# 🚀 Comandos Rápidos - Deploy StoryMapp na Nuvem

## 📋 Checklist Pré-Deploy

- [ ] Conta DigitalOcean criada
- [ ] Chave SSH configurada
- [ ] Domínio apontando para o servidor (opcional)
- [ ] Repositório Git configurado

## 🔧 Deploy Automatizado (Recomendado)

### 1. Conectar ao Droplet

```bash
ssh root@SEU_IP_DO_DROPLET
```

### 2. Executar Script de Deploy

```bash
# Baixar e executar o script
curl -fsSL https://raw.githubusercontent.com/seu-usuario/storymapp/main/deploy-script.sh | bash
```

### 3. Clonar e Deployar

```bash
cd /opt/storymapp
git clone https://github.com/seu-usuario/storymapp.git .
docker-compose -f docker-compose.prod.yml up -d
```

## 🔧 Deploy Manual

### 1. Configurar Servidor

```bash
# Atualizar sistema
apt update && apt upgrade -y

# Instalar Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh

# Instalar Docker Compose
curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
```

### 2. Configurar Firewall

```bash
ufw allow 22/tcp    # SSH
ufw allow 80/tcp    # HTTP
ufw allow 443/tcp   # HTTPS
ufw allow 5678/tcp  # n8n
ufw --force enable
```

### 3. Deployar Aplicação

```bash
mkdir -p /opt/storymapp
cd /opt/storymapp
git clone https://github.com/seu-usuario/storymapp.git .
docker-compose -f docker-compose.prod.yml up -d
```

## 🌐 Configurar Domínio e SSL

### 1. Instalar Nginx

```bash
apt install -y nginx certbot python3-certbot-nginx
```

### 2. Configurar Proxy Reverso

```bash
cat > /etc/nginx/sites-available/storymapp << 'EOF'
server {
    listen 80;
    server_name SEU_DOMINIO.com;

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
}
EOF

ln -s /etc/nginx/sites-available/storymapp /etc/nginx/sites-enabled/
rm /etc/nginx/sites-enabled/default
nginx -t && systemctl restart nginx
```

### 3. Configurar SSL

```bash
certbot --nginx -d SEU_DOMINIO.com
```

## 🛠️ Comandos de Manutenção

### Verificar Status

```bash
# Status dos containers
docker-compose ps

# Logs em tempo real
docker-compose logs -f

# Uso de recursos
docker stats
```

### Backup e Restore

```bash
# Backup manual
/opt/storymapp/backup.sh

# Restaurar backup
docker run --rm -v storymapp_n8n_data:/data -v /caminho/backup:/backup alpine tar xzf /backup/n8n_data_20241201_120000.tar.gz -C /data
```

### Atualizações

```bash
# Atualizar n8n
docker-compose pull n8n
docker-compose up -d n8n

# Atualizar tudo
docker-compose pull
docker-compose up -d
```

### Troubleshooting

```bash
# Reiniciar serviço específico
docker-compose restart n8n

# Ver logs de erro
docker-compose logs n8n --tail=50

# Verificar portas
netstat -tulpn | grep :5678

# Verificar permissões
ls -la /opt/storymapp/
```

## 📊 Monitoramento

### Script de Monitoramento

```bash
# Executar monitoramento
/opt/storymapp/monitor.sh

# Verificar uso de disco
df -h

# Verificar uso de memória
free -h

# Verificar processos
htop
```

### Alertas Automáticos

```bash
# Configurar alerta de disco cheio
echo '*/5 * * * * df -h | awk '\''$5 > "80%" {print "DISCO CHEIO: " $0}'\'' | mail -s "Alerta Disco" seu@email.com' | crontab -
```

## 🔒 Segurança

### Atualizações Automáticas

```bash
# Configurar atualizações automáticas
apt install unattended-upgrades
dpkg-reconfigure -plow unattended-upgrades
```

### Backup Automático

```bash
# Verificar cron jobs
crontab -l

# Adicionar backup diário
echo "0 2 * * * /opt/storymapp/backup.sh" | crontab -
```

## 💰 Otimização de Custos

### Redimensionar Droplet

```bash
# Verificar uso atual
htop
df -h
free -h

# Se uso < 50%, pode reduzir para Droplet menor
```

### Limpeza de Logs

```bash
# Limpar logs antigos
find /var/log -name "*.log" -mtime +7 -delete
docker system prune -f
```

## 🆘 Comandos de Emergência

### Parar Tudo

```bash
docker-compose down
```

### Reiniciar Servidor

```bash
reboot
```

### Acesso de Emergência

```bash
# Se não conseguir acessar n8n
docker-compose exec n8n n8n user:create --email admin@exemplo.com --firstName Admin --lastName User --password novaSenha123
```

## 📞 Suporte

### Informações do Sistema

```bash
# Versões
docker --version
docker-compose --version
nginx -v

# Status dos serviços
systemctl status nginx
systemctl status docker
```

### Logs Importantes

```bash
# Logs do sistema
journalctl -u nginx
journalctl -u docker

# Logs da aplicação
docker-compose logs --tail=100
```

## 🎯 Próximos Passos

1. **Testar Acesso**: https://SEU_DOMINIO
2. **Configurar Workflows**: Importar workflows existentes
3. **Configurar Email**: Configurar SMTP para notificações
4. **Monitoramento**: Configurar alertas
5. **Backup**: Testar restauração de backup
