%% @author xiaoxiang
%% @deprecated
%% @doc  藏宝图
%% @param
%% @since  2017-04-24
-module(lib_tsmap).

-include("tsmaps.hrl").
-include("figure.hrl").
-include("server.hrl").
-include("vip.hrl").
-include("errcode.hrl").
-include("common.hrl").
-include("predefine.hrl").
-include("goods.hrl").
-include("def_goods.hrl").
-include("def_module.hrl").
-include("def_fun.hrl").

-export([
    lottery/3,
    do_FMA/3,
    send_tv/6,
    send_tv/7,
    use_treasure_map/2,
    make_goods_other/2,
    pack_and_send/3,
    get_tsmap_times_by_type/2
]).

-export([
    gm_chrono_repair/0,
    tsmap_gm/3,
    do_tsmap_gm/4,
    gm_lottery/3
]).

%% ==============================================
%% open function
%% ==============================================
use_treasure_map(PlayerStatus, AutoGoodsId) ->
    #player_status{id = PlayerId, figure = #figure{ lv = PlayerLevel }} = PlayerStatus,
    case lib_goods_api:get_goods_info(AutoGoodsId) of
        #goods{goods_id = GoodsTypeId, other = Other} = GoodsInfo ->
            case is_treasure_map(GoodsTypeId) of
                true ->
                    #goods_other{optional_data = Data} = Other,
                    case Data of
                        {Scene, X, Y} ->
                            pack_and_send(PlayerId, 20301, [?SUCCESS, Scene, X, Y]);
                        _ ->%% 首次使用
                            #goods{other = Other2} = init_map(GoodsInfo, PlayerLevel),
                            #goods_other{optional_data = Data2} = Other2,
                            case Data2 of
                                {Scene, X, Y} ->
                                    pack_and_send(PlayerId, 20301, [?SUCCESS, Scene, X, Y]);
                                _ -> skip
                            end
                    end;
                _ ->
                    pack_and_send(PlayerId, 20300, [?ERRCODE(err203_not_teasure_map)])
            end;
        _ ->
            pack_and_send(PlayerId, 20300, [?ERRCODE(err150_no_goods)])
    end.

lottery(PlayerStatus, LotteryType, AutoGoodsId) ->
    #player_status{
        id = PlayerId,
        scene = PlayerScene,
        x = MyX,
        y = MyY,
        figure =
        #figure{lv = PlayerLevel, name = PlayerName },
        vip = #role_vip{ vip_lv = VipLevel }
    } = PlayerStatus,
    case catch check_can_lottery(LotteryType, AutoGoodsId, PlayerScene, MyX, MyY) of
        {ok, {Scene, MapX, MapY}} ->
            AllPool = get_all_pool(LotteryType),
            case get_lottery_pool(AllPool, VipLevel, PlayerLevel) of
                LotteryPoolL when is_list(LotteryPoolL) ->
                    OtherArgsL =  [PlayerId, PlayerName, PlayerLevel, LotteryType, AutoGoodsId, Scene, {MapX, MapY}],
                    do_lottery(PlayerStatus, LotteryPoolL, AllPool, OtherArgsL);
                _ ->
                    pack_and_send(PlayerId, 20302, [?MISSING_CONFIG, LotteryType, 0, [], []])
            end;
        {error, 2030004} -> % ?ERRCODE(err203_distance_error)
            % 当前客户端遇到某个坐标寻路会有bug导致采集点过远，但较难复现，
            % 所以在此兼容当触发采集点过远的错误时，重新生成坐标。
            GoodsInfo = lib_goods_api:get_goods_info(AutoGoodsId),
            #goods{other = #goods_other{optional_data = {Scene0, X0, Y0}}} = GoodsInfo,
            ?ERR("tsmap_error_Code:~p//PlayerId:~p//PlayerInfo:~p//GoodsInfo:~p~n", [2030004, PlayerId, {PlayerScene, MyX, MyY}, {Scene0, X0, Y0}]),
            case init_map(GoodsInfo, PlayerLevel) of
                #goods{other = #goods_other{optional_data = {Scene, X, Y}}} ->
                    pack_and_send(PlayerId, 20301, [?SUCCESS, Scene, X, Y]);
                _ ->
                    skip
            end;
        {error, Code} ->
            pack_and_send(PlayerId, 20302, [Code, LotteryType, 0, [], []])
    end.

