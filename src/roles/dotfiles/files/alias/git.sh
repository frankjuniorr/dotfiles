################################################################################
#  GIT ALIAS
################################################################################

# -------------------------------------------------------------------------------
# REPOSITORY
# -------------------------------------------------------------------------------

# got to git-root folder
alias g-root="git rev-parse --show-toplevel"

# Faz o `git fetch` com o spinner do `gum`
g-fetch() {
  gum spin \
    --spinner.foreground= \
    --spinner dot \
    --title "Fetching repository..." \
    -- git fetch --prune
}

# Alias para quando eu quero dar um 'git pull', levando em conta
# APENAS o que tem no repositório.
# útil, pra quando eu faço um Amend em um commit, e quero dar um 'git pull' depois
g-force-pull() {
  current_branch=$(git branch | grep "^*" | awk '{print $2}')
  git fetch origin
  git reset --hard origin/${current_branch}
}

# Faz clone de um repositório git a partir da URL, e entra na pasta
g-clone() {

  __is_cmd_installed gum

  local repository_name="$1"
  if [ -z "$repository_name" ]; then
    local repository_name=$(gum input --no-show-help --placeholder="Digite a URL do repositório")
  fi

  local repository_folder=$(basename "$repository_name" ".git")
  git clone "$repository_name"
  cd "$repository_folder"
  ls
}

# pega o nome do repositório do git
alias g-repository-name="git config --get --local remote.origin.url"

# abre o repositório no browser
g-repository-web() {
  local repository_url=$(g-repository-name)
  repository_url=$(echo "$repository_url" | sed 's/gitlab@//g' | sed 's/git@//g' | sed 's/.git//g' | sed 's|:|/|g')
  google-chrome-stable "$repository_url"
}

# -------------------------------------------------------------------------------
# LOGS
# -------------------------------------------------------------------------------
# olhe: http://opensource.apple.com/source/Git/Git-19/src/git-htmldocs/pretty-formats.txt
# <hash> <date> <user name> <commit message>
alias gl='git log -n 20 --oneline --date=short --pretty=format:"%Cgreen%h%Creset %Cred%ad%Creset %Cblue% %aN%Creset %s"'

# <hash> <date> <user email> <commit message>
alias gle='git log -n 20 --oneline --date=short --pretty=format:"%Cgreen%h%Creset %Cred%ad%Creset %Cblue% %ae%Creset %s"'

# imprime apenas o ultimo commit
alias g-last-commit="git log -1 --pretty=%s"

# -------------------------------------------------------------------------------
# STATUS
# -------------------------------------------------------------------------------
# Git status
alias gt='git status'

# desfaz as modificações do `git status` de "staged" e "not staged". Mantém os "Untracked Files" caso tenha
alias g-status-clean="git reset --hard"

# remove all untracked files, is case of you want to clean in repo.
g-status-remove-untracked() {
  if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    rm -rf $(git ls-files --others --exclude-standard | xargs)
  else
    echo "This is not a git repository"
    return 1
  fi
}

# -------------------------------------------------------------------------------
# COMMIT
# -------------------------------------------------------------------------------
# undo commit, and files back to the 'stage area'
alias g-commit-undo="git reset --soft HEAD^"

# Adiciona as modificações correntes no 'git status' ao último commit (HEAD), e faz um force push
alias g-commit-amend="git add . && git commit --amend --no-edit && git push --force-with-lease"

g-commit-new() {

  __is_cmd_installed gum

  # Verifica se há modificações no "git status".
  # - ! git diff --quiet : Verifica se há modificações "not staged"
  # - ! git diff --cached --quiet : Verifica se há modificações "staged"
  if ! git diff --quiet || ! git diff --cached --quiet; then
    local commit_title=$(gum input --cursor.foreground=2 --no-show-help --placeholder="Type the commit message")
    local commit_body=$(gum write --cursor.foreground=2 --no-show-help --placeholder="Type the commit description")
    local current_branch=$(git branch --show-current)

    test -z "$commit_title" && echo "The commit title cannot be empty" && return 1

    if [ -z "$commit_body" ]; then
      git commit -a -m \""$commit_title"\"
    else
      git commit -a -m \""$commit_title"\" -m \""$commit_body"\"
    fi
    git push -u origin "$current_branch"
  else
    echo "Nothing to commit"
    return 0
  fi
}

