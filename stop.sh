#!/bin/bash

echo "🛑 Parando StoryMapp..."

# Parar e remover containers
docker-compose down

echo "✅ Serviços parados com sucesso!"
echo ""
echo "💡 Para remover também os volumes (dados):"
echo "   docker-compose down -v"
echo ""
echo "💡 Para remover também as imagens:"
echo "   docker-compose down --rmi all" 