send_tv(PS, Tv, Type, _Name, RoleId, RewardList, RoleId) ->
    send_tv(Tv, Type, _Name, RoleId, RewardList, RoleId),
    PS.

send_tv(?not_tv, _Type, _Name, RoleId, _RewardList, RoleId) ->
    put(tsmap, []);
send_tv(Tv, Type, Name, RoleId, Reward, RoleId) ->
    if
        Type == ?mysterious_map ->  %% 神秘藏宝图， 立即发送传闻
            put(tsmap, []),
            send_tv_do([], Tv, Type, Name, RoleId, Reward);
        Type == ?legend_map ->  %% 一段时间后在发送传闻和奖励
            spawn(
                fun() ->
                    put(tsmap, []),
                    send_tv_do([], Tv, Type, Name, RoleId, Reward)
                end
            );
        true ->
            skip
    end.

%% 跨服中心执行函数
do_FMA(M, F, Args) ->
    mod_clusters_center:apply_to_all_node(M, F, Args).

%% 藏宝图物品将数据库里other_data的数据转化到#goods_other里面
make_goods_other(Other, [SceneMsg | _]) ->
    Other#goods_other{optional_data = SceneMsg}.

%% ========================================================
%% inner_function
%% ========================================================

send_tv_do(PS, ?all_world_tv, Type, RoleName, _RoleId, Reward) -> %% 全世界传闻
    MapName = get_map_name(Type),
    {GoodsId, Num} = get_reward_id_num(Reward),
    lib_chat:send_TV({all}, ?MOD_TREASURE_MAP, 1, [RoleName, MapName, GoodsId, Num]),
    PS;
send_tv_do(PS, ?all_server_tv, Type, RoleName, RoleId, Reward) ->  %% 全跨服传闻
    MapName = get_map_name(Type),
    {GoodsId, Num} = get_reward_id_num(Reward),
    M = lib_chat,
    F = send_TV,
    Args = [{all}, ?MOD_TREASURE_MAP, 2, [RoleName, MapName, GoodsId, Num]],
    mod_kf_draw_record:cast_center([{'save_draw_log2', ?MOD_TREASURE_MAP, 1, config:get_server_id(), config:get_server_num(), util:get_server_name(), RoleId, RoleName, Reward, utime:unixtime(), "",  0, 0, util:get_c_server_msg()}]),
    mod_clusters_node:apply_cast(lib_tsmap, do_FMA, [M, F, Args]),
    PS.

get_map_name(?mysterious_map) ->
    utext:get(2030001);%%"神秘";
get_map_name(?legend_map) ->
    utext:get(2030002). %%"传说".

get_reward_id_num([]) ->
    {0, 0};
get_reward_id_num([{_, GoodTypeId, Num} | _]) ->
    {GoodTypeId, Num}.

