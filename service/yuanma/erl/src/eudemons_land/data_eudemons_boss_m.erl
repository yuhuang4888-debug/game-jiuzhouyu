%%%---------------------------------------
%%% @Module  : data_eudemons_boss_m
%%% @Description : 幻兽之域手动配置
%%%---------------------------------------
-module(data_eudemons_boss_m).
-compile(export_all).
-include("eudemons_land.hrl").
-include("boss.hrl").
-include("def_module.hrl").




%% 跨服幻兽领与幻兽领boss共享次数
get_counter_module(?BOSS_TYPE_EUDEMONS, Type) ->
	case Type of 
		tired -> {?MOD_BOSS, ?MOD_BOSS_TIRE, ?BOSS_TYPE_PHANTOM};
		{collect, CollectType} -> {?MOD_EUDEMONS_BOSS, 1, CollectType};
		_ -> get_counter_module(0, 0)
	end;

get_counter_module(_, _) ->
	{?MOD_EUDEMONS_BOSS, 0, 0}.

%% 圣兽领采集次数限制
get_boss_collect_max(?BOSS_TYPE_EUDEMONS) ->
	case data_eudemons_land:get_eudemons_boss_type(?BOSS_TYPE_EUDEMONS) of 
		#eudemons_boss_type{count=NormalCount, rare_count=RareCount, crystal_count=CrystalCount} -> 
			{NormalCount, RareCount, CrystalCount};
		_ -> {0, 0, 0}
	end;

get_boss_collect_max(_) ->
	{0, 0, 0}.

