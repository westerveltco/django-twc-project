justfile := justfile_directory() + "/.just/python.just"

[private]
default:
    @just --list --justfile {{ justfile }}

[private]
fmt:
    @just --fmt --justfile {{ justfile }}

# Run the Playwright codegen command within the 'app' container
codegen *ARGS:
    @just docker run app "-e DJANGO_VITE_DEV_SERVER_HOST=node" "python manage.py runserver 0.0.0.0:8000 & while ! curl -s http://0.0.0.0:8000 > /dev/null; do sleep 1; done; playwright codegen {{ ARGS }}; kill %1"

# Run the test suite, generate code coverage, and export html report
coverage-html: test
    rm -rf htmlcov
    @just docker command python -m coverage html --skip-covered --skip-empty

# Run the test suite, generate code coverage, and print report to stdout
coverage-report: test
    @just docker command python -m coverage report

# Install dependencies
[no-cd]
install *ARGS:
    $python -m uv pip install {{ ARGS }} -r requirements.txt

# Generate requirements.txt file
[no-cd]
lock *ARGS:
    $python -m uv pip compile {{ ARGS }} --generate-hashes requirements.in --output-file requirements.txt

# Run tests using pytest within the 'app' container, with optional arguments
test *ARGS:
    @just docker run app "-e DJANGO_VITE_DEV_SERVER_HOST=node" pytest {{ ARGS }}

# Run tests with Playwright debug mode enabled, in the 'app' container, with optional arguments
test-debug *ARGS:
    @just docker run app "-e DJANGO_VITE_DEV_SERVER_HOST=node -e PWDEBUG=1" pytest {{ ARGS }}

# Run mypy on project
[no-cd]
types:
    @just docker command python -m mypy

# Update dependencies
update:
    @just py install --upgrade

# Generate and upgrade dependencies
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
