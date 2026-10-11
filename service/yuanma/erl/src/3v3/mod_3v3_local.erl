%%% ----------------------------------------------------
%%% @Module:        mod_3v3_local
%%% @Author:        zhl
%%% @Description:   跨服3v3 - 本服
%%% @Created:       2017/07/04
%%% ----------------------------------------------------

-module(mod_3v3_local).
-behaviour(gen_server).
-export([
        init/1,
        handle_call/3,
        handle_cast/2,
        handle_info/2,
        terminate/2,
        code_change/3
    ]).

-export([
        logout/1,                                    %% 登出 
        start_link/0,                                %% 启动本服3v3进程
        cancel_attention/1,                          %% 取消关注界面
        get_team_info/1,                             %% 获取自身队伍信息
        get_team_list/1,                             %% 获取3v3队伍列表
        get_team_data/1,                             %% 查询3v3队伍信息
        get_left_time/1,                             %% 获取活动剩余时间
        open_call_member/1,                          %% 公开招募队友
        set_left_time/0,
        send_to_3v3_team/2                           %% 发送消息给队伍的人
    ]).

-export([
        create_team/1,                               %% 创建队伍 -> 跨服中心
        quick_join_team/1,                           %% 快速加入队伍（个人匹配）-> 跨服中心
        apply_join_team/1,                           %% 申请入队伍 -> 跨服中心
        invite_join_team/1,                          %% 受邀入队伍 -> 跨服中心
        leave_team/1,                                %% 离开队伍 -> 跨服中心
        kick_out_team/1,                             %% 踢出队伍 -> 跨服中心
        invite_role/1,                               %% 邀请玩家 -> 跨服中心
        start_matching_team/1,                       %% 开始匹配战斗 -> 跨服中心
        stop_matching_team/1,                        %% 取消匹配战斗 -> 跨服中心
        reset_ready/1,                               %% 准备 | 取消准备 -> 跨服中心
        reset_auto/1,                                %% 自动开始 | 取消自动开始 -> 跨服中心
        get_battle_info/1,                           %% 获取战场信息
        get_score_rank/1,                            %% 获取天梯排行榜

        test/1
    ]).

-export([
        start_3v3/1,
        gm_start_3v3/1,
        gm_start_3v3/2,
        gm_set_member_limit/1,         
        send_team_info/1,                            %% 跨服中心 -> 获取自身队伍信息结果
        send_create_team/1,                          %% 跨服中心 -> 创建队伍结果
        send_quick_join/1,                           %% 跨服中心 -> 快速加入队伍结果（个人匹配）
        send_apply_join/1,                           %% 跨服中心 -> 申请入队伍结果
        send_invite_join/1,                          %% 跨服中心 -> 受邀入队伍
        send_leave_team/1,                           %% 跨服中心 -> 离开队伍
        send_kick_out/1,                             %% 跨服中心 -> 踢出队伍
        send_invite_role/1,                          %% 跨服中心 -> 邀请玩家 -> 邀请者
        send_invite_info/1,                          %% 跨服中心 -> 邀请玩家 -> 受邀者
        send_reset_ready/1,                          %% 跨服中心 -> 准备 | 取消准备
        send_reset_auto/1,                           %% 跨服中心 -> 自动开始 | 取消自动开始
        send_leave_notice/1,                         %% 发送离队提醒
        send_kick_notice/1,                          %% 发送被踢提醒
        send_stop_matching_notice/1,                 %% 取消匹配提醒
        send_start_matching_notice/1,                %% 开始匹配提醒
        send_leave_pk_room_notice/1,                 %% 推送退出战斗房间提醒
        send_enter_pk_room_notice/1,                 %% 推送重登战斗战场提醒
        send_occupy_tower/1,                         %% 发送神塔采集广播
        send_score_notice/1,                         %% 发送积分变更广播
        send_role_score/1,                           %% 发送玩家积分变更广播
        send_score_rank/1,                           %% 获取天梯排行榜
        update_ets_data/1                            %% 跨服中心 -> 更新数据
        ,send_team_info_to_all/1                     %% 发送队伍信息
    ]).

-include("server.hrl").
-include("predefine.hrl").
-include("common.hrl").
-include("3v3.hrl").
-include("errcode.hrl").
-include("def_module.hrl").
-include("figure.hrl").

%% -------------------------------------------------- 每日清理一次玩家信息
%% -------------------------------------------------- 每周进行一次段位重置 & 段位继承

%% 3v3数据
-record(state, {
        state_3v3 = 0,                               %% 活动状态
        ed_time = 0,                                 %% 结束时间
        score_rank = undefined,                      %% [{Platform, ServerNum, Nickname, Star} | List]
        attention_list = [],                         %% 关注列表
        match_role = [],                             %% 候选玩家 - 匹配中
        team_timer = [],                             %% 队伍匹配倒计时
        act_timer = [],
        member_limit = ?KF_3V3_MEMBER_LIMIT         %% 人数限制
    }).

%% 登出
logout(Args) ->
    gen_server:cast(?MODULE, {logout, Args}).

%% 启动跨服3v3进程
start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

%% 取消关注界面
cancel_attention(Args) ->
    gen_server:cast(?MODULE, {cancel_attention, Args}).

%% 获取自身队伍信息
get_team_info(Args) ->
    gen_server:cast(?MODULE, {get_team_info, Args}).

%% 获取3v3队伍列表
get_team_list(Args) ->
    gen_server:cast(?MODULE, {get_team_list, Args}).

%% 查询3v3队伍信息
get_team_data(Args) ->
    gen_server:cast(?MODULE, {get_team_data, Args}).

%% 获取活动剩余时间
get_left_time(Args) ->
    gen_server:cast(?MODULE, {get_left_time, Args}).

%% 发送消息给
send_to_3v3_team(RoleId, BinData) ->
    gen_server:cast(?MODULE, {send_to_3v3_team, RoleId, BinData}).

%% 跨服中心 -> 获取自身队伍信息结果
send_team_info(Args) ->
    gen_server:cast(?MODULE, {send_team_info, Args}).

