#!/bin/bash

# ##############################################################################
# [Descrição]:
#
# Script que instala os dotfiles, comandos, e configs através de links simbólicos
# ##############################################################################

set -e

# carrega todos os dotfiles para o $HOME
link_dotfiles(){
  # linkando os arquivos
  for dotfile in dotfiles/.*[a-z]; do
    home_file=$(basename $dotfile)
    dotfile="$(pwd)/$dotfile"

    # se o arquivo já existir no $HOME, delete
    if [ -L ~/$home_file ];then
      rm ~/$home_file
    fi

    ln -s "$dotfile" ~/$home_file
  done
}

# linkando os arquivos de configuração
link_config_tools(){
  for config in config/*; do
    home_file=$HOME/.config/$(basename $config)
    config="$(pwd)/$config"

    # se o arquivo já existir no $HOME, delete
    if [ -d "$home_file" ];then
      rm -rf "$home_file"
    fi

    ln -s "$config" "$home_file"
  done
}


link_albert_file(){
  # linkando o arquivo de configuração do albert
  if [ -d "$HOME/.config/albert" ];then
      test -e "$HOME/.config/albert/albert.conf" && rm -rf $_
      ln -s "$(pwd)/albert/albert.conf" "$HOME/.config/albert/albert.conf"
  fi
}

# carregando o frankrc
link_frankrc(){
  local load_frankrc='
  # carregando minhas configs (alias, functions...)
  test -f ~/.frankrc && . ~/.frankrc
  '

  if ! grep -q "~/.frankrc" ~/.bashrc ;then
    echo "$load_frankrc" >> ~/.bashrc
  fi
}

# movendo o arquivo de credenciais para o $HOME
link_git_config(){
  if [ ! -f ~/.gitconfig.local ];then
    cp .gitconfig.local.template ~/.gitconfig.local
    vim ~/.gitconfig.local
  fi
}

# movendo as configurações do Atom para ~/.atom
link_atom_configs(){
  if [ -e $HOME/.atom/config.cson ];then
    rm $HOME/.atom/config.cson
  fi
  ln -s $(pwd)/atom/config.cson $HOME/.atom
}

# criando uma chave genérica de SSH, pra ser executado a primeira vez
create_ssh_key(){
  if [ ! -f ~/.ssh/id_rsa.pub ];then
    # -q --> is silent
    # -t rsa --> generate key
    # -N '' --> tells to use empty passphrase
    # -f <file> --> the file with new key
    ssh-keygen -q -t rsa -N '' -f ~/.ssh/id_rsa > /dev/null
  fi
}


link_dotfiles
link_frankrc
link_config_tools
link_albert_file
link_atom_configs
link_git_config
create_ssh_key

echo "dotfiles instalados =D"
