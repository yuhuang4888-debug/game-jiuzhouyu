%% ---------------------------------------------------------
%% Author:  lxl
%% Email:   
%% Created: 2020-5-18
%% Description: 物品掉落限制数据(本服和跨服)
%% --------------------------------------------------------
-module(mod_drop_statistics).
-export([start_link/0, get_count/1, set_count/1, server_merge/2]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
-include("drop.hrl").
-include("common.hrl").
-include("errcode.hrl").

-record(drop_limit_goods, {
        key = 0,
        owner_id = 0,      % 服id/玩家id
        mod = 0,
        sub_mod = 0,
        goods_id = 0,
        num = 0,
        first_time = 0    % 第一次掉落时间
    }).

%% Args : {LimitType, OwnerId, LimitDay, GoodsL}
%% GoodsL: [{Mod, SubMod, GoodsTypeId}]
get_count(Args) ->
    gen_server:call(?MODULE, {get_count, Args}).

%% Args : {LimitType, OwnerId, GoodsL}
%% GoodsL: [{{Mod, SubMod, GoodsTypeId}, Num}]
set_count(Args) ->
    gen_server:cast(?MODULE, {set_count, Args}).

server_merge(ServerId, MergeSerIds) ->
    gen_server:cast(?MODULE, {server_merge, ServerId, MergeSerIds}).

%% -----------------------------------------------------------------------

start_link() ->
    gen_server:start_link({local,?MODULE}, ?MODULE, [], []).

init([]) ->
    init_drop_limit_data(),
    {ok, []}.

handle_call(Req, From, State) ->
    case catch do_handle_call(Req, From, State) of
        {'EXIT', _R} ->
            ?ERR("Req Error:~p~n", [[Req, _R]]),
            {reply, ok, State};
        Res ->
            Res
    end.

handle_cast(Msg, State) ->
    case catch do_handle_cast(Msg, State) of
        {'EXIT', _R} ->
            ?ERR("Msg Error:~p~n", [[Msg, _R]]),
            {noreply, State};
        Res ->
            Res
    end.

handle_info(Info, State) ->
    case catch do_handle_info(Info, State) of
        {'EXIT', _R} ->
            ?ERR("Info Error:~p~n", [[Info, _R]]),
            {noreply, State};
        Res ->
            Res
    end.

do_handle_cast({set_count, Args}, State) ->
    {LimitType, OwnerId, GoodsL} = Args,
    DropLimitData = get_drop_limit_data(LimitType),
    NowTime = utime:unixtime(),
    FirstTime = utime:unixdate(NowTime),
    F = fun({Id, NewNum}, SaveList) ->
        {Mod, SubMod, GoodsTypeId} = Id,
        Key = {Mod, SubMod, OwnerId, GoodsTypeId},
        case maps:get(Key, DropLimitData, false) of
           false -> 
                NewDropLimitGoods = make(drop_limit_goods, [Mod, SubMod, OwnerId, GoodsTypeId, FirstTime, NewNum]);
           #drop_limit_goods{} = DropLimitGoods ->
                NewDropLimitGoods = DropLimitGoods#drop_limit_goods{num = NewNum}
        end,
        [NewDropLimitGoods|SaveList]
    end,
    SaveList = lists:foldl(F, [], GoodsL),
    save_list(LimitType, SaveList),
    {noreply, State};

do_handle_cast({server_merge, ServerId, MergeSerIds}, State) ->
    DelServerList = lists:delete(ServerId, MergeSerIds),
    combine_server_drop_when_merge(ServerId, DelServerList, ?DROP_LIMIT_ID_SERVER),
    {noreply, State};


do_handle_cast(_Msg, State) ->
    {noreply, State}.

do_handle_info(_Info, State) ->
    {noreply, State}.

do_handle_call({get_count, Args}, _From, State) ->
    {LimitType, OwnerId, LimitDay, GoodsL} = Args,
    DropLimitData = get_drop_limit_data(LimitType),
    LimitSecond = LimitDay*?ONE_DAY_SECONDS,
    NowTime = utime:unixtime(),
    F = fun({Mod, SubMod, GoodsTypeId}=Id, {Acc, SaveList}) ->
        Key = {Mod, SubMod, OwnerId, GoodsTypeId},
        case maps:get(Key, DropLimitData, false) of
           false -> {[{Id, 0}|Acc], SaveList};
           #drop_limit_goods{first_time = FirstTime, num = Num} = DropLimitGoods ->
               if
                   FirstTime + LimitSecond > NowTime -> {[{Id, Num}|Acc], SaveList};
                   true ->
                       NewFirstTime = utime:unixdate(NowTime),
                       NewDropLimitGoods = DropLimitGoods#drop_limit_goods{first_time = NewFirstTime, num = 0},
                       {[{Id, 0}|Acc], [NewDropLimitGoods|SaveList]}
               end
       end
    end,
    {ReplyList, SaveList} = lists:foldl(F, {[], []}, GoodsL),
    save_list(LimitType, SaveList),
    {reply, ReplyList, State};

do_handle_call(_Req, _From, State) ->
    {reply, ok, State}.


terminate(_Reason, Status) ->
    ?ERR("~p is terminate:~p", [?MODULE, _Reason]),
    {ok, Status}.

code_change(_OldVsn, Status, _Extra)->
    {ok, Status}.


init_drop_limit_data() ->
    GetSql = usql:select(drop_limit_kf, [module, sub_mod, owner_id, goods_id, first_time, num], all),
    case db:get_all(GetSql) of 
        [] -> skip;
        DbRows ->
            DataMap = init_drop_limit_data_do(DbRows, #{}),
            lists:foreach(fun({LimitType, DropLimitData}) -> update_drop_limit_data(LimitType, DropLimitData) end, maps:to_list(DataMap))
    end.

init_drop_limit_data_do([], DataMap) -> DataMap;
init_drop_limit_data_do([[Mod, SubMod, OwnerId, GoodsTypeId, FirstTime, Num]|DbRows], DataMap) ->
    case data_drop_limit:get_goods_limit(?TYPE_GOODS, GoodsTypeId) of
        #base_drop_limit{limit_type = LimitType} ->
            DropLimitData = maps:get(LimitType, DataMap, #{}),
            DropLimitGoods = make(drop_limit_goods, [Mod, SubMod, OwnerId, GoodsTypeId, FirstTime, Num]),
            NewDropLimitData = maps:put(DropLimitGoods#drop_limit_goods.key, DropLimitGoods, DropLimitData),
            NewDataMap = maps:put(LimitType, NewDropLimitData, DataMap),
            init_drop_limit_data_do(DbRows, NewDataMap);
        _ ->
            init_drop_limit_data_do(DbRows, DataMap)
    end.

save_list(_LimitType, []) -> ok;
save_list(LimitType, SaveList) ->   
    DropLimitData = get_drop_limit_data(LimitType),
    F = fun(DropLimitGoods, Map) -> maps:put(DropLimitGoods#drop_limit_goods.key, DropLimitGoods, Map) end,
    NewDropLimitGoods = lists:foldl(F, DropLimitData, SaveList),
    update_drop_limit_data(LimitType, NewDropLimitGoods),
    db_save_list(SaveList).


combine_server_drop_when_merge(_ServerId, [], _LimitType) -> ok;
combine_server_drop_when_merge(ServerId, DelServerList, LimitType) ->
    DropLimitData = get_drop_limit_data(LimitType),
    F = fun(Key, DropLimitGoods, {Map, DelList, SaveList}) ->
        {Mod, SubMod, OwnerId, GoodsTypeId} = Key,
        case lists:member(OwnerId, DelServerList) of 
            true ->
                NewKey = {Mod, SubMod, ServerId, GoodsTypeId},
                %% 删除被合服的数据
                Map1 = maps:remove(Key, Map),
                %% 更新主服数据
                case maps:get(NewKey, Map1, false) of 
                    false -> NewDropLimitGoods = DropLimitGoods#drop_limit_goods{key = NewKey, owner_id = ServerId};
                    #drop_limit_goods{num = OldNum} = OldDropLimitGoods ->
                        NewDropLimitGoods = OldDropLimitGoods#drop_limit_goods{num = OldNum + DropLimitGoods#drop_limit_goods.num}
                end,
                NewMap = maps:put(NewKey, NewDropLimitGoods, Map1),
                {NewMap, [Key|DelList], [NewDropLimitGoods|SaveList]};
            _ ->
                {Map, DelList, SaveList}
        end
    end,
    {NewDropLimitData, DelList, SaveList} = maps:fold(F, {DropLimitData, [], []}, DropLimitData),
    update_drop_limit_data(LimitType, NewDropLimitData),
    db_del_list_by_key(DelList),
    db_save_list(SaveList),
    ok.


make(drop_limit_goods, [Mod, SubMod, OwnerId, GoodsTypeId, FirstTime, Num]) ->
    #drop_limit_goods{
        key = {Mod, SubMod, OwnerId, GoodsTypeId},
        mod = Mod,
        sub_mod = SubMod,
        owner_id = OwnerId,      % 服id/玩家id
        goods_id = GoodsTypeId,
        num = Num,
        first_time = FirstTime    
    }.

get_drop_limit_data(LimitType) ->
    case get(?P_DROP_LIMIT_KEY(LimitType)) of 
        undefined -> #{};
        DropLimitData -> DropLimitData
    end.

update_drop_limit_data(LimitType, DropLimitData) ->
    put(?P_DROP_LIMIT_KEY(LimitType), DropLimitData).

db_save_list([]) -> ok;
db_save_list(SaveList) ->
    List = [ [Mod, SubMod, OwnerId, GoodsTypeId, FirstTime, Num]
        ||#drop_limit_goods{mod = Mod, sub_mod = SubMod, owner_id = OwnerId, goods_id = GoodsTypeId, num = Num, first_time = FirstTime} <- SaveList],
    Sql = usql:replace(drop_limit_kf, [module, sub_mod, owner_id, goods_id, first_time, num], List),
    db:execute(Sql).

db_del_list_by_key([]) -> ok;
db_del_list_by_key(DelKeyList) ->
    F = fun({Mod, SubMod, OwnerId, GoodsTypeId}, StrList) ->
        SubString = io_lib:format("(module=~p and sub_mod=~p and owner_id=~p and goods_id=~p)", [Mod, SubMod, OwnerId, GoodsTypeId]),
        case StrList == [] of 
            true -> SubString ++ StrList;
            _ ->
                SubString ++ " or " ++ StrList
        end
    end,
    DelString = lists:foldl(F, "", DelKeyList),
    Sql = io_lib:format(<<"delete from `drop_limit_kf` where ~s">>, [DelString]),
    db:execute(Sql).
