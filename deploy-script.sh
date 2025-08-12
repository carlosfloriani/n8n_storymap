#!/bin/bash

# 🚀 Script de Deploy Automatizado para StoryMapp na Nuvem
# DigitalOcean Ubuntu 22.04 LTS

set -e  # Parar em caso de erro

echo "🚀 Iniciando deploy do StoryMapp na nuvem..."

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Função para log colorido
log() {
    echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')] $1${NC}"
}

warn() {
    echo -e "${YELLOW}[$(date +'%Y-%m-%d %H:%M:%S')] WARNING: $1${NC}"
}

error() {
    echo -e "${RED}[$(date +'%Y-%m-%d %H:%M:%S')] ERROR: $1${NC}"
    exit 1
}

# Verificar se está rodando como root
if [[ $EUID -ne 0 ]]; then
   error "Este script deve ser executado como root"
fi

# Variáveis de configuração
PROJECT_DIR="/opt/storymapp"
BACKUP_DIR="/opt/backups"
DOMAIN=""
EMAIL=""

# Função para obter configurações do usuário
get_config() {
    echo -e "${BLUE}=== Configuração do Deploy ===${NC}"
    
    read -p "Digite seu domínio (ou pressione Enter para usar IP): " DOMAIN
    read -p "Digite seu email (para SSL): " EMAIL
    
    if [[ -z "$DOMAIN" ]]; then
        DOMAIN=$(curl -s ifconfig.me)
        warn "Usando IP público: $DOMAIN"
    fi
}

# Atualizar sistema
update_system() {
    log "Atualizando sistema..."
    apt update && apt upgrade -y
    log "Sistema atualizado com sucesso!"
}

# Instalar dependências
install_dependencies() {
    log "Instalando dependências..."
    
    apt install -y curl wget git unzip software-properties-common \
                   apt-transport-https ca-certificates gnupg lsb-release \
                   nginx certbot python3-certbot-nginx htop
    
    log "Dependências instaladas com sucesso!"
}

# Instalar Docker
install_docker() {
    log "Instalando Docker..."
    
    # Adicionar repositório Docker
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
    
    apt update
    apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
    
    # Instalar Docker Compose standalone
    curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
    
    # Adicionar usuário ao grupo docker
    usermod -aG docker $USER
    
    log "Docker instalado com sucesso!"
}

# Configurar firewall
setup_firewall() {
    log "Configurando firewall..."
    
    ufw allow 22/tcp    # SSH
    ufw allow 80/tcp    # HTTP
    ufw allow 443/tcp   # HTTPS
    ufw allow 5678/tcp  # n8n
    ufw allow 3000/tcp  # API
    ufw allow 3001/tcp  # n8n-mcp
    ufw allow 6333/tcp  # Qdrant
    ufw allow 11434/tcp # Ollama
    
    ufw --force enable
    
    log "Firewall configurado com sucesso!"
}

# Preparar diretórios
prepare_directories() {
    log "Preparando diretórios..."
    
    mkdir -p $PROJECT_DIR
    mkdir -p $BACKUP_DIR
    
    log "Diretórios criados com sucesso!"
}

