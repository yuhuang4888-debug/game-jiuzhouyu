%% ---------------------------------------------------------------------------
%% @doc data_behavior_tree

%% @author  lzh
%% @email   lu13824949032@gmail.com
%% @since   2021/1/30 0030
%% @deprecated  
%% ---------------------------------------------------------------------------
-module(data_behavior_tree).

-include("scene_object_btree.hrl").

%% API
-compile([export_all]).

get_btree(ebt)->
	#behavior_tree{
		tree_id=test,
		root_node_id=1,
		nodes=#{
			1 => #selector_node{executor = lib_node_selector, node_id = 1, parent_id = undefined, child_list = [2,9] },
			2 => #sequence_node{executor = lib_node_sequence, node_id = 2, parent_id = 1, child_list = [3,4] },
			3 => #condition_node{executor = lib_node_condition, node_id = 3, parent_id = 2, condition = [{hp_more,0},{hp_less,10000}]},
			4 => #selector_node{executor = lib_node_selector, node_id = 4, parent_id = 2, child_list = [5,6] },
			5 => #sequence_node{executor = lib_node_sequence, node_id = 5, parent_id = 4, child_list = [7,8] },
			6 => #action_node{executor = lib_node_action, node_id = 6, parent_id = 4, module = lib_node_back, args = []},
			7 => #action_node{executor = lib_node_action, node_id = 7, parent_id = 5, module = lib_node_patrol, args = [{path_point,[{4388, 1690}]},{waring_range,200}]},
			8 => #action_node{executor = lib_node_action, node_id = 8, parent_id = 5, module = lib_node_attack, args = []},
			9 => #action_node{executor = lib_node_action, node_id = 9, parent_id = 1, module = lib_node_revive, args = []}
		}
	};

get_btree(onhook) ->
	#behavior_tree{
		tree_id = onhook,
		title = <<"托管假人"/utf8>>,
		root_node_id=1,
		nodes=#{
			1 => #selector_node{executor = lib_node_selector, desc = <<"选择节点"/utf8>>, node_id = 1, parent_id = undefined, child_list = [2,3,4,7] },
			2 => #action_node{executor = lib_node_action, desc = <<"拾取奖励"/utf8>>, node_id = 2, parent_id = 1, module = lib_node_pick_up, args = []},
			3 => #action_node{executor = lib_node_action, desc = <<"采集怪物"/utf8>>, node_id = 3, parent_id = 1, module = lib_node_collect, args = []},
			4 => #repeat_node{executor = lib_node_repeat, desc = <<"循环节点"/utf8>>, node_id = 4, parent_id = 1, child_list = [5], repeat = {loop_count,util_fail} },
			5 => #sequence_node{executor = lib_node_sequence, desc = <<"序列节点"/utf8>>, node_id = 5, parent_id = 4, child_list = [6,8] },
			6 => #action_node{executor = lib_node_action, desc = <<"寻找目标"/utf8>>, node_id = 6, parent_id = 5, module = lib_node_find_target, args = []},
			7 => #action_node{executor = lib_node_action, desc = <<"走去模块点"/utf8>>, node_id = 7, parent_id = 1, module = lib_node_walk, args = [{point,none},{is_trace,false}]},
			8 => #parallel_node{executor = lib_node_parallel, desc = <<"并行节点"/utf8>>, node_id = 8, parent_id = 5, child_list = [9,10], parallel_cfg = [{success_num,1}] },
			9 => #action_node{executor = lib_node_action, desc = <<"伙伴攻击"/utf8>>, node_id = 9, parent_id = 8, module = lib_node_pet_attack, args = []},
			10 => #action_node{executor = lib_node_action, desc = <<"攻击"/utf8>>, node_id = 10, parent_id = 8, module = lib_node_attack, args = []}
		},
		event_map=#{},
		desc = <<"用户活动托管的服务端控制玩家行为"/utf8>>
	};

