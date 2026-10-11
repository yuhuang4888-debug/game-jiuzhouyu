%% ---------------------------------------------------------
%% Author:  xyj
%% Email:   156702030@qq.com
%% Created: 2012-3-19
%% Description: 物品掉落ets
%% --------------------------------------------------------
% 广播类型
-define(BROAD_NONE,     0).       %% 不广播，掉落只展示给玩家自己看
-define(BROAD_TEAM,     1).       %% 队伍广播
-define(BROAD_SCENE,    2).       %% 场景广播

% 分配方式
-define(ALLOC_ONESELF,  1).       %% 分配方式：队长独占
-define(ALLOC_RAND,     2).       %% 分配方式：队伍随机
-define(ALLOC_EQUAL,    3).       %% 分配方式：队伍均等
-define(ALLOC_BLONG,    4).       %% 分配方式：归属拾取
-define(ALLOC_SINGLE,   5).       %% 分配方式：单人掉落(触发特殊功能的掉落规则,看看是否需要自己触发掉落,如果走正常掉落则会是最后一击的玩家获得掉落)
-define(ALLOC_SINGLE_2, 6).       %% 分配方式：单人掉落2(触发特殊功能的掉落规则,看看是否需要自己触发掉落,如果走正常掉落则会是最后一击的玩家获得掉落)
-define(ALLOC_HURT_EQUAL, 7).     %% 分配方式：伤害均等(只有对应的玩家能看到)

%% 归属
-define(DROP_HURT,      0).       %% 伤害最高获得(单人/队伍)
-define(DROP_FIRST_ATT, 1).       %% 第一击获得(单人/队伍)
-define(DROP_LAST_ATT,  2).       %% 最后一击获得(单人/队伍)
-define(DROP_NO_ONE,    3).       %% 无归属:生成没有归属的掉落包
-define(DROP_SERVER,    4).       %% 服最高伤害(没有保护时间的,只有跨服场景有效)
-define(DROP_HURT_SINGLE, 5).     %% 伤害最高获得(仅单人)
-define(DROP_CAMP,      6).       %% 阵营最高伤害
-define(DROP_ANY_HURT,  7).       %% 任意有伤害
-define(DROP_GUILD,     8).       %% 公会最高伤害

% 掉落方式
-define(DROP_TYPE_RAND,   0).     %% 随机权重掉落
-define(DROP_TYPE_FIXED,  1).     %% 固定掉落
-define(DROP_TYPE_TASK,   2).     %% 任务物品
-define(DROP_TYPE_GIFT_RAND, 3).  %% 礼包掉落

%% 收集方式
-define(DROP_WAY_NORAML, 0).      %% 普通掉落拾取
-define(DROP_WAY_BAG, 1).         %% 直接进背包
-define(DROP_WAY_BAG_SIMULATE, 2).%% 模拟掉落自动进背包(本服)

%% 掉落限制计算
-define(DROP_LIMIT_GOODID,    0). %% 单个物品ID玩家限制
-define(DROP_LIMIT_ID_SERVER, 1). %% 单个物品ID全服限制

% 掉落持续时间
-define(DROP_ALIVE_TIME,    180). %% 掉落包存活时间##掉落存活时间戳=掉落时间+?DROP_ALIVE_TIME
-define(DROP_SAVE_TIME,     90). %% 掉落包去保护时间##去保护时间戳=掉落存活时间戳-?DROP_SAVE_TIME
-define(DROP_PICK_SAVE_TIME,    200). %% 其他玩家采集中,保留200毫秒不去采集

%% 掉落拾取类型
%% 目的是为了检查掉落是否能拾取,防止自动拾取的情况下刚好切场景导致场景不一致无法获取掉落
-define(DROP_PICK_TYPE_NORMAL,  0).  %% 普通
-define(DROP_PICK_TYPE_AUTO,    1).  %% 自动拾取

-define(P_DROP_LIMIT_KEY(LimitType), lists:concat(["P_DROP_LIMIT_", LimitType])). %% 掉落限制统计数据的进程字典主键

%% 玩家数据
-record(drop_ratio, {
        ratio_id = 0            %% 概率id
        , count = 0             %% 次数
        , is_hit = 0            %% 是否命中
    }).

-define(sql_role_drop_ratio_select, <<"SELECT ratio_id, count, is_hit FROM role_drop_ratio WHERE role_id = ~p">>).
-define(sql_role_drop_ratio_replace_val, {role_drop_ratio, [role_id, ratio_id, count, is_hit]}).

