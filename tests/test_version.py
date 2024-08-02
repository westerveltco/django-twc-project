from __future__ import annotations

from pathlib import Path

BASE_DIR = Path(__file__).parent.parent


def test_VERSION_version():
    file = BASE_DIR / "VERSION"
    with open(file, encoding="utf-8") as f:
        version = f.read().strip()

    assert version == "2024.42"
