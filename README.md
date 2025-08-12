# StoryMapp

Projeto completo com Node.js, Docker, n8n e n8n-mcp para automação e IA.

## 🚀 Tecnologias

- **Node.js** - API REST
- **Docker** - Containerização
- **n8n** - Plataforma de automação de workflows
- **n8n-mcp** - Model Context Protocol para n8n
- **Ollama** - LLMs locais
- **Qdrant** - Vector database
- **PostgreSQL** - Banco de dados

## 📁 Estrutura do Projeto

```
StoryMapp/
├── src/                    # Código fonte da API
├── docker/                 # Configurações Docker
├── n8n/                    # Configurações n8n
├── n8n-mcp/                # Configurações n8n-mcp
├── docker-compose.yml      # Orquestração dos serviços
├── Dockerfile              # Imagem da API
└── README.md
```

## 🛠️ Instalação

### Pré-requisitos

- Node.js 18+
- Docker e Docker Compose
- Git

### Passos

1. **Clone o repositório**
   ```bash
   git clone <seu-repositorio>
   cd StoryMapp
   ```

2. **Instale as dependências da API**
   ```bash
   npm install
   ```

3. **Configure as variáveis de ambiente**
   ```bash
   cp .env.example .env
   # Edite o arquivo .env com suas configurações
   ```

4. **Inicie todos os serviços**
   ```bash
   docker-compose up -d
   ```

## 🌐 Acessos

- **API Node.js**: http://localhost:3000
- **n8n**: http://localhost:5678
- **n8n-mcp**: http://localhost:3001
- **Qdrant**: http://localhost:6333
- **PostgreSQL**: localhost:5432

## 📚 Documentação

- [n8n Self-hosted AI Starter Kit](https://github.com/n8n-io/self-hosted-ai-starter-kit)
- [n8n MCP](https://github.com/czlonkowski/n8n-mcp)

## 🤝 Contribuição

1. Fork o projeto
2. Crie uma branch para sua feature
3. Commit suas mudanças
4. Push para a branch
5. Abra um Pull Request 