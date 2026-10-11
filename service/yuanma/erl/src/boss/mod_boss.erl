%%%-------------------------------------------------------------------
%%% @author root <root@localhost.localdomain>
%%% @copyright (C) 2017, root
%%% @doc
%%%
%%% @end
%%% Created : 27 Oct 2017 by root <root@localhost.localdomain>
%%%-------------------------------------------------------------------
-module(mod_boss).

-behaviour(gen_server).

%% API
-export([start_link/0]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
    terminate/2, code_change/3]).

-compile(export_all).

-include("common.hrl").
-include("boss.hrl").
-include("def_fun.hrl").
-include("scene.hrl").
-include("errcode.hrl").
-include("predefine.hrl").
-include("def_module.hrl").
-include("goods.hrl").
-include("server.hrl").
-include("drop.hrl").
-include("domain.hrl").
-include("rec_event.hrl").
-include("def_event.hrl").
-include("weekly_card.hrl").

%% pt_46000_[1]
%% pt_46001_[1, 1]
%% pt_46002_[]

%%%===================================================================
%%% API
%%%===================================================================

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

%% 获取boss信息
get_boss_info(RoleId, Sid, BossType, LessCount, AllCount, LessTired, AllTired, Vit, LastVitTime, LCollectTimes, AllCollectTimes) ->
    gen_server:cast(?MODULE, {'get_boss_info', RoleId, Sid, BossType, LessCount, AllCount, LessTired, AllTired, Vit, LastVitTime, LCollectTimes, AllCollectTimes}).

%% 获取击杀日志
get_boss_kill_log(Sid, BossType, BossId) ->
    gen_server:cast(?MODULE, {'get_boss_kill_log', Sid, BossType, BossId}).

%% 获取掉落日志
get_boss_drop_log(Sid) ->
    gen_server:cast(?MODULE, {'get_boss_drop_log', Sid}).

%% 进入
enter(RoleId, Lv, WeeklyCardStatus, BossType, BossId) ->
    enter(RoleId, Lv, WeeklyCardStatus, BossType, BossId, 0).

%% 进入
enter(RoleId, Lv, WeeklyCardStatus, BossType, BossId, AddAnger) ->
    gen_server:cast(?MODULE, {'enter', RoleId, Lv, WeeklyCardStatus, BossType, BossId, AddAnger}).

%% 退出
quit(RoleId, BossType, CopyId, Scene, OldX, OldY) ->
    gen_server:cast(?MODULE, {'quit', RoleId, BossType, CopyId, Scene, OldX, OldY}).

%% 中途加怒气
boss_anger_add(RoleId, BossType, AddAngle) ->
    gen_server:cast(?MODULE, {'boss_anger_add', RoleId, BossType, AddAngle}).

%% 中途减少怒气
boss_anger_reduce(RoleId, BossType, ReduceAngle) ->
    gen_server:cast(?MODULE, {'boss_anger_reduce', RoleId, BossType, ReduceAngle}).

%% 取消怒气操作
cancel_boss_anger_add(RoleId, BossType) ->
    gen_server:cast(?MODULE, {'cancel_boss_anger_add', RoleId, BossType}).

%% 关注操作
boss_remind_op(RoleId, BossType, BossId, Remind, IsAuto) ->
    gen_server:cast(?MODULE, {'boss_remind_op', RoleId, BossType, BossId, Remind, IsAuto}).

%% 伤害
be_hurted(BossType, BossId, Hp, HpLim, RoleId, Hurt) ->
    gen_server:cast(?MODULE, {'be_hurted', BossType, BossId, Hp, HpLim, RoleId, Hurt}).
%%场景的怪物被怪物杀死
boss_be_kill_by_mon(SceneId, ScenePoolId, MonCfgid, AttrId, AttrName, BLWho, DX, DY, FirstAttr, MonArgs) ->
    FeastScene = ?FEAST_BOSS_SCENE, %%节日boss的场景
    %%节日水晶id水晶id列表
    FeastCrystalList = lib_boss:get_feast_boss_crystal_mon_list(),
    IsFeastBossCrystal = lists:member(MonCfgid, FeastCrystalList),
    if
        IsFeastBossCrystal andalso FeastScene == SceneId ->
            gen_server:cast(?MODULE, {'boss_be_kill', ScenePoolId, ?BOSS_TYPE_FEAST,
                MonCfgid, AttrId, AttrName, BLWho, DX, DY, FirstAttr, MonArgs});
        true ->
            skip
    end.

%% boss被击杀
boss_be_kill(Scene, ScenePoolId, BossId, AttrId, AttrName, BLWho, DX, DY, FirstAttr, MonArgs) ->
    % boss首杀触发
    lib_boss_first_blood_plus:boss_be_killed(BossId, BLWho),
    % 节日场景Boss击杀
    handle_boss_be_killed_at_feast_scene(Scene, ScenePoolId, BossId, AttrId, AttrName, BLWho, DX, DY, FirstAttr, MonArgs),
    case data_boss:get_boss_cfg(BossId) of
        #boss_cfg{scene = Scene, type = BossType} ->
            lib_guild_daily:kill_boss(BossType, BLWho),
            if
                BossType == ?BOSS_TYPE_VIP_PERSONAL orelse BossType == ?BOSS_TYPE_PERSONAL ->
                    skip;
                BossType == ?BOSS_TYPE_SPECIAL; BossType == ?BOSS_TYPE_PHANTOM_PER; BossType == ?BOSS_TYPE_WORLD_PER ->
                    mod_special_boss:boss_be_kill(ScenePoolId, BossType, BossId, AttrId, AttrName, BLWho, DX, DY, FirstAttr, MonArgs);
                true ->
                    gen_server:cast(?MODULE, {'boss_be_kill', ScenePoolId, BossType, BossId, AttrId, AttrName, BLWho, DX, DY, FirstAttr, MonArgs})
            end;
        #boss_cfg{type = BossType} ->
            % Boss未在配置场景下的击杀
            handle_boss_be_killed_on_uncfg_scene(BossType, Scene, ScenePoolId, BossId, AttrId, AttrName, BLWho, DX, DY, FirstAttr, MonArgs);
        _ ->
            skip
    end.

%% 死亡处理
player_die(SceneId, AtterSign, AtterId, AtterName, AtterGuildId, AttMaskId, DieId, DerGuildId, DerName, DerMaskId, X, Y) ->
    gen_server:cast(?MODULE, {'player_die', SceneId, AtterSign, AtterId, AtterName, AtterGuildId, AttMaskId, DieId, DerGuildId, DerName, DerMaskId, X, Y}).

%% 增加抢夺次数
add_rob_count(BossType, BossId, RoleId) ->
    gen_server:cast(?MODULE, {'add_rob_count', BossType, BossId, RoleId}).

%% 增加被抢夺次数
add_robbed_count(BossType, BossId, RobbedId) ->
    gen_server:cast(?MODULE, {'add_robbed_count', BossType, BossId, RobbedId}).

%%======================================================世界boss专用接口===================================================

%%世界boss，伤害排名
rank_damage(BossType, BossId, Pid, RoleId, Name, Hurt) ->
    gen_server:cast(?MODULE, {'rank_damage', BossType, BossId, Pid, RoleId, Name, Hurt}).

%%世界boss，鼓舞
inspire_self(RoleId, Pid, InspireType) ->
    gen_server:cast(?MODULE, {'inspire_self', RoleId, Pid, InspireType}).

%% 记录鼓舞次数
setup_inspire_count(RoleId, InspireList) ->
    gen_server:cast(?MODULE, {'setup_inspire_count', RoleId, InspireList}).

%%获取鼓舞记录
get_inspire_count(RoleId) ->
    gen_server:cast(?MODULE, {'get_inspire_count', RoleId}).

%% 重连，增加鼓舞buff
add_inspire_buff(RoleId, Pid, Scene) ->
    gen_server:cast(?MODULE, {'add_inspire_buff', RoleId, Pid, Scene}).

%% 处理 重连
get_killed_wldboss() ->
    Resoult = gen_server:call(?MODULE, {'get_killed_boss'}),
    if
        is_list(Resoult) ->
            Resoult;
        true ->
            []
    end.

gm_wldboss_init() ->
    gen_server:cast(?MODULE, {'gm_wldboss_init', ?BOSS_TYPE_WORLD}).

%%========================================================================================================================
%% 掉落日志添加添加
boss_add_drop_log(RoleId, RoleName, Scene, BossType, BossId, GoodsInfoL) ->
    % case data_boss:get_boss_cfg(BossId) of
    %     #boss_cfg{scene = Scene} ->
    %         ?IF(Notice =:= [], skip,
    %             gen_server:cast(?MODULE, {'boss_add_drop_log', RoleId, RoleName, Scene, BossId, GoodsInfo}));
    %     _ ->
    %         skip
    % end.
    F = fun({GoodsId, _Num, _Rating, _ExtraAttr}) ->
        lists:member(GoodsId, ?BOSS_TYPE_KV_LOG_GOODS_LIST(?BOSS_TYPE_GLOBAL))
    end,
    NewGoodsInfoL = lists:filter(F, GoodsInfoL),
    case length(NewGoodsInfoL) > 0 andalso BossType > 0 of
        true ->
            gen_server:cast(?MODULE, {'boss_add_drop_log', RoleId, RoleName, Scene, BossType, BossId, NewGoodsInfoL});
        false -> skip
    end.

%% boss怒气值
get_boss_anger(RoleId) ->
    gen_server:cast(?MODULE, {'get_boss_anger', RoleId}).

%% 获取蛮荒倒计时
get_boss_anger_time(RoleId) ->
    gen_server:cast(?MODULE, {'get_boss_anger_time', RoleId}).

%% 蛮荒禁地被杀加怒气
forbidden_boss_bekill_add_anger(Scene, RoleId) ->
    case lib_boss:is_in_forbdden_boss(Scene) of
        false ->
            skip;
        true ->
            gen_server:cast(?MODULE, {'forbidden_boss_bekill_add_anger', RoleId, Scene})
    end.

%% 上古神庙随机怪坐标（给客户端）
temple_mon_rand_xy(Sid, BossType, BossId) ->
    gen_server:cast(?MODULE, {'temple_mon_rand_xy', Sid, BossType, BossId}).

%% 离开boss场景
logout_boss(RoleId, Scene, LogoutType, CopyId) ->
    gen_server:cast(?MODULE, {'logout_boss', Scene, RoleId, LogoutType, CopyId}).


%% 玩家等级
lv_up(RoleId, Lv) ->
    gen_server:cast(?MODULE, {'lv_up', RoleId, Lv}).

%% 每天0点清理boss日志
clean_boss_log(_DelaySec) ->
    gen_server:cast(?MODULE, {'clean_boss_log'}).

%% 秘籍
gm_boss_init() ->
    gen_server:cast(?MODULE, {'gm_boss_init'}).

%% 秘籍-重置秘境领域采集怪
gm_reinit_domain_cl_boss() ->
    gen_server:cast(?MODULE, {'gm_reinit_domain_cl_boss'}).

%% 秘籍-重置秘境领域毁灭领主
gm_fix_sp_boss() ->
    gen_server:cast(?MODULE, {'gm_fix_sp_boss'}).

%% 刷新已击杀本服Boss(个人boss, 世界boss除外)
refresh_killed_boss() -> %%不确定 mod_collect 的需求，暂时不复活世界boss
    refresh_killed_boss(normal).

refresh_killed_boss(RefreshType) ->
    gen_server:cast(?MODULE, {'refresh_killed_boss', RefreshType}).

gm_create_temple_mon() ->
    gen_server:cast(?MODULE, {'gm_create_temple_mon'}).

gm_create_domain_boss(Scene) ->
    case lib_boss:is_in_domain_boss(Scene) of
        true -> gen_server:cast(?MODULE, {'gm_create_domain_boss', Scene});
        _ -> skip
    end.

refresh_boss(BossType, BossId) ->
    gen_server:cast(?MODULE, {'refresh_boss_use_goods', BossType, BossId}).

