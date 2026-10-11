%% ---------------------------------------------------------------------------
%% @doc lib_cycle_rank

%% @author  lianghaihui
%% @email   1457863678@qq.com
%% @since   2022/03/18
%% @desc    循环冲榜##玩家进程函数处理模块
%% ---------------------------------------------------------------------------

-module(lib_cycle_rank).

%% API
-compile(export_all).

-include("common.hrl").
-include("server.hrl").
-include("def_fun.hrl").
-include("predefine.hrl").
-include("cycle_rank.hrl").
-include("figure.hrl").
-include("errcode.hrl").
-include("goods.hrl").
-include("rec_event.hrl").
-include("def_event.hrl").

login(Ps) ->
    #player_status{ id = PlayerId, figure = #figure{ lv = PlayerLevel } } = Ps,
    case get_data_from_db(PlayerId) of
        List when is_list(List) andalso List =/= [] ->
            F = fun([_RoleId, Type, SubType, Score, RewardState, RewardGot, Other, EndTime], AccL) ->
                FixRewardState = util:bitstring_to_term(RewardState),
                FixRewardGot = util:bitstring_to_term(RewardGot),
                FixOther = util:bitstring_to_term(Other),
                CycleInfo = make_record(Type, SubType, Score, FixRewardState, FixRewardGot, FixOther, EndTime),
                [CycleInfo|AccL]
            end,
            PlayerCycleInfoL = lists:foldl(F, [], List),
            LastPlayerCycleInfoL = check_player_cycle_info(PlayerCycleInfoL, PlayerId, PlayerLevel, PlayerCycleInfoL),
            Ps#player_status{ cycle_rank_data = LastPlayerCycleInfoL };
        _ ->
            Ps
     end.

get_data_from_db(PlayerId) ->
    Sql = io_lib:format(?sql_select_player_cycle_info, [PlayerId]),
    db:get_all(Sql).

make_record(Type, SubType, Score, FixRewardState, FixRewardGot, FixOther, EndTime) ->
    #status_cycle_rank_info{
        id = {Type, SubType},
        type = Type,
        sub_type = SubType,
        score = Score,
        reward_state = FixRewardState,
        reward_got = FixRewardGot,
        other = FixOther,
        end_time = EndTime
    }.

%% 检测玩家活动相关的数据是否存在需要补发目标奖励
check_player_cycle_info([], _, _, LastCycleInfoL) ->
    LastCycleInfoL;
