%%%---------------------------------------
%%% module      : data_temple_awaken
%%% description : 神殿觉醒配置
%%%
%%%---------------------------------------
-module(data_temple_awaken).
-compile(export_all).
-include("temple_awaken.hrl").



get_temple_awaken(1001) ->
	#base_temple_awaken{chapter_id = 1001,chapter_name = <<"封印千术"/utf8>>,condition = [{lv,48}],attr = [{1,300},{2,6000},{3,150},{4,150}],pos_type = 11};

get_temple_awaken(1002) ->
	#base_temple_awaken{chapter_id = 1002,chapter_name = <<"菖蒲绣锦"/utf8>>,condition = [{lv,160}],attr = [{1,500},{2,10000},{3,250},{4,250}],pos_type = 4};

get_temple_awaken(1003) ->
	#base_temple_awaken{chapter_id = 1003,chapter_name = <<"千草琉璃"/utf8>>,condition = [{lv,250}],attr = [{1,1000},{2,20000},{3,500},{4,500}],pos_type = 3};

get_temple_awaken(1004) ->
	#base_temple_awaken{chapter_id = 1004,chapter_name = <<"兵破生锥"/utf8>>,condition = [{lv,330}],attr = [{1,2000},{2,40000},{3,1000},{4,1000}],pos_type = 5};

get_temple_awaken(1005) ->
	#base_temple_awaken{chapter_id = 1005,chapter_name = <<"彩羽灵鹫"/utf8>>,condition = [{lv,410}],attr = [{1,2500},{2,50000},{3,1250},{4,1250}],pos_type = 1};

get_temple_awaken(_Chapterid) ->
	[].

list_chapter_id() ->
[1001,1002,1003,1004,1005].

get_temple_awaken_stage(1001,1,1) ->
	#base_temple_awaken_stage{chapter_id = 1001,sub_chapter = 1,stage = 1,open_con = [{lv,48}],complete_con = [{lv,48}],reward = [{3,0,200000},{2,0,10}]};

get_temple_awaken_stage(1001,1,2) ->
	#base_temple_awaken_stage{chapter_id = 1001,sub_chapter = 1,stage = 2,open_con = [{lv,48}],complete_con = [{finish_task,100660}],reward = [{0,18020001,2},{2,0,10}]};

get_temple_awaken_stage(1001,1,3) ->
	#base_temple_awaken_stage{chapter_id = 1001,sub_chapter = 1,stage = 3,open_con = [{lv,48}],complete_con = [{lv,65}],reward = [{0,16020001,1},{2,0,10}]};

get_temple_awaken_stage(1001,1,4) ->
	#base_temple_awaken_stage{chapter_id = 1001,sub_chapter = 1,stage = 4,open_con = [{lv,48}],complete_con = [{finish_task,100970}],reward = [{0,32010322,1},{2,0,10}]};

get_temple_awaken_stage(1001,1,5) ->
	#base_temple_awaken_stage{chapter_id = 1001,sub_chapter = 1,stage = 5,open_con = [{lv,48}],complete_con = [{finish_task,101160}],reward = [{0,37020001,1},{2,0,10}]};

get_temple_awaken_stage(1001,2,1) ->
	#base_temple_awaken_stage{chapter_id = 1001,sub_chapter = 2,stage = 1,open_con = [{lv,100}],complete_con = [{finish_task,101200}],reward = [{0,14020001,1},{2,0,10}]};

get_temple_awaken_stage(1001,2,2) ->
	#base_temple_awaken_stage{chapter_id = 1001,sub_chapter = 2,stage = 2,open_con = [{lv,100}],complete_con = [{finish_task,101270}],reward = [{0,14010001,1},{2,0,10}]};

get_temple_awaken_stage(1001,2,3) ->
	#base_temple_awaken_stage{chapter_id = 1001,sub_chapter = 2,stage = 3,open_con = [{lv,100}],complete_con = [{finish_task,101460}],reward = [{255,41,1000},{2,0,10}]};

get_temple_awaken_stage(1001,2,4) ->
	#base_temple_awaken_stage{chapter_id = 1001,sub_chapter = 2,stage = 4,open_con = [{lv,100}],complete_con = [{mount,2,1,3}],reward = [{0,17020001,2},{2,0,10}]};

