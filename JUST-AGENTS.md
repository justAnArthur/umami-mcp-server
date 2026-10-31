# The just-agents image

The `just-agents` branch of this fork builds the image [just-agents](https://github.com/justAnArthur/just-agents)
runs: read-only Umami analytics (websites, stats, pageviews, events, sessions), every tool annotated `readOnlyHint`. It is this server over stdio, wrapped in
[supergateway](https://github.com/supercorp-ai/supergateway) as streamable HTTP.

- Port `8000`, MCP at `/mcp`, health at `/healthz`.
- `SUPERGATEWAY_API_KEY` is required; callers send it as `Authorization: Bearer <key>`, and a call without it gets 401.
- Runs as `65534:65534` and works on a read-only root with a tmpfs on `/tmp`.
- Env: `UMAMI_URL`, and `UMAMI_API_KEY` (Umami Cloud) or `UMAMI_USERNAME` and `UMAMI_PASSWORD` (self-hosted); `UMAMI_TEAM_ID` optional. Use a view-only user.

```sh
docker build -f just-agents.Dockerfile -t mcp .
docker run --read-only --tmpfs /tmp -p 8000:8000 -e SUPERGATEWAY_API_KEY=… <env above> mcp
```

A compose builds it straight from git:

```yaml
services:
  mcp:
    build:
      context: https://github.com/justAnArthur/umami-mcp-server.git#just-agents
      dockerfile: just-agents.Dockerfile
```
