FROM phpswoole/swoole:4.5.7-php7.4

COPY ./rootfilesystem/ /

RUN apt-get update && apt-get install -y --no-install-recommends \
      git \
      unzip \
      zip \
    && apt-get clean \
    && rm -r /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y --no-install-recommends \
      libicu-dev \
      libzip-dev \
    && docker-php-ext-install -j5 \
        bcmath \
        intl \
        json \
        opcache \
        pdo_mysql \
        zip \
    && apt-get clean \
    && rm -r /var/lib/apt/lists/*

RUN curl -sS https://getcomposer.org/installer | php -- \
      --install-dir=/usr/local/bin --filename=composer \
      --version 2.0.6

RUN mkdir /home/utente \
    && groupadd -g 1000 utente \
    && useradd -u 1000 --gid 1000 -d /home/utente -s /bin/bash utente \
    && usermod -a -G www-data utente \
    && chown utente /home/utente

WORKDIR /var/www/app

USER utente

ARG GITHUB_TOKEN
# ARG BITBUCKET_CONSUMER_KEY
# ARG BITBUCKET_CONSUMER_SECRET

RUN composer config -g github-oauth.github.com $GITHUB_TOKEN \
#     && composer config -g bitbucket-oauth.bitbucket.org.consumer-key $BITBUCKET_CONSUMER_KEY \
#     && composer config -g bitbucket-oauth.bitbucket.org.consumer-secret $BITBUCKET_CONSUMER_SECRET \
#   https://github.com/coopcycle/coopcycle-web/issues/1853
#    && composer global require \
#        --no-suggest --no-interaction \
#        hirak/prestissimo \
    && rm -rf ~/.composer/cache

USER root
