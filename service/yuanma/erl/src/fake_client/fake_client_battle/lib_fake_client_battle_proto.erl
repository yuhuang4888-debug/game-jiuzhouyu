%% ---------------------------------------------------------------------------
%% @doc lib_fake_client_battle_proto.erl

%% @author  lxl
%% @email  
%% @since  
%% @deprecated 战斗挂机处理
%% ---------------------------------------------------------------------------
-module(lib_fake_client_battle_proto).
-export([handle_proto/3]).

-include("server.hrl").
-include("common.hrl").
-include("errcode.hrl").
-include("scene.hrl").
-include("figure.hrl").
-include("fake_client.hrl").

%% 
handle_proto(20001, PS, [_AtterType, _Id, _Hp, _Anger, _MoveType, _SkillId, _SkillLv, _AerX, _AerY, _AttX, _AttY, _AttAngle, _AttBuffList, DefList]) ->
	%?PRINT("20001  : ~p~n", [{AtterType, Id, Hp}]),
	%% 删除血量为0的场景对象
	DelList = [{Sign1, Id1} ||{Sign1, Id1, Hp1, _, _, _, _, _, _, _, _, _} <- DefList, Hp1 == 0],
	{DelUserList, DelMonList} = lists:partition(fun({Sign1, _}) -> Sign1 == ?BATTLE_SIGN_PARTNER end, DelList),
	DelUserIdList = [Id1 || {_, Id1} <- DelUserList],
	DelMonIdList = [Id1 || {_, Id1} <- DelMonList],
	%?MYLOG("lxl_battle_proto", "20001 del : ~p~n", [{DelUserIdList, DelMonIdList}]),
	PS1 = lib_fake_client_scene_data:user_leave(PS, DelUserIdList),
	NPS = lib_fake_client_scene_data:object_leave(PS1, DelMonIdList),
	LastPS = lib_fake_client_event:object_leave(NPS, DelUserIdList++DelMonIdList),
	LastPS;

%% %% 玩家采集结果
handle_proto(20008, PS, [Code]) ->
	%?PRINT("20008 20008 : ~p~n", [Code]),
	case lib_fake_client:get_onhook_type() of
		?ON_HOOK_BEHAVIOR ->
			lib_player_behavior:collect_mon_result(PS, Code);
		_ ->
			lib_fake_client_battle:collect_mon_result(PS, Code)
	end;

%% %% 玩家采集被打断
handle_proto(20026, PS, [_StopperId]) ->
	%%
	case lib_fake_client:get_onhook_type() of
		?ON_HOOK_BEHAVIOR ->
			lib_player_behavior:interrupt_collect_mon(PS);
		_ ->
			lib_fake_client_battle:interrupt_collect(PS)
	end;

%% 设置技能cd
% handle_proto(20027, PS, [SkillId, EndTime]) ->
% 	?PRINT("20027 {SkillId, EndTime} : ~p~n", [{SkillId, EndTime}]),
% 	?MYLOG("lxl_battle_proto", "20027 SkillId, EndTime : ~p~n", [{SkillId, EndTime}]),
% 	#player_status{fake_client = FakeClient} = PS,
% 	#fake_client{att_skill_data = AttSkillData} = FakeClient,
% 	NewAttSkillData = lib_fake_client_battle:set_att_skill_data(AttSkillData, [{skill_cd, SkillId, EndTime}]),
%     NewFakeClient = FakeClient#fake_client{att_skill_data = NewAttSkillData},
% 	PS#player_status{fake_client = NewFakeClient};

handle_proto(_Cmd, PS, _Data) ->
    ?ERR("handle_proto no match : ~p~n", [{_Cmd, _Data}]),
    ?PRINT("handle_proto no match : ~p~n", [{_Cmd, _Data}]),
    PS.