# 📦 Extensões Recomendadas para o Cursor/VS Code

## 🔧 Extensões Essenciais

### 1. **Docker**

- **ID**: `ms-vscode.vscode-docker`
- **Descrição**: Suporte completo para Docker
- **Por que**: Para gerenciar containers e imagens

### 2. **Prettier - Code formatter**

- **ID**: `esbenp.prettier-vscode`
- **Descrição**: Formatador de código automático
- **Por que**: Para manter o código bem formatado

### 3. **ESLint**

- **ID**: `dbaeumer.vscode-eslint`
- **Descrição**: Linter para JavaScript/Node.js
- **Por que**: Para identificar problemas no código

### 4. **JavaScript Debugger**

- **ID**: `ms-vscode.vscode-js-debug`
- **Descrição**: Debugger nativo para JavaScript
- **Por que**: Para debugar a API Node.js

### 5. **YAML**

- **ID**: `ms-vscode.vscode-yaml`
- **Descrição**: Suporte para arquivos YAML
- **Por que**: Para editar docker-compose.yml

## 🎨 Extensões Opcionais (mas úteis)

### 6. **Path Intellisense**

- **ID**: `christian-kohler.path-intellisense`
- **Descrição**: Autocompletar caminhos de arquivos
- **Por que**: Facilita a navegação no projeto

### 7. **Auto Rename Tag**

- **ID**: `formulahendry.auto-rename-tag`
- **Descrição**: Renomear tags automaticamente
- **Por que**: Útil para HTML/XML se necessário

### 8. **Tailwind CSS IntelliSense**

- **ID**: `bradlc.vscode-tailwindcss`
- **Descrição**: Suporte para Tailwind CSS
- **Por que**: Se você usar Tailwind no futuro

## 🚀 Como Instalar

### No Cursor/VS Code:

1. **Abrir a aba de extensões**: `Ctrl+Shift+X` (Windows/Linux) ou `Cmd+Shift+X` (Mac)

2. **Pesquisar e instalar cada extensão**:

   - Digite o nome da extensão na barra de pesquisa
   - Clique em "Install"

3. **Ou usar o comando**:
   - `Ctrl+Shift+P` → "Extensions: Install Extensions"
   - Pesquise pelo nome

### Via Terminal (opcional):

```bash
# Instalar extensões via code CLI (se disponível)
code --install-extension ms-vscode.vscode-docker
code --install-extension esbenp.prettier-vscode
code --install-extension dbaeumer.vscode-eslint
code --install-extension ms-vscode.vscode-js-debug
code --install-extension ms-vscode.vscode-yaml
```

## ✅ Verificação

Após instalar, você deve ver:

- Ícone do Docker na barra lateral
- Formatação automática ao salvar arquivos
- Sublinhados vermelhos para erros de ESLint
- Autocompletar melhorado para caminhos

## 🔄 Próximo Passo

Depois de instalar as extensões, você pode executar:

```bash
./start.sh
```

Para iniciar todos os serviços do projeto!
