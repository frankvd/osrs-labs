FROM crystallang/crystal:1.0.0-alpine

ADD . /
WORKDIR /
RUN apk update
RUN apk add sqlite-static sqlite-dev
RUN shards build --release --static

FROM scratch
COPY --from=0 /assets /assets
COPY --from=0 /bin /
COPY --from=0 /etc/ssl /etc/ssl
ADD ./app.json /app/

CMD ["/web", "-a", "/assets", "-d", "/var/data/osrs.db", "-p", "5000"]