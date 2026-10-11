%%-----------------------------------------------------------------------------
%% @Module  :       lib_boss_first_blood_plus
%% @Author  :       cxd
%% @Created :       2020-04-25
%% @Description:  

% 类似首杀的功能都可以考虑使用
% 支持后续新首杀玩法的扩展，新首杀活动配在定制活动

% 目前已有首杀玩法：
% 1、第一个首杀玩家出现，全服玩家都会得到一份奖励。另外首杀玩家多一分首杀奖励。 
%   例子：boss首杀和副本首通(符文本首通)
% 2、第一个首杀玩家出现，只有首杀玩家可以获得那份奖励，别的玩家不会有。例子: 伙伴副本首通

% 数据结构(record)说明：
% 1、boss_first_blood_plus，首杀进程公共数据
% 2、boss_info，对应{Type, SubType}的首杀数据
% 3、role_info，玩家身上数据

% 合服说明:
% 1、boss_first_blood_plus_boss 表
%   (1) 支持多种规则处理，要与php商量好，在后台合服配置里说明好
%   (2) 目前已有的规则(根据类型和子类型区分)：
%       a.合服role_id置为0(boss首杀、副本首通)
%       b.保留主服(伙伴副本首通)

% 2、boss_first_blood_plus_data 表
%   (1) 主要是对data字段的处理，支持多种规则处理，要与php商量好，在后台合服配置里说明好
%   (2) 目前已有的规则：
%       a.?PASS_RANK，根据来 pass_dun_role 里的 interval_time 截取
%         前N(可以由类型和子类型来区分)个数据
%   (3) 友情提示：data字段是由php处理的，所以在编码时要对data数据做好容错，防止报错

%%-----------------------------------------------------------------------------
-module(lib_boss_first_blood_plus).

-include("custom_act.hrl").
-include("predefine.hrl").
-include("common.hrl").
-include("errcode.hrl").
-include("def_module.hrl").
-include("red_envelopes.hrl").
-include("boss_first_blood_plus.hrl").
-include("figure.hrl").
-include("role.hrl").
-include("server.hrl").
-include("def_fun.hrl").
-include("rec_dress_up.hrl").
-include("scene.hrl").
-include("goods.hrl").
-include("def_event.hrl").
-include("rec_event.hrl").
-include("dungeon.hrl").

-compile(export_all).

