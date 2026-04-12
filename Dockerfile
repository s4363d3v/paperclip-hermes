FROM node:20-bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive
ENV HOME=/root
ENV PATH="/root/.local/bin:${PATH}"
ENV PAPERCLIP_HOME=/data/paperclip
ENV HERMES_HOME=/root/.hermes

RUN apt-get update && apt-get install -y \
    bash \
    build-essential \
    ca-certificates \
    curl \
    git \
    python3 \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Install Hermes without interactive setup
RUN curl -fsSL https://raw.githubusercontent.com/NousResearch/hermes-agent/main/scripts/install.sh | bash -s -- --skip-setup

# Install Paperclip
RUN npm install -g paperclipai

RUN mkdir -p /data/paperclip /root/.hermes /workspace

WORKDIR /workspace

COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 3100

CMD ["/start.sh"]
