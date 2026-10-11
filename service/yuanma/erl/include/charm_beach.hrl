%%----------------------------------------------------
%% @title 魅力沙滩头文件
%% @creator yxf
%% @date 20171106
%%----------------------------------------------------

%% 预定义字段-----------------------------------------
%% 活动阶段
-define(BEACH_CLOSE, 0).    %% 海滩关闭阶段
-define(BEACH_READY, 1).    %% 海滩准备阶段
-define(BEACH_OPEN, 2).     %% 海滩活动进行阶段
-define(BEACH_REWARD, 3).   %% 海滩活动发奖励阶段

%% 用户初始化数据
-define(GIFT_TIMES, 5).     %% 初始赠送礼物次数

%% 活动相关配置
-define(LEAVE_BEACH, 0).    %% 离开海滩场景
-define(ACT_TYPE, 1).         %% 本服配置ID
-define(CAL_REWARD_TIME, 10).   %% 计算奖励时长
-define(PREVILEGE_ID, 1).   %% vip经验增加特权子id
-define(BEACH_OPEN_LV, 60). %% 海滩开放等级
-define(OFF_TITLE, 43).    %% 离线发送奖励邮件标题
-define(OFF_CONTENT, 44).  %% 离线发送奖励邮件内容

% -define(RANK_LIST_NUM, 3). %% 海滩排行榜上限人数
-define (MB_PAGE_NUM, 10).  %% 海滩人员列表每页人数

-define(SEND_GIFT, 0).     %% 赠送礼物
-define(GET_GIFT, 1).      %% 收到礼物


%% 传闻预定义
-define(READY_ACT_RUMORID, 1).  %% 活动准备传闻id
-define(START_ACT_RUMORID, 2).  %% 活动开始传闻id
-define(SEND_GIFT_RUMORID1, 3).  %% 赠送礼物传闻id
-define(SEND_GIFT_RUMORID2, 4).  %% 赠送礼物传闻id
-define(SEND_GIFT_RUMORID3, 5).  %% 赠送礼物传闻id
-define(SEND_GIFT_RUMORID4, 6).  %% 赠送礼物传闻id

% 海滩经验：y=32341*1.5^((x-170)/50))
% 约会经验：y=13862*1.5^((x-170)/50))
%% 经验增加
-define(ON_ENGAGE, 1).      %% 约会中的经验
-define(BASE_EXP(Lv), trunc(32341* math:pow(1.5, (Lv-170)/50))).      %% 基础经验
-define(ENGAGE_EXP(Lv), trunc(13862* math:pow(1.5, (Lv-170)/50))).    %% 约会经验

-define(REFUSE_ENGAGE, 0).         %% 拒绝约会
-define(AGGRE_ENGAGE, 1).         %% 接收约会
-define(HAS_INVITED, 2).         %% 已经邀请过

%% 跨服相关
-define(BF_BEACH_SCENE_ID, 5161).   %%跨服海滩场景id
-define(KF_BEACH_SCENE_ID, 5162).   %%跨服海滩场景id
-define(ACT_TYPE_BF, 1).                %% 本服活动
-define(ACT_TYPE_KF, 2).                %% 跨服活动
-define(SCENE_ID(T), if T =:= ? ACT_TYPE_BF -> ?BF_BEACH_SCENE_ID; true -> ?KF_BEACH_SCENE_ID end).

%% 魅力沙滩功能记录------------------------------------

%% 活动状态记录
-record(beach_stage, {
    stage = 0,              %% 当前步骤 0-关闭 1-准备 2-进行中 3-发奖励
    act_type = 0,           %% 活动类型 0-本服 1-跨服
    scene = 0,              %% 场景id 
    starttime = 0,          %% 活动开始时间戳
    endtime = 0,           %% 活动持续时长（秒）
    ref = [],               %% 计时器引用
    members = dict:new(),   %% 当前参与的玩家 [role_id, #beach_member{}]
    rank_list = []          %% 魅力排行榜前20的list [{RoleId, CharmValue, Rank}]
    }).

%% 参与活动玩家信息
-record(beach_member, {
    role_id = 0,            %% 玩家id
    node = [],              %% 玩家节点（跨服节点中需要用到）
    figure = undefined,     %% 玩家形象
    % name = "",              %% 玩家名字
    % role_lv = 0,            %% 玩家等级
    % gender = 0,             %% 性别 1-男 2-女
    scene = 0,              %% 场景id 0-不在场景内
    % guild_id = 0,           %% 公会id
    % guild_name = "",        %% 公会名称
    % picture = "",           %% 头像
    acc_exp = 0,            %% 累计经验
    gift_times = 0,         %% 赠送礼物剩余次数
    charm_v = 0,            %% 魅力值
    engage_roleid = 0,      %% 约会对象id 0-未在约会状态
    % vip_lv = 0,             %% vip等级
    buy_times = 0,          %% 赠送次数
    server_id = 0,          %% 玩家区服
    gift_record = [],       %% 礼物记录 {RoleId, Name, Times, Oper} (Oper 0-赠送 1-收到)
    pre_time = 0,           %% 上次获取经验时间戳 0-还没有获取过经验
    engage_exp = 0,         %% 约会中获得的经验
    invited_list = []       %% 已经邀请过的玩家列表[{role_id, time}],
    , result = undefined    %% 结果 缓存到退出场景才发送
    , members_page_index = 1 %% 海滩人员列表序号
    }).

%% 魅力沙滩配置记录------------------------------------

%% 活动配置
-record(base_beach_act_cfg, {
    id = 0,                 %% 配置类型
    start_time = 0,         %% 每天活动开放时间点
    ready_time = 0,         %% 活动开始前准被时长（秒）
    interval = 0,           %% 增加经验间隔
    duration = 0,           %% 活动持续时长（秒）
    cal_time = 0,            %% 结算奖励时长
    kf_min_day = 0,         %% 开服后多少天跨服
    buy_cost = 0,          %% 购买赠送次数消耗物品
    scene_id = 0            %% 场景id
    }).

%% 经验配置
-record(base_beach_exp,{
    lv_ll = 0,              %% 等级下限
    lv_ul = 0,              %% 等级上限
    gift_exp = 0            %% 赠送礼物经验
    }).

%% 购买赠送次数配置
-record(base_beach_buy, {
    buy_times = 0,          %% 购买次数
    money_type = 0,         %% 货币类型
    price = 0               %% 价格
    }).

%% 魅力值道具配置
-record(base_beach_props, {
    props_type = 0,          %% 道具类型
    props_name = "",         %% 道具名称
    charm_v = 0              %% 道具魅力值
    % rumors = ""              %% 传闻内容
    }).

%% 魅力值排行榜奖励配置
-record(base_beach_reward, {
    rank_ll = 0,             %% 排名下限
    rank_ul = 0,             %% 排名上限
    reward = []              %% 奖励内容
    }).
