FROM xliudg/code_editor_bench:latest

# (We keep every original command, but also launch the script).
RUN printf '%s\n' \
    '#!/bin/bash' \
    'set -e' \
    '' \
    '# --- Original startup sequence ---' \
    'service mysql start' \
    'service php8.1-fpm start' \
    'judged' \
    '' \
    '# --- Your addition ---' \
    'nohup bash /home/judge/scripts/run_judge.sh \\' \
    '      > /home/judge/scripts/runlog.out 2>&1 &' \
    '' \
    '# --- Keep container in foreground ---' \
    'nginx -g "daemon off;"' \
  > /start.sh && chmod +x /start.sh

ENTRYPOINT ["/start.sh"]