%% 跨服中心 -> 获取自身队伍信息结果
send_team_info_to_all(TeamId) ->
    gen_server:cast(?MODULE, {send_team_info_to_all, TeamId}).

%% 创建队伍 -> 跨服中心
create_team(Args) ->
    gen_server:cast(?MODULE, {create_team, Args}).

%% 跨服中心 -> 创建队伍结果
send_create_team(Args) ->
    gen_server:cast(?MODULE, {send_create_team, Args}).

%% 快速加入队伍（个人匹配）-> 跨服中心
quick_join_team(Args) ->
    gen_server:cast(?MODULE, {quick_join_team, Args}).

%% 跨服中心 -> 快速加入队伍结果（个人匹配）
send_quick_join(Args) ->
    gen_server:cast(?MODULE, {send_quick_join, Args}).

%% 申请入队伍 -> 跨服中心
apply_join_team(Args) ->
    gen_server:cast(?MODULE, {apply_join_team, Args}).

%% 跨服中心 -> 申请入队伍结果
send_apply_join(Args) ->
    gen_server:cast(?MODULE, {send_apply_join, Args}).

%% 受邀入队伍 -> 跨服中心
invite_join_team(Args) ->
    gen_server:cast(?MODULE, {invite_join_team, Args}).

%% 跨服中心 -> 受邀入队伍
send_invite_join(Args) ->
    gen_server:cast(?MODULE, {send_invite_join, Args}).

%% 离开队伍 -> 跨服中心
leave_team(Args) ->
    gen_server:cast(?MODULE, {leave_team, Args}).

%% 跨服中心 -> 离开队伍
send_leave_team(Args) ->
    gen_server:cast(?MODULE, {send_leave_team, Args}).

%% 踢出队伍 -> 跨服中心
kick_out_team(Args) ->
    gen_server:cast(?MODULE, {kick_out_team, Args}).

%% 跨服中心 -> 踢出队伍
send_kick_out(Args) ->
    gen_server:cast(?MODULE, {send_kick_out, Args}).

%% 邀请玩家 -> 跨服中心
invite_role(Args) ->
    gen_server:cast(?MODULE, {invite_role, Args}).

%% 跨服中心 -> 邀请玩家
send_invite_role(Args) ->
    gen_server:cast(?MODULE, {send_invite_role, Args}).

%% 跨服中心 -> 邀请玩家 -> 受邀者
send_invite_info(Args) ->
    gen_server:cast(?MODULE, {send_invite_info, Args}).

%% 开始匹配 -> 跨服中心
start_matching_team(Args) ->
    gen_server:cast(?MODULE, {start_matching_team, Args}).

%% 取消匹配 -> 跨服中心
stop_matching_team(Args) ->
    gen_server:cast(?MODULE, {stop_matching_team, Args}).

%% 准备 | 取消准备 -> 跨服中心
reset_ready(Args) ->
    gen_server:cast(?MODULE, {reset_ready, Args}).

%% 跨服中心 -> 准备 | 取消准备
send_reset_ready(Args) ->
    gen_server:cast(?MODULE, {send_reset_ready, Args}).

%% 自动开始 | 取消自动开始 -> 跨服中心
reset_auto(Args) ->
    gen_server:cast(?MODULE, {reset_auto, Args}).

%% 跨服中心 -> 自动开始 | 取消自动开始
send_reset_auto(Args) ->
    gen_server:cast(?MODULE, {send_reset_auto, Args}).

%% 发送离队提醒
send_leave_notice(Args) ->
    gen_server:cast(?MODULE, {send_leave_notice, Args}).

%% 发送被踢提醒
send_kick_notice(Args) ->
    gen_server:cast(?MODULE, {send_kick_notice, Args}).

%% 取消匹配提醒
send_stop_matching_notice(Args) ->
    gen_server:cast(?MODULE, {send_stop_matching_notice, Args}).

%% 开始匹配提醒
send_start_matching_notice(Args) ->
    gen_server:cast(?MODULE, {send_start_matching_notice, Args}).

%% 推送退出战斗房间提醒
send_leave_pk_room_notice(Args) ->
    gen_server:cast(?MODULE, {send_leave_pk_room_notice, Args}).

%% 推送重登战斗战场提醒
send_enter_pk_room_notice(Args) ->
    gen_server:cast(?MODULE, {send_enter_pk_room_notice, Args}).

%% 发送神塔采集广播
send_occupy_tower(Args) ->
    gen_server:cast(?MODULE, {send_occupy_tower, Args}).

%% 发送积分变更广播
send_score_notice(Args) ->
    gen_server:cast(?MODULE, {send_score_notice, Args}).
    
%% 发送玩家积分变更广播
send_role_score(Args) ->
    gen_server:cast(?MODULE, {send_role_score, Args}).

%% 获取战场信息
get_battle_info(Args) ->
    gen_server:cast(?MODULE, {get_battle_info, Args}).

%% 获取天梯排行榜
get_score_rank(Args) ->
    gen_server:cast(?MODULE, {get_score_rank, Args}).

%% 获取天梯排行榜
send_score_rank(Args) ->
    gen_server:cast(?MODULE, {send_score_rank, Args}).

%% 跨服中心 -> 更新数据
update_ets_data(Args) ->
    gen_server:cast(?MODULE, {update_ets_data, Args}).

start_3v3(LastTime) ->
    ?MODULE ! {start_3v3, LastTime}.

gm_start_3v3(LastTime) ->
    ?MODULE ! {gm_start_3v3, LastTime}.

gm_start_3v3(LastTime, MemberLimit) ->
    ?MODULE ! {gm_start_3v3, LastTime, MemberLimit}.

gm_set_member_limit(MemberLimit) ->
    ?MODULE ! {gm_set_member_limit, MemberLimit}.

%% 公开招募队友
open_call_member(Args) ->
    ?MODULE ! {open_call_member, Args}.

set_left_time() ->
    ?MODULE ! {set_left_time}.

test(Args) ->
    gen_server:cast(?MODULE, {test, Args}).

