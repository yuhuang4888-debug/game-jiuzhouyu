%%-----------------------------------------------------------------------------
%% @Module  :       pp_guild_act
%% @Author  :       Czc
%% @Email   :       389853407@qq.com
%% @Created :       2017-11-05
%% @Description:    公会活动
%%-----------------------------------------------------------------------------
-module(pp_guild_act).

-include("server.hrl").
-include("guild.hrl").
-include("errcode.hrl").
-include("guild_feast.hrl").
-include("guild_boss.hrl").
-include("figure.hrl").
-include("common.hrl").
-include("dungeon.hrl").
-include("predefine.hrl").
-include("def_module.hrl").
-include("goods.hrl").

-export([handle/3,
    send_error_code/2,
    send_error_code_by_role_id/2]).

%% 公会Boss信息
handle(40201, Status, _) ->
    #player_status{id = RoleId, guild = GuildStatus} = Status,
    #status_guild{id = GuildId} = GuildStatus,
    case GuildId > 0 of
        true ->
            mod_guild_boss:send_gboss_info(RoleId, GuildId);
        false -> skip
    end;

%% 开启公会Boss
% handle(40202, Status, _) ->
%     #player_status{id = RoleId, guild = GuildStatus} = Status,
%     #status_guild{id = GuildId} = GuildStatus,
%     case GuildId > 0 of
%         true ->
%             mod_guild_boss:open_gboss(RoleId, GuildId);
%         false -> skip
%     end;

%% 上交兽粮
% handle(40203, Status, _) ->
%     #player_status{sid = Sid, id = RoleId, guild = GuildStatus} = Status,
%     #status_guild{id = GuildId} = GuildStatus,
%     case GuildId > 0 of
%         true ->
%             GBossMatGTypeId = data_guild_boss:get_cfg(gboss_mat_gtype_id),
%             case lib_goods_api:get_goods_num(Status, [GBossMatGTypeId]) of
%                 [{GBossMatGTypeId, GoodsNum}|_] when GoodsNum > 0 ->
%                     DonateReward = data_guild_boss:get_cfg(gboss_mat_donate_reward),
%                     RealDonateReward = [{ObjectType, GTypeId, GNum * GoodsNum} || {ObjectType, GTypeId, GNum} <- DonateReward],
%                     case lib_goods_api:can_give_goods(Status, RealDonateReward) of
%                         true ->
%                             case lib_goods_api:cost_object_list(Status, [{?TYPE_GOODS, GBossMatGTypeId, GoodsNum}], gboss_mat_turn_in, "") of
%                                 {true, NewStatus} ->
%                                     mod_guild_boss:add_gboss_mat(RoleId, GuildId, GoodsNum, RealDonateReward);
%                                 {false, _, _} -> NewStatus = Status
%                             end;
%                         {false, ErrorCode} ->
%                             send_error_code(Sid, ErrorCode),
%                             NewStatus = Status
%                     end;
%                 _ ->
%                     send_error_code(Sid, ?ERRCODE(goods_not_enough)),
%                     NewStatus = Status
%             end;
%         false -> NewStatus = Status
%     end,
%     {ok, NewStatus};

%% 召集
handle(40204, Status, _) ->
    #player_status{sid = Sid, id = RoleId, dungeon = _StatusDungenon, guild = GuildStatus} = Status,
    #status_guild{position = Position, id = GuildId} = GuildStatus,
    case GuildId > 0 of
        true ->
            case Position == ?POS_CHIEF orelse Position == ?POS_DUPTY_CHIEF of %% 会长才能召集
                true ->
                    mod_guild_boss:drum_up(RoleId, GuildId);
                false ->
                    send_error_code(Sid, ?ERRCODE(err402_chief_can_drum_up))
            end;
        false -> skip
    end;

