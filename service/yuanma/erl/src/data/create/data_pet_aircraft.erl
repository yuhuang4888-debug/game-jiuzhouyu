%%%---------------------------------------
%%% module      : data_pet_aircraft
%%% description : 精灵飞行器配置
%%%
%%%---------------------------------------
-module(data_pet_aircraft).
-compile(export_all).
-include("pet.hrl").



get_pet_aircraft_info_con(_) ->
	[].

get_aircraft_id_list() ->
[].

get_pet_aircraft_stage_con(1,1) ->
	#pet_aircraft_stage_con{aircraft_id = 1,stage = 1,cost_list = [],attr_list = [{1,75},{5,150},{7,150},{15,75}],if_send_tv = 0};

get_pet_aircraft_stage_con(_Aircraftid,_Stage) ->
	[].

