#!/bin/sh

cd /app
/tailscale.sh
python -m manage migrate --noinput
