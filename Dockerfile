FROM alpine:latest

RUN apk add --no-cache ca-certificates

COPY pocketbase /pb/pocketbase
RUN chmod +x /pb/pocketbase

WORKDIR /pb
EXPOSE 8080

CMD ["./pocketbase", "serve", "--http=0.0.0.0:8080"]
