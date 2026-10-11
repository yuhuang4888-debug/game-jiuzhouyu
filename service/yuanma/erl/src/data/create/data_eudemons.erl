%%%---------------------------------------
%%% module      : data_eudemons
%%% description : 幻兽配置
%%%
%%%---------------------------------------
-module(data_eudemons).
-compile(export_all).
-include("eudemons.hrl").



get_item(1) ->
	#base_eudemons_item{id = 1,name = "月精灵",base_att = [{1,800},{2,16000},{3,400},{4,400}],skill_ids = [{19000101,1}]};

get_item(2) ->
	#base_eudemons_item{id = 2,name = "祭祀猪",base_att = [{1,960},{2,19200},{3,480},{4,480}],skill_ids = [{19000201,1}]};

get_item(3) ->
	#base_eudemons_item{id = 3,name = "酒童子",base_att = [{1,1160},{2,23200},{3,580},{4,580}],skill_ids = [{19000301,1}]};

get_item(4) ->
	#base_eudemons_item{id = 4,name = "小鹿姬",base_att = [{1,1360},{2,27200},{3,680},{4,680}],skill_ids = [{19000401,1}]};

get_item(5) ->
	#base_eudemons_item{id = 5,name = "呱太郎",base_att = [{1,1560},{2,31200},{3,780},{4,780}],skill_ids = [{19000501,1}]};

get_item(6) ->
	#base_eudemons_item{id = 6,name = "斗扇魂",base_att = [{1,1800},{2,36000},{3,900},{4,900}],skill_ids = [{19000601,1}]};

get_item(7) ->
	#base_eudemons_item{id = 7,name = "凤凰火",base_att = [{1,2040},{2,40800},{3,1020},{4,1020}],skill_ids = [{19000701,1}]};

get_item(8) ->
	#base_eudemons_item{id = 8,name = "桃花姬",base_att = [{1,2320},{2,46400},{3,1160},{4,1160}],skill_ids = [{19000000,1},{19000801,1}]};

get_item(9) ->
	#base_eudemons_item{id = 9,name = "角盥漱",base_att = [{1,2600},{2,52000},{3,1300},{4,1300}],skill_ids = [{19000000,1},{19000901,1}]};

get_item(10) ->
	#base_eudemons_item{id = 10,name = "荒骷髅",base_att = [{1,2880},{2,57600},{3,1440},{4,1440}],skill_ids = [{19000000,1},{19001001,1}]};

get_item(11) ->
	#base_eudemons_item{id = 11,name = "炼狱鬼",base_att = [{1,3200},{2,64000},{3,1600},{4,1600}],skill_ids = [{19000000,1},{19001101,1}]};

get_item(12) ->
	#base_eudemons_item{id = 12,name = "浮生绘",base_att = [{1,3520},{2,70400},{3,1760},{4,1760}],skill_ids = [{19000000,1},{19001201,1}]};

get_item(13) ->
	#base_eudemons_item{id = 13,name = "海坊主",base_att = [{1,3880},{2,77600},{3,1940},{4,1940}],skill_ids = [{19000000,1},{19001301,1}]};

get_item(14) ->
	#base_eudemons_item{id = 14,name = "驭铃姬",base_att = [{1,4240},{2,84800},{3,2120},{4,2120}],skill_ids = [{19000000,1},{19001401,1}]};

get_item(15) ->
	#base_eudemons_item{id = 15,name = "复仇骨",base_att = [{1,4600},{2,92000},{3,2300},{4,2300}],skill_ids = [{19000000,1},{19001501,1}]};

get_item(16) ->
	#base_eudemons_item{id = 16,name = "烛阴神",base_att = [{1,5000},{2,100000},{3,2500},{4,2500}],skill_ids = [{19000000,1},{19001601,1}]};

get_item(17) ->
	#base_eudemons_item{id = 17,name = "酒吞邪",base_att = [{1,5400},{2,108000},{3,2700},{4,2700}],skill_ids = [{19000000,1},{19001701,1}]};

get_item(18) ->
	#base_eudemons_item{id = 18,name = "白粉婆",base_att = [{1,5840},{2,116800},{3,2920},{4,2920}],skill_ids = [{19000000,1},{19001801,1}]};

get_item(19) ->
	#base_eudemons_item{id = 19,name = "罗生鬼",base_att = [{1,6280},{2,125600},{3,3140},{4,3140}],skill_ids = [{19000000,1},{19001901,1}]};

get_item(20) ->
	#base_eudemons_item{id = 20,name = "无面鬼",base_att = [{1,6720},{2,134400},{3,3360},{4,3360}],skill_ids = [{19000000,1},{19002001,1}]};

get_item(21) ->
	#base_eudemons_item{id = 21,name = "斗修罗",base_att = [{1,7200},{2,144000},{3,3600},{4,3600}],skill_ids = [{19000000,1},{19002101,1},{19002102,1}]};

get_item(22) ->
	#base_eudemons_item{id = 22,name = "日傀儡",base_att = [{1,7680},{2,153600},{3,3840},{4,3840}],skill_ids = [{19000000,1},{19002201,1},{19002202,1}]};

get_item(23) ->
	#base_eudemons_item{id = 23,name = "亡灵将",base_att = [{1,8200},{2,164000},{3,4100},{4,4100}],skill_ids = [{19000000,1},{19002301,1},{19002302,1}]};

get_item(24) ->
	#base_eudemons_item{id = 24,name = "黄泉花",base_att = [{1,8720},{2,174400},{3,4360},{4,4360}],skill_ids = [{19000000,1},{19002401,1},{19002402,1}]};

get_item(25) ->
	#base_eudemons_item{id = 25,name = "鸦天狗",base_att = [{1,9240},{2,184800},{3,4620},{4,4620}],skill_ids = [{19000000,1},{19002501,1},{19002502,1}]};

get_item(_Id) ->
	[].

get_all_items() ->
[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25].

get_pos(1,1) ->
	#base_eudemons_equip_pos{id = 1,pos = 1,conditions = [{color,1}]};

get_pos(1,2) ->
	#base_eudemons_equip_pos{id = 1,pos = 2,conditions = [{color,1}]};

get_pos(1,3) ->
	#base_eudemons_equip_pos{id = 1,pos = 3,conditions = [{color,1}]};

get_pos(1,4) ->
	#base_eudemons_equip_pos{id = 1,pos = 4,conditions = [{color,1}]};

get_pos(1,5) ->
	#base_eudemons_equip_pos{id = 1,pos = 5,conditions = [{color,1}]};

get_pos(2,1) ->
	#base_eudemons_equip_pos{id = 2,pos = 1,conditions = [{color,2}]};

get_pos(2,2) ->
	#base_eudemons_equip_pos{id = 2,pos = 2,conditions = [{color,2}]};

get_pos(2,3) ->
	#base_eudemons_equip_pos{id = 2,pos = 3,conditions = [{color,1}]};

get_pos(2,4) ->
	#base_eudemons_equip_pos{id = 2,pos = 4,conditions = [{color,1}]};

get_pos(2,5) ->
	#base_eudemons_equip_pos{id = 2,pos = 5,conditions = [{color,1}]};

get_pos(3,1) ->
	#base_eudemons_equip_pos{id = 3,pos = 1,conditions = [{color,2}]};

get_pos(3,2) ->
	#base_eudemons_equip_pos{id = 3,pos = 2,conditions = [{color,2}]};

get_pos(3,3) ->
	#base_eudemons_equip_pos{id = 3,pos = 3,conditions = [{color,2}]};

get_pos(3,4) ->
	#base_eudemons_equip_pos{id = 3,pos = 4,conditions = [{color,2}]};

get_pos(3,5) ->
	#base_eudemons_equip_pos{id = 3,pos = 5,conditions = [{color,2}]};

get_pos(4,1) ->
	#base_eudemons_equip_pos{id = 4,pos = 1,conditions = [{color,3}]};

get_pos(4,2) ->
	#base_eudemons_equip_pos{id = 4,pos = 2,conditions = [{color,2}]};

get_pos(4,3) ->
	#base_eudemons_equip_pos{id = 4,pos = 3,conditions = [{color,2}]};

get_pos(4,4) ->
	#base_eudemons_equip_pos{id = 4,pos = 4,conditions = [{color,2}]};

get_pos(4,5) ->
	#base_eudemons_equip_pos{id = 4,pos = 5,conditions = [{color,2}]};

get_pos(5,1) ->
	#base_eudemons_equip_pos{id = 5,pos = 1,conditions = [{color,3}]};

get_pos(5,2) ->
	#base_eudemons_equip_pos{id = 5,pos = 2,conditions = [{color,3}]};

get_pos(5,3) ->
	#base_eudemons_equip_pos{id = 5,pos = 3,conditions = [{color,2}]};

get_pos(5,4) ->
	#base_eudemons_equip_pos{id = 5,pos = 4,conditions = [{color,2}]};

get_pos(5,5) ->
	#base_eudemons_equip_pos{id = 5,pos = 5,conditions = [{color,2}]};

get_pos(6,1) ->
	#base_eudemons_equip_pos{id = 6,pos = 1,conditions = [{color,3}]};

get_pos(6,2) ->
	#base_eudemons_equip_pos{id = 6,pos = 2,conditions = [{color,3}]};

get_pos(6,3) ->
	#base_eudemons_equip_pos{id = 6,pos = 3,conditions = [{color,3}]};

get_pos(6,4) ->
	#base_eudemons_equip_pos{id = 6,pos = 4,conditions = [{color,3}]};

get_pos(6,5) ->
	#base_eudemons_equip_pos{id = 6,pos = 5,conditions = [{color,3}]};

get_pos(7,1) ->
	#base_eudemons_equip_pos{id = 7,pos = 1,conditions = [{color,3}]};

get_pos(7,2) ->
	#base_eudemons_equip_pos{id = 7,pos = 2,conditions = [{color,3}]};

get_pos(7,3) ->
	#base_eudemons_equip_pos{id = 7,pos = 3,conditions = [{color,3}]};

get_pos(7,4) ->
	#base_eudemons_equip_pos{id = 7,pos = 4,conditions = [{color,3}]};

get_pos(7,5) ->
	#base_eudemons_equip_pos{id = 7,pos = 5,conditions = [{color,3}]};

get_pos(8,1) ->
	#base_eudemons_equip_pos{id = 8,pos = 1,conditions = [{color,4}]};

get_pos(8,2) ->
	#base_eudemons_equip_pos{id = 8,pos = 2,conditions = [{color,3}]};

get_pos(8,3) ->
	#base_eudemons_equip_pos{id = 8,pos = 3,conditions = [{color,3}]};

get_pos(8,4) ->
	#base_eudemons_equip_pos{id = 8,pos = 4,conditions = [{color,3}]};

get_pos(8,5) ->
	#base_eudemons_equip_pos{id = 8,pos = 5,conditions = [{color,3}]};

get_pos(9,1) ->
	#base_eudemons_equip_pos{id = 9,pos = 1,conditions = [{color,4}]};

get_pos(9,2) ->
	#base_eudemons_equip_pos{id = 9,pos = 2,conditions = [{color,4}]};

get_pos(9,3) ->
	#base_eudemons_equip_pos{id = 9,pos = 3,conditions = [{color,4}]};

get_pos(9,4) ->
	#base_eudemons_equip_pos{id = 9,pos = 4,conditions = [{color,3}]};

get_pos(9,5) ->
	#base_eudemons_equip_pos{id = 9,pos = 5,conditions = [{color,3}]};

get_pos(10,1) ->
	#base_eudemons_equip_pos{id = 10,pos = 1,conditions = [{color,4}]};

get_pos(10,2) ->
	#base_eudemons_equip_pos{id = 10,pos = 2,conditions = [{color,4}]};

get_pos(10,3) ->
	#base_eudemons_equip_pos{id = 10,pos = 3,conditions = [{color,4}]};

get_pos(10,4) ->
	#base_eudemons_equip_pos{id = 10,pos = 4,conditions = [{color,4}]};

get_pos(10,5) ->
	#base_eudemons_equip_pos{id = 10,pos = 5,conditions = [{color,4}]};

get_pos(11,1) ->
	#base_eudemons_equip_pos{id = 11,pos = 1,conditions = [{color,4}]};

get_pos(11,2) ->
	#base_eudemons_equip_pos{id = 11,pos = 2,conditions = [{color,4}]};

get_pos(11,3) ->
	#base_eudemons_equip_pos{id = 11,pos = 3,conditions = [{color,4}]};

get_pos(11,4) ->
	#base_eudemons_equip_pos{id = 11,pos = 4,conditions = [{color,4}]};

get_pos(11,5) ->
	#base_eudemons_equip_pos{id = 11,pos = 5,conditions = [{color,4}]};

get_pos(12,1) ->
	#base_eudemons_equip_pos{id = 12,pos = 1,conditions = [{color,5},{star,2}]};

get_pos(12,2) ->
	#base_eudemons_equip_pos{id = 12,pos = 2,conditions = [{color,4}]};

get_pos(12,3) ->
	#base_eudemons_equip_pos{id = 12,pos = 3,conditions = [{color,4}]};

get_pos(12,4) ->
	#base_eudemons_equip_pos{id = 12,pos = 4,conditions = [{color,4}]};

get_pos(12,5) ->
	#base_eudemons_equip_pos{id = 12,pos = 5,conditions = [{color,4}]};

get_pos(13,1) ->
	#base_eudemons_equip_pos{id = 13,pos = 1,conditions = [{color,5},{star,2}]};

get_pos(13,2) ->
	#base_eudemons_equip_pos{id = 13,pos = 2,conditions = [{color,5},{star,2}]};

get_pos(13,3) ->
	#base_eudemons_equip_pos{id = 13,pos = 3,conditions = [{color,5},{star,2}]};

get_pos(13,4) ->
	#base_eudemons_equip_pos{id = 13,pos = 4,conditions = [{color,4}]};

get_pos(13,5) ->
	#base_eudemons_equip_pos{id = 13,pos = 5,conditions = [{color,4}]};

get_pos(14,1) ->
	#base_eudemons_equip_pos{id = 14,pos = 1,conditions = [{color,5},{star,2}]};

get_pos(14,2) ->
	#base_eudemons_equip_pos{id = 14,pos = 2,conditions = [{color,5},{star,2}]};

get_pos(14,3) ->
	#base_eudemons_equip_pos{id = 14,pos = 3,conditions = [{color,5},{star,2}]};

get_pos(14,4) ->
	#base_eudemons_equip_pos{id = 14,pos = 4,conditions = [{color,5},{star,2}]};

get_pos(14,5) ->
	#base_eudemons_equip_pos{id = 14,pos = 5,conditions = [{color,5},{star,2}]};

get_pos(15,1) ->
	#base_eudemons_equip_pos{id = 15,pos = 1,conditions = [{color,5},{star,2}]};

get_pos(15,2) ->
	#base_eudemons_equip_pos{id = 15,pos = 2,conditions = [{color,5},{star,2}]};

get_pos(15,3) ->
	#base_eudemons_equip_pos{id = 15,pos = 3,conditions = [{color,5},{star,2}]};

get_pos(15,4) ->
	#base_eudemons_equip_pos{id = 15,pos = 4,conditions = [{color,5},{star,2}]};

get_pos(15,5) ->
	#base_eudemons_equip_pos{id = 15,pos = 5,conditions = [{color,5},{star,2}]};

get_pos(16,1) ->
	#base_eudemons_equip_pos{id = 16,pos = 1,conditions = [{color,5},{star,3}]};

get_pos(16,2) ->
	#base_eudemons_equip_pos{id = 16,pos = 2,conditions = [{color,5},{star,2}]};

get_pos(16,3) ->
	#base_eudemons_equip_pos{id = 16,pos = 3,conditions = [{color,5},{star,2}]};

get_pos(16,4) ->
	#base_eudemons_equip_pos{id = 16,pos = 4,conditions = [{color,5},{star,2}]};

get_pos(16,5) ->
	#base_eudemons_equip_pos{id = 16,pos = 5,conditions = [{color,5},{star,2}]};

get_pos(17,1) ->
	#base_eudemons_equip_pos{id = 17,pos = 1,conditions = [{color,5},{star,3}]};

get_pos(17,2) ->
	#base_eudemons_equip_pos{id = 17,pos = 2,conditions = [{color,5},{star,3}]};

get_pos(17,3) ->
	#base_eudemons_equip_pos{id = 17,pos = 3,conditions = [{color,5},{star,2}]};

get_pos(17,4) ->
	#base_eudemons_equip_pos{id = 17,pos = 4,conditions = [{color,5},{star,2}]};

get_pos(17,5) ->
	#base_eudemons_equip_pos{id = 17,pos = 5,conditions = [{color,5},{star,2}]};

get_pos(18,1) ->
	#base_eudemons_equip_pos{id = 18,pos = 1,conditions = [{color,5},{star,3}]};

get_pos(18,2) ->
	#base_eudemons_equip_pos{id = 18,pos = 2,conditions = [{color,5},{star,3}]};

get_pos(18,3) ->
	#base_eudemons_equip_pos{id = 18,pos = 3,conditions = [{color,5},{star,3}]};

get_pos(18,4) ->
	#base_eudemons_equip_pos{id = 18,pos = 4,conditions = [{color,5},{star,2}]};

get_pos(18,5) ->
	#base_eudemons_equip_pos{id = 18,pos = 5,conditions = [{color,5},{star,2}]};

get_pos(19,1) ->
	#base_eudemons_equip_pos{id = 19,pos = 1,conditions = [{color,5},{star,3}]};

get_pos(19,2) ->
	#base_eudemons_equip_pos{id = 19,pos = 2,conditions = [{color,5},{star,3}]};

get_pos(19,3) ->
	#base_eudemons_equip_pos{id = 19,pos = 3,conditions = [{color,5},{star,3}]};

get_pos(19,4) ->
	#base_eudemons_equip_pos{id = 19,pos = 4,conditions = [{color,5},{star,3}]};

get_pos(19,5) ->
	#base_eudemons_equip_pos{id = 19,pos = 5,conditions = [{color,5},{star,2}]};

get_pos(20,1) ->
	#base_eudemons_equip_pos{id = 20,pos = 1,conditions = [{color,5},{star,3}]};

get_pos(20,2) ->
	#base_eudemons_equip_pos{id = 20,pos = 2,conditions = [{color,5},{star,3}]};

get_pos(20,3) ->
	#base_eudemons_equip_pos{id = 20,pos = 3,conditions = [{color,5},{star,3}]};

get_pos(20,4) ->
	#base_eudemons_equip_pos{id = 20,pos = 4,conditions = [{color,5},{star,3}]};

get_pos(20,5) ->
	#base_eudemons_equip_pos{id = 20,pos = 5,conditions = [{color,5},{star,3}]};

get_pos(21,1) ->
	#base_eudemons_equip_pos{id = 21,pos = 1,conditions = [{color,7}]};

get_pos(21,2) ->
	#base_eudemons_equip_pos{id = 21,pos = 2,conditions = [{color,5},{star,3}]};

get_pos(21,3) ->
	#base_eudemons_equip_pos{id = 21,pos = 3,conditions = [{color,5},{star,3}]};

get_pos(21,4) ->
	#base_eudemons_equip_pos{id = 21,pos = 4,conditions = [{color,5},{star,3}]};

get_pos(21,5) ->
	#base_eudemons_equip_pos{id = 21,pos = 5,conditions = [{color,5},{star,3}]};

get_pos(22,1) ->
	#base_eudemons_equip_pos{id = 22,pos = 1,conditions = [{color,7}]};

get_pos(22,2) ->
	#base_eudemons_equip_pos{id = 22,pos = 2,conditions = [{color,7}]};

get_pos(22,3) ->
	#base_eudemons_equip_pos{id = 22,pos = 3,conditions = [{color,5},{star,3}]};

get_pos(22,4) ->
	#base_eudemons_equip_pos{id = 22,pos = 4,conditions = [{color,5},{star,3}]};

get_pos(22,5) ->
	#base_eudemons_equip_pos{id = 22,pos = 5,conditions = [{color,5},{star,3}]};

get_pos(23,1) ->
	#base_eudemons_equip_pos{id = 23,pos = 1,conditions = [{color,7}]};

get_pos(23,2) ->
	#base_eudemons_equip_pos{id = 23,pos = 2,conditions = [{color,7}]};

get_pos(23,3) ->
	#base_eudemons_equip_pos{id = 23,pos = 3,conditions = [{color,7}]};

get_pos(23,4) ->
	#base_eudemons_equip_pos{id = 23,pos = 4,conditions = [{color,5},{star,3}]};

get_pos(23,5) ->
	#base_eudemons_equip_pos{id = 23,pos = 5,conditions = [{color,5},{star,3}]};

get_pos(24,1) ->
	#base_eudemons_equip_pos{id = 24,pos = 1,conditions = [{color,7}]};

get_pos(24,2) ->
	#base_eudemons_equip_pos{id = 24,pos = 2,conditions = [{color,7}]};

get_pos(24,3) ->
	#base_eudemons_equip_pos{id = 24,pos = 3,conditions = [{color,7}]};

get_pos(24,4) ->
	#base_eudemons_equip_pos{id = 24,pos = 4,conditions = [{color,7}]};

get_pos(24,5) ->
	#base_eudemons_equip_pos{id = 24,pos = 5,conditions = [{color,5},{star,3}]};

get_pos(25,1) ->
	#base_eudemons_equip_pos{id = 25,pos = 1,conditions = [{color,7}]};

get_pos(25,2) ->
	#base_eudemons_equip_pos{id = 25,pos = 2,conditions = [{color,7}]};

get_pos(25,3) ->
	#base_eudemons_equip_pos{id = 25,pos = 3,conditions = [{color,7}]};

get_pos(25,4) ->
	#base_eudemons_equip_pos{id = 25,pos = 4,conditions = [{color,7}]};

get_pos(25,5) ->
	#base_eudemons_equip_pos{id = 25,pos = 5,conditions = [{color,7}]};

get_pos(_Id,_Pos) ->
	[].


get_all_pos(1) ->
[1,2,3,4,5];


get_all_pos(2) ->
[1,2,3,4,5];


get_all_pos(3) ->
[1,2,3,4,5];


get_all_pos(4) ->
[1,2,3,4,5];


get_all_pos(5) ->
[1,2,3,4,5];


get_all_pos(6) ->
[1,2,3,4,5];


get_all_pos(7) ->
[1,2,3,4,5];


get_all_pos(8) ->
[1,2,3,4,5];


get_all_pos(9) ->
[1,2,3,4,5];


get_all_pos(10) ->
[1,2,3,4,5];


get_all_pos(11) ->
[1,2,3,4,5];


get_all_pos(12) ->
[1,2,3,4,5];


get_all_pos(13) ->
[1,2,3,4,5];


get_all_pos(14) ->
[1,2,3,4,5];


get_all_pos(15) ->
[1,2,3,4,5];


get_all_pos(16) ->
[1,2,3,4,5];


get_all_pos(17) ->
[1,2,3,4,5];