# Função pra juntar vários commits em 1 só.
# passando a quantidade por parâmetro, tipo assim:
# git_squash_commits 5 # ele irá considerar os ultimos 5 commits para fazer um squash
g-commit-squash() {
  local amount_commits="$1"

  if [ -n "$amount_commits" ]; then
    current_branch=$(git branch | grep "^*" | awk '{print $2}')
    git rebase -i HEAD~$amount_commits
    git push origin +${current_branch}
  else
    echo "type the amount of commits"
    return 1
  fi
}

# Função para juntar vários commits em 1 só.
# Ele a quantidade de vezes que o ultimo commit repetiu a mensagem.
g-commit-squash-equals() {
  local last_repeated_commit_count
  last_repeated_commit_count=$(git log --format=%s -n 20 | uniq -c | head -n 1 | awk '{print $1}')

  echo current_branch="$(git branch --show-current)"
  echo "$last_repeated_commit_count"

  git rebase -i HEAD~"${last_repeated_commit_count}"
  git push origin +"${current_branch}"
}

# -------------------------------------------------------------------------------
# BRANCHES
# -------------------------------------------------------------------------------
# comando padrão de listar as branchs locais
alias gb="git branch"

g-branch-switch() {

  __is_cmd_installed fzf

  # Atualiza a referências do repositório
  g-fetch

  # Get local branches and format with green color
  local local_branches=$(git branch --format='%(refname:short) %(committerdate:relative)' | grep -v HEAD)
  local formatted_local=$(echo "$local_branches" | sed -E "s/^([^ ]+)(.*)/${color_green}\1${color_reset}${color_blue}\2${color_reset}/")

  # Get remote branches and format with red color for names and blue for dates
  local remote_branches=$(git branch -r --format='%(refname:short) %(committerdate:relative)' | grep -v HEAD | grep "^origin/")
  local formatted_remote=$(echo "$remote_branches" | sed -E "s/^([^ ]+)(.*)/${color_red}\1${color_reset}${color_blue}\2${color_reset}/")

  # Combine the lists
  all_branches=$(echo -e "${formatted_local}\n${formatted_remote}" | grep -v "^$")

  # Select branch with FZF
  branch=$(
    echo "$all_branches" |
      fzf --ansi --no-sort --height 40% --reverse --border rounded \
        --preview 'branch_name=$(echo {} | sed -E "s/^[^a-zA-Z0-9_\/\-]*(([a-zA-Z0-9_\/\-]+)( .*)?)/\2/"); git log --oneline --date=short --color --pretty="format:%C(auto)%cd %h%d %s" $branch_name | head -n 20' \
        --preview-window right:60% \
        --prompt "Switch to branch: " |
      sed -E 's/^[[:space:]]*([^ ]+).*/\1/' | # Extract just the branch name
      sed -E 's/^origin\///'                  # Remove origin/ prefix if present
  )

  # Exit if no branch was selected
  if [ -z "$branch" ]; then
    echo "No branch selected. Exiting."
    return 0
  fi

  git checkout "$branch"
}

# Deleta todas as branches locais, deixando só a current branch
g-branches-clean() {
  local branches=$(git branch | grep -v '^\*' | awk '{print $1}')

  if [ -n "$branches" ]; then
    echo "🧹 Apagando branches locais:"
    echo "$branches" | xargs -n1 git branch -D
  fi

  echo "🔄 Limpando referências remotas obsoletas..."
  git fetch --prune
}

