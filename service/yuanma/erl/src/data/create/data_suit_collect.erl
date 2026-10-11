%%%---------------------------------------
%%% module      : data_suit_collect
%%% description : 套装收集配置
%%%
%%%---------------------------------------
-module(data_suit_collect).
-compile(export_all).
-include("equip_suit.hrl").



get_suit_clt_cfg(1,1) ->
	#base_suit_clt{suit_id = 1,career = 1,name = "二忍套装",open_lv = 20,open_turn = 0,show_equip = [{1,101012020,0},{2,101022020,0},{3,101032020,0},{4,101042020,0},{5,101052020,0},{6,101062020,0},{8,101082020,0},{10,101102020,0}],stage = 2,star = 0,color = 2,power_show = 4400,fashion_id = 1111,fashion_color = 1};

get_suit_clt_cfg(1,2) ->
	#base_suit_clt{suit_id = 1,career = 2,name = "二忍套装",open_lv = 20,open_turn = 0,show_equip = [{1,102012020,0},{2,102022020,0},{3,101032020,0},{4,102042020,0},{5,101052020,0},{6,102062020,0},{8,102082020,0},{10,102102020,0}],stage = 2,star = 0,color = 2,power_show = 4400,fashion_id = 1213,fashion_color = 1};

get_suit_clt_cfg(1,3) ->
	#base_suit_clt{suit_id = 1,career = 3,name = "二忍套装",open_lv = 20,open_turn = 0,show_equip = [{1,103012020,0},{2,101022020,0},{3,101032020,0},{4,101042020,0},{5,101052020,0},{6,101062020,0},{8,101082020,0},{10,101102020,0}],stage = 2,star = 0,color = 2,power_show = 4400,fashion_id = 1300,fashion_color = 1};

get_suit_clt_cfg(1,4) ->
	#base_suit_clt{suit_id = 1,career = 4,name = "二忍套装",open_lv = 20,open_turn = 0,show_equip = [{1,104012020,0},{2,102022020,0},{3,101032020,0},{4,102042020,0},{5,101052020,0},{6,102062020,0},{8,102082020,0},{10,102102020,0}],stage = 2,star = 0,color = 2,power_show = 4400,fashion_id = 1400,fashion_color = 1};

get_suit_clt_cfg(2,1) ->
	#base_suit_clt{suit_id = 2,career = 1,name = "三浦套装",open_lv = 40,open_turn = 0,show_equip = [{1,101013030,0},{2,101023030,0},{3,101033030,0},{4,101043030,0},{5,101053030,0},{6,101063030,0},{8,101083030,0},{10,101103030,0}],stage = 3,star = 0,color = 3,power_show = 6800,fashion_id = 1111,fashion_color = 2};

get_suit_clt_cfg(2,2) ->
	#base_suit_clt{suit_id = 2,career = 2,name = "三浦套装",open_lv = 40,open_turn = 0,show_equip = [{1,102013030,0},{2,102023030,0},{3,101033030,0},{4,102043030,0},{5,101053030,0},{6,102063030,0},{8,102083030,0},{10,102103030,0}],stage = 3,star = 0,color = 3,power_show = 6800,fashion_id = 1213,fashion_color = 2};

get_suit_clt_cfg(2,3) ->
	#base_suit_clt{suit_id = 2,career = 3,name = "三浦套装",open_lv = 40,open_turn = 0,show_equip = [{1,103013030,0},{2,101023030,0},{3,101033030,0},{4,101043030,0},{5,101053030,0},{6,101063030,0},{8,101083030,0},{10,101103030,0}],stage = 3,star = 0,color = 3,power_show = 6800,fashion_id = 1300,fashion_color = 2};

get_suit_clt_cfg(2,4) ->
	#base_suit_clt{suit_id = 2,career = 4,name = "三浦套装",open_lv = 40,open_turn = 0,show_equip = [{1,104013030,0},{2,102023030,0},{3,101033030,0},{4,102043030,0},{5,101053030,0},{6,102063030,0},{8,102083030,0},{10,102103030,0}],stage = 3,star = 0,color = 3,power_show = 6800,fashion_id = 1400,fashion_color = 2};

get_suit_clt_cfg(3,1) ->
	#base_suit_clt{suit_id = 3,career = 1,name = "四季橙一",open_lv = 76,open_turn = 0,show_equip = [{1,101014041,119},{2,101024041,119},{3,101034041,29},{4,101044041,119},{5,101054041,29},{6,101064041,119},{8,101084041,119},{10,101104041,119}],stage = 4,star = 1,color = 4,power_show = 9950,fashion_id = 1111,fashion_color = 3};

get_suit_clt_cfg(3,2) ->
	#base_suit_clt{suit_id = 3,career = 2,name = "四季橙一",open_lv = 76,open_turn = 0,show_equip = [{1,102014041,119},{2,102024041,119},{3,101034041,29},{4,102044041,119},{5,101054041,29},{6,102064041,119},{8,102084041,119},{10,102104041,119}],stage = 4,star = 1,color = 4,power_show = 9950,fashion_id = 1213,fashion_color = 3};

get_suit_clt_cfg(3,3) ->
	#base_suit_clt{suit_id = 3,career = 3,name = "四季橙一",open_lv = 76,open_turn = 0,show_equip = [{1,103014041,119},{2,101024041,119},{3,101034041,29},{4,101044041,119},{5,101054041,29},{6,101064041,119},{8,101084041,119},{10,101104041,119}],stage = 4,star = 1,color = 4,power_show = 9950,fashion_id = 1300,fashion_color = 3};

get_suit_clt_cfg(3,4) ->
	#base_suit_clt{suit_id = 3,career = 4,name = "四季橙一",open_lv = 76,open_turn = 0,show_equip = [{1,104014041,119},{2,102024041,119},{3,101034041,29},{4,102044041,119},{5,101054041,29},{6,102064041,119},{8,102084041,119},{10,102104041,119}],stage = 4,star = 1,color = 4,power_show = 9950,fashion_id = 1400,fashion_color = 3};

get_suit_clt_cfg(4,1) ->
	#base_suit_clt{suit_id = 4,career = 1,name = "四季红一",open_lv = 100,open_turn = 0,show_equip = [{1,101015041,119},{2,101025041,119},{3,101035041,29},{4,101045041,119},{5,101055041,29},{6,101065041,119},{8,101085041,119},{10,101105041,119}],stage = 4,star = 1,color = 5,power_show = 13200,fashion_id = 1111,fashion_color = 4};

get_suit_clt_cfg(4,2) ->
	#base_suit_clt{suit_id = 4,career = 2,name = "四季红一",open_lv = 100,open_turn = 0,show_equip = [{1,102015041,119},{2,102025041,119},{3,101035041,29},{4,102045041,119},{5,101055041,29},{6,102065041,119},{8,102085041,119},{10,102105041,119}],stage = 4,star = 1,color = 5,power_show = 13200,fashion_id = 1213,fashion_color = 4};

get_suit_clt_cfg(4,3) ->
	#base_suit_clt{suit_id = 4,career = 3,name = "四季红一",open_lv = 100,open_turn = 0,show_equip = [{1,103015041,119},{2,101025041,119},{3,101035041,29},{4,101045041,119},{5,101055041,29},{6,101065041,119},{8,101085041,119},{10,101105041,119}],stage = 4,star = 1,color = 5,power_show = 13200,fashion_id = 1300,fashion_color = 4};

