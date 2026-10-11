%% ---------------------------------------------------------------------------
%% @doc    充值系统 - 充值返利
%% @author hek
%% @since  2016-11-14
%% @deprecated
%% ---------------------------------------------------------------------------

-module (lib_recharge_return).
-include ("common.hrl").
-include ("rec_recharge.hrl").
-include ("def_recharge.hrl").
-include ("def_event.hrl").
-include ("rec_event.hrl").
-include ("errcode.hrl").
-include ("def_fun.hrl").
-include ("language.hrl").
-include ("server.hrl").
-include ("custom_act.hrl").
-include ("def_module.hrl").
-include ("predefine.hrl").

-export([
         login/1                            %% 玩家登陆
        ]).
-export ([
          handle_event/2,                   %% 处理充值回调事件
          handle_product/2,                 %% 处理商品逻辑
          calc_return_state/2,              %% 计算返利信息
          can_return/2                      %% 是否可以返利
          , merge_recharge_return/0
          , act_start/1
          , act_end/1
          ,reset_life_first_recharge_return/1
         ]).

%% 玩家登陆
login(PS) ->
    %% 加载充值返利
    PlayerId       = PS#player_status.id,
    RechargeStatus = PS#player_status.recharge_status,
    ReturnData = case get_recharge_return_db(PlayerId) of
                     [] -> #{};
                     ReturnedList ->
                         lists:foldl(
                           fun([ProductId, ReturnType, ReturnTime], ReturnMap) ->
                                   maps:put({ProductId, ReturnType}, ReturnTime, ReturnMap)
                           end, #{}, ReturnedList)
                 end,
    NewRechargeStatus = RechargeStatus#recharge_status{return_data = ReturnData},
    NewPS = PS#player_status{recharge_status = NewRechargeStatus},
    %% 加载首充奖励
    lib_recharge_first:login(NewPS).

%% 处理充值回调事件 -- 普通充值
handle_event(PS, #event_callback{
                    type_id = ?EVENT_RECHARGE,
                    data    = #callback_recharge_data{
                                 recharge_product = #base_recharge_product{product_id    = ProductId,
                                                                           product_type = ?PRODUCT_TYPE_NORMAL
                                                                          } = _Product,
                                 associate_ids = AssociateIds
                                }
                   }) ->
    {ok, NewPS} = handle_product(PS, ProductId),

    %% 关联的其他商品类型
    {ok, LastPS} = lib_recharge:handle_associate_product(NewPS, AssociateIds),
    {ok, LastPS};
handle_event(PS, _) ->
    {ok, PS}.

%% 处理商品逻辑
handle_product(PS, ProductId) ->
    #base_recharge_product{
       product_id      = ProductId,
       product_type    = _ProductType,
       product_subtype = _ProductSubType
      } = Product = lib_recharge_check:get_product(ProductId),
    RechargeStatus = PS#player_status.recharge_status,
    {CanReturn, ReturnType} = can_return(RechargeStatus, ProductId),
    if
        CanReturn == 1 -> do_handle_product(PS, Product, ReturnType);
        true -> {ok, PS}
    end.

%% 处理返利逻辑
do_handle_product(PS, Product, ReturnType) ->
    NowTime  = utime:unixtime(),
    update_recharge_return_and_mail(PS, Product, ReturnType, NowTime).

