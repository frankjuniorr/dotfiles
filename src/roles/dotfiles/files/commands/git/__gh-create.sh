#!/bin/bash

USER="frankjuniorr"

# Nome do template repo (pra quando for público)
TEMPLATE_REPO="${USER}/template-repository"

# Nome do diretório atual = nome do repo
REPO_NAME=$(basename "$PWD")

# Função para mostrar erro e sair
function erro() {
    echo "❌ $1"
    exit 1
}

# Detecta se o GitHub CLI está instalado
command -v gh >/dev/null 2>&1 || erro "GitHub CLI (gh) não encontrado. Instale com https://cli.github.com/"

# Detecta se gum está instalado
command -v gum >/dev/null 2>&1 || erro "gum não encontrado. Instale com https://github.com/charmbracelet/gum"

# Determina se o argumento foi passado
if [[ "$1" == "--private" ]]; then
    VISIBILITY="private"
elif [[ "$1" == "--public" ]]; then
    VISIBILITY="public"
else
    VISIBILITY=$(gum choose "public" "private")
fi

# Criação do repositório com o GitHub CLI
if [[ "$VISIBILITY" == "private" ]]; then
    echo "🔒 Criando repositório privado '$REPO_NAME'..."

    # Inicializa repositório Git com branch 'main'
    git init || erro "Falha ao inicializar o repositório"

    # Adiciona todos os arquivos e faz o primeiro commit
    git add . || erro "Falha ao adicionar arquivos"
    git commit -m "first commit" || erro "Falha ao fazer o commit inicial"

    gh repo create "$REPO_NAME" --private --source=. --push || erro "Falha ao criar o repositório privado"

    # Muda o origin de HTTPS → SSH
    git remote set-url origin "git@github.com:${USER}/${REPO_NAME}.git"

    # Push da branch main, definindo como upstream
    git push -u origin main || erro "Falha ao fazer push da branch main"

elif [[ "$VISIBILITY" == "public" ]]; then
    echo "🌍 Criando repositório público '$REPO_NAME' baseado no template '$TEMPLATE_REPO'..."
    gh repo create "$REPO_NAME" --public --template="$TEMPLATE_REPO" || erro "Falha ao criar o repositório público"

    echo "🔁 Inicializando repositório Git local e puxando base do template..."
    git init
    git remote add origin "git@github.com:${USER}/${REPO_NAME}.git"

    # Puxa o conteúdo base (README, LICENSE, etc.) do template
    git pull origin main --allow-unrelated-histories || erro "Erro ao puxar do repositório remoto"

    echo "📦 Subindo seu código da pasta atual..."
    git add .
    git commit -m "Initial commit from local"
    git branch -M main
    git push -u origin main
else
    erro "Opção inválida: $VISIBILITY"
fi

echo "✅ Repositório '$REPO_NAME' criado e conteúdo enviado!"
