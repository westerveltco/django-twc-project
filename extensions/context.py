from __future__ import annotations

import secrets
import sys
from typing import cast

if sys.version_info >= (3, 12):
    from typing import override
else:
    from typing_extensions import override

from copier_templates_extensions import ContextHook


class SecretKey(ContextHook):
    @override
    def hook(self, context: dict[str, object]) -> dict[str, object]:
        context["secret_key"] = secrets.token_hex(32)
        return context


class DjangoNextVersion(ContextHook):
    @override
    def hook(self, context: dict[str, object]) -> dict[str, object]:
        django_version = cast(str, context["django_version"])
        context["django_next_version"] = self.get_next_version(django_version)
        return context

    def get_next_version(self, django_version: str) -> str:
        version_parts = django_version.split(".")

        major_release = int(version_parts[0])
        point_release = int(version_parts[-1])

        if point_release == 0:
            next_version = f"{major_release}.1"
        elif point_release == 1:
            next_version = f"{major_release}.2"
        elif point_release == 2:
            next_version = f"{major_release + 1}.0"
        else:
            raise ValueError(f"Unknown django version: {django_version}")

        return next_version
