把数据库导出放到这里（按文件名顺序首次启动导入）：

```
00-databases.sql   # 已提供（建库）
10-game_s1.sql     # game_s1 导出
20-game_kf.sql     # game_kf 导出
```

导出示例（在旧库上）：
```bash
mysqldump -uroot -p --default-character-set=utf8 --single-transaction --databases game_s1 > 10-game_s1.sql
```
注意：用 `--databases` 会自动带 `CREATE DATABASE`，与 `00-databases.sql` 重复也无妨。
