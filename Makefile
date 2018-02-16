.PHONY: all build clean push certificates
NAME = rvben/rpi-registry
VERSION = 0.1

build:
	docker run --rm -v $PWD:/go/bin/linux_arm -e CGO_ENABLED=0 -e GOOS=linux -e GOARCH=arm -e GOARM=5 golang:1.8 go get -a -ldflags '-s' github.com/docker/distribution/cmd/registry
	docker build --no-cache=true -t $(NAME) .
	docker tag "$$(docker images -qa $(NAME):latest)" $(NAME):$(VERSION)

clean:
	rm -rf registry

certificates:
	openssl req -x509 -sha256 -nodes -days 36500 -newkey rsa:2048 -keyout ./domain.key -out ./domain.crt -subj "/C=NL/ST=Amsterdam/L=./O=./OU=./CN=."

push:
	docker push $(NAME)
