%%%------------------------------------
%%% @Module  : lib_flower_act_mod
%%% @Author  :  xiaoxiang
%%% @Created :  2016-11-17
%%% @Description: 本服魅力榜活动
%%%------------------------------------
-module(lib_flower_act_mod_local).

-export([
    init/0
    , refresh_common_rank/4
    , send_rank_list/4
]).

-compile(export_all).

-include("errcode.hrl").
-include("language.hrl").
-include("flower_rank_act.hrl").
-include("common.hrl").
-include("record.hrl").
-include("relationship.hrl").
-include("figure.hrl").
-include("role.hrl").
-include("def_module.hrl").
-include("def_fun.hrl").
-include("predefine.hrl").

make_record(rank_role, [RankType, SubType, RoleId, Value, Time]) ->
    #rank_role{
        role_key  = {RankType, RoleId},        % {RankType, RoleId}
        rank_type = RankType,                  % 榜单类型
        sub_type  = SubType,                   % 活动子类型
        role_id   = RoleId,                    % 角色id
        value     = Value,                     % 排序值
        time      = Time                       % 时间戳
    };
make_record(rank_wed, [RankType, SubType, RoleId, SecId, Value, SecondValue, Time]) ->
    #rank_wed{
        wed_key      = {RankType, RoleId, Time},  % {RankType, RoleId, Time}
        rank_type    = RankType,                  % 榜单类型
        sub_type     = SubType,                   % 活动子类型
        role_id      = RoleId,                    % 男角色id
        sec_id       = SecId,                     % 女角色id
        value        = Value,                     % 预定婚礼时间
        second_value = SecondValue,               % 预约的婚礼类型
        time         = Time                       % 时间戳
    }.

