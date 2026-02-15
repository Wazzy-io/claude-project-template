---
name: start-session
description: Cargar contexto completo del proyecto al inicio de una sesión. Lee CLAUDE.md, DEVLOG.md y ROADMAP.md, revisa git log y estado de Docker, y presenta un resumen compacto.
---

# Iniciar Sesión de Trabajo

Ejecuta estos pasos en orden para tener contexto completo:

## 1. Leer documentación del proyecto

Lee estos archivos en orden:

1. **CLAUDE.md** — Arquitectura, instrucciones, reglas
2. **DEVLOG.md** — Historial de cambios recientes, bugs conocidos
3. **ROADMAP.md** — Plan futuro y prioridades
4. **docs/** — Solo lo relevante para la sesión (testing, infrastructure, etc.)

## 2. Revisar estado actual

```bash
# Últimos commits
git log --oneline -5

# Cambios sin commitear
git status

# Estado de Docker (si aplica)
docker compose ps
```

## 3. Revisar estado de la base de datos (si aplica)

```bash
# Migraciones pendientes
ls backend/*/db/migrations/*.sql 2>/dev/null || ls migrations/*.sql 2>/dev/null

# Tablas actuales
docker compose exec -T postgres psql -U $DB_USER -d $DB_NAME -c "\dt"
```

## 4. Presentar resumen compacto al usuario

```
[PROYECTO] — Sesión iniciada

Último commit: `abc1234` mensaje del commit
Docker: servicio1 (running), servicio2 (healthy)
Cambios pendientes: X archivos modificados

Bugs abiertos:
- Bug 1

Próxima tarea sugerida (ROADMAP):
- [ ] Tarea de prioridad alta

¿Qué quieres hacer hoy?
```
