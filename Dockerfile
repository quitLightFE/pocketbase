FROM alpine:latest

RUN apk add --no-cache ca-certificates unzip wget

ARG PB_VERSION=0.39.4

RUN wget -O /tmp/pb.zip \
    https://github.com/pocketbase/pocketbase/releases/download/v${PB_VERSION}/pocketbase_${PB_VERSION}_linux_amd64.zip && \
    unzip /tmp/pb.zip -d /pb/ && \
    chmod +x /pb/pocketbase && \
    rm /tmp/pb.zip

WORKDIR /pb

VOLUME /pb/pb_data

EXPOSE 8080

RUN echo '#!/bin/sh' > /pb/start.sh && \
    echo 'if [ -n "$PB_ADMIN_EMAIL" ] && [ -n "$PB_ADMIN_PASSWORD" ]; then' >> /pb/start.sh && \
    echo '  /pb/pocketbase superuser upsert "$PB_ADMIN_EMAIL" "$PB_ADMIN_PASSWORD"' >> /pb/start.sh && \
    echo 'fi' >> /pb/start.sh && \
    echo 'exec /pb/pocketbase serve --http=0.0.0.0:${PORT:-8080}' >> /pb/start.sh && \
    chmod +x /pb/start.sh

ENTRYPOINT ["/pb/start.sh"]
