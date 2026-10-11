%%%--------------------------------------
%%% @Module  : pp_battle
%%% @Author  : xyao
%%% @Email   : jiexiaowen@gmail.com
%%% @Created : 2011.07.25
%%% @Description: 战斗
%%%--------------------------------------
-module(pp_battle).
-export([handle/3]).
-include("server.hrl").
-include("scene.hrl").
-include("skill.hrl").
-include("battle.hrl").
-include("common.hrl").
-include("errcode.hrl").
-include("attr.hrl").
-include("team.hrl").
-include("def_fun.hrl").
-include("pet.hrl").
-include("marriage.hrl").
-include("figure.hrl").
-include("3v3.hrl").
-include("kf_guild_war.hrl").
-include("guild.hrl").
-include("mount.hrl").
-include("dungeon.hrl").

%% 玩家发起攻击
%% MonList          怪物Id列表
%% PlayerList       玩家key列表
%% SkillId          技能Id
%% AttDirection     攻击朝向
handle(20001, Status, [MonList, PlayerList, SkillId, AttX, AttY, AttAngle]) ->
    % ?PRINT("MonList:~p PlayerList:~p ~n", [MonList, PlayerList]),
    % ?IF(SkillId == 100101 orelse SkillId == 100102, ?PRINT("SkillId:~p ~n", [SkillId]), skip),
    NowTime = utime:longunixtime(),
    %% 跨服公会战增加的临时技能
    #player_status{id = _RoleId, scene = SceneId} = Status,
    IsInBehavior = lib_player_behavior_api:is_in_behavior(Status),
    case lib_battle_util:use_skill_base_check(Status, SkillId, NowTime) of
        _ when IsInBehavior ->
            {ok, Status};
        {false, ErrCode} ->
            ?MYLOG("skill", "_RoleId:~p SkillId:~p longunixtime:~p, ErrCode:~p ~n", [_RoleId, SkillId, NowTime, ErrCode]),
            ?PRINT("_RoleId:~p SkillId:~p longunixtime:~p, ErrCode:~p ~n", [_RoleId, SkillId, NowTime, ErrCode]),
            lib_battle:battle_fail(ErrCode, Status, [ErrCode]),
            {ok, Status};
        {true, IsCombo, _IsTmp, SkillLv, Sign, SR} -> %% 玩家|宠物|宝宝|圣物|圣灵
            case lib_battle_util:check_battle(Status, Sign) of
                ok ->
                    #player_status{
                        id = RoleId, scene = _SceneId, scene_pool_id = ScenePoolId,
                        last_att_time = LastAttTime, att_time = AttTime, nor_att_time = NorAttTime} = Status,
                    %% 先取被攻击的数量，避免进行不必要的人数操作
                    {NMonList, NPlayerList} = lib_battle_util:select_att_num_der(Status, SR, Sign, MonList, PlayerList),
                    CallBackArgs = lib_skill:make_skill_use_call_back(Status, SkillId, SkillLv),
                    BattleArgs = #battle_args{
                        att_key=RoleId, mon_list=NMonList, player_list=NPlayerList, att_x=AttX, att_y=AttY, sign = Sign,
                        skill_id=SkillId, skill_lv=SkillLv, skill_call_back = CallBackArgs, now_time=NowTime, att_angle=AttAngle,
                        is_combo=IsCombo, skill_stren=lib_skill:get_skill_stren_for_battle(Status, SkillId)
                        },
                    mod_scene_agent:apply_cast_with_state(SceneId, ScenePoolId, lib_battle, start_battle, [BattleArgs]),
                    NewLastAttTime = ?IF(PlayerList=/=[], NowTime, LastAttTime),
                    NewAttTime = ?IF(lib_battle:calc_real_sign(Sign) == ?BATTLE_SIGN_PLAYER, NowTime, AttTime),
                    NewNorAttTime = ?IF(Sign == ?BATTLE_SIGN_PLAYER andalso lib_skill:is_normal_skill_without_combo(SkillId), NowTime, NorAttTime),
                    AfSucStatus = lib_battle_event:handle_af_battle_success(Status, SkillId),
                    SaveStatus = AfSucStatus#player_status{last_att_time = NewLastAttTime, att_time = NewAttTime, nor_att_time = NewNorAttTime},
                    % ?PRINT("Sign:~p SkillId:~p NewAttTime:~p AttTime:~p ~n", [lib_battle:calc_real_sign(Sign), SkillId, NewAttTime, AttTime]),
                    {ok, SaveStatus};
                {false, ErrCode} ->
                    ?PRINT("SkillId:~p NowTime:~p ErrCode:~p ~n", [SkillId, NowTime, ErrCode]),
                    lib_battle:battle_fail(ErrCode, Status, [ErrCode]),
                    {ok, Status}
            end
    end;

