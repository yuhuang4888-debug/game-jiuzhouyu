%% ---------------------------------------------------------------------------
%% @doc lib_cycle_rank_local_mod

%% @author  lianghaihui
%% @email   1457863678@qq.com
%% @since   2022/03/18
%% @desc    循环冲榜##游戏服进程函数处理模块
%% ---------------------------------------------------------------------------

-module(lib_cycle_rank_local_mod).

%% API
-compile(export_all).

-include("common.hrl").
-include("server.hrl").
-include("cycle_rank.hrl").
-include("figure.hrl").
-include("predefine.hrl").
-include("def_fun.hrl").

init() ->
    Ref = check_ref([]),
    State = #game_rank_status{ ref = Ref },
    State.

check_ref(Ref) ->
    util:cancel_timer(Ref),
    {_, {H, Min, S}} = calendar:local_time(),
    PassTime = H * 3600 + Min * 60 + S,
    RefTime = ?ONE_DAY_SECONDS + 1 - PassTime,
    erlang:send_after(RefTime * 1000, self(), {check_daily_zero}).

check_daily_zero() ->
    ok.

%% 结算补发在线玩家的目标奖励
over_player_cycle_rank_info(Type, SubType, State) ->
    #game_rank_status{ opening_act = OpenActList } = State,
    KeyType = {Type, SubType},
    case lists:keyfind(KeyType, #rank_type.id, OpenActList) of
        #base_cycle_rank_info{} ->
            OnlineRoles = ets:tab2list(?ETS_ONLINE),
            spawn(fun() -> [
                begin
                    timer:sleep(500),
                    lib_player:apply_cast(E#ets_online.id, ?APPLY_CAST_SAVE, lib_cycle_rank, over_cycle_rank_info_reward, [Type, SubType])
                end || E <- OnlineRoles]
            end);
        _ ->
            skip
    end.

%%定时器
ref(Ref)->
    util:cancel_timer(Ref),
    {_, {H,Min,S}} = calendar:local_time(),
    PassTime = H*3600 + Min*60 + S,
    RefTime = ?ONE_DAY_SECONDS + 1 - PassTime,
    erlang:send_after(RefTime*1000, self(), {zero}).

%% 同步导致榜单变化的榜单玩家信息到本服
syn_cycle_rank_role(Type, SubType, AddRankRole, State) ->
    #game_rank_status{ rank_list = RankList } = State,
    KeyType = {Type, SubType},
    RankTypeData = lists:keyfind(KeyType, #rank_type.id, RankList),
    case RankTypeData == false of
        true ->
            RankRoleList = [],
            LastRankRoleList = [AddRankRole],
            NewRankTypeData = #rank_type{ rank_role_list = LastRankRoleList, id = KeyType, type = Type, subtype = SubType  };
        false ->
            #rank_type{ rank_role_list = RankRoleList } = RankTypeData,
            #rank_role{ id = RoleID } = AddRankRole,
            NewRankRoleList = lists:keystore(RoleID, #rank_role.id, RankRoleList, AddRankRole),
            TmpRankList = lib_cycle_rank_mod:sort_rank_list(NewRankRoleList),
            NewRankRoleList1 = lib_cycle_rank_mod:set_role_ranking(TmpRankList, Type, SubType, 1, []),
            Max = lib_cycle_rank_mod:get_rank_max(Type, SubType),
            {LastRankRoleList, LastScore} = lib_cycle_rank_mod:get_limit_score(Type, SubType, NewRankRoleList1, Max),
            NewRankTypeData = RankTypeData#rank_type{ rank_role_list = LastRankRoleList, score_limit = LastScore }
    end,
    send_first_place_changes(Type, SubType, RankRoleList, LastRankRoleList),
    NewRankList = lists:keystore(KeyType, #rank_type.id, RankList, NewRankTypeData),
    State#game_rank_status{ rank_list = NewRankList }.

%% 发送榜单数据
send_cycle_rank_list([PlayerId, Type, SubType, PlayerScore], State) ->
    #game_rank_status{ opening_act = OpenActList, rank_list = RankList } = State,
    ActInfo = ?IF( OpenActList =/= [], hd(OpenActList), none),
    FixActInfo = ?IF( ActInfo == none, false, ActInfo#base_cycle_rank_info.type == Type andalso ActInfo#base_cycle_rank_info.sub_type == SubType),
    case FixActInfo of
        true ->
            KeyType = {Type, SubType},
            RankType = lists:keyfind(KeyType, #rank_type.id, RankList),
            case RankType of
                false ->
                    RankRoleList = [];
                #rank_type{ } ->
                    RankRoleList = RankType#rank_type.rank_role_list
            end,
            Fun = fun(I, AccL) ->
                #rank_role{
                    id = RoleId, rank = Rank, server_num = ServerNum,
                    score = RoleScore, figure = #figure{ name = RoleName }
                } = I,
                [{Rank, ServerNum, RoleId, RoleName, RoleScore}|AccL]
            end,
            SendList = lists:foldl(Fun, [], RankRoleList),
            PlayerRank = case lists:keyfind(PlayerId, #rank_role.id, RankRoleList) of
                             #rank_role{ rank = PRank } -> PRank;
                             _ -> 0
                         end,
            RankRewardId = data_cycle_rank:get_rank_reward_id(Type, SubType, PlayerRank),
            Args = [Type, SubType, PlayerScore, PlayerRank, RankRewardId, SendList],
            {ok, Bin} = pt_227:write(22702, Args),
            lib_server_send:send_to_uid(PlayerId, Bin);
        _ ->
            skip
    end,
    {noreply, State}.


%% 同步中心服所有关于循环冲榜的数据
sync_cycle_rank_data_from_center([OpenActList, ShowActInfo, RankList, AllCycleRank] = Args, State) ->
    %% 过滤本游戏服可正常开启的冲榜活动
    Fun = fun(I) -> lib_cycle_rank_util:game_check_is_open(I) end,
    FixOpenActList = lists:filter(Fun, OpenActList),
    %% 获取本游戏节点处于展示期的活动
    Fun2 = fun(I) -> lib_cycle_rank_util:game_check_is_show(I) end,
    FixShowActList = lists:filter(Fun2, ShowActInfo),
    %% 获取可正常保留在本游戏节点的榜单数据
    CheckCycleRank = OpenActList ++ ShowActInfo,
    Fun3 = fun(#rank_type{ id = {Type, SubType} }, AccL) ->
        case lib_cycle_rank_util:game_is_clear(Type, SubType, CheckCycleRank) of
            true ->
                lists:keydelete({Type, SubType}, #rank_type.id, AccL);
            false ->
                AccL
        end
    end,
    FixRankList = lists:foldl(Fun3, RankList, RankList),
    ?MYLOG("lhh", "Args:~p~n~p", [Args, [FixRankList, FixOpenActList, FixShowActList]]),
    %% 记录开启日志
    log(FixOpenActList, 1),
    NewState = State#game_rank_status{
        all_act = AllCycleRank,
        rank_list = FixRankList,
        opening_act = FixOpenActList,
        showing_act = FixShowActList
    },
    NewState.

%% 获取本节点上开启的活动
get_open_cycle_rank(State) ->
    #game_rank_status{ opening_act = OpenActList } = State,
    SortActList = lists:keysort(#base_cycle_rank_info.start_time, OpenActList),  %% 当有多个活动开启数据时去最早开启的那个活动
    case SortActList of
        [] ->
            [];
        _ ->
            #base_cycle_rank_info{ start_time = StarTime, end_time = EndTime } = OpenActInfo = hd(SortActList),
            NowSec = utime:unixtime(),
            case NowSec >= StarTime andalso NowSec < EndTime of
                true ->
                    OpenActInfo;
                false ->
                    none
            end
    end.

%% 获取本节点上正在展示期间的活动
get_show_cycle_rank(State) ->
    #game_rank_status{ showing_act = ShowActList } = State,
    SortActList = lists:keysort(#base_cycle_rank_info.end_time, ShowActList),  %% 当有多个展示期间的活动时去最早结束的那个
    case SortActList of
        [] ->
            [];
        _ ->
            hd(SortActList)
    end.

%% 游戏节点上执行的
%% 根据玩家榜单上的排名，发放排名奖励
send_rank_reward(Type, SubType, RoleId, Rank, RankReward) ->
    case data_cycle_rank:get_cycle_rank_info(Type, SubType) of
        #base_cycle_rank_info{ name = ActName, open_day = OpenDay } ->
            case util:get_open_day() >= OpenDay of
                true ->
                    Title = utext:get(2270001, [ActName]),
                    Content = utext:get(2270002, [ActName, Rank]),
                    %% 发送奖励邮件
                    lib_mail_api:send_sys_mail([RoleId], Title, Content, RankReward);
                false ->
                    skip
            end;
        _ ->
            skip
    end.

synch_cycle_rank_info({close_cycle_rank, CloseActL, AddShowActL}, State) ->
    case CloseActL of
        [] ->
            State;
        _ ->
            #game_rank_status{ opening_act = OpenActL, showing_act = ShowActL, rank_list = RankList} = State,
            Fun = fun(CloseAct, {OpAccL, ShAccL}) ->
                NewOpenActL0 = lists:delete(CloseAct, OpAccL),
                NewShowActL0 = lists:delete(CloseAct, ShAccL),
                {NewOpenActL0, NewShowActL0}
            end,
            {NewOpenActL, NewShowActL} = lists:foldl(Fun, {OpenActL, ShowActL}, CloseActL),
            LastNewShowActL = lists:umerge(NewShowActL, AddShowActL),
            %% 记录关闭的活动
            log(CloseActL, 2),
            %% 记录新开启的展示榜单
            log(AddShowActL, 3),
            NewState = State#game_rank_status{opening_act = NewOpenActL, showing_act = LastNewShowActL},
            %% 推送新的展示活动榜单
            case AddShowActL of
                [] -> skip;
                _ -> push_show_cycle_rank(AddShowActL, RankList)
            end,
            NewState
    end;
synch_cycle_rank_info({open_cycle_rank, AddOpenActL, LastAllActList}, State) ->
    case AddOpenActL of
        [] ->
            State;
        _ ->
            #game_rank_status{ opening_act = OpenActL} = State,
            Fun = fun(AddOpenAct, AccL) ->
                case lists:member(AddOpenAct, AccL) of
                    true -> AccL;
                    _ ->
                        case lib_cycle_rank_util:game_check_is_open(AddOpenAct) of
                            true -> [AddOpenAct|AccL];
                            _ -> AccL
                        end
                end
            end,
            NewOpenActL = lists:foldl(Fun, OpenActL, AddOpenActL),
            log(NewOpenActL, 1),
            %% 结束时推送，以免客户端请求时没有及时更新到数据出现问题
            case NewOpenActL of
                [] -> skip;
                _ -> push_cycle_rank_info(NewOpenActL)
            end,
            State#game_rank_status{ opening_act = NewOpenActL, all_act = LastAllActList }
    end;
synch_cycle_rank_info({close_show_cycle_rank, CloseShowActL}, State) ->
    case CloseShowActL of
        [] ->
            State;
        _ ->
            #game_rank_status{ showing_act = ShowActL, rank_list = RankList } = State,
            Fun = fun(CloseShowAct, {NewShowActL, NewRankList}) ->
                #base_cycle_rank_info{ id = KeyType } = CloseShowAct,
                NewShowActL2 = lists:delete(CloseShowAct, NewShowActL),
                NewRankList2 = lists:keydelete(KeyType, #rank_type.id, NewRankList),
                {NewShowActL2, NewRankList2}
            end,
            %% 记录关闭的展示活动信息
            log(CloseShowActL, 4),
            {NewShowActL, NewRankList} = lists:foldl(Fun, {ShowActL, RankList}, CloseShowActL),
            State#game_rank_status{ showing_act = NewShowActL, rank_list = NewRankList }
    end;
synch_cycle_rank_info({change_rank_role_server_info, NewRankList}, State) ->
    State#game_rank_status{ rank_list = NewRankList };
synch_cycle_rank_info(Msg, State) ->
    ?ERR("no_match_synch_cycle_rank_info~p", [Msg]),
    State.

%% 发送正在开启的活动信息
send_open_cycle_rank_info(PlayerId, State) ->
    case get_open_cycle_rank(State) of
        #base_cycle_rank_info{
            type = Type, sub_type = SubType, start_time = StartTime, end_time = EndTime, banned_time = UponTime
        } = ActInfo ->
            case lib_cycle_rank_util:game_check_is_open(ActInfo) of
                true ->
                    Args = [Type, SubType, StartTime, EndTime, UponTime];
                false ->
                    Args = [0, 0, 0, 0, 0]
            end;
        _ ->
            Args = [0, 0, 0, 0, 0]
    end,
    lib_cycle_rank:pack(PlayerId, 22700, Args).

send_player_cycle_rank_info(Args, State) ->
    [PlayerId, Score, ShowReachId, ShowReachStatus, Type, SubType] = Args,
    #game_rank_status{ rank_list = RankList, opening_act = OpenActL } = State,
    KeyType = {Type, SubType},
    case lists:keyfind(KeyType, #base_cycle_rank_info.id, OpenActL) of
        #base_cycle_rank_info{  } ->
            IsOpen = 1,
            case lists:keyfind(KeyType, #rank_type.id, RankList) of
                #rank_type{ rank_role_list = RoleList } ->
                    case lists:keyfind(PlayerId, #rank_role.id, RoleList) of
                        #rank_role{ rank = Rank } -> ok;
                        _ -> Rank = 0
                    end;
                _ -> Rank = 0
            end;
        _ ->
            IsOpen = 0,
            Rank = 0
    end,
    SendArgs = [Type, SubType, IsOpen, Score, Rank, ShowReachId, ShowReachStatus],
    %% ?INFO("send_player_cycle_rank_info RoleId:~p//SendArgs:~p~n", [PlayerId, SendArgs]),
    lib_cycle_rank:pack(PlayerId, 22701, SendArgs).

%% 发送展示期间的榜单
%% 目前只可能有一个展示活动 以后根据type, SubType即可做到多个展示活动
send_show_rank_list(PlayerId, State) ->
    #game_rank_status{ rank_list = RankList, showing_act = ShowActList } = State,
    case ShowActList =/= [] of
        true ->
            #base_cycle_rank_info{ type = Type, sub_type = SubType } = hd(ShowActList),
            KeyType = {Type, SubType},
            RankType = lists:keyfind(KeyType, #rank_type.id, RankList),
            case RankType of
                false ->
                    RankRoleList = [];
                #rank_type{ } ->
                    RankRoleList = RankType#rank_type.rank_role_list
            end,
            Fun = fun(I, AccL) ->
                #rank_role{
                    id = RoleId, rank = Rank, server_num = ServerNum,
                    score = RoleScore, figure = #figure{ name = RoleName }
                } = I,
                [{Rank, ServerNum, RoleId, RoleName, RoleScore}|AccL]
            end,
            SendList = lists:foldl(Fun, [], RankRoleList),
            case lists:keyfind(PlayerId, #rank_role.id, RankRoleList) of
                #rank_role{ rank = PRank, score = Score } ->
                    PlayerRank = PRank, PlayerScore = Score;
                _ ->
                    PlayerRank = 0, PlayerScore = 0
            end,
            Args = [Type, SubType, PlayerRank, SendList, PlayerScore],
            lib_player:apply_cast(PlayerId, ?APPLY_CAST_STATUS, lib_cycle_rank, send_show_rank_list, Args);
        false ->
            skip
    end.

calc_cycle_rank_score(PlayerId, GoodsList, State) ->
    #game_rank_status{ opening_act = OpenActList } = State,
    case OpenActList of
        [] ->%% 当前游戏服无开启的活动，不参与积分计算
            skip;
        _ ->
            OpenAct = hd(OpenActList),
            lib_player:apply_cast(PlayerId, ?APPLY_CAST_SAVE, lib_cycle_rank, add_cycle_rank_score, [GoodsList, OpenAct])
    end.

%% 清空变化冷却时间
role_refresh_send_time(_State, RoleId) ->
    mod_clusters_node:apply_cast(mod_cycle_rank, role_refresh_send_time, [RoleId]).

%% 结算时推送昨日榜单
push_show_cycle_rank(AddShowActL, RankList) ->
    #base_cycle_rank_info{ id = KeyType, open_day = OpenDay } = hd(AddShowActL),
    %% 未符合开服天数的服不推送
    case util:get_open_day() >= OpenDay of
        true ->
            case lists:keyfind(KeyType, #rank_type.id, RankList) of
                #rank_type{ rank_role_list = RankRoleList } ->
                    Fun = fun(I, AccL) ->
                        #rank_role{
                            id = RoleId, rank = Rank, server_num = ServerNum,
                            score = RoleScore, figure = #figure{ name = RoleName }
                        } = I,
                        [{Rank, ServerNum, RoleId, RoleName, RoleScore}|AccL]
                    end,
                    SendList = lists:foldl(Fun, [], RankRoleList);
                _ ->
                    SendList = []
            end,
            {Type, SubType} = KeyType,
            OnlineList = ets:tab2list(?ETS_ONLINE),
            [lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, lib_cycle_rank, push_show_cycle_rank, [Type, SubType, SendList]) || #ets_online{id = RoleId} <- OnlineList];
        _ ->
            skip
    end.

%% -----------------------------------------------------------------
%% @desc    功能描述  玩家升级时触发，为节约资源，由终身计数器记录其次数，理论上每个玩家只执行一次
%% @param   参数
%% -----------------------------------------------------------------
update_cycle_rank_when_lv_up(PlayerId, State) ->
    #game_rank_status{ opening_act = OpenActList } = State,
    case OpenActList of
        [] ->%% 当前游戏服无开启的活动，不参与积分计算
            skip;
        _ ->
            OpenAct = hd(OpenActList),
            %% 这里升级触发的只去玩家的积分，不需要更新#player_status{}
            lib_player:apply_cast(PlayerId, ?APPLY_CAST_STATUS, lib_cycle_rank, update_cycle_rank_when_lv_up, [OpenAct])
    end.

%% -----------------------------------------------------------------
%% @desc    功能描述 第一名变化时计算
%% @param   参数
%% @return  返回值
%% -----------------------------------------------------------------
send_first_place_changes(Type, SubType, OldRankList, NewRankList) ->
    OldFirstOne = ulists:keyfind(1, #rank_role.rank, OldRankList, []),
    NewFirstOne = ulists:keyfind(1, #rank_role.rank, NewRankList, []),
    if
        OldFirstOne == [] ->
            skip;
        NewFirstOne == [] ->
            skip;
        true ->
            #rank_role{ id = OldPlayerId } = OldFirstOne,
            #rank_role{ score = NewScore, id = NewPlayerId, server_num = ServerNum, figure = #figure{ name = Name } } = NewFirstOne,
            case OldPlayerId == NewPlayerId of
                true ->
                    skip;
                false ->
                    SendArgs = [Type, SubType, ServerNum, NewPlayerId, Name, NewScore],
                    {ok, BinData} = pt_227:write(22706, SendArgs),
                    lib_server_send:send_to_all(BinData)
            end
    end.

%% -----------------------------------------------------------------
%% @desc    功能描述 记录本服开关循环冲榜的时间日志
%% -----------------------------------------------------------------
log([], _OpenType) ->
    ok;
log(List, OpenType) ->
    ServerId  = config:get_server_id(),
    NowSec = utime:unixtime(),
    Fun = fun(#base_cycle_rank_info{ type = Type, sub_type = SubType}, AccL) ->
        Args = [ServerId, Type, SubType, OpenType, NowSec],
        [Args] ++ AccL
    end,
    LogList = lists:foldl(Fun, [], List),
    lib_log_api:log_cycle_rank_time(LogList).

push_cycle_rank_info(NewOpenActL) ->
    #base_cycle_rank_info{
        type = Type, sub_type = SubType, start_time = StartTime,
        end_time = EndTime, banned_time = UponTime, open_day = OpenDay
     } = hd(NewOpenActL),
    case util:get_open_day() >= OpenDay of
        true ->
            Args = [Type, SubType, StartTime, EndTime, UponTime];
        false ->
            Args = [0, 0, 0, 0, 0]
    end,
    {ok, Bin} = pt_227:write(22700, Args),
    lib_server_send:send_to_all(Bin).

get_rank_and_last_score(State) ->
    #game_rank_status{ rank_list = RankList } = State,
    case get_open_cycle_rank(State) of
        #base_cycle_rank_info{ type = Type, sub_type = SubType } ->
            Max = lib_cycle_rank_mod:get_rank_max(Type, SubType),
            {_LastRankRoleList, LastScore} = lib_cycle_rank_mod:get_limit_score(Type, SubType, RankList, Max),
            case LastScore > 0 of
                true ->
                    fix_player_data_to_rank(Type, SubType, LastScore);
                false ->
                    skip
            end;
        _ ->
            skip
    end.

fix_player_data_to_rank() ->
    mod_cycle_rank_local:get_rank_and_last_score().

%% 重新让玩家进一次榜，防止因为踢人问题而导致积分达标却无法进榜的玩家存在
fix_player_data_to_rank(Type, SubType, Score) ->
    Sql = io_lib:format(<<"SELECT `role_id`,`score` FROM player_cycle_rank_role where `type` = ~p and `subtype` = ~p and score > ~p ">>, [Type, SubType, Score]),
    case db:get_all(Sql) of
        [] ->
            skip;
        AllPlayerInfo ->
            ServerId = config:get_server_id(),
            ServerNum = config:get_server_num(),
            Plat = config:get_platform(),
            Fun = fun([FixPlayerId, PlayerScore|_]) ->
                timer:sleep(urand:rand(1, 500)),
                [Name|_] = db:get_all(io_lib:format(<<"select nickname from player_low where id = ~p">>, [FixPlayerId])),
                RankRole = #rank_role{
                    score = PlayerScore, server_id = ServerId, id = FixPlayerId, figure = #figure{ name = Name },
                    server_num = ServerNum, platform = Plat, last_time = utime:unixtime()
                },
                Args = [Type, SubType, RankRole],
                mod_cycle_rank_local:update_cycle_rank_list(Args)
            end,
            spawn(fun() -> lists:foreach(Fun, AllPlayerInfo) end),
            length(AllPlayerInfo)
    end.

update_cycle_rank_list([Type, SubType, AddRankRole], State) ->
    #game_rank_status{ rank_list = RankList } = State,
    #rank_role{ score = Score, id = RoleId, server_id = ServerId } = AddRankRole,
    case lists:keyfind({Type, SubType}, #rank_type.id, RankList) of
        false ->
            %% 当前全服榜单无人
            case lib_cycle_rank_util:check_enter_rank(Type, SubType, Score) of
                false -> %% 玩家不满足上榜的最近要求，但也要提示弹窗，这里是为了控制发完中心跨服的流量
                    LastState = lib_cycle_rank_util:send_num_to_reach_reward(State, {Type, SubType}, RoleId, Score, ServerId);
                _ ->
                    %% 满足最低的上榜条件，需要发送
                    mod_clusters_node:apply_cast(mod_cycle_rank, update_cycle_rank_list, [[Type, SubType, AddRankRole, ?NEED_TO_BE_REORDERED]]),
                    LastState = State
            end;
        #rank_type{ score_limit = LimitScore, rank_role_list = RoleList } when Score > LimitScore ->
            case lists:keyfind(RoleId, #rank_role.id, RoleList) of
                false ->
                    %% 当前全服榜单不存在该玩家信息
                    case lib_cycle_rank_util:check_enter_rank(Type, SubType, Score) of
                        false -> %% 玩家不满足上榜的最近要求，但也要提示弹窗，这里是为了控制发完中心跨服的流程
                            LastState = lib_cycle_rank_util:send_num_to_reach_reward(State, {Type, SubType}, RoleId, Score, ServerId);
                        _ ->
                            %% 满足最低的上榜条件，需要发送
                            mod_clusters_node:apply_cast(mod_cycle_rank, update_cycle_rank_list, [[Type, SubType, AddRankRole, ?NEED_TO_BE_REORDERED]]),
                            LastState = State
                    end;
                #rank_role{ rank = RoleRank } ->
                    if
                        RoleRank == 1 ->
                            IsNeedRank = ?NOT_NEED_TO_BE_REORDERED;
                        true ->
                            case lists:keyfind(RoleRank - 1, #rank_role.rank, RoleList) of
                                #rank_role{ score = BeforeScore} ->
                                    IsNeedRank = ?IF( BeforeScore > Score, ?NOT_NEED_TO_BE_REORDERED, ?NEED_TO_BE_REORDERED);
                                _ ->
                                    %% 可以去区间进一步优化，但会涉及到弹窗的问题
                                    IsNeedRank = ?NEED_TO_BE_REORDERED
                            end
                    end,
                    mod_clusters_node:apply_cast(mod_cycle_rank, update_cycle_rank_list, [[Type, SubType, AddRankRole, IsNeedRank]]),
                    LastState = State
            end;
        _ ->
            %% 玩家积分没有到达上榜的最后一名的值，这时不发往中心服，但正常推送上榜要求弹窗
            LastState = lib_cycle_rank_util:send_num_to_reach_reward(State, {Type, SubType}, RoleId, Score, ServerId)
    end,
    LastState.

%% 秘籍抽取50名玩家冲榜
gm_select_player_rank() ->
    Sql = <<"select id, nickname from player_low order by rand() limit 100">>,
    ServerId = config:get_server_id(),
    ServerNum = config:get_server_num(),
    #base_cycle_rank_info{ type = Type, sub_type = SubType } = mod_cycle_rank_local:get_open_cycle_rank(),
    case db:get_all(Sql) of
        List when List =/= [] ->
            Fun = fun([PlayerId, NickName]) ->
                RankRole = #rank_role{
                    score = urand:rand(900, 5000), server_id = ServerId, figure = #figure{ name = NickName },
                    server_num = ServerNum, id = PlayerId, last_time = utime:unixtime()
                },
                Args = [Type, SubType, RankRole],
                mod_cycle_rank_local:update_cycle_rank_list(Args),
                timer:sleep(500)
            end,
            spawn(fun() -> lists:foreach(Fun, List) end);
        _ ->
            skip
    end.