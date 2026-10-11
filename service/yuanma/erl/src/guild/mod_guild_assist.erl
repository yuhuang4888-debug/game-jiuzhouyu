% %% ---------------------------------------------------------------------------
% %% @doc mod_guild_assist
% %% @author
% %% @since
% %% @deprecated
% %% ---------------------------------------------------------------------------
-module(mod_guild_assist).

-export([init/1,handle_call/3,handle_cast/2,handle_info/2,terminate/2,code_change/3]).
-export([

    ]).
-compile(export_all).
-include("common.hrl").
-include("errcode.hrl").
-include("def_fun.hrl").
-include("def_module.hrl").
-include("rec_assist.hrl").
-include("decoration_boss.hrl").
-include("boss.hrl").
-include("predefine.hrl").
-include("figure.hrl").
-include("scene.hrl").
-include("team.hrl").
-include("dungeon.hrl").

%%-----------------------------

add_new_assist(Args) ->
    gen_server:call(?MODULE, {add_new_assist, Args}).

get_launch_assist(AssistId) ->
    gen_server:call(?MODULE, {get_launch_assist, AssistId}).

add_assister(Assister) ->
    gen_server:call(?MODULE, {add_assister, Assister}).

%% 根据协助id删除协助
del_assist_by_id(AssistId) ->
    gen_server:cast(?MODULE, {del_assist_by_id, AssistId}).

%% 根据目标id删除协助
del_assist_by_target_list(AssistType, TargetList) ->
    gen_server:cast(?MODULE, {del_assist_by_target_list, AssistType, TargetList}).

cancel_boss_assist(AssistId, RoleId, BlState, CancelType) ->
    gen_server:cast(?MODULE, {cancel_boss_assist, AssistId, RoleId, BlState, CancelType}).

cancel_dungeon_assist(AssistId, RoleId, CancelType) ->
    gen_server:cast(?MODULE, {cancel_dungeon_assist, AssistId, RoleId, CancelType}).

cancel_sea_treasure_assist(AssistId, RoleId, CancelType) ->
    gen_server:cast(?MODULE, {cancel_sea_treasure_assist, AssistId, RoleId, CancelType}).

cancel_enchantment_guard_assist(AssistId, RoleId, CancelType) ->
    gen_server:cast(?MODULE, {cancel_enchantment_guard_assist, AssistId, RoleId, CancelType}).

update_bl_state(Args) ->
    gen_server:cast(?MODULE, {update_bl_state, Args}).

% had_guild_assist(GuildId, Sid) ->
%     gen_server:cast(?MODULE, {had_guild_assist, GuildId, Sid}).

send_guild_assist_list(RoleId, GuildId, Sid) ->
    gen_server:cast(?MODULE, {send_guild_assist_list, RoleId, GuildId, Sid}).

boss_be_kill(AssistId, BLWhos) ->
    gen_server:cast(?MODULE, {boss_be_kill, AssistId, BLWhos}).

boss_be_hurt(AssistId, AtterId, Hurt) ->
    gen_server:cast(?MODULE, {boss_be_hurt, AssistId, AtterId, Hurt}).

player_be_kill(AssistId, KillerId) ->
    gen_server:cast(?MODULE, {player_be_kill, AssistId, KillerId}).

dungeon_end(AssistId, EndType) ->
    gen_server:cast(?MODULE, {dungeon_end, AssistId, EndType}).

dungeon_end_special(AssistId, EndType) ->
    gen_server:cast(?MODULE, {dungeon_end_special, AssistId, EndType}).

rback_resoult(RoleId, AssistId, EndType, Rober, Reward) ->
    gen_server:cast(?MODULE, {rback_resoult, RoleId, AssistId, EndType, Rober, Reward}).

rback_resoult_after_battle(RoleId, AutoId, Res, Reward, Rober) ->
    gen_server:cast(?MODULE, {rback_resoult_after_battle, RoleId, AutoId, Res, Reward, Rober}).

send_my_assist_info(AssistId, RoleId, Sid) ->
    gen_server:cast(?MODULE, {send_my_assist_info, AssistId, RoleId, Sid}).

day_trigger() ->
    gen_server:cast(?MODULE, {day_trigger}).

%% 众生之门活动结束
beings_gate_end() ->
    gen_server:cast(?MODULE, {beings_gate_end}).

