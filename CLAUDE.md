# [NOMBRE DEL PROYECTO] — Instrucciones para Claude

> **Ver `DEVLOG.md`** para historial de cambios recientes y bugs conocidos.
> **Ver `ROADMAP.md`** para planes futuros y prioridades.

## Resumen del Sistema

[DESCRIPCIÓN: 2-3 líneas explicando qué hace el proyecto]

- **Backend**: [Framework + BD] (`/backend/` o `/src/`)
- **Frontend**: [Framework] (`/frontend/` o `/web/`)
- **Despliegue**: [Docker / Vercel / AWS / etc.]
- **CI/CD**: [GitHub Actions / GitLab CI / etc.]

---

## Arquitectura

```
[FLUJO PRINCIPAL: cómo se procesan los datos/requests]
Ejemplo: Usuario → API → Servicio → BD → Respuesta
```

| Módulo | Tipo | Ubicación | Responsabilidad |
|--------|------|-----------|-----------------|
| [Módulo 1] | [Tipo] | `path/to/module` | [Qué hace] |
| [Módulo 2] | [Tipo] | `path/to/module` | [Qué hace] |

---

## Quick Start

```bash
# Levantar el proyecto
[COMANDO PARA LEVANTAR]

# Verificar que funciona
[COMANDO DE HEALTH CHECK]

# Ejecutar tests
[COMANDO DE TESTS]
```

---

## Archivos Clave

| Archivo | Qué hace |
|---------|----------|
| `[path/to/main]` | Punto de entrada |
| `[path/to/config]` | Configuración |
| `[path/to/models]` | Modelos de datos |
| `[path/to/routes]` | Rutas/endpoints |

---

## Skills Disponibles

| Skill | Cuándo usarla |
|-------|---------------|
| `/start-session` | Al abrir sesión de trabajo |
| `/daily` | Inicio del día: panorama + plan sugerido |
| `/debug-systematic` | Cuando hay un bug o error |
| `/docker-manage` | Operar o diagnosticar Docker |
| `/verify-and-ship` | Verificar + commit + push |
| `/update-docs` | Fin de sesión: actualizar DEVLOG + ROADMAP |
| `/project-sync` | Sincronizar al tablero del equipo |
| `/diagram` | Generar diagramas Mermaid |
| `/deploy-vps` | Deploy Docker Compose a VPS desde cero |

### Flujo típico
```
/daily → trabajo → /debug-systematic (si bugs) → /verify-and-ship → /update-docs → /project-sync
```

---

## Equipo y Tablero

- **Tipo de equipo**: [Técnico / No técnico / Mixto]
- **Tablero técnico**: [GitHub Projects / Linear / etc.]
- **Tablero cliente**: [Notion / Trello / etc.] (pendiente configurar)

---

## Documentación de Referencia

El detalle técnico está en archivos separados:

- **`docs/[REFERENCIA].md`** — [Descripción]
- **`docs/[TESTING].md`** — [Descripción]
- **`docs/[INFRAESTRUCTURA].md`** — [Descripción]

---

## Reglas Importantes

### Documentación
Al finalizar sesión o cuando el usuario lo pida:
1. **`DEVLOG.md`** — Añadir entrada: commits, archivos, cambios, bugs
2. **`ROADMAP.md`** — Marcar `[x]` completado, añadir nuevas ideas
3. **`CLAUDE.md`** — Solo si cambia arquitectura o módulos nuevos
4. Commit + Push siempre

### Migraciones BD (si aplica)
Cada cambio a la BD requiere: (1) archivo de migración, (2) actualizar schema, (3) modelos coincidan.

### Archivos temporales
Todos en **`.tmp/`** (está en `.gitignore`). NUNCA crear archivos temporales fuera de `.tmp/`.

### Post-tarea
Al completar una tarea, proactivamente revisar DEVLOG (bugs pendientes) y ROADMAP (siguiente tarea) y presentar resumen compacto.

### CLAUDE.md — Regla de mantenimiento
Este archivo DEBE mantenerse por debajo de 250 líneas. Si necesitas añadir contenido:
- **Detalle técnico** → va en `docs/`
- **Workflows** → va en skills (`.claude/skills/`)
- **Aquí solo** → reglas críticas, arquitectura de alto nivel, datos esenciales
- Si al editar CLAUDE.md supera 250 líneas → compactar moviendo detalle a docs/

### Code style
- No sobre-ingeniería. Solo cambios pedidos.
- No añadir features, refactoring, o mejoras extra no solicitadas.
- No crear archivos innecesarios.

---

## Datos del Proyecto

### [Entorno de desarrollo]
- **URL local**: `http://localhost:[PORT]`
- **BD**: [tipo, user, database]

### [Datos de test]
- [Datos relevantes para testing]

### Gotchas
- [Gotcha 1: cosa que sorprende y hay que recordar]
- [Gotcha 2]
