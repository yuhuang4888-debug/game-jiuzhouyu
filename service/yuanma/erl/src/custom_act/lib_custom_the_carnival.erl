%% ---------------------------------------------------------------------------
%% @doc lib_custom_the_carnival

%% @author  lzh
%% @email   lu13824949032@gmail.com
%% @since   2022/3/15
%% @desc    全民狂欢
%% ---------------------------------------------------------------------------
-module(lib_custom_the_carnival).

%% API
-export([
    act_start/2,
    act_end/2,
    act_start_init_data/3,
    init_data_lv_up/1,
    send_task_process/3,
    count_reward_status/3,
    receive_reward/4
]).

-export([
    kill_boss/2,
    dungeon_success/2,
    upgrade_medal/2,
    trigger_seal_rating/2,
    equip_wash/2
]).

-include("common.hrl").
-include("server.hrl").
-include("def_event.hrl").
-include("rec_event.hrl").
-include("dungeon.hrl").
-include("custom_act.hrl").
-include("figure.hrl").
-include("def_fun.hrl").
-include("boss.hrl").
-include("seal.hrl").
-include("goods.hrl").
-include("errcode.hrl").
-include("predefine.hrl").
-include("medal.hrl").
-include("def_module.hrl").

%% 活动开始时，初始化在线玩家数据
act_start(Type, SubType) ->
    PidL = [Pid||#ets_online{pid = Pid}<-ets:tab2list(?ETS_ONLINE)],
    F = fun(Pid) ->
        timer:sleep(500),
        lib_player:apply_cast(Pid, ?APPLY_CAST_SAVE, ?MODULE, act_start_init_data, [Type, SubType])
    end,
    spawn( fun() -> lists:foreach(F, PidL) end ).

%% 活动结束，直接清空数据就可|一般来说活动结束之后不再修改玩家进程内数据，暂时不修改玩家数据后续有问题再处理（一般没问题，除非活动排期比较奇怪）
%% 同时发奖励
act_end(Type, SubType) ->
    spawn(
        fun() ->
            DelayMS = urand:rand(1, 10) * 1000,
            timer:sleep(DelayMS),
            List = db:get_all(io_lib:format(<<"select `player_id`, `data_list` from `custom_act_data` where `type` = ~p and `subtype` = ~p ">>
                ,[Type, SubType])),
            act_end_send_mail(List, Type, SubType),
            db:execute(io_lib:format(?SQL_DELETE_CUSTOM_ACT_DATA_1, [Type, SubType]))
        end
    ).

act_end_send_mail(List, Type, SubType) ->
    GradeIdL = lib_custom_act_util:get_act_reward_grade_list(Type, SubType),
    RewardCfgL = [lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GradeId)||GradeId <- GradeIdL],
    do_act_end_send_mail(List, RewardCfgL, Type, SubType),
    ok.

