%%%--------------------------------------
%%% @Module  : mod_marriage_wedding_mgr
%%% @Author  : huyihao
%%% @Created : 2017.12.5
%%% @Description:  婚姻婚礼管理进程
%%%--------------------------------------
-module(mod_marriage_wedding_mgr).
-behaviour(gen_server).

-include("common.hrl").
-include("boss.hrl").
-include("def_fun.hrl").
-include("def_goods.hrl").
-include("scene.hrl").
-include("errcode.hrl").
-include("predefine.hrl").
-include("marriage.hrl").
-include("language.hrl").
-include("def_module.hrl").
-include("figure.hrl").
-include("role.hrl").
-include("def_id_create.hrl").

-export([start_link/0, stop/0]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
        terminate/2, code_change/3]).
-export([open_wedding_order/1, wedding_order/2, check_wedding_order/3, divorce_success/3,
    wedding_end/2, check_wedding_start_login/1, open_invite_guest/1, do_invite_guest/1, invited_list/1,
    invited_answer/3, open_buy_max/1, check_buy_max/2, do_buy_max/1, ask_invite/1, open_ask_invite/1, answer_ask_invite/3,
    enter_wedding/1, quit_wedding/2, get_wedding_info/2, enter_wedding_login/1, send_wedding_state_info/1,
    kill_trouble_maker_solve/4, collect_mon/6, get_wedding_guest_info/2, get_wedding_tm_info/2, get_wedding_exp_info/2,
    get_wedding_pid/1, open_my_lover/5, guest_buy_card/1, gm_wedding_start/1, gm_wedding_end/1, one_invite_role/1]).

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

stop() ->
    gen_server:cast(?MODULE, {'stop'}).

open_wedding_order(Args) ->
    gen_server:cast(?MODULE, {open_wedding_order, Args}).

wedding_order(RoleId, Args) ->
    gen_server:cast(?MODULE, {wedding_order, RoleId, Args}).

wedding_end(RoleIdM, RoleIdW) ->
    gen_server:cast(?MODULE, {wedding_end, RoleIdM, RoleIdW}).

% propose_success(RoleIdM, RoleIdW, WeddingType, ProposeRoleId) ->
%     gen_server:cast(?MODULE, {propose_success, RoleIdM, RoleIdW, WeddingType, ProposeRoleId}).

send_wedding_state_info(RoleId) ->
    gen_server:cast(?MODULE, {send_wedding_state_info, RoleId}).

divorce_success(RoleIdM, RoleIdW, NowWeddingState) ->
    gen_server:cast(?MODULE, {divorce_success, RoleIdM, RoleIdW, NowWeddingState}).

check_wedding_start_login(RoleId) ->
    gen_server:cast(?MODULE, {check_wedding_start_login, RoleId}).

open_invite_guest(Args) ->
    gen_server:cast(?MODULE, {open_invite_guest, Args}).

do_invite_guest(Args) ->
    gen_server:cast(?MODULE, {do_invite_guest, Args}).

invited_list(RoleIdList) ->
    gen_server:cast(?MODULE, {invited_list, RoleIdList}).

invited_answer(RoleId, RoleIdM, AnswerType) ->
    gen_server:cast(?MODULE, {invited_answer, RoleId, RoleIdM, AnswerType}).

open_buy_max(RoleId) ->
    gen_server:cast(?MODULE, {open_buy_max, RoleId}).

do_buy_max(Args) ->
    gen_server:cast(?MODULE, {do_buy_max, Args}).

ask_invite(Args) ->
    gen_server:cast(?MODULE, {ask_invite, Args}).

open_ask_invite(Args) ->
    gen_server:cast(?MODULE, {open_ask_invite, Args}).

answer_ask_invite(RoleId, RoleName, AnswerAskList) ->
    gen_server:cast(?MODULE, {answer_ask_invite, RoleId, RoleName, AnswerAskList}).

enter_wedding(Args) ->
    gen_server:cast(?MODULE, {enter_wedding, Args}).

enter_wedding_login(Args) ->
    gen_server:cast(?MODULE, {enter_wedding_login, Args}).

quit_wedding(RoleId, RoleIdM) ->
    gen_server:cast(?MODULE, {quit_wedding, RoleId, RoleIdM}).

get_wedding_info(RoleId, RoleIdM) ->
    gen_server:cast(?MODULE, {get_wedding_info, RoleId, RoleIdM}).

kill_trouble_maker_solve(RoleId, RoleIdM, SolveId, MonOnlyId) ->
    gen_server:cast(?MODULE, {kill_trouble_maker_solve, RoleId, RoleIdM, SolveId, MonOnlyId}).

collect_mon(RoleId, MonOnlyId, Mid, RoleIdM, AddAura, Type) ->
    gen_server:cast(?MODULE, {collect_mon, RoleId, MonOnlyId, Mid, RoleIdM, AddAura, Type}).

get_wedding_guest_info(RoleId, RoleIdM) ->
    gen_server:cast(?MODULE, {get_wedding_guest_info, RoleId, RoleIdM}).

get_wedding_tm_info(RoleId, RoleIdM) ->
    gen_server:cast(?MODULE, {get_wedding_tm_info, RoleId, RoleIdM}).

get_wedding_exp_info(RoleId, RoleIdM) ->
    gen_server:cast(?MODULE, {get_wedding_exp_info, RoleId, RoleIdM}).

open_my_lover(RoleId, Type, NowWeddingState, MarriageTime, OtherRid) ->
    gen_server:cast(?MODULE, {open_my_lover, RoleId, Type, NowWeddingState, MarriageTime, OtherRid}).

check_wedding_order(RoleId, DayId, TimeId) ->
    gen_server:call(?MODULE, {check_wedding_order, RoleId, DayId, TimeId}).

check_buy_max(RoleId, BuyNum) ->
    gen_server:call(?MODULE, {check_buy_max, RoleId, BuyNum}).

get_wedding_pid(RoleIdM) ->
    gen_server:call(?MODULE, {get_wedding_pid, RoleIdM}).

guest_buy_card(Args) ->
    gen_server:call(?MODULE, {guest_buy_card, Args}).

%% 一键邀请婚礼宾客
one_invite_role(Args) ->
    gen_server:cast(?MODULE, {one_invite_role, Args}).


gm_wedding_start(RoleId) ->
    ?MODULE ! {gm_wedding_start, RoleId}.

gm_wedding_end(RoleId) ->
    ?MODULE ! {gm_wedding_end, RoleId}.

init([]) ->
    NowTime = utime:unixtime(),
    UnixDateTime = utime:unixdate(),
    %% 重启服务器结算未完成的婚礼的婚礼气氛值奖励
    case db:get_all(?SelectMWeddingRestartAllSql) of
        [] ->
            skip;
        WeddingRestartSqlList ->
            FR = fun(RestartSqlInfo, RestartDeleteList1) ->
                [RoleIdMR, RoleIdWR, ManInR, WomanInR, _AuraR, SMemberIdListR] = RestartSqlInfo,
                MemberIdListR = util:bitstring_to_term(SMemberIdListR),
                lib_log_api:log_marriage_wedding_end(RoleIdMR, RoleIdWR, ManInR, WomanInR, 3, MemberIdListR),
                [RoleIdMR|RestartDeleteList1]
            end,
            RestartDeleteList = lists:foldl(FR, [], WeddingRestartSqlList),
            DeleteRestartListStr = ulists:list_to_string(RestartDeleteList, ","),
            ReSqlR = io_lib:format(?DelectMWeddingRestartAllSql, [DeleteRestartListStr]),
            db:execute(ReSqlR)
    end,
    case db:get_all(?SelectMWeddingOrderInfoAllSql) of
        [] ->
            WeddingOrderInfoList = [];
        WeddingOrderSqlList ->
            IsMergeServer = util:get_merge_day() == 1,
            WeddingGuestSqlList = db:get_all(?SelectMWeddingGuestInfoAllSql),
            F = fun(WeddingOrderSql, {DeleteRoleIdMList1, WeddingOrderInfoList1, WeddingFailList1, WeddingReset1}) ->
                [Id, RoleIdM, RoleIdW, WeddingType, OrderUnixDate, TimeId, GuestNumMax, ProposeRoleId, InvitedNum, OthersB] = WeddingOrderSql,
                Others = util:bitstring_to_term(OthersB),
                case IsMergeServer of 
                    false ->
                        case TimeId of
                            0 ->
                                WeddingOrderInfo = #wedding_order_info{
                                    id = Id,
                                    role_id_m = RoleIdM,
                                    role_id_w = RoleIdW,
                                    wedding_type = WeddingType,
                                    order_unix_date = OrderUnixDate,
                                    time_id = TimeId,
                                    guest_num_max = GuestNumMax,
                                    guest_list = [],
                                    propose_role_id = ProposeRoleId,
                                    invited_num = InvitedNum,
                                    others = Others
                                },
                                {DeleteRoleIdMList1, [WeddingOrderInfo|WeddingOrderInfoList1], WeddingFailList1, WeddingReset1};
                            _ ->
                                case data_wedding:get_wedding_time_con(TimeId) of                
                                    #wedding_time_con{
                                        begin_time = {BeginHour, BeginMinute}
                                    } ->
                                        case NowTime >= (OrderUnixDate+BeginHour*60*60+BeginMinute*60) of
                                            true ->
                                                %% 补偿未完成的婚礼婚礼卡
                                                {[RoleIdM|DeleteRoleIdMList1], WeddingOrderInfoList1, [{ProposeRoleId, RoleIdM, RoleIdW, WeddingType, Others}|WeddingFailList1], WeddingReset1};
                                            false ->
                                                F1 = fun(GuestSqlInfo, GuestList1) ->
                                                    [Id1, _RoleIdM1, RoleId1, RoleName1, AnswerType1] = GuestSqlInfo,
                                                    case Id1 of
                                                        Id ->
                                                            GuestInfo = #wedding_guest_info{
                                                                id = Id,
                                                                role_id_m = RoleIdM,
                                                                role_id = RoleId1,
                                                                role_name = RoleName1,
                                                                answer_type = AnswerType1
                                                            },
                                                            [GuestInfo|GuestList1];
                                                        _ ->
                                                            GuestList1
                                                    end
                                                end,
                                                GuestList = lists:foldl(F1, [], WeddingGuestSqlList),
                                                WeddingOrderInfo = #wedding_order_info{
                                                    id = Id,
                                                    role_id_m = RoleIdM,
                                                    role_id_w = RoleIdW,
                                                    wedding_type = WeddingType,
                                                    order_unix_date = OrderUnixDate,
                                                    time_id = TimeId,
                                                    guest_num_max = GuestNumMax,
                                                    guest_list = GuestList,
                                                    propose_role_id = ProposeRoleId,
                                                    invited_num = InvitedNum,
                                                    others = Others
                                                },
                                                {DeleteRoleIdMList1, [WeddingOrderInfo|WeddingOrderInfoList1], WeddingFailList1, WeddingReset1}
                                        end;
                                    _ ->
                                        %% 补偿未完成的婚礼婚礼卡
                                        {[RoleIdM|DeleteRoleIdMList1], WeddingOrderInfoList1, [{ProposeRoleId, RoleIdM, RoleIdW, WeddingType, Others}|WeddingFailList1], WeddingReset1}
                                end
                        end;
                    _ ->
                        %% 合服补偿未完成的婚礼婚礼卡
                        {[RoleIdM|DeleteRoleIdMList1], WeddingOrderInfoList1, WeddingFailList1, [{ProposeRoleId, RoleIdM, RoleIdW, WeddingType, Others}|WeddingReset1]}
                end
            end,
            {DeleteRoleIdMList, WeddingOrderInfoList, WeddingFailList, WeddingReset} = lists:foldl(F, {[], [], [], []}, WeddingOrderSqlList),
            case DeleteRoleIdMList of
                [] ->
                    skip;
                _ ->
                    spawn(fun() -> wedding_fail(WeddingFailList) end),
                    spawn(fun() -> wedding_reset_with_merge(WeddingReset) end),
                    DeleteListStr = ulists:list_to_string(DeleteRoleIdMList, ","),
                    ReSql = io_lib:format(?DelectMWeddingOrderInfoAllSql, [DeleteListStr]),
                    db:execute(ReSql),
                    ReSql1 = io_lib:format(?DelectMWeddingGuestInfoAllSql, [DeleteListStr]),
                    db:execute(ReSql1),
                    mod_marriage:change_now_wedding_state(DeleteRoleIdMList)
            end
    end,
    NextRefleshTime = UnixDateTime + 24*60*60 - NowTime,
    RefleshRef = erlang:send_after(NextRefleshTime*1000, self(), {wedding_order_reflesh}),
    WeddingTimeIdList = data_wedding:get_wedding_time_id_list(),
    NextWeddingStartTime = lib_marriage_wedding:get_next_wedding_start_time_id(WeddingTimeIdList, NowTime),
    ?PRINT("init NextWeddingStartTime ~p~n", [NextWeddingStartTime]),
    WeddingStartRef = erlang:send_after(max((NextWeddingStartTime-NowTime)*1000, 100), self(), {wedding_start}),
    WeddingMgrState = #wedding_mgr_state{
        wedding_order_list = WeddingOrderInfoList,
        refresh_timer = RefleshRef,
        wedding_start_timer = WeddingStartRef
    },
    %?PRINT("init WeddingOrderInfoList ~p~n", [WeddingOrderInfoList]),
    {ok, WeddingMgrState}.

