FROM xliudg/code_editor_bench:latest


COPY start.sh /start.sh

ENTRYPOINT ["/start.sh"]
