-module(lib_escort).

-include("common.hrl").
-include("escort.hrl").
-include("battle.hrl").
-include("scene.hrl").
-include("server.hrl").
-include("attr.hrl").
-include("guild.hrl").
-include("errcode.hrl").
-include("def_goods.hrl").
-include("figure.hrl").
-include("def_fun.hrl").
-include("def_module.hrl").
-include("predefine.hrl").
-include("goods.hrl").

-export([
        calc_act_time/1                 %% 计算当天下一次活动时间
        ,calc_act_time/2                %% 计算下一次活动时间
        ,re_login/1                     %% 重连处理
        ,get_revive_cost/0              %% 复活消耗
        ,check/1                        %% 检查
        ,get_config_after_check/1       %% 获取配置数据
        ,mon_hurt/3                     %% 攻击怪物
        ,send_escort_reward/7           %% 发放掠夺奖励
        ,send_escort_reward/2           %% 发放护送奖励
        ,send_rank_reward/7             %% 发放排名奖励
        ,mon_be_killed/12               %% 击杀怪物
        ,get_mon_type/1                 %% 获取水晶类型
        ,get_rob_max_times/0            %% 获取最大掠夺次数
        ,get_produce_type/0             %% 产出类型
        ,get_cost_type/0                %% 消耗类型
        ,mon_stop/1                     %% 怪物自我终结（AI结束）
        ,logout/1                       %% 登出
        ,mon_move/1                     %% 怪物移动（护送）
        ,walk_check_back/2              %% 怪物移动检测
        ,calc_zone_wlv/2                %% 计算怪物动态等级
        ,send_tv_to_all/3               %% 传闻发送
        ,get_mon_id/1                   %% 获取怪物id
        ,clear_scene_palyer/1           %% 清理房间玩家
        ,quit_timeout/1                 %% 踢玩家出场景
        ,get_mon_hp_percent/3           %% 计算水晶血量百分比
        ,is_in_a_circular/5             %% 判断是否在范围（圆）内
        ,get_mon_max_hp/2               %% 怪物最大血量
        ,sort_score_rank/1              %% 排行榜计算
        ,get_tv_args/6                  %% 组装传闻参数
        ,send_reward_and_notify/7       %% 发送奖励
        ,send_role_reward/6             %% 发放奖励并通知客户端
        ,send_TV_helper/4           
    ]).

%% -----------------------------------------------------------------
%% @doc  依据当前时间获取当天最近的一次活动开启时间戳
-spec calc_act_time(NowTime) ->  Return when
    NowTime     :: integer(),               %% 时间戳
    Return      :: tuple().                 %% 返回值{开始时间，结束时间}
%% -----------------------------------------------------------------
calc_act_time(NowTime) ->
    CfgList = data_escort:get_escort_value(open_time),
    {_, DayList} = ulists:keyfind(day, 1, CfgList, {day, []}),
    Day = utime:day_of_week(NowTime),
    case lists:member(Day, DayList) of
        true ->
            {_, TimeList} = ulists:keyfind(time, 1, CfgList, {time, []}),
            {_D,{NowSH,NowSM, NowSS}} = utime:unixtime_to_localtime(NowTime),
            case get_next_time({NowSH, NowSM, NowSS}, TimeList) of %%获取开启时间段中第一个大于nowtime的时间
                {ok, {{SH, SM}, {EH, EM}}} ->
                    TemStartT = utime:unixtime({_D, {SH, SM, 0}}),
                    TemEndT = utime:unixtime({_D, {EH, EM, 0}}),
                    {TemStartT, TemEndT};
                {ok, {{SH, SM, SS}, {EH, EM, ES}}} ->
                    TemStartT = utime:unixtime({_D, {SH, SM, SS}}),
                    TemEndT = utime:unixtime({_D, {EH, EM, ES}}),
                    {TemStartT, TemEndT};
                _ ->
                    {0,0}
            end;
        _ ->
            {0,0}
    end.

%% -----------------------------------------------------------------
%% @doc  依据当前时间从配置中获取最近的一次活动开启时间戳
-spec calc_act_time(NowTime, TimeList) ->  Return when
    NowTime     :: integer(),               %% 时间戳
    TimeList    :: list(),                  %% 配置开启、关闭时间[{{SH,SM,SS}, {EH,EM,ES}}]
    Return      :: tuple().                 %% 返回值{开始时间，结束时间}
