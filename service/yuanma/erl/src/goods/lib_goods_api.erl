%% ---------------------------------------------------------------------------
%% Author:  huangwenjie
%% Email:   huangwenjie@jieyoumail.com
%% Created: 2014.5.23
%% Description: 物品外部接口
%% ---------------------------------------------------------------------------

%% =============================!!!api使用须知!!!=============================
%% note：只支持来自【玩家进程】的调用，对于非玩家进程调用会抛出异常（not_in_player_process）
%% 使用方法：
%% 方法一：玩家进程调用本api，再去其他进程处理逻辑
%% 方法二：玩家进程call到其它进程，处理完成逻辑后，回到玩家进程调用本api
%% 方法三：其他进程cast到玩家进程调用本api，如
%%        1.lib_player:apply_cast(PlayerId, ?APPLY_CAST, lib_goods_api, give_goods_by_list, [goodsList])
%%        2.lib_goods_api:send_reward_by_id/3
%% =============================!!!api使用须知!!!=============================


-module(lib_goods_api).
-include("common.hrl").
-include("record.hrl").
-include("def_goods.hrl").
-include("sql_goods.hrl").
-include("goods.hrl").
-include("server.hrl").
-include("scene.hrl").
-include("predefine.hrl").
-include("figure.hrl").
-include("guild.hrl").
-include("errcode.hrl").
-include("def_event.hrl").
-include("rec_event.hrl").
-include("def_fun.hrl").
-define(PLAYER_NOT_ONLINE,     100).    %% 结果码: 角色不在线
-define(NOT_IN_PLAYER_PROCESS(_R), throw(not_in_player_process)).

%% --------------------------------- note ---------------------------------
%% note：移除了物品进程，假如支持非玩家进程调用本api，对于那些来自玩家进程的请求，然后中间绕到
%%       其他进程请求本api，会造成玩家进程里面的逻辑相互等待从而timeout
%% !!! 基于此，从api角度不提供非玩家进程调用
%% --------------------------------- note ---------------------------------

-export([
    % --------------------------------- 删除物品 ---------------------------------
    %delete_one_by_id/4              %% 根据物品Id删除物品并刷新客户端以及做物品日志
    %,delete_one_by_id/3             %% 根据物品Id删除物品并刷新客户端以及做物品日志
    %,delete_more_by_type_id/4       %% 根据物品类型Id删除物品并刷新客户端以及做物品日志 
    %,delete_more_by_type_id/3       %% 根据物品类型Id删除物品并刷新客户端以及做物品日志
    delete_more_by_list/3          %% 根据物品Id列表删除物品并刷新客户端以及做物品日志
    ,delete_more_by_list/2          %% 根据物品Id列表删除物品并刷新客户端以及做物品日志
    ,delete_as_much_as_possible_by_list/2   %% 尽量可能去移除所需数量，如果不够，则返回移除了多少数量
    ,goods_delete_type_list/3       %% 根据物品类型Id列表删除物品并刷新客户端以及做物品日志
    ,goods_delete_type_list/2       %% 根据物品类型Id列表删除物品并刷新客户端以及做物品日志

    % --------------------------------- 增加物品 ---------------------------------
    ,give_goods_by_list/4           %% 根据物品类型Id列表赠送物品并刷新客户端以及做物品日志
    ,give_goods_by_list/2           %% 根据物品类型Id列表赠送物品并刷新客户端以及做物品日志
    ,give_goods_by_list/3           %% 根据物品类型Id列表赠送物品并刷新客户端以及做物品日志
    %,give_goods/5                   %% 给物品并刷新客户端以及做物品日志(没用到，注释掉)
    %,give_goods/3                   %% 给物品并刷新客户端以及做物品日志(没用到，注释掉)

    ,give_goods_by_pile/3           %% 分组发奖励
    ,spilt_reward_pile/1            %% 分离出奖励组

    ,give_goods_to_specify_loc/3    %% 发物品到指定背包
    ,give_goods_to_specify_loc/4    %% 发物品到指定背包
    ,give_goods_to_specify_loc/5    %% 发物品到指定背包

    % --------------------------------- 发放奖励 ---------------------------------
    ,send_reward_by_id/2            %% 发放奖励
    ,send_reward_by_id/3            %% 发放奖励
    ,send_reward_by_id/4            %% 发放奖励
    ,send_reward_by_id/5            %% 发放奖励
    ,send_reward_by_pid/2           %% 发放奖励
    ,send_reward_by_pid/3           %% 发放奖励
    ,send_reward_by_pid/4           %% 发放奖励
    ,send_reward/2                  %% 发送奖励
    ,send_reward/4                  %% 发送奖励
    ,send_reward/5                  %% 发送奖励

    ,cost_money/5                   %% 扣取货币，写入消耗日志
    ,cost_money/4                   %% 扣取多种货币，未全部成功会返回已扣部分
    ,cost_money_offline/5           %% 扣钱（离线版）
    ,get_money_offline/2            %% 获取金钱数量（离线版）
    ,cost_object_list/4             %% 扣除消耗列表object_list
    ,cost_object_list_with_check/4  %% 扣除消耗列表object_list
    ,cost_objects_with_auto_buy/4   %% 扣除消耗列表object_list 不够尝试将其转换成货币
    ,cost_objects_with_auto_buy_with_bg_to_g/4    %% 扣除消耗列表object_list,不够尝试将其转换成货币,绑金不足时，用金代替
    ,send_reward_with_mail/2        %% 发送奖励[玩家背包已满就通过邮件]
    ,send_reward_with_mail_return_goods/2   %% 发送奖励，并且返回物品列表[玩家背包已满就通过邮件]
    ,send_reward_return_goods/2    %% 不会检查背包的发奖励接口，用这接口前请先自行检查背包空间
    ,make_reward_unique/1
    ,move_a2b/4                     %% 移动物品从A背包到B背包
    ,move_a2b/5                     %% 移动物品从A背包到B背包
    ,move_more_a2b/3                %% 移动物品从A背包到B背包，直到B背包没有空格子
    ,move_goods_from_loc/2          %% 移动物品到物品配置的背包里

    % --------------------------------- 检查数量 ---------------------------------
    ,check_object_list/2            %% 判断是否满足消耗列表
    ,check_object_list_with_auto_buy/2 %% 判断是否满足消耗列表 尝试将其转换成货币
    ,check_goods_num/2              %% 判断物品列表数量
    ,get_cost_max_num/2             %% 获得物品消耗最大次数
    ,get_goods_num/2                %% 查询道具数量
    ,get_goods_num/3                %% 查询道具数量
    ,get_cell_num/1                 %% 获取空格子数量
    ,get_cell_num/2                 %% 获取空格子数量
    ,get_need_cell_num/2            %% 获得物品需要多少格子数
    ,can_give_goods/2               %% 检查物品是否可以加入到背包
    ,spilt_send_able_goods/2        %% 分离道具：{可发送，不可发送}
    ,get_goods_info/1               %% 获取物品信息
    ,get_goods_info/2               %% 获取物品信息
    ,count_stren_total_lv/1         %% 计算总的强化等级
    ,count_stone_total_power/1      %% 计算宝石总战力
    ,count_stone_total_lv/1         %% 计算宝石总等级
    ,get_currency/2                 %% 查询特殊货币数量
    ,db_delete_currency_by_currency_id/1
    ,get_first_object_name/1        %% 获取物品名字
    ,make_goods_tv_format_3/1       %% <a@goods3@{1}@{2}@{3}></a> 中的三个参数
    ,calc_auto_buy_list/1           %% 计算不足的物品 这个接口必须在玩家进程调用
    ,calc_cost_goods/1              %% 计算消耗的物品信息
    ,trans_to_attr_goods/1          %% 转换成带属性的物品格式
    ,goods_transactions/5           %% 封装物品dict进入事务
]).

-export([
    notify_client/2                 %% 通知前端更新物品信息、增加物品
    ,notify_client_num/2            %% 更新物品数量 (若物品数量为0,即是要删除的物品)
    ,send_tv_tip/2
    ,send_tv_tip/3
    ,send_update_currency/2
    ,update_client_goods_info/1     %% 通知客户端更新物品的详细信息 15000协议
    ,trans_object_format/1          %% 转为objectlist
    ,spilt_reward/1                 %% 分解objectlist return：{GoodsObjectList, OtherObjectList}
    ,format_detail_reward_list/3    %% 制造详细列表
    ,make_see_reward_list/2         %% 获得可查看的物品列表
    ,make_see_reward_list_for_bf/2
    ,make_reward_args/1
    ,calc_reward/2
    ,calc_reward_help/2
    ,combine_object_with_auto_goods_id/1     %% return [{GoodsType, GoodsId, Num, GoodsAutoId}]
    ,filter_goods/2
    ,get_reward_by_draw_mul_times/2
    ,calc_static_bag/2
]).

-export([make_produce/6]).

%% 秘籍接口，其他地方勿用
-export([
    set_goods_expired_time/3
    , set_goods_expired_time_core/3
    ]).

make_produce(ProduceType, ProduceSubtype, Title, Content, Reward, ShowTips) ->
    #produce{type = ProduceType, subtype = ProduceSubtype, title = Title, content = Content, reward = Reward, show_tips = ShowTips}.

