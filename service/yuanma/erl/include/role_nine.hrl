%%%-----------------------------------
%%% @Module  : mod_nine_mgr
%%% @Author  : zmh
%%% @Created : 2017-02-06
%%% @Description: 九重天斗法
%%%-----------------------------------

-define(NINE_KV(Key), data_nine:get_key_value(Key)).

-define(NINE_KV_CLS_OPEN_DAY, ?NINE_KV(1)).     %% 转换成跨服活动的开服天数
-define(NINE_KV_FLAG_TIME, ?NINE_KV(2)).        %% 秘宝时间，每次循环发奖励的时间(秒)
-define(NINE_KV_FLAG_REWARD, ?NINE_KV(3)).      %% 秘宝奖励
-define(NINE_KV_RANK_REFRESH_TIME, ?NINE_KV(4)).%% 榜单刷新时间
-define(NINE_KV_NEED_LV, ?NINE_KV(5)).          %% 等级
-define(NINE_KV_ROBOT_REVIVE_TIME, ?NINE_KV(6)).    %% 假人复活时间(毫秒)
-define(NINE_KV_FLAG_MON_ID, ?NINE_KV(7)).          %% 秘宝怪物id
-define(NINE_KV_FLAG_MON_XY, ?NINE_KV(8)).          %% 秘宝坐标
-define(NINE_KV_REVIVE_COST, ?NINE_KV(9)).          %% 原地复活消耗
-define(NINE_KV_DUMMY_LV_RANGE, ?NINE_KV(10)).      %% 假人在世界等级基础上的等级波动范围
-define(NINE_KV_LAYER_SCORE_TIME, ?NINE_KV(11)).    %% 层数积分，每次增加的时间(秒)
-define(NINE_KV_MON_LIST, ?NINE_KV(12)).        %% 怪物列表
-define(NINE_KV_COPY_NUM, ?NINE_KV(13)).        %% 房间人数，达到上限分房
%%-define(NINE_KV_COPY_NUM, 5).        %% 房间人数，达到上限分房

-define(STATE_CLOSE,    0).         %% 未开放
-define(STATE_OPEN,     1).         %% 开放期间

-define(DEFAULT_FIRSTS, [0, 0, ""]).   %% 首次登顶数据[ServerNum,RoleID,RoleName]

-define(NINE_AWARD_TYPE_SCORE, 1).      %% 积分奖励
-define(NINE_AWARD_TYPE_LAYER, 2).      %% 层数奖励
-define(NINE_AWARD_TYPE_FIRST, 4).      %% 首次登顶奖励
-define(NINE_AWARD_TYPE_RESULT, 5).     %% 结算奖励

-define(DEFAULT_ZONE_ID, 0).            %% 本服模式zoneid
-define(DEFAULT_GROUP_ID, 0).           %% 本服模式groupid

-define(NINE_PARTITION_1, 1).     %% 本服模式
-define(NINE_PARTITION_2, 2).     %% 2服模式
-define(NINE_PARTITION_4, 4).     %% 4服模式
-define(NINE_PARTITION_8, 8).     %% 8服模式

-record(nine_battle, {
        mod = 1 ,        %  模式
        layer_id = 1     %  层数
}).

%% 区域
-record(nine_zone, {
        zone_id = 0,        %% 区域id
        mod = 1,            %% 分服模式（1/2/4/8）
        group_id = 0,       %% 组id
        servers = [],       %% 服务器等级列表 #zone_base{}
        lv = 0,             %% 世界等级
        firsts = ?DEFAULT_FIRSTS,   %% 首次登顶数据[ServerNum, RoleID,RoleName]
        is_create_flag = 0, %% 是否创建了旗帜
        findex = 1,         %% 旗帜索引（每当有人获取奖励索引+1）
        fid    = 0,         %% 旗帜持有者ID
        fname  = 0,         %% 旗帜持有者名字
        f_server_num = 0,   %% 旗帜server_num
        f_role_list = [],   %% 获取旗帜奖励玩家列表[{findex, server_num, role_id, role_name}]
        ranks  = [],        %% 榜单数据
        copy_list = []      %% 房间信息 [{{copy_id, layerId}, role_num}]
    }).