handle_call(Request, From, State) ->
    case catch do_handle_call(Request, From, State) of
        {'EXIT', _Reason} ->
            ?ERR("~p ~p _Reason:~p~n", [?MODULE, ?LINE, _Reason]),
            {reply, ok, State};
        Result ->
            Result
    end.

do_handle_call({check_wedding_order, RoleId, DayId, TimeId}, _From, State) ->
    #wedding_mgr_state{
        wedding_order_list = WeddingOrderList
    } = State,
    Return = lib_marriage_wedding:check_wedding_order(RoleId, DayId, TimeId, WeddingOrderList),
    {reply, Return, State};

do_handle_call({check_buy_max, RoleId, BuyNum}, _From, State) ->
    #wedding_mgr_state{
        wedding_order_list = WeddingOrderList
    } = State,
    WeddingOrderInfoM = lists:keyfind(RoleId, #wedding_order_info.role_id_m, WeddingOrderList),
    WeddingOrderInfoW = lists:keyfind(RoleId, #wedding_order_info.role_id_w, WeddingOrderList),
    WeddingOrderInfo = case WeddingOrderInfoM of
        false ->
            case WeddingOrderInfoW of
                false ->
                    false;
                _ ->
                    WeddingOrderInfoW
            end;
        _ ->
            WeddingOrderInfoM
    end,
    case WeddingOrderInfo of
        false ->
            Return = {false, ?ERRCODE(err172_wedding_not_order)};
        _ ->
            #wedding_order_info{
                wedding_type = WeddingType,
                guest_num_max = GuestNumMax
            } = WeddingOrderInfo,
            WeddingInfoCon = data_wedding:get_wedding_info_con(WeddingType),
            #wedding_info_con{
                guest_num_max = ConGuestNumMax
            } = WeddingInfoCon,
            case GuestNumMax + BuyNum > ConGuestNumMax of
                true ->
                    Return = {false, ?ERRCODE(err172_wedding_buy_max_num_max)};
                false ->
                    Return = true
            end
    end,
    {reply, Return, State};

do_handle_call({guest_buy_card, [RoleId, Name, RoleIdM]}, _From, State) ->
    #wedding_mgr_state{
        wedding_order_list = WeddingOrderList
    } = State,
    WeddingOrderInfoM = lists:keyfind(RoleIdM, #wedding_order_info.role_id_m, WeddingOrderList),
    WeddingOrderInfoW = lists:keyfind(RoleIdM, #wedding_order_info.role_id_w, WeddingOrderList),
    WeddingOrderInfo = case WeddingOrderInfoM of
        false ->
            case WeddingOrderInfoW of
                false ->
                    false;
                _ ->
                    WeddingOrderInfoW
            end;
        _ ->
            WeddingOrderInfoM
    end,
    case WeddingOrderInfo of
        false ->
            {reply, {false, ?ERRCODE(err172_wedding_not_order)}, State};
        _ ->
            #wedding_order_info{
                id = Id,
                time_id = TimeId, 
                begin_time = BeginTime1,
                order_unix_date = OrderUnixDate,
                wedding_type = WeddingType,
                wedding_pid = WeddingPid,
                guest_list = GuestList,           %% 宾客总人数
                ask_invite_list = AskInviteList,
                invited_num = InvitedNum          %% 举办人已邀请的人数
            } = WeddingOrderInfo,
            GuestMax = ?GuestMax,
            GuestCnt = length(GuestList),
            WeddingInfoCon = data_wedding:get_wedding_info_con(WeddingType),
            #wedding_info_con{
                guest_num_max = ConGuestNumMax
            } = WeddingInfoCon,
            %% 剩余通过购买请柬的数量
            LeftBuyCnt = GuestMax - ConGuestNumMax - max(GuestCnt - InvitedNum, 0),
            InGuest = lists:keymember(RoleId, #wedding_guest_info.role_id, GuestList),
            if
                LeftBuyCnt < 1 ->
                    {reply, {false, ?ERRCODE(err172_wedding_buy_max_num_max)}, State};
                InGuest ->
                    {reply, {false, ?ERRCODE(err172_wedding_is_guest)}, State};
                WeddingPid == 0 ->
                    {reply, {false, ?ERRCODE(err172_wedding_not_start)}, State};
                true ->
                    NewGuestInfo = #wedding_guest_info{role_id_m = RoleIdM, role_id = RoleId, role_name = Name, answer_type = 1},
                    NewGuestList = [NewGuestInfo|GuestList],
                    NewAskInviteList = lists:keydelete(RoleId, 1, AskInviteList),
                    NewWeddingOrderInfo = WeddingOrderInfo#wedding_order_info{guest_list = NewGuestList, ask_invite_list = NewAskInviteList},
                    ReSqlStr = io_lib:format("(~p, ~p, ~p, '~s', ~p)", [Id, RoleIdM, RoleId, Name, 1]),
                    Resql = io_lib:format(?ReplaceMWeddingGuestInfoAllSql, [ReSqlStr]),
                    db:execute(Resql),
                    NewWeddingOrderList = lists:keyreplace(RoleIdM, #wedding_order_info.role_id_m, WeddingOrderList, NewWeddingOrderInfo),
                    NewState = State#wedding_mgr_state{
                        wedding_order_list = NewWeddingOrderList
                    },
                    %% 通知邮件
                    case BeginTime1 > 0 of 
                        false ->
                            WeddingTimeCon = data_wedding:get_wedding_time_con(TimeId),
                            #wedding_time_con{
                                begin_time = {BeginHour, BeginMinute}
                            } = WeddingTimeCon,
                            BeginTime = OrderUnixDate+BeginHour*60*60+BeginMinute*60;
                        _ ->
                            BeginTime = BeginTime1
                    end,
                    {{_Y, Mon, D}, {H, M, _S}} = utime:unixtime_to_localtime(BeginTime),
                    RoleName = lib_role:get_role_name(RoleIdM),
                    Title = utext:get(1720016),
                    Content = utext:get(1720017, [RoleName, Mon, D, H, M]),
                    lib_mail_api:send_sys_mail([RoleId], Title, Content, ?InviteReward),
                    % {ok, Bin1} = pt_172:write(17253, [?ERRCODE(err172_wedding_invite_success), InviteRoleIdList]),
                    % lib_server_send:send_to_uid(LoverRoleId, Bin1),
                    send_wedding_start(NewWeddingOrderInfo, [RoleId]),
                    {reply, true, NewState}
            end
    end;

do_handle_call({get_wedding_pid, RoleIdM}, _From, State) ->
    #wedding_mgr_state{
        wedding_order_list = WeddingOrderList
    } = State,
    case lists:keyfind(RoleIdM, #wedding_order_info.role_id_m, WeddingOrderList) of
        false ->
            Return = 0;
        #wedding_order_info{wedding_pid = WeddingPid} ->
            Return = WeddingPid
    end,
    {reply, Return, State};

do_handle_call(_Request, _From, State) ->
    {reply, ok, State}.

handle_cast(Info, State) ->
    case catch do_handle_cast(Info, State) of
        {'EXIT', _Reason} ->
            ?ERR("~p ~p _Reason:~p~n", [?MODULE, ?LINE, _Reason]),
            {noreply, State};
        Res ->
            Res
    end.

% do_handle_cast({propose_success, RoleIdM, RoleIdW, WeddingType, ProposeRoleId}, State) ->
%     #wedding_mgr_state{
%         wedding_order_list = WeddingOrderList
%     } = State,
%     case data_wedding:get_wedding_info_con(WeddingType) of 
%         [] -> {noreply, State};
%         WeddingInfoCon ->
%             #wedding_info_con{
%                 guest_num = GuestNumMax
%             } = WeddingInfoCon,
%             NewWeddingOrderInfo = #wedding_order_info{
%                 role_id_m = RoleIdM,
%                 role_id_w = RoleIdW,
%                 wedding_type = WeddingType,
%                 guest_num_max = GuestNumMax,
%                 propose_role_id = ProposeRoleId
%             },
%             lib_marriage_wedding:sql_wedding_order(NewWeddingOrderInfo),
%             NewWeddingOrderList = [NewWeddingOrderInfo|WeddingOrderList],
%             NewState = State#wedding_mgr_state{
%                 wedding_order_list = NewWeddingOrderList
%             },
%             {noreply, NewState}
%     end;

do_handle_cast({divorce_success, RoleIdM, _RoleIdW, _NowWeddingState}, State) ->
    #wedding_mgr_state{
        wedding_order_list = WeddingOrderList
    } = State,
    case lists:keyfind(RoleIdM, #wedding_order_info.role_id_m, WeddingOrderList) of
        false ->
            NewState = State;
        WeddingOrderInfo ->
            #wedding_order_info{id = OldId} = WeddingOrderInfo,
            erase(?P_STARTTING_WEDDING(OldId)),
            NewWeddingOrderList= lib_marriage_wedding:delete_wedding_order(WeddingOrderList, [RoleIdM]),
            NewState = #wedding_mgr_state{
                wedding_order_list = NewWeddingOrderList
            }
    end,
    {noreply, NewState};

do_handle_cast({open_wedding_order, [NowWeddingState, RoleId, WeddingOrderTimes]}, State) ->
    #wedding_mgr_state{
        wedding_order_list = WeddingOrderList
    } = State,
    % WeddingOrderInfoM = lists:keyfind(RoleId, #wedding_order_info.role_id_m, WeddingOrderList),
    % WeddingOrderInfoW = lists:keyfind(RoleId, #wedding_order_info.role_id_w, WeddingOrderList),
    % WeddingOrderInfoOwn = case WeddingOrderInfoM of
    %     false ->
    %         case WeddingOrderInfoW of
    %             false ->
    %                 false;
    %             _ ->
    %                 WeddingOrderInfoW
    %         end;
    %     _ ->
    %         WeddingOrderInfoM
    % end,
    F = fun(WeddingOrderInfo, SendList1) ->
        #wedding_order_info{
            role_id_m = RoleIdM,
            role_id_w = RoleIdW,
            wedding_type = WeddingType,
            order_unix_date = OrderUnixDate,
            time_id = TimeId
        } = WeddingOrderInfo,
        if
            RoleIdM =:= RoleId ->
                IfOwn = 1;
            RoleIdW =:= RoleId ->
                IfOwn = 1;
            true ->
                IfOwn = 0
        end,
        OrderInfo = {RoleIdM, RoleIdW, WeddingType, IfOwn},
        case lists:keyfind(OrderUnixDate, 1, SendList1) of
            false ->
                NewOrderUnixDateInfo = {OrderUnixDate, [{TimeId, [OrderInfo]}]};
            {_OrderUnixDate, TimeInfoList} ->
                case lists:keyfind(TimeId, 1, TimeInfoList) of
                    false ->
                        NewTimeInfoList = [{TimeId, [OrderInfo]}|TimeInfoList];
                    {_TimeId, OrderInfoList} ->
                        NewOrderInfoList = [OrderInfo|OrderInfoList],
                        NewTimeInfoList = lists:keyreplace(TimeId, 1, TimeInfoList, {TimeId, NewOrderInfoList})
                end,
                NewOrderUnixDateInfo = {OrderUnixDate, NewTimeInfoList}
        end,
        lists:keystore(OrderUnixDate, 1, SendList1, NewOrderUnixDateInfo)
    end,
    SendList2 = lists:foldl(F, [], WeddingOrderList),
    Code = ?SUCCESS,
    % case WeddingOrderInfoOwn of
    %     false ->
    %         Code = ?SUCCESS,
    %         SendList = SendList2;
    %     _ ->
    %         #wedding_order_info{
    %             propose_role_id = ProposeRoleId
    %         } = WeddingOrderInfoOwn,
    %         case RoleId of
    %             ProposeRoleId ->
    %                 Code = ?SUCCESS,
    %                 SendList = SendList2;
    %             _ ->
    %                 Code = ?ERRCODE(err172_wedding_can_not_open_order),
    %                 SendList = []
    %         end
    % end,
    ?PRINT("Code ~p~n", [Code]),
    ?PRINT("SendList2 ~p~n", [SendList2]),
    ?PRINT("NowWeddingState ~p~n", [NowWeddingState]),
    ?PRINT("WeddingOrderTimes ~p~n", [WeddingOrderTimes]),
    {ok, Bin} = pt_172:write(17250, [Code, NowWeddingState, WeddingOrderTimes, SendList2]),
    lib_server_send:send_to_uid(RoleId, Bin),
    {noreply, State};