% %% ---------------------------------------------------------------------------
% %% @doc 根据物品Id删除物品并刷新客户端以及做物品日志
% -spec delete_one_by_id(PlayerInfo, GoodsId, DeleteNum, Type) -> Res when
%     PlayerInfo  :: integer() | #player_status{},    %% 玩家Id或者玩家记录
%     GoodsId     :: integer(),                       %% 物品唯一Id
%     DeleteNum   :: integer(),                       %% 要删除的数量
%     Type        :: atom(),                          %% 物品消耗类型
%                                                     %% 需要后台定义"产出消耗类型--消耗类型"
%     Res         :: integer().                       %% 结果码 0:失败|1:成功|2:物品不存在
%                                                     %%        3:物品不属于你|4:物品不在背包
%                                                     %%        6:数量不正确|7:正在交易中
% %% ---------------------------------------------------------------------------
% delete_one_by_id(PlayerInfo, GoodsId, DeleteNum, Type) when DeleteNum>0 ->
%     {PlayerId, Pid} = get_id_pid(PlayerInfo),
%     {Res, GoodsInfo} = case Pid =:= self() of
%         true ->
%             lib_goods_do:delete_one(GoodsId, DeleteNum);
%         false ->
%             ?NOT_IN_PLAYER_PROCESS({0, #goods{}})
%     end,
%     case Res==1 andalso Type=/=[] of
%         true ->
%             #goods{goods_id = GoodsTypeId} = GoodsInfo,
%             lib_log_api:log_throw(Type, PlayerId, GoodsId, GoodsTypeId, DeleteNum, 0, 0);
%         _ ->
%             ok
%     end,
%     Res;
% delete_one_by_id(_PlayerInfo, _GoodsId, DeleteNum, _Type) ->
%     ?ERR("~p:~p param error:~p", [?MODULE, ?LINE, DeleteNum]),
%     0.

% delete_one_by_id(PlayerInfo, GoodsId, DeleteNum) ->
%     delete_one_by_id(PlayerInfo, GoodsId, DeleteNum, "").

% %% ---------------------------------------------------------------------------
% %% @doc 根据物品类型Id删除物品并刷新客户端以及做物品日志
% -spec delete_more_by_type_id(PlayerInfo, GoodsTypeId, DeleteNum, Type) -> Res when
%     PlayerInfo  :: integer() | #player_status{},    %% 玩家Id或者玩家记录
%     GoodsTypeId :: integer(),                       %% 物品类型Id
%     DeleteNum   :: integer(),                       %% 要删除的数量
%     Type        :: atom(),                          %% 物品消耗类型
%                                                     %% 需要后台定义"产出消耗类型--消耗类型"
%     Res         :: integer().                       %% 结果码 0:失败|1:成功|2:物品不存在|6:物品数量不足
% %% ---------------------------------------------------------------------------
% delete_more_by_type_id(PlayerInfo, GoodsTypeId, DeleteNum, Type) when DeleteNum>0 ->
%     goods_delete_type_list(PlayerInfo, [{GoodsTypeId, DeleteNum}], Type);

% delete_more_by_type_id(_PlayerInfo, _GoodsTypeId, DeleteNum, _Type) ->
%     ?ERR("~p:~p param error:~p", [?MODULE, ?LINE, DeleteNum]),
%     0.

% delete_more_by_type_id(PlayerInfo, GoodsTypeId, DeleteNum) ->
%     delete_more_by_type_id(PlayerInfo, GoodsTypeId, DeleteNum, "").

%% ---------------------------------------------------------------------------
%% @doc 根据物品Id列表删除物品并刷新客户端以及做物品日志
-spec delete_more_by_list(PlayerInfo, GoodsList, Type) -> Res when
    PlayerInfo  :: integer() | #player_status{},    %% 玩家Id或者玩家记录
    GoodsList   :: [{GoodsId, DeleteNum}],          %% 物品列表
    GoodsId     :: integer(),                       %% 物品Id
    DeleteNum   :: integer(),                       %% 要删除的数量
    Type        :: atom(),                          %% 物品消耗类型
                                                    %% 需要后台定义"产出消耗类型--消耗类型"
    Res         :: integer().                       %% 结果码 0:失败|1:成功|2:物品不存在|3:物品不是你所有|
                                                    %%        4:物品不在背包|:6物品数量不足|7:正在交易中
%% --------------------------------------------------------------------------
delete_more_by_list(PlayerInfo, GoodsList, Type) when GoodsList=/=[] ->
    {PlayerId, Pid} = get_id_pid(PlayerInfo),
    {Res, GoodsInfoList} = case Pid =:= self() of
        true ->
            lib_goods_do:delete_list(GoodsList);
        false ->
            ?NOT_IN_PLAYER_PROCESS({0, []})
    end,
    case Res==1 andalso Type=/=[] of
        true ->
            Fun = fun({GoodsInfo, Num}) ->
                #goods{id = GoodsId, type = _GType, goods_id = GoodsTypeId} = GoodsInfo,
                lib_log_api:log_throw(Type, PlayerId, GoodsId, GoodsTypeId, Num, 0, 0)
            end,
            [Fun(OneDel) || OneDel <- GoodsInfoList];
        _ ->
            ok
    end,
    Res;
delete_more_by_list(_PlayerInfo, GoodsList, _Type) ->
    ?ERR("~p:~p param error:~p", [?MODULE, ?LINE, GoodsList]),
    tool:back_trace_to_file(),
    0.

delete_more_by_list(PlayerInfo, GoodsList) ->
    delete_more_by_list(PlayerInfo, GoodsList, "").

%% ---------------------------------------------------------------------------
%% @doc 根据物品类型Id列表删除物品并刷新客户端以及做物品日志
-spec goods_delete_type_list(PlayerInfo, GoodsTypeList, Type) -> Res when
    PlayerInfo  :: integer() | #player_status{},    %% 玩家Id或者玩家记录
    GoodsTypeList:: [{GoodsTypeId, DeleteNum}],     %% 物品列表
    GoodsTypeId :: integer(),                       %% 物品类型Id
    DeleteNum   :: integer(),                       %% 要删除的数量
    Type        :: atom(),                          %% 物品消耗类型
                                                    %% 需要后台定义"产出消耗类型--消耗类型"
    Res         :: integer().                       %% 结果码 0:失败|1:成功
%% ---------------------------------------------------------------------------
goods_delete_type_list(PlayerInfo, GoodsTypeList, Type) when GoodsTypeList=/=[] ->
    {PlayerId, Pid} = get_id_pid(PlayerInfo),
    NewGoodsTypeList = GoodsTypeList,
    Res = case Pid =:= self() of
        true ->
            lib_goods_do:delete_type_list(NewGoodsTypeList);
        false ->
            ?NOT_IN_PLAYER_PROCESS(0)
    end,
    case Res==1 andalso Type=/=[] of
        true ->
            Fun = fun({GoodsTypeId, DeleteNum}) ->
                lib_log_api:log_throw(Type, PlayerId, 0, GoodsTypeId, DeleteNum, 0, 0)
            end,
            [Fun(OneDel) || OneDel <- NewGoodsTypeList];
        false ->
            ok
    end,
    Res;
goods_delete_type_list(_PlayerInfo, GoodsTypeList, _Type) ->
    ?ERR("~p:~p param error:~p", [?MODULE, ?LINE, GoodsTypeList]),
    0.

goods_delete_type_list(PlayerInfo, GoodsTypeList) ->
    goods_delete_type_list(PlayerInfo, GoodsTypeList, "").

%% ---------------------------------------------------------------------------
%% @doc 赠送物品(列表中GoodsTypeId不能重复)
%%      根据物品类型Id列表赠送物品并刷新客户端以及做物品日志
-spec give_goods_by_list(Player, GoodsList, Type, SubType) -> Res when
    Player      :: #player_status{},        %% 玩家记录
    GoodsList   :: [tuple()],               %% 物品列表 具体格式参照上面
    Type        :: atom(),                  %% 物品产出类型
                                            %% 需要后台定义"产出消耗类型--产出类型"
    SubType     :: integer(),               %% 物品产出子类型
    Res         :: integer().               %% 结果码： 1 成功， 2物品类型不存在, 3 背包数量不足, 4动态属性设置权限不足, 5列表中GoodsTypeId重复
%% ---------------------------------------------------------------------------

%% (列表中GoodsTypeId不能重复)
%% !! 请确保列表里面只有物品，不能有其它格式的  !!
%% GoodsList = [{GoodsTypeId, GoodsNum }, ...]
%% GoodsList = [{?TYPE_GOODS, GoodsTypeId, GoodsNum }, ...]
%% GoodsList = [{?TYPE_BIND_GOODS, GoodsNum }, ...]
%% GoodsList = [{goods, GoodsTypeId, GoodsNum }, ...]
%% GoodsList = [{goods, GoodsTypeId, GoodsNum, BindBind(0非绑1绑定)}, ...]
%% GoodsList = [{goods, GoodsTypeId, GoodsNum, Bind, ExpireTime, LockTime}, ...]
%% GoodsList = [{goods_attr, GoodsTypeId, GoodsNum, AttrList}, ...]
%% GoodsList = [{info, GoodsInfo }, ...]
%% return ErrorCode|{1, GoodsInfoList}
give_goods_by_list(PlayerInfo, GoodsList, Type, SubType) ->
    Produce = #produce{type = Type, subtype = SubType, remark = ""},
    give_goods_by_list(PlayerInfo, GoodsList, Produce).

give_goods_by_list(PlayerInfo, GoodsList) ->
    give_goods_by_list(PlayerInfo, GoodsList, "", 0).

give_goods_by_list(PlayerInfo, GoodsList, Produce) when GoodsList=/=[] ->
    #produce{type = Type, subtype = SubType, remark = Remark} = Produce,
    {PlayerId, Pid} = get_id_pid(PlayerInfo),
    Res = case Pid =:= self() of
        true ->
            lib_goods_do:give_more(GoodsList);
        false ->
            ?NOT_IN_PLAYER_PROCESS(0)
    end,
    case Res of
        {ErrorCode, _GoodsInfoList, RewardResult} when ErrorCode == 1 ->
            case Type =/= [] of
                true ->
                    GoodsList2 = maps:get(?REWARD_RESULT_SUCC, RewardResult, []),
                    Fun = fun(OneAdd) ->
                        {GoodsTypeId, GoodsNum} = case OneAdd of
                            {goods, TypeId, Num} -> {TypeId, Num};
                            {?TYPE_GOODS, TypeId, Num} -> {TypeId, Num};
                            {?TYPE_BIND_GOODS, TypeId, Num} -> {TypeId, Num};
                            {goods, TypeId, Num, _Bind} -> {TypeId, Num};
                            {goods, TypeId, Num, _Bind, _ExpireTime, _LockTime} -> {TypeId, Num};
                            {info, Goods} -> {Goods#goods.goods_id, Goods#goods.num};
                            {goods_attr, TypeId, Num, _DyAttrList} -> {TypeId, Num};
                            {TypeId, Num} -> {TypeId, Num}
                        end,
                        lib_log_api:log_goods(Type, SubType, GoodsTypeId, GoodsNum, PlayerId, Remark)
                    end,
                    [Fun(OneAdd) || OneAdd <- GoodsList2];
                false -> skip
            end;
        _ -> skip
    end,
    Res;
give_goods_by_list(_PlayerInfo, GoodsList, _Produce) ->
    ?ERR("~p:~p param error:~p", [?MODULE, ?LINE, GoodsList]),
    0.

%% ---------------------------------------------------------------------------
%% @doc 发物品到指定背包(列表中GoodsTypeId不能重复)
%% 某些特定活动才能调用这个接口！！！！！！！！
-spec give_goods_to_specify_loc(Player, GoodsList, Type, SubType, Location) -> Res when
    Player      :: #player_status{},        %% 玩家记录
    GoodsList   :: [tuple()],               %% 物品列表 具体格式参照上面
    Type        :: atom(),                  %% 物品产出类型
                                            %% 需要后台定义"产出消耗类型--产出类型"
    SubType     :: integer(),               %% 物品产出子类型
    Location    :: integer(),               %% 所发奖励要统一放到哪个背包
    Res         :: integer().               %% 结果码： 1 成功， 2物品类型不存在, 3 背包数量不足, 4动态属性设置权限不足, 5列表中GoodsTypeId重复
%% ---------------------------------------------------------------------------

%% (列表中GoodsTypeId不能重复)
%% GoodsList = [{location, Location, GoodsTypeId, GoodsNum }, ...]
%% return ErrorCode|{1, GoodsInfoList}
give_goods_to_specify_loc(PlayerInfo, Location, GoodsList) ->
    give_goods_to_specify_loc(PlayerInfo, Location, GoodsList, "", 0).

give_goods_to_specify_loc(PlayerInfo, Location, GoodsList, Type, SubType) ->
    Produce = #produce{type = Type, subtype = SubType, remark = ""},
    give_goods_to_specify_loc(PlayerInfo, Location, GoodsList, Produce).

give_goods_to_specify_loc(PlayerInfo, Location, GoodsList, Produce) when GoodsList =/= [] ->
    #produce{type = Type, subtype = SubType, remark = Remark} = Produce,
    {PlayerId, Pid} = get_id_pid(PlayerInfo),
    Res = case Pid =:= self() of
        true ->
            lib_goods_do:give_more_to_specify_loc(Location, GoodsList);
        false ->
            ?NOT_IN_PLAYER_PROCESS(0)
    end,
    case Res of
        {ErrorCode, _GoodsInfoList, RewardResult} when ErrorCode == 1 ->
            case Type =/= [] of
                true ->
                    GoodsList2 = maps:get(?REWARD_RESULT_SUCC, RewardResult, []),
                    Fun = fun(OneAdd) ->
                        {GoodsTypeId, GoodsNum} = case OneAdd of
                            {location, _Location, TypeId, Num} -> {TypeId, Num};
                            {?TYPE_GOODS, TypeId, Num} -> {TypeId, Num}
                        end,
                        lib_log_api:log_goods(Type, SubType, GoodsTypeId, GoodsNum, PlayerId, Remark)
                    end,
                    [Fun(OneAdd) || OneAdd <- GoodsList2],
                    handle_send_reward_result(ErrorCode, PlayerId, RewardResult, [], Produce);
                false -> skip
            end;
        _ -> skip
    end,
    Res;
give_goods_to_specify_loc(_PlayerInfo, Location, GoodsList, _Produce) ->
    ?ERR("give_goods_to_specify_loc:~p error:~p", [Location, GoodsList]),
    0.

%% 发放奖励
%% @return ok | false
send_reward_by_id(RewardList, ProduceType, Id) ->
    send_reward_by_id(RewardList, ProduceType, 0, Id).
send_reward_by_id(RewardList, ProduceType, SubType, Id) ->
    Produce = #produce{type = ProduceType, subtype = SubType, reward = RewardList, remark = ""},
    send_reward_by_id(Produce, Id).

send_reward_by_id(RewardList, ProduceType, SubType, Id, ShowTips) ->
    Produce = #produce{type = ProduceType, subtype = SubType, reward = RewardList, remark = "", show_tips = ShowTips},
    send_reward_by_id(Produce, Id).

send_reward_by_id(Produce, Id) ->
    Pid = misc:get_player_process(Id),
    case misc:is_process_alive(Pid) of
        true -> send_reward_by_pid(Produce, Pid);
        false -> false
    end.

%% 发放奖励
send_reward_by_pid(RewardList, ProduceType, Pid) ->
    send_reward_by_pid(RewardList, ProduceType, Pid, 0).
send_reward_by_pid(RewardList, ProduceType, Pid, SubType) ->
    Produce = #produce{type = ProduceType, subtype = SubType, reward = RewardList, remark = ""},
    send_reward_by_pid(Produce, Pid).

send_reward_by_pid(Produce, Pid) ->
    gen_server:cast(Pid, {'send_reward', Produce}).

%% ---------------------------------------------------------------------------
%% @doc 发送奖励
-spec send_reward(PS, RewardList, ProduceType, SubType) -> Return when
    PS          :: #player_status{}, %% 玩家记录
    RewardList  :: list(),      %% RewardList = [{coin,0,数量},{gold,0,数量},{goods,物品ID,物品数量},{physical,0,数量}]
    ProduceType :: atom(),      %% 需要后台定义"产出消耗类型--产出类型"
    SubType     :: integer(),   %% 子类型,主要是怪物的产出
    Return      :: #player_status{}. %% 玩家记录
%% ---------------------------------------------------------------------------
%% description: 发放的奖励含有装备(有背包数量限制)，建议使用 send_reward_with_mail
send_reward(PS, RewardList, ProduceType, SubType) ->
    send_reward(PS, #produce{type = ProduceType, subtype = SubType, reward = RewardList, remark = ""}).

send_reward(PS, RewardList, ProduceType, SubType, ShowTips) ->
    send_reward(PS, #produce{type = ProduceType, subtype = SubType, reward = RewardList, remark = "", show_tips = ShowTips}).

%% 建议使用
send_reward(PS, Produce) ->
    {PS1, Produce1} = spilt_reward_when_onhook(PS, Produce),
    #produce{reward = RewardList} = Produce1,
    {LocLimitReward, _LocNotLimitReward} = split_reward_with_location(RewardList),
    case lib_goods_api:can_give_goods(PS1, LocLimitReward) of
        true ->
            {ok, NewPS, _UpGoodsList} = send_reward_return_goods(PS1, Produce1);
        {false, _Errcode} -> 
            UniqueRewardList = make_reward_unique(RewardList),
            send_mail_when_no_cell(PS1#player_status.id, Produce1, UniqueRewardList),
            NewPS = PS1
    end,
    NewPS. 

%%%  -------------------------------------------------------
%%%   该接口是不检查背包空间，请使用 lib_goods_api:send_reward_with_mail_return_goods
%%%   如果要使用，请先自行检查背包空间
%%%  --------------------------------------------------------
%% 发奖奖励,并且返还goods,
%% @return {ok, PS, UpGoodsList} 
%%  UpGoodsList:[#goods{}],客户端需要更新的GoodsList,返回更新物品列表操作.
send_reward_return_goods(PS, Produce) ->
    {PS1, Produce1} = spilt_reward_when_onhook(PS, Produce),
    #produce{reward = RewardList} = Produce1,
    send_reward_helper(PS1, RewardList, [], [], Produce1).

%% @return {ok, PS, UpGoodsList} 
%%  UpGoodsList:[#goods{}],客户端需要更新的GoodsList,返回更新物品列表操作.
send_reward_helper(PS, [], CoinList, [], Produce) ->
    #produce{show_tips = ShowTips} = Produce,
    ?IF(ShowTips=/=0, send_tv_tip(PS#player_status.id, ShowTips, CoinList), skip),
    {ok, PS, []};
send_reward_helper(PS, [], CoinList, GoodsList, Produce) ->
    #produce{show_tips = ShowTips, reward = _RewardList} = Produce,
    UniqueGoodsList = make_reward_unique(GoodsList),
    F = fun
    ({?TYPE_GOODS, GoodsTypeId, GoodsNum}) -> 
        case data_goods_type:get(GoodsTypeId) of 
            #ets_goods_type{bind = BindCfg} -> ok;
            _ -> BindCfg = ?UNBIND
        end,
        {goods, GoodsTypeId, GoodsNum, BindCfg};
    ({?TYPE_GOODS, GoodsTypeId, GoodsNum, Bind}) -> 
        {goods, GoodsTypeId, GoodsNum, Bind};
    ({?TYPE_BIND_GOODS, GoodsTypeId, GoodsNum}) ->
        case data_goods_type:get(GoodsTypeId) of 
            #ets_goods_type{type = Type, bind = BindCfg} when Type == ?GOODS_TYPE_DRAGON_EQUIP orelse Type == ?GOODS_TYPE_DRAGON_THING -> 
                Bind = BindCfg;
            _ -> Bind = ?BIND
        end,
        {goods, GoodsTypeId, GoodsNum, Bind};
    ({?TYPE_ATTR_GOODS, GoodsTypeId, GoodsNum, DyAttrList}) ->
        {goods_attr, GoodsTypeId, GoodsNum, DyAttrList}
    end,
    GoodsList2 = lists:map(F, UniqueGoodsList),
    case give_goods_by_pile(PS, GoodsList2, Produce) of
        {1, UpGoodsList, RewardResult} ->
            % ?PRINT("send_reward_helper RewardResult ~p~n", [RewardResult]),
            RewardGive = maps:get(?REWARD_RESULT_SUCC, RewardResult, []),
            FF = fun({ ?TYPE_GOODS, GoodsTypeId, GoodsNum}) -> {GoodsTypeId, GoodsNum};
                   ({ ?TYPE_BIND_GOODS, GoodsTypeId, GoodsNum}) -> {GoodsTypeId, GoodsNum}
                end,
            FFGoodsList = lists:map(FF, RewardGive),
            %% 触发任务收集
            lib_task_api:collect_goods(PS, FFGoodsList),
            lib_task_api:add_stuff(PS, FFGoodsList),
            lib_supreme_vip_api:collect_goods(PS#player_status.id, FFGoodsList),
            %%
            if
                PS#player_status.online == ?ONLINE_OFF_ONHOOK -> %% 计算装备
                    lib_player:apply_cast(PS#player_status.id, ?APPLY_CAST_SAVE, lib_onhook, calc_onhook_pickup_goods, [FFGoodsList]);
                PS#player_status.online == ?ONLINE_ON ->
                    ?IF(ShowTips=/=0, send_tv_tip(PS#player_status.id, ShowTips, RewardGive++CoinList), skip);
                true ->
                    skip
            end,
            handle_send_reward_result(1, PS#player_status.id, RewardResult, [], Produce),
            {ok, PS, UpGoodsList};
        {Res, UpGoodsList, ErrorGoodsList, RewardResult} ->
            RewardGive = maps:get(?REWARD_RESULT_SUCC, RewardResult, []),
            %?ERR("[ERROR]:lib_goods_api:send_reward_helper/5 Res=~p~n", [{Res, ErrorGoodsList}]),
            ?IF(ShowTips=/=0, send_tv_tip(PS#player_status.id, ShowTips, RewardGive++CoinList), skip),
            handle_send_reward_result(Res, PS#player_status.id, RewardResult, ErrorGoodsList, Produce),
            {ok, PS, UpGoodsList}
    end;
send_reward_helper(PS, [H|T], CoinList, GoodsList, Produce) ->
    #produce{type = ProduceType, subtype = ProduceSubtype, remark = Remark} = Produce,
    case H of
        {?TYPE_COIN, _, Coin} ->
            NewPS = lib_goods_util:add_money(PS, Coin, coin),
            lib_log_api:log_produce(ProduceType, coin, PS, NewPS, Remark),
            send_reward_helper(NewPS, T, [{?TYPE_COIN, 0, Coin}|CoinList], GoodsList, Produce);
        {?TYPE_COIN, Coin} ->
            NewPS = lib_goods_util:add_money(PS, Coin, coin),
            lib_log_api:log_produce(ProduceType, coin, PS, NewPS, Remark),
            send_reward_helper(NewPS, T, [{?TYPE_COIN, 0, Coin}|CoinList], GoodsList, Produce);

        {?TYPE_GOLD, _, Gold} ->
            NewPS = lib_goods_util:add_money(PS, Gold, gold),
            lib_log_api:log_produce(ProduceType, gold, PS, NewPS, Remark),
            send_reward_helper(NewPS, T, [{?TYPE_GOLD, 0, Gold}|CoinList], GoodsList, Produce);
        {?TYPE_GOLD, Gold} ->
            NewPS = lib_goods_util:add_money(PS, Gold, gold),
            lib_log_api:log_produce(ProduceType, gold, PS, NewPS, Remark),
            send_reward_helper(NewPS, T, [{?TYPE_GOLD, 0, Gold}|CoinList], GoodsList, Produce);

        {?TYPE_BGOLD, _, BGold} ->
            NewPS = lib_goods_util:add_money(PS, BGold, bgold),
            lib_log_api:log_produce(ProduceType, bgold, PS, NewPS, Remark),
            send_reward_helper(NewPS, T, [{?TYPE_BGOLD, 0, BGold}|CoinList], GoodsList, Produce);
        {?TYPE_BGOLD, BGold} ->
            NewPS = lib_goods_util:add_money(PS, BGold, bgold),
            lib_log_api:log_produce(ProduceType, bgold, PS, NewPS, Remark),
            send_reward_helper(NewPS, T, [{?TYPE_BGOLD, 0, BGold}|CoinList], GoodsList, Produce);

        %% {?TYPE_GCOIN, _, Gcoin} ->
        %%     NewPS = lib_goods_util:add_money(PS, Gcoin, gcoin),
        %%     lib_log_api:log_produce(ProduceType, gcoin, PS, NewPS, Remark),
        %%     send_reward_helper(NewPS, T, GoodsList, Produce);

        {?TYPE_EXP, _, Exp} when ProduceType==task ->
            NewPS = lib_player:add_exp(PS, Exp, ?ADD_EXP_TASK, []),
            send_reward_helper(NewPS, T, [{?TYPE_EXP, 0, Exp}|CoinList], GoodsList, Produce);
        {?TYPE_EXP, Exp} when ProduceType==task ->
            NewPS = lib_player:add_exp(PS, Exp, ?ADD_EXP_TASK, []),
            send_reward_helper(NewPS, T, [{?TYPE_EXP, 0, Exp}|CoinList], GoodsList, Produce);

        {?TYPE_EXP, _, Exp} when ProduceType==dungeon ->
            NewPS = lib_player:add_exp(PS, Exp, ?ADD_EXP_DUN, [{dun_id, ProduceSubtype}]),
            send_reward_helper(NewPS, T, [{?TYPE_EXP, 0, Exp}|CoinList], GoodsList, Produce);
        {?TYPE_EXP, Exp} when ProduceType==dungeon ->
            NewPS = lib_player:add_exp(PS, Exp, ?ADD_EXP_DUN, [{dun_id, ProduceSubtype}]),
            send_reward_helper(NewPS, T, [{?TYPE_EXP, 0, Exp}|CoinList], GoodsList, Produce);

        {?TYPE_EXP, _, Exp} when ProduceType==midday_party ->
            NewPS = lib_player:add_exp(PS, Exp, ?ADD_EXP_MIDDAY_PARTY, []),
            send_reward_helper(NewPS, T, [{?TYPE_EXP, 0, Exp}|CoinList], GoodsList, Produce);
        {?TYPE_EXP, Exp} when ProduceType==midday_party ->
            NewPS = lib_player:add_exp(PS, Exp, ?ADD_EXP_MIDDAY_PARTY, []),
            send_reward_helper(NewPS, T, [{?TYPE_EXP, 0, Exp}|CoinList], GoodsList, Produce);
    
        {?TYPE_EXP, _, Exp} when ProduceType==guild_feast ->
            NewPS = lib_player:add_exp(PS, Exp, ?ADD_EXP_GUILD_FEAST, []),
            send_reward_helper(NewPS, T, [{?TYPE_EXP, 0, Exp}|CoinList], GoodsList, Produce);
        {?TYPE_EXP, _, Exp} when ProduceType==holy_spirit_battlefield_exp ->
            NewPS = lib_player:add_exp(PS, Exp, ?ADD_EXP_HOLY_SPIRIT_BATTLEFIELD, []),
            send_reward_helper(NewPS, T, [{?TYPE_EXP, 0, Exp}|CoinList], GoodsList, Produce);
        {?TYPE_EXP, _, Exp} when ProduceType==sea_craft_carry_brick_reward ->
            NewPS = lib_player:add_exp(PS, Exp, ?ADD_EXP_SEA_DAILY, []),
            send_reward_helper(NewPS, T, [{?TYPE_EXP, 0, Exp}|CoinList], GoodsList, Produce);
        {?TYPE_EXP, Exp} when ProduceType==guild_feast ->
            NewPS = lib_player:add_exp(PS, Exp, ?ADD_EXP_GUILD_FEAST, []),
            send_reward_helper(NewPS, T, [{?TYPE_EXP, 0, Exp}|CoinList], GoodsList, Produce);
        {?TYPE_EXP, Exp} when ProduceType==holy_spirit_battlefield_exp ->
            NewPS = lib_player:add_exp(PS, Exp, ?ADD_EXP_HOLY_SPIRIT_BATTLEFIELD, []),
            send_reward_helper(NewPS, T, [{?TYPE_EXP, 0, Exp}|CoinList], GoodsList, Produce);
        {?TYPE_EXP, _, Exp} when ProduceType==onhook_reward ->
            NewPS = lib_player:add_exp(PS, Exp, ?ADD_EXP_ONHOOK, []),
            send_reward_helper(NewPS, T, [{?TYPE_EXP, 0, Exp}|CoinList], GoodsList, Produce);
        {?TYPE_EXP, Exp} when ProduceType==onhook_reward ->
            NewPS = lib_player:add_exp(PS, Exp, ?ADD_EXP_ONHOOK, []),
            send_reward_helper(NewPS, T, [{?TYPE_EXP, 0, Exp}|CoinList], GoodsList, Produce);
        {?TYPE_EXP, _, Exp} when ProduceType==afk_trigger ->
            NewPS = lib_player:add_exp(PS, Exp, ?ADD_EXP_AFK, []),
            send_reward_helper(NewPS, T, [{?TYPE_EXP, 0, Exp}|CoinList], GoodsList, Produce);

        {?TYPE_EXP, _, Exp} ->
            NewPS = lib_player:add_exp(PS, Exp),
            send_reward_helper(NewPS, T, [{?TYPE_EXP, 0, Exp}|CoinList], GoodsList, Produce);
        {?TYPE_EXP, Exp} ->
            NewPS = lib_player:add_exp(PS, Exp),
            send_reward_helper(NewPS, T, [{?TYPE_EXP, 0, Exp}|CoinList], GoodsList, Produce);

        % 增加名誉
        {?TYPE_FAME, _, Num} ->
            NewPS = lib_flower_api:add_fame(PS, Num, [{produce, ProduceType}]),
            send_reward_helper(NewPS, T, [{?TYPE_FAME, 0, Num}|CoinList], GoodsList, Produce);

        % 增加魅力值
        {?TYPE_CHARM, _, Num} ->
            NewPS = lib_flower_api:add_charm(PS, Num, [{produce, ProduceType}]),
            send_reward_helper(NewPS, T, [{?TYPE_CHARM, 0, Num}|CoinList], GoodsList, Produce);

        {?TYPE_GFUNDS, _, Gfunds} ->
            #player_status{id = RoleId} = PS,
            mod_guild:add_gfunds(RoleId, PS#player_status.guild#status_guild.id, Gfunds, ProduceType),
            send_reward_helper(PS, T, [{?TYPE_GFUNDS, 0, Gfunds}|CoinList], GoodsList, Produce);

        {?TYPE_GFUNDS, Gfunds} ->
            #player_status{id = RoleId} = PS,
            mod_guild:add_gfunds(RoleId, PS#player_status.guild#status_guild.id, Gfunds, ProduceType),
            send_reward_helper(PS, T, [{?TYPE_GFUNDS, 0, Gfunds}|CoinList], GoodsList, Produce);

        {?TYPE_GDONATE, _, Donate} ->
            mod_guild:add_donate(PS#player_status.id, Donate, ProduceType, {produce, ProduceType}),
            send_reward_helper(PS, T, [{?TYPE_GDONATE, 0, Donate}|CoinList], GoodsList, Produce);

        {?TYPE_GDONATE, Donate} ->
            mod_guild:add_donate(PS#player_status.id, Donate, ProduceType, {produce, ProduceType}),
            send_reward_helper(PS, T, [{?TYPE_GDONATE, 0, Donate}|CoinList], GoodsList, Produce);

        {?TYPE_SEA_EXPLOIT, _, Exploit} ->
            NewPs = lib_seacraft_extra_api:add_exploit(PS, Exploit, {produce, ProduceType}),
            send_reward_helper(NewPs, T, [{?TYPE_SEA_EXPLOIT, 0, Exploit}|CoinList], GoodsList, Produce);

        {?TYPE_SEA_EXPLOIT, Exploit} ->
            NewPs = lib_seacraft_extra_api:add_exploit(PS, Exploit, {produce, ProduceType}),
            send_reward_helper(NewPs, T, [{?TYPE_SEA_EXPLOIT, 0, Exploit}|CoinList], GoodsList, Produce);

        {?TYPE_GUILD_PRESTIGE, _, Num} ->
            mod_guild_prestige:add_prestige([PS#player_status.id, ProduceType, ?GOODS_ID_GUILD_PRESTIGE, Num, 0]),
            send_reward_helper(PS, T, [{?TYPE_GUILD_PRESTIGE, ?GOODS_ID_GUILD_PRESTIGE, Num}|CoinList], GoodsList, Produce);

        {?TYPE_GUILD_DRAGON_MAT, _, GGragonVal} ->
            mod_guild_boss:add_gboss_mat(PS#player_status.id, PS#player_status.guild#status_guild.id, GGragonVal, ProduceType),
            send_reward_helper(PS, T, [{?TYPE_GUILD_DRAGON_MAT, 0, GGragonVal}|CoinList], GoodsList, Produce);

        {?TYPE_GUILD_DRAGON_MAT, GGragonVal} ->
            mod_guild_boss:add_gboss_mat(PS#player_status.id, PS#player_status.guild#status_guild.id, GGragonVal, ProduceType),
            send_reward_helper(PS, T, [{?TYPE_GUILD_DRAGON_MAT, 0, GGragonVal}|CoinList], GoodsList, Produce);

        {?TYPE_GUILD_ACTIVITY, _, GActivity} ->
            #player_status{id = RoleId} = PS,
            mod_guild:add_gactivity(RoleId, PS#player_status.guild#status_guild.id, GActivity, ProduceType),
            send_reward_helper(PS, T, [{?TYPE_GUILD_ACTIVITY, 0, GActivity}|CoinList], GoodsList, Produce);

        {?TYPE_GUILD_ACTIVITY, GActivity} ->
            #player_status{id = RoleId} = PS,
            mod_guild:add_gactivity(RoleId, PS#player_status.guild#status_guild.id, GActivity, ProduceType),
            send_reward_helper(PS, T, [{?TYPE_GUILD_ACTIVITY, 0, GActivity}|CoinList], GoodsList, Produce);

        {?TYPE_FASHION_NUM, PosId, Num} ->
            GoodsStatus = lib_goods_do:get_goods_status(),
            NewGoodsStatus = lib_fashion:fashion_add_upgrade_num(PosId, Num, GoodsStatus),
            lib_goods_do:set_goods_status(NewGoodsStatus),
            send_reward_helper(PS, T, [{?TYPE_FASHION_NUM, PosId, Num}|CoinList], GoodsList, Produce);

        {?TYPE_RUNE, _, Num} ->
            GoodsStatus = lib_goods_do:get_goods_status(),
            NewGoodsStatus = lib_rune:add_rune_point(Num, GoodsStatus),
            lib_goods_do:set_goods_status(NewGoodsStatus),
            #player_status{id = RoleId} = PS,
            lib_log_api:log_goods(ProduceType, ProduceSubtype, ?TYPE_RUNE, Num, RoleId, Remark),
            send_reward_helper(PS, T, [{?TYPE_RUNE, 0, Num}|CoinList], GoodsList, Produce);

        {?TYPE_SOUL, _, Num} ->
            GoodsStatus = lib_goods_do:get_goods_status(),
            NewGoodsStatus = lib_soul:add_soul_point(Num, GoodsStatus),
            lib_goods_do:set_goods_status(NewGoodsStatus),
            send_reward_helper(PS, T, [{?TYPE_SOUL, 0, Num}|CoinList], GoodsList, Produce);

        {?TYPE_RUNE_CHIP, _, Num} ->
            GoodsStatus = lib_goods_do:get_goods_status(),
            NewGoodsStatus = lib_rune:add_rune_chip(Num, GoodsStatus),
            lib_goods_do:set_goods_status(NewGoodsStatus),
            send_reward_helper(PS, T, [{?TYPE_RUNE_CHIP, 0, Num}|CoinList], GoodsList, Produce);

        {?TYPE_HONOUR, _, Num} ->
            NewPS = lib_jjc:add_honour(PS, Num),
            lib_log_api:log_produce_honour(ProduceType, PS, NewPS, Remark),
            send_reward_helper(NewPS, T, [{?TYPE_HONOUR, 0, Num}|CoinList], GoodsList, Produce);

        {?TYPE_GUILD_GROWTH, _, Val} ->
            #player_status{id = RoleId} = PS,
            mod_guild:add_growth(RoleId, PS#player_status.guild#status_guild.id, Val, ProduceType, []),
            send_reward_helper(PS, T, [{?TYPE_GUILD_GROWTH, 0, Val}|CoinList], GoodsList, Produce);

        {?TYPE_CURRENCY, CurrencyId, Val} ->
            NewPS = lib_goods_util:add_currency(PS, CurrencyId, Val),
            lib_log_api:log_produce(ProduceType, ?CURRENCY, PS, NewPS, {CurrencyId, Remark}),
            send_reward_helper(NewPS, T, [{?TYPE_CURRENCY, CurrencyId, Val}|CoinList], GoodsList, Produce);

        {?TYPE_GOODS, GoodsTypeId, GoodsNum} ->
            AttrList = get_attr_goods(PS, GoodsTypeId),
            Item = ?IF(AttrList == [], H, {?TYPE_ATTR_GOODS, GoodsTypeId, GoodsNum, AttrList}),
            NewGoodsList = [Item|GoodsList],
            send_reward_helper(PS, T, CoinList, NewGoodsList, Produce);

        {?TYPE_GOODS, GoodsTypeId, GoodsNum, Bind} ->
            AttrList = get_attr_goods(PS, GoodsTypeId),
            Item = ?IF(AttrList == [], H, {?TYPE_ATTR_GOODS, GoodsTypeId, GoodsNum, [{bind, Bind}|AttrList]}),
            NewGoodsList = [Item|GoodsList],
            send_reward_helper(PS, T, CoinList, NewGoodsList, Produce);

        {?TYPE_BIND_GOODS, GoodsTypeId, GoodsNum} ->
            AttrList = get_attr_goods(PS, GoodsTypeId),
            Item = ?IF(AttrList == [], H, {?TYPE_ATTR_GOODS, GoodsTypeId, GoodsNum, [{bind, ?BIND}|AttrList]}),
            NewGoodsList = [Item|GoodsList],
            send_reward_helper(PS, T, CoinList, NewGoodsList, Produce);

        {Type = ?TYPE_ATTR_GOODS, GoodsTypeId, GoodsNum, AttrList} ->
            NewGoodsList = [{Type, GoodsTypeId, GoodsNum, AttrList}|GoodsList],
            send_reward_helper(PS, T, CoinList, NewGoodsList, Produce)   
    end.

%% 将一些特殊物品转成attr_goods
get_attr_goods(PS, GoodsTypeId) ->
    #player_status{figure = #figure{lv = RoleLv}} = PS,
    case data_goods_type:get(GoodsTypeId) of
        #ets_goods_type{type = ?GOODS_TYPE_GIFT} ->
            IsLvGift = lib_gift_new:is_lv_gift(GoodsTypeId),
            IsRuneGift = lib_gift_new:is_rune_gift(GoodsTypeId),
            IsOpenDayGift = lib_gift_new:is_open_day_gift(GoodsTypeId),
            if
                IsLvGift andalso IsRuneGift andalso IsOpenDayGift ->
                    [{role_lv, RoleLv}, {rune_lv, lib_dungeon_rune:get_dungeon_level(PS)}, {open_day, util:get_open_day()}];
                IsLvGift -> [{role_lv, RoleLv}];
                IsRuneGift -> [{rune_lv, lib_dungeon_rune:get_dungeon_level(PS)}];
                IsOpenDayGift -> [{open_day, util:get_open_day()}];
                true ->
                    []
            end;
        _ ->
            []
    end.


%% 分离堆奖励后,发送物品
%% 处理奖励列表中出现同类型的的物品（比如存在绑定和非绑定的相同物品类型）
%% @return {1, [生成物品的结构(#goods{}),...], 物品发送结果列表} | {Res, [生成物品的结构(#goods{}),...], 没有发送成功的物品列表, 物品发送结果列表}
give_goods_by_pile(PlayerInfo, GoodsList, Produce) when GoodsList=/=[] ->
    PileList = spilt_reward_pile(GoodsList),
    % ?INFO("give_goods_by_pile GoodsList:~w PileList:~w ~n", [GoodsList, PileList]),
    do_give_goods_by_pile(PileList, PlayerInfo, Produce, [], #{});
give_goods_by_pile(_PlayerInfo, GoodsList, _Produce) ->
    ?ERR("~p:~p param error:~p", [?MODULE, ?LINE, GoodsList]),
    {0, [], [], #{}}.

do_give_goods_by_pile([], _PlayerInfo, _Produce, SumGoodsInfoList, RewardResult) -> {1, SumGoodsInfoList, RewardResult};
do_give_goods_by_pile([GoodsList|PileList] = L, PlayerInfo, Produce, SumGoodsInfoList, RewardResult) ->
    case give_goods_by_list(PlayerInfo, GoodsList, Produce) of
        {1, GoodsInfoList, RewardResult1} -> 
            NewRewardResult = combine_reward_result(RewardResult1, RewardResult),
            do_give_goods_by_pile(PileList, PlayerInfo, Produce, GoodsInfoList++SumGoodsInfoList, NewRewardResult);
        Res -> {Res, SumGoodsInfoList, lists:flatten(L), RewardResult}
    end.

combine_reward_result(RewardResult1, RewardResult2) ->
    F = fun(Key, ObjectList, Map) ->
        CombineList = maps:get(Key, Map, []),
        NObjectList = ulists:object_list_plus([CombineList, ObjectList]),
        maps:put(Key, NObjectList, Map)
    end,
    maps:fold(F, RewardResult1, RewardResult2).

%% 分离堆奖励,保证GoodsTypeId不唯一
%% GoodsList = [{GoodsTypeId, GoodsNum }, ...]
%% GoodsList = [{goods, GoodsTypeId, GoodsNum }, ...]
%% GoodsList = [{goods, GoodsTypeId, GoodsNum, BindBind(0非绑1绑定)}, ...]
%% GoodsList = [{goods, GoodsTypeId, GoodsNum, Bind, ExpireTime, LockTime}, ...]
%% GoodsList = [{goods_attr, GoodsTypeId, GoodsNum, AttrList}, ...]
%% GoodsList = [{info, GoodsInfo }, ...]
spilt_reward_pile(GoodsList) ->
    spilt_reward_pile(GoodsList, []).

%% 分离奖励组
%% @return [组1列表,组2列表,...] 每一个组别内的GoodsTypeId都不一样
spilt_reward_pile([], L) -> L;
spilt_reward_pile([H|T], L) ->
    NewL = spilt_reward_pile_help(L, H, []),
    spilt_reward_pile(T, NewL).

spilt_reward_pile_help([], Key, L) ->
    lists:reverse([[Key]]++L);
spilt_reward_pile_help([GoodsList|T], Key, L) ->
    case is_same(Key, GoodsList) of
        true -> spilt_reward_pile_help(T, Key, [GoodsList|L]);
        false ->
            NewGoodsList = lists:reverse([Key|GoodsList]),
            lists:reverse(L) ++ [NewGoodsList] ++ T
    end.

%% 是否存在相同Key值
is_same(Key, GoodsList) ->
    case Key of
        {GoodsTypeId, _GoodsNum} when is_integer(GoodsTypeId) -> ok;
        {goods, GoodsTypeId, _GoodsNum} -> ok;
        {goods, GoodsTypeId, _GoodsNum, _Bind} -> ok;
        {goods, GoodsTypeId, _GoodsNum, _Bind, _ExpireTime, _LockTime} -> ok;
        {goods_attr, GoodsTypeId, _GoodsNum, _AttrList} -> ok;
        {info, #goods{goods_id = GoodsTypeId}} -> ok
    end,
    is_same_help(GoodsList, GoodsTypeId).

is_same_help([], _GoodsTypeId) -> false;
is_same_help([{GoodsTypeId, _GoodsNum}|_T], GoodsTypeId) -> true;
is_same_help([{goods, GoodsTypeId, _GoodsNum}|_T], GoodsTypeId) -> true;
is_same_help([{goods, GoodsTypeId, _GoodsNum, _Bind}|_T], GoodsTypeId) -> true;
is_same_help([{goods, GoodsTypeId, _GoodsNum, _Bind, _ExpireTime, _LockTime}|_T], GoodsTypeId) -> true;
is_same_help([{goods_attr, GoodsTypeId, _GoodsNum, _AttrList}|_T], GoodsTypeId) -> true;
is_same_help([{info, #goods{goods_id = GoodsTypeId}}|_T], GoodsTypeId) -> true;
is_same_help([_|T], GoodsTypeId) -> is_same_help(T, GoodsTypeId).

%% ---------------------------------------------------------------------------
%% @doc 扣取货币，写入消耗日志
-spec cost_money(Status, MoneyType, Money, ConsumeType, ABout) ->  Return when
    Status      :: #player_status{},    %% 玩家记录
    MoneyType   :: atom(),              %% coin | gold
    Money       :: integer(),           %% 数量
    ConsumeType :: atom(),              %% 消费类型
    ABout       :: list(),              %% [] | string 备注
    Return      :: {Res::integer, #player_status{} }. %% {错误码(0:货币不足，1成功), 玩家记录}
%% ---------------------------------------------------------------------------
cost_money(Status, MoneyType, Money, ConsumeType, ABout) ->
    case lib_goods_util:is_enough_money(Status, Money, MoneyType) of
        true ->
            NewPSTmp = record_cost_when_onhook(Status, Money, MoneyType, ConsumeType),
            NewPS = lib_goods_util:cost_money(NewPSTmp, Money, MoneyType, ConsumeType, ABout),
            {1, NewPS};
        false ->
            {0, Status}
    end.

%% @doc 获取货币数量（离线版）
-spec get_money_offline(PlayerId, MoneyType) ->  Return when
    PlayerId       :: integer(),          %% 玩家Id
    MoneyType      :: atom(),             %% 货币类型
    Return         :: integer().          %% 金钱数量
%% ---------------------------------------------------------------------------
get_money_offline(PlayerId, MoneyType) ->
    lib_goods_util:get_money_offline(PlayerId, MoneyType).

%% @doc 扣钱（离线版）
-spec cost_money_offline(PlayerId, Cost, MoneyType, Type, About) ->  Return when
    PlayerId       :: integer(),          %% 玩家Id
    Cost           :: integer(),          %% 数量
    MoneyType      :: atom(),             %% 货币类型
    Type           :: atom(),             %% 货币消耗类型：需要后台定义"产出消耗类型--货币消耗"
    About          :: string(),           %% 扣钱描述
    Return         :: #player_status{}.   %% #player_status{}
cost_money_offline(PlayerId, Cost, MoneyType, Type, About) ->
    lib_goods_util:cost_money_offline(PlayerId, Cost, MoneyType, Type, About).

%% ---------------------------------------------------------------------------
%% @doc 扣取多种货币，未全部成功会返回已扣部分
-spec cost_money(PS, MoneyList, ConsumeType, ABout) ->  Return when
    PS          :: #player_status{},    %% 玩家记录
    MoneyList   :: list(),              %% [{MoneyType, Money}]
    ConsumeType :: atom(),              %% 消费类型
    ABout       :: list(),              %% [] | string 备注
    Return      :: {Res::integer, #player_status{} }. %% {错误码(0:货币不足，1成功), 玩家记录}
%% ---------------------------------------------------------------------------
cost_money(PS, MoneyList, ConsumeType, ABout) ->
    cost_money_helper(PS, MoneyList, ConsumeType, ABout, []).

cost_money_helper(PS, [], _ConsumeType, _ABout, _L) -> {1, PS};
cost_money_helper(PS, [N|T], ConsumeType, ABout, L) ->
    case N of
        {Type, Num} -> MoneyType = Type, Money = Num;
        {?TYPE_BGOLD, _GoodsId, Num} -> MoneyType = ?BGOLD, Money = Num;
        {?TYPE_GOLD, _GoodsId, Num} ->  MoneyType = ?GOLD,  Money = Num;
        {?TYPE_COIN, _GoodsId, Num} ->  MoneyType = ?COIN,  Money = Num
        %% {?TYPE_GCOIN, _GoodsId, Num} -> MoneyType = ?GCOIN, Money = Num
    end,
    case lib_goods_api:cost_money(PS, MoneyType, Money, ConsumeType, ABout) of
        {1, NewPS} -> cost_money_helper(NewPS, T, ConsumeType, ABout, [{MoneyType, Money}|L]);
        {0, NewPS} -> {0, return_cost_money(NewPS, L, ConsumeType, ABout)}
    end.

return_cost_money(PS, MoneyList, ProduceType, About) ->
    return_cost_money_helper(PS, MoneyList, ProduceType, About).

return_cost_money_helper(NewPS, [], _ProduceType, _About) -> NewPS;
return_cost_money_helper(PS, [{MoneyType, Money}|T], ProduceType, About) ->
    NewPS = lib_goods_util:add_money(PS, Money, MoneyType, ProduceType, About),
    return_cost_money_helper(NewPS, T, ProduceType, About).

%% ---------------------------------------------------------------------------
%% @doc 扣除消耗列表object_list
-spec cost_object_list(PS, ObjectList, Type, About) ->  Return when
    PS             :: #player_status{},         %% #player_status{}
    ObjectList     :: list(),                   %% object_list :: [{type,goods_id,num}]
    Type           :: atom(),                   %% 物品|货币消耗类型：需要后台定义"消耗类型"
    About          :: string(),                 %% 消耗描述
    Return         :: {true, #player_status{}}|{false, integer(), #player_status{}}. %% 返回：{true, PS}|{false,错误码,PS}
%% ---------------------------------------------------------------------------
cost_object_list(PS, ObjectList, Type, About) ->
    RecordPS = record_cost_when_onhook(PS, ObjectList, Type),
    lib_goods_util:cost_object_list(RecordPS, ObjectList, Type, About).

%% ---------------------------------------------------------------------------
%% @doc 判断是否满足消耗列表
-spec check_object_list(PS, ObjectList) ->  Return when
    PS             :: #player_status{},         %% #player_status{}
    ObjectList     :: list(),                   %% object_list :: [{type,goods_id,num}]
    Return         :: true | {false, integer()}.%% 返回：true|{false,错误码}
%% ---------------------------------------------------------------------------
check_object_list(PS, ObjectList) ->
    lib_goods_util:check_object_list(PS, ObjectList).

check_object_list_with_auto_buy(PS,  ObjectList) ->
    case lib_goods_util:check_object_list(PS, ObjectList) of
        {false, ErrorCode} ->
            case ErrorCode =:= ?GOODS_NOT_ENOUGH of
                true ->
                    case calc_auto_buy_list(ObjectList) of
                        {ok, NewObjectList} ->
                            lib_goods_util:check_object_list(PS, NewObjectList);
                        _A ->
                            {false, ErrorCode}
                    end;
                _ ->
                    {false, ErrorCode}
            end;
        Res ->
            Res
    end.

%% 满足条件才扣除
%% @return {true, #player_status{}} | {false, integer(), #player_status{}}
cost_object_list_with_check(PS, ObjectList, Type, About) ->
    case check_object_list(PS, ObjectList) of
        {false, ErrorCode} -> {false, ErrorCode, PS};
        true -> cost_object_list(PS, ObjectList, Type, About)
    end.

%% @return {true, #player_status{}, list()} | {false, integer(), #player_status{}}
cost_objects_with_auto_buy(PS, ObjectList, Type, About) ->
    case check_object_list(PS, ObjectList) of
        {false, ErrorCode} ->
            case ErrorCode =:= ?GOODS_NOT_ENOUGH of
                true ->
                    case calc_auto_buy_list(ObjectList) of
                        {ok, NewObjectList} ->
                            case cost_object_list_with_check(PS, NewObjectList, Type, About) of
                                {true, NewPS} -> {true, NewPS, NewObjectList};
                                {false, ErrorCode1, NewPS} -> {false, ErrorCode1, NewPS}
                            end;
                        _A ->
                            {false, ?GOODS_NOT_ENOUGH, PS}
                    end;
                _ ->
                    {false, ErrorCode, PS}
            end;
        true ->
            case cost_object_list(PS, ObjectList, Type, About) of
                {true, NewPS} -> {true, NewPS, ObjectList};
                {false, ErrorCode, NewPS} -> {false, ErrorCode, NewPS}
            end
    end.

% 不存在的物品消耗钻石自动购买，与cost_objects_with_auto_buy不同点在于绑钻不足时用钻石替代
%% @return {true, #player_status{}, list()} | {false, integer(), #player_status{}}
cost_objects_with_auto_buy_with_bg_to_g(PS, ObjectList, Type, About) -> 
    case check_object_list(PS, ObjectList) of
        {false, ErrorCode} ->
            case ErrorCode =:= ?GOODS_NOT_ENOUGH of
                true ->
                    case calc_auto_buy_list_with_bg_to_g(PS, ObjectList) of
                        {ok, NewObjectList} ->
                            case cost_object_list_with_check(PS, NewObjectList, Type, About) of
                                {true, NewPS} -> {true, NewPS, NewObjectList};
                                {false, ErrorCode1, NewPS} -> {false, ErrorCode1, NewPS}
                            end;
                        _A ->
                            {false, ?GOODS_NOT_ENOUGH, PS}
                    end;
                _ ->
                    {false, ErrorCode, PS}
            end;
        true ->
            case cost_object_list(PS, ObjectList, Type, About) of
                {true, NewPS} -> {true, NewPS, ObjectList};
                {false, ErrorCode, NewPS} -> {false, ErrorCode, NewPS}
            end
    end.

%%--------------------------------------------------
%% 把物品从A背包移动到B背包
%% @param  Ps          #player_status{}
%% @param  GoodsId     物品唯一id
%% @param  FromLoc     A背包
%% @param  ToLoc       B背包
%% @param  MoveNum     需要移动的数量|all
%% @return             {Errcode, GoodsTypeId}
%%--------------------------------------------------
move_a2b(Ps, GoodsId, FromLoc, ToLoc) ->
    move_a2b(Ps, GoodsId, FromLoc, ToLoc, all).

move_a2b(Ps, GoodsId, FromLoc, ToLoc, MoveNum) ->
    {PlayerId, Pid} = get_id_pid(Ps),
    case Pid =:= self() of
        true ->
            GoodsStatus = lib_goods_do:get_goods_status(),
            case lib_goods_check:check_move_a2b(GoodsStatus, GoodsId, FromLoc, ToLoc, MoveNum) of
                {fail, Res} -> {Res, 0};
                {ok, GoodsInfo, RealMoveNum} ->
                    case catch lib_goods_do:move_a2b(GoodsStatus, GoodsInfo, ToLoc, RealMoveNum) of
                        {ok, NewGoodsStatus, UpGoods} ->
                            lib_goods_do:set_goods_status(NewGoodsStatus),
                            lib_goods_api:notify_client(Ps#player_status.id, UpGoods),
                            %% 如果原背包的物品已经全部移动到B背包,要告诉客户端把物品从A背包删除
                            case RealMoveNum >= GoodsInfo#goods.num of
                                true ->
                                    %% 此处通知客户端将从原背包中移除但不会从服务端删除物品
                                    lib_goods_api:notify_client_num(PlayerId, [GoodsInfo#goods{num=0}]);
                                _ -> skip
                            end,
                            {1, GoodsInfo#goods.goods_id};
                        {db_error, {error,{cell_num, not_enough}}} ->
                            {?ERRCODE(err416_bag_no_null_cell), GoodsInfo#goods.goods_id};
                        _Error ->
                            ?ERR("move_a2b err:~p~n", [_Error]),
                            {0, 0}
                    end
            end;
        false ->
            Res = ?NOT_IN_PLAYER_PROCESS(0),
            {Res, 0}
    end.

move_more_a2b(Ps, FromLoc, ToLoc) ->
    {PlayerId, Pid} = get_id_pid(Ps),
    case Pid =:= self() of
        true ->
            case lib_goods_check:check_move_a2b_type(FromLoc, ToLoc) of
                true ->
                    GoodsStatus = lib_goods_do:get_goods_status(),
                    GoodsInfoList = lib_goods_util:get_goods_list(PlayerId, FromLoc, GoodsStatus#goods_status.dict),
                    SortList = lists:keysort(#goods.goods_id, GoodsInfoList),
                    NullCellNum = lib_goods_util:get_null_cell_num(GoodsStatus, ToLoc),
                    case NullCellNum > 0 of
                        true ->
                            SubList = lists:sublist(SortList, NullCellNum),
                            case catch lib_goods_do:move_more_a2b(GoodsStatus, SubList, ToLoc) of
                                {ok, NewGoodsStatus, UpGoods} ->
                                    lib_goods_do:set_goods_status(NewGoodsStatus),
                                    lib_goods_api:notify_client(Ps#player_status.id, UpGoods),
                                    %% 此处通知客户端将从原背包中移除但不会从服务端删除物品
                                    NotifyRemoveL = [TGoods#goods{num = 0}|| TGoods <- SubList],
                                    lib_goods_api:notify_client_num(PlayerId, NotifyRemoveL),
                                    1;
                                _Error ->
                                    ?ERR("move_a2b err:~p~n", [_Error]),
                                    0
                            end;
                        false ->
                            ?ERRCODE(err416_bag_no_null_cell)
                    end;
                false -> ?ERRCODE(err150_location_err)
            end;
        false ->
            ?NOT_IN_PLAYER_PROCESS(0)
    end.

%% 将fromloc里面的物品移到物品配置的背包里面
%% return：{ok, NewPS, GoodsList}|{false, Res}, GoodsList:被移动的物品列表
move_goods_from_loc(Ps, FromLoc) ->
   {PlayerId, Pid} = get_id_pid(Ps),
    case Pid =:= self() of
        true ->
            case lists:member(FromLoc, ?GOODS_LOC_BAG_TYPES) of
                true ->
                    GoodsStatus = lib_goods_do:get_goods_status(),
                    GoodsInfoList = lib_goods_util:get_goods_list(PlayerId, FromLoc, GoodsStatus#goods_status.dict),  
                    case lib_goods_do:move_goods_to_original(Ps, GoodsStatus, GoodsInfoList) of
                        {ok, _, _, RewardList} ->
                            NewPs = lib_goods_api:send_reward(Ps, #produce{type = move_goods, reward = RewardList, remark = lists:concat(["from_", FromLoc])}),
                            {ok, NewPs, GoodsInfoList};
                        {false, Res} ->
                            {false, Res}
                    end;
                false -> {false, ?ERRCODE(err150_location_err)}
            end;
        false ->
            {false, ?NOT_IN_PLAYER_PROCESS(0)}
    end. 


%% 查询道具数量
%% GoodsTypeList = [GoodsTypeId,...]
%% return: [{GoodsTypeId, Num}]
get_goods_num(PlayerInfo, GoodsTypeList) ->
    {_PlayerId, Pid} = get_id_pid(PlayerInfo),
    case Pid =:= self() of
        true ->
            lib_goods_do:goods_num(GoodsTypeList);
        false ->
            ?NOT_IN_PLAYER_PROCESS([])
    end.

%% 查询道具数量
%% GoodsTypeList = [GoodsTypeId,...]
%% Bind 绑定状态
%% return: [{GoodsTypeId, Num}]
get_goods_num(PlayerInfo, GoodsTypeList, Bind) ->
    {_PlayerId, Pid} = get_id_pid(PlayerInfo),
    case Pid =:= self() of
        true ->
            lib_goods_do:goods_num(GoodsTypeList, Bind);
        false ->
            ?NOT_IN_PLAYER_PROCESS([])
    end.

%% @doc 获取背包空格子数量
get_cell_num(PlayerInfo) ->
    {_PlayerId, Pid} = get_id_pid(PlayerInfo),
    case Pid =:= self() of
        true ->
            lib_goods_do:cell_num(?GOODS_LOC_BAG);
        false ->
            ?NOT_IN_PLAYER_PROCESS(0)
    end.

%% @doc 获取背包空格子数量
get_cell_num(PlayerInfo, Location) ->
    {_PlayerId, Pid} = get_id_pid(PlayerInfo),
    case Pid =:= self() of
        true ->
            lib_goods_do:cell_num(Location);
        false ->
            ?NOT_IN_PLAYER_PROCESS(0)
    end.

%% 获得物品列表需要多少格子数
%% GoodsTypeList :: [{ObjectType, GoodsTypeId, Num} | {ObjectType, GoodsTypeId, Num, Bind} |{GoodsTypeId, Num}]
%% return: [{背包位置, 格子数}]
get_need_cell_num(PlayerInfo, GoodsTypeList) ->
    {PlayerId, Pid} = get_id_pid(PlayerInfo),
    case Pid =:= self() of
        true ->
            GoodsStatus = lib_goods_do:get_goods_status(),        
            lib_storage_util:get_need_cell_num(PlayerId, GoodsStatus, GoodsTypeList);
        false ->
            ?NOT_IN_PLAYER_PROCESS(9999999)
    end.

%% ---------------------------------------------------------------------------
%% @doc 检查物品是否可以加入到背包，能不能加入完全取决于背包格子数
%% PlayerInfo    :: #player_status{},
%% GoodsTypeList :: [{ObjectType, GoodsTypeId, Num} | {ObjectType, GoodsTypeId, Num, Bind} |{GoodsTypeId, Num}]
%% 注：不带Bind参数时，默认非绑
%% @return {false, ErrorCode} | true
%% ---------------------------------------------------------------------------
can_give_goods(_PlayerInfo, []) -> true;
can_give_goods(PlayerInfo, GoodsTypeList) ->
    {_PlayerId, Pid} = get_id_pid(PlayerInfo),
    case Pid =:= self() of
        true ->
            lib_goods_do:can_give_goods(GoodsTypeList);
        false ->
            ?NOT_IN_PLAYER_PROCESS(false)
    end.

%% ---------------------------------------------------------------------------
%% @doc 拆分可发送和不可发送的道具
%% PlayerInfo    :: #player_status{},
%% GoodsTypeList :: [{ObjectType, GoodsTypeId, Num} | {ObjectType, GoodsTypeId, Num, Bind} |{GoodsTypeId, Num}]
%% @return {最大可发送道具列表, 不可发送列表}
%% ---------------------------------------------------------------------------
spilt_send_able_goods(_PlayerInfo, []) -> {[], []};
spilt_send_able_goods(PlayerInfo, GoodsTypeList) ->
    {_PlayerId, Pid} = get_id_pid(PlayerInfo),
    case Pid =:= self() of
        true ->
            {LocLimitReward, LocNotLimitReward} = split_reward_with_location(GoodsTypeList),
            {SendAbleList, NotSendAbleList} = lib_goods_do:spilt_send_able_goods(LocLimitReward),
            {LocNotLimitReward++SendAbleList, NotSendAbleList};
        false ->
            {[], GoodsTypeList}
    end.

%% 判断物品列表数量 
%% GoodsTypeList = [{GoodsTypeId, Num}]
%% return: 0失败，1 成功
check_goods_num(PlayerInfo, GoodsTypeList) ->
    {_PlayerId, Pid} = get_id_pid(PlayerInfo),
    case Pid =:= self() of
        true ->
            lib_goods_do:check_num(GoodsTypeList);
        false ->
            ?NOT_IN_PLAYER_PROCESS(0)
    end.

%% 检查消耗最大数量
get_cost_max_num(PlayerInfo, CostList) ->
    GoodsTypeIdList = [GoodsTypeId||{?TYPE_GOODS, GoodsTypeId, _Num}<-CostList],
    GoodsNumList = get_goods_num(PlayerInfo, GoodsTypeIdList),
    F = fun({GoodsTypeId, Num}, List) ->
        case lists:keyfind(GoodsTypeId, 2, CostList) of
            false -> List;
            {_, _, NeedNum} -> [Num div NeedNum|List]
        end
    end,
    case lists:foldl(F, [], GoodsNumList) of
        [] -> 0;
        List -> lists:min(List)
    end.

% ---------------------------------------------------------------------------
% @doc 获取物品信息
% spec get_goods_info(GoodsId) -> GoodsInfo | [] when
%      GoodsId     :: integer()    物品Id
%      GoodsInfo   :: #goods{}     物品信息
%      []                          没有物品
% ---------------------------------------------------------------------------
get_goods_info(GoodsId) ->
    GoodsStatus = lib_goods_do:get_goods_status(),
    lib_goods_util:get_goods(GoodsId, GoodsStatus#goods_status.dict).

get_goods_info(GoodsId, GoodsStatus) ->
    lib_goods_util:get_goods(GoodsId, GoodsStatus#goods_status.dict).

% --------------------------------------------------------------------------
%  local function
% --------------------------------------------------------------------------
get_id_pid(PlayerInfo) ->
    PlayerId = case PlayerInfo of
        Id when is_integer(Id) ->
            Id;
        PS when is_record(PS, player_status) ->
            PS#player_status.id
    end,
    Pid = misc:get_player_process(PlayerId),
    {PlayerId, Pid}.

trans_object_format(GoodsList) ->
    trans_object_format(GoodsList, []).

trans_object_format([], ObjectList) -> 
    ulists:object_list_plus([[], ObjectList]);
trans_object_format([H|T], ObjectList) ->  
    case H of
        {GoodsTypeId, GoodsNum} ->
            NewObjectList = [{?TYPE_GOODS, GoodsTypeId, GoodsNum}|ObjectList],
            trans_object_format(T, NewObjectList);
        {goods, GoodsTypeId, GoodsNum} ->
            NewObjectList = [{?TYPE_GOODS, GoodsTypeId, GoodsNum}|ObjectList],
            trans_object_format(T, NewObjectList);
        {goods, GoodsTypeId, GoodsNum, _Bind} ->
            NewObjectList = [{?TYPE_GOODS, GoodsTypeId, GoodsNum}|ObjectList],
            trans_object_format(T, NewObjectList);
        {goods, GoodsTypeId, GoodsNum, _Bind, _ExpireTime, _LockTime} ->
            NewObjectList = [{?TYPE_GOODS, GoodsTypeId, GoodsNum}|ObjectList],
            trans_object_format(T, NewObjectList);
        {goods_attr, GoodsTypeId, GoodsNum, _AttrList} ->
            NewObjectList = [{?TYPE_GOODS, GoodsTypeId, GoodsNum}|ObjectList],
            trans_object_format(T, NewObjectList);
        {Type, GoodsTypeId, GoodsNum} when is_integer(Type) ->
            NewObjectList = [{Type, GoodsTypeId, GoodsNum}|ObjectList],
            trans_object_format(T, NewObjectList);
        _ ->
            trans_object_format(T, ObjectList)
    end.

spilt_reward(ObjectList) ->
    F = fun(Item, {List1, List2, List3}) ->
        case Item of 
            {?TYPE_GOODS, _, _} -> {[Item|List1], List2, List3};
            {?TYPE_GOODS, _, _, _} -> {[Item|List1], List2, List3};
            {?TYPE_BIND_GOODS, _, _} -> {[Item|List1], List2, List3};
            {?TYPE_ATTR_GOODS, _, _, _} -> {[Item|List1], List2, List3};
            {?TYPE_COIN, Id, Num} -> {List1, [{?TYPE_COIN, Id, Num}|List2], List3};
            {?TYPE_GOLD, Id, Num} -> {List1, [{?TYPE_GOLD, Id, Num}|List2], List3};
            {?TYPE_BGOLD, Id, Num} -> {List1, [{?TYPE_BGOLD, Id, Num}|List2], List3};
            {Type, Id, Num} -> {List1, List2, [{Type, Id, Num}|List3]};
            _ -> {List1, List2, List3}
        end
    end,
    {GoodsObjectList, CoinObjectList, OtherObjectList} = lists:foldl(F, {[], [], []}, ObjectList),
    {GoodsObjectList, CoinObjectList, OtherObjectList}.

split_reward_with_location(Reward) ->
    F = fun(Item, {L1, L2}) ->
        case Item of 
            {?TYPE_GOODS, GoodsTypeId, _} -> IsGoods = true;
            {?TYPE_GOODS, GoodsTypeId, _, _} -> IsGoods = true;
            {?TYPE_BIND_GOODS, GoodsTypeId, _} -> IsGoods = true;
            {?TYPE_ATTR_GOODS, GoodsTypeId, _, _} -> IsGoods = true;              
            _ -> GoodsTypeId = -1, IsGoods = false
        end,
        case IsGoods of 
            true ->
                case data_goods_type:get(GoodsTypeId) of 
                    #ets_goods_type{bag_location = BagLocation} -> ok;
                    _ -> BagLocation = ?GOODS_LOC_BAG
                end,
                case lists:member(BagLocation, ?GOODS_LOC_BAG_LIMIT_TYPES) of 
                    true ->
                        {[Item|L1], L2};
                    _ -> 
                        {L1, [Item|L2]}
                end;
            _ ->
                {L1, [Item|L2]}
        end
    end,
    {LocLimitReward, LocNotLimitReward} = lists:foldl(F, {[], []}, Reward),
    {LocLimitReward, LocNotLimitReward}.

%% ---------------------------------------------------------------------------
%% @doc 通知前端更新物品信息、增加物品
-spec notify_client(PlayerInfo, GoodsInfoList) -> ok when
    PlayerInfo   :: #player_status{} | integer(),
    GoodsInfoList:: [#goods{}].
%% ---------------------------------------------------------------------------
notify_client(_PlayerId, []) -> skip;
notify_client(Player = #player_status{sid = Sid}, GoodsInfoList) ->
    LocationList = classify_goods_by_location(GoodsInfoList, []),
    Fun = fun({Location, GoodsList}) ->
        GoodsListPack = pp_goods:pack_goods_list(GoodsList),
        {ok, BinData} = pt_150:write(15017, [Location, GoodsListPack]),
        lib_server_send:send_to_sid(Sid, BinData)
    end,
    [Fun(OneLocationL) || OneLocationL <- LocationList],
    dispatch_event(Player#player_status.id, GoodsInfoList),
    ok;
notify_client(PlayerId, GoodsInfoList) ->
    LocationList = classify_goods_by_location(GoodsInfoList, []),
    Fun = fun({Location, GoodsList}) ->
        GoodsListPack = pp_goods:pack_goods_list(GoodsList),
        {ok, BinData} = pt_150:write(15017, [Location, GoodsListPack]),
        lib_server_send:send_to_uid(PlayerId, BinData)
    end,
    [Fun(OneLocationL) || OneLocationL <- LocationList],
    dispatch_event(PlayerId, GoodsInfoList),
    ok.

update_client_goods_info([]) -> skip;
update_client_goods_info([GoodsInfo|GoodsInfoL]) ->
    Args = pp_goods:make_self_goods_info_pack(GoodsInfo),
    {ok, BinData} = pt_150:write(15000, Args),
    lib_server_send:send_to_uid(GoodsInfo#goods.player_id, BinData),
    update_client_goods_info(GoodsInfoL).
dispatch_event(PlayerId, GoodsList) ->
    F = fun(#goods{id = Id, goods_id = GoodsId, num = Num, location = Location} = Goods, EventMap) -> 
        case data_goods_type:get(GoodsId) of
            #ets_goods_type{quick_use = ?QUICK_USE} when Num > 0 ->         
                EventData = #callback_give_goods_data{
                    type  = 1, goods = Goods},
                lib_player_event:async_dispatch(PlayerId, ?EVENT_GIVE_GOODS, EventData),
                EventMap;
            #ets_goods_type{type = ?GOODS_TYPE_EQUIP} when Location == ?GOODS_LOC_BAG andalso Num > 0->  
                GiveGoods = maps:get(2, EventMap, []),   
                NewEventMap = maps:put(2, [Id|GiveGoods], EventMap),   
                NewEventMap;
            #ets_goods_type{type = ?GOODS_TYPE_RUNE} when Location == ?GOODS_LOC_RUNE_BAG andalso Num > 0->
                GiveGoods = maps:get(3, EventMap, []),   
                NewEventMap = maps:put(3, [Id|GiveGoods], EventMap),   
                NewEventMap;
            #ets_goods_type{type = ?GOODS_TYPE_SOUL} when Location == ?GOODS_LOC_SOUL_BAG andalso Num > 0->
                GiveGoods = maps:get(4, EventMap, []),   
                NewEventMap = maps:put(4, [Id|GiveGoods], EventMap),   
                NewEventMap;
            _ -> EventMap
        end
    end,
    LastEventMap = lists:foldl(F, #{}, GoodsList),
    F2 = fun(Type, EventGoodsList, Acc) ->
        EventData = #callback_give_goods_list{type  = Type, goods_list = EventGoodsList},
        lib_player_event:async_dispatch(PlayerId, ?EVENT_GIVE_GOODS_LIST, EventData),
        Acc
    end,
    maps:fold(F2, 0, LastEventMap).

%% ---------------------------------------------------------------------------
%% @doc %% 通知前端更新物品数量 (若物品数量为0,即是要删除的物品)
-spec notify_client_num(PlayerId, GoodsInfoList) -> ok when
    PlayerId   :: integer(),
    GoodsInfoList:: [#goods{}].
%% ---------------------------------------------------------------------------
notify_client_num(_PlayerId, []) -> skip;
notify_client_num(PlayerId, GoodsInfoList) ->
    LocationList = classify_goods_by_location(GoodsInfoList, []),
    Fun = fun({Location, GoodsList}) ->
        GoodsListPack = [{Goods#goods.id, Goods#goods.num, Goods#goods.goods_id}||Goods<-GoodsList],
        {ok, BinData} = pt_150:write(15018, [Location, GoodsListPack]),
        lib_server_send:send_to_uid(PlayerId, BinData)
    end,
    [Fun(OneLocationL) || OneLocationL <- LocationList],
    ok.

%% 根据物品所在位置把物品分开
classify_goods_by_location([], ClassifyList) -> ClassifyList;
classify_goods_by_location([Goods | T], ClassifyList) ->
    Location = Goods#goods.location,
    case lists:keyfind(Location, 1, ClassifyList) of
        false ->
            NewClassifyL = [{Location, [Goods]} | ClassifyList],
            classify_goods_by_location(T, NewClassifyL);
        {Location, GoodsList} ->
            LocationList = {Location, [Goods | GoodsList]},
            NewClassifyL = lists:keystore(
                Location, 1, ClassifyList, LocationList
            ),
            classify_goods_by_location(T, NewClassifyL)
    end.

%% 发送奖励[带邮件的]
%% @param Produce 产出record
%%  Reward:[{Type, GoodsType, Num},...]
send_reward_with_mail(RoleId, Produce) when is_integer(RoleId) ->
    #produce{type = Type, off_title = OffTitle, off_content = OffContent, reward = Reward, title = Title, content = Content} = Produce,
    Pid = misc:get_player_process(RoleId),
    case misc:is_process_alive(Pid) of
        true -> lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_goods_api, send_reward_with_mail, [Produce]);
        false ->
            UniqueReward = make_reward_unique(Reward),
            if
                OffTitle =/= "" andalso OffContent =/= "" -> 
                    lib_mail_api:send_sys_mail([RoleId], OffTitle, OffContent, UniqueReward);
                Title =/= "" andalso Content =/= "" ->
                    lib_mail_api:send_sys_mail([RoleId], Title, Content, UniqueReward);
                true ->
                    ProduceAbout = data_produce_type:get_produce_content(Type),
                    NewTitle = utext:get(1500003), NewContent = utext:get(1500004, [util:make_sure_binary(ProduceAbout)]),
                    lib_mail_api:send_sys_mail([RoleId], NewTitle, NewContent, UniqueReward)
            end
    end;
send_reward_with_mail(Player, Produce) ->
    #produce{reward = Reward} = Produce,
    UniqueReward = make_reward_unique(Reward),
    {LocLimitReward, LocNotLimitReward} = split_reward_with_location(UniqueReward),
    case lib_goods_api:can_give_goods(Player, LocLimitReward) of
        true ->
            {ok, NewPlayer, _UpGoodsList} = send_reward_return_goods(Player, Produce#produce{reward = UniqueReward});
        _ ->
            send_mail_when_no_cell(Player#player_status.id, Produce, LocLimitReward),
            {ok, NewPlayer, _UpGoodsList} = send_reward_return_goods(Player, Produce#produce{reward = LocNotLimitReward})
    end,
    {ok, NewPlayer}.

%% 发送奖励:背包已满用邮件,如果背包没有满,直接发到背包,并且返回需要更新的物品列表
%% @return  {ok, bag, LastPlayer, UpGoodsList} | {ok, mail, Player, []}
%%  UpGoodsList [#goods{}]
send_reward_with_mail_return_goods(Player, Produce) ->
    #produce{reward = Reward} = Produce,
    UniqueReward = make_reward_unique(Reward),
    {LocLimitReward, LocNotLimitReward} = split_reward_with_location(UniqueReward),
    case lib_goods_api:can_give_goods(Player, LocLimitReward) of
        % true when Type == task ->
        %     {ok, NewPlayer, UpGoodsList} = send_reward_return_goods(Player, Produce#produce{reward = UniqueReward}),
        %     %% 帮角色穿上任务送的装备
        %     LastPlayer = lib_equip:task_send_equip(NewPlayer, UniqueReward),
        %     {ok, bag, LastPlayer, UpGoodsList};
        true ->
            % LastPlayer = send_reward_return_goods(Player, Produce#produce{reward = UniqueReward});
            {ok, NewPlayer, UpGoodsList} = send_reward_return_goods(Player, Produce#produce{reward = UniqueReward}),
            {ok, bag, NewPlayer, UpGoodsList};
        {false, _Errcode} -> 
            send_mail_when_no_cell(Player#player_status.id, Produce, LocLimitReward),
            {ok, NewPlayer, UpGoodsList} = send_reward_return_goods(Player, Produce#produce{reward = LocNotLimitReward}),
            {ok, bag, NewPlayer, UpGoodsList}
    end.

%% 唯一处理(不要修改格式)
%% RewardList :: [{type, id, num}|{?TYPE_GOODS, id, num, bind}|{?TYPE_ATTR_GOODS, id, num, attrlist}]
make_reward_unique(RewardList) ->
    ulists:object_list_plus_extra(RewardList).

%% 系统提示获得物品
%% RoleId :: 玩家id
%% Type   :: 类型：1右下角飘字|2聊天频道消息|3右下角飘字 + 聊天频道消息
%% RewardL:: [{GoodsType,Id,Num}]
send_tv_tip(RoleId, RewardL) ->
    send_tv_tip(RoleId, 2, RewardL).

send_tv_tip(RoleId, Type, RewardL) ->
    F = fun(Item, List) ->
        case Item of
            {?TYPE_GOODS, Id, Num} -> [{Id, Num}|List];
            {?TYPE_BIND_GOODS, Id, Num} -> [{Id, Num}|List];
            {?TYPE_ATTR_GOODS, Id, Num, _Attr} -> [{Id, Num}|List];
            {?TYPE_COIN, _Id, Num} -> [{?GOODS_ID_COIN, Num}|List];
            {?TYPE_GOLD, _Id, Num} -> [{?GOODS_ID_GOLD, Num}|List];
            {?TYPE_BGOLD, _Id, Num} -> [{?GOODS_ID_BGOLD, Num}|List];
            {?TYPE_CHARM, _Id, Num} -> [{?GOODS_ID_CHARM, Num}|List];
            {?TYPE_FAME, _Id, Num} -> [{?GOODS_ID_FAME, Num}|List];
            %% {?TYPE_EXP, _Id, Num} -> [{?GOODS_ID_EXP, Num}|List];
            % {?TYPE_GFUNDS, _Id, Num} -> [{?GOODS_ID_GFUNDS, Num}|List];
            % {?TYPE_GDONATE, _Id, Num} -> [{?GOODS_ID_GDONATE, Num}|List];
            %{?TYPE_GUILD_DRAGON_MAT, _Id, Num} -> [{?GOODS_ID_GDRAGON_MAT, Num}|List];
            {?TYPE_GUILD_PRESTIGE, _Id, Num} -> [{?GOODS_ID_GUILD_PRESTIGE, Num}|List];
            {?TYPE_FASHION_NUM, PosId, Num} -> [{?GOODS_ID_FASHION_NUM(PosId), Num}|List];
            {?TYPE_RUNE, _Id, Num} -> [{?GOODS_ID_RUNE, Num}|List];
            {?TYPE_SOUL, _Id, Num} -> [{?GOODS_ID_SOUL, Num}|List];
            {?TYPE_RUNE_CHIP, _Id, Num} -> [{?GOODS_ID_RUNE_CHIP, Num}|List];
            {?TYPE_CURRENCY, Id, Num} -> [{Id, Num}|List];
            _ -> List
        end
    end,
    NewList = lists:foldl(F, [], RewardL),
    case length(NewList) > 0 of
        true ->
            {ok, BinData} = pt_110:write(11060, [Type, NewList]),
            lib_server_send:send_to_uid(RoleId, BinData);
        false -> ok
    end.

%%% 计算自动购买的物品
calc_auto_buy_list(ObjectList) ->
    UniqueList = ulists:object_list_plus([[], ObjectList]),
    {EnoughGoods, NotEnoughGoods}
    = lists:foldl(fun
        ({?TYPE_GOODS, GoodsId, Num} = G, {Enough, NotEnough}) ->
            [{_, BagNum}] = lib_goods_do:goods_num([GoodsId]),
            if
                BagNum =:= 0 ->
                    {Enough, [G|NotEnough]};
                BagNum < Num ->
                    {[{?TYPE_GOODS, GoodsId, BagNum}|Enough], [{?TYPE_GOODS, GoodsId, Num - BagNum}|NotEnough]};
                true ->
                    {[G|Enough], NotEnough}
            end;
        (G, {Enough, NotEnough}) ->
            {[G|Enough], NotEnough}
    end, {[], []}, UniqueList),
    case calc_price(NotEnoughGoods, []) of
        {ok, PriceList} ->
            {ok, make_reward_unique(PriceList ++ EnoughGoods)};
        _ ->
            error
    end.

calc_price([{?TYPE_GOODS, GoodsId, Num}|T], Acc) ->
    case data_goods:get_goods_buy_price(GoodsId) of
        {0, 0} -> error;
        {PriceType, Price} -> calc_price(T, [{PriceType, 0, Price * Num}|Acc])
    end;

calc_price([], Acc) -> {ok, Acc}.

%% 计算自动购买的物品价格，与calc_auto_buy_list不同点在于绑金不足时自动将不足的用金替代
calc_auto_buy_list_with_bg_to_g(PS, ObjectList) -> 
    UniqueList = ulists:object_list_plus([[], ObjectList]),
    {EnoughGoods, NotEnoughGoods}
    = lists:foldl(fun
        ({?TYPE_GOODS, GoodsId, Num} = G, {Enough, NotEnough}) ->
            [{_, BagNum}] = lib_goods_do:goods_num([GoodsId]),
            if
                BagNum =:= 0 ->
                    {Enough, [G|NotEnough]};
                BagNum < Num ->
                    {[{?TYPE_GOODS, GoodsId, BagNum}|Enough], [{?TYPE_GOODS, GoodsId, Num - BagNum}|NotEnough]};
                true ->
                    {[G|Enough], NotEnough}
            end;
        (G, {Enough, NotEnough}) ->
            {[G|Enough], NotEnough}
    end, {[], []}, UniqueList),
    #player_status{bgold = BGold} = PS, 
    case calc_price_with_bg_to_g(BGold, NotEnoughGoods, []) of
        {ok, PriceList} ->
            {ok, make_reward_unique(PriceList ++ EnoughGoods)};
        _ ->
            error
    end.

calc_price_with_bg_to_g(BGold, [{?TYPE_GOODS, GoodsId, Num}|T], Acc) ->
    case data_goods:get_goods_buy_price(GoodsId) of
        {0, 0} -> error;
        {PriceType, Price} ->
            % 价格是绑钻的话，不足之处用钻石代替 
            case PriceType =:= 2 andalso (Price*Num - BGold) > 0 of
                true ->  
                    ?IF(BGold =:= 0, 
                        calc_price_with_bg_to_g(BGold, T, [{1, 0, Price * Num}|Acc]),
                        calc_price_with_bg_to_g(0, T, [{PriceType, 0, BGold}, {1, 0, Price*Num - BGold}] ++ Acc)
                    );
                false -> 
                    Remain = ?IF(PriceType =:= 2, BGold - Price * Num, BGold),
                    calc_price_with_bg_to_g(Remain, T, [{PriceType, 0, Price * Num}|Acc])
            end
    end;

calc_price_with_bg_to_g(_, [], Acc) -> {ok, Acc}.

send_update_currency(PS, CurrencyId) ->
    Value = maps:get(CurrencyId, PS#player_status.currency_map, 0),
    {ok, BinData} = pt_150:write(15008, [CurrencyId, Value]),
    lib_server_send:send_to_sid(PS#player_status.sid, BinData).

%% 计算总的强化等级
count_stren_total_lv(PlayerStatus) ->
    {_PlayerId, Pid} = get_id_pid(PlayerStatus),
    case Pid =:= self() of
        true ->
            lib_equip:count_stren_total_lv(PlayerStatus);
        false ->
            ?NOT_IN_PLAYER_PROCESS(false)
    end.

%% 计算宝石总战力
count_stone_total_power(PlayerStatus) ->
    {_PlayerId, Pid} = get_id_pid(PlayerStatus),
    case Pid =:= self() of
        true ->
            lib_equip:count_stone_total_power(PlayerStatus);
        false ->
            ?NOT_IN_PLAYER_PROCESS(false)
    end.

%% 计算宝石总等级
count_stone_total_lv(PlayerStatus) ->
    {_PlayerId, Pid} = get_id_pid(PlayerStatus),
    case Pid =:= self() of
        true ->
            lib_equip:count_stone_total_lv(PlayerStatus);
        false ->
            lib_equip:count_stone_total_lv_off_line(PlayerStatus)
%%            ?NOT_IN_PLAYER_PROCESS(false)
    end.

get_currency(Player, CurrencyId) ->
    maps:get(CurrencyId, Player#player_status.currency_map, 0).

%% 删除指定的货币id,玩家进程数据中的currency_map也要对应的设为0，不要使用maps:remove,否则下次增加同类型特殊货币会报错
%% 使用SQL操作DELETE,玩家进程数据就应该同步使用maps:remove，否则下次增加同类型特殊货币无法插入数据库保存
db_delete_currency_by_currency_id(CurrencyId) ->
    db:execute(io_lib:format(<<"UPDATE `player_special_currency` SET `num`=~p WHERE `currency_id` = ~p">>, [0, CurrencyId])).

get_first_object_name([{_, GoodsId, _}|_]) when GoodsId > 0 ->
    data_goods:get_goods_name(GoodsId);

get_first_object_name([{GoodsId, _}|_]) when GoodsId > 0 ->
    data_goods:get_goods_name(GoodsId);

get_first_object_name([{Type, 0, _}|_]) ->
    GoodsId
    = case Type of
        ?TYPE_BGOLD ->
            ?GOODS_ID_BGOLD;
        ?TYPE_GOLD ->
            ?GOODS_ID_GOLD;
        ?TYPE_COIN ->
            ?GOODS_ID_COIN;
        ?TYPE_GDONATE ->
            ?GOODS_ID_GDONATE;
        ?TYPE_GUILD_DRAGON_MAT ->
            ?GOODS_ID_GDRAGON_MAT;
        ?TYPE_GUILD_PRESTIGE ->
            ?GOODS_ID_GUILD_PRESTIGE;
        ?TYPE_GFUNDS ->
            ?GOODS_ID_GFUNDS;
        ?TYPE_EXP ->
            ?GOODS_ID_EXP;
        ?TYPE_RUNE ->
            ?GOODS_ID_RUNE;
        ?TYPE_SOUL ->
            ?GOODS_ID_SOUL;
        ?TYPE_RUNE_CHIP ->
            ?GOODS_ID_RUNE_CHIP;
        ?TYPE_SEA_EXPLOIT ->
            ?GOODS_ID_SEA_EXPLOIT;
        _ ->
            0
    end,
    data_goods:get_goods_name(GoodsId).

make_goods_tv_format_3(Goods) ->
    #goods{goods_id = GoodsTypeId, other = #goods_other{rating = Rating, extra_attr = ExtraAttr}} = Goods,
    [GoodsTypeId, Rating, util:term_to_string(data_attr:unified_format_extra_attr(ExtraAttr, []))].

%% ----------------------------------- 秘籍 -----------------------------------------------
set_goods_expired_time(RoleIds, GTypeIds, ExpiredTime) ->
    case RoleIds of
        [] ->
            NeedHandle = true,
            RealRoleIdsTmp = db:get_all(<<"select id from player_low">>),
            RealRoleIds = [RoleId || [RoleId] <- RealRoleIdsTmp],
            GoodsIdsTmp = db:get_all(io_lib:format(<<"select gid from goods_low where gtype_id in (~s)">>, [util:link_list(GTypeIds)])),
            GoodsIds = [GoodsId || [GoodsId] <- GoodsIdsTmp];
        [_|_] ->
            NeedHandle = true,
            RealRoleIds = RoleIds,
            GoodsIdsTmp = db:get_all(io_lib:format(<<"select gid from goods_low where pid in (~s) and gtype_id in (~s)">>, [util:link_list(RealRoleIds), util:link_list(GTypeIds)])),
            GoodsIds = [GoodsId || [GoodsId] <- GoodsIdsTmp];
        _ -> NeedHandle = false, RealRoleIds = [], GoodsIds = []
    end,
    case NeedHandle of
        true ->
            %% 先统一修改数据库，之后再处理在线玩家的物品信息
            db:execute(io_lib:format(<<"update goods set expire_time = ~p where id in (~s)">>, [ExpiredTime, util:link_list(GoodsIds)])),
            spawn(fun() ->
                do_set_goods_expired_time(RealRoleIds, GTypeIds, ExpiredTime)
            end),
            ok;
        _ -> skip
    end.

do_set_goods_expired_time([], _, _) -> skip;
do_set_goods_expired_time([RoleId|L], GTypeIds, ExpiredTime) ->
    Pid = misc:get_player_process(RoleId),
    case misc:is_process_alive(Pid) of
        true ->
            lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, lib_goods_api, set_goods_expired_time_core, [GTypeIds, ExpiredTime]);
        false -> skip
    end,
    timer:sleep(100),
    do_set_goods_expired_time(L, GTypeIds, ExpiredTime).

set_goods_expired_time_core(PlayerStatus, GTypeIds, ExpiredTime) ->
    GoodsStatus = lib_goods_do:get_goods_status(),
    #goods_status{dict = Dict} = GoodsStatus,
    F = fun(_Key, [Value]) ->
        #goods{goods_id = GTypeId} = Value,
        case lists:member(GTypeId, GTypeIds) of
            true ->
                [Value#goods{expire_time = ExpiredTime}];
            _ -> [Value]
        end
    end,
    NewDict = dict:map(F, Dict),
    NewGoodsStatus = GoodsStatus#goods_status{dict = NewDict},
    lib_goods_do:set_goods_status(NewGoodsStatus),
    %% 帮玩家整理一遍背包
    pp_goods:handle(15004, PlayerStatus, [?GOODS_LOC_BAG]).



%%-------------------------------------------- 暂时没有调用的函数
%% ---------------------------------------------------------------------------
%% @doc 尽量可能去移除所需数量，如果不够，则返回移除了多少数量
%% (列表中GoodsTypeId不能重复)
-spec delete_as_much_as_possible_by_list(PlayerInfo, GoodsList) ->  Return when
    PlayerInfo  :: integer() | #player_status{},    %% 玩家id | 玩家进程记录
    GoodsList   :: list(),                          %% 要扣除的物品类型id，数量tuple_list: [{GoodsTypeId, Num}...]
    Return      :: false | list().                  %% 返回false(不成功),或者实际扣取的要扣除的物品类型id，数量tuple_list
                                                    %% 请接口调用者自行进行校对，是否扣取足够数量
%% ---------------------------------------------------------------------------
delete_as_much_as_possible_by_list(PlayerInfo, GoodsList) when GoodsList=/=[] ->
    {_PlayerId, Pid} = get_id_pid(PlayerInfo),
    Res = case Pid =:= self() of
        true ->
            lib_goods_do:delete_list_as_much_as_possible(GoodsList);
        false ->
            ?NOT_IN_PLAYER_PROCESS(0)
    end,
    Res;
delete_as_much_as_possible_by_list(_PlayerInfo, GoodsList) ->
    ?ERR("~p:~p param error:~p", [?MODULE, ?LINE, GoodsList]),
    0.

%% ---------------------------------------------------------------------------
%% @doc 记录发奖励结果日志，主要记得发送不成功的日志
% -spec give_goods(Player, GoodsTypeId, Num, Type, SubType) -> Res when
%     Player      :: #player_status{},        %% 玩家记录
%     GoodsTypeId :: integer(),               %% 物品类型Id
%     Num         :: integer(),               %% 物品数量
%     Type        :: atom(),                  %% 物品产出类型
%                                             %% 需要后台定义"产出消耗类型--产出类型"
%     SubType     :: integer(),               %% 物品产出子类型
%     Res         :: integer().               %% 结果码 1 成功， 2物品类型不存在, 3 背包数量不足, 4动态属性设置权限不足, 5列表中GoodsTypeId重复
%% ---------------------------------------------------------------------------
handle_send_reward_result(Res, RoleId, RewardResult, ErrorGoodsList, Produce) ->
    #produce{type = Type} = Produce,
    ProduceId = data_goods:get_produce_type(Type),
    IgnoreGoods = maps:get(?REWARD_RESULT_IGNOR, RewardResult, []),
    FIgnore = fun({_, GoodsTypeId, Num}, MapIgnore) ->
        case data_goods_type:get(GoodsTypeId) of 
            %% 记录发放失败的神装，通过邮件发送给玩家
            #ets_goods_type{type = ?GOODS_TYPE_EQUIP} ->
                OList = maps:get(god_equip, MapIgnore, []), maps:put(god_equip, [{?TYPE_GOODS, GoodsTypeId, Num}|OList], MapIgnore);
             %% 记录发放失败的圣印，通过邮件发送给玩家
            #ets_goods_type{bag_location = ?GOODS_LOC_SEAL, type = ?GOODS_TYPE_SEAL} ->
                OList = maps:get(seal_equip, MapIgnore, []), maps:put(seal_equip, [{?TYPE_GOODS, GoodsTypeId, Num}|OList], MapIgnore);
            %% 其他物品，记录发送失败日志
            _ -> 
                OList = maps:get(other_goods, MapIgnore, []), maps:put(other_goods, [{?TYPE_GOODS, GoodsTypeId, Num}|OList], MapIgnore)
        end
    end,
    MapIgnore = lists:foldl(FIgnore, #{}, IgnoreGoods),
    FErr = fun(Item, ListErr) ->
        case Item of 
            {goods, GoodsTypeId, Num} -> [{GoodsTypeId, Num}|ListErr];
            {goods, GoodsTypeId, Num, Bind} -> [{GoodsTypeId, Num, Bind}|ListErr];
            {goods_attr, GoodsTypeId, Num, AttrList} -> [{GoodsTypeId, Num, AttrList}|ListErr];
            _ -> ListErr
        end
    end,
    ErrList = lists:foldl(FErr, [], ErrorGoodsList),
    OtherList = maps:get(other_goods, MapIgnore, []),
    GodEquipList = maps:get(god_equip, MapIgnore, []),
    SealEquipList = maps:get(seal_equip, MapIgnore, []),
    %?IF(length(IgnoreList)>0, lib_log_api:log_send_reward_result(RoleId, ProduceId, IgnoreList, 1), ok),
    ?IF(length(ErrList)>0, lib_log_api:log_send_reward_result(RoleId, ProduceId, ErrList, Res), ok),
    handle_handle_send_reward_result_mail(god_equip, RoleId, GodEquipList, Produce),
    handle_handle_send_reward_result_mail(seal_equip, RoleId, SealEquipList, Produce),
    handle_handle_send_reward_result_mail(other_goods, RoleId, OtherList, Produce).

handle_handle_send_reward_result_mail(god_equip, RoleId, GodEquipList, Produce) when length(GodEquipList)>0 ->
    #produce{type = Type, title = Title, content = Content} = Produce,
    case Title == "" orelse Content == "" of 
        true ->
            ProduceAbout = data_produce_type:get_produce_content(Type),
            NewTitle = utext:get(1500001), NewContent = utext:get(1500002, [util:make_sure_binary(ProduceAbout)]),
            lib_mail_api:send_sys_mail([RoleId], NewTitle, NewContent, GodEquipList);
        _ ->    
            lib_mail_api:send_sys_mail([RoleId], Title, Content, GodEquipList)
    end;

handle_handle_send_reward_result_mail(seal_equip, RoleId, SealEquipList, Produce) when length(SealEquipList)>0 ->
    #produce{type = Type, title = Title, content = Content} = Produce,
    case Title == "" orelse Content == "" of 
        true ->
            _ProduceAbout = data_produce_type:get_produce_content(Type),
            NewTitle = utext:get(1500005), NewContent = utext:get(1500006),
            lib_mail_api:send_sys_mail([RoleId], NewTitle, NewContent, SealEquipList);
        _ ->    
            lib_mail_api:send_sys_mail([RoleId], Title, Content, SealEquipList)
    end;

handle_handle_send_reward_result_mail(other_goods, RoleId, OtherList, Produce) when length(OtherList)>0 ->
    #produce{type = Type, title = Title, content = Content} = Produce,
    case Title == "" orelse Content == "" of 
        true ->
            ProduceAbout = data_produce_type:get_produce_content(Type),
            NewTitle = utext:get(1500003), NewContent = utext:get(1500004, [util:make_sure_binary(ProduceAbout)]),
            lib_mail_api:send_sys_mail([RoleId], NewTitle, NewContent, OtherList);
        _ ->    
            lib_mail_api:send_sys_mail([RoleId], Title, Content, OtherList)
    end;
    
handle_handle_send_reward_result_mail(_, _RoleId, _, _Produce) -> ok.

%% ---------------------------------------------------------------------------
%% @doc 给物品并刷新客户端以及做物品日志
% -spec give_goods(Player, GoodsTypeId, Num, Type, SubType) -> Res when
%     Player      :: #player_status{},        %% 玩家记录
%     GoodsTypeId :: integer(),               %% 物品类型Id
%     Num         :: integer(),               %% 物品数量
%     Type        :: atom(),                  %% 物品产出类型
%                                             %% 需要后台定义"产出消耗类型--产出类型"
%     SubType     :: integer(),               %% 物品产出子类型
%     Res         :: integer().               %% 结果码 1 成功， 2物品类型不存在, 3 背包数量不足, 4动态属性设置权限不足, 5列表中GoodsTypeId重复
%% ---------------------------------------------------------------------------
% give_goods(PlayerInfo, GoodsTypeId, Num, Type, SubType) when Num>0 ->
%     {PlayerId, Pid} = get_id_pid(PlayerInfo),
%     Res = case Pid =:= self() of
%         true ->
%             lib_goods_do:give_goods(GoodsTypeId, Num);
%         false ->
%             ?NOT_IN_PLAYER_PROCESS(0)
%     end,
%     case Res==1 andalso Type=/=[] of
%         1 ->
%             lib_log_api:log_goods(Type, SubType, GoodsTypeId, Num, PlayerId, "");
%         _ ->
%            ok
%     end,
%     Res;
% give_goods(_PlayerInfo, _GoodsTypeId, Num, _Type, _SubType) ->
%     ?ERR("~p:~p param error:~p", [?MODULE, ?LINE, Num]),
%     0.

% give_goods(PlayerInfo, GoodsTypeId, Num) ->
%     give_goods(PlayerInfo, GoodsTypeId, Num, "", 0).

%% 构造详细的奖励列表
%% @param 物品列表 需要发给玩家的物品列表 [{Type, GoodsTypeId, Num}]
%% @param UpGoodsList 生成后的物品 [#goods{},...]
%% @return [{Type, GoodsTypeId, Num}|{format_detail, Type, GoodsTypeId, #goods{}}]
format_detail_reward_list([], _UpGoodsList, R) -> lists:reverse(R);
format_detail_reward_list([H|T], UpGoodsList, R) ->
    case H of
        {Type = ?GOODS_TYPE_EQUIP, GoodsTypeId, Num} ->
            {NewUpGoodsList, NewR} = format_detail_reward_list(Type, GoodsTypeId, Num, UpGoodsList, R),
            format_detail_reward_list(T, NewUpGoodsList, NewR);
        {Type = ?GOODS_TYPE_EUDEMONS, GoodsTypeId, Num} ->
            {NewUpGoodsList, NewR} = format_detail_reward_list(Type, GoodsTypeId, Num, UpGoodsList, R),
            format_detail_reward_list(T, NewUpGoodsList, NewR);
        {Type = ?GOODS_TYPE_GOD_EQUIP, GoodsTypeId, Num} ->
            {NewUpGoodsList, NewR} = format_detail_reward_list(Type, GoodsTypeId, Num, UpGoodsList, R),
            format_detail_reward_list(T, NewUpGoodsList, NewR);
        {Type = ?GOODS_TYPE_DECORATION, GoodsTypeId, Num} ->
            {NewUpGoodsList, NewR} = format_detail_reward_list(Type, GoodsTypeId, Num, UpGoodsList, R),
            format_detail_reward_list(T, NewUpGoodsList, NewR);
        {Type, GoodsTypeId, Num} ->
            case data_goods_type:get(GoodsTypeId) of
                #ets_goods_type{type = ?GOODS_TYPE_EQUIP} -> 
                    {NewUpGoodsList, NewR} = format_detail_reward_list(Type, GoodsTypeId, Num, UpGoodsList, R),
                    format_detail_reward_list(T, NewUpGoodsList, NewR);
                #ets_goods_type{type = ?GOODS_TYPE_EUDEMONS} -> 
                    {NewUpGoodsList, NewR} = format_detail_reward_list(Type, GoodsTypeId, Num, UpGoodsList, R),
                    format_detail_reward_list(T, NewUpGoodsList, NewR);
                #ets_goods_type{type = ?GOODS_TYPE_GOD_EQUIP} ->
                    {NewUpGoodsList, NewR} = format_detail_reward_list(Type, GoodsTypeId, Num, UpGoodsList, R),
                    format_detail_reward_list(T, NewUpGoodsList, NewR);
                #ets_goods_type{type = ?GOODS_TYPE_DECORATION} -> 
                    {NewUpGoodsList, NewR} = format_detail_reward_list(Type, GoodsTypeId, Num, UpGoodsList, R),
                    format_detail_reward_list(T, NewUpGoodsList, NewR);
                #ets_goods_type{type = ?GOODS_TYPE_SOUL} ->
                    {NewUpGoodsList, NewR} = format_detail_reward_list(Type, GoodsTypeId, Num, UpGoodsList, R),
                    format_detail_reward_list(T, NewUpGoodsList, NewR);
                #ets_goods_type{type = ?GOODS_TYPE_CONSTELLATION} ->
                    {NewUpGoodsList, NewR} = format_detail_reward_list(Type, GoodsTypeId, Num, UpGoodsList, R),
                    format_detail_reward_list(T, NewUpGoodsList, NewR);
                _ -> 
                    format_detail_reward_list(T, UpGoodsList, [{Type, GoodsTypeId, Num}|R])
            end;
        Other ->
            format_detail_reward_list(T, UpGoodsList, [Other|R])
    end.

format_detail_reward_list(_Type, _GoodsTypeId, 0, UpGoodsList, R) -> {UpGoodsList, R};
format_detail_reward_list(Type, GoodsTypeId, Num, UpGoodsList, R) ->
    case lists:keytake(GoodsTypeId, #goods.goods_id, UpGoodsList) of
        {value, #goods{type = ?GOODS_TYPE_EQUIP} = GoodsInfo, NewUpGoodsList} ->
            NewR = [{format_detail, Type, GoodsTypeId, GoodsInfo}|R],
            format_detail_reward_list(Type, GoodsTypeId, Num-1, NewUpGoodsList, NewR);
        {value, #goods{type = ?GOODS_TYPE_EUDEMONS} = GoodsInfo, NewUpGoodsList} ->
            NewR = [{format_detail, Type, GoodsTypeId, GoodsInfo}|R],
            format_detail_reward_list(Type, GoodsTypeId, Num-1, NewUpGoodsList, NewR);
        {value, #goods{type = ?GOODS_TYPE_DECORATION} = GoodsInfo, NewUpGoodsList} ->
            NewR = [{format_detail, Type, GoodsTypeId, GoodsInfo}|R],
            format_detail_reward_list(Type, GoodsTypeId, Num-1, NewUpGoodsList, NewR);
        {value, #goods{type = ?GOODS_TYPE_SOUL} = GoodsInfo, NewUpGoodsList} ->
            NewR = [{format_detail, Type, GoodsTypeId, GoodsInfo}|R],
            format_detail_reward_list(Type, GoodsTypeId, Num-1, NewUpGoodsList, NewR);
        {value, #goods{type = ?GOODS_TYPE_CONSTELLATION} = GoodsInfo, NewUpGoodsList} ->
            NewR = [{format_detail, Type, GoodsTypeId, GoodsInfo}|R],
            format_detail_reward_list(Type, GoodsTypeId, Num-1, NewUpGoodsList, NewR);
        {value, #goods{type = ?GOODS_TYPE_GOD_EQUIP} = GoodsInfo, NewUpGoodsList} ->
            NewR = [{format_detail, Type, GoodsTypeId, GoodsInfo}|R],
            format_detail_reward_list(Type, GoodsTypeId, Num-1, NewUpGoodsList, NewR);
        _ ->
            {UpGoodsList, [{Type, GoodsTypeId, Num}|R]}
    end.

%% 获得可查看的物品列表(自己查看)
%% [{Type, GoodsTypeId, Num, 物品唯一键}]
make_see_reward_list(RewardL, UpGoodsL) ->
    DetailRewardL = format_detail_reward_list(RewardL, UpGoodsL, []),
    F = fun
        ({format_detail, Type, GoodsTypeId, GoodsInfo}, L) -> [{Type, GoodsTypeId, 1, GoodsInfo#goods.id}|L];
        ({Type, GoodsTypeId, Num}, L) -> [{Type, GoodsTypeId, Num, 0}|L];
        (_T, L) -> L
    end,
    lists:reverse(lists:foldl(F, [], DetailRewardL)).

%% 获得可查看的物品列表(本服玩家)
%% [{Type, GoodsTypeId, Num, 物品唯一键}]
make_see_reward_list_for_bf(RewardL, UpGoodsL) ->
    DetailRewardL = format_detail_reward_list(RewardL, UpGoodsL, []),
    F = fun
        ({format_detail, Type, GoodsTypeId, GoodsInfo}, L) -> [{Type, GoodsTypeId, 1, GoodsInfo#goods.id, GoodsInfo#goods.player_id}|L];
        ({Type, GoodsTypeId, Num}, L) -> [{Type, GoodsTypeId, Num, 0, 0}|L];
        (_T, L) -> L
    end,
    lists:reverse(lists:foldl(F, [], DetailRewardL)).

%% 制作奖励参数:后续可能会增加其他字段
make_reward_args(#player_status{figure = Figure}) ->
    make_reward_args(Figure);
make_reward_args(#figure{career = Career}) ->
    #reward_args{career=Career}.

%% @param Rewward #player_status{} | #figure{}
calc_reward(Record, Reward) ->
    RewardArgs = make_reward_args(Record),
    calc_reward_help(Reward, RewardArgs).

%% 计算奖励:通用的解析
%% @param RewardArgs
calc_reward_help({?REWARD_TYPE_NORMAL, Reward}, _RewardArgs) -> Reward;
calc_reward_help({?REWARD_TYPE_CAREER, RewardKvL}, #reward_args{career=Career}) ->
    case lists:keyfind(Career, 1, RewardKvL) of
        {Career, Reward} -> Reward;
        _ -> []
    end;
calc_reward_help(Reward, _RewardArgs) ->
    Reward.

%% -----------------------------------------------------------------
%% @desc     功能描述  合并重复项
%% @param    参数      [{GoodsType, GoodsId, Num, GoodsAutoId}]  GoodsAutoId::integer() 物品唯一id
%% @return   返回值    [{GoodsType, GoodsId, Num, GoodsAutoId}]
%% @history  修改历史
%% -----------------------------------------------------------------
combine_object_with_auto_goods_id(List) ->
    List1 = [{{GoodsType, GoodsId, GoodsAutoId}, Num}||{GoodsType, GoodsId, Num, GoodsAutoId} <- List],
    List2 = util:combine_list(List1),
    [{_GoodsType, _GoodsId, _Num, _GoodsAutoId} || {{_GoodsType, _GoodsId, _GoodsAutoId}, _Num} <- List2].

%% 过滤物品列表
%% Condition:[{career, Career}|{sex, Sex}]
filter_goods(ObjectList, Condition) ->
    F = fun({Type, GoodsTypeId, Num}, L) when Type == ?TYPE_GOODS ->
            case data_goods_type:get(GoodsTypeId) of 
                #ets_goods_type{career = Career, sex = Sex} ->
                    Filter = fun(Key, Value) -> 
                        if
                            Key == career andalso Career =/= 0 andalso Career =/= Value -> true;
                            Key == sex andalso Sex == 0 andalso Sex =/= Value -> true;
                            true -> false
                        end
                    end,
                    case length([1 || {K, V} <- Condition, Filter(K, V) == true]) > 0 of 
                        true -> %% 存在不符条件的item
                            L;
                        _ ->
                            [{Type, GoodsTypeId, Num}|L]
                    end;
                _ -> [{Type, GoodsTypeId, Num}|L]
            end;
        ({Type, GoodsTypeId, Num}, L) -> 
            [{Type, GoodsTypeId, Num}|L]
    end,
    lists:foldl(F, [], ObjectList).

%% -----------------------------------------------------------------
%% @desc     功能描述 复数次抽奖， 分别在对应的列表id上抽奖
%% @param    参数    DrawList::[{列表id, 抽奖次数}]  Pool::list()  [{列表id,   [{{Type, GoodId, Num}, W}]}]
%% @return   返回值  [{Type, GoodId, Num}]
%% @history  修改历史
%% -----------------------------------------------------------------

get_reward_by_draw_mul_times(DrawList, Pool) ->
    RewardList = get_reward_by_draw_mul_times(DrawList, Pool, []),
    [{GoodType, GoodId, Num} || {GoodType, GoodId, Num}<-RewardList, Num > 0].
    
get_reward_by_draw_mul_times([], _Pool, Res) ->
    Res;
get_reward_by_draw_mul_times(_, [], _Res) ->
    [];
get_reward_by_draw_mul_times([{ListId, DrawNum} | TailDrawList], Pool, Res) ->
    case lists:keyfind(ListId, 1, Pool) of
        false ->
            get_reward_by_draw_mul_times(TailDrawList, Pool, Res);
        {ListId, SubPool} ->
            RewardList = get_reward_by_draw_mul_times2(SubPool, DrawNum),
            get_reward_by_draw_mul_times(TailDrawList, Pool, RewardList ++ Res)
    end;
get_reward_by_draw_mul_times(_, _, _) ->
    [].

get_reward_by_draw_mul_times2(_Pool, 0) ->
    [];
get_reward_by_draw_mul_times2([], _) ->
    [];
get_reward_by_draw_mul_times2(Pool, DrawNum) ->
    TempList = find_ratio_list(Pool, 2, DrawNum),
    RewardList = [ Reward || {Reward, _W} <- TempList],
    RewardList.

%% -----------------------------------------------------------------
%% @desc     功能描述
%% @param    参数   List:: [element]  ,N::integer 权重坐标,   Times::抽奖次数
%% @return   返回值  [element].
%% @history  修改历史
%% -----------------------------------------------------------------
find_ratio_list([], _N, _Times) ->
    [];
find_ratio_list(List, N, Times) ->
    find_ratio_list(List, N, Times, []).
find_ratio_list(_List, _N, 0, Res) ->
    Res;
find_ratio_list(List, N, Times, Res) ->
    R = util:find_ratio(List, N),
    find_ratio_list(List, N, Times - 1, [R | Res]).

%% 背包不足时发的邮件内容
send_mail_when_no_cell(RoleId, Produce, RewardList) ->
    #produce{type = Type, title = Title, content = Content} = Produce,
    Location = calc_reward_location(RewardList),
    lib_server_send:send_to_uid(RoleId, pt_150, 15029, [1, Location]),
    if
        Title =/= "" andalso Content =/= "" ->
            lib_mail_api:send_sys_mail([RoleId], Title, Content, RewardList);
        true ->
            ProduceAbout = data_produce_type:get_produce_content(Type),
            NewTitle = utext:get(1500003), NewContent = utext:get(1500004, [util:make_sure_binary(ProduceAbout)]),
            lib_mail_api:send_sys_mail([RoleId], NewTitle, NewContent, RewardList)
    end.

calc_reward_location([{_, GoodsTypeId, _}|_]) ->
    case data_goods_type:get(GoodsTypeId) of
        #ets_goods_type{bag_location = Location} -> Location;
        _ -> 0
    end;
calc_reward_location(_) -> 0.

%% 玩家进程调用: 计算实际消耗的物品内容
%% CostList:[{type,id,num}]
%% Return:{ok, MoneyList, DelGoodsList}|{false, Errcode}
calc_cost_goods(CostList) ->
    GS = lib_goods_do:get_goods_status(),
    UniCost = lib_goods_api:make_reward_unique(CostList),
    case calc_cost_goods(GS, UniCost, []) of 
        {false, ErrCode} -> {false, ErrCode};
        ReturnList ->
            {_, MoneyList} = ulists:keyfind(money, 1, ReturnList, {money, []}),
            {_, DelGoodsList} = ulists:keyfind(goods, 1, ReturnList, {goods, []}),
            {ok, MoneyList, DelGoodsList}
    end.

calc_cost_goods(_GS, [], Return) -> Return;
calc_cost_goods(GS, [{Type, TypeId, GoodsNum}|CostList], Return) ->
    case Type of 
        ?TYPE_GOODS ->
            case data_goods_type:get(TypeId) of 
                #ets_goods_type{bag_location = BagLocation} ->
                    GoodsList = lib_goods_util:get_type_goods_list(GS#goods_status.player_id, TypeId, BagLocation, GS#goods_status.dict),
                    TotalNum = lib_goods_util:get_goods_totalnum(GoodsList),
                    case TotalNum >= GoodsNum of
                        true ->
                            GoodsListSort = lib_goods_util:sort(GoodsList, bind_num),
                            F = fun(GoodsInfo, {LeftNum, DelList}) ->
                                case LeftNum > 0 of 
                                    true ->
                                        DelNum = GoodsInfo#goods.num,
                                        ?IF(LeftNum >= DelNum, {LeftNum-DelNum, [{GoodsInfo, DelNum}|DelList]}, {0, [{GoodsInfo, LeftNum}|DelList]});
                                    _ ->
                                        {LeftNum, DelList}
                                end
                            end,
                            {_, DelGoodsList} = lists:foldl(F, {GoodsNum, []}, GoodsListSort),
                            {_, OldDelList} = ulists:keyfind(goods, 1, Return, {goods, []}),
                            NewReturn = lists:keystore(goods, 1, Return, {goods, DelGoodsList++OldDelList}),
                            calc_cost_goods(GS, CostList, NewReturn);
                        false ->
                            {false, ?GOODS_NOT_ENOUGH}
                    end;
                _ ->
                    {false, ?MISSING_CONFIG}
            end;
        _ ->
            {_, OldMoneyList} = ulists:keyfind(money, 1, Return, {money, []}),
            NewReturn = lists:keystore(money, 1, Return, {money, [{Type, TypeId, GoodsNum}|OldMoneyList]}),
            calc_cost_goods(GS, CostList, NewReturn)
    end.

trans_to_attr_goods(RewardList) ->
    F = fun(Item, List) ->
        case Item of 
            {Type, Id, Num} -> [{Type, Id, Num, []}|List];
            {?TYPE_BIND_GOODS, Id, Num, Bind} -> [{?TYPE_ATTR_GOODS, Id, Num, [{bind, Bind}]}|List];
            {?TYPE_ATTR_GOODS, Id, Num, Attr} -> [{?TYPE_ATTR_GOODS, Id, Num, Attr}|List];
            _ -> List
        end
    end,
    lists:foldl(F, [], RewardList).


%% 计算消耗后的静态数据
calc_static_bag(StaticBag, ObjectList) ->
    calc_static_bag_help(ObjectList, StaticBag).

calc_static_bag_help([], StaticBag) -> StaticBag;
calc_static_bag_help([{?TYPE_GOLD, _, Num}|T], StaticBag) ->
    #static_bag{gold = Gold} = StaticBag,
    NewStaticBag = StaticBag#static_bag{gold = Gold - Num},
    calc_static_bag_help(T, NewStaticBag);

calc_static_bag_help([{?TYPE_BGOLD, _, Num}|T], StaticBag) ->
    #static_bag{bgold = BGold} = StaticBag,
    NewStaticBag = StaticBag#static_bag{bgold = BGold - Num},
    calc_static_bag_help(T, NewStaticBag);

calc_static_bag_help([{?TYPE_COIN, _, Num}|T], StaticBag) ->
    #static_bag{coin = Coin} = StaticBag,
    NewStaticBag = StaticBag#static_bag{coin = Coin - Num},
    calc_static_bag_help(T, NewStaticBag);

calc_static_bag_help([_|T], StaticBag) -> 
    calc_static_bag_help(T, StaticBag).

%% 封装一下物品dict的提取和恢复，避免使用错误
%% FilterConditions：过滤的道具
%% Mod, Fun, InputArgs：执行的业务逻辑
%% apply(Mod, Fun, [GoodsStatus|InputArgs]):return:{ok, NewGoodsStatus, Return}
goods_transactions(GoodsStatus, FilterConditions, Mod, Fun, InputArgs) ->
    GoodsStatusBfTrans = ?IF(FilterConditions == [], GoodsStatus, lib_goods_util:make_goods_status_in_transaction(GoodsStatus, FilterConditions)),
    F = fun() ->
        apply(Mod, Fun, [GoodsStatusBfTrans|InputArgs])
    end,
    case catch lib_goods_util:transaction(F) of 
        {ok, NewStatus, Return} ->
            LastStatus = lib_goods_util:restore_goods_status_out_transaction(NewStatus, GoodsStatusBfTrans, GoodsStatus),
            {ok, LastStatus, Return};
        _Err ->
            ?ERR("goods_transactions error:~p", [_Err]),
            {fail, ?FAIL}
    end.

%% return:{NewPS, NewProduce}
spilt_reward_when_onhook(PS, Produce) ->
    case lib_fake_client:in_fake_client(PS) of
        true -> lib_fake_client_goods:spilt_reward_when_onhook(PS, Produce);
        _ -> {PS, Produce}
    end.

%% return:NewPS
record_cost_when_onhook(PS, Cost, Type) ->
    case lib_fake_client:in_fake_client(PS) of
        true -> lib_fake_client_goods:record_cost_when_onhook(PS, Cost, Type);
        _ -> PS
    end.
record_cost_when_onhook(PS, Money, MoneyType, Type) ->
    case lib_fake_client:in_fake_client(PS) of
        true ->
            case MoneyType of
                ?COIN ->lib_fake_client_goods:record_cost_when_onhook(PS, [{?TYPE_COIN, 0, Money}], Type);
                ?BGOLD ->lib_fake_client_goods:record_cost_when_onhook(PS, [{?TYPE_BGOLD, 0, Money}], Type);
                ?GOLD ->lib_fake_client_goods:record_cost_when_onhook(PS, [{?TYPE_GOLD, 0, Money}], Type);
                _ -> PS
            end;
        _ -> PS
    end.