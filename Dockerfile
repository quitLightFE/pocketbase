FROM alpine:latest

# Устанавливаем необходимые пакеты
RUN apk add --no-cache ca-certificates unzip

# Указываем версию PocketBase по умолчанию
ARG PB_VERSION=0.39.4

# Скачиваем правильную версию и распаковываем
ADD https://github.com/pocketbase/pocketbase/releases/download/v${PB_VERSION}/pocketbase_${PB_VERSION}_linux_amd64.zip /tmp/pb.zip
RUN unzip /tmp/pb.zip -d /pb/ && \
    chmod +x /pb/pocketbase && \
    rm /tmp/pb.zip

WORKDIR /pb

# Создаем директорию для постоянных данных (база данных, загрузки)
VOLUME /pb/pb_data

EXPOSE 8080

# Запуск PocketBase на порту, переданном через переменную среды (по умолчанию 8080)
ENTRYPOINT ["/pb/pocketbase", "serve", "--http=0.0.0.0:8080"]
