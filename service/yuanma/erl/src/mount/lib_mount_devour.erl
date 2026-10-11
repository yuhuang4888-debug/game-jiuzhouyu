%%%-------------------------------------------------------------------
%%% @author whao
%%% @copyright (C) 2019, <SuYou Game>
%%% @doc
%%%  外形吞噬
%%% @end
%%% Created : 03. 二月 2019 0:17
%%%-------------------------------------------------------------------
-module(lib_mount_devour).
-author("whao").

-include("server.hrl").
-include("errcode.hrl").
-include("predefine.hrl").
-include("common.hrl").
-include("mount.hrl").
-include("attr.hrl").
-include("figure.hrl").
-include("scene.hrl").
-include("goods.hrl").
-include("def_fun.hrl").
-include("def_module.hrl").
-include("def_event.hrl").
-include("def_goods.hrl").
-include("rec_event.hrl").
-include("skill.hrl").
-include("common_rank.hrl").
%% API
-compile(export_all).


%% 获取物品吞噬所加的经验值
count_add_exp(GoodsList, MaxExp) ->
    F = fun({GoodsId, GoodsNum}, {ExpTmp, NewGoodsTmp}) ->
        AddExp = data_mount:get_mount_devour_exp(GoodsId),
        ?MYLOG("wuhao", "ExpTmp:~p AddExp:~p GoodsNum ~p~n", [ExpTmp, AddExp, GoodsNum]),
        NewExpTmp = ExpTmp + AddExp * GoodsNum,
        case ExpTmp >= MaxExp of
            true ->
                {ExpTmp, NewGoodsTmp};
            false ->
                NewExpTmp = ExpTmp + AddExp * GoodsNum,
                {NewExpTmp, [{GoodsId, GoodsNum} | NewGoodsTmp]}
        end
        end,
    lists:foldl(F, {0, []}, GoodsList).


%%  升级
get_new_devour_lv(TypeId, Lv, ExpTmp, AddExp) ->
    case data_mount:get_mount_devour(TypeId, Lv) of
        [] -> {Lv, ExpTmp + AddExp};
        #mount_devour_cfg{exp = 0} ->
            {Lv, ExpTmp + AddExp};
        #mount_devour_cfg{exp = NeedExp} ->
            case ExpTmp + AddExp >= NeedExp of
                true ->
                    case data_mount:get_mount_devour(TypeId, Lv + 1) of
                        [] -> {Lv, ExpTmp + AddExp};
                        _ -> get_new_devour_lv(TypeId, Lv + 1, 0, ExpTmp + AddExp - NeedExp)
                    end;
                false ->
                    {Lv, ExpTmp + AddExp}
            end
    end.


%% 获取剩余升到满级的吞噬经验
get_least_full_lv(TypeId, Lv, Exp) ->
    MaxLv = data_mount:mount_devour_lv(TypeId), % 获取最大的等级
    %% 选取需要待升级的等级
    LeastLvs = lists:sublist(data_mount:get_all_mount_dev_lv(TypeId), Lv),
    case Lv == MaxLv of
        true -> 0;
        false ->
            F = fun(LvTmp, ExpTmp) ->
                #mount_devour_cfg{exp = NeedExpTmp} = data_mount:get_mount_devour(TypeId, LvTmp),
                case Lv == LvTmp of
                    true ->
                        ExpTmp + (NeedExpTmp - Exp);
                    false ->
                        ExpTmp + NeedExpTmp
                end
                end,
            lists:foldl(F, 0, LeastLvs)   % 计算剩余升满级的经验
    end.