get_temple_awaken_stage(1001,2,5) ->
	#base_temple_awaken_stage{chapter_id = 1001,sub_chapter = 2,stage = 5,open_con = [{lv,100}],complete_con = [{rune_dun,8}],reward = [{0,32010322,1},{2,0,10}]};

get_temple_awaken_stage(1001,3,1) ->
	#base_temple_awaken_stage{chapter_id = 1001,sub_chapter = 3,stage = 1,open_con = [{lv,135}],complete_con = [{boss_lv,12,130,1}],reward = [{0,14020001,1},{2,0,10}]};

get_temple_awaken_stage(1001,3,2) ->
	#base_temple_awaken_stage{chapter_id = 1001,sub_chapter = 3,stage = 2,open_con = [{lv,135}],complete_con = [{dun_id,5002,1}],reward = [{0,14010001,1},{2,0,10}]};

get_temple_awaken_stage(1001,3,3) ->
	#base_temple_awaken_stage{chapter_id = 1001,sub_chapter = 3,stage = 3,open_con = [{lv,135}],complete_con = [{turn,1}],reward = [{0,14010002,1},{2,0,10}]};

get_temple_awaken_stage(1001,3,4) ->
	#base_temple_awaken_stage{chapter_id = 1001,sub_chapter = 3,stage = 4,open_con = [{lv,135}],complete_con = [{active_lv,9}],reward = [{0,56020001,1},{2,0,10}]};

get_temple_awaken_stage(1001,3,5) ->
	#base_temple_awaken_stage{chapter_id = 1001,sub_chapter = 3,stage = 5,open_con = [{lv,135}],complete_con = [{dun_id,31002,1}],reward = [{0,56020002,1},{2,0,10}]};

get_temple_awaken_stage(1002,1,1) ->
	#base_temple_awaken_stage{chapter_id = 1002,sub_chapter = 1,stage = 1,open_con = [{lv,160}],complete_con = [{mount,1,2,5}],reward = [{0,18020001,2},{2,0,10}]};

get_temple_awaken_stage(1002,1,2) ->
	#base_temple_awaken_stage{chapter_id = 1002,sub_chapter = 1,stage = 2,open_con = [{lv,160}],complete_con = [{mount,2,2,5}],reward = [{0,16020001,2},{2,0,10}]};

get_temple_awaken_stage(1002,1,3) ->
	#base_temple_awaken_stage{chapter_id = 1002,sub_chapter = 1,stage = 3,open_con = [{lv,160}],complete_con = [{rune_dun,20}],reward = [{0,32010322,1},{2,0,10}]};

get_temple_awaken_stage(1002,1,4) ->
	#base_temple_awaken_stage{chapter_id = 1002,sub_chapter = 1,stage = 4,open_con = [{lv,160}],complete_con = [{strength_sum_lv,200}],reward = [{3,0,200000},{2,0,10}]};

get_temple_awaken_stage(1002,1,5) ->
	#base_temple_awaken_stage{chapter_id = 1002,sub_chapter = 1,stage = 5,open_con = [{lv,160}],complete_con = [{equip_status,1,5,1,3}],reward = [{0,56020001,1},{2,0,10}]};

get_temple_awaken_stage(1002,2,1) ->
	#base_temple_awaken_stage{chapter_id = 1002,sub_chapter = 2,stage = 1,open_con = [{lv,190}],complete_con = [{medal_lv,20}],reward = [{0,38040044,1},{2,0,10}]};

get_temple_awaken_stage(1002,2,2) ->
	#base_temple_awaken_stage{chapter_id = 1002,sub_chapter = 2,stage = 2,open_con = [{lv,190}],complete_con = [{dun_id,5003,1}],reward = [{0,14010001,1},{2,0,10}]};

get_temple_awaken_stage(1002,2,3) ->
	#base_temple_awaken_stage{chapter_id = 1002,sub_chapter = 2,stage = 3,open_con = [{lv,190}],complete_con = [{boss_lv,12,190,1}],reward = [{0,14020001,1},{2,0,10}]};