do_handle_cast({wedding_order, RoleId, Args}, State) ->
    #wedding_mgr_state{
        wedding_order_list = WeddingOrderList
    } = State,
    [RoleIdM, RoleIdW, DayId, TimeId, WeddingType, _NowWeddingState, IfReward] = Args,
    case lib_marriage_wedding:check_wedding_order(RoleId, DayId, TimeId, WeddingOrderList) of
        {false, Code} ->
            NewState = State,
            %lib_marriage_wedding:return_wedding_order_cost(RoleId, GoodsTypeId, NowWeddingState),
            {ok, Bin} = pt_172:write(17251, [Code, 0, 0, [], []]),
            lib_server_send:send_to_uid(RoleId, Bin);
        true ->
            TodayDateTime = utime:unixdate(),
            _UseDateTime = TodayDateTime+(DayId-1)*24*60*60,
            TimeCon = data_wedding:get_wedding_time_con(TimeId),
            #wedding_time_con{
                begin_time = {BeginHour, BeginMinute}
            } = TimeCon,
            _WeddingTime = _UseDateTime + BeginHour*60*60 + BeginMinute*60,
            %% 夏冬令时的转换
            UseDateTime = utime:unixdate(_WeddingTime),
            WeddingTime = UseDateTime + BeginHour*60*60 + BeginMinute*60,
            StartPreTime = ?WeddingStartPreTime,
            case utime:unixtime() < (WeddingTime - StartPreTime) of 
                true ->
                    case lists:keyfind(RoleIdM, #wedding_order_info.role_id_m, WeddingOrderList) of
                        false ->
                            WeddingInfoCon = data_wedding:get_wedding_info_con(WeddingType),
                            Id = mod_id_create:get_new_id(?WEDDING_ID_CREATE),
                            #wedding_info_con{
                                guest_num = GuestNumMax
                            } = WeddingInfoCon,
                            NewWeddingOrderInfo = #wedding_order_info{
                                id = Id,
                                role_id_m = RoleIdM,
                                role_id_w = RoleIdW,
                                wedding_type = WeddingType,
                                order_unix_date = UseDateTime,
                                time_id = TimeId,
                                guest_num_max = GuestNumMax,
                                propose_role_id = RoleId
                            },
                            OrderType = 2,
                            %% 完美恋人活动
                            %mod_perfect_lover:add_wedding_times(RoleIdM, RoleIdW, WeddingType),
                            lib_flower_act_api:reflash_rank_by_wedding(NewWeddingOrderInfo);
                        WeddingOrderInfo ->
                            #wedding_order_info{
                                guest_list = _GuestList,
                                order_unix_date = OrderUnixDate
                            } = WeddingOrderInfo,
                            NewWeddingOrderInfo = WeddingOrderInfo#wedding_order_info{
                                wedding_type = WeddingType,
                                order_unix_date = UseDateTime,
                                time_id = TimeId
                            },
                            case OrderUnixDate of
                                0 ->
                                    OrderType = 1,
                                    %% 完美恋人活动
                                    %mod_perfect_lover:add_wedding_times(RoleIdM, RoleIdW, WeddingType),
                                    lib_flower_act_api:reflash_rank_by_wedding(NewWeddingOrderInfo);
                                _ ->
                                    OrderType = 3
                            end
                            %% 通知宾客日期改变
                            % GuestIdList = [GuestInfo#wedding_guest_info.role_id||GuestInfo <- GuestList],
                            % gen_server:cast(self(), {invited_list, GuestIdList})
                    end,
                    ?PRINT("NewWeddingOrderInfo ~p~n", [NewWeddingOrderInfo]),
                    lib_marriage_wedding:sql_wedding_order(NewWeddingOrderInfo),
                    NewWeddingOrderList = lists:keystore(RoleIdM, #wedding_order_info.role_id_m, WeddingOrderList, NewWeddingOrderInfo),
                    NewState = State#wedding_mgr_state{
                        wedding_order_list = NewWeddingOrderList
                    },
                    mod_marriage:wedding_order_success(RoleId, WeddingTime, WeddingType),
                    case IfReward of
                        0 ->
                            skip;
                        _ ->
                            Title   = ?LAN_MSG(?LAN_TITLE_WEDDING_SUCCESS),
                            Content = ?LAN_MSG(?LAN_CONTENT_WEDDING_SUCCESS),
                            case data_wedding:get_wedding_info_con(WeddingType) of
                                [] ->
                                    skip;
                                WeddingInfoCon1 ->
                                    #wedding_info_con{
                                        reward = RewardList,
                                        designation_id = DesignationId
                                    } = WeddingInfoCon1,
                                    lib_designation_api:active_dsgt_common(RoleIdM, DesignationId),
                                    lib_designation_api:active_dsgt_common(RoleIdW, DesignationId),
                                    lib_mail_api:send_sys_mail([RoleIdM, RoleIdW], Title, Content, RewardList)
                            end
                    end,
                    lib_log_api:log_marriage_wedding_order(RoleIdM, RoleIdW, WeddingTime, WeddingType, OrderType);
                _ ->
                    NewState = State,
                    {ok, Bin} = pt_172:write(17251, [?ERRCODE(err172_please_order_next_time), 0, 0, [], []]),
                    lib_server_send:send_to_uid(RoleId, Bin)
            end
    end,
    {noreply, NewState};

do_handle_cast({wedding_end, RoleIdM, RoleIdW}, State) ->
    #wedding_mgr_state{
        wedding_order_list = WeddingOrderList
    } = State,
    case lists:keyfind(RoleIdM, #wedding_order_info.role_id_m, WeddingOrderList) of 
        false -> skip;
        #wedding_order_info{id = OldId} ->
            ?PRINT("wedding_end ============== OldId ~p~n", [OldId]),
            erase(?P_STARTTING_WEDDING(OldId))
    end,
    %OldGuestIdList = [OldGuestInfo#wedding_guest_info.role_id||OldGuestInfo <- OldGuestList],
    %gen_server:cast(self(), {invited_list, OldGuestIdList}),
    NewWeddingOrderList= lib_marriage_wedding:delete_wedding_order(WeddingOrderList, [RoleIdM]),
    NewState = #wedding_mgr_state{
        wedding_order_list = NewWeddingOrderList
    },
    F = fun(WeddingOrderInfo, CoupleSendInfoList1) ->
        #wedding_order_info{
            id = Id,
            role_id_m = RoleIdM1,
            role_id_w = RoleIdW1,
            wedding_type = WeddingType,
            guest_list = GuestList,
            begin_time = BeginTime,
            wedding_pid = WeddingPid
        } = WeddingOrderInfo,
        case misc:is_process_alive(WeddingPid) of
            true ->
                GuestIdList = [GuestRoleId||#wedding_guest_info{role_id = GuestRoleId} <- GuestList],
                SendInfo = {Id, RoleIdM1, RoleIdW1, BeginTime, WeddingType, GuestIdList},
                [SendInfo|CoupleSendInfoList1];
            false ->
                CoupleSendInfoList1
        end
    end,
    CoupleSendInfoList = lists:foldl(F, [], NewWeddingOrderList),
    case CoupleSendInfoList of
        [] ->
            {ok, Bin} = pt_172:write(17256, [0, []]),
            lib_server_send:send_to_all(Bin);
        _ ->
            send_wedding_start(CoupleSendInfoList, 0)
    end,
    {ok, Bin1} = pt_172:write(17276, [RoleIdM, RoleIdW]),
    lib_server_send:send_to_uid(RoleIdM, Bin1),
    lib_server_send:send_to_uid(RoleIdW, Bin1),
    {noreply, NewState};

do_handle_cast({check_wedding_start_login, RoleId}, State) ->
    #wedding_mgr_state{
        wedding_order_list = WeddingOrderList
    } = State,
    F = fun(WeddingOrderInfo, CoupleSendInfoList1) ->
        #wedding_order_info{
            id = Id,
            role_id_m = RoleIdM,
            role_id_w = RoleIdW,
            wedding_type = WeddingType,
            time_id = TimeId,
            wedding_pid = WeddingPid,
            guest_list = GuestList,
            begin_time = BeginTime1
        } = WeddingOrderInfo,
        case WeddingPid of
            0 ->
                CoupleSendInfoList1;
            _ ->
                case BeginTime1 of
                    0 ->
                        WeddingTimeCon = data_wedding:get_wedding_time_con(TimeId),
                        #wedding_time_con{
                            begin_time = {BeginHour, BeginMinute}
                        } = WeddingTimeCon,
                        BeginTime = utime:unixdate()+24*60*60+BeginHour*60*60+BeginMinute*60;
                    _ ->
                        BeginTime = BeginTime1
                end,
                GuestIdList = [GuestRoleId||#wedding_guest_info{role_id = GuestRoleId} <- GuestList],
                CoupleSendInfo = {Id, RoleIdM, RoleIdW, BeginTime, WeddingType, GuestIdList},
                [CoupleSendInfo|CoupleSendInfoList1]
        end
    end,
    CoupleSendInfoList = lists:foldl(F, [], WeddingOrderList),
    case CoupleSendInfoList of
        [] ->
            skip;
        _ ->
            send_wedding_start_one(RoleId, CoupleSendInfoList)
    end,
    {noreply, State};

do_handle_cast({open_invite_guest, [RoleId, Figure, _NowWeddingState]}, State) ->
    #wedding_mgr_state{
        wedding_order_list = WeddingOrderList
    } = State,
    WeddingOrderInfoM = lists:keyfind(RoleId, #wedding_order_info.role_id_m, WeddingOrderList),
    WeddingOrderInfoW = lists:keyfind(RoleId, #wedding_order_info.role_id_w, WeddingOrderList),
    WeddingOrderInfo = case WeddingOrderInfoM of
        false ->
            case WeddingOrderInfoW of
                false ->
                    false;
                _ ->
                    WeddingOrderInfoW
            end;
        _ ->
            WeddingOrderInfoM
    end,
    case WeddingOrderInfo of
        false ->
            Code = ?ERRCODE(err172_wedding_not_order),
            LoverRoleId = 0, 
            LoverFigure = #figure{},
            WeddingType = 0,
            WeddingTime = 0,
            IfOrderAgain = 0,
            LessInvitedNum = 0,
            GuestNumMax = 0,
            GuestSendList = [],
            AskSendList = [];
        _ ->
            #wedding_order_info{
                role_id_m = RoleIdM,
                role_id_w = RoleIdW,
                wedding_type = WeddingType,
                order_unix_date = OrderUnixDate,
                time_id = TimeId,
                guest_list = GuestList,
                ask_invite_list = AskInviteList,
                guest_num_max = GuestNumMax,
                propose_role_id = _ProposeRoleId,
                invited_num = InvitedNum
            } = WeddingOrderInfo,
            LoverRoleId = case RoleId of
                RoleIdM ->
                    RoleIdW;
                _ ->
                    RoleIdM
            end,
            WeddingTimeCon = data_wedding:get_wedding_time_con(TimeId),
            case WeddingTimeCon of
                [] ->
                    Code = ?ERRCODE(err172_wedding_not_order),
                    LoverFigure = #figure{},
                    WeddingTime = 0,
                    IfOrderAgain = 0,
                    LessInvitedNum = 0,
                    GuestSendList = [],
                    AskSendList = [];
                _ ->
                    Code = ?SUCCESS,
                    #wedding_time_con{
                        begin_time = {BeginHour, BeginMinute}
                    } = WeddingTimeCon,
                    WeddingTime = OrderUnixDate+BeginHour*60*60+BeginMinute*60,
                    IfOrderAgain = 0,
                    LoverFigure = lib_role:get_role_figure(LoverRoleId),
                    % case RoleId of
                    %     ProposeRoleId ->
                    %         case NowWeddingState of
                    %             3 ->
                    %                 IfOrderAgain = 0;
                    %             _ ->
                    %                 IfOrderAgain = 1
                    %         end;
                    %     _ ->
                    %         IfOrderAgain = 0
                    % end,
                    LessInvitedNum = max(0, (GuestNumMax-InvitedNum)),
                    AskSendList = AskInviteList,
                    GuestSendList = [begin
                        #wedding_guest_info{
                            role_id = GuestRoleId,
                            role_name = RoleName,
                            answer_type = AnswerType
                        } = GuestInfo,
                        {GuestRoleId, AnswerType, RoleName}
                    end||GuestInfo <- GuestList]
            end
    end,
    %Args = [Code, LoverRoleId, WeddingType, WeddingTime, IfOrderAgain, LessInvitedNum, GuestSendList],
    %lib_offline_api:apply_cast(lib_marriage_wedding, open_invite_guest, [RoleId, Args]),
    #figure{name = MyName, picture = MyPicture, picture_ver = MyPictureVer, career = Career} = Figure,
    #figure{name = LoverName, picture = LoverPicture, picture_ver = LoverPictureVer, career = LoverCareer} = LoverFigure,
    MyPictureString = util:term_to_string([{picture_id, binary_to_integer(MyPicture)}, {career, Career}]),
    LoverMyPictureString = util:term_to_string([{picture_id, binary_to_integer(LoverPicture)}, {career, LoverCareer}]),
    ?PRINT("open_invite_guest ==== Code ~p~n", [Code]),
    ?PRINT("GuestSendList ~p~n", [GuestSendList]),
    ?PRINT("AskSendList ~p~n", [AskSendList]),
    {ok, Bin} = pt_172:write(17252, [
        Code, RoleId, MyName, MyPictureString, MyPictureVer, LoverRoleId, LoverName, LoverMyPictureString, LoverPictureVer,
        WeddingType, WeddingTime, IfOrderAgain, LessInvitedNum, GuestNumMax, GuestSendList, AskSendList
    ]),
    lib_server_send:send_to_uid(RoleId, Bin),
    {noreply, State};   

