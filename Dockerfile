# build
FROM golang:latest AS build-stage

ENV GO111MODULE=on \
    GOPROXY=https://goproxy.cn,direct 

WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY *.go ./
RUN CGO_ENABLED=0 GOOS=linux go build -o /main

# test
FROM build-stage AS run-test-stage
RUN go test -v ./...

# release
FROM alpine:latest AS final

WORKDIR /
COPY --from=build-stage /main /main

EXPOSE 8080
ENTRYPOINT ["/main"]
