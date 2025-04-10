set dotenv-load := true
set unstable := true

justfile := justfile_directory() + "/.just/copier.just"

[private]
default:
    @just --list --justfile {{ justfile }}

[private]
fmt:
    @just --fmt --justfile {{ justfile }}

# Create a copier answers file
[no-cd]
copy TEMPLATE_PATH DESTINATION_PATH=".":
    $python -m copier copy --trust {{ TEMPLATE_PATH }} {{ DESTINATION_PATH }}

# Recopy the project from the original template
[no-cd]
recopy ANSWERS_FILE *ARGS:
    $python -m copier recopy --trust --answers-file {{ ANSWERS_FILE }} {{ ARGS }}

# Loop through all answers files and recopy the project using copier
[no-cd]
@recopy-all *ARGS:
    for file in `ls .copier/`; do just --unstable copier recopy .copier/$file "{{ ARGS }}"; done

# Update the project using a copier answers file
[no-cd]
update ANSWERS_FILE *ARGS:
    $python -m copier update --trust --answers-file {{ ANSWERS_FILE }} {{ ARGS }}

# Loop through all answers files and update the project using copier
[no-cd]
@update-all *ARGS:
    for file in `ls .copier/`; do just --unstable copier update .copier/$file "{{ ARGS }}"; done
