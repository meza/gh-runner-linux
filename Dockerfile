FROM mcr.microsoft.com/playwright:v1.47.2-noble@sha256:f640d04686ef8fcca228955dc73f36b86ccd2228eda488fb2b32f3f037639f09

ARG RUNNER_VERSION="2.319.1"
ARG DEBIAN_FRONTEND=noninteractive
ENV PW_USER=pwuser
ENV GH_LABELS="self-hosted,playwright,github-actions"
ENV GITHUB_ACTIONS=true
ENV GITHUB_WORKSPACE=/home/${PW_USER}/actions-runner/_work

RUN apt update -y && apt upgrade -y
RUN apt install -y --no-install-recommends \
    curl jq build-essential libssl-dev libffi-dev python3 python3-venv python3-dev python3-pip libicu-dev


RUN cd /home/${PW_USER} && mkdir actions-runner && cd actions-runner \
    && curl -O -L https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz \
    && tar xzf ./actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz

RUN chown -R pwuser ~pwuser && /home/${PW_USER}/actions-runner/bin/installdependencies.sh

RUN apt install -y --no-install-recommends mc git zip unzip

RUN PW_GROUP_ID=$(getent group ${PW_USER} | cut -d: -f3) && usermod -u ${PW_GROUP_ID} -g ${PW_GROUP_ID} ${PW_USER}

RUN curl -fsSL https://get.docker.com | sh
RUN usermod -aG docker ${PW_USER} && \
    newgrp docker

RUN mkdir -p ${GITHUB_WORKSPACE} \
    && chown -R pwuser:pwuser ${GITHUB_WORKSPACE}

COPY start.sh start.sh
RUN chmod +x start.sh
USER ${PW_USER}
WORKDIR /home/${PW_USER}

CMD ["/bin/bash", "-c", "/start.sh"]
