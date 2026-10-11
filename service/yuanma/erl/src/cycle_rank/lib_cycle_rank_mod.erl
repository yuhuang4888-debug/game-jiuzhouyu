%% ---------------------------------------------------------------------------
%% @doc lib_cycle_rank_mod

%% @author  lianghaihui
%% @email   1457863678@qq.com
%% @since   2022/03/18
%% @desc    循环冲榜##跨服进程函数处理模块
%% ---------------------------------------------------------------------------

-module(lib_cycle_rank_mod).

%% API
-export([
    init/0,
    sort_rank_list/1,
    set_role_ranking/5,
    get_rank_max/2,
    get_limit_score/4,
    close_cycle_rank/1,
    close_show_act/1,
    open_cycle_rank/1,
    update_cycle_rank_list/2,
    get_rank_limit_type/2,
    role_refresh_send_time/2,
    sync_cycle_rank_data_to_node/2,
    fix_merge_server_data/4,
    change_role_name/3,
    calc_daily_act_info/1,
    gm_reopen_cycle_rank/1,
    gm_recalculate_timer/1
]).

-export([
    gm_refresh/1,
    gm_refresh_ref/0
]).

-include("common.hrl").
-include("server.hrl").
-include("cycle_rank.hrl").
-include("figure.hrl").
-include("def_fun.hrl").

%% -----------------------------------------------------------------
%% @desc    功能描述  跨服冲榜进程初始化
%% @param   参数
%% @return  返回值 #cluster_rank_status{}
%% -----------------------------------------------------------------
init() ->
    State0 = init_cycle_rank_info(),
    State1 = init_rank_list(State0),  %% 拿取数据库中排名数据
    State2 = set_close_timer_ref(State1),   %% 计算最早结束的活动
    State3 = set_timer_to_start_act(State2),  %% 计算最早开启的活动
    State4 = set_timer_to_show_act(State3),   %% 计算展示活动的时间
    State4.

%% 初始化进程关于循环冲榜的相关信息
init_cycle_rank_info() ->
    %% 计算获取所有符合时间段要求的循环冲榜信息
    %% InitList = lib_cycle_rank_cfg:get_open_cycle_rank_info(),
    %% Fun = fun(CycleRank, {OpenActL, ShowActL}) ->
    %%     case lib_cycle_rank_util:kf_check_is_open(CycleRank) of
    %%         true ->
    %%             NewOpenAct = [CycleRank|OpenActL],
    %%             NewShowAct = ShowActL;
    %%         false ->
    %%             NewOpenAct = OpenActL,
    %%             IsShow = lib_cycle_rank_util:kf_check_is_show(CycleRank),
    %%             NewShowAct = ?IF(IsShow, [CycleRank|ShowActL], ShowActL)
    %%     end,
    %%     {NewOpenAct, NewShowAct}
    %% end,
    %% {LastOpenAct, LastShowAct} = lists:foldl(Fun, {[], []}, InitList),
    %% 2022-08-03 优化调整，只根据当前时间来计算即将开启的活动等信息，减少进程状态存储的数据量
    {LastOpenActL, LastShowActL, NextActL, _IsNewOrder} = lib_cycle_rank_cfg:calc_open_and_show_activity(),
    #cluster_rank_status{
        all_cycle_rank = LastOpenActL ++ LastShowActL ++ NextActL, opening_act = LastOpenActL,
        show_act_info = LastShowActL, role_send_time_limit = #{}
    }.

init_rank_list(State) ->
    #cluster_rank_status{ opening_act = AllOpenActList, show_act_info = ShowActList } = State,
    Sql = io_lib:format(?sql_select_all_cycle_rank_info, []),
    case db:get_all(Sql) of
        [] ->
            LastRankList = [];
        RoleList ->
            RankTypeList = make_mod_rank_record(RoleList, []),
            LastRankList = sort_all_type_rank(RankTypeList, AllOpenActList ++ ShowActList, [])
    end,
    State#cluster_rank_status{rank_list = LastRankList}.

%% 组合进程榜单Record
make_mod_rank_record([], RankTypeList) ->
    RankTypeList;
make_mod_rank_record([RoleInfo|T], RankTypeList) ->
    [RoleId, Type, SubType, ServerId, Form, ServerNum, Name, Score, Time] = RoleInfo,
    PForm = binary_to_list(Form),
    RankRole = #rank_role{
        node = ServerId, id = RoleId, server_id = ServerId,
        platform = PForm, server_num = ServerNum, score = Score,
        figure = #figure{name = Name}, last_time = Time
    },
    NewRankTypeList= make_data_rank_record(Type, SubType, RankTypeList, RankRole),
    make_mod_rank_record(T, NewRankTypeList).

