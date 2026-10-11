%%%-----------------------------------
%%% @Module  : pt_server
%%% @Author  : 
%%% @Email   : 
%%% @Created : 
%%% @Description: 解包 server to client 的协议数据
%%%-----------------------------------
-module(pt_server). 
-include("attr.hrl").
-include("figure.hrl").
-include("common.hrl").
-include("server.hrl").
-include("scene.hrl").
-include("drop.hrl").
-include("team.hrl").
-include("mount.hrl").
-include("battle.hrl").
-include("pet.hrl").
-include("kf_guild_war.hrl").
-include("def_fun.hrl").

-export([
		unpack/1
		, read/2
        ]).

unpack(Bin) ->
	<<L:32, Cmd:16, _Zip:8, Left/binary>> = Bin,
	DataLen = L - 7,
	<<DataBin:DataLen/binary, LeftBin/binary>> = Left,
	{Cmd, DataBin, LeftBin}.

read(12001, DataBin) ->
	<<BX:16, BY:16, Id:64, F:8, Left/binary>> = DataBin,
	case Left of 
		<<FX:16, FY:16, _/binary>> -> {ok, [BX, BY, Id, F, FX, FY]};
		_ -> {ok, [BX, BY, Id, F, 0, 0]}
	end;
read(12002, DataBin) ->
	{UserList, LeftBin} = unpack_scene_user_list(DataBin),
	{MonList, PartnerList, NormalList, DummyList, LeftBin1} = unpack_scene_object_list(LeftBin),
	{MarkList, _LeftBin2} = unpack_area_mark(LeftBin1),
	{ok, [UserList, MonList, PartnerList, NormalList, DummyList, MarkList]};
%%进入新场景广播给本场景的人
read(12003, DataBin) ->
	{User, _} = binary_from_12003(DataBin),
    {ok, [User]};
%%离开场景
read(12004, DataBin) ->
	<<Id:64, _/binary>> = DataBin,
    {ok, [Id]};
%%切换场景
read(12005, DataBin) ->
    <<Id:32, X:16, Y:16, ErrCode:32, DunId:32, Callback:8, TransType:8>> = DataBin,
    {ok, [Id, X, Y, ErrCode, DunId, Callback, TransType]};
%% 怪物消失
read(12006, DataBin) ->
	<<Id:32>> = DataBin,
    {ok, [Id]};
%% 有怪物进入场景
read(12007, DataBin) ->
	{Info, _} = binary_from_12007(DataBin),
    {ok, [Info]};
%% 场景对象移动
read(12008, DataBin) ->
	<<X:16, Y:16, Id:32>> = DataBin,
    {ok, [X, Y, Id]};
%% 9宫格加场景信息
read(12011, DataBin) ->
    {AddUserList, LeftBin} = unpack_scene_user_list(DataBin),
    {DelUserIdList, _} = unpack_leave_list(LeftBin),
    {ok, [AddUserList, DelUserIdList]};
%% 九宫格加载怪物
read(12012, DataBin) ->
    {AddMonList, AddPartnerList, AddNormalList, AddDummyList, LeftBin} = unpack_scene_object_list(DataBin),
    {DelObjectIdList, _} = unpack_scene_object_leave_list(LeftBin),
    {ok, [AddMonList, AddPartnerList, AddNormalList, AddDummyList, DelObjectIdList]};
%% 有伙伴进入场景
read(12013, DataBin) ->
	{Info, _} = binary_from_12013(DataBin),
    {ok, [Info]};
%% 场景一般对象
read(12014, DataBin) ->
    {Info, _} = binary_from_12014(DataBin),
    {ok, [Info]};
%% 场景假人
read(12015, DataBin) ->
    {Info, _} = binary_from_12015(DataBin),
    {ok, [Info]};
