%% ---------------------------------------------------------------------------
%% @doc lib_battle_util

%% @author  lzh
%% @email   lu13824949032@gmail.com
%% @since   2021/8/11 0011
%% @deprecated
%% ---------------------------------------------------------------------------
-module(lib_battle_util).

%% API 玩家进程
-export([
      use_skill_base_check/3                            %% 技能使用基本判断，判断是否拥有该技能
    , check_battle/2                                    %% 检测玩家是否能进行战斗
    , select_att_num_der/5                              %% 选择攻击人数
]).
%% API 场景进程
-export([
      trans_to_real_atter/2                             %% 修正攻击对象
    , init_data/1                                       %% 初始化战斗双方属性
    , check_start_battle/4                              %% 检查开始战斗的攻击者和受击者
    , check_use_skill/6                                 %% 检查技能使用状态，cd 与 连技状态等
    , back_data/2                                       %% 数据回写，战斗转换的battle_status转换成场景数据
    , get_boss_tired/1                                  %% 获取Boss疲劳
    , check_boss_tired/5                                %% 检查Boss疲劳
    , check_boss_missing/6                              %% 检查Boss是否Miss
    , calc_boss_type/3                                  %% 计算boss类型
    , is_need_hit_list/1                                %% 是否需要助攻列表
    , change_new_cd/4
    , make_return_atter/2
]).

-include("common.hrl").
-include("server.hrl").
-include("kf_guild_war.hrl").
-include("skill.hrl").
-include("scene.hrl").
-include("dungeon.hrl").
-include("errcode.hrl").
-include("battle.hrl").
-include("figure.hrl").
-include("attr.hrl").
-include("marriage.hrl").
-include("team.hrl").
-include("def_fun.hrl").
-include("boss.hrl").
-include("eudemons_land.hrl").

