FROM louislam/uptime-kuma:base-debian AS pr-test
WORKDIR /app

ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=1

## Install Git
RUN apt update \
    && apt --yes --no-install-recommends install curl \
    && curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
    && chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
    && apt update \
    && apt --yes --no-install-recommends  install git

## Empty the directory, because we have to clone the Git repo.
RUN rm -rf ./* && chown node /app

USER node
RUN git config --global user.email "no-reply@no-reply.com"
RUN git config --global user.name "PR Tester"
RUN git clone https://github.com/louislam/uptime-kuma.git .
RUN npm ci

EXPOSE 3000 3001
VOLUME ["/app/data"]
HEALTHCHECK --interval=60s --timeout=30s --start-period=180s --retries=5 CMD node extra/healthcheck.js
CMD ["npm", "start"]
