justfile := justfile_directory() + "/.just/project.just"

[private]
default:
    @just --list --justfile {{ justfile }}

[private]
fmt:
    @just --fmt --justfile {{ justfile }}

# Remove all installed dependencies, caches, and generated files
[no-cd]
clean:
    #!/usr/bin/env bash
    set -euo pipefail
    for dir in \
        "$VIRTUAL_ENV" \
        .mypy_cache \
        .pytest_cache \
        .ruff_cache \
        htmlcov \
        node_modules; do
            [ -d "$dir" ] && rm -rf "$dir"
    done
    find . -name "__pycache__" -exec rm -rf {} +

# Create .env file from .env.example, if it doesn't exist
[no-cd]
envfile:
    #!/usr/bin/env python
    from pathlib import Path

    envfile = Path("{{ justfile_directory() }}/.env")
    envfile_example = Path("{{ justfile_directory() }}/.env.example")

    if not envfile.exists():
        envfile.write_text(envfile_example.read_text())

# Sync .env file back to .env.example
[no-cd]
envsync: envfile
    #!/usr/bin/env python
    from pathlib import Path

    envfile = Path("{{ justfile_directory() }}/.env")
    envfile_example = Path("{{ justfile_directory() }}/.env.example")

    with envfile.open() as f:
        lines = [line for line in f.readlines() if not line.endswith("# envsync: ignore\n")]
        lines = [
            line.split("=")[0] + "=\n" if line.endswith("# envsync: no-value\n") else line
            for line in lines
        ]

        lines.sort()
        envfile_example.write_text("".join(lines))

[no-cd]
[private]
install-precommit: install-uv
    $python -m uv pip install -c {{ justfile_directory() }}/requirements.txt pre-commit
    $python -m pre_commit install --install-hooks

[no-cd]
[private]
install-uv:
    $python -m pip install --upgrade uv

# Format justfile
just-fmt:
    @just --fmt
    @just copier fmt
    @just dj fmt
    @just docker fmt
    @just docs fmt
    @just node fmt
    @just pg fmt
    @just project fmt
    @just py fmt

# Run pre-commit on all files
[no-cd]
lint: install-precommit
    $python -m pre_commit run --all-files
    @just project just-fmt

# Setup project scaffolding
setup:
    @just project envfile
    @just py venv
    @just project install-uv
    @just project install-precommit
