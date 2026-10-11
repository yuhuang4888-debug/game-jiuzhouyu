%%%-----------------------------------
%%% @Module      : lib_c_sanctuary 跨服圣域
%%% @Author      : xlh
%%% @Email       : 1593315047@qq.com
%%% @Created     : 2018
%%% @Description : 跨服圣域接口模块
%%%-----------------------------------
-module(lib_c_sanctuary).

-compile(export_all).

-include("cluster_sanctuary.hrl").
-include("common.hrl").
-include("predefine.hrl").
-include("server.hrl").
-include("scene.hrl").
-include("def_event.hrl").
-include("rec_event.hrl").
-include("figure.hrl").
-include("attr.hrl").
-include("boss.hrl").
-include("auction_module.hrl").
-include("rec_auction.hrl").
-include("def_module.hrl").

%% -----------------------------------------------------------------
%% @doc      跨服圣域模块玩家数据初始化
-spec login(RoleId, RoleLv, Logtime, LastLogtime) ->  Return when
    RoleId      :: integer(),           %% 玩家id
    RoleLv      :: integer(),           %% 玩家等级
    Logtime     :: integer(),           %% 本次登陆时间/当前时间
    LastLogtime :: integer(),           %% 上次登陆时间
    Return      :: term().              %% 玩家跨服圣域模块数据 #kf_sanctuary_info{}
%% -----------------------------------------------------------------
login(RoleId, RoleLv, Logtime, _LastLogtime) ->
    OpenDay = util:get_open_day(),
    case data_cluster_sanctuary:get_type_by_openday(OpenDay) of
        Santype when is_integer(Santype) -> %% 判断是否满足开服天数限制
            case data_cluster_sanctuary:get_san_value(open_lv) of
                OpenLv when is_integer(OpenLv) andalso OpenLv > 0 -> OpenLv;
                _ -> OpenLv = 200
            end,
            if
                RoleLv >= OpenLv -> %% 是否满足开启等级限制
                    IsWeekClear = mod_week:get_count(RoleId, ?MOD_C_SANCTUARY, 1),
                    %% 依据两次登陆时间判断是否需要清理积分和怒气值
                    NeedClearScore = calc_login_clear_score(IsWeekClear), 
                    ListD = db:get_row(io_lib:format(?SQL_SELECT_ROLE_DIE, [RoleId])),
                    List = db:get_row(io_lib:format(?SQL_SELECT_ROLE_INFO, [RoleId])),

                    case ListD of %% 死亡疲劳相关数据处理
                        [DieTime, ODieList] -> %die_time_list = [NowTime|NewList], die_time = NowTime, buff_end = NowTime + TimeCfg
                            DieList = util:bitstring_to_term(ODieList),
                            case data_cluster_sanctuary:get_san_value(player_die_times) of
                                TimeCfg when is_integer(TimeCfg) andalso TimeCfg > 0 -> TimeCfg;
                                _ -> TimeCfg = 300
                            end,
                            BuffEndTime = DieTime + TimeCfg;
                        _ ->
                            DieTime = 0, DieList = [], BuffEndTime = 0
                    end,
                    case List of %paied, anger, score, score_status
                        [Paied, Anger, Score, ClearTime, OScoreStage] ->
                            NeedClearAnger = calc_login_clear_anger(Logtime, _LastLogtime, ClearTime),
                            ScoreStage1 = util:bitstring_to_term(OScoreStage),
                            ScoreStage = transform_stage_state(ScoreStage1),
                            if  %% 处理积分和怒气值，玩家积分奖励状态
                                NeedClearAnger == true andalso NeedClearScore == true ->
                                    RScore = 0, RAnger = 0, Rpaid = 0,Stage = [], NClearTime = Logtime,
                                    NScoreStage = util:term_to_string(Stage),
                                    mod_week:set_count(RoleId, ?MOD_C_SANCTUARY, 1, 1),
                                    db:execute(io_lib:format(?SQL_REPLACE_ROLE_INFO, 
                                                [RoleId, Rpaid, RAnger, RScore, Logtime, NScoreStage]));
                                NeedClearAnger == true ->
                                    NewScoreStage = calc_role_score_reward(Score, ScoreStage, Paied),
                                    RAnger = 0, RScore = Score,Rpaid = Paied,Stage = NewScoreStage,
                                    NScoreStage = util:term_to_string(NewScoreStage), NClearTime = Logtime,
                                    db:execute(io_lib:format(?SQL_REPLACE_ROLE_INFO, 
                                                [RoleId, Paied, RAnger, RScore, Logtime, NScoreStage]));
                                NeedClearScore == true ->
                                    RScore = 0, RAnger = Anger,Rpaid = 0,Stage = [],
                                    NScoreStage = util:term_to_string(Stage), NClearTime = ClearTime,
                                    mod_week:set_count(RoleId, ?MOD_C_SANCTUARY, 1, 1),
                                    db:execute(io_lib:format(?SQL_REPLACE_ROLE_INFO, 
                                                [RoleId, 0, RAnger, RScore, ClearTime, NScoreStage]));
                                true ->
                                    NewScoreStage = calc_role_score_reward(Score, ScoreStage, Paied),
                                    NClearTime = ClearTime, RScore = Score, RAnger = Anger, 
                                    Rpaid =Paied, Stage = NewScoreStage
                            end,
                            #kf_sanctuary_info{
                                die_time_list = DieList, paied = Rpaid, die_time = DieTime, 
                                clear_time = NClearTime, buff_end = BuffEndTime, anger = RAnger, 
                                score = RScore, score_status = Stage
                            };
                        _ ->
                            NScoreStage = util:term_to_string([]),
                            mod_week:set_count(RoleId, ?MOD_C_SANCTUARY, 1, 1),
                            db:execute(io_lib:format(?SQL_REPLACE_ROLE_INFO, [RoleId, 0, 0, 0, Logtime, NScoreStage])),
                            #kf_sanctuary_info{die_time_list = DieList, die_time = DieTime, buff_end = BuffEndTime, 
                                    paied = 0, anger = 0, score = 0, score_status = [], clear_time = Logtime}
                    end;
                true ->
                    mod_week:set_count(RoleId, ?MOD_C_SANCTUARY, 1, 1),
                    #kf_sanctuary_info{die_time_list = [], die_time = 0, buff_end = 0, paied = 0, 
                            anger = 0, score = 0, score_status = [], clear_time = Logtime}
            end;
        _ ->
            mod_week:set_count(RoleId, ?MOD_C_SANCTUARY, 1, 1),
            #kf_sanctuary_info{die_time_list = [], die_time = 0, buff_end = 0, paied = 0, 
                    anger = 0, score = 0, score_status = [], clear_time = Logtime}
    end.
    
