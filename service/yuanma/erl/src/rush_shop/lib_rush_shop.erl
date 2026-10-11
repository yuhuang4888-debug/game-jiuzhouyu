%% ---------------------------------------------------------------------------
%% @doc 抢购商城逻辑.
%% @author zhaoyu
%% @since  2014-07-08
%% @update by ningguoqiang 2015-07-14
%% @update by zengzy 2017-08-08
%% ---------------------------------------------------------------------------
-module(lib_rush_shop).


-export([
    login/1                         %% 登录处理
    , goods_list/1                   %% 获取抢购商城的物品列表
    , list_goods/3                   %% 获取抢购商城的物品列表(进程)
    , buy_goods/3                    %% 购买兑换商店里的物品
    , goods_buy/5                    %% 购买兑换商店里的物品(进程)

    , add_goods/6                    %% 玩家购买商品(玩家进程)
    , update_daily/4                 %% 玩家更新当日购买次数(玩家进程)

    , broadcast_remaining_num/1      %% 通知在线玩家抢购商城商品的可以购买数量变化了
    , broadcast_delete_goods/1       %% 通知在线玩家抢购商城下架商品
    , send_del_info/3                %% 发送下架信息(玩家)
    , broadcast_goods/1              %% 通知在线玩家抢购商城新开售的物品
    , send_add_info/3                %% 发送上架信息(玩家)

    , check_refresh/1                %% 检测数据更新
    , daily_clear/1                  %% 零点更新数据
    , reset_clear/1                  %% 零点删除可重置商品的记录
]).

-export([reload/0, reload/1, reset_role_daily/1, send_product_info/2]).

-include("server.hrl").
-include("common.hrl").
-include("rush_shop.hrl").
-include("goods.hrl").
-include("predefine.hrl").
-include("errcode.hrl").

%% @doc 条件检查
% -define(QUIT_IF(Bool, Reason),
%     case Bool of
%         false -> skip;
%         true -> erlang:throw(Reason)
%     end
% ).
%% ---------------------------------------------------------------------------
%% @doc 登录处理
-spec login(RoleID) -> {Time, any()} when
    RoleID :: integer(),
    Time :: integer().   %% 当日最新时间
%% ---------------------------------------------------------------------------
login(RoleID) ->
    Info = lib_rush_shop_data:load_role_data(RoleID),
    Now = utime:unixtime(),
    Dict = do_login(Info, Now, dict:new()),
    {Now, Dict}.

do_login([[ID, DailyDone, Time] | T], Now, Dict) ->
    NewDict =
    case data_rush_shop:get_goods_info(ID) of
        #rush_shop_goods{refresh = IsRefresh} ->
            case IsRefresh =:= 1 andalso (not is_same_day(Time, Now)) of
                true -> Dict;
                false -> dict:store(ID, DailyDone, Dict)
            end;
        _ -> Dict
    end,
    do_login(T, Now, NewDict);
do_login([], _Now, Dict) ->
    Dict.

%% 判断是否同一天(0点重置)
is_same_day(T1, T2) ->
    {D1, _} = calendar:seconds_to_daystime(T1 + 3600 * 8),
    {D2, _} = calendar:seconds_to_daystime(T2 + 3600 * 8),
    D1 =:= D2.


%% ---------------------------------------------------------------------------
%% @doc 获取抢购商城的物品列表 
-spec goods_list(Player) -> {ok, NewPlayer} when
    Player :: #player_status{},
    NewPlayer :: #player_status{}.
