#!/bin/bash
if [[ -z "$DOCKER_PREFIX" ]]; then
    export DOCKER_PREFIX=localhost:31000
    kubectl port-forward service/registry-local 31000:5000 &
    export KUBECTL_PID=$!
    trap cleanup EXIT
fi
if [[ -z "$DOCKER_TAG" ]]; then
    export DOCKER_TAG=$(git describe --abbrev=0 --tags)
fi

function cleanup {
	kill $KUBECTL_PID
}

function main {
    make && make push
}

[[ "$0" == "$BASH_SOURCE" ]] && main "$@"