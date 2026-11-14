# ---------- Build stage ----------
FROM golang:1.24 AS builder

WORKDIR /app

# Cache dependencies
COPY go.mod go.sum ./
RUN go mod download

# Copy source
COPY . .

# Build a static binary
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 \
    go build -o auth-service .

# ---------- Runtime stage ----------
FROM alpine:3.22

# Aplica patches de seguranca da imagem-base (corrige CVEs CRITICAS)
RUN apk --no-cache upgrade && apk --no-cache add ca-certificates

WORKDIR /app

COPY --from=builder /app/auth-service .

EXPOSE 8001

CMD ["./auth-service"]