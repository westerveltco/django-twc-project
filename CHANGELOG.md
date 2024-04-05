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

## [2024.14]

### Changed

-   Adjusted all `Justfile` commands to only echo the command being run.

### Removed

- Removed the template version from the main project's `__init__.py` since it is already captured in the copier answers file.

## [2024.13]

### Added

-   A `.env.prod` template to be used with 1Password's `op` CLI tool.

### Changed

-   Now using 1Password's `op` CLI tool for managing and injecting secrets when deploying to Fly.io.

## [2024.12]

### Changed

-   Added more files to `coverage` exclude list.
-   Node.js/Vite specific files now excluded from `.dockerignore`.

### Added

-   Template now has a `CODEOWNERS` file.

### Removed

-   `ENABLE_SENTRY` environment variable has been removed from template in favor of checking for the existence of `SENTRY_DSN`.

### Fixed

-   Moved the `--skip-checks` flag in `django-tailwind-cli`'s build command in CI/CD.

## [2024.11]

### Added

-   Two new `Justfile` commands for using `copier`'s recopy command: `copier-recopy` and `copier-recopy-all`.
-   All `Justfile` commands now have a short description that is displayed when running `just` (default command) or `just --list`.

### Fixed

-   Removed extra `test` command in `Justfile`.
-   Fixed `compose.yml` filename in various `Justfile` commands.

## [2024.10]

### Added

-   Now prompted for the version of PostGIS to use in the project, if `postgis/postgis` is chosen as the PostgreSQL database.
-   A new example project has been added to the `examples` directory using PostGIS.

### Changed

-   PostgreSQL version now takes into account the version of PostGIS, if that option is chosen.

## [2024.9]

### Changed

