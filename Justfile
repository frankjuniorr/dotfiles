set shell := ["bash", "-c"]

ansible_cmd := "ansible-playbook -i " + quote(invocation_directory() + "/src/hosts.ini")

image        := "frank-env"
registry_img := "ghcr.io/frankjuniorr/dotfiles-env"
docker_gid   := `stat -c '%g' /var/run/docker.sock`

# Instala git hooks
install-hooks:
	@echo "Installing git pre-commit hook..."
	@cp -f scripts/pre-commit.sh .git/hooks/pre-commit
	@chmod +x .git/hooks/pre-commit
	@echo "Hook installed successfully."

############################################################################
# DOCKER (personal-busybox)
############################################################################
# Build the CLI image locally (BuildKit enabled)
docker-build:
	DOCKER_BUILDKIT=1 docker build \
		-t {{image}} .

# Force a clean rebuild from scratch (bypasses all Docker layer cache)
docker-rebuild: docker-clean
	DOCKER_BUILDKIT=1 docker build \
		--no-cache \
		-t {{image}} .

# Run smoke tests (builds first if needed)
docker-smoke: docker-build
	@scripts/smoke-test.sh {{image}}

# Start container via docker-compose with the locally built image
docker-up-local: docker-build
	FRANK_ENV_IMAGE={{image}} DOCKER_GID={{docker_gid}} docker compose up -d

# Start container via docker-compose with the registry image (default)
docker-up:
	DOCKER_GID={{docker_gid}} docker compose up -d

# Enter the running container (attaches to or creates tmux session)
docker-enter:
	docker exec -it frank-env tmux new-session -As main

# Pull latest image from ghcr.io
docker-pull:
	docker compose pull

# Stop and remove the container
docker-down:
	docker compose down

# Remove container + local image (forces a full rebuild on next docker-build)
docker-clean:
	docker compose down 2>/dev/null || true
	docker rmi {{image}} 2>/dev/null || true

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