%% 场景掉落包
read(12017, DataBin) ->
    <<MonId:32, Time:16, Scene:32, Bin/binary>> = DataBin,
    Fun = fun(<<RestBin0/binary>>) -> 
        {EtsDrop, RestBin1} = binary_from_12017(RestBin0),
        {EtsDrop, RestBin1}
        end,
    {DropList, Bin1} = pt:read_array(Fun, Bin),
    <<X:16, Y:16, Boss:8, _/binary>> = Bin1,
    {ok, [MonId, Time, Scene, X, Y, Boss, DropList]};
%% 场景掉落包
read(12018, DataBin) ->
    Fun = fun(<<RestBin0/binary>>) -> 
        {EtsDrop, RestBin1} = binary_from_12018(RestBin0),
        {EtsDrop, RestBin1}
        end,
    {DropList, _} = pt:read_array(Fun, DataBin),
    {ok, [DropList]};
%% 掉落包消失
read(12019, DataBin) ->
    Fun = fun(<<RestBin0/binary>>) -> 
        <<DropId:64, RestBin1/binary>>  = RestBin0,
        {DropId, RestBin1}
        end,
    {DropIdL, _} = pt:read_array(Fun, DataBin),
    {ok, [DropIdL]};
%% 掉落包信息更改
read(12024, DataBin) ->
    <<DropId:64, RoleId:64, DropEndTime:64>> = DataBin,
    {ok, [DropId, RoleId, DropEndTime]};
%% 掉落包拾取返回
read(15053, DataBin) ->
    <<Res:32, Bin1/binary>> = DataBin,
    {Args, Bin2} = pt:read_string(Bin1),
    <<Status:8, DropId:64>> = Bin2,
    {ok, [Res, Args, Status, DropId]};
%% 隐身字段广播
read(12070, DataBin) ->
	<<Sign:8, Id:64, Hide:8>> = DataBin,
    {ok, [Sign, Id, Hide]};
%% 幽灵字段广播
read(12071, DataBin) ->
	<<Sign:8, Id:64, Ghost:8>> = DataBin,
    {ok, [Sign, Id, Ghost]};
%% 分组字段广播
read(12072, DataBin) ->
	<<Sign:8, Id:64, Group:64>> = DataBin,
    {ok, [Sign, Id, Group]};
%% 复活信息
read(12083, DataBin) ->
    <<ReviveType:8,ScenceId:32, X:16,Y:16,Bin1/binary>> = DataBin,
    {SceneName, Bin2} = pt:read_string(Bin1),
    <<Hp:64,Gold:32,BGold:32,AttProtectedTime:16>> = Bin2,
    {ok, [ReviveType,ScenceId, X,Y,SceneName,Hp,Gold,BGold,AttProtectedTime]};
%%%%%%%%%%%%%%%%%%%%%%%%%% 战斗协议
%%
read(20001, DataBin) ->
    <<AtterType:8, Id:64, Hp:64, Anger:32, MoveType:8, SkillId:32, SkillLv:16, 
        AerX:16, AerY:16, AttX:16, AttY:16, AttAngle:16, LeftBin/binary>> = DataBin,
    {AttBuffList, LeftBin1} = lib_skill_buff:unpack_buff(LeftBin),
    {_TriggerSkillL, LeftBin2} = unpack_trigger_skillL(LeftBin1),
    {DefList, _} = unpack_def_list(LeftBin2),
    {ok, [AtterType, Id, Hp, Anger, MoveType, SkillId, SkillLv, AerX, AerY, AttX, AttY, AttAngle, AttBuffList, DefList]};
%%采集怪物
read(20008, DataBin) ->
    <<Res:8>> = DataBin,
    {ok, [Res]};
%% 玩家采集被打断
read(20026, DataBin) ->
    <<StopperId:64>> = DataBin,
    {ok, [StopperId]};
%% 设置技能cd
read(20027, DataBin) ->
    <<SkillId:32, EndTime:64>> = DataBin,
    {ok, [SkillId, EndTime]};

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 九魂圣殿
read(13502, DataBin) ->
    <<ErrorCode:32>> = DataBin,
    {ok, [ErrorCode]};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 巅峰竞技