%% 复活:客户端1 3 6 9 11
%%@param Type   1元宝原地复活(扣钱) 2绑定元宝原地复活(扣钱) 3回城复活(免费)
%%              4根据参数Status的血量复活
%%              5原地满血复活 6客户端请求变成幽灵状 8挂机自动复活 9通用副本复活
%%              10新回合复活 113v3复活 12 跨服公会战 13 世界boss
handle(20004, Status, Type) when Type > 0, Type =< ?REVIVE_HOLY_SEA_CRAFT_DAILY ->
    if
        Type == 1 orelse Type == 3 orelse
        Type == 6 orelse Type == 9 orelse
        Type == 11 orelse Type == ?REVIVE_KF_GWAR orelse Type == ?REVIVE_WORLD_BOSS orelse
        Type == ?REVIVE_GUILD_BATTLE  orelse Type == ?REVIVE_WLDBOSS_POINT orelse
        Type == ?REVIVE_NINE orelse Type == ?REVIVE_NINE_GOLD orelse Type == ?REVIVE_ASHES orelse
        Type == ?REVIVE_SOUL_DUNGEON orelse Type == ?REVIVE_DRUMWAR orelse Type == ?REVIVE_BOSS orelse
        Type == ?REVIVE_ORIGIN orelse Type == ?REVIVE_INPLACE orelse Type == ?REVIVE_HOLY_SPIRIT_BATTLE orelse
        Type == ?REVIVE_HOLY_SEA_CRAFT_DAILY    ->
            %% 数据初始化
            #player_status{sid = Sid, scene = SceneId} = Status,
            %% 不允许复活的地图列表
            NoReviveSceneList = [],
            IsCantReviveScene = lists:member(SceneId, NoReviveSceneList),
            if
                IsCantReviveScene -> ok;
                true  ->
                    {Result, Status1} = lib_revive:revive(Status, Type),
                    %% 告诉客户端复活成功
                    if
                        (Type == ?REVIVE_BOSS orelse Type == ?REVIVE_ASHES) andalso Result == 1 ->
                            {ok, BinData} = pt_200:write(20004, [Type, 12]);
                        true ->
                            {ok, BinData} = pt_200:write(20004, [Type, Result])
                    end,
                    lib_server_send:send_to_sid(Sid, BinData),
                    case Result == 1 of
                        true -> {ok, battle_attr, Status1};
                        false -> {ok, Status1}
                    end
            end;
        true ->
            ?ERR("error revive type:~p~n", [[Status#player_status.id, Type]]),
            ok
    end;

%% 发动辅助技能
handle(20006, Status, [PlayerId, SkillId]) ->
    NowTime = utime:longunixtime(),
    %% 跨服公会战增加的临时技能
    IsInBehavior = lib_player_behavior_api:is_in_behavior(Status),
    case lib_battle_util:use_skill_base_check(Status, SkillId, NowTime) of
        _ when IsInBehavior ->
            {ok, Status};
        {false, ErrCode} ->
            lib_battle:battle_fail(ErrCode, Status, []);
        {true, IsCombo, _IsTmp, SkillLv, _Sign, _SR} ->
            CallBackArgs = lib_skill:make_skill_use_call_back(Status, SkillId, SkillLv),
            mod_scene_agent:apply_cast_with_state(Status#player_status.scene, Status#player_status.scene_pool_id,
                lib_battle, assist_to_anyone, [Status#player_status.id, PlayerId, IsCombo, SkillId, SkillLv, CallBackArgs]),
            %% Status1 = use_tmp_skill_event(IsTmp, Status, SkillId),
            {ok, Status}
    end;

%% 采集怪物
%% MonId    :  怪物唯一ID
%% MonCfgId :  怪物配置id
handle(20008, Status, [MonId, MonCfgId, Type]) when Type == 1 orelse Type == 2 orelse Type == 3 ->
    #player_status{id = Id, scene = SceneId, scene_pool_id=ScenePoolId, collect_checker = CollectChecker} = Status,
    if
        Type == 1 ->
            Res
            = case CollectChecker of
                {M, F, A} ->
                    M:F(MonId, MonCfgId, A);
                _ ->
                    true
            end,
            case Res of
                true ->
                    NeedCellNum = calc_collect_need_cell(Status, MonCfgId),
                    case  lib_goods_api:get_cell_num(Status) >= NeedCellNum of
                        false -> lib_server_send:send_to_uid(Id, pt_200, 20008, 15); %% 背包不足
                        true -> mod_scene_agent:apply_cast(SceneId, ScenePoolId, lib_battle, collect_mon, [Id, MonId, MonCfgId, Type, []])
                    end;
                {false, Code} ->
                    lib_server_send:send_to_uid(Id, pt_200, 20008, Code)
            end;
        true -> mod_scene_agent:apply_cast(SceneId, ScenePoolId, lib_battle, collect_mon, [Id, MonId, MonCfgId, Type, []])
    end;

%% 复活
handle(20009, Status, _Data) ->
    #player_status{id = RoleId, revive_status = #revive_status{is_revive = IsRevive, revive_time = ReviveTime}} = Status,
    IsOnDungeon = lib_dungeon:is_on_dungeon(Status),
    % IsOnWorldboss = lib_boss:is_in_world_boss(Status#player_status.scene),
    if
        IsOnDungeon -> lib_dungeon:send_reveive_info(Status);
        % IsOnWorldboss -> lib_boss:send_reveive_info(Status);
        true -> lib_server_send:send_to_uid(RoleId, pt_200, 20009, [IsRevive, ReviveTime])
    end;

%% 拾取怪物
handle(20010, Status, MonList) ->
    #player_status{id = RoleId, scene = Scene, scene_pool_id=ScenePoolId} = Status,
    mod_scene_agent:apply_cast(Scene, ScenePoolId, lib_battle, pick_mon, [RoleId, MonList]);

%% 与赏金怪物对话
%% handle(20011, Status, MonId) ->
%%     #player_status{
%%        id = RoleId, scene = Scene, scene_pool_id=ScenePoolId, team = #status_team{team_id=TeamId, positon = Position} } = Status,
%%     if
%%         TeamId =< 0 ->
%%             lib_server_send:send_to_sid(Status#player_status.sid, pt_200, 20011, [2]);
%%         Position =/= ?TEAM_LEADER ->
%%             lib_server_send:send_to_sid(Status#player_status.sid, pt_200, 20011, [3]);
%%         true ->
%%             mod_team:cast_to_team(TeamId, {'talk_to_mon', Scene, ScenePoolId, RoleId, MonId})
%%     end,
%%     ok;

%% 客户端请求扣血:幻兽之域独家采集扣血
handle(20012, Status, DHp) when DHp>0 ->
    #player_status{id=Id, scene=Scene, scene_pool_id=ScenePoolId, battle_attr=_BA} = Status,
    case data_scene:get(Scene) of
        #ets_scene{type = Type} when
            %Type =:= ?SCENE_TYPE_EUDEMONS_BOSS orelse
            Type =:= ?SCENE_TYPE_KF_TEMPLE
        ->
            mod_scene_agent:cast_to_scene(Scene, ScenePoolId, {'client_del_hp', Id});
        _ ->
            ok
    end;

%% 玩家登录请求被谁杀死
handle(20013, Status, []) ->
    #player_status{sid = Sid, figure = Figure, last_be_kill = LastBeKill, battle_attr = BA} = Status,
    if
        BA#battle_attr.hp > 0 -> skip;
        true ->
            case LastBeKill of
                [{sign, Sign}, {id, Id}, {name, Name}, {lv, Lv}|_] ->
                    {ok, Bin} = pt_200:write(20013, [Sign, Name, BA#battle_attr.pk#pk.pk_value, 0, Lv, Figure#figure.turn, Id]),
                    lib_server_send:send_to_sid(Sid, Bin);
                _ ->
                    skip
            end
    end;

%% 20014 20015

%% 5分钟内的回城复活次数
handle(20017, Status, []) ->
    #player_status{id = Id, sid = Sid} = Status,
    NowTime = utime:unixtime(),
    case get({Id, revive_tired}) of
        {LastTime, Num} when NowTime - LastTime < 300 ->
            LTime = LastTime + 300;
        _ ->
            Num = 0, LTime = 0
    end,
    {ok, BinData} = pt_200:write(20017, [Num, LTime]),
    lib_server_send:send_to_sid(Sid, BinData);

%% 20018 已用

%% 20019 已用

%% 抢夺归属
handle(20020, Status, [MonId]) ->
    #player_status{id = RoleId, scene=Scene, scene_pool_id=ScenePoolId} = Status,
    mod_scene_agent:apply_cast(Scene, ScenePoolId, lib_battle, rob_mon_bl, [node(), RoleId, MonId]);

%% 查看归属
handle(20021, Status, [MonId]) ->
    #player_status{id=RoleId, scene=Scene, scene_pool_id=ScenePoolId} = Status,
    mod_scene_agent:cast_to_scene(Scene, ScenePoolId, {'send_mon_own_info', node(), RoleId, MonId});

%% 查看能量值
handle(20023, Status, []) ->
    lib_battle:send_energy_info(Status);

%% 战斗状态
%% Type 1:开始;2:结束
handle(20024, Status, [Type]) ->
    % ?PRINT("Type:~p NowTime:~p ~n", [Type, utime:unixtime()]),
    NewStatus = if
        Type == 1 -> lib_player:enter_battle(Status);
        Type == 2 -> lib_player:off_battle(Status);
        true -> Status
    end,
    {ok, BinData} = pt_200:write(20024, [Type]),
    lib_server_send:send_to_sid(Status#player_status.sid, BinData),
    {ok, NewStatus};

%% 查看采集怪的采集对象
handle(20025, Status, [MonId, MonCfgId]) ->
    #player_status{id = Id, scene = SceneId, scene_pool_id=ScenePoolId} = Status,
    mod_scene_agent:apply_cast(SceneId, ScenePoolId, lib_battle, send_collectors_of_mon, [Id, MonId, MonCfgId]),
    {ok, Status};

handle(Cmd, _Status, Data) ->
    {error, {"pp_battle no match", Cmd, Data}}.


calc_collect_need_cell(#player_status{scene = ?PK_3V3_SCENE_ID}, _) -> 0;
%%calc_collect_need_cell(#player_status{scene = SceneId}, _) ->
%%    case data_scene:get(SceneId) of
%%        #ets_scene{type = ?SCENE_TYPE_KF_TEMPLE} ->
%%            0;
%%        _ ->
%%            1
%%    end;
%% 一般不检查背包格子数量
calc_collect_need_cell(_, _) -> 0.
