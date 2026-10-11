%% ---------------------------------------------------------------------------
%% @doc lib_hi_point

%% @author  lzh
%% @email   lu13824949032@gmail.com
%% @since   2019/10/12
%% @deprecated
%% ---------------------------------------------------------------------------
-module(lib_hi_point).

%% API
-compile([export_all]).
-include("common.hrl").
-include("server.hrl").
-include("custom_act.hrl").
-include("hi_point.hrl").
-include("figure.hrl").
-include("mount.hrl").
-include("def_module.hrl").
-include("dragon.hrl").
-include("goods.hrl").
-include("def_goods.hrl").
-include("soul.hrl").
-include("def_fun.hrl").
-include("rec_baby.hrl").
-include("predefine.hrl").

%% 用户登陆
login(PS) ->
    #player_status{id = RoleId, figure = #figure{lv = Lv}} = PS,
    SubList = lib_custom_act_api:get_open_subtype_ids(?CUSTOM_ACT_TYPE_HI_POINT),
    F = fun(SubType) ->
        case lib_custom_act_api:is_open_act(?CUSTOM_ACT_TYPE_HI_POINT, SubType) of
            true ->
                PoiList = load_hi_info(PS, SubType),
                mod_hi_point:sync_user_info(SubType, RoleId,Lv, PoiList);
            false -> skip
        end
    end,
    lists:foreach(F, SubList),
%%    PoiList = load_hi_info(PS, ?PERSON_SUBTYPE),
%%    mod_hi_point:sync_user_info(?PERSON_SUBTYPE, RoleId,Lv, PoiList),
    PS.

%% 加载信息
load_hi_info(PS, SubType) ->
    #player_status{figure = Figure} = PS,
    List1 = load_level_info(Figure, SubType, []),
    List2 = load_mount_info(PS, SubType, List1),
    List3 = load_mount_info2(PS, SubType, List2),
    List4 = load_dragon_info(PS, SubType, List3),
    List5 = load_soul_info(PS, SubType, List4),
    load_baby_info(PS, SubType, List5).


load_level_info(Figure, SubType, PoiList) ->
    Lv = Figure#figure.lv,
    Point = cal_single_point(lv, SubType,?MOD_LEVEL, ?SUB_ID, Lv),
    Item = #hi_points{key = {?MOD_LEVEL, ?SUB_ID, lv}, count = Figure#figure.lv, utime = utime:unixtime(), point = Point},
    [Item|PoiList].

