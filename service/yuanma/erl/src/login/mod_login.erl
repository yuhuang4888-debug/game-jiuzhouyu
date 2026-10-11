%%%-----------------------------------
%%% @Module  : mod_login
%%% @Author  : xyao
%%% @Email   : jiexiaowen@gmail.com
%%% @Created : 2011.06.14
%%% @Description: 登陆模块
%%%-----------------------------------
-module(mod_login).
-export([
         login/1,
         delay_logout/2,
         delay_logout/1,
         logout/1,
         logout/2,
         logout_socket/2,
         stop_player/1,
         stop_all/0,
         server_stop_all/0,
         save_online/1,
         server_login/1,
         sync_mod_chat_agent/1
        ]).

-include("record.hrl").
-include("server.hrl").
-include("unite.hrl").
-include("goods.hrl").
-include("scene.hrl").
-include("predefine.hrl").
-include("figure.hrl").
-include("attr.hrl").
-include("common.hrl").
-include("task.hrl").
-include("team.hrl").
-include("guild.hrl").
-include("skill.hrl").
-include("checkin.hrl").
-include("dungeon.hrl").
-include("def_event.hrl").
-include("vip.hrl").
-include("rec_recharge.hrl").
-include("partner_battle.hrl").
-include("rec_sell.hrl").
-include("rec_offline.hrl").
-include("activitycalen.hrl").
-include("reincarnation.hrl").
-include("def_fun.hrl").
-include("welfare.hrl").
-include("mount.hrl").
-include("rec_assist.hrl").
-include("fake_client.hrl").
-include("def_module.hrl").
-include("login.hrl").