update_recharge_return_and_mail(PS, Product, ReturnType, NowTime) ->
    PlayerId = PS#player_status.id,
    #base_recharge_product{
       product_id      = ProductId,
       product_name     = ProductName
      } = Product,
    replace_recharge_return_db(PlayerId, ProductId, ReturnType, NowTime),
    RechargeStatus = PS#player_status.recharge_status,
    NewReturnData = maps:put({ProductId, ReturnType}, NowTime, RechargeStatus#recharge_status.return_data),
    NewRechargeStatus = RechargeStatus#recharge_status{return_data = NewReturnData},
    ReturnCfg = data_recharge:get_recharge_return(ProductId, ReturnType),
    #base_recharge_return{gold = Gold, return_gold = ReturnGold} = ReturnCfg,
    send_pay_mail(PlayerId, ProductName, ReturnGold),
    NewReturnType = calc_return_state(NewRechargeStatus, ProductId),
    send_return_change_notify(PS#player_status.sid, ProductId, NewReturnType),
    lib_log_api:log_recharge_return(PlayerId, ProductId, ReturnType, Gold, ReturnGold, NowTime),
    ta_agent_fire:log_recharge_return(PS, [ProductId, ReturnType, Gold, ReturnGold]),
    {ok, PS#player_status{recharge_status = NewRechargeStatus}}.

%% 是否可以返利
%% @reutrn {return_status：详见下面get_return_status, return_type}
%% 注： 一个商品同时配置了活动时间首次，终生首次返利类型时，优先活动时间返利
%%     1. 活动时间前，未获得终生首次可以获得终生首次
%%     2. 之前没拿终生首次，活动时间拿了活动时间首次再次购买同商品，不拿终生首次
%%     3. 活动时间结束，之前没拿终生首次的可以获得终生首次
%% 修改为：
%% 注： 一个商品同时配置了活动时间首次，终生首次返利类型时，优先活动时间返利
%%     1. 活动时间前，未获得终生首次可以获得终生首次
%%     2. 没拿终生首次，活动时间充值首次拿终生，然后再次充值拿活动
%%     3. 活动时间结束，之前没拿终生首次的可以获得终生首次

can_return(RechargeStatus, ProductId) ->
    do_can_return(RechargeStatus, ProductId, ?RETURN_TYPE_LIFE_FIRST).

do_can_return(RechargeStatus, ProductId, ReturnType) ->
    Return = get_return_status(RechargeStatus, ProductId, ReturnType),
    case Return of
        %% 可以返利
        {1, _ReturnType} -> Return;
        {2, ?RETURN_TYPE_LIFE_FIRST} ->
            do_can_return(RechargeStatus, ProductId, ?RETURN_TYPE_ACT_FIRST);
        %% 已拿本次活动时间返利 或者 终生首次返利
        % {2, _ReturnType} -> Return;
        % _ when ReturnType == ?RETURN_TYPE_ACT_FIRST -> %% 活动首次
        %     do_can_return(RechargeStatus, ProductId, ?RETURN_TYPE_LIFE_FIRST);
        % _ when ReturnType == ?RETURN_TYPE_LIFE_FIRST -> %% 终生首次
        %     do_can_return(RechargeStatus, ProductId, ?RETURN_TYPE_NO); %% 没有返利
        _ -> Return
    end.

%% 商品id返利状态
%% @reutrn {return_status,  return_type}
%% return_status :: 0 无返利类型
%%                   :: 1 未返利
%%                   :: 2 已经返利
%%                   :: 3 不满足商品控制条件
%%                   :: 4 非活动时间
%%                   :: 5 本商品无该返利类型
get_return_status(RechargeStatus, ProductId, ReturnType) ->
    ReturnTypeList = data_recharge:get_return_type_by_product_id(ProductId),
    case lists:member(ReturnType, ReturnTypeList) of
        true -> do_get_return_status(RechargeStatus, ProductId, ReturnType);
        false -> {5, ReturnType}
    end.

do_get_return_status(_RechargeStatus, _ProductId, ReturnType = ?RETURN_TYPE_NO) -> %% 没有返利
    {0, ReturnType};

do_get_return_status(RechargeStatus, ProductId, ReturnType = ?RETURN_TYPE_LIFE_FIRST) -> %% 历史首次
    %% ！！！注：策划特别需求：终生首次不受商品商品通用控制条件影响
    case maps:get({ProductId, ReturnType}, RechargeStatus#recharge_status.return_data, false) of
        false -> {1, ReturnType};
        _ -> {2, ReturnType}
    end;

do_get_return_status(RechargeStatus, ProductId, ReturnType) -> %% 活动返利
    NowTime = utime:unixtime(),
    {StartTime, EndTime} = get_open_time_range(ProductId),
    case lib_recharge_check:check_product(ProductId) of
        {true, _Product} -> CorrectCtrl = 1;
        _ -> CorrectCtrl = 0
    end,
    %% 不满足商品控制条件
    if CorrectCtrl == 0 -> {3, ReturnType};
       true ->
            case maps:get({ProductId, ReturnType}, RechargeStatus#recharge_status.return_data, false) of
                ReturnTime when is_integer(ReturnTime) andalso  %% 本次活动时间已返利
                                ReturnTime>=StartTime andalso ReturnTime<EndTime ->
                    {2, ReturnType};

                ReturnTime when is_integer(ReturnTime) andalso  %% 上次活动已返利，本次活动时间未返利
                                ReturnTime<StartTime andalso NowTime>=StartTime andalso NowTime<EndTime -> 
                    {1, ReturnType};
                
                false when StartTime==0 andalso EndTime == 0 -> %% 未返利，开始时间，结束时间不填默认0时
                    {1, ReturnType}; 

                false when NowTime>=StartTime andalso NowTime<EndTime -> %% 未返利
                    {1, ReturnType};
                
                _ -> %% 非活动时间
                    {4, ReturnType}
            end
    end.

%% 获取返利开放时间段
get_open_time_range(ProductId) ->
    case data_recharge:get_product_ctrl(ProductId) of
        #base_recharge_product_ctrl{start_time = StartTime, end_time = EndTime}
          when StartTime>0 andalso EndTime>0 ->
            {StartTime, EndTime};
        %% 不开放
        _ -> {0, 0}
    end.

%% 充值邮件
send_pay_mail(PlayerId, ProductName, Gold) ->
    Title   = uio:format(?LAN_MSG(?LAN_TITLE_RECHAEGE_RETURN), [ProductName]),
    Content = uio:format(?LAN_MSG(?LAN_CONTENT_RECHAEGE_RETURN), [ProductName, Gold]),
    lib_mail_api:send_sys_mail([PlayerId], Title, Content, [{?TYPE_BGOLD, 0, Gold}]),
    ok.

send_return_change_notify(Sid, ProductId, ReturnType) ->
    lib_server_send:send_to_sid(Sid, pt_158, 15801, [ProductId, ReturnType]),
    ok.

calc_return_state(RechargeStatus, ProductId) ->
  {CanReturn, ReturnType} =  can_return(RechargeStatus, ProductId),   
  if
      %% 无返利类型
      % CanReturn == 0 ->
      %     {ProductId, 0, 0};
      %% 未返利
      CanReturn==1 ->
          % {ReturnType, 1};
          ReturnType;
      %% 已经返利
      % CanReturn==2 ->
      %     {ReturnType, 0};     
      true ->
          % {0, 0}
          0
  end.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 定制活动:充值返利重置
act_start(#act_info{key = {?CUSTOM_ACT_TYPE_RECHARGE_RETURN_RESET, SubType}, etime = EndTime}) ->
    reset_recharge_return(?CUSTOM_ACT_TYPE_RECHARGE_RETURN_RESET, SubType, EndTime),
    ok;
act_start(_ActInfo) ->
    ok.

act_end(#act_info{key = {?CUSTOM_ACT_TYPE_RECHARGE_RETURN_RESET, SubType}}) ->
    mod_global_counter:set_count(?MOD_AC_CUSTOM, ?CUSTOM_ACT_TYPE_RECHARGE_RETURN_RESET, SubType, 0),
    ok;
act_end(_ActInfo) ->
    ok.

reset_recharge_return(ActType, SubType, EndTime) ->
    NowTime = utime:unixtime(),
    case mod_global_counter:get_count(?MOD_AC_CUSTOM, ActType, SubType) of 
        RecordEndTime when NowTime < RecordEndTime -> ok;
        _ ->
            mod_global_counter:set_count(?MOD_AC_CUSTOM, ActType, SubType, EndTime),
            reset_recharge_return_do(),
            ok
    end.

reset_recharge_return_do() ->
    %% 活动重置终生首次返利类型
    merge_recharge_return(),
    RefreshList = ets:tab2list(?ETS_ONLINE),
    [lib_player:apply_cast(OnlineRole#ets_online.id, ?APPLY_CAST_SAVE, ?MODULE, reset_life_first_recharge_return, []) || OnlineRole <- RefreshList].

reset_life_first_recharge_return(PS) ->
    #player_status{id = RoleId, recharge_status = RechargeStatus} = PS,
    #recharge_status{return_data = ReturnData} = RechargeStatus,
    F = fun({ProductId, ReturnType}, _RefreshTime, {Map, List}) ->
        case ReturnType == ?RETURN_TYPE_LIFE_FIRST of 
            true ->
              {maps:remove({ProductId, ReturnType}, Map), [ProductId|List]};
            _ ->
              {Map, List}
        end
    end,
    {NewReturnData, DelList} = maps:fold(F, {ReturnData, []}, ReturnData),
    case DelList == [] of 
        true -> ok;
        _ ->
            IdString = util:link_list(DelList),
            DelSQL = io_lib:format("delete from `recharge_return` where `player_id`=~p and `return_type`=~p and `product_id` in (~s)", [RoleId, ?RETURN_TYPE_LIFE_FIRST, IdString]),
            db:execute(DelSQL)
    end,
    NewRechargeStatus = RechargeStatus#recharge_status{return_data = NewReturnData},
    PS#player_status{recharge_status = NewRechargeStatus}.

%% -------------------------------- db function --------------------------------

get_recharge_return_db(PlayerId) ->
    Sql = io_lib:format(<<"select `product_id`, `return_type`, `return_time` from `recharge_return` where `player_id` = ~p">>, [PlayerId]),
    db:get_all(Sql).

replace_recharge_return_db(PlayerId, ProductId, ReturnType, Time) ->
    Sql = io_lib:format(<<"replace into `recharge_return`(`player_id`, `product_id`, `return_type`, `return_time`) values(~p, ~p, ~p, ~p)">>, [PlayerId, ProductId, ReturnType, Time]),
    db:execute(Sql).

%% 合服处理充值返还
%% 1.清理终生首次的返利类型
merge_recharge_return() ->
    Sql = io_lib:format(<<"delete from `recharge_return` where `return_type` = 1">>, []),
    db:execute(Sql).