%% -----------------------------------------------------------------
calc_act_time(NowTime, TimeList) ->
    {_D,{NowSH,NowSM, NowSS}} = utime:unixtime_to_localtime(NowTime),
    case get_next_time({NowSH, NowSM, NowSS}, TimeList) of %%获取开启时间段中第一个大于nowtime的时间
        {ok, {{SH, SM, SS}, {EH, EM, ES}}} ->
            TemStartT = utime:unixtime({_D, {SH, SM, SS}}),
            TemEndT = utime:unixtime({_D, {EH, EM, ES}}),
            {TemStartT, TemEndT};
        _ -> %% 当天开启时间已过，计算下一天开启时间
            NowDate = utime:unixdate(NowTime),
            {_DA,{DSH,DSM, DSS}} = utime:unixtime_to_localtime(NowDate+86400),
            case get_next_time({DSH,DSM, DSS}, TimeList) of %%获取开启时间段中第一个大于nowtime的时间
                {ok, {{SH, SM, SS}, {EH, EM, ES}}} ->
                    TemStartT = utime:unixtime({_DA, {SH, SM, SS}}),
                    TemEndT = utime:unixtime({_DA, {EH, EM, ES}}),
                    {TemStartT, TemEndT};
                _ ->
                    {0,0}
            end
    end.

%% -----------------------------------------------------------------
%% 返回第一个比TemS大的配置时间
%% -----------------------------------------------------------------
get_next_time({TemSH, TemSM, TemSS}, OpenList) ->
    Tem = (TemSH * 60 + TemSM) * 60 + TemSS,
    Fun = fun
        ({{SH, SM, _}, _}) ->
            Tem =< (SH * 60 + SM) * 60;
        ({{SH, SM}, _}) ->
            Tem =< (SH * 60 + SM) * 60
    end,
    ulists:find(Fun, OpenList).

%% -----------------------------------------------------------------
%% 玩家重连
%% -----------------------------------------------------------------
re_login(Player) ->
    #player_status{server_id = ServerId, scene = Scene, battle_attr = BA, id = RoleId, guild = #status_guild{id = GuildId}} = Player,
    #battle_attr{hp = Hp} = BA,
    case data_scene:get(Scene) of
        #ets_scene{type = ?SCENE_TYPE_ESCORT, x = X, y = Y} ->
            case Hp =< 0 of  %% 死亡重连丢回出生点
                true -> HpAttr = [{change_scene_hp_lim, 100}, {x,X}, {y,Y}];
                false -> HpAttr = []
            end,
            NewPlayer = lib_scene:change_relogin_scene(Player, [{ghost, 0}]++HpAttr),
            mod_escort_kf:reconnect(ServerId, GuildId, RoleId),
            {ok, NewPlayer};     
        _ ->
            {next, Player}
    end.

%% -----------------------------------------------------------------
%% 玩家登出
%% -----------------------------------------------------------------
logout(Player) ->
    #player_status{server_id = ServerId, scene = Scene, id = RoleId, guild = #status_guild{id = GuildId}} = Player,
    case data_scene:get(Scene) of
        #ets_scene{type = ?SCENE_TYPE_ESCORT} ->
            mod_escort_kf:exit(ServerId, GuildId, RoleId),
            {ok, Player};     
        _ ->
            {ok, Player}
    end.

%% -----------------------------------------------------------------
%% 复活消耗
%% -----------------------------------------------------------------
get_revive_cost() ->
    case data_escort:get_escort_value(revive_cost) of
        Cost when is_list(Cost) -> Cost;
        _ -> []
    end.

%% -----------------------------------------------------------------
%% 检查
%% -----------------------------------------------------------------
check(List) ->
    case do_check(List) of
        true -> true;
        {false, Code} -> {false, Code}
    end.
