FROM php:7.4.5-fpm

RUN apt-get update
RUN apt-get install -y curl git supervisor nginx nginx-extras \ 
 zlib1g-dev libpng-dev \ 
 libicu-dev libxslt-dev libzip-dev

RUN curl https://getcomposer.org/download/$(curl -s https://api.github.com/repos/composer/composer/releases/latest | grep 'tag_name' | cut -d '"' -f 4)/composer.phar -o /usr/local/bin/composer && chmod +x /usr/local/bin/composer
ENV php_vars /usr/local/etc/php/conf.d/docker-vars.ini
ENV fpm_conf /usr/local/etc/php-fpm.d/www.conf
WORKDIR /var/www/html

RUN docker-php-ext-install iconv pdo_mysql
RUN docker-php-ext-install mysqli gd exif intl xsl json zip opcache

## Debug 
RUN pecl install xdebug

RUN echo "opcache.enable=1" >> /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini && \
    echo "opcache.preload_user=www-data" >> /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini && \
    echo "opcache.preload=/var/www/html/preload.php" >> /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini && \
    echo 'max_execution_time = 120s' > /usr/local/etc/php/conf.d/docker-php-maxexectime.ini && \
    echo "cgi.fix_pathinfo=0" > ${php_vars} &&\
    echo "upload_max_filesize = 25M"  >> ${php_vars} &&\
    echo "post_max_size = 25M"  >> ${php_vars} &&\
    echo "variables_order = \"EGPCS\""  >> ${php_vars} && \
    echo "memory_limit = 128M"  >> ${php_vars} && \
    sed -i \
        -e "s/;catch_workers_output\s*=\s*yes/catch_workers_output = yes/g" \
        -e "s/pm.max_children = 5/pm.max_children = 4/g" \
        -e "s/pm.start_servers = 2/pm.start_servers = 3/g" \
        -e "s/pm.min_spare_servers = 1/pm.min_spare_servers = 2/g" \
        -e "s/pm.max_spare_servers = 3/pm.max_spare_servers = 4/g" \
        -e "s/;pm.max_requests = 500/pm.max_requests = 200/g" \
        -e "s/;listen.mode = 0660/listen.mode = 0666/g" \
        -e "s/listen = 127.0.0.1:9000/listen = \/var\/run\/php-fpm.sock/g" \
        -e "s/^;clear_env = no$/clear_env = no/" \
        ${fpm_conf}

COPY conf/nginx-site.conf /etc/nginx/conf.d/
COPY conf/nginx.conf /etc/nginx/nginx.conf
COPY conf/supervisord.conf /etc/supervisord.conf
COPY scripts/start.sh /start.sh

COPY src/composer.json src/composer.lock /var/www/html/
RUN composer install
COPY ./src /var/www/html
ARG GIT_REV
LABEL "flo.git_rev"=$GIT_REV
RUN chown www-data:www-data /var/www/html && chmod +x /start.sh
CMD ["/start.sh"]