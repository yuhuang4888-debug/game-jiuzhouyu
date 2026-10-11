%%%--------------------------------------
%%% @Module  : mod_saint
%%% @Author  : fwx
%%% @Created : 2018.6.13
%%% @Description:  圣者殿
%%%--------------------------------------
-module(mod_saint).

-behaviour(gen_server).

%% API
-export([start_link/0]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
    terminate/2, code_change/3]).

-compile(export_all).

-include("common.hrl").
-include("def_fun.hrl").
-include("scene.hrl").
-include("errcode.hrl").
-include("predefine.hrl").
-include("def_module.hrl").
-include("saint.hrl").
-include("figure.hrl").
-include("attr.hrl").
-include("goods.hrl").
%%%===================================================================
%%% API
%%%===================================================================

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

%% 获取圣者殿信息
get_saint_info(Node, RoleSaint) ->
    gen_server:cast(?MODULE, {'get_saint_info', Node, RoleSaint}).

get_saint_challenge_record(Node, RoleSaint, SaintId) ->
    gen_server:cast(?MODULE, {'get_saint_challenge_record', Node, RoleSaint, SaintId}).

%% 进入圣者殿大厅
enter_saint(Node, RoleSaint, StoneId) ->
    gen_server:cast(?MODULE, {'enter_saint', Node, RoleSaint, StoneId}).

%% 离开圣者殿大厅
leave_saint(Node, RoleId, ServerId) ->
    gen_server:cast(?MODULE, {'leave_saint', Node, RoleId, ServerId}).

%%
logout_saint(Node, RoleId, ServerId) ->
    gen_server:cast(?MODULE, {'logout_saint', Node, RoleId, ServerId}).

%% 离开圣者殿战斗
leave_fight(Node, RoleId, ServerId) ->
    gen_server:cast(?MODULE, {'leave_fight', Node, RoleId, ServerId}).

%% 挑战石像
challenge_saint(Node, RoleSaint, StoneId, RoleData, IsReward) ->
    gen_server:cast(?MODULE, {'challenge_saint', Node, RoleSaint, StoneId, RoleData, IsReward}).

%% 启动时通知游戏节点同步
sync_saint_info(ServerId, Node) ->
    gen_server:cast(?MODULE, {'sync_saint_info', ServerId, Node}).

%% 更新figure
update_saint_info(ServerId, T) ->
    gen_server:cast(?MODULE, {'update_saint_info', ServerId, T}).

%% 跨服合并前移除称号
remove_dsgt() ->
    gen_server:cast(?MODULE, {'remove_dsgt'}).

%% cast
apply_cast(M, F, A) ->
    gen_server:cast(?MODULE, {'apply_cast', M, F, A}).

