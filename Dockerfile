FROM xliudg/code_editor_bench:latest

COPY run_judge.sh /home/judge/scripts/run_judge.sh
COPY start-wrapper.sh /start.sh   # replaces the original
RUN chmod +x /start.sh /home/judge/scripts/run_judge.sh