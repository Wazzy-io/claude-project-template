"""
[PROJECT_NAME] — FastAPI Application
"""
import os
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI(
    title="[PROJECT_NAME]",
    description="[DESCRIPCION]",
    version="1.0.0",
)

# CORS — en dev permite todo, en prod restringir a tu dominio
ENVIRONMENT = os.getenv("ENVIRONMENT", "development")
if ENVIRONMENT == "development":
    origins = ["*"]
else:
    domain = os.getenv("DOMAIN", "localhost")
    origins = [f"https://app.{domain}", f"https://{domain}"]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.get("/api/health")
async def health():
    return {"status": "healthy"}


@app.get("/api/health/deep")
async def health_deep():
    """Health check profundo — verifica DB y Redis."""
    checks = {}

    # TODO: Verificar PostgreSQL
    # try:
    #     async with db.session() as session:
    #         await session.execute(text("SELECT 1"))
    #     checks["database"] = "ok"
    # except Exception as e:
    #     checks["database"] = f"error: {e}"

    # TODO: Verificar Redis
    # try:
    #     await redis.ping()
    #     checks["redis"] = "ok"
    # except Exception as e:
    #     checks["redis"] = f"error: {e}"

    all_ok = all(v == "ok" for v in checks.values()) if checks else True
    return {
        "status": "healthy" if all_ok else "unhealthy",
        "checks": checks,
        "environment": ENVIRONMENT,
    }
