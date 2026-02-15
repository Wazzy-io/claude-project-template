---
name: deploy-vps
description: Deploy Docker Compose a VPS desde cero. Setup, deploy, SSL, backups, CI/CD. Reutilizable entre proyectos.
---

# Deploy VPS Skill

> Skill reutilizable para desplegar cualquier proyecto Docker Compose en un VPS.

---

## Cuándo usar

- `/deploy-vps setup` — Primera vez: instalar Docker, configurar firewall, usuario deploy
- `/deploy-vps deploy` — Subir proyecto al VPS y levantarlo
- `/deploy-vps ssl` — Configurar dominio + SSL con Traefik
- `/deploy-vps backup` — Configurar backups automáticos de PostgreSQL
- `/deploy-vps ci` — Configurar GitHub Actions CI/CD auto-deploy
- `/deploy-vps status` — Ver estado completo del VPS

---

## Pre-requisitos

- VPS con Ubuntu 22.04+ LTS
- Clave SSH local añadida al VPS
- Proyecto con `docker-compose.yml` + `docker-compose.prod.yml`
- Archivo `.env.prod.example` como template

---

## FASE 1: Setup inicial (`/deploy-vps setup`)

### 1.1 Verificar conexión + actualizar
```bash
ssh root@<VPS_IP> "apt update && apt upgrade -y && apt install -y curl git htop ufw fail2ban"
```

### 1.2 Instalar Docker CE (repo oficial, NO snap)
```bash
# GPG key (batch mode para SSH)
ssh root@<VPS_IP> 'apt install -y ca-certificates curl gnupg && install -m 0755 -d /etc/apt/keyrings && curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /tmp/docker.gpg && gpg --batch --dearmor -o /etc/apt/keyrings/docker.gpg < /tmp/docker.gpg'

# Repo + install
ssh root@<VPS_IP> 'echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo $VERSION_CODENAME) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null && apt update && DEBIAN_FRONTEND=noninteractive apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin'
```

### 1.3 Firewall
```bash
ssh root@<VPS_IP> "ufw default deny incoming && ufw default allow outgoing && ufw allow 22/tcp && ufw allow 80/tcp && ufw allow 443/tcp && ufw --force enable"
```

### 1.4 Usuario deploy (no root)
```bash
ssh root@<VPS_IP> << 'EOF'
  adduser --disabled-password --gecos "" deploy
  usermod -aG docker deploy
  mkdir -p /home/deploy/.ssh
  cp /root/.ssh/authorized_keys /home/deploy/.ssh/
  chown -R deploy:deploy /home/deploy/.ssh
  chmod 700 /home/deploy/.ssh && chmod 600 /home/deploy/.ssh/authorized_keys
  echo "deploy ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/deploy
EOF
```

### 1.5 SSH key dedicada (sin passphrase)
```bash
ssh-keygen -t ed25519 -C "deploy@<PROJECT>" -f ~/.ssh/id_ed25519_<PROJECT> -N ""
# Añadir al VPS y configurar ~/.ssh/config con alias <PROJECT>-vps
```

---

## FASE 2: Deploy (`/deploy-vps deploy`)

### Subir proyecto (tar+scp, sin necesitar git en VPS)
```bash
tar -czf /tmp/project.tar.gz --exclude='.git' --exclude='node_modules' --exclude='__pycache__' --exclude='.env.*' --exclude='.tmp' .
scp /tmp/project.tar.gz <PROJECT>-vps:~/apps/
ssh <PROJECT>-vps "mkdir -p ~/apps/<PROJECT> && cd ~/apps/<PROJECT> && tar -xzf ~/apps/project.tar.gz && rm ~/apps/project.tar.gz"
```

### Crear .env.prod + levantar
```bash
scp .env.prod.example <PROJECT>-vps:~/apps/<PROJECT>/.env.prod
ssh <PROJECT>-vps "cd ~/apps/<PROJECT> && docker compose -f docker-compose.yml -f docker-compose.prod.yml --env-file .env.prod up -d --build"
```

---

## FASE 3: Dominio + SSL (`/deploy-vps ssl`)

1. DNS: registro A apuntando al VPS
2. Actualizar DOMAIN en .env.prod
3. Restart → Traefik genera SSL automáticamente
4. Verificar: `curl https://app.tudominio.com/api/health`

---

## FASE 4: Backups (`/deploy-vps backup`)

Script en VPS: pg_dump diario via cron (3AM), retención 30 días.

---

## FASE 5: CI/CD (`/deploy-vps ci`)

GitHub Actions: checkout → tar → SCP → SSH rebuild Docker → health check.

```bash
# Crear SSH key para Actions
ssh-keygen -t ed25519 -C "actions@<PROJECT>" -f ~/.ssh/id_ed25519_<PROJECT>_actions -N ""

# Secrets en GitHub
gh secret set VPS_HOST --repo <OWNER>/<REPO>
gh secret set VPS_USER --repo <OWNER>/<REPO>
gh secret set VPS_SSH_KEY --repo <OWNER>/<REPO> < ~/.ssh/id_ed25519_<PROJECT>_actions
```

Crear `.github/workflows/deploy.yml` con steps: checkout, setup SSH, tar, SCP, SSH deploy, health check.

---

## Lecciones aprendidas

1. **Traefik v3.6+** — Versiones anteriores incompatibles con Docker 29
2. **`docker compose restart` NO recarga env vars** → usar `up --force-recreate`
3. **Health check en CI/CD: URL pública, no localhost** — Con reverse proxy los puertos no están expuestos
4. **rsync no disponible en Windows** — Usar tar+scp
5. **curl Windows falla con Let's Encrypt** — Verificar SSL desde el VPS