get_suit_clt_cfg(4,4) ->
	#base_suit_clt{suit_id = 4,career = 4,name = "四季红一",open_lv = 100,open_turn = 0,show_equip = [{1,104015041,119},{2,102025041,119},{3,101035041,29},{4,102045041,119},{5,101055041,29},{6,102065041,119},{8,102085041,119},{10,102105041,119}],stage = 4,star = 1,color = 5,power_show = 13200,fashion_id = 1400,fashion_color = 4};

get_suit_clt_cfg(5,1) ->
	#base_suit_clt{suit_id = 5,career = 1,name = "五更橙一",open_lv = 130,open_turn = 0,show_equip = [{1,101014051,26},{2,101024051,26},{3,101034051,29},{4,101044051,26},{5,101054051,29},{6,101064051,26},{8,101084051,26},{10,101104051,26}],stage = 5,star = 1,color = 4,power_show = 13800,fashion_id = 1111,fashion_color = 4};

get_suit_clt_cfg(5,2) ->
	#base_suit_clt{suit_id = 5,career = 2,name = "五更橙一",open_lv = 130,open_turn = 0,show_equip = [{1,102014051,26},{2,102024051,26},{3,101034051,29},{4,102044051,26},{5,101054051,29},{6,102064051,26},{8,102084051,26},{10,102104051,26}],stage = 5,star = 1,color = 4,power_show = 13800,fashion_id = 1213,fashion_color = 4};

get_suit_clt_cfg(5,3) ->
	#base_suit_clt{suit_id = 5,career = 3,name = "五更橙一",open_lv = 130,open_turn = 0,show_equip = [{1,103014051,26},{2,101024051,26},{3,101034051,29},{4,101044051,26},{5,101054051,29},{6,101064051,26},{8,101084051,26},{10,101104051,26}],stage = 5,star = 1,color = 4,power_show = 13800,fashion_id = 1300,fashion_color = 4};

get_suit_clt_cfg(5,4) ->
	#base_suit_clt{suit_id = 5,career = 4,name = "五更橙一",open_lv = 130,open_turn = 0,show_equip = [{1,104014051,26},{2,102024051,26},{3,101034051,29},{4,102044051,26},{5,101054051,29},{6,102064051,26},{8,102084051,26},{10,102104051,26}],stage = 5,star = 1,color = 4,power_show = 13800,fashion_id = 1400,fashion_color = 4};

get_suit_clt_cfg(6,1) ->
	#base_suit_clt{suit_id = 6,career = 1,name = "五更红一",open_lv = 130,open_turn = 0,show_equip = [{1,101015051,26},{2,101025051,26},{3,101035051,29},{4,101045051,26},{5,101055051,29},{6,101065051,26},{8,101085051,26},{10,101105051,26}],stage = 5,star = 1,color = 5,power_show = 18000,fashion_id = 1111,fashion_color = 4};

get_suit_clt_cfg(6,2) ->
	#base_suit_clt{suit_id = 6,career = 2,name = "五更红一",open_lv = 130,open_turn = 0,show_equip = [{1,102015051,26},{2,102025051,26},{3,101035051,29},{4,102045051,26},{5,101055051,29},{6,102065051,26},{8,102085051,26},{10,102105051,26}],stage = 5,star = 1,color = 5,power_show = 18000,fashion_id = 1213,fashion_color = 4};

get_suit_clt_cfg(6,3) ->
	#base_suit_clt{suit_id = 6,career = 3,name = "五更红一",open_lv = 130,open_turn = 0,show_equip = [{1,103015051,26},{2,101025051,26},{3,101035051,29},{4,101045051,26},{5,101055051,29},{6,101065051,26},{8,101085051,26},{10,101105051,26}],stage = 5,star = 1,color = 5,power_show = 18000,fashion_id = 1300,fashion_color = 4};

get_suit_clt_cfg(6,4) ->
	#base_suit_clt{suit_id = 6,career = 4,name = "五更红一",open_lv = 130,open_turn = 0,show_equip = [{1,104015051,26},{2,102025051,26},{3,101035051,29},{4,102045051,26},{5,101055051,29},{6,102065051,26},{8,102085051,26},{10,102105051,26}],stage = 5,star = 1,color = 5,power_show = 18000,fashion_id = 1400,fashion_color = 4};

get_suit_clt_cfg(7,1) ->
	#base_suit_clt{suit_id = 7,career = 1,name = "五更红二",open_lv = 130,open_turn = 0,show_equip = [{1,101015052,26},{2,101025052,26},{3,101035052,29},{4,101045052,26},{5,101055052,29},{6,101065052,26},{8,101085052,26},{10,101105052,26}],stage = 5,star = 2,color = 5,power_show = 37550,fashion_id = 1111,fashion_color = 4};

get_suit_clt_cfg(7,2) ->
	#base_suit_clt{suit_id = 7,career = 2,name = "五更红二",open_lv = 130,open_turn = 0,show_equip = [{1,102015052,26},{2,102025052,26},{3,101035052,29},{4,102045052,26},{5,101055052,29},{6,102065052,26},{8,102085052,26},{10,102105052,26}],stage = 5,star = 2,color = 5,power_show = 37550,fashion_id = 1213,fashion_color = 4};

get_suit_clt_cfg(7,3) ->
	#base_suit_clt{suit_id = 7,career = 3,name = "五更红二",open_lv = 130,open_turn = 0,show_equip = [{1,103015052,26},{2,101025052,26},{3,101035052,29},{4,101045052,26},{5,101055052,29},{6,101065052,26},{8,101085052,26},{10,101105052,26}],stage = 5,star = 2,color = 5,power_show = 37550,fashion_id = 1300,fashion_color = 4};

get_suit_clt_cfg(7,4) ->
	#base_suit_clt{suit_id = 7,career = 4,name = "五更红二",open_lv = 130,open_turn = 0,show_equip = [{1,104015052,26},{2,102025052,26},{3,101035052,29},{4,102045052,26},{5,101055052,29},{6,102065052,26},{8,102085052,26},{10,102105052,26}],stage = 5,star = 2,color = 5,power_show = 37550,fashion_id = 1400,fashion_color = 4};

get_suit_clt_cfg(8,1) ->
	#base_suit_clt{suit_id = 8,career = 1,name = "六城红一",open_lv = 150,open_turn = 0,show_equip = [{1,101015061,26},{2,101025061,26},{3,101035061,70},{4,101045061,26},{5,101055061,70},{6,101065061,26},{8,101085061,26},{10,101105061,26}],stage = 6,star = 1,color = 5,power_show = 20275,fashion_id = 1111,fashion_color = 4};

get_suit_clt_cfg(8,2) ->
	#base_suit_clt{suit_id = 8,career = 2,name = "六城红一",open_lv = 150,open_turn = 0,show_equip = [{1,102015061,26},{2,102025061,26},{3,101035061,70},{4,102045061,26},{5,101055061,70},{6,102065061,26},{8,102085061,26},{10,102105061,26}],stage = 6,star = 1,color = 5,power_show = 20275,fashion_id = 1213,fashion_color = 4};

get_suit_clt_cfg(8,3) ->
	#base_suit_clt{suit_id = 8,career = 3,name = "六城红一",open_lv = 150,open_turn = 0,show_equip = [{1,103015061,26},{2,101025061,26},{3,101035061,70},{4,101045061,26},{5,101055061,70},{6,101065061,26},{8,101085061,26},{10,101105061,26}],stage = 6,star = 1,color = 5,power_show = 20275,fashion_id = 1300,fashion_color = 4};

