%%-----------------------------------------------------------------------------
%% @Module  :       lib_consume_currency_data.erl
%% @Author  :       lxl
%% @Email   :       
%% @Created :       2020-7-6
%% @Description:    
%%-----------------------------------------------------------------------------

-module (lib_consume_currency_data).
-export ([
    get_consume_between/4
    , update_money_consume/4
    ,clear_cache/1
    ]).

-include ("common.hrl").
-include ("predefine.hrl").
-include ("server.hrl").
-include ("errcode.hrl").
-include ("figure.hrl").

-ifdef(DEV_SERVER).
-define(CHECK_PROCESS(Player), 
    begin 
        Self = self(), 
        Pid = 
        if 
            is_integer(Player) ->
                misc:get_player_process(Player);
            true ->
                Player#player_status.pid
        end,
        if
            Self =/= Pid ->
                ?ERR("CHECK_PROCESS error ~p ~p~n", [[Self, Pid], Player]);
            true ->
                ok
        end,
        Self = Pid
    end).
-else.
-define(CHECK_PROCESS(_), ok).
-endif.

-record (consume, {
    start_time,
    items = []
    }).

-record (currency_item, {
    time,
    cost = 0,
    consume_type
    }).

clear_cache(RoleId) ->
    ?CHECK_PROCESS(RoleId),
    erase(),
    ok.

get_consume_between(RoleId, CurrencyId, StartTime, EndTime) ->
    #consume{items = Items} = get_consume_coin_since(RoleId, CurrencyId, StartTime),
    Sum = lists:sum([C || #currency_item{time = T, cost = C} <- Items, StartTime =< T andalso T < EndTime andalso C > 0]),
    Sum.

update_money_consume(Player, CurrencyId, CostNum, ConsumeType) ->
    ConsumeId = data_goods:get_consume_type(ConsumeType),
    case self() =:= Player#player_status.pid of
        true ->
            update_money_consume(CurrencyId, CostNum, ConsumeId);
        _ ->
            lib_player:apply_cast(Player#player_status.pid, ?APPLY_CAST, ?MODULE, update_money_consume, [CurrencyId, CostNum, ConsumeId])
    end.

update_money_consume(CurrencyId, CostNum, ConsumeId) ->
    NowTime = utime:unixtime(),
    case get({?MODULE, CurrencyId}) of
        undefined ->
            NewD = #consume{items = [#currency_item{time = NowTime, cost = CostNum, consume_type = ConsumeId}], start_time = NowTime};
        #consume{items = Items} = D ->
            NewD = D#consume{items = [#currency_item{time = NowTime, cost = CostNum, consume_type = ConsumeId}|Items]}
    end,
    put({?MODULE, CurrencyId}, NewD).

get_consume_coin_since(RoleId, CurrencyId, StartTime) ->
    ?CHECK_PROCESS(RoleId),
    case get({?MODULE, CurrencyId}) of
        undefined ->
            load_and_combine_currency(RoleId, CurrencyId, StartTime, utime:unixtime(), #consume{});
        #consume{start_time = STime} = D when STime > StartTime ->
            load_and_combine_currency(RoleId, CurrencyId, StartTime, STime, D);
        D ->
            D
    end.

load_and_combine_currency(RoleId, CurrencyId, StartTime, EndTime, #consume{items = Items} = CurrencyCache) ->
    SQL = io_lib:format("SELECT `type`, `value`, `time` FROM `log_consume_currency` WHERE `player_id`=~p AND `time` >= ~p AND `time` < ~p AND currency_id=~p ", [RoleId, StartTime, EndTime, CurrencyId]),
    NewItems = [#currency_item{time = T, cost = C, consume_type = CT} || [CT, C, T] <- db:get_all(SQL)],
    NewCache = CurrencyCache#consume{start_time = StartTime, items = NewItems ++ Items},
    put({?MODULE, CurrencyId}, NewCache),
    NewCache.