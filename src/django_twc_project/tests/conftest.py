from __future__ import annotations

import logging
import os

pytest_plugins = []


def pytest_configure(config):
    logging.disable(logging.CRITICAL)
    os.environ["DJANGO_SETTINGS_MODULE"] = "tests.settings"