get_all_pos(18) ->
[1,2,3,4,5];


get_all_pos(19) ->
[1,2,3,4,5];


get_all_pos(20) ->
[1,2,3,4,5];


get_all_pos(21) ->
[1,2,3,4,5];


get_all_pos(22) ->
[1,2,3,4,5];


get_all_pos(23) ->
[1,2,3,4,5];


get_all_pos(24) ->
[1,2,3,4,5];


get_all_pos(25) ->
[1,2,3,4,5];

get_all_pos(_Id) ->
	[].

get_equip_attr(39010000) ->
	#base_eudemons_equip_attr{goods_id = 39010000,star = 0,blue_attr = [{1000,{15,35}},{1000,{16,35}},{1000,{5,35}}],bule_count = 3,purple_attr = [],purple_count = 0,orange_attr = [],orange_count = 0,red_attr = [],red_count = 0,base_exp = 0};

get_equip_attr(39010201) ->
	#base_eudemons_equip_attr{goods_id = 39010201,star = 0,blue_attr = [],bule_count = 0,purple_attr = [{1000,{15,60}},{1000,{16,60}},{1000,{5,60}}],purple_count = 3,orange_attr = [],orange_count = 0,red_attr = [],red_count = 0,base_exp = 0};

get_equip_attr(39010301) ->
	#base_eudemons_equip_attr{goods_id = 39010301,star = 0,blue_attr = [],bule_count = 0,purple_attr = [{1000,{15,100}},{1000,{16,100}},{1000,{5,100}}],purple_count = 3,orange_attr = [],orange_count = 0,red_attr = [],red_count = 0,base_exp = 0};

get_equip_attr(39010401) ->
	#base_eudemons_equip_attr{goods_id = 39010401,star = 1,blue_attr = [],bule_count = 0,purple_attr = [{1000,{15,140}},{1000,{16,140}},{1000,{5,140}}],purple_count = 2,orange_attr = [{1000,{23,300}},{1000,{13,25}}],orange_count = 1,red_attr = [],red_count = 0,base_exp = 0};

get_equip_attr(39010402) ->
	#base_eudemons_equip_attr{goods_id = 39010402,star = 2,blue_attr = [],bule_count = 0,purple_attr = [{1000,{15,140}},{1000,{16,140}},{1000,{5,140}}],purple_count = 1,orange_attr = [{1000,{23,300}},{1000,{13,25}}],orange_count = 2,red_attr = [],red_count = 0,base_exp = 0};

get_equip_attr(39010502) ->
	#base_eudemons_equip_attr{goods_id = 39010502,star = 2,blue_attr = [],bule_count = 0,purple_attr = [],purple_count = 0,orange_attr = [{1000,{15,200}},{1000,{16,200}},{1000,{5,200}}],orange_count = 1,red_attr = [{1000,{23,400}},{1000,{13,30}}],red_count = 2,base_exp = 0};

get_equip_attr(39010503) ->
	#base_eudemons_equip_attr{goods_id = 39010503,star = 3,blue_attr = [],bule_count = 0,purple_attr = [],purple_count = 0,orange_attr = [],orange_count = 0,red_attr = [{1000,{19,80}},{1000,{23,400}},{1000,{13,30}}],red_count = 3,base_exp = 0};

get_equip_attr(39010603) ->
	#base_eudemons_equip_attr{goods_id = 39010603,star = 3,blue_attr = [],bule_count = 0,purple_attr = [],purple_count = 0,orange_attr = [],orange_count = 0,red_attr = [{1000,{19,100}},{1000,{23,500}},{1000,{13,40}}],red_count = 3,base_exp = 0};

get_equip_attr(39020000) ->
	#base_eudemons_equip_attr{goods_id = 39020000,star = 0,blue_attr = [{1000,{15,35}},{1000,{16,35}},{1000,{7,35}}],bule_count = 3,purple_attr = [],purple_count = 0,orange_attr = [],orange_count = 0,red_attr = [],red_count = 0,base_exp = 0};

get_equip_attr(39020201) ->
	#base_eudemons_equip_attr{goods_id = 39020201,star = 0,blue_attr = [],bule_count = 0,purple_attr = [{1000,{15,60}},{1000,{16,60}},{1000,{7,60}}],purple_count = 3,orange_attr = [],orange_count = 0,red_attr = [],red_count = 0,base_exp = 0};

get_equip_attr(39020301) ->
	#base_eudemons_equip_attr{goods_id = 39020301,star = 0,blue_attr = [],bule_count = 0,purple_attr = [{1000,{15,100}},{1000,{16,100}},{1000,{7,100}}],purple_count = 3,orange_attr = [],orange_count = 0,red_attr = [],red_count = 0,base_exp = 0};

get_equip_attr(39020401) ->
	#base_eudemons_equip_attr{goods_id = 39020401,star = 1,blue_attr = [],bule_count = 0,purple_attr = [{1000,{15,140}},{1000,{16,140}},{1000,{7,140}}],purple_count = 2,orange_attr = [{1000,{25,300}},{1000,{53,50}}],orange_count = 1,red_attr = [],red_count = 0,base_exp = 0};

get_equip_attr(39020402) ->
	#base_eudemons_equip_attr{goods_id = 39020402,star = 2,blue_attr = [],bule_count = 0,purple_attr = [{1000,{15,140}},{1000,{16,140}},{1000,{7,140}}],purple_count = 1,orange_attr = [{1000,{25,300}},{1000,{53,50}}],orange_count = 2,red_attr = [],red_count = 0,base_exp = 0};

get_equip_attr(39020502) ->
	#base_eudemons_equip_attr{goods_id = 39020502,star = 2,blue_attr = [],bule_count = 0,purple_attr = [],purple_count = 0,orange_attr = [{1000,{15,280}},{1000,{16,280}},{1000,{7,280}}],orange_count = 1,red_attr = [{1000,{25,400}},{1000,{53,60}}],red_count = 2,base_exp = 0};

get_equip_attr(39020503) ->
	#base_eudemons_equip_attr{goods_id = 39020503,star = 3,blue_attr = [],bule_count = 0,purple_attr = [],purple_count = 0,orange_attr = [],orange_count = 0,red_attr = [{1000,{21,160}},{1000,{25,400}},{1000,{53,60}}],red_count = 3,base_exp = 0};

get_equip_attr(39020603) ->
	#base_eudemons_equip_attr{goods_id = 39020603,star = 3,blue_attr = [],bule_count = 0,purple_attr = [],purple_count = 0,orange_attr = [],orange_count = 0,red_attr = [{1000,{21,200}},{1000,{25,500}},{1000,{53,80}}],red_count = 3,base_exp = 0};

get_equip_attr(39030000) ->
	#base_eudemons_equip_attr{goods_id = 39030000,star = 0,blue_attr = [{1000,{15,35}},{1000,{16,35}},{1000,{6,35}}],bule_count = 3,purple_attr = [],purple_count = 0,orange_attr = [],orange_count = 0,red_attr = [],red_count = 0,base_exp = 0};

get_equip_attr(39030201) ->
	#base_eudemons_equip_attr{goods_id = 39030201,star = 0,blue_attr = [],bule_count = 0,purple_attr = [{1000,{15,60}},{1000,{16,60}},{1000,{6,60}}],purple_count = 3,orange_attr = [],orange_count = 0,red_attr = [],red_count = 0,base_exp = 0};

get_equip_attr(39030301) ->
	#base_eudemons_equip_attr{goods_id = 39030301,star = 0,blue_attr = [],bule_count = 0,purple_attr = [{1000,{15,100}},{1000,{16,100}},{1000,{6,100}}],purple_count = 3,orange_attr = [],orange_count = 0,red_attr = [],red_count = 0,base_exp = 0};

get_equip_attr(39030401) ->
	#base_eudemons_equip_attr{goods_id = 39030401,star = 1,blue_attr = [],bule_count = 0,purple_attr = [{1000,{15,140}},{1000,{16,140}},{1000,{6,140}}],purple_count = 2,orange_attr = [{1000,{24,300}},{1000,{14,25}}],orange_count = 1,red_attr = [],red_count = 0,base_exp = 0};

get_equip_attr(39030402) ->
	#base_eudemons_equip_attr{goods_id = 39030402,star = 2,blue_attr = [],bule_count = 0,purple_attr = [{1000,{15,140}},{1000,{16,140}},{1000,{6,140}}],purple_count = 1,orange_attr = [{1000,{24,300}},{1000,{14,25}}],orange_count = 2,red_attr = [],red_count = 0,base_exp = 0};

get_equip_attr(39030502) ->
	#base_eudemons_equip_attr{goods_id = 39030502,star = 2,blue_attr = [],bule_count = 0,purple_attr = [],purple_count = 0,orange_attr = [{1000,{15,280}},{1000,{16,280}},{1000,{6,280}}],orange_count = 1,red_attr = [{1000,{24,400}},{1000,{14,30}}],red_count = 2,base_exp = 0};

get_equip_attr(39030503) ->
	#base_eudemons_equip_attr{goods_id = 39030503,star = 3,blue_attr = [],bule_count = 0,purple_attr = [],purple_count = 0,orange_attr = [],orange_count = 0,red_attr = [{1000,{20,80}},{1000,{24,400}},{1000,{14,30}}],red_count = 3,base_exp = 0};

get_equip_attr(39030603) ->
	#base_eudemons_equip_attr{goods_id = 39030603,star = 3,blue_attr = [],bule_count = 0,purple_attr = [],purple_count = 0,orange_attr = [],orange_count = 0,red_attr = [{1000,{20,100}},{1000,{24,500}},{1000,{14,40}}],red_count = 3,base_exp = 0};

get_equip_attr(39040000) ->
	#base_eudemons_equip_attr{goods_id = 39040000,star = 0,blue_attr = [{1000,{15,35}},{1000,{16,35}},{1000,{8,35}}],bule_count = 3,purple_attr = [],purple_count = 0,orange_attr = [],orange_count = 0,red_attr = [],red_count = 0,base_exp = 0};

get_equip_attr(39040201) ->
	#base_eudemons_equip_attr{goods_id = 39040201,star = 0,blue_attr = [],bule_count = 0,purple_attr = [{1000,{15,60}},{1000,{16,60}},{1000,{8,60}}],purple_count = 3,orange_attr = [],orange_count = 0,red_attr = [],red_count = 0,base_exp = 0};

get_equip_attr(39040301) ->
	#base_eudemons_equip_attr{goods_id = 39040301,star = 0,blue_attr = [],bule_count = 0,purple_attr = [{1000,{15,100}},{1000,{16,100}},{1000,{8,100}}],purple_count = 3,orange_attr = [],orange_count = 0,red_attr = [],red_count = 0,base_exp = 0};

get_equip_attr(39040401) ->
	#base_eudemons_equip_attr{goods_id = 39040401,star = 1,blue_attr = [],bule_count = 0,purple_attr = [{1000,{15,140}},{1000,{16,140}},{1000,{8,140}}],purple_count = 2,orange_attr = [{1000,{26,300}},{1000,{54,25}}],orange_count = 1,red_attr = [],red_count = 0,base_exp = 0};

get_equip_attr(39040402) ->
	#base_eudemons_equip_attr{goods_id = 39040402,star = 2,blue_attr = [],bule_count = 0,purple_attr = [{1000,{15,140}},{1000,{16,140}},{1000,{8,140}}],purple_count = 1,orange_attr = [{1000,{26,300}},{1000,{54,25}}],orange_count = 2,red_attr = [],red_count = 0,base_exp = 0};

get_equip_attr(39040502) ->
	#base_eudemons_equip_attr{goods_id = 39040502,star = 2,blue_attr = [],bule_count = 0,purple_attr = [],purple_count = 0,orange_attr = [{1000,{15,280}},{1000,{16,280}},{1000,{8,280}}],orange_count = 1,red_attr = [{1000,{26,400}},{1000,{54,30}}],red_count = 2,base_exp = 0};

get_equip_attr(39040503) ->
	#base_eudemons_equip_attr{goods_id = 39040503,star = 3,blue_attr = [],bule_count = 0,purple_attr = [],purple_count = 0,orange_attr = [],orange_count = 0,red_attr = [{1000,{22,160}},{1000,{26,400}},{1000,{54,30}}],red_count = 3,base_exp = 0};

get_equip_attr(39040603) ->
	#base_eudemons_equip_attr{goods_id = 39040603,star = 3,blue_attr = [],bule_count = 0,purple_attr = [],purple_count = 0,orange_attr = [],orange_count = 0,red_attr = [{1000,{22,200}},{1000,{26,500}},{1000,{54,40}}],red_count = 3,base_exp = 0};

get_equip_attr(39050000) ->
	#base_eudemons_equip_attr{goods_id = 39050000,star = 0,blue_attr = [{1000,{15,35}},{1000,{16,35}},{1000,{6,35}}],bule_count = 3,purple_attr = [],purple_count = 0,orange_attr = [],orange_count = 0,red_attr = [],red_count = 0,base_exp = 0};

get_equip_attr(39050201) ->
	#base_eudemons_equip_attr{goods_id = 39050201,star = 0,blue_attr = [],bule_count = 0,purple_attr = [{1000,{15,60}},{1000,{16,60}},{1000,{6,60}}],purple_count = 3,orange_attr = [],orange_count = 0,red_attr = [],red_count = 0,base_exp = 0};

get_equip_attr(39050301) ->
	#base_eudemons_equip_attr{goods_id = 39050301,star = 0,blue_attr = [],bule_count = 0,purple_attr = [{1000,{15,100}},{1000,{16,100}},{1000,{6,100}}],purple_count = 3,orange_attr = [],orange_count = 0,red_attr = [],red_count = 0,base_exp = 0};

get_equip_attr(39050401) ->
	#base_eudemons_equip_attr{goods_id = 39050401,star = 1,blue_attr = [],bule_count = 0,purple_attr = [{1000,{15,140}},{1000,{16,140}},{1000,{6,140}}],purple_count = 2,orange_attr = [{1000,{24,300}},{1000,{14,25}}],orange_count = 1,red_attr = [],red_count = 0,base_exp = 0};

get_equip_attr(39050402) ->
	#base_eudemons_equip_attr{goods_id = 39050402,star = 2,blue_attr = [],bule_count = 0,purple_attr = [{1000,{15,140}},{1000,{16,140}},{1000,{6,140}}],purple_count = 1,orange_attr = [{1000,{24,300}},{1000,{14,25}}],orange_count = 2,red_attr = [],red_count = 0,base_exp = 0};

get_equip_attr(39050502) ->
	#base_eudemons_equip_attr{goods_id = 39050502,star = 2,blue_attr = [],bule_count = 0,purple_attr = [],purple_count = 0,orange_attr = [{1000,{15,280}},{1000,{16,280}},{1000,{6,280}}],orange_count = 1,red_attr = [{1000,{24,400}},{1000,{14,30}}],red_count = 2,base_exp = 0};

get_equip_attr(39050503) ->
	#base_eudemons_equip_attr{goods_id = 39050503,star = 3,blue_attr = [],bule_count = 0,purple_attr = [],purple_count = 0,orange_attr = [],orange_count = 0,red_attr = [{1000,{20,80}},{1000,{24,400}},{1000,{14,30}}],red_count = 3,base_exp = 0};

get_equip_attr(39050603) ->
	#base_eudemons_equip_attr{goods_id = 39050603,star = 3,blue_attr = [],bule_count = 0,purple_attr = [],purple_count = 0,orange_attr = [],orange_count = 0,red_attr = [{1000,{20,100}},{1000,{24,500}},{1000,{14,40}}],red_count = 3,base_exp = 0};

get_equip_attr(39510000) ->
	#base_eudemons_equip_attr{goods_id = 39510000,star = 0,blue_attr = [],bule_count = 0,purple_attr = [],purple_count = 0,orange_attr = [],orange_count = 0,red_attr = [],red_count = 0,base_exp = 10};

get_equip_attr(_Goodsid) ->
	[].

get_strength(1,1) ->
	#base_eudemons_strength{pos = 1,level = 1,attr = [{1,10},{5,5}],exp = 10};

get_strength(1,2) ->
	#base_eudemons_strength{pos = 1,level = 2,attr = [{1,20},{5,10}],exp = 13};

get_strength(1,3) ->
	#base_eudemons_strength{pos = 1,level = 3,attr = [{1,30},{5,15}],exp = 17};

get_strength(1,4) ->
	#base_eudemons_strength{pos = 1,level = 4,attr = [{1,40},{5,20}],exp = 22};

get_strength(1,5) ->
	#base_eudemons_strength{pos = 1,level = 5,attr = [{1,50},{5,25}],exp = 25};

get_strength(1,6) ->
	#base_eudemons_strength{pos = 1,level = 6,attr = [{1,60},{5,30}],exp = 28};

get_strength(1,7) ->
	#base_eudemons_strength{pos = 1,level = 7,attr = [{1,70},{5,35}],exp = 30};

get_strength(1,8) ->
	#base_eudemons_strength{pos = 1,level = 8,attr = [{1,80},{5,40}],exp = 33};

get_strength(1,9) ->
	#base_eudemons_strength{pos = 1,level = 9,attr = [{1,90},{5,45}],exp = 36};

get_strength(1,10) ->
	#base_eudemons_strength{pos = 1,level = 10,attr = [{1,100},{5,50}],exp = 39};

get_strength(1,11) ->
	#base_eudemons_strength{pos = 1,level = 11,attr = [{1,110},{5,55}],exp = 42};

get_strength(1,12) ->
	#base_eudemons_strength{pos = 1,level = 12,attr = [{1,120},{5,60}],exp = 45};

get_strength(1,13) ->
	#base_eudemons_strength{pos = 1,level = 13,attr = [{1,130},{5,65}],exp = 47};

get_strength(1,14) ->
	#base_eudemons_strength{pos = 1,level = 14,attr = [{1,140},{5,70}],exp = 49};

get_strength(1,15) ->
	#base_eudemons_strength{pos = 1,level = 15,attr = [{1,150},{5,75}],exp = 58};

get_strength(1,16) ->
	#base_eudemons_strength{pos = 1,level = 16,attr = [{1,160},{5,80}],exp = 61};

get_strength(1,17) ->
	#base_eudemons_strength{pos = 1,level = 17,attr = [{1,170},{5,85}],exp = 65};

get_strength(1,18) ->
	#base_eudemons_strength{pos = 1,level = 18,attr = [{1,180},{5,90}],exp = 68};

get_strength(1,19) ->
	#base_eudemons_strength{pos = 1,level = 19,attr = [{1,190},{5,95}],exp = 72};

get_strength(1,20) ->
	#base_eudemons_strength{pos = 1,level = 20,attr = [{1,200},{5,100}],exp = 75};

get_strength(1,21) ->
	#base_eudemons_strength{pos = 1,level = 21,attr = [{1,210},{5,105}],exp = 80};

get_strength(1,22) ->
	#base_eudemons_strength{pos = 1,level = 22,attr = [{1,220},{5,110}],exp = 85};

get_strength(1,23) ->
	#base_eudemons_strength{pos = 1,level = 23,attr = [{1,230},{5,115}],exp = 95};

get_strength(1,24) ->
	#base_eudemons_strength{pos = 1,level = 24,attr = [{1,240},{5,120}],exp = 110};

get_strength(1,25) ->
	#base_eudemons_strength{pos = 1,level = 25,attr = [{1,250},{5,125}],exp = 125};

get_strength(1,26) ->
	#base_eudemons_strength{pos = 1,level = 26,attr = [{1,260},{5,130}],exp = 135};

get_strength(1,27) ->
	#base_eudemons_strength{pos = 1,level = 27,attr = [{1,270},{5,135}],exp = 145};

get_strength(1,28) ->
	#base_eudemons_strength{pos = 1,level = 28,attr = [{1,280},{5,140}],exp = 150};

get_strength(1,29) ->
	#base_eudemons_strength{pos = 1,level = 29,attr = [{1,290},{5,145}],exp = 155};

get_strength(1,30) ->
	#base_eudemons_strength{pos = 1,level = 30,attr = [{1,300},{5,150}],exp = 162};

get_strength(1,31) ->
	#base_eudemons_strength{pos = 1,level = 31,attr = [{1,310},{5,155}],exp = 115};

get_strength(1,32) ->
	#base_eudemons_strength{pos = 1,level = 32,attr = [{1,320},{5,160}],exp = 121};

get_strength(1,33) ->
	#base_eudemons_strength{pos = 1,level = 33,attr = [{1,330},{5,165}],exp = 127};

get_strength(1,34) ->
	#base_eudemons_strength{pos = 1,level = 34,attr = [{1,340},{5,170}],exp = 133};

get_strength(1,35) ->
	#base_eudemons_strength{pos = 1,level = 35,attr = [{1,350},{5,175}],exp = 139};

get_strength(1,36) ->
	#base_eudemons_strength{pos = 1,level = 36,attr = [{1,360},{5,180}],exp = 145};

get_strength(1,37) ->
	#base_eudemons_strength{pos = 1,level = 37,attr = [{1,370},{5,185}],exp = 151};

get_strength(1,38) ->
	#base_eudemons_strength{pos = 1,level = 38,attr = [{1,380},{5,190}],exp = 158};

get_strength(1,39) ->
	#base_eudemons_strength{pos = 1,level = 39,attr = [{1,390},{5,195}],exp = 166};

get_strength(1,40) ->
	#base_eudemons_strength{pos = 1,level = 40,attr = [{1,400},{5,200}],exp = 173};

get_strength(1,41) ->
	#base_eudemons_strength{pos = 1,level = 41,attr = [{1,410},{5,205}],exp = 180};

get_strength(1,42) ->
	#base_eudemons_strength{pos = 1,level = 42,attr = [{1,420},{5,210}],exp = 187};

get_strength(1,43) ->
	#base_eudemons_strength{pos = 1,level = 43,attr = [{1,430},{5,215}],exp = 194};

get_strength(1,44) ->
	#base_eudemons_strength{pos = 1,level = 44,attr = [{1,440},{5,220}],exp = 202};

get_strength(1,45) ->
	#base_eudemons_strength{pos = 1,level = 45,attr = [{1,450},{5,225}],exp = 209};

get_strength(1,46) ->
	#base_eudemons_strength{pos = 1,level = 46,attr = [{1,460},{5,230}],exp = 217};

get_strength(1,47) ->
	#base_eudemons_strength{pos = 1,level = 47,attr = [{1,470},{5,235}],exp = 226};

get_strength(1,48) ->
	#base_eudemons_strength{pos = 1,level = 48,attr = [{1,480},{5,240}],exp = 234};

get_strength(1,49) ->
	#base_eudemons_strength{pos = 1,level = 49,attr = [{1,490},{5,245}],exp = 242};

get_strength(1,50) ->
	#base_eudemons_strength{pos = 1,level = 50,attr = [{1,500},{5,250}],exp = 251};

get_strength(1,51) ->
	#base_eudemons_strength{pos = 1,level = 51,attr = [{1,510},{5,255}],exp = 259};

