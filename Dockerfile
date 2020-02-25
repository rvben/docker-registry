FROM golang:1.12 as builder
ENV CGO_ENABLED=0
ENV GOPATH=/golang
RUN mkdir /golang && \
    go get -a -ldflags '-s' github.com/docker/distribution/cmd/registry


FROM scratch
COPY --from=builder /golang/bin/registry /registry
COPY ./config.yml /config.yml

VOLUME ["/data"]
EXPOSE 5000

ENTRYPOINT ["/registry"]
CMD ["serve", "/config.yml"]
