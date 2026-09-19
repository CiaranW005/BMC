#!/usr/bin/env bash

set -e

DEPLOY_DIR="/home/ubuntu/deploy"

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


echo "Restarting services..."

sudo systemctl restart bmc-oracle
sudo systemctl reload caddy


echo "Deployment complete."