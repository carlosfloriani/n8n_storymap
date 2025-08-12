# 🚀 Deploy do StoryMapp na Nuvem - DigitalOcean

Este guia irá ajudá-lo a migrar seu projeto StoryMapp para a nuvem usando DigitalOcean.

## 📋 Pré-requisitos

- Conta na DigitalOcean
- Chave SSH configurada
- Domínio (opcional, mas recomendado)

## 🔧 Passo a Passo

### 1. Criar Droplet na DigitalOcean

1. Acesse [DigitalOcean](https://cloud.digitalocean.com/)
2. Clique em **Create** → **Droplets**
3. Configure o Droplet:
   - **Choose an image**: Ubuntu 22.04 LTS
   - **Choose a plan**: Basic (1GB RAM, 1 vCPU, 25GB SSD) - mínimo recomendado
   - **Choose a datacenter region**: São Paulo (SPA1) para melhor latência
   - **Authentication**: SSH Key (use sua chave pública)
   - **Finalize and create**

### 2. Conectar ao Droplet

```bash
ssh root@SEU_IP_DO_DROPLET
```

### 3. Configurar o Servidor

```bash
# Atualizar o sistema
apt update && apt upgrade -y

# Instalar dependências
apt install -y curl wget git unzip software-properties-common apt-transport-https ca-certificates gnupg lsb-release

# Instalar Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
apt update
apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# Instalar Docker Compose
curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# Adicionar usuário ao grupo docker
usermod -aG docker $USER
```

### 4. Configurar Firewall

```bash
# Permitir portas necessárias
ufw allow 22/tcp    # SSH
ufw allow 80/tcp    # HTTP
ufw allow 443/tcp   # HTTPS
ufw allow 5678/tcp  # n8n
ufw allow 3000/tcp  # API
ufw allow 3001/tcp  # n8n-mcp
ufw allow 6333/tcp  # Qdrant
ufw allow 11434/tcp # Ollama

# Ativar firewall
ufw enable
```

### 5. Clonar o Projeto

```bash
# Criar diretório para o projeto
mkdir -p /opt/storymapp
cd /opt/storymapp

# Clonar seu repositório (substitua pela URL do seu repo)
git clone https://github.com/seu-usuario/storymapp.git .
```

### 6. Configurar Variáveis de Ambiente

```bash
# Copiar arquivo de exemplo
cp env.example .env

# Editar as variáveis para produção
nano .env
```

**Configurações importantes para produção:**

```env
NODE_ENV=production
N8N_BASIC_AUTH_USER=admin
N8N_BASIC_AUTH_PASSWORD=SUA_SENHA_FORTE_AQUI
N8N_HOST=SEU_IP_OU_DOMINIO
N8N_PROTOCOL=https
WEBHOOK_URL=https://SEU_IP_OU_DOMINIO:5678/
```

### 7. Deploy com Docker Compose

```bash
# Construir e iniciar os serviços
docker-compose up -d

# Verificar status
docker-compose ps

# Ver logs
docker-compose logs -f
```

### 8. Configurar Nginx (Proxy Reverso)

```bash
# Instalar Nginx
apt install -y nginx

# Criar configuração
nano /etc/nginx/sites-available/storymapp
```

**Conteúdo da configuração:**

```nginx
server {
    listen 80;
    server_name SEU_IP_OU_DOMINIO;

    # n8n
    location / {
        proxy_pass http://localhost:5678;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
    }

    # API
    location /api/ {
        proxy_pass http://localhost:3000/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

```bash
# Ativar site
ln -s /etc/nginx/sites-available/storymapp /etc/nginx/sites-enabled/
rm /etc/nginx/sites-enabled/default

# Testar configuração
nginx -t

# Reiniciar Nginx
systemctl restart nginx
```

### 9. Configurar SSL/HTTPS (Opcional)

```bash
# Instalar Certbot
apt install -y certbot python3-certbot-nginx

# Obter certificado SSL
certbot --nginx -d SEU_DOMINIO.com

# Configurar renovação automática
crontab -e
# Adicionar linha: 0 12 * * * /usr/bin/certbot renew --quiet
```

### 10. Configurar Backup Automático

```bash
# Criar script de backup
nano /opt/storymapp/backup.sh
```

**Conteúdo do script:**

```bash
#!/bin/bash
DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="/opt/backups"
mkdir -p $BACKUP_DIR

# Backup dos volumes Docker
docker run --rm -v storymapp_n8n_data:/data -v $BACKUP_DIR:/backup alpine tar czf /backup/n8n_data_$DATE.tar.gz -C /data .
docker run --rm -v storymapp_postgres_data:/data -v $BACKUP_DIR:/backup alpine tar czf /backup/postgres_data_$DATE.tar.gz -C /data .

# Manter apenas os últimos 7 backups
find $BACKUP_DIR -name "*.tar.gz" -mtime +7 -delete
```

```bash
# Tornar executável
chmod +x /opt/storymapp/backup.sh

# Agendar backup diário
crontab -e
# Adicionar linha: 0 2 * * * /opt/storymapp/backup.sh
```

## 🌐 Acessos

Após o deploy, você poderá acessar:

- **n8n**: http://SEU_IP:5678 ou https://SEU_DOMINIO
- **API**: http://SEU_IP:3000/api ou https://SEU_DOMINIO/api
- **n8n-mcp**: http://SEU_IP:3001
- **Qdrant**: http://SEU_IP:6333

## 🔄 Migração de Workflows

Se você já tem workflows locais:

1. **Exportar workflows locais:**

   - Acesse n8n local: http://localhost:5678
   - Vá em Settings → Workflows
   - Exporte os workflows desejados

2. **Importar na nuvem:**
   - Acesse n8n na nuvem: http://SEU_IP:5678
   - Vá em Settings → Workflows
   - Importe os workflows exportados

## 📊 Monitoramento

```bash
# Verificar uso de recursos
htop

# Ver logs dos containers
docker-compose logs -f n8n

# Verificar espaço em disco
df -h

# Verificar uso de memória
free -h
```

## 🛠️ Comandos Úteis

```bash
# Reiniciar serviços
docker-compose restart

# Parar todos os serviços
docker-compose down

# Atualizar n8n
docker-compose pull n8n
docker-compose up -d n8n

# Backup manual
/opt/storymapp/backup.sh

# Verificar status dos serviços
systemctl status nginx
systemctl status docker
```

## 🔒 Segurança

- ✅ Firewall configurado
- ✅ Senhas fortes definidas
- ✅ SSL/HTTPS configurado
- ✅ Backup automático
- ✅ Atualizações automáticas

## 💰 Custos Estimados

- **Droplet Basic (1GB RAM)**: ~$6/mês
- **Domínio**: ~$12/ano
- **Total estimado**: ~$84/ano

## 🆘 Troubleshooting

### Problemas Comuns

1. **n8n não acessível:**

   ```bash
   docker-compose logs n8n
   docker-compose restart n8n
   ```

2. **Erro de permissão:**

   ```bash
   chown -R 1000:1000 /opt/storymapp/n8n_data
   ```

3. **Porta já em uso:**

   ```bash
   netstat -tulpn | grep :5678
   ```

4. **Problemas de SSL:**
   ```bash
   certbot renew --dry-run
   ```

## 📞 Suporte

Se encontrar problemas:

1. Verifique os logs: `docker-compose logs`
2. Consulte a documentação oficial do n8n
3. Verifique o status dos serviços: `docker-compose ps`
