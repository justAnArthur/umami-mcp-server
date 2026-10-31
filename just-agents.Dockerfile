FROM docker.io/golang:1.22-alpine AS build
WORKDIR /src
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 go build -trimpath -ldflags="-s -w" -o /umami-mcp .

FROM docker.io/supercorp/supergateway:4.2.0
COPY --from=build /umami-mcp /usr/local/bin/umami-mcp
USER 65534:65534
EXPOSE 8000
CMD ["--stdio", "umami-mcp", "--outputTransport", "streamableHttp", "--port", "8000", "--healthEndpoint", "/healthz"]
