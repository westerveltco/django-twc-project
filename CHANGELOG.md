# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

<!--
## [Version Number]

### Added
### Changed
### Deprecated
### Removed
### Fixed
### Security
-->

## [Unreleased]

## [2024.34]

### Changed

- Now explicitly adding `template_partials.loader.Loader` to the template loaders section of `settings.TEMPLATES`. This is to support trying out a few component libraries that use custom loaders and to avoid `django-template-partials` from overwriting any changes. Also to avoid using `template_partials.apps.SimpleAppConfig` in `INSTALLED_APPS` as that would really bug me for it be the only one installed like that. Silly thing, but it would!

## [2024.33]

### Changed

- `prettier` pre-commit hook is now local instead of using the official mirror. The mirror has been deprecated and archived.
- `djlint` configuration expanded.

## [2024.32]

### Changed

- `mypy` configuration now excludes these directories: `docs`, `migrations`, `tests`, and `.venv`/`venv`.
- Default Django version is now 5.0.
- Bumped default Playwright version to 1.45.0.
- Bumped default Tailwind CSS version to 3.4.6.
- Migrated defining dependencies from `requirements.in` to `pyproject.toml`. Split dev dependencies to project extras.

### Removed

- Django 3.2 (EOL) has been removed as an option.
- Removed an out-of-date and unneeded `# type: ignore` comment from the `users.admin` module.

## [2024.31]

### Removed

- Remove `mkdocs.yml` config from template. This is now being handled from the central docs repo and no longer needed.

## [2024.30]

### Added

- There is now a `mkdocs.yml` file that enables docs from this repo to be collected in another repo.

### Removed

