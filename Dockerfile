FROM diaoulael/subliminal

RUN apt-get update && apt-get install -y inotify-tools

RUN mkdir /.cache
RUN chmod a+rwx /.cache

RUN mkdir -p /media
ENV SUBS_WATCHDIR /media

RUN mkdir -p /opt/autosubs
WORKDIR /opt/autosubs

COPY entrypoint.sh /opt/autosubs
RUN chmod +x /opt/autosubs/entrypoint.sh

ENTRYPOINT ["/opt/autosubs/entrypoint.sh", "--verbose"]
CMD []
