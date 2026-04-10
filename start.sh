#!/bin/bash

echo "Starting Tailscale daemon in userspace networking mode..."
# Render doesn't allow /dev/net/tun, so userspace-networking is required
tailscaled --tun=userspace-networking --socks5-server=localhost:1055 &

# Wait a few seconds for the daemon to initialize
sleep 5

echo "Authenticating Tailscale..."
if [ -z "$TAILSCALE_AUTHKEY" ]; then
  echo "Error: TAILSCALE_AUTHKEY environment variable is not set."
else
  # Bring Tailscale up with your Auth Key
  tailscale up --authkey="${TAILSCALE_AUTHKEY}" --hostname="render-stremio-bot" --ssh --accept-routes
  
  echo "Configuring Tailscale funnel..."
  # Funnel exposes the local port to the public internet via your Tailscale domain
  # The '&' puts it in the background so the Python app can start
  tailscale funnel localhost:8001 &
fi

echo "Starting the main application..."
uv run update.py && uv run -m Backend
