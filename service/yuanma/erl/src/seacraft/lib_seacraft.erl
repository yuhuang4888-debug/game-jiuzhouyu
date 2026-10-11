%%%-----------------------------------
%%% @Module      : lib_seacraft
%%% @Author      : xlh
%%% @Email       : 1593315047@qq.com
%%% @Created     : 2020
%%% @Description : 怒海争霸工具方法、接口
%%%-----------------------------------
-module(lib_seacraft).

-include("common.hrl").
-include("seacraft.hrl").
-include("scene.hrl").
-include("def_module.hrl").
-include("predefine.hrl").
-include("def_fun.hrl").
-include("battle.hrl").
-include("attr.hrl").
-include("goods.hrl").
-include("server.hrl").
-include("guild.hrl").
-include("def_event.hrl").
-include("rec_event.hrl").
-include("figure.hrl").
-include("mail.hrl").

-export([
        get_server_info/0
        ,calc_act_time/1
        ,calc_act_type/2
        ,get_act_scene/2
        ,get_mon_list/1
        ,mon_create/5
        ,mon_create/6
        ,collect_mon_reborn/5
        ,fun_send_tv/2
        ,mon_be_hurt/3
        ,mon_be_kill/2
        ,mon_be_collect/2
        ,kill_player/6
        ,get_guild_realm/2
        ,get_hurt_mon_add_score/0
        ,get_kill_player_add_score/1
        ,get_reborn_point/2
        ,send_win_more_times_reward/4
        ,send_winer_reward/2
        ,send_reward_helper/2
        ,send_reward_normal/2
        ,send_role_reward/3
        ,send_role_reward/7
        ,change_role_realm_and_pos/4
        ,change_role_realm_and_pos/5
        ,re_login/1
        ,logout/1
        ,get_revive_cost/0
        ,get_revive_point/3
        ,db_replace_join_limit/5
        ,db_replace_sea_info/3
        ,do_after_change_camp/1
        ,do_after_change_camp/5
        ,calc_can_be_collect/3
        ,clear_scene_palyer/0
        ,quit_timeout/1
        ,handle_event/2
        ,get_update_role_info_time/0
        ,get_change_ship_time/0
        ,data_for_client/3
        ,get_scene_mon_list/1
        ,calc_next_act_time/1
        ,calc_next_act_time/4
        ,get_before_collect_id/3
        ,mon_create_2/6
        ,notify_role_be_remove/1
        ,notify_server_be_remove/1
        ,player_request/3
        ,sort_score_rank/1
        ,handle_data_for_join_camp/1
        ,calc_average_lv/2
        ,remove_role_dsgt/1
        ,active_role_dsgt/1
        ,role_dsgt_op_core/2
        ,remove_all_dsgt/0
        ,notify_role_act_reset/0
        ,is_in_seacraft/1
        ,check_skill/2
        ,update_sea_guild_info/3
        ,update_sea_job_info/3
        ,update_sea_apply_info/3
        ,make_record/2
        ,gm_remove_act_dsgt/0
        ,is_reset_day/1
        ,is_reset_day/2
    ]).