# Usado para checkar se a minha branch corrente, existe no repositório ou não
g-branch-check() {

  __is_cmd_installed gum

  local current_branch=$(git branch --show-current)

  g-fetch

  if git branch -r | grep -q "origin/${current_branch}"; then
    echo "This branch $current_branch exists in the repository"
  else
    echo "This branch $current_branch doens't exists in the repository"
    if gum confirm \
      --prompt.foreground=2 \
      --selected.background=2 \
      --no-show-help \
      "Clean up local branches?"; then
      g-branch-default && g-branch-clean
    fi
  fi
}

# Volta para o default branch
g-branch-default() {
  local default_branch=$(git rev-parse --abbrev-ref origin/HEAD | cut -d '/' -f2)
  git checkout "$default_branch"
  git fetch --prune
  git pull
}

# Cria uma nova branch de maneira interativa
g-branch-new() {

  __is_cmd_installed fzf

  # faz o fetch pra atualizar as referências do repositório
  g-fetch

  local branch_src
  local branch_new
  local commit_title
  local commit_body
  local remote_branches

  local default_branch=$(git rev-parse --abbrev-ref origin/HEAD | cut -d '/' -f2)

  # Menu: branch de origem
  local options=("Default (${default_branch})" "other")
  local branch_selected=$(printf "%s\n" "${options[@]}" | fzf \
    --prompt="Select a source branch: " \
    --height=20%)

  if [ "$branch_selected" != "other" ]; then
    branch_src="$default_branch"
  else
    remote_branches=$(git branch -r | grep -v "origin/HEAD" | sed "s/^ *//g" | sed "s|origin/||g" | fzf \
      --prompt="Select a source branch: " \
      --height=20%)
    branch_src="$remote_branches"
  fi

  branch_new=$(gum input --cursor.foreground=2 --no-show-help --placeholder="Type the new branch name")

  git checkout "$branch_src"
  git pull
  git checkout -b "$branch_new"

  # Verifica se há modificações no "git status".
  # - ! git diff --quiet : Verifica se há modificações "not staged"
  # - ! git diff --cached --quiet : Verifica se há modificações "staged"
  if ! git diff --quiet || ! git diff --cached --quiet; then
    commit_title=$(gum input --cursor.foreground=2 --no-show-help --placeholder="Type commit message")
    commit_body=$(gum write --cursor.foreground=2 --no-show-help --placeholder="Type commit description")

    test -z "$commit_title" && echo "The commit cannot be empty" && return 1

    if [ -z "$commit_body" ]; then
      git commit -a -m \""$commit_title"\"
    else
      git commit -a -m \""$commit_title"\" -m \""$commit_body"\"
    fi

    # TODO: usar o 'gum confirm' para perguntar, se quer abrir um MR ou não.
    # caso sim:
    #   - criar um menu fixo no fzf, com os username dos "assign" do MR.
    #   - usar o `glab` para criar o MR
    # caso não:
    # encerra o comando
  fi

  git push origin -u "$branch_new"
}

# -------------------------------------------------------------------------------
# TAGS
# -------------------------------------------------------------------------------

# Função que cria uma nova branch local, a partir deu uma tag no git
g-tags-new-branch() {
  local tag="$1"

  test -z "$tag" && echo "digite o nome da tag por parametro" && return 1

  git checkout -b "$tag" "$tag"
}

# Função para renomear uma tag no git
g-tags-rename() {
  local old_tag="$1"
  local new_tag="$2"

  test -z "$old_tag" && echo "digite a tag antiga no 1º parametro" && return 1
  test -z "$new_tag" && echo "digite a tag nova no 2º parametro" && return 1

  if git rev-parse --is-inside-work-tree >/dev/null; then
    git tag "$new_tag" "$old_tag"
    git tag -d "$old_tag"
    git push origin ":refs/tags/${old_tag}"
    git push --tags
  else
    echo "ERROR: This folder is not a git repository"
    return 1
  fi
}
