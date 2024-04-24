#!/bin/sh

cd /app
/tailscale.sh
gosu django python /app/manage.py qcluster
