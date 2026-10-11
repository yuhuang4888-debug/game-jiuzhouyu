%%-----------------------------------------------------------------------------
%% @Module  :       lib_custom_act_api
%% @Author  :       Czc
%% @Email   :       389853407@qq.com
%% @Created :       2018-01-05
%% @Description:    定制活动API
%%-----------------------------------------------------------------------------
-module(lib_custom_act_api).

-include("custom_act.hrl").
-include("server.hrl").
-include("def_fun.hrl").
-include("def_event.hrl").
-include("rec_event.hrl").
-include("predefine.hrl").
-include("figure.hrl").
-include("def_module.hrl").
-include("common.hrl").
-include("scene.hrl").
-include("drop.hrl").
-include("goods.hrl").
-include("hi_point.hrl").
-include("afk.hrl").
-include("sql_goods.hrl").
-include("rec_recharge.hrl").
-include("def_recharge.hrl").

-export([
    reload_custom_act_cfg/0
    , is_open_act/1
    , is_open_act/2
    % , manual_close_act/3
    , get_open_subtype_ids/1
    , get_open_custom_act_infos/1
    , get_custom_act_open_info_by_actids/1
    , login/2
    , count_reward_status/4
    , handle_event/2
    , get_act_name/2
    , is_feast_boss_time_open/0
    , is_feast_boss_limit_lv/1
    , is_feast_boss_tv_time/0
    , calc_act_drop_online/2
    , calc_act_drop/2
    , calc_act_drop/3
    , update_custom_drop_map/1
    , gm_reset_recieve_times/3
    , gm_clear_act_drop/2
    , clear_act_drop/2
    , refresh_supply_liveness/1
    , gm_change_custom_act_wlv/3
    , is_yy_sh921_lj_57_PM001257_source/0
    , is_yy_sh921_lj_57_PM001257_source_helper/1
    , gm_repace_goods/3
    , gm_repace_goods_helper/3
    , gm_repace_goods2/5
    , gm_repace_goods_helper2/5
    , gm_repace_goods2_call/5
    , calc_offline_act_drop/3
    , gm_reward_by_act_log/3
    , gm_refresh_custom_act_data/3
    , gm_re_trigger_120_act/2
    ]).