get_btree(default_mon) ->
	#behavior_tree{
		tree_id = default_mon,
		title = <<"基础怪物"/utf8>>,
		root_node_id=1,
		nodes=#{
			1 => #selector_node{executor = lib_node_selector, desc = <<"选择节点"/utf8>>, node_id = 1, parent_id = undefined, child_list = [2,5] },
			2 => #sequence_node{executor = lib_node_sequence, desc = <<"序列节点"/utf8>>, node_id = 2, parent_id = 1, child_list = [3,4] },
			3 => #action_node{executor = lib_node_action, desc = <<"寻找目标"/utf8>>, node_id = 3, parent_id = 2, module = lib_node_find_target, args = []},
			4 => #action_node{executor = lib_node_action, desc = <<"攻击"/utf8>>, node_id = 4, parent_id = 2, module = lib_node_attack, args = []},
			5 => #action_node{executor = lib_node_action, desc = <<"返回出生点"/utf8>>, node_id = 5, parent_id = 1, module = lib_node_back, args = []}
		},
		event_map=#{},
		desc = <<"最基础的怪物行为。野怪的怪，普通的副本怪或者boss。找不到目标攻击之后会回到出生点"/utf8>>
	};

get_btree(default_dummy) ->
	#behavior_tree{
		title = <<"基础假人"/utf8>>,
		root_node_id=1,
		nodes=#{
			1 => #sequence_node{executor = lib_node_sequence, desc = <<"序列节点"/utf8>>, node_id = 1, parent_id = undefined, child_list = [2,3] },
			2 => #action_node{executor = lib_node_action, desc = <<"寻找目标"/utf8>>, node_id = 2, parent_id = 1, module = lib_node_find_target, args = []},
			3 => #action_node{executor = lib_node_action, desc = <<"攻击"/utf8>>, node_id = 3, parent_id = 1, module = lib_node_attack, args = []}
		},
		event_map=#{},
		desc = <<"最基础的假人，一般用于副本匹配，一些pk活动产生的假玩家数据，只有寻找目标和攻击两个行为"/utf8>>
	};

get_btree(jjc_dummy1) ->
	#behavior_tree{
		tree_id = jjc_dummy1,
		title = <<"竞技场假人1"/utf8>>,
		root_node_id=1,
		nodes=#{
			1 => #sequence_node{executor = lib_node_sequence, desc = <<"序列节点"/utf8>>, node_id = 1, parent_id = undefined, child_list = [2,4,5] },
			2 => #counter_node{executor = lib_node_counter, desc = <<"执行1次"/utf8>>, node_id = 2, parent_id = 1, child_list = [3], counter = {count,1} },
			3 => #action_node{executor = lib_node_action, desc = <<"走路"/utf8>>, node_id = 3, parent_id = 2, module = lib_node_walk, args = [{point,[{1271, 938}]},{is_trace,flase}]},
			4 => #action_node{executor = lib_node_action, desc = <<"寻找目标"/utf8>>, node_id = 4, parent_id = 1, module = lib_node_find_target, args = []},
			5 => #action_node{executor = lib_node_action, desc = <<"攻击"/utf8>>, node_id = 5, parent_id = 1, module = lib_node_attack, args = []}
		},
		event_map=#{},
		desc = <<"竞技场A方假人，和最基础的假人类似，不过需要出生时移动到指定点"/utf8>>
	};

get_btree(jjc_dummy2) ->
	#behavior_tree{
		tree_id=jjc_dummy2,
		title = <<"竞技场假人2"/utf8>>,
		root_node_id=1,
		nodes=#{
			1 => #sequence_node{executor = lib_node_sequence, desc = <<"序列节点"/utf8>>, node_id = 1, parent_id = undefined, child_list = [2,4,5] },
			2 => #counter_node{executor = lib_node_counter, desc = <<"执行1次"/utf8>>, node_id = 2, parent_id = 1, child_list = [3], counter = {count,1} },
			3 => #action_node{executor = lib_node_action, desc = <<"走路"/utf8>>, node_id = 3, parent_id = 2, module = lib_node_walk, args = [{point,[{1371, 859}]},{is_trace,false}]},
			4 => #action_node{executor = lib_node_action, desc = <<"寻找目标"/utf8>>, node_id = 4, parent_id = 1, module = lib_node_find_target, args = []},
			5 => #action_node{executor = lib_node_action, desc = <<"攻击"/utf8>>, node_id = 5, parent_id = 1, module = lib_node_attack, args = []}
		},
		event_map=#{},
		desc = <<"竞技场B方假人，和最基础的假人类似，不过需要出生时移动到指定点"/utf8>>
	};

