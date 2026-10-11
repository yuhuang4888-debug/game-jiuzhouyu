%%-----------------------------------------------------------------------------
%% @Module  :       mod_boss_first_blood_plus
%% @Author  :       cxd
%% @Created :       2020-04-25
%% @Description:    新版boss首杀
%%-----------------------------------------------------------------------------
-module(mod_boss_first_blood_plus).

-include("boss_first_blood_plus.hrl").
-include("custom_act.hrl").
-include("common.hrl").
-include("errcode.hrl").
-include("def_fun.hrl").
-include("figure.hrl").
-include("role.hrl").
-include("goods.hrl").
-include("scene.hrl").
-include("def_module.hrl").
-include("predefine.hrl").
-include("red_envelopes.hrl").
-include("server.hrl").

-behaviour(gen_server).

-export([start_link/0]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-export([
    red_point/4,
    act_info/4,
    act_info/5,
    boss_be_killed/4,
    receive_reward/4,
    boss_be_killed_for_partner_dun/4,
    reload_data/0,
    login_notice_role_receive_reward/4,
    pass_dungeon/4
]).

%% 红点
red_point(Type, SubType, RoleId, RoleInfoList) ->
    gen_server:cast(?MODULE, {'red_point', Type, SubType, RoleId, RoleInfoList}).

%% 获取活动数据
act_info(Type, SubType, RoleId, RoleMap) ->
    gen_server:cast(?MODULE, {'act_info', Type, SubType, RoleId, RoleMap}).

act_info(Type, SubType, RoleId, RoleMap, DunId) ->
    gen_server:cast(?MODULE, {'act_info', Type, SubType, RoleId, RoleMap, DunId}).

%% 获取奖励
receive_reward(Type, SubType, RoleId, BossId) ->
    gen_server:cast(?MODULE, {'receive_reward', Type, SubType, RoleId, BossId}).

%% boss被杀
boss_be_killed(Type, SubType, BossId, BLRoleList) when Type == ?CUSTOM_ACT_TYPE_BOSS_FIRST_BLOOD_PLUS andalso SubType == 1 ->
    gen_server:cast(?MODULE, {'boss_be_killed', Type, SubType, BossId, BLRoleList});
boss_be_killed(Type, SubType, BossId, BLRoleId) when Type == ?CUSTOM_ACT_TYPE_BOSS_FIRST_BLOOD_PLUS andalso SubType == 2 ->
    gen_server:cast(?MODULE, {'boss_be_killed', Type, SubType, BossId, BLRoleId});
boss_be_killed(Type, SubType, _BossId, _BLRoleId) ->
    ?ERR("no subtype:~p", [{Type, SubType}]),
    skip.

%% 登录弹窗领取奖励提示
login_notice_role_receive_reward(Type, SubType, RoleId, BossId) ->
    gen_server:cast(?MODULE, {'login_notice_role_receive_reward', Type, SubType, RoleId, BossId}).

%% -----------------------------------------------------------------
%% @desc     功能描述    伙伴副本首杀专用函数
%% @param    参数       Type 活动类型  SubType 活动子类型  DunId:副本id   RoleId:玩家id
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
boss_be_killed_for_partner_dun(Type, SubType, DunId, RoleId) ->
    gen_server:cast(?MODULE, {'boss_be_killed_for_partner_dun', Type, SubType, DunId, RoleId}).

%% 通关副本    
pass_dungeon(Type, SubType, DunId, RoleId) ->
    gen_server:cast(?MODULE, {'pass_dungeon', Type, SubType, DunId, RoleId}).

%% 重载数据
reload_data() ->
    gen_server:cast(?MODULE, {'reload_data'}).

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

init([]) ->
    %% ets，记录对应boss的击杀玩家列表
    ets:new(?ETS_FIRST_BLOOD, [set, named_table, public, {keypos, #ets_first_blood.key}, {read_concurrency, true}]),
    lib_boss_first_blood_plus:init_first_blood_ets(), 
    lib_boss_first_blood_plus:reload_data().

handle_cast(Msg, State) ->
    case catch do_handle_cast(Msg, State) of
        {ok, NewState} when is_record(NewState, boss_first_blood_plus) ->
            {noreply, NewState};
        {ok, stop, NewState} ->
            {stop, normal, NewState};
        Err ->
            ?ERR("handle_cast Msg:~p error:~p~n", [Msg, Err]),
            {noreply, State}
    end.

do_handle_cast({'act_info', Type, SubType, RoleId, _RoleMap}, State) when Type == ?CUSTOM_ACT_TYPE_DUN_FIRST_KILL -> %% 副本首杀
    #boss_first_blood_plus{boss_map = BossMap} = State,
    BossInfoList = maps:get({Type, SubType}, BossMap, []),
    ClientData = lib_boss_first_blood_plus:pack_act_info2(Type, SubType, RoleId, BossInfoList),    
    {ok, BinData} = pt_188:write(18801, ClientData),
    lib_server_send:send_to_uid(RoleId, BinData),
    {ok, State};

do_handle_cast({'act_info', Type, SubType, RoleId, RoleMap}, State) when Type == ?CUSTOM_ACT_TYPE_BOSS_FIRST_BLOOD_PLUS -> %% boss首杀
    #boss_first_blood_plus{boss_map = BossMap} = State,
    RoleInfoList = maps:get({Type, SubType}, RoleMap, []),
    BossInfoList = maps:get({Type, SubType}, BossMap, []),
    ClientData = lib_boss_first_blood_plus:pack_act_info(Type, SubType, RoleInfoList, BossInfoList),
    {ok, BinData} = pt_188:write(18801, ClientData),
    lib_server_send:send_to_uid(RoleId, BinData),
    {ok, State};

do_handle_cast({'act_info', Type, SubType, RoleId, RoleMap, DunId}, State) when Type == ?CUSTOM_ACT_TYPE_PASS_DUN -> 
    #boss_first_blood_plus{boss_map = BossMap} = State,
    RoleInfoList = maps:get({Type, SubType}, RoleMap, []),
    BossInfoList = maps:get({Type, SubType}, BossMap, []),
    ClientData = lib_boss_first_blood_plus:pack_act_info3(Type, SubType, RoleInfoList, BossInfoList, DunId),
    % ?MYLOG("cxd_pd2", "ClientData:~p", [ClientData]),
    {ok, BinData} = pt_188:write(18804, ClientData),
    lib_server_send:send_to_uid(RoleId, BinData),
    {ok, State};

do_handle_cast({'boss_be_killed_for_partner_dun', Type, SubType, DunId, KillerId}, State) ->
    #boss_first_blood_plus{boss_map = BossMap} = State,
    Cfg = data_first_blood_plus:get(Type, SubType,DunId),
    BossInfoList = maps:get({Type, SubType}, BossMap, []),
    BossInfo = lists:keyfind(DunId, #boss_info.object_id, BossInfoList),
    if
    %% 是否首杀boss,则只发协议
        is_record(BossInfo, boss_info) ->
            {ok, State};
        Cfg == [] ->
            {ok, State};
        true ->
            lib_boss_first_blood_plus:sql_replace_boss_first_blood_plus_boss(Type, SubType, DunId, KillerId, ?NOT_RECEIVE),
            %% 更新boss_map
            NewBossInfo = #boss_info{object_id = DunId, role_id = KillerId},
            NewBossInfoList = lists:keystore(DunId, #boss_info.object_id, BossInfoList, NewBossInfo),
            NewBossMap = maps:put({Type, SubType}, NewBossInfoList, BossMap),
            lib_log_api:log_boss_first_blood_plus_boss(Type, SubType, DunId, "", KillerId, ?WHOLE_FIRST_BLOOD),
            lib_boss_first_blood_plus:send_tv(Type, SubType, KillerId, DunId),
            lib_boss_first_blood_plus:broadcast_act_info(Type, SubType, NewBossInfoList),
            {ok, State#boss_first_blood_plus{boss_map = NewBossMap}}
    end;

do_handle_cast({'boss_be_killed', Type, SubType, BossId, BLRoleList}, State) when Type == ?CUSTOM_ACT_TYPE_BOSS_FIRST_BLOOD_PLUS andalso SubType == 1 ->
    %% 是否boss首杀来计算归属，是保持原来规则，不是直接cast所有的BLRolId
    #boss_first_blood_plus{boss_map = BossMap} = State,
    BossInfoList = maps:get({Type, SubType}, BossMap, []),
    BossInfo = lists:keyfind(BossId, #boss_info.object_id, BossInfoList),
    HasBeenFirstBlood = is_record(BossInfo, boss_info),
    %% 分离首杀玩家和非首杀玩家
    case lib_boss_first_blood_plus:cal_bl_role_id(BLRoleList, HasBeenFirstBlood) of
        {KillerId, BLRoleIdList} -> %% 首杀玩家和归属玩家
            F = fun() ->
                lib_boss_first_blood_plus:sql_replace_boss_first_blood_plus_boss(Type, SubType, BossId, KillerId, ?NOT_RECEIVE),
                lib_boss_first_blood_plus:sql_replace_boss_first_blood_plus_boss_merge(Type, SubType, BossId, KillerId, ?NOT_RECEIVE),
                ok
            end,
            case catch db:transaction(F) of
                ok ->
                    %% 更新boss_map            
                    NewBossInfo = #boss_info{object_id = BossId, role_id = KillerId},
                    NewBossInfoList = lists:keystore(BossId, #boss_info.object_id, BossInfoList, NewBossInfo),
                    NewBossMap = maps:put({Type, SubType}, NewBossInfoList, BossMap),
                    #base_first_blood_plus_boss{boss_scene_name = BossSceneName} = data_first_blood_plus:get(Type, SubType, BossId),
                    lib_log_api:log_boss_first_blood_plus_boss(Type, SubType, BossId, BossSceneName, KillerId, ?WHOLE_FIRST_BLOOD),
                    lib_boss_first_blood_plus:send_tv(Type, SubType, KillerId, BossId),
                    NewState = State#boss_first_blood_plus{boss_map = NewBossMap},
                    lib_player:apply_cast(KillerId, ?APPLY_CAST_SAVE, lib_boss_first_blood_plus, boss_be_killed_help, [Type, SubType, ?WHOLE_FIRST_BLOOD, BossId, NewBossInfoList]),
                    [lib_player:apply_cast(BLRoleId, ?APPLY_CAST_SAVE, lib_boss_first_blood_plus, boss_be_killed_help, [Type, SubType, ?NOT_WHOLE_FIRST_BLOOD, BossId, BossInfoList]) || BLRoleId <- BLRoleIdList];
                    % lib_boss_first_blood_plus:broadcast_act_info(Type, SubType, NewBossInfoList);
                _Err ->
                   NewState = State
            end;
        BLRoleIdList -> %% 非首杀玩家
            [lib_player:apply_cast(BLRoleId, ?APPLY_CAST_SAVE, lib_boss_first_blood_plus, boss_be_killed_help, [Type, SubType, ?NOT_WHOLE_FIRST_BLOOD, BossId, BossInfoList]) || BLRoleId <- BLRoleIdList],
            NewState = State
    end,
    {ok, NewState};

do_handle_cast({'boss_be_killed', Type, SubType, BossId, KillerId}, State) when Type == ?CUSTOM_ACT_TYPE_BOSS_FIRST_BLOOD_PLUS andalso SubType == 2 ->
    #boss_first_blood_plus{boss_map = BossMap} = State,
    BossInfoList = maps:get({Type, SubType}, BossMap, []),
    BossInfo = lists:keyfind(BossId, #boss_info.object_id, BossInfoList),
    HasBeenFirstBlood = is_record(BossInfo, boss_info),
    case HasBeenFirstBlood of
        true -> %% 非首杀
            NewState = State;
        false -> %% 首杀
            %% 插入数据库，进程内存和ets
            F = fun() ->
                lib_boss_first_blood_plus:sql_replace_boss_first_blood_plus_boss(Type, SubType, BossId, KillerId, ?NOT_RECEIVE),
                lib_boss_first_blood_plus:sql_replace_boss_first_blood_plus_boss_merge(Type, SubType, BossId, KillerId, ?NOT_RECEIVE),
                lib_boss_first_blood_plus:sql_replace_boss_first_blood_plus_role(Type, SubType, KillerId, BossId, ?NOT_RECEIVE, ?NOT_RECEIVE),
                ok
            end,
            case catch db:transaction(F) of
                ok ->
                    %% 更新boss_map            
                    NewBossInfo = #boss_info{object_id = BossId, role_id = KillerId},
                    NewBossInfoList = lists:keystore(BossId, #boss_info.object_id, BossInfoList, NewBossInfo),
                    NewBossMap = maps:put({Type, SubType}, NewBossInfoList, BossMap),
                    #base_first_blood_plus_boss{boss_scene_name = BossSceneName} = data_first_blood_plus:get(Type, SubType, BossId),
                    lib_log_api:log_boss_first_blood_plus_boss(Type, SubType, BossId, BossSceneName, KillerId, ?WHOLE_FIRST_BLOOD),
                    lib_boss_first_blood_plus:send_tv(Type, SubType, KillerId, BossId),
                    NewState = State#boss_first_blood_plus{boss_map = NewBossMap},
                    %% 插入ets
                    NewEtsFirstBlood = case ets:lookup(?ETS_FIRST_BLOOD, {Type, SubType, BossId}) of
                        [EtsFirstBlood|_] when is_record(EtsFirstBlood, ets_first_blood) ->
                            EtsFirstBlood#ets_first_blood{role_ids = [KillerId | EtsFirstBlood#ets_first_blood.role_ids]};
                        _ ->
                            #ets_first_blood{key = {Type, SubType, BossId}, role_ids = [KillerId]}
                    end,
                    ets:insert(?ETS_FIRST_BLOOD, NewEtsFirstBlood),
                    %% 首杀刷新在线玩家首杀界面
                    lib_boss_first_blood_plus:broadcast_act_info(Type, SubType, NewBossInfoList),
                    %% 弹窗告诉玩家可以领取奖励
                    OnlineList = ets:tab2list(?ETS_ONLINE),
                    [lib_player:apply_cast(PlayerId, ?APPLY_CAST_STATUS, lib_boss_first_blood_plus, notice_role_receive_reward_af_kill_boss, [Type, SubType]) || #ets_online{id = PlayerId} <- OnlineList];
                _Err ->
                   NewState = State
            end
    end,
    {ok, NewState};

do_handle_cast({'pass_dungeon', Type, SubType, DunId, RoleId}, State) ->
    #boss_first_blood_plus{boss_map = BossMap} = State,
    BossInfoList = maps:get({Type, SubType}, BossMap, []),
    BossInfo = lists:keyfind(DunId, #boss_info.object_id, BossInfoList),
    PassTime = utime:unixtime(),
    IntervalTime = lib_boss_first_blood_plus:get_interval_time(Type, SubType, PassTime),
    case is_record(BossInfo, boss_info) of 
        true -> %% 非首通
            #boss_info{data = Data} = BossInfo,
            {?PASS_RANK, RankRoleList} = ulists:keyfind(?PASS_RANK, 1, Data, {?PASS_RANK, []}),
            %% 合服容错，防止php处理数据出错
            NewRankRoleList = ?IF(is_list(RankRoleList), RankRoleList, []),
            RankRoleListLength = length(NewRankRoleList),
            PassRankNum = lib_boss_first_blood_plus:get_config_value(pass_rank_num),
            case RankRoleListLength >= PassRankNum of 
                true -> %% 已经记录了指定数量的排行榜数据
                    F = none,
                    NewBossInfo = {};
                false -> %% 记录排行榜数据
                    PassRuneDunRole = lib_boss_first_blood_plus:make_record(pass_dun_role, [RoleId, RankRoleListLength + 1, PassTime, IntervalTime]),
                    NewData = lib_boss_first_blood_plus:update_data(boss_info_data, [RoleId, NewRankRoleList, PassRuneDunRole, Data]),
                    NewBossInfo = BossInfo#boss_info{data = NewData},
                    F = fun() ->
                        %% 记录排行榜记录
                        lib_boss_first_blood_plus:sql_replace_boss_first_blood_plus_data(Type, SubType, DunId, NewData),
                        ok
                    end
            end,
            IsFirstPass = false;
        false -> %% 首通            
            PassRuneDunRole = lib_boss_first_blood_plus:make_record(pass_dun_role, [RoleId, 1, PassTime, IntervalTime]),
            Data = [{?PASS_RANK, [PassRuneDunRole]}],
            NewBossInfo = lib_boss_first_blood_plus:make_record(boss_info, [DunId, RoleId, ?NOT_RECEIVE, Data]),
            F = fun() ->
                %% 记录首通玩家记录
                lib_boss_first_blood_plus:sql_replace_boss_first_blood_plus_boss(Type, SubType, DunId, RoleId, ?NOT_RECEIVE),
                lib_boss_first_blood_plus:sql_replace_boss_first_blood_plus_boss_merge(Type, SubType, DunId, RoleId, ?NOT_RECEIVE),
                %% 记录排行榜记录
                lib_boss_first_blood_plus:sql_replace_boss_first_blood_plus_data(Type, SubType, DunId, Data),
                ok
            end,
            IsFirstPass = true
    end,
    case F =/= none of 
        true ->
            case catch db:transaction(F) of 
                ok ->
                    NewBossMap = lib_boss_first_blood_plus:update_data(boss_map, [Type, SubType, DunId, NewBossInfo, BossInfoList, BossMap]),
                    NewState = State#boss_first_blood_plus{boss_map = NewBossMap},
                    if
                        IsFirstPass ->
                            %% 发送传闻
                            lib_boss_first_blood_plus:send_tv(Type, SubType, RoleId, DunId);
                        true ->
                            skip
                    end,
                    %% 刷新界面
                    lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, lib_boss_first_blood_plus, refresh_client, [Type, SubType, DunId]);
                _Err ->
                    NewState = State
            end;
        false -> 
            NewState = State
    end,
    {ok, NewState};

do_handle_cast({'receive_reward', Type, SubType, RoleId, DunId}, State) when Type == ?CUSTOM_ACT_TYPE_DUN_FIRST_KILL andalso SubType == 1 ->
    
    #boss_first_blood_plus{boss_map = BossMap} = State,
    BossInfoList = maps:get({Type, SubType}, BossMap, []),
    #base_first_blood_plus_boss{whole_first_blood_reward = WholeReward} = data_first_blood_plus:get(Type, SubType, DunId),
    case lists:keyfind(DunId, #boss_info.object_id, BossInfoList) of
        #boss_info{role_id = RoleId, reward_state = ?NOT_RECEIVE} = BossInfo ->
            Produce = #produce{title = utext:get(18800001), content = utext:get(18800002), type = first_blood_plus_dun, reward = WholeReward, show_tips = 1},
            lib_goods_api:send_reward_by_id(Produce, RoleId),
            lib_log_api:log_boss_first_blood_plus_reward(Type, SubType, RoleId, DunId, util:term_to_bitstring(WholeReward)),
            Code = ?SUCCESS,
            {ok, BinData} = pt_188:write(18802, [Type, SubType, Code, DunId, WholeReward]),
            lib_server_send:send_to_uid(RoleId, BinData),
            BossInfoNew = BossInfo#boss_info{reward_state = ?IS_RECEIVE},
            lib_boss_first_blood_plus:sql_replace_boss_first_blood_plus_boss(Type, SubType, DunId, RoleId, ?IS_RECEIVE),
            BossInfoListNew = lists:keystore(DunId, #boss_info.object_id, BossInfoList, BossInfoNew),
            BossMapNew = maps:put({Type, SubType}, BossInfoListNew, BossMap),
            {ok, State#boss_first_blood_plus{boss_map = BossMapNew}};
        _ ->
            Code = ?FAIL,
            {ok, BinData} = pt_188:write(18802, [Type, SubType, Code, DunId, []]),
            lib_server_send:send_to_uid(RoleId, BinData),
            {ok, State}
    end;

do_handle_cast({'receive_reward', Type, SubType, RoleId, DunId}, State) when Type == ?CUSTOM_ACT_TYPE_PASS_DUN ->
    #boss_first_blood_plus{boss_map = BossMap} = State,
    BossInfoList = maps:get({Type, SubType}, BossMap, []),
    BossInfo = lists:keyfind(DunId, #boss_info.object_id, BossInfoList),
    case is_record(BossInfo, boss_info) of 
        true ->
            lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_boss_first_blood_plus, receive_reward, [Type, SubType, DunId, BossInfoList]);
        false ->
            skip
    end,
    {ok, State};

do_handle_cast({'receive_reward', Type, SubType, RoleId, BossId}, State) ->  
    #boss_first_blood_plus{boss_map = BossMap} = State,
    BossInfoList = maps:get({Type, SubType}, BossMap, []),
    lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_boss_first_blood_plus, receive_reward, [Type, SubType, BossId, BossInfoList]),
    {ok, State};


do_handle_cast({'login_notice_role_receive_reward', Type, SubType, RoleId, BossId}, State) ->  
    #boss_first_blood_plus{boss_map = BossMap} = State,
    BossInfoList = maps:get({Type, SubType}, BossMap, []),
    case lists:keyfind(BossId, #boss_info.object_id, BossInfoList) of
        #boss_info{role_id = FirstBloodRoleId} when FirstBloodRoleId =/= 0 ->
            lib_boss_first_blood_plus:notice_role_receive_reward(Type, SubType, RoleId, FirstBloodRoleId, BossId);
        _ -> skip
    end,
    {ok, State};

do_handle_cast({'red_point', Type, SubType, RoleId, RoleInfoList}, State) ->
    #boss_first_blood_plus{boss_map = BossMap} = State,
    BossInfoList = maps:get({Type, SubType}, BossMap, []),
    DunIds = data_first_blood_plus:get_object_ids(Type, SubType),
    F = fun(DunId, FunRedPointList) ->
        BossInfo = lists:keyfind(DunId, #boss_info.object_id, BossInfoList),
        RoleInfo = lists:keyfind(DunId, #role_info.boss_id, RoleInfoList),
        %% 只有当首通了且未领取才显示红点
        case is_record(BossInfo, boss_info) of 
            true when is_record(RoleInfo, role_info)->
                #role_info{reward_state = RewardState} = RoleInfo,
                case RewardState of 
                    ?NOT_RECEIVE -> [{DunId, 1} | FunRedPointList];
                    ?IS_RECEIVE -> [{DunId, 2} | FunRedPointList];
                    _ -> FunRedPointList
                end;
            true -> [{DunId, 1} | FunRedPointList];
            _ -> FunRedPointList
        end
    end,
    RedPointList = lists:foldl(F, [], DunIds),
    % ?MYLOG("cxd_pd2", "RedPointList:~p", [RedPointList]),
    {ok, BinData} = pt_188:write(18805, [Type, SubType, RedPointList]),
    lib_server_send:send_to_uid(RoleId, BinData),
    {ok, State};

do_handle_cast({'reload_data'}, _State) ->
    lib_boss_first_blood_plus:reload_data();
    
do_handle_cast(_Msg, State) -> {ok, State}.

handle_info(Info, State) ->
    case catch do_handle_info(Info, State) of
        {ok, NewState} when is_record(NewState, boss_first_blood_plus) ->
            {noreply, NewState};
        Err ->
            ?ERR("handle_info Info:~p error:~p~n", [Info, Err]),
            {noreply, State}
    end.

do_handle_info(_Info, State) -> {ok, State}.

handle_call(Request, _From, State) ->
    case catch do_handle_call(Request, State) of
        {ok, Reply, NewState} ->
            {reply, Reply, NewState};
        Err ->
            ?ERR("handle_call Request:~p error:~p~n", [Request, Err]),
            {noreply, State}
    end.

do_handle_call(_Request, State) -> {ok, ok, State}.

terminate(_Reason, _State) ->
    ?ERR("~p is terminate:~p", [?MODULE, _Reason]),
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

