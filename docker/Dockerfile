FROM php:8.2-cli-alpine AS base

# Install system dependencies
RUN apk add --no-cache \
    git \
    curl \
    libpng-dev \
    libxml2-dev \
    zip \
    unzip \
    postgresql-dev \
    $PHPIZE_DEPS

# Install PHP extensions
RUN docker-php-ext-install pdo pdo_mysql pdo_pgsql mbstring exif pcntl bcmath gd xml

# Install OpenSwoole
RUN pecl install openswoole && docker-php-ext-enable openswoole

# Install Redis extension
RUN pecl install redis && docker-php-ext-enable redis

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /var/www

# Development stage
FROM base AS development

# Install development tools
RUN pecl install xdebug && docker-php-ext-enable xdebug

# Copy application
COPY . .

# Install dependencies
RUN composer install --no-scripts --no-autoloader

EXPOSE 9501

CMD ["php", "bin/swoole-server", "start"]

# Production stage
FROM base AS production

# Copy application
COPY . .

# Install production dependencies
RUN composer install --no-dev --optimize-autoloader

EXPOSE 9501

CMD ["php", "bin/swoole-server", "start"]
