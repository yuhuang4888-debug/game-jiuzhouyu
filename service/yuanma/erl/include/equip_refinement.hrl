
-record(base_equip_refinement,{
		refine_lv = 0,   
		refine_pos = 1,
		promote = 0,            %% 提升万分比
		cost_list = []
	}).

-define(sql_select_equip_refinement, <<"select equip_pos, refine_lv from equip_refinement where role_id=~p">>).
-define(sql_replace_equip_refinement, <<"replace into equip_refinement set role_id=~p, equip_pos=~p, refine_lv=~p">>).