%%-----------------------------------------------------------------------------
%% @Module  :       mod_cloud_buy_mgr.erl
%% @Author  :       hyh
%% @Email   :       huyihao@suyougame.com
%% @Created :       2018-03-20
%% @Description:    众仙云购
%%-----------------------------------------------------------------------------

-module(mod_cloud_buy_mgr).

-include("common.hrl").
-include("custom_act.hrl").
-include("cloud_buy.hrl").
-include("vip.hrl").
-include("errcode.hrl").
-include("def_module.hrl").

-behaviour (gen_server).

-export([start_link/0]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
-export([
    get_info/7,
    order/4,
    get_last_lucky_orders/3,
    get_cur_award_info/5,
    act_start/1,
    gm_award/1,
    gm_restart/0
]).

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

get_info(Node, SubType, RoleId, Sid, VipLv, VipType, StageReward) ->
    gen_server:cast(?MODULE, {get_info, Node, SubType, RoleId, Sid, VipLv, VipType, StageReward}).

order(SubType, Node, Sid, Args) ->
    gen_server:cast(?MODULE, {order, SubType, Node, Sid, Args}).

get_last_lucky_orders(Node, SubType, Sid) ->
    gen_server:cast(?MODULE, {get_last_lucky_orders, Node, SubType, Sid}).

get_cur_award_info(Node, SubType, RoleId, Count, IfAutoBuy) ->
    gen_server:cast(?MODULE, {get_cur_award_info, Node, SubType, RoleId, Count, IfAutoBuy}).

gm_award(Node) ->
    case config:get_cls_type() of
        Node ->
            gen_server:cast(?MODULE, {gm_award});
        _ ->
            skip
    end.

gm_restart() ->
    gen_server:cast(?MODULE, {gm_restart}).

%% 本服活动开启
act_start(SubType) ->
    gen_server:cast(?MODULE, {act_start, SubType}).

init([]) ->
    SubTypeIdList = lib_custom_act_api:get_open_subtype_ids(?CUSTOM_ACT_TYPE_CLOUD_BUY),
    IfCls =  util:is_cls(),
    F = fun(SubType, SubTypeList1) ->
        {if_kf, IfKf} = lib_custom_act_util:keyfind_act_condition(?CUSTOM_ACT_TYPE_CLOUD_BUY, SubType, if_kf),
        case IfCls of
            true ->
                case IfKf of
                    0 ->
                        SubTypeList1;
                    _ ->
                        {ok, SubPid} = mod_cloud_buy:start_link(SubType),
                        SubTypeInfo = #subtype_info{
                            subtype = SubType,
                            sub_pid = SubPid
                        },
                        [SubTypeInfo|SubTypeList1]
                end;
            false ->
                case IfKf of
                    0 ->
                        {ok, SubPid} = mod_cloud_buy:start_link(SubType),
                        SubTypeInfo = #subtype_info{
                            subtype = SubType,
                            sub_pid = SubPid
                        },
                        [SubTypeInfo|SubTypeList1];
                    _ ->
                        SubTypeList1
                end
        end
    end,
    SubTypeList = lists:foldl(F, [], SubTypeIdList),
    NextCheckTime = utime:unixdate() + 24*60*60 - utime:unixtime() + 10,
    CheckTimer = erlang:send_after(NextCheckTime*1000, self(), {check_act}),
    State = #cloud_buy_kf_mgr_state{
        subtype_list = SubTypeList,
        check_timer = CheckTimer
    },
    {ok, State}.

handle_call(Request, From, State) ->
    case catch do_handle_call(Request, From, State) of
        {'EXIT', _Reason} ->
            ?ERR("~p ~p _Reason:~p~n", [?MODULE, ?LINE, _Reason]),
            {reply, ok, State};
        Result ->
            Result
    end.

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

do_handle_cast({gm_restart}, State) ->
    #cloud_buy_kf_mgr_state{subtype_list = SubTypeList} = State,
    [begin
         #subtype_info{
             sub_pid = SubPid
         } = SubInfo,
         erlang:send_after(2*1000, SubPid, {gm_restart})
     end||SubInfo <- SubTypeList],
    {noreply, State};

do_handle_cast({act_start, SubType}, State) ->
    #cloud_buy_kf_mgr_state{
        subtype_list = SubTypeList
    } = State,
    case lists:keyfind(SubType, #subtype_info.subtype, SubTypeList) of
        false ->
            {if_kf, IfKf} = lib_custom_act_util:keyfind_act_condition(?CUSTOM_ACT_TYPE_CLOUD_BUY, SubType, if_kf),
            case IfKf of
                0 ->
                    {ok, SubPid} = mod_cloud_buy:start_link(SubType),
                    SubTypeInfo = #subtype_info{
                        subtype = SubType,
                        sub_pid = SubPid
                    },
                    NewSubTypeList = [SubTypeInfo|SubTypeList];
                _ ->
                    NewSubTypeList = SubTypeList
            end;
        _ ->
            NewSubTypeList = SubTypeList
    end,
    NewState = State#cloud_buy_kf_mgr_state{
        subtype_list = NewSubTypeList
    },
    {noreply, NewState};

