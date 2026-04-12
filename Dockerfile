FROM node:20-bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive
ENV PAPERCLIP_HOME=/data/paperclip
ENV HERMES_HOME=/data/hermes
ENV PATH="/root/.local/bin:${PATH}"

RUN apt-get update && apt-get install -y \
    curl \
    git \
    bash \
    ca-certificates \
    python3 \
    python3-pip \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Install Hermes
RUN curl -fsSL https://raw.githubusercontent.com/NousResearch/hermes-agent/main/scripts/install.sh | bash

# Install Paperclip CLI
RUN npm install -g paperclipai

RUN mkdir -p /data/paperclip /data/hermes /workspace

WORKDIR /workspace

COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 3100

CMD ["/start.sh"]
