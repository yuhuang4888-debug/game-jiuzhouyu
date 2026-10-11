# backend —— 二开自研服务端（GM / 后台 / 支付 / 账号 API）

这些是原版 PHP 之外的**自研 Java/Python 服务**，用于替代/补齐运营功能。原目录曾放在临时工作区，现归档到仓库。

## 服务一览

| 文件 | 端口 | 说明 |
|---|---|---|
| `GmServer.java` | 8898 | GM 工具（发货/查询/封号/公告等），入口 `/gm/` |
| `AdminServer.java` | 8897 | 运营后台（玩家/订单/活动/配置/支付配置），入口 `/admin/` |
| `PayServer2.java` | 8896 | 支付宝手机网站支付（证书模式），生成收银台、处理 `notify`/`return`、凭证记录 |
| `api_server.py` | 8899 | 账号服（注册/登录/选服）+ 充值订单/凭证页（Python 2.7） |
| `pt_514.erl` | — | 协议补丁：`write(51400)` 补 `0:16`（setting_list），修复卡 11.68% |

## 运行

```bash
# 依赖：JDK8、Python2.7、MySQL5.7、alipay-sdk 等 jar（见服务器 /data/gm）
# 配置：复制示例并修改
cp gm.properties.example  gm.properties
cp pay.properties.example pay.properties

# 编译
javac -encoding UTF-8 -cp .:mysql-connector-j-8.0.33.jar GmServer.java AdminServer.java
javac -encoding UTF-8 -cp .:alipay-sdk.jar:bcprov.jar:commons-logging.jar:gson.jar:httpclient.jar:httpcore.jar:commons-codec.jar PayServer2.java

# 启动（示例）
java -cp .:mysql-connector-j-8.0.33.jar GmServer
java -cp .:mysql-connector-j-8.0.33.jar AdminServer
setsid nohup java -cp .:alipay-sdk.jar:bcprov.jar:commons-logging.jar:gson.jar:httpclient.jar:httpcore.jar:commons-codec.jar PayServer2 &
python2.7 api_server.py      # 需要 PYTHONHOME / LD_LIBRARY_PATH 指向 python2.7
```

> ⚠️ 仓库内**不含**任何真实密钥：`gm.properties` / `pay.properties` / `alipay/`（私钥证书）请自行在服务器配置，且**不要提交**。