do_handle_cast({get_info, Node, SubType, RoleId, Sid, VipLv, VipType, StageReward}, State) ->
    #cloud_buy_kf_mgr_state{
        subtype_list = SubTypeList
    } = State,
    case lists:keyfind(SubType, #subtype_info.subtype, SubTypeList) of
        false ->
            {if_kf, IfKf} = lib_custom_act_util:keyfind_act_condition(?CUSTOM_ACT_TYPE_CLOUD_BUY, SubType, if_kf),
            unode:apply(Node, lib_server_send, send_to_sid, [Sid, pt_331, 33112, [?ERRCODE(err331_act_closed), SubType, IfKf, 0, 0, 0, 0, [], [], 0, 0, 0]]);
        #subtype_info{sub_pid = SubPid} ->
            gen_server:cast(SubPid, {get_info, Node, RoleId, Sid, VipLv, VipType, StageReward})
    end,
    {noreply, State};

do_handle_cast({order, SubType, Node, Sid, Args}, State) ->
    #cloud_buy_kf_mgr_state{
        subtype_list = SubTypeList
    } = State,
    case lists:keyfind(SubType, #subtype_info.subtype, SubTypeList) of
        false ->
            [Node|_] = Args,
            unode:apply(Node, lib_server_send, send_to_sid, [Sid, pt_331, 33113, [?ERRCODE(err331_act_closed), SubType, [], 0]]);
        #subtype_info{sub_pid = SubPid} ->
            gen_server:cast(SubPid, {order, Args})
    end,
    {noreply, State};

do_handle_cast({get_last_lucky_orders, Node, SubType, Sid}, State) ->
    #cloud_buy_kf_mgr_state{
        subtype_list = SubTypeList
    } = State,
    case lists:keyfind(SubType, #subtype_info.subtype, SubTypeList) of
        false ->
            skip;
        #subtype_info{sub_pid = SubPid} ->
            gen_server:cast(SubPid, {get_last_lucky_orders, Node, Sid})
    end,
    {noreply, State};

do_handle_cast({get_cur_award_info, Node, SubType, RoleId, Count, IfAutoBuy}, State) ->
    #cloud_buy_kf_mgr_state{
        subtype_list = SubTypeList
    } = State,
    case lists:keyfind(SubType, #subtype_info.subtype, SubTypeList) of
        false ->
            unode:apply(Node, lib_server_send, send_to_Uid, [RoleId, pt_331, 33113, [?ERRCODE(err331_act_closed), SubType, [], 0]]);
        #subtype_info{sub_pid = SubPid} ->
            gen_server:cast(SubPid, {get_cur_award_info, Node, RoleId, Count, IfAutoBuy})
    end,
    {noreply, State};

do_handle_cast({gm_award}, State) ->
    #cloud_buy_kf_mgr_state{
        subtype_list = SubTypeList,
        check_timer = CheckTimer
    } = State,
    util:cancel_timer(CheckTimer),
    [begin
         #subtype_info{
             sub_pid = SubPid
         } = SubInfo,
         gen_server:cast(SubPid, {gm_award})
     end||SubInfo <- SubTypeList],
    NewState = #cloud_buy_kf_mgr_state{},
    {noreply, NewState};

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

do_handle_info({check_act}, State) ->
    #cloud_buy_kf_mgr_state{
        subtype_list = SubTypeList,
        check_timer = CheckTimer
    } = State,
    util:cancel_timer(CheckTimer),
    IfCls =  util:is_cls(),
    SubTypeIdList = lib_custom_act_api:get_open_subtype_ids(?CUSTOM_ACT_TYPE_CLOUD_BUY),
    %% 删除过期的活动
    F1 = fun(SubTypeInfo, SubTypeList1) ->
        #subtype_info{
            subtype = SubType,
            sub_pid = SubPid
        } = SubTypeInfo,
        case lists:member(SubType, SubTypeIdList) of
            false ->
                gen_server:cast(SubPid, {close}),
                SubTypeList1;
            true ->
                [SubTypeInfo|SubTypeList1]
        end
    end,
    NewSubTypeList1 = lists:foldl(F1, [], SubTypeList),
    %% 新增开始的活动
    F2 = fun(SubType, SubTypeList2) ->
        case lists:keyfind(SubType, #subtype_info.subtype, SubTypeList2) of
            false ->
                {if_kf, IfKf} = lib_custom_act_util:keyfind_act_condition(?CUSTOM_ACT_TYPE_CLOUD_BUY, SubType, if_kf),
                case IfCls of
                    true ->
                        case IfKf of
                            0 ->
                                SubTypeList2;
                            _ ->
                                {ok, SubPid} = mod_cloud_buy:start_link(SubType),
                                SubTypeInfo = #subtype_info{
                                    subtype = SubType,
                                    sub_pid = SubPid
                                },
                                [SubTypeInfo|SubTypeList2]
                        end;
                    false ->
                        case IfKf of
                            0 ->
                                {ok, SubPid} = mod_cloud_buy:start_link(SubType),
                                SubTypeInfo = #subtype_info{
                                    subtype = SubType,
                                    sub_pid = SubPid
                                },
                                [SubTypeInfo|SubTypeList2];
                            _ ->
                                SubTypeList2
                        end
                end;
            _ ->
                SubTypeList2
        end
    end,
    NewSubTypeList = lists:foldl(F2, NewSubTypeList1, SubTypeIdList),
    NewCheckTimer = erlang:send_after(24*60*60*1000, self(), {check_act}),
    NewState = State#cloud_buy_kf_mgr_state{
        subtype_list = NewSubTypeList,
        check_timer = NewCheckTimer
    },
    {noreply, NewState};

do_handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) -> ok.

code_change(_OldVsn, State, _Extra) -> {ok, State}.