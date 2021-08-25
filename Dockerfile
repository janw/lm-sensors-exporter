FROM golang:1.16-buster as build

RUN set -e; \
    apt update; \
    apt install -y libsensors4-dev; \
    apt clean

WORKDIR /src
COPY go.* .
COPY vendor ./vendor
COPY sensor-exporter .

RUN GO111MODULE=on go build \
    -v \
    -mod=vendor \
    -o /sensor-exporter


FROM debian:buster

RUN set -e; \
    apt update; \
    apt install -y libsensors4-dev; \
    apt clean

COPY --from=build /sensor-exporter /

EXPOSE 9255

ENTRYPOINT /sensor-exporter
