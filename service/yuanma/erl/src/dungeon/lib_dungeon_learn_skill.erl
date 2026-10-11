%% ---------------------------------------------------------------------------
%% @doc lib_dungeon_learn_skill.erl

%% @author  hjh
%% @email  hejiahua@163.com
%% @since  2017-02-23
%% @deprecated 副本技能列表
%% ---------------------------------------------------------------------------
-module(lib_dungeon_learn_skill).
-compile(export_all).
-include("server.hrl").
-include("dungeon.hrl").
-include("def_module.hrl").
-include("predefine.hrl").
-include("common.hrl").
-include("attr.hrl").
-include("figure.hrl").
-include("def_fun.hrl").
-include("skill.hrl").

%% 登录
login(Player) ->
    #player_status{id = RoleId, figure = #figure{career = Career}, tid = _Tid} = Player,
    DunIdList = data_dungeon_learn_skill:get_learn_skill_dun_id_list(),
    % 获取完成的副本id
    FinishList = mod_counter:get_count_offline(RoleId, ?MOD_DUNGEON, ?MOD_DUNGEON_ENTER, DunIdList),
    FinishDunIdList = [DunId||{DunId, Count}<-FinishList, Count>0],
    F = fun(DunId, List) ->
        CareerSkillL = data_dungeon_learn_skill:get_learn_skill_list_by_dun_id(DunId),
        {Career, SkillL} = ulists:keyfind(Career, 1, CareerSkillL, {Career, []}),
        F2 = fun({SkillId, SkillLv}, TmpSkillL) ->
            case lists:keyfind(SkillId, 1, TmpSkillL) of
                {SkillId, OldSkillLv} -> NewSkillLv = max(OldSkillLv, SkillLv);
                _ -> NewSkillLv = SkillLv
            end,
            lists:keystore(SkillId, 1, TmpSkillL, {SkillId, NewSkillLv})
        end,
        lists:foldl(F2, List, SkillL)
    end,
    SkillList = lists:foldl(F, [], FinishDunIdList),
    SkillAttr = lib_skill:get_passive_skill_attr(SkillList),
    SkillPower = lib_skill_api:get_skill_power(SkillList),
    PassiveSkillL = lib_skill:divide_passive_skill(SkillList),
    PassiveShareSkillL = lib_skill:divide_team_passive_share_skill(SkillList),
    StatusDunSkill = #status_dungeon_skill{
        skill_list = SkillList, skill_attr = SkillAttr, skill_power = SkillPower, 
        passive_skill_list = PassiveSkillL, passive_share_skill_list = PassiveShareSkillL
        },
    % ?MYLOG("dunskill", "RoleId:~p StatusDunSkill:~p ~n", [RoleId, StatusDunSkill]),
    Player#player_status{dungeon_skill = StatusDunSkill}.

%% 完成任务触发
finish_task(Player, _TaskId) -> {ok, Player}.

%% 是否触发副本学习技能
is_do_dungeon_learn_skill(_TaskId) -> false.

