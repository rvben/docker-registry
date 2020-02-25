.PHONY: build login push certificates
DOCKER_USER = rvben
VERSION = 0.2
GO_VER = 1.12
             
IMAGE_NAME:=${DOCKER_USER}/registry

certificates:
	openssl req -x509 -sha256 -nodes -days 36500 -newkey rsa:2048 -keyout ./domain.key -out ./domain.crt -subj "/C=NL/ST=Amsterdam/L=./O=./OU=./CN=."

build_all:
	docker buildx build --platform linux/amd64,linux/arm64,linux/arm/v7 -t ${IMAGE_NAME}:${VERSION} --push .
	docker buildx build --platform linux/amd64,linux/arm64,linux/arm/v7 -t ${IMAGE_NAME}:latest --push .
	docker buildx build --platform linux/arm64,linux/arm/v7 -t rvben/rpi-registry:${VERSION} --push .
	docker buildx build --platform linux/arm64,linux/arm/v7 -t rvben/rpi-registry:latest --push .