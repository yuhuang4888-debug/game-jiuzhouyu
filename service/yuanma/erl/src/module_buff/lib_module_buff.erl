%%%--------------------------------------
%%% @Module  : lib_module_buff
%%% @Author  : lxl
%%% @Created : 2019.7.17
%%% @Description:  
%%%--------------------------------------

-module (lib_module_buff).

-include("common.hrl").
-include("server.hrl").
-include("boss.hrl").
-include("dungeon.hrl").
-include("scene.hrl").
-include("def_module_buff.hrl").
-export ([

]).   

-compile(export_all). 

login(PS) ->
	update_module_buff(PS).

update_module_buff(PS) ->	
	DemonsModBuffList = lib_demons:get_demons_module_buff(PS),
	ModBuffList = merge_mod_buff(DemonsModBuffList),
	%?PRINT("update### ModBuffList:~p~n", [ModBuffList]),
	SendList = [{Key, util:term_to_string(Data)} ||#module_buff{key = Key, data = Data} <- ModBuffList],
    lib_server_send:send_to_sid(PS#player_status.sid, pt_184, 18401, [SendList]),
	PS#player_status{mod_buff = ModBuffList}.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 获取具体buff的数据
%% 符文寻宝cd减免千分比
get_treasure_hunt_cd_buff(PS) ->
	#player_status{mod_buff = ModBuffList} = PS,
	case lists:keyfind(?TREASURE_HUNT_CD_BUFF, #module_buff.key, ModBuffList) of 
		#module_buff{data = Data} when is_integer(Data) -> Data / 10000;
		_ -> 0
	end.

%% 离线挂机时长增加时长(小时)
get_offline_onhook_time(PS) ->
	#player_status{mod_buff = ModBuffList} = PS,
	case lists:keyfind(?OFFLINE_ONHOOK_TIME_BUFF, #module_buff.key, ModBuffList) of 
		#module_buff{data = Data} when is_list(Data) -> 
			lists:sum([AddTime ||{onhook_time, AddTime} <- Data, is_integer(AddTime)]);
		_ -> 0
	end.
%% 挂机超过8小时额外礼包
get_offline_onhook_reward(PS) ->
	#player_status{mod_buff = ModBuffList} = PS,
	case lists:keyfind(?OFFLINE_ONHOOK_TIME_BUFF, #module_buff.key, ModBuffList) of 
		#module_buff{data = Data} when is_list(Data) -> 
			case [RewardList ||{reward, RewardList} <- Data, is_list(RewardList)] of
				[] -> [];
				List -> lists:flatten(List)
			end;
		_ -> []
	end.
%% 获取活跃礼包额外奖励
get_livenss_extra_reward(PS) ->
	#player_status{mod_buff = ModBuffList} = PS,
	case lists:keyfind(?LIVENESS_REWARD_BUFF, #module_buff.key, ModBuffList) of 
		#module_buff{data = Data} when is_list(Data) -> 
			case [RewardList ||{reward, RewardList} <- Data, is_list(RewardList)] of
				[] -> [];
				List -> lists:flatten(List)
			end;
		_ -> []
	end.

%% 获取装备合成的概率加成
get_equip_compose_ratio_add(PS) ->
	#player_status{mod_buff = ModBuffList} = PS,
	case lists:keyfind(?EQUIP_COMPOSE_BUFF, #module_buff.key, ModBuffList) of 
		#module_buff{data = Data} when is_integer(Data) -> Data;
		_ -> 0
	end.

%% 装备掉落率
get_equip_dungeon_drop_add(PS) ->
	#player_status{mod_buff = ModBuffList} = PS,
	case lists:keyfind(?EQUIP_DUNGEON_DROP_BUFF, #module_buff.key, ModBuffList) of 
		#module_buff{data = Data} when is_integer(Data) -> Data/10000;
		_ -> 0
	end.

%% 限时活动玩法额外技能列表
get_passive_skill(PS) ->
	#player_status{scene = Scene, mod_buff = ModBuffList} = PS,
	case data_scene:get(Scene) of 
		#ets_scene{type = SceneType} -> ok;
		_ -> SceneType = 0
	end,
	if
		SceneType == ?SCENE_TYPE_DRUMWAR orelse SceneType == ?SCENE_TYPE_NINE orelse
		SceneType == ?SCENE_TYPE_HOLY_SPIRIT_BATTLE orelse SceneType == ?SCENE_TYPE_TOPPK orelse
		SceneType == ?SCENE_TYPE_KF_1VN_BATTLE orelse SceneType == ?SCENE_TYPE_SANCTUM orelse 
		SceneType == ?SCENE_TYPE_GWAR orelse SceneType == ?SCENE_TYPE_SEACRAFT ->
			case lists:keyfind(?ACTIVITY_ATTR_BUFF, #module_buff.key, ModBuffList) of 
				#module_buff{data = SkillId} when is_integer(SkillId) -> 
					[{SkillId, 1}];
				_ -> []
			end;
		true ->
			[]
	end.

clean_buff(PS, EnterSceneId, LeaveSceneId) ->
	#player_status{id = RoleId, scene = SceneId, scene_pool_id = PoolId, mod_buff = ModBuffList} = PS,
	LeaveSceneType = lib_scene:get_scene_type(LeaveSceneId),
	EnterSceneType = lib_scene:get_scene_type(EnterSceneId),
	case EnterSceneType =/= LeaveSceneType andalso 
		(LeaveSceneType == ?SCENE_TYPE_DRUMWAR orelse LeaveSceneType == ?SCENE_TYPE_NINE orelse
		 LeaveSceneType == ?SCENE_TYPE_HOLY_SPIRIT_BATTLE orelse LeaveSceneType == ?SCENE_TYPE_TOPPK orelse
		 LeaveSceneType == ?SCENE_TYPE_KF_1VN_BATTLE orelse LeaveSceneType == ?SCENE_TYPE_SANCTUM orelse
		 LeaveSceneType == ?SCENE_TYPE_GWAR) 
	of 
		true ->
			case lists:keyfind(?ACTIVITY_ATTR_BUFF, #module_buff.key, ModBuffList) of 
				#module_buff{data = SkillId} when is_integer(SkillId) -> 
					%?PRINT("clean_buff:~p~n", [{SceneId, PoolId, RoleId, SkillId}]),
					lib_skill_api:clean_buff(SceneId, PoolId, RoleId, SkillId);
				_ -> ok
			end;
		_ ->
			ok
	end.

%% 祈愿暴击几率
get_pray_crit_ratio(_PS) -> 0.
	% #player_status{mod_buff = ModBuffList} = PS,
	% case lists:keyfind(?PRAY_CRIT_BUFF, #module_buff.key, ModBuffList) of 
	% 	#module_buff{data = Data} when is_integer(Data) -> Data/1000;
	% 	_ -> 0
	% end.

%% 获取boss增加的疲劳值
get_boss_anger_add(_PS, _BossType) -> 0.
	% #player_status{mod_buff = ModBuffList} = PS,
	% if
	% 	BossType == ?BOSS_TYPE_FORBIDDEN ->
	% 		case lists:keyfind(?FORBIDDEN_BOSS_ANGER_BUFF, #module_buff.key, ModBuffList) of 
	% 			#module_buff{data = Data} when is_integer(Data) -> Data;
	% 			_ -> 0
	% 		end;
	% 	true ->
	% 		0
	% end.
	
%% 获取钻石大战命数增加
get_drum_war_live(_PS) -> 0.
	% #player_status{mod_buff = ModBuffList} = PS,
	% case lists:keyfind(?DRUM_WAR_LIVE_BUFF, #module_buff.key, ModBuffList) of 
	% 	#module_buff{data = Data} when is_integer(Data) -> Data;
	% 	_ -> 0
	% end.

%% 经验副本经验加成
get_module_buff_exp_add(_PS) -> 0.
	% #player_status{dungeon = StatusDun, mod_buff = ModBuffList} = PS,
 %    #status_dungeon{dun_type = DunType} = StatusDun,
 %    case DunType == ?DUNGEON_TYPE_EXP_SINGLE orelse DunType == ?DUNGEON_TYPE_HIGH_EXP of 
 %    	true ->
	% 		case lists:keyfind(?EXP_DUNGEON_BUFF, #module_buff.key, ModBuffList) of 
	% 			#module_buff{data = Data} when is_integer(Data) -> Data;
	% 			_ -> 0
	% 		end;
	% 	_ ->
	% 		0
	% end.

%% 永恒圣殿血量上限加成
get_module_buff_hp_lim_add(_PS) -> 0.
	% #player_status{scene = Scene, mod_buff = ModBuffList} = PS,
	% case data_scene:get(Scene) of 
	% 	#ets_scene{type = ?SCENE_TYPE_SANCTUM} ->
	% 		case lists:keyfind(?SAMCTUM_HP_LIM_BUFF, #module_buff.key, ModBuffList) of 
	% 			#module_buff{data = Data} when is_integer(Data) -> Data/10000;
	% 			_ -> 0
	% 		end;
	% 	_ ->
	% 		0
	% end.

%% 获取被动技能列表
%get_passive_skill(_PS) ->
	% #player_status{scene = Scene, mod_buff = ModBuffList} = PS,
	% case data_scene:get(Scene) of 
	% 	#ets_scene{type = SceneType} -> ok;
	% 	_ -> SceneType = 0
	% end,
	% if
	% 	SceneType == ?SCENE_TYPE_KF_1VN_BATTLE ->
	% 		case lists:keyfind(?KF_1VN_SKILL_BUFF, #module_buff.key, ModBuffList) of 
	% 			#module_buff{data = SkillId} when is_integer(SkillId) -> 
	% 				[{SkillId, 1}];
	% 			_ -> []
	% 		end;
	% 	true ->
	% 		[]
	% end.

%% 竞榜活动结算奖励增加万分比
% get_race_act_reward_add(PS) ->
% 	#player_status{mod_buff = ModBuffList} = PS,
% 	case lists:keyfind(?RACE_ACT_REWARD_BUFF, #module_buff.key, ModBuffList) of 
% 		#module_buff{data = Data} when is_integer(Data) -> Data/10000;
% 		_ -> 0
% 	end.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 合并module_buff
merge_mod_buff(ModBuffList) ->
	F = fun(ModBuff, Return) ->
		#module_buff{key = Key, data = Data} = ModBuff,
		case lists:keyfind(Key, #module_buff.key, Return) of 
			#module_buff{data = OldData} ->
				NewData = plus_data(Key, OldData, Data),
				NewModBuff = ModBuff#module_buff{data = NewData},
				lists:keyreplace(Key, #module_buff.key, Return, NewModBuff);
			_ ->
				[ModBuff|Return]
		end
	end,
	lists:foldl(F, [], ModBuffList).

plus_data(Key, OldData, Data) ->
	Format = data_module_buff:get_format_type(Key),
	case Format of 
		1 -> OldData + Data;
		99 -> %% 自定义格式 [{key, value}], key:atom,value:自定义数据
			OldData ++ Data;
		_ ->
			Data
	end.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 构造module_buff
trans_to_module_buff(List) ->
	trans_to_module_buff(List, []).

trans_to_module_buff([], Return) -> Return;
trans_to_module_buff([{Key, Value}|List], Return) ->
	ModuleBuff = #module_buff{
		key = Key, data = Value
	},
	trans_to_module_buff(List, [ModuleBuff|Return]);
trans_to_module_buff([_|List], Return) ->
	trans_to_module_buff(List, Return).