%% state
-record(nine_state, {
        state_type = 0,     %% 进程类型##本服 | 跨服
        status = 0,         %% 状态
        cls_type = 0,       %% 服类型##本服 | 跨服
        stime = 0,          %% 开始时间
        etime = 0,          %% 结束时间
        zone_map = #{},     %% 区域Map 跨服格式: #{{ZoneId, GroupId} => #nine_zone{}}
        group_map = #{},    %% 分组map #{ZoneId => {ServerMap(#{SerId => {Mod, GroupId}}), ModGroupMap(#{{Mod, GroupId} => ZoneBasesL})}}
        role_map = #{},     %% 玩家map Key:RoleId Value:ZoneId
        ref = none,         %% 定时器##结束定时器
        rank_ref = none,    %% 榜单定时器
        flag_ref = none,    %% 秘宝定时器
        score_ref = none,   %% 层数积分定时器
        zone_id = 0,
        group_id = 0,       %% 分组id   ##本服
        mod = 1,            %% 分服模式  ##本服
        servers = []       %% 服务器等级列表#zone_base{} ##本服
    }).

%% 榜单
-record(nine_rank,{
        rank = 0,       %% 榜单
        role_id = 0,    %% 玩家id
        name = "",      %% 名字
        career = 0,     %% 职业
        server_id = 0,  %% 服id
        zone_id = 0,    %% 区域id
        group_id = 0,   %% 组id
        copy_id = 0,    %% 房间id
        mod = 1,        %% 分服模式（1/2/4/8）
        server_name = "",   %% 平台
        server_num = 0, %% 服号
        combat_power = 0,   %% 战力
        is_on = 0,      %% 是否在九魂圣殿里面
        layer_id = 1,   %% 所在层
        kill  = 0,      %% 当前击杀
        dkill = 0,      %% 当前连杀
        max_layer_id = 0,   %% 最高层
        max_kill = 0,   %% 最大击杀
        max_dkill = 0,  %% 最大连杀
        gain_grade = 0, %% 已领取积分级别
        add   = 0,      %% 单次累加积分
        score = 0,      %% 积分
        reward = [],    %% 获得的奖励
        world_lv = 0    %% 世界等级
    }).

-record(copy_info, {

}).

-record(copy_info_cls, {
        key = {0,0}
}).

%% 配置
-record(base_nine,{
        mod_id = 0,         %% 模式id
        layer_id = 0,       %% 层id
        scene_id = 0,       %% 场景id
        cls_scene_id = 0,   %% 跨服场景id
        kill_num = 0,       %% 击杀数量
        award = [],         %% 层数奖励
        is_drop = 0,        %% 是否降层
        drop_rate = 0,      %% 概率##万分比
        first_award = [],   %% 首个奖励
        find_path = [],     %% 寻路坐标
        born_pos = [],      %% 出生坐标集
        mon_num = 0,        %% 怪物数量
        mon_pos = [],       %% 怪物坐标
        layer_score = 0     %% 层数积分
    }).

-define(SQL_ROLE_NINE_GET, <<"SELECT `zone_id`, `group_id`, `role_id`,`name`,`career`,`server_id`,`server_name`,`server_num`,`max_layer_id`,`max_kill`,`max_dkill`,`score` FROM `role_nine`">>).
-define(SQL_ROLE_NINE_BATCH, <<"REPLACE INTO role_nine (`zone_id`, `group_id`, `role_id`,`name`,`career`,`server_id`,`server_name`,`server_num`,`max_layer_id`,`max_kill`,`max_dkill`,`score`) VALUES ~ts">>).
-define(SQL_ROLE_NINE_VALUES, "(~w, ~w, ~w,'~s',~w,~w,'~s',~w,~w,~w,~w,~w)").
-define(SQL_ROLE_NINE_TRUNCATE, <<"TRUNCATE TABLE role_nine">>).