get_temple_awaken_stage(1002,2,4) ->
	#base_temple_awaken_stage{chapter_id = 1002,sub_chapter = 2,stage = 4,open_con = [{lv,190}],complete_con = [{equip_status,1,5,1,5}],reward = [{0,56020001,1},{2,0,10}]};

get_temple_awaken_stage(1002,2,5) ->
	#base_temple_awaken_stage{chapter_id = 1002,sub_chapter = 2,stage = 5,open_con = [{lv,190}],complete_con = [{turn,2}],reward = [{0,56020002,1},{2,0,10}]};

get_temple_awaken_stage(1002,3,1) ->
	#base_temple_awaken_stage{chapter_id = 1002,sub_chapter = 3,stage = 1,open_con = [{lv,230}],complete_con = [{boss_type,99,1}],reward = [{0,6101001,1},{2,0,10}]};

get_temple_awaken_stage(1002,3,2) ->
	#base_temple_awaken_stage{chapter_id = 1002,sub_chapter = 3,stage = 2,open_con = [{lv,230}],complete_con = [{boss_lv,12,235,1}],reward = [{0,14020001,1},{2,0,10}]};

get_temple_awaken_stage(1002,3,3) ->
	#base_temple_awaken_stage{chapter_id = 1002,sub_chapter = 3,stage = 3,open_con = [{lv,230}],complete_con = [{enter_mh,1}],reward = [{3,0,200000},{2,0,10}]};

get_temple_awaken_stage(1002,3,4) ->
	#base_temple_awaken_stage{chapter_id = 1002,sub_chapter = 3,stage = 4,open_con = [{lv,230}],complete_con = [{compose_equip,6,5,2,1}],reward = [{0,56020002,1},{2,0,10}]};

get_temple_awaken_stage(1002,3,5) ->
	#base_temple_awaken_stage{chapter_id = 1002,sub_chapter = 3,stage = 5,open_con = [{lv,230}],complete_con = [{combat,1800000}],reward = [{0,14010001,1},{2,0,10}]};

get_temple_awaken_stage(1003,1,1) ->
	#base_temple_awaken_stage{chapter_id = 1003,sub_chapter = 1,stage = 1,open_con = [{lv,250}],complete_con = [{dun_id,5004,1}],reward = [{0,38040005,20},{2,0,20}]};

get_temple_awaken_stage(1003,1,2) ->
	#base_temple_awaken_stage{chapter_id = 1003,sub_chapter = 1,stage = 2,open_con = [{lv,250}],complete_con = [{seal_status,4,1,4}],reward = [{0,6101002,1},{2,0,20}]};

get_temple_awaken_stage(1003,1,3) ->
	#base_temple_awaken_stage{chapter_id = 1003,sub_chapter = 1,stage = 3,open_con = [{lv,250}],complete_con = [{wash_status,2,1}],reward = [{0,38040005,20},{2,0,20}]};

get_temple_awaken_stage(1003,1,4) ->
	#base_temple_awaken_stage{chapter_id = 1003,sub_chapter = 1,stage = 4,open_con = [{lv,250}],complete_con = [{suit,1,2,4}],reward = [{100,32010056,1},{2,0,20}]};

get_temple_awaken_stage(1003,1,5) ->
	#base_temple_awaken_stage{chapter_id = 1003,sub_chapter = 1,stage = 5,open_con = [{lv,250}],complete_con = [{dun_id,18003,1}],reward = [{0,17020001,2},{2,0,20}]};

get_temple_awaken_stage(1003,2,1) ->
	#base_temple_awaken_stage{chapter_id = 1003,sub_chapter = 2,stage = 1,open_con = [{lv,280}],complete_con = [{active_companion,2}],reward = [{0,22020001,30},{2,0,20}]};

get_temple_awaken_stage(1003,2,2) ->
	#base_temple_awaken_stage{chapter_id = 1003,sub_chapter = 2,stage = 2,open_con = [{lv,280}],complete_con = [{active_lv,25}],reward = [{3,0,200000},{2,0,20}]};

