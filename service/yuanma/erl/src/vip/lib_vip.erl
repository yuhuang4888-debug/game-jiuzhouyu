%%%===================================================================
%%% @author z.hua
%%% @doc
%%%
%%% @end
%%%===================================================================
-module(lib_vip).
-include("vip.hrl").
-include("server.hrl").
-include("chat.hrl").
-include("common.hrl").
-include("figure.hrl").
-include("def_event.hrl").
-include("rec_event.hrl").
-include("def_fun.hrl").
-include("errcode.hrl").
-include("predefine.hrl").
-include("goods.hrl").
-include("def_module.hrl").
-include_lib("stdlib/include/ms_transform.hrl").

%% API
%%-export([
%%    login/1             %% 登录初始化
%%%%    , after_login/1      %% 登录后初始化
%%    , logout/1           %% 登出处理
%%    , timer_check/0      %% 扫描是否有失效的vip特权卡
%%    , timeout_card/2     %% 处理超时特权卡
%%    , cost_money/2       %% 消费钻石增加vip经验
%%    , add_vip_exp/2      %% 增加经验
%%    , get_vip_lv/1       %% 获取vip等级
%%    , get_vip_lv_max/0   %% 获取vip等级上限
%%    , buy_vip_card/2     %% 购买vip特权卡
%%    , use_goods/3        %% 使用特权卡激活道具
%%    , gm_add_vip_exp/2
%%    , gm_add_vip_exp_core/2
%%    , week_list_filter/2
%%]).
-compile(export_all).

%% 登录初始化
login(PlayerId) ->
    CardList = init_vip_card(PlayerId),
    RoleVip = init_vip_lv(PlayerId),
    VipType = get_vip_type(CardList),
    RoleVip#role_vip{vip_type = VipType, vip_card_list = CardList}.

init_vip_lv(PlayerId) ->
    %%    SupVip = #sup_vip{},
    VipInfo = db:get_row(io_lib:format(?SELECT_VIP_INFO, [PlayerId])),
    do_init_vip_lv(PlayerId, VipInfo).

do_init_vip_lv(_PlayerId, [VipLv, VipExp, VipHide, CostGold, FetchedList, WeekListTuple, LoginExpTime, FreeCardTuple, TotalTime]) ->
    %%    NowTime = utime:unixtime(),
    FetchedList2 = util:bitstring_to_term(FetchedList),
    NewWeekList = util:bitstring_to_term(WeekListTuple),
    FreeCard = util:bitstring_to_term(FreeCardTuple),
    %%  再获取新的奖励
    %%    WeekList = do_init_vip_lv_help(NewWeekListTuple, []),
    %%    NewWeekList =
    %%        case lists:keyfind(VipLv, 1, WeekList) of
    %%            {VipLv, UnLockTime, GotTime} ->
    %%                lists:keystore(VipLv, 1, WeekList, {VipLv, UnLockTime, GotTime});
    %%            _ ->
    %%                WeekList
    %%        end,
    %%    更新数据库
    % ?PRINT("====login   NewWeekList :~p  ~n", [NewWeekList]),
    %%    Sql = io_lib:format(?UPDATE_VIP_WEEK_REWARD, [util:term_to_string(NewWeekList), PlayerId]),
    %%    db:execute(Sql),
    %%    更新state
    #role_vip{
        vip_lv = VipLv,
        vip_exp = VipExp,
        vip_hide = VipHide,
        cost_gold = CostGold,
        fetched_list = FetchedList2,
        week_list = NewWeekList,
        login_exp_time = LoginExpTime,
        free_card = FreeCard,
        total_login_time = TotalTime
    };


do_init_vip_lv(PlayerId, []) ->
    Sql = io_lib:format(?INSERT_VIP_INFO, [PlayerId, 0]),
    db:execute(Sql),
    #role_vip{}.
%%--------------- 过滤超时的奖励---------------

do_init_vip_lv_help([], WeekList) -> WeekList;
do_init_vip_lv_help([{Lv, UnLockTime, OldGotTime} | L], WeekList) ->
    NowTime = utime:unixtime(),
    NewWeekList =
        case utime:is_same_day(UnLockTime, NowTime) of
            true -> % 当天解锁
                case OldGotTime == 0 of
                    true -> % 未领取
                        [{Lv, UnLockTime, OldGotTime} | WeekList];
                    false ->
                        WeekList
                end;
            false ->
                case utime:is_same_day(OldGotTime, NowTime) of
                    true -> %今天已经领取
                        WeekList;
                    false ->
                        [{Lv, UnLockTime, OldGotTime} | WeekList]
                end
        end,
    do_init_vip_lv_help(L, NewWeekList);
do_init_vip_lv_help(_, _) -> [].
%%--------------------------------------------------

%%check_is_pay(CardList, VipLv) ->
%%    PayList = [IsTempCard || #vip_card{is_temp_card = IsTempCard} <- CardList, IsTempCard == 0],
%%    case length(PayList) of
%%        0 ->   % 全白嫖
%%            0;
%%        _ ->   % 有付费的
%%            case data_vip:get(VipLv) of
%%                [] -> 0;    % 没有配置
%%                _ -> VipLv
%%            end
%%    end.

init_vip_card(PlayerId) ->
    CardList = db:get_all(io_lib:format(?SELECT_VIP_CARD, [PlayerId])),
    [
        #vip_card{
            vip_type = VipType, forever = Forever, is_temp_card = IsTempCard,
            end_time = EndTime, award_status = AwardStatus}
        || [VipType, Forever, IsTempCard, EndTime, AwardStatus] <- CardList
    ].

%% 获取vip类型
%% @return vip_type
get_vip_type(CardList) ->
    get_vip_type(CardList, utime:unixtime()).
