ARG BUILD_FROM=ghcr.io/hassio-addons/debian-base:stable
# hadolint ignore=DL3006
FROM ${BUILD_FROM}

# Confiure locale
ENV \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8 \
    PIP_BREAK_SYSTEM_PACKAGES=1

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Copy Python requirements file
COPY requirements.txt /tmp/requirements.txt

# Setup base system
ARG BUILD_ARCH=amd64
ARG CODE_SERVER_VERSION="v4.21.0"
ARG HA_CLI_VERSION="4.29.0"
# hadolint ignore=SC2181, DL3008
RUN \
    apt-get update \
    \
    && apt-get install -y --no-install-recommends \
        certbot \
        python3-pip \
        git \
        mc \
        locales-all \
    \
    && if [[ "${BUILD_ARCH}" = "aarch64" ]]; then ARCH="arm64"; fi \
    && if [[ "${BUILD_ARCH}" = "amd64" ]]; then ARCH="amd64"; fi \
    && if [[ "${BUILD_ARCH}" = "armhf" ]]; then export MULTIDICT_NO_EXTENSIONS=1; fi \
    && if [[ "${BUILD_ARCH}" = "armv7" ]]; then export MULTIDICT_NO_EXTENSIONS=1; fi \
    && if [[ "${BUILD_ARCH}" = "armv7l" ]]; then export MULTIDICT_NO_EXTENSIONS=1; fi \
    \
    && pip3 install --upgrade --no-cache-dir -r /tmp/requirements.txt \
    && apt remove git mc -y \
    && apt autoremove -y \
    && apt clean -y

# Copy root filesystem
COPY rootfs /

# Build arguments
ARG BUILD_ARCH
ARG BUILD_DATE
ARG BUILD_DESCRIPTION
ARG BUILD_NAME
ARG BUILD_REF
ARG BUILD_REPOSITORY
ARG BUILD_VERSION

# Labels
LABEL \
    io.hass.name="${BUILD_NAME}" \
    io.hass.description="${BUILD_DESCRIPTION}" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version=${BUILD_VERSION} \
    maintainer="Smartverse <smartverse@smartverse.ru>" \
    org.opencontainers.image.title="${BUILD_NAME}" \
    org.opencontainers.image.description="${BUILD_DESCRIPTION}" \
    org.opencontainers.image.vendor="Home Assistant Add-ons" \
    org.opencontainers.image.authors="Smartverse <smartverse@smartverse.ru>" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.url="https://smartverse.ru" \
    org.opencontainers.image.source="https://github.com/${BUILD_REPOSITORY}" \
    org.opencontainers.image.documentation="https://github.com/${BUILD_REPOSITORY}/blob/main/README.md" \
    org.opencontainers.image.created=${BUILD_DATE} \
    org.opencontainers.image.revision=${BUILD_REF} \
    org.opencontainers.image.version=${BUILD_VERSION}
