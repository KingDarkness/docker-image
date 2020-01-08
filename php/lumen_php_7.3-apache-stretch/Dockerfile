FROM php:7.3-apache-stretch

# Generate locale C.UTF-8 for postgres and general locale data
ENV LANG C.UTF-8

# set default time zone for server
ENV TZ=Asia/Ho_Chi_Minh
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update && apt-get install -y libfreetype6-dev libjpeg62-turbo-dev zlib1g-dev libpng-dev libpq-dev libzip-dev libicu-dev \
        curl \
    && docker-php-ext-install -j$(nproc) iconv \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd\
    && docker-php-source extract \
    && docker-php-ext-install pdo pdo_mysql zip \
    && docker-php-source delete \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN if [ "$APP_ENV" == "production" ]; then mv $PHP_INI_DIR/php.ini-production $PHP_INI_DIR/php.ini; else mv $PHP_INI_DIR/php.ini-development $PHP_INI_DIR/php.ini; fi
RUN sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 10M/g' $PHP_INI_DIR/php.ini
RUN sed -i 's/memory_limit = 128M/memory_limit = 3072M/g' $PHP_INI_DIR/php.ini
RUN sed -i 's/max_execution_time = 30/max_execution_time = 90/g' $PHP_INI_DIR/php.ini
RUN sed -i 's/post_max_size = 8M/post_max_size = 15M/g' $PHP_INI_DIR/php.ini


COPY ./vhost.conf /etc/apache2/sites-available/000-default.conf
COPY ./start.sh /usr/local/bin/start

RUN chown -R www-data:www-data /var/www/html \
    && chmod u+x /usr/local/bin/start \
    && a2enmod rewrite

VOLUME /var/www/html
WORKDIR /var/www/html

CMD ["/usr/local/bin/start"]