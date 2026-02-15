#!/bin/bash
# ============================================
# [PROJECT_NAME] - Development Helper Script
# ============================================
# Shortcut para docker compose en desarrollo.
# Uso: bash dev.sh up / bash dev.sh down / bash dev.sh logs

DC="docker compose -f docker-compose.yml -f docker-compose.dev.yml --env-file .env.dev"

case "$1" in
    up)      $DC up -d ;;
    down)    $DC down ;;
    build)   $DC build ${2:-} && $DC up -d ${2:-} ;;
    logs)    $DC logs ${2:-api} --tail ${3:-50} -f ;;
    restart) $DC restart ${2:-api} ;;
    ps)      $DC ps ;;
    *)
        echo "Uso: bash dev.sh [up|down|build|logs|restart|ps] [servicio]"
        echo ""
        echo "  up              Levantar todo"
        echo "  down            Parar todo"
        echo "  build [svc]     Rebuild + restart (default: todo)"
        echo "  logs [svc] [N]  Ver logs (default: api, 50 lineas)"
        echo "  restart [svc]   Reiniciar servicio (default: api)"
        echo "  ps              Estado de contenedores"
        ;;
esac