get_vip_type(CardList, NowTime) ->
    get_vip_type_helper(lists:reverse(lists:keysort(#vip_card.vip_type, CardList)), NowTime).

get_vip_type_helper([], _NowTime) -> 0;
get_vip_type_helper([VipCard | T], NowTime) ->
    #vip_card{
        vip_type = VipType, forever = Forever, end_time = EndTime} = VipCard,
    case Forever of
        1 -> VipType;
        _ when EndTime > NowTime -> VipType;
        _ -> get_vip_type_helper(T, NowTime)
    end.

%%get_login_exp(?VIP_TYPE_SILVER) -> 10;
%%get_login_exp(?VIP_TYPE_AMETHYST) -> 20;
%%get_login_exp(?VIP_TYPE_EMPEROR) -> 40;
%%get_login_exp(_) -> 5.

%% 获得付费的vip卡
get_pay_vip_card() ->
    AllCard = data_vip:get_vip_type_list(),
    F = fun(VipType, PayCardTmp) ->
        #data_vip_card{get_config = Config} = data_vip:get_vip_card(VipType),
        case Config of
            [] ->
                [VipType | PayCardTmp];
            _ ->
                PayCardTmp
        end
        end,
    lists:foldl(F, [], AllCard).


%% 登录后初始化：每天首次登录，赠送VIP经验
%% login/1时，add_vip_exp/2还走不通，放到after_login处理
after_login(PS) ->
    NowTime = utime:unixtime(),
    #role_vip{
        vip_lv = OldVipLv,
        vip_exp = OldVipExp,
        vip_type = VipType,
        vip_card_list = CardList,
        login_exp_time = LoginExpTime
    } = PS#player_status.vip,
    init_timeout_card(PS#player_status.id, CardList),
    IsVipLvMax = is_vip_lv_max(PS),
    DiffDays = utime:diff_days(LoginExpTime),
    IsTempCard = is_temp_card(CardList),
    AddVipExp =
        case lists:member(VipType, get_pay_vip_card()) of
            true -> ?GIVE_EXP * 10;
            false -> 0
        end,
    if
    %% vip等级未达上限时，每天首次登录送经验 且付费卡生效
        IsVipLvMax == false andalso DiffDays >= 1 andalso VipType =/= 0 andalso IsTempCard == false->
            Sql = io_lib:format(?UPDATE_VIP_LOGIN_EXP_TIME, [NowTime, PS#player_status.id]),
            db:execute(Sql),
            NewPS = add_vip_exp(PS, AddVipExp),
            lib_log_api:log_vip_exp(PS#player_status.id, 4, 0, AddVipExp, OldVipLv, OldVipExp,
                NewPS#player_status.vip#role_vip.vip_lv, NewPS#player_status.vip#role_vip.vip_exp, NowTime),
            NewRoleVip = NewPS#player_status.vip,
            NewRoleVip2 = NewRoleVip#role_vip{login_exp_time = NowTime},
            NewPS2 = NewPS#player_status{vip = NewRoleVip2};
        true -> NewPS2 = PS
    end,
    %% 如果是体验卡，且过期了如果只有体验卡修正等级
    #player_status{vip = NewRoleVip3, id = RoleId} = NewPS2,
    case CardList of
        [#vip_card{is_temp_card = 1, end_time = EndTime}] when NowTime > EndTime ->
            NewRoleVip4 = NewRoleVip3#role_vip{vip_type = 0, vip_lv = 0},
            Sql1 = io_lib:format(?UPDATE_VIP_INFO, [0, 0, NewRoleVip3#role_vip.cost_gold, RoleId]),
            db:execute(Sql1),
            NewPS2#player_status{vip = NewRoleVip4};
        _ ->
            NewPS2
    end.


%% 更新登录
update_login(PS) ->
    updata_free_card_state(PS).

%% 登出处理
logout(PS) ->
    PlayerId = PS#player_status.id,
    update_total_login_time(PS),
    delete_ets_vip_card(PlayerId).


delay_logout(PS) ->
    NowTime = utime:unixtime(),
    #player_status{id = PlayerId, last_login_time = LoginTime, vip = Vip = #role_vip{free_card = FreeCard, total_login_time = TotalTime}} = PS,
    NewTotalTime = TotalTime + max(0, NowTime - LoginTime),
    FreeCardBin = util:term_to_bitstring(FreeCard),
    Sql = io_lib:format(?UPDATE_VIP_TOTAL_TIME, [NewTotalTime, FreeCardBin, PlayerId]),
    db:execute(Sql),
    NewVip = Vip#role_vip{total_login_time = NewTotalTime},
    PS#player_status{vip = NewVip}.


update_total_login_time(PS) ->
    NowTime = utime:unixtime(),
    #player_status{id = PlayerId, last_login_time = LoginTime, vip = #role_vip{free_card = FreeCard, total_login_time = TotalTime}} = PS,
    NewTotalTime = TotalTime + max(0, NowTime - LoginTime),
    %%    ?PRINT("TotalTime, NewTotalTime:~w~n", [[TotalTime, NewTotalTime]]),
    FreeCardBin = util:term_to_bitstring(FreeCard),
    Sql = io_lib:format(?UPDATE_VIP_TOTAL_TIME, [NewTotalTime, FreeCardBin, PlayerId]),
    db:execute(Sql).


%% 初始化有时效的特权卡超时信息
init_timeout_card(PlayerId, CardList) ->
    F = fun(#vip_card{vip_type = VipType, forever = Forever, end_time = EndTime}) ->
        HandleTimeOut = is_handle_timeout(VipType, Forever, EndTime),
        ?IF(HandleTimeOut, save_ets_vip_card(PlayerId, VipType, EndTime), skip)
        end,
    lists:foreach(F, CardList).

is_handle_timeout(VipType, Forever, EndTime) ->
    VipType > 0 andalso Forever =/= 1 andalso EndTime > utime:unixtime().

save_ets_vip_card(PlayerId, VipType, EndTime) ->
    ets:insert(?ETS_VIP_CARD, #ets_vip_card{key = {PlayerId, VipType}, end_time = EndTime}),
    ok.

delete_ets_vip_card(PlayerId) ->
    ets:match_delete(?ETS_VIP_CARD, #ets_vip_card{key = {PlayerId, '_'}, _ = '_'}),
    ok.
delete_ets_vip_card(PlayerId, VipType) ->
    ets:delete(?ETS_VIP_CARD, {PlayerId, VipType}),
    ok.

%% 扫描是否有失效的vip特权卡
timer_check() ->
    NowTime = utime:unixtime(),
    MatchSpec = ets:fun2ms(
        fun(#ets_vip_card{end_time = EndTime} = Magic) when EndTime < NowTime -> Magic end),
    EndTimeList = ets:select(?ETS_VIP_CARD, MatchSpec),
    IdList = lists:usort([{PlayerId, VipType} || #ets_vip_card{key = {PlayerId, VipType}} <- EndTimeList]),
    do_batch(IdList, fun do_timer_check/1, 1, {30, 100}).

do_batch([], _F, _Index, {_SleepNum, _SleepTime}) -> ok;
do_batch([Args | T], F, Index, {SleepNum, SleepTime}) ->
    case Index of
        SleepNum ->
            timer:sleep(SleepTime),
            NewIndex = 1;
        _ ->
            NewIndex = Index + 1
    end,
    F(Args),
    do_batch(T, F, NewIndex, {SleepNum, SleepTime}).

do_timer_check({PlayerId, VipType}) ->
    lib_player:apply_cast(PlayerId, ?APPLY_CAST_SAVE, lib_vip, timeout_card, [VipType]).

%% 处理超时特权卡
timeout_card(PS, TimeOutVipType) ->
%%    ?MYLOG("cym", "timeout_card ~p~n", [TimeOutVipType]),
    NowTime = utime:unixtime(),
    PlayerId = PS#player_status.id,
    #role_vip{
        vip_card_list = CardList
        ,vip_exp = VipExp
        , vip_lv = VipLv
        ,cost_gold = CostGold
    } = RoleVip = PS#player_status.vip,
    %% 通知超时
    case lists:keyfind(TimeOutVipType, #vip_card.vip_type, CardList) of
        #vip_card{is_temp_card = IsTempCard, end_time = EndTime}
            when EndTime =/= 0 andalso EndTime < NowTime ->
            delete_ets_vip_card(PlayerId, TimeOutVipType),
            %%            RecVipTypeList = recommend_vip_type(CardList),
            %%            ?PRINT("TimeOutVipType, IsTempCard, RecVipTypeList:~w~n",[{TimeOutVipType, IsTempCard, RecVipTypeList}]),
            {ok, Bin} = pt_450:write(45006, [TimeOutVipType, IsTempCard]),
            lib_server_send:send_to_sid(PS#player_status.sid, Bin);
        _ -> skip
    end,
    %% 上一张特权超时后，取其余特权卡最好的一类
    VipType = get_vip_type(CardList),
    % 如果只有一张卡 ，且是体验卡，且等级是1 则变为 0
    case CardList of
        [#vip_card{is_temp_card = 1}]  ->
%%            ?MYLOG("vip", "CardList ~p  VipLv ~p~n", [CardList, VipLv]),
            if
                VipLv == 1 ->
                    NewRoleVip = RoleVip#role_vip{vip_type = VipType, vip_lv = 0},
                    Sql1 = io_lib:format(?UPDATE_VIP_INFO, [0, VipExp, CostGold, PlayerId]),
                    db:execute(Sql1);
                true ->
                    NewRoleVip = RoleVip#role_vip{vip_type = VipType}
            end;
        _ ->
%%            ?MYLOG("vip", "CardList ~p~n", [CardList]),
            NewRoleVip = RoleVip#role_vip{vip_type = VipType}
    end,
    NewPS = PS#player_status{vip = NewRoleVip},
    NewPS1 = dispatch_update_vip(PS, NewPS),
    {ok, LastPS} = lib_player_event:dispatch(NewPS1, ?EVENT_VIP_TIME_OUT),
    {ok, LastPS}.


dispatch_update_vip(OldPS, PS) ->
    PlayerId = PS#player_status.id,
    #role_vip{vip_type = OldVipType, vip_lv = OldVipLv} = OldPS#player_status.vip,
    #role_vip{vip_type = VipType, vip_lv = VipLv, vip_card_list = _CardList} = PS#player_status.vip,
    if
        OldVipType =/= VipType orelse OldVipLv =/= VipLv ->
            Figure = PS#player_status.figure,
            NewFigure = Figure#figure{vip_type = VipType, vip = VipLv},
            NewPS = PS#player_status{figure = NewFigure},
            mod_scene_agent:update(NewPS, [{vip, [VipType, VipLv]}]),
            lib_scene:broadcast_player_attr(NewPS, [{4, VipType}, {5, VipLv}]), % 12010协议
            lib_role:update_role_show(PlayerId, [{figure, NewFigure}]),
            %% vip升级成就
            lib_achievement_api:vip_lv_up_event(NewPS, VipLv),
            %%   检查vip周礼包领取状态

            %% 派发vip变更事件
            CallBack = #callback_vip_change{old_vip_type = OldVipType,
                new_vip_type = VipType, old_vip_lv = OldVipLv, new_vip_lv = VipLv},
            {ok, NewPS2} = lib_player_event:dispatch(NewPS, ?EVENT_VIP, CallBack),
            NewPS3 = lib_player:count_player_attribute(NewPS2),
            lib_player:send_attribute_change_notify(NewPS3, ?NOTIFY_ATTR),
            LastPS =
                case OldVipLv < VipLv of
                    true ->
                        lib_log_api:log_vip_lv(PlayerId, OldVipLv, VipLv, utime:unixtime()),
                        %% 激活称号
                        F = fun(VipLvTmp, PsTmp) ->
                            #data_vip{rewards = Rewards} = data_vip:get(VipLvTmp),
                            case lists:keyfind(design, 1, Rewards) of
                                false -> % 没有称号奖励
                                    PsTmp;
                                {design, DesignId} ->
                                    %%                                    ?PRINT("======================================DesignId:~p~n",[DesignId]),
                                    case lib_designation:active_dsgt(PsTmp, DesignId) of
                                        {ok, LastPS1} -> LastPS1;
                                        {add_money, LastPS1, _} -> LastPS1;
                                        _ -> PsTmp
                                    end
                            end
                            end,
                        lists:foldl(F, NewPS3, lists:seq(OldVipLv + 1, VipLv));
                    false -> NewPS3
                end,
            LastPS;
        true -> LastPS = PS
    end,
    pp_vip:handle(45000, LastPS, []),
    pp_vip:handle(45004, LastPS, []),
    LastPS.

recommend_vip_type(CardList) ->
    NowTime = utime:unixtime(),
    VipTypeList = lists:reverse(data_vip:get_vip_type_list()),
    recommend_vip_type_helper(VipTypeList, CardList, NowTime, []).

recommend_vip_type_helper([], _CardList, _NowTime, Res) -> Res;
recommend_vip_type_helper([VipType | T], CardList, NowTime, Res) ->
    case is_recommend(VipType, CardList, NowTime) of
        true -> recommend_vip_type_helper(T, CardList, NowTime, [VipType | Res]);
        false -> Res
    end.

is_recommend(VipType, CardList, NowTime) ->
    case lists:keyfind(VipType, #vip_card.vip_type, CardList) of
        #vip_card{award_status = AwardStatus} when AwardStatus == 0 -> true;
        #vip_card{forever = Forever} when Forever == 1 -> false;
        #vip_card{end_time = EndTime} when EndTime > NowTime -> false;
        _ -> true
    end.

%% 消费钻石增加vip经验
cost_money(Player, AddGold) ->
    %% 注：最新需求改为了消耗钻石跟经验10:1
    LastCostGold = 0,
    AddVipExp = AddGold,
    IsVipLvMax = is_vip_lv_max(Player),
    case AddVipExp > 0 of
        true when IsVipLvMax == false ->
            NewPlayer = add_vip_exp(Player, LastCostGold, AddVipExp),
            NowTime = utime:unixtime(),
            lib_log_api:log_vip_exp(Player#player_status.id, 3, 0, AddGold,
                Player#player_status.vip#role_vip.vip_lv, Player#player_status.vip#role_vip.vip_exp,
                NewPlayer#player_status.vip#role_vip.vip_lv, NewPlayer#player_status.vip#role_vip.vip_exp, NowTime),
            NewPlayer;
        %% vip等级已达上限或者AddVipExp为0
        _ ->
            Player
    end.

%% 购买礼包增加经验
buy_product(Player, AddExp) ->
    #player_status{vip = #role_vip{vip_card_list = CardList, vip_lv = OldLv, vip_exp = OldExp}, id = RoleId} = Player,
    VipType = lib_vip:get_vip_type(CardList),
    IsTempCard =  is_temp_card(CardList),
    IsVipLvMax = is_vip_lv_max(Player),
    IsSatisfy = VipType =/= 0 andalso not IsTempCard andalso not IsVipLvMax,
    case AddExp > 0 of
        true when IsSatisfy ->
            NewPlayer = add_vip_exp(Player, 0, AddExp),
            #player_status{vip = #role_vip{vip_lv = NewLv, vip_exp = NewExp}} = NewPlayer,
            lib_log_api:log_vip_exp(RoleId, 5, 0, AddExp, OldLv, OldExp, NewLv, NewExp, utime:unixtime()),
            NewPlayer;
        %% vip等级已达上限或者AddVipExp为0
        _ ->
            Player
    end.

add_vip_exp(Player, AddVipExp) ->
    #role_vip{
        cost_gold = CostGold
    } = Player#player_status.vip,
    add_vip_exp(Player, CostGold, AddVipExp).

%% 给玩家添加VIP经验（外部需要使用）
add_vip_exp(Player, CostGold, AddVipExp) ->
    #player_status{id = Id, vip = RoleVip} = Player,
    #role_vip{vip_lv = OldVipLv, vip_exp = VipExp} = RoleVip,
    % ?PRINT("add_vip_exp  OldVipLv:~p,VipExp:~p~n  ", [OldVipLv, VipExp]),
    RoleVip2 = #role_vip{
        vip_lv = VipLv2,
        vip_exp = VipExp2,
        week_list = NewWeekList
    } = do_vip_level_up(RoleVip#role_vip{vip_exp = VipExp + AddVipExp, cost_gold = CostGold}),
    Sql = io_lib:format(?UPDATE_VIP_INFO, [VipLv2, VipExp2, CostGold, Id]),
    db:execute(Sql),
    %%   更新周礼包
    case OldVipLv =/= VipLv2 of
        true ->
            Sql1 = io_lib:format(?UPDATE_VIP_WEEK_REWARD, [util:term_to_string(NewWeekList), Id]),
            db:execute(Sql1);
        false ->
            skip
    end,
    NewPlayer = Player#player_status{vip = RoleVip2},
    LastPlayer = dispatch_update_vip(Player, NewPlayer),
    % %% 神器
    % lib_artifact_api:mod_activate_artifact(LastPlayer, vip);
    % %% 刷新帮派成员列表
    % guild_member:update_member_info(LastPlayer),
    % %% 刷新排行榜
    % mod_rank:refresh_player_info(Id, [{vip, VipLv2}])
    LastPlayer.

do_vip_level_up(RoleVip = #role_vip{vip_lv = VipLv, vip_exp = VipExp, week_list = WeekList}) ->
    % ?PRINT("do_vip_level_up   VipLv,VipExp :~p  ~p~n", [VipLv, VipExp]),
    case data_vip:get(VipLv + 1) of
        #data_vip{need_gold = NeedExp} when VipExp >= NeedExp * ?VIP_CONVERT ->
            %%           更新vip周礼物列表
            NewVipLv = VipLv + 1,
            NowTime = utime:unixtime(),
            %%            F = fun({VipTmp, UnLock, GetTime}, WeekListTmp) ->
            %%                case utime:is_same_day(GetTime, NowTime) of
            %%                    true ->
            %%                        [{VipTmp, UnLock, GetTime} | WeekListTmp];
            %%                    false ->
            %%                        [{VipTmp, NowTime, GetTime} | WeekListTmp]
            %%                end
            %%                end,
            %%            WeekList1 = lists:foldl(F, [], WeekList),
            NewWeekList = lists:keystore(NewVipLv, 1, WeekList, {NewVipLv, NowTime, 0}),
            do_vip_level_up(RoleVip#role_vip{vip_lv = NewVipLv, week_list = NewWeekList});
        _ ->
            RoleVip
    end.

get_vip_lv(#player_status{vip = RoleVip}) ->
    RoleVip#role_vip.vip_lv.

get_vip_lv_max() ->
    lists:max(data_vip:get_all_vip_lv()).

is_vip_lv_max(PS) ->
    #role_vip{vip_lv = VipLv} = PS#player_status.vip,
    MaxVipLv = get_vip_lv_max(),
    VipLv >= MaxVipLv.


%% 购买vip特权卡
buy_vip_card(PS, VipType) ->
    DataVipCard = data_vip:get_vip_card(VipType),
    %%    IsVipLvMax = is_vip_lv_max(PS),   % 是否满级
    %%    _IsRepeat = repeat_enable_forever(PS, VipType),
    CheckList = [{accord, VipType}, card_cfg, expire_type_exist, gold_enough],
    case check_buy_vip(CheckList, PS, DataVipCard) of
        %% 购买vip
        {true, NewPS} ->
            {ok, LastPS} = handle_buy_vip_enable(NewPS, DataVipCard),
            {ok, LastPS};
        {false, Res, NewPS} ->
            lib_server_send:send_to_sid(PS#player_status.sid, pt_450, 45003, [Res]),
            {ok, NewPS}
    end.

handle_buy_vip_enable(PS, DataVipCard) ->
    NowTime = utime:unixtime(),
    PlayerId = PS#player_status.id,
    %%    Career = PS#player_status.figure#figure.career,
    #data_vip_card{
        vip_type = VipType, vip_name = _VipName, price = Price, give_lv = GiveLv, vip_exp = GiveExp,
        expire_type = ExpireType, expire_time = ExpireTime
        %%        , award_list = AwardList
    } = DataVipCard,
    #role_vip{
        vip_type = OldVipType,
        vip_lv = OldVipLv,
        vip_exp = OldVipExp,
        vip_card_list = CardList,
        cost_gold = CostGold} = PS#player_status.vip,
    OldPrice = case data_vip:get_vip_card(OldVipType) of
                   #data_vip_card{price = OPrice} ->
                       OPrice;
                   _ -> 0
               end,
    {AwardStatus, _OldEndTime} =
        case lists:keyfind(VipType, #vip_card.vip_type, CardList) of
            #vip_card{award_status = AwardSt, end_time = OldEndT} -> {AwardSt, OldEndT};
            _ -> {0, 0}
        end,
    %% 是否首次激活，是的话准备给奖励，更新状态
    GiveFirstAward = ?IF(AwardStatus == 0, 1, 0),
    NewAwardStatus = ?IF(AwardStatus == 0, 1, AwardStatus),
    %%    CareerAwardList =
    %%        case lists:keyfind(Career, 1, AwardList) of
    %%            {Career, CareerAwardL} when GiveFirstAward == 1 -> CareerAwardL;
    %%            _ -> []
    %%        end,
    About = ulists:concat(["vip_type:", VipType]),
    IsTempCard = lib_vip:is_temp_card(CardList),
    if
        IsTempCard == true ->
            TurePrice = Price;
        true ->
            TurePrice = max(0, Price - OldPrice)
    end,
    % 1> 特权卡等级 大于 玩家vip等级,不加入vip经验
    % 2> 特权卡等级 小于等于 玩家vip等级,加入vip经验
    case GiveLv > OldVipLv of
        true -> NewPS2 = lib_goods_util:cost_money(PS, TurePrice, ?GOLD, buy_vip_up, About);
        false -> NewPS2 = lib_goods_util:cost_money(PS, TurePrice, ?GOLD, buy_vip, About)
    end,
    %% 处理激活状态
    {VipCard, NewPS3} = enable_vip_card(NewPS2, VipType, 0, ExpireType, ExpireTime),
    NewVipCard = VipCard#vip_card{award_status = NewAwardStatus},
    %% 计算保送等级
%%    ?PRINT("GiveLv1:~p~n", [GiveLv]),
    {NewVipLv, TempNewVipExp, NewWeekList} = calc_give_lv(NewPS3#player_status.vip, GiveLv, GiveExp * ?VIP_CONVERT),
    %%  体验特权卡经验修正, 如果是特权卡，第一次买v1卡，会出现经验不对的情况，所以要修正等级1 的经验
    case lib_vip:is_temp_card(CardList) of
        true ->
            #data_vip{need_gold = NeedExp1} = data_vip:get(GiveLv),
            NewVipExp =  NeedExp1 * ?VIP_CONVERT;
        _ ->
            NewVipExp = TempNewVipExp
    end,
%%    ?PRINT("CardList:~p~n", [CardList]),
%%    ?PRINT("NewVipExp:~p~n", [NewVipExp]),
    RoleVip = NewPS3#player_status.vip,
    NewRoleVip = RoleVip#role_vip{vip_lv = NewVipLv, vip_exp = NewVipExp, week_list = NewWeekList},
    NewPS4 = NewPS3#player_status{vip = NewRoleVip},
    F = fun() ->
        db_enable_vip_card(NewPS4, NewVipCard),
        Sql = io_lib:format(?UPDATE_VIP_INFO, [NewVipLv, NewVipExp, CostGold, PlayerId]),
        db:execute(Sql),
        %%   更新周礼包
        case RoleVip#role_vip.vip_lv =/= NewVipLv of
            true ->
                Sql1 = io_lib:format(?UPDATE_VIP_WEEK_REWARD, [util:term_to_string(NewWeekList), PlayerId]),
                db:execute(Sql1);
            false ->
                skip
        end,
        ok
        end,
    case db:transaction(F) of
        ok ->
            NewPS5 = after_enable_vip_card(NewPS4, NewVipCard, 0, GiveFirstAward),
            NewPS6 = dispatch_update_vip(PS, NewPS5),
            %% 派发购买vip卡事件
%%            {ok, NewPS7} = handle_receive_vip_card(NewPS6, data_vip:get_vip_card(3)), % 直接领取v3
            {ok, LastPS} = lib_player_event:dispatch(NewPS6, ?EVENT_BUY_VIP, VipType),
            lib_server_send:send_to_sid(PS#player_status.sid, pt_450, 45003, [?SUCCESS]),
            % PS#player_status.figure#figure.gm =/= 1 andalso OldEndTime < NowTime andalso
            %     lib_chat:send_TV({all}, ?MOD_VIP, 1, [PS#player_status.figure#figure.name, VipName]),
            lib_log_api:log_vip_buy(PlayerId, VipType, Price, GiveFirstAward, [], 0, NewVipCard#vip_card.forever,
                NewVipCard#vip_card.end_time, NowTime),
            lib_log_api:log_vip_exp(PlayerId, 1, VipType, 0, OldVipLv, OldVipExp,
                LastPS#player_status.vip#role_vip.vip_lv, LastPS#player_status.vip#role_vip.vip_exp, NowTime),
            % TA数据上报
            ta_agent_fire:vip_card_buy(LastPS, VipType, TurePrice),
            {ok, LastPS};
        Error ->
            ?ERR("~p ~p Error:~p~n", [?MODULE, ?LINE, Error]),
            lib_server_send:send_to_sid(NewPS2#player_status.sid, pt_450, 45003, [?FAIL]),
            {ok, NewPS2}
    end.

%% 是否重复激活相同永久卡或者非首次激活比身上永久卡低级的卡
repeat_enable_forever(PS, EnableVipType) ->
    #role_vip{
        vip_card_list = CardList
    } = PS#player_status.vip,
    RepeatList = [VipType || #vip_card{vip_type = VipType, forever = Forever} <- CardList,
        Forever == 1 andalso VipType >= EnableVipType],
    length(RepeatList) > 0.

%% 计算保送vip等级
%% @return {保送后vip等级，vip当前经验, 周礼包}
calc_give_lv(RoleVip, GiveLv, GiveExp) when GiveLv > 0 ->
    #role_vip{vip_lv = OldVipLv, vip_exp = OldVipExp} = RoleVip,
    #data_vip{need_gold = NeedExp1} = data_vip:get(GiveLv),
    #role_vip{
        vip_lv = VipLv,
        vip_exp = VipExp,
        week_list = WeekList
    } = do_vip_level_up(RoleVip#role_vip{vip_exp = OldVipExp + GiveExp}),
    NowTime = utime:unixtime(),
    if
        OldVipLv < GiveLv->
            Num = lists:seq(OldVipLv + 1, GiveLv),
%%            ?PRINT("OldVipLv:~p , GiveLv ~p~n", [OldVipLv, GiveLv]),
            F = fun(TmpLv, TmpWeekList) ->
                case lists:keymember(TmpLv, 1, TmpWeekList) of
                    true ->
                        TmpWeekList;
                    _ ->
                        NewTmpWeekList = lists:keystore(TmpLv, 1, TmpWeekList, {TmpLv, NowTime, 0}),
                        NewTmpWeekList
                end
                end,
            NewWeekList = lists:foldl(F, RoleVip#role_vip.week_list, Num),
            {GiveLv, NeedExp1 * ?VIP_CONVERT, NewWeekList};
        OldVipLv >= GiveLv ->
%%            ?PRINT("OldVipLv  ~p, GiveLv ~p,  WeekList : ~p~n", [OldVipLv, GiveLv, WeekList]),
            {VipLv, VipExp, WeekList}
    end;

calc_give_lv(RoleVip, _GiveLv, _GiveExp) ->
    #role_vip{
        vip_lv = VipLv,
        vip_exp = VipExp,
        week_list = WeekList
    } = RoleVip,
    {VipLv, VipExp, WeekList}.

%% 是否已购买
has_buy(PS, #data_vip_goods{} = DataVipGoods) ->
    NowTime = utime:unixtime(),
    #data_vip_goods{
        vip_type = VipType,
        is_temp_card = GoodsIsTempCard
    } = DataVipGoods,
    #role_vip{
        vip_card_list = CardList
    } = PS#player_status.vip,
    case lists:keyfind(VipType, #vip_card.vip_type, CardList) of
        #vip_card{forever = Forever, is_temp_card = IsTempCard}
            when Forever == 1 andalso IsTempCard == 0 -> true;
        #vip_card{end_time = EndTime, is_temp_card = IsTempCard}
            when EndTime > NowTime andalso IsTempCard == 0 -> true;
        %% 体验卡不需要判断已购买
        _ when GoodsIsTempCard == 1 -> true;
        _ -> false
    end;
has_buy(_PS, _DataVipGoods) -> false.

%% 秘籍:设置卡超时
gm_set_card_timeout(#player_status{vip = #role_vip{vip_card_list = CardList} = RoleVip} = Player, VipType) ->
    case lists:keyfind(VipType, #vip_card.vip_type, CardList) of
        false -> NewCardList = CardList;
        VipCard ->
            NewVipCard = VipCard#vip_card{end_time = 0},
            NewCardList = lists:keystore(VipType, #vip_card.vip_type, CardList, NewVipCard)
    end,
    NewVipType = get_vip_type(NewCardList),
    NewRoleVip = RoleVip#role_vip{vip_type = NewVipType, vip_card_list = NewCardList},
    NewFigure = Player#player_status.figure#figure{vip_type = NewVipType},
    NewPlayer = Player#player_status{vip = NewRoleVip, figure = NewFigure},
    {ok, NewPlayer2} = timeout_card(NewPlayer, VipType),
    {ok, NewPlayer2}.

%% 预留用的gm秘籍
%%gm_add_vip_exp(PlayerId, AddVipExp) ->
%%    lib_player:apply_cast(PlayerId, ?APPLY_CAST_SAVE, lib_vip, gm_add_vip_exp_core, [AddVipExp]).
%%
%%gm_add_vip_exp_core(PS, AddVipExp) ->
%%    IsVipLvMax = is_vip_lv_max(PS),
%%    NewPS = if
%%    %% vip等级未达上限时
%%                IsVipLvMax == false -> add_vip_exp(PS, AddVipExp);
%%                true -> PS
%%            end,
%%    lib_log_api:log_vip_exp(PS#player_status.id, 4, 0, 0, PS#player_status.vip#role_vip.vip_lv,
%%        PS#player_status.vip#role_vip.vip_exp, NewPS#player_status.vip#role_vip.vip_lv,
%%        NewPS#player_status.vip#role_vip.vip_exp, utime:unixtime()),
%%    {ok, NewPS}.

%% 使用特权卡激活道具
%%use_goods(PS, GoodsInfo, GoodsNum) when GoodsInfo#goods.goods_id == ?GOODS_ID_VIP_EXP ->
%%    GoodsId = GoodsInfo#goods.goods_id,
%%    AddVipExp = GoodsNum,
%%    IsVipLvMax = is_vip_lv_max(PS),
%%    NewPS = if
%%    %% vip等级未达上限时
%%                IsVipLvMax == false ->
%%                    add_vip_exp(PS, AddVipExp);
%%                true -> PS
%%            end,
%%    lib_log_api:log_vip_exp(PS#player_status.id, 3, 0, GoodsId, PS#player_status.vip#role_vip.vip_lv,
%%        PS#player_status.vip#role_vip.vip_exp, NewPS#player_status.vip#role_vip.vip_lv,
%%        NewPS#player_status.vip#role_vip.vip_exp, utime:unixtime()),
%%    {ok, NewPS};

%% 使用物品
%%use_goods(PS, GoodsInfo, GoodsNum) when GoodsNum == 1 ->
%%    DataVipGoods = data_vip:get_vip_goods(GoodsInfo#goods.goods_id),
%%    VipType = ?IF(is_record(DataVipGoods, data_vip_goods), DataVipGoods#data_vip_goods.vip_type, 0),
%%    HasBuy = has_buy(PS, DataVipGoods),
%%    _IsRepeat = repeat_enable_forever(PS, VipType),
%%    _IsVipLvMax = is_vip_lv_max(PS),
%%    CheckList = [vip_goods_cfg, expire_type_exist],
%%    case check_use_goods(CheckList, PS, DataVipGoods) of
%%        %% 特权卡续期vip
%%        {true, NewPS} when HasBuy == true ->
%%            {ok, only, LastPS} = handle_use_vip_goods_enable(NewPS, GoodsInfo, DataVipGoods),
%%            {ok, only, LastPS};
%%        %% 未购买vip，不能使用本vip道具
%%        {true, _NewPS} ->
%%            Res = ?ERRCODE(err450_has_notbuy),
%%            {false, Res};
%%        {false, Res, _NewPS} -> {false, Res}
%%    end;
%%
%%
%%use_goods(_PS, _GoodsInfo, _GoodsNum) ->
%%    {false, ?ERRCODE(err450_goods_onlyuse_one)}.

%%handle_use_vip_goods_enable(PS, GoodsInfo, DataVipGoods) ->
%%    NowTime = utime:unixtime(),
%%    PlayerId = PS#player_status.id,
%%    #role_vip{cost_gold = CostGold} = PS#player_status.vip,
%%    #data_vip_goods{
%%        vip_type = VipType, is_temp_card = IsTempCard, expire_type = ExpireType,
%%        expire_time = ExpireTime, give_lv = GiveLv, vip_exp = GiveExp
%%    } = DataVipGoods,
%%
%%    {VipCard, NewPS3} = enable_vip_card(PS, VipType, IsTempCard, ExpireType, ExpireTime),
%%    {NewVipLv, NewVipExp, NewWeekList} = calc_give_lv(NewPS3#player_status.vip, GiveLv, GiveExp * ?VIP_CONVERT),
%%    RoleVip = NewPS3#player_status.vip,
%%    NewPS4 = NewPS3#player_status{vip = RoleVip#role_vip{vip_lv = NewVipLv, vip_exp = NewVipExp, week_list = NewWeekList}},
%%    F = fun() ->
%%        db_enable_vip_card(NewPS4, VipCard),
%%        Sql = io_lib:format(?UPDATE_VIP_INFO, [NewVipLv, NewVipExp, CostGold, PlayerId]),
%%        db:execute(Sql),
%%        %%   更新周礼包
%%        case RoleVip#role_vip.vip_lv =/= NewVipLv of
%%            true ->
%%                Sql1 = io_lib:format(?UPDATE_VIP_WEEK_REWARD, [util:term_to_string(NewWeekList), PlayerId]),
%%                db:execute(Sql1);
%%            false ->
%%                skip
%%        end,
%%        ok
%%        end,
%%    case db:transaction(F) of
%%        ok ->
%%            GoodsId = GoodsInfo#goods.goods_id,
%%            NewPS5 = after_enable_vip_card(NewPS4, VipCard, IsTempCard, 0),
%%            LastPS = dispatch_update_vip(PS, NewPS5),
%%            lib_log_api:log_vip_goods(PS#player_status.id, GoodsId, VipType, 0, VipCard#vip_card.forever,
%%                VipCard#vip_card.end_time, NowTime),
%%            lib_log_api:log_vip_exp(PS#player_status.id, 2, 0, GoodsId, PS#player_status.vip#role_vip.vip_lv,
%%                PS#player_status.vip#role_vip.vip_exp, LastPS#player_status.vip#role_vip.vip_lv,
%%                LastPS#player_status.vip#role_vip.vip_exp, NowTime),
%%            {ok, only, LastPS};
%%        Error ->
%%            ?ERR("~p ~p Error:~p~n", [?MODULE, ?LINE, Error]),
%%            {false, ?FAIL}
%%    end.

%% 有效期类型列表
-define(EXPIRE_TYPE_LIST, [0, 1, 2, 3]).
enable_vip_card(Player, VipType, IsTempCard, ExpireType, ExpireTime) ->
    NowTime = utime:unixtime(),
    #role_vip{
        vip_lv = VipLv,
        vip_card_list = CardList
    } = RoleVip = Player#player_status.vip,
    case lists:keyfind(VipType, #vip_card.vip_type, CardList) of
        #vip_card{} = VipCard -> skip;
        _ -> VipCard = #vip_card{vip_type = VipType, is_temp_card = 1}
    end,
    OldEndTime = VipCard#vip_card.end_time,
    IfOldEndTime = ?IF(OldEndTime > NowTime, OldEndTime, NowTime),
    IsTempCard2 = min(IsTempCard, VipCard#vip_card.is_temp_card),
    NewVipCard = if
    %% 有效期：永久类型
                     ExpireType == 0 -> VipCard#vip_card{is_temp_card = IsTempCard2, forever = 1, end_time = 0};
    %% 有效期：秒类型
                     ExpireType == 1 ->
                         VipCard#vip_card{is_temp_card = IsTempCard2, end_time = max(NowTime + ExpireTime, IfOldEndTime)};
    %% 有效期：小时类型
                     ExpireType == 2 ->
                         VipCard#vip_card{is_temp_card = IsTempCard2, end_time = max(NowTime + ExpireTime * 3600, IfOldEndTime)};
    %% 有效期：天数类型
                     ExpireType == 3 ->
                         VipCard#vip_card{is_temp_card = IsTempCard2, end_time = max(NowTime + ExpireTime * 86400, IfOldEndTime)}
                 end,
    NewCardList = lists:keystore(VipType, #vip_card.vip_type, CardList, NewVipCard),
    NewVipType = get_vip_type(NewCardList),
    NewRoleVip = RoleVip#role_vip{vip_type = NewVipType, vip_card_list = NewCardList},
    NewFigure = Player#player_status.figure#figure{vip_type = NewVipType, vip = VipLv},
    NewPlayer = Player#player_status{vip = NewRoleVip, figure = NewFigure},
    {NewVipCard, NewPlayer}.

db_enable_vip_card(Player, VipCard) ->
    Sql = io_lib:format(?INSERT_VIP_CARD, [Player#player_status.id, VipCard#vip_card.vip_type, VipCard#vip_card.forever,
        VipCard#vip_card.is_temp_card, VipCard#vip_card.end_time, VipCard#vip_card.award_status]),
    db:execute(Sql).

after_enable_vip_card(Player, VipCard, _IsTempCard, _GiveFirstAward) ->
    lib_server_send:send_to_sid(Player#player_status.sid, pt_450, 45005, [VipCard#vip_card.vip_type,  VipCard#vip_card.is_temp_card]),
    %%    LastPlayer = send_card_award(Player, VipCard, GiveFirstAward),
    init_timeout_card(Player#player_status.id, [VipCard]),
    Player.

%% 首次激活奖励
send_card_award(PS, VipCard, 1) ->
    VipType = VipCard#vip_card.vip_type,
    #role_vip{
        vip_card_list = CardList
    } = RoleVip = PS#player_status.vip,
    DataVipCard = data_vip:get_vip_card(VipType),
    Career = PS#player_status.figure#figure.career,
    AwardList = DataVipCard#data_vip_card.award_list,
    {Career, CareerAwardList} = lists:keyfind(Career, 1, AwardList),
    GetAwardStatus = 1,
    Produce = #produce{
        type = vip_card_award, reward = CareerAwardList,
        remark = ulists:concat(["vip_type:", VipType]), show_tips = 3},
    NewPS = lib_goods_api:send_reward(PS, Produce),

    NewVipCard = VipCard#vip_card{award_status = GetAwardStatus},
    NewCardList = lists:keystore(VipType, #vip_card.vip_type, CardList, NewVipCard),
    NewRoleVip = RoleVip#role_vip{vip_card_list = NewCardList},
    NewPS#player_status{vip = NewRoleVip};
send_card_award(PS, _VipCard, _GiveFirstAward) ->
    PS.

%%
week_list_filter(VipLv, WeekList) ->
    NowTime = utime:unixtime(),
    Fun = fun(WeekTuple, LowWeekTmp) ->
        {Lv, UnLockTime, _OldGotTime} = WeekTuple,
        case utime:is_same_day(UnLockTime, NowTime) of
            true ->
                case Lv < LowWeekTmp of
                    true ->
                        Lv;
                    false ->
                        LowWeekTmp
                end;
            false ->
                LowWeekTmp
        end
          end,
    MinTodayLv = lists:foldl(Fun, 9999, WeekList),
    %%    ?PRINT("MinTodayLv:~p~n", [MinTodayLv]),
    case MinTodayLv == 9999 of
        true ->
            case lists:keyfind(VipLv, 1, WeekList) of
                {Lv1, _UnLockTime1, OldGotTime1} ->
                    case utime:is_same_day(OldGotTime1, NowTime) of
                        true -> [];
                        false -> [Lv1]
                    end;
                _ -> []
            end;
        false ->
            DayList = lists:seq(max(MinTodayLv - 1, 1), VipLv),
            Fun1 = fun(LvTmp, DayListTmp) ->
                case lists:keyfind(LvTmp, 1, WeekList) of
                    {Lv2, _UnLockTime2, OldGotTime2} ->
                        case utime:is_same_day(OldGotTime2, NowTime) of
                            true -> DayListTmp;
                            false -> [Lv2 | DayListTmp]
                        end;
                    _ ->
                        DayListTmp
                end
                   end,
            lists:foldl(Fun1, [], DayList)
    end.
%%    Fun =
%%        fun(WeekTuple, WeekListTmp) ->
%%            {Lv, UnLockTime, OldGotTime} = WeekTuple,
%%            case VipLv == Lv of
%%                true ->
%%                    case utime:is_same_day(OldGotTime, NowTime) of
%%                        true ->
%%                            WeekListTmp;
%%                        false ->
%%                            [Lv | WeekListTmp]
%%                    end;
%%                false ->
%%                    case utime:is_same_day(UnLockTime, NowTime) of
%%                        true -> % 当天解锁
%%                            case utime:is_same_day(OldGotTime, NowTime) of
%%                                true ->
%%                                    WeekListTmp;
%%                                false ->
%%                                    [Lv | WeekListTmp]
%%                            end;
%%                        false ->
%%                            WeekListTmp
%%                    end
%%            end
%%        end,
%%    lists:foldl(Fun, [], WeekList).

%% 更新免费卡的状态
updata_free_card_state(Player) ->
    #player_status{vip = RoleVip, last_login_time = LoginTime, reg_time = RegTime} = Player,
    #role_vip{free_card = FreeCard, total_login_time = TotalTime} = RoleVip,
    AllVipCardType = data_vip:get_vip_type_list(),
    F = fun(VipCardType, CardTmp) ->
        case lists:keyfind(VipCardType, 1, FreeCard) of
            {VipCardType, State} ->
                [{VipCardType, State} | CardTmp];
            false ->
                #data_vip_card{get_config = GetConfig} = data_vip:get_vip_card(VipCardType),
                case GetConfig == [] of
                    true -> CardTmp;
                    false ->
                        %%                        ?PRINT("BefLoginTime, LoginTime:~w~n", [[BefLoginTime, LoginTime]]),
                        case check_can_get_card(GetConfig, TotalTime, LoginTime, RegTime) of
                            true ->
                                [{VipCardType, 1} | CardTmp];
                            false ->
                                CardTmp
                        end
                end
        end
        end,
    NewFreeCard = lists:foldl(F, [], AllVipCardType),
    NewRoleVip = RoleVip#role_vip{free_card = NewFreeCard},
    Player#player_status{vip = NewRoleVip}.

%% 获得免费卡的列表
get_use_card_list(Player) ->
    NewPlayer = updata_free_card_state(Player),
    NowTime = utime:unixtime(),
    #player_status{last_login_time = LoginTime, vip = #role_vip{free_card = FreeCard, total_login_time = TotalTime}} = NewPlayer,
    AllVipCardType = data_vip:get_vip_type_list(),
    F = fun(VipCardType, CardTmp) ->
        #data_vip_card{get_config = GetConfig} = data_vip:get_vip_card(VipCardType),
        case GetConfig of
            [] ->
                CardTmp;
            [{login_time, NeedTime}] ->
                case lists:keyfind(VipCardType, 1, FreeCard) of
                    {VipCardType, State} ->
                        case State of
                            1 ->
                                [{VipCardType, 1} | CardTmp];
                            2 ->
                                [{VipCardType, 2} | CardTmp]
                        end;
                    false ->
                        [{VipCardType, NowTime + max(0, NeedTime - (NowTime - LoginTime + TotalTime))} | CardTmp]
                end;
            [{relogin}] ->
                case lists:keyfind(VipCardType, 1, FreeCard) of
                    {VipCardType, State} ->
                        case State of
                            1 ->
                                [{VipCardType, 1} | CardTmp];
                            2 ->
                                [{VipCardType, 2} | CardTmp]
                        end;
                    false ->
%%                        [{VipCardType, utime:unixdate() + ?ONE_DAY_SECONDS} | CardTmp]
                        [{VipCardType, utime:get_diff_day_standard_unixdate(1, 1)} | CardTmp]
                end
        end
        end,
    UseCard = lists:foldl(F, [], AllVipCardType),
    {UseCard, NewPlayer}.


%% 领取免费卡
receive_vip_card(PS, VipType) ->
    DataVipCard = data_vip:get_vip_card(VipType),
    #player_status{vip = RoleVip} = PS,
    #role_vip{free_card = FreeCard} = RoleVip,
    case lists:keyfind(VipType, 1, FreeCard) of
        {VipType, State} -> %% 购买vip
            case State of
                1 ->
                    {ok, _LastPS} = handle_receive_vip_card(PS, DataVipCard);
                _ ->
                    {ok, PS}
            end;
        false ->
            lib_server_send:send_to_sid(PS#player_status.sid, pt_450, 45007, [?FAIL]),
            {ok, PS}
    end.

handle_receive_vip_card(PS, DataVipCard) ->
    NowTime = utime:unixtime(),
    PlayerId = PS#player_status.id,
    #data_vip_card{
        vip_type = VipType, vip_name = _VipName, price = Price, give_lv = GiveLv,
        vip_exp = GiveExp, expire_type = ExpireType, expire_time = ExpireTime
    } = DataVipCard,
    #role_vip{
        vip_lv = OldVipLv,
        vip_exp = OldVipExp,
        vip_card_list = CardList,
        cost_gold = CostGold,
        free_card = FreeCard} = PS#player_status.vip,
    {_AwardStatus, _OldEndTime} =
        case lists:keyfind(VipType, #vip_card.vip_type, CardList) of
            #vip_card{award_status = AwardSt, end_time = OldEndT} -> {AwardSt, OldEndT};
            _ -> {0, 0}
        end,
    %% 处理激活状态
    {VipCard, NewPS3} = enable_vip_card(PS, VipType, 0, ExpireType, ExpireTime),
    %% 计算保送等级
    %%    ?PRINT("GiveLv2:~p", [GiveLv]),
    {NewVipLv, NewVipExp, NewWeekList} = calc_give_lv(NewPS3#player_status.vip, GiveLv, GiveExp * ?VIP_CONVERT),
    RoleVip = NewPS3#player_status.vip,
    NewFreeCard =
        case VipType of
            3 -> % 当第三个可以领了默认低级都领取
                [{1, 2}, {2, 2}, {3, 2}];
            _ ->
                lists:keyreplace(VipType, 1, FreeCard, {VipType, 2})
        end,
    NewRoleVip = RoleVip#role_vip{vip_lv = NewVipLv, vip_exp = NewVipExp, week_list = NewWeekList, free_card = NewFreeCard},
    NewPS4 = NewPS3#player_status{vip = NewRoleVip},
    F = fun() ->
        db_enable_vip_card(NewPS4, VipCard),
        Sql = io_lib:format(?UPDATE_VIP_INFO, [NewVipLv, NewVipExp, CostGold, PlayerId]),
        db:execute(Sql),
        %%   更新周礼包
        case RoleVip#role_vip.vip_lv =/= NewVipLv of
            true ->
                Sql1 = io_lib:format(?UPDATE_VIP_WEEK_REWARD, [util:term_to_string(NewWeekList), PlayerId]),
                db:execute(Sql1);
            false -> skip
        end, ok
        end,
    case db:transaction(F) of
        ok ->
            NewPS5 = after_enable_vip_card(NewPS4, VipCard, 0, 0),
            NewPS6 = dispatch_update_vip(PS, NewPS5),

            %% 派发购买vip卡事件
            {ok, LastPS} = lib_player_event:dispatch(NewPS6, ?EVENT_FREE_VIP, VipType),
            % PS#player_status.figure#figure.gm =/= 1 andalso OldEndTime < NowTime andalso
            %     lib_chat:send_TV({all}, ?MOD_VIP, 1, [PS#player_status.figure#figure.name, PS#player_status.id]),
            lib_log_api:log_vip_buy(PlayerId, VipType, Price, 2, [], 0, VipCard#vip_card.forever, VipCard#vip_card.end_time, NowTime),
            lib_log_api:log_vip_exp(PlayerId, 1, VipType, 0, OldVipLv, OldVipExp, LastPS#player_status.vip#role_vip.vip_lv, LastPS#player_status.vip#role_vip.vip_exp, NowTime),
            lib_server_send:send_to_sid(PS#player_status.sid, pt_450, 45007, [?SUCCESS]),
            {ok, LastPS};
        Error ->
            ?ERR("~p ~p Error:~p~n", [?MODULE, ?LINE, Error]),
            lib_server_send:send_to_sid(PS#player_status.sid, pt_450, 45007, [?FAIL]),
            {ok, PS}
    end.

%% 隐藏vip
hide_vip(Player, Hide) ->
    #player_status{vip = RoleVip, id = RoleId, figure = Figure} = Player,
    case RoleVip of
        #role_vip{vip_hide = VipHide} when VipHide =/= Hide ->
            NewRoleVip = RoleVip#role_vip{vip_hide = Hide},
            db:execute(io_lib:format(?UPDATE_VIP_HIDE, [Hide, RoleId])),
            NewPlayer = Player#player_status{vip = NewRoleVip, figure = Figure#figure{vip_hide = Hide}},
            dispatch_hide_vip(NewPlayer, Hide),
            lib_server_send:send_to_uid(RoleId, pt_450, 45008, [Hide]),
            NewPlayer;
        _ ->
            lib_server_send:send_to_uid(RoleId, pt_450, 45008, [Hide]),
            Player
    end.

dispatch_hide_vip(Player, Hide) ->
    #player_status{figure = Figure, id = RoleId} = Player,
    mod_scene_agent:update(Player, [{vip_hide, Hide}]),
    lib_scene:broadcast_player_attr(Player, [{17, Hide}]), % 12010协议
    lib_role:update_role_show(RoleId, [{figure, Figure}]),
    ok.


%% ------------------------------ check function -----------------------------

check_can_get_card([], _, _, _) -> false;
check_can_get_card([H | T], TotalTime, LoginTime, RegTime) ->
    NowTime = utime:unixtime(),
    case H of
        {login_time, NeedLoginTime} ->
            SumTime = TotalTime + (NowTime - LoginTime),
            case SumTime >= NeedLoginTime of
                true ->
                    true;
                false ->
                    check_can_get_card(T, TotalTime, LoginTime, RegTime)
            end;
        {relogin} ->
            case utime:is_same_day(NowTime, RegTime) of
                true ->
                    %%                    ?PRINT("LoginTime, RegTime:~w~n", [[LoginTime, RegTime]]),
                    check_can_get_card(T, TotalTime, LoginTime, RegTime);
                false ->
                    true
            end;
        Error ->
            ?ERR("vip check error:~p", [Error])
    end.


check_buy_vip([], PS, _DataVipCard) -> {true, PS};
check_buy_vip([H | T], PS, DataVipCard) ->
    case do_check_buy_vip(H, PS, DataVipCard) of
        {true, NewPS} -> check_buy_vip(T, NewPS, DataVipCard);
        {false, Res, NewPS} -> {false, Res, NewPS}
    end.

%% 检查是否存在特权卡
do_check_buy_vip(card_cfg, PS, DataVipCard) ->
    case DataVipCard of
        #data_vip_card{get_config = Config} when Config == [] -> {true, PS};
        _ -> {false, ?ERRCODE(err450_card_not_exist), PS}
    end;

%% 检查特权卡有效类型
do_check_buy_vip(expire_type_exist, PS, DataVipCard) ->
    case lists:member(DataVipCard#data_vip_card.expire_type, ?EXPIRE_TYPE_LIST) of
        true -> {true, PS};
        false -> {false, ?ERRCODE(err450_expire_type_error), PS}
    end;

%% 检查特权卡是否可以购买
do_check_buy_vip({accord, VipType}, PS, _DataVipCard) ->
    #role_vip{vip_type = NowVipType, vip_card_list = CardList} = PS#player_status.vip,
    case CardList of  %%  有且只有一张免费卡则，随便买
        [#vip_card{is_temp_card = 1}] ->
            {true, PS};
        _ ->
            case VipType > NowVipType of
                true ->
                    {true, PS};
                false ->
                    {false, ?ERRCODE(err450_buy_low_card), PS}
            end
    end;


%% 检查奖励配置
%%do_check_buy_vip(first_award_exist, PS, DataVipCard) ->
%%    Career = PS#player_status.figure#figure.career,
%%    AwardList = DataVipCard#data_vip_card.award_list,
%%    case lists:keyfind(Career, 1, AwardList) of
%%        {Career, _List} -> {true, PS};
%%        _ -> {false, ?ERRCODE(err450_first_award_error), PS}
%%    end;
%% 检查是否满足消耗
do_check_buy_vip(gold_enough, PS, DataVipCard) ->
    Price = DataVipCard#data_vip_card.price,
    OldVipType = PS#player_status.figure#figure.vip_type,
    OldDataVipCard = data_vip:get_vip_card(OldVipType),
    OldPrice = case is_record(OldDataVipCard, data_vip_card) of
                   true -> OldDataVipCard#data_vip_card.price;
                   false -> 0
               end,
    NeedPrice = max(0, Price - OldPrice),
    case lib_goods_util:is_enough_money(PS, NeedPrice, ?GOLD) of
        true -> {true, PS};
        false -> {false, ?GOLD_NOT_ENOUGH, PS}
    end.

check_use_goods([], PS, _DataVipCard) -> {true, PS};
check_use_goods([H | T], PS, DataVipGoods) ->
    case do_check_use_goods(H, PS, DataVipGoods) of
        {true, NewPS} -> check_use_goods(T, NewPS, DataVipGoods);
        {false, Res, NewPS} -> {false, Res, NewPS}
    end.
%% 检查vip道具配置
do_check_use_goods(vip_goods_cfg, PS, DataVipGoods) ->
    case DataVipGoods of
        #data_vip_goods{} -> {true, PS};
        _ -> {false, ?ERRCODE(err450_vip_goods_cfg_error), PS}
    end;
%% 检查特权卡有效期类型
do_check_use_goods(expire_type_exist, PS, DataVipGoods) ->
    case lists:member(DataVipGoods#data_vip_goods.expire_type, ?EXPIRE_TYPE_LIST) of
        true -> {true, PS};
        false -> {false, ?ERRCODE(err450_expire_type_error), PS}
    end.



free_card(PS) ->
    #player_status{vip = Vip} =PS,
    #role_vip{vip_lv = VipLv} = Vip,
    if
        VipLv  >= 1 ->
            PS;
        true ->
            PS
    end.


%%%% 使用特權卡激活道具
%%use_goods(PS, GoodsInfo, GoodsNum) when GoodsInfo#goods.goods_id == ?GOODS_ID_VIP_EXP ->
%%    GoodsId = GoodsInfo#goods.goods_id,
%%    AddVipExp = GoodsNum,
%%    IsVipLvMax = is_vip_lv_max(PS),
%%    NewPS = if
%%    %% vip等級未達上限時
%%                IsVipLvMax == false -> add_vip_exp(PS, AddVipExp);
%%                true -> PS
%%            end,
%%    lib_log_api:log_vip_exp(PS#player_status.id, 3, 0, GoodsId, PS#player_status.vip#role_vip.vip_lv,
%%        PS#player_status.vip#role_vip.vip_exp, NewPS#player_status.vip#role_vip.vip_lv,
%%        NewPS#player_status.vip#role_vip.vip_exp, utime:unixtime()),
%%    {ok, NewPS};
use_goods(PS, GoodsInfo, GoodsNum) when GoodsNum==1 ->
    DataVipGoods = data_vip:get_vip_goods(GoodsInfo#goods.goods_id),
    VipType = ?IF(is_record(DataVipGoods, data_vip_goods), DataVipGoods#data_vip_goods.vip_type, 0),
%%    HasBuy = has_buy(PS, DataVipGoods),
%%    HasBuy = true,
    _IsRepeat  = repeat_enable_forever(PS, VipType),
    _IsVipLvMax = is_vip_lv_max(PS),
    CheckList = [vip_goods_cfg, expire_type_exist],
    case check_use_goods(CheckList, PS, DataVipGoods) of
        %% 特權卡續期vip
        {true, NewPS}  ->
            handle_use_vip_goods_enable(NewPS, GoodsInfo, DataVipGoods);
        %% 未購買vip，不能使用本vip道具
%%        {true, _NewPS} ->
%%            Res = ?ERRCODE(err450_has_notbuy),
%%            {false, Res};
        {false, Res, _NewPS} -> {false, Res}
    end;
use_goods(_PS, _GoodsInfo, _GoodsNum) ->
    {false, ?ERRCODE(err450_goods_onlyuse_one)}.


handle_use_vip_goods_enable(PS, GoodsInfo, DataVipGoods) ->
    NowTime = utime:unixtime(),
    PlayerId   = PS#player_status.id,
    #role_vip{cost_gold = CostGold, vip_lv = VipLvOld} =  PS#player_status.vip,
    #data_vip_goods{
        vip_type = VipType, is_temp_card = IsTempCard, expire_type = ExpireType,
        expire_time = ExpireTime, give_lv = GiveLv, vip_exp = GiveExp
    } = DataVipGoods,

    {VipCard, NewPS3} = enable_vip_card(PS, VipType, IsTempCard, ExpireType, ExpireTime),
    {NewVipLv, NewVipExp, NewWeekList} = calc_give_lv(NewPS3#player_status.vip, GiveLv, GiveExp  * ?VIP_CONVERT ),
    if
        VipLvOld >= 1 ->
            LastVipExp = NewVipExp;
        true ->
            LastVipExp = ?IF(IsTempCard == 1, 0, NewVipExp)
    end,
%%    ?MYLOG("cym", "{NewVipLv, NewVipExp, NewWeekList} ~p~n", [{NewVipLv, NewVipExp, NewWeekList}]),
    RoleVip = NewPS3#player_status.vip,
    NewPS4 = NewPS3#player_status{vip =  RoleVip#role_vip{vip_lv = NewVipLv, vip_exp = LastVipExp, week_list = NewWeekList}},
    F = fun() ->
        db_enable_vip_card(NewPS4, VipCard),
        Sql = io_lib:format(?UPDATE_VIP_INFO, [NewVipLv, LastVipExp, CostGold, PlayerId]),
        db:execute(Sql),
        %%   更新周礼包
        case RoleVip#role_vip.vip_lv =/= NewVipLv of
	        true ->
                Sql1 = io_lib:format(?UPDATE_VIP_WEEK_REWARD, [util:term_to_string(NewWeekList), PlayerId]),
                db:execute(Sql1);
            false -> skip
        end,
	    ok
        end,
    case db:transaction(F) of
        ok  ->
            GoodsId = GoodsInfo#goods.goods_id,
            NewPS5 = after_enable_vip_card(NewPS4, VipCard, IsTempCard, 0),
            LastPS = dispatch_update_vip(PS, NewPS5),
            lib_log_api:log_vip_goods(PS#player_status.id, GoodsId, VipType, 0, VipCard#vip_card.forever,
                VipCard#vip_card.end_time, NowTime),
            lib_log_api:log_vip_exp(PS#player_status.id, 2, 0, GoodsId, PS#player_status.vip#role_vip.vip_lv,
                PS#player_status.vip#role_vip.vip_exp, LastPS#player_status.vip#role_vip.vip_lv,
                LastPS#player_status.vip#role_vip.vip_exp, NowTime),
            {ok, only, LastPS};
        Error ->
            ?ERR("~p ~p Error:~p~n", [?MODULE, ?LINE, Error]),
            {false, ?FAIL}
    end.

is_temp_card([#vip_card{is_temp_card = 1}]) ->
    true;
is_temp_card(_) ->
    false.


gm_repair_vip() ->
    Sql = io_lib:format(<<"select  id from  role_vip  where   vip_lv > 0">>, []),
    RoleIds = db:get_all(Sql),
    [lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, ?HAND_OFFLINE, lib_vip, gm_repair_vip, [])|| [RoleId] <- RoleIds].


%% -----------------------------------------------------------------
%% @desc     功能描述   修复vip经验配置错误
%% @param    参数
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
gm_repair_vip(PS) ->
    #player_status{vip = RoleVip, id = RoleId} = PS,
    #role_vip{vip_card_list = CardList, vip_lv = VipLv, vip_exp = VipExp, cost_gold = CostGold} = RoleVip,
    case lib_vip:is_temp_card(CardList) of
        true ->
            PS;
        _ ->
            case data_vip:get(VipLv) of
                #data_vip{need_gold = NeedGold} ->
                    NeedVip = NeedGold * ?VIP_CONVERT,
                    if
                        VipExp >= NeedVip ->
                            PS;
                        true ->
                            RoleVipNew = RoleVip#role_vip{vip_exp = NeedVip},
                            %%  save to db
                            Sql = io_lib:format(?UPDATE_VIP_INFO, [VipLv, NeedVip, CostGold, RoleId]),
                            db:execute(Sql),
                            PS#player_status{vip = RoleVipNew}
                    end;
                _ ->
                    PS
            end
    end.

%% 更新vip等级
gm_update_vip_lv(RoleId, VipLv, VipExp) ->
    lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_vip, gm_repair_vip_help, [VipLv, VipExp]),
    ok.

gm_repair_vip_help(PS, VipLv, VipExp) ->
    #player_status{vip = RoleVip, id = RoleId} = PS,
    #role_vip{vip_card_list = CardList, cost_gold = CostGold} = RoleVip,
    IsTmep = lib_vip:is_temp_card(CardList),
    Config = data_vip:get(VipLv),
    if
        IsTmep -> PS;
        is_record(Config, data_vip) == false -> PS;
        true ->
            #data_vip{need_gold = NeedGold} = Config,
            case data_vip:get(VipLv+1) of
                #data_vip{need_gold = NextNeedGold} ->
                    NewVipExp = ?IF(VipExp >= NeedGold*?VIP_CONVERT andalso VipExp =< NextNeedGold*?VIP_CONVERT, VipExp, NeedGold*?VIP_CONVERT);
                _ ->
                    NewVipExp = max(NeedGold*?VIP_CONVERT, VipExp)
            end,
            RoleVipNew = RoleVip#role_vip{vip_lv = VipLv, vip_exp = NewVipExp},
            ?PRINT("VipLv:~p NewVipExp:~p ~n", [VipLv, NewVipExp]),
            %%  save to db
            Sql = io_lib:format(?UPDATE_VIP_INFO, [VipLv, NewVipExp, CostGold, RoleId]),
            db:execute(Sql),
            NewPS = PS#player_status{vip = RoleVipNew},
            pp_vip:handle(45000, NewPS, []),
            NewPS
    end.


%% 秘籍修复因为数值变化需要重置购买过VIP礼包的数据
gm_reset_fetch_reward() ->
    Sql = <<"select id from role_vip where fetched_list != '[]'">>,
    DbList = db:get_all(Sql),
    case DbList of
        [] -> skip;
        _ ->
            RoleIdL = [RoleId || [RoleId] <- DbList],
            Title1 = utext:get(4500001),
            Content1 = utext:get(4500002),
            mod_mail_queue:add(?MOD_VIP, RoleIdL, Title1, Content1, []),
            UpdateSql = <<"update role_vip set fetched_list = '[]'">>,
            db:execute(UpdateSql)
    end.