do_handle_cast({do_invite_guest, [RoleId, RoleName, InviteList]}, State) ->
    #wedding_mgr_state{
        wedding_order_list = WeddingOrderList
    } = State,
    WeddingOrderInfoM = lists:keyfind(RoleId, #wedding_order_info.role_id_m, WeddingOrderList),
    WeddingOrderInfoW = lists:keyfind(RoleId, #wedding_order_info.role_id_w, WeddingOrderList),
    WeddingOrderInfo = case WeddingOrderInfoM of
        false ->
            case WeddingOrderInfoW of
                false ->
                    false;
                _ ->
                    WeddingOrderInfoW
            end;
        _ ->
            WeddingOrderInfoM
    end,
    case WeddingOrderInfo of
        false ->
            ?PRINT("17253 err =============== 222 ~n", []),
            Code = ?ERRCODE(err172_wedding_not_order),
            InviteRoleIdList = [],
            NewState = State;
        _ ->
            #wedding_order_info{
                id = Id,
                role_id_m = RoleIdM,
                role_id_w = RoleIdW,
                guest_list = GuestList,
                ask_invite_list = AskInviteList,
                invited_num = InvitedNum,
                guest_num_max = GuestNumMax,
                order_unix_date = OrderUnixDate, 
                time_id = TimeId, 
                begin_time = BeginTime1
            } = WeddingOrderInfo,
            case (InvitedNum+length(InviteList)) =< GuestNumMax of
                false ->
                    Code = ?ERRCODE(err172_wedding_guest_num_max),
                    InviteRoleIdList = [],
                    NewState = State;
                true ->
                    F = fun({InviteRoleId, InviteRoleName}, {InviteRoleIdList1, GuestSqlStrList1, NewGuestList1}) ->
                        case lists:keyfind(InviteRoleId, #wedding_guest_info.role_id, NewGuestList1) of
                            false ->
                                NewGuestInfo = #wedding_guest_info{
                                    role_id_m = RoleIdM,
                                    role_id = InviteRoleId,
                                    role_name = InviteRoleName,
                                    answer_type = 1
                                },
                                ReSqlStr = io_lib:format("(~p, ~p, ~p, '~s', ~p)", [Id, RoleIdM, InviteRoleId, InviteRoleName, 1]),
                                {[InviteRoleId|InviteRoleIdList1], [ReSqlStr|GuestSqlStrList1], [NewGuestInfo|NewGuestList1]};
                            _ ->
                                {InviteRoleIdList1, GuestSqlStrList1, NewGuestList1}
                        end
                    end,
                    {InviteRoleIdList, GuestSqlStrList, NewGuestList} = lists:foldl(F, {[], [], GuestList}, InviteList),
                    case InviteRoleIdList of
                        [] ->
                            Code = ?ERRCODE(err172_wedding_have_invite),
                            NewState = State;
                        _ ->
                            Code = ?SUCCESS,
                            %gen_server:cast(self(), {invited_list, InviteRoleIdList}),
                            GuestSqlList = ulists:list_to_string(GuestSqlStrList, ","),
                            Resql = io_lib:format(?ReplaceMWeddingGuestInfoAllSql, [GuestSqlList]),
                            db:execute(Resql),
                            NewInvitedNum = InvitedNum + length(GuestSqlStrList),
                            NewAskInviteList = [{AskId, AskName} ||{AskId, AskName} <- AskInviteList, lists:member(AskId, InviteRoleIdList) == false],
                            NewWeddingOrderInfo = WeddingOrderInfo#wedding_order_info{
                                invited_num = NewInvitedNum,
                                guest_list = NewGuestList,
                                ask_invite_list = NewAskInviteList
                            },
                            lib_marriage_wedding:sql_update_wedding_order([{invited_num, NewInvitedNum}], [{role_id_m, RoleIdM}, {role_id_w, RoleIdW}]),
                            NewWeddingOrderList = lists:keyreplace(RoleIdM, #wedding_order_info.role_id_m, WeddingOrderList, NewWeddingOrderInfo),
                            NewState = State#wedding_mgr_state{
                                wedding_order_list = NewWeddingOrderList
                            },
                            LoverRoleId = case RoleId of
                                RoleIdM ->
                                    RoleIdW;
                                _ ->
                                    RoleIdM
                            end,
                            ?PRINT("do_invite_guest ==== Code ~p~n", [1]),
                            ?PRINT("InviteRoleIdList  ~p~n", [InviteRoleIdList]),
                            %% 通知邮件
                            case BeginTime1 > 0 of 
                                false ->
                                    WeddingTimeCon = data_wedding:get_wedding_time_con(TimeId),
                                    #wedding_time_con{
                                        begin_time = {BeginHour, BeginMinute}
                                    } = WeddingTimeCon,
                                    BeginTime = OrderUnixDate+BeginHour*60*60+BeginMinute*60;
                                _ ->
                                    BeginTime = BeginTime1
                            end,
                            {{_Y, Mon, D}, {H, M, _S}} = utime:unixtime_to_localtime(BeginTime),
                            Title = utext:get(1720016),
                            Content = utext:get(1720017, [RoleName, Mon, D, H, M]),
                            lib_mail_api:send_sys_mail(InviteRoleIdList, Title, Content, ?InviteReward),
                            {ok, Bin1} = pt_172:write(17253, [?ERRCODE(err172_wedding_invite_success), InviteRoleIdList]),
                            lib_server_send:send_to_uid(LoverRoleId, Bin1),
                            send_wedding_start(NewWeddingOrderInfo, InviteRoleIdList)
                    end
            end
    end,
    ?PRINT("17253 code =============== Code ~p~n", [Code]),
    {ok, Bin} = pt_172:write(17253, [Code, InviteRoleIdList]),
    lib_server_send:send_to_uid(RoleId, Bin),
    {noreply, NewState};

do_handle_cast({invited_list, RoleIdList}, State) ->
    #wedding_mgr_state{
        wedding_order_list = WeddingOrderList
    } = State,
    F = fun(RoleId, InvitedInfoList1) ->
        InvitedList = lib_marriage_wedding:invited_list(WeddingOrderList, RoleId, []),
        [{RoleId, InvitedList}|InvitedInfoList1]
    end,
    InvitedInfoList = lists:foldl(F, [], RoleIdList),
    spawn(fun() -> lib_marriage_wedding:send_invited_list(InvitedInfoList) end),
    {noreply, State};

do_handle_cast({invited_answer, RoleId, RoleIdM, AnswerType}, State) ->
    #wedding_mgr_state{
        wedding_order_list = WeddingOrderList
    } = State,
    WeddingOrderInfo = lists:keyfind(RoleIdM, #wedding_order_info.role_id_m, WeddingOrderList),
    case WeddingOrderInfo of
        false ->
            Code = ?ERRCODE(err172_wedding_not_order),
            NewState = State;
        _ ->
            #wedding_order_info{
                id = Id,
                guest_list = GuestList,
                ask_invite_list = AskInviteList
            } = WeddingOrderInfo,
            case lists:keyfind(RoleId, #wedding_guest_info.role_id, GuestList) of
                false ->
                    Code = ?ERRCODE(err172_wedding_not_invite),
                    NewState = State;
                GuestInfo ->
                    #wedding_guest_info{
                        role_name = RoleName,
                        answer_type = OldAnswerType
                    } = GuestInfo,
                    case OldAnswerType =/= 0 of
                        true ->
                            Code = ?ERRCODE(err172_wedding_guest_have_answer),
                            NewState = State;
                        false ->
                            Code = ?SUCCESS,
                            case AnswerType of
                                1 ->
                                    NewGuestInfo = GuestInfo#wedding_guest_info{
                                        answer_type = 1
                                    },
                                    ReSqlStr = io_lib:format("(~p, ~p, ~p, '~s', ~p)", [Id, RoleIdM, RoleId, RoleName, 1]),
                                    GuestSqlList = ulists:list_to_string([ReSqlStr], ","),
                                    Resql = io_lib:format(?ReplaceMWeddingGuestInfoAllSql, [GuestSqlList]),
                                    db:execute(Resql),
                                    NewGuestList = lists:keyreplace(RoleId, #wedding_guest_info.role_id, GuestList, NewGuestInfo),
                                    NewAskInviteList = lists:delete(RoleId, AskInviteList);
                                _ ->
                                    Resql = io_lib:format(?DelectMWeddingGuestInfoSql, [RoleIdM, RoleId]),
                                    db:execute(Resql),
                                    NewGuestList = lists:keydelete(RoleId, #wedding_guest_info.role_id, GuestList),
                                    NewAskInviteList = AskInviteList
                            end,
                            NewWeddingOrderInfo = WeddingOrderInfo#wedding_order_info{
                                guest_list = NewGuestList,
                                ask_invite_list = NewAskInviteList
                            },
                            NewWeddingOrderList = lists:keyreplace(RoleIdM, #wedding_order_info.role_id_m, WeddingOrderList, NewWeddingOrderInfo),
                            NewState = State#wedding_mgr_state{
                                wedding_order_list = NewWeddingOrderList
                            }
                    end
            end
    end,
    {ok, Bin} = pt_172:write(17255, [Code, RoleIdM, AnswerType]),
    lib_server_send:send_to_uid(RoleId, Bin),
    {noreply, NewState};

do_handle_cast({open_buy_max, RoleId}, State) ->
    #wedding_mgr_state{
        wedding_order_list = WeddingOrderList
    } = State,
    WeddingOrderInfoM = lists:keyfind(RoleId, #wedding_order_info.role_id_m, WeddingOrderList),
    WeddingOrderInfoW = lists:keyfind(RoleId, #wedding_order_info.role_id_w, WeddingOrderList),
    WeddingOrderInfo = case WeddingOrderInfoM of
        false ->
            case WeddingOrderInfoW of
                false ->
                    false;
                _ ->
                    WeddingOrderInfoW
            end;
        _ ->
            WeddingOrderInfoM
    end,
    case WeddingOrderInfo of
        false ->
            Code = ?ERRCODE(err172_wedding_not_order),
            LessNum = 0,
            CanbuyNum = 0,
            Price = 0;
        _ ->
            Code = ?SUCCESS,
            #wedding_order_info{
                wedding_type = WeddingType,
                guest_num_max = GuestNumMax,
                guest_list = GuestList
            } = WeddingOrderInfo,
            WeddingInfoCon = data_wedding:get_wedding_info_con(WeddingType),
            #wedding_info_con{
                guest_num_max = ConGuestNumMax
            } = WeddingInfoCon,
            LessNum = GuestNumMax - length(GuestList),
            CanbuyNum = ConGuestNumMax - GuestNumMax,
            Price = ?WeddingGuestMaxNumPrice
    end,
    {ok, Bin} = pt_172:write(17258, [Code, LessNum, CanbuyNum, Price]),
    lib_server_send:send_to_uid(RoleId, Bin),
    {noreply, State};

