%%-----------------------------------------------------------------------------
%% @Module  :       lib_jjc_battle.erl
%% @Author  :       Fwx
%% @Email   :       421307471@qq.com
%% @Created :       2017-12-06
%% @Description:    排位赛战斗
%%-----------------------------------------------------------------------------

-module(lib_jjc_battle).
-behaviour(lib_battle_field).
-include("battle_field.hrl").
-include("def_fun.hrl").
-include("predefine.hrl").
-include("server.hrl").
-include("jjc.hrl").
-include("scene.hrl").
-include("attr.hrl").
-include("common.hrl").
-include("errcode.hrl").
-include("faker.hrl").
-include("def_module.hrl").

%% 行为接口
-export([
    %% 战场进程
    init/2
    , player_enter/3
    , player_quit/3
    , player_logout/3
    , player_disconnect/3
    , player_finish_change_scene/3
    , player_die/3
    , player_revive/3
    %% 玩家进程
    , evt_out_of_battle/2
    % % ,mon_hp_change/3
    , mon_die/3
    , terminate/2
]).

%% 其它接口
-export([
    fake_man_die_handler/5
    , battle_time_out/2
    , ready_time_out/2
    , reward_time_out/2
    , send_fake_data/2
    , skip_battle/2
    , dummy_start_battle/2
    , clear_dummy/1
    , sleep_dummy/1
    , trigger_battle_ref/2
    , trigger_battle/2
]).


init(#battle_state{self = Self} = State, Args) ->
    [[{X, Y}]] = data_jjc:get_jjc_value(?JJC_SELF_POS),
    case Args of
        [fake_man, ChallengeRole] ->
            #challenge_role{
                self_image  = SelfImage,
                rival_image = RivalImage
            } = ChallengeRole,
            #image_role{
                rank = SelfRank,
                role_info = #faker_info{
                    role_id = RoleId
                }
            } = SelfImage,
            #image_role{
                rank = RivalRank
            } = RivalImage,
            RoleMap = #{RoleId => #battle_role{key = RoleId, in_info = #{x => X, y => Y}}},
            % 创建假人
            {FakeId1, FakeId2, CallbackData} = lib_faker_api:sync_create_object(?MOD_JJC, {SelfImage, RivalImage}),
            #{
                scene_id := SceneId,
                pool_id  := ScenePoolId,
                copy_id  := RoleIdAsCopyId
                                            } = CallbackData,
            % 战斗延时
            BattleRef = erlang:send_after(3000, Self, {apply, ?MODULE, trigger_battle_ref, []}),
            Data =
            #{
                rank               => [SelfRank, RivalRank],
                copy_id            => RoleIdAsCopyId,
                trigger_battle_ref => BattleRef,
                fake_man_mine      => #{id => FakeId1, data => SelfImage},
                fake_man_rival     => #{id => FakeId2, data => RivalImage}
            },
            NewState = State#battle_state{cur_scene = SceneId, scene_pool_id = ScenePoolId, copy_id = RoleIdAsCopyId, roles = RoleMap, data = Data};
        _ ->
            NewState = State
    end,
    {ok, NewState}.

