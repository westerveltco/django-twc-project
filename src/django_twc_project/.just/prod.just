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
    fly ssh console --pty -C '{{ COMMAND }}'

# Open a bash console within the application host
[no-cd]
console:
    fly ssh console

# Display the most recent logs for the application
[no-cd]
logs:
    fly logs --no-tail

# Run a Django management command
[no-cd]
manage *COMMAND:
    @just prod command python -m manage {{ COMMAND }}

# Open an interative Django shell within the application host
[no-cd]
shell:
    @just prod manage shell_plus

# Follow the logs for the application
[no-cd]
tail:
    fly logs