do_handle_cast({do_buy_max, [RoleId, BuyNum, CostList]}, State) ->
    #wedding_mgr_state{
        wedding_order_list = WeddingOrderList
    } = State,
    WeddingOrderInfoM = lists:keyfind(RoleId, #wedding_order_info.role_id_m, WeddingOrderList),
    WeddingOrderInfoW = lists:keyfind(RoleId, #wedding_order_info.role_id_w, WeddingOrderList),
    WeddingOrderInfo = case WeddingOrderInfoM of
        false ->
            case WeddingOrderInfoW of
                false ->
                    false;
                _ ->
                    WeddingOrderInfoW
            end;
        _ ->
            WeddingOrderInfoM
    end,
    case WeddingOrderInfo of
        false ->
            Code = ?ERRCODE(err172_wedding_not_order),
            Title   = ?LAN_MSG(?LAN_TITLE_BUY_GUEST_NUM_RETURN),
            Content = ?LAN_MSG(?LAN_CONTENT_BUY_GUEST_NUM_RETURN),
            GoodsList = CostList,
            lib_mail_api:send_sys_mail([RoleId], Title, Content, GoodsList),
            NewLessNum = 0,
            NewGuestNumMax = 0,
            NewState = State;
        _ ->
            #wedding_order_info{
                role_id_m = RoleIdM,
                role_id_w = RoleIdW,
                wedding_type = WeddingType,
                guest_num_max = GuestNumMax,
                guest_list = GuestList,
                others = Others
            } = WeddingOrderInfo,
            WeddingInfoCon = data_wedding:get_wedding_info_con(WeddingType),
            #wedding_info_con{
                guest_num_max = ConGuestNumMax
            } = WeddingInfoCon,
            case GuestNumMax + BuyNum > ConGuestNumMax of
                true ->
                    Code = ?ERRCODE(err172_wedding_buy_max_num_max),
                    Title   = ?LAN_MSG(?LAN_TITLE_BUY_GUEST_NUM_RETURN),
                    Content = ?LAN_MSG(?LAN_CONTENT_BUY_GUEST_NUM_RETURN),
                    GoodsList = CostList,
                    lib_mail_api:send_sys_mail([RoleId], Title, Content, GoodsList),
                    NewLessNum = 0,
                    NewGuestNumMax = 0,
                    NewState = State;
                false ->
                    Code = ?SUCCESS,
                    NewGuestNumMax = GuestNumMax + BuyNum,
                    NewLessNum = NewGuestNumMax - length(GuestList),
                    NewOthers = update_wedding_order_others(Others, ?WEDDING_ORDER_OTHER_KEY_1, {RoleId, CostList}),
                    NewWeddingOrderInfo = WeddingOrderInfo#wedding_order_info{
                        guest_num_max = NewGuestNumMax,
                        others = NewOthers
                    },
                    lib_marriage_wedding:sql_update_wedding_order([{guest_num_max, NewGuestNumMax}, {others, util:term_to_bitstring(NewOthers)}], [{role_id_m, RoleIdM}]),
                    NewWeddingOrderList = lists:keyreplace(RoleIdM, #wedding_order_info.role_id_m, WeddingOrderList, NewWeddingOrderInfo),
                    NewState = State#wedding_mgr_state{
                        wedding_order_list = NewWeddingOrderList
                    },
                    case RoleId of
                        RoleIdM ->
                            OtherId = RoleIdW;
                        _ ->
                            OtherId = RoleIdM
                    end,
                    {ok, Bin1} = pt_172:write(17259, [?ERRCODE(err172_wedding_buy_max_num_success), NewLessNum, NewGuestNumMax]),
                    lib_server_send:send_to_uid(OtherId, Bin1)
            end
    end,
    ?PRINT("do_buy_max ~p~n", [{Code, NewLessNum, NewGuestNumMax}]),
    {ok, Bin} = pt_172:write(17259, [Code, NewLessNum, NewGuestNumMax]),
    lib_server_send:send_to_uid(RoleId, Bin),
    {noreply, NewState};

do_handle_cast({ask_invite, [RoleId, RoleName, RoleIdM]}, State) ->
    #wedding_mgr_state{
        wedding_order_list = WeddingOrderList
    } = State,
    case lists:keyfind(RoleIdM, #wedding_order_info.role_id_m, WeddingOrderList) of
        false ->
            Code = ?ERRCODE(err172_wedding_not_start),
            NewState = State;
        WeddingOrderInfo ->
            #wedding_order_info{
                role_id_w = RoleIdW,
                wedding_pid = WeddingPid,
                guest_num_max = GuestNumMax,
                guest_list = GuestList,
                ask_invite_list = AskInviteList
            } = WeddingOrderInfo,
            case misc:is_process_alive(WeddingPid) of
                false ->
                    Code = ?ERRCODE(err172_wedding_not_start),
                    NewState = State;
                true ->
                    case lists:keyfind(RoleId, #wedding_guest_info.role_id, GuestList) of
                        false ->
                            case lists:keymember(RoleId, 1, AskInviteList) of
                                false ->
                                    Code = ?SUCCESS,
                                    NewAskInviteList = [{RoleId, RoleName}|AskInviteList],
                                    ?PRINT("NewAskInviteList ~p~n", [NewAskInviteList]),
                                    NewWeddingOrderInfo = WeddingOrderInfo#wedding_order_info{
                                        ask_invite_list = NewAskInviteList
                                    },
                                    NewWeddingOrderList = lists:keyreplace(RoleIdM, #wedding_order_info.role_id_m, WeddingOrderList, NewWeddingOrderInfo),
                                    NewState = State#wedding_mgr_state{
                                        wedding_order_list = NewWeddingOrderList
                                    },
                                    LessGuestNum = GuestNumMax -length(GuestList),
                                    AskSendList = [{AskRoleId, 1, AskRoleName}||{AskRoleId, AskRoleName} <- NewAskInviteList],
                                    {ok, Bin} = pt_172:write(17260, [?SUCCESS, LessGuestNum, [{1, AskSendList}]]),
                                    lib_server_send:send_to_uid(RoleIdM, Bin),
                                    lib_server_send:send_to_uid(RoleIdW, Bin);
                                true ->
                                    Code = ?ERRCODE(err172_wedding_already_ask),
                                    NewState = State
                            end;
                        _ ->
                            Code = ?ERRCODE(err172_wedding_is_guest),
                            NewState = State
                    end
            end
    end,
    ?PRINT("ask_invite ==== Code ~p~n", [Code]),
    {ok, Bin1} = pt_172:write(17257, [Code]),
    lib_server_send:send_to_uid(RoleId, Bin1),
    {noreply, NewState};

do_handle_cast({open_ask_invite, [RoleId, TypeList]}, State) ->
    #wedding_mgr_state{
        wedding_order_list = WeddingOrderList
    } = State,
    WeddingOrderInfoM = lists:keyfind(RoleId, #wedding_order_info.role_id_m, WeddingOrderList),
    WeddingOrderInfoW = lists:keyfind(RoleId, #wedding_order_info.role_id_w, WeddingOrderList),
    WeddingOrderInfo = case WeddingOrderInfoM of
        false ->
            case WeddingOrderInfoW of
                false ->
                    false;
                _ ->
                    WeddingOrderInfoW
            end;
        _ ->
            WeddingOrderInfoM
    end,
    case WeddingOrderInfo of
        false ->
            {ok, Bin1} = pt_172:write(17260, [?ERRCODE(err172_wedding_not_start), 0, []]),
            lib_server_send:send_to_uid(RoleId, Bin1);
        _ ->
            #wedding_order_info{
                guest_num_max = GuestNumMax,
                wedding_pid = _WeddingPid,
                guest_list = GuestList,
                invited_num = InvitedNum,
                ask_invite_list = AskInviteList
            } = WeddingOrderInfo,
                LessGuestNum = max(0, GuestNumMax - InvitedNum),
                F = fun(Type, SendList) ->
                    case Type of 
                        1 ->
                            AskSendList = [{AskRoleId, 1, AskRoleName} ||{AskRoleId, AskRoleName} <- AskInviteList],
                            [{1, AskSendList}|SendList];
                        2 ->
                            GuestSendList = [{GRoleId, 1, GRoleName}||#wedding_guest_info{role_id = GRoleId, role_name = GRoleName} <- GuestList],
                            [{2, GuestSendList}|SendList];
                        _ -> SendList
                    end
                end,
                SendList2 = lists:foldl(F, [], TypeList),
                {ok, Bin} = pt_172:write(17260, [?SUCCESS, LessGuestNum, SendList2]),
                lib_server_send:send_to_uid(RoleId, Bin)
    end,
    {noreply, State};

do_handle_cast({answer_ask_invite, RoleId, RoleName, AnswerAskList}, State) ->
    #wedding_mgr_state{
        wedding_order_list = WeddingOrderList
    } = State,
    WeddingOrderInfoM = lists:keyfind(RoleId, #wedding_order_info.role_id_m, WeddingOrderList),
    WeddingOrderInfoW = lists:keyfind(RoleId, #wedding_order_info.role_id_w, WeddingOrderList),
    WeddingOrderInfo = case WeddingOrderInfoM of
        false ->
            case WeddingOrderInfoW of
                false ->
                    false;
                _ ->
                    WeddingOrderInfoW
            end;
        _ ->
            WeddingOrderInfoM
    end,
    case WeddingOrderInfo of
        false ->
            Code = ?ERRCODE(err172_wedding_not_start),
            NewState = State;
        _ ->
            #wedding_order_info{
                id = Id,
                role_id_m = RoleIdM,
                role_id_w = RoleIdW,
                guest_num_max = GuestNumMax,
                invited_num = InvitedNum,
                wedding_pid = WeddingPid,
                begin_time = BeginTime,
                guest_list = GuestList,
                ask_invite_list = AskInviteList
            } = WeddingOrderInfo,
            AskRoleIdYesList = [AskRoleId1||{AskRoleId1, AnswerType1} <- AnswerAskList, AnswerType1 =:= 1],
            if
                 WeddingPid =:= 0 ->
                    Code = ?ERRCODE(err172_wedding_not_start),
                    NewState = State;
                InvitedNum + length(AskRoleIdYesList) > GuestNumMax ->
                    Code = ?ERRCODE(err172_wedding_guest_num_max),
                    NewState = State;
                true ->
                    Code = ?SUCCESS,
                    F = fun({AskRoleId, AnswerType}, {NewAskRoleIdYesList1, NewGuestSqlStrList1, NewAskInviteList1, NewGusestList1, NewInvitedNum1}) ->
                        case AnswerType of
                            1 ->
                                case lists:keyfind(AskRoleId, #wedding_guest_info.role_id, NewGusestList1) of
                                    false ->
                                        case lists:keyfind(AskRoleId, 1, NewAskInviteList1) of 
                                            {AskRoleId, AskRoleName} ->
                                                NewWeddingGuestInfo = #wedding_guest_info{
                                                    role_id_m = RoleIdM,
                                                    role_id = AskRoleId,
                                                    role_name = AskRoleName,
                                                    answer_type = 1
                                                },
                                                ReSqlStr = io_lib:format("(~p, ~p, ~p, '~s', ~p)", [Id, RoleIdM, AskRoleId, AskRoleName, 1]),
                                                NewAskRoleIdYesList2 = [AskRoleId|NewAskRoleIdYesList1],
                                                NewGuestSqlStrList2 = [ReSqlStr|NewGuestSqlStrList1],
                                                NewInvitedNum2 = NewInvitedNum1 + 1,
                                                NewGusestList2 = [NewWeddingGuestInfo|NewGusestList1];                                      
                                            _ ->
                                                NewAskRoleIdYesList2 = NewAskRoleIdYesList1,
                                                NewGuestSqlStrList2 = NewGuestSqlStrList1,
                                                NewGusestList2 = NewGusestList1,
                                                NewInvitedNum2 = NewInvitedNum1
                                        end;
                                    _WeddingGuestInfo ->
                                        NewAskRoleIdYesList2 = NewAskRoleIdYesList1,
                                        NewGuestSqlStrList2 = NewGuestSqlStrList1,
                                        NewGusestList2 = NewGusestList1,
                                        NewInvitedNum2 = NewInvitedNum1
                                end;
                            _ ->
                                NewAskRoleIdYesList2 = NewAskRoleIdYesList1,
                                NewGuestSqlStrList2 = NewGuestSqlStrList1,
                                NewGusestList2 = NewGusestList1,
                                NewInvitedNum2 = NewInvitedNum1
                        end,
                        NewAskInviteList2 = lists:keydelete(AskRoleId, 1, NewAskInviteList1),
                        {NewAskRoleIdYesList2, NewGuestSqlStrList2, NewAskInviteList2, NewGusestList2, NewInvitedNum2}
                    end,
                    {NewAskRoleIdYesList, GuestSqlStrList, NewAskInviteList, NewGuestList, NewInvitedNum} = lists:foldl(F, {[], [], AskInviteList, GuestList, InvitedNum}, AnswerAskList),
                    NewWeddingOrderInfo = WeddingOrderInfo#wedding_order_info{
                        guest_list = NewGuestList,
                        ask_invite_list = NewAskInviteList,
                        invited_num = NewInvitedNum
                    },
                    ?PRINT("NewGuestList ~p~n", [NewGuestList]),
                    lib_marriage_wedding:sql_update_wedding_order([{invited_num, NewInvitedNum}], [{role_id_m, RoleIdM}]),
                    send_wedding_start(NewWeddingOrderInfo, NewAskRoleIdYesList),
                    %% 通知邮件
                    {{_Y, Mon, D}, {H, M, _S}} = utime:unixtime_to_localtime(BeginTime),
                    Title = utext:get(1720016),
                    Content = utext:get(1720017, [RoleName, Mon, D, H, M]),
                    lib_mail_api:send_sys_mail(NewAskRoleIdYesList, Title, Content, ?InviteReward),
                    case GuestSqlStrList of
                        [] ->
                            skip;
                        _ ->
                            GuestSqlList = ulists:list_to_string(GuestSqlStrList, ","),
                            Resql = io_lib:format(?ReplaceMWeddingGuestInfoAllSql, [GuestSqlList]),
                            db:execute(Resql)
                    end,
                    NewWeddingOrderList = lists:keyreplace(RoleIdM, #wedding_order_info.role_id_m, WeddingOrderList, NewWeddingOrderInfo),
                    NewState = State#wedding_mgr_state{
                        wedding_order_list = NewWeddingOrderList
                    },
                    case RoleId of
                        RoleIdM ->
                            OtherRid = RoleIdW;
                        _ ->
                            OtherRid = RoleIdM
                    end,
                    LessGuestNum = GuestNumMax - NewInvitedNum,
                    AskSendList = [{AskRoleId, 1, AskRoleName} ||{AskRoleId, AskRoleName} <- NewAskInviteList],
                    GuestSendList = [{GRoleId, 1, GRoleName}||#wedding_guest_info{role_id = GRoleId, role_name = GRoleName} <- NewGuestList],    
                    {ok, Bin2} = pt_172:write(17260, [?SUCCESS, LessGuestNum, [{1, AskSendList}, {2, GuestSendList}]]),
                    %{ok, Bin1} = pt_172:write(17261, [?ERRCODE(err172_wedding_ask_invite_agree)]),
                    %lib_server_send:send_to_uid(OtherRid, Bin1),
                    lib_server_send:send_to_uid(OtherRid, Bin2),
                    lib_server_send:send_to_uid(RoleId, Bin2)
            end
    end,
    ?PRINT("answer_ask_invite ==== Code ~p~n", [Code]),
    {ok, Bin} = pt_172:write(17261, [Code]),
    lib_server_send:send_to_uid(RoleId, Bin),
    {noreply, NewState};

do_handle_cast({enter_wedding, [RoleId, Sid, RoleIdM]}, State) ->
    #wedding_mgr_state{
        wedding_order_list = WeddingOrderList
    } = State,
    case lists:keyfind(RoleIdM, #wedding_order_info.role_id_m, WeddingOrderList) of
        false ->
            Code = ?ERRCODE(err172_wedding_not_start);
        WeddingOrderInfo ->
            #wedding_order_info{
                role_id_w = RoleIdW,
                wedding_pid = WeddingPid,
                guest_list = GuestList,
                begin_time = BeginTime
            } = WeddingOrderInfo,
            case is_pid(WeddingPid) andalso misc:is_process_alive(WeddingPid) andalso utime:unixtime() >= BeginTime of
                false ->
                    Code = ?ERRCODE(err172_wedding_not_start);
                true ->
                    case lists:keyfind(RoleId, #wedding_guest_info.role_id, GuestList) of
                        #wedding_guest_info{answer_type = 1} ->
                            Code = ?SUCCESS;
                        _ ->
                            case lists:member(RoleId, [RoleIdM, RoleIdW]) of
                                false ->
                                    Code = ?ERRCODE(err172_wedding_not_guest);
                                true ->
                                    Code = ?SUCCESS
                            end
                    end,
                    case Code =:= ?SUCCESS of
                        true ->
                            gen_server:cast(WeddingPid, {enter_wedding, RoleId, Sid, true});
                        false ->
                            skip
                    end
            end
    end,
    {ok, Bin1} = pt_172:write(17263, [Code]),
    lib_server_send:send_to_uid(RoleId, Bin1),
    {noreply, State};

do_handle_cast({enter_wedding_login, [RoleIdM, RoleId, Sid]}, State) ->
    #wedding_mgr_state{
        wedding_order_list = WeddingOrderList
    } = State,
    WeddingOrderInfoM = lists:keyfind(RoleId, #wedding_order_info.role_id_m, WeddingOrderList),
    WeddingOrderInfoW = lists:keyfind(RoleId, #wedding_order_info.role_id_w, WeddingOrderList),
    WeddingOrderInfo = case WeddingOrderInfoM of
        false ->
            case WeddingOrderInfoW of
                false ->
                    false;
                _ ->
                    WeddingOrderInfoW
            end;
        _ ->
            WeddingOrderInfoM
    end,
    case WeddingOrderInfo of
        false ->
            case lists:keyfind(RoleIdM, #wedding_order_info.role_id_m, WeddingOrderList) of
                false ->
                    skip;
                WeddingOrderInfo2 ->
                    #wedding_order_info{
                        wedding_pid = WeddingPid
                    } = WeddingOrderInfo2,
                    case is_pid(WeddingPid) andalso is_process_alive(WeddingPid) of
                        true ->
                            gen_server:cast(WeddingPid, {quit_wedding, RoleId});
                        false ->
                            skip
                    end
            end,
            KeyValueList = [{action_free, ?ERRCODE(err172_in_wedding_scene)}, {collect_checker, undefined}],
            lib_scene:player_change_default_scene(RoleId, KeyValueList);
        _ ->
            #wedding_order_info{
                wedding_pid = WeddingPid
            } = WeddingOrderInfo,
            case misc:is_process_alive(WeddingPid) of 
                true ->
                    gen_server:cast(WeddingPid, {enter_wedding, RoleId, Sid, false});
                _ ->
                    KeyValueList = [{action_free, ?ERRCODE(err172_in_wedding_scene)}, {collect_checker, undefined}],
                    lib_scene:player_change_default_scene(RoleId, KeyValueList)
            end
    end,
    {noreply, State};

do_handle_cast({quit_wedding, RoleId, RoleIdM}, State) ->
    #wedding_mgr_state{
        wedding_order_list = WeddingOrderList
    } = State,
    case lists:keyfind(RoleIdM, #wedding_order_info.role_id_m, WeddingOrderList) of
        false ->
            skip;
        WeddingOrderInfo ->
            #wedding_order_info{
                wedding_pid = WeddingPid
            } = WeddingOrderInfo,
            case is_pid(WeddingPid) andalso is_process_alive(WeddingPid) of
                true ->
                    gen_server:cast(WeddingPid, {quit_wedding, RoleId});
                false ->
                    skip
            end
    end,
    {noreply, State};

do_handle_cast({get_wedding_info, RoleId, RoleIdM}, State) ->
    #wedding_mgr_state{
        wedding_order_list = WeddingOrderList
    } = State,
    case lists:keyfind(RoleIdM, #wedding_order_info.role_id_m, WeddingOrderList) of
        false ->
            {ok, Bin} = pt_172:write(17265, [?ERRCODE(err172_wedding_not_start), 0, 0, 0, 0, 0]),
            lib_server_send:send_to_uid(RoleId, Bin);
        WeddingOrderInfo ->
            #wedding_order_info{
                wedding_pid = WeddingPid
            } = WeddingOrderInfo,
            case misc:is_process_alive(WeddingPid) of
                false ->
                    {ok, Bin} = pt_172:write(17265, [?ERRCODE(err172_wedding_not_start), 0, 0, 0, 0, 0]),
                    lib_server_send:send_to_uid(RoleId, Bin);
                true ->
                    gen_server:cast(WeddingPid, {get_wedding_info, RoleId})
            end
    end,
    {noreply, State};

