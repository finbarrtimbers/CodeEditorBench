#!/usr/bin/env bash
set -euo pipefail

###############################################################################
# start.sh — container entrypoint
###############################################################################

dump_tree() {
  echo "===== DEBUG: /home ====="
  ls -al /home || true
  echo "===== DEBUG: /home/judge ====="
  ls -al /home/judge || true
  echo "===== DEBUG: /home/judge/scripts ====="
  ls -al /home/judge/scripts || true
}

echo "🔧  Starting MySQL …"
service mysql start

echo "🔧  Starting PHP-FPM (if present) …"
if command -v php-fpm8.1 >/dev/null 2>&1; then
  php-fpm8.1 -D
elif command -v php-fpm >/dev/null 2>&1; then
  php-fpm -D
else
  echo "⚠️  ️php-fpm not installed; skipping"
fi

echo "🔧  Starting judged …"
judged

echo "🔎  Verifying /home/judge/scripts/run_judge.sh …"
if [[ ! -x /home/judge/scripts/run_judge.sh ]]; then
  echo "❌  run_judge.sh missing or not executable"
  dump_tree
  exit 1
fi

echo "▶️   Launching run_judge.sh in the background …"
nohup /home/judge/scripts/run_judge.sh \
      > /home/judge/scripts/runlog.out 2>&1 &

echo "🚀  Handing off to nginx (PID 1) …"
exec nginx -g "daemon off;"
