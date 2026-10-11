%% 幻兽之域 分区管理

-define(ANNOUNCE_TIME,         300).       %% 提前5分钟通知分区

-define(EUDEMONS_DAY_1,         90).       %% 开服超过90天的分为同一大组
-define(EUDEMONS_DAY_2,         7).       %% 开服间隔在7天内的分为一个大组

-record(eudemons_zone_mgr, {
        zone_id = 0,
        status = 1,                 %% 1 正常 2 重置中
        reset_etime = 0,             %% 洗牌结束时间
        next_reset_time = 0,         %% 下次洗牌时间戳
        sign_list = [],              %% 待重置列表
        server_map = #{},            %% #{server_id=>#server_info{}}
        zone_map = #{},             %% #{zone_id => [ServerId]}
        ref_reset = undefined       %%    
        }).

-record(eudemons_server, {
          server_id = 0,
          zone_id = 0,
          server_num = 0,
          server_name = "",
          optime = 0,
          merge_servers = []
         }).

-record(eudemons_zone, {
        server_id = 0,
        zone_id = 0
    }).