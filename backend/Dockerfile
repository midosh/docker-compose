#
## build stage
#
FROM  golang:1.13 AS build
WORKDIR  /app
COPY main.go  main.go
RUN  CGO_ENABLED=0 go build -o backend main.go
#
## run stage
#
FROM  golang:stretch
COPY --from=build  /app/backend  /usr/local/bin/backend
CMD ["/usr/local/bin/backend"]