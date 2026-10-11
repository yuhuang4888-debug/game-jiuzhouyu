%% ---------------------------------------------------------
%% Doc: 玩家record操作相关
%% Author:  hek
%% Email:   1472524632@qq.com
%% Created: 2016-8-25
%% Description: 获取、更新指定玩家record字段
%% --------------------------------------------------------

-module(lib_player_record).
-include("attr.hrl").
-include("server.hrl").
-include("figure.hrl").
-include("errcode.hrl").
-include("predefine.hrl").
-include("def_event.hrl").
-include("rec_event.hrl").
-include("sql_player.hrl").
-include("common.hrl").

-export([
         get_field_auto/2,
         update_field_auto/2,
         get_field/2,
         update_field/2,
         %% 修正玩家的pk值
         pk_login/5,
         use_red_name_goods/1,
         %% 功能存在超时的检查
         role_func_check_insert/3,
         role_func_check_update/3,
         role_func_check_delete/2,
         role_func_check_delete_sub_id/3,
         role_func_check/0,
         %% 玩家身上金钱转换
         trans_to_ps_money/2,
         update_ps_money_op/3
         , get_pk_map/1
         , db_role_pk_status_replace/3
        ]).

get_field_auto(FieldList, PS) ->
    get_field_auto(FieldList, PS, []).

get_field_auto([], _PS, Res) -> lists:reverse(Res);
get_field_auto([FieldId|T], PS, Res) ->
    Value = element(FieldId+1, PS),
    get_field_auto(T, PS, [Value|Res]).

update_field_auto([], PS) -> PS;
update_field_auto([{FieldId, Value}|T], PS) ->
    NewPS = setelement(FieldId+1, PS, Value),
    update_field_auto(T, NewPS).

get_field(KeyList, PS) ->
    get_field(KeyList, PS, []).

get_field([], _PS, Res) -> lists:reverse(Res);
get_field([Key|T], PS, Res) ->
    Value = case Key of
                career -> PS#player_status.figure#figure.career;
                _ -> 0
            end,
    get_field(T, PS, [Value|Res]).

update_field(_KeyValueList, PS) -> PS.

%% ================================= 玩家pk状态 =================================
%% 玩家pk状态
pk_login(NowTime, PkStatus, PkSChgTime, PkValue, PkVChgTime)->
    {NPkValue, NPkVChgTime, NewPkValueRef}
        = if
              PkValue =< 0  -> {0, 0, undefined};
              PkValue == 1 andalso NowTime - PkVChgTime >= ?RemovePkValue-> {0, 0, undefined};
              PkVChgTime == 0 ->
                  NPkValueRef = erlang:send_after(?RemovePkValue*1000, self(), {'change_pk_value', pk_value, -1}),
                  {PkValue, NowTime, NPkValueRef};
              true -> %% 记录最近的一次清理时间
                  DelPkValue = (NowTime - PkVChgTime) div ?RemovePkValue,
                  case max(0, PkValue - DelPkValue) of 
                      0 -> {0, 0, undefined};
                      NewPkValue ->
                          NextPkVChgTime = PkVChgTime + (DelPkValue + 1) * ?RemovePkValue,
                          SpanTime = NextPkVChgTime - NowTime + 2,
                          NPkValueRef = erlang:send_after(SpanTime*1000, self(), {'change_pk_value', pk_value, -1}),
                          {NewPkValue, NextPkVChgTime-?RemovePkValue, NPkValueRef}
                  end
          end,
    #pk{pk_status = PkStatus, pk_change_time = PkSChgTime, pk_value = NPkValue,
        pk_value_change_time = NPkVChgTime, pk_value_ref = NewPkValueRef}.

