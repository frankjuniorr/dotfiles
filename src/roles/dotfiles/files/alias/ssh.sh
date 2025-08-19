#################################################################
# SSH Functions
#################################################################

alias servers="sshs --config ~/.ssh/config"

ssh_create_new_key() {
  key_name=$1
  ssh_key_comment="$2"

  help_msg="
    Informe os parâmetros corretos:
    - Nome do arquivo da chave ssh
    - texto do comentário

    ex: $0 'minha_chave' 'meu_comentario'
    "

  if [ -z $key_name ] || [ -z $ssh_key_comment ]; then
    echo "$help_msg"
    return 1
  fi

  ssh_key_file="${HOME}/.ssh/id_ed25519_${key_name}"
  # -t rsa: O tipo de algoritmo usado, o RSA
  # -b 4096: O tamanho da chave em bits
  # -N '': diz para criar um empty passprashe
  # -C <comentário>: Adiciona um comentário a chave.
  # -f <file>: Nome do arquivo que será salvo a chave
  if [ ! -f $ssh_key_file ]; then
    ssh-keygen -t ed25519 -b 4096 -N '' -C "$ssh_key_comment" -f "$ssh_key_file"
  fi
  echo "OK: chave $ssh_key_file criada em: $HOME/.ssh"
}

# ----------------------------------------------------------------------
ssh_new_host() {
  public_key_file="$1"
  host_user="$2"
  host_ip="$3"

  help_msg="
    Informe os parâmetros corretos:
    - Arquivo da chave pública do ssh
    - usuário do host
    - IP do host

    ex: $0 '~/.ssh/id_rsa.pub' 'user' '192.168.0.999'
    "

  if [ -z $public_key_file ] || [ -z $host_user ] || [ -z $host_ip ]; then
    echo "$help_msg"
    return 1
  fi

  if [ ! -f "$public_key_file" ]; then
    echo "$public_key_file não é um arquivo válido"
    return 1
  fi

  filename=$(basename -- "$public_key_file")
  extension="${filename##*.}"
  if [ "$extension" != "pub" ]; then
    echo "Selecione a chave ssh pública (.pub)"
    return 1
  fi

  ssh-copy-id -i "$public_key_file" "${host_user}@${host_ip}"

  ssh_private_key="${public_key_file%.*}" #sem extensão
  ssh_config_file="${HOME}/.ssh/config"
  echo "
Host <ALTERE_AQUI>
    User $host_user
    HostName $host_ip
    IdentityFile $ssh_private_key
    " >>$ssh_config_file

  line_number=$(grep -n "ALTERE_AQUI" $ssh_config_file | cut -d ':' -f1)
  vim +${line_number} $ssh_config_file

  echo "Arquivo $ssh_config_file atualizado com sucesso."
}

# ----------------------------------------------------------------------
ssh_list_hosts() {
  grep ^Host ~/.ssh/config | awk '{print $2}'
}

# ----------------------------------------------------------------------
ssh_shutdown_all_vms() {
  # all_hosts=$(grep 'HostName' ~/.ssh/config | awk '{print $2}')
  all_hosts=($(ssh_list_hosts))

  for vm in $all_hosts; do
    ssh -t $vm 'sudo shutdown -h now'
  done
}
