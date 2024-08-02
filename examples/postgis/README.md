# default

## Requirements

- Python 3.12
  - It is recommended to use [`pyenv`](https://github.com/pyenv/pyenv) to manage your Python versions.
  - [`pyenv-virtualenv`](https://github.com/pyenv/pyenv-virtualenv) is also useful for managing virtual environments, though it is not required.
  - [`uv`](https://github.com/astral-sh/uv) is used for managing Python dependencies.
- Node.js 20
  - It is recommended to use [`nvm`](https://github.com/nvm-sh/nvm) to manage your Node.js versions.
- Docker and Docker Compose
  - The easiest way to install Docker and Docker Compose is to use [Docker Desktop](https://www.docker.com/products/docker-desktop).
- [Just](https://github.com/casey/just)
- [Direnv](https://direnv.net/)
  - This is optional, but highly recommended.

## Getting Started

1. Clone this repository:

   ```sh
   git clone https://github.com/example_owner/default
   ```

2. Run the setup script:

   ```sh
   just setup
   ```

   This will:
   - Clean the repository of existing files, stop any Docker containers that may be running, delete Docker images and networks.
   - Copy the `.env.example` file to `.env` if it does not already exist.
   - Create a virtual environment at the `$VIRTUAL_ENV` directory (default `.venv`).
   - Install `uv` and `pre-commit` Python tools.
   - Build the Docker images for the development environment.
   - Install Python and Node.js dependencies.
   - Start the Docker Compose stack.
   - Migrate the database.
   - Create a superuser for the Django admin interface with the username `admin` and the password `admin`.
   - Run the test suite and generate code coverage.
   - Run the `mypy` static type checker.
   - Lint the repository.
   - Stop the Docker Compose stack.

3. After the setup script has successfully completed, you can start your development Docker Compose stack by running either of these commands:

   ```sh
   # to start the containers detached in the background
   just docker start
   # to start the containers in the foreground with the logs continuously streaming in stdout
   just docker up
   ```

   After starting, you should be able to access the development server at [http://localhost:8000](http://localhost:8000).

   By default, the development server will run on port 8000. If you need to change the port, you can do so by setting the `DJANGO_PORT` environment variable in the `.env` file and then restarting the development server.

## Development

### Testing

This project uses `pytest` for testing. To run the tests, use the following command:

```sh
just test
```

This command can take additional arguments, which will be passed to `pytest`. For example, to run only the tests in the `tests/test_app.py` file, you can use the following command:

```sh
just test tests/test_app.py
```

By default, the tests will run in an ephemeral `app` Docker container service. If you want to run the tests on your local machine, you can use the following command:

```sh
pytest
```

`pytest` will use the `[tool.pytest.ini_options]` configuration from the `pyproject.toml` file. It is setup to:

- Reuse the database between test runs courtesy of the `pytest-django` plugin.
- Run the tests in parallel using the `pytest-xdist` plugin, using the number of CPU cores available on your machine.
- Randomize the order of the tests using the `pytest-randomly` plugin.
  - This is can be disabled by passing `--no-randomly` as a command line argument.

#### Code Coverage

This project uses `coverage.py` to measure code coverage. To run the code coverage report, use the following command:

```sh
just coverage
```

In general, you should strive to have the code coverage be 100%. However, in the real world given various constraints such as time, budget, and the nature of the code, this is not always possible nor desired.

The easiest and best way to maintain high code coverage is to always ensure tests are written for new code and that existing tests are updated when the code they are testing changes. As part of the PR review process, code coverage should be reviewed and discussed. Do not let code coverage be a blocker for merging a PR, but do not ignore it either.

The floor for code coverage can be adjusted in a few places, depending on the context:

- The `[tool.coverage.run]` section of the `pyproject.toml` file.
- Adding a `--fail-under=$COVERAGE_FLOOR_NUMBER` argument to the `coverage` command in the `Justfile`.
- The last step in the "Run tests" step of the `test` job in the `.github/workflows/tests.yml` file.

### Type Checking

This project uses `mypy` and the `django-stubs` plugin for type checking. To run the type checks, use the following command:

```sh
just types
````

In general, you should aim to have `mypy` pass without any errors or warnings. However, given the dynamic nature of Django and the fact that the `django-stubs` project is entirely volunteer driven, it is not always possible to have `mypy` pass without any errors or warnings.

In cases where you need to suppress a `mypy` error or warning, you can use the `# type: ignore` comment. However, you should always aim to minimize the use of `# type: ignore` comments. Make sure you are not ignoring a legitimate type error.

If a third-party package is giving `mypy` problems, you can add it to the list of ignored packages in the `[[tool.mypy.overrides]]` section of the `pyproject.toml` file.

**The overall goal is to type check as much of the code as possible, especially the code we can control, while minimizing the use of `# type: ignore` comments and ignored packages.** Though sometimes the only way to make `mypy` happy is to use `# type: ignore` and move on with your day. Do not waste too much time trying to make `mypy` happy. It never will be.

### Linting and Formatting

This project uses `pre-commit` to run linting and formatting checks, listed in the `.pre-commit-config.yaml` file. To run the checks, use the following command:

```sh
just lint
```

`pre-commit-ci` is configured to run the checks on every push and pull request. If the checks fail, the pull request should be blocked from merging until the checks pass.

To have `pre-commit` run the checks on every commit locallay, use the following command:

```sh
pre-commit install
```

## CI/CD

This project uses GitHub Actions for continuous integration and continuous deployment. The GitHub Actions workflows are defined in the [`.github/workflows`](.github/workflows) directory.

[1Password](https://1password.com/) is used to store the secrets and credentials used by the GitHub Actions workflows. The only secret that should be set in the GitHub repository settings is the `OP_SERVICE_ACCOUNT_TOKEN` secret, which is used to authenticate with the 1Password GitHub Action.

### CI

The [`.github/workflows/tests.yml`](.github/workflows/tests.yml) workflow is responsible for running the continuous integration suite.

This workflow is triggered on every pull request. It is responsible for:

- Setting up and configuring the environment.
- Running the tests.
- Collecting and reporting the code coverage.
- Running the type checks.
- Running the deployment checks provided by Django's `check --deploy` management command.

### CD

The [`.github/workflows/deploy.yml`](.github/workflows/deploy.yml) workflow is responsible for deploying the application to the production environment.

This workflow is triggered on every push to the `main` branch. It is responsible for:

- Bumping the version number across the project.
- Deploying the application to the production environment on [Fly.io](https://fly.io/).
- Notifying [Sentry](https://sentry.io/) of the new release.
