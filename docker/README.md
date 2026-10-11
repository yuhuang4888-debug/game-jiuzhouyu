# Docker 化部署

把现网「原生 + el7 兼容库」的部署方式容器化。

> ✅ 已在 CentOS7 虚拟机（Docker CE 26.1.4 + compose v2.27.1）**构建并端到端跑通**：mysql(导入真实库) + game(OTP19+faketime) + backend(JDK8/py2.7) + nginx，nginx 反代账号接口/后台/GM/wss 均正常。

## 组件

| 服务 | 镜像/构建 | 端口 | 说明 |
|---|---|---|---|
| `mysql` | `mysql:5.7` | 3307→3306 | 游戏库（game_s1 / game_kf） |
| `game` | `./game`（centos:7） | 9180 / 9030 | Erlang OTP19 游戏服（s1 + kf），带 libfaketime 假时间 |
| `backend` | `./backend`（centos:7 + JDK8 + python2.7） | 8896-8899 | 自研 GM/后台/支付/账号服务 |
| `nginx` | `nginx:1.25` | 80 / 443 | 站点 + wss 反向代理 |

## 环境变量

| 变量 | 作用 | 默认 |
|---|---|---|
| `MYSQL_ROOT_PASSWORD` | MySQL root 密码 | change_me |
| `DB_HOST` / `DB_PORT` | 游戏连库地址（容器内为 `mysql:3306`） | mysql:3306 |
| `DB_PASS` | 游戏连库密码（会改写 gsrv.config） | 空=不改 |
| `LISTEN_HOST` | 后端服务监听地址（容器内需 `0.0.0.0`） | 127.0.0.1 |
| `FAKETIME` | 游戏假时间 | 2024-01-01 12:00:00 |

> `backend/` 的 Java/Python 源码据此支持 `LISTEN_HOST` 环境变量：默认仍绑 `127.0.0.1`（与现网一致），容器里设 `0.0.0.0`。

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
   - EPEL7 里库路径是 `/usr/lib64/faketime/libfaketime.so.1`（Dockerfile 已建软链到 `/usr/lib64/`）。
2. **无 TTY 的 erl**：原版用 `screen` 给伪终端，容器里改用 `-noinput`，否则 eshell 收到 EOF 会直接退出。
3. **CentOS7 已 EOL**：基础镜像的 yum 源要换成 `vault.centos.org`，EPEL 换 `archives.fedoraproject.org`（Dockerfile 已处理）。
4. **el7 兼容库**：若在 glibc 较新的宿主（如 Rocky9）上跑，OTP19 需要 `libcrypto/libssl.so.10`；entrypoint 会把 `runtime/compat-lib` 写进 `ld.so.conf.d` 并 `ldconfig`（centos:7 基础镜像自带，可留空目录）。

## DB 连接

容器内后端连的是 compose 服务名 `mysql:3306`（不是 127.0.0.1:3307）。`game/entrypoint.sh` 会自动把
`runtime/game_s1|game_kf/config/gsrv.config` 里的 `db_host/db_port` 改成 `$DB_HOST:$DB_PORT`。

## 已知待办

- [x] 在真实 Docker 环境构建验证（CentOS7 VM）
- [ ] 客户端 `ClientConfig.json` 的域名（`url_account_path` / `url_cdn_path`）改为容器对外域名
- [ ] 账号服返回的 `host/port`（server 域名与 443）同步
- [ ] 支付回调地址 `pay.properties` 的 notify/return 改为对外域名
- [ ] 正式上线用的 TLS 证书（`nginx/certs/`）
