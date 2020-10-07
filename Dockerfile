FROM golang:1.15.2 AS build
WORKDIR /src
COPY myapp.go .
RUN go get -d -v github.com/lib/pq gopkg.in/yaml.v2 && \
    CGO_ENABLED=0 GOOS=linux go build -o myapp .

FROM alpine:latest
WORKDIR /src
COPY --from=build /src/myapp .
RUN mkdir /lib64 && ln -s /lib/libc.musl-x86_64.so.1 /lib64/ld-linux-x86-64.so.2
CMD ["./myapp"]
EXPOSE 8090
