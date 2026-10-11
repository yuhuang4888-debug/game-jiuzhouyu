%%%------------------------------------
%%% @Module  : lib_flower_act_mod
%%% @Author  :  xiaoxiang
%%% @Created :  2016-11-17
%%% @Description: 跨服魅力榜活动
%%%------------------------------------
-module(lib_kf_flower_act_mod_local).


-compile(export_all).

-include("errcode.hrl").
-include("language.hrl").
-include("flower_rank_act.hrl").
-include("common.hrl").
-include("record.hrl").
-include("relationship.hrl").
-include("figure.hrl").
-include("role.hrl").

make_record([RankType, SubType, RoleId, Value, ServerId, Platform, ServerNum, Name, Sex, Career, Turn, Time]) ->
    #rank_role_kf{
        role_key   = {RankType, SubType, RoleId},  % {RankType, RoleId}
        rank_type  = RankType,                     % 榜单类型
        sub_type   = SubType,                      % 活动子类型
        role_id    = RoleId,                       % 角色id
        value      = Value,                        % 排序值
        server_id  = ServerId,                     % 服务器id
        platform   = Platform,                     % 平台名字
        server_num = ServerNum,                    % 所在的服标示
        name       = Name,                         % 名字
        sex        = Sex,                          % 性别
        career     = Career,                       % 职业
        turn       = Turn,                         % 转生数
        time       = Time                          % 时间戳
    }.
make_record(RankType, SubType, {RoleId, WLv, Figure, Power, CharmPlus}) ->
    #figure{name = Name, sex = Sex, career = Career, turn = Turn} = Figure,
    ServerId = config:get_server_id(),
    ServerNum = config:get_server_num(),
    Platform = config:get_platform(),
    Value = CharmPlus,
    #rank_role_kf{
        role_key   = {RankType, SubType, RoleId},  % 键
        rank_type  = RankType,                     % 榜单类型
        sub_type   = SubType,                      % 活动子类型
        role_id    = RoleId,                       % 玩家id
        value      = Value,                        % 魅力值
        server_id  = ServerId,                     % 服务器id
        platform   = Platform,                     % 平台名字
        server_num = ServerNum,                    % 所在的服标示
        name       = Name,                         % 名字
        sex        = Sex,                          % 性别
        career     = Career,                       % 职业
        turn       = Turn,                         % 转生数
        wlv        = WLv,                          % 世界等级
        power      = Power,
        time       = utime:unixtime()              % 时间
    }.

