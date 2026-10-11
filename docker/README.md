# Docker 化部署（规划/脚手架）

把现网「原生 + el7 兼容库」的部署方式容器化。**注意：本目录尚未在真实 Docker 环境构建验证过**（开发机无 Docker）；请先在测试机 `docker compose build` 验证后再上线。

## 组件

| 服务 | 镜像/构建 | 端口 | 说明 |
|---|---|---|---|
| `mysql` | `mysql:5.7` | 3307→3306 | 游戏库（game_s1 / game_kf） |
| `game` | `./game`（centos:7） | 9180 / 9030 | Erlang OTP19 游戏服（s1 + kf），带 libfaketime 假时间 |
| `backend` | `./backend`（centos:7 + JDK8 + python2.7） | 8896-8899 | 自研 GM/后台/支付/账号服务 |
| `nginx` | `nginx:1.25` | 80 / 443 | 站点 + wss 反向代理 |

## 前置：准备运行时（runtime/）

镜像只装系统环境，**运行时数据用 bind mount 挂载**（OTP19、游戏目录、jar、客户端资源等都很大且含密钥，不入库）。

```bash
# 在能 ssh 到现网服务器的机器上执行
./prepare-runtime.sh root@211.149.169.170 22000
```

会在 `docker/runtime/` 下生成：

```
runtime/
  otp_src_19.1/    Erlang OTP19（编译好的）
  compat-lib/      el7 的 libcrypto/libssl.so.10
  game_s1/ game_kf/  游戏服（config/ebin/script/logs/sql）
  py27/            Python2.7 运行时（镜像里用系统 python 也行）
  gm/              GmServer/AdminServer/PayServer2 的 .class/.java + jar + properties + alipay/
  api_server.py    账号服
  game-www/        客户端 web（静态资源，nginx 用）
```

> `runtime/` 已加入 `.gitignore`（含 `alipay/` 私钥、数据库口令），**不要提交**。

数据库初始化：把导出的 SQL 放到 `mysql/init/`（会按文件名顺序在首次启动时导入）：
```
mysql/init/00-databases.sql     # 已提供：建库 game_s1 / game_kf
mysql/init/10-game_s1.sql       # 你的 game_s1 导出
mysql/init/20-game_kf.sql       # 你的 game_kf 导出
```

## 快速开始

```bash
cp .env.example .env      # 改 MYSQL_ROOT_PASSWORD / 域名
docker compose build
docker compose up -d
docker compose logs -f game
```

## 域名 / 证书

`nginx/conf.d/*.conf` 目前按现网 5 个子域编写（`game/api/pay/www/server.rqsr888.cn`）。请：
1. 改成你自己的域名（`server_name`）；
2. 把证书放到 `nginx/certs/`，命名为 `fullchain.pem` / `privkey.pem`
   （或先用自签证书测试：`openssl req -x509 -newkey rsa:2048 -nodes -keyout certs/privkey.pem -out certs/fullchain.pem -days 365 -subj "/CN=localhost"`）。

## 两个关键坑（已在配置里处理）

1. **假时间**：游戏服有时间校验，系统时间 2026 起不来。`game/entrypoint.sh` 里用 **libfaketime** 只给 erl 进程假 `2024-01-01`，容器/宿主真实时间不受影响（否则 HTTPS、支付宝回调会出问题）。
2. **el7 兼容库**：OTP19 的 crypto NIF 依赖 `libcrypto.so.10` / `libssl.so.10`（el7），entrypoint 会把 `runtime/compat-lib` 写进 `ld.so.conf.d` 并 `ldconfig`。

## DB 连接

容器内后端连的是 compose 服务名 `mysql:3306`（不是 127.0.0.1:3307）。`game/entrypoint.sh` 会自动把
`runtime/game_s1|game_kf/config/gsrv.config` 里的 `db_host/db_port` 改成 `$DB_HOST:$DB_PORT`。

## 已知待办

- [ ] 在真实 Docker 环境构建验证
- [ ] 客户端 `ClientConfig.json` 的域名（`url_account_path` / `url_cdn_path`）改为容器对外域名
- [ ] 账号服返回的 `host/port`（server 域名与 443）同步
- [ ] 支付回调地址 `pay.properties` 的 notify/return 改为对外域名
