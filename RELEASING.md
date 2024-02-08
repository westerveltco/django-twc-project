# Releasing a New Version

When it comes time to cut a new release, follow these steps:

1. Create a new git branch off of `main` for the release.

   Prefer the convention `release-<version>`, where `<version>` is the next incremental version number (e.g. `release-v2024.1` for version 2024.1).

   ```shell
   git checkout -b release-v<version>
   ```

   However, the branch name is not *super* important, as long as it is not `main`.

2. Update the version number across the project using the `bumpver` tool.

   The `pyproject.toml` in the base of the repository contains a `[tool.bumpver]` section that configures the `bumpver` tool to update the version number wherever it needs to be updated and to create a commit with the appropriate commit message.

   `bumpver` is included as a development dependency, so you should already have it installed if you have installed the development dependencies for this project. If you do not have the development dependencies installed, you can install them with the following command:

   ```shell
   python -m pip install -r requirements-dev.lock
   ```

   Then, run `bumpver` to update the version number, with the appropriate command line arguments. See the [`bumpver` documentation](https://github.com/mbarkhau/bumpver) for more details.

   **Note**: For any of the following commands, you can add the command line flag `--dry` to preview the changes without actually making the changes.

   Here are the most common commands you will need to run:

   ```shell
   bumpver update
   ```

   To release a tagged version, such as a beta or release candidate, you can run:

   ```shell
   bumpver update --tag=beta
   # or
   bumpver update --tag=rc
   ```

   Running these commands on a tagged version will increment the tag appropriately, but will not increment the version number.

   To go from a tagged release to a full release, you can run:

   ```shell
   bumpver update --tag=final
   ```

3. Ensure the [CHANGELOG](https://github.com/westerveltco/django-twc-project/blob/main/CHANGELOG.md) is up to date. If updates are needed, add them now in the release branch.

4. Create a pull request from the release branch to `main`.

5. Once CI has passed and all the checks are green ✅, merge the pull request.

6. Draft a [new release](https://github.com/westerveltco/django-twc-project/releases/new) on GitHub.

   Use the version number with a leading `v` as the tag name (e.g. `v2024.1`).

   Allow GitHub to generate the release title and release notes, using the 'Generate release notes' button above the text box. If this is a final release coming from a tagged release (or multiple tagged releases), make sure to copy the release notes from the previous tagged release(s) to the new release notes (after the release notes already generated for this final release).

   If this is a tagged release, make sure to check the 'Set as a pre-release' checkbox.

7. Once you are satisfied with the release, publish the release.
