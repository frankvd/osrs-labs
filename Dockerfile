FROM crystallang/crystal:0.32.1

ADD . /
WORKDIR /
RUN apt-get update
RUN apt-get install -y libsqlite3-dev
RUN shards build --release

RUN ldd ./bin/web | tr -s '[:blank:]' '\n' | grep '^/' | \
   xargs -I % sh -c 'mkdir -p $(dirname deps%); cp % deps%;'

FROM busybox
COPY --from=0 /assets /assets
COPY --from=0 /deps /
COPY --from=0 /bin /

ENTRYPOINT ["/web", "-a", "/assets", "-d", "/var/data/osrs.db", "-p", "5000"]