%% -----------------------------------------------------------------    
%% 根据圣域模式获取相应的场景id
%% -----------------------------------------------------------------
get_scenes_by_santype(Santype) ->
    case data_cluster_sanctuary:get_san_type(Santype) of
        #base_san_type{san_num = [{3, SanScenes}],city_num = [{2, CityScenes}],village_num = [{1, VillScenes}]} ->
            SanScenes ++ CityScenes ++ VillScenes;
        _ ->
            ?ERR("ERR config Santype:~p, server SantypeList = [1,2,3]~n",[Santype]),
            []
    end.

%% -----------------------------------------------------------------
%% 秘籍增加玩家积分
%% -----------------------------------------------------------------
gm_add_role_score(RoleId, Score) ->
    lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, ?MODULE, update_role_score_helper, [Score]).

%% -----------------------------------------------------------------
%% 更新玩家积分
%% -----------------------------------------------------------------
update_role_score([]) -> skip;
update_role_score([{ServerId, RoleId, Score}|RoleScore]) ->
    mod_clusters_center:apply_cast(ServerId, lib_c_sanctuary, update_role_score, [RoleId, Score]),
    update_role_score(RoleScore).

update_role_score(RoleId, Score) ->
    lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, ?MODULE, update_role_score_helper, [Score]).

update_role_score_helper(Player, AScore) ->
    #player_status{kf_sanctuary_info = KfsanRole, id = RoleId} = Player,
    #kf_sanctuary_info{paied = Paied, anger = Anger, score = Score, score_status = ScoreStage, clear_time = ClearTime} = KfsanRole,
    NewScoreStage = calc_role_score_reward(Score+AScore, ScoreStage, Paied),
    %% 更新内存及数据库
    NScoreStage = util:term_to_string(NewScoreStage),
    db:execute(io_lib:format(?SQL_REPLACE_ROLE_INFO, [RoleId, Paied, Anger, Score+AScore, ClearTime, NScoreStage])),
    SendNewScoreStage = lib_c_sanctuary:transform_stage_state_for_client(NewScoreStage),
    {ok, BinData} = pt_284:write(28405, [Score+AScore, Paied, Anger, SendNewScoreStage]),
    % ?MYLOG("xlh","@@@@@@@@ RoleId:~p NewScoreStage:~p~n",[RoleId,NewScoreStage]),
    lib_server_send:send_to_uid(RoleId, BinData),
    % lib_achievement_api:async_event(RoleId, lib_achievement_api, sanctuary_score_event, AScore),
    Newkfrole = KfsanRole#kf_sanctuary_info{score = Score+AScore, score_status = NewScoreStage},
    NewPlayer = Player#player_status{kf_sanctuary_info = Newkfrole},
    {ok, NewPlayer}.

%% -----------------------------------------------------------------
%% 设置玩家的怒气值
%% -----------------------------------------------------------------
set_role_anger(RoleId, Tried) ->
    lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, ?MODULE, set_role_anger_helper, [Tried]).

set_role_anger_helper(Player, Tried) ->
    #player_status{kf_sanctuary_info = KfsanRole, id = RoleId} = Player,
    #kf_sanctuary_info{paied = Paied, score = Score, score_status = ScoreStage, clear_time = ClearTime} = KfsanRole,
    case data_cluster_sanctuary:get_san_value(anger_limit) of
        AngerLimit when is_integer(AngerLimit) -> AngerLimit;
        _ -> AngerLimit = 100
    end,
    if
        Tried >= AngerLimit ->
            AddAnger = AngerLimit;
        Tried < 0 -> 
            AddAnger = 0;
        true -> 
            AddAnger = Tried
    end,
    %% 更新内存及数据库
    NScoreStage = util:term_to_string(ScoreStage),
    db:execute(io_lib:format(?SQL_REPLACE_ROLE_INFO, [RoleId, Paied, AddAnger, Score, ClearTime, NScoreStage])),
    SendScoreStage = lib_c_sanctuary:transform_stage_state_for_client(ScoreStage),
    {ok, BinData} = pt_284:write(28405, [Score, Paied, AddAnger, SendScoreStage]),
    lib_server_send:send_to_uid(RoleId, BinData),
    Newkfrole = KfsanRole#kf_sanctuary_info{anger = AddAnger, score = Score, score_status = ScoreStage},
    NewPlayer = Player#player_status{kf_sanctuary_info = Newkfrole},
    lib_boss:try_to_updata_senen_data(NewPlayer, ?BOSS_TYPE_KF_SANCTUARY),
    {ok, NewPlayer}.

