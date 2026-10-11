%% @doc    首充奖励
%% @author hek
%% @since  2016-11-14
%% @deprecated
%% ---------------------------------------------------------------------------

-module (lib_recharge_first).
-include ("common.hrl").
-include ("server.hrl").
-include ("rec_recharge.hrl").
-include ("def_recharge.hrl").
-include ("def_event.hrl").
-include ("rec_event.hrl").
-include ("errcode.hrl").
-include ("def_fun.hrl").
-include ("figure.hrl").
-include ("def_module.hrl").
-include ("goods.hrl").
-include("predefine.hrl").
-include("def_counter.hrl").
-include("language.hrl").
-include("kv.hrl").

-export ([
        login/1,
        relogin/1,
        handle_event/2,           %% 处理充值回调事件
        handle_product/2,         %% 处理商品逻辑
        send_first_state_to_client/1,
        send_first_state_to_client2/1,
        get_recharge_gift_award/2,
        daily_reset/0,
        daily_reset/1
        , is_buy/1
        , gm_update/2
    ]).

-define (STATE_NOT_BUY,     0). %% 状态：0未购买
-define (STATE_NOT_GET,     1). %% 状态：1未领取
-define (STATE_NOT_TIME, 2).    %% 状态：2时间未到
% -define (STATE_ALL_GET, 3).     %% 状态：3已领完
-define (STATE_HAD_GET, 4).     %% 状态：4已领取
-define (STATE_NOT_REACH_OPEN_DAY, 5).  %% 状态：未达到开服天数

%% 玩家登陆
login(PS) ->
    PlayerId       = PS#player_status.id,
    RechargeStatus = PS#player_status.recharge_status,
    FirstData = case get_recharge_first_db(PlayerId) of
        [IsBuy, Time, IndexListBin, LoginDays, DaysUtime] ->
            IndexList = util:bitstring_to_term(IndexListBin),
            #recharge_first_data{is_buy = IsBuy, time = Time, index_list = IndexList, login_days = LoginDays, days_utime = DaysUtime};
        _ ->
            #recharge_first_data{}
    end,
    NewRechargeStatus = RechargeStatus#recharge_status{first_data = FirstData},
    NewPS = PS#player_status{recharge_status = NewRechargeStatus},
    PSAfUpdate = update_login_days(NewPS),
    {ok, LastPS} = handle([?RECHARGE_FIRST2], PSAfUpdate), % 添加有礼处理
    LastPS.

%% 重连
relogin(PS) ->
    NewPS = update_login_days(PS),
    NewPS.

