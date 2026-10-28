#!/bin/sh
set -eu

# Railway always injects PORT for public HTTP services; default for local runs.
export PORT="${PORT:-8080}"

CONFIG="/etc/caddy/Caddyfile"
if [ -n "${UPSTREAM:-}" ]; then
	echo "caddy: reverse_proxy mode → ${UPSTREAM} (listen :${PORT})"
	CONFIG="/etc/caddy/Caddyfile.reverse-proxy"
else
	echo "caddy: file_server mode → /srv (listen :${PORT})"
fi

# If the user passed the default CMD, rewrite --config to the chosen file.
if [ "$#" -ge 1 ] && [ "$1" = "caddy" ]; then
	# Rebuild argv so --config points at the active Caddyfile.
	set -- caddy run --config "$CONFIG" --adapter caddyfile
fi

exec "$@"