%% 检查是否满足消耗
do_check([{cost, Type, Player}|T]) ->
    #player_status{guild = #status_guild{position = Position}} = Player,
    case Position == ?POS_CHIEF orelse Position == ?POS_DUPTY_CHIEF of
        true ->  %% 不是会长/副会长不通过
            case data_escort:get_mon_type(Type) of
                #base_escort_mon{cost = Cost} when is_list(Cost) ->
                    case Cost of 
                        [{Type, GoodsTypeId, _Num}|_] when Type == ?TYPE_GFUNDS orelse GoodsTypeId == ?GOODS_ID_GFUNDS -> 
                            do_check(T); %% 公会资金不在这检测是否满足
                        _Num when is_integer(_Num) -> %% 数字则默认是公会资金
                            do_check(T);
                        _ -> 
                            case lib_goods_api:check_object_list(Player, Cost) of
                                {false, Code} -> {false, Code};
                                _ -> do_check(T)
                            end
                    end;
                _ -> 
                    {false, ?MISSING_CONFIG}
            end;
        _ -> {false, ?ERRCODE(err185_guild_position_limit)}
    end;
%% 检查水晶类型    
do_check([{config, Type}|T]) ->
    case data_escort:get_mon_type(Type) of
        #base_escort_mon{scene = _Scene, monid = _MonId} ->
            do_check(T);
        _ -> 
            {false, ?MISSING_CONFIG}
    end;

do_check(_) -> true.

%% -----------------------------------------------------------------
%% 获取水晶相关配置
%% -----------------------------------------------------------------
get_config_after_check(Type) ->
    case data_escort:get_mon_type(Type) of
        #base_escort_mon{scene = Scene, monid = MonId, cost = CostCfg, x = X, y = Y} ->
            case CostCfg of
                [{Type, GoodsTypeId, Num}|_] when Type == ?TYPE_GFUNDS orelse GoodsTypeId == ?GOODS_ID_GFUNDS ->
                    Cost = Num;
                [{_, _, _}|_] -> 
                    Cost = CostCfg; 
                _ -> 
                    Cost = []
            end,
            {Scene, MonId, Cost, X, Y};
        _ -> 
            {0,0,[], 0, 0}
    end.

%% -----------------------------------------------------------------
%% 怪物被攻击
%% -----------------------------------------------------------------
mon_hurt(Atter, Minfo, Hurt) ->
    #battle_return_atter{server_id = ServerId, server_num = _ServerNum, id = RoleId, real_name = _Name, guild_id = AttrGuildId} = Atter,
    #scene_object{scene = Scene, scene_pool_id = PoolId, copy_id = CopyId, config_id = Monid, id = MonAutoId, 
        figure = #figure{guild_id = GuildId, guild_name = _GuildName}, battle_attr = #battle_attr{hp = Hp}} = Minfo, 
    case data_scene:get(Scene) of
        #ets_scene{type = Type} when Type == ?SCENE_TYPE_ESCORT ->
            mod_escort_kf:mon_hurt(Scene, PoolId, CopyId, _ServerNum, ServerId, AttrGuildId, GuildId, Monid, RoleId, _Name, Hurt, MonAutoId, Hp);
        _ ->
            skip
    end.

%% -----------------------------------------------------------------
%% 怪物被击败
%% -----------------------------------------------------------------
mon_be_killed(Scene, ScenePoolId, CopyId, X, Y, ServerId, Monid, MonAutoId, MonLv, GuildId, AtterId, AtterName) ->
    case data_scene:get(Scene) of
        #ets_scene{type = Type} when Type == ?SCENE_TYPE_ESCORT ->
            mod_escort_kf:mon_be_killed(Scene, ScenePoolId, CopyId, X, Y, ServerId, Monid, MonAutoId, MonLv, GuildId, AtterId, AtterName);
        _ ->
            skip
    end.

%% -----------------------------------------------------------------
%% 怪物销毁（AI结束，怪物自我销毁）
%% -----------------------------------------------------------------
mon_stop(Minfo) ->
    #scene_object{scene = Scene, scene_pool_id = PoolId, copy_id = CopyId, config_id = Monid, id = MonAutoId, 
        figure = #figure{guild_id = GuildId, lv = MonLv}, battle_attr = #battle_attr{hp = Hp}, x = X, y = Y} = Minfo,
    case data_scene:get(Scene) of
        #ets_scene{type = Type} when Type == ?SCENE_TYPE_ESCORT ->
            mod_escort_kf:mon_stop(Scene, PoolId, CopyId, Monid, MonAutoId, MonLv, Hp, GuildId, X, Y);
        _ ->
            skip
    end.