%% Scene 玩家所在场景
refresh_boss(BossType) ->
    if
        BossType == ?BOSS_TYPE_SPECIAL; BossType == ?BOSS_TYPE_PHANTOM_PER; BossType == ?BOSS_TYPE_WORLD_PER ->
            OnlineRoles = ets:tab2list(?ETS_ONLINE),
            [lib_player:apply_cast(E#ets_online.id, ?APPLY_CAST_STATUS, mod_boss, refresh_boss_special, [BossType]) || E <- OnlineRoles];
        true ->
            gen_server:cast(?MODULE, {'refresh_boss', BossType})
    end.

refresh_boss_special(#player_status{id = RoleId, scene = Scene}, BossType) ->
    mod_special_boss:refresh_boss(BossType, RoleId, Scene).
% %%set设置物品掉落奖励
% set_drop_reward(RoleId, RewardType, RewardList) ->
%     gen_server:cast(?MODULE, {'set_drop_reward', RoleId, RewardType, RewardList}).

% %%set设置额外奖励
% set_other_drop_reward(RoleId, RewardType, DropList) ->
%     gen_server:cast(?MODULE, {'set_other_drop_reward', RoleId, RewardType, DropList}).

%% 设置奖励
%% @param SourceReward [{SourceType, Reward}|{RewardType, SourceType, Reward}]
set_reward(RoleId, SourceReward) ->
    gen_server:cast(?MODULE, {'set_reward', RoleId, SourceReward}).


feast_boss_act_start() ->
    gen_server:cast(?MODULE, {'feast_boss_act_start'}).

feast_boss_act_end() ->
    gen_server:cast(?MODULE, {'feast_boss_act_end'}).

gm_feast_boss_reset(RoleId) ->
    gen_server:cast(?MODULE, {'gm_feast_boss_reset', RoleId}).

%%检查是否可以采集
check_feast_boss_collect_times(ModAutoId, ModCfgId, {RoleId, CopyId}) ->
    gen_server:call(?MODULE, {'check_feast_boss_collect_times', ModAutoId, ModCfgId, RoleId, CopyId}).

%% 秘境boss宝箱抽奖
draw(BossId, Times, RoleId) -> %%Type 1钻石 2绑钻
    gen_server:cast(?MODULE, {'fairyland_boss_draw', BossId, Times, RoleId}).

draw_data(BossId, ToRoleId) ->
    gen_server:cast(?MODULE, {'fairyland_boss_draw_data', BossId, ToRoleId}).

online_num_map_update(OnlineNumMap) ->
    gen_server:cast(?MODULE, {'online_num_map_update', OnlineNumMap}).

get_draw_data(BossId) ->
    gen_server:call(?MODULE, {'get_fairyland_boss_draw_data', BossId}).


%% 刷新XX boss
refresh_killed_forb_boss() ->
    gen_server:cast(?MODULE, {'refresh_killed_forb_boss'}).


%% 获取秘境领域阶段奖励状态
get_domain_boss_reward(Sid, RoleId) ->
    gen_server:cast(?MODULE, {'get_domain_boss_reward', Sid, RoleId}).


%%  秘境领域阶段 领取奖励
take_domain_boss_reward(Sid, RoleId, RoleLv, RewardId) ->
    gen_server:cast(?MODULE, {'take_domain_boss_reward', Sid, RoleId, RoleLv, RewardId}).

%% 秘境领域4点发送 邮件奖励
domain_mail_reward() ->
    gen_server:cast(?MODULE, {'domain_mail_reward'}).

%% 秘境boss 宝箱信息
send_domain_cl_boss(RoleId) ->
    gen_server:cast(?MODULE, {'send_domain_cl_boss', RoleId}).

%% 消耗复活
cost_reborn(RoleId, BossType, BossId) ->
    gen_server:cast(?MODULE, {'cost_reborn', RoleId, BossType, BossId}).

%% 秘籍：清除玩家不能自动关注状态
gm_clear_no_auto_remind_state(RoleId) ->
    gen_server:cast(?MODULE, {'gm_clear_no_auto_remind_state', RoleId}).

%%%===================================================================
%%% gen_server callbacks
%%%===================================================================
init([]) ->
    process_flag(trap_exit, true),
    erlang:send_after(1000, self(), 'boss_init'),
    {ok, #boss_state{}}.

handle_call(Request, _From, State) ->
    % Reply = ok,
    % {reply, Reply, State}.
    case catch do_handle_call(Request, State) of
        {reply, Resoult, NewState} ->
            {reply, Resoult, NewState};
        Res ->
            ?ERR("Boss Msg Error:~p~n", [[Request, Res]]),
            {reply, ok, State}
    end.

handle_cast(Msg, State) ->
    case catch do_handle_cast(Msg, State) of
        {noreply, NewState} ->
            {noreply, NewState};
        Res ->
            ?ERR("Boss Msg Error:~p~n", [[Msg, Res]]),
            {noreply, State}
    end.

handle_info(Info, State) ->
    case catch do_handle_info(Info, State) of
        {noreply, NewState} ->
            {noreply, NewState};
        Res ->
            ?ERR("Boss Info Error:~p~n", [[Info, Res]]),
            {noreply, State}
    end.

terminate(_Reason, _State) ->
    %% ?ERR("~p is terminate:~p", [?MODULE, _Reason]),
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================


%%世界boss专用，获取已击杀的bossid,世界boss复活前会清理掉击杀日志
do_handle_call({'get_killed_boss'}, State) ->
    % NowTime = utime:unixtime(),
    #boss_state{boss_world_map = WldBossMap} = State,
    AllBossIds = data_boss:get_all_boss_id(),
    Fun = fun(BossId, Acc) ->
        case data_boss:get_boss_cfg(BossId) of
            #boss_cfg{type = Type} when Type == ?BOSS_TYPE_WORLD ->
                case maps:get(BossId, WldBossMap, null) of
                    #boss_status{kill_log = KillLog} when KillLog =/= [] ->
                        [BossId | Acc];
                    _ ->
                        Acc
                end;
            _ ->
                Acc
        end
    end,
    KilledBoss = lists:foldl(Fun, [], AllBossIds),
    {reply, KilledBoss, State};

do_handle_call({'check_feast_boss_collect_times', ModAutoId, _ModCfgId, RoleId, CopyId}, #boss_state{common_status_map = CommMap} = State) ->
    %%  ?MYLOG("cym", "~p~n", [{ModAutoId, _ModCfgId, RoleId, CopyId}]),
    try
        {ok, #boss_common_status{copy_msg = CopyList}} = maps:find(?BOSS_TYPE_FEAST, CommMap),
        #copy_msg{other_map = OtherMap} = lists:keyfind(CopyId, #copy_msg.copy_id, CopyList),
        {ok, BoxList} = maps:find(?feast_boss_box, OtherMap),
        #feast_boss_box{refresh_direct = Direct, wave = Wave} = lists:keyfind(ModAutoId, #feast_boss_box.auto_id, BoxList),
        Res = case maps:find(?feast_boss_role_collection, OtherMap) of
            {ok, RoleCollection} ->
                case lists:keyfind({Direct, Wave, RoleId}, #feast_boss_role_collection.key, RoleCollection) of
                    #feast_boss_role_collection{collect_limit = Limit, collect_count = Count} ->
                        case Limit > Count of
                            true -> true;
                            false -> {false, 7}
                        end;
                    % 没有搜集信息则直接可以采集
                    _ -> true
                end;
            % 没有搜集信息则直接可以采集
            _ -> true
        end,
        {reply, Res, State}
    catch
        % 没有相应记录，一律失败
        _:_ -> {reply, {false, 4}, State}
    end;

%==============================================================
do_handle_call({'get_fairyland_boss_draw_data', BossId}, State) ->
    Data = lib_boss_mod:get_boss_map_data(State, BossId),
    {reply, Data, State};

do_handle_call(Msg, State) ->
    ?ERR("Boss Call No Match:~p~n", [Msg]),
    {reply, ok, State}.

do_handle_cast({'gm_feast_boss_reset', RoleId}, #boss_state{common_status_map = CommMap} = State) ->
    case maps:find(?BOSS_TYPE_FEAST, CommMap) of
        {ok, BossComm} ->
            #boss_common_status{other_map = OtherMap} = BossComm,
            OverList = maps:get(?feast_boss_over_role, OtherMap, []),
            NewOverList = lists:delete(RoleId, OverList),
            NewOtherMap = maps:put(?feast_boss_over_role, NewOverList, OtherMap),
            NewBossComm = BossComm#boss_common_status{other_map = NewOtherMap},
            NewCommMap = maps:put(?BOSS_TYPE_FEAST, NewBossComm, CommMap),
            {noreply, State#boss_state{common_status_map = NewCommMap}};
        _ ->
            {noreply, State}
    end;
do_handle_cast({'get_boss_info', RoleId, Sid, BossType, LessCount, AllCount, LessTired, AllTired, Vit, LastVitTime, LCollectTimes, AllCollectTimes}, State) when
    BossType == ?BOSS_TYPE_OUTSIDE orelse BossType == ?BOSS_TYPE_ABYSS orelse BossType == ?BOSS_TYPE_PERSONAL
        orelse BossType == ?BOSS_TYPE_FAIRYLAND orelse BossType == ?BOSS_TYPE_NEW_OUTSIDE
    ->
    lib_boss_mod:get_boss_info(State, RoleId, Sid, BossType, LessCount, AllCount, LessTired, AllTired, Vit, LastVitTime, LCollectTimes, AllCollectTimes),
    {noreply, State};
do_handle_cast({'get_boss_info', RoleId, Sid, BossType, LessCount, AllCount, LessTired, AllTired, Vit, LastVitTime, LCollectTimes, AllCollectTimes}, State) ->
    case get_boss_type_map(BossType, State) of
        null -> skip;
        BossMap ->
            Fun =
            if
                BossType == ?BOSS_TYPE_VIP_PERSONAL -> fun(BossId, _Boss, TL) -> [{BossId, 0, 0, 0, ?AUTO_REMIND} | TL] end;
                BossType == ?BOSS_TYPE_PHANTOM ->
                    fun(BossId, #boss_status{reborn_time = RebornTime, remind_list = RemindList, num = Num, optional_data = OptionalData}, TL) ->
                        case lib_boss:get_phatom_boss_type(BossType, BossId) of
                            cl_mon ->
                                case lists:keyfind({BossType, BossId}, 1, OptionalData) of
                                    {_, MonCollectTimes} -> ok; _ -> MonCollectTimes = 0
                                end,
                                [{BossId, MonCollectTimes, RebornTime, 0, ?AUTO_REMIND} | TL];
                            _ ->
                                [{BossId, Num, RebornTime, ?IF(lists:member(RoleId, RemindList), 1, 0), ?AUTO_REMIND} | TL]
                        end
                    end;
                true ->
                    fun(BossId, #boss_status{reborn_time = RebornTime, remind_list = RemindList, no_auto_remind_list = NoAutoList, num = Num}, TL) ->
                        AutoRemind = ?IF(lists:member(RoleId, NoAutoList), ?NO_AUTO_REMIND, ?AUTO_REMIND),
                        [{BossId, Num, RebornTime, ?IF(lists:member(RoleId, RemindList), 1, 0), AutoRemind} | TL]
                    end
            end,
            BossInfos = maps:fold(Fun, [], BossMap),
            %lib_server_send:send_to_sid(Sid, pt_460, 46000, [BossType, LessCount, AllCount, LessTired, AllTired, Vit, LastVitTime, BossInfos])
            lib_server_send:send_to_sid(Sid, pt_460, 46000, [BossType, AllCount, LessCount, LessTired, AllTired, Vit, LastVitTime, LCollectTimes, AllCollectTimes, BossInfos])
    end,
    {noreply, State};

do_handle_cast({'get_boss_kill_log', Sid, BossType, BossId}, State) when
    BossType == ?BOSS_TYPE_OUTSIDE orelse BossType == ?BOSS_TYPE_ABYSS orelse
        BossType == ?BOSS_TYPE_FAIRYLAND orelse BossType == ?BOSS_TYPE_NEW_OUTSIDE
    ->
    lib_boss_mod:get_boss_kill_log(State, Sid, BossType, BossId);
do_handle_cast({'get_boss_kill_log', Sid, BossType, BossId}, State) ->
    case get_boss_type_boss_info(State, BossType, BossId) of
        {false, _Code} -> KillLog = [];
        {ok, _BossMap, #boss_status{kill_log = KillLog}} -> skip
    end,
    lib_server_send:send_to_sid(Sid, pt_460, 46001, [KillLog]),
    {noreply, State};

do_handle_cast({'get_boss_drop_log', Sid}, State) ->
    #boss_state{boss_drop_log = BossDropLog} = State,
    F = fun(Log) ->
        #boss_drop_log{
            role_id = RoleId, name = RoleName, boss_type = BossType, boss_id = BossId, goods_id = GoodsId, num = Num,
            rating = Rating, equip_extra_attr = Attr, is_top = IsTop, time = Time
        } = Log,
        {Time, RoleId, RoleName, BossType, BossId, GoodsId, Num, Rating, Attr, IsTop}
        end,
    List = lists:map(F, BossDropLog),
    lib_server_send:send_to_sid(Sid, pt_460, 46002, [List]),
    {noreply, State};

%% 进入
do_handle_cast({'enter', RoleId, Lv, WeeklyCardStatus, BossType, BossId, AddAnger}, State) ->
    #boss_state{other_map = OtherMap} = State,
    NowTime = utime:unixtime(),
    if
        BossType == ?BOSS_TYPE_OUTSIDE orelse BossType == ?BOSS_TYPE_ABYSS orelse
            BossType == ?BOSS_TYPE_FAIRYLAND orelse BossType == ?BOSS_TYPE_FEAST orelse BossType == ?BOSS_TYPE_NEW_OUTSIDE ->
            {noreply, NState} = lib_boss_mod:enter(State, RoleId, BossType, BossId);
        BossType == ?BOSS_TYPE_DOMAIN ->
            lib_boss:send_domain_cl_boss(RoleId, State#boss_state.boss_domain_map),
            NState = State;
        true ->
            NState = State
    end,
    lib_boss_api:enter_event(RoleId, Lv,BossType),
    BossCfg = data_boss:get_boss_cfg(BossId),
    case BossCfg of
        #boss_cfg{scene = Scene} -> skip;
        _ ->
            Scene = 0
    end,
    NewOtherMap = maps:put({enter_time, BossType, Scene, RoleId}, NowTime, OtherMap),
    NewState = NState#boss_state{other_map = NewOtherMap},
    do_handle_cast({'active_boss_anger_add', RoleId, WeeklyCardStatus, BossType, BossId, AddAnger}, NewState);

%% 触发蛮荒禁地怒气定时器
do_handle_cast({'active_boss_anger_add', RoleId, WeeklyCardStatus, BossType, BossId, AddAnger}, State) ->
    if
        BossType == ?BOSS_TYPE_FORBIDDEN orelse BossType == ?BOSS_TYPE_TEMPLE orelse BossType == ?BOSS_TYPE_DOMAIN -> %% 怒气值
            #boss_type{module = _Module, daily_id = _DailyType} = data_boss:get_boss_type(BossType),
            %% 蛮荒boss添加进入次数
            mod_daily:increment(RoleId, ?MOD_BOSS, ?MOD_BOSS_ENTER, BossType),
            #boss_state{boss_role_anger = BossRoleAnger} = State,
            case lists:keyfind(RoleId, #boss_role_anger.role_id, BossRoleAnger) of
                false ->
                    AngerRef = erlang:send_after(?ANGER_TIME * 1000, self(), {'anger_add', RoleId, BossType, BossId}),
                    E = #boss_role_anger{role_id = RoleId, boss_type = BossType, anger = 0, anger_ref = AngerRef, add_anger = AddAnger, weekly_card_status = WeeklyCardStatus};
                #boss_role_anger{anger_ref = AngerRef} = OE ->
                    util:cancel_timer(AngerRef),
                    NewAngerRef = erlang:send_after(?ANGER_TIME * 1000, self(), {'anger_add', RoleId, BossType, BossId}),
                    E = OE#boss_role_anger{role_id = RoleId, boss_type = BossType, anger = 0, step = 0, time = 0, add_anger = AddAnger, anger_ref = NewAngerRef, weekly_card_status = WeeklyCardStatus}
            end,
            NewBossRoleAnger = lists:keystore(RoleId, #boss_role_anger.role_id, BossRoleAnger, E),
            {noreply, State#boss_state{boss_role_anger = NewBossRoleAnger}};
        true ->
            {noreply, State}
    end;

%% 蛮荒怒气值增加
do_handle_cast({'boss_anger_add', RoleId, ?BOSS_TYPE_FORBIDDEN, AddAnger}, State) ->
    #boss_state{boss_role_anger = BossRoleAngerList} = State,
    case lists:keyfind(RoleId, #boss_role_anger.role_id, BossRoleAngerList) of
        false -> NewBossRoleAngerList = BossRoleAngerList;
        #boss_role_anger{add_anger = OldAddAnger, anger_ref = OldAngerRef, boss_id = BossId, anger = Anger} = BossRoleAnger ->
%%            ?PRINT("OldAddAnger ~p AddAnger ~p ~n", [OldAddAnger, AddAnger]),
%%            ?MYLOG("zhvip", "OldAddAnger ~p AddAnger ~p ~n", [OldAddAnger, AddAnger]),
            NewAngerRef = util:send_after(OldAngerRef, ?ANGER_TIME * 1000, self(), {'anger_add', RoleId, ?BOSS_TYPE_FORBIDDEN, BossId}),
            NewBossRoleAnger = BossRoleAnger#boss_role_anger{add_anger = OldAddAnger + AddAnger, anger_ref = NewAngerRef},
            MaxAnger = calc_max_anger(NewBossRoleAnger, ?BOSS_TYPE_FORBIDDEN),
            lib_server_send:send_to_uid(RoleId, pt_460, 46005, [Anger, MaxAnger]),
            NewBossRoleAngerList = lists:keystore(RoleId, #boss_role_anger.role_id, BossRoleAngerList, NewBossRoleAnger)
    end,
    {noreply, State#boss_state{boss_role_anger = NewBossRoleAngerList}};

%% 蛮荒值减少
do_handle_cast({'boss_anger_reduce', RoleId, ?BOSS_TYPE_FORBIDDEN, ReduceAngle}, State) ->
    #boss_state{boss_role_anger = BossRoleAngerList} = State,
    case lists:keyfind(RoleId, #boss_role_anger.role_id, BossRoleAngerList) of
        false -> NewBossRoleAngerList = BossRoleAngerList;
        #boss_role_anger{add_anger = OldAddAnger, anger_ref = OldAngerRef, boss_id = BossId, anger = Anger} = BossRoleAnger ->
%%            ?PRINT("OldAddAnger ~p AddAnger ~p ~n", [OldAddAnger, AddAnger]),
%%            ?MYLOG("zhvip", "OldAddAnger ~p AddAnger ~p ~n", [OldAddAnger, AddAnger]),
            NewAddAngerTmp = OldAddAnger - ReduceAngle,
            NewAddAnger = max(0, NewAddAngerTmp),
            NewBossRoleAnger1 = BossRoleAnger#boss_role_anger{add_anger = NewAddAnger},
            MaxAnger = calc_max_anger(NewBossRoleAnger1, ?BOSS_TYPE_FORBIDDEN),
            case Anger >= MaxAnger of
                false -> NewBossRoleAnger = NewBossRoleAnger1;
                true ->
                    AngerDelayRef = util:send_after(OldAngerRef, ?ANGER_DELAY_TIME * 1000, self(), {'anger_tickout_delay', RoleId, ?BOSS_TYPE_FORBIDDEN, BossId}),
                    EndTime = utime:unixtime() + ?ANGER_DELAY_TIME,
                    lib_server_send:send_to_uid(RoleId, pt_460, 46005, [MaxAnger, MaxAnger]),
                    lib_server_send:send_to_uid(RoleId, pt_460, 46006, [?FORBIDDEN_OUT_DELAY, ?ANGER_DELAY_TIME]),
                    NewBossRoleAnger = NewBossRoleAnger1#boss_role_anger{anger = MaxAnger, step = ?FORBIDDEN_OUT_DELAY,
                        time = EndTime, anger_ref = AngerDelayRef}
            end,
            NewBossRoleAngerList = lists:keystore(RoleId, #boss_role_anger.role_id, BossRoleAngerList, NewBossRoleAnger)
    end,
    {noreply, State#boss_state{boss_role_anger = NewBossRoleAngerList}};

%% 退出
do_handle_cast({'quit', RoleId, BossType, CopyId, Scene, OldX, OldY}, State) ->
    #boss_state{boss_role_anger = BossRoleAnger, other_map = OtherMap} = State,
    NowTime = utime:unixtime(),
    StayTime = case maps:get({enter_time, BossType, Scene, RoleId}, OtherMap, false) of
                   EnterTime when is_integer(EnterTime) andalso EnterTime > 0 -> NowTime - EnterTime;
                   _ -> 0
               end,
    if
        BossType == ?BOSS_TYPE_OUTSIDE orelse BossType == ?BOSS_TYPE_ABYSS orelse BossType == ?BOSS_TYPE_FAIRYLAND
            orelse BossType == ?BOSS_TYPE_FEAST orelse BossType == ?BOSS_TYPE_NEW_OUTSIDE ->
            lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, ?HAND_OFFLINE, lib_boss, add_exit_log, [BossType, 1, Scene, OldX, OldY, StayTime]),
            {noreply, NState} = lib_boss_mod:quit(State, RoleId, BossType, CopyId);
        BossType == ?BOSS_TYPE_FORBIDDEN orelse BossType == ?BOSS_TYPE_DOMAIN ->
            #boss_state{boss_role_anger = BossRoleAnger} = State,
            case lists:keyfind(RoleId, #boss_role_anger.role_id, BossRoleAnger) of
                false ->
                    lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, ?HAND_OFFLINE, lib_boss, add_exit_log, [BossType, 1, Scene, OldX, OldY, StayTime]);
                #boss_role_anger{anger = Anger} = OE ->
                    case data_boss:get_boss_type(BossType) of
                        #boss_type{} ->
                            MaxAnger = calc_max_anger(OE, BossType),
                            if
                                Anger >= MaxAnger ->
                                    lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, ?HAND_OFFLINE, lib_boss, add_exit_log, [BossType, 2, Scene, OldX, OldY, StayTime]);
                                true ->
                                    lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, ?HAND_OFFLINE, lib_boss, add_exit_log, [BossType, 1, Scene, OldX, OldY, StayTime])
                            end;
                        _ ->
                            lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, ?HAND_OFFLINE, lib_boss, add_exit_log, [BossType, 1, Scene, OldX, OldY, StayTime])
                    end
            end,
            NState = State;
        true ->
            lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, ?HAND_OFFLINE, lib_boss, add_exit_log, [BossType, 1, Scene, OldX, OldY, StayTime]),
            NState = State
    end,
    NewOtherMap = maps:remove({enter_time, BossType, Scene, RoleId}, OtherMap),
    NewState = NState#boss_state{other_map = NewOtherMap},
    do_handle_cast({'cancel_boss_anger_add', RoleId, BossType}, NewState);

%% 取消蛮荒禁地怒气定时器
do_handle_cast({'cancel_boss_anger_add', RoleId, BossType}, State) ->
    if
        BossType == ?BOSS_TYPE_FORBIDDEN orelse BossType == ?BOSS_TYPE_TEMPLE orelse BossType == ?BOSS_TYPE_DOMAIN -> %% 怒气值
            #boss_state{boss_role_anger = BossRoleAnger} = State,
            NewBossRoleAnger
                = case lists:keyfind(RoleId, #boss_role_anger.role_id, BossRoleAnger) of
                      false -> BossRoleAnger;
                      #boss_role_anger{anger_ref = AngerRef} ->
                          util:cancel_timer(AngerRef),
                          lists:keydelete(RoleId, #boss_role_anger.role_id, BossRoleAnger)
                  end,
            {noreply, State#boss_state{boss_role_anger = NewBossRoleAnger}};
        true ->
            {noreply, State}
    end;

%% boss关注操作
do_handle_cast({'boss_remind_op', RoleId, BossType, BossId, Remind, IsAuto}, State) when
    BossType == ?BOSS_TYPE_OUTSIDE orelse BossType == ?BOSS_TYPE_ABYSS
        orelse BossType == ?BOSS_TYPE_FAIRYLAND orelse BossType == ?BOSS_TYPE_NEW_OUTSIDE
    ->
    lib_boss_mod:boss_remind_op(State, RoleId, BossType, BossId, Remind, IsAuto);
do_handle_cast({'boss_remind_op', RoleId, BossType, BossId, Remind, IsAuto}, State) ->
    case get_boss_type_boss_info(State, BossType, BossId) of
        {false, Code} ->
            lib_server_send:send_to_uid(RoleId, pt_460, 46007, [Code, BossType, BossId, Remind, IsAuto]),
            {noreply, State};
        {ok, BossMap, #boss_status{remind_list = RemindList, no_auto_remind_list = NoAutoList} = Boss} ->
            IsInRemind = lists:member(RoleId, RemindList),
            AutoRemind = ?IF(lists:member(RoleId, NoAutoList), ?NO_AUTO_REMIND, ?AUTO_REMIND),
            {Code, NewRemindList, NewNoAutoList}
                = if
                      Remind == ?REMIND andalso IsInRemind == true ->
                          {?ERRCODE(err460_no_remind), RemindList, NoAutoList};
                      Remind =/= ?REMIND andalso IsInRemind == false ->
                          {?ERRCODE(err460_no_unremind), RemindList, NoAutoList};
                      Remind == ?REMIND -> %% replace
                          SQL = <<"replace into boss_remind set role_id = ~p, boss_id = ~p, remind = ~p, auto_remind = ~p">>,
                          db:execute(io_lib:format(SQL, [RoleId, BossId, Remind, AutoRemind])),
                          {?SUCCESS, [RoleId | RemindList], lists:delete(RoleId, NoAutoList)};
                      true -> %% delete
                          SQL = <<"replace into boss_remind set role_id = ~p, boss_id = ~p, remind = ~p, auto_remind = ~p">>,
                          db:execute(io_lib:format(SQL, [RoleId, BossId, Remind, AutoRemind])),
                          {?SUCCESS, lists:delete(RoleId, RemindList), NoAutoList}
                  end,
            lib_server_send:send_to_uid(RoleId, pt_460, 46007, [Code, BossType, BossId, Remind, IsAuto]),
            NewBoss = Boss#boss_status{remind_list = NewRemindList, no_auto_remind_list = NewNoAutoList},
            NewBossMap = maps:put(BossId, NewBoss, BossMap),
            {noreply, update_boss_state(BossType, NewBossMap, State)}
    end;

%% 伤害
do_handle_cast({'be_hurted', BossType, BossId, Hp, HpLim, RoleId, Hurt}, State) ->
    lib_boss_mod:be_hurted(State, BossType, BossId, Hp, HpLim, RoleId, Hurt);

do_handle_cast({'gm_create_domain_boss', Scene}, State) ->
    case get_boss_type_map(?BOSS_TYPE_DOMAIN, State) of
        null -> {noreply, State};
        BossMap ->
            NewState = lib_boss:create_domain_special_boss(Scene, BossMap, State),
            {noreply, NewState}
    end;

%%被采集
do_handle_cast({'be_collected', ScenePoolId, ?BOSS_TYPE_FEAST, BossId, AttrId, AttrName, BLWhos, DX, DY, FirstAttr, MonArgs}, State) ->
    lib_boss_mod:be_collected(State, ScenePoolId, ?BOSS_TYPE_FEAST, BossId, AttrId, AttrName, BLWhos, DX, DY, FirstAttr, MonArgs);
%% 怪物被击杀
do_handle_cast({'boss_be_kill', ScenePoolId, BossType, BossId, AttrId, AttrName, BLWhos, DX, DY, FirstAttr, MonArgs}, State) when
    BossType == ?BOSS_TYPE_OUTSIDE orelse BossType == ?BOSS_TYPE_ABYSS orelse BossType == ?BOSS_TYPE_FEAST
        orelse BossType == ?BOSS_TYPE_FAIRYLAND; BossType == ?BOSS_TYPE_NEW_OUTSIDE ->
    case BossType of
        ?BOSS_TYPE_ABYSS -> lib_hi_point_api:hi_point_task_boss_kill(BLWhos, BossType);
        ?BOSS_TYPE_NEW_OUTSIDE -> lib_hi_point_api:hi_point_task_boss_kill(BLWhos, BossType);
        _ -> skip
    end,
    lib_contract_challenge_api:kill_boss(BLWhos, BossType),
    lib_boss_mod:boss_be_kill(State, ScenePoolId, BossType, BossId, AttrId, AttrName, BLWhos, DX, DY, FirstAttr, MonArgs);
do_handle_cast({'boss_be_kill', _ScenePoolId, BossType, BossId, AttrId, AttrName, BLWhos, DX, DY, FirstAttr, MonArgs}, State) when BossType == ?BOSS_TYPE_WORLD ->
    lib_boss_mod:world_boss_be_kill(State, BossType, BossId, AttrId, AttrName, BLWhos, DX, DY, FirstAttr, MonArgs);
%% 蛮荒boss被杀|蛮荒小怪被杀
do_handle_cast({'boss_be_kill', _ScenePoolId, BossType, BossId, AttrId, AttrName, BLWhos, _DX, _DY, _FirstAttr, MonArgs}, State) when BossType == ?BOSS_TYPE_FORBIDDEN ->
    #boss_state{boss_role_anger = BossRoleAnger, online_num_map = OnlineNumMap} = State,
    case get_boss_type_map(BossType, State) of
        null -> {noreply, State};
        BossMap ->
            case maps:get(BossId, BossMap, null) of
                null -> %% 小怪物
                    NewBossMap = BossMap;
                Boss -> %% Boss
                    lib_hi_point_api:hi_point_task_boss_kill(BLWhos, BossType),
                    lib_contract_challenge_api:kill_boss(BLWhos, BossType),
                    NewBossMap = do_boss_be_kill(OnlineNumMap, BossType, BossMap, Boss, AttrId, AttrName, BLWhos, MonArgs)
            end,
            %% 批量+怒
            NewBossRoleAnger = update_boss_anger(BossType, BossId, AttrId, BossRoleAnger, BLWhos),
            {noreply, update_boss_state(BossType, NewBossMap, State#boss_state{boss_role_anger = NewBossRoleAnger})}
    end;

%% 秘境领域 boss被杀| 小怪被杀
do_handle_cast({'boss_be_kill', _ScenePoolId, BossType, BossId, AttrId, AttrName, BLWhos, _DX, _DY, _FirstAttr, MonArgs}, State) when BossType == ?BOSS_TYPE_DOMAIN ->
    #boss_state{boss_role_anger = BossRoleAnger, online_num_map = OnlineNumMap, domain_kill = DomainKill} = State,
    case get_boss_type_map(BossType, State) of
        null -> {noreply, State};
        BossMap ->
            case maps:get(BossId, BossMap, null) of
                null -> %% 小怪物
                    NewBossMap = BossMap,
                    NewDomainKill = DomainKill;
                Boss -> %% Boss
                    case lib_boss:get_domain_boss_type(BossType, BossId) of
                        cl_mon ->  % 采集怪
                            NewBossMap =  lib_boss:do_domain_mon_be_kill(BossType, BossId, MonArgs, Boss, BossMap, AttrId, BLWhos),
                            NewDomainKill = DomainKill;
                        _ ->
                            NewBossMap =
                            case lists:member(BossId, data_boss:get_boss_by_mon_type(?DOMAIN_SPECIAL_BOSS)) of   % 1: 特殊 2 ，宝箱 3 高级宝箱
                                 true ->
                                     lib_boss:do_domain_mon_be_kill(BossType, BossId, MonArgs, Boss, BossMap, AttrId, BLWhos);
                                false ->
                                    do_boss_be_kill(OnlineNumMap, BossType, BossMap, Boss, AttrId, AttrName, BLWhos, MonArgs)
                            end,
                            % 记录玩家击杀情况
                            NewDomainKill = lib_boss:save_domain_kill(DomainKill, BLWhos)
                    end
            end,
            %% 批量+怒
            NewBossRoleAnger = update_boss_anger(BossType, BossId, AttrId, BossRoleAnger, BLWhos),
            %% 生成特殊怪随机个数
            NewState = lib_boss:create_domain_special_boss(BossType, BossId, NewBossMap, State),
            {noreply,  NewState#boss_state{boss_role_anger = NewBossRoleAnger, domain_kill = NewDomainKill}}
    end;


%% 神庙怪物被杀
do_handle_cast({'boss_be_kill', _ScenePoolId, BossType, BossId, AttrId, AttrName, BLWhos, DX, DY, _FirstAttr, MonArgs}, State) when BossType == ?BOSS_TYPE_TEMPLE ->
    #boss_state{boss_role_anger = BossRoleAnger, online_num_map = OnlineNumMap} = State,
    case get_boss_type_map(BossType, State) of
        null -> {noreply, State};
        BossMap ->
            case maps:get(BossId, BossMap, null) of
                null -> %% 小怪物|普通采集怪
                    NewBossMap = BossMap;
                Boss -> %% 固定Boss|随机Boss|精英怪|稀有采集怪
                    case lib_boss:get_temple_mon_type(BossType, BossId) of
                        fixed_boss ->
                            TmpBossMap = do_boss_be_kill(OnlineNumMap, BossType, BossMap, Boss, AttrId, AttrName, BLWhos, MonArgs),
                            lib_chat:send_TV({all}, ?MOD_BOSS, 6, [AttrName, AttrId, lib_mon:get_name_by_mon_id(BossId)]),
                            born_temple_rand_boss(BossType),
                            %% 添加疲劳值
                            spawn(mod_boss, update_boss_tired, [BossType, AttrId, BLWhos]);
                        rand_boss ->
                            TmpBossMap = do_boss_be_kill(OnlineNumMap, BossType, BossMap, Boss, AttrId, AttrName, BLWhos, MonArgs),
                            spawn(mod_boss, update_boss_tired, [BossType, AttrId, BLWhos]);
                        rare_mon ->
                            TmpBossMap = do_temple_mon_be_kill(BossType, BossMap, Boss, AttrId, AttrName, BLWhos);
                        rare_cl_mon ->
                            TmpBossMap = do_temple_mon_be_kill(BossType, BossMap, Boss, AttrId, AttrName, BLWhos)
                    end,
                    #boss_status{num = Num, xy = XYL} = NewBoss = maps:get(BossId, TmpBossMap, null),
                    NewBossMap = maps:put(BossId, NewBoss#boss_status{num = max(0, Num - 1), xy = XYL -- [{DX, DY}]}, TmpBossMap)
            end,
            %% 批量+怒
            NewBossRoleAnger = update_boss_anger(BossType, BossId, AttrId, BossRoleAnger, BLWhos),
            {noreply, update_boss_state(BossType, NewBossMap, State#boss_state{boss_role_anger = NewBossRoleAnger})}
    end;
%% 幻兽领boss被杀
do_handle_cast({'boss_be_kill', _ScenePoolId, BossType, BossId, AttrId, AttrName, BLWhos, _DX, _DY, _FirstAttr, MonArgs}, State) when BossType == ?BOSS_TYPE_PHANTOM ->
    #boss_state{online_num_map = OnlineNumMap} = State,
    case get_boss_type_boss_info(State, BossType, BossId) of
        {ok, BossMap, Boss} ->
            PhatomBossType = lib_boss:get_phatom_boss_type(BossType, BossId),
            case PhatomBossType == cl_mon of
                true -> %% 采集怪
                    NewBossMap = do_platom_cl_mon_be_kill(BossType, BossMap, Boss, AttrId, AttrName, BLWhos, MonArgs);
                _ ->
                    NewBossMap = do_boss_be_kill(OnlineNumMap, BossType, BossMap, Boss, AttrId, AttrName, BLWhos, MonArgs),
                    %?PRINT("boss_be_kill ~p~n",[NewBossMap]),
                    %% 事件触发
                    CallBackData = #callback_boss_kill{boss_type = BossType, boss_id = BossId},
                    [lib_player_event:async_dispatch(RoleId, ?EVENT_BOSS_KILL, CallBackData)||#mon_atter{id = RoleId}<-BLWhos],
                    %% 成就触发
                    lib_player:apply_cast(AttrId, ?APPLY_CAST_STATUS, lib_achievement_api, boss_achv_finish, [BossType, BossId]),
                    spawn(mod_boss, update_boss_tired, [BossType, AttrId, BLWhos])
            end,
            NewState = update_boss_state(BossType, NewBossMap, State),
            {noreply, NewState};
        _ -> {noreply, State}
    end;
do_handle_cast({'boss_be_kill', _ScenePoolId, BossType, BossId, AttrId, AttrName, BLWho, _DX, _DY, _FirstAttr, MonArgs}, State) ->
    #boss_state{online_num_map = OnlineNumMap} = State,
    case get_boss_type_boss_info(State, BossType, BossId) of
        {false, _Code} ->
            {noreply, State};
        {ok, BossMap, Boss} ->
            % %% 世界boss添加疲劳值
            % if
            %     BossType =/= ?BOSS_TYPE_WORLD -> skip;
            %     true -> spawn(mod_boss, update_boss_tired, [BossType, AttrId, BLWho])
            % end,
            mod_boss_first_blood:boss_be_killed(BossId, BLWho),
            NewBossMap = do_boss_be_kill(OnlineNumMap, BossType, BossMap, Boss, AttrId, AttrName, BLWho, MonArgs),
            {noreply, update_boss_state(BossType, NewBossMap, State)}
    end;

do_handle_cast({'boss_add_drop_log', RoleId, RoleName, _Scene, BossType, BossId, GoodsInfoL}, State) ->
    % ?MYLOG("hjh", "boss_add_drop_log BossType:~p BossId:~p ~n", [BossType, BossId]),
    NowTime = utime:unixtime(),
    #boss_state{boss_drop_log = BossDropLog} = State,
    F = fun(#boss_drop_log{is_top = IsTop}) -> IsTop == 1 end,
    {Satisfying, NotSatisfying} = lists:partition(F, BossDropLog),
    F2 = fun({GoodsId, Num, Rating, Attr}, {TmpSatisfying, TmpNotSatisfying}) ->
        Log = #boss_drop_log{
            role_id=RoleId, name=RoleName, boss_type=BossType, boss_id=BossId, goods_id=GoodsId, num=Num,
            rating=Rating, equip_extra_attr=Attr, time = NowTime
            },
        case lists:member(GoodsId, ?BOSS_TYPE_KV_LOG_GOODS_TOP_LIST(?BOSS_TYPE_GLOBAL)) of
            true -> {[Log#boss_drop_log{is_top = 1}|TmpSatisfying], TmpNotSatisfying};
            false -> {TmpSatisfying, [Log#boss_drop_log{is_top = 0}|TmpNotSatisfying]}
        end
    end,
    {NewSatisfying, NewNotSatisfying} = lists:foldl(F2, {Satisfying, NotSatisfying}, GoodsInfoL),
    LogLen = ?BOSS_TYPE_KV_LOG_GOODS_LEN(?BOSS_TYPE_GLOBAL),
    TopLogLen = ?BOSS_TYPE_KV_TOPLOG_GOODS_LEN(?BOSS_TYPE_GLOBAL),
    NewBossSatisfying = lists:sublist(NewSatisfying, TopLogLen),
    NewBossDropLog = lists:sublist(NewNotSatisfying, LogLen) ++ NewBossSatisfying,
    {noreply, State#boss_state{boss_drop_log = NewBossDropLog}};

%% 获取蛮荒禁地怒气值
do_handle_cast({'get_boss_anger', RoleId}, State) ->
    #boss_state{boss_role_anger = BossRoleAnger} = State,
    case lists:keyfind(RoleId, #boss_role_anger.role_id, BossRoleAnger) of
        false -> {noreply, State};
        #boss_role_anger{anger = Anger} = RoleBossAnger ->
            MaxAnger = calc_max_anger(RoleBossAnger),
            lib_server_send:send_to_uid(RoleId, pt_460, 46005, [Anger, MaxAnger]),
            {noreply, State}
    end;

%% 获取蛮荒禁地的倒计时
do_handle_cast({'get_boss_anger_time', RoleId}, State) ->
    #boss_state{boss_role_anger = BossRoleAnger} = State,
    case lists:keyfind(RoleId, #boss_role_anger.role_id, BossRoleAnger) of
        false -> {noreply, State};
        #boss_role_anger{step = Step, time = EndTime} ->
            if
                Step == 0 -> skip;
                true ->
                    NowTime = utime:unixtime(),
                    lib_server_send:send_to_uid(RoleId, pt_460, 46006, [Step, max(0, EndTime - NowTime)])
            end,
            {noreply, State}
    end;

%% 被杀+怒气
do_handle_cast({'forbidden_boss_bekill_add_anger', RoleId, Scene}, State) ->
    BossType = lib_boss:get_boss_type_by_scene(Scene),
    #boss_state{boss_role_anger = BossRoleAnger, other_map = OtherMap} = State,
    case lists:keyfind(RoleId, #boss_role_anger.role_id, BossRoleAnger) of
        false ->
            lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_boss, change_add_anger_out, [BossType, 0, OtherMap]),
            {noreply, State};
        #boss_role_anger{anger = Anger, anger_ref = AngerRef} = RoleBossAnger ->
            % #boss_type{max_anger = MaxAnger} = data_boss:get_boss_type(BossType),
            MaxAnger = calc_max_anger(RoleBossAnger, BossType),
            if
                Anger == MaxAnger -> {noreply, State}; %% 怒气已满等待踢出
                true ->
                    case ?BOSS_TYPE_KV_BEKILL_ANGER_ADD(BossType) of
                        AddAnger when is_integer(AddAnger) -> AddAnger;
                        _ -> AddAnger = 0
                    end,
                    NewAnger = Anger + AddAnger,
                    % ?PRINT("NewAnger, MaxAnger :~p  ~p~n" ,[NewAnger, MaxAnger]),
                    lib_server_send:send_to_uid(RoleId, pt_460, 46005, [min(NewAnger, MaxAnger), MaxAnger]),
                    if
                        NewAnger >= MaxAnger ->
                            util:cancel_timer(AngerRef),
                            AngerDelayRef = erlang:send_after(?ANGER_DELAY_TIME * 1000, self(), {'anger_tickout_delay', RoleId, BossType, 0}),
                            EndTime = utime:unixtime() + ?ANGER_DELAY_TIME,
                            E = RoleBossAnger#boss_role_anger{anger = MaxAnger, step = ?FORBIDDEN_OUT_DELAY, time = EndTime, anger_ref = AngerDelayRef},
                            NewBossRoleAnger = lists:keystore(RoleId, #boss_role_anger.role_id, BossRoleAnger, E),
                            lib_server_send:send_to_uid(RoleId, pt_460, 46006, [?FORBIDDEN_OUT_DELAY, ?ANGER_DELAY_TIME]),
                            {noreply, State#boss_state{boss_role_anger = NewBossRoleAnger}};
                        true ->
                            E = RoleBossAnger#boss_role_anger{anger = NewAnger},
                            NewBossRoleAnger = lists:keystore(RoleId, #boss_role_anger.role_id, BossRoleAnger, E),
                            {noreply, State#boss_state{boss_role_anger = NewBossRoleAnger}}
                    end
            end
    end;

do_handle_cast({'temple_mon_rand_xy', Sid, BossType, BossId}, State) ->
    case get_boss_type_boss_info(State, BossType, BossId) of
        {false, Code} ->
            lib_server_send:send_to_sid(Sid, pt_460, 46012, [Code, BossId, 0, 0]),
            {noreply, State};
        {ok, _BossMap, #boss_status{xy = XYL}} ->
            case XYL of
                [] -> lib_server_send:send_to_sid(Sid, pt_460, 46012, [?FAIL, BossId, 0, 0]);
                _ ->
                    {X, Y} = urand:list_rand(XYL),
                    lib_server_send:send_to_sid(Sid, pt_460, 46012, [?SUCCESS, BossId, X, Y])
            end,
            {noreply, State}
    end;

%% 清理日志(世界boss)
do_handle_cast({'clean_boss_log'}, State) ->
    #boss_state{boss_world_map = WorldBossMap,
        boss_home_map = HomeBossMap,
        boss_forbidden_map = ForbiddenBossMap,
        boss_domain_map = DomainBossMap,
        boss_temple_map = TempleBossMap,
        common_status_map = StatusMap} = State,
    Fun = fun(_K, Boss) -> Boss#boss_status{kill_log = []} end,
    NewWorldBossMap = maps:map(Fun, WorldBossMap),
    NewHomeBossMap = maps:map(Fun, HomeBossMap),
    NewForbiddenBossMap = maps:map(Fun, ForbiddenBossMap),
    NewDomainBossMap = maps:map(Fun, DomainBossMap),
    NewTempleBossMap = maps:map(Fun, TempleBossMap),
    Fun2 = fun(_K, #boss_common_status{boss_map = BossMap} = ComStatus) ->
        NewBossMap = maps:map(Fun, BossMap),
        ComStatus#boss_common_status{boss_map = NewBossMap}
           end,
    NewStatusMap = maps:map(Fun2, StatusMap),
    {noreply, State#boss_state{boss_drop_log = [], boss_world_map = NewWorldBossMap,
        boss_home_map = NewHomeBossMap, boss_forbidden_map = NewForbiddenBossMap,
        boss_domain_map = NewDomainBossMap,
        boss_temple_map = NewTempleBossMap,
        common_status_map = NewStatusMap}};

%% 离开boss场景处理
do_handle_cast({'logout_boss', Scene, RoleId, LogoutType, CopyId}, State) ->
    %%    ?MYLOG("cym", "logout Scene ~p ~n", [Scene]),
    NewState = case lib_boss:is_in_forbdden_boss(Scene) orelse
        lib_boss:is_in_outside_boss(Scene) orelse
        lib_boss:is_in_abyss_boss(Scene) orelse lib_boss:is_in_new_outside_boss(Scene)
        orelse lib_boss:is_in_fairy_boss(Scene)
        orelse lib_boss:is_in_feast_boss(Scene) of
                   false ->
                    %    ?MYLOG("cym", "logout~n", []),
                       State;
                   true ->
                       #boss_state{boss_role_anger = BossRoleAnger} = State,
                       State1 =
                           case lists:keyfind(RoleId, #boss_role_anger.role_id, BossRoleAnger) of
                               false ->
                                   State;
                               #boss_role_anger{anger_ref = AngerRef} ->
                                   util:cancel_timer(AngerRef),
                                   NewBossRoleAnger = lists:keydelete(RoleId, #boss_role_anger.role_id, BossRoleAnger),
                                   State#boss_state{boss_role_anger = NewBossRoleAnger}
                           end,
                       %%            ?MYLOG("cym", "logout~n", []),
                       State2 = lib_boss_mod:logout_by_boss_type(State1, RoleId, CopyId),
                       State2
               end,
    if
        LogoutType == ?NORMAL_LOGOUT ->
            skip;
        true ->
            lib_scene:player_change_scene(RoleId, 0, 0, 0, true, [{group, 0}, {change_scene_hp_lim, 1}])
    end,
    {noreply, NewState};

%% 玩家等级发生变化
do_handle_cast({'lv_up', RoleId, Lv}, State) ->
    lib_boss_mod:lv_up(State, RoleId, Lv);

%% 玩家死亡
do_handle_cast({'player_die', SceneId, AtterSign, AtterId, AtterName, AtterGuildId, AttMaskId, DieId, DerGuildId, DerName, DerMaskId, X, Y}, State) ->
    lib_boss_mod:player_die(State, SceneId, AtterSign, AtterId, AtterName, AtterGuildId, AttMaskId, DieId, DerGuildId, DerName, DerMaskId, X, Y);

%% 刷新已被杀的本服boss（个人boss、世界boss除外）
do_handle_cast({'refresh_killed_boss', RefreshType}, State) ->
    #boss_state{
        boss_world_map = OWldBoss, boss_personal_map = OPerBoss,
        boss_home_map = OHomeBoss, boss_forbidden_map = OForbBoss,
        boss_domain_map = ODomainBoss, boss_temple_map = OTplBoss,
        common_status_map = OComStatusMap} = State,
    AllBossIds = data_boss:get_all_boss_id(),
    Fun = fun(BossId, {WldBoss, PerBoss, HomeBoss, ForbBoss, TplBoss, DomBoss, ComStatusMap}) ->
        case data_boss:get_boss_cfg(BossId) of
            #boss_cfg{type = BossType} = BossCfg ->
                if
                % BossType == ?BOSS_TYPE_WORLD ->
                %     NewWldBoss = refresh_new_boss( BossId, WldBoss, BossCfg),
                %     {NewWldBoss, PerBoss, HomeBoss, ForbBoss, TplBoss, SectBoss};
                    BossType == ?BOSS_TYPE_HOME ->
                        NewHomeBoss = refresh_new_boss(BossId, HomeBoss, BossCfg),
                        {WldBoss, PerBoss, NewHomeBoss, ForbBoss, TplBoss, DomBoss, ComStatusMap};
                    BossType == ?BOSS_TYPE_FORBIDDEN ->
                        NewForbBoss = refresh_new_boss(BossId, ForbBoss, BossCfg),
                        {WldBoss, PerBoss, HomeBoss, NewForbBoss, TplBoss, DomBoss, ComStatusMap};
                    BossType == ?BOSS_TYPE_DOMAIN ->
                        NewDomBoss = refresh_new_boss(BossId, DomBoss, BossCfg),
                        {WldBoss, PerBoss, HomeBoss, ForbBoss, TplBoss, NewDomBoss, ComStatusMap};
                    BossType == ?BOSS_TYPE_TEMPLE ->
                        NewTplBoss = refresh_new_boss(BossId, TplBoss, BossCfg),
                        {WldBoss, PerBoss, HomeBoss, ForbBoss, NewTplBoss, DomBoss, ComStatusMap};
                % BossType == ?BOSS_TYPE_FAIRYLAND ->
                %     NewFairyBoss = refresh_new_boss(BossId, TplBoss, BossCfg),
                %     {WldBoss, PerBoss, HomeBoss, ForbBoss, TplBoss, NewFairyBoss};
                    true ->
                        NewComStatusMap = ?IF(RefreshType == gm, refresh_common_boss(BossId, ComStatusMap, BossCfg), ComStatusMap),
                        {WldBoss, PerBoss, HomeBoss, ForbBoss, TplBoss, DomBoss, NewComStatusMap}
                end;
            _ ->
                ?ERR("can't find boss cfg:~p~n", [BossId]),
                {WldBoss, PerBoss, HomeBoss, ForbBoss, TplBoss, DomBoss}
        end
          end,
    {NWldBoss, NPerBoss, NHomeBoss, NForbBoss, NTplBoss, NDomBoss, NComStatusMap}
        = lists:foldl(Fun, {OWldBoss, OPerBoss, OHomeBoss, OForbBoss, OTplBoss, ODomainBoss, OComStatusMap}, AllBossIds),
    {ok, Bin} = pt_460:write(46014, []),
    lib_server_send:send_to_all(Bin),
    {noreply, State#boss_state{boss_world_map = NWldBoss, boss_personal_map = NPerBoss,
        boss_home_map = NHomeBoss, boss_forbidden_map = NForbBoss,
        boss_domain_map = NDomBoss, common_status_map = NComStatusMap,
        boss_temple_map = NTplBoss}};

do_handle_cast({'gm_wldboss_init', BossType}, State) when BossType == ?BOSS_TYPE_WORLD ->
    #boss_state{boss_world_map = WldBossMap} = State,
    AllWldBossIds = lib_boss:get_all_worldboss_id(),
    Fun = fun({BossId, _}, Acc) ->
        IsWorldBossKilled = case maps:get(BossId, WldBossMap, null) of
                                #boss_status{kill_log = KillLog} ->
                                    KillLog;
                                null ->
                                    false
                            end,
        case IsWorldBossKilled of
            [{_, _, _} | _] ->
                [BossId | Acc];
            _ ->
                Acc
        end
          end,
    KilledBoss = lists:foldl(Fun, [], AllWldBossIds),
    Fun1 = fun(BossId, TemState) ->
        case get_boss_type_boss_info(TemState, BossType, BossId) of
            {false, _ErrCode} -> TemState;
            {ok, BossMap, Boss} ->
                % ?PRINT("bOSS::~p~n",[1]),
                RebornRef = erlang:send_after(1000, self(), {'boss_reborn', BossType, BossId}),
                NewBoss = Boss#boss_status{reborn_time = 1, reborn_ref = RebornRef, kill_log = []},
                NewBossMap = maps:put(BossId, NewBoss, BossMap),
                TemState#boss_state{boss_world_map = NewBossMap, world_boss_rankmap = #{}, world_boss_inspire = #{}}
        end
           end,
    NewState = lists:foldl(Fun1, State, KilledBoss),
    {noreply, NewState};

do_handle_cast({'gm_boss_init'}, State) ->
    NowTime = utime:unixtime(),
    AllBossIds = data_boss:get_all_boss_id(),
    {AllBossReminds, _DbList} = get_boss_db_info(NowTime, AllBossIds),
    Fun = fun(BossId, {WldBoss, PerBoss, HomeBoss, ForbBoss, TplBoss, DomBoss}) ->
        case data_boss:get_boss_cfg(BossId) of
            #boss_cfg{type = BossType, scene = Scene, x = X, y = Y} = BossCfg ->
                if
                    BossType == ?BOSS_TYPE_VIP_PERSONAL ->
                        Boss = #boss_status{boss_id = BossId},
                        {WldBoss, PerBoss#{BossId => Boss}, HomeBoss, ForbBoss, TplBoss, DomBoss};
                    BossType == ?BOSS_TYPE_TEMPLE ->
                        RemindInfos = [RemindInfo || [_, _BossId | _] = RemindInfo <- AllBossReminds, _BossId == BossId],
                        Boss = temple_boss_init(BossType, BossId, RemindInfos, BossCfg, NowTime, NowTime),
                        {WldBoss, PerBoss, HomeBoss, ForbBoss, TplBoss#{BossId => Boss}, DomBoss};
                    true ->
                        BReminds = [RoleId || [RoleId, _BossId, Remind, _] <- AllBossReminds, _BossId == BossId, Remind == ?REMIND],
                        NoAutoList = [RoleId || [RoleId, _BossId, _, AutoRemind] <- AllBossReminds, _BossId == BossId, AutoRemind == ?NO_AUTO_REMIND],
                        lib_scene_object:async_create_object(?BATTLE_SIGN_MON, BossId, Scene, 0, X, Y, 1, 0, 1, []),
                        Boss = #boss_status{boss_id = BossId, remind_list = BReminds, no_auto_remind_list = NoAutoList},
                        if
                            BossType == ?BOSS_TYPE_WORLD ->
                                {WldBoss#{BossId => Boss}, PerBoss, HomeBoss, ForbBoss, TplBoss, DomBoss};
                            BossType == ?BOSS_TYPE_HOME ->
                                {WldBoss, PerBoss, HomeBoss#{BossId => Boss}, ForbBoss, TplBoss, DomBoss};
                            BossType == ?BOSS_TYPE_FORBIDDEN ->
                                {WldBoss, PerBoss, HomeBoss, ForbBoss#{BossId => Boss}, TplBoss, DomBoss};
                            BossType == ?BOSS_TYPE_DOMAIN ->
                                {WldBoss, PerBoss, HomeBoss, ForbBoss, TplBoss, DomBoss#{BossId => Boss}};
                            true ->
                                {WldBoss, PerBoss, HomeBoss, ForbBoss, TplBoss, DomBoss}
                        end
                end;
            _ ->
                ?ERR("can't find boss cfg:~p~n", [BossId]),
                {WldBoss, PerBoss, HomeBoss, ForbBoss, TplBoss, DomBoss}
        end
          end,
    {NWldBoss, NPerBoss, NHomeBoss, NForbBoss, NTplBoss, NDomainMap}
        = lists:foldl(Fun, {#{}, #{}, #{}, #{}, #{}, #{}}, AllBossIds),
    {noreply, State#boss_state{boss_world_map = NWldBoss, boss_personal_map = NPerBoss,
        boss_home_map = NHomeBoss, boss_forbidden_map = NForbBoss,
        boss_domain_map = NDomainMap,
        boss_temple_map = NTplBoss}};

do_handle_cast({'gm_reinit_domain_cl_boss'}, State) ->
    #boss_state{boss_domain_map = DomainMap} = State,
    BossType = ?BOSS_TYPE_DOMAIN,
    BossIds = data_boss:get_boss_by_type(BossType),

    F = fun(BossId, AccM) ->
        case lib_boss:get_domain_boss_type(BossType, BossId) of
            cl_mon ->
                BossCfg = data_boss:get_boss_cfg(BossId),
                Boss = lib_boss:domain_boss_init(BossType, BossId, BossCfg, 0),
                AccM#{BossId => Boss};
            _ ->
                AccM
        end
    end,
    DomainMap1 = lists:foldl(F, DomainMap, BossIds),

    State1 = State#boss_state{boss_domain_map = DomainMap1},
    {noreply, State1};

do_handle_cast({'gm_fix_sp_boss'}, State) ->
    #boss_state{boss_domain_map = DomainMap} = State,
    BossType = ?BOSS_TYPE_DOMAIN,
    BossIds = data_boss:get_boss_by_type(BossType),
    F = fun(BossId, AccM) ->
        case lib_boss:get_domain_boss_type(BossType, BossId) of
            sp_boss ->
                case maps:get(BossId, AccM, null) of
                    null -> AccM;
                    Boss ->
                        #boss_cfg{scene = Scene} = data_boss:get_boss_cfg(BossId),
                        case lib_mon:get_scene_mon_by_mids(Scene, 0, 0, [BossId], [#scene_object.x, #scene_object.id]) of
                            [[0, OId]] ->
                                lib_mon:clear_scene_mon_by_ids(Scene, 0, 1, [OId]),
                                #boss_status{xy = BossXYList} = Boss,
                                [{X, Y}| _] = BossXYList,
                                lib_scene_object:async_create_object(?BATTLE_SIGN_MON, BossId, Scene, 0, X, Y, 1, 0, 1, []),
                                AccM;
                            _ ->
                                AccM
                        end
                end;
            _ -> AccM
        end end,
    DomainMap1 = lists:foldl(F, DomainMap, BossIds),

    State1 = State#boss_state{boss_domain_map = DomainMap1},
    {noreply, State1};

do_handle_cast({'gm_create_temple_mon'}, State) ->
    IdL = [1351031, 1351042],
    F = fun(BossId) ->
        case data_boss:get_boss_cfg(BossId) of
            #boss_cfg{type = ?BOSS_TYPE_TEMPLE, num = MaxNum} ->
                case get_boss_type_boss_info(State, ?BOSS_TYPE_TEMPLE, BossId) of
                    {false, _} -> skip;
                    {ok, _, #boss_status{num = Num}} ->
                        [self() ! {'boss_reborn', ?BOSS_TYPE_TEMPLE, BossId} || _ <- lists:seq(1, MaxNum - Num)]
                end;
            _ -> skip
        end
        end,
    [F(Id) || Id <- IdL],
    {noreply, State};
%%=================================================世界boss==============================================================
%% 世界boss伤害排名
do_handle_cast({'rank_damage', BossType, BossId, Pid, RoleId, Name, Hurt}, State) when BossType == ?BOSS_TYPE_WORLD ->
    #boss_state{world_boss_rankmap = RankMap} = State,
    RankList = maps:get(BossId, RankMap, []),
    NewRankList = lib_boss_mod:rank_damage(Name, Pid, RoleId, Hurt, RankList), %%伤害由小到大的列表
    NewRankmap = maps:put(BossId, NewRankList, RankMap),
    NewState = State#boss_state{world_boss_rankmap = NewRankmap},
    NewRankA = lists:reverse(NewRankList), %%伤害由大到小的列表
    NeedSendL = lists:sublist(NewRankA, 3),
    Fun1 = fun({N, _, _, H}, Acc) ->
        [{N, H} | Acc]
           end,
    NeedSendList = lists:foldl(Fun1, [], NeedSendL),
    RealSendL = lists:reverse(NeedSendList),
    % lib_player:apply_cast(Pid, ?APPLY_CAST_STATUS, ?NOT_HAND_OFFLINE, lib_boss, rank_damage,
    %     [Name, NewRankList, NeedSendL]),
    % % ?PRINT("NeedSendL:~p~n",[NeedSendL]),
    %%PerHurt:上一名玩家的伤害
    Fun = fun({N, _, _, H}, {Sum, HurtN, PerHurt, PerHurtBefore, Rank}) ->
        case N =/= Name of
            true ->
                {Sum + 1, HurtN, PerHurt, H, Rank};
            false ->
                {Sum + 1, H, PerHurtBefore, PerHurtBefore, Sum + 1}
        end
          end,
    {_Count, RHurt, PHurt, _, RealRank} = lists:foldl(Fun, {0, 0, 0, 0, 0}, NewRankA),
    Distance = max(PHurt - RHurt, 0),
    % ?PRINT(Distance == 0,"PerHurt:~p,RHurt:~p~n",[PHurt,RHurt]),
    % ?PRINT("46022   #### RealRank:~p, RHurt:~p, Name:~p, Distance:~p~n, RealSendL:~p~n",[RealRank, RHurt, Name, Distance, RealSendL]),
    lib_server_send:send_to_uid(RoleId, pt_460, 46022, [RealRank, RHurt, Name, Distance]),
    erlang:send_after(500, self(), {'send_rank', BossId, RealSendL}),
    {noreply, NewState};

%% 世界boss 鼓舞
do_handle_cast({'inspire_self', RoleId, Pid, InspireType}, State) ->
    #boss_state{world_boss_inspire = InspireMap} = State,
    case maps:get(RoleId, InspireMap, null) of
        [{?INSPIRE_TYPE1, Num1}, {?INSPIRE_TYPE2, Num2}] ->
            Num1,
            Num2;
        null ->
            Num1 = 0,
            Num2 = 0
    end,
    %?PRINT("Num1:~p, Num2:~p~n",[Num1,Num2]),
    InspireList = [{?INSPIRE_TYPE1, Num1}, {?INSPIRE_TYPE2, Num2}],
    Inspire1Max = data_boss:get_boss_type_kv(1, world_upway1_times),
    Inspire2Max = data_boss:get_boss_type_kv(1, world_upway2_times),
    NewInspList =
    case Inspire2Max =/= [] andalso Inspire1Max =/= [] of
        true ->
            case InspireType of
                ?INSPIRE_TYPE1 ->
                    if
                        Num1 + 1 =< Inspire1Max ->
                            [{?INSPIRE_TYPE1, Num1 + 1}, {?INSPIRE_TYPE2, Num2}];
                        true ->
                            lib_server_send:send_to_uid(RoleId, pt_460, 46020,
                                [?ERRCODE(err460_max_inspire), Inspire1Max - Num1, Inspire2Max - Num2]),
                            InspireList
                    end;
                _ ->
                    if
                        Num2 + 1 =< Inspire2Max ->
                            [{?INSPIRE_TYPE1, Num1}, {?INSPIRE_TYPE2, Num2 + 1}];
                        true ->
                            lib_server_send:send_to_uid(RoleId, pt_460, 46020,
                                [?ERRCODE(err460_max_inspire), Inspire1Max - Num1, Inspire2Max - Num2]),
                            InspireList
                    end
            end;
        false ->
            lib_server_send:send_to_uid(RoleId, pt_460, 46020,
                [?ERRCODE(err460_no_cfg), Inspire1Max - Num1, Inspire2Max - Num2]),
            [{?INSPIRE_TYPE1, Num1}, {?INSPIRE_TYPE2, Num2}]
    end,
    lib_player:apply_cast(Pid, ?APPLY_CAST_STATUS, ?NOT_HAND_OFFLINE, lib_boss, do_inspire_self,
        [?INSPIRE_SKILL_ID, InspireType, NewInspList, InspireList]),
    %?PRINT("NewInspList:~p~n",[NewInspList]),
    % NewInspireMap = maps:put(RoleId, NewInspList, InspireMap),
    % NewState = State#boss_state{world_boss_inspire = NewInspireMap},
    {noreply, State};

do_handle_cast({'setup_inspire_count', RoleId, InspireList}, State) ->
    #boss_state{world_boss_inspire = InspireMap} = State,
    %?PRINT("InspireList:~p~n",[InspireList]),
    NewInspireMap = maps:put(RoleId, InspireList, InspireMap),
    NewState = State#boss_state{world_boss_inspire = NewInspireMap},
    {noreply, NewState};

do_handle_cast({'get_inspire_count', RoleId}, State) ->
    #boss_state{world_boss_inspire = InspireMap} = State,
    Inspire1Max = data_boss:get_boss_type_kv(1, world_upway1_times),
    Inspire2Max = data_boss:get_boss_type_kv(1, world_upway2_times),
    case maps:get(RoleId, InspireMap, null) of
        [{?INSPIRE_TYPE1, Num1}, {?INSPIRE_TYPE2, Num2}] -> skip;
        null ->
            Num1 = 0,
            Num2 = 0
    end,
    % ?PRINT("46020  Num2:~p,Num1:~p~n",[Num2, Num1]),
    lib_server_send:send_to_uid(RoleId, pt_460, 46020, [1, Inspire1Max - Num1, Inspire2Max - Num2]),
    {noreply, State};

do_handle_cast({'add_inspire_buff', RoleId, Pid, Scene}, State) ->
    #boss_state{world_boss_inspire = InspireMap, other_map = OtherMap} = State,
    NowTime = utime:unixtime(),
    NewOtherMap = maps:put({enter_time, ?BOSS_TYPE_WORLD, Scene, RoleId}, NowTime, OtherMap),
    case maps:get(RoleId, InspireMap, null) of
        [{?INSPIRE_TYPE1, Num1}, {?INSPIRE_TYPE2, Num2}] -> skip;
        null ->
            Num1 = 0,
            Num2 = 0
    end,
    lib_player:apply_cast(Pid, ?APPLY_CAST_STATUS, ?NOT_HAND_OFFLINE, lib_boss, do_inspire_reconnect,
        [?INSPIRE_SKILL_ID, Num1 + Num2]),
    {noreply, State#boss_state{other_map = NewOtherMap}};

do_handle_cast({'refresh_boss_use_goods', BossType, BossId}, State) ->
    NowTime = utime:unixtime(),
    case mod_boss:get_boss_type_boss_info(BossType, BossId) of
        {false, _Code} ->
            NewState = State;
        {ok, BossMap, Boss} ->
            #boss_status{boss_id = BossId, remind_ref = RemindRef, reborn_ref = RebornRef} = Boss,
            util:cancel_timer(RemindRef),
            util:cancel_timer(RebornRef),
            RebornEndTime = NowTime + 1,
            NRemindRef = undefined,
            % NRemindRef = ?IF(RemindTime =< 0, undefined,
            %     erlang:send_after(RemindTime * 1000, self(), {'boss_remind', BossType, BossId})),
            NRebornRef = erlang:send_after(1000, self(), {'boss_reborn', BossType, BossId}),
            NewBoss = Boss#boss_status{reborn_time = RebornEndTime, remind_ref = NRemindRef, reborn_ref = NRebornRef},
            NewBossMap = maps:put(BossId, NewBoss, BossMap),
            NewState = update_boss_state(BossType, NewBossMap, State)
    end,
    {noreply, NewState};

do_handle_cast({'refresh_boss', BossType}, State) ->
    NowTime = utime:unixtime(),
    BossIds = data_boss:get_boss_by_type(BossType),
    F = fun(BossId, TemState) ->
        Result =
            case get_boss_type_map(BossType, TemState) of
                null ->
                    lib_boss_mod:get_status_map_info(TemState, BossType, BossId);
                BossMap1 ->
                    case maps:get(BossId, BossMap1, null) of
                        null -> false;
                        Boss1 ->
                            {ok, special, special, BossMap1, Boss1}
                    end
            end,

        case Result of
            {ok, ComStatusMap, ComStatus, BossMap, Boss} ->
                #boss_status{reborn_ref = RebornRef, remind_ref = RemindRef, remind_list = RemindList} = Boss,
                #boss_cfg{scene = Scene, x = X, y = Y} = data_boss:get_boss_cfg(BossId),
                PhatomBossType = lib_boss:get_domain_boss_type(BossType, BossId),
                case BossType =/= ?BOSS_TYPE_DOMAIN orelse PhatomBossType == boss of
                    true ->
                        util:cancel_timer(RemindRef),
                        util:cancel_timer(RebornRef),
                        lib_mon:clear_scene_mon_by_mids(Scene, 0, 0, 1, [BossId]),
                        %% 再重新创建
                        spawn(fun() -> lib_boss_mod:send_boss_reborn_msg(RemindList, BossType, BossId) end),
                        if
                            BossType == ?BOSS_TYPE_FAIRYLAND ->
                                Data = #fairyland_boss_data{times = 0, role_id = 0, time = 0},
                                NewOtherMap = maps:put(fairyland_boss, Data, Boss#boss_status.other_map);
                            true ->
                                NewOtherMap = Boss#boss_status.other_map
                        end,
                        %% 广播刷新信息
                        {ok, BinData2} = pt_460:write(46042, [BossType, BossId]),
                        lib_server_send:send_to_all(BinData2),
                        lib_scene_object:async_create_object(?BATTLE_SIGN_MON, BossId, Scene, 0, X, Y, 1, 0, 1, []),
                        NewBoss = Boss#boss_status{reborn_time = NowTime, reborn_ref = undefined, remind_ref =undefined, other_map = NewOtherMap},
                        case ComStatusMap of
                            special ->
                                NewBossMap = maps:put(BossId, NewBoss, BossMap),
                                NewState = update_boss_state(BossType, NewBossMap, State);
                            _ ->
                                NewState = lib_boss_mod:update_status_map(TemState, ComStatusMap, ComStatus, BossMap, NewBoss)
                        end,
                        NewState;
                    _ ->
                        TemState
                end;
            _ ->
                TemState
        end
    end,
    RealState = lists:foldl(F, State, BossIds),
    {noreply, RealState};
% do_handle_cast({'set_drop_reward', RoleId, RewardType, RewardList}, State) ->
%     NewState = lib_boss_mod:set_drop_reward(RoleId, RewardType, RewardList, State),
%     {noreply, NewState};
% do_handle_cast({'set_other_drop_reward', RoleId, RewardType, RewardList}, State) ->
%     NewState = lib_boss_mod:set_other_drop_reward(RoleId, RewardType, RewardList, State),
%     {noreply, NewState};
do_handle_cast({'set_reward', RoleId, SourceReward}, State) ->
    NewState = lib_boss_mod:set_reward(State, RoleId, SourceReward),
    {noreply, NewState};

do_handle_cast({'feast_boss_act_start'}, State) ->
    NewState = lib_boss_mod:feast_boss_act_start(State),
    {noreply, NewState};
do_handle_cast({'feast_boss_act_end'}, State) ->
    NewState = lib_boss_mod:feast_boss_act_end(State),
    {noreply, NewState};

do_handle_cast({'add_rob_count', BossType, BossId, RoleId}, State) ->
    NewState = lib_boss_mod:add_rob_count(State, BossType, BossId, RoleId),
    {noreply, NewState};

do_handle_cast({'add_robbed_count', BossType, BossId, RoleId}, State) ->
    NewState = lib_boss_mod:add_robbed_count(State, BossType, BossId, RoleId),
    {noreply, NewState};

do_handle_cast({'fairyland_boss_draw', BossId, Times, RoleId}, State) ->
    NewState = lib_boss_mod:draw(State, BossId, Times, RoleId),
    {noreply, NewState};

do_handle_cast({'fairyland_boss_draw_data', BossId, ToRoleId}, State) ->
    lib_boss_mod:draw_data(State, BossId, ToRoleId),
    {noreply, State};

do_handle_cast({'online_num_map_update', OnlineNumMap}, State) ->
    {noreply, State#boss_state{online_num_map = OnlineNumMap}};


%% 刷新已被杀的本服boss（个人boss、世界boss除外）
do_handle_cast({'refresh_killed_forb_boss'}, State) ->
    BossType = ?BOSS_TYPE_FORBIDDEN,
    #boss_state{boss_forbidden_map = OForbBoss} = State,
    % 获取场景列表
    SceneList =
        case data_boss:get_boss_type_scene(BossType) of
            List when is_list(List) -> List;
            _ -> []
        end,

    Fun = fun(Scene, Acc) ->
        case data_boss:get_boss_by_scene(BossType, Scene) of
            [{_BossId, _Layer} | _] = T ->
                BossTmp = [BossIdTmp || {BossIdTmp, _LayerTmp} <- T],
                BossTmp ++ Acc;
            _ -> Acc
        end
          end,
    AllBossIds = lists:foldl(Fun, [], SceneList),
    % ?PRINT("refresh_killed_boss_type  AllBossIds :~p~n",[AllBossIds]),
    Fun1 =
        fun(BossId, ForbBoss) ->
            case data_boss:get_boss_cfg(BossId) of
                #boss_cfg{type = BossType} = BossCfg ->
                    NewForbBoss = refresh_new_boss(BossId, ForbBoss, BossCfg),
                    NewForbBoss;
                _ ->
                    ?ERR("can't find boss cfg:~p~n", [BossId]),
                    ForbBoss
            end
        end,
    NForbBoss = lists:foldl(Fun1, OForbBoss, AllBossIds),
    {ok, Bin} = pt_460:write(46014, []),
    lib_server_send:send_to_all(Bin),
    {noreply, State#boss_state{boss_forbidden_map = NForbBoss}};


%% 刷新已被杀的本服boss（个人boss、世界boss除外）
do_handle_cast({'refresh_killed_domain_boss'}, State) ->
    BossType = ?BOSS_TYPE_DOMAIN,
    #boss_state{boss_domain_map = OForbBoss} = State,
    % 获取场景列表
    SceneList =
        case data_boss:get_boss_type_scene(BossType) of
            List when is_list(List) -> List;
            _ -> []
        end,

    Fun = fun(Scene, Acc) ->
        case data_boss:get_boss_by_scene(BossType, Scene) of
            [{_BossId, _Layer} | _] = T ->
                BossTmp = [BossIdTmp || {BossIdTmp, _LayerTmp} <- T],
                BossTmp ++ Acc;
            _ -> Acc
        end
          end,
    AllBossIds = lists:foldl(Fun, [], SceneList),
    Fun1 =
        fun(BossId, ForbBoss) ->
            case data_boss:get_boss_cfg(BossId) of
                #boss_cfg{type = BossType} = BossCfg ->
                    NewForbBoss = refresh_new_boss(BossId, ForbBoss, BossCfg),
                    NewForbBoss;
                _ ->
                    ?ERR("can't find boss cfg:~p~n", [BossId]),
                    ForbBoss
            end
        end,
    NForbBoss = lists:foldl(Fun1, OForbBoss, AllBossIds),
    {ok, Bin} = pt_460:write(46014, []),
    lib_server_send:send_to_all(Bin),
    {noreply, State#boss_state{boss_domain_map = NForbBoss}};


%% 获取秘境领域阶段奖励状态
do_handle_cast({'get_domain_boss_reward', Sid, RoleId}, State) ->
    #boss_state{domain_kill = DomainKill} = State,
    {KillNum, GetList} =
        case lists:keyfind(RoleId, #domain_boss_kill.role_id, DomainKill) of
            #domain_boss_kill{kill_num = KillNumTmp, get_list = GetListTmp} ->
                {KillNumTmp, GetListTmp};
            _ ->
                {0, []}
    end,
    lib_server_send:send_to_sid(Sid, pt_460, 46037, [KillNum, GetList]),
    {noreply, State};

%% 获取秘境领域阶段奖励状态
%% TODO:需要放在玩家身上。减少不必要的存储
do_handle_cast({'take_domain_boss_reward', Sid, RoleId, RoleLv, RewardId}, State) ->
    #boss_state{domain_kill = DomainKill} = State,
    #domain_kill_reward_cfg{stage = Stage, kill_boss_num = KillBossNum, limit_down = LimitDown, limit_up = LimitUp, reward_list = RewardList} =
        data_domain:get_domain_kill_reward(RewardId),
    {ErrCode, NewState} =
    case RoleLv >= LimitDown andalso RoleLv =< LimitUp of
        true ->
            case lists:keyfind(RoleId, #domain_boss_kill.role_id, DomainKill) of
                #domain_boss_kill{kill_num = KillNumTmp, get_list = GetListTmp} = DomainBossKill ->
                    case KillNumTmp >= KillBossNum of
                        true ->
                            case lists:member(Stage, GetListTmp) of
                                true ->  % 已经领取阶段奖励
                                    {?ERRCODE(err460_domain_had_reward), State};
                                false ->
                                    lib_goods_api:send_reward_by_id(RewardList, boss_domain, RoleId),
                                    NewGetListTmp = [Stage | GetListTmp],
                                    NewDomainBossKill = DomainBossKill#domain_boss_kill{get_list = NewGetListTmp},
                                    NewDomainKill = lists:keystore(RoleId, #domain_boss_kill.role_id, DomainKill, NewDomainBossKill),
                                    lib_boss_mod:db_role_domain_boss_kill_replace(NewDomainBossKill),
                                    {?SUCCESS, State#boss_state{domain_kill = NewDomainKill}}
                            end;
                        false -> {?ERRCODE(err460_domain_no_kill_num), State}
                    end;
                _ -> {?FAIL, State}
            end;
        false -> {?ERRCODE(err460_domain_no_lv), State}
    end,
    lib_server_send:send_to_sid(Sid, pt_460, 46038, [RewardId, ErrCode]),
    {noreply, NewState};

%% 4点清除
do_handle_cast({'domain_mail_reward'}, State) ->
    lib_boss:domain_mail_reward(State),
    NewState = State#boss_state{domain_kill = []},
    lib_boss_mod:db_role_domain_boss_kill_truncate(),
    {noreply, NewState};


%%  发送采集boss信息
do_handle_cast({'send_domain_cl_boss', RoleId}, State) ->
    lib_boss:send_domain_cl_boss(RoleId, State#boss_state.boss_domain_map),
    {noreply, State};

%% 消耗复活
do_handle_cast({'cost_reborn', RoleId, BossType, BossId}, State) ->
    lib_boss_mod:cost_reborn(State, RoleId, BossType, BossId);

%% 秘籍：清除玩家不能自动关注状态(boss之家)
do_handle_cast({'gm_clear_no_auto_remind_state', RoleId}, State) ->
    #boss_state{common_status_map = CommonMap} = State,
    CommonStatus = maps:get(?BOSS_TYPE_ABYSS, CommonMap, #boss_common_status{}),
    #boss_common_status{boss_map = BossMap} = CommonStatus,
    F = fun(BossId, BossStatus, AccM) ->
        #boss_status{no_auto_remind_list = NoAutoList} = BossStatus,
        NBossStatus = BossStatus#boss_status{no_auto_remind_list = lists:delete(RoleId, NoAutoList)},
        maps:put(BossId, NBossStatus, AccM)
    end,
    NBossMap = maps:fold(F, BossMap, BossMap),
    NCommonStatus = CommonStatus#boss_common_status{boss_map = NBossMap},
    NCommonMap = maps:put(?BOSS_TYPE_ABYSS, NCommonStatus, CommonMap),
    NState = State#boss_state{common_status_map = NCommonMap},
    {noreply, NState};

do_handle_cast(Msg, State) ->
    ?ERR("Boss Cast No Match:~p~n", [Msg]),
    {noreply, State}.

%% info
do_handle_info('boss_init', State) ->
    NowTime = utime:unixtime(),
    TempleTvRef = erlang:send_after(lib_boss:get_temple_boss_next_time(NowTime) * 1000, self(), {'temple_tv'}),
    AllBossIds = data_boss:get_all_boss_id(),
    {AllBossReminds, DbList} = get_boss_db_info(NowTime, AllBossIds),
    Fun = fun({BossId, RebornTime, OptionalData}, {PlatomMap, WldBoss, PerBoss, HomeBoss, ForbBoss, TplBoss, StatusMap, DomainMap}) ->
        case data_boss:get_boss_cfg(BossId) of
            #boss_cfg{type = BossType, scene = Scene, x = X, y = Y} = BossCfg ->
                if
                    BossType == ?BOSS_TYPE_SANCTUARY ->
                        {PlatomMap, WldBoss, PerBoss, HomeBoss, ForbBoss, TplBoss, StatusMap, DomainMap};
                    BossType == ?BOSS_TYPE_SPECIAL; BossType == ?BOSS_TYPE_PHANTOM_PER ->
                        {PlatomMap, WldBoss, PerBoss, HomeBoss, ForbBoss, TplBoss, StatusMap, DomainMap};
                    BossType == ?BOSS_TYPE_VIP_PERSONAL ->
                        Boss = #boss_status{boss_id = BossId},
                        {PlatomMap, WldBoss, PerBoss#{BossId => Boss}, HomeBoss, ForbBoss, TplBoss, StatusMap, DomainMap};
                    BossType == ?BOSS_TYPE_TEMPLE ->
                        RemindInfos = [RemindInfo || [_, _BossId | _] = RemindInfo <- AllBossReminds, _BossId == BossId],
                        Boss = temple_boss_init(BossType, BossId, RemindInfos, BossCfg, NowTime, RebornTime),
                        {PlatomMap, WldBoss, PerBoss, HomeBoss, ForbBoss, TplBoss#{BossId => Boss}, StatusMap, DomainMap};
                    BossType == ?BOSS_TYPE_PERSONAL ->
                        Boss = #boss_status{boss_id = BossId},
                        NStatusMap = lib_boss_mod:add_boss(StatusMap, BossType, Boss),
                        {PlatomMap, WldBoss, PerBoss, HomeBoss, ForbBoss, TplBoss, NStatusMap, DomainMap};
                    BossType == ?BOSS_TYPE_WORLD; BossType == ?BOSS_TYPE_WORLD_PER ->
                        % %% 暂时屏蔽功能
                        % Boss = lib_boss_mod:wldboss_init(BossType, BossId, NowTime),
                        % {PlatomMap, WldBoss#{BossId => Boss}, PerBoss, HomeBoss, ForbBoss, TplBoss, StatusMap};
                        {PlatomMap, WldBoss, PerBoss, HomeBoss, ForbBoss, TplBoss, StatusMap, DomainMap};
                    BossType == ?BOSS_TYPE_PHANTOM ->
                        BReminds = [RoleId || [RoleId, _BossId, Remind, _] <- AllBossReminds, _BossId == BossId, Remind == ?REMIND],
                        NoAutoList = [RoleId || [RoleId, _BossId, _, AutoRemind] <- AllBossReminds, _BossId == BossId, AutoRemind == ?NO_AUTO_REMIND],
                        Boss = lib_boss_mod:phantom_boss_init(BossCfg, RebornTime, OptionalData, NowTime),
                        {PlatomMap#{BossId => Boss#boss_status{remind_list = BReminds, no_auto_remind_list = NoAutoList}}, WldBoss, PerBoss, HomeBoss, ForbBoss, TplBoss, StatusMap, DomainMap};
                    BossType == ?BOSS_TYPE_FEAST ->
                        NewStatusMap = lib_boss_mod:feast_boss_init(StatusMap),
                        {PlatomMap, WldBoss, PerBoss, HomeBoss, ForbBoss, TplBoss, NewStatusMap, DomainMap};
                    BossType == ?BOSS_TYPE_DOMAIN ->
                        %% 屏蔽本服模式
                        %% Boss = lib_boss:domain_boss_init(BossType, BossId, BossCfg, 0),
                        {PlatomMap, WldBoss, PerBoss, HomeBoss, ForbBoss, TplBoss, StatusMap, DomainMap};
                    true ->
                        BReminds = [RoleId || [RoleId, _BossId, Remind, _] <- AllBossReminds, _BossId == BossId, Remind == ?REMIND],
                        NoAutoList = [RoleId || [RoleId, _BossId, _, AutoRemind] <- AllBossReminds, _BossId == BossId, AutoRemind == ?NO_AUTO_REMIND],
                        RebornSpanTime = max(0, RebornTime - NowTime),
                        if
                            BossType == ?BOSS_TYPE_OUTSIDE orelse BossType == ?BOSS_TYPE_ABYSS orelse
                                BossType == ?BOSS_TYPE_FAIRYLAND; BossType == ?BOSS_TYPE_NEW_OUTSIDE ->
                                lib_scene_object:async_create_object(?BATTLE_SIGN_MON, BossId, Scene, 0, X, Y, 1, 0, 1, []),
                                case data_mon:get(BossId) of
                                    #mon{hp_lim = HpLim} ->
                                        Hp = HpLim;
                                    _ ->
                                        Hp = 100, HpLim = 100
                                end,
                                if
                                    BossType == ?BOSS_TYPE_FAIRYLAND ->
                                        NewOtherMap = lib_boss_mod:update_boss_map_data(BossId, #{});
                                    true ->
                                        NewOtherMap = #{}
                                end,
                                Boss = #boss_status{boss_id = BossId, remind_list = BReminds, no_auto_remind_list = NoAutoList, hp = Hp, hp_lim = HpLim, other_map = NewOtherMap};
                            RebornSpanTime > 0 ->
                                RemindTime = max(0, RebornSpanTime - ?REMIND_TIME),
                                RemindRef = ?IF(RemindTime =< 0, undefined,
                                    erlang:send_after(RemindTime * 1000, self(), {'boss_remind', BossType, BossId})),
                                RebornRef = erlang:send_after(RebornSpanTime * 1000, self(),
                                    {'boss_reborn', BossType, BossId}),
                                Boss = #boss_status{boss_id = BossId, remind_list = BReminds, no_auto_remind_list = NoAutoList,
                                    reborn_time = RebornTime,
                                    remind_ref = RemindRef, reborn_ref = RebornRef};
                            true ->
                                lib_scene_object:async_create_object(?BATTLE_SIGN_MON, BossId, Scene, 0, X, Y, 1, 0, 1, []),
                                Boss = #boss_status{boss_id = BossId, remind_list = BReminds, no_auto_remind_list = NoAutoList}
                        end,
                        if
                        % BossType == ?BOSS_TYPE_WORLD ->
                        %     {WldBoss#{BossId => Boss}, PerBoss, HomeBoss, ForbBoss, TplBoss, StatusMap};
                        % BossType == ?BOSS_TYPE_FAIRYLAND ->
                        %     NStatusMap = lib_boss_mod:add_boss(StatusMap, BossType, Boss),
                        %     {WldBoss, PerBoss, HomeBoss, ForbBoss, TplBoss, FairyBoss#{BossId => Boss}, NStatusMap};
                            BossType == ?BOSS_TYPE_HOME ->
                                {PlatomMap, WldBoss, PerBoss, HomeBoss#{BossId => Boss}, ForbBoss, TplBoss, StatusMap, DomainMap};
                            BossType == ?BOSS_TYPE_FORBIDDEN ->
                                {PlatomMap, WldBoss, PerBoss, HomeBoss, ForbBoss#{BossId => Boss}, TplBoss, StatusMap, DomainMap};
                            BossType == ?BOSS_TYPE_OUTSIDE orelse BossType == ?BOSS_TYPE_ABYSS orelse
                                BossType == ?BOSS_TYPE_FAIRYLAND; BossType == ?BOSS_TYPE_NEW_OUTSIDE ->
                                NStatusMap = lib_boss_mod:add_boss(StatusMap, BossType, Boss),
                                {PlatomMap, WldBoss, PerBoss, HomeBoss, ForbBoss, TplBoss, NStatusMap, DomainMap};
                            true ->
                                {PlatomMap, WldBoss, PerBoss, HomeBoss, ForbBoss, TplBoss, StatusMap, DomainMap}
                        end
                end;
            _ ->
                ?ERR("can't find boss cfg:~p~n", [BossId]),
                {PlatomMap, WldBoss, PerBoss, HomeBoss, ForbBoss, TplBoss, StatusMap, DomainMap}
        end
          end,
    {NPlatomMap, NWldBoss, NPerBoss, NHomeBoss, NForbBoss, NTplBoss, NStatusMap, NDomainMap} = lists:foldl(Fun, {#{}, #{}, #{}, #{}, #{}, #{}, #{}, #{}}, DbList),
    DomainKill = lib_boss_mod:load_domain_kill(),
    NewState = State#boss_state{boss_world_map = NWldBoss, boss_personal_map = NPerBoss,
        boss_home_map = NHomeBoss, boss_forbidden_map = NForbBoss,
        boss_domain_map = NDomainMap,
        boss_temple_map = NTplBoss, boss_phantom_map = NPlatomMap,
        common_status_map = NStatusMap, temple_tv_ref = TempleTvRef,
        domain_kill = DomainKill},
    %?PRINT("boss init ~p~n",[NPlatomMap]),
    NewState2 = lib_boss_mod:append_init(NewState),
    {noreply, NewState2};

%% 广播提醒
do_handle_info({'boss_remind', BossType, BossId}, State) when
    BossType == ?BOSS_TYPE_OUTSIDE orelse BossType == ?BOSS_TYPE_ABYSS orelse
        BossType == ?BOSS_TYPE_FAIRYLAND orelse BossType == ?BOSS_TYPE_NEW_OUTSIDE
    ->
    lib_boss_mod:boss_remind(State, BossType, BossId);
do_handle_info({'boss_remind', BossType, BossId}, State) ->
    BossMap = get_boss_type_map(BossType, State),
    case maps:get(BossId, BossMap, null) of
        #boss_status{remind_list = RemindList, remind_ref = RemindRef} = BR ->
            util:cancel_timer(RemindRef),
            spawn(fun() -> send_remind_msg_role(RemindList, BossType, BossId) end),
            NewBossMap = maps:put(BossId, BR#boss_status{remind_ref = undefined}, BossMap),
            {noreply, update_boss_state(BossType, NewBossMap, State)};
        _ ->
            {noreply, State}
    end;

do_handle_info({'timeout', BossType, BossId}, State) -> %% 活动日历 ,世界boss超时结算
    case mod_boss:get_boss_type_boss_info(State, BossType, BossId) of
        {false, _Code} ->
            {noreply, State};
        {ok, BossMap, Boss} ->
            lib_activitycalen_api:success_end_activity(?MOD_BOSS, ?BOSS_TYPE_WORLD),
            case data_boss:get_boss_cfg(BossId) of
                #boss_cfg{scene = SceneId} ->
                    mod_scene_agent:apply_cast(SceneId, 0, lib_boss, clear_scene_palyer, [BossType]),
                    #boss_status{boss_id = BossId, remind_ref = RemindRef, reborn_ref = RebornRef, timeout_ref = TimeOutRef} = Boss,
                    util:cancel_timer(RemindRef),
                    util:cancel_timer(RebornRef),
                    util:cancel_timer(TimeOutRef),
                    %% 计算重生时间和提醒时间
                    NowTime = utime:unixtime(),
                    {_, NextBornTime} = lib_boss:get_wldboss_borntime(NowTime),
                    NRebornRef = erlang:send_after(NextBornTime * 1000, self(), {'boss_reborn', BossType, BossId}),
                    NRemindRef = undefined, NTimeOutRef = undefined,
                    NewBoss = Boss#boss_status{reborn_time = NextBornTime, remind_ref = NRemindRef, reborn_ref = NRebornRef, timeout_ref = NTimeOutRef},
                    NewBossMap = maps:update(BossId, NewBoss, BossMap),
                    NewState = State#boss_state{world_boss_rankmap = #{}, world_boss_inspire = #{}},
                    {noreply, mod_boss:update_boss_state(BossType, NewBossMap, NewState)};
                _ ->
                    ?ERR("world_boss_cfg_not_exit, BossId:~p~n", [BossId]),
                    {noreply, State}
            end
    end;


%% boss重生
do_handle_info({'boss_reborn', ?BOSS_TYPE_FEAST, BossId, CopyId}, State) ->
    lib_boss_mod:boss_reborn(State, ?BOSS_TYPE_FEAST, BossId, CopyId);
do_handle_info({'boss_reborn', BossType, BossId}, State) when
    BossType == ?BOSS_TYPE_OUTSIDE orelse BossType == ?BOSS_TYPE_ABYSS
        orelse BossType == ?BOSS_TYPE_FAIRYLAND; BossType == ?BOSS_TYPE_NEW_OUTSIDE ->
    lib_boss_mod:boss_reborn(State, BossType, BossId);
do_handle_info({'boss_reborn', BossType, BossId}, State) when BossType == ?BOSS_TYPE_TEMPLE ->
    BossMap = get_boss_type_map(BossType, State),
    case maps:get(BossId, BossMap, null) of
        #boss_status{reborn_ref = _RebornRef, num = Num, xy = XYL} = BR ->
            %util:cancel_timer(RebornRef),
            case data_boss:get_boss_cfg(BossId) of
                #boss_cfg{type = BossType, scene = Scene, x = X, y = Y, rand_xy = RandXYList, num = MaxNum} ->
                    %lib_chat:send_TV({all}, ?MOD_BOSS, 2, [MonName, SceneName, Scene, X, Y, BossType]),
                    case lib_boss:get_temple_mon_type(BossType, BossId) of
                        fixed_boss ->
                            NewNum = Num + 1, NewXYL = XYL,
                            lib_scene_object:async_create_object(?BATTLE_SIGN_MON, BossId, Scene, 0, X, Y, 1, 0, 1, []);
                        rand_boss -> % 随机boss
                            {NewXYL, NewNum} = lib_boss:temple_create_rand_mon(rand_boss, BossId, Scene, XYL, RandXYList -- XYL, Num, MaxNum);
                        rare_mon -> %% 神庙精英怪处理
                            {NewXYL, NewNum} = lib_boss:temple_create_rand_mon(rare_mon, BossId, Scene, XYL, RandXYList, Num, MaxNum);
                        rare_cl_mon -> %% 稀有采集怪
                            {NewXYL, NewNum} = lib_boss:temple_create_rand_mon(rare_cl_mon, BossId, Scene, XYL, RandXYList -- XYL, Num, MaxNum)
                    end,
                    %% 广播刷新信息
                    {ok, Bin} = pt_460:write(46013, [BossType, BossId, NewNum]),
                    lib_server_send:send_to_scene(Scene, 0, 0, Bin);
                _ -> NewNum = Num, NewXYL = XYL
            end,
            NewBossMap = maps:put(BossId, BR#boss_status{num = NewNum, xy = NewXYL}, BossMap),
            {noreply, update_boss_state(BossType, NewBossMap, State)};
        _ ->
            {noreply, State}
    end;
do_handle_info({'boss_reborn', BossType, BossId}, State) when BossType == ?BOSS_TYPE_WORLD ->
    NowTime = utime:unixtime(),
    BossMap = get_boss_type_map(BossType, State),
    case maps:get(BossId, BossMap, null) of
        #boss_status{reborn_ref = RebornRef} = BR ->
            util:cancel_timer(RebornRef),
            case data_boss:get_boss_cfg(BossId) of
                #boss_cfg{condition = ConditionList, type = BossType, scene = Scene, x = X, y = Y} ->
                    %% 先清怪物
                    lib_mon:clear_scene_mon_by_mids(Scene, 0, 0, 1, [BossId]),
                    %% 再重新创建
                    MonName = lib_mon:get_name_by_mon_id(BossId),
                    SceneName = lib_scene:get_scene_name(Scene),
                    %% 活动日历
                    lib_activitycalen_api:success_start_activity(?MOD_BOSS, ?BOSS_TYPE_WORLD),
                    {_, EndTime} = lib_boss:get_wldboss_endtime(NowTime),
                    TimeOutRef = erlang:send_after(EndTime * 1000, self(), {'timeout', BossType, BossId}),
                    case lists:keyfind(turn, 1, ConditionList) of
                        {turn, MinTurn, MaxTurn} ->
                            lib_chat:send_TV({all_turn, MinTurn, MaxTurn}, ?MOD_BOSS, 2, [MonName, SceneName, Scene, X, Y, BossType]);
                        _ ->
                            ?ERR("world_boss_cfg_condition_not_exit, BossId:~p~n", [BossId])
                    end,
                    lib_scene_object:async_create_object(?BATTLE_SIGN_MON, BossId, Scene, 0, X, Y, 1, 0, 1, []);
                _ ->
                    TimeOutRef = undefined
            end,
            NewBossMap = maps:put(BossId, BR#boss_status{reborn_ref = undefined, reborn_time = 0, timeout_ref = TimeOutRef, kill_log = []}, BossMap),
            NewState = State#boss_state{boss_world_map = NewBossMap, world_boss_rankmap = #{}, world_boss_inspire = #{}},
            {noreply, NewState};
        _ ->
            {noreply, State}
    end;

%% 蛮荒boss重生
do_handle_info({'boss_reborn', BossType, BossId}, State) when BossType == ?BOSS_TYPE_FORBIDDEN ->
    BossMap = get_boss_type_map(BossType, State),
    case maps:get(BossId, BossMap, null) of
        #boss_status{reborn_ref = RebornRef} = BR ->
            util:cancel_timer(RebornRef),
            case data_boss:get_boss_cfg(BossId) of
                #boss_cfg{type = BossType, scene = Scene, x = X, y = Y} ->
                    %% 先清怪物
                    lib_mon:clear_scene_mon_by_mids(Scene, 0, 0, 1, [BossId]),
                    %% 再重新创建
                    MonName = lib_mon:get_name_by_mon_id(BossId),
                    SceneName = lib_scene:get_scene_name(Scene),
                    MonLv = lib_mon:get_lv_by_mon_id(BossId),
                    lib_chat:send_TV({all}, ?MOD_BOSS, 8, [SceneName, MonLv, MonName]),
                    lib_scene_object:async_create_object(?BATTLE_SIGN_MON, BossId, Scene, 0, X, Y, 1, 0, 1, []);
                _ ->
                    skip
            end,
            NewBossMap = maps:put(BossId, BR#boss_status{reborn_ref = undefined, reborn_time = 0}, BossMap),
            {noreply, update_boss_state(BossType, NewBossMap, State)};
        _ ->
            {noreply, State}
    end;

%% 秘境领域 boss复活
do_handle_info({'boss_reborn', BossType, BossId}, State) when BossType == ?BOSS_TYPE_DOMAIN ->
    case get_boss_type_boss_info(State, BossType, BossId) of
        {ok, BossMap, Boss} ->
            #boss_cfg{scene = Scene, x = X, y = Y, reborn_time = RebornTimes, condition = _Condition} = BossCfg = data_boss:get_boss_cfg(BossId),
            #boss_status{reborn_ref = RebornRef, xy = XYList} = Boss,
            util:cancel_timer(RebornRef),
            DomainBossType = lib_boss:get_domain_boss_type(BossType, BossId),
            NewBoss =
                case DomainBossType of
                    cl_mon -> %% 采集怪
                        lib_boss:cl_boss_reborn(0, BossCfg, XYList, RebornTimes);
                    sp_boss ->  %% 特殊boss
                        Boss#boss_status{reborn_ref = undefined};
                    _ ->
                        lib_mon:clear_scene_mon_by_mids(Scene, 0, 0, 1, [BossId]),
                        lib_scene_object:async_create_object(?BATTLE_SIGN_MON, BossId, Scene, 0, X, Y, 1, 0, 1, []),
                        Boss#boss_status{reborn_ref = undefined}
                end,
            NewBossMap = maps:put(BossId, NewBoss, BossMap),
            {noreply, update_boss_state(BossType, NewBossMap, State)};
        _ ->
            {noreply, State}
    end;


%% 幻兽领 boss重生/采集怪刷新
do_handle_info({'boss_reborn', BossType, BossId}, State) when BossType == ?BOSS_TYPE_PHANTOM ->
    case get_boss_type_boss_info(State, BossType, BossId) of
        {ok, BossMap, Boss} ->
            #boss_cfg{
                scene = Scene, x = X, y = Y, reborn_time = RebornTimes, condition = Condition
            } = data_boss:get_boss_cfg(BossId),
            #boss_status{reborn_ref = RebornRef} = Boss,
            {_, EnterLv} = ulists:keyfind(lv, 1, Condition, {lv, 300}),
            util:cancel_timer(RebornRef),
            PhatomBossType = lib_boss:get_phatom_boss_type(BossType, BossId),
            lib_mon:clear_scene_mon_by_mids(Scene, 0, 0, 1, [BossId]),
            lib_scene_object:async_create_object(?BATTLE_SIGN_MON, BossId, Scene, 0, X, Y, 1, 0, 1, []),
            case PhatomBossType of
                cl_mon -> %% 采集怪
                    NowTime = utime:unixtime(),
                    RebornSpan = get_reborn_time(RebornTimes),
                    {NewRebornTime, NewReBornRef} = {NowTime + RebornSpan, erlang:send_after(RebornSpan * 1000, self(), {'boss_reborn', BossType, BossId})},
                    {ok, Bin} = pt_460:write(46009, [BossType, BossId, NewRebornTime, 0]),
                    lib_server_send:send_to_scene(Scene, 0, 0, Bin),
                    MonName = lib_mon:get_name_by_mon_id(BossId),
                    SceneName = lib_scene:get_scene_name(Scene),
                    lib_chat:send_TV({all_lv, EnterLv, 9999}, ?MOD_BOSS, 9, [SceneName, MonName]),
                    NewBoss = #boss_status{boss_id = BossId, reborn_time = NewRebornTime, reborn_ref = NewReBornRef, optional_data = []};
                _ ->
                    MonName = lib_mon:get_name_by_mon_id(BossId),
                    SceneName = lib_scene:get_scene_name(Scene),
                    MonLv = lib_mon:get_lv_by_mon_id(BossId),
                    lib_chat:send_TV({all_lv, EnterLv, 9999}, ?MOD_BOSS, 8, [SceneName, MonLv, MonName]),
                    NewBoss = Boss#boss_status{reborn_ref = undefined}
            end,
            NewBossMap = maps:put(BossId, NewBoss, BossMap),
            %?PRINT("boss_reborn NewBossMap ~p~n", [NewBossMap]),
            {noreply, update_boss_state(BossType, NewBossMap, State)};
        _ ->
            {noreply, State}
    end;

do_handle_info({'boss_reborn', BossType, BossId}, State) ->
    BossMap = get_boss_type_map(BossType, State),
    case maps:get(BossId, BossMap, null) of
        #boss_status{remind_ref = RemindRef, reborn_ref = RebornRef} = BR ->
            % 重生把提醒定时器也关了
            util:cancel_timer(RemindRef),
            util:cancel_timer(RebornRef),
            case data_boss:get_boss_cfg(BossId) of
                #boss_cfg{type = BossType, scene = Scene, x = X, y = Y} ->
                    %% 先清怪物
                    lib_mon:clear_scene_mon_by_mids(Scene, 0, 0, 1, [BossId]),
                    %% 再重新创建
                    MonName = lib_mon:get_name_by_mon_id(BossId),
                    SceneName = lib_scene:get_scene_name(Scene),
                    %?PRINT("BossType:~p~n",[BossType]),
                    lib_chat:send_TV({all}, ?MOD_BOSS, 2, [MonName, SceneName, Scene, X, Y, BossType]),
                    lib_scene_object:async_create_object(?BATTLE_SIGN_MON, BossId, Scene, 0, X, Y, 1, 0, 1, []);
                _ ->
                    skip
            end,
            NewBossMap = maps:put(BossId, BR#boss_status{reborn_ref = undefined, reborn_time = 0, remind_ref = undefined}, BossMap),
            {noreply, update_boss_state(BossType, NewBossMap, State)};
        _ ->
            {noreply, State}
    end;


%% boss 怒气值增加（每分钟增加2点怒气）
do_handle_info({'anger_add', RoleId, BossType, BossId}, State) ->
    #boss_state{boss_role_anger = BossRoleAnger, other_map = OtherMap} = State,
    %%    ?PRINT("per 2min  BossRoleAnger:~p~n",[BossRoleAnger]),
    case lists:keyfind(RoleId, #boss_role_anger.role_id, BossRoleAnger) of
        false ->
            lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_boss, change_add_anger_out, [BossType, BossId, OtherMap]),
            {noreply, State};
        #boss_role_anger{anger = Anger, anger_ref = AngerRef} = RoleBossAnger ->
            util:cancel_timer(AngerRef),
            NewAnger = Anger + 1,
            % #boss_type{max_anger = MaxAnger} = data_boss:get_boss_type(BossType),
            MaxAnger = calc_max_anger(RoleBossAnger, BossType),
            lib_server_send:send_to_uid(RoleId, pt_460, 46005, [NewAnger, MaxAnger]),
            %%            ?PRINT("anger_add NewAnger MaxAnger:~w~n",[[NewAnger,MaxAnger]]),
            if
                NewAnger >= MaxAnger ->
                    AngerDelayRef = erlang:send_after(?ANGER_DELAY_TIME * 1000, self(), {'anger_tickout_delay', RoleId, BossType, BossId}),
                    EndTime = utime:unixtime() + ?ANGER_DELAY_TIME,
                    E = RoleBossAnger#boss_role_anger{anger = MaxAnger, step = ?FORBIDDEN_OUT_DELAY,
                        time = EndTime, anger_ref = AngerDelayRef},
                    NewBossRoleAnger = lists:keystore(RoleId, #boss_role_anger.role_id, BossRoleAnger, E),
                    lib_server_send:send_to_uid(RoleId, pt_460, 46006, [?FORBIDDEN_OUT_DELAY, ?ANGER_DELAY_TIME]),
                    {noreply, State#boss_state{boss_role_anger = NewBossRoleAnger}};
                true ->
                    NewAngerRef = erlang:send_after(?ANGER_TIME * 1000, self(), {'anger_add', RoleId, BossType, BossId}),
                    E = RoleBossAnger#boss_role_anger{anger = NewAnger, anger_ref = NewAngerRef},
                    NewBossRoleAnger = lists:keystore(RoleId, #boss_role_anger.role_id, BossRoleAnger, E),
                    {noreply, State#boss_state{boss_role_anger = NewBossRoleAnger}}
            end
    end;

%% 蛮荒禁地Boss雷霆之怒
do_handle_info({'anger_tickout_delay', RoleId, BossType, BossId}, State) ->
    #boss_state{boss_role_anger = BossRoleAnger, other_map = OtherMap} = State,
    case lists:keyfind(RoleId, #boss_role_anger.role_id, BossRoleAnger) of
        false ->
            lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_boss, change_add_anger_out, [BossType, BossId, OtherMap]),
            {noreply, State};
        #boss_role_anger{anger_ref = AngerDelayRef} = RoleBossAnger ->
            util:cancel_timer(AngerDelayRef),
            TickoutRef = erlang:send_after(?ANGER_OUT_TIME * 1000, self(), {'anger_tickout', RoleId, BossType, BossId}),
            EndTime = utime:unixtime() + ?ANGER_OUT_TIME,
            E = RoleBossAnger#boss_role_anger{anger_ref = TickoutRef, step = ?FORBIDDEN_OUT_TIME, time = EndTime},
            NewBossRoleAnger = lists:keystore(RoleId, #boss_role_anger.role_id, BossRoleAnger, E),
            lib_server_send:send_to_uid(RoleId, pt_460, 46006, [?FORBIDDEN_OUT_TIME, ?ANGER_OUT_TIME]),
            {noreply, State#boss_state{boss_role_anger = NewBossRoleAnger}}
    end;

%% 踢出蛮荒禁地Boss场景
do_handle_info({'anger_tickout', RoleId, BossType, BossId}, State) ->
    #boss_state{boss_role_anger = BossRoleAnger, other_map = OtherMap} = State,
    case lists:keyfind(RoleId, #boss_role_anger.role_id, BossRoleAnger) of
        false ->
            lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_boss, change_add_anger_out, [BossType, BossId, OtherMap]),
            {noreply, State};
        #boss_role_anger{anger_ref = AngerTickoutRef} ->
            util:cancel_timer(AngerTickoutRef),
            NewBossRoleAnger = lists:keydelete(RoleId, #boss_role_anger.role_id, BossRoleAnger),
            lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_boss, change_add_anger_out, [BossType, BossId, OtherMap]),
            {noreply, State#boss_state{boss_role_anger = NewBossRoleAnger}}
    end;


%% 神庙怪物初始
do_handle_info({'temple_mon_init', BossType, BossId, #boss_cfg{num = NumLim} = BossCfg, TType}, State) ->
    BossMap = get_boss_type_map(BossType, State),
    case maps:get(BossId, BossMap, null) of
        #boss_status{reborn_ref = RebornRef} = BR ->
            util:cancel_timer(RebornRef),
            % 获取出生点
            XY = temple_get_init_xy(BossId, TType, BossCfg),
            NewBossMap = maps:put(BossId, BR#boss_status{reborn_ref = undefined, num = NumLim, xy = XY}, BossMap),
            {noreply, update_boss_state(BossType, NewBossMap, State)};
        _ -> {noreply, State}
    end;

do_handle_info({'temple_tv'}, State) ->
    #boss_state{temple_tv_ref = TvRef} = State,
    util:cancel_timer(TvRef),
    lib_chat:send_TV({all}, ?MOD_BOSS, 5, []),
    NewRef = erlang:send_after(lib_boss:get_temple_boss_next_time(utime:unixtime()) * 1000, self(), {'temple_tv'}),
    {noreply, State#boss_state{temple_tv_ref = NewRef}};

%% 计算狂热时间
do_handle_info({calc_fever, BossType}, State) ->
    lib_boss_mod:calc_fever(State, BossType);

%% 计算狂热时间
do_handle_info({fever_ref, BossType}, State) ->
    lib_boss_mod:fever_ref(State, BossType);

%% 离开
do_handle_info({leave_ref, RoleId, BossType, BossId}, State) ->
    lib_boss_mod:leave_ref(State, RoleId, BossType, BossId);

do_handle_info({'send_rank', BossId, NeedSendL}, State) ->
    case data_boss:get_boss_cfg(BossId) of
        #boss_cfg{scene = Scene} ->
            {ok, Bin} = pt_460:write(46019, [NeedSendL]),
            lib_server_send:send_to_scene(Scene, 0, 0, Bin);
        _ ->
            skip
    end,
    % lib_server_send:send_to_scene(RoleId, pt_460, 46019, [RealRank, RHurt, Name, Distance, NeedSendL]),
    % ?PRINT("Rank:~p, RHurt:~p, Name:~p, Distance:~p, NeedSendL:~p",[RealRank, RHurt, Name, Distance, NeedSendL]),
    {noreply, State};

%%世界boss入口图标显示
do_handle_info({'wldboss_enter_icon', Sid}, State) ->
    {ok, BinData} = pt_460:write(46017, [1]),
    lib_server_send:send_to_sid(Sid, BinData),
    {noreply, State};

%%节日boss其他小怪刷新
do_handle_info({'feast_boss_small_mon_refresh', CopyId}, State) ->
    NewState = lib_boss_mod:handle_feast_boss_refresh_small_mon(CopyId, State),
    {noreply, NewState};

do_handle_info(_Info, State) ->
    ?ERR("Boss Info No Match:~p~n", [_Info]),
    {noreply, State}.


%% ================================= private fun =================================
get_boss_db_info(NowTime, AllBossIds) ->
    AllBossReminds = case db:get_all(<<" select role_id, boss_id, remind, auto_remind from boss_remind">>) of
                         BossReminds when is_list(BossReminds) -> BossReminds;
                         _ -> []
                     end,
    {DbList, DelList, LessBossIds}
        = case db:get_all(<<" select boss_id, reborn_time, optional_data from boss ">>) of
              BossList when is_list(BossList) ->
                  F = fun([BossId, RebornTime, OptionalDataB], {LefL, DelL, LessL}) ->
                      case lists:member(BossId, AllBossIds) of
                          false -> %% del
                              {LefL, [BossId | DelL], lists:delete(BossId, LessL)};
                          true ->
                              OptionalData = util:bitstring_to_term(OptionalDataB),
                              NewRebornTime = ?IF(RebornTime =< NowTime, 0, RebornTime),
                              {[{BossId, NewRebornTime, OptionalData} | LefL], DelL, lists:delete(BossId, LessL)}
                      end
                      end,
                  lists:foldl(F, {[], [], AllBossIds}, BossList);
              _ ->
                  {[], [], AllBossIds}
          end,
    Fun = fun(DelBossId, I) ->
        DelbossSQL = <<"delete from boss where boss_id = ~p">>,
        DelbossRemindSQL = <<"delete from boss_remind where boss_id = ~p">>,
        db:execute(io_lib:format(DelbossSQL, [DelBossId])),
        db:execute(io_lib:format(DelbossRemindSQL, [DelBossId])),
        if I == 5 -> util:sleep(100), 0; true -> I end
          end,
    spawn(fun() -> lists:foldl(Fun, 0, DelList) end),
    {AllBossReminds, DbList ++ [{LLBossId, 0, []} || LLBossId <- LessBossIds]}.

%% 获取BOSS map和info
get_boss_type_boss_info(State, BossType, BossId) ->
    case get_boss_type_map(BossType, State) of
        null -> {false, ?ERRCODE(err460_no_boss_type)};
        BossMap ->
            case maps:get(BossId, BossMap, null) of
                null -> {false, ?ERRCODE(err460_no_boss_cfg)};
                Boss -> {ok, BossMap, Boss}
            end
    end.

get_boss_type_map(BossType, State) ->
    if
        BossType == ?BOSS_TYPE_WORLD -> State#boss_state.boss_world_map;
        BossType == ?BOSS_TYPE_VIP_PERSONAL -> State#boss_state.boss_personal_map;
        BossType == ?BOSS_TYPE_HOME -> State#boss_state.boss_home_map;
        BossType == ?BOSS_TYPE_FORBIDDEN -> State#boss_state.boss_forbidden_map;
        BossType == ?BOSS_TYPE_DOMAIN -> State#boss_state.boss_domain_map;
        BossType == ?BOSS_TYPE_TEMPLE -> State#boss_state.boss_temple_map;
        BossType == ?BOSS_TYPE_PHANTOM -> State#boss_state.boss_phantom_map;
        true -> null
    end.

update_boss_state(BossType, NewBossMap, State) ->
    if
        BossType == ?BOSS_TYPE_WORLD -> State#boss_state{boss_world_map = NewBossMap};
        BossType == ?BOSS_TYPE_VIP_PERSONAL -> State#boss_state{boss_personal_map = NewBossMap};
        BossType == ?BOSS_TYPE_HOME -> State#boss_state{boss_home_map = NewBossMap};
        BossType == ?BOSS_TYPE_FORBIDDEN -> State#boss_state{boss_forbidden_map = NewBossMap};
        BossType == ?BOSS_TYPE_DOMAIN -> State#boss_state{boss_domain_map = NewBossMap};
        BossType == ?BOSS_TYPE_TEMPLE -> State#boss_state{boss_temple_map = NewBossMap};
        BossType == ?BOSS_TYPE_PHANTOM -> State#boss_state{boss_phantom_map = NewBossMap};
        true -> State
    end.

%% 发送提醒消息
send_remind_msg_role([], _BossType, _BossId) -> skip;
send_remind_msg_role([RoleId | RemindList], BossType, BossId) ->
    lib_server_send:send_to_uid(RoleId, pt_460, 46008, [BossType, BossId]),
    send_remind_msg_role(RemindList, BossType, BossId).

%% 获取重生时间
get_reborn_time(RebornTimes) ->
    Opday = util:get_open_day(),
    get_reborn_time(RebornTimes, 0, Opday).

get_reborn_time([], Time, _Opday) ->
    if Time == 0 -> ?REMIND_TIME; true -> Time end;
get_reborn_time([{B, BornTime} | T], Time, Opday) ->
    if
        Opday >= B -> get_reborn_time(T, BornTime, Opday);
        true -> Time
    end;
get_reborn_time([_ | T], Time, Opday) -> get_reborn_time(T, Time, Opday).

%% 击杀boss处理
do_boss_be_kill(OnlineNumMap, BossType, BossMap, Boss, AttrId, AttrName, BLWhos, MonArgs) ->
    #boss_status{boss_id = BossId, kill_log = KillLog, remind_ref = RemindRef, reborn_ref = RebornRef, num = Num} = Boss,
    %% 取消旧的定时器
    util:cancel_timer(RemindRef),
    util:cancel_timer(RebornRef),
    %% 计算重生时间和提醒时间
    NowTime = utime:unixtime(),
    #boss_cfg{reborn_time = RebornTimes} = data_boss:get_boss_cfg(BossId),
    %% 更新击杀记录
    NewKillLog = [{NowTime, AttrId, AttrName} | KillLog],
    case lib_boss:get_temple_mon_type(BossType, BossId) of
        rand_boss ->
            RebornEndTime = 0,
            NewBoss = Boss#boss_status{kill_log = NewKillLog};
        _ ->
            TemRebornTime = ?IF(BossType =/= ?BOSS_TYPE_TEMPLE, get_reborn_time(RebornTimes), lib_boss:get_temple_boss_next_time(BossType, NowTime)),
            % Discount = lib_boss:calc_online_user(OnlineNumMap, BossType, BossId),
            % RebornTime = TemRebornTime * Discount div 100,
            RebornTime_2 = lib_boss:calc_online_user(OnlineNumMap, BossType, BossId),
            if
                RebornTime_2 == 0 ->
                    RebornTime = TemRebornTime;
                true ->
                    RebornTime = RebornTime_2
            end,
            RebornEndTime = NowTime + RebornTime,
            % ?PRINT("OnlineNumMap:~p, {BossType,BossId}:~p, Discount:~p,TemRebornTime:~p,
            %         RebornTime:~p ~n",[OnlineNumMap,{BossType,BossId},Discount,TemRebornTime, RebornTime]),
            %% 更新boss重生时间
            spawn(fun() ->
                update_boss_reborn_time(BossId, RebornEndTime) end),
            RemindTime = max(0, RebornTime - ?REMIND_TIME),
            NRemindRef = ?IF(RemindTime =< 0, undefined,
                erlang:send_after(RemindTime * 1000, self(), {'boss_remind', BossType, BossId})),
            NRebornRef = erlang:send_after(RebornTime * 1000, self(), {'boss_reborn', BossType, BossId}),
            NewBoss = Boss#boss_status{reborn_time = RebornEndTime, kill_log = NewKillLog, remind_ref = NRemindRef, reborn_ref = NRebornRef}
    end,
    NewBossMap = maps:update(BossId, NewBoss, BossMap),
    %% 广播boss死亡信息
    {ok, Bin} = pt_460:write(46009, [BossType, BossId, RebornEndTime, max(0, Num - 1)]),
    lib_server_send:send_to_all(Bin),
    %% 事件触发
    CallBackData = #callback_boss_kill{boss_type = BossType, boss_id = BossId},
    [lib_player_event:async_dispatch(RoleId, ?EVENT_BOSS_KILL, CallBackData)||#mon_atter{id = RoleId}<-BLWhos],
    %% 成就触发
    lib_player:apply_cast(AttrId, ?APPLY_CAST_STATUS, lib_achievement_api, boss_achv_finish, [BossType, BossId]),
    handle_activitycalen_kill([], AttrId, [], BossType),
    [begin
        case P#mon_atter.hurt > 0 of
            true ->
                %% Boss转盘
                lib_boss_rotary:boss_be_kill(P#mon_atter.id, BossType, BossId);
            _ ->
                ok
        end
    end || P <- BLWhos],
    %% 玩家击杀和日志
    case [P#mon_atter.id || P <- BLWhos] of
        [] ->
            lib_log_api:log_boss(BossType, BossId, AttrId, "[]", NowTime);
        BLIds ->
            StrBLIds = util:term_to_string(BLIds),
            lib_log_api:log_boss(BossType, BossId, AttrId, StrBLIds, NowTime),
            [begin
            %% boss击杀任务
                 lib_task_api:kill_boss(BlId, BossType, MonArgs#mon_args.lv),
                 lib_baby_api:boss_be_kill(BlId, BossType, BossId),
                 lib_demons_api:boss_be_kill(BlId, BossType, BossId)
             end || BlId <- BLIds]
    end,
    NewBossMap.

%% 神庙怪物被击杀处理
do_temple_mon_be_kill(BossType, BossMap, Boss, _AttrId, _AttrName, _BLWhos) ->
    #boss_status{boss_id = BossId, remind_ref = RemindRef, reborn_ref = _RebornRef, num = Num} = Boss,
    util:cancel_timer(RemindRef),
    %util:cancel_timer(RebornRef),
    NowTime = utime:unixtime(),
    #boss_cfg{scene = Scene} = data_boss:get_boss_cfg(BossId),
    RebornTime = lib_boss:get_temple_boss_next_time(BossType, NowTime),
    RebornEndTime = NowTime + RebornTime,
    NRemindRef = undefined,
    NRebornRef = erlang:send_after(RebornTime * 1000, self(), {'boss_reborn', BossType, BossId}),
    NewBoss = Boss#boss_status{reborn_time = RebornEndTime, remind_ref = NRemindRef, reborn_ref = NRebornRef},
    %% 广播boss死亡信息
    {ok, Bin} = pt_460:write(46009, [BossType, BossId, RebornEndTime, max(0, Num - 1)]),
    lib_server_send:send_to_scene(Scene, 0, 0, Bin),
    maps:put(BossId, NewBoss, BossMap).

do_platom_cl_mon_be_kill(BossType, BossMap, Boss, AttrId, _AttrName, _BLWhos, MonArgs) ->
    #mon_args{collect_times = CollectTimes} = MonArgs,
    #boss_status{boss_id = BossId, reborn_time = RebornTime, optional_data = OptionalData} = Boss,
    #boss_cfg{scene = Scene} = data_boss:get_boss_cfg(BossId),
    NewOptionalData = lists:keystore({BossType, BossId}, 1, OptionalData, {{BossType, BossId}, CollectTimes}),
    NewBoss = Boss#boss_status{optional_data = NewOptionalData},
    update_boss_reborn_time(BossId, RebornTime, NewOptionalData),
    update_boss_collect_times(BossType, BossId, AttrId),
    {ok, Bin} = pt_460:write(46009, [BossType, BossId, RebornTime, max(0, CollectTimes)]),
    lib_server_send:send_to_scene(Scene, 0, 0, Bin),
    NewBossMap = maps:update(BossId, NewBoss, BossMap),
    NewBossMap.

%% 更新boss疲劳
update_boss_tired(BossType, AttrId, BLWhos) ->
    #boss_type{module = _Module, daily_id = _TmpDailyType} = data_boss:get_boss_type(BossType),
    F = fun(RId) ->
        %% 触发日常
        %%        ?IF(BossType =/= ?BOSS_TYPE_WORLD, skip,
        %%            lib_activitycalen_api:role_success_end_activity(RId, ?MOD_BOSS,  BossType)),
        case BossType of
            ?BOSS_TYPE_TEMPLE ->
                % DailyType = TmpDailyType * 1000,
                lib_player:update_player_info(RId, [{temple_boss_tired, 1}]);
            ?BOSS_TYPE_WORLD ->
                % DailyType = TmpDailyType,
                lib_player:update_player_info(RId, [{boss_tired, 1}]);
            ?BOSS_TYPE_PHANTOM ->
                lib_player:update_player_info(RId, [{phantom_tired, 1}])
        end,
        mod_daily:increment(RId, ?MOD_BOSS, ?MOD_BOSS_TIRE, BossType)
        end,
    L = ?IF(BLWhos == [], [AttrId], [P#mon_atter.id || P <- BLWhos]),
    lists:map(F, L).

update_boss_collect_times(BossType, BossId, AttrId) ->
    mod_daily:increment_offline(AttrId, ?MOD_BOSS, ?MOD_BOSS_COLLECT, BossType),
    #boss_cfg{goods = Goods} = data_boss:get_boss_cfg(BossId),
    Produce = #produce{type = phantom_boss, reward = Goods, remark = lists:concat([BossType, BossId])},
    lib_goods_api:send_reward_with_mail(AttrId, Produce),
    CollectTimes = mod_daily:get_count_offline(AttrId, ?MOD_BOSS, ?MOD_BOSS_COLLECT, BossType),
    lib_boss:broadcast_role_info(AttrId, [{4, CollectTimes}]),
    %?PRINT("update_boss_collect_times ~p~n",[Goods]),
    ok.

%% 保存boss的刷新时间
update_boss_reborn_time(BossId, RebornTime) ->
    SQL = <<"replace into `boss` set `boss_id` = ~p, `reborn_time` = ~p">>,
    db:execute(io_lib:format(SQL, [BossId, RebornTime])).

update_boss_reborn_time(BossId, RebornTime, OptionalData) ->
    SQL = <<"replace into `boss` set `boss_id` = ~p, `reborn_time` = ~p, `optional_data` = '~s'">>,
    db:execute(io_lib:format(SQL, [BossId, RebornTime, util:term_to_bitstring(OptionalData)])).

%% 按归属+怒气
update_boss_anger(BossType, BossId, AttrId, BossRoleAnger, BLWhos) ->
    #mon{anger = MonAnger} = data_mon:get(BossId),
    #boss_type{max_anger = MaxAnger} = data_boss:get_boss_type(BossType),
    L = ?IF(BLWhos == [], [AttrId], [P#mon_atter.id || P <- BLWhos]),
    Fun = fun(AId, TAngerRef) ->
        case lists:keyfind(AId, #boss_role_anger.role_id, TAngerRef) of
            false -> SumMaxAnger = MaxAnger;
            #boss_role_anger{} = OE -> SumMaxAnger = calc_max_anger(OE, BossType)
        end,
        case lists:keyfind(AId, #boss_role_anger.role_id, TAngerRef) of
            false ->
                %%                ?PRINT("46005 kill boss MonAnger:~p~n",[MonAnger]),
                lib_server_send:send_to_uid(AId, pt_460, 46005, [MonAnger, SumMaxAnger]),
                AngerRef = erlang:send_after(?ANGER_TIME * 1000, self(), {'anger_add', AId, BossType, BossId}),
                E = #boss_role_anger{role_id = AId, anger = MonAnger, anger_ref = AngerRef},
                lists:keystore(AId, #boss_role_anger.role_id, TAngerRef, E);
            #boss_role_anger{anger = Anger} when SumMaxAnger == Anger ->
                TAngerRef;
            #boss_role_anger{anger = Anger, anger_ref = AngerRef} = RoleBossAnger ->
                NewAnger = Anger + MonAnger,
                %%                ?PRINT("46005 kill boss NewAnger:~w~n",[NewAnger]),
                lib_server_send:send_to_uid(AId, pt_460, 46005, [min(SumMaxAnger, NewAnger), SumMaxAnger]),
                if
                    NewAnger >= SumMaxAnger ->
                        util:cancel_timer(AngerRef),
                        AngerDelayRef = erlang:send_after(?ANGER_DELAY_TIME * 1000, self(),
                            {'anger_tickout_delay', AId, BossType, BossId}),
                        EndTime = utime:unixtime() + ?ANGER_DELAY_TIME,
                        E = RoleBossAnger#boss_role_anger{anger = SumMaxAnger,
                            step = ?FORBIDDEN_OUT_DELAY,
                            time = EndTime,
                            anger_ref = AngerDelayRef},
                        lib_server_send:send_to_uid(AId, pt_460, 46006,
                            [?FORBIDDEN_OUT_DELAY, ?ANGER_DELAY_TIME]),
                        lists:keystore(AId, #boss_role_anger.role_id, TAngerRef, E);
                    true ->
                        E = RoleBossAnger#boss_role_anger{anger = NewAnger},
                        lists:keystore(AId, #boss_role_anger.role_id, TAngerRef, E)
                end
        end
          end,
    lists:foldl(Fun, BossRoleAnger, L).


%% 神庙固定boss被击杀后生成随机boss
born_temple_rand_boss(BossType) when BossType == ?BOSS_TYPE_TEMPLE ->
    case urand:rand(1, 100) =< 100 of
        true ->
            RandBossIds = [BossId || BossId <- data_boss:get_all_boss_id(),
                case data_boss:get_boss_cfg(BossId) of
                    #boss_cfg{type = BossType, rand_xy = [{_X, _Y} | _]} ->
                        ?IF(lib_boss:get_temple_mon_type(BossType, BossId) =:= rand_boss, true, false);
                    _ ->
                        false
                end],
            [self() ! {'boss_reborn', BossType, BossId} || BossId <- RandBossIds];
        _ ->
            skip
    end.


temple_boss_init(BossType, BossId, RemindInfos, BossCfg, NowTime, RebornTime) ->
    Boss = #boss_status{boss_id = BossId},
    case lib_boss:get_temple_mon_type(BossType, BossId) of
        fixed_boss ->
            RebornSpanTime = max(0, RebornTime - NowTime),
            if
                RebornSpanTime > 0 ->
                    RemindTime = max(0, RebornSpanTime - ?REMIND_TIME),
                    RemindRef = ?IF(RemindTime =< 0, undefined, erlang:send_after(RemindTime * 1000, self(), {'boss_remind', BossType, BossId})),
                    RebornRef = erlang:send_after(RebornSpanTime * 1000, self(), {'boss_reborn', BossType, BossId});
                true ->
                    RemindRef = undefined,
                    RebornRef = erlang:send_after(1, self(), {'boss_reborn', BossType, BossId})
            end,
            BReminds = [RoleId || [RoleId, _, Remind, _] <- RemindInfos, Remind == ?REMIND],
            NoAutoList = [RoleId || [RoleId, _, _, AutoRemind] <- RemindInfos, AutoRemind == ?NO_AUTO_REMIND],
            NewBoss = Boss#boss_status{remind_list = BReminds, no_auto_remind_list = NoAutoList, reborn_time = RebornTime, remind_ref = RemindRef, reborn_ref = RebornRef};
        rand_boss ->
            NewBoss = Boss;
        rare_mon ->
            erlang:send_after(1, self(), {'temple_mon_init', BossType, BossId, BossCfg, rare_mon}), NewBoss = Boss;
        rare_cl_mon ->
            erlang:send_after(1, self(), {'temple_mon_init', BossType, BossId, BossCfg, rare_cl_mon}), NewBoss = Boss
    end,
    NewBoss.

refresh_new_boss(BossId, BossMap, #boss_cfg{type = BossType, scene = Scene, x = X, y = Y}) ->
    NowTime = utime:unixtime(),
    TplMonType = lib_boss:get_temple_mon_type(BossType, BossId),
    if
        BossType == ?BOSS_TYPE_TEMPLE, TplMonType =/= fixed_boss ->
            BossMap;
        true ->
            case maps:get(BossId, BossMap, false) of
                #boss_status{remind_ref = RemindRef, reborn_ref = RebornRef} = OldBoss when is_reference(RebornRef) ->
                    util:cancel_timer(RemindRef),
                    util:cancel_timer(RebornRef),
                    lib_scene_object:async_create_object(?BATTLE_SIGN_MON, BossId, Scene, 0, X, Y, 1, 0, 1, []),
                    NewBoss = OldBoss#boss_status{remind_ref = undefined, reborn_time = NowTime, reborn_ref = undefined},
                    update_boss_reborn_time(BossId, NowTime),
                    maps:put(BossId, NewBoss, BossMap);
                _ ->
                    BossMap
            end
    end.

refresh_common_boss(BossId, ComStatusMap, #boss_cfg{type = BossType, scene = Scene, x = X, y = Y}) ->
    NowTime = utime:unixtime(),
    case maps:get(BossType, ComStatusMap, []) of
        [] -> ComStatusMap;
        #boss_common_status{boss_map = BossMap} = OldComStatus ->
            case maps:get(BossId, BossMap, false) of
                #boss_status{remind_ref = RemindRef, reborn_ref = RebornRef} = OldBoss when is_reference(RebornRef) ->
                    util:cancel_timer(RemindRef),
                    util:cancel_timer(RebornRef),
                    lib_scene_object:async_create_object(?BATTLE_SIGN_MON, BossId, Scene, 0, X, Y, 1, 0, 1, []),
                    NewBoss = OldBoss#boss_status{remind_ref = undefined, reborn_time = NowTime, reborn_ref = undefined},
                    update_boss_reborn_time(BossId, NowTime),
                    NewBossMap = maps:put(BossId, NewBoss, BossMap),
                    ComStatus = OldComStatus#boss_common_status{boss_map = NewBossMap};
                _ ->
                    ComStatus = OldComStatus
            end,
            maps:put(BossType, ComStatus, ComStatusMap)
    end.

%% 神庙采集怪状态
gm_temple_cl_mon() ->
    mod_scene_agent:apply_cast(1351, 0, ?MODULE, change_temple_status, []).

change_temple_status() ->
    F = fun
            ({{object, Id}, #scene_object{config_id = 1351042, d_x = X, d_y = Y}}, AccL) ->
                [{Id, X, Y} | AccL];
            (_, AccL) ->
                AccL
        end,
    OjectL = lists:foldl(F, [], get()),
    lib_scene_object_agent:clear_scene_object_by_ids(1, [Id || {Id, _, _} <- OjectL]),
    [mod_scene_object_create:create_object_cast(?BATTLE_SIGN_MON, 1351042, 1351, 0, X, Y, 1, 0, 1, []) || {_, X, Y} <- OjectL],
    ok.
%% 修疲劳
gm_tired() ->
    IdL = [17179871177, 17179869368, 17179869607, 17179869731, 17179869988, 17179872430, 17179870032, 17179872018, 47244641116, 47244640521, 47244641129
        , 47244640611, 47244644354, 47244642708, 47244640978, 47244641256, 47244642435, 47244640580, 47244644810, 8589934619, 8589934625, 8589934649, 8589934622, 8589934642, 8589935503, 77309411388],
    [lib_player:apply_cast(Id, ?APPLY_CAST_STATUS, ?MODULE, gm_change_tired, []) || Id <- IdL],
    ok.
gm_change_tired(Ps) ->
    SetCount = mod_daily:get_count(Ps#player_status.id, ?MOD_BOSS, ?MOD_BOSS_TIRE, ?BOSS_TYPE_TEMPLE),
    mod_scene_agent:update(Ps#player_status{scene = 1351, scene_pool_id = 0}, [{temple_boss_tired, SetCount}]),
    NewPs = Ps#player_status{temple_boss_tired = SetCount},
    {ok, NewPs}.




handle_activitycalen_enter(RoleId, BossType) ->
    if
        BossType == ?BOSS_TYPE_FORBIDDEN ->
            lib_local_chrono_rift_act:role_success_finish_act(RoleId, ?MOD_BOSS, ?BOSS_TYPE_FORBIDDEN, 1);
        BossType == ?BOSS_TYPE_ABYSS ->
            lib_activitycalen_api:role_success_end_activity(RoleId, ?MOD_BOSS, ?MOD_SUB_ABYSS_BOSS);
    %%      BossType == ?BOSS_TYPE_DOMAIN ->
    %%          lib_activitycalen_api:role_success_end_activity(RoleId, ?MOD_BOSS, ?BOSS_TYPE_DOMAIN);
    %%      BossType == ?BOSS_TYPE_FAIRYLAND ->
    %%          lib_activitycalen_api:role_success_end_activity(RoleId, ?MOD_BOSS, ?MOD_SUB_FAIRYLAND_BOSS);
        true ->
            skip
    end.

handle_activitycalen_kill(_RoleIdList, AttrId, BelongList, BossType) ->
    if
        BossType == ?BOSS_TYPE_NEW_OUTSIDE -> %%野外boss参与就可以算是完成任务
            [ begin
                  handle_activitycalen_kill(RoleId, BossType),
                  lib_local_chrono_rift_act:role_success_finish_act(RoleId, ?MOD_BOSS, ?BOSS_TYPE_NEW_OUTSIDE, 1)
              end
                || #mon_atter{id = RoleId} <- BelongList];
        BossType == ?BOSS_TYPE_FORBIDDEN -> %%蛮荒boss击杀可以算是完成任务
            handle_activitycalen_kill(AttrId, BossType);
        BossType == ?BOSS_TYPE_DOMAIN ->
            handle_activitycalen_kill(AttrId, BossType),
            lib_local_chrono_rift_act:role_success_finish_act(AttrId, ?MOD_BOSS, ?BOSS_TYPE_DOMAIN, 1);
        BossType == ?BOSS_TYPE_ABYSS ->
            lib_local_chrono_rift_act:role_success_finish_act(AttrId, ?MOD_BOSS, ?BOSS_TYPE_ABYSS, 1);
        BossType == ?BOSS_TYPE_KF_GREAT_DEMON ->
            handle_activitycalen_kill(AttrId, BossType),
            lib_local_chrono_rift_act:role_success_finish_act(AttrId, ?MOD_BOSS, ?BOSS_TYPE_KF_GREAT_DEMON, 1);
        true ->
            skip
    end.


handle_activitycalen_kill(RoleId, BossType) ->
    if
        BossType == ?BOSS_TYPE_OUTSIDE ->
            lib_activitycalen_api:role_success_end_activity(RoleId, ?MOD_BOSS, ?MOD_SUB_OUTSIDE_BOSS);
        BossType == ?BOSS_TYPE_NEW_OUTSIDE ->
            lib_activitycalen_api:role_success_end_activity(RoleId, ?MOD_BOSS, ?MOD_SUB_NEW_OUTSIDE_BOSS);
        BossType == ?BOSS_TYPE_FAIRYLAND ->
            lib_activitycalen_api:role_success_end_activity(RoleId, ?MOD_BOSS, ?MOD_SUB_FAIRYLAND_BOSS);
        BossType == ?BOSS_TYPE_DOMAIN ->
            lib_activitycalen_api:role_success_end_activity(RoleId, ?MOD_BOSS, ?BOSS_TYPE_DOMAIN);
        BossType == ?BOSS_TYPE_FORBIDDEN ->
            lib_activitycalen_api:role_success_end_activity(RoleId, ?MOD_BOSS, ?MOD_SUB_FBD_BOSS);
        BossType == ?BOSS_TYPE_KF_GREAT_DEMON ->
            lib_activitycalen_api:role_success_end_activity(RoleId, ?MOD_BOSS, ?BOSS_TYPE_KF_GREAT_DEMON);
        true ->
            skip
    end.

calc_max_anger(BossRoleAnger, ?BOSS_TYPE_FORBIDDEN) ->
    #boss_role_anger{add_anger = AddAnger, weekly_card_status = WeeklyCardStatus} = BossRoleAnger,
    case data_boss:get_boss_type(?BOSS_TYPE_FORBIDDEN) of
        #boss_type{max_anger = MaxAnger} ->
            ?IF(WeeklyCardStatus#weekly_card_status.is_activity =:= ?ACTIVATION_OPEN,
                trunc(MaxAnger * ?WEEKLY_CARD_PHYSICAL_STRENGTH) + MaxAnger + AddAnger, MaxAnger + AddAnger);
        _ -> AddAnger
    end;
calc_max_anger(#boss_role_anger{add_anger = AddAnger}, BossType) ->
    case data_boss:get_boss_type(BossType) of
        #boss_type{max_anger = MaxAnger} ->  MaxAnger + AddAnger;
        _ -> AddAnger
    end.

calc_max_anger(#boss_role_anger{boss_type = ?BOSS_TYPE_FORBIDDEN} = BossRoleAnger) ->
    #boss_role_anger{add_anger = AddAnger, weekly_card_status = WeeklyCardStatus} = BossRoleAnger,
    case data_boss:get_boss_type(?BOSS_TYPE_FORBIDDEN) of
        #boss_type{max_anger = MaxAnger} ->
            ?IF(WeeklyCardStatus#weekly_card_status.is_activity =:= ?ACTIVATION_OPEN,
                trunc(MaxAnger * ?WEEKLY_CARD_PHYSICAL_STRENGTH) + MaxAnger + AddAnger, MaxAnger + AddAnger);
        _ -> AddAnger
    end;
calc_max_anger(#boss_role_anger{boss_type = BossType, add_anger = AddAnger}) ->
    case data_boss:get_boss_type(BossType) of
        #boss_type{max_anger = MaxAnger} ->  MaxAnger + AddAnger;
        _ -> AddAnger
    end.

%% 处理节日场景下Boss击杀事件
handle_boss_be_killed_at_feast_scene(Scene, ScenePoolId, BossId, AttrId, AttrName, BLWho, DX, DY, FirstAttr, MonArgs) ->
    try
        true = Scene =:= ?FEAST_BOSS_SCENE,
        List = data_boss:get_boss_type_kv(?BOSS_TYPE_FEAST, feast_boss_id),
        case lists:member(BossId, List) of
            true -> % boss
                gen_server:cast(?MODULE, {'boss_be_kill', ScenePoolId, ?BOSS_TYPE_FEAST, BossId, AttrId, AttrName, BLWho, DX, DY, FirstAttr, MonArgs});
            false ->
                #mon{kind = ?MON_KIND_COLLECT} = data_mon:get(BossId),
                gen_server:cast(?MODULE, {'be_collected', ScenePoolId, ?BOSS_TYPE_FEAST, BossId, AttrId, AttrName, BLWho, DX, DY, FirstAttr, MonArgs})
        end
    catch
        _:_ -> skip
    end.

%% 处理未在配置场景下被击杀的Boss被杀事件
handle_boss_be_killed_on_uncfg_scene(BossType, _Scene, ScenePoolId, BossId, AttrId, AttrName, BLWho, DX, DY, FirstAttr, MonArgs)
    when BossType =:= ?BOSS_TYPE_FORBIDDEN orelse
         BossType =:= ?BOSS_TYPE_TEMPLE ->
    try
        #boss_type{mon_ids = MonIds} = data_boss:get_boss_type(BossType),
        true =:= lists:member(BossId, MonIds) andalso
        gen_server:cast(?MODULE, {'boss_be_kill', ScenePoolId, BossType, BossId, AttrId, AttrName, BLWho, DX, DY, FirstAttr, MonArgs})
    catch
        _:_ -> skip
    end;
handle_boss_be_killed_on_uncfg_scene(_BossType, _Scene, _ScenePoolId, _BossId, _AttrId, _AttrName, _BLWho, _DX, _DY, _FirstAttr, _MonArgs) -> skip.


%% 神庙Boss获取出生点
temple_get_init_xy(BossId, TType, #boss_cfg{scene = Scene, rand_xy = RandL, num = NumLim}) ->
    case TType of
        rare_mon ->
            Radius = 200, PNum = 3,
            F = fun({X, Y}, {Acc, AccL}) ->
                F1 = fun(_, {Acc1, AccL1}) ->
                    case Acc1 >= NumLim of
                        true -> {Acc1, AccL1};
                        false ->
                            {RX, RY} = umath:rand_point_in_circle(X, Y, Radius, 1),
                            lib_scene_object:async_create_object(?BATTLE_SIGN_MON, BossId, Scene, 0, RX, RY, 1, 0, 1, []),
                            {Acc1 + 1, [{RX, RY} | AccL1]}
                    end
                    end,
                lists:foldl(F1, {Acc, AccL}, lists:seq(1, PNum))
                end,
            {_, XYL} = lists:foldl(F, {0, []}, RandL);
        rare_cl_mon ->
            case length(RandL) < NumLim of
                true -> XYL = [];
                false ->
                    F2 = fun(_, AccL) ->
                        {X, Y} = urand:list_rand(AccL),
                        lib_scene_object:async_create_object(?BATTLE_SIGN_MON, BossId, Scene, 0, X, Y, 1, 0, 1, []),
                        AccL -- [{X, Y}]
                        end,
                    XYL = RandL -- lists:foldl(F2, RandL, lists:seq(1, NumLim))
            end;
        _ -> XYL = []
    end,
    XYL.