%% 使用道具消除罪恶值
use_red_name_goods(Ps)->
    #player_status{id = RoleId, sid = Sid, battle_attr = BA, 
                   scene = SceneId, scene_pool_id = ScenePId, copy_id = CopyId, x = X, y = Y} = Ps,
    #battle_attr{pk = Pk} = BA,
    #pk{pk_value = PkValue, pk_value_ref = PkValueRef} = Pk,
    if
        PkValue =< 0 -> {fail, ?ERRCODE(err150_pk_value_0)};
        true ->
            NewPkValue = max(0, PkValue-1),
            NewPk = if
                        NewPkValue == 0 ->
                            util:cancel_timer(PkValueRef),
                            {ok, BinData1} = pt_200:write(20015, [RoleId, NewPkValue]),
                            lib_server_send:send_to_area_scene(SceneId, ScenePId, CopyId, X, Y, BinData1),
                            Pk#pk{pk_value = 0, pk_value_change_time = 0, pk_value_ref = undefined};
                        true ->
                            Pk#pk{pk_value = NewPkValue}
                    end,
            NewPs = Ps#player_status{battle_attr = BA#battle_attr{pk = NewPk}},
            lib_player:send_attribute_change_notify(NewPs, ?NOTIFY_PK),
            mod_scene_agent:update(NewPs, [{battle_attr, NewPs#player_status.battle_attr}]),
            {ok, BinData} = pt_200:write(20014, ["", 2, NewPkValue]),
            lib_server_send:send_to_sid(Sid, BinData),
            %% 触发成就
            lib_achievement_api:red_name_wash_event(NewPs, [])
    end.

%% 暂时是称号添加定时检查
%% type: designation
role_func_check_insert(RoleId, Type, EndTimesOrEndTime)->
    E = #ets_role_func_check{key_id = {RoleId, Type}, end_times = EndTimesOrEndTime},
    ets:insert(?ETS_ROLE_FUNC_CHECK, E).

%% 更新定时器数据
role_func_check_update(RoleId, Type, EndTimesOrEndTime) ->
    case ets:lookup(?ETS_ROLE_FUNC_CHECK, {RoleId, Type}) of
        [#ets_role_func_check{end_times = EndTimes} = Object] ->
            case Type of
                designation ->
                    {Id, _} = EndTimesOrEndTime,
                    NewEndTimes = [EndTimesOrEndTime|lists:keydelete(Id, 1, EndTimes)],
                    NewObject = Object#ets_role_func_check{end_times = NewEndTimes},
                    ets:insert(?ETS_ROLE_FUNC_CHECK, NewObject);
                holyghost_illu ->
                    {Id, _} = EndTimesOrEndTime,
                    NewEndTimes = [EndTimesOrEndTime|lists:keydelete(Id, 1, EndTimes)],
                    NewObject = Object#ets_role_func_check{end_times = NewEndTimes},
                    ets:insert(?ETS_ROLE_FUNC_CHECK, NewObject);
                _ ->
                    skip
            end;
        _ ->
            role_func_check_insert(RoleId, Type, [EndTimesOrEndTime])
    end.

%% 删除定时检查超时
role_func_check_delete(RoleId, Type)->
    ets:delete(?ETS_ROLE_FUNC_CHECK, {RoleId, Type}).

%% 删除子类型数据
role_func_check_delete_sub_id(RoleId, Type, SubId)->
    case ets:lookup(?ETS_ROLE_FUNC_CHECK, {RoleId, Type}) of
        [] -> skip;
        [#ets_role_func_check{end_times = EndTimes} = Object] ->
            case Type of
                designation ->
                    NewEndTimes = lists:keydelete(SubId, 1, EndTimes),
                    if
                        NewEndTimes == [] ->
                            ets:delete(?ETS_ROLE_FUNC_CHECK, {RoleId, Type});
                        true ->
                            NewObject = Object#ets_role_func_check{end_times = NewEndTimes},
                            ets:insert(?ETS_ROLE_FUNC_CHECK, NewObject)
                    end;
                _ ->
                    skip
            end
    end.

%% 玩家功能定时检测过期
role_func_check()->
    NowTime = utime:unixtime(),
    RoleList = ets:tab2list(?ETS_ROLE_FUNC_CHECK),
    Fun = fun(#ets_role_func_check{key_id = {RoleId, Type}, end_times = EndTimesOrEndTime}=E) ->
                  if
                      Type == designation orelse Type =:= holyghost_illu ->
                          F = fun({Id, DEndTime}, {DList, LList}) ->
                                      if
                                          NowTime > DEndTime -> {[Id|DList], LList};
                                          true -> {DList, [{Id, DEndTime}|LList]}
                                      end
                              end,
                          {DelList, LeftList} = lists:foldl(F, {[], []}, EndTimesOrEndTime),
                          if
                              DelList == [] -> skip;
                              true -> send_msg_to_role(RoleId, {'func_timer_out', Type, DelList})
                          end,
                          if
                              LeftList == [] -> ets:delete(?ETS_ROLE_FUNC_CHECK, {RoleId, Type});
                              true  ->
                                  NE = E#ets_role_func_check{end_times = LeftList},
                                  ets:insert(?ETS_ROLE_FUNC_CHECK, NE)
                          end;
                      true ->
                          ok
                  end
          end,
    lists:foreach(Fun, RoleList).

%% 发送消息
send_msg_to_role(RoleId, Msg)->
    RolePid = misc:get_player_process(RoleId),
    case misc:is_process_alive(RolePid) of
        false -> skip;
        true -> RolePid ! Msg
    end.

%% 将玩家的金钱数据转换成操作结构传到mysql进程中
%% MoneyCost:只能包含：特殊货币,钻石，绑钻，金币，其他货币没处理
trans_to_ps_money(Ps, Type) ->
    #player_status{id = Id, gold = Gold, bgold = BGold, coin = Coin, gcoin = GCoin,
      figure = #figure{lv = Lv, guild_id = GuildId}, currency_map = CurrencyMap} = Ps,
    #ps_money{id = Id, lv = Lv, guild_id = GuildId, gold = Gold, bgold = BGold, coin = Coin, gcoin = GCoin, currency_map = CurrencyMap, type = Type}.

%% 更新玩家的货币数据
update_ps_money_op(Ps, PsMoney, NewPsMoney)->
    #ps_money{gold = Gold, bgold = BGold, coin = Coin, gcoin = GCoin, type = Type} = PsMoney,
    #ps_money{gold = NewGold, bgold = NewBGold, coin = NewCoin, gcoin = NewGCoin, currency_map = NewCurrencyMap, real_cost = RealCost} = NewPsMoney,
    case RealCost =/= [] of 
      true ->
        case Gold /= NewGold orelse BGold /= NewBGold orelse Coin /= NewCoin orelse GCoin /= NewGCoin of 
            true ->
                NewPs = Ps#player_status{gold = NewGold, bgold = NewBGold, coin = NewCoin, gcoin = NewGCoin, currency_map = NewCurrencyMap},
                lib_consume_data:update_money_consume(max(Coin-NewCoin,0), max(Gold-NewGold,0), max(BGold-NewBGold,0), Type),
                lib_player:send_attribute_change_notify(NewPs, ?NOTIFY_MONEY);
            _ ->
                NewPs = Ps#player_status{currency_map = NewCurrencyMap}
        end,
        TypeId = data_goods:get_consume_type(Type),
        FConsume = fun({CostType, CostGoodsId, Cost}, PSTmp) ->
            if
                CostType == ?TYPE_GOLD -> 
                    Cost > 0 andalso ta_agent_fire:gold_consume(NewPs, [Cost, TypeId]),
                    {_, NPSTmp} = lib_player_event:dispatch(PSTmp, ?EVENT_MONEY_CONSUME, #callback_money_cost{consume_type = Type, money_type = ?GOLD, cost = Cost});
                CostType == ?TYPE_BGOLD -> 
                    Cost > 0 andalso ta_agent_fire:bgold_consume(NewPs, [Cost, TypeId]),
                    {_, NPSTmp} = lib_player_event:dispatch(PSTmp, ?EVENT_MONEY_CONSUME, #callback_money_cost{consume_type = Type, money_type = ?BGOLD, cost = Cost});
                CostType == ?TYPE_COIN -> 
                    Cost > 0 andalso ta_agent_fire:log_consume_coin(NewPs, [Cost, TypeId]),
                    {_, NPSTmp} = lib_player_event:dispatch(PSTmp, ?EVENT_MONEY_CONSUME, #callback_money_cost{consume_type = Type, money_type = ?COIN, cost = Cost});
                CostType == ?TYPE_CURRENCY ->
                    lib_goods_api:send_update_currency(PSTmp, CostGoodsId),
                    lib_consume_currency_data:update_money_consume(PSTmp, CostGoodsId, Cost, Type),
                    Cost > 0 andalso ta_agent_fire:log_consume_currency(NewPs, [CostGoodsId, Cost, TypeId]),
                    {_, NPSTmp} = lib_player_event:dispatch(PSTmp, ?EVENT_MONEY_CONSUME_CURRENCY, 
                        #callback_currency_cost{consume_type = Type, currency_id = CostGoodsId, cost = Cost});
                true -> 
                    NPSTmp = PSTmp
            end,
            NPSTmp
        end,
        LastPS = lists:foldl(FConsume, NewPs, RealCost),
        LastPS;
      _ ->
        Ps
    end.
  
%% ----------------------------------------------------------------
%% pk状态处理
%% ----------------------------------------------------------------

%% 获得PkMap
get_pk_map(RoleId) ->
    List = db:get_all(io_lib:format(?sql_role_pk_status_select, [RoleId])),
    maps:from_list([{SceneId, PkStatus}||[SceneId, PkStatus]<-List]).

%% 存储pk状态
db_role_pk_status_replace(RoleId, SceneId, PkStatus) ->
    db:execute(io_lib:format(?sql_role_pk_status_replace, [RoleId, SceneId, PkStatus])).
