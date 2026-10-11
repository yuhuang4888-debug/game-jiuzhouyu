%%%--------------------------------------
%%% @Module  : lib_activitycalen
%%% @Author  : xiaoxiang
%%% @Created : 2017-03-01
%%% @Description:  lib_activitycalen
%%%--------------------------------------
-module(lib_activitycalen).
-export([

    ]).
-compile(export_all).
-include("server.hrl").
-include("figure.hrl").
-include("role.hrl").
-include("boss.hrl").
-include("dungeon.hrl").
-include("errcode.hrl").
-include("activitycalen.hrl").
-include("vip.hrl").
-include("predefine.hrl").
-include("common.hrl").
-include("def_module.hrl").
-include("def_daily.hrl").
-include("def_event.hrl").
-include("custom_act.hrl").
-include("rec_event.hrl").
-include("goods.hrl").
-include("def_vip.hrl").
-include("jjc.hrl").
-include("def_fun.hrl").
-include("weekly_card.hrl").

%% 查询活动状态
%% 0未开启 1开启中 2结束
ask_activity_status(Player) ->
    #player_status{id = RoleId, figure = #figure{lv = Lv}} = Player,
    mod_activitycalen:ask_activity_status(RoleId, Lv).


%% 查询活跃度奖励
ask_live_reward(Player) ->
    #player_status{id = RoleId} = Player,
    Live      = mod_daily:get_count(RoleId, ?MOD_ACTIVITY, ?ACTIVITY_LIVE_DAILY),
    %% 每日最大活跃度
    LiveMax   = mod_daily:get_limit_by_type(?MOD_ACTIVITY, ?ACTIVITY_LIVE_DAILY),
    IdList    = data_activitycalen:get_reward_id(),
    CountList = mod_daily:get_count(RoleId, [{?MOD_ACTIVITY, ?MOD_ACTIVITY_LIVE_REWARD, Id} || Id <- IdList]),
    Info      = [{Id, Value} ||{{_, _, Id}, Value} <- CountList],
%%    ?DEBUG("~p~n", [{Live, LiveMax, Info}]),
    lib_server_send:send_to_uid(RoleId, pt_157, 15703, [Live, LiveMax, Info]).

% 兑换奖励
get_live_reward(Player, Id) ->
    #player_status{figure = #figure{lv = RoleLv}, id = RoleId}= Player,
    case check_get_reward(Player, Id) of
        {true, NewPlayerTmp} ->
            %?DEBUG("seesee", []),
            #ac_reward{reward = RewardList} = data_activitycalen:get_reward_config(Id),
            Reward = get_reward_by_lv(RoleLv, RewardList),
            case Id >= lists:max(data_activitycalen:get_reward_id()) of
                true ->
                    ExtraReward = lib_module_buff:get_livenss_extra_reward(Player);
                _ ->
                    ExtraReward = []
            end,
            %% 计算周卡额外奖励
            {NewReward, NewPlayerTmpA} = lib_weekly_card_api:cale_activity_reward(NewPlayerTmp, Reward),
            Produce = #produce{type = activity_live_reward, show_tips= 1, reward = NewReward ++ ExtraReward, remark=""},
            {ok, NewPlayer} = lib_goods_api:send_reward_with_mail(NewPlayerTmpA, Produce),
            %% 置为已领状态
            mod_daily:increment(RoleId, ?MOD_ACTIVITY, ?MOD_ACTIVITY_LIVE_REWARD, Id),
            lib_server_send:send_to_uid(RoleId, pt_157, 15705, [?SUCCESS ,Id]);
        {false, ErrCode, NewPlayer} ->
            %?DEBUG("ErrCode ~p~n", [ErrCode]),
            lib_server_send:send_to_uid(RoleId, pt_157, 15700, [ErrCode])
    end,
    {ok, NewPlayer}.

refresh_onhook_time(RoleId, OnhookTime) ->
    %?PRINT("~p~n", [OnhookTime]),
    lib_server_send:send_to_uid(RoleId, pt_157, 15714, [OnhookTime]).


