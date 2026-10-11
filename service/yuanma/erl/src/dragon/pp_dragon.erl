%% ---------------------------------------------------------------------------
%% @doc pp_dragon.erl

%% @author  hjh
%% @email  hejiahua@163.com
%% @since  2017-12-18
%% @deprecated 龍紋系統
%% ---------------------------------------------------------------------------
-module(pp_dragon).
-export([handle/3]).

-include("server.hrl").
-include("dragon.hrl").
-include("goods.hrl").
-include("errcode.hrl").
-include("common.hrl").
-include("def_goods.hrl").

%% 獲取龍紋信息
handle(Cmd = 18100, Player, []) ->
    #player_status{
        id = PlayerId, sid = Sid, dragon = StatusDragon
    } = Player,
    #status_dragon{
        base_attr = BaseAttr, attr_special_list = EquipSpecialAttrList,
        pos_list = PosList, real_combat_power = CombatPower
    } = StatusDragon,
    BaseAttrList = lib_player_attr:to_kv_list(BaseAttr),

    #goods_status{ dict = Dict} = GoodsStatus = lib_goods_do:get_goods_status(),
    EquipList = lib_goods_util:get_equip_list(PlayerId, ?GOODS_TYPE_DRAGON_EQUIP, ?GOODS_LOC_DRAGON_EQUIP, Dict),
    Fun = fun(#dragon_pos{ pos = Pos, lv = PosLv}, AccSendList) ->
        case lists:keyfind(Pos, #goods.cell, EquipList) of
            #goods{ goods_id = ItemId, level = Level } ->
                NextLevel = Level + 1,
                case data_dragon:get_star_and_lv(NextLevel) of
                    {_, _Star} ->
                        NextPower = lib_dragon:calc_one_equip_add_power(ItemId, NextLevel, Player, GoodsStatus);
                    _ ->
                        NextPower = 0
                end,
                [{Pos, Level, NextPower}|AccSendList];
            _ ->
                [{Pos, 0, 0}|AccSendList]
        end
    end,
    PosShowList = lists:foldl(Fun, [], PosList),
    lib_server_send:send_to_sid(Sid, pt_181, Cmd, [BaseAttrList++EquipSpecialAttrList, PosShowList, CombatPower]),
    ok;

%% 龍紋升級
handle(Cmd = 18101, #player_status{sid = Sid} = Player, [GoodsId]) ->
    case lib_dragon_equip:up_lv(Player, GoodsId) of
        {false, ErrorCode, NewPlayer} -> skip;
        {true, NewPlayer} -> 
            lib_train_act:dragon_train_power_up(NewPlayer),
            ErrorCode = ?SUCCESS
    end,
    case lib_goods_api:get_goods_info(GoodsId) of
        [] -> Lv = 0;
        #goods{level = Lv} -> ok
    end,
    lib_server_send:send_to_sid(Sid, pt_181, Cmd, [ErrorCode, GoodsId, Lv]),
    {ok, NewPlayer};

%% 穿戴龍紋裝備
handle(Cmd = 18102, #player_status{sid = Sid} = Player, [GoodsId, CellPos]) ->
    case lib_dragon_equip:equip(Player, GoodsId, CellPos) of
        {true, ErrorCode, NewPlayer} ->
            lib_server_send:send_to_sid(Sid, pt_181, Cmd, [ErrorCode, GoodsId, CellPos]),
            lib_train_act:dragon_train_power_up(NewPlayer),
            {ok, PlayerAfSupVip} = lib_supreme_vip_api:dragon_equip_event(NewPlayer),
            {ok, equip, PlayerAfSupVip};
        {false, ErrorCode, NewPlayer} ->
            lib_server_send:send_to_sid(Sid, pt_181, Cmd, [ErrorCode, GoodsId, CellPos]),
            {ok, NewPlayer};
        _ -> 
            {ok, Player}
    end;

%% 卸下龍紋裝備
handle(Cmd = 18103, #player_status{sid = Sid} = Player, [GoodsId]) ->
    case lib_dragon_equip:unequip(Player, GoodsId) of
        {true, ErrorCode, NewPlayer, Cell} ->
            ?ERR_MSG(Cmd, ErrorCode),
            lib_server_send:send_to_sid(Sid, pt_181, Cmd, [ErrorCode, GoodsId, Cell]),
            {ok, equip, NewPlayer};
        {false, ErrorCode, NewPlayer} ->
            ?ERR_MSG(Cmd, ErrorCode),
            lib_server_send:send_to_sid(Sid, pt_181, Cmd, [ErrorCode, GoodsId, 0]),
            {ok, NewPlayer};
        _ -> 
            {ok, Player}
    end;

%% 龍紋一鍵分解
handle(Cmd = 18104, #player_status{sid = Sid} = Player, [GoodsIdL]) ->
    case lib_dragon_equip:decompose(Player, GoodsIdL) of
        {false, ErrorCode, NewPlayer} -> DecomposeList = [];
        {true, NewPlayer, DecomposeList} -> ErrorCode = ?SUCCESS
    end,
    lib_server_send:send_to_sid(Sid, pt_181, Cmd, [ErrorCode, DecomposeList]),
    {ok, NewPlayer};

%% 熔爐信息
handle(Cmd = 18105, #player_status{sid = Sid, dragon_cb = StatusDragonCb} = Player, []) ->
    NewPlayer = lib_dragon_crucible:calc_status_dragon_cb(Player),
    {InfoList,{NewFreeTimes, NewNextFreeTime}} = lib_dragon_crucible:get_crucible_info(NewPlayer),
    lib_server_send:send_to_sid(Sid, pt_181, Cmd, InfoList),
    NewSDCb = StatusDragonCb#status_dragon_cb{free_times = NewFreeTimes, next_free_time = NewNextFreeTime},
    {ok, NewPlayer#player_status{dragon_cb = NewSDCb}};

%% 熔爐召喚
handle(Cmd = 18106, #player_status{sid = Sid} = Player, [AddCount, AutoBuy]) ->
    NewPlayer = lib_dragon_crucible:calc_status_dragon_cb(Player),
    case lib_dragon_crucible:beckon(NewPlayer, AddCount, AutoBuy) of
        {false, ErrorCode, NewPlayer2} -> RewardList = [];
        {true, NewPlayer2, RewardList} -> ErrorCode = ?SUCCESS
    end,
    lib_server_send:send_to_sid(Sid, pt_181, Cmd, [ErrorCode, AddCount, RewardList]),
    {ok, NewPlayer2};

%% 熔爐召喚獎勵領取
handle(Cmd = 18107, #player_status{sid = Sid} = Player, [Count]) ->
    NewPlayer = lib_dragon_crucible:calc_status_dragon_cb(Player),
    case lib_dragon_crucible:handle_count_reward(NewPlayer, Count) of
        {false, ErrorCode} -> NewPlayer2 = NewPlayer, RewardList = [];
        {true, NewPlayer2, RewardList} -> ErrorCode = ?SUCCESS
    end,
    % ?INFO("~p 18107 ErrorCode:~p", [?MODULE, ErrorCode]),
    lib_server_send:send_to_sid(Sid, pt_181, Cmd, [ErrorCode, Count, RewardList]),
    {ok, NewPlayer2};

%% 龍紋槽位升級
handle(Cmd = 18108, #player_status{sid = Sid} = Player, [Pos]) ->
    case lib_dragon:up_pos_lv(Player, Pos) of
        {false, ErrorCode, NewPlayer} -> PosLv = 0;
        {true, NewPlayer, PosLv} -> 
            lib_train_act:dragon_train_power_up(NewPlayer), 
            ErrorCode = ?SUCCESS
    end,
    % ?INFO("~p 18108 ErrorCode:~p", [?MODULE, ErrorCode]),
    lib_server_send:send_to_sid(Sid, pt_181, Cmd, [ErrorCode, Pos, PosLv]),
    {ok, NewPlayer};

%% 龍紋槽位降級
handle(Cmd = 18109, #player_status{sid = Sid} = Player, [Pos]) ->
    case lib_dragon:down_pos_lv(Player, Pos) of
        {false, ErrorCode} -> NewPlayer = Player, PosLv = 0;
        {true, NewPlayer, PosLv} -> ErrorCode = ?SUCCESS
    end,
    lib_server_send:send_to_sid(Sid, pt_181, Cmd, [ErrorCode, Pos, PosLv]),
    {ok, NewPlayer};

%% 龍紋槽位重置
handle(Cmd = 18110, #player_status{sid = Sid} = Player, [Pos]) ->
    case lib_dragon:reset_pos(Player, Pos) of
        {false, ErrorCode, NewPlayer} -> PosLv = 0;
        {true, NewPlayer, PosLv} -> ErrorCode = ?SUCCESS
    end,
    lib_server_send:send_to_sid(Sid, pt_181, Cmd, [ErrorCode, Pos, PosLv]),
    {ok, NewPlayer};

handle(Cmd = 18111, #player_status{sid = Sid, dragon = StatusDragon}, []) ->
    #status_dragon{echo_combat_power = EchoCombatPower} = StatusDragon,
    lib_server_send:send_to_sid(Sid, pt_181, Cmd, [EchoCombatPower]),
    ok;

handle(Cmd = 18112, #player_status{sid = Sid}, []) ->
    {CrucibleId,OpenTime} = case lib_dragon_crucible:get_next_open_time() of
            {ActId, StarTime} ->{ActId, StarTime};
            _ -> {0,0}
        end,
    ?PRINT("OpenTime:~p~n",[OpenTime]),
    lib_server_send:send_to_sid(Sid, pt_181, Cmd, [CrucibleId, OpenTime]),
    ok;

handle(Cmd = 18113, #player_status{sid = Sid} = Player, [GoodsAutoId, Location]) ->
    % ?PRINT("18113    GoodsAutoId:~p~n",[GoodsAutoId]),
    GoodsStatus = lib_goods_do:get_goods_status(),
    GoodsInfo = lib_goods_api:get_goods_info(GoodsAutoId, GoodsStatus),
    % ?PRINT("18113    GoodsAutoId:~p~n",[GoodsInfo]),
    PackList = pp_goods:pack_goods_list(Player, GoodsStatus, [GoodsInfo], dragon),
    lib_server_send:send_to_sid(Sid, pt_181, Cmd, [Location, PackList]),
    ok;

handle(_Cmd, _Player, _Data) ->
    {error, atom_to_list(?MODULE) ++ " no match"}.