get_btree(week_dungeon_boss2) ->
	#behavior_tree{
		tree_id = week_dungeon_boss2,
		title = <<"极地本怪物-全能之王"/utf8>>,
		root_node_id=1,
		nodes=#{
			1 => #selector_node{executor = lib_node_selector, desc = <<"选择节点"/utf8>>, node_id = 1, parent_id = undefined, child_list = [2,3] },
			2 => #sequence_node{executor = lib_node_sequence, desc = <<"序列节点"/utf8>>, node_id = 2, parent_id = 1, child_list = [4,5,6] },
			3 => #action_node{executor = lib_node_action, desc = <<"返回出生点"/utf8>>, node_id = 3, parent_id = 1, module = lib_node_back, args = []},
			4 => #action_node{executor = lib_node_action, desc = <<"寻找目标"/utf8>>, node_id = 4, parent_id = 2, module = lib_node_find_target, args = []},
			5 => #selector_node{executor = lib_node_selector, desc = <<"选择节点"/utf8>>, node_id = 5, parent_id = 2, child_list = [7,10,19] },
			6 => #action_node{executor = lib_node_action, desc = <<"攻击"/utf8>>, node_id = 6, parent_id = 2, module = lib_node_attack, args = []},
			7 => #sequence_node{executor = lib_node_sequence, desc = <<"序列节点"/utf8>>, node_id = 7, parent_id = 5, child_list = [8,9] },
			8 => #condition_node{executor = lib_node_condition, desc = <<"50%<HP<70%"/utf8>>, node_id = 8, parent_id = 7, condition = [{hp_more,5000},{hp_less,7000}]},
			9 => #action_node{executor = lib_node_action, desc = <<"更改技能和公共cd"/utf8>>, node_id = 9, parent_id = 7, module = lib_node_other, args = [{skill,[{3601050,1},{3601060,1},{900106,1}]},{pub_skill_cd_cfg,[{3601050,1,3000},{3601060,1,2000}]}]},
			10 => #sequence_node{executor = lib_node_sequence, desc = <<"序列节点"/utf8>>, node_id = 10, parent_id = 5, child_list = [11,12,14] },
			11 => #condition_node{executor = lib_node_condition, desc = <<"HP<50%"/utf8>>, node_id = 11, parent_id = 10, condition = [{hp_more,0},{hp_less,5000}]},
			12 => #interval_node{executor = lib_node_interval, desc = <<"间隔每6S"/utf8>>, node_id = 12, parent_id = 10, child_list = [13], interval = [{interval,6000},{is_succ,1}] },
			13 => #action_node{executor = lib_node_action, desc = <<"创建陨石怪"/utf8>>, node_id = 13, parent_id = 12, module = lib_node_create_mon, args = [{type,1},{mon_id,3600004},{x,[{100, 350}]},{y,[{100, 450}]},{arg,[]},{num,10}]},
			14 => #selector_node{executor = lib_node_selector, desc = <<"选择节点"/utf8>>, node_id = 14, parent_id = 10, child_list = [15,18] },
			15 => #sequence_node{executor = lib_node_sequence, desc = <<"序列节点"/utf8>>, node_id = 15, parent_id = 14, child_list = [16,17] },
			16 => #condition_node{executor = lib_node_condition, desc = <<"HP<30%"/utf8>>, node_id = 16, parent_id = 15, condition = [{hp_more,0},{hp_less,3000}]},
			17 => #action_node{executor = lib_node_action, desc = <<"更改公共cd"/utf8>>, node_id = 17, parent_id = 15, module = lib_node_other, args = []},
			18 => #condition_node{executor = lib_node_condition, desc = <<"HP>30%(节点出口)"/utf8>>, node_id = 18, parent_id = 14, condition = [{hp_more,3000},{hp_less,5000}]},
			19 => #action_node{executor = lib_node_action, desc = <<"默认技能"/utf8>>, node_id = 19, parent_id = 5, module = lib_node_other, args = [{skill,[{900106,1},{3601060,1}]}]}
		},
		event_map=#{},
		desc = <<"极地副本怪物AI"/utf8>>
	};

get_btree(falling_stone) ->
	#behavior_tree{
		tree_id = falling_stone,
		title = <<"陨石怪"/utf8>>,
		root_node_id=1,
		nodes=#{
			1 => #sequence_node{executor = lib_node_sequence, desc = <<"序列节点"/utf8>>, node_id = 1, parent_id = undefined, child_list = [2,3] },
			2 => #action_node{executor = lib_node_action, desc = <<"释放技能"/utf8>>, node_id = 2, parent_id = 1, module = lib_node_skill, args = [{ac_skill,{3600020, 1}}]},
			3 => #action_node{executor = lib_node_action, desc = <<"死亡"/utf8>>, node_id = 3, parent_id = 1, module = lib_node_die, args = []}
		},
		event_map=#{},
		desc = <<"出生后释放技能，然后死亡"/utf8>>
	}.