#!/usr/bin/env bash

PROJECT_NAME=$(basename $(pwd) | tr '[:upper:]' '[:lower:]')
COMPOSE_OVERRIDE=
PHP_CONTAINER=php
PHP_USER=utente

if [[ -f "./docker/docker-compose.override.yml" ]]; then
  COMPOSE_OVERRIDE="--file ./docker/docker-compose.override.yml"
fi

DC_BASE_COMMAND="docker-compose
    --file docker/docker-compose.yml
    ${COMPOSE_OVERRIDE}
    -p ${PROJECT_NAME}"

DC_RUN="${DC_BASE_COMMAND}
    run
    --service-ports
    --rm
    -u ${PHP_USER}
    ${PHP_CONTAINER}"

if [[ "$1" == "composer" ]]; then

  shift 1
  ${DC_RUN} \
    composer "$@"

elif [[ "$1" == "up" ]]; then

  shift 1
  ${DC_BASE_COMMAND} \
    up "$@"

elif [[ "$1" == "build" ]] && [[ "$2" == "php" ]]; then

  ${DC_BASE_COMMAND} \
    build ${PHP_CONTAINER}

elif [[ "$1" == "enter-root" ]]; then

  ${DC_BASE_COMMAND} \
    exec \
    -u root \
    ${PHP_CONTAINER} /bin/bash

elif [[ "$1" == "enter" ]]; then

  ${DC_BASE_COMMAND} \
    exec \
    -u ${PHP_USER} \
    ${PHP_CONTAINER} /bin/bash

elif [[ "$1" == "down" ]]; then

  shift 1
  ${DC_BASE_COMMAND} \
    down "$@"

elif [[ "$1" == "purge" ]]; then

  ${DC_BASE_COMMAND} \
    down \
    --rmi=all \
    --volumes \
    --remove-orphans

elif [[ "$1" == "log" ]]; then

  ${DC_BASE_COMMAND} \
    logs -f

elif [[ "$1" == "exec" ]]; then

  shift 1
  ${DC_BASE_COMMAND} \
    exec \
    -u ${PHP_USER} \
    ${PHP_CONTAINER} \
    "$@"

elif [[ "$1" == "run" ]]; then

  shift 1
  ${DC_RUN} \
    "$@"

elif [[ "$1" == "runr" ]]; then

  PHP_USER=root

  shift 1
  ${DC_RUN} \
    "$@"

  PHP_USER=utente

elif [[ $# -gt 0 ]]; then

  ${DC_BASE_COMMAND} \
    "$@"

else

  ${DC_BASE_COMMAND} \
    ps
fi
