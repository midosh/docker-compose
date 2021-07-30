#
## build stage
#
FROM  golang:alpine AS build
WORKDIR  /app
COPY main.go  main.go
RUN  CGO_ENABLED=0 go build -o backend main.go
#
## run stage
#
FROM  golang:alpine
COPY --from=build  /app/backend  /usr/local/bin/backend
CMD ["/usr/local/bin/backend"]