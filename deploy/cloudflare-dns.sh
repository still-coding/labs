#!/usr/bin/env bash
# Point Cloudflare DNS at a finished deploy: the A record for the site, then DNSLink at its CID.
# The A record is NOT proxied: Russian ISPs throttle Cloudflare to the first ~16 KB of a response,
# so visitors go straight to the VPS and Caddy serves HTTPS itself.
#
# Run last — once the files are on the origin and the CID is pinned — so nothing ever points at
# content that is not being served yet.
#
#   CF_API_TOKEN=... ZONE=evil-teacher.ru DOMAIN=labs.evil-teacher.ru \
#   ORIGIN_IP=81.200.144.62 CID=bafy... deploy/cloudflare-dns.sh
#
# The token needs Zone → Zone → Read and Zone → DNS → Edit, limited to this zone.
# Rolling back only the IPFS side is this script with an older CID.
set -euo pipefail
: "${CF_API_TOKEN:?}" "${ZONE:?}" "${DOMAIN:?}" "${ORIGIN_IP:?}" "${CID:?}"
command -v jq >/dev/null || { echo "needs jq" >&2; exit 1; }

API="https://api.cloudflare.com/client/v4"

# curl + check .success; on failure print Cloudflare's own error rather than a bare HTTP code
cf() {
	local method="$1" path="$2" out
	shift 2
	out="$(curl -sS -X "$method" "$API$path" \
		-H "Authorization: Bearer $CF_API_TOKEN" -H "Content-Type: application/json" "$@")"
	if ! jq -e '.success' >/dev/null 2>&1 <<<"$out"; then
		echo "cloudflare: $method $path failed: $(jq -c '.errors' <<<"$out" 2>/dev/null || echo "$out")" >&2
		return 1
	fi
	printf '%s' "$out"
}

# upsert <type> <name> <content> <proxied>
upsert() {
	local type="$1" name="$2" content="$3" proxied="$4" id body
	id="$(cf GET "/zones/$ZONE_ID/dns_records?type=$type&name=$name" | jq -r '.result[0].id // empty')"
	# ttl 1 means "automatic", which proxied records require
	body="$(jq -nc --arg t "$type" --arg n "$name" --arg c "$content" --argjson p "$proxied" \
		'{type: $t, name: $n, content: $c, proxied: $p, ttl: (if $p then 1 else 120 end)}')"
	if [ -n "$id" ]; then
		cf PUT "/zones/$ZONE_ID/dns_records/$id" --data "$body" >/dev/null
	else
		cf POST "/zones/$ZONE_ID/dns_records" --data "$body" >/dev/null
	fi
	echo "$type $name → $content$([ "$proxied" = true ] && echo ' (proxied)')"
}

ZONE_ID="$(cf GET "/zones?name=$ZONE" | jq -r '.result[0].id // empty')"
if [ -z "$ZONE_ID" ]; then
	echo "zone $ZONE is not visible to this token" >&2
	exit 1
fi

upsert A "$DOMAIN" "$ORIGIN_IP" false
upsert TXT "_dnslink.$DOMAIN" "\"dnslink=/ipfs/$CID\"" false