%% -----------------------------------------------------------------
%% 护送走路检测返回（计算护送时长用）
%% -----------------------------------------------------------------
walk_check_back(Minfo, UserList) -> %UserList {Uid, USerId, Uname, Upos}
    #scene_object{scene = Scene, scene_pool_id = PoolId, copy_id = CopyId, config_id = Monid, id = MonAutoId, 
        figure = #figure{guild_id = GuildId}} = Minfo,
    case data_scene:get(Scene) of
        #ets_scene{type = Type} when Type == ?SCENE_TYPE_ESCORT ->
            mod_escort_kf:walk_check_back(Scene, PoolId, CopyId, Monid, MonAutoId, GuildId, UserList);
        _ ->
            skip
    end.

%% -----------------------------------------------------------------
%% 怪物移动
%% -----------------------------------------------------------------
mon_move(Minfo) ->
    #scene_object{scene = Scene, scene_pool_id = PoolId, copy_id = CopyId, config_id = Monid, id = MonAutoId, 
        figure = #figure{guild_id = GuildId}, x = X, y = Y, battle_attr = #battle_attr{hp = Hp, hp_lim = HpMax}} = Minfo,
    case data_scene:get(Scene) of
        #ets_scene{type = Type} when Type == ?SCENE_TYPE_ESCORT ->
            mod_escort_kf:mon_move(Scene, PoolId, CopyId, Monid, MonAutoId, GuildId, X, Y, Hp, HpMax);
        _ ->
            skip
    end.

%% -----------------------------------------------------------------
%% 获取水晶类型
%% -----------------------------------------------------------------
get_mon_type(MonId) ->
    case data_escort:get_escort_mon_type(MonId) of
        MonType when is_integer(MonType) -> MonType;
        _ -> 0
    end.

%% -----------------------------------------------------------------
%% 获取怪物id
%% -----------------------------------------------------------------
get_mon_id(MonType) ->
    case data_escort:get_escort_mon_id(MonType) of
        MonId when is_integer(MonId) -> MonId;
        _ -> 0
    end.

%% -----------------------------------------------------------------
%% 计算当前血量百分比
%% -----------------------------------------------------------------
get_mon_hp_percent(MonId, Hp, Lv) ->
    case data_mon_dynamic:get(MonId, Lv) of
        #mon_dynamic{hp=HpMax} when is_integer(HpMax) andalso HpMax > 0 -> (Hp*100) div HpMax;
        _ -> 0
    end.

%% -----------------------------------------------------------------
%% 获取怪物最大血量
%% -----------------------------------------------------------------
get_mon_max_hp(MonId, Lv) ->
    case data_mon_dynamic:get(MonId, Lv) of
        #mon_dynamic{hp=HpMax} -> HpMax;
        _ -> 1
    end.

%% -----------------------------------------------------------------
%% 获取最大掠夺次数
%% -----------------------------------------------------------------
get_rob_max_times() ->
    case data_escort:get_escort_value(rob_max_times) of
        Times when is_integer(Times) andalso Times > 0 -> Times;
        _ -> 0
    end.

%% -----------------------------------------------------------------
%% 产出消耗类型
%% -----------------------------------------------------------------
get_produce_type() -> escort_reward.
get_cost_type() -> escort_cost.
    % ProduceType = get_produce_type(),
    % Produce = #produce{type = ProduceType, subtype = 0, reward = Reward, remark = "escort_rob"},

%% -----------------------------------------------------------------
%% 发放水晶护送奖励(掠夺奖励)
%% -----------------------------------------------------------------
%% 场景进程执行
send_escort_reward(_, _, _, _, _, [], _) -> ok;
send_escort_reward(CopyId, Xo, Yo, MonType, MailRoleMap, Reward, Scene) ->
    %% 获取水晶被击杀时附近所有的玩家
    AllArea = lib_scene_calc:get_the_area(Xo, Yo),
    UserList = lib_scene_agent:get_all_area_user_by_bd(AllArea, CopyId),
    %% 圆的半径
    Radius = max(data_escort:get_escort_value(px_of_rob_reward), 1),
    case data_escort:get_mon_type(MonType) of
        #base_escort_mon{name = Name} -> skip;
        _ -> Name = <<>>
    end,
    List = maps:to_list(MailRoleMap),
    Title = utext:get(1850001),
    Fun = fun({ServerId, RoleList}, Acc) -> %% 一个一个服发放掠夺奖励
        handle_role_list(RoleList, UserList, Radius, Xo, Yo, Name, ServerId, Reward, Title, MonType, Scene, Acc)
    end,
    lists:foldl(Fun, [], List).

