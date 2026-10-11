%%%------------------------------------
%%% @Module  : race_act
%%% @Author  : zengzy
%%% @Created : 2017-12-20
%%% @Description: 竞榜的活动
%%%------------------------------------

%% ---------------------------------------------------------------------------
%% 类型定义
%% ---------------------------------------------------------------------------

-define(RACE_ACT_MOUNT,         1).     %% 坐骑竞榜
-define(RACE_ACT_MATE,          2).     %% 伙伴竞榜
-define(RACE_ACT_SUIT,          3).     %% 套装竞榜
-define(RACE_ACT_BABY,          4).     %% 宝宝竞榜
-define(RACE_ACT_HOLYORGAN,     5).     %% 圣器竞榜(yyhx:神兵)
-define(RACE_ACT_DRAGON,        6).     %% 龙纹竞榜   
-define(RACE_ACT_HOLYJUDGE,     7).     %% 圣裁竞榜   
-define(RACE_ACT_ARTIFACT,      8).     %% 神器竞榜(yyhx:圣器)
-define(RACE_ACT_GOD,           9).     %% 式神竞榜
-define(RACE_ACT_FLY,           10).    %% 翅膀竞榜
-define(RACE_ACT_DEMONS,        11).    %% 使魔竞榜
-define(RACE_ACT_BACK_DECROTEION,   12).%% 背饰竞榜

%% 备用:可以直接替换,运营最近都在线热配置
-define(RACE_ACT_BACKUP2,       13).    %% 备用竞榜2
-define(RACE_ACT_BACKUP3,       14).    %% 备用竞榜3


% -define(RACE_ACT_TCRANE, 1).       %% 活动1:圣翼幻化竞榜
% -define(RACE_ACT_WISH,   2).     %% 活动2:许愿池
% -define(RACE_ACT_HERO,   3).     %% 活动3:英灵
% -define(RACE_ACT_DONATION,   4).   %% 活动4:贡献榜单活动
% -define(RACE_ACT_FASHION,   5).    %% 活动5:时装冲榜
% -define(RACE_ACT_DRAGON,    6).    %% 活动6:龙纹竞榜
% -define(RACE_ACT_THORSE,    7).    %% 活动7:坐骑竞榜
% -define(RACE_ACT_TWEAPON,   8).      %% 活动8:武器竞榜
% -define(RACE_ACT_GOD,   9).          %% 活动9:式神竞榜

%% 需要展示的活动类型
-define(SHOW_LIST,  [
        % ?RACE_ACT_MOUNT
        % , ?RACE_ACT_MATE
        % , ?RACE_ACT_SUIT
        % , ?RACE_ACT_BABY
        % , ?RACE_ACT_HOLYORGAN
        % , ?RACE_ACT_DRAGON
        % , ?RACE_ACT_HOLYJUDGE
        % , ?RACE_ACT_ARTIFACT
        % , ?RACE_ACT_GOD
        % , ?RACE_ACT_FLY
        % , ?RACE_ACT_BACKUP1
        % , ?RACE_ACT_BACKUP2
        % , ?RACE_ACT_BACKUP3
]).

% -define(RECHARGE_EXCHANGE, [{?RACE_ACT_WISH,1},{?RACE_ACT_WISH,2},{?RACE_ACT_WISH,3},{?RACE_ACT_WISH,4}]).  %% 充值兑换的活动类型,格式{主类型,次类型}
-define(RECHARGE_EXCHANGE,  []).        %% 充值兑换的活动类型
-define(NSHOW_TIPS_LIST,    []).        %% 需要转动，不推送频道消息类型

-define(GOLD_ACT,        1).            %%钻石奖池##[{Type, GoodsTypeId, Num},...]
-define(SCORE_ACT,       2).            %%积分奖池

-define(ETS_RACE_ACT,   ets_race_act).  %%ets表

-define(RACE_ACT_FORMAT_NORMAL, 0).     %% 普通奖励##[{Type, GoodsTypeId, Num},...]
-define(RACE_ACT_FORMAT_WORLD_LV, 1).   %% 世界等级##[{LimLv, 奖励列表}]

% <br> 0:普通奖励##[{Type, GoodsTypeId, Num},...]
% <br> 1:世界等级##[{LimLv, 奖励列表}]

% 奖励参数
-record(race_act_reward_param, {
        world_lv = 0
}).

