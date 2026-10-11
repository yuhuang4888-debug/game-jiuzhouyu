%%%-------------------------------------------------------------------
%%% @author whao
%%% @copyright (C) 2018, <SuYou Game>
%%% @doc
%%%
%%% @end
%%% Created : 10. 十二月 2018 9:26
%%%-------------------------------------------------------------------
-module(lib_fairy_check).
-author("whao").

-include("server.hrl").
-include("common.hrl").
-include("goods.hrl").
-include("def_goods.hrl").
-include("errcode.hrl").
-include("def_event.hrl").
-include("rec_event.hrl").
-include("def_module.hrl").
-include("figure.hrl").
-include("fairy.hrl").
%% API
-compile(export_all).

%% 检查强化条件
stren(PS, GoodsStatus, Pos) ->
    Level = lib_decoration:get_dec_level(PS, Pos),
    Cfg = data_decoration:get_dec_level(Pos, Level),
    EquipInfo = lib_decoration:get_dec_by_location(PS, GoodsStatus, Pos),
    CheckList = [
        {check_config, Cfg, []},
        {check_equip_pos_correct, Pos},
        {check_has_equip, Pos, PS},
        {check_level_up, Level, EquipInfo},
        {check_level_cost, PS, Cfg}
    ],
    case checklist(CheckList) of
        true ->
            {true, EquipInfo, Level, Cfg};
        {false, Res} ->
            {false, Res}
    end.


%%
check({check_fairy_exist, GoodsInfo}) ->
    case is_record(GoodsInfo, goods) of
        true -> true;
        false -> {false, ?ERRCODE(err150_no_goods)}
    end;

% 检查物品是否存在
check({check_exist, GoodsInfo}) ->
    case is_record(GoodsInfo, goods) of
        true -> true;
        false -> {false, ?ERRCODE(err150_no_goods)}
    end;



check(X) ->
    ?INFO("equip_check error ~p~n", [X]),
    {false, ?FAIL}.

checklist([]) -> true;
checklist([H | T]) ->
    case check(H) of
        true -> checklist(T);
        {false, Res} -> {false, Res}
    end.