get_temple_awaken_stage(1003,2,3) ->
	#base_temple_awaken_stage{chapter_id = 1003,sub_chapter = 2,stage = 3,open_con = [{lv,280}],complete_con = [{mount,2,3,8}],reward = [{0,17020001,2},{2,0,20}]};

get_temple_awaken_stage(1003,2,4) ->
	#base_temple_awaken_stage{chapter_id = 1003,sub_chapter = 2,stage = 4,open_con = [{lv,280}],complete_con = [{lv_day,5,290}],reward = [{0,38040030,2},{2,0,20}]};

get_temple_awaken_stage(1003,2,5) ->
	#base_temple_awaken_stage{chapter_id = 1003,sub_chapter = 2,stage = 5,open_con = [{lv,280}],complete_con = [{medal_lv,30}],reward = [{0,38040044,1},{2,0,20}]};

get_temple_awaken_stage(1003,3,1) ->
	#base_temple_awaken_stage{chapter_id = 1003,sub_chapter = 3,stage = 1,open_con = [{lv,300}],complete_con = [{seal_status,4,7,4}],reward = [{0,6101002,1},{2,0,20}]};

get_temple_awaken_stage(1003,3,2) ->
	#base_temple_awaken_stage{chapter_id = 1003,sub_chapter = 3,stage = 2,open_con = [{lv,300}],complete_con = [{wash_sum_lv,14}],reward = [{0,38040005,40},{2,0,20}]};

get_temple_awaken_stage(1003,3,3) ->
	#base_temple_awaken_stage{chapter_id = 1003,sub_chapter = 3,stage = 3,open_con = [{lv,300}],complete_con = [{combat,5500000}],reward = [{0,14010002,1},{2,0,20}]};

get_temple_awaken_stage(1003,3,4) ->
	#base_temple_awaken_stage{chapter_id = 1003,sub_chapter = 3,stage = 4,open_con = [{lv,300}],complete_con = [{suit,2,1,6}],reward = [{100,32010056,2},{2,0,20}]};

get_temple_awaken_stage(1003,3,5) ->
	#base_temple_awaken_stage{chapter_id = 1003,sub_chapter = 3,stage = 5,open_con = [{lv,300}],complete_con = [{equip_status,8,5,2,6}],reward = [{0,14010002,1},{2,0,20}]};

get_temple_awaken_stage(1004,1,1) ->
	#base_temple_awaken_stage{chapter_id = 1004,sub_chapter = 1,stage = 1,open_con = [{lv,330}],complete_con = [{enter_dun,32003,1}],reward = [{0,38040030,2},{2,0,20}]};

get_temple_awaken_stage(1004,1,2) ->
	#base_temple_awaken_stage{chapter_id = 1004,sub_chapter = 1,stage = 2,open_con = [{lv,330}],complete_con = [{active_companion,3}],reward = [{0,22020001,30},{2,0,20}]};

get_temple_awaken_stage(1004,1,3) ->
	#base_temple_awaken_stage{chapter_id = 1004,sub_chapter = 1,stage = 3,open_con = [{lv,330}],complete_con = [{active_eudemon,6}],reward = [{0,39510000,3},{2,0,20}]};

get_temple_awaken_stage(1004,1,4) ->
	#base_temple_awaken_stage{chapter_id = 1004,sub_chapter = 1,stage = 4,open_con = [{lv,330}],complete_con = [{seal_status,4,9,4}],reward = [{0,6101002,2},{2,0,20}]};

get_temple_awaken_stage(1004,1,5) ->
	#base_temple_awaken_stage{chapter_id = 1004,sub_chapter = 1,stage = 5,open_con = [{lv,330}],complete_con = [{strength_sum_lv,620}],reward = [{3,0,500000},{2,0,20}]};

get_temple_awaken_stage(1004,2,1) ->
	#base_temple_awaken_stage{chapter_id = 1004,sub_chapter = 2,stage = 1,open_con = [{lv,360}],complete_con = [{turn,4}],reward = [{0,56020001,1},{2,0,20}]};

