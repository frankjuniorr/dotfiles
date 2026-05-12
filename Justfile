set shell := ["bash", "-c"]

export VAULT_PASS_FILE := home_dir() + "/.config/homelab-iac/.vault_pass"

ansible_cmd := "ansible-playbook -i " + quote(invocation_directory() + "/src/hosts.ini") + " --vault-password-file " + VAULT_PASS_FILE

# Instala git hooks
install-hooks:
	@echo "Installing git pre-commit hook..."
	@cp -f scripts/pre-commit.sh .git/hooks/pre-commit
	@chmod +x .git/hooks/pre-commit
	@echo "Hook installed successfully."

iac-proxmox:
	@cd iac && bash iac-proxmox.sh

############################################################################
# SECRETS (Ansible-Vault)
############################################################################
# Cria um novo arquivo de senha para o vault se não existir em ~/.config/homelab-iac/.vault_pass
secrets-keygen:
	@test ! -d ~/.config/homelab-iac && mkdir -p ~/.config/homelab-iac || true
	@test ! -f {{VAULT_PASS_FILE}} && openssl rand -base64 32 > {{VAULT_PASS_FILE}} && chmod 600 {{VAULT_PASS_FILE}} || echo "Vault password file already exists"

# Criptografa o vault.yml (garante segurança no Git)
secrets-encrypt:
	@if ! grep -q "\$ANSIBLE_VAULT" src/group_vars/all/vault.yml; then \
		ansible-vault encrypt src/group_vars/all/vault.yml --vault-password-file {{VAULT_PASS_FILE}} && echo "vault.yml encrypted"; \
	else \
		echo "vault.yml already encrypted"; \
	fi

# Abre o vault.yml criptografado diretamente no editor padrão
secrets-edit:
	@ansible-vault edit src/group_vars/all/vault.yml --vault-password-file {{VAULT_PASS_FILE}}

# Descriptografa o vault.yml permanentemente (use com cautela)
secrets-decrypt:
	@if grep -q "\$ANSIBLE_VAULT" src/group_vars/all/vault.yml; then \
		ansible-vault decrypt src/group_vars/all/vault.yml --vault-password-file {{VAULT_PASS_FILE}} && echo "vault.yml decrypted"; \
	else \
		echo "vault.yml is already decrypted"; \
	fi

# Apenas visualiza os segredos descriptografados no terminal
secrets-view:
	@ansible-vault view src/group_vars/all/vault.yml --vault-password-file {{VAULT_PASS_FILE}}

############################################################################
# UTILS
############################################################################
# Liga/Desliga o plugin de saída estética (beautiful_output) para visualização ou debug
plugin state:
	@if [ "{{state}}" == "on" ]; then \
		sed -i '/^# *stdout_callback = beautiful_output/s/^# *//' src/ansible.cfg; \
		echo "Plugin 'beautiful_output' ATIVADO."; \
	elif [ "{{state}}" == "off" ]; then \
		sed -i '/^stdout_callback = beautiful_output/s/^/# /' src/ansible.cfg; \
		echo "Plugin 'beautiful_output' DESATIVADO."; \
	else \
		echo "Use: just plugin on ou just plugin off"; \
	fi