player_enter(RoleKey, Args, State) ->
    #battle_state{roles = RoleMap} = State,
    case maps:find(RoleKey, RoleMap) of
        {ok, #battle_role{out_info = OutInfo, in_info = InInfo} = Role} ->
            [OSceneId, OPoolId, OCopyId, X, Y, Hp, HpLim] = Args,
            NewOutInfo
                = OutInfo#{
                scene => OSceneId,
                scene_pool_id => OPoolId,
                copy_id => OCopyId,
                x => X,
                y => Y,
                hp => max(1, Hp),
                hp_lim => HpLim,
                scene_args => [{ghost, 0}]
            },
            if
                Hp > 0 ->
                    InSceneArgs = [{hp_lim, HpLim}, {hp, HpLim}, {ghost, 1}];
                true ->
                    InSceneArgs = [{change_scene_hp, 1}, {ghost, 1}]
            end,
            {ok, Role#battle_role{out_info = NewOutInfo, in_info = InInfo#{scene_args => InSceneArgs}}, State};
        _ ->
            skip
    end.

%%
player_quit(#battle_role{key = RoleKey}, _Args, #battle_state{is_end = false} = State) ->
    #battle_state{roles = NewRoleMap} = NewState = handle_result(State),
    NewRole = maps:get(RoleKey, NewRoleMap),
    {ok, NewRole, NewState};
player_quit(_, _, _) ->
    skip.

%% 掉线
player_logout(#battle_role{key = RoleKey}, _Args, #battle_state{is_end = false} = State) ->
    #battle_state{roles = NewRoleMap} = NewState = handle_result(State),
    NewRole = maps:get(RoleKey, NewRoleMap),
    {ok, NewRole, NewState};
player_logout(_Role, _Args, _State) ->
    skip.

%% 断开客户端
player_disconnect(#battle_role{}, _Args, #battle_state{is_end = false} = State) ->
    NewState = handle_result(State),
    {ok, NewState};
player_disconnect(_Role, _Args, _State) ->
    skip.


player_die(_Role, _Args, _State) ->
    skip.

player_revive(_Role, _Args, _State) ->
    skip.


player_finish_change_scene(Role, _Args, State) ->
    % ?PRINT("player_finish_change_scene res = ~p~n", [ok]),
    % #battle_state{roles = RoleMap, self = Self, data = Data, cur_scene = SceneId, scene_pool_id = ScenePoolId} = State,
    % RoleList = maps:to_list(RoleMap),
    % case lists:all(fun
    %                    ({_key, R}) ->
    %                        R#battle_role.state =:= ?ROLE_STATE_IN orelse R#battle_role.key =:= Role#battle_role.key
    %                end, RoleList) of
    %     true ->
    %         case data_jjc:get_jjc_value(?JJC_START_TIME) of
    %             [] -> BeforeStartTime = 3;
    %             [BeforeStartTime] -> skip
    %         end,
    %         UnixTime = utime:unixtime(),
    %         [lib_server_send:send_to_uid(RoleId, pt_280, 28014, [0, UnixTime + BeforeStartTime])
    %             || {RoleId, _} <- RoleList],
    %         erlang:send_after(max((BeforeStartTime) * 1000,100), Self, {apply, ?MODULE, ready_time_out, []}),
    %         case Data of
    %             #{fake_man_mine := #{id := DummyId1}, fake_man_rival := #{id := DummyId2}} ->
    %                 mod_scene_agent:apply_cast(SceneId, ScenePoolId, ?MODULE, dummy_start_battle,
    %                     [[DummyId1, DummyId2], BeforeStartTime*1000 + 500]);
    %             _ ->
    %                 ok
    %         end;
    %     _ ->
    %         ok
    % end,
    {ok, Role, State}.

mon_die(_MonKey, DieRoleId, #battle_state{is_end = false, roles = RoleMap, cur_scene = SceneId, scene_pool_id = ScenePoolId} = State) ->
    #battle_state{data = Data} = State,
    case maps:get(clear_status, Data, 0) of
        0 ->
            RoleList = maps:to_list(RoleMap),
            case data_jjc:get_jjc_value(?JJC_REWARD_TIME) of
                [] ->
                    ?ERR("jjc cfg error:reward time!~n", []),
                    RewardTime = 10;
                [RewardTime] -> skip
            end,
            UnixTime = utime:unixtime(),
            [spawn(fun() ->
                % timer:sleep(200),
                case Data of
                    #{copy_id := CopyId} -> mod_scene_agent:apply_cast(SceneId, ScenePoolId, ?MODULE, sleep_dummy, [CopyId]);
                    _ -> skip
                end,
                mod_jjc:cast_to_jjc(challenge_image_role_result, [RoleId, DieRoleId=/=RoleId, 1]),  %% 挑战默认一次
                lib_server_send:send_to_uid(RoleId, pt_280, 28014, [2, UnixTime + RewardTime])
                   end)
                || {RoleId, _} <- RoleList],
            NewState = State#battle_state{data = maps:put(clear_status, 1, Data)};
        1 -> NewState = State
    end,
    {ok, NewState};

mon_die(_, _, _) -> ok.

dummy_start_battle(List, Time) ->
    [case lib_scene_object_agent:get_object(Id) of
         #scene_object{aid = Aid} ->
             Aid ! {'change_attr', [{find_target, Time}]};
         _ ->
             skip
     end || Id <- List].


send_fake_data(State, _Args) ->
    #battle_state{roles = RoleMap, data = Data} = State,
    RoleList = maps:to_list(RoleMap),
    case Data of
        #{fake_man_mine  := #{id := SelfRobotId, data := #image_role{role_info = #faker_info{role_id = SelfRoleId}}},
          fake_man_rival := #{id := RivalRobotId, data := #image_role{role_info = #faker_info{role_id = RivalRoleId}}}} ->
            lists:map(fun
                          ({RoleId, _}) ->
                              lib_server_send:send_to_uid(RoleId, pt_280, 28013, [SelfRobotId, SelfRoleId, RivalRobotId, RivalRoleId])
                      end, RoleList);
        _ -> skip
    end,
    State.

ready_time_out(#battle_state{is_end = false, roles = RoleMap, self = Self}, []) ->
    RoleList = maps:to_list(RoleMap),
    case data_jjc:get_jjc_value(?JJC_BATTLE_TIME) of
        [] -> BattleTime = 30;
        [BattleTime] -> skip
    end,
    UnixTime = utime:unixtime(),
    [lib_server_send:send_to_uid(RoleId, pt_280, 28014, [1, UnixTime + BattleTime])
        || {RoleId, _} <- RoleList],
    erlang:send_after(BattleTime * 1000, Self, {apply, ?MODULE, battle_time_out, []});
ready_time_out(_State, _) -> ok.

battle_time_out(#battle_state{is_end = false, roles = RoleMap, self = Self, data = Data, cur_scene = SceneId, scene_pool_id = ScenePoolId} = State, []) ->
    case data_jjc:get_jjc_value(?JJC_REWARD_TIME) of
        [] -> RewardTime = 10;
        [RewardTime] -> skip
    end,
    case maps:get(clear_status, Data, 0) of
        0 ->
            RoleList = maps:to_list(RoleMap),

            UnixTime = utime:unixtime(),
            [begin
                 case Data of
                     #{copy_id := CopyId} -> mod_scene_agent:apply_cast(SceneId, ScenePoolId, ?MODULE, sleep_dummy, [CopyId]);
                     _ -> skip
                 end,
                 mod_jjc:cast_to_jjc(challenge_image_role_result, [RoleId]),
                 lib_server_send:send_to_uid(RoleId, pt_280, 28014, [2, UnixTime + RewardTime])
             end
                || {RoleId, _} <- RoleList],
            NewState = State#battle_state{data = maps:put(clear_status, 1, Data)};
        1 -> NewState = State
    end,
    erlang:send_after(RewardTime * 1000, Self, {apply, ?MODULE, reward_time_out, []}),
    NewState;
battle_time_out(_State, _) -> ok.

reward_time_out(#battle_state{is_end = false} = State, []) ->
    handle_result(State);
reward_time_out(_State, _) -> ok.

handle_result(#battle_state{roles = _RoleMap, self = Self, data = _Data} = State) ->
    mod_battle_field:stop(Self),
    State#battle_state{is_end = true}.

evt_out_of_battle(Player, _Reason) ->
    %?PRINT("evt_out_of_battle res = ~p~n", [ok]),
    #player_status{sid = Sid} = Player,
    %% 通知客户端结束
    lib_server_send:send_to_sid(Sid, pt_280, 28012, [?SUCCESS]),
    lib_player:break_action_lock(Player#player_status{jjc_battle_pid = undefined}, ?ERRCODE(err280_on_battle_state)).

terminate(_Reason, State) ->
    #battle_state{data = Data, cur_scene = SceneId, scene_pool_id = ScenePoolId, copy_id = CopyId} = State,
    lib_scene:clear_scene_room(SceneId, ScenePoolId, CopyId),
    case Data of
        #{rank := RankList} ->
            mod_jjc:cast_to_jjc(set_battle_status, [RankList, ?NOT_BATTLE_STATUS]);
        _ -> skip
    end.

fake_man_die_handler(#scene_object{id = Id, mod_args = ModArgs}, _Klist, _Atter, _AtterSign, [BattleFieldPid]) ->
    mod_battle_field:mon_die(BattleFieldPid, Id, ModArgs).

skip_battle(#battle_state{data = Data, cur_scene = SceneId, scene_pool_id = ScenePoolId} = State, [RoleId]) ->
    case maps:get(clear_status, Data, 0) of
        0 ->
            mod_jjc:cast_to_jjc(challenge_image_role_result, [RoleId]),
            NewState = State#battle_state{data = maps:put(clear_status, 1, Data)};
        1 -> NewState = State
    end,
    case Data of
        #{copy_id := CopyId} -> mod_scene_agent:apply_cast(SceneId, ScenePoolId, ?MODULE, clear_dummy, [CopyId]);
        _ -> skip
    end,
    NewState.

clear_dummy(CopyId) ->
    lib_scene_object_agent:clear_scene_object(0, CopyId, 1).

%% 睡眠假人
sleep_dummy(CopyId) ->
    AllObject = lib_scene_object_agent:get_scene_object(CopyId),
    [begin
        Object#scene_object.aid ! 'thorough_sleep'
    end || Object <- AllObject, Object/=[]],
    ok.

%% 触发战斗定时器
trigger_battle_ref(State, Args) ->
    trigger_battle(State, Args).

%% 触发战斗
% none 已经触发战斗,无法重复执行
trigger_battle(#battle_state{data = #{trigger_battle_ref := none}} = State, _Args) ->
    State;
trigger_battle(State, _Args) ->
    % ?PRINT("player_finish_change_scene res = ~p~n", [ok]),
    #battle_state{roles = RoleMap, self = Self, data = Data, cur_scene = SceneId, scene_pool_id = ScenePoolId} = State,
    RoleList = maps:to_list(RoleMap),
    case data_jjc:get_jjc_value(?JJC_START_TIME) of
        [] -> BeforeStartTime = 3;
        [BeforeStartTime] -> skip
    end,
    UnixTime = utime:unixtime(),
    [lib_server_send:send_to_uid(RoleId, pt_280, 28014, [0, UnixTime + BeforeStartTime])
        || {RoleId, _} <- RoleList],
    erlang:send_after(max((BeforeStartTime) * 1000,100), Self, {apply, ?MODULE, ready_time_out, []}),
    case Data of
        #{fake_man_mine := #{id := DummyId1}, fake_man_rival := #{id := DummyId2}, trigger_battle_ref := BattleRef} ->
            util:cancel_timer(BattleRef),
            mod_scene_agent:apply_cast(SceneId, ScenePoolId, ?MODULE, dummy_start_battle,
                [[DummyId1, DummyId2], BeforeStartTime*1000 + 500]);
        _ ->
            ok
    end,
    State#battle_state{data = Data#{trigger_battle_ref => none}}.