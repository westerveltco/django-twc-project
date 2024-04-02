#!/bin/sh

tailscaled --state=/var/lib/tailscale/tailscaled.state --socket=/var/run/tailscale/tailscaled.sock &
tailscale up --authkey=${TAILSCALE_AUTHKEY} --hostname=${FLY_APP_NAME}-${FLY_REGION}-${FLY_MACHINE_ID} --advertise-tags=tag:flyio