get_strength(1,52) ->
	#base_eudemons_strength{pos = 1,level = 52,attr = [{1,520},{5,260}],exp = 268};

get_strength(1,53) ->
	#base_eudemons_strength{pos = 1,level = 53,attr = [{1,530},{5,265}],exp = 276};

get_strength(1,54) ->
	#base_eudemons_strength{pos = 1,level = 54,attr = [{1,540},{5,270}],exp = 286};

get_strength(1,55) ->
	#base_eudemons_strength{pos = 1,level = 55,attr = [{1,550},{5,275}],exp = 295};

get_strength(1,56) ->
	#base_eudemons_strength{pos = 1,level = 56,attr = [{1,560},{5,280}],exp = 305};

get_strength(1,57) ->
	#base_eudemons_strength{pos = 1,level = 57,attr = [{1,570},{5,285}],exp = 314};

get_strength(1,58) ->
	#base_eudemons_strength{pos = 1,level = 58,attr = [{1,580},{5,290}],exp = 324};

get_strength(1,59) ->
	#base_eudemons_strength{pos = 1,level = 59,attr = [{1,590},{5,295}],exp = 334};

get_strength(1,60) ->
	#base_eudemons_strength{pos = 1,level = 60,attr = [{1,600},{5,300}],exp = 343};

get_strength(1,61) ->
	#base_eudemons_strength{pos = 1,level = 61,attr = [{1,610},{5,305}],exp = 353};

get_strength(1,62) ->
	#base_eudemons_strength{pos = 1,level = 62,attr = [{1,620},{5,310}],exp = 364};

get_strength(1,63) ->
	#base_eudemons_strength{pos = 1,level = 63,attr = [{1,630},{5,315}],exp = 374};

get_strength(1,64) ->
	#base_eudemons_strength{pos = 1,level = 64,attr = [{1,640},{5,320}],exp = 385};

get_strength(1,65) ->
	#base_eudemons_strength{pos = 1,level = 65,attr = [{1,650},{5,325}],exp = 396};

get_strength(1,66) ->
	#base_eudemons_strength{pos = 1,level = 66,attr = [{1,660},{5,330}],exp = 407};

get_strength(1,67) ->
	#base_eudemons_strength{pos = 1,level = 67,attr = [{1,670},{5,335}],exp = 418};

get_strength(1,68) ->
	#base_eudemons_strength{pos = 1,level = 68,attr = [{1,680},{5,340}],exp = 428};

get_strength(1,69) ->
	#base_eudemons_strength{pos = 1,level = 69,attr = [{1,690},{5,345}],exp = 439};

get_strength(1,70) ->
	#base_eudemons_strength{pos = 1,level = 70,attr = [{1,700},{5,350}],exp = 451};

get_strength(1,71) ->
	#base_eudemons_strength{pos = 1,level = 71,attr = [{1,710},{5,355}],exp = 463};

get_strength(1,72) ->
	#base_eudemons_strength{pos = 1,level = 72,attr = [{1,720},{5,360}],exp = 475};

get_strength(1,73) ->
	#base_eudemons_strength{pos = 1,level = 73,attr = [{1,730},{5,365}],exp = 487};

get_strength(1,74) ->
	#base_eudemons_strength{pos = 1,level = 74,attr = [{1,740},{5,370}],exp = 499};

get_strength(1,75) ->
	#base_eudemons_strength{pos = 1,level = 75,attr = [{1,750},{5,375}],exp = 511};

get_strength(1,76) ->
	#base_eudemons_strength{pos = 1,level = 76,attr = [{1,760},{5,380}],exp = 523};

get_strength(1,77) ->
	#base_eudemons_strength{pos = 1,level = 77,attr = [{1,770},{5,385}],exp = 535};

get_strength(1,78) ->
	#base_eudemons_strength{pos = 1,level = 78,attr = [{1,780},{5,390}],exp = 548};

get_strength(1,79) ->
	#base_eudemons_strength{pos = 1,level = 79,attr = [{1,790},{5,395}],exp = 562};

get_strength(1,80) ->
	#base_eudemons_strength{pos = 1,level = 80,attr = [{1,800},{5,400}],exp = 575};

get_strength(1,81) ->
	#base_eudemons_strength{pos = 1,level = 81,attr = [{1,810},{5,405}],exp = 588};

get_strength(1,82) ->
	#base_eudemons_strength{pos = 1,level = 82,attr = [{1,820},{5,410}],exp = 601};

get_strength(1,83) ->
	#base_eudemons_strength{pos = 1,level = 83,attr = [{1,830},{5,415}],exp = 614};

get_strength(1,84) ->
	#base_eudemons_strength{pos = 1,level = 84,attr = [{1,840},{5,420}],exp = 628};

get_strength(1,85) ->
	#base_eudemons_strength{pos = 1,level = 85,attr = [{1,850},{5,425}],exp = 641};

get_strength(1,86) ->
	#base_eudemons_strength{pos = 1,level = 86,attr = [{1,860},{5,430}],exp = 655};

get_strength(1,87) ->
	#base_eudemons_strength{pos = 1,level = 87,attr = [{1,870},{5,435}],exp = 670};

get_strength(1,88) ->
	#base_eudemons_strength{pos = 1,level = 88,attr = [{1,880},{5,440}],exp = 684};

get_strength(1,89) ->
	#base_eudemons_strength{pos = 1,level = 89,attr = [{1,890},{5,445}],exp = 698};

get_strength(1,90) ->
	#base_eudemons_strength{pos = 1,level = 90,attr = [{1,900},{5,450}],exp = 713};

get_strength(1,91) ->
	#base_eudemons_strength{pos = 1,level = 91,attr = [{1,910},{5,455}],exp = 727};

get_strength(1,92) ->
	#base_eudemons_strength{pos = 1,level = 92,attr = [{1,920},{5,460}],exp = 742};

get_strength(1,93) ->
	#base_eudemons_strength{pos = 1,level = 93,attr = [{1,930},{5,465}],exp = 756};

get_strength(1,94) ->
	#base_eudemons_strength{pos = 1,level = 94,attr = [{1,940},{5,470}],exp = 772};

get_strength(1,95) ->
	#base_eudemons_strength{pos = 1,level = 95,attr = [{1,950},{5,475}],exp = 787};

get_strength(1,96) ->
	#base_eudemons_strength{pos = 1,level = 96,attr = [{1,960},{5,480}],exp = 803};

get_strength(1,97) ->
	#base_eudemons_strength{pos = 1,level = 97,attr = [{1,970},{5,485}],exp = 818};

get_strength(1,98) ->
	#base_eudemons_strength{pos = 1,level = 98,attr = [{1,980},{5,490}],exp = 834};

get_strength(1,99) ->
	#base_eudemons_strength{pos = 1,level = 99,attr = [{1,990},{5,495}],exp = 850};

get_strength(1,100) ->
	#base_eudemons_strength{pos = 1,level = 100,attr = [{1,1000},{5,500}],exp = 865};

get_strength(1,101) ->
	#base_eudemons_strength{pos = 1,level = 101,attr = [{1,1010},{5,505}],exp = 881};

get_strength(1,102) ->
	#base_eudemons_strength{pos = 1,level = 102,attr = [{1,1020},{5,510}],exp = 898};

get_strength(1,103) ->
	#base_eudemons_strength{pos = 1,level = 103,attr = [{1,1030},{5,515}],exp = 914};

get_strength(1,104) ->
	#base_eudemons_strength{pos = 1,level = 104,attr = [{1,1040},{5,520}],exp = 931};

get_strength(1,105) ->
	#base_eudemons_strength{pos = 1,level = 105,attr = [{1,1050},{5,525}],exp = 948};

get_strength(1,106) ->
	#base_eudemons_strength{pos = 1,level = 106,attr = [{1,1060},{5,530}],exp = 965};

get_strength(1,107) ->
	#base_eudemons_strength{pos = 1,level = 107,attr = [{1,1070},{5,535}],exp = 982};

get_strength(1,108) ->
	#base_eudemons_strength{pos = 1,level = 108,attr = [{1,1080},{5,540}],exp = 998};

get_strength(1,109) ->
	#base_eudemons_strength{pos = 1,level = 109,attr = [{1,1090},{5,545}],exp = 1015};

get_strength(1,110) ->
	#base_eudemons_strength{pos = 1,level = 110,attr = [{1,1100},{5,550}],exp = 1033};

get_strength(1,111) ->
	#base_eudemons_strength{pos = 1,level = 111,attr = [{1,1110},{5,555}],exp = 1051};

get_strength(1,112) ->
	#base_eudemons_strength{pos = 1,level = 112,attr = [{1,1120},{5,560}],exp = 1069};

get_strength(1,113) ->
	#base_eudemons_strength{pos = 1,level = 113,attr = [{1,1130},{5,565}],exp = 1087};

get_strength(1,114) ->
	#base_eudemons_strength{pos = 1,level = 114,attr = [{1,1140},{5,570}],exp = 1105};

get_strength(1,115) ->
	#base_eudemons_strength{pos = 1,level = 115,attr = [{1,1150},{5,575}],exp = 1123};

get_strength(1,116) ->
	#base_eudemons_strength{pos = 1,level = 116,attr = [{1,1160},{5,580}],exp = 1141};

get_strength(1,117) ->
	#base_eudemons_strength{pos = 1,level = 117,attr = [{1,1170},{5,585}],exp = 1159};

get_strength(1,118) ->
	#base_eudemons_strength{pos = 1,level = 118,attr = [{1,1180},{5,590}],exp = 1178};

get_strength(1,119) ->
	#base_eudemons_strength{pos = 1,level = 119,attr = [{1,1190},{5,595}],exp = 1198};

get_strength(1,120) ->
	#base_eudemons_strength{pos = 1,level = 120,attr = [{1,1200},{5,600}],exp = 1217};

get_strength(1,121) ->
	#base_eudemons_strength{pos = 1,level = 121,attr = [{1,1210},{5,605}],exp = 1222};

get_strength(1,122) ->
	#base_eudemons_strength{pos = 1,level = 122,attr = [{1,1220},{5,610}],exp = 1226};

get_strength(1,123) ->
	#base_eudemons_strength{pos = 1,level = 123,attr = [{1,1230},{5,615}],exp = 1231};

get_strength(1,124) ->
	#base_eudemons_strength{pos = 1,level = 124,attr = [{1,1240},{5,620}],exp = 1236};

get_strength(1,125) ->
	#base_eudemons_strength{pos = 1,level = 125,attr = [{1,1250},{5,625}],exp = 1241};

get_strength(1,126) ->
	#base_eudemons_strength{pos = 1,level = 126,attr = [{1,1260},{5,630}],exp = 1246};

get_strength(1,127) ->
	#base_eudemons_strength{pos = 1,level = 127,attr = [{1,1270},{5,635}],exp = 1250};

get_strength(1,128) ->
	#base_eudemons_strength{pos = 1,level = 128,attr = [{1,1280},{5,640}],exp = 1255};

get_strength(1,129) ->
	#base_eudemons_strength{pos = 1,level = 129,attr = [{1,1290},{5,645}],exp = 1260};

get_strength(1,130) ->
	#base_eudemons_strength{pos = 1,level = 130,attr = [{1,1300},{5,650}],exp = 1265};

get_strength(1,131) ->
	#base_eudemons_strength{pos = 1,level = 131,attr = [{1,1310},{5,655}],exp = 1270};

get_strength(1,132) ->
	#base_eudemons_strength{pos = 1,level = 132,attr = [{1,1320},{5,660}],exp = 1274};

get_strength(1,133) ->
	#base_eudemons_strength{pos = 1,level = 133,attr = [{1,1330},{5,665}],exp = 1279};

get_strength(1,134) ->
	#base_eudemons_strength{pos = 1,level = 134,attr = [{1,1340},{5,670}],exp = 1284};

get_strength(1,135) ->
	#base_eudemons_strength{pos = 1,level = 135,attr = [{1,1350},{5,675}],exp = 1289};

get_strength(1,136) ->
	#base_eudemons_strength{pos = 1,level = 136,attr = [{1,1360},{5,680}],exp = 1294};

get_strength(1,137) ->
	#base_eudemons_strength{pos = 1,level = 137,attr = [{1,1370},{5,685}],exp = 1298};

get_strength(1,138) ->
	#base_eudemons_strength{pos = 1,level = 138,attr = [{1,1380},{5,690}],exp = 1303};

get_strength(1,139) ->
	#base_eudemons_strength{pos = 1,level = 139,attr = [{1,1390},{5,695}],exp = 1308};

get_strength(1,140) ->
	#base_eudemons_strength{pos = 1,level = 140,attr = [{1,1400},{5,700}],exp = 1313};

get_strength(1,141) ->
	#base_eudemons_strength{pos = 1,level = 141,attr = [{1,1410},{5,705}],exp = 1318};

get_strength(1,142) ->
	#base_eudemons_strength{pos = 1,level = 142,attr = [{1,1420},{5,710}],exp = 1322};

get_strength(1,143) ->
	#base_eudemons_strength{pos = 1,level = 143,attr = [{1,1430},{5,715}],exp = 1327};

get_strength(1,144) ->
	#base_eudemons_strength{pos = 1,level = 144,attr = [{1,1440},{5,720}],exp = 1332};

get_strength(1,145) ->
	#base_eudemons_strength{pos = 1,level = 145,attr = [{1,1450},{5,725}],exp = 1337};

get_strength(1,146) ->
	#base_eudemons_strength{pos = 1,level = 146,attr = [{1,1460},{5,730}],exp = 1342};

get_strength(1,147) ->
	#base_eudemons_strength{pos = 1,level = 147,attr = [{1,1470},{5,735}],exp = 1346};

get_strength(1,148) ->
	#base_eudemons_strength{pos = 1,level = 148,attr = [{1,1480},{5,740}],exp = 1351};

get_strength(1,149) ->
	#base_eudemons_strength{pos = 1,level = 149,attr = [{1,1490},{5,745}],exp = 1356};

get_strength(1,150) ->
	#base_eudemons_strength{pos = 1,level = 150,attr = [{1,1500},{5,750}],exp = 1361};

get_strength(1,151) ->
	#base_eudemons_strength{pos = 1,level = 151,attr = [{1,1510},{5,755}],exp = 1366};

get_strength(1,152) ->
	#base_eudemons_strength{pos = 1,level = 152,attr = [{1,1520},{5,760}],exp = 1370};

get_strength(1,153) ->
	#base_eudemons_strength{pos = 1,level = 153,attr = [{1,1530},{5,765}],exp = 1375};

get_strength(1,154) ->
	#base_eudemons_strength{pos = 1,level = 154,attr = [{1,1540},{5,770}],exp = 1380};

get_strength(1,155) ->
	#base_eudemons_strength{pos = 1,level = 155,attr = [{1,1550},{5,775}],exp = 1385};

get_strength(1,156) ->
	#base_eudemons_strength{pos = 1,level = 156,attr = [{1,1560},{5,780}],exp = 1390};

get_strength(1,157) ->
	#base_eudemons_strength{pos = 1,level = 157,attr = [{1,1570},{5,785}],exp = 1394};

get_strength(1,158) ->
	#base_eudemons_strength{pos = 1,level = 158,attr = [{1,1580},{5,790}],exp = 1399};

get_strength(1,159) ->
	#base_eudemons_strength{pos = 1,level = 159,attr = [{1,1590},{5,795}],exp = 1404};

get_strength(1,160) ->
	#base_eudemons_strength{pos = 1,level = 160,attr = [{1,1600},{5,800}],exp = 1409};

get_strength(1,161) ->
	#base_eudemons_strength{pos = 1,level = 161,attr = [{1,1610},{5,805}],exp = 1414};

get_strength(1,162) ->
	#base_eudemons_strength{pos = 1,level = 162,attr = [{1,1620},{5,810}],exp = 1418};

get_strength(1,163) ->
	#base_eudemons_strength{pos = 1,level = 163,attr = [{1,1630},{5,815}],exp = 1423};

get_strength(1,164) ->
	#base_eudemons_strength{pos = 1,level = 164,attr = [{1,1640},{5,820}],exp = 1428};

get_strength(1,165) ->
	#base_eudemons_strength{pos = 1,level = 165,attr = [{1,1650},{5,825}],exp = 1433};

get_strength(1,166) ->
	#base_eudemons_strength{pos = 1,level = 166,attr = [{1,1660},{5,830}],exp = 1438};

get_strength(1,167) ->
	#base_eudemons_strength{pos = 1,level = 167,attr = [{1,1670},{5,835}],exp = 1442};

get_strength(1,168) ->
	#base_eudemons_strength{pos = 1,level = 168,attr = [{1,1680},{5,840}],exp = 1447};

get_strength(1,169) ->
	#base_eudemons_strength{pos = 1,level = 169,attr = [{1,1690},{5,845}],exp = 1452};

get_strength(1,170) ->
	#base_eudemons_strength{pos = 1,level = 170,attr = [{1,1700},{5,850}],exp = 1457};

get_strength(1,171) ->
	#base_eudemons_strength{pos = 1,level = 171,attr = [{1,1710},{5,855}],exp = 1462};

get_strength(1,172) ->
	#base_eudemons_strength{pos = 1,level = 172,attr = [{1,1720},{5,860}],exp = 1466};

get_strength(1,173) ->
	#base_eudemons_strength{pos = 1,level = 173,attr = [{1,1730},{5,865}],exp = 1471};

get_strength(1,174) ->
	#base_eudemons_strength{pos = 1,level = 174,attr = [{1,1740},{5,870}],exp = 1476};

get_strength(1,175) ->
	#base_eudemons_strength{pos = 1,level = 175,attr = [{1,1750},{5,875}],exp = 1481};

get_strength(1,176) ->
	#base_eudemons_strength{pos = 1,level = 176,attr = [{1,1760},{5,880}],exp = 1486};

get_strength(1,177) ->
	#base_eudemons_strength{pos = 1,level = 177,attr = [{1,1770},{5,885}],exp = 1490};

get_strength(1,178) ->
	#base_eudemons_strength{pos = 1,level = 178,attr = [{1,1780},{5,890}],exp = 1495};

get_strength(1,179) ->
	#base_eudemons_strength{pos = 1,level = 179,attr = [{1,1790},{5,895}],exp = 1500};

get_strength(1,180) ->
	#base_eudemons_strength{pos = 1,level = 180,attr = [{1,1800},{5,900}],exp = 1505};

get_strength(1,181) ->
	#base_eudemons_strength{pos = 1,level = 181,attr = [{1,1810},{5,905}],exp = 1510};

get_strength(1,182) ->
	#base_eudemons_strength{pos = 1,level = 182,attr = [{1,1820},{5,910}],exp = 1514};

get_strength(1,183) ->
	#base_eudemons_strength{pos = 1,level = 183,attr = [{1,1830},{5,915}],exp = 1519};

get_strength(1,184) ->
	#base_eudemons_strength{pos = 1,level = 184,attr = [{1,1840},{5,920}],exp = 1524};

get_strength(1,185) ->
	#base_eudemons_strength{pos = 1,level = 185,attr = [{1,1850},{5,925}],exp = 1529};

get_strength(1,186) ->
	#base_eudemons_strength{pos = 1,level = 186,attr = [{1,1860},{5,930}],exp = 1534};

get_strength(1,187) ->
	#base_eudemons_strength{pos = 1,level = 187,attr = [{1,1870},{5,935}],exp = 1538};

get_strength(1,188) ->
	#base_eudemons_strength{pos = 1,level = 188,attr = [{1,1880},{5,940}],exp = 1543};

get_strength(1,189) ->
	#base_eudemons_strength{pos = 1,level = 189,attr = [{1,1890},{5,945}],exp = 1548};

get_strength(1,190) ->
	#base_eudemons_strength{pos = 1,level = 190,attr = [{1,1900},{5,950}],exp = 1553};

get_strength(1,191) ->
	#base_eudemons_strength{pos = 1,level = 191,attr = [{1,1910},{5,955}],exp = 1558};

get_strength(1,192) ->
	#base_eudemons_strength{pos = 1,level = 192,attr = [{1,1920},{5,960}],exp = 1562};

get_strength(1,193) ->
	#base_eudemons_strength{pos = 1,level = 193,attr = [{1,1930},{5,965}],exp = 1567};

get_strength(1,194) ->
	#base_eudemons_strength{pos = 1,level = 194,attr = [{1,1940},{5,970}],exp = 1572};

get_strength(1,195) ->
	#base_eudemons_strength{pos = 1,level = 195,attr = [{1,1950},{5,975}],exp = 1577};

get_strength(1,196) ->
	#base_eudemons_strength{pos = 1,level = 196,attr = [{1,1960},{5,980}],exp = 1582};

get_strength(1,197) ->
	#base_eudemons_strength{pos = 1,level = 197,attr = [{1,1970},{5,985}],exp = 1586};

get_strength(1,198) ->
	#base_eudemons_strength{pos = 1,level = 198,attr = [{1,1980},{5,990}],exp = 1591};

get_strength(1,199) ->
	#base_eudemons_strength{pos = 1,level = 199,attr = [{1,1990},{5,995}],exp = 1596};

get_strength(1,200) ->
	#base_eudemons_strength{pos = 1,level = 200,attr = [{1,2000},{5,1000}],exp = 1601};

get_strength(2,1) ->
	#base_eudemons_strength{pos = 2,level = 1,attr = [{3,10},{7,5}],exp = 10};

get_strength(2,2) ->
	#base_eudemons_strength{pos = 2,level = 2,attr = [{3,20},{7,10}],exp = 13};

get_strength(2,3) ->
	#base_eudemons_strength{pos = 2,level = 3,attr = [{3,30},{7,15}],exp = 17};

get_strength(2,4) ->
	#base_eudemons_strength{pos = 2,level = 4,attr = [{3,40},{7,20}],exp = 22};

get_strength(2,5) ->
	#base_eudemons_strength{pos = 2,level = 5,attr = [{3,50},{7,25}],exp = 25};

get_strength(2,6) ->
	#base_eudemons_strength{pos = 2,level = 6,attr = [{3,60},{7,30}],exp = 28};

get_strength(2,7) ->
	#base_eudemons_strength{pos = 2,level = 7,attr = [{3,70},{7,35}],exp = 30};

get_strength(2,8) ->
	#base_eudemons_strength{pos = 2,level = 8,attr = [{3,80},{7,40}],exp = 33};

get_strength(2,9) ->
	#base_eudemons_strength{pos = 2,level = 9,attr = [{3,90},{7,45}],exp = 36};

get_strength(2,10) ->
	#base_eudemons_strength{pos = 2,level = 10,attr = [{3,100},{7,50}],exp = 39};

get_strength(2,11) ->
	#base_eudemons_strength{pos = 2,level = 11,attr = [{3,110},{7,55}],exp = 42};

get_strength(2,12) ->
	#base_eudemons_strength{pos = 2,level = 12,attr = [{3,120},{7,60}],exp = 45};

get_strength(2,13) ->
	#base_eudemons_strength{pos = 2,level = 13,attr = [{3,130},{7,65}],exp = 47};

