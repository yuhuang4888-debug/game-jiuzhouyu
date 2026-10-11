% %% ---------------------------------------------------------------------------
% %% @doc mod_kf_group_buy
% %% @author 
% %% @since  
% %% @deprecated  
% %% ---------------------------------------------------------------------------
-module(mod_kf_group_buy).

-export([init/1,handle_call/3,handle_cast/2,handle_info/2,terminate/2,code_change/3]).
-export([

    ]).
-compile(export_all).
-include("custom_act.hrl").
-include("custom_act_list.hrl").
-include("common.hrl").
-include("errcode.hrl").
-include("def_fun.hrl").
-include("def_module.hrl").
-include("figure.hrl").
-include("goods.hrl").
-include("language.hrl").
-include("chat.hrl").
%%-----------------------------

act_start(ActInfo) ->
    gen_server:cast(?MODULE, {act_start, ActInfo}).

act_end(ActInfo) ->
    gen_server:cast(?MODULE, {act_end, ActInfo}).

send_gpbuy_info(Args) ->
    gen_server:cast(?MODULE, {send_gpbuy_info, Args}).

send_gpbuy_records(Args) ->
    gen_server:cast(?MODULE, {send_gpbuy_records, Args}).

purchase_gp_goods_first(Args) ->
    gen_server:call(?MODULE, {purchase_gp_goods_first, Args}).

gm_clear(Type, SubType) ->
    gen_server:cast(?MODULE, {gm_clear, Type, SubType}).

purchase_gp_goods_tail(Args) ->
    gen_server:call(?MODULE, {purchase_gp_goods_tail, Args}).
%% 跨服团购喊话
group_buy_shout(Args) ->
    gen_server:cast(?MODULE, {'group_buy_shout', Args}).

%% 秘籍清空所有预定等记录
gm_reset_group_buy() ->
    gen_server:cast(?MODULE, {'gm_reset_group_buy'}).

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

handle_call(Request, From, State) ->
    case catch do_handle_call(Request, From, State) of
        {reply, Reply, NewState} ->
            {reply, Reply, NewState};
        Reason ->
            ?ERR("handle_call Request: ~p, Reason=~p~n", [Request, Reason]),
            {reply, error, State}
    end.

handle_cast(Msg, State) ->
    case catch do_handle_cast(Msg, State)of
        {noreply, NewState} ->
            {noreply, NewState};
        Reason ->
            ?ERR("handle_cast Msg: ~p, Reason:=~p~n",[Msg, Reason]),
            {noreply, State}
    end.

handle_info(Info, State) ->
    case catch do_handle_info(Info, State)of
        {noreply, NewState} ->
            {noreply, NewState};
        Reason ->
            ?ERR("handle_info error: ~p, Reason:=~p~n",[Info, Reason]),
            {noreply, State}
    end.
terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%% ====================
%% 初始化
%% ====================

init([]) ->
    State = init_do(),
    NewState = check_expire(State),
    {ok, NewState}.

