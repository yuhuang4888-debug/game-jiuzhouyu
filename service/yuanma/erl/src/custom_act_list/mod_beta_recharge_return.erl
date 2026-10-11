%%-----------------------------------------------------------------------------
%% @Module  :       mod_beta_recharge_return
%% @Author  :       lxl
%% @Email   :      
%% @Created :       2020-6-11
%% @Description:    封测充值返还数据记录进程(跨服)
%%-----------------------------------------------------------------------------
-module(mod_beta_recharge_return).

-include("beta_recharge_return.hrl").
-include("common.hrl").
-export([start_link/0]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-compile([export_all]).

-define(TYPE_BETA_RECHARGE_RETURN,  1).        %% 封测活动(充值返利数据)

%% 充值返利的record
-record(accname_beta_recharge_return, {
        accid = 0        
        , accname = 0          % 
        , role_id = 0    % 
        , gold = 0    % 
        , return_gold = 0  %% 返还钻石
        , login_days = 0 
        , role_list = []
    }).

start_link() ->
    gen_server:start_link({global, ?MODULE}, ?MODULE, [], []).

%% ######################################################################################################
%% 封测账号充值记录
request_center_record(ServerId, RoleId, Accid, Accname, TotalGold, Gold, LoginDays, SendType) ->
    gen_server:cast({global, ?MODULE}, {'request_center_record', ServerId, RoleId, Accid, Accname, TotalGold, Gold, LoginDays, SendType}).

request_center_get(Accid, Accname, RoleId, ServerId) ->
    gen_server:cast({global, ?MODULE}, {'request_center_get', Accid, Accname, RoleId, ServerId}).

get_beta_recharge_info(Accid, Accname) ->
    gen_server:call({global, ?MODULE}, {'get_beta_recharge_info', Accid, Accname}).

gm_reset_beta_recharge() ->
    gen_server:cast({global, ?MODULE}, {'gm_reset_beta_recharge'}).

%% ######################################################################################################

init([]) ->
    init(),
    {ok, []}.

handle_cast(Msg, State) ->
    case catch do_handle_cast(Msg, State) of
        {ok, NewState}->
            {noreply, NewState};
        Err ->
            ?ERR("handle_cast Msg:~p error:~p~n", [Msg, Err]),
            {noreply, State}
    end.

handle_info(Info, State) ->
    case catch do_handle_info(Info, State) of
        {ok, NewState}->
            {noreply, NewState};
        Err ->
            ?ERR("handle_info Info:~p error:~p~n", [Info, Err]),
            {noreply, State}
    end.

do_handle_info(_Info, State) -> {ok, State}.

handle_call(Request, _From, State) ->
    case catch do_handle_call(Request, State) of
        {ok, Reply} ->
            {reply, Reply, State};
        Err ->
            ?ERR("handle_call Request:~p error:~p~n", [Request, Err]),
            {noreply, State}
    end.


do_handle_call({'get_beta_recharge_info', Accid, Accname1}, _State) ->
    RechargeData = get_data(?TYPE_BETA_RECHARGE_RETURN),
    Accname = util:make_sure_binary(Accname1),
    AccnameRecharge = maps:get({Accid, Accname}, RechargeData, #accname_beta_recharge_return{accid = Accid, accname = Accname}),
    #accname_beta_recharge_return{
        role_id = SyncRoleId
        , gold = Gold
        , return_gold = ReturnGold
        , login_days = LoginDay
    } = AccnameRecharge,
    if
        SyncRoleId > 0 -> Reply = {0, 0, 0, 0};
        Gold == 0 -> Reply = {0, 0, 0, 0};
        true -> Reply = {1, Gold, ReturnGold, LoginDay}
    end,
    {ok, Reply};

do_handle_call(_Request, _State) -> {ok, ok}.

terminate(_Reason, _State) ->
    ?ERR("~p is terminate:~p", [?MODULE, _Reason]),
    ok.

code_change(_OldVsn, State, _Extra) -> {ok, State}.


do_handle_cast({'request_center_record', ServerId, RoleId, Accid, Accname1, TotalGold, Gold, LoginDays, SendType}, State) ->
    RechargeData = get_data(?TYPE_BETA_RECHARGE_RETURN),
    Accname = util:make_sure_binary(Accname1),
    AccnameRecharge = maps:get({Accid, Accname}, RechargeData, #accname_beta_recharge_return{accid = Accid, accname = Accname}),
    #accname_beta_recharge_return{
        role_id = SyncRoleId
        , gold = OldGold
        , return_gold = OldReturnGold
        , login_days = OldLoginDay
        , role_list = RoleList
    } = AccnameRecharge,
    if
        SyncRoleId > 0 -> skip;
        true ->
            % 因为有可能是不同服,所以要汇总
            SumGold = Gold + OldGold,
            MaxGold = max(TotalGold, SumGold),
            NewLoginDays = max(OldLoginDay, LoginDays),
            NewReturnGold = lib_beta_recharge_return:count_return_gold(MaxGold, NewLoginDays),
            NewRoleList = [{RoleId, ServerId}|lists:keydelete(RoleId, 1, RoleList)], %% 用来同步同账号的不同角色数据
            case Gold > 0 orelse NewReturnGold =/= OldReturnGold of
                true -> %% 充值了才写数据库，不充值只保留在内存中
                    lib_beta_recharge_return:db_beta_recharge_return_replace(Accid, Accname, 0, MaxGold, NewReturnGold, NewLoginDays);
                false -> skip
            end,
            NewAccnameRecharge = AccnameRecharge#accname_beta_recharge_return{gold = MaxGold, return_gold = NewReturnGold, login_days = NewLoginDays, role_list = NewRoleList},
            NewRechargeData = maps:put({Accid, Accname}, NewAccnameRecharge, RechargeData),
            put_data(?TYPE_BETA_RECHARGE_RETURN, NewRechargeData),
            %?PRINT("NewAccnameRecharge : ~p~n", [NewAccnameRecharge]),
            [begin 
                case RoleId1 == RoleId of 
                    true ->
                        mod_clusters_center:apply_cast(ServerId1, lib_beta_recharge_return, back_local_record, [RoleId1, MaxGold, NewReturnGold, NewLoginDays, SendType]);
                    _ ->
                        mod_clusters_center:apply_cast(ServerId1, lib_beta_recharge_return, back_local_record, [RoleId1, MaxGold, NewReturnGold, NewLoginDays])
                end
            end || {RoleId1, ServerId1} <- NewRoleList
            ],
            ok
    end,
    {ok, State};

do_handle_cast({'request_center_get', Accid, Accname1, RoleId, ServerId}, State) ->
    RechargeData = get_data(?TYPE_BETA_RECHARGE_RETURN),
    Accname = util:make_sure_binary(Accname1),
    AccnameRecharge = maps:get({Accid, Accname}, RechargeData, #accname_beta_recharge_return{accid = Accid, accname = Accname}),
    #accname_beta_recharge_return{
        role_id = SyncRoleId
        , gold = Gold
        , return_gold = ReturnGold
        , login_days = LoginDays
    } = AccnameRecharge,
    case SyncRoleId > 0 of 
        true -> %% 已领取
            mod_clusters_center:apply_cast(ServerId, lib_beta_recharge_return, back_local_get, [Accid, Accname, RoleId, SyncRoleId, Gold, ReturnGold, LoginDays]);
        _ -> %%更新数据，玩家领取
            lib_beta_recharge_return:db_beta_recharge_return_replace(Accid, Accname, RoleId, Gold, ReturnGold, LoginDays),
            NewAccnameRecharge = AccnameRecharge#accname_beta_recharge_return{role_id = RoleId},
            NewRechargeData = maps:put({Accid, Accname}, NewAccnameRecharge, RechargeData),
            ?PRINT("NewAccnameRecharge : ~p~n", [NewAccnameRecharge]),
            put_data(?TYPE_BETA_RECHARGE_RETURN, NewRechargeData),
            mod_clusters_center:apply_cast(ServerId, lib_beta_recharge_return, back_local_get, [Accid, Accname, RoleId, RoleId, Gold, ReturnGold, LoginDays])

    end,
    {ok, State};

do_handle_cast({'gm_reset_beta_recharge'}, State) ->
    lib_beta_recharge_return:truncate_beta_recharge_return(),
    put_data(?TYPE_BETA_RECHARGE_RETURN, #{}),
    mod_clusters_center:apply_to_all_node(lib_beta_recharge_return, gm_reset_beta_recharge, []),
    {ok, State};

do_handle_cast(_Msg, State) -> {ok, State}.

init() ->
    TypeList = [?TYPE_BETA_RECHARGE_RETURN],
    F = fun(Type) ->
        do_init(Type)
    end,
    lists:foreach(F, TypeList).

do_init(?TYPE_BETA_RECHARGE_RETURN) ->
    case lib_beta_recharge_return:db_beta_recharge_return_select_all() of 
        [] -> skip;
        DbList ->
            F = fun([Accid, AccnameStr, RoleId, Gold, ReturnGold, LoginDays], Map) ->
                Accname = util:make_sure_binary(AccnameStr),
                AccnameRecharge = #accname_beta_recharge_return{
                    accid = Accid, accname = Accname, role_id = RoleId,
                    gold = Gold, return_gold = ReturnGold, login_days = LoginDays
                },
                maps:put({Accid, Accname}, AccnameRecharge, Map)
            end,
            Data = lists:foldl(F, #{}, DbList),
            %?PRINT("do_init Data : ~p~n", [Data]),
            put_data(?TYPE_BETA_RECHARGE_RETURN, Data)
    end;
do_init(_) ->
    ok.


get_data(Type) ->
    case get({?MODULE, Type}) of 
        undefined -> #{};
        Data -> Data
    end.

put_data(Type, Data) ->
    put({?MODULE, Type}, Data).