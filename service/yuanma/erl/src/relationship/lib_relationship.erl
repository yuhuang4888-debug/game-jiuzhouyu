%% ---------------------------------------------------------------------------
%% @doc lib_relationship.erl

%% @author hjh
%% @since  2016-12-06
%% @deprecated 关系(所有接口只在玩家进程调用)
%% ---------------------------------------------------------------------------
-module(lib_relationship).
-include("server.hrl").
-include("figure.hrl").
-include("errcode.hrl").
-include("relationship.hrl").
-include("vip.hrl").
-include("predefine.hrl").
-include("common.hrl").
-include("def_module.hrl").
-include("def_daily.hrl").
-include("def_vip.hrl").
-include("def_event.hrl").
-include("def_fun.hrl").
-include("role.hrl").

-include_lib("stdlib/include/ms_transform.hrl").

-export([
    get_relas_by_types/2                %% 获得相应的关系列表
    ,get_friend_id_on_dict/1            %% 获取好友Id列表
    ,get_friend_on_dict/1
    ,get_rela_with_other_on_dict/2      %% 获取A B玩家之间的关系(A玩家进程)
    % get_rela_with_other_from_db/2,    %% 从数据库获取A B玩家之间的关系
    ,is_friend_on_dict/2                %% 是否为好友
    ,is_enemy_on_dict/2                 %% 是否为仇人
    ,is_black_on_dict/2                 %% 是否为黑名单
    ,is_black/2                         %% 是否在黑名单
    ,is_black_on_db/2                   %% 是否在黑名单
    ,get_rela_list/2                    %% 获取玩家的关系列表
    ,get_recommended_list/2             %% 获取玩家的好友推荐列表
    ,get_one_recommended_role_info/1    %% 获取推荐好友的信息
    ,ask_add_friend/3                   %% 请求添加好友
    ,get_friend_ask_list/1              %% 获取好友请求列表
    ,reply_add_friend_ask/2             %% 回复所有好友请求
    ,reply_one_add_friend_ask/4         %% 回复单个玩家的好友请求
    ,del_friend/2                       %% 删除好友
    ,pull_black/3                       %% 拉黑玩家
    ,del_from_black_list/2              %% 取消拉黑
    ,add_enemy/2                        %% 增加仇人
    ,del_from_enemies/2                 %% 删除仇人
    ,get_rela_and_intimacy_online/2     %% 获得ID列表的关系和亲密度(在线)
    ,get_rela_and_intimacy_offline/2    %% 获得ID列表的关系和亲密度(离线)
    ,get_rela_and_intimacy/2            %% 获取关系和亲密度
    ,update_intimacy/7                  %% 更新亲密度
    ,update_intimacy_each_one/5         %% 同时更新好友双方的亲密度
    ,get_intimacy_attr/2
    ,update_last_chat_time/3
    ,update_last_ctime_each_one/3
    ,trigger_intimacy_add/5
    ,rela_type_change/3
    ,clear_intimacy_each_one/3         %% 清空亲密度
    ,clear_intimacy/3
    ,get_rela_on_db_2/1
    ,do_add_firend_directly/3
    ,check_list/1
]).

-export([
    be_asked_add_friend/2              %% 回调函数(外部不要私自调用)
    ,receive_friend_ask_reply/5        %% 回调函数(外部不要私自调用)
    ,be_pull_black/3                   %% 回调函数(外部不要私自调用)
    ,be_del_friend_by_other/2          %% 回调函数(外部不要私自调用)
    ]).

-export([
    role_change_online_status/3
    ]).

%% 注意:dict是玩家进程处理;db是数据库;其他函数会先从本玩家进程,再对方玩家进程,最后数据库查询对应的好友关系
make_record(rela, [RoleId, OtherRid, RelaType, Intimacy, LastChatTime, CTime]) ->
    #rela{
        role_id = RoleId,
        other_rid = OtherRid,
        rela_type = RelaType,
        intimacy = Intimacy,
        last_chat_time = LastChatTime,
        ctime = CTime
    };
%% 好友请求
make_record(friend_ask, [RoleId, AskId, Time]) ->
    #friend_ask{role_id = RoleId, ask_id = AskId, time = Time}.

%% 获得相应的关系列表
get_relas_by_types(RoleId, Type) ->
    RelaTypeList = case Type of
        1 -> ?RELA_FRIEND_TYPES;
        2 -> ?RELA_ENEMY_TYPES;
        3 -> ?RELA_BLACK_TYPES;
        _ -> []
    end,
    get_relas_by_types_on_dict(RoleId, RelaTypeList).

