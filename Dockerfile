FROM alpine:latest

# Устанавливаем нужные пакеты
RUN apk add --no-cache ca-certificates unzip

# Скачиваем актуальную версию для Render (amd64)
ARG PB_VERSION=0.39.4
ADD https://github.com/pocketbase/pocketbase/releases/download/v\( {PB_VERSION}/pocketbase_ \){PB_VERSION}_linux_amd64.zip /tmp/pb.zip

RUN unzip /tmp/pb.zip -d /pb/ && \
    chmod +x /pb/pocketbase && \
    rm /tmp/pb.zip

WORKDIR /pb
EXPOSE 8080

CMD ["./pocketbase", "serve", "--http=0.0.0.0:8080"]
