%% ---------------------------------------------------------------------------
%% @doc 野外挂机
%% @author hek
%% @since  2016-11-14
%% @deprecated
%% ---------------------------------------------------------------------------

-module(lib_onhook).
-include("server.hrl").
-include("figure.hrl").
-include("common.hrl").
-include("predefine.hrl").
-include("scene.hrl").
-include("goods.hrl").
-include("errcode.hrl").
-include("rec_onhook.hrl").
-include("daily.hrl").
-include("def_fun.hrl").
-include("language.hrl").
-include("def_goods.hrl").
-include("def_event.hrl").
-include("rec_event.hrl").
-include("team.hrl").
-include("def_module.hrl").
-include("attr.hrl").

-export([
        onhook_login/1,             %% 上线处理
        onhook_relogin/2,           %% 重连处理
        onhook_logout/2,            %% 下线处理
        delay_stop/1,               %% 延迟登出
        use_onhook_goods/3,         %% 使用离线挂机类道具
        add_onhook_time/2,          %% 离线挂机加时间接口
        update_onhook_setting/2,    %% 离线挂机设置保存
        update_redemption_exp/4,    %% 更新离线赎回经验
        update_exp_list/3,          %% 更新挂机经验
        check_onhook_type/2,        %% 检查各种类型的设置
        check_auto_pickup_setting/3,%% 检查自动拾取功能设置
        check_is_can_onhook/1,      %% 检查是否可以离线挂机
        check_auto_revive/5,        %% 检查玩家自动复活
        get_onhook_config/1,        %% 常量配置
        onhook_equips_angle_devil/1,%% 装备恶魔
        calc_onhook_pickup_goods/2, %% 统计掉落的数据
        calc_onhook_revive_data/4,  %% 统计复活的数据
        enter_onhook_team/2,        %% 进入离线挂机队伍
        create_onhook_team/1,       %% 创建离线挂机组队
        onhook_auto_devour_equips/1,%% 自动吞噬
        onhook_auto_sell_equips/1   %% 自动出售
        , onhook_start_gc/2         %% 进入离线挂机以后每半个小时gc一次
        , add_exp/2
    ]).

-export([rand_a_outside_scene/2, calc_gold_drop_items/2]).

-compile(export_all).

