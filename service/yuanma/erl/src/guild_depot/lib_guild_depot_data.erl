%%-----------------------------------------------------------------------------
%% @Module  :       lib_guild_depot_data
%% @Author  :       Czc
%% @Email   :       389853407@qq.com
%% @Created :       2017-09-18
%% @Description:
%%-----------------------------------------------------------------------------
-module(lib_guild_depot_data).

-include("guild.hrl").
-include("goods.hrl").
-include("sql_guild.hrl").

-export([
    get_depot_map/0
    , save_depot_map/1
    , get_guild_depot/1
    , save_guild_depot/2
    , get_filter_depot_goods/1
    , get_filter_depot_goods/2
    , get_depot_record_new_id/0
    , delete_depot_by_guild_id/1
    , get_donate_record_new_id/0
    , log_guild_depot/3
]).

-export([
    db_guild_depot_goods_delete/1,
    db_guild_depot_goods_insert/1,
    db_guild_member_depot_score_update/2
]).

%% 获得Maps
get_depot_map() -> get(?P_GUILD_DEPOT).

%% 保存Maps
save_depot_map(GuildMap) -> put(?P_GUILD_DEPOT, GuildMap).

%% 获取公会仓库
get_guild_depot(GuildId) ->
    GuildDepotMap = get_depot_map(),
    maps:get(GuildId, GuildDepotMap, #guild_depot{}).

%% 保存公会仓库
save_guild_depot(GuildId, GuildDepot) ->
    GuildDepotMap = get_depot_map(),
    NewGuildDepotMap = maps:put(GuildId, GuildDepot, GuildDepotMap),
    save_depot_map(NewGuildDepotMap).

%% 获取根据自动清理条件过滤的仓库物品
get_filter_depot_goods(GuildDepot) ->
    #guild_depot{
        depot_goods = DepotGoodsList,
        auto_destroy = {Stage, Color, Star}
    } = GuildDepot,

    F = fun(#depot_goods{goods_id = GoodsId}) ->
        lib_equip_api:get_equip_stage(GoodsId) =< Stage
        andalso
        data_goods:get_goods_color(GoodsId) =< Color
        andalso
        lib_equip_api:get_equip_star(GoodsId) =< Star
    end,
    lists:filter(F, DepotGoodsList).

get_filter_depot_goods(GuildDepot, {Stage, Color, Star}) ->
    get_filter_depot_goods(GuildDepot#guild_depot{auto_destroy = {Stage, Color, Star}}).

%% 仓库操作记录的最新id 不进数据库在自己进程维护就行
get_depot_record_new_id() ->
    case get("depot_record_last_id") of
        undefined ->
            LastId = 1,
            put("depot_record_last_id", LastId),
            LastId;
        LastId ->
            put("depot_record_last_id", LastId + 1),
            LastId + 1
    end.

%% 每日捐献操作记录的最新id 不进数据库在自己进程维护就行
get_donate_record_new_id() ->
    case get("depot_donate_last_id") of
        undefined ->
            LastId = 1,
            put("depot_donate_last_id", LastId),
            LastId;
        LastId ->
            put("depot_donate_last_id", LastId + 1),
            LastId + 1
    end.

delete_depot_by_guild_id(GuildId) ->
    GuildDepotMap = get_depot_map(),
    NewGuildDepotMap = maps:remove(GuildId, GuildDepotMap),
    save_depot_map(NewGuildDepotMap).

log_guild_depot(_, [], DepotScore) -> DepotScore;
log_guild_depot(RoleId, [DepotGood | T], DepotScore) ->
    #depot_goods{
        id = AutoId,
        goods_id = GoodsId,
        color = Color
    } = DepotGood,

    case data_equip:get_equip_attr_cfg(GoodsId) of
        #equip_attr_cfg{stage = Stage, star = Star} ->
            [{ScoreAdd, _}] = data_guild_depot:get_depot_goods_score(Stage, Star, Color);
        _ ->
            ScoreAdd = 0
    end,
    NewDepotScore = DepotScore + ScoreAdd,

    lib_log_api:log_guild_depot(RoleId, ?GUILD_DEPOT_CTRL_ADD, AutoId, GoodsId, DepotScore, NewDepotScore),
    log_guild_depot(RoleId, T, NewDepotScore).

%% db删除仓库物品
db_guild_depot_goods_delete(DepotGoods) ->
    GoodsIds = [Id || #depot_goods{id = Id} <- DepotGoods],
    GoodsIds /= [] andalso db:execute(io_lib:format(?sql_delete_guild_depot_more, [util:link_list(GoodsIds)])).

%% db插入新增仓库物品
db_guild_depot_goods_insert(DepotGoods) ->
    NowTime = utime:unixtime(),
    DbArgs =
    [
        begin
            #depot_goods{
                id = AutoId,
                guild_id = GuildId,
                goods_id = GoodsId,
                num = Num,
                color = Color,
                addition = Addition,
                extra_attr = ExtraAttr
            } = DepotGood,
            AdditionBin = util:term_to_bitstring(Addition),
            ExtraAttrBin = util:term_to_bitstring(ExtraAttr),
            [
                AutoId, GuildId, GoodsId, Num, Color,
                AdditionBin, ExtraAttrBin, NowTime
            ]
        end
     || DepotGood <- DepotGoods
    ],
    Sql = usql:replace(
        guild_depot_goods,
        [id, guild_id, goods_id, num, color, addition, extra_attr, create_time],
        DbArgs
    ),
    Sql /= [] andalso db:execute(Sql).

%% db更新玩家仓库积分值
db_guild_member_depot_score_update(RoleId, DepotScore) ->
    db:execute(io_lib:format(?sql_guild_member_update_depot_score, [DepotScore, RoleId])).