
# Nextcloud
Nextcloud Docker stack. Below are deployment strategies

## Table of Contents
1. [Nextcloud All-in-one deployment](#nextcloud-all-in-one-deployment)
2. [Nextcloud Minimal deployment](#nextcloud-minimal-deployment)

## Nextcloud All-in-one deployment
Here is a robust `docker-compose.yml` configuration designed for a "beefy" Ubuntu server. It includes **Nextcloud**, a high-performance **PostgreSQL** database, the **Redis** cache (critical for performance and required for Talk), and the official **OnlyOffice** document server (essential if you want full office suite integration with Talk).

This setup uses **HTTPS via Let's Encrypt** logic (reverse proxy setup), meaning you should have a domain name pointing to your server's IP.

### Prerequisites
Before running this, ensure you have:
1.  **Docker & Docker Compose installed:** `sudo apt install docker.io docker-compose-v2`
2.  **A Domain Name:** Pointed to your Ubuntu server's IP (e.g., `cloud.yourdomain.com`).
3.  **Ports 80 and 443 open** on your firewall.

### The `docker-compose.yml` File

Save the following code as `nextcloud-talk/docker-compose.yml`.

```yaml
version: '3.7'

services:
  # 1. Reverse Proxy (Traefik) - Handles SSL/HTTPS automatically
  traefik:
    image: traefik:v2.10
    command:
      - "--api.insecure=true"        # Dashboard available at :8080 (optional)
      - "--providers.docker"
      - "--providers.docker.exposedbydefault=false"
      - "--entrypoints.web.address=:80"
      - "--entrypoints.websecure.address=:443"
      - "--certificatesresolvers.myresolver.acme.httpchallenge=true"
      - "--certificatesresolvers.myresolver.acme.httpchallenge.entrypoint=web"
      # CHANGE 'YOUR_EMAIL' TO YOUR REAL EMAIL FOR LET'S ENCRYPT
      - "--certificatesresolvers.myresolver.acme.email=your_email@example.com"
      - "--certificatesresolvers.myresolver.acme.storage=/letsencrypt/acme.json"
    ports:
      - 80:80
      - 443:443
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock:ro
      - traefik-data:/letsencrypt
    restart: unless-stopped

  # 2. Database (PostgreSQL for high performance)
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

  # 3. Redis Cache (Required for Talk & Performance)
  redis:
    image: redis:alpine
    command: --save 60 1 --loglevel warning
    volumes:
      - redis-data:/data
    restart: unless-stopped

  # 4. Nextcloud App (The Core Application)
  nextcloud:
    image: nextcloud:latest
    environment:
      - NEXTCLOUD_HOST=cloud.yourdomain.com  # REPLACE THIS WITH YOUR DOMAIN
      - NEXTCLOUD_ADMIN_USER=admin            # Default Admin User
      - NEXTCLOUD_ADMIN_PASSWORD=change_this_admin_password_456
      # Database Config
      - POSTGRES_HOST=db
      - POSTGRES_DB=nextcloud
      - POSTGRES_USER=nextcloud
      - POSTGRES_PASSWORD=change_this_strong_password_123
      # Redis Config (For Talk & Caching)
      - REDIS_HOST=redis
      - REDIS_HOST_PORT=6379
      # Trust the reverse proxy
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

  # 5. OnlyOffice (Document Server for Editing in Browser)
  # Optional but recommended if you want full Talk file collaboration
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

### Configuration Steps (Crucial)

1.  **Update the Environment Variables:**
    *   Look for `NEXTCLOUD_HOST` and replace `cloud.yourdomain.com` with your actual domain.
    *   Look for `JWT_SECRET` and change it to a random string of characters.
    *   Update the `POSTGRES_PASSWORD` and `NEXTCLOUD_ADMIN_PASSWORD`.
    *   Change `your_email@example.com` in the Traefik section to a real email so you can recover lost certificates.

2.  **Create a `.env` file (Optional but recommended for passwords):**
    Instead of hardcoding passwords in the YAML, create a file named `.env` in the same folder with:
    ```text
    POSTGRES_PASSWORD=YourSuperSecretDBPassword
    NEXTCLOUD_ADMIN_PASS=YourSuperSecretAdminPass
    JWT_SECRET=YourSuperSecureJWTSecretString
    ```

3.  **Open Ports on Ubuntu:**
    Make sure UFW (Ubuntu Firewall) allows traffic:
    ```bash
    sudo ufw allow OpenSSH
    sudo ufw allow 80/tcp
    sudo ufw allow 443/tcp
    sudo ufw enable
    ```

### How to Start the Stack

1.  Navigate to the folder containing your `docker-compose.yml` in your terminal.
2.  Run:
    ```bash
    docker compose up -d
    ```
3.  Wait about 3-5 minutes for Traefik to request a certificate from Let's Encrypt and for Nextcloud to initialize.

### How to Access

*   **Nextcloud Web Interface:**
    `https://cloud.yourdomain.com`
    *   Use the Admin credentials defined in the YAML file.
*   **Nextcloud Talk Setup:**
    1.  Log into Nextcloud.
    2.  Go to **Settings** -> **Talk** (Under Administration).
    3.  You will see a message about "Turn" or "STUN" servers. By default, it uses Google's public STUN server (`stun:stun.l.google.com:19302`), which is fine for basic setup.
    4.  If you want video calls to work perfectly across different networks, you can add a TURN server later (like `coturn`), but for a start, the default configuration works.

### Why this stack?

*   **Traefik:** It automates SSL certificates and port mapping. You don't have to mess with complex Nginx configurations manually.
*   **PostgreSQL vs MariaDB:** PostgreSQL handles larger user bases (beefy servers) slightly better and is standard for enterprise Nextcloud deployments.

---

## Nextcloud minimal deployment
This deployment strategy utilizes your Firewall as end-point

Use enterprise firewall or FortiGate 60F instead of Traefik** for TLS termination, reverse proxying, and SSL management in your Nextcloud deployment.

FortiGate is a full-featured **SSL/HTTPS reverse proxy**, load balancer, and firewall. Using it means:

✅ No need for a separate Traefik container (simpler stack)  
✅ Centralized certificate management (using your enterprise CA or Let’s Encrypt via FortiGate)  
✅ Native deep-packet inspection, SSL decryption (if allowed by policy), DDoS protection, and WAF rules  
✅ Unified logging & security policies for Nextcloud traffic  

---

### ✅ Revised Architecture: FortiGate as Reverse Proxy

```
[Internet]
     |
   [FortiGate 60F] ←─── TLS Offloading / SSL Decryption (if enabled)
     |       │
     |       └── HTTPS → Docker Host IP:80 (Nextcloud container via reverse proxy)
     |
[Internal LAN / DMZ]
```

> 🔒 **Recommendation**: Use *SSL Certificate Inspection* only if required by compliance. Otherwise, use **SSL Forward Proxy** or *pass-through with SNI-based routing* to avoid decrypting traffic.

---

### ✅ Step-by-Step Integration

#### 1. **Deploy Nextcloud without Traefik (just reverse proxy to port 80)**
Update your `docker-compose.yml` — remove Traefik and expose Nextcloud on port 80:

```yaml
version: '3'
services:
  # Database (PostgreSQL)
  db:
    image: postgres:15
    environment:
      - POSTGRES_USER=nextcloud
      - POSTGRES_PASSWORD=secure_db_pass_123
      - POSTGRES_DB=nextcloud
      - PGDATA=/var/lib/postgresql/data/pgdata
    volumes:
      - db-data:/var/lib/postgresql/data
    restart: unless-stopped

  # Redis Cache (required for Talk & caching)
  redis:
    image: redis:alpine
    command: --save 60 1 --loglevel warning
    volumes:
      - redis-data:/data
    restart: unless-stopped

  # Nextcloud App
  nextcloud:
    image: nextcloud:latest
    environment:
      - NEXTCLOUD_HOST=your-fqdn.example.com   # e.g., cloud.company.local or cloud.yourdomain.com
      - POSTGRES_HOST=db
      - POSTGRES_DB=nextcloud
      - POSTGRES_USER=nextcloud
      - POSTGRES_PASSWORD=secure_db_pass_123
      - REDIS_HOST=redis
      - TRUSTED_PROXIES=172.0.0.0/8           # Allows FortiGate (or Docker gateway) to be trusted proxy
    ports:
      - "80:80"  # ← Only expose HTTP for now; FortiGate handles HTTPS
    volumes:
      - nextcloud-data:/var/www/html
    depends_on:
      - db
      - redis
    restart: unless-stopped

volumes:
  db-data:
  redis-data:
  nextcloud-data:
```

> 📌 **Important**: Nextcloud only listens on HTTP (80) inside the container. FortiGate handles HTTPS (443).

---

#### 2. **Configure FortiGate SSL Offloading / Reverse Proxy**

**Option A: Using Virtual Servers (Recommended)**  
*(Best for clean mapping and security policies)*

1. **Log in to FortiGate GUI** → `Network` → `Virtual IPs`.
   - Click **Create New**.
   - **Name**: `nextcloud-vip`
   - **External IP/Port**: `HTTPS:443`
   - **Server IP/Port**: Nextcloud Docker host IP:80 (e.g., `192.168.1.50:80`)
   - **Type**: `Reverse SNAT` or `Virtual IP` (depends on your topology — if using NAT, choose *VIP*).
   - Under **HTTP Rewrite**, optionally enable *HTTP to HTTPS redirect*.

2. **Configure SSL Certificate**
   - Go to `System` → `Cert Management` → `Local Certificates`.
     - Either upload your **enterprise certificate** (e.g., from your internal CA), OR
     - Generate a Let’s Encrypt cert *on FortiGate*:
       ```bash
       # Via CLI (optional):
       config ssl cert local
           edit "nextcloud-cert"
               set cert [paste base64 cert]...
               set key [paste base64 key]
           next
       end
       ```
     - Or use **FortiCloud Let’s Encrypt automation**:
       `System` → `Cert Management` → **Let’s Encrypt** → Enable and enter FQDN (`cloud.yourdomain.com`).

3. **Apply SSL certificate to VIP**
   - In the same Virtual IP config, under **SSL/SSH**, assign your cert.

4. **Configure Firewall Policy**
   - Go to `Policy & Objects` → **IPv4 Policy**.
     - Create policy:
       - **Incoming Interface**: e.g., `port1` (WAN) or trusted LAN
       - **Source**: `all` (or restrict by user/group)
       - **Destination**: `nextcloud-vip`
       - **Service**: `HTTPS`
       - **Schedule**: `always`
       - **AV Profile / Web Filter / Application Control**: Apply your standard security profile
     - Enable logging.

✅ Result:  
`https://your-fqdn.example.com` → FortiGate (TLS termination) → `http://192.168.x.x:80` (Nextcloud container)

---

#### 3. **Configure Nextcloud Trusted Domain & Proxy Settings**

In your Docker setup, ensure `NEXTCLOUD_HOST` matches the FQDN.

Then (crucial!) edit `config/config.php` inside the container:

```bash
docker exec -it nextcloud_nextcloud_1 sh
vi /var/www/html/config/config.php
```

Add/update:
```php
'trusted_proxies' => ['172.0.0.0/8', '192.168.x.x'], // include FortiGate's IP if different
'overwriteprotocol' => 'https',
'forwarded_ip_headers' => ['HTTP_X_FORWARDED_FOR', 'HTTP_X_REAL_IP'],
'htaccess.RewriteBase' => '/',
```

✅ This ensures Nextcloud generates URLs as `https://...` (not `http://`) and logs correct IPs.

---

#### 4. **(Optional) Enable Strict Transport Security (HSTS)**

In FortiGate SSL settings, you can inject HSTS header:
- Under the VIP or HTTP-to-HTTPS redirect profile → **HTTP Redirect to HTTPS** + add custom header:  
  `Strict-Transport-Security: max-age=31536000; includeSubDomains`

Or in Nextcloud’s `config.php`:
```php
'trust_proxies' => [...],
'overwrite.cli.url' => 'https://your-fqdn.example.com',
'overwritehost' => 'your-fqdn.example.com',
```

---

### ✅ Benefits of Using FortiGate vs. Traefik

| Feature | FortiGate 60F | Traefik |
|--------|---------------|---------|
| Centralized cert mgmt | ✅ (Enterprise CA + LE) | ✅ (LE only) |
| DDoS & bot protection | ✅ Native | ❌ (requires extra tools) |
| User-based policies / SSO | ✅ via AD/FortiToken | ❌ (via reverse proxy headers, complex) |
| SSL Decryption/inspection | ✅ Yes (if enabled) | ❌ Not native |
| Simplicity for small setups | ⚠️ CLI/GUI learning curve | ✅ Very easy (YAML) |
| Container-native? | ❌ Not container-aware | ✅ Dynamic service discovery |

---

### 📝 Summary

1. Deploy Nextcloud container **without Traefik** (expose port 80 only).
2. In FortiGate:
   - Create a **Virtual IP** for HTTPS:443 → Nextcloud:80.
   - Assign a TLS certificate (enterprise or LE on FortiGate).
   - Add firewall policy with security profiles.
3. Update `config.php` to trust FortiGate and use HTTPS.
