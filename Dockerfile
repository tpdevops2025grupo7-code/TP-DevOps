FROM python:3.13-alpine AS builder

RUN apk add --no-cache build-base

WORKDIR /app

COPY requirements.txt .

RUN --mount=type=cache,target=/root/.cache/pip \
    pip install --prefix=/install --no-cache-dir -r requirements.txt

FROM python:3.13-alpine AS deploy

WORKDIR /app

COPY --from=builder /install /usr/local

COPY app/ .
COPY newrelic.ini .

ENV NEW_RELIC_CONFIG_FILE=/app/newrelic.ini

RUN adduser -D user
USER user

CMD ["sh", "-c", "uvicorn main:app --host 0.0.0.0 --port ${PORT:-8000}"]