do_act_end_send_mail([], _RewardCfgL, _Type, _SubType) -> ok;
do_act_end_send_mail([[RoleId, ActDataStr]|T], RewardCfgL, Type, SubType) ->
    DataInfo = util:bitstring_to_term(ActDataStr),
    F = fun(RewardCfg, AccReward) ->
        case DataInfo of
            #custom_the_carnival{receive_ids = ReceiveIds} ->
                #custom_act_reward_cfg{reward = Reward, grade = GradeId} = RewardCfg,
                case lists:member(GradeId, ReceiveIds) of
                    true -> AccReward;
                    _ ->
                        case count_reward_status(DataInfo, #act_info{key = {Type, SubType}}, RewardCfg) of
                            ?ACT_REWARD_CAN_GET -> Reward ++ AccReward;
                            _ -> AccReward
                        end
                end;
            _ -> ok
        end
    end,
    Reward = lists:foldl(F, [], RewardCfgL),
    case Reward of
        [] -> skip;
        _ -> mod_mail_queue:add_no_delay({?MOD_AC_CUSTOM, Type}, [RoleId], utext:get(3310016), utext:get(3310017), Reward)
    end,
    do_act_end_send_mail(T, RewardCfgL, Type, SubType).

act_start_init_data(PS, Type, SubType) ->
    do_init_data_lv_up(PS, Type, SubType).

init_data_lv_up(PS) ->
    Type = ?CUSTOM_ACT_TYPE_THE_CARNIVAL,
    SubList = lib_custom_act_api:get_open_subtype_ids(Type),
    F = fun(SubType, AccPS) -> do_init_data_lv_up(AccPS, Type, SubType) end,
    lists:foldl(F, PS, SubList).

do_init_data_lv_up(PS, Type, SubType) ->
    #player_status{figure = #figure{lv = RoleLv}} = PS,
    case get_data_info(PS, Type, SubType) of
        #custom_the_carnival{is_init = 1} -> PS;
        _ ->
            #custom_act_cfg{condition = Condition} = lib_custom_act_util:get_act_cfg_info(Type, SubType),
            case lib_custom_act_check:check_act_condtion([role_lv], Condition) of
                [NeedLv] when RoleLv >= NeedLv ->
                    init_data_info(PS, Type, SubType);
                _ ->
                    PS
            end
    end.

% 大妖击杀
kill_boss(PS, #callback_boss_kill{boss_type = BossType}) ->
    TriggerTypeL = [
        ?BOSS_TYPE_NEW_OUTSIDE, ?BOSS_TYPE_VIP_PERSONAL, ?BOSS_TYPE_ABYSS,
        ?BOSS_TYPE_FORBIDDEN, ?BOSS_TYPE_SANCTUARY, ?BOSS_TYPE_KF_SANCTUARY,
        ?BOSS_TYPE_SPECIAL, ?BOSS_TYPE_WORLD_PER
    ],
    case lists:member(BossType, TriggerTypeL) of
        true -> trigger(PS, {kill_boss, 1});
        _ -> {ok, PS}
    end.

dungeon_success(PS, #callback_dungeon_succ{dun_type = DunType, dun_id = DunId}) ->
    if
        %% 符文塔通关
        DunType == ?DUNGEON_TYPE_RUNE2 ->
            trigger(PS, {dun_id, DunId});
        %% 契灵副本总星数
        DunType == ?DUNGEON_TYPE_PARTNER_NEW ->
            Star = lib_dungeon_partner:get_all_dun_score(PS),
            trigger(PS, {partner_dun_star, Star});
        %% 专属BOSss
        DunType == ?DUNGEON_TYPE_VIP_PER_BOSS ->
            trigger(PS, {kill_boss, 1});
        true ->
            {ok, PS}
    end.

%% 境界（勋章）升级
upgrade_medal(PS, MedalId) ->
    trigger(PS, {medal, MedalId}).

% 影装(圣印)总战力
trigger_seal_rating(PS, Rating) ->
    trigger(PS, {seal_power, Rating}).

%% 洗练次数
equip_wash(PS, Num) ->
    trigger(PS, {wash_num, Num}).

trigger(PS, Arg) ->
    Type = ?CUSTOM_ACT_TYPE_THE_CARNIVAL,
    SubList = lib_custom_act_api:get_open_subtype_ids(Type),
    F = fun(SubType, AccPS) -> do_trigger(AccPS, Type, SubType, Arg) end,
    LastPS = lists:foldl(F, PS, SubList),
    {ok, LastPS}.

do_trigger(PS, Type, SubType, Arg) ->
    #player_status{figure = #figure{lv = RoleLv}} = PS,
    ActInfo = lib_custom_act_util:get_custom_act_open_info(Type, SubType),
    #act_info{wlv = WorldLv} = ActInfo,
    DataInfo = get_data_info(PS, Type, SubType),
    GradeIds = lib_custom_act_util:get_act_reward_grade_list(Type, SubType),
    F = fun(GradeId, AccL) ->
        RewardCfg = lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GradeId),
        case lib_custom_act_check:check_reward_in_wlv(Type, SubType, [{wlv, WorldLv}, {role_lv, RoleLv}, {open_day}], RewardCfg) of
            true ->
                HadGet = lib_custom_act_check:check_reward_receive_times(PS, ActInfo, RewardCfg) == false,
                CanTrigger = count_reward_status(DataInfo, ActInfo, RewardCfg) == ?ACT_REWARD_CAN_NOT_GET,
                if
                    HadGet -> AccL;
                    not CanTrigger -> AccL;
                    true -> [RewardCfg|AccL]
                end;
            _ -> AccL
        end
    end,
    case lists:foldl(F, [], GradeIds) of
        [] -> PS;
        TriggerRewardCfgL ->
            {NewDataInfo, IsChange} = do_trigger_core(DataInfo, TriggerRewardCfgL, false, Arg),
            %?PRINT("NewDataInfo, IsChange, Arg ~p ~n", [{NewDataInfo, IsChange, Arg}]),
            case IsChange of
                true ->
                    NewPS = save_data_info(PS, Type, SubType, NewDataInfo),
                    pp_custom_act:handle(33104, NewPS, [Type, SubType]),
                    pp_custom_act_list:handle(33258, NewPS, [Type, SubType]),
                    NewPS;
                _ ->
                    PS
            end
    end.

do_trigger_core(DataInfo, [], IsChange, _) -> {DataInfo, IsChange};
do_trigger_core(DataInfo, [RewardCfg|T], IsChange, Arg) ->
    #custom_act_reward_cfg{condition = Condition, grade = GradeId} = RewardCfg,
    case lib_custom_act_check:check_act_condtion([task], Condition) of
        [TaskItem] ->
            {NewDataInfo, NewIsChange} = do_trigger_core1(DataInfo, GradeId, TaskItem, Arg, IsChange),
            %?PRINT("DataInfo, GradeId, TaskItem, Arg ~p ~n", [{DataInfo, GradeId, TaskItem, Arg}]),
            %?PRINT("{NewDataInfo, NewIsChange} ~p ~n", [{NewDataInfo, NewIsChange}]),
            do_trigger_core(NewDataInfo, T, NewIsChange, Arg);
        _ -> do_trigger_core(DataInfo, T, IsChange, Arg)
    end.

do_trigger_core1(DataInfo, GradeId, {kill_boss, NeedNum}, {kill_boss, Num}, _IsChange) ->
    #custom_the_carnival{task_process = TaskProcessL} = DataInfo,
    {_, CurrentNum} = ulists:keyfind(GradeId, 1, TaskProcessL, {GradeId, 0}),
    NewNum = min(NeedNum, Num + CurrentNum),
    NewTaskProcessL = lists:keystore(GradeId, 1, TaskProcessL, {GradeId, NewNum}),
    {DataInfo#custom_the_carnival{task_process = NewTaskProcessL}, true};
do_trigger_core1(DataInfo, GradeId, {dun_id, DunId}, {dun_id, DunId}, _IsChange) ->
    #custom_the_carnival{task_process = TaskProcessL} = DataInfo,
    NewTaskProcessL = lists:keystore(GradeId, 1, TaskProcessL, {GradeId, 1}),
    {DataInfo#custom_the_carnival{task_process = NewTaskProcessL}, true};
do_trigger_core1(DataInfo, GradeId, {partner_dun_star, NeedNum}, {partner_dun_star, Num}, _IsChange) ->
    #custom_the_carnival{task_process = TaskProcessL} = DataInfo,
    NewTaskProcessL = lists:keystore(GradeId, 1, TaskProcessL, {GradeId, min(Num, NeedNum)}),
    {DataInfo#custom_the_carnival{task_process = NewTaskProcessL}, true};
do_trigger_core1(DataInfo, GradeId, {medal, NeedLv}, {medal, Lv}, _IsChange) ->
    #custom_the_carnival{task_process = TaskProcessL} = DataInfo,
    NewTaskProcessL = lists:keystore(GradeId, 1, TaskProcessL, {GradeId, min(Lv, NeedLv)}),
    {DataInfo#custom_the_carnival{task_process = NewTaskProcessL}, true};
do_trigger_core1(DataInfo, GradeId, {seal_power, NeedPower}, {seal_power, Power}, _IsChange) ->
    #custom_the_carnival{task_process = TaskProcessL} = DataInfo,
    NewTaskProcessL = lists:keystore(GradeId, 1, TaskProcessL, {GradeId, min(NeedPower, Power)}),
    {DataInfo#custom_the_carnival{task_process = NewTaskProcessL}, true};
do_trigger_core1(DataInfo, GradeId, {wash_num, NeedNum}, {wash_num, Num}, _IsChange) ->
    #custom_the_carnival{task_process = TaskProcessL} = DataInfo,
    {_, CurrentNum} = ulists:keyfind(GradeId, 1, TaskProcessL, {GradeId, 0}),
    NewNum = min(NeedNum, Num + CurrentNum),
    NewTaskProcessL = lists:keystore(GradeId, 1, TaskProcessL, {GradeId, NewNum}),
    {DataInfo#custom_the_carnival{task_process = NewTaskProcessL}, true};
do_trigger_core1(DataInfo, _GradeId, _,_, IsChange) -> {DataInfo, IsChange}.

%% 获取任务进度
send_task_process(PS, Type, SubType) ->
    #custom_the_carnival{task_process = TaskProcessL} = get_data_info(PS, Type, SubType),
    {ok, BinData} = pt_332:write(33258, [Type, SubType, TaskProcessL]),
    lib_server_send:send_to_sid(PS#player_status.sid, BinData).

%% 获取任务领取情况
count_reward_status(PS, #act_info{key = {Type, SubType}} = ActInfo, RewardCfg) when is_record(PS, player_status) ->
    case lib_custom_act_check:check_reward_receive_times(PS, ActInfo, RewardCfg) of
        false -> ?ACT_REWARD_HAS_GET;
        _ ->
            DataInfo = get_data_info(PS, Type, SubType),
            Res = count_reward_status(DataInfo, ActInfo, RewardCfg),
            Res
    end;
count_reward_status(DataInfo, _ActInfo, RewardCfg) when is_record(DataInfo, custom_the_carnival) ->
    #custom_the_carnival{task_process = TaskProcessL} = DataInfo,
    #custom_act_reward_cfg{grade = GradeId, condition = Condition} = RewardCfg,
    {_, Value} = ulists:keyfind(GradeId, 1, TaskProcessL, {GradeId, 0}),
    case lib_custom_act_check:check_act_condtion([task], Condition) of
        [{dun_id, _}] when Value >= 1 -> ?ACT_REWARD_CAN_GET;
        [{_, NeedNum}] when Value >= NeedNum -> ?ACT_REWARD_CAN_GET;
        _ -> ?ACT_REWARD_CAN_NOT_GET
    end.

% 领取奖励
receive_reward(PS, Type, SubType, GradeId) ->
    #player_status{id = RoleId} = PS,
    NowTime = utime:unixtime(),
    case lib_custom_act_util:get_custom_act_open_info(Type, SubType) of
        #act_info{
            etime = Etime
        } = ActInfo when NowTime < Etime ->
            RewardCfg = lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GradeId),
            case count_reward_status(PS, ActInfo, RewardCfg) of
                ?ACT_REWARD_CAN_GET ->
                    #custom_act_reward_cfg{reward = Reward} = RewardCfg,
                    PS1 = lib_custom_act:update_receive_times(PS, Type, SubType, GradeId, 1),
                    {ok, BinData} = pt_331:write(33105, [?SUCCESS, Type, SubType, GradeId]),
                    lib_server_send:send_to_uid(PS1#player_status.id, BinData),
                    #custom_the_carnival{receive_ids = ReceiveIds} = DataInfo = get_data_info(PS1, Type, SubType),
                    NewReceiveIds = [GradeId|lists:delete(GradeId, ReceiveIds)],
                    NewDataInfo = DataInfo#custom_the_carnival{receive_ids = NewReceiveIds},
                    NewPS = save_data_info(PS1, Type, SubType, NewDataInfo),
                    Remark = lists:concat(["SubType:", SubType, "GradeId:", GradeId]),
                    Produce = #produce{type = custom_the_carnival, subtype = Type, remark = Remark, reward = Reward, show_tips = ?SHOW_TIPS_1},
                    LastPS = lib_goods_api:send_reward(NewPS, Produce),
                    lib_log_api:log_custom_act_reward(RoleId, Type, SubType, GradeId, Reward),
                    {ok, LastPS};
                _ErrCode ->
                    lib_custom_act:send_error_code(RoleId, _ErrCode)
            end;
        _ ->
            skip
    end.

%% 获取数据
get_data_info(PS, Type, SubType) ->
    case lib_custom_act:act_data(PS, Type, SubType) of
        #custom_act_data{data = #custom_the_carnival{} = DataInfo} ->
             DataInfo;
        _ -> #custom_the_carnival{}
    end.

%% 保存数据
save_data_info(PS, Type, SubType, DataInfo) ->
    DbData = #custom_act_data{id = {Type, SubType}, type = Type, subtype = SubType, data = DataInfo},
    lib_custom_act:save_act_data_to_player(PS, DbData).

%% 初始化时需要处理 符文塔层数， 影装（圣印）评分，契灵（伙伴）副本， 境界（勋章） 的任务进度
init_data_info(PS, Type, SubType) ->
    #player_status{seal_status = #seal_status{rating = Rating}, medal = #medal{id = MedalLv}} = PS,
    GradeIds = lib_custom_act_util:get_act_reward_grade_list(Type, SubType),
    F = fun(GradeId, {AccL, AccCfgL}) ->
        RewardCfg = #custom_act_reward_cfg{condition = Condition} = lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GradeId),
        case lib_custom_act_check:check_act_condtion([task], Condition) of
            [{dun_id, DunId}] ->
                case lib_dungeon_api:check_ever_finish(PS, DunId) of
                    true -> NewAccL = [{dun_id, DunId}|AccL];
                    _ -> NewAccL = AccL
                end;
            _ -> NewAccL = AccL
        end,
        {NewAccL, [RewardCfg|AccCfgL]}
    end,
    {NeedTriggerDunIdL, TriggerRewardCfgL} = lists:foldl(F, {[], []}, GradeIds),
    Star = lib_dungeon_partner:get_all_dun_score(PS),
    TriggerL = [{seal_power, Rating}, {medal, MedalLv}, {partner_dun_star, Star}] ++ NeedTriggerDunIdL,
    DataInfo = lists:foldl(
        fun(Arg, AccDataInfo) ->
            {NewAccDataInfo, _} = do_trigger_core(AccDataInfo, TriggerRewardCfgL, false, Arg),
            NewAccDataInfo
        end,
        #custom_the_carnival{is_init = 1, task_process = [{GradeId, 0}||GradeId<-GradeIds]}, TriggerL),
    save_data_info(PS, Type, SubType, DataInfo).



