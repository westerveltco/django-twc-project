set dotenv-load := true
set unstable := true

justfile := justfile_directory() + "/.just/documentation.just"

[private]
default:
    @just --list --justfile {{ justfile }}

[private]
fmt:
    @just --fmt --justfile {{ justfile }}

# Build documentation using Sphinx
[no-cd]
build LOCATION="docs/_build/html": cog
    sphinx-build docs {{ LOCATION }}

# Install documentation dependencies
[no-cd]
install *ARGS:
    $python -m uv pip install {{ ARGS }} --constraint requirements.txt --requirement pyproject.toml --extra docs

# Serve documentation locally
[no-cd]
serve: cog
    #!/usr/bin/env sh
    if [ -f "/.dockerenv" ]; then
        sphinx-autobuild docs docs/_build/html --host "0.0.0.0"
    else
        sphinx-autobuild docs docs/_build/html --host "localhost"
    fi

# Generate and upgrade documentation dependencies
[no-cd]
upgrade:
    @just docs lock --upgrade

[no-cd]
[private]
cog:
    cog -r docs/just.md
