%%%-------------------------------------------------------------------
%%% @author whao
%%% @copyright (C) 2019, <SuYou Game>
%%% @doc
%%%     天天冒险
%%% @end
%%% Created : 03. 五月 2019 22:07
%%%-------------------------------------------------------------------
-module(pp_adventure).
-author("whao").

%% API
-export([handle/3]).
-include("server.hrl").
-include("common.hrl").
-include("hero_halo.hrl").
-include("adventure.hrl").
-include("errcode.hrl").
-include("def_module.hrl").
-include("figure.hrl").
-include("vip.hrl").
-include("counter_global.hrl").

%% 请求活动状态
handle(Cmd = 42700, Player, []) ->
    OpenList = lib_adventure_util:get_open(),
    ProData = case OpenList == [] of
                  true -> [0, 0, 0];
                  false ->
                      Info = hd(OpenList),
                      [
                          Info#adventure_info_cfg.stage,
                          Info#adventure_info_cfg.start_time,
                          Info#adventure_info_cfg.end_time
                      ]
              end,
    {ok, Bin} = pt_427:write(Cmd, ProData),
    lib_server_send:send_to_uid(Player#player_status.id, Bin);



%% 界面
handle(Cmd = 42701, #player_status{id = RoleId} = Player, []) ->
    #player_status{status_adventure = StatusAdven, figure = #figure{vip_type = _VipType, vip = _Vip}} = Player,
    #status_adventure{
        circle = Circle, % 当前圈数
        location = Location % 当前位置
    } = StatusAdven,
    ResetTimes = mod_daily:get_count(RoleId, ?MOD_ADVENTURE, ?ADVEN_RESET_NUM),
    HaloExtraTimes = lib_hero_halo:get_halo_extra_times(Player, ?HALO_ADVENTURE_TIMES),
    ThrowTimes = mod_daily:get_count(RoleId, ?MOD_ADVENTURE, ?ADVEN_THROW_NUM),
    UseFreeTimes = mod_daily:get_count(RoleId, ?MOD_ADVENTURE, ?ADVEN_FREE_RESET_NUM),
    ExtraFreeTimes = mod_daily:get_count(RoleId, ?MOD_ADVENTURE, ?ADVEN_FREE_THROW_NUM),
    %% 当前圈数, 位置, 已重置次数, 已投掷次数
    {ok, Bin} = pt_427:write(Cmd, [Circle, Location, ResetTimes, ThrowTimes, HaloExtraTimes - UseFreeTimes, ExtraFreeTimes]),
    lib_server_send:send_to_uid(Player#player_status.id, Bin);


%% 投骰子
handle(Cmd = 42702, Player, [IsCheap]) ->
    case ?ONE_DAY_SECONDS - utime:get_seconds_from_midnight() > 15 orelse utime:get_seconds_from_midnight() < 15 of
        true-> %% 跨零点前后做一个判断处理
            case lib_adventure:adventure_throw(IsCheap, Player) of
                {false, Reason} ->
                    {ok, BinData} = pt_427:write(Cmd, [Reason, 0, 0, 0, [], []]),
                    lib_server_send:send_to_sid(Player#player_status.sid, BinData),
                    {ok, Player};
                {ok, NewPlayer, Circle, Location, Point, TurnGoodsList, GainGoodsList} ->
                    {ok, BinData} = pt_427:write(Cmd, [?SUCCESS, Circle, Location, Point, TurnGoodsList, GainGoodsList]),
                    lib_server_send:send_to_sid(Player#player_status.sid, BinData),
                    {ok, NewPlayer}
            end;
        false ->
            {ok, BinData} = pt_427:write(Cmd, [?ERRCODE(err427_time_not_enough), 0, 0, 0, [], []]),
            lib_server_send:send_to_sid(Player#player_status.sid, BinData),
            {ok, Player}
    end;



%% 重置骰子
handle(Cmd = 42703, Player, []) ->
    case lib_adventure:adventure_reset(Player) of
        {false, Res} ->
            {ok, BinData} = pt_427:write(Cmd, [Res, 0, 0]),
            lib_server_send:send_to_sid(Player#player_status.sid, BinData),
            {ok, Player};
        {ok, NewPlayer, NewCircle} ->
            {ok, BinData} = pt_427:write(Cmd, [?SUCCESS, NewCircle, ?INIT_LOCATION]),
            lib_server_send:send_to_sid(Player#player_status.sid, BinData),
            {ok, NewPlayer}
    end;

%% 商城界面
handle(Cmd = 42704,#player_status{id = RoleId, status_adventure = StatusAdven} = Player, []) ->
    RefreshTimes = mod_daily:get_count(RoleId, ?MOD_ADVENTURE, ?ADVEN_SHOP_RESET_NUM),
    RefreshCost = data_adventure:get_adventure_shop_refresh(RefreshTimes +1) ,
    #status_adventure{shop_goods = ShopGoods, last_time = LastTime} = StatusAdven,
    NowTime = utime:unixtime(),
    NewStatusAdven =
        case utime:is_same_day(NowTime, LastTime) of
            true ->
                StatusAdven ;
            false ->
                lib_adventure:fix_adven_shop(RoleId, ShopGoods, LastTime, StatusAdven)
        end,
    GoodsList = lib_adventure:adven_shop_pack_goods(NewStatusAdven#status_adventure.shop_goods),
    {ok, BinData} = pt_427:write(Cmd, [RefreshTimes, RefreshCost, GoodsList]),
    NewPlayer = Player#player_status{status_adventure = NewStatusAdven},
    lib_server_send:send_to_sid(Player#player_status.sid, BinData),
    {ok, NewPlayer};

%% 商城购买
handle(Cmd = 42705, Player, [GoodsId]) ->
    case lib_adventure:adven_shop_buy(GoodsId, Player) of
        {false, Res} ->
            {ok, BinData} = pt_427:write(Cmd, [Res, GoodsId]),
            lib_server_send:send_to_sid(Player#player_status.sid, BinData),
            {ok, Player};
        {ok, NewPlayer} ->
            {ok, BinData} = pt_427:write(Cmd, [?SUCCESS, GoodsId]),
            lib_server_send:send_to_sid(Player#player_status.sid, BinData),
            {ok, NewPlayer}
    end;



%% 商城手动刷新
handle(Cmd = 42706, Player, []) ->
    case lib_adventure:adven_shop_refresh(Player) of
        {false, Res} ->
            {ok, BinData} = pt_427:write(Cmd, [Res, 0, [], []]),
            lib_server_send:send_to_sid(Player#player_status.sid, BinData),
            {ok, Player};
        {ok, NewPlayer, RefreshTimes, RefreshCost, PackList} ->
            {ok, BinData} = pt_427:write(Cmd, [?SUCCESS, RefreshTimes, RefreshCost, PackList]),
            lib_server_send:send_to_sid(Player#player_status.sid, BinData),
            {ok, NewPlayer}
    end;


handle(_Cmd, _Player, _Data) ->
    {error, "pp_adventure no match~n"}.
