#!/bin/bash
set -e

DB_HOST="${DB_HOST:-mysql}"
DB_PORT="${DB_PORT:-3306}"
DB_PASS="${DB_PASS:-}"

# ---- el7 兼容库（OTP19 crypto NIF 依赖 libcrypto/libssl.so.10）----
if [ -d /data/compat-lib ]; then
  echo "/data/compat-lib" > /etc/ld.so.conf.d/gamecompat.conf
  ldconfig
fi

# 兼容库就位后再检查 OTP
if [ ! -x /data/otp_src_19.1/bin/erl ]; then
  echo "!! 缺少 /data/otp_src_19.1/bin/erl —— 请先执行 docker/prepare-runtime.sh" >&2
  exit 1
fi

# ---- 改写连库地址为 compose 服务名 ----
for s in game_kf game_s1; do
  cfg="/data/$s/config/gsrv.config"
  [ -f "$cfg" ] || continue
  SED="s/\{db_host,[[:space:]]*\"[^\"]*\"\}/{db_host, \"$DB_HOST\"}/; s/\{db_port,[[:space:]]*[0-9]+\}/{db_port, $DB_PORT}/"
  if [ -n "$DB_PASS" ]; then
    SED="$SED; s/\{db_pass,[[:space:]]*\"[^\"]*\"\}/{db_pass, \"$DB_PASS\"}/"
  fi
  sed -i -E "$SED" "$cfg"
  echo "[$s] db -> $DB_HOST:$DB_PORT"
done

ulimit -SHn 100000

# ---- 假时间（只影响游戏进程；容器/宿主保持真实时间）----
FK=$(ls /usr/lib64/libfaketime.so.1 /usr/lib64/faketime/libfaketime.so.1 2>/dev/null | head -1)
if [ -n "$FK" ]; then
  export LD_PRELOAD="$FK"
else
  echo "!! 未找到 libfaketime，游戏可能因时间校验启动失败" >&2
fi
export FAKETIME="${FAKETIME:-2024-01-01 12:00:00}"
export FAKETIME_DONT_FAKE_MONOTONIC=1

start_node() {
  local dir="$1" port="$2" node="$3" cookie="$4"
  mkdir -p "/data/$dir/logs"
  cd "/data/$dir/config"
  /data/otp_src_19.1/bin/erl \
    -noinput \
    -kernel inet_dist_listen_min 40001 \
    -kernel inet_dist_listen_max 40100 \
    +P 1000000 +K true +A 100 +spp true -smp enable -hidden \
    -name "${node}@127.0.0.1" \
    -setcookie "$cookie" \
    -boot start_sasl -config gsrv -pa ../ebin -s gsrv start \
    -extra 127.0.0.1 "$port" 10 >> "/data/$dir/logs/start.log" 2>&1 &
  echo "[$dir] 启动 erl (port $port) pid=$!"
}

start_node game_kf 9030 qudaoljkf0040 qudaolj004NnJQua27Qal82zHpz
sleep 5
start_node game_s1 9180 qudaoljgame33410 qudaolj334NnJQua27Qal82zHpz

trap 'echo ">> 停止游戏服"; kill 0' TERM INT
wait
