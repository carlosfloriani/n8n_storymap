#!/bin/bash

# 🚀 Script para configurar GitHub para StoryMapp

echo "🚀 Configurando GitHub para StoryMapp..."

# Cores
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}=== Configuração do GitHub ===${NC}"

# Verificar se git está configurado
if ! git config --global user.name > /dev/null 2>&1; then
    echo -e "${YELLOW}⚠️  Git não está configurado. Vamos configurar agora:${NC}"
    read -p "Digite seu nome completo: " GIT_NAME
    read -p "Digite seu email: " GIT_EMAIL
    
    git config --global user.name "$GIT_NAME"
    git config --global user.email "$GIT_EMAIL"
    
    echo -e "${GREEN}✅ Git configurado com sucesso!${NC}"
fi

echo ""
echo -e "${BLUE}=== Opções para criar repositório ===${NC}"
echo "1. Criar repositório via GitHub CLI (recomendado)"
echo "2. Criar repositório manualmente no GitHub"
echo "3. Usar repositório existente"
echo ""

read -p "Escolha uma opção (1-3): " OPTION

case $OPTION in
    1)
        echo -e "${GREEN}Opção 1: Criar via GitHub CLI${NC}"
        
        # Verificar se GitHub CLI está instalado
        if ! command -v gh &> /dev/null; then
            echo -e "${YELLOW}GitHub CLI não está instalado. Instalando...${NC}"
            
            if [[ "$OSTYPE" == "darwin"* ]]; then
                # macOS
                brew install gh
            elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
                # Linux
                curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
                echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
                sudo apt update
                sudo apt install gh
            else
                echo -e "${YELLOW}Por favor, instale o GitHub CLI manualmente: https://cli.github.com/${NC}"
                exit 1
            fi
        fi
        
        # Login no GitHub
        echo -e "${BLUE}Fazendo login no GitHub...${NC}"
        gh auth login
        
        # Criar repositório
        read -p "Digite o nome do repositório (ex: storymapp): " REPO_NAME
        read -p "Digite a descrição do repositório: " REPO_DESC
        
        echo -e "${BLUE}Criando repositório no GitHub...${NC}"
        gh repo create "$REPO_NAME" --description "$REPO_DESC" --public --source=. --remote=origin --push
        
        echo -e "${GREEN}✅ Repositório criado e código enviado com sucesso!${NC}"
        ;;
        
    2)
        echo -e "${GREEN}Opção 2: Criar manualmente${NC}"
        echo ""
        echo -e "${BLUE}Passos para criar manualmente:${NC}"
        echo "1. Vá para: https://github.com/new"
        echo "2. Digite o nome do repositório (ex: storymapp)"
        echo "3. Adicione uma descrição"
        echo "4. Escolha se será público ou privado"
        echo "5. NÃO inicialize com README (já temos um)"
        echo "6. Clique em 'Create repository'"
        echo ""
        read -p "Após criar o repositório, digite a URL (ex: https://github.com/seu-usuario/storymapp.git): " REPO_URL
        
        if [[ -n "$REPO_URL" ]]; then
            git remote add origin "$REPO_URL"
            git branch -M main
            git push -u origin main
            
            echo -e "${GREEN}✅ Código enviado para o repositório!${NC}"
        fi
        ;;
        
    3)
        echo -e "${GREEN}Opção 3: Usar repositório existente${NC}"
        read -p "Digite a URL do repositório existente: " REPO_URL
        
        if [[ -n "$REPO_URL" ]]; then
            git remote add origin "$REPO_URL"
            git branch -M main
            git push -u origin main
            
            echo -e "${GREEN}✅ Código enviado para o repositório existente!${NC}"
        fi
        ;;
        
    *)
        echo -e "${YELLOW}Opção inválida. Saindo...${NC}"
        exit 1
        ;;
esac

echo ""
echo -e "${GREEN}🎉 Configuração do GitHub concluída!${NC}"
echo ""
echo -e "${BLUE}=== Próximos passos ===${NC}"
echo "1. Atualize o script de deploy com a URL do seu repositório"
echo "2. Execute o deploy no DigitalOcean"
echo "3. Compartilhe o repositório com sua equipe"
echo ""
echo -e "${BLUE}=== URLs importantes ===${NC}"
echo "GitHub: $(git remote get-url origin 2>/dev/null || echo 'Configure o remote primeiro')"
echo "DigitalOcean: http://165.227.68.30"