%% 检查是否可以使用此技能
%% retrun: {true, 攻击者#battle_status{}, #skill{}, MainSkillId} | {false, ErrCode, #battle_status{}}
%% 其中NextSkillId, NextSkillTime 用于场景对象使用连续技, 为0时没有连续技能
-define(ERR_CD, 5).
-define(ERR_CONF, 6).
-define(ERR_DIZZY, 21).
-define(ERR_SILENCE, 22).
-define(ERR_COMBO, 30).
-define(ERR_OTHER_BUFF, 42).
-define(ERR_ENERGY, 43).
-define(ERR_PUB_CD, 44).
-define(ERR_CD_NO, 45).

-define(COMBO_FINISH, 1).   %% 连技完成
-define(COMBO_NEXT,   2).   %% 还有后续副技能

%% =============================================== In Player Process =================================================
%% 技能使用基本判断
%% 获取最新的技能等级
%% 判断玩家是否拥有当前技能
use_skill_base_check(Status0, SkillId, NowTime) ->
    Status = add_special_skill(Status0),
    OldSR = data_skill:get(SkillId, 1),
    case do_use_skill_base_check(Status, OldSR, NowTime) of
        {false, ErrCode} -> {false, ErrCode};
        {true, IsCombo, IsTmp, SkillLv, Sign, SR} ->
            case data_skill:get(SkillId, SkillLv) of
                #skill{} = NewSR -> {true, IsCombo, IsTmp, SkillLv, Sign, NewSR};
                [] -> {true, IsCombo, IsTmp, SkillLv, Sign, SR}
            end
    end.

%% 特殊玩法临时技能添加
add_special_skill(Status) ->
    #player_status{id = _RoleId, scene = SceneId, skill = Skill, status_kf_guild_war = StatusKfGWar} = Status,
    case lib_kf_guild_war_api:is_kf_guild_war_scene(SceneId) of
        true ->
            #status_kf_guild_war{in_sea = InSea, ship_id = ShipId} = StatusKfGWar,
            case InSea == 1 of
                true -> %% 在海里要加上战舰的技能
                    ShipSkillL = lib_kf_guild_war_api:get_ship_skill(ShipId),
                    Status#player_status{skill = Skill#status_skill{skill_list = ShipSkillL ++ Skill#status_skill.skill_list}};
                _ ->
                    Status
            end;
        _ ->
            Status
    end.

do_use_skill_base_check(_Status, #skill{type = Type, is_combo = IsCombo} = SR, _NowTime) when
    (Type == ?SKILL_TYPE_ACTIVE orelse Type == ?SKILL_TYPE_ASSIST) andalso IsCombo > 0 ->
    % combo技能在mod_battle模块继承主技能等级
    {true, IsCombo, 0, 1, ?BATTLE_SIGN_PLAYER, SR};

do_use_skill_base_check(Status, #skill{id = SkillId, type = Type, is_combo = IsCombo = 0} = SR, NowTime) when
    Type == ?SKILL_TYPE_ACTIVE orelse Type == ?SKILL_TYPE_ASSIST ->
    #player_status{
        id = RoleId, skill = Skill, status_pet = Pet, baby = Baby,
        nor_att_time = NorAttTime, figure = Figure, holy_ghost = HolyGhost} = Status,
    #skill{career = Career, is_normal = IsNormal} = SR,
    if
        (Career == ?SKILL_CAREER_MATE) andalso Type == ?SKILL_TYPE_ACTIVE -> %% 伙伴技能判断
            TrainType = lib_mount:skill_career_to_train_type(Career),
            case lib_mount:check_skill_has_learn(Status, TrainType, SkillId) of
                false ->
                    {false, 6};
                true ->
                    {true, IsCombo, 0, 1, ?BATTLE_SIGN_MATE, SR}
            end;
        Career == ?SKILL_CAREER_PET andalso Type == ?SKILL_TYPE_ACTIVE -> %% 宠物技能判断
            case lib_pet:check_skill_has_learn(Pet, SkillId) of
                false -> {false, 6};
                true -> {true, IsCombo, 0, 1, ?BATTLE_SIGN_PET, SR}
            end;
        Career == ?SKILL_CAREER_BABY andalso Type == ?SKILL_TYPE_ACTIVE -> %% 宝宝技能
            case lists:member(SkillId,  Baby#baby_status.skills) of
                false -> {false, 6};
                true -> {true, IsCombo, 0, 1, ?BATTLE_SIGN_BABY, SR}
            end;
        Career == ?SKILL_CAREER_TREASURE andalso Type == ?SKILL_TYPE_ACTIVE -> %% 圣物技能
            if
                SkillId =/= 16000001 -> {false, 6};
                true -> {true, IsCombo, 0, 1, ?BATTLE_SIGN_HOLY, SR}
            end;
        Career == ?SKILL_CAREER_HGHOST -> %% 圣灵技能
            case lib_holy_ghost:check_skill_has_learn(RoleId, HolyGhost, SkillId) of
                false -> {false, 6};
                SkillLv -> {true, IsCombo, 0, SkillLv, ?BATTLE_SIGN_HGHOST, SR}
            end;
        Career == ?SKILL_CAREER_FAIRY andalso Type == ?SKILL_TYPE_ACTIVE ->    %% 精灵技能
            case lib_fairy:check_skill_has_learn(Status, SkillId) of
                false -> {false, 6};
                true -> {true, IsCombo, 0, 1, ?BATTLE_SIGN_FAIRY, SR}
            end;
        Career == ?SKILL_CAREER_GOD andalso Type == ?SKILL_TYPE_ACTIVE ->    %% 降神技能
            case lib_god:check_skill_has_learn(Status, SkillId) of
                false -> {false, 6};
                true -> {true, IsCombo, 0, 1, ?BATTLE_SIGN_PLAYER, SR}
            end;
        Career == ?SKILL_CAREER_SEACRAFT_DAILY andalso (Type == ?SKILL_TYPE_ACTIVE orelse Type == ?SKILL_TYPE_ASSIST) ->    %%海战日常技能
            case lib_seacraft_daily:check_skill_has_learn(Status, SkillId) of
                false -> {false, 6};
                true -> {true, IsCombo, 0, 1, ?BATTLE_SIGN_PLAYER, SR}
            end;
        Career == ?SKILL_CAREER_SPIRIT_BATTLE andalso Type == ?SKILL_TYPE_ACTIVE ->    %% 降神技能
            case lib_holy_spirit_battlefield:check_skill_has_learn(Status, SkillId) of
                false -> {false, 6};
                true -> {true, IsCombo, 0, 1, ?BATTLE_SIGN_PLAYER, SR}
            end;
        Career == ?SKILL_CAREER_COMPANION andalso (Type == ?SKILL_TYPE_ACTIVE orelse Type == ?SKILL_TYPE_ASSIST) ->    %% 伙伴（新）技能
            case lib_companion_util:check_skill_has_fight(Status, SkillId) of
                false ->
                    {false, 6};
                {SkillId, SkillLv} ->
                    {true, IsCombo, 0, SkillLv, ?BATTLE_SIGN_COMPANION, SR}
            end;
        Career == ?SKILL_CAREER_DEMONS ->
            case lib_demons:check_use_demons_skill(Status, SkillId) of
                {false, ErrCode} -> {false, ErrCode};
                {true, SkillLv} -> {true, IsCombo, 0, SkillLv, ?BATTLE_SIGN_DEMONS, SR}
            end;
        Career == ?SKILL_CAREER_WEEK_DUNGEON ->
            case lib_week_dungeon:check_skill_has_learn(Status, SkillId) of
                false -> {false, 6};
                {true, SkillLv} -> {true, IsCombo, 0, SkillLv, ?BATTLE_SIGN_PLAYER, SR}
            end;
        Career == ?SKILL_CAREER_ARCANA ->
            case lib_arcana:check_skill_has_learn(Status, SkillId) of
                false -> {false, 6};
                {true, SkillLv} -> {true, IsCombo, 0, SkillLv, ?BATTLE_SIGN_PLAYER, SR}
            end;
        Career == ?SKILL_CAREER_SEACRAFT ->
            case lib_seacraft:check_skill(Status, SkillId) of
                false -> {false, 6};
                {true, SkillLv} -> {true, IsCombo, 0, SkillLv, ?BATTLE_SIGN_PLAYER, SR}
            end;
        true ->
            {Check, Result} = case lists:keyfind(SkillId, 1, Skill#status_skill.skill_list) of
                false ->
                    case lists:keyfind(SkillId, 1, Skill#status_skill.tmp_skill_list) of
                        false -> {false, {false, 6}};
                        {_, TmpSkillLv} -> {release, {true, IsCombo, 1, TmpSkillLv, ?BATTLE_SIGN_PLAYER, SR}}
                    end;
                {_, TmpSkillLv} ->
                    IsSuitSkill = lib_reincarnation:is_suit_skill(Figure#figure.career, Figure#figure.sex, Figure#figure.turn, SkillId),
                    ReskillId = lib_arcana:get_high_reskill_id(Status, SkillId),
                    % InWeekDun = lib_week_dungeon:in_week_dungeon_scene(Status#player_status.scene),
                    if
                        % 如果技能是转生过程中需要替换掉的技能则不允许玩家使用
                        IsSuitSkill == false -> {false, {false, 6}};
                        % 只能释放高阶技能
                        ReskillId =/= SkillId -> {false, {false, 6}};
                        % 极地本只能释放普通和临时技能
                        % InWeekDun andalso IsNormal == 0 -> {false, {false, 6}};
                        true -> {true, TmpSkillLv}
                    end
            end,
            {IsOpen, OpenSkillLv} = lib_skill:get_open_skill_lv(Status, SkillId),
            if
                % 直接释放
                Check == release -> ReturnType = 1, SkillLv = 0;
                % 不通过则检查是否开启本技能
                Check == false andalso IsOpen == true -> ReturnType = 0, SkillLv = OpenSkillLv;
                % 通过则取本技能等级
                Check == true -> ReturnType = 0, SkillLv = Result;
                true -> ReturnType = 1, SkillLv = 0
            end,
            % ?PRINT("Check:~p IsOpen:~p ReturnType:~p ~n", [Check, IsOpen, ReturnType]),
            if
                ReturnType == 1 -> Result;
                % 非普攻和副技能不检查普攻出手
                IsNormal == 0 orelse IsCombo == 1 ->
                    {true, IsCombo, 0, SkillLv, ?BATTLE_SIGN_PLAYER, SR};
                NowTime - NorAttTime  < 200 -> %% 限制普攻出手太快
                    ?PRINT("SkillId:~p NowTime:~p, NorAttTime:~p ~n", [SkillId, NowTime, NorAttTime]),
                    {false, 2};
                true ->
                    {true, IsCombo, 0, SkillLv, ?BATTLE_SIGN_PLAYER, SR}
            end
    end;
do_use_skill_base_check(_Status, _SR, _NowTime) ->
    {false, 8}.

%% 简单检查玩家身上状态
%% 检测玩家是否能进行战斗
check_battle(Status, Sign) ->
    #player_status{
        forbid_pk_etime = ForBidPkEtime, scene_hide_type = HideType,
        dungeon = #status_dungeon{dun_id = _DunId, dun_type = DunType}
    } = Status,
    NowTime = utime:unixtime(),
    if
        ForBidPkEtime >= NowTime -> {false, ?ERRCODE(in_forbid_pk_status)};
        HideType =:= ?HIDE_TYPE_VISITOR -> {false, ?FAIL};
        DunType == ?DUNGEON_TYPE_WEEK_DUNGEON andalso Sign =/= ?BATTLE_SIGN_PLAYER -> {false, ?FAIL};
        true -> ok
    end.

%% 先计算战斗人数
%% 防止客户端传过多受击对象
select_att_num_der(Ps, SR, Sign, MonList, PlayerList) when
    Sign == ?BATTLE_SIGN_PLAYER;
    Sign == ?BATTLE_SIGN_HOLY;
    Sign == ?BATTLE_SIGN_HGHOST;
    Sign == ?BATTLE_SIGN_DEMONS;
    Sign == ?BATTLE_SIGN_COMPANION ->
    #skill{lv_data=#skill_lv{num = [PNum, MNum]}} = SR,
    #player_status{scene = SceneId, figure = Figure} = Ps,
    case lib_scene:is_outside_scene(SceneId) andalso Figure#figure.lv =< 50 of
        true ->
            {lists:sublist(MonList, MNum), []};
        false ->
            {lists:sublist(MonList, MNum), lists:sublist(PlayerList, PNum)}
    end;
select_att_num_der(_Ps, _SR, _Sign, MonList, PlayerList) ->
    if
        PlayerList =/= [] -> [PId|_] = PlayerList, {[], [PId]};
        MonList =/= [] -> [MId|_] = MonList, {[MId], []};
        true -> {[], []}
    end.


%% =============================================== In Scene Process =================================================
%% 检查开始战斗的攻击者和受击者
%% 性能原因，暂时不判断受击目标与玩家的距离关系
%% 根据受击者的Id 获取实际对象信息
check_start_battle(AttKey, MonList, PlayerList, _SkillId) ->
    case lib_scene_agent:get_user(AttKey) of
        [] -> false;
        AttUser when AttUser#ets_scene_user.battle_attr#battle_attr.hp=<0 -> {false, AttUser};
        #ets_scene_user{x = _AX, y = _AY} = AttUser ->
            %% #skill{obj = Obj, is_combo = _IsConbo,
            %%        lv_data = #skill_lv{distance = Dis, area = Area}} = data_skill:get(SkillId, 1),
            %% %% 判断距离和范围,做一个粗略的矩形判断
            %% if
            %%     Obj == 1 -> %% 自己
            %%         AMaxX = AX + Area,
            %%         AMinX = AX - Area,
            %%         AMaxY = AY + Area,
            %%         AMinY = AY - Area;
            %%     true -> %% 其他
            %%         AMaxX = AX + Dis + Area,
            %%         AMinX = AX - Dis - Area,
            %%         AMaxY = AY + Dis + Area,
            %%         AMinY = AY - Dis - Area
            %% end,
            %% 获取怪物
            F = fun(MonId, {NotExistList, EtsMonList}) ->
                case lib_scene_object_agent:get_object(MonId) of
                    [] -> {[MonId|NotExistList], EtsMonList};
                    #scene_object{hurt_check = {Mod, Fun, Args}} = Object ->
                        case Mod:Fun(AttUser, Object, Args) of
                            true ->
                                {NotExistList, [Object|EtsMonList]};
                            _ ->
                                {NotExistList, EtsMonList}
                        end;
                    Object -> {NotExistList, [Object|EtsMonList]}
                end
                end,
            {NotExistList, EtsMonList} = lists:foldl(F, {[], []}, MonList),
            %% 获取玩家
            OutScene = lib_scene:is_outside_scene(AttUser#ets_scene_user.scene),
            if
                OutScene andalso AttUser#ets_scene_user.figure#figure.lv =< 50 ->
                    DerList = EtsMonList, AllNotExistList = NotExistList;
                true ->
                    F2 = fun(Key, {Acc, NoExistUser}) ->
                        EtsPlayer = lib_scene_agent:get_user(Key),
                        if
                            EtsPlayer == [] -> {Acc, [Key|NoExistUser]};
                            OutScene andalso EtsPlayer#ets_scene_user.figure#figure.lv =< 50 -> {Acc, NoExistUser};
                            true ->
                                %% #ets_scene_user{x = DerX, y = DerY} = EtsPlayer,
                                %% if
                                %%     DerX < AMaxX andalso DerX >= AMinX andalso
                                %%     DerY < AMaxY andalso DerY >= AMinY -> {[EtsPlayer|Acc], NoExistUser};
                                %%     true ->
                                %%         {Acc, [Key|NoExistUser]}
                                %% end
                                {[EtsPlayer|Acc], NoExistUser}
                        end
                         end,
                    {DerList, AllNotExistList} = lists:foldl(F2, {EtsMonList, NotExistList}, PlayerList)
            end,
            DerListAfRev = lists:reverse(DerList),
            {true, AttUser, DerListAfRev, AllNotExistList}
    end.

%% 修正攻击对象
trans_to_real_atter(Arr, Sign) when
    Sign == ?BATTLE_SIGN_PET;
    Sign == ?BATTLE_SIGN_BABY;
    Sign == ?BATTLE_SIGN_HOLY;
    Sign == ?BATTLE_SIGN_HGHOST ->
    init_data(Arr, Sign);
trans_to_real_atter(#ets_scene_user{train_object=TrainObj, battle_attr = ABA}=Arr, Sign) when
    Sign == ?BATTLE_SIGN_MATE;
    Sign == ?BATTLE_SIGN_FAIRY;
    Sign == ?BATTLE_SIGN_DEMONS;
    Sign == ?BATTLE_SIGN_COMPANION ->
    case maps:get(Sign, TrainObj, false) of
        false -> false;
        #scene_train_object{battle_attr = BA, passive_skill = PassiveSkill} ->
            #battle_attr{attr = AAttr, mate_mon_hurt_add = MateMonHurtAdd} = ABA,
            % 使用玩家的基础属性
            Attr = ?IF(Sign == ?BATTLE_SIGN_COMPANION, AAttr, BA#battle_attr.attr),
            NewBA = BA#battle_attr{
                attr = Attr,
                group = Arr#ets_scene_user.battle_attr#battle_attr.group,
                is_hurt_mon = Arr#ets_scene_user.battle_attr#battle_attr.is_hurt_mon,
                pk = Arr#ets_scene_user.battle_attr#battle_attr.pk,
                skill_effect=#skill_effect{},
                mate_mon_hurt_add = MateMonHurtAdd
            },
            do_trans_to_real_atter(Arr, NewBA, PassiveSkill, Sign)
    end;
trans_to_real_atter(Arr, _AttSign) ->
    init_data(Arr).

%% 封装其他战斗类型的战斗体
do_trans_to_real_atter(Arr, BA, PassiveSkill, Sign) when is_record(Arr, ets_scene_user) ->
    #battle_status{
        id      = Arr#ets_scene_user.id,
        node    = Arr#ets_scene_user.node,
        server_id = Arr#ets_scene_user.server_id,
        server_num = Arr#ets_scene_user.server_num,
        server_name = Arr#ets_scene_user.server_name,
        scene   = Arr#ets_scene_user.scene,
        scene_pool_id = Arr#ets_scene_user.scene_pool_id,
        copy_id = Arr#ets_scene_user.copy_id,
        figure  = Arr#ets_scene_user.figure,
        battle_attr = BA,
        skill_passive = PassiveSkill,
        skill_cd    = Arr#ets_scene_user.skill_cd,
        skill_cd_map = Arr#ets_scene_user.skill_cd_map,
        skill_combo = Arr#ets_scene_user.skill_combo,
        shaking_skill = Arr#ets_scene_user.shaking_skill,
        x = Arr#ets_scene_user.x,
        y = Arr#ets_scene_user.y,
        sign = Sign,
        pid  = Arr#ets_scene_user.pid,
        sid  = Arr#ets_scene_user.sid,
        team_id = Arr#ets_scene_user.team#status_team.team_id,
        guild_id= Arr#ets_scene_user.figure#figure.guild_id,
        att_list = Arr#ets_scene_user.att_list,
        boss_tired = get_boss_tired(Arr),
        world_lv = Arr#ets_scene_user.world_lv,
        mod_level = Arr#ets_scene_user.mod_level,
        camp_id = Arr#ets_scene_user.camp_id,
        assist_id = Arr#ets_scene_user.assist_id,
        del_hp_each_time = Arr#ets_scene_user.del_hp_each_time,
        halo_privilege = Arr#ets_scene_user.halo_privilege
    };
do_trans_to_real_atter(Arr, BA, PassiveSkill, Sign) ->
    ?ERR("init_data: Arr:~p, BA:~p, PassiveSkill:~p Sign:~p~n", [Arr, BA, PassiveSkill, Sign]),
    #battle_status{}.

%% 初始化战斗双方属性
%% 场景进程对象信息转换成战斗信息
%% #scene_object/#ets_user => #battle_status
init_data(Arr) when is_record(Arr, scene_object) ->
    #scene_object{mon=Mon, dummy=Dummy} = Arr,
    D = #battle_status{
        id          = Arr#scene_object.id,
        config_id   = Arr#scene_object.config_id,
        figure      = Arr#scene_object.figure,
        scene       = Arr#scene_object.scene,
        scene_pool_id = Arr#scene_object.scene_pool_id,
        copy_id     = Arr#scene_object.copy_id,
        battle_attr = Arr#scene_object.battle_attr#battle_attr{skill_effect=#skill_effect{}},
        x           = Arr#scene_object.x,
        y           = Arr#scene_object.y,
        sign        = Arr#scene_object.sign,
        pid         = Arr#scene_object.aid,
        att_type    = Arr#scene_object.att_type,
        attr_type   = Arr#scene_object.attr_type,
        skill_cd    = Arr#scene_object.skill_cd,
        skill_cd_map = Arr#scene_object.skill_cd_map,
        skill_combo = Arr#scene_object.skill_combo,
        shaking_skill = Arr#scene_object.shaking_skill,
        pub_skill_cd_cfg = Arr#scene_object.pub_skill_cd_cfg,
        pub_skill_cd = Arr#scene_object.pub_skill_cd,
        skill_owner = Arr#scene_object.skill_owner,
        is_be_atted = Arr#scene_object.is_be_atted,
        guild_id    = Arr#scene_object.figure#figure.guild_id,
        is_armor    = Arr#scene_object.is_armor,
        del_hp_each_time = Arr#scene_object.del_hp_each_time,
        per_hurt = Arr#scene_object.per_hurt,
        per_hurt_time = Arr#scene_object.per_hurt_time,
        be_att_limit = Arr#scene_object.be_att_limit,
        assist_ids = Arr#scene_object.assist_ids,
        camp_id = Arr#scene_object.camp_id
    },
    MonD =
        case is_record(Mon, scene_mon) of
            true ->
                D#battle_status{
                    mid = Mon#scene_mon.mid,
                    kind = Mon#scene_mon.kind,
                    boss = Mon#scene_mon.boss
                };
            false -> D
        end,
    DummyD =
        case is_record(Dummy, scene_dummy) of
            true ->
                MonD#battle_status{
                    scene_partner = Dummy#scene_dummy.partner,
                    team_id = Dummy#scene_dummy.team_id
                };
            false -> MonD
        end,
    DummyD;
init_data(Arr) when is_record(Arr, ets_scene_user) ->
    #battle_status{
        id      = Arr#ets_scene_user.id,
        node    = Arr#ets_scene_user.node,
        server_id = Arr#ets_scene_user.server_id,
        server_num = Arr#ets_scene_user.server_num,
        server_name = Arr#ets_scene_user.server_name,
        scene   = Arr#ets_scene_user.scene,
        scene_pool_id = Arr#ets_scene_user.scene_pool_id,
        copy_id = Arr#ets_scene_user.copy_id,
        figure  = Arr#ets_scene_user.figure,
        battle_attr = Arr#ets_scene_user.battle_attr#battle_attr{skill_effect=#skill_effect{}},
        skill_passive = Arr#ets_scene_user.skill_passive,
        skill_passive_share = Arr#ets_scene_user.skill_passive_share,
        skill_cd    = Arr#ets_scene_user.skill_cd,
        skill_cd_map = Arr#ets_scene_user.skill_cd_map,
        skill_combo = Arr#ets_scene_user.skill_combo,
        shaking_skill = Arr#ets_scene_user.shaking_skill,
        quickbar = Arr#ets_scene_user.quickbar,
        x = Arr#ets_scene_user.x,
        y = Arr#ets_scene_user.y,
        sign = ?BATTLE_SIGN_PLAYER,
        pid  = Arr#ets_scene_user.pid,
        sid  = Arr#ets_scene_user.sid,
        team_id = Arr#ets_scene_user.team#status_team.team_id,
        team_skill = Arr#ets_scene_user.team#status_team.team_skill,
        team_skill_num = Arr#ets_scene_user.team#status_team.skill_num,
        guild_id= Arr#ets_scene_user.figure#figure.guild_id,
        scene_partner = Arr#ets_scene_user.scene_partner,
        is_be_atted = ?IF(Arr#ets_scene_user.hide_type==?HIDE_TYPE_VISITOR, 0, 1),
        att_list = Arr#ets_scene_user.att_list,
        boss_tired = get_boss_tired(Arr),
        in_sea = Arr#ets_scene_user.in_sea,
        world_lv = Arr#ets_scene_user.world_lv,
        mod_level = Arr#ets_scene_user.mod_level,
        camp_id = Arr#ets_scene_user.camp_id,
        assist_id = Arr#ets_scene_user.assist_id,
        del_hp_each_time = Arr#ets_scene_user.del_hp_each_time,
        per_hurt = Arr#ets_scene_user.per_hurt,
        per_hurt_time = Arr#ets_scene_user.per_hurt_time,
        halo_privilege = Arr#ets_scene_user.halo_privilege
    };
init_data(Arr) ->
    ?ERR("init_data: error:~p~n", [Arr]),
    #battle_status{}.

%% 封装其他战斗类型(宠物,宝宝)的战斗体
init_data(Arr, Sign) when is_record(Arr, ets_scene_user)->
    BA =
        if
            Sign == ?BATTLE_SIGN_PET ->
                Arr#ets_scene_user.pet_battle_attr#battle_attr{
                    group = Arr#ets_scene_user.battle_attr#battle_attr.group,
                    is_hurt_mon = Arr#ets_scene_user.battle_attr#battle_attr.is_hurt_mon,
                    pk = Arr#ets_scene_user.battle_attr#battle_attr.pk,
                    skill_effect=#skill_effect{}
                };
            Sign == ?BATTLE_SIGN_BABY ->
                Arr#ets_scene_user.baby_battle_attr#battle_attr{
                    group = Arr#ets_scene_user.battle_attr#battle_attr.group,
                    is_hurt_mon = Arr#ets_scene_user.battle_attr#battle_attr.is_hurt_mon,
                    pk = Arr#ets_scene_user.battle_attr#battle_attr.pk,
                    skill_effect=#skill_effect{}
                };
            Sign == ?BATTLE_SIGN_HOLY ->
                Arr#ets_scene_user.talisman_battle_attr#battle_attr{
                    group = Arr#ets_scene_user.battle_attr#battle_attr.group,
                    is_hurt_mon = Arr#ets_scene_user.battle_attr#battle_attr.is_hurt_mon,
                    pk = Arr#ets_scene_user.battle_attr#battle_attr.pk,
                    skill_effect=#skill_effect{}
                };
            Sign == ?BATTLE_SIGN_HGHOST ->
                Arr#ets_scene_user.battle_attr#battle_attr{
                    skill_effect=#skill_effect{}
                };
            true ->
                #battle_attr{skill_effect=#skill_effect{}} %% 异常情况
        end,
    #battle_status{
        id      = Arr#ets_scene_user.id,
        node    = Arr#ets_scene_user.node,
        server_id = Arr#ets_scene_user.server_id,
        server_num = Arr#ets_scene_user.server_num,
        server_name = Arr#ets_scene_user.server_name,
        scene   = Arr#ets_scene_user.scene,
        scene_pool_id = Arr#ets_scene_user.scene_pool_id,
        copy_id = Arr#ets_scene_user.copy_id,
        figure  = Arr#ets_scene_user.figure,
        battle_attr = BA,
        skill_passive = [],
        skill_cd    = Arr#ets_scene_user.skill_cd,
        skill_cd_map = Arr#ets_scene_user.skill_cd_map,
        skill_combo = Arr#ets_scene_user.skill_combo,
        shaking_skill = Arr#ets_scene_user.shaking_skill,
        x = Arr#ets_scene_user.x,
        y = Arr#ets_scene_user.y,
        sign = Sign,
        pid  = Arr#ets_scene_user.pid,
        sid  = Arr#ets_scene_user.sid,
        team_id = Arr#ets_scene_user.team#status_team.team_id,
        guild_id= Arr#ets_scene_user.figure#figure.guild_id,
        %% scene_partner = Arr#ets_scene_user.scene_partner,
        att_list = Arr#ets_scene_user.att_list,
        boss_tired = get_boss_tired(Arr),
        world_lv = Arr#ets_scene_user.world_lv,
        mod_level = Arr#ets_scene_user.mod_level,
        camp_id = Arr#ets_scene_user.camp_id,
        assist_id = Arr#ets_scene_user.assist_id
    };
