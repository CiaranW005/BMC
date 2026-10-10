#!/usr/bin/env bash

set -euo pipefail

DEPLOY_DIR="/home/ubuntu/deploy"
ENV_FILE="/home/ubuntu/.config/bmc-oracle/.env"

echo "Installing backend..."

sudo install \
    -m 755 \
    "$DEPLOY_DIR/oracle-server/bmc-oracle" \
    /usr/local/bin/bmc-oracle


echo "Installing frontend..."

sudo mkdir -p /var/www/bmc
sudo rm -rf /var/www/bmc/*
sudo cp -r "$DEPLOY_DIR/frontend/dist/"* /var/www/bmc/


echo "Installing systemd service..."

sudo cp \
    "$DEPLOY_DIR/deployment/systemd/bmc-oracle.service" \
    /etc/systemd/system/bmc-oracle.service

sudo systemctl daemon-reload


echo "Installing Caddy configuration..."

sudo cp \
    "$DEPLOY_DIR/deployment/caddy/Caddyfile" \
    /etc/caddy/Caddyfile

sudo caddy validate --config /etc/caddy/Caddyfile


echo "Updating Google authentication configuration..."

# Ensure GitHub Actions supplied both variables.
: "${GOOGLE_CLIENT_ID:?GOOGLE_CLIENT_ID is missing}"
: "${GOOGLE_ALLOWED_SUBS:?GOOGLE_ALLOWED_SUBS is missing}"

# Preserve existing configuration.
mkdir -p "$(dirname "$ENV_FILE")"
touch "$ENV_FILE"
chmod 600 "$ENV_FILE"

set_env() {
    local key="$1"
    local value="$2"

    # These variables should contain only the expected characters.
    if [[ ! "$value" =~ ^[A-Za-z0-9._,@-]+$ ]]; then
        echo "Invalid value for $key" >&2
        exit 1
    fi

    # Remove existing definitions and append the updated value.
    sed -i "/^${key}=/d" "$ENV_FILE"
    printf '%s=%s\n' "$key" "$value" >> "$ENV_FILE"
}

set_env "GOOGLE_CLIENT_ID" "$GOOGLE_CLIENT_ID"
set_env "GOOGLE_ALLOWED_SUBS" "$GOOGLE_ALLOWED_SUBS"


echo "Restarting services..."

sudo systemctl restart bmc-oracle
sudo systemctl reload caddy


echo "Deployment complete."