%% -----------------------------------------------------------------
%% 玩家数据收集，统一更新到跨服
%% -----------------------------------------------------------------
handle_event(PS, #event_callback{type_id = ?EVENT_LV_UP}) when is_record(PS, player_status) ->
    Openday = util:get_open_day(),
    case data_seacraft:get_value(open_day) of
        LimitOpenDay when is_integer(LimitOpenDay) andalso Openday >= LimitOpenDay -> %% 开服天数限制
            #player_status{id = RoleId, combat_power = Power,
                guild = #status_guild{realm = Camp}, figure = #figure{name = RoleName, lv = RoleLv, picture = Picture, picture_ver = PictureVer}} = PS,
            mod_seacraft_local:update_role_info(Camp, RoleId, RoleName, RoleLv, Power, Picture, PictureVer);
        _ ->
            skip
    end,
    {ok, PS};
handle_event(PS, #event_callback{type_id = ?EVENT_COMBAT_POWER}) when is_record(PS, player_status) ->
    Openday = util:get_open_day(),
    case data_seacraft:get_value(open_day) of
        LimitOpenDay when is_integer(LimitOpenDay) andalso Openday >= LimitOpenDay -> %% 开服天数限制
            #player_status{id = RoleId, combat_power = Power,
                guild = #status_guild{realm = Camp}, figure = #figure{name = RoleName, lv = RoleLv, picture = Picture, picture_ver = PictureVer}} = PS,
            mod_seacraft_local:update_role_info(Camp, RoleId, RoleName, RoleLv, Power, Picture, PictureVer);
        _ ->
            skip
    end,
    {ok, PS};
handle_event(PS, #event_callback{type_id = ?EVENT_PICTURE_CHANGE}) when is_record(PS, player_status) ->
    Openday = util:get_open_day(),
    case data_seacraft:get_value(open_day) of
        LimitOpenDay when is_integer(LimitOpenDay) andalso Openday >= LimitOpenDay -> %% 开服天数限制
            #player_status{id = RoleId, combat_power = Power,
                guild = #status_guild{realm = Camp}, figure = #figure{name = RoleName, lv = RoleLv, picture = Picture, picture_ver = PictureVer}} = PS,
            mod_seacraft_local:update_role_info(Camp, RoleId, RoleName, RoleLv, Power, Picture, PictureVer);
        _ ->
            skip
    end,
    {ok, PS};
handle_event(PS, #event_callback{type_id = ?EVENT_RENAME}) when is_record(PS, player_status) ->
    Openday = util:get_open_day(),
    case data_seacraft:get_value(open_day) of
        LimitOpenDay when is_integer(LimitOpenDay) andalso Openday >= LimitOpenDay -> %% 开服天数限制
            #player_status{id = RoleId, combat_power = Power,
                guild = #status_guild{realm = Camp}, figure = #figure{name = RoleName, lv = RoleLv, picture = Picture, picture_ver = PictureVer}} = PS,
            mod_seacraft_local:update_role_info(Camp, RoleId, RoleName, RoleLv, Power, Picture, PictureVer);
        _ ->
            skip
    end,
    {ok, PS};
handle_event(PS, _) ->
    {ok, PS}.

%% -----------------------------------------------------------------
%% @doc 判断当天是否赛季重置
-spec is_reset_day(StartTime) -> IsResetDay when
    StartTime       :: integer(),
    IsResetDay      :: boolean().
%% -----------------------------------------------------------------
is_reset_day(StartTime) ->
    NowTime = utime:unixtime(),
    is_reset_day(StartTime, NowTime).
%% -----------------------------------------------------------------
%% @doc 判断时间当天是否赛季重置
-spec is_reset_day(StartTime, Time) -> IsResetDay when
    StartTime       :: integer(),
    Time            :: integer(),
    IsResetDay      :: boolean().
%% -----------------------------------------------------------------
is_reset_day(StartTime, Time) ->
    IsSameDay = utime:is_today(StartTime),
    if
        IsSameDay == false ->
            {NextOpenTime, _} = lib_seacraft:calc_next_act_time(Time),
            utime:is_today(NextOpenTime-86400);
        true -> false
    end.
%% -----------------------------------------------------------------

%% -----------------------------------------------------------------
%% @doc  依据当前时间获取当天最近的一次活动开启时间戳(有可能是0，活动当天才不返回0)
-spec calc_act_time(NowTime) ->  Return when
    NowTime     :: integer(),               %% 时间戳
    Return      :: tuple().                 %% 返回值{开始时间，结束时间}
%% -----------------------------------------------------------------
calc_act_time(NowTime) ->
    DayList = data_seacraft:get_value(open_day_list),
    Day = utime:day_of_week(NowTime),
    case lists:member(Day, DayList) of
        true ->
            TimeList = data_seacraft:get_value(open_time),
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
%% @doc  获取游戏服信息，用于同步跨服中心数据时调用，防止合服后数据不准确
-spec get_server_info() ->  Return when
    Return      :: tuple().
%% -----------------------------------------------------------------
get_server_info() ->
    ServerId = config:get_server_id(),
    ServerNum = config:get_server_num(),
    ServerName = util:get_server_name(),
    MergeSerIds = config:get_merge_server_ids(),
    {ServerId, ServerNum, ServerName, MergeSerIds}.

%% -----------------------------------------------------------------
%% @doc  依据当前时间获取当天最近的一次活动开启时间戳(一定有值)
-spec calc_next_act_time(NowTime) ->  Return when
    NowTime     :: integer(),               %% 时间戳
    Return      :: tuple().                 %% 返回值{开始时间，结束时间}
%% -----------------------------------------------------------------
calc_next_act_time(NowTime) ->
    DayList = data_seacraft:get_value(open_day_list),
    TimeList = data_seacraft:get_value(open_time),
    Day = utime:day_of_week(NowTime),
    Distime = get_next_open_time(Day, 0, DayList),
    {_D,{NowSH,NowSM, NowSS}} = utime:unixtime_to_localtime(NowTime+Distime),
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
            NextMidnight = utime:unixdate(NowTime+86400),
            calc_next_act_time(NextMidnight + 60)
    end.

%% -----------------------------------------------------------------
%% 距离下一个开放日的时间差距（s）
%% -----------------------------------------------------------------
get_next_open_time(Day, TempTime, OpenDayList) -> 
    case Day =< 7 of
        true ->
            case lists:member(Day, OpenDayList) of
                true ->
                    TempTime;
                false ->
                    get_next_open_time(Day + 1, TempTime + 86400, OpenDayList)
            end;
        false ->
            get_next_open_time(1, TempTime, OpenDayList)
    end.

%% -----------------------------------------------------------------
%% 依据当前活动类型计算其他以及当前活动类型的活动时间
%% -----------------------------------------------------------------
calc_next_act_time({ActType, Num}, 0, _, NexActTimeList) -> %% 当天无开启时间
    {NextActType, NewNum} = calc_act_type(ActType, Num),
    NowTime = utime:unixtime(),
    {NextStartTime, NextEndTime} = calc_next_act_time(NowTime),
    List = lists:keystore(NextActType, 1, NexActTimeList, {NextActType, NextStartTime, NextEndTime}),
    calc_next_act_time({NextActType, NewNum}, NextStartTime, NextEndTime, List);
calc_next_act_time({ActType, Num}, StartTime, EndTime, NexActTimeList) ->
    NowTime = utime:unixtime(),
    if
        NowTime >= EndTime -> %% 活动结束重新计算各个类型活动时间
            {NextStartTime, NextEndTime} = calc_next_act_time(NowTime),
            List = lists:keystore(ActType, 1, NexActTimeList, {ActType, NextStartTime, NextEndTime}),
            calc_next_act_time({ActType, Num+1}, NextStartTime, NextEndTime, List);
        NowTime >= StartTime -> %% 活动开启中，
            {NextActType, NewNum} = calc_act_type(ActType, Num),
            {NextStartTime, NextEndTime} = calc_next_act_time(StartTime+60),
            NewList = lists:keystore(NextActType, 1, NexActTimeList, {NextActType, NextStartTime, NextEndTime}),
            calc_next_act_time({NextActType, NewNum+1}, NextStartTime, NextEndTime, NewList);
        true ->
            {NextActType, NewNum} = calc_act_type(ActType, Num+1),
            {NextStartTime, NextEndTime} = calc_next_act_time(StartTime+60),
            if
                NextActType == ActType ->
                    calc_next_act_time({NextActType, NewNum}, NextStartTime, NextEndTime, NexActTimeList);
                true ->
                    lists:keystore(NextActType, 1, NexActTimeList, {NextActType, NextStartTime, NextEndTime})
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
%% 计算下次活动类型
%% -----------------------------------------------------------------
calc_act_type(0, _) ->
    calc_act_type(1, 0);
calc_act_type(ActType, Num) ->
    CfgList = data_seacraft:get_value(act_change),
    {_, NeedNum, NextAct} = ulists:keyfind(ActType, 1, CfgList, {ActType, 1, 1}),
    if
        Num >= NeedNum ->
            {NextAct, 0};
        true ->
            {ActType, Num} 
    end.

%% -----------------------------------------------------------------
%% 计算场景内的怪物
%% -----------------------------------------------------------------
get_act_scene(ActType, Default) ->
    List = data_seacraft:get_value(act_scene),
    {_, Scene} = ulists:keyfind(ActType, 1, List, {ActType, Default}),
    Scene.

get_mon_list(Scene) ->
    data_seacraft:get_all_mon(Scene).

%% -----------------------------------------------------------------
%% 计算怪物是否可被攻击
%% -----------------------------------------------------------------
calc_mon_can_be_att(BeAttFirst, _, []) ->
    if
        BeAttFirst == ?CAN_BE_ATT_REBORN ->
            1; %% 不限制攻击
        true ->
            0  %% 限制攻击
    end;
calc_mon_can_be_att(BeAttFirst, MonId, MonInfoList) ->
    case lists:keyfind(MonId, 1, MonInfoList) of
        {_, _, _, AttBeLimit, _} -> AttBeLimit;
        _ -> 
            if
                BeAttFirst == ?CAN_BE_ATT_REBORN ->
                    1; %% 不限制攻击
                true ->
                    0  %% 限制攻击
            end
    end.

%% -----------------------------------------------------------------
%% 生成所有怪物
%% -----------------------------------------------------------------
mon_create(Scene, ZoneId, MonList, Realm, Wlv) ->
    mon_create(Scene, ZoneId, MonList, Realm, [], Wlv).

mon_create(Scene, ZoneId, MonList, Realm, Acc, Wlv) ->
    PoolId = ZoneId,
    CopyId = 0,
    % ?PRINT("{Scene, ZoneId, MonList, Realm}:~p~n",[{Scene, ZoneId, MonList, Realm}]),
    %% 设置动态障碍区域
    List = data_seacraft:get_all_areamark_id(Scene),
    MarkList = [{AreaMarkId, 1}||AreaMarkId <- List, AreaMarkId =/= 0],
    MarkList =/= [] andalso lib_scene:change_area_mark(Scene, ZoneId, 0, MarkList),
    %?MYLOG("zhsea", "Scene ~p MarkList ~p ~n", [Scene, MarkList]),
    % ?PRINT("================  MarkList:~p~n",[MarkList]),
    %% 先清怪物
    lib_mon:clear_scene_mon(Scene, PoolId, CopyId, 0),
    % lib_mon:clear_scene_mon_by_mids(Scene, 0, ZoneId, 0, MonList),
    Fun = fun
        (MonId, AccList) when MonId =/= 0 ->
            #base_seacraft_construction{x = X, y = Y, is_be_att = BeAttFirst, list = NextMonList, skill = _SkillId, areamark_id = _AreaMarkId} = 
                data_seacraft:get_mon_info(MonId, Scene),
            AttBeLimit = calc_mon_can_be_att(BeAttFirst, MonId, Acc), %% 判断怪物是否可以被攻击
            case NextMonList of
                [NextMon|_] -> ok;
                _ -> NextMon = 0
            end,
            case data_mon:get(MonId)  of
                #mon{type = MonType, hp_lim = HpLim} -> ok;
                _ -> MonType = 1, HpLim = 100
            end,
            case data_mon_dynamic:get(MonId, Wlv) of
                #mon_dynamic{hp=HpMax} -> skip;
                _ -> HpMax = HpLim
            end,
            % lib_scene:change_area_mark(Scene, PoolId, CopyId, [{AreaMarkId, 1}]),
            lib_mon:async_create_mon(MonId, Scene, PoolId, X, Y, MonType, CopyId, 1, [{is_be_atted, AttBeLimit}, {camp_id, Realm}, {auto_lv, Wlv}]),%, {skill, Skill}
            % if
            %     SkillId =/= 0 andalso AttBeLimit == 0 ->
            %         lib_skill_buff:mon_add_buff(Scene, PoolId, CopyId, MonId, SkillId, 1);
            %     true -> 
            %         skip
            % end,
            lists:keystore(MonId, 1, AccList, {MonId, HpMax, HpMax, AttBeLimit, NextMon});
        (_, AccList) -> AccList
    end,
    % spawn(fun() -> timer:sleep(5000), mod_scene_agent:apply_cast(Scene, 0, lib_seacraft, get_scene_mon_list, [ZoneId]) end),
    lists:foldl(Fun, Acc, MonList).
    % spawn(fun() -> 
    %     timer:sleep(3000), 
    %     [begin
    %         #base_seacraft_construction{skill = SkillId} = data_seacraft:get_mon_info(MonId, Scene),
    %         ?PRINT("AttBeLimit")
    %         AttBeLimit =/= 1 andalso lib_skill_buff:mon_add_buff(Scene, 0, ZoneId, MonId, SkillId, 1)
    %     end
    %     ||{MonId, _, _, AttBeLimit, _} <- NewAcc] 
    % end),
    % NewAcc.

%% -----------------------------------------------------------------
%% 复活怪物
%% -----------------------------------------------------------------
mon_create_2(Scene, ZoneId, MonList, Realm, Acc, Wlv) ->
    PoolId = ZoneId,
    CopyId = 0,
    %% 先清怪物
    lib_mon:clear_scene_mon_by_mids(Scene, PoolId, CopyId, 0, MonList),
    Fun = fun
        (MonId, AccList) when MonId =/= 0 ->
            #base_seacraft_construction{x = X, y = Y, is_be_att = BeAttFirst, list = NextMonList, skill = _SkillId, areamark_id = AreaMarkId} = 
                data_seacraft:get_mon_info(MonId, Scene),
            AttBeLimit = calc_mon_can_be_att(BeAttFirst, MonId, Acc),
            case NextMonList of
                [NextMon|_] -> ok;
                _ -> NextMon = 0
            end,
            case data_mon:get(MonId) of
                [] -> MonType = 1, HpLim = 100;
                #mon{type = MonType, hp_lim = HpLim} -> ok
            end,
            case data_mon_dynamic:get(MonId, Wlv) of
                #mon_dynamic{hp=HpMax} -> skip;
                _ -> HpMax = HpLim
            end,
            lib_scene:change_area_mark(Scene, PoolId, CopyId, [{AreaMarkId, 1}]), %% 生成怪物的同时激活动态障碍区
            lib_mon:async_create_mon(MonId, Scene, PoolId, X, Y, MonType, CopyId, 1, [{is_be_atted, AttBeLimit}, {camp_id, Realm}, {auto_lv, Wlv}]),%, {skill, Skill}
            % if
            %     SkillId =/= 0 andalso AttBeLimit == 0 ->
            %         lib_skill_buff:mon_add_buff(Scene, PoolId, CopyId, MonId, SkillId, 1);
            %     true -> 
            %         skip
            % end,
            lists:keystore(MonId, 1, AccList, {MonId, HpMax, HpMax, AttBeLimit, NextMon});
        (_, AccList) -> AccList
    end,
    lists:foldl(Fun, Acc, MonList).

get_scene_mon_list(CopyId) ->
    List = lib_scene_object_agent:get_scene_object(CopyId),
    ?MYLOG("xlh_mon", "Mon:~p~n",[List]).
    
%% -----------------------------------------------------------------
%% 采集怪生成
%% -----------------------------------------------------------------
collect_mon_reborn(Scene, ZoneId, MonId, Realm, CollectMonList) ->
    PoolId = ZoneId, CopyId = 0,
    #base_seacraft_construction{x = X, y = Y, conlect_mon = CollectMonId} = data_seacraft:get_mon_info(MonId, Scene),
    if
        CollectMonId == 0 ->
            CollectMonList;
        true ->
            case data_mon:get(CollectMonId) of
                [] -> MonType = 1;
                #mon{type = MonType} -> ok
            end,
            %% 计算采集怪采集冷却时间
            case lists:keyfind(CollectMonId, 1, CollectMonList) of
                {CollectMonId, _, Time} ->
                    NextCollectTime = Time;
                _ ->
                    Time = 0, NextCollectTime = 0
            end,
            lib_mon:async_create_mon(CollectMonId, Scene, PoolId, X, Y, MonType, CopyId, 1, [{camp_id, Realm}, {next_collect_time, NextCollectTime}]),
            lists:keystore(CollectMonId, 1, CollectMonList, {CollectMonId, 1, Time})
    end.
    
%% -----------------------------------------------------------------
%% 发送传闻
%% -----------------------------------------------------------------
fun_send_tv(TvId, Args) ->
    Type = all_lv,
    case data_seacraft:get_value(open_lv) of
        LimitLv when is_integer(LimitLv) ->
            Min = LimitLv, Max = 999;
        _-> Min = 200, Max = 999
    end,
    lib_chat:send_TV({Type, Min, Max}, ?MOD_SEACRAFT, TvId, Args).

%% -----------------------------------------------------------------
%% 攻击怪物
%% -----------------------------------------------------------------
mon_be_hurt(Atter, Minfo, _Hurt) ->
    #battle_return_atter{
        server_id = AtterServerId, 
        server_num = AtterServerNum, 
        id = AtterRoleId, 
        real_name = AtterName, 
        guild_id = AtterGuildId
    } = Atter,
    #scene_object{scene = Scene, scene_pool_id = PoolId, copy_id = CopyId, config_id = Monid, battle_attr = #battle_attr{hp = Hp}} = Minfo, 
    case data_scene:get(Scene) of
        #ets_scene{type = Type} when Type == ?SCENE_TYPE_SEACRAFT ->
            mod_kf_seacraft:mon_be_hurt(Scene, PoolId, CopyId, AtterServerNum, AtterServerId, AtterGuildId, 
                    Monid, AtterRoleId, AtterName, _Hurt, Hp);
        _ ->
            skip
    end.

%% -----------------------------------------------------------------
%% 采集怪采集
%% -----------------------------------------------------------------
mon_be_collect(Atter, Minfo) ->
    #mon_atter{
        server_id = AtterServerId
        ,name = AtterName
        ,id = AtterRoleId
        ,server_num = AtterServerNum
    } = Atter,
    #scene_object{scene = Scene, config_id = Monid} = Minfo, 
    case data_scene:get(Scene) of
        #ets_scene{type = Type} when Type == ?SCENE_TYPE_SEACRAFT ->
            mod_kf_seacraft:mon_be_revive(AtterServerId, AtterServerNum, Scene, Monid, AtterRoleId, AtterName);
        _ ->
            skip
    end.
    
%% -----------------------------------------------------------------
%% 击杀怪物
%% -----------------------------------------------------------------
mon_be_kill(_Atter, Minfo) ->
    #battle_return_atter{server_id = AttrServerId, server_num = AttrServerNum, id = AttrRoleId, real_name = AttrName, guild_id = AttGuildId} = _Atter,
    #scene_object{scene = Scene, scene_pool_id = PoolId, copy_id = CopyId, config_id = Monid} = Minfo, 
    case data_scene:get(Scene) of
        #ets_scene{type = Type} when Type == ?SCENE_TYPE_SEACRAFT ->
            mod_kf_seacraft:mon_be_kill(Scene, PoolId, CopyId, Monid, AttrServerId, AttrServerNum, AttGuildId, AttrRoleId, AttrName);
        _ ->
            skip
    end.

%% -----------------------------------------------------------------
%% 击败玩家
%% -----------------------------------------------------------------
kill_player(Scene, PoolId, DieId, DieName, Atter, HitList) ->
    #battle_return_atter{server_id = AttrServerId, server_num = AttrServerNum, id = AttrRoleId, real_name = _AttrName, guild_id = AttGuildId} = Atter,
    case data_scene:get(Scene) of
        #ets_scene{type = Type} when Type == ?SCENE_TYPE_SEACRAFT  ->
            mod_kf_seacraft:kill_player(Scene, PoolId, DieId, DieName, AttrServerId, AttrServerNum, AttGuildId, AttrRoleId, _AttrName, [HitId||#hit{id=HitId}<- HitList]);
        _ ->
            skip
    end.

%% -----------------------------------------------------------------
%% 判断是否是活动场景
%% -----------------------------------------------------------------
is_in_seacraft(Scene) ->
    case data_scene:get(Scene) of
        #ets_scene{type = Type} when Type == ?SCENE_TYPE_SEACRAFT  ->
            true;
         _ ->
            false
    end.

%% -----------------------------------------------------------------
%% 获取公会阵营归属
%% -----------------------------------------------------------------
get_guild_realm(_, []) -> 0;
get_guild_realm(GuildId, [{Camp, GuildIdList}|GuildCampList]) ->
    case lists:member(GuildId, GuildIdList) of
        true -> Camp;
        _ -> get_guild_realm(GuildId, GuildCampList)
    end.

%% -----------------------------------------------------------------
%% 攻击怪物增加积分
%% -----------------------------------------------------------------
get_hurt_mon_add_score() ->
    case data_seacraft:get_value(hurt_mon_add_score) of
        Score when is_integer(Score) -> Score;
        _ -> 0
    end.

%% -----------------------------------------------------------------
%% 击败、帮助击败积分奖励
%% -----------------------------------------------------------------
get_kill_player_add_score(AttType) ->
    if
        AttType == kill ->
            case data_seacraft:get_value(kill_player_add_score) of
                Score when is_integer(Score) -> Score;
                _ -> 0
            end;
        true ->
            case data_seacraft:get_value(help_kill_player_add_score) of
                Score when is_integer(Score) -> Score;
                _ -> 0
            end
    end.
    
%% -----------------------------------------------------------------
%% 获取不同出生点
%% -----------------------------------------------------------------
get_reborn_point(Scene, PointId) ->
    case data_seacraft:get_scene_born_info(Scene, PointId) of
        #base_seacraft_scene{x = X, y = Y} -> skip;
        _ ->
            case data_scene:get(Scene) of
                #ets_scene{x = X,y = Y} -> skip;
                _ ->
                    X = 0,
                    Y = 0
            end
    end,
    {X, Y}.

%% -----------------------------------------------------------------
%% 邮件发送奖励
%% -----------------------------------------------------------------
send_win_more_times_reward(RoleId, MailRoleId, Reward, BinData) ->
    lib_server_send:send_to_uid(RoleId, BinData),
    Title = utext:get(1860007),
    Content = utext:get(1850008),
    lib_mail_api:send_sys_mail([MailRoleId], Title, Content, Reward).

%% -----------------------------------------------------------------
%% 霸主额外奖励发送
%% -----------------------------------------------------------------
send_winer_reward(RoleId, Reward) ->
    Remark = "seacraft_winer",
    ProduceType = seacraft_reward,
    Pid = misc:get_player_process(RoleId),
    case data_seacraft:get_value(sea_master_dsgt_id) of
        DsgtId when is_integer(DsgtId) -> ok;
        _ -> DsgtId = 0
    end,
    DsgtId =/= 0 andalso lib_designation_api:active_dsgt_common(RoleId,  DsgtId), %% 激活霸主称号
    if
        Reward =/= [] ->
            Produce = #produce{type = ProduceType, subtype = 0, reward = Reward, remark = Remark},
            case misc:is_process_alive(Pid) of
                true -> %% 玩家进程还在奖励直接发背包
                    lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, ?NOT_HAND_OFFLINE, lib_seacraft, send_role_reward, 
                        [Produce, Reward]);
                _ -> %% 奖励不为空玩家不在线则邮件发奖励
                    Title = utext:get(1860005),
                    Content = utext:get(1850006),
                    lib_mail_api:send_sys_mail([RoleId], Title, Content, Reward)
            end;
        true ->
            skip
    end.
    
%% -----------------------------------------------------------------
%% 活动结束发送奖励
%% -----------------------------------------------------------------
send_reward_helper(ActType, List) ->
    Remark = "seacraft",
    ProduceType = seacraft_reward,
    Title = ?IF(ActType == ?ACT_TYPE_SEA_PART, utext:get(1860001), utext:get(1860003)),
    Fun = fun
        ({RoleId, ActRank, Rank, Score, Reward1, Reward2, ActRes}) when Reward2 =/= [] orelse Reward1 =/= [] ->%{RoleId, GuildRank, Rank, RankReward, Reward, ActRes}
            timer:sleep(20),
            Produce = #produce{type = ProduceType, subtype = 0, reward = Reward1++Reward2, remark = Remark},
            Pid = misc:get_player_process(RoleId),
            case misc:is_process_alive(Pid) of
                true -> %% 玩家进程还在奖励直接发背包
                    lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, ?NOT_HAND_OFFLINE, lib_seacraft, send_role_reward, 
                        [Produce, ActType, Rank, Score, Reward1, Reward2]);
                _ -> %% 奖励不为空玩家不在线则邮件发奖励
                    Content = ?IF(ActType == ?ACT_TYPE_SEA_PART, utext:get(1860002, [Rank]), utext:get(1860004, [Rank])),
                    lib_mail_api:send_sys_mail([RoleId], Title, Content, Reward1++Reward2)
            end,
            {ok, Bin} = pt_186:write(18612, [ActRes, ActRank, Rank, Reward1++Reward2, []]),
            lib_server_send:send_to_uid(RoleId, Bin);
        (_) -> skip
    end,
    spawn(fun() -> lists:foreach(Fun, List) end).
    
%% -----------------------------------------------------------------
%% 每日福利
%% -----------------------------------------------------------------
send_reward_normal(RoleId, Reward) ->
    Pid = misc:get_player_process(RoleId),
    case misc:is_process_alive(Pid) of
        true -> %% 玩家进程还在奖励直接发背包
            Remark = "seacraft",
            ProduceType = seacraft_reward,
            Produce = #produce{type = ProduceType, subtype = 0, reward = Reward, remark = Remark},
            lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, ?NOT_HAND_OFFLINE, lib_seacraft, send_role_reward, 
                [Produce, Reward]);
        _ -> %% 奖励不为空玩家不在线则邮件发奖励
            Title = utext:get(1860009), Content = utext:get(1860010),
            lib_mail_api:send_sys_mail([RoleId], Title, Content, Reward)
    end.

%% -----------------------------------------------------------------
%% 发放奖励
%% -----------------------------------------------------------------
send_role_reward(PS, Produce, ActType, Rank, Score, Reward1, Reward2) ->
    #player_status{
        id = RoleId,  figure = #figure{name = RoleName},
        guild = #status_guild{name = GuildName, id = GuildId, realm = Camp}
    } = PS,
    lib_log_api:log_seacraft_reward(Camp, GuildId, GuildName, ActType, RoleId, RoleName, Rank, Score, Reward1, Reward2),
    NewPlayer = lib_goods_api:send_reward(PS, Produce),
    {ok, NewPlayer}.

