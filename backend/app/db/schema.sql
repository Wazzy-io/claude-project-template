-- ============================================
-- [PROJECT_NAME] — Schema SQL (Fuente de verdad)
-- ============================================
-- Este archivo se ejecuta automaticamente en el PRIMER deploy
-- (cuando el volumen de PostgreSQL es nuevo).
--
-- Para cambios posteriores, crear migraciones en:
--   backend/app/db/migrations/YYYY-MM-DD_descripcion.sql
--
-- Regla: schema.sql SIEMPRE debe reflejar el estado final de la BD.

-- Habilitar UUID
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ---- Tabla ejemplo ----
-- CREATE TABLE IF NOT EXISTS users (
--     id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
--     name VARCHAR(255) NOT NULL,
--     email VARCHAR(255) UNIQUE,
--     created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
--     updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
-- );

-- Agregar tus tablas aqui...
