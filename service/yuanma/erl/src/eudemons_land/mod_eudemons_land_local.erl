%%%-------------------------------------------------------------------
%%% @author root <root@localhost.localdomain>
%%% @copyright (C) 2017, root
%%% @doc
%%%
%%% @end
%%% Created : 27 Oct 2017 by root <root@localhost.localdomain>
%%%-------------------------------------------------------------------
-module(mod_eudemons_land_local).

-behaviour(gen_server).

%% API
-export([start_link/0]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).

-compile(export_all).

-include("common.hrl").
-include("eudemons_land.hrl").
-include("def_fun.hrl").
-include("scene.hrl").
-include("errcode.hrl").
-include("predefine.hrl").
-include("def_module.hrl").
-include("goods.hrl").

%%%===================================================================
%%% API
%%%===================================================================

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

%% 获取boss信息
get_eudemons_boss_info(ServerId, RoleId, Sid, BossType, TimesList)->
    gen_server:cast(?MODULE, {'get_eudemons_boss_info', ServerId, RoleId, Sid, BossType, TimesList}).

%% 榜单信息
send_rank_info(ServerId, RoleId, Sid) ->
    gen_server:cast(?MODULE, {'send_rank_info', ServerId, RoleId, Sid}).

%% 获取击杀日志
get_boss_kill_log(Sid, BossType, BossId) ->
    gen_server:cast(?MODULE, {'get_boss_kill_log', Sid, BossType, BossId}).

%% 获取掉落日志
get_boss_drop_log(Sid) ->
    gen_server:cast(?MODULE, {'get_boss_drop_log', Sid}).

%% 关注操作
boss_remind_op(RoleId, BossType, BossId, Remind)->
    gen_server:cast(?MODULE, {'boss_remind_op', RoleId, BossType, BossId, Remind}).

%% 清理日志
clean_eudemons_boss_log(_DelaySec) ->
    gen_server:cast(?MODULE, {'clean_eudemons_boss_log'}).

%% 跨服中心->游戏节点
%% 第一次同步信息
%% IsForce:是否强制更新 0否;1是
board_eudemos_boss_info(ZoneId, ActStatus, ResetETime, EudemonsBossMap, ScoreList) ->
    gen_server:cast(?MODULE, {'board_eudemos_boss_info', ZoneId, ActStatus, ResetETime, EudemonsBossMap, ScoreList}).

%% 跨服中心统一调用，同步信息
gm_board_eudemos_boss_info(EudemonsBossMap) ->
    gen_server:cast(?MODULE, {'gm_board_eudemos_boss_info', EudemonsBossMap}).

%% 同步掉落日志
board_eudemos_boss_add_drop_log(RecordList)->
    gen_server:cast(?MODULE, {'board_eudemos_boss_add_drop_log', RecordList}).

%% 同步boss被击杀
board_eudemos_boss_kill_and_log(BossType, BossId, NewBoss, AttrId, AttrName, SName) ->
    gen_server:cast(?MODULE, {'board_eudemos_boss_kill_and_log', BossType, BossId, NewBoss, AttrId, AttrName, SName}).

%% boss重生关注提醒
board_eudemos_boss_remind(BossType, BossId)->
    gen_server:cast(?MODULE, {'board_eudemos_boss_remind', BossType, BossId}).

%% boss重生
board_eudemos_boss_reborn(BossType, BossId, NewBoss)->
    gen_server:cast(?MODULE, {'board_eudemos_boss_reborn', BossType, BossId, NewBoss}).

%% 删除boss信息
board_eudemos_boss_delete(BossType, BossId)->
    gen_server:cast(?MODULE, {'board_eudemos_boss_delete', BossType, BossId}).

sync_score_info_to_server(PlayerScore) ->
    gen_server:cast(?MODULE, {'sync_score_info_to_server', PlayerScore}).

%% 重置区域中
% in_reset(ResetETime) ->
%     gen_server:cast(?MODULE, {'in_reset', ResetETime}).

