FROM node:20-bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive
ENV PAPERCLIP_HOME=/data/paperclip
ENV HERMES_HOME=/data/hermes

RUN apt-get update && apt-get install -y \
    bash \
    build-essential \
    ca-certificates \
    curl \
    git \
    python3 \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Install Hermes to /opt/hermes (not /root) so the node user can access it.
# HOME must be exported so the piped bash subprocess inherits it.
RUN mkdir -p /opt/hermes \
    && export HOME=/opt/hermes \
    && curl -fsSL https://raw.githubusercontent.com/NousResearch/hermes-agent/main/scripts/install.sh | bash -s -- --skip-setup \
    && chmod -R a+rX /opt/hermes \
    && ln -sf /opt/hermes/.local/bin/hermes /usr/local/bin/hermes

# Pre-seed minimal Hermes config so it never triggers the interactive setup wizard.
# The model/provider can be overridden at runtime via HERMES_MODEL and
# HERMES_INFERENCE_PROVIDER env vars.
COPY hermes-config.yaml /etc/hermes/config.yaml
RUN touch /etc/hermes/.env

# Install Paperclip (goes to /usr/local/bin, accessible by all users)
RUN npm install -g paperclipai

RUN mkdir -p /data/paperclip /data/hermes /workspace \
    && chown -R node:node /data/paperclip /data/hermes /workspace

RUN chmod -R 777 /data
RUN chmod -R 777 /opt/hermes
RUN chmod -R 777 /workspace
RUN chmod -R 777 /etc/hermes
RUN chmod -R 777 /usr/local/lib
RUN chmod -R 777 /usr/local/bin

RUN usermod -a -G root node

WORKDIR /workspace

COPY start.sh /start.sh
RUN chmod +x /start.sh


ENV PAPERCLIP_HOME="/data/paperclip"
ENV HERMES_HOME="/data/hermes"
ENV HOME="/data/paperclip"
ENV HOST="0.0.0.0"

RUN mkdir -p "/data/paperclip" "/data/hermes"
RUN chown -R node:node "/data/paperclip" "/data/hermes"

# Seed Hermes config if not already present
RUN cp /etc/hermes/config.yaml "/data/hermes/config.yaml"
RUN cp /etc/hermes/.env        "/data/hermes/.env"

USER node
EXPOSE 3100

CMD ["/start.sh"]
