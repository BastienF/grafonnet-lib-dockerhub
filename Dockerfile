# Install required libraries
FROM golang:1.15-alpine3.12 AS builder

RUN apk add --no-cache curl git=2.26.2-r0 && \
    rm -rf /var/lib/apt/lists/*

RUN go get github.com/google/go-jsonnet/cmd/jsonnet

RUN curl -L https://github.com/grafana/grafonnet-lib/archive/v0.1.0.tar.gz | tar -xz && \
    mkdir /go/vendor && \
    mv grafonnet-lib-0.1.0/grafonnet /go/vendor/grafonnet

# Create image for dashboard generation
FROM alpine:3.12

WORKDIR /dashboards

COPY --from=builder /go/vendor vendor
COPY --from=builder /go/bin/jsonnet /usr/local/bin/

ENV JSONNET_PATH=/dashboards/vendor
ENV GRAFONNET_LIB_PATH=/dashboards/vendor/grafonnet/

CMD [ "jsonnet", "-" ]
