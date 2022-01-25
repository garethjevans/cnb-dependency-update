FROM golang:1.17.5 as builder
RUN GO111MODULE=on go get -u -ldflags="-s -w" github.com/paketo-buildpacks/libpak/cmd/update-buildpack-dependency

FROM alpine:3.11.3
COPY --from=builder /build/golang-memtest . 

FROM ubuntu:20.04
RUN apt-get update && apt-get install curl git -y && apt-get clean

COPY --from=builder /go/bin/update-buildpack-dependency /usr/local/bin

ENV YJ_VERSION 5.0.0
RUN curl \
      --location \
      --show-error \
      --silent \
      --output /usr/local/bin/yj \
      "https://github.com/sclevine/yj/releases/download/v${YJ_VERSION}/yj-linux"

ENV JQ_VERSION 1.6
RUN wget -q https://github.com/stedolan/jq/releases/download/jq-${JQ_VERSION}/jq-linux64 && \
  mv jq-linux64 /usr/local/bin/jq && \
  chmod +x /usr/local/bin/jq

# GH?
