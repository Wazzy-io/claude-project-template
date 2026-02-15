---
name: docker-manage
description: Gestionar stack Docker del proyecto. Detecta compose files, maneja entornos, health checks, rebuild, logs y debug de servicios.
---

# Gestionar Docker

---

## Paso 1: Detectar estructura del proyecto

```bash
ls -la docker-compose*.yml .env* 2>/dev/null
```

### Patrones esperados

**Estructura separada (recomendada)**:
```
docker-compose.yml          # Base: servicios, volúmenes, redes
docker-compose.dev.yml      # Override: hot-reload, debug, ports
docker-compose.prod.yml     # Override: reverse proxy, redes internas
.env.dev / .env.prod
```

**Estructura simple**:
```
docker-compose.yml + .env
```

## Paso 2: Determinar entorno

- "dev", "local" o sin especificar → DEV
- "prod", "producción", "VPS" → PROD

## Paso 3: Operaciones comunes

### Levantar
```bash
# Dev (adaptar archivos)
docker compose -f docker-compose.yml -f docker-compose.dev.yml --env-file .env.dev up -d
docker compose ps
```

### Rebuild
```bash
docker compose -f ... build <service>
docker compose -f ... up -d <service>
```

### Logs
```bash
docker compose logs <service> --tail 50
docker compose logs <service> -f --tail 20
docker compose logs <service> --tail 100 2>&1 | grep -iE "error|exception|traceback"
```

### Restart / Stop
```bash
docker compose restart <service>
docker compose down           # Para y elimina containers
docker compose down -v        # PELIGRO: también elimina volúmenes (datos)
```

## Paso 4: Diagnóstico

### Servicio no levanta
```bash
docker compose logs <service> --tail 100
docker compose ps -a
docker compose build <service>
```

### Servicio unhealthy
```bash
docker inspect --format='{{json .State.Health}}' <container> | jq
```

### Puerto ocupado
```bash
lsof -i :<port> 2>/dev/null || ss -tlnp | grep :<port>
```

## Reporte al usuario

```
DOCKER STATUS

Entorno: dev / prod
Compose files: [detectados]
Env file: [detectado]

Servicios:
  service1   UP  healthy  (port XXXX)
  service2   UP  healthy  (port XXXX)
```
