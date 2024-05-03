# syntax=docker/dockerfile:1
ARG PYTHON_VERSION=3.12
ARG NODE_VERSION=20
ARG UID=1000
ARG GID=1000

FROM python:${PYTHON_VERSION}-slim as base
ARG UID
ARG GID
ENV DEBUG False
ENV DEBIAN_FRONTEND noninteractive
ENV PIP_DISABLE_PIP_VERSION_CHECK 1
ENV PYTHONPATH /app
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1
ENV UV_SYSTEM_PYTHON true
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked --mount=type=cache,target=/var/lib/apt,sharing=locked \
  echo 'deb http://deb.debian.org/debian/ bookworm main contrib' >> /etc/apt/sources.list \
  && apt-get update --fix-missing \
  && apt-get install -y --no-install-recommends \
  build-essential \
  curl \
  git \
  jq \
  # tailscale
  ca-certificates \
  iptables \
  gosu \
  # cleanup
  && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/* \
  && mkdir -p /app \
  && addgroup -gid "${GID}" --system django \
  && adduser -uid "${UID}" -gid "${GID}" --home /home/django --system django
WORKDIR /app


FROM base as node-base
ARG NODE_VERSION
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked --mount=type=cache,target=/var/lib/apt,sharing=locked \
  curl -sL https://deb.nodesource.com/setup_${NODE_VERSION}.x | bash - \
  && apt-get update --fix-missing \
  && apt-get install -y --no-install-recommends nodejs \
  && npm install -g npm@latest \
  && apt-get autoremove -y \
  && apt-get clean -y \
  && rm -rf /var/lib/apt/lists/*


FROM base as py
COPY --link requirements*.txt ./
RUN --mount=type=cache,target=/root/.cache/pip --mount=type=cache,target=/root/.cache/uv \
  python -m pip install --upgrade pip uv \
  && uv pip install -r requirements.txt


FROM node-base as node
COPY --from=py --link /usr/local /usr/local
COPY --link package*.json /app
RUN --mount=type=cache,target=/root/.npm npm install


FROM node as tailwind
ARG UID
ARG GID
ARG BUILDARCH
ARG BUILDVARIANT
RUN case ${BUILDARCH} in \
  arm64) \
  case ${BUILDVARIANT} in \
  v7) TAILWINDCSS_ARCH=armv7 ;; \
  *)  TAILWINDCSS_ARCH=arm64 ;; \
  esac ;; \
  *) TAILWINDCSS_ARCH=x64 ;; \
  esac \
  && TAILWINDCSS_VERSION=$(jq -r '.dependencies.tailwindcss // .devDependencies.tailwindcss' package.json | sed 's/^[^0-9]*//') \
  && curl -L https://github.com/tailwindlabs/tailwindcss/releases/download/v${TAILWINDCSS_VERSION}/tailwindcss-linux-${TAILWINDCSS_ARCH} -o /usr/local/bin/tailwindcss-linux-${TAILWINDCSS_ARCH}-${TAILWINDCSS_VERSION} \
  && chmod 755 /usr/local/bin/tailwindcss-linux-${TAILWINDCSS_ARCH}-${TAILWINDCSS_VERSION} \
  && chown ${UID}:${GID} /usr/local/bin/tailwindcss-linux-${TAILWINDCSS_ARCH}-${TAILWINDCSS_VERSION}


FROM base as app
COPY --from=py --link /usr/local /usr/local
COPY --link manage.py package.json /app
COPY --link default /app/default
COPY --link templates /app/templates


FROM mcr.microsoft.com/playwright/python:v1.43.0 as dev
ENV DEBIAN_FRONTEND noninteractive
COPY --from=py --link /usr/local /usr/local
COPY --from=app --link /app /app
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked --mount=type=cache,target=/var/lib/apt,sharing=locked \
  apt-get update --fix-missing \
  && apt-get install -y --no-install-recommends \
  # timezone data missing from Ubuntu base image that Playwright uses
  # (it's normally included in the Python based images)
  tzdata \
  # cleanup
  && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/*


FROM node as node-final
ENV DATABASE_URL sqlite://:memory:
COPY --from=tailwind --link /usr/local /usr/local
COPY --from=app --link /app /app
COPY --link static/src /app/static/src
COPY --link postcss.config.mjs tailwind.config.mjs /app/
RUN python manage.py tailwind --skip-checks build


FROM app as static
ENV DATABASE_URL sqlite://:memory:
COPY --from=py --link /usr/local /usr/local
COPY --from=node-final --link /app/static/dist /app/static/dist
COPY --from=node-final --link /app/package*.json /app/
COPY --link static/public /app/static/public
RUN python manage.py collectstatic --noinput --clear --skip-checks --no-default-ignore


FROM base as final
ARG UID
ARG GID
COPY --from=py --link /usr/local /usr/local
COPY --from=app --chown=${UID}:${GID} --link /app /app
COPY --from=static --chown=${UID}:${GID} --link /app/staticfiles /app/staticfiles
COPY --from=docker.io/tailscale/tailscale:stable /usr/local/bin/tailscaled /usr/local/bin/tailscale /usr/local/bin/
COPY --chmod=755 --link .bin /
RUN mkdir -p /var/run/tailscale /var/cache/tailscale /var/lib/tailscale \
  && apt-get remove -y --purge \
  build-essential \
  curl \
  git \
  jq \
  && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/*
EXPOSE 8000
