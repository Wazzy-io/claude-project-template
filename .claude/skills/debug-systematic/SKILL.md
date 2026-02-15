---
name: debug-systematic
description: Debugging sistemático con root cause analysis. Usar cuando hay un bug, error, o comportamiento inesperado. NUNCA tocar código antes de investigar la causa raíz.
---

# Debugging Sistemático

**REGLA DE ORO: NO toques código hasta completar las Fases 1-2.**

---

## Fase 0: Cargar referencia

Si el proyecto tiene docs de referencia (testing, infrastructure), consultarlos primero.

## Fase 1: Reproducir y Observar

Antes de hacer NADA, reproduce el error:

1. **Ejecutar** el comando/endpoint/test que falla
2. **Leer** el error completo (stack trace, logs, response)
3. **Capturar** el output exacto (no parafrasear)

```bash
# Ejemplos de reproducción
docker compose logs <service> --tail 50
curl -s http://localhost:<port>/api/...
docker compose exec postgres psql -U ... -c "SELECT ..."
```

Si NO puedes reproducir el error, PARA. Pregunta al usuario por más contexto.

## Fase 2: Trazar la Causa Raíz

Sigue el error HACIA ATRÁS desde donde explota hasta donde se origina:

1. **Localizar** la línea exacta del error (archivo:linea)
2. **Leer** la función completa donde ocurre
3. **Trazar** de dónde vienen los datos que causan el error
4. **Identificar** el punto exacto donde los datos se corrompen o faltan

### Preguntas obligatorias

- ¿Esto funcionaba antes? ¿Qué cambió?
- ¿Hay otros paths que llegan al mismo código? ¿Fallan también?
- ¿El tipo de dato es el esperado?
- ¿Hay un caso edge que no se maneja? (null, empty, lista con 1 item vs varios)

### Anti-patrones (NO hacer)

| Tentación | Por qué está mal | Qué hacer en vez |
|-----------|-------------------|-------------------|
| "Ya sé qué es, lo arreglo rápido" | Probablemente no sabes | Traza el root cause primero |
| "Añado un try/except" | Ocultas el error | Arregla la causa, no el síntoma |
| "Cambio el tipo y ya" | Puede romper otros paths | Entiende POR QUÉ el tipo es incorrecto |

## Fase 3: Hipótesis Única

Formula UNA hipótesis específica antes de tocar código:

```
HIPÓTESIS: [El error ocurre porque X devuelve Y cuando debería devolver Z,
            debido a que en la línea N del archivo F no se maneja el caso C]
```

- Si no puedes formular una hipótesis clara, vuelve a Fase 2

## Fase 4: Fix + Verificar

1. **Cambiar** el mínimo código necesario para arreglar la causa raíz
2. **Reproducir** el escenario original — debe funcionar ahora
3. **Verificar** que no rompiste otros paths

### Regla de los 3 fixes

Si ya llevas 3 fixes para el mismo problema y sigue fallando:
- PARA
- El problema es más profundo de lo que parece
- Re-lee el código completo del módulo afectado

## Formato de Reporte al Usuario

```
BUG: [descripción corta]
CAUSA RAÍZ: [explicación técnica precisa]
FIX: [qué se cambió y por qué]
VERIFICACIÓN: [qué se ejecutó para confirmar]
```
