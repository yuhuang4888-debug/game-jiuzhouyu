%%%------------------------------------
%%% @Module  :  lib_ranking_api
%%% @Author  :  xiaoxiang
%%% @Created :  2016-11-17
%%% @Description: 榜单
%%%------------------------------------

-module(lib_rush_rank_api).

-export([
    handle_event/2,
    login/1,
    logout/1
]).

-compile(export_all).

-include("rush_rank.hrl").
-include("server.hrl").
-include("figure.hrl").
-include("def_event.hrl").
-include("rec_event.hrl").
-include("predefine.hrl").
-include("common.hrl").
-include("record.hrl").
-include("custom_act.hrl").

%% 移除指定排行的玩家信息
%% 将玩家剔除指定的榜单，并且重新排行
remove_role_rank(_RankType, []) -> skip;
remove_role_rank(?RANK_TYPE_RECHARGE_RUSH, RoleIds) ->
    ?PRINT("RoleIds ~p ~n", [RoleIds]),
    SubList = lib_custom_act_api:get_open_subtype_ids(?CUSTOM_ACT_TYPE_RUSH_RANK),
    [mod_rush_rank:remove_role_in_rank(SubType, ?RANK_TYPE_RECHARGE_RUSH, RoleIds)||SubType<-SubList];
remove_role_rank(_RankType, _RoleIds) -> skip.

%% 重新加载信息到排行榜
%% 玩家重新入榜
fresh_role_rank(_RankType, []) -> skip;
fresh_role_rank(?RANK_TYPE_RECHARGE_RUSH, RoleIds) ->
    [lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, ?MODULE, refresh_rush_rank, [?RANK_TYPE_RECHARGE_RUSH])||RoleId <- RoleIds],
    ok;
fresh_role_rank(_RankType, _RoleIds) -> skip.