%% ====================
%% hanle_call
%% ==================== 
do_handle_call({purchase_gp_goods_first, Args}, _From, State) -> 
    #gpbuy_state{act_list = ActList, role_map = RoleMap} = State,
    [Type, SubType, GpGoodsId, MaxBuyCount, RoleId, Name, ServerId, ServerNum, _Sid, _Node] = Args,
    NowTime = utime:unixtime(),
    case lists:keyfind({Type, SubType}, #act_info.key, ActList) of 
        #act_info{etime = EndTime} when NowTime < EndTime ->
            case maps:get({RoleId, Type, SubType}, RoleMap, 0) of 
                #gpbuy_role{} = GpBuyRole -> ok;
                _ ->
                    GpBuyRole = lib_kf_group_buy:make(gpbuy_role, [RoleId, Type, SubType, Name, ServerId, ServerNum, [], EndTime]),
                    lib_kf_group_buy:db_replace_group_buy_role(GpBuyRole)
            end,
            #gpbuy_role{buy_list = BuyList} = GpBuyRole,
            case lists:keyfind(GpGoodsId, #gp_goods.gp_goods_id, BuyList) of 
                #gp_goods{} = GpGoods -> ok;
                _ -> GpGoods = lib_kf_group_buy:make(gp_goods, [GpGoodsId, [], 0, [], 0])
            end,
            #gp_goods{first_buy = FirstBuy, first_buy_time = FirstBuyTime} = GpGoods,
            FirstBuyCount = length(FirstBuy),
            case FirstBuyCount < MaxBuyCount of 
                true ->
                    NewFirstBuyTime = ?IF(FirstBuyTime == 0, NowTime, FirstBuyTime),
                    NewFirstBuy = [NowTime-NewFirstBuyTime|FirstBuy],
                    NewGpGoods = GpGoods#gp_goods{first_buy = NewFirstBuy, first_buy_time = NewFirstBuyTime},
                    lib_kf_group_buy:db_replace_group_buy_goods(RoleId, Type, SubType, NewGpGoods),
                    NewBuyList = lists:keystore(GpGoodsId, #gp_goods.gp_goods_id, BuyList, NewGpGoods),
                    NewGpBuyRole = GpBuyRole#gpbuy_role{buy_list = NewBuyList},
                    NewRoleMap = maps:put({RoleId, Type, SubType}, NewGpBuyRole, RoleMap),
                    NewState = State#gpbuy_state{role_map = NewRoleMap},
                    ?PRINT("purchase_gp_goods_first # NewGpBuyRole:~p~n", [NewGpBuyRole]),
                    %% 更新进程字典数据
                    BuyNum = get_buy_num(Type, SubType, GpGoodsId, State),
                    update_buy_num(Type, SubType, GpGoodsId, BuyNum+1),
                    %% 清掉购买记录，等客户端请求时重新刷新
                    erase({buy_record, Type, SubType}),
                    {ok, Bin} = pt_332:write(33230, [Type, SubType, GpGoodsId, BuyNum+1]),
                    mod_clusters_center:apply_to_all_node(lib_server_send, send_to_all, [Bin], 10),
                    Reply = {ok, FirstBuyCount+1, BuyNum+1};
                _ ->
                    NewState = State,
                    Reply = {false, ?ERRCODE(err332_not_buy_count)}
            end,
            {reply, Reply, NewState};
        _ ->
            Reply = {false, ?ERRCODE(err331_act_closed)},
            {reply, Reply, State}
    end;

do_handle_call({purchase_gp_goods_tail, Args}, _From, State) -> 
    #gpbuy_state{act_list = ActList, role_map = RoleMap} = State,
    [Type, SubType, GpGoodsId, RoleId, MoneyArgs] = Args,
    NowTime = utime:unixtime(),
    case lists:keyfind({Type, SubType}, #act_info.key, ActList) of 
        #act_info{etime = EndTime} when NowTime < EndTime ->
            case maps:get({RoleId, Type, SubType}, RoleMap, 0) of 
                #gpbuy_role{buy_list = BuyList} = GpBuyRole ->
                    case lists:keyfind(GpGoodsId, #gp_goods.gp_goods_id, BuyList) of 
                        #gp_goods{} = GpGoods -> 
                            #gp_goods{
                                first_buy = FirstBuy, 
                                tail_buy = TailBuy, tail_buy_time = TailBuyTime
                            } = GpGoods,
                            FirstBuyCount = length(FirstBuy),
                            TailBuyCount = length(TailBuy),
                            case TailBuyCount < FirstBuyCount of 
                                true ->
                                    BuyNum = get_buy_num(Type, SubType, GpGoodsId, State),
                                    case lib_kf_group_buy:check_tail_cost(MoneyArgs, Type, SubType, GpGoodsId, BuyNum) of 
                                        {ok, CostList} ->
                                            NewTailBuyTime = ?IF(TailBuyTime == 0, NowTime, TailBuyTime),
                                            NewTailBuy = [NowTime-NewTailBuyTime|TailBuy],
                                            NewGpGoods = GpGoods#gp_goods{tail_buy = NewTailBuy, tail_buy_time = NewTailBuyTime},
                                            lib_kf_group_buy:db_replace_group_buy_goods(RoleId, Type, SubType, NewGpGoods),
                                            NewBuyList = lists:keystore(GpGoodsId, #gp_goods.gp_goods_id, BuyList, NewGpGoods),
                                            NewGpBuyRole = GpBuyRole#gpbuy_role{buy_list = NewBuyList},
                                            NewRoleMap = maps:put({RoleId, Type, SubType}, NewGpBuyRole, RoleMap),
                                            NewState = State#gpbuy_state{role_map = NewRoleMap},
                                            ?PRINT("purchase_gp_goods_tail # NewGpBuyRole:~p~n", [NewGpBuyRole]),
                                            %% 清掉购买记录，等客户端请求时重新刷新
                                            erase({buy_record, Type, SubType}),
                                            Reply = {ok, TailBuyCount+1, BuyNum, CostList};
                                        {false, Res} ->
                                            NewState = State,
                                            Reply = {false, Res}
                                    end;
                                _ ->
                                    NewState = State,
                                    Reply = {false, ?ERRCODE(err332_no_tail_count)}
                            end,
                            {reply, Reply, NewState};
                        _ -> 
                            Reply = {false, ?ERRCODE(err331_not_buy)},
                            {reply, Reply, State}
                    end;
                _ ->
                    Reply = {false, ?ERRCODE(err331_not_buy)},
                    {reply, Reply, State}
            end;
        _ ->
            Reply = {false, ?ERRCODE(err331_act_closed)},
            {reply, Reply, State}
    end;

do_handle_call(_Request, _From, State) -> {reply, ok, State}.

%% ====================
%% hanle_cast
%% ====================
do_handle_cast({act_start, ActInfo}, State) -> 
    #gpbuy_state{act_list = ActList} = State,
    case lists:keymember(ActInfo#act_info.key, #act_info.key, ActList) of 
        true -> NewActList = ActList;
        _ -> NewActList = [ActInfo|ActList]
    end,
    %?PRINT("act_start # NewActList:~p~n", [NewActList]),
    {noreply, State#gpbuy_state{act_list = NewActList}};

do_handle_cast({act_end, ActInfo}, State) -> 
    #gpbuy_state{act_list = ActList} = State,
    #act_info{key = {Type, SubType}} = ActInfo,
    %% 结算
    NewActList = lists:keydelete(ActInfo#act_info.key, #act_info.key, ActList),
    NewState = handle_act_end(State#gpbuy_state{act_list = NewActList}, Type, SubType),
    ?PRINT("act_end # NewState:~p~n", [NewState]),
    {noreply, NewState};

do_handle_cast({gm_clear, Type, SubType}, State) -> 
    #gpbuy_state{act_list = ActList} = State,
    %% 结算
    NewActList = lists:keydelete({Type, SubType}, #act_info.key, ActList),
    NewState = handle_act_end(State#gpbuy_state{act_list = NewActList}, Type, SubType),
    %?PRINT("act_end # NewState:~p~n", [NewState]),
    {noreply, NewState};

do_handle_cast({send_gpbuy_info, Args}, State) ->
    #gpbuy_state{act_list = _ActList, role_map = RoleMap, shout_time_map = TimeMap} = State,
    [Type, SubType, RoleId, Sid, Node] = Args,
    GpBuyGoodsIdList = lib_custom_act_util:get_act_reward_grade_list(Type, SubType),
    case maps:get({RoleId, Type, SubType}, RoleMap, 0) of
        #gpbuy_role{buy_list = BuyList} -> ok;
        _ ->
           BuyList = []
    end,
    F = fun(GpGoodsId, Acc) ->
        case lists:keyfind(GpGoodsId, #gp_goods.gp_goods_id, BuyList) of
            #gp_goods{first_buy = FirstBuy, tail_buy = TailBuy} ->
                FirstBuyCount = length(FirstBuy),
                TailBuyCount = length(TailBuy);
            _ ->
                FirstBuyCount = 0, TailBuyCount = 0
        end,
        BuyNum = get_buy_num(Type, SubType, GpGoodsId, State),
        [{GpGoodsId, FirstBuyCount, TailBuyCount, BuyNum}|Acc]
    end,
    SendList = lists:foldl(F, [], GpBuyGoodsIdList),
    LastShoutTime = maps:get({Type, SubType, RoleId}, TimeMap, 0),
    {ok, Bin} = pt_332:write(33227, [Type, SubType, SendList, LastShoutTime]),
    lib_server_send:send_to_sid(Node, Sid, Bin),
    %?PRINT("send_gpbuy_info # SendList:~p~n", [SendList]),
    {noreply, State};

do_handle_cast({send_gpbuy_records, Args}, State) -> 
    [Type, SubType, _RoleId, Sid, Node] = Args,
    RecordList = get_record_list(Type, SubType, State),
    {ok, Bin} = pt_332:write(33228, [Type, SubType, RecordList]),
    lib_server_send:send_to_sid(Node, Sid, Bin),
    %?PRINT("send_gpbuy_records # RecordList:~p~n", [RecordList]),
    {noreply, State};

do_handle_cast({server_info_change, ServerId, KvList}, State) ->
    NewState = lib_kf_group_buy:server_info_change(ServerId, KvList, State),
    {noreply, NewState};

do_handle_cast({'group_buy_shout', Args}, State) ->
    NewState = group_buy_shout(Args, State),
    {noreply, NewState};

do_handle_cast({'gm_reset_group_buy'}, _State) ->
    Sql = <<"truncate gpbuy_goods">>,
    Sql2 = <<"truncate gpbuy_role">>,
    db:execute(Sql),
    db:execute(Sql2),
    {ok, NewState} = init([]),
    erase(),
    {noreply, NewState};

do_handle_cast(_Msg, State) -> {noreply, State}.

%% ====================
%% hanle_info
%% ====================


do_handle_info(_Info, State) -> {noreply, State}.


init_do() ->
    RoleMap = init_gpbuy_role(),
    NewRoleMap = init_gpbuy_goods(RoleMap),
    %?PRINT("init_do # NewRoleMap:~p~n", [NewRoleMap]),
    #gpbuy_state{role_map = NewRoleMap}.

init_gpbuy_role() ->
    case lib_kf_group_buy:db_select_group_buy_role() of 
        [] -> #{};
        DbList ->
            F = fun([RoleId, Type, SubType, Name, ServerId, ServerNum, EndTime], Map) ->
                GpBuyRole = lib_kf_group_buy:make(gpbuy_role, [RoleId, Type, SubType, Name, ServerId, ServerNum, [], EndTime]),
                maps:put({RoleId, Type, SubType}, GpBuyRole, Map)
            end,
            RoleMap = lists:foldl(F, #{}, DbList),
            RoleMap
    end.

init_gpbuy_goods(RoleMap) ->
    case lib_kf_group_buy:db_select_group_buy_goods() of 
        [] -> RoleMap;
        DbList ->
            F = fun([RoleId, Type, SubType, GpGoodsId, FirstBuy, FirstBuyTime, TailBuy, TailBuyTime], Map) ->
                GpGoods = lib_kf_group_buy:make(gp_goods, [GpGoodsId, util:bitstring_to_term(FirstBuy), FirstBuyTime, util:bitstring_to_term(TailBuy), TailBuyTime]),
                case maps:get({RoleId, Type, SubType}, Map, 0) of 
                    #gpbuy_role{buy_list = BuyList} = GpBuyRole ->
                        NewGpBuyRole = GpBuyRole#gpbuy_role{buy_list = [GpGoods|BuyList]},
                        maps:put({RoleId, Type, SubType}, NewGpBuyRole, Map);
                    _ -> Map
                end
            end,
            NewRoleMap = lists:foldl(F, RoleMap, DbList),
            NewRoleMap
    end.

check_expire(State) ->
    #gpbuy_state{role_map = RoleMap} = State,
    NowTime = utime:unixtime(),
    %% 将已经过期的活动清掉
    F = fun(_, GpBuyRole, List) ->
        #gpbuy_role{key = {_RoleId, Type, SubType}, end_time = EndTime} = GpBuyRole,
        %% 只要有一个过期，认为所有的都过期
        case NowTime > EndTime of 
            true ->
                case lists:member({Type, SubType}, List) of 
                    true -> List;
                    _ -> [{Type, SubType}|List]
                end;
            _ -> List 
        end 
    end,
    ExpireList = maps:fold(F, [], RoleMap),
    F2 = fun({Type, SubType}, TmpState) ->
        handle_act_end(TmpState, Type, SubType)
    end,
    lists:foldl(F2, State, ExpireList).
    
get_buy_num(Type, SubType, GpGoodsId, State) ->
    case get({buy_num, Type, SubType, GpGoodsId}) of 
        undefined ->
            Num = get_buy_num_do(Type, SubType, GpGoodsId, State),
            update_buy_num(Type, SubType, GpGoodsId, Num),
            Num;
        Num ->
            Num
    end.

get_buy_num_do(Type, SubType, GpGoodsId, State) ->
    #gpbuy_state{role_map = RoleMap} = State,
    F = fun(_, GpBuyRole, Acc) ->
        #gpbuy_role{key = {_RoleId, Type1, SubType1}, buy_list = BuyList} = GpBuyRole,
        case Type1 == Type andalso SubType1 == SubType of 
            true ->
                case lists:keyfind(GpGoodsId, #gp_goods.gp_goods_id, BuyList) of 
                    #gp_goods{first_buy = FirstBuy} -> Acc + length(FirstBuy);
                    _ -> Acc
                end;
            _ -> Acc
        end
    end,
    maps:fold(F, 0, RoleMap).

update_buy_num(Type, SubType, GpGoodsId, BuyNum) ->
    put({buy_num, Type, SubType, GpGoodsId}, BuyNum).

get_record_list(Type, SubType, State) ->
    case get({buy_record, Type, SubType}) of 
        undefined ->
            RecordList = get_record_list_do(Type, SubType, State),
            put({buy_record, Type, SubType}, RecordList),
            RecordList;
        RecordList ->
            RecordList
    end.

get_record_list_do(Type, SubType, State) ->
    #gpbuy_state{role_map = RoleMap} = State,
    F = fun(_, GpBuyRole, Acc) ->
        #gpbuy_role{
            key = {RoleId, Type1, SubType1}, role_name = Name, server_id = ServerId,
            server_num = ServerNum, buy_list = BuyList
        } = GpBuyRole,
        case Type1 == Type andalso SubType1 == SubType of 
            true ->
                [{RoleId, Name, ServerId, ServerNum, GpGoodsId, FirstBuy, FirstBuyTime, TailBuy, TailBuyTime} 
                    ||#gp_goods{
                        gp_goods_id = GpGoodsId, first_buy = FirstBuy, first_buy_time = FirstBuyTime,
                        tail_buy = TailBuy, tail_buy_time = TailBuyTime
                    } <- BuyList, FirstBuyTime > 0] ++ Acc;
            _ -> Acc
        end
    end,
    maps:fold(F, [], RoleMap).

handle_act_end(State, Type, SubType) ->
    #gpbuy_state{role_map = RoleMap} = State,
    F = fun(_, GpBuyRole, {AccMap, Map}) ->
        #gpbuy_role{key = {RoleId, Type1, SubType1}, server_id = ServerId, buy_list = BuyList} = GpBuyRole,
        case Type1 == Type andalso SubType1 == SubType of 
            true ->
                F2 = fun(GpGoods, AccList) ->
                    #gp_goods{gp_goods_id = GpGoodsId, first_buy = FirstBuy, tail_buy = TailBuy} = GpGoods,
                    FirstBuyCount = length(FirstBuy), TailBuyCount = length(TailBuy),
                    case FirstBuyCount > TailBuyCount of 
                        true ->
                            LeftCount = FirstBuyCount - TailBuyCount,
                            [{GpGoodsId, LeftCount}|AccList];
                        _ -> AccList 
                    end 
                end,
                ReturnGradeList = lists:foldl(F2, [], BuyList),
                case ReturnGradeList =/= [] of 
                    true ->
                        OldList = maps:get(ServerId, AccMap, []),
                        {maps:put(ServerId, [{RoleId, ReturnGradeList}|OldList], AccMap), Map};
                    _ ->
                        {AccMap, Map}
                end;
            _ -> {AccMap, maps:put({RoleId, Type1, SubType1}, GpBuyRole, Map)}
        end 
    end,
    {ServerReturnMap, NewRoleMap} = maps:fold(F, {#{}, #{}}, RoleMap),
    spawn(fun() -> delay_compensate_first_buy(Type, SubType, ServerReturnMap) end),
    spawn(fun() ->
        lib_kf_group_buy:db_clear_group_buy_role(Type, SubType),
        lib_kf_group_buy:db_clear_group_buy_goods(Type, SubType)
    end),
    ?PRINT("handle_act_end # ServerReturnMap:~p~n", [ServerReturnMap]),
    State#gpbuy_state{role_map = NewRoleMap}.

delay_compensate_first_buy(Type, SubType, ServerReturnMap) ->
    F = fun(ServerId, ReturnList, Acc) ->
        Acc rem 5 == 0 andalso timer:sleep(200),
        mod_clusters_center:apply_cast(ServerId, lib_kf_group_buy, compensate_first_buy, [Type, SubType, ReturnList]),
        Acc+1
    end,
    maps:fold(F, 1, ServerReturnMap).

%% 跨服团购喊话
%% 跨服团购喊话功能
group_buy_shout([Type, SubType, PlayerId, ServerId, GradeId, CfgCdTime|_], State) ->
    #gpbuy_state{ shout_time_map = ShoutTimeMap, act_list = ActList} = State,
    NowSec = utime:unixtime(),
    case lists:keyfind({Type, SubType}, #act_info.key, ActList) of
        #act_info{ etime = EndTime } when NowSec < EndTime  ->
            LastShoutTime = maps:get({Type, SubType, PlayerId}, ShoutTimeMap, 0),
            case LastShoutTime == 0 orelse (LastShoutTime + CfgCdTime) =< NowSec of
                true ->
                    GradeSumNum = get_buy_num(Type, SubType, GradeId, State),
                    do_group_buy_shout(Type, SubType, GradeId, GradeSumNum, ServerId, PlayerId),
                    NewShoutTimeMap = maps:put({Type, SubType, PlayerId}, NowSec,ShoutTimeMap),
                    {ok, BinData} = pt_332:write(33267, [?SUCCESS, Type, SubType, NowSec]);
                _ ->
                    {ok, BinData} = pt_332:write(33267, [?ERRCODE(err151_shout_id_cd), Type, SubType, 0]),
                    NewShoutTimeMap = ShoutTimeMap
            end,
            mod_clusters_center:apply_cast(ServerId, lib_server_send, send_to_uid, [PlayerId, BinData]);
        _ ->
           NewShoutTimeMap = ShoutTimeMap
    end,
    State#gpbuy_state{ shout_time_map = NewShoutTimeMap }.

do_group_buy_shout(Type, SubType, GradeId, BuyNum, ServerId, PlayerId) ->
    case lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GradeId) of
        #custom_act_reward_cfg{ condition = Condition, name = GradeName, reward = [{_, GoodsTypeId, Num}|_] } ->
            %% 获取颜色
            case data_goods_type:get(GoodsTypeId) of
                #ets_goods_type{goods_name = GoodsName, color = TvColor} -> ok;
                _ -> GoodsName = [], TvColor = 0
            end,
            if
                GoodsName == [] ->
                    skip;
                true ->
                    #custom_act_cfg{ show_id = ShowID } = lib_custom_act_util:get_act_cfg_info(Type, SubType),
                    %% 计算当前数量对应的折扣
                    case lists:keyfind(discount, 1, Condition) of
                        {_, DisCount} ->
                            {_, BaseCostNum, FirstCostNum, _} = lists:keyfind(cost, 1, Condition),
                            Predicate = fun({NeedNum, _Money}) -> BuyNum >= NeedNum end,
                            {RegularL, NotRegularL} = lists:partition(Predicate, DisCount),
                            case lists:reverse(lists:keysort(1, RegularL)) of
                                [] ->
                                    CurDisCount = float_to_list(util:float_sub(FirstCostNum / BaseCostNum * 10, 2), [{decimals, 1}]);
                                [{_, TailCost}|_] ->
                                    CurDisCount = float_to_list(util:float_sub(TailCost / BaseCostNum * 10, 2), [{decimals, 1}])
                            end,
                            case lists:keysort(1, NotRegularL) of
                                [] ->
                                    %% 最大折扣时
                                    SendTvId = 8,
                                    TvArgs = [TvColor, GoodsTypeId, util:make_sure_binary(GoodsName), Num, CurDisCount, Type, ShowID, GradeId];
                                [{NeedNum, _}|_] ->
                                    %% 未到最大折扣时
                                    NextNum = NeedNum - BuyNum,
                                    SendTvId = 7,
                                    TvArgs = [TvColor, GoodsTypeId, util:make_sure_binary(GoodsName), Num, CurDisCount, NextNum, Type, ShowID, GradeId]
                            end,
                            TemContent = utext:get(?MOD_AC_CUSTOM_OTHER, SendTvId, TvArgs),
                            ApplyArgs = [PlayerId, ?CHAT_CHANNEL_ZONE, 0, TemContent, []],
                            mod_clusters_center:apply_cast(ServerId, lib_chat, send_msg_by_server, ApplyArgs)
                    end
            end;
        _ ->
            skip
    end.