get_temple_awaken_stage(1004,2,2) ->
	#base_temple_awaken_stage{chapter_id = 1004,sub_chapter = 2,stage = 2,open_con = [{lv,360}],complete_con = [{active_companion,4}],reward = [{0,22020001,30},{2,0,20}]};

get_temple_awaken_stage(1004,2,3) ->
	#base_temple_awaken_stage{chapter_id = 1004,sub_chapter = 2,stage = 3,open_con = [{lv,360}],complete_con = [{suit,3,1,2}],reward = [{100,38240201,1},{2,0,20}]};

get_temple_awaken_stage(1004,2,4) ->
	#base_temple_awaken_stage{chapter_id = 1004,sub_chapter = 2,stage = 4,open_con = [{lv,360}],complete_con = [{active_eudemon,10}],reward = [{0,39510000,3},{2,0,20}]};

get_temple_awaken_stage(1004,2,5) ->
	#base_temple_awaken_stage{chapter_id = 1004,sub_chapter = 2,stage = 5,open_con = [{lv,360}],complete_con = [{mount,1,4,1}],reward = [{0,16020002,1},{2,0,20}]};

get_temple_awaken_stage(1004,3,1) ->
	#base_temple_awaken_stage{chapter_id = 1004,sub_chapter = 3,stage = 1,open_con = [{lv,380}],complete_con = [{mount,2,5,1}],reward = [{0,17020002,1},{2,0,20}]};

get_temple_awaken_stage(1004,3,2) ->
	#base_temple_awaken_stage{chapter_id = 1004,sub_chapter = 3,stage = 2,open_con = [{lv,380}],complete_con = [{baby_lv,40}],reward = [{0,38040041,2},{2,0,20}]};

get_temple_awaken_stage(1004,3,3) ->
	#base_temple_awaken_stage{chapter_id = 1004,sub_chapter = 3,stage = 3,open_con = [{lv,380}],complete_con = [{active_god,3002}],reward = [{0,7110001,5},{2,0,20}]};

get_temple_awaken_stage(1004,3,4) ->
	#base_temple_awaken_stage{chapter_id = 1004,sub_chapter = 3,stage = 4,open_con = [{lv,380}],complete_con = [{strength_sum_lv,850}],reward = [{3,0,500000},{2,0,20}]};

get_temple_awaken_stage(1004,3,5) ->
	#base_temple_awaken_stage{chapter_id = 1004,sub_chapter = 3,stage = 5,open_con = [{lv,380}],complete_con = [{decoration_rate,450000}],reward = [{0,38040018,20},{2,0,20}]};

get_temple_awaken_stage(1005,1,1) ->
	#base_temple_awaken_stage{chapter_id = 1005,sub_chapter = 1,stage = 1,open_con = [{lv,410}],complete_con = [{enter_dun,32004,1}],reward = [{0,38040030,2},{2,0,20}]};

get_temple_awaken_stage(1005,1,2) ->
	#base_temple_awaken_stage{chapter_id = 1005,sub_chapter = 1,stage = 2,open_con = [{lv,410}],complete_con = [{active_companion,5}],reward = [{0,22020001,30},{2,0,20}]};

get_temple_awaken_stage(1005,1,3) ->
	#base_temple_awaken_stage{chapter_id = 1005,sub_chapter = 1,stage = 3,open_con = [{lv,410}],complete_con = [{seal_status,4,11,4}],reward = [{0,6101003,1},{2,0,20}]};

get_temple_awaken_stage(1005,1,4) ->
	#base_temple_awaken_stage{chapter_id = 1005,sub_chapter = 1,stage = 4,open_con = [{lv,410}],complete_con = [{baby_lv,60}],reward = [{0,38040041,2},{2,0,20}]};

get_temple_awaken_stage(1005,1,5) ->
	#base_temple_awaken_stage{chapter_id = 1005,sub_chapter = 1,stage = 5,open_con = [{lv,410}],complete_con = [{decoration_rate,700000}],reward = [{0,38040018,20},{2,0,20}]};

get_temple_awaken_stage(1005,2,1) ->
	#base_temple_awaken_stage{chapter_id = 1005,sub_chapter = 2,stage = 1,open_con = [{lv,430}],complete_con = [{mount,2,5,6}],reward = [{0,16020002,1},{2,0,20}]};

