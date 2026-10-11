%%-----------------------------------------------------------------------------
%% @Module  :       mount.hrl
%% @Author  :       Czc
%% @Email   :       389853407@qq.com
%% @Created :       2017-10-9
%% @Description:    坐骑类（坐骑、伙伴、翅膀）
%%-----------------------------------------------------------------------------

%% 模块160, 定义子模块(1000以下)作为培养类型,要一一对应
-define(MOUNT_ID, 1).                               %% 坐骑类型
-define(MATE_ID, 2).                                %% 精灵类型
-define(FLY_ID, 3).                                 %% 翅膀类型
-define(ARTIFACT_ID, 4).                            %% 圣器
-define(HOLYORGAN_ID, 5).                           %% 神兵
-define(SPIRIT_ID, 6).                              %% 精灵类型
-define(PET_ID, 7).                                 %% 飞骑
-define(ZHENFA_ID, 8).                              %% 阵法类型
-define(BACK_DECORATION, 9).                        %% 背饰类型
-define(COMPANION_ID, 10).                          %% 伙伴（新）类型
-define(TEMPLE_AWAKEN_ID, 11).                      %% 神殿觉醒衣服类型
-define(NEW_BACK_DECORATION, 12).                   %% 新版背饰系统（与9类型的区别在于，新版本的与翅膀是相互兼容不互斥）

-define(NEW_MOUNT_OPEN_LV, 10).                     %% 外形的装备开放等级
-define(TENTHOU ,10000).                            %%全身加成万分比
%% 升阶配置
-define(STAGE_CONFIG, [?MOUNT_ID, ?MATE_ID]).
%% 升星配置
-define(STAR_CONFIG, [?ARTIFACT_ID, ?HOLYORGAN_ID, ?SPIRIT_ID, ?FLY_ID, ?ZHENFA_ID, ?NEW_BACK_DECORATION]).
% 所有的外形类型
% -define(LV_ACTIVE_APPERENCE, [?ARTIFACT_ID, ?SPIRIT_ID, ?PET_ID, ?ZHENFA_ID]). %% 升级自动获得
-define(LV_ACTIVE_APPERENCE, data_mount:get_constant_cfg(21)). %% 升级自动获得
-define(APPERENCE, data_mount:get_constant_cfg(20)).
% -define(APPERENCE, [?MOUNT_ID, ?MATE_ID, ?FLY_ID, ?ARTIFACT_ID, ?HOLYORGAN_ID, ?SPIRIT_ID, ?PET_ID, ?ZHENFA_ID]).
-define(FIGURE_EQUIP, [?MOUNT_ID, ?MATE_ID]). % 外形的装备

-define(NOT_RIDE_STATUS, 0).                        %% 非骑乘状态
-define(RIDE_STATUS, 1).                            %% 骑乘状态

-define(SEL_FIGURE, 1).                             %% 幻化操作
-define(CHANGE_RIDE_STATUS, 2).                     %% 骑乘操作

-define(MIN_STAGE, 1).                              %% 外形类最低阶数
-define(MIN_STAR, 1).                               %% 外形类最低星数

-define(ILLUSION_MIN_STAGE , 1).                    %% 幻型最低阶数
-define(ILLUSION_MIN_STAR , 0).                     %% 幻型最低级数

-define(MOUNT_BASE_SKILL, 1).                       %% 外形类基础技能
-define(MOUNT_ILLUSION_SKILL, 2).                   %% 外形类幻形技能
%%-define(MOUNT_ACTIVE_SKILL, 3).                     %% 外形类主动技能
-define(MOUNT_UPGRADE_SYS_SKILL, 4).                %% 升级养成线得到技能

-define(BASE_MOUNT_FIGURE, 1).                      %% 基础形象
-define(ILLUSION_MOUNT_FIGURE, 2).                  %% 幻形激活的形象

-define(INIT_EQUIP_POS_LV,  0).                     %% 初始装备的等级
-define(INIT_EQUIP_STAGE , 1).                      %% 初始装备的阶数
-define(INIT_EQUIP_STAR , 1).                       %% 初始装备的星数

-define(INIT_DEVOUR_LV , 0).                        %% 初始吞噬等级
-define(INIT_DEVOUR_EXP , 0).                       %% 初始吞噬经验

