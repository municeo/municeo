# syntax=docker/dockerfile:1

# ─── base stage: shared PHP + extensions ─────────────────────────────────────
FROM dunglas/frankenphp:1-php8.5 AS base

WORKDIR /app

# Install system libraries required by PHP extensions
RUN apt-get update && apt-get install -y --no-install-recommends \
    libpq-dev \
    libgd-dev \
    libicu-dev \
    libzip-dev \
    && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN install-php-extensions \
    pdo_pgsql \
    pgsql \
    gd \
    intl \
    zip \
    apcu \
    opcache

# Install Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Worker mode: keep the PHP process alive between requests
ENV FRANKENPHP_CONFIG="worker ./public/index.php"
ENV APP_RUNTIME="Runtime\\FrankenPhpRuntime\\Runtime"

# ─── dev stage: adds Xdebug, skips opcache preload ───────────────────────────
FROM base AS dev

ENV APP_ENV=dev
ENV FRANKENPHP_CONFIG=""
ENV XDEBUG_MODE=off

RUN install-php-extensions xdebug

# Allow the app directory to be bind-mounted
VOLUME /app

# ─── prod stage: installs dependencies and optimises ─────────────────────────
FROM base AS prod

ENV APP_ENV=prod

# Copy composer files first to leverage layer cache
COPY composer.json composer.lock symfony.lock ./

RUN composer install \
    --no-dev \
    --no-scripts \
    --no-plugins \
    --prefer-dist \
    --optimize-autoloader

# Copy application source
COPY . .

# Dump optimised autoloader and warm up cache
RUN composer dump-autoload --optimize --no-dev \
    && php bin/console cache:warmup

HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
    CMD curl -f http://localhost/up || exit 1
