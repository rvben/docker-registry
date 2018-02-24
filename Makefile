.PHONY: build login push certificates
DOCKER_USER = rvben
DOCKER_NAME = $DOCKER_USER/rpi-registry
VERSION = 0.1

build:
	docker run --rm -v $PWD:/go/bin/linux_arm -e CGO_ENABLED=0 -e GOOS=linux -e GOARCH=arm -e GOARM=5 golang:1.8 go get -a -ldflags '-s' github.com/docker/distribution/cmd/registry
	docker build --no-cache=true -t $(DOCKER_NAME) .
	docker tag "$$(docker images -qa $(NAME):latest)" $(DOCKER_NAME):$(VERSION)

login:
	docker login -u="$DOCKER_USER" -p="$DOCKER_PASS"

push:
	docker push $(DOCKER_NAME)

certificates:
	openssl req -x509 -sha256 -nodes -days 36500 -newkey rsa:2048 -keyout ./domain.key -out ./domain.crt -subj "/C=NL/ST=Amsterdam/L=./O=./OU=./CN=."