-define(CLEAR_BLESSING_TIME, 24 * 60 * 60 ).     %% 祝福值清空时间（24h）
-define(AUTOBUY, 1).                                %% 自动购买
-define(NOAUTOBUY, 0).                              %% 非自动购买
-define(MAX_GOODS_EXP, 999999).                     %% 最大经验值，用于自动购买时候对比
-define(UPGRADE_PRECENT, 0.02).                     %% 每次升级百分比进度

-define(EXPGOODS_TYPE_NORMAL,  1).                  %% 普通经验材料
-define(EXPGOODS_TYPE_SELF,    2).                  %% 专有道具卡
-define(EXPGOODS_TYPE_SPECIAL, 3).                  %% 稀有道具卡
-define(EXPGOODS_TYPE_UPGRADE, 4).                  %% 升级系统的经验材料

%% 坐骑类星级配置
-record(mount_star_cfg, {       % base_mount_star
    type_id = 0,                % 外形类型id
    stage = 0,                  % 阶数
    star = 0,                   % 星数
    max_blessing = 0,           % 升星所需祝福值
    attr = [],                  % 属性
    clear_status = 0,           % 是否触发清空机制
    combat = 0}).               % 战力

%% 坐骑类培养道具配置
-record(mount_goods_cfg, {      % base_mount_goods
    type_id = 0,                % 外形类型id
    goods_id = 0,               % 物品id
    attr = [],                  % 属性
    combat = 0,                 % 战力
    max_times = 0,              % 最大次数
    add =0                      % 坐骑属性的加成（基础+ 技能 + 魔晶）
}).

%% 坐骑类技能配置
-record(mount_skill_cfg, {      %% base_mount_skill
    type_id = 0,                % 外形类型id
    skill_id = 0,               %% 技能id
    type = 0,                   %% 1: 基础技能 2: 幻形技能 3：主动技能
    ownership_id = 0,           %% 归属id 幻形技能填所属的幻形id
    stage = 0                   %% 解锁阶段
}).

%% 坐骑类阶数配置
-record(mount_stage_cfg, {   % base_mount_stage
    type_id = 0,             % 外形类型id
    stage = 0,               % 阶数
    career = 0,              % 职业
    name = "",               % 名字
    figure = 0,              % 形象id
    ride_figure = 0,         % 骑乘形象
    ride_attr = [],          % 骑乘属性
    max_star = 0,            % 总星数
    is_tv = 0               % 进阶传闻
}).


%% 坐骑类幻形形象配置
-record(mount_figure_cfg, {     %% base_mount_figure
    type_id = 0,                %% 外形类型id
    id = 0,                     %% 幻形id
    career = 0,                 %% 职业
    name = "",                  %% 名字
    desc = "",                  %% 描述
    figure = 0,                 %% 非骑乘形象资源id
    ride_figure = 0,            %% 骑乘形象资源id
    goods_id = 0,               %% 激活物品id
    goods_num = 0,              %% 激活物品数量
    goods_exp = 0,              %% 激活道具做培养材料时候提供的经验值
    stage_lim = 0,              %% 阶数限制 需要坐骑达到多少阶才能培养
    skill_list = [],            %% 拥有的技能列表
    is_tv = 0  ,                %% 激活传闻
    condition_list = [],        %% 激活条件
    time = 0   ,                %% 有效时间
    add_exp = 0                 %% 吞噬经验
    ,exp_goods = []             %% 升级所需经验道具id列表
}).

%% 坐骑类幻形等阶配置
-record(mount_figure_stage_cfg, {   % base_mount_figure_stage
    type_id = 0,                    % 外形类型id
    id = 0,                         % 幻形id
    stage = 0,                      % 等阶
    cost = [],                      % 物品消耗
    attr = [],                      % 当前阶属性
    combat = 0,                     % 战力
    max_blessing = 0,               % 升星所需祝福值
    add = []                        % 某属性的加成系数 [{AttrId, Num}]
}).