read(28110, DataBin) ->
    <<ErrorCode:32>> = DataBin,
    {ok, [ErrorCode]};
read(28113, DataBin) ->
    <<Res:8, Honor:32, Flag:8, Point:32>> = DataBin,
    {ok, [Res, Honor, Flag, Point]};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 午间派对
read(28501,DataBin) ->
    <<ErrorCode:32>> = DataBin,
    {ok, [ErrorCode]};

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 钻石大战
read(13704, DataBin) ->
    <<ErrorCode:32>> = DataBin,
    {ok, [ErrorCode]};
read(13710, DataBin) ->
    <<SelfLife:8, OtherLife:8>> = DataBin,
    {ok, [SelfLife, OtherLife]};
read(13708, DataBin) ->
    <<Settlement:8,Result:8,ActionId:8>> = DataBin,
    {ok, [Settlement, Result, ActionId]};

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 公会活动
read(40212, DataBin) ->
    <<ErrorCode:32>> = DataBin,
    {ok, [ErrorCode]};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 圣灵战场
read(21802, DataBin) ->
    <<ErrorCode:32>> = DataBin,
    {ok, [ErrorCode]};
read(21809, DataBin) ->
    {RoleName, Bin1} = pt:read_string(DataBin),
    <<RoleId:64, Lv:16, Power:64, PictureId:32, Bin2/binary>> = Bin1,
    {Picture, Bin3} = pt:read_string(Bin2),
    <<Anger:32, ServerId:32, Career:8, Turn:8>> = Bin3,
    {ok, [RoleName, RoleId, Lv, Power, PictureId, Picture, Anger, ServerId, Career, Turn]};
read(21813, DataBin) ->
    Fun = fun(<<RestBin0/binary>>) -> 
        <<MonAuto:32, MonCfgId:32, Hp:32, HpAll:32, GroupId:8, RestBin1/binary>> = RestBin0,
        {{MonAuto, MonCfgId, Hp, HpAll, GroupId}, RestBin1}
        end,
    {MonList, _} = pt:read_array(Fun, DataBin),
    {ok, [MonList]};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 公会争霸
read(50603, DataBin) ->
    <<ErrorCode:32, Type:8>> = DataBin,
    {ok, [ErrorCode, Type]};
read(50604, DataBin) ->
    <<TerritoryId:32, EndTime:32, RoleScore:32, Bin1/binary>> = DataBin,
    Fun1 = fun(<<RestBin0/binary>>) -> 
        <<GuildId:64, RestBin1/binary>> = RestBin0,
        {GuildName, RestBin2} = pt:read_string(RestBin1),
        <<ServerId:16, ServerNum:16, Score:32, RestBin3/binary>> = RestBin2,
        Fun11 = fun(<<RB0/binary>>) ->
            <<ModId:32, RB1/binary>> = RB0,
            {ModId, RB1}
            end,
        {OwnList, RestBin4} = pt:read_array(Fun11, RestBin3),
        {{GuildId, GuildName, ServerId, ServerNum, Score, OwnList}, RestBin4}
        end,
    Fun2 = fun(<<RestBin0/binary>>) -> 
        <<Keyid:8, RestBin1/binary>> = RestBin0,
        {Keyid, RestBin1}
        end,
    Fun3 = fun(<<RestBin0/binary>>) -> 
        <<Type:8, GuildId:64, RestBin1/binary>> = RestBin0,
        {GuildName, RestBin2} = pt:read_string(RestBin1),
        <<MonId:32, Hp:32, HpLim:32, RestBin3/binary>> = RestBin2,
        {{Type, GuildId, GuildName, MonId, Hp, HpLim}, RestBin3}
        end,  

    {GuildList, Bin2} = pt:read_array(Fun1, Bin1),
    {StageList, Bin3} = pt:read_array(Fun2, Bin2),
    {OwnList, _} = pt:read_array(Fun3, Bin3),
    {ok, [TerritoryId, EndTime, RoleScore, GuildList, StageList, OwnList]};