reset_start() ->
    gen_server:cast(?MODULE, {'reset_start'}).

reset_end() ->
    gen_server:cast(?MODULE, {'reset_end'}).

daily_check() ->
    gen_server:cast(?MODULE, {'daily_check'}).

show_state() ->
    gen_server:cast(?MODULE, {'show_state'}).

%%%===================================================================
%%% gen_server callbacks
%%%===================================================================
init([]) ->
    process_flag(trap_exit, true),
    {ok, #local_eudemons_boss_state{}}.

handle_call(_Request, _From, State) ->
    Reply = ok,
    {reply, Reply, State}.

handle_cast(Msg, State) ->
    case catch do_handle_cast(Msg, State) of
        {noreply, NewState} ->
            {noreply, NewState};
        Res ->
            ?ERR("Boss Msg Error:~p~n", [[Msg, Res]]),
            {noreply, State}
    end.

handle_info(Info, State) ->
    case catch do_handle_info(Info, State) of
        {noreply, NewState} ->
            {noreply, NewState};
        Res ->
            ?ERR("Boss Info Error:~p~n", [[Info, Res]]),
            {noreply, State}
    end.

terminate(_Reason, _State) ->
    %% ?ERR("~p is terminate:~p", [?MODULE, _Reason]),
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================
%% 获取幻兽信息
do_handle_cast({'get_eudemons_boss_info', ServerId, RoleId, Sid, BossType, TimesList}, State)->
    #local_eudemons_boss_state{act_status = ActStatus, sync = Sync,  boss_eudemons_map = EudemonsBossMap} = State,
    [LTired, LTiredMax, CollectList] = TimesList,
    IsOpen = lib_eudemons_land:eudemons_boss_open(),
    if
        IsOpen == false ->
            lib_server_send:send_to_sid(Sid, pt_470, 47010, [?ERRCODE(err470_boss_not_open)]),
            {noreply, State};
        ActStatus == 2 ->
            lib_server_send:send_to_sid(Sid, pt_470, 47000, [BossType, ActStatus, 0, LTired, LTiredMax, CollectList, []]),
            {noreply, State};
        Sync == ?SYNC_NO orelse EudemonsBossMap == #{} -> %% 请求跨服幻兽之域信息
            lib_server_send:send_to_sid(Sid, pt_470, 47010, [?ERRCODE(kf_server_allot)]),
            case get('eudemons_boss_sync') of
                undefined ->
                    put('eudemons_boss_sync', 1),
                    Node = mod_disperse:get_clusters_node(),
                    mod_clusters_node:apply_cast(mod_eudemons_land, sync_eudemons_boss_info, [ServerId, Node, ?FORCE_UP]),
                    {noreply, State};
                Count when Count < 20 ->
                    put('eudemons_boss_sync', Count+1),
                    {noreply, State};
                _ ->
                    erase('eudemons_boss_sync'),
                    {noreply, State}
            end;
        Sync == ?SYNC_YES ->
            %% boss信息
            Fun = fun(BossId, Boss, TL) ->
                    #eudemons_boss_status{num = Num, reborn_time = RebornTime, remind_list = RemindList, optional_data = OptionalData} = Boss,
                    case data_eudemons_land:get_eudemons_boss_cfg(BossId) of 
                        #eudemons_boss_cfg{is_rare = IsRare} when IsRare >= ?MON_CL_NORMAL ->
                            case lists:keyfind({BossType, BossId}, 1, OptionalData) of 
                                {_, MonCollectTimes} -> ok; _ -> MonCollectTimes = 0
                            end,
                            [{BossId, MonCollectTimes, RebornTime, 0}|TL];
                        _ ->
                            [{BossId, Num, RebornTime, ?IF(lists:member(RoleId, RemindList), 1, 0)}|TL]
                    end
                  end,
            BossInfos = maps:fold(Fun, [], EudemonsBossMap),
            ?PRINT("get_eudemons_boss_info ~p~n", [{ActStatus, 0, LTired, LTiredMax, CollectList}]),
            %?PRINT("get_eudemons_boss_info ~p~n", [BossInfos]),
            lib_server_send:send_to_sid(Sid, pt_470, 47000, [BossType, ActStatus, 0, LTired, LTiredMax, CollectList, BossInfos]),
            {noreply, State}
    end;
%% 获取榜单
do_handle_cast({'send_rank_info', ServerId, _RoleId, Sid}, State)->
    #local_eudemons_boss_state{act_status = ActStatus, sync = Sync, score_list = ScoreList} = State,
    IsOpen = lib_eudemons_land:eudemons_boss_open(),
    if
        IsOpen == false ->
            lib_server_send:send_to_sid(Sid, pt_470, 47010, [?ERRCODE(err470_boss_not_open)]),
            {noreply, State};
        ActStatus == 2 ->
            lib_server_send:send_to_sid(Sid, pt_470, 47021, [[]]),
            {noreply, State};
        Sync == ?SYNC_NO -> %% 请求跨服幻兽之域信息
            lib_server_send:send_to_sid(Sid, pt_470, 47010, [?ERRCODE(kf_server_allot)]),
            case get('eudemons_boss_sync') of
                undefined ->
                    put('eudemons_boss_sync', 1),
                    Node = mod_disperse:get_clusters_node(),
                    mod_clusters_node:apply_cast(mod_eudemons_land, sync_eudemons_boss_info, [ServerId, Node, ?FORCE_UP]),
                    {noreply, State};
                Count when Count < 20 ->
                    put('eudemons_boss_sync', Count+1),
                    {noreply, State};
                _ ->
                    erase('eudemons_boss_sync'),
                    {noreply, State}
            end;
        Sync == ?SYNC_YES ->
            %% 榜单信息
            F = fun(PlayerScore, List) ->
                #player_score{
                    role_id = RoleId1, role_name = RoleName, server_id = ServerId1, server_num = ServerNum,
                    score = Score, sort_key1 = SK1, kill_num = KillNum, sort_key2 = SK2, total_score = TotalScore, sort_key3 = SK3
                } = PlayerScore,
                [{RoleId1, RoleName, ServerId1, ServerNum, Score, SK1, KillNum, SK2, TotalScore, SK3}|List]
            end,
            SendList = lists:foldl(F, [], ScoreList),
            ?PRINT("send_rank_info:~p~n", [SendList]),
            lib_server_send:send_to_sid(Sid, pt_470, 47021, [SendList]),
            {noreply, State}
    end;

