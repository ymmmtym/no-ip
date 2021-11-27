FROM alpine:3.15.0 AS builder
LABEL maintainer="yumenomatayume"

RUN apk add make=4.3-r0 \
            gcc=10.3.1_git20211027-r0 \
            g++=10.3.1_git20211027-r0 \
            --no-cache
ADD https://www.noip.com/client/linux/noip-duc-linux.tar.gz /
RUN tar xzf noip-duc-linux.tar.gz

WORKDIR /noip-2.1.9-1

RUN make


FROM alpine:3.15.0

WORKDIR /opt/noip
RUN adduser -D noip && chown -R noip:noip /opt/noip

COPY --from=builder /noip-2.1.9-1/noip2 /usr/local/bin/noip2
COPY --chown=noip:noip entrypoint.sh /usr/local/bin/entrypoint.sh

USER noip

ENTRYPOINT ["entrypoint.sh"]
