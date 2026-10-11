%%-----------------------------------------------------------------------------
%% @Module  :       mod_guild_boss
%% @Author  :       Czc
%% @Email   :       389853407@qq.com
%% @Created :       2017-11-07
%% @Description:    公会Boss
%%-----------------------------------------------------------------------------
-module(mod_guild_boss).

-include("guild.hrl").
-include("common.hrl").
-include("errcode.hrl").
-include("guild_boss.hrl").
-include("def_module.hrl").
-include("auction_module.hrl").
-include("scene.hrl").
-include("guild_feast.hrl").
-include("battle.hrl").
-include("goods.hrl").
-include("def_fun.hrl").
-include("def_id_create.hrl").

-export([start_link/0]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-compile([export_all]).

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

init([]) ->
    GBossMap = init_from_db(),
    save_gboss_map(GBossMap),
    %Ref = erlang:send_after(?REF_UPDATE_INTERVAL * 1000, self(), 'save_gboss_hp'),
    %put(?REF_UPDATE_GBOSS_HP, Ref),
    {ok, []}.

%% 发送公会Boss信息
send_gboss_info(RoleId, GuildId) ->
    gen_server:cast(?MODULE, {'send_gboss_info', RoleId, GuildId}).

%% 检查boss时候要开启
timer_check() ->
    gen_server:cast(?MODULE, {'timer_check'}).

%% 开启公会Boss
open_gboss() ->
    gen_server:cast(?MODULE, {'open_gboss'}).

gm_open_gboss() ->
    gen_server:cast(?MODULE, {'gm_open_gboss'}).

set_auto_drumup(RoleId, GuildId, IsAuto) ->
    gen_server:cast(?MODULE, {'set_auto_drumup', RoleId, GuildId, IsAuto}).

%% 上交兽粮
% add_gboss_mat(RoleId, GuildId, GoodsNum, DonateReward) ->
%     gen_server:cast(?MODULE, {'add_gboss_mat', RoleId, GuildId, GoodsNum, DonateReward}).

add_gboss_mat(RoleId, GuildId, GGragonVal, ProductType) when GuildId > 0 ->
    gen_server:cast(?MODULE, {'add_gboss_mat', RoleId, GuildId, GGragonVal, ProductType});
add_gboss_mat(_RoleId, _GuildId, _GGragonVal, _ProductType) ->
    ok.

%% 召集
drum_up(RoleId, GuildId) ->
    gen_server:cast(?MODULE, {'drum_up', RoleId, GuildId}).

enter_guild_boss(GuildId, RoleId) ->
    gen_server:cast(?MODULE, {'enter_guild_boss', GuildId, RoleId}).

leave_guild_boss(GuildId, RoleId) ->
    gen_server:cast(?MODULE, {'leave_guild_boss', GuildId, RoleId}).

collect_checker(ModId, ModCfgId, A) ->
    gen_server:call(?MODULE, {'collect_checker', ModId, ModCfgId, A}).

%% 击杀boss
kill_mon(Atter, MonInfo) ->
    #scene_object{scene = SceneId, mod_args = ModArgs} = MonInfo,
    #battle_return_atter{id = AtterId, real_name = AtterName, guild_id = GuildId} = Atter,
    case SceneId == data_guild_feast:get_cfg(scene_id) of
        true ->
            case ModArgs of
                {gboss, GuildId} ->
                    gen_server:cast(?MODULE, {'kill_mon', GuildId, AtterId, AtterName});
                _ ->
                    ?INFO("guild_boss, kill mon, err : ~p~n", [{ModArgs, AtterId, GuildId}]),
                    skip
            end;
        _ ->
            skip
    end.

%% hurt boss
hurt_mon(Atter, MonInfo) ->
    #scene_object{scene = SceneId, mod_args = ModArgs} = MonInfo,
    #battle_return_atter{id = AtterId, real_name = AtterName, guild_id = GuildId} = Atter,
    case SceneId == data_guild_feast:get_cfg(scene_id) of
        true ->
            case ModArgs of
                {gboss, GuildId} ->
                    gen_server:cast(?MODULE, {'hurt_mon', GuildId, AtterId, AtterName});
                _ ->
                    ?INFO("guild_boss, hurt_mon, err : ~p~n", [{ModArgs, AtterId, GuildId}]),
                    skip
            end;
        _ ->
            skip
    end.

be_collected(CollectorId, AId, Mid, SceneId, CopyId) ->
    case SceneId == data_guild_feast:get_cfg(scene_id) of
        true ->
            GuildId = CopyId,
            gen_server:cast(?MODULE, {'be_collected', CollectorId, GuildId, AId, Mid});
        _ ->
            skip
    end.

gboss_end() ->
    gen_server:cast(?MODULE, {'gboss_end'}).

reset_gboss_times() ->
    gen_server:cast(?MODULE, {'reset_gboss_times'}).

daily_timer(_Delay) ->
    gen_server:cast(?MODULE, 'daily_timer').

%% 更新当前公会Boss的血量
% update_boss_hp(MonSceneObj, CurHp, _AttackerList, Args) ->
%     NowTime = utime:unixtime(),
%     case Args of
%         [GuildId, LastUtime] when NowTime - LastUtime >= 1 orelse CurHp == 0 ->
%             gen_server:cast(?MODULE, {'update_boss_hp', GuildId, MonSceneObj#scene_object.copy_id, CurHp}),
%             {ok, [GuildId, NowTime]};
%         _ -> skip
%     end.

%% 公会解散
% guild_disband(GuildId) ->
%     gen_server:cast(?MODULE, {'guild_disband', GuildId}).

%% 服务器重启后重新开启当前公会挑战Boss的副本进程
% restart_pid(GuildId, DunPid) ->
%     gen_server:cast(?MODULE, {'restart_pid', GuildId, DunPid}).

% send_next_drum_up_time(RoleId, GuildId, CurDunId) ->
%     gen_server:cast(?MODULE, {'send_next_drum_up_time', RoleId, GuildId, CurDunId}).

% gboss_fight_end(GuildId, Result, AucTionReward) ->
%     gen_server:cast(?MODULE, {'gboss_fight_end', GuildId, Result, AucTionReward}).

%% 获取公会Boss的开启状态
get_gboss_status(GuildId) ->
    gen_server:call(?MODULE, {'get_gboss_status', GuildId}).

get_gboss_open_status() ->
    gen_server:call(?MODULE, {'get_gboss_open_status'}).

%% 节点关闭时关闭
stop() ->
    gen_server:call(?MODULE, 'stop').

handle_cast(Msg, State) ->
    case catch do_handle_cast(Msg, State) of
        {ok, NewState} ->
            {noreply, NewState};
        Err ->
            ?ERR("handle_cast Msg:~p error:~p~n", [Msg, Err]),
            {noreply, State}
    end.

do_handle_cast({'send_gboss_info', RoleId, GuildId}, State) ->
    GBossMap = get_gboss_map(),
    NowTime = utime:unixtime(),
    ChallengeTimesLimit = data_guild_boss:get_cfg(challenge_times_limit),
    case get_open_state() of
        {OpTime, AutoDrumTime, EndTime, _Ref} -> ok;
        _ -> OpTime = 0, AutoDrumTime = 1, EndTime = 0
    end,
    #status_gboss{
        dun_id = DunId,
        mon_state = MonState,
        %hp = Hp,
        gboss_mat = GBossMat,
        challenge_times = ChallengeTimes,
        last_drum_up_time = LastDrumUpTime,
        auto_drumup = AutoDrumup
    } = maps:get(GuildId, GBossMap, #status_gboss{}),
    case OpTime > 0 andalso NowTime < EndTime of
        true ->
            RealDunId = DunId,
            Etime = EndTime;
            %RealHp = Hp;
        false ->
            WoldLv = util:get_world_lv(),
            % GuildAverageLv = mod_guild:get_guild_average_lv(GuildId, 3),
            % MonLv = min(WoldLv, GuildAverageLv),
            RealDunId = data_guild_boss:get_dun_id(WoldLv),
            Etime = 0
            %RealHp = 0
    end,
    IsDrumupToday = ?IF(utime:is_same_day(NowTime, LastDrumUpTime), 1, 0),
    IsKillMon = ?IF(IsDrumupToday == 1 andalso MonState == 0, 1, 2),
    ?PRINT("send_gboss_info  :~p~n", [{Etime, AutoDrumTime, RealDunId, GBossMat, max(0, ChallengeTimesLimit - ChallengeTimes), AutoDrumup, IsDrumupToday, IsKillMon}]),
    {ok, BinData} = pt_402:write(40201, [Etime, AutoDrumTime, RealDunId, GBossMat, max(0, ChallengeTimesLimit - ChallengeTimes), AutoDrumup, IsDrumupToday, IsKillMon]),
    lib_server_send:send_to_uid(RoleId, BinData),
    {ok, State};

do_handle_cast({'timer_check'}, State) ->
    case is_open_gboss() of
        false ->
            case check_otime_in_cfg() of
                true ->
                    mod_guild_boss:open_gboss();
                _ ->
                    ok
            end;
        true ->
            ok
    end,
    {ok, State};

do_handle_cast({'open_gboss'}, State) ->
    case is_open_gboss() of
        false ->
            reset_war_state(),
            OpTime = utime:unixtime(),
            {_StarTime, EndTime} = get_gboss_time(),
            %Duration = data_guild_boss:get_cfg(duration),
            BossWaitTime = data_guild_feast:get_cfg(guild_boss_wait_time),
            util:send_after([], BossWaitTime*1000, self(), {auto_drumup}),
            Ref = util:send_after([], (EndTime - OpTime)*1000, self(), {end_gboss}),
            put({?MODULE, open}, {OpTime, OpTime+BossWaitTime, EndTime, Ref}),
            % ?INFO("open_gboss ########## :~p~n", [{start, OpTime, OpTime+BossWaitTime, EndTime}]),
            % AverageGuildLvList = mod_guild:get_all_guild_average_lv(3),
            % auto_drumup(AverageGuildLvList),
            %% 日志
            lib_log_api:log_guild_boss(0, 1, OpTime),
            %% 发送传闻
            lib_chat:send_TV({all_guild}, ?MOD_GUILD_ACT, 25, []);
        true ->
            _Errcode = ?ERRCODE(err402_gboss_has_open)
    end,
    {ok, State};

do_handle_cast({'gm_open_gboss'}, State) ->
    case is_open_gboss() of
        false ->
            reset_war_state(),
            OpTime = utime:unixtime(),
            %{_StarTime, EndTime} = get_gboss_time(),
            EndTime = OpTime + 3600,
            %Duration = data_guild_boss:get_cfg(duration),
            BossWaitTime = data_guild_feast:get_cfg(guild_boss_wait_time),
            util:send_after([], BossWaitTime*1000, self(), {auto_drumup}),
            Ref = util:send_after([], (EndTime - OpTime)*1000, self(), {end_gboss}),
            put({?MODULE, open}, {OpTime, OpTime+BossWaitTime, EndTime, Ref}),
            ?PRINT("gm_open_gboss : ~p~n", [start]),
            %% 日志
            lib_log_api:log_guild_boss(0, 1, OpTime),
            %% 发送传闻
            lib_chat:send_TV({all_guild}, ?MOD_GUILD_ACT, 25, []);
        true ->
            skip
    end,
    {ok, State};


do_handle_cast({'set_auto_drumup', RoleId, GuildId, IsAuto} , State) ->
    GBossMap = get_gboss_map(),
    case maps:get(GuildId, GBossMap, false) of
        GBossR when is_record(GBossR, status_gboss) -> skip;
        _ -> GBossR = #status_gboss{guild_id = GuildId}
    end,
    NewGBossR = GBossR#status_gboss{auto_drumup = IsAuto},
    db_replace_status_gboss(NewGBossR),
    NewGBossMap = maps:put(GuildId, NewGBossR, GBossMap),
    save_gboss_map(NewGBossMap),
    {ok, BinData} = pt_402:write(40209, [?SUCCESS, IsAuto]),
    ?PRINT("set_auto_drumup:~p~n", [IsAuto]),
    lib_server_send:send_to_uid(RoleId, BinData),
    {ok, State};

do_handle_cast({'add_gboss_mat', RoleId, GuildId, GGragonVal, ProductType}, State) ->
    GBossMap = get_gboss_map(),
    case maps:get(GuildId, GBossMap, false) of
        GBossR when is_record(GBossR, status_gboss) -> skip;
        _ -> GBossR = #status_gboss{guild_id = GuildId}
    end,
    #status_gboss{
        gboss_mat = CurGBossMat
    } = GBossR,
    ExchangeRatio = data_guild_boss:get_cfg(exchange_ratio),
    NewGBossMat = CurGBossMat + round(ExchangeRatio * GGragonVal),
    NewGBossR = GBossR#status_gboss{gboss_mat = NewGBossMat},
    ?PRINT("add_gboss_mat NewGBossR: ~p~n", [NewGBossR]),
    db_replace_status_gboss(NewGBossR),
    NewGBossMap = maps:put(GuildId, NewGBossR, GBossMap),
    save_gboss_map(NewGBossMap),
    DonateReward = data_guild_boss:get_cfg(gboss_mat_donate_reward),
    NewDonateReward = [{Type, GTypeId, GNum*GGragonVal} ||{Type, GTypeId, GNum} <- DonateReward],
    %% 日志
    lib_log_api:log_gboss_mat(GuildId, RoleId, 1, GGragonVal, NewGBossMat, ProductType),
    case NewDonateReward =/= [] of
        true ->
            lib_goods_api:send_reward_by_id(NewDonateReward, gboss_mat_donate_reward, RoleId);
        _ -> skip
    end,
    {ok, BinData} = pt_402:write(40203, [GGragonVal, NewGBossMat]),
    lib_server_send:send_to_uid(RoleId, BinData),
    {ok, State};

do_handle_cast({'drum_up', RoleId, GuildId}, State) ->
    ?PRINT("drum_up########:~p~n", [start]),
    case is_open_gboss() of
        true ->
            {_OpTime, AutoDrumTime, _EndTime, _Ref} = get_open_state(),
            case utime:unixtime() >= AutoDrumTime of
                true ->
                    GBossMap = get_gboss_map(),
                    ChallengeTimesLimit = data_guild_boss:get_cfg(challenge_times_limit),
                    WoldLv = util:get_world_lv(),
                    GuildAverageLv = mod_guild:get_guild_average_lv(GuildId, 3),
                    MonLv = min(WoldLv, GuildAverageLv),
                    ?PRINT("drum_up########:~p~n", [MonLv]),
                    case drum_up_boss(RoleId, GuildId, MonLv, GBossMap, ChallengeTimesLimit) of
                        {ok, NewGBossMap} ->
                            save_gboss_map(NewGBossMap);
                        {false, Res} ->
                            lib_server_send:send_to_uid(RoleId, pt_402, 40200, [Res])
                    end;
                _ ->
                    lib_server_send:send_to_uid(RoleId, pt_402, 40200, [?ERRCODE(err402_not_drum_time)])
            end;
        false ->
            ?PRINT("drum_up########:~p~n", [111]),
            lib_server_send:send_to_uid(RoleId, pt_402, 40200, [?ERRCODE(err402_gboss_open_no_mat)])
    end,
    {ok, State};

do_handle_cast({'enter_guild_boss', GuildId, RoleId}, State) ->
    GBossMap = get_gboss_map(),
    case maps:get(GuildId, GBossMap, 0) of
        #status_gboss{role_list = RoleList} = GBossR ->
            case lists:keyfind(RoleId, #gboss_role.role_id, RoleList) of
                #gboss_role{} = GBossRole -> NewGBossRole = GBossRole#gboss_role{is_enter = 1};
                _ -> NewGBossRole = #gboss_role{role_id = RoleId, is_enter = 1}
            end,
            NewRoleList = lists:keystore(RoleId, #gboss_role.role_id, RoleList, NewGBossRole),
            ?PRINT("enter_guild_boss########:~p~n", [NewRoleList]),
            NewGBossR = GBossR#status_gboss{role_list = NewRoleList},
            NewGBossMap = maps:put(GuildId, NewGBossR, GBossMap),
            save_gboss_map(NewGBossMap);
        _ ->
            ok
    end,
    {ok, State};

do_handle_cast({'leave_guild_boss', GuildId, RoleId}, State) ->
    GBossMap = get_gboss_map(),
    case maps:get(GuildId, GBossMap, 0) of
        #status_gboss{role_list = RoleList, mon_state = MonState} = GBossR ->
            case lists:keyfind(RoleId, #gboss_role.role_id, RoleList) of
                #gboss_role{is_show = IsShow} = GBossRole ->
                    case MonState == 1 andalso IsShow == 0 of
                        true ->
                            NewIsShow = 1;
                            % case IsHit > 0 andalso length(AucTionRewardList) > 0 of
                            %     true ->
                            %         %% 弹框
                            %         _GoodsTypeList = lib_auction_api:trans_to_goods_list(AucTionRewardList);
                            %         %?PRINT("send_gboss_reward GoodsTypeList:~p~n", [GoodsTypeList]),
                            %         %{ok, Bin} = pt_402:write(40208, [3, [], GoodsTypeList]),
                            %         %lib_server_send:send_to_uid(RoleId, Bin);
                            %     _ ->
                            %         skip
                            % end;
                        _ ->
                            NewIsShow = IsShow
                    end,
                    NewGBossRole = GBossRole#gboss_role{is_show = NewIsShow},
                    NewRoleList = lists:keyreplace(RoleId, #gboss_role.role_id, RoleList, NewGBossRole),
                    ?PRINT("leave_guild_boss########:~p~n", [NewRoleList]),
                    NewGBossR = GBossR#status_gboss{role_list = NewRoleList},
                    NewGBossMap = maps:put(GuildId, NewGBossR, GBossMap),
                    save_gboss_map(NewGBossMap);
                _ -> ok
            end;
        _ ->
            ok
    end,
    {ok, State};

do_handle_cast({'kill_mon', GuildId, RoleId, _AtterName}, State) ->
    GBossMap = get_gboss_map(),
    case get_war_state() == 0 of
        true ->
            case maps:get(GuildId, GBossMap, 0) of
                #status_gboss{dun_id = DunId, role_list = RoleList} = GBossR ->
                    ?PRINT("kill_mon########:~p~n", [start]),
                    case lists:keyfind(RoleId, #gboss_role.role_id, RoleList) of
                        #gboss_role{} = GBossRole -> NewGBossRole = GBossRole#gboss_role{is_hurt = 1};
                        _ -> NewGBossRole = #gboss_role{role_id = RoleId, is_enter = 1, is_hurt = 1}
                    end,
                    NewRoleList = lists:keystore(RoleId, #gboss_role.role_id, RoleList, NewGBossRole),
                    #gboss_dun_cfg{fix_reward = _FixReward} = data_guild_boss:get_gboss_cfg(DunId),
                    HitPlayerNum = length([1||#gboss_role{is_hurt = IsHit} <- NewRoleList, IsHit == 1]),
                    %% 钻石拍品产出 ## 不产出拍卖
                    AucTionRewardList = [],
                    % ProductValue = data_guild_boss:get_cfg(product_fix_val) + HitPlayerNum * data_guild_boss:get_cfg(product_ratio),
                    % TotalWeight = calc_total_weight(AucTionReward),
                    % NormalAuctionReward1 = calc_notmal_auction_reward(ProductValue, TotalWeight, AucTionReward),
                    % RareAuctionReward1 = calc_rare_auction_reward(ProductValue, TotalWeight, AucTionReward),
                    % AucTionRewardList1 = NormalAuctionReward1 ++ RareAuctionReward1,
                    % %% 绑钻拍品产出
                    % BGoldProductValue = data_guild_boss:get_cfg(bgold_product_fix_val) + HitPlayerNum * data_guild_boss:get_cfg(bgold_product_ratio),
                    % BGoldTotalWeight = calc_total_weight(BGoldAuctionReward),
                    % NormalAuctionReward2 = calc_notmal_auction_reward(BGoldProductValue, BGoldTotalWeight, BGoldAuctionReward),
                    % RareAuctionReward2 = calc_rare_auction_reward(BGoldProductValue, BGoldTotalWeight, BGoldAuctionReward),
                    % AucTionRewardList2 = NormalAuctionReward2 ++ RareAuctionReward2,
                    % %% 拍品汇总
                    % AucTionRewardList = AucTionRewardList1 ++ AucTionRewardList2,
                    % AuthenticationId = mod_id_create:get_new_id(?AUTHENTICATION_ID_CREATE),
                    % InAuctionPlayerList = [{AuthenticationId, RoleIdA, GuildId, ?AUCTION_MOD_GUILD_BOSS}||{RoleIdA, _, IsHit, _} <- NewRoleList, IsHit>0],
                    % lib_act_join_api:add_authentication_player(InAuctionPlayerList),
                    % lib_auction_api:start_guild_auction(?AUCTION_MOD_GUILD_BOSS, AuthenticationId, [{GuildId, AucTionRewardList}]),
                    %% 计算掉落宝箱
                    CreateNum = max(10, HitPlayerNum * 2),
                    XYlist = ulists:list_shuffle(data_guild_boss:get_cfg(boss_drop_xy)),
                    MonId = data_guild_boss:get_cfg(boss_drop_id),
                    SceneId = data_guild_feast:get_cfg(scene_id),
                    PoolId = ?DEF_SCENE_PID,
                    CopyId = GuildId,
                    F = fun(_I, {AccMon, RandList}) ->
                        case RandList of
                            [{X, Y}|T] -> NewRandList = T;
                            _ -> [{X, Y}|T] = XYlist, NewRandList = T
                        end,
                        MId = lib_mon:sync_create_mon(MonId, SceneId, PoolId, X, Y, 0, CopyId, 1, []),
                        {[{MId, 0}|AccMon], NewRandList}
                    end,
                    {DropMonList, _} = lists:foldl(F, {[], XYlist}, lists:seq(1, CreateNum)),
                    ?PRINT("kill_mon######## DropMonList:~p~n", [{CreateNum, DropMonList}]),
                    DropMonExpireRef = util:send_after([], 120000, self(), {clear_drop_mon, GuildId}),
                    DropMonExpireTime = utime:unixtime() + 120,
                    NewGBossR = GBossR#status_gboss{
                        mon_state = 1, auction_reward = AucTionRewardList, role_list = NewRoleList, drop_mon_list = DropMonList,
                        drop_mon_expire_time = DropMonExpireTime, drop_mon_expire_ref = DropMonExpireRef
                    },
                    NewGBossMap = maps:put(GuildId, NewGBossR, GBossMap),
                    save_gboss_map(NewGBossMap),
                    %send_gboss_reward(1, GuildId, NewRoleList, FixReward, AucTionRewardList),
                    {ok, BinData} = pt_402:write(40204, [2, RoleId]),
                    lib_server_send:send_to_guild(GuildId, BinData);
                _ ->
                    ok
            end;
        _ ->
            ok
    end,
    {ok, State};

do_handle_cast({'hurt_mon', GuildId, RoleId, _AtterName}, State) ->
    GBossMap = get_gboss_map(),
    case get_war_state() == 0 of
        true ->
            case maps:get(GuildId, GBossMap, 0) of
                #status_gboss{dun_id = _DunId, role_list = RoleList} = GBossR ->
                    case lists:keyfind(RoleId, #gboss_role.role_id, RoleList) of
                        #gboss_role{is_hurt = 1} -> ok;
                        #gboss_role{} = GBossRole ->
                            NewGBossRole = GBossRole#gboss_role{is_hurt = 1},
                            NewRoleList = lists:keyreplace(RoleId, #gboss_role.role_id, RoleList, NewGBossRole),
                            NewGBossR = GBossR#status_gboss{role_list = NewRoleList},
                            NewGBossMap = maps:put(GuildId, NewGBossR, GBossMap),
                            save_gboss_map(NewGBossMap);
                        _ ->
                            NewGBossRole = #gboss_role{role_id = RoleId, is_enter = 1, is_hurt = 1},
                            NewRoleList = lists:keystore(RoleId, #gboss_role.role_id, RoleList, NewGBossRole),
                            NewGBossR = GBossR#status_gboss{role_list = NewRoleList},
                            NewGBossMap = maps:put(GuildId, NewGBossR, GBossMap),
                            save_gboss_map(NewGBossMap)
                    end;
                _ ->
                    ok
            end;
        _ ->
            ok
    end,
    {ok, State};

do_handle_cast({'be_collected', RoleId, GuildId, AId, Mid}, State) ->
    GBossMap = get_gboss_map(),
    case maps:get(GuildId, GBossMap, 0) of
        #status_gboss{dun_id = _DunId, role_list = RoleList, drop_mon_list = DropMonList} = GBossR ->
            case lists:keyfind(RoleId, #gboss_role.role_id, RoleList) of
                #gboss_role{clt_list = CltList} = GBossRole ->
                    NewGBossRole = GBossRole#gboss_role{clt_list = [Mid|CltList]},
                    NewRoleList = lists:keyreplace(RoleId, #gboss_role.role_id, RoleList, NewGBossRole),
                    NewDropMonList = lists:keydelete(AId, 1, DropMonList),
                    %% 发奖励
                    GoodsTypeId = data_guild_boss:get_cfg(boss_drop_goods),
                    RewardList = [{?TYPE_GOODS, GoodsTypeId, 1}],
                    lib_server_send:send_to_uid(RoleId, pt_402, 40210, [RewardList]),
                    Produce = #produce{type = gboss, reward = RewardList, show_tips = ?SHOW_TIPS_4},
                    lib_goods_api:send_reward_by_id(Produce, RoleId),
                    NewGBossR = GBossR#status_gboss{role_list = NewRoleList, drop_mon_list = NewDropMonList},
                    NewGBossMap = maps:put(GuildId, NewGBossR, GBossMap),
                    ?PRINT("be_collected######## RewardList:~p~n", [{RoleId, RewardList}]),
                    ?PRINT("be_collected######## NewDropMonList:~p~n", [NewDropMonList]),
                    save_gboss_map(NewGBossMap);
                _ ->
                    ok
            end;
        _ ->
            ok
    end,
    {ok, State};

do_handle_cast('daily_timer', State) ->
    case utime:day_of_week() of
        Week when Week == 1 ->
            db:execute(io_lib:format(?sql_reset_challenge_times, [])),
            GBossMap = get_gboss_map(),
            F = fun(_TmpGuildId, TmpGBossR) ->
                TmpGBossR#status_gboss{challenge_times = 0}
            end,
            NewGBossMap = maps:map(F, GBossMap),
            save_gboss_map(NewGBossMap);
        _ -> skip
    end,
    {ok, State};

do_handle_cast({'reset_gboss_times'}, State) ->
    db:execute(io_lib:format(?sql_reset_challenge_times, [])),
    GBossMap = get_gboss_map(),
    F = fun(_TmpGuildId, TmpGBossR) ->
        TmpGBossR#status_gboss{challenge_times = 0, last_drum_up_time = 0}
    end,
    NewGBossMap = maps:map(F, GBossMap),
    save_gboss_map(NewGBossMap),
    {ok, State};

do_handle_cast({'gboss_end'}, State) ->
    ?PRINT("gboss_end########   :~p~n", [ok]),
    end_gboss(),
    {ok, State};

% do_handle_cast({'update_boss_hp', _GuildId, _CopyId, _Hp}, State) ->
%     % case is_open_gboss() of
%     %     true ->
%     %         GBossMap = get_gboss_map(),
%     %         case maps:get(GuildId, GBossMap, false) of
%     %             #status_gboss{
%     %                 dun_pid = DunPid
%     %                 } = GBossR when DunPid == CopyId ->
%     %                 NewGBossR = case Hp > 0 of
%     %                     true ->
%     %                         GBossR#status_gboss{hp = Hp};
%     %                     false -> %% 如果血量传过来是0则判断为公会Boss已经被击杀
%     %                         NowTime = utime:unixtime(),
%     %                         db:execute(io_lib:format(?sql_kill_guild_boos, [GuildId])),
%     %                         GBossR#status_gboss{kill_time = NowTime, hp = 0, optime = 0, dun_pid = undefine}
%     %                 end,
%     %                 NewGBossMap = GBossMap#{GuildId => NewGBossR},
%     %                 save_gboss_map(NewGBossMap);
%     %             _ -> skip
%     %         end;
%     %     false -> skip
%     % end,
%     {ok, State};

% do_handle_cast({'guild_disband', _GuildId}, State) ->
%     % GBossMap = get_gboss_map(),
%     % NewGBossMap = maps:remove(GuildId, GBossMap),
%     % save_gboss_map(NewGBossMap),
%     {ok, State};

% do_handle_cast({'restart_pid', _GuildId, _DunPid}, State) ->
%     % case is_open_gboss() of
%     %     true ->
%     %         GBossMap = get_gboss_map(),
%     %         #{GuildId := GBossR} = GBossMap,
%     %         NewGBossR = GBossR#status_gboss{dun_pid = DunPid},
%     %         NewGBossMap = GBossMap#{GuildId => NewGBossR},
%     %         save_gboss_map(NewGBossMap);
%     %     false -> skip
%     % end,
%     {ok, State};

% do_handle_cast({'send_next_drum_up_time', _RoleId, _GuildId, _CurDunId}, State) ->
%     % case is_open_gboss() of
%     %     true ->
%     %         GBossMap = get_gboss_map(),
%     %         #{GuildId := GBossR} = GBossMap,
%     %         DrumUpCd = data_guild_boss:get_cfg(drum_up_cd),
%     %         #status_gboss{dun_id = DunId, last_drum_up_time = LastDrumUpTime} = GBossR,
%     %         case CurDunId == DunId of
%     %             true ->
%     %                 {ok, BinData} = pt_402:write(40206, [LastDrumUpTime + DrumUpCd]),
%     %                 lib_server_send:send_to_uid(RoleId, BinData);
%     %             false -> skip
%     %         end;
%     %     false -> skip
%     % end,
%     {ok, State};

% do_handle_cast({'gboss_fight_end', GuildId, _Result, AucTionReward}, State) ->
%     ?PRINT("gboss_fight_end######## AucTionReward  :~p~n", [AucTionReward]),
%     GBossMap = get_gboss_map(),
%     case maps:get(GuildId, GBossMap, 0) of
%         #status_gboss{} = GBossR ->
%             NewGBossR = GBossR#status_gboss{auction_reward = AucTionReward},
%             NewGBossMap = maps:put(GuildId, NewGBossR, GBossMap),
%             ?PRINT("gboss_fight_end########   :~p~n", [ok]),
%             save_gboss_map(NewGBossMap);
%         _ ->
%             ok
%     end,
%     {ok, State};

do_handle_cast(_Msg, State) -> {ok, State}.

handle_info(Info, State) ->
    case catch do_handle_info(Info, State) of
        {ok, NewState} ->
            {noreply, NewState};
        Err ->
            ?ERR("handle_info Info:~p error:~p~n", [Info, Err]),
            {noreply, State}
    end.

%% 定时保存Boss的血量到数据库
do_handle_info('save_gboss_hp', State) ->
    % ORef = get(?REF_UPDATE_GBOSS_HP),
    % util:cancel_timer(ORef),
    % Ref = erlang:send_after(?REF_UPDATE_INTERVAL * 1000, self(), 'save_gboss_hp'),
    % put(?REF_UPDATE_GBOSS_HP, Ref),
    % save_gboss_hp(),
    {ok, State};

do_handle_info({auto_drumup}, State) ->
    case is_open_gboss() of
        true ->
            AverageGuildLvList = mod_guild:get_all_guild_average_lv(3),
            ?PRINT("auto_drumup:~p~n", [AverageGuildLvList]),
            auto_drumup(AverageGuildLvList);
        _ ->
            skip
    end,
    {ok, State};

do_handle_info({clear_drop_mon, GuildId}, State) ->
    GBossMap = get_gboss_map(),
    case maps:get(GuildId, GBossMap, 0) of
        #status_gboss{drop_mon_list = DropMonList} = GBossR ->
            case DropMonList of
                [] -> NewDropMonList = [];
                _ ->
                    SceneId = data_guild_feast:get_cfg(scene_id),
                    PoolId = ?DEF_SCENE_PID,
                    NewDropMonList = [{MonId, MonS} ||{MonId, MonS} <- DropMonList, MonS == 1],
                    lib_mon:clear_scene_mon_by_ids(SceneId, PoolId, 1, [MonId ||{MonId, MonS} <- DropMonList, MonS == 0])
            end,
            NewGBossR = GBossR#status_gboss{
                drop_mon_list = NewDropMonList, drop_mon_expire_time = 0, drop_mon_expire_ref = none
            },
            NewGBossMap = maps:put(GuildId, NewGBossR, GBossMap),
            save_gboss_map(NewGBossMap),
            {ok, State};
        _ ->
            {ok, State}
    end;

do_handle_info({end_gboss}, State) ->
    end_gboss(),
    {ok, State};

do_handle_info(_Info, State) -> {ok, State}.

handle_call(Request, _From, State) ->
    case catch do_handle_call(Request, State) of
        {ok, Reply} ->
            {reply, Reply, State};
        Err ->
            ?ERR("handle_call Request:~p error:~p~n", [Request, Err]),
            {noreply, State}
    end.

do_handle_call({'get_gboss_open_status'}, _State) ->
    case is_open_gboss() of
        true -> {ok, true};
        _ -> {ok, false}
    end;

do_handle_call({'get_gboss_status', GuildId}, _State) ->
    OpenStatus = is_open_gboss(),
    GBossMap = get_gboss_map(),
    GBossR = maps:get(GuildId, GBossMap, #status_gboss{}),
    {ok, {OpenStatus, GBossR}};

do_handle_call({'collect_checker', ModId, _ModCfgId, {RoleId, GuildId}}, _State) ->
    GBossMap = get_gboss_map(),
    case maps:get(GuildId, GBossMap, 0) of
        #status_gboss{role_list = RoleList, drop_mon_list = DropMonList} = GBossR ->
            case lists:keyfind(RoleId, #gboss_role.role_id, RoleList) of
                #gboss_role{is_hurt = 1, clt_list = CltList} ->
                    IsDropMon = lists:keymember(ModId, 1, DropMonList),
                    %?PRINT("collect_checker : ~p~n", [{ModId, DropMonList}]),
                    CltMax = ?IF(length(CltList) >= 2, true, false),
                    if
                        IsDropMon == false -> {ok, {false, 6}};
                        CltMax -> {ok, {false, 7}};
                        true ->
                            NewDropMonList = lists:keyreplace(ModId, 1, DropMonList, {ModId, 1}),
                            NewGBossR = GBossR#status_gboss{drop_mon_list = NewDropMonList},
                            NewGBossMap = maps:put(GuildId, NewGBossR, GBossMap),
                            save_gboss_map(NewGBossMap),
                            {ok, true}
                    end;
                _ ->
                    {ok, {false, 25}}
            end;
        _ ->
            {ok, {false, 6}}
    end;


do_handle_call('stop', _State) ->
    %save_gboss_hp(),
    {ok, ok};

do_handle_call(_Request, _State) -> {ok, ok}.

terminate(_Reason, _State) ->
    ?ERR("~p is terminate:~p", [?MODULE, _Reason]),
    ok.

code_change(_OldVsn, State, _Extra) -> {ok, State}.

get_gboss_map() ->
    case get(?P_GUILD_BOSS) of
        undefined ->
            GBossMap = init_from_db(),
            save_gboss_map(GBossMap),
            GBossMap;
        Val -> Val
    end.

save_gboss_map(GBossMap) ->
    put(?P_GUILD_BOSS, GBossMap).

init_from_db() ->
    List = db:get_all(io_lib:format(?sql_select_guild_boss, [])),
    F = fun([GuildId, DunId, OpTime, Hp, GBossMat, ChallengeTimes, AutoDrumup, LastDrumUpTime], AccMap) ->
        TmpR = #status_gboss{
            guild_id = GuildId,
            dun_id = DunId,
            optime = OpTime,
            hp = Hp,
            gboss_mat = GBossMat,
            challenge_times = ChallengeTimes,
            last_drum_up_time = LastDrumUpTime,
            auto_drumup = AutoDrumup
        },
        maps:put(GuildId, TmpR, AccMap)
    end,
    lists:foldl(F, #{}, List).

%%% 自动召集bos
auto_drumup(AverageGuildLvList) ->
    GBossMap = get_gboss_map(),
    ChallengeTimesLimit = data_guild_boss:get_cfg(challenge_times_limit),
    WoldLv = util:get_world_lv(),
    F = fun(GuildId, GBossR, Map) ->
        #status_gboss{auto_drumup = AutoDrumup} = GBossR,
        case AutoDrumup > 0 of
            true ->
                {_, GuildAverageLv} = ulists:keyfind(GuildId, 1, AverageGuildLvList, {GuildId, WoldLv}),
                MonLv = min(WoldLv, GuildAverageLv),
                ?PRINT("auto_drumup########:~p~n", [{GuildId, MonLv}]),
                case drum_up_boss(0, GuildId, MonLv, Map, ChallengeTimesLimit) of
                    {ok, NewMap} ->
                        {ok, BinData} = pt_402:write(40204, [?SUCCESS, 0]),
                        lib_server_send:send_to_guild(GuildId, BinData),
                        NewMap;
                    {false, _Res} ->
                        Map
                end;
            _ ->
                Map
        end
    end,
    NewGBossMap = maps:fold(F, GBossMap, GBossMap),
    save_gboss_map(NewGBossMap).
%% 召集单个公会boss
drum_up_boss(RoleId, GuildId, MonLv, GBossMap, ChallengeTimesLimit) ->
    ?PRINT("drum_up_boss########:~p~n", [start]),
    case maps:get(GuildId, GBossMap, 0) of
        #status_gboss{challenge_times = ChallengeTimes} when ChallengeTimes >= ChallengeTimesLimit ->
            {false, ?ERRCODE(err402_no_challenge_times)};
        #status_gboss{gboss_mat = GBossMat, challenge_times = ChallengeTimes, last_drum_up_time = LastDrumUpTime} = GBossR ->
            NeedGBossMat = get_gboss_mat_cost(ChallengeTimes+1),
            {OpTime, _AutoDrumTime, EndTime, _Ref} = get_open_state(),
            if
                GBossMat < NeedGBossMat ->
                    {false, ?ERRCODE(err402_gboss_open_no_mat)};
                LastDrumUpTime >= OpTime andalso LastDrumUpTime =< EndTime ->
                    {false, ?ERRCODE(err402_gboss_has_open)};
                true ->
                    NowTime = utime:unixtime(),
                    DunId = data_guild_boss:get_dun_id(MonLv),
                    ?PRINT("drum_up_boss######## start DunId:~p~n", [DunId]),
                    create_boss(GuildId, DunId, MonLv),
                    NewGBossMat = GBossMat - NeedGBossMat,
                    NewGBossR = GBossR#status_gboss{
                        dun_id = DunId, challenge_times = ChallengeTimes+1, gboss_mat = NewGBossMat, mon_state = 0,
                        last_drum_up_time = NowTime, role_list = [], drop_mon_list = [], drop_mon_expire_time = 0, drop_mon_expire_ref = none
                    },
                    db_replace_status_gboss(NewGBossR),
                    %% 日志
                    lib_log_api:log_gboss_mat(GuildId, RoleId, 2, NeedGBossMat, NewGBossMat, drum_up),
                    NewGBossMap = GBossMap#{GuildId => NewGBossR},
                    {ok, BinData} = pt_402:write(40204, [?SUCCESS, RoleId]),
                    lib_server_send:send_to_guild(GuildId, BinData),
                    %% 发送传闻
                    lib_chat:send_TV({guild, GuildId}, ?MOD_GUILD_ACT, 4, []),
                    {ok, NewGBossMap}
            end;
        _ ->
            {false, ?ERRCODE(err402_act_close)}
    end.

get_gboss_mat_cost(ChallengeTimes) ->
    CostMatList = data_guild_boss:get_cfg(open_cost_gboss_mat),
    get_gboss_mat_cost(lists:reverse(CostMatList), ChallengeTimes).

get_gboss_mat_cost([], _ChallengeTimes) -> 10000;
get_gboss_mat_cost([{Count, CostNum}|CostMatList], ChallengeTimes) ->
    case ChallengeTimes >= Count of
        true -> CostNum;
        _ -> get_gboss_mat_cost(CostMatList, ChallengeTimes)
    end.


%%%%%%%%%%%%%%%%%%%%%%%%% 公会boss结束
end_gboss() ->
    case get_war_state() of
        0 ->
            ?PRINT("end_gboss ############# start ~n", []),
            NowTime = utime:unixtime(),
            GBossMap = get_gboss_map(),
            F = fun(GuildId, GBossR, {Map, List}) ->
                #status_gboss{
                    dun_id = DunId, challenge_times = ChallengeTimes, last_drum_up_time = LastDrumUpTime, mon_state = MonState, auction_reward = AucTionReward, gboss_mat = OldGMat,
                    role_list = _RoleList, drop_mon_list = DropMonList, drop_mon_expire_ref = DropMonExpireRef
                } = GBossR,
                case DunId > 0 andalso utime:is_same_day(NowTime, LastDrumUpTime) of
                    true ->
                        SceneId = data_guild_feast:get_cfg(scene_id),
                        PoolId = ?DEF_SCENE_PID,
                        CopyId = GuildId,
                        case MonState == 0 of
                            true -> %% 召唤出来的boss没有击杀，失败
                                NewGMat = OldGMat + get_gboss_mat_cost(ChallengeTimes),
                                #gboss_dun_cfg{boss_id = BossId} = data_guild_boss:get_gboss_cfg(DunId),
                                lib_mon:clear_scene_mon_by_mids(SceneId, PoolId, CopyId, 1, [BossId]),
                                db:execute(io_lib:format(?sql_update_guild_boos_mat, [NewGMat, GuildId]));
                                %send_gboss_reward(0, RoleList, SceneId, PoolId, CopyId, [], []);
                            _ ->
                                NewGMat = OldGMat
                        end,
                        %% 清理采集怪
                        util:cancel_timer(DropMonExpireRef),
                        case DropMonList of
                            [] -> skip;
                            _ -> lib_mon:clear_scene_mon_by_ids(SceneId, PoolId, 1, [MonId ||{MonId, _} <- DropMonList])
                        end,
                        NewList = [{GuildId, AucTionReward}|List],
                        NewGBossR = GBossR#status_gboss{
                            dun_id = 0, last_drum_up_time = 0, mon_state = 0, gboss_mat = NewGMat, role_list = [], drop_mon_list = [],
                            drop_mon_expire_time = 0, drop_mon_expire_ref = none
                        },
                        {maps:put(GuildId, NewGBossR, Map), NewList};
                    _ ->
                        {Map, List}
                end
            end,
            {NewGBossMap, _GuildAcutionList} = maps:fold(F, {GBossMap, []}, GBossMap),
            db:execute(io_lib:format(?sql_reset_dun_id, [])),
            save_gboss_map(NewGBossMap),
            close_gboss(),
            set_war_state(1),
            ?PRINT("end_gboss ############# end ~n", []),
            ok;
        _ ->
            ?PRINT("end_gboss : ~p~n", [is_end]),
            ok
    end.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 计算拍卖品
calc_notmal_auction_reward(ProductValue, TotalWeight, AucTionReward) ->
    F = fun({AuctionId, _Weight, ProductRatio, Type}, List) ->
        case Type == ?GBOSS_AUCTION_REWARD_TYPE_1 of
            true ->
                ProductParam = ProductValue*ProductRatio/TotalWeight,
                ProductNum = get_product_num(ProductParam),
                case ProductNum > 0 of
                    true ->
                        List1 = lists:duplicate(ProductNum, {AuctionId, 1}),
                        List1 ++ List;
                    _ ->
                        List
                end;
            _ ->
                List
        end
    end,
    NormalAuctionReward = lists:foldl(F, [], AucTionReward),
    NormalAuctionReward.

calc_rare_auction_reward(ProductValue, TotalWeight, AucTionReward) ->
    RareList = [{AuctionId, Weight, ProductRatio, Type}||{AuctionId, Weight, ProductRatio, Type} <- AucTionReward, Type == ?GBOSS_AUCTION_REWARD_TYPE_2],
    F = fun({_AuctionId, _Weight, ProductRatio, _Type}, Acc) ->
            Acc + ProductRatio
    end,
    AccProductRatio = lists:foldl(F, 0, RareList),
    ProductParam = ProductValue*AccProductRatio/TotalWeight,
    ProductNum = get_product_num(ProductParam),
    case ProductNum > 0 of
        true ->
            F2 = fun(_I, List) ->
                {AuctionId, _, _, _} = util:find_ratio(RareList, 2),
                [{AuctionId, 1}|List]
            end,
            lists:foldl(F2, [], lists:seq(1, ProductNum));
        _ ->
            []
    end.

get_product_num(ProductParam) ->
    CeilNum = umath:ceil(ProductParam),
    FloorNum = CeilNum - 1,
    CeilRatio = 10000 - round((CeilNum - ProductParam) * 10000),
    case urand:rand(1, 10000) =< CeilRatio of
        true -> CeilNum;
        _ -> FloorNum
    end.

calc_total_weight(AucTionReward) ->
    WeightList = [Weight||{_AuctionId, Weight, _ProductRatio, _Type} <- AucTionReward],
    lists:sum(WeightList).

%%%%%%%%%%%%%%%%%%%%%%% 发奖励
send_gboss_reward(Result, GuildId, RoleList, FixReward, AucTionRewardList) ->
    SceneId = data_guild_feast:get_cfg(scene_id),
    PoolId = ?DEF_SCENE_PID,
    CopyId = GuildId,
    send_gboss_reward(Result, RoleList, SceneId, PoolId, CopyId, FixReward, AucTionRewardList).

send_gboss_reward(Result, RoleList, SceneId, PoolId, CopyId, FixReward, AucTionRewardList) ->
    spawn(fun() -> send_gboss_reward_helper(Result, RoleList, SceneId, PoolId, CopyId, FixReward, AucTionRewardList) end),
    ok.

send_gboss_reward_helper(Result, RoleList, SceneId, PoolId, CopyId, FixReward, AucTionRewardList) ->
    %?PRINT("send_gboss_reward AucTionRewardList:~p~n", [AucTionRewardList]),
    GoodsTypeList = lib_auction_api:trans_to_goods_list(AucTionRewardList),
    %?PRINT("send_gboss_reward GoodsTypeList:~p~n", [GoodsTypeList]),
    {ok, Bin} = pt_402:write(40208, [Result, FixReward, GoodsTypeList]),
    %?PRINT("send_gboss_reward Bin:~p~n", [Bin]),
    lib_server_send:send_to_scene(SceneId, PoolId, CopyId, Bin),
    Product = #produce{type = gboss, reward = FixReward, show_tips = ?SHOW_TIPS_4},
    F = fun(#gboss_role{role_id = RoleId, is_enter = IsIn, is_hurt = IsHit}, Acc) ->
        case IsIn > 0 andalso IsHit > 0 of
            true ->
                Acc rem 20 == 0 andalso timer:sleep(200),
                lib_goods_api:send_reward_by_id(Product, RoleId),
                Acc+1;
            _ ->
                Acc
        end
    end,
    lists:foldl(F, 1, RoleList).

%%%%%%%%%%%%%%% 创建boss
create_boss(GuildId, DunId, MonLv) ->
    #gboss_dun_cfg{boss_id = BossId} = data_guild_boss:get_gboss_cfg(DunId),
    {X, Y} = data_guild_boss:get_cfg(boss_born_xy),
    SceneId = data_guild_feast:get_cfg(scene_id),
    PoolId = ?DEF_SCENE_PID,
    CopyId = GuildId,
    lib_mon:async_create_mon(BossId, SceneId, PoolId, X, Y, 1, CopyId, 1, [{lv, MonLv}, {auto_lv, MonLv}, {mod_args, {gboss,GuildId}}]).

%%--------------------------------------------------
%% 检测是否处于后台配置开启时间内
%% @return true|false
%%--------------------------------------------------
check_otime_in_cfg() ->
    NowTime = utime:unixtime(),
    Unixdate = utime:unixdate(),
    TimeL = data_guild_boss:get_cfg(open_time),
    do_get_next_time(format_time(TimeL), NowTime - Unixdate).

do_get_next_time([], _NowTime) -> false;
do_get_next_time([{Stime, Etime}|L], NowTime) ->
    if
        NowTime < Stime -> false;
        NowTime >= Stime andalso NowTime < Etime -> true;
        true ->
            do_get_next_time(L, NowTime)
    end.

format_time(TimeL) ->
    [{SH*3600+SM*60+SS, EH*3600+EM*60+ES}||{{SH, SM, SS}, {EH, EM, ES}} <- TimeL].

get_gboss_time() ->
    Unixdate = utime:unixdate(),
    TimeL = data_guild_boss:get_cfg(open_time),
    [{StarTime, EndTime}|_] = format_time(TimeL),
    {Unixdate+StarTime, Unixdate+EndTime}.

%% 检测是否开启活动Boss
is_open_gboss() ->
    NowTime = utime:unixtime(),
    %Duration = data_guild_boss:get_cfg(duration),
    case get({?MODULE, open}) of
        {OpTime, _AutoDrumTime, EndTime, _Ref} ->
            case NowTime >= OpTime andalso NowTime < EndTime of
                true -> true;
                _ -> false
            end;
        _ ->
            false
    end.

close_gboss() ->
    erase({?MODULE, open}).

get_open_state() ->
    get({?MODULE, open}).

get_war_state() ->
    case get({?MODULE, war_state}) of
        1 -> 1;
        _ -> 0
    end.

set_war_state(WarState) ->
    put({?MODULE, war_state}, WarState).

reset_war_state() ->
    erase({?MODULE, war_state}).


db_replace_status_gboss(GBossR) ->
    #status_gboss{
        guild_id = GuildId, dun_id = DunId, optime = OpTime, hp = Hp, gboss_mat = GBossMat,
        challenge_times = ChallengeTimes, last_drum_up_time = LastDrumUpTime, auto_drumup = AutoDrumup
    } = GBossR,
    db:execute(io_lib:format(?sql_save_guild_boss, [GuildId, DunId, OpTime, Hp, GBossMat, ChallengeTimes, AutoDrumup, LastDrumUpTime])).


is_guild_boss(_CopyId, _Mid) -> false.
    % Val = data_guild_boss:get_gboss(),
    % lists:member({CopyId, Mid}, Val).

% get_gboss_product_value() ->
%     Today = utime:unixdate(),
%     case get({?MODULE, product_value}) of
%         {Unixdate, ProductValue} when Today == Unixdate ->
%             ProductValue;
%         _ ->
%             case catch mod_act_join:get_join_by_unixdate(?MOD_GUILD_ACT) of
%                 JoinMap when is_map(JoinMap) ->
%                     JoinList = maps:to_list(JoinMap),
%                     SortJoinList = lists:reverse(lists:keysort(1, JoinList)),
%                     case get_gboss_product_value_do(SortJoinList, SortJoinList, Today) of
%                         {1, PlayerList} ->
%                             ProductValue = length(PlayerList);
%                         {2, PlayerList} ->
%                             case catch mod_role_activity:get_activity_by_day(PlayerList, 1) of
%                                 {ok, TotalActivity} ->
%                                     ProductValue = TotalActivity;
%                                 _Err1 ->
%                                     ?ERR("get_gboss_product_value:~p~n", [_Err1]),
%                                     ProductValue = 100    %% 取默认值
%                             end;
%                         {3, ProductValue} ->
%                             ok
%                     end,
%                     put({?MODULE, product_value}, {Today, ProductValue}),
%                     ProductValue;
%                 _Err ->
%                     ?ERR("get_gboss_product_value:~p~n", [_Err]),
%                     100
%             end
%     end.

% get_gboss_product_value_do([], List, Today) ->
%     case lists:keyfind(Today, 1, List) of
%         {_, PlayerList} -> %% 以前没开过
%             {1, PlayerList};
%         _ -> %% 用默认价值(不应该走到这个流程的)
%             {3, 100}
%     end;
% get_gboss_product_value_do([{Unixdate, PlayerList}|SortJoinList], List, Today) ->
%     case Unixdate < Today of
%         true ->  %% 之前已经开过公会boss活动
%             {2, PlayerList};
%         _ ->
%             get_gboss_product_value_do(SortJoinList, List, Today)
%     end.

% save_gboss_hp() ->
%     GBossMap = get_gboss_map(),
%     F = fun(TmpGuildId, T) ->
%         case T of
%             #status_gboss{hp = Hp} ->
%                 db:execute(io_lib:format(?sql_update_guild_boos_hp, [Hp, TmpGuildId])),
%                 T;
%             _ -> T
%         end
%     end,
%     maps:map(F, GBossMap).

% get_war_no() ->
%     case get({?MODULE, war_no}) of
%         undefined ->
%             put({?MODULE, war_no}, 2),
%             1;
%         WarNo ->
%             put({?MODULE, war_no}, WarNo+1),
%             WarNo
%     end.

% reset_war_no() ->
%     erase({?MODULE, war_no}).