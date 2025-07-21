#!/bin/bash

# original behaviour
service mysql start
service php8.1-fpm start
judged

# your addition
nohup bash /home/judge/scripts/run_judge.sh > /home/judge/scripts/runlog.out 2>&1 &

# final command to keep the container alive
nginx -g "daemon off;"
