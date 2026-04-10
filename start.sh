#!/bin/bash

# 1. Force the dummy HTTP server to use IPv4 so Render stays happy
python3 -m http.server ${PORT:-10000} --bind 0.0.0.0 --directory /tmp &

# 2. Start Tailscale WITHOUT the SOCKS5 server to stop the log spam
tailscaled --tun=userspace-networking &
sleep 5

# 3. Authenticate to Tailscale as an ephemeral machine
tailscale up --auth-key="${TAILSCALE_AUTHKEY}" --hostname="render-r-stream" --ssh  &
sleep 10

tailscale serve localhost:8001

# 5. Hide Python from the dummy server port
export PORT=8001

# 6. Start the bot
uv run -m Backend
