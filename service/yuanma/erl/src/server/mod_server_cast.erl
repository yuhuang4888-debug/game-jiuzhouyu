%------------------------------------
%%% @Module  : mod_server_cast
%%% @Author  : xyao
%%% @Email   : jiexiaowen@gmail.com
%%% @Created : 2011.12.16
%%% @Description: 角色cast处理
%%%------------------------------------
-module(mod_server_cast).
-export([handle_cast/2,set_data/2,set_data_sub/2]).
-include("server.hrl").
-include("common.hrl").
-include("daily.hrl").
-include("predefine.hrl").
-include("attr.hrl").
-include("team.hrl").
-include("figure.hrl").
-include("scene.hrl").
-include("battle.hrl").
-include("def_event.hrl").
-include("errcode.hrl").
-include("def_module.hrl").
-include("def_daily.hrl").
-include("language.hrl").
-include("goods.hrl").
-include("eudemons_land.hrl").
-include("skill.hrl").
-include("buff.hrl").
-include("role_nine.hrl").
-include("kf_guild_war.hrl").
-include("mount.hrl").

%% 设置玩家属性(按属性列表更新)远程调用
%% @spec set_data(AttrKeyValueList,Pid) -> noprc | ok
%% AttrKeyValueList 属性列表 [{Key,Value},{Key,Value},...] Key为原子类型，Value为所需参数数据
%% Pid 玩家进程
%% @end
set_data(AttrKeyValueList, RoleId) when is_integer(RoleId) ->
    Pid = misc:get_player_process(RoleId),
    case misc:is_process_alive(Pid) of
        true -> set_data(AttrKeyValueList, Pid);
        false -> noprc
    end;
set_data(AttrKeyValueList, Pid) ->
    case is_pid(Pid) andalso misc:is_process_alive(Pid) of
        true  -> gen_server:cast(Pid, {'set_data', AttrKeyValueList});
        false -> noprc
    end.

