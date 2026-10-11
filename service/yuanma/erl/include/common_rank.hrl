%%%------------------------------------
%%% @Module  : common_rank.hrl
%%% @Author  : hejiahua
%%% @Created : 2015-12-18
%%% @Description: 通用榜单
%%%------------------------------------

%% --------------------#common_rank_role.rank_type 类型---------------------
 -define(RANK_TYPE_CAREER, 700).                 %% 职业排行榜
-define(RANK_TYPE_CAREER1, 701).
-define(RANK_TYPE_CAREER2, 702).


-define(RANK_TYPE_GUILD,            100).           %% 公会排行榜
%%%% 装备排行榜
%%-define(RANK_TYPE_EQUIPMENT_BAPTIZE, 501).      %% 洗炼
%%-define(RANK_TYPE_EQUIPMENT_STRENGTHEN, 502).   %% 强化
%%-define(RANK_TYPE_EQUIPMENT_INLAY, 503).        %% 镶嵌


-define(RANK_TYPE_COMBAT,           200).           %% 战力排行榜  
-define(RANK_TYPE_LV,               300).           %% 等级排行榜
-define(RANK_TYPE_JUEWEI,           400).           %% 爵位等级榜
-define(RANK_TYPE_JJC,              500).           %% 竞技场排名
-define(RANK_TYPE_MOUNT,            601).           %% 坐骑战力榜  
-define(RANK_TYPE_FLYPET,           602).           %% 飞骑战力榜  
-define(RANK_TYPE_WING,             603).           %% 翅膀战力榜  
-define(RANK_TYPE_MATE,             604).           %% 伙伴战力榜
-define(RANK_TYPE_SPIRIT,           605).           %% 精灵
-define(RANK_TYPE_AIRCRAFT,         606).           %% 神器战力榜
-define(RANK_TYPE_HOLYORGAN,        607).           %% 圣器战力榜
-define(RANK_TYPE_EQUIPMENT,        608).           %% 装备战力榜
-define(RANK_TYPE_TOWER_DUN,        609).           %% 爬塔关卡榜
-define(RANK_TYPE_AFK,              700).           %% 挂机收益排行榜

% -define(RANK_TYPE_PET_AIRCRAFT, 708).           %% 飞行器排行榜
% -define(RANK_TYPE_PET_WING,     701).
% -define(RANK_TYPE_TALISMAN,     702).           %% 法宝排行榜  
% -define(RANK_TYPE_FASHION,      703).           %% 时装排行榜
% -define(RANK_TYPE_BABY,         704).           %% 宝宝排行榜
% -define(RANK_TYPE_HOLY_GHOST,   705).           %% 圣灵排行榜
% -define(RANK_TYPE_HOME,         706).           %% 家园人气排行榜
% -define(RANK_TYPE_ACHIEVE,      707).           %% 成就排行榜
% -define(RANK_TYPE_CHARM,        800).           %% 魅力周榜（合并用）
 -define(RANK_TYPE_CHARM_BOY,    801).           %% 魅力周榜男
 -define(RANK_TYPE_CHARM_GIRL,   802).           %% 魅力周榜女


-define(RANK_TYPE_LIST,     [                   %% 个人榜单列表
         ?RANK_TYPE_COMBAT,
         ?RANK_TYPE_LV,
         ?RANK_TYPE_JUEWEI,
         ?RANK_TYPE_JJC,
         ?RANK_TYPE_MOUNT,
         ?RANK_TYPE_FLYPET,
         ?RANK_TYPE_WING,
         ?RANK_TYPE_MATE,
         ?RANK_TYPE_SPIRIT,
         ?RANK_TYPE_AIRCRAFT,
         ?RANK_TYPE_HOLYORGAN,
         ?RANK_TYPE_EQUIPMENT,
         ?RANK_TYPE_TOWER_DUN,
         ?RANK_TYPE_AFK
%%yyhx不需要的排行榜
         % ?RANK_TYPE_TALISMAN,
         % ?RANK_TYPE_FASHION,
         % ?RANK_TYPE_CHARM_BOY,
         % ?RANK_TYPE_CHARM_GIRL,
         % ?RANK_TYPE_BABY,
         % ?RANK_TYPE_PET_AIRCRAFT,
         % ?RANK_TYPE_HOLY_GHOST,
         % ?RANK_TYPE_PET_WING
        % ?RANK_TYPE_ACHIEVE
]).

