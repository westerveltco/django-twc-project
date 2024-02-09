from __future__ import annotations

from pathlib import Path
import yaml

BASE_DIR = Path(__file__).parent.parent


def test_copier_yml_version():
    file = BASE_DIR / "copier.yml"
    with open(file, encoding="utf-8") as f:
        copier_yml = yaml.safe_load(f)

    version = copier_yml["template_version"]["default"]

    assert version == "2024.1"


def test_VERSION_version():
    file = BASE_DIR / "VERSION"
    with open(file, encoding="utf-8") as f:
        version = f.read().strip()

    assert version == "2024.1"
