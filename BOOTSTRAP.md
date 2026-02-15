# Guia de Bootstrap — Como personalizar este template

Este template te da una configuracion completa de **Claude Code + Docker** para cualquier proyecto web con FastAPI + PostgreSQL + Redis + Traefik SSL.

---

## Que incluye

### Infraestructura Docker
```
docker-compose.yml            # BASE: PostgreSQL 16, Redis 7, FastAPI API
docker-compose.dev.yml        # DEV: puertos, PgAdmin, hot-reload, Vite dev
docker-compose.prod.yml       # PROD: Traefik v3.6, SSL, redes aisladas
.env.dev.example              # Variables desarrollo (copiar a .env.dev)
.env.prod.example             # Variables produccion (copiar a .env.prod)
backend/Dockerfile            # Python 3.11 + FastAPI + uvicorn
backend/requirements.txt      # Dependencias Python
backend/app/main.py           # FastAPI app + health endpoints
backend/app/db/schema.sql     # Fuente de verdad BD (pg_init)
frontend/Dockerfile           # Multi-stage: Node build → Nginx serve
frontend/Dockerfile.dev       # Vite dev server con HMR
frontend/nginx.conf           # SPA routing + gzip + cache
prod.sh                       # Helper SSH para operar VPS
dev.sh                        # Shortcut para docker compose dev
.github/workflows/deploy.yml  # CI/CD: push → auto-deploy al VPS
```

### Claude Code Skills (9)
| Skill | Para que |
|-------|----------|
| `/start-session` | Cargar contexto al inicio |
| `/daily` | Resumen diario + plan |
| `/debug-systematic` | Debug con root cause analysis |
| `/docker-manage` | Operar Docker (dev/prod) |
| `/verify-and-ship` | Verificar + commit + push |
| `/update-docs` | Actualizar DEVLOG + ROADMAP |
| `/project-sync` | Sincronizar a GitHub Projects / Notion |
| `/diagram` | Generar diagramas Mermaid |
| `/deploy-vps` | Deploy a VPS desde cero |

### Documentos
| Archivo | Para que |
|---------|----------|
| `CLAUDE.md` | Instrucciones para Claude (< 250 lineas) |
| `DEVLOG.md` | Historial de desarrollo |
| `ROADMAP.md` | Plan de desarrollo |
| `docs/` | Documentacion de referencia |
| `.tmp/` | Archivos temporales (gitignored) |

---

## Paso 1: Copiar al nuevo proyecto

```bash
# Opcion A: "Use this template" en GitHub → ya tienes todo
git clone https://github.com/tu-org/nuevo-proyecto.git
cd nuevo-proyecto

# Opcion B: Copiar a repo existente
cp -r template/* tu-proyecto/
cp -r template/.* tu-proyecto/   # Incluir .claude, .github, .gitignore
cd tu-proyecto
```

## Paso 2: Buscar y reemplazar placeholders

Busca `[PROJECT]` y `[PROJECT_NAME]` en TODOS los archivos y reemplaza:

| Archivo | Que cambiar |
|---------|-------------|
| `docker-compose.yml` | Nombre del proyecto, schema.sql path |
| `.env.dev.example` | `COMPOSE_PROJECT_NAME`, `DB_NAME`, `DB_USER` |
| `.env.prod.example` | Lo mismo + `DOMAIN`, passwords seguros |
| `prod.sh` | Alias SSH (`VPS`), token env var, `APP_DIR` |
| `deploy.yml` | `APP_DIR` en el VPS |
| `backend/app/main.py` | Titulo de la app |
| `CLAUDE.md` | Todas las secciones `[PLACEHOLDER]` |
| `DEVLOG.md` | Nombre del proyecto |

## Paso 3: Levantar entorno de desarrollo

```bash
# 1. Crear .env.dev
cp .env.dev.example .env.dev
# Editar con tus API keys, passwords, etc.

# 2. Levantar Docker
bash dev.sh up

# 3. Verificar
bash dev.sh ps                          # Contenedores corriendo
curl http://localhost:8000/api/health   # API responde → {"status":"healthy"}

# Accesos:
# API:     http://localhost:8000
# PgAdmin: http://localhost:5050 (admin@project.com / admin)
```

## Paso 4: Personalizar CLAUDE.md

Abre `CLAUDE.md` y rellena:
1. **Resumen del Sistema** — Que hace tu proyecto
2. **Arquitectura** — Modulos y flujo de datos
3. **Quick Start** — Comandos para levantar y testear
4. **Archivos Clave** — Los archivos mas importantes
5. **Datos del Proyecto** — URLs, credenciales de test, gotchas

**IMPORTANTE**: Mantener CLAUDE.md bajo 250 lineas. Mover detalle a `docs/`.

## Paso 5: Desarrollar tu backend

