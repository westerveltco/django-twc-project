set dotenv-load := true

@_default:
    just --list

examples:
    pipx run copier copy {{ justfile_directory() }} {{ justfile_directory() }}/examples --force --data-file defaults.yml

# ----------------------------------------------------------------------
# UTILS
# ----------------------------------------------------------------------

# format justfile
fmt:
    just --fmt --unstable

# run pre-commit on all files
lint:
    pre-commit run --all-files
