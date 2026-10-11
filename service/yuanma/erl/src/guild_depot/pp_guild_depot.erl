%%-----------------------------------------------------------------------------
%% @Module  :       pp_guild_depot
%% @Author  :       Czc
%% @Email   :       389853407@qq.com
%% @Created :       2017-09-18
%% @Description:
%%-----------------------------------------------------------------------------
-module(pp_guild_depot).

-include("server.hrl").
-include("common.hrl").
-include("figure.hrl").
-include("def_goods.hrl").
-include("errcode.hrl").
-include("guild.hrl").
-include("goods.hrl").

-export([handle/3]).

% -compile([export_all]).

handle(Cmd, Player, Args) ->
    #player_status{sid = Sid, guild = GuildStatus} = Player,
    #status_guild{id = GuildId} = GuildStatus,
    case GuildId =/= 0 of
        true ->
            do_handle(Cmd, Player, Args);
        _ ->
            lib_guild_depot:send_error_code(Sid, ?ERRCODE(err400_not_join_guild))
    end.

%% 仓库界面
do_handle(40101, Player, []) ->
    #player_status{id = RoleId, guild = GuildStatus} = Player,
    #status_guild{id = GuildId} = GuildStatus,
    mod_guild:send_guild_depot_info(RoleId, GuildId);

do_handle(40102, Player, [DonateList]) ->
    #player_status{sid = Sid, id = RoleId, figure = Figure} = Player,
    #figure{name = RoleName} = Figure,

    % 获取物品列表
    GoodsStatus = lib_goods_do:get_goods_status(),
    GoodsInfoL = [
        {lib_goods_util:get_goods(GoodsId, GoodsStatus#goods_status.dict), Num}
     || {GoodsId, Num} <- DonateList
    ],

    % 判断物品是否可捐赠
    F = fun({GoodsInfo, Num}) ->
        is_record(GoodsInfo, goods)
        andalso
        GoodsInfo#goods.num >= Num
        andalso
        lib_guild_depot:is_allow_add_to_depot(GoodsInfo)
    end,
    case {DonateList, lists:all(F, GoodsInfoL)} of
        {[], _} -> lib_guild_depot:send_error_code(Sid, ?FAIL);
        {_, false} -> lib_guild_depot:send_error_code(Sid, ?ERRCODE(err401_goods_can_not_add_to_depot));
        _ -> mod_guild:add_to_depot(RoleId, RoleName, GoodsInfoL)
    end;

%% 兑换
do_handle(40103, Player, [?GUILD_DEPOT_TASK_EQUIP = GoodsId, GoodsTypeId, 1]) -> % 做任务兑换系统生成物品
    #player_status{sid = Sid, id = RoleId, figure = #figure{name = RoleName}} = Player,
    IsNotFinishTask = lib_guild_depot:is_not_finish_guild_depot_excg_task(Player),
    TaskGTypeId = lib_guild_depot:get_guild_depot_excg_task_equip_id(Player),
    case {IsNotFinishTask, TaskGTypeId} of
        {true, GoodsTypeId} ->
            mod_guild:exchange_depot_goods(RoleId, RoleName, GoodsId, GoodsTypeId, 1);
        _ ->
            lib_guild_depot:send_error_code(Sid, ?FAIL)
    end;
do_handle(40103, Player, [DepotGoodsId, GoodsTypeId, Num]) when Num > 0 ->
    #player_status{sid = Sid, id = RoleId, figure = Figure} = Player,
    #figure{name = RoleName} = Figure,
    case lib_goods_api:can_give_goods(Player, [{GoodsTypeId, Num}]) of
        true ->
            mod_guild:exchange_depot_goods(RoleId, RoleName, DepotGoodsId, GoodsTypeId, Num);
        _ ->
            lib_guild_depot:send_error_code(Sid, ?ERRCODE(err401_bag_cell_not_enough))
    end;

%% 销毁
do_handle(40104, Player, [DepotGoodsIds]) when DepotGoodsIds =/= [] ->
    #player_status{id = RoleId, figure = Figure} = Player,
    #figure{name = RoleName} = Figure,
    mod_guild:destory_depot_goods(RoleId, RoleName, ?GUILD_DEPOT_CTRL_DESTORY, DepotGoodsIds);

%% 按条件销毁
do_handle(40109, Player, [Stage, Color, Star]) ->
    #player_status{id = RoleId, figure = Figure} = Player,
    #figure{name = RoleName} = Figure,
    mod_guild:destory_depot_goods(RoleId, RoleName, ?GUILD_DEPOT_CTRL_DESTORY, {Stage, Color, Star});

%% 批量销毁当前条件
do_handle(40110, Player, []) ->
    #player_status{id = RoleId} = Player,
    mod_guild:send_auto_destroy_setting(RoleId);

do_handle(_Cmd, _Player, _Data) ->
    {error, atom_to_list(?MODULE) ++ " no match"}.
