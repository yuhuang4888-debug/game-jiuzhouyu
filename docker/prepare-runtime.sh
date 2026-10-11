#!/usr/bin/env bash
# 从现网服务器抓取 Docker 运行所需运行时到 docker/runtime/（含密钥，勿提交）
set -euo pipefail

if [ $# -lt 1 ]; then
  echo "用法: $0 user@host [ssh端口]"
  exit 1
fi
SSH_HOST="$1"
SSH_PORT="${2:-22000}"
SSH_OPTS="-P $SSH_PORT -o StrictHostKeyChecking=no"

DOCKER_DIR="$(cd "$(dirname "$0")" && pwd)"
DST="$DOCKER_DIR/runtime"
mkdir -p "$DST"

echo ">> 抓取运行时到 $DST"
scp $SSH_OPTS -r \
  "$SSH_HOST:/data/otp_src_19.1" \
  "$SSH_HOST:/data/compat-lib" \
  "$SSH_HOST:/data/game_s1" \
  "$SSH_HOST:/data/game_kf" \
  "$SSH_HOST:/data/py27" \
  "$SSH_HOST:/data/gm" \
  "$SSH_HOST:/data/api_server.py" \
  "$DST/"

echo ">> 抓取客户端 web 静态资源"
scp $SSH_OPTS -r "$SSH_HOST:/home/game-www" "$DST/"

echo ">> 完成。请检查 runtime/ 内容，并确认 .gitignore 已忽略。"