init_data(Arr, Sign) ->
    ?ERR("init_data: error:~p~n", [Arr, Sign]),
    #battle_status{}.


%% 检查技能使用状态, 同时会设置技能cd与combo状态
%% 服务器触发的辅助或者被动技能，不会被玩家自身的状态打断
check_use_skill(Aer, server, SkillId, SkillLv, NowTime, _Sign) ->
    case data_skill:get(SkillId, SkillLv) of
        [] ->
            {false, ?ERR_CONF, Aer};
        #skill{is_shake_pre = IsShakePre, time = Time, time_no = TimeNo, lv_data = #skill_lv{cd = Cd}} = SkillR ->
            #battle_status{pub_skill_cd_cfg = PubSkillCdCfg, pub_skill_cd = PubSkillCd} = Aer,
            case check_cd(Aer, SkillR, NowTime) of
                true ->
                    NewCd = change_new_cd(0, Aer, SkillId, Cd),
                    Aer1 = set_skill_cd(IsShakePre, Aer, SkillId, NowTime, NewCd, Cd),
                    AerAfPubCd = set_pub_skill_cd(IsShakePre, Aer1, PubSkillCdCfg, PubSkillCd, SkillId, NowTime),
                    AerAfCdMap = set_skill_cd_map(IsShakePre, AerAfPubCd, NowTime, TimeNo, Time),
                    {true, AerAfCdMap, SkillR, 0};
                ErrInfo ->
                    ErrInfo
            end
    end;
