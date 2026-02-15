#!/bin/bash
# ============================================
# [PROJECT_NAME] - Production Helper Script
# ============================================
# Ejecuta operaciones en el VPS de produccion via SSH.
# Usado por Claude Code y el desarrollador desde local.
#
# REQUISITOS:
#   1. SSH configurado en ~/.ssh/config con alias "[PROJECT]-vps"
#   2. DEBUG_API_TOKEN configurado (mismo valor que en .env.prod del VPS)
#
# CONFIGURACION:
#   Edita estas variables antes del primer uso:
VPS="[PROJECT]-vps"                          # Alias SSH (definido en ~/.ssh/config)
DEBUG_TOKEN="${[PROJECT]_DEBUG_TOKEN:-}"      # Token de debug API (set como env var)
APP_DIR="~/apps/[PROJECT]"                   # Directorio del proyecto en el VPS
#
# USO:
#   bash prod.sh status          Ver estado de Docker + health check
#   bash prod.sh health          Health check profundo (DB, Redis)
#   bash prod.sh logs [N]        Ultimas N lineas de logs API (default: 50)
#   bash prod.sh logs-err [N]    Solo errores de los ultimos N logs
#   bash prod.sh logs-all [N]    Logs de TODOS los servicios
#   bash prod.sh sql "QUERY"     Ejecutar SELECT en la BD de produccion
#   bash prod.sh tables          Conteo de filas por tabla
#   bash prod.sh deploy          Deploy manual (git pull + rebuild + up)
#   bash prod.sh restart [SVC]   Reiniciar servicio (default: api)
#   bash prod.sh migrate FILE    Aplicar migracion SQL
#   bash prod.sh ps              Docker compose ps (estado contenedores)
#   bash prod.sh ssh             Abrir sesion SSH interactiva
#   bash prod.sh ssh-cmd "CMD"   Ejecutar comando SSH arbitrario
# ============================================

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Comando docker compose en el VPS
DC="cd $APP_DIR && docker compose -f docker-compose.yml -f docker-compose.prod.yml --env-file .env.prod"

# API base URL (localhost en el VPS, accesible via SSH)
API="http://localhost:8000"

# Helper para curl con token de debug
debug_curl() {
    if [ -z "$DEBUG_TOKEN" ]; then
        echo -e "${RED}ERROR: DEBUG_TOKEN no configurado${NC}"
        echo "Ejecuta: export [PROJECT]_DEBUG_TOKEN=tu_token_aqui"
        echo "O anadelo a tu .bashrc / .zshrc"
        exit 1
    fi
    ssh "$VPS" "curl -s -H 'X-Debug-Token: $DEBUG_TOKEN' $@"
}

