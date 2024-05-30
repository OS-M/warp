FROM golang:1.21

ADD go.mod /go/src/github.com/minio/warp/go.mod
ADD go.sum /go/src/github.com/minio/warp/go.sum
WORKDIR /go/src/github.com/minio/warp/
# Get dependencies - will also be cached if we won't change mod/sum
RUN go mod download

ADD . /go/src/github.com/minio/warp/
WORKDIR /go/src/github.com/minio/warp/

ENV CGO_ENABLED=0

RUN go build -ldflags '-w -s' -a -o warp .

FROM alpine
MAINTAINER MinIO Development "dev@min.io"
EXPOSE 7761

ADD nebius/ca/*.crt /nebius/ca/
RUN mkdir -p /usr/local/share/ca-certificates/ && \
    cp /nebius/ca/*.crt /usr/local/share/ca-certificates/ && \
    cat /nebius/ca/*.crt >> /etc/ssl/certs/ca-certificates.crt
COPY --from=0 /go/src/github.com/minio/warp/warp /warp

ENTRYPOINT ["/warp"]
