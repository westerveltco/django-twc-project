justfile := justfile_directory() + "/.just/docker.just"

[private]
default:
    @just --list --justfile {{ justfile }}

[private]
fmt:
    @just --fmt --justfile {{ justfile }}

# Build services using docker compose
[no-cd]
build *ARGS:
    docker compose build {{ ARGS }}

# Build production stack using docker compose
[no-cd]
build-prod:
    docker compose -f compose.yml -f compose.prod.yml build

# Stop and remove all containers, networks, images, and volumes
[no-cd]
clean:
    #!/usr/bin/env bash
    [[ ! -f .env ]] && just project envfile
    @just docker down --volumes --rmi local

# Run a command within the 'app' container
command *ARGS:
    @just docker run app "" "/bin/bash -c '{{ ARGS }}'"

# Stop and remove all containers defined in docker compose
[no-cd]
down *ARGS:
    docker compose down {{ ARGS }}

# Display the logs for containers, optionally using provided arguments (e.g., --follow)
[no-cd]
logs *ARGS:
    docker compose logs {{ ARGS }}

# Display the running containers and their statuses
[no-cd]
ps:
    docker compose ps

# Pull the latest versions of all images defined in docker compose
[no-cd]
pull:
    docker compose pull

# Restart services, optionally targeting specific ones
[no-cd]
restart *ARGS:
    docker compose restart {{ ARGS }}

# Run a command within the specified container with command-line flags
[no-cd]
run CONTAINER FLAGS *ARGS:
    docker compose run --rm {{ FLAGS }} {{ CONTAINER }} {{ ARGS }}

# Start development stack using docker compose
start:
    @just docker up --detach

# Start the full production stack using docker compose
start-prod:
    @just docker up-prod --detach

# Stop services by calling the 'down' command
stop:
    @just docker down

# Continuously follow the latest docker logs, optionally targeting specific containers
tail *ARGS:
    @just docker logs --follow {{ ARGS }}

# Start development stack using docker compose, with optional arguments
[no-cd]
up *ARGS:
    docker compose up {{ ARGS }}

# Start the full production stack using docker compose
[no-cd]
up-prod *ARGS:
    docker compose -f compose.yml -f compose.prod.yml up {{ ARGS }}
