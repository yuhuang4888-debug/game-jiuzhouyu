%%-----------------------------------------------------------------------------
%% @Module  :      saint.hrl
%% @Author  :       Fwx
%% @Created :       2018-6-13
%% @Description:    圣者殿
%%-----------------------------------------------------------------------------
-define(MAX_ZONE, 6).

-define(SYNC_NO,             0).       %% 未同步
-define(SYNC_YES,            1).       %% 已同步

-define(FORCE_NO,            0).       %% 不强制同步更新
-define(FORCE_UP,            1).       %% 强制同步更新

-define(STATUS_FIGHT,        1).       %% 挑战中
-define(STATUS_FREE,         0).       %% 空闲

-define(READY_SCENE,         data_saint:get_cfg(ready_scene)).       %% 圣者殿大厅场景
-define(FIGHT_SCENE,         data_saint:get_cfg(fight_scene)).       %% 圣者殿战斗场景

-define(CD,                  data_saint:get_cfg(cd)).       %% 挑战冷却

-define(ATTR_TIME,           data_saint:get_cfg(turntable_time)).       %% 转盘显示时间
-define(BATTLE_TIME,         data_saint:get_cfg(battle_time)).       %% 战斗时间

-define(MAX_RECORD,          data_saint:get_cfg(max_record)).      %% 挑战记录上限

%% 圣者殿石像配置
-record(base_saint_stone, {
    id = 0,             %% 石像id
    name = "",          %% 名称
    born_x = 0,         %% 出生x坐标
    born_y = 0,         %% 出生y坐标
    fight_cd = 0,       %% 挑战冷却时间
    dsgt_id = 0         %% 激活对应称号id
    }).

%% 转盘配置
-record(base_saint_turntable, {
    id = 0,             %% 唯一id
    attr = [],          %% 属性加成
    prob = 0            %% 出现概率
}).

%% 鼓舞配置
-record(base_saint_inspire, {
    id = 0,             %% 唯一id
    name = "",          %% 名称
    effect = [],        %% 效果
    num_limit = 0,      %% 次数限制
    type = 0,           %% 货币类型
    price = 0           %% 价格
}).


%% 玩家圣者殿信息
-record(role_saint, {
    role_id = 0,                 %% 玩家id
    server_id = 0,
    plat_form = <<>>,
    server_num = 0,
    server_name = <<>>,          %% 玩家服务器名
    node = null,                  %% 玩家的节点
    inspire_times = []          %% 鼓舞次数列表
}).

%% 玩家形象战力进程字典缓存
-record(role_data, {
    role_id = 0,
    server_name = <<>>,
    figure = undefined,
    combat = 0,
    skills = [],
    attr = undefined
}).

%% 圣者殿进程状态(跨服中心状态)
-record(kf_saint_state, {
    role_info = dict:new(),      %% 玩家数据
    scene_num = #{},
    saint_map = #{},             %% 石像信息 #{ZoneId => #{StoneId => #saint{}}}
    sync = 0                     %% 是否同步
}).

%% 幻兽Boss进程状态(游戏节点状态)
-record(local_saint_state, {
    saint_map = #{},             %% 石像信息
    sync = 0                     %% 是否已经从跨服同步数据:0否;1是;2等待更新中
}).

%% 石像状态
-record(saint, {
    stone_id = 0,               %% 石像id
    role_id = 0,                %% 玩家Id
    server_name = <<>>,         %% 服务器名字
    combat = 0,                 %% 玩家战力
    figure = undefined,         %% 玩家形象
    skills = [],                %% 玩家技能
    attr = undefined,           %% 玩家战斗属性
    cd     = 0,                 %% 挑战cd
    status = 0,                 %% 挑战中状态
    challenge_log = []          %% 挑战记录
}).




