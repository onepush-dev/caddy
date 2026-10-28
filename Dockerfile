# Caddy 2.11.7 (Alpine) — official image, pinned by multi-arch index digest.
# Same digest as caddy:2-alpine / caddy:alpine as of 2026-10-22.
ARG CADDY_IMAGE=caddy:2.11.7-alpine@sha256:eb4d35b7452d1ab6171fbdbe8d9275b2301dad6dad92115d91e19fb9b24d510f
FROM ${CADDY_IMAGE}

# Railway terminates TLS at the edge; we speak plain HTTP on $PORT.
COPY Caddyfile /etc/caddy/Caddyfile
COPY railway/Caddyfile.reverse-proxy /etc/caddy/Caddyfile.reverse-proxy
COPY www /srv
COPY --chmod=755 railway/entrypoint.sh /entrypoint.sh

# Official image already EXPOSEs 80/443/2019; Railway routes via $PORT.
EXPOSE 8080

ENTRYPOINT ["/entrypoint.sh"]
CMD ["caddy", "run", "--config", "/etc/caddy/Caddyfile", "--adapter", "caddyfile"]