-define(RANK_TYPE_ADVANCED,     [               %% 进阶页面下的榜单
         ?RANK_TYPE_MOUNT,            
         ?RANK_TYPE_FLYPET,           
         ?RANK_TYPE_WING,             
         ?RANK_TYPE_MATE,             
         ?RANK_TYPE_SPIRIT,          
         ?RANK_TYPE_AIRCRAFT,         
         ?RANK_TYPE_HOLYORGAN        
         % ?RANK_TYPE_TALISMAN,
         % ?RANK_TYPE_FASHION,
         % ?RANK_TYPE_BABY,
         % ?RANK_TYPE_PET_AIRCRAFT,
         % ?RANK_TYPE_HOLY_GHOST,
         % ?RANK_TYPE_PET_WING

]).

-define(RANK_TYPE_CAREER_LIST, [
        ?RANK_TYPE_CAREER1,
        ?RANK_TYPE_CAREER2
    ]).

%%-define(RANK_TYPE_EQUIPMENT_LIST, [
%%        ?RANK_TYPE_EQUIPMENT_BAPTIZE,
%%        ?RANK_TYPE_EQUIPMENT_STRENGTHEN,
%%        ?RANK_TYPE_EQUIPMENT_INLAY
%%    ]).

% -define(RANK_TYPE_CHARM_WEEK,     [
%     ?RANK_TYPE_CHARM_BOY,
%     ?RANK_TYPE_CHARM_GIRL
% ]).

%% 助力礼包排名对比
-define(RANK_POWER_GIFT_LIST, [?RANK_TYPE_COMBAT, ?RANK_TYPE_LV]).

-define(LOGIN_TIME_RANK_TYPE_LIST, [?RANK_TYPE_LV]).

-define(sanctuary_guild_rank_len, 20).  %%圣域公会排行榜长度
-define(sanctuary_guild_rank_result_len, 3). %%圣域公会排行榜，结算长度，即前三名

-define (MAX_PRAISE_NUM,   3).

%% 助力礼包开启状态
-define(RANK_GIFT_OPEN, true).

%% 排行榜配置
-record(rank_config, {
            type = 0,
            rank_name = "",
            rank_max = 0,
            rank_limit = 0,
            sortid = 0,      
            show = 1,
            title_id = 0
    }).

-record(worship_award_cfg,{
        id = 0,      %%编号
        times = 0,   %% 膜拜次数
        award = [],  %%格式[{Type,GoodsTypeId,Num}]
        about = ""   %%说明
    }).

-record(base_charm_week_reward, {
    id = 0,
    rank_min = 0,
    rank_max = 0,
    reward = [],
    fame_reward = []
}).

-record(base_home_rank_reward, {
    id = 0,
    rank_min = 0,
    rank_max = 0,
    reward = []
}).

%% 等级助力礼包配置
-record(base_rank_reward_lv, {
    day_down = 0,
    day_up = 0,
    lv_down = 0,
    lv_up = 0,
    reward_pool = []
}).

%% 战力助力礼包配置
-record(base_rank_reward_combat, {
    day_down = 0,       % 开服天数限制
    day_up = 0,         % 开服天数限制 {day_down， day_up} 组成主键
    base_value1 = 0,    % 高战玩家战力基准
    cal_percent1 = 0,   % 高战玩家战力百分比
    base_value2 = 0,    % 活跃玩家战力基准
    cal_percent2 = 0,   % 活跃玩家战力百分比
    reward_pool1 = [],  % 高战玩家奖池
    reward_pool2 = [],  % 活跃玩家奖池
    reward_pool3 = []   % 屌丝玩家奖池
}).

%% 通用榜单的角色信息
%% 注意:需要排序的话,使用value、second_value、third_value,不要用其他字段
-record(common_rank_role, {
        role_key        = undefined,    % 玩家的唯一键 {RankType, id}
        rank_type       = 0,            % 榜单类型
        role_id         = 0,            % 角色Id
        value           = 0,            % 值
        second_value    = 0,            % 值（保留）
        third_value     = 0,            % 值（保留）
        display_value   = 0,            % 客户端显示值
        time            = 0,            % 时间
        rank            = 0             % 名次
    }).

