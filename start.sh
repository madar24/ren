#!/bin/bash

# 1. Start Tailscale background daemon
tailscaled --tun=userspace-networking --socks5-server=localhost:1055 &
sleep 5

# 2. Authenticate to Tailscale using your Render Environment Variable
tailscale up --auth-key="${TAILSCALE_AUTHKEY}" --hostname="singapore-madar24-stream" --advertise-exit-node &
sleep 10

# 3. Auto-generate SSL certificates and save them with a fixed name
HOSTNAME=$(tailscale status --json | jq -r .Self.DNSName | sed 's/\.$//')
echo "Generating SSL certs for $HOSTNAME..."
tailscale cert --cert-file /app/ts.crt --key-file /app/ts.key "$HOSTNAME"

# 4. Start the R-stream bot
uv run update.py && uv run -m Backend
