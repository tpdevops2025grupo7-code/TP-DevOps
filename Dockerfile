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

RUN adduser -D user
USER user

EXPOSE 8000
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]