%% --------------------------- 上线、下线处理 ---------------------------
onhook_login(Ps) -> Ps#player_status{onhook = #status_onhook{}}.
    % #player_status{
    %     id = RoleId, figure = #figure{lv = RoleLv},
    %     hightest_combat_power = HightestCombatPower, last_logout_time = LastLogoutTime, socket = Socket} = Ps,
    % SQL = io_lib:format(?SQL_ROLE_ONHOOK_SELECT, [RoleId]),
    % case db:get_row(SQL) of
    %     [OnhookTime, BSetting, Lv, Exp, PetExp, CostOnHookTime, DevourEquips, BPickUpGoods, 
    %             Clv, CExp, CCostOnHookTime, CDevourEquips, BCPickUpGoods,
    %             BReviveData, _StartTime, EndTime, RedemptionExp, RedemptionGold, RedemptionTime, BExpList, GetCount] ->
    %         OnhookSetting = case util:bitstring_to_term(BSetting) of
    %             undefined -> ?DEF_ONHOOK;
    %             OnhookSetting1 ->
    %                 case lists:keyfind(?AUTO_ED_DEVOUR, 1, OnhookSetting1) of 
    %                     false -> [{?AUTO_ED_DEVOUR, 1}|OnhookSetting1];
    %                     _ -> OnhookSetting1
    %                 end
    %         end,
    %         case util:bitstring_to_term(BPickUpGoods) of undefined -> PickUpGoods = []; PickUpGoods -> skip end,
    %         case util:bitstring_to_term(BReviveData) of undefined -> ReviveData = []; ReviveData -> skip end,
    %         case util:bitstring_to_term(BExpList) of undefined -> ExpList = []; ExpList -> skip end,
    %         case util:bitstring_to_term(BCPickUpGoods) of undefined -> CPickUpGoods = []; CPickUpGoods -> skip end,
    %         NowTime = utime:unixtime(),
    %         % 自动登录,保留消耗
    %         case Socket == none of
    %             true -> 
    %                 NewClv = ?IF(Clv==0, Lv, Clv), NewCExp = CExp+Exp, NewCCostOnHookTime = CostOnHookTime+CCostOnHookTime, 
    %                 NewCDevourEquips = DevourEquips+CDevourEquips, 
    %                 NewCPickUpGoods = ulists:kv_list_plus_extra([PickUpGoods, CPickUpGoods]),
    %                 NewExpList = calc_exp_list_on_onhook(ExpList, NowTime, LastLogoutTime);
    %             false -> 
    %                 NewClv = 0, NewCExp = 0, NewCCostOnHookTime = 0, NewCDevourEquips = 0, NewCPickUpGoods = [], 
    %                 NewExpList = calc_exp_list(ExpList, LastLogoutTime)
    %         end,
    %         %% 记录日志
    %         case Clv == 0 of
    %             true -> NewPickGoods = PickUpGoods;
    %             false -> NewPickGoods = ulists:kv_list_plus_extra([PickUpGoods, CPickUpGoods])
    %         end,
    %         if
    %             CostOnHookTime == 0 -> skip;
    %             Socket == none -> skip;
    %             true -> lib_log_api:log_onhook_result(RoleId, Lv, Exp, PetExp, CostOnHookTime, DevourEquips, BPickUpGoods, NowTime)
    %         end,
    %         %% 发送结算界面
    %         if
    %             CostOnHookTime+CCostOnHookTime > ?ONHOOK_RESULT_SEND_TIME-> %% 玩家离线挂机时间大于0
    %                 send_onhook_revive_mail(RoleId, ReviveData),
    %                 case Clv == 0 of
    %                     true -> Args = [OnhookTime, Lv, Exp, PetExp, CostOnHookTime, DevourEquips, NewPickGoods];
    %                     false -> Args = [OnhookTime, Clv, CExp+Exp, PetExp, CostOnHookTime+CCostOnHookTime, DevourEquips+CDevourEquips, NewPickGoods]
    %                 end,
    %                 % ?MYLOG("hjhonhookdrop", "onhook_login Id:~p PickUpGoods:~p, CPickUpGoods:~p, NewPickGoods:~p ~n", [RoleId, PickUpGoods, CPickUpGoods, NewPickGoods]),
    %                 % ?MYLOG("hjhonhook2", "onhook_login RoleId:~p Args:~p ~n", [RoleId, Args]),
    %                 {ok, Bin} = pt_132:write(13202, Args),
    %                 spawn(fun() -> timer:sleep(?ONHOOK_RESULT_TIME*1000), lib_server_send:send_to_uid(RoleId, Bin) end);
    %             true ->
    %                 skip
    %         end,
    %         % 经验补全
    %         case Socket == none of
    %             true -> skip;
    %             false ->
    %                 case Clv == 0 of
    %                     true -> lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, lib_compensate_exp, compensate, [CostOnHookTime, Exp]);
    %                     false -> lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, lib_compensate_exp, compensate, [CostOnHookTime+CCostOnHookTime, CExp+Exp])
    %                 end
    %         end,

    %         %% 离线经验赎回
    %         RedemptionLv = get_onhook_config(redemption_lv),
    %         if
    %             RoleLv < RedemptionLv -> %% 等级小于找回等级
    %                 OnhookStatus = #status_onhook{onhook_time = OnhookTime, onhook_setting = OnhookSetting, exp_list = NewExpList, get_count = GetCount},
    %                 Ps#player_status{onhook = OnhookStatus};
    %             true ->
    %                 %% 玩家下线大于10分钟才开始计算经验
    %                 GapTime = get_onhook_config(redemption_time),
    %                 %% 玩家下线时间和玩家
    %                 %% SpanTime = ?IF(EndTime > LastLogoutTime, NowTime - EndTime, NowTime - LastLogoutTime),
    %                 SpanTime = NowTime - LastLogoutTime,
    %                 OnhookExp = lib_onhook_offline:get_onhook_exp(RoleLv, HightestCombatPower),
    %                 {NewRedemptionExp, NewRedemptionGold, NewRedemptionTime} =
    %                     if
    %                         (LastLogoutTime == 0 andalso EndTime == 0) orelse %% 按道理不会出现
    %                                 OnhookExp == 0 orelse SpanTime < GapTime -> 
    %                         %% (RedemptionExp =/= 0 andalso NowTime - RedemptionTime < ?ONE_DAY_SECONDS*2) ->
    %                             {RedemptionExp, RedemptionGold, RedemptionTime};
    %                         true ->
    %                             TMin = (SpanTime - GapTime) div 60,
    %                             MaxMin = get_onhook_config(Ps, redemption_max_min),
    %                             RealMiin = min(TMin, MaxMin),
    %                             RExp = RealMiin * OnhookExp, %% 最好累加20个小时的经验
    %                             if
    %                                 RedemptionExp >= RExp -> %% 经验取每次登录的最大值
    %                                     {RedemptionExp, RedemptionGold, RedemptionTime};
    %                                 true ->
    %                                     %% 相同等级一个小时8个钻
    %                                     RExpGold = max(round(RealMiin/8 * min(RoleLv/300, 1)), 5),
    %                                     update_redemption_exp(RoleId, RExp, RExpGold, NowTime),
    %                                     {RExp, RExpGold, NowTime}
    %                             end
    %                     end,
    %                 % ?IF(Ps#player_status.id == 4294967442, 
    %                 %     ?MYLOG("hjhonhooktime", "onhook_login Socket:~p NewClv:~p NewCExp:~p NewCCostOnHookTime:~p NewCDevourEquips:~p NewCPickUpGoods:~p CostOnHookTime:~p~n", 
    %                 %         [Socket, NewClv, NewCExp, NewCCostOnHookTime, NewCDevourEquips, NewCPickUpGoods, CostOnHookTime]), skip),
    %                 OnhookStatus = #status_onhook{
    %                     onhook_time = OnhookTime,
    %                     onhook_setting = OnhookSetting,
    %                     redemption_exp = NewRedemptionExp,
    %                     redemption_gold = NewRedemptionGold,
    %                     redemption_time = NewRedemptionTime, 
    %                     c_lv = NewClv,
    %                     c_exp = NewCExp,
    %                     c_cost_onhook_time = NewCCostOnHookTime,
    %                     c_auto_devour_equips = NewCDevourEquips,
    %                     c_auto_pickup_goods = NewCPickUpGoods,
    %                     exp_list = NewExpList, 
    %                     get_count = GetCount
    %                     },
    %                 update_onhook_status(RoleId, OnhookStatus),
    %                 Ps#player_status{onhook = OnhookStatus}
    %         end;
    %     _ ->
    %         OnHook = #status_onhook{onhook_time = ?ONHOOK_CREATE_TIME, onhook_setting = ?DEF_ONHOOK},
    %         insert_onhook_status(RoleId, OnHook),
    %         Ps#player_status{onhook = OnHook}
    % end.

