FROM --platform=${BUILDPLATFORM} golang:1.15-alpine3.12 AS builder
ARG VERSION
ARG TARGETOS
ARG TARGETARCH
ARG TARGETVARIANT
RUN apk add --no-cache git tzdata ca-certificates
RUN git clone https://github.com/elastic/beats.git && cd beats && git checkout ${VERSION}
RUN cd beats/filebeat && \
    CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} GOARM=${TARGETVARIANT:1} go build .
RUN find beats/filebeat/module \( -name "_meta" -o -name "test" -o -name "fields.go" \) -prune -exec rm -rf {} +

FROM alpine:3.12
RUN apk add --no-cache tzdata ca-certificates
RUN mkdir -p /config/inputs /config/modules /usr/share/filebeat && chown -R nobody:nobody /usr/share/filebeat
COPY entrypoint.sh /entrypoint.sh
RUN chmod 755 /entrypoint.sh
WORKDIR /usr/share/filebeat
COPY --chown=nobody:nobody filebeat.yml .
COPY --chown=nobody:nobody --from=builder /go/beats/filebeat/module ./module
COPY --chown=nobody:nobody --from=builder /go/beats/filebeat/filebeat .
RUN chmod 644 filebeat.yml
USER nobody
ENV PATH=/usr/share/filebeat:$PATH
ENTRYPOINT ["/entrypoint.sh"]
CMD [""]
