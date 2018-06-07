FROM php:7.1-apache

RUN apt-get update && apt-get install --assume-yes \
    curl \
    libmcrypt-dev \
    git \
    zlib1g-dev

RUN docker-php-ext-install \
    zip \
    mcrypt

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN a2enmod rewrite

RUN /usr/local/bin/composer create-project --prefer-dist laravel/lumen /var/www/html

RUN composer require ratepay/php-library

RUN git clone https://github.com/ratepay/ramp.git ramp-temp && \
    rm -rf ramp-temp/.git && \
    rsync -r ramp-temp/ ./ && \
    rm -rf ramp-temp

RUN chown www-data:www-data -R ./