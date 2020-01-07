FROM php:7.1-fpm-alpine
RUN apk add --no-cache curl libmcrypt-dev freetype libpng libjpeg-turbo freetype-dev libpng-dev libjpeg-turbo-dev php7-phpdbg \
    && docker-php-ext-install mcrypt pdo_mysql zip \
    && docker-php-ext-configure gd \
        --with-gd \
        --with-freetype-dir=/usr/include/ \
        --with-png-dir=/usr/include/ \
        --with-jpeg-dir=/usr/include/ && \
    NPROC=$(grep -c ^processor /proc/cpuinfo 2>/dev/null || 1) && \
    docker-php-ext-install -j${NPROC} gd && \
    apk del --no-cache freetype-dev libpng-dev libjpeg-turbo-dev \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && rm -rf /tmp/*