get_strength(2,14) ->
	#base_eudemons_strength{pos = 2,level = 14,attr = [{3,140},{7,70}],exp = 49};

get_strength(2,15) ->
	#base_eudemons_strength{pos = 2,level = 15,attr = [{3,150},{7,75}],exp = 58};

get_strength(2,16) ->
	#base_eudemons_strength{pos = 2,level = 16,attr = [{3,160},{7,80}],exp = 61};

get_strength(2,17) ->
	#base_eudemons_strength{pos = 2,level = 17,attr = [{3,170},{7,85}],exp = 65};

get_strength(2,18) ->
	#base_eudemons_strength{pos = 2,level = 18,attr = [{3,180},{7,90}],exp = 68};

get_strength(2,19) ->
	#base_eudemons_strength{pos = 2,level = 19,attr = [{3,190},{7,95}],exp = 72};

get_strength(2,20) ->
	#base_eudemons_strength{pos = 2,level = 20,attr = [{3,200},{7,100}],exp = 75};

get_strength(2,21) ->
	#base_eudemons_strength{pos = 2,level = 21,attr = [{3,210},{7,105}],exp = 80};

get_strength(2,22) ->
	#base_eudemons_strength{pos = 2,level = 22,attr = [{3,220},{7,110}],exp = 85};

get_strength(2,23) ->
	#base_eudemons_strength{pos = 2,level = 23,attr = [{3,230},{7,115}],exp = 95};

get_strength(2,24) ->
	#base_eudemons_strength{pos = 2,level = 24,attr = [{3,240},{7,120}],exp = 110};

get_strength(2,25) ->
	#base_eudemons_strength{pos = 2,level = 25,attr = [{3,250},{7,125}],exp = 125};

get_strength(2,26) ->
	#base_eudemons_strength{pos = 2,level = 26,attr = [{3,260},{7,130}],exp = 135};

get_strength(2,27) ->
	#base_eudemons_strength{pos = 2,level = 27,attr = [{3,270},{7,135}],exp = 145};

get_strength(2,28) ->
	#base_eudemons_strength{pos = 2,level = 28,attr = [{3,280},{7,140}],exp = 150};

get_strength(2,29) ->
	#base_eudemons_strength{pos = 2,level = 29,attr = [{3,290},{7,145}],exp = 155};

get_strength(2,30) ->
	#base_eudemons_strength{pos = 2,level = 30,attr = [{3,300},{7,150}],exp = 162};

get_strength(2,31) ->
	#base_eudemons_strength{pos = 2,level = 31,attr = [{3,310},{7,155}],exp = 115};

get_strength(2,32) ->
	#base_eudemons_strength{pos = 2,level = 32,attr = [{3,320},{7,160}],exp = 121};

get_strength(2,33) ->
	#base_eudemons_strength{pos = 2,level = 33,attr = [{3,330},{7,165}],exp = 127};

get_strength(2,34) ->
	#base_eudemons_strength{pos = 2,level = 34,attr = [{3,340},{7,170}],exp = 133};

get_strength(2,35) ->
	#base_eudemons_strength{pos = 2,level = 35,attr = [{3,350},{7,175}],exp = 139};

get_strength(2,36) ->
	#base_eudemons_strength{pos = 2,level = 36,attr = [{3,360},{7,180}],exp = 145};

get_strength(2,37) ->
	#base_eudemons_strength{pos = 2,level = 37,attr = [{3,370},{7,185}],exp = 151};

get_strength(2,38) ->
	#base_eudemons_strength{pos = 2,level = 38,attr = [{3,380},{7,190}],exp = 158};

get_strength(2,39) ->
	#base_eudemons_strength{pos = 2,level = 39,attr = [{3,390},{7,195}],exp = 166};

get_strength(2,40) ->
	#base_eudemons_strength{pos = 2,level = 40,attr = [{3,400},{7,200}],exp = 173};

get_strength(2,41) ->
	#base_eudemons_strength{pos = 2,level = 41,attr = [{3,410},{7,205}],exp = 180};

get_strength(2,42) ->
	#base_eudemons_strength{pos = 2,level = 42,attr = [{3,420},{7,210}],exp = 187};

get_strength(2,43) ->
	#base_eudemons_strength{pos = 2,level = 43,attr = [{3,430},{7,215}],exp = 194};

get_strength(2,44) ->
	#base_eudemons_strength{pos = 2,level = 44,attr = [{3,440},{7,220}],exp = 202};

get_strength(2,45) ->
	#base_eudemons_strength{pos = 2,level = 45,attr = [{3,450},{7,225}],exp = 209};

get_strength(2,46) ->
	#base_eudemons_strength{pos = 2,level = 46,attr = [{3,460},{7,230}],exp = 217};

get_strength(2,47) ->
	#base_eudemons_strength{pos = 2,level = 47,attr = [{3,470},{7,235}],exp = 226};

get_strength(2,48) ->
	#base_eudemons_strength{pos = 2,level = 48,attr = [{3,480},{7,240}],exp = 234};

get_strength(2,49) ->
	#base_eudemons_strength{pos = 2,level = 49,attr = [{3,490},{7,245}],exp = 242};

get_strength(2,50) ->
	#base_eudemons_strength{pos = 2,level = 50,attr = [{3,500},{7,250}],exp = 251};

get_strength(2,51) ->
	#base_eudemons_strength{pos = 2,level = 51,attr = [{3,510},{7,255}],exp = 259};

get_strength(2,52) ->
	#base_eudemons_strength{pos = 2,level = 52,attr = [{3,520},{7,260}],exp = 268};

get_strength(2,53) ->
	#base_eudemons_strength{pos = 2,level = 53,attr = [{3,530},{7,265}],exp = 276};

get_strength(2,54) ->
	#base_eudemons_strength{pos = 2,level = 54,attr = [{3,540},{7,270}],exp = 286};

get_strength(2,55) ->
	#base_eudemons_strength{pos = 2,level = 55,attr = [{3,550},{7,275}],exp = 295};

get_strength(2,56) ->
	#base_eudemons_strength{pos = 2,level = 56,attr = [{3,560},{7,280}],exp = 305};

get_strength(2,57) ->
	#base_eudemons_strength{pos = 2,level = 57,attr = [{3,570},{7,285}],exp = 314};

get_strength(2,58) ->
	#base_eudemons_strength{pos = 2,level = 58,attr = [{3,580},{7,290}],exp = 324};

get_strength(2,59) ->
	#base_eudemons_strength{pos = 2,level = 59,attr = [{3,590},{7,295}],exp = 334};

get_strength(2,60) ->
	#base_eudemons_strength{pos = 2,level = 60,attr = [{3,600},{7,300}],exp = 343};

get_strength(2,61) ->
	#base_eudemons_strength{pos = 2,level = 61,attr = [{3,610},{7,305}],exp = 353};

get_strength(2,62) ->
	#base_eudemons_strength{pos = 2,level = 62,attr = [{3,620},{7,310}],exp = 364};

get_strength(2,63) ->
	#base_eudemons_strength{pos = 2,level = 63,attr = [{3,630},{7,315}],exp = 374};

get_strength(2,64) ->
	#base_eudemons_strength{pos = 2,level = 64,attr = [{3,640},{7,320}],exp = 385};

get_strength(2,65) ->
	#base_eudemons_strength{pos = 2,level = 65,attr = [{3,650},{7,325}],exp = 396};

get_strength(2,66) ->
	#base_eudemons_strength{pos = 2,level = 66,attr = [{3,660},{7,330}],exp = 407};

get_strength(2,67) ->
	#base_eudemons_strength{pos = 2,level = 67,attr = [{3,670},{7,335}],exp = 418};

get_strength(2,68) ->
	#base_eudemons_strength{pos = 2,level = 68,attr = [{3,680},{7,340}],exp = 428};

get_strength(2,69) ->
	#base_eudemons_strength{pos = 2,level = 69,attr = [{3,690},{7,345}],exp = 439};

get_strength(2,70) ->
	#base_eudemons_strength{pos = 2,level = 70,attr = [{3,700},{7,350}],exp = 451};

get_strength(2,71) ->
	#base_eudemons_strength{pos = 2,level = 71,attr = [{3,710},{7,355}],exp = 463};

get_strength(2,72) ->
	#base_eudemons_strength{pos = 2,level = 72,attr = [{3,720},{7,360}],exp = 475};

get_strength(2,73) ->
	#base_eudemons_strength{pos = 2,level = 73,attr = [{3,730},{7,365}],exp = 487};

get_strength(2,74) ->
	#base_eudemons_strength{pos = 2,level = 74,attr = [{3,740},{7,370}],exp = 499};

get_strength(2,75) ->
	#base_eudemons_strength{pos = 2,level = 75,attr = [{3,750},{7,375}],exp = 511};

get_strength(2,76) ->
	#base_eudemons_strength{pos = 2,level = 76,attr = [{3,760},{7,380}],exp = 523};

get_strength(2,77) ->
	#base_eudemons_strength{pos = 2,level = 77,attr = [{3,770},{7,385}],exp = 535};

get_strength(2,78) ->
	#base_eudemons_strength{pos = 2,level = 78,attr = [{3,780},{7,390}],exp = 548};

get_strength(2,79) ->
	#base_eudemons_strength{pos = 2,level = 79,attr = [{3,790},{7,395}],exp = 562};

get_strength(2,80) ->
	#base_eudemons_strength{pos = 2,level = 80,attr = [{3,800},{7,400}],exp = 575};

get_strength(2,81) ->
	#base_eudemons_strength{pos = 2,level = 81,attr = [{3,810},{7,405}],exp = 588};

get_strength(2,82) ->
	#base_eudemons_strength{pos = 2,level = 82,attr = [{3,820},{7,410}],exp = 601};

get_strength(2,83) ->
	#base_eudemons_strength{pos = 2,level = 83,attr = [{3,830},{7,415}],exp = 614};

get_strength(2,84) ->
	#base_eudemons_strength{pos = 2,level = 84,attr = [{3,840},{7,420}],exp = 628};

get_strength(2,85) ->
	#base_eudemons_strength{pos = 2,level = 85,attr = [{3,850},{7,425}],exp = 641};

get_strength(2,86) ->
	#base_eudemons_strength{pos = 2,level = 86,attr = [{3,860},{7,430}],exp = 655};

get_strength(2,87) ->
	#base_eudemons_strength{pos = 2,level = 87,attr = [{3,870},{7,435}],exp = 670};

get_strength(2,88) ->
	#base_eudemons_strength{pos = 2,level = 88,attr = [{3,880},{7,440}],exp = 684};

get_strength(2,89) ->
	#base_eudemons_strength{pos = 2,level = 89,attr = [{3,890},{7,445}],exp = 698};

get_strength(2,90) ->
	#base_eudemons_strength{pos = 2,level = 90,attr = [{3,900},{7,450}],exp = 713};

get_strength(2,91) ->
	#base_eudemons_strength{pos = 2,level = 91,attr = [{3,910},{7,455}],exp = 727};

get_strength(2,92) ->
	#base_eudemons_strength{pos = 2,level = 92,attr = [{3,920},{7,460}],exp = 742};

get_strength(2,93) ->
	#base_eudemons_strength{pos = 2,level = 93,attr = [{3,930},{7,465}],exp = 756};

get_strength(2,94) ->
	#base_eudemons_strength{pos = 2,level = 94,attr = [{3,940},{7,470}],exp = 772};

get_strength(2,95) ->
	#base_eudemons_strength{pos = 2,level = 95,attr = [{3,950},{7,475}],exp = 787};

get_strength(2,96) ->
	#base_eudemons_strength{pos = 2,level = 96,attr = [{3,960},{7,480}],exp = 803};

get_strength(2,97) ->
	#base_eudemons_strength{pos = 2,level = 97,attr = [{3,970},{7,485}],exp = 818};

get_strength(2,98) ->
	#base_eudemons_strength{pos = 2,level = 98,attr = [{3,980},{7,490}],exp = 834};

get_strength(2,99) ->
	#base_eudemons_strength{pos = 2,level = 99,attr = [{3,990},{7,495}],exp = 850};

get_strength(2,100) ->
	#base_eudemons_strength{pos = 2,level = 100,attr = [{3,1000},{7,500}],exp = 865};

get_strength(2,101) ->
	#base_eudemons_strength{pos = 2,level = 101,attr = [{3,1010},{7,505}],exp = 881};

get_strength(2,102) ->
	#base_eudemons_strength{pos = 2,level = 102,attr = [{3,1020},{7,510}],exp = 898};

get_strength(2,103) ->
	#base_eudemons_strength{pos = 2,level = 103,attr = [{3,1030},{7,515}],exp = 914};

get_strength(2,104) ->
	#base_eudemons_strength{pos = 2,level = 104,attr = [{3,1040},{7,520}],exp = 931};

get_strength(2,105) ->
	#base_eudemons_strength{pos = 2,level = 105,attr = [{3,1050},{7,525}],exp = 948};

get_strength(2,106) ->
	#base_eudemons_strength{pos = 2,level = 106,attr = [{3,1060},{7,530}],exp = 965};

get_strength(2,107) ->
	#base_eudemons_strength{pos = 2,level = 107,attr = [{3,1070},{7,535}],exp = 982};

get_strength(2,108) ->
	#base_eudemons_strength{pos = 2,level = 108,attr = [{3,1080},{7,540}],exp = 998};

get_strength(2,109) ->
	#base_eudemons_strength{pos = 2,level = 109,attr = [{3,1090},{7,545}],exp = 1015};

get_strength(2,110) ->
	#base_eudemons_strength{pos = 2,level = 110,attr = [{3,1100},{7,550}],exp = 1033};

get_strength(2,111) ->
	#base_eudemons_strength{pos = 2,level = 111,attr = [{3,1110},{7,555}],exp = 1051};

get_strength(2,112) ->
	#base_eudemons_strength{pos = 2,level = 112,attr = [{3,1120},{7,560}],exp = 1069};

get_strength(2,113) ->
	#base_eudemons_strength{pos = 2,level = 113,attr = [{3,1130},{7,565}],exp = 1087};

get_strength(2,114) ->
	#base_eudemons_strength{pos = 2,level = 114,attr = [{3,1140},{7,570}],exp = 1105};

get_strength(2,115) ->
	#base_eudemons_strength{pos = 2,level = 115,attr = [{3,1150},{7,575}],exp = 1123};

get_strength(2,116) ->
	#base_eudemons_strength{pos = 2,level = 116,attr = [{3,1160},{7,580}],exp = 1141};

get_strength(2,117) ->
	#base_eudemons_strength{pos = 2,level = 117,attr = [{3,1170},{7,585}],exp = 1159};

get_strength(2,118) ->
	#base_eudemons_strength{pos = 2,level = 118,attr = [{3,1180},{7,590}],exp = 1178};

get_strength(2,119) ->
	#base_eudemons_strength{pos = 2,level = 119,attr = [{3,1190},{7,595}],exp = 1198};

get_strength(2,120) ->
	#base_eudemons_strength{pos = 2,level = 120,attr = [{3,1200},{7,600}],exp = 1217};

get_strength(2,121) ->
	#base_eudemons_strength{pos = 2,level = 121,attr = [{3,1210},{7,605}],exp = 1222};

get_strength(2,122) ->
	#base_eudemons_strength{pos = 2,level = 122,attr = [{3,1220},{7,610}],exp = 1226};

get_strength(2,123) ->
	#base_eudemons_strength{pos = 2,level = 123,attr = [{3,1230},{7,615}],exp = 1231};

get_strength(2,124) ->
	#base_eudemons_strength{pos = 2,level = 124,attr = [{3,1240},{7,620}],exp = 1236};

get_strength(2,125) ->
	#base_eudemons_strength{pos = 2,level = 125,attr = [{3,1250},{7,625}],exp = 1241};

get_strength(2,126) ->
	#base_eudemons_strength{pos = 2,level = 126,attr = [{3,1260},{7,630}],exp = 1246};

get_strength(2,127) ->
	#base_eudemons_strength{pos = 2,level = 127,attr = [{3,1270},{7,635}],exp = 1250};

get_strength(2,128) ->
	#base_eudemons_strength{pos = 2,level = 128,attr = [{3,1280},{7,640}],exp = 1255};

get_strength(2,129) ->
	#base_eudemons_strength{pos = 2,level = 129,attr = [{3,1290},{7,645}],exp = 1260};

get_strength(2,130) ->
	#base_eudemons_strength{pos = 2,level = 130,attr = [{3,1300},{7,650}],exp = 1265};

get_strength(2,131) ->
	#base_eudemons_strength{pos = 2,level = 131,attr = [{3,1310},{7,655}],exp = 1270};

get_strength(2,132) ->
	#base_eudemons_strength{pos = 2,level = 132,attr = [{3,1320},{7,660}],exp = 1274};

get_strength(2,133) ->
	#base_eudemons_strength{pos = 2,level = 133,attr = [{3,1330},{7,665}],exp = 1279};

get_strength(2,134) ->
	#base_eudemons_strength{pos = 2,level = 134,attr = [{3,1340},{7,670}],exp = 1284};

get_strength(2,135) ->
	#base_eudemons_strength{pos = 2,level = 135,attr = [{3,1350},{7,675}],exp = 1289};

get_strength(2,136) ->
	#base_eudemons_strength{pos = 2,level = 136,attr = [{3,1360},{7,680}],exp = 1294};

get_strength(2,137) ->
	#base_eudemons_strength{pos = 2,level = 137,attr = [{3,1370},{7,685}],exp = 1298};

get_strength(2,138) ->
	#base_eudemons_strength{pos = 2,level = 138,attr = [{3,1380},{7,690}],exp = 1303};

get_strength(2,139) ->
	#base_eudemons_strength{pos = 2,level = 139,attr = [{3,1390},{7,695}],exp = 1308};

get_strength(2,140) ->
	#base_eudemons_strength{pos = 2,level = 140,attr = [{3,1400},{7,700}],exp = 1313};

get_strength(2,141) ->
	#base_eudemons_strength{pos = 2,level = 141,attr = [{3,1410},{7,705}],exp = 1318};

get_strength(2,142) ->
	#base_eudemons_strength{pos = 2,level = 142,attr = [{3,1420},{7,710}],exp = 1322};

get_strength(2,143) ->
	#base_eudemons_strength{pos = 2,level = 143,attr = [{3,1430},{7,715}],exp = 1327};

get_strength(2,144) ->
	#base_eudemons_strength{pos = 2,level = 144,attr = [{3,1440},{7,720}],exp = 1332};

get_strength(2,145) ->
	#base_eudemons_strength{pos = 2,level = 145,attr = [{3,1450},{7,725}],exp = 1337};

get_strength(2,146) ->
	#base_eudemons_strength{pos = 2,level = 146,attr = [{3,1460},{7,730}],exp = 1342};

get_strength(2,147) ->
	#base_eudemons_strength{pos = 2,level = 147,attr = [{3,1470},{7,735}],exp = 1346};

get_strength(2,148) ->
	#base_eudemons_strength{pos = 2,level = 148,attr = [{3,1480},{7,740}],exp = 1351};

get_strength(2,149) ->
	#base_eudemons_strength{pos = 2,level = 149,attr = [{3,1490},{7,745}],exp = 1356};

get_strength(2,150) ->
	#base_eudemons_strength{pos = 2,level = 150,attr = [{3,1500},{7,750}],exp = 1361};

get_strength(2,151) ->
	#base_eudemons_strength{pos = 2,level = 151,attr = [{3,1510},{7,755}],exp = 1366};

get_strength(2,152) ->
	#base_eudemons_strength{pos = 2,level = 152,attr = [{3,1520},{7,760}],exp = 1370};

get_strength(2,153) ->
	#base_eudemons_strength{pos = 2,level = 153,attr = [{3,1530},{7,765}],exp = 1375};

get_strength(2,154) ->
	#base_eudemons_strength{pos = 2,level = 154,attr = [{3,1540},{7,770}],exp = 1380};

get_strength(2,155) ->
	#base_eudemons_strength{pos = 2,level = 155,attr = [{3,1550},{7,775}],exp = 1385};

get_strength(2,156) ->
	#base_eudemons_strength{pos = 2,level = 156,attr = [{3,1560},{7,780}],exp = 1390};

get_strength(2,157) ->
	#base_eudemons_strength{pos = 2,level = 157,attr = [{3,1570},{7,785}],exp = 1394};

get_strength(2,158) ->
	#base_eudemons_strength{pos = 2,level = 158,attr = [{3,1580},{7,790}],exp = 1399};

get_strength(2,159) ->
	#base_eudemons_strength{pos = 2,level = 159,attr = [{3,1590},{7,795}],exp = 1404};

get_strength(2,160) ->
	#base_eudemons_strength{pos = 2,level = 160,attr = [{3,1600},{7,800}],exp = 1409};

get_strength(2,161) ->
	#base_eudemons_strength{pos = 2,level = 161,attr = [{3,1610},{7,805}],exp = 1414};

get_strength(2,162) ->
	#base_eudemons_strength{pos = 2,level = 162,attr = [{3,1620},{7,810}],exp = 1418};

get_strength(2,163) ->
	#base_eudemons_strength{pos = 2,level = 163,attr = [{3,1630},{7,815}],exp = 1423};

get_strength(2,164) ->
	#base_eudemons_strength{pos = 2,level = 164,attr = [{3,1640},{7,820}],exp = 1428};

get_strength(2,165) ->
	#base_eudemons_strength{pos = 2,level = 165,attr = [{3,1650},{7,825}],exp = 1433};

get_strength(2,166) ->
	#base_eudemons_strength{pos = 2,level = 166,attr = [{3,1660},{7,830}],exp = 1438};

get_strength(2,167) ->
	#base_eudemons_strength{pos = 2,level = 167,attr = [{3,1670},{7,835}],exp = 1442};

get_strength(2,168) ->
	#base_eudemons_strength{pos = 2,level = 168,attr = [{3,1680},{7,840}],exp = 1447};

get_strength(2,169) ->
	#base_eudemons_strength{pos = 2,level = 169,attr = [{3,1690},{7,845}],exp = 1452};

get_strength(2,170) ->
	#base_eudemons_strength{pos = 2,level = 170,attr = [{3,1700},{7,850}],exp = 1457};

get_strength(2,171) ->
	#base_eudemons_strength{pos = 2,level = 171,attr = [{3,1710},{7,855}],exp = 1462};

get_strength(2,172) ->
	#base_eudemons_strength{pos = 2,level = 172,attr = [{3,1720},{7,860}],exp = 1466};

get_strength(2,173) ->
	#base_eudemons_strength{pos = 2,level = 173,attr = [{3,1730},{7,865}],exp = 1471};

get_strength(2,174) ->
	#base_eudemons_strength{pos = 2,level = 174,attr = [{3,1740},{7,870}],exp = 1476};

get_strength(2,175) ->
	#base_eudemons_strength{pos = 2,level = 175,attr = [{3,1750},{7,875}],exp = 1481};

get_strength(2,176) ->
	#base_eudemons_strength{pos = 2,level = 176,attr = [{3,1760},{7,880}],exp = 1486};