check_player_cycle_info([CycleRankInfo|Tail], PlayerId, PlayerLevel, CycleInfoL) ->
    #status_cycle_rank_info{
        type = Type, sub_type = SubType, reward_state = RewardState, end_time = EndTime, other = Other
    } = CycleRankInfo,
    NowSec = utime:unixtime(),
    case EndTime > NowSec orelse EndTime == 0 of
        true ->
            check_player_cycle_info(Tail, PlayerId, PlayerLevel, CycleInfoL);
        false ->
            IsHasEmail = proplists:get_value(?ACT_REACH_REWARD_EMAIL, Other, 0),
            LevelLimit = data_cycle_rank:get_kv_cfg(rank_level_limit),
            case data_cycle_rank:get_cycle_rank_info(Type, SubType) of
                #base_cycle_rank_info{ open_day = OpenDay }  ->
                    CanDo = util:get_open_day() >= OpenDay;
                _ ->
                    CanDo =  false  %% 增加容错，只要开服天数>=配置的开发天数才可以计算奖励
            end,
            case IsHasEmail == 0 andalso PlayerLevel >= LevelLimit andalso CanDo of
                true -> %% 需要补发邮件
                    F = fun(RewardId, AccL) ->
                        case data_cycle_rank:get_reach_reward_info(Type, SubType, RewardId) of
                            #base_reach_reward_info{ rewards = RewardL } -> RewardL ++ AccL;
                            _ -> AccL
                        end
                    end,
                    SumRewardL = lists:foldl(F, [], RewardState);
                false ->  %% 已补发过邮件
                    SumRewardL = []
            end,
            ShowEndTime = proplists:get_value(?ACT_SHOW_END_TIME, Other, 0),
            case NowSec >= ShowEndTime of
                true -> %% 已过展示期间数据统一清理，防止出现相同主键的活动数据
                    lib_cycle_rank_util:db_delete_player_cycle_rank_info(PlayerId, Type, SubType),
                    NewCycleInfoL = lists:delete(CycleRankInfo, CycleInfoL);
                _ ->
                    case IsHasEmail of
                        0 ->
                            NewOther = lists:keystore(?ACT_REACH_REWARD_EMAIL, 1, Other, {?ACT_REACH_REWARD_EMAIL, 1}),
                            %% 更新数据库
                            lib_cycle_rank_util:db_update_player_cycle_rank_other(PlayerId, [], [], NewOther, Type, SubType),
                            NewCycleRankInfo = CycleRankInfo#status_cycle_rank_info{ other = NewOther },
                            NewCycleInfoL = lists:keystore({Type, SubType}, #status_cycle_rank_info.id, CycleInfoL, NewCycleRankInfo);
                        _ ->
                            NewCycleInfoL = CycleInfoL
                    end,
                    NewCycleInfoL
            end,
            case SumRewardL of
                [] ->
                    skip;
                _ ->
                    Title = utext:get(2270003),
                    Content = utext:get(2270004),
                    lib_mail_api:send_sys_mail([PlayerId], Title, Content, lib_goods_api:make_reward_unique(SumRewardL))
            end,
            check_player_cycle_info(Tail, PlayerId, PlayerLevel, NewCycleInfoL)
    end.

%% 领取目标奖励
get_reach_reward(Ps, Type, SubType, RewardId) ->
    Cmd = 22704,
    #player_status{ cycle_rank_data = CycleDataList, id = PlayerId, figure = #figure{ name = Name } } = Ps,
    KeyType = {Type, SubType},
    case lists:keyfind(KeyType, #rank_type.id, CycleDataList) of
        #status_cycle_rank_info{ reward_state = RewardState, reward_got = GotList } = CycleData ->
            case check_reach_reward(RewardState, GotList, Type, SubType, RewardId) of
                {ok, RewardList} ->
                    NewRewardState = lists:delete(RewardId, RewardState),
                    NewGotList = [RewardId|GotList],
                    Produce = #produce{type = cycle_rank_reach_reward, reward = RewardList, show_tips = ?SHOW_TIPS_0},
                    %% 更新数据库数据
                    lib_cycle_rank_util:db_update_player_cycle_rank_reward(PlayerId, NewRewardState, NewGotList, Type, SubType),
                    NewPs = lib_goods_api:send_reward(Ps, Produce),
                    %% 更新缓存数据
                    NewCycleData = CycleData#status_cycle_rank_info{ reward_state = NewRewardState, reward_got = NewGotList },
                    NewCycleDataList = lists:keystore(KeyType, #status_cycle_rank_info.id, CycleDataList, NewCycleData),
                    %% 记录奖励日志
                    lib_log_api:log_cycle_rank_reach(PlayerId, Name, Type, SubType, RewardId, RewardList, 2),
                    pack(PlayerId, Cmd, [Type, SubType, RewardId, ?SUCCESS]),
                    NewPs#player_status{ cycle_rank_data = NewCycleDataList };
                {error, Code} ->
                    pack(PlayerId, Cmd, [Type, SubType, RewardId, Code]),
                    Ps
            end;
        _ ->
            pack(PlayerId, Cmd, [Type, SubType, RewardId, ?LEVEL_LIMIT]),
            Ps
    end.

check_reach_reward(RewardState, GotList, Type, SubType, RewardId) ->
    Flag0 = lists:member(RewardId, RewardState),
    Flag1 = lists:member(RewardId, GotList),
    if
        Flag0 == false ->
            {error, ?ERRCODE(err179_not_achieve)};
        Flag1 ->
            {error, ?ERRCODE(err138_had_reward)};
        true ->
            case data_cycle_rank:get_reach_reward_info(Type, SubType, RewardId) of
                #base_reach_reward_info{ rewards = RewardList } ->
                    {ok, RewardList};
                _ ->
                    {error, ?MISSING_CONFIG}
            end
    end.

%% 根据在线玩家目标奖励数据，判断是否需要补发奖励邮件
over_cycle_rank_info_reward(Ps, Type, SubType) ->
    #player_status{ id = PlayerId, cycle_rank_data = CycleRankData, figure = #figure{ lv = PlayerLevel }} = Ps,
    KeyType = {Type, SubType},
    case lists:keyfind(KeyType, #status_cycle_rank_info.id, CycleRankData) of
        #status_cycle_rank_info{ } = CycleRankInfo->
            LastPlayerCycleInfoL = check_player_cycle_info([CycleRankInfo], PlayerId, PlayerLevel, CycleRankData),
            Ps#player_status{ cycle_rank_data = LastPlayerCycleInfoL };
        _ ->
            Ps
    end.

%% 查看当前正在开启活动信息
send_open_cycle_rank_info(Ps) ->
    #player_status{ id = PlayerId } = Ps,
    mod_cycle_rank_local:send_open_cycle_rank_info(PlayerId).

%% 查看当前玩家个人循环冲榜的数据
send_player_cycle_rank_info(Ps, Type, SubType) ->
    #player_status{ id = PlayerId, cycle_rank_data = CycRankData } = Ps,
    case lists:keyfind({Type, SubType}, #status_cycle_rank_info.id, CycRankData) of
        #status_cycle_rank_info{ score = Score, reward_state = RewardState, reward_got = GotList } ->
            {ShowReachId, ShowReachStatus} =
            if
                RewardState =/= [] ->
                    {lists:min(RewardState), ?REWARD_NOT_GET};
                GotList =/= [] ->
                    AllRewardId = data_cycle_rank:get_reach_reward_id_list(Type, SubType),
                    Filter = lists:subtract(AllRewardId, GotList),
                    case Filter == [] of
                        true ->
                            {lists:max(GotList), ?REWARD_HAS_GET};
                        false ->
                            {lists:min(Filter), ?REWARD_NOT_REACH}
                    end;
                true ->
                    AllRewardId = data_cycle_rank:get_reach_reward_id_list(Type, SubType),
                    {?IF(AllRewardId == [], 1, hd(AllRewardId)), ?REWARD_NOT_REACH}
            end;
        _ ->
            Score = 0,
            AllRewardId = data_cycle_rank:get_reach_reward_id_list(Type, SubType),
            ShowReachId = ?IF(AllRewardId == [], lists:min(AllRewardId), hd(AllRewardId)),
            ShowReachStatus = ?REWARD_NOT_REACH
    end,
    Args = [PlayerId, Score, ShowReachId, ShowReachStatus, Type, SubType],
    mod_cycle_rank_local:send_player_cycle_rank_info(Args).

%% 获取排行榜信息
send_cycle_rank_list(Ps, Type, SubType) ->
    #player_status{ id = PlayerId, cycle_rank_data = CycleDataList } = Ps,
    CycleData = lists:keyfind({Type, SubType}, #status_cycle_rank_info.id, CycleDataList),
    case CycleData of
        false ->
            PlayerScore = 0;
        _ ->
            PlayerScore = CycleData#status_cycle_rank_info.score
    end,
    ReqArgs = [PlayerId, Type, SubType, PlayerScore],
    mod_cycle_rank_local:send_cycle_rank_list(ReqArgs).


%% 查看昨日榜单
send_show_time_list(Player) ->
    #player_status{ id = PlayerId } = Player,
    mod_cycle_rank_local:send_show_rank_list(PlayerId).

%% 20220531 版本 如果玩家昨日没有上榜，则积分直接传0
send_show_rank_list(Ps, Type, SubType, PlayerRank, SendList, PlayerScore) ->
    #player_status{ id = PlayerId } = Ps,
    %% case lists:keyfind(PlayerId, 3, SendList) of
    %%    {_Rank, _ServerNum, _RoleId, _RoleName, RoleScore} ->
    %%        Score = RoleScore;
    %%    _ ->
    %%        Score = 0
    %% end,
    Args = [Type, SubType, PlayerScore, PlayerRank, 0, lists:reverse(SendList)],
    %% ?INFO("Player:~p//Args:~p", [PlayerId, Args]),
    pack(PlayerId, 22703, Args).

%% 消耗物品计算循环冲榜的积分
calc_cycle_rank_score(Ps, Data) ->
    case is_in_open_seven_day() of
        true -> skip;
        false ->
            AllGoodsId = data_cycle_rank:get_all_points_goods_id(),
            Fun = fun({_, GoodsId, _Num}) -> lists:member(GoodsId, AllGoodsId) end,
            Filter = lists:filter(Fun, Data),
            case Filter of
                [] -> skip;
                _ ->
                    #player_status{ id = PlayerId } = Ps,
                    mod_cycle_rank_local:calc_cycle_rank_score(PlayerId, Filter)
            end
    end.

%% 20220531版本, 到10点后只禁止上榜，但仍可以冲击目标奖励
add_cycle_rank_score(Ps, GoodsList, OpenAct) ->
    #base_cycle_rank_info{ type = Type, sub_type = SubType, end_time = EndTime, banned_time = BannedTime } = OpenAct,  %% 与策划确认过每次只有一个活动开启
    F = fun(I, Sum) ->
        case I of
            {_, GoodsId, Num} -> ok;
            {GoodsId, Num} -> ok
        end,
        OnePoint = data_cycle_rank:get_cycle_rank_points(Type, SubType, GoodsId),
        Num * OnePoint + Sum
    end,
    AddScore = lists:foldl(F, 0, GoodsList),
    do_add_cycle_rank_score(Ps, Type, SubType, AddScore, EndTime, GoodsList, BannedTime).

%% 积分增加时
do_add_cycle_rank_score(Ps, _Type, _SubType, 0, _EndTime, _CostsL, _) ->
    Ps;
do_add_cycle_rank_score(Ps, Type, SubType, AddScore, EndTime, CostsL, BannedTime) ->
    #player_status{
        id = PlayerId, cycle_rank_data = CycleRankDataL, server_id = ServerId,
        figure = Figure, platform = Plat, server_num = ServerNum
    } = Ps,
    KeyType = {Type, SubType},
    case lists:keyfind(KeyType, #status_cycle_rank_info.id, CycleRankDataL) of
        #status_cycle_rank_info{} = Cr ->
            CycData = Cr,
            IsInit = false;
        _ ->
            CycData = #status_cycle_rank_info{ type = Type, sub_type = SubType, id = KeyType },
            IsInit = true
    end,
    #status_cycle_rank_info{ score = Score, reward_state = RewardState, reward_got = GotList} = CycData,
    NewScore = Score + AddScore,
    NewRewardState = correct_reward_state(Type, SubType, NewScore, RewardState, GotList),
    %% 更新数据库
    case IsInit of
        true ->
            %% 计算结束展示的时间
            ShowDay = 1,
            ShowEndTime = EndTime + ShowDay * 86400,
            Other = [{?ACT_SHOW_END_TIME, ShowEndTime}],
            NewCycData = CycData#status_cycle_rank_info{
                score = NewScore, reward_state = NewRewardState, end_time = EndTime, other = Other
            },
            lib_cycle_rank_util:db_insert_player_cycle_rank_info(PlayerId, NewCycData);
        false ->
            NewCycData = CycData#status_cycle_rank_info{score = NewScore, reward_state = NewRewardState},
            lib_cycle_rank_util:db_updata_player_cycle_rank_state(PlayerId, NewScore, NewRewardState, Type, SubType)
    end,
    PlayerLevel = Figure#figure.lv,
    LevelLimit = data_cycle_rank:get_kv_cfg(rank_level_limit),

    %% 为满足等级的只记录积分不进行冲榜操作 或过了上榜的时间
    NowSec = utime:unixtime(),
    case PlayerLevel >= LevelLimit andalso NowSec =< BannedTime of
        true ->
            %% 更新排行榜
            RankRole = #rank_role{
                score = NewScore, figure = Figure, server_id = ServerId,
                server_num = ServerNum, platform = Plat, id = PlayerId, last_time = utime:unixtime()
            },
            Args = [Type, SubType, RankRole],
            mod_cycle_rank_local:update_cycle_rank_list(Args);
        _ ->
            skip
    end,
    %% 更新缓存数据
    NewCycleRankDataL = lists:keystore(KeyType, #status_cycle_rank_info.id, CycleRankDataL, NewCycData),
    %% 记录积分变化日志
    lib_log_api:log_cycle_rank_role_score(PlayerId, Figure#figure.name, Type, SubType, 1, CostsL, Score, AddScore, NewScore),
    Ps#player_status{ cycle_rank_data = NewCycleRankDataL }.

%% 根据积分计算新的目标奖励状态
correct_reward_state(Type, SubType, NewScore, RewardState, GotList) ->
    AllRewardId = data_cycle_rank:get_reach_reward_id_list(Type, SubType),
    Filter = fun(CfgId, AccL) ->
        Cfg = data_cycle_rank:get_reach_reward_info(Type, SubType, CfgId),
        case Cfg of
            #base_reach_reward_info{ need = Need } ->
                Flag0 = lists:member(CfgId, RewardState) == false,
                Flag1 = lists:member(CfgId, GotList) == false,
                Flag = NewScore >= Need andalso Flag0 andalso Flag1,
                ?IF(Flag , [CfgId|AccL], AccL);
            _ ->
                AccL
        end
    end,
    NewRewardState = lists:foldl(Filter, RewardState, AllRewardId),
    lists:sort(NewRewardState).

pack(PlayerId, Cmd, Args) ->
    {ok, Bin} = pt_227:write(Cmd, Args),
    lib_server_send:send_to_uid(PlayerId, Bin).

get_data(Ps) ->
    #player_status{ cycle_rank_data = CycleRankData } = Ps,
    CycleRankData.

%% 升级或战力变化时触发
handle_event(Player, #event_callback{type_id = ?EVENT_LV_UP}) ->
    #player_status{ id = PlayerId, figure = #figure{lv = Lv} } = Player,
    OpenLevel = data_cycle_rank:get_kv_cfg(rank_level_limit),
    Count = mod_counter:get_count(PlayerId, 227, 1),
    case Lv >= OpenLevel orelse Count < 1  of
        true ->
            mod_cycle_rank_local:update_cycle_rank_when_lv_up(PlayerId);
        false ->
            skip
    end,
    {ok, Player};
handle_event(Player, #event_callback{ type_id = ?EVENT_RENAME }) ->
    #player_status{
        id = PlayerId, figure = #figure{lv = Lv, name = PlayerName}, cycle_rank_data = CycleData
    } = Player,
    OpenLevel = data_cycle_rank:get_kv_cfg(rank_level_limit),
    case Lv >= OpenLevel andalso CycleData =/= [] andalso not is_in_open_seven_day() of
        true ->
            mod_cycle_rank_local:change_role_name(PlayerId, PlayerName);
        _ ->
            skip
    end,
    {ok, Player};
handle_event(Player, _) ->
    {ok, Player}.

update_cycle_rank_when_lv_up(Player, OpenAct) ->
    #base_cycle_rank_info{ type = Type, sub_type = SubType, end_time = EndTime, banned_time = BannedTime } = OpenAct,  %% 与策划确认过每次只有一个活动开启
    NowSec = utime:unixtime(),
    case NowSec >= BannedTime of
        true -> skip;
        _ ->
            #player_status{
                id = PlayerId, cycle_rank_data = CycleRankDataL, server_id = ServerId,
                figure = Figure, platform = Plat, server_num = ServerNum
            } = Player,
            case lists:keyfind({Type, SubType}, #status_cycle_rank_info.id, CycleRankDataL) of
                #status_cycle_rank_info{ score = Score, end_time = EndTime } when EndTime >= NowSec ->
                    %% 更新排行榜
                    RankRole = #rank_role{
                        score = Score, figure = Figure, server_id = ServerId,
                        server_num = ServerNum, platform = Plat, id = PlayerId, last_time = utime:unixtime()
                    },
                    Args = [Type, SubType, RankRole],
                    mod_cycle_rank_local:update_cycle_rank_list(Args),
                    mod_counter:plus_count(PlayerId, 227, 1, 1);
                _ ->
                    skip
            end
    end.

%% 统一设置，开服前七天屏蔽循环冲榜的相关操作
is_in_open_seven_day() ->
    util:get_open_day() =< 7.

push_show_cycle_rank(Player, Type, SubType, SendList) ->
    #player_status{ id = PlayerId } = Player,
    case lists:keyfind(PlayerId, 3, SendList) of
        {Rank, _ServerNum, _RoleId, _RoleName, RoleScore} -> ok;
        _ -> Rank = 0, RoleScore = 0
    end,
    %% ?INFO("PlayerId:~p//Type:~p//SubType:~p//Rank:~p//RoleScore:~p//SendList:~p", [PlayerId, Type, SubType, Rank, RoleScore, SendList]),
    {ok, Bin} = pt_227:write(22703, [Type, SubType, RoleScore, Rank, 1, SendList]),
    lib_server_send:send_to_all(Bin).

cycle_gm(Ps, Type, SubType, AddScore) ->
    #player_status{
        id = PlayerId, cycle_rank_data = CycleRankDataL, figure = Figure
    } = Ps,
    KeyType = {Type, SubType},
    case lists:keyfind(KeyType, #status_cycle_rank_info.id, CycleRankDataL) of
        #status_cycle_rank_info{} = Cr ->
            CycData = Cr,
            IsInit = false;
        _ ->
            CycData = #status_cycle_rank_info{ type = Type, sub_type = SubType, id = KeyType },
            IsInit = true
    end,
    #status_cycle_rank_info{ score = Score, reward_state = RewardState, reward_got = GotList} = CycData,
    NewScore = Score + AddScore,
    NewRewardState = correct_reward_state(Type, SubType, NewScore, RewardState, GotList),
    %% 更新数据库
    case IsInit of
        true ->
            %% 计算结束展示的时间
            ShowEndTime = utime:unixtime() + 7200,
            Other = [{?ACT_SHOW_END_TIME, ShowEndTime}],
            NewCycData = CycData#status_cycle_rank_info{
                score = NewScore, reward_state = NewRewardState, other = Other
            },
            lib_cycle_rank_util:db_insert_player_cycle_rank_info(PlayerId, NewCycData);
        false ->
            NewCycData = CycData#status_cycle_rank_info{score = NewScore, reward_state = NewRewardState},
            lib_cycle_rank_util:db_updata_player_cycle_rank_state(PlayerId, NewScore, NewRewardState, Type, SubType)
    end,
    %% 更新缓存数据
    NewCycleRankDataL = lists:keystore(KeyType, #status_cycle_rank_info.id, CycleRankDataL, NewCycData),
    Ps#player_status{ cycle_rank_data = NewCycleRankDataL }.

%%
fix_merge_player_data(PlayerId, GoodsId, Num) ->
    lib_player:apply_cast(PlayerId, ?APPLY_CAST_STATUS, ?MODULE, do_fix_merge_player_data, [GoodsId, Num]).

do_fix_merge_player_data(Ps, GoodsId, Num) ->
    CostL = [{0, GoodsId, Num}],
    calc_cycle_rank_score(Ps, CostL).