init() ->
    %% 个人数据
    List = db_rank_role_select(),
    RoleList = [make_record(rank_role, T) || T <- List],
    %?PRINT("~p~n", [RoleList]),
    F = fun(#rank_role{rank_type = RankType, sub_type = SubType} = RankRole, Maps) ->
        case maps:get({RankType, SubType}, Maps, false) of
            false -> NewList = [RankRole];
            TmpL -> NewList = [RankRole | TmpL]
        end,
        maps:put({RankType, SubType}, NewList, Maps)
        end,
    RoleMaps = lists:foldl(F, maps:new(), RoleList),
    % 个人榜单
    RankMaps = get_standard_sort_rank_maps(rank_role, RoleList),
    RoleLimitList = clean_redundant_rank_data_from_db(rank_role, RankMaps),
    %% 婚礼榜
    List1 = db_rank_wedding_select(),
    WedList = [make_record(rank_wed, T) || T <- List1],
    WedMaps = get_standard_sort_rank_maps(rank_wed, WedList),
    clean_redundant_rank_data_from_db(rank_wed, WedMaps),

    RankLimit = maps:from_list(RoleLimitList),
    #rank_state{role_maps = RoleMaps, rank_maps = RankMaps, wed_maps = WedMaps, rank_limit = RankLimit}.

%% 获得标准排序Maps(被截取了长度) Key:{RankType, ActType} Value:[#rank_role{}]
get_standard_sort_rank_maps(rank_role, RankList) ->
    MapsKeyList = get_sort_rank_maps(rank_role, RankList),
    F = fun({{RankType, SubType}, TmpList}) ->
        MaxRankLen = lib_flower_act:get_max_len(RankType, SubType),
        CfgLim = lib_flower_act:get_rank_limit(RankType, SubType),
        NewRankList0 = lists:sublist(TmpList, MaxRankLen),
        NewRankList = [ RankRole || RankRole <- NewRankList0, RankRole#rank_role.value >= CfgLim ],
        {{RankType, SubType}, NewRankList}
        end,
    NewKeyList = lists:map(F, MapsKeyList),
    maps:from_list(NewKeyList);
get_standard_sort_rank_maps(rank_wed, RankList) ->
    MapsKeyList = get_sort_rank_maps(rank_wed, RankList),
    F = fun({{RankType, SubType}, TmpList}) ->
        MaxRankLen = lib_flower_act:get_max_len(RankType, SubType),
        NewRankList = lists:sublist(TmpList, MaxRankLen),
        {{RankType, SubType}, NewRankList}
        end,
    NewKeyList = lists:map(F, MapsKeyList),
    maps:from_list(NewKeyList).

%% 分类到Maps,然后对Maps的Value排序 Key:RankType Value:[#rank_role{}]
get_sort_rank_maps(rank_role, RankList) ->
    F = fun(#rank_role{rank_type = RankType, sub_type = SubType} = RankRole, Maps) ->
        case maps:get({RankType, SubType}, Maps, false) of
            false -> NewList = [RankRole];
            List -> NewList = [RankRole | List]
        end,
        maps:put({RankType, SubType}, NewList, Maps)
        end,
    Maps = lists:foldl(F, maps:new(), RankList),
    sort_rank_maps(Maps);

get_sort_rank_maps(rank_wed, WedList) ->
    F = fun(#rank_wed{rank_type = RankType, sub_type = SubType} = RankWed, Maps) ->
        case maps:get({RankType, SubType}, Maps, false) of
            false -> NewList = [RankWed];
            List -> NewList = [RankWed | List]
        end,
        maps:put({RankType, SubType}, NewList, Maps)
        end,
    Maps = lists:foldl(F, maps:new(), WedList),
    sort_rank_maps(Maps).

%% 对Maps的Value排序
sort_rank_maps(Maps) ->
    MapsKeyList = maps:to_list(Maps),
    F = fun({{RankType, SubType}, List}) ->
        RankList = sort_rank_list(List),
        {{RankType, SubType}, RankList}
        end,
    NewKeyList = lists:map(F, MapsKeyList),
    NewKeyList.

%% 根据排序值排序
sort_rank_list(List) ->
    F = fun(A, B) ->
        if
            is_record(A, rank_role) ->
                if
                    A#rank_role.value > B#rank_role.value -> true;
                    A#rank_role.value == B#rank_role.value ->
                        A#rank_role.time =< B#rank_role.time;
                    true -> false
                end;
        %% 预约时间越小 排名越前
            is_record(A, rank_wed) ->
                if
                    A#rank_wed.value < B#rank_wed.value -> true;
                    A#rank_wed.value == B#rank_wed.value ->
                        A#rank_wed.time =< B#rank_wed.time;
                    true -> false
                end;
            true ->
                false
        end
        end,
    NewList = lists:sort(F, List),
    F1 = fun(Member, {TempList, Value}) ->
        if
            is_record(Member, rank_role) ->
                NewMember = Member#rank_role{rank = Value},
                NewTempList = [NewMember | TempList],
                {NewTempList, Value + 1};
            is_record(Member, rank_wed) ->
                NewMember = Member#rank_wed{rank = Value},
                NewTempList = [NewMember | TempList],
                {NewTempList, Value + 1};
            true ->
                {TempList, Value}
        end
         end,
    {NewRankList, _} = lists:foldl(F1, {[], 1}, NewList),
    lists:reverse(NewRankList).

%% 阈值
clean_redundant_rank_data_from_db(rank_role, RankMaps) ->
    MapsKeyList = maps:to_list(RankMaps),
    F = fun
            ({{RankType, SubType}, []}) ->
                Limit = lib_flower_act:get_rank_limit(RankType, SubType),
                {{RankType, SubType}, Limit};
            ({{RankType, SubType}, RankList}) ->
                RankMax = lib_flower_act:get_max_len(RankType, SubType),
                Limit = lib_flower_act:get_rank_limit(RankType, SubType),
                case length(RankList) >= RankMax of
                    true ->
                        RankLast = lists:last(RankList),
                        Value = RankLast#rank_role.value,
                        {{RankType, SubType}, max(Value, Limit)};
                    false ->
                        {{RankType, SubType}, Limit}
                end
        end,
    lists:map(F, MapsKeyList);
clean_redundant_rank_data_from_db(rank_wed, RankMaps) ->
    MapsKeyList = maps:to_list(RankMaps),
    F = fun
            ({{RankType, SubType}, RankList}) ->
                RankMax = lib_flower_act:get_max_len(RankType, SubType),
                case length(RankList) >= RankMax of
                    true ->
                        RankLast = lists:last(RankList),
                        Value = RankLast#rank_wed.value,
                        db_rank_delete_by_value(RankType, SubType, Value);
                    false -> skip
                end
        end,
    lists:map(F, MapsKeyList).

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
refresh_common_rank(State, RankType, SubType, RankWed) when RankType == ?RANK_TYPE_WEDDING ->
    #rank_state{wed_maps = WedMaps} = State,
    RankList = maps:get({RankType, SubType}, WedMaps, []),
    NewRankList = do_refresh_rank_help(RankList, RankType, SubType, RankWed),
    NewRankMaps = maps:put({RankType, SubType}, NewRankList, WedMaps),
    NewState = State#rank_state{wed_maps = NewRankMaps},
    {ok, NewState};

refresh_common_rank(State, RankType, SubType, RankRole) ->
    #rank_role{role_id = RoleId, value = ValuePlus} = RankRole,
    #rank_state{rank_maps = RankMaps, role_maps = RoleMaps, rank_limit = RankLimit} = State,
    RankList = maps:get({RankType, SubType}, RankMaps, []),
    %% 更新个人值maps 增加魅力值
    RoleList = maps:get({RankType, SubType}, RoleMaps, []),
    case lists:keyfind({RankType, RoleId}, #rank_role.role_key, RoleList) of
        TmpRole when is_record(TmpRole, rank_role) ->
            NewValue = TmpRole#rank_role.value + ValuePlus;
        _ ->
            NewValue = ValuePlus
    end,
    NewRoleList = lists:keystore({RankType, RoleId}, #rank_role.role_key, RoleList, RankRole#rank_role{value = NewValue}),
    NewRoleMaps = maps:put({RankType, SubType}, NewRoleList, RoleMaps),
    NewRankRole = RankRole#rank_role{value = NewValue},
    {NewRankList, NewRankLimit} = do_refresh_rank_help(RankList, RankType, SubType, NewRankRole, RankLimit),
    NewRankMaps = maps:put({RankType, SubType}, NewRankList, RankMaps),
    NewState = State#rank_state{rank_maps = NewRankMaps, role_maps = NewRoleMaps, rank_limit = NewRankLimit},
    %%--------db-------------
    db_rank_role_save(NewRankRole),
    {ok, NewState}.

%% 先判断list中是否存在key和value都相等的玩家，存在则跟新数据，不存在则将其进行队列排序：将其与队
%% 尾比较，若小于队尾并且队列长度大于最长长度，则丢弃，否则将其加入队列，排序并保证队列长度为最大
%% 队列长度，发送数据的时候，先截取显示长度，再判断是否满足limit，满足条件的才加入发送队列。
%% 时刻保证，排序之后队列和数据库保存的数据为整个服的前N，然后在这之中选择发送
do_refresh_rank_help(RankList, RankType, SubType, RankWed) when RankType == ?RANK_TYPE_WEDDING ->
    MaxRankLen = lib_flower_act:get_max_len(RankType, SubType),
    case RankList == [] of
        true ->
            NewRankWed = RankWed#rank_wed{rank = 1},
            %% 上榜就发奖励
            send_wed_reward(SubType, NewRankWed),
            db_rank_wed_save(RankWed),
            [NewRankWed];
        false ->
            #rank_wed{wed_key = WedKey} = RankWed,
            NewRankList = lists:keystore(WedKey, #rank_wed.wed_key, RankList, RankWed),
            % 排序
            LastList = sort_rank_list(NewRankList),
            case length(LastList) > MaxRankLen of
                true -> RankList;
                false ->
                    %% 上榜就发奖励
                    case lists:keyfind(RankWed#rank_wed.wed_key, #rank_wed.wed_key, LastList) of
                        NewRankWed when is_record(NewRankWed, rank_wed) ->
                            send_wed_reward(SubType, NewRankWed);
                        _ -> skip
                    end,
                    db_rank_wed_save(RankWed)
            end,
            LastList
    end.
do_refresh_rank_help(RankList, RankType, SubType, RankRole, RankLimit) ->
    #rank_role{role_key = RoleKey, value = Value} = RankRole,
    %% 阈值
    Limit = lib_flower_act:get_rank_limit(RankType, SubType),
    %% 最大长度
    MaxRankLen = lib_flower_act:get_max_len(RankType, SubType),
    Temp = maps:get({RankType, SubType}, RankLimit, Limit),
    %% 最终阈值
    LastLimit = max(Temp, Limit),
    case RankList == [] of
        true ->
            if
                Value >= LastLimit ->
                    {[RankRole#rank_role{rank = 1}], RankLimit};
                true ->
                    {[], RankLimit}
            end;
        false ->
            IsExistKey = lists:keymember(RankRole#rank_role.role_key, #rank_role.role_key, RankList),
            % 是否需要排序
            case Value >= LastLimit orelse IsExistKey of
                false ->
                    {RankList, RankLimit};
                true ->
                    NewRankList = lists:keystore(RoleKey, #rank_role.role_key, RankList, RankRole),
                    % 排序
                    NewRankList2 = sort_rank_list(NewRankList),
                    LastList = lists:sublist(NewRankList2, MaxRankLen),
                    case length(NewRankList2) > MaxRankLen of
                        true ->
                            case LastList of
                                [] -> LastRankRole = #rank_role{};
                                _ -> LastRankRole = lists:last(LastList)
                            end,
                            #rank_role{value = TempLastLimit} = LastRankRole,
                            NewLastLimit = max(TempLastLimit, LastLimit);
                        false -> NewLastLimit = LastLimit
                    end,
                    NewRankLimit = maps:put({RankType, SubType}, NewLastLimit, RankLimit),
                    {LastList, NewRankLimit}
            end
    end.

%% 婚礼榜信息发送
send_rank_list(State, RankType, SubType, RoleId) when RankType == ?RANK_TYPE_WEDDING ->
    MaxRankLen = lib_flower_act:get_max_len(RankType, SubType),
    %% 婚礼折扣
    Discount = lib_flower_act:get_wed_discount(lib_flower_act:change_act_type(RankType), SubType),
    #rank_state{wed_maps = RankMaps} = State,
    RankList = maps:get({RankType, SubType}, RankMaps, []),
    SubRankList = lists:sublist(RankList, MaxRankLen),
    F = fun(#rank_wed{role_id = TmpRoleId, sec_id = SecId, value = Value, second_value = SecondValue, rank = Rank}) ->
        Figure1 = case lib_role:get_role_show(TmpRoleId) of
                      [] -> #figure{};
                      #ets_role_show{figure = TmpFigure1} -> TmpFigure1
                  end,
        Figure2 = case lib_role:get_role_show(SecId) of
                      [] -> #figure{};
                      #ets_role_show{figure = TmpFigure2} -> TmpFigure2
                  end,
        #figure{name = Name, sex = Sex, career = Career, vip = Vip, picture = Picture, picture_ver = PictureVer, turn = Turn, dress_list = Dress} = Figure1,
        #figure{name = Name2, sex = Sex2, career = Career2, vip = Vip2, picture = Picture2, picture_ver = PictureVer2, turn = Turn2, dress_list = Dress2} = Figure2,
        %% 婚礼奖励倍数
        RewardTimes = lib_flower_act:get_wed_reward_times(lib_flower_act:change_act_type(RankType), SubType, SecondValue),
        {TmpRoleId, Name, Sex, Career, Vip, Picture, PictureVer, Turn, Dress,
            SecId, Name2, Sex2, Career2, Vip2, Picture2, PictureVer2, Turn2, Dress2,
            Value, SecondValue, RewardTimes, Rank}
        end,
    List = lists:map(F, SubRankList),
    Sum = length(List),
    if
        Sum == 0 ->
            lib_server_send:send_to_uid(RoleId, pt_224, 22402, [RankType, 0, MaxRankLen, Discount, []]);
        true ->
            lib_server_send:send_to_uid(RoleId, pt_224, 22402, [RankType, Sum, MaxRankLen, Discount, List])
    end;

%% 魅力榜信息发送
send_rank_list(State, RankType, SubType, RoleId) ->
    %% 配置的最大长度和上榜阈值
    %?PRINT("~p~n", [State]),
    Limit = lib_flower_act:get_rank_limit(RankType, SubType),
    MaxRankLen = lib_flower_act:get_max_len(RankType, SubType),
    #rank_state{rank_maps = RankMaps, role_maps = RoleMaps} = State,
    %% 自己在活动期间的魅力值
    RoleList = maps:get({RankType, SubType}, RoleMaps, []),
    case lists:keyfind({RankType, RoleId}, #rank_role.role_key, RoleList) of
        #rank_role{value = SelValue} -> skip;
        _ -> SelValue = 0
    end,
    RankList = maps:get({RankType, SubType}, RankMaps, []),
    case lists:keyfind({RankType, RoleId}, #rank_role.role_key, RankList) of
        #rank_role{rank = RoleRank} -> skip;
        _ -> RoleRank = 0
    end,
    SubRankList = lists:sublist(RankList, MaxRankLen),
    List1 = [RankRole || RankRole <- SubRankList, RankRole#rank_role.value >= Limit],

    F = fun(#rank_role{role_id = TmpRoleId, value = Value, rank = Rank}) ->
        Figure = case lib_role:get_role_show(TmpRoleId) of
                     [] -> #figure{};
                     #ets_role_show{figure = TmpFigure} -> TmpFigure
                 end,
        #figure{name = Name, sex = Sex, career = Career, vip = Vip, guild_name = GuildName, picture = Picture, picture_ver = PictureVer, turn = Turn, dress_list = Dress} = Figure,
        {TmpRoleId, Name, Sex, Career, Vip, GuildName, Picture, PictureVer, Turn, Dress, Value, Rank}
        end,
    List = lists:map(F, List1),
    Sum = length(List),
    if
        Sum == 0 ->
            lib_server_send:send_to_uid(RoleId, pt_224, 22401, [RankType, 0, SelValue, 0, MaxRankLen, Limit, []]);
        true ->
            %?PRINT("~p~n", [List]),
            lib_server_send:send_to_uid(RoleId, pt_224, 22401, [RankType, RoleRank, SelValue, Sum, MaxRankLen, Limit, List])
    end.

%% 发送本服鲜花榜奖励（活动结束时触发）
send_charm_local_reward(State, SubType) ->
    #rank_state{rank_maps = RankMaps} = State,
    RankTypeL = ?RANK_TYPE_FLOWER,
    F = fun(RankType) ->
        RankList = maps:get({RankType, SubType}, RankMaps, []),
        spawn(fun() -> util:multiserver_delay(10, lib_flower_act_mod_local, do_send_charm_local_reward, [RankList, RankType, SubType, 1]) end)
        end,
    lists:foreach(F, RankTypeL),
    NewState = clear_charm_rank_local(State, SubType),
    %% 清空之前活动数据
    {ok, NewState}.

do_send_charm_local_reward([], _RankType, _SubType, _Count) -> skip;
do_send_charm_local_reward([RankRole | RankList], RankType, SubType, Count) when is_record(RankRole, rank_role) ->
    #rank_role{role_id = RoleId, rank = Rank, value = Value} = RankRole,
    %% 传闻
    if
        Rank == 1 ->
            case lib_role:get_role_show(RoleId) of
                [] -> Name = "";
                #ets_role_show{figure = #figure{name = Name}} -> skip
            end,
            lib_chat:send_TV({all}, ?MOD_FLOWER_RANK_ACT, ?IF(RankType == ?RANK_TYPE_FLOWER_BOY, 1, 2), [Name]);
        true -> skip
    end,
    case lib_flower_act:get_flower_rank_reward(RankType, SubType, Rank) of
        [] -> do_send_charm_local_reward(RankList, RankType, SubType, Count);
        Reward when is_list(Reward) ->
            Title = ?LAN_MSG(286),
            Content = uio:format(?LAN_MSG(287), [Rank]),
            lib_mail_api:send_sys_mail([RoleId], Title, Content, Reward),
            %% 日志
            Sex = ?IF(RankType == ?RANK_TYPE_FLOWER_BOY, ?MALE, ?FEMALE),
            lib_log_api:log_flower_rank_local(RoleId, Sex, Rank, Value, Reward),
            case Count rem 20 of
                0 -> timer:sleep(50);
                _ -> skip
            end,
            do_send_charm_local_reward(RankList, RankType, SubType, Count + 1);
        _ -> skip
    end;
do_send_charm_local_reward(_, _, _, _) -> skip.


%% 发送婚礼榜奖励（上榜即触发）
send_wed_reward(SubType, RankWed) ->
    RankType = ?RANK_TYPE_WEDDING,
    #rank_wed{
        role_id      = RoleId,
        sec_id       = SecId,
        second_value = WedType,
        rank         = Rank,
        value        = BookTime
    } = RankWed,
    % ?PRINT("~p~n", [Reward]),
    %% 给两人都发奖励
    case lib_flower_act:get_wed_rank_reward(RankType, SubType, Rank, WedType) of
        [] -> skip;
        Reward when is_list(Reward) ->
            Title = ?LAN_MSG(288),
            Content = uio:format(?LAN_MSG(289), [Rank]),
            lib_mail_api:send_sys_mail([RoleId, SecId], Title, Content, Reward),
            %% 日志
            lib_log_api:log_wed_rank(RoleId, SecId, Rank, BookTime, Reward);
        _ -> skip
    end.

%% 清楚本次本服魅力榜数据（活动结束时触发）
clear_charm_rank_local(State, SubType) ->
    #rank_state{rank_maps = RankMaps, role_maps = RoleMaps, rank_limit = Limit} = State,
    NewRankMaps1 = maps:remove({?RANK_TYPE_FLOWER_BOY, SubType}, RankMaps),
    NewRankMaps = maps:remove({?RANK_TYPE_FLOWER_GIRL, SubType}, NewRankMaps1),
    NewRoleMaps1 = maps:remove({?RANK_TYPE_FLOWER_BOY, SubType}, RoleMaps),
    NewRoleMaps = maps:remove({?RANK_TYPE_FLOWER_GIRL, SubType}, NewRoleMaps1),
    NewLimit1 = maps:remove({?RANK_TYPE_FLOWER_BOY, SubType}, Limit),
    NewLimit = maps:remove({?RANK_TYPE_FLOWER_GIRL, SubType}, NewLimit1),
    NewState = State#rank_state{rank_maps = NewRankMaps, role_maps = NewRoleMaps, rank_limit = NewLimit},
    %?PRINT("~p~n", [SubType]),
    db:execute(io_lib:format(?sql_rank_role_clear, [?RANK_TYPE_FLOWER_BOY, ?RANK_TYPE_FLOWER_GIRL, SubType])),
    NewState.

%% 清楚本次婚礼榜数据（活动结束时触发）
clear_wed_rank(State, SubType) ->
    #rank_state{wed_maps = WedMaps, rank_limit = Limit} = State,
    NewWedMaps = maps:remove({?RANK_TYPE_WEDDING, SubType}, WedMaps),
    NewLimit = maps:remove({?RANK_TYPE_WEDDING, SubType}, Limit),
    NewState = State#rank_state{wed_maps = NewWedMaps, rank_limit = NewLimit},
    db:execute(io_lib:format(?sql_rank_wed_clear, [?RANK_TYPE_WEDDING, SubType])),
    {ok, NewState}.

%% 变性相关
change_rank_by_type(State, SubType, RoleId, OldType, NewType) ->
    #rank_state{role_maps = RoleMaps, rank_maps = RankMaps} = State,
    DelRoleL = maps:get({OldType, SubType}, RoleMaps, []),
    AddRoleL = maps:get({NewType, SubType}, RoleMaps, []),
    DelRankL = maps:get({OldType, SubType}, RankMaps, []),
    AddRankL = maps:get({NewType, SubType}, RankMaps, []),
    case lists:keyfind({OldType, RoleId}, #rank_role.role_key, DelRoleL) of
        false -> NewDelRoleL = DelRoleL, NewAddRoleL = AddRoleL;
        DelRole ->
            NewDelRoleL = lists:keydelete({OldType, RoleId}, #rank_role.role_key, DelRoleL),
            db_rank_delete_by_id(OldType, SubType, RoleId),
            NewAddRoleL = lists:keystore({NewType, RoleId}, #rank_role.role_key, AddRoleL,
                DelRole#rank_role{role_key = {NewType, RoleId}, rank_type = NewType}),
            db_rank_role_save(DelRole#rank_role{rank_type = NewType})
    end,
    case lists:keyfind({OldType, RoleId}, #rank_role.role_key, DelRankL) of
        false -> NewDelRankL = DelRankL, NewAddRankL = AddRankL;
        DelRankRole ->
            TmpDelRankL = lists:keydelete({OldType, RoleId}, #rank_role.role_key, DelRankL),
            TmpAddRankL = lists:keystore({NewType, RoleId}, #rank_role.role_key, AddRankL,
                DelRankRole#rank_role{role_key = {NewType, RoleId}, rank_type = NewType}),
            NewDelRankL = sort_rank_list(TmpDelRankL),
            NewAddRankL = sort_rank_list(TmpAddRankL)
    end,
    NewRoleMaps1 = maps:put({OldType, SubType}, NewDelRoleL, RoleMaps),
    NewRoleMaps2 = maps:put({NewType, SubType}, NewAddRoleL, NewRoleMaps1),
    NewRankMaps1 = maps:put({OldType, SubType}, NewDelRankL, RankMaps),
    NewRankMaps2 = maps:put({NewType, SubType}, NewAddRankL, NewRankMaps1),
    {ok, State#rank_state{role_maps = NewRoleMaps2, rank_maps = NewRankMaps2}}.



%%-----------------db-----------------------%%

db_rank_role_select() ->
    Sql = io_lib:format(?sql_rank_role_select, []),
    db:get_all(Sql).

db_rank_wedding_select() ->
    Sql = io_lib:format(?sql_rank_wed_select, []),
    db:get_all(Sql).

db_rank_role_save(RankRole) ->
    #rank_role{
        rank_type = RankType,
        sub_type  = SubType,
        role_id   = RoleId,
        value     = Value,
        time      = Time
    } = RankRole,
    Sql = io_lib:format(?sql_rank_role_save,
        [RankType, SubType, RoleId, Value, Time]),
    db:execute(Sql).

db_rank_wed_save(RankRole) ->
    #rank_wed{
        rank_type    = RankType,
        sub_type     = SubType,
        role_id      = RoleId,
        sec_id       = SecId,
        value        = Value,
        second_value = SecondValue,
        time         = Time
    } = RankRole,
    Sql = io_lib:format(?sql_rank_wed_save,
        [RankType, SubType, RoleId, SecId, Value, SecondValue, Time]),
    db:execute(Sql).

db_rank_delete_by_id(RankType, SubType, RoleId) when RankType == ?RANK_TYPE_WEDDING ->
    Sql = io_lib:format(?sql_rank_wed_delete_by_role_id, [RankType, SubType, RoleId]),
    db:execute(Sql);
db_rank_delete_by_id(RankType, SubType, RoleId) ->
    Sql = io_lib:format(?sql_rank_role_delete_by_role_id, [RankType, SubType, RoleId]),
    db:execute(Sql).

db_rank_delete_by_value(RankType, SubType, Value) when RankType == ?RANK_TYPE_WEDDING ->
    Sql = io_lib:format(?sql_rank_wed_delete_by_value, [RankType, SubType, Value]),
    db:execute(Sql);
db_rank_delete_by_value(RankType, SubType, Value) ->
    Sql = io_lib:format(?sql_rank_role_delete_by_value, [RankType, SubType, Value]),
    db:execute(Sql).