%% 掉落规则
-record(ets_drop_rule, {
        mon_id=0,               %% 怪物编号
        alloc = 4,              %% 分配方式：1队长独占,2队伍随机,3队伍均等,4归属拾取
        min_lv = 0,             %% 最小等级 根据怪物等级在相应的等级区间取不同的掉落规则
        max_lv = 0,             %% 最大等级
        bltype = 0,             %% 归属类型：分配方式4：启作用。 0：伤害最高获得(单人/队伍) 1：第一击获得(单人/队伍) 2：最后一击获得(单人/队伍)
                                %%  3：无归属；配置“无归属”后所有玩家都可以拾取列表中的道具 4:服最高伤害 5:伤害最高获得(仅单人)
        task=0,                 %% 是否有任务物品，0为无，1为有
        broad=0,                %% 广播场景，0不广播，1队伍广播，2场景广播
        drop_list=[],           %% 掉落列表[1和2对应的所有掉落物品id]
        drop_rule=[],           %% 掉落规则1:1+2:1=250; 3:1=750 = [ {[{1,1}, {2, 1}], 250}, {[{3,1}], 750} ] %% 默认概率是1000：(权重和随机结合)
        drop_range={0,0}        %% 掉落范围 {x轴像素, y轴像素}; 注:{0,0}表示不做范围限制
    }).

%% 掉落几率类型
-define(DROP_RATIO_TYPE_NORMAL, 0).     % 普通
-define(DROP_RATIO_TYPE_ADD, 1).        % 额外附加

%% 物品掉落规则
%% 注意:不能随便修改默认值,php做了处理,默认值相同不会生成的.每次开新项目都要去检查
-record(ets_drop_goods, {
        id=0,                   %% 编号
        type = 0,               %% 类型:0随机权重掉落;1固定掉落;2任务物品
        drop_thing_type = 0,    %% 掉落物品类型(?TYPE_GOODS ?TYPE_COIN)
        list_id=0,              %% 列表ID
        goods_id=0,             %% 物品类型ID
        gift_id=0,              %% 怪物掉落礼包ID
        career=0,               %% 职业##归属包计算:玩家的职业以及职业等于0的情况[只有本服正常的掉落才可以用,额外掉落等等不计算]
        gift_weight_list=[],    %% 礼包的权重列表##php根据怪物掉落礼包ID获得,代码会修改
        goods_list=[],          %% 生成的物品列表
        ratio_type=0,           %% 机率类型
        ratio=0,                %% 机率
        ratio_id=0,             %% 机率规则id
        min_num=0,              %% 最低掉落数
        num=0,                  %% 最大数量
        get_way = 0,            %% 获得方式：0入背包，1放入拍卖行
        drop_way = 0,           %% 掉落方式：0普通，1直接进背包
        bind=0,                 %% 绑定状态
        vip_bind = 0,           %% vip绑定，玩家vip值小于本数值时，掉落道具设定为绑定
        notice=[],              %% 传闻，频道列表如[世界(1),家族(2)...]
        hour_start=0,           %% 时间段限制，0为无
        hour_end=0,             %% 时间段限制，0为无
        time_start=0,           %% 日期限制，0为无
        time_end=0,             %% 日期限制，0为无
        drop_icon = "",         %% 掉落在地上显示的图标
        drop_leff = "",         %% 掉落在地上显示的光效
        show_tips = 4           %% 掉落提示
    }).

%% 掉落上限
-record(base_drop_limit, {
        goods_id = 0,          %% 掉落物品id
        drop_thing_type = 0,   %% 掉落类型
        limit_type = 0,        %% 限制类型：0：玩家单个物品Id限制；1：全服单个物品Id限制
        limit_day = 0,         %% 掉落周期
        limit_num = 0          %% 限制数量品
    }).

%% 怪物类型活动动额外掉落
-record(base_mon_type_drop, {
        act_id = 0,             %% 活动主id
        sub_id = 0,             %% 主动子id
        mon_sys = 0,            %%　怪物系统类型
        % mon_type = 0,           %% 怪物类型
        % boss_type = 0,          %% boss类型
        slv = 0,                %% 开始等级
        elv = 0,                %% 结束等级
        drop_list=[],           %% 掉落列表[1和2对应的所有掉落物品id]
        drop_rule=[]            %% 掉落规则1:1+2:1=250; 3:1=750 = [ {[{1,1}, {2, 1}], 250}, {[{3,1}], 750} ] %% 默认概率是1000：(权重和随机结合)
    }).

