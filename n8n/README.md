# n8n Configuration

Este diretório contém as configurações e workflows para o n8n.

## 📁 Estrutura

```
n8n/
├── workflows/           # Workflows exportados
├── credentials/         # Credenciais (se necessário)
└── README.md           # Esta documentação
```

## 🔧 Configuração

O n8n está configurado com:

- **Autenticação básica**: admin/password123
- **Banco de dados**: PostgreSQL
- **Porta**: 5678
- **Timezone**: America/Sao_Paulo

## 🌐 Acesso

- **URL**: http://localhost:5678
- **Usuário**: admin
- **Senha**: password123

## 📋 Workflows Incluídos

### 1. Example Workflow
- **Arquivo**: `workflows/example-workflow.json`
- **Descrição**: Workflow básico de exemplo com webhook
- **Endpoint**: `GET /webhook`

## 🚀 Como Usar

1. Acesse http://localhost:5678
2. Faça login com admin/password123
3. Importe os workflows da pasta `workflows/`
4. Ative os workflows desejados

## 🔗 Integrações Disponíveis

- **API Node.js**: http://api:3000
- **Qdrant**: http://qdrant:6333
- **Ollama**: http://ollama:11434
- **n8n-mcp**: http://n8n-mcp:3001

## 📚 Recursos

- [Documentação oficial do n8n](https://docs.n8n.io/)
- [n8n Self-hosted AI Starter Kit](https://github.com/n8n-io/self-hosted-ai-starter-kit)
- [n8n MCP](https://github.com/czlonkowski/n8n-mcp) 