get_temple_awaken_stage(1005,2,2) ->
	#base_temple_awaken_stage{chapter_id = 1005,sub_chapter = 2,stage = 2,open_con = [{lv,430}],complete_con = [{baby_lv,70}],reward = [{0,38040041,2},{2,0,20}]};

get_temple_awaken_stage(1005,2,3) ->
	#base_temple_awaken_stage{chapter_id = 1005,sub_chapter = 2,stage = 3,open_con = [{lv,430}],complete_con = [{active_eudemon,16}],reward = [{0,39510000,3},{2,0,20}]};

get_temple_awaken_stage(1005,2,4) ->
	#base_temple_awaken_stage{chapter_id = 1005,sub_chapter = 2,stage = 4,open_con = [{lv,430}],complete_con = [{decoration_rate,1000000}],reward = [{0,39510000,3},{2,0,20}]};

get_temple_awaken_stage(1005,2,5) ->
	#base_temple_awaken_stage{chapter_id = 1005,sub_chapter = 2,stage = 5,open_con = [{lv,430}],complete_con = [{seal_status,5,11,6}],reward = [{0,6101003,1},{2,0,20}]};

get_temple_awaken_stage(1005,3,1) ->
	#base_temple_awaken_stage{chapter_id = 1005,sub_chapter = 3,stage = 1,open_con = [{lv,460}],complete_con = [{active_eudemon,17}],reward = [{0,39510000,5},{2,0,20}]};

get_temple_awaken_stage(1005,3,2) ->
	#base_temple_awaken_stage{chapter_id = 1005,sub_chapter = 3,stage = 2,open_con = [{lv,460}],complete_con = [{god_status,3001,2}],reward = [{0,7110001,5},{2,0,20}]};

get_temple_awaken_stage(1005,3,3) ->
	#base_temple_awaken_stage{chapter_id = 1005,sub_chapter = 3,stage = 3,open_con = [{lv,460}],complete_con = [{god_status,3002,2}],reward = [{0,7110001,5},{2,0,20}]};

get_temple_awaken_stage(1005,3,4) ->
	#base_temple_awaken_stage{chapter_id = 1005,sub_chapter = 3,stage = 4,open_con = [{lv,460}],complete_con = [{mount,2,6,1}],reward = [{0,16020002,1},{2,0,20}]};

get_temple_awaken_stage(1005,3,5) ->
	#base_temple_awaken_stage{chapter_id = 1005,sub_chapter = 3,stage = 5,open_con = [{lv,460}],complete_con = [{strength_sum_lv,1300}],reward = [{3,0,500000},{2,0,20}]};

get_temple_awaken_stage(_Chapterid,_Subchapter,_Stage) ->
	[].


list_sub_chapter(1001) ->
[1,2,3];


list_sub_chapter(1002) ->
[1,2,3];


list_sub_chapter(1003) ->
[1,2,3];


list_sub_chapter(1004) ->
[1,2,3];


list_sub_chapter(1005) ->
[1,2,3];

list_sub_chapter(_Chapterid) ->
	[].

list_sub_chapter_stage(1001,1) ->
[1,2,3,4,5];

list_sub_chapter_stage(1001,2) ->
[1,2,3,4,5];

list_sub_chapter_stage(1001,3) ->
[1,2,3,4,5];

list_sub_chapter_stage(1002,1) ->
[1,2,3,4,5];

list_sub_chapter_stage(1002,2) ->
[1,2,3,4,5];

list_sub_chapter_stage(1002,3) ->
[1,2,3,4,5];

list_sub_chapter_stage(1003,1) ->
[1,2,3,4,5];

list_sub_chapter_stage(1003,2) ->
[1,2,3,4,5];

list_sub_chapter_stage(1003,3) ->
[1,2,3,4,5];

list_sub_chapter_stage(1004,1) ->
[1,2,3,4,5];

list_sub_chapter_stage(1004,2) ->
[1,2,3,4,5];

list_sub_chapter_stage(1004,3) ->
[1,2,3,4,5];

list_sub_chapter_stage(1005,1) ->
[1,2,3,4,5];

