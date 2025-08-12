# 🚀 Comandos para Console do DigitalOcean

## 📋 Passo a Passo para Deploy

### 1. Acesse o Console do DigitalOcean

1. Vá para https://cloud.digitalocean.com/
2. Clique no seu Droplet: `nodejs-s-1vcpu-1gb-nyc3-01`
3. Clique em **"Console"** (no canto superior direito)
4. Aguarde o console carregar

### 2. Execute o Script de Deploy

Copie e cole este comando no console:

```bash
curl -fsSL https://raw.githubusercontent.com/carlosfloriani/n8n_storymap/main/deploy-droplet.sh | bash
```

**OU** se preferir executar localmente, copie todo o conteúdo do arquivo `deploy-droplet.sh` e cole no console.

### 3. Clone o Repositório

Após o script terminar, execute:

```bash
cd /opt/storymapp
git clone https://github.com/carlosfloriani/n8n_storymap.git .
```

### 4. Deployar a Aplicação

```bash
docker-compose -f docker-compose.prod.yml up -d
```

### 5. Verificar Status

```bash
docker-compose ps
```

## 🌐 Acessos

Após o deploy, você poderá acessar:

- **n8n**: http://165.227.68.30
- **API**: http://165.227.68.30/api
- **n8n-mcp**: http://165.227.68.30/mcp

## 🔧 Comandos Úteis

### Verificar Logs

```bash
# Logs em tempo real
docker-compose logs -f

# Logs específicos do n8n
docker-compose logs -f n8n
```

### Monitoramento

```bash
# Status dos serviços
/opt/storymapp/monitor.sh

# Uso de recursos
htop
df -h
free -h
```

### Backup

```bash
# Backup manual
/opt/storymapp/backup.sh

# Ver backups existentes
ls -la /opt/backups/
```

### Troubleshooting

```bash
# Reiniciar n8n
docker-compose restart n8n

# Verificar portas
netstat -tulpn | grep :5678

# Verificar permissões
ls -la /opt/storymapp/
```

## ⚠️ Informações Importantes

- **Senha do admin**: Será gerada automaticamente pelo script
- **Backup automático**: Diário às 2h da manhã
- **Firewall**: Configurado automaticamente
- **Nginx**: Proxy reverso configurado

## 🆘 Se Algo Der Errado

### Reiniciar Tudo

```bash
docker-compose down
docker-compose -f docker-compose.prod.yml up -d
```

### Verificar Serviços

```bash
systemctl status nginx
systemctl status docker
```

### Logs do Sistema

```bash
journalctl -u nginx
journalctl -u docker
```

## 📞 Próximos Passos

1. **Testar acesso** ao n8n: http://165.227.68.30
2. **Fazer login** com as credenciais geradas
3. **Importar workflows** existentes (se houver)
4. **Configurar notificações** por email
5. **Monitorar performance** do servidor
