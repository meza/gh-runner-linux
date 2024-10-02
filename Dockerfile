FROM ubuntu:latest@sha256:b359f1067efa76f37863778f7b6d0e8d911e3ee8efa807ad01fbf5dc1ef9006b

ARG RUNNER_VERSION="2.319.1"
ARG DEBIAN_FRONTEND=noninteractive

RUN curl -fsSL https://get.docker.com | sh

RUN apt update -y && apt upgrade -y && useradd -m docker
RUN apt install -y --no-install-recommends \
    curl jq build-essential libssl-dev libffi-dev python3 python3-venv python3-dev python3-pip libicu-dev


RUN cd /home/docker && mkdir actions-runner && cd actions-runner \
    && curl -O -L https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz \
    && tar xzf ./actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz

RUN chown -R docker ~docker && /home/docker/actions-runner/bin/installdependencies.sh

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
USER docker

CMD ["/bin/bash", "-c", "./start.sh"]
