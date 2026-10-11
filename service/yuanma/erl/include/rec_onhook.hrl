%%% @doc
%%% 挂机设置
%%% @end

%% 挂机设置类型
-define(ONHOOK_PLACE,      1).        %% 挂机范围
-define(AUTO_GREEN,        2).        %% 自动拾取：绿
-define(AUTO_BLUE,         3).        %% 自动拾取：蓝
-define(AUTO_PURPLE,       4).        %% 自动拾取：紫
-define(AUTO_SELL,         5).        %% 自动出售：白绿装备
-define(AUTO_DEVOUR,       6).        %% 自动吞噬：白绿蓝紫装（不包括项链、护符、手镯、戒指部位）
-define(AUTO_TEAM,         7).        %% 自动组队
-define(AUTO_REVIVE,       8).        %% 自动复活
-define(AUTO_ORANGE,       9).        %% 自动拾取：橙装及以上 橙色
-define(AUTO_ED_DEVOUR,   10).        %% 自动幻兽装备吞噬
-define(AUTO_SW_DEVOUR,   11).        %% 自动圣纹分解

-define(ONHOOK_CREATE_TIME,      36000).   %% 玩家创建角色给10小时离线挂机时间
-define(ONHOOK_TO_TIME,            180).   %% 180s进入离线挂机时间
-define(ONHOOK_RESULT_TIME,          5).   %% 5s发送结算信息
-define(ONHOOK_RESULT_SEND_TIME,    60).   %% 60s离线挂机一分钟推送结算信息
-define(ONHOOK_REVIVE_UNATT_TIME, 1800).   %% 离线挂机复活保护时间

%% 日志类型
-define(ONHOOK_STAER,      0).        %% 开始挂机
-define(ONHOOK_NO_TIME,    1).        %% 没有挂机时间
-define(ONHOOK_DIE,        2).        %% 死亡没有复活
-define(ONHOOK_NO_PLACE,   3).        %% 找不到挂机点
-define(ONHOOK_LOGIN,      4).        %% 玩家上线
-define(ONHOOK_SERVER_STOP,5).        %% 服务器停止
-define(ONHOOK_OTHER,      6).        %% 其他未知中断
-define(ONHOOK_FORBIDDEN,  7).        %% 封号中断
-define(ONHOOK_WAIGUA,     8).        %% 使用外挂中断

%% 默认离线设置
-define(DEF_ONHOOK, [
        {?ONHOOK_PLACE,    0}
        % {?AUTO_GREEN,      0},
        % {?AUTO_BLUE,       0},
        % {?AUTO_PURPLE,     0},
        % {?AUTO_SELL,       0},
        % {?AUTO_DEVOUR,     0},
        % {?AUTO_TEAM,       0},
        % {?AUTO_REVIVE,     0},
        % {?AUTO_ORANGE,     0},
        % {?AUTO_ED_DEVOUR,  0},
        % {?AUTO_SW_DEVOUR,  0}
    ]).

%% 离线挂机配置
-record(base_onhook, {
        scene_id = 0,               %% 挂机场景
        id = 0,                     %% 挂机点id
        name = 0,                   %% 挂机点怪物id
        min_lv = 0,                 %% 推荐最低最小等级
        max_lv = 0,                 %% 最大等级
        xy = [{0, 0}],              %% 挂机坐标点[{x1,y1}...]
        power = 0,                  %% 挂机推荐战力
        color = 0,                  %% 挂机点颜色
        content = "",               %% 收益说明[{装备品质，装备阶数，掉落数量（件/天）}，{exp，经验量，经验单位（好像0是“xx/分钟”，1是“xx万/分钟”，2是“xx亿/分钟”）}]
        onhook_exp = 0,             %% 经验值
        onhook_type = 0             %% 挂机点类型(0:默认离线野外挂机;1:boss展示用)
    }).

