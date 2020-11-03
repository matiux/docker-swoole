#!/usr/bin/env bash

WORKDIR=/var/www/app
PROJECT_NAME=$(basename "$(pwd)" | tr '[:upper:]' '[:lower:]')
COMPOSE_OVERRIDE=
PHP_CONTAINER=php_swoole_csv_handler

if [[ -f "./docker/docker-compose.override.yml" ]]; then
  COMPOSE_OVERRIDE="--file ./docker/docker-compose.override.yml"
fi

DC_BASE_COMMAND="docker-compose
    --file docker/docker-compose.yml
    ${COMPOSE_OVERRIDE}
    -p ${PROJECT_NAME}"

DC_RUN="${DC_BASE_COMMAND}
    run
    --rm
    -u utente
    -v ${PWD}:${WORKDIR}
    -w ${WORKDIR}
    ${PHP_CONTAINER}"

#-T
DC_EXEC="${DC_BASE_COMMAND}
  exec
  -u utente
  -w ${WORKDIR}
  ${PHP_CONTAINER}"

if [[ "$1" == "composer" ]]; then

  shift 1
  ${DC_RUN} \
    composer "$@"

elif [[ "$1" == "php-cs-fixer-fix" ]]; then

  shift 1
  ${DC_EXEC} \
    vendor/bin/php-cs-fixer fix --config=.php_cs.dist "$@"

elif [[ "$1" == "php-cs-fixer" ]]; then

  shift 1
  ${DC_EXEC} \
    vendor/bin/php-cs-fixer "$@"

elif [[ "$1" == "psalm" ]]; then

  shift 1
  ${DC_EXEC} \
    vendor/bin/psalm "$@"

elif [[ "$1" == "phpunit" ]]; then

  shift 1
  ${DC_EXEC} \
    vendor/bin/phpunit "$@"

elif [[ "$1" == "up" ]]; then

  shift 1
  ${DC_BASE_COMMAND} \
    up "$@"

elif [[ "$1" == "build" ]] && [[ "$2" == "php" ]]; then

  ${DC_BASE_COMMAND} \
    build ${PHP_CONTAINER}

elif [[ "$1" == "enter" ]]; then

  ${DC_EXEC} \
     /bin/zsh

elif [[ "$1" == "enter-root" ]]; then

  ${DC_EXEC} \
    /bin/zsh

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

elif [[ $# -gt 0 ]]; then

  ${DC_BASE_COMMAND} \
    "$@"

else

  ${DC_BASE_COMMAND} \
    ps
fi
