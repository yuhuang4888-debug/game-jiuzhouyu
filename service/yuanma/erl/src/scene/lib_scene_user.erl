%% ---------------------------------------------------------------------------
%% @doc 场景玩家
%% @author hek
%% @since  2016-09-22
%% @deprecated 本模块更新场景玩家属性
%% ---------------------------------------------------------------------------
-module(lib_scene_user).
-export([set_data_sub/2, is_ban_passive_skill/1, broadcast_user_collect/6]).
-include("scene.hrl").
-include("attr.hrl").
-include("figure.hrl").
-include("common.hrl").
-include("team.hrl").
-include("eudemons_land.hrl").
-include("boss.hrl").
-include("seacraft.hrl").

%% 设置场景玩家属性(按属性列表更新)
%% @param AttrKeyValueList 属性列表 [{Key,Value}] Key为原子类型，Value为所需参数数据
%% @param SceneUser     当前状态
%% @return NewSceneUser 新状态
set_data_sub([], SceneUser) -> SceneUser;
set_data_sub([{Key, Value} | T], SceneUser) ->
    NewSceneUser = case Key of
        %% 气血回复
        name ->
            #ets_scene_user{figure = Figure} = SceneUser,
            NewFigure = Figure#figure{name = Value},
            SceneUser#ets_scene_user{figure = NewFigure};
        designation ->
            #ets_scene_user{figure = Figure} = SceneUser,
            NewFigure = Figure#figure{designation = Value},
            SceneUser#ets_scene_user{figure = NewFigure};
        battle_attr ->
            SceneUser#ets_scene_user{battle_attr = Value};
        picture ->
            {Picture, PictureVer} = Value,
            #ets_scene_user{figure = Figure} = SceneUser,
            NewFigure = Figure#figure{picture = Picture, picture_ver = PictureVer},
            SceneUser#ets_scene_user{figure = NewFigure};
        guild ->
            {GuildId, GuildName, Position, PositionName} = Value,
            #ets_scene_user{figure = Figure} = SceneUser,
            NewFigure = Figure#figure{
                guild_id = GuildId, guild_name = GuildName, position = Position,
                position_name = PositionName},
            SceneUser#ets_scene_user{figure = NewFigure};
        team_flag ->
            %% 离开广播给怪物
            #ets_scene_user{id = RoleId, copy_id = CopyId, x = TX, y = TY} = SceneUser,
            {X, Y} = lib_scene_calc:pixel_to_logic_coordinate(TX, TY),
            [Aid ! {'team_flag', RoleId, Value#status_team.team_id} || Aid <- lib_scene_object_agent:get_trace(CopyId, X, Y)],
            SceneUser#ets_scene_user{team = Value};
        pk ->
            BA = SceneUser#ets_scene_user.battle_attr,
            SceneUser#ets_scene_user{battle_attr = BA#battle_attr{pk = Value}};
        scene_partner ->
            SceneUser#ets_scene_user{scene_partner = Value};
        mount_figure ->
            {TypeId, _FigureId, _} = Value,
            Figure = SceneUser#ets_scene_user.figure,
            %%                  ?PRINT("Value:~w mount_figure :~p~n",[Value,Figure#figure.mount_figure]),
            MonFigure = lists:keystore(TypeId, 1, Figure#figure.mount_figure, Value),
            NewFigure = Figure#figure{mount_figure = MonFigure},
            SceneUser#ets_scene_user{figure = NewFigure};
        mount_figure_ride ->
            {TypeId, _IsRide} = Value,
            Figure = SceneUser#ets_scene_user.figure,
            MonFigureRide = lists:keystore(TypeId, 1, Figure#figure.mount_figure_ride, Value),
            NewFigure = Figure#figure{mount_figure_ride = MonFigureRide},
            SceneUser#ets_scene_user{figure = NewFigure};
        wing_figure ->
            #ets_scene_user{figure = Figure} = SceneUser,
            NewFigure = Figure#figure{wing_figure = Value},
            SceneUser#ets_scene_user{figure = NewFigure};
        fairy_figure ->
            #ets_scene_user{figure = Figure} = SceneUser,
            NewFigure = Figure#figure{fairy_figure = Value},
            SceneUser#ets_scene_user{figure = NewFigure};
        fashion_model ->
            #ets_scene_user{figure = Figure} = SceneUser,
            NewFigure = Figure#figure{fashion_model = Value},
            SceneUser#ets_scene_user{figure = NewFigure};
        baby_id ->
            {ResourceId, BabyIfShow} = Value,
            #ets_scene_user{figure = Figure} = SceneUser,
            NewFigure = Figure#figure{
            baby_id = ResourceId,
            baby_if_show = BabyIfShow
            },
            SceneUser#ets_scene_user{figure = NewFigure};
        add_partner ->
            {PartnerId, _, _} = Value,
            NewScenePartner = [Value | lists:keydelete(PartnerId, 1, SceneUser#ets_scene_user.scene_partner)],
            SceneUser#ets_scene_user{scene_partner = NewScenePartner};
        weapon_effect ->
            #ets_scene_user{figure = Figure} = SceneUser,
            NewFigure = Figure#figure{weapon_effect = Value},
            SceneUser#ets_scene_user{figure = NewFigure};
        vip ->
            [VipType, VipLv] = Value,
            #ets_scene_user{figure = Figure} = SceneUser,
            NewFigure = Figure#figure{vip_type = VipType, vip = VipLv},
            SceneUser#ets_scene_user{figure = NewFigure};
        vip_hide ->
            #ets_scene_user{figure = Figure} = SceneUser,
            NewFigure = Figure#figure{vip_hide = Value},
            SceneUser#ets_scene_user{figure = NewFigure};
        follow_target_xy ->
            SceneUser#ets_scene_user{follow_target_xy = Value};
        lv_model ->
            #ets_scene_user{figure = Figure} = SceneUser,
            NewFigure = Figure#figure{lv_model = Value},
            SceneUser#ets_scene_user{figure = NewFigure};
        god_equip_model ->
            #ets_scene_user{figure = Figure} = SceneUser,
            NewFigure = Figure#figure{god_equip_model = Value},
            SceneUser#ets_scene_user{figure = NewFigure};
        liveness ->
            #ets_scene_user{figure = Figure} = SceneUser,
            NewFigure = Figure#figure{liveness = Value},
            SceneUser#ets_scene_user{figure = NewFigure};
        turn ->
            #ets_scene_user{figure = Figure} = SceneUser,
            NewFigure = Figure#figure{turn = Value},
            SceneUser#ets_scene_user{figure = NewFigure};
        holy_ghost_figure ->
            case Value of
                {HGhostFigure, HideStatus} ->
                    #ets_scene_user{figure = Figure} = SceneUser,
                    NewFigure = Figure#figure{h_ghost_figure = HGhostFigure, h_ghost_display = HideStatus},
                    SceneUser#ets_scene_user{figure = NewFigure};
                _ -> SceneUser
            end;
        passive_skill ->
            case is_ban_passive_skill(SceneUser) of
                true -> SceneUser;
                false ->
                    F = fun({SkillId, SLv}, TSkills) -> lists:keystore(SkillId, 1, TSkills, {SkillId, SLv}) end,
                    NewSkillPassive = lists:foldl(F, SceneUser#ets_scene_user.skill_passive, Value),
                    SceneUser#ets_scene_user{skill_passive = NewSkillPassive}
            end;
        %% pet_passive_skill ->
        %%     F = fun({SkillId, SLv}, TSkills) -> lists:keystore(SkillId, 1, TSkills, {SkillId, SLv}) end,
        %%     NewSkillPassive = lists:foldl(F, SceneUser#ets_scene_user.pet_passive_skill, Value ),
        %%     SceneUser#ets_scene_user{pet_passive_skill = NewSkillPassive};
        delete_passive_skill ->
            F = fun({SkillId, _SLv}, TSkills) -> lists:keydelete(SkillId, 1, TSkills) end,
            NewSkillPassive = lists:foldl(F, SceneUser#ets_scene_user.skill_passive, Value),
            SceneUser#ets_scene_user{skill_passive = NewSkillPassive};
        skill_passive_share ->
            case is_ban_passive_skill(SceneUser) of
                true -> SceneUser;
                false -> SceneUser#ets_scene_user{skill_passive_share = Value}
            end;
        add_skill_passive_share ->
            case is_ban_passive_skill(SceneUser) of
                true -> SceneUser;
                false ->
                    F = fun({SkillId, SLv}, TSkills) -> lists:keystore(SkillId, 1, TSkills, {SkillId, SLv}) end,
                    NewSkillPassive = lists:foldl(F, SceneUser#ets_scene_user.skill_passive_share, Value),
                    SceneUser#ets_scene_user{skill_passive_share = NewSkillPassive}
            end;
        delete_skill_passive_share ->
            F = fun({SkillId, _SLv}, TSkills) -> lists:keydelete(SkillId, 1, TSkills) end,
            NewSkillPassive = lists:foldl(F, SceneUser#ets_scene_user.skill_passive_share, Value),
            SceneUser#ets_scene_user{skill_passive_share = NewSkillPassive};
        tmp_attr_skill ->
            F = fun({SkillId, SLv}, TSkills) -> lists:keystore(SkillId, 1, TSkills, {SkillId, SLv}) end,
            SkillL = lists:foldl(F, SceneUser#ets_scene_user.tmp_attr_skill, Value),
            count_total_sec_map(SceneUser#ets_scene_user{tmp_attr_skill = SkillL});
        delete_tmp_attr_skill ->
            F = fun({SkillId, _SLv}, TSkills) -> lists:keydelete(SkillId, 1, TSkills) end,
            SkillL = lists:foldl(F, SceneUser#ets_scene_user.tmp_attr_skill, Value),
            count_total_sec_map(SceneUser#ets_scene_user{tmp_attr_skill = SkillL});
        qucikbar ->
            QuickbarSkill = [{SkillId, 1} || {_, _, SkillId, _} <- Value, SkillId =/= 10001],
            SceneUser#ets_scene_user{quickbar = QuickbarSkill};
        boss_tired ->
            SceneUser#ets_scene_user{boss_tired = Value};
        temple_boss_tired ->
            SceneUser#ets_scene_user{temple_boss_tired = Value};
        phantom_tired ->
            SceneUser#ets_scene_user{phantom_tired = Value};  
        fairyland_tired ->
            SceneUser#ets_scene_user{fairyland_tired = Value};
        marriage ->
            {MarriageType, LoverRoleId} = Value,
            SceneUser#ets_scene_user{marriage_type = MarriageType, lover_role_id = LoverRoleId};
        bl_who ->
            SceneUser#ets_scene_user{bl_who = Value};
        bl_who_op ->
            #ets_scene_user{bl_who_list = BlWhoL} = SceneUser,
            {ObjectId, BlWho} = Value,
            NewBlWhoL = case BlWho == 0 of
                true -> lists:delete(ObjectId, BlWhoL);
                false -> [ObjectId|lists:delete(ObjectId, BlWhoL)]
            end,
            SceneUser#ets_scene_user{bl_who_list = NewBlWhoL};
        eudemons_boss_tired ->
            SceneUser#ets_scene_user{eudemons_boss_tired = Value};
        eudemons_boss_clinfo ->
            SceneUser#ets_scene_user{eudemons_cl_info = Value};
        treasure_chest ->
            SceneUser#ets_scene_user{treasure_chest = Value};
        baby_attr ->
            SceneUser#ets_scene_user{baby_battle_attr = Value};
        pet_battle_attr ->
            SceneUser#ets_scene_user{pet_battle_attr = Value};
        talisman_battle_attr ->
            SceneUser#ets_scene_user{talisman_battle_attr = Value};
        holyghost_battle_attr ->
            SceneUser#ets_scene_user{holyghost_battle_attr = Value};
        husong_angle_id ->
            Figure = SceneUser#ets_scene_user.figure,
            NewFigure = Figure#figure{
                husong_angel_id = Value
            },
            SceneUser#ets_scene_user{figure = NewFigure};
        mate_role_id ->
            #ets_scene_user{id = Id, x = X, y = Y, copy_id = CopyId} = SceneUser,
            {ok, BinData} = pt_120:write(12076, [Id, Value]),
            case lib_scene:is_broadcast_scene(SceneUser#ets_scene_user.scene) of
                true ->
                    lib_scene_agent:send_to_local_scene(CopyId, BinData);
                _ ->
                    lib_scene_agent:send_to_local_area_scene(CopyId, X, Y, BinData)
            end,
            SceneUser#ets_scene_user{mate_role_id = Value};
        house ->
            {BlockId, HouseId, HouseLv} = Value,
            Figure = SceneUser#ets_scene_user.figure,
            NewFigure = Figure#figure{
                home_id = {BlockId, HouseId},
                house_lv = HouseLv
            },
            SceneUser#ets_scene_user{figure = NewFigure};
        figure ->
            SceneUser#ets_scene_user{figure = Value};
        clear_collect_info ->
            case SceneUser#ets_scene_user.collect_pid of
                Value ->
                    SceneUser#ets_scene_user{collect_pid = {0, 0}, collect_etime = 0};
                _ -> SceneUser
            end;
        in_sea ->
            SceneUser#ets_scene_user{in_sea = Value};
        ship_id ->
            SceneUser#ets_scene_user{ship_id = Value};
        %% 正式代码加载上面：测试cd
        nocd ->
            if
                Value == 1 -> put({nocd, SceneUser#ets_scene_user.id}, 1);
                true -> erase({nocd, SceneUser#ets_scene_user.id})
            end,
            SceneUser;
        scene_train_attr ->
            {Sign, Attr} = Value,
            #ets_scene_user{train_object = SceneTrainObjMap} = SceneUser,
            case maps:get(Sign, SceneTrainObjMap, []) of
                [] -> SceneUser;
                #scene_train_object{battle_attr = BA} = SceneTrainObj -> 
                    NewSceneTrainObj = SceneTrainObj#scene_train_object{battle_attr = BA#battle_attr{attr = Attr}},
                    NewSceneTrainObjMap = maps:put(Sign, NewSceneTrainObj, SceneTrainObjMap),
                    SceneUser#ets_scene_user{train_object = NewSceneTrainObjMap}
            end;
        scene_train_object ->
            #scene_train_object{att_sign = Sign} = SceneTrainObj = Value,
            #ets_scene_user{train_object = SceneTrainObjMap} = SceneUser,
            NewSceneTrainObjMap = maps:put(Sign, SceneTrainObj, SceneTrainObjMap),
            SceneUser#ets_scene_user{train_object = NewSceneTrainObjMap};
        achiv_stage ->
            #ets_scene_user{figure = Figure} = SceneUser,
            SceneUser#ets_scene_user{figure = Figure#figure{achiv_stage = Value}};
        combat_power -> 
            SceneUser#ets_scene_user{combat_power = Value};
        energy ->
            BA = SceneUser#ets_scene_user.battle_attr,
            SceneUser#ets_scene_user{battle_attr = BA#battle_attr{energy = Value}};
        dress_list ->
            #ets_scene_user{figure = Figure} = SceneUser,
            SceneUser#ets_scene_user{figure = Figure#figure{dress_list = Value}};
        scene_boss_tired ->
            #scene_boss_tired{boss_type = BossType} = SceneBossTired = Value,
            #ets_scene_user{boss_tired_map = BossTiredMap} = SceneUser,
            NewBossTiredMap = maps:put(BossType, SceneBossTired, BossTiredMap),
            SceneUser#ets_scene_user{boss_tired_map = NewBossTiredMap};
        group ->
        %%                ?MYLOG("cym3", "change group ~p~n", [Value]),
            #ets_scene_user{battle_attr = BA} = SceneUser,
            NewBA = BA#battle_attr{group = Value},
            SceneUser#ets_scene_user{battle_attr = NewBA};
        world_lv ->
            SceneUser#ets_scene_user{world_lv = Value};
        god_id ->
            #ets_scene_user{figure = Figure} = SceneUser,
            NewFigure = Figure#figure{god_id = Value},
            SceneUser#ets_scene_user{figure = NewFigure};
        brick_color ->
            #ets_scene_user{figure = Figure} = SceneUser,
            NewFigure = Figure#figure{brick_color = Value},
            SceneUser#ets_scene_user{figure = NewFigure};
        revelation_suit_figure_id ->
            #ets_scene_user{figure = Figure} = SceneUser,
            NewFigure = Figure#figure{revelation_suit = Value},
            SceneUser#ets_scene_user{figure = NewFigure};
        mod_level ->
            SceneUser#ets_scene_user{mod_level = Value};
        demons_id ->
            #ets_scene_user{figure = Figure} = SceneUser,
            NewFigure = Figure#figure{demons_id = Value},
            SceneUser#ets_scene_user{figure = NewFigure};
        is_supvip ->
            #ets_scene_user{figure = Figure} = SceneUser,
            NewFigure = Figure#figure{is_supvip = Value},
            SceneUser#ets_scene_user{figure = NewFigure};
        is_hurt_mon ->
            #ets_scene_user{battle_attr = BA} = SceneUser,
            NewBA = BA#battle_attr{is_hurt_mon = Value},
            SceneUser#ets_scene_user{battle_attr = NewBA};
        back_decora_figure ->
            #ets_scene_user{figure = Figure} = SceneUser,
            NewFigure = Figure#figure{back_decora_figure = Value},
            SceneUser#ets_scene_user{figure = NewFigure};
        back_decora_figure_ride ->
            #ets_scene_user{figure = Figure} = SceneUser,
            NewFigure = Figure#figure{back_decora_figure_ride = Value},
            SceneUser#ets_scene_user{figure = NewFigure};
        title_id ->
            #ets_scene_user{figure = Figure} = SceneUser,
            NewFigure = Figure#figure{title_id = Value},
            SceneUser#ets_scene_user{figure = NewFigure};
        camp ->
            SceneUser#ets_scene_user{camp_id = Value};
        mask_id ->
            #ets_scene_user{figure = Figure} = SceneUser,
            NewFigure = Figure#figure{mask_id = Value},
            SceneUser#ets_scene_user{figure = NewFigure};
        assist_id ->
            SceneUser#ets_scene_user{assist_id = Value};
        change_passive_skill ->
            SceneUser#ets_scene_user{skill_passive = Value};
        all_hp ->
            #ets_scene_user{battle_attr = BA} = SceneUser,
            #battle_attr{attr = Attr} = BA,
            NewBA = BA#battle_attr{hp = Value, hp_lim = Value, attr = Attr#attr{hp = Value}},
            SceneUser#ets_scene_user{battle_attr = NewBA};
        set_att -> %%这里只改变固定属性
            #ets_scene_user{battle_attr = BA} = SceneUser,
            % #battle_attr{attr = Attr} = BA,
            % AttrList = lib_player_attr:to_kv_list(Attr),
            Fun = fun({K, V}, Acc) ->
                lists:keystore(K, 1, Acc, {K, V})
            end,
            NewAttrList = lists:foldl(Fun, [], Value),
            NewAttr = lib_player_attr:to_attr_record(NewAttrList),
            NewBA = BA#battle_attr{attr = NewAttr},
            SceneUser#ets_scene_user{battle_attr = NewBA};
        del_hp_each_time ->
            SceneUser#ets_scene_user{del_hp_each_time = Value};
        lv ->
            #ets_scene_user{figure = Figure} = SceneUser,
            SceneUser#ets_scene_user{figure = Figure#figure{lv = Value}};
        companion_skill_cd ->  %% 切换伙伴时技能CD处理
            #ets_scene_user{skill_cd = SkillCd, sid = Sid} = SceneUser,
            {OldSkillId, NewSkillId} = Value,
            case lists:keytake(OldSkillId, 1, SkillCd) of
                {value, {_, EndTime}, SkillCdTmp} ->
                    lib_server_send:send_to_sid(Sid, pt_200, 20027, [NewSkillId, EndTime]),
                    NewSkillCd = [{NewSkillId, EndTime}|SkillCdTmp];
                _ ->
                    NewSkillCd = SkillCd
            end,
            SceneUser #ets_scene_user{skill_cd = NewSkillCd};
        suit_clt_figure ->
            #ets_scene_user{figure = Figure} = SceneUser,
            NewFigure = Figure#figure{suit_clt_figure = Value},
            SceneUser#ets_scene_user{figure = NewFigure};
        is_collecting ->
            #ets_scene_user{id = Id, figure = Figure, copy_id = CopyId, scene = SceneId, x = X, y = Y} = SceneUser,
            NewFigure = Figure#figure{is_collecting = Value},
            broadcast_user_collect(SceneId, CopyId, X, Y, Id, Value),
            SceneUser#ets_scene_user{figure = NewFigure};
        _ ->
            SceneUser
    end,
    set_data_sub(T, NewSceneUser).

%% 广播采集
broadcast_user_collect(SceneId, CopyId, X, Y, RoleId, IsCollect) ->
    {ok, BinData} = pt_120:write(12010, [RoleId, [{16, IsCollect}]]),
    case lib_scene:is_broadcast_scene(SceneId) of
        true ->
            lib_scene_agent:send_to_local_scene(CopyId, BinData);
        _ ->
            lib_scene_agent:send_to_local_area_scene(CopyId, X, Y, BinData)
    end.


%% 计算第二属性
count_total_sec_map(User) ->
    #ets_scene_user{tmp_attr_skill = TmpAttrSkill, battle_attr = BA} = User,
    #battle_attr{sec_attr = SecAttr} = BA,
    TmpSecAttr = lib_skill:get_passive_skill_sec_attr(TmpAttrSkill),
    TotalSecAttr = lib_sec_player_attr:to_attr_map([SecAttr, TmpSecAttr]),
    User#ets_scene_user{battle_attr = BA#battle_attr{total_sec_attr = TotalSecAttr}}.

%% 禁止被动
is_ban_passive_skill(#ets_scene_user{scene = SceneId, battle_attr = BA}) ->
    IsInSeacraft = lib_seacraft:is_in_seacraft(SceneId),
    IsInWeekDun = lib_week_dungeon:in_week_dungeon_scene(SceneId),
    #battle_attr{group = Group} = BA,
    IsInSeacraftDaily = lib_seacraft_daily:is_scene(SceneId),
    if
        IsInWeekDun == true -> true;
        IsInSeacraft == true andalso Group == ?SHIP_TYPE_CONSTRUCTION -> true;
        IsInSeacraftDaily == true -> true;
        true -> false
    end.