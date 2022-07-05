#!/usr/bin/env bash
set -e

script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)

declare -a contexts=(ui-only standalone joinmarket/base)

ORG="theborakompanioni"
IMAGE_NAME_PREFIX="jmui-local"
IMAGE_TAG='latest'

for context in "${contexts[@]}"
do
    docker_path="${script_dir}/${context}"
    image_name="${ORG}/${IMAGE_NAME_PREFIX}-${context}:${IMAGE_TAG}"
    echo "Building docker image ${image_name}"
	docker build --label "local" --tag "${image_name}" "${docker_path}"
    echo "Built image ${image_name}"
    echo "Run with: docker run -it --rm -p \"8080:80\" ${image_name}"
    echo "Inspect with: docker run --rm --entrypoint="/bin/bash" -it ${image_name}"
    echo "(or --entrypoint="/bin/ash")"
done
