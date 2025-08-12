# 🚀 Instruções Finais - Deploy StoryMapp

## 🎯 Seu Droplet: 165.227.68.30

**Nome**: `nodejs-s-1vcpu-1gb-nyc3-01`  
**IP**: `165.227.68.30`  
**Região**: NYC3  
**Plano**: 1GB RAM, 1 vCPU, 25GB SSD

## 📋 Deploy em 4 Passos Simples

### 1. Acessar Console do DigitalOcean

1. Vá para: https://cloud.digitalocean.com/
2. Clique no seu Droplet: `nodejs-s-1vcpu-1gb-nyc3-01`
3. Clique em **"Console"** (canto superior direito)
4. Aguarde o console carregar

### 2. Executar Script de Deploy

Copie e cole este comando no console:

```bash
curl -fsSL https://raw.githubusercontent.com/carlosfloriani/n8n_storymap/main/deploy-droplet.sh | bash
```

**⏱️ Tempo estimado**: 5-10 minutos

### 3. Clone o Repositório

Após o script terminar, execute:

```bash
cd /opt/storymapp
git clone https://github.com/carlosfloriani/n8n_storymap.git .
```

### 4. Deployar Aplicação

```bash
docker-compose -f docker-compose.prod.yml up -d
```

## 🌐 Acessos Após Deploy

- **n8n**: http://165.227.68.30
- **API**: http://165.227.68.30/api
- **n8n-mcp**: http://165.227.68.30/mcp

## 🔑 Credenciais

A senha do admin será gerada automaticamente pelo script e exibida no final da execução.

**⚠️ IMPORTANTE**: Guarde essa senha em um lugar seguro!

## 🔧 Comandos de Verificação

### Verificar Status

```bash
docker-compose ps
```

### Ver Logs

```bash
docker-compose logs -f
```

### Monitoramento

```bash
/opt/storymapp/monitor.sh
```

## 🛠️ Recursos Configurados

✅ **Docker** - Containerização  
✅ **Nginx** - Proxy reverso  
✅ **Firewall** - Segurança  
✅ **Backup automático** - Diário às 2h  
✅ **Monitoramento** - Scripts de verificação  
✅ **SSL** - Pronto para configuração

## 💰 Custos

- **Droplet**: $6/mês
- **Total estimado**: $72/ano

## 🆘 Troubleshooting

### Se n8n não acessível:

```bash
docker-compose restart n8n
docker-compose logs n8n
```

### Se porta em uso:

```bash
netstat -tulpn | grep :5678
```

### Se erro de permissão:

```bash
chown -R 1000:1000 /opt/storymapp/n8n_data
```

## 📞 Próximos Passos

1. **Execute o deploy** seguindo os passos acima
2. **Teste o acesso** ao n8n
3. **Importe workflows** existentes (se houver)
4. **Configure notificações** por email
5. **Monitore performance** do servidor

## 🎉 Resultado Final

Após o deploy, você terá:

- ✅ n8n rodando na nuvem
- ✅ Acesso 24/7 de qualquer lugar
- ✅ Backup automático dos dados
- ✅ Monitoramento profissional
- ✅ Segurança configurada

---

**🚀 Seu StoryMapp estará rodando na nuvem e pronto para uso!**
