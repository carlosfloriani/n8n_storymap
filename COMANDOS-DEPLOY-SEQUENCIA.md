# 🚀 Comandos de Deploy - Sequência Completa

## 📋 Copie e cole cada comando no console do DigitalOcean

### 1. Script de Deploy (5-10 minutos)
```bash
curl -fsSL https://raw.githubusercontent.com/carlosfloriani/n8n_storymap/main/deploy-droplet.sh | bash
```

### 2. Aguarde o script terminar e execute:
```bash
cd /opt/storymapp
```

### 3. Clone o repositório:
```bash
git clone https://github.com/carlosfloriani/n8n_storymap.git .
```

### 4. Deploy da aplicação:
```bash
docker-compose -f docker-compose.prod.yml up -d
```

### 5. Verificar status:
```bash
docker-compose ps
```

### 6. Ver logs (opcional):
```bash
docker-compose logs -f
```

## 🌐 Acessos Após Deploy

- **n8n**: http://165.227.68.30
- **API**: http://165.227.68.30/api
- **n8n-mcp**: http://165.227.68.30/mcp

## ⚠️ Informações Importantes

- **Senha do admin**: Será exibida no final da execução do script
- **Guarde a senha** em um lugar seguro!
- **Backup automático**: Configurado para 2h da manhã
- **Monitoramento**: Use `/opt/storymapp/monitor.sh`

## 🔧 Comandos de Verificação

### Verificar se tudo está funcionando:
```bash
# Status dos serviços
docker-compose ps

# Monitoramento
/opt/storymapp/monitor.sh

# Logs em tempo real
docker-compose logs -f
```

### Se algo der errado:
```bash
# Reiniciar n8n
docker-compose restart n8n

# Ver logs de erro
docker-compose logs n8n

# Verificar portas
netstat -tulpn | grep :5678
```

## 🎯 Resultado Esperado

Após executar todos os comandos, você terá:
- ✅ n8n rodando na nuvem
- ✅ Acesso via http://165.227.68.30
- ✅ Backup automático configurado
- ✅ Monitoramento ativo
- ✅ Segurança configurada
