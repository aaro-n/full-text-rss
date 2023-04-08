#! /bin/bash
#rm /var/www/html/custom_config.php
cp /home/www/custom_config.php /var/www/html/custom_config.php
chown -R www-data:www-data /var/www/html/custom_config.php
chown -R www-data:www-data /var/www/html/
chmod 777 /var/www/html/cache/