%% 藏宝图物品other_data的保存格式
%% SceneMsg : {SceneId, X, Y}
format_other_data(#goods{type = ?GOODS_TYPE_TREASURE_MAP, other = Other}) ->
    #goods_other{optional_data = SceneMsg} = Other,
    [?GOODS_OTHER_KEY_TREASURE_MAP, SceneMsg];

format_other_data(_) ->
    [].

%% 更新 goods_other
change_goods_other(#goods{id = Id} = GoodsInfo) ->
    lib_goods_util:change_goods_other(Id, format_other_data(GoodsInfo)).

%%第一次使用藏宝图, 初始化场景和坐标
%%return   #goods{}
init_map(#goods{other = Other, level = GoodsLv, location = Location} = GoodsInfo, PlayerLevel) ->
    Data = get_new_map_data(PlayerLevel),
    NewGoodsInfo = GoodsInfo#goods{other = Other#goods_other{optional_data = Data}},
    GoodsStatus = lib_goods_do:get_goods_status(),
    change_goods_other(NewGoodsInfo),
    [LastGoodsInfo, NewGoodsStatus] = lib_goods:change_goods_level_extra_attr(NewGoodsInfo, Location, GoodsLv, [], GoodsStatus),
    lib_goods_do:set_goods_status(NewGoodsStatus),
    LastGoodsInfo.

%% 根据玩家等级，随机获得一个场景ID与一组坐标
get_new_map_data(PlayerLevel) ->
    case data_treasure_map:get_scene_list(PlayerLevel) of
        List when is_list(List)->
            Scene = hd(ulists:list_shuffle(List)),
            case data_treasure_map:get_coordinate(Scene) of
                List2 when is_list(List2)->
                    {X, Y} = hd(ulists:list_shuffle(List2)),
                    {Scene, X, Y};
                _ ->
                    {Scene, 0, 0}
            end;
        _ ->
            {0, 0, 0}
    end.

%%藏宝图的补偿
gm_chrono_repair() ->
    Sql  =  io_lib:format(<<"select  role_id from   log_treasure_map  where   type = 2  and   time >=  1576533616  and   time   <=    1576564216">>, []),
    List = db:get_all(Sql),
    [lib_local_chrono_rift_act:role_success_finish_act(RoleId, ?MOD_TREASURE_MAP, 2, 1) || [RoleId] <- List].

%% ======================================================
%% internal_function
%% ======================================================

handle_af_lottery(GoodsAutoId, Lv) ->
    case lib_goods_api:get_goods_info(GoodsAutoId) of
        #goods{} = GoodsInfo ->
            init_map(GoodsInfo, Lv);
        _ ->
            ok
    end.

%% 打包并发送数据
pack_and_send(PlayerId, Cmd, Args) ->
    {ok, Bin} = pt_203:write(Cmd, Args),
    lib_server_send:send_to_uid(PlayerId, Bin).

%% 校验前端使用的藏宝图是否合法
is_treasure_map(GoodsTypeId) ->
    lists:member(GoodsTypeId, ?TSMAPS_TYPE).

%% 根据类型获取整个奖池
get_all_pool(Type) ->
    List = data_treasure_map:get_treasure_map_by_type(Type),
    [#base_reward_map{id = Id, type = Type1, reward_list = Reward, weight = Weight, min_lv = MinLv, max_lv = MaxLv, rare = Rare, tv = Tv, vip_lv = VipLv}
        || {Id, Type1, Reward, Weight, MinLv, MaxLv, Rare, Tv, VipLv} <- List].

%% 获得抽奖列表
get_lottery_pool(AllPool, VipLv, Lv) ->
    [{W, Item} || #base_reward_map{vip_lv = VipLvLimit, min_lv = MinLv, max_lv = MaxLv, weight = W} = Item <- AllPool, VipLv >= VipLvLimit, Lv >= MinLv, Lv =< MaxLv, W =/= 0].

%% 极品奖励
get_rare_show_list(Pool) ->
    RewardList1 = [Reward || #base_reward_map{rare = Rare, reward_list = Reward} <- Pool, Rare == ?is_rare],
    RewardList2 = ulists:list_shuffle(lists:flatten(RewardList1)),
    RareNum = get_rare_num(),
    ResList = lists:sublist(RewardList2, RareNum),
    {length(ResList), ResList}.

%% 外观稀有奖励
get_rare2_show_list(Pool) ->
    RewardList1 = [Reward || #base_reward_map{rare = Rare, reward_list = Reward} <- Pool, Rare == ?is_rare2],
    RewardList2 = ulists:list_shuffle(lists:flatten(RewardList1)),
    RareNum = get_rare_num2(),
    ResList = lists:sublist(RewardList2, RareNum),
    {length(ResList), ResList}.

%%垃圾奖励
get_poor_show_list(Pool) ->
    RewardList1 = [Reward || #base_reward_map{rare = Rare, reward_list = Reward} <- Pool, Rare == ?is_poor],
    RewardList2 = ulists:list_shuffle(lists:flatten(RewardList1)),
    RareNum = get_poor_num(),
    ResList = lists:sublist(RewardList2, RareNum),
    {length(ResList), ResList}.

%% 获取极品奖励展示的个数
get_rare_num() ->
    RareList = data_treasure_map:get_kv(rare_num),
    {_, Num} = util:find_ratio(RareList, 1),
    Num.

%% 获取外观奖励展示的个数
get_rare_num2() ->
    RareList = data_treasure_map:get_kv(rare_num2),
    {_, Num} = util:find_ratio(RareList, 1),
    Num.

get_poor_num() ->
    RareList = data_treasure_map:get_kv(poor_num),
    {_, Num} = util:find_ratio(RareList, 1),
    Num.

%% 获得普通奖励展示
get_common_show_list(_LeftPool, Num) when Num =< 0 ->
    [];
get_common_show_list(Pool, Num) ->
    RewardList1 = [Reward || #base_reward_map{rare = Rare, reward_list = Reward} <- Pool, Rare == ?not_rare],
    RewardList2 = ulists:list_shuffle(lists:flatten(RewardList1)),
    ResList = lists:sublist(RewardList2, Num),
    ResList.

%% 藏宝图抽奖的合法性
check_can_lottery(LotteryType, AutoGoodsId, PlayerScene, MyX, MyY) ->
    case lib_goods_api:get_goods_info(AutoGoodsId) of
        #goods{ goods_id = GoodsType, other = Other } ->
            ?IF( is_treasure_map(GoodsType), ok, throw({error, ?ERRCODE(err203_not_teasure_map)})),
            ?IF( is_good_type_legal(LotteryType, GoodsType), ok, throw({error, ?ERRCODE(er203_map_type_error)})),
            case Other#goods_other.optional_data of
                {Scene, X, Y} ->
                    Distance = umath:distance({MyX, MyY}, {X, Y}),
                    DistanceLimit = data_treasure_map:get_kv(distance),
                    ?IF( Scene == PlayerScene, ok, throw({error, ?ERRCODE(er203_scene_error)})),
                    ?IF( Distance =< DistanceLimit, ok, throw({error, ?ERRCODE(err203_distance_error)})),
                    {ok, {Scene, X, Y}};
                _ ->
                    throw({error, ?ERRCODE(err203_not_have_coordinate)})
            end;
        _ ->
            throw({error, ?ERRCODE(err150_no_goods)})
    end.

%% 检测使用的道具类型与抽奖类型的一致合法
is_good_type_legal(LotteryType, GoodsTypeId) ->
    if
        LotteryType == ?mysterious_map ->
            GoodsTypeId == data_treasure_map:get_kv(map1);
        LotteryType == ?legend_map ->
            GoodsTypeId == data_treasure_map:get_kv(map2);
        true -> false
    end.

do_lottery(PlayerStatus, LotteryPoolL, AllPool, OtherArgsL) ->
    [PlayerId, PlayerName, PlayerLevel, LotteryType, AutoGoodsId, Scene, {MapX, MapY}] = OtherArgsL,
    ShowNum = data_treasure_map:get_kv(show_num),  %% 展示奖励梳理
    {_, WinningInfo} = util:find_ratio(LotteryPoolL, 1),
    #base_reward_map{id = LotteryId, reward_list = RewardList, rare = Rare, tv = Tv} = WinningInfo,
    %% 根据挖宝次数修正奖励
    DrawTimes = get_tsmap_times_by_type(PlayerId, LotteryType),
    FixRewardList = case data_treasure_map:get_trmaps_times_reward(LotteryType, DrawTimes + 1) of
                        #trmaps_times_reward{ rewards = AwardList } -> AwardList;
                        _ -> RewardList
                    end,
    LeftPool = lists:keydelete(LotteryId, #base_reward_map.id, AllPool),
    {RareNum, RareList} = get_rare_show_list(LeftPool),  %%稀有奖励
    {RareNum2, RareList2} = get_rare2_show_list(LeftPool),  %%稀有奖励2
    {PoorNum, PoorList} = get_poor_show_list(LeftPool),   %% 超级普通奖励
    CommonRewardList = get_common_show_list(LeftPool, ShowNum - RareNum - RareNum2 - PoorNum),  %% 普通奖励
    ShowList = ulists:list_shuffle(RareList ++ CommonRewardList ++ RareList2 ++ PoorList),  %%展示奖励
    %%日志
    lib_log_api:log_treasure_map(PlayerId, LotteryType, Scene, {MapX, MapY}, FixRewardList),
    %%删除藏宝图
    case lib_goods_api:delete_more_by_list(PlayerStatus, [{AutoGoodsId, 1}], treasure_map) of
        1 -> %% 成功
            case LotteryType == ?legend_map of
                true -> lib_local_chrono_rift_act:role_success_finish_act(PlayerId, ?MOD_TREASURE_MAP, 2, 1);
                false -> skip
            end,
            %% 更新挖宝次数
            update_do_tsmap_times(PlayerId, DrawTimes, LotteryType),
            %%20220302 按策划要求优化奖励立即发送到账
            lib_goods_api:send_reward_with_mail(PlayerId, #produce{reward = FixRewardList, type = treasure_map}),
            %% 定时器的作用防止前端无法正常发送20304协议导致奖励无法正常发送
            Ref = util:send_after([], ?tv_delay, self(), {'mod', lib_tsmap, send_tv, [Tv, LotteryType, PlayerName, PlayerId, FixRewardList, PlayerId]}),
            Mag = {Ref, Tv, LotteryType, PlayerName, PlayerId, FixRewardList, PlayerId},
            put(tsmap, Mag),
            %% 处理剩下藏宝图的坐标
            handle_af_lottery(AutoGoodsId, PlayerLevel),
            pack_and_send(PlayerId, 20302, [?SUCCESS, LotteryType, Rare, FixRewardList, ShowList]);
        Error ->
            pack_and_send(PlayerId, 20302, [Error, LotteryType, 0, [], []])
    end.

update_do_tsmap_times(PlayerId, CurTimes, Type) ->
    NewTimes = CurTimes + 1,
    OldList = case mod_counter:get_other_data(PlayerId, ?MOD_TREASURE_MAP, 1, ?DO_TSMAPS_TYPE_TIMES) of
                  List when is_list(List) -> List;
                  _ -> []
              end,
    NewList = lists:keystore(Type, 1, OldList, {Type, NewTimes}),
    mod_counter:set_count(PlayerId, [{{?MOD_TREASURE_MAP, 1, ?DO_TSMAPS_TYPE_TIMES}, {1, NewList}}]).

get_tsmap_times_by_type(PlayerId, LotteryType) ->
    case mod_counter:get_other_data(PlayerId, ?MOD_TREASURE_MAP, 1, ?DO_TSMAPS_TYPE_TIMES) of
        List when is_list(List) ->
            proplists:get_value(LotteryType, List, 0);
        _ ->
            0
    end.

%% 特殊处理货币等类型的格式，使其符合20303协议的格式
%%fix_reward_format(RewardList) ->
%%    F = fun(Item, List) ->
%%        case Item of
%%            {?TYPE_COIN, Id, Num} -> [{Id, ?GOODS_ID_COIN, Num}|List];
%%            {?TYPE_GOLD, Id, Num} -> [{Id, ?GOODS_ID_GOLD, Num}|List];
%%            {?TYPE_BGOLD, Id, Num} -> [{Id, ?GOODS_ID_BGOLD, Num}|List];
%%            {?TYPE_CHARM, Id, Num} -> [{Id, ?GOODS_ID_CHARM, Num}|List];
%%            {?TYPE_FAME, Id, Num} -> [{Id, ?GOODS_ID_FAME, Num}|List];
%%            {?TYPE_RUNE, Id, Num} -> [{Id, ?GOODS_ID_RUNE, Num}|List];
%%            {?TYPE_SOUL, Id, Num} -> [{Id, ?GOODS_ID_SOUL, Num}|List];
%%            {?TYPE_RUNE_CHIP, Id, Num} -> [{Id, ?GOODS_ID_RUNE_CHIP, Num}|List];
%%            _ -> [Item|List]
%%        end
%%    end,
%%    lists:foldl(F, [], RewardList).

%% ========================================
%% GM
%% ========================================

tsmap_gm(Ps, LotteryType, Times) ->
    GoodsTypeId = case LotteryType == ?mysterious_map of
                      true -> data_treasure_map:get_kv(map1);
                      _ -> data_treasure_map:get_kv(map2)
                  end,
    #goods_status{dict = Dict} = lib_goods_do:get_goods_status(),
    Dict1 = dict:filter(fun(_Key, [Value]) -> Value#goods.goods_id =:= GoodsTypeId end, Dict),
    DictList = dict:to_list(Dict1),
    [AutoGoodsInfo|_] = lib_goods_dict:get_list(DictList, []),
    #goods{ id = AutoGoodsId } = AutoGoodsInfo,
    %%lib_player:apply_cast(Ps#player_status.id, 2, lib_tsmap, do_tsmap_gm, [LotteryType, AutoGoodsId, Times])
    lib_tsmap:do_tsmap_gm(Ps, LotteryType, AutoGoodsId, Times).

do_tsmap_gm(_, _,  _, 0) -> ok;
do_tsmap_gm(Ps, LotteryType, AutoGoodsId, Num) ->
    lib_tsmap:gm_lottery(Ps, LotteryType, AutoGoodsId),
    do_tsmap_gm(Ps, LotteryType, AutoGoodsId, Num - 1).

gm_lottery(PlayerStatus, LotteryType, AutoGoodsId) ->
    #player_status{id = PlayerId, scene = PlayerScene, x = MyX, y = MyY, figure = #figure{lv = PlayerLevel, name = PlayerName }, vip = #role_vip{ vip_lv = VipLevel }} = PlayerStatus,
    AllPool = get_all_pool(LotteryType),
    case get_lottery_pool(AllPool, VipLevel, PlayerLevel) of
        LotteryPoolL when is_list(LotteryPoolL) ->
            OtherArgsL =  [PlayerId, PlayerName, PlayerLevel, LotteryType, AutoGoodsId, PlayerScene, {MyX, MyY}],
            do_gm_lottery(PlayerStatus, LotteryPoolL, AllPool, OtherArgsL);
        _ ->
            pack_and_send(PlayerId, 20302, [?MISSING_CONFIG, LotteryType, 0, [], []])
    end.

do_gm_lottery(PlayerStatus, LotteryPoolL, AllPool, OtherArgsL) ->
    [PlayerId, _PlayerName, _PlayerLevel, LotteryType, AutoGoodsId, Scene, {MapX, MapY}] = OtherArgsL,
    ShowNum = data_treasure_map:get_kv(show_num),  %% 展示奖励梳理
    {_, WinningInfo} = util:find_ratio(LotteryPoolL, 1),
    #base_reward_map{id = LotteryId, reward_list = RewardList, rare = _Rare, tv = _Tv} = WinningInfo,
    %% 根据挖宝次数修正奖励
    DrawTimes = get_tsmap_times_by_type(PlayerId, LotteryType),
    FixRewardList = case data_treasure_map:get_trmaps_times_reward(LotteryType, DrawTimes + 1) of
                        #trmaps_times_reward{ rewards = AwardList } -> AwardList;
                        _ -> RewardList
                    end,
    LeftPool = lists:keydelete(LotteryId, #base_reward_map.id, AllPool),
    {RareNum, RareList} = get_rare_show_list(LeftPool),  %%稀有奖励
    {RareNum2, RareList2} = get_rare2_show_list(LeftPool),  %%稀有奖励2
    {PoorNum, PoorList} = get_poor_show_list(LeftPool),   %% 超级普通奖励
    CommonRewardList = get_common_show_list(LeftPool, ShowNum - RareNum - RareNum2 - PoorNum),  %% 普通奖励
    _ShowList = ulists:list_shuffle(RareList ++ CommonRewardList ++ RareList2 ++ PoorList),  %%展示奖励
    %%日志
    lib_log_api:log_treasure_map(PlayerId, LotteryType, Scene, {MapX, MapY}, FixRewardList),
    %%删除藏宝图
    case lib_goods_api:delete_more_by_list(PlayerStatus, [{AutoGoodsId, 1}], treasure_map) of
        1 -> %% 成功
            case LotteryType == ?legend_map of
                true -> lib_local_chrono_rift_act:role_success_finish_act(PlayerId, ?MOD_TREASURE_MAP, 2, 1);
                false -> skip
            end,
            %% 更新挖宝次数
            update_do_tsmap_times(PlayerId, DrawTimes, LotteryType),
            %%20220302 按策划要求优化奖励立即发送到账
            lib_goods_api:send_reward_with_mail(PlayerId, #produce{reward = FixRewardList, type = treasure_map}),
            %%lib_tsmap:send_tv(Tv, LotteryType, PlayerName, PlayerId, FixRewardList, PlayerId),
            %% 处理剩下藏宝图的坐标
            handle_gm_lottery(AutoGoodsId, Scene, MapX, MapY);
        _Error ->
            ok
    end.


handle_gm_lottery(GoodsAutoId, Scene, X, Y) ->
    case lib_goods_api:get_goods_info(GoodsAutoId) of
        #goods{other = Other, level = GoodsLv, location = Location} = GoodsInfo ->
            Data = {Scene, X, Y},
            NewGoodsInfo = GoodsInfo#goods{other = Other#goods_other{optional_data = Data}},
            GoodsStatus = lib_goods_do:get_goods_status(),
            change_goods_other(NewGoodsInfo),
            [LastGoodsInfo, NewGoodsStatus] = lib_goods:change_goods_level_extra_attr(NewGoodsInfo, Location, GoodsLv, [], GoodsStatus),
            lib_goods_do:set_goods_status(NewGoodsStatus),
            LastGoodsInfo;
        _ ->
            ok
    end.