%%%===================================================================
%%% gen_server callbacks
%%%===================================================================
init([]) ->
    erlang:send_after(500, self(), 'init'),
    {ok, #kf_saint_state{}}.

handle_call(Req, From, State) ->
    case catch do_handle_call(Req, From, State) of
        {reply, Res, NewState} ->
            {reply, Res, NewState};
        Res ->
            ?ERR("Saint Call Error:~p~n", [[Req, Res]]),
            {reply, error, State}

    end.

handle_cast(Msg, State) ->
    case catch do_handle_cast(Msg, State) of
        {noreply, NewState} ->
            {noreply, NewState};
        Res ->
            ?ERR("Saint Cast Error:~p~n", [[Msg, Res]]),
            {noreply, State}
    end.

handle_info(Info, State) ->
    case catch do_handle_info(Info, State) of
        {noreply, NewState} ->
            {noreply, NewState};
        Res ->
            ?ERR("Saint Info Error:~p~n", [[Info, Res]]),
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
    %?PRINT("_Req:~p~n", [_Req]),
    {reply, ok, State}.

%% 游戏节点请求boss信息
%% IsForce:是否强制更新 0否;1是
do_handle_cast({'get_saint_info', Node, RoleSaint}, State) ->
    #kf_saint_state{saint_map = SaintMap, sync = Sync} = State,
    #role_saint{role_id = RoleId, server_id = ServerId} = RoleSaint,
    case get_zone_saint_map(ServerId, SaintMap) of
        {ok, _ZoneId, ZoneSaintMap} ->
            F = fun(SaintId, #saint{role_id = SaintRoleId, cd = Cd, status = Status, combat = Combat, figure = Figure, server_name = ServerName}, Acc) ->
                %?PRINT("~p~n", [ServerName]),
                [{SaintId, Cd, Status, SaintRoleId, ServerName, Figure, Combat} | Acc]
                end,
            SendL = maps:fold(F, [], ZoneSaintMap),
            %?PRINT("~p~n", [SendL]),
            LastL = ?IF(Sync == 1, SendL, []),
            {ok, Bin} = pt_607:write(60701, [Sync, LastL]),
            lib_clusters_center:send_to_uid(Node, RoleId, Bin),
            {noreply, State};
        _ -> %% 该服暂未分区
            pp_saint:send_error(Node, RoleId, ?ERRCODE(server_no_zone)),
            {noreply, State}
    end;

%% 进入圣者殿大厅
do_handle_cast({'enter_saint', Node, RoleSaint, StoneId}, State) ->
    NowTime = utime:unixtime(),
    #kf_saint_state{role_info = RolesZoneDict, scene_num = SceneZoneMap, saint_map = SaintZoneMap} = State,
    #role_saint{role_id = RoleId, server_id = ServerId} = RoleSaint,
    case lib_clusters_center_api:get_zone(ServerId) of
        0 -> %% 该服暂未分区
            pp_saint:send_error(Node, RoleId, ?ERRCODE(server_no_zone)),
            {noreply, State};
        ZoneId ->
            %% 分区里面的某个场景的人数
            SceneNum = maps:get(ZoneId, SceneZoneMap, 0),
            Saint = get_one_saint(ZoneId, SaintZoneMap, StoneId),
            #ets_scene{x = X, y = Y} = data_scene:get(?READY_SCENE),
            #ets_scene_other{room_max_people = MaxNum} = data_scene_other:get(?READY_SCENE),
            if
                SceneNum >= MaxNum ->
                    pp_saint:send_error(Node, RoleId, ?ERRCODE(err120_max_user)),
                    {noreply, State};
                not is_record(Saint, saint) ->
                    ?ERR("saint_create_error:~p~n", [[ZoneId, StoneId]]),
                    {noreply, State};
                Saint#saint.status == ?STATUS_FIGHT ->
                    pp_saint:send_error(Node, RoleId, ?ERRCODE(err607_fighting)),
                    {noreply, State};
                Saint#saint.cd >= NowTime ->
                    pp_saint:send_error(Node, RoleId, ?ERRCODE(err607_cd)),
                    {noreply, State};
                true ->
                    case dict:find({ZoneId, RoleId}, RolesZoneDict) of
                        error ->
                            NewSceneNum = SceneNum + 1,
                            NewSceneZoneMap = maps:put(ZoneId, NewSceneNum, SceneZoneMap),
                            NewRoleSaint = RoleSaint#role_saint{node = Node},
                            NewRolesZoneDict = dict:store({ZoneId, RoleId}, NewRoleSaint, RolesZoneDict),
                            %% 锁
                            lib_saint:apply_cast(Node, lib_player, apply_cast,
                                [RoleId, ?APPLY_CAST_STATUS, lib_player, setup_action_lock, [?ERRCODE(err607_sainting)]]),
                            mod_clusters_center:apply_cast(Node, lib_scene, player_change_scene_queue,
                                [RoleId, ?READY_SCENE, 0, ZoneId, X, Y, true, []]),
                            {ok, Bin} = pt_607:write(60702, [StoneId]),
                            lib_clusters_center:send_to_uid(Node, RoleId, Bin),
                            {noreply, State#kf_saint_state{role_info = NewRolesZoneDict, scene_num = NewSceneZoneMap}};
                        _ ->
                            ?ERR("have in saint ~p~n", [RoleId]),
                            {noreply, State}
                    end
            end
    end;

%% 离开圣者殿大厅
do_handle_cast({'leave_saint', Node, RoleId, ServerId}, State) ->
    #kf_saint_state{role_info = RoleInfos, scene_num = SceneMap} = State,
    case lib_clusters_center_api:get_zone(ServerId) of
        0 -> %% 该服暂未分区
            NewRoleInfos = RoleInfos, NewSceneMap = SceneMap;
        ZoneId ->
            case dict:find({ZoneId, RoleId}, RoleInfos) of
                error -> NewRoleInfos = RoleInfos, NewSceneMap = SceneMap;
                _ ->
                    NewRoleInfos = dict:erase({ZoneId, RoleId}, RoleInfos),
                    SceneNum = maps:get(ZoneId, SceneMap, 0),
                    NewSceneNum = max(SceneNum - 1, 0),
                    NewSceneMap = maps:put(ZoneId, NewSceneNum, SceneMap)
            end
    end,
    %% 不走队列
    mod_clusters_center:apply_cast(Node, lib_scene, player_change_scene,
        [RoleId, 0, 0, 0, 0, 0, true, []]),
    lib_saint:apply_cast(Node, lib_player, apply_cast,
        [RoleId, ?APPLY_CAST_STATUS, lib_player, break_action_lock, [?ERRCODE(err607_sainting)]]),
    {noreply, State#kf_saint_state{role_info = NewRoleInfos, scene_num = NewSceneMap}};

%玩家下线 圣者殿大厅
do_handle_cast({'logout_saint', Node, RoleId, ServerId}, State) ->
    %?PRINT("log out saint~n", []),
    #kf_saint_state{role_info = RoleInfos, scene_num = SceneMap} = State,
    case lib_clusters_center_api:get_zone(ServerId) of
        0 -> NewRoleInfos = RoleInfos, NewSceneMap = SceneMap;
        ZoneId ->
            case dict:find({ZoneId, RoleId}, RoleInfos) of
                error -> NewRoleInfos = RoleInfos, NewSceneMap = SceneMap;
                _ ->
                    NewRoleInfos = dict:erase({ZoneId, RoleId}, RoleInfos),
                    SceneNum = maps:get(ZoneId, SceneMap, 0),
                    NewSceneNum = max(SceneNum - 1, 0),
                    NewSceneMap = maps:put(ZoneId, NewSceneNum, SceneMap)
            end
    end,
    lib_saint:apply_cast(Node, lib_player, apply_cast,
        [RoleId, ?APPLY_CAST_STATUS, lib_player, break_action_lock, [?ERRCODE(err607_sainting)]]),
    {noreply, State#kf_saint_state{role_info = NewRoleInfos, scene_num = NewSceneMap}};

% 挑战石像
do_handle_cast({'challenge_saint', Node, RoleSaint, SaintId, RoleData, IsReward}, State) ->
    NowTime = utime:unixtime(),
    BattleNode = node(),
    #kf_saint_state{role_info = RoleInfos, saint_map = SaintMap} = State,
    #role_saint{role_id = RoleId, server_id = ServerId} = RoleSaint,
    case get_zone_saint_map(ServerId, SaintId, SaintMap) of
        {ok, _, _, #saint{cd = Cd}} when NowTime < Cd ->    %% 冷却中
            pp_saint:send_error(Node, RoleId, ?ERRCODE(err607_cd)),
            {noreply, State};
        {ok, _, _, #saint{status = ?STATUS_FIGHT}} ->       %% 战斗中
            pp_saint:send_error(Node, RoleId, ?ERRCODE(err607_fighting)),
            {noreply, State};
        {ok, _, _, #saint{role_id = RoleId}} ->  %% 不能挑战自己
            pp_saint:send_error(Node, RoleId, ?ERRCODE(err607_fight_self)),
            {noreply, State};
        {ok, ZoneId, ZoneSaintMap, Saint} ->
            #saint{role_id = SaintRoleId, figure = SaintFigure, skills = SaintSkills, attr = SaintAttr, server_name = SaintServerName} = Saint,
            %?PRINT("~p~n", [Saint]),
            case dict:find({ZoneId, RoleId}, RoleInfos) of
                error ->
                    {noreply, State};
                _ ->
                    case lib_saint:check_by_saint_lv(ZoneSaintMap, RoleId, SaintId) of
                        true ->
                            SaintInitData = [SaintServerName, SaintFigure, SaintAttr, SaintSkills],
%%                  %% 创建战场 进入战场后先发转盘属性
                            %% 防止重复创建
                            case get({RoleId, battle_pid}) of
                                Pid when is_pid(Pid) ->
                                    ?ERR("saint fighting~n", []),
                                    {noreply, State};
                                _ ->
                                    case catch mod_battle_field:start(lib_saint_battle, [Node, RoleId, ServerId, SaintId, SaintRoleId, SaintInitData, IsReward]) of
                                        BattlePid when is_pid(BattlePid) ->
                                            lib_saint:apply_cast(Node, lib_player, apply_cast,
                                                [RoleId, ?APPLY_CAST_STATUS, lib_saint, battle_field_create_done, [BattleNode, BattlePid, RoleId, SaintId]]),
                                            %%----------------------
                                            NewSaint = Saint#saint{status = ?STATUS_FIGHT},
                                            NewZoneSaintMap = maps:put(SaintId, NewSaint, ZoneSaintMap),
                                            NewSaintMap = maps:put(ZoneId, NewZoneSaintMap, SaintMap),
                                            mod_clusters_center:apply_cast(Node, mod_daily, increment, [RoleId, ?MOD_SAINT, 1]),
                                            boardcast_scene(ZoneId, NewZoneSaintMap),
                                            put({RoleId, battle_pid}, BattlePid),
                                            put(RoleId, RoleData),
                                            {noreply, State#kf_saint_state{saint_map = NewSaintMap}};
                                        _ ->
                                            %?PRINT("init fail ~p~n", [fail]),
                                            lib_saint:apply_cast(Node, lib_player, apply_cast, [RoleId, ?APPLY_CAST_STATUS, lib_saint, battle_field_create_done, [init_error]]),
                                            {noreply, State}
                                    end
                            end;
                        _ ->
                            pp_saint:send_error(Node, RoleId, ?ERRCODE(err607_saint_lv_limit)),
                            {noreply, State}
                    end
            end;
        _R ->
            ?ERR("~p ~p server error ServerId:~w~n", [?MODULE, ?LINE, [ServerId, _R]]),
            {noreply, State}
    end;

do_handle_cast({'apply_cast', M, F, A}, State) ->
    M:F(State, A);

%% 发送同步玩家id列表
do_handle_cast({'sync_saint_info', ServerId, Node}, State) ->
    #kf_saint_state{saint_map = SaintMap} = State,
    case get_zone_saint_map(ServerId, SaintMap) of
        {ok, _ZoneId, ZoneSaintMap} ->
            F = fun(SaintId, #saint{role_id = SaintRoleId}, Acc) ->
                [{SaintId, ServerId, SaintRoleId} | Acc]
                end,
            RoleL = maps:fold(F, [], ZoneSaintMap),
            %?PRINT("~p~n", [RoleL]),
            mod_clusters_center:apply_cast(Node, mod_saint_local, sync_saint_info, [RoleL]),
            {noreply, State#kf_saint_state{sync = 1}};
        _ ->
            ?ERR("no zone saint map ~p~n", [ServerId]),
            {noreply, State}
    end;


%% 同步figure
do_handle_cast({'update_saint_info', ServerId, {SaintId, Figure, ServerName}}, State) ->
    %?PRINT("~p~n", [Figure]),
    #kf_saint_state{saint_map = SaintMap} = State,
    case get_zone_saint_map(ServerId, SaintId, SaintMap) of
        {ok, ZoneId, ZoneSaintMap, Saint} ->
            NewSaint = Saint#saint{figure = Figure, server_name = ServerName},
            NewZoneSaintMap = maps:put(SaintId, NewSaint, ZoneSaintMap),
            NewSaintMap = maps:put(ZoneId, NewZoneSaintMap, SaintMap),
            NewState = State#kf_saint_state{saint_map = NewSaintMap},
            {noreply, NewState};
        _ ->
            %?PRINT("no saint map: ~p~n", [SaintMap]),
            {noreply, State}
    end;

do_handle_cast({'remove_dsgt'}, State) ->
    #kf_saint_state{saint_map = SaintMap} = State,
    SaintList = maps:to_list(SaintMap),
    F = fun
            (_, ZoneSaintMap) ->
            ZoneSaintList = maps:to_list(ZoneSaintMap),
            F1 = fun
                     (SaintId, #saint{role_id = RoleId}) ->
                         case  data_saint:get_stone(SaintId) of
                             #base_saint_stone{dsgt_id = DsgtId} ->
                                 case RoleId of
                                     0 -> skip;
                                     _ ->
                                         RoleNode = lib_clusters_center:get_node_by_role_id(RoleId),
                                         mod_clusters_center:apply_cast(RoleNode, lib_designation_api, cancel_dsgt, [RoleId, DsgtId])
                                 end;
                             _ ->
                                 skip
                         end
                 end,
             [F1(SaintId, Saint)  ||{SaintId, Saint}  <- ZoneSaintList ]
        end,
    [F(ZoneId, ZoneSaintMap)  || {ZoneId, ZoneSaintMap} <- SaintList ];

do_handle_cast({'get_saint_challenge_record', Node, RoleSaint, SaintId}, State) ->
    #kf_saint_state{saint_map = SaintMap} = State,
    #role_saint{role_id = RoleId, server_id = ServerId} = RoleSaint,
    case get_zone_saint_map(ServerId, SaintMap) of
        {ok, _ZoneId, ZoneSaintMap} ->
            ZoneSaintList = maps:to_list(ZoneSaintMap),
            case lists:keyfind(SaintId, 1, ZoneSaintList) of
                {_, #saint{challenge_log = LogL}} ->
                    SendL = lists:sublist(LogL, ?MAX_RECORD),
                    {ok, Bin} = pt_607:write(60711, [SaintId, SendL]),
                    lib_clusters_center:send_to_uid(Node, RoleId, Bin);
                _ ->
                    skip
            end,
            %?PRINT("~p~n", [SendL]),
            {noreply, State};
        _ -> %% 该服暂未分区
            pp_saint:send_error(Node, RoleId, ?ERRCODE(server_no_zone)),
            {noreply, State}
    end;

do_handle_cast(Msg, State) ->
    ?ERR("Saint Cast No Match:~w~n", [Msg]),
    {noreply, State}.

%% info
%% 石像初始化
do_handle_info('init', State) ->
    %_NowTime = utime:unixtime(),
    AllIds = data_saint:get_all_saint_id(),
    ZoneIds = lists:seq(1, ?MAX_ZONE),
    F = fun
            (ZoneId, LineSaintMap) ->
                DbList = get_saint_db_info(ZoneId, AllIds),
                Fun = fun
                          ({StoneId, RoleId, Combat, Attr, Skills}, AccMap) ->
                              case data_saint:get_stone(StoneId) of
                                  #base_saint_stone{} ->
                                      Saint = init_saint(ZoneId, StoneId, RoleId, Combat, Attr, Skills),
                                      AccMap#{StoneId => Saint};
                                  _ ->
                                      ?ERR("can't find saint cfg:~p~n", [StoneId]),
                                      AccMap
                              end
                      end,
                SaintMap = lists:foldl(Fun, #{}, DbList),
                LineSaintMap#{ZoneId => SaintMap}
        end,
    LineSaintMap = lists:foldl(F, #{}, ZoneIds),
    %% ?ERR("~p ~p LinesEudemonsBoss:~p~n", [?MODULE, ?LINE, LinesEudemonsBoss]),
    {noreply, State#kf_saint_state{saint_map = LineSaintMap}};

do_handle_info(_Info, State) ->
    ?ERR("Saint Info No Match:~w~n", [_Info]),
    {noreply, State}.


%% ================================= private fun =================================

%% 获取boss信息
get_saint_db_info(ZoneId, AllIds) ->
    SQL = io_lib:format(<<"select stone_id, role_id, combat, attr, skills from saint_kf where zone_id = ~p">>, [ZoneId]),
    {DbList, DelList, LessStoneIds}
        = case db:get_all(SQL) of
              SaintList when is_list(SaintList) ->
                  F = fun([StoneId, RoleId, Combat, BAttr, BSkills], {LefL, DelL, LessL}) ->
                      case lists:member(StoneId, AllIds) of
                          false -> %% del
                              {LefL, [StoneId | DelL], lists:delete(StoneId, LessL)};
                          true ->
                              {[{StoneId, RoleId, Combat, lib_player_attr:to_attr_record(util:bitstring_to_term(BAttr)), util:bitstring_to_term(BSkills)} | LefL],
                                  DelL, lists:delete(StoneId, LessL)}
                      end
                      end,
                  lists:foldl(F, {[], [], AllIds}, SaintList);
              _ ->
                  {[], [], AllIds}
          end,
    Fun = fun
              (DelId, I) ->
                  DelSQL = <<"delete from saint_kf where stone_id = ~p">>,
                  db:execute(io_lib:format(DelSQL, DelId)),
                  if I == 5 -> util:sleep(100), 0; true -> I end
          end,
    lists:foldl(Fun, 0, DelList),
    DbList ++ [{StoneId, 0, 0, #attr{}, []} || StoneId <- LessStoneIds].

%% 初始化圣者殿大厅内石像
init_saint(_ZoneId, SaintId, RoleId, _, _, _) when RoleId =:= 0 ->       %% 玩家id为0 表示是石像
    #saint{
        stone_id = SaintId,
        role_id  = 0,
        combat   = 0,
        figure   = #figure{},
        attr     = #attr{}
    };

init_saint(_ZoneId, SaintId, RoleId, Combat, Attr, Skills) ->        %% 不为0 表示是石像
    #saint{
        stone_id = SaintId,
        role_id  = RoleId,
        combat   = Combat,
        attr     = Attr,
        figure   = #figure{},
        skills   = Skills
    }.

%% 获取一个分区里面的数据{ZoneId, ZoneSaintMap}
get_zone_saint_map(ServerId, SaintMap) ->
    case lib_clusters_center_api:get_zone(ServerId) of
        0 ->
            no_zone;
        ZoneId ->
            case maps:get(ZoneId, SaintMap, null) of
                null ->
                    no_zone_boss_map;
                ZoneSaintMap ->
                    {ok, ZoneId, ZoneSaintMap}
            end
    end.

%% 获取一个分区里面的数据{ZoneId, ZoneBossMap, Boss}
get_zone_saint_map(ServerId, StoneId, SaintMap) ->
    case lib_clusters_center_api:get_zone(ServerId) of
        0 ->
            no_zone;
        ZoneId ->
            case maps:get(ZoneId, SaintMap, null) of
                null ->
                    no_zone_boss_map;
                ZoneSaintMap ->
                    case maps:get(StoneId, ZoneSaintMap, null) of
                        null ->
                            no_saint;
                        Saint ->
                            {ok, ZoneId, ZoneSaintMap, Saint}
                    end
            end
    end.


%% 获取一个石像信息
get_one_saint(ZoneId, SaintMap, StoneId) ->
    case maps:get(ZoneId, SaintMap, null) of
        null ->
            no_zone_saint_map;
        ZoneSaintMap ->
            case maps:get(StoneId, ZoneSaintMap, null) of
                null ->
                    no_saint;
                Saint ->
                    Saint
            end
    end.

calc_result(#kf_saint_state{saint_map = SaintMap} = State, [Node, RoleId, ServerId, SaintId, SaintRoleId, SaintRoleName, SaintServerName, Res, IsReward]) ->  %% 挑战成功
    NowTime = utime:unixtime(),
    #base_saint_stone{name = SaintName, dsgt_id = DsgtId} = data_saint:get_stone(SaintId),
    case get(RoleId) of
        undefined ->
            ?PRINT("no roleid ~p~n", [RoleId]),
            {noreply, State};
        #role_data{figure = Figure, combat = Combat, attr = TmpAttr, skills = Skills, server_name = ServerName} ->
            AttrList = [{Index, round(Val * 1.2)}  || {Index, Val}  <-lib_player_attr:to_kv_list(TmpAttr)  ],
            Attr = lib_player_attr:to_attr_record(AttrList),
            case get_zone_saint_map(ServerId, SaintId, SaintMap) of
                {ok, ZoneId, ZoneSaintMap, Saint} ->
                    case Res of
                        1 ->
                            NewSaint = Saint#saint{
                                role_id  = RoleId,
                                stone_id = SaintId,
                                server_name = ServerName,
                                skills   = Skills,
                                attr     = Attr,
                                combat   = Combat,
                                figure   = Figure,
                                cd       = NowTime + ?CD,
                                status   = ?STATUS_FREE
                            },
                            %?PRINT("~p~n", [ServerName]),
                            %% 广发传闻
                            case SaintRoleId of
                                0 ->
                                    Args = [{all}, ?MOD_SAINT, 2, [ServerName, Figure#figure.name, ulists:list_to_bin(SaintName), lib_designation_api:get_dsgt_name(DsgtId)]];
                                _ ->
                                    Args = [{all}, ?MOD_SAINT, 1, [ServerName, Figure#figure.name, SaintServerName, SaintRoleName, ulists:list_to_bin(SaintName), lib_designation_api:get_dsgt_name(DsgtId)]]
                            end,
                            mod_zone_mgr:apply_cast_to_zone(1, ZoneId, lib_chat, send_TV, Args),
                            case lib_saint:get_valid_saint_id(maps:to_list(ZoneSaintMap), RoleId) of
                                0 ->
                                    TmpZoneSaintMap = ZoneSaintMap;
                                OldSaintId ->
                                    TmpZoneSaintMap = remove_old_saint(ZoneId, ZoneSaintMap, OldSaintId, RoleId, SaintId)
                            end,
                            %% 称号处理  上面先取消再到下面激活 称号相同情况
                            handle_dsgt(SaintId, RoleId, SaintRoleId),
                            Sql = io_lib:format(<<"replace into saint_kf(zone_id, stone_id, role_id, combat, attr, skills) values(~p, ~p, ~p, ~p, ~p, ~p)">>,
                                [ZoneId, SaintId, RoleId, Combat, util:term_to_string(lib_player_attr:to_kv_list(Attr)), util:term_to_string(Skills)]),
                            %?PRINT("~p~n", [util:term_to_bitstring(Figure)]),
                            db:execute(Sql);
                        0 ->
                            TmpZoneSaintMap = ZoneSaintMap,
                            NewSaint = Saint#saint{
                                status = ?STATUS_FREE
                            }
                    end,
                    LastSaint = NewSaint#saint{challenge_log = lists:sublist([{NowTime, RoleId, ServerName, Figure#figure.name, Res} | Saint#saint.challenge_log], ?MAX_RECORD)},
                    NewZoneSaintMap = maps:put(SaintId, LastSaint, TmpZoneSaintMap),
                    NewSaintMap = maps:put(ZoneId, NewZoneSaintMap, SaintMap),
                    NewState = State#kf_saint_state{saint_map = NewSaintMap},
                    boardcast_scene(ZoneId, NewZoneSaintMap),
                    Reward
                        = case IsReward of
                              1 ->
                                  ?IF(Res == 1, data_saint:get_cfg(success_reward), data_saint:get_cfg(fail_reward));
                              0 ->
                                  []
                          end,
                    send_reward(Node, RoleId, Reward, IsReward),
                    pp_saint:send(Node, RoleId, 60710, [Res, Reward]),
                    lib_log_api:log_kf_saint_challenge(ZoneId, SaintId, ServerName, RoleId, Figure#figure.name, SaintServerName, SaintRoleId, SaintRoleName, Res, ?IF(Res == 1, DsgtId, 0)),
                    %%-----------%%
                    erase({RoleId, battle_pid}),
                    erase(RoleId),
                    {noreply, NewState};
                _ ->
                    %?PRINT("no saint map: ~p~n", [SaintMap]),
                    {noreply, State}
            end
    end.

boardcast_scene(ZoneId, ZoneSaintMap) ->
    F = fun(SaintId, #saint{role_id = SaintRoleId, cd = Cd, status = Status, combat = Combat, figure = Figure, server_name = ServerName}, Acc) ->
        [{SaintId, Cd, Status, SaintRoleId, ServerName, Figure, Combat} | Acc]
        end,
    {ok, Bin} = pt_607:write(60701, [1, maps:fold(F, [], ZoneSaintMap)]),
    lib_server_send:send_to_scene(?READY_SCENE, 0, ZoneId, Bin).

handle_dsgt(SaintId, RoleId, SaintRoleId) ->
    #base_saint_stone{dsgt_id = DsgtId} = data_saint:get_stone(SaintId),
    case SaintRoleId of
        0 ->
            skip;
        _ ->
            RivalNode = lib_clusters_center:get_node_by_role_id(SaintRoleId),
            mod_clusters_center:apply_cast(RivalNode, lib_designation_api, cancel_dsgt, [SaintRoleId, DsgtId])
    end,
    RoleNode = lib_clusters_center:get_node_by_role_id(RoleId),
    mod_clusters_center:apply_cast(RoleNode, lib_designation_api, active_dsgt_common, [RoleId, DsgtId]).


remove_old_saint(ZoneId, ZoneSaintMap, OldSaintId, RoleId, SaintId) ->
    case maps:get(OldSaintId, ZoneSaintMap, false) of
        false ->
            ZoneSaintMap;
        Saint ->
            NewSaint = Saint#saint{
                role_id = 0,
                combat  = 0,
                server_name = <<>>,
                figure  = #figure{},
                skills  = [],
                attr    = #attr{}
            },
            #base_saint_stone{dsgt_id = OldDsgtId} = data_saint:get_stone(OldSaintId),
            #base_saint_stone{dsgt_id = NewDsgtId} = data_saint:get_stone(SaintId),
            case OldDsgtId =:= NewDsgtId of
                true -> skip;
                false ->
                    RoleNode = lib_clusters_center:get_node_by_role_id(RoleId),
                    mod_clusters_center:apply_cast(RoleNode, lib_designation_api, cancel_dsgt, [RoleId, OldDsgtId])
            end,
            Sql = io_lib:format(<<"replace into saint_kf(zone_id, stone_id, role_id, combat, attr, skills) values(~p, ~p, ~p, ~p, ~p, ~p)">>,
                [ZoneId, OldSaintId, 0, 0, util:term_to_string([]), util:term_to_string([])]),
            db:execute(Sql),
            maps:put(OldSaintId, NewSaint, ZoneSaintMap)
    end.

send_reward(_Node, _RoleId, _Reward, 0)  -> skip;
send_reward(Node, RoleId, Reward, 1) ->
    case Reward of
        [] -> ?ERR("cfg err~n", []);
        _ ->
            Produce = #produce{title = utext:get(203), content = utext:get(204), type = saint, reward = Reward, show_tips = 1},
            mod_clusters_center:apply_cast(Node, lib_goods_api, send_reward_with_mail, [RoleId, Produce])
    end.

gm_remove_saint_dsgt(State, [ServerId, Node, L]) ->
    #kf_saint_state{saint_map = SaintMap} = State,
    case get_zone_saint_map(ServerId, SaintMap) of
        {ok, _ZoneId, ZoneSaintMap} ->
            SaintL = maps:to_list(ZoneSaintMap),
            F = fun({RoleId, OldDsgtId}) ->
                    case is_have(get_saint_from_dsgt_id(SaintL, OldDsgtId), RoleId) of
                        true ->
                            skip;
                        false ->
                            mod_clusters_center:apply_cast(Node, lib_designation_api, cancel_dsgt, [RoleId, OldDsgtId])
                    end
                end,
            [ F(T) || T <- L ],
            {noreply, State};
        _ ->
            ?ERR("no zone saint map ~p~n", [ServerId]),
            {noreply, State}
    end.

get_saint_from_dsgt_id(SaintL, OldDsgtId) ->
    P = fun(SaintId) ->
            #base_saint_stone{dsgt_id = DsgtId} = data_saint:get_stone(SaintId),
            DsgtId =:= OldDsgtId
        end,
    [ T || {SaintId, _} = T <- SaintL, P(SaintId) ].

is_have([], _) -> false;
is_have([{_, #saint{role_id = RoleId}} | _T], RoleId) -> true;
is_have([{_, _} | T], RoleId) ->
    is_have(T, RoleId).