%% 玩家重连离线数据处理
onhook_relogin(_Online, Ps) -> Ps.
    % % ?MYLOG("hjhonhook", "onhook_relogin Online Id:~p ~n", [Ps#player_status.id]),
    % if
    %     Online == ?ONLINE_OFF_ONHOOK ->
    %         #player_status{id = RoleId, onhook = Onhook} = Ps,
    %         NowTime = utime:unixtime(),
    %         #status_onhook{
    %             onhook_time = OnhookTime, onhook_setting = OnhookSetting,
    %             onhook_btime = OnhookBTime, lv = Lv, exp = Exp, pet_exp = PetExp,
    %             cost_onhook_time = _CostOnhookTime, auto_devour_equips = DevourEquips, auto_pickup_goods = PickUpGoods, 
    %             c_lv = Clv, c_exp = CExp, c_cost_onhook_time = CCostOnHookTime, c_auto_devour_equips = CDevourEquips, c_auto_pickup_goods = CPickUpGoods,
    %             revive_data = ReviveData, redemption_exp = RedemptionExp, redemption_gold = RedemptionGold,
    %             redemption_time = RedemptionTime, exp_list = ExpList, get_count = GetCount
    %             } = Onhook,
    %         NewExpList = calc_exp_list(ExpList, NowTime),
    %         NewCostOnhookTime = max(0, NowTime-OnhookBTime),
    %         NewOnhookTime = max(0, OnhookTime-NewCostOnhookTime),
    %         lib_log_api:log_onhook(RoleId, ?ONHOOK_LOGIN, NewOnhookTime, NowTime),
    %         % ?IF(Ps#player_status.id == 4294967442, ?MYLOG("hjhonhooktime", "[NewOnhookTime, Lv, Exp, PetExp, NewCostOnhookTime, DevourEquips, PickUpGoods]:~w~n", 
    %         %     [[NewOnhookTime, Lv, Exp, PetExp, NewCostOnhookTime, DevourEquips, PickUpGoods]]), skip),
    %         % ?IF(Ps#player_status.id == 4294967442, ?MYLOG("hjhonhooktime", "[NewOnhookTime, Clv, CExp+Exp, PetExp, NewCostOnhookTime+CCostOnHookTime, DevourEquips+CDevourEquips, NewPickGoods]:~w~n", 
    %         %     [[NewOnhookTime, Clv, CExp+Exp, PetExp, NewCostOnhookTime+CCostOnHookTime, DevourEquips+CDevourEquips, ulists:kv_list_plus([PickUpGoods, CPickUpGoods])]]), skip),
    %         if
    %             OnhookBTime > 0 andalso NewCostOnhookTime > 0 -> %% 玩家离线挂机中
    %                 if
    %                     NewCostOnhookTime >= ?ONHOOK_RESULT_SEND_TIME ->
    %                         %% 发送复活数据邮件
    %                         send_onhook_revive_mail(RoleId, ReviveData),
    %                         case Clv == 0 of
    %                             true -> 
    %                                 NewPickGoods = PickUpGoods,
    %                                 Args = [NewOnhookTime, Lv, Exp, PetExp, NewCostOnhookTime, DevourEquips, PickUpGoods];
    %                             false ->
    %                                 NewPickGoods = ulists:kv_list_plus_extra([PickUpGoods, CPickUpGoods]), 
    %                                 Args = [NewOnhookTime, Clv, CExp+Exp, PetExp, NewCostOnhookTime+CCostOnHookTime, DevourEquips+CDevourEquips, NewPickGoods]
    %                         end,
    %                         % ?MYLOG("hjhonhookdrop", "onhook_relogin Id:~p PickUpGoods:~p, CPickUpGoods:~p, NewPickGoods:~p ~n", [RoleId, PickUpGoods, CPickUpGoods, NewPickGoods]),
    %                         %% 发送结算
    %                         {ok, Bin} = pt_132:write(13202, Args),
    %                         spawn(fun() ->
    %                             timer:sleep(?ONHOOK_RESULT_TIME*1000),
    %                             lib_server_send:send_to_uid(RoleId, Bin)
    %                         end);
    %                     true ->
    %                         NewPickGoods = PickUpGoods
    %                 end,

    %                 % 经验补全
    %                 case Clv == 0 of
    %                     true -> lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, lib_compensate_exp, compensate, [NewCostOnhookTime, Exp]);
    %                     false -> lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, lib_compensate_exp, compensate, [NewCostOnhookTime+CCostOnHookTime, CExp+Exp])
    %                 end,

    %                 %% 结果日志记录
    %                 lib_log_api:log_onhook_result(RoleId, Lv, Exp, PetExp, NewCostOnhookTime, DevourEquips, util:term_to_string(NewPickGoods), NowTime),

    %                 NewOnhookStatus = #status_onhook{
    %                     onhook_time = NewOnhookTime, onhook_setting = OnhookSetting,
    %                     redemption_exp = RedemptionExp, redemption_gold = RedemptionGold,
    %                     redemption_time = RedemptionTime, exp_list = NewExpList, get_count = GetCount},
    %                 update_onhook_status(RoleId, NewOnhookStatus),
    %                 Ps#player_status{onhook = NewOnhookStatus};
    %             true ->
    %                 NewOnhookStatus = #status_onhook{
    %                     onhook_time = NewOnhookTime, onhook_setting = OnhookSetting,
    %                     redemption_exp = RedemptionExp, redemption_gold = RedemptionGold,
    %                     redemption_time = RedemptionTime, exp_list = NewExpList, get_count = GetCount
    %                     },
    %                 update_onhook_status(RoleId, NewOnhookStatus),
    %                 Ps#player_status{onhook = NewOnhookStatus}
    %         end;
    %     true ->
    %         Ps
    % end.

