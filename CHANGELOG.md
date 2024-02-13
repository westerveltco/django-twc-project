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

### Added

- Minimum Copier version set to 9.1.0.
- `author_name` and `github_owner` in `copier.yml` now have inline validators to ensure they are not empty.
- `FORM_RENDERER` is now set to `django.forms.renderers.TemplatesSetting` by default.
- Test for version in `tests/test_version.py` now correctly bumped by `bumpver`.
- `django-q-registry` added to `requirements.in`.

### Changed

- `DEFAULT_AUTO_FIELD` reverted to `django.db.models.AutoField`. We still have projects that have not migrated to the new field and this change was potentially breaking for them.
- `admin_email` help text in `copier.yml` updated to be more clear that it's the destination for emails sent to Admins. This is primarily only used in the `templates/.well-known/security.txt` file at the moment.
- All HTML templates in `src/django_twc_project/templates` have been formatted using djLint.
- Add missing `django-tailwind-cli` build command in CI/CD test job.
- Redirect after login to "index" view instead of non-existent "dashboard" view.
- All `pre-commit` hooks have been updated to use the latest versions of the tools.
    - `django-upgrade` to 1.16.0
    - `language-formatters-pre-commit-hooks` to v2.12.0
    - `prettier` to v4.0.0-alpha.8
    - `ruff-pre-commit` to 0.2.1
    - `rustywind` to 0.21.0
    - `validate-pyproject` to v0.16
- `djhtml` has been swapped out in favor of `djLint` for HTML formatting.
- `pyproject.toml` has been updated and formatted.
    - Add `coverage` config.
    - Add `boto3` and `botocore` to `mypy` ignore list.
    - Actually use Copier `python_version` input for `ruff` Python target version.
    - Add some `ruff` per-file ignores for tests.
    - Add rules for `pyupgrade` to `ruff` config.
- Favicon view in `core.views` now uses `django.contrib.staticfiles` to find the favicon file.

### Removed

- Empty `{{ module_name }}/users/views.py` file has been removed.

## [2024.1]

Initial release! 🎉

### Added

- Initial project template.
- Initial documentation.
- Initial tests.
- Initial CI/CD (GitHub Actions).

### New Contributors!

- Josh Thomas <josh@joshthomas.dev> (maintainer)

[unreleased]: https://github.com/westerveltco/django-twc-project/compare/v2024.1...HEAD
[2024.1]: https://github.com/westerveltco/django-simple-nav/releases/tag/v2024.1
