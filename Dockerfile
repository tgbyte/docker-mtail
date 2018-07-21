FROM golang:1.10-alpine as builder

WORKDIR /go/src/github.com/google/mtail
RUN set -x \
    && apk add --update --no-cache --virtual build-dependencies git make \
    && git clone https://github.com/google/mtail /go/src/github.com/google/mtail \
    && make install_deps \
    && go build -o /usr/bin/mtail

FROM scratch

COPY --from=builder /usr/bin/mtail /mtail

ENTRYPOINT ["/mtail"]