%% 坐骑类经验道具
-record(mount_prop_cfg, {  % base_mount_prop
    type_id = 0,           % 外形类型id
    goods_id = 0,          % 物品ID
    type = 0,              % 道具类型 1普通 2专有 3稀有
    exp = 0,               % 经验值
    ratio = []             % 权重[{倍数，权重}]
}).

%% 外形的特殊物品
-record(mount_sp_goods_cfg,{   % base_mount_sp_goods
    type_id = 0,           % 外形类型id
    goods_id = 0,          % 物品ID
    use_condition =  0,    % 最大可使用 阶数/星数
    add_star = 0,          % 增加阶数/星数
    add_exp = 0            % 增加经验值
}).

%% 外形吞噬配置表
-record(mount_devour_cfg,{   % base_mount_devour
    type_id = 0,             % 外形类型id
    pos_id = 0,              % 外形id
    pos_lv = 0,              % 部位等级
    exp = 0 ,                % 吞噬经验
    attr_add_list = []       % 属性加成百分比列表
}).

%% 形象物品吞噬配置
-record(mount_devour_exp_cfg,{ % base_mount_devour_exp
    goods_id = 0,              % 外形物品id
    add_exp = 0                % 吞噬经验
}).

%% 幻饰等级配置
-record(mount_figure_star_cfg, {    % base_mount_figure_star
    type_id = 0,                    % 外形类型id
    id = 0,                         % 幻形id
    star = 0,                       % 等级
    cost = [],                      % 物品消耗
    attr = []                       % 当前阶属性
}).


-record(base_mount_color_up, {
    type_id = 0,            % 类型id
    figure_id = 0,          % 幻型id
    color_id = 0,           % 染色id
    color_lv = 0,           % 染色等级
    attr = [],              % 属性
    sp_attr = [],           % 额外属性
    cost = []               % 消耗
}).

%% 外形装备
-record(figure_equip, {
    role_id = 0,
    equip_attr = []
}).


