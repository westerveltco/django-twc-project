justfile := justfile_directory() + "/.just/prod.just"

[private]
default:
    @just --list --justfile {{ justfile }}

[private]
fmt:
    @just --fmt --justfile {{ justfile }}

# Run a command on application host
[no-cd]
command *COMMAND:
    @just console --pty -C '{{ COMMAND }}'

# Open a bash console within the application host
[no-cd]
console *ARGS:
    flyctl ssh console {{ ARGS }}

# Deploy the application
[no-cd]
deploy *ARGS:
    flyctl deploy {{ ARGS }}

# Display the most recent logs for the application
[no-cd]
logs:
    flyctl logs --no-tail

# Run a Django management command
[no-cd]
manage *COMMAND:
    @just prod command python -m manage {{ COMMAND }}

# Open an interative Django shell within the application host
[no-cd]
shell:
    @just prod manage shell_plus

# Stage secrets needed for deployment
[no-cd]
secrets:
    op inject -i .env.prod | xargs flyctl secrets set --stage

# Follow the logs for the application
[no-cd]
tail:
    flyctl logs
