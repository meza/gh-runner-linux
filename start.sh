#!/bin/bash

ACCESS_TOKEN=$TOKEN

echo "ACCESS_TOKEN ${ACCESS_TOKEN}"

REG_TOKEN=$(curl -X POST -H "Authorization: token ${ACCESS_TOKEN}" -H "Accept: application/vnd.github+json" https://api.github.com/enterprises/stateshifters/actions/runners/registration-token | jq .token --raw-output)

cd ~/actions-runner

./config.sh --url https://github.com/enterprises/stateshifters --token ${REG_TOKEN} --labels ubuntu-latest,${GH_LABELS} --unattended --work ${GITHUB_WORKSPACE}

cleanup() {
    echo "Removing runner..."
    ./config.sh remove --token ${REG_TOKEN}
}

trap 'cleanup; exit 130' INT
trap 'cleanup; exit 143' TERM

./run.sh & wait $!
