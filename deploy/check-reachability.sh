#!/usr/bin/env bash
# Where does the site break without a VPN? Fetches the same files of several sizes three ways:
#   dns     wherever DNS points right now (what visitors get)
#   origin  straight to the VPS over HTTPS, whatever DNS says
#   ipfs    through Filebase's gateway
# A connection that stalls after the first ~16 KB is throttling, not a broken site: Russian ISPs
# do that to Cloudflare, which is why no record is proxied. If a "dns" row stalls while its
# "origin" row is fine, a record has been proxied (orange cloud) again.
#
#   deploy/check-reachability.sh            run it with the VPN OFF, then with it ON to compare
set -uo pipefail
export LC_ALL=C   # curl prints 1.23; a ru_RU printf would want 1,23

ORIGIN_IP="81.200.144.62"
LABS="labs.evil-teacher.ru"
FLY="fly.evil-teacher.ru"
ROOT="evil-teacher.ru"
GATEWAY="https://ipfs.filebase.io/ipns/$LABS"

# path on labs, roughly by size: 6.5 KB, 37 KB, 135 KB, 297 KB, 4.4 MB
LABS_FILES=(
	/
	/assets/css/stylesheet.min.7bebf52ca2da639b2f944628d8fe7921bb771321e93ddb9a344553975d766fd7.css
	/images/surprised.png
	/images/ssw_lab04_qt_linux_installation.png
	/ssw_pm/lab04_gtk.zip
)

# one fetch → "code bytes seconds verdict"
fetch() {
	local out code bytes secs rc err verdict
	out="$(curl -sS -o /dev/null --connect-timeout 10 -m 60 --speed-limit 1 --speed-time 15 \
		-w '%{http_code} %{size_download} %{time_total}' "$@" 2>/tmp/reach.err)"
	rc=$?
	read -r code bytes secs <<<"$out"
	err="$(head -1 /tmp/reach.err | sed 's/^curl: ([0-9]*) //')"
	if [ "$rc" -eq 0 ] && [ "${code:-000}" -lt 400 ]; then
		verdict="ok"
	elif [ "$rc" -eq 28 ] && [ "${bytes:-0}" -gt 0 ]; then
		verdict="STALLED after ${bytes} bytes"
	elif [ "$rc" -ne 0 ]; then
		verdict="FAIL: $err"
	else
		verdict="HTTP $code"
	fi
	printf '%-4s %9s B %6.1fs  %s\n' "${code:-000}" "${bytes:-0}" "${secs:-0}" "$verdict"
}

row() { # row <via> <label> <curl args...>
	local via="$1" label="$2"
	shift 2
	printf '%-7s %-46s ' "$via" "$label"
	fetch "$@"
}

echo "== where this machine is"
curl -s -m 10 https://www.cloudflare.com/cdn-cgi/trace 2>/dev/null | grep -E '^(ip|loc|colo)=' | tr '\n' ' '
echo
curl -s -m 10 https://ipinfo.io/json 2>/dev/null | grep -oE '"(ip|country|org)": *"[^"]*"' | tr '\n' ' '
echo; echo

echo "== DNS"
for h in "$LABS" "$FLY" "$ROOT"; do
	printf '%-24s %s\n' "$h" "$(getent ahostsv4 "$h" | awk '{print $1}' | sort -u | tr '\n' ' ')"
done
echo

echo "== labs: through Cloudflare vs straight to the VPS vs IPFS"
for p in "${LABS_FILES[@]}"; do
	name="${p##*/}"
	name="labs /${name:0:40}"
	row dns "$name" "https://$LABS$p"
	row origin "$name" --resolve "$LABS:443:$ORIGIN_IP" "https://$LABS$p"
	row ipfs "$name" "$GATEWAY$p"
	echo
done

echo "== the neighbours"
row dns "$FLY/" "https://$FLY/"
row dns "$FLY/fly-lab.jpg (170 KB)" "https://$FLY/fly-lab.jpg"
row origin "$FLY/fly-lab.jpg (170 KB)" --resolve "$FLY:443:$ORIGIN_IP" "https://$FLY/fly-lab.jpg"
row dns "$ROOT/" "https://$ROOT/"
row dns "www.$ROOT/ (redirects to $ROOT)" "https://www.$ROOT/"
echo

echo "== controls"
row direct "ya.ru (not Cloudflare)" "https://ya.ru/"
row cf "www.cloudflare.com (Cloudflare itself)" "https://www.cloudflare.com/"

rm -f /tmp/reach.err
