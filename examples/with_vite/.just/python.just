justfile := justfile_directory() + "/.just/python.just"

[private]
default:
    @just --list --justfile {{ justfile }}

[private]
fmt:
    @just --fmt --justfile {{ justfile }}

# Run the Playwright codegen command within the 'app' container
[no-cd]
codegen *ARGS:
    @just docker run app "-e DJANGO_VITE_DEV_SERVER_HOST=node" "python manage.py runserver 0.0.0.0:8000 & while ! curl -s http://0.0.0.0:8000 > /dev/null; do sleep 1; done; playwright codegen {{ ARGS }}; kill %1"

# Generate most recent code coverage report in HTML format
[no-cd]
cov-html:
    rm -rf htmlcov
    @just docker command python -m coverage html --skip-covered --skip-empty

# Print most recent code coverage report
[no-cd]
cov-report:
    @just docker command python -m coverage report

# Install dependencies
[no-cd]
install *ARGS:
    $python -m uv pip install {{ ARGS }} --constraint requirements.txt --requirement pyproject.toml --extra dev

# Generate requirements.txt file
[no-cd]
lock *ARGS:
    $python -m uv pip compile pyproject.toml --output-file requirements.txt --generate-hashes {{ ARGS }}

# Run tests using pytest within the 'app' container, with optional arguments
[no-cd]
test *ARGS:
    @just docker command python -m coverage erase
    @just docker run app "-e DJANGO_VITE_DEV_SERVER_HOST=node" python -m pytest {{ ARGS }}

# Run tests with Playwright debug mode enabled, in the 'app' container, with optional arguments
[no-cd]
test-debug *ARGS:
    @just docker run app "-e DJANGO_VITE_DEV_SERVER_HOST=node -e PWDEBUG=1" pytest {{ ARGS }}

# Run mypy on project
[no-cd]
types:
    @just docker command python -m mypy

# Update dependencies
[no-cd]
update:
    @just py install --upgrade

# Generate and upgrade dependencies
[no-cd]
upgrade:
    @just py lock --upgrade

# Create virtual environment and install Python dependency tools
[no-cd]
venv:
    #!/usr/bin/env bash
    set -euo pipefail
    if ! [ -d $VIRTUAL_ENV ]; then
        if command -v uv &>/dev/null; then
            uv venv --seed $VIRTUAL_ENV
        else
            $system_python -m venv $VIRTUAL_ENV
        fi
    fi
