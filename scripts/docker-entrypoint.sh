#!/bin/sh
set -e
# 将自定义域名解析到与 host.docker.internal 相同 IP（需运行环境提供 host.docker.internal，如 Docker Desktop 或 --add-host / compose host-gateway）
host_ip=$(awk '/host\.docker\.internal/{print $1; exit}' /etc/hosts 2>/dev/null || true)
if [ -z "$host_ip" ] && command -v getent >/dev/null 2>&1; then
  host_ip=$(getent hosts host.docker.internal 2>/dev/null | awk '{ print $1; exit }' || true)
fi
if [ -n "$host_ip" ] && ! grep -q '[[:space:]]login\.ibb8\.store' /etc/hosts 2>/dev/null; then
  echo "$host_ip login.ibb8.store useradmin.ibb8.store" >> /etc/hosts
fi
exec npm run "$@"