%% 特殊的技能跳过主角的负面信息
check_use_skill(Aer, _IsCombo, SkillId, SkillLv, NowTime, Sign)
    when Sign == ?BATTLE_SIGN_HGHOST ->
    case data_skill:get(SkillId, SkillLv) of
        [] ->
            {false, ?ERR_CONF, Aer};
        #skill{is_shake_pre = IsShakePre, time = Time, time_no = TimeNo, lv_data = #skill_lv{cd = Cd}} = SkillR ->
            #battle_status{pub_skill_cd_cfg = PubSkillCdCfg, pub_skill_cd = PubSkillCd} = Aer,
            case check_cd(Aer, SkillR, NowTime) of
                true ->
                    NewCd = change_new_cd(0, Aer, SkillId, Cd),
                    Aer1 = set_skill_cd(IsShakePre, Aer, SkillId, NowTime, NewCd, Cd),
                    AerAfPubCd = set_pub_skill_cd(IsShakePre, Aer1, PubSkillCdCfg, PubSkillCd, SkillId, NowTime),
                    AerAfCdMap = set_skill_cd_map(IsShakePre, AerAfPubCd, NowTime, TimeNo, Time),
                    {true, AerAfCdMap, SkillR, 0};
                ErrInfo ->
                    ErrInfo
            end
    end;