- Label syncing has been removed. This has been moved to a GitHub App using [github/safe-settings](https://github.com/github/safe-settings).

## [2024.29]

### Added

- CI now has a new `fly` step that validates the `fly.toml` configuration file.

### Fixed

- Removed the `[no-cd]` decoration from an alias in one of the sub-`Justfile`s.

## [2024.28]

### Changed

- Added `[no-cd]` to all `Justfile` module subcommands. By default, a `just` command runs in the context of the file that it is contained it, which means the working directory for all of the module subcommands ends up being the `.just` directory. This is not what we want. Annoyingly, there seems to be no way to change this, either globally or as a setting at the top of a `Justfile`, so we instead have to decorate all of the commands.
- `django-twc-toolbox` now a part of the `INSTALLED_APPS` list. There was a management command added -- an override of the built-in `createsuperuser` command that resets the superuser's password in development -- so it's added as an installed app so this command can be run.
- Added a question for template generation on whether Cloudflare R2 will be used. If so, make sure the `STORAGES` setting in `settings.py` has the correct keys for setting that up.

### Removed

- Removed question about 1Password vault, which is no longer used.

## [2024.27]

### Added

- Added Semgrep CI GitHub Actions workflow.

### Changed

- Updated `README.md` to account for recent changes to `Justfile` commands.
- In `.just/postgres.just`, added replacement in database URLs of `postgis://` to `postgres://` to account for potential PostGIS usage. When using the commands directly with the `db` container, there is no need for the PostGIS scheme.

### Removed

- Removed GitHub branching strategy section from `README.md`. This has been moved to our central Web Dev documentation.

### Fixed

- Fixed `just pg dump-prod` command subcall of `just pg dump` command.

## [2024.26]

### Fixed

- Fixed a bug in the changed `just docker clean` `Justfile` command where the command was prefixed with an `@` symbol. That is valid when it's a pure `just` command, but it was changed to a `bash` script.

## [2024.25]

### Added

- Added our Data Analytics GitHub Team to the `CODEOWNERS` file for automatic review assignment to any PRs involving migrations.

### Changed

- Adjusted various `Justfile` commands based on testing and feedback.
- `depends_on` in `compose.yml` now moved to a separate YAML anchor with the benefit of being able to extend it to include the `node` container when Vite is chosen.

## [2024.24]

### Changed

- Adjusted the configuration of `django-storages` to use new style. At least, I think it's new. I cannot find in the library's CHANGELOG where it was added.
- `django-storages` installation options adjusted to specify the `[s3]` extra.
- Major refactor to the `Justfile`. Now utilizing the new modules introduced in version 1.19.0 of `just`.

### Removed

- `boto3` as an explicit dependency has been removed in favor of `django-storages[s3]`.
- Removed deprecated `version` property from all Docker `compose*.yml` files.
- Dropped support for Python 3.8.

## [2024.23]

### Removed

- Removed the `PORT` environment variable from the Fly.io config. It was unused and not needed.

## [2024.22]

### Added

- Added "high visibility" label.

### Changed

- Added `socialaccount` extra to `django-allauth` dependency, per the breaking change outlined in the library's [release notes](https://docs.allauth.org/en/latest/release-notes/recent.html#backwards-incompatible-changes).

### Fixed

- Removed deprecated `sentry_sdk.last_event_id` function from custom 500 error view.

## [2024.21]

### Fixed

- Added missing trailing slash when copying files in `Dockerfile`.

## [2024.20]

### Added

- Repo now has a `CODEOWNERS` file to automatically assign reviewers to pull requests. (Template already has one.)
- Added a new, separate Dependabot group for `django-email-relay` updates.
- Added Docker to Dependabot updates.
- Added `CSRF_COOKIE_SECURE = not DEBUG` setting to template.
- Added `AWS_S3_CUSTOM_DOMAIN` setting to template.
- Added "c-suite" label.

### Changed

- Tweaked a few of the commands in the template's `Dockerfile` to consolidate the ones that could be.
- Added the ability to specify repo specific labels, in addition to the global shared labels.

### Fixed

- Fixed a bug with the `ssl_require` argument in the database config in `settings.py`. When building or testing, we sometimes fall back to just using SQLite to avoid having to spin up a Postgres database. However, SQLite doesn't know what to do with the `sql_require` argument, so we disable it for SQLite.

## [2024.19]

### Added

- Added a GitHub Action workflow for syncing labels across all projects using this template.

## [2024.18]

### Added

- Added two CSS utilities previously set in the shared central Tailwind CSS config: `x-cloak` for hiding certain Alpine.js elements until Alpine has been initialized and the `htmx-indicator` for controlling the Z-index of the loading indicator.

### Fixed

- `tzdata` system utility package now explicitly installed in the `dev` stage of the template's `Dockerfile`. Previously all of the stages were based on the `python-slim` base image, which includes `tzdata` by default. The `mcr.microsoft.com/playwright/python` image is based on `ubuntu` and does not include `tzdata` by default.

## [2024.17]

### Added

- Pinned Django in `requirements.in` to less than the next major release based on the version chosen when answering copier questions.
- Added more ignore rules to `.gitignore` pertaining to SQLite, PostgreSQL, and other database files.

### Changed

- Now using official Playwright Docker image provided my Microsoft, instead of installing manually inside project's `Dockerfile`. The build times when updating any Python dependency got to be too long to deal with, so instead we pin which version of Playwright to use in both `requirements.in` and the aforementioned `Dockerfile` so there is no drift between the two.
- `just bootstrap` command in template now calls `just lock` to address when a `requirements.txt` may not exist.

## [2024.16]

### Added

- `partialdef` template tag from `django-template-partials` has been added to the config for `djlint`.
- Added Inter font to `base.html` template.

### Changed

- Moved the Python and Node.js versions from arguments to `setup-ci-action` to environment variables at the top of the workflow to cut down on duplication in `test.yml` GitHub Action workflow.
- `.mise.toml` config files are now ignored by Git.
- `SECRET_KEY` default now set at template generation time using copier extension instead of using `secrets` stdlib module. This was causing login issues in development and is not really needed.
- `bumpver` pattern for updating version in `.copier/project.yml` now without quotes around version number. There must have been an internal change with `copier`.

### Removed

- `uv` was removed from `requirements.in`.

## [2024.15]

### Added

- Added S3 and Okta credentials to `.env.prod`.
- Added the version specified in the Copier answers file `.copier/project.yml` to `bumpver` config. Copier advises not to edit this file directly, however when updating a project to a new version of the template it is a bit of a pain to lookup what the current version is. Since `bumpver` bumps the project's version in every place it needs to, the risk that it messes up Copier is very low.

### Changed

- Now calling `manage.py` file in CI as a module instead of using the file name directly.

### Fixed

- Added upper bounds for `django-email-relay` dependency. Since it runs distributed, with a central relay service that is responsible for sending emails, the roll-out of a new version should be more controlled. With the upper bounds, the version won't accidentally get bumped in day-to-day work (hopefully!).

## [2024.14]

### Changed

- Adjusted all `Justfile` commands to only echo the command being run.

### Removed

- Removed the template version from the main project's `__init__.py` since it is already captured in the copier answers file.

## [2024.13]

### Added

- A `.env.prod` template to be used with 1Password's `op` CLI tool.

### Changed

- Now using 1Password's `op` CLI tool for managing and injecting secrets when deploying to Fly.io.

## [2024.12]

### Changed

- Added more files to `coverage` exclude list.
- Node.js/Vite specific files now excluded from `.dockerignore`.

### Added

- Template now has a `CODEOWNERS` file.

### Removed

- `ENABLE_SENTRY` environment variable has been removed from template in favor of checking for the existence of `SENTRY_DSN`.

### Fixed

- Moved the `--skip-checks` flag in `django-tailwind-cli`'s build command in CI/CD.

## [2024.11]

### Added

- Two new `Justfile` commands for using `copier`'s recopy command: `copier-recopy` and `copier-recopy-all`.
- All `Justfile` commands now have a short description that is displayed when running `just` (default command) or `just --list`.

### Fixed

- Removed extra `test` command in `Justfile`.
- Fixed `compose.yml` filename in various `Justfile` commands.

## [2024.10]

### Added

- Now prompted for the version of PostGIS to use in the project, if `postgis/postgis` is chosen as the PostgreSQL database.
- A new example project has been added to the `examples` directory using PostGIS.

### Changed

- PostgreSQL version now takes into account the version of PostGIS, if that option is chosen.

## [2024.9]

### Changed

- `django_browser_reload` middleware now only loaded in development (`DEBUG=True`).
- `template_partials` template loader has been removed in favor of built-in behavior. (The package automatically wraps the template loaders with the correct loader class.)
- In `settings.py`, all reading of environment variables using `environs.env` now have the correct types associated with them.
- `SECRET_KEY` now uses `secrets` stdlib module to generate a new secret key if not set. H/T to [@jacobian](https://github.com/jacobian) for the [inspiration](https://github.com/jacobian/personal-app-template/blob/f2318d8734cdffea66c9c874f6292d6bfdd8fc21/%7B%7B%20cookiecutter.project_slug%20%7D%7D/config/settings.py#L16).
- `.dockerignore` now uses a whitelist of files to include, rather than a blacklist. H/T to [@mhlut](https://github.com/mhlut) for the [inspiration](https://marijkeluttekes.dev/blog/articles/2024/03/18/smaller-docker-images-by-using-a-blanket-ignore/).
- In `settings.py`, `SENTRY_DSN` now correctly using `environs.env.url` to validate the URL from the environment and passing the URL string to `sentry_sdk.init`.
- `uv` explicitly added to template's `requirements.in` file.
- Python 3.12 is now the default version in template and repo.

### Removed

- `pip-tools` has been removed from `requirements.in`, in favor of `uv`.

### Fixed

- Added missing `--no-default-ignore` to static collection step in `test.yml`. By default Vite puts the `manifest.json` in a `.vite` directory, so we need to make sure this is not ignored when collecting static files.
- Now correctly using `postgres_uri_scheme` throughout template.

## [2024.8]

### Changed

- Now using v2 of `1password/load-secrets-action` GitHub Action.
- Now using v0.3.2 of `ruff` in pre-commit.
- Shortened all `docker-compose*.yml` files to `compose*.yml` files. This is the recommended file naming scheme now.
- Tailwind CSS version now read from `package.json` anywhere the version is needed.
- Playwright installation stage in `Dockerfile` moved to earlier stage with the dev stage inheriting from it later on. This allows for the system dependencies and browsers installation and building to be cached without anything in the project busting it.

### Removed

- `project.yml` GitHub Actions workflow file. This is now taken care of by a custom GitHub bot.

### Fixed

- Now mirroring the `default` database when testing. This is the recommendation from the Django documentation.
- `STORAGES["staticfiles"]["BACKEND"]` now correctly using `django.contrib.staticfiles.StaticFilesStorage` instead of the `InMemoryStorage` backend. This was causing the static templatetag to look in the `mediafiles` directory instead of the `static` directory.

## [2024.7]

### Added

- Default vm settings for Fly.io app now set to 1 shared CPU and 1GB RAM.
- Use `uv` for dependency management.
- `playwright` added to `requirements.in` for testing.

### Fixed

- Database connection now requires SSL connection by default in production.

### Changed

- Adjust how `DISABLE_SERVER_SIDE_CURSORS` is set in dev and production settings.
- Adjust how Sentry is configured and enabled.
- Always have one machine running in the Fly.io production environment.
- `[services.concurrency]` in `fly.toml` config now based on requests per [Fly.io's recommendation](https://fly.io/docs/reference/configuration/#services-concurrency) for web services.

### Removed

- No hash dependencies.

## [2024.6]

### Fixed

- The release link and text in the `README.md` was not referencing the correct SaaS product.

## [2024.5]

### Added

- Now using [`westerveltco/setup-ci-action`](https://github.com/westereltco/setup-ci-action) for common Python and Node.js CI/CD setup. This action sets up a Python and Node.js environment with caching and installs all dependencies for a project.
- Added example generation job to `test.yml` GitHub Actions workflow.
- Initial `README.md` in the project template with basic information about the project and how to get started.

### Changed

- Django commands in CI/CD now use `--skip-checks` and/or `--no-input` where possible.

### Removed

- `create-release-pr` command from `Justfile` was removed and moved to a personal script.

### Fixed

- `django-template-partials` added to `INSTALLED_APPS`.
- Added missing `coverage-py` report config to `pyproject.toml`.

## [2024.4]

### Changed

- All GitHub Actions steps have been updated to the latest versions.

## [2024.3]

### Changed

- Move from deprecated `ruff` config to new in `pyproject.toml`.

## [2024.2]

### Added

- Minimum Copier version set to 9.1.0.
- `author_name` and `github_owner` in `copier.yml` now have inline validators to ensure they are not empty.
- `FORM_RENDERER` is now set to `django.forms.renderers.TemplatesSetting` by default.
- Test for version in `tests/test_version.py` now correctly bumped by `bumpver`.
- `django-q-registry` added to `requirements.in`.
- `django-twc-toolbox` added to `requirements.in`.
- `django-simple-nav` added to `requirements.in`.
- Add `coverage` config to `pyproject.toml`.
- Add `boto3` and `botocore` to `mypy` ignore list in `pyproject.toml`.
- Add some `ruff` per-file ignores for tests in `pyproject.toml`.
- Add rules for `pyupgrade` to `ruff` config in `pyproject.toml`.

### Changed

- `admin_email` help text in `copier.yml` updated to be more clear that it's the destination for emails sent to Admins. This is primarily only used in the `templates/.well-known/security.txt` file at the moment.
- All `pre-commit` hooks have been updated to use the latest versions of the tools.
  - `django-upgrade` to 1.16.0
  - `language-formatters-pre-commit-hooks` to v2.12.0
  - `prettier` to v4.0.0-alpha.8
  - `ruff-pre-commit` to 0.2.1
  - `rustywind` to 0.21.0
  - `validate-pyproject` to v0.16
- `djhtml` has been swapped out in favor of `djLint` for HTML formatting.
- `pyproject.toml` has been linted and formatted.
- Favicon view in `core.views` now uses `django.contrib.staticfiles` to find the favicon file.
- `pre-commit` is now run after generation to ensure the generated project is properly formatted.

### Fixed

- `DEFAULT_AUTO_FIELD` reverted to `django.db.models.AutoField`. We still have projects that have not migrated to the new field and this change was potentially breaking for them.
- Redirect after login to "index" view instead of non-existent "dashboard" view.
- All HTML templates in `src/django_twc_project/templates` have been formatted using djLint.
- Add missing `django-tailwind-cli` build command in CI/CD test job.
- Actually use Copier `python_version` input for `ruff` Python target version in `pyproject.toml`.

### Removed

- Empty `{{ module_name }}/users/views.py` file has been removed.

## [2024.1]

Initial release! 🎉

### Added

- Initial project template.
- Initial documentation.
- Initial tests.
- Initial CI/CD (GitHub Actions).

### New Contributors

- Josh Thomas <josh@joshthomas.dev> (maintainer)

[unreleased]: https://github.com/westerveltco/django-twc-project/compare/v2024.34...HEAD
[2024.1]: https://github.com/westerveltco/django-twc-project/releases/tag/v2024.1
[2024.2]: https://github.com/westerveltco/django-twc-project/releases/tag/v2024.2
[2024.3]: https://github.com/westerveltco/django-twc-project/releases/tag/v2024.3
[2024.4]: https://github.com/westerveltco/django-twc-project/releases/tag/v2024.4
[2024.5]: https://github.com/westerveltco/django-twc-project/releases/tag/v2024.5
[2024.6]: https://github.com/westerveltco/django-twc-project/releases/tag/v2024.6
[2024.7]: https://github.com/westerveltco/django-twc-project/releases/tag/v2024.7
[2024.8]: https://github.com/westerveltco/django-twc-project/releases/tag/v2024.8
[2024.9]: https://github.com/westerveltco/django-twc-project/releases/tag/v2024.9
[2024.10]: https://github.com/westerveltco/django-twc-project/releases/tag/v2024.10
[2024.11]: https://github.com/westerveltco/django-twc-project/releases/tag/v2024.11
[2024.12]: https://github.com/westerveltco/django-twc-project/releases/tag/v2024.12
[2024.13]: https://github.com/westerveltco/django-twc-project/releases/tag/v2024.13
[2024.14]: https://github.com/westerveltco/django-twc-project/releases/tag/v2024.14
[2024.15]: https://github.com/westerveltco/django-twc-project/releases/tag/v2024.15
[2024.16]: https://github.com/westerveltco/django-twc-project/releases/tag/v2024.16
[2024.17]: https://github.com/westerveltco/django-twc-project/releases/tag/v2024.17
[2024.18]: https://github.com/westerveltco/django-twc-project/releases/tag/v2024.18
[2024.19]: https://github.com/westerveltco/django-twc-project/releases/tag/v2024.19
[2024.20]: https://github.com/westerveltco/django-twc-project/releases/tag/v2024.20
[2024.21]: https://github.com/westerveltco/django-twc-project/releases/tag/v2024.21
[2024.22]: https://github.com/westerveltco/django-twc-project/releases/tag/v2024.22
[2024.23]: https://github.com/westerveltco/django-twc-project/releases/tag/v2024.23
[2024.24]: https://github.com/westerveltco/django-twc-project/releases/tag/v2024.24
[2024.25]: https://github.com/westerveltco/django-twc-project/releases/tag/v2024.25
[2024.26]: https://github.com/westerveltco/django-twc-project/releases/tag/v2024.26
[2024.27]: https://github.com/westerveltco/django-twc-project/releases/tag/v2024.27
[2024.28]: https://github.com/westerveltco/django-twc-project/releases/tag/v2024.28
[2024.29]: https://github.com/westerveltco/django-twc-project/releases/tag/v2024.29
[2024.30]: https://github.com/westerveltco/django-twc-project/releases/tag/v2024.30
[2024.31]: https://github.com/westerveltco/django-twc-project/releases/tag/v2024.31
[2024.32]: https://github.com/westerveltco/django-twc-project/releases/tag/v2024.32
[2024.33]: https://github.com/westerveltco/django-twc-project/releases/tag/v2024.33
[2024.34]: https://github.com/westerveltco/django-twc-project/releases/tag/v2024.34
