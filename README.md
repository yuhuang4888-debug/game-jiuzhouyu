# 非凡仙途（原 九州谕 H5）

H5 仙侠 MMO 的**二开源码 + 运营化改造**仓库。

- 前端：LayaAir（TypeScript）H5 客户端
- 服务端：Erlang 游戏服（原版）+ 自研 Java/Python 运营服务（`backend/`）
- 数据库：MySQL 5.7
- 已完成的运营化改造：账号登录、GM/运营后台、支付宝充值、活动、改名（九州谕 → 非凡仙途）、合规信息（运营单位 / ICP 备案）、推广页、充值凭证

## 目录结构

```
client/h5/            LayaAir H5 客户端（源码在 src/，资源在 laya/）
service/
  erlang/             Erlang OTP 运行时（已忽略，不入库）
  excel/              策划表/导出数据（已忽略）
  sql/                数据库导出（已忽略）
  yuanma/erl/         游戏服 Erlang 源码（src/config/include/script/sql）
backend/              自研 Java/Python 服务（GM/后台/支付/账号API）
deploy/               部署脚本与数据库导出（db/ 已忽略）
promo/                推广落地页
部署与打包说明.md
部署到服务器-流程与修改清单.md
```

## 快速开始

### 客户端（本地开发）
```bash
cd client/h5
# 依赖 LayaAir IDE / 参考 启动.bat、一键发布web端代码.bat
```

### 服务端
参见 `部署与打包说明.md`、`部署到服务器-流程与修改清单.md` 与 `backend/README.md`。

## Docker（规划中）

当前生产环境为「原生 + el7 兼容库」部署（Erlang OTP19 + 兼容 libcrypto/libssl.so.10、独立 MySQL5.7、Python2.7、JDK8、Nginx、libfaketime 假时间）。

后续计划用 Docker 打包，方向：
- `game-server`：Erlang OTP19 运行环境（基于 CentOS7 基础镜像 / el7 兼容库）
- `mysql`：MySQL 5.7
- `backend`：JDK8 + Python2.7 运行自研服务
- `nginx`：站点 + wss 反代

> 说明：游戏服有时间校验（需假 2024 时间）、且依赖 el7 的 libcrypto/libssl.so.10，容器化需要一并处理。

## 安全

仓库**不包含**任何真实密钥/证书/数据库导出。请勿提交：
`gm.properties`、`pay.properties`、`alipay/`（私钥与证书）、`*.db`、`*.sql`、SSH 私钥、云服务器密码。