check_use_skill(OldAer, IsCombo, SkillId, SkillLv, NowTime, _InitSign) ->
    case check_aer_buff_negative(OldAer, SkillId, SkillLv, NowTime) of
        {false, ErrorCode, Aer} ->
            {false, ErrorCode, Aer};
        {true, SkillR, Aer} when IsCombo == 0 ->
            #skill{is_shake_pre = IsShakePre, combo = Combo, time = Time, time_no = TimeNo, lv_data = #skill_lv{cd=Cd}} = SkillR,
            #battle_status{
                sign = _Sign, skill_combo = SkillCombo, pub_skill_cd_cfg = PubSkillCdCfg,
                pub_skill_cd = PubSkillCd
            } = Aer,
            CheckEnergy = check_energy(OldAer, SkillR),
            CheckCd = check_cd(Aer, SkillR, NowTime),
            if
                CheckCd =/= true -> CheckCd;
                CheckEnergy == false -> {false, ?ERR_ENERGY, Aer};
                true ->
                    %% 检查玩家身上是不是存在combo技能
                    case check_combo_skill(SkillCombo, SkillId, IsCombo, []) of
                        {_, ComboR, IsSetCd, T} ->
                            Aer1 = set_aer_combo_buff(Aer#battle_status{skill_combo=T}, ComboR#skill_combo.next_time, NowTime,
                                ComboR#skill_combo.main_skill_id, ComboR#skill_combo.main_skill_lv),
                            NewCd = change_new_cd(IsSetCd, Aer, SkillId, Cd),
                            Aer2 = set_skill_cd(IsSetCd, Aer1, SkillId, NowTime, NewCd, Cd),
                            AerAfPubCd = set_pub_skill_cd(IsSetCd, Aer2, PubSkillCdCfg, PubSkillCd, SkillId, NowTime),
                            AerAfCdMap = set_skill_cd_map(IsSetCd, AerAfPubCd, NowTime, TimeNo, Time),
                            {true, AerAfCdMap, SkillR, ComboR#skill_combo.main_skill_id};

                        false -> %% 新主动技能
                            case Combo of %% 有combo技能
                                [{_, LastTime, _}|T] when T /= [] ->
                                    IsSetCd = case IsShakePre of 0 -> 1; _ -> 0 end,
                                    ComboR = #skill_combo{main_skill_id=SkillId, main_skill_lv=SkillLv, main_skill_cd=Cd,
                                        is_set_cd=IsSetCd, next_time=LastTime, combo_list=T},
                                    Aer1 = Aer#battle_status{skill_combo=[ComboR|lists:keydelete(SkillId, #skill_combo.main_skill_id, SkillCombo)]},
                                    Aer2 = set_aer_combo_buff(Aer1, LastTime, NowTime, SkillId, SkillLv),
                                    NewCd = change_new_cd(IsSetCd, Aer, SkillId, Cd),
                                    Aer3 = set_skill_cd(IsShakePre, Aer2, SkillId, NowTime, NewCd, Cd),
                                    AerAfPubCd = set_pub_skill_cd(IsShakePre, Aer3, PubSkillCdCfg, PubSkillCd, SkillId, NowTime),
                                    AerAfCdMap = set_skill_cd_map(IsShakePre, AerAfPubCd, NowTime, TimeNo, Time),
                                    {true, AerAfCdMap, SkillR, SkillId};
                                _  ->
                                    NewCd = change_new_cd(IsShakePre, Aer, SkillId, Cd),
                                    Aer1 =  set_skill_cd(IsShakePre, Aer, SkillId, NowTime, NewCd, Cd),
                                    AerAfPubCd = set_pub_skill_cd(IsShakePre, Aer1, PubSkillCdCfg, PubSkillCd, SkillId, NowTime),
                                    AerAfCdMap = set_skill_cd_map(IsShakePre, AerAfPubCd, NowTime, TimeNo, Time),
                                    {true, AerAfCdMap, SkillR, 0} %% 无副技能，即没前摇
                            end
                    end
            end;
        {true, SkillR, Aer} ->
            #skill{time = Time, time_no = TimeNo} = SkillR,
            #battle_status{
                skill_combo = SkillCombo, pub_skill_cd_cfg = PubSkillCdCfg,
                pub_skill_cd = PubSkillCd
            } = Aer,
            case check_combo_skill(SkillCombo, SkillId, IsCombo, []) of
                {?COMBO_FINISH, ComboR, IsSetCd, T} ->
                    SkillR2 = data_skill:get(SkillId, ComboR#skill_combo.main_skill_lv),
                    Aer1 = del_aer_combo_buff(Aer#battle_status{skill_combo=T}, ComboR#skill_combo.main_skill_id),
                    Aer2 = set_skill_cd(IsSetCd, Aer1, ComboR#skill_combo.main_skill_id, NowTime, ComboR#skill_combo.main_skill_cd, ComboR#skill_combo.main_skill_cd),
                    AerAfPubCd = set_pub_skill_cd(IsSetCd, Aer2, PubSkillCdCfg, PubSkillCd, SkillId, NowTime),
                    AerAfCdMap = set_skill_cd_map(IsSetCd, AerAfPubCd, NowTime, TimeNo, Time),
                    {true, AerAfCdMap, SkillR2, ComboR#skill_combo.main_skill_id}; %% 无后续技能，即没前摇
                {?COMBO_NEXT, ComboR, IsSetCd, T} ->
                    SkillR2 = data_skill:get(SkillId, ComboR#skill_combo.main_skill_lv),
                    Aer1   = set_aer_combo_buff(Aer#battle_status{skill_combo=T}, ComboR#skill_combo.next_time, NowTime,
                        ComboR#skill_combo.main_skill_id, ComboR#skill_combo.main_skill_lv),
                    Aer2 = set_skill_cd(IsSetCd, Aer1, ComboR#skill_combo.main_skill_id, NowTime, ComboR#skill_combo.main_skill_cd, ComboR#skill_combo.main_skill_cd),
                    AerAfPubCd = set_pub_skill_cd(IsSetCd, Aer2, PubSkillCdCfg, PubSkillCd, ComboR#skill_combo.main_skill_id, NowTime),
                    AerAfCdMap = set_skill_cd_map(IsSetCd, AerAfPubCd, NowTime, TimeNo, Time),
                    {true, AerAfCdMap, SkillR2, ComboR#skill_combo.main_skill_id};
                false ->
                    {false, ?ERR_COMBO, Aer}
            end
    end.

check_cd(Aer, SkillR, NowTime) ->
    #skill{id = SkillId, time_no = TimeNo} = SkillR,
    #battle_status{skill_cd = SkillCd, skill_cd_map = SkillCdMap, pub_skill_cd_cfg = PubSkillCdCfg, pub_skill_cd = PubSkillCd} = Aer,
    CheckCd = check_cd_skill(SkillCd, SkillId, NowTime),
    CheckPubCd = check_pub_cd_skill(PubSkillCdCfg, PubSkillCd, SkillId, NowTime),
    CheckCdNo = check_skill_cd_no_map(SkillCdMap, TimeNo, NowTime),
    if
        CheckCd == false -> {false, ?ERR_CD, Aer};
        CheckPubCd == false -> {false, ?ERR_PUB_CD, Aer};
        CheckCdNo == false -> {false, ?ERR_CD_NO, Aer};
        true -> true
    end.

%% 检查技能cd
check_cd_skill(SkillCd, SkillId, NowTime) ->
    case lists:keyfind(SkillId, 1, SkillCd) of
        {_, EndTime} when EndTime - 200 > NowTime -> false; %% 只放宽200毫秒(旧：给与两秒的宽容(注意不能放宽那么多)）
        _ -> true
    end.

%% 检查技能cd编号
check_skill_cd_no_map(SkillCdMap, TimeNo, NowTime) ->
    EndTime = maps:get(TimeNo, SkillCdMap, 0),
    if
        % 容错200毫秒
        EndTime - 200 > NowTime -> false;
        true -> true
    end.

%% 检查公共cd
check_pub_cd_skill(PubSkillCdCfg, PubSkillCd, SkillId, NowTime) ->
    case lists:keyfind(SkillId, 1, PubSkillCdCfg) of
        {SkillId, CdNo, _NeedCd} ->
            case lists:keyfind(CdNo, 1, PubSkillCd) of
                {_, EndTime} when EndTime - 200 > NowTime -> false; %% (旧：给与两秒的宽容(注意不能放宽那么多)）
                _ -> true
            end;
        _ ->
            true
    end.

%% 检查能量值
check_energy(Aer, #skill{career = ?SKILL_CAREER_SOUL_DUN, id = SkillId} = _SkillR) ->
    % 检查能量值够不够
    BA = Aer#battle_status.battle_attr,
    NeedEnergy = lib_soul_dungeon:get_need_energy(SkillId),
    #battle_attr{energy = Energy} = BA,
    case Energy >= NeedEnergy of
        true ->
            true;
        false ->
            false
    end;
%% 检查能量值
check_energy(Aer, #skill{career = ?SKILL_CAREER_SPIRIT_BATTLE, id = SkillId} = _SkillR) ->
    % 检查能量值够不够
    BA = Aer#battle_status.battle_attr,
    NeedEnergy = lib_holy_spirit_battlefield:get_need_energy(SkillId),
    #battle_attr{energy = Energy} = BA,
    case Energy >= NeedEnergy of
        true ->
            true;
        false ->
            false
    end;
check_energy(_Aer, _SkillR) ->
    true.

%% 检查攻击者的负面状态
check_aer_buff_negative(Aer, SkillId, SkillLv, NowTime)->
    case data_skill:get(SkillId, SkillLv) of
        #skill{type = Type} = SkillR when
            Type == ?SKILL_TYPE_ACTIVE orelse
                Type == ?SKILL_TYPE_ASSIST ->
            check_aer_buff_negative(Aer, SkillR, NowTime);
        _ ->
            {false, ?ERR_CONF, Aer}
    end.
% 伙伴释放伙伴技能不会检查负面状态
check_aer_buff_negative(#battle_status{sign = ?BATTLE_SIGN_COMPANION} = Aer, #skill{career = ?SKILL_CAREER_COMPANION} = SkillR, _NowTime) ->
    {true, SkillR, Aer};
check_aer_buff_negative(Aer, #skill{is_normal = IsNormal, lv_data = #skill_lv{effect = EffectBuff}} = SkillR, NowTime) ->
    case lists:keyfind(?SPBUFF_CLEAN_BUFF, 1, EffectBuff) of
        false ->
            BA = Aer#battle_status.battle_attr,
            case lib_skill_buff:is_can_attack(BA#battle_attr.other_buff_list, IsNormal, NowTime) of
                {false, BuffType, _Time} ->
                    if
                        BuffType == ?SPBUFF_DIZZY -> {false, ?ERR_DIZZY, Aer};
                        BuffType == ?SPBUFF_SILENCE -> {false, ?ERR_SILENCE, Aer};
                        true -> {false, ?ERR_OTHER_BUFF, Aer}
                    end;
                _ ->
                    {true, SkillR, Aer}
            end;
        _Buff ->
            {true, SkillR, Aer}
    end;
check_aer_buff_negative(Aer, _SkillR, _NowTime) ->
    {false, ?ERR_CONF, Aer}.

%% 检查副技能释放是否合法
%% skill_combo有多组副技能，看看是否有合法的组
check_combo_skill([], _, _, _) -> false;
check_combo_skill([ #skill_combo{is_set_bullet=0, main_skill_lv=MainSkillLv, combo_list=[{SkillId, _, _}|_]}=ComboR |T], SkillId, IsCombo, Result) when IsCombo == 1 ->
    #skill{bullet_spd=BulletSpd, bullet_att_time=BulletAttTime, bullet_type = BulletType, lv_data=#skill_lv{distance=Dis, num=[PNum, MNum]}} = data_skill:get(SkillId, MainSkillLv),
    if
    % 攻击次数
        BulletType == ?SKILL_BULLET_TYPE_ATT_NUM ->
            NewComboR = ComboR#skill_combo{bullet_type = BulletType, is_set_bullet=1, count=PNum+MNum},
            % ?MYLOG("hjhcombo", "check_combo_skill SkillId:~p ~n", [PNum+MNum]),
            check_combo_skill([NewComboR|T], SkillId, IsCombo, Result);
        BulletSpd > 0 andalso BulletAttTime > 0 ->
            %% 子弹攻击次数=攻击距离*1000/(子弹速度*子弹检查时间)
            Count = max( 1, util:ceil(Dis*1000/(BulletSpd*BulletAttTime)) ),
            EathDis = util:ceil(Dis/Count),
            NewComboR = ComboR#skill_combo{is_set_bullet=1, count=Count-1, bullet_dis=EathDis},
            check_combo_skill([NewComboR|T], SkillId, IsCombo, Result);
        true ->
            NewComboR = ComboR#skill_combo{is_set_bullet=1},
            check_combo_skill([NewComboR|T], SkillId, IsCombo, Result)
    end;

%% 检查技能id是不是combo链接技能
check_combo_skill([ #skill_combo{count=0, is_set_cd=IsSetCd, combo_list=[{SkillId, NextTime, _}|ET]}=ComboR |T], SkillId, _, Result) -> %% 剩余一次，移除该副技能
    case ET of
        [] ->
            % ?MYLOG("hjhcombo", "check_combo_skill 1 SkillId:~p ~n", [0]),
            {?COMBO_FINISH, ComboR#skill_combo{next_time=0, is_set_cd=1}, IsSetCd, Result++T}; %% Res=1 技能已经放完
        _  ->
            % ?MYLOG("hjhcombo", "check_combo_skill 1 SkillId:~p ~n", [0]),
            ComboR1 = ComboR#skill_combo{next_time=NextTime, combo_list=ET, is_set_cd=1},
            {?COMBO_NEXT, ComboR1, IsSetCd, [ComboR1|Result]++T} %% Res=2 还有后续副技能
    end;

check_combo_skill([ #skill_combo{count=Count, main_skill_lv=MainSkillLv, is_set_cd=IsSetCd, combo_list=[{SkillId, _, _}|_]}=ComboR |T], SkillId, _, Result) -> %% 子弹类副技能，有重复次数
    #skill{bullet_att_time=BulletAttTime} = data_skill:get(SkillId, MainSkillLv),
    ComboR1 = ComboR#skill_combo{count=Count-1, next_time=BulletAttTime, is_set_cd=1},
    % ?MYLOG("hjhcombo", "check_combo_skill 2 SkillId:~p ~n", [Count-1]),
    {?COMBO_NEXT, ComboR1, IsSetCd, [ComboR1 |Result]++T};
check_combo_skill([H|T], SkillId, IsCombo, Result) -> check_combo_skill(T, SkillId, IsCombo, [H|Result]).

%% 设置cd，前摇没有cd
set_skill_cd(_, Aer, _SkillId, _, 0, _OldCd) ->
    Aer; %% cd为0，不记录
set_skill_cd(0,
        #battle_status{
            skill_cd=SkillCd, battle_attr=BA, quickbar = QuickBar,
            node = Node, id = Id, sign = Sign
        }=Aer, SkillId, NowTime, CD, OldCd) ->
    #attr{overload_ratio = OverLoadRatio} = BA#battle_attr.attr,
    if
        Sign =/= ?BATTLE_SIGN_PLAYER orelse OverLoadRatio =< 0 ->
            EndTime = NowTime + CD,
            check_and_send_skill_cd(Aer, SkillId, EndTime, CD, OldCd),
            Aer#battle_status{skill_cd = [{SkillId, EndTime}|lists:keydelete(SkillId, 1, SkillCd)]};
        true ->
            case lists:keyfind(SkillId, 1, QuickBar) of
                false ->
                    EndTime = NowTime + CD,
                    check_and_send_skill_cd(Aer, SkillId, EndTime, CD, OldCd),
                    Aer#battle_status{skill_cd = [{SkillId, EndTime}|lists:keydelete(SkillId, 1, SkillCd)]};
                _ ->
                    case urand:rand(1, ?RATIO_COEFFICIENT) =< OverLoadRatio of
                        false ->
                            EndTime = NowTime + CD,
                            check_and_send_skill_cd(Aer, SkillId, EndTime, CD, OldCd),
                            Aer#battle_status{skill_cd = [{SkillId, EndTime}|lists:keydelete(SkillId, 1, SkillCd)]};
                        true ->
                            %% 通知客户端技能刷新
                            {ok, Bin} = pt_200:write(20018, [SkillId]),
                            lib_server_send:send_to_uid(Node, Id, Bin),
                            Aer#battle_status{skill_cd = lists:keydelete(SkillId, 1, SkillCd)}
                    end
            end
    end;
set_skill_cd(_, Aer, _SkillId, _, _, _OldCd) ->
    Aer.

check_and_send_skill_cd(_Aer, _SkillId, _EndTime, Cd, Cd) ->
    skip;
check_and_send_skill_cd(#battle_status{node = Node, id = Id, sign = Sign}, SkillId, EndTime, _Cd, _OldCd) ->
    RealSign = lib_battle:calc_real_sign(Sign),
    if
        RealSign == ?BATTLE_SIGN_PLAYER ->
            {ok, BinData} = pt_200:write(20027, [SkillId, EndTime]),
            lib_server_send:send_to_uid(Node, Id, BinData);
        true ->
            skip
    end.

set_skill_cd_map(_, Aer, _NowTime, _TimeNo, 0) -> Aer;
set_skill_cd_map(_, Aer, _NowTime, 0, _Time) -> Aer;
set_skill_cd_map(0, #battle_status{skill_cd_map = SkillCdMap}=Aer, NowTime, TimeNo, Time) ->
    % ?MYLOG("hjhbattlecdmap11", "SkillCdMap11:~p ~n", [maps:put(TimeNo, NowTime+Time, SkillCdMap)]),
    Aer#battle_status{skill_cd_map = maps:put(TimeNo, NowTime+Time, SkillCdMap)};
set_skill_cd_map(_, Aer, _NowTime, _TimeNo, _Time) -> Aer.

%% 减cd
change_new_cd(IsSetCd, Aer, SkillId, Cd) ->
    #battle_status{battle_attr = BA} = Aer,
    #battle_attr{sec_attr = SecAttr} = BA,
    if
        Cd == 0 -> Cd;
        IsSetCd == 0 andalso (SkillId == ?SP_SKILL_FIRE orelse SkillId == ?SP_SKILL_ICE) -> %% 怒火/波冰
            max(1, Cd-BA#battle_attr.fire_ice_minus_cd);
        IsSetCd == 0 andalso SkillId == ?SP_SKILL_HOPE -> %% 不灭希望
            max(1, Cd-BA#battle_attr.hope_minus_cd);
        IsSetCd == 0 ->
            MinusCd = lib_sec_player_attr:get_value_to_int(SecAttr, ?SKILL_CD_MINUS, SkillId),
            MinusRatioCd = lib_sec_player_attr:get_value_to_int(SecAttr, ?SKILL_CD_RATIO, SkillId),
            max(1, util:ceil( (Cd-MinusCd)*(1-MinusRatioCd/?RATIO_COEFFICIENT) ) );
        true ->
            Cd
    end.

%% 设置公共cd
set_pub_skill_cd(0, Aer, PubSkillCdCfg, PubSkillCd, SkillId, NowTime) ->
    case lists:keyfind(SkillId, 1, PubSkillCdCfg) of
        {SkillId, CdNo, NeedCd} ->
            EndTime = NowTime + NeedCd,
            Aer#battle_status{pub_skill_cd = [{CdNo, EndTime}|lists:keydelete(CdNo, 1, PubSkillCd)]};
        _ ->
            Aer
    end;
set_pub_skill_cd(_IsSetCd, Aer, _PubSkillCdCfg, _PubSkillCd, _SkillId, _NowTime) ->
    Aer.

%% 设置攻击者的连招buff
set_aer_combo_buff(Aer, LastTime, NowTime, MainSkillId, MainSkillLv) ->
    #battle_status{battle_attr=#battle_attr{other_buff_list=OtherBuffL}=BA} = Aer,
    NewOtherBuff = lib_skill_buff:set_combo_buff(OtherBuffL, MainSkillId, MainSkillLv, NowTime+LastTime+2000),
    Aer#battle_status{battle_attr=BA#battle_attr{other_buff_list=NewOtherBuff}}.
%% 删除攻击者的连招buff
del_aer_combo_buff(Aer, MainSkillId) ->
    #battle_status{battle_attr=#battle_attr{other_buff_list=OtherBuffL}=BA} = Aer,
    NewOtherBuff = lib_skill_buff:del_combo_buff(OtherBuffL, MainSkillId),
    Aer#battle_status{battle_attr=BA#battle_attr{other_buff_list=NewOtherBuff}}.

%% 回写
%% !!!如有修改!!!，必须修改对应的:lib_battle_api:slim_back_data()
back_data(#battle_status{sign = Sign} = Aer, #ets_scene_user{train_object=TrainObj}=EtsAer) when
    Sign == ?BATTLE_SIGN_MATE;
    Sign == ?BATTLE_SIGN_FAIRY;
    Sign == ?BATTLE_SIGN_DEMONS;
    Sign == ?BATTLE_SIGN_COMPANION ->
    NewEtsAer = EtsAer#ets_scene_user{
        skill_cd = Aer#battle_status.skill_cd,
        skill_cd_map = Aer#battle_status.skill_cd_map,
        skill_combo = Aer#battle_status.skill_combo,
        shaking_skill = Aer#battle_status.shaking_skill,
        last_skill_id = Aer#battle_status.last_skill_id,
        pub_skill_cd = Aer#battle_status.pub_skill_cd,
        x = Aer#battle_status.x,
        y = Aer#battle_status.y
    },
    case maps:get(Sign, TrainObj, false) of
        false -> NewEtsAer;
        #scene_train_object{}=SceneTrainObj ->
            #battle_status{battle_attr=BA} = Aer,
            SceneTrainObj1 = SceneTrainObj#scene_train_object{battle_attr=BA},
            NewEtsAer#ets_scene_user{train_object = maps:update(Sign, SceneTrainObj1, TrainObj)}
    end;
back_data(Aer, #ets_scene_user{}=EtsAer) ->
    NewEtsAer = EtsAer#ets_scene_user{
        skill_cd    = Aer#battle_status.skill_cd,
        skill_cd_map = Aer#battle_status.skill_cd_map,
        skill_combo = Aer#battle_status.skill_combo,
        shaking_skill = Aer#battle_status.shaking_skill,
        last_skill_id = Aer#battle_status.last_skill_id,
        pub_skill_cd = Aer#battle_status.pub_skill_cd,
        x = Aer#battle_status.x,
        y = Aer#battle_status.y},
    if
        Aer#battle_status.sign == ?BATTLE_SIGN_PET ->
            NewEtsAer#ets_scene_user{pet_battle_attr = Aer#battle_status.battle_attr};
        Aer#battle_status.sign == ?BATTLE_SIGN_BABY ->
            NewEtsAer#ets_scene_user{baby_battle_attr = Aer#battle_status.battle_attr};
        Aer#battle_status.sign == ?BATTLE_SIGN_HOLY->
            NewEtsAer#ets_scene_user{talisman_battle_attr = Aer#battle_status.battle_attr};
        Aer#battle_status.sign == ?BATTLE_SIGN_HGHOST->
            NewEtsAer#ets_scene_user{holyghost_battle_attr = Aer#battle_status.battle_attr};
        true ->
            NewEtsAer#ets_scene_user{battle_attr = Aer#battle_status.battle_attr}
    end;
%% !!!如有修改!!!，必须修改对应的:lib_battle_api:slim_back_data()
back_data(Aer, #scene_object{}=EtsAer) ->
    EtsAer#scene_object{
        battle_attr = Aer#battle_status.battle_attr,
        skill_cd    = Aer#battle_status.skill_cd,
        skill_cd_map = Aer#battle_status.skill_cd_map,
        skill_combo = Aer#battle_status.skill_combo,
        shaking_skill = Aer#battle_status.shaking_skill,
        last_skill_id = Aer#battle_status.last_skill_id,
        pub_skill_cd = Aer#battle_status.pub_skill_cd,
        per_hurt = Aer#battle_status.per_hurt,
        per_hurt_time = Aer#battle_status.per_hurt_time,
        x = Aer#battle_status.x,
        y = Aer#battle_status.y
    }.

%% ========= Boss 相关
%% 获取boss疲劳值
get_boss_tired(Arr) ->
    case data_scene:get(Arr#ets_scene_user.scene) of
        #ets_scene{type = ?SCENE_TYPE_SANCTUARY} ->
            BossType = ?BOSS_TYPE_SANCTUARY,
            maps:get(BossType, Arr#ets_scene_user.boss_tired_map, #scene_boss_tired{boss_type = BossType});
        #ets_scene{type = ?SCENE_TYPE_WORLD_BOSS} ->
            #scene_boss_tired{boss_type = ?BOSS_TYPE_WORLD, tired = Arr#ets_scene_user.boss_tired};
        #ets_scene{type = ?SCENE_TYPE_TEMPLE_BOSS} ->
            #scene_boss_tired{boss_type = ?BOSS_TYPE_TEMPLE, tired = Arr#ets_scene_user.temple_boss_tired};
        #ets_scene{type = ?SCENE_TYPE_EUDEMONS_BOSS} ->
            BossType = ?BOSS_TYPE_PHANTOM,
            LastMaxTired =
                case maps:get(BossType, Arr#ets_scene_user.boss_tired_map, false) of
                    false ->
                        #eudemons_boss_type{tired = MaxTired} = data_eudemons_land:get_eudemons_boss_type(?BOSS_TYPE_EUDEMONS),
                        MaxTired;
                    #scene_boss_tired{max_tired = MaxTired} -> MaxTired
                end,
            #scene_boss_tired{boss_type = ?BOSS_TYPE_PHANTOM, tired = Arr#ets_scene_user.phantom_tired, max_tired = LastMaxTired};
        #ets_scene{type = ?SCENE_TYPE_FAIRYLAND_BOSS} ->
            #scene_boss_tired{boss_type = ?BOSS_TYPE_FAIRYLAND, tired = Arr#ets_scene_user.fairyland_tired};
        #ets_scene{type = ?SCENE_TYPE_PHANTOM_BOSS} ->
            #scene_boss_tired{boss_type = ?BOSS_TYPE_PHANTOM, tired = Arr#ets_scene_user.phantom_tired};
        #ets_scene{type = ?SCENE_TYPE_KF_SANCTUARY} ->
            BossType = ?BOSS_TYPE_KF_SANCTUARY,
            maps:get(BossType, Arr#ets_scene_user.boss_tired_map, #scene_boss_tired{boss_type = BossType});
        #ets_scene{type = SceneType} when SceneType == ?SCENE_TYPE_SPECIAL_BOSS
            orelse SceneType == ?SCENE_TYPE_NEW_OUTSIDE_BOSS ->
            BossType = ?BOSS_TYPE_NEW_OUTSIDE,
            maps:get(BossType, Arr#ets_scene_user.boss_tired_map, #scene_boss_tired{boss_type = BossType});
        _ ->
            #scene_boss_tired{}
    end.

%% 返回ture|false
check_boss_tired(Scene, Mid, #scene_boss_tired{tired = BossTired, max_tired = SceneMaxTired}, _VipType, _Vip) ->
    case get_max_boss_tired(Scene, Mid, SceneMaxTired, _VipType, _Vip) of
        false -> false;
        {SceneType, MaxTired} ->
            if
                SceneType == ?SCENE_TYPE_SPECIAL_BOSS orelse
                    SceneType == ?SCENE_TYPE_NEW_OUTSIDE_BOSS ->
                    case data_boss:get_boss_cfg(Mid) of %% 使用的是体力值
                        #boss_cfg{tired_add = DeleteVit} -> BossTired >= DeleteVit;
                        _ -> false
                    end;
                true ->
                    BossTired >= MaxTired
            end
    end;
check_boss_tired(_Scene, _Mid, _, _VipType, _Vip) ->
    false.

%% 检查Boss是否Miss
check_boss_missing(Scene, Mid, #scene_boss_tired{tired = BossTired, max_tired = SceneMaxTired}, _VipType, _Vip, ExtraArgs) ->
    case get_max_boss_tired(Scene, Mid, SceneMaxTired, _VipType, _Vip) of
        false -> false;
        {SceneType, MaxTired} ->
            if
                MaxTired > BossTired andalso (SceneType == ?SCENE_TYPE_SPECIAL_BOSS orelse
                    SceneType == ?SCENE_TYPE_NEW_OUTSIDE_BOSS) ->  %% 体力值不足不能攻击boss
                    %% 新野外boss(12)改成了体力值 MaxTired:需要的体力值 BossTired：当前体力值
                    [AssistId, MonAssistIds] = ExtraArgs,
                    case lists:member(AssistId, MonAssistIds) of
                        true -> %% 玩家在这个boss的协助列表中,可以攻击
                            false;
                        _ ->
                            true
                    end;
                BossTired >= MaxTired andalso (SceneType == ?SCENE_TYPE_SPECIAL_BOSS orelse
                    SceneType == ?SCENE_TYPE_NEW_OUTSIDE_BOSS) -> %% 体力值够了
                    false;
                BossTired >= MaxTired ->
                    case SceneType == ?SCENE_TYPE_EUDEMONS_BOSS of
                        true ->
                            [AssistId, MonAssistIds] = ExtraArgs,
                            case lists:member(AssistId, MonAssistIds) of
                                true -> %% 玩家在这个boss的协助列表中,可以攻击
                                    false;
                                _ ->
                                    true
                            end;
                        _ ->
                            true
                    end;
                true ->
                    false
            end

    end;
check_boss_missing(_Scene, _Mid, _, _VipType, _Vip, _ExtraArgs) ->
    false.

get_max_boss_tired(Scene, Mid, SceneMaxTired, _VipType, _Vip) ->
    case data_scene:get(Scene) of
        #ets_scene{type = SceneType} when
            SceneType == ?SCENE_TYPE_WORLD_BOSS orelse
                SceneType == ?SCENE_TYPE_FAIRYLAND_BOSS orelse
                SceneType == ?SCENE_TYPE_PHANTOM_BOSS ->
            BossType = lib_boss:get_boss_type_by_scene(Scene),
            case data_boss:get_boss_cfg(Mid) of
                #boss_cfg{type = BossType} ->
                    #boss_type{tired = MaxTired} = data_boss:get_boss_type(BossType),
                    {SceneType, MaxTired};
                _ -> false
            end;
        #ets_scene{type = ?SCENE_TYPE_TEMPLE_BOSS} ->
            VipAddTired = 0,%lib_vip:get_vip_privilege(Vip, ?MOD_BOSS, ?BOSS_TYPE_TEMPLE * 1000),
            case data_boss:get_boss_cfg(Mid) of
                #boss_cfg{type = ?BOSS_TYPE_TEMPLE} ->
                    #boss_type{tired = MaxTired} = data_boss:get_boss_type(?BOSS_TYPE_TEMPLE),
                    {?SCENE_TYPE_TEMPLE_BOSS, MaxTired + VipAddTired};
                _R -> false
            end;
        #ets_scene{type = ?SCENE_TYPE_EUDEMONS_BOSS} ->
            case data_eudemons_land:get_eudemons_boss_cfg(Mid) of
                #eudemons_boss_cfg{type = ?BOSS_TYPE_EUDEMONS} ->
                    #eudemons_boss_type{tired = _MaxTired}
                        = data_eudemons_land:get_eudemons_boss_type(?BOSS_TYPE_EUDEMONS),
                    {?SCENE_TYPE_EUDEMONS_BOSS, SceneMaxTired};
                _R -> false
            end;
        #ets_scene{type = SceneType} when SceneType == ?SCENE_TYPE_SPECIAL_BOSS orelse SceneType == ?SCENE_TYPE_NEW_OUTSIDE_BOSS ->
            % VipAddMaxCount = lib_vip_api:get_vip_privilege(?MOD_BOSS, ?NEW_OUTSIDE_BOSS_VIP_VALUE, _VipType, _Vip),
            % MaxVit = ?BOSS_TYPE_KV_MAX_VIT(?BOSS_TYPE_NEW_OUTSIDE),
            case data_boss:get_boss_cfg(Mid) of %% 使用的是体力值
                #boss_cfg{tired_add = DeleteVit} -> {SceneType, DeleteVit};
                _ -> false
            end;
        #ets_scene{type = ?SCENE_TYPE_KF_SANCTUARY} ->
            {?SCENE_TYPE_KF_SANCTUARY, SceneMaxTired};
        #ets_scene{type = ?SCENE_TYPE_SANCTUARY} ->
            case data_boss:get_boss_cfg(Mid) of
                #boss_cfg{sign = Sign} ->
                    if
                        Sign == 1 -> %% 和平怪
                            {?SCENE_TYPE_SANCTUARY, SceneMaxTired};
                        true ->
                            false
                    end;
                _ ->
                    false
            end;
        _ ->
            false
    end.

%% 计算boss类型
calc_boss_type(SceneId, Boss, SpanLv) ->
    IsLocalCal= Boss == ?MON_LOCAL_BOSS andalso lib_boss:is_in_all_boss(SceneId),
    % 跨服boss只有圣兽领的支持
    IsClusterCal = Boss == ?MON_CLUSTER_BOSS andalso lib_scene:get_scene_type(SceneId) == ?SCENE_TYPE_EUDEMONS_BOSS,
    if
        IsLocalCal orelse IsClusterCal ->
            BossType = lib_boss:get_boss_type_by_scene(SceneId),
            case data_mon_type:get_lv_hurt(Boss, BossType, SpanLv) of
                #mon_type_lv_hurt{} -> BossType;
                _ -> 0
            end;
        true ->
            0
    end.

%% 是否需要助攻列表
is_need_hit_list(SceneId) ->
    case data_scene:get(SceneId) of
        #ets_scene{type = ?SCENE_TYPE_KF_3v3} -> true;
        #ets_scene{type = ?SCENE_TYPE_HOLY_SPIRIT_BATTLE} -> true;
        _ -> false
    end.


make_return_atter(Aer, AerSign) ->
    case Aer#battle_status.skill_owner of
        %% 父类属性
        #skill_owner{id=OwnerId, pid=OwnerPid, node=OwnerNode, guild_id = OwnerGuildId, team_id=OwnerTeamId, sign=OwnerSign} ->
            [ #battle_return_atter{
                sign = OwnerSign, id = OwnerId, node = OwnerNode, mid = Aer#battle_status.mid,
                kind = Aer#battle_status.kind, pid = OwnerPid, team_id = OwnerTeamId, x = Aer#battle_status.x,
                y = Aer#battle_status.y, hide = Aer#battle_status.battle_attr#battle_attr.hide,
                guild_id = OwnerGuildId, real_id = Aer#battle_status.id, real_sign = Aer#battle_status.sign,
                real_name = Aer#battle_status.figure#figure.name, lv = Aer#battle_status.figure#figure.lv,
                server_id = Aer#battle_status.server_id, server_num = Aer#battle_status.server_num,
                hp = Aer#battle_status.battle_attr#battle_attr.hp, hp_lim = Aer#battle_status.battle_attr#battle_attr.hp_lim,
                world_lv = Aer#battle_status.world_lv, server_name = Aer#battle_status.server_name,
                career = Aer#battle_status.figure#figure.career,
                mod_level = Aer#battle_status.mod_level, camp_id = Aer#battle_status.camp_id,
                mask_id = Aer#battle_status.figure#figure.mask_id,
                assist_id = Aer#battle_status.assist_id, halo_privilege = Aer#battle_status.halo_privilege
            }, OwnerSign
            ];
        _ ->
            [ #battle_return_atter{
                sign = Aer#battle_status.sign, id = Aer#battle_status.id, node = Aer#battle_status.node,
                mid = Aer#battle_status.mid, kind = Aer#battle_status.kind, pid = Aer#battle_status.pid,
                team_id = Aer#battle_status.team_id, x = Aer#battle_status.x, y = Aer#battle_status.y,
                hide = Aer#battle_status.battle_attr#battle_attr.hide, guild_id = Aer#battle_status.guild_id,
                real_id = Aer#battle_status.id, real_sign = AerSign, real_name = Aer#battle_status.figure#figure.name,
                lv = Aer#battle_status.figure#figure.lv, server_id = Aer#battle_status.server_id, server_num = Aer#battle_status.server_num,
                hp = Aer#battle_status.battle_attr#battle_attr.hp, hp_lim = Aer#battle_status.battle_attr#battle_attr.hp_lim,
                world_lv = Aer#battle_status.world_lv, server_name = Aer#battle_status.server_name,
                career = Aer#battle_status.figure#figure.career,
                mod_level = Aer#battle_status.mod_level, camp_id = Aer#battle_status.camp_id,
                mask_id = Aer#battle_status.figure#figure.mask_id,
                assist_id = Aer#battle_status.assist_id, halo_privilege = Aer#battle_status.halo_privilege
            }, AerSign
            ]
    end.
