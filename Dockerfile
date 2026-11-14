FROM alpine:3.24.4 AS builder
LABEL maintainer="yumenomatayume"

RUN apk add --no-cache \
            make \
            gcc \
            g++ \
            libc-dev
ADD https://www.noip.com/client/linux/noip-duc-linux.tar.gz /
RUN tar xzf noip-duc-linux.tar.gz

WORKDIR /noip-2.1.9-1

RUN make


FROM alpine:3.24.4

WORKDIR /opt/noip
RUN adduser -D noip && chown -R noip:noip /opt/noip

COPY --from=builder /noip-2.1.9-1/noip2 /usr/local/bin/noip2
COPY --chown=noip:noip entrypoint.sh /usr/local/bin/entrypoint.sh

USER noip

ENTRYPOINT ["entrypoint.sh"]