%% ---------------------------------------------------------------------------
goods_list(#player_status{sid = Sid, rush_shop = {Time, LimitShop}} = Player) ->
    Now = utime:unixtime(),
    case is_same_day(Time, Now) of
        true ->
            NewLimitShop = LimitShop;
        false ->
            NewLimitShop = reset_daily(LimitShop)
    end,
    Pid = misc:whereis_name(global, mod_rush_shop),
    gen_server:cast(Pid, {'list_goods', Sid, NewLimitShop}),
    {ok, Player#player_status{rush_shop = {Now, NewLimitShop}}}.

%% @doc 进程发送商品信息
list_goods(#rush_shop{selling = Selling}, Sid, LimitShop) ->
    Now = utime:unixtime(),
    Info = get_product_info(Selling, Now, LimitShop, []),
%%    ?PRINT("64000 goodslist ~p ~n Selling :~p~n", [Info, Selling]),
    {ok, Bin} = pt_640:write(64000, [Info]),
    lib_server_send:send_to_sid(Sid, Bin),
    ok.

%% 商品发送信息
get_product_info([{ID, AllDoneNum, _ETime} | T], Now, Dict, Result) ->
    case data_rush_shop:get_goods_info(ID) of
        #rush_shop_goods{
            goods_id = GoodsId, default_num = Num,
            price_type = PriceType, price = Price,
            limit_price = NewPrice, daily_limit_num = LimitNum,
            total_limit_num = TotalNum, expire_time = _ExpireTime
        } ->
            LessNum = get_role_product_done(ID, Dict),
            % PriceType =
            % case Type of
            %     bgold -> 2;
            %     _ -> 1 %% 其他情况一律扣元宝
            % end,
            Product = {
                ID, GoodsId, Num, PriceType, Price, NewPrice, TotalNum, TotalNum - AllDoneNum,
                LimitNum, LessNum
%%                , max(0, ETime - Now), ExpireTime
            },
            get_product_info(T, Now, Dict, [Product | Result]);
        _ ->
            get_product_info(T, Now, Dict, Result)
    end;
get_product_info([], _Now, _Dict, Result) ->
    Result.

%% 查询玩家商品当日购买次数
get_role_product_done(ID, Dict) ->
    case dict:find(ID, Dict) of
        {ok, Value} ->
            Value;
        error ->
            0
    end.

%% ---------------------------------------------------------------------------
%% @doc 购买抢购商城里的物品 
-spec buy_goods(Player, ID, Num) -> {false, Reason} | {ok, NewPlayer} when
    Player :: #player_status{},
    NewPlayer :: #player_status{},
    ID :: integer(), %% 商品id
    Num :: integer(), %% 购买数量
    Reason :: integer().           %% 提示码(0失败 1成功 2商品已下架 3金额不足
%% 4达到限购次数 5售罄 6商品剩余数量不足 7商品未上架)
%% ---------------------------------------------------------------------------
buy_goods(#player_status{id = RoleID, rush_shop = {Time, LimitShop}} = Player, ID, Num) ->
    Now = utime:unixtime(),
    NewLimitShop =
        case is_same_day(Time, Now) of
            true -> LimitShop;
            false -> reset_daily(LimitShop)
        end,
    case catch check_buy(Player#player_status{rush_shop = {Now, NewLimitShop}}, ID, Num) of
        ok ->
            %% 先增加数量
            NewLimitShop1 = dict:update_counter(ID, Num, NewLimitShop),
            Done = get_role_product_done(ID, NewLimitShop1),
            Pid = misc:whereis_name(global, mod_rush_shop),
            gen_server:cast(Pid, {'goods_buy', RoleID, ID, Num, Done}),
            {ok, Player#player_status{rush_shop = {Now, NewLimitShop1}}};
        ErrCode when is_integer(ErrCode) ->
            {false, ErrCode};
        _Err ->
            {false, ?ERRCODE(err_limit_num)}
    end.

%% 检查玩家购买条件
check_buy(#player_status{rush_shop = {_Time, LimitShop}} = Player, ID, Num) ->
    %% 检查抢购商城是否配置了这个商品
    #rush_shop_goods{goods_id = GoodsID,
        price_type = Type,
        limit_price = Price,
        daily_limit_num = DailyLimit} = data_rush_shop:get_goods_info(ID),
    %% 检查物品是否存在
    #ets_goods_type{} = data_goods_type:get(GoodsID),
    %% 检查玩家限购数量
    Done = get_role_product_done(ID, LimitShop),
    case Done + Num > DailyLimit of
        true ->
            skip;
        false ->
            %% 通用的扣东西检查
            case lib_goods_api:check_object_list(Player, [{Type, 0, Price * Num}]) of
                true -> ok;
                {false, Err} -> Err
            end
%% 检查玩家是否够钱
%%            HadValue =
%%                case Type of
%%                    ?TYPE_GOLD -> Player#player_status.gold;
%%                    ?TYPE_BGOLD -> Player#player_status.bgold
%%                end,
%%            case HadValue >= (Price * Num) of
%%                true ->
%%                    ok;
%%                false ->
%%                    ?ERRCODE(gold_not_enough)
%%            end
    end.

%% @doc 进程处理购买商品
goods_buy(#rush_shop{selling = Selling, refresh_timer = Timer} = State, RoleID, ID, Num, DailyDone) ->
    {Reply, TotalNum} =
        case catch check_selling(State, ID, Num) of
        {ok, TotalNum1} ->
            {1, TotalNum1};
        Reply1 when is_integer(Reply1) ->
            {Reply1, 0};
        _Err ->
            {0, 0}
    end,
    case Reply =:= 1 of
        true ->
            {_, Done, ETime} = lists:keyfind(ID, 1, Selling),
            NewDone = Done + Num,
            NewSelling = lists:keyreplace(ID, 1, Selling, {ID, NewDone, ETime}),
            %% 更新标志
            lib_rush_shop_data:set_update(ID),
            case erlang:is_reference(Timer) andalso erlang:read_timer(Timer) =/= false of
                true ->
                    NewTimer = Timer;
                false ->
                    NewTimer = erlang:send_after(1000, self(), 'refresh')
            end,
            %% 通知玩家进行道具增加操作
            Pid = misc:get_player_process(RoleID),
            case is_pid(Pid) of
                true ->
                    % gen_server:cast(Pid, {rush_shop_give, ID, Num, Reply, TotalNum - NewDone});
                    % ?PRINT("goods_buy ID, Num, Reply, NewDone :~w~n",[[ID, Num, Reply, NewDone]]),
                    lib_player:apply_cast(RoleID, ?APPLY_CAST_STATUS, ?MODULE, add_goods, [ID, Num, Reply, NewDone,max(0, TotalNum - NewDone)]);
                false ->
                    ok
            end,
            %% 保存数据
            spawn(fun() -> lib_rush_shop_data:save_buy(RoleID, ID, NewDone, DailyDone) end),
            {ok, State#rush_shop{selling = NewSelling, refresh_timer = NewTimer}};
        false ->
            %% 重置每日次数
            lib_player:apply_cast(RoleID, ?APPLY_CAST_STATUS, ?MODULE, update_daily, [ID, Num, Reply]),
            {ok, State}
    end.

%% 检查商店销售商品
check_selling(#rush_shop{selling = Selling, wait = _Wait}, ID, _Num) ->
    #rush_shop_goods{total_limit_num = TotalNum} = data_rush_shop:get_goods_info(ID),
    case lists:keyfind(ID, 1, Selling) of
        % {_, Done, _} when TotalNum =< Done orelse TotalNum < (Done + Num)->
        %     ?ERRCODE(goods_not_enough);
        % ?QUIT_IF(TotalNum =< Done, 5),
        % ?QUIT_IF(TotalNum < (Done + Num), 6),
        {_, _Done, _} ->
%%            ?PRINT("lists:keyfind(ID, 1, Selling) :~w~n",[lists:keyfind(ID, 1, Selling)]),
            {ok, TotalNum};
        false ->
            % ?QUIT_IF(lists:keymember(ID, 1, Wait), 7),
            ?ERRCODE(err640_goods_not_on_sale)
    end.

%% @doc 玩家获得商品
%% （物品id, 物品数量，返回值， 玩家购买的数量 ）
add_goods(#player_status{sid = Sid} = Player, ID, Num, Reply, _Rest, LeastNum) ->
    #rush_shop_goods{
        goods_id = GoodsID, default_num = PerN, price_type = Type,
        limit_price = Price, expire_time = _ExpireTime
    } = data_rush_shop:get_goods_info(ID),
    Cost = [{Type, 0, Price * Num}],
    Award = case GoodsID of
                ?TYPE_BGOLD ->
                    [{?TYPE_BGOLD, 0, PerN * Num}];
                ?TYPE_GOLD ->
                    [{?TYPE_GOLD, 0, PerN * Num}];
                _ ->
                    [{?TYPE_GOODS, GoodsID, PerN * Num}]
%%                    case ExpireTime > 0 of
%%                        true ->
%%                            [{?TYPE_TIME_GOODS, GoodsID, PerN * Num, 0, ExpireTime}];
%%                        false ->
%%                            [{?TYPE_GOODS, GoodsID, PerN * Num}]
%%                    end
            end,
    %% 先扣款
    PS1 = cost(Cost, Player, 'rush_shop', "rush_shop"),
    %% 后给货
    Produce = #produce{type = rush_shop, reward = Award, show_tips = 3},
    PS2 = lib_goods_api:send_reward(PS1, Produce),
    case lists:keymember(?TYPE_GOLD, 1, Award) orelse lists:keymember(?TYPE_BGOLD, 1, Award) of
        true ->
            lib_player:send_attribute_change_notify(PS2, 2);
        false ->
            skip
    end,
    %% 反馈购买提示
    ?PRINT("64001  Reply, ID, LeastNum :~w~n",[[Reply, ID, Num, LeastNum]]),
    {ok, Bin} = pt_640:write(64001, [Reply, ID, Num, LeastNum]),
    lib_server_send:send_to_sid(Sid, Bin),
    %% 日志
    % log:log_rush_shop(Player, GoodsID, Num, PerN * Num, Cost),
    PS2.

%% 扣除消耗
cost([{?TYPE_BGOLD, 0, BGold} | T], PS, ConsumType, About) when BGold > 0 ->
    NewPS = lib_goods_util:cost_money(PS, BGold, bgold, ConsumType, About),
    % log:log_consume(ConsumType, bgold, PS, NewPS, About),
    cost(T, NewPS, ConsumType, About);
cost([{?TYPE_GOLD, 0, Gold} | T], PS, ConsumType, About) when Gold > 0 ->
    NewPS = lib_goods_util:cost_money(PS, Gold, gold, ConsumType, About),
    % log:log_consume(ConsumType, gold, PS, NewPS, About),
    cost(T, NewPS, ConsumType, About);
cost([{?TYPE_GOODS, GoodsID, Num} | T], PS, ConsumType, About) when Num > 0 ->
    case lib_goods_api:delete_more_by_list(PS, [{?TYPE_GOODS, GoodsID, Num}], ConsumType) of
        1 -> cost(T, PS, ConsumType, About);
        _ -> error
    end;
cost([_ | T], PS, ConsumType, About) ->
    cost(T, PS, ConsumType, About);
cost([], PS, _ConsumType, _About) ->
    PS.

%% @doc 更新玩家商品当日购买次数
update_daily(#player_status{sid = Sid, rush_shop = {Time, LimitShop}} = PS, ID, Num, Reply) ->
    NewLimitShop = dict:update_counter(ID, -Num, LimitShop),
    %% 反馈购买提示
    {ok, Bin} = pt_640:write(64001, [Reply, ID, 0, 0]),
    lib_server_send:send_to_sid(Sid, Bin),
    PS#player_status{rush_shop = {Time, NewLimitShop}}.

%% ---------------------------------------------------------------------------
%% @doc 通知在线玩家抢购商城某个商品的可以购买数量变化了
-spec broadcast_remaining_num(#rush_shop{}) -> ok | skip.
%% ---------------------------------------------------------------------------
broadcast_remaining_num(#rush_shop{selling = Selling}) ->
    case lib_rush_shop_data:get_update() of
        [] ->
            skip;
        L ->
            Info = filter_selling(L, Selling, []),
            {ok, BinData} = pt_640:write(64002, [Info]),
            %% 通知全世界
            send_to_all_online(fun(Id) -> lib_server_send:send_to_uid(Id, BinData) end),
            % spawn(fun() -> lib_unite_send:send_to_all(BinData) end),
            %% 重置
            lib_rush_shop_data:set_update([]),
            ok
    end.

%% 筛选上架商品信息
filter_selling([ID | T], List, Result) ->
    case data_rush_shop:get_goods_info(ID) of
        #rush_shop_goods{total_limit_num = TotalNum} ->
            case lists:keyfind(ID, 1, List) of
                {_, Num, _} ->
                    ok;
                _ ->
                    Num = 0
            end,
            filter_selling(T, List, [{ID, max(0, TotalNum - Num)} | Result]);
        _ ->
            filter_selling(T, List, Result)
    end;
filter_selling([], _List, Result) ->
    Result.

%% ---------------------------------------------------------------------------
%% @doc 通知在线玩家抢购商城下架个商品
-spec broadcast_delete_goods(#rush_shop{}) -> {ok, #rush_shop{}} | skip.
%% ---------------------------------------------------------------------------
broadcast_delete_goods(#rush_shop{selling = []}) ->
    skip;
broadcast_delete_goods(#rush_shop{selling = [{ID, _, Time} | T]} = State) ->
    Now = utime:unixtime(),
    %% 判断移除的时间是否合理(5秒误差)
    case Now < Time andalso Time - Now > 5 of
        true ->
            DelTimer = erlang:send_after((Time - Now) * 1000, self(), 'del'),
            {ok, State#rush_shop{del_timer = DelTimer}};
        false ->
            {Selling, Del} = get_del_ids(T, Time, [ID]),
            Bin =
                case lib_rush_shop_data:get_update() of
                [] -> false;
                L ->
                    Info = filter_selling(L, Selling, []),
                    {ok, Bin1} = pt_640:write(64002, [Info]),
                    Bin1
            end,
            %% 移除下架商品信息
            lib_rush_shop_data:delete_db_data(Del),
            %% 通知全世界
            % spawn(fun() -> online_player_do(?MODULE, send_del_info, [Del, Bin]) end),
            case Bin of
                false -> skip;
                _ ->
                    F = fun(Id) ->
                        lib_player:apply_cast(Id, ?APPLY_CAST_STATUS, ?MODULE, send_del_info, [Del, Bin])
                    end,
                    send_to_all_online(F)
            end,
            %% 重置
            lib_rush_shop_data:set_update([]),
            %% 下架商品设置
            case Selling of
                [{_, _, DelTime} | _] ->
                    DelTimer = erlang:send_after((DelTime - Now) * 1000, self(), 'del');
                _ ->
                    DelTimer = 0
            end,
            {ok, State#rush_shop{selling = Selling, del_timer = DelTimer}}
    end.

%% 检索下架商品
get_del_ids([{ID, _, Time} | T], Time, Result) ->
    get_del_ids(T, Time, [ID | Result]);
get_del_ids(Selling, _Time, Result) ->
    {Selling, Result}.

%% @doc 向玩家发送下架信息
send_del_info(#player_status{sid = Sid, rush_shop = {Time, LimitShop}} = PS, Del, ExtBin) ->
    %% 移除玩家内存信息
    NewLimitShop = lists:foldl(fun(DelId, Dict) -> dict:erase(DelId, Dict) end, LimitShop, Del),
    {ok, Bin} = pt_640:write(64003, [Del]),
    lib_server_send:send_to_sid(Sid, Bin),
    lib_server_send:send_to_sid(Sid, ExtBin),
    PS#player_status{rush_shop = {Time, NewLimitShop}}.

%% ---------------------------------------------------------------------------
%% @doc 通知在线玩家抢购商城新开售的物品
-spec broadcast_goods(#rush_shop{}) -> {ok, #rush_shop{}} | skip.
%% ---------------------------------------------------------------------------
broadcast_goods(#rush_shop{wait = []}) ->
    skip;
broadcast_goods(#rush_shop{
    selling = Selling,
    wait = [{ID, Time, ETime} | T],
    del_timer = DelTimer
} = State) ->
    Now = utime:unixtime(),
    %% 判断移除的时间是否合理(5秒误差)
    case Now < Time andalso Time - Now > 5 of
        true ->
            AddTimer = erlang:send_after((Time - Now) * 1000, self(), 'add'),
            {ok, State#rush_shop{add_timer = AddTimer}};
        false ->
            {Wait, Add} = get_add_ids(T, Time, [{ID, 0, ETime}]),
            %% 同时发送更新信息
            Bin =
            case lib_rush_shop_data:get_update() of
                [] -> false;
                L ->
                    Info = filter_selling(L, Selling, []),
                    {ok, Bin1} = pt_640:write(64002, [Info]),
                    Bin1
            end,
            %% 通知全世界
            % spawn(fun() -> online_player_do(?MODULE, send_add_info, [Add, Bin]) end),
            case Bin of
                false -> skip;
                _ ->
                    F = fun(Id) ->
                        lib_player:apply_cast(Id, ?APPLY_CAST_STATUS, ?MODULE, send_add_info, [Add, Bin])
                        end,
                    send_to_all_online(F)
            end,
            %% 重置
            lib_rush_shop_data:set_update([]),
            %% 上架商品设置
            case Wait of
                [{_, AddTime, _} | _] ->
                    AddTimer = erlang:send_after((AddTime - Now) * 1000, self(), 'add');
                _ ->
                    AddTimer = 0
            end,
            %% 重置下架定时器
            [{_, _, DelTime} | _] = NewSelling = lists:keysort(3, Add ++ Selling),
            cancel_timer_1(DelTimer),
            NewDelTimer = erlang:send_after(max((DelTime - Now), 1) * 1000, self(), 'del'),
            {ok, State#rush_shop{selling = NewSelling, wait = Wait,
                add_timer = AddTimer, del_timer = NewDelTimer}}
    end.

%% 检索上架商品
get_add_ids([{ID, Time, ETime} | T], Time, Result) ->
    get_add_ids(T, Time, [{ID, 0, ETime} | Result]);
get_add_ids(Wait, _Time, Result) ->
    {Wait, Result}.

%% @doc 向玩家发送上架信息
send_add_info(#player_status{sid = Sid, rush_shop = {Time, LimitShop}} = PS, _Add, ExtBin) ->
    Now = utime:unixtime(),
    case is_same_day(Time, Now) of
        true ->
            NewLimitShop = LimitShop;
        false ->
            NewLimitShop = reset_daily(LimitShop)
    end,
    %%通知刷新页面
    Pid = misc:whereis_name(global, mod_rush_shop),
    gen_server:cast(Pid, {'list_goods', Sid, NewLimitShop}),
    lib_server_send:send_to_sid(Sid, ExtBin),
    PS#player_status{rush_shop = {Now, NewLimitShop}}.

%% ---------------------------------------------------------------------------
%% @doc 所有在线玩家执行MFA 
% -spec online_player_do(Module, Fun, Args) -> ok when
%     Module      :: atom(),
%     Fun         :: atom(),
%     Args        :: [term()].
%% ---------------------------------------------------------------------------
% online_player_do(Module, Fun, Args) ->
%     OnlinePlayerIDs = mod_chat_agent:match(all_ids, []),
%     DoFun = fun(PlayerId) ->
%         Pid = misc:get_player_process(PlayerId),
%         case is_pid(Pid) of
%             true ->
%                 gen_server:cast(
%                     Pid, {apply_cast_save, Module, Fun, Args}
%                 );
%             false ->
%                 ok
%         end
%     end,
%     lists:foreach(DoFun, OnlinePlayerIDs),
%     ok.

%% 重置每日购买数量
reset_daily(Dict) ->
    Fun =
        fun(ID, Value, D) ->
            case data_rush_shop:get_goods_info(ID) of
                #rush_shop_goods{refresh = IsRefresh} when IsRefresh =/= 1 ->
                    dict:store(ID, Value, D);
                _ ->
                    D
            end
        end,
    dict:fold(Fun, dict:new(), Dict).

%% 移除定时器
cancel_timer_1(Timer) ->
    case erlang:is_reference(Timer) of
        true ->
            erlang:cancel_timer(Timer);
        false ->
            skip
    end.

%% @doc 检测数据更新
check_refresh(#rush_shop{old_records = Old} = State) ->
    All = data_rush_shop:get_all_goods(),
    Fun =
        fun(ID, Acc) ->
            GoodsInfo = #rush_shop_goods{} = data_rush_shop:get_goods_info(ID),
            [GoodsInfo | Acc]
        end,
    New = lists:foldl(Fun, [], All),
    case lists:keysort(#rush_shop_goods.id, Old) =:= lists:keysort(#rush_shop_goods.id, New) of
        true ->
            Timer = erlang:send_after(60000, self(), 'check'),
            {ok, State#rush_shop{check_timer = Timer}};
        false ->
            reload(State)
    end.

%% 发送给所有在线玩家
send_to_all_online(F) ->
    OnlineList = ets:tab2list(?ETS_ONLINE),
    [F(Id) || #ets_online{id = Id} <- OnlineList].

%%%-----------------------------------------------------------------------------
%% GM专用
%% 重新加载商城数据(公共线调用)
reload() ->
    Pid = misc:whereis_name(global, mod_rush_shop),
    gen_server:cast(Pid, {'reload', node()}).

reload(#rush_shop{add_timer = T1, del_timer = T2, refresh_timer = T3, check_timer = T4}) ->
    %% 移除所有定时器
    cancel_timer_1(T1),
    cancel_timer_1(T2),
    cancel_timer_1(T3),
    cancel_timer_1(T4),
    %% 重置更新标志
    put('refresh', false),
    %% 重新加载设置数据
    State = lib_rush_shop_data:init_all(),
    %% 通知已上架信息
    % spawn(fun() -> online_player_do(?MODULE, send_product_info, [State#rush_shop.selling]) end),
    F = fun(Id) ->
        lib_player:apply_cast(Id, ?APPLY_CAST_STATUS, ?MODULE, send_product_info, [State#rush_shop.selling])
        end,
    send_to_all_online(F),
    {ok, State}.

%% 热更通知商品信息
send_product_info(#player_status{sid = Sid, rush_shop = {Time, LimitShop}} = PS, Selling) ->
    Now = utime:unixtime(),
    case is_same_day(Time, Now) of
        true ->
            NewLimitShop = LimitShop;
        false ->
            NewLimitShop = reset_daily(LimitShop)
    end,
    Info = get_product_info(Selling, Now, LimitShop, []),
    {ok, Bin} = pt_640:write(64000, [Info]),
    lib_server_send:send_to_sid(Sid, Bin),
    PS#player_status{rush_shop = {Now, NewLimitShop}}.

%% 重置玩家每日购买数据
reset_role_daily(RoleID) when is_integer(RoleID) ->
    Pid = misc:get_player_process(RoleID),
    case is_pid(Pid) of
        true ->
            % gen_server:cast(Pid, {apply_cast_save, ?MODULE, reset_role_daily, []});
            lib_player:apply_cast(RoleID, ?APPLY_CAST_STATUS, ?MODULE, reset_role_daily, []);
        false ->
            ok
    end;

reset_role_daily(PS) ->
    #player_status{rush_shop = {_, LimitShop}} = PS,
    NewLimitShop = reset_daily(LimitShop),
    PS#player_status{rush_shop = {utime:unixtime(), NewLimitShop}}.

daily_clear(0) ->
    mod_rush_shop:daily_clear(),
    OnlineList = ets:tab2list(?ETS_ONLINE),
    IdList = [PlayerId || #ets_online{id = PlayerId} <- OnlineList],
    lists:foreach(fun reset_role_daily/1, IdList);
daily_clear(_Other) ->
    skip.

%%零点删除可重置商品的记录
reset_clear(State) ->
    #rush_shop{selling = Selling} = State,
    check_clear(Selling, 0),
    {ok, State}.

check_clear([], _N) -> ok;
check_clear([{Id, _Done, _ETime} | T], N) ->
    case data_rush_shop:get_goods_info(Id) of
        #rush_shop_goods{refresh = IsRefresh} when IsRefresh == 1 ->
            %% 删除玩家购买记录
            Sql = io_lib:format(?RUSH_SHOP_BUY_LOG_DELETE, [Id]),
            db:execute(Sql);
        _ ->
            ok
    end,
    case N > 10 of
        true ->
            timer:sleep(100),
            check_clear(T, 0);
        false ->
            check_clear(T, N + 1)
    end.