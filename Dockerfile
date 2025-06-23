# Dockerfile
FROM xliudg/code_editor_bench:latest

# We need to override /etc/mysql/mysql.conf.d/mysqld.cnf to let us connect to
# MySQL from outside the container.
COPY mysqld.cnf /etc/mysql/conf.d/
COPY mysqld.cnf /etc/mysql/mysql.conf.d/