-record(common_rank_guild, {
        guild_key       = undefine,     % 唯一键{RankType, guild_id}
        rank_type       = 0,            % 榜单类型
        guild_id        = 0,            % 公会id
        guild_name      = "",           % 公会名称
        chairman_id     = 0,            % 会长Id
        chairman_name   = "",           % 会长名字
        lv              = 0,            % 公会等级
        members_num     = 0,            % 成员数量
        value           = 0,            % 值
        second_value    = 0,            % 值（保留）
        third_value     = 0,            % 值（保留）
        time            = 0,            % 时间
        rank            = 0             % 名次
    }).

-record(common_rank_home, {
    home_key        = undefined,    % 唯一键{BlockId, HouseId}
    block_id        = 0,
    house_id        = 0,
    rank_type       = 0,            % 榜单类型
    role_id_1       = 0,            % 玩家Id 1
    role_id_2       = 0,            % 玩家Id 2
    lock            = 0,            % 上锁标志
    value           = 0,            % 值
    second_value    = 0,            % 值（保留）
    third_value     = 0,            % 值（保留）
    time            = 0,            % 时间
    rank            = 0             % 名次
}).


%% 通用榜单的进程状态
-record(common_rank_state, {
        value_maps = maps:new(),        %
        role_maps = maps:new(),         % Key:RankType Value:[#common_rank_role{}|...]
        guild_maps = maps:new(),
        home_value_maps = maps:new(),   % 家园全值
        home_rank_maps = maps:new(),   % 家园榜上值
        old_first_guild = 0,             % 存昨天第一的公会id
        rank_limit = maps:new(),
        praise_maps = maps:new(),       % key: role_id  value: praise_num
        first_rank_list = [],           % 保存三天指定排行榜第一名的玩家数据 [[{RankType, #common_rank_role{}}|_] | _ ]
        last_login_time_map = #{}       % 榜单最后的登出时间，目前只保存等级榜单 #{{RankType, RoleId} => Time}
    }).

-define(sql_common_rank_guild_select,  <<"
    SELECT
        rank_type, guild_id, guild_name, chairman_id, chairman_name, lv, members_num,
        value, second_value, third_value, time
    FROM common_rank_guild">>).

-define(sql_common_rank_role_select, <<"
    SELECT
        rank_type, player_id, value, second_value, third_value, time
    FROM common_rank_role">>).

-define(sql_common_rank_praise_select, <<"
    SELECT
        role_id, praise_num
    FROM common_rank_praise">>).

-define(sql_common_rank_home_select, <<"
    SELECT
        rank_type, block_id, house_id, role_id_1, role_id_2, is_lock, value, second_value, third_value, time
    FROM common_rank_home">>).

-define(sql_common_rank_role_save, <<"
    replace into common_rank_role(
        rank_type, player_id, value, second_value, third_value, time
    ) values(~p, ~p, ~p, ~p, ~p, ~p)">>).

-define(sql_common_rank_home_save, <<"
    replace into common_rank_home(
        rank_type, block_id, house_id, role_id_1, role_id_2, is_lock, value, second_value, third_value, time
    ) values(~p, ~p, ~p, ~p, ~p, ~p, ~p, ~p, ~p, ~p)">>).

-define(sql_common_rank_praise_save, <<"
    replace into common_rank_praise(
        role_id, praise_num
    ) values(~p, ~p)">>).

-define(sql_common_rank_guild_save, <<"
    replace into common_rank_guild(
        rank_type, guild_id, guild_name, chairman_id,
        chairman_name, lv,  members_num, value, second_value,  third_value, time
    ) values(~p, ~p , '~s', ~p, '~s', ~p, ~p, ~p, ~p, ~p, ~p)">>).

-define(sql_common_rank_role_delete_by_role_id, <<"delete from common_rank_role
                    where rank_type = ~p and player_id = ~p">>).

-define(sql_common_rank_guild_delete_by_guild_id, <<"delete from common_rank_guild
                    where rank_type = ~p and guild_id = ~p">>).
-define(sql_common_rank_home_delete, <<"delete from common_rank_home
                    where rank_type = ~p and block_id = ~p and house_id = ~p">>).

-define(sql_common_rank_role_delete_by_value, <<"delete from common_rank_role
                    where rank_type = ~p and value < ~p ">>).

-define(sql_common_rank_guild_delete_by_value, <<"delete from common_rank_guild
                    where rank_type = ~p and value < ~p ">>).

-define(sql_common_rank_role_delete_by_rank_type, <<"delete from common_rank_role
                    where rank_type in(~p, ~p)">>).

-define(sql_common_rank_home_delete_by_rank_type, <<"delete from common_rank_home
                    where rank_type = ~p">>).