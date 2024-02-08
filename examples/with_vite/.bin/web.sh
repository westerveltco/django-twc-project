#!/bin/sh

cd /app
/tailscale.sh
gosu django python -m gunicorn with_vite.wsgi:application --config python:with_vite.gunicorn
