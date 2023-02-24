# Dockerfile for building production ready software image.
# The size of final image may drastically change depending on how it is built.
# Reference: https://docs.docker.com/engine/reference/builder/

# ========== Python builder ==========
FROM python:3.11-slim AS python

ENV PIP_NO_CACHE_DIR=1

# Setup virtual environment and upgrade pip
RUN python -m venv /opt/venv
RUN /opt/venv/bin/pip install --upgrade pip

# Install requirements
COPY requirements/prod.txt requirements.txt
RUN /opt/venv/bin/pip install -r requirements.txt

# Start building the final image from fresh python:3.11-slim image
# ========== Final image ==========
FROM python:3.11-slim AS final

# Set working directory within the container
WORKDIR /code

# Copy Python venv with requirements installed from the Python builder image above
COPY --from=python /opt /opt
# Set virtualenv path as Python path
ENV VIRTUAL_ENV=/opt/venv
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

# Copy required project files
COPY example/main.py .

# Set environment variables so that Python prints are visible
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# Run service
ENTRYPOINT ["python", "main.py"]