%% 根据关系类型获得关系列表
get_relas_by_types_on_dict(_, []) -> [];
get_relas_by_types_on_dict(RoleId, RelaTypeList) ->
    RelaList = get_rela_on_dict(RoleId),
    [R || R <- RelaList, lists:member(R#rela.rela_type, RelaTypeList)].

%% 从内存获取玩家和某玩家的关系
%% RoleId:玩家自己id
%% OtherRid:另一个玩家的id
get_rela_with_other_on_dict(RoleId, OtherRid) ->
    RelaList = get_rela_on_dict(RoleId),
    lists:keyfind(OtherRid, #rela.other_rid, RelaList).

%% 从数据库获取玩家和某玩家的关系
get_rela_with_other_from_db(RoleId, OtherRid) ->
    case db:get_row(io_lib:format(?sql_rela_select_by_rid_and_oid, [RoleId, OtherRid])) of
        [] -> [];
        List -> make_record(rela, List)
    end.

%% 获取好友Id列表
get_friend_id_on_dict(RoleId) ->
    List = get_rela_on_dict(RoleId),
    [OtherRid || #rela{other_rid = OtherRid, rela_type = RelaType} <- List, lists:member(RelaType, ?RELA_FRIEND_TYPES)].

%% 获取好友列表
get_friend_on_dict(RoleId) ->
    get_relas_by_types_on_dict(RoleId, ?RELA_FRIEND_TYPES).

%% 玩家间是否存在指定的关系
is_sepcify_rela_on_dict(RoleId, OtherRid, RelaTypeList) ->
    case get_rela_with_other_on_dict(RoleId, OtherRid) of
        false -> false;
        #rela{rela_type = RelaType} ->
            lists:member(RelaType, RelaTypeList)
    end.

%% 是否为好友
is_friend_on_dict(RoleId, OtherRid) ->
    is_sepcify_rela_on_dict(RoleId, OtherRid, ?RELA_FRIEND_TYPES).

%% 是否为仇人
is_enemy_on_dict(RoleId, OtherRid) ->
    is_sepcify_rela_on_dict(RoleId, OtherRid, ?RELA_ENEMY_TYPES).

%% 是否为黑名单
is_black_on_dict(RoleId, OtherRid) ->
    is_sepcify_rela_on_dict(RoleId, OtherRid, ?RELA_BLACK_TYPES).

%% 是否在黑名单
is_black(RoleId, OtherRid) ->
    case is_self_pid(RoleId) of
        true -> is_black_on_dict(RoleId, OtherRid);
        false ->
            case catch lib_player:apply_call(RoleId, ?APPLY_CALL, lib_relationship, is_black, [RoleId, OtherRid], 1000) of
                Result when is_boolean(Result) -> Result;
                _ -> is_black_on_db(RoleId, OtherRid)
            end
    end.

%% 是否在黑名单
is_black_on_db(RoleId, OtherRid) ->
    case get_rela_with_other_on_dict(RoleId, OtherRid) of
        false -> false;
        #rela{rela_type = RelaType} ->
            lists:member(RelaType, ?RELA_BLACK_TYPES)
    end.

%% 获得关系列表
get_rela_list(RoleId, Type) when is_integer(Type) ->
    RelaTypeList = case Type of
        1 -> ?RELA_FRIEND_TYPES;
        2 -> ?RELA_ENEMY_TYPES;
        3 -> ?RELA_BLACK_TYPES;
        _ -> []
    end,
    get_rela_list(RoleId, RelaTypeList);
get_rela_list(RoleId, RelaTypeList) when is_list(RelaTypeList) andalso RelaTypeList =/= [] ->
    List = get_relas_by_types_on_dict(RoleId, RelaTypeList),
    get_rela_list_help(List, []);
get_rela_list(_, _) -> [].

make_up_friend_info(Rela, RoleId) when is_integer(RoleId) ->
    case lib_role:get_role_show(RoleId) of
        RoleInfo when is_record(RoleInfo, ets_role_show) -> skip;
        _ -> RoleInfo = #ets_role_show{}
    end,
    make_up_friend_info(Rela, RoleInfo);
make_up_friend_info(Rela, RoleInfo) ->
    {BlockId, HouseId} = RoleInfo#ets_role_show.figure#figure.home_id,
    OfflineTime = lib_role:get_role_offline_time(RoleInfo#ets_role_show.id),
    {
        RoleInfo#ets_role_show.id,
        RoleInfo#ets_role_show.figure#figure.name,
        RoleInfo#ets_role_show.figure#figure.career,
        RoleInfo#ets_role_show.figure#figure.sex,
        RoleInfo#ets_role_show.figure#figure.turn,
        RoleInfo#ets_role_show.figure#figure.lv,
        RoleInfo#ets_role_show.figure#figure.vip,
        RoleInfo#ets_role_show.figure#figure.vip_hide,
        RoleInfo#ets_role_show.figure#figure.picture,
        RoleInfo#ets_role_show.figure#figure.picture_ver,
        RoleInfo#ets_role_show.combat_power,
        RoleInfo#ets_role_show.online_flag,
        Rela#rela.intimacy,
        RoleInfo#ets_role_show.figure#figure.marriage_type,
        BlockId,
        HouseId,
        RoleInfo#ets_role_show.figure#figure.house_lv,
        RoleInfo#ets_role_show.figure#figure.is_supvip,
        Rela#rela.last_chat_time,
        OfflineTime,
        Rela#rela.ctime,
        RoleInfo#ets_role_show.figure#figure.dress_list
    }.

get_rela_list_help([], Result) -> Result;
get_rela_list_help([#rela{role_id = RoleId, other_rid = OtherRid} = Rela|L], Result) ->
    case lib_role:get_role_show(OtherRid) of
        RoleInfo when is_record(RoleInfo, ets_role_show) ->
            T = make_up_friend_info(Rela, RoleInfo),
            get_rela_list_help(L, [T|Result]);
        _ ->
            ?ERR("get_rela_list_help err other_rid:~p", [OtherRid]),
            db:execute(io_lib:format(?sql_del_role_rela, [RoleId, OtherRid])),
            get_rela_list_help(L, Result)
    end.

%% 获取某个推荐好友的信息
get_one_recommended_role_info(RoleId) when is_integer(RoleId) ->
    case lib_role:get_role_show(RoleId) of
        RoleInfo when is_record(RoleInfo, ets_role_show) ->
            {
                RoleId,
                RoleInfo#ets_role_show.figure#figure.name,
                RoleInfo#ets_role_show.figure#figure.career,
                RoleInfo#ets_role_show.figure#figure.sex,
                RoleInfo#ets_role_show.figure#figure.turn,
                RoleInfo#ets_role_show.figure#figure.lv,
                RoleInfo#ets_role_show.figure#figure.vip,
                RoleInfo#ets_role_show.figure#figure.vip_hide,
                RoleInfo#ets_role_show.figure#figure.picture,
                RoleInfo#ets_role_show.figure#figure.picture_ver,
                RoleInfo#ets_role_show.combat_power,
                RoleInfo#ets_role_show.online_flag,
                RoleInfo#ets_role_show.figure#figure.is_supvip
            };
        _ -> false
    end.

%% 获取推荐好友列表
get_recommended_list(RoleId, 0) ->
    RecommendedRids = case get(rela_recommended_list) of
        undefined ->
            NeedCheck = false,
            do_get_recommended_list(RoleId);
        Val when Val =/= [] ->
            NeedCheck = true,
            Val;
        _ -> %% 如果之前的推荐列表是空的,打开界面自动刷新
            NeedCheck = false,
            do_get_recommended_list(RoleId)
    end,
    F = fun(OneId, ListTmp) ->
        case get_one_recommended_role_info(OneId) of
            false -> ListTmp;
            Tmp -> ListTmp ++ [Tmp]
        end
    end,
    case NeedCheck of
        true ->
            F1 = fun(OneId) ->
                is_friend_on_dict(RoleId, OneId)
            end,
            IsIncludeFriend = lists:any(F1, RecommendedRids),
            case IsIncludeFriend of
                true ->
                    NewRecommendedRids = do_get_recommended_list(RoleId);
                _ ->
                    NewRecommendedRids = RecommendedRids
            end;
        _ ->
            NewRecommendedRids = RecommendedRids
    end,
    RecommendedList = lists:foldl(F, [], NewRecommendedRids),
    {?SUCCESS, RecommendedList};
get_recommended_list(RoleId, _Type) ->
    LastSearchTime = case get(rela_last_search_time) of
        undefined -> 0;
        Val -> Val
    end,
    Unixtime = utime:unixtime(),
    case Unixtime - LastSearchTime >= ?RECOMMENDED_SEARCH_CD of
        true ->
            RecommendedRids = do_get_recommended_list(RoleId),
            F = fun(OneId, ListTmp) ->
                case get_one_recommended_role_info(OneId) of
                    false -> ListTmp;
                    Tmp -> ListTmp ++ [Tmp]
                end
            end,
            RecommendedList = lists:foldl(F, [], RecommendedRids),
            put(rela_last_search_time, Unixtime),
            {?SUCCESS, RecommendedList};
        false ->
            {?ERRCODE(err140_26_recommended_too_often), []}
    end.

do_get_recommended_list(RoleId) ->
    OnlineRIds = lib_online:get_online_ids(),
    RandList = ulists:list_shuffle(OnlineRIds),
    RecommendedRids = do_get_recommended_list_helper(RandList, RoleId, [], 0),
    put(rela_recommended_list, RecommendedRids),
    RecommendedRids.

do_get_recommended_list_helper([], _, Result, _) -> Result;
do_get_recommended_list_helper(_, _, Result, ResultLen) when ResultLen >= ?RECOMMENDED_LIST_MAX_LEN -> Result;
do_get_recommended_list_helper([OneId|OnlineRIds], RoleId, Result, ResultLen) ->
    OpenLv = lib_module:get_open_lv(?MOD_RELA, 1),
    case lib_role:get_role_show(OneId) of
        #ets_role_show{
           figure = #figure{lv = Lv},
           online_flag = ?ONLINE_ON
        } when Lv >= OpenLv ->
            case OneId =/= RoleId andalso is_friend_on_dict(RoleId, OneId) == false of
                true -> %% 自己和好友的不会推荐
                    do_get_recommended_list_helper(OnlineRIds, RoleId, [OneId|Result], ResultLen + 1);
                false ->
                    do_get_recommended_list_helper(OnlineRIds, RoleId, Result, ResultLen)
            end;
        _ -> do_get_recommended_list_helper(OnlineRIds, RoleId, Result, ResultLen)
    end.

%% 请求添加好友(请求者进程)
ask_add_friend(Sid, RoleId, BeAskId) ->
    %% 注意: is_no_black call 了玩家进程
    CheckList = [{add_self, RoleId, BeAskId}, {friend_num_limit, RoleId}, {check_rela_type, RoleId, BeAskId}, {other_side_online, BeAskId}, {is_no_black, BeAskId, RoleId}],
    case check_list(CheckList) of
        true ->
            BeAskPid = misc:get_player_process(BeAskId),
            case misc:is_process_alive(BeAskPid) of
                true -> %% 被请求玩家在线跳到被请求玩家进程处理
                    lib_player:apply_cast(BeAskId, ?APPLY_CAST, lib_relationship, be_asked_add_friend, [BeAskId, RoleId]),
                    {ok, BinData} = pt_140:write(14003, [?SUCCESS]),
                    lib_server_send:send_to_uid(RoleId, BinData);
                false -> %% 对方不在线不能加好友
                    {ok, BinData} = pt_140:write(14003, [?ERRCODE(err140_14_not_online)]),
                    lib_server_send:send_to_sid(Sid, BinData)
                    % %% 玩家不在线直接操作数据库
                    % case get_rela_with_other_from_db(BeAskId, RoleId) of
                    %     #rela{rela_type = RelaType} ->
                    %         case lists:member(RelaType, ?RELA_BLACK_TYPES) of
                    %             false -> %% 在对方黑名单里面不处理
                    %                 db_add_friend_ask(BeAskId, RoleId, utime:unixtime());
                    %             true -> skip
                    %         end;
                    %     _ -> skip
                    % end
            end;
        {false, Code} ->
            {ok, BinData} = pt_140:write(14003, [Code]),
            lib_server_send:send_to_sid(Sid, BinData);
        _ -> skip
    end.

%% 收到添加好友请求(被请求者进程)
be_asked_add_friend(RoleId, AskId) ->
    PreRelaType = case get_rela_with_other_on_dict(RoleId, AskId) of
        #rela{rela_type = RelaType} -> RelaType;
        _ -> 0
    end,
    case lists:member(PreRelaType, ?RELA_BLACK_TYPES) of
        false -> %% 不在自己的黑名单里面才处理
            CurFriendAskList = get_friend_ask_on_dict(RoleId),
            Unixtime = utime:unixtime(),
            NewFriendAskList = lists:keystore(AskId, #friend_ask.ask_id, CurFriendAskList, #friend_ask{ask_id = AskId, time = Unixtime}),
            save_friend_ask_on_dict(RoleId, NewFriendAskList),
            db_add_friend_ask(RoleId, AskId, Unixtime),
            case lib_role:get_role_show(AskId) of
                #ets_role_show{
                   figure = #figure{name = AskName, lv = AskLv, career = AskCareer, turn = AskTurn, picture = AskPicture, picture_ver = AskPictureVer},
                   combat_power = AskCombatPower
                } ->
                    %% 通知客户端有新的好友请求
                    {ok, BinData} = pt_140:write(14008, [AskId, AskName, AskCareer, AskTurn, AskLv, AskPicture, AskPictureVer, AskCombatPower, Unixtime]),
                    lib_server_send:send_to_uid(RoleId, BinData);
                _ -> skip
            end;
        true -> ok
    end.

%% 获取好友请求列表
get_friend_ask_list(RoleId) ->
    case get_friend_ask_on_dict(RoleId) of
        [] -> [];
        CurFriendAskList ->
            F = fun(FriendAsk) ->
                case lib_role:get_role_show(FriendAsk#friend_ask.ask_id) of
                    #ets_role_show{figure = AskerFigure, combat_power = CombatPower} ->
                        {FriendAsk#friend_ask.ask_id, AskerFigure#figure.name, AskerFigure#figure.career, 
                            AskerFigure#figure.turn, AskerFigure#figure.lv, AskerFigure#figure.picture, AskerFigure#figure.picture_ver, 
                            CombatPower, FriendAsk#friend_ask.time};
                    _ ->
                        {FriendAsk#friend_ask.ask_id, "???", 0, 0, 0, "", 0, 0, FriendAsk#friend_ask.time}
                end
            end,
            [F(FriendAsk) || FriendAsk <- CurFriendAskList, is_record(FriendAsk, friend_ask)]
    end.

%% 按照申请的时间先后顺序，自动逐条接受申请并删除申请直到列表为空或好友人数达到上限
%% 排序由客户端来排服务端这边不做排序
agree_add_friend_ask([], RelaList, FriendAskList, _RoleId, _RoleName, _FriendNum, _Unixtime) ->
    {RelaList, FriendAskList};
agree_add_friend_ask(_AskIds, RelaList, FriendAskList, _RoleId, _RoleName, FriendNum, _Unixtime) when FriendNum >= ?FRIEND_NUM_LIMIT ->
    {RelaList, FriendAskList};
agree_add_friend_ask([AskId|AskIds], RelaList, FriendAskList, RoleId, RoleName, FriendNum, Unixtime) when AskId =/= RoleId ->
    case lists:keyfind(AskId, #friend_ask.ask_id, FriendAskList) of
        #friend_ask{} -> %% 请求存在
            case lists:keyfind(AskId, #rela.other_rid, RelaList) of
                #rela{rela_type = RelaType} = PreRela ->
                    InBlackList = lists:member(RelaType, ?RELA_BLACK_TYPES),
                    InFriendList = lists:member(RelaType, ?RELA_FRIEND_TYPES),
                    case InBlackList == false andalso InFriendList == false of
                        true -> %% 不在好友列表和黑名单才能添加
                            {NewRelaList, NewFriendAskList} = do_agree_add_friend_ask(RoleId, AskId, PreRela, RelaList, FriendAskList, RoleName, Unixtime),
                            agree_add_friend_ask(AskIds, NewRelaList, NewFriendAskList, RoleId, RoleName, FriendNum + 1, Unixtime);
                        false ->
                            agree_add_friend_ask(AskIds, RelaList, FriendAskList, RoleId, RoleName, FriendNum, Unixtime)
                    end;
                _ -> %% 不存在关系
                    {NewRelaList, NewFriendAskList} = do_agree_add_friend_ask(RoleId, AskId, #rela{role_id = RoleId, other_rid = AskId}, RelaList, FriendAskList, RoleName, Unixtime),
                    agree_add_friend_ask(AskIds, NewRelaList, NewFriendAskList, RoleId, RoleName, FriendNum + 1, Unixtime)
            end;
        _ ->
            agree_add_friend_ask(AskIds, RelaList, FriendAskList, RoleId, RoleName, FriendNum, Unixtime)
    end;
agree_add_friend_ask([_AskId|AskIds], RelaList, FriendAskList, RoleId, RoleName, FriendNum, Unixtime) ->
    agree_add_friend_ask(AskIds, RelaList, FriendAskList, RoleId, RoleName, FriendNum, Unixtime).

do_agree_add_friend_ask(RoleId, AskId, PreRela, RelaList, FriendAskList, RoleName, Time) ->
    NewRelaType = rela_type_change(PreRela#rela.rela_type, ?RELA_TYPE_FRIEND, add_friend),
    db_rela_insert(RoleId, AskId, NewRelaType, Time),
    db_del_friend_ask_by_asker_id(RoleId, AskId),
    NewOneRela = make_record(rela, [RoleId, AskId, NewRelaType, 0, 0, Time]),
    NewRelaList = lists:keystore(AskId, #rela.other_rid, RelaList, NewOneRela),
    NewFriendAskList = lists:keydelete(AskId, #friend_ask.ask_id, FriendAskList),
    AskPid = misc:get_player_process(AskId),
    case misc:is_process_alive(AskPid) of
        true -> %% 好友请求者在线跳到请求玩家进程处理
            lib_player:apply_cast(AskId, ?APPLY_CAST_SAVE, lib_relationship, receive_friend_ask_reply, [AskId, RoleId, RoleName, Time]);
        false -> %% 玩家不在线直接操作数据库
            case get_rela_with_other_from_db(AskId, RoleId) of
                #rela{rela_type = PreRelaType1} ->
                    %% 如果对方之前有发好友请求过来要删掉
                    db_del_friend_ask_by_asker_id(AskId, RoleId),
                    NewRelaType1 = rela_type_change(PreRelaType1, ?RELA_TYPE_FRIEND, add_friend),
                    db_rela_insert(AskId, RoleId, NewRelaType1, Time);
                _ ->
                    PreRelaType1 = ?RELA_TYPE_NONE,
                    NewRelaType1 = ?RELA_TYPE_FRIEND,
                    db_rela_insert(AskId, RoleId, ?RELA_TYPE_FRIEND, Time)
            end,
            %% 日志
            lib_log_api:log_rela(AskId, RoleId, PreRelaType1, ?BE_ADD_FRIEND, NewRelaType1)
    end,
    %% 触发任务
    % lib_task_api:add_friend(RoleId),
    %% 日志
    lib_log_api:log_rela(RoleId, AskId, PreRela#rela.rela_type, ?ADD_FRIEND, NewRelaType),

    RelaRoleInfo = make_up_friend_info(NewOneRela, AskId),
    notify_client_rela_update(?RELA_UPDATE_ADD, RoleId, ?RELA_LIST_TYPE_FRIEND, [RelaRoleInfo]),

    {NewRelaList, NewFriendAskList}.

%% 收到同意加好友的回复
receive_friend_ask_reply(Player, RoleId, BeAskId, BeAskName, Time) ->
    %% 如果对方之前有发好友请求过来要删掉
    case get_friend_ask_on_dict(RoleId) of
        [] -> skip;
        CurFriendAskList ->
            db_del_friend_ask_by_asker_id(RoleId, BeAskId),
            NewFriendAskList = lists:keydelete(BeAskId, #friend_ask.ask_id, CurFriendAskList),
            save_friend_ask_on_dict(RoleId, NewFriendAskList)
    end,
    RelaList = get_rela_on_dict(RoleId),
    PreRela = case lists:keyfind(BeAskId, #rela.other_rid, RelaList) of
        #rela{} = PreRelaTmp -> PreRelaTmp;
        _ -> #rela{role_id = RoleId, other_rid = BeAskId, rela_type = 0}
    end,
    NewRelaType = rela_type_change(PreRela#rela.rela_type, ?RELA_TYPE_FRIEND, add_friend),
    db_rela_insert(RoleId, BeAskId, NewRelaType, Time),
    NewOneRela = make_record(rela, [RoleId, BeAskId, NewRelaType, 0, 0, Time]),
    NewRelaList = lists:keystore(BeAskId, #rela.other_rid, RelaList, NewOneRela),
    %% 保存好友列表到玩家的进程字典中
    save_rela_on_dict(RoleId, NewRelaList),
    %% 触发成就
    FriendList = get_friend_on_dict(RoleId),
    {ok, NewPlayer} = lib_achievement_api:add_friend_event(Player, length(FriendList)),
    BinData = lib_chat:make_tv(?MOD_RELA, 1, [BeAskName]),
    lib_server_send:send_to_uid(RoleId, BinData),

    RelaRoleInfo = make_up_friend_info(NewOneRela, BeAskId),
    notify_client_rela_update(?RELA_UPDATE_ADD, RoleId, ?RELA_LIST_TYPE_FRIEND, [RelaRoleInfo]),

    %% 触发任务
    % lib_task_api:add_friend(Player),
    %% 日志
    lib_log_api:log_rela(RoleId, BeAskId, PreRela#rela.rela_type, ?BE_ADD_FRIEND, NewRelaType),
    {ok, NewPlayer}.

%% 直接添加好友(不走申请流程)
do_add_firend_directly(Player, RoleId, BeAskId) ->
    CheckList = [{friend_num_limit, RoleId}, {check_rela_type, RoleId, BeAskId}],
    case lib_relationship:check_list(CheckList) of
        {false, Code} -> skip;
        true -> %% 满足添加好友条件
            RelaList = get_rela_on_dict(RoleId),
            FriendAskList = get_friend_ask_list(RoleId),
            Time = utime:unixtime(),
            PreRela = ulists:keyfind(BeAskId, #rela.other_rid, RelaList, #rela{role_id = RoleId, other_rid = BeAskId}),
            NewRelaType = rela_type_change(PreRela#rela.rela_type, ?RELA_TYPE_FRIEND, add_friend),
            NewOneRela = make_record(rela, [RoleId, BeAskId, NewRelaType, 0, 0, Time]),
            NewRelaList = lists:keystore(BeAskId, #rela.other_rid, RelaList, NewOneRela),
            NewFriendAskList = lists:keydelete(BeAskId, #friend_ask.ask_id, FriendAskList),
            db_rela_insert(RoleId, BeAskId, NewRelaType, Time),
            db_del_friend_ask_by_asker_id(RoleId, BeAskId),
            save_rela_on_dict(RoleId, NewRelaList),
            save_friend_ask_on_dict(RoleId, NewFriendAskList),
            AskPid = misc:get_player_process(BeAskId),
            case misc:is_process_alive(AskPid) of
                true -> %% 好友请求者在线跳到请求玩家进程处理
                    #ets_role_show{figure = #figure{name = RoleName}} = lib_role:get_role_show(RoleId),
                    lib_player:apply_cast(BeAskId, ?APPLY_CAST_SAVE, lib_relationship, receive_friend_ask_reply, [BeAskId, RoleId, RoleName, Time]);
                false -> %% 玩家不在线直接操作数据库
                    case get_rela_with_other_from_db(BeAskId, RoleId) of
                        #rela{rela_type = PreRelaType1} ->
                            %% 如果对方之前有发好友请求过来要删掉
                            db_del_friend_ask_by_asker_id(BeAskId, RoleId),
                            NewRelaType1 = rela_type_change(PreRelaType1, ?RELA_TYPE_FRIEND, add_friend),
                            db_rela_insert(BeAskId, RoleId, NewRelaType1, Time);
                        _ ->
                            PreRelaType1 = ?RELA_TYPE_NONE,
                            NewRelaType1 = ?RELA_TYPE_FRIEND,
                            db_rela_insert(BeAskId, RoleId, ?RELA_TYPE_FRIEND, Time)
                    end,
                    %% 日志
                    lib_log_api:log_rela(BeAskId, RoleId, PreRelaType1, ?BE_ADD_FRIEND, NewRelaType1)
            end,
            %% 日志
            lib_log_api:log_rela(RoleId, BeAskId, PreRela#rela.rela_type, ?ADD_FRIEND, NewRelaType),
            RelaRoleInfo = make_up_friend_info(NewOneRela, BeAskId),
            notify_client_rela_update(?RELA_UPDATE_ADD, RoleId, ?RELA_LIST_TYPE_FRIEND, [RelaRoleInfo]),
            Code = ?SUCCESS
    end,
    pp_relationship:send_error(RoleId, Code),
    %% 触发成就
    FriendList = lib_relationship:get_friend_on_dict(RoleId),
    {ok, NewPlayer} = lib_achievement_api:add_friend_event(Player, length(FriendList)),
    {ok, NewPlayer}.

%% A拉黑B要同时把A向B以及B向A发送的好友请求删除
pull_black(RoleId, RoleName, BePullBlackId) ->
    CheckList = [{black_list_num_limit, RoleId}, {is_same_server, RoleId}],
    case check_list(CheckList) of
        true ->
            RelaList = get_rela_on_dict(RoleId),
            PreRela = case lists:keyfind(BePullBlackId, #rela.other_rid, RelaList) of
                #rela{} = PreRelaTmp -> PreRelaTmp;
                _ -> #rela{role_id = RoleId, other_rid = BePullBlackId, rela_type = 0}
            end,
            case lists:member(PreRela#rela.rela_type, ?RELA_BLACK_TYPES) of
                false ->
                    %% 删除好友请求
                    case get_friend_ask_on_dict(RoleId) of
                        [] -> skip;
                        CurFriendAskList ->
                            db_del_friend_ask_by_asker_id(RoleId, BePullBlackId),
                            NewFriendAskList = lists:keydelete(BePullBlackId, #friend_ask.ask_id, CurFriendAskList),
                            save_friend_ask_on_dict(RoleId, NewFriendAskList)
                    end,
                    Unixtime = utime:unixtime(),
                    NewRelaType = rela_type_change(PreRela#rela.rela_type, ?RELA_TYPE_BLACK, pull_black),
                    db:execute(io_lib:format(?sql_save_role_rela, [RoleId, BePullBlackId, NewRelaType, 0, 0, Unixtime])),
                    NewOneRela = PreRela#rela{rela_type = NewRelaType, intimacy = 0, last_chat_time = 0, ctime = Unixtime},
                    NewRelaList = lists:keystore(BePullBlackId, #rela.other_rid, RelaList, NewOneRela),
                    %% 保存好友列表到玩家的进程字典中
                    save_rela_on_dict(RoleId, NewRelaList),

                    %% 日志
                    lib_log_api:log_rela(RoleId, BePullBlackId, PreRela#rela.rela_type, ?ADD_BLACK, NewRelaType),

                    RelaRoleInfo = make_up_friend_info(NewOneRela, BePullBlackId),
                    notify_client_rela_update(?RELA_UPDATE_ADD, RoleId, ?RELA_LIST_TYPE_BLACK, [RelaRoleInfo]),
                    notify_client_rela_update(?RELA_UPDATE_REMOVE, RoleId, ?RELA_LIST_TYPE_FRIEND, [BePullBlackId]),

                    BePullBlackPid = misc:get_player_process(BePullBlackId),
                    case misc:is_process_alive(BePullBlackPid) of
                        true -> %% 被拉黑玩家在线跳到玩家进程处理
                            lib_player:apply_cast(BePullBlackPid, ?APPLY_CAST, lib_relationship, be_pull_black, [BePullBlackId, RoleId, RoleName]);
                        false -> %% 玩家不在线直接操作数据库
                            case get_rela_with_other_from_db(BePullBlackId, RoleId) of
                                #rela{rela_type = RelaType1}->
                                    NewRelaType1 = rela_type_change(RelaType1, ?RELA_TYPE_NONE, be_pull_black),
                                    %% 日志
                                    lib_log_api:log_rela(BePullBlackId, RoleId, RelaType1, ?BE_ADD_BLACK, NewRelaType1),
                                    case NewRelaType1 =/= ?RELA_TYPE_NONE of
                                        true ->
                                            db:execute(io_lib:format(?sql_save_role_rela, [BePullBlackId, RoleId, NewRelaType1, 0, 0, Unixtime]));
                                        false ->
                                            db:execute(io_lib:format(?sql_del_role_rela, [BePullBlackId, RoleId]))
                                    end;
                                _ -> skip
                            end
                    end,
                    ?SUCCESS;
                true -> %% 已经拉黑的不能重复操作
                    ?ERRCODE(err140_9_exist_rela)
            end;
        {false, Code} -> Code
    end.

%% 通知玩家被拉黑(被拉黑玩家所在进程)
%% PullBlackId执行拉黑操作的玩家id
%% PullBlackName执行拉黑操作的玩家名字
be_pull_black(RoleId, PullBlackId, PullBlackName) ->
    %% 如果对方之前有发好友请求过来要删掉
    case get_friend_ask_on_dict(RoleId) of
        [] -> skip;
        CurFriendAskList ->
            case lists:keyfind(PullBlackId, #friend_ask.ask_id, CurFriendAskList) of
                Ask when is_record(Ask, friend_ask) ->
                    db_del_friend_ask_by_asker_id(RoleId, PullBlackId),
                    NewFriendAskList = lists:keydelete(PullBlackId, #friend_ask.ask_id, CurFriendAskList),
                    save_friend_ask_on_dict(RoleId, NewFriendAskList),
                    BinData = lib_chat:make_tv(?MOD_RELA, 2, [PullBlackName]),
                    lib_server_send:send_to_uid(RoleId, BinData);
                _ -> skip
            end
    end,
    RelaList = get_rela_on_dict(RoleId),
    PreRela = case lists:keyfind(PullBlackId, #rela.other_rid, RelaList) of
        #rela{} = PreRelaTmp -> PreRelaTmp;
        _ -> #rela{role_id = RoleId, other_rid = PullBlackId, rela_type = 0}
    end,
    NewRelaType = rela_type_change(PreRela#rela.rela_type, ?RELA_TYPE_NONE, be_pull_black),

    case NewRelaType =/= ?RELA_TYPE_NONE of
        true -> %% 两玩家之前还有其他关系则更新关系否则删除
            Unixtime = utime:unixtime(),
            db:execute(io_lib:format(?sql_save_role_rela, [RoleId, PullBlackId, NewRelaType, 0, 0, Unixtime])),
            NewOneRela = PreRela#rela{rela_type = NewRelaType, intimacy = 0, last_chat_time = 0, ctime = Unixtime},
            NewRelaList = lists:keystore(PullBlackId, #rela.other_rid, RelaList, NewOneRela),
            %% 保存好友列表到玩家的进程字典中
            save_rela_on_dict(RoleId, NewRelaList);
        false ->
            db:execute(io_lib:format(?sql_del_role_rela, [RoleId, PullBlackId])),
            NewRelaList = lists:keydelete(PullBlackId, #rela.other_rid, RelaList),
            %% 保存好友列表到玩家的进程字典中
            save_rela_on_dict(RoleId, NewRelaList)
    end,

    notify_client_rela_update(?RELA_UPDATE_REMOVE, RoleId, ?RELA_LIST_TYPE_FRIEND, [PullBlackId]),

    %% 日志
    lib_log_api:log_rela(RoleId, PullBlackId, PreRela#rela.rela_type, ?BE_ADD_BLACK, NewRelaType).

%% 删除好友
del_friend(RoleId, BeDelId) ->
    RelaList = get_rela_on_dict(RoleId),
    PreRela = case lists:keyfind(BeDelId, #rela.other_rid, RelaList) of
        #rela{} = PreRelaTmp -> PreRelaTmp;
        _ -> #rela{role_id = RoleId, other_rid = BeDelId, rela_type = 0}
    end,
    case lists:member(PreRela#rela.rela_type, ?RELA_FRIEND_TYPES) of
        true ->
            NewRelaType = rela_type_change(PreRela#rela.rela_type, ?RELA_TYPE_NONE, del_friend),
            case NewRelaType > 0 of
                true -> %% 两玩家之前还有其他关系则更新关系否则删除
                    db:execute(io_lib:format(?sql_save_role_rela, [RoleId, BeDelId, NewRelaType, 0, 0, PreRela#rela.ctime])),
                    NewOneRela = PreRela#rela{rela_type = NewRelaType, intimacy = 0, last_chat_time = 0},
                    NewRelaList = lists:keystore(BeDelId, #rela.other_rid, RelaList, NewOneRela),
                    %% 保存好友列表到玩家的进程字典中
                    save_rela_on_dict(RoleId, NewRelaList);
                false ->
                    db:execute(io_lib:format(?sql_del_role_rela, [RoleId, BeDelId])),
                    NewRelaList = lists:keydelete(BeDelId, #rela.other_rid, RelaList),
                    %% 保存好友列表到玩家的进程字典中
                    save_rela_on_dict(RoleId, NewRelaList)
            end,

            notify_client_rela_update(?RELA_UPDATE_REMOVE, RoleId, ?RELA_LIST_TYPE_FRIEND, [BeDelId]),
            %% 日志
            lib_log_api:log_rela(RoleId, BeDelId, PreRela#rela.rela_type, ?DEL_FRIEND, NewRelaType),

            BeDelPid = misc:get_player_process(BeDelId),
            case misc:is_process_alive(BeDelPid) of
                true -> %% 被删除玩家在线跳到玩家进程处理
                    lib_player:apply_cast(BeDelId, ?APPLY_CAST, lib_relationship, be_del_friend_by_other, [BeDelId, RoleId]);
                false -> %% 玩家不在线直接操作数据库
                    case get_rela_with_other_from_db(BeDelId, RoleId) of
                        #rela{rela_type = RelaType1} = PreRela1 ->
                            NewRelaType1 = rela_type_change(RelaType1, ?RELA_TYPE_NONE, del_friend),
                            %% 日志
                            lib_log_api:log_rela(BeDelId, RoleId, RelaType1, ?BE_DEL_FRIEND, NewRelaType1),
                            case NewRelaType1 =/= ?RELA_TYPE_NONE of
                                true ->
                                    db:execute(io_lib:format(?sql_save_role_rela, [BeDelId, RoleId, NewRelaType1, 0, 0, PreRela1#rela.ctime]));
                                false ->
                                    db:execute(io_lib:format(?sql_del_role_rela, [BeDelId, RoleId]))
                            end;
                        _ -> skip
                    end
            end,
            ?SUCCESS;
        false -> %% 非好友操作失败
            ?ERRCODE(err140_6_not_friend)
    end.

%% 删除好友告知被删除方处理
be_del_friend_by_other(RoleId, OtherRid) ->
    RelaList = get_rela_on_dict(RoleId),
    PreRela = case lists:keyfind(OtherRid, #rela.other_rid, RelaList) of
        #rela{} = PreRelaTmp -> PreRelaTmp;
        _ -> #rela{role_id = RoleId, other_rid = OtherRid, rela_type = 0}
    end,
    case lists:member(PreRela#rela.rela_type, ?RELA_FRIEND_TYPES) of
        true ->
            NewRelaType = rela_type_change(PreRela#rela.rela_type, ?RELA_TYPE_NONE, del_friend),

            notify_client_rela_update(?RELA_UPDATE_REMOVE, RoleId, ?RELA_LIST_TYPE_FRIEND, [OtherRid]),
            %% 日志
            lib_log_api:log_rela(RoleId, OtherRid, PreRela#rela.rela_type, ?BE_DEL_FRIEND, NewRelaType),
            case NewRelaType > 0 of
                true -> %% 两玩家之前还有其他关系则更新关系否则删除
                    db:execute(io_lib:format(?sql_save_role_rela, [RoleId, OtherRid, NewRelaType, 0, 0, PreRela#rela.ctime])),
                    NewOneRela = PreRela#rela{rela_type = NewRelaType, intimacy = 0, last_chat_time = 0},
                    NewRelaList = lists:keystore(OtherRid, #rela.other_rid, RelaList, NewOneRela),
                    %% 保存好友列表到玩家的进程字典中
                    save_rela_on_dict(RoleId, NewRelaList);
                false ->
                    db:execute(io_lib:format(?sql_del_role_rela, [RoleId, OtherRid])),
                    NewRelaList = lists:keydelete(OtherRid, #rela.other_rid, RelaList),
                    %% 保存好友列表到玩家的进程字典中
                    save_rela_on_dict(RoleId, NewRelaList)
            end;
        false -> %% 非好友操作失败
            skip
    end.

%% 从黑名单中删除
del_from_black_list(RoleId, BeCtrlId) ->
    RelaList = get_rela_on_dict(RoleId),
    PreRela = case lists:keyfind(BeCtrlId, #rela.other_rid, RelaList) of
        #rela{} = PreRelaTmp -> PreRelaTmp;
        _ -> #rela{role_id = RoleId, other_rid = BeCtrlId, rela_type = 0}
    end,
    case lists:member(PreRela#rela.rela_type, ?RELA_BLACK_TYPES) of
        true ->
            Unixtime = utime:unixtime(),
            NewRelaType = rela_type_change(PreRela#rela.rela_type, ?RELA_TYPE_NONE, del_from_black_list),
            case NewRelaType =/= ?RELA_TYPE_NONE of
                true -> %% 两玩家之前还有其他关系则更新关系否则删除
                    db:execute(io_lib:format(?sql_save_role_rela, [RoleId, BeCtrlId, NewRelaType, 0, 0, Unixtime])),
                    NewOneRela = PreRela#rela{rela_type = NewRelaType, intimacy = 0, last_chat_time = 0, ctime = Unixtime},
                    NewRelaList = lists:keystore(BeCtrlId, #rela.other_rid, RelaList, NewOneRela),
                    save_rela_on_dict(RoleId, NewRelaList);
                false ->
                    db:execute(io_lib:format(?sql_del_role_rela, [RoleId, BeCtrlId])),
                    NewRelaList = lists:keydelete(BeCtrlId, #rela.other_rid, RelaList),
                    save_rela_on_dict(RoleId, NewRelaList)
            end,
            %% 日志
            lib_log_api:log_rela(RoleId, BeCtrlId, PreRela#rela.rela_type, ?DEL_BLACK, NewRelaType),
            notify_client_rela_update(?RELA_UPDATE_REMOVE, RoleId, ?RELA_LIST_TYPE_BLACK, [BeCtrlId]),
            ?SUCCESS;
        false -> %% 不在黑名单
            ?ERRCODE(err140_7_not_exist_by_type)
    end.

%% 增加仇人
%% 检测是否是本服的玩家
add_enemy(RoleId, EnemyId) ->
    SerId = config:get_server_id(),
    case mod_player_create:get_real_serid_by_id(EnemyId) of
        SerId -> %% 非本服的玩家直接跳过
            do_add_enemy(RoleId, EnemyId);
        _ -> skip
    end.

do_add_enemy(RoleId, EnemyId) ->
    RelaList = get_rela_on_dict(RoleId),
    PreRela = case lists:keyfind(EnemyId, #rela.other_rid, RelaList) of
        #rela{} = PreRelaTmp -> PreRelaTmp;
        _ -> #rela{role_id = RoleId, other_rid = EnemyId, rela_type = 0}
    end,
    case lists:member(PreRela#rela.rela_type, ?RELA_ENEMY_TYPES) of
        false ->
            %% 如果仇人超过上限要把前面的顶掉
            EnemyRelaList = [OneRela || OneRela <- RelaList, lists:member(OneRela#rela.rela_type, ?RELA_ENEMY_TYPES) == true],
            NewRelaListTmp = case length(EnemyRelaList) >= ?ENEMY_NUM_LIMIT of
                true ->
                    [NeedDelEnemyRela|_] = lists:keysort(#rela.ctime, EnemyRelaList),
                    NeedDelEnemyNewRelaType = rela_type_change(NeedDelEnemyRela#rela.rela_type, ?RELA_TYPE_NONE, del_from_enemies),
                    %% 日志
                    lib_log_api:log_rela(RoleId, NeedDelEnemyRela#rela.other_rid, NeedDelEnemyRela#rela.rela_type, ?DEL_ENEMY, NeedDelEnemyNewRelaType),
                    db:execute(io_lib:format(?sql_save_role_rela,
                        [RoleId, NeedDelEnemyRela#rela.other_rid, NeedDelEnemyNewRelaType, NeedDelEnemyRela#rela.intimacy, NeedDelEnemyRela#rela.last_chat_time, NeedDelEnemyRela#rela.ctime])),
                    NewNeedDelEnemyRela = NeedDelEnemyRela#rela{rela_type = NeedDelEnemyNewRelaType},
                    lists:keystore(NeedDelEnemyRela#rela.other_rid, #rela.other_rid, RelaList, NewNeedDelEnemyRela);
                false -> RelaList
            end,
            NewRelaType = rela_type_change(PreRela#rela.rela_type, ?RELA_TYPE_ENEMY, add_enemy),
            AddTime = ?IF(PreRela#rela.ctime > 0, PreRela#rela.ctime, utime:unixtime()),
            db:execute(io_lib:format(?sql_save_role_rela, [RoleId, EnemyId, NewRelaType, PreRela#rela.intimacy, PreRela#rela.last_chat_time, AddTime])),
            NewOneRela = PreRela#rela{rela_type = NewRelaType},
            NewRelaList = lists:keystore(EnemyId, #rela.other_rid, NewRelaListTmp, NewOneRela),
            %% 保存好友列表到玩家的进程字典中
            save_rela_on_dict(RoleId, NewRelaList),
            %% 日志
            lib_log_api:log_rela(RoleId, EnemyId, PreRela#rela.rela_type, ?ADD_ENEMY, NewRelaType),
            RelaRoleInfo = make_up_friend_info(NewOneRela, EnemyId),
            notify_client_rela_update(?RELA_UPDATE_ADD, RoleId, ?RELA_LIST_TYPE_ENEMY, [RelaRoleInfo]),
            ?SUCCESS;
        true -> %% 已经是仇人跳过
            skip
    end.

%% 从仇人列表中删除
del_from_enemies(RoleId, BeCtrlId) ->
    RelaList = get_rela_on_dict(RoleId),
    PreRela = case lists:keyfind(BeCtrlId, #rela.other_rid, RelaList) of
        #rela{} = PreRelaTmp -> PreRelaTmp;
        _ -> #rela{role_id = RoleId, other_rid = BeCtrlId, rela_type = 0}
    end,
    case lists:member(PreRela#rela.rela_type, ?RELA_ENEMY_TYPES) of
        true ->
            NewRelaType = rela_type_change(PreRela#rela.rela_type, ?RELA_TYPE_NONE, del_from_enemies),
            case NewRelaType =/= ?RELA_TYPE_NONE of
                true -> %% 两玩家之前还有其他关系则更新关系否则删除
                    db:execute(io_lib:format(?sql_save_role_rela, [RoleId, BeCtrlId, NewRelaType, 0, 0, PreRela#rela.ctime])),
                    NewOneRela = PreRela#rela{rela_type = NewRelaType, intimacy = 0, last_chat_time = 0},
                    NewRelaList = lists:keystore(BeCtrlId, #rela.other_rid, RelaList, NewOneRela),
                    save_rela_on_dict(RoleId, NewRelaList);
                false ->
                    db:execute(io_lib:format(?sql_del_role_rela, [RoleId, BeCtrlId])),
                    NewRelaList = lists:keydelete(BeCtrlId, #rela.other_rid, RelaList),
                    save_rela_on_dict(RoleId, NewRelaList)
            end,
            %% 日志
            lib_log_api:log_rela(RoleId, BeCtrlId, PreRela#rela.rela_type, ?DEL_ENEMY, NewRelaType),
            notify_client_rela_update(?RELA_UPDATE_REMOVE, RoleId, ?RELA_LIST_TYPE_ENEMY, [BeCtrlId]),
            ?SUCCESS;
        false -> %% 不在仇人列表
            ?ERRCODE(err140_7_not_exist_by_type)
    end.

%% 批量回复好友请求
reply_add_friend_ask(Player, ?REPLY_TYPE_AGREE) ->
    #player_status{id = RoleId, figure = Figure} = Player,
    #figure{name = RoleName} = Figure,
    CurFriendAskList = get_friend_ask_on_dict(RoleId),
    HasSortList = lists:keysort(#friend_ask.time, CurFriendAskList),
    AskIds = [AskId || #friend_ask{ask_id = AskId} <- HasSortList],
    CurRelaList = get_rela_on_dict(RoleId),
    Unixtime = utime:unixtime(),
    FriendNum = length(get_friend_on_dict(RoleId)),
    {NewRelaList, NewFriendAskList} =
        agree_add_friend_ask(AskIds, CurRelaList, CurFriendAskList, RoleId, RoleName, FriendNum, Unixtime),
    save_rela_on_dict(RoleId, NewRelaList),
    save_friend_ask_on_dict(RoleId, NewFriendAskList);
reply_add_friend_ask(Player, ?REPLY_TYPE_REFUSE) ->
    #player_status{id = RoleId, figure = Figure} = Player,
    #figure{name = RoleName} = Figure,
    FriendAskList = get_friend_ask_on_dict(RoleId),
    db_del_one_role_all_friend_ask(RoleId),
    BinData = lib_chat:make_tv(?MOD_RELA, 2, [RoleName]),
    F = fun(OneAsk) ->
        %% 通知被拒绝的玩家
        lib_server_send:send_to_uid(OneAsk#friend_ask.ask_id, BinData)
    end,
    [F(OneAsk) || OneAsk <- FriendAskList],
    save_friend_ask_on_dict(RoleId, []);
reply_add_friend_ask(_, _) -> ok.

%% 回复单个玩家的好友请求
reply_one_add_friend_ask(AskId, RoleId, RoleName, ResponseType) ->
    FriendAskList = get_friend_ask_on_dict(RoleId),
    case lists:keyfind(AskId, #friend_ask.ask_id, FriendAskList) of
        #friend_ask{} -> %% 请求存在
            do_reply_one_add_friend_ask(AskId, RoleId, RoleName, FriendAskList, ResponseType);
        _ ->
            ?FAIL
    end.

do_reply_one_add_friend_ask(AskId, RoleId, RoleName, _FriendAskList, ?REPLY_TYPE_PULL_BLACK) ->
    pull_black(RoleId, RoleName, AskId);
do_reply_one_add_friend_ask(AskId, RoleId, RoleName, FriendAskList, ?REPLY_TYPE_AGREE) ->
    CheckList = [{friend_num_limit, RoleId}, {check_rela_type, RoleId, AskId}],
    case check_list(CheckList) of
        true ->
            Unixtime = utime:unixtime(),
            RelaList = get_rela_on_dict(RoleId),
            case lists:keyfind(AskId, #rela.other_rid, RelaList) of
                #rela{rela_type = RelaType} = PreRela ->
                    InBlackList = lists:member(RelaType, ?RELA_BLACK_TYPES),
                    InFriendList = lists:member(RelaType, ?RELA_FRIEND_TYPES),
                    if
                        InBlackList == true ->
                            ?ERRCODE(err140_25_in_blacklist);
                        InFriendList == true ->
                            ?ERRCODE(err140_4_is_friend);
                        true ->
                            {NewRelaList, NewFriendAskList} = do_agree_add_friend_ask(RoleId, AskId, PreRela, RelaList, FriendAskList, RoleName, Unixtime),
                            save_rela_on_dict(RoleId, NewRelaList),
                            save_friend_ask_on_dict(RoleId, NewFriendAskList),
                            ?SUCCESS
                    end;
                _ -> %% 不存在关系
                    {NewRelaList, NewFriendAskList} = do_agree_add_friend_ask(RoleId, AskId, #rela{role_id = RoleId, other_rid = AskId}, RelaList, FriendAskList, RoleName, Unixtime),
                    save_rela_on_dict(RoleId, NewRelaList),
                    save_friend_ask_on_dict(RoleId, NewFriendAskList),
                    ?SUCCESS
            end;
        {false, Code} -> Code
    end;
do_reply_one_add_friend_ask(AskId, RoleId, RoleName, FriendAskList, ?REPLY_TYPE_REFUSE) ->
    db_del_friend_ask_by_asker_id(RoleId, AskId),
    NewFriendAskList = lists:keydelete(AskId, #friend_ask.ask_id, FriendAskList),
    save_friend_ask_on_dict(RoleId, NewFriendAskList),
    %% 通知被拒绝的玩家
    BinData = lib_chat:make_tv(?MOD_RELA, 2, [RoleName]),
    lib_server_send:send_to_uid(AskId, BinData),
    ?SUCCESS;
do_reply_one_add_friend_ask(_, _, _, _, _) -> ?FAIL.

%% 处理好友上下线通知
role_change_online_status(RoleId, Figure, OnlineFlag) ->
    TimeStamp = utime:unixtime(),
    %% 因为有仇人这种单方面的关系需要提醒所以需要从数据库里面查询需要通知的玩家
    List = db:get_all(io_lib:format(?sql_select_rela_data_by_rela,
        [RoleId, util:link_list([?RELA_TYPE_FRIEND, ?RELA_TYPE_ENEMY, ?RELA_TYPE_FRIEND_AND_ENEMY, ?RELA_TYPE_BLACK_AND_ENEMY])])),
    F = fun(OneId, RelaType) ->
        TipsRelaType = case RelaType of
            ?RELA_TYPE_FRIEND_AND_ENEMY -> ?RELA_TYPE_ENEMY;
            ?RELA_TYPE_BLACK_AND_ENEMY -> ?RELA_TYPE_ENEMY;
            _ -> RelaType
        end,
        {ok, BinData} = pt_140:write(14009, [RoleId, Figure#figure.name, TipsRelaType, OnlineFlag, TimeStamp]),
        lib_server_send:send_to_uid(OneId, BinData)
    end,
    [F(OneId, OneRelaType) || [OneId, OneRelaType] <- List].

%% 同时更新好友双方的最后聊天时间
update_last_ctime_each_one(RoleId, OtherRid, Time) ->
    update_last_chat_time(RoleId, OtherRid, Time),
    update_last_chat_time(OtherRid, RoleId, Time).

%% 更新最后聊天时间，玩家在线，则更新dict
update_last_chat_time(RoleId, OtherRid, Time) ->
    Pid = misc:get_player_process(RoleId),
    case misc:is_process_alive(Pid) of
        true ->
            case is_self_pid(RoleId) of
                true ->
                    do_update_last_chat_time(RoleId, OtherRid, Time);
                false ->
                    lib_player:apply_cast(RoleId, ?APPLY_CAST, ?MODULE, update_last_chat_time, [RoleId, OtherRid, Time])
            end;
        false -> skip
    end.

do_update_last_chat_time(RoleId, OtherRid, Time) ->
    RelaList = get_rela_on_dict(RoleId),
    case lists:keyfind(OtherRid, #rela.other_rid, RelaList) of
        #rela{rela_type = RelaType, last_chat_utime = LastChatUTime} = PreRela
            when RelaType == ?RELA_TYPE_FRIEND orelse RelaType == ?RELA_TYPE_FRIEND_AND_ENEMY ->
            case Time - LastChatUTime >= 120 of %% 定时更新一次最后聊天时间
                true ->
                    spawn(fun() ->
                        db:execute(io_lib:format(?sql_update_last_chat_time, [Time, RoleId, OtherRid, OtherRid, RoleId]))
                    end),
                    NewLastChatUTime = Time;
                false ->
                    NewLastChatUTime = LastChatUTime
            end,
            NewRela = PreRela#rela{last_chat_time = Time, last_chat_utime = NewLastChatUTime},
            NewRelaList = lists:keystore(OtherRid, #rela.other_rid, RelaList, NewRela),
            save_rela_on_dict(RoleId, NewRelaList);
        _ -> skip
    end.

trigger_intimacy_add([], _, _, _, _) -> skip;
trigger_intimacy_add(RoleL, Intimacy, ObtainType, SubType, Extra) ->
    OnlineRoleL = [RoleId || RoleId <- RoleL, lib_player:is_online_global(RoleId)],
    do_trigger_intimacy_add(OnlineRoleL, Intimacy, ObtainType, SubType, Extra).

do_trigger_intimacy_add([], _, _, _, _) -> skip;
do_trigger_intimacy_add([T|L], Intimacy, ObtainType, SubType, Extra) ->
    do_trigger_intimacy_add_core(T, L, Intimacy, ObtainType, SubType, Extra),
    do_trigger_intimacy_add(L, Intimacy, ObtainType, SubType, Extra).

do_trigger_intimacy_add_core(_RoleId, [], _, _, _, _) -> ok;
do_trigger_intimacy_add_core(RoleId, [OtherRid|L], Intimacy, ObtainType, SubType, Extra) ->
    F1 = fun() ->
        mod_daily:increment(RoleId, ?MOD_RELA, ObtainType, SubType)
    end,
    F2 = fun() ->
        mod_daily:increment(OtherRid, ?MOD_RELA, ObtainType, SubType)
    end,
    F = fun() ->
        update_intimacy(RoleId, OtherRid, Intimacy, ObtainType, SubType, Extra, F1),
        update_intimacy(OtherRid, RoleId, Intimacy, ObtainType, SubType, Extra, F2)
    end,
    catch db:transaction(F),
    do_trigger_intimacy_add_core(RoleId, L, Intimacy, ObtainType, SubType, Extra).

%% 同时更新好友双方的亲密度
update_intimacy_each_one(RoleId, OtherRid, Intimacy, ObtainType, Extra) ->
    F = fun() ->
        update_intimacy(RoleId, OtherRid, Intimacy, ObtainType, 0, Extra, []),
        update_intimacy(OtherRid, RoleId, Intimacy, ObtainType, 0, Extra, [])
    end,
    catch db:transaction(F).

%% 更新亲密度，玩家在线，则更新dict，不在线则直接操作数据库
update_intimacy(_RoleId, _OtherRid, 0, _ObtainType, _SubType, _Extra, _CallBack) -> skip; %% 变化为0不处理
update_intimacy(RoleId, OtherRid, Intimacy, ObtainType, SubType, Extra, CallBack) ->
    Pid = misc:get_player_process(RoleId),
    case misc:is_process_alive(Pid) of
        true ->
            case is_self_pid(RoleId) of
                true ->
                    RelaList = get_rela_on_dict(RoleId),
                    case lists:keyfind(OtherRid, #rela.other_rid, RelaList) of
                        #rela{rela_type = RelaType, intimacy = OldIntimacy} = PreRela
                            when RelaType == ?RELA_TYPE_FRIEND orelse RelaType == ?RELA_TYPE_FRIEND_AND_ENEMY ->
                            case data_rela:get_intimacy_obtain_cfg(ObtainType) of
                                #intimacy_obtain_cfg{times = TimesLim} ->
                                    HasTriggerTimes = mod_daily:get_count(RoleId, ?MOD_RELA, ObtainType, SubType),
                                    CanAdd = ?IF(TimesLim > HasTriggerTimes, true, false);
                                _ -> CanAdd = true
                            end,
                            case CanAdd of
                                true ->
                                    NewIntimacy = max(0, OldIntimacy + Intimacy),
                                    NewRela = PreRela#rela{intimacy = NewIntimacy},
                                    NewRelaList = lists:keystore(OtherRid, #rela.other_rid, RelaList, NewRela),
                                    save_rela_on_dict(RoleId, NewRelaList),
                                    %% 日志
                                    lib_log_api:log_intimacy(RoleId, OtherRid, OldIntimacy, ObtainType, OldIntimacy + Intimacy, Extra),
                                    notify_intimacy(RoleId, OtherRid, NewIntimacy),
                                    db_update_intimacy(RoleId, OtherRid, NewIntimacy),
                                    case is_function(CallBack) of
                                        true -> CallBack();
                                        false -> skip
                                    end;
                                false -> skip
                            end;
                        _ -> skip
                    end;
                false ->
                    lib_player:apply_cast(RoleId, ?APPLY_CAST, ?MODULE, update_intimacy, [RoleId, OtherRid, Intimacy, ObtainType, SubType, Extra, CallBack])
            end;
        false ->
            case data_rela:get_intimacy_obtain_cfg(ObtainType) of
                #intimacy_obtain_cfg{} -> %% 触发类型加的亲密度 离线玩家不加
                    skip;
                _ ->
                    case get_rela_with_other_from_db(RoleId, OtherRid) of
                        false -> skip;
                        #rela{role_id = RoleId, other_rid = OtherRid, rela_type = RelaType, intimacy = OldIntimacy}
                            when RelaType == ?RELA_TYPE_FRIEND orelse RelaType == ?RELA_TYPE_FRIEND_AND_ENEMY ->
                            lib_log_api:log_intimacy(RoleId, OtherRid, OldIntimacy, ObtainType, OldIntimacy + Intimacy, Extra),
                            db_update_intimacy(RoleId, OtherRid, max(0, OldIntimacy + Intimacy))
                    end
            end
    end.

clear_intimacy_each_one(RoleId, OtherRid, Extra) ->
    F = fun() ->
        clear_intimacy(RoleId, OtherRid, Extra),
        clear_intimacy(OtherRid, RoleId, Extra)
    end,
    catch db:transaction(F).

clear_intimacy(RoleId, OtherRid, Extra) ->
    Pid = misc:get_player_process(RoleId),
    case misc:is_process_alive(Pid) of
        true ->
            case is_self_pid(RoleId) of
                true ->
                    RelaList = get_rela_on_dict(RoleId),
                    case lists:keyfind(OtherRid, #rela.other_rid, RelaList) of
                        #rela{rela_type = RelaType, intimacy = OldIntimacy} = PreRela
                            when RelaType == ?RELA_TYPE_FRIEND orelse RelaType == ?RELA_TYPE_FRIEND_AND_ENEMY ->
                                NewIntimacy = 0,
                                NewRela = PreRela#rela{intimacy = NewIntimacy},
                                NewRelaList = lists:keystore(OtherRid, #rela.other_rid, RelaList, NewRela),
                                save_rela_on_dict(RoleId, NewRelaList),
                                %% 日志
                                ?PRINT("clear_intimacy SUCC1 ~n", []),
                                lib_log_api:log_intimacy(RoleId, OtherRid, OldIntimacy, 0, 0, Extra),
                                notify_intimacy(RoleId, OtherRid, NewIntimacy),
                                db_update_intimacy(RoleId, OtherRid, NewIntimacy);
                        _ -> skip
                    end;
                false ->
                    lib_player:apply_cast(RoleId, ?APPLY_CAST, ?MODULE, clear_intimacy, [RoleId, OtherRid, Extra])
            end;
        false ->
            case get_rela_with_other_from_db(RoleId, OtherRid) of
                false -> skip;
                #rela{role_id = RoleId, other_rid = OtherRid, rela_type = RelaType, intimacy = OldIntimacy}
                    when RelaType == ?RELA_TYPE_FRIEND orelse RelaType == ?RELA_TYPE_FRIEND_AND_ENEMY ->
                    lib_log_api:log_intimacy(RoleId, OtherRid, OldIntimacy, 0, 0, Extra),
                    ?PRINT("clear_intimacy SUCC2 ~n", []),
                    db_update_intimacy(RoleId, OtherRid, 0)
            end
    end.

%% 通知客户端好友列表更新
notify_client_rela_update(?RELA_UPDATE_ADD, RoleId, RelaListType, UpdateL) when ?RELA_UPDATE_SWITCH == 1 ->
    Args = [{RelaListType, UpdateL}],
    {ok, BinData} = pt_140:write(14013, [Args]),
    lib_server_send:send_to_uid(RoleId, BinData);
notify_client_rela_update(?RELA_UPDATE_REMOVE, RoleId, RelaListType, UpdateL) when ?RELA_UPDATE_SWITCH == 1 ->
    Args = [{RelaListType, UpdateL}],
    {ok, BinData} = pt_140:write(14014, [Args]),
    lib_server_send:send_to_uid(RoleId, BinData);
notify_client_rela_update(_, _, _, _) -> skip.

%% 通知亲密度更新
notify_intimacy(FromId, ToId, Intimacy) ->
    {ok, BinData} = pt_140:write(14015, [ToId, Intimacy]),
    lib_server_send:send_to_uid(FromId, BinData),
    ok.

%% 关系转换
rela_type_change(PreRelaType, CurRelaType, CtrlType) ->
    if
        PreRelaType == ?RELA_TYPE_ENEMY andalso CtrlType == add_friend ->
            ?RELA_TYPE_FRIEND_AND_ENEMY;
        PreRelaType == ?RELA_TYPE_ENEMY andalso CtrlType == pull_black ->
            ?RELA_TYPE_BLACK_AND_ENEMY;
        PreRelaType == ?RELA_TYPE_FRIEND_AND_ENEMY andalso CtrlType == pull_black ->
            ?RELA_TYPE_BLACK_AND_ENEMY;
        PreRelaType == ?RELA_TYPE_ENEMY andalso CtrlType == pull_black ->
            ?RELA_TYPE_BLACK_AND_ENEMY;
        PreRelaType == ?RELA_TYPE_ENEMY andalso CtrlType == be_pull_black ->
            ?RELA_TYPE_BLACK_AND_ENEMY;
        PreRelaType == ?RELA_TYPE_FRIEND_AND_ENEMY andalso CtrlType == be_pull_black ->
            ?RELA_TYPE_BLACK_AND_ENEMY;
        PreRelaType == ?RELA_TYPE_BLACK_AND_ENEMY andalso CtrlType == del_from_black_list ->
            ?RELA_TYPE_ENEMY;
        PreRelaType == ?RELA_TYPE_FRIEND_AND_ENEMY andalso CtrlType == del_friend ->
            ?RELA_TYPE_ENEMY;
        PreRelaType == ?RELA_TYPE_FRIEND_AND_ENEMY andalso CtrlType == del_from_enemies ->
            ?RELA_TYPE_FRIEND;
        PreRelaType == ?RELA_TYPE_BLACK_AND_ENEMY andalso CtrlType == del_from_enemies ->
            ?RELA_TYPE_BLACK;
        PreRelaType == ?RELA_TYPE_BLACK andalso CtrlType == add_enemy ->
            ?RELA_TYPE_BLACK_AND_ENEMY;
        PreRelaType == ?RELA_TYPE_FRIEND andalso CtrlType == add_enemy ->
            ?RELA_TYPE_FRIEND_AND_ENEMY;
        PreRelaType == ?RELA_TYPE_BLACK andalso CtrlType == be_pull_black ->
            ?RELA_TYPE_BLACK;
        true -> CurRelaType
    end.

%% 获取好友亲密度加的属性
%% (如果这个属性需要实时变化需要在更新亲密度接口出发事件通知玩家)
%% 返回[{属性,值}]
get_intimacy_attr(RoleId, OtherRid) ->
    #rela{intimacy = Intimacy} = get_rela_with_other_from_db(RoleId, OtherRid),
    data_relationship:get_intimacy_attr(Intimacy).

%% 是否玩家自身进程
is_self_pid(RoleId) ->
    Pid = misc:get_player_process(RoleId),
    Pid =:= self().

%% 保存好友列表到玩家的进程字典中
save_rela_on_dict(RoleId, RelaList) ->
    case is_self_pid(RoleId) of
        true ->
            case put(?RELAS_KEY, RelaList) of
                undefined -> RelaList;
                _ -> RelaList
            end;
        false ->
            []
    end.

%% 获取进程字典中的好友列表信息
get_rela_on_dict(RoleId) ->
    case is_self_pid(RoleId) of
        true ->
            case get(?RELAS_KEY) of
                undefined ->
                    get_rela_on_db(RoleId);
                Value ->
                    Value
            end;
        false ->
            []
    end.

get_rela_on_db(RoleId) ->
    RelaList = case db_rela_select_by_role_id(RoleId) of
        List when List =/= [] ->
            [make_record(rela, T) || T <- List];
        _ -> []
    end,
    save_rela_on_dict(RoleId, RelaList).

get_rela_on_db_2(RoleId) ->
    RelaList = case db_rela_select_by_role_id(RoleId) of
        List when List =/= [] ->
            [make_record(rela, T) || T <- List];
        _ -> []
    end,
    RelaList.

get_friend_ask_on_dict(RoleId) ->
    case is_self_pid(RoleId) of
        true ->
            case get(?FRIEND_ASK_LIST) of
                undefined ->
                    get_friend_ask_by_role_id_on_db(RoleId);
                Value ->
                    Value
            end;
        false ->
            []
    end.

get_friend_ask_by_role_id_on_db(RoleId) ->
    FriendAskList = case db_get_friend_ask_by_role_id(RoleId) of
        List when List =/= [] ->
            [make_record(friend_ask, T) || T <- List];
        _ -> []
    end,
    save_friend_ask_on_dict(RoleId, FriendAskList).

save_friend_ask_on_dict(RoleId, FriendAskList) ->
    case is_self_pid(RoleId) of
        true ->
            case put(?FRIEND_ASK_LIST, FriendAskList) of
                undefined -> FriendAskList;
                _ -> FriendAskList
            end;
        false ->
            []
    end.

check_list([]) -> true;
check_list([H|T]) ->
    case check(H) of
        true -> check_list(T);
        {false, Res} -> {false, Res}
    end.

check({add_self, RoleId, BeAskId}) ->
    ?IF(RoleId == BeAskId, {false, ?ERRCODE(err140_5_not_reply_myself_ask)}, true);
check({friend_num_limit, RoleId}) ->
    RelaList = get_friend_on_dict(RoleId),
    case length(RelaList) < ?FRIEND_NUM_LIMIT of
        true -> true;
        false -> {false, ?ERRCODE(err140_1_myself_friend_num_limit)}
    end;
check({black_list_num_limit, RoleId}) ->
    RelaList = get_relas_by_types_on_dict(RoleId, ?RELA_BLACK_TYPES),
    case length(RelaList) < ?BLACK_LIST_NUM_LIMIT of
        true -> true;
        false -> {false, ?ERRCODE(err140_27_myself_black_list_num_limit)}
    end;
check({check_rela_type, RoleId, BeAskId}) ->
    case get_rela_with_other_on_dict(RoleId, BeAskId) of
        #rela{rela_type = RelaType} ->
            IsFriend = lists:member(RelaType, ?RELA_FRIEND_TYPES),
            IsBlack = lists:member(RelaType, ?RELA_BLACK_TYPES),
            if
                IsFriend == true ->
                    {false, ?ERRCODE(err140_4_is_friend)};
                IsBlack == true ->
                    {false, ?ERRCODE(err140_25_in_blacklist)};
                true -> true
            end;
        false -> true
    end;
check({other_side_online, BeAskId}) ->
    case lib_role:get_role_show(BeAskId) of
        #ets_role_show{online_flag = ?ONLINE_ON} -> true;
        _ -> {false, ?ERRCODE(err140_14_not_online)}
    end;
check({is_no_black, BeAskId, RoleId}) ->
    case is_black(BeAskId, RoleId) of
        true -> {false, ?ERRCODE(err140_28_in_another_blacklist)};
        false -> true
    end;
check({is_same_server, RoleId}) ->
    case lib_role:get_role_show(RoleId) of
        #ets_role_show{} -> true;
        _ -> {false, ?ERRCODE(err140_29_not_same_server_player)}
    end;
check(_) ->
    {false, ?FAIL}.

%% ---------------- 数据库 ----------------------

db_rela_select_by_role_id(RoleId) ->
    db:get_all(io_lib:format(?sql_rela_select_by_role_id, [RoleId])).

%% 保存玩家关系
db_rela_insert(RoleId, OtherRid, RelaType, Unixtime) ->
    Sql = io_lib:format(?sql_save_role_rela, [RoleId, OtherRid, RelaType, 0, 0, Unixtime]),
    db:execute(Sql).

%% 获取玩家的所有好友请求
db_get_friend_ask_by_role_id(RoleId) ->
    db:execute(io_lib:format(?sql_del_out_time_friend_ask_by_role_id, [?FRIEND_ASK_VAILD_TIME, RoleId])),
    Sql = io_lib:format(?sql_get_friend_ask_by_role_id, [RoleId]),
    db:get_all(Sql).

%% 数据库添加新的好友请求
db_add_friend_ask(RoleId, AskId, Time) ->
    Sql = io_lib:format(?sql_add_friend_ask, [RoleId, AskId, Time]),
    db:execute(Sql).

%% 数据库删除好友请求
db_del_friend_ask_by_asker_id(RoleId, AskId) ->
    Sql = io_lib:format(?db_del_friend_ask_by_asker_id, [RoleId, AskId]),
    db:execute(Sql).

%% 数据库删除好友请求
db_del_one_role_all_friend_ask(RoleId) ->
    Sql = io_lib:format(?db_del_one_role_all_friend_ask, [RoleId]),
    db:execute(Sql).

%% 更新亲密度
db_update_intimacy(RoleId, OtherRid, Intimacy) ->
    Sql = io_lib:format(?sql_update_intimacy, [Intimacy, RoleId, OtherRid]),
    db:execute(Sql).

%% ----------------------- 旧接口(要优化以及去掉的) --------------------------
get_rela_and_intimacy_online(RoleId, IdList) ->
    RelaList = get_rela_on_dict(RoleId),
    F = fun(TmpRoleId) ->
        case lists:keyfind(TmpRoleId, #rela.other_rid, RelaList) of
            false -> {TmpRoleId, ?RELA_TYPE_NONE, 0};
            #rela{rela_type = RelaType, intimacy = Intimacy} -> {TmpRoleId, RelaType, Intimacy}
        end
    end,
    lists:map(F, IdList).

get_rela_and_intimacy_offline(RoleId, IdList) ->
    RelaList = get_rela_on_db(RoleId),
    F = fun(TmpRoleId) ->
        case lists:keyfind(TmpRoleId, #rela.other_rid, RelaList) of
            false -> {TmpRoleId, ?RELA_TYPE_NONE, 0};
            #rela{rela_type = RelaType, intimacy = Intimacy} -> {TmpRoleId, RelaType, Intimacy}
        end
    end,
    lists:map(F, IdList).

%% 获得ID列表的关系和亲密度
get_rela_and_intimacy(RoleId, IdList) ->
    case is_self_pid(RoleId) of
        true ->
            get_rela_and_intimacy_online(RoleId, IdList);
        _ ->
            Pid = misc:get_player_process(RoleId),
            case misc:is_process_alive(Pid) of
                true ->
                    case catch lib_player:apply_call(RoleId, ?APPLY_CALL, lib_relationship, get_rela_and_intimacy_online, [RoleId, IdList]) of
                        Res when is_list(Res) ->
                            Res;
                        _ ->
                            get_rela_and_intimacy_offline(RoleId, IdList)
                    end;
                false ->
                    get_rela_and_intimacy_offline(RoleId, IdList)
            end
    end.