%% 处理充值回调事件
%% 注：首充礼包不需要处理充值回调事件，它作为被关联事件触发
handle_event(#player_status{c_source = CSource, figure = #figure{lv = Lv}} = PS, #event_callback{type_id = ?EVENT_LV_UP}) ->
    case is_legal_source(CSource) of
        true ->
            SendLv = get_mail_lv(CSource),
            case Lv == SendLv andalso is_buy2(PS) of % 已在之前等级时首充，达到发送等级补发邮件
                true -> send_first_recharge_mail(PS);
                false -> skip
            end;
        false ->
            skip
    end,
    {ok, PS}.

%% 处理商品逻辑
handle_product(PS, _ProductId) ->
    handle([?RECHARGE_FIRST, ?RECHARGE_FIRST2], PS).

%% @return {ok, #player_status{}}
handle([], PS) -> {ok, PS};
handle([?RECHARGE_FIRST | T], PS) ->
    ProductId = get_product_id(),
    case lib_recharge_check:check_product(ProductId) of
        {true, _Product} -> CorrectCtrl = 1;
        _ -> CorrectCtrl = 0
    end,
    {ok, NewPS} =
    case CorrectCtrl==1 andalso is_buy(PS)==false of
        true ->
            Sql = io_lib:format(<<"select gold from recharge_log where player_id = ~p ORDER BY id desc limit 1">>, [PS#player_status.id]),
            GoldLimit = get_gold_limit(),
            case db:get_row(Sql) of
                [Gold]  when Gold >= GoldLimit->
                    do_handle_product(?RECHARGE_FIRST, PS);
                _ ->
                    {ok, PS}
            end;
        false -> {ok, PS}
    end,
    handle(T, NewPS);
handle([?RECHARGE_FIRST2 | T], #player_status{id = PlayerId, c_source = Source} = PS) ->
    {ok, NewPS} =
    case {is_buy2(PS), is_legal_source(Source)} of
        {false, true} ->
            Total = lib_recharge_data:get_total(PlayerId),
            Limit = get_gold_limit2(Source),
            case Total >= Limit of
                true ->
                    do_handle_product(?RECHARGE_FIRST2, PS);
                _ ->
                    {ok, PS}
            end;
        _ ->
            {ok, PS}
    end,
    handle(T, NewPS).

do_handle_product(?RECHARGE_FIRST, PS) ->
    NowTime = utime:unixtime(),
    #player_status{id = PlayerId, recharge_status = RechargeStatus} = PS,
    #recharge_status{first_data = #recharge_first_data{is_buy = IsBuy}} = RechargeStatus,
    % 重新初始化
    FirstData = #recharge_first_data{is_buy = IsBuy bor ?RECHARGE_FIRST, login_days = 1, days_utime = NowTime},
    replace_recharge_first_db(PlayerId, FirstData),
    NewRechargeStatus = RechargeStatus#recharge_status{first_data = FirstData},
    NewPS = PS#player_status{recharge_status = NewRechargeStatus},
    send_first_state_to_client(NewPS),
    lib_log_api:log_recharge_first(PlayerId, 0, NowTime, 1, []),
    %% 永恒碑谷
    {ok, LastPS} = lib_eternal_valley_api:trigger(NewPS, {first_recharge}),
    {ok, LastPS};
do_handle_product(?RECHARGE_FIRST2, PS) ->
    #player_status{id = PlayerId, recharge_status = RechargeStatus} = PS,
    #recharge_status{first_data = FirstData1} = RechargeStatus,
    #recharge_first_data{is_buy = IsBuy} = FirstData1,

    FirstData2 = FirstData1#recharge_first_data{is_buy = IsBuy bor ?RECHARGE_FIRST2},
    replace_recharge_first_db(PlayerId, FirstData2),
    NewRechargeStatus = RechargeStatus#recharge_status{first_data = FirstData2},
    NewPS = PS#player_status{recharge_status = NewRechargeStatus},

    send_first_state_to_client2(NewPS),
    send_first_recharge_mail(NewPS),
    {ok, NewPS}.

%% 获得奖励状态
get_award_state(PS, Index) ->
    #player_status{recharge_status = RechargeStatus} = PS,
    #recharge_status{first_data = FirstData} = RechargeStatus,
    #recharge_first_data{index_list = IndexList} = FirstData,
    IsBuy = is_buy(PS),
    IsGet = lists:member(Index, IndexList),
    OpenDay = util:get_open_day(),
    if
        OpenDay < Index -> ?STATE_NOT_REACH_OPEN_DAY;
        not IsBuy -> ?STATE_NOT_BUY;
        IsGet -> ?STATE_HAD_GET;
        % LoginDays < Index -> ?STATE_NOT_TIME;
        true -> ?STATE_NOT_GET
    end.

%% 是否达成首充金额
is_buy(#player_status{recharge_status = #recharge_status{first_data = #recharge_first_data{is_buy = IsBuy}}}) when IsBuy band ?RECHARGE_FIRST > 0 -> true;
is_buy(_) -> false.

%% 是否达成添加有礼金额
is_buy2(#player_status{recharge_status = #recharge_status{first_data = #recharge_first_data{is_buy = IsBuy}}}) when IsBuy band ?RECHARGE_FIRST2 > 0 -> true;
is_buy2(_) -> false.

%% 是否合法的渠道来源
%% @return boolean()
is_legal_source(Source) ->
    Source1 = util:make_sure_list(Source),
    case data_recharge_first2:get_source_conditions(Source1) of
        undefined -> false;
        _ -> true
    end.

%% 每天触发
daily_reset() ->
    OnlineRoles = ets:tab2list(?ETS_ONLINE),
    spawn(fun() ->
        F = fun(E) ->
            timer:sleep(50),
            lib_player:apply_cast(E#ets_online.id, ?APPLY_CAST_SAVE, lib_recharge_first, daily_reset, [])
        end,
        lists:foreach(F, OnlineRoles)
    end),
    ok.

daily_reset(#player_status{online = ?ONLINE_ON} = PS) ->
    NewPS = update_login_days(PS),
    send_first_state_to_client(NewPS),
    NewPS;
daily_reset(PS) -> PS.

%% 获取首充商品id
get_product_id() ->
    case data_recharge:get_recharge_first_ids() of
        [ProductId|_] -> ProductId;
        _ -> 0
    end.

%% --------------------------- 协议处理部分 ---------------------------

send_first_state_to_client(PS) ->
    ProductId = get_product_id(),
    case lib_recharge_check:check_product(ProductId) of
        {true, _Product} ->
            % {AwardState, Index} = get_award_state(PS, ProductId);
            #player_status{figure = #figure{sex = Sex}} = PS,
            CfgIndexList = data_recharge:get_index_list(ProductId, Sex),
            F = fun(Index) ->
                AwardState = get_award_state(PS, Index),
                {AwardState, Index}
            end,
            AwardStateList = lists:map(F, CfgIndexList);
        _ ->
            AwardStateList = []
    end,
    IsNotify = ?IF(mod_counter:get_count(PS#player_status.id, ?MOD_RECHARGE_ACT, ?COUNTER_RECHARGE_ACT_FIRST_NOTIFY) > 0, 1, 0),
    lib_server_send:send_to_sid(PS#player_status.sid, pt_159, 15905, [AwardStateList, ProductId, IsNotify]),
    ok.

send_first_state_to_client2(PS) ->
    Flag = ?IF(is_buy2(PS), 1, 0),
    lib_server_send:send_to_sid(PS#player_status.sid, pt_159, 15908, [Flag]),
    ok.


get_recharge_gift_award(PS, Index) ->
    case check(PS, Index) of
        {true, Award, ProductId} ->
            NowTime = utime:unixtime(),
            PlayerId = PS#player_status.id,
            RechargeStatus = PS#player_status.recharge_status,
            #recharge_first_data{time = LastTime, index_list = IndexList} = FirstData = RechargeStatus#recharge_status.first_data,
            NewIndexList = [Index|IndexList],
            NewFirstData = FirstData#recharge_first_data{index_list = NewIndexList, time = NowTime},
            replace_recharge_first_db(PlayerId, NewFirstData),
            NewRechargeStatus = RechargeStatus#recharge_status{first_data = NewFirstData},
            NewPS = PS#player_status{recharge_status = NewRechargeStatus},
            {GoodsAward, OtherAward} = lists:partition(fun
                ({?TYPE_GOODS,_,_}) ->
                    true;
                ({?TYPE_BIND_GOODS, _, _}) ->
                    true;
                (_) ->
                    false
            end, Award),
            case lib_goods_api:can_give_goods(PS, GoodsAward) of
                true ->
                    case lib_goods_api:give_goods_by_list(NewPS, lib_goods_api:make_reward_unique(GoodsAward), recharge_gift_award, 0) of
                        {1, GiveGoodsList, _} ->
                            case Award of
                                [{_, GoodsTypeId, _}|_] ->
                                    case lists:keyfind(GoodsTypeId, #goods.goods_id, GiveGoodsList) of
                                        G when is_record(G, goods) ->
                                            #player_status{id = RoleId, figure = #figure{name = RoleName, sex = Sex}} = PS,
                                            case data_recharge:get_recharge_first_language_id(ProductId, Sex, Index) of
                                                0 -> skip;
                                                LanguageId -> lib_chat:send_TV({all}, ?MOD_RECHARGE, LanguageId, [RoleName, RoleId] ++ lib_goods_api:make_goods_tv_format_3(G))
                                            end;
                                        _ ->
                                            ok
                                    end;
                                _ ->
                                    ok
                            end,
                            if
                                OtherAward =/= [] ->
                                    LastPS = lib_goods_api:send_reward(NewPS, OtherAward, recharge_gift_award, 0);
                                true ->
                                    LastPS = NewPS
                            end,
                            lib_goods_api:send_tv_tip(PlayerId, 3, Award),
                            send_first_state_to_client(NewPS),
                            lib_log_api:log_recharge_first(PlayerId, LastTime, NowTime, Index, Award),
                            {true, ?SUCCESS, LastPS};
                        _Res ->
                            ?ERR("get_recharge_gift_award ~p~n error ~p~n", [PS#player_status.id, _Res]),
                            {false, ?FAIL}
                    end;
                _ ->
                    {false, ?ERRCODE(err150_no_cell)}
            end;
        {false, ErrCode} -> {false, ErrCode}
    end.

check(PS, Index) ->
    Career = PS#player_status.figure#figure.career,
    ProductId = get_product_id(),
    AwardState = get_award_state(PS, Index),
    CareerAwardList = data_recharge:get_recharge_first(ProductId, PS#player_status.figure#figure.sex, Index),
    CareerAward = lists:keyfind(Career, 1, CareerAwardList),
    {Career, Award} = ?IF(CareerAward==false, {Career, []}, CareerAward),
    EnoughCell = lib_goods_api:can_give_goods(PS, Award),
    if
        Award == [] -> {false, ?ERRCODE(missing_config)};
        AwardState == ?STATE_NOT_BUY -> {false, ?ERRCODE(err159_3_not_buy)};
        AwardState == ?STATE_NOT_TIME -> {false, ?ERRCODE(err159_not_the_time)};
        AwardState == ?STATE_HAD_GET -> {false, ?ERRCODE(err159_4_already_get)};
        AwardState == ?STATE_NOT_REACH_OPEN_DAY -> {false, ?ERRCODE(err159_5_not_reach_openday)};
        EnoughCell =/= true -> {false, ?ERRCODE(err150_no_cell)};
        true -> {true, Award, ProductId}
    end.

%% 更新天数
update_login_days(PS) ->
    #player_status{id = PlayerId, figure = #figure{sex = Sex}, recharge_status = RechargeStatus} = PS,
    #recharge_status{first_data = FirstData} = RechargeStatus,
    #recharge_first_data{login_days = LoginDays, days_utime = DaysUtime} = FirstData,
    IsBuy = is_buy(PS),
    ProductId = get_product_id(),
    IsToday = utime:is_today(DaysUtime),
    MaxIndex = data_recharge:get_max_index(ProductId, PS#player_status.figure#figure.sex),
    case IsBuy == false orelse IsToday orelse all_reward_finish(Sex, FirstData) orelse LoginDays>=MaxIndex of
        true -> PS;
        false ->
            NewFirstData = FirstData#recharge_first_data{login_days = LoginDays+1, days_utime = utime:unixtime()},
            NewRechargeStatus = RechargeStatus#recharge_status{first_data = NewFirstData},
            NewPS = PS#player_status{recharge_status = NewRechargeStatus},
            replace_recharge_first_db(PlayerId, NewFirstData),
            NewPS
    end.

%% 是否所有奖励领取完
all_reward_finish(Sex, #recharge_first_data{index_list = IndexList}) ->
    ProductId = get_product_id(),
    CfgIndexList = data_recharge:get_index_list(ProductId, Sex),
    case CfgIndexList -- IndexList of
        [] -> true;
        _ -> false
    end.

%% 更新数据
gm_update(PS, List) ->
    #player_status{id = PlayerId, recharge_status = RechargeStatus} = PS,
    #recharge_status{first_data = FirstData} = RechargeStatus,
    NewFirstData = do_gm_update(List, FirstData),
    NewRechargeStatus = RechargeStatus#recharge_status{first_data = NewFirstData},
    NewPS = PS#player_status{recharge_status = NewRechargeStatus},
    replace_recharge_first_db(PlayerId, NewFirstData),
    NewPS.

do_gm_update([], FirstData) -> FirstData;
do_gm_update([H|T], FirstData) ->
    case H of
        {login_days, LoginDays} -> NewFirstData = FirstData#recharge_first_data{login_days = LoginDays};
        {index_list, IndexList} -> NewFirstData = FirstData#recharge_first_data{index_list = IndexList};
        {days_utime, DaysTime} -> NewFirstData = FirstData#recharge_first_data{days_utime = DaysTime}
    end,
    do_gm_update(T, NewFirstData).

%% 首充触发金额
get_gold_limit() ->
    case  ?GAME_VER of
        ?GAME_VER_TW ->
            120;
        ?GAME_VER_TH ->
            30;
        _ ->
            60
    end.

%% 添加有礼单个配置
%% 注：假设Source为合法渠道
get_recharge_first2_conf(Source, CondType) ->
    Conditions = data_recharge_first2:get_source_conditions(util:make_sure_list(Source)),
    {_, Condition} = ulists:keyfind(CondType, 1, Conditions, {CondType, 0}),
    Condition.

%% 添加有礼充值触发金额
get_gold_limit2(Source) ->
    get_recharge_first2_conf(Source, money).

%% 添加有礼邮件触发等级
get_mail_lv(Source) ->
    get_recharge_first2_conf(Source, mail_lv).

%% 添加有礼邮件配置id
get_mail_lan_id(Source) ->
    [{TitleId, ContentId}|_] = get_recharge_first2_conf(Source, mail),
    {TitleId, ContentId}.

%% 首充关注公众号有礼
send_first_recharge_mail(#player_status{id = RoleId, c_source = CSource, figure = #figure{lv = Lv}}) ->
    SendLv = get_mail_lv(CSource),
    case Lv >= SendLv of
        true ->
            {Title, Content} = get_mail_lan_id(CSource),
            lib_mail_api:send_sys_mail([RoleId], utext:get(Title), utext:get(Content), []);
        false ->
            skip
    end.

%% -------------------------------- db function --------------------------------

get_recharge_first_db(PlayerId) ->
    Sql = io_lib:format(<<"select `is_buy`, `time`, `index_list`, login_days, days_utime from `recharge_first` where `player_id` = ~p">>, [PlayerId]),
    db:get_row(Sql).

replace_recharge_first_db(PlayerId, FirstData) ->
    #recharge_first_data{is_buy = IsBuy, time = Time, index_list = IndexList, login_days = LoginDays, days_utime = DaysUtime} = FirstData,
    IndexListBin = util:term_to_bitstring(IndexList),
    Sql = io_lib:format(<<"replace into `recharge_first`(`player_id`, `is_buy`, `time`, `index_list`, login_days, days_utime) values(~p, ~p, ~p, '~s', ~p, ~p)">>,
        [PlayerId, IsBuy, Time, IndexListBin, LoginDays, DaysUtime]),
    db:execute(Sql).
