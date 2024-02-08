ARG PYTHON_VERSION=3.11
ARG NODE_VERSION=20.9.0
ARG NVM_VERSION=0.39.5
ARG TAILWINDCSS_VERSION=3.4.0
ARG TAILWINDCSS_ARCH=x64
ARG VITE_API_BASE_URL=http://localhost:8000/api/
ARG UID=1000
ARG GID=1000

FROM python:${PYTHON_VERSION}-slim as base
ARG UID
ARG GID
ENV DEBUG False
ENV PYTHONPATH /app
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1
RUN mkdir -p /app /app/mediafiles
RUN echo 'deb http://deb.debian.org/debian/ bookworm main contrib' >> /etc/apt/sources.list \
  && DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y --no-install-recommends \
  build-essential \
  curl \
  git \
  # tailscale
  ca-certificates \
  iptables \
  gosu \
  # cleanup
  && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/*
RUN addgroup -gid "${GID}" --system django \
  && adduser -uid "${UID}" -gid "${GID}" --home /home/django --system django
WORKDIR /app


FROM base as py
COPY requirements*.txt ./
RUN python -m pip install --upgrade pip \
  && python -m pip install -r requirements.txt \
  && python -m pip install -r requirements.nohash.txt


FROM base as node
ARG NODE_VERSION
ARG NVM_VERSION
ENV NVM_DIR=/usr/local/share/nvm
ENV PATH="$NVM_DIR/versions/node/v${NODE_VERSION}/bin:${PATH}"
COPY --from=py /usr/local /usr/local
COPY package*.json /app/
RUN mkdir -p ${NVM_DIR} \
  && curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v${NVM_VERSION}/install.sh | bash \
  && . "$NVM_DIR/nvm.sh" \
  && nvm use v${NODE_VERSION} \
  && nvm alias default v${NODE_VERSION} \
  && chmod -R 755 "$NVM_DIR" \
  && npm install -g npm@latest \
  && npm install


FROM node as tailwind
ARG TAILWINDCSS_VERSION
ARG TAILWINDCSS_ARCH
ADD https://github.com/tailwindlabs/tailwindcss/releases/download/v${TAILWINDCSS_VERSION}/tailwindcss-linux-${TAILWINDCSS_ARCH} /usr/local/bin/tailwindcss-linux-${TAILWINDCSS_ARCH}-${TAILWINDCSS_VERSION}
RUN chmod 755 /usr/local/bin/tailwindcss-linux-${TAILWINDCSS_ARCH}-${TAILWINDCSS_VERSION} \
  && chown ${UID}:${GID} /usr/local/bin/tailwindcss-linux-${TAILWINDCSS_ARCH}-${TAILWINDCSS_VERSION}


FROM base as app
COPY --from=py /usr/local /usr/local
COPY manage.py /app
COPY with_vite /app/with_vite
COPY templates /app/templates


FROM node as node-final
ARG VITE_API_BASE_URL
COPY --from=tailwind /usr/local /usr/local
COPY --from=app /app /app
COPY static /app/static
COPY postcss.config.js tailwind.config.js tsconfig.json vite.config.ts /app/
RUN npm run build \
  && python manage.py tailwind --skip-checks build


FROM app as static
ENV DATABASE_URL sqlite://:memory:
COPY --from=py /usr/local /usr/local
COPY --from=node-final /app/static/dist /app/static/dist
COPY static/public /app/static/public
RUN python manage.py collectstatic --noinput --clear --skip-checks --no-default-ignore


FROM base as final
COPY --from=py /usr/local /usr/local
COPY --from=app /app /app
COPY --from=static /app/staticfiles /app/staticfiles
COPY --from=docker.io/tailscale/tailscale:stable /usr/local/bin/tailscaled /usr/local/bin/tailscaled
COPY --from=docker.io/tailscale/tailscale:stable /usr/local/bin/tailscale /usr/local/bin/tailscale
COPY .bin /
RUN mkdir -p /var/run/tailscale /var/cache/tailscale /var/lib/tailscale \
  && chmod +x /release.sh /tailscale.sh /web.sh /worker.sh \
  && chown -R django:django /app \
  && DEBIAN_FRONTEND=noninteractive apt-get remove -y --purge \
  build-essential \
  curl \
  git \
  && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/*
EXPOSE 8000