get_suit_clt_cfg(8,4) ->
	#base_suit_clt{suit_id = 8,career = 4,name = "六城红一",open_lv = 150,open_turn = 0,show_equip = [{1,104015061,26},{2,102025061,26},{3,101035061,70},{4,102045061,26},{5,101055061,70},{6,102065061,26},{8,102085061,26},{10,102105061,26}],stage = 6,star = 1,color = 5,power_show = 20275,fashion_id = 1400,fashion_color = 4};

get_suit_clt_cfg(9,1) ->
	#base_suit_clt{suit_id = 9,career = 1,name = "六城红二",open_lv = 150,open_turn = 0,show_equip = [{1,101015062,26},{2,101025062,26},{3,101035062,29},{4,101045062,26},{5,101055062,29},{6,101065062,26},{8,101085062,26},{10,101105062,26}],stage = 6,star = 2,color = 5,power_show = 63725,fashion_id = 1111,fashion_color = 4};

get_suit_clt_cfg(9,2) ->
	#base_suit_clt{suit_id = 9,career = 2,name = "六城红二",open_lv = 150,open_turn = 0,show_equip = [{1,102015062,26},{2,102025062,26},{3,101035062,29},{4,102045062,26},{5,101055062,29},{6,102065062,26},{8,102085062,26},{10,102105062,26}],stage = 6,star = 2,color = 5,power_show = 63725,fashion_id = 1213,fashion_color = 4};

get_suit_clt_cfg(9,3) ->
	#base_suit_clt{suit_id = 9,career = 3,name = "六城红二",open_lv = 150,open_turn = 0,show_equip = [{1,103015062,26},{2,101025062,26},{3,101035062,29},{4,101045062,26},{5,101055062,29},{6,101065062,26},{8,101085062,26},{10,101105062,26}],stage = 6,star = 2,color = 5,power_show = 63725,fashion_id = 1300,fashion_color = 4};

get_suit_clt_cfg(9,4) ->
	#base_suit_clt{suit_id = 9,career = 4,name = "六城红二",open_lv = 150,open_turn = 0,show_equip = [{1,104015062,26},{2,102025062,26},{3,101035062,29},{4,102045062,26},{5,101055062,29},{6,102065062,26},{8,102085062,26},{10,102105062,26}],stage = 6,star = 2,color = 5,power_show = 63725,fashion_id = 1400,fashion_color = 4};

get_suit_clt_cfg(10,1) ->
	#base_suit_clt{suit_id = 10,career = 1,name = "七海红二",open_lv = 180,open_turn = 0,show_equip = [{1,101015072,26},{2,101025072,26},{3,101035072,29},{4,101045072,26},{5,101055072,29},{6,101065072,26},{8,101085072,26},{10,101105072,26}],stage = 7,star = 2,color = 5,power_show = 117000,fashion_id = 1111,fashion_color = 4};

get_suit_clt_cfg(10,2) ->
	#base_suit_clt{suit_id = 10,career = 2,name = "七海红二",open_lv = 180,open_turn = 0,show_equip = [{1,102015072,26},{2,102025072,26},{3,101035072,29},{4,102045072,26},{5,101055072,29},{6,102065072,26},{8,102085072,26},{10,102105072,26}],stage = 7,star = 2,color = 5,power_show = 117000,fashion_id = 1213,fashion_color = 4};

get_suit_clt_cfg(10,3) ->
	#base_suit_clt{suit_id = 10,career = 3,name = "七海红二",open_lv = 180,open_turn = 0,show_equip = [{1,103015072,26},{2,101025072,26},{3,101035072,29},{4,101045072,26},{5,101055072,29},{6,101065072,26},{8,101085072,26},{10,101105072,26}],stage = 7,star = 2,color = 5,power_show = 117000,fashion_id = 1300,fashion_color = 4};

get_suit_clt_cfg(10,4) ->
	#base_suit_clt{suit_id = 10,career = 4,name = "七海红二",open_lv = 180,open_turn = 0,show_equip = [{1,104015072,26},{2,102025072,26},{3,101035072,29},{4,102045072,26},{5,101055072,29},{6,102065072,26},{8,102085072,26},{10,102105072,26}],stage = 7,star = 2,color = 5,power_show = 117000,fashion_id = 1400,fashion_color = 4};

get_suit_clt_cfg(11,1) ->
	#base_suit_clt{suit_id = 11,career = 1,name = "七海红三",open_lv = 180,open_turn = 0,show_equip = [{1,101015073,96},{2,101025073,96},{3,101035073,29},{4,101045073,96},{5,101055073,29},{6,101065073,96},{8,101085073,96},{10,101105073,96}],stage = 7,star = 3,color = 5,power_show = 216000,fashion_id = 1111,fashion_color = 4};

get_suit_clt_cfg(11,2) ->
	#base_suit_clt{suit_id = 11,career = 2,name = "七海红三",open_lv = 180,open_turn = 0,show_equip = [{1,102015073,96},{2,102025073,96},{3,101035073,29},{4,102045073,96},{5,101055073,29},{6,102065073,96},{8,102085073,96},{10,102105073,96}],stage = 7,star = 3,color = 5,power_show = 216000,fashion_id = 1213,fashion_color = 4};

get_suit_clt_cfg(11,3) ->
	#base_suit_clt{suit_id = 11,career = 3,name = "七海红三",open_lv = 180,open_turn = 0,show_equip = [{1,103015073,96},{2,101025073,96},{3,101035073,29},{4,101045073,96},{5,101055073,29},{6,101065073,96},{8,101085073,96},{10,101105073,96}],stage = 7,star = 3,color = 5,power_show = 216000,fashion_id = 1300,fashion_color = 4};

get_suit_clt_cfg(11,4) ->
	#base_suit_clt{suit_id = 11,career = 4,name = "七海红三",open_lv = 180,open_turn = 0,show_equip = [{1,104015073,96},{2,102025073,96},{3,101035073,29},{4,102045073,96},{5,101055073,29},{6,102065073,96},{8,102085073,96},{10,102105073,96}],stage = 7,star = 3,color = 5,power_show = 216000,fashion_id = 1400,fashion_color = 4};

get_suit_clt_cfg(12,1) ->
	#base_suit_clt{suit_id = 12,career = 1,name = "九重红二",open_lv = 300,open_turn = 0,show_equip = [{1,101015092,26},{2,101025092,26},{3,101035092,29},{4,101045092,26},{5,101055092,29},{6,101065092,26},{8,101085092,26},{10,101105092,26}],stage = 9,star = 2,color = 5,power_show = 432000,fashion_id = 1111,fashion_color = 4};

get_suit_clt_cfg(12,2) ->
	#base_suit_clt{suit_id = 12,career = 2,name = "九重红二",open_lv = 300,open_turn = 0,show_equip = [{1,102015092,26},{2,102025092,26},{3,101035092,29},{4,102045092,26},{5,101055092,29},{6,102065092,26},{8,102085092,26},{10,102105092,26}],stage = 9,star = 2,color = 5,power_show = 432000,fashion_id = 1213,fashion_color = 4};

get_suit_clt_cfg(12,3) ->
	#base_suit_clt{suit_id = 12,career = 3,name = "九重红二",open_lv = 300,open_turn = 0,show_equip = [{1,103015092,26},{2,101025092,26},{3,101035092,29},{4,101045092,26},{5,101055092,29},{6,101065092,26},{8,101085092,26},{10,101105092,26}],stage = 9,star = 2,color = 5,power_show = 432000,fashion_id = 1300,fashion_color = 4};