%% 进程不能挂掉，暂时不考虑进程会挂掉的情况
init([]) ->
    process_flag(trap_exit, true),
    ets:new(?ETS_TEAM_DATA, [named_table, {keypos, #kf_3v3_team_data.team_id}, {read_concurrency, true}]),
    % ets:new(?ETS_RANK_DATA, [named_table, {keypos, #kf_3v3_rank_data.role_id}, {read_concurrency, true}]), - 暂时不同步
    ets:new(?ETS_ROLE_DATA, [named_table, {keypos, #kf_3v3_role_data.role_id}, {read_concurrency, true}]),
    {ok, #state{}}.

handle_call(_Request, _From, State) ->
    {reply, ok, State}.

handle_cast(Request, State) ->
    try
        do_handle_cast(Request, State)
    catch
        throw:{error, _Reason} ->
            {noreply, State};
        throw:_ ->
            {noreply, State};
        _:Error ->
            ?ERR("handle call exception~n"
                 "error:~p~n"
                 "state:~p~n"
                 "stack:~p", [Error, State, erlang:get_stacktrace()]),
            {noreply, State}
    end.

handle_info(Request, State) ->
    try
        do_handle_info(Request, State)
    catch
        throw:{error, _Reason} ->
            {noreply, State};
        throw:_ ->
            {noreply, State};
        _:Error ->
            ?ERR("handle call exception~n"
                 "error:~p~n"
                 "state:~p~n"
                 "stack:~p", [Error, State, erlang:get_stacktrace()]),
            {noreply, State}
    end.

terminate(_Reason, _State) ->
    %% ?ERR("~p is terminate:~p", [?MODULE, _Reason]),
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%% 取消关注界面
%% Type : ?PK_3V3_OFFLINE
do_handle_cast({logout, [Platform, ServerNum, ServerId, RoleID, RoleSid, Type, Is3v3Scene]}, State) ->
    #state{state_3v3 = State3v3} = State,
    if
        State3v3 /= ?KF_3V3_STATE_START -> skip;
        true ->
           mod_clusters_node:apply_cast(mod_3v3_center, logout, [[Platform, ServerNum, ServerId, RoleID, RoleSid, Type, Is3v3Scene]])
    end,
    {noreply, State};

%% 取消关注界面
do_handle_cast({cancel_attention, [RoleID]}, State) ->
    #state{attention_list = AttenList} = State,
    NAttenList = lists:keydelete(RoleID, #attention_list.role_id, AttenList),
    {noreply, State#state{attention_list = NAttenList}};

%% 获取自身队伍信息
do_handle_cast({get_team_info, [RoleID, RoleSid]}, State) ->
    #state{state_3v3 = State3v3} = State,
    if
        State3v3 /= ?KF_3V3_STATE_START ->
            Data = lib_3v3_local:pack_team_info(?ERRCODE(err650_kf_3v3_not_start), []);
        true ->
            case lib_3v3_local:get_unite_role_data(RoleID) of
                {ok, #kf_3v3_role_data{team_id = TeamID}} when TeamID > 0 ->
                    case lib_3v3_local:get_unite_team_data(TeamID) of
                        {ok, #kf_3v3_team_data{} = TeamData} ->
                            Data = lib_3v3_local:pack_team_info(TeamData);
                        _ ->
                            Data = lib_3v3_local:pack_team_info(?ERRCODE(err650_kf_3v3_no_team), [])
                    end;
                _ ->
%%                    ?MYLOG("3v32", "err650_kf_3v3_not_joined ~n", [err650_kf_3v3_not_joined]),
                    Data = lib_3v3_local:pack_team_info(?ERRCODE(err650_kf_3v3_not_joined), [])
            end
    end,
    {ok, Bin} = pt_650:write(65010, Data),
    lib_server_send:send_to_sid(RoleSid, Bin),
    {noreply, State};

do_handle_cast({send_to_3v3_team, RoleId, BinData}, State) ->
    case lib_3v3_local:get_unite_role_data(RoleId) of
        {ok, #kf_3v3_role_data{team_id = TeamID}} when TeamID > 0 ->
            case lib_3v3_local:get_unite_team_data(TeamID) of
                {ok, #kf_3v3_team_data{member_data = Members}} ->
                    MyNode = mod_disperse:get_clusters_node(),
                    [begin
                         case Node of
                             MyNode ->
                                 lib_server_send:send_to_uid(Id, BinData);
                             _ ->
                                 mod_clusters_node:apply_cast(lib_server_send, send_to_uid, [Node, Id, BinData])
                         end
                     end || #kf_3v3_role_data{node = Node, role_id = Id} <- Members];
                _ ->
                    lib_server_send:send_to_uid(RoleId, BinData)
            end;
        _ ->
            lib_server_send:send_to_uid(RoleId, BinData)
    end,
    {noreply, State};

%% 获取3v3队伍列表
do_handle_cast({get_team_list, [RoleID, RoleSid, ServerId]}, #state{attention_list = AttenList} = State) ->
    TeamList = ets:tab2list(?ETS_TEAM_DATA),
    Data = lib_3v3_local:pack_team_list(
        ?ERRCODE(err650_kf_3v3_update_teamlist), TeamList, ServerId),
    lib_3v3_local:send_team_list([#attention_list{sid = RoleSid}], Data), %% 推送 65011 队伍列表

    NAttenList = [#attention_list{role_id = RoleID, sid = RoleSid} | 
        lists:keydelete(RoleID, #attention_list.role_id, AttenList)],
    {noreply, State#state{attention_list = NAttenList}};




%% 查询3v3队伍信息
do_handle_cast({get_team_data, [RoleSid, TeamID]}, State) ->
    TeamData = ets:lookup(?ETS_TEAM_DATA, TeamID),
    Data = lib_3v3_local:pack_team_data(TeamData),
    {ok, Bin} = pt_650:write(65012, Data),
    lib_server_send:send_to_sid(RoleSid, Bin),
    {noreply, State};


%% 查询3v3队伍信息
do_handle_cast({send_team_info_to_all, TeamId},  State) ->
    case ets:lookup(?ETS_TEAM_DATA, TeamId) of
        [TeamData] ->
            #kf_3v3_team_data{member_data = MemberData} = TeamData,
%%            ?MYLOG("3v3", "65010  TeamData ~n ~p~n", [TeamData]),
	        Data = lib_3v3_local:pack_team_info(TeamData),
            lib_3v3_local:send_team_data(MemberData, Data); %% 推送 65010 队伍信息
        _ -> skip
    end,
    {noreply, State};

%% 获取活动剩余时间
do_handle_cast({get_left_time, RoleSid}, #state{ed_time = EdTime, state_3v3 = State3v3} = State) ->
    if
        State3v3 == ?KF_3V3_STATE_START ->
            NowSec = utime:get_seconds_from_midnight(),
            LeftTime = erlang:max(EdTime - NowSec, 0);
        true ->
            LeftTime = 0
    end,
    {ok, Bin} = pt_650:write(65005, [LeftTime]),
    lib_server_send:send_to_sid(RoleSid, Bin),
    {noreply, State};

%% 创建队伍 -> 跨服中心
do_handle_cast({create_team, RoleData}, State) ->
    #state{state_3v3 = State3v3} = State,
    #role_data{role_id = RoleID, sid = RoleSid, password = Password} = RoleData,
    if
        State3v3 /= ?KF_3V3_STATE_START ->
            Res = {false, ?ERRCODE(err650_kf_3v3_not_start)};
        Password > 999999 -> %% 密码不能超过6位数
            Res = {false, ?ERRCODE(err650_kf_3v3_long_pasm)};
        true ->
            Res = lib_3v3_local:is_in_team(RoleID)
    end,
    case Res of
        {false, ResID} ->
            {ok, Bin} = pt_650:write(65013, [ResID]),
            lib_server_send:send_to_sid(RoleSid, Bin);
        _ ->
            mod_clusters_node:apply_cast(mod_3v3_center, create_team, [RoleData])
    end,
    {noreply, State};

%% 跨服中心 -> 创建队伍结果
do_handle_cast({send_create_team, [RoleSid, ResID]}, State) ->
    {ok, Bin} = pt_650:write(65013, [ResID]),
    lib_server_send:send_to_sid(RoleSid, Bin),
    {noreply, State};

%% 快速加入队伍（个人匹配）-> 跨服中心
do_handle_cast({quick_join_team, [RoleData, Type]}, #state{state_3v3 = State3v3, ed_time = EdTime} = State) ->
    NowSec = utime:get_seconds_from_midnight(),
    #role_data{
        server_id = ServerId, sid = RoleSid, role_id = RoleID
    } = RoleData,
    if
        State3v3 /= ?KF_3V3_STATE_START ->
            Res = {false, ?ERRCODE(err650_kf_3v3_not_start)};
        EdTime =< NowSec + ?KF_3V3_PK_TIME2 -> %% 活动时间剩余不足3min
            Res = {false, ?ERRCODE(err650_kf_3v3_come_to_end)};
%%        Password > 999999 -> %% 密码不能超过6位数
%%            Res = {false, ?ERRCODE(err650_kf_3v3_long_pasm)};
        Type == ?KF_3V3_START_ROLE -> %% 开始匹配组队
            %%设置锁
            lib_player:apply_cast(RoleID, ?APPLY_CAST_STATUS, lib_3v3_local, cast_change_status, [?ERRCODE(err650_in_kf_3v3_act_single)]),
            MFA = {mod_3v3_center, start_matching_role, [[RoleData]]},
            Res = {ok, MFA};
        true -> %% 取消匹配组队
            lib_player:apply_cast(RoleID, ?APPLY_CAST_STATUS, lib_3v3_local, cast_change_status, [free]),
            MFA = {mod_3v3_center, stop_matching_role, [[ServerId, RoleSid, RoleID]]},
            Res = {ok, MFA}
    end,
    case Res of
        {false, ResID} ->
            {ok, Bin} = pt_650:write(65014, [ResID, Type]),
            lib_server_send:send_to_sid(RoleSid, Bin);
        {ok, {M, F, A}} ->
            mod_clusters_node:apply_cast(M, F, A)
    end,
    {noreply, State};

%% 跨服中心 -> 快速加入队伍结果（个人匹配）
do_handle_cast({send_quick_join, [RoleSid, ResID, Type]}, State) ->
    ?MYLOG("3v3", "send_quick_join ~p ~n", [{RoleSid, ResID, Type}]),
    {ok, Bin} = pt_650:write(65014, [ResID, Type]),
    lib_server_send:send_to_sid(RoleSid, Bin),
    {noreply, State};

%% 申请入队伍 -> 跨服中心
do_handle_cast({apply_join_team, [RoleData, TeamID, Password]}, State) ->
    #state{state_3v3 = State3v3} = State,
    #role_data{sid = RoleSid, role_id = RoleID} = RoleData,
    if
        State3v3 /= ?KF_3V3_STATE_START ->
            Res = {false, ?ERRCODE(err650_kf_3v3_not_start)};
        true ->
            Res = lib_3v3_local:is_in_team(RoleID)
    end,
    case Res of
        {false, ResID} ->
            {ok, Bin} = pt_650:write(65015, [ResID]),
            lib_server_send:send_to_sid(RoleSid, Bin);
        _ ->
            mod_clusters_node:apply_cast(mod_3v3_center, apply_join_team, [[RoleData, TeamID, Password]])
    end,
    {noreply, State};

%% 跨服中心 -> 申请入队伍结果
do_handle_cast({send_apply_join, [RoleSid, ResID]}, State) ->
    {ok, Bin} = pt_650:write(65015, [ResID]),
    lib_server_send:send_to_sid(RoleSid, Bin),
    {noreply, State};

%% 受邀入队伍 -> 跨服中心
do_handle_cast({invite_join_team, [RoleData, TeamID, Password]}, State) ->
    #state{state_3v3 = State3v3} = State,
    #role_data{role_id = RoleID, sid = RoleSid} = RoleData,
    if
        State3v3 /= ?KF_3V3_STATE_START ->
            Res = {false, ?ERRCODE(err650_kf_3v3_not_start)};
        true ->
            Res = lib_3v3_local:is_in_team(RoleID)
    end,
    case Res of
        {false, ResID} ->
            {ok, Bin} = pt_650:write(65016, [ResID]),
            lib_server_send:send_to_sid(RoleSid, Bin);
        _ ->
            mod_clusters_node:apply_cast(mod_3v3_center, invite_join_team, [[RoleData, TeamID, Password]])
    end,
    {noreply, State};

%% 跨服中心 -> 受邀入队伍
do_handle_cast({send_invite_join, [RoleSid, ResID]}, State) ->
    {ok, Bin} = pt_650:write(65016, [ResID]),
    lib_server_send:send_to_sid(RoleSid, Bin),
    {noreply, State};

%% 离开队伍 -> 跨服中心
do_handle_cast({leave_team, [Platform, ServerNum, ServerId, RoleID, RoleSid]}, State) ->
    #state{state_3v3 = State3v3} = State,
    if
        State3v3 /= ?KF_3V3_STATE_START ->
            {ok, Bin} = pt_650:write(65017, [?ERRCODE(err650_kf_3v3_not_start)]),
            lib_server_send:send_to_sid(RoleSid, Bin);
        true ->
            lib_player:apply_cast(RoleID, ?APPLY_CAST_STATUS, lib_3v3_local, cast_change_status, [free]),
            mod_clusters_node:apply_cast(mod_3v3_center, leave_team, [[Platform, ServerNum, ServerId, RoleID, RoleSid]])
    end,
    {noreply, State};

%% 跨服中心 -> 离开队伍
do_handle_cast({send_leave_team, [_RoleSid, _ResID]}, State) ->
%%    {ok, Bin} = pt_650:write(65017, [ResID]),
%%    lib_server_send:send_to_sid(RoleSid, Bin),
%%    SuccessRes = ?SUCCESS,
%%    if
%%        ResID == SuccessRes ->
%%            Data = lib_3v3_local:pack_team_info([]),
%%            lib_3v3_local:send_team_data(
%%                [#kf_3v3_role_data{node = node(), sid = RoleSid}], Data); %% 推送 65010 队伍信息
%%        true -> skip
%%    end,
    {noreply, State};

%% 踢出队伍 -> 跨服中心
do_handle_cast({kick_out_team, [_ServerId, RoleID, RoleSid, TRID] = Args}, #state{state_3v3 = State3v3} = State) ->
    if
        State3v3 /= ?KF_3V3_STATE_START ->
            Res = {false, ?ERRCODE(err650_kf_3v3_not_start)};
        RoleID == TRID ->
            Res = {false, ?ERRCODE(err650_kf_3v3_kick_self)};
        true ->
            Res = lib_3v3_center:get_unite_role_data(RoleID)
    end,
    case Res of
        {false, ResID} ->
            {ok, Bin} = pt_650:write(65018, [ResID]),
            lib_server_send:send_to_sid(RoleSid, Bin);
        {ok, #kf_3v3_role_data{team_id = TeamID}} when TeamID == 0 ->
            {ok, Bin} = pt_650:write(65018, [?ERRCODE(err650_kf_3v3_not_joined)]),
            lib_server_send:send_to_sid(RoleSid, Bin);
        _ ->
            mod_clusters_node:apply_cast(mod_3v3_center, kick_out_team, [Args])
    end,
    {noreply, State};

%% 跨服中心 -> 踢出队伍
do_handle_cast({send_kick_out, [RoleSid, ResID]}, State) ->
    {ok, Bin} = pt_650:write(65018, [ResID]),
    lib_server_send:send_to_sid(RoleSid, Bin),
    {noreply, State};

%% 邀请玩家 -> 跨服中心
do_handle_cast({invite_role, [ServerId, RoleID, RoleSid, TRID]}, State) ->
    #state{state_3v3 = State3v3} = State,
    if
        State3v3 /= ?KF_3V3_STATE_START ->
            Res = {false, ?ERRCODE(err650_kf_3v3_not_start)};
        true ->
            case lib_3v3_center:get_unite_role_data(RoleID) of
                {ok, #kf_3v3_role_data{team_id = TeamID}} when TeamID == 0 ->
                    Res = {false, ?ERRCODE(err650_kf_3v3_not_joined)};
                {ok, #kf_3v3_role_data{} = UniteRoleData} ->
                    case lib_3v3_center:get_unite_role_data(TRID) of
                        {ok, #kf_3v3_role_data{team_id = TTeamID}} when TTeamID > 0 ->
                            Res = {false, ?ERRCODE(err650_kf_3v3_in_team)};
                        _ ->
                            Res = {ok, UniteRoleData}
                    end;
                Res -> ok
            end
    end,
    case Res of
        {false, ResID} ->
            {ok, Bin} = pt_650:write(65019, [ResID, TRID]),
            lib_server_send:send_to_sid(RoleSid, Bin);
        {ok, _} ->
            mod_clusters_node:apply_cast(mod_3v3_center, invite_role, [[ServerId, RoleID, RoleSid, TRID]])
    end,
    {noreply, State};

%% 跨服中心 -> 邀请玩家 -> 邀请者
do_handle_cast({send_invite_role, [RoleSid, ResID, TRID]}, State) ->
    {ok, Bin} = pt_650:write(65019, [ResID, TRID]),
    lib_server_send:send_to_sid(RoleSid, Bin),
    {noreply, State};

%% 跨服中心 -> 邀请玩家 -> 受邀者
do_handle_cast({send_invite_info, [_, []]}, State) ->
    {noreply, State};
do_handle_cast({send_invite_info, [RoleID, Data]}, State) ->
    {ok, Bin} = pt_650:write(65020, Data),
    lib_server_send:send_to_uid(RoleID, Bin),
    {noreply, State};

%% 开始匹配 -> 跨服中心
do_handle_cast({start_matching_team, [ServerId, RoleID, RoleSid]}, State) ->
    #state{state_3v3 = State3v3, ed_time = EdTime} = State,
    NowSec = utime:get_seconds_from_midnight(),
    if
        State3v3 /= ?KF_3V3_STATE_START ->
            {ok, Bin} = pt_650:write(65021, [?ERRCODE(err650_kf_3v3_not_start)]),
            lib_server_send:send_to_sid(RoleSid, Bin);
        EdTime =< NowSec + ?KF_3V3_PK_TIME2 -> %% 活动时间剩余不足3min
            {ok, Bin} = pt_650:write(65021, [?ERRCODE(err650_kf_3v3_come_to_end)]),
            lib_server_send:send_to_sid(RoleSid, Bin);
        true ->
            mod_clusters_node:apply_cast(mod_3v3_center, start_matching_team, [[ServerId, RoleID, RoleSid]])
    end,
    {noreply, State};

%% 取消匹配 -> 跨服中心
do_handle_cast({stop_matching_team, [Platform, ServerNum, ServerId, RoleID, RoleSid]}, State) ->
    #state{state_3v3 = State3v3} = State,
    if
        State3v3 /= ?KF_3V3_STATE_START ->
            {ok, Bin} = pt_650:write(65022, [?ERRCODE(err650_kf_3v3_not_start), Platform, ServerNum, RoleID]),
            lib_server_send:send_to_sid(RoleSid, Bin);
        true ->
            mod_clusters_node:apply_cast(mod_3v3_center, stop_matching_team, [[Platform, ServerNum, ServerId, RoleID, RoleSid]])
    end,
    {noreply, State};

%% 准备 | 取消准备 -> 跨服中心
do_handle_cast({reset_ready, [ServerId, RoleID, RoleSid, IsReady]}, State) ->
    #state{state_3v3 = State3v3} = State,
    if
        State3v3 /= ?KF_3V3_STATE_START ->
            {ok, Bin} = pt_650:write(65023, [?ERRCODE(err650_kf_3v3_not_start), 0]),
            lib_server_send:send_to_sid(RoleSid, Bin);
        true ->
            mod_clusters_node:apply_cast(mod_3v3_center, reset_ready, [[ServerId, RoleID, RoleSid, IsReady]])
    end,
    {noreply, State};

%% 跨服中心 -> 准备 | 取消准备
do_handle_cast({send_reset_ready, [RoleSid, ResID, IsReady]}, State) ->
    {ok, Bin} = pt_650:write(65023, [ResID, IsReady]),
    lib_server_send:send_to_sid(RoleSid, Bin),
    {noreply, State};

%% 自动开始 | 取消自动开始 -> 跨服中心
do_handle_cast({reset_auto, [ServerId, RoleID, RoleSid, IsAuto]}, State) ->
    #state{state_3v3 = State3v3} = State,
    if
        State3v3 /= ?KF_3V3_STATE_START ->
            {ok, Bin} = pt_650:write(65024, [?ERRCODE(err650_kf_3v3_not_start), 0]),
            lib_server_send:send_to_sid(RoleSid, Bin);
        true ->
            mod_clusters_node:apply_cast(mod_3v3_center, reset_auto, [[ServerId, RoleID, RoleSid, IsAuto]])
    end,
    {noreply, State};

%% 跨服中心 -> 自动开始 | 取消自动开始
do_handle_cast({send_reset_auto, [RoleSid, ResID, IsAuto]}, State) ->
    {ok, Bin} = pt_650:write(65024, [ResID, IsAuto]),
    lib_server_send:send_to_sid(RoleSid, Bin),
    {noreply, State};

%% 发送离队提醒
do_handle_cast({send_leave_notice, [RoleRId, Data]}, State) ->
    {ok, Bin} = pt_650:write(65025, Data),
    lib_server_send:send_to_uid(RoleRId, Bin),
    {noreply, State};

%% 发送被踢提醒
do_handle_cast({send_kick_notice, [RoleSid]}, State) ->
    {ok, Bin} = pt_650:write(65026, []),
    lib_server_send:send_to_sid(RoleSid, Bin),
    Data = lib_3v3_local:pack_team_info([]),
    lib_3v3_local:send_team_data([#kf_3v3_role_data{node = node(), sid = RoleSid}], Data), %% 推送 65010 队伍信息
    {noreply, State};

%% 退出战斗房间提醒
do_handle_cast({send_leave_pk_room_notice, [_RoleSid, _Data]}, State) ->
    %% todo
%%    {ok, Bin} = pt_650:write(65032, Data),
%%    lib_server_send:send_to_sid(RoleSid, Bin),
    {noreply, State};

%% 推送重登战斗战场提醒
do_handle_cast({send_enter_pk_room_notice, [RoleSid, Data]}, State) ->
    {ok, Bin} = pt_650:write(65033, Data),
    lib_server_send:send_to_sid(RoleSid, Bin),
    {noreply, State};

%% 开始匹配提醒
do_handle_cast({send_start_matching_notice, [RoleSid, Data]}, State) ->
    {ok, Bin} = pt_650:write(65021, Data),
    lib_server_send:send_to_sid(RoleSid, Bin),
    {noreply, State};

%% 取消匹配提醒
do_handle_cast({send_stop_matching_notice, [RoleSid, Data]}, State) ->
    {ok, Bin} = pt_650:write(65022, Data),
    case is_pid(RoleSid) of
        true ->
            case is_process_alive(RoleSid) of
                true ->
                    lib_server_send:send_to_sid(RoleSid, Bin);
                _ ->
                    skip
            end;
        _ ->
            ok
    end,
    {noreply, State};

%% 发送神塔采集广播
do_handle_cast({send_occupy_tower, [RoleSid]}, State) ->
    {ok, Bin} = pt_650:write(65031, []),
    lib_server_send:send_to_sid(RoleSid, Bin),
    {noreply, State};

%% 发送积分变更广播
do_handle_cast({send_score_notice, [RoleId, Data]}, State) ->
    {ok, Bin} = pt_650:write(65035, Data),
    lib_server_send:send_to_uid(RoleId, Bin),
    {noreply, State};

%% 发送玩家积分变更广播
do_handle_cast({send_role_score, [RoleSid, Data]}, State) ->
    {ok, Bin} = pt_650:write(65036, Data),
    case is_pid(RoleSid) of
        true ->
            case is_process_alive(RoleSid) of
                true ->
                    lib_server_send:send_to_sid(RoleSid, Bin);
                _ ->
                    skip
            end;
        _ ->
            ok
    end,
    {noreply, State};

%% 获取战场信息
do_handle_cast({get_battle_info, [ServerId, RoleID, RoleSid]}, State) ->
    #state{state_3v3 = State3v3} = State,
    if
        State3v3 /= ?KF_3V3_STATE_START ->
            ?MYLOG("3v32", "++++++++++++~n", []),
            {ok, Bin} = pt_650:write(65030, [?ERRCODE(err650_kf_3v3_war_end), 0, 0, 0, [], 0, 0]),
            lib_server_send:send_to_uid(RoleID, Bin);
        true ->
            mod_clusters_node:apply_cast(mod_3v3_center, get_battle_info, [[ServerId, RoleID, RoleSid]])
    end,
    {noreply, State};

%% 获取天梯排行榜
do_handle_cast({get_score_rank, [ServerId, RoleSid]}, #state{score_rank = _ScoreRank} = State) ->
    mod_clusters_node:apply_cast(mod_3v3_rank, get_score_rank, [[ServerId, RoleSid]]),
%%    if
%%        ScoreRank == undefined ->
%%            mod_clusters_node:apply_cast(mod_3v3_rank, get_score_rank, [[ServerId, RoleSid]]);
%%        true ->
%%            ?MYLOG("3v3", "ScoreRank ~p~n", [ScoreRank]),
%%            {ok, Bin} = pt_650:write(65038, [ScoreRank]),
%%            lib_server_send:send_to_sid(RoleSid, Bin)
%%    end,
    {noreply, State};

%% 获取天梯排行榜
do_handle_cast({send_score_rank, [RoleSid, ScoreRank]}, State)  when is_pid(RoleSid)->
    ?MYLOG("3v3", "send_score_rank ~p~n", [ScoreRank]),
    {ok, Bin} = pt_650:write(65038, [ScoreRank]),
    lib_server_send:send_to_sid(RoleSid, Bin),
    {noreply, State#state{score_rank = ScoreRank}};
do_handle_cast({send_score_rank, ScoreRank}, State) ->
%%    ?MYLOG("3v3", "send_score_rank ~p~n", [ScoreRank]),
    {noreply, State#state{score_rank = ScoreRank}};

%% 更新数据
do_handle_cast({update_ets_data, KeyValueList}, #state{attention_list = AttenList,
    state_3v3 = State3v3} = State) when State3v3 == ?KF_3V3_STATE_START ->
    Platform = config:get_platform(),
    ServerNum = config:get_server_num(),
    F = fun({Type, Tab, Object} = KeyVal) ->
        if
            Type == update andalso Tab == ?ETS_TEAM_DATA ->
                update_to_ets([KeyVal]), %% 更新ets
                #kf_3v3_team_data{member_data = _MemberData} = Object,
%%                Data1 = lib_3v3_local:pack_team_info(Object),
%%	            ?MYLOG("3v3", "65010  Data1 ~n ~p~n", [Data1]),
%%                lib_3v3_local:send_team_data(MemberData, Data1), %% 推送 65010 队伍信息
                case lib_3v3_local:pack_team_list(
                    ?ERRCODE(err650_kf_3v3_update_team), [Object], {Platform, ServerNum}) 
                of
                    [_, []] -> skip;
                    Data2 ->
                        lib_3v3_local:send_team_list(AttenList, Data2) %% 推送 65011 队伍列表
                end;
            Type == delete andalso Tab == ?ETS_TEAM_DATA ->
                case ets:lookup(Tab, Object) of
                    [#kf_3v3_team_data{member_data = MemberData} = TeamData] ->
                        lib_3v3_local:change_status(MemberData, free), %% 修改玩家状态
                        update_to_ets([KeyVal]), %% 更新ets
                        case lib_3v3_local:pack_team_list(
                            ?ERRCODE(err650_kf_3v3_delete_team), [TeamData], {Platform, ServerNum}) 
                        of
                            [_, []] -> skip;
                            Data2 ->
                                lib_3v3_local:send_team_list(AttenList, Data2) %% 推送 65011 队伍列表
                        end;
                    _ -> skip
                end;
            Type == update andalso Tab == ?ETS_ROLE_DATA ->
                lib_3v3_local:change_status([Object], ?ERRCODE(err650_in_kf_3v3_act)), %% 修改玩家状态
                update_to_ets([KeyVal]); %% 更新ets
            Type == delete andalso Tab == ?ETS_ROLE_DATA ->
                case ets:lookup(Tab, Object) of
                    [#kf_3v3_role_data{} = UniteRoleData] ->
                        lib_3v3_local:change_status([UniteRoleData], free); %% 修改玩家状态
                    _ -> skip
                end,
                update_to_ets([KeyVal]); %% 更新ets
            true ->
                update_to_ets([KeyVal])
        end
    end,
    lists:foreach(F, KeyValueList),
    {noreply, State};

do_handle_cast({test, [Platform, ServerNum, RoleID, Group]}, State) ->
    mod_clusters_node:apply_cast(mod_3v3_center, test, [[Platform, ServerNum, RoleID, Group]]),
    {noreply, State};

do_handle_cast(_Request, State) ->
    {noreply, State}.

do_handle_info({end_3v3}, #state{act_timer = _ActTimer, score_rank = ScoreRank, ed_time = EdTime} = _State) ->
    util:cancel_timer(_ActTimer),
    %% 将所有参与3v3玩家全局状态回复正常
    MemberData = ets:tab2list(?ETS_ROLE_DATA),
    lib_3v3_local:change_status(MemberData, free),
    lib_3v3_local:clear_role_status(MemberData),
    ets:delete_all_objects(?ETS_ROLE_DATA),
    ets:delete_all_objects(?ETS_TEAM_DATA),
    NowSec = utime:get_seconds_from_midnight(),
    {ok, Bin} = pt_650:write(65005, [erlang:max(EdTime - NowSec, 0)]),
    lib_server_send:send_to_local_all(Bin),
    lib_activitycalen_api:success_end_activity(?MOD_KF_3V3, 1),
    {noreply, #state{score_rank = ScoreRank}};

do_handle_info({start_3v3, LastTime}, #state{act_timer = _ActTimer} = State) ->
    util:cancel_timer(_ActTimer),
    OpenDay = util:get_open_day(),
    if
        OpenDay < 3 -> %% 开服时间少于3天的不开启
            NState = #state{};
        true ->
            MemberData = ets:tab2list(?ETS_ROLE_DATA),
            lib_3v3_local:change_status(MemberData, free),
            lib_3v3_local:clear_role_status(MemberData),
            ets:delete_all_objects(?ETS_ROLE_DATA),
            ets:delete_all_objects(?ETS_TEAM_DATA),
            NowSec = utime:get_seconds_from_midnight(),
            ActTimer = erlang:send_after(LastTime * 1000, self(), {end_3v3}),
            {ok, Bin} = pt_650:write(65005, [LastTime]),
            lib_server_send:send_to_local_all(Bin),
            lib_activitycalen_api:success_start_activity(?MOD_KF_3V3, 1),
            NState = State#state{ed_time = NowSec + LastTime, 
                state_3v3 = ?KF_3V3_STATE_START, act_timer = ActTimer}
    end,
    {noreply, NState};

do_handle_info({gm_start_3v3, LastTime}, #state{act_timer = _ActTimer} = State) ->
    util:cancel_timer(_ActTimer),
    MemberData = ets:tab2list(?ETS_ROLE_DATA),
    lib_3v3_local:change_status(MemberData, free),
    lib_3v3_local:clear_role_status(MemberData),
    ets:delete_all_objects(?ETS_ROLE_DATA),
    ets:delete_all_objects(?ETS_TEAM_DATA),
    NowSec = utime:get_seconds_from_midnight(),
    ActTimer = erlang:send_after(LastTime * 1000, self(), {end_3v3}),
    {ok, Bin} = pt_650:write(65005, [LastTime]),
    lib_server_send:send_to_local_all(Bin),
    lib_activitycalen_api:success_start_activity(?MOD_KF_3V3, 1),
%%    ?MYLOG("3v3", "LastTime ~p~n", [LastTime]),
    NState = State#state{ed_time = NowSec + LastTime, 
        state_3v3 = ?KF_3V3_STATE_START, act_timer = ActTimer},
    {noreply, NState};

do_handle_info({gm_start_3v3, LastTime, MemberLimit}, #state{act_timer = _ActTimer} = State) ->
    util:cancel_timer(_ActTimer),
    MemberData = ets:tab2list(?ETS_ROLE_DATA),
    lib_3v3_local:change_status(MemberData, free),
    lib_3v3_local:clear_role_status(MemberData),
    ets:delete_all_objects(?ETS_ROLE_DATA),
    ets:delete_all_objects(?ETS_TEAM_DATA),
    NowSec = utime:get_seconds_from_midnight(),
    ActTimer = erlang:send_after(LastTime * 1000, self(), {end_3v3}),
    {ok, Bin} = pt_650:write(65005, [LastTime]),
    lib_server_send:send_to_local_all(Bin),
    lib_activitycalen_api:success_start_activity(?MOD_KF_3V3, 1),
    NState = State#state{ed_time = NowSec + LastTime, 
        state_3v3 = ?KF_3V3_STATE_START, act_timer = ActTimer, member_limit = MemberLimit},
    {noreply, NState};

do_handle_info({gm_set_member_limit, MemberLimit}, #state{act_timer = _ActTimer} = State) ->
    NState = State#state{member_limit = MemberLimit},
    {noreply, NState};

%% 公开招募队友
do_handle_info({open_call_member, [RoleID, Type, #figure{guild_id = GuildID, name = RoleName} = Figure, _CombatPower]}, #state{state_3v3 = State3v3, member_limit = MemberLimit} = State) ->
    if
        State3v3 == ?KF_3V3_STATE_START ->
            case ets:lookup(?ETS_ROLE_DATA, RoleID) of
                [#kf_3v3_role_data{team_id = TeamID}] ->
                    case ets:lookup(?ETS_TEAM_DATA, TeamID) of
                        [#kf_3v3_team_data{password = Password, member_num = MemberNum}] 
                                when MemberNum < MemberLimit andalso Type == 2 -> %% 帮派招募
                            % {ok, Bin} = pt_650:write(65041, [Type, Nickname, TeamID, Password]),
                            % lib_server_send:send_to_guild(GuildID, Bin);
                            lib_chat:send_TV({guild, GuildID}, RoleID, Figure, ?MOD_KF_3V3, 4, [RoleName, TeamID, Password]);
                        [#kf_3v3_team_data{password = Password, member_num = MemberNum}] 
                                when MemberNum < MemberLimit -> %% 世界招募
                            lib_chat:send_TV({all}, RoleID, Figure, ?MOD_KF_3V3, 3, [RoleName, TeamID, Password]);
                            % {ok, Bin} = pt_650:write(65041, [Type, Nickname, TeamID, Password]),
                            % lib_server_send:send_to_local_all(Bin);
                        _ -> 
                            skip
                    end;
                _ -> 
                    skip
            end;
        true -> 
            skip
    end,
    {noreply, State};

do_handle_info({set_left_time}, State) ->
    ServerId = config:get_server_id(),
    mod_clusters_node:apply_cast(mod_3v3_center, get_left_time, [[ServerId]]),
    {noreply, State};

do_handle_info({test, Tab, Key}, State) ->
    ets:delete(Tab, Key),
    {noreply, State};

do_handle_info({test}, State) ->
    io:format("----{test}---~p~n", [State]),
    {noreply, State};

do_handle_info(_Request, State) ->
    {noreply, State}.

%% 更新ets
%% @desc : 注意，这个方法只有mod_3v3_local这个进程才能使用
update_to_ets(KeyValueList) ->
    F = fun({Type, Tab, Obejct}) ->
        case Type of
            update -> ets:insert(Tab, Obejct);
            delete -> ets:delete(Tab, Obejct);
            _ -> skip
        end
    end,
    lists:foreach(F, KeyValueList).