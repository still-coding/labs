# Деплой

Сайт живёт в двух местах сразу:

- **HTTP** — https://labs.evil-teacher.ru: Caddy на VPS `81.200.144.62`, HTTPS от Let's Encrypt. DNS в Cloudflare, но
  **без прокси** (серое облако): российские провайдеры режут Cloudflare до первых ~16 КБ ответа.
- **IPFS** — CAR пинится в Filebase, `_dnslink.labs.evil-teacher.ru` указывает на CID. В Brave: `ipns://labs.evil-teacher.ru`.
  Гейтвей Filebase из России без VPN режется так же, как Cloudflare: IPFS-копия — для тех, кто с VPN или со своей нодой.

Каждый push в `main` запускает `.github/workflows/deploy.yml`:

```
hugo --minify → site.car → CID → пин в Filebase (сверка CID) → rsync на VPS
             → DNS: A labs (DNS only) + TXT _dnslink → чистка старых пинов (последние 5 остаются)
```

DNS обновляется последним: имя никогда не указывает на то, что ещё не лежит на сервере и не запинено.

## Сервер общий

| Хост | Что | Чей файл |
|---|---|---|
| `labs.evil-teacher.ru` | этот сайт, `/srv/labs` | `deploy/server/sites/labs.caddy` |
| `evil-teacher.ru`, голый IP, любой неизвестный хост | заглушка, `/srv/root` | `deploy/server/sites/root.caddy` |
| `www.evil-teacher.ru` | редирект на `evil-teacher.ru` | там же |
| `fly.evil-teacher.ru` | anti_fly, `/srv/anti-fly` | репозиторий anti_fly, `deploy/push.sh` |

`/etc/caddy/Caddyfile` только импортирует `/etc/caddy/sites/*.caddy`, и каждый деплой пишет лишь свой файл.
Сертификаты Let's Encrypt Caddy получает и продлевает сам. **Оранжевое облако не включать**: провайдеры режут
Cloudflare, а Caddy, редиректящий HTTP на HTTPS за прокси в режиме *Flexible*, зацикливает запросы.
Проверить доступность без VPN: `deploy/check-reachability.sh`.

## Разовая настройка

**1. Ключ для CI и сервер.** Скрипт переносит текущий конфиг fly в `sites/anti-fly.caddy`, добавляет labs и
заглушку, заводит пользователя `deploy`, которому ключ разрешает только rsync в `/srv/labs` (rrsync).
Перед изменениями делает бэкап `/etc/caddy.bak-*`, при невалидном конфиге откатывается.

```bash
ssh-keygen -t ed25519 -N '' -C labs-deploy -f ~/.ssh/labs_deploy
scp -r deploy/server ~/.ssh/labs_deploy.pub root@81.200.144.62:/tmp/
ssh root@81.200.144.62 'bash /tmp/server/setup.sh /tmp/labs_deploy.pub'
```

В конце он печатает отпечаток ключа хоста: сверь его с `ssh-keygen -lf deploy/known_hosts`.

**2. Токен Cloudflare.** *My Profile → API Tokens → Create Token → Custom*:
Zone → Zone → Read и Zone → DNS → Edit, Zone Resources → только `evil-teacher.ru`.

**3. Filebase.** Bucket с сетью IPFS и ключи доступа (*Access Keys*).

**4. GitHub** → *Settings → Secrets and variables → Actions*:

| Secrets | |
|---|---|
| `VPS_DEPLOY_KEY` | содержимое `~/.ssh/labs_deploy` (приватный) |
| `CF_DNS_TOKEN` | токен из шага 2 |
| `FILEBASE_KEY`, `FILEBASE_SECRET` | ключи из шага 3 |

| Variables | |
|---|---|
| `FILEBASE_BUCKET` | имя bucket |

После этого — push в `main` или *Actions → deploy → Run workflow*.

## Откат

- **Целиком:** `git revert` или *Run workflow* на старом коммите. Версии Hugo и ipfs-car зафиксированы, так что
  получится тот же CID; если он ещё в Filebase, повторной загрузки не будет.
- **Только IPFS:** `CF_API_TOKEN=… ZONE=evil-teacher.ru DOMAIN=labs.evil-teacher.ru ORIGIN_IP=81.200.144.62 CID=<старый> deploy/cloudflare-dns.sh`.
  CID каждого деплоя — в Summary его запуска.

## Что нужно знать

- **Смена `HUGO_VERSION` или `IPFS_CAR_VERSION` меняет CID.** Обновляй их отдельно от контента.
  Сам по себе CID меняется ещё раз в год — из-за `now.Year` в футере темы.
- **`relativeURLs: true` не трогать.** Без него CSS и картинки ломаются на path-гейтвее `/ipfs/<CID>/`.
  Картинки в `{{< figure >}}` проходят через `relURL` (`layouts/shortcodes/figure.html`), поэтому пиши `src="/images/…"`.
- **Меню и списки страниц используют абсолютные ссылки** (`.Permalink` в теме). Через `ipns://` и `/ipfs/<CID>/`
  страница открывается, но переход по меню уводит на HTTP-версию.
- **CAR весит около 480 МБ**, почти всё — `static/books`. Он заливается целиком, если CID новый.