read(50607, DataBin) ->
    Fun1 = fun(<<RestBin0/binary>>) -> 
        <<Type:8, GuildId:64, RestBin1/binary>> = RestBin0,
        {GuildName, RestBin2} = pt:read_string(RestBin1),
        <<MonId:32, Hp:32, HpLim:32, RestBin3/binary>> = RestBin2,
        {{Type, GuildId, GuildName, MonId, Hp, HpLim}, RestBin3}
        end,  
    {OwnList, _} = pt:read_array(Fun1, DataBin),
    {ok, [OwnList]};
read(50611, DataBin) ->
    <<TerritoryId:32, ModeNum:8, Bin1/binary>> = DataBin,
    Fun1 = fun(<<RestBin0/binary>>) -> 
        <<GuildId:64, IsWin:8, RestBin1/binary>> = RestBin0,
        {GuildName, RestBin2} = pt:read_string(RestBin1),
        <<ServerId:16, ServerNum:16, Score:32, RestBin3/binary>> = RestBin2,
        Fun11 = fun(<<RB0/binary>>) ->
            <<ModId:32, RB1/binary>> = RB0,
            {ModId, RB1}
            end,
        {OwnList, RestBin4} = pt:read_array(Fun11, RestBin3),
        {{GuildId, IsWin, GuildName, ServerId, ServerNum, Score, OwnList}, RestBin4}
        end,
    {GuildList, _} = pt:read_array(Fun1, Bin1),
    {ok, [TerritoryId, ModeNum, GuildList]};
read(50620, DataBin) ->
    <<Round:8, RoundStartTime:32, RoundEndTime:32>> = DataBin,
    {ok, [Round, RoundStartTime, RoundEndTime]};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 1vN
read(62101, DataBin) ->
    <<Stage:8, Turn:16, Edtime:32, SubStage:8, SubEdtime:32>> = DataBin,
    {ok, [Stage, Turn, Edtime, SubStage, SubEdtime]};
read(62103, DataBin) ->
    <<Code:32>> = DataBin,
    {ok, [Code]};

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 领地夺宝
read(65202, DataBin) ->
    <<Code:32, Dunid:32, TotalWave:16, FirstWaveTime:32, Wave:16, Num:16, EndTime:32>> = DataBin,
    {ok, [Code, Dunid, TotalWave, FirstWaveTime, Wave, Num, EndTime]};
read(65204, DataBin) ->
    Fun = fun(<<RestBin0/binary>>) -> 
        {RoleName, RestBin1} = pt:read_string(RestBin0),
        <<Damage:64, RestBin2/binary>> = RestBin1,
        {{RoleName, Damage}, RestBin2}
        end,
    {Rank, Bin1} = pt:read_array(Fun, DataBin),
    <<Wave:16, Num:16, Time:32>> = Bin1,
    {ok, [Rank, Wave, Num, Time]};
read(65209, DataBin) ->
    <<MonId:32, X:16, Y:16>> = DataBin,
    {ok, [MonId, X, Y]};
read(_, _) ->
	{ok, []}.

unpack_leave_list(Bin) ->
	Fun = fun(<<RestBin0/binary>>) -> 
        <<Id:64, _Args1/binary>> = RestBin0, 
        {Id,_Args1}
        end,
    {DelUserIdList, LeftBin} = pt:read_array(Fun, Bin),
    {DelUserIdList, LeftBin}.

unpack_scene_object_leave_list(Bin) ->
    Fun = fun(<<RestBin0/binary>>) -> 
        <<Id:32, _Args1/binary>> = RestBin0, 
        {Id,_Args1}
        end,
    {DelObjectIdList, LeftBin} = pt:read_array(Fun, Bin),
    {DelObjectIdList, LeftBin}.

unpack_scene_user_list(Bin) ->
	<<RLen:16, RB/binary>> = Bin,
    unpack_scene_user_list_helper(0, RLen, RB, []).

unpack_scene_user_list_helper(RLen, RLen, RB, UserList) ->
	{UserList, RB};