%% 进入公会Boss副本
% handle(40205, Status, _) ->
%     #player_status{id = RoleId, sid = Sid, scene = SceneId, dungeon = _StatusDungenon, guild = GuildStatus} = Status,
%     %#status_dungeon{dun_id = CurDunId} = StatusDungenon,
%     #status_guild{id = GuildId} = GuildStatus,
%     case GuildId > 0 of
%         true ->
%             % FeastScene = data_guild_feast:get_cfg(scene_id),
%             % case SceneId == FeastScene of
%             %     true ->
%                     mod_guild_boss:enter_guild_boss(GuildId, RoleId),
%                     NewStatus = Status;
%             %     _ ->
%             %         NewStatus = Status,
%             %         send_error_code(Sid, ?ERRCODE(err402_please_enter_feast))
%             % end;
%         false -> NewStatus = Status
%     end,
%     {ok, NewStatus};

%% 获取下次召集时间
% handle(40206, Status, _) ->
%     #player_status{id = RoleId, dungeon = StatusDungenon, guild = GuildStatus} = Status,
%     #status_dungeon{dun_id = CurDunId} = StatusDungenon,
%     #status_guild{position = Position, id = GuildId} = GuildStatus,
%     case GuildId > 0 of
%         true ->
%             case Position == ?POS_CHIEF of %% 会长才能召集
%                 true ->
%                     mod_guild_boss:send_next_drum_up_time(RoleId, GuildId, CurDunId);
%                 false -> skip
%             end;
%         false -> skip
%     end;

 %% 离开公会boss
% handle(40207, Status, _) ->
%     #player_status{id = RoleId, scene = SceneId, copy_id = CopyId} = Status,
%     GBossSceneId = data_guild_boss:get_cfg(boss_scene),
%     case GBossSceneId == SceneId andalso misc:is_process_alive(CopyId) == true of
%         true ->
%             mod_guild_boss_fight:leave_guild_boss(CopyId, [RoleId]);
%         false -> skip
%     end;

%% 设置自动召唤
handle(40209, Status, [IsAuto]) ->
    #player_status{sid = Sid, id = RoleId, dungeon = _StatusDungenon, guild = GuildStatus} = Status,
    #status_guild{position = Position, id = GuildId} = GuildStatus,
    case GuildId > 0 of
        true ->
            case Position == ?POS_CHIEF orelse Position == ?POS_DUPTY_CHIEF of %% 会长才能设置
                true ->
                    mod_guild_boss:set_auto_drumup(RoleId, GuildId, IsAuto);
                false ->
                    lib_server_send:send_to_sid(Sid, pt_402, 40209, [?ERRCODE(err402_chief_can_drum_up), IsAuto])
            end;
        false -> skip
    end;

%% 公会晚宴信息
handle(40211, Status, _) ->
    #player_status{id = RoleId} = Status,
    mod_guild_feast_mgr:send_act_info(RoleId);