%% 到限制等级刷新弹窗
handle_event(Player, #event_callback{type_id = ?EVENT_LV_UP}) when is_record(Player, player_status) ->
    #player_status{id = RoleId, role_boss_first_blood = RoleMap, figure = #figure{lv = RoleLv}} = Player,
    Type = ?CUSTOM_ACT_TYPE_BOSS_FIRST_BLOOD_PLUS,
    SubType = 1,
    RoleLvLimit = get_act_role_lv_limit(Type, SubType),
    case RoleLv == RoleLvLimit of 
        true ->
            RoleInfoList = maps:get({Type, SubType}, RoleMap, []),
            lib_boss_first_blood_plus:login_notice(Type, SubType, RoleId, RoleInfoList),
            mod_boss_first_blood_plus:act_info(Type, SubType, RoleId, RoleMap);
        false ->
            skip
    end,
    {ok, Player};
handle_event(Player, _EventCallback) ->
    {ok, Player}.

%% 完成任务触发
fin_task(Ps, TaskId) ->
    TriggerActList = 
        [
            {?CUSTOM_ACT_TYPE_PASS_DUN, 1}
        ],
    [do_fin_task(Ps, TaskId, Type, SubType) || {Type, SubType} <- TriggerActList].

do_fin_task(Ps, TaskId, Type, SubType) when Type == ?CUSTOM_ACT_TYPE_PASS_DUN ->
    case get_act_task_limit(Type, SubType) of 
        TaskId ->
            pp_boss_first_blood_plus:handle(18805, Ps, [Type, SubType]);
        _ ->
            skip
    end;
do_fin_task(_Ps, _TaskId, _Type, _SubType) ->
    skip.

%% 重载数据
reload_data() -> 
    BossInfoMap = init_boss_info_map(),
    %% 加载boss_info的data字段
    NewBossInfoMap = init_boss_info_map_data(BossInfoMap),
    %% 合服后处理
    merge_handle(NewBossInfoMap),
    {ok, #boss_first_blood_plus{boss_map = NewBossInfoMap}}.

%% 登录
login(Ps) ->
    #player_status{id = RoleId} = Ps,
    RoleInfoMap = init_role_info_map(RoleId),
    Ps#player_status{role_boss_first_blood = RoleInfoMap}.

%% 初始化首杀ets
init_first_blood_ets() ->
    AllRoleRecordSql = io_lib:format(<<"select type, sub_type, role_id, boss_id, reward_state from boss_first_blood_plus_role">>, []),
    AllRoleRecord = db:get_all(AllRoleRecordSql),
    F = fun(RoleInfoData, EtsMap) ->
        [Type, SubType, RoleId, BossId, RewardState] = RoleInfoData,
        case RewardState =/= ?CAN_NOT_RECEIVE of 
            true ->
                EtsFirstBlood = maps:get({Type, SubType, BossId}, EtsMap, #ets_first_blood{key = {Type, SubType, BossId}}),
                NewEtsFirstBlood = EtsFirstBlood#ets_first_blood{role_ids = [RoleId | EtsFirstBlood#ets_first_blood.role_ids]},
                maps:put({Type, SubType, BossId}, NewEtsFirstBlood, EtsMap);
            _ ->
                EtsMap
        end
    end,
    EtsRoleMap = lists:foldl(F, #{}, AllRoleRecord),
    [ets:insert(?ETS_FIRST_BLOOD, EtsFirstBlood) || {_, EtsFirstBlood} <- maps:to_list(EtsRoleMap)].

%% 初始化玩家数据
init_role_info_map(RoleId) ->
    RoleListData = sql_select_role_by_role_id(RoleId),
    F = fun(RoleInfoData, RoleMap) ->
        [Type, SubType, _RoleId, BossId, RewardState, SharedState] = RoleInfoData,
        RoleInfoList = maps:get({Type, SubType}, RoleMap, []),
        RoleInfo = make_record(role_info, [BossId, RewardState, SharedState]),
        NewRoleInfoList = lists:keystore(BossId, #role_info.boss_id, RoleInfoList, RoleInfo),
        maps:put({Type, SubType}, NewRoleInfoList, RoleMap)
    end,
    lists:foldl(F, #{}, RoleListData).

%% 初始化boss数据
init_boss_info_map() ->
    BossListData = sql_select_boss(),
    F = fun(BossInfoData, BossMap) ->
        [Type, SubType, ObjectId, RoleId, RewardState] = BossInfoData,
        BossInfoList = maps:get({Type, SubType}, BossMap, []),
        BossInfo = make_record(boss_info, [ObjectId, RoleId, RewardState, []]),
        NewBossInfoList = lists:keystore(ObjectId, #boss_info.object_id, BossInfoList, BossInfo),
        maps:put({Type, SubType}, NewBossInfoList, BossMap)
    end,
    lists:foldl(F, #{}, BossListData).

%% 加载boss_info的data字段
init_boss_info_map_data(BossInfoMap) ->
    BossInfoDataList = sql_select_boss_first_blood_plus_data(),
    F = fun([Type, SubType, ObjectId, Data], {FunBossInfoMap, FRepairDbList}) ->
        BossInfoList = maps:get({Type, SubType}, FunBossInfoMap, []),
        BossInfo = lists:keyfind(ObjectId, #boss_info.object_id, BossInfoList),
        DataTerm = util:bitstring_to_term(Data),
        NewDataTerm = ?IF(DataTerm =/= undefined andalso is_list(DataTerm), DataTerm, []),
        case is_record(BossInfo, boss_info) of 
            false -> 
                %% 合服有可能出现的情况，两个服的玩家数据都被清空了
                case Type of 
                    ?CUSTOM_ACT_TYPE_PASS_DUN -> %% 针对符文本首通情况
                        %% 这时候将合服后排行榜第一的玩家作为首杀玩家
                        %% 如果排行榜也没有玩家了，就让新玩家重打
                        RewardState = ?NOT_RECEIVE,
                        {?PASS_RANK, PassRankData} = ulists:keyfind(?PASS_RANK, 1, NewDataTerm, {?PASS_RANK, []}),
                        case lists:keyfind(1, #pass_dun_role.rank, PassRankData) of
                            #pass_dun_role{role_id = FirstRoleId} -> %% 找到了第一的玩家
                                NewBossInfo = make_record(boss_info, [ObjectId, FirstRoleId, RewardState, Data]),
                                NewBossInfoList = lists:keystore(ObjectId, #boss_info.object_id, BossInfoList, NewBossInfo),
                                {maps:put({Type, SubType}, NewBossInfoList, FunBossInfoMap), [[Type, SubType, ObjectId, FirstRoleId, RewardState] | FRepairDbList]};
                            _ -> %% 排行榜也没数据了，让新玩家重新打
                                {FunBossInfoMap, FRepairDbList}
                        end;
                    _ ->
                        {FunBossInfoMap, FRepairDbList}
                end;
            _ -> %% 正常情况
                NewBossInfo = BossInfo#boss_info{data = NewDataTerm},
                NewBossInfoList = lists:keystore(ObjectId, #boss_info.object_id, BossInfoList, NewBossInfo),
                {maps:put({Type, SubType}, NewBossInfoList, FunBossInfoMap), FRepairDbList}
        end
    end,
    {NewBossInfoMap, RepairDbList} = lists:foldl(F, {BossInfoMap, []}, BossInfoDataList),
    case RepairDbList =/= [] of 
        true ->
            Sql = usql:replace(boss_first_blood_plus_boss, [type, sub_type, object_id, role_id, reward_state], RepairDbList),
            db:execute(Sql);
        false -> skip
    end,
    NewBossInfoMap.

%% 组装record
make_record(role_info, [BossId, RewardState]) ->
    RoleInfo = #role_info{
        boss_id = BossId,
        reward_state = RewardState
    },
    RoleInfo;
make_record(role_info, [BossId, RewardState, SharedState]) ->
    RoleInfo = #role_info{
        boss_id = BossId,
        reward_state = RewardState,
        shared_state = SharedState
    },
    RoleInfo;
make_record(boss_info, [ObjectId, RoleId, RewardState, Data]) ->
    BossInfo = #boss_info{
        object_id = ObjectId,
        role_id = RoleId,
        reward_state = RewardState,
        data = Data
    },
    BossInfo;
make_record(pass_dun_role, [RoleId, Rank, PassTime]) ->
    PassRuneDunRole = #pass_dun_role{
        role_id = RoleId,
        rank = Rank,
        pass_time = PassTime
    },
    PassRuneDunRole;
make_record(pass_dun_role, [RoleId, Rank, PassTime, IntervalTime]) ->
    PassRuneDunRole = #pass_dun_role{
        role_id = RoleId,
        rank = Rank,
        pass_time = PassTime,
        interval_time = IntervalTime
    },
    PassRuneDunRole;
make_record(_, _) ->
    {}.

%% 打包活动数据
pack_act_info(Type, SubType, RoleInfoList, BossInfoList) when Type == ?CUSTOM_ACT_TYPE_BOSS_FIRST_BLOOD_PLUS ->
    BossIds = data_first_blood_plus:get_object_ids(Type, SubType),
    F = fun(BossId, ClientDataList1) ->
        RoleInfo = lists:keyfind(BossId, #role_info.boss_id, RoleInfoList),
        if
            is_record(RoleInfo, role_info) ->
                #role_info{reward_state = RewardState} = RoleInfo;
            true ->
                case SubType of
                    2 -> %% 新活动要判断是否已经首杀boss，已首杀奖励状态为可领取
                        HasKillBossRoleIds = case ets:lookup(?ETS_FIRST_BLOOD, {Type, SubType, BossId}) of
                            [EtsFirstBlood|_] when is_record(EtsFirstBlood, ets_first_blood) -> EtsFirstBlood#ets_first_blood.role_ids;
                            _ -> []
                        end,
                        case HasKillBossRoleIds =:= [] of 
                            true ->
                                RewardState = ?CAN_NOT_RECEIVE;
                            false ->
                                RewardState = ?NOT_RECEIVE
                        end;
                    _ ->
                        RewardState = ?CAN_NOT_RECEIVE
                end                
        end,
        BossInfo = lists:keyfind(BossId, #boss_info.object_id, BossInfoList),
        if
            is_record(BossInfo, boss_info) ->
                #boss_info{role_id = FirstBloodRoleId} = BossInfo,
                case FirstBloodRoleId == 0 of
                    true ->    %% 有记录合服role_id置0了
                        ShowFirstBlood = 0,
                        NoFirstBloodInfo = 1;
                    false ->   %% 有记录且合服role_id没有置0
                        ShowFirstBlood = 1,
                        NoFirstBloodInfo = 0
                end;
            true ->  %% 无记录，证明未首杀
                ShowFirstBlood = 1,
                FirstBloodRoleId = 0,
                NoFirstBloodInfo = 0
        end,
        %% 只有role_id没有被重置为0且有对应的记录
        case FirstBloodRoleId =/= 0 andalso NoFirstBloodInfo == 0 of
            true ->
                #ets_role_show{figure = #figure{name = FirstBloodRoleName, lv = Lv, sex = Sex, career = Career, picture = Picture, picture_ver = PictureVer, dress_list = DressList}} = lib_role:get_role_show(FirstBloodRoleId),
                NewDressList = [{DressType, DressId} || {DressType, DressId} <- DressList, DressType == ?DRESS_UP_FRAME];
            false ->
                FirstBloodRoleName = <<""/utf8>>,
                Lv = 0,
                Sex = 0,
                Career = 0,
                Picture = 0,
                PictureVer = 0,
                NewDressList = []
        end,
        [{ShowFirstBlood, BossId, FirstBloodRoleId, FirstBloodRoleName, Lv, Sex, Career, Picture, PictureVer, NewDressList, RewardState} | ClientDataList1]
    end,
    ClientBossList = lists:foldl(F, [], BossIds),
    [Type, SubType, ClientBossList];
pack_act_info(_Type, _SubType, _RoleInfoList, _BossInfoList) -> 
    [0, 0, []].

pack_act_info2(Type, SubType, RoleId, BossInfoList) ->
    BossIds = data_first_blood_plus:get_object_ids(Type, SubType),
    F = fun(BossId, ClientDataList1) ->
        case lists:keyfind(BossId, #boss_info.object_id, BossInfoList) of
            #boss_info{role_id = FirstBloodRoleId, reward_state = RewardState} ->
                #ets_role_show{figure = #figure{name = FirstBloodRoleName, lv = Lv, sex = Sex, career = Career, picture = Picture, picture_ver = PictureVer, dress_list = DressList}} = lib_role:get_role_show(FirstBloodRoleId),
                NewDressList = [{DressType, DressId} || {DressType, DressId} <- DressList, DressType == ?DRESS_UP_FRAME],
                if
                    RoleId == FirstBloodRoleId  ->
                        RewardStateLast = RewardState;
                    true ->
                        RewardStateLast = ?CAN_NOT_RECEIVE
                end,
                [{1, BossId, FirstBloodRoleId, FirstBloodRoleName, Lv, Sex, Career, Picture, PictureVer, NewDressList, RewardStateLast} | ClientDataList1];
            false ->
                ClientDataList1
        end
        end,
    ClientBossList = lists:foldl(F, [], BossIds),
    [Type, SubType, ClientBossList].

pack_act_info3(Type, SubType, RoleInfoList, BossInfoList, DunId) ->
    RoleInfo = lists:keyfind(DunId, #role_info.boss_id, RoleInfoList),
    BossInfo = lists:keyfind(DunId, #boss_info.object_id, BossInfoList),
    if
        is_record(RoleInfo, role_info) ->
            #role_info{reward_state = RewardState} = RoleInfo;
        is_record(BossInfo, boss_info) -> %% 已有人首通
            RewardState = ?NOT_RECEIVE;
        true ->
            RewardState = ?CAN_NOT_RECEIVE
    end,
    %% 组装排行榜数据
    ClientDataList = case get_data(pass_rank, [BossInfo]) of 
        PassRankData when is_list(PassRankData) andalso length(PassRankData) > 0 ->
            F = fun(#pass_dun_role{role_id = RoleId, rank = Rank, pass_time = PassTime, interval_time = IntervalTime}, FunClientData) ->
                #ets_role_show{figure = #figure{name = RoleName, lv = Lv, sex = Sex, career = Career, picture = Picture, picture_ver = PictureVer, dress_list = DressList}} = lib_role:get_role_show(RoleId),
                 NewDressList = [{DressType, DressId} || {DressType, DressId} <- DressList, DressType == ?DRESS_UP_FRAME],
                 ClientTime = get_client_time(Type, SubType, PassTime, IntervalTime),
                 [{RoleId, RoleName, Rank, Lv, Sex, Career, Picture, PictureVer, NewDressList, ClientTime} | FunClientData]
            end,
            lists:foldl(F, [], PassRankData);
        _ ->
            []
    end,
    [Type, SubType, DunId, RewardState, ClientDataList].

%% 击杀boss广播击杀数据
broadcast_act_info(Type, SubType, BossInfoList) ->
    OnlineRoleList = ets:tab2list(?ETS_ONLINE),
    F = fun(#ets_online{id = OnlineRoleId}) ->
        lib_player:apply_cast(OnlineRoleId, ?APPLY_CAST_STATUS, lib_boss_first_blood_plus, broadcast_act_info_help, [Type, SubType, BossInfoList])
    end,
    lists:foreach(F, OnlineRoleList).


broadcast_act_info_help(Ps, Type, SubType, BossInfoList) when Type == ?CUSTOM_ACT_TYPE_BOSS_FIRST_BLOOD_PLUS  ->
    #player_status{id = RoleId, role_boss_first_blood = RoleMap} = Ps,
    RoleInfoList = maps:get({Type, SubType}, RoleMap, []),
    ClientData = pack_act_info(Type, SubType, RoleInfoList, BossInfoList),
    {ok, BinData} = pt_188:write(18801, ClientData),
    lib_server_send:send_to_uid(RoleId, BinData);
broadcast_act_info_help(Ps, ?CUSTOM_ACT_TYPE_DUN_FIRST_KILL, SubType, _BossInfoList) ->
    #player_status{id = RoleId, role_boss_first_blood = RoleMap} = Ps,
    mod_boss_first_blood_plus:act_info(?CUSTOM_ACT_TYPE_DUN_FIRST_KILL, SubType, RoleId, RoleMap);
broadcast_act_info_help(Ps, Type, SubType, _BossInfoList) when Type == ?CUSTOM_ACT_TYPE_PASS_DUN ->
    pp_boss_first_blood_plus:handle(18805, Ps, [Type, SubType]);
broadcast_act_info_help(_Ps, _Type, _SubType, _BossInfoList) ->
    ?ERR("broadcast_act_info_help type:_Type", [_Type]),
    skip.

%% 通关副本
pass_dungeon(DunId, DunType, RoleId) when DunType == ?DUNGEON_TYPE_RUNE2 ->
    Type = ?CUSTOM_ACT_TYPE_PASS_DUN,
    SubTypes = lib_custom_act_api:get_open_subtype_ids(Type),
    F = fun(SubType) ->
        TargetDunIds = data_first_blood_plus:get_object_ids(Type, SubType),
        IsTargetDun = lists:member(DunId, TargetDunIds),
        if
            IsTargetDun =:= false -> %% 非目标层数
                skip;
            true ->
                mod_boss_first_blood_plus:pass_dungeon(Type, SubType, DunId, RoleId)
        end
    end,
    lists:foreach(F, SubTypes);
pass_dungeon(_DunId, _DunType, _RoleId) ->
    skip.

%% 击杀boss
boss_be_killed(BossId, BLWho) when BLWho =/= [] ->
    Type = ?CUSTOM_ACT_TYPE_BOSS_FIRST_BLOOD_PLUS,
    SubTypes = lib_custom_act_api:get_open_subtype_ids(Type),
    F = fun(SubType) ->
        TargetBossIds = data_first_blood_plus:get_object_ids(Type, SubType),
        IsTargetBoss = lists:member(BossId, TargetBossIds),
        if
            IsTargetBoss =:= false ->
                skip;
            true ->
                HasKillBossRoleIds = case ets:lookup(?ETS_FIRST_BLOOD, {Type, SubType, BossId}) of
                    [EtsFirstBlood|_] when is_record(EtsFirstBlood, ets_first_blood) -> EtsFirstBlood#ets_first_blood.role_ids;
                    _ -> []
                end,
                case SubType of 
                    1 -> %% 旧活动，目前已经开启的服仍然用旧活动玩法
                        LastBLRoleList = filter_bl_role(BLWho, get_act_role_lv_limit(Type, SubType), HasKillBossRoleIds),
                        mod_boss_first_blood_plus:boss_be_killed(Type, SubType, BossId, LastBLRoleList);
                    2 when HasKillBossRoleIds =:= [] ->  %% 新活动，后面的新服用新活动的玩法
                        BLRoleId = cal_bl_role_id(BLWho),
                        mod_boss_first_blood_plus:boss_be_killed(Type, SubType, BossId, BLRoleId);
                    _ -> skip
                end
                
        end
    end,
    lists:foreach(F, SubTypes);
boss_be_killed(_BossId, _BLWho) ->
    skip.

boss_be_killed_help(Ps, Type, SubType, FirstBloodStatus, BossId, BossInfoList) ->
    #player_status{id = KillerId, role_boss_first_blood = RoleMap} = Ps,
    RoleInfoList = maps:get({Type, SubType}, RoleMap, []),
    RoleInfo = lists:keyfind(BossId, #role_info.boss_id, RoleInfoList),
    if
        is_record(RoleInfo, role_info) andalso RoleInfo#role_info.reward_state =/= ?CAN_NOT_RECEIVE->
            Ps;
        true ->
            if 
                % 没有记录的进行初始化
                not is_record(RoleInfo, role_info) ->
                    lib_boss_first_blood_plus:sql_replace_boss_first_blood_plus_role(Type, SubType, KillerId, BossId, ?NOT_RECEIVE, ?NOT_RECEIVE),
                    NewRoleInfo = #role_info{boss_id = BossId, reward_state = ?NOT_RECEIVE};
                % 这里有记录的且个人奖励状态为无法领取，将奖励状态改为未领取
                true ->
                    lib_boss_first_blood_plus:sql_replace_boss_first_blood_plus_role(Type, SubType, KillerId, BossId, ?NOT_RECEIVE, RoleInfo#role_info.shared_state),
                    NewRoleInfo = RoleInfo#role_info{boss_id = BossId, reward_state = ?NOT_RECEIVE}
            end,
            NewRoleInfoList = lists:keystore(BossId, #role_info.boss_id, RoleInfoList, NewRoleInfo),
            NewRoleMap = maps:put({Type, SubType}, NewRoleInfoList, RoleMap),
            %% 插入ets
            NewEtsFirstBlood = case ets:lookup(?ETS_FIRST_BLOOD, {Type, SubType, BossId}) of
                [EtsFirstBlood|_] when is_record(EtsFirstBlood, ets_first_blood) ->
                    EtsFirstBlood#ets_first_blood{role_ids = [KillerId | EtsFirstBlood#ets_first_blood.role_ids]};
                _ ->
                    #ets_first_blood{key = {Type, SubType, BossId}, role_ids = [KillerId]}
            end,
            ets:insert(?ETS_FIRST_BLOOD, NewEtsFirstBlood),
            %% 刷新界面
            case FirstBloodStatus of
                ?WHOLE_FIRST_BLOOD ->
                    broadcast_act_info(Type, SubType, BossInfoList);
                ?NOT_WHOLE_FIRST_BLOOD ->
                    ClientData = pack_act_info(Type, SubType, NewRoleInfoList, BossInfoList),
                    {ok, BinData} = pt_188:write(18801, ClientData),
                    lib_server_send:send_to_uid(KillerId, BinData);
                _ ->
                    skip
            end,
            Ps#player_status{role_boss_first_blood = NewRoleMap}
    end.

%% 筛选满足条件的归属玩家
filter_bl_role(BLWho, RoleLvLimit, []) ->
    F = fun(BLRole = #mon_atter{att_lv = RoleLv}, FunBLRoleList) ->
        case RoleLv >= RoleLvLimit of
            true ->
                [BLRole | FunBLRoleList];
            false ->
                FunBLRoleList
        end
    end,
    lists:foldl(F, [], BLWho);
filter_bl_role(BLWho, RoleLvLimit, HasKillBossRoleIds) ->
    F = fun(BLRole = #mon_atter{id = BLRoleId, att_lv = RoleLv}, FunBLRoleList) ->
        case RoleLv >= RoleLvLimit andalso lists:member(BLRoleId, HasKillBossRoleIds) =:= false of
            true ->
                [BLRole | FunBLRoleList];
            false ->
                FunBLRoleList
        end
    end,
    lists:foldl(F, [], BLWho).

%% 计算归属的玩家id
%% 不组队和组队，组队归给伤害最高的玩家
cal_bl_role_id(BLWho) ->
    case length(BLWho) > 1 of 
        true ->
            [#mon_atter{id = BLRoleId}|_] = lists:reverse(lists:keysort(#mon_atter.hurt, BLWho));
        false ->
            [#mon_atter{id = BLRoleId}|_] = BLWho
    end,
    BLRoleId.

%% 计算首杀玩家id和非首杀玩家id
cal_bl_role_id(BLWho, HasBeenFirstBlood) ->
    %% 判断boss是否被首杀了
    if
        HasBeenFirstBlood -> %% 已经被首杀
            [BLRoleId || #mon_atter{id = BLRoleId} <- BLWho];
        true -> %% 还没被首杀需要将首杀玩家从归属玩家中分离出来
            %% 伤害排名
            HurtList = lists:reverse(lists:keysort(#mon_atter.hurt, BLWho)),
            [FirstBloodRoleId | BLRoleIds] = [BLRoleId || #mon_atter{id = BLRoleId} <- HurtList],
            {FirstBloodRoleId, BLRoleIds}
    end.

%% 新活动领取奖励
new_act_receive_reward(Type, SubType, RoleInfoList, BossId, RoleId) when Type == ?CUSTOM_ACT_TYPE_BOSS_FIRST_BLOOD_PLUS andalso SubType == 2 ->
    case lists:keyfind(BossId, #role_info.boss_id, RoleInfoList) of
        #role_info{reward_state = RewardState} when RewardState == ?NOT_RECEIVE ->
            mod_boss_first_blood_plus:receive_reward(Type, SubType, RoleId, BossId);
        false -> %% 没记录，检测一下boss是否被首杀
            HasKillBossRoleIds = case ets:lookup(?ETS_FIRST_BLOOD, {Type, SubType, BossId}) of
                [EtsFirstBlood|_] when is_record(EtsFirstBlood, ets_first_blood) -> EtsFirstBlood#ets_first_blood.role_ids;
                _ -> []
            end,
            case HasKillBossRoleIds =/= [] of 
                true -> %% 已经被首杀
                    mod_boss_first_blood_plus:receive_reward(Type, SubType, RoleId, BossId);
                false -> %% 未被首杀
                    skip
            end;
        _Err -> 
            skip
    end;

%% 领取全服归属奖励
new_act_receive_reward(Type, SubType, RoleInfoList, BossId, RoleId) when Type == ?CUSTOM_ACT_TYPE_PASS_DUN andalso SubType == 1 ->
    case lists:keyfind(BossId, #role_info.boss_id, RoleInfoList) of
        #role_info{reward_state = RewardState} when RewardState == ?CAN_NOT_RECEIVE orelse RewardState == ?IS_RECEIVE ->
            skip;
        _ ->
            mod_boss_first_blood_plus:receive_reward(Type, SubType, RoleId, BossId)
    end;
new_act_receive_reward(_Type, _SubType, _RoleInfoList, _BossId, _RoleId) ->
    ?ERR("new_act_receive_reward error:~p", [{_Type, _SubType, _BossId}]).

new_act_receive_shared(Ps, Type, SubType, RoleInfoList, BossId) when Type == ?CUSTOM_ACT_TYPE_BOSS_FIRST_BLOOD_PLUS andalso SubType == 1 ->
    #player_status{id = RoleId} = Ps,
    case lists:keyfind(BossId, #role_info.boss_id, RoleInfoList) of
        #role_info{shared_state = SharedState} when SharedState == ?IS_RECEIVE ->
            {ok, BinData} = pt_188:write(18807, [Type, SubType, ?ERRCODE(err188_has_get_reward), BossId, []]),
            lib_server_send:send_to_uid(RoleId, BinData),
            skip;
        _ ->
            HasKillBossRoleIds = case ets:lookup(?ETS_FIRST_BLOOD, {Type, SubType, BossId}) of
                [EtsFirstBlood|_] when is_record(EtsFirstBlood, ets_first_blood) -> EtsFirstBlood#ets_first_blood.role_ids;
                _ -> []
            end,
            case HasKillBossRoleIds =/= [] of 
                true -> %% 已经被首杀
                    lib_boss_first_blood_plus:receive_shared(Ps, Type, SubType, BossId);
                false -> %% 未被首杀
                    {ok, BinData} = pt_188:write(18807, [Type, SubType, ?ERRCODE(err188_not_kill_boss), BossId, []]),
                    lib_server_send:send_to_uid(RoleId, BinData),
                    skip
            end
    end;
new_act_receive_shared(_Ps, Type, SubType, _RoleInfoList, BossId) ->
    ?ERR("new_act_receive_shared error:~p", [{Type, SubType, BossId}]).

%% 领取全服归属奖励
receive_shared(Ps, Type, SubType, BossId) ->
    #player_status{id = RoleId, role_boss_first_blood = RoleMap} = Ps,
    RoleInfoList = maps:get({Type, SubType}, RoleMap, []), 
    RoleInfo = lists:keyfind(BossId, #role_info.boss_id, RoleInfoList),
    NewRoleInfo = case is_record(RoleInfo, role_info) of 
                        true -> RoleInfo#role_info{shared_state = ?IS_RECEIVE};
                        false -> #role_info{boss_id = BossId, reward_state = ?CAN_NOT_RECEIVE, shared_state = ?IS_RECEIVE}
                    end,
    #base_first_blood_plus_boss{shared_reward = SharedReward} = data_first_blood_plus:get(Type, SubType, BossId),
    lib_boss_first_blood_plus:sql_replace_boss_first_blood_plus_role(Type, SubType, RoleId, BossId, NewRoleInfo#role_info.reward_state, ?IS_RECEIVE),
    ProdeuceType = first_blood_plus_boss,
    Produce = #produce{title = utext:get(18800001), content = utext:get(18800002), type = ProdeuceType, reward = SharedReward, show_tips = 1},
    lib_log_api:log_boss_first_blood_plus_reward(Type, SubType, RoleId, BossId, util:term_to_bitstring(SharedReward)),
    lib_goods_api:send_reward_by_id(Produce, RoleId),
    NewRoleInfoList = lists:keystore(BossId, #role_info.boss_id, RoleInfoList, NewRoleInfo),
    NewRoleMap = maps:put({Type, SubType}, NewRoleInfoList, RoleMap),
    NewPs = Ps#player_status{role_boss_first_blood = NewRoleMap},
    {ok, BinData} = pt_188:write(18807, [Type, SubType, ?SUCCESS, BossId, SharedReward]),
    lib_server_send:send_to_uid(RoleId, BinData),
    {ok, NewPs}.

get_shared_state(Type, SubType, RoleInfoList, BossId) ->
    RoleInfo = lists:keyfind(BossId, #role_info.boss_id, RoleInfoList),
    SharedState = case is_record(RoleInfo, role_info) andalso RoleInfo#role_info.shared_state =:= ?IS_RECEIVE of 
                        true -> ?IS_RECEIVE;
                        false -> 
                            HasKillBossRoleIds = case ets:lookup(?ETS_FIRST_BLOOD, {Type, SubType, BossId}) of
                                [EtsFirstBlood|_] when is_record(EtsFirstBlood, ets_first_blood) -> EtsFirstBlood#ets_first_blood.role_ids;
                                _ -> []
                            end,
                            case HasKillBossRoleIds =/= [] of 
                                true -> %% 已经被首杀
                                    ?NOT_RECEIVE;
                                false -> %% 未被首杀
                                    ?CAN_NOT_RECEIVE
                            end
                    end,
    SharedState.

%% 查询全服归属奖励领取状态
shared_info(Type, SubType, RoleInfoList, BossId, RoleId) ->
    SharedState = get_shared_state(Type, SubType, RoleInfoList, BossId),
    {ok, BinData} = pt_188:write(18806, [Type, SubType, BossId, SharedState]),
    lib_server_send:send_to_uid(RoleId, BinData).

%% 获取奖励
receive_reward(Ps, Type, SubType, BossId, BossInfoList) when Type =:= ?CUSTOM_ACT_TYPE_BOSS_FIRST_BLOOD_PLUS andalso SubType =:= 1 ->
    #player_status{id = RoleId, role_boss_first_blood = RoleMap} = Ps,
    RoleInfoList = maps:get({Type, SubType}, RoleMap, []),
    RoleInfo = lists:keyfind(BossId, #role_info.boss_id, RoleInfoList),
    {RewardState, SharedState} = case is_record(RoleInfo, role_info) of 
                        true -> {RoleInfo#role_info.reward_state, get_shared_state(Type, SubType, RoleInfoList, BossId)};
                        false -> {?CAN_NOT_RECEIVE, get_shared_state(Type, SubType, RoleInfoList, BossId)}
                    end,
    % 只有在任一奖励可以领取的情况下才执行奖励的计算与发放
    ?IF(RewardState =:= ?NOT_RECEIVE orelse SharedState =:= ?NOT_RECEIVE, 
    case cal_reward(Type, SubType, RoleId, BossId, BossInfoList, {RewardState, SharedState}) of
        {RewardList, IsFirstBlood, AfRewardState, AfSharedState} ->
            DbF = fun() ->
                ?IF(IsFirstBlood == 1, lib_boss_first_blood_plus:sql_replace_boss_first_blood_plus_boss_merge(Type, SubType, BossId, RoleId, ?IS_RECEIVE), skip),
                lib_boss_first_blood_plus:sql_replace_boss_first_blood_plus_role(Type, SubType, RoleId, BossId,  AfRewardState, AfSharedState),
                ok
            end,
            case catch db:transaction(DbF) of
                ok ->
                    ProdeuceType = case Type of 
                        ?CUSTOM_ACT_TYPE_PASS_DUN -> first_pass_rune_dun;
                        _ -> first_blood_plus_boss
                    end,
                    Produce = #produce{title = utext:get(18800001), content = utext:get(18800002), type = ProdeuceType, reward = RewardList, show_tips = 1},
                    lib_log_api:log_boss_first_blood_plus_reward(Type, SubType, RoleId, BossId, util:term_to_bitstring(RewardList)),
                    lib_goods_api:send_reward_by_id(Produce, RoleId),
                    NewRoleInfo = case is_record(RoleInfo, role_info) of 
                        true -> RoleInfo#role_info{reward_state = AfRewardState, shared_state = AfSharedState};
                        false -> #role_info{boss_id = BossId, reward_state = AfRewardState, shared_state = AfSharedState}
                    end,
                    NewRoleInfoList = lists:keystore(BossId, #role_info.boss_id, RoleInfoList, NewRoleInfo),
                    NewRoleMap = maps:put({Type, SubType}, NewRoleInfoList, RoleMap),
                    NewPs = Ps#player_status{role_boss_first_blood = NewRoleMap},
                    {ok, BinData} = pt_188:write(18802, [Type, SubType, ?SUCCESS, BossId, RewardList]),
                    lib_server_send:send_to_uid(RoleId, BinData),
                    %% 刷新弹窗
                    case Type == ?CUSTOM_ACT_TYPE_BOSS_FIRST_BLOOD_PLUS andalso SubType == 2 of 
                        true ->
                            lib_boss_first_blood_plus:login_notice(Type, SubType, RoleId, NewRoleInfoList);
                        false ->
                            skip
                    end,
                    NewPs;
                _Error ->
                    {ok, BinData} = pt_188:write(18802, [Type, SubType, ?FAIL, BossId, []]),
                    lib_server_send:send_to_uid(RoleId, BinData),
                    Ps
            end;
        _ ->
            {ok, BinData} = pt_188:write(18802, [Type, SubType, ?FAIL, BossId, []]),
            lib_server_send:send_to_uid(RoleId, BinData),
            Ps
    end , Ps);

%% 获取奖励
receive_reward(Ps, Type, SubType, BossId, BossInfoList) -> 
    #player_status{id = RoleId, role_boss_first_blood = RoleMap} = Ps,
    RoleInfoList = maps:get({Type, SubType}, RoleMap, []),
    RoleInfo = lists:keyfind(BossId, #role_info.boss_id, RoleInfoList),
    case cal_reward(Type, SubType, RoleId, BossId, BossInfoList) of
        {RewardList, IsFirstBlood} ->
            DbF = fun() ->
                % 非BOSS首杀活动，共享奖励状态不重要，现都处理为2
                ?IF(IsFirstBlood == 1, lib_boss_first_blood_plus:sql_replace_boss_first_blood_plus_boss_merge(Type, SubType, BossId, RoleId, ?IS_RECEIVE), skip),
                lib_boss_first_blood_plus:sql_replace_boss_first_blood_plus_role(Type, SubType, RoleId, BossId, ?IS_RECEIVE, 2),
                ok
            end,
            case catch db:transaction(DbF) of
                ok ->
                    ProdeuceType = case Type of 
                        ?CUSTOM_ACT_TYPE_PASS_DUN -> first_pass_rune_dun;
                        _ -> first_blood_plus_boss
                    end,
                    Produce = #produce{title = utext:get(18800001), content = utext:get(18800002), type = ProdeuceType, reward = RewardList, show_tips = 1},
                    lib_log_api:log_boss_first_blood_plus_reward(Type, SubType, RoleId, BossId, util:term_to_bitstring(RewardList)),
                    lib_goods_api:send_reward_by_id(Produce, RoleId),
                    NewRoleInfo = case is_record(RoleInfo, role_info) of 
                        true -> RoleInfo#role_info{reward_state = ?IS_RECEIVE};
                        false -> #role_info{boss_id = BossId, reward_state = ?IS_RECEIVE}
                    end,
                    NewRoleInfoList = lists:keystore(BossId, #role_info.boss_id, RoleInfoList, NewRoleInfo),
                    NewRoleMap = maps:put({Type, SubType}, NewRoleInfoList, RoleMap),
                    NewPs = Ps#player_status{role_boss_first_blood = NewRoleMap},
                    {ok, BinData} = pt_188:write(18802, [Type, SubType, ?SUCCESS, BossId, RewardList]),
                    lib_server_send:send_to_uid(RoleId, BinData),
                    %% 刷新弹窗
                    case Type == ?CUSTOM_ACT_TYPE_BOSS_FIRST_BLOOD_PLUS andalso SubType == 2 of 
                        true ->
                            lib_boss_first_blood_plus:login_notice(Type, SubType, RoleId, NewRoleInfoList);
                        false ->
                            skip
                    end,
                    NewPs;
                _Error ->
                    {ok, BinData} = pt_188:write(18802, [Type, SubType, ?FAIL, BossId, []]),
                    lib_server_send:send_to_uid(RoleId, BinData),
                    Ps
            end;
        _ ->
            {ok, BinData} = pt_188:write(18802, [Type, SubType, ?FAIL, BossId, []]),
            lib_server_send:send_to_uid(RoleId, BinData),
            Ps
    end.    
    
%% 计算奖励
%% BOSS首杀用第一个特有的，副本的用下面的
cal_reward(Type, SubType, RoleId, BossId, BossInfoList, State) when Type == ?CUSTOM_ACT_TYPE_BOSS_FIRST_BLOOD_PLUS andalso SubType == 1->
    %% 领取奖励，首杀多一份礼包
    {RewardState, SharedState} = State, 
    #base_first_blood_plus_boss{whole_first_blood_reward = WholeReward, own_reward = OwnReward, shared_reward = SharedReward} = data_first_blood_plus:get(Type, SubType, BossId),
    case lists:keyfind(BossId, #boss_info.object_id, BossInfoList) of
        #boss_info{role_id = FirstBloodRoleId} when FirstBloodRoleId == RoleId ->
            RewardList = ?IF(RewardState =:= ?NOT_RECEIVE, WholeReward ++ OwnReward, []) ++ ?IF(SharedState =:= ?NOT_RECEIVE, SharedReward, []),
            IsFirstBlood = 1;
        _ ->
            RewardList = ?IF(RewardState =:= ?NOT_RECEIVE, OwnReward, []) ++ ?IF(SharedState =:= ?NOT_RECEIVE, SharedReward, []),
            IsFirstBlood = 0
    end,
    {RewardList, IsFirstBlood, ?IF(RewardState =:= ?NOT_RECEIVE, ?IS_RECEIVE, RewardState), ?IF(SharedState =:= ?NOT_RECEIVE, ?IS_RECEIVE, SharedState)}.
% cal_reward(Type, SubType, RoleId, BossId, BossInfoList) when Type == ?CUSTOM_ACT_TYPE_BOSS_FIRST_BLOOD_PLUS andalso SubType == 1 ->
%     %% 领取奖励，首杀多一份礼包
%     #base_first_blood_plus_boss{whole_first_blood_reward = WholeReward, own_reward = OwnReward} = data_first_blood_plus:get(Type, SubType, BossId),
%     case lists:keyfind(BossId, #boss_info.object_id, BossInfoList) of
%         #boss_info{role_id = FirstBloodRoleId} when FirstBloodRoleId == RoleId ->
%             RewardList = WholeReward ++ OwnReward,
%             IsFirstBlood = 1;
%         _ ->
%             RewardList = OwnReward,
%             IsFirstBlood = 0
%     end,
%     {RewardList, IsFirstBlood};
cal_reward(Type, SubType, RoleId, BossId, BossInfoList) when Type == ?CUSTOM_ACT_TYPE_BOSS_FIRST_BLOOD_PLUS andalso SubType == 2 ->
    %% 新活动奖励规则
    %% 全服首杀玩家可以获取 WholeReward，非首杀玩家只能拿OwnReward
    #base_first_blood_plus_boss{whole_first_blood_reward = WholeReward, own_reward = OwnReward} = data_first_blood_plus:get(Type, SubType, BossId),
    case lists:keyfind(BossId, #boss_info.object_id, BossInfoList) of
        #boss_info{role_id = FirstBloodRoleId} when FirstBloodRoleId == RoleId ->
            RewardList = WholeReward,
            IsFirstBlood = 1;
        _ ->
            RewardList = OwnReward,
            IsFirstBlood = 0
    end,
    {RewardList, IsFirstBlood};
cal_reward(Type, SubType, RoleId, BossId, BossInfoList) when Type == ?CUSTOM_ACT_TYPE_PASS_DUN ->
    %% 新活动奖励规则
    %% 全服首杀玩家可以获取 WholeReward，非首杀玩家只能拿OwnReward
    #base_first_blood_plus_boss{whole_first_blood_reward = WholeReward, own_reward = OwnReward} = data_first_blood_plus:get(Type, SubType, BossId),
    case lists:keyfind(BossId, #boss_info.object_id, BossInfoList) of
        #boss_info{role_id = FirstBloodRoleId} when FirstBloodRoleId == RoleId ->
            RewardList = WholeReward,
            IsFirstBlood = 1;
        _ ->
            RewardList = OwnReward,
            IsFirstBlood = 0
    end,
    {RewardList, IsFirstBlood};
cal_reward(Type, SubType, RoleId, BossId, _) ->
    ?ERR("first blood cal reward error:~p", [{Type, SubType, RoleId, BossId}]),
    error.

%% 击杀boss之后提醒领取奖励
notice_role_receive_reward_af_kill_boss(Ps, Type, SubType) when Type == ?CUSTOM_ACT_TYPE_BOSS_FIRST_BLOOD_PLUS andalso SubType == 2 ->
    #player_status{id = RoleId, role_boss_first_blood = RoleMap} = Ps,
    case lib_boss_first_blood_plus:base_check(Type, SubType, Ps) of
        true ->
            RoleInfoList = maps:get({Type, SubType}, RoleMap, []),
            lib_boss_first_blood_plus:login_notice(Type, SubType, RoleId, RoleInfoList);
        {false, _ErrCode} -> skip
    end;
notice_role_receive_reward_af_kill_boss(_Ps, _Type, _SubType) ->
    skip.

%% 登录提醒玩家领取奖励
login_notice(Type, SubType, RoleId, RoleInfoList) ->
    BossIds = data_first_blood_plus:get_object_ids(Type, SubType),
    %% 根据界面展示顺序排序
    SortBossIds = lib_boss_first_blood_plus_util:sort(client_pos, [Type, SubType, BossIds]),
    lib_boss_first_blood_plus:login_notice_role_receive_reward(Type, SubType, RoleId, RoleInfoList, SortBossIds).

%% 登录提醒玩家领取奖励
login_notice_role_receive_reward(Type, SubType, RoleId, RoleInfoList, [BossId | BossIds]) ->
    case lists:keyfind(BossId, #role_info.boss_id, RoleInfoList) of
        #role_info{reward_state = RewardState} when RewardState == ?IS_RECEIVE orelse RewardState == ?CAN_NOT_RECEIVE ->
            login_notice_role_receive_reward(Type, SubType, RoleId, RoleInfoList, BossIds);
        _ -> 
            case ets:lookup(?ETS_FIRST_BLOOD, {Type, SubType, BossId}) of
                [EtsFirstBlood|_] when is_record(EtsFirstBlood, ets_first_blood) -> 
                    EtsRoleIds = EtsFirstBlood#ets_first_blood.role_ids,
                    case EtsRoleIds =:= [] of 
                        false -> %% 已被首杀
                            mod_boss_first_blood_plus:login_notice_role_receive_reward(Type, SubType, RoleId, BossId);
                        _ -> 
                            login_notice_role_receive_reward(Type, SubType, RoleId, RoleInfoList, BossIds)
                    end;
                _ -> 
                    login_notice_role_receive_reward(Type, SubType, RoleId, RoleInfoList, BossIds)
            end
    end; 
login_notice_role_receive_reward(_Type, _SubType, _RoleId, _RoleInfoList, []) ->
    skip.

%% boss被首杀，提醒玩家领取奖励
notice_role_receive_reward(Type, SubType, RoleId, FirstBloodRoleId, BossId) ->
    IsOpen = lib_custom_act_api:is_open_act(Type, SubType),
    if
        IsOpen =:= false ->
            skip;
        FirstBloodRoleId =/= 0 ->
            #ets_role_show{figure = #figure{name = FirstBloodRoleName}} = lib_role:get_role_show(FirstBloodRoleId),
            #mon{name = BossName} = data_mon:get(BossId),
            {ok, BinData} = pt_188:write(18803, [Type, SubType, FirstBloodRoleName, BossName]),
            lib_server_send:send_to_uid(RoleId, BinData);
        true -> skip
    end.

%% 刷新界面
refresh_client(Ps, Type, SubType, BossId) when Type == ?CUSTOM_ACT_TYPE_PASS_DUN ->
    pp_boss_first_blood_plus:handle(18804, Ps, [Type, SubType, BossId]),
    broadcast_act_info(Type, SubType, []),
    #dungeon{type = DunType} = data_dungeon:get(BossId),
    pp_dungeon_sec:handle(61113, Ps, [DunType]);
refresh_client(_Ps, _Type, _SubType, _BossId) ->
    ?ERR("refresh_client error:~p", [{_Type, _SubType, _BossId}]).

%% 获取副本通关间隔时间
get_interval_time(Type, SubType, PassTime) when Type == ?CUSTOM_ACT_TYPE_PASS_DUN andalso SubType == 1 -> %% 符文本
    OpenTime = util:get_open_time(),
    PassTime - OpenTime;
get_interval_time(_Type, _SubType, _PassTime) ->
    0.

%% 获取副本榜单显示时间
get_client_time(Type, SubType, PassTime, _IntervalTime) when Type == ?CUSTOM_ACT_TYPE_PASS_DUN andalso SubType == 1 -> %% 符文本 ->
    % case util:is_merge_game() of 
    %     true -> IntervalTime;
    %     false -> PassTime
    % end;
    PassTime;
get_client_time(_Type, _SubType, _PassTime, _IntervalTime) ->
    0.

%% 发送传闻
send_tv(?CUSTOM_ACT_TYPE_DUN_FIRST_KILL, SubType, BLRoleId, BossId) ->
    RoleLvLimit = get_act_role_lv_limit(?CUSTOM_ACT_TYPE_DUN_FIRST_KILL, SubType),
    #ets_role_show{figure = #figure{name = BLRoleName}} = lib_role:get_role_show(BLRoleId),
    #base_first_blood_plus_boss{boss_scene_name = BossArea} = data_first_blood_plus:get(?CUSTOM_ACT_TYPE_DUN_FIRST_KILL, SubType,BossId),
    lib_chat:send_TV({all_lv, RoleLvLimit, 999}, ?MOD_DUNGEON, 5, [BLRoleName, BossArea]);
send_tv(Type, SubType, BLRoleId, BossId) when Type == ?CUSTOM_ACT_TYPE_PASS_DUN ->
    FinishTaskId = get_act_task_limit(Type, SubType),
    OnlineList = ets:tab2list(?ETS_ONLINE),
    F = fun(#ets_online{id = PlayerId, tid = Tid}, FunRoleIdList) ->
        case catch mod_task:is_finish_task_id(Tid, FinishTaskId) of 
            true -> FunRoleIdList;
            _ -> [PlayerId | FunRoleIdList]
        end
    end,
    ExcludeRoleIdList = lists:foldl(F, [], OnlineList),
    #ets_role_show{figure = #figure{name = BLRoleName}} = lib_role:get_role_show(BLRoleId),
    #base_first_blood_plus_boss{boss_scene_name = BossArea} = data_first_blood_plus:get(Type, SubType, BossId),
    lib_chat:send_TV({all_exclude, ExcludeRoleIdList}, ?MOD_DUNGEON, 7, [BLRoleName, BossArea]);
send_tv(Type, SubType, BLRoleId, BossId) ->
    RoleLvLimit = get_act_role_lv_limit(Type, SubType),
    #ets_role_show{figure = #figure{name = BLRoleName}} = lib_role:get_role_show(BLRoleId),
    #base_first_blood_plus_boss{boss_scene_name = BossArea} = data_first_blood_plus:get(Type, SubType,BossId),
    BossName = lib_mon:get_name_by_mon_id(BossId),
    lib_chat:send_TV({all_lv, RoleLvLimit, 999}, ?MOD_BOSS_FIRST_BLOOD_PLUS, 1, [BLRoleName, BossArea, BossName]).

%% 合服后的处理
merge_handle(BossInfoMap) ->
    case util:get_merge_day() == 1 of 
        true ->
            %% 未领取奖励的角色id列表[{BossId, RoleId}|...]
            FirstBloodRole = sql_select_boss_first_blood_plus_boss_merge(?NOT_RECEIVE),
            [?TRY_CATCH(merge_handle_help(Type, BossInfoMap, FirstBloodRole)) || Type <- ?FIRST_BLOOD_ACT_LIST];
        false ->
            skip
    end.

%% 合服处理策略
merge_handle_help(Type, BossInfoMap, FirstBloodRole) when 
    Type == ?CUSTOM_ACT_TYPE_BOSS_FIRST_BLOOD_PLUS orelse
    Type == ?CUSTOM_ACT_TYPE_PASS_DUN -> %% 结算奖励
    ?IF(FirstBloodRole =/= [], spawn(fun() -> merge_send_reward(Type, FirstBloodRole, BossInfoMap) end), skip);
merge_handle_help(_, _, _) ->
    skip.

%% 合服奖励结算
merge_send_reward(Type, FirstBloodRole, BossInfoMap) when Type == ?CUSTOM_ACT_TYPE_BOSS_FIRST_BLOOD_PLUS ->
    SubTypes = lib_custom_act_api:get_open_subtype_ids(Type),
    Fun = fun(SubType) ->
        DbList = [[Type, SubType, FirstBloodRoleId, BossId, ?IS_RECEIVE, ?IS_RECEIVE] || [DbType, BossId, FirstBloodRoleId] <- FirstBloodRole, DbType == Type],
        if
            DbList =:= [] -> %% 无数据处理
                skip;
            true ->
                DbF = fun() ->
                    %% 删除活动数据
                    sql_delete_boss_first_blood_plus_boss_merge(Type, SubType),
                    %% 更新玩家的领取标志位
                    Sql = usql:replace(boss_first_blood_plus_role, [type, sub_type, role_id, boss_id, reward_state, shared_state], DbList),
                    db:execute(Sql),
                    ok
                end,
                case catch db:transaction(DbF) of
                    ok ->
                        %% 发送奖励
                        F = fun([_, _, FirstBloodRoleId, BossId, _, _]) ->
                            #base_first_blood_plus_boss{whole_first_blood_reward = WholeReward, own_reward = OwnReward, shared_reward = SharedReward} = data_first_blood_plus:get(Type, SubType, BossId),
                            RewardList = case SubType of 
                                1 -> WholeReward ++ OwnReward ++ SharedReward;
                                2 -> WholeReward;
                                _ -> []
                            end,
                            lib_log_api:log_boss_first_blood_plus_reward(Type, SubType, FirstBloodRoleId, BossId, util:term_to_bitstring(RewardList)),
                            lib_mail_api:send_sys_mail([FirstBloodRoleId], utext:get(18800003), utext:get(18800004), RewardList),
                            timer:sleep(200)
                        end,
                        lists:foreach(F, DbList),
                        BossInfoList = maps:get({Type, SubType}, BossInfoMap, []),
                        %% 广播刷新数据
                        broadcast_act_info(Type, SubType, BossInfoList);
                    Err ->
                        ?ERR("first blood db error:~p", [Err]),
                        skip
                end        
        end
    end,
    lists:foreach(Fun, SubTypes);
merge_send_reward(Type, FirstBloodRole, _BossInfoMap) when Type == ?CUSTOM_ACT_TYPE_PASS_DUN ->
    SubTypes = lib_custom_act_api:get_open_subtype_ids(Type),
    Fun = fun(SubType) ->
        DbList = [[Type, SubType, FirstBloodRoleId, BossId, ?IS_RECEIVE, ?IS_RECEIVE] || [DbType, BossId, FirstBloodRoleId] <- FirstBloodRole, DbType == Type],
        if
            DbList =:= [] -> %% 无数据处理
                skip;
            true ->
                DbF = fun() ->
                    %% 删除活动数据
                    sql_delete_boss_first_blood_plus_boss_merge(Type, SubType),
                    %% 更新玩家的领取标志位
                    Sql = usql:replace(boss_first_blood_plus_role, [type, sub_type, role_id, boss_id, reward_state, shared_state], DbList),
                    db:execute(Sql),
                    ok
                end,
                case catch db:transaction(DbF) of
                    ok ->
                        %% 发送奖励
                        F = fun([_, _, FirstBloodRoleId, BossId, _, _]) ->
                            #base_first_blood_plus_boss{whole_first_blood_reward = WholeReward} = data_first_blood_plus:get(Type, SubType, BossId),
                            RewardList = case SubType of 
                                1 -> WholeReward;
                                _ -> []
                            end,
                            lib_log_api:log_boss_first_blood_plus_reward(Type, SubType, FirstBloodRoleId, BossId, util:term_to_bitstring(RewardList)),
                            lib_mail_api:send_sys_mail([FirstBloodRoleId], utext:get(18800003), utext:get(18800004), RewardList),
                            timer:sleep(200)
                        end,
                        lists:foreach(F, DbList);
                    Err ->
                        ?ERR("first blood db error:~p", [Err]),
                        skip

                end
        end        
    end,
    lists:foreach(Fun, SubTypes);
merge_send_reward(_Type, _FirstBloodRole, _BossInfoMap) ->
    ?ERR("merge_send_reward err, type:~p", [_Type]),
    skip.
    
%% 基本检测
base_check(Type, SubType, Ps) ->
    #player_status{figure = #figure{lv = RoleLv}, tid = Tid} = Ps,
    case lib_custom_act_util:get_act_cfg_info(Type, SubType) of 
        #custom_act_cfg{condition = Condition} ->
            {role_lv, RoleLvLimit} = ulists:keyfind(role_lv, 1, Condition, {role_lv, 999}),
            {finish_task_id, TaskId} = ulists:keyfind(finish_task_id, 1, Condition, {finish_task_id, 0}),
            CheckList = 
                [
                    {role_lv, RoleLv, RoleLvLimit}
                    , {is_open_act, Type, SubType}
                    , {finish_task_id, TaskId, Tid}
                ],
            check(CheckList);
        _ ->
            {false, ?MISSING_CONFIG}
    end.
%% 基本检测
base_check(Type, SubType, Ps, DynamicCheckList) ->
    #player_status{figure = #figure{lv = RoleLv}, tid = Tid} = Ps,
    case lib_custom_act_util:get_act_cfg_info(Type, SubType) of 
        #custom_act_cfg{condition = Condition} ->
            {role_lv, RoleLvLimit} = ulists:keyfind(role_lv, 1, Condition, {role_lv, 999}),
            {finish_task_id, TaskId} = ulists:keyfind(finish_task_id, 1, Condition, {finish_task_id, 0}),
            CheckList = 
                [
                    {role_lv, RoleLv, RoleLvLimit}
                    , {is_open_act, Type, SubType}
                    , {finish_task_id, TaskId, Tid}
                ],
            check(CheckList ++ DynamicCheckList);
        _ ->
            {false, ?MISSING_CONFIG}
    end.

%% 条件检查
check([]) -> true;
check([H|T]) ->
    case do_check(H) of 
        true ->
            check(T);
        {false, ErrCode} ->
            {false, ErrCode}
    end.

do_check({role_lv, RoleLv, RoleLvLimit}) ->
    case RoleLv >= RoleLvLimit of
        true ->
            true;
        false ->
            {false, ?ERRCODE(lv_limit)}
    end;
do_check({is_open_act, Type, SubType}) ->
    case lib_custom_act_api:is_open_act(Type, SubType) of
        true ->
            true;
        false ->
            {false, ?ERRCODE(err331_act_closed)}
    end;
do_check({finish_task_id, TaskId, Tid}) ->
    case TaskId == 0 of 
        true -> %% 为0表示不检测
            true;
        false ->
            case catch mod_task:is_finish_task_id(Tid, TaskId) of 
                true -> true;
                _ -> {false, ?ERRCODE(err204_goal_not_finish)}
            end
    end;
do_check(_) ->
    true.

%% ======================== 秘籍 ========================
%% 重置奖励状态
gm_reset_reward_state(Ps) ->
    F3 = fun() ->
        lib_boss_first_blood_plus:sql_truncate_boss_first_blood_plus_role(),
        lib_boss_first_blood_plus:sql_truncate_boss_first_blood_plus_boss(),
        lib_boss_first_blood_plus:sql_truncate_boss_first_blood_plus_boss_merge(),
        lib_boss_first_blood_plus:sql_truncate_boss_first_blood_plus_data()
    end,
    db:transaction(F3),
    mod_boss_first_blood_plus:reload_data(),
    ets:delete_all_objects(?ETS_FIRST_BLOOD),
    NewPs = Ps#player_status{role_boss_first_blood = #{}},
    pp_boss_first_blood_plus:handle(18801, NewPs, [96, 1]),
    pp_boss_first_blood_plus:handle(18801, NewPs, [96, 2]),
    pp_boss_first_blood_plus:handle(18805, NewPs, [105, 1]),
    NewPs.
    

%% ======================== 获取配置数据 ========================
%% 获取活动玩家等级限制
get_act_role_lv_limit(Type, SubType) ->
    case lib_custom_act_util:get_act_cfg_info(Type, SubType) of
        #custom_act_cfg{condition = Condition} ->
            case lists:keyfind(role_lv, 1, Condition) of
                {role_lv, RoleLvLimit} -> RoleLvLimit;
                _ -> 
                    ?ERR("Type:~p, SubType:~p cfg condition miss", [Type, SubType]), 
                    108
            end;
        _ ->
            ?ERR("Type:~p, SubType:~p cfg miss", [Type, SubType]), 
            108
    end.

%% 获取活动玩家的任务限制
get_act_task_limit(Type, SubType) ->
    case lib_custom_act_util:get_act_cfg_info(Type, SubType) of
        #custom_act_cfg{condition = Condition} ->
            case lists:keyfind(finish_task_id, 1, Condition) of
                {finish_task_id, TaskId} -> TaskId;
                _ -> 
                    ?ERR("Type:~p, SubType:~p cfg condition miss", [Type, SubType]), 
                    100970
            end;
        _ ->
            ?ERR("Type:~p, SubType:~p cfg miss", [Type, SubType]), 
            100970
    end.

%% 获取服务端配置
get_config_value(Key) ->
    case Key of 
        pass_rank_num -> 5;
        _ -> 0
    end.

%% ======================== 内存数据结构操作 ========================
%% 获取首杀data域排行榜数据
get_data(pass_rank, [BossInfo]) ->
    case is_record(BossInfo, boss_info) of 
        true ->
            BossInfoData = BossInfo#boss_info.data,
            {?PASS_RANK, PassRankData} = ulists:keyfind(?PASS_RANK, 1, BossInfoData, {?PASS_RANK, []}),
            PassRankData;
        false -> []
    end;
get_data(_, _) -> [].

%% 更新首杀公共进程boss map数据
update_data(boss_map, [Type, SubType, ObjectId, BossInfo, BossInfoList, BossMap]) ->
    NewBossInfoList = lists:keystore(ObjectId, #boss_info.object_id, BossInfoList, BossInfo),
    maps:put({Type, SubType}, NewBossInfoList, BossMap);
%% 更新首杀data字段
update_data(boss_info_data, [RoleId, RankRoleList, PassRuneDunRole, Data]) ->
    NewRankRoleList = lists:keystore(RoleId, #pass_dun_role.role_id, RankRoleList, PassRuneDunRole),
    lists:keystore(?PASS_RANK, 1, Data, {?PASS_RANK, NewRankRoleList});
%% 更新玩家身上role map
update_data(role_map, [Type, SubType, ObjectId, RoleInfoList, RoleInfo, RoleMap]) ->
    NewRoleInfoList = lists:keystore(ObjectId, #role_info.boss_id, RoleInfoList, RoleInfo),
    maps:put({Type, SubType}, NewRoleInfoList, RoleMap);
update_data(_, _) -> [].



%% =========== boss_first_blood_plus_role 表操作 ========

%% 根据角色id查询玩家数据
sql_select_role_by_role_id(RoleId) ->
    db:get_all(io_lib:format(?sql_select_role_by_role_id, [RoleId])).

%% 插入玩家记录
sql_replace_boss_first_blood_plus_role(Type, SubType, RoleId, BossId, RewardState, SharedState) ->
    db:execute(io_lib:format(?sql_replace_boss_first_blood_plus_role, [Type, SubType, RoleId, BossId, RewardState, SharedState])).

%% 清空玩家记录
sql_truncate_boss_first_blood_plus_role() ->
    db:execute(io_lib:format(?sql_truncate_boss_first_blood_plus_role, [])).

%% 更新玩家领取状态
sql_update_boss_first_blood_plus_role_reward_state(RewardState, RoleId, Type, SubType, BossId) ->
    db:execute(io_lib:format(?sql_update_boss_first_blood_plus_role_reward_state, [RewardState, RoleId, Type, SubType, BossId])).   



%% =========== boss_first_blood_plus_boss 表操作 =========

%% 查询boss数据
sql_select_boss() ->
    db:get_all(io_lib:format(?sql_select_boss, [])).

%% 击杀boss插入boss记录
sql_replace_boss_first_blood_plus_boss(Type, SubType, BossId, KillerId, RewardState) ->
    db:execute(io_lib:format(?sql_replace_boss_first_blood_plus_boss, [Type, SubType, BossId, KillerId, RewardState])).

%% 清空boss记录
sql_truncate_boss_first_blood_plus_boss() ->
    db:execute(io_lib:format(?sql_truncate_boss_first_blood_plus_boss, [])).



%% =========== boss_first_blood_plus_boss_merge 表操作 =========

%% 查询未领取奖励的首杀boss记录
sql_select_boss_first_blood_plus_boss_merge(RewardState) ->
    db:get_all(io_lib:format(?sql_select_boss_first_blood_plus_boss_merge, [RewardState])).

%% 击杀boss插入boss记录
sql_replace_boss_first_blood_plus_boss_merge(Type, SubType, BossId, KillerId, RewardState) ->
    db:execute(io_lib:format(?sql_replace_boss_first_blood_plus_boss_merge, [Type, SubType, BossId, KillerId, RewardState])).

%% 清空merge表
sql_truncate_boss_first_blood_plus_boss_merge() ->
    db:execute(io_lib:format(?sql_truncate_boss_first_blood_plus_boss_merge, [])).


%% 清空活动数据
sql_delete_boss_first_blood_plus_boss_merge(Type, SubType) ->
    db:execute(io_lib:format(?sql_delete_boss_first_blood_plus_boss_merge, [Type, SubType])).



%% =========== boss_first_blood_plus_data 表操作 =========
sql_select_boss_first_blood_plus_data() ->
    db:get_all(io_lib:format(?sql_select_boss_first_blood_plus_data, [])).

sql_replace_boss_first_blood_plus_data(Type, SubType, ObjectId, Data) ->
    DataStr = util:term_to_string(Data),
    db:execute(io_lib:format(?sql_replace_boss_first_blood_plus_data, [Type, SubType, ObjectId, DataStr])).

sql_truncate_boss_first_blood_plus_data() ->
    db:execute(io_lib:format(?sql_truncate_boss_first_blood_plus_data, [])).