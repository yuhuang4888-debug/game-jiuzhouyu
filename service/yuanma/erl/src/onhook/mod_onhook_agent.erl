%%%-------------------------------------------------------------------
%%% @author root <root@localhost.localdomain>
%%% @copyright (C) 2018, root
%%% @doc
%%%
%%% @end
%%% Created : 10 Feb 2018 by root <root@localhost.localdomain>
%%%-------------------------------------------------------------------
-module(mod_onhook_agent).

-include("common.hrl").
-include("predefine.hrl").
-include("rec_onhook.hrl").

%% API
-export([start_link/0, get_role_have_onhook_time/0, onhook_agent_login/4,
         add_to_onhook/4, remove_out_onhook/1, timer_to_onhook/0]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).

%%%===================================================================
%%% API
%%%===================================================================

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

add_to_onhook(RoleId, AccId, AccName, Ip) ->
    gen_server:cast(?MODULE, {'add_to_onhook', RoleId, AccId, AccName, Ip}).

remove_out_onhook(RoleId) ->
    gen_server:cast(?MODULE, {'remove_out_onhook', RoleId}).

timer_to_onhook() ->
    gen_server:cast(?MODULE, {'timer_to_onhook'}).

%%%===================================================================
%%% gen_server callbacks
%%%===================================================================
init([]) ->
    process_flag(trap_exit, true),
    get_role_have_onhook_time(),
    {ok, #onhook_agent{}}.

handle_call(Req, From, State) ->
    case catch do_handle_call(Req, From, State) of
        {reply, Reply, NewState} ->
            {reply, Reply, NewState};
        Res ->
            ?ERR("Req Error:~p~n", [[Req, Res]]),
            {reply, ok, State}
    end.

handle_cast(Msg, State) ->
    case catch do_handle_cast(Msg, State) of
        {noreply, NewState} ->
            {noreply, NewState};
        Res ->
            ?ERR("Msg Error:~p~n", [[Msg, Res]]),
            {noreply, State}
    end.

handle_info(Info, State) ->
    case catch do_handle_info(Info, State) of
        {noreply, NewState} ->
            {noreply, NewState};
        Res ->
            ?ERR("Info Error:~p~n", [[Info, Res]]),
            {noreply, State}
    end.

terminate(_Reason, _State) ->
    ?ERR("~p is terminate:~p", [?MODULE, _Reason]),
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================
do_handle_call(_Req, _From, State) ->
    {reply, ok, State}.

%% 将玩家加入离线挂机的队列
do_handle_cast({'add_to_onhook', RoleId, AccId, AccName, Ip}, State) ->
    #onhook_agent{role_onhook = RoleOnhookList} = State,
    RoleOnhookInfo = #role_onhook_info{id = RoleId,
                                       acc_id = AccId,
                                       acc_name = AccName,
                                       ip = Ip,
                                       time = utime:unixtime()},
    NewRoleOnhookList = lists:keystore(RoleId, #role_onhook_info.id, RoleOnhookList, RoleOnhookInfo),
    {noreply, State#onhook_agent{role_onhook = NewRoleOnhookList}};

%% 将玩家移出离线挂机的队列
do_handle_cast({'remove_out_onhook', RoleId}, State) ->
    #onhook_agent{role_onhook = RoleOnhookList} = State,
    NewRoleOnhookList = lists:keydelete(RoleId, #role_onhook_info.id, RoleOnhookList),
    {noreply, State#onhook_agent{role_onhook = NewRoleOnhookList}};

%% 定时器检查
do_handle_cast({'timer_to_onhook'}, State) ->
    % ?MYLOG("hjhagent", "timer_to_onhook ~n", []),
    #onhook_agent{role_onhook = RoleOnhookList} = State,
    NowTime = utime:unixtime(),
    {NewRoleOnhookList, ToHookRoles} = filter_onhook_angent_role(RoleOnhookList, NowTime, [], []),
    if 
        ToHookRoles == [] -> skip;
        true -> spawn(fun() -> mod_onhook_agent:onhook_agent_login(ToHookRoles, NowTime, 1, 0) end)
    end,
    {noreply, State#onhook_agent{role_onhook = NewRoleOnhookList}};

do_handle_cast(_Msg, State) ->
    {noreply, State}.

do_handle_info(_Info, State) ->
    {noreply, State}.

%% 数据库查找玩家离线挂机玩家信息
get_role_have_onhook_time()->
    OnhookLv = lib_onhook:get_onhook_config(can_onhook_lv),
    CanOnhookTime = lib_onhook:get_onhook_config(can_onhook_time),
    %% 获取两天内有登录的玩家进行离线挂机
    SQL = <<"select pll.id, pll.accid, pll.accname, pll.last_login_ip, pll.last_login_time from player_login pll left join player_low plo on pll.id=plo.id left join role_onhook ro on ro.player_id=plo.id where pll.status=0 and plo.lv > ~p and ro.onhook_time > ~p">>,
    % ?MYLOG("hjhagent", "get_role_have_onhook_time SQL:~p ~n", [db:get_all(io_lib:format(SQL, [OnhookLv, CanOnhookTime]))]),
    case db:get_all(io_lib:format(SQL, [OnhookLv, CanOnhookTime])) of
        [] -> ok;
        List ->
            NowTime = utime:unixtime(),
            RandList = ulists:list_shuffle(List),
            spawn(fun() -> timer:sleep(5000), mod_onhook_agent:onhook_agent_login(RandList, NowTime, 0, 0) end),
            skip
    end.

%% 过滤出玩家挂机信息
filter_onhook_angent_role([], _NowTime, OnhookList, TohookRoles)->
    {OnhookList, TohookRoles};
filter_onhook_angent_role([E|RoleOnhookList], NowTime, OnhookList, TohookRoles)->
    #role_onhook_info{id = RoleId, acc_id = AccId, acc_name = AccName, ip = Ip, time = AddTime} = E,
    if
        NowTime - AddTime >= 180 -> %% 下线超过3分钟才进行离线挂机
            filter_onhook_angent_role(RoleOnhookList, NowTime, OnhookList,
                                      [[RoleId, AccId, AccName, Ip, NowTime]|TohookRoles]);
        true ->
            filter_onhook_angent_role(RoleOnhookList, NowTime, [E|OnhookList], TohookRoles)
    end.

%% 挂机代理模拟登录
onhook_agent_login([], _NowTime, _Type, 0) -> ok;
onhook_agent_login([], _NowTime, 0, Count)->
    catch ?ERR("onhook_agent_sever_start_login_num:~p~n", [Count]);
onhook_agent_login([], _NowTime, 1, Count)->
    catch ?ERR("onhook_agent_sever_normal_login_num:~p~n", [Count]);
% onhook_agent_login([[Id, AccId, BAccName, Ip, LastLoginTime]|T], NowTime, Type, Count)->
%     AccName = util:make_sure_list(BAccName),
%     if 
%         Type == 0 andalso NowTime - LastLoginTime >= 172800 ->
%             onhook_agent_login(T, NowTime, Type, Count); %% 机器重启并且登录时间差距;
%         true ->
%             % ?MYLOG("hjhagent", "onhook_agent_login Id:~p~n", [Id]),
%             RolePid = misc:get_player_process(Id),
%             case is_pid(RolePid) andalso misc:is_process_alive(RolePid) of
%                 false ->
%                     RoleList = lib_login:get_role_list(AccId, AccName),
%                     Ids = [TmpId||[TmpId |_ ] <- RoleList],
%                     LoginParams = #login_params{}
%                     % case catch mod_server:start([Id, Ip, none, AccId, AccName, util:get_server_name(), Ids, 1, none, gsrv_tcp, reader_ws, ?ONHOOK_AGENT_LOGIN]) of
%                         {ok, Pid} ->
%                             % ?MYLOG("hjhagent", "onhook_agent_login Id:~p Pid:~p ~n", [Id, Pid]),
%                             %% 走完正的流程
%                             erlang:unlink(Pid),
%                             % lib_log_api:log_login(Id, Ip, AccId, AccName, ?ONHOOK_AGENT_LOGIN),
%                             timer:sleep(300),
%                             Pid ! {'onhook_agent_login'},
%                             onhook_agent_login(T, NowTime, Type, Count+1);
%                         _R ->
%                             catch ?ERR("onhook_agent_err:~p~n", [_R]),
%                             onhook_agent_login(T, NowTime, Type, Count)
%                     end;
%                 _ ->
%                     onhook_agent_login(T, NowTime, Type, Count)
%             end
%     end;
onhook_agent_login([H|T], NowTime, Type, Count) ->
    ?ERR("onhook_login_H:~p~n", [H]),
    onhook_agent_login(T, NowTime, Type, Count).
