FROM xliudg/code_editor_bench:latest

# PHP-FPM 8.1 lives in Jammy/Debian Bookworm’s default repos
RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      php8.1-fpm \
 && rm -rf /var/lib/apt/lists/*

COPY start.sh /start.sh

ENTRYPOINT ["/start.sh"]
