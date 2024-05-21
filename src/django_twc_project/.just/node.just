justfile := justfile_directory() + "/.just/node.just"

[private]
default:
    @just --list --justfile {{ justfile }}

[private]
fmt:
    @just --fmt --justfile {{ justfile }}

# Install dependencies
[no-cd]
install *ARGS:
    npm install

# Generate package-lock.json file
[no-cd]
lock:
    npm install --package-lock-only

# Update dependencies
[no-cd]
update:
    npm update

# Generate and upgrade dependencies
[no-cd]
upgrade:
    npm upgrade
