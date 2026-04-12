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

# Install Hermes to /opt/hermes (not /root) so the node user can access it
RUN HOME=/opt/hermes \
    curl -fsSL https://raw.githubusercontent.com/NousResearch/hermes-agent/main/scripts/install.sh | bash -s -- --skip-setup \
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

WORKDIR /workspace

COPY start.sh /start.sh
COPY start-worker.sh /start-worker.sh
RUN chmod +x /start.sh /start-worker.sh

EXPOSE 3100

CMD ["/start.sh"]