%% ---------------------------------------------------------------------------
%% 其他定义
%% ---------------------------------------------------------------------------
-define(OPEN,         1).          %% 开启
-define(CLOSE,        0).          %% 关闭
-define(ONE_TREASURE, 1).          %% 单抽
-define(TEN_TREASURE, 10).         %% 10抽
-define(ZERO_CLEAR,   1).          %% 凌晨清
-define(ACT_CLEAR,    2).          %% 活动清

%% ets结构(记录已开启的活动)
-record(ets_race_act, {
        type = 0,
        subtype = 0,
        world_lv = 0               %% 世界等级##等于0意味着没有初始化
}).

%% 竞榜活动的结构
-record(race_act, {
        data_list = []                      %% 活动需要统计保存的数据[#race_act_data{}]
}).

%% 数据记录
-record(race_act_data,{
        id = {0, 0},                    %% {主类型,次类型}
        type = 0,                       %% 主类型
        subtype = 0,                    %% 次类型
        score = 0,                      %% 积分
        today_score = 0,                %% 今日积分
        times = 0,                      %% 累积次数
        reward_list = [],               %% 已获奖励:奖励id
        score_reward = [],              %% 已领取积分奖励id
        other = [],                     %% 其他数据：根据各活动（现有：#race_wish{}）
        last_time = 0                   %% 最后抽奖时间
}).

%% 许愿记录（重置）
-record(race_wish,{
        times = 0,          % 已用秘钥次数
        e_times = 0,        % 今日已兑换次数
        key = 0,            % 剩余秘钥
        left_pay = 0,       % 今日兑换剩余重置量
        reward_list = []    % 已获奖励:奖励id
}).

%% 进程记录
-record(rank_status,{
        all_act = [],               %% 所有配置活动
        opening_act = [],           %% 开启中的活动 [#base_race_act_info{}]
        zone_list = [],             %% 区域列表 [#race_act_zone{}]
        show_act = [],              %% 展示中的活动
        start_timer = 0,            %% 定时关闭活动的定时器
        end_timer = 0,              %% 定时开启活动的定时器
        show_timer = 0,             %% 定时关闭展示的定时器
        rank_list = []              %% 活动榜单，格式[#rank_type{}]
}).

% 活动开启的区域信息
-record(race_act_zone, {
        key = {0, 0, 0}             %% key##{ZoneId,Type,Subtype}
        , zone_id = 0               %% 区域id
        , type = 0                  %% 主类型
        , subtype = 0               %% 次类型
        , world_lv = 0              %% 世界等级
}).

%% 指定类型排行
-record(rank_type,{
        id = {0,0},                 %% 主键，格式{type,subtype}
        type = 0,                   %% 主类型
        subtype = 0,                %% 次类型
        % server_map = #{},         %% 服对应区列表，格式 server_id=>zone
        % zone_list = [],           %% 区列表，格式[{zone,[服id]}]
        rank_data = []              %% 格式[#rank_data{}]
}).

%% 排行数据记录
-record(rank_data,{
        id = 0,                     %% 区id
        rank_list = [],             %% 格式 #rank_role{}
        score_limit = 0             %% 最后一名分数
}).

-record(rank_role,{
        id = 0              %%玩家id
        ,server_id = 0      %%服务器id
        ,platform = []      %%平台
        ,server_num = 0     %%
        ,node = none        %%所在节点
        ,score = 0          %%分数
        ,rank = 0           %%排名
        ,figure = undefined
        ,last_time = 0
}).
%% ---------------------------------------------------------------------------
%% sql定义
%% ---------------------------------------------------------------------------
-define(sql_race_act_role_select, <<
        "select
            `role_id`,`type`,`subtype`,`score`,`today_score`,`times`,`reward_list`,`score_reward`,`other`,`last_time` from race_act_role
        where role_id=~p ">>).
-define(sql_race_act_role_replace, <<
        "replace into race_act_role (`role_id`,`type`,`subtype`,`score`,`today_score`,`times`,`reward_list`,`score_reward`,`other`,`last_time`) values(~p,~p,~p,~p,~p,~p,'~s','~s','~s',~p)">>).
-define(sql_race_act_rank_select, <<"
    SELECT
        `role_id`,`type`, `subtype`,`server_id`,`platform`,`server_num`,`name`, `mask_id`, `score`,`time`
    FROM race_act_rank order by score desc">>).
-define(sql_race_act_rank_replace,<<"
    replace into `race_act_rank`(
         `role_id`,`type`, `subtype`,`server_id`,`platform`,`server_num`,`name`, `mask_id`, `score`,`time`)
    values(~p, ~p, ~p, ~p, '~s',~p, '~s', ~p, ~p, ~p)">>).
-define(sql_race_act_open_selete, <<"select `type`,`subtype` from race_act">>).
-define(sql_race_act_open_replace, <<"replace into `race_act`(type,subtype) values (~p,~p) ">>).

%% 区域信息
-define(sql_race_act_zone_selete, <<"select `zone_id`,`type`,`subtype`,world_lv from race_act_zone">>).
-define(sql_race_act_zone_replace, <<"replace into `race_act_zone`(`zone_id`,type,subtype,world_lv) values (~p,~p,~p,~p) ">>).
-define(sql_race_act_zone_delete, <<"delete from race_act_zone where `type`=~p and `subtype`=~p">>).
-define(sql_race_act_zone_truncate, <<"truncate table `race_act_zone`">>).

-define(sql_race_act_zone_replace_one, "replace into `race_act_zone`(`zone_id`,`type`,subtype,world_lv) values ~ts").
-define(sql_race_act_zone_replace_values, "(~w, ~w, ~w, ~w)").

%% ---------------------------------------------------------------------------
%% 配置定义
%% ---------------------------------------------------------------------------

% 其他条件:
% 展示物品:[{reward_show,[物品id1,物品id1]}
% 阶段奖励0点清:{stage_clear_zero,1};
% 阶段奖励活动清:{stage_clear_close,1}
% 传闻:{tv_show,[{物品类型id,数量}]}
% 活动类型:{act_type,活动类型}
%   (龙纹:1=>不灭,2=>诡诈,3=>超然)
%   (式神:101=>索尔,102=>雅典娜,103=>须佐之男,104=>炽天使)]
% 邮件(内容参数默认为只有一个,排名参数):{rank_mail, {TitleId, ContentId}}

% -define(RACE_ACT_MOUNT,         1).     %% 坐骑竞榜
% 邮件(内容参数默认为只有一个,排名参数):{rank_mail, {TitleId, ContentId}}

-define(RACE_ACT_IS_ZONE_NO, 0).    % 大跨服
-define(RACE_ACT_IS_ZONE_YES, 1).   % 小跨服

%%活动配置
-record(base_race_act_info, {
        type = 0,           %%主类型
        sub_type = 0,       %%次类型
        act_type = 0,       %%活动类型##0:无,1:单独图标
        show_id = 0,        %%展示id
        is_zone = 0,        %%是否小跨服##0:大跨服,1:小跨服
        name = "",          %%名字
        open_day = 0,       %%开服天数
        open_over = 0,      %%开服结束
        start_time = 0,     %%活动开始时间
        end_time = 0,       %%活动结束时间
        buy_end_time = 0,   %%购买结束时间
        clear_type = 0,     %%1为零点清；2为活动清
        treasure = [],      %%抽检方式##[{抽奖次数(1|10),消耗列表,增加积分}],消耗列表[{Type, GoodsTypeId, Num}]
        others = []         %%其他
}).

%%排名奖励
-record(base_race_act_rank_reward,{
        type = 0,           %%主类型
        sub_type = 0,       %%次类型
        reward_id = 0,      %%奖励id
        rank_min = 0,       %%排名下限
        rank_max = 0,       %%排名上限
        limit_val = 0,      %%最低上榜值
        format = 0,         %%奖励格式
        reward = []         %%奖励
}).

%%阶段奖励
-record(base_race_act_stage_reward,{
        type = 0,           %%主类型
        sub_type = 0,       %%次类型
        reward_id = 0,      %%奖励id
        need_val = 0,       %%所需值
        format = 0,         %%奖励格式
        reward = []         %%奖励
}).

%%奖池配置
-record(base_race_act_reward,{
        type = 0,           %%主类型
        sub_type = 0,       %%次类型
        cost_type = 0,      %%奖池类型
        reward_id = 0,      %%奖励id
        format = 0,         %%奖励格式
        reward = [],        %%内容
        condition = []      %%条件    [加权下限,加权上限,权重,临时权重,必中次数]
}).

