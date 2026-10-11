%%%------------------------------------
%%% @Module  : mod_server
%%% @Author  : xyao
%%% @Email   : jiexiaowen@gmail.com
%%% @Created : 2011.06.14
%%% @Description: 角色处理
%%%------------------------------------
-module(mod_server).
-behaviour(gen_server).
-export([start/1, stop/1, server_stop/1, delay_stop/2, do_delay_stop/2, relogin/2,
         online_flag/1, do_return_value/2, get_ps/1, stop_socket/2]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
-export([routing/3]).
-include("server.hrl").
-include("common.hrl").
-include("attr.hrl").
-include("team.hrl").
-include("figure.hrl").
-include("predefine.hrl").
-include("scene.hrl").
-include("def_event.hrl").
-include("errcode.hrl").
-include("rec_onhook.hrl").
-include("def_fun.hrl").
-include("guild.hrl").
-include("boss.hrl").
-include("def_module.hrl").
-include("login.hrl").

%%开始
start(Args) ->
    gen_server:start_link(?MODULE, Args, []).

init(Args) ->
    %% process_flag(priority, max),
    PS = mod_login:server_login(Args),
    {ok, PS}.

%% 停止本游戏进程
stop(Pid) ->
    catch gen:call(Pid, '$gen_call', stop).

%% 判断socket是否一致
stop_socket(Pid, Socket)->
    catch gen:call(Pid, '$gen_call', {stop, Socket}).

%% 停服踢出玩家
server_stop(Pid) ->
    catch gen:call(Pid, '$gen_call', server_stop).

%% 测试用
get_ps(Id)->
    catch gen:call(misc:get_player_process(Id), '$gen_call', get_ps).

%% 延迟下线
delay_stop(Pid, Socket) ->
    gen_server:call(Pid, {'delay_stop', Socket}).

% 玩家重连登录
relogin(Pid, LoginParams) ->
    gen_server:call(Pid, {'relogin', LoginParams}, 5000).

%% 获取玩家的离线状态
online_flag(Pid)->
    gen_server:call(Pid, 'online_flag').

%% 游戏进程死掉修改状态(非正常掉线)
terminate(_Reason, _Status) ->
    handle_offline(_Reason, _Status),
    ok.

%% 停止游戏进程
handle_cast(stop, Status) ->
    case catch mod_login:logout(Status, ?LOGOUT_LOG_NORMAL) of
        {'EXIT', _Reason} ->
            catch ?ERR("mod_server_logout ERROR== LINE:~p Reason=~p~n", [?LINE, _Reason]);
        _ -> skip
    end,
    {stop, normal, Status};

% %% 延迟登出
% handle_cast({'delay_stop', Socket}, Status) ->
%     ?MYLOG("hjhonhook", "delay_stop RoleId:~p Socket:~p ~n", [Status#player_status.id, Socket]),
%     NewStatus = do_delay_stop(Status, Socket),
%     {noreply, NewStatus};

%% handle_cast信息处理
handle_cast(Event, Status) ->
    misc:monitor_pid(handle_cast, Event),
    mod_server_cast:handle_cast(Event, Status).

%% 延迟登出
handle_call({'delay_stop', Socket}, _From, Status) ->
    % ?MYLOG("hjhonhook", "delay_stop RoleId:~p Socket:~p ~n", [Status#player_status.id, Socket]),
    NewStatus = do_delay_stop(Status, Socket),
    {reply, true, NewStatus};

%% 玩家重新链接
handle_call({'relogin', LoginParams}, _From, OldStatus) ->
    #login_params{
        socket = Socket, ip = Ip, server_name = _ServerName, reg_server_id = _RegSId, c_source = CSource,
        trans_mod = TransMod, proto_mod = ProtoMod, ta_guest_id = TaGuestId, ta_device_id = TaDeviceId, is_simulator = IsSimulator,
        wx_scene = WxScene
    } = LoginParams,
    LoginTime = utime:unixtime(),
    #player_status{
        id = RoleId, accid = AccId, accname = AccName,
        team = Team, scene = Scene, scene_pool_id = SPID, x = X, y = Y, reconnect = Reconnect,
        battle_attr = BA, online = Online, delay_logout_ref = DelayRef,
        last_login_time = LastLoginTime, figure = Figure, last_task_id = LastTaskId,
        revive_ref = ReviveRef, onhook_gc_ref = OnhookGcRef, onhook_fix_ref = OnhookFixRef, combat_ref = CombatRef,
        cell_num = CellNum, storage_num = StorageNum, combat_power = CombatPower
        } = OldStatus,
    {NewTaSpclBase, NewTaSpclCommon} = ta_agent:get_ta_spcl_data(TaGuestId, TaDeviceId),
    % 部分参数要提前初始化
    Status = OldStatus#player_status{
        is_simulator = IsSimulator,
        ta_spcl_base = NewTaSpclBase,
        ta_spcl_common = NewTaSpclCommon
    },
    StatusGuild = lib_guild:load_status_guild(RoleId),
    Realm = StatusGuild#status_guild.realm,
    #figure{guild_id = GuildId, lv = Lv, vip_type = VipType, vip = VipLv, career = Career} = Figure,
    ModulePowerL = lib_player:get_module_power(Status, ?LOG_POWER_MODULES),
    lib_log_api:log_login(RoleId, Ip, AccId, AccName, ?RE_LOGIN, CombatPower, util:term_to_bitstring(ModulePowerL), Scene, X, Y, WxScene),
    %% 取消定时器
    util:cancel_timer(DelayRef),
    util:cancel_timer(ReviveRef),
    util:cancel_timer(OnhookGcRef),
    util:cancel_timer(OnhookFixRef),
    %% 记录玩家上线时间
    lib_login:update_login_data(RoleId, Ip, LoginTime),
    %% Status#player_status.sid ! {modify_sock, Socket},
    %% 重新初始化sid
    %% 先关闭旧的msg进程
    OldMsgPid = misc:whereis_name(global, misc:player_send_process_name(RoleId)),
    %% 顶号,关闭处理
    case is_pid(OldMsgPid) of
        true ->
            erlang:unlink(OldMsgPid),
            misc:unregister(global, misc:player_send_process_name(RoleId)),
            {ok, BinData} = pt_590:write(59004, 5),
            lib_server_send:send_to_sid(OldMsgPid, BinData),
            OldMsgPid ! {relogin_close};
        false ->
            % 异常情况:消息进程不存在
            ?ERR("relogin msgpid error RoleId:~p ~n", [RoleId])
    end,
    %% 重新创建进程
    SendMsgPid = spawn_link(fun() -> ProtoMod:send_msg(TransMod, Socket, true, none) end),
    misc:register(global, misc:player_send_process_name(RoleId), SendMsgPid),
    %% 更新各个进程的玩家在线状态
    if
        Online == ?ONLINE_ON ->
            %% 顶号处理
            lib_login:log_offline(Status, LoginTime, ?LOGOUT_LOG_DH),
            mod_scene_agent:cast_to_scene(Scene, SPID, {'online_flag', RoleId, ?ONLINE_ON}),
            skip;
        true ->
            mod_scene_agent:cast_to_scene(Scene, SPID, {'online_flag', RoleId, ?ONLINE_ON}),
            mod_team:cast_to_team(Team#status_team.team_id, {'online_flag', RoleId, ?ONLINE_ON}),
            %% 当玩家在线被顶替的时候，只有在离线挂机的时候才去计算玩家的在线人数
            %% mod_chat_agent:update(RoleId, [{online_flag, ?ONLINE_ON, Online}, {sid, Sid}]),
            lib_relationship:role_change_online_status(RoleId, Figure, ?ONLINE_ON),
            %% 更新后台在线标识
            lib_player:update_online_flag(RoleId, ?ONLINE_ON)
    end,
    lib_role:update_role_show(RoleId, [{last_login_time, LoginTime}, {online_flag, ?ONLINE_ON}]),
    case GuildId > 0 of
        false -> skip;
        true -> mod_guild:update_guild_member_attr(RoleId, [{online_flag, ?ONLINE_ON}, {last_login_time, LoginTime}])
    end,
    %% 部分功能数据重连时候进行初始化(防止意外丢失玩家在线缓存数据,导致任务,日常,聊天无法刷新)
    %% 重新加载日常数据和0点数据
    mod_daily:reload_daily(RoleId),
    %% 物品初始化-注意:如果功能有对物品数据第二次初始化,要把对应函数写在重连函数里面
    {GoodsStatus, StatusGoods} = lib_goods:login(RoleId, [Lv, VipType, VipLv, CellNum, StorageNum]),
    lib_goods_do:init_data(GoodsStatus, Career),
    %% pk状态重新计算
    #battle_attr{pk = PK} = BA,
    #pk{pk_status = PkStatus, pk_change_time = PkSChgTime,
        pk_value = PkValue,  pk_value_ref = PkValueRef,
        pk_value_change_time = PkVChgTime, pk_protect_time = PkProtectTime} = PK,
    util:cancel_timer(PkValueRef),
    NPkProtectTime = if
        Online == ?ONLINE_OFF_ONHOOK -> 0;
        true -> PkProtectTime
    end,
    NewPk = lib_player_record:pk_login(LoginTime, PkStatus, PkSChgTime, PkValue, PkVChgTime),
    ProtectTime = lib_protect:get_scene_protect_time(Status),
    NBA = BA#battle_attr{pk = NewPk#pk{pk_protect_time = NPkProtectTime, protect_time = ProtectTime}},
    %% 清除20次在线自动买活次数
    erase('onhook_online_revive'),
    % 重连赋值
    Reconnect1 = if
        Reconnect == ?NORMAL_LOGIN ->
            ?NORMAL_LOGIN;
        true ->
            ?RE_LOGIN
    end,
    ReloginStatus = Status#player_status{
        c_source = CSource,
        figure = Figure#figure{camp = Realm},
        online = ?ONLINE_ON, reconnect = Reconnect1, login_type = ?RE_LOGIN, last_login_time = LoginTime,
        login_time_before_last = LastLoginTime, delay_logout_ref = undefined,
        boss_tired = lib_boss:get_boss_tired(RoleId), sid = SendMsgPid,
        temple_boss_tired = lib_boss:get_temple_boss_tired(RoleId),
        status_adventure = lib_adventure:login(RoleId),
        guild = StatusGuild,
        phantom_tired = lib_boss:get_phantom_boss_tired(RoleId), goods = StatusGoods,
        revive_ref = undefined, battle_attr = NBA, socket = Socket, ip = tool:ip2bin(Ip)},
    %% 上线处理离线挂机数据
    OnhookPsStatus = lib_onhook:onhook_relogin(Online, ReloginStatus),
    %% 累计登陆统计(放在前面，其他模块可能会用到)
    LoginDaysStatus = lib_player_login_day:relogin(OnhookPsStatus),
    %% 护送
    HuSongPs = lib_husong:husong_login(LoginDaysStatus),
    %% 登陆有礼重连处理
    {_, SignPlayer} = lib_sign_reward_act:login_for_sign_reward(HuSongPs),
    %%   vip
    VipPS = lib_vip:after_login(SignPlayer),
    %% 惊喜礼包
    SurprisePs = lib_surprise_gift:login(VipPS),
    %% 充值活动修复
    WelfarePlayer = lib_recharge_act:repair_welfare(SurprisePs),
    %% 幻兽之域修复
    EudemonsLandPs = lib_eudemons_land:eudemons_boss_login(WelfarePlayer),
    %% 在线奖励
    OnlinePS = lib_online_reward:login(EudemonsLandPs),
    %% 龙纹熔炉
    DragonCruciblePS = lib_dragon_crucible:login(OnlinePS),
    %% 助战礼包
    RankGiftPs = lib_common_rank_gift:relogin(DragonCruciblePS),
    %% 龙纹
    DragonPS = lib_dragon:login(RankGiftPs, GoodsStatus),
%%    %%开服冲榜宝石修复
%%    lib_rush_rank_api:reflash_rank_by_stone_rush(DragonPS),
    %% 上线事件处理
    {ok, EvtStatus} = lib_player_event:dispatch(DragonPS, ?EVENT_RECONNECT, []),
    %% 派发上线延后事件
    lib_player_event:async_dispatch(RoleId, ?EVENT_LOGIN_CAST),
    %% 重连更新玩家缓存表
    mod_login:save_online(EvtStatus),
    mod_login:sync_mod_chat_agent(EvtStatus),
    %% 坐骑属性计算
    MountAttrPs = lib_mount:count_mount_attr(EvtStatus),
    MountAfterAttrPs = lib_mount:after_login(MountAttrPs),  % 计算真实战力
    %% 幻饰属性计算
    DecorAttrPs = lib_decoration:login(MountAfterAttrPs, GoodsStatus),
     %% 背饰
    BackDecraPS = lib_back_decoration:login(DecorAttrPs),
    %% 符文寻宝重新取数据库
    RuneHuntPS = lib_rune_hunt:login(BackDecraPS),
    %% 天启修复装备套装形象
    RevelationPS = lib_revelation_equip:re_login(RuneHuntPS),
    RevelationEquipPS = lib_revelation_equip:login(RevelationPS),
    %% 至尊vip
    SupVipPS = lib_supreme_vip:relogin(RevelationEquipPS),
    %% 快捷栏
    QuickbarPS = lib_skill:recalc_quickbar(SupVipPS),
    %% 远古奥术
    ArcanaPS = lib_arcana:relogin(QuickbarPS),
    lib_fashion_suit:init_conform_num_and_attr(ArcanaPS),
    %% 装备属性计算
    {ok, CountAttrPS} = lib_goods_util:count_role_equip_attribute(ArcanaPS),
     %% 属性计算
    %CountAttrPS = lib_player:count_player_attribute(RuneHuntPS),
    %%副本信息修复
    DungeonPS = lib_dungeon:login(CountAttrPS),
    %%日常预约
    ActSignUpPS = lib_act_sign_up:check_guild_war(DungeonPS),
    %%奖励找回
    ResourcePS = lib_resource_back:login(ActSignUpPS),
    %% 延迟发放奖励
    DelayRewardPs = lib_delay_reward:login(ResourcePS),
    %% 魔法阵
    lib_magic_circle:re_login(DelayRewardPs),
    lib_holy_spirit_battlefield:re_login(ResourcePS),
    %%重新请求属性加成
%%    lib_seacraft_daily:get_exp_attr(ActSignUpPS),
    SeaDailyPS = lib_seacraft_daily:re_login(ResourcePS),
    RechargeFirstPS = lib_recharge_first:relogin(SeaDailyPS),
    %% 推送礼包
    PushGiftPS = lib_push_gift:relogin(RechargeFirstPS),
    %% 合服的名字冲突发送改名卡道具
    SendRenameCardPs = lib_rename:conflict_send_rename_card(PushGiftPS),
    %%封测返回
    BetaReturnPS = lib_beta_recharge_return:relogin(SendRenameCardPs),
    % %% 任务重新加载
    mod_task:relogin(BetaReturnPS),
    % %% 无限层boss初始化 未完成任务才会初始化
    LastTaskId =< ?SPECIAL_BOSS_TASK_ID
        andalso mod_special_boss:boss_init(RoleId, Lv, ?BOSS_TYPE_SPECIAL),
    mod_special_boss:boss_init(RoleId, Lv, ?BOSS_TYPE_PHANTOM_PER),
    mod_special_boss:boss_init(RoleId, Lv, ?BOSS_TYPE_WORLD_PER),
    %% 邮件
    lib_mail:init_mail_dict(RoleId),
    %% 巅峰竞技容错
    lib_top_pk:re_login(BetaReturnPS),
    %% 嗨点任务重载
    lib_hi_point:login(BetaReturnPS),
    % lib_task_api:lv_up(DungeonPS),
    % 修复转生
    TurnPS = lib_reincarnation:repair(BetaReturnPS),
    %% 广告
    AdPS = lib_advertisement:login(TurnPS),
    %% 重登刷新战力排行榜
    lib_up_power:refresh_rush_rank_all(AdPS),
    GodPS = lib_god:reLogin(TurnPS),
    InvitePS = lib_invite:relogin(GodPS),
    % 离线挂机
    AfkPS = lib_afk:relogin(InvitePS, Online),
    % 托管处理
    BehaviorStatus = lib_player_behavior:relogin(AfkPS),
    % !!! 放到最后
    % 自动上坐骑
    AutoRidePs = lib_player:auto_change_ride_mount_status_slient(BehaviorStatus),
    % 修复血量
    RepairHpPS = lib_player:repair_hp(AutoRidePs),
    NewCombatRef = util:send_after(CombatRef, 180000, self(), {'combat_ref', RepairHpPS#player_status.combat_power}),
    lib_fake_client:relogin(RepairHpPS),
    %% 玩家展示, 保证求他信息加载完后调用
    lib_role:login(RepairHpPS),
    ta_agent_fire:role_login(RepairHpPS, RepairHpPS#player_status.source),
    lib_fairy_buy:role_login(RepairHpPS),
    {reply, true, RepairHpPS#player_status{combat_ref = NewCombatRef}};

%% 玩家在线的状态
handle_call('online_flag', _From, Status) ->
    {reply, Status#player_status.online, Status};

%% 玩家在线的状态
handle_call(get_ps, _From, Status) ->
    {reply, Status, Status};

%% 停止游戏进程
handle_call(stop, _From, Status) ->
    case catch mod_login:logout(Status, ?LOGOUT_LOG_NORMAL) of
        {'EXIT', _Reason} ->
            catch ?ERR("mod_server_login:logout ERROR== LINE:~p Reason=~p~n", [?LINE, _Reason]);
        _ -> skip
    end,
    {stop, normal, true, Status};

%% 停服停止游戏进程
handle_call(server_stop, _From, Status) ->
    case catch mod_login:logout(Status, ?LOGOUT_LOG_SERVER_STOP) of
        {'EXIT', _Reason} ->
            catch ?ERR("mod_server_login:logout ERROR== LINE:~p Reason=~p~n", [?LINE, _Reason]);
        _ -> skip
    end,
    {stop, normal, true, Status};

%% 同socket退出stop(暂时没有用)
handle_call({stop, Socket}, _From, Status) ->
    #player_status{socket = OldSocket} = Status,
    if
        Socket =:= OldSocket -> %% 同socket退出
            case catch mod_login:logout(Status, ?LOGOUT_LOG_SERVER_STOP) of
                {'EXIT', _Reason} ->
                    catch ?ERR("mod_server_login:logout ERROR== LINE:~p Reason=~p~n", [?LINE, _Reason]);
                _ -> skip
            end,
            {stop, normal, Status};
        true ->
            {reply, ok, Status}
    end;

%% 处理socket协议
%% cmd：命令号
%% data：协议体
handle_call({'SOCKET_EVENT', Cmd, Data}, _From, Status) ->
    %% 开启执行时间分析
    %% statistics(runtime),
    Res =
        case routing(Cmd, Status, Data) of
            {ok, Status1} when is_record(Status1, player_status) ->
                {reply, ok, Status1};
            {ok, V, Status1} when is_record(Status1, player_status) ->
                do_return_value(V, Status1),
                {reply, ok, Status1};
            {error, OtherReason} ->
                ?ERR("mod_server error Cmd:~p Data:~p~n Reason== ~p", [Cmd, Data, OtherReason]),
                {reply, ok, Status};
            {'EXIT', R} when is_record(Status, player_status)->
                ?ERR("mod_server 'EXIT' Cmd:~p Data:~p~n Reason== ~p", [Cmd, Data, R]),
                {reply, ok, Status};
            _R ->
                {reply, ok, Status}
        end,
    %% {_, Time} = statistics(runtime),
    %% case Time > 35 of
    %%     true ->
    %%         ?ERR("=====role_id = ~p Time ~p ms, cmd=~p, data=~p~n", [Status#player_status.id, Time, Cmd, Data]);
    %%     false ->
    %%         skip
    %% end,
    Res;

%% handle_call信息处理
handle_call(Event, From, Status) ->
    misc:monitor_pid(handle_call, Event),
    mod_server_call:handle_call(Event, From, Status).

%% handle_info信息处理:Force:是否强制下线
handle_info({'timer_stop', Force}, Status) ->
    handle_info({'timer_stop', Force, ?LOGOUT_LOG_NORMAL}, Status);

%% handle_info信息处理:Force:是否强制下线
handle_info({'timer_stop', Force, LogoutType}, Status) ->
    #player_status{
        id = _RoleId, online = Online, delay_logout_ref = ORef,
        onhook = OnhookStatus, figure = #figure{lv = Lv},
        team = #status_team{team_id = TeamId}
        } = Status,
    util:cancel_timer(ORef),
    case Online of
        ?ONLINE_ON -> {noreply, Status};
        _ ->
            #status_onhook{onhook_time = OnhookTime} = OnhookStatus,
            %% 小于1分钟和小于挂机等级
            IsCanOnhook = lib_onhook:check_is_can_onhook([{lv, Lv}, {onhook_time, OnhookTime}]),
            if
                IsCanOnhook == false orelse Force == 1 -> %% 没有挂机时间,直接退出,强制退出
                    % ?MYLOG("hjhonhook", "timer_stop Socket Id:~p IsCanOnhook:~p ~n", [_RoleId, IsCanOnhook]),
                    case catch mod_login:logout(Status, LogoutType) of
                        {'EXIT', _Reason} ->
                            catch ?ERR("mod_server_login:logout ERROR== LINE:~p Reason=~p~n", [?LINE, _Reason]);
                        _ -> skip
                    end,
                    {stop, normal, Status};
                true ->
                    %%  {ok, EvtStatus} = lib_player_event:dispatch(Status, ?EVENT_DISCONNECT_HOLD_END, ?LOGOUT_LOG_DELAY),
                    %% 玩家离开各种副本和活动处理
                    {ok, NewPS} = lib_player_logout:logout(Status, ?DELAY_LOGOUT),
                    if
                        TeamId > 0 andalso TeamId rem 2 == 0 -> %% 跨服队伍自动退出
                            lib_team_api:quit_team(Status, 1);
                        true ->
                            ok
                    end,
                    %% 触发推荐点挂机(确保玩家不会扎堆到一个房间)
                    RandTimeToOnhook = urand:rand(2000, 10000),
                    % 如果是普通登出类型，那么就转换成挂机退出类型
                    case LogoutType == ?LOGOUT_LOG_NORMAL of
                        true -> Ref = erlang:send_after(RandTimeToOnhook, self(), {'timer_to_onhook', ?LOGOUT_LOG_ONHOOK});
                        false -> Ref = erlang:send_after(RandTimeToOnhook, self(), {'timer_to_onhook', LogoutType})
                    end,
                    {noreply, NewPS#player_status{online = ?ONLINE_OFF, delay_logout_ref = Ref}}
            end
    end;

%% 开始离线挂机
handle_info('timer_to_onhook', Status) ->
    handle_info({'timer_to_onhook', ?LOGOUT_LOG_ONHOOK}, Status);

%% 开始离线挂机
handle_info({'timer_to_onhook', LogoutType}, Status) ->
    #player_status{
        id = RoleId, pid = Pid, online = Online, delay_logout_ref = ORef, onhook = OnhookStatus,
        scene = Scene, scene_pool_id = PoolId, battle_attr = #battle_attr{hp_lim = HpLim},
        figure = #figure{lv = Lv}, team = Team} = Status,
    util:cancel_timer(ORef),
    if
        Online == ?ONLINE_ON ->  {noreply, Status};
        true ->
            NowTime = utime:unixtime(),
            #status_onhook{onhook_time = OnhookTime} = OnhookStatus,
            %% 离线挂机到时间结束,强制结束挂机
            Ref = erlang:send_after((OnhookTime+1)*1000, Pid, {'timer_stop', 1, LogoutType}),
            TargetPlace = lib_onhook_offline:select_a_onhook_place(Status, Scene),
            case TargetPlace of
                false ->
                    catch ?ERR("can not find onhook place:~p~n", [Scene]),
                    lib_log_api:log_onhook(RoleId, ?ONHOOK_NO_PLACE, OnhookTime, NowTime),
                    if
                        LogoutType == ?LOGOUT_LOG_AGENT_ONHOOK -> NewLogoutType = ?LOGOUT_LOG_AGENT_ONHOOK_NO_PLACE;
                        true -> NewLogoutType = ?LOGOUT_LOG_ONHOOK_NO_PLACE
                    end,
                    case catch mod_login:logout(Status, NewLogoutType) of
                        {'EXIT', _Reason} ->
                            catch ?ERR("mod_server_login:logout ERROR== LINE:~p Reason=~p~n", [?LINE, _Reason]);
                        _ -> skip
                    end,
                    {stop, normal, Status};
                _ ->
                    case TargetPlace of
                        {TId, TX, TY} -> %% 在推荐挂机场景
                            TSid = Scene,
                            NewPs = Status#player_status{x = TX, y = TY};
                        {TSid, TId, TX, TY} ->
                            NewPs = lib_scene:change_scene(Status, TSid, PoolId, 0, TX, TY, false, [])
                    end,
                    NewOnhookStatus = OnhookStatus#status_onhook{
                        onhook_btime = NowTime, onhook_sxy = {TSid, TId, TX, TY},
                        lv = Lv, exp = 0, pet_exp = 0, cost_onhook_time = 0,
                        auto_devour_equips = 0, auto_pickup_goods = [], revive_data = []},
                    %% 装备恶魔
                    DevilPS = lib_onhook:onhook_equips_angle_devil(NewPs#player_status{online = ?ONLINE_OFF_ONHOOK}),
                    %% 更新玩家的在线,不然就通过自动加载场景来处理
                    case TSid == Scene of
                        true -> mod_scene_agent:cast_to_scene(Scene, PoolId, {'online_flag', RoleId, ?ONLINE_OFF_ONHOOK});
                        false -> skip
                    end,
                    mod_team:cast_to_team(Team#status_team.team_id, {'online_flag', RoleId, ?ONLINE_OFF_ONHOOK}),
                    %% 第一次挂机切换恢复满血,pk状态切换为和平
                    gen_server:cast(self(), {'set_data', [{hp, HpLim}, {pk, {?PK_PEACE, true}}, {load_scene_auto, ?ONLINE_OFF_ONHOOK}]}),
                    %% 跟随发送坐标到组队进程
                    lib_team_api:change_location(DevilPS),
                    %% 离线队伍处理
                    lib_team_api:team_to_onhook(DevilPS),
                    %% 修改在线状态和记录开始挂机的时间点
                    lib_player:update_online_flag_to_onhook(RoleId, NowTime),
                    %% 离线挂机日志
                    lib_log_api:log_onhook(RoleId, ?ONHOOK_STAER, OnhookTime, NowTime),
                    %% 更新离线挂机人数，真是在线人数减一
                    mod_chat_agent:update(RoleId, [{online_flag, ?ONLINE_OFF_ONHOOK}]),
                    OnhookFixPS = lib_onhook_offline:make_onhook_fix_ref(DevilPS, Lv, 0),
                    %% 触发离线挂机gc一次
                    OnhookGcRef = lib_onhook:onhook_start_gc(RoleId, self()),
                    {noreply, OnhookFixPS#player_status{delay_logout_ref = Ref, onhook_gc_ref = OnhookGcRef,
                        fin_change_scene = 0, onhook = NewOnhookStatus}}
            end
    end;

handle_info({'EXIT', _, normal}=Info, Status) ->
    mod_server_info:handle_info(Info, Status);

handle_info({Route, _, _} = Info, Status) when Route == 'fake_client_route'; Route == 'player_btree_router' ->
    misc:monitor_pid_special(handle_info, Info),
    mod_server_info:handle_info(Info, Status);
handle_info(Info, Status) ->
    misc:monitor_pid(handle_info, Info),
    mod_server_info:handle_info(Info, Status).

code_change(_oldvsn, Status, _extra) ->
    {ok, Status}.

%% 延迟登出
do_delay_stop(StatusFirst, Socket) ->
    #player_status{
        id = RoleId, sid = Sid, team = Team, online = _OnlineFlag, last_login_time = _LastLoginTime,
        scene = Scene, scene_pool_id = PoolId, figure = Figure, socket = OldSocket, source = Source,
        delay_logout_ref = ORef, combat_ref = CombatRef, combat_power = CombatPower
    } = StatusFirst,
   % ?MYLOG(RoleId == 4294967314, "hjhonhook", "Socket:~p OldSocket:~p Bool:~p ~n",
   %      [Socket, OldSocket, Socket =:= OldSocket]),
    if
        Socket =:= OldSocket -> %% 如果是同socket退出就走延迟
            %% 关闭socket
            lib_player:update_player_state_combat(StatusFirst, CombatPower),
            util:cancel_timer(CombatRef),
            Status0 = StatusFirst#player_status{combat_ref = undefined},
            Status1 = lib_top_pk:delay_stop(Status0),
            Status = lib_3v3_local:delay_stop(Status1),
            mod_scene_agent:apply_cast(Scene, PoolId, lib_scene_agent, clear_collect_mon_msg, [RoleId]), %%清除采集怪的信息
            Sid ! {is_send, false},
            timer:sleep(1000),
            #figure{guild_id = GuildId} = Figure,
            LogoutTime = utime:unixtime(),
            %% 更新各个进程的玩家在线状态
            mod_scene_agent:cast_to_scene(Scene, PoolId, {'online_flag', RoleId, ?ONLINE_OFF}),
            mod_team:cast_to_team(Team#status_team.team_id, {'online_flag', RoleId, ?ONLINE_OFF}),
            mod_chat_agent:update(RoleId, [{online_flag, ?ONLINE_OFF}]),
            lib_relationship:role_change_online_status(RoleId, Figure, ?ONLINE_OFF),
            lib_role:update_role_show(RoleId, [{last_logout_time, LogoutTime}, {online_flag, ?ONLINE_OFF}]),
            %mod_smashed_egg:update_online_time(RoleId, OnlineFlag, LastLoginTime),
            if
                GuildId =< 0 -> skip;
                true -> mod_guild:update_guild_member_attr(RoleId, [{last_logout_time, LogoutTime}, {online_flag, ?ONLINE_OFF}])
            end,
            %% 记录真实下线时间点,记录下线日志
            lib_player:update_player_login_offline(Status, LogoutTime),
            lib_login:log_offline(Status, LogoutTime, ?LOGOUT_LOG_DELAY),
            ?TRY_CATCH(lib_login:log_all_online(Status, LogoutTime)),
            %% 记录vip在线经验
            % lib_vip:log_vip_upgrade(Status),
            %% 保留3分钟的原地不动
            case lib_shenhe_api:check_is_shenhe_ios(Source) of
                true -> %% 审核服直接下线
                    Ref = util:send_after(ORef, 3*1000, self(), {'timer_stop', 1});
                false ->
                    % % 测试:3秒下线
                    % Ref = util:send_after(ORef, 3*1000, self(), {'timer_stop', 1})
                    % 直接下线:取消离线挂机
                    Ref = util:send_after(ORef, ?ONHOOK_TO_TIME*1000, self(), {'timer_stop', 1})
            end,
            NewStatus = Status#player_status{last_logout_time = LogoutTime, online = ?ONLINE_OFF, delay_logout_ref = Ref},
            NewStatus2 = lib_onhook:delay_stop(NewStatus),
            %% 在线奖励
            NewStatus3 = lib_online_reward:logout(NewStatus2),
            %% 龙纹熔炉
            NewStatus4 = lib_dragon_crucible:delay_stop(NewStatus3),
            % vip更新数据
            NewStatus5 = lib_vip:delay_logout(NewStatus4),
            %% kf圣域
            %NewStatus6 = lib_c_sanctuary:delay_stop(NewStatus5),
            %% 永恒圣殿
            NewStatus7 = lib_kf_sanctum:delay_stop(NewStatus5),
            %% 使魔
            StatusDemons = lib_demons:delay_stop(NewStatus7),
            StatusAfNine = lib_nine:delay_stop(StatusDemons),
            SanctuaryPs = lib_sanctuary:delay_stop(StatusAfNine),
            BossPs = lib_boss:delay_stop(SanctuaryPs),
            DungeonPs = lib_dungeon:delay_stop(BossPs),
            LevelPs = lib_level_act:logout(DungeonPs),
            {ok, BetaPS} = lib_beta_login:logout(LevelPs),
            BetaReturnPS = lib_beta_recharge_return:logout(BetaPS),
            PushGiftStatus = lib_push_gift:logout(BetaReturnPS),
            InvitePS = lib_invite:delay_stop(PushGiftStatus),
            {ok, EvtStatus} = lib_player_event:dispatch(InvitePS, ?EVENT_DISCONNECT, []),
            MagicCircleStatus = lib_magic_circle:delay_stop(EvtStatus),
            InviteStatus = lib_dungeon:offline_answer_invite_dun(MagicCircleStatus),
            RideMountStatus = lib_player:auto_change_ride_mount_status(InviteStatus),
            RideMountStatus;
        true ->
            StatusFirst
    end.

%%
%% ------------------------私有函数------------------------
%%

%% 路由
%% cmd:命令号
%% Socket:socket id
%% data:消息体
routing(Cmd, Status, Data) ->
    %% 取前面二位区分功能类型
    [H1, H2, H3, _, _] = integer_to_list(Cmd),
    case cd_cmd(Cmd) of
        true ->
            case [H1, H2, H3] of
                "100" -> pp_login:handle(Cmd, Status, Data);               %% 登录
                "102" -> pp_game:handle(Cmd, Status, Data);                %% 游戏控制
                "110" -> pp_chat:handle(Cmd, Status, Data);                %% 聊天
                "112" -> pp_dress_up:handle(Cmd, Status, Data);            %% 装扮
                "111" ->                                                   %% GM命令
                    TICKET = config:get_ticket(),
                    case TICKET == "SDFSDESF123DFSDF" of
                        true -> pp_gm:handle(Cmd, Status, Data);
                        false -> skip
                    end;
                "113" -> pp_wx:handle(Cmd, Status, Data);                  %% 微信
                "120" -> pp_scene:handle(Cmd, Status, Data);               %% 场景
                "121" -> pp_npc:handle(Cmd, Status, Data);                 %% NPC
                "130" -> pp_player:handle(Cmd, Status, Data);              %% 玩家信息
                "132" -> pp_onhook:handle(Cmd, Status, Data);              %% 离线挂机设置
                "133" -> pp_enchantment_guard:handle(Cmd, Status, Data);   %% 结界守护
                "134" -> pp_medal:handle(Cmd, Status, Data);               %% 勋章
                "135" -> pp_nine:handle(Cmd, Status, Data);                %% 九魂圣殿
                "137" -> pp_drum:handle(Cmd, Status, Data);                %% 钻石大战
                "138" -> pp_module_open:handle(Cmd, Status, Data);         %% 模块预告
                %"139" -> pp_arbitrament:handle(Cmd, Status, Data);         %% 圣裁
                "140" -> pp_relationship:handle(Cmd, Status, Data);        %% 好友
%%                "141" -> pp_back_decoration:handle(Cmd, Status, Data);     %% 背饰
                "142" -> pp_companion:handle(Cmd, Status, Data);           %% 伙伴
                "143" -> pp_dragon_ball:handle(Cmd, Status, Data);        %% 龙珠
                "144" -> pp_armour:handle(Cmd, Status, Data);              %% 战甲
                "148" -> pp_fairy:handle(Cmd, Status, Data);               %% 精灵
                "149" -> pp_decoration:handle(Cmd, Status, Data);          %% 幻饰
                "150" -> pp_goods:handle(Cmd, Status, Data);               %% 物品
                "151" -> pp_sell:handle(Cmd, Status, Data);                %% 交易市场
                "152" -> pp_equip:handle(Cmd, Status, Data);               %% 装备
                "153" -> pp_shop:handle(Cmd, Status, Data);                %% 商城
                "154" -> pp_auction:handle(Cmd, Status, Data);             %% 拍卖
                "157" -> pp_activitycalen:handle(Cmd, Status, Data);       %% 活动日历
                "158" -> pp_recharge:handle(Cmd, Status, Data);            %% 充值界面
                "159" -> pp_recharge_act:handle(Cmd, Status, Data);        %% 充值活动
                "160" -> pp_mount:handle(Cmd, Status, Data);               %% 坐骑
                "161" -> pp_wing:handle(Cmd, Status, Data);                %% 翅膀
                "164" -> pp_awakening:handle(Cmd, Status, Data);           %% 觉醒
                "165" -> pp_pet:handle(Cmd, Status, Data);                 %% 宠物
                "166" -> pp_juewei:handle(Cmd, Status, Data);              %% 爵位
                "167" -> pp_rune:handle(Cmd, Status, Data);                %% 符文
                "168" -> pp_talisman:handle(Cmd, Status, Data);            %% 法宝
                "169" -> pp_godweapon:handle(Cmd, Status, Data);           %% 神兵
                "170" -> pp_soul:handle(Cmd, Status, Data);                %% 聚魂
                "171" -> pp_artifact:handle(Cmd, Status, Data);            %% 神器
                "172" -> pp_marriage:handle(Cmd, Status, Data);            %% 婚姻
                "173" -> pp_eudemons:handle(Cmd, Status, Data);            %% 婚姻
                "175" -> pp_login_reward:handle(Cmd, Status, Data);        %% 七天登录
                "176" -> pp_limit_shop:handle(Cmd, Status, Data);          %% 神秘限购
                "177" -> pp_house:handle(Cmd, Status, Data);               %% 家园
                "179" -> pp_bonus_monday:handle(Cmd, Status, Data);        %% 周一大奖
                "180" -> pp_anima_equip:handle(Cmd, Status, Data);         %% 灵器
                "181" -> pp_dragon:handle(Cmd, Status, Data);              %% 龙纹
                "182" -> pp_baby:handle(Cmd, Status, Data);                %% 宝宝
                "183" -> pp_demons:handle(Cmd, Status, Data);                %% 使魔
                "184" -> pp_module_buff:handle(Cmd, Status, Data);                %%
                "185" -> pp_escort:handle(Cmd, Status, Data);              %% 矿石护送
                "186" -> pp_seacraft:handle(Cmd, Status, Data);            %% 怒海争霸
                "187" -> pp_seacraft_daily:handle(Cmd, Status, Data);            %% 怒海争霸
                "188" -> pp_boss_first_blood_plus:handle(Cmd, Status, Data);     %% 新boss首杀
                "189" -> pp_sea_treasure:handle(Cmd, Status, Data);        %% 璀璨之海
                "190" -> pp_mail:handle(Cmd, Status, Data);                %% 邮件
                "191" -> pp_push_gift:handle(Cmd, Status, Data);                %% 礼包推送
                "192" -> pp_activity_onhook:handle(Cmd, Status, Data);     %% 活动托管
                "193" -> pp_advertisement:handle(Cmd, Status, Data);     %% 活动托管
                "194" -> pp_fiesta:handle(Cmd, Status, Data);               % 祭典
                "195" -> pp_look_over:handle(Cmd, Status, Data);           %% 新版查看玩家信息
                "200" -> pp_battle:handle(Cmd, Status, Data);              %% 战斗
                %% "201" -> pp_partner_battle:handle(Cmd, Status, Data);
                "202" -> pp_protect:handle(Cmd, Status, Data);             %% 免战保护
                "203" -> pp_tsmap:handle(Cmd, Status, Data);               %% 藏宝图
                "204" -> pp_chrono_rift:handle(Cmd, Status, Data);         %% 时空圣痕
                "206" -> pp_night_ghost:handle(Cmd, Status, Data);         %% 百鬼夜行
                "210" -> pp_skill:handle(Cmd, Status, Data);               %% 技能
                "211" -> pp_arcana:handle(Cmd, Status, Data);              %% 远古奥术
                "215" -> pp_soul_dungeon:handle(Cmd, Status, Data);        %% 聚魂副本
                "216" -> pp_magic_circle:handle(Cmd, Status, Data);        %% 魔法阵
                "217" -> pp_attr_medication:handle(Cmd, Status, Data);     %% 属性药剂
                "218" -> pp_holy_spirit_battlefield:handle(Cmd, Status, Data);     %% 圣灵战场
                "232" -> pp_constellation_equip:handle(Cmd, Status, Data); %% 星宿
                "233" -> pp_god_court:handle(Cmd, Status, Data);           %% 神庭
                "240" -> pp_team:handle(Cmd, Status, Data);                %% 队伍
                "241" -> pp_beings_gate:handle(Cmd, Status, Data);         %% 众生之门
                "221" -> pp_common_rank:handle(Cmd, Status, Data);         %% 榜单
                "223" -> pp_flower:handle(Cmd, Status, Data);              %% 鲜花
                "224" -> pp_flower_act:handle(Cmd, Status, Data);          %% 鲜花结婚榜活动
                "225" -> pp_rush_rank:handle(Cmd, Status, Data);           %% 开服冲榜活动
                "226" -> pp_up_power_rank:handle(Cmd, Status, Data);       %% 战力升榜活动
                "227" -> pp_cycle_rank:handle(Cmd, Status, Data);          %% 循环冲榜
                "279" -> pp_kf_sanctum:handle(Cmd, Status, Data);          %% 永恒圣殿
                "280" -> pp_jjc:handle(Cmd, Status, Data);                 %% 竞技
                "281" -> pp_top_pk:handle(Cmd, Status, Data);              %% 巅峰竞技
                "282" -> pp_role_view:handle(Cmd, Status, Data);           %% 查看角色信息
                "283" -> pp_sanctuary:handle(Cmd, Status, Data);           %% 圣域
                "284" -> pp_sanctuary_cluster:handle(Cmd, Status, Data);   %% 跨服圣域
                "285" -> pp_midday_party:handle(Cmd, Status, Data);        %% 午间派对
                "286" -> pp_revelation_equip:handle(Cmd, Status, Data);    %% 天启装备
                "300" -> pp_task:handle(Cmd, Status, Data);                %% 任务
                "331" -> pp_custom_act:handle(Cmd, Status, Data);          %% 定制活动
                "332" -> pp_custom_act_list:handle(Cmd, Status, Data);     %% 定制活动(延伸331)
                "333" -> pp_hi_point:handle(Cmd, Status, Data);     %% 嗨点
                "338" -> pp_race_act:handle(Cmd, Status, Data);            %% 竞榜活动
                "339" -> pp_red_envelopes:handle(Cmd, Status, Data);       %% 红包
                "340" -> pp_invite:handle(Cmd, Status, Data);              %% 邀请
                "342" -> pp_guess:handle(Cmd, Status, Data);               %% 竞猜
                "399" -> pp_mini_game:handle(Cmd, Status, Data);           %% 小游戏
                "400" -> pp_guild:handle(Cmd, Status, Data);               %% 帮派
                "401" -> pp_guild_depot:handle(Cmd, Status, Data);         %% 帮派仓库
                "402" -> pp_guild_act:handle(Cmd, Status, Data);           %% 帮派活动
                "403" -> pp_guild_daily:handle(Cmd, Status, Data);         %% 公会宝箱
                "404" -> pp_guild_assist:handle(Cmd, Status, Data);         %% 公会协助
                "405" -> pp_guild_god:handle(Cmd, Status, Data);           %% 公会神像
                "409" -> pp_achievement:handle(Cmd, Status, Data);         %% 成就
                "411" -> pp_designation:handle(Cmd, Status, Data);         %% 称号
                %% "412" -> pp_partner:handle(Cmd, Status, Data);
                "413" -> pp_fashion:handle(Cmd, Status, Data);             %% 时装
                "414" -> pp_treasure_chest:handle(Cmd, Status, Data);      %% 青云夺宝
                "415" -> pp_pray:handle(Cmd, Status, Data);                %% 祈愿
                "416" -> pp_treasure_hunt:handle(Cmd, Status, Data);       %% 寻宝
                "417" -> pp_welfare:handle(Cmd, Status, Data);             %% 福利
                "419" -> pp_resource_back:handle(Cmd, Status, Data);       %% 回归
                "420" -> pp_investment:handle(Cmd, Status, Data);          %% 投资活动
                "421" -> pp_tsmap:handle(Cmd, Status, Data);               %% 藏宝图
                "422" -> pp_star_map:handle(Cmd, Status, Data);            %% 星图
%%                "424" -> pp_eternal_valley:handle(Cmd, Status, Data);      %% 永恒碑谷
                "425" -> pp_adventure_book:handle(Cmd, Status, Data);      %% 冒险之书
                "426" -> pp_rename:handle(Cmd, Status, Data);              %% 重命名
                "427" -> pp_adventure:handle(Cmd, Status, Data);           %% 天天冒险
                "429" -> pp_temple_awaken:handle(Cmd, Status, Data);      %% 神殿觉醒
                "437" -> pp_kf_guild_war:handle(Cmd, Status, Data);        %% 跨服公会战
                "440" -> pp_god:handle(Cmd, Status, Data);                 %% 降神
                "442" -> pp_mon_pic:handle(Cmd, Status, Data);             %% 怪物图鉴
                "450" -> pp_vip:handle(Cmd, Status, Data);                 %% vip
                "451" -> pp_supreme_vip:handle(Cmd, Status, Data);         %% 至尊vip
                "452" -> pp_weekly_card:handle(Cmd, Status, Data);         %% 周卡
                "460" -> pp_boss:handle(Cmd, Status, Data);                %% 本服boss
                "470" -> pp_eudemons_land:handle(Cmd, Status, Data);       %% 幻兽之域boss
                "471" -> pp_decoration_boss:handle(Cmd, Status, Data);     %% 幻饰boss
                "490" -> pp_surprise_gift:handle(Cmd, Status, Data);       %% 惊喜礼包
                "500" -> pp_husong:handle(Cmd, Status, Data);              %% 护送
                "505" -> pp_guild_battle:handle(Cmd, Status, Data);        %% 公会战
                "506" -> pp_territory_war:handle(Cmd, Status, Data);        %% 领地战
                "507" -> pp_kf_rank_dungeon:handle(Cmd, Status, Data);        %% 个人排行本
                "508" -> pp_week_dungeon:handle(Cmd, Status, Data);        %% 周常本
                "509" -> pp_spirit_rotary:handle(Cmd, Status, Data);        %% 精灵转盘
                "510" -> skip; %%pp_boss_rotary:handle(Cmd, Status, Data);        %% boss转盘
                "511" -> pp_mask_role:handle(Cmd, Status, Data);        %% 蒙面
                "512" -> pp_kf_cloud_buy:handle(Cmd, Status, Data);        %% 跨服云购
                "513" -> pp_fairy_buy:handle(Cmd, Status, Data);           %% 仙灵直购
                "514" -> pp_hero_halo:handle(Cmd, Status, Data);           %% 主角光环
                "600" -> pp_void_fam:handle(Cmd, Status, Data);            %% 虚空秘境
                "603" -> pp_eudemons_attack:handle(Cmd, Status, Data);     %% 幻兽入侵
                "604" -> pp_diamond_league:handle(Cmd, Status, Data);      %% 星钻联赛
                "606" -> pp_holy_ghost:handle(Cmd, Status, Data);          %% 圣灵
                "607" -> pp_saint:handle(Cmd, Status, Data);               %% 圣者殿
                "610" -> pp_dungeon:handle(Cmd, Status, Data);             %% 副本
                "611" -> pp_dungeon_sec:handle(Cmd, Status, Data);         %% 副本2
                "612" -> pp_level_act:handle(Cmd, Status, Data);           %% 等级抢购商城
                "618" -> pp_to_be_strong:handle(Cmd, Status, Data);        %% 我要变强
                "619" -> pp_pk_log:handle(Cmd, Status, Data);              %% pk记录
                "621" -> pp_kf_1vN:handle(Cmd, Status, Data);              %% 1VN
                "622" -> pp_draconic:handle(Cmd, Status, Data);            %% 龙语
                "640" -> pp_rush_shop:handle(Cmd, Status, Data);           %% 抢购商城
                "650" -> pp_3v3:handle(Cmd, Status, Data);                 %% 3v3
                "651" -> pp_dragon_language_boss:handle(Cmd, Status, Data);%% 龙语boss
                "652" -> pp_territory_treasure:handle(Cmd, Status, Data);  %% 领地夺宝
                "653" -> pp_glad:handle(Cmd, Status, Data);                %% 决斗场
                "654" -> pp_seal:handle(Cmd, Status, Data);                %% 圣印
                _ ->
                    ?ERR("bad handle mod CMD=~w", [Cmd]),
                    {error, "Routing failure"}
            end;
        {false, CdTime} -> %% 返回Cd提示
            IgnoreTipCmdL = [43719],
            case lists:member(Cmd, IgnoreTipCmdL) of
                false ->
                    ?DEBUG("err102_too_frequent Cmd:~p ~n", [Cmd]),
                    {ErrorCodeInt, ErrorCodeArgs} = util:parse_error_code({?ERRCODE(err102_too_frequent), [max(1, CdTime)]}),
                    lib_server_send:send_to_sid(Status#player_status.sid, pt_102, 10205, [ErrorCodeInt, ErrorCodeArgs]);
                _ -> skip
            end,
            skip
    end.

%% 处理路由返回值
do_return_value(Value, Status) ->
    case Value of
        %% 更新战斗属性
        battle_attr ->
            mod_scene_agent:update(Status, [{battle_attr, Status#player_status.battle_attr}]);
        %% 更新装备属性
        equip ->
            mod_scene_agent:update(Status, [{battle_attr, Status#player_status.battle_attr}]);
        %% ...
        _ ->
            skip
    end.

%% 玩家进程退出
%% 退出所需要操作都写这里
handle_offline(normal, _Status) -> ok;
handle_offline(Reason, Status) ->
    #player_status{id = RoleId, figure = #figure{name = Name}} = Status,
    catch ?ERR("[ERROR] mod_server crash reason:~p~n", [Reason]),
    catch ?WEBERR("player error logout reason:~p~n", [[RoleId, Reason]], {RoleId, Name}),
    %% 登出流程
    case catch mod_login:logout(Status, ?LOGOUT_LOG_ERROR) of
        {'EXIT', LogOutReason} ->
            catch ?ERR("[ERROR] mod_login:logout crash Reason=~p~n", [LogOutReason]),
            ?WEBERR("mod_server_login:logout ERROR== LINE:~p Reason=~p~n", [?LINE, LogOutReason], {RoleId, Name});
        _ -> skip
    end,
    ok.

%% 需要加cd时间的协议
%%List = [{12001, 3},{120001,4}];  12001是需要加cd的协议号,3是cd的时间长度单位秒
cd_cmd(Cmd) ->
    case get_cmd_cd(Cmd) of
        false  ->
            true;
        T ->
            NowTime = utime:unixtime(),
            case get({mod_server_cd_cmd, Cmd}) of
                undefined ->
                    put({mod_server_cd_cmd, Cmd}, NowTime),
                    true;
                LastTime ->
                    case NowTime - LastTime > T of
                        true ->
                            put({mod_server_cd_cmd, Cmd}, NowTime),
                            true;
                        false ->
                            {false, T - (NowTime - LastTime)}
                    end
            end
    end.

%% 小飞鞋使用
get_cmd_cd(12033) -> 3;
%% 好友推荐
get_cmd_cd(14013) -> 10;
%% 领取礼包卡奖励
get_cmd_cd(15087) -> 5;
%% 整理背包
get_cmd_cd(15004) -> 5;
get_cmd_cd(15106) -> 1;
%% 跨服圣殿进入
get_cmd_cd(15554) -> 1;
%% 跨服圣殿续命
get_cmd_cd(15556) -> 2;
%% 写信
get_cmd_cd(19001) -> 3;
%% 公会邮件
get_cmd_cd(19006) -> 3;
%% 发起投票
get_cmd_cd(24020) -> 3;
%% 竞技随机对手
% get_cmd_cd(28002) -> 3;
%% 公会申请1分钟CD
get_cmd_cd(40003) -> 30;
%% 赠送鲜花
get_cmd_cd(22301) -> 1;
%% 决战之巅匹配
get_cmd_cd(28110) -> 2;
%% 决战之巅取消匹配
get_cmd_cd(28114) -> 2;
% %% 寻宝
% get_cmd_cd(41604) -> 1;
%% 寻宝一键取出
get_cmd_cd(41606) -> 3;
%% 婚姻-秀恩爱
get_cmd_cd(17242) -> 1;
% %% 使用宠物灵丹
% get_cmd_cd(16511) -> 1;
% %% 使用宠物灵丹次数
% get_cmd_cd(16512) -> 1;
% %% 使用兽魂
% get_cmd_cd(16010) -> 1;
% %% 兽魂使用次数
% get_cmd_cd(16011) -> 1;
% %% 竞技挑战
% get_cmd_cd(28003) -> 1;
%% 跨服送花
get_cmd_cd(22404) -> 1;
%% 圣者殿挑战
get_cmd_cd(60704) -> 1;
%% 1vN押注
get_cmd_cd(62118) -> 3;
%% 1vN拍卖
get_cmd_cd(62126) -> 5;
%% 家园送礼
get_cmd_cd(17724) -> 2;
%% 跨服公会战进出场景
get_cmd_cd(43719) -> 1;
%% 幻饰boss援助
get_cmd_cd(47111) -> 2;
get_cmd_cd(11304) -> 10;
get_cmd_cd(18509) -> 3;
get_cmd_cd(18504) -> 1;
%% 公会调戏
get_cmd_cd(40029) -> 3;
%% 密符使用， 1分钟1次
get_cmd_cd(15804) -> 120;
get_cmd_cd(_) -> false.
