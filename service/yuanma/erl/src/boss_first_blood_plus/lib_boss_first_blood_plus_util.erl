%%-----------------------------------------------------------------------------
%% @Module  :       lib_boss_first_blood_plus_util
%% @Author  :       cxd
%% @Created :       2020-08-05
%% @Description:  首杀工具

-module(lib_boss_first_blood_plus_util).

-include("boss_first_blood_plus.hrl").

-compile(export_all).

sort(client_pos, [Type, SubType, BossIds]) ->
	F = fun(BossId1, BossId2) ->
		#base_first_blood_plus_boss{client_pos = ClientPos1} = data_first_blood_plus:get(Type, SubType, BossId1),
		#base_first_blood_plus_boss{client_pos = ClientPos2} = data_first_blood_plus:get(Type, SubType, BossId2),
		ClientPos1 < ClientPos2
	end,
	lists:sort(F, BossIds);
sort(_, _) -> [].