%% 增加吞噬的经验等级
add_devour(TypeId, GoodsList, StatusType, #player_status{id = RoleId}, GS) ->
    #status_mount{devour_exp = Exp, devour_lv = Lv} = StatusType,
    case check_goods_base(GS, GoodsList, []) of
        {true, GoodsInfoList} ->
            ExpAdd = get_upgrade_exp(GoodsInfoList),   % 所选物品增加的经验
            {NewLv, NewExp} = get_new_devour_lv(TypeId, Lv, Exp, ExpAdd),  % 获取升级之后的等级
            case data_mount:get_mount_devour(TypeId, NewLv) of
                [] ->
                    {false, ?ERRCODE(err160_devour_max_lv)}     ;
                #mount_devour_cfg{exp = 0} when NewLv == Lv ->
                    {false, ?ERRCODE(err160_devour_max_lv)};
                _ ->
                    NewStatusType = StatusType#status_mount{devour_exp = NewExp, devour_lv = NewLv},
                    F = fun() ->
                        ok = lib_goods_dict:start_dict(),
                        add_devour_core(RoleId, GS, GoodsInfoList, NewStatusType)
                        end,
                    case lib_goods_util:transaction(F) of
                        {ok, NewGS, UpdateGoodsList} ->
                            IsUpgrade = NewLv =/= Lv,
                            CostList = [ {GoodsTypeId, Num} || {#goods{goods_id = GoodsTypeId}, Num} <- GoodsInfoList],
                            lib_log_api:log_mount_devour(RoleId, TypeId, Lv, Exp, NewLv, NewExp, CostList),
                            {ok, NewGS, UpdateGoodsList, NewStatusType, IsUpgrade};
                        _Err ->
                            ?ERR("add devour err : ~p~n", [_Err]),
                            {false, ?FAIL}
                    end
            end;
        {false, Res} ->
            {false, Res}
    end.



%% 检查吞噬的条件
check_devour(StatusType) ->
    #status_mount{type_id = TypeId, devour_lv = DevLv} = StatusType,
    MaxLv = data_mount:mount_devour_lv(TypeId), % 获取最大的等级
    case DevLv < MaxLv of
        true ->
            true;
        false ->
            {false, ?ERRCODE(err160_devour_max_lv)}
    end.



get_devour_lv_exp(TypeId, NewPlayer) ->
    #player_status{status_mount = StatusMount} = NewPlayer,
    StatuType = lists:keyfind(TypeId, #status_mount.type_id, StatusMount),
    #status_mount{devour_exp = DevExp, devour_lv = DevLv} = StatuType,
    {DevLv, DevExp}.



%% 检查物品的
check_goods_base(_GS, [], List) -> {true, List};
check_goods_base(GS, [{GoodsId, Num} | GoodsNumList], List) ->
    case lib_goods_check:check_goods_normal(GS, GoodsId) of
        {ok, GoodsInfo} ->
            case data_mount:get_mount_devour_exp(GoodsInfo#goods.goods_id) of
                [] -> {false, ?MISSING_CONFIG};
                _ ->
                    case GoodsInfo#goods.num >= Num of
                        true -> check_goods_base(GS, GoodsNumList, [{GoodsInfo, Num} | List]);
                        _ -> {false, ?GOODS_NOT_ENOUGH}
                    end
            end;
        {fail, Res} -> {false, Res}
    end.



%% 获取升级的物品的经验
get_upgrade_exp(GoodsInfoList) ->
    F = fun({#goods{goods_id = GoodsTypeId}, Num}, AccExp) ->
        Exp = data_mount:get_mount_devour_exp(GoodsTypeId),
        AccExp + Exp * Num
        end,
    lists:foldl(F, 0, GoodsInfoList).




%% 升级吞噬
add_devour_core(RoleId, GS, GoodsInfoList, NewStatusType)->
    {ok, GS1} = lib_goods:delete_goods_list(GS, GoodsInfoList),
    %% 物品扣除日志
    [
        lib_log_api:log_throw(add_devour, RoleId, GoodsInfo#goods.id, GoodsInfo#goods.goods_id, Num, 0, 0)
        || {GoodsInfo, Num} <- GoodsInfoList
    ],
    sql_devour_base(NewStatusType, RoleId),
    #goods_status{dict = ODict} = GS1,
    {NewDict, UpdateGoodsList} = lib_goods_dict:handle_dict_and_notify(ODict),
    NewGS = GS1#goods_status{dict = NewDict},
    {ok, NewGS, UpdateGoodsList}.




%% 吞噬sql
sql_devour_base(StatuType, RoleId) ->
    #status_mount{
        type_id = TypeId,
        devour_lv = DevourLv,
        devour_exp = DevourExp
    } = StatuType,
    ReSql = io_lib:format(?sql_mount_devour_replace, [RoleId, TypeId, DevourLv, DevourExp]),
    db:execute(ReSql).






