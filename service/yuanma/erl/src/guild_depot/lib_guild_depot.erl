%%-----------------------------------------------------------------------------
%% @Module  :       lib_guild_depot
%% @Author  :       Czc
%% @Email   :       389853407@qq.com
%% @Created :       2017-09-18
%% @Description:
%%-----------------------------------------------------------------------------
-module(lib_guild_depot).

-include("guild.hrl").
-include("sql_guild.hrl").
-include("goods.hrl").
-include("common.hrl").
-include("def_goods.hrl").
-include("predefine.hrl").
-include("server.hrl").
-include("figure.hrl").

-export([
    make_depot_goods/1
    , make_depot_record/1
    , make_records/2
    , init/1
    , send_guild_depot_info/4
    , is_not_finish_guild_depot_excg_task/1
    , get_guild_depot_excg_task_equip_id/1
    , is_allow_add_to_depot/1
    , pack_depot_record/1
    , pack_depot_goods_list/1
    , send_error_code/2
    ]).

% -compile(export_all).

make_record(sql_depot_goods, [Id, GuildId, GoodsTypeId, Num, Color, AdditionBin, ExtraAttrBin, CreateTime]) ->
    case data_goods_type:get(GoodsTypeId) of
        GoodsTypeR when is_record(GoodsTypeR, ets_goods_type) ->
            #ets_goods_type{equip_type = EquipType} = GoodsTypeR,
            Addition = lib_goods_util:to_term(AdditionBin),
            ExtraAttr = lib_goods_util:to_term(ExtraAttrBin),
            EquipRating = case EquipType > 0 of
                true -> %% 装备要计算装备评分
                    lib_equip_api:cal_equip_rating(GoodsTypeR, ExtraAttr);
                false -> 0
            end,
            EquipOverallRating = EquipRating,
            #depot_goods{
                id = Id, guild_id = GuildId, goods_id = GoodsTypeId,
                num = Num, color = Color,
                addition = Addition, extra_attr = ExtraAttr,
                rating = EquipRating, overall_rating = EquipOverallRating,
                create_time = CreateTime
            };
        _ -> %% 没有该物品配置
            #depot_goods{}
    end;
make_record(depot_goods, [Id, GuildId, GoodsTypeId, Num, Color, Rating, OverallRating, Addition, ExtraAttr, CreateTime]) ->
    #depot_goods{
        id = Id, guild_id = GuildId, goods_id = GoodsTypeId,
        num = Num, color = Color,
        addition = Addition, extra_attr = ExtraAttr,
        rating = Rating, overall_rating = OverallRating,
        create_time = CreateTime
    };
make_record(depot_record, [Id, RoleName, Type, GoodsId, GoodsTypeId, Num, Color, Rating, OverallRating, Addition, ExtraAttr, Time]) ->
    #depot_record{
        id = Id, role_name = RoleName, type = Type, color = Color,
        goods_id = GoodsId, type_id = GoodsTypeId, num = Num, rating = Rating, overall_rating = OverallRating,
        addition = Addition, extra_attr = ExtraAttr, time = Time
    }.

make_depot_goods(T) ->
    make_record(depot_goods, T).

make_depot_record(T) ->
    make_record(depot_record, T).

%% @return [#depot_goods{},...]
make_records(depot_goods, [GuildId, GoodsInfoL]) ->
    NowTime = utime:unixtime(),
    [
        begin
            #goods{
                id = DepotGoodsAutoId,
                goods_id = GoodsId,
                color = Color,
                other = GoodsOther
            } = GoodsInfo,
            #goods_other{
                rating = Rating,
                addition = Addition,
                extra_attr = ExtraAttr
            } = GoodsOther,
            Args = [
                DepotGoodsAutoId, GuildId, GoodsId, Num, Color,
                Rating, Rating, Addition, ExtraAttr, NowTime
            ],
            make_depot_goods(Args)
        end
     || {GoodsInfo, Num} <- GoodsInfoL
    ];

%% @return [#depot_record{},...]
make_records(depot_record, [RoleName, GoodsInfoL]) ->
    NowTime = utime:unixtime(),
    [
        begin
            DepotRecordAutoId = lib_guild_depot_data:get_depot_record_new_id(),
            #goods{
                id = DepotGoodsAutoId,
                goods_id = GoodsId,
                color = Color,
                other = GoodsOther
            } = GoodsInfo,
            #goods_other{
                rating = Rating,
                addition = Addition,
                extra_attr = ExtraAttr
            } = GoodsOther,
            Args = [
                DepotRecordAutoId, RoleName, ?GUILD_DEPOT_CTRL_ADD, DepotGoodsAutoId, GoodsId,
                Num, Color, Rating, Rating, Addition,
                ExtraAttr, NowTime
            ],
            make_depot_record(Args)
        end
     || {GoodsInfo, Num} <- GoodsInfoL
    ].