get_suit_clt_cfg(12,4) ->
	#base_suit_clt{suit_id = 12,career = 4,name = "九重红二",open_lv = 300,open_turn = 0,show_equip = [{1,104015092,26},{2,102025092,26},{3,101035092,29},{4,102045092,26},{5,101055092,29},{6,102065092,26},{8,102085092,26},{10,102105092,26}],stage = 9,star = 2,color = 5,power_show = 432000,fashion_id = 1400,fashion_color = 4};

get_suit_clt_cfg(13,1) ->
	#base_suit_clt{suit_id = 13,career = 1,name = "九重红三",open_lv = 300,open_turn = 0,show_equip = [{1,101015093,96},{2,101025093,96},{3,101035093,29},{4,101045093,96},{5,101055093,29},{6,101065093,96},{8,101085093,96},{10,101105093,96}],stage = 9,star = 3,color = 5,power_show = 720000,fashion_id = 1111,fashion_color = 4};

get_suit_clt_cfg(13,2) ->
	#base_suit_clt{suit_id = 13,career = 2,name = "九重红三",open_lv = 300,open_turn = 0,show_equip = [{1,102015093,96},{2,102025093,96},{3,101035093,29},{4,102045093,96},{5,101055093,29},{6,102065093,96},{8,102085093,96},{10,102105093,96}],stage = 9,star = 3,color = 5,power_show = 720000,fashion_id = 1213,fashion_color = 4};

get_suit_clt_cfg(13,3) ->
	#base_suit_clt{suit_id = 13,career = 3,name = "九重红三",open_lv = 300,open_turn = 0,show_equip = [{1,103015093,96},{2,101025093,96},{3,101035093,29},{4,101045093,96},{5,101055093,29},{6,101065093,96},{8,101085093,96},{10,101105093,96}],stage = 9,star = 3,color = 5,power_show = 720000,fashion_id = 1300,fashion_color = 4};

get_suit_clt_cfg(13,4) ->
	#base_suit_clt{suit_id = 13,career = 4,name = "九重红三",open_lv = 300,open_turn = 0,show_equip = [{1,104015093,96},{2,102025093,96},{3,101035093,29},{4,102045093,96},{5,101055093,29},{6,102065093,96},{8,102085093,96},{10,102105093,96}],stage = 9,star = 3,color = 5,power_show = 720000,fashion_id = 1400,fashion_color = 4};

get_suit_clt_cfg(14,1) ->
	#base_suit_clt{suit_id = 14,career = 1,name = "黄泉红三",open_lv = 371,open_turn = 0,show_equip = [{1,101015103,96},{2,101025103,96},{3,101035103,29},{4,101045103,96},{5,101055103,29},{6,101065103,96},{8,101085103,96},{10,101105103,96}],stage = 10,star = 3,color = 5,power_show = 810000,fashion_id = 1111,fashion_color = 4};

get_suit_clt_cfg(14,2) ->
	#base_suit_clt{suit_id = 14,career = 2,name = "黄泉红三",open_lv = 371,open_turn = 0,show_equip = [{1,102015103,96},{2,102025103,96},{3,101035103,29},{4,102045103,96},{5,101055103,29},{6,102065103,96},{8,102085103,96},{10,102105103,96}],stage = 10,star = 3,color = 5,power_show = 810000,fashion_id = 1213,fashion_color = 4};

get_suit_clt_cfg(14,3) ->
	#base_suit_clt{suit_id = 14,career = 3,name = "黄泉红三",open_lv = 371,open_turn = 0,show_equip = [{1,103015103,96},{2,101025103,96},{3,101035103,29},{4,101045103,96},{5,101055103,29},{6,101065103,96},{8,101085103,96},{10,101105103,96}],stage = 10,star = 3,color = 5,power_show = 810000,fashion_id = 1300,fashion_color = 4};

get_suit_clt_cfg(14,4) ->
	#base_suit_clt{suit_id = 14,career = 4,name = "黄泉红三",open_lv = 371,open_turn = 0,show_equip = [{1,104015103,96},{2,102025103,96},{3,101035103,29},{4,102045103,96},{5,101055103,29},{6,102065103,96},{8,102085103,96},{10,102105103,96}],stage = 10,star = 3,color = 5,power_show = 810000,fashion_id = 1400,fashion_color = 4};

get_suit_clt_cfg(15,1) ->
	#base_suit_clt{suit_id = 15,career = 1,name = "月夜红三",open_lv = 420,open_turn = 0,show_equip = [{1,101015113,96},{2,101025113,96},{3,101035113,29},{4,101045113,96},{5,101055113,29},{6,101065113,96},{8,101085113,96},{10,101105113,96}],stage = 11,star = 3,color = 5,power_show = 900000,fashion_id = 1111,fashion_color = 4};

get_suit_clt_cfg(15,2) ->
	#base_suit_clt{suit_id = 15,career = 2,name = "月夜红三",open_lv = 420,open_turn = 0,show_equip = [{1,102015113,96},{2,102025113,96},{3,101035113,29},{4,102045113,96},{5,101055113,29},{6,102065113,96},{8,102085113,96},{10,102105113,96}],stage = 11,star = 3,color = 5,power_show = 900000,fashion_id = 1213,fashion_color = 4};

get_suit_clt_cfg(15,3) ->
	#base_suit_clt{suit_id = 15,career = 3,name = "月夜红三",open_lv = 420,open_turn = 0,show_equip = [{1,103015113,96},{2,101025113,96},{3,101035113,29},{4,101045113,96},{5,101055113,29},{6,101065113,96},{8,101085113,96},{10,101105113,96}],stage = 11,star = 3,color = 5,power_show = 900000,fashion_id = 1300,fashion_color = 4};

get_suit_clt_cfg(15,4) ->
	#base_suit_clt{suit_id = 15,career = 4,name = "月夜红三",open_lv = 420,open_turn = 0,show_equip = [{1,104015113,96},{2,102025113,96},{3,101035113,29},{4,102045113,96},{5,101055113,29},{6,102065113,96},{8,102085113,96},{10,102105113,96}],stage = 11,star = 3,color = 5,power_show = 900000,fashion_id = 1400,fashion_color = 4};

get_suit_clt_cfg(16,1) ->
	#base_suit_clt{suit_id = 16,career = 1,name = "天海红三",open_lv = 470,open_turn = 0,show_equip = [{1,101015123,96},{2,101025123,96},{3,101035123,29},{4,101045123,96},{5,101055123,29},{6,101065123,96},{8,101085123,96},{10,101105123,96}],stage = 12,star = 3,color = 5,power_show = 990000,fashion_id = 1111,fashion_color = 4};

get_suit_clt_cfg(16,2) ->
	#base_suit_clt{suit_id = 16,career = 2,name = "天海红三",open_lv = 470,open_turn = 0,show_equip = [{1,102015123,96},{2,102025123,96},{3,101035123,29},{4,102045123,96},{5,101055123,29},{6,102065123,96},{8,102085123,96},{10,102105123,96}],stage = 12,star = 3,color = 5,power_show = 990000,fashion_id = 1213,fashion_color = 4};

get_suit_clt_cfg(16,3) ->
	#base_suit_clt{suit_id = 16,career = 3,name = "天海红三",open_lv = 470,open_turn = 0,show_equip = [{1,103015123,96},{2,101025123,96},{3,101035123,29},{4,101045123,96},{5,101055123,29},{6,101065123,96},{8,101085123,96},{10,101105123,96}],stage = 12,star = 3,color = 5,power_show = 990000,fashion_id = 1300,fashion_color = 4};