%% 物品掉落生成表
-record(ets_drop, {
        id=0,                   %% 编号
        player_id=0,            %% 角色ID
        team_id=0,              %% 组队ID
        copy_id=0,              %% 副本ID
        scene=0,                %% 场景ID
        scene_pool_id=0,        %% 场景进程id
        drop_thing_type = 0,    %% 掉落物品类型(?TYPE_GOODS，?TYPE_COIN)
        drop_goods=[],          %% 掉落物品[[物品类型ID,物品类型,物品数量,物品品质]...]
        goods_id=0,             %% 掉落物品 - 物品类型ID
        min_num=0,              %% 最低数量
        num=0,                  %% 最大数量
        get_way = 0,            %% 获得方式：0入背包，1放入拍卖行
        drop_way = 0,           %% 掉落方式：0普通，1直接进背包
        bind=0,                 %% 绑定状态
        notice=[],              %% 传闻，频道列表如[世界(1),家族(2)...]
        broad=0,                %% 广播场景，0不广播，1队伍广播，2场景广播
        expire_time=0,          %% 过期时间
        mon_id = 0,             %% 怪物类型ID
        mon_name = <<>>,        %% BOSS怪物名字
        x = 0,                  %% 掉落坐标
        y = 0,
        drop_icon = "",         %% 掉落图标
        drop_leff = "",         %% 掉落光效 0:没有光效 >0:光效id
        hurt_list = [],         %% 玩家对这个掉落贡献##归属者的伤害
        any_hurt_list = [],     %% 所有玩家的伤害
        any_hurt_sum = 0,       %% 任意伤害的总和
        alloc = 0,              %% 分配方式(7:只有相同的玩家id才可以看到)
        bltype = 0              %% 归属类型
        , pick_time = 0         %%　拾取时长##毫秒
        , pick_player_id = 0    %% 正在拾取的玩家
        , pick_end_time = 0     %% 拾取结束时间(毫秒)##第一个玩家拾取的时间
        , drop_x = 0            %% 掉落中心点X##给客户端显示，玩家重连后,以这个中心点为准，做一个散落的特效
        , drop_y = 0            %% 掉落中心点Y
        , server_id = 0         %% 服唯一id
        , show_tips = 4         %% 掉落提示
        , camp_id = 0           %% 阵营id
        , guild_id = 0          %% 公会ID
    }).

%% 取掉落物品列表参数
-record(drop_args, {
        career = 0              %% 职业
        , drop_ratio_map = #{}  %% 掉落概率Map##参考 #player_status.drop_ratio_map
    }).

%%　玩家掉落信息
-record(drop_role, {
        id=0                    %% 玩家id
        , drop_id = 0           %% 掉落id
        , pick_end_time = 0     %% 拾取结束时间(毫秒)
    }).

%% 怪物参数
-record(mon_args, {
        id = 0,                 %% 怪物唯一id
        mid = 0,                %% 怪物配置id
        kind = 0,               %% 怪物类型
        boss = 0 ,              %% BOSS类型
        mon_sys = 0,            %% 怪物系统类型
        lv = 0,                 %% 等级
        scene = 0,              %% 场景
        scene_pool_id = 0,      %% 场景进程池id
        copy_id = 0,            %% copy_id
        x = 0,                  %% x坐标
        y = 0,                  %% y坐标
        d_x=0,                  %% 出生点X坐标
        d_y=0,                  %% 出生点Y坐标
        ctime = 0,              %% 怪物创建时间
        name = ""               %% 怪物名字
        , collect_times = 0     %% 已被采集次数
        , hurt_list     = []    %% 伤害列表
    }).

%% 玩家参数
-record(ps_args, {
        role_id = 0,
        name = "",
        lv = 0,
        vip = 0,
        vip_type = 0,           %% vip类型
        cell_num = [],          %% 背包格子列表[{背包位置, 空格子数}]
        scene = 0,
        pool_id = 0,
        copy_id = 0,
        x = 0,
        y = 0,
        hp = 0,
        team_id = 0
        % real_boss_tired = 0     %% 本服boss|神庙boss|跨服幻兽之域疲劳值
        , scene_boss_tired = undefined %% 疲劳记录
        %% eudemons_boss_tired = 0
        , server_id = 0
        , camp_id = 0
        , guild_id = 0
    }).


