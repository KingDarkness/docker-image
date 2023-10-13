FROM php:8.2.11-cli-bullseye

# Generate locale C.UTF-8 for postgres and general locale data
ENV LANG C.UTF-8

VOLUME /var/www/html
WORKDIR /var/www/html

# set default time zone for server
ENV TZ=Asia/Ho_Chi_Minh
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update && apt-get install -y libfreetype6-dev libjpeg62-turbo-dev zlib1g-dev libpng-dev libpq-dev libzip-dev libicu-dev libgmp-dev libwebp-dev \
    libmcrypt-dev \
    libsodium-dev \
    uuid-dev \
    zip curl \
    && pecl install -o -f redis mcrypt-1.0.4 libsodium uuid swoole \
    && rm -rf /tmp/pear \
    && docker-php-ext-enable redis mcrypt sodium uuid swoole \
    && docker-php-ext-install -j$(nproc) iconv \
    && docker-php-ext-configure gd --enable-gd --with-freetype --with-jpeg --with-webp \
    && docker-php-ext-install -j$(nproc) gd\
    && docker-php-source extract \
    && docker-php-ext-install pdo pdo_mysql zip gmp pcntl \
    && docker-php-source delete \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN mv $PHP_INI_DIR/php.ini-production $PHP_INI_DIR/php.ini
RUN sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 10M/g' $PHP_INI_DIR/php.ini
RUN sed -i 's/memory_limit = 128M/memory_limit = 3072M/g' $PHP_INI_DIR/php.ini
RUN sed -i 's/max_execution_time = 30/max_execution_time = 90/g' $PHP_INI_DIR/php.ini
RUN sed -i 's/post_max_size = 8M/post_max_size = 15M/g' $PHP_INI_DIR/php.ini


COPY ./start.sh /usr/local/bin/start

RUN chown -R www-data:www-data /var/www/html \
    && chmod u+x /usr/local/bin/start

CMD ["/usr/local/bin/start"]
