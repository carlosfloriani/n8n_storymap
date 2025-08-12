#!/bin/bash

echo "🚀 Iniciando StoryMapp..."

# Verificar se o Docker está rodando
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker não está rodando. Por favor, inicie o Docker primeiro."
    exit 1
fi

# Verificar se o arquivo .env existe
if [ ! -f .env ]; then
    echo "📝 Criando arquivo .env a partir do exemplo..."
    cp env.example .env
    echo "✅ Arquivo .env criado. Edite-o se necessário."
fi

# Construir e iniciar os containers
echo "🔨 Construindo e iniciando containers..."
docker-compose up -d --build

# Aguardar um pouco para os serviços iniciarem
echo "⏳ Aguardando serviços iniciarem..."
sleep 10

# Verificar status dos serviços
echo "📊 Status dos serviços:"
docker-compose ps

echo ""
echo "🌐 Acessos disponíveis:"
echo "   API Node.js: http://localhost:3000"
echo "   n8n: http://localhost:5678 (admin/password123)"
echo "   n8n-mcp: http://localhost:3001"
echo "   Qdrant: http://localhost:6333"
echo ""
echo "📚 Logs em tempo real: docker-compose logs -f"
echo "🛑 Parar serviços: docker-compose down" 