%% 等级排行榜
handle_event(Player, #event_callback{type_id = ?EVENT_LV_UP}) when is_record(Player, player_status) ->
    %?PRINT("~p~n", [util:get_open_day()]),
    refresh_rush_rank(Player, ?RANK_TYPE_LV_RUSH),
    {ok, Player};

%% 战力排行榜、 职业排行榜
handle_event(Player, #event_callback{type_id = ?EVENT_COMBAT_POWER}) when is_record(Player, player_status) ->
    refresh_rush_rank(Player, ?RANK_TYPE_COMBAT_RUSH),
    {ok, Player};

%%%% 充值排行榜
handle_event(Player, #event_callback{type_id = ?EVENT_RECHARGE}) when is_record(Player, player_status) ->
    %% 充值活动限制
%%    IsLimit = lib_recharge_limit:check_recharge_limit(Player),
%%    ?PRINT("IsLimit ~p ~n", [IsLimit]),
%%    case IsLimit of
%%        true -> skip;
%%        false -> refresh_rush_rank(Player, ?RANK_TYPE_RECHARGE_RUSH)
%%    end,
    refresh_rush_rank(Player, ?RANK_TYPE_RECHARGE_RUSH),
    {ok, Player};

%% 玩家登出事件
handle_event(Player, #event_callback{type_id = ?EVENT_DISCONNECT}) -> 
    #player_status{id = RoleId} = Player, 
    mod_rush_rank:role_refresh_send_time(RoleId), 
    {ok, Player};
handle_event(Player, #event_callback{type_id = ?EVENT_DISCONNECT_HOLD_END}) -> 
    #player_status{id = RoleId} = Player, 
    mod_rush_rank:role_refresh_send_time(RoleId), 
    {ok, Player};

handle_event(Player, _Ec) ->
    ?ERR("unkown event_callback:~p", [_Ec]),
    {ok, Player}.

%% 强化
reflash_rank_by_strengthen_rush(Player) ->
    refresh_rush_rank(Player, ?RANK_TYPE_EQUIPMENT_STRENGTHEN_RUSH).
%% 宝石
reflash_rank_by_stone_rush(Player) ->
    refresh_rush_rank(Player, ?RANK_TYPE_STONE_RUSH).

%% 飞行器
reflash_rank_by_aircraft_rush(Player) ->
    refresh_rush_rank(Player, ?RANK_TYPE_AIRCRAFT_RUSH).
%% 坐骑
reflash_rank_by_mount_rush(Player) ->
    refresh_rush_rank(Player, ?RANK_TYPE_MOUNT_RUSH).
%% 宠物
reflash_rank_by_pet_rush(Player) ->
    refresh_rush_rank(Player, ?RANK_TYPE_PET_RUSH).

%% 精灵
reflash_rank_by_spirit_rush(Player) ->
%%    ?DEBUG("Wing update~n", []),
    refresh_rush_rank(Player, ?RANK_TYPE_SPIRIT_RUSH).
%%  翅膀
reflash_rank_by_wing_rush(Player) ->
    refresh_rush_rank(Player, ?RANK_TYPE_WING_RUSH).

%% 套装战力
reflash_rank_by_suit_rush(Player) ->
    refresh_rush_rank(Player, ?RANK_TYPE_SUIT_RUSH).


%%聚魂战力
reflash_rank_by_soul_rush(Player) ->
    refresh_rush_rank(Player, ?RANK_TYPE_SOUL_RUSH).


%% 龙纹等级
reflash_rank_by_dragon_rush(Player) ->
    refresh_rush_rank(Player, ?RANK_TYPE_DRAGON).

%% 御魂战力（符文）
flash_rank_by_rune_rush(Player) ->
    refresh_rush_rank(Player, ?RANK_TYPE_RUNE).

login(Player) ->
    refresh_rush_rank_by_all(Player),
    ok.

logout(_Player) ->
    %refresh_rush_rank_by_all(Player),
    ok.

refresh_rush_rank(Player, RankType) ->
    SubList = lib_custom_act_api:get_open_subtype_ids(?CUSTOM_ACT_TYPE_RUSH_RANK),
%%    ?DEBUG("RankType ~p ,  SubList ~p~n", [RankType, SubList]),
    [refresh_rush_rank(Player, RankType, SubType) || SubType <- SubList].

%% 刷新榜单,最好在里面统一处理,修改方便
refresh_rush_rank(Player, RankType, SubType) ->
    case lists:member(RankType, ?RANK_TYPE_LIST) of
        true ->
            case lib_rush_rank:get_refresh_limit(RankType) of  %%结算后的，不能刷榜了
                true ->
%%                    ?DEBUG("~n M:~p L:~p RankType:~p ~n ", [?MODULE, ?LINE, RankType]),
                    lib_rush_rank:refresh_rush_rank({RankType, SubType}, Player);
                false ->
%%                    ?DEBUG("~n M:~p L:~p RankType:~p ~n ", [?MODULE, ?LINE, RankType]),
                    skip
            end;
        false -> skip
    end.


%% 刷新所有榜单。
refresh_rush_rank_by_all(Player) ->
    refresh_rush_rank(Player, ?RANK_TYPE_LV_RUSH),
    %% refresh_rush_rank(Player, ?RANK_TYPE_SOUL_RUSH),
    %% refresh_rush_rank(Player, ?RANK_TYPE_EQUIPMENT_STRENGTHEN_RUSH),
    %% refresh_rush_rank(Player, ?RANK_TYPE_AIRCRAFT_RUSH),
    refresh_rush_rank(Player, ?RANK_TYPE_MOUNT_RUSH),
    refresh_rush_rank(Player, ?RANK_TYPE_STONE_RUSH),
    %% refresh_rush_rank(Player, ?RANK_TYPE_PET_RUSH),
    %% refresh_rush_rank(Player, ?RANK_TYPE_WING_RUSH),
    %% RANK_TYPE_PARTNER_RUSH
    refresh_rush_rank(Player, ?RANK_TYPE_SPIRIT_RUSH),
    %% refresh_rush_rank(Player, ?RANK_TYPE_RECHARGE_RUSH),
    refresh_rush_rank(Player, ?RANK_TYPE_DRAGON),
    refresh_rush_rank(Player, ?RANK_TYPE_COMBAT_RUSH),
    ok.


%% 刷新宝石秘籍
gm_refresh_stone() ->
    Sql = io_lib:format(<<"select  player_id  from   rush_rank_role">>, []),
    List = db:get_all(Sql),
    [lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, ?HAND_OFFLINE, lib_rush_rank_api, gm_refresh_stone, [])
        || [RoleId] <- List].

gm_refresh_stone(PS) ->
    refresh_rush_rank(PS, ?RANK_TYPE_STONE_RUSH),
	PS.

role_reload_recharge(RoleId) ->
    lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, ?MODULE, refresh_rush_rank, [?RANK_TYPE_RECHARGE_RUSH]),
    ok.
gm_remove_ban_role() ->
    case db:get_all(<<"select id from player_login where status != 0">>) of
        [] -> skip;
        RoleIdlL ->
            Condition = usql:condition({player_id, in, lists:flatten(RoleIdlL)}),
            Sql = "delete from rush_rank_role " ++ Condition,
            Res = db:execute(Sql),
            supervisor:terminate_child(gsrv_sup, {mod_rush_rank, start_link, []}),
            supervisor:restart_child(gsrv_sup, {mod_rush_rank, start_link, []}),
            Res
    end.

%% -----------------------------------------------------------------
%% @desc 周卡培养现回退修正开服冲榜榜单
%% @param
%% @return
%% -----------------------------------------------------------------
gm_refresh_rush_rank(Player) ->
    [gm_refresh_rush_rank(Player, RankType) || RankType <- [?RANK_TYPE_MOUNT_RUSH, ?RANK_TYPE_SPIRIT_RUSH, ?RANK_TYPE_WING_RUSH]].
gm_refresh_rush_rank(Player, RankType) ->
    SubList = lib_custom_act_api:get_open_subtype_ids(?CUSTOM_ACT_TYPE_RUSH_RANK),
    F = fun(SubType) ->
        case lists:member(RankType, ?RANK_TYPE_LIST) of
            true ->
                %% 结算后的，不能刷榜了
                case lib_rush_rank:get_refresh_limit(RankType) of
                    true ->
                        RushRank = lib_rush_rank:make_record([{RankType, SubType}, Player]),
                        mod_rush_rank:gm_refresh_rush_rank(RankType, SubType, RushRank);
                    false -> skip
                end;
            false -> skip
        end
        end,
    lists:foreach(F, SubList).

