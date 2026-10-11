%%%------------------------------------
%%% @Module  : mod_server_info
%%% @Author  : xyao
%%% @Email   : jiexiaowen@gmail.com
%%% @Created : 2011.12.16
%%% @Description: 角色info处理
%%%------------------------------------
-module(mod_server_info).
-export([handle_info/2]).
-include("server.hrl").
-include("common.hrl").
-include("battle.hrl").
-include("attr.hrl").
-include("predefine.hrl").
-include("def_fun.hrl").
-include("scene.hrl").
-include("def_event.hrl").
-include("vip.hrl").
-include("figure.hrl").
-include("holy_ghost.hrl").
-include("skill.hrl").
-include("rec_onhook.hrl").
-include("goods.hrl").
-include("def_goods.hrl").

%% 更新一般战斗信息
handle_info({'battle_info', BattleReturn}, Status) ->
    #player_status{battle_attr = BA, last_beatt_time = LastBeAttTime} = Status,
    case BA#battle_attr.hp > 0 of
        true ->
            #battle_return{
               hp = Hp,
               hurt = FullHurt,
               move_x = MoveX,
               move_y = MoveY,
               anger = _Anger,
               attr_buff_list = AttrBuffList,
               other_buff_list = OtherBuffList,
               atter = Atter,
               sign  = AtterSign
              } = BattleReturn,
            NewBeAttTime = ?IF(lib_battle:calc_real_sign(AtterSign)==?BATTLE_SIGN_PLAYER, utime:longunixtime(), LastBeAttTime),
            NewStatus = Status#player_status{
                          x = case MoveX == 0 of true -> Status#player_status.x; false -> MoveX end,
                          y = case MoveY == 0 of true -> Status#player_status.y; false -> MoveY end,
                          battle_attr = BA#battle_attr{hp=Hp, attr_buff_list=AttrBuffList,
                                                       other_buff_list=OtherBuffList},
                          last_beatt_time = NewBeAttTime
                         },
            %% if
            %%     %% 处理本服受到的伤害
            %%     true ->
            Hurt = min(FullHurt, BA#battle_attr.hp),
            NewStatus2 = lib_player:be_hurted(NewStatus, BattleReturn, Atter, AtterSign, Hurt),
            %% end,
            %% 玩家受击伤害后触发特殊主动技能
            lib_holy_ghost:check_holy_ghost_skill(NewStatus2, ?SKILL_BUFF_TG_TIME_DEFAF), %%
            {noreply, NewStatus2};
        false ->
            {noreply, Status}
    end;

%% 死亡信息处理
handle_info({'battle_info_die', BattleReturn}, Status) ->
    #player_status{battle_attr = BA, last_beatt_time = LastBeAttTime, online = Online, scene = SceneId, revive_ref = OldReviveRef} = Status,
    case BA#battle_attr.hp > 0 of
        true ->
            #battle_return{
               hurt = FullHurt,
               move_x = MoveX,
               move_y = MoveY,
               anger = _Anger,
               attr_buff_list = AttrBuffList,
               other_buff_list = OtherBuffList,
               hit_list = HitList,
               atter = Atter,
               sign = Sign
              } = BattleReturn,
            Status1 = Status#player_status{
                          x = case MoveX == 0 of true -> Status#player_status.x; false -> MoveX end,
                          y = case MoveY == 0 of true -> Status#player_status.y; false -> MoveY end,
                          battle_attr = BA#battle_attr{hp=0, attr_buff_list=AttrBuffList, other_buff_list=OtherBuffList},
                          last_beatt_time = ?IF(lib_battle:calc_real_sign(Sign)==?BATTLE_SIGN_PLAYER, utime:longunixtime(), LastBeAttTime)
                         },
            IsClustersScene = lib_scene:is_clusters_scene(Status1#player_status.scene),
            Maps = #{attersign => Sign, atter => Atter, hit => HitList},
            #battle_return_atter{id = AtterId} = Atter,
            {ok, NewStatus} = lib_player_event:dispatch(Status1, ?EVENT_PLAYER_DIE, Maps),
            lib_achievement_api:player_die_event(NewStatus, []),
            if
                BA#battle_attr.pk#pk.pk_value > 0 ->
                    lib_achievement_api:async_event(AtterId, lib_achievement_api, kill_red_name_event, []);
                true -> skip
            end,
            DieStatus = if
                IsClustersScene == true -> %% 跨服死亡处理
                    CalcDieStatus = lib_player:clusters_player_die(NewStatus, Sign, Atter, HitList),
                    %% return
                    CalcDieStatus;
                true -> %% 本服死亡处理
                    CalcDieStatus = lib_player:player_die(NewStatus, Sign, Atter, HitList),
                    Hurt = min(FullHurt, BA#battle_attr.hp),
                    lib_player:be_hurted(CalcDieStatus, BattleReturn, Atter, Sign, Hurt),
                    %% return
                    CalcDieStatus
            end,
            %% 判断是否自动买活
            #battle_return_atter{real_name = AttName} = Atter,
            ReviveRef = lib_onhook:check_auto_revive(Online, SceneId, Sign, AttName, OldReviveRef),
            {noreply, DieStatus#player_status{revive_ref = ReviveRef}};
        false ->
            {noreply, Status}
    end;

%% 攻击时触发特殊的其他主动技能(圣灵主动技能...)
handle_info({'trigger_special_active_skill'}, Status) ->
    lib_holy_ghost:check_holy_ghost_skill(Status, ?SKILL_BUFF_TG_TIME_ATTAF),
    {noreply, Status};

%% 设置战斗状态
handle_info({'battle_attr', BA}, Status) ->
    {noreply, Status#player_status{battle_attr = BA}};

%% 设置buff
handle_info({'buff', AttrBuffL, OtherBuffL}, Status) ->
    #player_status{battle_attr=BA} = Status,
    {noreply, Status#player_status{battle_attr=BA#battle_attr{attr_buff_list=AttrBuffL, other_buff_list=OtherBuffL}}};

%% 更新罪恶值+1,定时器自动-1
handle_info({'change_pk_value', Name, Value}, Status) when is_integer(Value) ->
    #player_status{id = RoleId, sid = Sid, battle_attr = #battle_attr{pk = Pk} = BA,
                   scene = SceneId, scene_pool_id = ScenePId, copy_id = CopyId, x = X, y = Y} = Status,
    case Value of
        0 -> {noreply, Status};
        _ ->
            NowTime = utime:unixtime(),
            #pk{pk_value = OPkValue, pk_value_ref = PkValueRef, pk_value_change_time = PVChangeTime} = Pk,
            NewPkValue = max(0, OPkValue + Value),
            if
                Value == 1 -> %% 增加一点红名
                    lib_mail_api:send_sys_mail([RoleId], utext:get(134), utext:get(135, [Name]), []);
                true ->
                    skip
            end,
            if
                NewPkValue == 0 ->
                    util:cancel_timer(PkValueRef),
                    NewPk = Pk#pk{pk_value = NewPkValue, pk_value_change_time = 0, pk_value_ref = undefined};

                NewPkValue == 1 orelse PkValueRef == undefined -> %% 第一次开始
                    util:cancel_timer(PkValueRef),
                    NPkValueRef = erlang:send_after(?RemovePkValue*1000, self(), {'change_pk_value', pk_value, -1}),
                    NewPk = Pk#pk{pk_value = NewPkValue, pk_value_change_time = NowTime, pk_value_ref = NPkValueRef};

                NowTime - PVChangeTime >= ?RemovePkValue -> %% 中间变更罪恶值
                    util:cancel_timer(PkValueRef),
                    NPkValueRef = erlang:send_after(?RemovePkValue*1000, self(), {'change_pk_value', pk_value, -1}),
                    NewPk = Pk#pk{pk_value = NewPkValue, pk_value_change_time = NowTime, pk_value_ref = NPkValueRef};
                true ->
                    NewPk = Pk#pk{pk_value = NewPkValue}
            end,
            #pk{pk_value_change_time = NewPkValueChangeTime} = NewPk,
            SQL = <<"update player_state set pk_value = ~w, pk_value_change_time = ~w where id = ~w">>,
            db:execute(io_lib:format(SQL, [NewPkValue, NewPkValueChangeTime, RoleId])),
            NewStatus = Status#player_status{battle_attr = BA#battle_attr{pk = NewPk}},
            lib_player:send_attribute_change_notify(NewStatus, ?NOTIFY_PK),
            mod_scene_agent:update(NewStatus, [{battle_attr, NewStatus#player_status.battle_attr}]),
            %% 告诉自己的pk值
            Args = ?IF(Name == pk_value, ["", 3, NewPkValue], [Name, 1, NewPkValue]),
            {ok, BinData} = pt_200:write(20014, Args),
            lib_server_send:send_to_sid(Sid, BinData),
            %% 广播pk值,让玩家场景变成红名
            if
                NewPkValue > 1 -> skip;
                true ->
                    {ok, Bin} = pt_200:write(20015, [RoleId, NewPkValue]),
                    lib_server_send:send_to_area_scene(SceneId, ScenePId, CopyId, X, Y, Bin)
            end,
            {noreply, NewStatus}
    end;


%% 功能超时处理
handle_info({'func_timer_out', Type, Args}, Status) ->
    case Type of
        designation -> %% 称号过期
            F = fun(DsgtId, PSTmp) -> {ok, PsTmp} = lib_designation:cancel_dsgt(PSTmp, DsgtId), PsTmp end,
            NewStatus = lists:foldl(F, Status, Args),
            {noreply, NewStatus};
        angle_devil -> %% 天使恶魔过期
            {ok, NewPs} = lib_goods_util:count_role_equip_attribute(Status),
            mod_scene_agent:update(NewPs, [{battle_attr, NewPs#player_status.battle_attr}]),
            lib_server_send:send_to_sid(NewPs#player_status.sid, pt_150, 15007, [Args]),
            {noreply, NewPs};
        holyghost_illu -> %% 圣灵幻形过期
            F = fun(IlluId, PSTmp) -> lib_holy_ghost:cancel_illu(PSTmp, IlluId) end,
            NewStatus = lists:foldl(F, Status, Args),
            {noreply, NewStatus};
        _Type ->
            ?ERR("func_timer_out error type:~p~n", [_Type]),
            {noreply, Status}
    end;
%% TODO: VIP
%% vip过期时处理函数
%%handle_info({timeout, _TimeRef, {vip_timeout, Type}}, Status) ->
%%    VipStatus = Status#player_status.vip_status,
%%    #vip_status{endtime = EndTime, lv = CurVipLv} = VipStatus,
%%    case EndTime > utime:unixtime() of
%%        true ->
%%            {noreply, Status};
%%        false ->
%%            lib_log_api:log_vip_status(Status#player_status.id, CurVipLv, ?NO_PROPS, ?OVERDUE_VIP, EndTime),
%%            case Type of
%%                ?VIP_TIME_OUT ->
%%                    RemoveVipBuffVipStatus = VipStatus#vip_status{attr = [], exp_buff = 0},
%%                    Figure = Status#player_status.figure,
%%                    NewFigure = Figure#figure{vip = 0},
%%                    RemoveVipBuffStatus = Status#player_status{vip_status = RemoveVipBuffVipStatus,figure = NewFigure},
%%                    lib_server_send:send_to_sid(RemoveVipBuffStatus#player_status.sid, pt_450, 45003, [?VIP_TIME_OUT]),
%%                    {ok, NewPS} = lib_player_event:dispatch(RemoveVipBuffStatus, ?EVENT_VIP_TIME_OUT),
%%                    CountAttrPS = lib_player:count_player_attribute(NewPS),
%%                    lib_player:send_attribute_change_notify(CountAttrPS, ?NOTIFY_ATTR),
%%                    {noreply, CountAttrPS};
%%                ?VIP_EXPER_TIME_OUT ->
%%                    RemoveVipBuffVipStatus = VipStatus#vip_status{attr = [], exp_buff = 0},
%%                    RemoveVipBuffStatus = Status#player_status{vip_status = RemoveVipBuffVipStatus},
%%                    lib_server_send:send_to_sid(Status#player_status.sid, pt_450, 45003, [?VIP_EXPER_TIME_OUT]),
%%                    {noreply, RemoveVipBuffStatus}
%%            end
%%    end;

%% 通用回调
handle_info({'mod', Moudle, Method, Args},Status)->
    case apply(Moudle, Method, [Status|Args]) of
        NewStatus when is_record(NewStatus, player_status) ->
            {noreply, NewStatus};
        {ok, NewStatus} when is_record(NewStatus, player_status) ->
            {noreply, NewStatus};
        _ ->
            ?ERR("mod_server_info:mod error  Moudle = ~p, Method = ~p, Args = ~p ~n", [Moudle, Method, Args]),
            throw(error_player_status),
            {noreply, Status}
    end;

%% 离线自动挂机复活
handle_info({'online_revive', AtterSign, RealName}, Status) ->
    util:cancel_timer(Status#player_status.revive_ref),
    #ets_scene{type = _SceneType} = data_scene:get(Status#player_status.scene),
    if
        Status#player_status.battle_attr#battle_attr.hp > 0 -> {noreply, Status};
        Status#player_status.online == ?ONLINE_OFF_ONHOOK -> %% 离线自动复活
            case lib_onhook:check_onhook_type(Status#player_status.onhook, auto_revive) of
                false -> {noreply, Status};
                true ->
                    case lib_revive:revive(Status, ?REVIVE_ONHOOK) of
                        {0, ReviveTmpStatus} -> {noreply, ReviveTmpStatus};
                        {_, ReviveTmpStatus} ->
                            OnhookPs = lib_onhook:calc_onhook_revive_data(ReviveTmpStatus, Status, AtterSign, RealName),
                            {ok, LoadSceneStatus} = pp_scene:handle(12002, OnhookPs, ok),
                            {noreply, LoadSceneStatus}
                    end
            end;
        % (Status#player_status.online == ?ONLINE_OFF) orelse %% 离线下被杀回到出生点
        % (SceneType =/= ?SCENE_TYPE_NORMAL andalso SceneType =/= ?SCENE_TYPE_OUTSIDE) -> %% 不下线，但是在其他场景
        %     case lib_revive:revive(Status, 3) of
        %         {0, ReviveTmpStatus} -> {noreply, ReviveTmpStatus};
        %         {_, ReviveTmpStatus} ->
        %             {ok, LoadSceneStatus} = pp_scene:handle(12002, ReviveTmpStatus, ok),
        %             {noreply, LoadSceneStatus}
        %     end;
        Status#player_status.online == ?ONLINE_OFF ->
            case lib_revive:revive(Status, 3) of
                {0, ReviveTmpStatus} -> {noreply, ReviveTmpStatus};
                {_, ReviveTmpStatus} ->
                    {ok, LoadSceneStatus} = pp_scene:handle(12002, ReviveTmpStatus, ok),
                    {noreply, LoadSceneStatus}
            end;
        true -> %% 在线野外挂机自动买活
            % AutoRevive = lib_onhook:check_onhook_type(Status#player_status.onhook, auto_revive),
            % case get('onhook_online_revive') of
            %     undefined -> put('onhook_online_revive', 1), CanRevive = true;
            %     ReviveTime when ReviveTime < 20 -> put('onhook_online_revive', ReviveTime+1), CanRevive = true;
            %     _ -> CanRevive = false
            % end,
            % if
            %     AutoRevive == false orelse CanRevive == false -> {noreply, Status};
            %     true ->
            %         case lib_revive:revive(Status, 1) of
            %             {0, ReviveTmpStatus} -> {noreply, ReviveTmpStatus};
            %             {_, ReviveTmpStatus} ->
            %                 #player_status{id = RoleId, bgold = OBGold, gold = OGold} = Status,
            %                 #player_status{bgold = NBGold, gold = NGold} = ReviveTmpStatus,
            %                 C = utext:get(202, [RealName, OBGold-NBGold, OGold-NGold]),
            %                 lib_mail_api:send_sys_mail([RoleId], utext:get(201), C, []),
            %                 {ok, LoadSceneStatus} = pp_scene:handle(12002, ReviveTmpStatus, ok),
            %                 {noreply, LoadSceneStatus}
            %         end
            % end
            {noreply, Status}
    end;

%% 重新找一个新的挂机点
handle_info({'find_new_onhook_place'}, Status) ->
    case Status#player_status.online of
        ?ONLINE_OFF_ONHOOK ->
            #player_status{id = _RoleId, onhook = Onhook, scene = Scene, scene_pool_id = SPoolId} = Status,
            #status_onhook{onhook_sxy = {_OScene, OTId, _OX, _OY}} = Onhook,
            case lib_onhook:check_onhook_type(Onhook, ?ONHOOK_PLACE) of
                true -> {noreply, Status};
                false ->
                    case lib_onhook_offline:select_a_onhook_place(Status, Scene) of
                        {TId, TX, TY} -> %% 在推荐挂机场景
                            if
                                TId == OTId -> {noreply, Status};
                                true ->
                                    NewOnhook = Onhook#status_onhook{onhook_sxy = {Scene, TId, TX, TY}},
                                    NewPs = Status#player_status{x = TX, y = TY},
                                    lib_scene:leave_scene(NewPs),
                                    gen_server:cast(self(), {'set_data', [{load_scene_auto, 0}]}),
                                    %% 跟随发送坐标到组队进程
                                    lib_team_api:change_location(NewPs),
                                    {noreply, NewPs#player_status{fin_change_scene = 0, onhook = NewOnhook}}
                            end;

                        {TSceneId, TId, TX, TY} -> %% 切换到推荐挂机点
                            NewOnhook = Onhook#status_onhook{onhook_sxy = {TSceneId, TId, TX, TY}},
                            NewStatus = lib_scene:change_scene(Status, TSceneId, SPoolId, 0, TX, TY, false, []),
                            gen_server:cast(self(), {'set_data', [{load_scene_auto, 0}]}),
                            {noreply, NewStatus#player_status{onhook = NewOnhook}};

                        _ -> %% 找不到挂机点
                            ?ERR("can not find onhook place~n", []),
                            {noreply, Status}
                    end
            end;
        _ ->
            {noreply, Status}
    end;

%% 服务器离线挂机登录
handle_info({'onhook_agent_login'}, Status)->
    NowTime = utime:unixtime(),
    #player_status{id = RoleId, pid = Pid, onhook = OnhookStatus,
                   scene = Scene, scene_pool_id = PoolId, source = Source,
                   battle_attr = #battle_attr{hp_lim = HpLim, combat_power = Power},
                   figure = Figure} = Status,
    #figure{lv = Lv, guild_id = GuildId} = Figure,
    #status_onhook{onhook_time = OnhookTime} = OnhookStatus,
    case lib_shenhe_api:check_is_shenhe_ios(Source) of
        true -> %% 直接关闭进程
            catch mod_login:logout(Status, ?LOGOUT_LOG_NORMAL),
            {stop, normal, Status};
        false ->
            %% 离线挂机到时间结束,强制结束挂机
            Ref = erlang:send_after(OnhookTime*1000, Pid, {'timer_stop', 1, ?LOGOUT_LOG_AGENT_ONHOOK}),
            OnhookPlace
                = case lib_onhook_offline:select_a_onhook_place(Status, Scene) of
                      {TId, TX, TY} -> {Scene, TId, TX, TY};
                      {TSId, TId, TX, TY} -> {TSId, TId, TX, TY};
                      _ -> []
                  end,
            case OnhookPlace of  %% 在推荐挂机场景
                {NSceneId, NTId, NX, NY} ->
                    NewOnhookStatus = OnhookStatus#status_onhook{
                        onhook_btime = NowTime, onhook_sxy = {NSceneId, NTId, NX, NY},
                        lv = Lv, exp = 0, pet_exp = 0, cost_onhook_time = 0, auto_devour_equips = 0, auto_pickup_goods = [],
                        revive_data = []},
                    CopyId = 0,%?IF(lib_jail:is_in_jail(Scene), RoleId, 0),
                    % 离线状态
                    StatusAfOnline = Status#player_status{online = ?ONLINE_OFF_ONHOOK},
                    % 切场景
                    NewStatus = lib_scene:change_scene(StatusAfOnline, NSceneId, PoolId, CopyId, NX, NY, false, [{hp, HpLim}]),
                    gen_server:cast(self(), {'set_data', [{load_scene_auto, ?ONLINE_OFF_ONHOOK}]}),
                    %% 修改在线状态和记录开始挂机的时间点
                    mod_scene_agent:cast_to_scene(Scene, PoolId, {'online_flag', RoleId, ?ONLINE_OFF}),
                    mod_chat_agent:update(RoleId, [{online_flag, ?ONLINE_OFF_ONHOOK}]),
                    lib_role:update_role_show(RoleId, [{online_flag, ?ONLINE_OFF}]),
                    case GuildId > 0 of
                        false -> skip;
                        true -> mod_guild:update_guild_member_attr(RoleId, [{online_flag, ?ONLINE_OFF}])
                    end,
                    lib_player:update_online_flag_to_onhook(RoleId, NowTime),
                    %% 离线挂机日志
                    lib_log_api:log_onhook(RoleId, ?ONHOOK_STAER, OnhookTime, NowTime),
                    {noreply, NewStatus#player_status{fin_change_scene = 0, delay_logout_ref = Ref,
                                                      onhook = NewOnhookStatus}};
                _ -> %% 找不到挂机点，直接下线
                    ?ERR("onhook_agent_login can not find onhook place:~p~n", [[Scene, RoleId, Lv, Power]]),
                    lib_log_api:log_onhook(RoleId, ?ONHOOK_NO_PLACE, OnhookTime, NowTime),
                    case catch mod_login:logout(Status, ?LOGOUT_LOG_AGENT_ONHOOK_NO_PLACE) of
                        {'EXIT', _Reason} ->
                            catch ?ERR("mod_server_login:logout ERROR== LINE:~p Reason=~p~n", [?LINE, _Reason]);
                        _ -> skip
                    end,
                    {stop, normal, Status}
            end
    end;

%% 封号下线
handle_info({'limit_login', _RoleId, LogoutErrorType}, Status) ->
    case catch mod_login:logout(Status, LogoutErrorType) of
        {'EXIT', _Reason} ->
            catch ?ERR("mod_server_login:logout ERROR== LINE:~p Reason=~p~n", [?LINE, _Reason]);
        _ -> skip
    end,
    lib_server_send:send_to_sid(Status#player_status.sid, close),
    {stop, normal, Status};

%% 完成预设等级任务(审核调用,其他情况不能用)
handle_info( {'alpha_finish_lv_task'}, Status)->
    TaskArgs = lib_task_api:ps2task_args(Status),
    LastTaskId = mod_task:finish_lv_task(Status#player_status.tid, TaskArgs, 1, 0),
    NewPs = lib_player:count_player_attribute(Status#player_status{last_task_id =LastTaskId}),
    {noreply, NewPs};

handle_info({delay_refresh_and_clear_daily, [{M, F}|DelayResetMFAs]}, Status) ->
    NewStatus
    = case catch M:F(Status) of
        Status1 when is_record(Status, player_status) ->
            Status1;
        {'EXIT', Error} ->
            #player_status{id = RoleId, figure = #figure{name = Name}} = Status,
            ?ERR("delay_refresh_and_clear_daily error ~p~n", [Error]),
            ?WEBERR("delay_refresh_and_clear_daily error ~p~n", [Error], {RoleId, Name}),
            Status;
        _ ->
            Status
    end,
    case DelayResetMFAs of
        [] ->
            ok;
        _ ->
            erlang:send_after(?DELAY_DAILY_TIME_SPACE, self(), {delay_refresh_and_clear_daily, DelayResetMFAs})
    end,
    {noreply, NewStatus};

%% 特殊情况直接踢下线
handle_info({'can_not_receive_12005', Id}, Status) ->
    ?ERR("can_not_receive_12005_id:~p~n", [[Id, Status#player_status.sid, Status#player_status.socket]]),
    {noreply, Status};

%% 删除神庙玩家旧数据秘籍
handle_info({'delete_temple_scene_user', TargetScene}, Status)->
    #player_status{id = RoleId, scene = Scene} = Status,
    if
        TargetScene == Scene -> skip;
        true -> mod_scene_agent:cast_to_scene(TargetScene, 0, {'delete_temple_scene_user', RoleId})
    end,
    {noreply, Status};

handle_info({'role_check_figure_time', TypeTmp, IdTmp}, Status) ->
    NewStatus = lib_mount:clear_figure(Status,TypeTmp, IdTmp),
    {noreply, NewStatus};

%% 玩家进程gc定时器
handle_info({'onhook_start_gc', RoleId}, Status) ->
    if
        RoleId =/= Status#player_status.id orelse
        Status#player_status.online == ?ONLINE_ON -> {noreply, Status};
        true ->
            OnhookGcRef = lib_onhook:onhook_start_gc(RoleId, self()),
            {noreply, Status#player_status{onhook_gc_ref = OnhookGcRef}}
    end;

%% 修复离线挂机
handle_info({'onhook_fix_ref', CheckOnhookLv, CheckOnhookExp, CheckRoleLv, CheckRoleExp}, Status) ->
    NewStatus = lib_onhook_offline:onhook_fix_ref(Status, CheckOnhookLv, CheckOnhookExp, CheckRoleLv, CheckRoleExp),
    {noreply, NewStatus};

%% 至尊vip体验定时器
handle_info({'supvip_ex_ref'}, Status) ->
    {ok, NewStatus} = lib_supreme_vip:supvip_ex_ref(Status),
    {noreply, NewStatus};

handle_info({'combat_ref', OldCombatPower}, Status) ->
    #player_status{pid = Pid, combat_ref = OldCombatRef, combat_power = CombatPower} = Status,
    if
        CombatPower =/= OldCombatPower ->
            lib_player:update_player_state_combat(Status, CombatPower);
        true ->
            skip
    end ,
    NewStatus = Status#player_status{combat_ref = util:send_after(OldCombatRef, 180000, Pid, {'combat_ref', CombatPower})},
    {noreply, NewStatus};

%% 清空坐骑伙伴祝福值定时器
handle_info({'clear_bless', TypeId}, Status) ->
    {ok, NewStatus} = lib_mount:clear_bless(Status, TypeId),
    {noreply, NewStatus};

% 自动分解符文
handle_info({'rune_auto_decompose'}, Status) ->
    #goods_status{player_id = RoleId, dict = Dict} = lib_goods_do:get_goods_status(),
    OneAttrRuneGoodsList = lib_rune:get_can_decompose_rune_goods(RoleId, Dict),
    GoodsNum = length(OneAttrRuneGoodsList),
    case GoodsNum >= ?RUNE_LIMIT_2 of
        true ->
            DecomposeGoodsList = lib_rune:get_rune_decompose_list(login, OneAttrRuneGoodsList, [?WHITE, ?GREEN, ?BLUE, ?PURPLE], lib_goods_util:get_goods_list(RoleId, ?GOODS_LOC_RUNE, Dict)),
            case DecomposeGoodsList =/= [] of
                true ->
                    case lib_goods_do:goods_decompose(Status, DecomposeGoodsList) of
                        [1, NewStatus, _] ->
                            RolePid = misc:get_player_process(RoleId),
                            lib_rune:start_rune_auto_decompose_timer(RolePid),
                            {noreply, NewStatus};
                        [ErrorCode, NewStatus, _] ->
                            ?ERR("rune_auto_decompose error:~p", [ErrorCode]),
                            {noreply, NewStatus}
                    end;
                false ->
                    {noreply, Status}
            end;
        false ->
            lib_rune:send_tips_by_email(RoleId),
            pp_goods:send_bag_goods_list(Status, ?GOODS_LOC_RUNE_BAG, server),
            {noreply, Status}
    end;


%% 自动分解源力
handle_info({'soul_auto_decompose'}, Status) ->
    #goods_status{player_id = RoleId, dict = Dict} = lib_goods_do:get_goods_status(),
    OneAttrSoulGoodsList = lib_soul:get_can_decompose_soul_goods(RoleId, Dict),
    GoodsNum = length(OneAttrSoulGoodsList),
    case GoodsNum >= ?SOUL_LIMIT_2 of
        true ->
            DecomposeGoodsList = lib_soul:get_soul_decompose_list(login, OneAttrSoulGoodsList, [?WHITE, ?GREEN, ?BLUE, ?PURPLE], lib_goods_util:get_goods_list(RoleId, ?GOODS_LOC_SOUL, Dict)),
            case DecomposeGoodsList =/= [] of
                true ->
                    case lib_goods_do:goods_decompose(Status, DecomposeGoodsList) of
                        [1, NewStatus, _] ->
                            RolePid = misc:get_player_process(RoleId),
                            lib_soul:start_soul_auto_decompose_timer(RolePid),
                            {noreply, NewStatus};
                        [ErrorCode, NewStatus, _] ->
                            ?ERR("soul_auto_decompose error:~p", [ErrorCode]),
                            {noreply, NewStatus}
                    end;
                false ->
                    {noreply, Status}
            end;
        false ->
            lib_soul:send_tips_by_email(RoleId),
            pp_goods:send_bag_goods_list(Status, ?GOODS_LOC_SOUL_BAG, server),
            {noreply, Status}
    end;

handle_info({fake_client_route, ProtoId, DataBin}, Status) ->
    Reply = lib_fake_client_proto:msg_routing(Status, ProtoId, DataBin),
    case Reply of
        {ok, NewStatus} when is_record(NewStatus, player_status) -> {noreply, NewStatus};
        NewStatus when is_record(NewStatus, player_status) -> {noreply, NewStatus};
        _ ->
            {noreply, Status}
    end;

handle_info({start_fake_client, OnhookModule}, Status) ->
    Reply = lib_fake_client:start_fake_client_do(Status, OnhookModule),
    case Reply of
        {stop, normal, NewStatus} when is_record(NewStatus, player_status) ->
            {stop, normal, NewStatus};
        {noreply, NewStatus} ->
            {noreply, NewStatus};
        _ ->
            {noreply, Status}
    end;
handle_info({start_fake_client2, OnhookModule}, Status) ->
    Reply = lib_fake_client:start_fake_client2(Status, OnhookModule),
    case Reply of
        {noreply, NewStatus} ->
            {noreply, NewStatus};
        _ ->
            {noreply, Status}
    end;
handle_info({close_fake_client, Msg}, Status) ->
    Reply = lib_fake_client:close_fake_client2(Status, Msg),
    case Reply of
        {stop, normal, NewStatus} when is_record(NewStatus, player_status) ->
            {stop, normal, NewStatus};
        {noreply, NewStatus} ->
            {noreply, NewStatus};
        NewStatus when is_record(NewStatus, player_status) ->
            {noreply, NewStatus};
        _ ->
            {noreply, Status}
    end;


handle_info({'player_btree_router', ProtoId, DataBin}, Status) ->
    Reply = lib_player_behavior_data:router_msg(Status, ProtoId, DataBin),
    case Reply of
        {ok, NewStatus} when is_record(NewStatus, player_status) -> {noreply, NewStatus};
        NewStatus when is_record(NewStatus, player_status) -> {noreply, NewStatus};
        _ ->
            {noreply, Status}
    end;

handle_info('tick_behavior', Status) ->
    NewStatus = lib_player_behavior:tick_behavior(Status),
    {noreply, NewStatus};

handle_info({'behavior_msg', Msg}, Status) ->
    NewStatus = lib_player_behavior:behavior_msg(Status, Msg),
    {noreply, NewStatus};

handle_info({'send_delay_reward', ProtoId}, Status) ->
    NewStatus = lib_delay_reward:send_delay_reward(Status, ProtoId),
    {noreply, NewStatus};

%% 默认匹配
handle_info(_Info, Status) ->
    ?PRINT("not match info:~p~n", [_Info]),
    {noreply, Status}.
