FROM alpine:latest

# Устанавливаем необходимые пакеты
RUN apk add --no-cache ca-certificates unzip

# Указываем версию PocketBase по умолчанию
ARG PB_VERSION=0.39.4

# Скачиваем правильную версию и распаковываем
ADD https://github.com{PB_VERSION}/pocketbase_${PB_VERSION}_linux_amd64.zip /tmp/pb.zip
RUN unzip /tmp/pb.zip -d /pb/ && \
    chmod +x /pb/pocketbase && \
    rm /tmp/pb.zip

WORKDIR /pb

# Создаем директорию для постоянных данных (база данных, загрузки)
VOLUME /pb/pb_data

EXPOSE 8080

# --- ИЗМЕНЕНИЯ НАЧИНАЮТСЯ ЗДЕСЬ ---

# Создаем динамический скрипт запуска
RUN echo '#!/bin/sh' > /pb/start.sh && \
    echo 'if [ -n "$PB_ADMIN_EMAIL" ] && [ -n "$PB_ADMIN_PASSWORD" ]; then' >> /pb/start.sh && \
    echo '  /pb/pocketbase superuser upsert "$PB_ADMIN_EMAIL" "$PB_ADMIN_PASSWORD"' >> /pb/start.sh && \
    echo 'fi' >> /pb/start.sh && \
    echo 'exec /pb/pocketbase serve --http "0.0.0.0:${PORT:-8080}"' >> /pb/start.sh && \
    chmod +x /pb/start.sh

# Запускаем созданный скрипт
ENTRYPOINT ["/pb/start.sh"]