%% 离线下线处理:保存离线玩家数据
onhook_logout(Ps, _LogoutType) -> Ps.
    % #player_status{id = RoleId, accid = AccId, accname = AccName, ip = Ip, source = Source,
    %                online = Online, onhook = OnHook, battle_attr = BA, figure = Figure} = Ps,
    % #status_onhook{onhook_time = OnhookTime, onhook_btime = OnhookBTime, cost_onhook_time = OldCOnhookTime} = OnHook,
    % IsShenHe = lib_shenhe_api:check_is_shenhe_ios(Source),
    % if
    %     IsShenHe -> skip;
    %     OnhookBTime == 0 -> %% 玩家没有开始挂机
    %         IsCanOnhook = check_is_can_onhook([{lv, Figure#figure.lv}, {onhook_time, OnhookTime}]),
    %         if  %% 玩家异常掉线的情况,进入离线挂机
    %             LogoutType == ?LOGOUT_LOG_FORBIDDEN orelse 
    %             LogoutType == ?LOGOUT_LOG_WAIGUA orelse LogoutType == ?LOGOUT_LOG_IP ->
    %                 ?ERR("RoleId LOGOUT_LOG_FORBIDDEN or LOGOUT_LOG_WAIGUA:~p~n", [[RoleId, LogoutType]]),
    %                 ok;
    %             IsCanOnhook andalso LogoutType == ?LOGOUT_LOG_ERROR->
    %                 mod_onhook_agent:add_to_onhook(RoleId, AccId, AccName, Ip);
    %             true ->
    %                 ok
    %         end,
    %         NewOnHook = OnHook#status_onhook{onhook_time = OnhookTime, cost_onhook_time = 0, onhook_etime = 0},
    %         update_onhook_status(RoleId, NewOnHook);
    %     true ->
    %         NowTime = utime:unixtime(),
    %         COnhookTime = ?IF(NowTime - OnhookBTime > OnhookTime, OnhookTime, NowTime - OnhookBTime) + OldCOnhookTime,
    %         NOnhookTime = max(0, OnhookTime - COnhookTime),
    %         NewOnHook = OnHook#status_onhook{
    %             onhook_time = NOnhookTime,
    %             cost_onhook_time = COnhookTime,
    %             onhook_etime = NowTime},
    %         % ?IF(Ps#player_status.id == 4294967442, ?MYLOG("hjhonhooktime", "onhook_logout NewOnHook:~p ~n", [NewOnHook]), skip),
    %         update_onhook_status(RoleId, NewOnHook),
    %         if
    %             LogoutType == ?LOGOUT_LOG_FORBIDDEN orelse LogoutType == ?LOGOUT_LOG_IP -> %% 封号
    %                 lib_log_api:log_onhook(RoleId, ?ONHOOK_FORBIDDEN, NOnhookTime, NowTime);
    %             LogoutType == ?LOGOUT_LOG_WAIGUA ->                                        %% 外挂
    %                 lib_log_api:log_onhook(RoleId, ?ONHOOK_WAIGUA, NOnhookTime, NowTime);
    %             LogoutType == ?LOGOUT_LOG_SERVER_STOP ->                                   %% 停服直接走db
    %                 SQL = io_lib:format(?SQL_LOG_ONHOOK, [RoleId, ?ONHOOK_SERVER_STOP, NOnhookTime, NowTime]),
    %                 db:execute(SQL);
    %             LogoutType == ?LOGOUT_LOG_ERROR andalso Online == ?ONLINE_OFF_ONHOOK ->   %% 异常报错直接退出
    %                 lib_log_api:log_onhook(RoleId, ?ONHOOK_OTHER, NOnhookTime, NowTime);
    %             Online == ?ONLINE_OFF_ONHOOK andalso BA#battle_attr.hp =< 0  ->           %% 离线挂机被杀死，没有复活
    %                 lib_log_api:log_onhook(RoleId, ?ONHOOK_DIE, NOnhookTime, NowTime);
    %             Online == ?ONLINE_OFF_ONHOOK andalso  NOnhookTime == 0 ->                 %% 没有离线挂机时间
    %                 lib_log_api:log_onhook(RoleId, ?ONHOOK_NO_TIME, NOnhookTime, NowTime);
    %             true ->
    %                 skip
    %         end
    % end.

%% 延迟登出
delay_stop(PS) -> PS.
    % #player_status{id = RoleId, onhook = OnHookStatus} = PS,
    % % 清除数据
    % NewOnHookStatus = OnHookStatus#status_onhook{exp_list = [], get_count = 0},
    % update_exp_list(RoleId, [], 0),
    % PS#player_status{onhook = NewOnHookStatus}.

%% 使用挂机时间卡
use_onhook_goods(_PS, _GoodsInfo, _GoodsNum) ->
    % case data_goods_effect:get(GoodsInfo#goods.goods_id) of
    %     #goods_effect{effect_list = EffectList} ->
    %         case lists:keyfind(onhook_time, 1, EffectList) of
    %             false -> {false, ?ERRCODE(missing_config)};
    %             {onhook_time, H} ->
    %                 #player_status{id = RoleId, onhook = OnhookStatus} = PS,
    %                 #status_onhook{onhook_time = OnhookTime} = OnhookStatus,
    %                 MaxHour = get_onhook_config(PS, onhook_max_hour),
    %                 if
    %                     OnhookTime >= 3600*MaxHour -> %% 大于20个小时不给使用离线时间卡
    %                         {false, ?ERRCODE(err150_onhook_time_enough)};
    %                     true ->
    %                         NewOnhookTime = min((H * GoodsNum) * 3600 + OnhookTime, 3600*MaxHour),
    %                         NewOnhookStatus = OnhookStatus#status_onhook{onhook_time = NewOnhookTime},
    %                         %% 更新日常界面上的挂机时间
    %                         lib_activitycalen:refresh_onhook_time(RoleId, NewOnhookTime),
    %                         update_onhook_time(RoleId, NewOnhookTime),
    %                         {ok, PS#player_status{onhook = NewOnhookStatus}}
    %                 end
    %         end;
    %     _ ->
    %         {false, ?ERRCODE(missing_config)}
    % end.
    {false, ?ERRCODE(missing_config)}.

%% 加挂机时间接口
add_onhook_time(PS, _H) -> PS.
    % #player_status{id = RoleId, onhook = OnhookStatus} = PS,
    % #status_onhook{onhook_time = OnhookTime} = OnhookStatus,
    % MaxHour = get_onhook_config(PS, onhook_max_hour),
    % NewOnhookTime = min(H * 3600 + OnhookTime, 3600*MaxHour),
    % NewOnhookStatus = OnhookStatus#status_onhook{onhook_time = NewOnhookTime},
    % %% 更新日常界面上的挂机时间
    % lib_activitycalen:refresh_onhook_time(RoleId, NewOnhookTime),
    % update_onhook_time(RoleId, NewOnhookTime),
    % PS#player_status{onhook = NewOnhookStatus}.


%% 过滤挂机设置
check_auto_pickup_setting(_Online, OnHook, GoodsTypeId)->
    case data_goods_type:get(GoodsTypeId) of
        #ets_goods_type{type = ?GOODS_TYPE_EQUIP, color = Color} ->
            if
                Color == ?GREEN -> check_onhook_type(OnHook, auto_pkup_g);
                Color == ?BLUE  -> check_onhook_type(OnHook, auto_pkup_b);
                Color == ?PURPLE-> check_onhook_type(OnHook, auto_pkup_p);
                true            -> check_onhook_type(OnHook, auto_pkup_o)
            end;
        _ -> true
    end.

%% 检查挂机设置
check_onhook_type(_OnhookStatus, auto_team) -> false;
check_onhook_type(_OnhookStatus, auto_sell) -> false;
check_onhook_type(_OnhookStatus, auto_pkup_g) -> true;
check_onhook_type(_OnhookStatus, auto_pkup_b) -> true;
check_onhook_type(_OnhookStatus, auto_pkup_p) -> true;
check_onhook_type(_OnhookStatus, auto_pkup_o) -> true;
check_onhook_type(_OnhookStatus, auto_devour) -> true;
check_onhook_type(_OnhookStatus, auto_revive) -> true;
check_onhook_type(OnhookStatus, Type) ->
    #status_onhook{onhook_setting = OnhookSetting} = OnhookStatus,
    RType = case Type of
        auto_revive -> ?AUTO_REVIVE;
        auto_sell ->   ?AUTO_SELL;
        auto_devour -> ?AUTO_DEVOUR;
        auto_pkup_g -> ?AUTO_GREEN;
        auto_pkup_b -> ?AUTO_BLUE;
        auto_pkup_p -> ?AUTO_PURPLE;
        auto_pkup_o -> ?AUTO_ORANGE;
        auto_team   -> ?AUTO_TEAM;
        _ -> Type
    end,
    case lists:keyfind(RType, 1, OnhookSetting) of
        {_, 1} -> true;
        _R  -> false
    end.

%% 离线挂机主动装备恶魔
onhook_equips_angle_devil(Ps)->
    #player_status{id = RoleId} = Ps,
    GoodsStatus = lib_goods_do:get_goods_status(),
    #goods_status{dict = Dict} = GoodsStatus,
    NowTime = utime:unixtime(),
    case lib_goods_util:get_goods_by_cell(RoleId, ?GOODS_LOC_EQUIP, ?EQUIP_ANGLE_DEVIL, Dict) of
        #goods{goods_id = GoodsId} when GoodsId == ?GOODS_ID_DEVIL ->
            Ps;
        _ ->
            case lib_goods_util:get_type_goods_list_expire_time(RoleId, ?GOODS_ID_DEVIL, ?GOODS_LOC_BAG, NowTime, Dict) of
                [] -> Ps;
                Lists ->
                    SortList = lists:keysort(#goods.expire_time, Lists),
                    #goods{id = GoodsId} = lists:last(SortList),
                    case lib_equip:equip(Ps, GoodsId) of
                        {true, _Res, _OldGoodsInfo, NewGoodsInfo, _Cell, NewPS} ->
                            {ok, NewPS2} = lib_player_event:dispatch(NewPS, ?EVENT_EQUIP, NewGoodsInfo),
                            lib_common_rank_api:reflash_rank_by_equipment(NewPS2),
                            mod_scene_agent:update(NewPS2, [{battle_attr, NewPS2#player_status.battle_attr}]),
                            NewPS2;
                        _R ->
                            Ps
                    end
            end
    end.

%% 统计离线拾取的物品
calc_onhook_pickup_goods(Ps, GoodsTypeIds) when is_list(GoodsTypeIds) ->
    % ?MYLOG("hjhonhookdrop", "calc_onhook_pickup_goods:~p ~n", [GoodsTypeIds]),
    F = fun({GoodsTypeId, _}, TmpPs) -> calc_onhook_pickup_goods(TmpPs, GoodsTypeId) end,
    lists:foldl(F, Ps, (GoodsTypeIds));
calc_onhook_pickup_goods(Ps, GoodsTypeId)->
    % ?MYLOG("hjhonhookdrop", "calc_onhook_pickup_goods:~p ~n", [GoodsTypeId]),
    #player_status{onhook = OnhookStatus} = Ps,
    #status_onhook{auto_pickup_goods = AutoPickupGoods} = OnhookStatus,
    case data_goods_type:get(GoodsTypeId) of
        #ets_goods_type{type = ?GOODS_TYPE_EQUIP, color = Color} when Color < ?GREEN ->
            Ps;
        % 其他物品全部统计
        #ets_goods_type{} ->
            NNum = case lists:keyfind(GoodsTypeId, 1 , AutoPickupGoods) of
                {_, Num} -> Num + 1;
                _ -> 1
            end,
            NAutoPickupGoods = lists:keystore(GoodsTypeId, 1, AutoPickupGoods, {GoodsTypeId, NNum}),
            NewOnhookStatus = OnhookStatus#status_onhook{auto_pickup_goods = NAutoPickupGoods},
            % ?MYLOG("hjhonhookdrop", "calc_onhook_pickup_goods Id:~p NAutoPickupGoods:~p ~n", [Ps#player_status.id, NAutoPickupGoods]),
            Ps#player_status{onhook = NewOnhookStatus};
        _ ->
            Ps
    end.

%% 统计离线挂机复活数据
calc_onhook_revive_data(ReviveStatus, OldStatus, AtterSign, RealName) ->
    #player_status{bgold = OBGold, gold = OGold} = OldStatus,
    #player_status{onhook = OnhookStatus, bgold = NBGold, gold = NGold} = ReviveStatus,
    #status_onhook{revive_data = ReviveData} = OnhookStatus,
    ReviveData1 = if
    AtterSign == ?BATTLE_SIGN_PLAYER orelse AtterSign == ?BATTLE_SIGN_MON->
        lists:keystore(kill, 1, ReviveData, {kill, RealName});
    true ->
        ReviveData
    end,
    UsedBGold = OBGold-NBGold,
    UsedGold = OGold-NGold,
    NewReviveData = case lists:keyfind(gold, 1, ReviveData1) of
        false ->
            [{gold, UsedBGold, UsedGold}, {count, 1}|ReviveData1];
        {_, UsedBGold1, UsedGold1} ->
            case lists:keyfind(count, 1, ReviveData1) of
                false -> 1;
                {_, DieCount} ->
                    E = {gold, UsedBGold+UsedBGold1, UsedGold+UsedGold1},
                    ReviveData2 = lists:keystore(gold, 1, ReviveData1, E),
                    lists:keystore(count, 1, ReviveData2, {count, DieCount+1})
            end
    end,
    ReviveStatus#player_status{onhook=OnhookStatus#status_onhook{revive_data = NewReviveData}}.

%% 发送挂机期间死亡邮件
send_onhook_revive_mail(_RoleId, _ReviveData) -> skip.
    % case lists:keyfind(count, 1, ReviveData) of
    %     false -> skip;
    %     {count, Count} ->
    %         case lists:keyfind(gold, 1, ReviveData) of
    %             false -> {BGold, Gold} = {0, 0};
    %             {gold, BGold, Gold} -> skip
    %         end,
    %         case lists:keyfind(kill, 1, ReviveData) of
    %             false -> Name = "";
    %             {kill, Name} -> skip
    %         end,
    %         lib_mail_api:send_sys_mail([RoleId], utext:get(184), utext:get(185, [Count, Name, BGold, Gold]), [])
    % end.

%% 进入离线挂机队伍
enter_onhook_team(Ps, TeamId) ->
    #player_status{onhook = OnhookStatus, team = Team, online = Online,
                   scene = Scene, copy_id = CopyId, y = Y,x = X} = Ps,
    IsAutoTeam = check_onhook_type(OnhookStatus, auto_team),
    if
        Online == 1 orelse IsAutoTeam == false -> {ok, Ps};
        true ->
            if
                Team#status_team.team_id =/= 0 -> {ok, Ps};
                true ->
                    MbInfo = lib_team_api:thing_to_mb(Ps),
                    mod_team:cast_to_team(TeamId,  {'invite_response', 1, MbInfo, [Scene, CopyId, X, Y]}),
                    {ok, Ps}
            end
    end.

%% 创建离线挂机队伍
create_onhook_team(Ps0) ->
    #player_status{figure = #figure{lv = Lv}, id = RoleId, scene = SceneId,
                   onhook = OnhookStatus,
                   team = #status_team{team_id=OldTeamId, reqlist = ReqList}} = Ps0,
    IsAutoTeam = check_onhook_type(OnhookStatus, auto_team),
    if
        IsAutoTeam == false ->
            Ps0;
        true ->
            Ps= lib_team:silent_cancel_team_match(Ps0),
            if
                ReqList =/= [] -> mod_team_enlist:clear_teams_reqlist_by_id(RoleId, ReqList);
                true -> ok
            end,
            CreateType = 1, TeamName="", JoinType=1, IsInvite=1,
            {TeamEnlist, LvMin, LvMax} = lib_team:get_onhook_target_type(SceneId),
            #team_enlist{activity_id = Type, subtype_id = SubId} = TeamEnlist,
            if
                OldTeamId /= 0 orelse Lv =< ?TEAM_NEED_LV -> Ps;
                true ->
                    TeamId = mod_team_create:get_new_id(),
                    Leader = lib_team_api:thing_to_mb(Ps),
                    {ok, TeamPid} = mod_team:start([TeamId, CreateType, Type, SubId, SceneId, TeamName, JoinType, IsInvite,
                                                    [Leader#mb{online = ?ONLINE_OFF_ONHOOK}], [{lv, [LvMin, LvMax]}]]),
                    %% 进入匹配队伍队列
                    mod_team:cast_to_team(TeamId, {'set_matching_state', RoleId, 1}),
                    lib_team:create_team_done(Ps, TeamId, TeamPid, Type)
            end
    end.

%% 离线挂机自动吞噬白绿蓝紫装（不包括项链、护符、手镯、戒指部位）
onhook_auto_devour_equips(Ps)->
    case lib_onhook:check_onhook_type(Ps#player_status.onhook, auto_devour) of
        false -> {ok, Ps};
        true ->
            Gs = lib_goods_do:get_goods_status(),
            case lib_goods_util:get_equip_list(Ps#player_status.id, ?GOODS_TYPE_EQUIP,
                    [?GOODS_LOC_BAG], [?WHITE, ?GREEN, ?BLUE, ?PURPLE], Gs#goods_status.dict) of
                [] -> {ok, Ps};
                EquipsList ->
                    {_DevourGoods, ExpGoods} = calc_auto_devour_equips(EquipsList, [], [], 0),
                    GoodsNum = lists:sum([Num||{_GoodsId, Num}<-ExpGoods]),
                    case GoodsNum > 0 of
                        true ->
                            case pp_goods:handle(15025, Ps, [ExpGoods]) of
                                {ok, NewPs} -> 
                                    #player_status{onhook = StatusOnhook} = NewPs,
                                    #status_onhook{auto_devour_equips = AutoDevourEquips} = StatusOnhook,
                                        NewStatusOnhook = StatusOnhook#status_onhook{
                                        auto_devour_equips = AutoDevourEquips+GoodsNum},
                                    {ok, battle_attr, NewPs#player_status{onhook = NewStatusOnhook}};
                                ok ->
                                    {ok, Ps}
                            end;
                        false ->
                            {ok, Ps}
                    end
            end
    end.

%% 离线挂机自动出售白装备
onhook_auto_sell_equips(Ps)->
    case lib_onhook:check_onhook_type(Ps#player_status.onhook, auto_sell) of
        false -> {ok, Ps};
        true ->
            Gs = lib_goods_do:get_goods_status(),
            case lib_goods_util:get_equip_list(Ps#player_status.id, ?GOODS_TYPE_EQUIP,
                                               ?GOODS_LOC_BAG, ?GREEN, Gs#goods_status.dict) of
                [] -> {ok, Ps};
                EquipsList ->
                    {SellGoods, Coin, SellCount} = calc_onhook_sell_equips(EquipsList, [], 0, 0),
                    if
                        SellGoods == [] -> {ok, Ps};
                        true ->
                            case lib_goods:sell_goods(Ps, Gs, [{?TYPE_COIN, 0, Coin}], SellGoods) of
                                {ok, NewGs, _UpdateGoodsL, _GoodsTypeList, RealMomeyList} ->
                                    lib_goods_do:set_goods_status(NewGs),
                                    NewPs = lib_goods_api:send_reward(Ps, RealMomeyList, sell_goods, 0),
                                    #player_status{onhook = StatusOnhook} = NewPs,
                                    %% 计算出售的绿装和计算金币
                                    #status_onhook{auto_pickup_goods = PickGoods} = StatusOnhook,
                                    NPickGoods = case lists:keyfind(99, 1, PickGoods) of %% 绿装出售数量
                                                     false -> [{99, SellCount}|PickGoods];
                                                     {_, OCount} -> [{99, SellCount+OCount}|lists:keydelete(99, 1, PickGoods)]
                                                 end,
                                    NewPickGoods = case lists:keyfind(?TYPE_COIN, 1, NPickGoods) of %% 金币数量
                                                       false -> [{?TYPE_COIN, Coin}|NPickGoods];
                                                       {_, OCoin} -> [{?TYPE_COIN, Coin+OCoin}|lists:keydelete(?TYPE_COIN, 1, NPickGoods)]
                                                   end,
                                    NewStatusOnhook = StatusOnhook#status_onhook{auto_pickup_goods = NewPickGoods},
                                    {ok, NewPs#player_status{onhook = NewStatusOnhook}};
                                Res ->
                                    ?ERR("sell_goods sell:~p", [Res]),
                                    {ok, Ps}
                            end
                    end
            end
    end.

%% 返回离线玩家进程gc定时器(先观察玩家没存才决定是否开启)
onhook_start_gc(RoleId, RolePid)->
    %% 直接gc不走打印
    erlang:garbage_collect(RolePid),
    %% lib_online:do_process_gc(RolePid, 3145728), %% 大于3m的就会触发回收
    erlang:send_after(600*1000, RolePid, {'onhook_start_gc', RoleId}).

%% ================================= private fun =================================
%% 插入数据
insert_onhook_status(RoleId, OnhookStatus)->
    #status_onhook{
       onhook_time = OnhookTime, onhook_setting = OnhookSetting, lv = Lv, exp = Exp,
       pet_exp = PetExp, cost_onhook_time = CostOnHookTime, auto_devour_equips =AutoDevourEquips,
       auto_pickup_goods =AutoPickUpGoods, revive_data = ReviveData, c_auto_pickup_goods = CPickUpGoods
      } = OnhookStatus,
    StrOnhookSetting = util:term_to_string(OnhookSetting),
    StrAutoPickUpGoods =  util:term_to_string(AutoPickUpGoods),
    StrReviveData =  util:term_to_string(ReviveData),
    StrCPickUpGoods =  util:term_to_string(CPickUpGoods),
    SQL = io_lib:format(?SQL_ROLE_ONHOOK_INSERT, [RoleId, OnhookTime, StrOnhookSetting, Lv, Exp, PetExp,
        CostOnHookTime, AutoDevourEquips, StrAutoPickUpGoods, StrReviveData, StrCPickUpGoods]),
    db:execute(SQL).

%% 整体更新
update_onhook_status(RoleId, OnhookStatus)->
    #status_onhook{
       onhook_time = OnhookTime, onhook_setting = OnhookSetting, lv = Lv, exp = Exp,
       pet_exp = PetExp, cost_onhook_time = CostOnHookTime, auto_devour_equips =AutoDevourEquips,
       auto_pickup_goods = AutoPickUpGoods, c_lv = CLv, c_exp = CExp, c_cost_onhook_time = CCostOnHookTime, 
       c_auto_devour_equips = CDevourEquips, c_auto_pickup_goods = CPickUpGoods, 
       revive_data = ReviveData, onhook_btime = OnhookBTime,
       onhook_etime = OnhookETime, exp_list = ExpList, get_count = GetCount
      } = OnhookStatus,
    % ?IF(RoleId == 4294967442, ?MYLOG("hjhonhook2", "update_onhook_status:~p ~n", [ExpList]), skip),
    % ?IF(RoleId == 4294967442 andalso CostOnHookTime == 0, tool:back_trace_to_file(), skip),
    StrOnhookSetting = util:term_to_string(OnhookSetting),
    StrAutoPickUpGoods = util:term_to_string(AutoPickUpGoods),
    StrCPickUpGoods = util:term_to_string(CPickUpGoods),
    StrReviveData = util:term_to_string(ReviveData),
    StrExpList = util:term_to_string(ExpList),
    SQL = io_lib:format(?SQL_ROLE_ONHOOK_UPDATE, [OnhookTime, StrOnhookSetting, Lv, Exp, PetExp, CostOnHookTime, AutoDevourEquips, 
        StrAutoPickUpGoods, CLv, CExp, CCostOnHookTime, CDevourEquips, StrCPickUpGoods,
        StrReviveData, OnhookBTime, OnhookETime, StrExpList, GetCount, RoleId]),
    db:execute(SQL).

%% 更新挂机设置
update_onhook_setting(RoleId, OnhookSetting)->
    Str = util:term_to_string(OnhookSetting),
    SQL = io_lib:format(?SQL_ROLE_ONHOOK_UPDATE_SETTING, [Str, RoleId]),
    db:execute(SQL).

%% 更新挂机时间
update_onhook_time(RoleId, OnhookTime)->
    db:execute(io_lib:format(?SQL_ROLE_ONHOOK_UPDATE_TIME, [OnhookTime, RoleId])).

%% 更新赎回经验
update_redemption_exp(RoleId, Exp, ExpGold, Time)->
    db:execute(io_lib:format(?SQL_ROLE_ONHOOK_UPDATE_REDEMPTION_EXP, [Exp, ExpGold, Time, RoleId])).

%% 更新离线挂机经验信息
update_exp_list(RoleId, ExpList, GetCount) ->
    Str = util:term_to_string(ExpList),
    db:execute(io_lib:format(?SQL_ROLE_ONHOOK_UPDATE_EXP_LIST, [Str, GetCount, RoleId])).

%% 计算30件出售装备
calc_onhook_sell_equips(_, SellGoods, Coin, 30) -> {SellGoods, Coin, 30};
calc_onhook_sell_equips([], SellGoods, Coin, Count) -> {SellGoods, Coin, Count};
calc_onhook_sell_equips([#goods{goods_id = GoodsId, num = Num} = GInfo|EquipsList], SellGoods, Coin, Count)->
    case data_goods:get_goods_sell_price(GoodsId) of
        {SellType, SellPrice} when SellType == ?TYPE_COIN ->
            calc_onhook_sell_equips(EquipsList, [{GInfo, Num}|SellGoods], Coin+round(SellPrice*Num), Count+1);
        _ ->
            calc_onhook_sell_equips(EquipsList, [{GInfo, Num}|SellGoods], Coin, Count+1)
    end;
calc_onhook_sell_equips([_GInfo|EquipsList], SellGoods, Coin, Count)->
    calc_onhook_sell_equips(EquipsList, SellGoods, Coin, Count).

%% 计算10件吞噬的装备
%% 过滤掉戒指手镯
calc_auto_devour_equips([], DevourGoods, ExpGoods, _Count) -> {DevourGoods, ExpGoods};
calc_auto_devour_equips(_EquipsList, DevourGoods, ExpGoods, 50) -> {DevourGoods, ExpGoods};
calc_auto_devour_equips([#goods{equip_type = EquipType, id = GoodId, num = Num} = GInfo|EquipsList], DevourGoods, ExpGoods, Count) ->
    FusionExp = lib_goods_check:get_goods_fusion_exp(GInfo),
    % ?INFO("FusionExp:~p EquipType:~p GoodId:~p ~n", [FusionExp, EquipType, GoodId]),
    if
        FusionExp =< 0 -> calc_auto_devour_equips(EquipsList, DevourGoods, ExpGoods, Count);
        EquipType == ?EQUIP_NECKLACE orelse EquipType == ?EQUIP_AMULET orelse EquipType == ?EQUIP_BRACELET orelse EquipType == ?EQUIP_RING ->
            calc_auto_devour_equips(EquipsList, DevourGoods, ExpGoods, Count);
        true ->
            NDevourGoods = [{GInfo, Num}|DevourGoods],
            NExpGoods    = [{GoodId, Num}|ExpGoods],
            calc_auto_devour_equips(EquipsList, NDevourGoods, NExpGoods, Count+1)
    end;
calc_auto_devour_equips([_|EquipsList], DevourGoods, ExpGoods, Count) ->
    calc_auto_devour_equips(EquipsList, DevourGoods, ExpGoods, Count).

%% 获取离线挂机的默认配置
get_onhook_config(Type)->
    case Type of
        %% 离线挂机
        can_onhook_lv -> 70;
        %% 离线挂机最小值
        can_onhook_time -> 60;
        %% 离线经验赎回
        redemption_lv -> 55;
        %% 离线经验赎回计算时间(秒)
        redemption_time -> 660;
        %% 挂机经验找回每小时的消耗
        onhook_redemption_exp_cost -> [{?TYPE_GOODS, 37020001, 1}];
        %% 挂机经验找回时间间隔(秒)
        onhook_redemption_exp_time -> 3600;
        _ -> 0
    end.

%% 获取离线挂机的默认配置
get_onhook_config(Player, Type) ->
    case Type of
        %% 挂机最大小时数
        onhook_max_hour -> 20 + lib_module_buff:get_offline_onhook_time(Player);
        %% 挂机经验找回的最大小时数
        onhook_redemption_exp_max_count -> 20 + lib_module_buff:get_offline_onhook_time(Player);
        %% 离线经验赎回的最大分钟(分):目前20小时,1200分钟
        redemption_max_min -> (20 + lib_module_buff:get_offline_onhook_time(Player))*3600;
        _ -> 0
    end.

%% 检查玩家是否可以离线挂机
check_is_can_onhook([]) -> true;
check_is_can_onhook([{onhook_time, OnhookTime}|CheckList]) ->
    DefValue = get_onhook_config(can_onhook_time),
    if
        OnhookTime < DefValue -> false;
        true -> check_is_can_onhook(CheckList)
    end;
check_is_can_onhook([{lv, Lv}|CheckList]) ->
    DefLv = get_onhook_config(can_onhook_lv),
    if
        Lv < DefLv -> false;
        true -> check_is_can_onhook(CheckList)
    end.

%% 检查玩家自动复活问题
check_auto_revive(_Online, SceneId, Sign, AttName, OldReviveRef) ->
    #ets_scene{type = SceneType} = data_scene:get(SceneId),
    % 只有在离线挂机的时候才复活
    if
        SceneType == ?SCENE_TYPE_OUTSIDE -> 
            util:send_after(OldReviveRef, 5000, self(), {'online_revive', Sign, AttName});
        true -> none
    end.

%% 增加经验
add_exp(Player, AddExp) ->
    #player_status{online = Online, goods_buff_exp_ratio = BuffExpRatio, onhook = OnHookStatus} = Player,
    #status_onhook{exp_list = ExpList} = OnHookStatus,
    MaxCount = get_onhook_config(Player, onhook_redemption_exp_max_count),
    if
        Online == ?ONLINE_OFF_ONHOOK andalso BuffExpRatio == 0 andalso length(ExpList) < MaxCount -> 
            NewExpList = add_exp_helper(ExpList, utime:unixtime(), AddExp, []),
            % ?IF(Player#player_status.id == 4294967442, ?MYLOG("hjhonhookexp", "add_exp ExpList:~p NewExpList:~p ~n", [ExpList, NewExpList]), skip),
            NewOnHookStatus = OnHookStatus#status_onhook{exp_list = NewExpList},
            Player#player_status{onhook = NewOnHookStatus};
        true ->
            Player
    end.

add_exp_helper([], NowTime, AddExp, ExpList) -> lists:reverse(ExpList) ++ [{NowTime, AddExp}];
add_exp_helper([{Time, Exp}|T], NowTime, AddExp, ExpList) ->
    TimeGap = get_onhook_config(onhook_redemption_exp_time),
    case NowTime - Time =< TimeGap of
        true -> lists:reverse(ExpList) ++ [{Time, Exp+AddExp}|T];
        false -> add_exp_helper(T, NowTime, AddExp, [{Time, Exp}|ExpList])
    end.

%% 计算经验列表
calc_exp_list(ExpList, NowTime) ->
    TimeGap = get_onhook_config(onhook_redemption_exp_time),
    [{Time, Exp}||{Time, Exp}<-ExpList, Time < NowTime - TimeGap].

%% 挂机补发经验
%% @test lib_onhook:calc_exp_list_on_onhook([{3600, 100}, {7200, 100}, {10800, 100}, {14400, 100}], 16000, 15000).
calc_exp_list_on_onhook(ExpList, NowTime, LastLogoutTime) ->
    TimeGap = get_onhook_config(onhook_redemption_exp_time),
    F = fun({Time, Exp}, List) -> 
        case Time < LastLogoutTime - TimeGap of
            true -> [{Time, Exp}|List];
            false -> 
                % 修正记录时间,不能小于经验开始记录时间
                NewTime = max(NowTime - (LastLogoutTime - Time), Time),
                % 不得大于当前时间
                NewTime2 = min(NewTime, NowTime),
                [{NewTime2, Exp}|List]
        end
    end,
    lists:keysort(1, lists:foldl(F, [], ExpList)).

%% -----------------------------------------------------------------
%% 主线挂机保留
%% -----------------------------------------------------------------

%% 主线挂机 随机一个野外场景
rand_a_outside_scene(Lv, {_, _, _, OldSceneInfo}=DefaultSceneInfo) ->
    SceneWeightL = data_onhook_main:get_onhook_scene(Lv),
    Sum = lists:sum([V ||{_, V} <- SceneWeightL]),
    Rand = urand:rand(1, Sum),
     F = fun({SceneId, Value}, TmpSum) -> 
            case Rand =< TmpSum+Value of
                true  -> SceneId;
                false -> {false, TmpSum+Value}
            end
    end,
    case rand_a_items_by_weight(SceneWeightL, F) of
        false -> DefaultSceneInfo;
        SceneId -> 
            case data_scene:get(SceneId) of
                #ets_scene{x=X, y=Y} -> {SceneId, X, Y, OldSceneInfo};
                _ -> DefaultSceneInfo
            end
    end.

rand_a_items_by_weight(List, F) -> rand_a_items_by_weight(List, F, 0).
rand_a_items_by_weight([H|T], F, Sum) -> 
    case F(H, Sum) of
        {false, NextSum} -> rand_a_items_by_weight(T, F, NextSum);
        Result -> Result
    end;
rand_a_items_by_weight([], _, _) -> false.

%% 计算扫荡掉落
%% return: [经验和金币object_list， 装备和道具object_list]
% calc_gold_drop_items(PS, Hours) when Hours > 0 andalso Hours < 5 -> 
%      Chapter = lib_enchantment_guard:get_max_chapter(PS), 
%      case data_onhook_main:get_onhook_drop(Chapter) of
%         #onhook_drop{origin_chapter=OriginChapter, coin=Coin0, coin_add=CoinAdd, exp=Exp0, exp_add=ExpAdd,
%             sdrop_num=SdropNum, static_award=StaticAward, edrop_num=EdropNum, equip_award_rule=EquipAwardRule, equip_award=EquipAward} -> 
        
%             CellNum = lib_goods_api:get_cell_num(PS, ?GOODS_LOC_EQUIP_BAG),
%             ExpRatio = lib_player:get_exp_add_ratio(PS),
%             CoinRatio = get_vip_ratio(PS),
%             Coin = round(Hours*(Coin0+max(0, (Chapter-OriginChapter)*CoinAdd))*CoinRatio),
%             Exp = round(Hours*(Exp0+max(0, (Chapter-OriginChapter)*ExpAdd))*ExpRatio),
%             Fstatic = fun(_, TmpL) -> {ok, StaticAward++TmpL} end,
%             {ok, StaticDropList} = util:for(1, SdropNum*Hours, Fstatic, []),

%             EquipDropList = calc_drop_equips(EquipAwardRule, EquipAward, EdropNum*Hours, CellNum),
%             %%cym
%             NewStaticDropList  =   ulists:object_list_plus([StaticDropList, []]),
%             NewEquipDropList = ulists:object_list_plus([EquipDropList, []]),
%             %%end
%             [[{?TYPE_EXP, 0, Exp}, {?TYPE_COIN, 0, Coin}], NewStaticDropList, NewEquipDropList ];
%         _ -> false
%     end;
calc_gold_drop_items(_PS, _) -> false.