%% 进入晚宴场景
handle(40212, Status, _) ->
    case lib_gm_stop:check_gm_close_act(?MOD_GUILD_ACT, ?MOD_GUILD_ACT_PARTY) of
        true ->
            #player_status{sid = Sid, id = RoleId, scene = Scene, figure = #figure{lv = Lv}, guild = GuildStatus} = Status,
            #status_guild{id = GuildId, name = GuildName, lv = GuildLv, create_time = _CreateTimes} = GuildStatus,
            ActScene = data_guild_feast:get_cfg(scene_id),
            NeedLv = data_guild_feast:get_cfg(need_role_lv),
            GuildLvLimit = data_guild_feast:get_cfg(guild_lv),
            % EnterGuildLimit = data_guild_feast:get_cfg(enter_guild_time),
            % NowTime = utime:unixtime(),
            if
                Scene == ActScene ->  ErrCode = skip;
                GuildId =< 0 -> ErrCode = ?ERRCODE(err402_no_join_guild);
                Lv < NeedLv -> ErrCode = ?ERRCODE(err402_no_enough_lv_join);
                GuildLv  < GuildLvLimit   ->  ErrCode = ?ERRCODE(err402_guild_lv);   %%公会等级不够
                % NowTime - CreateTimes < 86400  * EnterGuildLimit ->  ErrCode = ?ERRCODE(err402_enter_guild_time);   %%入会时间不够
                true ->
                    case lib_player_check:check_list(Status, [action_free, is_transferable]) of
                        true ->
                            ErrCode = ok,
                            mod_guild_feast_mgr:enter_scene(RoleId, Lv, GuildId, GuildName);
                        {false, ErrCode} ->
                            ok
                    end
            end,
            case is_integer(ErrCode) of
                true ->
                    lib_server_send:send_to_sid(Sid, pt_402, 40212, [ErrCode]);
                _ ->
                    NewStatus = lib_to_be_strong:update_data_guild_act(Status),
                    {ok, NewStatus}
            end;
        {_, Error} ->
            lib_server_send:send_to_sid(Status#player_status.sid, pt_402, 40212, [Error])
    end;


%% 个人奖励信息
handle(40213, Status, _) ->
    #player_status{id = RoleId} = Status,
    mod_guild_feast_mgr:send_role_reward_info(RoleId);

%% 积分排行榜
handle(40214, Status, _) ->
    #player_status{id = RoleId, guild = Guild} = Status,
    #status_guild{id = GuildId} = Guild,
    mod_guild_feast_mgr:send_quiz_rank(RoleId,  GuildId);

%% 采集宴席奖励
handle(40215, Status, _) ->
    #player_status{sid = Sid, id = RoleId, scene = Scene} = Status,
    ActScene = data_guild_feast:get_cfg(scene_id),
    Reward = data_guild_feast:get_cfg(gfeast_reward),
    RealReward = [{?TYPE_GOODS, GTypeId, GoodsNum} || {?TYPE_GOODS, GTypeId, GoodsNum} <- Reward],
    CanGiveReward = lib_goods_api:can_give_goods(Status, RealReward),
    if
        ActScene =/= Scene -> send_error_code(Sid, ?ERRCODE(err402_no_in_act_scene));
        CanGiveReward =/= true -> send_error_code(Sid, ?ERRCODE(err150_no_cell));
        true ->
            mod_guild_feast_mgr:receive_reward(RoleId)
    end;

%% 累积经验/贡献
handle(40216, Status, [Type]) when Type == 1 orelse Type == 2 ->
    #player_status{sid = Sid, id = RoleId, figure = Figure, scene = Scene} = Status,
    #figure{lv = RoleLv} = Figure,
    ActScene = data_guild_feast:get_cfg(scene_id),
    if
        ActScene =/= Scene -> send_error_code(Sid, ?ERRCODE(err402_no_in_act_scene));   %%不是处于活动场景
        true ->
            mod_guild_feast_mgr:update_acc_reward(RoleId, RoleLv, Type)
    end;

%% 宴会答题信息
handle(40217, Status, _) ->
    #player_status{sid = Sid, id = RoleId, scene = Scene, guild = GuildStatus} = Status,
    #status_guild{id = GuildId} = GuildStatus,
    ActScene = data_guild_feast:get_cfg(scene_id),
    if
        ActScene =/= Scene -> send_error_code(Sid, ?ERRCODE(err402_no_in_act_scene));
        true ->
            mod_guild_feast_mgr:send_quiz_info(RoleId, GuildId)
    end;

%% 退出晚宴场景
handle(40218, Status, _) ->
    #player_status{sid = Sid, id = RoleId, scene = Scene, guild = Guild} = Status,
    ActScene = data_guild_feast:get_cfg(scene_id),
    if
        Scene =/= ActScene -> send_error_code(Sid, ?ERRCODE(err402_no_in_act_scene));
        true ->
            #status_guild{id = GuildId} =  Guild,
            lib_scene:player_change_scene(RoleId, 0, 0, 0, true, [{action_free, ?ERRCODE(err402_can_not_change_scene_in_gfeast)}, {change_scene_hp_lim, 100}, {collect_checker, undefined}]),
            mod_guild_feast_mgr:exit_scene(RoleId, GuildId)
    end;

%% 是否能采集宴席奖励
handle(40219, Status, _) ->
    #player_status{sid = Sid, id = RoleId, scene = Scene} = Status,
    ActScene = data_guild_feast:get_cfg(scene_id),
    Reward = data_guild_feast:get_cfg(gfeast_reward),
    RealReward = [{?TYPE_GOODS, GTypeId, GoodsNum} || {?TYPE_GOODS, GTypeId, GoodsNum} <- Reward],
    CanGiveReward = lib_goods_api:can_give_goods(Status, RealReward),
    if
        ActScene =/= Scene -> send_error_code(Sid, ?ERRCODE(err402_no_in_act_scene));
        CanGiveReward =/= true -> send_error_code(Sid, ?ERRCODE(err150_no_cell));
        true ->
            mod_guild_feast_mgr:check_receive_reward(RoleId)
    end;

%% 个人积分排行
handle(40220, Status, _) ->
    #player_status{id = RoleId, guild = Guild} = Status,
    #status_guild{id = GuildId} = Guild,
    mod_guild_feast_mgr:send_role_score_rank(RoleId, GuildId);

%% 小游戏是否已经完成
handle(40221, Status, _) ->
    #player_status{id = RoleId, guild = #status_guild{id = GuildId}} = Status,
    mod_guild_feast_mgr:send_mini_game_status(RoleId, GuildId);

%% 当天轮换的游戏类型
handle(40222, Status, _) ->
    #player_status{id = RoleId} = Status,
    mod_guild_feast_mgr:send_game_type(RoleId);

%% 进入守卫公会
handle(40230, Status, []) ->
    #player_status{sid = Sid, id = RoleId, figure = #figure{lv = Lv}, guild = GuildStatus} = Status,
    #status_guild{id = GuildId} = GuildStatus,
    CanEnter = lib_player_check:check_all(Status),
    if
        GuildId =< 0 -> send_error_code(Sid, ?ERRCODE(err402_no_join_guild));
        Lv < 130 -> send_error_code(Sid, ?LEVEL_LIMIT);
        CanEnter =/= true ->
            {_, Code} = CanEnter,
            send_error_code(Sid, Code);
        true ->
            % case lib_activitycalen_api:get_first_enabled_ac_id(?MOD_GUILD_ACT, ?MOD_GUILD_ACT_GUARD) of
            %     {ok, _} ->
            %         mod_guild_guard:enter_act(RoleId, GuildId);
            %     _ ->
            %         send_error_code(Sid, ?ERRCODE(err402_act_close))
            % end
            %% 因为有秘籍开启，所以去到进程里面再判断
            mod_guild_guard:enter_act(RoleId, GuildId)
    end;

%% 获取守卫公会状态
handle(40231, #player_status{sid = Sid} = Status, []) ->
    #player_status{sid = Sid, guild = GuildStatus} = Status,
    #status_guild{id = GuildId} = GuildStatus,
    mod_guild_guard:get_info(Sid, GuildId);

%% 获取守卫公会当前挑战波数
handle(40232, #player_status{sid = Sid} = Status, []) ->
    #player_status{sid = Sid, guild = GuildStatus} = Status,
    #status_guild{id = GuildId} = GuildStatus,
    mod_guild_guard:get_guild_wave_num(Sid, GuildId);

% %% 公会争霸活动信息
% handle(40240, Status, _) ->
%     #player_status{id = RoleId, guild = GuildStatus} = Status,
%     #status_guild{id = GuildId} = GuildStatus,
%     if
%         GuildId =< 0 -> skip;
%         true ->
%             mod_guild_war:send_act_info(RoleId)
%     end;

% %% 公会争霸首届界面信息(未开启)
% handle(40241, Status, _) ->
%     #player_status{id = RoleId, guild = GuildStatus} = Status,
%     #status_guild{id = GuildId} = GuildStatus,
%     if
%         GuildId =< 0 -> skip;
%         true ->
%             mod_guild_war:send_gwar_view_info(RoleId)
%     end;

% %% 公会争霸首届界面信息(开启)
% handle(40242, Status, _) ->
%     #player_status{id = RoleId, guild = GuildStatus} = Status,
%     #status_guild{id = GuildId} = GuildStatus,
%     if
%         GuildId =< 0 -> skip;
%         true ->
%             mod_guild_war:send_gwar_view_info(RoleId)
%     end;

% %% 公会争霸界面信息(未开启)
% handle(40243, Status, _) ->
%     #player_status{id = RoleId, guild = GuildStatus} = Status,
%     #status_guild{id = GuildId} = GuildStatus,
%     if
%         GuildId =< 0 -> skip;
%         true ->
%             mod_guild_war:send_gwar_view_info(RoleId)
%     end;

% %% 公会争霸界面信息(已开启)
% handle(40244, Status, _) ->
%     #player_status{id = RoleId, guild = GuildStatus} = Status,
%     #status_guild{id = GuildId} = GuildStatus,
%     if
%         GuildId =< 0 -> skip;
%         true ->
%             mod_guild_war:send_gwar_view_info(RoleId)
%     end;

% %% 进入公会争霸场景
% handle(40245, Status, _) ->
%     #player_status{sid = Sid, id = RoleId, scene = Scene, figure = #figure{lv = Lv}, guild = GuildStatus} = Status,
%     #status_guild{id = GuildId, create_time = CreateTime} = GuildStatus,
%     IsInGWarScene = lib_guild_war_api:is_gwar_scene(Scene),
%     NeedLv = data_guild_war:get_cfg(need_role_lv),
%     if
%         IsInGWarScene -> skip;
%         GuildId =< 0 -> send_error_code(Sid, ?ERRCODE(err402_no_join_guild));
%         Lv < NeedLv -> send_error_code(Sid, ?ERRCODE(err402_no_enough_lv_join));
%         true ->
%             case lib_player_check:check_list(Status, [action_free, is_transferable]) of
%                 true ->
%                     mod_guild_war:enter_scene(GuildId, RoleId, CreateTime);
%                 {false, ErrCode} ->
%                     send_error_code(Sid, ErrCode)
%             end
%     end;

% %% 退出公会争霸场景
% handle(40246, Status, _) ->
%     #player_status{sid = Sid, id = RoleId, scene = Scene, guild = GuildStatus} = Status,
%     #status_guild{id = GuildId} = GuildStatus,
%     IsInGWarScene = lib_guild_war_api:is_gwar_scene(Scene),
%     if
%         IsInGWarScene == false -> send_error_code(Sid, ?ERRCODE(err402_no_in_act_scene));
%         true ->
%             mod_guild_war:exit_scene(GuildId, RoleId)
%     end;

% %% 公会争霸战斗信息
% handle(40247, Status, _) ->
%     #player_status{id = RoleId, scene = Scene, guild = GuildStatus, copy_id = CopyId} = Status,
%     #status_guild{id = GuildId} = GuildStatus,
%     IsInGWarScene = lib_guild_war_api:is_gwar_scene(Scene),
%     if
%         IsInGWarScene == false -> skip;
%         GuildId =< 0 -> skip;
%         true ->
%             Alive = misc:is_process_alive(CopyId),
%             if
%                 Alive == false -> skip;
%                 true ->
%                     mod_guild_war_battle:send_battle_info(CopyId, GuildId, RoleId)
%             end
%     end;

% %% 主宰公会界面信息
% handle(40250, Status, _) ->
%     #player_status{id = RoleId, guild = GuildStatus} = Status,
%     #status_guild{id = GuildId, create_time = CreateTime} = GuildStatus,
%     mod_guild_war:send_dominator_info(RoleId, GuildId, CreateTime);

% %% 连胜奖励
% handle(40251, Status, _) ->
%     #player_status{id = RoleId} = Status,
%     mod_guild_war:send_streak_reward_info(RoleId);

% %% 终结奖励
% handle(40252, Status, _) ->
%     #player_status{id = RoleId} = Status,
%     mod_guild_war:send_break_reward_info(RoleId);

% %% 分配奖励
% handle(40253, Status, [Type, SpecifyId, Extra]) ->
%     #player_status{sid = Sid, id = RoleId, guild = GuildStatus} = Status,
%     #status_guild{id = GuildId, position = Position} = GuildStatus,
%     if
%         Position =/= ?POS_CHIEF ->
%             send_error_code(Sid, ?ERRCODE(err402_no_permission_allot));
%         true ->
%             mod_guild_war:allot_reward(RoleId, GuildId, Type, SpecifyId, Extra)
%     end;

% %% 领取俸禄
% handle(40254, Status, _) ->
%     #player_status{sid = Sid, id = RoleId, guild = GuildStatus} = Status,
%     #status_guild{id = GuildId, create_time = CreateTime} = GuildStatus,
%     NowTime = utime:unixtime(),
%     NeedTime = data_guild_war:get_cfg(min_join_guild_time),
%     if
%         GuildId =< 0 ->
%             send_error_code(Sid, ?ERRCODE(err400_no_guild));
%         NowTime - CreateTime < NeedTime -> send_error_code(Sid, ?ERRCODE(err402_join_in_guild_not_enough_time_can_not_receive));
%         true ->
%             SalaryPaulReward = data_guild_war:get_cfg(gwar_salary_paul),
%             CanGiveReward = lib_goods_api:can_give_goods(Status, SalaryPaulReward),
%             if
%                 CanGiveReward =/= true ->
%                     send_error_code(Sid, ?ERRCODE(err402_no_null_cell_receive_salary_paul));
%                 true ->
%                    mod_guild_war:receive_salary_paul(RoleId, GuildId, SalaryPaulReward)
%             end
%     end;

%% 发送经验或者贡献信息
handle(40255, Status, [_Type]) ->
    #player_status{sid = Sid, id = RoleId, figure = _Figure, scene = Scene} = Status,
    ActScene = data_guild_feast:get_cfg(scene_id),
    if
        ActScene =/= Scene -> send_error_code(Sid, ?ERRCODE(err402_no_in_act_scene));   %%不是处于活动场景
        true ->
            mod_guild_feast_mgr:send_exp_by_cast(RoleId, 0)
    end,
    {ok, Status};

%%主动获取火苗信息
handle(40256, Status, []) ->
    #player_status{sid = Sid, id = RoleId,  scene = Scene, guild = Guild} = Status,
    #status_guild{id = GuildId} = Guild,
    ActScene = data_guild_feast:get_cfg(scene_id),
    if
        ActScene =/= Scene -> send_error_code(Sid, ?ERRCODE(err402_no_in_act_scene));   %%不是处于活动场景
        true ->
            mod_guild_feast_mgr:send_fire_to_user(RoleId, GuildId)
    end,
    {ok, Status};


%%%% 点击火苗
%%handle(40257, Status, [FireId]) ->
%%    #player_status{sid = Sid, id = RoleId, scene = Scene, guild =  Guild} = Status,
%%    #status_guild{id = GuildId} = Guild,
%%    ActScene = data_guild_feast:get_cfg(scene_id),
%%    if
%%        ActScene =/= Scene -> send_error_code(Sid, ?ERRCODE(err402_no_in_act_scene));   %%不是处于活动场景
%%        true ->
%%            mod_guild_feast_mgr:collect_fire(RoleId, FireId, GuildId)
%%    end,
%%    {ok, Status};


%% 答选择题
handle(40259,#player_status{id = RoleId, sid = SId, guild = Guild, figure =  F} =  _Status, [Answer]) ->
    #figure{name = RoleName} = F,
    #status_guild{id = GuildId, name = GuildName} = Guild,
    IsAnswer = mod_guild_feast_mgr:quiz_answer(RoleId, RoleName, F, GuildId, GuildName, Answer, 1),
    {Reply, _} = IsAnswer,
    lib_server_send:send_to_sid(SId, pt_402, 40259, [Reply]),
    {ok, _Status};

%% 龙魂信息
handle(40260,#player_status{id = RoleId, guild = Guild} =  Status, []) ->
    #status_guild{id = GuildId} = Guild,
    mod_guild_feast_mgr:send_dragon_point(RoleId , GuildId),
    {ok, Status};

%% 购买龙魂
handle(40261,#player_status{id = RoleId, guild = Guild} =  Status, [Num]) ->
    #status_guild{id = GuildId} = Guild,
    NewPs = lib_guild_feast:buy_dragon_spirit(RoleId ,GuildId, Num, Status),
    {ok, NewPs};


%% 篝火经验信息
handle(40255,#player_status{id = RoleId} =  Status, [Type]) ->
    case Type of
        1 ->
            mod_guild_feast_mgr:get_fire_exp_by_role_id(RoleId);
        _ ->
            skip
    end,
    {ok, Status};

%% 购买菜肴
handle(40264,#player_status{id = RoleId, scene = Scene, guild = StatusGuild, figure = Figure} =  Status, [Type]) ->
%%    ?PRINT("++++++++++++ ~n", []),
    case lib_guild_feast:is_gfeast_scene(Scene) of
        true ->
            case lib_guild_feast:is_buy_food(RoleId, Type) of
                true ->
%%                    ?PRINT("++++++++++++ ~n", []),
                    {ok, Bin} = pt_402:write(40264, [?ERRCODE(err402_yet_buy_food), []]),
                    lib_server_send:send_to_uid(RoleId, Bin);
                _ ->
%%                    ?PRINT("++++++++++++ ~n", []),
                    CostCfg = data_guild_feast:get_cfg(food_cost),
                    BuffCfg = data_guild_feast:get_cfg(food_buff),
                    case lists:keyfind(Type, 1, CostCfg) of
                        {_, Cost, Reward} ->
                            %%
                            if
                                Type == 3 -> %%高级菜肴，每个公会只能买一次
                                    case catch mod_guild_feast_mgr:is_can_buy_food(StatusGuild#status_guild.id) of
                                        true -> Res = true;
                                        false -> Res = {fail, ?ERRCODE(buy_grade_food_limit	)};
                                        {fail, Error} -> Res = {fail, Error};
                                        Error -> %% 出错 提示系统繁忙
                                            ?ERR("mod_guild_feast_mgr err:~p", [Error]),
                                            Res = {fail, ?ERRCODE(system_busy)}
                                    end;
                                true ->
                                    Res = true
                            end,
                            case Res of
                                true ->
                                    case lib_goods_api:cost_object_list_with_check(Status, Cost, guild_act_buy_food, "") of
                                        %% Status, Cost, guild_act_buy_food, ""
                                        {true, NewPs} -> %%  购买菜肴 , 只是判断场景，就不判断阶段了
                                            PackList = lib_guild_feast:set_foods_status(RoleId, Type),
                                            {ok, Bin} = pt_402:write(40264, [?SUCCESS, PackList]),
                                            lib_server_send:send_to_uid(RoleId, Bin),
                                            lib_goods_api:send_reward_with_mail(RoleId, #produce{reward = Reward, type = err402_yet_buy_food}),
                                            %% 增加经验加成到公会晚宴
                                            case lists:keyfind(Type, 1, BuffCfg) of
                                                {_, Ratio} ->
                                                    ok;
                                                _ ->
                                                    Ratio = 0
                                            end,
                                            mod_guild_feast_mgr:add_guild_exp_ratio(StatusGuild#status_guild.id, Ratio, Type),
                                            lib_guild_feast:send_buy_food_tv(RoleId, Figure#figure.name, StatusGuild#status_guild.id, Type, Cost),
                                            {ok, NewPs};
                                        {false, Err, _} ->
                                            {ok, Bin} = pt_402:write(40264, [Err, []]),
                                            lib_server_send:send_to_uid(RoleId, Bin)
                                    end;
                                {_, ErrorCode} ->
                                    {ok, Bin} = pt_402:write(40264, [ErrorCode, []]),
                                    lib_server_send:send_to_uid(RoleId, Bin)
                            end;
                        _ ->
                            {ok, Bin} = pt_402:write(40264, [?MISSING_CONFIG, []]),
                            lib_server_send:send_to_uid(RoleId, Bin)
                    end
            end;
        _ ->
            {ok, Status}
    end;


%% 菜肴状态
handle(40265,#player_status{id = RoleId, scene = Scene, guild = Guild} =  Status, []) ->
    case lib_guild_feast:is_gfeast_scene(Scene) of
        true ->
            PackList = lib_guild_feast:get_foods_pack_list(RoleId),
            mod_guild_feast_mgr:send_food_status(RoleId, Guild#status_guild.id, PackList),
%%            {ok, Bin} = pt_402:write(40265, [PackListNew]),
%%            lib_server_send:send_to_uid(RoleId, Bin),
            {ok, Status};
        _ ->
            {ok, Status}
    end;

%% 经验加成状态
handle(40267,#player_status{id = RoleId, scene = Scene} =  Status, []) ->
    case lib_guild_feast:is_gfeast_scene(Scene) of
        true ->
            Ratio = mod_daily:get_count(RoleId, ?MOD_GUILD_ACT, 4),
            {ok, Bin} = pt_402:write(40267, [Ratio]),
            lib_server_send:send_to_uid(RoleId, Bin),
            {ok, Status};
        _ ->
            {ok, Status}
    end;

%%%% 召唤远古巨龙
%%handle(40263,#player_status{id = RoleId, sid = Sid, scene = Scene, guild = Guild} =  Status, [Type]) ->
%%    %%检查消耗
%%    %%是否在公会晚宴场景内
%%    #status_guild{id = GuildId} = Guild,
%%    IsInGuildFeast = lib_guild_feast:is_gfeast_scene(Scene),
%%    if
%%        Type > 3 orelse Type < 1 ->
%%            send_error_code(Sid, ?FAIL);
%%        IsInGuildFeast == true ->
%%            Cost = lib_guild_feast:get_summon_cost_by_type(Type),
%%            case lib_goods_api:check_object_list(Status, Cost) of
%%                true ->
%%                    mod_guild_feast_mgr:summon_dragon(RoleId, GuildId, Cost, Type);
%%                {false, _Res} ->
%%                    send_error_code(Sid, ?ERRCODE(err402_not_have_summon_card))
%%            end;
%%        true ->
%%            send_error_code(Sid, ?FAIL)
%%    end,
%%    {ok, Status};
%%

handle(_Cmd, _Status, _Data) ->
    {error, "pp_guild_act no match"}.

%% 发送错误码
send_error_code(Sid, ErrorCode) ->
    ?DEBUG("ErrorCode ~p~n", [ErrorCode]),
    {ok, BinData} = pt_402:write(40200, [ErrorCode]),
    lib_server_send:send_to_sid(Sid, BinData).

send_error_code_by_role_id(RoleId, ErrorCode) ->
    ?DEBUG("ErrorCode ~p~n", [ErrorCode]),
    {ok, BinData} = pt_402:write(40200, [ErrorCode]),
    lib_server_send:send_to_uid(RoleId, BinData).