```
backend/
├── Dockerfile
├── requirements.txt          # Agregar dependencias aqui
└── app/
    ├── __init__.py
    ├── main.py               # FastAPI app + health endpoints
    ├── api/                   # Tus endpoints
    └── db/
        ├── schema.sql         # Fuente de verdad de la BD
        └── migrations/        # Migraciones incrementales
```

**Ciclo de BD**: Cada cambio requiere:
1. Migracion en `migrations/YYYY-MM-DD_descripcion.sql`
2. Actualizar `schema.sql` (estado final)
3. Aplicar: `docker compose exec -T postgres psql -U user -d db < backend/app/db/migrations/archivo.sql`

## Paso 6: Frontend (cuando lo necesites)

1. Descomentar servicio `admin` en `docker-compose.dev.yml` y `docker-compose.prod.yml`
2. Crear tu app en `frontend/` (Vue, React, etc.)
3. Adaptar `frontend/nginx.conf` si es necesario

## Paso 7: Deploy a produccion

### 7.1 Preparar VPS
```bash
/deploy-vps setup
# Instala Docker, configura firewall, crea usuario deploy
```

### 7.2 SSH
```bash
# Crear clave
ssh-keygen -t ed25519 -C "deploy@myproject" -f ~/.ssh/id_ed25519_myproject -N ""
ssh-copy-id -i ~/.ssh/id_ed25519_myproject.pub deploy@VPS_IP

# Alias en ~/.ssh/config
# Host myproject-vps
#     HostName VPS_IP
#     User deploy
#     IdentityFile ~/.ssh/id_ed25519_myproject
```

### 7.3 Primer deploy
```bash
# .env.prod en el VPS
scp .env.prod.example myproject-vps:~/apps/myproject/.env.prod
# Editar con valores reales

# Deploy
/deploy-vps deploy
# O: bash prod.sh deploy
```

### 7.4 Dominio + SSL
1. DNS A record → IP del VPS
2. `DOMAIN=tudominio.com` en `.env.prod`
3. Restart → Traefik genera SSL automaticamente

### 7.5 CI/CD (GitHub Actions)
```bash
# Clave SSH para Actions
ssh-keygen -t ed25519 -C "actions@myproject" -f ~/.ssh/id_ed25519_myproject_actions -N ""
ssh-copy-id -i ~/.ssh/id_ed25519_myproject_actions.pub deploy@VPS_IP

# Secrets en GitHub
gh secret set VPS_HOST --repo tu-org/tu-repo
gh secret set VPS_USER --repo tu-org/tu-repo
gh secret set VPS_SSH_KEY --repo tu-org/tu-repo < ~/.ssh/id_ed25519_myproject_actions
```
Cada push a `main` → deploy automatico (~30-60s).

## Paso 8: Operar produccion

```bash
bash prod.sh status        # Estado Docker + health check
bash prod.sh logs          # Ultimos logs
bash prod.sh logs-err      # Solo errores
bash prod.sh health        # Health check profundo
bash prod.sh sql "SELECT * FROM users LIMIT 5"
bash prod.sh restart       # Reiniciar API
bash prod.sh deploy        # Deploy manual
bash prod.sh ssh           # Terminal en el VPS
```

---

## Arquitectura Docker

### Desarrollo
```
localhost:8000  →  API (FastAPI + hot-reload)
localhost:5432  →  PostgreSQL
localhost:6379  →  Redis
localhost:5050  →  PgAdmin
localhost:3001  →  Frontend (Vite dev)
```

### Produccion
```
                    ┌─────────────────────┐
                    │  Traefik :80/:443   │
                    │  (SSL automatico)   │
                    └─────┬─────┬─────────┘
                          │     │
              ┌───────────┘     └───────────┐
              ▼                             ▼
    ┌─────────────────┐          ┌──────────────────┐
    │ api.domain.com  │          │ app.domain.com   │
    │ (FastAPI)       │          │ (nginx + SPA)    │
    └────────┬────────┘          └──────────────────┘
             │
    ┌────────┴────────┐
    │  Red interna    │
    │  (sin acceso    │
    │   externo)      │
    │  PostgreSQL     │
    │  Redis          │
    └─────────────────┘
```

---

## Tips

1. **Los .env nunca se commitean** — Solo `.example` van al repo
2. **schema.sql + migraciones** — schema.sql para deploys nuevos, migraciones para existentes
3. **Traefik v3.6+** — Versiones anteriores incompatibles con Docker 29
4. **`docker compose restart` NO recarga env** — Usar `up --force-recreate`
5. **prod.sh funciona via SSH** — No necesitas estar en el VPS
6. **CLAUDE.md < 250 lineas** — Detalle va en `docs/`
7. **Flujo de trabajo**: `/daily → trabajo → /debug-systematic → /verify-and-ship → /update-docs`
