ARG DISTRO="alpine"
ARG DISTRO_VARIANT="3.20"

FROM docker.io/tiredofit/nginx:${DISTRO}-${DISTRO_VARIANT}
LABEL maintainer="Dave Conroy (github.com/tiredofit)"

ARG N8N_VERSION

ENV N8N_VERSION=${N8N_VERSION:-"1.53.1"} \
    CONTAINER_ENABLE_MESSAGING=FALSE \
    NGINX_SITE_ENABLED=n8n \
    NGINX_WEBROOT=/app \
    NGINX_ENABLE_CREATE_SAMPLE_HTML=FALSE \
    IMAGE_NAME="tiredofit/n8n" \
    IMAGE_REPO_URL="https://github.com/tiredofit/docker-n8n/"

RUN source /assets/functions/00-container && \
    set -x && \
    package update && \
    package upgrade && \
    package install .n8n-build-deps \
               build-base \
               python3 \
               && \
    \
    package install .n8n-run-deps \
               graphicsmagick \
               git \
               nodejs \
               npm \
               openssh-client \
               && \
    \
    mkdir -p /app && \
    npm_config_user=root npm install -g typescript && \
    npm_config_user=root npm install -g n8n@${N8N_VERSION} && \
    \
    package remove .n8n-build-deps && \
    package cleanup && \
    rm -rf /root/.npm

WORKDIR /app/

EXPOSE 5678

COPY install /
