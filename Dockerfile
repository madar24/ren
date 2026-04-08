# Use a generic standard Python image instead of the astral-sh base image 
FROM python:3.11-slim

# Set generic environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1
ENV LANG=en_US.UTF-8

# Install system dependencies
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

# Install uv manually to mask the environment, then install dependencies
RUN pip install uv && uv sync --locked

# Avoid bash execution wrappers which Render sometimes blocks
CMD ["uv", "run", "python", "-m", "Backend"]