send_role_reward(PS, Produce, _Reward) ->
    % lib_server_send:send_to_uid(PS#player_status.id, pt_185, 18514, [ScoreType, PerReward, Score, KillScore]),
    NewPlayer = lib_goods_api:send_reward(PS, Produce),
    {ok, NewPlayer}.

%% -----------------------------------------------------------------
%% 场景执行，阵营互换的时候自动将玩家丢到复活点并且更改玩家攻守状态
%% -----------------------------------------------------------------
change_role_realm_and_pos(AttDefList, DividePoint, Scene, PoolId) ->
    UserList = lib_scene_agent:get_scene_user(),
    [begin
        Args = [AttDefList, DividePoint, Scene, PoolId],
        ?PRINT("===========RoleId:~p Group:~p~n",[RoleId, Group]),
        mod_clusters_center:apply_cast(ServerId, lib_player, apply_cast, [RoleId, ?APPLY_CAST_STATUS, lib_seacraft, change_role_realm_and_pos, Args])
     end || #ets_scene_user{server_id = ServerId, id = RoleId, battle_attr = #battle_attr{group = Group}} <- UserList].

change_role_realm_and_pos(PS, AttDefList, DividePoint, Scene, PoolId) ->
    {Realm, X, Y} = calc_realm(PS, Scene, AttDefList, DividePoint),
    ?PRINT("===========RoleId:~p Group:~p~n",[PS#player_status.id, PS#player_status.battle_attr#battle_attr.group]),
    lib_scene:player_change_scene(PS#player_status.id, Scene, PoolId, 0, X, Y, false, [{camp, Realm}, {change_scene_hp_lim, 100}]),
    {ok, PS}.

%% -----------------------------------------------------------------
%% 计算玩家攻守状态
%% -----------------------------------------------------------------
calc_realm(_PS, Scene, [], _) -> {X, Y} = lib_seacraft:get_reborn_point(Scene, 1), {1, X, Y};
calc_realm(PS, Scene, [{Realm, List}|T], DividePoint) ->
    #player_status{guild = #status_guild{id = GuildId, realm = Camp}} = PS,
    case List of
        [{_, _}|_] ->
            case lists:keyfind(GuildId, 1, DividePoint) of
                {_, PointId} -> skip;
                _ -> PointId = 1
            end,
            {X, Y} = lib_seacraft:get_reborn_point(Scene, PointId),
            case lists:keyfind(GuildId, 2, List) of
                {_, _} -> {Realm, X, Y};
                _ -> calc_realm(PS, Scene, T, DividePoint)
            end;
        [_|_] ->
            case lists:keyfind(Camp, 1, DividePoint) of
                {_, PointId} -> skip;
                _ -> PointId = 1
            end,
            {X, Y} = lib_seacraft:get_reborn_point(Scene, PointId),
            case lists:member(Camp, List) of
                true -> {Realm, X, Y};
                _ -> calc_realm(PS, Scene, T, DividePoint)
            end;
        _ -> calc_realm(PS, Scene, T, DividePoint)
    end.

%% -----------------------------------------------------------------
%% 玩家重连
%% -----------------------------------------------------------------
re_login(Player) ->
    #player_status{server_id = ServerId, scene = Scene, battle_attr = BA, id = RoleId, guild = #status_guild{id = GuildId, realm = Camp}} = Player,
    #battle_attr{hp = Hp} = BA,
    case data_scene:get(Scene) of
        #ets_scene{type = ?SCENE_TYPE_SEACRAFT} ->
            case Hp =< 0 of  %% 死亡重连丢回出生点
                true -> HpAttr = [{change_scene_hp_lim, 100}];
                false -> HpAttr = []
            end,
            % NewPlayer = lib_scene:change_relogin_scene(Player, [{ghost, 0}]++HpAttr),
            mod_kf_seacraft:reconnect(ServerId, GuildId, Scene, Camp, RoleId, [{ghost, 0}]++HpAttr),
            {ok, Player};     
        _ ->
            {next, Player}
    end.

%% -----------------------------------------------------------------
%% 玩家登出
%% -----------------------------------------------------------------
logout(Player) ->
    #player_status{server_id = _ServerId, scene = Scene, id = _RoleId, guild = #status_guild{id = _GuildId}} = Player,
    case data_scene:get(Scene) of
        #ets_scene{type = ?SCENE_TYPE_SEACRAFT} ->
            % mod_server_cast:set_data_sub([{group, 0}, {camp_id, 0}], Player),
            {ok, Player};     
        _ ->
            {ok, Player}
    end.

%% -----------------------------------------------------------------
%% 复活消耗及出生点
%% -----------------------------------------------------------------
get_revive_cost() ->
    case data_seacraft:get_value(revive_cost) of
        Cost when is_list(Cost) -> Cost;
        _ -> []
    end.

get_revive_point(Scene, Camp, GuildId) ->
    case mod_seacraft_local:get_divide_point(Scene, Camp, GuildId) of
        {X, Y} when is_integer(X) andalso is_integer(Y) -> {X, Y};
        _ -> {0,0}
    end.

%% -----------------------------------------------------------------
%% 数据库操作
%% -----------------------------------------------------------------
db_replace_join_limit(ZoneId, Camp, JoinLimit, Master, WinReward) ->
    db:execute(io_lib:format(?REPLACE_SEA_CAMP, [ZoneId, Camp, util:term_to_bitstring(JoinLimit), util:term_to_bitstring(Master), util:term_to_bitstring(WinReward)])).

db_replace_sea_info(ZoneId, Camp, Times) ->
    db:execute(io_lib:format(?REPLACE_SEA_INFO, [ZoneId, Camp, Times])).

do_after_change_camp(GuildCampList) ->
    [mod_guild:update_guild_realm(0, 0, GuildId)|| {GuildId, _} <- GuildCampList].

do_after_change_camp(RoleId, Bin, Camp, OldCamp, GuildId) ->
    mod_guild:update_guild_realm(Camp, OldCamp, GuildId),
    lib_server_send:send_to_uid(RoleId, Bin).

%% -----------------------------------------------------------------
%% 计算是否可以被采集
%% -----------------------------------------------------------------
calc_can_be_collect(_Scene, _CopyId, 0) -> false;
calc_can_be_collect(_Scene, CopyId, CollectMonId) ->
    ReviveList = data_seacraft:get_value(can_be_revive_mon_list),
    BeforeMonId = get_before_collect_id(ReviveList, 0, CollectMonId), %% 获取前置采集怪
    if
        BeforeMonId == 0 orelse BeforeMonId == CollectMonId -> true;
        true ->
            case lib_scene_object_agent:get_scene_mon_by_mids(CopyId, [BeforeMonId], all) of
                [T|_] when is_record(T, scene_object) -> false;
                _ -> true
            end
    end.
    

%% -----------------------------------------------------------------
%% 清理房间所有玩家
%% -----------------------------------------------------------------
clear_scene_palyer() ->
    UserList = lib_scene_agent:get_scene_user(),
    [begin
        mod_clusters_center:apply_cast(ServerId, lib_player, apply_cast, [RoleId, ?APPLY_CAST_STATUS, lib_seacraft, quit_timeout, []])
    end|| #ets_scene_user{server_id = ServerId, id = RoleId}<-UserList].

%% -----------------------------------------------------------------
%% 清理玩家出场景
%% -----------------------------------------------------------------
quit_timeout(Ps)->
    case data_scene:get(Ps#player_status.scene) of
        #ets_scene{type = Type} when Type == ?SCENE_TYPE_SEACRAFT ->
            NewPs = lib_scene:change_scene(Ps, 0, 0, 0, 0, 0, true, [{group, 0}, {camp, 0}, {recalc_attr, 0}, {change_scene_hp_lim, 100}, {collect_checker, undefined}, {pk, {?PK_PEACE, true}}]),
            {ok, NewPs};
        _ ->
            {ok, Ps}
    end.

%% -----------------------------------------------------------------
%% 获取更新玩家数据间隔
%% -----------------------------------------------------------------
get_update_role_info_time() ->
    case data_seacraft:get_value(update_role_info_time) of
        Time when is_integer(Time) -> Time*60;
        _ -> 120
    end.

%% -----------------------------------------------------------------
%% 船只切换cd
%% -----------------------------------------------------------------
get_change_ship_time() ->
    case data_seacraft:get_value(change_ship_time) of
        Time when is_integer(Time) -> Time;
        _ -> 120
    end.

%% -----------------------------------------------------------------
%% 组装攻守方信息发送给客户端
%% -----------------------------------------------------------------
data_for_client(?ACT_TYPE_SEA_PART, AttdefList, GuildMap) ->
    {_, List} = ulists:keyfind(?ATTACKER, 1, AttdefList, {?ATTACKER, []}),
    {_, [{ServerId, GuildId}]} = ulists:keyfind(?DEFENDER, 1, AttdefList, {?DEFENDER, [{0,0}]}),
    GuildList = maps:get(ServerId, GuildMap, []),
    #sea_guild{server_num = ServerNum, guild_name = GuildName} = 
            ulists:keyfind(GuildId, #sea_guild.guild_id, GuildList, #sea_guild{}),
    SendDefList = [{ServerId, ServerNum, GuildId, GuildName}],
    SendAttList =
    [begin
        TemGuildList = maps:get(SerId, GuildMap, []),
        #sea_guild{server_num = SerNum, guild_name = GName} =
            ulists:keyfind(GId, #sea_guild.guild_id, TemGuildList, #sea_guild{}),
        {SerId, SerNum, GId, GName}
    end || {SerId, GId} <- List],
    {SendDefList, SendAttList};
data_for_client(_, AttdefList, _) ->
    % {_, List} = ulists:keyfind(?ATTACKER, 1, AttdefList, {?ATTACKER, []}),
    {_, [Camp|_]} = ulists:keyfind(?DEFENDER, 1, AttdefList, {?DEFENDER, [0]}),
    case data_seacraft:get_camp_name(Camp) of
        CampName when CampName =/= [] -> CampName;
        _ -> CampName = ""
    end,
    CampList = 
    case data_seacraft:get_all_camp() of
        List when is_list(List) andalso List =/= [] -> List;
        _ -> [1]
    end,
    SendAttList = 
    [begin 
        case data_seacraft:get_camp_name(TemCamp) of
            Name when Name =/= [] -> Name;
            _ -> Name = ""
        end,
        {0,0, TemCamp, Name}
     end || TemCamp <- lists:delete(Camp, CampList)],
    SendDefList = [{0,0,Camp, CampName}], 
    {SendDefList, SendAttList}.

%% -----------------------------------------------------------------
%% 计算前置采集怪
%% -----------------------------------------------------------------
get_before_collect_id([], _, _) -> 0;
get_before_collect_id([{Id1, _},{Id2, Value}|ReviveList], Before, Monid) ->
    if
        Monid == Id1 ->
            ?IF(Before == 0, Id1, Before);
        Monid == Id2 ->
            Id1;
        true ->
            get_before_collect_id([{Id2, Value}|ReviveList], Id1, Monid)
    end;
get_before_collect_id([{Id2, _}], Before, Monid) ->
    if
        Monid == Id2 ->
            ?IF(Before == 0, Id2, Before);
        true ->
            0
    end.

%% -----------------------------------------------------------------
%% 移除禁卫通知
%% -----------------------------------------------------------------
notify_server_be_remove(ServerRoleIdList) ->
    Fun = fun({ServerId, RoleIdList}) ->
        mod_clusters_center:apply_cast(ServerId, lib_seacraft, notify_role_be_remove, [RoleIdList])
    end,
    lists:foreach(Fun, ServerRoleIdList).

%% -----------------------------------------------------------------
%% 更新界面数据
%% -----------------------------------------------------------------
player_request(Player, Cmd, Args) ->
    {ok, NewPlayer} = pp_seacraft:handle(Cmd, Player, Args),
    {ok, NewPlayer}.

%% -----------------------------------------------------------------
%% 移除禁卫通知
%% -----------------------------------------------------------------
notify_role_be_remove(RoleIdList) ->
    Fun = fun(RoleId) ->
        Pid = misc:get_player_process(RoleId),
        case misc:is_process_alive(Pid) of
            true -> 
                lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, lib_seacraft, player_request, [18601, []]);
            _ -> skip
        end
    end,
    lists:foreach(Fun, RoleIdList).

%% -----------------------------------------------------------------
%% 禁卫列表排序
%% -----------------------------------------------------------------
sort_score_rank(List) ->
    F = fun
        (#sea_score{score = AScore, time = ATime}, #sea_score{score = BScore, time = BTime}) ->
            sort_score_rank_core(AScore, ATime, BScore, BTime);
        ({_, _, AScore, ATime}, {_, _, BScore, BTime}) ->
            sort_score_rank_core(AScore, ATime, BScore, BTime);
        ({_, AScore, ATime}, {_, BScore, BTime}) ->
            sort_score_rank_core(AScore, ATime, BScore, BTime)
    end,
    lists:sort(F, List).

sort_score_rank_core(AScore, ATime, BScore, BTime) ->
    if
        AScore > BScore -> true;
        AScore == BScore ->
            ATime =< BTime;
        true -> false
    end.

%% -----------------------------------------------------------------
%% 自动加入海域公会数据组装
%% -----------------------------------------------------------------
handle_data_for_join_camp(GuildMap) ->
    TempList =
        case is_map(GuildMap) of
            true ->
                maps:values(GuildMap);
            false ->
                case is_list(GuildMap) of
                    true -> GuildMap;
                    _ -> []
                end
        end,
    % CampList = 
    % case data_seacraft:get_all_camp() of
    %     List when is_list(List) andalso List =/= [] -> List;
    %     _ -> [1]
    % end,
    case data_seacraft:get_value(open_lv) of
        LimitLv when is_integer(LimitLv) -> skip;
        _ -> LimitLv = 500
    end,
    Fun = fun
        (Guild, Acc) when is_record(Guild, guild) ->
            #guild{
                id = GuildId, name = GuildName, realm = Realm, 
                chief_id = ChiefId, chief_name = ChiefName, 
                member_num = GuildUserNum, combat_power_ten = GuildPower
            } = Guild,
            if
                Realm =/= 0 ->
                    Acc;
                true ->
                    % Camp = urand:list_rand(CampList),
                    case lib_offline_player:get_player_info(ChiefId, all) of
                        #player_status{combat_power = Power, figure = #figure{lv = RoleLv, picture = Picture, picture_ver = PictureVer}} when RoleLv >= LimitLv ->
                            ServerId = config:get_server_id(),
                            ServerNum = config:get_server_num(),
                            % Tuple = {ServerId, ServerNum, GuildId, GuildName, GuildPower, ChiefId, ChiefName, GuildUserNum, Camp, RoleLv, Power, Picture},
                            Tuple = {ServerId, ServerNum, GuildId, GuildName, GuildPower, ChiefId, ChiefName, GuildUserNum, RoleLv, Power, Picture, PictureVer},
                            lists:keystore(GuildId, 3, Acc, Tuple);
                        _ ->
                            Acc
                    end     
            end;
        (_, Acc) -> Acc
    end,
    lists:foldl(Fun, [], TempList).

%% -----------------------------------------------------------------
%% 计算分区平均世界等级
%% -----------------------------------------------------------------
calc_average_lv(Serverids, ServersInfo) ->
    Fun = fun(ServerId, {Total, Length}) ->
        case lists:keyfind(ServerId, 1, ServersInfo) of
            {ServerId, _OpenTime, WorldLv,_,_} ->
                {Total+WorldLv, Length+1};
            _ ->
                {Total, Length}
        end
    end,
    {TotalLv, Length} = lists:foldl(Fun, {0,0}, lists:flatten(Serverids)),
    % ?PRINT("TotalLv:~p, Length:~p~n",[TotalLv, Length]),
    TotalLv div max(1, Length).

%% -----------------------------------------------------------------
%% 移除称号
%% -----------------------------------------------------------------
remove_role_dsgt(RemoveList) ->
    spawn(fun() -> 
        [begin 
            timer:sleep(20),
            mod_clusters_center:apply_cast(ServerId, lib_seacraft, role_dsgt_op_core, [List, remove]) 
        end|| {ServerId, List} <- RemoveList]
    end).

%% -----------------------------------------------------------------
%% 激活称号
%% -----------------------------------------------------------------
active_role_dsgt(RemoveList) ->
    spawn(fun() -> 
        [begin 
            timer:sleep(20),
            mod_clusters_center:apply_cast(ServerId, lib_seacraft, role_dsgt_op_core, [List, active]) 
        end|| {ServerId, List} <- RemoveList]
    end).

%% -----------------------------------------------------------------
%% 称号处理
%% -----------------------------------------------------------------
role_dsgt_op_core(List, remove) ->
    Fun = fun({RoleId, TemJobId}) ->
        case data_seacraft:get_daily_reward(TemJobId) of
            #base_seacraft_daily_reward{dsgt_id = DsgtId} -> 
                {ok, BinData} = pt_186:write(18626, [1]),
                lib_server_send:send_to_uid(RoleId, BinData),
                lib_designation_api:remove_dsgt(RoleId,  DsgtId);
            _ ->
                skip
        end
    end,
    lists:foreach(Fun, List);
role_dsgt_op_core(List, _) ->
    ?PRINT("List:~p~n",[List]),
    Fun = fun({RoleId, TemJobId}) ->
        case data_seacraft:get_daily_reward(TemJobId) of
            #base_seacraft_daily_reward{dsgt_id = DsgtId} -> 
                lib_designation_api:active_dsgt_common(RoleId,  DsgtId);
            _ ->
                skip
        end
    end,
    lists:foreach(Fun, List).

%% -----------------------------------------------------------------
%% 移除所有海域称号
%% -----------------------------------------------------------------
remove_all_dsgt() ->
    List = data_seacraft:get_all_dsgt_id(),
    case data_seacraft:get_value(sea_master_dsgt_id) of
        DsgtId when is_integer(DsgtId) -> ExtraList = [DsgtId];
        _ -> ExtraList = []
    end,
    lib_designation_api:remove_dsgt(ExtraList++lists:delete(0, List)).

gm_remove_act_dsgt() ->
    Openday = util:get_open_day(),
    case data_seacraft:get_value(open_day) of
        LimitOpenDay when is_integer(LimitOpenDay) andalso Openday < LimitOpenDay -> %% 开服天数限制
            remove_all_dsgt(),
            mod_kf_seacraft:gm_remove_act_dsgt(config:get_server_id());
        _ ->
            skip
    end.
%% -----------------------------------------------------------------
%% 通知所有满足条件玩家赛季重置
%% -----------------------------------------------------------------
notify_role_act_reset() ->
    case data_seacraft:get_value(open_lv) of
        LimitLv when is_integer(LimitLv) -> skip;
        _ -> LimitLv = 500
    end,
    Title = utext:get(1860011),
    Content = utext:get(1860012),
    lib_mail_api:send_sys_mail_to_all_on_game(Title, Content, [], [], LimitLv, ?SEND_LOG_TYPE_YES).

%% -----------------------------------------------------------------
%% 船只释放技能检查
%% -----------------------------------------------------------------
check_skill(Player, SkillId) ->
    #player_status{battle_attr = #battle_attr{group = Group}} = Player,
    Skill = data_seacraft:get_ship_skill(Group),
    case lists:keyfind(SkillId, 1, Skill) of
        {SkillId, SkillLv} when SkillLv > 0 -> {true, SkillLv};
        _ -> false
    end.

%% -----------------------------------------------------------------
%% 数据库保存数据
%% -----------------------------------------------------------------
update_sea_guild_info(ZoneId, Camp, SeaGuildMember) when is_record(SeaGuildMember, sea_guild) ->
    #sea_guild{
        server_id = ServerId,
        server_num = ServerNum,
        guild_id = GuildId,
        guild_name = GuildName,
        guild_power = GuildPower,
        role_id = RoleId,
        role_name = RoleName,
        member_num = Num,
        role_lv = RoleLv,
        combat_power = Power,
        picture = Picture,
        picture_ver = PictureVer
    } = SeaGuildMember,
    db:execute(io_lib:format(?REPLACE_SEA_GUILD, [ZoneId, Camp, ServerId, ServerNum, GuildId, 
        GuildName, GuildPower, RoleId, RoleName, Num, RoleLv, Power, Picture, PictureVer]));
update_sea_guild_info(ZoneId, Camp, A) -> ?ERR("error arg ZoneId:~p, Camp:~p A:~p~n",[ZoneId, Camp, A]), ok.

update_sea_job_info(ZoneId, Camp, JobMember) when is_record(JobMember, sea_job) ->
    #sea_job{
        server_id = ServerId,
        server_num = ServerNum,
        role_id = RoleId,
        role_name = RoleName,
        role_lv = RoleLv,
        job_id = JobId,
        combat_power = Power,
        picture = Picture,
        picture_ver = PictureVer
    } = JobMember,
    db:execute(io_lib:format(?REPLACE_SEA_JOB, [ZoneId, Camp, ServerId, ServerNum, Power, RoleId, RoleName, RoleLv, JobId, Picture, PictureVer]));
update_sea_job_info(ZoneId, Camp, A) -> ?ERR("error arg ZoneId:~p, Camp:~p A:~p~n",[ZoneId, Camp, A]), ok.

update_sea_apply_info(ZoneId, Camp, ApplyMember) when is_record(ApplyMember, sea_apply) ->
    #sea_apply{
        server_id = ServerId,
        server_num = ServerNum,
        role_id = RoleId,
        role_name = RoleName,
        role_lv = RoleLv,
        combat_power = Power,
        picture = Picture,
        picture_ver = PictureVer
    } = ApplyMember,
    db:execute(io_lib:format(?REPLACE_SEA_APPLY, [ZoneId, Camp, ServerId, ServerNum, Power, RoleId, RoleName, RoleLv, Picture, PictureVer]));
update_sea_apply_info(ZoneId, Camp, A) -> ?ERR("error arg ZoneId:~p, Camp:~p A:~p~n",[ZoneId, Camp, A]), ok.

%% -----------------------------------------------------------------
%% 生成record
%% -----------------------------------------------------------------
make_record(join_member, [ServerId, ServerNum, GuildId, RoleId, RoleName, RoleLv, Power, Picture, PictureVer, Camp]) ->
    #join_member{
        server_id = ServerId,
        server_num = ServerNum,
        guild_id = GuildId,
        role_id = RoleId,
        role_name = RoleName,
        role_lv = RoleLv,
        combat_power = Power,
        picture = Picture,
        picture_ver = PictureVer,
        camp = Camp
    };
make_record(sea_guild, [ServerId, ServerNum, GuildId, GuildName, GuildPower, RoleId, RoleName, Num, RoleLv, Power, Picture, PictureVer]) ->
    #sea_guild{
        server_id = ServerId,
        server_num = ServerNum,
        guild_id = GuildId,
        guild_name = GuildName,
        guild_power = GuildPower,
        role_id = RoleId,
        role_name = RoleName,
        member_num = Num,
        role_lv = RoleLv,
        combat_power = Power,
        picture = Picture,
        picture_ver = PictureVer
    };
make_record(sea_job, [ServerId, ServerNum, RoleId, RoleName, RoleLv, JobId, Power, Picture, PictureVer]) ->
    #sea_job{
        server_id = ServerId,
        server_num = ServerNum,
        role_id = RoleId,
        role_name = RoleName,
        role_lv = RoleLv,
        job_id = JobId,
        combat_power = Power,
        picture = Picture,
        picture_ver = PictureVer
    };
make_record(sea_apply, [ServerId, ServerNum, Picture, PictureVer, RoleLv, RoleId, RoleName, Power]) ->
    #sea_apply{
        server_id = ServerId,
        server_num = ServerNum,
        role_id = RoleId,
        role_name = RoleName,
        role_lv = RoleLv,
        combat_power = Power,
        picture = Picture,
        picture_ver = PictureVer
    };
make_record(sea_score, [ServerId, ServerNum, RoleId, Name, KillNum, Score, NowTime]) ->
    #sea_score{
        server_id = ServerId,
        server_num = ServerNum,
        role_id = RoleId,
        role_name = Name,
        kill_num = KillNum,
        score = Score,
        time = NowTime
    };
make_record(Record, Args) -> ?ERR("Record:~p, Args:~p~n",[Record, Args]), [].