%%%------------------------------------
%%% @Module  : lib_flower_act_mod
%%% @Author  :  xiaoxiang
%%% @Created :  2016-11-17
%%% @Description: 跨服魅力榜活动
%%%------------------------------------
-module(lib_kf_flower_act_mod).


-compile(export_all).

-include("errcode.hrl").
-include("language.hrl").
-include("flower_rank_act.hrl").
-include("common.hrl").
-include("record.hrl").
-include("relationship.hrl").
-include("figure.hrl").
-include("role.hrl").
-include("def_fun.hrl").
-include("def_module.hrl").
-include("flower.hrl").
-include("goods.hrl").
-include("predefine.hrl").
-include("def_goods.hrl").
-include("designation.hrl").

make_record([RankType, SubType, RoleId, Value, ServerId, Platform, ServerNum, Name, Sex, Career, Turn, WLv, Time]) ->
    #rank_role_kf{
        role_key   = {RankType, SubType, RoleId},        % {RankType, RoleId}
        rank_type  = RankType,                  % 榜单类型
        sub_type   = SubType,                   % 活动子类型
        role_id    = RoleId,                    % 角色id
        value      = Value,                     % 排序值
        server_id  = ServerId,                  %% 服务器id
        zone_id    = lib_clusters_center_api:get_zone(ServerId),
        platform   = Platform,                  %% 平台名字
        server_num = ServerNum,                 %% 所在的服标示
        name       = Name,                      %% 名字
        sex        = Sex,                       %% 性别
        career     = Career,                    %% 职业
        turn       = Turn,                      %% 转生数
        wlv        = WLv,
        time       = Time                       % 时间戳
    }.