list_sub_chapter_stage(1005,2) ->
[1,2,3,4,5];

list_sub_chapter_stage(1005,3) ->
[1,2,3,4,5];

list_sub_chapter_stage(_Chapterid,_Subchapter) ->
	[].


get_value(1) ->
1;


get_value(2) ->
{100580, 100590};


get_value(3) ->
[{1, 1001}];


get_value(4) ->
[{1001,11},{1002, 4}, {1003, 3}, {1004, 5}, {1005, 1}];


get_value(5) ->
[{1001, 1}];


get_value(6) ->
[{lv, 48}];


get_value(7) ->
[{1,1114},{2,1214},{3,1114},{4,1214}];


get_value(8) ->
[ 100660, 100970, 101160, 101200, 101270, 101460 ];


get_value(9) ->
[31002];


get_value(10) ->
50006;


get_value(11) ->
[{1002,3,5},{1003,3,5},{1004,1,3},{1002,1,4},{1004,1,3},{1005,1,5},{1005,2,4},{1005,3,4}];

get_value(_Key) ->
	[].

get_career_suit(1001,1) ->
	#base_temple_awaken_suit{chapter_id = 1001,career = 1,figure_id = 1108,reward = []};

get_career_suit(1001,2) ->
	#base_temple_awaken_suit{chapter_id = 1001,career = 2,figure_id = 1208,reward = []};

get_career_suit(1001,3) ->
	#base_temple_awaken_suit{chapter_id = 1001,career = 3,figure_id = 1308,reward = []};

get_career_suit(1001,4) ->
	#base_temple_awaken_suit{chapter_id = 1001,career = 4,figure_id = 1408,reward = []};

get_career_suit(1002,1) ->
	#base_temple_awaken_suit{chapter_id = 1002,career = 1,figure_id = 1005,reward = []};

get_career_suit(1002,2) ->
	#base_temple_awaken_suit{chapter_id = 1002,career = 2,figure_id = 1005,reward = []};

get_career_suit(1002,3) ->
	#base_temple_awaken_suit{chapter_id = 1002,career = 3,figure_id = 1005,reward = []};

get_career_suit(1002,4) ->
	#base_temple_awaken_suit{chapter_id = 1002,career = 4,figure_id = 1005,reward = []};

get_career_suit(1003,1) ->
	#base_temple_awaken_suit{chapter_id = 1003,career = 1,figure_id = 1016,reward = []};

get_career_suit(1003,2) ->
	#base_temple_awaken_suit{chapter_id = 1003,career = 2,figure_id = 1016,reward = []};

get_career_suit(1003,3) ->
	#base_temple_awaken_suit{chapter_id = 1003,career = 3,figure_id = 1016,reward = []};

get_career_suit(1003,4) ->
	#base_temple_awaken_suit{chapter_id = 1003,career = 4,figure_id = 1016,reward = []};

get_career_suit(1004,1) ->
	#base_temple_awaken_suit{chapter_id = 1004,career = 1,figure_id = 1103,reward = []};

get_career_suit(1004,2) ->
	#base_temple_awaken_suit{chapter_id = 1004,career = 2,figure_id = 1103,reward = []};

get_career_suit(1004,3) ->
	#base_temple_awaken_suit{chapter_id = 1004,career = 3,figure_id = 1303,reward = []};

get_career_suit(1004,4) ->
	#base_temple_awaken_suit{chapter_id = 1004,career = 4,figure_id = 1403,reward = []};

get_career_suit(1005,1) ->
	#base_temple_awaken_suit{chapter_id = 1005,career = 1,figure_id = 1021,reward = []};

get_career_suit(1005,2) ->
	#base_temple_awaken_suit{chapter_id = 1005,career = 2,figure_id = 1021,reward = []};

get_career_suit(1005,3) ->
	#base_temple_awaken_suit{chapter_id = 1005,career = 3,figure_id = 1021,reward = []};

get_career_suit(1005,4) ->
	#base_temple_awaken_suit{chapter_id = 1005,career = 4,figure_id = 1021,reward = []};

get_career_suit(_Chapterid,_Career) ->
	[].