%% 按类型归类排名信息
make_data_rank_record(Type, SubType, RankTypeList, RankRole) ->
    TypeKey = {Type, SubType},
    case lists:keyfind(TypeKey, #rank_type.id, RankTypeList) of
        #rank_type{ rank_role_list = RankList } = RankTypeData ->
            NewRankList = [RankRole|RankList],
            NewRankTypeData = RankTypeData#rank_type{ rank_role_list = NewRankList },
            lists:keystore(TypeKey, #rank_type.id, RankTypeList, NewRankTypeData);
        _ ->
            NewRankList = [RankRole],
            NewRankTypeData = #rank_type{id = TypeKey, type = Type, subtype = SubType, rank_role_list = NewRankList},
            lists:keystore(TypeKey, #rank_type.id, RankTypeList, NewRankTypeData)
    end.

%% 对数据库所有类型的冲榜类型数据进行排行
sort_all_type_rank([], _AllOpenActList, SortList) ->
    SortList;
sort_all_type_rank([RankTypeData|Tail], AllOpenActList, SortList) ->
    #rank_type{id = {Type, SubType}, rank_role_list = RankList } = RankTypeData,
    case lib_cycle_rank_util:is_kf_clear(Type, SubType, AllOpenActList) of
        true->
            %% 清除不在开启时间段且不处于展示期的数据
            Sql = io_lib:format(?sql_delete_cycle_rank_info, [Type, SubType]),
            db:execute(Sql),
            sort_all_type_rank(Tail, AllOpenActList, SortList);
        false->
            {NewRankList, LimitScore} = sort_rank_list(RankList, Type, SubType),
            NewRankTypeData = RankTypeData#rank_type{rank_role_list = NewRankList, score_limit = LimitScore},
            sort_all_type_rank(Tail, AllOpenActList, [NewRankTypeData|SortList])
    end.

%% 针对某种确切的榜单数据进行排行
sort_rank_list([], _Type, _SubType) ->
    {[], 0};
sort_rank_list(RankList , Type, SubType) ->
    NewRankList = sort_rank_list(RankList),
    FixRankList = set_role_ranking(NewRankList, Type, SubType, 1, []),
    Max = get_rank_max(Type, SubType),
    {LastRankList, LastScore} = get_limit_score(Type, SubType, FixRankList, Max),
    {LastRankList, LastScore}.

%% 按积分排序，积分相同按时间
sort_rank_list(RankList)->
    F = fun(RoleA,RoleB)->
        if
            RoleA#rank_role.score > RoleB#rank_role.score -> true;
            RoleA#rank_role.score < RoleB#rank_role.score -> false;
            RoleA#rank_role.last_time < RoleB#rank_role.last_time -> true;
            true ->
                false
        end
    end,
    lists:sort(F,RankList).

%% 设置玩家名次
set_role_ranking([], _Type, _SubType, _InitRank, List) ->
    lists:reverse(List);
set_role_ranking([RankRole|Tail], Type, SubType, InitRank, List) ->
    #rank_role{score = Score} = RankRole,
    case lib_cycle_rank_util:check_enter_rank(Type, SubType, Score) of
        false->
            set_role_ranking(Tail, Type, SubType, InitRank, List);
        {RankMin,_RankMax}->
            case InitRank >= RankMin of
                true->
                    set_role_ranking(Tail, Type, SubType, InitRank + 1, [RankRole#rank_role{rank=InitRank}|List]);
                false->
                    set_role_ranking(Tail, Type, SubType, RankMin + 1, [RankRole#rank_role{rank=RankMin}|List])
            end
    end.

%% 获取榜单长度
get_rank_max(Type,SubType)->
    List = data_cycle_rank:get_all_rank_max(Type, SubType),
    case List == [] of
        true-> 0;
        false-> lists:max(List)
    end.

%% 获取上限内榜单和最低分数
get_limit_score(Type, SubType, List, Max)->
    Length = length(List),
    case Length >= Max of
        true->
            SortList = lists:keysort(#rank_role.rank, List),
            {NRankList, DelList} = lists:split(Max, SortList),
            LastRole = lists:last(NRankList),
            LastScore = LastRole#rank_role.score,
            lib_cycle_rank_util:db_delete_cycle_rank_role_id(Type, SubType, DelList),
            {NRankList, LastScore};
        false-> {List,0}
    end.

%% 设置最早结束活动的定时器
set_close_timer_ref(State) ->
    #cluster_rank_status{opening_act = OpenAct, end_timer = ORef} = State,
    util:cancel_timer(ORef),
    NowSec = utime:unixtime(),
    Fun = fun(ActInfo, EList)->
        #base_cycle_rank_info{end_time = EndTime} = ActInfo,
        case NowSec < EndTime of
            true->
                [EndTime|EList];
            false->
                EList
        end
    end,
    EndList = lists:foldl(Fun, [], OpenAct),
    %%开启关闭活动定时器
    case EndList == [] of
        true->
            State#cluster_rank_status{end_timer = 0};
        false->
            SortList = lists:sort(EndList),
            ETime = hd(SortList),
            RefTime = max(ETime - NowSec + 6, 10), %% 至少延迟10秒结算
            Ref = erlang:send_after(RefTime * 1000, self(), {close_cycle_rank}),
            State#cluster_rank_status{end_timer = Ref}
    end.

%% 设置最早开启的活动定时器
set_timer_to_start_act(State)->
    #cluster_rank_status{opening_act = OpenAct, start_timer = OldRef, all_cycle_rank = AllActList} = State,
    util:cancel_timer(OldRef),
    NowSec = utime:unixtime(),
    F = fun(ActInfo, SList)->
        #base_cycle_rank_info{start_time = StartTime} = ActInfo,
        case NowSec < StartTime andalso not lists:member(ActInfo, OpenAct) of
            true-> [StartTime|SList];
            false-> SList
        end
    end,
    StartList = lists:foldl(F, [], AllActList),
    %% 开启关闭活动定时器
    case StartList == [] of
        true->
            State#cluster_rank_status{ start_timer = 0 };
        false->
            SortList = lists:sort(StartList),
            STime = hd(SortList),
            RefTime = max(STime - NowSec + 8, 12),
            Ref = erlang:send_after(RefTime*1000, self(), {open_cycle_rank}),
            State#cluster_rank_status{start_timer = Ref}
    end.

%%展示活动关闭定时器
set_timer_to_show_act(State)->
    #cluster_rank_status{show_act_info = ShowAct, show_timer = ORef} = State,
    util:cancel_timer(ORef),
    Now = utime:unixtime(),
    %% ShowActDay = data_cycle_rank:get_kv_cfg(show_act_day), %% 展示已结算的天数
    ShowActDay = 1,
    F = fun(ActInfo,EList)->
        #base_cycle_rank_info{end_time = EndTime} = ActInfo,
        [EndTime + ShowActDay * 86400| EList]
    end,
    EndList = lists:foldl(F,[],ShowAct),
    case EndList == [] of
        true->
            State#cluster_rank_status{show_timer = 0};
        false->
            SortList = lists:sort(EndList),
            ETime = hd(SortList),
            RefTime = max(ETime - Now + 4, 8),
            Ref = erlang:send_after(RefTime*1000, self(), {close_show_act}),
            State#cluster_rank_status{show_timer = Ref}
    end.

%% 执行冲榜活动结束定时器
%% 活动关闭时主要步骤：
%% 1. 计算出下一个迭代的活动；2. 结算当前活动的榜单，并补发邮件等；3. 更新需要展示的数据。
%% 4. 清楚掉已过展示期的榜单数据
close_cycle_rank(State) ->
    #cluster_rank_status{
        opening_act = OpenAct,
        rank_list = RankList,
        show_act_info = ShowAct,
        all_cycle_rank = AllActList
    } = State,
    NowSec = utime:unixtime(),
    {CloseAct, NewOpenAct, AddShowAct, NewShowAct, NewAllActList} = calc_close_cycle_rank(OpenAct, NowSec, [], OpenAct, [], ShowAct, AllActList),
    case CloseAct of
        [] ->
            ok;
        _ ->
            spawn(fun() ->
                %% 结合新增的展示活动类型来判断是否需要清楚榜单数据
                delete_db_cycle_rank_role_info(CloseAct, AddShowAct, 0),
                %% 计算结束的活动是否需要进行结算操作
                do_close_cycle_rank(CloseAct, RankList),
                %% 通知游戏节点循环冲榜进程清算对应的活动的数据
                Args = {close_cycle_rank, CloseAct, AddShowAct},
                mod_clusters_center:apply_to_all_node(mod_cycle_rank_local, synch_cycle_rank_info, [Args], 100)
            end)
    end,
    %% 更新缓存中的榜单数据
    NewRankList = update_cache_rank(RankList, CloseAct, AddShowAct),
    NewState = State#cluster_rank_status{
        opening_act = NewOpenAct,
        show_act_info = NewShowAct,
        rank_list = NewRankList,
        all_cycle_rank = NewAllActList
    },
    NewState2 = set_close_timer_ref(NewState),
    case AddShowAct of
        [] ->
            NewState3 = NewState2;
        _ ->
            NewState3 = set_timer_to_show_act(NewState2)
    end,
    {noreply, NewState3}.

%% 冲开启列表中找到需要关闭的活动、需要展示的活动等
%% 同时为控制state大小，清除all_cycle_rank字段中对应的活动信息
calc_close_cycle_rank([], _NowSec, CloseAct, OpenAct, AddShowAct, ShowAct, AllActList) ->
    {CloseAct, OpenAct, AddShowAct, ShowAct, AllActList};
calc_close_cycle_rank([ActInfo|Tail], NowSec, CloseAct, OpenAct, AddShowAct, ShowAct, AllActList) ->
    %% 判断是否需要关闭活动
    case lib_cycle_rank_util:kf_check_is_open(ActInfo) of
        true ->
            %%没结束
            calc_close_cycle_rank(Tail, NowSec, CloseAct, OpenAct, AddShowAct, ShowAct, AllActList);
        false ->
            %%结束
            NewOpenAct = lists:delete(ActInfo, OpenAct),
            NewAllActList = lists:delete(ActInfo, AllActList),
            NewCloseAct = [ActInfo|CloseAct],
            case lib_cycle_rank_util:kf_check_is_show(ActInfo) of
                true-> %% 是否处于展示期
                    NewShowAct = [ActInfo|ShowAct],
                    NewAddShowAct = [ActInfo|AddShowAct],
                    calc_close_cycle_rank(Tail, NowSec, NewCloseAct, NewOpenAct, NewAddShowAct, NewShowAct, NewAllActList);
                false->
                    calc_close_cycle_rank(Tail, NowSec, NewCloseAct, NewOpenAct, AddShowAct, ShowAct, NewAllActList)
            end
    end.

%% 清除数据库中对应活动的排行数据
delete_db_cycle_rank_role_info([], _AddShowAct, _RunTimes) ->
    ok;
delete_db_cycle_rank_role_info([ActInfo|Tail], AddShowAct, RunTimes) ->
    case lists:member(ActInfo, AddShowAct) of
        true ->
            %% 需要展示榜单的活动不进行清理
            delete_db_cycle_rank_role_info(Tail, AddShowAct, RunTimes);
        false ->
            case RunTimes >= 5 of
                true ->  %% 函数执行五次后，睡眠100毫秒
                    timer:sleep(100),
                    NewRunTimes = 0;
                false ->
                    NewRunTimes = RunTimes + 1
            end,
            #base_cycle_rank_info{ type = Type, sub_type = SubType } = ActInfo,
            Sql = io_lib:format(?sql_delete_cycle_rank_info, [Type, SubType]),
            db:execute(Sql),
            delete_db_cycle_rank_role_info(Tail, AddShowAct, NewRunTimes)
    end.

%% 结算结束的活动
do_close_cycle_rank([], _RankList) ->
    ok;
do_close_cycle_rank([ActInfo|Tail], RankList) ->
    #base_cycle_rank_info{ type = Type, sub_type = SubType } = ActInfo,
    KeyType = {Type, SubType},
    case lists:keyfind(KeyType, #rank_type.id, RankList) of
        #rank_type{ rank_role_list = RoleList } ->
            NewRoleList = sort_rank_list(RoleList),
            FixRoleList = set_role_ranking(NewRoleList, Type, SubType, 1, []),
            Max = get_rank_max(Type, SubType),
            %% 结算
            NewRoleList2 = lists:sublist(FixRoleList, Max),
            {SortRoleList, _LastScore} = get_limit_score(Type, SubType, NewRoleList2, Max),
            settlement_cycle_rank_role(SortRoleList, Type, SubType),
            NewRankList = lists:keydelete(KeyType, #rank_type.id, RankList),
            %%通知本地删除对应类型db并进行目标阶段的结算
            mod_clusters_center:apply_to_all_node(mod_cycle_rank_local, over_player_cycle_rank_info, [Type, SubType], 100),
            do_close_cycle_rank(Tail, NewRankList);
        _ ->
            do_close_cycle_rank(Tail, RankList)
    end.

%% 结算活动的榜单，分发奖励
settlement_cycle_rank_role([], _Type, _SubType) ->
    ok;
settlement_cycle_rank_role([RankRole|Tail], Type, SubType) ->
    #rank_role{
        rank = Rank, id = RoleId, server_id = ServerId,
        figure = #figure{ name = RoleName }, score = Score
    } = RankRole,
    RewardId = data_cycle_rank:get_rank_reward_id(Type, SubType, Rank),
    case data_cycle_rank:get_rank_reward(Type, SubType, RewardId) of
        #base_cycle_rank_reward{ rewards = RankReward }  ->
            %% 缺排名日志
            timer:sleep(500),
            %% 通知游戏节点执行send_rank_reward函数
            lib_log_api:log_cycle_rank_rank_reward(RoleId, RoleName, ServerId, Type, SubType, Score, Rank, RankReward),
            mod_clusters_center:apply_cast(ServerId, lib_cycle_rank_local_mod, send_rank_reward, [Type, SubType, RoleId, Rank, RankReward]),
            settlement_cycle_rank_role(Tail, Type, SubType);
        _ ->
            settlement_cycle_rank_role(Tail, Type, SubType)
    end.

%%活动结束删除排行榜
update_cache_rank(RankList, [], _) ->
    RankList;
update_cache_rank(RankList, [ActInfo|T], ShowAct)->
    case lists:member(ActInfo, ShowAct) of
        true->
            update_cache_rank(RankList, T, ShowAct);
        false->
            #base_cycle_rank_info{type = Type, sub_type = SubType} = ActInfo,
            NRankList = lists:keydelete({Type, SubType}, #rank_type.id, RankList),
            update_cache_rank(NRankList, T, ShowAct)
    end.

%% 更新榜单
update_cycle_rank_list([Type, SubType, RankRole, IsNeedRank], State) ->
    #cluster_rank_status{ rank_list = RankList } = State,
    #rank_role{ score = Score, id = RoleId, server_id = ServerId, figure = #figure{ name = RoleName } } = RankRole,
    case lib_cycle_rank_util:check_enter_rank(Type, SubType, Score) of
        false ->  %% 未达到进榜的最低要求
            LastState = lib_cycle_rank_util:send_num_to_reach_reward(State, {Type, SubType}, RoleId, Score, ServerId);
        {RankMin, _RankMax} ->
            KeyType = {Type, SubType},
            RankTypeData = lists:keyfind(KeyType, #rank_type.id, RankList),
            case RankTypeData of
                false ->  %% 无改榜单数据，直接进榜
                    AddRankRole = RankRole#rank_role{rank = RankMin},
                    NewRankRoleList = [AddRankRole],
                    NewRankTypeData = #rank_type{ id = KeyType, subtype = SubType, type = Type, rank_role_list = NewRankRoleList },
                    %% 进榜日志
                    lib_log_api:log_cycle_rank_rank(RoleId, RoleName, Type, SubType, Score, RankMin, ServerId),
                    lib_cycle_rank_util:db_update_cycle_rank_role(Type, SubType, RankRole);
                _ ->
                    {NewRankTypeData, AddRankRole} = do_update_cycle_rank_list(Type, SubType, RankRole, RankMin, RankTypeData, IsNeedRank)
            end,
            NewRankList = lists:keystore(KeyType, #rank_type.id, RankList, NewRankTypeData),
            NewState = State#cluster_rank_status{ rank_list = NewRankList },
            %% 当对应排行榜发生变化时，通知游戏节点更新对应榜单信息
            case AddRankRole of
                [] ->
                    skip;
                _ ->
                    mod_clusters_center:apply_to_all_node(mod_cycle_rank_local, syn_cycle_rank_role, [Type, SubType, AddRankRole], 100)
            end,
            %% 判断榜单，发送榜单通知22705
            #rank_type{ rank_role_list = NewRankRoleList33 } = NewRankTypeData,
            case RankTypeData of
                #rank_type{ rank_role_list = OldList33 } ->
                    OldRankRoleList33 = OldList33;
                _ ->
                    OldRankRoleList33 = []
            end,
            LastState = send_rank_change_notify_help(NewState, KeyType, OldRankRoleList33, NewRankRoleList33, RoleId, Score, ServerId)

    end,
    LastState.

%% 执行进榜
do_update_cycle_rank_list(Type, SubType, RankRole, RankMin, RankType, IsNeedRank)->
    #rank_type{rank_role_list = RankRoleList } = RankType,
    #rank_role{
        id = RoleId, score = Score, server_id = ServerId, figure = #figure{name = RoleName}
    } = RankRole,
    Max = get_rank_max(Type,SubType),
    if
        RankRoleList == [] -> %%无人上榜，直接RankMin
            AddRankRole = RankRole#rank_role{rank = RankMin},
            NewRankList = [AddRankRole],
            NewRankType = #rank_type{ rank_role_list = NewRankList },
            %% 上榜日志记录
            lib_log_api:log_cycle_rank_rank(RoleId, RoleName, Type, SubType, Score, RankMin, ServerId),
            lib_cycle_rank_util:db_update_cycle_rank_role(Type, SubType, RankRole);
        length(RankRoleList) >= Max andalso Score =< RankType#rank_type.score_limit -> %%榜满人并且比最后一名还低分不计算
            NewRankType = RankType,
            AddRankRole = [];
        true -> %%上榜
            case IsNeedRank of
                ?NEED_TO_BE_REORDERED ->
                    NewRankRoleList = lists:keydelete(RoleId, #rank_role.id, RankRoleList),
                    TmpRankList = sort_rank_list([RankRole|NewRankRoleList]),
                    NewRankRoleList1 = set_role_ranking(TmpRankList, Type, SubType, 1, []);
                _ ->
                    case lists:keyfind(RoleId, #rank_role.id, RankRoleList) of
                        false ->
                            NewRankRoleList1 = lists:keystore(RoleId, #rank_role.id, RankRoleList, RankRole);
                        #rank_role{  } = OldRankRole ->
                            NewRankRole = OldRankRole#rank_role{ score = RankRole#rank_role.score },
                            NewRankRoleList1 = lists:keystore(RoleId, #rank_role.id, RankRoleList, NewRankRole)
                    end
            end,
            case length(NewRankRoleList1) >= Max of
                true->
                    {LastRankRoleList, LastScore} = get_limit_score(Type, SubType, NewRankRoleList1, Max),
                    %%判断是否入库
                    case lists:keyfind(RoleId, #rank_role.id, LastRankRoleList) of
                        false->
                            AddRankRole = [];
                        #rank_role{ rank = LogRank } = Add ->
                            %% 上榜日志记录
                            lib_log_api:log_cycle_rank_rank(RoleId, RoleName, Type, SubType, Score, LogRank, ServerId),
                            AddRankRole = Add,
                            lib_cycle_rank_util:db_update_cycle_rank_role(Type, SubType, RankRole)
                    end,
                    NewRankType = RankType#rank_type{ rank_role_list = LastRankRoleList, score_limit = LastScore};
                false-> %% 榜单长度未超，可直接上榜
                    case lists:keyfind(RoleId, #rank_role.id, NewRankRoleList1) of
                        false->
                            AddRankRole = [];
                        #rank_role{rank = LogRank} = Add ->
                            %% 上榜日志记录
                            lib_log_api:log_cycle_rank_rank(RoleId, RoleName, Type, SubType, Score, LogRank, ServerId),
                            AddRankRole = Add
                    end,
                    lib_cycle_rank_util:db_update_cycle_rank_role(Type, SubType, RankRole),
                    NewRankType = RankType#rank_type{ rank_role_list = NewRankRoleList1 }
            end
    end,
    {NewRankType, AddRankRole}.

%% 同步中心服的数据到某个节点
sync_cycle_rank_data_to_node(Node, State) ->
    #cluster_rank_status{ opening_act = OpenActList, show_act_info = ShowActInfo, rank_list = RankList, all_cycle_rank = AllCycleRank } = State,
    Args = [OpenActList, ShowActInfo, RankList, AllCycleRank],
    mod_clusters_center:apply_cast(Node, mod_cycle_rank_local, sync_cycle_rank_data_from_center, [Args]),
    {noreply, State}.

%% 执行开启定时器的主要逻辑
%%定时开启活动
open_cycle_rank(State)->
    #cluster_rank_status{ opening_act = OpenAct } = State,
    Now = utime:unixtime(),
    %% 20220824版本
    %% 修改上版本优化问题 - 没有下个活动的信息
    %% 修改思路，因为AllActList 量已经优化到很小了，所有，这里重算一次，确保执行到此处时有只要配置到永远都会包含下一个开启的活动
    {OpenActL, ShowActL, NextActL, _IsNewOrder} = lib_cycle_rank_cfg:calc_open_and_show_activity(),
    InitNewAllActList = OpenActL ++ ShowActL ++ NextActL,
    {AddAct, NewOpeningAct} = do_open_cycle_rank(InitNewAllActList, OpenAct, Now, []),
    StateTemp = State#cluster_rank_status{
        opening_act = NewOpeningAct,
        all_cycle_rank = InitNewAllActList
    },
    NewState0 = set_timer_to_start_act(StateTemp),
    NewState = sure_cycle_rank_end(NewState0),
    case AddAct == [] of
        true->
            LastState = NewState;
        false ->
            LastState = set_close_timer_ref(NewState),
            %% 通知游戏节点循环冲榜进程清算对应的活动的数据
            LastAllActList = LastState#cluster_rank_status.all_cycle_rank,
            %% Args = {open_cycle_rank, AddAct},
            Args = {open_cycle_rank, AddAct, LastAllActList}, %% 这里选择最新所有的活动信息都在跨服上计算好再传到节点进行更新
            mod_clusters_center:apply_to_all_node(mod_cycle_rank_local, synch_cycle_rank_info, [Args], 100)
    end,
    {noreply, LastState}.

do_open_cycle_rank([], OpenAct, _Now, AddAct) ->
    {AddAct, OpenAct};
do_open_cycle_rank([ActInfo| T], OpenAct, Now, AddAct) ->
    case lists:member(ActInfo, OpenAct) of
        true ->
            %% 已经在开启中了
            do_open_cycle_rank(T, OpenAct, Now, AddAct);
        false ->
            case lib_cycle_rank_util:kf_check_is_open(ActInfo) of
                true ->
                    NewOpeningAct = [ActInfo | OpenAct],
                    do_open_cycle_rank(T, NewOpeningAct, Now, [ActInfo | AddAct]);
                _ ->
                    do_open_cycle_rank(T, OpenAct, Now, AddAct)
            end
    end.

%%定时关闭展示活动
close_show_act(State)->
    #cluster_rank_status{show_act_info = ShowAct, rank_list=RankList} = State,
    Now = utime:unixtime(),
    {DelAct, NewShowAct} = do_close_show_act(ShowAct, Now, [], ShowAct),
    case DelAct == [] of
        true-> ok;
        false->
            %%通知活动（跨服量多）
            spawn(fun()->
                delete_db_cycle_rank_role_info(DelAct, [], 0)
            end)
    end,
    ?MYLOG("lhh", "~p:~p~n",[DelAct, NewShowAct]),
    NRankList = update_cache_rank(RankList, DelAct, []),
    StateTemp = State#cluster_rank_status{show_act_info = NewShowAct, rank_list=NRankList},
    NewState = set_timer_to_show_act(StateTemp),
    %% 向各节点分发展示活动关闭事件
    Args = {close_show_cycle_rank, DelAct},
    mod_clusters_center:apply_to_all_node(mod_cycle_rank_local, synch_cycle_rank_info, [Args], 100),
    {noreply, NewState}.

do_close_show_act([], _Now, DelAct, ShowAct) -> {DelAct, ShowAct};
do_close_show_act([ShowInfo | T], Now, DelAct, ShowAct) ->
    #base_cycle_rank_info{end_time = EndTime} = ShowInfo,
    case EndTime + ?ONE_DAY_SECONDS > Now of
        true->
            do_close_show_act(T, Now, DelAct, ShowAct);
        false->
            do_close_show_act(T, Now, [ShowInfo|DelAct], lists:delete(ShowInfo,ShowAct))
    end.

%% 确保结算定时器执行前结算活动## yy3d_tw 出过一次未结算问题添加#时间戳问题导致
%% 开启活动定时器先执行，取消了结算定时器#极低概率
sure_cycle_rank_end(#cluster_rank_status{end_timer = EndRef} = State) when is_reference(EndRef) ->
    case catch erlang:read_timer(EndRef) of
        {'EXIT', _} ->
            State#cluster_rank_status{ end_timer = 0 };
        false ->
            State#cluster_rank_status{ end_timer = 0 };
        Integer when is_integer(Integer) andalso Integer < 20 ->
            {_, NewState} = close_cycle_rank(State),
            NewState#cluster_rank_status{end_timer = util:cancel_timer(EndRef)};
        _ -> State
    end;
sure_cycle_rank_end(State) ->
    State.

%% 获取排行榜上榜的阀值
get_rank_limit_type(Type, SubType) ->
    AllRankId = data_cycle_rank:get_all_rank_reward_id(Type, SubType),
    F = fun(RankId, MaxLimit) ->
        Cfg = data_cycle_rank:get_rank_reward(Type, SubType, RankId),
        Limit = Cfg#base_cycle_rank_reward.limit_val,
        max(Limit, MaxLimit)
    end,
    lists:foldl(F, 0, AllRankId).

%% =========================  处理弹窗 22705 协议相关的 =================================

role_refresh_send_time(RoleId, State) ->
    #cluster_rank_status{ role_send_time_limit = AllRoleList } = State,
    F = fun(_, RoleMap) ->
        maps:remove(RoleId, RoleMap)
    end,
    NewMap = maps:map(F, AllRoleList),
    State#cluster_rank_status{ role_send_time_limit = NewMap }.

%% 发送榜单排名变化的通知
send_rank_change_notify_help(State, RankType, OldRankList, NewRankList, RoleId, RoleVal, ServerId) ->
    {Type, SubType} = RankType,
    MaxRankLen = lib_cycle_rank_mod:get_rank_max(Type, SubType),  %%榜单长度
    NewSubRankList = lists:sublist(NewRankList, MaxRankLen),
    OldSubRankList = lists:sublist(OldRankList, MaxRankLen), %%截取
    NowTime = utime:unixtime(),
    AllRankMax = data_cycle_rank:get_all_rank_max(Type, SubType),
    FixAllRankMax = [{R, 0} || R <- AllRankMax],
    F = fun(#rank_role{rank = Rank, score = Score}, RankMaxList) ->
        case lists:keyfind(Rank, 1, RankMaxList) of
            {Rank, _} ->
                lists:keystore(Rank, 1, RankMaxList, {Rank, Score});
            _ ->
                RankMaxList
        end
    end,
    RankLevelValue = lists:foldl(F, FixAllRankMax, NewSubRankList),
    F1 = fun(#rank_role{id = ListRoleId, rank = Rank, server_id = ListServerId}, AccState) ->
        case lib_cycle_rank_util:check_send_time_limit(AccState, RankType, ListRoleId, NowTime) of
            true ->
                case lists:keyfind(ListRoleId, #rank_role.id, NewSubRankList) of
                    #rank_role{rank = NewRank, score = NewValue} ->
                        %% 计算其他变化的通知
                        handle_rank_change(AccState, RankType, ListRoleId, Rank, NewRank, NewValue, RankLevelValue, RoleId, ListServerId);
                    false ->
                        % 旧榜单存在新榜单掉榜，则提示该名玩家被其他人超过
                        lib_cycle_rank_util:send_rank_change_info(AccState, ListRoleId, [RankType, ?CYCLE_RANK_NOTIFY_TYPE_3, 0, 0, 0], ListServerId)
                end;
            false -> AccState
        end
    end,
    %% 这一步主要通知新旧榜单差异的玩家
    NewState = lists:foldl(F1, State, OldSubRankList),
    lib_cycle_rank_util:send_num_to_reach_reward(NewState, RankType, RoleId, RoleVal, ServerId).

%% 处理排名变化
%% 被别人超过处理
handle_rank_change(State, RankType, RoleId, OldRank, NewRank, _NowValue,_RankLevelValue, _TriggerRoleId, Node) when OldRank < NewRank->
    %% 玩家在新榜单上的排名下降，通知该名玩家排名下降
    lib_cycle_rank_util:send_rank_change_info(State, RoleId, [RankType, ?CYCLE_RANK_NOTIFY_TYPE_3, 0, 0, 0], Node);
%% 排名提升处理
%% RankLevelValue 为一个list
handle_rank_change(State, RankType, RoleId, OldRank, NewRank, Value, RankLevelValue, TriggerRoleId, Node) when OldRank >= NewRank->
    OldLevel = calc_rank_level(OldRank, RankType),
    NewLevel = calc_rank_level(NewRank, RankType),
    {Type, SubType} = RankType,
    AllRankLevel = data_cycle_rank:get_all_rank_max(Type, SubType),
    CalcNextLevelDis = fun(Level) ->
        case Level of
            1 -> % 登临榜首
                {?CYCLE_RANK_NOTIFY_TYPE_0, 0, 0, 0};
            _ ->
                RankMax = lists:nth(Level - 1, AllRankLevel),
                RankValue = proplists:get_value(RankMax, RankLevelValue),
                {?CYCLE_RANK_NOTIFY_TYPE_2, RankMax, Value, RankValue}

        end
    end,
    case OldLevel =:= NewLevel of
        true ->
            % 第一名发送第二名何时追过
            case RoleId =:= TriggerRoleId of
                true ->
                    % 排名第一要发送第二名多久超过
                    case OldLevel =:= 1 of
                        true ->
                            State;
                        false ->
                            %% 计算距离上一个阶段最后一名的差距 发送类型是2
                            {SendType, NextRank, NowValue, NextValue} = CalcNextLevelDis(NewLevel),
                            {SendValue, SendSubValue} = calc_level_value(RankType, NowValue, NextValue, false),
                            case SendValue > 0 of
                                true ->
                                    lib_cycle_rank_util:send_rank_change_info(State, RoleId, [RankType, SendType, NextRank, SendValue, SendSubValue], Node);
                                false ->
                                    lib_cycle_rank_util:send_num_to_reach_reward(State, RankType, RoleId, Value, Node)
                            end
                    end;
                false ->
                    State
            end;
        false ->
            % 有其他玩家阶段发生变化，提示当前进榜的玩家提升多少到下一阶段
            {SendType, NextRank, NowValue, NextValue} = CalcNextLevelDis(NewLevel),
            {SendValue, SendSubValue} = calc_level_value(RankType, NowValue, NextValue, false),
            case SendValue > 0 of
                true ->
                    lib_cycle_rank_util:send_rank_change_info(State, RoleId, [RankType, SendType, NextRank, SendValue, SendSubValue], Node);
                false ->
                    lib_cycle_rank_util:send_num_to_reach_reward(State, RankType, RoleId, Value, Node)
            end
    end.

%% 计算排名阶段
%% 不再写死每个阶段
calc_rank_level(Rank, RankType) ->
    {Type, SubType} = RankType,
    AllRankLevel = data_cycle_rank:get_all_rank_max(Type, SubType),
    Fun = fun(CfgRankLevel, RankLevel) ->
        case Rank > CfgRankLevel of
            true ->
                util:get_list_elem_index(CfgRankLevel, AllRankLevel) + 1;
            false ->
                RankLevel
        end
    end,
    lists:foldl(Fun, 1, AllRankLevel).

%% 计算
%% IsLimit 是否是阈值
calc_level_value(_RankType, NowValue, NextValue, IsLimit) ->
    LevelDis = NextValue - NowValue,
    NewLevelDis = ?IF(IsLimit =:= true, LevelDis, LevelDis + 1),
    {NewLevelDis, 0}.

%% -----------------------------------------------------------------
%% @desc    功能描述  当处于有游戏节点连上跨服中心时, 若改游戏节点处于合服第一天则会修改榜单上在这次合服中
%%                   从服的ServerId成主服的ServerID与Node,防止结算时因为ServerId对应不上而导致奖励等无法正常发放
%% @param   参数
%% -----------------------------------------------------------------
fix_merge_server_data(State, ServerId, Node, MergeServerIds) ->
    ?MYLOG("lhh", "Merge_Server, Fix Cycle Rank Role Info:~p", [{ServerId, MergeServerIds}]),
    %% 修改有两个部分，一个是正在开启的数据，一个是处于展示期的数据
    #cluster_rank_status{ rank_list = RankList }  = State,
    FixServerIds = MergeServerIds -- [ServerId],
    case FixServerIds of
        [] ->
            NewState = State;
        _ ->
            Fun = fun(CycleRank) ->
                #rank_type{ rank_role_list = RankRoleList } = CycleRank,
                FixFun = fun(#rank_role{ server_id = OldServerId } = RankRole) ->
                    case lists:member(OldServerId, FixServerIds) of
                        true ->
                            NewRankRole = RankRole#rank_role{ server_id = ServerId, node = Node};
                        false ->
                            NewRankRole = RankRole
                    end,
                    NewRankRole
                end,
                NewRankRoleList = lists:map(FixFun, RankRoleList),
                CycleRank#rank_type{ rank_role_list = NewRankRoleList }
            end,
            NewRankList = lists:map(Fun, RankList),
            Args = {change_rank_role_server_info, NewRankList},
            mod_clusters_center:apply_to_all_node(mod_cycle_rank_local, synch_cycle_rank_info, [Args], 100),
            NewState = State#cluster_rank_status{ rank_list = NewRankList }
    end,
    lib_cycle_rank_mod:sync_cycle_rank_data_to_node(Node, NewState),
    NewState.

%% -----------------------------------------------------------------
%% @desc    功能描述 玩家修改昵称时同步修改榜单的数据
%% -----------------------------------------------------------------
change_role_name(PlayerId, PlayerName, State) ->
    #cluster_rank_status{ rank_list = RankList } = State,
    Fun = fun(#rank_type{ rank_role_list = RankRoleList } = RankType) ->
        case lists:keyfind(PlayerId, #rank_role.id, RankRoleList) of
            #rank_role{ figure = Figure } = RankRole ->
                NewFigure = Figure#figure{ name = PlayerName },
                NewRankRole = RankRole#rank_role{ figure = NewFigure },
                NewRankRoleList = lists:keystore(PlayerId, #rank_role.id, RankRoleList, NewRankRole);
            _ ->
                NewRankRoleList = RankRoleList
        end,
        RankType#rank_type{ rank_role_list = NewRankRoleList }
    end,
    NewRankList = lists:map(Fun, RankList),
    %% 派发到个人游戏节点
    Args = {change_rank_role_server_info, NewRankList},
    mod_clusters_center:apply_to_all_node(mod_cycle_rank_local, synch_cycle_rank_info, [Args], 100),
    State#cluster_rank_status{ rank_list = NewRankList }.

%% 每晚23点30分计算前中后三天的活动时间数据
calc_daily_act_info(State) ->
    {LastOpenActL, LastShowActL, NextActL, _IsNewOrder} = lib_cycle_rank_cfg:calc_open_and_show_activity(),
    AllCycleRankList = LastOpenActL ++ LastShowActL ++ NextActL,
    State#cluster_rank_status{
        all_cycle_rank = AllCycleRankList, opening_act = LastOpenActL,
        show_act_info = LastShowActL, role_send_time_limit = #{}
    }.

%% reopen
gm_reopen_cycle_rank(State) ->
    {LastOpenActL, LastShowActL, NextActL, _IsNewOrder} = lib_cycle_rank_cfg:calc_open_and_show_activity(),
    TemState = State#cluster_rank_status{
        all_cycle_rank = LastOpenActL ++ LastShowActL ++ NextActL,
        opening_act = LastOpenActL,
        show_act_info = LastShowActL
    },
    TemState1 = set_close_timer_ref(TemState),
    TemState2 = set_timer_to_start_act(TemState1),
    TemState3 = set_timer_to_show_act(TemState2),
    #cluster_rank_status{ opening_act = OpenActList, show_act_info = ShowActInfo, rank_list = RankList, all_cycle_rank = AllCycleRank } = TemState3,
    Args = [OpenActList, ShowActInfo, RankList, AllCycleRank],
    mod_clusters_center:apply_to_all_node(mod_cycle_rank_local, sync_cycle_rank_data_from_center, [Args], 100),
    TemState3.

%% 重算定时器
gm_recalculate_timer(State) ->
    {LastOpenActL, LastShowActL, NextActL, _IsNewOrder} = lib_cycle_rank_cfg:calc_open_and_show_activity(),
    TemState = State#cluster_rank_status{
        all_cycle_rank = LastOpenActL ++ LastShowActL ++ NextActL
    },
    TemState1 = set_close_timer_ref(TemState),
    TemState2 = set_timer_to_start_act(TemState1),
    TemState2.

%% =============================================
%% GM 测试跨天情况使用
%% =============================================
gm_refresh(State) ->
    #cluster_rank_status{ rank_list = RankList } = State,
    ?PRINT("GM_Refresh:~p~n", [RankList]),
    init_rank_list(State).

%%刷新所有定时器秘籍（运营修改正在开启活动的配置时间相关时用）
gm_refresh_ref()->
    State0 = init_cycle_rank_info(),
    State1 = init_rank_list(State0),  %% 拿取数据库中排名数据
    State2 = set_close_timer_ref(State1),   %% 计算最早结束的活动
    State3 = set_timer_to_start_act(State2),  %% 计算最早开启的活动
    State4 = set_timer_to_show_act(State3),   %% 计算展示活动的时间
    State4.