-   `django_browser_reload` middleware now only loaded in development (`DEBUG=True`).
-   `template_partials` template loader has been removed in favor of built-in behavior. (The package automatically wraps the template loaders with the correct loader class.)
-   In `settings.py`, all reading of environment variables using `environs.env` now have the correct types associated with them.
-   `SECRET_KEY` now uses `secrets` stdlib module to generate a new secret key if not set. H/T to [@jacobian](https://github.com/jacobian) for the [inspiration](https://github.com/jacobian/personal-app-template/blob/f2318d8734cdffea66c9c874f6292d6bfdd8fc21/%7B%7B%20cookiecutter.project_slug%20%7D%7D/config/settings.py#L16).
-   `.dockerignore` now uses a whitelist of files to include, rather than a blacklist. H/T to [@mhlut](https://github.com/mhlut) for the [inspiration](https://marijkeluttekes.dev/blog/articles/2024/03/18/smaller-docker-images-by-using-a-blanket-ignore/).
-   In `settings.py`, `SENTRY_DSN` now correctly using `environs.env.url` to validate the URL from the environment and passing the URL string to `sentry_sdk.init`.
-   `uv` explicitly added to template's `requirements.in` file.
-   Python 3.12 is now the default version in template and repo.

### Removed

-   `pip-tools` has been removed from `requirements.in`, in favor of `uv`.

### Fixed

-   Added missing `--no-default-ignore` to static collection step in `test.yml`. By default Vite puts the `manifest.json` in a `.vite` directory, so we need to make sure this is not ignored when collecting static files.
-   Now correctly using `postgres_uri_scheme` throughout template.

## [2024.8]

### Changed

-   Now using v2 of `1password/load-secrets-action` GitHub Action.
-   Now using v0.3.2 of `ruff` in pre-commit.
-   Shortened all `docker-compose*.yml` files to `compose*.yml` files. This is the recommended file naming scheme now.
-   Tailwind CSS version now read from `package.json` anywhere the version is needed.
-   Playwright installation stage in `Dockerfile` moved to earlier stage with the dev stage inheriting from it later on. This allows for the system dependencies and browsers installation and building to be cached without anything in the project busting it.

### Removed

-   `project.yml` GitHub Actions workflow file. This is now taken care of by a custom GitHub bot.

### Fixed

-   Now mirroring the `default` database when testing. This is the recommendation from the Django documentation.
-   `STORAGES["staticfiles"]["BACKEND"]` now correctly using `django.contrib.staticfiles.StaticFilesStorage` instead of the `InMemoryStorage` backend. This was causing the static templatetag to look in the `mediafiles` directory instead of the `static` directory.

## [2024.7]

### Added

-   Default vm settings for Fly.io app now set to 1 shared CPU and 1GB RAM.
-   Use `uv` for dependency management.
-   `playwright` added to `requirements.in` for testing.

### Fixed

-   Database connection now requires SSL connection by default in production.

### Changed

-   Adjust how `DISABLE_SERVER_SIDE_CURSORS` is set in dev and production settings.
-   Adjust how Sentry is configured and enabled.
-   Always have one machine running in the Fly.io production environment.
-   `[services.concurrency]` in `fly.toml` config now based on requests per [Fly.io's recommendation](https://fly.io/docs/reference/configuration/#services-concurrency) for web services.

### Removed

-   No hash dependencies.

## [2024.6]

### Fixed

-   The release link and text in the `README.md` was not referencing the correct SaaS product.

## [2024.5]

### Added

-   Now using [`westerveltco/setup-ci-action`](https://github.com/westereltco/setup-ci-action) for common Python and Node.js CI/CD setup. This action sets up a Python and Node.js environment with caching and installs all dependencies for a project.
-   Added example generation job to `test.yml` GitHub Actions workflow.
-   Initial `README.md` in the project template with basic information about the project and how to get started.

### Changed

-   Django commands in CI/CD now use `--skip-checks` and/or `--no-input` where possible.

### Removed

-   `create-release-pr` command from `Justfile` was removed and moved to a personal script.

### Fixed

-   `django-template-partials` added to `INSTALLED_APPS`.
-   Added missing `coverage-py` report config to `pyproject.toml`.

## [2024.4]

### Changed

-   All GitHub Actions steps have been updated to the latest versions.

## [2024.3]

### Changed

-   Move from deprecated `ruff` config to new in `pyproject.toml`.

## [2024.2]

### Added

-   Minimum Copier version set to 9.1.0.
-   `author_name` and `github_owner` in `copier.yml` now have inline validators to ensure they are not empty.
-   `FORM_RENDERER` is now set to `django.forms.renderers.TemplatesSetting` by default.
-   Test for version in `tests/test_version.py` now correctly bumped by `bumpver`.
-   `django-q-registry` added to `requirements.in`.
-   `django-twc-toolbox` added to `requirements.in`.
-   `django-simple-nav` added to `requirements.in`.
-   Add `coverage` config to `pyproject.toml`.
-   Add `boto3` and `botocore` to `mypy` ignore list in `pyproject.toml`.
-   Add some `ruff` per-file ignores for tests in `pyproject.toml`.
-   Add rules for `pyupgrade` to `ruff` config in `pyproject.toml`.

### Changed

-   `admin_email` help text in `copier.yml` updated to be more clear that it's the destination for emails sent to Admins. This is primarily only used in the `templates/.well-known/security.txt` file at the moment.
-   All `pre-commit` hooks have been updated to use the latest versions of the tools.
    -   `django-upgrade` to 1.16.0
    -   `language-formatters-pre-commit-hooks` to v2.12.0
    -   `prettier` to v4.0.0-alpha.8
    -   `ruff-pre-commit` to 0.2.1
    -   `rustywind` to 0.21.0
    -   `validate-pyproject` to v0.16
-   `djhtml` has been swapped out in favor of `djLint` for HTML formatting.
-   `pyproject.toml` has been linted and formatted.
-   Favicon view in `core.views` now uses `django.contrib.staticfiles` to find the favicon file.
-   `pre-commit` is now run after generation to ensure the generated project is properly formatted.

### Fixed

-   `DEFAULT_AUTO_FIELD` reverted to `django.db.models.AutoField`. We still have projects that have not migrated to the new field and this change was potentially breaking for them.
-   Redirect after login to "index" view instead of non-existent "dashboard" view.
-   All HTML templates in `src/django_twc_project/templates` have been formatted using djLint.
-   Add missing `django-tailwind-cli` build command in CI/CD test job.
-   Actually use Copier `python_version` input for `ruff` Python target version in `pyproject.toml`.

### Removed

-   Empty `{{ module_name }}/users/views.py` file has been removed.

## [2024.1]

Initial release! 🎉

### Added

-   Initial project template.
-   Initial documentation.
-   Initial tests.
-   Initial CI/CD (GitHub Actions).

### New Contributors

-   Josh Thomas <josh@joshthomas.dev> (maintainer)

[unreleased]: https://github.com/westerveltco/django-twc-project/compare/v2024.14...HEAD
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