# Configurar Nginx
setup_nginx() {
    log "Configurando Nginx..."
    
    # Criar configuração do site
    cat > /etc/nginx/sites-available/storymapp << EOF
server {
    listen 80;
    server_name $DOMAIN;

    # n8n
    location / {
        proxy_pass http://localhost:5678;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_read_timeout 86400;
    }

    # API
    location /api/ {
        proxy_pass http://localhost:3000/;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }

    # n8n-mcp
    location /mcp/ {
        proxy_pass http://localhost:3001/;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}
EOF

    # Ativar site
    ln -sf /etc/nginx/sites-available/storymapp /etc/nginx/sites-enabled/
    rm -f /etc/nginx/sites-enabled/default
    
    # Testar configuração
    nginx -t
    
    # Reiniciar Nginx
    systemctl restart nginx
    systemctl enable nginx
    
    log "Nginx configurado com sucesso!"
}

# Configurar SSL (se domínio fornecido)
setup_ssl() {
    if [[ -n "$DOMAIN" && "$DOMAIN" != *"."* ]]; then
        warn "Domínio inválido, pulando configuração SSL"
        return
    fi
    
    if [[ -n "$EMAIL" ]]; then
        log "Configurando SSL com Let's Encrypt..."
        
        # Aguardar um pouco para o DNS propagar
        sleep 10
        
        # Obter certificado
        certbot --nginx -d $DOMAIN --non-interactive --agree-tos --email $EMAIL
        
        # Configurar renovação automática
        (crontab -l 2>/dev/null; echo "0 12 * * * /usr/bin/certbot renew --quiet") | crontab -
        
        log "SSL configurado com sucesso!"
    else
        warn "Email não fornecido, pulando configuração SSL"
    fi
}

# Criar script de backup
create_backup_script() {
    log "Criando script de backup..."
    
    cat > $PROJECT_DIR/backup.sh << 'EOF'
#!/bin/bash
DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="/opt/backups"
mkdir -p $BACKUP_DIR

# Backup dos volumes Docker
docker run --rm -v storymapp_n8n_data:/data -v $BACKUP_DIR:/backup alpine tar czf /backup/n8n_data_$DATE.tar.gz -C /data .
docker run --rm -v storymapp_postgres_data:/data -v $BACKUP_DIR:/backup alpine tar czf /backup/postgres_data_$DATE.tar.gz -C /data .
docker run --rm -v storymapp_qdrant_data:/data -v $BACKUP_DIR:/backup alpine tar czf /backup/qdrant_data_$DATE.tar.gz -C /data .
docker run --rm -v storymapp_ollama_data:/data -v $BACKUP_DIR:/backup alpine tar czf /backup/ollama_data_$DATE.tar.gz -C /data .

# Manter apenas os últimos 7 backups
find $BACKUP_DIR -name "*.tar.gz" -mtime +7 -delete

echo "Backup concluído: $DATE"
EOF

    chmod +x $PROJECT_DIR/backup.sh
    
    # Agendar backup diário
    (crontab -l 2>/dev/null; echo "0 2 * * * $PROJECT_DIR/backup.sh") | crontab -
    
    log "Script de backup criado e agendado!"
}

# Criar script de monitoramento
create_monitoring_script() {
    log "Criando script de monitoramento..."
    
    cat > $PROJECT_DIR/monitor.sh << 'EOF'
#!/bin/bash
echo "=== Status dos Serviços ==="
docker-compose ps

echo -e "\n=== Uso de Recursos ==="
echo "CPU e Memória:"
top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'%' -f1
free -h | grep Mem | awk '{print $3"/"$2}'

echo -e "\n=== Espaço em Disco ==="
df -h /

echo -e "\n=== Logs Recentes do n8n ==="
docker-compose logs --tail=10 n8n
EOF

    chmod +x $PROJECT_DIR/monitor.sh
    
    log "Script de monitoramento criado!"
}

# Criar arquivo de configuração de produção
create_production_env() {
    log "Criando arquivo de configuração de produção..."
    
    # Gerar senha aleatória
    PASSWORD=$(openssl rand -base64 32)
    
    cat > $PROJECT_DIR/.env << EOF
# Configurações de Produção
NODE_ENV=production
N8N_BASIC_AUTH_ACTIVE=true
N8N_BASIC_AUTH_USER=admin
N8N_BASIC_AUTH_PASSWORD=$PASSWORD
DB_TYPE=postgresdb
DB_POSTGRESDB_HOST=postgres
DB_POSTGRESDB_PORT=5432
DB_POSTGRESDB_DATABASE=n8n
DB_POSTGRESDB_USER=n8n
DB_POSTGRESDB_PASSWORD=n8n
N8N_HOST=$DOMAIN
N8N_PORT=5678
N8N_PROTOCOL=https
WEBHOOK_URL=https://$DOMAIN:5678/
GENERIC_TIMEZONE=America/Sao_Paulo
EOF

    log "Arquivo de configuração criado!"
    log "Senha do admin: $PASSWORD"
    echo "⚠️  GUARDE ESTA SENHA EM UM LUGAR SEGURO!"
}

# Função principal
main() {
    echo -e "${BLUE}================================${NC}"
    echo -e "${BLUE}  Deploy StoryMapp na Nuvem${NC}"
    echo -e "${BLUE}================================${NC}"
    
    get_config
    update_system
    install_dependencies
    install_docker
    setup_firewall
    prepare_directories
    setup_nginx
    setup_ssl
    create_backup_script
    create_monitoring_script
    create_production_env
    
    echo -e "${GREEN}================================${NC}"
    echo -e "${GREEN}  Deploy concluído com sucesso!${NC}"
    echo -e "${GREEN}================================${NC}"
    echo ""
    echo "📋 Próximos passos:"
    echo "1. Clone seu repositório em: $PROJECT_DIR"
    echo "2. Execute: cd $PROJECT_DIR && docker-compose up -d"
    echo "3. Acesse: https://$DOMAIN"
    echo ""
    echo "🔧 Comandos úteis:"
    echo "- Monitorar: $PROJECT_DIR/monitor.sh"
    echo "- Backup: $PROJECT_DIR/backup.sh"
    echo "- Logs: docker-compose logs -f"
    echo ""
    echo "⚠️  IMPORTANTE: Guarde a senha do admin mostrada acima!"
}

# Executar função principal
main "$@"
