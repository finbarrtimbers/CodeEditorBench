FROM xliudg/code_editor_bench:latest
COPY mysqld.cnf /etc/mysql/conf.d/
COPY mysqld.cnf /etc/mysql/mysql.conf.d/

COPY start.sh /start.sh

ENTRYPOINT ["/start.sh"]
