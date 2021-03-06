FROM golang:1.10-alpine as builder

WORKDIR /go/src/github.com/google/mtail
RUN set -x \
    && apk add --update --no-cache --virtual build-dependencies git make \
    && git clone https://github.com/google/mtail /go/src/github.com/google/mtail \
    && make install_deps \
    && CGO_ENABLED=0 GOOS=linux go build -o /usr/bin/mtail -a -ldflags '-extldflags "-static"'

FROM scratch

COPY --from=builder /usr/bin/mtail /mtail

EXPOSE 3903
ENTRYPOINT ["/mtail", "-logtostderr"]