case "$1" in

    # ---- Estado y salud ----
    status)
        echo -e "${BLUE}=== Docker Status ===${NC}"
        ssh "$VPS" "$DC ps"
        echo ""
        echo -e "${BLUE}=== Health Check ===${NC}"
        ssh "$VPS" "curl -s $API/api/health/deep 2>/dev/null" | python3 -m json.tool 2>/dev/null || echo -e "${RED}API no responde${NC}"
        ;;

    health)
        ssh "$VPS" "curl -s $API/api/health/deep 2>/dev/null" | python3 -m json.tool 2>/dev/null || echo -e "${RED}API no responde${NC}"
        ;;

    ps)
        ssh "$VPS" "$DC ps"
        ;;

    # ---- Logs ----
    logs)
        LINES=${2:-50}
        ssh "$VPS" "$DC logs api --tail $LINES --no-log-prefix 2>&1"
        ;;

    logs-err)
        LINES=${2:-200}
        echo -e "${YELLOW}Buscando errores en ultimas $LINES lineas...${NC}"
        ssh "$VPS" "$DC logs api --tail $LINES --no-log-prefix 2>&1" | grep -i -E "error|exception|traceback|critical|failed" || echo -e "${GREEN}Sin errores encontrados${NC}"
        ;;

    logs-all)
        LINES=${2:-30}
        ssh "$VPS" "$DC logs --tail $LINES 2>&1"
        ;;

    # ---- Base de datos ----
    sql)
        if [ -z "$2" ]; then
            echo -e "${RED}Uso: bash prod.sh sql \"SELECT * FROM users LIMIT 5\"${NC}"
            exit 1
        fi
        SQL_ESCAPED=$(echo "$2" | sed 's/"/\\"/g')
        debug_curl "-H 'Content-Type: application/json' -X POST -d '{\"sql\": \"$SQL_ESCAPED\"}' $API/api/debug/query" | python3 -m json.tool 2>/dev/null
        ;;

    tables)
        debug_curl "$API/api/debug/tables/counts" | python3 -m json.tool 2>/dev/null
        ;;

    # ---- Deploy y restart ----
    deploy)
        echo -e "${BLUE}=== Deploying to production ===${NC}"
        echo -e "${YELLOW}1/4 Git pull...${NC}"
        ssh "$VPS" "cd $APP_DIR && git pull origin main"
        echo -e "${YELLOW}2/4 Building...${NC}"
        ssh "$VPS" "$DC build"
        echo -e "${YELLOW}3/4 Starting...${NC}"
        ssh "$VPS" "$DC up -d"
        echo -e "${YELLOW}4/4 Health check (esperando 10s)...${NC}"
        sleep 10
        HEALTH=$(ssh "$VPS" "curl -s $API/api/health/deep 2>/dev/null")
        if echo "$HEALTH" | grep -q '"healthy"'; then
            echo -e "${GREEN}Deploy exitoso! API healthy.${NC}"
        else
            echo -e "${RED}ATENCION: API puede no estar saludable${NC}"
            echo "$HEALTH" | python3 -m json.tool 2>/dev/null
        fi
        ;;

    restart)
        SVC=${2:-api}
        echo -e "${YELLOW}Reiniciando $SVC...${NC}"
        ssh "$VPS" "$DC restart $SVC"
        if [ "$SVC" = "api" ]; then
            sleep 5
            ssh "$VPS" "curl -sf $API/api/health" > /dev/null 2>&1 && echo -e "${GREEN}API healthy${NC}" || echo -e "${RED}API no responde${NC}"
        fi
        ;;

    # ---- Migraciones ----
    migrate)
        if [ -z "$2" ]; then
            echo -e "${RED}Uso: bash prod.sh migrate 2026-02-15_add_new_column.sql${NC}"
            echo "Migraciones disponibles:"
            ssh "$VPS" "ls $APP_DIR/backend/app/db/migrations/*.sql 2>/dev/null | sort"
            exit 1
        fi
        echo -e "${YELLOW}Aplicando migracion: $2${NC}"
        ssh "$VPS" "$DC exec -T postgres psql -U \$(grep DB_USER $APP_DIR/.env.prod | cut -d= -f2) -d \$(grep DB_NAME $APP_DIR/.env.prod | cut -d= -f2) < $APP_DIR/backend/app/db/migrations/$2"
        echo -e "${GREEN}Migracion aplicada.${NC}"
        ;;

    # ---- SSH directo ----
    ssh)
        ssh "$VPS"
        ;;

    ssh-cmd)
        if [ -z "$2" ]; then
            echo -e "${RED}Uso: bash prod.sh ssh-cmd \"comando\"${NC}"
            exit 1
        fi
        ssh "$VPS" "$2"
        ;;

    # ---- Ayuda ----
    *)
        echo -e "${BLUE}[PROJECT_NAME] - Production Helper${NC}"
        echo ""
        echo "Estado:"
        echo "  bash prod.sh status          Estado Docker + health check"
        echo "  bash prod.sh health          Health check profundo"
        echo "  bash prod.sh ps              Estado de contenedores"
        echo ""
        echo "Logs:"
        echo "  bash prod.sh logs [N]        Ultimas N lineas API (default: 50)"
        echo "  bash prod.sh logs-err [N]    Solo errores"
        echo "  bash prod.sh logs-all [N]    Todos los servicios"
        echo ""
        echo "Base de datos:"
        echo "  bash prod.sh sql \"QUERY\"     Ejecutar SELECT"
        echo "  bash prod.sh tables          Conteo de filas"
        echo ""
        echo "Deploy:"
        echo "  bash prod.sh deploy          Git pull + rebuild + restart"
        echo "  bash prod.sh restart [SVC]   Reiniciar servicio (default: api)"
        echo "  bash prod.sh migrate FILE    Aplicar migracion SQL"
        echo ""
        echo "SSH:"
        echo "  bash prod.sh ssh             Sesion interactiva"
        echo "  bash prod.sh ssh-cmd \"CMD\"   Ejecutar comando"
        echo ""
        echo -e "${YELLOW}Config: export [PROJECT]_DEBUG_TOKEN=tu_token${NC}"
        ;;
esac