get_suit_clt_cfg(16,4) ->
	#base_suit_clt{suit_id = 16,career = 4,name = "天海红三",open_lv = 470,open_turn = 0,show_equip = [{1,104015123,96},{2,102025123,96},{3,101035123,29},{4,102045123,96},{5,101055123,29},{6,102065123,96},{8,102085123,96},{10,102105123,96}],stage = 12,star = 3,color = 5,power_show = 990000,fashion_id = 1400,fashion_color = 4};

get_suit_clt_cfg(17,1) ->
	#base_suit_clt{suit_id = 17,career = 1,name = "赤诚红三",open_lv = 520,open_turn = 0,show_equip = [{1,101015133,96},{2,101025133,96},{3,101035133,29},{4,101045133,96},{5,101055133,29},{6,101065133,96},{8,101085133,96},{10,101105133,96}],stage = 13,star = 3,color = 5,power_show = 1080000,fashion_id = 1111,fashion_color = 4};

get_suit_clt_cfg(17,2) ->
	#base_suit_clt{suit_id = 17,career = 2,name = "赤诚红三",open_lv = 520,open_turn = 0,show_equip = [{1,102015133,96},{2,102025133,96},{3,101035133,29},{4,102045133,96},{5,101055133,29},{6,102065133,96},{8,102085133,96},{10,102105133,96}],stage = 13,star = 3,color = 5,power_show = 1080000,fashion_id = 1213,fashion_color = 4};

get_suit_clt_cfg(17,3) ->
	#base_suit_clt{suit_id = 17,career = 3,name = "赤诚红三",open_lv = 520,open_turn = 0,show_equip = [{1,103015133,96},{2,101025133,96},{3,101035133,29},{4,101045133,96},{5,101055133,29},{6,101065133,96},{8,101085133,96},{10,101105133,96}],stage = 13,star = 3,color = 5,power_show = 1080000,fashion_id = 1300,fashion_color = 4};

get_suit_clt_cfg(17,4) ->
	#base_suit_clt{suit_id = 17,career = 4,name = "赤诚红三",open_lv = 520,open_turn = 0,show_equip = [{1,104015133,96},{2,102025133,96},{3,101035133,29},{4,102045133,96},{5,101055133,29},{6,102065133,96},{8,102085133,96},{10,102105133,96}],stage = 13,star = 3,color = 5,power_show = 1080000,fashion_id = 1400,fashion_color = 4};

get_suit_clt_cfg(18,1) ->
	#base_suit_clt{suit_id = 18,career = 1,name = "鬼面红三",open_lv = 570,open_turn = 0,show_equip = [{1,101015143,96},{2,101025143,96},{3,101035143,29},{4,101045143,96},{5,101055143,29},{6,101065143,96},{8,101085143,96},{10,101105143,96}],stage = 14,star = 3,color = 5,power_show = 1170000,fashion_id = 1111,fashion_color = 4};

get_suit_clt_cfg(18,2) ->
	#base_suit_clt{suit_id = 18,career = 2,name = "鬼面红三",open_lv = 570,open_turn = 0,show_equip = [{1,102015143,96},{2,102025143,96},{3,101035143,29},{4,102045143,96},{5,101055143,29},{6,102065143,96},{8,102085143,96},{10,102105143,96}],stage = 14,star = 3,color = 5,power_show = 1170000,fashion_id = 1213,fashion_color = 4};

get_suit_clt_cfg(18,3) ->
	#base_suit_clt{suit_id = 18,career = 3,name = "鬼面红三",open_lv = 570,open_turn = 0,show_equip = [{1,103015143,96},{2,101025143,96},{3,101035143,29},{4,101045143,96},{5,101055143,29},{6,101065143,96},{8,101085143,96},{10,101105143,96}],stage = 14,star = 3,color = 5,power_show = 1170000,fashion_id = 1300,fashion_color = 4};

get_suit_clt_cfg(18,4) ->
	#base_suit_clt{suit_id = 18,career = 4,name = "鬼面红三",open_lv = 570,open_turn = 0,show_equip = [{1,104015143,96},{2,102025143,96},{3,101035143,29},{4,102045143,96},{5,101055143,29},{6,102065143,96},{8,102085143,96},{10,102105143,96}],stage = 14,star = 3,color = 5,power_show = 1170000,fashion_id = 1400,fashion_color = 4};

get_suit_clt_cfg(19,1) ->
	#base_suit_clt{suit_id = 19,career = 1,name = "言灵红三",open_lv = 620,open_turn = 0,show_equip = [{1,101015153,96},{2,101025153,96},{3,101035153,29},{4,101045153,96},{5,101055153,29},{6,101065153,96},{8,101085153,96},{10,101105153,96}],stage = 15,star = 3,color = 5,power_show = 1260000,fashion_id = 1111,fashion_color = 4};

get_suit_clt_cfg(19,2) ->
	#base_suit_clt{suit_id = 19,career = 2,name = "言灵红三",open_lv = 620,open_turn = 0,show_equip = [{1,102015153,96},{2,102025153,96},{3,101035153,29},{4,102045153,96},{5,101055153,29},{6,102065153,96},{8,102085153,96},{10,102105153,96}],stage = 15,star = 3,color = 5,power_show = 1260000,fashion_id = 1213,fashion_color = 4};

get_suit_clt_cfg(19,3) ->
	#base_suit_clt{suit_id = 19,career = 3,name = "言灵红三",open_lv = 620,open_turn = 0,show_equip = [{1,103015153,96},{2,101025153,96},{3,101035153,29},{4,101045153,96},{5,101055153,29},{6,101065153,96},{8,101085153,96},{10,101105153,96}],stage = 15,star = 3,color = 5,power_show = 1260000,fashion_id = 1300,fashion_color = 4};

get_suit_clt_cfg(19,4) ->
	#base_suit_clt{suit_id = 19,career = 4,name = "言灵红三",open_lv = 620,open_turn = 0,show_equip = [{1,104015153,96},{2,102025153,96},{3,101035153,29},{4,102045153,96},{5,101055153,29},{6,102065153,96},{8,102085153,96},{10,102105153,96}],stage = 15,star = 3,color = 5,power_show = 1260000,fashion_id = 1400,fashion_color = 4};

get_suit_clt_cfg(20,1) ->
	#base_suit_clt{suit_id = 20,career = 1,name = "雷鸣红三",open_lv = 670,open_turn = 0,show_equip = [{1,101015163,96},{2,101025163,96},{3,101035163,29},{4,101045163,96},{5,101055163,29},{6,101065163,96},{8,101085163,96},{10,101105163,96}],stage = 16,star = 3,color = 5,power_show = 1350000,fashion_id = 1111,fashion_color = 4};

get_suit_clt_cfg(20,2) ->
	#base_suit_clt{suit_id = 20,career = 2,name = "雷鸣红三",open_lv = 670,open_turn = 0,show_equip = [{1,102015163,96},{2,102025163,96},{3,101035163,29},{4,102045163,96},{5,101055163,29},{6,102065163,96},{8,102085163,96},{10,102105163,96}],stage = 16,star = 3,color = 5,power_show = 1350000,fashion_id = 1213,fashion_color = 4};

get_suit_clt_cfg(20,3) ->
	#base_suit_clt{suit_id = 20,career = 3,name = "雷鸣红三",open_lv = 670,open_turn = 0,show_equip = [{1,103015163,96},{2,101025163,96},{3,101035163,29},{4,101045163,96},{5,101055163,29},{6,101065163,96},{8,101085163,96},{10,101105163,96}],stage = 16,star = 3,color = 5,power_show = 1350000,fashion_id = 1300,fashion_color = 4};

