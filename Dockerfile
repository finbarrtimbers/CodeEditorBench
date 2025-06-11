FROM ubuntu:20.04
ENV DEBIAN_FRONTEND=noninteractive \
    LANG=zh_CN.UTF-8 \
    LANGUAGE=zh_CN:zh \
    LC_ALL=zh_CN.UTF-8
RUN sed -i 's/archive\.ubuntu/mirrors.aliyun/g' /etc/apt/sources.list && \
    apt-get update && \
    apt-get -y upgrade && \
    apt-get install -y --no-install-recommends \
        wget \
        w3m  \
        locales \
        locales-all && \
    locale-gen zh_CN.UTF-8 && \
    /usr/sbin/update-locale LANG=zh_CN.UTF-8
RUN wget dl.hustoj.com/install-ubuntu20.04.sh && \
    bash install-ubuntu20.04.sh
RUN sed -i 's|DB_HOST="localhost"|DB_HOST="127.0.0.1"|g' \
        /home/judge/src/web/include/db_info.inc.php && \
    echo 'std::ostream& endl(std::ostream& s){s<<"\n";return s;}' >> \
        "$(find /usr/include/c++/ -name iostream)" && \
    usermod -d /var/lib/mysql mysql && \
    chown -R mysql:mysql /var/lib/mysql
RUN printf '%s\n' \
    '#!/bin/bash' \
    'service mysql start' \
    'service php8.1-fpm start' \
    'judged' \
    'nginx -g "daemon off;"' > /start.sh && \
    chmod +x /start.sh
ENTRYPOINT ["/start.sh"]
