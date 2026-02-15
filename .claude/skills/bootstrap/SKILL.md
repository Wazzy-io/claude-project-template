---
name: bootstrap
description: Personalizar este template para un nuevo proyecto. Reemplaza placeholders, configura Docker, levanta entorno dev. Ejecutar UNA SOLA VEZ al crear el proyecto.
---

# Bootstrap — Personalizar Template

> Ejecutar UNA SOLA VEZ cuando se crea un proyecto nuevo desde el template.
> Despues de esto, usar `/start-session` para sesiones normales.

---

## Paso 1: Preguntar datos al usuario

Pregunta al usuario los siguientes datos (usa AskUserQuestion o pregunta directamente):

1. **Nombre del proyecto** — Nombre corto (ej: "wazzy", "miapp")
2. **Nombre completo** — Para titulos (ej: "WAZZY 3.0", "Mi App de Reservas")
3. **Descripcion** — 2-3 lineas de que hace el proyecto
4. **Dominio** — Si ya tiene (ej: "miapp.com") o "todavia no tengo"
5. **Alias SSH del VPS** — Si ya tiene (ej: "miapp-vps") o "todavia no tengo VPS"

---

## Paso 2: Reemplazar placeholders en TODOS los archivos

Buscar y reemplazar en todos los archivos del proyecto:

| Buscar | Reemplazar con |
|--------|----------------|
| `[PROJECT_NAME]` | Nombre completo (ej: "Mi App de Reservas") |
| `[PROJECT]` | Nombre corto en minusculas (ej: "miapp") |
| `[DESCRIPCION]` | Descripcion del proyecto |
| `myproject` | Nombre corto (en .env.example, docker-compose, etc.) |
| `myproject.com` | Dominio real (si tiene) |
| `myproject-vps` | Alias SSH real (si tiene) |

### Archivos a modificar:

```
docker-compose.yml
docker-compose.dev.yml
docker-compose.prod.yml
.env.dev.example
.env.prod.example
prod.sh
dev.sh
.github/workflows/deploy.yml
backend/app/main.py
CLAUDE.md                    ← Rellenar TODAS las secciones [PLACEHOLDER]
DEVLOG.md                    ← Cambiar nombre del proyecto
ROADMAP.md                   ← Cambiar nombre del proyecto
README.md                    ← Reescribir con info del proyecto real
```

---

## Paso 3: Personalizar CLAUDE.md

Rellenar CADA seccion marcada con `[PLACEHOLDER]`:

1. **Resumen del Sistema** — Que hace, stack, estructura
2. **Arquitectura** — Flujo de datos, modulos principales
3. **Quick Start** — Comandos para levantar (ya estan en el template, adaptar)
4. **Archivos Clave** — Los mas importantes del proyecto
5. **Equipo y Tablero** — GitHub Projects, Notion, tipo de equipo
6. **Datos del Proyecto** — URLs, datos de test, gotchas

**Mantener CLAUDE.md bajo 250 lineas.**

---

## Paso 4: Configurar entorno de desarrollo

```bash
# 1. Crear .env.dev
cp .env.dev.example .env.dev

# 2. Levantar Docker
bash dev.sh up

# 3. Verificar
bash dev.sh ps
curl http://localhost:8000/api/health
```

Si el usuario tiene API keys (Anthropic, OpenAI, etc.), pedirle que las ponga en `.env.dev` manualmente.

---

## Paso 5: Primer commit

```bash
git add -A
git commit -m "bootstrap: personalizar template para [NOMBRE_PROYECTO]"
git push
```

---

## Paso 6: Resumen final

Mostrar al usuario:

```
BOOTSTRAP COMPLETADO

Proyecto: [nombre]
Docker: corriendo (api, postgres, redis, pgadmin)
API: http://localhost:8000/api/health → healthy

Accesos:
  API:     http://localhost:8000
  PgAdmin: http://localhost:5050

Archivos personalizados: [lista]

SIGUIENTE PASO:
  Para sesiones normales usa: /start-session
  Para deploy a VPS: /deploy-vps setup

Skills disponibles:
  /daily /debug-systematic /docker-manage /verify-and-ship
  /update-docs /project-sync /diagram /deploy-vps
```

---

## Notas

- Este skill se ejecuta UNA SOLA VEZ. Despues no se necesita mas.
- Si el usuario no tiene dominio o VPS, dejar los placeholders genericos — se actualizan cuando los tenga.
- NO borrar BOOTSTRAP.md del repo — sirve como referencia futura.