init(GuildIds) ->
    % 仓库物品
    Sql = io_lib:format(?sql_guild_depot_goods_select, []),
    List = db:get_all(Sql),
    DepotGoodsMap = make_depot_goods_map(List, GuildIds, #{}),
    % 仓库清理设置
    Sql2 = io_lib:format(?sql_guild_setting_select, [?GUILD_SETTING_DEPOT_AUTO_DESTROY]),
    List2 = db:get_all(Sql2),
    DepotGoodsMap2 = make_depot_setting_map(List2, DepotGoodsMap),
    lib_guild_depot_data:save_depot_map(DepotGoodsMap2).

%% 初始化仓库物品Map
make_depot_goods_map([], _GuildIds, GuildDepotMap) -> GuildDepotMap;
make_depot_goods_map([T|L], GuildIds, GuildDepotMap) ->
    DepotGoods = make_record(sql_depot_goods, T),
    #depot_goods{guild_id = GuildId} = DepotGoods,
    case lists:member(GuildId, GuildIds) of
        true ->
            GuildDepot = maps:get(GuildId, GuildDepotMap, #guild_depot{}),
            #guild_depot{depot_goods = DepotGoodsList} = GuildDepot,
            NewGuildDepot = GuildDepot#guild_depot{depot_goods = [DepotGoods|DepotGoodsList]},
            NewGuildDepotMap = maps:put(GuildId, NewGuildDepot, GuildDepotMap);
        _ -> NewGuildDepotMap = GuildDepotMap
    end,
    make_depot_goods_map(L, GuildIds, NewGuildDepotMap).

%% 初始化仓库自动清理设置
make_depot_setting_map([], GuildDepotMap) -> GuildDepotMap;
make_depot_setting_map([[GuildId, SettingBin] | T], GuildDepotMap) ->
    Setting = util:bitstring_to_term(SettingBin),
    GuildDepot = maps:get(GuildId, GuildDepotMap, #guild_depot{}),
    NewGuildDepot = GuildDepot#guild_depot{auto_destroy = Setting},
    NewGuildDepotMap = maps:put(GuildId, NewGuildDepot, GuildDepotMap),
    make_depot_setting_map(T, NewGuildDepotMap).

%% 仓库内容请求
send_guild_depot_info(PS, DepotScore, DepotRecordPackList, DepotGoodsPackList) ->
    #player_status{sid = SId} = PS,

    % 根据玩家任务情况插入生成装备
    case is_not_finish_guild_depot_excg_task(PS) of
        true ->
            % 获取评分最低的防装,并按规则生成一个更高级点的装备给玩家做任务兑换
            TaskGTypeId = get_guild_depot_excg_task_equip_id(PS),
            % 40101协议格式
            #ets_goods_type{color = Color} = GoodsTypeR = data_goods_type:get(TaskGTypeId),
            Rating = lib_equip:cal_equip_rating(GoodsTypeR, []),
            DepotGoodsPackList1 = [{?GUILD_DEPOT_TASK_EQUIP, TaskGTypeId, 1, Color, Rating, Rating, [], [], [], [], 0, 0, 0} | DepotGoodsPackList];
        _ ->
            DepotGoodsPackList1 = DepotGoodsPackList
    end,

    lib_server_send:send_to_sid(SId, pt_401, 40101, [DepotScore, DepotRecordPackList, DepotGoodsPackList1]).

%% 是否未完成公会仓库兑换任务
is_not_finish_guild_depot_excg_task(PS) ->
    #player_status{tid = TId} = PS,
    IsReceiveTask = mod_task:is_trigger_task_id(TId, ?GUILD_DEPOT_EXCG_TASK_ID),
    TaskState = mod_task:get_task_finish_state(TId, ?GUILD_DEPOT_EXCG_TASK_ID, lib_task_api:ps2task_args(PS)),
    % IsFinishTask = mod_task:is_finish_task_id(TId, ?GUILD_DEPOT_EXCG_TASK_ID),
    IsReceiveTask andalso (TaskState /= true).

get_guild_depot_excg_task_equip_id(PS) ->
    #player_status{figure = #figure{lv = Lv, career = Career, sex = Sex, turn = Turn}} = PS,
    WorstDefEquip = lib_equip_api:get_worst_defence_equip(PS),
    get_guild_depot_excg_task_equip_id(WorstDefEquip, [Lv, Career, Sex, Turn]).

%% 生成兑换任务装备
%% 注: 当前目标生成装备为玩家可以穿上的橙色一星装备或红色一星装备,阶数不大于五阶
%% @param WorstEquip :: #goods{} | undefined
%% @return GTypeId :: integer()
get_guild_depot_excg_task_equip_id(undefined, [Lv, Career, Sex, Turn]) ->
    GType = ?GOODS_TYPE_EQUIP,
    [GSubType | _] = ?DEFENCE_EQUIP_TYPES,

    % 筛选玩家可以穿的上的装备
    EquipIdL = data_goods_type:get_by_type(GType, GSubType),
    F1 = fun(GTypeId) ->
        #ets_goods_type{
            level = Lv1,
            career = Career1,
            sex = Sex1,
            turn = Turn1,
            color = Color1
        } = _GoodsTypeR = data_goods_type:get(GTypeId),
        {Stage1, Star1} = {lib_equip_api:get_equip_stage(GTypeId), lib_equip_api:get_equip_star(GTypeId)},

        Lv >= Lv1 andalso
        (Career == Career1 orelse Career1 == 0) andalso
        (Sex == Sex1 orelse Sex1 == 0) andalso
        Turn >= Turn1 andalso
        (Color1 == ?ORANGE orelse Color1 == ?RED) andalso
        Stage1 =< 5 andalso
        Star1 == 1
    end,
    CanWearIdL = lists:filter(F1, EquipIdL),

    % 找出最差的装备
    % 对筛选装备按评分排序
    F2 = fun(GTypeId1, GTypeId2) ->
        GoodsTypeR1 = data_goods_type:get(GTypeId1),
        Rating1 = lib_equip:cal_equip_rating(GoodsTypeR1, []),
        GoodsTypeR2 = data_goods_type:get(GTypeId2),
        Rating2 = lib_equip:cal_equip_rating(GoodsTypeR2, []),

        Rating1 < Rating2
    end,
    TaskGTypeId = lists:sort(F2, CanWearIdL), % 找出可兑换装备中评分最高的作为后续兼容

    TaskGTypeId;

get_guild_depot_excg_task_equip_id(WorstEquip, [Lv, Career, Sex, Turn]) ->
    #goods{
        type = GType,
        subtype = GSubType,
        color = _Color,
        other = #goods_other{rating = Rating}
    } = WorstEquip,

    % 筛选玩家可以穿的上的装备
    EquipIdL = data_goods_type:get_by_type(GType, GSubType),
    F1 = fun(GTypeId) ->
        #ets_goods_type{
            level = Lv1,
            career = Career1,
            sex = Sex1,
            turn = Turn1,
            color = Color1
        } = _GoodsTypeR = data_goods_type:get(GTypeId),
        {Stage1, Star1} = {lib_equip_api:get_equip_stage(GTypeId), lib_equip_api:get_equip_star(GTypeId)},

        Lv >= Lv1 andalso
        (Career == Career1 orelse Career1 == 0) andalso
        (Sex == Sex1 orelse Sex1 == 0) andalso
        Turn >= Turn1 andalso
        (Color1 == ?ORANGE orelse Color1 == ?RED) andalso
        Stage1 =< 5 andalso
        Star1 == 1
    end,
    CanWearIdL = lists:filter(F1, EquipIdL),

    % 对筛选装备按评分排序
    F2 = fun(GTypeId1, GTypeId2) ->
        GoodsTypeR1 = data_goods_type:get(GTypeId1),
        Rating1 = lib_equip:cal_equip_rating(GoodsTypeR1, []),
        GoodsTypeR2 = data_goods_type:get(GTypeId2),
        Rating2 = lib_equip:cal_equip_rating(GoodsTypeR2, []),

        Rating1 < Rating2
    end,
    [TmpId | _] = lists:reverse(lists:sort(F2, CanWearIdL)), % 找出可兑换装备中评分最高的作为后续兼容

    % 筛选评分比玩家装备高的
    F3 = fun(GTypeId) ->
        GoodsTypeR = data_goods_type:get(GTypeId),
        Rating1 = lib_equip:cal_equip_rating(GoodsTypeR, []),
        Rating1 > Rating
    end,
    BetterIdL = lists:filter(F3, CanWearIdL),
    [TaskGTypeId | _] = lists:sort(F2, BetterIdL) ++ [TmpId],

    TaskGTypeId.

