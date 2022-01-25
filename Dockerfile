FROM golang:1.17.5 as builder
RUN GO111MODULE=on go get -u -ldflags="-s -w" github.com/paketo-buildpacks/libpak/cmd/update-buildpack-dependency

FROM ubuntu:20.04
RUN apt-get update && apt-get install curl git -y && apt-get clean

COPY --from=builder /go/bin/update-buildpack-dependency /usr/local/bin

ENV YJ_VERSION 5.0.0
RUN curl \
      --location \
      --show-error \
      --silent \
      --output /usr/local/bin/yj \
      https://github.com/sclevine/yj/releases/download/v${YJ_VERSION}/yj-linux && \
      chmod +x /usr/local/bin/yj

ENV JQ_VERSION 1.6
RUN curl \
      --location \
      --show-error \
      --silent \
      --output /usr/local/bin/jq \
      https://github.com/stedolan/jq/releases/download/jq-${JQ_VERSION}/jq-linux64 && \
      chmod +x /usr/local/bin/jq

ENV GH_VERSION 2.4.0
RUN curl \
      --location \
      --show-error \
      --silent \
      --output gh.tar.gz \
      https://github.com/cli/cli/releases/download/v${GH_VERSION}/gh_${GH_VERSION}_linux_amd64.tar.gz && \
      tar xfz gh.tar.gz && mv gh_${GH_VERSION}_linux_amd64/bin/gh /usr/local/bin/gh && \
      rm -fr gh_${GH_VERSION}_linux_amd64
