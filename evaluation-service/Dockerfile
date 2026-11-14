# ---------- Build stage ----------
FROM golang:1.26-alpine AS builder

WORKDIR /app

# Install git (required for some Go modules)
RUN apk add --no-cache git

# Cache dependencies
COPY go.mod go.sum ./
RUN go mod download

# Copy source
COPY . .

# Build static binary
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 \
    go build -ldflags="-s -w" -o evaluation-service .

# ---------- Runtime stage ----------
FROM alpine:3.22

WORKDIR /app

# Patches de seguranca + certificados SSL
RUN apk --no-cache upgrade && apk add --no-cache ca-certificates

COPY --from=builder /app/evaluation-service .

EXPOSE 8004

ENV PORT=8004

CMD ["./evaluation-service"]