unpack_scene_user_list_helper(Index, RLen, RB, UserList) ->
    {User, RestRB} = binary_from_12003(RB),
	unpack_scene_user_list_helper(Index+1, RLen, RestRB, [User|UserList]).

%% 解包场景元素
unpack_scene_object_list(Bin) ->
	<<MonLen:16, Bin1/binary>> = Bin,
	F = fun(_I, {R, List, LeftBin}) ->
		if 
			R == 1 ->
				{S, LeftBin1} = binary_from_12007(LeftBin),
				{R, [S|List], LeftBin1};
			R == 2 ->
				{S, LeftBin1} = binary_from_12013(LeftBin),
				{R, [S|List], LeftBin1};
			R == 3 ->
				{S, LeftBin1} = binary_from_12014(LeftBin),
				{R, [S|List], LeftBin1};
			R == 4 ->
				{S, LeftBin1} = binary_from_12015(LeftBin),
				{R, [S|List], LeftBin1};
			true ->
				{R, List, LeftBin}
		end
	end,
	{_, MonList, Bin2} = lists:foldl(F, {1, [], Bin1}, lists:seq(1, MonLen)),
	<<PartnerLen:16, Bin3/binary>> = Bin2,
	{_, PartnerList, Bin4} = lists:foldl(F, {2, [], Bin3}, lists:seq(1, PartnerLen)),
	<<NormalLen:16, Bin5/binary>> = Bin4,
	{_, NormalList, Bin6} = lists:foldl(F, {3, [], Bin5}, lists:seq(1, NormalLen)),
	<<DummyLen:16, Bin7/binary>> = Bin6,
	{_, DummyList, Bin8} = lists:foldl(F, {4, [], Bin7}, lists:seq(1, DummyLen)),
	{MonList, PartnerList, NormalList, DummyList, Bin8}.

unpack_area_mark(Bin) ->
	Fun = fun(<<RestBin0/binary>>) -> 
        <<AreaId:8, ClientType:8, _Args1/binary>> = RestBin0, 
        {{AreaId, ClientType},_Args1}
        end,
    {MarkList, LeftBin} = pt:read_array(Fun, Bin),
    {MarkList, LeftBin}.

unpack_trigger_skillL(Bin) ->
    Fun = fun(<<RestBin0/binary>>) ->
        <<SkillId:32, RestBin2/binary>> = RestBin0,
        {SkillId, RestBin2}
    end,
    {DefList, LeftBin} = pt:read_array(Fun, Bin),
    {DefList, LeftBin} .

unpack_def_list(Bin) ->
    Fun = fun(<<RestBin0/binary>>) -> 
        <<Sign:8, Id:64, Hp:64, Anger:32, Hurt:32, HurtType:8, SecHurtType:8, X:16, Y:16, Move:8, InteruptSkillId:32, RestBin1/binary>> = RestBin0, 
        {BuffList, RestBin2} = lib_skill_buff:unpack_buff(RestBin1),
        {{Sign, Id, Hp, Anger, Hurt, HurtType, SecHurtType, X, Y, Move, InteruptSkillId, BuffList},RestBin2}
        end,
    {DefList, LeftBin} = pt:read_array(Fun, Bin),
    {DefList, LeftBin} .

