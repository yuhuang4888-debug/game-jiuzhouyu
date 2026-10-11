%%%--------------------------------------
%%% @Module  : lib_resource_back
%%% @Author  : liuxl 
%%% @Created : 2017-04-06
%%% @Description:  资源召回
%%%--------------------------------------
-module(lib_resource_back).
-compile(export_all).

-include("server.hrl").
-include("figure.hrl").
-include("errcode.hrl").
-include("vip.hrl").
-include("common.hrl").
-include("def_module.hrl").
-include("def_daily.hrl").
-include("resource_back.hrl").
-include("def_fun.hrl").
-include("daily.hrl").
-include("activitycalen.hrl").
%-include("vip.hrl").
-include("goods.hrl").
-include("def_event.hrl").
-include("rec_event.hrl").
-include("predefine.hrl").
-include("dungeon.hrl").
-include("guild.hrl").

-export([
    login/1
    , handle_event/2
    , resource_back/6
    , repair_max_vip_buy_times/1
]).

%% 事件处理
handle_event(PS,
    #event_callback{
        type_id = ?EVENT_PARTICIPATE_ACT,
        data    = #act_data{act_id = ActId, act_sub = ActSub, num = Num}}) ->
    #player_status{figure = #figure{lv = Lv}} = PS,
    case lib_module:is_open(?MOD_RESOURCE_BACK, 1, Lv) of
        true ->
            increase_ps_act_status(PS, {ActId, ActSub, Num});
        false -> {ok, PS}
    end;

%%  Vip升级，导致最大次数变化
handle_event(PS,
    #event_callback{
        type_id = ?EVENT_VIP}) ->
    ?DEBUG("event EVENT_VIP ~n", []),
    #player_status{figure = #figure{lv = Lv}} = PS,
    case lib_module:is_open(?MOD_RESOURCE_BACK, 1, Lv) of
        true ->
            NewPS =  vip_up_ps_act_status(PS);
        false ->
            NewPS = PS
    end,
    {ok, NewPS};
%%  Vip过期，导致资源找回最大次数变化
handle_event(PS,
    #event_callback{
        type_id = ?EVENT_VIP_TIME_OUT}) ->
    #player_status{figure = #figure{lv = Lv}} = PS,
    case lib_module:is_open(?MOD_RESOURCE_BACK, 1, Lv) of
        true ->
            NewPS =  vip_up_ps_act_status(PS);
        false ->
            NewPS = PS
    end,
    {ok, NewPS};

%%  Vip特权卡，导致资源找回最大次数变化
handle_event(PS,
    #event_callback{
        type_id = ?EVENT_BUY_VIP}) ->
%%    ?DEBUG("event EVENT_BUY_VIP ~n", []),
    #player_status{figure = #figure{lv = Lv}} = PS,
    case lib_module:is_open(?MOD_RESOURCE_BACK, 1, Lv) of
        true ->
            NewPS =  vip_up_ps_act_status(PS);
        false ->
            NewPS = PS
    end,
    {ok, NewPS};