%% 周一4点清理类型3的所有协助
clear_assist_monday() ->
    gen_server:cast(?MODULE, {clear_assist_monday}).

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
    {ok, #{}}.

%% ====================
%% hanle_call
%% ====================
do_handle_call({add_new_assist, #launch_assist{type = ?ASSIST_TYPE_3} = LaunchAssist}, _From, State) ->
    #launch_assist{assist_id = AssistId, target_id = TargetId} = LaunchAssist,
    F = fun
        (_AssistId, #launch_assist{type = ?ASSIST_TYPE_3, target_id = TemTargetId}, Acc) ->
            [TemTargetId|Acc];
        (_, _, Acc) -> Acc
    end,
    AllTargetIdList = maps:fold(F, [], State),
    case lists:member(TargetId, AllTargetIdList) of
        true ->
            Reply = error,
            NewState = State;
        _ ->
            Reply = ok,
            NewState = maps:put(AssistId, LaunchAssist, State)
    end,
    {reply, Reply, NewState};
do_handle_call({add_new_assist, LaunchAssist}, _From, State) ->
    #launch_assist{assist_id = AssistId} = LaunchAssist,
    NewState = maps:put(AssistId, LaunchAssist, State),
    {reply, ok, NewState};

do_handle_call({get_launch_assist, AssistId}, _From, State) ->
    case maps:get(AssistId, State, 0) of
        #launch_assist{} = LaunchAssist -> Reply = {ok, LaunchAssist};
        _ -> Reply = false
    end,
    {reply, Reply, State};

do_handle_call({add_assister, Assister}, _From, State) ->
    #assister{assist_id = AssistId, role_id = RoleId, role_info = AssisterRoleInfo} = Assister,
    case maps:get(AssistId, State, 0) of
        #launch_assist{assister_list = AssisterList, type = AssistType} = LaunchAssist when AssistType =/= ?ASSIST_TYPE_4 ->
            NewAssisterList = [Assister|lists:keydelete(RoleId, #assister.role_id, AssisterList)],
            NewLaunchAssist = LaunchAssist#launch_assist{assister_list = NewAssisterList},
            NewState = maps:put(AssistId, NewLaunchAssist, State),
            {reply, ok, NewState};
        #launch_assist{type = ?ASSIST_TYPE_4, assister_list = [], role_id = BeAssisterId, figure = Figure} = LaunchAssist->
            lib_player:apply_cast(BeAssisterId, ?APPLY_CAST_SAVE, lib_guild_assist, add_assister_enchantment_guard_back, [AssistId, AssisterRoleInfo]),
            NewLaunchAssist = LaunchAssist#launch_assist{assister_list = [Assister]},
            NewState = maps:put(AssistId, NewLaunchAssist, State),

            {ok, Bin} = pt_404:write(40407, [AssistId]),
            lib_server_send:send_to_guild(Figure#figure.guild_id, Bin),
            {reply, ok, NewState};
        #launch_assist{type = ?ASSIST_TYPE_4} ->
            {reply, {false, ?ERRCODE(err404_other_assist)}, State};
        _ ->
            {reply, false, State}
    end;

do_handle_call(_Request, _From, State) -> {reply, ok, State}.

%% ====================
%% hanle_cast
%% ====================

% do_handle_cast({had_guild_assist, GuildId, Sid}, State) ->
%     F = fun(_, #launch_assist{figure = Figure}, Acc) ->
%         case Figure#figure.guild_id == GuildId of
%             true -> Acc+1; _ -> Acc
%         end
%     end,
%     Num = maps:fold(F, 0, State),
%     lib_server_send:send_to_sid(Sid, pt_404, 40404, [Num]),
%     {noreply, State};

do_handle_cast({send_guild_assist_list, RoleId, GuildId, Sid}, State) ->
    F = fun(_AssistId, #launch_assist{role_id = AskId, figure = Figure, assister_list = AssistL, type = Type} = LaunchAssist, Acc) ->
        IsNotSatisfy = Type == ?ASSIST_TYPE_4 andalso AssistL =/= [],
        case Figure#figure.guild_id == GuildId of
            _ when IsNotSatisfy andalso AskId =/= RoleId -> Acc;
            true ->
                Item = lib_guild_assist:pack_launch_assist(LaunchAssist, RoleId),
                [Item|Acc];
            _ -> Acc
        end
    end,
    SendList = maps:fold(F, [], State),
    %?PRINT("send_guild_assist_list SendList : ~p~n", [SendList]),
    lib_server_send:send_to_sid(Sid, pt_404, 40405, [SendList]),
    {noreply, State};

do_handle_cast({send_my_assist_info, AssistId, _RoleId, Sid}, State) ->
    case maps:get(AssistId, State, 0) of
        #launch_assist{} = LaunchAssist ->
            #launch_assist{
                role_id = AskId, type = Type, sub_type = SubType, target_cfg_id = TargetCfgId, target_id = TargetId,
                figure = Figure
            } = LaunchAssist,
            #figure{name = Name, lv = Level, career = Career, sex = Sex, picture = Pic, picture_ver = PicVer} = Figure,
            lib_server_send:send_to_sid(Sid, pt_404, 40408, [AssistId, Type, SubType, TargetCfgId, TargetId, AskId, Name, Level, Career, Sex, Pic, PicVer]),
            ok;
        _ -> skip
    end,
    {noreply, State};

do_handle_cast({update_bl_state, [AssistId, RoleId, NewBlState]}, State) ->
    case maps:get(AssistId, State, 0) of
        #launch_assist{assister_list = AssisterList} = LaunchAssist ->
            case lists:keyfind(RoleId, #assister.role_id, AssisterList) of
                #assister{bl_st = OldBlState} = Assister when OldBlState =/= NewBlState ->
                    NewAssisterList = lists:keyreplace(RoleId, #assister.role_id, AssisterList, Assister#assister{bl_st = NewBlState}),
                    NewLaunchAssist = LaunchAssist#launch_assist{assister_list = NewAssisterList},
                    NewState = maps:put(AssistId, NewLaunchAssist, State),
                    {noreply, NewState};
                _ -> {noreply, State}
            end;
        _ ->
            {noreply, State}
    end;

do_handle_cast({del_assist_by_id, AssistId}, State) ->
    NewState = maps:remove(AssistId, State),
    {noreply, NewState};

do_handle_cast({del_assist_by_target_list, ?ASSIST_TYPE_3, TargetList}, State) ->
    F = fun
        (_, #launch_assist{assist_id = AssistId, target_id = TargetId, type = ?ASSIST_TYPE_3}, FMap) ->
            case lists:member(TargetId, TargetList) of
                true -> %% 删除
                    maps:remove(AssistId, FMap);
                _ ->
                    FMap
            end;
        (_, _, FMap) -> FMap
    end,
    NewState = maps:fold(F, State, State),
    %% 广播公会玩家刷新列表
    lib_guild_assist:broadcast_refresh_assist(),
    {noreply, NewState};

do_handle_cast({cancel_boss_assist, AssistId, RoleId, BlState, CancelType}, State) ->
    case maps:get(AssistId, State, 0) of
        #launch_assist{role_id = AskId, sub_type = SubType, assister_list = AssisterList, target_cfg_id = TargetCfgId,
            target_id = TargetId, figure = Figure, extra = Extra}=LaunchAssist ->
            NowTime = utime:unixtime(),
            [TarScene, TarScenePoolId, _TarCopyId] = maps:get(scene, Extra, [0,0,0]),
            case RoleId == AskId of
                true ->
                    {ok, Bin} = pt_404:write(40407, [AssistId]),
                    lib_server_send:send_to_guild(Figure#figure.guild_id, Bin),
                    UpRoleList = [{AssisterRoleId, BlState1} ||#assister{role_id = AssisterRoleId, assist_st = AssistSt, bl_st = BlState1} <- AssisterList, AssistSt == 1, AssisterRoleId =/= RoleId],
                    NewUpRoleList = [{RoleId, BlState}|UpRoleList],
                    CancelAll = true,
                    NewState = maps:remove(AssistId, State);
                _ -> %% 取消个人
                    NewUpRoleList = [{RoleId, BlState}],
                    CancelAll = false,
                    NewAssisterList = case lists:keyfind(RoleId, #assister.role_id, AssisterList) of
                        #assister{} = Assister ->
                            lists:keyreplace(RoleId, #assister.role_id, AssisterList, Assister#assister{assist_st = 2, bl_st = BlState});
                        _ -> AssisterList
                    end,
                    NewLaunchAssist = LaunchAssist#launch_assist{assister_list = NewAssisterList},
                    NewState = maps:put(AssistId, NewLaunchAssist, State)
            end,
            %% 幻饰Boss取消协助的特殊处理
            case SubType of
                ?BOSS_TYPE_DECORATION_BOSS -> %% 幻饰boss，更新幻饰boss进程中，玩家的进入类型 (改成踢玩家)
%%                    [mod_decoration_boss_local:set_enter_type(RoleId2, ?IF(BlState2, ?DECORATION_BOSS_ENTER_TYPE_NORMAL, ?DECORATION_BOSS_ENTER_TYPE_GUILD_ASSIST))
%%                     ||{RoleId2, BlState2} <- NewUpRoleList],
                    [lib_decoration_boss_api:cancel_boss_assist(QuitRoleId)||{QuitRoleId, _}<-NewUpRoleList, QuitRoleId =/= AskId];
                _ ->
                    skip
            end,
            ?PRINT("cancel_boss_assist : ~p~n", [{CancelAll, NewUpRoleList}]),
            mod_scene_agent:apply_cast_with_state(TarScene, TarScenePoolId,
                        lib_guild_assist, cancel_boss_assist_in_scene, [AssistId, SubType, TargetCfgId, TargetId, NewUpRoleList, CancelAll]),
            [lib_player:apply_cast(RoleId1, ?APPLY_CAST_STATUS, lib_guild_assist, cancel_boss_assist_succ, [AssistId, AskId, CancelType])
                || {RoleId1, _} <- NewUpRoleList],
            lib_log_api:log_guild_assist_operation([[RoleId3, AssistId, 2, ?IF(BlState3, 1, 0), 0, NowTime]||{RoleId3, BlState3} <- NewUpRoleList]),
            {noreply, NewState};
        _ ->
            {noreply, State}
    end;

do_handle_cast({cancel_dungeon_assist, AssistId, RoleId, CancelType}, State) ->
    case maps:get(AssistId, State, 0) of
        #launch_assist{role_id = AskId, sub_type = _SubType, assister_list = AssisterList, target_cfg_id = TargetCfgId,
            target_id = _TargetId, figure = Figure}=LaunchAssist ->
            NowTime = utime:unixtime(),
            case RoleId == AskId of
                true -> %% 取消全部
                    {ok, Bin} = pt_404:write(40407, [AssistId]),
                    lib_server_send:send_to_guild(Figure#figure.guild_id, Bin),
                    DelRoleList1 = [{AssisterRoleId, OHelpType} ||#assister{role_id = AssisterRoleId, assist_st = 1, o_help_type = OHelpType} <- AssisterList, AssisterRoleId =/= RoleId],
                    DelRoleList = [{RoleId, ?HELP_TYPE_NO}|DelRoleList1],
                    NewState = maps:remove(AssistId, State);
                _ -> %% 取消个人
                    case lists:keyfind(RoleId, #assister.role_id, AssisterList) of
                        #assister{o_help_type = OHelpType} ->
                            DelRoleList = [{RoleId, OHelpType}],
                            NewAssisterList = lists:keydelete(RoleId, #assister.role_id, AssisterList);
                        _ ->
                            DelRoleList = [],
                            NewAssisterList = AssisterList
                    end,
                    NewLaunchAssist = LaunchAssist#launch_assist{assister_list = NewAssisterList},
                    NewState = maps:put(AssistId, NewLaunchAssist, State)
            end,
            [lib_player:apply_cast(RoleId1, ?APPLY_CAST_STATUS, lib_guild_assist, cancel_dungeon_assist_succ, [AssistId, AskId, TargetCfgId, ResetHelpType, CancelType])
                || {RoleId1, ResetHelpType} <- DelRoleList],
            %?PRINT("cancel_dungeon_assist DelRoleList : ~p~n", [DelRoleList]),
            lib_log_api:log_guild_assist_operation([[RoleId3, AssistId, 2, OHelpType3, 0, NowTime]||{RoleId3, OHelpType3} <- DelRoleList]),
            {noreply, NewState};
        _ ->
            {noreply, State}
    end;

do_handle_cast({cancel_sea_treasure_assist, AssistId, RoleId, CancelType}, State) ->
    case maps:get(AssistId, State, 0) of
        #launch_assist{role_id = AskId, sub_type = _SubType, assister_list = AssisterList,
            target_id = _TargetId, figure = Figure}=LaunchAssist ->
            NowTime = utime:unixtime(),
            case RoleId == AskId of
                true -> %% 取消全部
                    {ok, Bin} = pt_404:write(40407, [AssistId]),
                    lib_server_send:send_to_guild(Figure#figure.guild_id, Bin),
                    DelRoleList1 = [AssisterRoleId ||#assister{role_id = AssisterRoleId, assist_st = 1} <- AssisterList, AssisterRoleId =/= RoleId],
                    DelRoleList = [RoleId|DelRoleList1],
                    NewState = maps:remove(AssistId, State);
                _ -> %% 取消个人
                    case lists:keyfind(RoleId, #assister.role_id, AssisterList) of
                        #assister{} ->
                            DelRoleList = [RoleId],
                            NewAssisterList = lists:keydelete(RoleId, #assister.role_id, AssisterList);
                        _ ->
                            DelRoleList = [],
                            NewAssisterList = AssisterList
                    end,
                    NewLaunchAssist = LaunchAssist#launch_assist{assister_list = NewAssisterList},
                    NewState = maps:put(AssistId, NewLaunchAssist, State)
            end,
            [lib_player:apply_cast(RoleId1, ?APPLY_CAST_STATUS, lib_guild_assist, cancel_sea_treasure_assist_succ, [AssistId, AskId, CancelType])
                || RoleId1 <- DelRoleList],
            %?PRINT("cancel_dungeon_assist DelRoleList : ~p~n", [DelRoleList]),
            lib_log_api:log_guild_assist_operation([[RoleId3, AssistId, 2, 0, 0, NowTime]||RoleId3 <- DelRoleList]),
            {noreply, NewState};
        _ ->
            {noreply, State}
    end;

do_handle_cast({cancel_enchantment_guard_assist, AssistId, RoleId, CancelType}, State) ->
    case maps:get(AssistId, State, 0) of
        #launch_assist{role_id = AskId, sub_type = _SubType, assister_list = AssisterList, target_cfg_id = TargetCfgId,
            target_id = _TargetId, figure = Figure}=LaunchAssist ->
            NowTime = utime:unixtime(),
            case RoleId == AskId of
                true -> %% 取消全部
                    {ok, Bin} = pt_404:write(40407, [AssistId]),
                    lib_server_send:send_to_guild(Figure#figure.guild_id, Bin),
                    DelRoleList1 = [AssisterRoleId ||#assister{role_id = AssisterRoleId, assist_st = 1} <- AssisterList, AssisterRoleId =/= RoleId],
                    DelRoleList = [RoleId|DelRoleList1],
                    NewState = maps:remove(AssistId, State);
                _ -> %% 取消个人
                    DelRoleList = [RoleId],
                    NewAssisterList = lists:keydelete(RoleId, #assister.role_id, AssisterList),
                    NewLaunchAssist = LaunchAssist#launch_assist{assister_list = NewAssisterList},
                    NewState = maps:put(AssistId, NewLaunchAssist, State)
            end,
            [lib_player:apply_cast(RoleId1, ?APPLY_CAST_STATUS, lib_guild_assist, cancel_enchantment_guard_assist_succ, [AssistId, AskId, TargetCfgId, CancelType])
                || RoleId1 <- DelRoleList],
            %?PRINT("cancel_dungeon_assist DelRoleList : ~p~n", [DelRoleList]),
            lib_log_api:log_guild_assist_operation([[RoleId3, AssistId, 2, 0, 0, NowTime]||RoleId3 <- DelRoleList]),
            {noreply, NewState};
        _ ->
            {noreply, State}
    end;

do_handle_cast({player_be_kill, AssistId, KillerId}, State) ->
    case maps:get(AssistId, State, 0) of
        #launch_assist{assister_list = AssisterList} = LaunchAssist ->
            case lists:keyfind(KillerId, #assister.role_id, AssisterList) of
                #assister{is_killed = 0} = Assister ->
                    NewAssisterList = lists:keyreplace(KillerId, #assister.role_id, AssisterList, Assister#assister{is_killed = 1}),
                    NewLaunchAssist = LaunchAssist#launch_assist{assister_list = NewAssisterList},
                    NewState = maps:put(AssistId, NewLaunchAssist, State),
                    ?PRINT("player_be_kill : ~p~n", [{KillerId}]),
                    {noreply, NewState};
                _ ->
                    {noreply, State}
            end;
        _ ->
            {noreply, State}
    end;
do_handle_cast({boss_be_hurt, AssistId, AtterId, Hurt}, State) ->
    case maps:get(AssistId, State, 0) of
        #launch_assist{assister_list = AssisterList} = LaunchAssist ->
            case lists:keyfind(AtterId, #assister.role_id, AssisterList) of
                #assister{hurt = 0} = Assister ->
                    NewAssisterList = lists:keyreplace(AtterId, #assister.role_id, AssisterList, Assister#assister{hurt = Hurt}),
                    NewLaunchAssist = LaunchAssist#launch_assist{assister_list = NewAssisterList},
                    NewState = maps:put(AssistId, NewLaunchAssist, State),
                    ?PRINT("boss_be_hurt : ~p~n", [{AtterId, Hurt}]),
                    {noreply, NewState};
                _ ->
                    {noreply, State}
            end;
        _ ->
            {noreply, State}
    end;

do_handle_cast({boss_be_kill, AssistId, BLWhos}, State) ->
    case maps:get(AssistId, State, 0) of
        #launch_assist{role_id = AskId, type = Type, sub_type = SubType, figure = Figure, assister_list = AssisterList} ->
            NowTime = utime:unixtime(),
            #figure{name = Name} = Figure,
            case lists:keymember(AskId, #mon_atter.id, BLWhos) of
                true ->
                    EndType = 1,
                    %% 公会传闻，发奖励
                    #base_guild_assist{rewards = Rewards} = data_guild_assist:get_assist_cfg(Type, SubType),
                    RewardSendList = [RoleId || #assister{role_id = RoleId, hurt = Hurt, is_killed = IsKilled, assist_st = AssistSt} <- AssisterList,
                        (Hurt > 0 orelse IsKilled /= 0) andalso AssistSt == 1],
                    spawn(fun() -> lib_guild_assist:send_assist_reward(RewardSendList, Rewards) end);
                _ ->
                    EndType = 2
            end,
            %% 清数据
            lib_guild_assist:clear_assist(AskId, AskId, AssistId, Name, [EndType]),
            [lib_guild_assist:clear_assist(RoleId, AskId, AssistId, Name, [EndType]) ||#assister{role_id = RoleId, assist_st = 1} <- AssisterList],
            NewState = maps:remove(AssistId, State),
            {ok, Bin} = pt_404:write(40407, [AssistId]),
            lib_server_send:send_to_guild(Figure#figure.guild_id, Bin),
            %% 日志
            LogList = [[RoleId, AssistId, 3, ?IF(BlState, 1, 0), EndType, NowTime]||#assister{role_id = RoleId, bl_st = BlState, assist_st = 1} <- AssisterList],
            lib_log_api:log_guild_assist_operation([[AskId, AssistId, 3, 1, EndType, NowTime]|LogList]),
            {noreply, NewState};
        _ ->
            {noreply, State}
    end;

do_handle_cast({dungeon_end_special, AssistId, EndType}, State) ->
    case maps:get(AssistId, State, 0) of
        #launch_assist{role_id = AskId, type = _Type, sub_type = _SubType, target_cfg_id = TargetCfgId, figure = Figure} ->
            NowTime = utime:unixtime(),
            #figure{name = Name} = Figure,
            %% 清数据
            case _Type of
                ?ASSIST_TYPE_4 ->
                    lib_guild_assist:clear_assist_4(AskId, AskId, AssistId, Name, [EndType, TargetCfgId, 0]);
                _ ->
                    lib_guild_assist:clear_assist(AskId, AskId, AssistId, Name, [EndType, TargetCfgId, 0])
            end,
            NewState = maps:remove(AssistId, State),
            {ok, Bin} = pt_404:write(40407, [AssistId]),
            lib_server_send:send_to_guild(Figure#figure.guild_id, Bin),
            %% 日志
            lib_log_api:log_guild_assist_operation([[AskId, AssistId, 3, ?HELP_TYPE_NO, EndType, NowTime]]),
            {noreply, NewState};
        _ ->
            {noreply, State}
    end;

do_handle_cast({dungeon_end, AssistId, EndType}, State) ->
    case maps:get(AssistId, State, 0) of
        #launch_assist{role_id = AskId, type = Type, sub_type = SubType, target_cfg_id = TargetCfgId, figure = Figure, assister_list = AssisterList} ->
            NowTime = utime:unixtime(),
            #figure{name = Name} = Figure,
            case EndType == 1 of
                true ->
                    %% 公会传闻，发奖励
                    #base_guild_assist{rewards = Rewards} = data_guild_assist:get_assist_cfg(Type, SubType),
                    RewardSendList = [RoleId|| #assister{role_id = RoleId} <- AssisterList],
                    spawn(fun() -> lib_guild_assist:send_assist_reward(RewardSendList, Rewards) end);
                _ ->
                    skip
            end,
            %% 清数据
            lib_guild_assist:clear_assist(AskId, AskId, AssistId, Name, [EndType, TargetCfgId, 0]),
            [lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, lib_team, set_help_type, [TargetCfgId, OHelpType]) ||#assister{role_id = RoleId, o_help_type = OHelpType} <- AssisterList],
            [lib_guild_assist:clear_assist(RoleId, AskId, AssistId, Name, [EndType, TargetCfgId, OHelpType]) ||#assister{role_id = RoleId, o_help_type = OHelpType} <- AssisterList],
            NewState = maps:remove(AssistId, State),
            {ok, Bin} = pt_404:write(40407, [AssistId]),
            lib_server_send:send_to_guild(Figure#figure.guild_id, Bin),
            %% 日志
            LogList = [[RoleId, AssistId, 3, OHelpType, EndType, NowTime]||#assister{role_id = RoleId, o_help_type = OHelpType, assist_st = 1} <- AssisterList],
            lib_log_api:log_guild_assist_operation([[AskId, AssistId, 3, ?HELP_TYPE_NO, EndType, NowTime]|LogList]),
            {noreply, NewState};
        _ ->
            {noreply, State}
    end;

do_handle_cast({rback_resoult_after_battle, FightRoleId, AutoId, Res, Reward, Rober}, State) ->
    AssistList = maps:values(State),
    case lists:keyfind(AutoId, #launch_assist.target_id, AssistList) of
        #launch_assist{
            assist_id = AssistId, role_id = AskId, figure = Figure,
            assister_list = AssisterList, type = Type
        } = OldLunchAssist ->
            NowTime = utime:unixtime(),
            #figure{name = Name} = Figure,
            ?PRINT("================= ~n",[]),
            if
                Res == 1 ->
                    %% 清数据
                    lib_guild_assist:clear_assist_type3(AskId, AskId, 1, Type, AssistId, Name, [1, Rober, Reward]),
                    [lib_guild_assist:clear_assist_type3(RoleId, AskId, 1, Type, AssistId, Name, [1, Rober, Reward])
                        ||#assister{role_id = RoleId} <- AssisterList],
                    NewState = maps:remove(AssistId, State),
                    {ok, Bin} = pt_404:write(40407, [AssistId]),
                    lib_server_send:send_to_guild(Figure#figure.guild_id, Bin),
                    %% 日志
                    LogList = [
                        [RoleId, AssistId, 3, 0, 1, NowTime]
                        ||#assister{role_id = RoleId} <- AssisterList
                    ],
                    lib_log_api:log_guild_assist_operation([[AskId, AssistId, 3, 1, 1, NowTime]|LogList]);
                true ->
                    NewAssisterList = lists:keydelete(FightRoleId, #assister.role_id, AssisterList),
                    NewAssist = OldLunchAssist#launch_assist{assister_list = NewAssisterList},
                    NewState = maps:put(AssistId, NewAssist, State),
                    %% 清数据
                    lib_guild_assist:clear_assist_type3(FightRoleId, AskId, 2, Type, AssistId, Name, [2, Rober, Reward]),
                    lib_log_api:log_guild_assist_operation([[FightRoleId, AssistId, 3, 1, 2, NowTime]])
            end,
            {noreply, NewState};
        _ ->
            {noreply, State}
    end;

do_handle_cast({rback_resoult, FightRoleId, AssistId, EndType, Rober, Reward}, State) ->
    case maps:get(AssistId, State, 0) of
        #launch_assist{
            role_id = AskId, figure = Figure, assister_list = AssisterList, type = Type
        } = OldLunchAssist ->
            NowTime = utime:unixtime(),
            #figure{name = Name} = Figure,
            if
                EndType == 1 ->
                    %% 清数据
                    lib_guild_assist:clear_assist_type3(AskId, AskId, 1, Type, AssistId, Name, [EndType, Rober, Reward]),
                    [lib_guild_assist:clear_assist(RoleId, AskId, AssistId, Name, [EndType, Rober, Reward])
                        ||#assister{role_id = RoleId} <- AssisterList],
                    NewState = maps:remove(AssistId, State),
                    {ok, Bin} = pt_404:write(40407, [AssistId]),
                    lib_server_send:send_to_guild(Figure#figure.guild_id, Bin),
                    %% 日志
                    LogList = [
                        [RoleId, AssistId, 3, 0, EndType, NowTime]
                        ||#assister{role_id = RoleId} <- AssisterList
                    ],
                    lib_log_api:log_guild_assist_operation([[AskId, AssistId, 3, 1, EndType, NowTime]|LogList]);
                true ->
                    NewAssisterList = lists:keydelete(FightRoleId, #assister.role_id, AssisterList),
                    NewAssist = OldLunchAssist#launch_assist{assister_list = NewAssisterList},
                    NewState = maps:put(AssistId, NewAssist, State),
                    %% 清数据
                    lib_guild_assist:clear_assist(FightRoleId, AskId, AssistId, Name, [EndType, Rober, Reward]),
                    lib_log_api:log_guild_assist_operation([[FightRoleId, AssistId, 3, 1, EndType, NowTime]])
            end,
            {noreply, NewState};
        _ ->
            {noreply, State}
    end;

do_handle_cast({day_trigger}, State) ->
    F = fun(_AssistId, #launch_assist{type = Type, assister_list = AssisterList}, Acc) ->
        case Type of
            ?ASSIST_TYPE_1 ->
                [lib_guild_assist:update_bl_state(RoleId) ||#assister{role_id = RoleId, assist_st = 1} <- AssisterList],
                Acc;
            _ -> Acc
        end
    end,
    maps:fold(F, 1, State),
    {noreply, State};

do_handle_cast({beings_gate_end}, State) ->
    F = fun(AssistId, #launch_assist{type = Type, sub_type = SubType, role_id = RoleId}, AccState) ->
        case Type == ?ASSIST_TYPE_2 andalso SubType == ?DUNGEON_TYPE_BEINGS_GATE of
            true ->
                {_, NewAccState} = do_handle_cast({cancel_dungeon_assist, AssistId, RoleId, 1}, AccState),
                NewAccState;
            _ -> AccState
        end
    end,
    NewState = maps:fold(F, State, State),
    {noreply, NewState};

do_handle_cast({clear_assist_monday}, State) ->
    List = maps:to_list(State),
    Fun = fun
        ({_Key, #launch_assist{type = Type} = LaunchAssist}, Map) when Type == ?ASSIST_TYPE_3 ->
            #launch_assist{
                assist_id = AssistId, role_id = AskId,
                assister_list = AssisterList,
                target_id = _TargetId, figure = Figure
            } = LaunchAssist,
            NowTime = utime:unixtime(),
            {ok, Bin} = pt_404:write(40407, [AssistId]),
            lib_server_send:send_to_guild(Figure#figure.guild_id, Bin),
            DelRoleList1 = [AssisterRoleId ||#assister{role_id = AssisterRoleId, assist_st = 1} <- AssisterList],
            DelRoleList = [AskId|DelRoleList1],
            [lib_player:apply_cast(RoleId1, ?APPLY_CAST_SAVE, lib_guild_assist, cancel_sea_treasure_assist_succ, [AssistId, AskId, 2])
                || RoleId1 <- DelRoleList],
            lib_log_api:log_guild_assist_operation([[RoleId3, AssistId, 2, 0, 0, NowTime]||RoleId3 <- DelRoleList]),
            Map;
        ({Key, Val}, Map) -> maps:put(Key, Val, Map)
    end,
    NewState = lists:foldl(Fun, #{}, List),
    {noreply, NewState};

do_handle_cast(_Msg, State) -> {noreply, State}.

%% ====================
%% hanle_info
%% ====================
do_handle_info(_Info, State) -> {noreply, State}.
