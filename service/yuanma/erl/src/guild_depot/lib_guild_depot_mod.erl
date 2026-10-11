%%-----------------------------------------------------------------------------
%% @Module  :       lib_guild_depot_mod
%% @Author  :       Czc
%% @Email   :       389853407@qq.com
%% @Created :       2017-09-18
%% @Description:
%%-----------------------------------------------------------------------------
-module(lib_guild_depot_mod).

-include("guild.hrl").
-include("goods.hrl").
-include("def_id_create.hrl").
-include("errcode.hrl").
-include("sql_guild.hrl").
-include("common.hrl").
-include("predefine.hrl").
-include("def_goods.hrl").
-include("def_module.hrl").
-include("figure.hrl").

-export([
    send_guild_depot_info/2
    , send_auto_destroy_setting/1
    , add_to_depot/3
    , exchange_depot_goods/4
    , exchange_excg_task_goods/4
    , exchange_special_goods/4
    , destory_depot_goods/4
    ]).

send_guild_depot_info(RoleId, GuildId) ->
    GuildMember = lib_guild_data:get_guild_member_by_role_id(RoleId),
    if
        is_record(GuildMember, guild_member) == false -> skip;
        true ->
            #guild_depot{
                depot_goods = DepotGoods,
                depot_record = DepotRecord
            } = lib_guild_depot_data:get_guild_depot(GuildId),
            DepotRecordPackList = lib_guild_depot:pack_depot_record(DepotRecord),
            DepotGoodsPackList = lib_guild_depot:pack_depot_goods_list(DepotGoods),
            lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, lib_guild_depot, send_guild_depot_info, [GuildMember#guild_member.depot_score, DepotRecordPackList, DepotGoodsPackList])
    end.

%% 自动清理设定值
send_auto_destroy_setting(RoleId) ->
    #guild_member{guild_id = GuildId} = lib_guild_data:get_guild_member_by_role_id(RoleId),
    #guild_depot{auto_destroy = {Stage, Color, Star}} = lib_guild_depot_data:get_guild_depot(GuildId),
    lib_server_send:send_to_uid(RoleId, pt_401, 40110, [Stage, Color, Star]).

%% 捐献物品到帮派仓库
%% @param GoodsInfoL :: [{#goods{}, Num},...]
add_to_depot(RoleId, _RoleName, GoodsInfoL) ->
    % 获取公会仓库物品
    #guild_member{
        guild_id = GuildId
    } = GuildMember = lib_guild_data:get_guild_member_by_role_id(RoleId),
    #guild_depot{
        depot_goods = DepotGoodsList
    } = GuildDepot = lib_guild_depot_data:get_guild_depot(GuildId),

    % 获取仓库容量信息
    MaxSize = data_guild_m:get_config(default_depot_cell),
    DepotSize = length(DepotGoodsList),
    DonateSize = lists:sum([Num || {_, Num} <- GoodsInfoL]),
    ClearSize = length(lib_guild_depot_data:get_filter_depot_goods(GuildDepot)),

    % 判断仓库容量情况
    if
        DepotSize + DonateSize =< MaxSize -> % 直接存入
            add_to_depot_core(GoodsInfoL, GuildMember);
        DepotSize + DonateSize - ClearSize =< MaxSize -> % 先自动清理再存入
            auto_destroy(RoleId, "", ?GUILD_DEPOT_CTRL_AUTO_DESTORY, GuildDepot), % 名字为空指代自动销毁
            add_to_depot_core(GoodsInfoL, GuildMember);
        true -> % 容量不足
            ErrCode = ?ERRCODE(err401_not_in_depot),
            lib_server_send:send_to_uid(RoleId, pt_401, 40100, [ErrCode])
    end,
    ok.

%% @param GoodsInfoL :: [{#goods{}, Num},...]
add_to_depot_core(GoodsInfoL, GuildMember) ->
    % 获取公会成员信息和仓库信息
    #guild_member{
        id = RoleId,
        figure = #figure{name = RoleName},
        guild_id = GuildId,
        depot_score = DepotScore
    } = GuildMember,
    #guild_depot{
        depot_goods = DepotGoodsList,
        depot_record = DepotRecordList
    } = GuildDepot = lib_guild_depot_data:get_guild_depot(GuildId),

    % 通知玩家进程删除物品
    DeleteL = [{UId, Num} || {#goods{id = UId}, Num} <- GoodsInfoL],
    lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, lib_goods_api, delete_more_by_list, [DeleteL, depot_donate]),

    % 构造新增仓库物品列表和记录列表
    NewDepotGoods = lib_guild_depot:make_records(depot_goods, [GuildId, GoodsInfoL]),
    NewDepotRecords = lib_guild_depot:make_records(depot_record, [RoleName, GoodsInfoL]),

    % 计算新的仓库积分;记录日志
    NewDepotScore = lib_guild_depot_data:log_guild_depot(RoleId, NewDepotGoods, DepotScore),

    % 新仓库物品,积分入库
    lib_guild_depot_data:db_guild_depot_goods_insert(NewDepotGoods),
    DepotScore /= NewDepotScore andalso lib_guild_depot_data:db_guild_member_depot_score_update(RoleId, NewDepotScore),

    % 更新公会仓库内存数据
    NewDepotGoodsList = NewDepotGoods ++ DepotGoodsList,
    NewDepotRecordList = lists:sublist(NewDepotRecords ++ DepotRecordList, ?DEPOT_RECORD_MAX_LEN),
    NewRecordLen = min(?DEPOT_RECORD_SHOW_LEN, length(NewDepotRecordList)),
    NewGuildDepot = GuildDepot#guild_depot{
        depot_goods = NewDepotGoodsList,
        depot_record = NewDepotRecordList,
        record_len = NewRecordLen
    },
    lib_guild_depot_data:save_guild_depot(GuildId, NewGuildDepot),

    % 更新公会玩家内存数据
    NewGuildMember = GuildMember#guild_member{depot_score = NewDepotScore},
    lib_guild_data:update_guild_member(NewGuildMember),

    % 事件触发
    handle_event(add_to_depot, [NewGuildMember, NewDepotGoods, NewDepotRecords]),
    ok.

%% 兑换任务装备
exchange_excg_task_goods(RoleId, _RoleName, GoodsTypeId, Num) ->
    GuildMember = lib_guild_data:get_guild_member_by_role_id(RoleId),
    ErrorCode =
    if
        is_record(GuildMember, guild_member) == false -> ?ERRCODE(err400_not_join_guild);
        true ->
            #guild_member{guild_id = _GuildId, depot_score = DepotScore} = GuildMember,
            #ets_goods_type{color = _Color} = data_goods_type:get(GoodsTypeId),
            % case data_equip:get_equip_attr_cfg(GoodsTypeId) of
            %     #equip_attr_cfg{stage = Stage, star = Star} ->
            %         [{_, ScoreCost}] = data_guild_depot:get_depot_goods_score(Stage, Star, Color),
            %         DepotScoreCost = ScoreCost;
            %     _ ->
            %         DepotScoreCost = 0
            % end,
            DepotScoreCost = 5000, % 任务装备物品兑换积分写死5000
            NewDepotScore = DepotScore - DepotScoreCost,
            case NewDepotScore >= 0 of
                true ->
                    db:execute(io_lib:format(?sql_guild_member_update_depot_score, [NewDepotScore, RoleId])),
                    % 日志
                    lib_log_api:log_guild_depot(RoleId, ?GUILD_DEPOT_CTRL_EXCHANGE, 0, GoodsTypeId, DepotScore, NewDepotScore),

                    % 更新玩家积分
                    case NewDepotScore =/= DepotScore of
                        true ->
                            NewGuildMember = GuildMember#guild_member{depot_score = NewDepotScore},
                            lib_guild_data:update_guild_member(NewGuildMember);
                        false -> skip
                    end,

                    % 物品发送
                    RewardList = [{?TYPE_GOODS, GoodsTypeId, Num}],
                    RewardList1 = lib_goods_util:goods_to_bind_goods(RewardList),
                    Produce = #produce{reward = RewardList1, type = guild_depot_exchange},
                    lib_goods_api:send_reward_with_mail(RoleId, Produce),

                    % 事件触发
                    TmpDepotGoods = #depot_goods{goods_id = GoodsTypeId, num = Num},
                    handle_event('exchange_depot_goods', [GuildMember, TmpDepotGoods, Num, #depot_record{}]),

                    %% 通知客户端更新仓库物品的数量
                    {ok, BinData} = pt_401:write(40106, [[{?GUILD_DEPOT_TASK_EQUIP, 0}]]),
                    lib_server_send:send_to_uid(RoleId, BinData),

                    {ok, BinData2} = pt_401:write(40103, [?SUCCESS, NewDepotScore]),
                    lib_server_send:send_to_uid(RoleId, BinData2),
                    ok;
                false ->
                    ?ERRCODE(err401_depot_score_not_enough)
            end
    end,
    case ErrorCode of
        ok -> skip;
        _ -> lib_server_send:send_to_uid(RoleId, pt_401, 40103, [ErrorCode, 0])
    end.

%% 兑换特定道具(如经验道具)
exchange_special_goods(RoleId, RoleName, GoodsTypeId, Num) ->
    GuildMember = lib_guild_data:get_guild_member_by_role_id(RoleId),
    ErrorCode = if
        is_record(GuildMember, guild_member) == false -> ?ERRCODE(err400_not_join_guild);
        true ->
            #guild_member{guild_id = GuildId, depot_score = DepotScore} = GuildMember,
            GuildDepotMap = lib_guild_depot_data:get_depot_map(),
            GuildDepot = maps:get(GuildId, GuildDepotMap, #guild_depot{}),
            #guild_depot{depot_record = DepotRecordList, record_len = RecordLen} = GuildDepot,
            NowTime = utime:unixtime(),
            NewDepotScore = DepotScore - ?DEPOT_EXP_EXCHANGE_SCORE * Num,
            case NewDepotScore >= 0 of
                true ->
                    db:execute(io_lib:format(?sql_guild_member_update_depot_score, [NewDepotScore, RoleId])),
                    %% 日志
                    lib_log_api:log_guild_depot(RoleId, ?GUILD_DEPOT_CTRL_EXCHANGE, 0, GoodsTypeId, DepotScore, NewDepotScore),
                    DepotRecordAutoId = lib_guild_depot_data:get_depot_record_new_id(),
                    #ets_goods_type{color = Color} = data_goods_type:get(GoodsTypeId),
                    MakeRecordAges = [DepotRecordAutoId, RoleName, ?GUILD_DEPOT_CTRL_EXCHANGE, DepotRecordAutoId, GoodsTypeId, Num, Color, 0, 0, [], [], NowTime],
                    NewAddDepotRecord = lib_guild_depot:make_depot_record(MakeRecordAges),
                    case RecordLen + 1 >= ?DEPOT_RECORD_MAX_LEN of
                        true ->
                            NewDepotRecordList = lists:sublist([NewAddDepotRecord|DepotRecordList], ?DEPOT_RECORD_SHOW_LEN),
                            NewRecordLen = ?DEPOT_RECORD_SHOW_LEN;
                        _ ->
                            NewDepotRecordList = [NewAddDepotRecord|DepotRecordList],
                            NewRecordLen = RecordLen + 1
                    end,
                    NewGuildDepot = GuildDepot#guild_depot{
                                        depot_record = NewDepotRecordList,
                                        record_len = NewRecordLen
                                    },
                    NewGuildDepotMap = maps:put(GuildId, NewGuildDepot, GuildDepotMap),
                    lib_guild_depot_data:save_depot_map(NewGuildDepotMap),

                    %% 更新玩家的仓库积分
                    case NewDepotScore =/= DepotScore of
                        true ->
                            NewGuildMember = GuildMember#guild_member{depot_score = NewDepotScore},
                            lib_guild_data:update_guild_member(NewGuildMember);
                        false -> skip
                    end,

                    send_depot_exchange_goods(RoleId, GoodsTypeId, Num),

                    DepotRecordPackList = lib_guild_depot:pack_depot_record([NewAddDepotRecord]),
                    {ok, BinData1} = pt_401:write(40107, [DepotRecordPackList]),
                    lib_server_send:send_to_uid(RoleId, BinData1),

                    {ok, BinData2} = pt_401:write(40103, [?SUCCESS, NewDepotScore]),
                    lib_server_send:send_to_uid(RoleId, BinData2),
                    ok;
                false -> ?ERRCODE(err401_depot_score_not_enough)
            end
    end,
    case is_integer(ErrorCode) of
        true ->
            {ok, BinData3} = pt_401:write(40100, [ErrorCode]),
            lib_server_send:send_to_uid(RoleId, BinData3);
        false -> skip
    end.

%% 从公会仓库兑换物品
exchange_depot_goods(RoleId, RoleName, DepotGoodsId, Num) ->
    GuildMember = lib_guild_data:get_guild_member_by_role_id(RoleId),
    ErrorCode = if
        is_record(GuildMember, guild_member) == false -> ?ERRCODE(err400_not_join_guild);
        true ->
            #guild_member{guild_id = GuildId, depot_score = DepotScore} = GuildMember,
            GuildDepotMap = lib_guild_depot_data:get_depot_map(),
            GuildDepot = maps:get(GuildId, GuildDepotMap, #guild_depot{}),
            #guild_depot{depot_goods = DepotGoodsList, depot_record = DepotRecordList, record_len = RecordLen} = GuildDepot,
            OneDepotGoods = lists:keyfind(DepotGoodsId, #depot_goods.id, DepotGoodsList),
            if
                OneDepotGoods == false -> ?ERRCODE(err401_goods_not_in_depot);
                true ->
                    #depot_goods{
                        id = Id, goods_id = GoodsId, num = RemainNum, color = Color, rating = Rating, overall_rating = OverallRating,
                        addition = Addition, extra_attr = ExtraAttr
                    } = OneDepotGoods,
                    case RemainNum >= Num of
                        true ->
                            NowTime = utime:unixtime(),
                            DepotScoreCost = case data_equip:get_equip_attr_cfg(GoodsId) of
                                #equip_attr_cfg{stage = Stage, star = Star} ->
                                    [{_, ScoreCost}] = data_guild_depot:get_depot_goods_score(Stage, Star, Color), ScoreCost;
                                _ -> 0
                            end,
                            NewDepotScore = DepotScore - DepotScoreCost,
                            NewRemainNum = max(0, RemainNum - Num),
                            case NewDepotScore >= 0 of
                                true ->
                                    F = fun() ->
                                        case NewRemainNum > 0 of
                                            true ->
                                                db:execute(io_lib:format(?sql_update_guild_depot_goods_num,
                                                    [NewRemainNum, DepotGoodsId]));
                                            false ->
                                                db:execute(io_lib:format(?sql_delete_guild_depot_goods,
                                                    [DepotGoodsId]))
                                        end,
                                        db:execute(io_lib:format(?sql_guild_member_update_depot_score,
                                            [NewDepotScore, RoleId])),
                                        ok
                                    end,
                                    case catch db:transaction(F) of
                                        ok ->
                                            %% 日志
                                            lib_log_api:log_guild_depot(RoleId, ?GUILD_DEPOT_CTRL_EXCHANGE, DepotGoodsId, GoodsId, DepotScore, NewDepotScore),
                                            DepotRecordAutoId = lib_guild_depot_data:get_depot_record_new_id(),
                                            MakeRecordAges = [DepotRecordAutoId, RoleName, ?GUILD_DEPOT_CTRL_EXCHANGE, Id, GoodsId, Num, Color, Rating, OverallRating, Addition, ExtraAttr, NowTime],
                                            NewAddDepotRecord = lib_guild_depot:make_depot_record(MakeRecordAges),
                                            NewDepotGoodsList = case NewRemainNum > 0 of
                                                true ->
                                                    lists:keystore(DepotGoodsId, #depot_goods.id, DepotGoodsList, OneDepotGoods#depot_goods{num = NewRemainNum});
                                                false ->
                                                    lists:keydelete(DepotGoodsId, #depot_goods.id, DepotGoodsList)
                                            end,
                                            case RecordLen + 1 >= ?DEPOT_RECORD_MAX_LEN of
                                                true ->
                                                    NewDepotRecordList = lists:sublist([NewAddDepotRecord|DepotRecordList], ?DEPOT_RECORD_SHOW_LEN),
                                                    NewRecordLen = ?DEPOT_RECORD_SHOW_LEN;
                                                _ ->
                                                    NewDepotRecordList = [NewAddDepotRecord|DepotRecordList],
                                                    NewRecordLen = RecordLen + 1
                                            end,
                                            NewGuildDepot = GuildDepot#guild_depot{
                                                                depot_goods = NewDepotGoodsList,
                                                                depot_record = NewDepotRecordList,
                                                                record_len = NewRecordLen
                                            },
                                            NewGuildDepotMap = maps:put(GuildId, NewGuildDepot, GuildDepotMap),
                                            lib_guild_depot_data:save_depot_map(NewGuildDepotMap),

                                            %% 更新玩家的仓库积分
                                            case NewDepotScore =/= DepotScore of
                                                true ->
                                                    NewGuildMember = GuildMember#guild_member{depot_score = NewDepotScore},
                                                    lib_guild_data:update_guild_member(NewGuildMember);
                                                false -> skip
                                            end,

                                            send_depot_exchange_goods(RoleId, OneDepotGoods, Num),

                                            handle_event('exchange_depot_goods', [GuildMember, OneDepotGoods, Num, NewAddDepotRecord]),

                                            %% 通知客户端更新仓库物品的数量
                                            {ok, BinData} = pt_401:write(40106, [[{DepotGoodsId, NewRemainNum}]]),
                                            lib_server_send:send_to_uid(RoleId, BinData),

                                            %% 通知公会所有人员，仓库更新
                                            {ok, Bin40108} = pt_401:write(40108, [1]),
                                            lib_server_send:send_to_guild(GuildId, Bin40108),

                                            DepotRecordPackList = lib_guild_depot:pack_depot_record([NewAddDepotRecord]),
                                            {ok, BinData1} = pt_401:write(40107, [DepotRecordPackList]),
                                            lib_server_send:send_to_uid(RoleId, BinData1),

                                            {ok, BinData2} = pt_401:write(40103, [?SUCCESS, NewDepotScore]),
                                            lib_server_send:send_to_uid(RoleId, BinData2),
                                            ok;
                                        Error ->
                                            ?ERR("exchange_depot_goods:~p~n", [Error]),
                                            ?FAIL
                                    end;
                                false -> ?ERRCODE(err401_depot_score_not_enough)
                            end;
                        false -> ?ERRCODE(err401_exchange_num_err)
                    end
            end
    end,
    case is_integer(ErrorCode) of
        true ->
            lib_server_send:send_to_uid(RoleId, pt_401, 40103, [ErrorCode, 0]);
        false -> skip
    end.

check_destory_ids_is_vaild([], _DepotGoodsList) -> ok;
check_destory_ids_is_vaild([OneId|DestoryIds], DepotGoodsList) ->
    case lists:keyfind(OneId, #depot_goods.id, DepotGoodsList) of
        OneDepotGoods when is_record(OneDepotGoods, depot_goods) ->
            check_destory_ids_is_vaild(DestoryIds, DepotGoodsList);
        _ -> {false, ?ERRCODE(err401_goods_not_in_depot)}
    end.

check_destory_depot_goods(RoleId, OpType, DestoryIds) ->
    GuildMember = lib_guild_data:get_guild_member_by_role_id(RoleId),
    if
        is_record(GuildMember, guild_member) == false -> {false, ?ERRCODE(err400_not_join_guild)};
        true ->
            #guild_member{guild_id = GuildId, position = Position} = GuildMember,
            PermissionList = lib_guild_mod:get_position_permission_list(GuildId, Position),
            HasPermission = lists:member(?PERMISSION_MANAGE_DEPOT, PermissionList),
            if
                OpType == ?GUILD_DEPOT_CTRL_DESTORY, not HasPermission -> {false, ?ERRCODE(err401_no_permission_to_destory)};
                true ->
                    GuildDepotMap = lib_guild_depot_data:get_depot_map(),
                    GuildDepot = maps:get(GuildId, GuildDepotMap, #guild_depot{}),
                    #guild_depot{depot_goods = DepotGoodsList} = GuildDepot,
                    case check_destory_ids_is_vaild(DestoryIds, DepotGoodsList) of
                        ok -> {ok, GuildId, GuildMember};
                        {false, ErrorCode} -> {false, ErrorCode}
                    end
            end
    end.

%% 自动销毁仓库物品
auto_destroy(RoleId, RoleName, OpType, GuildDepot) ->
    Setting = GuildDepot#guild_depot.auto_destroy,
    TargetGoods = lib_guild_depot_data:get_filter_depot_goods(GuildDepot, Setting),
    DestoryIds = [Id || #depot_goods{id = Id} <- TargetGoods],
    destory_depot_goods(RoleId, RoleName,OpType, DestoryIds).

%% 销毁仓库物品
%% @param Setting :: {阶数, 颜色, 星数}
destory_depot_goods(RoleId, RoleName, OpType, {_, _, _} = Setting) ->
    % 获取仓库物品
    #guild_member{guild_id = GuildId} = lib_guild_data:get_guild_member_by_role_id(RoleId),
    GuildDepot = lib_guild_depot_data:get_guild_depot(GuildId),

    % 更新自动清理设置
    NewGuildDepot = GuildDepot#guild_depot{auto_destroy = Setting},
    lib_guild_depot_data:save_guild_depot(GuildId, NewGuildDepot),
    lib_guild_data:db_guild_setting_update(GuildId, ?GUILD_SETTING_DEPOT_AUTO_DESTROY, Setting),

    % 自动销毁
    auto_destroy(RoleId, RoleName, OpType, NewGuildDepot);

destory_depot_goods(RoleId, _RoleName, OpType, []) ->
    lib_server_send:send_to_uid(RoleId, pt_401, 40104, [?SUCCESS, OpType, 0]),
    skip;
destory_depot_goods(RoleId, RoleName, OpType, DestoryIds) ->
    case check_destory_depot_goods(RoleId, OpType, DestoryIds) of
        {ok, GuildId, GuildMember} ->
            db:execute(io_lib:format(?sql_delete_guild_depot_more, [util:link_list(DestoryIds)])),
            NowTime = utime:unixtime(),
            GuildDepotMap = lib_guild_depot_data:get_depot_map(),
            GuildDepot = maps:get(GuildId, GuildDepotMap, #guild_depot{}),
            #guild_depot{depot_goods = DepotGoodsList, depot_record = DepotRecordList, record_len = RecordLen} = GuildDepot,
            {NewDepotGoodsList, AddDepotRecordList} =
                do_destory_depot_goods(DepotGoodsList, [], DestoryIds, [], RoleId, RoleName, GuildMember#guild_member.depot_score, NowTime),
            AddRecordLen = length(AddDepotRecordList),
            case RecordLen + AddRecordLen >= ?DEPOT_RECORD_MAX_LEN of
                true ->
                    NewDepotRecordList = lists:sublist(AddDepotRecordList ++ DepotRecordList, ?DEPOT_RECORD_SHOW_LEN),
                    NewRecordLen = ?DEPOT_RECORD_SHOW_LEN;
                _ ->
                    NewDepotRecordList = AddDepotRecordList ++ DepotRecordList,
                    NewRecordLen = RecordLen + AddRecordLen
            end,
            NewGuildDepot = GuildDepot#guild_depot{
                                depot_goods = NewDepotGoodsList,
                                depot_record = NewDepotRecordList,
                                record_len = NewRecordLen
            },
            NewGuildDepotMap = maps:put(GuildId, NewGuildDepot, GuildDepotMap),
            lib_guild_depot_data:save_depot_map(NewGuildDepotMap),

            %% 通知客户端删除物品
            DelData = [{OneId, 0} || OneId <- DestoryIds],
            {ok, BinData} = pt_401:write(40106, [DelData]),
            lib_server_send:send_to_uid(RoleId, BinData),

            %% 通知公会所有人员，仓库更新
            {ok, Bin40108} = pt_401:write(40108, [1]),
            lib_server_send:send_to_guild(GuildId, Bin40108),

            DepotRecordPackList = lib_guild_depot:pack_depot_record(AddDepotRecordList),
            {ok, BinData1} = pt_401:write(40107, [DepotRecordPackList]),
            lib_server_send:send_to_uid(RoleId, BinData1),

            {ok, BinData2} = pt_401:write(40104, [?SUCCESS, OpType, length(DestoryIds)]),
            lib_server_send:send_to_uid(RoleId, BinData2);
        {false, ErrorCode} ->
            {ok, BinData} = pt_401:write(40104, [ErrorCode, OpType, 0]),
            lib_server_send:send_to_uid(RoleId, BinData)
    end.

do_destory_depot_goods([], DepotRecordList, _, Result, _, _, _, _) -> {Result, DepotRecordList};
do_destory_depot_goods([OneGoods|DepotGoodsList], DepotRecordList, DestoryIds, Result, RoleId, RoleName, DepotScore, NowTime) ->
    #depot_goods{
        id = OneId, goods_id = OneGoodsId, num = OneGoodsNum, color = Color, rating = Rating, overall_rating = OverallRating,
        addition = Addition, extra_attr = ExtraAttr
    } = OneGoods,
    case lists:member(OneId, DestoryIds) of
        true ->
            %% 日志
            lib_log_api:log_guild_depot(RoleId, ?GUILD_DEPOT_CTRL_DESTORY, OneId, OneGoodsId, DepotScore, DepotScore),
            DepotRecordAutoId = lib_guild_depot_data:get_depot_record_new_id(),
            MakeRecordAges = [DepotRecordAutoId, RoleName, ?GUILD_DEPOT_CTRL_DESTORY, OneId, OneGoodsId, OneGoodsNum, Color, Rating, OverallRating, Addition, ExtraAttr, NowTime],
            NewAddDepotRecord = lib_guild_depot:make_depot_record(MakeRecordAges),
            do_destory_depot_goods(DepotGoodsList, [NewAddDepotRecord|DepotRecordList], DestoryIds, Result, RoleId, RoleName, DepotScore, NowTime);
        false ->
            do_destory_depot_goods(DepotGoodsList, DepotRecordList, DestoryIds, Result++[OneGoods], RoleId, RoleName, DepotScore, NowTime)
    end.

send_depot_exchange_goods(RoleId, GoodsTypeId, Num) when is_integer(GoodsTypeId) ->
    Produce = #produce{reward = [{?TYPE_GOODS, GoodsTypeId, Num}], type = guild_depot_exchange},
    lib_goods_api:send_reward_with_mail(RoleId, Produce);
send_depot_exchange_goods(RoleId, ExchanegDepotGoods, Num) ->
    #depot_goods{
        goods_id = GoodsTypeId,
        color = Color,
        addition = Addition,
        extra_attr = ExtraAttr,
        rating = Rating
    } = ExchanegDepotGoods,
    AttrList = [{color, Color}, {addition, Addition}, {extra_attr, ExtraAttr}, {rating, Rating}],
    Reward = [{?TYPE_ATTR_GOODS, GoodsTypeId, Num, AttrList}],
    Produce = #produce{reward = Reward, type = guild_depot_exchange},
    lib_goods_api:send_reward_with_mail(RoleId, Produce).

%% 事件触发

%% 捐赠仓库物品事件
handle_event(add_to_depot, [GuildMember, DepotGoods, DepotRecords]) ->
    #guild_member{
        id = RoleId,
        figure = #figure{name = RoleName},
        guild_id = GuildId,
        depot_score = DepotScore
    } = GuildMember,

    % 任务触发
    Num = lists:sum([N || #depot_goods{num = N} <- DepotGoods]),
    lib_task_api:guild_donate(RoleId, Num),

    % 捐赠玩家反馈
    {ok, BinData2} = pt_401:write(40102, [?SUCCESS, DepotScore]),
    lib_server_send:send_to_uid(RoleId, BinData2),

    % 通知客户端公会仓库增加新物品
    DepotGoodsPackList = lib_guild_depot:pack_depot_goods_list(DepotGoods),
    {ok, BinData} = pt_401:write(40105, [DepotGoodsPackList]),
    lib_server_send:send_to_uid(RoleId, BinData),

    % 通知公会所有人员，仓库更新
    {ok, Bin40108} = pt_401:write(40108, [1]),
    lib_server_send:send_to_guild(GuildId, Bin40108),

    % 仓库记录更新
    DepotRecordPackList = lib_guild_depot:pack_depot_record(DepotRecords),
    {ok, BinData1} = pt_401:write(40107, [DepotRecordPackList]),
    lib_server_send:send_to_uid(RoleId, BinData1),

    % 传闻
    [
        begin
            #depot_goods{
                goods_id = GoodsId,
                rating = Rating,
                extra_attr = ExtraAttr
            } = DepotGood,
            EquipStage = lib_equip_api:get_equip_stage(GoodsId),
            EquipStar = lib_equip_api:get_equip_star(GoodsId),
            [NeedStage, NeedStar] = data_key_value:get(4010001),
            case EquipStage >= NeedStage andalso EquipStar >= NeedStar of
                true ->
                    ExtraAttrStr = util:term_to_string(data_attr:unified_format_extra_attr(ExtraAttr, [])),
                    lib_chat:send_TV({guild, GuildId}, ?MOD_GUILD_DEPOT, 1, [RoleName, EquipStage, EquipStar, GoodsId, Rating, ExtraAttrStr]);
                _ ->
                    skip
            end
        end
     || DepotGood <- DepotGoods
    ],

    ok;

handle_event(exchange_depot_goods, [GuildMember, DepotGoods, _Num, _DepotRecord]) ->
    #guild_member{
        id= RoleId,
        figure = #figure{name = RoleName},
        guild_id = GuildId
    } = GuildMember,
    #depot_goods{
        id = DepotGoodsId,
        goods_id = GoodsId,
        rating = Rating,
        extra_attr = ExtraAttr,
        num = Num
    } = DepotGoods,

    % 任务
    lib_task_api:guild_exchange(RoleId, Num),

    % 传闻
    EquipStage = lib_equip_api:get_equip_stage(GoodsId),
    EquipStar = lib_equip_api:get_equip_star(GoodsId),
    [NeedStage, NeedStar] = data_key_value:get(4010001),

    case DepotGoodsId > 0 andalso EquipStage >= NeedStage andalso EquipStar >= NeedStar of
        true ->
            ExtraAttrStr = util:term_to_string(data_attr:unified_format_extra_attr(ExtraAttr, [])),
            lib_chat:send_TV({guild, GuildId}, ?MOD_GUILD_DEPOT, 2, [RoleName, EquipStage, EquipStar, GoodsId, Rating, ExtraAttrStr]);
        _ ->
            skip
    end,

    ok.