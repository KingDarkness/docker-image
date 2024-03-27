FROM dunglas/frankenphp:1.1.2-php8.2.17

# Generate locale C.UTF-8 for postgres and general locale data
ENV LANG C.UTF-8

ENV SERVER_NAME=:80

ENV PHP_OPCACHE_VALIDATE_TIMESTAMPS="0" \
    PHP_OPCACHE_MAX_ACCELERATED_FILES="10000" \
    PHP_OPCACHE_MEMORY_CONSUMPTION="192" \
    PHP_OPCACHE_MAX_WASTED_PERCENTAGE="10"

# set default time zone for server
ENV TZ=Asia/Ho_Chi_Minh
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update && apt-get install -y libfreetype6-dev libjpeg62-turbo-dev zlib1g-dev libpng-dev libpq-dev libzip-dev libicu-dev libgmp-dev libwebp-dev \
  libmcrypt-dev \
  uuid-dev \
  zip curl \
  && pecl install -o -f redis mcrypt-1.0.4 uuid \
  && rm -rf /tmp/pear \
  && docker-php-ext-enable redis mcrypt uuid \
  && docker-php-ext-install -j$(nproc) iconv opcache \
  && docker-php-ext-configure gd --enable-gd --with-freetype --with-jpeg --with-webp \
  && docker-php-ext-install -j$(nproc) gd\
  && docker-php-source extract \
  && docker-php-ext-install pdo pdo_mysql zip sockets gmp pcntl \
  && docker-php-source delete \
  && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN mv $PHP_INI_DIR/php.ini-production $PHP_INI_DIR/php.ini
RUN sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 10M/g' $PHP_INI_DIR/php.ini
RUN sed -i 's/memory_limit = 128M/memory_limit = 3072M/g' $PHP_INI_DIR/php.ini
RUN sed -i 's/max_execution_time = 30/max_execution_time = 90/g' $PHP_INI_DIR/php.ini
RUN sed -i 's/post_max_size = 8M/post_max_size = 15M/g' $PHP_INI_DIR/php.ini

COPY ./start.sh /usr/local/bin/start
COPY ./opcache.ini /usr/local/etc/php/conf.d/opcache.ini

RUN chmod u+x /usr/local/bin/start

CMD ["/usr/local/bin/start"]

