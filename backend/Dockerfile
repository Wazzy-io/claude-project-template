# ============================================
# [PROJECT_NAME] — Backend Dockerfile (FastAPI + Python)
# ============================================
FROM python:3.11-slim

# Dependencias del sistema para psycopg2 (PostgreSQL)
RUN apt-get update && apt-get install -y \
    gcc \
    libpq-dev \
    curl \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Instalar dependencias Python
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copiar codigo
COPY . .

# Puerto de la API
EXPOSE 8000

# Comando por defecto (produccion)
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
