---
name: verify-and-ship
description: Verificar que todo funciona antes de hacer commit y push. Ejecuta health checks, revisa logs, corre tests si existen, y solo entonces hace commit + push.
---

# Verificar y Enviar

**REGLA: NO digas "listo" ni hagas push sin ejecutar verificaciones AHORA MISMO.**

---

## Paso 1: Verificar que Docker está sano (si aplica)

```bash
docker compose ps
```

- Todos los servicios deben estar `Up` y `healthy`

## Paso 2: Verificar que el backend responde

```bash
curl -sf http://localhost:<PORT>/docs > /dev/null && echo "API OK" || echo "API FAIL"
```

## Paso 3: Revisar logs por errores

```bash
docker compose logs <service> --tail 30 2>&1 | grep -iE "error|exception|traceback|critical"
```

## Paso 4: Verificar migraciones de BD (si aplica)

Si durante esta sesión se tocaron modelos o la BD:

Checklist:
- [ ] Existe archivo de migración
- [ ] Schema actualizado
- [ ] Modelos coinciden con schema
- [ ] Migración aplicada en BD local

## Paso 5: Test rápido (si existe)

```bash
# Adaptar al proyecto
docker compose exec <service> pytest tests/ -x -q 2>&1 | tail -5
```

Si no hay tests, al menos verifica manualmente el flujo que tocaste.

## Paso 6: Git status y diff

```bash
git status
git diff --stat
```

Revisar:
- No hay archivos sensibles staged (.env, credentials, tokens)
- Los archivos modificados son los esperados
- No hay archivos gigantes o binarios innecesarios

## Paso 7: Commit

```bash
git add <archivos específicos>
git commit -m "<tipo>(<scope>): <descripción>"
```

Tipos: `feat`, `fix`, `refactor`, `docs`, `chore`, `test`

## Paso 8: Push

```bash
git push -u origin <branch-name>
```

## Paso 9: Resumen al usuario

```
VERIFICACIÓN COMPLETADA

Docker:     OK (servicios running)
Backend:    OK (API responding)
Logs:       OK (no errors)
Tests:      OK / SKIPPED (razón)

COMMIT: abc1234 feat(scope): mensaje
PUSH:   origin/branch-name OK

Notas para deploy (si aplica):
- Requiere: rebuild de imágenes
- Migración: path/to/migration.sql
- Variables nuevas: NUEVA_VAR
```
