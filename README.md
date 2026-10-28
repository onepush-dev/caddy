# Caddy — official web server & reverse proxy (2.11.7 Alpine). Deploy on Railway with one click.

[![Deploy on Railway](https://railway.com/button.svg)](https://railway.com/new/template)

[Caddy](https://caddyserver.com/) (Apache-2.0) is a fast, production-ready web server written in Go. This template runs the **official** `caddy:2.11.7-alpine` image (pinned by digest) as a single Railway service. It needs **no deploy-time input**: deploy and you get a welcome page over HTTPS (TLS is terminated by Railway). Point it at your own files under `www/`, or set `UPSTREAM` to reverse-proxy another service on Railway’s private network.

## Why this template
- **Official image, digest-pinned.** Uses [`caddy:2.11.7-alpine`](https://hub.docker.com/_/caddy) at multi-arch index digest `sha256:eb4d35b7452d1ab6171fbdbe8d9275b2301dad6dad92115d91e19fb9b24d510f` (same as `2-alpine` / `alpine` as of 2026-10-22). A redeploy never silently jumps to another Caddy version.
- **Zero deploy-time inputs.** Default mode serves static files from `/srv` (repo `www/`). Open the public URL and you see the welcome page.
- **Optional reverse proxy.** Set `UPSTREAM=host:port` (e.g. `${{App.RAILWAY_PRIVATE_DOMAIN}}:${{App.PORT}}`) to proxy instead of serving files — no Caddyfile edit required.
- **Railway-aware Caddyfile.** Listens on `{$PORT}`, `auto_https off`, `admin off`, `persist_config off`, and trusts Railway’s private proxy ranges so client IPs stay correct.
- **No volume required.** Static assets ship in the image. Add an optional volume at `/srv` only if you want to upload files at runtime without rebuilding.

## Service
| Service | Source | Port | Volume | Notes |
|---|---|---|---|---|
| Caddy | `caddy:2.11.7-alpine@sha256:eb4d35b7452d1ab6171fbdbe8d9275b2301dad6dad92115d91e19fb9b24d510f` | `{$PORT}` (public) | none (optional `/srv`) | Health `/` (timeout 60 s), restart `ALWAYS` |

Platform digests for the same index: **amd64** `sha256:04913b1da43339a40ad1ea87827d70a576ac5aa6cf674c6e24fdca675887533a` · **arm64** `sha256:cc447f149425221422153c6cdf33a123b3f458839679f950298f68a690a54a5b`.

## Variables
Every value is also in `env.example`. There are no secrets.

| Variable | Template value | Notes |
|---|---|---|
| PORT | _(Railway injects)_ | Caddy listens on `:{$PORT}` (defaults to `8080` locally) |
| UPSTREAM | _(empty)_ | Optional. When set (e.g. `my-app.railway.internal:3000`), Caddy reverse-proxies instead of serving `/srv` |

## How to use
1. Click **Deploy on Railway** and wait for the service to turn healthy (a few seconds).
2. Open the public URL — you should see the welcome page.
3. **Static site:** put files in `www/`, commit, and redeploy (or mount a volume at `/srv` and copy files in).
4. **Reverse proxy:** set `UPSTREAM` to another service’s private host and port, e.g. `${{Backend.RAILWAY_PRIVATE_DOMAIN}}:${{Backend.PORT}}`, and redeploy. Upstream services must listen on IPv6/`::` for Railway private networking.

## Notes
- **TLS / HTTPS.** Railway terminates TLS at the edge. This container speaks **plain HTTP** only. Do not enable Caddy `auto_https` or listen on 443 inside the container — ACME challenges and certificate storage will not work behind Railway’s proxy, and enabling them can break routing.
- **Custom domains.** Add them in Railway → Settings → Networking. No Caddyfile change needed; Railway handles certificates.
- **Admin API.** Disabled (`admin off`) — not useful on Railway’s ephemeral filesystem.
- **`/data` volume.** The official image documents `/data` for TLS certs. With `auto_https off` you do not need it. Skip the volume unless you later enable Caddy-managed TLS yourself (not recommended on Railway).
- **Plugins.** This template uses the stock official binary (no `xcaddy` rebuild). For plugins, fork and switch to a builder stage, or use the upstream [caddy-railway](https://github.com/caddyserver/caddy-railway) template which rebuilds from `CADDY_PLUGINS`.
- **Upgrade.** Bump the tag and digest in `Dockerfile` to a newer `caddy:*-alpine` release from [Docker Hub](https://hub.docker.com/_/caddy).
- **Upstream docs:** [Caddyfile](https://caddyserver.com/docs/caddyfile), [Docker image](https://hub.docker.com/_/caddy), [Railway Caddy guide](https://docs.railway.com/guides/caddy).

## License
Caddy is Apache-2.0 licensed by the Caddy authors / Stack Holdings GmbH. This repository only holds Railway configuration and a sample static page.
