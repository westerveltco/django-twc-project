set dotenv-load := true

@_default:
    just --list

# ----------------------------------------------------------------------
# RELEASING
# ----------------------------------------------------------------------

create-release-pr:
    #!/usr/bin/env bash

    set -euo pipefail

    # get changes since last tag for PR body
    # done first so none of the other commits in this script are included
    changes=$(git log $(git tag --sort=-creatordate | head -n 1)..HEAD --pretty=format:"- \`%h\`: %s" --reverse)

    # grab the newest version for release branch name and example generation commit message
    new_version=$(just _bump --dry 2>&1 | rg 'New Version' | awk '{print $5}')

    release_branch="release-v${new_version}"
    git checkout -b "${release_branch}"

    just _bump
    # grab the PR title from the `bumpver` commit message
    pr_title=$(git log -1 --pretty=%s)

    just generate-examples
    git add . && git commit -m "regenerate examples for version ${new_version}"

    repo_url=$(git remote get-url origin)
    changelog="CHANGELOG.md"
    # update unrelease section with new version and add new unreleased section
    sed -i -e "0,/## \[Unreleased\]/s//## [${new_version}]/" $changelog
    sed -i -e "/## \[${new_version}\]/i ## [Unreleased]\n\n" $changelog
    # adjust link references at bottom of changelog
    echo -e "[${new_version}]: ${repo_url}/releases/tag/v${new_version}\n" >> $changelog
    sed -i -e "s|\[unreleased\]: ${repo_url}/compare/v.*...HEAD|\[unreleased\]: ${repo_url}/compare/v${new_version}...HEAD|" $changelog
    git add . && git commit -m "update CHANGELOG"

    git push --set-upstream origin "${release_branch}"

    gh pr create --base main --head "${release_branch}" --title "${pr_title}" --body "${changes}"

_bump *ARGS:
    rye run bumpver update {{ ARGS }}

@generate-examples:
    for file in `ls examples/*.yml`; do \
        just _generate-example $file; \
    done

_generate-example DATA_FILE:
    #!/usr/bin/env bash

    set -euo pipefail

    DIRECTORY="{{ trim_end_match(DATA_FILE, '.yml') }}"
    rm -rf $DIRECTORY
    rye run copier copy -r HEAD . $DIRECTORY --force --trust --data-file {{ DATA_FILE }}

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
