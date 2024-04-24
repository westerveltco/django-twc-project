from __future__ import annotations

import secrets

from copier_templates_extensions import ContextHook


class SecretKey(ContextHook):
    def hook(self, context):
        context["secret_key"] = secrets.token_hex(32)
        return context
