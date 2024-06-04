justfile := justfile_directory() + "/.just/postgres.just"

[private]
default:
    @just --list --justfile {{ justfile }}

[private]
fmt:
    @just --fmt --justfile {{ justfile }}

DATABASE_URL := replace(env_var("DATABASE_URL"), "postgis://", "postgres://")

# Dump our local database to file
dump database_url=DATABASE_URL file='db.dump':
    just docker run db "" \
        pg_dump \
            --dbname {{ database_url }} \
            --file /app/{{ file }} \
            --format=c \
            --verbose

# Dump our production database to file
dump-prod file='production.dump':
    set PROD_DATABASE_URL := '{{ replace(env_var("PROD_DATABASE_URL"), "postgis://", "postgres://") }}'
    @just pg dump $PROD_DATABASE_URL {{ file }}

# Restore database backup to our local database
restore database_url=DATABASE_URL file='db.dump':
    just docker run db "" \
        pg_restore \
            --clean \
            --dbname {{ database_url }} \
            --if-exists \
            --no-owner \
            --verbose \
            /app/{{ file }}