%% 设置玩家属性(按属性列表更新)
%% @param AttrKeyValueList 属性列表 [{Key,Value},{Key,Value},...] Key为原子类型，Value为所需参数数据
%% @param Status 当前玩家状态
%% @return NewStatus 新玩家状态
set_data_sub(AttrKeyValueList, Status)->
    case AttrKeyValueList of
        [{Key,Value}|T] ->
            case Key of
                cost_money ->
                    {Cost, MoneyType, Type, About} = Value,
                    NewStatus = lib_goods_util:cost_money(Status, Cost, MoneyType, Type, About);
                cost ->
                    {ObjectList, Type, About} = Value,
                    case lib_goods_api:cost_object_list(Status, ObjectList, Type, About) of
                        {false, _ErrorCode, NewStatus} -> ok;
                        {true, NewStatus} -> ok
                    end;
                hp ->
                    BattleAttr = Status#player_status.battle_attr,
                    NewBattleAttr =  BattleAttr#battle_attr{hp = Value},
                    NewStatus = Status#player_status{battle_attr = NewBattleAttr};
                hp_lim ->
                    BattleAttr = Status#player_status.battle_attr,
                    NewBattleAttr =  BattleAttr#battle_attr{hp_lim = Value},
                    NewStatus = Status#player_status{battle_attr = NewBattleAttr};
                xy ->
                    {X, Y} = Value,
                    NewStatus = Status#player_status{x=X, y=Y};
                group ->
                    BattleAttr = Status#player_status.battle_attr,
                    NewBattleAttr =  BattleAttr#battle_attr{group = Value},
                    NewStatus = Status#player_status{battle_attr = NewBattleAttr},
                    mod_scene_agent:update(NewStatus, [{group, Value}]),
                    {ok, Bin} = pt_120:write(12072, [?BATTLE_SIGN_PLAYER, Status#player_status.id, Value]),
                    lib_server_send:send_to_scene(Status#player_status.scene, Status#player_status.scene_pool_id, Bin),
                    NewStatus;
                is_hurt_mon ->
                    BattleAttr = Status#player_status.battle_attr,
                    NewBattleAttr = BattleAttr#battle_attr{is_hurt_mon = Value},
                    NewStatus = Status#player_status{battle_attr = NewBattleAttr},
                    NewStatus;
                hide ->
                    BattleAttr = Status#player_status.battle_attr,
                    NewBattleAttr =  BattleAttr#battle_attr{hide = Value},
                    NewStatus = Status#player_status{battle_attr = NewBattleAttr};
                team_flag ->
                    NewStatus = lib_team:update_team_flag(Status, Value);
                team_skill ->
                    {SetSkillId, SkillNum} = Value,
                    #player_status{team = Team, skill = SkillStatus} = Status,
                    TeamStatus = Status#player_status{team = Team#status_team{team_skill=SetSkillId, skill_num = SkillNum}},
                    mod_scene_agent:update(TeamStatus, [{team_flag, TeamStatus#player_status.team}]),
                    if
                        SetSkillId == 0 andalso SkillNum == 0 ->
                            %% 特殊的技能临时buff:展示
                            case lists:keyfind(?SP_SKILL_KILLING, 1, SkillStatus#status_skill.skill_passive) of
                                false ->
                                    NewStatus = lib_goods_buff:remove_goods_temp_buff(TeamStatus, ?BUFF_TEAM_SHOW);
                                _ ->
                                    NewStatus = lib_goods_buff:add_goods_temp_buff(TeamStatus, ?BUFF_TEAM_SHOW, [{?SPBUFF_REBOUND, 1}], 0)
                            end;
                        true ->
                            NewStatus = lib_goods_buff:add_goods_temp_buff(TeamStatus, ?BUFF_TEAM_SHOW, [{?SPBUFF_REBOUND, SkillNum}], 0)
                    end,
                    lib_goods_buff:send_buff_notice(NewStatus),
                    NewStatus;
                copy_id ->
                    NewStatus = Status#player_status{copy_id = Value};
                pk ->
                    {Type, IsForce} = Value,
                    case lib_player:change_pkstatus(Status, Type, IsForce) of
                        {ok, NewStatus} -> skip;
                        _ -> NewStatus = Status
                    end;
                status_dungeon ->
                    NewStatus = lib_dungeon:update_status_dungeon(Value, Status);
                ghost ->
                    #player_status{battle_attr = BA} = Status,
                    NewStatus = Status#player_status{battle_attr = BA#battle_attr{ghost = Value}};
                %% 切换场景回满血（先在原场景回满血，再切换场景）
                change_scene_hp_lim ->
                    BattleAttr = Status#player_status.battle_attr,
                    HpLim   = BattleAttr#battle_attr.hp_lim,

                    Sid     = Status#player_status.sid,
                    SceneId = Status#player_status.scene,
                    X       = Status#player_status.x,
                    Y       = Status#player_status.y,
                    SceneName = lib_scene:get_scene_name(SceneId),
                    Hp      = HpLim,
                    Gold    = Status#player_status.gold,
                    BGold   = Status#player_status.bgold,
                    AttProtected = 0,
                    lib_revive:send_revive(Sid, 1, SceneId, X, Y, SceneName, Hp, Gold, BGold, AttProtected),

                    NewBattleAttr =  BattleAttr#battle_attr{hp = HpLim},
                    NewStatus = Status#player_status{battle_attr = NewBattleAttr};
                %% 切换场景回血（先在原场景回血，再切换场景）
                change_scene_hp ->
                    BattleAttr = Status#player_status.battle_attr,

                    Sid     = Status#player_status.sid,
                    SceneId = Status#player_status.scene,
                    X       = Status#player_status.x,
                    Y       = Status#player_status.y,
                    SceneName = lib_scene:get_scene_name(SceneId),
                    Hp      = Value,
                    Gold    = Status#player_status.gold,
                    BGold   = Status#player_status.bgold,
                    AttProtected = 0,
                    lib_revive:send_revive(Sid, 1, SceneId, X, Y, SceneName, Hp, Gold, BGold, AttProtected),

                    NewBattleAttr =  BattleAttr#battle_attr{hp = Value},
                    NewStatus = Status#player_status{battle_attr = NewBattleAttr};
                hp_lim_ratio ->
                    BattleAttr = Status#player_status.battle_attr,
                    HpLim = BattleAttr#battle_attr.hp_lim,
                    Hp = min(round(HpLim*Value), HpLim),
                    NewBattleAttr = BattleAttr#battle_attr{hp = Hp},
                    NewStatus = Status#player_status{battle_attr = NewBattleAttr};
                follows ->
                    NewStatus = Status#player_status{follows = Value};
                change_location ->
                    [SceneId, ScenePoolId, CopyId, X, Y, BX, BY] = Value,
                    #player_status{scene=NowSceneId, scene_pool_id=NowScenePoolId, copy_id=NowCopyId, x=Xnow, y=Ynow,
                                   follow_target_conut=FTargetCount, battle_attr=BA} = Status,
                    case Status#player_status.online == ?ONLINE_ON of
                        true -> NewStatus = Status;
                        false ->
                            NewStatus
                                = case SceneId /= NowSceneId orelse ScenePoolId /= NowScenePoolId orelse CopyId /= NowCopyId of
                                      true when BA#battle_attr.hp =< 0 -> %% 血量为0不切换
                                          IsSendTeam=false,
                                          Status;

                                      true ->
                                          IsTrans = case data_scene:get(SceneId) of
                                                        #ets_scene{type=SceneType}
                                                          when SceneType == ?SCENE_TYPE_NORMAL
                                                               orelse SceneType == ?SCENE_TYPE_OUTSIDE ->
                                                            true;
                                                        _ ->
                                                            false
                                                    end,
                                          case IsTrans of
                                              true ->
                                                  IsSendTeam=true,
                                                  %% lib_scene:leave_scene(Status),
                                                  TmpStatus = lib_scene:change_scene(Status, SceneId, ScenePoolId, CopyId, X, Y, false, [{follow_target_xy, {X,Y}}]),
                                                  TmpStatus;
                                              false ->
                                                  IsSendTeam=false
                                                  %lib_onhook_offline:interrupt(Status)
                                          end;

                                      false ->
                                          case abs(X-Xnow) > 300 orelse abs(Y-Ynow) > 150 of
                                              true ->
                                                  {IsSend, FTargetCount1} = case FTargetCount > 4 of
                                                                                true  -> {true, 0};
                                                                                false -> {false, FTargetCount+1}
                                                                            end,
                                                  IsSendTeam=IsSend,
                                                  case IsSend of
                                                      true  -> mod_scene_agent:update(Status, [{follow_target_xy,{X,Y}}]);
                                                      false -> skip
                                                  end,
                                                  Status#player_status{follow_target_conut=FTargetCount1};
                                              false ->
                                                  IsSendTeam=false,
                                                  Status
                                          end
                                  end,
                            case IsSendTeam andalso Status#player_status.team#status_team.team_id > 0 of
                                true ->
                                    mod_team:cast_to_team(Status#player_status.team#status_team.team_id,
                                                          {'change_location', Status#player_status.id, SceneId, ScenePoolId, CopyId, X, Y, BX, BY});
                                false ->
                                    skip
                            end
                    end;
                follow_target_xy ->
                    NewStatus = Status#player_status{follow_target_xy=Value};
                mount ->
                    case Value of
                        0 ->
                            NewStatus = lib_mount:clear_figure_id_api(Status, ?MOUNT_ID);
                        1 ->
                            NewStatus = lib_mount:unequip_fashion_api(Status, ?MOUNT_ID);
                        _ ->
                            NewStatus = Status
                    end;
                % 仅加载场景
                just_load_scene_auto ->
                    {ok, NewStatus} = pp_scene:handle(12002, Status, ok);
                load_scene_auto ->
                    {ok, NewStatus} = pp_scene:handle(12002, Status, ok),
                    case Status#player_status.online of
                        ?ONLINE_OFF_ONHOOK -> %% 开始挂机
                            mod_scene_agent:cast_to_scene(NewStatus#player_status.scene, NewStatus#player_status.scene_pool_id,
                                {'go_to_onhook_place', NewStatus#player_status.id});
                        _ ->
                            skip
                    end;
                talk_lim ->
                    NewStatus = Status#player_status{talk_lim = Value};
                talk_lim_time ->
                    NewStatus = Status#player_status{talk_lim_time = Value};
                leave_scene_sign ->
                    NewStatus = Status#player_status{leave_scene_sign = Value};
                boss_tired ->
                    NewBossTired = Status#player_status.boss_tired + Value,
                    NewStatus = Status#player_status{boss_tired =  NewBossTired},
                    lib_server_send:send_to_sid(Status#player_status.sid, pt_460, 46011, [NewBossTired]),
                    mod_scene_agent:update(NewStatus, [{boss_tired, NewBossTired}]);
                temple_boss_tired ->
                    NewTBossTired = Status#player_status.temple_boss_tired + Value,
                    NewStatus = Status#player_status{temple_boss_tired = NewTBossTired},
                    lib_server_send:send_to_sid(Status#player_status.sid, pt_460, 46011, [NewTBossTired]),
                    mod_scene_agent:update(NewStatus, [{temple_boss_tired, NewTBossTired}]);
                phantom_tired ->
                    NewPhantomTired = Status#player_status.phantom_tired + Value,
                    NewStatus = Status#player_status{phantom_tired = NewPhantomTired},
                    lib_server_send:send_to_sid(Status#player_status.sid, pt_460, 46011, [NewPhantomTired]),
                    mod_scene_agent:update(NewStatus, [{phantom_tired, NewPhantomTired}]);
                action_lock -> %% 注意 Value只能是错误码整数值
                    NewStatus = lib_player:setup_action_lock(Status, Value);
                action_free ->
                    NewStatus = lib_player:break_action_lock(Status, Value);
                forbid_pk_etime ->
                    NewStatus = Status#player_status{forbid_pk_etime = Value};
                add_exp ->%% 增加玩家经验
                    NewStatus = lib_player:add_exp(Status, Value);
                eudemons_boss_tired ->
                    NewPhantomTired = Status#player_status.phantom_tired + Value,
                    NewStatus = Status#player_status{phantom_tired = NewPhantomTired},
                    lib_server_send:send_to_sid(Status#player_status.sid, pt_470, 47009, [NewPhantomTired]),
                    mod_scene_agent:update(NewStatus, [{phantom_tired, NewPhantomTired}]);
                eudemons_boss_lv ->
                    BossId = Value,
                    NewStatus = lib_eudemons_land:update_eudemons_exp_ps(Status, BossId);
                eudemons_boss_clinfo ->
                    [BossId, ClBossInfo] = Value,
                    #player_status{id = RoleId, eudemons_boss = EudemonsBoss}= Status,
                    NewPs = case data_eudemons_land:get_eudemons_boss_cfg(BossId) of
                                [] -> Status;
                                #eudemons_boss_cfg{goods = Goods, module_id = ModId, counter_id = CId} ->
                                    mod_daily:increment(RoleId, ModId, CId),
                                    lib_goods_api:send_reward(Status, Goods, eudemons_boss_cl, 0)
                            end,
                    NewStatus = NewPs#player_status{eudemons_boss =  EudemonsBoss#eudemons_boss{cl_boss_info = ClBossInfo}};
                last_task_id ->
                    lib_server_send:send_to_sid(Status#player_status.sid, pt_300, 30005, [Value]),
                    NewStatus = Status#player_status{last_task_id = Value};
                mate_role_id ->
                    NewStatus = Status#player_status{mate_role_id = Value},
                    mod_scene_agent:update(NewStatus, [{mate_role_id, Value}]);
                collect_checker ->
                    NewStatus = Status#player_status{collect_checker = Value};
                scene_hide_type ->
                    NewStatus = Status#player_status{scene_hide_type = Value};
                battle_field ->
                    NewStatus = Status#player_status{battle_field = Value};
                kf_1vn ->
                    {DefType, Turn} = Value,
                    NewStatus = lib_kf_1vN:set_player_1vn(Status, DefType, Turn);
                add_sk_gbuff ->
                    {SkillId, SkillLv} = Value,
                    NewStatus = lib_goods_buff:add_skill_buff(Status, SkillId, SkillLv);
                rm_sk_gbuff ->
                    NewStatus = lib_goods_buff:remove_skill_buff(Status, Value);
                passive_skill ->
                    #player_status{skill = SkillStatus} = Status,
                    #status_skill{skill_passive = PassiveSkills} = SkillStatus,
                    case Value of
                        {SkillId, SkillLv} ->
                            PassiveSkills1 = lists:keystore(SkillId, 1, PassiveSkills, {SkillId, SkillLv}),
                            mod_scene_agent:update(Status, [{passive_skill, [Value]}]);
                        List when is_list(List) ->
                            Fun = fun({SId, SLv}, Acc) ->
                                lists:keystore(SId, 1, Acc, {SId, SLv})
                            end,
                            PassiveSkills1 = lists:foldl(Fun, PassiveSkills, List),
                            mod_scene_agent:update(Status, [{passive_skill, Value}]);
                        _ ->
                            PassiveSkills1 = PassiveSkills
                    end,
                    SkillStatus1 = SkillStatus#status_skill{skill_passive = PassiveSkills1},
                    NewStatus = Status#player_status{skill = SkillStatus1};
                delete_passive_skill ->

                    #player_status{skill = SkillStatus} = Status,
                    #status_skill{skill_passive = PassiveSkills} = SkillStatus,
                    case Value of
                        {SkillId, _} ->
                            PassiveSkills1 = lists:keydelete(SkillId, 1, PassiveSkills),
                            mod_scene_agent:update(Status, [{delete_passive_skill, [Value]}]);
                        List when is_list(List) ->
                            Fun = fun({SId, _}, Acc) ->
                                lists:keydelete(SId, 1, Acc)
                            end,
                            PassiveSkills1 = lists:foldl(Fun, PassiveSkills, List),
                            mod_scene_agent:update(Status, [{delete_passive_skill, Value}]);
                        _ ->
                            PassiveSkills1 = PassiveSkills
                    end,
                    SkillStatus1 = SkillStatus#status_skill{skill_passive = PassiveSkills1},
                    NewStatus = Status#player_status{skill = SkillStatus1};
                in_sea ->
                    #player_status{status_kf_guild_war = StatusKfGWar} = Status,
                    NewStatusKfGWar = StatusKfGWar#status_kf_guild_war{in_sea = Value},
                    NewStatus = Status#player_status{status_kf_guild_war = NewStatusKfGWar};
                ship_id ->
                    #player_status{status_kf_guild_war = StatusKfGWar} = Status,
                    NewStatusKfGWar = StatusKfGWar#status_kf_guild_war{ship_id = Value},
                    NewStatus = Status#player_status{status_kf_guild_war = NewStatusKfGWar};
                task_attr ->
                    TmpStatus = Status#player_status{task_attr=Value},
                    NewStatus = lib_player:count_player_attribute(TmpStatus),
                    mod_scene_agent:update(Status, [{battle_attr, NewStatus#player_status.battle_attr}]),
                    lib_player:send_attribute_change_notify(NewStatus, ?NOTIFY_ATTR);
                pk_endtime ->
                    NewStatus = Status#player_status{pk_endtime = Value};
                fashion_replace ->
                    Figure = Status#player_status.figure,
                    NewFigure = Figure#figure{fashion_model = Value},
                    NewStatus = Status#player_status{figure = NewFigure};
                world_lv ->
                    mod_scene_agent:update(Status, [{world_lv, Value}]),
                    NewStatus = Status;
                last_battle_time -> %%上次战斗时间
                    NewStatus = Status#player_status{last_att_time = Value, last_beatt_time = Value};
                recalc_attr ->
                    NewStatus = lib_player:count_player_attribute(Status),
                    lib_player:send_attribute_change_notify(NewStatus, ?NOTIFY_ATTR);
                is_change_scene_log ->
                    NewStatus = Status#player_status{is_change_scene_log = Value};
                drop_rule_modifier ->
                    NewStatus = Status#player_status{drop_rule_modifier = Value};
                terri_status ->
                    NewStatus = Status#player_status{terri_status = Value};
                camp ->
                    NewStatus = Status#player_status{camp_id = Value};
                change_passive_skill ->
                    #player_status{skill = SkillStatus} = Status,
                    mod_scene_agent:update(Status, [{change_passive_skill, Value}]),
                    SkillStatus1 = SkillStatus#status_skill{skill_passive = Value},
                    NewStatus = Status#player_status{skill = SkillStatus1};
                all_hp ->
                    BA = Status#player_status.battle_attr,
                    #battle_attr{attr = Attr} = BA,
                    NewBA = BA#battle_attr{hp = Value, hp_lim = Value, attr = Attr#attr{hp = Value}},
                    NewStatus = Status#player_status{battle_attr = NewBA};
                set_att -> %%这里只改变固定属性
                    #player_status{scene = SceneId, scene_pool_id = PoolId, battle_attr = BA, id = Id, x = X, y = Y, copy_id = CopyId} = Status,
                    % #battle_attr{attr = Attr} = BA,
                    % AttrList = lib_player_attr:to_kv_list(Attr),
                    Fun = fun({K, V}, Acc) ->
                        lists:keystore(K, 1, Acc, {K, V})
                    end,
                    NewAttrList = lists:foldl(Fun, [], Value),
                    NewAttr = lib_player_attr:to_attr_record(NewAttrList),
                    NewBA = BA#battle_attr{attr = NewAttr},
                    NewStatus1 = Status#player_status{battle_attr = NewBA},
                    NewStatus = lib_player:count_player_attribute(NewStatus1),
                    #battle_attr{hp = Hp, hp_lim = HpLim} = NewStatus#player_status.battle_attr,
                    #player_status{skill = SkillStatus} = NewStatus,
                    #status_skill{skill_passive = PassiveSkills} = SkillStatus,
                    {ok, BinData} = pt_120:write(12009, [Id, Hp, HpLim]), %% 广播玩家血量变化
                    mod_scene_agent:send_to_area_scene(SceneId, PoolId, CopyId, X, Y, BinData),
                    mod_scene_agent:update(NewStatus, [{passive_skill, PassiveSkills}, {battle_attr, NewStatus#player_status.battle_attr}]),
                    lib_server_send:send_to_sid(Status#player_status.sid, BinData),%%客户端要求先推12009 再12033
                    lib_player:send_attribute_change_notify(NewStatus, ?NOTIFY_ATTR),
                    NewStatus;
                del_hp_each_time ->
                    NewStatus = Status#player_status{del_hp_each_time = Value};
                nine_mod ->
                    case Value of
                        {NineMod, LayerId} ->
                            #player_status{nine_battle = NineBattle} = Status,
                            case NineBattle of
                                #nine_battle{} ->
                                    NineBattleNew = NineBattle#nine_battle{mod = NineMod, layer_id = LayerId};
                                _ ->
                                    NineBattleNew = #nine_battle{mod = NineMod, layer_id = LayerId}
                            end,
                            NewStatus = Status#player_status{nine_battle = NineBattleNew};
                        _ ->
                            NewStatus = Status
                    end;
                _->
                    NewStatus = Status
            end,
            set_data_sub(T, NewStatus);
        _ -> Status
    end.

%% 分类设置/更新玩家信息|(因为各属性更改规则不一致，故需要特殊写规则，请维护上面set_data_sub()函数)
%% @param Type 更新数据的类型_根据此类型来对Info解包
%% @param Info 更新所包含的数据
handle_cast({'set_data', AttrKeyValueList}, Status) ->
    %% 根据类型_调用各个功能自己的组合函数来更新玩家信息，请维护set_data_sub()函数。
    case set_data_sub(AttrKeyValueList,Status) of
        NewPlayerStatus when is_record(NewPlayerStatus, player_status) ->
            {noreply, NewPlayerStatus};
        Other ->
            ?ERR("mod_server_cast set_data error:~p~n", [Other]),
            throw(error_player_status),
            {noreply, Status}
    end;

handle_cast({'update_player_scene_info', AttrKeyValueList}, Status) ->
    mod_scene_agent:update(Status, AttrKeyValueList),
    {noreply, Status};

handle_cast({'update_player_ship_info', ShipId}, Status) ->
    #player_status{status_kf_guild_war = StatusKfGWar} = Status,
    NewStatusKfGWar = StatusKfGWar#status_kf_guild_war{ship_id = ShipId},
    NewStatus = Status#player_status{status_kf_guild_war = NewStatusKfGWar},
    LastStatus = lib_player:count_player_attribute(NewStatus),
    {noreply, LastStatus};

%% 调用模块函数
handle_cast({'apply_cast', CastType, Moudle, Method, Args}, Status) ->
    if
        CastType == ?APPLY_CAST -> NewArgs = Args;
        CastType == ?APPLY_CAST_STATUS orelse
        CastType == ?APPLY_CAST_SAVE -> NewArgs = [Status|Args]
    end,
    case apply(Moudle, Method, NewArgs) of
        NewStatus when is_record(NewStatus, player_status) ->
            {noreply, NewStatus};
        {ok, NewStatus} when is_record(NewStatus, player_status) ->
            {noreply, NewStatus};
        {ok, Value, NewStatus} ->
            if
                Value == battle_attr orelse Value == equip -> %% 更新战斗属性,更新装备属性
                    mod_scene_agent:update(NewStatus, [{battle_attr, NewStatus#player_status.battle_attr}]);
                true ->
                    skip
            end,
            {noreply, NewStatus};
        {NewStatus, _} when is_record(NewStatus, player_status) ->
            {noreply, NewStatus};
        _Info when CastType == ?APPLY_CAST_SAVE ->
            ?ERR("mod_server_cast apply_cast error CastType = ~p, Moudle = ~p, Method = ~p, Args = ~p, Reason = ~p~n",
                 [CastType, Moudle, Method, Args, _Info]),
            throw(error_player_status),
            {noreply, Status};
        _R ->
            {noreply, Status}
    end;

handle_cast({'send_reward', RewardList, ProduceType, SubType}, Status) ->
    NewStatus = lib_goods_api:send_reward(Status, RewardList, ProduceType, SubType),
    lib_player:send_attribute_change_notify(NewStatus, ?NOTIFY_MONEY),
    {noreply, NewStatus};

handle_cast({'send_reward', Produce}, Status) ->
    NewStatus = lib_goods_api:send_reward(Status, Produce),
    lib_player:send_attribute_change_notify(NewStatus, ?NOTIFY_MONEY),
    {noreply, NewStatus};

%% handle_cast({'send_cluster_drop_reward', DropArgs, DropReward, ProduceType}, Status) ->
%%     NewStatus = lib_drop:send_cluster_drop_reward_ps(Status, DropArgs, DropReward, ProduceType),
%%     lib_player:send_attribute_change_notify(NewStatus, ?NOTIFY_MONEY),
%%     {noreply, NewStatus};

%% 发送掉落物品(跨服和本服都是这里)
handle_cast({'send_drop_reward', DropArgs, DropReward, ProduceType}, Status) ->
    NewStatus = lib_drop:send_drop_reward_helper(Status, DropArgs, DropReward, ProduceType),
    lib_player:send_attribute_change_notify(NewStatus, ?NOTIFY_MONEY),
    {noreply, NewStatus};

%% [通用]玩家离开场景处理
handle_cast({'leave_scene', _LeaveType, _Args}, Status) ->
    {noreply, Status};

handle_cast({'leave_scene'}, Status) ->
    lib_scene:leave_scene(Status),
    {noreply, Status};

%%更改玩家场景
handle_cast({'change_scene', SceneId, ScenePoolId, CopyId, X, Y, NeedOut, KeyValueList}, Status) ->
    NewStatus = case lib_scene:is_dungeon_scene(Status#player_status.scene) of
                    true ->
                        %% 副本地图无法传送.
                        ErrorCode = ?ERRCODE(err120_cannot_transfer_in_dungeon),
                        {ok, BinData} = pt_120:write(12005, [0, X, Y, ErrorCode, 0, 0, 0]),
                        lib_server_send:send_to_sid(Status#player_status.sid, BinData),
                        Status;
                    _ ->
                        lib_scene:change_scene(Status, SceneId, ScenePoolId, CopyId, X, Y, NeedOut, KeyValueList)
                end,
    {noreply, NewStatus};

%%更改玩家到默认场景
handle_cast({'change_default_scene', KeyValueList}, Status) ->
    NewStatus = lib_scene:change_default_scene(Status, KeyValueList),
    {noreply, NewStatus};

%%更改玩家到relogin场景
handle_cast({'change_relogin_scene', KeyValueList}, Status) ->
    NewStatus = lib_scene:change_relogin_scene(Status, KeyValueList),
    {noreply, NewStatus};

%% 标志排队换线
handle_cast({'change_scene_sign', [SceneId, ScenePoolId, CopyId, X, Y, NeedOut, KeyValueList]}, Status) ->
    case lib_scene:is_dungeon_scene(Status#player_status.scene) of
        true ->
            %% 副本地图无法传送.
            % {ok, BinData} = pt_120:write(12005, [0, 0, 0, ?ERRCODE(err120_transtype), 0, CallBackValue, TransType]),
            % lib_server_send:send_to_sid(Status#player_status.sid, BinData),
            {noreply, Status};
        _ ->
            case SceneId == Status#player_status.scene of %% 如果已经在这个场景了就不要使用排队传送了
                true -> {noreply, Status};
                false ->
                    %% 发送到排队进程
                    case lib_scene:is_clusters_scene(SceneId) of
                        true ->
                            Node = mod_disperse:get_clusters_node(),
                            mod_clusters_node:apply_cast(mod_change_scene_cls_center, cls_cen_change_scene_queue,
                                                         [Node, Status#player_status.id, Status#player_status.pid,
                                                          SceneId, ScenePoolId, CopyId, X, Y, NeedOut, KeyValueList]);
                        false ->
                            misc:get_global_pid(mod_change_scene) ! {'change_scene', Status#player_status.id, Status#player_status.pid,
                                                                     SceneId, ScenePoolId, CopyId, X, Y, NeedOut, KeyValueList}
                    end,
                    {noreply, Status#player_status{change_scene_sign = 1}}
            end
    end;

%% 刷新日常(凌晨12点)
handle_cast({'refresh_and_clear_daily', ?TWELVE}, Status)  ->
    gen_server:cast(Status#player_status.dailypid, {daily_clear, ?TWELVE, Status#player_status.id}),
    lib_login_reward:across_zero(Status),
    lib_login_reward_merge:across_zero(Status),
    RechargeStatus = lib_recharge_cumulation:update_daily(Status),
    StrongStatus = lib_to_be_strong:daily_reset(RechargeStatus, ?TWELVE),
    DunStatus = lib_dungeon_api:daily_reset_12(StrongStatus),
    BossPlayer = DunStatus,
%%    Kf3v3Status = lib_3v3_local:daily_check(DunStatus),
    AdvenPlayer = lib_adventure:clear_daily(BossPlayer),
    DelayResetMFAs = [
        {lib_3v3_local, daily_check},
        {lib_treasure_evaluation, player_daily_check}
    ],
    Delay = urand:rand(1, ?DELAY_DAILY_TIME_SPACE),
    erlang:send_after(Delay, self(), {delay_refresh_and_clear_daily, DelayResetMFAs}),
    lib_game:send_game_info(DunStatus),
    lib_boss:updata_boss_info(Status),
    {noreply, AdvenPlayer};

%% 刷新日常(凌晨4点)
handle_cast({'refresh_and_clear_daily', ?FOUR}, Status)  ->
    gen_server:cast(Status#player_status.dailypid, {daily_clear, ?FOUR, Status#player_status.id}),
    %% 世界boss和幻兽之域的疲劳值
    %NewEudemonsBoss = lib_eudemons_land:update_eudemons_boss_info(Status),
    DungeonPlayer = lib_dungeon:daily_reset(Status, ?FOUR),
    StrongStatus = lib_to_be_strong:daily_reset(DungeonPlayer, ?FOUR),
    BossPlayer = StrongStatus#player_status{boss_tired = 0, temple_boss_tired = 0, phantom_tired = 0},
    lib_saint:daily_reset(BossPlayer),
    lib_game:send_game_info(BossPlayer),
    {noreply, BossPlayer};

%% 刷新日常(中午12点)
handle_cast({'refresh_and_clear_midday'}, Status)  ->
    Player = lib_bonus_monday:send_info_midday(Status),
    {noreply, Player};

%% 清理在线玩家的周数据
handle_cast({'refresh_and_clear_week'}, Status)  ->
    gen_server:cast(Status#player_status.week_pid, {week_clear_0}),
    {noreply, Status};

%% 清理在线玩家的任务数据
handle_cast({'refresh_and_clear_task', Time}, Status)  ->
    mod_task:each_daily_clear(Status#player_status.tid, lib_task_api:ps2task_args(Status), Time),
    {noreply, Status};

%% 记录玩家vip升级数据
handle_cast({'log_vip_upgrade'}, Status) ->
    lib_vip:log_vip_upgrade(Status),
    {noreply, Status};

%% 刷新榜单
handle_cast({'refresh_average_lv_20'}, State)->
    lib_player:send_world_exp_add_to_client(State),
    {noreply, State};

%% gm删除任务秘籍
handle_cast({'gm_del_task', RoleId, TaskId}, State)->
    #player_status{id = Id} = State,
    if
        RoleId =/= Id ->
            ?ERR("~p ~p RoleId error:~p~n", [?MODULE, ?LINE, [RoleId, Id]]),
            skip;
        true ->
            case data_task:get(TaskId) of
                null ->
                    ?ERR("~p ~p TaskId error:~p~n", [?MODULE, ?LINE, [TaskId]]),
                    skip;
                _    ->
                    mod_task:del_task(State#player_status.tid, TaskId, lib_task_api:ps2task_args(State))
            end
    end,
    {noreply, State};

handle_cast({'trigger_task_special', Event, Params, Id}, State) ->
    gen_server:cast(State#player_status.tid, {action, [Id, Event, Params]}),
    {noreply, State};

handle_cast({'clear_exchange_counter'}, State) ->
    Ids = data_exchange:get_ids(?EXCHANGE_TYPE_KF_1VN),
    mod_counter:clear(State#player_status.id, ?MOD_GOODS, ?MOD_GOODS_EXCHANGE, Ids),
    {noreply, State};

handle_cast({'refresh_ser_name', ServerName}, Status)  ->
    NewStatus = Status#player_status{server_name = ServerName},
    {noreply, NewStatus};

handle_cast({'reload_c_server_msg', CServerMsg}, Status)  ->
    NewStatus = Status#player_status{c_server_msg = CServerMsg},
    {noreply, NewStatus};

handle_cast({'reload_server_type', ServerType}, Status)  ->
    NewStatus = Status#player_status{server_type = ServerType},
    {noreply, NewStatus};

handle_cast(_Event, Status) ->
    {noreply, Status}.
