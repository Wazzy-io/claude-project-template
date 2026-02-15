---
name: daily
description: Resumen diario del proyecto y planificación. Lee DEVLOG.md, ROADMAP.md, git log, GitHub Issues y Docker para dar panorama completo y sugerir plan del día.
---

# Resumen Diario y Planificación

## Paso 1: Recolectar información

Lee todo en paralelo:

### Local
- **DEVLOG.md** — Últimas 2-3 entradas
- **ROADMAP.md** — Tareas con estado y prioridad
- **Git log** — Últimos 10 commits (`git log --oneline -10`)
- **Git status** — Cambios sin commitear
- **Docker** — `docker compose ps` (si aplica)

### GitHub (si hay acceso)
```bash
gh issue list --state open --json number,title,labels --limit 20
gh pr list --state open --json number,title
```

## Paso 2: Generar resumen

```
═══════════════════════════════════════════
  DAILY — [proyecto] — [fecha]
═══════════════════════════════════════════

ÚLTIMA SESIÓN (qué se hizo):
  - <commit> <descripción>
  - <commit> <descripción>

ESTADO ACTUAL:
  Docker:      service1 (running), service2 (healthy)
  Branch:      main (limpio / X archivos sin commit)
  Último push: hace X horas/días

BUGS ABIERTOS:
  - <bug 1>
  (o "Ninguno")

ROADMAP — PROGRESO:
  ████████████░░░░░░░░ 55% completado
  Completado: X tareas
  Pendiente:  Y tareas (Z alta, W media)

PRIORIDAD ALTA PENDIENTE:
  1. <tarea> — <contexto breve>
  2. <tarea>
  3. <tarea>

═══════════════════════════════════════════
  PLAN SUGERIDO PARA HOY
═══════════════════════════════════════════

  1. <tarea más prioritaria y por qué>
  2. <siguiente tarea lógica>
  3. <si sobra tiempo>

  Dependencias: <si alguna tarea depende de otra>
  Bloqueadores: <si algo impide avanzar>

═══════════════════════════════════════════
```

## Paso 3: Esperar instrucciones

Preguntar:

> "¿Empezamos con la tarea 1, prefieres otra cosa, o quieres más detalle?"

No empezar a trabajar sin confirmación del usuario.

## Notas
- Si no hay `gh` CLI → omitir GitHub
- Si no hay Docker → omitir Docker
- Si DEVLOG o ROADMAP no existen → avisar que deberían crearse
- Plan sugerido: prioridad ROADMAP > bugs abiertos > mejoras técnicas
