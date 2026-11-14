# ---------- Build stage ----------
FROM python:3.12-slim AS builder

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /build

COPY requirements.txt .

# Install dependencies into a separate directory
RUN pip install --no-cache-dir \
    --prefix=/install \
    -r requirements.txt

# ---------- Runtime stage ----------
FROM python:3.12-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PORT=8005 \
    OTEL_SERVICE_NAME=analytics-service

WORKDIR /app

# Aplica patches de seguranca da imagem-base (corrige CVEs CRITICAS do SO)
RUN apt-get update && apt-get upgrade -y && rm -rf /var/lib/apt/lists/*

# Copy installed Python packages
COPY --from=builder /install /usr/local

# Copy application
COPY . .

EXPOSE 8005

CMD ["opentelemetry-instrument", "gunicorn", "--workers", "1", "--threads", "4", "--bind", "0.0.0.0:8005", "app:app"]