% test_get_guild_depot_excg_task_equip_id(GTypeId, Lv, Career, Sex, Turn) ->
%     #ets_goods_type{type = GType, subtype = GSubType} = GoodsTypeR = data_goods_type:get(GTypeId),
%     Rating = lib_equip:cal_equip_rating(GoodsTypeR, []),

%     TEquip = #goods{
%         goods_id = GTypeId,
%         type = GType,
%         subtype = GSubType,
%         other = #goods_other{rating = Rating}
%     },
%     get_guild_depot_excg_task_equip_id(TEquip, [Lv, Career, Sex, Turn]).

%% 检测物品是否允许放入帮派仓库
is_allow_add_to_depot(Goods) when is_record(Goods, goods) ->
    AllEquipTypes = [?EQUIP_WEAPON, ?EQUIP_PILEUM, ?EQUIP_NECKLACE,
                    ?EQUIP_CLOTH, ?EQUIP_AMULET, ?EQUIP_TROUSERS,
                    ?EQUIP_BRACELET, ?EQUIP_CUFF, ?EQUIP_RING, ?EQUIP_SHOE],
    #goods{
        goods_id = GoodsId, type = GoodsType, equip_type = EquipType,
        bind = Bind, color = Color, location = Location} = Goods,
    if
        Bind == ?BIND -> false;
        Location =/= ?GOODS_LOC_BAG -> false; %% 只有在背包的物品才能放入帮派仓库
        GoodsType == ?GOODS_TYPE_EQUIP ->
            case lists:member(EquipType, AllEquipTypes) of
                true ->
                    case data_equip:get_equip_attr_cfg(GoodsId) of
                        #equip_attr_cfg{stage = Stage, star = Star}
                            when Stage >= 4 andalso Star >= 1 andalso Color >= ?PURPLE andalso Color =< ?RED -> true;
                        _ -> false
                    end;
                false -> false
            end;
        true -> false
    end;
