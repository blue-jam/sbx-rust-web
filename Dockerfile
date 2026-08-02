ARG BASE_VARIANT=codex-docker
FROM docker/sandbox-templates:${BASE_VARIANT}

ARG RUSTUP_INIT_VERSION=1.28.2
ARG NVM_VERSION=v0.40.6
ARG NVM_NODE_VERSION=lts/*
ARG ANTIGRAVITY_INSTALL_URL=

ENV CARGO_HOME=/home/agent/.cargo \
    RUSTUP_HOME=/home/agent/.rustup \
    NVM_DIR=/home/agent/.nvm \
    NPM_CONFIG_PREFIX= \
    npm_config_prefix= \
    PATH=/home/agent/.cargo/bin:/home/agent/.nvm/versions/node/default/bin:/home/agent/.local/bin:${PATH}

USER root
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        build-essential \
        pkg-config \
        libssl-dev \
        xz-utils \
        unzip \
    && rm -rf /var/lib/apt/lists/*

USER agent
SHELL ["/bin/bash", "-lc"]
RUN curl --proto '=https' --tlsv1.2 -fsSLo /tmp/rustup-init "https://static.rust-lang.org/rustup/archive/${RUSTUP_INIT_VERSION}/$(uname -m)-unknown-linux-gnu/rustup-init" \
    && chmod +x /tmp/rustup-init \
    && /tmp/rustup-init -y --profile default --default-toolchain stable \
    && rm /tmp/rustup-init \
    && rustup component add rustfmt clippy \
    && unset NPM_CONFIG_PREFIX npm_config_prefix \
    && curl -fsSL "https://raw.githubusercontent.com/nvm-sh/nvm/${NVM_VERSION}/install.sh" | PROFILE=/dev/null bash \
    && source "${NVM_DIR}/nvm.sh" \
    && unset NPM_CONFIG_PREFIX npm_config_prefix \
    && nvm install "${NVM_NODE_VERSION}" \
    && nvm alias default "${NVM_NODE_VERSION}" \
    && nvm use default \
    && ln -sfn "$(dirname "$(dirname "$(which node)")")" "${NVM_DIR}/versions/node/default" \
    && if [ -n "${ANTIGRAVITY_INSTALL_URL}" ]; then curl -fsSL "${ANTIGRAVITY_INSTALL_URL}" | bash && command -v agy; fi \
    && npm config set fund false \
    && npm config set update-notifier false \
    && cargo --version \
    && rustc --version \
    && node --version \
    && npm --version

USER root
RUN printf '%s\n' \
    'unset NPM_CONFIG_PREFIX npm_config_prefix' \
    'export CARGO_HOME="$HOME/.cargo"' \
    'export RUSTUP_HOME="$HOME/.rustup"' \
    'export NVM_DIR="$HOME/.nvm"' \
    '[ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"' \
    >> /etc/sandbox-persistent.sh

USER agent