-record(status_mount, {
    type_id = 0,                %% 类型id
    stage = 0,                  %% 坐骑阶数
    star = 0,                   %% 坐骑星级
    blessing = 0,               %% 祝福值/经验
    illusion_type = 0,          %% 幻化类型
    illusion_id = 0,            %% 幻形id
    illusion_color = 0,         %% 幻形颜色id
    figure_id = 0,              %% 当前使用的形象id
    etime = 0,                  %% 清空祝福值时间
    auto_buy = 0,               %% 强化时是否自动购买
    figure_list = [],           %% 已激活的幻形形象列表[#mount_figure{}]
    base_attr = [],             %% 魔晶属性(消耗魔晶使用培养道具增加的属性)
%%    crystal = 0 ,               %% 消耗的魔晶数量
    attr = [],                  %% 总的加成属性
    ride_attr = [],             %% 骑乘属性
    figure_attr = [],           %% 幻形属性(等阶属性+技能属性+ 加成)
    figure_star_attr = [],      %% 幻形等阶属性（仅仅在天赋技能计算时使用，属于figure_attr一部分，不用再汇总
    special_attr = #{},         %% 特殊属性
    skills = [],                %% 坐骑解锁的技能
    figure_skills = [],         %% 幻形解锁的技能

    passive_skills = [],        %% 被动技能
    combat = 0,                 %% 坐骑战力(基础属性战力+星阶战力+等级战力+新培养线升级战力)
    is_ride = 1 ,               %% 0: 非骑乘状态 1: 骑乘状态
    devour_lv = 0,              %% 吞噬等级
    devour_exp = 0,             %% 吞噬经验
    figure_equip = #figure_equip{},  %% 外形装备
    ref = undefined,            %% 清空祝福值定时器（坐骑和伙伴才有）
    upgrade_sys_level = 0,      %% 升级养成线的等级
    upgrade_sys_exp = 0,        %% 升级养成线的经验值
    upgrade_sys_skill = []      %% 升级养成线的技能列表[{skillId, SkillLevel}]
}).



-record(figure_equip_pos, {
    pos = 0,
    equip_point = 0
}).

-record(mount_figure, {
    type_id = 0,                %% 类型id
    id = 0,                     %% 幻化形象id
    stage = 0,                  %% 幻化形象阶数
    star = 0,                   %% 幻化星数
    blessing = 0,               %% 祝福值
    attr = [],                  %% 属性
    star_attr = [],             %% 等阶属性（属于attr的子集
    skills = [],                %% 解锁技能
    combat = 0,                 %% 战力
    end_time = 0                %% 形象结束时间
    ,color_list = []            %% 染色进度[{color_id, color_lv}]
}).

-record(mount_equip, {
    type_id = 0,                %% 类型id
    pos_attr = [],               %% [{Pos, 属性列表}]
    total_attr = [],
    skills = [],
    passive_skills = [],
    skill_combat = 0
}).




%% ------------------------------------------------------


-define(sql_player_all_figure_select,
    <<"select type_id, illusion_type, illusion_id, illusion_color from player_mount where role_id = ~p">>).


-define(sql_player_mount_select,
    <<"select type_id, stage, star, blessing, base_attr, illusion_type, illusion_id, illusion_color, is_ride, figure_id, etime, auto_buy from player_mount where role_id = ~p">>).

-define (sql_player_mount_clear_bless,
    <<"update player_mount set etime = 0, blessing = 0 where role_id = ~p and type_id = ~p">>).

-define(sql_player_mount_change_auto_buy, 
    <<"update player_mount set auto_buy = ~p where role_id = ~p and type_id = ~p">>).

-define(sql_player_mount_illusion_id_select,
    <<"select id, illusion_id from player_mount where role_id = ~p">>).

-define(sql_player_mount_figure_select,
    <<"select id, stage, star, blessing, end_time from player_mount_figure where role_id = ~p and type_id = ~p">>).

-define(sql_player_mount_insert,
    <<"insert into player_mount(role_id, type_id, stage, star, illusion_type, illusion_id, illusion_color, is_ride) values(~p, ~p, ~p, ~p, ~p, ~p, ~p, ~p)">>).

-define(sql_player_mount_replace,
    <<"replace into player_mount(role_id, type_id, stage, star, illusion_type, illusion_id, is_ride) values(~p, ~p, ~p, ~p, ~p, ~p, ~p)">>).

-define(sql_update_mount_illusion,
    <<"update player_mount set illusion_type = ~p, illusion_id = ~p, illusion_color = ~p, figure_id = ~p where role_id = ~p and type_id = ~p">>).

%%-define(sql_update_mount_ride_status,
%%    <<"update player_mount set is_ride = ~p where role_id = ~p and type_id = ~p">>).

-define(sql_update_mount_base_attr,
    <<"update player_mount set base_attr = '~s' where role_id = ~p and type_id = ~p">>).

-define(sql_update_mount_fashion_figure,
    <<"update player_mount set figure_id = ~p where role_id = ~p and type_id = ~p">>).

-define(sql_update_mount_stage_and_star,
    <<"update player_mount set stage = ~p, star = ~p, blessing = ~p, illusion_id = ~p, illusion_color = ~p where role_id = ~p and type_id = ~p">>).

-define(sql_update_mount_stage_and_star_and_etime,
    <<"update player_mount set stage = ~p, star = ~p, blessing = ~p, illusion_id = ~p, illusion_color = ~p, etime = ~p  where role_id = ~p and type_id = ~p">>).

-define(sql_delete_player_mount,
    <<"delete from player_mount where role_id = ~p">>).

-define(sql_update_mount_illusion_info,
    <<"replace into player_mount_figure(role_id, type_id, id, stage, star, blessing, end_time) values(~p, ~p, ~p, ~p, ~p, ~p, ~p)">>).

-define(sql_delete_mount_illusion_info,
    <<"delete from player_mount_figure where role_id = ~p and type_id = ~p and id = ~p ">>).

%%  选取外形装备位置
-define(sql_figure_equip_pos_select,
    <<"SELECT `role_id`, `pos`, `figure_equip_point` FROM `figure_equip_pos` WHERE `role_id` = ~p and type_id = ~p">>).
%%  替换外形装备位置
-define(sql_figure_equip_pos_replace,
    <<"REPLACE INTO `figure_equip_pos`(`role_id`, `type_id`, `pos`, `figure_equip_point`) VALUES (~p, ~p, ~p, ~p)">>).


%%  选取外形吞噬
-define(sql_mount_devour_select,
    <<"SELECT `role_id`, `type_id`, `dev_lv`, `dev_exp` FROM `player_mount_devour` WHERE `role_id` = ~p and type_id = ~p">>).

%%  选取外形吞噬
-define(sql_mount_devour_all_select,
    <<"SELECT  `type_id`, `dev_lv`, `dev_exp` FROM `player_mount_devour` WHERE `role_id` = ~p">>).

%%  替换外形吞噬
-define(sql_mount_devour_replace,
    <<"REPLACE INTO `player_mount_devour`(`role_id`, `type_id`, `dev_lv`, `dev_exp`) VALUES (~p, ~p, ~p, ~p)">>).

-define(sql_player_mount_color_select,
    <<"SELECT `color_id`, `color_lv` from `player_mount_color` where `role_id` = ~p and `type_id` = ~p and `figure_id` = ~p">>).

-define(sql_player_mount_color_replace, 
    <<"REPLACE INTO `player_mount_color`(`role_id`, `type_id`, `figure_id`, `color_id`, `color_lv`) VALUES (~p, ~p, ~p, ~p, ~p)">>).

%% =================== 外形升级系统 =============================

%% 选取玩家有外形升级系统的数据
-define(SQL_SELECT_ALL_PLAYER_MOUNT_LEVEL,
    <<"SELECT  `type_id`, `dev_lv`, `dev_exp`, `skill`  FROM `player_mount_level` WHERE `role_id` = ~p">>).

%% 更新外形升级系统数据
-define(SQL_UPDATE_MOUNT_UPGRADE_DATA,
    <<"REPLACE INTO `player_mount_level`(`role_id`,`type_id`, `dev_lv`, `dev_exp`, `skill`)VALUES(~p,~p,~p,~p,'~s')">>).

-define(SQL_UPDATE_MOUNT_UPGRADE_SKILL_DATA,
    <<"update player_mount_level set skill = ~p where role_id = ~p and type_id = ~p">>).

%% REPLACE INTO `player_mount_levell`(`role_id`, `type_id`, `dev_lv`, `dev_exp`, `skill`) VALUES (1, 1, 1, 1, 1)

-define(INIT_UPGRADE_LV, 1).                        %% 初始升级系统等级
-define(INIT_UPGRADE_EXP, 0).                       %% 初始升级系统经验
-define(INIT_SKILL_LEVEL, 1).                       %% 自动激活技能时默认的技能等级

%% 外形升级系统配置
-record(base_mount_level_info, {
    type_id = 0,
    level = 0,
    need_exp = 0,
    attr = [],
    combat = 0,
    is_clear = 0
}).

%%%% 坐骑装备 配置
-record(base_mount_equip, {
    id = 0,                     %% 物品id
    pos = 0,                    %% 1:坐鞍 2:缰绳 3:脚蹬 4:护甲 5:项圈 6:头盔
    quality = 0,                %% 1:绿 2:蓝 3:紫 4:橙 5:红 6:粉
    stage_limit = 0,            %% 阶级限制
    skill_id = 0,               %% 技能Id
    gen_weight = 0,             %% 生成激活技能概率/万分比
    com_weight = []             %% 合成激活技能概率/万分比 [{参与合成装备携带技能数, 概率}]
}).

%%%% 坐骑装备 锻造等级属性配置
-record(base_mount_equip_attr, {
    pos = 0,                    %% 1:坐鞍 2:缰绳 3:脚蹬 4:护甲 5:项圈 6:头盔
    stage = 0,                  %% 阶数
    lv = 0,                     %% 锻造等级
    exp = 0,                    %% 升到此级需要经验值
    attr = []                   %% 当阶级属性
}).

%%%% 坐骑装备 升阶配置
-record(base_mount_equip_stage, {
    stage = 0,                  %% 阶数
    cost = [],                  %% 消耗
    percent = 0                 %% 属性百分比加成
}).
%%
%%%% 坐骑装备 铭刻配置
-record(base_mount_equip_engrave, {
    quality = 0,                %% 品质
    good_id = 0,                %% 铭刻石Id
    num = 0,                    %% 消耗数量
    prob = 0                    %% 激活概率
}).
%%-------------------------------------------------------
















