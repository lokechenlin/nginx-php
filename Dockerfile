FROM centos:7.5.1804

WORKDIR /tmp

# Install all required package; Use --nogpgcheck to avoid nokey warning
RUN \
  yum update -y && \  
  yum install -y --nogpgcheck deltarpm-3.6-3.el7.x86_64  && \  
  yum install -y --nogpgcheck epel-release && \  
  yum install -y --nogpgcheck nginx && \
  yum install -y --nogpgcheck wget.x86_64 && \
  yum install -y --nogpgcheck tar.x86_64 && \
  yum install -y --nogpgcheck gcc.x86_64 && \
  yum install -y --nogpgcheck make.x86_64 && \
  yum install -y --nogpgcheck gmp-devel.x86_64 && \
  yum install -y --nogpgcheck libxml2-devel && \   
  yum install -y --nogpgcheck openssl-devel.x86_64 && \
  yum install -y --nogpgcheck libcurl-devel.x86_64 && \
  yum install -y --nogpgcheck libjpeg-turbo-devel.x86_64 && \
  yum install -y --nogpgcheck libpng-devel.x86_64 && \
  yum install -y --nogpgcheck freetype-devel.x86_64 && \
  yum install -y --nogpgcheck libxslt-devel.x86_64 && \
  yum install -y --nogpgcheck libmcrypt-devel.x86_64 && \
  yum install -y --nogpgcheck autoconf && \
  yum install -y --nogpgcheck gcc-c++.x86_64 && \
  yum install -y --nogpgcheck supervisor && \
  yum install -y --nogpgcheck sendmail && \
  yum clean all && \ 
  mv /etc/localtime /etc/localtime.bak && \
  ln -s /usr/share/zoneinfo/Asia/Singapore /etc/localtime

# Install PHP   
RUN \
  cd /tmp && \
  wget http://my1.php.net/distributions/php-7.2.10.tar.gz && \
  tar -zxvf php-7.2.10.tar.gz && \
  cd php-7.2.10 && \
  ./configure --prefix=/usr/local/php-7.2.10  --enable-debug --enable-maintainer-zts --with-tsrm-pthreads --enable-sigchild --enable-fpm --disable-cgi --enable-sockets --enable-pcntl --enable-calendar --enable-bcmath --enable-hash --enable-soap --enable-ftp --enable-simplexml --enable-xml --enable-json --enable-opcache --enable-session --enable-exif --enable-mbstring --enable-cli --with-zlib-dir=/usr --with-png-dir=/usr --with-jpeg-dir=/usr --with-freetype-dir=/usr --with-xsl=/usr --with-gd --with-gettext --with-curl --enable-mysqlnd --with-mysqli=mysqlnd --with-pdo-mysql=mysqlnd  --with-openssl --enable-zip --with-libdir=lib64 --with-pcre-regex --with-fpm-user=www-data --with-fpm-group=www-data && \ 
  make && \
  make install && \
  ln -s /usr/local/php-7.2.10/bin/php /usr/bin/php

# Apply PHP Configuration 
ADD config/php.ini /usr/local/php-7.2.10/lib/php.ini

# https://serverpilot.io/docs/how-to-install-the-php-mcrypt-extension
RUN \
  cd /tmp && \
  wget https://pecl.php.net/get/mcrypt-1.0.1.tgz && \
  tar -zxvf mcrypt-1.0.1.tgz && \ 
  cd mcrypt-1.0.1 && \ 
  /usr/local/php-7.2.10/bin/phpize && \ 
  ./configure --with-php-config=/usr/local/php-7.2.10/bin/php-config && \ 
  make && \ 
  make install 

# Memcached extension
RUN \
  cd /tmp && \
  wget https://launchpad.net/libmemcached/1.0/1.0.18/+download/libmemcached-1.0.18.tar.gz && \
  tar -zxvf libmemcached-1.0.18.tar.gz && \ 
  cd libmemcached-1.0.18 && \ 
  ./configure && \ 
  make && \ 
  make install && \
  cd /tmp && \
  wget https://pecl.php.net/get/memcached-3.0.4.tgz && \ 
  tar -zxvf memcached-3.0.4.tgz && \ 
  cd memcached-3.0.4 && \ 
  /usr/local/php-7.2.10/bin/phpize && \ 
  ./configure --with-php-config=/usr/local/php-7.2.10/bin/php-config --disable-memcached-sasl && \ 
  make && \ 
  make install

# APCu extension
RUN \
  cd /tmp && \
  wget https://pecl.php.net/get/apcu-5.1.12.tgz && \
  tar -zxvf apcu-5.1.12.tgz && \ 
  cd apcu-5.1.12 && \ 
  /usr/local/php-7.2.10/bin/phpize && \ 
  ./configure --with-php-config=/usr/local/php-7.2.10/bin/php-config && \ 
  make && \ 
  make install

# Clean tmp folder & Create required folder
RUN \
  rm -rf /tmp/* /var/tmp/* && \
  mkdir -p /data && \
  mkdir -p /data/www && \
  mkdir -p /data/log && \
  mkdir -p /data/log/nginx && \
  mkdir -p /data/log/php && \
  mkdir -p /data/log/supervisor && \
  mkdir -p /data/src 

# Apply Configuration 
COPY scripts/* /data/www/
ADD config/nginx.conf /etc/nginx/nginx.conf
ADD config/php-fpm.conf /usr/local/php-7.2.10/etc/php-fpm.conf
ADD config/www.conf /usr/local/php-7.2.10/etc/php-fpm.d/www.conf
ADD config/supervisord.conf /etc/supervisord.conf

# Data Volumes
VOLUME ["/data"]

# Ports
EXPOSE 80 8008 9001

# Start the supervisord and it will start PHP-FPM and Nginx
ENTRYPOINT ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]

# FROM — Specify which image to use for the container.
# RUN — Run a command on the container. Used for things like installing packages, etc.
# ADD - Copies new files, directories or remote file URLs from <src> and adds them to the filesystem of the container at the path <dest>
# EXPOSE — Open ports from the Docker container to the host.
# CMD — The default command to run when the container is started. Can be overridden from the command line at runtime.
# ENTRYPOINT — Similar to the CMD option in that it will be the default command that is run but this one cannot be overridden from the command line.
# VOLUME instruction makes the directory available as a volume that other containers can mount by using the --volumes-from
# COPY
# ENV
# LABEL
# STOPSIGNAL
# USER
