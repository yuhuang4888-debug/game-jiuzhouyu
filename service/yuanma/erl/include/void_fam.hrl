%%-----------------------------------------------------------------------------
%% @Module  :       void_fam
%% @Author  :       Czc
%% @Email   :       389853407@qq.com
%% @Created :       2017-11-15
%% @Description:    虚空秘境头文件
%%-----------------------------------------------------------------------------

-define(P_ROLE_MAP, "P_ROLE_MAP").                                      %% 保存在进程字典的参与活动的玩家Map

-define(P_ACHIEVE_FLOOR_RECORD_MAP, "P_ACHIEVE_FLOOR_RECORD_MAP").      %% 进入楼层记录

-define(P_ROOM_MAP, "P_ROOM_MAP").      %% 房间Map #{层数 => #room_info{}}

-define(MIN_RANK_NO, 3).                %% 能领取登顶排名奖励的最小排名

-define(MIN_FLOOR, 1).                  %% 最小层数

-define(ACT_STATUS_CLOSE, 0).
-define(ACT_STATUS_OPEN, 1).

-define(ACT_TYPE_BF, 0).                %% 本服活动
-define(ACT_TYPE_KF, 1).                %% 跨服活动

-define(SYNC_TYPE_ACT_STATUS, 1).       %% 同步活动状态

%% 活动常量配置
-record(void_fam_cfg, {
    id = 0,
    key = "",
    val = 0,
    desc = ""
    }).

%% 层数配置
-record(void_fam_floor_cfg, {
    floor = 0,
    scene = 0,                          %% 场景id
    kf_scene = 0,                       %% 跨服场景id
    born_xy = [],                       %% 出生点坐标集[{x,y}]
    score = 0,
    reward = []
    }).

-record(status_void_fam, {
    status = 0,
    cls_type = 0,
    etime = 0,
    ref = []
    }).

-record(room_info, {
    max_room_id = 1,
    room_list = []                      %% [{房间id, 房间当前人数}]
    }).

-record(role_info, {
    node = none,                        %% 玩家节点
    role_id = 0,                        %% 玩家id
    platform = "",                      %% 平台
    ser_id = 0,                         %% 服务器id
    scene = 0,                          %% 场景id 不在活动场景则为0
    room_id = 0,                        %% 房间id
    score = 0,                          %% 当前积分
    floor = 0,                          %% 最高层数
    hp = 0,                             %% 当前血量
    combo = 0,                          %% 连杀数
    die_num = 0,                        %% 死亡次数
    ref = []                            %% 通关离开场景的定时器
    }).