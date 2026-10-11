%%%---------------------------------------
%%% @Module         : suit_collect_event
%%% @Author          : kuangyaode
%%% @Created         : 2020.08.05
%%% @Description   :  套装收集事件触发
%%%---------------------------------------

-module(lib_suit_collect_event).

-include("equip_suit.hrl").
-include("server.hrl").
-include("figure.hrl").
-include("errcode.hrl").
-include("common.hrl").

-export([event/2]).

%% 通用处理
event(base, [PS]) ->
    #player_status{id = RoleId, figure = #figure{suit_clt_figure = SuitId} = Figure} = PS,
    % 更新场景玩家时装
    mod_scene_agent:update(PS, [{suit_clt_figure, SuitId}]),
    lib_scene:broadcast_player_attr(PS, [{?SUIT_CLT_FIGURE_ATTR, SuitId}]),
    % 更新ets表
    lib_role:update_role_show(RoleId, [{figure, Figure}]),
    lib_team_api:update_team_mb(PS, [{figure, Figure}]);

%% 穿戴
event(IsWear, [PS, _Pos]) when IsWear == ?WEAR ->
    event(base, [PS]),
    {ok, NewPS} = lib_fashion_api:take_off_other(suit_clt, PS),    % 脱掉其它时装（时装、神殿、天启）
    case NewPS#player_status.figure#figure.guild_id > 0 of
        true -> mod_guild:update_guild_member_attr(NewPS#player_status.id, [{figure, NewPS#player_status.figure}]);
        false -> skip
    end,
    {ok, NewPS};

%% 脱下
event(IsWear, [PS, _Pos]) when IsWear == ?UNWEAR ->
    event(base, [PS]),
    {ok, PS};

%% 套装阶段激活
event(activate, [PS, _SuitId, CltStage]) when CltStage == ?SUIT_CLT_MAX_STAGE ->

    % 任务
    lib_task_api:suit_ctl(PS, lib_suit_collect_api:get_all_suit_clt(PS)),
    PS;
event(activate, [PS, _SuitId, _CltStage]) -> 
    % 任务
    lib_task_api:suit_ctl(PS, lib_suit_collect_api:get_all_suit_clt(PS)),
    PS;

event(_IsWear, [PS, _Pos]) -> {ok, PS}.