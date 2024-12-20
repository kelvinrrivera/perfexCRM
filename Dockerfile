FROM php:8.1-fpm # Reemplaza con tu imagen base si es diferente

# Instalación de dependencias generales
RUN apt-get update && apt-get install -y \
    git \
    zip \
    unzip \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    libzip-dev \
    default-mysql-client

# Instala dependencias necesarias para la extensión IMAP
RUN apt-get update && apt-get install -y \
    libkrb5-dev \
    libc-client-dev \
    libssl-dev

# Instala extensiones de PHP
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd zip
RUN docker-php-ext-configure imap --with-kerberos --with-imap-ssl && \
    docker-php-ext-install imap

# Instala Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Establece el directorio de trabajo
WORKDIR /var/www/html

# Copia los archivos de la aplicación
COPY . .

# Instala las dependencias de composer
RUN composer install --no-scripts --no-interaction --no-autoloader

# Genera el autoloader
RUN composer dump-autoload --optimize

# Configura el usuario
RUN chown -R www-data:www-data /var/www/html

# Exponiendo el puerto 9000
EXPOSE 9000

CMD ["php-fpm"]
