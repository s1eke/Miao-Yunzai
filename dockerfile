FROM node:lts-slim 

ARG GITHUB_ACTIONS

RUN if [ ! "$GITHUB_ACTIONS" ]; then \
    sed -i "s@deb.debian.org@mirrors.cloud.tencent.com@g" /etc/apt/sources.list; fi && \
    apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
    wget \
    vim \
    xz-utils \
    dos2unix \
    ffmpeg \
    curl \
    gnupg \
    git \
    python3 \
    python3-pip \
    fonts-wqy-microhei \
    xfonts-utils \
    chromium \
    fontconfig \
    libxss1 \
    libgl1 \
    build-essential && \
    apt-get autoremove && \
    apt-get clean && \
    rm -rf /var/cache/* && \
    rm -rf /tmp/*

RUN fc-cache -f -v && \
    git config --global --add safe.directory '*' && \
    git config --global pull.rebase false && \
    git config --global user.email "Yunzai@yunzai.bot" && \
    git config --global user.name "Yunzai" && \
    npm config set registry http://mirrors.cloud.tencent.com/npm/ && \
    pip config set global.index-url https://mirrors.cloud.tencent.com/pypi/simple && \
    corepack enable && \
    corepack prepare pnpm@latest --activate

WORKDIR /app/Miao-Yunzai

ARG REPO_URL="https://gitee.com/yoimiya-kokomi/Miao-Yunzai.git" \
    GITHUB_REPO_URL="https://github.com/yoimiya-kokomi/Miao-Yunzai" \
    REPO_BRANCH=master

ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
    PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium \
    NPM_CONFIG_STORE_DIR=/app/.pnpm/

COPY docker-entrypoint.sh /entrypoint.sh

RUN if [ "$GITHUB_ACTIONS" ]; then \
    git clone --depth=1 --branch $REPO_BRANCH $GITHUB_REPO_URL /app/Miao-Yunzai; else \
    git clone --depth=1 --branch $REPO_BRANCH $REPO_URL /app/Miao-Yunzai; fi && \
    cd /app/Miao-Yunzai && \
    pnpm install && \
    chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
