%% ---------------------------------------------------------------------------
%% @doc  藏宝图
%% @author cym
%% @since  2019/09/03
%% @deprecated
%% ---------------------------------------------------------------------------
-module(pp_tsmap).

-export([
    handle/3
]).

-include("server.hrl").
-include("tsmaps.hrl").
-include("common.hrl").
-include("figure.hrl").
-include("goods.hrl").
-include("def_goods.hrl").
-include("def_module.hrl").
-include("errcode.hrl").


handle(Cmd, #player_status{figure = F, id = RoleId} = PlayerStatus, Data) ->
    LvLimit = data_treasure_map:get_kv(lv_limit),
    if
        F#figure.lv < LvLimit ->
            lib_tsmap:pack_and_send(RoleId, 20300, [?ERRCODE(lv_limit)]);
        true ->
            case do_handle(Cmd, PlayerStatus, Data) of
                {ok, NewPS} when is_record(NewPS, player_status) ->
                    {ok, NewPS};
                NewPS when is_record(NewPS, player_status) ->
                    {ok, NewPS};
                _ ->
                    ok
            end
    end.

%% 藏宝图道具的使用
do_handle(20301, Ps, [AutoGoodsId]) ->
    lib_tsmap:use_treasure_map(Ps, AutoGoodsId);

%% 藏宝图抽奖
do_handle(20302, PS, [Type, GoodsAutoId]) ->
    lib_tsmap:lottery(PS, Type, GoodsAutoId);


do_handle(20303, PS, []) ->
    #player_status{server_id = ServerId, id = RoleId} = PS,
    %% mod_kf_draw_record:cast_center([{'get_draw_log', ?MOD_BONUS_MONDAY, ?MOD_BONUS_MONDAY_FIRST, ServerId, RoleId}]),
    mod_kf_draw_record:cast_center([{'get_draw_log', ?MOD_TREASURE_MAP, 1, ServerId, RoleId}]);

%% 发送传闻
do_handle(20304, _PS, []) ->
    case get(tsmap) of
        {Ref, Tv, Type, Name, RoleId, RewardList, RoleId} ->
            util:cancel_timer(Ref),
            lib_tsmap:send_tv(Tv, Type, Name, RoleId, RewardList, RoleId);
        _ ->
            skip
    end;

do_handle(_Cmd, _PlayerStatus, _Data) ->
    ok.