do_handle_cast({kill_trouble_maker_solve, RoleId, RoleIdM, SolveId, MonOnlyId}, State) ->
    #wedding_mgr_state{
        wedding_order_list = WeddingOrderList
    } = State,
    case lists:keyfind(RoleIdM, #wedding_order_info.role_id_m, WeddingOrderList) of
        false ->
            {ok, Bin} = pt_172:write(17269, [?ERRCODE(err172_wedding_not_start), ""]),
            lib_server_send:send_to_uid(RoleId, Bin);
        WeddingOrderInfo ->
            #wedding_order_info{
                wedding_pid = WeddingPid
            } = WeddingOrderInfo,
            case misc:is_process_alive(WeddingPid) of
                false ->
                    {ok, Bin} = pt_172:write(17269, [?ERRCODE(err172_wedding_not_start), ""]),
                    lib_server_send:send_to_uid(RoleId, Bin);
                true ->
                    gen_server:cast(WeddingPid, {kill_trouble_maker_solve, RoleId, SolveId, MonOnlyId})
            end
    end,
    {noreply, State};

do_handle_cast({collect_mon, RoleId, MonOnlyId, Mid, RoleIdM, AddAura, Type}, State) ->
    #wedding_mgr_state{
        wedding_order_list = WeddingOrderList
    } = State,
    case lists:keyfind(RoleIdM, #wedding_order_info.role_id_m, WeddingOrderList) of
        false ->
            {ok, Bin} = pt_172:write(17271, [?ERRCODE(err172_wedding_not_start), "", Type]),
            lib_server_send:send_to_uid(RoleId, Bin);
        WeddingOrderInfo ->
            #wedding_order_info{
                wedding_pid = WeddingPid
            } = WeddingOrderInfo,
            case misc:is_process_alive(WeddingPid) of
                false ->
                    {ok, Bin} = pt_172:write(17271, [?ERRCODE(err172_wedding_not_start), "", Type]),
                    lib_server_send:send_to_uid(RoleId, Bin);
                true ->
                    Args = [MonOnlyId, Mid, AddAura, Type, WeddingPid],
                    case Type of
                        1 ->
                            gen_server:cast(WeddingPid, {collect_mon_table, RoleId, Args});
                        _ ->
                            lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, ?NOT_HAND_OFFLINE, lib_marriage_wedding, collect_mon_player, [Args])
                    end
            end
    end,
    {noreply, State};

do_handle_cast({get_wedding_guest_info, RoleId, RoleIdM}, State) ->
    #wedding_mgr_state{
        wedding_order_list = WeddingOrderList
    } = State,
    case lists:keyfind(RoleIdM, #wedding_order_info.role_id_m, WeddingOrderList) of
        false ->
            {ok, Bin} = pt_172:write(17272, [?ERRCODE(err172_wedding_not_start), 0, 0, 0, []]),
            lib_server_send:send_to_uid(RoleId, Bin);
        WeddingOrderInfo ->
            #wedding_order_info{
                wedding_pid = WeddingPid
            } = WeddingOrderInfo,
            case misc:is_process_alive(WeddingPid) of
                false ->
                    {ok, Bin} = pt_172:write(17272, [?ERRCODE(err172_wedding_not_start), 0, 0, 0, []]),
                    lib_server_send:send_to_uid(RoleId, Bin);
                true ->
                    gen_server:cast(WeddingPid, {get_wedding_guest_info, RoleId})
            end
    end,
    {noreply, State};

do_handle_cast({get_wedding_tm_info, RoleId, RoleIdM}, State) ->
    #wedding_mgr_state{
        wedding_order_list = WeddingOrderList
    } = State,
    case lists:keyfind(RoleIdM, #wedding_order_info.role_id_m, WeddingOrderList) of
        false ->
            {ok, Bin} = pt_172:write(17274, [0]),
            lib_server_send:send_to_uid(RoleId, Bin);
        WeddingOrderInfo ->
            #wedding_order_info{
                wedding_pid = WeddingPid
            } = WeddingOrderInfo,
            case misc:is_process_alive(WeddingPid) of
                false ->
                    {ok, Bin} = pt_172:write(17274, [0]),
                    lib_server_send:send_to_uid(RoleId, Bin);
                true ->
                    gen_server:cast(WeddingPid, {get_wedding_tm_info, RoleId})
            end
    end,
    {noreply, State};

do_handle_cast({get_wedding_exp_info, RoleId, RoleIdM}, State) ->
    #wedding_mgr_state{
        wedding_order_list = WeddingOrderList
    } = State,
    case lists:keyfind(RoleIdM, #wedding_order_info.role_id_m, WeddingOrderList) of
        false ->
            skip;
        WeddingOrderInfo ->
            #wedding_order_info{
                wedding_pid = WeddingPid
            } = WeddingOrderInfo,
            case misc:is_process_alive(WeddingPid) of
                false ->
                    skip;
                true ->
                    gen_server:cast(WeddingPid, {get_wedding_exp_info, RoleId})
            end
    end,
    {noreply, State};