handle_event(PS, #event_callback{type_id = ?EVENT_LV_UP}) ->
    #player_status{figure = #figure{lv = Lv}} = PS,
    OpenLv = lib_module:get_open_lv(?MOD_RESOURCE_BACK, 1),
    if
        Lv < OpenLv -> {ok, PS};
        true ->
            NewPS = login(PS),
            lib_player_event:remove_listener(?EVENT_LV_UP, lib_resource_back, handle_event),
            {ok, NewPS}
    end;
handle_event(PS, _) ->
    {ok, PS}.


increase_ps_act_status(PS, {ActId, ActSub, Num}) ->
    %?%PRINT("handle event ~p~n", [{ActId, Num}]),
    ActIds = data_resource_back:get_act_ids(),
    case lists:member({ActId, ActSub}, ActIds) of
        true -> increase_ps_act_status_do(PS, {ActId, ActSub, Num});
        false -> {ok, PS}
    end.
%% -----------------------------------------------------------------
%% @desc     功能描述  因为vip的升级导致次数的变化
%% @param    参数      PS::#player_status{}
%% @return   返回值    LastPs
%% @history  修改历史
%% -----------------------------------------------------------------
vip_up_ps_act_status(PS) ->
    ActIds = data_resource_back:get_act_ids(),
    #player_status{resource_back =  ResBack} =  PS,
    #resource_back{res_act_map =  ResActMap} =  ResBack,
    Today = maps:get(?TODAY, ResActMap, #{}),  %%当天的资源找回
    F =  fun({TempActId, TempSub}, AccToday) ->
        NewAccToday  =
        case maps:get({TempActId, TempSub}, AccToday, none) of
            #res_act{state = State, lefttimes = LeftTimes, max_vip_fixation_times = OldMaxVipFixationTimes, max_vip_buy_time = OldMaxVipBuyTimes} = ResAct  when State == ?STATE_NOT_FIND ->
                MaxVipBuyTimes       = get_only_vip_times(TempActId, TempSub, PS),
                MaxVipFixationTimes  = get_act_limit(TempActId, TempSub, PS#player_status.vip),
                NewLeftTimes         = MaxVipBuyTimes + MaxVipFixationTimes - (OldMaxVipBuyTimes + OldMaxVipFixationTimes - LeftTimes),  %%(新总次数 - 今天参与次数)
%%                ?MYLOG("cym", "TempActId ~p TempSub ~p MaxVipBuyTimes ~p MaxVipFixationTimes  ~p~n", [TempActId, TempSub, MaxVipBuyTimes, MaxVipFixationTimes]),
                NewResAct            = ResAct#res_act{max_vip_buy_time = MaxVipBuyTimes, max_vip_fixation_times = MaxVipFixationTimes, lefttimes = NewLeftTimes,
                    max = get_act_limit_with_vip(TempSub, TempSub, PS)},
                maps:put({TempActId, TempSub}, NewResAct, AccToday);
            #res_act{} = _ResAct ->
%%                ?MYLOG("cym", "ResActs  ~p~n", [ResAct]),
                AccToday;
            none ->
%%                ?MYLOG("cym", "TempActId ~p, TempSub ~p  AccToday ~p  ~n", [TempActId, TempSub, AccToday]),
                AccToday
        end,
        NewAccToday
%%            TempCount   = get_act_limit_with_vip(TempActId, TempActId, PS) - OldMaxCount,  %%vip改变后增加的找回次数
%%           {ok, NewPs}  = vip_up_ps_act_status_do(OldPs,{TempActId, TempSub, TempCount}),
%%            NewPs
        end,
    NewToday   = lists:foldl(F, Today, ActIds),
%%    ?MYLOG("cym", "NewToday ~p ~n", [NewToday]),
    NewResActMap = maps:put(?TODAY, NewToday, ResActMap),
    NewResBack   = ResBack#resource_back{res_act_map = NewResActMap},
    db_update_resource_back(PS#player_status.id, NewResBack),
    PS#player_status{resource_back = NewResBack}.

%% -----------------------------------------------------------------
%% @desc     功能描述   vip变更，导致找回次数变更
%% @param    参数       Count::integer   变更后，所增加的次数
%% @return   返回值     {ok, NewPS}
%% @history  修改历史
%% -----------------------------------------------------------------
vip_up_ps_act_status_do(PS,{ActId, ActSub, Count}) ->
    #player_status{id = RoleId, resource_back = ResourceBack} = PS,
    #resource_back{res_act_map = ResActMap} = ResourceBack,
    {NeedUpdateDb, NewResActMap} = vip_add_today_res_act(PS, ResActMap, {ActId, ActSub, Count}),
    NewResourceBack = ResourceBack#resource_back{res_act_map = NewResActMap},
    case NeedUpdateDb of
        true -> db_update_resource_back(RoleId, NewResourceBack);
        false -> skip
    end,
    NewPS = PS#player_status{resource_back = NewResourceBack},
    {ok, NewPS}.

increase_ps_act_status_do(PS, {ActId, ActSub, Num}) ->
    #player_status{id = RoleId, resource_back = ResourceBack} = PS,
    #resource_back{res_act_map = ResActMap} = ResourceBack,
    {NeedUpdateDb, NewResActMap} = update_today_res_act(PS, ResActMap, {ActId, ActSub, Num}),
    NewResourceBack = ResourceBack#resource_back{res_act_map = NewResActMap},
    case NeedUpdateDb of
        true -> db_update_resource_back(RoleId, NewResourceBack);
        false -> skip
    end,
    NewPS = PS#player_status{resource_back = NewResourceBack},
    {ok, NewPS}.




update_today_res_act(_PS, ResActMap, {ActId, ActSub, Num}) ->
    Today = maps:get(?TODAY, ResActMap, #{}),
    MaxVipBuyTimes = get_only_vip_times(ActId, ActSub, _PS),
    case maps:get({ActId, ActSub}, Today, none) of
        #res_act{lefttimes = LeftTimes, state = State} = ResAct when State == ?STATE_NOT_FIND ->
            NewLeftTime = max(LeftTimes - Num, 0),
            NewState = ?IF(NewLeftTime == 0, ?STATE_FINISHED, ?STATE_NOT_FIND),
            NewResAct = ResAct#res_act{lefttimes = NewLeftTime, state = NewState, max_vip_buy_time = MaxVipBuyTimes},
            NewToday = maps:put({ActId, ActSub}, NewResAct, Today),
            {true, maps:put(?TODAY, NewToday, ResActMap)};
        #res_act{} -> {false, ResActMap};
        none ->
            Limit = get_act_limit_with_vip(ActId, ActSub, _PS),   %%最大参与次数  改为受vip影响
            LeftTimes = max(Limit - Num, 0),
            State = ?IF(LeftTimes == 0, ?STATE_FINISHED, ?STATE_NOT_FIND),
            ResAct = #res_act{act_id = ActId, act_sub = ActSub, lefttimes = LeftTimes, max = Limit, state = State,
                max_vip_buy_time = MaxVipBuyTimes, max_vip_fixation_times = get_act_limit(ActId, ActSub, _PS#player_status.vip)},
            NewToday = maps:put({ActId, ActSub}, ResAct, Today),
            {true, maps:put(?TODAY, NewToday, ResActMap)}
    end.
%% -----------------------------------------------------------------
%% @desc     功能描述   增加找回次数，增加找回次数上限
%% @param    参数      PS::#player_status{},
%%                     ResActMap::map  资源找回map
%%                     ActId::integer   活动id,
%%                     ActSub::integer  活动子类型
%%                     Count::integer  增加找回次数
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
vip_add_today_res_act(PS, ResActMap, {ActId, ActSub, Count}) ->
    Today = maps:get(?TODAY, ResActMap, #{}),
    case maps:get({ActId, ActSub}, Today, none) of
        #res_act{lefttimes = LeftTimes, state = State, max = OldMaxCount} = ResAct when State == ?STATE_NOT_FIND ->
            NewLeftTime =max(LeftTimes + Count, 0),   %%剩余次数  +  vip增加次数 ，有可能是负数，vip过期了
            NewState = ?IF(NewLeftTime == 0, ?STATE_FINISHED, ?STATE_NOT_FIND),
            MaxCount  = OldMaxCount +  Count,  %%旧的最大值 + 增加的次数
%%            ?DEBUG("oldCount:~p, NewMaxCount  ~p~n", [OldMaxCount, MaxCount]),
            NewResAct = ResAct#res_act{lefttimes = NewLeftTime, state = NewState, max =  MaxCount},
            NewToday = maps:put({ActId, ActSub}, NewResAct, Today),
            {true, maps:put(?TODAY, NewToday, ResActMap)};
        #res_act{} -> {false, ResActMap};
        none ->
            Limit = get_act_limit_with_vip(ActId, ActSub, PS),   %%最大参与次数  改为受vip影响
            LeftTimes =  Limit,
            State = ?IF(LeftTimes == 0, ?STATE_FINISHED, ?STATE_NOT_FIND),
            ResAct = #res_act{act_id = ActId, act_sub = ActSub, lefttimes = LeftTimes, max = Limit, state = State},
            NewToday = maps:put({ActId, ActSub}, ResAct, Today),
            {true, maps:put(?TODAY, NewToday, ResActMap)}
    end.

%%---------------------------------- 登陆 ------------------------------------
login(PS) ->
    NowTime = utime:unixtime(),
    #player_status{id = RoleId, figure = #figure{lv = Lv}} = PS,
    case lib_module:is_open(?MOD_RESOURCE_BACK, 1, Lv) of
        true ->
            ActIds = data_resource_back:get_act_ids(),
            {OldClearTime, ResActMap}
                = case db_select_res_act_list(RoleId) of
                      [] ->
                          Today = init_today_res_act(PS, ActIds),
                          {get_today_clear_time(), maps:put(?TODAY, Today, #{})};
                      List ->
                          F = fun(Item, {_Time, Map}) ->
                              [ClearTime1, DayType, ActList_B] = Item,
                              ActList = util:bitstring_to_term(ActList_B),
                              ResActMap = make_res_act_map(DayType, PS, ActIds, ActList),
                              {ClearTime1, maps:put(DayType, ResActMap, Map)}
                              end,
                          lists:foldl(F, {NowTime, #{}}, List)
                  end,
            ResourceBack = update_res_act_login(PS, ResActMap, OldClearTime, NowTime),
            NewPS = PS#player_status{resource_back = ResourceBack},
            db_update_resource_back(RoleId, ResourceBack),
            NewPS;
        false ->
            lib_player_event:add_listener(?EVENT_LV_UP, lib_resource_back, handle_event, []),
            PS#player_status{resource_back = #resource_back{}}
    end.

update_res_act_login(PS, ResActMap, OldClearTime, NowTime) ->
    case NowTime - OldClearTime of
        DTime when DTime =< 1 -> #resource_back{cleartime = OldClearTime, res_act_map = ResActMap};
        DTime ->   %%过期了
            NewResActMap = move_res_act_list(PS, DTime, ResActMap),
            NewClearTime = get_today_clear_time(),
            #resource_back{cleartime = NewClearTime, res_act_map = NewResActMap}
    end.


move_res_act_list(PS, DTime, ResActMap) ->
    MoveTimes = 1 + (DTime div ?ONE_DAY_SECONDS),
    %?PRINT("move_res_act_list MoveTimes ~p~n", [MoveTimes]),
    ActIds = data_resource_back:get_act_ids(),
    if
        MoveTimes == 1 -> move_res_act_list_1(PS, ActIds, ResActMap);
        MoveTimes == 2 -> move_res_act_list_2(PS, ActIds, ResActMap);
        true -> move_res_act_list_more(PS, ActIds, ResActMap)
    end.

%% 登陆离上次离线跨一天
move_res_act_list_1(PS, ActIds, ResActMap) ->
    Yesterday = maps:get(?YESTERDAY, ResActMap, #{}),
    F = fun(_K, V) -> V#res_act.state == ?STATE_NOT_FIND end,
    BYesterday = maps:filter(F, Yesterday),
    Today = maps:get(?TODAY, ResActMap, #{}),
    %PreWeekDay = get_pre_weekday(),
    Today1 = correct_logout_act(PS, Today, ActIds, yesterday),
    Today2 = correct_limit_act_with_vip(PS, Today1, ActIds, yesterday),
%%    ?MYLOG("cym", "Today1 ~p~n", [Today2]),
    NewYesterday = maps:filter(F, Today2),
    NewToday = init_today_res_act(PS, ActIds),
%%    ?MYLOG("cym", "NewToday ~p~n", [NewToday]),
    ResActMap2 = maps:put(?TODAY, NewToday, #{}),
    ResActMap3 = maps:put(?YESTERDAY, NewYesterday, ResActMap2),
    maps:put(?B_YESTERDAY, BYesterday, ResActMap3).

%% 登陆离上次离线跨两天
move_res_act_list_2(PS, ActIds, ResActMap) ->
    F = fun(_K, V) -> V#res_act.state == ?STATE_NOT_FIND end,
    Today = maps:get(?TODAY, ResActMap, #{}),
    %PrePreWeekDay = get_pre_pre_weekday(),
    Today1 = correct_logout_act(PS, Today, ActIds, byesterday),
    Today2 = correct_limit_act_with_vip(PS, Today1, ActIds, byesterday),
    BYesterday = maps:filter(F, Today2),
    NewToday = init_today_res_act(PS, ActIds),
    ResActMap2 = maps:put(?TODAY, NewToday, #{}),
    Yesterday = init_res_act_yesterday(PS, ActIds),
    ResActMap3 = maps:put(?YESTERDAY, Yesterday, ResActMap2),
    maps:put(?B_YESTERDAY, BYesterday, ResActMap3).

%% 登陆离上次离线跨两天以上
move_res_act_list_more(PS, ActIds, _ResActMap) ->
    Today = init_today_res_act(PS, ActIds),
    ResActMap2 = maps:put(?TODAY, Today, #{}),
    Yesterday = init_res_act_yesterday(PS, ActIds),
    ResActMap3 = maps:put(?YESTERDAY, Yesterday, ResActMap2),
    BYesterday = init_res_act_b_yesterday(PS, ActIds),
    maps:put(?B_YESTERDAY, BYesterday, ResActMap3).

%%----------------------------------- 资源找回 ---------------------------------------
resource_back(PS, Id, ActSub, Type, Times, Times_Others) ->
    %CostType = ?IF(Type == ?TYPE_COIN, ?TYPE_COIN, ?TYPE_GOLD),
    case check_resource_back(PS, Id, ActSub, Type, Times, Times_Others) of
        {true, RewardLv, Reward, Cost, YResAct, BYResAct} ->
%%            ?MYLOG("cym", "Cost ~p Times ~p~n", [Cost, Times]),
            resource_back_do(PS, Type, Id, ActSub, RewardLv, Reward, Cost, Times + Times_Others, YResAct, BYResAct);
        {false, Res} ->
%%            ?MYLOG("cym", "Res ~p~n", [Res]),
            {false, Res, PS}
    end.

resource_back_onekey(PS, Type) ->
    ComListAct = get_common_times(PS),
    #player_status{vip = Vip, resource_back = #resource_back{res_act_map = ResActMap}} = PS,
    VipList = count_vip_times(ComListAct, Vip, ResActMap, []),
    NewComListAct = [{Id, ActSub, NewLeftTimes, RewardLv} ||{Id, ActSub, NewLeftTimes, _, RewardLv} <- VipList],
    ?PRINT("list~n~n~n ~p ~n~n~n", [NewComListAct]),
    {CheckResList, AllCost} = resource_back_onekey_helper(PS, Type, NewComListAct, [], []),
    if
        AllCost == [] -> {false, ?FAIL, PS};
        Type == 2 -> resource_back_do_onekey(PS, Type, CheckResList, []);
        true ->
            case lib_goods_api:check_object_list(PS, AllCost) of
                true ->
                    resource_back_do_onekey(PS, Type, CheckResList, []);
                {false, ErrorCode} ->
                    {false, ErrorCode, PS}
            end
    end.

%%@return{[{Id, ActSub,Times, RewardLv, Reward, Cost, YResAct, BYResAct}|_], Cost}
resource_back_onekey_helper(_PS, _Type, [], CheckResList, AllCost) -> {CheckResList, AllCost};
resource_back_onekey_helper(PS, Type, [{Id, ActSub, Times, RewardLv} | OtherAct], CheckResList, AllCost) ->
    case check_resource_back(PS, Id, ActSub, Type, Times, 0) of %% vip额外次数0即可
        {true, RewardLv, Reward, Cost, YResAct, BYResAct} ->
            ?MYLOG("cym", "Cost ~p Times ~p~n", [Cost, Times]),
            ResItem = [{Id, ActSub,Times, RewardLv, Reward, Cost, YResAct, BYResAct}],
            resource_back_onekey_helper(PS, Type, OtherAct, ResItem ++ CheckResList, Cost ++ AllCost);
        {false, Res} ->
            ?MYLOG("cym", "Res ~p~n", [Res]),
            resource_back_onekey_helper(PS, Type, OtherAct, CheckResList, AllCost)
    end.

resource_back_do(PS, Type, Id, ActSub, RewardLv, Reward, Cost, Times, YResAct, BYResAct) ->
    #player_status{id = RoleId, sid = Sid, resource_back = ResourceBack, vip = Vip} = PS,
    case cost_object_list_with_check(Type, PS, Cost, resource_back, "") of
        {true, NewPS} ->
            %?PRINT("resource_back succ Reward:~p~n", [Reward]),
            Produce = #produce{title = utext:get(255), content = utext:get(256), reward = Reward, type = resource_back, show_tips = 1},
            {ok, NewPS1} = lib_goods_api:send_reward_with_mail(NewPS, Produce),
            {NewResourceBack, LeftTimes} = resource_back_do_core(ResourceBack, Id, ActSub, Times, YResAct, BYResAct),
            %% 日志
            lib_log_api:log_resource_back(RoleId, Id, ActSub, Cost, Times, LeftTimes, Reward),
            db_update_resource_back(RoleId, NewResourceBack),
	          #resource_back{res_act_map = Map} = NewResourceBack,
	          [{NewId, NewActSub, NewLeftTimes, VipTimes, NewRewardLv}] = count_vip_times([{Id, ActSub, LeftTimes, RewardLv}],  Vip, Map, []),
	          ?DEBUG("~p~n", [{NewId, NewActSub, NewLeftTimes, VipTimes, NewRewardLv}]),
            lib_server_send:send_to_sid(Sid, pt_419, 41903, [?SUCCESS, Type, NewId, NewActSub, NewLeftTimes, VipTimes, NewRewardLv]),
            {true, NewPS1#player_status{resource_back = NewResourceBack}};
        {false, Res, NewPS} -> {false, Res, NewPS}
    end.

resource_back_do_onekey(PS, _Type, [], []) -> {false, ?FAIL, PS};
resource_back_do_onekey(PS, Type, [], SendList) ->
    {ok, BinData} = pt_419:write(41904, [?SUCCESS, Type, SendList]),
    lib_server_send:send_to_sid(PS#player_status.sid, BinData),
    {true, PS};
resource_back_do_onekey(PS, Type, [{Id, ActSub, Times, RewardLv, Reward, Cost, YResAct, BYResAct}|OtherAct], SendList) ->
    #player_status{id = RoleId, resource_back = ResourceBack, vip = Vip} = PS,
    case cost_object_list_with_check(Type, PS, Cost, resource_back, "") of
        {true, NewPS} ->
            %?PRINT("resource_back succ Reward:~p~n", [Reward]),
            Produce = #produce{title = utext:get(255), content = utext:get(256), reward = Reward, type = resource_back, show_tips = 1},
            {ok, NewPS1} = lib_goods_api:send_reward_with_mail(NewPS, Produce),
            {NewResourceBack, LeftTimes} = resource_back_do_core(ResourceBack, Id, ActSub, Times, YResAct, BYResAct),
            %% 日志
            lib_log_api:log_resource_back(RoleId, Id, ActSub, Cost, Times, LeftTimes, Reward),
            db_update_resource_back(RoleId, NewResourceBack),
            #resource_back{res_act_map = Map} = NewResourceBack,
            %% SendItem = [{NewId, NewActSub, NewLeftTimes, VipTimes, NewRewardLv}]
            SendItem = count_vip_times([{Id, ActSub, LeftTimes, RewardLv}],  Vip, Map, []),
            resource_back_do_onekey(NewPS1#player_status{resource_back = NewResourceBack}, Type, OtherAct, SendItem ++ SendList);
        {false, Res, NewPS} -> {false, Res, NewPS}
    end.

resource_back_do_core(ResourceBack, Id, ActSub, Times, YResAct, BYResAct) ->
    #resource_back{res_act_map = ResActMap} = ResourceBack,
    Yesterday = maps:get(?YESTERDAY, ResActMap, #{}),
    BYesterday = maps:get(?B_YESTERDAY, ResActMap, #{}),
    if
        is_record(BYResAct, res_act) == false ->
            NewLeftTime = YResAct#res_act.lefttimes - Times,
            NewState = ?IF(NewLeftTime == 0, ?STATE_FIND, ?STATE_NOT_FIND),
            NewYResAct = YResAct#res_act{lefttimes = NewLeftTime, state = NewState},
            NewYesterday = maps:put({Id, ActSub}, NewYResAct, Yesterday),
            NewResActMap = maps:put(?YESTERDAY, NewYesterday, ResActMap),
            ?MYLOG("cym", "NewYesterday ~p~n  YResAct ~p Times ~p~n", [NewYesterday,YResAct, Times]),
            {ResourceBack#resource_back{res_act_map = NewResActMap}, NewLeftTime};
        is_record(YResAct, res_act) == false ->
            NewLeftTime = BYResAct#res_act.lefttimes - Times,
            NewState = ?IF(NewLeftTime == 0, ?STATE_FIND, ?STATE_NOT_FIND),
            NewBYResAct = BYResAct#res_act{lefttimes = NewLeftTime, state = NewState},
            NewBYesterday = maps:put({Id, ActSub}, NewBYResAct, BYesterday),
            NewResActMap = maps:put(?B_YESTERDAY, NewBYesterday, ResActMap),
            {ResourceBack#resource_back{res_act_map = NewResActMap}, NewLeftTime};
        true ->
            LeftTimesY = YResAct#res_act.lefttimes,
            LeftTimesBY = BYResAct#res_act.lefttimes,
            {NewLeftTimesBY, NewLeftTimesY} = ?IF((LeftTimesBY - Times) >= 0, {LeftTimesBY - Times, LeftTimesY}, {0, LeftTimesY + LeftTimesBY - Times}),
            NewStateBY = ?IF(NewLeftTimesBY == 0, ?STATE_FIND, ?STATE_NOT_FIND),
            NewStateY = ?IF(NewLeftTimesY == 0, ?STATE_FIND, ?STATE_NOT_FIND),
            NewYResAct = YResAct#res_act{lefttimes = NewLeftTimesY, state = NewStateY},
            NewBYResAct = BYResAct#res_act{lefttimes = NewLeftTimesBY, state = NewStateBY},
            NewYesterday = maps:put({Id, ActSub}, NewYResAct, Yesterday),
            NewBYesterday = maps:put({Id, ActSub}, NewBYResAct, BYesterday),
            ResActMap1 = maps:put(?YESTERDAY, NewYesterday, ResActMap),
            NewResActMap = maps:put(?B_YESTERDAY, NewBYesterday, ResActMap1),
            {ResourceBack#resource_back{res_act_map = NewResActMap}, NewLeftTimesBY + NewLeftTimesY}
    end.

%%---------------------------------- 凌晨4点刷新 ---------------------------------
refresh(_DelaySec) ->
    util:rand_time_to_delay(1000, lib_resource_back, refresh, []).

refresh() ->
    RefreshList = ets:tab2list(?ETS_ONLINE),
    [refresh_res_act_status(OnlineRole#ets_online.id) || OnlineRole <- RefreshList].

refresh_res_act_status(PlayerId) ->
    lib_player:apply_cast(PlayerId, ?APPLY_CAST_SAVE, lib_resource_back, refresh_4_clock_res_act, []).
%%改为 4点刷新
refresh_4_clock_res_act(PS) ->
    #player_status{id = RoleId, figure = #figure{lv = Lv}, resource_back = ResourceBack} = PS,
    case lib_module:is_open(?MOD_RESOURCE_BACK, 1, Lv) of
        true ->
            ActIds = data_resource_back:get_act_ids(),
            NewResourceBack = update_res_act_4_clock(PS, ActIds, ResourceBack),
            db_update_resource_back(RoleId, NewResourceBack),
            NewPS = PS#player_status{resource_back = NewResourceBack},
            report_res_act(NewPS),
            {ok, NewPS};
        false -> {ok, PS}
    end.

update_res_act_4_clock(PS, ActIds, ResourceBack) ->
    %?PRINT("update 3 clock ResourceBack: ~p ~n", [ResourceBack]),
    ClearTime = get_today_clear_time(),
    F = fun(_K, V) -> V#res_act.state == ?STATE_NOT_FIND end,
    #resource_back{res_act_map = ResActMap} = ResourceBack,
    OldYesterday = maps:get(?YESTERDAY, ResActMap, #{}),
    BYesterday = maps:filter(F, OldYesterday),
    Today  = maps:get(?TODAY, ResActMap, #{}),
    Today1 = correct_logout_act(PS, Today, ActIds, yesterday),
    Today2 = correct_limit_act_with_vip(PS, Today1, ActIds, yesterday),
    NewYesterday = maps:filter(F, Today2),
    NewToday = init_today_res_act(PS, ActIds),
    ResActMap2 = maps:put(?TODAY, NewToday, #{}),
    ResActMap3 = maps:put(?YESTERDAY, NewYesterday, ResActMap2),
    ResActMap4 = maps:put(?B_YESTERDAY, BYesterday, ResActMap3),
    #resource_back{cleartime = ClearTime, res_act_map = ResActMap4}.

%% --------------------------------------- other ------------------------------------

init_today_res_act(PS, ActIds) ->
    %WeekDay = get_today_weekday(),
    FilterActIds = filter_unopen_act(PS, ActIds, today),
    %?DEBUG("ActIds ~p ~n FilterActIds ~p ~n", [ActIds, FilterActIds]),
    F = fun({Id, ActSub}, Map) ->
        Limit = get_act_limit_with_vip(Id, ActSub, PS),  %%初始化当前的最大次数, 受vip特权值影响
        case Limit == 0 of
            true -> Map;
            _ ->
                ResAct = get_init_res_act(Id, ActSub, PS),
                maps:put({Id, ActSub}, ResAct, Map)
        end
        end,
    lists:foldl(F, #{}, FilterActIds).

init_res_act_yesterday(PS, ActIds) ->
    FilterActIds = filter_unopen_act(PS, ActIds, yesterday),
    F = fun({Id, ActSub}, Map) ->
        Limit = get_act_limit_with_vip(Id, ActSub, PS),  %%初始化昨天最大次数
        case Limit == 0 of
            true -> Map;
            _ ->
                MaxVipBuyTimes = get_only_vip_times(Id, ActSub, PS),
                ResAct = #res_act{act_id = Id, act_sub = ActSub, lefttimes = Limit, max = Limit,
                    state = ?STATE_NOT_FIND, max_vip_buy_time = MaxVipBuyTimes, max_vip_fixation_times = get_act_limit(Id, ActSub, PS#player_status.vip)},
                maps:put({Id, ActSub}, ResAct, Map)
        end
        end,
    lists:foldl(F, #{}, FilterActIds).

init_res_act_b_yesterday(PS, ActIds) ->
    FilterActIds = filter_unopen_act(PS, ActIds, byesterday),
    F = fun({Id, ActSub}, Map) ->
        Limit = get_act_limit_with_vip(Id, ActSub, PS),  %%初始化前天的最大参与次数,受vip特权值影响
        case Limit == 0 of
            true -> Map;
            _ ->
                MaxVipBuyTimes = get_only_vip_times(Id, ActSub, PS),
                ResAct = #res_act{act_id = Id, act_sub = ActSub, lefttimes = Limit, max = Limit,
                    state = ?STATE_NOT_FIND, max_vip_buy_time = MaxVipBuyTimes, max_vip_fixation_times = get_act_limit(Id, ActSub, PS#player_status.vip)},
                maps:put({Id, ActSub}, ResAct, Map)
        end
        end,
    lists:foldl(F, #{}, FilterActIds).

%% 纠正奖励找回(由于下线没有补充数据)：
%% 例如：下线当天由20级升到30级，这个等级段新开了3个活动，然后下线，再次上线后，要将这个等级段的活动补充进record里面
correct_logout_act(PS, Today, ActIds, WeekDay) ->
    FilterActIds = filter_unopen_act(PS, ActIds, WeekDay),
    %%?PRINT("correct_logout_act FilterActIds ~p ~n", [{WeekDay, FilterActIds}]),
    F = fun({ActId, ActSub}, Map2) ->
        case maps:get({ActId, ActSub}, Map2, none) of
            #res_act{} -> Map2;
            _ ->
                ResAct = get_init_res_act(ActId, ActSub, PS),
                maps:put({ActId, ActSub}, ResAct, Map2)
%%                Limit = get_act_limit_with_vip(ActId, ActSub, PS),     %%受vip特权值影响最大次数
%%                case Limit == 0 of
%%                    true -> Map2;
%%                    _ ->
%%                        ResAct = #res_act{act_id = ActId, act_sub = ActSub, lefttimes = Limit, max = Limit, state = ?STATE_NOT_FIND},
%%                        maps:put({ActId, ActSub}, ResAct, Map2)
%%                end
        end
        end,
    lists:foldl(F, Today, FilterActIds).


correct_limit_act_with_vip(PS, Today, ActIds, WeekDay) ->
    FilterActIds = filter_unopen_act(PS, ActIds, WeekDay),
    F = fun({ActId, ActSub}, Map2) ->
        case maps:get({ActId, ActSub}, Map2, none) of
            #res_act{lefttimes = LeftTimes, vip_buy_time = BuyTimes, max_vip_buy_time = MaxVipBuyTimes, max_vip_fixation_times = MaxVipFixationTimes} = ResAct->
                %%跨天的时候，重算剩余次数
                LeftVipTimes = MaxVipBuyTimes - BuyTimes,  %%vip次数 - 购买vip次数  = 剩余vip次数
                %%min(总次数 - vip剩余次数， 普通次数最大值)  目的，不让购买的vip次数留到普通次数里
                CommTimes    = min(LeftTimes - LeftVipTimes,  MaxVipFixationTimes),
                ResAct1      = ResAct#res_act{lefttimes = LeftVipTimes + CommTimes},
                maps:put({ActId, ActSub}, ResAct1, Map2);
            _ ->
                Limit = get_act_limit_with_vip(ActId, ActSub, PS),     %%受vip特权值影响最大次数
                case Limit == 0 of
                    true -> Map2;
                    _ ->
                        ResAct = #res_act{act_id = ActId, act_sub = ActSub, lefttimes = Limit,
                            max = Limit, state = ?STATE_NOT_FIND, vip_buy_time = get_only_vip_times(ActId, ActSub, PS),
                            max_vip_fixation_times = get_act_limit(ActId, ActSub, PS#player_status.vip)},
                        maps:put({ActId, ActSub}, ResAct, Map2)
                end
        end
    end,
    lists:foldl(F, Today, FilterActIds).

%% 过滤今天没开启或者等级不足的活动的活动
 filter_unopen_act(#player_status{tid = Tid} = PS, ActIds, WeekDay) ->
    #player_status{id = RoleId, figure = #figure{lv = Lv, guild_id = GuildId}} = PS,
    Now = utime:unixtime(),
    DataTime = case WeekDay of
                   today ->
                       utime:unixtime_to_localtime(Now);
                   yesterday ->
                       utime:unixtime_to_localtime(Now - ?ONE_DAY_SECONDS);
                   byesterday ->
                       utime:unixtime_to_localtime(Now - 2 * ?ONE_DAY_SECONDS);
                   _ ->
                       utime:unixtime_to_localtime(Now)
               end,
    %?PRINT("filter_unopen_act DataTime ~p ~n", [ActIds]),
    F = fun({Id, AcSub}, List) ->
        case lib_activitycalen_api:check_ac_start(PS, Id, AcSub, DataTime) of
            true ->
                RewardLv = get_reward_lv(RoleId, Id, AcSub, Lv),
                TaskOpen = is_task_open(Id, AcSub, Tid, RewardLv),
                GuildLim = get_guild_limit(GuildId, Id, AcSub, RewardLv),
                %?DEBUG("~p, ~p,~p,~p~n", [Id, AcSub, RewardLv, GuildLim]),
                case RewardLv =:= 0 orelse GuildLim =:= false  orelse TaskOpen == false of
                    true -> List;
                    false -> [{Id, AcSub} | List]
                end;
            false -> List
        end
        end,
    lists:foldl(F, [], ActIds).

%% 获取活动的参与次数 活动参与次数
get_act_limit(ActId, ActSub, Vip) ->
    LvList = data_resource_back:get_reward_lv_list(ActId, ActSub),
    #role_vip{vip_type = VipCard, vip_lv =  VipLv} = Vip,
    case   LvList of
        [Lv | _] ->
            case data_resource_back:get_res_cfg(ActId,  ActSub,  Lv)  of
                #base_res_act{fixation_count = FixationCount, fixation_vip_type = VipType} ->
                    if
                        FixationCount =/= 0 -> %%固定次数不等于0则用固定次数，为0则用vip的特权值
                            FixationCount;
                        true ->
                            VipCount = lib_vip_api:get_vip_privilege(ActId, VipType, VipCard, VipLv),
                            VipCount
                    end;
                _ ->
                    0
            end;
        _ ->
            0
    end.
%%    case data_activitycalen:get_live_config(ActId, ActSub) of
%%        #ac_liveness{res_max = Max} -> Max;
%%        _ ->
%%            Max = 0
%%%%    end,
%%    Max.
%% -----------------------------------------------------------------
%% @desc     功能描述  获取活动的参与次数 + 购买次数
%% @param    参数      ActId::integer 功能id
%%                     ActSub::integer  子类型
%%                     Vip::#role_vip{}
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
get_act_limit_with_vip(ActId, ActSub, #player_status{id = RoleId,
	vip = #role_vip{vip_type = VipCard, vip_lv =  VipLv},
	figure = #figure{lv = Lv}} = _Ps ) ->
	VipType =
		case data_resource_back:get_res_cfg(ActId, ActSub, get_reward_lv(RoleId, ActId, ActSub, Lv))  of
			[] ->
				-1;
			#base_res_act{vip_type =  TempValue} ->
				TempValue
		end,
    VipCount = lib_vip_api:get_vip_privilege(ActId, VipType, VipCard, VipLv),
%%    ?MYLOG("cym", "ActId ~p ActSub ~p~n", [ActId, ActSub]),
    Max      = get_act_limit(ActId, ActSub, #role_vip{vip_type = VipCard, vip_lv =  VipLv}),
    VipCount + Max.

%%仅仅是vip购买次数
get_only_vip_times(ActId, ActSub, #player_status{id = RoleId,
    vip = #role_vip{vip_type = VipCard, vip_lv =  VipLv},
    figure = #figure{lv = Lv}} = _Ps ) ->
    VipType =
        case data_resource_back:get_res_cfg(ActId, ActSub, get_reward_lv(RoleId, ActId, ActSub, Lv))  of
            [] ->
                -1;
            #base_res_act{vip_type =  TempValue} ->
                TempValue
        end,
    lib_vip_api:get_vip_privilege(ActId, VipType, VipCard, VipLv).

rectify_max_num(ActId, _ActSub, Max, Num) ->
    case ActId of
        %% ?MOD_HUNTING -> {1, Num};
        %% ?MOD_HERO_WAR -> {1, Num};
        _ -> {Max, Num}
    end.


%% 现在改为用24点来作为清除时间
get_today_clear_time() ->
%%    {_, {H, _, _}} = calendar:local_time(),
%%%%    NowTime = utime:unixtime(),
%%%%    ZeroTime = utime:unixdate(NowTime) + ?ONE_DAY_SECONDS,
%%%%    ZeroTime.
%%    FourClock = ZeroTime + 4 * 3600,
%%    case H < 4 of
%%        true -> FourClock;
%%        false -> FourClock + ?ONE_DAY_SECONDS
%%    end.
    {_, {H, _, _}} = calendar:local_time(),
    NowTime = utime:unixtime(),
    ZeroTime = utime:unixdate(NowTime),
    FourClock = ZeroTime + 4 * 3600,
    case H < 4 of
        true -> FourClock;
        false -> FourClock + ?ONE_DAY_SECONDS
    end.


%% 资源找回状态report
report_res_act(PS) ->
    #player_status{vip = Vip, sid = Sid, resource_back = #resource_back{res_act_map = ResActMap}} = PS,
    ComList = get_common_times(PS),
    ?PRINT("~n~n~n ~p ~n~n~n", [ComList]),
	  VipList = count_vip_times(ComList, Vip, ResActMap, []),
    ?PRINT("~n~n~n ~p ~n~n~n", [VipList]),
%%	?DEBUG("ResActMap:~p ~n List ~p~n", [ResActMap, List4]),
    CheckList = lists:filter(fun({ActId, SubId, _, _, _}) -> bf_check_resource_back(PS, ActId, SubId) end, VipList),
    {ok, Bin} = pt_419:write(41900, [?SUCCESS, CheckList]),
    lib_server_send:send_to_sid(Sid, Bin).

%% 资源找回列表（包括vip额外次数,总数（日常次数+vip额外次数））
%% @return  [{Id, ActSub, LeftTimes, RewardLv} | _]
get_common_times(PS) ->
    #player_status{id = RoleId, figure = #figure{lv = Lv}, resource_back = #resource_back{res_act_map = ResActMap}} = PS,
    Yesterday = maps:get(?YESTERDAY, ResActMap, #{}),
    BYesterday = maps:get(?B_YESTERDAY, ResActMap, #{}),
    F = fun(_K, V, List) ->
        #res_act{act_id = Id, act_sub = ActSub, lefttimes = LeftTimes, max = Limit} = V,
        case Limit == 0 of
            false ->
                case lists:keyfind({Id, ActSub}, 1, List) of
                    {{Id, ActSub}, OldLeftTimes} ->
                        lists:keystore({Id, ActSub}, 1, List, {{Id, ActSub}, OldLeftTimes + LeftTimes});
                    _ -> [{{Id, ActSub}, LeftTimes} | List]
                end;
            true -> List
        end
        end,
    List1 = maps:fold(F, [], Yesterday),
    List2 = maps:fold(F, List1, BYesterday),
    List3 = [{Id, ActSub, LeftTimes, get_reward_lv(RoleId, Id, ActSub, Lv)}
        || {{Id, ActSub}, LeftTimes} <- List2, get_reward_lv(RoleId, Id, ActSub, Lv) =/= 0],  %% LeftTimes /= 0,  次数不过滤
    List3.

%% -----------------------------------------------------------------
%% @desc     功能描述 计算vip额外次数
%% @param    参数     [{Id, ActSub, LeftTimes, RewardLv}]
%%                    Vip::#role_vip
%% @return   返回值   [{Id, ActSub, NewLeftTimes, NewVipTimes, RewardLv}]
%% @history  修改历史
%% -----------------------------------------------------------------
count_vip_times([], _Vip, _ResActMap,  ResList) ->
	  ResList;

count_vip_times([H | T], Vip, ResActMap,  ResList) ->
    {Id, ActSub, LeftTimes, RewardLv} = H,
	  Yesterday  = maps:get(?YESTERDAY, ResActMap, #{}),
	  BYesterday = maps:get(?B_YESTERDAY, ResActMap, #{}),
	  YResAct    = maps:get({Id, ActSub}, Yesterday, none),
	  BYResAct   = maps:get({Id, ActSub}, BYesterday, none),
%%	_Count     =   %%vip的天数，
%%	if
%%		is_record(BYResAct, res_act), is_record(YResAct, res_act) ->  %%前两天都有剩余次数
%%			2;
%%		is_record(BYResAct, res_act) ->
%%			1;
%%		is_record(YResAct, res_act) ->
%%			1;
%%		true ->
%%			0
%%	end,
    TempYResAct  = maps:get({Id, ActSub}, Yesterday, #res_act{}),
    TempBYResAct = maps:get({Id, ActSub}, BYesterday, #res_act{}),
%%	_VipType =
%%		case data_resource_back:get_res_cfg(Id, ActSub, RewardLv)  of
%%			[] ->
%%				-1;
%%			#base_res_act{vip_type =  TempValue} ->
%%				TempValue
%%		end,
	  #role_vip{vip_type =  _Card,vip_lv =  _VipLv } = Vip, %%Card vip卡类型  VipLv vip等级
	  VipTimes =  get_yesterday_byesterday_vip_times(YResAct, BYResAct),
    %%总vip次数 - 购买vip次数
    _NewVipTimes   = min(VipTimes - TempYResAct#res_act.vip_buy_time - TempBYResAct#res_act.vip_buy_time, LeftTimes),
    NewVipTimes  = max(_NewVipTimes, 0), %%防止策划填错
    %%剩余次数   = vip次数 + 普通次数
    %%剩余次数   = 剩余次数 - 参与活动次数 %%参与活动会改变当天的剩余次数
    %%找回的时候 = 显示给客户端的时候，剩余的普通次数不能大于最大的普通次数
    %%显示值     = (总剩余次数 - 剩余vip次数)
    NewLeftTimes = max(LeftTimes - NewVipTimes, 0),
    NewVipTimes1 = max(NewVipTimes, 0),
%%    ?MYLOG("cym", "LeftTimes ~p NewVipTimes ~p~n", [LeftTimes, NewVipTimes]),
	  count_vip_times(T, Vip, ResActMap, [{Id, ActSub, NewLeftTimes, NewVipTimes1, RewardLv} | ResList]).

make_res_act_map(DayType, _PS, _ActIds, ActList) when DayType == ?TODAY ->
    F = fun(H, Map) ->
        case H of
            {Id, ActSub, LeftTimes, State} ->
                Limit = get_act_limit_with_vip(Id, ActSub, _PS),  %%受特权值影响
                Act   = #res_act{act_id = Id, act_sub = ActSub, lefttimes = LeftTimes, max = Limit, state = State},
                maps:put({Id, ActSub}, Act, Map);
            {Id, ActSub, LeftTimes, State, VipBuyTimes} ->
                Limit = get_act_limit_with_vip(Id, ActSub, _PS),  %%受特权值影响
                Act   = #res_act{act_id = Id, act_sub = ActSub, lefttimes = LeftTimes, max = Limit, state = State, vip_buy_time = VipBuyTimes},
                maps:put({Id, ActSub}, Act, Map);
            {Id, ActSub, LeftTimes, State, VipBuyTimes, MaxVipBuyTimes, MaxFixationTimes} ->
                Limit = get_act_limit_with_vip(Id, ActSub, _PS),  %%受特权值影响
                Act   = #res_act{act_id = Id, act_sub = ActSub, lefttimes = LeftTimes, max = Limit, state = State, vip_buy_time = VipBuyTimes,
                    max_vip_buy_time = MaxVipBuyTimes, max_vip_fixation_times = MaxFixationTimes},
                maps:put({Id, ActSub}, Act, Map);
            _ -> Map
        end
        end,
    lists:foldl(F, #{}, ActList);

make_res_act_map(_DayType, _PS, _ActIds, ActList) ->
    F = fun(H, Map) ->
        case H of
            {Id, ActSub, LeftTimes, State} ->
                Limit = get_act_limit_with_vip(Id, ActSub, _PS),  %%受特权值
                Act   = #res_act{act_id = Id, act_sub = ActSub, lefttimes = LeftTimes, max = Limit, state = State},
                maps:put({Id, ActSub}, Act, Map);
            {Id, ActSub, LeftTimes, State, VipBuyTimes} ->
                Limit = get_act_limit_with_vip(Id, ActSub, _PS),  %%受特权值
                Act   = #res_act{act_id = Id, act_sub = ActSub, lefttimes = LeftTimes, max = Limit, state = State, vip_buy_time = VipBuyTimes},
                maps:put({Id, ActSub}, Act, Map);
            {Id, ActSub, LeftTimes, State, VipBuyTimes, MaxVipBuyTimes, MaxFixationTimes} ->
                Limit = get_act_limit_with_vip(Id, ActSub, _PS),  %%受特权值
                Act   = #res_act{act_id = Id, act_sub = ActSub, lefttimes = LeftTimes, max = Limit, state = State,
                    vip_buy_time = VipBuyTimes, max_vip_buy_time = MaxVipBuyTimes, max_vip_fixation_times = MaxFixationTimes},
                maps:put({Id, ActSub}, Act, Map);
            _ -> Map
        end
        end,
    lists:foldl(F, #{}, ActList).

%% -------------------------------- db函数 ---------------------------------
db_update_resource_back(RoleId, ResourceBack) ->
    #resource_back{cleartime = ClearTime, res_act_map = ResActMap} = ResourceBack,
    F = fun(DayType, V, List) ->
        F1 = fun(_K, ResAct, List1) ->
            #res_act{act_id = Id, act_sub = ActSub, lefttimes = LeftTimes, state = State,
                vip_buy_time = VipBuyTime, max_vip_buy_time = MaxVipBuyTime, max_vip_fixation_times = MaxVipFixationTimes} = ResAct,
            [{Id, ActSub, LeftTimes, State, VipBuyTime, MaxVipBuyTime, MaxVipFixationTimes} | List1]
             end,
        DbActList = maps:fold(F1, [], V),
        [{DayType, DbActList} | List]
        end,
    ResActList = maps:fold(F, [], ResActMap),
    SqlValues = format_resource_back_values(RoleId, ClearTime, ResActList, [], 1),
    %?PRINT("update_resource_back ~p~n", [SqlValues]),
    Sql = ?SQL_BATCH_REPLACE_RES_BACK ++ SqlValues,
    db:execute(Sql).

db_select_res_act_list(RoleId) ->
    Sql = io_lib:format(?SQL_SELECT_RES_BACK, [RoleId]),
    db:get_all(Sql).


format_resource_back_values(_, _, [], List, _) -> List;
format_resource_back_values(RoleId, ClearTime, [H | ResActList], List, Num) ->
    {DayType, ActList} = H,
    ActList_B = util:term_to_bitstring(ActList),
    Value = io_lib:format(?SQL_BATCH_REPLACE_VALUES, [RoleId, ClearTime, DayType, ActList_B]),
    if
        Num =:= 1 ->
            NewList = Value ++ List;
        true ->
            NewList = Value ++ "," ++ List
    end,
    format_resource_back_values(RoleId, ClearTime, ResActList, NewList, Num + 1).

calc_cost(PS, Cost) ->
    #player_status{bgold = BGold} = PS,
    F = fun(Item, {Bind, List}) ->
        case Item of
            {?TYPE_COIN, _, _} -> {no_bind, [Item | List]};
            {?TYPE_GOLD, _, Num} ->
                case BGold >= Num of
                    true -> {bind, [{?TYPE_BGOLD, 0, Num} | List]};
                    false when BGold > 0 ->
                        {bind, [{?TYPE_BGOLD, 0, BGold}, {?TYPE_GOLD, 0, Num - BGold} | List]};
                    _ -> {no_bind, [{?TYPE_GOLD, 0, Num} | List]}
                end;
            _ -> {Bind, List}
        end
        end,
    lists:foldl(F, {no_bind, []}, Cost).



find_reward_by_bind(Reward, bind) ->
    F = fun(Item, List) ->
        case Item of
            {?TYPE_GOODS, Id, Num} ->
                [{?TYPE_BIND_GOODS, Id, Num} | List];
            _ -> [Item | List]
        end
        end,
    lists:foldl(F, [], Reward);
find_reward_by_bind(Reward, _) -> Reward.

get_reward_lv(RoleId, Module, ModuleSub, Lv) ->
    LvList = data_resource_back:get_reward_lv_list(Module, ModuleSub),
    do_get_reward_lv(RoleId, Module, ModuleSub, Lv, LvList).
do_get_reward_lv(_RoleId, _Module, _ModuleSub, _Lv, []) -> 0;
do_get_reward_lv(RoleId, Module, ModuleSub, Lv, [H | T]) ->
    case Lv >= H of
        true ->
            case Module of
                ?MOD_DUNGEON ->
                    case data_resource_back:get_res_cfg(Module, ModuleSub, H) of
                        #base_res_act{dun_id = DunId} ->
                            if
                                ModuleSub == ?DUNGEON_TYPE_HIGH_EXP -> H;   %% 高级经验本特殊处理
                                DunId == 0 -> H;
                                true ->
                                    case lib_dungeon_api:check_ever_finish(RoleId, DunId) of
                                        true -> H;
                                        _ ->
                                            do_get_reward_lv(RoleId, Module, ModuleSub, Lv, T)
                                    end
                            end;

                        _ -> 0
                    end;
                _ -> H
            end;
        false -> do_get_reward_lv(RoleId, Module, ModuleSub, Lv, T)
    end.

get_guild_limit(GuildId, Module, ModuleSub, Lv) ->
    case data_resource_back:get_res_cfg(Module, ModuleSub, Lv) of
        #base_res_act{guild_limit = GuildLim} ->
            case GuildLim of
                0 -> true;
                _ ->
                    case GuildId of
                        0 -> false;
                        _ -> true
                    end
            end;
        _ -> false
    end.

%% -------------------------------- 检查函数 ---------------------------------

%% 一些额外特殊处理
%% 工会争霸特殊处理
bf_check_resource_back(#player_status{id = RoleId, guild = #status_guild{id = GuildId}}, ?MOD_TERRITORY_WAR, 0) ->
    case catch mod_territory_war:is_qualification_call(RoleId, GuildId) of
        {'EXIT', _} -> false;
        Res -> Res
    end;
bf_check_resource_back(_PS, _Id, _ActSub) ->
    true.

check_resource_back(PS, Id, ActSub, TmpType, TempTimes, Times_Others) ->
	Times = TempTimes + Times_Others,
    #player_status{id = RoleId, figure = #figure{lv = Lv}, resource_back = #resource_back{res_act_map = ResActMap}} = PS,
    OpenLv = lib_module:get_open_lv(?MOD_RESOURCE_BACK, 1),
    RewardLv = get_reward_lv(RoleId, Id, ActSub, Lv),
    %?PRINT("~p,~p, ~p~n", [Id, ActSub, RewardLv]),
    BfCheck = bf_check_resource_back(PS, Id, ActSub),
    if
        not BfCheck -> {false, ?FAIL};
        Lv < OpenLv -> {false, ?FAIL};
        TempTimes +  Times_Others == 0 -> {false, ?FAIL};
        TmpType == 1 orelse TmpType == 2 ->
            Type = ?IF(TmpType == 1, ?TYPE_BGOLD, ?TYPE_COIN),
            case data_resource_back:get_res_cfg(Id, ActSub, RewardLv) of
                #base_res_act{coin_per = CoinCost, coin_goods = CoinReward, gold_per = GoldCost, gold_goods = GoldReward, other_cost = OtherCost} ->
                    case check_res_act_times(ResActMap, Id, ActSub, Times) of
                        {true, YResAct, BYResAct} ->
                            %?PRINT("~p,~p~n", [YResAct, BYResAct]),
                            case CoinCost of
                                [{Type, _, _}] ->  %%金币消耗
                                    % RealReward = [{RewardType, RewardTypeId, RewardNum * TempTimes} || {RewardType, RewardTypeId, RewardNum} <- CoinReward],
                                    RealReward = recalc_resource_back_reward(Id, ActSub, PS, CoinReward, TempTimes),
                                    RealCost = [{MoneyType, MoneyTypeId, MoneyNum * TempTimes} || {MoneyType, MoneyTypeId, MoneyNum} <- CoinCost],
                                    case lib_goods_api:can_give_goods(PS, RealReward) of
                                        true -> {true, RewardLv, RealReward, RealCost, YResAct, BYResAct};
                                        _ -> {false, ?ERRCODE(err150_cell_max)}
                                    end;
                                _ ->   %%绑转消耗  +  额外消耗,   奖励一样，消耗不一样
                                    case GoldCost of
                                        [{Type, _, _}] ->
                                            % RealReward    = [{RewardType, RewardTypeId, RewardNum * Times} || {RewardType, RewardTypeId, RewardNum} <- GoldReward],
                                            RealReward = recalc_resource_back_reward(Id, ActSub, PS, GoldReward, Times),
                                            TempRealCost1 = [{MoneyType, MoneyTypeId, MoneyNum * TempTimes} || {MoneyType, MoneyTypeId, MoneyNum} <- GoldCost],
	                                        TempRealCost2 = [{MoneyType1, MoneyTypeId1, MoneyNum1 * Times_Others} || {MoneyType1, MoneyTypeId1, MoneyNum1} <- OtherCost],
	                                        _RealCost     = TempRealCost1 ++ TempRealCost2,
                                            RealCost      = [{_GoodType, _GoodId, _Num} || {_GoodType, _GoodId, _Num} <-_RealCost , _Num > 0],
	                                        case lib_goods_api:can_give_goods(PS, RealReward) of
                                                true -> {true, RewardLv, RealReward, RealCost, YResAct, BYResAct};
                                                _ -> {false, ?ERRCODE(err150_cell_max)}
                                            end;
                                        _ -> {false, ?ERRCODE(err_config)}
                                    end
                            end;
                        {false, Res1} -> {false, Res1}
                    end;
                _ ->
                    case RewardLv of
                        0 -> {false, ?ERRCODE(err419_no_dun_finish)};
                        _ -> {false, ?ERRCODE(err_config)}
                    end
            end;
        true -> {false, ?ERRCODE(err_config)}
    end.

recalc_resource_back_reward(?MOD_DUNGEON, SubId, PS, Reward, Times)
    when SubId == ?DUNGEON_TYPE_EXP_SINGLE orelse SubId == ?DUNGEON_TYPE_HIGH_EXP ->
    WorldLv = util:get_world_lv(),
    ServerLvExpAdd = lib_player:calc_satisfy_world_exp_add(PS, WorldLv),
    F = fun
        ({?TYPE_EXP=RewardType, RewardTypeId, RewardNum}, List) ->
            [{RewardType, RewardTypeId, round(RewardNum * Times * (1+ServerLvExpAdd/100))}|List];
        ({RewardType, RewardTypeId, RewardNum}, List) ->
            [{RewardType, RewardTypeId, RewardNum * Times}|List];
        (_, List) ->
            List
    end,
    NewReward = lists:reverse(lists:foldl(F, [], Reward)),
    NewReward;
recalc_resource_back_reward(_Id, _ActSub, _PS, Reward, Times) ->
    [{RewardType, RewardTypeId, RewardNum * Times} || {RewardType, RewardTypeId, RewardNum} <- Reward].

check_res_act_times(ResActMap, Id, ActSub, Times) ->
    Yesterday = maps:get(?YESTERDAY, ResActMap, #{}),
    BYesterday = maps:get(?B_YESTERDAY, ResActMap, #{}),
    YResAct = maps:get({Id, ActSub}, Yesterday, none),
    BYResAct = maps:get({Id, ActSub}, BYesterday, none),
    if
        is_record(BYResAct, res_act), is_record(YResAct, res_act) ->  %%前两天都有剩余次数
            LeftTimes1 = YResAct#res_act.lefttimes,  %% 昨天剩余次数
            LeftTimes2 = BYResAct#res_act.lefttimes, %% 前天剩余次数
            case check_times_valid(LeftTimes1 + LeftTimes2, Times) of
                true -> {true, YResAct, BYResAct};
                Res -> Res
            end;
        is_record(BYResAct, res_act) ->
            LeftTimes1 = BYResAct#res_act.lefttimes,
            case check_times_valid(LeftTimes1, Times) of
                true -> {true, none, BYResAct};
                Res -> Res
            end;
        is_record(YResAct, res_act) ->
            LeftTimes1 = YResAct#res_act.lefttimes,
            case check_times_valid(LeftTimes1, Times) of
                true -> {true, YResAct, none};
                Res -> Res
            end;
        true -> {false, ?ERRCODE(err419_no_res_act)}
    end.

check_times_valid(LeftTimes, Times) ->
    case LeftTimes of
        0 -> {false, ?ERRCODE(err419_no_res_act)};
        Num when Times > Num -> {false, ?ERRCODE(err419_no_more_times)};
        _ -> true
    end.



%% -----------------------------------------------------------------
%% @desc     功能描述  vip购买导致，剩余次数改变
%% @param    参数
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
add_vip_buy_count(PS, ActId, Sub, Count) ->
    #player_status{resource_back =  ResBack} =  PS,
    #resource_back{res_act_map =  ResActMap} =  ResBack,
    Today = maps:get(?TODAY, ResActMap, #{}),  %%当天的资源找回
    case maps:get({ActId, Sub}, Today, none) of
        #res_act{vip_buy_time = VipBuyTime} = ResAct->
            NewResAct = ResAct#res_act{vip_buy_time = VipBuyTime + Count};
        none ->
            ResAct = get_init_res_act(ActId, Sub, PS),
            #res_act{vip_buy_time = VipBuyTime} = ResAct,
            NewResAct = ResAct#res_act{vip_buy_time = VipBuyTime + Count}
    end,
    NewToday     = maps:put({ActId, Sub}, NewResAct, Today),
%%    ?MYLOG("cym", "NewResAct ~p~n", [NewResAct]),
    NewResActMap = maps:put(?TODAY, NewToday, ResActMap),
    NewResBack   = ResBack#resource_back{res_act_map = NewResActMap},
    db_update_resource_back(PS#player_status.id, NewResBack), %%同步数据库
    PS#player_status{resource_back = NewResBack}.


%%获取前两天的vip次数
get_yesterday_byesterday_vip_times(#res_act{max_vip_buy_time = V1}, #res_act{max_vip_buy_time = V2}) ->
    V1 + V2;
get_yesterday_byesterday_vip_times(#res_act{max_vip_buy_time = V1}, _) ->
    V1;
get_yesterday_byesterday_vip_times(_, #res_act{max_vip_buy_time = V2}) ->
    V2;
get_yesterday_byesterday_vip_times(_, _) ->
    0.


get_init_res_act(Id, ActSub, PS) ->
    MaxVipBuyTimes = get_only_vip_times(Id, ActSub, PS),
    Limit = get_act_limit_with_vip(Id, ActSub, PS),
    ResAct = #res_act{act_id = Id, act_sub = ActSub, lefttimes = Limit, max = Limit,
        state = ?STATE_NOT_FIND, max_vip_buy_time = MaxVipBuyTimes, max_vip_fixation_times = get_act_limit(Id, ActSub, PS#player_status.vip)},
    ResAct.

is_task_open(Id, AcSub, Tid, RewardLv) ->
    case data_resource_back:get_res_cfg(Id, AcSub, RewardLv) of
        #base_res_act{task_id = TaskId} ->
            if
                TaskId == 0->
                    true;
                true ->
                    case catch mod_task:is_finish_task_id(Tid, TaskId) of
                        true -> true;
                        _ -> false
                    end
            end;
        _ ->
            false
    end.


%% 修复最大vip次数错误问题

repair_max_vip_buy_times(RoleId) ->
    lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, ?HAND_OFFLINE, lib_resource_back, repair_max_vip_buy_times2, []).

repair_max_vip_buy_times2(PS) ->
%%    ?MYLOG("cym", "++++++++++~n", []),
    #player_status{resource_back = ResBack} = PS,
    #resource_back{res_act_map =  ResActMap} =  ResBack,
    YesterdayMap = maps:get(?YESTERDAY, ResActMap, #{}),  %%昨天的资源找回
    BYesterdayMap = maps:get(?B_YESTERDAY, ResActMap, #{}),
%%    ?MYLOG("cym", "YesterdayMap ~p~n", [YesterdayMap]),
%%    ?MYLOG("cym", "BYesterdayMap ~p~n", [BYesterdayMap]),
    ListYesterday = maps:to_list(YesterdayMap),
    ListBYesterday = maps:to_list(BYesterdayMap),
    NewListYesterday =
        [{{ActId, SubId}, ResAct#res_act{max_vip_buy_time = get_only_vip_times(ActId, SubId, PS)}} ||
            {{ActId, SubId}, ResAct} <- ListYesterday],
    NewListBYesterday =
        [{{ActId2, SubId2}, ResAct2#res_act{max_vip_buy_time = get_only_vip_times(ActId2, SubId2, PS)}} ||
            {{ActId2, SubId2}, ResAct2} <- ListBYesterday],
%%    ?MYLOG("cym", "NewListYesterday ~p~n", [NewListYesterday]),
%%    ?MYLOG("cym", "NewListBYesterday ~p~n", [NewListBYesterday]),
    NewYesterdayMap = maps:from_list(NewListYesterday),
    NewBYesterdayMap = maps:from_list(NewListBYesterday),
    NewResActMap1 = maps:put(?YESTERDAY, NewYesterdayMap, ResActMap),
    NewResActMap2 = maps:put(?B_YESTERDAY, NewBYesterdayMap, NewResActMap1),
    NewResBack   = ResBack#resource_back{res_act_map = NewResActMap2},
    db_update_resource_back(PS#player_status.id, NewResBack), %%同步数据库
%%    ?MYLOG("cym", "NewResBack ~p~n", [NewResBack]),
    PS#player_status{resource_back = NewResBack}.

repair_dungeon() ->
    OnlineList = ets:tab2list(?ETS_ONLINE),
    [lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_resource_back, repair_dungeon, []) || #ets_online{id = RoleId} <- OnlineList].

repair_dungeon(Ps) ->
    Num1 = mod_daily:get_count_offline(Ps#player_status.id, ?MOD_DUNGEON, ?MOD_DUNGEON_ENTER, 32),
    NewPsTmp =
        case Num1 of
            0 -> Ps;
            _ ->
                {ok, NewPs1} = increase_ps_act_status(Ps, {610, 32, Num1}),
                NewPs1
        end,
    Num2 = mod_daily:get_count_offline(Ps#player_status.id, ?MOD_DUNGEON, ?MOD_DUNGEON_ENTER, 34),
    case Num2 of
        0 -> NewPsTmp;
        _ ->
            {ok, NewPs} = increase_ps_act_status(NewPsTmp, {610, 34, Num2}),
            NewPs
    end.


%% 消耗物品
%% 优化后可免费找回奖励，为少改代码，加以优化
%% 应对[{_,_0}]的情况
cost_object_list_with_check(ResourceType, PS, Cost, Type, About) ->
    case ResourceType of
        2 ->
            case recurise_zero_num(Cost) of %% 金币消耗为0的情况
                true -> {true, PS};
                false -> lib_goods_api:cost_object_list_with_check(PS, Cost, Type, About)
            end;
        _ -> lib_goods_api:cost_object_list_with_check(PS, Cost, Type, About)
    end.

recurise_zero_num([]) -> true;
recurise_zero_num([{_,_,Num}|T]) ->
    ?IF(Num == 0, recurise_zero_num(T), false).



