get_suit_clt_cfg(20,4) ->
	#base_suit_clt{suit_id = 20,career = 4,name = "雷鸣红三",open_lv = 670,open_turn = 0,show_equip = [{1,104015163,96},{2,102025163,96},{3,101035163,29},{4,102045163,96},{5,101055163,29},{6,102065163,96},{8,102085163,96},{10,102105163,96}],stage = 16,star = 3,color = 5,power_show = 1350000,fashion_id = 1400,fashion_color = 4};

get_suit_clt_cfg(_Suitid,_Career) ->
	[].


get_all_suit_id(1) ->
[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20];


get_all_suit_id(2) ->
[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20];


get_all_suit_id(3) ->
[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20];


get_all_suit_id(4) ->
[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20];

get_all_suit_id(_Career) ->
	[].

get_suit_clt_process(1,1) ->
	#base_suit_clt_process{suit_id = 1,suit_stage = 1,attr = [{7,15}],skill_id = 0};

get_suit_clt_process(1,2) ->
	#base_suit_clt_process{suit_id = 1,suit_stage = 2,attr = [{3,21}],skill_id = 0};

get_suit_clt_process(1,3) ->
	#base_suit_clt_process{suit_id = 1,suit_stage = 3,attr = [{8,27}],skill_id = 0};

get_suit_clt_process(1,4) ->
	#base_suit_clt_process{suit_id = 1,suit_stage = 4,attr = [{4,35}],skill_id = 0};

get_suit_clt_process(1,5) ->
	#base_suit_clt_process{suit_id = 1,suit_stage = 5,attr = [{5,41}],skill_id = 0};

get_suit_clt_process(1,6) ->
	#base_suit_clt_process{suit_id = 1,suit_stage = 6,attr = [{1,48}],skill_id = 0};

get_suit_clt_process(1,7) ->
	#base_suit_clt_process{suit_id = 1,suit_stage = 7,attr = [{6,54}],skill_id = 0};

get_suit_clt_process(1,8) ->
	#base_suit_clt_process{suit_id = 1,suit_stage = 8,attr = [{2,1200}],skill_id = 5400001};

get_suit_clt_process(2,1) ->
	#base_suit_clt_process{suit_id = 2,suit_stage = 1,attr = [{7,23}],skill_id = 0};

get_suit_clt_process(2,2) ->
	#base_suit_clt_process{suit_id = 2,suit_stage = 2,attr = [{3,32}],skill_id = 0};

get_suit_clt_process(2,3) ->
	#base_suit_clt_process{suit_id = 2,suit_stage = 3,attr = [{8,41}],skill_id = 0};

get_suit_clt_process(2,4) ->
	#base_suit_clt_process{suit_id = 2,suit_stage = 4,attr = [{4,53}],skill_id = 0};

get_suit_clt_process(2,5) ->
	#base_suit_clt_process{suit_id = 2,suit_stage = 5,attr = [{5,62}],skill_id = 0};

get_suit_clt_process(2,6) ->
	#base_suit_clt_process{suit_id = 2,suit_stage = 6,attr = [{1,74}],skill_id = 0};

get_suit_clt_process(2,7) ->
	#base_suit_clt_process{suit_id = 2,suit_stage = 7,attr = [{6,83}],skill_id = 0};

get_suit_clt_process(2,8) ->
	#base_suit_clt_process{suit_id = 2,suit_stage = 8,attr = [{2,1840}],skill_id = 5400002};

get_suit_clt_process(3,1) ->
	#base_suit_clt_process{suit_id = 3,suit_stage = 1,attr = [{7,33}],skill_id = 0};

get_suit_clt_process(3,2) ->
	#base_suit_clt_process{suit_id = 3,suit_stage = 2,attr = [{3,46}],skill_id = 0};

get_suit_clt_process(3,3) ->
	#base_suit_clt_process{suit_id = 3,suit_stage = 3,attr = [{8,59}],skill_id = 0};

get_suit_clt_process(3,4) ->
	#base_suit_clt_process{suit_id = 3,suit_stage = 4,attr = [{4,76}],skill_id = 0};

get_suit_clt_process(3,5) ->
	#base_suit_clt_process{suit_id = 3,suit_stage = 5,attr = [{5,89}],skill_id = 0};

get_suit_clt_process(3,6) ->
	#base_suit_clt_process{suit_id = 3,suit_stage = 6,attr = [{1,106}],skill_id = 0};

get_suit_clt_process(3,7) ->
	#base_suit_clt_process{suit_id = 3,suit_stage = 7,attr = [{6,119}],skill_id = 0};

get_suit_clt_process(3,8) ->
	#base_suit_clt_process{suit_id = 3,suit_stage = 8,attr = [{2,2640}],skill_id = 5400003};

get_suit_clt_process(4,1) ->
	#base_suit_clt_process{suit_id = 4,suit_stage = 1,attr = [{7,44}],skill_id = 0};

get_suit_clt_process(4,2) ->
	#base_suit_clt_process{suit_id = 4,suit_stage = 2,attr = [{3,62}],skill_id = 0};

get_suit_clt_process(4,3) ->
	#base_suit_clt_process{suit_id = 4,suit_stage = 3,attr = [{8,79}],skill_id = 0};

get_suit_clt_process(4,4) ->
	#base_suit_clt_process{suit_id = 4,suit_stage = 4,attr = [{4,101}],skill_id = 0};

get_suit_clt_process(4,5) ->
	#base_suit_clt_process{suit_id = 4,suit_stage = 5,attr = [{5,119}],skill_id = 0};

get_suit_clt_process(4,6) ->
	#base_suit_clt_process{suit_id = 4,suit_stage = 6,attr = [{1,141}],skill_id = 0};

get_suit_clt_process(4,7) ->
	#base_suit_clt_process{suit_id = 4,suit_stage = 7,attr = [{6,158}],skill_id = 0};

get_suit_clt_process(4,8) ->
	#base_suit_clt_process{suit_id = 4,suit_stage = 8,attr = [{2,3520}],skill_id = 5400004};

get_suit_clt_process(5,1) ->
	#base_suit_clt_process{suit_id = 5,suit_stage = 1,attr = [{7,46}],skill_id = 0};

get_suit_clt_process(5,2) ->
	#base_suit_clt_process{suit_id = 5,suit_stage = 2,attr = [{3,64}],skill_id = 0};

get_suit_clt_process(5,3) ->
	#base_suit_clt_process{suit_id = 5,suit_stage = 3,attr = [{8,83}],skill_id = 0};

get_suit_clt_process(5,4) ->
	#base_suit_clt_process{suit_id = 5,suit_stage = 4,attr = [{4,106}],skill_id = 0};

get_suit_clt_process(5,5) ->
	#base_suit_clt_process{suit_id = 5,suit_stage = 5,attr = [{5,124}],skill_id = 0};

get_suit_clt_process(5,6) ->
	#base_suit_clt_process{suit_id = 5,suit_stage = 6,attr = [{1,147}],skill_id = 0};

get_suit_clt_process(5,7) ->
	#base_suit_clt_process{suit_id = 5,suit_stage = 7,attr = [{6,166}],skill_id = 0};

get_suit_clt_process(5,8) ->
	#base_suit_clt_process{suit_id = 5,suit_stage = 8,attr = [{2,3680}],skill_id = 5400005};

