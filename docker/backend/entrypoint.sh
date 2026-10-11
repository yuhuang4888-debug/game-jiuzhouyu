#!/bin/bash
set -e

DB_HOST="${DB_HOST:-mysql}"
DB_PORT="${DB_PORT:-3306}"
GM=/data/gm

wait_port() {
  echo ">> 等待 $1:$2 ..."
  for i in $(seq 1 60); do
    (echo > "/dev/tcp/$1/$2") >/dev/null 2>&1 && return 0
    sleep 2
  done
  return 1
}
wait_port "$DB_HOST" "$DB_PORT" || echo "!! 无法连接数据库，继续尝试启动"

cd "$GM"

java -cp .:mysql-connector-j-8.0.33.jar GmServer >> "$GM/gm.log" 2>&1 &
java -cp .:mysql-connector-j-8.0.33.jar AdminServer >> "$GM/admin.log" 2>&1 &
setsid java -cp .:alipay-sdk.jar:bcprov.jar:commons-logging.jar:gson.jar:httpclient.jar:httpcore.jar:commons-codec.jar PayServer2 \
  </dev/null >> "$GM/payserver2.log" 2>&1 &

cd /data
python2.7 /data/api_server.py >> /data/api_server.log 2>&1 &

trap 'echo ">> 停止后端"; kill 0' TERM INT
wait
