#!/usr/bin/env bash
# One-time, on the server, as root. Splits /etc/caddy/Caddyfile into one file per site, adds
# labs.evil-teacher.ru and the placeholder on the bare domain, and creates the `deploy` user that
# CI rsyncs the labs site with. Safe to run again.
#
# From the labs repository root, with the key made for CI:
#   ssh-keygen -t ed25519 -N '' -C labs-deploy -f ~/.ssh/labs_deploy
#   scp -r deploy/server ~/.ssh/labs_deploy.pub root@81.200.144.62:/tmp/
#   ssh root@81.200.144.62 'bash /tmp/server/setup.sh /tmp/labs_deploy.pub'
set -euo pipefail

HERE="$(cd "$(dirname "$0")" && pwd)"
PUBKEY="${1:?usage: setup.sh <deploy-key.pub>}"
FLY_HOST="fly.evil-teacher.ru"

if [ "$(id -u)" -ne 0 ]; then
	echo "run this as root" >&2
	exit 1
fi
if ! grep -qE '^ssh-(ed25519|rsa) ' "$PUBKEY"; then
	echo "$PUBKEY does not look like an ssh public key" >&2
	exit 1
fi

echo "==> rsync (CI deploys with it; rrsync pins the deploy key to /srv/labs)"
command -v rsync >/dev/null || { apt-get update -qq && apt-get install -y -qq rsync; }
RRSYNC="$(command -v rrsync || true)"
if [ -z "$RRSYNC" ]; then
	echo "rrsync not found — it ships with rsync >= 3.2.4" >&2
	exit 1
fi

echo "==> user deploy"
id deploy >/dev/null 2>&1 || useradd --create-home --shell /bin/bash deploy
install -d -m 700 -o deploy -g deploy /home/deploy/.ssh
# the key can run rsync into /srv/labs and nothing else: no shell, no forwarding, no other path
printf 'command="%s /srv/labs",restrict %s\n' "$RRSYNC" "$(head -1 "$PUBKEY")" \
	> /home/deploy/.ssh/authorized_keys
chown deploy:deploy /home/deploy/.ssh/authorized_keys
chmod 600 /home/deploy/.ssh/authorized_keys

echo "==> web roots"
# the site is public anyway, so plain world-readable files: no group juggling between deploy and caddy
install -d -m 755 -o deploy -g deploy /srv/labs
install -d -m 755 /srv/root
install -m 644 "$HERE/root/index.html" /srv/root/index.html

echo "==> caddy config"
BACKUP="/etc/caddy.bak-$(date +%Y%m%d-%H%M%S)"
cp -a /etc/caddy "$BACKUP"
restore() {
	echo "restoring $BACKUP" >&2
	rm -rf /etc/caddy && cp -a "$BACKUP" /etc/caddy
}

install -d -m 755 /etc/caddy/sites
if ! grep -q '^import /etc/caddy/sites/' /etc/caddy/Caddyfile; then
	# The live config is anti_fly's single catch-all block. It becomes that site's own file,
	# answering only to its hostname now that the catch-all belongs to the placeholder.
	if ! grep -q '^:80 {' /etc/caddy/Caddyfile; then
		echo "expected anti_fly's ':80 {' block in /etc/caddy/Caddyfile, found something else:" >&2
		grep -nE '^[^#[:space:]].*\{' /etc/caddy/Caddyfile >&2 || true
		echo "nothing changed" >&2
		exit 1
	fi
	sed "s|^:80 {|http://$FLY_HOST {|" /etc/caddy/Caddyfile > /etc/caddy/sites/anti-fly.caddy
fi
install -m 644 "$HERE/Caddyfile" /etc/caddy/Caddyfile
install -m 644 "$HERE/sites/labs.caddy" "$HERE/sites/root.caddy" /etc/caddy/sites/

if ! caddy validate --config /etc/caddy/Caddyfile --adapter caddyfile >/dev/null 2>&1; then
	caddy validate --config /etc/caddy/Caddyfile --adapter caddyfile || true
	restore
	exit 1
fi
systemctl reload caddy

echo "==> smoke test, straight to the origin"
sleep 1
for host in "$FLY_HOST" evil-teacher.ru www.evil-teacher.ru labs.evil-teacher.ru; do
	printf '    %-24s %s\n' "$host" \
		"$(curl -s -o /dev/null -w '%{http_code}' -H "Host: $host" http://127.0.0.1/)"
done
echo "    (labs answers 404 until the first CI deploy fills /srv/labs)"

echo
echo "backup of the old config: $BACKUP"
echo "host key, compare with deploy/known_hosts in the repo:"
ssh-keygen -lf /etc/ssh/ssh_host_ed25519_key.pub
