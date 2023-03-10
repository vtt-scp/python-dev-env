# Reference: https://www.gnu.org/software/make/manual/make.html
SHELL=/bin/bash

# Ensure requirements is always done when called (otherwise make may consider it "up to date")
.PHONY: requirements

# Generate requirements files (run in .venv)
requirements:
	pip-compile --generate-hashes --resolver backtracking -o requirements/prod.txt pyproject.toml
	pip-compile --generate-hashes --extra dev --resolver backtracking -o requirements/dev.txt pyproject.toml

# Synchronise requirements to virtual environment (run in .venv)
sync:
	pip-sync requirements/dev.txt requirements/prod.txt

# Build Docker images for services in docker-compose.yml
build:
	docker compose build

# Run services in docker-compose.yml
up:
	docker compose up

# Stop services in docker-compose.yml
down:
	docker compose down