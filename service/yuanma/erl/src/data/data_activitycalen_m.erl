%%%--------------------------------------
%%% @Module  : data_activitycalen_m
%%% @Author  : xiaoxiang
%%% @Created : 2017-03-01
%%% @Description:  data_activitycalen_m
%%%--------------------------------------
-module(data_activitycalen_m).
-export([

    ]).
-include("server.hrl").
-include("figure.hrl").
-include("def_module.hrl").
-include("def_daily.hrl").
-include("activitycalen.hrl").
-include("common.hrl").
-compile(export_all).

%%功能内部自定义次数，MAX为次数上限，NUM为已完成次数
%% 竞技场次数
%% @return List [{Type, Max, Num},..] Type见 ?ACTIVITY_COUNT_TYPE_NORMAL 等定义
% get_extra(Player, #base_ac{module = ?MOD_JJC, module_sub = 0}) ->
%     #player_status{id = RoleId} = Player,
%     {Max, Num} = lib_jjc_api:get_jjc_num(RoleId),
%     [{?ACTIVITY_COUNT_TYPE_NORMAL, Max, Num}];

%% 商会任务
%% get_extra(Player, #base_ac{module = 417, module_sub = 0}) ->
%%     #player_status{id = RoleId} = Player,
%%     Max = mod_daily:get_limit_by_type(417, 1),
%%     Num = mod_daily:get_count(RoleId, 417, 1),
%%     [{?ACTIVITY_COUNT_TYPE_NORMAL, Max, Num}];

%% 天空战场
%% get_extra(Player, #base_ac{module = 418, module_sub = 0}) ->
%%     #player_status{id = RoleId} = Player,
%%     Max = mod_daily:get_limit_by_type(418, 1),
%%     Num = mod_daily:get_count(RoleId, 418, 1),
%%     [{?ACTIVITY_COUNT_TYPE_NORMAL, Max, Num}];

%% 成长试炼
% get_extra(Player, #base_ac{module = 611, module_sub = 0}) ->
%     #player_status{id = RoleId} = Player,
%     Max = mod_daily:get_limit_by_type(611, 1),
%     Num = mod_daily:get_count(RoleId, 611, 1),
%     [{?ACTIVITY_COUNT_TYPE_NORMAL, Max, Num}];

%% 恶魔狩猎
% get_extra(Player, #base_ac{module = ?MOD_HUNTING, module_sub = 0}) ->
%     #player_status{id = RoleId} = Player,
%     Max = mod_daily:get_limit_by_type(?MOD_HUNTING, ?HUNTING_AWARD),
%     Num = mod_daily:get_count(RoleId, ?MOD_HUNTING, ?HUNTING_AWARD),
%     [{?ACTIVITY_COUNT_TYPE_NORMAL, Max, Num}];

%% 五芒星副本
% get_extra(Player, #base_ac{module = ?MOD_DUNGEON_PENTACLE, module_sub = 0}) ->
%     #player_status{id = RoleId} = Player,
%     Max = mod_daily:get_limit_by_type(?MOD_DUNGEON_PENTACLE, ?DAILY_DUNGEON_PENTACLE_ENTER),
%     Num = mod_daily:get_count(RoleId, ?MOD_DUNGEON_PENTACLE, ?DAILY_DUNGEON_PENTACLE_ENTER),
%     HelpMax = mod_daily:get_limit_by_type(?MOD_DUNGEON_PENTACLE, ?DAILY_DUNGEON_PENTACLE_HELP),
%     HelpNum = mod_daily:get_count(RoleId, ?MOD_DUNGEON_PENTACLE, ?DAILY_DUNGEON_PENTACLE_HELP),
%     [{?ACTIVITY_COUNT_TYPE_NORMAL, Max, min(Num, Max)}, {?ACTIVITY_COUNT_TYPE_HELP_COUNT, HelpMax, min(HelpNum, HelpMax)}];

% %% 冒险副本
% get_extra(Player, #base_ac{module = ?MOD_DUNGEON_RISK, module_sub = 0}) ->
%     #player_status{id = RoleId} = Player,
%     Max = mod_daily:get_limit_by_type(?MOD_DUNGEON_RISK, ?DAILY_DUNGEON_RISK_ENTER),
%     Num = mod_daily:get_count(RoleId, ?MOD_DUNGEON_RISK, ?DAILY_DUNGEON_RISK_ENTER),
%     HelpMax = mod_daily:get_limit_by_type(?MOD_DUNGEON_RISK, ?DAILY_DUNGEON_RISK_HELP),
%     HelpNum = mod_daily:get_count(RoleId, ?MOD_DUNGEON_RISK, ?DAILY_DUNGEON_RISK_HELP),
%     [{?ACTIVITY_COUNT_TYPE_NORMAL, Max, min(Num, Max)}, {?ACTIVITY_COUNT_TYPE_HELP_COUNT, HelpMax, min(HelpNum, HelpMax)}];

% %% 遗忘之境
% get_extra(Player, #base_ac{module = ?MOD_DUNGEON_OBLIVION, module_sub = 0}) ->
%     #player_status{id = RoleId} = Player,
%     Max = mod_daily:get_limit_by_type(?MOD_DUNGEON_OBLIVION, ?DAILY_DUNGEON_OBLIVION_ENTER),
%     Num = mod_daily:get_count(RoleId, ?MOD_DUNGEON_OBLIVION, ?DAILY_DUNGEON_OBLIVION_ENTER),
%     HelpMax = mod_daily:get_limit_by_type(?MOD_DUNGEON_OBLIVION, ?DAILY_DUNGEON_OBLIVION_HELP),
%     HelpNum = mod_daily:get_count(RoleId, ?MOD_DUNGEON_OBLIVION, ?DAILY_DUNGEON_OBLIVION_HELP),
%     [{?ACTIVITY_COUNT_TYPE_NORMAL, Max, min(Num, Max)}, {?ACTIVITY_COUNT_TYPE_HELP_COUNT, HelpMax, min(HelpNum, HelpMax)}];

%% 英雄战场
%% get_extra(Player, #base_ac{module = ?MOD_HERO_WAR, module_sub = 0}) ->
%%     #player_status{id = RoleId} = Player,
%%     Max = mod_daily:get_limit_by_type(?MOD_HERO_WAR, ?HERO_WAR_ATTACK),
%%     Num = mod_daily:get_count(RoleId, ?MOD_HERO_WAR, ?HERO_WAR_ATTACK),
%%     [{?ACTIVITY_COUNT_TYPE_NORMAL, Max, Num}];

%% 夺旗战
%% get_extra(Player, #base_ac{module = ?MOD_FLAGWAR, module_sub = 0, time_region=TimeRegion} = BaseAc) ->
%%     #player_status{id = RoleId} = Player,
%%     case lib_activitycalen_util:do_check_ac_sub(BaseAc, [fix_time, week, month, time, open_day, merge_day, timestamp]) of
%%         true ->
%%             Max = length([1||{{_,_}, _End}<-TimeRegion]);
%%         false ->
%%             Max = 0
%%     end,
%%     Num = mod_daily:get_count(RoleId, ?MOD_ACTIVITY, ?MOD_ACTIVITY_NUM, ?MOD_FLAGWAR*?AC_LIVE_ADD+0),
%%     [{?ACTIVITY_COUNT_TYPE_NORMAL, Max, Num}];

%%　领取7日或30日礼包　　　购买每日礼包
%% 充值活动显示的为活跃度次数
get_extra(Player, #base_ac{module = Module, module_sub = ModuleSub})
        when Module == ?MOD_RECHARGE_ACT andalso (ModuleSub == ?MOD_RECHARGE_ACT_GET_WEAFARE_REWARD orelse ModuleSub == ?MOD_RECHARGE_ACT_BUY_DAILY) ->
    #player_status{id = RoleId} = Player,
    case data_activitycalen:get_live_config(Module, ModuleSub) of
        #ac_liveness{max = Max} ->
            Num = mod_daily:get_count(RoleId, ?MOD_ACTIVITY, ?MOD_ACTIVITY_NUM, Module*?AC_LIVE_ADD+ModuleSub);
        _ ->
            Max = 0,
            Num = 0
    end,
    [{?ACTIVITY_COUNT_TYPE_NORMAL, Max, min(Max, Num)}];

get_extra(_Player, _BaseAc) ->
    [{?ACTIVITY_COUNT_TYPE_NORMAL, 0, 0}].


%% 活动预告
%% @doc 根据物品Id删除物品并刷新客户端以及做物品日志
-spec get_advance(Module, ModuleSub) -> Time when
    Module          :: integer(),                        %% 功能ID
    ModuleSub       :: integer(),                       %% 功能子ID
    Time            :: integer().                       %% 预告时间（分钟）（0分钟不预告）
%% ---------------------------------------------------------------------------
get_advance(?MOD_TREASURE_CHEST, _) ->
    5;
get_advance(?MOD_NOON_QUIZ, _) ->
    5;
% get_advance(?MOD_GUILD_ACT, ?MOD_GUILD_ACT_GUARD) ->
%     5;
get_advance(?MOD_HUSONG, ?MOD_SUB_HUSONG_DOUBLE) ->
    5;
get_advance(?MOD_THREE_ARMIES_BATTLE, _) ->
    5;
get_advance(?MOD_KF_GUILD_WAR, _) ->
    5;
get_advance(?MOD_GUILD_BATTLE, _) ->
    5;
get_advance(?MOD_MIDDAY_PARTY, _) ->
    5;
get_advance(_Module, _ModuleSub) ->
    0.