get_suit_clt_process(6,1) ->
	#base_suit_clt_process{suit_id = 6,suit_stage = 1,attr = [{7,60}],skill_id = 0};

get_suit_clt_process(6,2) ->
	#base_suit_clt_process{suit_id = 6,suit_stage = 2,attr = [{3,84}],skill_id = 0};

get_suit_clt_process(6,3) ->
	#base_suit_clt_process{suit_id = 6,suit_stage = 3,attr = [{8,108}],skill_id = 0};

get_suit_clt_process(6,4) ->
	#base_suit_clt_process{suit_id = 6,suit_stage = 4,attr = [{4,138}],skill_id = 0};

get_suit_clt_process(6,5) ->
	#base_suit_clt_process{suit_id = 6,suit_stage = 5,attr = [{5,162}],skill_id = 0};

get_suit_clt_process(6,6) ->
	#base_suit_clt_process{suit_id = 6,suit_stage = 6,attr = [{1,192}],skill_id = 0};

get_suit_clt_process(6,7) ->
	#base_suit_clt_process{suit_id = 6,suit_stage = 7,attr = [{6,216}],skill_id = 0};

get_suit_clt_process(6,8) ->
	#base_suit_clt_process{suit_id = 6,suit_stage = 8,attr = [{2,4800}],skill_id = 5400006};

get_suit_clt_process(7,1) ->
	#base_suit_clt_process{suit_id = 7,suit_stage = 1,attr = [{7,125}],skill_id = 0};

get_suit_clt_process(7,2) ->
	#base_suit_clt_process{suit_id = 7,suit_stage = 2,attr = [{3,175}],skill_id = 0};

get_suit_clt_process(7,3) ->
	#base_suit_clt_process{suit_id = 7,suit_stage = 3,attr = [{8,225}],skill_id = 0};

get_suit_clt_process(7,4) ->
	#base_suit_clt_process{suit_id = 7,suit_stage = 4,attr = [{4,288}],skill_id = 0};

get_suit_clt_process(7,5) ->
	#base_suit_clt_process{suit_id = 7,suit_stage = 5,attr = [{5,338}],skill_id = 0};

get_suit_clt_process(7,6) ->
	#base_suit_clt_process{suit_id = 7,suit_stage = 6,attr = [{1,400}],skill_id = 0};

get_suit_clt_process(7,7) ->
	#base_suit_clt_process{suit_id = 7,suit_stage = 7,attr = [{6,450}],skill_id = 0};

get_suit_clt_process(7,8) ->
	#base_suit_clt_process{suit_id = 7,suit_stage = 8,attr = [{2,10000}],skill_id = 5400007};

get_suit_clt_process(8,2) ->
	#base_suit_clt_process{suit_id = 8,suit_stage = 2,attr = [{3,203}],skill_id = 0};

get_suit_clt_process(8,4) ->
	#base_suit_clt_process{suit_id = 8,suit_stage = 4,attr = [{4,270}],skill_id = 0};

get_suit_clt_process(8,6) ->
	#base_suit_clt_process{suit_id = 8,suit_stage = 6,attr = [{1,405}],skill_id = 0};

get_suit_clt_process(8,8) ->
	#base_suit_clt_process{suit_id = 8,suit_stage = 8,attr = [{2,9450}],skill_id = 5400008};

get_suit_clt_process(9,2) ->
	#base_suit_clt_process{suit_id = 9,suit_stage = 2,attr = [{3,638}],skill_id = 0};

get_suit_clt_process(9,4) ->
	#base_suit_clt_process{suit_id = 9,suit_stage = 4,attr = [{4,850}],skill_id = 0};

get_suit_clt_process(9,6) ->
	#base_suit_clt_process{suit_id = 9,suit_stage = 6,attr = [{1,1275}],skill_id = 0};

get_suit_clt_process(9,8) ->
	#base_suit_clt_process{suit_id = 9,suit_stage = 8,attr = [{2,29750}],skill_id = 5400009};

get_suit_clt_process(10,2) ->
	#base_suit_clt_process{suit_id = 10,suit_stage = 2,attr = [{3,1170}],skill_id = 0};

get_suit_clt_process(10,4) ->
	#base_suit_clt_process{suit_id = 10,suit_stage = 4,attr = [{4,1560}],skill_id = 0};

get_suit_clt_process(10,6) ->
	#base_suit_clt_process{suit_id = 10,suit_stage = 6,attr = [{1,2340}],skill_id = 0};

get_suit_clt_process(10,8) ->
	#base_suit_clt_process{suit_id = 10,suit_stage = 8,attr = [{2,54600}],skill_id = 5400010};

get_suit_clt_process(11,2) ->
	#base_suit_clt_process{suit_id = 11,suit_stage = 2,attr = [{3,2160}],skill_id = 0};

get_suit_clt_process(11,4) ->
	#base_suit_clt_process{suit_id = 11,suit_stage = 4,attr = [{4,2880}],skill_id = 0};

get_suit_clt_process(11,6) ->
	#base_suit_clt_process{suit_id = 11,suit_stage = 6,attr = [{1,4320}],skill_id = 0};

get_suit_clt_process(11,8) ->
	#base_suit_clt_process{suit_id = 11,suit_stage = 8,attr = [{2,100800}],skill_id = 5400011};

get_suit_clt_process(12,2) ->
	#base_suit_clt_process{suit_id = 12,suit_stage = 2,attr = [{3,4320}],skill_id = 0};

get_suit_clt_process(12,4) ->
	#base_suit_clt_process{suit_id = 12,suit_stage = 4,attr = [{4,5760}],skill_id = 0};

get_suit_clt_process(12,6) ->
	#base_suit_clt_process{suit_id = 12,suit_stage = 6,attr = [{1,8640}],skill_id = 0};

get_suit_clt_process(12,8) ->
	#base_suit_clt_process{suit_id = 12,suit_stage = 8,attr = [{2,201600}],skill_id = 5400012};

get_suit_clt_process(13,2) ->
	#base_suit_clt_process{suit_id = 13,suit_stage = 2,attr = [{3,7200}],skill_id = 0};

get_suit_clt_process(13,4) ->
	#base_suit_clt_process{suit_id = 13,suit_stage = 4,attr = [{4,9600}],skill_id = 0};

get_suit_clt_process(13,6) ->
	#base_suit_clt_process{suit_id = 13,suit_stage = 6,attr = [{1,14400}],skill_id = 0};

get_suit_clt_process(13,8) ->
	#base_suit_clt_process{suit_id = 13,suit_stage = 8,attr = [{2,336000}],skill_id = 5400013};

get_suit_clt_process(14,2) ->
	#base_suit_clt_process{suit_id = 14,suit_stage = 2,attr = [{3,8100}],skill_id = 0};

get_suit_clt_process(14,4) ->
	#base_suit_clt_process{suit_id = 14,suit_stage = 4,attr = [{4,10800}],skill_id = 0};

get_suit_clt_process(14,6) ->
	#base_suit_clt_process{suit_id = 14,suit_stage = 6,attr = [{1,16200}],skill_id = 0};

get_suit_clt_process(14,8) ->
	#base_suit_clt_process{suit_id = 14,suit_stage = 8,attr = [{2,378000}],skill_id = 5400014};

get_suit_clt_process(15,2) ->
	#base_suit_clt_process{suit_id = 15,suit_stage = 2,attr = [{3,9000}],skill_id = 0};

