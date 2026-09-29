# Собираем проект
FROM python:3.12-alpine AS builder

WORKDIR /build

RUN apk add --no-cache --virtual .build-deps \
        gcc \
        musl-dev \
        libffi-dev \
        postgresql-dev

COPY app/requirements.txt .

RUN pip install --no-cache-dir --prefix=/install -r requirements.txt

# Оставляем самое необходимое
FROM python:3.12-alpine

RUN apk add --no-cache libpq tzdata \
    && addgroup -S app \
    && adduser  -S app -G app -h /home/app

COPY --from=builder /install /usr/local

WORKDIR /app

COPY --chown=app:app app/app.py .

USER app

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PORT=5000

EXPOSE 5000

HEALTHCHECK --interval=30s --timeout=5s --start-period=15s --retries=3 \
    CMD wget -q -O- http://127.0.0.1:5000/ >/dev/null 2>&1 || exit 1

CMD ["python", "app.py"]