do_handle_cast({open_my_lover, _RoleId, _Type, _NowWeddingState, _MarriageTime, _OtherRid}, State) ->
    % #wedding_mgr_state{
    %     wedding_order_list = WeddingOrderList
    % } = State,
    % WeddingOrderInfoM = lists:keyfind(RoleId, #wedding_order_info.role_id_m, WeddingOrderList),
    % WeddingOrderInfoW = lists:keyfind(RoleId, #wedding_order_info.role_id_w, WeddingOrderList),
    % WeddingOrderInfo = case WeddingOrderInfoM of
    %     false ->
    %         case WeddingOrderInfoW of
    %             false ->
    %                 false;
    %             _ ->
    %                 WeddingOrderInfoW
    %         end;
    %     _ ->
    %         WeddingOrderInfoM
    % end,
    % case WeddingOrderInfo of
    %     false ->
    %         lib_player:apply_cast(OtherRid, ?APPLY_CAST_STATUS, ?HAND_OFFLINE, lib_marriage, open_my_lover, [RoleId, Type, NowWeddingState, MarriageTime]);
    %     #wedding_order_info{propose_role_id = ProposeRoleId} ->
    %         case RoleId of
    %             ProposeRoleId ->
    %                 NowWeddingState1 = NowWeddingState;
    %             _ ->
    %                 case NowWeddingState of
    %                     0 ->
    %                         NowWeddingState1 = 4;
    %                     _ ->
    %                         NowWeddingState1 = 5
    %                 end
    %         end,
    %         lib_player:apply_cast(OtherRid, ?APPLY_CAST_STATUS, ?HAND_OFFLINE, lib_marriage, open_my_lover, [RoleId, Type, NowWeddingState1, MarriageTime])
    % end,
    {noreply, State};

do_handle_cast({send_wedding_state_info, RoleId}, State) ->
    #wedding_mgr_state{
        wedding_order_list = WeddingOrderList
    } = State,
    WeddingOrderInfoM = lists:keyfind(RoleId, #wedding_order_info.role_id_m, WeddingOrderList),
    WeddingOrderInfoW = lists:keyfind(RoleId, #wedding_order_info.role_id_w, WeddingOrderList),
    WeddingOrderInfo = case WeddingOrderInfoM of
        false ->
            case WeddingOrderInfoW of
                false ->
                    false;
                _ ->
                    WeddingOrderInfoW
            end;
        _ ->
            WeddingOrderInfoM
    end,
    case WeddingOrderInfo of
        false ->
            WeddingState = 0, BeginTime = 0;
        #wedding_order_info{order_unix_date = OrderUnixDate, time_id = TimeId, begin_time = BeginTime1} -> 
            case BeginTime1 > 0 of 
                false ->
                    WeddingTimeCon = data_wedding:get_wedding_time_con(TimeId),
                    #wedding_time_con{
                        begin_time = {BeginHour, BeginMinute}
                    } = WeddingTimeCon,
                    WeddingState = 2,
                    BeginTime = OrderUnixDate+BeginHour*60*60+BeginMinute*60;
                _ ->
                    WeddingState = 2,
                    BeginTime = BeginTime1
            end
    end,
    % ?PRINT("send_wedding_state_info ~p~n", [{WeddingState, BeginTime}]),
    lib_server_send:send_to_uid(RoleId, pt_172, 17249, [WeddingState, BeginTime]),
    {noreply, State};

do_handle_cast({one_invite_role, Args}, State) ->
    [PlayerId, PlayerName, BaseInviteList|_] = Args,
    #wedding_mgr_state{
        wedding_order_list = WeddingOrderList
    } = State,
    WeddingOrderInfoM = lists:keyfind(PlayerId, #wedding_order_info.role_id_m, WeddingOrderList),
    WeddingOrderInfoW = lists:keyfind(PlayerId, #wedding_order_info.role_id_w, WeddingOrderList),
    case WeddingOrderInfoM of
        false ->
            case WeddingOrderInfoW of
                false ->
                    WeddingOrderInfo = false;
                _ ->
                    WeddingOrderInfo = WeddingOrderInfoW
            end;
        _ ->
            WeddingOrderInfo = WeddingOrderInfoM
    end,
    case WeddingOrderInfo of
        false ->
            ?PRINT("17298 err =============== 222 ~n", []),
            Code = ?ERRCODE(err172_wedding_not_order),
            InviteRoleIdList = [],
            NewState = State;
        _ ->
            #wedding_order_info{
                id = Id,
                role_id_m = RoleIdM,
                role_id_w = RoleIdW,
                guest_list = GuestList,
                ask_invite_list = AskInviteList,
                invited_num = InvitedNum,
                guest_num_max = GuestNumMax,
                order_unix_date = OrderUnixDate,
                time_id = TimeId,
                begin_time = BeginTime1
            } = WeddingOrderInfo,
            LessInviteNum = GuestNumMax - InvitedNum,
            case LessInviteNum =< 0 of
                true ->
                    Code = ?ERRCODE(err172_wedding_guest_num_max),
                    InviteRoleIdList = [],
                    NewState = State;
                _ ->
                    InviteList = [{TemRoleId, TemRoleName} || {TemRoleId, TemRoleName, _TemCCompat} <- lists:sublist(BaseInviteList, LessInviteNum)],
                    F = fun({InviteRoleId, InviteRoleName}, {InviteRoleIdList1, GuestSqlStrList1, NewGuestList1}) ->
                        case lists:keyfind(InviteRoleId, #wedding_guest_info.role_id, NewGuestList1) of
                            false ->
                                NewGuestInfo = #wedding_guest_info{
                                    role_id_m = RoleIdM,
                                    role_id = InviteRoleId,
                                    role_name = InviteRoleName,
                                    answer_type = 1
                                },
                                ReSqlStr = io_lib:format("(~p, ~p, ~p, '~s', ~p)", [Id, RoleIdM, InviteRoleId, InviteRoleName, 1]),
                                {[InviteRoleId|InviteRoleIdList1], [ReSqlStr|GuestSqlStrList1], [NewGuestInfo|NewGuestList1]};
                            _ ->
                                {InviteRoleIdList1, GuestSqlStrList1, NewGuestList1}
                        end
                    end,
                    {InviteRoleIdList, GuestSqlStrList, NewGuestList} = lists:foldl(F, {[], [], GuestList}, InviteList),
                    case InviteRoleIdList of
                        [] ->
                            Code = ?ERRCODE(err172_wedding_have_invite),
                            NewState = State;
                        _ ->
                            Code = ?SUCCESS,
                            %gen_server:cast(self(), {invited_list, InviteRoleIdList}),
                            GuestSqlList = ulists:list_to_string(GuestSqlStrList, ","),
                            Resql = io_lib:format(?ReplaceMWeddingGuestInfoAllSql, [GuestSqlList]),
                            db:execute(Resql),
                            NewInvitedNum = InvitedNum + length(GuestSqlStrList),
                            NewAskInviteList = [{AskId, AskName} ||{AskId, AskName} <- AskInviteList, lists:member(AskId, InviteRoleIdList) == false],
                            NewWeddingOrderInfo = WeddingOrderInfo#wedding_order_info{
                                invited_num = NewInvitedNum,
                                guest_list = NewGuestList,
                                ask_invite_list = NewAskInviteList
                            },
                            lib_marriage_wedding:sql_update_wedding_order([{invited_num, NewInvitedNum}], [{role_id_m, RoleIdM}, {role_id_w, RoleIdW}]),
                            NewWeddingOrderList = lists:keyreplace(RoleIdM, #wedding_order_info.role_id_m, WeddingOrderList, NewWeddingOrderInfo),
                            NewState = State#wedding_mgr_state{
                                wedding_order_list = NewWeddingOrderList
                            },
                            LoverRoleId = case PlayerId of
                                              RoleIdM ->
                                                  RoleIdW;
                                              _ ->
                                                  RoleIdM
                                          end,
                            ?PRINT("do_invite_guest ==== Code ~p~n", [1]),
                            ?PRINT("InviteRoleIdList  ~p~n", [InviteRoleIdList]),
                            %% 通知邮件
                            case BeginTime1 > 0 of
                                false ->
                                    WeddingTimeCon = data_wedding:get_wedding_time_con(TimeId),
                                    #wedding_time_con{
                                        begin_time = {BeginHour, BeginMinute}
                                    } = WeddingTimeCon,
                                    BeginTime = OrderUnixDate+BeginHour*60*60+BeginMinute*60;
                                _ ->
                                    BeginTime = BeginTime1
                            end,
                            {{_Y, Mon, D}, {H, M, _S}} = utime:unixtime_to_localtime(BeginTime),
                            Title = utext:get(1720016),
                            Content = utext:get(1720017, [PlayerName, Mon, D, H, M]),
                            lib_mail_api:send_sys_mail(InviteRoleIdList, Title, Content, ?InviteReward),
                            {ok, Bin1} = pt_172:write(17253, [?ERRCODE(err172_wedding_invite_success), InviteRoleIdList]),
                            lib_server_send:send_to_uid(LoverRoleId, Bin1),
                            send_wedding_start(NewWeddingOrderInfo, InviteRoleIdList)
                    end
            end
    end,
    ?PRINT("17298 code =============== Code ~p~n", [Code]),
    {ok, Bin} = pt_172:write(17298, [Code]),
    lib_server_send:send_to_uid(PlayerId, Bin),
    {noreply, NewState};



do_handle_cast({'stop'}, State) ->
    {stop, normal, State};

do_handle_cast(_Info, State) ->
    {noreply, State}.

handle_info(Info, State) ->
    case catch do_handle_info(Info, State) of
        {'EXIT', _Reason} ->
            ?ERR("~p ~p _Reason:~p~n", [?MODULE, ?LINE, _Reason]),
            {noreply, State};
        Res ->
            Res
    end.

do_handle_info({wedding_order_reflesh}, State) ->
    #wedding_mgr_state{
        wedding_order_list = WeddingOrderList
    } = State,
    NowTime = utime:unixtime(),
    F = fun(WeddingOrderInfo, {DeleteList1, NewWeddingOrderList1}) ->
        #wedding_order_info{
            role_id_m = RoleIdM,
            order_unix_date = OrderUnixDate
        } = WeddingOrderInfo,
        case OrderUnixDate < NowTime-60 andalso OrderUnixDate =/= 0 of
            true ->
                {[RoleIdM|DeleteList1], NewWeddingOrderList1};
            false ->
                {DeleteList1, [WeddingOrderInfo|NewWeddingOrderList1]}
        end
    end,
    {DeleteList, NewWeddingOrderList} = lists:foldl(F, {[], []}, WeddingOrderList),
    case DeleteList of
        [] ->
            skip;
        _ ->
            DeleteListStr = ulists:list_to_string(DeleteList, ","),
            ReSql = io_lib:format(?DelectMWeddingOrderInfoAllSql, [DeleteListStr]),
            db:execute(ReSql)
    end,
    RefleshRef = erlang:send_after(24*60*60*1000, self(), {wedding_order_reflesh}),
    NewState = State#wedding_mgr_state{
        wedding_order_list = NewWeddingOrderList,
        refresh_timer = RefleshRef
    },
    {noreply, NewState};

do_handle_info({wedding_start}, State) ->
    #wedding_mgr_state{
        wedding_order_list = WeddingOrderList
    } = State,
    UnixDate = utime:unixdate(),
    NowTime = utime:unixtime(),
    StartPreTime = ?WeddingStartPreTime,
    F = fun(WeddingOrderInfo, {CoupleSendInfoList1, NewWeddingOrderList1}) ->
        #wedding_order_info{
            id = Id,
            role_id_m = RoleIdM,
            role_id_w = RoleIdW,
            wedding_type = WeddingType,
            order_unix_date = OrderUnixDate,
            time_id = TimeId,
            wedding_pid = OldWeddingPid,
            guest_list = GuestList
        } = WeddingOrderInfo,
        case OrderUnixDate of
            UnixDate ->
                case data_wedding:get_wedding_time_con(TimeId) of       
                    #wedding_time_con{
                        begin_time = {BeginHour, BeginMinute}
                    } ->
                        BeginTime = UnixDate+BeginHour*60*60+BeginMinute*60,
                        BeginTimePre = BeginTime - StartPreTime,
                        case NowTime >= BeginTimePre-10 andalso NowTime < BeginTime+10 andalso OldWeddingPid =:= 0 of
                            true ->
                                Args = [RoleIdM, RoleIdW, TimeId, WeddingType, BeginTime],
                                {ok, WeddingPid} = mod_marriage_wedding:start_link(Args),
                                NewWeddingOrderInfo = WeddingOrderInfo#wedding_order_info{
                                    wedding_pid = WeddingPid,
                                    begin_time = BeginTime
                                },
                                mod_marriage:wedding_start(RoleIdM, WeddingPid),
                                GuestIdList = [GuestRoleId||#wedding_guest_info{role_id = GuestRoleId} <- GuestList],
                                SendInfo = {Id, RoleIdM, RoleIdW, BeginTime, WeddingType, GuestIdList},
                                {[SendInfo|CoupleSendInfoList1], [NewWeddingOrderInfo|NewWeddingOrderList1]};
                            false ->
                                {CoupleSendInfoList1, [WeddingOrderInfo|NewWeddingOrderList1]}
                        end;
                    _ ->
                        {CoupleSendInfoList1, NewWeddingOrderList1}
                end;
            _ ->
                {CoupleSendInfoList1, [WeddingOrderInfo|NewWeddingOrderList1]}
        end
    end,
    {CoupleSendInfoList, NewWeddingOrderList} = lists:foldl(F, {[], []}, WeddingOrderList),
    WeddingTimeIdList = data_wedding:get_wedding_time_id_list(),
    NextWeddingStartTime = lib_marriage_wedding:get_next_wedding_start_time_id(WeddingTimeIdList, NowTime+StartPreTime+10),
    ?PRINT("wedding_start NextWeddingStartTime ~p~n", [NextWeddingStartTime]),
    WeddingStartRef = erlang:send_after(max((NextWeddingStartTime-NowTime)*1000, 100), self(), {wedding_start}),
    case CoupleSendInfoList of
        [] ->
            skip;
        _ ->
            send_wedding_start(CoupleSendInfoList, 1)

    end,
    NewState = State#wedding_mgr_state{
        wedding_order_list = NewWeddingOrderList,
        wedding_start_timer = WeddingStartRef
    },
    {noreply, NewState};