get_strength(2,177) ->
	#base_eudemons_strength{pos = 2,level = 177,attr = [{3,1770},{7,885}],exp = 1490};

get_strength(2,178) ->
	#base_eudemons_strength{pos = 2,level = 178,attr = [{3,1780},{7,890}],exp = 1495};

get_strength(2,179) ->
	#base_eudemons_strength{pos = 2,level = 179,attr = [{3,1790},{7,895}],exp = 1500};

get_strength(2,180) ->
	#base_eudemons_strength{pos = 2,level = 180,attr = [{3,1800},{7,900}],exp = 1505};

get_strength(2,181) ->
	#base_eudemons_strength{pos = 2,level = 181,attr = [{3,1810},{7,905}],exp = 1510};

get_strength(2,182) ->
	#base_eudemons_strength{pos = 2,level = 182,attr = [{3,1820},{7,910}],exp = 1514};

get_strength(2,183) ->
	#base_eudemons_strength{pos = 2,level = 183,attr = [{3,1830},{7,915}],exp = 1519};

get_strength(2,184) ->
	#base_eudemons_strength{pos = 2,level = 184,attr = [{3,1840},{7,920}],exp = 1524};

get_strength(2,185) ->
	#base_eudemons_strength{pos = 2,level = 185,attr = [{3,1850},{7,925}],exp = 1529};

get_strength(2,186) ->
	#base_eudemons_strength{pos = 2,level = 186,attr = [{3,1860},{7,930}],exp = 1534};

get_strength(2,187) ->
	#base_eudemons_strength{pos = 2,level = 187,attr = [{3,1870},{7,935}],exp = 1538};

get_strength(2,188) ->
	#base_eudemons_strength{pos = 2,level = 188,attr = [{3,1880},{7,940}],exp = 1543};

get_strength(2,189) ->
	#base_eudemons_strength{pos = 2,level = 189,attr = [{3,1890},{7,945}],exp = 1548};

get_strength(2,190) ->
	#base_eudemons_strength{pos = 2,level = 190,attr = [{3,1900},{7,950}],exp = 1553};

get_strength(2,191) ->
	#base_eudemons_strength{pos = 2,level = 191,attr = [{3,1910},{7,955}],exp = 1558};

get_strength(2,192) ->
	#base_eudemons_strength{pos = 2,level = 192,attr = [{3,1920},{7,960}],exp = 1562};

get_strength(2,193) ->
	#base_eudemons_strength{pos = 2,level = 193,attr = [{3,1930},{7,965}],exp = 1567};

get_strength(2,194) ->
	#base_eudemons_strength{pos = 2,level = 194,attr = [{3,1940},{7,970}],exp = 1572};

get_strength(2,195) ->
	#base_eudemons_strength{pos = 2,level = 195,attr = [{3,1950},{7,975}],exp = 1577};

get_strength(2,196) ->
	#base_eudemons_strength{pos = 2,level = 196,attr = [{3,1960},{7,980}],exp = 1582};

get_strength(2,197) ->
	#base_eudemons_strength{pos = 2,level = 197,attr = [{3,1970},{7,985}],exp = 1586};

get_strength(2,198) ->
	#base_eudemons_strength{pos = 2,level = 198,attr = [{3,1980},{7,990}],exp = 1591};

get_strength(2,199) ->
	#base_eudemons_strength{pos = 2,level = 199,attr = [{3,1990},{7,995}],exp = 1596};

get_strength(2,200) ->
	#base_eudemons_strength{pos = 2,level = 200,attr = [{3,2000},{7,1000}],exp = 1601};

get_strength(3,1) ->
	#base_eudemons_strength{pos = 3,level = 1,attr = [{2,200},{6,5}],exp = 10};

get_strength(3,2) ->
	#base_eudemons_strength{pos = 3,level = 2,attr = [{2,400},{6,10}],exp = 13};

get_strength(3,3) ->
	#base_eudemons_strength{pos = 3,level = 3,attr = [{2,600},{6,15}],exp = 17};

get_strength(3,4) ->
	#base_eudemons_strength{pos = 3,level = 4,attr = [{2,800},{6,20}],exp = 22};

get_strength(3,5) ->
	#base_eudemons_strength{pos = 3,level = 5,attr = [{2,1000},{6,25}],exp = 25};

get_strength(3,6) ->
	#base_eudemons_strength{pos = 3,level = 6,attr = [{2,1200},{6,30}],exp = 28};

get_strength(3,7) ->
	#base_eudemons_strength{pos = 3,level = 7,attr = [{2,1400},{6,35}],exp = 30};

get_strength(3,8) ->
	#base_eudemons_strength{pos = 3,level = 8,attr = [{2,1600},{6,40}],exp = 33};

get_strength(3,9) ->
	#base_eudemons_strength{pos = 3,level = 9,attr = [{2,1800},{6,45}],exp = 36};

get_strength(3,10) ->
	#base_eudemons_strength{pos = 3,level = 10,attr = [{2,2000},{6,50}],exp = 39};

get_strength(3,11) ->
	#base_eudemons_strength{pos = 3,level = 11,attr = [{2,2200},{6,55}],exp = 42};

get_strength(3,12) ->
	#base_eudemons_strength{pos = 3,level = 12,attr = [{2,2400},{6,60}],exp = 45};

get_strength(3,13) ->
	#base_eudemons_strength{pos = 3,level = 13,attr = [{2,2600},{6,65}],exp = 47};

get_strength(3,14) ->
	#base_eudemons_strength{pos = 3,level = 14,attr = [{2,2800},{6,70}],exp = 49};

get_strength(3,15) ->
	#base_eudemons_strength{pos = 3,level = 15,attr = [{2,3000},{6,75}],exp = 58};

get_strength(3,16) ->
	#base_eudemons_strength{pos = 3,level = 16,attr = [{2,3200},{6,80}],exp = 61};

get_strength(3,17) ->
	#base_eudemons_strength{pos = 3,level = 17,attr = [{2,3400},{6,85}],exp = 65};

get_strength(3,18) ->
	#base_eudemons_strength{pos = 3,level = 18,attr = [{2,3600},{6,90}],exp = 68};

get_strength(3,19) ->
	#base_eudemons_strength{pos = 3,level = 19,attr = [{2,3800},{6,95}],exp = 72};

get_strength(3,20) ->
	#base_eudemons_strength{pos = 3,level = 20,attr = [{2,4000},{6,100}],exp = 75};

get_strength(3,21) ->
	#base_eudemons_strength{pos = 3,level = 21,attr = [{2,4200},{6,105}],exp = 80};

get_strength(3,22) ->
	#base_eudemons_strength{pos = 3,level = 22,attr = [{2,4400},{6,110}],exp = 85};

get_strength(3,23) ->
	#base_eudemons_strength{pos = 3,level = 23,attr = [{2,4600},{6,115}],exp = 95};

get_strength(3,24) ->
	#base_eudemons_strength{pos = 3,level = 24,attr = [{2,4800},{6,120}],exp = 110};

get_strength(3,25) ->
	#base_eudemons_strength{pos = 3,level = 25,attr = [{2,5000},{6,125}],exp = 125};

get_strength(3,26) ->
	#base_eudemons_strength{pos = 3,level = 26,attr = [{2,5200},{6,130}],exp = 135};

get_strength(3,27) ->
	#base_eudemons_strength{pos = 3,level = 27,attr = [{2,5400},{6,135}],exp = 145};

get_strength(3,28) ->
	#base_eudemons_strength{pos = 3,level = 28,attr = [{2,5600},{6,140}],exp = 150};

get_strength(3,29) ->
	#base_eudemons_strength{pos = 3,level = 29,attr = [{2,5800},{6,145}],exp = 155};

get_strength(3,30) ->
	#base_eudemons_strength{pos = 3,level = 30,attr = [{2,6000},{6,150}],exp = 162};

get_strength(3,31) ->
	#base_eudemons_strength{pos = 3,level = 31,attr = [{2,6200},{6,155}],exp = 115};

get_strength(3,32) ->
	#base_eudemons_strength{pos = 3,level = 32,attr = [{2,6400},{6,160}],exp = 121};

get_strength(3,33) ->
	#base_eudemons_strength{pos = 3,level = 33,attr = [{2,6600},{6,165}],exp = 127};

get_strength(3,34) ->
	#base_eudemons_strength{pos = 3,level = 34,attr = [{2,6800},{6,170}],exp = 133};

get_strength(3,35) ->
	#base_eudemons_strength{pos = 3,level = 35,attr = [{2,7000},{6,175}],exp = 139};

get_strength(3,36) ->
	#base_eudemons_strength{pos = 3,level = 36,attr = [{2,7200},{6,180}],exp = 145};

get_strength(3,37) ->
	#base_eudemons_strength{pos = 3,level = 37,attr = [{2,7400},{6,185}],exp = 151};

get_strength(3,38) ->
	#base_eudemons_strength{pos = 3,level = 38,attr = [{2,7600},{6,190}],exp = 158};

get_strength(3,39) ->
	#base_eudemons_strength{pos = 3,level = 39,attr = [{2,7800},{6,195}],exp = 166};

get_strength(3,40) ->
	#base_eudemons_strength{pos = 3,level = 40,attr = [{2,8000},{6,200}],exp = 173};

get_strength(3,41) ->
	#base_eudemons_strength{pos = 3,level = 41,attr = [{2,8200},{6,205}],exp = 180};

get_strength(3,42) ->
	#base_eudemons_strength{pos = 3,level = 42,attr = [{2,8400},{6,210}],exp = 187};

get_strength(3,43) ->
	#base_eudemons_strength{pos = 3,level = 43,attr = [{2,8600},{6,215}],exp = 194};

get_strength(3,44) ->
	#base_eudemons_strength{pos = 3,level = 44,attr = [{2,8800},{6,220}],exp = 202};

get_strength(3,45) ->
	#base_eudemons_strength{pos = 3,level = 45,attr = [{2,9000},{6,225}],exp = 209};

get_strength(3,46) ->
	#base_eudemons_strength{pos = 3,level = 46,attr = [{2,9200},{6,230}],exp = 217};

get_strength(3,47) ->
	#base_eudemons_strength{pos = 3,level = 47,attr = [{2,9400},{6,235}],exp = 226};

get_strength(3,48) ->
	#base_eudemons_strength{pos = 3,level = 48,attr = [{2,9600},{6,240}],exp = 234};

get_strength(3,49) ->
	#base_eudemons_strength{pos = 3,level = 49,attr = [{2,9800},{6,245}],exp = 242};

get_strength(3,50) ->
	#base_eudemons_strength{pos = 3,level = 50,attr = [{2,10000},{6,250}],exp = 251};

get_strength(3,51) ->
	#base_eudemons_strength{pos = 3,level = 51,attr = [{2,10200},{6,255}],exp = 259};

get_strength(3,52) ->
	#base_eudemons_strength{pos = 3,level = 52,attr = [{2,10400},{6,260}],exp = 268};

get_strength(3,53) ->
	#base_eudemons_strength{pos = 3,level = 53,attr = [{2,10600},{6,265}],exp = 276};

get_strength(3,54) ->
	#base_eudemons_strength{pos = 3,level = 54,attr = [{2,10800},{6,270}],exp = 286};

get_strength(3,55) ->
	#base_eudemons_strength{pos = 3,level = 55,attr = [{2,11000},{6,275}],exp = 295};

get_strength(3,56) ->
	#base_eudemons_strength{pos = 3,level = 56,attr = [{2,11200},{6,280}],exp = 305};

get_strength(3,57) ->
	#base_eudemons_strength{pos = 3,level = 57,attr = [{2,11400},{6,285}],exp = 314};

get_strength(3,58) ->
	#base_eudemons_strength{pos = 3,level = 58,attr = [{2,11600},{6,290}],exp = 324};

get_strength(3,59) ->
	#base_eudemons_strength{pos = 3,level = 59,attr = [{2,11800},{6,295}],exp = 334};

get_strength(3,60) ->
	#base_eudemons_strength{pos = 3,level = 60,attr = [{2,12000},{6,300}],exp = 343};

get_strength(3,61) ->
	#base_eudemons_strength{pos = 3,level = 61,attr = [{2,12200},{6,305}],exp = 353};

get_strength(3,62) ->
	#base_eudemons_strength{pos = 3,level = 62,attr = [{2,12400},{6,310}],exp = 364};

get_strength(3,63) ->
	#base_eudemons_strength{pos = 3,level = 63,attr = [{2,12600},{6,315}],exp = 374};

get_strength(3,64) ->
	#base_eudemons_strength{pos = 3,level = 64,attr = [{2,12800},{6,320}],exp = 385};

get_strength(3,65) ->
	#base_eudemons_strength{pos = 3,level = 65,attr = [{2,13000},{6,325}],exp = 396};

get_strength(3,66) ->
	#base_eudemons_strength{pos = 3,level = 66,attr = [{2,13200},{6,330}],exp = 407};

get_strength(3,67) ->
	#base_eudemons_strength{pos = 3,level = 67,attr = [{2,13400},{6,335}],exp = 418};

get_strength(3,68) ->
	#base_eudemons_strength{pos = 3,level = 68,attr = [{2,13600},{6,340}],exp = 428};

get_strength(3,69) ->
	#base_eudemons_strength{pos = 3,level = 69,attr = [{2,13800},{6,345}],exp = 439};

get_strength(3,70) ->
	#base_eudemons_strength{pos = 3,level = 70,attr = [{2,14000},{6,350}],exp = 451};

get_strength(3,71) ->
	#base_eudemons_strength{pos = 3,level = 71,attr = [{2,14200},{6,355}],exp = 463};

get_strength(3,72) ->
	#base_eudemons_strength{pos = 3,level = 72,attr = [{2,14400},{6,360}],exp = 475};

get_strength(3,73) ->
	#base_eudemons_strength{pos = 3,level = 73,attr = [{2,14600},{6,365}],exp = 487};

get_strength(3,74) ->
	#base_eudemons_strength{pos = 3,level = 74,attr = [{2,14800},{6,370}],exp = 499};

get_strength(3,75) ->
	#base_eudemons_strength{pos = 3,level = 75,attr = [{2,15000},{6,375}],exp = 511};

get_strength(3,76) ->
	#base_eudemons_strength{pos = 3,level = 76,attr = [{2,15200},{6,380}],exp = 523};

get_strength(3,77) ->
	#base_eudemons_strength{pos = 3,level = 77,attr = [{2,15400},{6,385}],exp = 535};

get_strength(3,78) ->
	#base_eudemons_strength{pos = 3,level = 78,attr = [{2,15600},{6,390}],exp = 548};

get_strength(3,79) ->
	#base_eudemons_strength{pos = 3,level = 79,attr = [{2,15800},{6,395}],exp = 562};

get_strength(3,80) ->
	#base_eudemons_strength{pos = 3,level = 80,attr = [{2,16000},{6,400}],exp = 575};

get_strength(3,81) ->
	#base_eudemons_strength{pos = 3,level = 81,attr = [{2,16200},{6,405}],exp = 588};

get_strength(3,82) ->
	#base_eudemons_strength{pos = 3,level = 82,attr = [{2,16400},{6,410}],exp = 601};

get_strength(3,83) ->
	#base_eudemons_strength{pos = 3,level = 83,attr = [{2,16600},{6,415}],exp = 614};

get_strength(3,84) ->
	#base_eudemons_strength{pos = 3,level = 84,attr = [{2,16800},{6,420}],exp = 628};

get_strength(3,85) ->
	#base_eudemons_strength{pos = 3,level = 85,attr = [{2,17000},{6,425}],exp = 641};

get_strength(3,86) ->
	#base_eudemons_strength{pos = 3,level = 86,attr = [{2,17200},{6,430}],exp = 655};

get_strength(3,87) ->
	#base_eudemons_strength{pos = 3,level = 87,attr = [{2,17400},{6,435}],exp = 670};

get_strength(3,88) ->
	#base_eudemons_strength{pos = 3,level = 88,attr = [{2,17600},{6,440}],exp = 684};

get_strength(3,89) ->
	#base_eudemons_strength{pos = 3,level = 89,attr = [{2,17800},{6,445}],exp = 698};

get_strength(3,90) ->
	#base_eudemons_strength{pos = 3,level = 90,attr = [{2,18000},{6,450}],exp = 713};

get_strength(3,91) ->
	#base_eudemons_strength{pos = 3,level = 91,attr = [{2,18200},{6,455}],exp = 727};

get_strength(3,92) ->
	#base_eudemons_strength{pos = 3,level = 92,attr = [{2,18400},{6,460}],exp = 742};

get_strength(3,93) ->
	#base_eudemons_strength{pos = 3,level = 93,attr = [{2,18600},{6,465}],exp = 756};

get_strength(3,94) ->
	#base_eudemons_strength{pos = 3,level = 94,attr = [{2,18800},{6,470}],exp = 772};

get_strength(3,95) ->
	#base_eudemons_strength{pos = 3,level = 95,attr = [{2,19000},{6,475}],exp = 787};

get_strength(3,96) ->
	#base_eudemons_strength{pos = 3,level = 96,attr = [{2,19200},{6,480}],exp = 803};

get_strength(3,97) ->
	#base_eudemons_strength{pos = 3,level = 97,attr = [{2,19400},{6,485}],exp = 818};

get_strength(3,98) ->
	#base_eudemons_strength{pos = 3,level = 98,attr = [{2,19600},{6,490}],exp = 834};

get_strength(3,99) ->
	#base_eudemons_strength{pos = 3,level = 99,attr = [{2,19800},{6,495}],exp = 850};

get_strength(3,100) ->
	#base_eudemons_strength{pos = 3,level = 100,attr = [{2,20000},{6,500}],exp = 865};

get_strength(3,101) ->
	#base_eudemons_strength{pos = 3,level = 101,attr = [{2,20200},{6,505}],exp = 881};

get_strength(3,102) ->
	#base_eudemons_strength{pos = 3,level = 102,attr = [{2,20400},{6,510}],exp = 898};

get_strength(3,103) ->
	#base_eudemons_strength{pos = 3,level = 103,attr = [{2,20600},{6,515}],exp = 914};

get_strength(3,104) ->
	#base_eudemons_strength{pos = 3,level = 104,attr = [{2,20800},{6,520}],exp = 931};

get_strength(3,105) ->
	#base_eudemons_strength{pos = 3,level = 105,attr = [{2,21000},{6,525}],exp = 948};

get_strength(3,106) ->
	#base_eudemons_strength{pos = 3,level = 106,attr = [{2,21200},{6,530}],exp = 965};

get_strength(3,107) ->
	#base_eudemons_strength{pos = 3,level = 107,attr = [{2,21400},{6,535}],exp = 982};

get_strength(3,108) ->
	#base_eudemons_strength{pos = 3,level = 108,attr = [{2,21600},{6,540}],exp = 998};

get_strength(3,109) ->
	#base_eudemons_strength{pos = 3,level = 109,attr = [{2,21800},{6,545}],exp = 1015};

get_strength(3,110) ->
	#base_eudemons_strength{pos = 3,level = 110,attr = [{2,22000},{6,550}],exp = 1033};

get_strength(3,111) ->
	#base_eudemons_strength{pos = 3,level = 111,attr = [{2,22200},{6,555}],exp = 1051};

get_strength(3,112) ->
	#base_eudemons_strength{pos = 3,level = 112,attr = [{2,22400},{6,560}],exp = 1069};

get_strength(3,113) ->
	#base_eudemons_strength{pos = 3,level = 113,attr = [{2,22600},{6,565}],exp = 1087};

get_strength(3,114) ->
	#base_eudemons_strength{pos = 3,level = 114,attr = [{2,22800},{6,570}],exp = 1105};

get_strength(3,115) ->
	#base_eudemons_strength{pos = 3,level = 115,attr = [{2,23000},{6,575}],exp = 1123};

get_strength(3,116) ->
	#base_eudemons_strength{pos = 3,level = 116,attr = [{2,23200},{6,580}],exp = 1141};

get_strength(3,117) ->
	#base_eudemons_strength{pos = 3,level = 117,attr = [{2,23400},{6,585}],exp = 1159};

get_strength(3,118) ->
	#base_eudemons_strength{pos = 3,level = 118,attr = [{2,23600},{6,590}],exp = 1178};

get_strength(3,119) ->
	#base_eudemons_strength{pos = 3,level = 119,attr = [{2,23800},{6,595}],exp = 1198};

get_strength(3,120) ->
	#base_eudemons_strength{pos = 3,level = 120,attr = [{2,24000},{6,600}],exp = 1217};

get_strength(3,121) ->
	#base_eudemons_strength{pos = 3,level = 121,attr = [{2,24200},{6,605}],exp = 1222};

get_strength(3,122) ->
	#base_eudemons_strength{pos = 3,level = 122,attr = [{2,24400},{6,610}],exp = 1226};

get_strength(3,123) ->
	#base_eudemons_strength{pos = 3,level = 123,attr = [{2,24600},{6,615}],exp = 1231};

get_strength(3,124) ->
	#base_eudemons_strength{pos = 3,level = 124,attr = [{2,24800},{6,620}],exp = 1236};

get_strength(3,125) ->
	#base_eudemons_strength{pos = 3,level = 125,attr = [{2,25000},{6,625}],exp = 1241};

get_strength(3,126) ->
	#base_eudemons_strength{pos = 3,level = 126,attr = [{2,25200},{6,630}],exp = 1246};

get_strength(3,127) ->
	#base_eudemons_strength{pos = 3,level = 127,attr = [{2,25400},{6,635}],exp = 1250};

get_strength(3,128) ->
	#base_eudemons_strength{pos = 3,level = 128,attr = [{2,25600},{6,640}],exp = 1255};

get_strength(3,129) ->
	#base_eudemons_strength{pos = 3,level = 129,attr = [{2,25800},{6,645}],exp = 1260};

get_strength(3,130) ->
	#base_eudemons_strength{pos = 3,level = 130,attr = [{2,26000},{6,650}],exp = 1265};

get_strength(3,131) ->
	#base_eudemons_strength{pos = 3,level = 131,attr = [{2,26200},{6,655}],exp = 1270};

get_strength(3,132) ->
	#base_eudemons_strength{pos = 3,level = 132,attr = [{2,26400},{6,660}],exp = 1274};

get_strength(3,133) ->
	#base_eudemons_strength{pos = 3,level = 133,attr = [{2,26600},{6,665}],exp = 1279};

get_strength(3,134) ->
	#base_eudemons_strength{pos = 3,level = 134,attr = [{2,26800},{6,670}],exp = 1284};

get_strength(3,135) ->
	#base_eudemons_strength{pos = 3,level = 135,attr = [{2,27000},{6,675}],exp = 1289};

get_strength(3,136) ->
	#base_eudemons_strength{pos = 3,level = 136,attr = [{2,27200},{6,680}],exp = 1294};

get_strength(3,137) ->
	#base_eudemons_strength{pos = 3,level = 137,attr = [{2,27400},{6,685}],exp = 1298};