load_mount_info(PS, SubType, PoiList) ->
    StatusMount = PS#player_status.status_mount,
    ResList = case lists:keyfind(?MATE_ID, #status_mount.type_id, StatusMount) of
        false -> PoiList;
        #status_mount{stage = Stage1, star = Star1} ->
            Point1 = cal_single_point(stage, SubType,?MOD_MOUNT, ?MATE_ID, {Stage1, Star1}),
            Item2 = #hi_points{key = {?MOD_MOUNT, ?MATE_ID, stage}, count = {Stage1, Star1}, utime = utime:unixtime(), point = Point1},
            [Item2 | PoiList]
    end,
    ResList.

load_mount_info2(PS, SubType, PoiList) ->
    StatusMount = PS#player_status.status_mount,
    PoiList1 = case lists:keyfind( ?MOUNT_ID,#status_mount.type_id,StatusMount) of
                   false -> PoiList;
                   #status_mount{stage = Stage, star = Star} ->
                       Point = cal_single_point(stage, SubType,?MOD_MOUNT, ?MOUNT_ID, {Stage, Star}),
                       Item1 = #hi_points{key = {?MOD_MOUNT, ?MOUNT_ID, stage}, count = {Stage, Star}, utime = utime:unixtime(), point = Point},
                       [Item1 | PoiList]
               end,
    PoiList1.

load_dragon_info(PS, SubType, PoiList) ->
    GoodsStatus = lib_goods_do:get_goods_status(),
    Dict = GoodsStatus#goods_status.dict,
    #status_dragon{pos_list = PosList} = PS#player_status.dragon,
    F = fun(#dragon_pos{ pos = Pos}, MaxLv) ->
        GoodInfo = lib_goods_util:get_goods_by_cell(PS#player_status.id, ?GOODS_LOC_DRAGON_EQUIP, Pos, Dict),
        case is_record(GoodInfo, goods) of
            true ->
                #goods{color = Color, level = Lv} = GoodInfo,
                case Color >= 3 of %% 紫色以上
                    true ->  ?IF(MaxLv =< Lv, Lv, MaxLv);
                    false -> MaxLv
                end;
            false -> MaxLv
        end
    end,
    MaxLv = lists:foldl(F, 0, PosList),
    Point = cal_single_point(set, SubType,?MOD_DRAGON, ?SUB_ID, MaxLv),
    Item = #hi_points{key = {?MOD_DRAGON, ?SUB_ID, set}, count = MaxLv, utime = utime:unixtime(), point = Point},
    [Item | PoiList].

load_soul_info(PS, SubType, PoiList) ->
    GoodsStatus = lib_goods_do:get_goods_status(),
    Dict = GoodsStatus#goods_status.dict,
    PosList = data_soul:get_soul_pos_list(),  % 获取所有聚魂位置
    F = fun(Pos, {MaxLv, CNum}) ->
        GoodInfo = lib_goods_util:get_goods_by_cell(PS#player_status.id, ?GOODS_LOC_SOUL, Pos, Dict),
        case is_record(GoodInfo, goods) of
            true ->
                #goods{level = Lv, color = Color} = GoodInfo,
                {?IF(Lv >= MaxLv, Lv, MaxLv), ?IF(Color >=4, CNum + 1, CNum)};
            false -> {MaxLv, CNum}
        end
        end,
    {LastLv, OrangeNum} = lists:foldl(F, {0, 0}, PosList),
    Point1 = cal_single_point(lv, SubType,?MOD_SOUL, ?SUB_ID, LastLv),
    Point2 = cal_single_point(set, SubType,?MOD_SOUL, ?SUB_ID, OrangeNum),
    Item1 = #hi_points{key = {?MOD_SOUL, ?SUB_ID, lv}, count = LastLv, utime = utime:unixtime(), point = Point1},
    Item2 = #hi_points{key = {?MOD_SOUL, ?SUB_ID, set}, count = OrangeNum, utime = utime:unixtime(), point = Point2},
    [Item1, Item2] ++ PoiList.

load_baby_info(PS, SubType, PoiList) ->
    StatusBaby = PS#player_status.status_baby,
    Lv = StatusBaby#status_baby.raise_lv,
    Stage = StatusBaby#status_baby.stage,
    Point1 = cal_single_point(lv, SubType,?MOD_BABY, ?SUB_ID, Lv),
    Point2 = cal_single_point(count, SubType,?MOD_BABY, ?SUB_ID, Stage),
    Item1 = #hi_points{key = {?MOD_BABY, ?SUB_ID, lv}, count = Lv, utime = utime:unixtime(), point = Point1},
    Item2 = #hi_points{key = {?MOD_BABY, ?SUB_ID, count}, count = Stage, utime = utime:unixtime(), point = Point2},
    [Item1, Item2] ++ PoiList.

%%===========================================================================================================
%% 用户同步数据
%% 一些需要累积任务次数的嗨点任务会保存到数据库
%% 这些需要同步的只需登录时加载同步即可（等级，强化等级等）
sync_user_info(State, SubType, RoleId, Lv, PolList) when SubType == ?PERSON_SUBTYPE ->
%%    ?DEBUG("@tong_bu_ge_ren_shu_ju", []),
    case is_open_per_hi(Lv) of
        false -> State;
        true ->
            #act_state{act_maps = ActMaps} = State,
            RoleMap = maps:get(SubType, ActMaps, #{}),
            CDay = data_hi_point:get(continute_day),
            {Stime, Etime} = get_stime_etime(RoleId, ?PERSON_SUBTYPE),
            case Stime == 0 andalso Etime == 0 of
                true ->
                    NStime = utime:unixtime(), NEtime = CDay * 3600 *24 + NStime,
                    db:execute(io_lib:format(?replace_hi_points_per_status, [RoleId, NStime, NEtime])),
                    RoleInfo = maps:get(RoleId, RoleMap, #role_info{}),
                    #role_info{points_list = OldPolList} = RoleInfo,
                    NewPolList = replace_point_list(OldPolList, PolList),
                    NewRoleInfo = #role_info{points_list = NewPolList, etime = NEtime, stime = NStime, utime = NStime},
                    NewRoleInfoTmp = cal_sum_point(NewRoleInfo, SubType),
                    LastRoleInfo = cal_reward_stage(NewRoleInfoTmp, SubType, RoleId),
                    save_poiList(RoleId, SubType, PolList),
                    NewRoleMap = maps:put(RoleId, LastRoleInfo, RoleMap),
                    NewActMap = maps:put(SubType, NewRoleMap, ActMaps),
                    State#act_state{act_maps = NewActMap};
                false ->
                    case maps:get(RoleId, RoleMap, false) of
                        false -> State;
                        OldRoleInfo ->
                            OldPolList = OldRoleInfo#role_info.points_list,
%%                    NewPolList = [lists:keystore(Key, #hi_points.key, OldPolList, HiPoint) || #hi_points{key = Key} = HiPoint <- PolList],
                            NewPolList = replace_point_list(OldPolList, PolList),
%%                    ?MYLOG("zh", "@@@@@@@@@@@@@@@@@@NewPolList ~p ~n", [NewPolList]),
                            RoleInfo = OldRoleInfo#role_info{utime = utime:unixtime(), points_list = NewPolList},
                            NewRoleInfo = cal_sum_point(RoleInfo, SubType),
                            LastRoleInfo = cal_reward_stage(NewRoleInfo, SubType, RoleId),
                            save_poiList(RoleId, SubType, PolList),
                            NewRoleMap = maps:put(RoleId, LastRoleInfo, RoleMap),
                            NewActMap = maps:put(SubType, NewRoleMap, ActMaps),
                            State#act_state{act_maps = NewActMap}
                    end
            end
    end ;
sync_user_info(State, SubType, RoleId, _Lv, PolList) ->
    #act_state{act_maps = ActMaps} = State,
    RoleMap = maps:get(SubType, ActMaps, #{}),
    OldRoleInfo = maps:get(RoleId, RoleMap, #role_info{}),
    OldPolList = OldRoleInfo#role_info.points_list,
    NewPolList = replace_point_list(OldPolList, PolList),
%%    NewPolList = [lists:keystore(Key, #hi_points.key, OldPolList, HiPoint) || #hi_points{key = Key} = HiPoint <- PolList],
%%    ?MYLOG("zh","@@@@NewPolList ~p ~n", [NewPolList]),
    RoleInfo = OldRoleInfo#role_info{utime = utime:unixtime(), points_list = NewPolList},
    NewRoleInfo = cal_sum_point(RoleInfo, SubType),
    LastRoleInfo = cal_reward_stage(NewRoleInfo, SubType,RoleId),
    save_poiList(RoleId, SubType, PolList),
    NewRoleMap = maps:put(RoleId, LastRoleInfo, RoleMap),
    NewActMap = maps:put(SubType, NewRoleMap, ActMaps),
    State#act_state{act_maps = NewActMap}.

save_poiList(RoleId, SubType, PoiList) ->
    F = fun(HiPoint, Summary) ->
            #hi_points{key = {ModId, SubId, ConditionType}, count = Count} = HiPoint,
            [[RoleId, SubType,ModId, SubId, util:term_to_string(ConditionType), util:term_to_string(Count), 0, utime:unixtime()]|Summary]
        end,
    UpdateList = lists:foldl(F, [], PoiList),
    Sql = usql:replace(hi_points_act, [role_id, sub_type, mod_id, sub_id, condition_type,  count, is_plus, utime], UpdateList),
    ?IF(Sql =/= [], db:execute(Sql), skip).
    % [save_hi_point_status(RoleId, SubType,ModId, SubId, ConditionType, Count)
    %     ||#hi_points{key = {ModId, SubId, ConditionType}, count = Count}<-PoiList].

replace_point_list(OldList, NewList) ->
    F = fun(HiPoint, NextList) ->
        Key = HiPoint#hi_points.key,
        lists:keystore(Key, #hi_points.key, NextList, HiPoint)
        end,
    lists:foldl(F, OldList, NewList).

%% 发送嗨点活动
send_all_info(State, RoleId, _Lv) ->
    #act_state{act_maps = ActMap} = State,
    RoleMap = maps:get(?PERSON_SUBTYPE, ActMap, #{}),
    List = case maps:get(RoleId, RoleMap, false) of
               #role_info{etime = ETime, stime = STime} ->
                   case ETime > utime:unixtime() of
                       true -> [{?CUSTOM_ACT_TYPE_HI_POINT, ?PERSON_SUBTYPE, ?ACT_NAME, STime, ETime, get_show_id(?PERSON_SUBTYPE)}];
                       false -> []
                   end;
               false -> []
           end,
    OpenList = lib_custom_act_api:get_open_custom_act_infos(?CUSTOM_ACT_TYPE_HI_POINT),
    F = fun(#act_info{key = {Type, SubType}, etime = Etime, stime = Stime}, SList) ->
        ActName = lib_custom_act_api:get_act_name(Type, SubType),
        [{Type, SubType, ActName, Stime, Etime, get_show_id(SubType)}|SList]
        end,
    FList = lists:foldl(F, List, OpenList),
%%    {ok, BinData} = pt_333:write(33300, [FList]),
%%    ?PRINT("FList ~p ~n ~n", [FList]),
    lib_server_send:send_to_uid(RoleId, pt_333, 33300, [FList]).

%% 发送奖励状态
deal_send_reward(State, SubType, RoleId, RoleInfo) ->
    #role_info{reward_status = RewardStatus} = RoleInfo,
    CfgList = get_reward_cfg(SubType),
    ConditionList = get_reward_condition(SubType),
    NewRewardStatus =
        case RewardStatus == [] of
            true -> first_load_reward(SubType, RoleId, ConditionList);
            false -> RewardStatus
        end,
    F = fun(Item, RList) ->
        #custom_act_reward_cfg{grade = Grade, format = Format, name = Name, desc = Desc, condition = Condition, reward = Reward} = Item,
        case lists:keyfind(Grade, 1 , NewRewardStatus) of
            {Grade, RStatus} ->
                [{Grade, Format, RStatus, RStatus, Name, Desc, util:term_to_string(Condition), util:term_to_string(Reward)}| RList];
            _ -> RList
        end
        end,
    RewardList = lists:foldl(F, [], CfgList),
    {ok, Data} = pt_333:write(33303, [?CUSTOM_ACT_TYPE_HI_POINT, SubType, RewardList]),
%%    ?PRINT("@@@Data ~p ~n ~p", [Data, RewardList]),
    lib_server_send:send_to_uid(RoleId, Data),
    #act_state{act_maps = ActMap} = State,
    RoleMap = maps:get(SubType, ActMap),
    RoleInfo = maps:get(RoleId, RoleMap),
    NewRoleMap = maps:put(RoleId, RoleInfo#role_info{reward_status = NewRewardStatus}, RoleMap),
    State#act_state{act_maps = maps:put(SubType, NewRoleMap, ActMap)}.

%% 用户升级时调用判断是否达到开启状况
%% 且添到任务
check_role_status(State, RoleId, Lv) ->
%%    ?PRINT("@@@panduan _yong_ shengjio~n~n", []),
    #act_state{act_maps = ActMap} = State,
    RoleMap = maps:get(?PERSON_SUBTYPE, ActMap, #{}),
    case maps:get(RoleId, RoleMap, false) of
        #role_info{etime = Etime} ->
            case Etime > utime:unixtime() of
                true -> complete_task_self_act(State, [RoleId, ?MOD_LEVEL, ?SUB_ID, lv, Lv]);
                false -> {ok, State}
            end;
        false ->
            case is_open_per_hi(Lv) of
                true -> %% 到达开启活动条件
                    CDay = data_hi_point:get(continute_day),
                    Stime = utime:unixtime(),
                    Etime = Stime + CDay*3600*24,
                    Sql = io_lib:format(?replace_hi_points_per_status, [RoleId, Stime, Etime]),
                    db:execute(Sql),
                    %% 推送消息
                    mod_hi_point:all_info(RoleId, Lv),
                    HiPoint = #hi_points{key = {?MOD_LEVEL, ?SUB_ID, lv}, count = Lv, utime = Stime},
                    RoleInfo = #role_info{utime = Stime, stime = Stime, etime = Etime, points_list = [HiPoint] },
                    NewRoleInfo = cal_sum_point(RoleInfo, ?PERSON_SUBTYPE),
                    LastRoleInfo = cal_reward_stage(NewRoleInfo, ?PERSON_SUBTYPE,RoleId),
                    NewRoleMap = maps:put(RoleId, LastRoleInfo, RoleMap),
                    NewState = State#act_state{act_maps = maps:put(?PERSON_SUBTYPE, NewRoleMap, ActMap)},
                    send_all_info(NewState, RoleId, Lv),
                    {ok, NewState};
                false -> {ok, State}
            end
    end.

%% 发送嗨点信息
send_hi_info(State, SubType, RoleId, Lv) ->
    #act_state{act_maps = ActMaps} = State,
    RoleMap = maps:get(SubType, ActMaps, #{}),
    #role_info{sum_points = SumPots, points_list = PotList} = maps:get(RoleId, RoleMap, #role_info{}),
%%    ?PRINT("@@RoleInfo ~p ~n ~n", [RoleInfo]),
    Keys = data_hi_point:get_keys(),
    AllHiPointsTmp = get_all_hi_points(SubType, Keys, PotList),
    AllHiPoints = lists:keydelete({0,0,single}, #hi_points.key, AllHiPointsTmp), %% 过滤嗨点之灵不显示
%%    ?MYLOG("HI", "ALLHIPOINT ~p", [AllHiPoints]),
    F = fun(HiPoint, ResList) ->
        #hi_points{key = {ModId, SubId, ConditionType}, count = Count, point = Point} = HiPoint,
        case data_hi_point:get_hi_point_cfg(SubType,ModId, SubId) of
            #base_hi_point{name = Name, order_id = OrderId, jump_id = JumpId, icon_type = IConType,
                reward_condition = ConList, is_process = IsP, min_lv = MinLv, max_lv = MaxLv, is_single = IsSigle, max_points = MaxPoint, one_points = OnePoint} ->
%%                ?MYLOG("zh", "SubType,ModId, SubId ~p ~p ~p", [SubType,ModId, SubId]),
                HiPointList = case IsSigle == 0 of
                                  true -> [
                                      pack_res_item(ModId, SubId, ConditionType, Count, Point, Name, OrderId, JumpId, IConType,IsP, Con) ||
                                      {CType, _CNum, _CPoint, _Desc} = Con <- ConList , Lv >= MinLv andalso Lv =< MaxLv, CType == ConditionType
                                  ];
                                  false -> ?IF(Lv >= MinLv andalso Lv =< MaxLv, [pack_res_singl_item(ModId, SubId, ConditionType, Count, MaxPoint,OnePoint, Name, OrderId, JumpId, IConType,IsP)], [])
                              end,
                HiPointList ++ ResList;
%%                get_mod_list(ModId, SubId, ConditionType, Count, Point, Name, OrderId, JumpId, IConType,IsP, MLv, Lv, ConList, []) ++ ResList;
            _ ->
                ResList
        end
        end,
    SendList = lists:foldl(F, [], AllHiPoints),
%%    ?MYLOG("zh", "SendList ~p ~n", [SendList]),
    lib_server_send:send_to_uid(RoleId, pt_333, 33302, [?CUSTOM_ACT_TYPE_HI_POINT,SubType, SumPots, SendList]).

get_all_hi_points(_SubType, [], PotList) -> PotList;
get_all_hi_points(SubType, [{SubType, ModId, SubId}|Other], PotList) ->
    #base_hi_point{reward_condition = RewCon, is_single = IsSingle} = data_hi_point:get_hi_point_cfg(SubType, ModId, SubId),
    NewPoiList = case IsSingle == 1 of
                     false ->
                         F = fun({CType, _, _, _}, List) ->
                             case lists:keyfind({ModId, SubId,CType}, #hi_points.key, List) of
                                 false -> [#hi_points{key = {ModId, SubId,CType}}|List];
                                 _ -> List
                             end
                             end,
                         lists:foldl(F, PotList, RewCon);
                     true ->
                         case lists:keyfind({ModId, SubId,?SINGLE}, #hi_points.key, PotList) of
                             false -> [#hi_points{key = {ModId, SubId,?SINGLE}}|PotList];
                             _ -> PotList
                         end
                 end,
    get_all_hi_points(SubType, Other, NewPoiList);
get_all_hi_points(SubType, [_|Other], PotList) -> get_all_hi_points(SubType, Other, PotList).

% 打包
pack_res_item(ModId, SubId, ConditionType, Count, _Point, Name, OrderId, JumpId, IConType,IsP, {ConditionType, CNum, CPoint, Desc}) ->
    {ProValue, IsCom} = case is_number(CNum) of
                            true -> ?IF(Count>=CNum, {Count, 1}, {Count, 0});
                            false ->
                                {Stage, Star} =
                                    case is_number(Count) of
                                        true -> {0, 0};
                                        false -> Count
                                    end,
                                {CStage, CStar} = CNum,
                                if
                                    Stage > CStage -> {1, 1};
                                    Stage == CStage ->
                                        if
                                            Star >= CStar -> {1, 1};
                                            true -> {0, 0}
                                        end;
                                    true -> {0, 0}
                                end
                        end,
    MBVal = case is_number(CNum) of
                true -> CNum;
                false -> 1
            end,
    {ModId,SubId,atom_to_list(ConditionType),Name,OrderId,JumpId,0,IConType,ProValue,IsP, MBVal, CPoint, data_hi_point:get_desc(Desc), IsCom}.

pack_res_singl_item(ModId, SubId, ConditionType, Count, MaxPoint, OnePoint, Name, OrderId, JumpId, IConType,IsP) ->
    IsCom = ?IF(MaxPoint > Count * OnePoint, 0, 1),
    {ModId, SubId, atom_to_list(ConditionType), Name, OrderId, JumpId,0, IConType, Count, IsP, (MaxPoint div OnePoint), OnePoint, Name, IsCom}.


%% 零点主动推送
push_info(State) ->
    #act_state{act_maps = ActMap} = State,
    OpenList = lib_custom_act_api:get_open_custom_act_infos(?CUSTOM_ACT_TYPE_HI_POINT),
    F = fun(#act_info{key = {Type, SubType}, etime = Etime, stime = Stime}, SList) ->
        ActName = lib_custom_act_api:get_act_name(Type, SubType),
        [{Type, SubType, ActName, Stime, Etime, get_show_id(SubType)}|SList]
        end,
    FList = lists:foldl(F, [], OpenList),
    Now = utime:unixtime(),
    OnlineList = ets:tab2list(?ETS_ONLINE),
    case maps:get(?PERSON_SUBTYPE, ActMap, false) of
        false ->
            [
                lib_server_send:send_to_uid(RoleId, pt_333, 33300, [FList])
                || #ets_online{id = RoleId} <- OnlineList
            ];
        RoleMap ->
            [
                case maps:get(RoleId, RoleMap, false) of
                    false -> lib_server_send:send_to_uid(RoleId, pt_333, 33300, [FList]);
                    #role_info{etime = ETime, stime = STime} ->
                        case ETime > Now of
                            false -> lib_server_send:send_to_uid(RoleId, pt_333, 33300, [FList]);
                            true ->
                                Item = {?CUSTOM_ACT_TYPE_HI_POINT, ?PERSON_SUBTYPE, ?ACT_NAME, STime, ETime, get_show_id(?PERSON_SUBTYPE)},
                                SenlList = [Item|FList],
                                lib_server_send:send_to_uid(RoleId, pt_333, 33300, [SenlList])
                        end
                end
                || #ets_online{id = RoleId} <- OnlineList
            ]
    end.


complete_task_self_act(State, [RoleId, ModId, SubId, ConditionType, Count]) ->
    #act_state{act_maps = ActMap} = State,
    RoleMap = maps:get(?PERSON_SUBTYPE, ActMap, #{}),
    case maps:get(RoleId, RoleMap, false) of
        false -> complete_task(State, [?PERSON_SUBTYPE, RoleId, ModId, SubId, ConditionType, Count]);
        #role_info{etime = ETime} ->
            case ETime > utime:unixtime() of
                true -> complete_task(State, [?PERSON_SUBTYPE, RoleId, ModId, SubId, ConditionType, Count]);
                false -> {ok, State}
            end
    end.
complete_task(State, [RoleId, ModId, SubId, ConditionType, Count]) ->
    complete_task_self_act(State, [RoleId, ModId, SubId, ConditionType, Count]);
complete_task(State, [SubType, RoleId, ModId, SubId, ConditionType, Count]) ->
    case data_hi_point:get_hi_point_cfg(SubType, ModId, SubId) of
        [] ->
            ?PRINT("no config ~p ~p ~p ~n", [ModId, SubId, ConditionType]),
            {ok, State};
        _ ->
            #act_state{act_maps = ActMap} = State,
            RoleMap = maps:get(SubType, ActMap, #{}),
            RoleInfo = maps:get(RoleId, RoleMap, #role_info{}),
            NewRoleInfo = complete_task_do(RoleId,SubType,ModId, SubId, ConditionType, Count, RoleInfo),
            LastRoleInfoTmp = cal_sum_point(NewRoleInfo, SubType),
            LastRoleInfo = cal_reward_stage(LastRoleInfoTmp, SubType,RoleId),
            send_33305(SubType, LastRoleInfo, RoleId,ModId, SubId, ConditionType),
            case RoleInfo#role_info.sum_points == LastRoleInfoTmp#role_info.sum_points of
                true -> skip;
                false ->
                    lib_log_api:log_hi_points(SubType, RoleId, ModId, SubId, RoleInfo#role_info.sum_points, LastRoleInfoTmp#role_info.sum_points),
                    lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, ta_agent_fire, log_hi_points, [SubType, ModId, SubId, RoleInfo#role_info.sum_points, LastRoleInfoTmp#role_info.sum_points])
            end,
            NewRoleMap = maps:put(RoleId, LastRoleInfo, RoleMap),
            NewActMap = maps:put(SubType, NewRoleMap, ActMap),
            {ok, State#act_state{act_maps = NewActMap}}
    end.


%% 次数替换 镶嵌个数特殊处理
complete_task_do(RoleId,SubType,ModId, SubId, ConditionType, Count, RoleInfo) when ConditionType==set orelse ConditionType==lv ->
    #role_info{points_list = PoList} = RoleInfo,
    NewHiPoint = case lists:keyfind({ModId, SubId, ConditionType}, #hi_points.key, PoList) of
                     false ->
                         case data_hi_point:get_hi_point_cfg(SubType, ModId, SubId) of
                             [] -> skip;
                             _ -> #hi_points{key = {ModId, SubId, ConditionType}, count = Count, utime = utime:unixtime()}
                         end;
                     #hi_points{} = HiPoint ->
                         HiPoint#hi_points{count = Count, utime = utime:unixtime()}
                 end,
    if
        NewHiPoint == skip -> RoleInfo;
        true ->
            save_hi_point_status(RoleId, SubType,ModId, SubId, ConditionType, NewHiPoint#hi_points.count),
            NewPoList = lists:keystore({ModId, SubId, ConditionType}, #hi_points.key, PoList, NewHiPoint),
            RoleInfo#role_info{points_list = NewPoList}
    end;
% %% 充值特殊处理
% complete_task_do(RoleId,SubType,ModId, SubId, ConditionType, Count, RoleInfo) when ConditionType==recharge ->
%     #role_info{points_list = PoList} = RoleInfo,
%     NewHiPoint = case lists:keyfind({ModId, SubId, ConditionType}, #hi_points.key, PoList) of
%                      false ->
%                          #hi_points{key = {ModId, SubId, ConditionType}, count = Count, utime = utime:unixtime()};
%                      #hi_points{count = OldCount, utime = Utime} = HiPoint ->
%                          case utime:is_same_day(Utime, utime:unixtime()) of
%                              false ->
%                                  HiPoint#hi_points{count = OldCount + Count, utime = utime:unixtime()};
%                              true -> HiPoint
%                          end
%                  end,
%     save_hi_point_status(RoleId, SubType,ModId, SubId, ConditionType, NewHiPoint#hi_points.count),
%     NewPoList = lists:keystore({ModId, SubId, ConditionType}, #hi_points.key, PoList, NewHiPoint),
%     RoleInfo#role_info{points_list = NewPoList};
%% 坐骑升阶
complete_task_do(RoleId, SubType,ModId, SubId, ConditionType, Tuple, RoleInfo) when ConditionType == stage ->
    #role_info{points_list = PoList} = RoleInfo,
    NewHiPoint = case lists:keyfind({ModId, SubId, ConditionType}, #hi_points.key, PoList) of
                     false ->
                         #hi_points{key = {ModId, SubId, ConditionType}, count = Tuple, utime = utime:unixtime()};
                     HiPoint ->
                         HiPoint#hi_points{count = Tuple, utime = utime:unixtime()}
                 end,
    save_hi_point_status(RoleId, SubType,ModId, SubId, ConditionType, NewHiPoint#hi_points.count),
    NewPoList = lists:keystore({ModId, SubId, ConditionType}, #hi_points.key, PoList, NewHiPoint),
    RoleInfo#role_info{points_list = NewPoList};
%% 登录
complete_task_do(RoleId, SubType,ModId, SubId, ConditionType, Count, RoleInfo) when ModId =:= 102 andalso SubId =:= ?SUB_ID ->
    #role_info{points_list = PoList} = RoleInfo,
    NewHiPoint = case lists:keyfind({ModId, SubId, ConditionType}, #hi_points.key, PoList) of
                     % 第一次登录
                     false ->
                         #hi_points{key = {ModId, SubId, ConditionType}, count = Count, utime = utime:unixtime()};
                     #hi_points{count = OldCount, utime = OldTime} = HiPoint ->
                         case utime:unixdate() =:= utime:unixdate(OldTime) of
                             true -> HiPoint;
                             _ ->
                                HiPoint#hi_points{count = OldCount + Count, utime = utime:unixtime()}
                         end
                 end,
    save_hi_point_status(RoleId, SubType,ModId, SubId, ConditionType, NewHiPoint#hi_points.count),
    NewPoList = lists:keystore({ModId, SubId, ConditionType}, #hi_points.key, PoList, NewHiPoint),
    RoleInfo#role_info{points_list = NewPoList};
%%  次数累加 ConditionType = dungeon_xxx / cost
complete_task_do(RoleId,SubType,ModId, SubId, ConditionType, Count, RoleInfo) when is_number(Count) ->
    #role_info{points_list = PoList} = RoleInfo,
    NewHiPoint = case lists:keyfind({ModId, SubId, ConditionType}, #hi_points.key, PoList) of
                     false ->
                         #hi_points{key = {ModId, SubId, ConditionType}, count = Count, utime = utime:unixtime()};
                     #hi_points{count = OldCount} = HiPoint ->
                         HiPoint#hi_points{count = OldCount + Count, utime = utime:unixtime()}
                 end,
    save_hi_point_status(RoleId, SubType,ModId, SubId, ConditionType, NewHiPoint#hi_points.count),
    NewPoList = lists:keystore({ModId, SubId, ConditionType}, #hi_points.key, PoList, NewHiPoint),
    RoleInfo#role_info{points_list = NewPoList};

complete_task_do(_,_,_, _, _, _, RoleInfo) -> RoleInfo.

%% 计算嗨点总值
cal_sum_point(RoleInfo, SubType) ->
    #role_info{points_list = PoList} = RoleInfo,
%%   ?MYLOG("zh", "@@@PoList ~p ~n ~n", [PoList]),
    F = fun(HiPoint, Point) ->
        {ModId, SubId, ConditionType} = HiPoint#hi_points.key,
        Count = HiPoint#hi_points.count,
        AddPoint = cal_single_point(ConditionType, SubType, ModId, SubId, Count),
        LastPoint = Point + AddPoint,
%%        ?MYLOG("zh", "@@@ModId, SubId, ConditionType  ~p ~p ~p ~p ~n ~n", [ModId, SubId, ConditionType, LastPoint]),
        LastPoint
        end,
    SumPoint = lists:foldl(F, 0, PoList),
%%    ?MYLOG("zh", "@@@SumPoint ~p ~n ~n", [SumPoint]),
    RoleInfo#role_info{sum_points = SumPoint}.

%% 计算嗨点值

% 单次任务能添加嗨点
cal_single_point(?SINGLE, SubType,ModId, SubId, Count) ->
    case data_hi_point:get_hi_point_cfg(SubType,ModId, SubId) of
        [] -> 0;
        #base_hi_point{max_points = MaxPoint, one_points = OnePoint} ->
            SPoint = OnePoint*Count,
            ?IF(SPoint > MaxPoint, MaxPoint, SPoint)
    end;
cal_single_point(ConditionType, SubType,ModId, SubId, Count) when is_number(Count) ->
    case data_hi_point:get_hi_point_cfg(SubType,ModId, SubId) of
        [] -> 0;
        #base_hi_point{reward_condition = CondList} ->
%%            ?MYLOG("zh", "@CondList ~p, ConditionType ~p, SubType ~p,ModId ~p, SubId ~p, Count ~p ~n", [CondList, ConditionType, SubType,ModId, SubId, Count]),
            SizeUpList = lists:filter(fun({Type, _, _, _}) -> Type =:= ConditionType end , CondList),
%%            ?MYLOG("zh", "@SizeUpList ~p", [SizeUpList]),
            cal_single_point_core(Count, SizeUpList)
    end;
cal_single_point(ConditionType, SubType,ModId, SubId, Tuple) when is_tuple(Tuple) ->
    case data_hi_point:get_hi_point_cfg(SubType,ModId, SubId) of
        [] -> 0;
        #base_hi_point{reward_condition = CondList} ->
            SizeUpList = lists:filter(fun({Type, _, _, _}) -> Type =:= ConditionType end , CondList),
            cal_single_point_core(Tuple, SizeUpList)
    end.

cal_single_point_core(Count, SizeUpList) when is_number(Count) ->
    F = fun({_, ConNum, Point, _}, AddPoint) ->
            if
                Count >= ConNum ->
                    AddPoint + Point;
                true -> AddPoint
            end
        end,
    Point = lists:foldl(F, 0, SizeUpList),
%%    ?MYLOG("zh", "@SizeUpList ~p, Count ~p, SubType ~p ~n", [SizeUpList, Count, Point]),
    Point;

cal_single_point_core(Tuple, SizeUpList) when is_tuple(Tuple) ->
    {Stage, Star} = Tuple,
    F = fun({_, {ConStage, ConStar}, Point, _}, AddPoint) ->
        if
            Stage > ConStage -> AddPoint + Point;
            Stage == ConStage ->
                if
                    Star >= ConStar ->AddPoint + Point;
                    true -> AddPoint
                end;
            true -> AddPoint
        end
        end,
    Point = lists:foldl(F, 0, SizeUpList),
%%    ?MYLOG("zh", "@SizeUpList ~p, Tuple ~p, SubType ~p ~n", [SizeUpList, Tuple, Point]),
    Point.

%% 计算奖励状态
cal_reward_stage(LastRoleInfo, SubType,RoleId) ->
    #role_info{sum_points = SumPoint, reward_status = RewardStatus} = LastRoleInfo,
    ConditionList = get_reward_condition(SubType),
    NewRewardStatus = case RewardStatus == [] of
        true -> first_load_reward(SubType, RoleId, ConditionList);
        false -> RewardStatus
    end,
    LastRewardStatus = cal_reward_stage_do(RoleId, SubType, SumPoint, NewRewardStatus, ConditionList),
%%    ?PRINT("@LastRewardStatus ~p ~n", [LastRewardStatus]),
    LastRoleInfo#role_info{reward_status = LastRewardStatus}.

cal_reward_stage_do(_RoleId, _SubType, _SumPoint, RewardStatus, []) -> RewardStatus;
cal_reward_stage_do(RoleId, SubType, SumPoint, RewardStatus, [{Grade, Condition}|Conditions]) ->
    F = fun({GradeId, Status}) ->
        case GradeId == Grade andalso Status == ?ACT_REWARD_CAN_NOT_GET of %% 不可领取的时候再判断
            true -> cal_reward_stage_core(RoleId, SubType, Grade, SumPoint, Condition);
            false -> {GradeId, Status}
        end
    end,
    NewRewardStatus = lists:map(F, RewardStatus),
    cal_reward_stage_do(RoleId, SubType, SumPoint, NewRewardStatus, Conditions).

cal_reward_stage_core(RoleId, SubType, GradeId, SumPoint, [{hi_points, NeedPoint}]) ->
    case SumPoint >= NeedPoint of
        true ->
            save_reward_status(RoleId, SubType, GradeId, ?ACT_REWARD_CAN_GET),
            {GradeId, ?ACT_REWARD_CAN_GET};
        false -> {GradeId, ?ACT_REWARD_CAN_NOT_GET}
    end;
cal_reward_stage_core(_RoleId, _SubType, GradeId, _SumPoint, _) -> {GradeId, ?ACT_REWARD_CAN_NOT_GET}.

%% 首次保存奖励状态
first_load_reward(SubType, RoleId, ConditionList) ->
    F = fun({Grade, _}) ->
        save_reward_status(RoleId, SubType, Grade, 0),
        {Grade, 0}
        end,
    lists:map(F, ConditionList).

send_33305(SubType, RoleInfo, RoleId,ModId, SubId, ConditionType) ->
    #role_info{sum_points = SumPoint, points_list = PoiList} = RoleInfo,
    HiPoint = lists:keyfind({ModId, SubId, ConditionType}, #hi_points.key, PoiList),
    case data_hi_point:get_hi_point_cfg(SubType, ModId, SubId) of
        #base_hi_point{reward_condition = RewConList, is_single = IsSigle, name = Name, one_points = OnePoint, max_points = MaxPoint} ->
            SendList = case IsSigle == 0 of
                           true -> get_res_list(ModId, SubId, HiPoint, PoiList,ConditionType, RewConList, []);
                           false -> get_res_list_single(ModId, SubId, HiPoint, OnePoint, MaxPoint, Name)
                       end,
%%            ?PRINT("@@@@@SendList, ~p ~n", [SendList]),
            {ok, BinData} = pt_333:write(33305, [?CUSTOM_ACT_TYPE_HI_POINT, SubType, SumPoint, SendList]),
            lib_server_send:send_to_uid(RoleId, BinData);
        _ -> skip
    end,
    ok.

get_res_list(_ModId, _SubId, _HiPoint, _PoiList, _ConditionType, [], Res) -> Res;
get_res_list(ModId, SubId, HiPoint, PoiList, ConditionType, [{CType,CNum,_CPoint,CName}|Other], Res) ->
    Item = case ConditionType == CType of
        true ->
            #hi_points{count = Count} = HiPoint,
            {ProValue, IsCom} =
                case is_number(CNum) of
                    true -> ?IF(Count>=CNum, {Count, 1}, {Count, 0});
                    false ->
                        {CStage, CStar} = CNum,
                        {Stage, Star} = Count,
                        if
                            Stage > CStage -> {1, 1};
                            Stage == CStage ->
                                if
                                    Star >= CStar -> {1, 1};
                                    true -> {0, 0}
                                end;
                            true -> {0, 0}
                        end
                end,
            {ModId,SubId,atom_to_list(CType),data_hi_point:get_desc(CName),ProValue, IsCom};
        false ->
            case lists:keyfind({ModId, SubId, CType}, #hi_points.key, PoiList) of
                false -> {ModId,SubId,atom_to_list(CType),data_hi_point:get_desc(CName),0, 0};
                #hi_points{count = Count2} ->
                    {ProValue2, IsCom2} =
                        case is_number(CNum) of
                            true -> ?IF(Count2>=CNum, {Count2, 1}, {Count2, 0});
                            false ->
                                {CStage2, CStar2} = CNum,
                                {Stage2, Star2} = Count2,
                                if
                                    Stage2 > CStage2 -> {1, 1};
                                    Stage2 == CStage2 ->
                                        if
                                            Star2 >= CStar2 -> {1, 1};
                                            true -> {0, 0}
                                        end;
                                    true -> {0, 0}
                                end
                        end,
                    {ModId,SubId,atom_to_list(CType),data_hi_point:get_desc(CName),ProValue2, IsCom2}
            end
    end,
    get_res_list(ModId, SubId, HiPoint, PoiList, ConditionType, Other, [Item|Res]).

get_res_list_single(ModId, SubId, HiPoint, OnePoint, MaxPoint, Name) ->
    #hi_points{count = Count} = HiPoint,
    IsCom = ?IF(MaxPoint > OnePoint * Count, 0, 1),
    [{ModId,SubId,atom_to_list(?SINGLE),Name, Count, IsCom}].


get_show_id(SubType) ->
    Keys = data_hi_point:get_keys(),
    case lists:keyfind(SubType, 1, Keys) of
        {SubType,ModId,SubId} ->
            case data_hi_point:get_hi_point_cfg(SubType,ModId,SubId) of
                #base_hi_point{show_id = ShowId} ->
                    ShowId;
                _ -> 0
            end;
        _ -> 0
    end.

%% 发送错误码
send_error_code(RoleId, ErrorCode) ->
    {ok, BinData} = pt_333:write(33306, [ErrorCode]),
    lib_server_send:send_to_uid(RoleId, BinData).

get_reward_cfg(SubType) ->
    List = lib_custom_act_util:get_act_reward_grade_list(?CUSTOM_ACT_TYPE_HI_POINT, SubType),
    List1 = lists:map(
        fun(Grade) ->
            lib_custom_act_util:get_act_reward_cfg_info(?CUSTOM_ACT_TYPE_HI_POINT, SubType, Grade)
        end
   , List),
    lists:filter(fun(Item) -> Item =/= [] end, List1).

get_reward_condition(SubType) ->
    List = lib_custom_act_util:get_act_reward_grade_list(?CUSTOM_ACT_TYPE_HI_POINT, SubType),
    F = fun(Grade, CList) ->
            case lib_custom_act_util:get_act_reward_cfg_info(?CUSTOM_ACT_TYPE_HI_POINT, SubType, Grade) of
                #custom_act_reward_cfg{condition = Condition} -> [{Grade, Condition}|CList];
                _ ->CList
            end
        end,
    lists:foldl(F, [], List).

%% 判断个人嗨点活动是否在开启时间
is_open_per_hi(#player_status{figure = Figure}) ->
    Lv = Figure#figure.lv,
    is_open_per_hi(Lv);
is_open_per_hi(Lv) ->
    OpendDay = util:get_open_day(),
    LimitLv = data_hi_point:get(limit_lv),
    LimitDay = data_hi_point:get(open_day),
    Lv >= LimitLv andalso OpendDay >= LimitDay.

%% ================================db===============================
get_stime_etime(RoleId, ?PERSON_SUBTYPE) ->
    Sql = io_lib:format(?select_hi_points_per_status, [RoleId]),
    Data = db:get_row(Sql),
%%    ?MYLOG("zh", "get_stime_etime sql : ~s ~n ~p", [Sql, Data]),
    case Data of
        [Stime, Etime] -> {Stime, Etime};
        _ -> {0,0}
    end;
get_stime_etime(_RoleId, _SubType) -> {0,0}.

save_hi_point_status(RoleId, SubType,ModId, SubId, ConditionType, Count)  ->
    SQl = io_lib:format(?replace_hi_points, [RoleId, SubType,ModId, SubId, util:term_to_string(ConditionType), util:term_to_string(Count), 0, utime:unixtime()]),
    db:execute(SQl).

save_reward_status(RoleId, SubType, Grade, RewardStatus) ->
    Sql = io_lib:format(?replace_hi_points_reward, [RoleId, SubType, Grade, RewardStatus, utime:unixtime()]),
    db:execute(Sql).