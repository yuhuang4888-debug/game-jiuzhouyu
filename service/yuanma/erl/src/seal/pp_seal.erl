%%-----------------------------------------------------------------------------
%% @Module  :       pp_seal.erl
%% @Author  :       
%% @Email   :       
%% @Created :       2019-03-02
%% @Description:    圣印
%%-----------------------------------------------------------------------------

-module(pp_seal).

-include("common.hrl").
-include("errcode.hrl").
-include("server.hrl").
-include("goods.hrl").
-include("def_goods.hrl").
-include("seal.hrl").
-include("def_module.hrl").
-include("predefine.hrl").
-include("figure.hrl").
-include("def_fun.hrl").
-export ([handle/3]).

handle(Cmd, PlayerStatus, Data) ->
    #player_status{figure = Figure} = PlayerStatus,
    OpenLv = case data_seal:get_seal_value(3) of
        [Lv] when is_integer(Lv) -> Lv;
        _ -> 0
    end,
    case Figure#figure.lv >= OpenLv of
        true ->
            do_handle(Cmd, PlayerStatus, Data);
        false -> skip
    end.

%% 界面
do_handle(65401, PS, []) ->
    lib_seal:send_seal_info(PS);

%% 强化
do_handle(65402, PS, [Pos, StrenType]) ->
    lib_seal:stren_seal_pos(PS, Pos, StrenType);

%% 穿装备
do_handle(65403, PS, [_Pos, GoodsAutoId]) ->
    lib_seal:dress_on_equip(PS, GoodsAutoId);

% 脱装备
do_handle(65404, PS, [Pos]) ->
    lib_seal:dress_off_seal_equip(PS, Pos);

%% 圣魂丹界面
do_handle(65405, PS, []) ->
    lib_seal:send_seal_bead_info(PS);

%%圣魂丹使用
do_handle(65406, PS, [GoodsTypeId, Num]) ->
    lib_seal:apply_seal_bead(PS, GoodsTypeId, Num);

%% 获取总评分（装备评分+套装评分）
do_handle(65407, PS, []) ->
    lib_seal:send_rating(PS);

%% 套装预览
do_handle(65408, PS, [GoodsTypeId]) ->
    lib_seal:look_over_suit_info(PS, GoodsTypeId);

%% 套装
do_handle(65409, PS, []) ->
    lib_seal:get_seal_equip_num(PS);

do_handle(CMD, _PS, Args) ->
    ?ERR("protocol ~p, ~p nomatch ~n", [CMD, Args]).