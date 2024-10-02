FROM mcr.microsoft.com/playwright:v1.47.2-noble

ARG RUNNER_VERSION="2.319.1"
ARG DEBIAN_FRONTEND=noninteractive
ARG USER=pwuser

RUN curl -fsSL https://get.docker.com | sh

RUN apt update -y && apt upgrade -y
RUN apt install -y --no-install-recommends \
    curl jq build-essential libssl-dev libffi-dev python3 python3-venv python3-dev python3-pip libicu-dev


RUN cd /home/${USER} && mkdir actions-runner && cd actions-runner \
    && curl -O -L https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz \
    && tar xzf ./actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz

RUN chown -R pwuser ~pwuser && /home/${USER}/actions-runner/bin/installdependencies.sh

RUN apt install -y --no-install-recommends mc git

#ENV NVM_DIR=/usr/local/nvm
#ENV PLAYWRIGHT_BROWSERS_PATH=/usr/local/playwright-browsers
#
#RUN mkdir -p $NVM_DIR \
#    && curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
#
#RUN echo "source $NVM_DIR/nvm.sh \
#    && nvm install node \
#    && nvm use default \
#    && npm install -g npm@latest \
#    && npm install -g yarn@latest \
#    && npm install -g pnpm@latest \
#    && npx playwright install --with-deps \
#    && echo \"source $NVM_DIR/nvm.sh\" >> /home/docker/.bashrc"  | bash

COPY start.sh start.sh
RUN chmod +x start.sh
USER ${USER}

CMD ["/bin/bash", "-c", "./start.sh"]
