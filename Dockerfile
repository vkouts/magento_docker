FROM ubuntu:16.04

MAINTAINER kvn12@ukr.net

ENV TERM=xterm

# Centos default image for some reason does not have tools like Wget/Tar/etc so lets add them
RUN apt-get update && apt-get install -y curl wget nano \
    php7.0 php7.0-cli php7.0-fpm php7.0-mysql php7.0-mcrypt php7.0-gd php7.0-zip php7.0-xml \
    php7.0-iconv php7.0-curl php7.0-soap php7.0-simplexml php7.0-pdo php7.0-mbstring \
    php7.0-dom php7.0-intl nginx mariadb-client \
    && rm -rf /var/lib/apt/lists/*

ADD default.conf /etc/nginx/sites-available/default
ADD php.ini /etc/php/7.0/fpm/

RUN cd ~/ && curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/bin/composer

RUN update-rc.d php7.0-fpm defaults
RUN update-rc.d nginx defaults

WORKDIR /var/www/magento

#RUN chmod -R 777 /var/www/magento/app/etc \
#	&& chmod -R 777 /var/www/magento/var \
#	&& chmod -R 777 /var/www/magento/pub/media \
#	&& chmod -R 777 /var/www/magento/pub/static


EXPOSE 80
ADD init.sh /init.sh
RUN chmod 0755 /init.sh
CMD /init.sh
#install magento files
#RUN cd /tmp && wget http://www.magentocommerce.com/downloads/assets/1.9.0.1/magento-1.9.0.1.tar.gz
#RUN cd /tmp && tar -zxvf magento-1.9.0.1.tar.gz
#RUN mv /tmp/magento /var/www
#RUN cd /var/www/ && chmod -R o+w media var && chmod o+w app/etc && rm -f magento-*tar.gz
#ADD mage-cache.xml /var/www/app/etc/mage-cache.xml
#ADD seturl.php /var/www/seturl.php
#ADD start.sh /var/www/magento/start.sh
#RUN chmod 0755 /start.sh
#RUN echo "daemon off;" >> /etc/nginx/nginx.conf
#CMD ./start.sh
RUN service php7.0-fpm start && nginx