get_suit_clt_process(15,4) ->
	#base_suit_clt_process{suit_id = 15,suit_stage = 4,attr = [{4,12000}],skill_id = 0};

get_suit_clt_process(15,6) ->
	#base_suit_clt_process{suit_id = 15,suit_stage = 6,attr = [{1,18000}],skill_id = 0};

get_suit_clt_process(15,8) ->
	#base_suit_clt_process{suit_id = 15,suit_stage = 8,attr = [{2,420000}],skill_id = 5400015};

get_suit_clt_process(16,2) ->
	#base_suit_clt_process{suit_id = 16,suit_stage = 2,attr = [{3,9900}],skill_id = 0};

get_suit_clt_process(16,4) ->
	#base_suit_clt_process{suit_id = 16,suit_stage = 4,attr = [{4,13200}],skill_id = 0};

get_suit_clt_process(16,6) ->
	#base_suit_clt_process{suit_id = 16,suit_stage = 6,attr = [{1,19800}],skill_id = 0};

get_suit_clt_process(16,8) ->
	#base_suit_clt_process{suit_id = 16,suit_stage = 8,attr = [{2,462000}],skill_id = 5400016};

get_suit_clt_process(17,2) ->
	#base_suit_clt_process{suit_id = 17,suit_stage = 2,attr = [{3,10800}],skill_id = 0};

get_suit_clt_process(17,4) ->
	#base_suit_clt_process{suit_id = 17,suit_stage = 4,attr = [{4,14400}],skill_id = 0};

get_suit_clt_process(17,6) ->
	#base_suit_clt_process{suit_id = 17,suit_stage = 6,attr = [{1,21600}],skill_id = 0};

get_suit_clt_process(17,8) ->
	#base_suit_clt_process{suit_id = 17,suit_stage = 8,attr = [{2,504000}],skill_id = 5400017};

get_suit_clt_process(18,2) ->
	#base_suit_clt_process{suit_id = 18,suit_stage = 2,attr = [{3,11700}],skill_id = 0};

get_suit_clt_process(18,4) ->
	#base_suit_clt_process{suit_id = 18,suit_stage = 4,attr = [{4,15600}],skill_id = 0};

get_suit_clt_process(18,6) ->
	#base_suit_clt_process{suit_id = 18,suit_stage = 6,attr = [{1,23400}],skill_id = 0};

get_suit_clt_process(18,8) ->
	#base_suit_clt_process{suit_id = 18,suit_stage = 8,attr = [{2,546000}],skill_id = 5400018};

get_suit_clt_process(19,2) ->
	#base_suit_clt_process{suit_id = 19,suit_stage = 2,attr = [{3,12600}],skill_id = 0};

get_suit_clt_process(19,4) ->
	#base_suit_clt_process{suit_id = 19,suit_stage = 4,attr = [{4,16800}],skill_id = 0};

get_suit_clt_process(19,6) ->
	#base_suit_clt_process{suit_id = 19,suit_stage = 6,attr = [{1,25200}],skill_id = 0};

get_suit_clt_process(19,8) ->
	#base_suit_clt_process{suit_id = 19,suit_stage = 8,attr = [{2,588000}],skill_id = 5400019};

get_suit_clt_process(20,2) ->
	#base_suit_clt_process{suit_id = 20,suit_stage = 2,attr = [{3,13500}],skill_id = 0};

get_suit_clt_process(20,4) ->
	#base_suit_clt_process{suit_id = 20,suit_stage = 4,attr = [{4,18000}],skill_id = 0};

get_suit_clt_process(20,6) ->
	#base_suit_clt_process{suit_id = 20,suit_stage = 6,attr = [{1,27000}],skill_id = 0};

get_suit_clt_process(20,8) ->
	#base_suit_clt_process{suit_id = 20,suit_stage = 8,attr = [{2,630000}],skill_id = 5400020};

get_suit_clt_process(_Suitid,_Suitstage) ->
	[].


get_stage_list(1) ->
[1,2,3,4,5,6,7,8];


get_stage_list(2) ->
[1,2,3,4,5,6,7,8];


get_stage_list(3) ->
[1,2,3,4,5,6,7,8];


get_stage_list(4) ->
[1,2,3,4,5,6,7,8];


get_stage_list(5) ->
[1,2,3,4,5,6,7,8];


get_stage_list(6) ->
[1,2,3,4,5,6,7,8];


get_stage_list(7) ->
[1,2,3,4,5,6,7,8];


get_stage_list(8) ->
[2,4,6,8];


get_stage_list(9) ->
[2,4,6,8];


get_stage_list(10) ->
[2,4,6,8];


get_stage_list(11) ->
[2,4,6,8];


get_stage_list(12) ->
[2,4,6,8];


get_stage_list(13) ->
[2,4,6,8];


get_stage_list(14) ->
[2,4,6,8];


get_stage_list(15) ->
[2,4,6,8];


get_stage_list(16) ->
[2,4,6,8];


get_stage_list(17) ->
[2,4,6,8];


get_stage_list(18) ->
[2,4,6,8];


get_stage_list(19) ->
[2,4,6,8];


get_stage_list(20) ->
[2,4,6,8];

get_stage_list(_Suitid) ->
	[].

get_suit_clt_task(1,1) ->
	#base_suit_clt_task{suit_id = 1,pos = 1,task_id = 100310,desc = "26级主线"};

get_suit_clt_task(1,2) ->
	#base_suit_clt_task{suit_id = 1,pos = 2,task_id = 100650,desc = "51级主线"};

get_suit_clt_task(1,3) ->
	#base_suit_clt_task{suit_id = 1,pos = 3,task_id = 100350,desc = "30级主线"};

get_suit_clt_task(1,4) ->
	#base_suit_clt_task{suit_id = 1,pos = 4,task_id = 100480,desc = "40级主线"};

get_suit_clt_task(1,5) ->
	#base_suit_clt_task{suit_id = 1,pos = 5,task_id = 100670,desc = "52级主线"};

get_suit_clt_task(1,6) ->
	#base_suit_clt_task{suit_id = 1,pos = 6,task_id = 100570,desc = "48级主线"};

get_suit_clt_task(1,8) ->
	#base_suit_clt_task{suit_id = 1,pos = 8,task_id = 100300,desc = "25级主线"};

get_suit_clt_task(1,10) ->
	#base_suit_clt_task{suit_id = 1,pos = 10,task_id = 100370,desc = "31级主线"};

get_suit_clt_task(2,1) ->
	#base_suit_clt_task{suit_id = 2,pos = 1,task_id = 100760,desc = "56级主线"};

get_suit_clt_task(2,2) ->
	#base_suit_clt_task{suit_id = 2,pos = 2,task_id = 101110,desc = "76级主线"};

get_suit_clt_task(2,3) ->
	#base_suit_clt_task{suit_id = 2,pos = 3,task_id = 100730,desc = "55级主线"};

get_suit_clt_task(2,4) ->
	#base_suit_clt_task{suit_id = 2,pos = 4,task_id = 101020,desc = "72级主线"};

get_suit_clt_task(2,5) ->
	#base_suit_clt_task{suit_id = 2,pos = 5,task_id = 101030,desc = "73级主线"};

get_suit_clt_task(2,6) ->
	#base_suit_clt_task{suit_id = 2,pos = 6,task_id = 100810,desc = "59级主线"};

get_suit_clt_task(2,8) ->
	#base_suit_clt_task{suit_id = 2,pos = 8,task_id = 100710,desc = "54级主线"};

get_suit_clt_task(_Suitid,_Pos) ->
	[].

