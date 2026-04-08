FROM ghcr.io/astral-sh/uv:debian-slim

# Set generic environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1
ENV LANG=en_US.UTF-8
ENV PATH="/app/.venv/bin:$PATH"

# Install system dependencies and clean up caches to reduce image signature
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        build-essential \
        bash \
        git \
        curl \
        ca-certificates \
        locales && \
    locale-gen en_US.UTF-8 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy the application code
COPY . .

# Install Python dependencies using uv
RUN uv lock && uv sync --locked

CMD ["bash", "-c", "uv run -m Backend"]
