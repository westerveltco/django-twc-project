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


class Dependencies(ContextHook):
    @override
    def hook(self, context: dict[str, object]) -> dict[str, object]:
        context["python_dependencies"] = self.get_python_dependencies(context)
        context["python_dev_dependencies"] = self.get_python_dev_dependencies(context)
        context["python_doc_dependencies"] = self.get_python_doc_dependencies(context)
        context["node_dependencies"] = self.get_node_dependencies(context)
        return context

    def get_python_dependencies(self, context):
        deps = cast(list[str], context["python_dependencies"])

        final_deps = [*deps]

        if "django-q2" in deps:
            final_deps.append("croniter")

        if context["include_twc_ui"]:
            token = context["twc_ui_token"]
            version = context["twc_ui_version"]
            extras = context["twc_ui_extras"]
            if extras:
                extras = f"[{','.join(extras)}]"
            else:
                extras = ""
            final_deps.append(
                f"django-twc-ui{extras} @ git+https://{token}:x-oauth-basic@github.com/westerveltco/django-twc-ui.git@v{version}"
            )

        lines = []

        for dep in sorted(final_deps):
            if dep == "django-email-relay":
                lines.append(
                    "# upper bounds for `django-email-relay` since it runs distributed"
                )
                lines.append(
                    "# https://django-email-relay.westervelt.dev/en/latest/updating.html"
                )
                version = context["email_relay_version"]
                dep = f"{dep}<{version}"

            elif dep == "django-storages":
                lines.append(
                    "# https://github.com/revsys/django-health-check/issues/434"
                )
                lines.append(
                    "# https://github.com/jschneier/django-storages/issues/1430"
                )
                dep = f"{dep}<1.14.4"

            elif dep == "django-twc-toolbox":
                extras = context["twc_toolbox_extras"]
                if extras:
                    dep = f"{dep}[{','.join(extras)}]"

            elif dep == "psycopg[binary]":
                django_version = context["django_version"]
                # TODO: make this more robust by turning string to float or version tuple
                # to help with future versions
                if django_version == "5.1":
                    dep = f"{dep[:-1]},pool]"

            lines.append(dep)

        return self._generate_string(lines)

    def get_python_dev_dependencies(self, context):
        deps = cast(list[str], context["python_dev_dependencies"])
        pydeps = cast(list[str], context["python_dependencies"])

        final_deps = [*deps]

        if "django-q2" in pydeps:
            # croniter is included if django-q2 is chosen
            final_deps.append("types-croniter")
        if "openpyxl" in pydeps:
            final_deps.append("types-openpyxl")

        lines = []

        for dep in sorted(final_deps):
            if dep == "playwright":
                version = context["playwright_version"]
                dep = f"{dep}=={version}"

            lines.append(dep)

        return self._generate_string(lines)

    def get_python_doc_dependencies(self, context):
        deps = cast(list[str], context["python_doc_dependencies"])
        return self._generate_string(deps)

    def get_node_dependencies(self, context):
        deps = cast(list[str], context["node_dependencies"])
        final_deps = []
        if "tailwindcss" in deps:
            ...

        return self._generate_string(deps)

    def _generate_string(self, lines, leading_spaces=2):
        ret = ""

        for idx, line in enumerate(lines):
            for space in leading_spaces:
                ret += " "
            if line.startswith("#"):
                ret += line
            else:
                ret += f'  "{line}"'
                if idx + 1 != len(lines):
                    ret += ","
            if idx + 1 != len(lines):
                ret += "\n"

        return ret