get_strength(3,138) ->
	#base_eudemons_strength{pos = 3,level = 138,attr = [{2,27600},{6,690}],exp = 1303};

get_strength(3,139) ->
	#base_eudemons_strength{pos = 3,level = 139,attr = [{2,27800},{6,695}],exp = 1308};

get_strength(3,140) ->
	#base_eudemons_strength{pos = 3,level = 140,attr = [{2,28000},{6,700}],exp = 1313};

get_strength(3,141) ->
	#base_eudemons_strength{pos = 3,level = 141,attr = [{2,28200},{6,705}],exp = 1318};

get_strength(3,142) ->
	#base_eudemons_strength{pos = 3,level = 142,attr = [{2,28400},{6,710}],exp = 1322};

get_strength(3,143) ->
	#base_eudemons_strength{pos = 3,level = 143,attr = [{2,28600},{6,715}],exp = 1327};

get_strength(3,144) ->
	#base_eudemons_strength{pos = 3,level = 144,attr = [{2,28800},{6,720}],exp = 1332};

get_strength(3,145) ->
	#base_eudemons_strength{pos = 3,level = 145,attr = [{2,29000},{6,725}],exp = 1337};

get_strength(3,146) ->
	#base_eudemons_strength{pos = 3,level = 146,attr = [{2,29200},{6,730}],exp = 1342};

get_strength(3,147) ->
	#base_eudemons_strength{pos = 3,level = 147,attr = [{2,29400},{6,735}],exp = 1346};

get_strength(3,148) ->
	#base_eudemons_strength{pos = 3,level = 148,attr = [{2,29600},{6,740}],exp = 1351};

get_strength(3,149) ->
	#base_eudemons_strength{pos = 3,level = 149,attr = [{2,29800},{6,745}],exp = 1356};

get_strength(3,150) ->
	#base_eudemons_strength{pos = 3,level = 150,attr = [{2,30000},{6,750}],exp = 1361};

get_strength(3,151) ->
	#base_eudemons_strength{pos = 3,level = 151,attr = [{2,30200},{6,755}],exp = 1366};

get_strength(3,152) ->
	#base_eudemons_strength{pos = 3,level = 152,attr = [{2,30400},{6,760}],exp = 1370};

get_strength(3,153) ->
	#base_eudemons_strength{pos = 3,level = 153,attr = [{2,30600},{6,765}],exp = 1375};

get_strength(3,154) ->
	#base_eudemons_strength{pos = 3,level = 154,attr = [{2,30800},{6,770}],exp = 1380};

get_strength(3,155) ->
	#base_eudemons_strength{pos = 3,level = 155,attr = [{2,31000},{6,775}],exp = 1385};

get_strength(3,156) ->
	#base_eudemons_strength{pos = 3,level = 156,attr = [{2,31200},{6,780}],exp = 1390};

get_strength(3,157) ->
	#base_eudemons_strength{pos = 3,level = 157,attr = [{2,31400},{6,785}],exp = 1394};

get_strength(3,158) ->
	#base_eudemons_strength{pos = 3,level = 158,attr = [{2,31600},{6,790}],exp = 1399};

get_strength(3,159) ->
	#base_eudemons_strength{pos = 3,level = 159,attr = [{2,31800},{6,795}],exp = 1404};

get_strength(3,160) ->
	#base_eudemons_strength{pos = 3,level = 160,attr = [{2,32000},{6,800}],exp = 1409};

get_strength(3,161) ->
	#base_eudemons_strength{pos = 3,level = 161,attr = [{2,32200},{6,805}],exp = 1414};

get_strength(3,162) ->
	#base_eudemons_strength{pos = 3,level = 162,attr = [{2,32400},{6,810}],exp = 1418};

get_strength(3,163) ->
	#base_eudemons_strength{pos = 3,level = 163,attr = [{2,32600},{6,815}],exp = 1423};

get_strength(3,164) ->
	#base_eudemons_strength{pos = 3,level = 164,attr = [{2,32800},{6,820}],exp = 1428};

get_strength(3,165) ->
	#base_eudemons_strength{pos = 3,level = 165,attr = [{2,33000},{6,825}],exp = 1433};

get_strength(3,166) ->
	#base_eudemons_strength{pos = 3,level = 166,attr = [{2,33200},{6,830}],exp = 1438};

get_strength(3,167) ->
	#base_eudemons_strength{pos = 3,level = 167,attr = [{2,33400},{6,835}],exp = 1442};

get_strength(3,168) ->
	#base_eudemons_strength{pos = 3,level = 168,attr = [{2,33600},{6,840}],exp = 1447};

get_strength(3,169) ->
	#base_eudemons_strength{pos = 3,level = 169,attr = [{2,33800},{6,845}],exp = 1452};

get_strength(3,170) ->
	#base_eudemons_strength{pos = 3,level = 170,attr = [{2,34000},{6,850}],exp = 1457};

get_strength(3,171) ->
	#base_eudemons_strength{pos = 3,level = 171,attr = [{2,34200},{6,855}],exp = 1462};

get_strength(3,172) ->
	#base_eudemons_strength{pos = 3,level = 172,attr = [{2,34400},{6,860}],exp = 1466};

get_strength(3,173) ->
	#base_eudemons_strength{pos = 3,level = 173,attr = [{2,34600},{6,865}],exp = 1471};

get_strength(3,174) ->
	#base_eudemons_strength{pos = 3,level = 174,attr = [{2,34800},{6,870}],exp = 1476};

get_strength(3,175) ->
	#base_eudemons_strength{pos = 3,level = 175,attr = [{2,35000},{6,875}],exp = 1481};

get_strength(3,176) ->
	#base_eudemons_strength{pos = 3,level = 176,attr = [{2,35200},{6,880}],exp = 1486};

get_strength(3,177) ->
	#base_eudemons_strength{pos = 3,level = 177,attr = [{2,35400},{6,885}],exp = 1490};

get_strength(3,178) ->
	#base_eudemons_strength{pos = 3,level = 178,attr = [{2,35600},{6,890}],exp = 1495};

get_strength(3,179) ->
	#base_eudemons_strength{pos = 3,level = 179,attr = [{2,35800},{6,895}],exp = 1500};

get_strength(3,180) ->
	#base_eudemons_strength{pos = 3,level = 180,attr = [{2,36000},{6,900}],exp = 1505};

get_strength(3,181) ->
	#base_eudemons_strength{pos = 3,level = 181,attr = [{2,36200},{6,905}],exp = 1510};

get_strength(3,182) ->
	#base_eudemons_strength{pos = 3,level = 182,attr = [{2,36400},{6,910}],exp = 1514};

get_strength(3,183) ->
	#base_eudemons_strength{pos = 3,level = 183,attr = [{2,36600},{6,915}],exp = 1519};

get_strength(3,184) ->
	#base_eudemons_strength{pos = 3,level = 184,attr = [{2,36800},{6,920}],exp = 1524};

get_strength(3,185) ->
	#base_eudemons_strength{pos = 3,level = 185,attr = [{2,37000},{6,925}],exp = 1529};

get_strength(3,186) ->
	#base_eudemons_strength{pos = 3,level = 186,attr = [{2,37200},{6,930}],exp = 1534};

get_strength(3,187) ->
	#base_eudemons_strength{pos = 3,level = 187,attr = [{2,37400},{6,935}],exp = 1538};

get_strength(3,188) ->
	#base_eudemons_strength{pos = 3,level = 188,attr = [{2,37600},{6,940}],exp = 1543};

get_strength(3,189) ->
	#base_eudemons_strength{pos = 3,level = 189,attr = [{2,37800},{6,945}],exp = 1548};

get_strength(3,190) ->
	#base_eudemons_strength{pos = 3,level = 190,attr = [{2,38000},{6,950}],exp = 1553};

get_strength(3,191) ->
	#base_eudemons_strength{pos = 3,level = 191,attr = [{2,38200},{6,955}],exp = 1558};

get_strength(3,192) ->
	#base_eudemons_strength{pos = 3,level = 192,attr = [{2,38400},{6,960}],exp = 1562};

get_strength(3,193) ->
	#base_eudemons_strength{pos = 3,level = 193,attr = [{2,38600},{6,965}],exp = 1567};

get_strength(3,194) ->
	#base_eudemons_strength{pos = 3,level = 194,attr = [{2,38800},{6,970}],exp = 1572};

get_strength(3,195) ->
	#base_eudemons_strength{pos = 3,level = 195,attr = [{2,39000},{6,975}],exp = 1577};

get_strength(3,196) ->
	#base_eudemons_strength{pos = 3,level = 196,attr = [{2,39200},{6,980}],exp = 1582};

get_strength(3,197) ->
	#base_eudemons_strength{pos = 3,level = 197,attr = [{2,39400},{6,985}],exp = 1586};

get_strength(3,198) ->
	#base_eudemons_strength{pos = 3,level = 198,attr = [{2,39600},{6,990}],exp = 1591};

get_strength(3,199) ->
	#base_eudemons_strength{pos = 3,level = 199,attr = [{2,39800},{6,995}],exp = 1596};

get_strength(3,200) ->
	#base_eudemons_strength{pos = 3,level = 200,attr = [{2,40000},{6,1000}],exp = 1601};

get_strength(4,1) ->
	#base_eudemons_strength{pos = 4,level = 1,attr = [{4,10},{8,5}],exp = 10};

get_strength(4,2) ->
	#base_eudemons_strength{pos = 4,level = 2,attr = [{4,20},{8,10}],exp = 13};

get_strength(4,3) ->
	#base_eudemons_strength{pos = 4,level = 3,attr = [{4,30},{8,15}],exp = 17};

get_strength(4,4) ->
	#base_eudemons_strength{pos = 4,level = 4,attr = [{4,40},{8,20}],exp = 22};

get_strength(4,5) ->
	#base_eudemons_strength{pos = 4,level = 5,attr = [{4,50},{8,25}],exp = 25};

get_strength(4,6) ->
	#base_eudemons_strength{pos = 4,level = 6,attr = [{4,60},{8,30}],exp = 28};

get_strength(4,7) ->
	#base_eudemons_strength{pos = 4,level = 7,attr = [{4,70},{8,35}],exp = 30};

get_strength(4,8) ->
	#base_eudemons_strength{pos = 4,level = 8,attr = [{4,80},{8,40}],exp = 33};

get_strength(4,9) ->
	#base_eudemons_strength{pos = 4,level = 9,attr = [{4,90},{8,45}],exp = 36};

get_strength(4,10) ->
	#base_eudemons_strength{pos = 4,level = 10,attr = [{4,100},{8,50}],exp = 39};

get_strength(4,11) ->
	#base_eudemons_strength{pos = 4,level = 11,attr = [{4,110},{8,55}],exp = 42};

get_strength(4,12) ->
	#base_eudemons_strength{pos = 4,level = 12,attr = [{4,120},{8,60}],exp = 45};

get_strength(4,13) ->
	#base_eudemons_strength{pos = 4,level = 13,attr = [{4,130},{8,65}],exp = 47};

get_strength(4,14) ->
	#base_eudemons_strength{pos = 4,level = 14,attr = [{4,140},{8,70}],exp = 49};

get_strength(4,15) ->
	#base_eudemons_strength{pos = 4,level = 15,attr = [{4,150},{8,75}],exp = 58};

get_strength(4,16) ->
	#base_eudemons_strength{pos = 4,level = 16,attr = [{4,160},{8,80}],exp = 61};

get_strength(4,17) ->
	#base_eudemons_strength{pos = 4,level = 17,attr = [{4,170},{8,85}],exp = 65};

get_strength(4,18) ->
	#base_eudemons_strength{pos = 4,level = 18,attr = [{4,180},{8,90}],exp = 68};

get_strength(4,19) ->
	#base_eudemons_strength{pos = 4,level = 19,attr = [{4,190},{8,95}],exp = 72};

get_strength(4,20) ->
	#base_eudemons_strength{pos = 4,level = 20,attr = [{4,200},{8,100}],exp = 75};

get_strength(4,21) ->
	#base_eudemons_strength{pos = 4,level = 21,attr = [{4,210},{8,105}],exp = 80};

get_strength(4,22) ->
	#base_eudemons_strength{pos = 4,level = 22,attr = [{4,220},{8,110}],exp = 85};

get_strength(4,23) ->
	#base_eudemons_strength{pos = 4,level = 23,attr = [{4,230},{8,115}],exp = 95};

get_strength(4,24) ->
	#base_eudemons_strength{pos = 4,level = 24,attr = [{4,240},{8,120}],exp = 110};

get_strength(4,25) ->
	#base_eudemons_strength{pos = 4,level = 25,attr = [{4,250},{8,125}],exp = 125};

get_strength(4,26) ->
	#base_eudemons_strength{pos = 4,level = 26,attr = [{4,260},{8,130}],exp = 135};

get_strength(4,27) ->
	#base_eudemons_strength{pos = 4,level = 27,attr = [{4,270},{8,135}],exp = 145};

get_strength(4,28) ->
	#base_eudemons_strength{pos = 4,level = 28,attr = [{4,280},{8,140}],exp = 150};

get_strength(4,29) ->
	#base_eudemons_strength{pos = 4,level = 29,attr = [{4,290},{8,145}],exp = 155};

get_strength(4,30) ->
	#base_eudemons_strength{pos = 4,level = 30,attr = [{4,300},{8,150}],exp = 162};

get_strength(4,31) ->
	#base_eudemons_strength{pos = 4,level = 31,attr = [{4,310},{8,155}],exp = 115};

get_strength(4,32) ->
	#base_eudemons_strength{pos = 4,level = 32,attr = [{4,320},{8,160}],exp = 121};

get_strength(4,33) ->
	#base_eudemons_strength{pos = 4,level = 33,attr = [{4,330},{8,165}],exp = 127};

get_strength(4,34) ->
	#base_eudemons_strength{pos = 4,level = 34,attr = [{4,340},{8,170}],exp = 133};

get_strength(4,35) ->
	#base_eudemons_strength{pos = 4,level = 35,attr = [{4,350},{8,175}],exp = 139};

get_strength(4,36) ->
	#base_eudemons_strength{pos = 4,level = 36,attr = [{4,360},{8,180}],exp = 145};

get_strength(4,37) ->
	#base_eudemons_strength{pos = 4,level = 37,attr = [{4,370},{8,185}],exp = 151};

get_strength(4,38) ->
	#base_eudemons_strength{pos = 4,level = 38,attr = [{4,380},{8,190}],exp = 158};

get_strength(4,39) ->
	#base_eudemons_strength{pos = 4,level = 39,attr = [{4,390},{8,195}],exp = 166};

get_strength(4,40) ->
	#base_eudemons_strength{pos = 4,level = 40,attr = [{4,400},{8,200}],exp = 173};

get_strength(4,41) ->
	#base_eudemons_strength{pos = 4,level = 41,attr = [{4,410},{8,205}],exp = 180};

get_strength(4,42) ->
	#base_eudemons_strength{pos = 4,level = 42,attr = [{4,420},{8,210}],exp = 187};

get_strength(4,43) ->
	#base_eudemons_strength{pos = 4,level = 43,attr = [{4,430},{8,215}],exp = 194};

get_strength(4,44) ->
	#base_eudemons_strength{pos = 4,level = 44,attr = [{4,440},{8,220}],exp = 202};

get_strength(4,45) ->
	#base_eudemons_strength{pos = 4,level = 45,attr = [{4,450},{8,225}],exp = 209};

get_strength(4,46) ->
	#base_eudemons_strength{pos = 4,level = 46,attr = [{4,460},{8,230}],exp = 217};

get_strength(4,47) ->
	#base_eudemons_strength{pos = 4,level = 47,attr = [{4,470},{8,235}],exp = 226};

get_strength(4,48) ->
	#base_eudemons_strength{pos = 4,level = 48,attr = [{4,480},{8,240}],exp = 234};

get_strength(4,49) ->
	#base_eudemons_strength{pos = 4,level = 49,attr = [{4,490},{8,245}],exp = 242};

get_strength(4,50) ->
	#base_eudemons_strength{pos = 4,level = 50,attr = [{4,500},{8,250}],exp = 251};

get_strength(4,51) ->
	#base_eudemons_strength{pos = 4,level = 51,attr = [{4,510},{8,255}],exp = 259};

get_strength(4,52) ->
	#base_eudemons_strength{pos = 4,level = 52,attr = [{4,520},{8,260}],exp = 268};

get_strength(4,53) ->
	#base_eudemons_strength{pos = 4,level = 53,attr = [{4,530},{8,265}],exp = 276};

get_strength(4,54) ->
	#base_eudemons_strength{pos = 4,level = 54,attr = [{4,540},{8,270}],exp = 286};

get_strength(4,55) ->
	#base_eudemons_strength{pos = 4,level = 55,attr = [{4,550},{8,275}],exp = 295};

get_strength(4,56) ->
	#base_eudemons_strength{pos = 4,level = 56,attr = [{4,560},{8,280}],exp = 305};

get_strength(4,57) ->
	#base_eudemons_strength{pos = 4,level = 57,attr = [{4,570},{8,285}],exp = 314};

get_strength(4,58) ->
	#base_eudemons_strength{pos = 4,level = 58,attr = [{4,580},{8,290}],exp = 324};

get_strength(4,59) ->
	#base_eudemons_strength{pos = 4,level = 59,attr = [{4,590},{8,295}],exp = 334};

get_strength(4,60) ->
	#base_eudemons_strength{pos = 4,level = 60,attr = [{4,600},{8,300}],exp = 343};

get_strength(4,61) ->
	#base_eudemons_strength{pos = 4,level = 61,attr = [{4,610},{8,305}],exp = 353};

get_strength(4,62) ->
	#base_eudemons_strength{pos = 4,level = 62,attr = [{4,620},{8,310}],exp = 364};

get_strength(4,63) ->
	#base_eudemons_strength{pos = 4,level = 63,attr = [{4,630},{8,315}],exp = 374};

get_strength(4,64) ->
	#base_eudemons_strength{pos = 4,level = 64,attr = [{4,640},{8,320}],exp = 385};

get_strength(4,65) ->
	#base_eudemons_strength{pos = 4,level = 65,attr = [{4,650},{8,325}],exp = 396};

get_strength(4,66) ->
	#base_eudemons_strength{pos = 4,level = 66,attr = [{4,660},{8,330}],exp = 407};

get_strength(4,67) ->
	#base_eudemons_strength{pos = 4,level = 67,attr = [{4,670},{8,335}],exp = 418};

get_strength(4,68) ->
	#base_eudemons_strength{pos = 4,level = 68,attr = [{4,680},{8,340}],exp = 428};

get_strength(4,69) ->
	#base_eudemons_strength{pos = 4,level = 69,attr = [{4,690},{8,345}],exp = 439};

get_strength(4,70) ->
	#base_eudemons_strength{pos = 4,level = 70,attr = [{4,700},{8,350}],exp = 451};

get_strength(4,71) ->
	#base_eudemons_strength{pos = 4,level = 71,attr = [{4,710},{8,355}],exp = 463};

get_strength(4,72) ->
	#base_eudemons_strength{pos = 4,level = 72,attr = [{4,720},{8,360}],exp = 475};

get_strength(4,73) ->
	#base_eudemons_strength{pos = 4,level = 73,attr = [{4,730},{8,365}],exp = 487};

get_strength(4,74) ->
	#base_eudemons_strength{pos = 4,level = 74,attr = [{4,740},{8,370}],exp = 499};

get_strength(4,75) ->
	#base_eudemons_strength{pos = 4,level = 75,attr = [{4,750},{8,375}],exp = 511};

get_strength(4,76) ->
	#base_eudemons_strength{pos = 4,level = 76,attr = [{4,760},{8,380}],exp = 523};

get_strength(4,77) ->
	#base_eudemons_strength{pos = 4,level = 77,attr = [{4,770},{8,385}],exp = 535};

get_strength(4,78) ->
	#base_eudemons_strength{pos = 4,level = 78,attr = [{4,780},{8,390}],exp = 548};

get_strength(4,79) ->
	#base_eudemons_strength{pos = 4,level = 79,attr = [{4,790},{8,395}],exp = 562};

get_strength(4,80) ->
	#base_eudemons_strength{pos = 4,level = 80,attr = [{4,800},{8,400}],exp = 575};

get_strength(4,81) ->
	#base_eudemons_strength{pos = 4,level = 81,attr = [{4,810},{8,405}],exp = 588};

get_strength(4,82) ->
	#base_eudemons_strength{pos = 4,level = 82,attr = [{4,820},{8,410}],exp = 601};

get_strength(4,83) ->
	#base_eudemons_strength{pos = 4,level = 83,attr = [{4,830},{8,415}],exp = 614};

get_strength(4,84) ->
	#base_eudemons_strength{pos = 4,level = 84,attr = [{4,840},{8,420}],exp = 628};

get_strength(4,85) ->
	#base_eudemons_strength{pos = 4,level = 85,attr = [{4,850},{8,425}],exp = 641};

get_strength(4,86) ->
	#base_eudemons_strength{pos = 4,level = 86,attr = [{4,860},{8,430}],exp = 655};

get_strength(4,87) ->
	#base_eudemons_strength{pos = 4,level = 87,attr = [{4,870},{8,435}],exp = 670};

get_strength(4,88) ->
	#base_eudemons_strength{pos = 4,level = 88,attr = [{4,880},{8,440}],exp = 684};

get_strength(4,89) ->
	#base_eudemons_strength{pos = 4,level = 89,attr = [{4,890},{8,445}],exp = 698};

get_strength(4,90) ->
	#base_eudemons_strength{pos = 4,level = 90,attr = [{4,900},{8,450}],exp = 713};

get_strength(4,91) ->
	#base_eudemons_strength{pos = 4,level = 91,attr = [{4,910},{8,455}],exp = 727};

get_strength(4,92) ->
	#base_eudemons_strength{pos = 4,level = 92,attr = [{4,920},{8,460}],exp = 742};

get_strength(4,93) ->
	#base_eudemons_strength{pos = 4,level = 93,attr = [{4,930},{8,465}],exp = 756};

get_strength(4,94) ->
	#base_eudemons_strength{pos = 4,level = 94,attr = [{4,940},{8,470}],exp = 772};

get_strength(4,95) ->
	#base_eudemons_strength{pos = 4,level = 95,attr = [{4,950},{8,475}],exp = 787};

get_strength(4,96) ->
	#base_eudemons_strength{pos = 4,level = 96,attr = [{4,960},{8,480}],exp = 803};

get_strength(4,97) ->
	#base_eudemons_strength{pos = 4,level = 97,attr = [{4,970},{8,485}],exp = 818};

get_strength(4,98) ->
	#base_eudemons_strength{pos = 4,level = 98,attr = [{4,980},{8,490}],exp = 834};

get_strength(4,99) ->
	#base_eudemons_strength{pos = 4,level = 99,attr = [{4,990},{8,495}],exp = 850};

get_strength(4,100) ->
	#base_eudemons_strength{pos = 4,level = 100,attr = [{4,1000},{8,500}],exp = 865};

