---
name: update-docs
description: Actualizar documentación del proyecto (DEVLOG.md, ROADMAP.md, CLAUDE.md, docs/) con los cambios de la sesión actual, y luego hacer commit + push.
---

# Actualizar Documentación del Proyecto

Ejecuta estos pasos en orden:

## 1. Analizar cambios recientes

- `git log --oneline -5` — últimos commits
- `git diff` — cambios sin commitear
- Identificar qué se hizo esta sesión

## 2. Verificar migraciones de BD (si aplica)

Si se tocaron modelos o la BD:
- Verificar archivo de migración creado
- Verificar schema actualizado
- Si falta algo, crearlo AHORA

## 3. Actualizar DEVLOG.md

Nueva entrada AL INICIO con formato:

```markdown
## [Fecha] — [Resumen breve]

### `<hash>` <commit message>
**Archivos**: `file1.py`, `file2.py`

**Cambios clave**:
1. **Nombre** — Descripción breve
2. ...

**Bugs resueltos**: (si aplica)
```

## 4. Actualizar ROADMAP.md

- Marcar `[x]` tareas completadas
- Añadir nuevas ideas si surgieron
- Mover prioridades si cambió algo

## 5. Actualizar CLAUDE.md (solo si necesario)

**REGLA: CLAUDE.md debe mantenerse por debajo de 250 líneas.**

Solo actualizar si:
- Nuevo módulo/componente
- Cambió flujo importante
- Cambió arquitectura
- Nuevo endpoint crítico

Si el detalle es extenso → ponerlo en `docs/`, NO en CLAUDE.md.

## 6. Actualizar docs/ (si aplica)

Si se cambiaron enums, tipos, testing, o infraestructura → actualizar los docs de referencia correspondientes.

## 7. Commit y Push

```bash
git add DEVLOG.md ROADMAP.md
# Solo si se tocaron:
git add CLAUDE.md docs/
git commit -m "docs: update DEVLOG + ROADMAP with session changes"
git push
```

## Formato
- Sé COMPACTO. Bullet points cortos.
- No repitas lo que ya está en el commit message.
- Incluye datos técnicos relevantes (archivos, funciones).
- Si hubo bugs, documenta error Y solución.