init() ->
    %% 个人数据
    List = db_rank_role_kf_select(),
    % ?PRINT("~p~n", [List]),
    RoleList = [make_record(T) || T <- List],
    F = fun(#rank_role_kf{rank_type = RankType, sub_type = SubType} = RankRole, Maps) ->
        case maps:get({RankType, SubType}, Maps, false) of
            false -> NewList = [RankRole];
            TmpL -> NewList = [RankRole | TmpL]
        end,
        maps:put({RankType, SubType}, NewList, Maps)
        end,
    RoleMaps = lists:foldl(F, maps:new(), RoleList),
    %% 先屏蔽刷战力，需要再开放
    %util:send_after([], 100*1000, self(), {refresh_power}),
    #rank_state{role_maps = RoleMaps}.

%% 刷新榜单
refresh_common_rank(State, RankType, SubType, {RoleId, ValuePlus, WLv, Figure, Power}) ->
    #rank_state{role_maps = RoleMaps} = State,
    case maps:get({RankType, SubType}, RoleMaps, []) of
        [] ->
            NewValue = ValuePlus,
            NewRole = make_record(RankType, SubType, {RoleId, WLv, Figure, Power, ValuePlus}),
            NewList = [NewRole];
        RankList ->
            %% 更新个人值maps 增加魅力值
            case lists:keyfind({RankType, SubType, RoleId}, #rank_role_kf.role_key, RankList) of
                Role when is_record(Role, rank_role_kf) ->
                    NewValue = Role#rank_role_kf.value + ValuePlus,
                    NewRole = Role#rank_role_kf{value = NewValue, wlv = WLv, power = Power, time = utime:unixtime()};
                _ ->
                    NewValue = ValuePlus,
                    NewRole = make_record(RankType, SubType, {RoleId, WLv, Figure, Power, ValuePlus})
            end,
            NewList = lists:keystore({RankType, SubType, RoleId}, #rank_role_kf.role_key, RankList, NewRole)
    end,
    NewRoleMaps = maps:put({RankType, SubType}, NewList, RoleMaps),
    %?PRINT("~p~n", [NewValue]),
    %%--------db-------------
    Limit = lib_flower_act:get_rank_limit(RankType, SubType),
    case NewValue >= Limit of
        true ->
            mod_clusters_node:apply_cast(mod_kf_flower_act, refresh_common_rank, [RankType, SubType, NewRole, []]);
        _ -> skip
    end,
    NewState = State#rank_state{role_maps = NewRoleMaps},
    db_rank_role_kf_local_save(NewRole),
    {ok, NewState}.

wlv_change(State, _Type, SubType, WLv) ->
    ServerId = config:get_server_id(),
    mod_clusters_node:apply_cast(mod_kf_flower_act, wlv_change, [ServerId, SubType, WLv]),
    {noreply, State}.
    

%% 定时刷战力
refresh_power(State) ->
    #rank_state{role_maps = RoleMaps} = State,
    NowTime = utime:unixtime(),
    ServerId = config:get_server_id(),
    util:send_after([], 1800*1000, self(), {refresh_power}), %% 后续半个小时刷一次
    F = fun({RankType, SubType}, RankList, List) ->
        Limit = lib_flower_act:get_rank_limit(RankType, SubType),
        FI = fun(Role, ListI) ->
            #rank_role_kf{role_id = RoleId, value = Value, power = Power, time = Time} = Role,
            case Value >= Limit andalso ((NowTime - Time) > 60 orelse Power == 0) of 
                true ->
                    case lib_role:get_role_show_ets(RoleId) of 
                        #ets_role_show{h_combat_power = NewPower} -> 
                            [{RoleId, NewPower}|ListI];
                        _ ->
                            [_Gold, _BGold, _Coin, _GCoin, _Exp, NewPower|_] = lib_player:get_player_high_data(RoleId),
                            [{RoleId, NewPower}|ListI]
                    end;
                _ ->
                    ListI
            end
        end,
        RolePowerList = lists:foldl(FI, [], RankList),
        case length(RolePowerList) > 0 of 
            true ->
                [{RankType, SubType, ServerId, RolePowerList}|List];
            _ ->
                List
        end
    end,
    RefreshList = maps:fold(F, [], RoleMaps),
    length(RefreshList) > 0 andalso mod_clusters_node:apply_cast(mod_kf_flower_act, refresh_power, [RefreshList]),
    {noreply, State}.

%% 发送榜单列表
send_rank_list(State, RankType, SubType, RoleId, ServerId) ->
    #rank_state{role_maps = RoleMaps} = State,
    Node = mod_disperse:get_clusters_node(),
    RankList = maps:get({RankType, SubType}, RoleMaps, []),
    SelValue = case lists:keyfind({RankType, SubType, RoleId}, #rank_role_kf.role_key, RankList) of
                   Role when is_record(Role, rank_role_kf) -> Role#rank_role_kf.value;
                   _ -> 0
               end,
    mod_clusters_node:apply_cast(mod_kf_flower_act, send_rank_list, [Node, RankType, SubType, RoleId, ServerId, SelValue]),
    {ok, State}.

%% 活动结束清数据
clear_data(State, SubType) ->
    #rank_state{role_maps = RoleMaps} = State,
    NewRoleMaps = maps:remove({?RANK_TYPE_FLOWER_GIRL_KF, SubType}, RoleMaps),
    NewRoleMaps1 = maps:remove({?RANK_TYPE_FLOWER_BOY_KF, SubType}, NewRoleMaps),
    NewState = State#rank_state{role_maps = NewRoleMaps1},
    db:execute(io_lib:format(?sql_kf_rank_role_local_clear, [?RANK_TYPE_FLOWER_BOY_KF, ?RANK_TYPE_FLOWER_GIRL_KF, SubType])),
    {ok, NewState}.

change_rank_by_type(State, SubType, RoleId, OldType, NewType, Sex) ->
    #rank_state{role_maps = RoleMaps} = State,
    DelRoleL = maps:get({OldType, SubType}, RoleMaps, []),
    AddRoleL = maps:get({NewType, SubType}, RoleMaps, []),
    case lists:keyfind({OldType, SubType, RoleId}, #rank_role_kf.role_key, DelRoleL) of
        false -> NewDelRoleL = DelRoleL, NewAddRoleL = AddRoleL;
        DelRole ->
            NewDelRoleL = lists:keydelete({OldType, SubType, RoleId}, #rank_role_kf.role_key, DelRoleL),
            db_rank_role_kf_local_delete(OldType, SubType, RoleId),
            NewAddRoleL = lists:keystore({NewType, SubType, RoleId}, #rank_role_kf.role_key, AddRoleL,
                DelRole#rank_role_kf{role_key = {NewType, SubType, RoleId}, rank_type = NewType, sex = Sex}),
            db_rank_role_kf_local_save(DelRole#rank_role_kf{rank_type = NewType, sex = Sex})
    end,
    NewRoleMaps1 = maps:put({OldType, SubType}, NewDelRoleL, RoleMaps),
    NewRoleMaps2 = maps:put({NewType, SubType}, NewAddRoleL, NewRoleMaps1),
    %% 跨服中心处理
    mod_clusters_node:apply_cast(mod_kf_flower_act, change_rank_by_type, [SubType, RoleId, OldType, NewType, Sex]),
    {ok, State#rank_state{role_maps = NewRoleMaps2}}.

%% 玩家修改昵称同步修改榜单的值
change_role_name_by_type(State, SubType, RoleId, ChangeRankType, PlayerName) ->
    #rank_state{role_maps = RoleMaps} = State,
    AllRoleList = maps:get({ChangeRankType, SubType}, RoleMaps, []),
    case lists:keyfind({ChangeRankType, SubType, RoleId}, #rank_role_kf.role_key, AllRoleList) of
        #rank_role_kf{} = RankRole ->
            NewRankRole = RankRole#rank_role_kf{ name = PlayerName },
            db_rank_role_kf_local_save(NewRankRole),
            NewAllRoleList = lists:keystore({ChangeRankType, SubType, RoleId}, #rank_role_kf.role_key, AllRoleList, NewRankRole);
        _ ->
            NewAllRoleList = AllRoleList
    end,
    NewRoleMaps =  maps:put({ChangeRankType, SubType}, NewAllRoleList, RoleMaps),
    %% 跨服中心处理
    mod_clusters_node:apply_cast(mod_kf_flower_act, change_role_name_by_type, [SubType, RoleId, ChangeRankType, PlayerName]),
    {ok, State#rank_state{role_maps = NewRoleMaps}}.

sync_top_n_figure(State, RankType, SubType, TopNIds) ->
    #rank_state{top_n = TopNMap} = State,
    NewTopNMap = maps:put({RankType, SubType}, TopNIds, TopNMap),
    {noreply, State#rank_state{top_n = NewTopNMap}}.

update_role_figure(State, RoleId, KeyList) ->
    #rank_state{top_n = TopNMap} = State,
    F = fun({RankType, SubType}, TopNIds, Acc) ->
        case lists:member(RoleId, TopNIds) of 
            true ->
                mod_clusters_node:apply_cast(mod_kf_flower_act, update_role_figure, [RankType, SubType, RoleId, KeyList]);
            _ -> ok
        end,
        Acc
    end,
    maps:fold(F, 1, TopNMap),
    {noreply, State}.


%%------------db------------------------%%
db_rank_role_kf_select() ->
    Sql = io_lib:format(?sql_kf_rank_role_local_select, []),
    db:get_all(Sql).

db_rank_role_kf_local_delete(RankType, SubType, RoleId) ->
    Sql = io_lib:format(?sql_rank_role_kf_local_delete_by_role_id, [RankType, SubType, RoleId]),
    db:execute(Sql).

db_rank_role_kf_local_save(Role) ->
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
        time       = Time
    } = Role,
    Sql = io_lib:format(?sql_kf_rank_role_local_save,
        [RankType, SubType, RoleId, Value, ServerId, Platform, ServerNum, Name, Sex, Career, Turn, Time]),
    db:execute(Sql).