%% 消费活动实时更新
handle_event(Player, #event_callback{type_id = ?EVENT_MONEY_CONSUME, data = Data})  ->
    #callback_money_cost{consume_type = ConsumeType, money_type = MoneyType} = Data,
    case lib_consume_data:is_consume_for_act(ConsumeType) of
        true ->
            case lib_consume_data:is_consume_for_act(ConsumeType) of
                true ->
                    [
                        case lib_custom_act_api:get_open_custom_act_infos(ActType) of
                            [_|_] = ConsumeActs ->
                                case ActType of
                                    ?CUSTOM_ACT_TYPE_CONSUME ->
                                        [begin
                                            case lib_custom_act_util:keyfind_act_condition(Type, SubType, money_types) of
                                                {money_types, MoneyTypes} ->
                                                    case lists:member(MoneyType, MoneyTypes) of
                                                        true ->
                                                            pp_custom_act:handle(33107, Player, [Type, SubType]);
                                                        _ ->
                                                            skip
                                                    end;
                                                _ ->
                                                    skip
                                            end
                                        end || #act_info{key = {Type, SubType}} <- ConsumeActs];
                                    ?CUSTOM_ACT_TYPE_RECHARGE_CONSUME ->
                                        [begin
                                            case lib_custom_act_util:keyfind_act_condition(Type, SubType, money_type) of
                                                {money_type, ActMoneyType} ->
                                                    case MoneyType of
                                                        ActMoneyType ->
                                                            pp_custom_act:handle(33164, Player, [SubType]);
                                                        _ ->
                                                            skip
                                                    end;
                                                _R ->
                                                    skip
                                            end
                                        end || #act_info{key = {Type, SubType}} <- ConsumeActs];
                                    ?CUSTOM_ACT_TYPE_CONSUME_RANK ->
                                        if
                                            MoneyType =:= ?GOLD; MoneyType =:= ?BGOLD_AND_GOLD  ->
                                                lib_consume_rank_act:refresh_consume(Player);
                                            true -> skip
                                        end;
                                    ?CUSTOM_ACT_TYPE_CONTINUE_CONSUME ->
                                        if
                                           MoneyType =:= ?GOLD; MoneyType =:= ?BGOLD_AND_GOLD  ->
                                                F = fun
                                                        (Type, SubType) ->
                                                            pp_custom_act:handle(33104, Player, [Type, SubType]),
                                                            pp_custom_act:handle(33143, Player, [SubType])
                                                    end,
                                                [F(Type, SubType)|| #act_info{key = {Type, SubType}} <- ConsumeActs];
                                            true -> skip
                                        end;
                                    _ ->
                                        skip
                                end;
                            _ ->
                                skip
                        end
                    ||ActType <- [?CUSTOM_ACT_TYPE_CONSUME, ?CUSTOM_ACT_TYPE_RECHARGE_CONSUME, ?CUSTOM_ACT_TYPE_CONSUME_RANK, ?CUSTOM_ACT_TYPE_CONTINUE_CONSUME]];
                _ ->
                    skip
            end;
        _ ->
            skip
    end,
    {ok, Player};

handle_event(Player, #event_callback{type_id = ?EVENT_LV_UP}) ->
    #player_status{figure = #figure{lv = RoleLv}} = Player,
    OpenLv = lib_custom_act:get_open_lv(?CUSTOM_ACT_TYPE_SIGN_REWARD),
    if
        RoleLv == OpenLv ->
            {List, SignPlayer} = lib_sign_reward_act:login_for_sign_reward(Player),
            Fun = fun({Type, SubType}) -> 
                lib_custom_act:reward_status(Player, Type, SubType)
            end,
            lists:foreach(Fun, List);
        true ->
            SignPlayer = Player
    end,
    PoolPlayer = lib_bonus_pool:init_data_lv_up(SignPlayer),
    NewPlayer = lib_bonus_draw:init_data_lv_up(PoolPlayer),
    NewPlayerS = lib_bonus_pray:init_data_after_act_open(NewPlayer),
    SelectPoolPS = lib_select_pool_draw:init_data_lv_up(NewPlayerS),
    LvGiftPs = lib_custom_act_lv_gift:init_data_lv_up(SelectPoolPS),
    LvEnvelopePs = lib_envelope_rebate:init_data_lv_up(LvGiftPs),
    LvTheCarnivalPs = lib_custom_the_carnival:init_data_lv_up(LvEnvelopePs),
    LvSubMailPs = lib_custom_subscribe_mail:init_data_lv_up(LvTheCarnivalPs),
    {ok, LvSubMailPs};

%% 事件处理
handle_event(
        Player
        , #event_callback{type_id = ?EVENT_RECHARGE, data = #callback_recharge_data{recharge_product = Product, gold = Gold}}
        ) ->
    NewPlayer = handle_recharge(Player, Product, Gold),
    {ok, NewPlayer};

handle_event(Player, #event_callback{type_id = ?EVENT_LOGIN_CAST}) ->
    LvTheCarnivalPs = lib_custom_the_carnival:init_data_lv_up(Player),
    {ok, LvTheCarnivalPs};

handle_event(Player, #event_callback{type_id = ?EVENT_ENSURE_ACC_FIRST}) ->
    AfRebatePlayer = lib_envelope_rebate:ensure_acc_first(Player),
    {ok, AfRebatePlayer};
% 大妖击杀
handle_event(PS, #event_callback{type_id = ?EVENT_BOSS_KILL, data = EventBossData}) ->
    lib_custom_the_carnival:kill_boss(PS, EventBossData);
% 副本通关
handle_event(PS, #event_callback{type_id = ?EVENT_DUNGEON_SUCCESS, data = EventDunSuccData}) ->
    lib_custom_the_carnival:dungeon_success(PS, EventDunSuccData);

handle_event(Player, _) ->
    {ok, Player}.

%% 充值
handle_recharge(Player, Product, Gold) ->
    PlayerAfTurntable = lib_lucky_turntable:handle_recharge(Player, Product, Gold),
    PlayerAfSign = lib_sign_reward_act:sign_act_handle_recharge(PlayerAfTurntable, Product, Gold),
    PlayerAfRebate = lib_recharge_rebate_act:handle_recharge(PlayerAfSign, Product, Gold),
    PlayerAfEnvelopeRebate = lib_envelope_rebate:handle_recharge(PlayerAfRebate, Product, Gold),
    PlayerAf120Act = handle_recharge_120_act(PlayerAfEnvelopeRebate, Product),
    PlayerAf127Act = lib_custom_act_wish_draw:handle_recharge(PlayerAf120Act, Product, Gold),
    PlayerAf127Act.

handle_recharge_120_act(Player, #base_recharge_product{product_id = ProductId, product_type = ProductType})
    when ProductType == ?PRODUCT_TYPE_DIRECT_GIFT; ProductType == ?PRODUCT_TYPE_GIFT->
    Type = ?CUSTOM_ACT_TYPE_SALE,
    ActInfoL = lib_custom_act_util:get_open_subtype_list(Type),
    #player_status{figure = #figure{lv = RoleLv}} = Player,
    F = fun(#act_info{key = {_, SubType}} = ActInfo, AccPlayer) ->
        case lib_custom_act_check:check_act_condition(Type, SubType, [is_first_rec, role_lv]) of
            [1, NeedLv] -> IsSatisfy = lib_recharge_first:is_buy(AccPlayer) andalso RoleLv >= NeedLv;
            [0, NeedLv] -> IsSatisfy = RoleLv >= NeedLv;
            _ -> IsSatisfy = true
        end,
        if
            IsSatisfy -> do_handle_recharge_120_act(AccPlayer, ActInfo, ProductId);
            true -> AccPlayer
        end
    end,
    lists:foldl(F, Player, ActInfoL);
handle_recharge_120_act(Player, _) ->
    Player.

do_handle_recharge_120_act(Player, ActInfo, ProductId) ->
    #player_status{id = RoleId, figure = #figure{name = RoleName}} = Player,
    #act_info{key = {Type, SubType}} = ActInfo,
    GradeIdL = lib_custom_act_util:get_act_reward_grade_list(Type, SubType),
    F = fun(GradeId, AccPlayer) ->
        RewardCfg = lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GradeId),
        case lib_custom_act_check:check_reward_receive_times(Player, ActInfo, RewardCfg) of
            {true, NewReceiveTimes} ->
                #custom_act_reward_cfg{condition = Condition, name = RewardName, reward = RewardList} = RewardCfg,
                case lib_custom_act_check:check_act_condtion([is_rmb, product_id, tv_id], Condition) of
                    [1, ProductId, TvId] ->
                        AccPlayer1 = lib_custom_act:update_receive_times(AccPlayer, Type, SubType, GradeId, NewReceiveTimes),
                        lib_log_api:log_custom_act_reward(RoleId, Type, SubType, GradeId, RewardList),
                        LastPlayer = lib_goods_api:send_reward(AccPlayer1, #produce{type = custom_act_sale, reward = RewardList}),
                        TvId =/= 0 andalso lib_chat:send_TV({all}, ?MOD_AC_CUSTOM, 70, [RoleName, RoleId, RewardName]),
                        {ok, BinData} = pt_331:write(33105, [1, Type, SubType, GradeId]),
                        lib_server_send:send_to_sid(Player#player_status.sid, BinData),
                        LastPlayer;
                    _ ->
                        AccPlayer
                end;
            false ->
                AccPlayer;
            _ ->
                AccPlayer
        end
    end,
    lists:foldl(F, Player, GradeIdL).


%% 定制活动热更之后后台调用接口
reload_custom_act_cfg() ->
    lib_custom_act_dynamic_compile:dynamic_compile_cfg(),
    case util:is_cls() of
        true ->
            mod_custom_act_kf:apply_cast(reload_act_list, []);
        _ ->
            mod_custom_act:apply_cast(reload_act_list, [])
    end.

% %%--------------------------------------------------
% %% 后台关闭定制活动
% %% @param  Type       活动主类型
% %% @param  SubType    活动子类型
% %% @param  IsExtraAct 是否是额外定制活动 0: 不是 1: 是
% %% @return            description
% %%--------------------------------------------------
% manual_close_act(Type, SubType, IsExtraAct) ->
%     RealSubType = ?IF(IsExtraAct == 1, SubType + ?EXTRA_CUSTOM_ACT_SUB_ADD, SubType),
%     case ets:lookup(?ETS_CUSTOM_ACT, {Type, RealSubType}) of
%         [ActInfo|_] when is_record(ActInfo, act_info) ->
%             NowTime = utime:unixtime(),
%             lib_custom_act:act_end(?CUSTOM_ACT_STATUS_MANUAL_CLOSE, ActInfo, NowTime),
%             ok;
%         _ -> skip
%     end.

%% 玩家登录
login(PlayerStatus, LoginType) ->
    #player_status{id = RoleId} = PlayerStatus,
    List = db:get_all(io_lib:format(?select_custom_act_reward_receive, [RoleId])),
    F = fun([Type, SubType, Grade, ReceiveTimes, Utime], AccMap) ->
        RewardStatus = #reward_status{receive_times = ReceiveTimes, utime = Utime},
        maps:put({Type, SubType, Grade}, RewardStatus, AccMap)
    end,
    RewardMap = lists:foldl(F, #{}, List),
    F2 = fun(#custom_act_data{type = Type, subtype = SubType} = DataR) ->
        {{Type, SubType}, DataR}
    end,
    DataMap = maps:from_list(lists:map(F2, lib_custom_act:db_load_custom_act_data(RoleId))),
    StatusCustomAct = #status_custom_act{
        reward_map = RewardMap
        , data_map = DataMap
    },
    NewPS = update_custom_drop_map(PlayerStatus),
    {_, SignPlayer} = lib_sign_reward_act:login_for_sign_reward(NewPS#player_status{status_custom_act = StatusCustomAct}, LoginType),
    SignPlayer.
    % {_, NewPS} = gm_repace_goods_helper(NewPSDrop, 36255097, 37050001),
    % ?PRINT("===================RewardMap~p  List :~p~n",[RewardMap,List]),
    % NewPS#player_status{status_custom_act = StatusCustomAct}.

%%--------------------------------------------------
%% 活动是否开启
%% @param  Type 活动主类型
%% @return      true|false
%%--------------------------------------------------
is_open_act(Type) ->
    OpenSubList = lib_custom_act_util:get_open_subtype_list(Type),
    OpenSubList =/= [].

%%--------------------------------------------------
%% 活动是否开启
%% @param  Type    活动主类型
%% @param  SubType 活动子类型
%% @return         true|false
%%--------------------------------------------------
is_open_act(Type, SubType) ->
    NowTime = utime:unixtime(),
%%    ?PRINT("ets info :~p~n",[ets:info(?ETS_CUSTOM_ACT)]),
    case ets:lookup(?ETS_CUSTOM_ACT, {Type, SubType}) of
        [#act_info{etime = Etime}|_] when Etime > NowTime -> true;
        _ -> false
    end.

%%--------------------------------------------------
%% 获取活动开启的子类型列表
%% @param  Type    活动主类型
%% @return         [SubType]
%%--------------------------------------------------
get_open_subtype_ids(Type) ->
    NowTime = utime:unixtime(),
    List = lib_custom_act_util:get_open_subtype_list(Type, NowTime),
    [SubType || #act_info{key = {_Type, SubType}} <- List].

%% 批量获取开启的活动信息
get_custom_act_open_info_by_actids(ActIds) ->
    NowTime = utime:unixtime(),
    Fun = fun(ActId, TL) -> get_open_custom_act_infos(ActId, NowTime) ++ TL end,
    lists:foldl(Fun, [], ActIds).

get_open_custom_act_infos(Type) ->
    NowTime = utime:unixtime(),
    get_open_custom_act_infos(Type, NowTime).

get_open_custom_act_infos(Type, NowTime) ->
    lib_custom_act_util:get_open_subtype_list(Type, NowTime).

count_reward_status(Player, Type, SubType, GradeId) ->
    NowTime = utime:unixtime(),
    case lib_custom_act_util:get_custom_act_open_info(Type, SubType) of
        #act_info{
            etime = Etime
        } = ActInfo when NowTime < Etime ->
            case lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GradeId) of
                RewardCfg when is_record(RewardCfg, custom_act_reward_cfg) ->
                    case lib_custom_act_check:check_reward_receive_times(Player, ActInfo, RewardCfg) of
                        false ->
                            ?ACT_REWARD_HAS_GET;
                        _ ->
                            case lib_custom_act_check:check_receive_reward_conditions(Player, ActInfo, RewardCfg) of
                                true ->
                                    ?ACT_REWARD_CAN_GET;
                                _ ->
                                    ?ACT_REWARD_CAN_NOT_GET
                            end
                    end;
                _ ->
                   ?ACT_REWARD_CAN_NOT_GET
            end;
        false ->
            ?ACT_REWARD_CAN_NOT_GET
    end.

get_act_name(Type, SubType) ->
    case lib_custom_act_util:get_act_cfg_info(Type, SubType) of
        #custom_act_cfg{name = Name} -> Name;
        _ -> <<>>
    end.

gm_reset_recieve_times(Player, Type, SubType) ->
    StatusCustomAct = Player#player_status.status_custom_act,
    RoleId = Player#player_status.id,
    GradeIds = lib_custom_act_util:get_act_reward_grade_list(Type, SubType),
    RewardMap = StatusCustomAct#status_custom_act.reward_map,
    Fun = fun(GradeId, TemMap) ->
        maps:remove({Type, SubType, GradeId}, TemMap)
    end,
    NewRewardMap = lists:foldl(Fun, RewardMap, GradeIds),
    Sql = io_lib:format(<<"delete from custom_act_receive_reward where role_id = ~p and type = ~p and subtype = ~p">>, 
            [RoleId, Type, SubType]),
    db:execute(Sql),
    Player#player_status{status_custom_act = StatusCustomAct#status_custom_act{reward_map = NewRewardMap}}.

%%等级限制
is_feast_boss_limit_lv(Lv) ->
    SubType =
        case lib_custom_act_util:get_open_subtype_list(?CUSTOM_ACT_TYPE_FEAST_BOSS) of
            [] ->
                1;
            V when is_list(V) ->
                TempAct = hd(V),
                #act_info{key = {_, Value}} = TempAct,
                Value;
            _ ->
                1
        end,
    case lib_custom_act_util:get_act_cfg_info(?CUSTOM_ACT_TYPE_FEAST_BOSS, SubType) of
        #custom_act_cfg{condition = Condition} ->
            case lists:keyfind(lv, 1, Condition) of
                false ->
                    true;
                {lv, LimitLv} ->
                    Lv >= LimitLv
            end;
        _ ->%%没有开启
            false
    end.


is_feast_boss_time_open() ->
    SubTypeList = lib_custom_act_api:get_open_subtype_ids(?CUSTOM_ACT_TYPE_FEAST_BOSS),
    is_feast_boss_time_open2(SubTypeList).
is_feast_boss_time_open2([]) -> false;
is_feast_boss_time_open2([Type | List]) ->
    Res =
        case lib_custom_act_util:get_act_cfg_info(?CUSTOM_ACT_TYPE_FEAST_BOSS, Type) of
        #custom_act_cfg{condition = Condition} ->
            case lists:keyfind(time, 1, Condition) of
                false ->
                    false;
                {_, TimeList} ->
                    is_feast_boss_time_open_help(TimeList, utime:unixtime())
            end;
        _ ->%%没有开启
            false
    end,
    if
        Res == true ->
            Res;
        true ->
            is_feast_boss_time_open2(List)
    end.

is_feast_boss_time_open_help([], _Now) ->
    false;
is_feast_boss_time_open_help([{{StartH, StartM, StartS}, {EndH, EndM, EndS}} | TimeList], Now) ->
    StartTime = utime:unixdate() + StartH * 60 * 60 + StartM * 60 + StartS,
    EndTime   = utime:unixdate() + EndH * 60 * 60 + EndM * 60 + EndS,
    if
        Now >= StartTime andalso Now =< EndTime ->
            true;
        true ->
            is_feast_boss_time_open_help(TimeList,  Now)
    end.
%% {true, TvTime} | false
is_feast_boss_tv_time() ->
    SubTypeList = lib_custom_act_util:get_open_subtype_list(?CUSTOM_ACT_TYPE_FEAST_BOSS),
%%    ?MYLOG("cym", "SubTypeList ~p~n", [SubTypeList]),
    is_feast_boss_tv_time2(SubTypeList).

is_feast_boss_tv_time2([]) ->
    false;
is_feast_boss_tv_time2([#act_info{key = {_, Type}} | List]) ->
    Res =
        case lib_custom_act_util:get_act_cfg_info(?CUSTOM_ACT_TYPE_FEAST_BOSS, Type) of
            #custom_act_cfg{condition = Condition} ->
                case lists:keyfind(tv_time, 1, Condition) of
                    false ->
                        false;
                    {_, TimeList} ->
                        {_, {H, M, _}} = calendar:local_time(),
                        is_feast_boss_tv_time_help(TimeList, H, M)
                end;
            _ ->%%没有开启
                false
        end,
    case Res of
        {true, Minute} ->
            {true, Minute};
        _ ->
            is_feast_boss_tv_time2(List)
    end.

is_feast_boss_tv_time_help([], _H, _M) ->
    false;
is_feast_boss_tv_time_help([{{StartH, StartM}, TvM} | TimeList], H, M) ->
    if
        StartH == H andalso StartM == M->
            {true, TvM};
        true ->
            is_feast_boss_tv_time_help(TimeList, H, M)
    end.

update_custom_drop_map(Ps) ->
    #player_status{id = RoleId} = Ps,
    List2 = db:get_all(io_lib:format(?select_custom_drop_log, [RoleId])),
    F2 = fun([Type, SubType, GoodsType, GoodsIdType, Num], AccMap) ->
        maps:put({Type, SubType, GoodsType, GoodsIdType}, {Num, 0}, AccMap)
    end,
    CustomDropMap = lists:foldl(F2, #{}, List2),
    Ps#player_status{custom_drop = CustomDropMap}.

find_ratio([], _, _) -> [];
find_ratio([{L,R}|_], S, Ra) when S < Ra andalso Ra =< (S + R) -> [L];
find_ratio([{_,R}|T], S, Ra) -> find_ratio(T, (S + R), Ra).

%% 野怪死亡后计算活动物品掉落
calc_act_drop(Ps, MonArgs) ->
    #mon_args{scene = Scene, boss = Boss} = MonArgs,
    calc_act_drop(Ps, Scene, Boss).
calc_act_drop(Ps, Scene, Boss) ->
    #ets_scene{type = SceneType} = data_scene:get(Scene),
    TypeList = [?CUSTOM_ACT_TYPE_COLWORD, ?CUSTOM_ACT_TYPE_LIVENESS], %% 参数 活动类型
    %% 集字要求野外挂机场景掉落物品
    NewPS = calc_act_boss_drop_special(TypeList, Ps, SceneType, Boss),
    {ok, NewPS}.

calc_act_drop_online(Ps, Count) ->
    TypeList = [?CUSTOM_ACT_TYPE_COLWORD, ?CUSTOM_ACT_TYPE_LIVENESS], %% 参数 活动类型
    calc_act_drop_online(Ps, min(Count, 3), TypeList, []). %% 修正次数，防止出现一次计算太多次的情况（71级--离线挂机开启之前的不计算）

calc_act_drop_online(Ps, 0, _, SendGoods) -> 
    if
        SendGoods =/= [] ->
            Produce = #produce{type = col_world_act, subtype = 0, reward = SendGoods, 
                remark = "", show_tips = 1},
            NewPS = lib_goods_api:send_reward(Ps, Produce);
        true ->
            NewPS = Ps
    end,
    NewPS;
calc_act_drop_online(Ps, Count, TypeList, Reward) ->
    %% 集字要求野外挂机场景掉落物品
    {NewPS, _SendGoods} = calc_act_drop_special(TypeList, Ps, ?SCENE_TYPE_OUTSIDE, 0), % Date取0表示没有日期控制掉落计算
    % ?PRINT("SendGoods:~p~n",[_SendGoods]),
    calc_act_drop_online(NewPS, Count-1, TypeList, _SendGoods ++ Reward).

calc_offline_act_drop(Ps, Date, Count) ->
    calc_offline_act_drop(Ps, Date, Count, []).

calc_offline_act_drop(Ps, _Date, 0, List) -> {Ps, List};
calc_offline_act_drop(Ps, Date, Count, List) ->
    #player_status{scene = Scene} = Ps,
    #ets_scene{type = SceneType} = data_scene:get(Scene),
    TypeList = [?CUSTOM_ACT_TYPE_COLWORD, ?CUSTOM_ACT_TYPE_LIVENESS], %% 参数 活动类型
    %% 集字要求野外挂机场景掉落物品
    {NewPS, SendGoods} = calc_act_drop_special(TypeList, Ps, SceneType, Date),
    NewList = SendGoods ++ List,
    calc_offline_act_drop(NewPS, Date, Count-1, NewList).

calc_act_boss_drop_special(TypeList, Ps, SceneType, Boss) ->
    if
        SceneType == ?SCENE_TYPE_OUTSIDE andalso Boss == ?MON_NORMAL_OUSIDE ->
            NewPS = calc_act_drop_special_core(Ps, TypeList);
        true ->
            NewPS = Ps
    end,
    NewPS.

calc_act_drop_special(TypeList, Ps, SceneType, Date) ->
    if
        SceneType == ?SCENE_TYPE_OUTSIDE ->
            #player_status{id = RoleId, custom_drop = CustomDrop, figure = #figure{lv = RoleLv}} = Ps,
            DropGoodsMap = handle_drop_goods_cfg(TypeList, RoleLv, Date),
            OnHookTime = ?AFK_KV_UNIT_TIME,
            {SendGoods, NewCustomMap} = calc_act_drop_core(DropGoodsMap, RoleId, CustomDrop),
            Fun = fun(_Key, Value) ->  %% 离线挂机5秒计算一次,所以这里修正下时间
                case Value of
                    {Num, Time} -> {Num, Time - OnHookTime};
                    _ -> {1, 0}
                end
            end,
            RealCustomMap = maps:map(Fun, NewCustomMap),
            {Ps#player_status{custom_drop = RealCustomMap}, SendGoods};
        true ->
            {Ps, []}
    end.

calc_act_drop_special_core(Ps, TypeList) ->
    #player_status{id = RoleId, custom_drop = CustomDrop, figure = #figure{lv = RoleLv}} = Ps,
    DropGoodsMap = handle_drop_goods_cfg(TypeList, RoleLv, 0),  % Date取0表示没有日期控制掉落计算
    {SendGoods, NewCustomMap} = calc_act_drop_core(DropGoodsMap, RoleId, CustomDrop),
    PS = Ps#player_status{custom_drop = NewCustomMap},
    if
        SendGoods =/= [] ->
            Produce = #produce{type = col_world_act, subtype = 0, reward = SendGoods, 
                remark = "", show_tips = 1},
            NewPS = lib_goods_api:send_reward(PS, Produce);
        true ->
            NewPS = PS
    end,
    NewPS.

%% 把所有需要野外挂机掉落的活动配置物品，组装成以下格式数据
%% {{Type, SubType} => [{{Type, SubType, TimeCfg, GoodsType, GoodsId, MaxNum}, Weight}] }
handle_drop_goods_cfg(TypeList, RoleLv, Date) ->
    {_, {H, _M, _S}} = utime:localtime(),
    Fun = fun(Type, Acc) ->
        case get_open_custom_act_infos(Type) of
            [_|_] = ConsumeActs ->
                F0 = fun(#act_info{key = {_, SubType}, stime = StartTime, etime = EndTime}, TemAcc) ->
                    % 掉落时活动是否开启,当Date取0表示没有日期控制掉落计算
                    CheckActTime = ?IF(Date =:= 0 orelse Date >= StartTime andalso Date =< EndTime, true, false),
                    % 角色等级检查
                    case lib_custom_act_util:keyfind_act_condition(Type, SubType, role_lv) of
                        {role_lv, LimitLv} when RoleLv >= LimitLv -> CheckLv = true;
                        _ -> CheckLv = false
                    end,
                    % 掉落时间段检查，不配置默认不检查
                    case lib_custom_act_util:keyfind_act_condition(Type, SubType, drop_hour_list) of
                        {drop_hour_list, HourList} -> CheckTime = lists:any(fun({SHour, EHour}) -> H>=SHour andalso (H=<EHour orelse EHour==0) end, HourList);
                        _ -> CheckTime = true
                    end,
                    % ?PRINT("Type:~p SubType:~p ~n", [Type, SubType]),
                    if
                        CheckActTime == false orelse CheckLv == false orelse CheckTime == false -> TemAcc;
                        true ->
                            case lib_custom_act_util:keyfind_act_condition(Type, SubType, time_drop) of
                                {time_drop, TimeCfg} when is_integer(TimeCfg) -> skip;
                                _ -> TimeCfg = 5
                            end,
                            case lib_custom_act_util:keyfind_act_condition(Type, SubType, drops) of
                                {drops, GoodsCfg} ->
                                    F1 = fun({GoodsType, GoodsId, MaxNum, Weight}, Acc1) ->
                                        WeightL = maps:get({Type, SubType}, Acc1, []),
                                        NewWeightL = [{{Type, SubType, TimeCfg, GoodsType, GoodsId, MaxNum}, Weight}|WeightL],
                                        maps:put({Type, SubType}, NewWeightL, Acc1)
                                        % [{{Type, SubType, TimeCfg, GoodsType, GoodsId, MaxNum}, Weight}|Acc1]
                                    end,
                                    lists:foldl(F1, TemAcc, GoodsCfg);
                                _ ->
                                    TemAcc
                            end
                    end
                end,
                lists:foldl(F0, Acc, ConsumeActs);
            _ ->
                Acc
        end
    end,
    lists:foldl(Fun, #{}, TypeList).

%% 计算掉落，更新玩家活动掉落数据
calc_act_drop_core(DropGoodsMap, RoleId, CustomDrop) ->
    NowTime = utime:unixtime(),
    % DropGoods = find_ratio(Goods, 0, urand:rand(1, 100000)),
    F0 = fun(_Key, WeightL, List) ->
       DropGoods = find_ratio(WeightL, 0, urand:rand(1, 100000)),
       DropGoods ++ List
    end,
    SumDropGoodsL = maps:fold(F0, [], DropGoodsMap),
    % ?PRINT("DropGoodsMap:~p SumDropGoodsL:~p ~n", [DropGoodsMap, SumDropGoodsL]), 
    F = fun({Type, SubType, TimeCfg, GoodsType, GoodsId, MaxNum}, {Acc, TemMap, Acc1}) ->
        case maps:get({Type, SubType, GoodsType, GoodsId}, TemMap, []) of
            {Num, Time} when is_integer(Num) andalso Num < MaxNum andalso NowTime > Time  ->
                % db:execute(io_lib:format(?insert_custom_drop_log, [RoleId, Type, SubType, GoodsType, GoodsId, Num+1])),
                TemList = [RoleId, Type, SubType, GoodsType, GoodsId, Num+1],
                NewMap = maps:put({Type, SubType, GoodsType, GoodsId}, {Num + 1, NowTime + TimeCfg}, TemMap),
                {[{GoodsType, GoodsId, 1}|Acc], NewMap, [TemList|Acc1]};
            [] ->
                % db:execute(io_lib:format(?insert_custom_drop_log, [RoleId, Type, SubType, GoodsType, GoodsId, 1])),
                NewMap = maps:put({Type, SubType, GoodsType, GoodsId}, {1, NowTime + TimeCfg}, TemMap),
                TemList = [RoleId, Type, SubType, GoodsType, GoodsId, 1],
                {[{GoodsType, GoodsId, 1}|Acc], NewMap, [TemList|Acc1]};
            _ ->
                {Acc, TemMap, Acc1}
        end
    end,
    {SendGoods, NewCustomMap, DbList} = lists:foldl(F, {[], CustomDrop, []}, SumDropGoodsL),
    Sql = usql:replace(custom_drop_log, [role_id, act_type, subtype, goods_type, goodsid, num], DbList),
    DbList =/= [] andalso db:execute(Sql),
    {SendGoods, NewCustomMap}.

%% 秘籍清理活动掉落次数
gm_clear_act_drop(Type, SubType) ->
    db:execute(io_lib:format(?delete_custom_drop_log, [Type, SubType])),
    OnlineRoles = ets:tab2list(?ETS_ONLINE),
    [lib_player:apply_cast(E#ets_online.id, ?APPLY_CAST_STATUS, ?MODULE, update_custom_drop_map, []) || E <- OnlineRoles],
    ok.

%% 清理活动掉落次数
clear_act_drop(Type, SubType) ->
    db:execute(io_lib:format(?delete_custom_drop_log, [Type, SubType])),
    OnlineRoles = ets:tab2list(?ETS_ONLINE),
    [lib_player:apply_cast(E#ets_online.id, ?APPLY_CAST_STATUS, ?MODULE, update_custom_drop_map, []) || E <- OnlineRoles],
    ok.

%% 每日补给活跃增加通知客户端
refresh_supply_liveness(Player) ->
    pp_custom_act_list:handle(33209, Player, []),
    [ pp_custom_act:handle(33104, Player, [?CUSTOM_ACT_TYPE_SUPPLY, SubType])
        || SubType <- lib_custom_act_api:get_open_subtype_ids(?CUSTOM_ACT_TYPE_SUPPLY)].


gm_change_custom_act_wlv(Type, SubType, WLv) ->
    case lib_custom_act_util:get_custom_act_open_info(Type, SubType) of
        #act_info{} = ActInfo ->
            %% 只改内存用作测试
            NewActInfo = ActInfo#act_info{wlv = WLv},
            ets:insert(?ETS_CUSTOM_ACT, NewActInfo),
            lib_custom_act:broadcast_act_info(?CUSTOM_ACT_STATUS_OPEN, [NewActInfo]),
            if
                Type == ?CUSTOM_ACT_TYPE_FLOWER_RANK ->
                    mod_kf_flower_act_local:wlv_change(Type, SubType, WLv);
                true ->
                    ok
            end;
        _ ->
            ok
    end.

%% 一换一秘籍
gm_repace_goods(0, DeleteGtypeId, AddGtypeId) -> gm_repace_goods_1(DeleteGtypeId, AddGtypeId);
gm_repace_goods(PlayerId, DeleteGtypeId, AddGtypeId) ->
    lib_player:apply_cast(PlayerId, ?APPLY_CAST_STATUS, ?MODULE, gm_repace_goods_helper, [DeleteGtypeId, AddGtypeId]).

gm_repace_goods_1(DeleteGtypeId, AddGtypeId) ->
    OnlineRoles = ets:tab2list(?ETS_ONLINE),
    [lib_player:apply_cast(E#ets_online.id, ?APPLY_CAST_STATUS, ?MODULE, gm_repace_goods_helper, [DeleteGtypeId, AddGtypeId]) || E <- OnlineRoles].
gm_repace_goods_helper(Player, DeleteGtypeId, AddGtypeId) ->
    case lib_goods_api:get_goods_num(Player, [DeleteGtypeId]) of
        [{_, GoodsNum}|_] when GoodsNum > 0 -> 
            Reward = [{0, AddGtypeId, GoodsNum}],
            case lib_goods_api:goods_delete_type_list(Player, [{DeleteGtypeId, GoodsNum}], gm) of
                1 -> 
                    Produce = #produce{type = gm, subtype = 0, reward = Reward, 
                        remark = "", show_tips = 1},
                    NewPlayer = lib_goods_api:send_reward(Player, Produce),
                    {ok, NewPlayer};
                _ ->
                    {ok, Player}
            end;
        _ ->
            {ok, Player}
    end.

%% 根据GmType来控制模式，1:表示手动输入删除数量，2：表示按比例替换
%% 手动输入数量
gm_repace_goods2_call(RoleListStr, DeleteGtypeId, DeleteNum, Reward, GmType) ->
    spawn(fun() -> 
        RoleList = util:string_to_term(RoleListStr),
        if
            RoleList == 0 -> %% 修复本服，包括在线和离线玩家
                Sql = io_lib:format(<<"select pid from goods_high where goods_id = ~p">>, [DeleteGtypeId]),
                case db:get_all(Sql) of 
                    [] -> 
                        skip;
                    DbIds ->
                        AllRoleIdList = [DbId || [DbId] <- DbIds],
                        gm_repace_goods2(AllRoleIdList, DeleteGtypeId, DeleteNum, util:string_to_term(Reward), GmType)
                end;
            true ->
                Sql = io_lib:format(<<"select id from player_low">>, []),
                case db:get_all(Sql) of 
                    [] -> 
                        skip;
                    DbIds ->
                        AllRoleIdList = [DbId || [DbId] <- DbIds],
                        F = fun(RoleId) ->
                            lists:member(RoleId, AllRoleIdList)
                        end,
                        LastRoleIdList = lists:filter(F, RoleList),
                        gm_repace_goods2(LastRoleIdList, DeleteGtypeId, DeleteNum, util:string_to_term(Reward), GmType)
                end
        end
    end),
    ok.

% gm_repace_goods2(0, DeleteGtypeId, DeleteNum, Reward, GmType) -> 
%     gm_repace_goods_1_2(DeleteGtypeId, DeleteNum, Reward, GmType);
gm_repace_goods2([], _, _, _, _) -> ok;
gm_repace_goods2([RoleId | RoleList], DeleteGtypeId, DeleteNum, Reward, GmType) ->
    timer:sleep(1000), %% 1s处理一个
    Pid = misc:get_player_process(RoleId),
    case misc:is_process_alive(Pid) of 
        true -> 
            lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, ?MODULE, gm_repace_goods_helper2, [DeleteGtypeId, DeleteNum, Reward, GmType]);
        false ->
            Sql = io_lib:format(<<"select gid, num from goods_high where goods_id = ~p and pid = ~p">>, [DeleteGtypeId, RoleId]),
            List = db:get_all(Sql),
            F = fun(GoodsId, GoodsNum) ->
                    case GmType of 
                        1 -> 
                            NewDeleteNum = DeleteNum,
                            NewReward = Reward;
                        2 -> 
                            NewDeleteNum = GoodsNum,
                            [{RewardType, RewardGoodsType, Mul}] = Reward,
                            NewReward = [{RewardType, RewardGoodsType, NewDeleteNum * Mul}];
                        _ ->
                            NewDeleteNum = 0,
                            NewReward = []
                    end,
                    case GoodsNum > NewDeleteNum of 
                        true ->
                            UpdateSql = io_lib:format(?SQL_GOODS_UPDATE_NUM, [GoodsNum - NewDeleteNum, GoodsId]),
                            db:execute(UpdateSql);
                        false ->
                            lib_goods_util:delete_goods(GoodsId)
                    end,
                    {Title, Content} = get_mail_msg_by_vsn(replace_goods),
                    lib_mail_api:send_sys_mail([RoleId], Title, Content, NewReward)
            end,
            [F(GID,GNUM)||[GID,GNUM]<-List]
    end,
    gm_repace_goods2(RoleList, DeleteGtypeId, DeleteNum, Reward, GmType).

% gm_repace_goods_1_2(DeleteGtypeId, DeleteNum, Reward, GmType) ->
%     OnlineRoles = ets:tab2list(?ETS_ONLINE),
%     [lib_player:apply_cast(E#ets_online.id, ?APPLY_CAST_STATUS, ?MODULE, gm_repace_goods_helper2, [DeleteGtypeId, DeleteNum, Reward, GmType]) || E <- OnlineRoles].
gm_repace_goods_helper2(Player, DeleteGtypeId, DeleteNum, Reward, GmType) ->
    case lib_goods_api:get_goods_num(Player, [DeleteGtypeId]) of
        [{_, GoodsNum}|_] when GoodsNum > 0 -> 
            case GmType of 
                1 -> 
                    NewDeleteNum = DeleteNum,
                    NewReward = Reward;
                2 -> 
                    NewDeleteNum = GoodsNum,
                    [{RewardType, RewardGoodsType, Mul}] = Reward,
                    NewReward = [{RewardType, RewardGoodsType, NewDeleteNum * Mul}];
                _ ->
                    NewDeleteNum = 0,
                    NewReward = []
            end,
            case lib_goods_api:goods_delete_type_list(Player, [{DeleteGtypeId, NewDeleteNum}], gm) of
                1 -> 
                    Produce = #produce{type = gm, subtype = 0, reward = NewReward, 
                        remark = "", show_tips = 1},
                    NewPlayer = lib_goods_api:send_reward(Player, Produce),
                    {ok, NewPlayer};
                _ ->
                    {ok, Player}
            end;
        _ ->
            {ok, Player}
    end.

%% 秘籍：根据定制活动日志补发物品
gm_reward_by_act_log(STime, ETime, GoodsTypeId) ->
    spawn(fun() -> 
        ActRwdSql = io_lib:format(<<"select reward, player_id from log_custom_act_reward where time >= ~p and time <= ~p ">>, [STime, ETime]),
        case db:get_all(ActRwdSql) of
            [] -> 
                skip;
            ActRwdList ->
                F = fun([ActRwd, RoleId]) ->
                    ProduceSql = io_lib:format(<<"select 1 from log_goods where player_id = ~p and goods_id = ~p and time >= ~p and time <= ~p limit 1">>, [RoleId, GoodsTypeId, STime, ETime]),
                    case db:get_all(ProduceSql) of 
                        [] -> %% 确保期间没有产出过这个物品，再发奖励
                            %% 解析成奖励term
                            RewardTerm = util:bitstring_to_term(ActRwd),
                            F2 = fun(Reward, FNeedSend) ->
                                case Reward of
                                    {_, GoodsTypeId, _} ->
                                        true;
                                    _ ->
                                        FNeedSend
                                end
                            end,
                            NeedSend = lists:foldl(F2, false, RewardTerm),
                            if
                                NeedSend ->
                                    {Title, Content} = get_mail_msg_by_vsn(resend_goods),
                                        %% 补发奖励
                                    lib_mail_api:send_sys_mail([RoleId], Title, Content, RewardTerm);
                                true ->
                                    skip
                            end;
                        _ -> 
                            skip
                    end,
                    timer:sleep(300)
                end,
                lists:foreach(F, ActRwdList)
        end
    end),
    ok.

%% 根据不同渠道获取相应的邮件标题和内容
get_mail_msg_by_vsn(replace_goods) -> %% 替换物品秘籍
    IsCn = lib_vsn:is_cn(),
    IsJp = lib_vsn:is_jp(),
    if
        IsCn ->
            {<<"换发物品"/utf8>>, <<"换发物品"/utf8>>};
        IsJp ->
            {<<"特別対応"/utf8>>, <<"ユーザ様、いつもご愛顧頂きありがとうございます。この度、誤りのアイテムを配置してしまい誠に申し訳ございません。誤りのアイテムを削除し、正しいアイテムを補填させていただきます。多大なるご迷惑をお掛け致しましたことを深くお詫び申し上げます。今後ともよろしくお願いいたします"/utf8>>};
        true ->
            {<<"Exchange items"/utf8>>, <<"Exchange items"/utf8>>}
    end;
get_mail_msg_by_vsn(resend_goods) -> %% 补发物品秘籍
    IsCn = lib_vsn:is_cn(),
    IsJp = lib_vsn:is_jp(),
    if
        IsCn ->
            {<<"补发物品"/utf8>>, <<"补发物品"/utf8>>};
        IsJp ->
            {<<"補填対応"/utf8>>, <<"この度、2/18に開催された天神祭イベントにてアイテムが正常に獲得されなかったため、該当アイテムを補填させていただきます。お手数をおかけしますが、ご確認くださいますようお願い申し上げます。多大なるご迷惑をお掛け致しまして誠に申し訳ございません"/utf8>>};
        true ->
            {<<"Reissue items"/utf8>>, <<"Reissue items"/utf8>>}
    end;
get_mail_msg_by_vsn(_) ->
    ?ERR("err", []),
    {"", ""}.

%%%%%%%%%%%%%%%%%%%%%%%%% 特殊渠道判断
%%% yy_sh921_lj_57_PM001257 渠道判断
is_yy_sh921_lj_57_PM001257_source() ->
    case mod_cache:get({yy_sh921_lj_57_PM001257}) of 
        SourceList when is_list(SourceList) andalso length(SourceList) > 0 -> ok;
        _ ->
            case db:get_all(<<"select distinct source from player_login">>) of 
                [] -> SourceList = [];
                DbList -> 
                    SourceList = [list_to_atom(util:make_sure_list(Source)) || [Source] <- DbList],
                    mod_cache:put({yy_sh921_lj_57_PM001257}, SourceList)
            end
    end,
    is_yy_sh921_lj_57_PM001257_source_helper(SourceList).
    
is_yy_sh921_lj_57_PM001257_source_helper(SourceList) ->
    %?PRINT("SourceList : ~p~n", [SourceList]),
    lists:member(yy_sh921_lj_57_PM001257, SourceList) orelse 
    lists:member(xx_suyou, SourceList).

%% 刷新在线玩家定制活动内存数据
gm_refresh_custom_act_data(PS, Type, SubType) ->
    #player_status{id = PlayerId, status_custom_act = StatusCustomAct} = PS,
    Sql = io_lib:format(
        "select data_list
        from custom_act_data
        where player_id=~p and type=~p and subtype=~p", [PlayerId, Type, SubType]),
    case db:get_row(Sql) of
        [] -> {ok, PS};
        [PlayerInfo] ->
            ActData = lib_custom_act:make_record(custom_act_data, [Type, SubType, PlayerInfo]),
            #status_custom_act{data_map = DataMap} = StatusCustomAct,
            Key = ActData#custom_act_data.id,
            NewDataMap = maps:put(Key, ActData, DataMap),
            NewStatusCustomAct = StatusCustomAct#status_custom_act{data_map = NewDataMap},
            NewPS = PS#player_status{status_custom_act = NewStatusCustomAct},
            {ok, NewPS}
    end.

gm_re_trigger_120_act(RoleId, ProductId) when is_integer(RoleId) ->
    Product = lib_recharge_check:get_product(ProductId),
    lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, ?MODULE, gm_re_trigger_120_act, [Product]);
gm_re_trigger_120_act(Player, Product) ->
    handle_recharge_120_act(Player, Product).
