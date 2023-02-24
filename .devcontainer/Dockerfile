# Dockerfile for building software development image.
# Reference: https://docs.docker.com/engine/reference/builder/

# ========== Python development image ==========
FROM ubuntu:lunar AS devenv

# Install prerequisite apps
# Append here OS level software required for development
RUN apt-get update && \
    apt-get install -y \
    git curl make python3.11 python3.11-venv

# Create non-root developer user
ARG USERNAME=dev
RUN useradd --create-home --shell /bin/bash $USERNAME

USER $USERNAME

# Set locale
ENV LC_ALL=C

# Setup virtual environment with pip-tools
ENV VIRTUAL_ENV=/home/$USERNAME/.venv
RUN python3.11 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"
RUN pip install --upgrade pip pip-tools wheel

# Run command (This is overridden in docker-compose.dev.yml)
CMD "/bin/bash"