%% 玩家离线挂机数据
-record(status_onhook, {
        onhook_time = 0,            %% 离线挂机剩余时间
        onhook_setting = [],        %% 离线设置
        onhook_sxy = {0, 0, 0, 0},  %% 挂机点
        onhook_btime = 0,           %% 挂机开始时间点
        onhook_etime = 0,           %% 挂机结束时间点
        lv = 0,                     %% 挂机时等级
        exp = 0,                    %% 获得经验
        pet_exp = 0,                %% 宠物经验(yyhx没有这个)
        cost_onhook_time = 0,       %% 消耗的离线时间
        auto_devour_equips = 0,     %% 自动吞噬的蓝装数量
        auto_pickup_goods = [],     %% 自动拾取的物品[{goods_id, num}]
        c_lv = 0,                   %% 挂机时等级(客户端)
        c_exp = 0,                  %% 获得经验(客户端)
        c_cost_onhook_time = 0,     %% 消耗的离线时间(客户端)
        c_auto_devour_equips = 0,   %% 自动吞噬的蓝装数量(客户端)
        c_auto_pickup_goods = [],   %% 自动拾取的物品[{goods_id, num}](客户端)
        revive_data = [],           %% 死亡复活数据[{gold, BGold, Gold}, {count, Num}, {kill, Name}]
        redemption_exp = 0,         %% 可赎回经验
        redemption_gold = 0,        %% 可赎回经验消耗
        redemption_time = 0         %% 更新时间
        , exp_list = []             %% 挂机不加成的基础经验(没有药品加成才计算)##[{时间,exp}]
        , get_count = 0             %% 获得次数
    }).

%% 离线挂机代理进程
-record(onhook_agent, {
        role_onhook = []
    }).

%% 玩家信息
-record(role_onhook_info, {
        id = 0,
        acc_id = 0,
        acc_name = "",
        ip = "",
        time = 0
    }).

%% ----------------------------- auction_type -----------------------------
%% 查找玩家挂机设置信息
-define(SQL_ROLE_ONHOOK_SELECT,
    <<"select onhook_time, onhook_setting, lv, exp, pet_exp, cost_onhook_time, auto_devour_equips, auto_pickup_goods, 
        c_lv, c_exp, c_cost_onhook_time, c_auto_devour_equips, c_auto_pickup_goods,
        revive_data, onhook_start_time, onhook_end_time, redemption_exp, redemption_gold, redemption_time, exp_list, get_count 
        from `role_onhook` where player_id = ~p limit 1">>).

%% 新增
-define(SQL_ROLE_ONHOOK_INSERT,
    <<"insert into `role_onhook`(player_id, onhook_time, onhook_setting, lv, exp, pet_exp, cost_onhook_time, auto_devour_equips, auto_pickup_goods, revive_data, c_auto_pickup_goods)
        values(~p, ~p, '~s', ~p, ~p, ~p, ~p, ~p, '~s', '~s', '~s')">>).

%% 更新没有结束时间
-define(SQL_ROLE_ONHOOK_UPDATE,
    <<" update `role_onhook` set onhook_time=~p, onhook_setting='~s', lv=~p, exp=~p, pet_exp=~p, cost_onhook_time=~p, auto_devour_equips=~p, auto_pickup_goods='~s', 
        c_lv=~p, c_exp=~p, c_cost_onhook_time=~p, c_auto_devour_equips=~p, c_auto_pickup_goods='~s',
        revive_data='~s', onhook_start_time = ~p, onhook_end_time = ~p, exp_list='~s', get_count=~p
        where player_id = ~p">>).

%% 离线挂机设置保存
-define(SQL_ROLE_ONHOOK_UPDATE_SETTING,
    <<"update role_onhook set onhook_setting='~s' where player_id = ~p">>).

%% 离线挂机时间保存
-define(SQL_ROLE_ONHOOK_UPDATE_TIME,
    <<"update role_onhook set onhook_time=~p where player_id = ~p">>).

%% 离线挂机设置保存
-define(SQL_ROLE_ONHOOK_UPDATE_START_TIME,
    <<"update role_onhook set onhook_start_time=~p  where player_id = ~p">>).

%% 更新离线赎回经验
-define(SQL_ROLE_ONHOOK_UPDATE_REDEMPTION_EXP, 
    <<"update role_onhook set redemption_exp=~p, redemption_gold=~p, redemption_time=~p where player_id = ~p">>).

%% 记录离线挂机日志
-define(SQL_LOG_ONHOOK,
    <<"insert into log_onhook (role_id, type, onhook_time, time) values (~p, ~p, ~p, ~p)">>).

%% 更新离线挂机经验信息
-define(SQL_ROLE_ONHOOK_UPDATE_EXP_LIST, <<"update role_onhook set exp_list='~s', get_count=~p where player_id = ~p">>).