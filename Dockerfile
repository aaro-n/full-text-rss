FROM php:7.0-apache

ENV RSS_ADMIN_USER rss
ENV RSS_ADMIN_PASSWORD abc123
ENV RSS_API_KEY B8CGzp88Jf
ENV RSS_CRON_SITE 66cdcaf030bd5f690c7d00997e0168957bff6642
ENV RSS_CRON "17 19 * * * /home/www/site-specific.sh >>/tmp/site-specific.log 2>&1"

RUN   apt-get update && \
      apt-get -y install --no-install-recommends \
      libtidy-dev \
      libzip-dev \
      zip \
      zlib1g-dev libicu-dev g++ \
      cron tzdata wget curl \
      && rm -rf /var/lib/apt/lists/*

RUN   docker-php-ext-install tidy && \
      docker-php-ext-install opcache && \
      docker-php-ext-install zip && \
      docker-php-ext-configure intl && \
      docker-php-ext-install intl && \
      pecl install apcu && \
      pecl install apcu_bc && \
      docker-php-ext-enable apcu 

COPY  config/opcache.ini /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini 

COPY  config/apcu.ini /usr/local/etc/php/conf.d/docker-php-ext-apcu.ini

COPY  config/crontab /etc/cron.d/cron

COPY  config/reboot.sh /home/www/reboot.sh

COPY  config/custom_config.php /home/www/custom_config.php

COPY  source-code /var/www/html/

COPY  config/site-specific.sh /home/www/site-specific.sh

COPY  config/env.sh /home/www/env.sh

COPY  config/admin-env.sh /home/www/admin-env.sh

RUN   chown -R www-data:www-data /var/www/html/ && \
      chmod 777 /var/www/html/cache/ && \
      chmod +x /home/www/reboot.sh && \
      chmod +x /home/www/site-specific.sh && \
      chmod +x  /home/www/env.sh && \
      chmod +x  /home/www/admin-env.sh && \
      chmod 0644 /etc/cron.d/cron && \
      crontab /etc/cron.d/cron

RUN   sed -i '$i\env >> /etc/environment' /usr/local/bin/apache2-foreground && \
      sed -i 's/^exec /service cron start\n\nexec /' /usr/local/bin/apache2-foreground
