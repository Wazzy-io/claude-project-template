---
name: project-sync
description: Sincronizar estado del proyecto al tablero del equipo. Lee DEVLOG.md, ROADMAP.md y git log, traduce a lenguaje apropiado, y actualiza GitHub Projects (técnico) y/o Notion (no técnico).
---

# Sincronizar Proyecto al Tablero del Equipo

## Paso 0: Detectar destino

Revisar `CLAUDE.md` sección "Equipo y Tablero" para saber el destino. Si no está definido, preguntar:

| Si el equipo... | Destino | Requisito |
|---|---|---|
| Tiene GitHub, es técnico | **GitHub Projects** | `gh` CLI |
| NO tiene GitHub, no es técnico | **Notion** | MCP Notion |
| Mixto | **Ambos** | `gh` CLI + MCP Notion |

---

## Paso 1: Leer estado local

En paralelo:

1. **DEVLOG.md** — Última entrada: commits, cambios, bugs
2. **ROADMAP.md** — Tareas `[x]` completadas y `[ ]` pendientes
3. **Git log** — Últimos 10 commits

---

## Paso 2: Traducir según audiencia

### Para equipo NO técnico (Notion)

| Técnico (DEVLOG/ROADMAP) | No técnico (Notion) |
|---|---|
| `fix(auth): handle expired tokens` | Se arregló un error de conexión |
| `feat: implement cancel flow` | Ahora se pueden cancelar citas |

**Reglas**:
- NUNCA mencionar: archivos, funciones, variables, Docker, API, endpoints
- SIEMPRE responder: ¿qué cambia para el usuario final o el negocio?

### Para equipo técnico (GitHub Projects)

Mantener lenguaje técnico. Añadir hash del commit y archivos afectados.

---

## Paso 3A: Sincronizar a Notion (equipo no técnico)

### Estructura de la página Notion

```
📋 [Proyecto] — Estado

  Última actualización: [fecha]

  📊 Progreso general
  ████████████░░░░░░░░ 55% completado

  ✅ Lo que ya funciona
  - Feature 1
  - Feature 2

  🔨 En lo que estamos trabajando
  | Tarea                    | Estado      | Prioridad |
  | Feature nueva            | Esta semana | Alta      |
  | Mejora X                 | Pendiente   | Media     |

  🐛 Problemas conocidos
  - (en lenguaje simple)

  📝 Últimas novedades ([fecha])
  - (en lenguaje simple)
```

### Actualizar via MCP Notion
1. Buscar página del proyecto
2. Actualizar "Últimas novedades"
3. Actualizar kanban
4. Actualizar barra de progreso

---

## Paso 3B: Sincronizar a GitHub Projects (equipo técnico)

### Cerrar issues completados
```bash
gh issue list --search "titulo" --state open --json number,title
gh issue close <number> --comment "Completado en commit <hash>."
```

### Crear issues nuevos
```bash
gh issue create --title "Título" --body "Desde ROADMAP.md — Prioridad: Alta" --label "enhancement"
```

### Actualizar progreso
```bash
gh issue comment <number> --body "Progreso (fecha): lo que se avanzó."
```

---

## Paso 4: Reportar al usuario

```
SINCRONIZADO → [DESTINO]
Novedades añadidas: X items
Tareas completadas: Y
Tareas nuevas: Z
Progreso: XX% → YY%
```