do_handle_info({gm_wedding_start, RoleId}, State) ->
    #wedding_mgr_state{
        wedding_order_list = WeddingOrderList
    } = State,
    WeddingOrderInfoM = lists:keyfind(RoleId, #wedding_order_info.role_id_m, WeddingOrderList),
    WeddingOrderInfoW = lists:keyfind(RoleId, #wedding_order_info.role_id_w, WeddingOrderList),
    WeddingOrderInfo = case WeddingOrderInfoM of
        false ->
            case WeddingOrderInfoW of
                false ->
                    false;
                _ ->
                    WeddingOrderInfoW
            end;
        _ ->
            WeddingOrderInfoM
    end,
    case WeddingOrderInfo of
        false ->
            NewState = State;
        _ ->
            StartPreTime = ?WeddingStartPreTime,
            #wedding_order_info{
                id = Id,
                role_id_m = RoleIdM,
                role_id_w = RoleIdW,
                time_id = TimeId,
                wedding_type = WeddingType,
                guest_list = GuestList
            } = WeddingOrderInfo,
            BeginTime = utime:unixtime() + StartPreTime,
            Args = [RoleIdM, RoleIdW, TimeId, WeddingType, BeginTime],
            {ok, WeddingPid} = mod_marriage_wedding:start_link(Args),
            NewWeddingOrderInfo = WeddingOrderInfo#wedding_order_info{
                wedding_pid = WeddingPid,
                begin_time = BeginTime
            },
            mod_marriage:wedding_start(RoleIdM, WeddingPid),
            GuestIdList = [GuestRoleId||#wedding_guest_info{role_id = GuestRoleId} <- GuestList],
            SendInfoList = [{Id, RoleIdM, RoleIdW, BeginTime, WeddingType, GuestIdList}],
            NewWeddingOrderList = lists:keyreplace(RoleIdM, #wedding_order_info.role_id_m, WeddingOrderList, NewWeddingOrderInfo),
            send_wedding_start(SendInfoList, 1),
            
            NewState = State#wedding_mgr_state{
                wedding_order_list = NewWeddingOrderList
            }
    end,
    {noreply, NewState};

do_handle_info({gm_wedding_end, RoleId}, State) ->
    #wedding_mgr_state{
        wedding_order_list = WeddingOrderList
    } = State,
    WeddingOrderInfoM = lists:keyfind(RoleId, #wedding_order_info.role_id_m, WeddingOrderList),
    WeddingOrderInfoW = lists:keyfind(RoleId, #wedding_order_info.role_id_w, WeddingOrderList),
    WeddingOrderInfo = case WeddingOrderInfoM of
        false ->
            case WeddingOrderInfoW of
                false ->
                    false;
                _ ->
                    WeddingOrderInfoW
            end;
        _ ->
            WeddingOrderInfoM
    end,
    case WeddingOrderInfo of
        false ->
            skip;
        _ ->
            #wedding_order_info{
                wedding_pid = WeddingPid
            } = WeddingOrderInfo,
            WeddingPid ! {wedding_end}
    end,
    {noreply, State};

do_handle_info({'stop'}, State)->
    gen_server:cast(self(), {'stop'}),
    {noreply, State};

do_handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

update_wedding_order_others(Others, Key = ?WEDDING_ORDER_OTHER_KEY_1, {RoleId, CostList}) ->
    {_, List} = ulists:keyfind(Key, 1, Others, {Key, []}),
    {_, DataList} = ulists:keyfind(RoleId, 1, List, {RoleId, []}),
    NewDataList = ulists:object_list_plus_extra(CostList++DataList),
    NewList = lists:keystore(RoleId, 1, List, {RoleId, NewDataList}),
    lists:keystore(Key, 1, Others, {Key, NewList});

update_wedding_order_others(Others, _Key, _Item) ->
    Others.

get_wedding_order_others(Others, Key = ?WEDDING_ORDER_OTHER_KEY_1, RoleId) ->
    {_, List} = ulists:keyfind(Key, 1, Others, {Key, []}),
    {_, DataList} = ulists:keyfind(RoleId, 1, List, {RoleId, []}),
    DataList;

get_wedding_order_others(_Others, _Key, _Item) ->
    [].

send_wedding_start(CoupleSendInfoList, IfStart) when is_list(CoupleSendInfoList) ->
    SendList = get_couple_send_info_list(CoupleSendInfoList, []),
    {ok, Bin} = pt_172:write(17256, [1, SendList]),
    lib_server_send:send_to_all(Bin),
    case IfStart of
        0 ->
            skip;
        _ ->
            skip
            % F = fun(Info) ->
            %     {WeddingType, _BeginTime, ManSendInfoList, WomanSendInfoList, _GuestIdList} = Info,
            %     [{RoleIdM, NameM, _LvM, _PowerM, _SexM, _VipM, _CareerM, _TurnM, _PicM, _PicVerM}] = ManSendInfoList,
            %     [{RoleIdW, NameW, _LvW, _PowerW, _SexW, _VipW, _CareerW, _TurnW, _PicW, _PicVerW}] = WomanSendInfoList,
            %     case data_wedding:get_wedding_info_con(WeddingType) of
            %         [] ->
            %             WeddingName = "";
            %         #wedding_info_con{wedding_name = WeddingName} ->
            %             skip
            %     end
            % end,
            % lists:map(F, SendList)
    end;
send_wedding_start(WeddingOrderInfo, AskRoleIdYesList) ->
    #wedding_order_info{
        id = Id,
        role_id_m = RoleIdM,
        role_id_w = RoleIdW,
        wedding_pid = WeddingPid,
        time_id = TimeId,
        wedding_type = WeddingType,
        begin_time = BeginTime1,
        guest_list = GuestList
    } = WeddingOrderInfo,
    case WeddingPid of 
        0 -> skip;
        _ ->
            case BeginTime1 of
                0 ->
                    WeddingTimeCon = data_wedding:get_wedding_time_con(TimeId),
                    #wedding_time_con{
                        begin_time = {BeginHour, BeginMinute}
                    } = WeddingTimeCon,
                    BeginTime = utime:unixdate()+24*60*60+BeginHour*60*60+BeginMinute*60;
                _ ->
                    BeginTime = BeginTime1
            end,
            GuestIdList = [GuestRoleId||#wedding_guest_info{role_id = GuestRoleId} <- GuestList],
            CoupleSendInfoList = [{Id, RoleIdM, RoleIdW, BeginTime, WeddingType, GuestIdList}],
            SendList = get_couple_send_info_list(CoupleSendInfoList, []),
            {ok, Bin} = pt_172:write(17256, [1, SendList]),
            [lib_server_send:send_to_uid(RoleId, Bin) ||RoleId <- AskRoleIdYesList]
    end.

send_wedding_start_one(RoleId, CoupleSendInfoList) ->
    SendList = get_couple_send_info_list(CoupleSendInfoList, []),
    % ?PRINT("send_wedding_start_one ============ ~n", []),
    % ?PRINT("SendList ~p ~n", [SendList]),
    {ok, Bin} = pt_172:write(17256, [1, SendList]),
    lib_server_send:send_to_uid(RoleId, Bin).

get_couple_send_info_list([T|G], SendList) ->
    {Id, RoleIdM, RoleIdW, BeginTime, WeddingType, GuestIdList} = T,
    case get(?P_STARTTING_WEDDING(Id)) of 
        {#ets_role_show{figure = FigureM, combat_power = PowerM}, #ets_role_show{figure = FigureW, combat_power = PowerW}} -> ok;
        _ ->
            #ets_role_show{figure = FigureM, combat_power = PowerM} = EtsRoleShowM = lib_role:get_role_show(RoleIdM),
            #ets_role_show{figure = FigureW, combat_power = PowerW} = EtsRoleShowW = lib_role:get_role_show(RoleIdW),
            put(?P_STARTTING_WEDDING(Id), {EtsRoleShowM, EtsRoleShowW})
    end,
    #figure{
        name = NameM,
        lv = LvM,
        sex = SexM,
        vip = VipM,
        career = CareerM,
        turn = TurnM,
        picture = PictureM,
        picture_ver = PictureVerM
    } = FigureM,
    #figure{
        name = NameW,
        lv = LvW,
        sex = SexW,
        vip = VipW,
        career = CareerW,
        turn = TurnW,
        picture = PictureW,
        picture_ver = PictureVerW
    } = FigureW,
    PictureMString = util:term_to_string([{picture_id, binary_to_integer(PictureM)}, {career, CareerM}]),
    PictureWString = util:term_to_string([{picture_id, binary_to_integer(PictureW)}, {career, CareerW}]),
    ManSendInfoList = [{RoleIdM, NameM, LvM, PowerM, SexM, VipM, CareerM, TurnM, PictureMString, PictureVerM}],
    WomanSendInfoList = [{RoleIdW, NameW, LvW, PowerW, SexW, VipW, CareerW, TurnW, PictureWString, PictureVerW}],
    NewSendList = [{WeddingType, BeginTime, ManSendInfoList, WomanSendInfoList, GuestIdList}|SendList],
    get_couple_send_info_list(G, NewSendList);
get_couple_send_info_list([], SendList) ->
    SendList.


wedding_fail([]) -> ok;
wedding_fail([{ProposeRoleId, RoleIdM, RoleIdW, WeddingType, Others}|WeddingFailList]) ->
    case data_wedding:get_wedding_info_con(WeddingType) of
        [] ->
            wedding_fail(WeddingFailList);
        WeddingInfoCon ->
            case ProposeRoleId of
                RoleIdM ->
                    LoverRoleId = RoleIdW;
                _ ->
                    LoverRoleId = RoleIdM
            end,
            LoverName = lib_role:get_role_name(LoverRoleId),
            MyName = lib_role:get_role_name(ProposeRoleId),
            #wedding_info_con{
                wedding_name = WeddingName
            } = WeddingInfoCon,
            Title   = ?LAN_MSG(?LAN_TITLE_WEDDING_FAIL),
            ContentLover = utext:get(?LAN_CONTENT_WEDDING_FAIL, [MyName, WeddingName]),
            ContentMe = utext:get(?LAN_CONTENT_WEDDING_FAIL, [LoverName, WeddingName]),
            WeddingFailReturnListLover = get_wedding_order_others(Others, ?WEDDING_ORDER_OTHER_KEY_1, LoverRoleId),
            WeddingFailReturnListMe = get_wedding_order_others(Others, ?WEDDING_ORDER_OTHER_KEY_1, ProposeRoleId),
            lib_mail_api:send_sys_mail([ProposeRoleId], Title, ContentMe, WeddingFailReturnListMe),
            lib_mail_api:send_sys_mail([LoverRoleId], Title, ContentLover, WeddingFailReturnListLover),
            mod_marriage:gm_add_wedding_times(RoleIdM, WeddingType),
            wedding_fail(WeddingFailList)
    end.

wedding_reset_with_merge([]) -> ok;
wedding_reset_with_merge([{ProposeRoleId, RoleIdM, RoleIdW, WeddingType, Others}|WeddingReset]) ->
    case data_wedding:get_wedding_info_con(WeddingType) of
        [] ->
            wedding_reset_with_merge(WeddingReset);
        WeddingInfoCon ->
            case ProposeRoleId of
                RoleIdM ->
                    LoverRoleId = RoleIdW;
                _ ->
                    LoverRoleId = RoleIdM
            end,
            LoverName = lib_role:get_role_name(LoverRoleId),
            MyName = lib_role:get_role_name(ProposeRoleId),
            #wedding_info_con{
                wedding_name = WeddingName
            } = WeddingInfoCon,
            Title   = ?LAN_MSG(?LAN_TITLE_WEDDING_FAIL),
            ContentLover = utext:get(263, [MyName, WeddingName]),
            ContentMe = utext:get(263, [LoverName, WeddingName]),
            WeddingFailReturnListLover = get_wedding_order_others(Others, ?WEDDING_ORDER_OTHER_KEY_1, LoverRoleId),
            WeddingFailReturnListMe = get_wedding_order_others(Others, ?WEDDING_ORDER_OTHER_KEY_1, ProposeRoleId),
            lib_mail_api:send_sys_mail([ProposeRoleId], Title, ContentMe, WeddingFailReturnListMe),
            lib_mail_api:send_sys_mail([LoverRoleId], Title, ContentLover, WeddingFailReturnListLover),
            mod_marriage:gm_add_wedding_times(RoleIdM, WeddingType),
            wedding_reset_with_merge(WeddingReset)
    end.
