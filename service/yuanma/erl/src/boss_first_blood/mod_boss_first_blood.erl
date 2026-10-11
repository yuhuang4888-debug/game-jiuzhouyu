%%-----------------------------------------------------------------------------
%% @Module  :       mod_boss_first_blood
%% @Author  :       Fwx
%% @Created :       2018-03-16
%% @Description:    boss首杀活动
%%-----------------------------------------------------------------------------
-module(mod_boss_first_blood).

-include("custom_act.hrl").
-include("common.hrl").
-include("errcode.hrl").
-include("def_fun.hrl").
-include("goods.hrl").
-include("boss_first_blood.hrl").
-include("scene.hrl").
-include("figure.hrl").
-include("role.hrl").
-include("def_module.hrl").
-include("boss.hrl").

-behaviour(gen_server).

-export([start_link/0]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-export([
    act_info/2,
    boss_be_killed/2,
    act_end/2,
    receive_reward/4
]).

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

init([]) ->
    List = db:get_all(io_lib:format(?sql_select_boss_first_blood, [])),
    F = fun([SubType, BossId, IsKilled, BlStr, Utime], AccMap) ->
        BlList = util:bitstring_to_term(BlStr),
        BossList = maps:get(SubType, AccMap, []),
        NewBossList = [#boss_info{boss_id = BossId, is_killed = IsKilled, bl_ids = BlList, utime = Utime} | BossList],
        maps:put(SubType, NewBossList, AccMap)
        end,
    BossMap = lists:foldl(F, #{}, List),
    List2 = db:get_all(io_lib:format(?sql_select_boss_first_blood_reward, [])),
    F1 = fun([SubType, RoleId, BossId, Bl, RewardState, Utime], AccMap) ->
        RoleList = maps:get(SubType, AccMap, []),
        NewRoleList = [#role_info{key = {RoleId, BossId}, bl = Bl, reward_state = RewardState, utime = Utime} | RoleList],
        maps:put(SubType, NewRoleList, AccMap)
         end,
    RoleMap = lists:foldl(F1, #{}, List2),
    %?PRINT("~p~n", [RoleMap]),
    %?PRINT("~p~n", [BossMap]),
    {ok, #act_state{boss_map = BossMap, role_map = RoleMap}}.

act_info(SubType, RoleId) ->
    gen_server:cast(?MODULE, {'act_info', SubType, RoleId}).

boss_be_killed(BossId, BLWho) ->
    RoleL = [RoleId || #mon_atter{id = RoleId} <- BLWho],
    [gen_server:cast(?MODULE, {'boss_be_killed', SubType, BossId, RoleL})
        || SubType <- lib_custom_act_api:get_open_subtype_ids(?CUSTOM_ACT_TYPE_BOSS_FIRST_BLOOD)].


receive_reward(RoleId, SubType, BossId, RewardL) ->
    gen_server:cast(?MODULE, {'receive_reward', RoleId, SubType, BossId, RewardL}).

act_end(EndType, SubType) ->
    gen_server:cast(?MODULE, {'act_end', EndType, SubType}).

handle_cast(Msg, State) ->
    case catch do_handle_cast(Msg, State) of
        {ok, NewState} when is_record(NewState, act_state) ->
            {noreply, NewState};
        Err ->
            ?ERR("handle_cast Msg:~p error:~p~n", [Msg, Err]),
            {noreply, State}
    end.

do_handle_cast({'act_info', SubType, RoleId}, State) ->
    #act_state{boss_map = BossMap, role_map = RoleMap} = State,
    BossList = maps:get(SubType, BossMap, []),
    RoleList = maps:get(SubType, RoleMap, []),
    %?PRINT("~p~n", [BossList]),
    %?PRINT("~p~n", [RoleList]),
    F = fun(GId, AccL) ->
        case lib_custom_act_util:get_act_reward_cfg_info(?CUSTOM_ACT_TYPE_BOSS_FIRST_BLOOD, SubType, GId) of
            #custom_act_reward_cfg{condition = Condition, reward = Reward} ->
                case lists:keyfind(boss_id, 1, Condition) of
                    false -> ?ERR("custom act boss_first_blood reward config error!!!~p", []), AccL;
                    {_, BossId} ->
                        case lists:keyfind(BossId, #boss_info.boss_id, BossList) of
                            false -> IsKilled = ?NOT_KILLED, BLIds = [];
                            #boss_info{is_killed = IsKilled, bl_ids = BLIds} -> skip
                        end,
                        case lists:keyfind({RoleId, BossId}, #role_info.key, RoleList) of
                            false -> RewardState = ?ACT_REWARD_CAN_NOT_GET;
                            #role_info{reward_state = RewardState} -> skip
                        end,
                        [{GId, BossId, IsKilled, RewardState, get_bl_list(BLIds), Reward} | AccL]
                end;
            _ -> ?ERR("custom act boss_first_blood reward config error!!!~n", []), AccL
        end
        end,
    SendList = lists:foldl(F, [], lib_custom_act_util:get_act_reward_grade_list(?CUSTOM_ACT_TYPE_BOSS_FIRST_BLOOD, SubType)),
    %?PRINT("~p~n", [SendList]),
    lib_server_send:send_to_uid(RoleId, pt_331, 33145, [lists:reverse(SendList)]),
    {ok, State};

do_handle_cast({'boss_be_killed', SubType, BossId, BLList}, State) ->
    %?PRINT("~p~n", [State]),
    case lists:member(BossId, get_boss_id_list(SubType)) of
        true ->
            NowTime = utime:unixtime(),
            #act_state{boss_map = BossMap, role_map = RoleMap} = State,
            BossList = maps:get(SubType, BossMap, []),
            RoleList = maps:get(SubType, RoleMap, []),
            case lists:keymember(BossId, #boss_info.boss_id, BossList) of
                false ->
                    send_tv(BossId, BLList),
                    db:execute(io_lib:format(?sql_replace_boss_first_blood, [SubType, BossId, ?IS_KILLED, util:term_to_bitstring(BLList), NowTime])),
                    NewBList = [#boss_info{boss_id = BossId, is_killed = ?IS_KILLED, utime = NowTime, bl_ids = BLList} | BossList],
                    F = fun(RoleId, AccL) ->
                        case lists:keymember({RoleId, BossId}, #role_info.key, RoleList) of
                            false ->
                                db:execute(io_lib:format(?sql_replace_boss_first_blood_reward, [SubType, RoleId, BossId, 1, ?ACT_REWARD_CAN_GET, NowTime])),
                                [#role_info{key = {RoleId, BossId}, bl = 1, reward_state = ?ACT_REWARD_CAN_GET, utime = NowTime} | AccL];
                            true -> AccL
                        end
                        end,
                    NewRList = lists:foldl(F, RoleList, BLList),
                    NewState = State#act_state{boss_map = maps:put(SubType, NewBList, BossMap), role_map = maps:put(SubType, NewRList, BossMap)};
                true -> NewState = State
            end;
        _ -> NewState = State
    end,
    {ok, NewState};

do_handle_cast({'receive_reward', RoleId, SubType, BossId, RewardL}, State) ->
    NowTime = utime:unixtime(),
    #act_state{boss_map = BossMap, role_map = RoleMap} = State,
    BossList = maps:get(SubType, BossMap, []),
    RoleList = maps:get(SubType, RoleMap, []),
    case lists:keyfind(BossId, #boss_info.boss_id, BossList) of
        #boss_info{is_killed = ?IS_KILLED} ->
            case lists:keyfind({RoleId, BossId}, #role_info.key, RoleList) of
                #role_info{reward_state = ?ACT_REWARD_CAN_GET} = RoleInfo ->
                    lib_goods_api:send_reward_by_id(RewardL, boss_first_blood, RoleId),
                    NewRoleList = lists:keystore({RoleId, BossId}, #role_info.key, RoleList, RoleInfo#role_info{reward_state = ?ACT_REWARD_HAS_GET}),
                    NewRoleMap = maps:put(SubType, NewRoleList, RoleMap),
                    NewState = State#act_state{role_map = NewRoleMap},
                    db:execute(io_lib:format(?sql_replace_boss_first_blood_reward, [SubType, RoleId, BossId, 1, ?ACT_REWARD_HAS_GET, NowTime])),
                    lib_server_send:send_to_uid(RoleId, pt_331, 33146, [?SUCCESS, BossId, ?ACT_REWARD_HAS_GET]);
                _ -> NewState = State
            end;
        _ ->
            NewState = State
    end,
    {ok, NewState};

do_handle_cast({'act_end', EndType, SubType}, State) ->
    F = fun() ->
        db:execute(io_lib:format(?sql_delete_boss_first_blood, [SubType])),
        db:execute(io_lib:format(?sql_delete_boss_first_blood_reward, [SubType]))
        end,
    db:transaction(F),
    #act_state{role_map = RoleMap, boss_map = BossMap} = State,
    case EndType of
        ?CUSTOM_ACT_STATUS_CLOSE ->
            spawn(fun() ->
                timer:sleep(60 * 1000),
                auto_send_unreceive_reward(SubType, RoleMap)
                  end);
        _ -> skip
    end,
    NewRoleMap = maps:remove(SubType, RoleMap),
    NewBossMap = maps:remove(SubType, BossMap),
    NewState = State#act_state{role_map = NewRoleMap, boss_map = NewBossMap},
    {ok, NewState};

do_handle_cast(_Msg, State) -> {ok, State}.

handle_info(Info, State) ->
    case catch do_handle_info(Info, State) of
        {ok, NewState} when is_record(NewState, act_state) ->
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

do_handle_call(_Request, _State) -> {ok, ok}.

terminate(_Reason, _State) ->
    ?ERR("~p is terminate:~p", [?MODULE, _Reason]),
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.


%% ------ inside fun ------------%%

get_bl_list(BLIds) ->
    [case lib_role:get_role_show(RoleId) of
         [] -> ?ERR("role_show can not get:[~p]~n", [RoleId]), {RoleId, ""};
         #ets_role_show{figure = Figure} -> {RoleId, Figure#figure.name}
     end
        || RoleId <- BLIds].

auto_send_unreceive_reward(SubType, RoleMap) ->
    RoleList = maps:get(SubType, RoleMap, []),
    [begin
         Reward = get_reward_by_boss_id(SubType, BossId),
         BossName = case data_mon:get(BossId) of
                        #mon{name = Name} -> Name;
                        _ -> ""
                    end,
         lib_mail_api:send_sys_mail([RoleId], utext:get(3310014), utext:get(3310015, [BossName]), Reward)
     end
        || #role_info{reward_state = ?ACT_REWARD_CAN_GET, key = {RoleId, BossId}} <- RoleList].

get_reward_by_boss_id(SubType, BossId) ->
    GIdL = lib_custom_act_util:get_act_reward_grade_list(?CUSTOM_ACT_TYPE_BOSS_FIRST_BLOOD, SubType),
    do_get_reward_by_boss_id(SubType, BossId, GIdL).

do_get_reward_by_boss_id(_, _, []) -> [];
do_get_reward_by_boss_id(SubType, BossId, [H | T]) ->
    case lib_custom_act_util:get_act_reward_cfg_info(?CUSTOM_ACT_TYPE_BOSS_FIRST_BLOOD, SubType, H) of
        #custom_act_reward_cfg{condition = Condition, reward = Reward} ->
            case lists:keyfind(boss_id, 1, Condition) of
                {_, BossId} -> Reward;
                _ -> do_get_reward_by_boss_id(SubType, BossId, T)
            end;
        _ -> do_get_reward_by_boss_id(SubType, BossId, T)
    end.

get_boss_id_list(SubType) ->
    [case lib_custom_act_util:get_act_reward_cfg_info(?CUSTOM_ACT_TYPE_BOSS_FIRST_BLOOD, SubType, Grade) of
         #custom_act_reward_cfg{condition = Condition} ->
             case lists:keyfind(boss_id, 1, Condition) of
                 {_, BossId} -> BossId;
                 _ -> ?ERR("boss first blood reward config error:[~p]~n", [Grade]), 0
             end;
         _ -> ?ERR("boss first blood reward config error:[~p]~n", [Grade]), 0
     end
        || Grade <- lib_custom_act_util:get_act_reward_grade_list(?CUSTOM_ACT_TYPE_BOSS_FIRST_BLOOD, SubType)].

send_tv(BossId, RoleL) ->
    case data_boss:get_boss_cfg(BossId) of
        #boss_cfg{scene = Scene} ->
            BossName = lib_mon:get_name_by_mon_id(BossId),
            SceneName = lib_scene:get_scene_name(Scene),
            RoleNameL = [case lib_role:get_role_show(RoleId) of
                             [] -> "";
                             #ets_role_show{figure = Figure} -> Figure#figure.name
                         end || RoleId <- RoleL],
            [ lib_server_send:send_to_uid(RoleId, pt_331, 33146, [?SUCCESS, BossId, ?ACT_REWARD_CAN_GET]) ||RoleId  <-  RoleL],
            RoleName = util:link_list(RoleNameL, ulists:thing_to_list(ulists:list_to_bin("、"))),
            lib_chat:send_TV({all}, ?MOD_AC_CUSTOM, 9, [RoleName, SceneName, BossName]);
        _ -> skip
    end.


