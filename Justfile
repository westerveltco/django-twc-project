set dotenv-load := true

@_default:
    just --list

# ----------------------------------------------------------------------
# EXAMPLES
# ----------------------------------------------------------------------

@generate-examples:
    for file in `ls examples/*.yml`; do \
        just _generate-example $file; \
    done
    @just lint

_generate-example DATA_FILE:
    #!/usr/bin/env bash

    set -euo pipefail

    DIRECTORY="{{ trim_end_match(DATA_FILE, '.yml') }}"
    rm -rf $DIRECTORY

    COMMAND="copier copy -r HEAD . $DIRECTORY --force --trust --data-file {{ DATA_FILE }}"
    if [ -z "$(command -v rye)" ]; then
        eval $COMMAND
    else
        rye run $COMMAND
    fi

# ----------------------------------------------------------------------
# UTILS
# ----------------------------------------------------------------------

# format justfile
fmt:
    just --fmt --unstable

# run pre-commit on all files
lint:
    pre-commit run --all-files

# run djlint through template html
djlint:
    rye run djlint --reformat --indent 2 --profile django src/django_twc_project
