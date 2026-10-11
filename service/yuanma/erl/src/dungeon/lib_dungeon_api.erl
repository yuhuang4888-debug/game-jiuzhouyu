%% ---------------------------------------------------------------------------
%% @doc lib_dungeon_api.erl

%% @author  hjh
%% @email  hejiahua@163.com
%% @since  2017-02-23
%% @deprecated 副本接口
%% ---------------------------------------------------------------------------
-module(lib_dungeon_api).
-export([
        kill_mon/7
        , stop_mon/8
        , object_die/1
        , object_stop/1
        , handle_event/2
        , invoke/4
    ]).

-compile(export_all).

-include("server.hrl").
-include("dungeon.hrl").
-include("scene.hrl").
-include("goods.hrl").
-include("attr.hrl").
-include("battle.hrl").
-include("rec_event.hrl").
-include("def_event.hrl").
-include("common.hrl").
-include("def_module.hrl").
-include("team.hrl").
-include("figure.hrl").
-include("predefine.hrl").
-include("custom_act.hrl").
-include("def_fun.hrl").
-include("task.hrl").
-include("buff.hrl").
-include("drop.hrl").

%% 击杀怪物
kill_mon(SceneId, CopyId, AutoId, DieSign, Mon, SkillOwner, DieDatas) ->
    #scene_mon{mid = Mid, create_key = CreateKey} = Mon,
    case is_record(SkillOwner, skill_owner) of
        true -> OwnId = SkillOwner#skill_owner.id;
        false -> OwnId = 0
    end,
    case data_scene:get(SceneId) of
        #ets_scene{type = SceneType} when SceneType==?SCENE_TYPE_DUNGEON orelse SceneType==?SCENE_TYPE_MAIN_DUN ->
            case misc:is_process_alive(CopyId) of
                true -> mod_dungeon:kill_mon(CopyId, AutoId, Mid, DieSign, CreateKey, OwnId, DieDatas);
                false -> skip
            end;
        _ ->
            skip
    end.

%% 怪物被停止
stop_mon(SceneId, CopyId, AutoId, Sign, Mon, SkillOwner, Hp, HpLim) ->
    #scene_mon{mid = Mid, create_key = CreateKey} = Mon,
    case is_record(SkillOwner, skill_owner) of
        true -> OwnId = SkillOwner#skill_owner.id;
        false -> OwnId = 0
    end,
    case data_scene:get(SceneId) of
        #ets_scene{type = SceneType} when SceneType==?SCENE_TYPE_DUNGEON orelse SceneType==?SCENE_TYPE_MAIN_DUN ->
            case misc:is_process_alive(CopyId) of
                true -> mod_dungeon:stop_mon(CopyId, AutoId, Mid, Sign, CreateKey, OwnId, Hp, HpLim);
                false -> skip
            end;
        _ ->
            skip
    end.

%% 对象死亡
object_die(Object) ->
    #scene_object{sign=_Sign, id = AutoId, scene = SceneId, copy_id = CopyId, skill_owner = SkillOwner} = Object,
    case is_record(SkillOwner, skill_owner) of
        true -> OwnId = SkillOwner#skill_owner.id;
        false -> OwnId = 0
    end,
    case data_scene:get(SceneId) of
        #ets_scene{type = SceneType} when SceneType==?SCENE_TYPE_DUNGEON orelse SceneType==?SCENE_TYPE_MAIN_DUN ->
            case misc:is_process_alive(CopyId) of
                true -> mod_dungeon:object_die(CopyId, AutoId, OwnId);
                false -> skip
            end;
        _ ->
            skip
    end.

