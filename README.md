# django-twc-project

[![Rye](https://img.shields.io/endpoint?url=https://raw.githubusercontent.com/mitsuhiko/rye/main/artwork/badge.json)](https://rye-up.com)
[![Copier](https://img.shields.io/endpoint?url=https://gist.githubusercontent.com/joshuadavidthomas/7c88611504b557ff7aa2a7524ad996e2/raw/4ba6834953dd8a14afc3dbb7bb41f49f181a59bf/badge.json)](https://copier.readthedocs.io)

`django-twc-project` is the project template for all web applications at The Westervelt Company. This template is built on top of the [Django](https://www.djangoproject.com/) web framework and is designed to be a starting point for new web applications. It includes a number of best practices and tools to help you get started quickly.

It is tailored to the needs of The Westervelt Company and is not intended for general use. However, it is open source and available for anyone take inspiration from or use and modify. [For the greater good!](https://youtu.be/5u8vd_YNbTw?si=lBqwaHdT8y8JUg9q)

## Features

This template is built using [Copier](https://copier.readthedocs.io) and includes the following features:

- [Django](https://www.djangoproject.com/)
    - [`django-allauth`](https://github.com/pennersr/django-allauth) for user authentication
    - [`django-click`](https://github.com/GaretJax/django-click) for nicer management commands
    - [`django-email-relay`](https://github.com/westerveltco/django-email-relay) for sending emails via a central database queue
    - [`django-filter`](https://github.com/carltongibson/django-filter) for filtering querysets
    - [`django-health-check`](https://github.com/revsys/django-health-check) for application, database, storage, and other health checks
    - [`django-q2`](https://github.com/django-q/django-q) for a task queue, using the built-in database broker
        - [`croniter`](https://github.com/kiorky/croniter) for cron tasks
    - [`django-simple-history`](https://github.com/jazzband/django-simple-history) for tracking historical changes to models
    - [`django-storages`](https://github.com/jschneier/django-storages) for file storage using S3
    - [`django-template-partials`](https://github.com/carltongibson/django-template-partials) for easy template partials
    - [`environs`](https://github.com/sloria/environs) for configuration via environment variables
    - [`heroicons`](https://github.com/adamchainz/heroicons) for easy access to [Heroicons](https://heroicons.com/) in Django templates
    - [`httpx`](https://github.com/encode/httpx) for making HTTP requests
    - [`neapolitan`](https://github.com/carltongibson/neapolitan) for quick and easy CRUD views
    - [`sentry-sdk`](https://sentry.io) for error tracking
    - [`whitenoise`](https://github.com/evansd/whitenoise) for serving static files from Django
    - Also includes the following packages to make development easier:
    - [`django-browser-reload`](https://github.com/adamchainz/django-browser-reload) for getting that HMR feeling in Django
    - [`django-debug-toolbar`](https://github.com/jazzband/django-debug-toolbar), 'nuff said
    - [`django-extensions`](https://github.com/django-extensions/django-extensions) for various management commands, but let's be honest -- it's mainly for `shell_plus`
    - [`coverage`](https://github.com/nedbat/coveragepy) and [`django-coverage-plugin`](https://github.com/nedbat/django_coverage_plugin) for test coverage
    - [`ipython`](https://github.com/ipython/ipython) for a better shell
    - [`model_bakery`](https://github.com/model-bakers/model_bakery) for easy model creation in tests
    - [`mypy`](https://github.com/python/mypy) and [`django-stubs`](https://github.com/typeddjango/django-stubs) for static type checking
    - [`pytest`](https://github.com/pytest-dev/pytest) for testing
        - [`pytest-django`](https://github.com/pytest-dev/pytest-django) for Django pytest helpers
        - [`pytest-is-running`](https://github.com/adamchainz/pytest-is-running), what it says on the tin
        - [`pytest-randomly`](https://github.com/pytest-dev/pytest-randomly) and [`pytest-reverse`](https://github.com/adamchainz/pytest-reverse) for keeping tests honest
        - [`pytest-xdist`](https://github.com/pytest-dev/pytest-xdist) for parallel testing, because ain't nobody got time for a slow test suite
- [HTMX](https://htmx.org/) with [`django-htmx`](https://github.com/adamchainz/django-htmx)
- [Alpine.js](https://alpinejs.dev/)
- [Tailwind CSS](https://tailwindcss.com/) with [`django-tailwind-cli`](https://github.com/oliverandrich/django-tailwind-cli)
- (optional) [Vite](https://vitejs.dev/) with [`django-vite`](https://github.com/MrBin99/django-vite)
- Dependency management with [`pip-tools`](https://github.com/jazzband/pip-tools)
    - [Dependabot](https://dependabot.com/) for automatic dependency updates
- Documentation built with [`Sphinx`](https://github.com/sphinx-doc/sphinx), [`MyST-Parser`](https://github.com/executablebooks/MyST-Parser), and the [`furo`](https://github.com/pradyunsg/furo) theme
- Automatic linting and formatting via [`pre-commit`](https://github.com/pre-commit/pre-commit)
    - [`blacken-docs`](https://github.com/adamchainz/blacken-docs) because `ruff` doesn't
    - [`django-upgrade`](https://github.com/adamchainz/django-upgrade) for keeping Django up to date automatically
    - [`djlint`](https://github.com/rtts/djlint) for linting and formatting Django templates
    - [`ruff`](https://github.com/astral-sh/ruff) for blazingly fast formatting and linting
    - [`prettier`](https://github.com/prettier/prettier) for formatting CSS, JavaScript, TypeScript, and YAML
    - [`rustywind`](https://github.com/avencera/rustywind) for sorting Tailwind CSS classes automatically
    - [`validate-pyproject`](https://github.com/abravalheri/validate-pyproject) for ensuring that `pyproject.toml` is valid
    - `pretty-format-toml` via [`language-formatters-pre-commit-hooks`](https://github.com/macisamuele/language-formatters-pre-commit-hooks) for TOML formatting
- [Docker](https://www.docker.com/) for local development and deployment
    - A multi-stage `Dockerfile` to targeting different use cases (application/tailwind/vite/worker in development, full image in production)
        - Tailscale included for easy access to private nodes on Tailnet
    - A `docker-compose.yml` file for local development, with a `docker-compose.prod.yml` to simulate production
- [`just`](https://github.com/casey/just) for running common development tasks
- Deployment to [Fly.io](https://fly.io) with a `fly.toml` file, with [`django-flyio`](https://github.com/joshuadavidthomas/django-flyio) giving some niceties specific to Fly
- CI/CD with [GitHub Actions](https://github.com/features/actions)
    - Testing
    - Type checking
    - Django deployment checks
    - Deploying to Fly.io
        - [`bumpver`](https://github.com/mbarkhau/bumpver) for version bumping
        - [1Password](https://1password.com) and the [`1password/load-secrets-action`](https://github.com/1password/load-secrets-action) to manage secrets

## Usage

### Generating a new package

To use this template, you will need to install [Copier](https://copier.readthedocs.io) and then run the following command:

```bash
copier copy --trust gh:westerveltco/django-twc-project <destination>
```

> [!NOTE]
> The `--trust` flag is used to because this template uses `copier-template-extensions` to simplify some of the Jinja templating. You cannot use this template without trusting it. Please review the files within the [`extensions`](extensions) directory to see what is being done.

After running the above command, you will be prompted to fill in some information about your package. Once you have filled in the necessary information, Copier will generate the package for you.

### Updating an existing package

To use this template to update a package that already uses `django-twc-project` to the latest version, make sure [Copier](https://copier.readthedocs.io) is installed.

Make sure the package you're updating is set up properly (run `just bootstrap` or the equivalent setup command).

> 💬️ For a detailed walkthrough of updating the `directory` package, see [Josh's comment from July 2024](https://github.com/westerveltco/directory/issues/165#issuecomment-2261252519). It goes through many of the problems he ran into and how to resolve them.

**In a new branch**:

1. Run `just copier update-all`.

    - You will be prompted to fill in or update some information about your package. Most of the answers will be the same as they were in setup.
    - You may have to upgrade the versions of some packages that were used, such as Tailwind, Playwright, etc.
    - You will need to enter the `django-twc-project` token

    When `update-all` is finished running, you may see that pre-commit has linted files.

2. **Handle merge conflicts.** This is the part of the process that is most unpredictable, as the kinds of conflicts you will encounter will differ from project to project. Some examples include:

    - `settings.py`: **Will most likely need to be updated every time, for every project.** Because of how the default secret key is generated in the template, this section of the settings file will probably need to be updated.
    - `pyproject.toml` or other config files: Your package's configuration may differ from the template for legitimate reasons, and you will need to reconcile what changes to keep and what to discard.
    - `requirements.in` or other requirements files: You may have some dependency management to do here, if you pin to specific versions for specific reasons or have other changes in your package that need to be kept.

3. Regenerate your `requirements.txt` file (usually, this will mean running `just py lock`)
4. **Confirm your changes work:**

    - Re-run your setup script to confirm everything still works in your package. (Usually, this will be `just setup`.)
    - Start your app locally and do a basic click-through
    - Run your tests locally

5. Commit your changes and open a pull request.

    - Make sure CI tests pass
    - Make sure other CI processes pass

6. Merge the pull request once CI passes.


## Examples

Examples are provided in the [`examples`](examples) directory.

## Contributing

As this template is mainly for internal use at The Westervelt Company, we do not generally accept contributions from external sources. However, if you have any suggestions or issues, please feel free to open an issue or pull request.

## License

`django-twc-project` is licensed under the MIT License. See the [LICENSE](LICENSE) file for more information.
