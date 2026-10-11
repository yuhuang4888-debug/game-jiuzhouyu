%% ---------------------------------------------------------------------------
%% @doc arcana.erl

%% @author  hjh
%% @email  hejiahua@163.com
%% @since  2019-10-21
%% @deprecated 远古奥术
%% ---------------------------------------------------------------------------

-define(ARCANA_KV(Key), data_arcana:get_kv(Key)). 

-define(ARCANA_KV_LV, ?ARCANA_KV(1)).             % 开启等级
-define(ARCANA_KV_OPEN_DAY, ?ARCANA_KV(2)).       % 开放天数

%% 远古奥术结构
-record(status_arcana, {
        core_type = 0           % 核心类型
        , arcana_list = []      % 远古奥术列表##[#arcana{}]
        , passive_skills = []   % 被动技能列表
        , active_list = []      % 技能列表##主动技能[{SkillId, SkillLv}]
        , reskill_list = []     % 技能替换##[{SkillId, ReSkillId}]
        , skill_list = []       % 总技能列表##[{SkillId, Lv}],如果被替换的,旧技能id不会存在这里
        , total_attr = []       % 总属性
        , sec_attr = #{}        % 第二属性
        , skill_power = 0       % 战力
    }).

%% 远古奥术
-record(arcana, {
        id = 0              % 规则id
        , lv = 0            % 等级
        , break_lv = 0      % 突破等级
    }).

%% 远古奥术
-record(base_arcana, {
        id = 0              % 规则id
        , career = 0        % 职业id
        , is_core = 0       % 是否核心
        , core_type = 0     % 核心类型
        , pos = 0           % 位置
        , max_lv = 0        % 最大等级
        , max_break_lv = 0  % 最大突破等级
        , desc = ""         % 描述@lang@
    }).

%% 远古奥术等级
-record(base_arcana_lv, {
        id = 0              % 规则id
        , career = 0        % 职业id
        , lv = 0            % 等级
        , condition = []    % 升级条件
        , skill_id = 0      % 技能id
        , skill_lv = 0      % 等级
        , is_auto = 0       % 是否自动升级
    }).

%% 远古奥术突破
-record(base_arcana_break, {
        id = 0                  % 规则id
        , career = 0            % 职业id
        , break_lv = 0          % 突破等级
        , condition = []        % 突破条件
        , skill_id = 0          % 技能id
        , break_skill_id = 0    % 突破技能id##等于0不处理
        , desc = ""             % 描述@lang@
    }).


-define(sql_role_arcana_select, <<"SELECT arcana_id, lv, break_lv FROM role_arcana WHERE role_id = ~p">>).
-define(sql_role_arcana_replace, <<"REPLACE INTO role_arcana(role_id, arcana_id, lv, break_lv) VALUES(~p, ~p, ~p, ~p)">>).

-define(sql_role_arcana_core_select, <<"SELECT core_type FROM role_arcana_core WHERE role_id = ~p">>).
-define(sql_role_arcana_core_replace, <<"REPLACE INTO role_arcana_core(role_id, core_type) VALUES(~p, ~p)">>).