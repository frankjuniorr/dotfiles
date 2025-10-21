################################################################################
#  GIT ALIAS
################################################################################
alias jam-git="bash ${jam_bin} ${jam_project_folder}/menus/git/git.yaml"

# -------------------------------------------------------------------------------
# REPOSITORY
# -------------------------------------------------------------------------------
# Jump: got to git-root folder
alias g-root='cd "$(git rev-parse --show-toplevel)"'

# My git repository commands
alias jam-git-repo="bash ${jam_bin} ${jam_project_folder}/menus/git/git-repository/git-repository.yaml"

# -------------------------------------------------------------------------------
# LOGS
# -------------------------------------------------------------------------------
# olhe: http://opensource.apple.com/source/Git/Git-19/src/git-htmldocs/pretty-formats.txt
# <hash> <date> <user name> <commit message>
alias jam-git-logs="bash ${jam_bin} ${jam_project_folder}/menus/git/git-logs/git-logs.yaml"

# -------------------------------------------------------------------------------
# STATUS
# -------------------------------------------------------------------------------
# Git status
alias gt='git status'

# My git status commands
alias jam-git-status="bash ${jam_bin} ${jam_project_folder}/menus/git/git-status/git-status.yaml"

# -------------------------------------------------------------------------------
# COMMIT
# -------------------------------------------------------------------------------
# My git commit commands
alias jam-git-commit="bash ${jam_bin} ${jam_project_folder}/menus/git/git-commit/git-commit.yaml"

# -------------------------------------------------------------------------------
# BRANCHES
# -------------------------------------------------------------------------------
# comando padrão de listar as branchs locais
alias gb="git branch"
alias jam-git-branch="bash ${jam_bin} ${jam_project_folder}/menus/git/git-branch/git-branch.yaml"

# -------------------------------------------------------------------------------
# TAGS
# -------------------------------------------------------------------------------
# My git tags commands
alias jam-git-tag="bash ${jam_bin} ${jam_project_folder}/menus/git/git-tag/git-tag.yaml"