init() ->
    %% 个人数据
    List = db_rank_role_kf_select(),
    RoleList = [make_record(T) || T <- List],
    % 个人榜单
    % F = fun
    %         (#rank_role_kf{rank_type = RankType, sub_type = SubType} = Role, AccMap) ->
    %             case maps:get({RankType, SubType}, AccMap, false) of
    %                 false -> NewList = [Role];
    %                 TmpL -> NewList = [Role | TmpL]
    %             end,
    %             maps:put({RankType, SubType}, NewList, AccMap)
    %     end,
    % RoleMaps = lists:foldl(F, #{}, RoleList),
    %% 排名列表
    RankList = get_standard_sort_rank_maps(RoleList),
    %% 阈值
    RoleLimitList = clean_redundant_rank_data(RankList),
    RankLimit = maps:from_list(RoleLimitList),
    %?PRINT("init#RankList:~p~n", [RankList]),
    %?PRINT("init#RankLimit:~p~n", [RankLimit]),
    #kf_rank_state{rank_list = RankList, rank_limit = RankLimit}.

%% 获得标准排序Maps(被截取了长度) Key:{RankType, ActType} Value:[#rank_role_kf{}]
get_standard_sort_rank_maps(RoleList) ->
    RankList = get_sort_rank_maps(RoleList),
    RankList.

%% 
get_sort_rank_maps(RoleList) ->
    F = fun(#rank_role_kf{rank_type = RankType, sub_type = SubType} = RankRole, RankList) ->
        {_, List} = ulists:keyfind({RankType, SubType}, 1, RankList, {{RankType, SubType}, []}),
        NewList = [RankRole | List],
        lists:keystore({RankType, SubType}, 1, RankList, {{RankType, SubType}, NewList})
    end,
    RankList = lists:foldl(F, [], RoleList),
    sort_rank_maps(RankList).

%% 对Maps的Value排序
sort_rank_maps(RankList) ->
    F = fun({{RankType, SubType}, List}) ->
        MaxRankLen = lib_flower_act:get_max_len(RankType, SubType),
        TypeRankList = sort_rank_list(List),
        NewTypeRankList = set_rank_list(RankType, SubType, MaxRankLen, TypeRankList),
        %LastTypeRankList = lists:sublist(NewTypeRankList, MaxRankLen),
        {{RankType, SubType}, NewTypeRankList}
    end,
    NewRankList = lists:map(F, RankList),
    NewRankList.

%% 根据排序值排序
sort_rank_list(List) ->
    F = fun(A, B) ->
        if
            A#rank_role_kf.value > B#rank_role_kf.value -> 
                true;
            A#rank_role_kf.value == B#rank_role_kf.value ->
                A#rank_role_kf.time =< B#rank_role_kf.time;
            true ->
                false
        end
    end,
    NewList = lists:sort(F, List),
    NewList.
    % F1 = fun(Member, {TempList, Value}) ->
    %         NewMember = Member#rank_role_kf{rank = Value},
    %         NewTempList = [NewMember | TempList],
    %         {NewTempList, Value + 1}
    % end,
    % {NewRankList, _} = lists:foldl(F1, {[], 1}, NewList),
    % lists:reverse(NewRankList).

%% 设置排名
set_rank_list(RankType, SubType, MaxRankLen, TypeRankList) ->
    ScoreRankCon1 = lib_flower_act:get_score_rank_condition(RankType, SubType),
    ScoreRankCon = lists:keysort(1, ScoreRankCon1),
    NewTypeRankList = set_rank(TypeRankList, ScoreRankCon, 1, MaxRankLen, []),
    NewTypeRankList.

set_rank([], _ScoreRankCon, _InitRank, _MaxRankLen, List)->lists:reverse(List);
set_rank([RankRole|T], ScoreRankCon, InitRank, MaxRankLen, List)->
    #rank_role_kf{value = Score} = RankRole,
    case check_enter_rank(Score, ScoreRankCon) of
        false-> 
            set_rank(T, ScoreRankCon, InitRank, MaxRankLen, List);
        {RankMin, _RankMax}->
            case InitRank >= RankMin of
                true-> 
                    Rank = ?IF(InitRank > MaxRankLen, 0, InitRank),
                    set_rank(T, ScoreRankCon, InitRank+1, MaxRankLen, [RankRole#rank_role_kf{rank=Rank}|List]);
                false-> 
                    set_rank(T, ScoreRankCon, RankMin+1, MaxRankLen, [RankRole#rank_role_kf{rank=RankMin}|List])
            end
    end.

check_enter_rank(_Score, []) -> false;
check_enter_rank(Score, [{RankMin, RankMax, ScoreNeed}|ScoreRankCon]) ->
    case Score >= ScoreNeed of 
        true ->
            {RankMin, RankMax};
        _ ->
            check_enter_rank(Score, ScoreRankCon)
    end.

%% 阈值
clean_redundant_rank_data(RankList) ->
    F = fun
            ({{RankType, SubType}, []}) ->
                Limit = lib_flower_act:get_rank_limit(RankType, SubType),
                {{RankType, SubType}, Limit};
            ({{RankType, SubType}, TypeRankList}) ->
                RankMax = lib_flower_act:get_max_len(RankType, SubType),
                Limit = lib_flower_act:get_rank_limit(RankType, SubType),
                case length(TypeRankList) >= RankMax of
                    true ->
                        RankLast = lists:nth(RankMax, TypeRankList),
                        %RankLast = lists:last(TypeRankList),
                        Value = RankLast#rank_role_kf.value,
                        %db_rank_kf_delete_by_value(RankType, SubType, Value),
                        {{RankType, SubType}, max(Value, Limit)};
                    false ->
                        {{RankType, SubType}, Limit}
                end
        end,
    lists:map(F, RankList).

%% @param [{RankType, RankRole}]
refresh_common_rank_by_list(State, List) ->
    % ?PRINT("List:~p ~n", [List]),
    F = fun({{RankType, SubType}, CommonRank}, TmpState) ->
        {ok, NewTmpState} = refresh_common_rank(TmpState, RankType, SubType, CommonRank),
        NewTmpState
        end,
    NewState = lists:foldl(F, State, List),
    {ok, NewState}.

%% 刷新榜单
refresh_common_rank(State, RankType, SubType, RankRole, _Figure) ->
    {ok, NewState} = refresh_common_rank(State, RankType, SubType, RankRole),
    %?PRINT("refresh_common_rank : ~p~n", [NewState#kf_rank_state.rank_list]), 
    %?PRINT("refresh_common_rank : ~p~n", [NewState#kf_rank_state.rank_limit]),
    %% 更新前三名的figure列表
    %LastState = refresh_top_n_figure(NewState, RankType, SubType, RankRole#rank_role_kf.role_id, Figure),
    {ok, NewState}.

%% 刷新榜单
refresh_common_rank(State, RankType, SubType, RankRole) ->
    ?PRINT("~p, ~p~n", [RankType, RankRole]),
    #kf_rank_state{rank_list = RankList, rank_limit = RankLimit} = State,
    #rank_role_kf{server_id = ServerId} = RankRole,
    NewRankRole = RankRole#rank_role_kf{zone_id = lib_clusters_center_api:get_zone(ServerId)},
    {_, TypeRankList} = ulists:keyfind({RankType, SubType}, 1, RankList, {{RankType, SubType}, []}),
    %% 更新个人值maps 增加魅力值

    {NewTypeRankList, NewRankLimit} = do_refresh_rank_help(TypeRankList, RankType, SubType, NewRankRole, RankLimit),
    db_rank_role_kf_save(NewRankRole),
    NewRankList = lists:keystore({RankType, SubType}, 1, RankList, {{RankType, SubType}, NewTypeRankList}),
    NewState = State#kf_rank_state{rank_list = NewRankList, rank_limit = NewRankLimit},
    {ok, NewState}.

%% 先判断list中是否存在key和value都相等的玩家，存在则跟新数据，不存在则将其进行队列排序：将其与队
%% 尾比较，若小于队尾并且队列长度大于最长长度，则丢弃，否则将其加入队列，排序并保证队列长度为最大
%% 队列长度，发送数据的时候，先截取显示长度，再判断是否满足limit，满足条件的才加入发送队列。
%% 时刻保证，排序之后队列和数据库保存的数据为整个服的前N，然后在这之中选择发送
do_refresh_rank_help(TypeRankList, RankType, SubType, RankRole, RankLimit) ->
    %% 阈值
    Limit = lib_flower_act:get_rank_limit(RankType, SubType),
    %% 最大长度
    MaxRankLen = lib_flower_act:get_max_len(RankType, SubType),
    Temp = maps:get({RankType, SubType}, RankLimit, Limit),
    %% 最终阈值
    LastValue = max(Temp, Limit),
    case TypeRankList == [] of
        true ->
            if
                RankRole#rank_role_kf.value >= LastValue ->
                    NewTypeRankList = [RankRole],
                    LastList = set_rank_list(RankType, SubType, MaxRankLen, NewTypeRankList),
                    {LastList, RankLimit};
                true ->
                    NewTypeRankList = [],
                    {NewTypeRankList, RankLimit}
            end;
        false ->
            #rank_role_kf{role_key = RoleKey, value = Value} = RankRole,
            case lists:keytake(RoleKey, #rank_role_kf.role_key, TypeRankList) of 
                {value, _, LeftList} ->
                    _IsExistKey = true;
                _ ->
                    _IsExistKey = false, LeftList = TypeRankList
            end,
            % 是否需要排序
            if
                Value < Limit -> %% 小于配置阈值不处理
                    {TypeRankList, RankLimit};
                Value < LastValue -> %% 大于配置阈值，小于当前阈值
                    %% 放到列表最后，作为替补
                    {LeftList ++ [RankRole], RankLimit};
                true ->
                    NewTypeRankList2 = [RankRole|LeftList],
                    {NewTypeRankList, NewRankLimit} = refresh_rank_core(RankType, SubType, NewTypeRankList2, RankLimit),
                    %% top 1 传闻
                    send_top_1_tv(RankType, SubType, TypeRankList, NewTypeRankList),
                    {NewTypeRankList, NewRankLimit}
            end
    end.

refresh_rank_core(RankType, SubType, TypeRankList, RankLimit) ->
    Limit = lib_flower_act:get_rank_limit(RankType, SubType),
    MaxRankLen = lib_flower_act:get_max_len(RankType, SubType),
    % 排序
    NewTypeRankList1 = sort_rank_list(TypeRankList),
    NewTypeRankList = set_rank_list(RankType, SubType, MaxRankLen, NewTypeRankList1),
    case length(NewTypeRankList) >= MaxRankLen of
        true -> 
            LastRankRole = lists:nth(MaxRankLen, NewTypeRankList),
            #rank_role_kf{value = TempLastValue} = LastRankRole,
            NewLastValue = max(TempLastValue, Limit);
        false -> 
            NewLastValue = Limit
    end,
    NewRankLimit = maps:put({RankType, SubType}, NewLastValue, RankLimit),
    {NewTypeRankList, NewRankLimit}.

refresh_top_n_figure(State, RankType, SubType, RoleId, Figure) ->
    #kf_rank_state{rank_list = RankList, show_figure = ShowFigure} = State,
    {_, TypeRankList} = ulists:keyfind({RankType, SubType}, 1, RankList, {{RankType, SubType}, []}),
    case lists:keyfind({RankType, SubType, RoleId}, #rank_role_kf.role_key, TypeRankList) of 
        #rank_role_kf{rank = Rank} when Rank =< ?TOP_N ->
            OldFigureList = maps:get({RankType, SubType}, ShowFigure, []),
            NOldFigureList = lists:keystore(RoleId, 1, OldFigureList, {RoleId, Figure}),
            LastFigureList = refresh_top_n_figure_helper(RankType, SubType, TypeRankList, NOldFigureList, []),
            NewShowFigure = maps:put({RankType, SubType}, LastFigureList, ShowFigure),
            NewState = State#kf_rank_state{show_figure = NewShowFigure},
            sync_top_n_to_local(NewState, RankType, SubType),
            NewState;
        _ ->
            State
    end.

refresh_top_n_figure_helper(_RankType, _SubType, [], _OldFigureList, NewFigureList) ->
    NewFigureList;
refresh_top_n_figure_helper(_RankType, _SubType, [#rank_role_kf{rank=Rank}|_TypeRankList], _OldFigureList, NewFigureList) when Rank > ?TOP_N ->
    NewFigureList;
refresh_top_n_figure_helper(RankType, SubType, [#rank_role_kf{role_id = RoleId, server_id = SerId}|TypeRankList], OldFigureList, NewFigureList) ->
    case lists:keyfind(RoleId, 1, OldFigureList) of 
        {_, Figure} ->
            refresh_top_n_figure_helper(RankType, SubType, TypeRankList, OldFigureList, [{RoleId, Figure}|NewFigureList]);
        _ -> %% 除非出bug, 不然不应该会走这个流程
            mod_clusters_center:apply_cast(SerId, lib_flower_act, send_top_n_figure_to_act, [RoleId, RankType, SubType])
    end.

send_top_n_figure_to_act(State, RankType, SubType, RoleId, Figure) ->
    #kf_rank_state{show_figure = ShowFigure} = State,
    OldFigureList = maps:get({RankType, SubType}, ShowFigure, []),
    LastFigureList = lists:keystore(RoleId, 1, OldFigureList, {RoleId, Figure}),
    NewShowFigure = maps:put({RankType, SubType}, LastFigureList, ShowFigure),
    NewState = State#kf_rank_state{show_figure = NewShowFigure},
    sync_top_n_to_local(NewState, RankType, SubType),
    {ok, State#kf_rank_state{show_figure = NewShowFigure}}.

sync_top_n_to_local(State, RankType, SubType) ->
    #kf_rank_state{show_figure = ShowFigure} = State,
    FigureList = maps:get({RankType, SubType}, ShowFigure, []),
    TopNIds = [RoleId ||{RoleId, _} <- FigureList],
    mod_clusters_center:apply_to_all_node(mod_kf_flower_act_local, sync_top_n_figure, [RankType, SubType, TopNIds], 100),
    ok.

wlv_change(State, ServerId, SubType, Wlv) ->
    #kf_rank_state{rank_list = RankList} = State,
    F = fun({{RankType, SubType1}, TypeRankList}, RankListTmp) ->
        case SubType == SubType1 of 
            true ->
                F1 = fun(RankRole, List) ->
                    case RankRole#rank_role_kf.server_id == ServerId of 
                        true ->
                            [RankRole#rank_role_kf{wlv = Wlv}|List];
                        _ ->
                            [RankRole|List]
                    end
                end,
                NewTypeRankList = lists:foldl(F1, [], TypeRankList),
                [{{RankType, SubType1}, lists:reverse(NewTypeRankList)}|RankListTmp];
            _ ->
                [{{RankType, SubType1}, TypeRankList}|RankListTmp]
        end
    end,
    NewRankList = lists:foldl(F, [], RankList),
    {ok, State#kf_rank_state{rank_list = NewRankList}}.

zone_change(State, ServerId, _OldZone, NewZone) ->
    #kf_rank_state{rank_list = RankList} = State,
    F = fun({{RankType, SubType}, TypeRankList}, RankListTmp) ->
        F1 = fun(RankRole, List) ->
            case RankRole#rank_role_kf.server_id == ServerId of 
                true ->
                    [RankRole#rank_role_kf{zone_id = NewZone}|List];
                _ ->
                    [RankRole|List]
            end
        end,
        NewTypeRankList = lists:foldl(F1, [], TypeRankList),
        [{{RankType, SubType}, lists:reverse(NewTypeRankList)}|RankListTmp]
    end,
    NewRankList = lists:foldl(F, [], RankList),
    {ok, State#kf_rank_state{rank_list = NewRankList}}.


%% 刷新战力
refresh_power(State, RefreshList) ->
    #kf_rank_state{rank_list = RankList} = State,
    F = fun({RankType, SubType, ServerId, RolePowerList}, RankListTmp) ->
        case lists:keyfind({RankType, SubType}, 1, RankListTmp) of 
            {_, TypeRankList} ->
                NewTypeRankList = refresh_power_do(TypeRankList, RolePowerList, ServerId, []),
                lists:keyreplace({RankType, SubType}, 1, RankListTmp, {{RankType, SubType}, NewTypeRankList});
            _ ->
                RankListTmp
        end
    end,
    NewRankList = lists:foldl(F, RankList, RefreshList),
    {ok, State#kf_rank_state{rank_list = NewRankList}}.

refresh_power_do([], _RefreshList, _ServerId, Return) ->
    lists:reverse(Return);
refresh_power_do([RankRole|TypeRankList], RefreshList, ServerId, Return) ->
    #rank_role_kf{role_id = RoleId, server_id = RoleServerId} = RankRole,
    case RoleServerId == ServerId of 
        true ->
            case lists:keytake(RoleId, 1, RefreshList) of 
                {value, {RoleId, NewPower}, LeftList} ->
                    NewRankRole = RankRole#rank_role_kf{power = NewPower},
                    refresh_power_do(TypeRankList, LeftList, ServerId, [NewRankRole|Return]);
                _ ->
                    refresh_power_do(TypeRankList, RefreshList, ServerId, [RankRole|Return])
            end;
        _ ->
            refresh_power_do(TypeRankList, RefreshList, ServerId, [RankRole|Return])
    end.

send_top_1_tv(RankType, _SubType, TypeRankList, NewTypeRankList) ->
    case TypeRankList of
        [#rank_role_kf{role_id = OldRoleId}|_] -> ok;
        _ -> OldRoleId = 0
    end,
    case NewTypeRankList of
        [#rank_role_kf{role_id = NewRoleId, server_num = NewSNum, name = NewName, rank = NewRank}|_] -> ok;
        _ -> NewRoleId = 0, NewSNum = 0, NewName = "", NewRank = 0
    end,
    case OldRoleId =/= NewRoleId andalso NewRoleId > 0 andalso NewRank == 1 of 
        true ->
            Title = ?IF(RankType == ?RANK_TYPE_FLOWER_BOY_KF, utext:get(2240001), utext:get(2240002)),
            mod_clusters_center:apply_to_all_node(lib_chat, send_TV, 
                [{all}, ?MOD_FLOWER_RANK_ACT, 1, [NewSNum, NewName, util:make_sure_binary(Title)]], 20);
        _ ->
            ok
    end.

send_settlement_tv(RankType, _SubType, TypeRankList) ->
    case TypeRankList of
        [RankRole, SecRole, ThrRole|_] -> 
            #rank_role_kf{role_id = _RoleId, server_num = SNum, name = Name, value = Value, rank = Rank} = RankRole,
            #rank_role_kf{server_num = SecSNum, name = SecName, rank = SecRank} = SecRole,
            #rank_role_kf{server_num = ThrSNum, name = ThrName, rank = ThrRank} = ThrRole,
            Title = ?IF(RankType == ?RANK_TYPE_FLOWER_BOY_KF, utext:get(2240001), utext:get(2240002)),
            TitleBin = util:make_sure_binary(Title),
            case Rank  == 1 of 
                true ->
                    if
                        SecRank == 2 andalso ThrRank == 3 ->
                            mod_clusters_center:apply_to_all_node(lib_chat, send_TV, 
                                [{all}, ?MOD_FLOWER_RANK_ACT, 4, [SNum, Name, Value, TitleBin, SecSNum, SecName, ThrSNum, ThrName]], 20);
                        SecRank == 2 orelse SecRank == 3 ->
                            mod_clusters_center:apply_to_all_node(lib_chat, send_TV, 
                                [{all}, ?MOD_FLOWER_RANK_ACT, 3, [SNum, Name, Value, TitleBin, SecSNum, SecName]], 20);
                        true ->
                            mod_clusters_center:apply_to_all_node(lib_chat, send_TV, 
                                [{all}, ?MOD_FLOWER_RANK_ACT, 2, [SNum, Name, Value, TitleBin]], 20)
                    end;
                _ ->
                    ok
            end;
        [RankRole, SecRole] ->  
            #rank_role_kf{role_id = _RoleId, server_num = SNum, name = Name, value = Value, rank = Rank} = RankRole,
            #rank_role_kf{server_num = SecSNum, name = SecName, rank = SecRank} = SecRole,
            Title = ?IF(RankType == ?RANK_TYPE_FLOWER_BOY_KF, utext:get(2240001), utext:get(2240002)),
            TitleBin = util:make_sure_binary(Title),
            case Rank  == 1 of 
                true ->
                    if
                        SecRank == 2 orelse SecRank == 3 ->
                            mod_clusters_center:apply_to_all_node(lib_chat, send_TV, 
                                [{all}, ?MOD_FLOWER_RANK_ACT, 3, [SNum, Name, Value, TitleBin, SecSNum, SecName]], 20);
                        true ->
                            mod_clusters_center:apply_to_all_node(lib_chat, send_TV, 
                                [{all}, ?MOD_FLOWER_RANK_ACT, 2, [SNum, Name, Value, TitleBin]], 20)
                    end;
                _ ->
                    ok
            end;
        [RankRole] ->
            #rank_role_kf{role_id = _RoleId, server_num = SNum, name = Name, value = Value, rank = Rank} = RankRole,
            case Rank == 1 of 
                true ->
                    Title = ?IF(RankType == ?RANK_TYPE_FLOWER_BOY_KF, utext:get(2240001), utext:get(2240002)),
                    TitleBin = util:make_sure_binary(Title),
                    mod_clusters_center:apply_to_all_node(lib_chat, send_TV, 
                        [{all}, ?MOD_FLOWER_RANK_ACT, 2, [SNum, Name, Value, TitleBin]], 20);
                _ ->
                    ok
            end;
        _ ->
            ok
    end.

%% 更新figure
update_role_figure(State, RankType, SubType, RoleId, KeyList) ->
    #kf_rank_state{show_figure = ShowFigure} = State,
    FigureList = maps:get({RankType, SubType}, ShowFigure, []),
    case lists:keyfind(RoleId, 1, FigureList) of 
        {RoleId, Figure} ->
            NewFigure = update_role_figure_do(KeyList, Figure),
            NewFigureList = lists:keyreplace(RoleId, 1, FigureList, {RoleId, NewFigure}),
            NewShowFigure = maps:put({RankType, SubType}, NewFigureList, ShowFigure),
            {ok, State#kf_rank_state{show_figure = NewShowFigure}};
        _ ->
            {ok, State}
    end.

update_role_figure_do([], Figure) -> Figure;
update_role_figure_do([T | L], Figure) ->
    case T of
        {guild_id, GuildId} -> 
            NewFigure = Figure#figure{guild_id = GuildId};
        {guild_name, GuildName} -> 
            NewFigure = Figure#figure{guild_name = GuildName};
        {position, Position} -> 
            NewFigure = Figure#figure{position = Position};
        {position_name, PositionName} ->
            NewFigure = Figure#figure{position_name = PositionName};
        {lb_pet_figure, FigureId} ->
            NewFigure = Figure#figure{lb_pet_figure = FigureId};
        {lb_mount_figure, FigureId} ->
            NewFigure = Figure#figure{lb_mount_figure = FigureId};
        {mount_figure, MountFigure} ->
            NewFigure = Figure#figure{mount_figure = MountFigure};
        {clear_marriage, _} ->
            NewFigure = Figure#figure{marriage_type = 0, lover_role_id = 0, lover_name = ""};
        {dress_list, DressList} ->
            NewFigure = Figure#figure{dress_list = DressList};
        {demons_id, DemonsId} ->
            NewFigure = Figure#figure{demons_id = DemonsId};
        _ -> NewFigure = Figure
    end,
    update_role_figure_do(L, NewFigure).


%% 魅力榜信息发送
send_rank_list(State, Node, RankType, SubType, RoleId, SelfServerId, SelValue) ->
    #kf_rank_state{rank_list = RankList, show_figure = _ShowFigure} = State,
    %% 配置的最大长度和上榜阈值
    Limit = lib_flower_act:get_rank_limit(RankType, SubType),
    MaxRankLen = lib_flower_act:get_max_len(RankType, SubType),
    %ShowLen = lib_flower_act:get_max_show_len(RankType, SubType),
    {_, TypeRankList} = ulists:keyfind({RankType, SubType}, 1, RankList, {{RankType, SubType}, []}),
    List = get_show_rank_list(TypeRankList, 1, MaxRankLen, []),
    Sum = length(List),
    SelZoneId = lib_clusters_center_api:get_zone(SelfServerId),
    if
        Sum == 0 ->
            ?PRINT("~p~n", [[RankType, SubType, 0, SelValue, Sum, MaxRankLen, Limit, []]]),
            {ok, Bin} = pt_224:write(22403, [RankType, SubType, 0, SelValue, SelZoneId, Sum, MaxRankLen, Limit, [], []]),
            lib_clusters_center:send_to_uid(Node, RoleId, Bin);
        true ->
            case lists:keyfind({RankType, SubType, RoleId}, #rank_role_kf.role_key, TypeRankList) of
                #rank_role_kf{rank = RoleRank} -> skip;
                _ -> RoleRank = 0
            end,
            ?PRINT("~p~n", [[RankType, SubType, RoleRank, SelValue, Sum, MaxRankLen, Limit, List]]),
            %FigureList = maps:get({RankType, SubType}, ShowFigure, []),
            %?PRINT("figures:~p~n", [FigureList]),
            {ok, Bin} = pt_224:write(22403, [RankType, SubType, RoleRank, SelValue, SelZoneId, Sum, MaxRankLen, Limit, List, []]),
            lib_clusters_center:send_to_uid(Node, RoleId, Bin)
    end.

get_show_rank_list([], _AccNum, _ShowLen, Return) -> Return;
get_show_rank_list(_TypeRankList, AccNum, ShowLen, Return) when AccNum > ShowLen ->
    Return;
get_show_rank_list([RankRole|TypeRankList], AccNum, ShowLen, Return) ->
    #rank_role_kf{
        role_id    = RoleId,
        value      = Value,
        rank       = Rank,
        server_id  = ServerId,
        zone_id    = ZoneId,
        server_num = ServerNum,
        name       = Name
    } = RankRole,
    case Rank > 0 of 
        true ->
            case ZoneId == 0 of 
                true ->
                    NZoneId = lib_clusters_center_api:get_zone(ServerId);
                _ -> 
                    NZoneId = ZoneId
            end,
            NewReturn = [{RoleId, ServerId, NZoneId, ServerNum, Name, Value, Rank}|Return],
            get_show_rank_list(TypeRankList, AccNum+1, ShowLen, NewReturn);
        _ ->
            get_show_rank_list(TypeRankList, AccNum, ShowLen, Return)
    end.

%% 同步到对应玩家上
% receive_flower_gift(State, SenderNode, RankType, SubType, SenderId, SName, SSerId, ReceiverId, GiftCfg, _IsAnonymous) when RankType == ?RANK_TYPE_FLOWER_BOY_KF orelse RankType == ?RANK_TYPE_FLOWER_GIRL_KF ->
%     % ?PRINT("~p~n", [GiftCfg]),
%     #kf_rank_state{role_maps = RoleMaps} = State,
%     #flower_gift_cfg{
%         goods_id    = GoodsId,
%         effect_type = EffectType,
%         effect      = Effect,
%         is_tv       = IsTv} = GiftCfg,
%     RoleList = maps:get({RankType, SubType}, RoleMaps, []),
%     %?PRINT("~p~n", [GiftCfg]),
%     %% 跨服的数据里有这个玩家id才操作
%     case lists:keyfind({RankType, SubType, ReceiverId}, #rank_role_kf.role_key, RoleList) of
%         #rank_role_kf{server_id = ServerId, name = ReceiverName} when ServerId /= 0 ->
%             %% 发送全部节点传闻
%             case IsTv > 0 of
%                 true ->
%                     #ets_goods_type{goods_name = GoodsName} = data_goods_type:get(GoodsId),
%                     BinData = lib_chat:make_tv(?MOD_FLOWER, 7, [ReceiverName, GoodsName]),
%                     mod_clusters_center:apply_to_all_node(lib_server_send, send_to_all, [BinData]);
%                 _ -> skip
%             end,
%             %% 显示特效
%             ReceiverNode = lib_clusters_center:get_node(ServerId),
%             case EffectType of
%                 2 -> %% 双方特效
%                     {ok, FXBinData} = pt_110:write(11063, [Effect]),
%                     lib_server_send:send_to_uid(SenderNode, SenderId, FXBinData),
%                     lib_server_send:send_to_uid(ReceiverNode, ReceiverId, FXBinData);
%                 3 -> %% 全服特效(同服只发一次)
%                     {ok, FXBinData} = pt_110:write(11063, [Effect]),
%                     case SenderNode =:= ReceiverNode of
%                         true ->
%                             mod_clusters_center:apply_cast(SenderNode, lib_server_send, send_to_all, [FXBinData]);
%                         false ->
%                             mod_clusters_center:apply_cast(SenderNode, lib_server_send, send_to_all, [FXBinData]),
%                             mod_clusters_center:apply_cast(ReceiverNode, lib_server_send, send_to_all, [FXBinData])
%                     end;
%                 _ -> skip
%             end,
%             % ?PRINT("~p~n", [ServerId]),
%             mod_clusters_center:apply_cast(ServerId, lib_flower, receive_flower_gift_kf, [SenderId, SName, SSerId, ReceiverId, ReceiverName, ServerId, GiftCfg, 1, 1]);
%         _ -> skip
%     end;
% receive_flower_gift(_, _, _, _, _, _, _, _, _, _) -> skip.

%% @Description 活动开启标志
%% @Params  State:#kf_rank_state{}, SubType:活动子类
%% @Return  {ok, NewState}
act_open(State, SubType) ->
    #kf_rank_state{act_status = StatusMaps} = State,
    Status = maps:get(SubType, StatusMaps, ?CLOSE),
    NewStatus = ?IF(Status == ?CLOSE, ?OPEN, Status),
    NewStatusMaps = maps:put(SubType, NewStatus, StatusMaps),
    NewState = State#kf_rank_state{act_status = NewStatusMaps},
    ?PRINT("act_open ################# ~p~n", [act_open]),
    {ok, NewState}.

%% @Description 活动结束发奖励 发完清数据
%% @Params  State:#kf_rank_state{}, SubType:活动子类
%% @Return  {ok, NewState}
send_reward(State, SubType) ->
    ?PRINT("send_reward:~p~n", [SubType]),
    #kf_rank_state{act_status = StatusMaps, rank_list = RankList, rank_limit = RankLimit, show_figure = _ShowFigure} = State,
    Status = maps:get(SubType, StatusMaps, ?CLOSE),
    case Status == ?OPEN of
        true ->
            F = fun(RankType) ->
                {_, TypeRankList} = ulists:keyfind({RankType, SubType}, 1, RankList, {{RankType, SubType}, []}),
                send_settlement_tv(RankType, SubType, TypeRankList),
                spawn(fun() ->
                    util:multiserver_delay(10, lib_kf_flower_act_mod, do_send_reward, [TypeRankList, RankType, SubType, 1]) end)
            end,
            lists:foreach(F, ?RANK_TYPE_FLOWER_KF);
        _ -> skip
    end,
    NewStatusMaps = maps:put(SubType, ?CLOSE, StatusMaps),
    %% 清空跨服数据 以及 相应的本服数据
    mod_clusters_center:apply_to_all_node(mod_kf_flower_act_local, clear_data, [SubType]),
    NewRankList1 = lists:keydelete({?RANK_TYPE_FLOWER_BOY_KF, SubType}, 1, RankList),
    NewRankList = lists:keydelete({?RANK_TYPE_FLOWER_GIRL_KF, SubType}, 1, NewRankList1),
    NewLimit1 = maps:remove({?RANK_TYPE_FLOWER_BOY_KF, SubType}, RankLimit),
    NewLimit = maps:remove({?RANK_TYPE_FLOWER_GIRL_KF, SubType}, NewLimit1),
    % NewShowFigure1 = maps:remove({?RANK_TYPE_FLOWER_BOY_KF, SubType}, ShowFigure),
    % NewShowFigure = maps:remove({?RANK_TYPE_FLOWER_GIRL_KF, SubType}, NewShowFigure1),
    NewState = State#kf_rank_state{act_status = NewStatusMaps, rank_list = NewRankList, rank_limit = NewLimit},
    %% db
    db:execute(io_lib:format(?sql_kf_rank_role_clear, [?RANK_TYPE_FLOWER_BOY_KF, ?RANK_TYPE_FLOWER_GIRL_KF, SubType])),
    ?PRINT("send_reward ############## end ~n", []),
    {ok, NewState}.

do_send_reward([], _RankType, _SubType, _Count) -> skip;
do_send_reward([RankRole | RankList], RankType, SubType, Count) when is_record(RankRole, rank_role_kf) ->
    #rank_role_kf{role_id = RoleId, value = Value, rank = Rank, server_id = ServerId, name = Name, platform = PlatForm, server_num = ServerNum} = RankRole,
    case lib_flower_act:get_flower_rank_reward(RankType, SubType, RankRole) of
        [] -> 
            Sex = ?IF(RankType == ?RANK_TYPE_FLOWER_BOY_KF, ?MALE, ?FEMALE),
            lib_log_api:log_flower_rank_kf(RoleId, Name, ServerId, PlatForm, ServerNum, Sex, Rank, Value, []),
            do_send_reward(RankList, RankType, SubType, Count);
        Reward ->
            Sex = ?IF(RankType == ?RANK_TYPE_FLOWER_BOY_KF, ?MALE, ?FEMALE),
            Title = ?LAN_MSG(302),
            case Sex == ?MALE of 
                true ->
                    Content = uio:format(?LAN_MSG(303), [Rank]);
                _ ->
                    Content = uio:format(?LAN_MSG(305), [Rank])
            end,
            F = fun({Type, GoodsTypeId, Num}, {List, DsgtId}) ->
                case Type == ?TYPE_GOODS orelse Type == ?TYPE_BIND_GOODS of 
                    true ->
                        case data_goods_type:get(GoodsTypeId) of 
                            #ets_goods_type{type = ?GOODS_TYPE_PROPS, subtype = ?GOODS_PROPS_STYPE_DESG} ->
                                case data_designation:get_designation_id([{?TYPE_GOODS, GoodsTypeId, 1}]) of 
                                    [DesignationId] ->
                                        case data_designation:get_by_id(DesignationId) of
                                            %% 20221009版本修改，与运营沟通好，现改成如果是有时间限制的，就统一走原有的去逻辑，自动去激活叠加，如果没有时间限制的，就直接跟着活动奖励发给玩家
                                            #base_designation{expire_time = ExpireTime}->
                                                ?IF(ExpireTime > 0, {List, DesignationId}, {[{Type, GoodsTypeId, Num}|List], DsgtId});
                                            _ ->
                                                ?ERR("error_designation:~p//GoodsId:~p", [DesignationId, GoodsTypeId]),
                                                {[{Type, GoodsTypeId, Num}|List], DsgtId}
                                        end;
                                    _ ->
                                      {[{Type, GoodsTypeId, Num}|List], DsgtId}  
                                end;
                            _ ->
                                {[{Type, GoodsTypeId, Num}|List], DsgtId}
                        end;
                    _ ->
                        {[{Type, GoodsTypeId, Num}|List], DsgtId}
                end
            end,
            {NewRewardList, DsgtId} = lists:foldl(F, {[], 0}, Reward),
            ?PRINT("do_send_reward##:~p~n", [{DsgtId, NewRewardList}]),
            %% 20221009版本修改，与运营沟通好，现改成如果是有时间限制的，就统一走原有的去逻辑，自动去激活叠加，如果没有时间限制的，就直接跟着活动奖励发给玩家
            DsgtId > 0 andalso mod_clusters_center:apply_cast(ServerId, lib_designation_api, active_dsgt_common, [RoleId, DsgtId]),
            mod_clusters_center:apply_cast(ServerId, lib_mail_api, send_sys_mail, [[RoleId], Title, Content, NewRewardList]),
            %% 日志
            lib_log_api:log_flower_rank_kf(RoleId, Name, ServerId, PlatForm, ServerNum, Sex, Rank, Value, Reward),
            case Count rem 20 of
                0 -> timer:sleep(100);
                _ -> skip
            end,
            do_send_reward(RankList, RankType, SubType, Count + 1)
    end;
do_send_reward(_, _, _, _) -> skip.

change_rank_by_type(State, SubType, RoleId, OldType, NewType, Sex) ->
    #kf_rank_state{rank_list = RankList, rank_limit = RankLimit} = State,
    {_, DelRankL} = ulists:keyfind({OldType, SubType}, 1, RankList, {{OldType, SubType}, []}),
    {_, AddRankL} = ulists:keyfind({NewType, SubType}, 1, RankList, {{NewType, SubType}, []}),
    case lists:keyfind({OldType, SubType, RoleId}, #rank_role_kf.role_key, DelRankL) of
        false -> NewDelRankL = DelRankL, NewAddRankL = AddRankL, LastRankLimit = RankLimit;
        DelRole ->
            TmpDelRankL = lists:keydelete({OldType, SubType, RoleId}, #rank_role_kf.role_key, DelRankL),
            db_rank_kf_delete_by_id(OldType, SubType, RoleId),
            TmpAddRankL = lists:keystore({NewType, SubType, RoleId}, #rank_role_kf.role_key, AddRankL,
                DelRole#rank_role_kf{role_key = {NewType, SubType, RoleId}, rank_type = NewType, sex = Sex}),
            db_rank_role_kf_save(DelRole#rank_role_kf{rank_type = NewType, sex = Sex}),
            {NewDelRankL, NewRankLimit} = refresh_rank_core(OldType, SubType, TmpDelRankL, RankLimit),
            {NewAddRankL, LastRankLimit} = refresh_rank_core(NewType, SubType, TmpAddRankL, NewRankLimit)
    end,
    NewRankList1 = lists:keystore({OldType, SubType}, 1, RankList, {{OldType, SubType}, NewDelRankL}),
    NewRankList2 = lists:keystore({NewType, SubType}, 1, NewRankList1, {{NewType, SubType}, NewAddRankL}),
    {ok, State#kf_rank_state{rank_list = NewRankList2, rank_limit = LastRankLimit}}.

%% 玩家修改昵称同步修改榜单的值
change_role_name_by_type(State, SubType, RoleId, ChangeRankType, PlayerName) ->
    #kf_rank_state{rank_list = RankList }= State,
    {_, AllRoleList} = ulists:keyfind({ChangeRankType, SubType}, 1, RankList, {{ChangeRankType, SubType}, []}),
    case lists:keyfind({ChangeRankType, SubType, RoleId}, #rank_role_kf.role_key, AllRoleList) of
        #rank_role_kf{} = RankRole ->
            NewRankRole = RankRole#rank_role_kf{ name = PlayerName },
            db_rank_role_kf_save(NewRankRole),
            NewAllRoleList = lists:keystore({ChangeRankType, SubType, RoleId}, #rank_role_kf.role_key, AllRoleList, NewRankRole);
        _ ->
            NewAllRoleList = AllRoleList
    end,
    NewRankList =  lists:keystore({ChangeRankType, SubType}, 1, RankList, {{ChangeRankType, SubType}, NewAllRoleList}),
    {ok, State#kf_rank_state{rank_list = NewRankList}}.

%%------------db------------------------%%
db_rank_role_kf_select() ->
    Sql = io_lib:format(?sql_rank_role_kf_select, []),
    db:get_all(Sql).

db_rank_role_kf_save(RankRole) ->
    #rank_role_kf{
        rank_type  = RankType,
        sub_type   = SubType,
        role_id    = RoleId,
        value      = Value,
        server_id  = ServerId,
        platform   = Platform,
        server_num = ServerNum,
        name       = Name,
        sex        = Sex,
        career     = Career,
        turn       = Turn,
        wlv        = WLv,
        time       = Time
    } = RankRole,
    Sql = io_lib:format(?sql_rank_role_kf_save,
        [RankType, SubType, RoleId, Value, ServerId, Platform, ServerNum, Name, Sex, Career, Turn, WLv, Time]),
    db:execute(Sql).

db_rank_kf_delete_by_id(RankType, SubType, RoleId) ->
    Sql = io_lib:format(?sql_rank_role_kf_delete_by_role_id, [RankType, SubType, RoleId]),
    db:execute(Sql).

db_rank_kf_delete_by_value(RankType, SubType, Value) ->
    Sql = io_lib:format(?sql_rank_role_kf_delete_by_value, [RankType, SubType, Value]),
    db:execute(Sql).