%% 判断是否在圆内
is_in_a_circular(Radius, X, Y, Xtmp, Ytmp) ->
    Radius2 = Radius*Radius,
    DX = Xtmp-X, DY = Ytmp-Y,
    abs(DX) =< Radius andalso abs(DY) =< Radius andalso DX*DX + DY*DY =< Radius2.

%% 发放奖励
handle_role_list([], _, _, _, _, _, _, _, _, _, _, RobRoleList) -> RobRoleList;
handle_role_list([{ServerNum, RoleId, RoleName, Position, GuildId, GuildName, Hurt, RestTimes, Score, KillScore}|RoleList], UserList, 
Radius, Xo, Yo, Name, ServerId, Reward, Title, MonType, Scene, RobRoleList) ->
    case lists:keyfind(RoleId, #ets_scene_user.id, UserList) of  %% 判断有伤害的玩家是否在附近
        #ets_scene_user{id = RoleId, x = X, y = Y, battle_attr = #battle_attr{hp = Hp}} ->
            InCircular = is_in_a_circular(Radius, Xo, Yo, X, Y), %% 确定是否在圆内
            if
                Hp > 0 andalso RestTimes > 0 andalso InCircular == true -> %% 血量不为0，还有掠夺次数，且在范围内才可获得奖励
                    Content = utext:get(1850002, [Name, RestTimes - 1]),
                    %% 日志
                    lib_log_api:log_escort_rob(ServerId, RoleId, RoleName, GuildId, GuildName, MonType, Scene, Hurt, Reward),
                    % mod_clusters_center:apply_cast(ServerId, lib_mail_api, send_sys_mail, [[RoleId], Title, Content, Reward]),
                    %% 发放奖励，协议告知客户端
                    mod_clusters_center:apply_cast(ServerId, lib_escort, send_reward_and_notify, [1, KillScore, Score, [RoleId], Reward, Title, Content]),
                    NewRobRoleList = [{ServerNum, ServerId, GuildName, GuildId, RoleId, RoleName, Position, RestTimes - 1, Score + KillScore}|RobRoleList];
                RestTimes == 0 -> %% 无掠夺次数不发奖励
                    Content = utext:get(1850002, [Name, 0]),
                    mod_clusters_center:apply_cast(ServerId, lib_escort, send_reward_and_notify, [1, KillScore, Score, [RoleId], [], Title, Content]),
                    lib_log_api:log_escort_rob(ServerId, RoleId, RoleName, GuildId, GuildName, MonType, Scene, Hurt, []),
                    NewRobRoleList = [{ServerNum, ServerId, GuildName, GuildId, RoleId, RoleName, Position, 0, Score + KillScore}|RobRoleList];
                true ->
                    NewRobRoleList = RobRoleList
            end;
        _ ->
            NewRobRoleList = RobRoleList
    end,
    handle_role_list(RoleList, UserList, Radius, Xo, Yo, Name, ServerId, Reward, Title, MonType, Scene, NewRobRoleList).

%% -----------------------------------------------------------------
%% 发放水晶护送奖励(护送奖励)
%% -----------------------------------------------------------------
send_escort_reward(MailRoleMap, EscortCfg) ->
    List = maps:to_list(MailRoleMap),
    #base_escort_reward{type = MonType, hp_max = Hp, escort_name = EscortName, person_reward = PerReward, score = Score} = EscortCfg,
    case data_escort:get_mon_type(MonType) of
        #base_escort_mon{name = Name} -> skip;
        _ -> Name = <<>>
    end,
    Title = utext:get(1850003),
    Content = ?IF(Hp == 0, utext:get(1850005, [Name]), utext:get(1850004, [EscortName, Name])),
    Fun = fun
        ({ServerId, RoleList}) when RoleList =/= [] ->
            % mod_clusters_center:apply_cast(ServerId, lib_mail_api, send_sys_mail, [RoleList, Title, Content, PerReward]);
            mod_clusters_center:apply_cast(ServerId, lib_escort, send_reward_and_notify, [2, 0, Score, RoleList, PerReward, Title, Content]);
        (_) -> skip
    end,
    PerReward =/= [] andalso lists:foreach(Fun, List),
    ok.

%% -----------------------------------------------------------------
%% 发放奖励
%% -----------------------------------------------------------------
send_reward_and_notify(ScoreType, KillScore, Score, RoleList, PerReward, Title, Content) ->
    Remark = ?IF(ScoreType == 1, "escort_rob", "escort"),%% 确定奖励类型做标记
    ProduceType = get_produce_type(),
    Produce = #produce{type = ProduceType, subtype = 0, reward = PerReward, remark = Remark},
    spawn(fun() -> 
        [begin
            timer:sleep(50),
            Pid = misc:get_player_process(RoleId),
            case misc:is_process_alive(Pid) of
                true -> %% 玩家进程还在奖励直接发背包
                    lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, ?NOT_HAND_OFFLINE, lib_escort, send_role_reward, 
                        [Produce, ScoreType, PerReward, Score, KillScore]);
                _ -> %% 奖励不为空玩家不在线则邮件发奖励
                    PerReward =/= [] andalso lib_mail_api:send_sys_mail(RoleList, Title, Content, PerReward)
            end
        end || RoleId <- RoleList]end).

