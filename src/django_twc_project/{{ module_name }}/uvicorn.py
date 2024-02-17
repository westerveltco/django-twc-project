from __future__ import annotations

from uvicorn.workers import UvicornWorker as BaseUvicornWorker


class UvicornWorker(BaseUvicornWorker):
    CONFIG_KWARGS = {
        # Django does not support Lifespan Protocol
        # https://asgi.readthedocs.io/en/latest/specs/lifespan.html
        # https://github.com/django/django/pull/13636
        # https://code.djangoproject.com/ticket/31508
        # Using uvicorn.workers.UvicornWorker throws INFO warning:
        #   "ASGI 'lifespan' protocol appears unsupported."
        "lifespan": "off",
    }