get_strength(4,101) ->
	#base_eudemons_strength{pos = 4,level = 101,attr = [{4,1010},{8,505}],exp = 881};

get_strength(4,102) ->
	#base_eudemons_strength{pos = 4,level = 102,attr = [{4,1020},{8,510}],exp = 898};

get_strength(4,103) ->
	#base_eudemons_strength{pos = 4,level = 103,attr = [{4,1030},{8,515}],exp = 914};

get_strength(4,104) ->
	#base_eudemons_strength{pos = 4,level = 104,attr = [{4,1040},{8,520}],exp = 931};

get_strength(4,105) ->
	#base_eudemons_strength{pos = 4,level = 105,attr = [{4,1050},{8,525}],exp = 948};

get_strength(4,106) ->
	#base_eudemons_strength{pos = 4,level = 106,attr = [{4,1060},{8,530}],exp = 965};

get_strength(4,107) ->
	#base_eudemons_strength{pos = 4,level = 107,attr = [{4,1070},{8,535}],exp = 982};

get_strength(4,108) ->
	#base_eudemons_strength{pos = 4,level = 108,attr = [{4,1080},{8,540}],exp = 998};

get_strength(4,109) ->
	#base_eudemons_strength{pos = 4,level = 109,attr = [{4,1090},{8,545}],exp = 1015};

get_strength(4,110) ->
	#base_eudemons_strength{pos = 4,level = 110,attr = [{4,1100},{8,550}],exp = 1033};

get_strength(4,111) ->
	#base_eudemons_strength{pos = 4,level = 111,attr = [{4,1110},{8,555}],exp = 1051};

get_strength(4,112) ->
	#base_eudemons_strength{pos = 4,level = 112,attr = [{4,1120},{8,560}],exp = 1069};

get_strength(4,113) ->
	#base_eudemons_strength{pos = 4,level = 113,attr = [{4,1130},{8,565}],exp = 1087};

get_strength(4,114) ->
	#base_eudemons_strength{pos = 4,level = 114,attr = [{4,1140},{8,570}],exp = 1105};

get_strength(4,115) ->
	#base_eudemons_strength{pos = 4,level = 115,attr = [{4,1150},{8,575}],exp = 1123};

get_strength(4,116) ->
	#base_eudemons_strength{pos = 4,level = 116,attr = [{4,1160},{8,580}],exp = 1141};

get_strength(4,117) ->
	#base_eudemons_strength{pos = 4,level = 117,attr = [{4,1170},{8,585}],exp = 1159};

get_strength(4,118) ->
	#base_eudemons_strength{pos = 4,level = 118,attr = [{4,1180},{8,590}],exp = 1178};

get_strength(4,119) ->
	#base_eudemons_strength{pos = 4,level = 119,attr = [{4,1190},{8,595}],exp = 1198};

get_strength(4,120) ->
	#base_eudemons_strength{pos = 4,level = 120,attr = [{4,1200},{8,600}],exp = 1217};

get_strength(4,121) ->
	#base_eudemons_strength{pos = 4,level = 121,attr = [{4,1210},{8,605}],exp = 1222};

get_strength(4,122) ->
	#base_eudemons_strength{pos = 4,level = 122,attr = [{4,1220},{8,610}],exp = 1226};

get_strength(4,123) ->
	#base_eudemons_strength{pos = 4,level = 123,attr = [{4,1230},{8,615}],exp = 1231};

get_strength(4,124) ->
	#base_eudemons_strength{pos = 4,level = 124,attr = [{4,1240},{8,620}],exp = 1236};

get_strength(4,125) ->
	#base_eudemons_strength{pos = 4,level = 125,attr = [{4,1250},{8,625}],exp = 1241};

get_strength(4,126) ->
	#base_eudemons_strength{pos = 4,level = 126,attr = [{4,1260},{8,630}],exp = 1246};

get_strength(4,127) ->
	#base_eudemons_strength{pos = 4,level = 127,attr = [{4,1270},{8,635}],exp = 1250};

get_strength(4,128) ->
	#base_eudemons_strength{pos = 4,level = 128,attr = [{4,1280},{8,640}],exp = 1255};

get_strength(4,129) ->
	#base_eudemons_strength{pos = 4,level = 129,attr = [{4,1290},{8,645}],exp = 1260};

get_strength(4,130) ->
	#base_eudemons_strength{pos = 4,level = 130,attr = [{4,1300},{8,650}],exp = 1265};

get_strength(4,131) ->
	#base_eudemons_strength{pos = 4,level = 131,attr = [{4,1310},{8,655}],exp = 1270};

get_strength(4,132) ->
	#base_eudemons_strength{pos = 4,level = 132,attr = [{4,1320},{8,660}],exp = 1274};

get_strength(4,133) ->
	#base_eudemons_strength{pos = 4,level = 133,attr = [{4,1330},{8,665}],exp = 1279};

get_strength(4,134) ->
	#base_eudemons_strength{pos = 4,level = 134,attr = [{4,1340},{8,670}],exp = 1284};

get_strength(4,135) ->
	#base_eudemons_strength{pos = 4,level = 135,attr = [{4,1350},{8,675}],exp = 1289};

get_strength(4,136) ->
	#base_eudemons_strength{pos = 4,level = 136,attr = [{4,1360},{8,680}],exp = 1294};

get_strength(4,137) ->
	#base_eudemons_strength{pos = 4,level = 137,attr = [{4,1370},{8,685}],exp = 1298};

get_strength(4,138) ->
	#base_eudemons_strength{pos = 4,level = 138,attr = [{4,1380},{8,690}],exp = 1303};

get_strength(4,139) ->
	#base_eudemons_strength{pos = 4,level = 139,attr = [{4,1390},{8,695}],exp = 1308};

get_strength(4,140) ->
	#base_eudemons_strength{pos = 4,level = 140,attr = [{4,1400},{8,700}],exp = 1313};

get_strength(4,141) ->
	#base_eudemons_strength{pos = 4,level = 141,attr = [{4,1410},{8,705}],exp = 1318};

get_strength(4,142) ->
	#base_eudemons_strength{pos = 4,level = 142,attr = [{4,1420},{8,710}],exp = 1322};

get_strength(4,143) ->
	#base_eudemons_strength{pos = 4,level = 143,attr = [{4,1430},{8,715}],exp = 1327};

get_strength(4,144) ->
	#base_eudemons_strength{pos = 4,level = 144,attr = [{4,1440},{8,720}],exp = 1332};

get_strength(4,145) ->
	#base_eudemons_strength{pos = 4,level = 145,attr = [{4,1450},{8,725}],exp = 1337};

get_strength(4,146) ->
	#base_eudemons_strength{pos = 4,level = 146,attr = [{4,1460},{8,730}],exp = 1342};

get_strength(4,147) ->
	#base_eudemons_strength{pos = 4,level = 147,attr = [{4,1470},{8,735}],exp = 1346};

get_strength(4,148) ->
	#base_eudemons_strength{pos = 4,level = 148,attr = [{4,1480},{8,740}],exp = 1351};

get_strength(4,149) ->
	#base_eudemons_strength{pos = 4,level = 149,attr = [{4,1490},{8,745}],exp = 1356};

get_strength(4,150) ->
	#base_eudemons_strength{pos = 4,level = 150,attr = [{4,1500},{8,750}],exp = 1361};

get_strength(4,151) ->
	#base_eudemons_strength{pos = 4,level = 151,attr = [{4,1510},{8,755}],exp = 1366};

get_strength(4,152) ->
	#base_eudemons_strength{pos = 4,level = 152,attr = [{4,1520},{8,760}],exp = 1370};

get_strength(4,153) ->
	#base_eudemons_strength{pos = 4,level = 153,attr = [{4,1530},{8,765}],exp = 1375};

get_strength(4,154) ->
	#base_eudemons_strength{pos = 4,level = 154,attr = [{4,1540},{8,770}],exp = 1380};

get_strength(4,155) ->
	#base_eudemons_strength{pos = 4,level = 155,attr = [{4,1550},{8,775}],exp = 1385};

get_strength(4,156) ->
	#base_eudemons_strength{pos = 4,level = 156,attr = [{4,1560},{8,780}],exp = 1390};

get_strength(4,157) ->
	#base_eudemons_strength{pos = 4,level = 157,attr = [{4,1570},{8,785}],exp = 1394};

get_strength(4,158) ->
	#base_eudemons_strength{pos = 4,level = 158,attr = [{4,1580},{8,790}],exp = 1399};

get_strength(4,159) ->
	#base_eudemons_strength{pos = 4,level = 159,attr = [{4,1590},{8,795}],exp = 1404};

get_strength(4,160) ->
	#base_eudemons_strength{pos = 4,level = 160,attr = [{4,1600},{8,800}],exp = 1409};

get_strength(4,161) ->
	#base_eudemons_strength{pos = 4,level = 161,attr = [{4,1610},{8,805}],exp = 1414};

get_strength(4,162) ->
	#base_eudemons_strength{pos = 4,level = 162,attr = [{4,1620},{8,810}],exp = 1418};

get_strength(4,163) ->
	#base_eudemons_strength{pos = 4,level = 163,attr = [{4,1630},{8,815}],exp = 1423};

get_strength(4,164) ->
	#base_eudemons_strength{pos = 4,level = 164,attr = [{4,1640},{8,820}],exp = 1428};

get_strength(4,165) ->
	#base_eudemons_strength{pos = 4,level = 165,attr = [{4,1650},{8,825}],exp = 1433};

get_strength(4,166) ->
	#base_eudemons_strength{pos = 4,level = 166,attr = [{4,1660},{8,830}],exp = 1438};

get_strength(4,167) ->
	#base_eudemons_strength{pos = 4,level = 167,attr = [{4,1670},{8,835}],exp = 1442};

get_strength(4,168) ->
	#base_eudemons_strength{pos = 4,level = 168,attr = [{4,1680},{8,840}],exp = 1447};

get_strength(4,169) ->
	#base_eudemons_strength{pos = 4,level = 169,attr = [{4,1690},{8,845}],exp = 1452};

get_strength(4,170) ->
	#base_eudemons_strength{pos = 4,level = 170,attr = [{4,1700},{8,850}],exp = 1457};

get_strength(4,171) ->
	#base_eudemons_strength{pos = 4,level = 171,attr = [{4,1710},{8,855}],exp = 1462};

get_strength(4,172) ->
	#base_eudemons_strength{pos = 4,level = 172,attr = [{4,1720},{8,860}],exp = 1466};

get_strength(4,173) ->
	#base_eudemons_strength{pos = 4,level = 173,attr = [{4,1730},{8,865}],exp = 1471};

get_strength(4,174) ->
	#base_eudemons_strength{pos = 4,level = 174,attr = [{4,1740},{8,870}],exp = 1476};

get_strength(4,175) ->
	#base_eudemons_strength{pos = 4,level = 175,attr = [{4,1750},{8,875}],exp = 1481};

get_strength(4,176) ->
	#base_eudemons_strength{pos = 4,level = 176,attr = [{4,1760},{8,880}],exp = 1486};

get_strength(4,177) ->
	#base_eudemons_strength{pos = 4,level = 177,attr = [{4,1770},{8,885}],exp = 1490};

get_strength(4,178) ->
	#base_eudemons_strength{pos = 4,level = 178,attr = [{4,1780},{8,890}],exp = 1495};

get_strength(4,179) ->
	#base_eudemons_strength{pos = 4,level = 179,attr = [{4,1790},{8,895}],exp = 1500};

get_strength(4,180) ->
	#base_eudemons_strength{pos = 4,level = 180,attr = [{4,1800},{8,900}],exp = 1505};

get_strength(4,181) ->
	#base_eudemons_strength{pos = 4,level = 181,attr = [{4,1810},{8,905}],exp = 1510};

get_strength(4,182) ->
	#base_eudemons_strength{pos = 4,level = 182,attr = [{4,1820},{8,910}],exp = 1514};

get_strength(4,183) ->
	#base_eudemons_strength{pos = 4,level = 183,attr = [{4,1830},{8,915}],exp = 1519};

get_strength(4,184) ->
	#base_eudemons_strength{pos = 4,level = 184,attr = [{4,1840},{8,920}],exp = 1524};

get_strength(4,185) ->
	#base_eudemons_strength{pos = 4,level = 185,attr = [{4,1850},{8,925}],exp = 1529};

get_strength(4,186) ->
	#base_eudemons_strength{pos = 4,level = 186,attr = [{4,1860},{8,930}],exp = 1534};

get_strength(4,187) ->
	#base_eudemons_strength{pos = 4,level = 187,attr = [{4,1870},{8,935}],exp = 1538};

get_strength(4,188) ->
	#base_eudemons_strength{pos = 4,level = 188,attr = [{4,1880},{8,940}],exp = 1543};

get_strength(4,189) ->
	#base_eudemons_strength{pos = 4,level = 189,attr = [{4,1890},{8,945}],exp = 1548};

get_strength(4,190) ->
	#base_eudemons_strength{pos = 4,level = 190,attr = [{4,1900},{8,950}],exp = 1553};

get_strength(4,191) ->
	#base_eudemons_strength{pos = 4,level = 191,attr = [{4,1910},{8,955}],exp = 1558};

get_strength(4,192) ->
	#base_eudemons_strength{pos = 4,level = 192,attr = [{4,1920},{8,960}],exp = 1562};

get_strength(4,193) ->
	#base_eudemons_strength{pos = 4,level = 193,attr = [{4,1930},{8,965}],exp = 1567};

get_strength(4,194) ->
	#base_eudemons_strength{pos = 4,level = 194,attr = [{4,1940},{8,970}],exp = 1572};

get_strength(4,195) ->
	#base_eudemons_strength{pos = 4,level = 195,attr = [{4,1950},{8,975}],exp = 1577};

get_strength(4,196) ->
	#base_eudemons_strength{pos = 4,level = 196,attr = [{4,1960},{8,980}],exp = 1582};

get_strength(4,197) ->
	#base_eudemons_strength{pos = 4,level = 197,attr = [{4,1970},{8,985}],exp = 1586};

get_strength(4,198) ->
	#base_eudemons_strength{pos = 4,level = 198,attr = [{4,1980},{8,990}],exp = 1591};

get_strength(4,199) ->
	#base_eudemons_strength{pos = 4,level = 199,attr = [{4,1990},{8,995}],exp = 1596};

get_strength(4,200) ->
	#base_eudemons_strength{pos = 4,level = 200,attr = [{4,2000},{8,1000}],exp = 1601};

get_strength(5,1) ->
	#base_eudemons_strength{pos = 5,level = 1,attr = [{2,200},{4,5}],exp = 10};

get_strength(5,2) ->
	#base_eudemons_strength{pos = 5,level = 2,attr = [{2,400},{4,10}],exp = 13};

get_strength(5,3) ->
	#base_eudemons_strength{pos = 5,level = 3,attr = [{2,600},{4,15}],exp = 17};

get_strength(5,4) ->
	#base_eudemons_strength{pos = 5,level = 4,attr = [{2,800},{4,20}],exp = 22};

get_strength(5,5) ->
	#base_eudemons_strength{pos = 5,level = 5,attr = [{2,1000},{4,25}],exp = 25};

get_strength(5,6) ->
	#base_eudemons_strength{pos = 5,level = 6,attr = [{2,1200},{4,30}],exp = 28};

get_strength(5,7) ->
	#base_eudemons_strength{pos = 5,level = 7,attr = [{2,1400},{4,35}],exp = 30};

get_strength(5,8) ->
	#base_eudemons_strength{pos = 5,level = 8,attr = [{2,1600},{4,40}],exp = 33};

get_strength(5,9) ->
	#base_eudemons_strength{pos = 5,level = 9,attr = [{2,1800},{4,45}],exp = 36};

get_strength(5,10) ->
	#base_eudemons_strength{pos = 5,level = 10,attr = [{2,2000},{4,50}],exp = 39};

get_strength(5,11) ->
	#base_eudemons_strength{pos = 5,level = 11,attr = [{2,2200},{4,55}],exp = 42};

get_strength(5,12) ->
	#base_eudemons_strength{pos = 5,level = 12,attr = [{2,2400},{4,60}],exp = 45};

get_strength(5,13) ->
	#base_eudemons_strength{pos = 5,level = 13,attr = [{2,2600},{4,65}],exp = 47};

get_strength(5,14) ->
	#base_eudemons_strength{pos = 5,level = 14,attr = [{2,2800},{4,70}],exp = 49};

get_strength(5,15) ->
	#base_eudemons_strength{pos = 5,level = 15,attr = [{2,3000},{4,75}],exp = 58};

get_strength(5,16) ->
	#base_eudemons_strength{pos = 5,level = 16,attr = [{2,3200},{4,80}],exp = 61};

get_strength(5,17) ->
	#base_eudemons_strength{pos = 5,level = 17,attr = [{2,3400},{4,85}],exp = 65};

get_strength(5,18) ->
	#base_eudemons_strength{pos = 5,level = 18,attr = [{2,3600},{4,90}],exp = 68};

get_strength(5,19) ->
	#base_eudemons_strength{pos = 5,level = 19,attr = [{2,3800},{4,95}],exp = 72};

get_strength(5,20) ->
	#base_eudemons_strength{pos = 5,level = 20,attr = [{2,4000},{4,100}],exp = 75};

get_strength(5,21) ->
	#base_eudemons_strength{pos = 5,level = 21,attr = [{2,4200},{4,105}],exp = 80};

get_strength(5,22) ->
	#base_eudemons_strength{pos = 5,level = 22,attr = [{2,4400},{4,110}],exp = 85};

get_strength(5,23) ->
	#base_eudemons_strength{pos = 5,level = 23,attr = [{2,4600},{4,115}],exp = 95};

get_strength(5,24) ->
	#base_eudemons_strength{pos = 5,level = 24,attr = [{2,4800},{4,120}],exp = 110};

get_strength(5,25) ->
	#base_eudemons_strength{pos = 5,level = 25,attr = [{2,5000},{4,125}],exp = 125};

get_strength(5,26) ->
	#base_eudemons_strength{pos = 5,level = 26,attr = [{2,5200},{4,130}],exp = 135};

get_strength(5,27) ->
	#base_eudemons_strength{pos = 5,level = 27,attr = [{2,5400},{4,135}],exp = 145};

get_strength(5,28) ->
	#base_eudemons_strength{pos = 5,level = 28,attr = [{2,5600},{4,140}],exp = 150};

get_strength(5,29) ->
	#base_eudemons_strength{pos = 5,level = 29,attr = [{2,5800},{4,145}],exp = 155};

get_strength(5,30) ->
	#base_eudemons_strength{pos = 5,level = 30,attr = [{2,6000},{4,150}],exp = 162};

get_strength(5,31) ->
	#base_eudemons_strength{pos = 5,level = 31,attr = [{2,6200},{4,155}],exp = 115};

get_strength(5,32) ->
	#base_eudemons_strength{pos = 5,level = 32,attr = [{2,6400},{4,160}],exp = 121};

get_strength(5,33) ->
	#base_eudemons_strength{pos = 5,level = 33,attr = [{2,6600},{4,165}],exp = 127};

get_strength(5,34) ->
	#base_eudemons_strength{pos = 5,level = 34,attr = [{2,6800},{4,170}],exp = 133};

get_strength(5,35) ->
	#base_eudemons_strength{pos = 5,level = 35,attr = [{2,7000},{4,175}],exp = 139};

get_strength(5,36) ->
	#base_eudemons_strength{pos = 5,level = 36,attr = [{2,7200},{4,180}],exp = 145};

get_strength(5,37) ->
	#base_eudemons_strength{pos = 5,level = 37,attr = [{2,7400},{4,185}],exp = 151};

get_strength(5,38) ->
	#base_eudemons_strength{pos = 5,level = 38,attr = [{2,7600},{4,190}],exp = 158};

get_strength(5,39) ->
	#base_eudemons_strength{pos = 5,level = 39,attr = [{2,7800},{4,195}],exp = 166};

get_strength(5,40) ->
	#base_eudemons_strength{pos = 5,level = 40,attr = [{2,8000},{4,200}],exp = 173};

get_strength(5,41) ->
	#base_eudemons_strength{pos = 5,level = 41,attr = [{2,8200},{4,205}],exp = 180};

get_strength(5,42) ->
	#base_eudemons_strength{pos = 5,level = 42,attr = [{2,8400},{4,210}],exp = 187};

get_strength(5,43) ->
	#base_eudemons_strength{pos = 5,level = 43,attr = [{2,8600},{4,215}],exp = 194};

get_strength(5,44) ->
	#base_eudemons_strength{pos = 5,level = 44,attr = [{2,8800},{4,220}],exp = 202};

get_strength(5,45) ->
	#base_eudemons_strength{pos = 5,level = 45,attr = [{2,9000},{4,225}],exp = 209};

get_strength(5,46) ->
	#base_eudemons_strength{pos = 5,level = 46,attr = [{2,9200},{4,230}],exp = 217};

get_strength(5,47) ->
	#base_eudemons_strength{pos = 5,level = 47,attr = [{2,9400},{4,235}],exp = 226};

get_strength(5,48) ->
	#base_eudemons_strength{pos = 5,level = 48,attr = [{2,9600},{4,240}],exp = 234};

get_strength(5,49) ->
	#base_eudemons_strength{pos = 5,level = 49,attr = [{2,9800},{4,245}],exp = 242};

get_strength(5,50) ->
	#base_eudemons_strength{pos = 5,level = 50,attr = [{2,10000},{4,250}],exp = 251};

get_strength(5,51) ->
	#base_eudemons_strength{pos = 5,level = 51,attr = [{2,10200},{4,255}],exp = 259};

get_strength(5,52) ->
	#base_eudemons_strength{pos = 5,level = 52,attr = [{2,10400},{4,260}],exp = 268};

get_strength(5,53) ->
	#base_eudemons_strength{pos = 5,level = 53,attr = [{2,10600},{4,265}],exp = 276};

get_strength(5,54) ->
	#base_eudemons_strength{pos = 5,level = 54,attr = [{2,10800},{4,270}],exp = 286};

get_strength(5,55) ->
	#base_eudemons_strength{pos = 5,level = 55,attr = [{2,11000},{4,275}],exp = 295};

get_strength(5,56) ->
	#base_eudemons_strength{pos = 5,level = 56,attr = [{2,11200},{4,280}],exp = 305};

get_strength(5,57) ->
	#base_eudemons_strength{pos = 5,level = 57,attr = [{2,11400},{4,285}],exp = 314};

get_strength(5,58) ->
	#base_eudemons_strength{pos = 5,level = 58,attr = [{2,11600},{4,290}],exp = 324};

get_strength(5,59) ->
	#base_eudemons_strength{pos = 5,level = 59,attr = [{2,11800},{4,295}],exp = 334};

get_strength(5,60) ->
	#base_eudemons_strength{pos = 5,level = 60,attr = [{2,12000},{4,300}],exp = 343};

get_strength(5,61) ->
	#base_eudemons_strength{pos = 5,level = 61,attr = [{2,12200},{4,305}],exp = 353};

