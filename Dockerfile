FROM php:8.1-apache

# Instalar las dependencias necesarias
RUN apt-get update && apt-get install -y \
    libzip-dev \
    zip \
    unzip \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libicu-dev \
    zlib1g-dev \
    && docker-php-ext-install -j$(nproc) \
	bcmath \
    mysqli \
    pdo_mysql \
    zip \
    gd \
    intl \
    imap

# Habilitar los módulos necesarios
RUN docker-php-ext-enable mysqli pdo_mysql zip gd intl imap

# Habilitar mod_rewrite
RUN a2enmod rewrite

# Establecer el directorio de trabajo
WORKDIR /var/www/html

# Copiar los archivos de la aplicación
COPY . .

# Configurar permisos de los archivos
RUN chown -R www-data:www-data /var/www/html
RUN chmod 755 /var/www/html/uploads/
RUN chmod 755 /var/www/html/application/config/
RUN chmod 755 /var/www/html/application/config/config.php
RUN chmod 755 /var/www/html/application/config/app-config-sample.php
RUN chmod 755 /var/www/html/temp/

# Exponer el puerto 80
EXPOSE 80

# Comando para ejecutar el servidor apache
CMD ["apache2-foreground"]