do_handle_cast({'daily_check'}, State)->
    #local_eudemons_boss_state{act_status = ActStatus, reset_etime = _ResetETime, sync = Sync} = State,
    ServerId = config:get_server_id(),
    IsOpen = lib_eudemons_land:eudemons_boss_open(),
    if
        ActStatus == 2 ->
            {noreply, State};
        Sync == ?SYNC_NO andalso IsOpen == true -> %% 请求跨服幻兽之域信息
            Node = mod_disperse:get_clusters_node(),
            mod_clusters_node:apply_cast(mod_eudemons_land, sync_eudemons_boss_info, [ServerId, Node, ?FORCE_UP]),
            {noreply, State};
        true ->
            {noreply, State}     
    end;

%% 击杀日志
do_handle_cast({'get_boss_kill_log', Sid, _BossType, BossId}, State)->
    #local_eudemons_boss_state{ boss_eudemons_map = EudemonsBossMap} = State,
    case maps:get(BossId, EudemonsBossMap, null) of
        null -> KillLog = [];
        #eudemons_boss_status{kill_log = KillLog} -> skip
    end,
    lib_server_send:send_to_sid(Sid, pt_470, 47001, [KillLog]),
    {noreply, State};

%% 掉落日志
do_handle_cast({'get_boss_drop_log', Sid}, State)->
    #local_eudemons_boss_state{boss_drop_log = BossDropLog} = State,
    {ok, Bin} = pt_470:write(47002, [BossDropLog]),
    ?PRINT("get_boss_drop_log:~p~n", [BossDropLog]),
    lib_server_send:send_to_sid(Sid, Bin),
    {noreply, State};