binary_from_12003(Bin) ->
    <<Id:64, Bin1/binary>> = Bin,
    {PlatFomr, Bin2} = pt:read_string(Bin1),
    <<ServerId:16, ServerNum:16, Bin3/binary>> = Bin2,
    {ServerName, Bin4} = pt:read_string(Bin3),
    {Figure, Bin5} = pt:read_figure(Bin4),
    <<X:16, Y:16, Hp:64, HpLim:64, Speed:16, Hide:8, Ghost:8,Group:64,BlWho:8, 
        TeamId:64,Position:8,PkStatus:8,CombatPower:64,PkValue:16,
        PkProtectTime:32,MateRoleId:64,ShipModelId:32,ProtectTime:32,CampId:16,
        LeftBin/binary>> = Bin5,
    Pk = #pk{
    	pk_status = PkStatus, pk_value = PkValue, pk_protect_time = PkProtectTime, protect_time = ProtectTime
    },
    BA = #battle_attr{
    	hp = Hp, hp_lim = HpLim, speed = Speed, hide = Hide, ghost = Ghost, group = Group, combat_power = CombatPower,
    	pk = Pk
    },
    Team = #status_team{team_id = TeamId, positon = Position},
    EtsUser = #ets_scene_user{
    	id = Id, platform = PlatFomr, server_id = ServerId, server_num = ServerNum, server_name = ServerName,
    	figure = Figure, x = X, y = Y, battle_attr = BA, bl_who = BlWho, team = Team, mate_role_id = MateRoleId,
    	ship_id = ShipModelId, camp_id = CampId
    },
    {EtsUser, LeftBin}.

binary_from_12007(Bin) ->
    <<X:16, Y:16, Id:32, Mid:32, Hp:64, HpLim:64, Lv:16, Bin1/binary>> = Bin,
    {Name, Bin2} = pt:read_string(Bin1),
    <<Speed:16, Body:32, Bin3/binary>> = Bin2,
    {IconEffect, Bin4} = pt:read_string(Bin3),
    <<IconTextrue:32, WeaponId:32, AttType:8, Kind:8, Color:8, Out:8, Boss:8, CollectTime:32, IsBeClicked:8, 
    	IsBeAtted:8, Hide:8, Ghost:8, Group:64, GuildId:64, BlRoleId:64, FrenzyEnterTime:32, Bin5/binary>> = Bin4,
    {GuildName, Bin6} = pt:read_string(Bin5),
    <<ServerNum:16, NextCollectTime:32, LeftBin/binary>> = Bin6,
    BA = #battle_attr{
    	hp = Hp, hp_lim = HpLim, speed = Speed, hide = Hide, ghost = Ghost, group = Group
    },
    Figure = #figure{lv=Lv, name=Name, body=Body, guild_id = GuildId, guild_name = GuildName},
    Mon = #scene_mon{mid=Mid, kind=Kind, out=Out, boss=Boss, collect_time=CollectTime, next_collect_time = NextCollectTime},
    S = #scene_object{
       x = X, y = Y, id = Id, config_id = Mid, sign = ?BATTLE_SIGN_MON,
       figure  = Figure, battle_attr = BA,
       att_type = AttType, color = Color,
       is_be_atted = IsBeAtted, is_be_clicked = IsBeClicked,
       icon_effect = IconEffect, icon_texture = IconTextrue,
       weapon_id = WeaponId, skill_owner = #skill_owner{guild_id = GuildId},
       mon = Mon, bl_role_id = BlRoleId, frenzy_enter_time = FrenzyEnterTime, 
       server_num = ServerNum},
    {S, LeftBin}.

%% partner
binary_from_12013(Bin) ->
    FunArrayLvModel = fun(<<RestBin0/binary>>) -> 
        <<Part:8, ModelId:32, _Args1/binary>> = RestBin0, 
        {{Part, ModelId},_Args1}
        end,

    <<X:16, Y:16, Id:32, Hp:64, HpLim:64, Bin1/binary>> = Bin,
    {Name, Bin2} = pt:read_string(Bin1),
    <<Lv:16, Speed:16, Career:8, Hide:8, Group:64, Bin3/binary>> = Bin2,
    {LvModel, Bin4} = pt:read_array(FunArrayLvModel, Bin3),
    <<IconTextrue:32, OwnerId:64, LeftBin/binary>> = Bin4,
    S = #scene_object{
       x       = X,
       y       = Y,
       id      = Id,
       sign = ?BATTLE_SIGN_PARTNER,
       icon_texture=IconTextrue,
       figure  = #figure{name=Name, lv = Lv, career=Career, lv_model=LvModel},
       skill_owner=#skill_owner{id=OwnerId},
       battle_attr = #battle_attr{speed=Speed, hp=Hp, hp_lim=HpLim, hide=Hide, group=Group}
    },
    {S, LeftBin}.

