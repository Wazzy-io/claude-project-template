---
name: diagram
description: Generar diagramas Mermaid del proyecto. Crea flowcharts, diagramas de estado, secuencia, ERD, arquitectura Docker y roadmap visual.
---

# Generar Diagrama con Mermaid

---

## Paso 1: Determinar tipo de diagrama

| Petición | Tipo Mermaid | Uso |
|----------|-------------|-----|
| "arquitectura", "flujo", "módulos" | `graph LR` o `graph TD` | Flujo de datos |
| "estado", "stages", "máquina" | `stateDiagram-v2` | Máquina de estados |
| "secuencia", "flujo mensaje" | `sequenceDiagram` | Interacción entre componentes |
| "base de datos", "tablas", "ERD" | `erDiagram` | Entidad-Relación |
| "docker", "servicios", "infra" | `graph TD` | Servicios Docker y redes |
| "roadmap", "timeline", "plan" | `gantt` | Timeline de tareas |
| "git", "branches" | `gitgraph` | Historial de branches |

## Paso 2: Generar el diagrama

Escribe código Mermaid dentro de un bloque ` ```mermaid `.

### Reglas de estilo

- Nodos: nombres cortos y claros
- Dirección: `LR` para flujos, `TD` para jerarquías
- Máximo 15-20 nodos por diagrama
- Si es muy grande, dividir en sub-diagramas

## Paso 3: Dónde guardar

| Situación | Dónde |
|-----------|-------|
| Arquitectura general | CLAUDE.md |
| Feature específico | En el chat (no guardar) |
| Roadmap/timeline | ROADMAP.md |
| Bug diagnosis | DEVLOG.md |
| Docker/infra | docs/ o CLAUDE.md |

Si el usuario no especifica, mostrar en el chat sin guardar.