%% -----------------------------------------------------------------
%% 发放奖励并通知客户端
%% -----------------------------------------------------------------
send_role_reward(PS, Produce, ScoreType, PerReward, Score, KillScore) ->
    lib_server_send:send_to_uid(PS#player_status.id, pt_185, 18514, [ScoreType, PerReward, Score, KillScore]),
    PerReward =/= [] andalso lib_goods_api:send_reward(PS, Produce),
    {ok, PS}.

%% -----------------------------------------------------------------
%% 活动结束发放排名奖励
%% -----------------------------------------------------------------
send_rank_reward(ServerId, Rank, RoleScoreList, Reward, GuildId, GuildName, GuildReward) ->
    Title = utext:get(1850006),
    Content = utext:get(1850007, [Rank]),
    spawn(fun() ->
        [begin 
            timer:sleep(20),
            lib_log_api:log_escort_rank(ServerId, RoleId, _RoleName, GuildId, GuildName, RobScore, Rank, Reward, GuildReward),
            mod_clusters_center:apply_cast(ServerId, lib_mail_api, send_sys_mail, [[RoleId], Title, Content, Reward])
         end || {RoleId, _Position, _RoleName, RobScore, EscortScore} <- RoleScoreList, RobScore > 0 orelse EscortScore > 0]end),
    ok.

%% -----------------------------------------------------------------
%% 生成怪物使用分区平均世界等级
%% -----------------------------------------------------------------
calc_zone_wlv(ServerIdList, ServerInfo) ->
    Fun = fun(ServerId, {Sum, Length}) ->
        case lists:keyfind(ServerId, 1, ServerInfo) of
            {ServerId, _Optime, WorldLv, _ServerNum, _ServerName} ->
                {Sum+WorldLv, Length+1};
            _ ->
                {Sum, Length+1}
        end
    end,
    {Total, Len} = lists:foldl(Fun, {0, 0}, ServerIdList),
    ?IF(Len =< 0, 0, Total div Len).

%% -----------------------------------------------------------------
%% 发送传闻
%% -----------------------------------------------------------------
send_tv_to_all(ServerId, MsgId, Args) ->
    case data_escort:get_escort_value(open_lv) of
        OpenLv when is_integer(OpenLv) -> OpenLv;
        _ -> OpenLv = 100
    end,
    mod_clusters_center:apply_cast(ServerId, lib_escort, send_TV_helper, [{all_lv, OpenLv, 999}, ?MOD_ESCORT, MsgId, Args]).

send_TV_helper(Type, Mod, MsgId, Args) ->
    case data_escort:get_escort_value(open_day) of
        OpenDay when is_integer(OpenDay) -> OpenDay;
        _ -> OpenDay = 50
    end,
    OpenD = util:get_open_day(),
    if
        OpenDay =< OpenD ->
          lib_chat:send_TV(Type, Mod, MsgId, Args);
        true ->
            skip
    end.

%% -----------------------------------------------------------------
%% 清理房间所有玩家
%% -----------------------------------------------------------------
clear_scene_palyer(CopyId) ->
    UserList = lib_scene_agent:get_scene_user(CopyId),
    [begin
        mod_clusters_center:apply_cast(ServerId, lib_player, apply_cast, [RoleId, ?APPLY_CAST_STATUS, lib_escort, quit_timeout, []])
    end|| #ets_scene_user{server_id = ServerId, id = RoleId}<-UserList].

%% -----------------------------------------------------------------
%% 清理玩家出场景
%% -----------------------------------------------------------------
quit_timeout(Ps)->
    case data_scene:get(Ps#player_status.scene) of
        #ets_scene{type = Type} when Type == ?SCENE_TYPE_ESCORT ->
            NewPs = lib_scene:change_scene(Ps, 0, 0, 0, 0, 0, true, [{group, 0}, {recalc_attr, 0}, {change_scene_hp_lim, 100}, {collect_checker, undefined}, {pk, {?PK_PEACE, true}}]),
            {ok, NewPs};
        _ ->
            {ok, Ps}
    end.

%% -----------------------------------------------------------------
%% 排行榜计算
%% -----------------------------------------------------------------
sort_score_rank(List) ->
    F = fun
        ({_, _, _, _, AScore, ATime}, {_, _, _, _, BScore, BTime}) ->
            if
                AScore > BScore -> true;
                AScore == BScore ->
                    ATime =< BTime;
                true -> false
            end
        % ({AScore, ATime} = A, {BScore, BTime} = B) ->
        %     if
        %         AScore > BScore -> true;
        %         AScore == BScore ->
        %             ATime =< BTime;
        %         true -> false
        %     end
    end,
    lists:sort(F, List).

%% -----------------------------------------------------------------
%% 组装传闻参数
%% -----------------------------------------------------------------
get_tv_args(Position, RoleId, RoleName, Cost, MonType, Scene) ->
    case data_escort:get_mon_type(MonType) of
        #base_escort_mon{name = NameStr} -> Name = util:make_sure_binary(NameStr);
        _ -> Name = <<>>
    end,
    case data_scene:get(Scene) of
        #ets_scene{name = SceneNameStr} -> SceneName = util:make_sure_binary(SceneNameStr);
        _ -> SceneName = <<>>
    end,
    case data_guild:get_guild_pos_cfg(Position) of
        #guild_pos_cfg{name = PositionName} -> PosName = util:make_sure_binary(PositionName);
        _ -> PosName = <<>>
    end,
    case Cost of
        [{Type, GoodsTypeId, Num}|_] ->
            GtypeId = get_real_goods_type(GoodsTypeId, Type),
            [PosName, RoleName, RoleId, GtypeId, Num, Name, SceneName, Scene];
        Num when is_integer(Num) ->
            [PosName, RoleName, RoleId, ?GOODS_ID_GFUNDS, Num, Name, SceneName, Scene];
        [{Type, Num}|_] ->
            GtypeId = get_real_goods_type(0, Type),
            [PosName, RoleName, RoleId, GtypeId, Num, Name, SceneName, Scene];
        true ->
            [PosName, RoleName, RoleId, 0, 0, Name, SceneName, Scene]
    end.

%% -----------------------------------------------------------------
%% 配置物品类型id转换为真实物品类型id(针对货币)
%% -----------------------------------------------------------------
get_real_goods_type(GoodsTypeId, Gtype) ->
    if
        GoodsTypeId =/= 0 ->
            GoodsTypeId;
        true ->
            if
                Gtype == ?TYPE_GOLD ->
                    ?GOODS_ID_GOLD;
                Gtype == ?TYPE_BGOLD ->
                    ?GOODS_ID_BGOLD;
                Gtype == ?TYPE_COIN ->
                    ?GOODS_ID_COIN;
                Gtype == ?TYPE_GFUNDS ->
                    ?GOODS_ID_GFUNDS;
                true ->
                    0
            end
    end.