get_strength(5,62) ->
	#base_eudemons_strength{pos = 5,level = 62,attr = [{2,12400},{4,310}],exp = 364};

get_strength(5,63) ->
	#base_eudemons_strength{pos = 5,level = 63,attr = [{2,12600},{4,315}],exp = 374};

get_strength(5,64) ->
	#base_eudemons_strength{pos = 5,level = 64,attr = [{2,12800},{4,320}],exp = 385};

get_strength(5,65) ->
	#base_eudemons_strength{pos = 5,level = 65,attr = [{2,13000},{4,325}],exp = 396};

get_strength(5,66) ->
	#base_eudemons_strength{pos = 5,level = 66,attr = [{2,13200},{4,330}],exp = 407};

get_strength(5,67) ->
	#base_eudemons_strength{pos = 5,level = 67,attr = [{2,13400},{4,335}],exp = 418};

get_strength(5,68) ->
	#base_eudemons_strength{pos = 5,level = 68,attr = [{2,13600},{4,340}],exp = 428};

get_strength(5,69) ->
	#base_eudemons_strength{pos = 5,level = 69,attr = [{2,13800},{4,345}],exp = 439};

get_strength(5,70) ->
	#base_eudemons_strength{pos = 5,level = 70,attr = [{2,14000},{4,350}],exp = 451};

get_strength(5,71) ->
	#base_eudemons_strength{pos = 5,level = 71,attr = [{2,14200},{4,355}],exp = 463};

get_strength(5,72) ->
	#base_eudemons_strength{pos = 5,level = 72,attr = [{2,14400},{4,360}],exp = 475};

get_strength(5,73) ->
	#base_eudemons_strength{pos = 5,level = 73,attr = [{2,14600},{4,365}],exp = 487};

get_strength(5,74) ->
	#base_eudemons_strength{pos = 5,level = 74,attr = [{2,14800},{4,370}],exp = 499};

get_strength(5,75) ->
	#base_eudemons_strength{pos = 5,level = 75,attr = [{2,15000},{4,375}],exp = 511};

get_strength(5,76) ->
	#base_eudemons_strength{pos = 5,level = 76,attr = [{2,15200},{4,380}],exp = 523};

get_strength(5,77) ->
	#base_eudemons_strength{pos = 5,level = 77,attr = [{2,15400},{4,385}],exp = 535};

get_strength(5,78) ->
	#base_eudemons_strength{pos = 5,level = 78,attr = [{2,15600},{4,390}],exp = 548};

get_strength(5,79) ->
	#base_eudemons_strength{pos = 5,level = 79,attr = [{2,15800},{4,395}],exp = 562};

get_strength(5,80) ->
	#base_eudemons_strength{pos = 5,level = 80,attr = [{2,16000},{4,400}],exp = 575};

get_strength(5,81) ->
	#base_eudemons_strength{pos = 5,level = 81,attr = [{2,16200},{4,405}],exp = 588};

get_strength(5,82) ->
	#base_eudemons_strength{pos = 5,level = 82,attr = [{2,16400},{4,410}],exp = 601};

get_strength(5,83) ->
	#base_eudemons_strength{pos = 5,level = 83,attr = [{2,16600},{4,415}],exp = 614};

get_strength(5,84) ->
	#base_eudemons_strength{pos = 5,level = 84,attr = [{2,16800},{4,420}],exp = 628};

get_strength(5,85) ->
	#base_eudemons_strength{pos = 5,level = 85,attr = [{2,17000},{4,425}],exp = 641};

get_strength(5,86) ->
	#base_eudemons_strength{pos = 5,level = 86,attr = [{2,17200},{4,430}],exp = 655};

get_strength(5,87) ->
	#base_eudemons_strength{pos = 5,level = 87,attr = [{2,17400},{4,435}],exp = 670};

get_strength(5,88) ->
	#base_eudemons_strength{pos = 5,level = 88,attr = [{2,17600},{4,440}],exp = 684};

get_strength(5,89) ->
	#base_eudemons_strength{pos = 5,level = 89,attr = [{2,17800},{4,445}],exp = 698};

get_strength(5,90) ->
	#base_eudemons_strength{pos = 5,level = 90,attr = [{2,18000},{4,450}],exp = 713};

get_strength(5,91) ->
	#base_eudemons_strength{pos = 5,level = 91,attr = [{2,18200},{4,455}],exp = 727};

get_strength(5,92) ->
	#base_eudemons_strength{pos = 5,level = 92,attr = [{2,18400},{4,460}],exp = 742};

get_strength(5,93) ->
	#base_eudemons_strength{pos = 5,level = 93,attr = [{2,18600},{4,465}],exp = 756};

get_strength(5,94) ->
	#base_eudemons_strength{pos = 5,level = 94,attr = [{2,18800},{4,470}],exp = 772};

get_strength(5,95) ->
	#base_eudemons_strength{pos = 5,level = 95,attr = [{2,19000},{4,475}],exp = 787};

get_strength(5,96) ->
	#base_eudemons_strength{pos = 5,level = 96,attr = [{2,19200},{4,480}],exp = 803};

get_strength(5,97) ->
	#base_eudemons_strength{pos = 5,level = 97,attr = [{2,19400},{4,485}],exp = 818};

get_strength(5,98) ->
	#base_eudemons_strength{pos = 5,level = 98,attr = [{2,19600},{4,490}],exp = 834};

get_strength(5,99) ->
	#base_eudemons_strength{pos = 5,level = 99,attr = [{2,19800},{4,495}],exp = 850};

get_strength(5,100) ->
	#base_eudemons_strength{pos = 5,level = 100,attr = [{2,20000},{4,500}],exp = 865};

get_strength(5,101) ->
	#base_eudemons_strength{pos = 5,level = 101,attr = [{2,20200},{4,505}],exp = 881};

get_strength(5,102) ->
	#base_eudemons_strength{pos = 5,level = 102,attr = [{2,20400},{4,510}],exp = 898};

get_strength(5,103) ->
	#base_eudemons_strength{pos = 5,level = 103,attr = [{2,20600},{4,515}],exp = 914};

get_strength(5,104) ->
	#base_eudemons_strength{pos = 5,level = 104,attr = [{2,20800},{4,520}],exp = 931};

get_strength(5,105) ->
	#base_eudemons_strength{pos = 5,level = 105,attr = [{2,21000},{4,525}],exp = 948};

get_strength(5,106) ->
	#base_eudemons_strength{pos = 5,level = 106,attr = [{2,21200},{4,530}],exp = 965};

get_strength(5,107) ->
	#base_eudemons_strength{pos = 5,level = 107,attr = [{2,21400},{4,535}],exp = 982};

get_strength(5,108) ->
	#base_eudemons_strength{pos = 5,level = 108,attr = [{2,21600},{4,540}],exp = 998};

get_strength(5,109) ->
	#base_eudemons_strength{pos = 5,level = 109,attr = [{2,21800},{4,545}],exp = 1015};

get_strength(5,110) ->
	#base_eudemons_strength{pos = 5,level = 110,attr = [{2,22000},{4,550}],exp = 1033};

get_strength(5,111) ->
	#base_eudemons_strength{pos = 5,level = 111,attr = [{2,22200},{4,555}],exp = 1051};

get_strength(5,112) ->
	#base_eudemons_strength{pos = 5,level = 112,attr = [{2,22400},{4,560}],exp = 1069};

get_strength(5,113) ->
	#base_eudemons_strength{pos = 5,level = 113,attr = [{2,22600},{4,565}],exp = 1087};

get_strength(5,114) ->
	#base_eudemons_strength{pos = 5,level = 114,attr = [{2,22800},{4,570}],exp = 1105};

get_strength(5,115) ->
	#base_eudemons_strength{pos = 5,level = 115,attr = [{2,23000},{4,575}],exp = 1123};

get_strength(5,116) ->
	#base_eudemons_strength{pos = 5,level = 116,attr = [{2,23200},{4,580}],exp = 1141};

get_strength(5,117) ->
	#base_eudemons_strength{pos = 5,level = 117,attr = [{2,23400},{4,585}],exp = 1159};

get_strength(5,118) ->
	#base_eudemons_strength{pos = 5,level = 118,attr = [{2,23600},{4,590}],exp = 1178};

get_strength(5,119) ->
	#base_eudemons_strength{pos = 5,level = 119,attr = [{2,23800},{4,595}],exp = 1198};

get_strength(5,120) ->
	#base_eudemons_strength{pos = 5,level = 120,attr = [{2,24000},{4,600}],exp = 1217};

get_strength(5,121) ->
	#base_eudemons_strength{pos = 5,level = 121,attr = [{2,24200},{4,605}],exp = 1222};

get_strength(5,122) ->
	#base_eudemons_strength{pos = 5,level = 122,attr = [{2,24400},{4,610}],exp = 1226};

get_strength(5,123) ->
	#base_eudemons_strength{pos = 5,level = 123,attr = [{2,24600},{4,615}],exp = 1231};

get_strength(5,124) ->
	#base_eudemons_strength{pos = 5,level = 124,attr = [{2,24800},{4,620}],exp = 1236};

get_strength(5,125) ->
	#base_eudemons_strength{pos = 5,level = 125,attr = [{2,25000},{4,625}],exp = 1241};

get_strength(5,126) ->
	#base_eudemons_strength{pos = 5,level = 126,attr = [{2,25200},{4,630}],exp = 1246};

get_strength(5,127) ->
	#base_eudemons_strength{pos = 5,level = 127,attr = [{2,25400},{4,635}],exp = 1250};

get_strength(5,128) ->
	#base_eudemons_strength{pos = 5,level = 128,attr = [{2,25600},{4,640}],exp = 1255};

get_strength(5,129) ->
	#base_eudemons_strength{pos = 5,level = 129,attr = [{2,25800},{4,645}],exp = 1260};

get_strength(5,130) ->
	#base_eudemons_strength{pos = 5,level = 130,attr = [{2,26000},{4,650}],exp = 1265};

get_strength(5,131) ->
	#base_eudemons_strength{pos = 5,level = 131,attr = [{2,26200},{4,655}],exp = 1270};

get_strength(5,132) ->
	#base_eudemons_strength{pos = 5,level = 132,attr = [{2,26400},{4,660}],exp = 1274};

get_strength(5,133) ->
	#base_eudemons_strength{pos = 5,level = 133,attr = [{2,26600},{4,665}],exp = 1279};

get_strength(5,134) ->
	#base_eudemons_strength{pos = 5,level = 134,attr = [{2,26800},{4,670}],exp = 1284};

get_strength(5,135) ->
	#base_eudemons_strength{pos = 5,level = 135,attr = [{2,27000},{4,675}],exp = 1289};

get_strength(5,136) ->
	#base_eudemons_strength{pos = 5,level = 136,attr = [{2,27200},{4,680}],exp = 1294};

get_strength(5,137) ->
	#base_eudemons_strength{pos = 5,level = 137,attr = [{2,27400},{4,685}],exp = 1298};

get_strength(5,138) ->
	#base_eudemons_strength{pos = 5,level = 138,attr = [{2,27600},{4,690}],exp = 1303};

get_strength(5,139) ->
	#base_eudemons_strength{pos = 5,level = 139,attr = [{2,27800},{4,695}],exp = 1308};

get_strength(5,140) ->
	#base_eudemons_strength{pos = 5,level = 140,attr = [{2,28000},{4,700}],exp = 1313};

get_strength(5,141) ->
	#base_eudemons_strength{pos = 5,level = 141,attr = [{2,28200},{4,705}],exp = 1318};

get_strength(5,142) ->
	#base_eudemons_strength{pos = 5,level = 142,attr = [{2,28400},{4,710}],exp = 1322};

get_strength(5,143) ->
	#base_eudemons_strength{pos = 5,level = 143,attr = [{2,28600},{4,715}],exp = 1327};

get_strength(5,144) ->
	#base_eudemons_strength{pos = 5,level = 144,attr = [{2,28800},{4,720}],exp = 1332};

get_strength(5,145) ->
	#base_eudemons_strength{pos = 5,level = 145,attr = [{2,29000},{4,725}],exp = 1337};

get_strength(5,146) ->
	#base_eudemons_strength{pos = 5,level = 146,attr = [{2,29200},{4,730}],exp = 1342};

get_strength(5,147) ->
	#base_eudemons_strength{pos = 5,level = 147,attr = [{2,29400},{4,735}],exp = 1346};

get_strength(5,148) ->
	#base_eudemons_strength{pos = 5,level = 148,attr = [{2,29600},{4,740}],exp = 1351};

get_strength(5,149) ->
	#base_eudemons_strength{pos = 5,level = 149,attr = [{2,29800},{4,745}],exp = 1356};

get_strength(5,150) ->
	#base_eudemons_strength{pos = 5,level = 150,attr = [{2,30000},{4,750}],exp = 1361};

get_strength(5,151) ->
	#base_eudemons_strength{pos = 5,level = 151,attr = [{2,30200},{4,755}],exp = 1366};

get_strength(5,152) ->
	#base_eudemons_strength{pos = 5,level = 152,attr = [{2,30400},{4,760}],exp = 1370};

get_strength(5,153) ->
	#base_eudemons_strength{pos = 5,level = 153,attr = [{2,30600},{4,765}],exp = 1375};

get_strength(5,154) ->
	#base_eudemons_strength{pos = 5,level = 154,attr = [{2,30800},{4,770}],exp = 1380};

get_strength(5,155) ->
	#base_eudemons_strength{pos = 5,level = 155,attr = [{2,31000},{4,775}],exp = 1385};

get_strength(5,156) ->
	#base_eudemons_strength{pos = 5,level = 156,attr = [{2,31200},{4,780}],exp = 1390};

get_strength(5,157) ->
	#base_eudemons_strength{pos = 5,level = 157,attr = [{2,31400},{4,785}],exp = 1394};

get_strength(5,158) ->
	#base_eudemons_strength{pos = 5,level = 158,attr = [{2,31600},{4,790}],exp = 1399};

get_strength(5,159) ->
	#base_eudemons_strength{pos = 5,level = 159,attr = [{2,31800},{4,795}],exp = 1404};

get_strength(5,160) ->
	#base_eudemons_strength{pos = 5,level = 160,attr = [{2,32000},{4,800}],exp = 1409};

get_strength(5,161) ->
	#base_eudemons_strength{pos = 5,level = 161,attr = [{2,32200},{4,805}],exp = 1414};

get_strength(5,162) ->
	#base_eudemons_strength{pos = 5,level = 162,attr = [{2,32400},{4,810}],exp = 1418};

get_strength(5,163) ->
	#base_eudemons_strength{pos = 5,level = 163,attr = [{2,32600},{4,815}],exp = 1423};

get_strength(5,164) ->
	#base_eudemons_strength{pos = 5,level = 164,attr = [{2,32800},{4,820}],exp = 1428};

get_strength(5,165) ->
	#base_eudemons_strength{pos = 5,level = 165,attr = [{2,33000},{4,825}],exp = 1433};

get_strength(5,166) ->
	#base_eudemons_strength{pos = 5,level = 166,attr = [{2,33200},{4,830}],exp = 1438};

get_strength(5,167) ->
	#base_eudemons_strength{pos = 5,level = 167,attr = [{2,33400},{4,835}],exp = 1442};

get_strength(5,168) ->
	#base_eudemons_strength{pos = 5,level = 168,attr = [{2,33600},{4,840}],exp = 1447};

get_strength(5,169) ->
	#base_eudemons_strength{pos = 5,level = 169,attr = [{2,33800},{4,845}],exp = 1452};

get_strength(5,170) ->
	#base_eudemons_strength{pos = 5,level = 170,attr = [{2,34000},{4,850}],exp = 1457};

get_strength(5,171) ->
	#base_eudemons_strength{pos = 5,level = 171,attr = [{2,34200},{4,855}],exp = 1462};

get_strength(5,172) ->
	#base_eudemons_strength{pos = 5,level = 172,attr = [{2,34400},{4,860}],exp = 1466};

get_strength(5,173) ->
	#base_eudemons_strength{pos = 5,level = 173,attr = [{2,34600},{4,865}],exp = 1471};

get_strength(5,174) ->
	#base_eudemons_strength{pos = 5,level = 174,attr = [{2,34800},{4,870}],exp = 1476};

get_strength(5,175) ->
	#base_eudemons_strength{pos = 5,level = 175,attr = [{2,35000},{4,875}],exp = 1481};

get_strength(5,176) ->
	#base_eudemons_strength{pos = 5,level = 176,attr = [{2,35200},{4,880}],exp = 1486};

get_strength(5,177) ->
	#base_eudemons_strength{pos = 5,level = 177,attr = [{2,35400},{4,885}],exp = 1490};

get_strength(5,178) ->
	#base_eudemons_strength{pos = 5,level = 178,attr = [{2,35600},{4,890}],exp = 1495};

get_strength(5,179) ->
	#base_eudemons_strength{pos = 5,level = 179,attr = [{2,35800},{4,895}],exp = 1500};

get_strength(5,180) ->
	#base_eudemons_strength{pos = 5,level = 180,attr = [{2,36000},{4,900}],exp = 1505};

get_strength(5,181) ->
	#base_eudemons_strength{pos = 5,level = 181,attr = [{2,36200},{4,905}],exp = 1510};

get_strength(5,182) ->
	#base_eudemons_strength{pos = 5,level = 182,attr = [{2,36400},{4,910}],exp = 1514};

get_strength(5,183) ->
	#base_eudemons_strength{pos = 5,level = 183,attr = [{2,36600},{4,915}],exp = 1519};

get_strength(5,184) ->
	#base_eudemons_strength{pos = 5,level = 184,attr = [{2,36800},{4,920}],exp = 1524};

get_strength(5,185) ->
	#base_eudemons_strength{pos = 5,level = 185,attr = [{2,37000},{4,925}],exp = 1529};

get_strength(5,186) ->
	#base_eudemons_strength{pos = 5,level = 186,attr = [{2,37200},{4,930}],exp = 1534};

get_strength(5,187) ->
	#base_eudemons_strength{pos = 5,level = 187,attr = [{2,37400},{4,935}],exp = 1538};

get_strength(5,188) ->
	#base_eudemons_strength{pos = 5,level = 188,attr = [{2,37600},{4,940}],exp = 1543};

get_strength(5,189) ->
	#base_eudemons_strength{pos = 5,level = 189,attr = [{2,37800},{4,945}],exp = 1548};

get_strength(5,190) ->
	#base_eudemons_strength{pos = 5,level = 190,attr = [{2,38000},{4,950}],exp = 1553};

get_strength(5,191) ->
	#base_eudemons_strength{pos = 5,level = 191,attr = [{2,38200},{4,955}],exp = 1558};

get_strength(5,192) ->
	#base_eudemons_strength{pos = 5,level = 192,attr = [{2,38400},{4,960}],exp = 1562};

get_strength(5,193) ->
	#base_eudemons_strength{pos = 5,level = 193,attr = [{2,38600},{4,965}],exp = 1567};

get_strength(5,194) ->
	#base_eudemons_strength{pos = 5,level = 194,attr = [{2,38800},{4,970}],exp = 1572};

get_strength(5,195) ->
	#base_eudemons_strength{pos = 5,level = 195,attr = [{2,39000},{4,975}],exp = 1577};

get_strength(5,196) ->
	#base_eudemons_strength{pos = 5,level = 196,attr = [{2,39200},{4,980}],exp = 1582};

get_strength(5,197) ->
	#base_eudemons_strength{pos = 5,level = 197,attr = [{2,39400},{4,985}],exp = 1586};

get_strength(5,198) ->
	#base_eudemons_strength{pos = 5,level = 198,attr = [{2,39600},{4,990}],exp = 1591};

get_strength(5,199) ->
	#base_eudemons_strength{pos = 5,level = 199,attr = [{2,39800},{4,995}],exp = 1596};

get_strength(5,200) ->
	#base_eudemons_strength{pos = 5,level = 200,attr = [{2,40000},{4,1000}],exp = 1601};

get_strength(_Pos,_Level) ->
	[].

get_cfg(default,fight_location) ->
3;

get_cfg(fight_location_cost,1) ->
[{cost, [{0,39510011,1}]}, {lv,0}, {lv_limit,320}];

get_cfg(fight_location_cost,2) ->
[{cost, [{0,39510011,1}]}, {lv,0}, {lv_limit,450}];

get_cfg(fight_location_cost,3) ->
[{cost, [{0,39510011,1}]}, {lv,0}, {lv_limit,500}];

get_cfg(open_lv,lv) ->
320;

get_cfg(strength_cost_gold,cost) ->
[{2,0,1}];

get_cfg(stren_cfg,cost) ->
[39510000, 10];

get_cfg(_Key,_Args) ->
	undefined.

get_compose_cfg(1001) ->
	#base_eudemons_compose{id = 1001,material = [39010000,39020000,39030000,39040000,39050000],cnum = 4,reward = [{100,39010201},{100,39020201},{100,39030201},{100,39040201},{100,39050201}],num = 1};

get_compose_cfg(1002) ->
	#base_eudemons_compose{id = 1002,material = [39010201,39020201,39030201,39040201,39050201],cnum = 4,reward = [{100,39010301},{100,39020301},{100,39030301},{100,39040301},{100,39050301}],num = 1};

get_compose_cfg(1003) ->
	#base_eudemons_compose{id = 1003,material = [39010301,39020301,39030301,39040301,39050301],cnum = 4,reward = [{100,39010401},{100,39020401},{100,39030401},{100,39040401},{100,39050401}],num = 1};

get_compose_cfg(1004) ->
	#base_eudemons_compose{id = 1004,material = [39010401,39020401,39030401,39040401,39050401],cnum = 4,reward = [{100,39010402},{100,39020402},{100,39030402},{100,39040402},{100,39050402}],num = 1};

get_compose_cfg(1005) ->
	#base_eudemons_compose{id = 1005,material = [39010402,39020402,39030402,39040402,39050402],cnum = 4,reward = [{100,39010502},{100,39020502},{100,39030502},{100,39040502},{100,39050502}],num = 1};

get_compose_cfg(_Id) ->
	[].

get_all_old_id() ->
[39010202,39010302,39010501,39020202,39020302,39020501,39030202,39030302,39030501,39040202,39040302,39040501,39050202,39050302,39050501].


get_new_id(39010202) ->
39010201;


get_new_id(39010302) ->
39010301;


get_new_id(39010501) ->
39010502;


get_new_id(39020202) ->
39020201;


get_new_id(39020302) ->
39020301;


get_new_id(39020501) ->
39020502;


get_new_id(39030202) ->
39030201;


get_new_id(39030302) ->
39030301;


get_new_id(39030501) ->
39030502;


get_new_id(39040202) ->
39040201;


get_new_id(39040302) ->
39040301;


get_new_id(39040501) ->
39040502;


get_new_id(39050202) ->
39050201;


get_new_id(39050302) ->
39050301;


get_new_id(39050501) ->
39050502;

get_new_id(_Id) ->
	[].

