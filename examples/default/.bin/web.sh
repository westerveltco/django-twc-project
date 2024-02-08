#!/bin/sh

cd /app
/tailscale.sh
gosu django python -m gunicorn default.wsgi:application --config python:default.gunicorn