is_allow_add_to_depot(_) -> false.

pack_depot_record(RecordList) ->
    do_pack_depot_record(RecordList, 0, []).

do_pack_depot_record([], _RecordLen, AccL) -> AccL;
do_pack_depot_record(_, RecordLen, AccL) when RecordLen >= ?DEPOT_RECORD_SHOW_LEN -> AccL;
do_pack_depot_record([T|L], RecordLen, AccL) ->
    case T of
        #depot_record{
            id = Id, role_name = RoleName, type = Type, goods_id = GoodsId, type_id = GoodsTypeId, color = Color, rating = Rating, overall_rating = OverallRating
            , addition = Addition, extra_attr = ExtraAttr, time = Time
        } ->
            FormatExtraAttr = data_attr:unified_format_extra_attr(ExtraAttr, []),
            NewRecordLen = RecordLen + 1,
            NewAccL = [{Id, RoleName, Type, GoodsId, GoodsTypeId, Color, Rating, OverallRating, Addition, FormatExtraAttr, [], [], 0, 0, 0, Time}|AccL];
        _ ->
            NewRecordLen = RecordLen,
            NewAccL = AccL
    end,
    do_pack_depot_record(L, NewRecordLen, NewAccL).

pack_depot_goods_list(DepotGoodsList) ->
    F = fun(DepotGoods, AccList) when is_record(DepotGoods, depot_goods) =:= true ->
            #depot_goods{
                id = GoodsId, goods_id = GoodsTypeId, num = Num,
                color = Color, addition = Addition, extra_attr = ExtraAttr,
                rating = EquipRating, overall_rating = EquipOverallRating
            } = DepotGoods,
            FormatExtraAttr = data_attr:unified_format_extra_attr(ExtraAttr, []),
            T = {GoodsId, GoodsTypeId, Num, Color, EquipRating, EquipOverallRating, Addition, FormatExtraAttr, [], [], 0, 0, 0},
            [T|AccList];
        (_DepotGoods, AccList) -> AccList
    end,
    lists:foldl(F, [], DepotGoodsList).

%% 发送错误码
send_error_code(Sid, ErrorCode) ->
    {ok, BinData} = pt_401:write(40100, [ErrorCode]),
    lib_server_send:send_to_sid(Sid, BinData).
