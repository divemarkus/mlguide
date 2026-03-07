
# Nextcloud
Nextcloud Docker stack. Deployment strategies and example compose snippets for a secure, production-like setup.

## Table of Contents
1. [All-in-one Deployment](#nextcloud-all-in-one-deployment)  
2. [Configuration Steps](#configuration-steps)  
3. [Start the Stack](#how-to-start-the-stack)  
4. [Access & Talk Setup](#how-to-access)  
5. [Minimal Deployment (FortiGate)](#nextcloud-minimal-deployment)

---

## Nextcloud All-in-one deployment
Robust `docker-compose.yml` for a beefy Ubuntu server: Nextcloud + PostgreSQL + Redis + OnlyOffice with HTTPS via Let's Encrypt (Traefik).

### ✅ Prerequisites
1. Docker & Docker Compose installed: `sudo apt install docker.io docker-compose-v2`  
2. A domain name pointed to your server (e.g., `cloud.yourdomain.com`).  
3. Ports 80 and 443 open on your firewall.

### 📁 The `docker-compose.yml` File
Save the following as `nextcloud-talk/docker-compose.yml`.

```yaml
version: '3.7'

services:
  traefik:
    image: traefik:v2.10
    command:
      - "--api.insecure=true"
      - "--providers.docker"
      - "--providers.docker.exposedbydefault=false"
      - "--entrypoints.web.address=:80"
      - "--entrypoints.websecure.address=:443"
      - "--certificatesresolvers.myresolver.acme.httpchallenge=true"
      - "--certificatesresolvers.myresolver.acme.httpchallenge.entrypoint=web"
      - "--certificatesresolvers.myresolver.acme.email=your_email@example.com"
      - "--certificatesresolvers.myresolver.acme.storage=/letsencrypt/acme.json"
    ports:
      - 80:80
      - 443:443
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock:ro
      - traefik-data:/letsencrypt
    restart: unless-stopped

  db:
    image: postgres:15
    environment:
      - POSTGRES_USER=nextcloud
      - POSTGRES_PASSWORD=change_this_strong_password_123
      - POSTGRES_DB=nextcloud
      - PGDATA=/var/lib/postgresql/data/pgdata
    volumes:
      - db-data:/var/lib/postgresql/data
    restart: unless-stopped

  redis:
    image: redis:alpine
    command: --save 60 1 --loglevel warning
    volumes:
      - redis-data:/data
    restart: unless-stopped

  nextcloud:
    image: nextcloud:latest
    environment:
      - NEXTCLOUD_HOST=cloud.yourdomain.com
      - NEXTCLOUD_ADMIN_USER=admin
      - NEXTCLOUD_ADMIN_PASSWORD=change_this_admin_password_456
      - POSTGRES_HOST=db
      - POSTGRES_DB=nextcloud
      - POSTGRES_USER=nextcloud
      - POSTGRES_PASSWORD=change_this_strong_password_123
      - REDIS_HOST=redis
      - REDIS_HOST_PORT=6379
      - TRUSTED_PROXIES=traefik
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.nextcloud.rule=Host(`cloud.yourdomain.com`)"
      - "traefik.http.routers.nextcloud.entrypoints=websecure"
      - "traefik.http.routers.nextcloud.tls.certresolver=myresolver"
      - "traefik.http.services.nextcloud.loadbalance.stickiness=true"
    depends_on:
      - db
      - redis
    volumes:
      - nextcloud-data:/var/www/html
    restart: unless-stopped

  onlyoffice:
    image: onlyoffice/documentserver:latest
    environment:
      - JWT_ENABLED=true
      - JWT_SECRET=super_secret_jwt_key_change_this_789
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.onlyoffice.rule=Host(`onlyoffice.yourdomain.com`)"
      - "traefik.http.routers.onlyoffice.entrypoints=websecure"
      - "traefik.http.routers.onlyoffice.tls.certresolver=myresolver"
    volumes:
      - onlyoffice-data:/var/www/onlyoffice/Data
    restart: unless-stopped

volumes:
  db-data:
  redis-data:
  nextcloud-data:
  traefik-data:
  onlyoffice-data:
```

---

## 🔧 Configuration Steps (Crucial)

1. Update environment variables (`NEXTCLOUD_HOST`, `JWT_SECRET`, DB passwords).  
2. Optionally use a `.env` file for secrets (recommended).  
3. Open firewall ports (UFW):
```bash
sudo ufw allow OpenSSH
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw enable
```

---

## ▶️ How to Start the Stack

```bash
docker compose up -d
```

Wait 3–5 minutes for Traefik and Nextcloud initialization.

---

## 📥 How to Access
- Nextcloud Web Interface: `https://cloud.yourdomain.com`  
- For Talk: Login → Settings → Talk (configure STUN/TURN as needed)

---

## Nextcloud minimal deployment (FortiGate reverse proxy)
If you prefer using an enterprise firewall (FortiGate) for TLS termination, the document describes removing Traefik and using FortiGate as the reverse proxy with examples and config guidance.

Key steps: deploy Nextcloud on HTTP (port 80), configure FortiGate VIP for HTTPS→HTTP, apply TLS certs on FortiGate, and update Nextcloud `config.php` with `trusted_proxies` and `overwriteprotocol`.

---

## 📝 Summary
1. Deploy Nextcloud with Traefik for automated TLS (recommended for small teams).  
2. Use FortiGate for enterprise-grade TLS offload and security policies when needed.