%% -----------------------------------------------------------------
%% 更新玩家怒气值
%% -----------------------------------------------------------------
update_role_anger(ServerId, RoleIdList, Anger, LogArgs) ->
    mod_clusters_center:apply_cast(ServerId, lib_c_sanctuary, update_role_anger, [RoleIdList, Anger, LogArgs]).

update_role_anger(RoleIdList, Anger, LogArgs) ->
    ServerId = config:get_server_id(),
    Fun = fun({TemServerId, RoleId}) when TemServerId == ServerId ->
        lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, ?MODULE, update_role_anger_helper, [Anger, LogArgs]);
        (_) -> skip
    end,
    lists:foreach(Fun, RoleIdList).

update_role_anger_helper(Player, AAnger, LogArgs) ->
    [Scene,ConType,MonId,MonType] = LogArgs,
    #player_status{kf_sanctuary_info = KfsanRole, id = RoleId, figure = #figure{name = RoleName}} = Player,
    #kf_sanctuary_info{paied = Paied, anger = Anger, score = Score, score_status = ScoreStage, clear_time = ClearTime} = KfsanRole,
    case data_cluster_sanctuary:get_san_value(anger_limit) of
        AngerLimit when is_integer(AngerLimit) -> AngerLimit;
        _ -> AngerLimit = 100
    end,
    if
        AAnger+Anger >= AngerLimit ->
            AddAnger = AngerLimit;
        true -> 
            AddAnger = AAnger+Anger
    end,
    %% 更新内存及数据库
    NScoreStage = util:term_to_string(ScoreStage),
    db:execute(io_lib:format(?SQL_REPLACE_ROLE_INFO, [RoleId, Paied, AddAnger, Score, ClearTime, NScoreStage])),
    SendScoreStage = lib_c_sanctuary:transform_stage_state_for_client(ScoreStage),
    {ok, BinData} = pt_284:write(28405, [Score, Paied, AddAnger, SendScoreStage]),
    lib_server_send:send_to_uid(RoleId, BinData),
    Newkfrole = KfsanRole#kf_sanctuary_info{anger = AddAnger, score = Score, score_status = ScoreStage},
    NewPlayer = Player#player_status{kf_sanctuary_info = Newkfrole},
    lib_achievement_api:async_event(RoleId, lib_achievement_api, sanctuary_boss_event, []),
    {ok, LastPlayer} = lib_temple_awaken_api:trigger_sanctuary_boss(NewPlayer),
    lib_log_api:log_kf_san_kill_log(RoleId, RoleName, Scene, ConType, MonId, MonType, Anger, AddAnger),
    %% 通知场景怒气值变化
    lib_boss:try_to_updata_senen_data(LastPlayer, ?BOSS_TYPE_KF_SANCTUARY),
    {ok, LastPlayer}.