%% 额外掉落
-record(other_drop, {
        mon_id=0,               %% 怪物编号
        mon_lv = 0,             %% 最小等级 根据怪物等级在相应的等级区间取不同的掉落规则
        mon_max_lv = 0          %% 最大等级
        ,alloc_type  = 0        %% 1队长独占(弃用). 2 .队伍随机(弃用) 3.队伍均等 4.归属拾取 5.个人归属 6.参与奖
        ,belong_type = 0        %% 分配方式为个人归属时启用 归属类型 0：伤害最高获得 1：第一击获得 2：最后一击获得 3：无归属；
        ,role_lv     = 0        %% 玩家等级
        ,transmigration_lv = 0  %% 转生等级
        ,drop_reward = []       %% 掉落列表
    }).

% 掉落函数处理参数
-record(method_role_drop_args, {
        role_id = 0,
        role_lv = 0,
        team_id = 0,
        server_id = 0,
        career = 0,
        camp_id = 0,
        guild_id = 0,
        world_lv = 0,           %% 世界等级
        mod_level = 0,          %% 功能等级
        halo_privilege = []     %% 主角光环特权
}).

%% 掉落权重类型
% <br>0通用奖励:[{Type,GoodsType,Num},...]
% <br>1权重奖励:[{Weight, [{Type,GoodsType,Num}]},...],允许为空则无掉落
% <br>2两重权重奖励:[{Weight, [{Weight, [{Type,GoodsType,Num}]}],...],允许为空则无掉落
% <br>3天命觉醒权重奖励:[{ {MinCell(天命id),MaxCell}, [{Weight, [{Type,GoodsType,Num}]}] }],...],在{MinCell,MaxCell}范围内才会掉落
-define(DROP_REWARD_TYPE_COMMON, 0).    %% 通用奖励##[{Type,GoodsType,Num},...]
-define(DROP_REWARD_TYPE_WEIGHT, 1).    %% 权重奖励##[{Weight, [{Type,GoodsType,Num}]},...],允许为空则无掉落
-define(DROP_REWARD_TYPE_WEIGHT2, 2).   %% 权重奖励##[{Weight, [{Weight, [{Type,GoodsType,Num}]}],...],允许为空则无掉落
-define(DROP_REWARD_TYPE_AWAKENING, 3). %% 觉醒权重奖励##[{ {MinCell,MaxCell}, [{Weight, [{Type,GoodsType,Num}]}] }],...],

%% 任务掉落
-record(base_task_drop, {
        id = 0                  %% 编号id
        , mon_id = 0            %% 怪物id
        , alloc  = 0            %% 分配方式##参考掉落
        , bltype = 0            %% 归属类型##参考掉落
        , task_id_list = []     %% 任务id列表
        , reward_type = 0       %% 奖励类型
        , reward_list = []      %% 奖励列表
    }).

-define(TASK_FUNC_TYPE_ENCHANTMENT_GUARD_SWEEP, 1). % 主线副本扫荡
-define(TASK_FUNC_TYPE_ONHOOK, 2).  % 挂机
-define(TASK_FUNC_TYPE_AFK, 3).     % 挂机规则(新,不打怪)

%% 任务功能掉落
-record(base_task_func_drop, {
        type = 0                %% 类型
        , task_id = 0           %% 任务id
        , mon_lv = 0            %% 怪物等级
        , reward_type = 0       %% 奖励类型
        , reward_list = []      %% 奖励列表
    }).

%% 任务阶段功能掉落方式
-define(TASK_STAGE_DROP_WAY_NORMAL, 0). % 普通掉落(进入缓存等待领取)
-define(TASK_STAGE_DROP_WAY_BAG, 1).    % 直接进背包

%% 任务阶段功能掉落
-record(base_task_stage_func_drop, {
        type = 0                %% 类型
        , task_id = 0           %% 任务id
        , stage = 0             %% 阶段
        , scene_type = 0        %% 场景类型
        , mon_lv = 0            %% 怪物等级
        , condition = []        %% 额外条件
        , drop_way = 0          %% 掉落方式 - 任务阶段功能掉落方式
        , reward_type = 0       %% 奖励类型
        , reward_list = []      %% 奖励列表
    }).