%% 幻兽boss关注操作
do_handle_cast({'boss_remind_op', RoleId, BossType, BossId, Remind}, State) ->
    #local_eudemons_boss_state{ boss_eudemons_map = EudemonsBossMap} = State,
    case maps:get(BossId, EudemonsBossMap, null) of
        null ->
            {noreply, State};
        #eudemons_boss_status{remind_list = RemindList} = Boss ->
            IsInRemind = lists:member(RoleId, RemindList),
            {Code, NewRemindList}
                = if
                      Remind == ?EUDEMONS_REMIND andalso IsInRemind == true ->
                          {?ERRCODE(err460_no_remind), RemindList};
                      Remind =/= ?EUDEMONS_REMIND andalso IsInRemind == false ->
                          {?ERRCODE(err460_no_unremind), RemindList};
                      Remind == ?EUDEMONS_REMIND -> %% replace
                          SQL = <<"replace into eudemons_boss_remind set role_id = ~p, boss_id = ~p">>,
                          db:execute(io_lib:format(SQL, [RoleId, BossId])),
                          {?SUCCESS, [RoleId | RemindList]};
                      true -> %% delete
                          SQL = <<"delete from eudemons_boss_remind where role_id = ~p and boss_id = ~p">>,
                          db:execute(io_lib:format(SQL, [RoleId, BossId])),
                          {?SUCCESS, lists:delete(RoleId, RemindList)}
                  end,
            lib_server_send:send_to_uid(RoleId, pt_470, 47005, [Code, BossType, BossId, Remind]),
            NewBoss = Boss#eudemons_boss_status{remind_list = NewRemindList},
            NewEudemonsBossMap = maps:update(BossId, NewBoss, EudemonsBossMap),
            {noreply, State#local_eudemons_boss_state{boss_eudemons_map = NewEudemonsBossMap}}
    end;

%% 清理日志
do_handle_cast({'clean_eudemons_boss_log'}, State) ->
    #local_eudemons_boss_state{ boss_eudemons_map = EudemonsBossMap} = State,
    Fun = fun(_K, Boss) -> Boss#eudemons_boss_status{kill_log = []} end,
    NewEudemonsBossMap = maps:map(Fun, EudemonsBossMap),
    {noreply, State#local_eudemons_boss_state{boss_drop_log = [], boss_eudemons_map = NewEudemonsBossMap}};

%% 跨服中心->游戏节点
%% 整个Boss Map同步到本地
do_handle_cast({'board_eudemos_boss_info', _ZoneId, ActStatus, ResetETime, EudemonsBossMap, ScoreList}, State) ->
    #local_eudemons_boss_state{sync = _OldSync,  boss_eudemons_map = _OldEudemonsBossMap} = State,
    AllBossReminds = case db:get_all(<<" select role_id, boss_id from eudemons_boss_remind">>) of
                         BossReminds when is_list(BossReminds) -> BossReminds;
                         _ -> []
                     end,
    F = fun(BossId, Boss) ->
                BReminds = [ RoleId || [RoleId, _BossId] <- AllBossReminds, _BossId == BossId],
                Boss#eudemons_boss_status{remind_list = BReminds}
        end,
    NewEudemonsBossMap = maps:map(F, EudemonsBossMap),
    NewState = State#local_eudemons_boss_state{
        act_status = ActStatus, reset_etime = ResetETime, 
        boss_eudemons_map = NewEudemonsBossMap, score_list = ScoreList,
        sync = ?SYNC_YES
    },
    ?PRINT("board_eudemos_boss_info:~p~n", [ScoreList]),
    %?PRINT("board_eudemos_boss_info ~p~n", [{ActStatus, ResetETime}]),
    {noreply, NewState};
    
%% 掉落日志同步到本地
do_handle_cast({'board_eudemos_boss_add_drop_log', RecordList}, State) ->
    %?PRINT("add_drop_log ~p~n", [RecordList]),
    #local_eudemons_boss_state{boss_drop_log = BossDropLog} = State,
    NewBossDropLog = RecordList ++ BossDropLog,
    {noreply, State#local_eudemons_boss_state{boss_drop_log = NewBossDropLog}};

%% 同步击杀记录并且广播本服倒计时重生时间
do_handle_cast({'board_eudemos_boss_kill_and_log', _BossType, BossId, NewBoss, AttrId, AttrName, SName}, State) ->
    #local_eudemons_boss_state{ boss_eudemons_map = EudemonsBossMap} = State,
    case maps:get(BossId, EudemonsBossMap, null) of
        null -> {noreply, State};
        #eudemons_boss_status{num = _Num, kill_log = KillLog} = Boss ->
            #eudemons_boss_status{num = NewNum, reborn_time = RebornTime, optional_data = NewOptionalData} = NewBoss,
            NowTime = utime:unixtime(),
            % #eudemons_boss_cfg{scene = Scene, is_rare = IsRare}
            %     = data_eudemons_land:get_eudemons_boss_cfg(BossId),
            NewKillLog = [{NowTime, SName, AttrId, AttrName}|KillLog],
            %?PRINT("board_eudemos_boss_kill_and_log ~p~n", [NewBoss]),
            LastBoss = Boss#eudemons_boss_status{num = NewNum, kill_log = NewKillLog, reborn_time = RebornTime, optional_data = NewOptionalData},
            NewEudemonsBossMap = maps:update(BossId, LastBoss, EudemonsBossMap),
            {noreply, State#local_eudemons_boss_state{boss_eudemons_map = NewEudemonsBossMap}}
    end;

%% 广播提醒
do_handle_cast({'board_eudemos_boss_remind', BossType, BossId}, State)->
    #local_eudemons_boss_state{ boss_eudemons_map = EudemonsBossMap} = State,
    case maps:get(BossId, EudemonsBossMap, null) of
        null -> {noreply, State};
        #eudemons_boss_status{remind_list = RemindList} ->
            spawn(fun() -> send_remind_msg_role(RemindList, BossType, BossId) end),
            {noreply, State}
    end;

%% boss重生
do_handle_cast({'board_eudemos_boss_reborn', _BossType, BossId, NewBoss}, State)->
    #local_eudemons_boss_state{ boss_eudemons_map = EudemonsBossMap} = State,
    #eudemons_boss_status{num = Num, optional_data = OptionalData, pos_list = PosList, reborn_time = RebornEndTime} = NewBoss,
    case maps:get(BossId, EudemonsBossMap, null) of
        null -> {noreply, State};
        Boss->
            BossOpen = lib_eudemons_land:eudemons_boss_open(),
            #eudemons_boss_cfg{scene = Scene, fixed_xy = FixedXy, is_rare = IsRare, condition = Condition}
                = data_eudemons_land:get_eudemons_boss_cfg(BossId),
            if
                IsRare == 1 orelse IsRare == 2 orelse IsRare == 4 -> skip;
                BossOpen == false -> skip;
                true ->
                    MonName = lib_mon:get_name_by_mon_id(BossId),
                    SceneName = lib_scene:get_scene_name(Scene),
                    {_, EnterLv} = ulists:keyfind(lv, 1, Condition, {lv, 380}),
                    Args = if
                               IsRare =/= 0 -> [MonName, SceneName, Scene, 0, 0, BossId];
                               true -> [{X, Y}] = FixedXy, [MonName, SceneName, Scene, X, Y, BossId]
                           end ,
                    lib_chat:send_TV({all_lv, EnterLv, 9999}, ?MOD_EUDEMONS_BOSS, 2, Args)
            end,
            %?PRINT("board_eudemos_boss_reborn ~p~n", [NewBoss]),
            NewEudemonsBossMap = maps:update(BossId, Boss#eudemons_boss_status{num = Num, pos_list = PosList, optional_data = OptionalData, reborn_time = RebornEndTime}, EudemonsBossMap),
            {noreply, State#local_eudemons_boss_state{boss_eudemons_map = NewEudemonsBossMap}}
    end;

%% 同步击杀记录并且广播本服倒计时重生时间
do_handle_cast({'sync_score_info_to_server', PlayerScore}, State) when is_record(PlayerScore, player_score) ->
    #local_eudemons_boss_state{ score_list = ScoreList} = State,
    #player_score{role_id = RoleId} = PlayerScore,
    NewScoreList = lists:keystore(RoleId, #player_score.role_id, ScoreList, PlayerScore),
    ?PRINT("sync_score_info_to_server:~p~n", [NewScoreList]),
    {noreply, State#local_eudemons_boss_state{score_list = NewScoreList}};
%% 同步击杀记录并且广播本服倒计时重生时间
do_handle_cast({'sync_score_info_to_server', PlayerScoreList}, State) when is_list(PlayerScoreList) ->
    NewScoreList = PlayerScoreList,
    ?PRINT("sync_score_info_to_server##2:~p~n", [NewScoreList]),
    {noreply, State#local_eudemons_boss_state{score_list = NewScoreList}};

%% boss删除
do_handle_cast({'board_eudemos_boss_delete', _BossType, BossId}, State)->
    #local_eudemons_boss_state{ boss_eudemons_map = EudemonsBossMap} = State,
    NewEudemonsBossMap = maps:remove(BossId, EudemonsBossMap),
    {noreply, State#local_eudemons_boss_state{boss_eudemons_map = NewEudemonsBossMap}};

% do_handle_cast({'sync_server_info'}, State)->
%     ?PRINT("local sync_server_info succ ~n", []),
%     Power = 10000,
%     ServerId = config:get_server_id(),
%     Node = node(),
%     ServerNum = config:get_server_num(),
%     ServerName = util:get_server_name(),
%     OpTime = util:get_open_time(),
%     MergeServerIds = config:get_merge_server_ids(),
%     mod_clusters_node:apply_cast(mod_eudemons_land_zone, add_server_in_eudemons,
%                                         [ServerId, Node, ServerNum, ServerName, Power, OpTime, MergeServerIds]),
%     {noreply, State};

% do_handle_cast({'in_reset', _ResetETime}, State)->
%     {noreply, State#local_eudemons_boss_state{act_status = 2, reset_etime = 0, sync = ?SYNC_NO}};

do_handle_cast({'reset_start'}, State)->
    {noreply, State#local_eudemons_boss_state{act_status = 2, boss_eudemons_map = #{}, sync = ?SYNC_NO}};

do_handle_cast({'reset_end'}, State)->
    ServerId = config:get_server_id(),
    Node = node(),
    mod_clusters_node:apply_cast(mod_eudemons_land, sync_eudemons_boss_info, [ServerId, Node, ?FORCE_UP]),
    {noreply, State};

do_handle_cast({'show_state'}, State)->
    ?PRINT("show_state ~p~n", [State]),
    {noreply, State};

do_handle_cast(Msg, State)->
    ?ERR("~p ~p Boss Cast No Match:~w~n", [?MODULE, ?LINE, [Msg]]),
    {noreply, State}.

do_handle_info(_Info, State) ->
    ?ERR("~p ~p Boss Info No Match:~w~n", [?MODULE, ?LINE, [_Info]]),
    {noreply, State}.


%% ================================= private fun =================================
%% 发送提醒消息
send_remind_msg_role([], _BossType, _BossId) -> skip;
send_remind_msg_role([RoleId|RemindList], BossType, BossId)->
    lib_server_send:send_to_uid(RoleId, pt_470, 47006, [BossType, BossId]),
    send_remind_msg_role(RemindList, BossType, BossId).