%% -------------------------------------
% 玩家完成活动用于记录玩家活跃度
%% -------------------------------------
%% return #player_status{}
%% 玩家完成活动

%%%% 活跃度用4，总表用1,2
%%%%周任务特殊处理
%%role_success_end_activity(Player, ?MOD_TASK, ?week_task, Count) ->
%%    task_week_do(Player#player_status.id, ?MOD_TASK, ?week_task, Count);
role_success_end_activity(_Player, TempModule, TempModuleSub, Count) -> %Player.
    {Module, ModuleSub} = get_extra_ac(TempModule, TempModuleSub),
    _Player1 = lib_act_sign_up:role_success_end_activity(_Player, TempModule, TempModuleSub, Count),
    Player = lib_demons_api:role_success_end_activity(_Player1, TempModule, TempModuleSub, Count, 0),
    #player_status{id = RoleId, figure = #figure{lv = Lv}} = Player,
    %% 资源找回 的处理
    Data1 = #act_data{act_id = TempModule, act_sub = TempModuleSub, num = Count},
    lib_player_event:async_dispatch(RoleId, ?EVENT_PARTICIPATE_ACT, Data1),
%%    IsMaterialsDungeon = is_materials_dungeon(TempModule, TempModuleSub),
%%    if
%%        IsMaterialsDungeon == true ->
%%            NewModuleSub = ?DUNGEON_TYPE_MON_MATERIALS;  %%改为材料副本，材料副本的特殊处理
%%        true ->
%%            NewModuleSub = ModuleSub
%%    end,
    NewModuleSub = ModuleSub,
    IdList = data_activitycalen:get_ac_sub(Module, NewModuleSub),
    CheckList = [time, week, month, open_day, merge_day],
    #ac_liveness{name = _AcName, max = _Max, act_type = _ActType, live = Live, start_lv = StartLv, end_lv = EndLv} = data_activitycalen:get_live_config(Module, NewModuleSub),
    % Max = get_right_liveness_max_time(Module, NewModuleSub, _Max, Player#player_status.vip),
    {Max, _} = get_act_max_num_live(Player, Module, NewModuleSub),
    CheckRes = [1 || AcSub <- IdList, lib_activitycalen_util:do_check_ac_sub(data_activitycalen:get_ac(Module, NewModuleSub, AcSub), CheckList)],
    case lists:member(1, CheckRes) of
        true ->
            Value = mod_daily:get_count(RoleId, ?MOD_ACTIVITY, ?MOD_ACTIVITY_NUM, Module * ?AC_LIVE_ADD + NewModuleSub),  %%
%%            ?MYLOG("cym", "Value ~p  Max ~p StartLv ~p Lv ~p EndLv ~p Lv ~p~n",  [Value, Max, StartLv, Lv, EndLv, Lv]),
            case Value < Max andalso StartLv =< Lv andalso EndLv >= Lv andalso lib_module:is_open(?MOD_ACTIVITY, 0, Lv) of
                true ->
                    %%增加活跃度
                    add_liveness(Module, NewModuleSub, Count, RoleId, Live, _AcName, Value, Lv),
                    lib_activitycalen:ask_live_reward(Player);
%%                    %% 日常次数增加
%%                    %% 每日必做的完成了通知客户端红点状态
%%                    if
%%                        Value + Count >= Max andalso ActType == ?ACTIVITY_TYPE_DAILY ->
%%                           lib_activitycalen_mod:send_15706(Module, NewModuleSub, 1, ?AC_FINISH);
%%                        true -> skip
%%                    end,
%%                    mod_daily:plus_count(RoleId, ?MOD_ACTIVITY, ?MOD_ACTIVITY_NUM, Module * ?AC_LIVE_ADD + NewModuleSub, Count),
%%                    %% 活跃度增加 改为增加到可以领去的活跃度中
%%                    AddLive = Count * Live,
%%                    mod_daily:plus_count(RoleId, ?MOD_ACTIVITY, ?MOD_ACTIVITY_LIVE_NUM, Module * ?AC_LIVE_ADD + NewModuleSub, AddLive),
%%                    %%推一下协议
%%                    mod_activitycalen:ask_activity_num(RoleId, Lv, 0, 1);
                false ->
                    skip
            end;
        _ ->
            skip
    end,
    Player.

%%role_success_end_activity_offline(RoleId, ?MOD_TASK, ?MOD_TASK, Count) ->
%%    task_week_do(RoleId, ?MOD_TASK, ?week_task, Count);
role_success_end_activity_offline(RoleId, TempModule, TempModuleSub, Count) ->
    {Module, ModuleSub} = get_extra_ac(TempModule, TempModuleSub),
    case lib_role:get_role_show(RoleId) of
        #ets_role_show{figure = #figure{lv = Lv, vip = VipLv, vip_type = VipType}} ->
            %% 资源找回处理
            Data1 = #act_data{act_id = TempModule, act_sub = TempModuleSub, num = Count},
            lib_player_event:async_dispatch(RoleId, ?HAND_OFFLINE, ?EVENT_PARTICIPATE_ACT, Data1),
%%            IsMaterialsDungeon = is_materials_dungeon(TempModule, TempModuleSub),
%%            if
%%                IsMaterialsDungeon == true ->
%%                    NewModuleSub = ?DUNGEON_TYPE_MON_MATERIALS;  %%改为材料副本
%%                true ->
%%                    NewModuleSub = ModuleSub
%%            end,
            NewModuleSub = ModuleSub,
            IdList = data_activitycalen:get_ac_sub(Module, NewModuleSub),
            CheckList = [time, week, month, open_day, merge_day],
            #ac_liveness{name = AcName, max = _Max,live = Live, start_lv = StartLv, end_lv = EndLv} = data_activitycalen:get_live_config(Module, NewModuleSub),
            Max = get_right_liveness_max_time(Module, NewModuleSub, _Max, #role_vip{vip_type = VipType, vip_lv = VipLv}),
            CheckRes=[1 || AcSub <- IdList, lib_activitycalen_util:do_check_ac_sub(data_activitycalen:get_ac(Module, NewModuleSub, AcSub), CheckList)],
            case lists:member(1, CheckRes)of
                true ->
                    Value = mod_daily:get_count_offline(RoleId, ?MOD_ACTIVITY, ?MOD_ACTIVITY_NUM, Module * ?AC_LIVE_ADD + NewModuleSub),
                    case Value < Max andalso StartLv =< Lv andalso EndLv >= Lv andalso lib_module:is_open(?MOD_ACTIVITY, 0, Lv) of
                        true ->
                            add_liveness(Module, NewModuleSub, Count, RoleId, Live, AcName, Value, Lv);
                        _ ->
                            ok
                    end;
                _ ->
                    %?PRINT("FALSE ~n", []),
                    skip
            end;
        _ ->
            skip
    end.

get_extra_ac(TempModule, TempModuleSub) ->
    if
        true -> {TempModule, TempModuleSub}
    end.

%% 活动信息发送 - 15701
ask_activity_num(PS, Type, OnHookTime, Infos) ->
    #player_status{id = RoleId} = PS,
    F = fun(Info) -> get_new_act_info(PS, Info) end,
    NewInfos = lists:map(F, Infos),
    lib_server_send:send_to_uid(RoleId, pt_157, 15701, [Type, OnHookTime, NewInfos]),
    ok.

%% 获取新的活动信息(加入玩家真实最大参与次数和最大活跃)
get_new_act_info(PS, {Mod, ModSub, AcSub, Val, Live, CanGetLive, ActStatus}) ->
    % #get_live_config{max = DefMax, live = LiveOnce} = data_activitycalen:get_live_config(Mod, ModSub),
    {MaxNum, MaxLive} = get_act_max_num_live(PS, Mod, ModSub),
    {Mod, ModSub, AcSub, Val, MaxNum, Live, MaxLive, CanGetLive, ActStatus}.

%% 获取玩家特定活动的最大参与次数和最大活跃(仅支持日常类型活动)
%% @todo 此函数很多日常计数器的call调用,可以适当加缓存,在玩家vip等级/类型改变或者购买额外次数时再更新缓存数据
%% @return {最大参与次数, 最大活动活跃值}
get_act_max_num_live(PS, Mod, ModSub) ->
    #player_status{id = RoleId} = PS,
    #ac_liveness{max = DefMaxNum, live = LiveOnce} = data_activitycalen:get_live_config(Mod, ModSub),
    MaxNum =
    case {Mod, ModSub} of % 默认次数+vip免费次数+可购买次数+道具物品次数+至尊vip次数(副本)
    {?MOD_JJC, 0} ->
        [Num] = data_jjc:get_jjc_value(?JJC_FREE_NUM_MAX),
        MaxBuyNum = lib_vip_api:get_vip_privilege(PS, ?MOD_JJC, 1),
        Num + MaxBuyNum;
    {?MOD_BOSS, _} when
        ModSub == ?BOSS_TYPE_FORBIDDEN;
        ModSub == ?BOSS_TYPE_DOMAIN;
        ModSub == ?BOSS_TYPE_KF_GREAT_DEMON
        ->
        VipCount = lib_vip_api:get_vip_privilege(PS, ?MOD_BOSS, ?VIP_BOSS_ENTER(ModSub)),
        VipCount;
    {?MOD_DECORATION_BOSS, 0} ->
        VipCount = lib_vip_api:get_vip_privilege(PS, ?MOD_DECORATION_BOSS, ?DAILY_DECORATION_BOSS_COUNT),
        MaxBuyNum = lib_vip_api:get_vip_privilege(PS, ?MOD_DECORATION_BOSS, ?DAILY_DECORATION_BOSS_BUY_COUNT),
        GoodsAddNum = mod_daily:get_count(RoleId, ?MOD_DECORATION_BOSS, ?DAILY_DECORATION_BOSS_ADD_COUNT),
        VipCount + MaxBuyNum + GoodsAddNum;
    {?MOD_DUNGEON, DunType} ->
        [DunId|_] = data_dungeon:get_ids_by_type(ModSub), % 取该类型代表副本
        CountType = lib_dungeon_api:get_daily_count_type(DunType, DunId),
        #dungeon{count_cond = CountCond} = data_dungeon:get(DunId),
        {_, Max} = ulists:keyfind(?DUN_COUNT_COND_DAILY, 1, CountCond, {0, 0}),
        VipCount = lib_vip_api:get_vip_privilege(PS, ?MOD_DUNGEON, ?VIP_DUNGEON_ENTER_RIGHT_ID(CountType)),
        SupvipAddCount = lib_supreme_vip_api:get_dungeon_num_add(PS, DunType),
        MaxBuyNum = lib_vip_api:get_vip_privilege(PS, ?MOD_DUNGEON, ?VIP_DUNGEON_BUY_RIGHT_ID(CountType)),
        Max + VipCount + SupvipAddCount + MaxBuyNum;
    _ ->
        DefMaxNum
    end,
    % 原需求:真实可参与最大次数
    % case {Mod, ModSub} of
    % {?MOD_JJC, 0} ->
    %     [Num] = data_jjc:get_jjc_value(?JJC_FREE_NUM_MAX),
    %     BuyNum = mod_daily:get_count(RoleId, ?MOD_JJC, ?JJC_BUY_NUM),
    %     Num + BuyNum;
    % {?MOD_BOSS, _} when ModSub == ?BOSS_TYPE_FORBIDDEN; ModSub == ?BOSS_TYPE_DOMAIN ->
    %     #boss_type{count = Count} = data_boss:get_boss_type(ModSub),
    %     VipAddCount = lib_vip_api:get_vip_privilege(?MOD_BOSS, ?VIP_BOSS_ENTER(ModSub), VipType, VipLv),
    %     Count + VipAddCount;
    % {?MOD_DECORATION_BOSS, 0} ->
    %     MaxCount = lib_decoration_boss:get_max_enter_count(PS),
    %     MaxCount;
    % {?MOD_DUNGEON, _} ->
    %     [DunId|_] = data_dungeon:get_ids_by_type(ModSub), % 取该类型代表副本
    %     Dun = data_dungeon:get(DunId),
    %     {TMaxNum, _} = lib_dungeon:get_daily_count(PS, Dun),
    %     TMaxNum;
    % _ ->
    %     DefMaxNum
    % end,
    MaxLive = MaxNum * LiveOnce,
    {MaxNum, MaxLive}.

% 查询活动首次开启状态
get_ac_first_start(Player) ->
    #player_status{id = RoleId} = Player,
    mod_activitycalen:get_ac_first_start(RoleId).


%% 判断当天是否会开启
check_ac_live_day(Module, ModuleSub) ->
    CheckList = [time, week, month, open_day, merge_day],
    CheckRes = case {Module, ModuleSub} of
        _ ->
            IdList = data_activitycalen:get_ac_sub(Module, ModuleSub),
            [1 ||AcSub <- IdList, lib_activitycalen_util:do_check_ac_sub(data_activitycalen:get_ac(Module, ModuleSub, AcSub), CheckList)]
    end,
    lists:member(1, CheckRes).

%% ----------------------------------------------
%% 查询活动的当日的活动时间
%%-----------------------------------------------
% return [{start_hour,start_min}|...] || []
get_time(Module, ModuleSub) ->
    IdList = data_activitycalen:get_ac_sub(Module, ModuleSub),
    CheckList = [time, week, month, open_day, merge_day],
    TimeList=[begin
        #base_ac{time_region=TimeRegion}=data_activitycalen:get_ac(Module, ModuleSub, AcSub),
        [{StartH,StartM} || {{StartH,StartM}, _} <- TimeRegion]
    end || AcSub <- IdList, lib_activitycalen_util:do_check_ac_sub(data_activitycalen:get_ac(Module, ModuleSub, AcSub), CheckList)],
    case TimeList of
        [H | _T] ->
            H;
        _ ->
            []
    end.

%% ----------------------------------------------
%% 查询活动的当日的下一次活动时间戳
%%-----------------------------------------------
get_timestamp(ModId, SubId, _SubAc) ->
    case get_time(ModId, SubId) of
        [] -> 0;
        TimeList ->
            get_timestamp(TimeList, utime:unixtime())
    end.

get_timestamp([], _) -> 0;
get_timestamp([{H, M} | T], NowTime) ->
    TS = utime:unixdate() + H * 3600 + M * 60,
    case TS > NowTime of
        true -> TS;
        false -> get_timestamp(T, NowTime)
    end.

%% ----------------------------------------------
%% 检查活动是否符合开启条件
%%----------------------------------------------
% return true|false
check_ac_start(Module, ModuleSub) ->
    IdList = data_activitycalen:get_ac_sub(Module, ModuleSub),
    CheckList = [time, region, week, month, open_day, merge_day],
    AcList = [true || AcSub <- IdList, lib_activitycalen_util:do_check_ac_sub(data_activitycalen:get_ac(Module, ModuleSub, AcSub), CheckList)],
    lists:member(true, AcList).
%% ----------------------------------------check-------------------------------------------------
check_get_reward(Player, Id) ->
    CheckList = [
        'bag_enough'
        , 'live_enough'
        , 'already_get'
    ],
    do_check_get_reward(CheckList, Player, Id).

do_check_get_reward([], Player, _Id) -> {true, Player};
do_check_get_reward([H|T], Player, Id) ->
    case do_check_get_reward_help(H, Player, Id) of
        {true, NewPlayer} ->
            do_check_get_reward(T, NewPlayer, Id);
        {false, ErrCode, NewPlayer} ->
            {false, ErrCode, NewPlayer}
    end.

do_check_get_reward_help('already_get', Player, Id) ->
    #player_status{id = RoleId} = Player,
    Value = mod_daily:get_count(RoleId, ?MOD_ACTIVITY, ?MOD_ACTIVITY_LIVE_REWARD, Id),
    case Value < ?FINISH_REWARD of
        true ->
            {true, Player};
        false ->
            {false, ?ERRCODE(err157_2_live_aready_get), Player}
    end;

do_check_get_reward_help('live_enough', Player, Id) ->
    #player_status{id = RoleId} = Player,
    #ac_reward{live = NeedLive} = data_activitycalen:get_reward_config(Id),
    Value = mod_daily:get_count(RoleId, ?MOD_ACTIVITY, ?ACTIVITY_LIVE_DAILY),
    RewardState = mod_daily:get_count(RoleId, ?MOD_ACTIVITY, ?MOD_ACTIVITY_LIVE_REWARD, Id),
    if
        Value < NeedLive orelse RewardState =:= ?NOT_REWARD ->
            {false, ?ERRCODE(err157_1_live_not_enough), Player};
        true ->
            {true, Player}
    end;

do_check_get_reward_help('bag_enough', Player, Id) ->
    #player_status{figure = #figure{lv = RoleLv}} = Player,
    #ac_reward{reward = RewardList} = data_activitycalen:get_reward_config(Id),
    Reward = get_reward_by_lv(RoleLv, RewardList),
    % GoodsTypeList = [{TypeId, Num}||{Type, TypeId, Num}<-Reward, Type == ?TYPE_GOODS],
    case lib_goods_api:can_give_goods(Player, Reward) of
        true ->
            {true, Player};
        {false, ErrCode} ->
            {false, ErrCode, Player};
        _ ->
            {false, ?ERRCODE(err150_no_cell), Player}
    end;

do_check_get_reward_help(_Msg, Player, _Id) -> {true, Player}.


%%　获取活动子类(包含结束时间)
get_ac_sub_with_end(Module, ModuleSub) ->
    IdList = data_activitycalen:get_ac_sub(Module, ModuleSub),
    CheckList = [time, time_region_loose, week, month, open_day, merge_day],
    get_ac_sub_with_end(Module, ModuleSub, IdList, CheckList).

get_ac_sub_with_end(Module, ModuleSub, [Id|T], CheckList) ->
    case lib_activitycalen_util:do_check_ac_sub(data_activitycalen:get_ac(Module, ModuleSub, Id), CheckList) of
        true -> Id;
        _ ->
            get_ac_sub_with_end(Module, ModuleSub, T, CheckList)
    end;
get_ac_sub_with_end(_, _, [], _) -> 1.

get_reward_by_lv(RoleLv, RewardList) ->
    F = fun
            ({Lv, Reward}, Acc) ->
                case RoleLv >= Lv of
                    true ->
                        Reward ++ Acc;
                    _ ->
                        Acc
                end
        end,
    lists:foldl(F, [], RewardList).

get_exp_by_lv(RoleLv, BaseExp) ->
    List = [{Lv, Exp} || {Lv, Exp} <- BaseExp, RoleLv >= Lv],
    LastList = lists:sort(fun({Lv1, _}, {Lv2, _}) -> Lv1 >= Lv2 end, List),
    case LastList of
        [] ->
            0;
        [{_LastLv, LastExp} | _T] ->
            LastExp * 12 * (RoleLv div 10 + 1);
        _ ->
            0
    end.

% %% 获得展示的列表##等级不足的以及开服天数不满足的
% get_show_act_list(Lv, Type) ->
%     LvList = data_activitycalen:get_start_lv_list(Type),
%     do_get_show_act_list(Lv, Type, LvList, []).
% do_get_show_act_list(_Lv, _Type, [], ActList) -> ActList;
% do_get_show_act_list(Lv, Type, [H|T], ActList) ->
%     case Lv < H of
%         true ->
%             OneActList = data_activitycalen:get_ac_by_lv(H, Type),
%             NewOneActList = [{Module, ModuleSub, AcSub}||{Module, ModuleSub, AcSub}<-OneActList,
%                 lib_activitycalen_mod:is_open_day_limit(Module, ModuleSub, AcSub)==false],
%             do_get_show_act_list(Lv, Type, T, NewOneActList++ActList);
%         _ ->
%             do_get_show_act_list(Lv, Type, T, ActList)
%     end.

get_next_act_lv(Lv, Type) ->
    LvList = data_activitycalen:get_start_lv_list(Type),
    do_get_next_act_lv(Lv, LvList).
do_get_next_act_lv(_Lv, []) -> 0;
do_get_next_act_lv(Lv, [H|T]) ->
    case Lv < H of
        true -> H;
        _ -> do_get_next_act_lv(Lv, T)
    end.

%% 通过配置获取活动当前的开启时间段
%% 活动已开启 return {ok, [开启时间戳, 结束时间戳]}
%% 活动未开启 return false
get_act_open_time_region(Module, SubModule, ActId) ->
    Act = data_activitycalen:get_ac(Module, SubModule, ActId),
    #base_ac{time_region = TimeRegion} = Act,
    {_NowDay, {NowH,NowM,_}} = calendar:local_time(),
    Now = NowH * 60 + NowM,
    ZeroAclock = utime:unixdate(),
    case ulists:find(fun
        ({{SH, SM}, {EH, EM}}) ->
            SH * 60 + SM =< Now andalso Now =< EH * 60 + EM
    end, TimeRegion) of
        {ok, {{SH, SM}, {EH, EM}}} ->
            Stime = ZeroAclock + SH * 3600 + SM * 60,
            Etime = ZeroAclock + EH * 3600 + EM * 60,
            {ok, [Stime, Etime]};
        _ -> false
    end.
%%是否材料副本
is_materials_dungeon(?MOD_DUNGEON, SubId) ->
    lists:member(SubId, ?dungeon_materials_list) orelse lists:member(SubId, ?DUNGEON_NEW_VERSION_MATERIEL_LIST);
is_materials_dungeon(_, _SubId) ->
    false.

add_liveness(Module, ModuleSub, Count, RoleId, Live, AcName, OldFinishCount, RoleLv) ->
    mod_daily:plus_count_offline(RoleId, ?MOD_ACTIVITY, ?MOD_ACTIVITY_NUM, Module * ?AC_LIVE_ADD + ModuleSub, Count),  %%完成次数
    _AddLive = Count * Live,  %%增加的活跃度
    if
        %%根据vip等级显示个人boss挑战次数
        %%现在完成1次+10点活跃，最多可加20点
        %%比如你v5可以打5次 界面上显示应该为次数0/5 活跃度 0/20
        Module == ?MOD_BOSS andalso ModuleSub == ?BOSS_TYPE_VIP_PERSONAL ->  %%vip个人boss特殊处理,
            VipBossLimit   = data_activitycalen:get_value(3),
            NewVipBossLive = min((Count + OldFinishCount) * Live, VipBossLimit), %%vip个人boss 新的活跃度
            AddLive        = max(NewVipBossLive - OldFinishCount * Live, 0);
        true ->
            AddLive = _AddLive
    end,
    OldLive   = mod_daily:get_count_offline(RoleId, ?MOD_ACTIVITY, ?ACTIVITY_LIVE_DAILY), %%旧活跃度
    LiveLimit = mod_daily:get_limit_by_type(?MOD_ACTIVITY, ?ACTIVITY_LIVE_DAILY), %%活跃度上限
    Add = min(AddLive, LiveLimit - OldLive),  %%修正活跃度
    NewLive = OldLive + Add,
    %%支持每日补给
    case  lib_custom_act_api:is_open_act(?CUSTOM_ACT_TYPE_SUPPLY, 1) andalso RoleLv >= lib_custom_act:get_open_lv(?CUSTOM_ACT_TYPE_SUPPLY) of
        true ->
            mod_daily:plus_count_offline(RoleId, ?MOD_AC_CUSTOM, ?CUSTOM_ACT_TYPE_SUPPLY, Add);
        _ ->
            skip
    end,
    mod_daily:plus_count_offline(RoleId, ?MOD_ACTIVITY, ?ACTIVITY_LIVE_DAILY, Add),
    mod_daily:plus_count_offline(RoleId, ?MOD_ACTIVITY, ?MOD_ACTIVITY_LIVE_YET_GET_NUM, Module * ?AC_LIVE_ADD + ModuleSub, Add),  %%直接发活跃度
    lib_log_api:log_activity_live(RoleId, Module, ModuleSub, util:make_sure_binary(AcName), Live, OldLive, NewLive, utime:unixtime()),
    lib_task_api:activity_acc(RoleId, NewLive),
    lib_baby_api:add_liveness(RoleId, Add),
    lib_red_envelopes_rain:add_liveness(RoleId, Add),
    lib_surprise_gift:add_liveness(RoleId, OldLive, NewLive),
    mod_activity_onhook:add_activity_value(RoleId, OldLive, AddLive),
    lib_demons_api:add_liveness(RoleId, OldLive, NewLive),
    lib_beings_gate_api:add_activity_value(Add),
    %% 更新ps的活跃度
    lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, ?HAND_OFFLINE, lib_liveness, add_liveness, [Add]).

task_week_do(RoleId, Module, ModuleSub, Count) ->
    %% 资源找回 的处理
%%    Data1 = #act_data{act_id = Module, act_sub = ModuleSub, num = Count},
%%    lib_player_event:async_dispatch(RoleId, ?EVENT_PARTICIPATE_ACT, Data1),
    case lib_role:get_role_show(RoleId) of
        #ets_role_show{figure = #figure{lv = Lv}} ->
            IdList = data_activitycalen:get_ac_sub(Module, ModuleSub),
            CheckList = [time, week, month, open_day, merge_day],
            #ac_liveness{name = _AcName, max = Max, act_type = _ActType, live = _Live, start_lv = StartLv, end_lv = EndLv} = data_activitycalen:get_live_config(Module, ModuleSub),
            CheckRes = [1 || AcSub <- IdList, lib_activitycalen_util:do_check_ac_sub(data_activitycalen:get_ac(Module, ModuleSub, AcSub), CheckList)],
            case lists:member(1, CheckRes) of
                true ->
                    Value = mod_week:get_count(RoleId, ?MOD_ACTIVITY, ?MOD_ACTIVITY_WEEK_NUM),
                    case Value < Max andalso StartLv =< Lv andalso EndLv >= Lv andalso lib_module:is_open(?MOD_ACTIVITY, 0, Lv) of
                        true ->
                            mod_week:plus_count_offline(RoleId, ?MOD_ACTIVITY, 0, ?MOD_ACTIVITY_WEEK_NUM, Count);  %%完成次数
                        false ->
                            skip
                    end;
                _ ->
                    skip
            end;
        _ ->
            skip
    end.

%%Vip个人boss特殊处理

get_right_liveness_max_time(?MOD_BOSS, ?BOSS_TYPE_VIP_PERSONAL, _Max, RoleVip) ->
    %%vip个人boss vip类型
    VipType = data_activitycalen:get_value(2),
    Times = lib_vip_api:get_vip_privilege(?MOD_DUNGEON, VipType, RoleVip#role_vip.vip_type, RoleVip#role_vip.vip_lv),
    Times;
get_right_liveness_max_time(_Module, _NewModuleSub, Max, _RoleVip) ->
    Max.