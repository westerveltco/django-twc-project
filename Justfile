set dotenv-load := true

@_default:
    just --list

generate-example DATA_FILE:
    rye run copier copy . {{ trim_end_match(DATA_FILE, '.yml') }} --force --data-file {{ DATA_FILE }}

# ----------------------------------------------------------------------
# UTILS
# ----------------------------------------------------------------------

# format justfile
fmt:
    just --fmt --unstable

# run pre-commit on all files
lint:
    pre-commit run --all-files