%% -----------------------------------------------------------------
%% 定时清理玩家积分
%% -----------------------------------------------------------------
clear_role_score() ->
    % ?MYLOG("xlh_score","@@@@@@@@ clear_role_score:~p~n",[111]),
    OnlineRoles = ets:tab2list(?ETS_ONLINE),
    [lib_player:apply_cast(E#ets_online.id, ?APPLY_CAST_SAVE, ?MODULE, clear_role_score_helper, []) || E <- OnlineRoles].
clear_role_score_helper(Player) ->
	#player_status{kf_sanctuary_info = KfsanRole, id = RoleId} = Player,
	#kf_sanctuary_info{anger = Anger, clear_time = ClearTime} = KfsanRole,
	%% 更新内存及数据库
	NewScoreStage = calc_role_score_reward(0, [], 0),
	NScoreStage = util:term_to_string(NewScoreStage),
	db:execute(io_lib:format(?SQL_REPLACE_ROLE_INFO, [RoleId, 0, Anger, 0, ClearTime, NScoreStage])),
	Newkfrole = KfsanRole#kf_sanctuary_info{paied = 0, score = 0, score_status = NewScoreStage},
    SendScoreStage = lib_c_sanctuary:transform_stage_state_for_client(NewScoreStage),
	{ok, BinData} = pt_284:write(28405, [0, 0, Anger, SendScoreStage]),
    lib_server_send:send_to_uid(RoleId, BinData),
    NewPlayer = Player#player_status{kf_sanctuary_info = Newkfrole},
    mod_week:set_count(RoleId, ?MOD_C_SANCTUARY, 1, 1),
    {ok, NewPlayer}.

%% -----------------------------------------------------------------
%% 定时清理怒气值
%% -----------------------------------------------------------------
clear_role_anger() ->
    OnlineRoles = ets:tab2list(?ETS_ONLINE),
    spawn(fun() -> 
        timer:sleep(350),%% 防止这边计数器赋值后又被清掉所以这里保持同步延时350ms
        Fun = fun(E) ->
            timer:sleep(20),
            lib_player:apply_cast(E#ets_online.id, ?APPLY_CAST_SAVE, ?MODULE, clear_role_anger_helper, []) 
        end,
        lists:foreach(Fun, OnlineRoles) end).
    

clear_role_anger_helper(Player) ->
    #player_status{kf_sanctuary_info = KfsanRole, id = RoleId} = Player,
    #kf_sanctuary_info{paied = Paied, score = Score, score_status = ScoreStage} = KfsanRole,
    %% 更新内存及数据库
    % NScoreStage = util:term_to_string(ScoreStage),
    NowTime = utime:unixtime(),
    Sql = <<"update sanctuary_kf_role set anger = ~p, clear_time = ~p where role_id = ~p">>,
    db:execute(io_lib:format(Sql, [0, NowTime, RoleId])),
    Newkfrole = KfsanRole#kf_sanctuary_info{anger = 0, clear_time = NowTime},
    SendScoreStage = lib_c_sanctuary:transform_stage_state_for_client(ScoreStage),
    {ok, BinData} = pt_284:write(28405, [Score, Paied, 0, SendScoreStage]),
    lib_server_send:send_to_uid(RoleId, BinData),
    NewPlayer = Player#player_status{kf_sanctuary_info = Newkfrole},
    lib_boss:try_to_updata_senen_data(NewPlayer, ?BOSS_TYPE_KF_SANCTUARY),
    {ok, NewPlayer}.

%% -----------------------------------------------------------------
%% 勋章奖励 %%所有在范围内且有伤害的玩家
%% -----------------------------------------------------------------
send_hurt_reward(RankList, Args, MedalReward) ->
    Fun = fun({_S,_SN,R,_N,_H}) ->
        mod_clusters_center:apply_cast(_S, lib_c_sanctuary, send_hurt_reward_helper, [R, MedalReward, Args])
    end,
    lists:foreach(Fun, RankList).
    

send_hurt_reward_helper(RoleId, Reward, Args) -> 
        lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, ?MODULE, send_reward_helper, [Reward, kf_sanctuary_hurt_rank, Args]).


%% -----------------------------------------------------------------
%% 发送奖励给玩家
%% -----------------------------------------------------------------
send_c_reward(Node, RoleId, Reward, ProduceType, Args) ->
    mod_clusters_center:apply_cast(Node, lib_c_sanctuary, send_c_reward, [RoleId, Reward, ProduceType, Args]).

send_c_reward(RoleId, Reward, ProduceType, Args) ->
    lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, ?MODULE, send_reward_helper, [Reward, ProduceType, Args]).

send_reward_helper(Player, Reward, ProduceType, Args) ->
    #player_status{id = RoleId,
            server_id = ServerId, server_num = ServerNum,
            figure = #figure{name = RoleName}} = Player,
    LastPlayer = lib_goods_api:send_reward(Player, Reward, ProduceType, 0),
    if  %% 依据产出类型写日志
        ProduceType == kf_sanctuary_hurt_rank -> %% 依据伤害排名计算的勋章奖励
            [Scene, MonId] = Args,
            [{_,_,AMedal}|_] = Reward,
            lib_achievement_api:async_event(RoleId, lib_achievement_api, sanctuary_score_event, AMedal),
            lib_log_api:log_kf_san_medal(ServerId, ServerNum, RoleId, RoleName, Scene, MonId, Reward);
        ProduceType == kf_sanctuary_con_bl -> %% 建筑归属奖励
            [Santype, Scene, Contype, BlCamp] = Args,
            lib_log_api:log_kf_san_construction_reward(Santype, Scene, Contype, BlCamp, ServerId, 
                    ServerNum, RoleId, RoleName, Reward);
        true ->
            skip
    end,
    {ok, LastPlayer}.

%% -----------------------------------------------------------------
%% 对数据库的积分状态数据处理，确保与配置保持一致
%% -----------------------------------------------------------------
transform_stage_state(ScoreStage) ->
    All = data_cluster_sanctuary:get_all_score_cfg(),
    Fun = fun({Key, Value}, Acc) ->
        case lists:member(Key, All) of
            true ->
                case data_cluster_sanctuary:get_id_by_score(Key) of
                    [Id] ->
                        [{Id, Value}|Acc];
                    _ ->
                        Acc
                end;
            _ ->
                [{Key, Value}|Acc]
        end
    end,
    lists:foldl(Fun, [], ScoreStage).

%% -----------------------------------------------------------------
%% 处理积分状态数据发送客户端使用
%% -----------------------------------------------------------------
transform_stage_state_for_client(ScoreStage) ->
    All = data_cluster_sanctuary:get_all_score_cfg(),
    Fun = fun({Key, Value}, Acc) ->
        case lists:member(Key, All) of
            true ->
                [{Key, Value}|Acc];
            _ ->
                case data_cluster_sanctuary:get_score_by_id(Key) of
                    [Score] ->
                        [{Score, Value}|Acc];
                    _ ->
                        Acc
                end
        end
    end,
    lists:foldl(Fun, [], ScoreStage).

%% -----------------------------------------------------------------
%% 计算阶段奖励状态
%% -----------------------------------------------------------------
calc_role_score_reward(Score, ScoreStage, Paied) ->
    All = data_cluster_sanctuary:get_all_score_cfg(),
    case data_cluster_sanctuary:get_san_value(unlock_score) of
        ScoreLimit when is_integer(ScoreLimit) -> skip;
        _ -> ScoreLimit = 0
    end,
    Fun = fun(TemScore, Acc) ->
        case data_cluster_sanctuary:get_id_by_score(TemScore) of
            [Id] ->
                case lists:keyfind(Id, 1, ScoreStage) of
                    {Id, State} -> [{Id, State}|Acc];
                    _ -> 
                        if
                            Paied == 1 andalso Score >= TemScore -> %% 付费解锁后续奖励计算
                                [{Id, ?HAS_ACHIEVE}|Acc];
                            Score >= TemScore andalso TemScore =< ScoreLimit -> %% 未付费的之前的积分阶段状态计算
                                [{Id, ?HAS_ACHIEVE}|Acc];
                            true ->
                                Acc
                        end
                end;
            _ ->
                Acc
        end
    end,
    lists:foldl(Fun, [], All).

%% -----------------------------------------------------------------
%% 登陆时计算是否需要清理怒气值
%% -----------------------------------------------------------------
calc_login_clear_anger(Logtime, LastLogtime, ClearTime) ->
    IsSameDay = utime:is_same_day(Logtime, LastLogtime),
    case data_cluster_sanctuary:get_san_value(clear_role_anger_time) of
        [{H,M}] -> skip;
        _ -> H = 16, M = 0
    end,
    if
        IsSameDay == true ->
            {Date,{_,_,_}} = utime:unixtime_to_localtime(Logtime),
            Four_16 = utime:unixtime({Date, {H, M, 0}}),
            if
                LastLogtime < Four_16 andalso Logtime >= Four_16 andalso ClearTime < Four_16 -> %% 每天下午16点清理怒气值
                    true;
                true ->
                    false
            end;
        true ->
            {Date,{_,_,_}} = utime:unixtime_to_localtime(Logtime-86400),
            Four_16 = utime:unixtime({Date, {H, M, 0}}),
            TodayFour_16 = Four_16 + 86400,
            if
                LastLogtime < Four_16 andalso Logtime >= Four_16 andalso ClearTime < Four_16 -> %% 上次在前一天16：00前离线，前一天16：00之后登陆
                    true;
                LastLogtime < TodayFour_16 andalso Logtime >= TodayFour_16 andalso ClearTime < TodayFour_16 -> %% 当天16：00前离线，当天16：00之后登陆
                    true;
                true ->
                    false
            end
    end.

%% -----------------------------------------------------------------
%% 登陆时计算是否需要清理积分
%% -----------------------------------------------------------------
calc_login_clear_score(IsWeekClear) ->
    if
        IsWeekClear > 0 ->
            false;
        true ->
            true
    end.
    
    
%% -----------------------------------------------------------------
%% 计算活动时间
%% -----------------------------------------------------------------
calc_act_opentime(NowDate) ->
    List = data_cluster_sanctuary:get_san_value(open_time),
    case List of
        [{open,{Hour,Minute}},{continue, {SH,SM}}] ->
            BeginTime = NowDate + Hour*3600 + Minute*60,
            EndTime = BeginTime + SH*3600 + SM*60;
        _->
            BeginTime = 0,EndTime = 0
    end,
    {BeginTime, EndTime}.

%% -----------------------------------------------------------------
%% 登出
%% -----------------------------------------------------------------
logout(Player) ->
    #player_status{id = RoleId, scene = Scene, server_id = ServerId} = Player,
    case data_scene:get(Scene) of
        #ets_scene{type = ?SCENE_TYPE_KF_SANCTUARY} ->
            mod_c_sanctuary:exit(ServerId, RoleId, Scene);
        _ ->
            skip
    end,
    Player.

%% -----------------------------------------------------------------
%% 玩家延时登出
%% -----------------------------------------------------------------
delay_stop(Player) -> 
    #player_status{scene = Scene, battle_attr = BA, kf_sanctuary_info = KfSanInfo} = Player,
    #battle_attr{hp = Hp} = BA,
    case data_scene:get(Scene) of
        #ets_scene{type = ?SCENE_TYPE_KF_SANCTUARY} ->
            if
                Hp =< 0 -> %% 血量小于0，计算复活等待时间，之后定时将玩家复活
                    NowTime = utime:unixtime(),
                    #kf_sanctuary_info{die_time_list = DieList, die_time = DieTime,reborn_ref = Ref} = KfSanInfo,
                    util:cancel_timer(Ref),
                    %% 复活为尸体的等待时间（将玩家从死亡点搬运到复活点）
                    case data_cluster_sanctuary:get_san_value(revive_point_gost) of 
                        TimeCfg2 when is_integer(TimeCfg2) andalso TimeCfg2 > 0 -> TimeCfg2;
                        _ -> TimeCfg2 = 20
                    end,
                    % case data_cluster_sanctuary:get_san_value(auto_revive_after_limit) of 
                    %     TimeCfg when is_integer(TimeCfg) andalso TimeCfg > 0 -> TimeCfg;
                    %     _ -> TimeCfg = 15
                    % end,
                    %% 计算死亡次数
                    DieTimes = erlang:length(DieList),
                    {RebornTime, _MinTimes} =lib_c_sanctuary:count_die_wait_time(DieTimes, DieTime),
                    ReviveTime = max(0, RebornTime - NowTime),
                    GostTime = max(0, DieTime + TimeCfg2 - NowTime),
                    % ?MYLOG("xlh_reborn","ReviveTime:~p,GostTime:~p~n",[ReviveTime,GostTime]),
                    NewRef = util:send_after([], min(ReviveTime, GostTime) * 1000,self(), 
                            {'mod', lib_c_sanctuary, player_reborn, []}),
                    NewPlayer = Player#player_status{kf_sanctuary_info = KfSanInfo#kf_sanctuary_info{reborn_ref = NewRef}};
                true ->
                    NewPlayer = Player
            end;
        _ ->
            NewPlayer = Player
    end,
    NewPlayer.

%% -----------------------------------------------------------------
%% 玩家复活
%% -----------------------------------------------------------------
player_reborn(Player) ->
    #player_status{scene = Scene, battle_attr = BA, kf_sanctuary_info = KfSanInfo} = Player,
    #battle_attr{hp = Hp} = BA,
    case data_scene:get(Scene) of
        #ets_scene{type = ?SCENE_TYPE_KF_SANCTUARY, x = X, y = Y} -> %% 跨服圣域场景才做处理
            if
                Hp =< 0 ->
                    NowTime = utime:unixtime(),
                    #kf_sanctuary_info{die_time_list = DieList, die_time = DieTime,reborn_ref = Ref} = KfSanInfo,
                    util:cancel_timer(Ref),
                    % case data_cluster_sanctuary:get_san_value(auto_revive_after_limit) of 
                    %     TimeCfg when is_integer(TimeCfg) andalso TimeCfg > 0 -> TimeCfg;
                    %     _ -> TimeCfg = 15
                    % end,
                    DieTimes = erlang:length(DieList),
                    {RebornTime, _MinTimes} =lib_c_sanctuary:count_die_wait_time(DieTimes, DieTime),
                    Time = max(RebornTime - NowTime, 0),
                    if
                        Time > 0 -> %% 复活时间未到，设为幽灵状态
                            NewRef = util:send_after([], max(Time * 1000, 500), self(), %%下一次复活
                                {'mod', lib_c_sanctuary, player_reborn, []}),
                            Player1 = lib_scene:change_relogin_scene(Player#player_status{x = X, y = Y}, [{ghost, 1}]);
                        true -> %% 复活
                            NewRef = undefined,
                            Player1 = lib_scene:change_relogin_scene(Player#player_status{x = X, y = Y}, 
                                    [{change_scene_hp_lim, 100}, {ghost, 0}])
                    end,
                    % ?MYLOG("xlh_reborn","X:~p,Y:~p~n",[X,Y]),
                    NewPlayer = Player1#player_status{kf_sanctuary_info = KfSanInfo#kf_sanctuary_info{reborn_ref = NewRef}};
                true ->
                    NewPlayer = Player
            end;
        _ ->
            NewPlayer = Player
    end,
    NewPlayer.

%% -----------------------------------------------------------------
%% 玩家重连
%% -----------------------------------------------------------------
re_login(Player) ->
    #player_status{server_id = ServerId, id = RoleId, scene = Scene, battle_attr = BA, kf_sanctuary_info = KfSanInfo} = Player,
    #battle_attr{hp = Hp} = BA,
    case data_scene:get(Scene) of
        #ets_scene{type = ?SCENE_TYPE_KF_SANCTUARY} ->
            if
                Hp =< 0 ->
                    #kf_sanctuary_info{die_time_list = DieList, die_time = DieTime, buff_end = BuffEndTime, reborn_ref = Ref} = KfSanInfo,
                    util:cancel_timer(Ref),
                    % NewPlayer = lib_scene:change_relogin_scene(Player, []),
                    {Sign, KillerName, KillId} = get_last_kill_msg(Player),
                    % lib_server_send:send_to_uid(RoleId, pt_200, 20013, [Sign, KillerName, 0, 0, 0, 0, KillId]),
                    case data_cluster_sanctuary:get_san_value(revive_point_gost) of
                        TimeCfg2 when is_integer(TimeCfg2) andalso TimeCfg2 > 0 -> TimeCfg2;
                        _ -> TimeCfg2 = 20
                    end,
                    DieTimes = erlang:length(DieList),
                    {RebornTime, MinTimes} =lib_c_sanctuary:count_die_wait_time(DieTimes, DieTime),
                    if
                        DieTimes > MinTimes ->
                            PointTime = DieTime + TimeCfg2;
                        true ->
                            PointTime = 0
                            % lib_server_send:send_to_uid(RoleId, pt_284, 28415, [DieTimes, RebornTime, BuffEndTime, PointTime])
                    end,
                    % NewPlayer = lib_scene:change_relogin_scene(Player, []),
                    Args = [DieTimes, RebornTime, BuffEndTime, PointTime],
                    Args2 = [Sign, KillerName, 0, 0, 0, 0, KillId],
                    mod_c_sanctuary:reconect(ServerId, RoleId, Scene, {Args, Args2}),
                    NewPlayer = Player;
                true ->
                    mod_c_sanctuary:reconect(ServerId, RoleId, Scene, {[], []}),
                    NewPlayer = Player
            end,
            {ok, NewPlayer#player_status{kf_sanctuary_info = KfSanInfo#kf_sanctuary_info{reborn_ref = undefined}}};     
        _ ->
            {next, Player}
    end.
     
%% -----------------------------------------------------------------
%% 复活消耗
%% -----------------------------------------------------------------
get_revive_cost() ->
    case data_cluster_sanctuary:get_san_value(revive_cost) of
        Cost when is_list(Cost) -> Cost;
        _ -> []
    end.

%% -----------------------------------------------------------------
%% 玩家死亡事件，计算复活buff
%% -----------------------------------------------------------------
handle_event(Player, #event_callback{type_id = ?EVENT_PLAYER_DIE, data = _Data}) when is_record(Player, player_status) ->
    #player_status{id = DieId, scene = SceneId, kf_sanctuary_info = KfsanRole}=Player,
    #kf_sanctuary_info{die_time_list = DieList, die_time = _T, buff_end = _B} = KfsanRole,
    % #{attersign := AtterSign, atter := Atter, hit := _HitList} = Data,
    % #battle_return_atter{real_id = AtterId, real_name = AtterName, guild_id = AtterGuildId} = Atter,
    NowTime = utime:unixtime(),
    case data_scene:get(SceneId) of
        #ets_scene{type = Type} when Type == ?SCENE_TYPE_KF_SANCTUARY ->
            %% 玩家每死亡一次的buff持续时间
            case data_cluster_sanctuary:get_san_value(player_die_times) of
                TimeCfg when is_integer(TimeCfg) andalso TimeCfg > 0 -> TimeCfg;
                _ -> TimeCfg = 300
            end,
            %% 死亡后多久复活成幽灵
            case data_cluster_sanctuary:get_san_value(revive_point_gost) of
                TimeCfg2 when is_integer(TimeCfg2) andalso TimeCfg2 > 0 -> TimeCfg2;
                _ -> TimeCfg2 = 20
            end,
            NewList = get_real_die_time_list_2(DieList, TimeCfg, NowTime),
            DieTimes = erlang:length([NowTime|NewList]),
            {RebornTime, MinTimes} = count_die_wait_time(DieTimes, NowTime),
            if
                DieTimes > MinTimes -> %% 通知客户端下次复活时间及其他相关信息
                    lib_server_send:send_to_uid(DieId, pt_284, 28415, [DieTimes, RebornTime, NowTime + TimeCfg, NowTime + TimeCfg2]);
                true ->
                    lib_server_send:send_to_uid(DieId, pt_284, 28415, [DieTimes, RebornTime, NowTime + TimeCfg, 0])
            end,
            %% 更新数据库及内存
            Newkfrole = KfsanRole#kf_sanctuary_info{die_time_list = [NowTime|NewList], 
                    die_time = NowTime, buff_end = NowTime + TimeCfg},
            RealList = util:term_to_string([NowTime|NewList]),
            db:execute(io_lib:format(?SQL_REPLACE_ROLE_DIE, [DieId, NowTime, RealList])),
            {ok, Player#player_status{kf_sanctuary_info = Newkfrole}};
        _ -> 
            {ok, Player}
    end;
handle_event(Player, _EventCallback) ->
    {ok, Player}.

%% -----------------------------------------------------------------
%% 玩家生效死亡次数统计
%% -----------------------------------------------------------------
%%计算规则2：只要玩家在Time秒内死亡，数据不会清理，直到某次玩家死亡间隔超过5分钟
get_real_die_time_list_2([], _, _) -> [];
get_real_die_time_list_2(DieTimeList, Time, NowTime) when is_list(DieTimeList) ->
    MaxDieTime = lists:max(DieTimeList),
    MinTime = NowTime - Time,
    NewDieTimeList = if
        MaxDieTime >= MinTime -> %% 连续死亡
            DieTimeList;
        true ->  %% 死亡间隔超过Time秒，清理数据
            []
    end,
    NewDieTimeList;
get_real_die_time_list_2(_, _, _) -> [].

is_in_sanctuary_scene(Scene) ->
    case data_scene:get(Scene) of
        #ets_scene{type = Type} when Type == ?SCENE_TYPE_KF_SANCTUARY ->
            true;
        _ ->
            false
    end.

%% -----------------------------------------------------------------
%% 依据死亡次数以及当前时间计算死亡复活时间，最小buff生效死亡次数
%% -----------------------------------------------------------------
count_die_wait_time(DieTimes, NowTime) ->
    case data_cluster_sanctuary:get_san_value(die_wait_time) of
        [{min_times, MinTimes},{special, SpecialList},{extra, WaitTime}]  -> 
            RebornTime = if
                DieTimes =< MinTimes -> %% 没有达到最低死亡次数，不限制立即复活
                    NowTime;
                true ->
                    case lists:keyfind(DieTimes, 1, SpecialList) of
                        {DieTimes, WaitTime1} ->
                            NowTime + WaitTime1;
                        _ ->
                            NowTime + WaitTime
                    end
            end,
            RebornTime;
        _ -> MinTimes = 0, RebornTime = NowTime
    end,
    {RebornTime, MinTimes}.

%% -----------------------------------------------------------------
%% 上次击杀信息
%% -----------------------------------------------------------------
get_last_kill_msg(PS) ->
    #player_status{last_be_kill = Kill} = PS,
%%    ?MYLOG("cym", "Kill ~p ~n", [Kill]),
    case lists:keyfind(sign, 1, Kill) of
        {sign, Sign} ->
            ok;
        _ ->
            Sign = 1
    end,
    case lists:keyfind(name, 1, Kill) of
        {name, Name} ->
            ok;
        _ ->
            Name = utext:get(181) %%野怪
    end,
    case lists:keyfind(id, 1, Kill) of
        {id, AttId} ->
            ok;
        _ ->
            AttId = 0
    end,
    {Sign, Name, AttId}.

%% -----------------------------------------------------------------
%% 通知玩家踢出场景时间
%% -----------------------------------------------------------------
notify_scene_user(RoleIds, OutTime) ->
    [lib_server_send:send_to_uid(RoleId, pt_284, 28417, [OutTime])|| RoleId <- RoleIds].

%% -----------------------------------------------------------------
%% 清理场景玩家
%% -----------------------------------------------------------------
clear_scene_user(RoleIds, _ServerId) ->
    clear_scene_user(RoleIds).

clear_scene_user(RoleIds) ->
    [lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, ?MODULE, clear_scene_user_helper, [])|| RoleId <- RoleIds].
clear_scene_user_helper(Player) ->
    #player_status{id = RoleId, server_id = ServerId, scene = Scene} = Player,
    % NewPlayer = lib_scene:change_scene(Player, 0, 0, 0, 0, 0, true, [{group, 0}, {change_scene_hp_lim, 100}, 
 %          {collect_checker, undefined}, {pk, {?PK_PEACE, true}}]),
    NewPlayer = lib_scene:change_default_scene(Player, [{group, 0}, {change_scene_hp_lim, 100}, 
        {collect_checker, undefined}, {pk, {?PK_PEACE, true}}]),
    mod_c_sanctuary:exit(ServerId, RoleId, Scene),
    {ok, NewPlayer}.

%% -----------------------------------------------------------------
%% 玩家重连通知客户端，保持协议顺序
%% -----------------------------------------------------------------
notify_re_login(#player_status{id = RoleId} = Player, Args, Args2) ->    
    NewPlayer = lib_scene:change_relogin_scene(Player, []),
    lib_server_send:send_to_uid(RoleId, pt_284, 28415, Args),
    lib_server_send:send_to_uid(RoleId, pt_200, 20013, Args2),
    {ok, NewPlayer}.

%% -----------------------------------------------------------------
%% @desc     清理场景玩家
%% @param    房间号（_CopyId）、场景id
%% @return   
%% @history  房间号有可能会变，修改为清理场景
%% ----------------------------------------------------------------- 
clear_scene_palyer(_CopyId, Scene) ->
    clear_scene_palyer(_CopyId, Scene, 0).

clear_scene_palyer(_CopyId, Scene, SerId) ->
    UserList = lib_scene_agent:get_scene_user(),
    Fun = fun
        (#ets_scene_user{server_id = ServerId, id = RoleId}, Acc) when SerId == 0 ->
            case lists:keyfind(ServerId, 1, Acc) of
                {_, RoleIdList} ->
                    lists:keystore(ServerId, 1, Acc, {ServerId, [RoleId|RoleIdList]});
                _ ->
                    lists:keystore(ServerId, 1, Acc, {ServerId, [RoleId]})
            end;
        (#ets_scene_user{server_id = ServerId, id = RoleId}, Acc) when SerId == ServerId ->
            case lists:keyfind(ServerId, 1, Acc) of
                {_, RoleIdList} ->
                    lists:keystore(ServerId, 1, Acc, {ServerId, [RoleId|RoleIdList]});
                _ ->
                    lists:keystore(ServerId, 1, Acc, {ServerId, [RoleId]})
            end;
        (_, Acc) -> Acc
    end,
    ServerUserList = lists:foldl(Fun, [], UserList),
    if
        _CopyId == gm ->
            ServerUserList =/= [] andalso mod_c_sanctuary:clear_user_mon_create(ServerUserList, Scene, gm);
        true ->
            ServerUserList =/= [] andalso mod_c_sanctuary:clear_user_mon_create(ServerUserList, Scene, _CopyId)
    end.


%% -----------------------------------------------------------------
%% 拍卖分红产出通知对应的服更行拍卖产出数据
%% -----------------------------------------------------------------
send_auction_info(ProduceType, AuctionBlserver, Produce, RoleIdList, StartTime, Source) ->
    mod_clusters_center:apply_cast(AuctionBlserver, mod_c_sanctuary_local, auction_info, [ProduceType, Produce, RoleIdList, StartTime, Source]).


%% 秘籍关闭活动
gm_clear_user(Mod, _SubMod) when Mod == ?MOD_C_SANCTUARY ->
    ServerId = config:get_server_id(),
    mod_c_sanctuary:gm_clear_user(ServerId);
gm_clear_user(_Mod, _SubMod) -> skip.

gm_close_c_sanctuary(Status) ->
    lib_gm_stop:gm_change_act(?MOD_C_SANCTUARY, 0, Status).