%% 一般场景物
binary_from_12014(Bin) ->
    <<X:16, Y:16, Id:32, Bin1/binary>> = Bin,
    {Name, Bin2} = pt:read_string(Bin1),
    <<Body:32, Bin3/binary>> = Bin2,
    {IconEffect, Bin4} = pt:read_string(Bin3),
    <<Speed:16, IsBeClicked:8, TeamId:64, PlayerId:64, LeftBin/binary>> = Bin4,
    S = #scene_object{
       x       = X,
       y       = Y,
       id      = Id,
       figure  = #figure{name = Name, body = Body},
       icon_effect = IconEffect,
       is_be_clicked = IsBeClicked,
       skill_owner = #skill_owner{id=PlayerId, team_id=TeamId},
       battle_attr = #battle_attr{speed=Speed}
    },
    {S, LeftBin}.

%% 假人
binary_from_12015(Bin) ->
    <<Id:32, _:16, _:16, _:16, Bin1/binary>> = Bin,
    {Figure, Bin2} = pt:read_figure(Bin1),
    <<X:16, Y:16, Hp:64, HpLim:64, Speed:16, Hide:8, Ghost:8, Group:64, LeftBin/binary>> = Bin2,
    BA = #battle_attr{hp=Hp, hp_lim=HpLim, speed=Speed, hide=Hide, ghost=Ghost, group=Group},
    S = #scene_object{
       id      = Id,
       x       = X,
       y       = Y,
       sign = ?BATTLE_SIGN_DUMMY,
       figure  = Figure,
       battle_attr = BA},
    {S, LeftBin}.

binary_from_12017(Bin) ->
    <<DropId:64, DTType:8, GoodsTypeId:32, GoodsNum:32, RoleId:64, ServerId:16, TeamId:64, Camp:16, GuildId:64, X:16, Y:16, Bin1/binary>> = Bin,
    {DropEff, Bin2} = pt:read_string(Bin1),
    {DropIcon, Bin3} = pt:read_string(Bin2),
    <<PickTime:32, ExpireTime:32, DropWay:8, Alloc:8, LeftBin/binary>> = Bin3,
    GoodsDrop = #ets_drop{
        id = DropId, player_id = RoleId, x = X, y = Y, drop_thing_type = DTType, alloc = Alloc, guild_id = GuildId,
        goods_id = GoodsTypeId, num = GoodsNum, drop_icon = DropIcon, camp_id = Camp, server_id = ServerId, team_id = TeamId,
        expire_time = ExpireTime, drop_leff = DropEff, drop_way = DropWay,
        pick_time = PickTime},
    {GoodsDrop, LeftBin}.


binary_from_12018(Bin) ->
    <<DropId:64, DTType:8, GoodsTypeId:32, GoodsNum:32, RoleId:64, ServerId:16, TeamId:64, Camp:16, GuildId:64, X:16, Y:16, Bin1/binary>> = Bin,
    {DropEff, Bin2} = pt:read_string(Bin1),
    {DropIcon, Bin3} = pt:read_string(Bin2),
    <<PickTime:32, PickPlayerId:64, PickEndTime:64, ExpireTime:32, DropWay:8, Mid:32, DropX:16, DropY:16, Alloc:8, LeftBin/binary>> = Bin3,
    GoodsDrop = #ets_drop{
        id = DropId, player_id = RoleId, x = X, y = Y, drop_thing_type = DTType, alloc = Alloc,
        goods_id = GoodsTypeId, num = GoodsNum, drop_icon = DropIcon, camp_id = Camp, server_id = ServerId, team_id = TeamId,
        expire_time = ExpireTime, drop_leff = DropEff, drop_way = DropWay, mon_id = Mid, guild_id = GuildId,
        pick_time = PickTime, pick_player_id = PickPlayerId, pick_end_time = PickEndTime, drop_x = DropX, drop_y = DropY},
    {GoodsDrop, LeftBin}.