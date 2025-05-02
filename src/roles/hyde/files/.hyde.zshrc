#  Startup 
# Commands on startup (before the prompt is shown)
# This is a good place to load graphic/ascii art, display system information, etc.

# fastfetch --logo-type kitty
if [ -n "$TMUX" ]; then
  fastfetch --logo none
else
  fastfetch --logo-type kitty
fi

#  Plugins 
# manually add your oh-my-zsh plugins here
plugins=(
    "sudo"
    # "git"                     # (default)
    # "zsh-autosuggestions"     # (default)
    # "zsh-syntax-highlighting" # (default)
    # "zsh-completions"         # (default)
)