%% 对象停止
object_stop(Object) ->
    #scene_object{sign=_Sign, id = AutoId, scene = SceneId, copy_id = CopyId, skill_owner = SkillOwner, battle_attr = BA} = Object,
    case is_record(SkillOwner, skill_owner) of
        true -> OwnId = SkillOwner#skill_owner.id;
        false -> OwnId = 0
    end,
    case data_scene:get(SceneId) of
        #ets_scene{type = SceneType} when SceneType==?SCENE_TYPE_DUNGEON orelse SceneType==?SCENE_TYPE_MAIN_DUN ->
            case misc:is_process_alive(CopyId) of
                true -> mod_dungeon:object_stop(CopyId, AutoId, OwnId, BA#battle_attr.hp, BA#battle_attr.hp_lim);
                false -> skip
            end;
        _ ->
            skip
    end.

%% 玩家死亡
handle_event(Player, #event_callback{type_id = ?EVENT_PLAYER_DIE}) when is_record(Player, player_status) ->
    case lib_dungeon:is_on_dungeon(Player) of
        true ->
            #player_status{id = RoleId, copy_id = CopyId, dungeon = StatusDun, battle_attr = #battle_attr{hp_lim = HpLim} } = Player,
            #status_dungeon{revive_count = ReviveCount} = StatusDun,
            NewDeadTime = utime:unixtime(),
            NewStatusDun = StatusDun#status_dungeon{dead_time = NewDeadTime},
            NewPlayer = Player#player_status{dungeon = NewStatusDun},
            mod_dungeon:player_die(CopyId, RoleId, HpLim, [{dead_time, NewDeadTime}, {revive_count, ReviveCount}]),
            lib_dungeon:send_reveive_info(NewPlayer),
            %% 注意顺序,把死亡信息发送出去再复活成幽灵
            %% {_, NewPlayer2} = lib_revive:revive(NewPlayer, ?REVIVE_GHOST),
            {ok, NewPlayer};
        false ->
            {ok, Player}
    end;

%% 玩家复活
handle_event(Player, #event_callback{type_id = ?EVENT_REVIVE, data = ReviveType}) when is_record(Player, player_status) ->
    case lib_dungeon:is_on_dungeon(Player) of
        true ->
            #player_status{id = RoleId, copy_id = CopyId} = Player,
            case ReviveType == ?REVIVE_DUNGEON of
                true -> mod_dungeon:player_revive(CopyId, RoleId);
                false -> skip
            end;

        false ->
            skip
    end,
    {ok, Player};

%% 完成场景的切换
handle_event(Player, #event_callback{type_id = ?EVENT_FIN_CHANGE_SCENE}) when is_record(Player, player_status) ->
    #player_status{id = RoleId, scene = Scene, copy_id = CopyId, x = X, y = Y} = Player,
    IsDungeonScene = lib_scene:is_dungeon_scene(Scene),
    if
        IsDungeonScene ->
            case lib_dungeon:is_on_dungeon(Player) of
                true -> mod_dungeon:fin_change_scene(CopyId, RoleId, X, Y);
                false -> skip
            end;
        true ->
            skip
    end,
    {ok, Player};

%% 请求加好友
% handle_event(Player, #event_callback{type_id = ?EVENT_ASK_ADD_FRIEND, data = IdList}) when is_record(Player, player_status) ->
%     #player_status{id = RoleId, copy_id = CopyId} = Player,
%     case lib_dungeon:is_on_dungeon(Player) of
%         true -> mod_dungeon:ask_add_friend(CopyId, RoleId, IdList);
%         false -> skip
%     end,
%     {ok, Player};

%% 副本通关
%% 玩家离线就不会通知到这里
handle_event(Player, #event_callback{type_id = ?EVENT_DUNGEON_SUCCESS, data = Data})  ->
    #callback_dungeon_succ{help_type=HelpType, dun_id = DunId, dun_type = DunType, count = Count} = Data,
    PartnerSuccess = is_partner_success(Data),
    ResourceSuccess = lib_dungeon_resource:is_resource_success(Data),
    if
        (HelpType == ?HELP_TYPE_NO andalso DunType =/= ?DUNGEON_TYPE_PARTNER_NEW) orelse PartnerSuccess orelse ResourceSuccess ->
            mod_daily:plus_count(Player#player_status.id, ?MOD_DUNGEON, ?MOD_DUNGEON_SUCCESS, DunType, Count),
            mod_counter:plus_count(Player#player_status.id, ?MOD_DUNGEON, ?MOD_DUNGEON_SUCCESS, DunId, Count),
            case DunType == ?DUNGEON_TYPE_RUNE2 of
                true ->
                    %% 刷新奖励列表
                    lib_boss_first_blood_plus:pass_dungeon(DunId, DunType, Player#player_status.id),
                    TargetList = data_dungeon:get_dun_reward_ids(DunType),
                    ?IF(lists:member(DunId, TargetList), lib_dungeon:send_dun_reward_info(Player#player_status.id, DunType), skip);
                false -> skip
            end,
            PlayerAfRecord = lib_dungeon:update_dungeon_record(Player, Data),
            F = fun(_Seq, TmpPlayer) ->
                lib_dungeon:handle_activitycalen(TmpPlayer, DunId),   %%活动日历
                NewTmpPlayer = lib_dungeon:handle_achievement(TmpPlayer, DunId),
                NewTmpPlayer
            end,
            NewPlayer = lists:foldl(F, PlayerAfRecord, lists:seq(1, Count));
        true ->
            NewPlayer = Player
    end,
    {ok, NewPlayer};

%% 拾取掉落
handle_event(Player, #event_callback{type_id = ?EVENT_DROP_CHOOSE, data = Data}) when is_record(Player, player_status) ->
    #player_status{id = RoleId, copy_id = CopyId} = Player,
    case lib_dungeon:is_on_dungeon(Player) of
        true ->
            SeeRewardList = maps:get(see_reward, Data, []),
            mod_dungeon:set_reward(CopyId, RoleId, [{?REWARD_SOURCE_DROP, SeeRewardList}], false), %%设置奖励
            DropWay = maps:get(drop_way, Data, ?DROP_WAY_NORAML),
            (DropWay == ?DROP_WAY_NORAML orelse DropWay == ?DROP_WAY_BAG) andalso mod_dungeon:drop_choose(CopyId, RoleId, Data);
        false ->
            skip
    end,
    {ok, Player};



%% 拾取掉落
handle_event(Player, #event_callback{type_id = ?EVENT_OTHERS_DROP, data = Data}) when is_record(Player, player_status) ->
    #player_status{id = RoleId, copy_id = CopyId} = Player,
    case lib_dungeon:is_on_dungeon(Player) of
        true ->
            SeeRewardList = maps:get(see_reward, Data, []),
            mod_dungeon:set_reward(CopyId, RoleId, [{?REWARD_SOURCE_OTHER_DROP, SeeRewardList}], false), %%设置奖励
            mod_dungeon:drop_choose(CopyId, RoleId, Data);
        false ->
            skip
    end,
    {ok, Player};

%% 任务掉落
handle_event(Player, #event_callback{type_id = ?EVENT_TASK_DROP, data = Callback}) when is_record(Player, player_status) ->
    #player_status{id = RoleId, copy_id = CopyId} = Player,
    case lib_dungeon:is_on_dungeon(Player) of
        true ->
            #callback_task_drop{reward = RewardL} = Callback,
            Data = #{goods => RewardL, id => 0},
            mod_dungeon:drop_choose(CopyId, RoleId, Data);
        false ->
            skip
    end,
    {ok, Player};

%% 发送公会邀请
% handle_event(
%         Player
%         , #event_callback{type_id = ?EVENT_SEND_GUILD_INVITE, data = #callback_guild_invite{invitee_id = InviteeId} }
%         ) when is_record(Player, player_status) ->
%     #player_status{id = RoleId, copy_id = CopyId} = Player,
%     case lib_dungeon:is_on_dungeon(Player) of
%         true -> mod_dungeon:send_guild_invite(CopyId, RoleId, InviteeId);
%         false -> skip
%     end,
%     {ok, Player};

%% 发送公会邀请
handle_event(
        Player
        , #event_callback{type_id = ?EVENT_LV_UP}
        ) when is_record(Player, player_status) ->
    #player_status{id = RoleId, copy_id = CopyId, figure = #figure{lv = Lv}} = Player,
    case lib_dungeon:is_on_dungeon(Player) of
        true ->
            mod_dungeon:role_lv_up(CopyId, RoleId, Lv);
        false ->
            skip
    end,
    {ok, Player};

handle_event(Player, #event_callback{type_id = ?EVENT_LOGIN_CAST}) when is_record(Player, player_status) ->
    NewPlayer = daily_reset_12(Player),
    {ok, MonInvadePlayer} = lib_dungeon_mon_invade:handle_daily_reward(NewPlayer), %%
    {ok, MonInvadePlayer};

handle_event(Player, _EventCallback) ->
    {ok, Player}.

daily_reset_12(#player_status{online = ?ONLINE_ON} = Player) ->
    %% 符文副本每日奖励计算
    %% {ok, RuneDunPlayer} = lib_dungeon_rune:handle_daily_reward(Player),
    NewPlayer = lib_dungeon:load_dungeon_record(Player),
    %% 诛邪战场昨日奖励
    {ok, EvilDunPlayer} = lib_dungeon_evil:handle_daily_reward(NewPlayer),
    %% 异兽入侵
    {ok, MonInvadePlayer} = lib_dungeon_mon_invade:handle_daily_reward(EvilDunPlayer),
    MonInvadePlayer;

daily_reset_12(Player) -> Player.

%% 设置队伍的情况
set_member_attr(_ClsType, DunPid, MemberId, TeamMemberType) ->
    case misc:is_process_alive(DunPid) of
        true -> mod_dungeon:update_dungeon_role(DunPid, MemberId, [{team_position, TeamMemberType}]);
        false -> skip
    end.

%% 日常完成次数类型
get_daily_count_type(DunType, DunId) ->
    if
        DunType =:= ?DUNGEON_TYPE_PER_BOSS ->
            DunId;
        DunType =:= ?DUNGEON_TYPE_PET2 ->
            DunId;
        true ->
            DunType
    end.

%% 日常助战次数类型
get_daily_help_type(DunType, _DunId) ->
    if
        true ->
            DunType
    end.

%% 日常重置次数类型
get_daily_reset_type(DunType, _DunId) ->
    if
        true ->
            DunType
    end.

%% 日常购买次数类型
get_daily_buy_type(DunType, _DunId) ->
    if
        % DunType =:= ?DUNGEON_TYPE_RUNE ->
        %     get_daily_reset_type(DunType, DunId);
        true ->
            DunType
    end.

%% 日常增加次数类型
get_daily_add_type(DunType, _DunId) ->
    if
        true ->
            DunType
    end.

%% 获取设置的副本key
get_setting_dun_key(DunType, _DunId) ->
    if
        true ->
            DunType
    end.

%% 获取设置鼓舞数据的key值
get_setting_encourage_data_dun_key(DunType, DunId) ->
    if
        DunType == ?DUNGEON_TYPE_EXP_SINGLE -> DunId;
        true -> DunType
    end.


get_daily_count_type_list(DunType) ->
    case get_daily_count_type(DunType, -1) of
        DunType ->
            [{?MOD_DUNGEON, ?MOD_DUNGEON_ENTER, DunType}];
        _ ->
            [{?MOD_DUNGEON, ?MOD_DUNGEON_ENTER, Id} || Id <- data_dungeon:get_ids_by_type(DunType)]
    end.

get_daily_buy_type_list(DunType) ->
    case get_daily_count_type(DunType, -1) of
        DunType ->
            [{?MOD_DUNGEON, ?MOD_DUNGEON_BUY, DunType}];
        _ ->
            [{?MOD_DUNGEON, ?MOD_DUNGEON_BUY, Id} || Id <- data_dungeon:get_ids_by_type(DunType)]
    end.

get_daily_add_type_list(DunType) ->
    case get_daily_add_type(DunType, -1) of
        DunType ->
            [{?MOD_DUNGEON, ?MOD_DUNGEON_ADD_COUNT, DunType}];
        _ ->
            [{?MOD_DUNGEON, ?MOD_DUNGEON_ADD_COUNT, Id} || Id <- data_dungeon:get_ids_by_type(DunType)]
    end.

get_daily_sweep_type_list(DunType) ->
    case get_daily_count_type(DunType, -1) of
        DunType ->
            [{?MOD_DUNGEON, ?MOD_RESOURCE_DUNGEON_SWEEP, DunType}];
        _ ->
            [{?MOD_DUNGEON, ?MOD_RESOURCE_DUNGEON_SWEEP, Id} || Id <- data_dungeon:get_ids_by_type(DunType)]
    end.

get_daily_challenge_type_list(DunType) ->
    case get_daily_count_type(DunType, -1) of
        DunType ->
            [{?MOD_DUNGEON, ?MOD_RESOURCE_DUNGEON_CHALLENGE, DunType}];
        _ ->
            [{?MOD_DUNGEON, ?MOD_RESOURCE_DUNGEON_CHALLENGE, Id} || Id <- data_dungeon:get_ids_by_type(DunType)]
    end.

get_daily_sweep_times_type_list(DunType) ->
    Diff = case lib_dungeon_resource:is_resource_dungeon_type(DunType) of
               true ->
                   get_daily_sweep_type_list(DunType);
               _ ->
                   get_daily_count_type_list(DunType)
           end,
    Diff ++ lib_dungeon_api:get_daily_buy_type_list(DunType) ++ lib_dungeon_api:get_daily_add_type_list(DunType).

get_daily_gage_times_type_list(DunType) ->
    Diff = case lib_dungeon_resource:is_resource_dungeon_type(DunType) of
               true ->
                   get_daily_challenge_type_list(DunType);
               _ ->
                   get_daily_count_type_list(DunType)
           end,
    Diff ++ lib_dungeon_api:get_daily_buy_type_list(DunType) ++ lib_dungeon_api:get_daily_add_type_list(DunType).



%%　暂时没用
% %% 永久完成次数类型
% get_counter_count_type(DunType, DunId) ->
%     if
%         DunType =:= ?DUNGEON_TYPE_DEVIL_INSIDE ->
%             DunId;
%         true ->
%             DunType
%     end.

% %% 永久完成次数类型列表
% get_counter_count_type_list(DunType) ->
%     case get_counter_count_type(DunType, -1) of
%         DunType ->
%             [{?MOD_DUNGEON, ?MOD_DUNGEON_ENTER, DunType}];
%         _ ->
%             [{?MOD_DUNGEON, ?MOD_DUNGEON_ENTER, Id} || Id <- data_dungeon:get_ids_by_type(DunType)]
%     end.


%% -----------------------------------------------------------------
%% @desc     功能描述   根据副本类型执行特殊api
%% @param    参数       DunType:integer  副本类型
%%                     ApiName: atom()   格式 dunex_XXXXXX       eg:dunex_get_send_reward
%%                     ArgsNum:integer
%% @return   返回值     undefined | atom()
%% @history  修改历史
%% -----------------------------------------------------------------
get_special_api_mod(DunType, ApiName, ArgsNum) ->
    Mod
    = case DunType of
        ?DUNGEON_TYPE_PET               -> lib_dungeon_pet;
        ?DUNGEON_TYPE_EQUIP             -> lib_dungeon_equip;
        ?DUNGEON_TYPE_EXP               -> lib_dungeon_exp;
        ?DUNGEON_TYPE_COIN              -> lib_dungeon_coin;
        ?DUNGEON_TYPE_RUNE              -> lib_soul_dungeon;
        ?DUNGEON_TYPE_RUNE2             -> lib_dungeon_rune;
        ?DUNGEON_TYPE_GUILD_BOSS        -> lib_dungeon_guild_boss;
        ?DUNGEON_TYPE_GUILD_GUARD       -> lib_dungeon_guild_guard;
        ?DUNGEON_TYPE_COUPLE            -> lib_dungeon_couple;
        ?DUNGEON_TYPE_EVIL              -> lib_dungeon_evil;
        ?DUNGEON_TYPE_TRAIN             -> lib_dungeon_train;
        ?DUNGEON_TYPE_NORMAL            -> lib_dungeon_normal;
        ?DUNGEON_TYPE_WAKE              -> lib_dungeon_wake;
        ?DUNGEON_TYPE_EXP_SINGLE        -> lib_dungeon_exp;
        ?DUNGEON_TYPE_ENCHANTMENT_GUARD -> lib_enchantment_guard;
        ?DUNGEON_TYPE_TOWER             -> lib_dungeon_tower;
        ?DUNGEON_TYPE_MAGIC_ORNAMENTS   -> lib_dungeon_magic_ornaments;
        ?DUNGEON_TYPE_MON_INVADE        -> lib_dungeon_mon_invade;
        ?DUNGEON_TYPE_DRAGON            -> lib_dun_dragon;
        ?DUNGEON_TYPE_PET2              -> lib_dun_demon;
        ?DUNGEON_TYPE_HIGH_EXP          -> lib_dungeon_high_exp;
        ?DUNGEON_TYPE_RANK_KF           -> lib_kf_rank_dungeon;
        ?DUNGEON_TYPE_WEEK_DUNGEON      -> lib_week_dungeon;
        ?DUNGEON_TYPE_PARTNER_NEW       -> lib_dungeon_partner;
        ?DUNGEON_TYPE_BEINGS_GATE       -> lib_beings_gate_api;
        ?DUNGEON_TYPE_LIMIT_TOWER       -> lib_dungeon_limit_tower;
        ?DUNGEON_TYPE_MOUNT_MATERIAL    -> lib_dungeon_coin;
        ?DUNGEON_TYPE_SPRITE_MATERIAL   -> lib_dungeon_coin;
        ?DUNGEON_TYPE_WING_MATERIAL     -> lib_dungeon_coin;
        ?DUNGEON_TYPE_AMULET_MATERIAL   -> lib_dungeon_coin;
        ?DUNGEON_TYPE_WEAPON_MATERIAL   -> lib_dungeon_coin;
        ?DUNGEON_TYPE_BACK_ACCESSORIES  -> lib_dungeon_coin;
        _ -> undefined
    end,
    if
        Mod =/= undefined -> ?IF(lists:member({ApiName, ArgsNum}, Mod:module_info(exports)), Mod, undefined);
        true -> undefined
    end.

%% -----------------------------------------------
%% @doc 根据副本类型调用对应的特殊函数
-spec
invoke(DunType, Fun, Args, Default) -> term() when
    DunType :: integer(), % 副本类型
    Fun     :: atom(),    % 特殊函数名
    Args    :: list(),    % 参数列表
    Default :: term().    % 默认值
%% -----------------------------------------------
invoke(DunType, Fun, Args, Default) ->
    case get_special_api_mod(DunType, Fun, length(Args)) of
        undefined -> Default;
        Mod       -> erlang:apply(Mod, Fun, Args)
    end.

%% return false|true
check_ever_finish(#player_status{id = RoleId} = Player, DunId) ->
    case data_dungeon:get(DunId) of
        #dungeon{type = DunType} ->
            case get_special_api_mod(DunType, dunex_update_dungeon_record, 2) of
                undefined ->
                    check_ever_finish(RoleId, DunId);
                _ ->
                    case Player#player_status.dungeon_record of
                        undefined ->
                            % lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, lib_dungeon, load_dungeon_record, []),
                            check_ever_finish(RoleId, DunId);
                        Rec ->
                            maps:is_key(DunId, Rec)
                    end
            end;
        _ ->
            false
    end;

%% 判断副本是否曾经完成过
check_ever_finish(RoleId, DunId) when is_integer(RoleId) ->
    Count = mod_counter:get_count_offline(RoleId, ?MOD_DUNGEON, ?MOD_DUNGEON_SUCCESS, DunId),
    Count > 0.

%% 判断副本今天是否完成过
check_today_finish(RoleId, DunId) ->
    Count = mod_daily:get_count_offline(RoleId, ?MOD_DUNGEON, ?MOD_DUNGEON_ENTER, DunId),
    Count > 0.

%% 检查副本的定制活动多倍掉落倍数
check_custom_act_drop_times(#player_status{figure = Figure} = Player) when is_record(Player, player_status) ->
    check_custom_act_drop_times(Figure);
check_custom_act_drop_times(#figure{lv = Lv}) ->
    case lib_custom_act_api:get_open_custom_act_infos(?CUSTOM_ACT_TYPE_DUN_MUL_DROP) of
        [#act_info{key = {ActId, SubId}}|_] ->
            case lib_custom_act_util:get_act_cfg_info(ActId, SubId) of
                #custom_act_cfg{condition = Condition} ->
                    case lists:keyfind(lv, 1, Condition) of
                        false -> true;
                        {lv, CfgLv} when Lv >= CfgLv -> true;
                        _ -> false
                    end;
                _ ->
                    false
            end;
        _ ->
            false
    end.

%% 获取副本的定制活动多倍掉落倍数 定制类型为12的活动加成
get_custom_act_drop_times(DunType) ->
    case lib_custom_act_api:get_open_custom_act_infos(?CUSTOM_ACT_TYPE_DUN_MUL_DROP) of
        [#act_info{key = {ActId, SubId}}|_] ->
            case lib_custom_act_util:get_act_cfg_info(ActId, SubId) of
                #custom_act_cfg{condition = Condition} ->
                    {types, Types} = ulists:keyfind(types, 1, Condition, {types, []}),
                    {DunType, N} = ulists:keyfind(DunType, 1, Types, {DunType, 1}),
                    {time, Time} = ulists:keyfind(time, 1, Condition, {time, {}}),
                    S = utime:get_seconds_from_midnight(),
                    case Time of
                        {{H1, M1, S1}, {H2, M2, S2}} when H1*3600 + M1*60 + S1 =< S andalso S =< H2*3600 + M2*60 + S2 ->
                            N;
                        _ ->
                            1
                    end;
                _ ->
                    1
            end;
        _ ->
            1
    end.

%% 获得定制活动多倍掉落倍数等级
%% @return false:无效 | Lv
get_custom_act_exp_ratio_lv() ->
    case lib_custom_act_api:get_open_custom_act_infos(?CUSTOM_ACT_TYPE_DUN_MUL_EXP) of
        [#act_info{key = {ActId, SubId}}|_] ->
            case lib_custom_act_util:get_act_cfg_info(ActId, SubId) of
                #custom_act_cfg{condition = Condition} ->
                    case lists:keyfind(lv, 1, Condition) of
                        false -> 0;
                        {lv, CfgLv} -> CfgLv
                    end;
                _ ->
                    false
            end;
        _ ->
            false
    end.

%% 检查副本的定制活动多倍掉落倍数
check_custom_act_exp_ratio(#player_status{figure = Figure} = Player) when is_record(Player, player_status) ->
    check_custom_act_exp_ratio(Figure);
check_custom_act_exp_ratio(#figure{lv = Lv}) ->
    case lib_custom_act_api:get_open_custom_act_infos(?CUSTOM_ACT_TYPE_DUN_MUL_EXP) of
        [#act_info{key = {ActId, SubId}}|_] ->
            case lib_custom_act_util:get_act_cfg_info(ActId, SubId) of
                #custom_act_cfg{condition = Condition} ->
                    case lists:keyfind(lv, 1, Condition) of
                        false -> true;
                        {lv, CfgLv} when Lv >= CfgLv -> true;
                        _ -> false
                    end;
                _ ->
                    false
            end;
        _ ->
            false
    end.

%% 获取副本的定制活动多倍掉落倍数
get_custom_act_exp_ratio(DunType) ->
    case lib_custom_act_api:get_open_custom_act_infos(?CUSTOM_ACT_TYPE_DUN_MUL_EXP) of
        [#act_info{key = {ActId, SubId}}|_] ->
            case lib_custom_act_util:get_act_cfg_info(ActId, SubId) of
                #custom_act_cfg{condition = Condition} ->
                    case lists:keyfind(types, 1, Condition) of
                        {types, Types} ->
                            case lists:keyfind(DunType, 1, Types) of
                                {DunType, N} ->
                                    case lists:keyfind(time, 1, Condition) of
                                        {time, {{H1, M1, S1}, {H2, M2, S2}}} ->
                                            S = utime:get_seconds_from_midnight(),
                                            if
                                                H1*3600 + M1*60 + S1 =< S andalso S =< H2*3600 + M2*60 + S2 ->
                                                    N;
                                                true ->
                                                    0
                                            end;
                                        _ ->
                                            N
                                    end;
                                _ ->
                                    0
                            end;
                        _ ->
                            0
                    end;
                _ ->
                    0
            end;
        _ ->
            0
    end.

get_dungeon_name(DunId) ->
    case data_dungeon:get(DunId) of
        #dungeon{name = Name} ->
            util:make_sure_binary(Name);
        _ ->
            <<"">>
    end.

get_dungeon_condition_lv(DunId) ->
    case data_dungeon:get(DunId) of
        #dungeon{condition = Conditions} ->
            case lists:keyfind(lv, 1, Conditions) of
                {lv, Lv} ->
                    Lv;
                _ ->
                    0
            end;
        _ ->
            0
    end.

%% 获得副本类型
get_dungeon_type(DunId) ->
    case data_dungeon:get(DunId) of
        #dungeon{type = Type} -> Type;
        _ -> 0
    end.

%% 获得副本最大次数
get_dungeon_daily_max_count(DunId) ->
    case data_dungeon:get(DunId) of
        #dungeon{count_cond = CountCond} ->
            case lists:keyfind(?DUN_COUNT_COND_DAILY, 1, CountCond) of
                {?DUN_COUNT_COND_DAILY, MaxNum} -> MaxNum;
                _ -> 0
            end;
        _ ->
            0
    end.

get_min_condition_lv(DunType) ->
    case data_dungeon:get_ids_by_type(DunType) of
        [] ->
            0;
        List ->
            lists:min([get_dungeon_condition_lv(DunId) || DunId <- List])
    end.

get_next_dungeon_id(DunId) ->
    case data_dungeon:get(DunId) of
        #dungeon{type = DunType, id = DunId} ->
            case get_relative_condition(DunType) of
                undefined ->
                    0;
                Key ->
                    Ids = data_dungeon:get_ids_by_type(DunType),
                    calc_next_dun_id(Ids, Key, DunId)
            end;
        _ ->
            0
    end.

get_relative_condition(?DUNGEON_TYPE_RUNE2) -> finish_dun_id;
%%get_relative_condition(?DUNGEON_TYPE_RUNE) -> today_finish_dun;
get_relative_condition(_) -> undefined.

calc_next_dun_id([Id|T], Key, DunId) ->
    if
        Id =:= DunId ->
            calc_next_dun_id(T, Key, DunId);
        true ->
            case data_dungeon:get(Id) of
                #dungeon{condition = Conditions} ->
                    case lists:keyfind(Key, 1, Conditions) of
                        {Key, DunId} ->
                            Id;
                        _ ->
                            calc_next_dun_id(T, Key, DunId)
                    end;
                _ ->
                    calc_next_dun_id(T, Key, DunId)
            end
    end;
calc_next_dun_id([], _, _) -> 0.

%% 获得任务中的副本次数
get_task_dungeon_num(?TASK_CONTENT_DUNGEON, RoleId, DunId) ->
    case data_dungeon:get(DunId) of
        #dungeon{type = DunType} -> get_task_dungeon_num_help(DunType, RoleId, DunId);
        _ -> 0
    end;
get_task_dungeon_num(?TASK_CONTENT_DUNGEON_TYPE, RoleId, DunType) ->
    get_task_dungeon_num_help(DunType, RoleId, DunType);
get_task_dungeon_num(_TaskType, _RoleId, _Args) ->
    0.

get_task_dungeon_num_help(DunType, RoleId, CountId) ->
    case DunType of
        ?DUNGEON_TYPE_RUNE2 -> mod_counter:get_count(RoleId, ?MOD_DUNGEON, ?MOD_DUNGEON_ENTER, CountId);
        ?DUNGEON_TYPE_TOWER -> mod_counter:get_count(RoleId, ?MOD_DUNGEON, ?MOD_DUNGEON_ENTER, CountId);
        ?DUNGEON_TYPE_TURN -> mod_counter:get_count(RoleId, ?MOD_DUNGEON, ?MOD_DUNGEON_ENTER, CountId);
        _ -> mod_daily:get_count(RoleId, ?MOD_DUNGEON, ?MOD_DUNGEON_ENTER, CountId)
    end.

%%获取副本评分奖励
get_dungeon_grade(DungeonRole, DunId, Score) ->
    case DungeonRole of
        #dungeon_role{id = RoleId, figure = #figure{name = RoleName, career = Career}} -> ok;
        #player_status{id = RoleId, figure = #figure{name = RoleName, career = Career}} -> ok
    end,
    case data_dungeon_grade:get_dungeon_grade(DunId, Score) of
        [] -> [];
        #dungeon_grade{reward = Rewards0, draw_list = DrawList, tv_goods_list = TVGoodsList} ->
            RewardList =
            case DrawList of
                [] ->   %%支持原来的格式
                    % 支持不同职业获取不同奖励且兼容旧的
                    case Rewards0 of
                        [{_Career, _Rewards}|_] -> {_, Rewards} = lists:keyfind(Career, 1, Rewards0);
                        _ -> Rewards = Rewards0
                    end,
                    case lib_goods_util:is_random_rewards(Rewards) of
                        false ->
                            Rewards;
                        _ ->
                            lib_goods_util:calc_random_rewards(Rewards)
                    end;
                _ ->
                    List = get_dungeon_grade_help(DrawList, Rewards0, []),  %%新的格式
                    NewList = [{GoodType, GoodId, Num} || {GoodType, GoodId, Num}<-List, Num > 0 andalso {GoodType, GoodId, Num}=/={0, 0, 0}],
	                NewList
            end,
            #dungeon{name = DunName} = data_dungeon:get(DunId),
            send_dungeon_grade_tv(RewardList, TVGoodsList, RoleId, RoleName, DunName),
            RewardList
    end.

%% 奖励传闻
send_dungeon_grade_tv([], _TVGoodsList, _RoleId, _RoleName, _DunName) -> ok;
send_dungeon_grade_tv([{_Type, GTypeId, Num} | T], TVGoodsList, RoleId, RoleName, DunName) ->
    case lists:member(GTypeId, TVGoodsList) of
        false -> skip;
        true -> lib_chat:send_TV({all}, ?MOD_DUNGEON, 12, [RoleName, RoleId, DunName, GTypeId, Num])
    end,
    send_dungeon_grade_tv(T, TVGoodsList, RoleId, RoleName, DunName);
send_dungeon_grade_tv([_ | T], TVGoodsList, RoleId, RoleName, DunName) ->
    send_dungeon_grade_tv(T, TVGoodsList, RoleId, RoleName, DunName).

%% Pool::list()  [{列表id,   [{{Type, GoodId, Num}, W}]}]
get_dungeon_grade_help([], _Pool, Res) ->
    ulists:object_list_plus([Res, []]);
get_dungeon_grade_help(_, [], _Res) ->
    [];
get_dungeon_grade_help([{ListId, DrawNum} | TailDrawList], Pool, Res) ->
    case lists:keyfind(ListId, 1, Pool) of
        false ->
            get_dungeon_grade_help(TailDrawList, Pool, Res);
        {ListId, SubPool} ->
            RewardList = get_dungeon_grade_help2(SubPool, DrawNum),
            get_dungeon_grade_help(TailDrawList, Pool, RewardList ++ Res)
    end;
get_dungeon_grade_help(_, _, _) ->
    [].


get_dungeon_grade_help2(_Pool, 0) ->
    [];
get_dungeon_grade_help2([], _) ->
    [];
get_dungeon_grade_help2(Pool, DrawNum) ->
    TempList = find_ratio_list(Pool, 2, DrawNum),
    RewardList = [ Reward || {Reward, _W} <- TempList],
    F = fun(R, Acc) ->
            case R of
                {GoodType, GoodId, [Min, Max]}  ->
                    Num = urand:rand(Min, Max),
                    [{GoodType, GoodId, Num} | Acc];
                {GoodType, GoodId, Num} when Num > 0 ->
                    [{GoodType, GoodId, Num} | Acc];
                {_GoodType, _GoodId, Num} when Num == 0 ->
                    Acc;
                _ ->
                    [R |Acc]
            end
        end,
    NewRewardList = lists:foldl(F, [], RewardList),
    NewRewardList.

%% -----------------------------------------------------------------
%% @desc     功能描述
%% @param    参数   List:: [element]  ,N::integer 权重坐标,   Times::抽奖次数
%% @return   返回值  [element].
%% @history  修改历史
%% -----------------------------------------------------------------
find_ratio_list([], _N, _Times) ->
    [];
find_ratio_list(List, N, Times) ->
    find_ratio_list(List, N, Times, []).
find_ratio_list(_List, _N, 0, Res) ->
    Res;
find_ratio_list(List, N, Times, Res) ->
    R = util:find_ratio(List, N),
    find_ratio_list(List, N, Times - 1, [R | Res]).

%% 玩家升级[副本调用]
role_lv_up(Player, DunType, Lv, EndTime) ->
    NewPlayer = case lib_dungeon:check_other_exp_act(Player) of
        true ->
            Player;
        _ ->
            CfgLv = get_custom_act_exp_ratio_lv(),
            if
                Lv == CfgLv ->
                    CheckDunExpRatio = check_custom_act_exp_ratio(Player),
                    Ratio = case get_custom_act_exp_ratio(DunType) of
                        Ratio0 when CheckDunExpRatio -> Ratio0;
                        _ -> 0
                    end,
                    Effect = lib_custom_act_liveness:get_server_effect_by_dun_type(Player, DunType),
                    NewRatio = Effect*?RATIO_COEFFICIENT + Ratio,
                    case NewRatio > 0 of
                        true -> lib_goods_buff:add_goods_temp_buff(Player, ?BUFF_EXP_DUN_ACT, [{attr, [{?EXP_ADD, NewRatio}]}], EndTime);
                        false -> Player
                    end;
                true ->
                    Player
            end
    end,
    {ok, NewPlayer}.


%% 获得副本关卡
get_dun_level_map(Player) ->
    DunTypeL = [?DUNGEON_TYPE_RUNE2, ?DUNGEON_TYPE_TOWER, ?DUNGEON_TYPE_ENCHANTMENT_GUARD],
    F = fun(DunType, Map) ->
        Level = get_dungeon_level(Player, DunType),
        maps:put(DunType, Level, Map)
    end,
    lists:foldl(F, #{}, DunTypeL).

%% 获得副本关卡
get_dungeon_level(Player, DunType) ->
    case DunType of
        ?DUNGEON_TYPE_RUNE2 -> lib_dungeon_rune:get_dungeon_level(Player);
        ?DUNGEON_TYPE_TOWER -> lib_dungeon_tower:get_dungeon_level(Player, DunType);
        ?DUNGEON_TYPE_ENCHANTMENT_GUARD -> lib_enchantment_guard:get_dungeon_level(Player);
        _ -> 0
    end.

%% -----------------------------------------------------------------
%% @desc     功能描述 获得基础奖励和额外奖励
%% @param    参数    RewardsList::[ [{GoodsType, GoodsId, Num}]...]
%%                   Mul::integer() 副本奖励倍数
%% @return   返回值  [ [{?REWARD_SOURCE_DUNGEON, BaseReward},
%%                      {?REWARD_SOURCE_DUNGEON_MULTIPLE, MultipleReward},
%%                          {?REWARD_SOURCE_WEEKLY_CARD, WeeklyCardReward}]...]
%% @history  修改历史
%% -----------------------------------------------------------------
get_base_reward_and_multiple_reward_by_multiple(RewardsList, 1, []) ->
    get_base_reward_and_multiple_reward_by_multiple_help(RewardsList, []);
get_base_reward_and_multiple_reward_by_multiple(RewardsList, 1, WeeklyCardRewards) ->
    get_base_reward_and_multiple_reward_by_multiple_help(RewardsList, WeeklyCardRewards, []);
get_base_reward_and_multiple_reward_by_multiple(RewardsList, Mul, WeeklyCardRewards) ->
    get_base_reward_and_multiple_reward_by_multiple_help(RewardsList, Mul, WeeklyCardRewards, []).

get_base_reward_and_multiple_reward_by_multiple_help([], Res) -> Res;
get_base_reward_and_multiple_reward_by_multiple_help([Reward | T], Res) ->
    get_base_reward_and_multiple_reward_by_multiple_help(T, [[{?REWARD_SOURCE_DUNGEON, Reward},
        {?REWARD_SOURCE_DUNGEON_MULTIPLE, []}, {?REWARD_SOURCE_WEEKLY_CARD, []}] |Res]).

get_base_reward_and_multiple_reward_by_multiple_help([], _WeeklyCardRewards, Res) -> Res;
get_base_reward_and_multiple_reward_by_multiple_help([Reward | T], [WeeklyCardReward | WeeklyCardRewards], Res) ->
    F = fun({GoodsType, GoodsId, Num}, {AccBaseReward, AccWeeklyCardReward}) ->
        case ulists:keyfind(GoodsId, 2, WeeklyCardReward, false) of
            false -> {[{GoodsType, GoodsId, Num} | AccBaseReward], AccWeeklyCardReward};
            {GoodsTypeA, GoodsIdA, NumA} ->
                {[{GoodsType, GoodsId, Num} | AccBaseReward], [{GoodsTypeA, GoodsIdA, NumA} | AccWeeklyCardReward]}
        end
    end,
    {BaseReward, NewWeeklyCardReward} = lists:foldl(F, {[], []}, Reward),
    get_base_reward_and_multiple_reward_by_multiple_help(T, WeeklyCardRewards, [[{?REWARD_SOURCE_DUNGEON, BaseReward},
        {?REWARD_SOURCE_DUNGEON_MULTIPLE, []}, {?REWARD_SOURCE_WEEKLY_CARD, NewWeeklyCardReward}] |Res]).

get_base_reward_and_multiple_reward_by_multiple_help([], _Mul, _WeeklyCardRewards, Res) ->
    Res;
get_base_reward_and_multiple_reward_by_multiple_help([Reward | T], Mul, [], Res) ->
    F = fun({GoodsType, GoodsId, Num}, {AccBaseReward, AccMultipleReward}) ->
        NewAccBaseReward = [{GoodsType, GoodsId, round(Num / Mul)} | AccBaseReward],
        case round(Num / Mul *(Mul - 1)) of
            0 ->
                NewAccMultipleReward = AccMultipleReward;
            NewNum ->
                NewAccMultipleReward = [{GoodsType, GoodsId, NewNum} | AccMultipleReward]
        end,
        {NewAccBaseReward, NewAccMultipleReward}
    end,
    {BaseReward, MultipleReward} = lists:foldl(F, {[], []}, Reward),
    get_base_reward_and_multiple_reward_by_multiple_help(T, Mul, [],
        [[{?REWARD_SOURCE_DUNGEON, BaseReward}, {?REWARD_SOURCE_DUNGEON_MULTIPLE, MultipleReward}, {?REWARD_SOURCE_WEEKLY_CARD, []}] | Res]);
get_base_reward_and_multiple_reward_by_multiple_help([Reward | T], Mul, [WeeklyCardReward | WeeklyCardRewards], Res) ->
    F = fun({GoodsType, GoodsId, Num}, {AccBaseReward, AccMultipleReward, AccWeeklyCardReward}) ->
        case ulists:keyfind(GoodsId, 2, WeeklyCardReward, false) of
            false ->
                NewAccBaseReward = [{GoodsType, GoodsId, round(Num / Mul)} | AccBaseReward],
                case round(Num / Mul *(Mul - 1)) of
                    0 ->
                        NewAccMultipleReward = AccMultipleReward;
                    NewNum ->
                        NewAccMultipleReward = [{GoodsType, GoodsId, NewNum} | AccMultipleReward]
                end,
                {NewAccBaseReward, NewAccMultipleReward, AccWeeklyCardReward};
            {GoodsTypeA, GoodsIdA, NumA} ->
                NewAccBaseReward = [{GoodsType, GoodsId, round(Num / Mul)} | AccBaseReward],
                case round(Num / Mul *(Mul - 1)) of
                    0 ->
                        NewAccMultipleReward = AccMultipleReward;
                    NewNum ->
                        NewAccMultipleReward = [{GoodsType, GoodsId, NewNum} | AccMultipleReward]
                end,
                {NewAccBaseReward, NewAccMultipleReward, [{GoodsTypeA, GoodsIdA, NumA} | AccWeeklyCardReward]}
        end
    end,
    {BaseReward, MultipleReward, NewWeeklyCardReward} = lists:foldl(F, {[], [], []}, Reward),
    get_base_reward_and_multiple_reward_by_multiple_help(T, Mul, WeeklyCardRewards,
        [[{?REWARD_SOURCE_DUNGEON, BaseReward}, {?REWARD_SOURCE_DUNGEON_MULTIPLE, MultipleReward}, {?REWARD_SOURCE_WEEKLY_CARD, NewWeeklyCardReward}] | Res]).

%% -----------------------------------------------------------------
%% @desc     功能描述 返回扫荡时的全部奖励
%% @param    参数     RewardsList:: [ [{?REWARD_SOURCE_DUNGEON, BaseReward}, {?REWARD_SOURCE_DUNGEON_MULTIPLE, MultipleReward}] ...]
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
get_sweep_all_reward(RewardsList) ->
    F = fun([{_, Reward1}, {_, Reward2}, {_, Reward3}], AccList) ->
        AccList ++ Reward1 ++ Reward2 ++ Reward3
        end,
    lists:foldl(F, [], RewardsList).

%% -----------------------------------------------------------------
%% @desc     功能描述  是否可以快速出怪
%% @param    参数      DunType::integer() 副本类型  DunId::integer()  副本id
%% @return   返回值    false | {每个人可以快速出怪次数, 快速出怪CD};
%% @history  修改历史
%% -----------------------------------------------------------------
can_quick_create_mon(DunType, DunId) ->
    case data_dungeon_special:get(DunType, quick_create_mon) of
        {MaxQuickCount, QuickCd} ->
            {MaxQuickCount, QuickCd};
        _ ->
            case data_dungeon_special:get(DunId, quick_create_mon) of
                {MaxQuickCount, QuickCd} ->
                    {MaxQuickCount, QuickCd};
                _ ->
                    false
            end
    end.

get_quick_time(DunType, DunId) ->
    case data_dungeon_special:get(DunType, quick_time) of
        undefined ->
            case data_dungeon_special:get(DunId, quick_time) of
                undefined ->
                    0;
                Time ->
                    Time
            end;
        Time ->
            Time
    end.

%% 拾取怪物
pick_mon(Minfo, CollectorId) ->
    #scene_object{
        id = _AutoId, mon=Mon, scene = SceneId, copy_id = CopyId, sign = _DieSign, skill_owner = SkillOwner
        , skill=Skill, x=X, y=Y} = Minfo,
    Coord = {X, Y},
    #scene_mon{mid = Mid, create_key = _CreateKey} = Mon,
    case is_record(SkillOwner, skill_owner) of
        true -> _OwnId = SkillOwner#skill_owner.id;
        false -> _OwnId = 0
    end,
    case data_scene:get(SceneId) of
        #ets_scene{type = ?SCENE_TYPE_DUNGEON} ->
            case misc:is_process_alive(CopyId) of
                true ->
                    mod_dungeon:pick_mon(CopyId, Mid, Coord, Skill, CollectorId);
                false ->
                    skip
            end;
        _ ->
            skip
    end.

%%使魔和怪物的对应列表
get_demon_list(DunType) ->
    case data_dungeon_special:get(DunType, demon_list) of
        [_ | _] = List ->
            List;
        _ ->
            []
    end.

%%使魔的坐标
get_demon_xy(DunType) ->
    case data_dungeon_special:get(DunType, demon_xy) of
        [_ | _] = List ->
            List;
        _ ->
            []
    end.

is_partner_success(Data) ->
    #callback_dungeon_succ{dun_type = DunType, pass_time = PassTime, dun_id = DunId} = Data,
    if
        DunType =/= ?DUNGEON_TYPE_PARTNER_NEW ->
            false;
        true ->
            TimeScore = lib_dungeon:get_time_score(DunId, PassTime),
            if
                TimeScore > 0 ->  %% 大于1分则认为是通关
                    true;
                true ->
                    false
            end
    end.

is_dungeon_success(PS, DungeonId) ->
    mod_counter:get_count(PS#player_status.id, ?MOD_DUNGEON, ?MOD_DUNGEON_SUCCESS, DungeonId) > 0.