%% 完成副本触发
fin_dun(#player_status{figure = #figure{career = Career}, dungeon_skill = StatusDunSkill} = Player, DunId) ->
    #status_dungeon_skill{skill_list = SkillList} = StatusDunSkill,
    case data_dungeon_learn_skill:get_learn_skill_list_by_dun_id(DunId) of
        [] -> {ok, Player};
        CareerSkillL -> 
            {Career, CfgSkillL} = ulists:keyfind(Career, 1, CareerSkillL, {Career, []}),
            % ?MYLOG("dunskill", "DunId:~p CfgSkillL:~p ~n", [DunId, CfgSkillL]),
            % 技能和计算
            F2 = fun({SkillId, SkillLv}, {TmpSkillL, ChangeSkillL}) ->
                case lists:keyfind(SkillId, 1, TmpSkillL) of
                    {SkillId, OldSkillLv} -> NewSkillLv = max(OldSkillLv, SkillLv);
                    _ -> NewSkillLv = SkillLv
                end,
                NewTmpSkillL = lists:keystore(SkillId, 1, TmpSkillL, {SkillId, NewSkillLv}),
                NewChangeSkillL = lists:keystore(SkillId, 1, ChangeSkillL, {SkillId, NewSkillLv}),
                {NewTmpSkillL, NewChangeSkillL}
            end,
            {NewSKillList, ChangeSkillL}  = lists:foldl(F2, {SkillList, []}, CfgSkillL),
            SkillAttr = lib_skill:get_passive_skill_attr(NewSKillList),
            SkillPower = lib_skill_api:get_skill_power(NewSKillList),
            PassiveSkillL = lib_skill:divide_passive_skill(NewSKillList),
            PassiveShareSkillL = lib_skill:divide_team_passive_share_skill(NewSKillList),
            NewStatusDunSkill = StatusDunSkill#status_dungeon_skill{
                skill_list = NewSKillList, skill_attr = SkillAttr, skill_power = SkillPower, 
                passive_skill_list = PassiveSkillL, passive_share_skill_list = PassiveShareSkillL
                },
            PlayerAfSave = Player#player_status{dungeon_skill = NewStatusDunSkill},
            NewPlayer = lib_player:count_player_attribute(PlayerAfSave),
            #player_status{battle_attr = BattleAttr} = NewPlayer,
            lib_player:send_attribute_change_notify(NewPlayer, ?NOTIFY_ATTR),
            % 场景处理
            ChangePassiveSkillL = lib_skill:divide_passive_skill(ChangeSkillL),
            ScenePassiveList = ?IF(ChangePassiveSkillL==[], [], [{passive_skill, ChangeSkillL}]),
            mod_scene_agent:update(NewPlayer, [{battle_attr, BattleAttr}]++ScenePassiveList),
            % 队伍处理
            ChangePassiveShareSkillL = lib_skill:divide_team_passive_share_skill(ChangeSkillL),
            lib_team_api:update_team_mb(NewPlayer, [{add_share_skill_list, ChangePassiveShareSkillL}]),
            lib_skill:send_passive_share_skill_list(NewPlayer),
            % ?MYLOG("dunskill", "RoleId:~p StatusDunSkill:~p NewStatusDunSkill:~p ~n", [Player#player_status.id, StatusDunSkill, NewStatusDunSkill]),
            send_info(NewPlayer),
            send_tv(NewPlayer, DunId, CfgSkillL),
            {ok, NewPlayer}
    end.

%% 发送信息
send_info(Player) -> 
    #player_status{id = RoleId, dungeon_skill = StatusDunSkill} = Player,
    #status_dungeon_skill{skill_list = SkillList} = StatusDunSkill,
    {ok, BinData} = pt_611:write(61101, [SkillList]),
    lib_server_send:send_to_uid(RoleId, BinData),
    ok.

send_tv(Player, DunId, [{SkillId, SkillLv}|_]) ->
    #player_status{figure = #figure{name = RoleName}} = Player,
    case data_dungeon:get(DunId) of
        #dungeon{name = DungeonName} -> ok;
        _ -> DungeonName = <<""/utf8>>
    end,
    case data_skill:get(SkillId, SkillLv) of
        #skill{name = SkillName, lv_data = #skill_lv{desc = SkillDesc}} -> ok;
        _ -> SkillName = <<""/utf8>>, SkillDesc = <<""/utf8>>
    end,
    lib_chat:send_TV({all}, ?MOD_DUNGEON, 10, [RoleName, DungeonName, SkillName, SkillDesc]),
    ok;
send_tv(_, _, _) ->
    skip.

%% 获得被动共享技能列表
get_passive_share_skill_list(Player) ->
    #player_status{dungeon_skill = #status_dungeon_skill{passive_share_skill_list = PassiveShareSkillL}} = Player,
    PassiveShareSkillL.