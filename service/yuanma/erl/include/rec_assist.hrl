%%-----------------------------------------------------------------------------
%% @Author  :       
%% @Created :       
%% @Description:    公会协助头文件
%%-----------------------------------------------------------------------------

-define(ASSIST_TYPE_1,     1).       %% boss
-define(ASSIST_TYPE_2,     2).       %% 副本
-define(ASSIST_TYPE_3,     3).       %% 璀璨之海
-define(ASSIST_TYPE_4,     4).       %% 主线本协助

%% 需要持久化的协助
-define(PERSISTENCE_ASSIST_TYPE_L, [?ASSIST_TYPE_4]).

%% ps
-record(status_assist, {
        assist_id = 0              %% 协助id(唯一)
        , ask_id = 0               %% 求助者id
        , type = 0                 %% 协助类型  1：boss，2：副本，3：璀璨之海
        , sub_type = 0             %% 协助子类型   1、boss:具体boss类型，2、副本：副本类型，3、璀璨之海
        , target_cfg_id = 0        %% 目标配置id，1、boss：是bossid，2、副本：副本id，3、璀璨之海：船只类型
        , target_id = 0            %% 目标id  1、boss：auto_id，2、副本：发0，3、璀璨之海：船只auto_id; 4 主线本关卡
        , assist_process = 0       %% 协助进度 0：协助开始(未确认是否成功) 1：协助成功 2:已取消
        , extra = #{}
        , stime = 0
        , assister_info = undefined %% 协助者信息 类型4（主线本）有效
    }).

%% 协助信息
-record(launch_assist, {
        assist_id = 0              %% 协助id(唯一)
        , role_id = 0
        , figure = []
        , team_id = 0
        , type = 0                 %% 协助类型 1：boss，2：副本，3：璀璨之海; 4: 主线本
        , sub_type = 0             %% 协助子类型 1、boss:具体boss类型，2、副本：副本类型，3、璀璨之海
        , target_cfg_id = 0        %% 目标配置id，1、boss：是bossid，2、副本：副本id，3、璀璨之海：船只类型
        , target_id = 0            %% 目标id  1、boss：auto_id，2、副本：发0，3、璀璨之海：船只auto_id
        , assister_list = []       %% 协助者列表[#assister{}, ...]
        , extra = #{}
    }).

-record(assister, {
        assist_id = 0              %% 协助id(唯一)
        , role_id = 0
        , assist_st = 0            %% 协助状态 1：协助中 2：取消协助
        , bl_st = false            %% 归属状态
        , o_help_type = 0          %% 副本玩家旧的协助状态
        , hurt = 0
        , is_killed = 0            %% 是否击杀了玩家
        , role_info = undefined    %% 玩家信息|用于创建镜像假人，仅4协助类型（主线本）有数据
    }).

-record(base_guild_assist, {
        type = 0                   %% 协助类型 1：boss，2：副本
        , sub_type = 0             %% 协助子类型 boss:具体boss类型，副本：副本类型
        , desc = ""
        , rewards = []
        , condition = []
    }).

-define(sql_select_role_assist, <<"select assist_id, ask_id, type, sub_type, target_cfg_id, target_id, assist_process, extra, stime
                                from role_guild_assist where role_id = ~p limit 1">>).
-define(sql_replace_role_assist, <<"replace into role_guild_assist (role_id, assist_id, ask_id, type, sub_type, target_cfg_id, target_id, assist_process, extra, stime)
                                values (~p, ~p, ~p, ~p, ~p, ~p, ~p, ~p, '~s', ~p)">>).
-define(sql_delete_role_assist, <<"delete from role_guild_assist where role_id = ~p">>).