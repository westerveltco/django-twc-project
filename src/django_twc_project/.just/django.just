justfile := justfile_directory() + "/.just/django.just"

[private]
default:
    @just --list --justfile {{ justfile }}

[private]
fmt:
    @just --fmt --justfile {{ justfile }}

# Run a Django management command
[no-cd]
manage *COMMAND:
    @just docker command python -m manage {{ COMMAND }}

[no-cd]
alias mm := makemigrations

# Generate Django migrations
[no-cd]
makemigrations *APPS:
    @just dj manage makemigrations {{ APPS }}

# Run Django migrations
[no-cd]
migrate *ARGS:
    @just dj manage migrate {{ ARGS }}

# Open a Django shell using django-extensions shell_plus command
[no-cd]
shell:
    @just dj manage shell_plus

# Quickly create a superuser with the provided credentials
[no-cd]
createsuperuser USERNAME="admin" PASSWORD="admin" EMAIL="admin@localhost":
    @just docker run app "-e DJANGO_SUPERUSER_PASSWORD='{{ PASSWORD }}'" "/bin/bash -c 'python -m manage createsuperuser --noinput --username "{{ USERNAME }}" --email "{{ EMAIL }}"'"

# Graph models using django-extensions graph_models command
[no-cd]
graph:
    @just dj manage graph_models users \
        --exclude-models AbstractUser \
        --group-models \
        --output ./docs/applications/images/users.svg