%% 验证登录
%% Data:登陆验证数据
%% Arg:tcp的Socket进程,socket ID
% login([Id, AccId, Accname, AccNameSdk, ServerName, Ip, Socket, Ids, RegSId, CSource, TransMod, ProtoMod]) ->
login(LoginParams = #login_params{id = Id, accname = Accname}) ->
    case lib_login:get_player_login_by_id(Id) of
        [] ->
            {error, 0};
        [Aname, Status] ->
            case Status of
                0 -> %%正常
                    case binary_to_list(Aname) =:= Accname of
                        true ->
                            do_login(LoginParams);
                        false ->
                            {error, 0}
                    end;
                1 -> %% 封号
                    {error, 6};
                2 -> %% 买卖元宝封号
                    {error, 7};
                3 -> %% 不正当竞争封号
                    {error, 8};
                _ -> %% 状态不正常
                    {error, 9}
            end
    end.

%% 角色登陆
%% @param TaGuestId binary()
%% @param IsSimulator boolean()
%% @param TaDeviceId binary()
do_login(#login_params{id = Id, accid = AccId, accname = AccName} = LoginParams) ->
    %% 检查用户登陆和状态已经登陆的踢出出去
    % case check_player(Id, Ids, Socket, Ip, ServerName, RegSId, CSource, TransMod, ProtoMod) of
    case check_player(LoginParams) of
        {ok, Pid} -> %% 重连
            % lib_log_api:log_login(Id, Ip, AccId, AccName, ?RE_LOGIN),
            {ok, Pid};
        false ->
            % case catch mod_server:start([Id, Ip, Socket, AccId, AccName, AccNameSdk, ServerName, Ids, RegSId, CSource, TransMod, ProtoMod, TaGuestId, IsSimulator, TaDeviceId, ?NORMAL_LOGIN]) of
            case catch mod_server:start([LoginParams, ?NORMAL_LOGIN]) of
                {ok, Pid} -> %% 登录
                    % lib_log_api:log_login(Id, Ip, AccId, AccName, ?NORMAL_LOGIN),
                    {ok, Pid};
                Other ->
                    ?ERR("login error AccId(~w), AccName(~p), id(~w), Reason:~p~n", [AccId, AccName, Id, Other]),
                    {error, 0}
            end
    end.

%% 检查用户是否登陆了
% check_player(Id, Ids, Socket, Ip, ServerName, RegSId, CSource, TransMod, ProtoMod) ->
check_player(LoginParams) ->
    #login_params{
        id = Id, ids = Ids
        } = LoginParams,
    % Fun = fun(TmpId) ->
    %         case misc:get_player_process(TmpId) of
    %             Pid when is_pid(Pid) ->
    %                 %% 告诉客户端，账号被重登陆，在线角色下线
    %                 {ok, BinData} = pt_590:write(59004, 5),
    %                 lib_server_send:send_to_uid(Id, BinData),
    %                 logout(Pid),
    %                 timer:sleep(500),
    %                 ok;
    %             _ -> ok
    %         end
    % end,
    % lists:map(Fun, Ids),
    % false.
    Fun = fun(TmpId, Result) ->
        case misc:get_player_process(TmpId) of
            Pid when is_pid(Pid), TmpId == Id ->
                case catch mod_server:relogin(Pid, LoginParams) of
                    true -> %% 将reader进程与server关联
                        % erlang:link(Pid),
                        {ok, Pid};
                    Error ->
                        ?ERR("mod server relogin error:~p~n", [[Error]]),
                        login_outside(Id, Pid),
                        timer:sleep(500),
                        Result
                end;
            Pid when is_pid(Pid) -> %% 允许离线的号共存
                case catch mod_server:online_flag(Pid) of
                    ?ONLINE_OFF ->
                        Result;
                    ?ONLINE_ON ->
                        login_outside(TmpId, Pid),
                        timer:sleep(500),
                        Result;
                    ?ONLINE_OFF_ONHOOK ->
                        Result;
                    ?ONLINE_FAKE_ON ->
                        Result;
                    _ErrorR ->
                        ?ERR("get_online_flag err:~p~n", [[TmpId, Pid, _ErrorR]]),
                        login_outside(TmpId, Pid),
                        timer:sleep(500),
                        Result
                end;
            _ ->
                Result
        end
    end,
    lists:foldl(Fun, false, Ids).

login_outside(Id, Pid) ->
    %% 通知客户端账户在别处登陆
    {ok, BinData} = pt_590:write(59004, 5),
    lib_server_send:send_to_uid(Id, BinData),
    logout(Pid),
    ok.

%% 把玩家踢出去
stop_player(PlayerId) ->
    case misc:get_player_process(PlayerId) of
        false -> skip;
        Pid -> logout(Pid)
    end.

%% 把所有在线玩家踢出去
stop_all() ->
    mod_ban:ban_all(),
    do_stop_all(ets:tab2list(?ETS_ONLINE)).
do_stop_all([]) ->
    ok;
do_stop_all([H | T]) ->
    {ok, BinData} = pt_590:write(59004, 11),
    lib_server_send:send_to_uid(H#ets_online.id, BinData),
    %% 关闭socket
    lib_server_send:send_to_uid(H#ets_online.id, close),
    logout(H#ets_online.pid),
    timer:sleep(10),
    do_stop_all(T).

%% 延迟登出
delay_logout(Pid, Socket) when is_pid(Pid) ->
    % ?MYLOG("hjhonhook", "delay_logout Pid:~p, IsAlive:~p Socket:~p ~n", [Pid, misc:is_process_alive(Pid), Socket]),
    case misc:is_process_alive(Pid) of
        true -> mod_server:delay_stop(Pid, Socket);
        false -> skip
    end.

% %% 离线
% cast_delay_logout(Pid, Socket, Ids, CloseReason) ->
%     case is_pid(Pid) andalso  misc:is_process_alive(Pid) of
%         true -> gen_server:cast(Pid, {'delay_stop', Socket});
%         false ->
%             ?ERR("~p ~p cast_dalay_error:~p~n", [?MODULE, ?LINE, [Pid, Ids, CloseReason]]),
%             skip
%     end.

%% 延迟登出
delay_logout(PS) ->
    % ?MYLOG("hjhonhook", "delay_logout :~p ~n", []),
    % #player_status{id=Id, scene=Scene, scene_pool_id=ScenePoolId, team=Team} = PS,
    % mod_scene_agent:cast_to_scene(Scene, ScenePoolId, {'socket_cloesd', Id}),
    % case Team#status_team.team_id > 0 of
    %     true -> mod_team:cast_to_team(Team#status_team.team_id, {'socket_cloesd', Id});
    %     _ -> skip
    % end,
    % lib_dungeon:delay_logout(PS),
    % mod_chat_agent:update(Id, [{online, PS#player_status.online}]),
    % {ok, NewPS} = lib_player_logout:logout(PS, ?DELAY_LOGIN),
    PS.

%% 退出登陆
logout(Pid) when is_pid(Pid) ->
    % ?MYLOG("hjhonhook", "logout ~n", []),
    case misc:is_process_alive(Pid) of
        true -> mod_server:stop(Pid);
        false -> skip
    end;
logout(_) -> skip.

%% 退出登陆[目前没用]
logout_socket(Pid, Socket) when is_pid(Pid) ->
    case misc:is_process_alive(Pid) of
        true -> mod_server:stop_socket(Pid, Socket);
        false -> skip
    end.

%% 服务器停止调用
server_stop_all()->
    do_server_stop_all(ets:tab2list(?ETS_ONLINE)).

%% 让所有玩家自动退出
do_server_stop_all([]) ->
    ok;
do_server_stop_all([H | T]) ->
    {ok, BinData} = pt_590:write(59004, 11),
    lib_server_send:send_to_uid(H#ets_online.id, BinData),
    %% 关闭socket
    lib_server_send:send_to_uid(H#ets_online.id, close),
    case mod_server:server_stop(H#ets_online.pid) of
        {ok, true} -> skip; %% 正常退出
        R -> ?ERR("server stop player error! id=~w, Err:~p~n", [H#ets_online.id, R])
    end,
    timer:sleep(10),
    do_server_stop_all(T).

%% 退出游戏系统
%% LogNorlOrErr
%% -define(LOGOUT_LOG_NORMAL,      1).   %% 正常退出日志
%% -define(LOGOUT_LOG_ERROR,       2).   %% 异常退出日志
%% -define(LOGOUT_LOG_SERVER_STOP, 3).   %% 服务器停服玩家退出操作
%% -define(LOGOUT_LOG_DELAY,       4).   %% 中间延迟下线日志(这个不会在这里出现的类型)
%% -define(LOGOUT_LOG_FORBIDDEN,   5).   %% 玩家被封号下线
%% -define(LOGOUT_LOG_WAIGUA,      6).   %% 玩家使用外挂被踢下线
logout(PS, LogNorlOrErr) when is_record(PS, player_status)->
    %% 更新离线时间
    NowTime = utime:unixtime(),

    %% 记录下线日志
    % ?TRY_CATCH(lib_log_api:log_offline(PS#player_status.id, LogNorlOrErr,
    %     PS#player_status.combat_power, PS#player_status.scene, PS#player_status.x, PS#player_status.y, NowTime)),
    ?TRY_CATCH(lib_login:log_offline(PS, NowTime, LogNorlOrErr)),

    %% 活动托管
    ?TRY_CATCH(lib_fake_client:logout(PS)),

    %% 删除在线ETS记录
    ets:delete(?ETS_ONLINE, PS#player_status.id),

    %% 玩家离开场景
    ?TRY_CATCH(lib_scene:leave_scene(PS)),

    %% 更新排行榜
    ?TRY_CATCH(lib_common_rank_api:logout(PS)),

    %% 清理离开场景时所要的操作
    ?TRY_CATCH(lib_scene:change_scene_handler(PS, 0, PS#player_status.scene, [])),

    %% 保存玩家state数据
    ?TRY_CATCH(lib_player:update_player_state(PS)),

    %% 保存玩家高频数据
    ?TRY_CATCH(lib_player:update_player_exp(PS)),

    %% 保存在线状态
    ?TRY_CATCH(lib_player:update_player_login_offline(PS, NowTime)),

    %% 下线保存金币
    ?TRY_CATCH(lib_player:db_update_player_coin(PS)),

    %% 保存在线时长日志
    ?TRY_CATCH(lib_login:log_all_online(PS, NowTime)),

    %% 在延迟下线的时候保存在线状态和在线时长：这个在延迟登录处理|在异常退出处理
%%    ?TRY_CATCH(lib_player_event:dispatch(PS, ?EVENT_DISCONNECT_HOLD_END, LogNorlOrErr)),

    %% 挂机登出[必须在日常前面清理][同时必须放任务登出前面（否则产出物品触发收集任务无法完成）]
    ?TRY_CATCH(lib_afk:logout(PS)),

    %% 保存任务数据
    ?TRY_CATCH(mod_task:stop(PS#player_status.tid)),

    %% 玩家下线，移除ets_buff信息
    ?TRY_CATCH(lib_goods_buff:logout(PS)),

    %% 邀请[必须在日常前面清理]
    ?TRY_CATCH(lib_invite:logout(PS)),

    %% 公会协助[必须在日常前面清理]
    ?TRY_CATCH(lib_guild_assist:logout(PS)),

    %% 下线每日记录器清除
    ?TRY_CATCH(mod_daily:stop(PS#player_status.dailypid)),

    %% 下线每周记录器清除
    ?TRY_CATCH(mod_week:stop(PS#player_status.week_pid)),

    %% 下线终生次数记录器清除
    ?TRY_CATCH(mod_counter:stop(PS#player_status.counter_pid)),

    %% 下线删除玩家
    ?TRY_CATCH(mod_chat_agent:delete(PS#player_status.id)),

    %% 派发下线事件
    ?TRY_CATCH(lib_player_event:dispatch(PS, ?EVENT_ONLINE_FLAG, 0)),

    %% 退出队伍
    ?TRY_CATCH(lib_team_api:quit_team(PS, 1)),

    %% 保存野外挂机高频数据
    ?TRY_CATCH(lib_onhook:onhook_logout(PS, LogNorlOrErr)),

    % vip清除
    ?TRY_CATCH(lib_vip:logout(PS)),

    % 在线福利结算
    ?TRY_CATCH(lib_online_reward:logout(PS)),

    % % 在线玩家统计
    % ?TRY_CATCH(lib_online_statistics:logout(PS)),

    %% 队伍活动锁
    %% mod_team_lock:logout(PS),

    %% 消费数据保存
%%    ?TRY_CATCH(lib_consume_data:save_advance_payments(PS#player_status.id)),
    %% 等级抢购
    ?TRY_CATCH(lib_level_act:logout(PS)),
    % 登出
    ?TRY_CATCH(lib_supreme_vip:logout(PS)),
    % 封测登陆献礼
    ?TRY_CATCH(lib_beta_login:logout(PS)),
    % 封测登出
    ?TRY_CATCH(lib_beta_recharge_return:logout(PS)),
    %% 玩家其他功能下线处理
    ?TRY_CATCH(lib_player_logout:logout(PS, ?NORMAL_LOGOUT)),
    % %% 订阅登出
    % ?TRY_CATCH(lib_subscribe:logout(PS, LogNorlOrErr, NowTime)),
    %% 删除广播队列
    ?TRY_CATCH(mod_msg_cache_queue:role_offline(PS#player_status.id)),
    %% 推送礼包
    ?TRY_CATCH(lib_push_gift:logout(PS)),
    % 设置 roleshow 离线状态
    ?TRY_CATCH(lib_role:update_role_show(PS#player_status.id, [{online_flag, ?ONLINE_OFF}])),
    ?TRY_CATCH(lib_rune:logout(PS)),

    case LogNorlOrErr == ?LOGOUT_LOG_SERVER_STOP of
        true -> ?TRY_CATCH(lib_player:count_player_attribute(PS, logout_log_server_stop));
        false -> skip
    end,

    %% 关闭玩家的定时器
    #player_status{
        delay_logout_ref = DelayRef, revive_ref = ReviveRef, onhook_gc_ref = OnhookGcRef, onhook_fix_ref = OnhookFixRef,
        battle_attr = BA, status_mount = StatusMounts
        } = PS,
    #pk{pk_value_ref = PkValueRef} = BA#battle_attr.pk,
    util:cancel_timer(DelayRef),
    util:cancel_timer(PkValueRef),
    util:cancel_timer(ReviveRef),
    util:cancel_timer(OnhookGcRef),
    util:cancel_timer(OnhookFixRef),
    Fun_QuitRef = fun(StatusMount) -> util:cancel_timer(StatusMount#status_mount.ref) end,
    lists:foreach(Fun_QuitRef, StatusMounts),
    ta_agent_fire:role_logout(PS, utime:unixtime(), LogNorlOrErr),
    %% exit(kill),
    ?MYLOG("task", "logout ~n", []),
    %% 关闭消息发送进程(下线处理均放在上面)
    exit(PS#player_status.sid, kill),
    ok;
logout(_PS, LogType)->
    ?ERR("logout type error:~p~n", [[_PS, LogType]]),
    ok.

%% 游戏服务器登陆
%% 此函数已经改为玩家进程执行
%% Socket==none,离线挂机
%% CSource==none,离线挂机,取玩家注册的来源
% server_login([Id, Ip, Socket, AccId, AccName, AccNameSdk1, _ServerName, _AccRoleIds, _RegSId, CSource, TransMod, ProtoMod, TaGuestId, IsSimulator, TaDeviceId, LoginType]) ->
server_login([LoginParams, LoginType]) ->
    #login_params{
        id = Id, ip = Ip, socket = Socket, accid = AccId, accname = AccName, accname_sdk = AccNameSdk1, server_name = _ServerName, ids = _AccRoleIds, reg_server_id = _RegSId,
        c_source = CSource, trans_mod = TransMod, proto_mod = ProtoMod, ta_guest_id = TaGuestId, ta_device_id = TaDeviceId, is_simulator =IsSimulator, wx_scene = WxScene
    } = LoginParams,
    Pid = self(),

    %% 注册玩家pid
    misc:register(global, misc:player_process_name(Id), Pid),

    NowTime = utime:unixtime(),
    %% 玩家玩家数据
    [GM, TalkLim, TalkLimTime, LastLogoutTime, _TalkLimRight, RegTime, Source, LastLoginTime, _ComeBackState, Mark, AccNameSdkDb, FirstState|_]
        = lib_player:get_player_login_data(Id),
    lib_login:update_login_data(Id, Ip, NowTime),
    [NickName, Sex, Lv, Career, Realm, Picture, PictureLim, PictureVer, CReName, CReNameTime, _CReCareerTime|_]
        = lib_player:get_player_low_data(Id),
    [Gold, BGold, Coin, GCoin, Exp, HightestCombatPower|_] = lib_player:get_player_high_data(Id),
    [DbScene, DbX, DbY, Hp, Quickbar, PkValue, PkStatus, PkStatusChangeTime, SkillPoint,
     PkValueChangeTime, LastTaskId, BitLastBeKill|_] = lib_player:get_player_state_data(Id),
    [CellNum, StorageNum, _GodBagNum|_] = lib_player:get_player_attr_data(Id),
    ReincarnationStatus = lib_reincarnation:login(Id, Career, Sex),
    LvModel = lib_goods_util:get_lv_model(Id, Career, Sex, ReincarnationStatus#reincarnation.turn, Lv),
    NewFashionModel = lib_fashion:get_equip_fashion_list(Id, Career, Sex),
    StatusGuild = lib_guild:load_status_guild(Id),
    VipStatus = lib_vip:login(Id),
    #role_vip{vip_lv = VipLv, vip_type = VipType, vip_hide = VipHide} = VipStatus,
%%    UsefulVipLv = ?IF(VipEndTime > NowTime, VipLv, 0),
    %% 物品初始化
    {GoodsStatus, StatusGoods} = lib_goods:login(Id, [Lv, VipType, VipLv, CellNum, StorageNum]),
    lib_goods_do:init_data(GoodsStatus, Career),
    %% 玩家活跃度形象
    StLiveness = lib_liveness:login(Id),
    %% 特殊货币
    CurrencyMap = lib_goods_util:load_currency(Id),
    StatusSupVip = lib_supreme_vip:load_status_supvip(Id),
    %% 玩家形象
    Figure = #figure{name=NickName, sex=Sex, lv=Lv, career=Career, realm=Realm, gm=GM,
                     vip=VipLv, vip_type = VipType,lv_model = LvModel, vip_hide = VipHide,
                     fashion_model = NewFashionModel, picture = Picture, picture_ver = PictureVer,
                     guild_id = StatusGuild#status_guild.id,
                     guild_name = StatusGuild#status_guild.name,
                     position = StatusGuild#status_guild.position,
                     position_name = StatusGuild#status_guild.position_name,
                    %  liveness = StLiveness#st_liveness.figure_id * StLiveness#st_liveness.display_status,
                     turn = ReincarnationStatus#reincarnation.turn,
                     turn_stage = ReincarnationStatus#reincarnation.turn_stage,
                     is_supvip = lib_supreme_vip:is_supvip(StatusSupVip),
                     camp = StatusGuild#status_guild.realm
                    },
    %% pk状态
    Pk = lib_player_record:pk_login(NowTime, PkStatus, PkStatusChangeTime, PkValue, PkValueChangeTime),
    %% 需要进行复活操作
    BA = #battle_attr{hp=max(Hp,1), pk=Pk},
    SendMsgPid = if
        %Id == 4294967413 -> spawn_link(fun() -> lib_fake_client_msg:send_msg(ProtoMod, TransMod, Socket, Pid) end);
        Socket == behavior_tree -> spawn_link(fun() -> lib_player_behavior_send:send_msg(Pid) end);
        Socket == fake_client -> spawn_link(fun() -> lib_fake_client_msg:send_msg(ProtoMod, TransMod, Socket, Pid) end);
        Socket == none -> spawn_link(fun() -> ProtoMod:send_msg(TransMod, Socket, false, none) end);
        true -> spawn_link(fun() -> ProtoMod:send_msg(TransMod, Socket, true, none) end)
    end,

    misc:register(global, misc:player_send_process_name(Id), SendMsgPid),
    %% 启动日常进程
    {ok, DailyPid} = mod_daily:start_link(Id),
    %% 启动周常进程
    {ok, WeekPid} = mod_week:start_link(Id),
    %% 启动终生次数进程
    {ok, CounterPid} = mod_counter:start_link(Id),
    %% 启动任务进程[在日常、周、终生次数下面,顺序不可乱]
    {ok, TaskPid} = mod_task:start_link(
        #task_args{
            id=Id, sid=SendMsgPid, figure=Figure, gs_dict=GoodsStatus#goods_status.dict,
            stren_award_list = GoodsStatus#goods_status.stren_award_list
        }),
    %% 技能初始化
    Skill = lib_skill:skill_online(Id, Career, Lv, SkillPoint),
    %% npc信息
    NpcInfo = lib_npc:load_role_npc_info(Id),
    %% 初始化玩家快捷栏
    RealQuickbarTemp = case util:bitstring_to_term(Quickbar) of
                           undefined -> [];
                           Qb -> [{QIndex, QType, QSKillId, QAutoTag} || {QIndex, QType, QSKillId, QAutoTag} <- Qb]
                       end,
    %% 玩家没有设置普通技能自动帮玩家设置
    %% yyhx:会重新计算快捷栏的 lib_skill:recalc_quickbar
    RealQuickbar = RealQuickbarTemp,
    % case lists:keyfind(1, 1, RealQuickbarTemp) of
    %                    false ->
    %                        case lib_skill:get_ori_normal_skill(Career, Sex) of
    %                            OriNormalSkillId when OriNormalSkillId > 0 ->
    %                                [{1, 2, OriNormalSkillId, 1}|RealQuickbarTemp];
    %                            _ -> RealQuickbarTemp
    %                        end;
    %                    _ -> RealQuickbarTemp
    %                end,
    %% 上一次最后被谁击杀
    RealBeKill = case util:bitstring_to_term(BitLastBeKill) of
                     undefined -> [];
                     LastBeKill -> LastBeKill
                 end,
    %% 幻兽初始化
    EudemonsStatus = lib_eudemons:init_data(Id),
    %% 修正上一次退出游戏时间
    NewLastLogoutTime = if
                            LastLoginTime > LastLogoutTime -> NowTime;
                            true -> LastLogoutTime
                        end,
    Status3V3 = lib_3v3_local:login([Id]),
    Status1VN = lib_kf_1vN:login(Id),
    % NewReincarnationStatus = lib_reincarnation:login(Id, Career, Sex),
    %% 成就列表初始化
    {_,StarRewardL, AchvStage} = lib_achievement:login(Id),
    NewFigure = Figure#figure{
                    % turn = NewReincarnationStatus#reincarnation.turn,
                    % turn_stage = NewReincarnationStatus#reincarnation.turn_stage,
                    achiv_stage = AchvStage
                },
    % Onhook = lib_onhook:login(Id),
    PictureList = lib_player:get_role_picture_list(Id, Career),
    TaskAttr = lib_task:load_attr(Id),
    Rmb = lib_recharge_data:get_total_rmb(Id),
    IsPay = ?IF(Rmb > 0, true, false),
    % OnhookGcRef = none,
    OnhookGcRef = if
        Socket == none orelse Socket == fake_client -> lib_onhook:onhook_start_gc(Id, self());
        true -> undefined
    end,
    % 默认值
    NewCSource = if
        CSource == none -> Source;
        true -> CSource
    end,
    AccNameSdk = if
        AccNameSdkDb == <<>> orelse AccNameSdkDb == [] -> AccNameSdk1;
        true -> AccNameSdkDb
    end,
    %% 前端上报： TaGuestId -- 客户端的TA访客id
    %% 前端上报： TaDeviceId -- 客户端的TA设备id
    %% 在角色登录的时候，用登录传递的TaGuestId和TaDeviceId，加工为 ta_spcl_base 和 ta_spcl_common
    {TaSpclBase, TaSpclCommon} = ta_agent:get_ta_spcl_data(TaGuestId, TaDeviceId),
    PlayerStatus = #player_status{
        id = Id,
        accid = AccId,
        accname = AccName,
        accname_sdk = AccNameSdk,
        platform = config:get_platform(),
        server_num = config:get_server_num(),
        server_name = util:get_server_name(),
        server_id = config:get_server_id(),
        reg_server_id = util:get_reg_server_id(),
        c_server_msg = util:get_c_server_msg(),
        server_type = config:get_server_type(),
        source = Source,
        is_simulator = IsSimulator,
        c_source = NewCSource,
        mark = Mark,
        first_state = FirstState,
        last_login_time = NowTime,
        login_time_before_last = LastLoginTime,
        socket = Socket,
        %% 上次登出时间肯定比上次登录时间晚,如果异常直接取上一次登录时间
        last_logout_time = NewLastLogoutTime,
        ip = tool:ip2bin(Ip),
        figure = NewFigure,
        pid = Pid,
        sid = SendMsgPid,
        tid = TaskPid,
        scene = DbScene,
        x = DbX,
        y = DbY,
        gold = Gold,
        bgold = BGold,
        coin = Coin,
        gcoin = GCoin,
        is_pay = IsPay,
        exp = Exp,
        exp_lim = data_exp:get(Lv),
        hightest_combat_power = HightestCombatPower,
        talk_lim = TalkLim,
        talk_lim_time = TalkLimTime,
        team = #status_team{},
        cell_num = CellNum,
        storage_num = StorageNum,
        battle_attr = BA,
        dailypid = DailyPid,
        week_pid = WeekPid,
        counter_pid = CounterPid,
        skill = Skill,
        npc_info = NpcInfo,
        guild = StatusGuild,
        goods = StatusGoods,
        %% partner = StatusPartner,
        picture_lim = PictureLim,
        picture_list = PictureList,
        check_in = #checkin_status{},
        online_reward = #status_online_reward{},
        dungeon = #status_dungeon{},
        revive_status = #revive_status{},
        vip = VipStatus,
        recharge_status = #recharge_status{},
        partner_battle = #status_partner_battle{},
        off = #status_off{},
        reconnect = ?NORMAL_LOGIN,
        login_type = ?NORMAL_LOGIN,
        st_liveness = StLiveness,
        flower = lib_flower:login(Id),
        jjc_honour = lib_jjc:get_honour(Id),
        reincarnation = ReincarnationStatus,% lib_reincarnation:login(Id, Career, Sex),
        quickbar = RealQuickbar,
        awakening = lib_awakening:login(Id),
        guild_skill = lib_guild_skill:login(Id),
        help_type_setting = #{},
        eudemons = EudemonsStatus,
        reg_time = RegTime,
        boss_tired = lib_boss:get_boss_tired(Id),
        temple_boss_tired = lib_boss:get_temple_boss_tired(Id),
        phantom_tired = lib_boss:get_phantom_boss_tired(Id),
        status_pray = lib_pray:login(Id),
        treasure_chest = lib_treasure_chest:login(Id),
        currency_map = CurrencyMap,
        eternal_valley = lib_eternal_valley:login(Id),
        c_rename = CReName,
        c_rename_time = CReNameTime,
        status_share = lib_share:login(Id),
        last_task_id = LastTaskId,
        last_be_kill = RealBeKill,
        fireworks = lib_fireworks_act:login(Id),
        daily_turntable = lib_daily_turntable:login(Id),
        last_transfer_time = lib_transfer:login(Id)
        ,role_3v3 = Status3V3
        ,kf_1vn = Status1VN
        ,status_kf_guild_war = lib_kf_guild_war_api:login(StatusGuild#status_guild.id, Id, Lv)
        % ,onhook = Onhook
        ,mon_pic = lib_mon_pic:login(Id)
        ,mystery_shop = lib_mystery_shop:login(Id, Career, Lv)
        ,status_achievement = StarRewardL
        ,status_shake = lib_shake:login(Id)
        ,task_attr=TaskAttr
        ,role_drum = lib_role_drum:login(Id)
        ,strong_status = lib_to_be_strong:login(Id, NowTime, Lv)
        ,seal_status = lib_seal:login(Id, Lv, GoodsStatus)
        ,draconic_status = lib_draconic:login(Id, Lv, GoodsStatus)
        ,rush_shop = lib_rush_shop:login(Id)
        % ,pk_map = lib_player_record:get_pk_map(Id)
        %% ,kf_invasion = lib_kf_invasion:kf_invasion_login(Id)
        ,onhook_gc_ref = OnhookGcRef
        ,pk_status = lib_pk_log:login(Id, NowTime)
        %,kf_sanctuary_info = lib_c_sanctuary:login(Id, Lv, NowTime, LastLoginTime)
        , sanctuary_cluster = lib_sanctuary_cluster:login(Id, Lv)
        ,cloud_buy_list = lib_cloud_buy:user_login(Id, [])
        ,god = lib_god:login(Id)
        ,status_adventure = lib_adventure:login(Id)
        ,jjc = lib_jjc:load_status_jjc(Id)
        ,supvip = StatusSupVip
        ,status_protect = lib_protect:load_status_protect(Id)
        ,wx_share = lib_wx:load_status_wx_share(Id)
        ,constellation = lib_constellation_equip:login(Id, Lv, GoodsStatus)
        ,player_real_info = lib_collec_info:login(Id)
        ,contract_buff = lib_contract_challenge:login(Id)
        ,guild_assist = #status_assist{}
        ,lunch_assist = lib_guild_assist:login(Id)
        % ,subscribe_type = lib_subscribe:get_subscribe_type(Id)
        ,subscribe_type = 0
        , fake_client = #fake_client{}
        , drop_ratio_map = lib_drop:load_drop_ratio_map(Id)
        , grow_welfare = lib_grow_welfare:login(Id)
        , ta_spcl_base = TaSpclBase
        , ta_spcl_common = TaSpclCommon
    },
    %% 派发上线延后事件[功能初始化放下面,先派发消息初始化,防止未初始化报错]
    lib_player_event:async_dispatch(Id, ?EVENT_LOGIN_CAST),
    % %% 成就列表初始化
    % lib_achievement:login(Id),
    %% 摇钱树初始化
    lib_bonus_tree:init_data(PlayerStatus),
     %% 累计登陆统计(放在前面，其他模块可能会用到)
    LoginDaysStatus = lib_player_login_day:login(PlayerStatus, LoginType),
    %% 称号列表初始化
    DsgtPS = lib_designation_util:login(LoginDaysStatus),
    %%结界守护
    GuardPs = lib_enchantment_guard:login(DsgtPS),
    %% 物品BUFF初始化
    BuffPS = lib_goods_buff:login(GuardPs),
    %% 登陆移除离线玩家信息
    lib_offline_api:login(Id),
    %% 远古奥术
    ArcanaPS = lib_arcana:login(BuffPS),
    %% 仙灵直购
    FairyBuyPs = lib_fairy_buy:login(ArcanaPS),
    %% 重新计算快捷栏
    QuickbarPS = lib_skill:recalc_quickbar(FairyBuyPs),
    %% 查看玩家是否有自动学习技能
    {ok, SkillPS} = lib_skill:auto_learn_skill(QuickbarPS, login),
    %% 设置初始化
    SettingPS = lib_game:login_setting(SkillPS),
    %% 翅膀初始化
    WingPS = lib_wing:login(SettingPS),
    %% 法宝初始化
    TalismanPS = lib_talisman:login(WingPS),
    %% 神兵初始化
    GodweaponPS = lib_godweapon:login(TalismanPS),
    %% 神器初始化
    ArtifactPS = lib_artifact:login(GodweaponPS),
    %% 头衔
    TitlePS = lib_title:login(ArtifactPS),
    %% 勋章
    MedalPs = lib_medal:login(TitlePS),
    %% 冲级礼包
    RushGBPS = lib_rush_giftbag:login(MedalPs),
    %% 月签到
    MonthCheckinPS = lib_checkin:login(RushGBPS),
    %% 在线奖励
    OnlinePs = lib_online_reward:login(MonthCheckinPS),
    %% 龙纹
    DragonPS = lib_dragon:login(OnlinePs, GoodsStatus),
    %% 龙纹熔炉
    DragonCruciblePS = lib_dragon_crucible:login(DragonPS),
    %% 邮件推送
    PushmailPS = lib_pushmail:login(DragonCruciblePS),
    %% 充值返利
    RechargeReturnPS = lib_recharge_return:login(PushmailPS),
    %% 充值活动
    RechargeActPs = lib_recharge_act:login(RechargeReturnPS),
    %% 资源找回
    ResourceBackPS = lib_resource_back:login(RechargeActPs),
    %% 延迟发放奖励
    DelayRewardPs = lib_delay_reward:login(ResourceBackPS),
    %% 重命名
    %% lib_rename:login(ResourceBackPS),
    %% 定制活动初始化
    CustomActPS = lib_custom_act_api:login(DelayRewardPs, LoginType),
    %% 个性装扮
    DressUpPS = lib_dress_up:login(CustomActPS),
    %% 星图
    StarMapPS = lib_star_map:login(DressUpPS),
    %% 爵位
    JueWeiPs = lib_juewei:juewei_login(StarMapPS),
    %% 坐骑
    MountPs = lib_mount:login(JueWeiPs, GoodsStatus),
    %% 伙伴（新
    CompanionPs = lib_companion:login(MountPs),
    %% 精灵
    FairyPs = lib_fairy:login(CompanionPs),
    %% 精灵转盘
    SpiritRotaryPS = lib_spirit_rotary:login(FairyPs),
    %% 幻饰
    DecorPS = lib_decoration:login(SpiritRotaryPS, GoodsStatus),
    %% 坐骑装备
    MountEquipPs = lib_mount_equip:login_init(DecorPS),
    %% 宠物
    PetPs = lib_pet:login(MountEquipPs, GoodsStatus),
    %% 圣灵
    HGhostPs = lib_holy_ghost:login(PetPs),
    %% 圣者殿
    SaintPs = lib_saint:login(HGhostPs),
    %% 婚姻
    MarriagePs = lib_marriage:marriage_login(SaintPs, GoodsStatus),
    %% 宝宝
    BabyPs = lib_marriage:baby_login(MarriagePs),
    %% 幻兽之域
    EudemonsBossPs = lib_eudemons_land:eudemons_boss_login(BabyPs),
    %% 护送
    HuSongPs = lib_husong:husong_login(EudemonsBossPs),
    %% 七天登录
    LoginRewardPs = lib_login_reward:login_reward_login(HuSongPs),
    %% 合成七天登录
    LoginMergeRewardPs = lib_login_reward_merge:login_reward_login(LoginRewardPs),
    %% 家园
    HousePs = lib_house:house_login(LoginMergeRewardPs),
    %% 龙珠
    DragonBallPs = lib_dragon_ball:login(HousePs),
    %% 主角光环
    HaloPs = lib_hero_halo:login(DragonBallPs),
    %%灵器
    AnimaEquipPs = lib_anima_equip:login(HaloPs, GoodsStatus),
    %% 圣裁
    ArbitramentPs = lib_arbitrament:login(AnimaEquipPs),
    %% 副本学习技能
    DunLearnSkillPs = lib_dungeon_learn_skill:login(ArbitramentPs),
    %% 装备属性计算
    {ok, EquipPs} = lib_goods_util:init_role_equip_attribute(DunLearnSkillPs),
    %% 套装收集
    SuitCltPs = lib_suit_collect:login(EquipPs),
    %% 超值礼包
    OverGiftPs = lib_overflow_gift:login(SuitCltPs),
    %% 精品特卖
    SpecSellPs = lib_spec_sell_act:login(OverGiftPs),
    %% 收集活动
    CollectPs = lib_collect:collect_login(SpecSellPs),
    %% 幸运鉴宝
    TEPs = lib_treasure_evaluation:login_te(CollectPs),
    %% boss
    BossPs = lib_boss:login(TEPs),
    %% 竞榜活动
    RacePS = lib_race_act:login(BossPs),
    %% 冲榜夺宝
    RushTreasurePS = lib_rush_treasure_player:login(RacePS),
    %% 魔法阵
    MagicCirclePS  = lib_magic_circle:login(RushTreasurePS),
    %% 属性药剂
    AttrMedicament = lib_attr_medicament:login(MagicCirclePS),
    %%活跃度找回
    LiveNessBackPs = lib_liveness:login_for_liveness_back(AttrMedicament),
    %%活跃度找回
    RuneHuntPS = lib_rune_hunt:login(LiveNessBackPs),
    %% 副本
    DungeonPs = lib_dungeon:login(RuneHuntPS),
    %% 公会战
    GuildBattlePs = lib_guild_battle:login(DungeonPs),
    %% 公会领地战
    TerriWarPs = lib_territory_war:login(GuildBattlePs),
    %% 神兵租借
    HireActPs = lib_custom_act_holyorgan_hire:login(TerriWarPs),
    %% 邀请
    InvitePs = lib_invite:login(HireActPs),
    %% 功能预告
    ModOpenPs = lib_module_open:login(InvitePs),
    %% 任务掉落
    TaskDropPs = lib_task_drop:login(ModOpenPs),
    %% 使魔
    DemonsPS = lib_demons:login(TaskDropPs),
    %% 神殿觉醒
    TemplePs = lib_temple_awaken:login(DemonsPS),
    %% 初始化(生活技能)功能buff列表：生成buff列表的模块放在前面初始化, 用到buff列表的模块放在后面初始化
    ModuleBuffPS = lib_module_buff:login(TemplePs),
    %% 离线挂机初始化
    OnHookPS = lib_onhook:onhook_login(ModuleBuffPS),
    %% 离线挂机修复(跟在 lib_onhook:onhook_login 后面)
    OnHookFixPS = lib_onhook_offline:login_for_onhook_fix_ref(OnHookPS),
    %% 限时礼包
    LimitGiftPS = lib_limit_gift:login(OnHookFixPS),
    %% 圣域
    SanctuaryPs = lib_sanctuary:login(LimitGiftPS),
    %% top_pk
    TopPkPs = lib_top_pk:load_data(SanctuaryPs),
    %% 节日首冲
    FestivalRecharge = lib_festival_recharge:login(TopPkPs),
    %% 累充有礼
    %% RechargePolitePs = lib_custom_act_recharge_polite:login(FestivalRecharge),
    %% 神圣召唤
    HolySummon = lib_holy_summon:login(FestivalRecharge),
    %% 聚魂本
    SoulDunPS = lib_soul_dungeon:login(HolySummon),
    %% 节日活跃奖励
    CustomActLivenessPS = lib_custom_act_liveness:login(SoulDunPS),
    %%   惊喜礼包
    SurprisePS = lib_surprise_gift:login(CustomActLivenessPS),
    %% 赛博夺宝
    BonusDrawPs = lib_bonus_draw:init_data(SurprisePS),
    %% 神佑祈愿
    PrayPs = lib_bonus_pray:login(BonusDrawPs),
    %% 宝宝
    BabyPS = lib_baby:login(PrayPs),
    %% 天启装备
    RevelationEquipPS = lib_revelation_equip:login(BabyPS),
    %% 节日投资
    FestInvestPS = lib_festival_investment:login(RevelationEquipPS),
    %% 永恒圣殿
    SanctumPS = lib_kf_sanctum:login(FestInvestPS),
    %% 寻宝
    HuntPS = lib_treasure_hunt_data:login(SanctumPS),
    %% 圣灵战场
    HolySpiritBattlefieldPS = lib_holy_spirit_battlefield:login(HuntPS),
    %% 时空裂缝
    ChronoRiftPS = lib_local_chrono_rift_act:login(HolySpiritBattlefieldPS),
    %%公会神像
    %% 时空裂缝
    GuildGodPS = lib_guild_god:login(ChronoRiftPS),
    %% 使魔副本
    DemonDunPS = lib_dun_demon:login(GuildGodPS),
    %% 使魔副本
    PartnerDunPS = lib_dungeon_partner:login(DemonDunPS),
    %% 3v3战队
    Team3v3PS = lib_3v3_local:login2(PartnerDunPS),
    %% 日常预约
    SignUpPS = lib_act_sign_up:login(Team3v3PS),
    %% 国战日常
    SeaDailyPS = lib_seacraft_daily:login(SignUpPS),
    %% 封测--登陆献礼
    BetaPS = lib_beta_login:login(SeaDailyPS),
    %% 离线挂机
    AfkPS = lib_afk:login(BetaPS, LoginType),
    %% 至尊vip
    SupvipPS = lib_supreme_vip:after_login(AfkPS, LoginType),
    %% 自选宝箱抽奖
    SelectPoolPS = lib_select_pool_draw:login(SupvipPS),
    %% 背饰
    BackDecraPS = lib_back_decoration:login(SelectPoolPS),
    %% 等级礼包
    LevelPs = lib_level_act:login(BackDecraPS, LoginType),
    %% 幻饰boss
    DecorationBossPS = lib_decoration_boss:login(LevelPs),
    % 封测返还
    BetaReturnPS = lib_beta_recharge_return:login(DecorationBossPS),
    % 许愿池
    BonusPoolPS = lib_bonus_pool:login(BetaReturnPS),
    % 周常本数据
    WeekDunPS = lib_week_dungeon:login(BonusPoolPS),
    HiPs = lib_hi_point:login(WeekDunPS),
    %% boss转盘
    BossRotaryPS = lib_boss_rotary:login(HiPs),
    %% 神庭
    GodCourtPs = lib_god_court:login(BossRotaryPS),
    %% 蒙面
    MaskPS = lib_mask_role:login(GodCourtPs),
    %% 红斑返利
    EnvelopeRebatePS = lib_envelope_rebate:login(MaskPS),
    %% 任务Map
    TaskMapPS = lib_task_map:login(EnvelopeRebatePS),
    %% 问卷调查
    QuestionPS = lib_questionnaire:login(TaskMapPS),
    %% 推送礼包
    PushGiftPs = lib_push_gift:login(QuestionPS),
    %% 海战功勋
    SeaExploitPs = lib_seacraft_extra:login_exploit(PushGiftPs),
    %% 战甲
    AmourPS = lib_armour:login(SeaExploitPs),
    %% vip更新(有可能会触发vip升级，计算玩家战力，导致报错(其他模块还未初始化)，放到最后调用)
    VipUpdatePs = lib_vip:after_login(AmourPS),
    %% 时装套装位置可激活数量初始化
    lib_fashion_suit:init_conform_num_and_attr(VipUpdatePs),
    %% 属性计算
    CountAttrPS1 = lib_player:count_player_attribute(VipUpdatePs),
    %% 坐骑、伙伴...真实战力计算
    CountAttrPS2 = lib_mount:after_login(CountAttrPS1),
    %% 星宿真实战力计算
    ConstellationPS = lib_constellation_equip:after_login(CountAttrPS2),
    %% 新boss首杀
    FirstBloodPs = lib_boss_first_blood_plus:login(ConstellationPS),
    %% 合服的名字冲突发送改名卡道具
    SendRenameCardPs = lib_rename:conflict_send_rename_card(FirstBloodPs),
    %% 战力冲榜
    UpPowerPs = lib_up_power:login(SendRenameCardPs),
    %% 助战礼包
    RankGiftPs = lib_common_rank_gift:login(UpPowerPs),
    %% 广告
    AdPS = lib_advertisement:login(RankGiftPs),
    %% 假人聊天
    ChatPS = lib_chat:login(AdPS),
    %% 祭典
    FiestaPS = lib_fiesta:login(ChatPS),
    %% 预约活动
    SubMailPS = lib_custom_subscribe_mail:login(FiestaPS),
    %% 周卡
    WeeklyCardPS = lib_weekly_card:login(SubMailPS),
    %% 符文本每日奖励状态
    RuneDunPS = lib_dungeon_rune:login(WeeklyCardPS),
    %% 战力福利数据
    CombatWelfarePs = lib_combat_welfare:login(RuneDunPS),
    %% 单人副本 限时爬塔数据
    LimitTowerPs = lib_dungeon_limit_tower:login(CombatWelfarePs),
    CycleRankPs = lib_cycle_rank:login(LimitTowerPs),
    %% 循环冲榜活动
    CycleRankActPs = lib_custom_cycle_rank:login(CycleRankPs),
    CycleRankOneActPs = lib_custom_cycle_rank_recharge:login(CycleRankActPs),
    RechargePs = lib_recharge:login(CycleRankOneActPs),
    %% 龙纹真实战力计算
    CountAttrPS =lib_dragon:calc_dragon_real_power(RechargePs, [], GoodsStatus),
    %% 进程字典应该在此消息的回调中初始化
    %% gen_server:cast(Pid, {'init_data', CountAttrPS}),
    %% 邮件初始化
    lib_mail:init_mail_dict(Id),
    %% 同步聊天代理信息
    sync_mod_chat_agent(CountAttrPS),
    %% 排行榜 login
    lib_common_rank_api:login(CountAttrPS),
    %% 开发冲榜
    lib_rush_rank_api:login(CountAttrPS),
    %% 队伍登录
    lib_team:login(CountAttrPS),
    %% 玩家展示
    lib_role:login(CountAttrPS),
    %% 离线期间的数据处理
    lib_player:handle_offline_data(CountAttrPS),
    %% 新角色信息上报
    lib_player_info_report:login(CountAttrPS),
    %% 开启决斗场活动
%%    mod_glad_local:act_start(0),
    %% 删档回归玩家返利
    %% lib_come_back:come_back_login(CountAttrPS, ComeBackState),
    %% mod_team_lock:login(CountAttrPS),
    %% 如果玩家是主宰公会会长要加上buff
    % case StatusGuild#status_guild.position == ?POS_CHIEF of
    %     true -> lib_guild_war_api:login(StatusGuild#status_guild.id, Id);
    %     false -> skip
    % end,
    %%累计登陆成就
    case utime:is_same_date(LastLoginTime, NowTime) of
        true -> skip;
        false ->
            lib_achievement_api:login_count_event(CountAttrPS,1)
    end,
    %% 代码都放在这之前
    %% 派发上线事件（不修改ps）
    lib_player_event:dispatch(CountAttrPS, ?EVENT_ONLINE_FLAG, 1),
    %% 保存在线信息
    save_online(CountAttrPS),
    ReconnectPS = lib_player_reconnect:login(CountAttrPS),
    ta_agent_fire:role_login(ReconnectPS, Source),
    %% 发行需要实时记录战力
    lib_player:update_player_state_combat(ReconnectPS, ReconnectPS#player_status.combat_power),
    CombatRef = erlang:send_after(180000, Pid, {'combat_ref', ReconnectPS#player_status.combat_power}),
    % ?MYLOG("hjhscene", "mod_login SceneId:~p ~n", [ReconnectPS#player_status.scene]),
    % 当天首次登录记录战力
    lib_role:update_role_first_combat(ReconnectPS),
    ModulePowerL = lib_player:get_module_power(ReconnectPS, ?LOG_POWER_MODULES),
    lib_log_api:log_login(Id, Ip, AccId, AccName, LoginType, ReconnectPS#player_status.combat_power,
        util:term_to_bitstring(ModulePowerL), ReconnectPS#player_status.scene,
        ReconnectPS#player_status.x, ReconnectPS#player_status.y, WxScene),
    ReconnectPS#player_status{combat_ref = CombatRef}.

%% 同步更新ETS中的角色数据
save_online(PlayerStatus) ->
    ets:insert(?ETS_ONLINE,
               #ets_online{
                  id  = PlayerStatus#player_status.id,
                  sid = PlayerStatus#player_status.sid,
                  pid = PlayerStatus#player_status.pid,
                  tid = PlayerStatus#player_status.tid
                 }).

%% 同步游戏性信息到mod_chat_agent服务器
sync_mod_chat_agent(PlayerStatus) ->
    mod_chat_agent:insert(
      #ets_unite{
         id = PlayerStatus#player_status.id,
         server_id = PlayerStatus#player_status.server_id,
         pid = PlayerStatus#player_status.pid,
         figure = PlayerStatus#player_status.figure,
         online = PlayerStatus#player_status.online,
         scene = PlayerStatus#player_status.scene,
         copy_id = PlayerStatus#player_status.copy_id,
         sid = PlayerStatus#player_status.sid,
         last_login_time = PlayerStatus#player_status.last_login_time,
         talk_lim = PlayerStatus#player_status.talk_lim,
         talk_lim_time = PlayerStatus#player_status.talk_lim_time,
         combat_power = PlayerStatus#player_status.combat_power
        }
     ).
