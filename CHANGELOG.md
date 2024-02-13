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

### Changed

- `DEFAULT_AUTO_FIELD` reverted to `django.db.models.AutoField`. We still have projects that have not migrated to the new field and this change was potentially breaking for them.
- `admin_email` help text in `copier.yml` updated to be more clear that it's the destination for emails sent to Admins. This is primarily only used in the `templates/.well-known/security.txt` file at the moment.
- All HTML templates in `src/django_twc_project/templates` have been formatted using djLint.
- Add missing `django-tailwind-cli` build command in CI/CD test job.

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
