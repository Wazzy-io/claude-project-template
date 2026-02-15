# Claude Project Template

Template reutilizable para proyectos web con **Claude Code + Docker**.

Stack incluido: FastAPI + PostgreSQL 16 + Redis 7 + Traefik SSL + GitHub Actions CI/CD.

---

## Quick Start

1. Click **"Use this template"** arriba → crear nuevo repo
2. Clonar: `git clone https://github.com/tu-org/tu-proyecto.git`
3. Abrir Claude Code: `claude`
4. Ejecutar: `/bootstrap`
5. Claude te pregunta los datos, personaliza todo, levanta Docker, y verifica
6. `/start-session` → a trabajar

---

## Que incluye

### Infraestructura Docker

| Archivo | Que hace |
|---------|----------|
| `docker-compose.yml` | Base: PostgreSQL + Redis + FastAPI API |
| `docker-compose.dev.yml` | Dev: puertos, PgAdmin, hot-reload |
| `docker-compose.prod.yml` | Prod: Traefik SSL + redes aisladas |
| `.env.dev.example` | Variables de desarrollo |
| `.env.prod.example` | Variables de produccion |
| `backend/Dockerfile` | Python 3.11 + FastAPI + uvicorn |
| `frontend/Dockerfile` | Multi-stage: Node build → Nginx |
| `frontend/nginx.conf` | SPA routing + gzip + cache |

### Deploy + CI/CD

| Archivo | Que hace |
|---------|----------|
| `prod.sh` | Helper SSH: status, logs, sql, deploy, restart |
| `dev.sh` | Shortcut: `bash dev.sh up/down/logs` |
| `.github/workflows/deploy.yml` | Auto-deploy on push al VPS |

### Claude Code Skills (10)

| Skill | Para que |
|-------|----------|
| `/bootstrap` | **Primera vez**: personalizar template |
| `/start-session` | Cargar contexto al inicio |
| `/daily` | Resumen diario + plan |
| `/debug-systematic` | Debug con root cause analysis |
| `/docker-manage` | Operar Docker (dev/prod) |
| `/verify-and-ship` | Verificar + commit + push |
| `/update-docs` | Actualizar DEVLOG + ROADMAP |
| `/project-sync` | Sincronizar a GitHub Projects / Notion |
| `/diagram` | Generar diagramas Mermaid |
| `/deploy-vps` | Deploy a VPS desde cero |

### Documentacion

| Archivo | Para que |
|---------|----------|
| `CLAUDE.md` | Instrucciones para Claude (< 250 lineas) |
| `DEVLOG.md` | Historial de desarrollo |
| `ROADMAP.md` | Plan de desarrollo |
| `BOOTSTRAP.md` | Guia paso a paso para personalizar |
| `docs/` | Documentacion de referencia |

---

## Arquitectura

### Desarrollo (local)
```
localhost:8000  →  API (FastAPI + hot-reload)
localhost:5432  →  PostgreSQL
localhost:6379  →  Redis
localhost:5050  →  PgAdmin
localhost:3001  →  Frontend (Vite dev)
```

### Produccion (VPS)
```
                ┌──────────────────┐
                │ Traefik :80/:443 │
                │ (SSL automatico) │
                └────┬────┬────────┘
                     │    │
          ┌──────────┘    └──────────┐
          ▼                          ▼
  ┌───────────────┐       ┌─────────────────┐
  │ api.domain    │       │ app.domain      │
  │ (FastAPI)     │       │ (nginx + SPA)   │
  └───────┬───────┘       └─────────────────┘
          │
  ┌───────┴───────┐
  │ Red interna   │
  │ PostgreSQL    │
  │ Redis         │
  └───────────────┘
```

---

## Comandos utiles

### Desarrollo
```bash
bash dev.sh up          # Levantar todo
bash dev.sh down        # Parar todo
bash dev.sh logs        # Ver logs API
bash dev.sh build api   # Rebuild + restart API
bash dev.sh ps          # Estado contenedores
```

### Produccion
```bash
bash prod.sh status     # Estado Docker + health check
bash prod.sh logs       # Ultimos logs
bash prod.sh logs-err   # Solo errores
bash prod.sh health     # Health check profundo
bash prod.sh deploy     # Deploy manual
bash prod.sh sql "..."  # Consulta BD
bash prod.sh ssh        # Terminal en VPS
```

### Flujo de trabajo con Claude Code
```
/daily → trabajo → /debug-systematic (si bugs) → /verify-and-ship → /update-docs
```

---

## Personalizacion

Ejecuta `/bootstrap` y Claude hace todo por ti. Ver **[BOOTSTRAP.md](BOOTSTRAP.md)** para la guia manual.

---

## Requisitos

- Docker + Docker Compose
- Claude Code CLI (`npm install -g @anthropic-ai/claude-code`)
- Git + GitHub CLI (`gh`)
- VPS con Ubuntu 22.04+ (para produccion)
