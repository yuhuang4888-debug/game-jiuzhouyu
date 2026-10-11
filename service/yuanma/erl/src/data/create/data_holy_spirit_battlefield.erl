%%%---------------------------------------
%%% module      : data_holy_spirit_battlefield
%%% description : 圣灵战场配置
%%%
%%%---------------------------------------
-module(data_holy_spirit_battlefield).
-compile(export_all).
-include("holy_spirit_battlefield.hrl").



get_mod_cfg(1) ->
	#mod_cfg{mod = 1,name = "本服模式",min_world_lv = 1,max_world_lv = 200,open_day = 0,room_num = 30};

get_mod_cfg(2) ->
	#mod_cfg{mod = 2,name = "2服模式",min_world_lv = 201,max_world_lv = 280,open_day = 5,room_num = 30};

get_mod_cfg(4) ->
	#mod_cfg{mod = 4,name = "4服模式",min_world_lv = 281,max_world_lv = 330,open_day = 9,room_num = 30};

get_mod_cfg(8) ->
	#mod_cfg{mod = 8,name = "8服模式",min_world_lv = 331,max_world_lv = 9999,open_day = 18,room_num = 30};

get_mod_cfg(_Mod) ->
	[].

get_mod_cfg_list() ->
[{1,1,200,0},{2,201,280,5},{4,281,330,9},{8,331,9999,18}].


get_kv(anger) ->
10;


get_kv(anger_skill) ->
4700105;


get_kv(assists_integral) ->
20;


get_kv(attack) ->
1;


get_kv(buff_list) ->
[{1,[]},{2,[{22,2500}]},{3,[{22,2500}]},{4,[{22,5000}]}];


get_kv(destroy) ->
500;


get_kv(exp_time) ->
5;


get_kv(kill_integral) ->
50;


get_kv(kill_tv) ->
3;


get_kv(local_week) ->
[{1, 29, [1,3,5,7]}, {30, 99999, [1,3,5]}];


get_kv(lv_limit) ->
1;


get_kv(max_anger) ->
50;


get_kv(occupy) ->
5;


get_kv(open_day) ->
1;


get_kv(open_time) ->
{{20,30}, {20, 50}};


get_kv(pk_scene) ->
47001;


get_kv(pk_scene_local) ->
47002;


get_kv(pk_time) ->
900;


get_kv(reborn_skill) ->
4700104;


get_kv(relive_time) ->
10;


get_kv(scene_point_time) ->
5;


get_kv(sence_point) ->
5;


get_kv(sence_point_time) ->
5;


get_kv(tower_list) ->
[{[{0, 4700401}, {1, 4700201}, {2, 4700301}, {3, 4700101}], 2270,2114},{[{0, 4700402}, {1, 4700202}, {2, 4700302}, {3, 4700102}],1348,2628},{[{0, 4700403}, {1, 4700203}, {2, 4700303}, {3, 4700103}],2269,1330},{[{0, 4700404}, {1, 4700204}, {2, 4700304}, {3, 4700104}], 3300,2755}];


get_kv(wait_scene) ->
47003;


get_kv(wait_scene_local) ->
47004;


get_kv(wait_time) ->
30;


get_kv(week) ->
[1,3,5,7];

get_kv(_Key) ->
	[].

get_exp(_Lv) when _Lv >= 1, _Lv =< 1 ->
		[{5,0,33999}];
get_exp(_Lv) when _Lv >= 2, _Lv =< 2 ->
		[{5,0,34114}];
get_exp(_Lv) when _Lv >= 3, _Lv =< 3 ->
		[{5,0,34230}];
get_exp(_Lv) when _Lv >= 4, _Lv =< 4 ->
		[{5,0,34346}];
get_exp(_Lv) when _Lv >= 5, _Lv =< 5 ->
		[{5,0,34462}];
get_exp(_Lv) when _Lv >= 6, _Lv =< 6 ->
		[{5,0,34579}];
get_exp(_Lv) when _Lv >= 7, _Lv =< 7 ->
		[{5,0,34696}];
get_exp(_Lv) when _Lv >= 8, _Lv =< 8 ->
		[{5,0,34813}];
get_exp(_Lv) when _Lv >= 9, _Lv =< 9 ->
		[{5,0,34931}];
get_exp(_Lv) when _Lv >= 10, _Lv =< 10 ->
		[{5,0,35049}];
get_exp(_Lv) when _Lv >= 11, _Lv =< 11 ->
		[{5,0,35168}];
get_exp(_Lv) when _Lv >= 12, _Lv =< 12 ->
		[{5,0,35287}];
get_exp(_Lv) when _Lv >= 13, _Lv =< 13 ->
		[{5,0,35406}];
get_exp(_Lv) when _Lv >= 14, _Lv =< 14 ->
		[{5,0,35526}];
get_exp(_Lv) when _Lv >= 15, _Lv =< 15 ->
		[{5,0,35646}];
get_exp(_Lv) when _Lv >= 16, _Lv =< 16 ->
		[{5,0,35767}];
get_exp(_Lv) when _Lv >= 17, _Lv =< 17 ->
		[{5,0,35888}];
get_exp(_Lv) when _Lv >= 18, _Lv =< 18 ->
		[{5,0,36009}];
get_exp(_Lv) when _Lv >= 19, _Lv =< 19 ->
		[{5,0,36131}];
get_exp(_Lv) when _Lv >= 20, _Lv =< 20 ->
		[{5,0,36254}];
get_exp(_Lv) when _Lv >= 21, _Lv =< 21 ->
		[{5,0,36376}];
get_exp(_Lv) when _Lv >= 22, _Lv =< 22 ->
		[{5,0,36499}];
get_exp(_Lv) when _Lv >= 23, _Lv =< 23 ->
		[{5,0,36623}];
get_exp(_Lv) when _Lv >= 24, _Lv =< 24 ->
		[{5,0,36747}];
get_exp(_Lv) when _Lv >= 25, _Lv =< 25 ->
		[{5,0,36871}];
get_exp(_Lv) when _Lv >= 26, _Lv =< 26 ->
		[{5,0,36996}];
get_exp(_Lv) when _Lv >= 27, _Lv =< 27 ->
		[{5,0,37121}];
get_exp(_Lv) when _Lv >= 28, _Lv =< 28 ->
		[{5,0,37247}];
get_exp(_Lv) when _Lv >= 29, _Lv =< 29 ->
		[{5,0,37373}];
get_exp(_Lv) when _Lv >= 30, _Lv =< 30 ->
		[{5,0,37499}];
get_exp(_Lv) when _Lv >= 31, _Lv =< 31 ->
		[{5,0,37626}];
get_exp(_Lv) when _Lv >= 32, _Lv =< 32 ->
		[{5,0,37754}];
get_exp(_Lv) when _Lv >= 33, _Lv =< 33 ->
		[{5,0,37882}];
get_exp(_Lv) when _Lv >= 34, _Lv =< 34 ->
		[{5,0,38010}];
get_exp(_Lv) when _Lv >= 35, _Lv =< 35 ->
		[{5,0,38138}];
get_exp(_Lv) when _Lv >= 36, _Lv =< 36 ->
		[{5,0,38267}];
get_exp(_Lv) when _Lv >= 37, _Lv =< 37 ->
		[{5,0,38397}];
get_exp(_Lv) when _Lv >= 38, _Lv =< 38 ->
		[{5,0,38527}];
get_exp(_Lv) when _Lv >= 39, _Lv =< 39 ->
		[{5,0,38657}];
get_exp(_Lv) when _Lv >= 40, _Lv =< 40 ->
		[{5,0,38788}];
get_exp(_Lv) when _Lv >= 41, _Lv =< 41 ->
		[{5,0,38919}];
get_exp(_Lv) when _Lv >= 42, _Lv =< 42 ->
		[{5,0,39051}];
get_exp(_Lv) when _Lv >= 43, _Lv =< 43 ->
		[{5,0,39183}];
get_exp(_Lv) when _Lv >= 44, _Lv =< 44 ->
		[{5,0,39316}];
get_exp(_Lv) when _Lv >= 45, _Lv =< 45 ->
		[{5,0,39449}];
get_exp(_Lv) when _Lv >= 46, _Lv =< 46 ->
		[{5,0,39583}];
get_exp(_Lv) when _Lv >= 47, _Lv =< 47 ->
		[{5,0,39717}];
get_exp(_Lv) when _Lv >= 48, _Lv =< 48 ->
		[{5,0,39851}];
get_exp(_Lv) when _Lv >= 49, _Lv =< 49 ->
		[{5,0,39986}];
get_exp(_Lv) when _Lv >= 50, _Lv =< 50 ->
		[{5,0,40121}];
get_exp(_Lv) when _Lv >= 51, _Lv =< 51 ->
		[{5,0,40257}];
get_exp(_Lv) when _Lv >= 52, _Lv =< 52 ->
		[{5,0,40393}];
get_exp(_Lv) when _Lv >= 53, _Lv =< 53 ->
		[{5,0,40530}];
get_exp(_Lv) when _Lv >= 54, _Lv =< 54 ->
		[{5,0,40667}];
get_exp(_Lv) when _Lv >= 55, _Lv =< 55 ->
		[{5,0,40805}];
get_exp(_Lv) when _Lv >= 56, _Lv =< 56 ->
		[{5,0,40943}];
get_exp(_Lv) when _Lv >= 57, _Lv =< 57 ->
		[{5,0,41081}];
get_exp(_Lv) when _Lv >= 58, _Lv =< 58 ->
		[{5,0,41220}];
get_exp(_Lv) when _Lv >= 59, _Lv =< 59 ->
		[{5,0,41360}];
get_exp(_Lv) when _Lv >= 60, _Lv =< 60 ->
		[{5,0,41500}];
get_exp(_Lv) when _Lv >= 61, _Lv =< 61 ->
		[{5,0,41640}];
get_exp(_Lv) when _Lv >= 62, _Lv =< 62 ->
		[{5,0,41781}];
get_exp(_Lv) when _Lv >= 63, _Lv =< 63 ->
		[{5,0,41923}];
get_exp(_Lv) when _Lv >= 64, _Lv =< 64 ->
		[{5,0,42065}];
get_exp(_Lv) when _Lv >= 65, _Lv =< 65 ->
		[{5,0,42207}];
get_exp(_Lv) when _Lv >= 66, _Lv =< 66 ->
		[{5,0,42350}];
get_exp(_Lv) when _Lv >= 67, _Lv =< 67 ->
		[{5,0,42493}];
get_exp(_Lv) when _Lv >= 68, _Lv =< 68 ->
		[{5,0,42637}];
get_exp(_Lv) when _Lv >= 69, _Lv =< 69 ->
		[{5,0,42781}];
get_exp(_Lv) when _Lv >= 70, _Lv =< 70 ->
		[{5,0,42926}];
get_exp(_Lv) when _Lv >= 71, _Lv =< 71 ->
		[{5,0,43071}];
get_exp(_Lv) when _Lv >= 72, _Lv =< 72 ->
		[{5,0,43217}];
get_exp(_Lv) when _Lv >= 73, _Lv =< 73 ->
		[{5,0,43364}];
get_exp(_Lv) when _Lv >= 74, _Lv =< 74 ->
		[{5,0,43510}];
get_exp(_Lv) when _Lv >= 75, _Lv =< 75 ->
		[{5,0,43658}];
get_exp(_Lv) when _Lv >= 76, _Lv =< 76 ->
		[{5,0,43805}];
get_exp(_Lv) when _Lv >= 77, _Lv =< 77 ->
		[{5,0,43954}];
get_exp(_Lv) when _Lv >= 78, _Lv =< 78 ->
		[{5,0,44102}];
get_exp(_Lv) when _Lv >= 79, _Lv =< 79 ->
		[{5,0,44252}];
get_exp(_Lv) when _Lv >= 80, _Lv =< 80 ->
		[{5,0,44401}];
get_exp(_Lv) when _Lv >= 81, _Lv =< 81 ->
		[{5,0,44552}];
get_exp(_Lv) when _Lv >= 82, _Lv =< 82 ->
		[{5,0,44702}];
get_exp(_Lv) when _Lv >= 83, _Lv =< 83 ->
		[{5,0,44854}];
get_exp(_Lv) when _Lv >= 84, _Lv =< 84 ->
		[{5,0,45006}];
get_exp(_Lv) when _Lv >= 85, _Lv =< 85 ->
		[{5,0,45158}];
get_exp(_Lv) when _Lv >= 86, _Lv =< 86 ->
		[{5,0,45311}];
get_exp(_Lv) when _Lv >= 87, _Lv =< 87 ->
		[{5,0,45464}];
get_exp(_Lv) when _Lv >= 88, _Lv =< 88 ->
		[{5,0,45618}];
get_exp(_Lv) when _Lv >= 89, _Lv =< 89 ->
		[{5,0,45772}];
get_exp(_Lv) when _Lv >= 90, _Lv =< 90 ->
		[{5,0,45927}];
get_exp(_Lv) when _Lv >= 91, _Lv =< 91 ->
		[{5,0,46083}];
get_exp(_Lv) when _Lv >= 92, _Lv =< 92 ->
		[{5,0,46239}];
get_exp(_Lv) when _Lv >= 93, _Lv =< 93 ->
		[{5,0,46395}];
get_exp(_Lv) when _Lv >= 94, _Lv =< 94 ->
		[{5,0,46552}];
get_exp(_Lv) when _Lv >= 95, _Lv =< 95 ->
		[{5,0,46710}];
get_exp(_Lv) when _Lv >= 96, _Lv =< 96 ->
		[{5,0,46868}];
get_exp(_Lv) when _Lv >= 97, _Lv =< 97 ->
		[{5,0,47027}];
get_exp(_Lv) when _Lv >= 98, _Lv =< 98 ->
		[{5,0,47186}];
get_exp(_Lv) when _Lv >= 99, _Lv =< 99 ->
		[{5,0,47345}];
get_exp(_Lv) when _Lv >= 100, _Lv =< 100 ->
		[{5,0,47506}];
get_exp(_Lv) when _Lv >= 101, _Lv =< 101 ->
		[{5,0,47666}];
get_exp(_Lv) when _Lv >= 102, _Lv =< 102 ->
		[{5,0,47828}];
get_exp(_Lv) when _Lv >= 103, _Lv =< 103 ->
		[{5,0,47990}];
get_exp(_Lv) when _Lv >= 104, _Lv =< 104 ->
		[{5,0,48152}];
get_exp(_Lv) when _Lv >= 105, _Lv =< 105 ->
		[{5,0,48315}];
get_exp(_Lv) when _Lv >= 106, _Lv =< 106 ->
		[{5,0,48479}];
get_exp(_Lv) when _Lv >= 107, _Lv =< 107 ->
		[{5,0,48643}];
get_exp(_Lv) when _Lv >= 108, _Lv =< 108 ->
		[{5,0,48807}];
get_exp(_Lv) when _Lv >= 109, _Lv =< 109 ->
		[{5,0,48972}];
get_exp(_Lv) when _Lv >= 110, _Lv =< 110 ->
		[{5,0,49138}];
get_exp(_Lv) when _Lv >= 111, _Lv =< 111 ->
		[{5,0,49305}];
get_exp(_Lv) when _Lv >= 112, _Lv =< 112 ->
		[{5,0,49471}];
get_exp(_Lv) when _Lv >= 113, _Lv =< 113 ->
		[{5,0,49639}];
get_exp(_Lv) when _Lv >= 114, _Lv =< 114 ->
		[{5,0,49807}];
get_exp(_Lv) when _Lv >= 115, _Lv =< 115 ->
		[{5,0,49975}];
get_exp(_Lv) when _Lv >= 116, _Lv =< 116 ->
		[{5,0,50145}];
get_exp(_Lv) when _Lv >= 117, _Lv =< 117 ->
		[{5,0,50314}];
get_exp(_Lv) when _Lv >= 118, _Lv =< 118 ->
		[{5,0,50485}];
get_exp(_Lv) when _Lv >= 119, _Lv =< 119 ->
		[{5,0,50655}];
get_exp(_Lv) when _Lv >= 120, _Lv =< 120 ->
		[{5,0,50827}];
get_exp(_Lv) when _Lv >= 121, _Lv =< 121 ->
		[{5,0,50999}];
get_exp(_Lv) when _Lv >= 122, _Lv =< 122 ->
		[{5,0,51172}];
get_exp(_Lv) when _Lv >= 123, _Lv =< 123 ->
		[{5,0,51345}];
get_exp(_Lv) when _Lv >= 124, _Lv =< 124 ->
		[{5,0,51519}];
get_exp(_Lv) when _Lv >= 125, _Lv =< 125 ->
		[{5,0,51693}];
get_exp(_Lv) when _Lv >= 126, _Lv =< 126 ->
		[{5,0,51868}];
get_exp(_Lv) when _Lv >= 127, _Lv =< 127 ->
		[{5,0,52043}];
get_exp(_Lv) when _Lv >= 128, _Lv =< 128 ->
		[{5,0,52220}];
get_exp(_Lv) when _Lv >= 129, _Lv =< 129 ->
		[{5,0,52396}];
get_exp(_Lv) when _Lv >= 130, _Lv =< 130 ->
		[{5,0,52574}];
get_exp(_Lv) when _Lv >= 131, _Lv =< 131 ->
		[{5,0,52752}];
get_exp(_Lv) when _Lv >= 132, _Lv =< 132 ->
		[{5,0,52930}];
get_exp(_Lv) when _Lv >= 133, _Lv =< 133 ->
		[{5,0,53109}];
get_exp(_Lv) when _Lv >= 134, _Lv =< 134 ->
		[{5,0,53289}];
get_exp(_Lv) when _Lv >= 135, _Lv =< 135 ->
		[{5,0,53469}];
get_exp(_Lv) when _Lv >= 136, _Lv =< 136 ->
		[{5,0,53650}];
get_exp(_Lv) when _Lv >= 137, _Lv =< 137 ->
		[{5,0,53832}];
get_exp(_Lv) when _Lv >= 138, _Lv =< 138 ->
		[{5,0,54014}];
get_exp(_Lv) when _Lv >= 139, _Lv =< 139 ->
		[{5,0,54197}];
get_exp(_Lv) when _Lv >= 140, _Lv =< 140 ->
		[{5,0,54380}];
get_exp(_Lv) when _Lv >= 141, _Lv =< 141 ->
		[{5,0,54564}];
get_exp(_Lv) when _Lv >= 142, _Lv =< 142 ->
		[{5,0,54749}];
get_exp(_Lv) when _Lv >= 143, _Lv =< 143 ->
		[{5,0,54934}];
get_exp(_Lv) when _Lv >= 144, _Lv =< 144 ->
		[{5,0,55120}];
get_exp(_Lv) when _Lv >= 145, _Lv =< 145 ->
		[{5,0,55307}];
get_exp(_Lv) when _Lv >= 146, _Lv =< 146 ->
		[{5,0,55494}];
get_exp(_Lv) when _Lv >= 147, _Lv =< 147 ->
		[{5,0,55682}];
get_exp(_Lv) when _Lv >= 148, _Lv =< 148 ->
		[{5,0,55870}];
get_exp(_Lv) when _Lv >= 149, _Lv =< 149 ->
		[{5,0,56059}];
get_exp(_Lv) when _Lv >= 150, _Lv =< 150 ->
		[{5,0,56249}];
get_exp(_Lv) when _Lv >= 151, _Lv =< 151 ->
		[{5,0,56440}];
get_exp(_Lv) when _Lv >= 152, _Lv =< 152 ->
		[{5,0,56631}];
get_exp(_Lv) when _Lv >= 153, _Lv =< 153 ->
		[{5,0,56822}];
get_exp(_Lv) when _Lv >= 154, _Lv =< 154 ->
		[{5,0,57015}];
get_exp(_Lv) when _Lv >= 155, _Lv =< 155 ->
		[{5,0,57208}];
get_exp(_Lv) when _Lv >= 156, _Lv =< 156 ->
		[{5,0,57401}];
get_exp(_Lv) when _Lv >= 157, _Lv =< 157 ->
		[{5,0,57595}];
get_exp(_Lv) when _Lv >= 158, _Lv =< 158 ->
		[{5,0,57790}];
get_exp(_Lv) when _Lv >= 159, _Lv =< 159 ->
		[{5,0,57986}];
get_exp(_Lv) when _Lv >= 160, _Lv =< 160 ->
		[{5,0,58182}];
get_exp(_Lv) when _Lv >= 161, _Lv =< 161 ->
		[{5,0,58379}];
get_exp(_Lv) when _Lv >= 162, _Lv =< 162 ->
		[{5,0,58577}];
get_exp(_Lv) when _Lv >= 163, _Lv =< 163 ->
		[{5,0,58775}];
get_exp(_Lv) when _Lv >= 164, _Lv =< 164 ->
		[{5,0,58974}];
get_exp(_Lv) when _Lv >= 165, _Lv =< 165 ->
		[{5,0,59174}];
get_exp(_Lv) when _Lv >= 166, _Lv =< 166 ->
		[{5,0,59374}];
get_exp(_Lv) when _Lv >= 167, _Lv =< 167 ->
		[{5,0,59575}];
get_exp(_Lv) when _Lv >= 168, _Lv =< 168 ->
		[{5,0,59776}];
get_exp(_Lv) when _Lv >= 169, _Lv =< 169 ->
		[{5,0,59979}];
get_exp(_Lv) when _Lv >= 170, _Lv =< 170 ->
		[{5,0,60182}];
get_exp(_Lv) when _Lv >= 171, _Lv =< 171 ->
		[{5,0,60385}];
get_exp(_Lv) when _Lv >= 172, _Lv =< 172 ->
		[{5,0,60590}];
get_exp(_Lv) when _Lv >= 173, _Lv =< 173 ->
		[{5,0,60795}];
get_exp(_Lv) when _Lv >= 174, _Lv =< 174 ->
		[{5,0,61001}];
get_exp(_Lv) when _Lv >= 175, _Lv =< 175 ->
		[{5,0,61207}];
get_exp(_Lv) when _Lv >= 176, _Lv =< 176 ->
		[{5,0,61414}];
get_exp(_Lv) when _Lv >= 177, _Lv =< 177 ->
		[{5,0,61622}];
get_exp(_Lv) when _Lv >= 178, _Lv =< 178 ->
		[{5,0,61831}];
get_exp(_Lv) when _Lv >= 179, _Lv =< 179 ->
		[{5,0,62040}];
get_exp(_Lv) when _Lv >= 180, _Lv =< 180 ->
		[{5,0,62250}];
get_exp(_Lv) when _Lv >= 181, _Lv =< 181 ->
		[{5,0,62461}];
get_exp(_Lv) when _Lv >= 182, _Lv =< 182 ->
		[{5,0,62672}];
get_exp(_Lv) when _Lv >= 183, _Lv =< 183 ->
		[{5,0,62884}];
get_exp(_Lv) when _Lv >= 184, _Lv =< 184 ->
		[{5,0,63097}];
get_exp(_Lv) when _Lv >= 185, _Lv =< 185 ->
		[{5,0,63311}];
get_exp(_Lv) when _Lv >= 186, _Lv =< 186 ->
		[{5,0,63525}];
get_exp(_Lv) when _Lv >= 187, _Lv =< 187 ->
		[{5,0,63740}];
get_exp(_Lv) when _Lv >= 188, _Lv =< 188 ->
		[{5,0,63956}];
get_exp(_Lv) when _Lv >= 189, _Lv =< 189 ->
		[{5,0,64172}];
get_exp(_Lv) when _Lv >= 190, _Lv =< 190 ->
		[{5,0,64389}];
get_exp(_Lv) when _Lv >= 191, _Lv =< 191 ->
		[{5,0,64607}];
get_exp(_Lv) when _Lv >= 192, _Lv =< 192 ->
		[{5,0,64826}];
get_exp(_Lv) when _Lv >= 193, _Lv =< 193 ->
		[{5,0,65045}];
get_exp(_Lv) when _Lv >= 194, _Lv =< 194 ->
		[{5,0,65265}];
get_exp(_Lv) when _Lv >= 195, _Lv =< 195 ->
		[{5,0,65486}];
get_exp(_Lv) when _Lv >= 196, _Lv =< 196 ->
		[{5,0,65708}];
get_exp(_Lv) when _Lv >= 197, _Lv =< 197 ->
		[{5,0,65930}];
get_exp(_Lv) when _Lv >= 198, _Lv =< 198 ->
		[{5,0,66154}];
get_exp(_Lv) when _Lv >= 199, _Lv =< 199 ->
		[{5,0,66377}];
get_exp(_Lv) when _Lv >= 200, _Lv =< 200 ->
		[{5,0,66602}];
get_exp(_Lv) when _Lv >= 201, _Lv =< 201 ->
		[{5,0,66828}];
get_exp(_Lv) when _Lv >= 202, _Lv =< 202 ->
		[{5,0,67054}];
get_exp(_Lv) when _Lv >= 203, _Lv =< 203 ->
		[{5,0,67281}];
get_exp(_Lv) when _Lv >= 204, _Lv =< 204 ->
		[{5,0,67508}];
get_exp(_Lv) when _Lv >= 205, _Lv =< 205 ->
		[{5,0,67737}];
get_exp(_Lv) when _Lv >= 206, _Lv =< 206 ->
		[{5,0,67966}];
get_exp(_Lv) when _Lv >= 207, _Lv =< 207 ->
		[{5,0,68196}];
get_exp(_Lv) when _Lv >= 208, _Lv =< 208 ->
		[{5,0,68427}];
get_exp(_Lv) when _Lv >= 209, _Lv =< 209 ->
		[{5,0,68659}];
get_exp(_Lv) when _Lv >= 210, _Lv =< 210 ->
		[{5,0,68891}];
get_exp(_Lv) when _Lv >= 211, _Lv =< 211 ->
		[{5,0,69124}];
get_exp(_Lv) when _Lv >= 212, _Lv =< 212 ->
		[{5,0,69358}];
get_exp(_Lv) when _Lv >= 213, _Lv =< 213 ->
		[{5,0,69593}];
get_exp(_Lv) when _Lv >= 214, _Lv =< 214 ->
		[{5,0,69828}];
get_exp(_Lv) when _Lv >= 215, _Lv =< 215 ->
		[{5,0,70065}];
get_exp(_Lv) when _Lv >= 216, _Lv =< 216 ->
		[{5,0,70302}];
get_exp(_Lv) when _Lv >= 217, _Lv =< 217 ->
		[{5,0,70540}];
get_exp(_Lv) when _Lv >= 218, _Lv =< 218 ->
		[{5,0,70779}];
get_exp(_Lv) when _Lv >= 219, _Lv =< 219 ->
		[{5,0,71018}];
get_exp(_Lv) when _Lv >= 220, _Lv =< 220 ->
		[{5,0,71258}];
get_exp(_Lv) when _Lv >= 221, _Lv =< 221 ->
		[{5,0,71500}];
get_exp(_Lv) when _Lv >= 222, _Lv =< 222 ->
		[{5,0,71742}];
get_exp(_Lv) when _Lv >= 223, _Lv =< 223 ->
		[{5,0,71984}];
get_exp(_Lv) when _Lv >= 224, _Lv =< 224 ->
		[{5,0,72228}];
get_exp(_Lv) when _Lv >= 225, _Lv =< 225 ->
		[{5,0,72473}];
get_exp(_Lv) when _Lv >= 226, _Lv =< 226 ->
		[{5,0,72718}];
get_exp(_Lv) when _Lv >= 227, _Lv =< 227 ->
		[{5,0,72964}];
get_exp(_Lv) when _Lv >= 228, _Lv =< 228 ->
		[{5,0,73211}];
get_exp(_Lv) when _Lv >= 229, _Lv =< 229 ->
		[{5,0,73459}];
get_exp(_Lv) when _Lv >= 230, _Lv =< 230 ->
		[{5,0,73707}];
get_exp(_Lv) when _Lv >= 231, _Lv =< 231 ->
		[{5,0,73957}];
get_exp(_Lv) when _Lv >= 232, _Lv =< 232 ->
		[{5,0,74207}];
get_exp(_Lv) when _Lv >= 233, _Lv =< 233 ->
		[{5,0,74458}];
get_exp(_Lv) when _Lv >= 234, _Lv =< 234 ->
		[{5,0,74710}];
get_exp(_Lv) when _Lv >= 235, _Lv =< 235 ->
		[{5,0,74963}];
get_exp(_Lv) when _Lv >= 236, _Lv =< 236 ->
		[{5,0,75217}];
get_exp(_Lv) when _Lv >= 237, _Lv =< 237 ->
		[{5,0,75471}];
get_exp(_Lv) when _Lv >= 238, _Lv =< 238 ->
		[{5,0,75727}];
get_exp(_Lv) when _Lv >= 239, _Lv =< 239 ->
		[{5,0,75983}];
get_exp(_Lv) when _Lv >= 240, _Lv =< 240 ->
		[{5,0,76240}];
get_exp(_Lv) when _Lv >= 241, _Lv =< 241 ->
		[{5,0,76498}];
get_exp(_Lv) when _Lv >= 242, _Lv =< 242 ->
		[{5,0,76757}];
get_exp(_Lv) when _Lv >= 243, _Lv =< 243 ->
		[{5,0,77017}];
get_exp(_Lv) when _Lv >= 244, _Lv =< 244 ->
		[{5,0,77278}];
get_exp(_Lv) when _Lv >= 245, _Lv =< 245 ->
		[{5,0,77539}];
get_exp(_Lv) when _Lv >= 246, _Lv =< 246 ->
		[{5,0,77802}];
get_exp(_Lv) when _Lv >= 247, _Lv =< 247 ->
		[{5,0,78065}];
get_exp(_Lv) when _Lv >= 248, _Lv =< 248 ->
		[{5,0,78329}];
get_exp(_Lv) when _Lv >= 249, _Lv =< 249 ->
		[{5,0,78594}];
get_exp(_Lv) when _Lv >= 250, _Lv =< 250 ->
		[{5,0,78860}];
get_exp(_Lv) when _Lv >= 251, _Lv =< 251 ->
		[{5,0,79127}];
get_exp(_Lv) when _Lv >= 252, _Lv =< 252 ->
		[{5,0,79395}];
get_exp(_Lv) when _Lv >= 253, _Lv =< 253 ->
		[{5,0,79664}];
get_exp(_Lv) when _Lv >= 254, _Lv =< 254 ->
		[{5,0,79934}];
get_exp(_Lv) when _Lv >= 255, _Lv =< 255 ->
		[{5,0,80204}];
get_exp(_Lv) when _Lv >= 256, _Lv =< 256 ->
		[{5,0,80476}];
get_exp(_Lv) when _Lv >= 257, _Lv =< 257 ->
		[{5,0,80748}];
get_exp(_Lv) when _Lv >= 258, _Lv =< 258 ->
		[{5,0,81021}];
get_exp(_Lv) when _Lv >= 259, _Lv =< 259 ->
		[{5,0,81295}];
get_exp(_Lv) when _Lv >= 260, _Lv =< 260 ->
		[{5,0,81571}];
get_exp(_Lv) when _Lv >= 261, _Lv =< 261 ->
		[{5,0,81847}];
get_exp(_Lv) when _Lv >= 262, _Lv =< 262 ->
		[{5,0,82124}];
get_exp(_Lv) when _Lv >= 263, _Lv =< 263 ->
		[{5,0,82402}];
get_exp(_Lv) when _Lv >= 264, _Lv =< 264 ->
		[{5,0,82681}];
get_exp(_Lv) when _Lv >= 265, _Lv =< 265 ->
		[{5,0,82960}];
get_exp(_Lv) when _Lv >= 266, _Lv =< 266 ->
		[{5,0,83241}];
get_exp(_Lv) when _Lv >= 267, _Lv =< 267 ->
		[{5,0,83523}];
get_exp(_Lv) when _Lv >= 268, _Lv =< 268 ->
		[{5,0,83806}];
get_exp(_Lv) when _Lv >= 269, _Lv =< 269 ->
		[{5,0,84089}];
get_exp(_Lv) when _Lv >= 270, _Lv =< 270 ->
		[{5,0,84374}];
get_exp(_Lv) when _Lv >= 271, _Lv =< 271 ->
		[{5,0,84659}];
get_exp(_Lv) when _Lv >= 272, _Lv =< 272 ->
		[{5,0,84946}];
get_exp(_Lv) when _Lv >= 273, _Lv =< 273 ->
		[{5,0,85233}];
get_exp(_Lv) when _Lv >= 274, _Lv =< 274 ->
		[{5,0,85522}];
get_exp(_Lv) when _Lv >= 275, _Lv =< 275 ->
		[{5,0,85811}];
get_exp(_Lv) when _Lv >= 276, _Lv =< 276 ->
		[{5,0,86102}];
get_exp(_Lv) when _Lv >= 277, _Lv =< 277 ->
		[{5,0,86393}];
get_exp(_Lv) when _Lv >= 278, _Lv =< 278 ->
		[{5,0,86686}];
get_exp(_Lv) when _Lv >= 279, _Lv =< 279 ->
		[{5,0,86979}];
get_exp(_Lv) when _Lv >= 280, _Lv =< 280 ->
		[{5,0,87273}];
get_exp(_Lv) when _Lv >= 281, _Lv =< 281 ->
		[{5,0,87569}];
get_exp(_Lv) when _Lv >= 282, _Lv =< 282 ->
		[{5,0,87865}];
get_exp(_Lv) when _Lv >= 283, _Lv =< 283 ->
		[{5,0,88163}];
get_exp(_Lv) when _Lv >= 284, _Lv =< 284 ->
		[{5,0,88461}];
get_exp(_Lv) when _Lv >= 285, _Lv =< 285 ->
		[{5,0,88760}];
get_exp(_Lv) when _Lv >= 286, _Lv =< 286 ->
		[{5,0,89061}];
get_exp(_Lv) when _Lv >= 287, _Lv =< 287 ->
		[{5,0,89362}];
get_exp(_Lv) when _Lv >= 288, _Lv =< 288 ->
		[{5,0,89665}];
get_exp(_Lv) when _Lv >= 289, _Lv =< 289 ->
		[{5,0,89968}];
get_exp(_Lv) when _Lv >= 290, _Lv =< 290 ->
		[{5,0,90273}];
get_exp(_Lv) when _Lv >= 291, _Lv =< 291 ->
		[{5,0,90578}];
get_exp(_Lv) when _Lv >= 292, _Lv =< 292 ->
		[{5,0,90885}];
get_exp(_Lv) when _Lv >= 293, _Lv =< 293 ->
		[{5,0,91192}];
get_exp(_Lv) when _Lv >= 294, _Lv =< 294 ->
		[{5,0,91501}];
get_exp(_Lv) when _Lv >= 295, _Lv =< 295 ->
		[{5,0,91811}];
get_exp(_Lv) when _Lv >= 296, _Lv =< 296 ->
		[{5,0,92121}];
get_exp(_Lv) when _Lv >= 297, _Lv =< 297 ->
		[{5,0,92433}];
get_exp(_Lv) when _Lv >= 298, _Lv =< 298 ->
		[{5,0,92746}];
get_exp(_Lv) when _Lv >= 299, _Lv =< 299 ->
		[{5,0,93060}];
get_exp(_Lv) when _Lv >= 300, _Lv =< 300 ->
		[{5,0,93375}];
get_exp(_Lv) when _Lv >= 301, _Lv =< 301 ->
		[{5,0,93691}];
get_exp(_Lv) when _Lv >= 302, _Lv =< 302 ->
		[{5,0,94008}];
get_exp(_Lv) when _Lv >= 303, _Lv =< 303 ->
		[{5,0,94326}];
get_exp(_Lv) when _Lv >= 304, _Lv =< 304 ->
		[{5,0,94646}];
get_exp(_Lv) when _Lv >= 305, _Lv =< 305 ->
		[{5,0,94966}];
get_exp(_Lv) when _Lv >= 306, _Lv =< 306 ->
		[{5,0,95287}];
get_exp(_Lv) when _Lv >= 307, _Lv =< 307 ->
		[{5,0,95610}];
get_exp(_Lv) when _Lv >= 308, _Lv =< 308 ->
		[{5,0,95933}];
get_exp(_Lv) when _Lv >= 309, _Lv =< 309 ->
		[{5,0,96258}];
get_exp(_Lv) when _Lv >= 310, _Lv =< 310 ->
		[{5,0,96584}];
get_exp(_Lv) when _Lv >= 311, _Lv =< 311 ->
		[{5,0,96911}];
get_exp(_Lv) when _Lv >= 312, _Lv =< 312 ->
		[{5,0,97239}];
get_exp(_Lv) when _Lv >= 313, _Lv =< 313 ->
		[{5,0,97568}];
get_exp(_Lv) when _Lv >= 314, _Lv =< 314 ->
		[{5,0,97898}];
get_exp(_Lv) when _Lv >= 315, _Lv =< 315 ->
		[{5,0,98230}];
get_exp(_Lv) when _Lv >= 316, _Lv =< 316 ->
		[{5,0,98562}];
get_exp(_Lv) when _Lv >= 317, _Lv =< 317 ->
		[{5,0,98896}];
get_exp(_Lv) when _Lv >= 318, _Lv =< 318 ->
		[{5,0,99230}];
get_exp(_Lv) when _Lv >= 319, _Lv =< 319 ->
		[{5,0,99566}];
get_exp(_Lv) when _Lv >= 320, _Lv =< 320 ->
		[{5,0,99903}];
get_exp(_Lv) when _Lv >= 321, _Lv =< 321 ->
		[{5,0,100241}];
get_exp(_Lv) when _Lv >= 322, _Lv =< 322 ->
		[{5,0,100581}];
get_exp(_Lv) when _Lv >= 323, _Lv =< 323 ->
		[{5,0,100921}];
get_exp(_Lv) when _Lv >= 324, _Lv =< 324 ->
		[{5,0,101263}];
get_exp(_Lv) when _Lv >= 325, _Lv =< 325 ->
		[{5,0,101605}];
get_exp(_Lv) when _Lv >= 326, _Lv =< 326 ->
		[{5,0,101949}];
get_exp(_Lv) when _Lv >= 327, _Lv =< 327 ->
		[{5,0,102294}];
get_exp(_Lv) when _Lv >= 328, _Lv =< 328 ->
		[{5,0,102640}];
get_exp(_Lv) when _Lv >= 329, _Lv =< 329 ->
		[{5,0,102988}];
get_exp(_Lv) when _Lv >= 330, _Lv =< 330 ->
		[{5,0,103336}];
get_exp(_Lv) when _Lv >= 331, _Lv =< 331 ->
		[{5,0,103686}];
get_exp(_Lv) when _Lv >= 332, _Lv =< 332 ->
		[{5,0,104037}];
get_exp(_Lv) when _Lv >= 333, _Lv =< 333 ->
		[{5,0,104389}];
get_exp(_Lv) when _Lv >= 334, _Lv =< 334 ->
		[{5,0,104743}];
get_exp(_Lv) when _Lv >= 335, _Lv =< 335 ->
		[{5,0,105097}];
get_exp(_Lv) when _Lv >= 336, _Lv =< 336 ->
		[{5,0,105453}];
get_exp(_Lv) when _Lv >= 337, _Lv =< 337 ->
		[{5,0,105810}];
get_exp(_Lv) when _Lv >= 338, _Lv =< 338 ->
		[{5,0,106168}];
get_exp(_Lv) when _Lv >= 339, _Lv =< 339 ->
		[{5,0,106527}];
get_exp(_Lv) when _Lv >= 340, _Lv =< 340 ->
		[{5,0,106888}];
get_exp(_Lv) when _Lv >= 341, _Lv =< 341 ->
		[{5,0,107249}];
get_exp(_Lv) when _Lv >= 342, _Lv =< 342 ->
		[{5,0,107612}];
get_exp(_Lv) when _Lv >= 343, _Lv =< 343 ->
		[{5,0,107977}];
get_exp(_Lv) when _Lv >= 344, _Lv =< 344 ->
		[{5,0,108342}];
get_exp(_Lv) when _Lv >= 345, _Lv =< 345 ->
		[{5,0,108709}];
get_exp(_Lv) when _Lv >= 346, _Lv =< 346 ->
		[{5,0,109077}];
get_exp(_Lv) when _Lv >= 347, _Lv =< 347 ->
		[{5,0,109446}];
get_exp(_Lv) when _Lv >= 348, _Lv =< 348 ->
		[{5,0,109816}];
get_exp(_Lv) when _Lv >= 349, _Lv =< 349 ->
		[{5,0,110188}];
get_exp(_Lv) when _Lv >= 350, _Lv =< 350 ->
		[{5,0,110561}];
get_exp(_Lv) when _Lv >= 351, _Lv =< 351 ->
		[{5,0,110935}];
get_exp(_Lv) when _Lv >= 352, _Lv =< 352 ->
		[{5,0,111311}];
get_exp(_Lv) when _Lv >= 353, _Lv =< 353 ->
		[{5,0,111687}];
get_exp(_Lv) when _Lv >= 354, _Lv =< 354 ->
		[{5,0,112065}];
get_exp(_Lv) when _Lv >= 355, _Lv =< 355 ->
		[{5,0,112445}];
get_exp(_Lv) when _Lv >= 356, _Lv =< 356 ->
		[{5,0,112825}];
get_exp(_Lv) when _Lv >= 357, _Lv =< 357 ->
		[{5,0,113207}];
get_exp(_Lv) when _Lv >= 358, _Lv =< 358 ->
		[{5,0,113590}];
get_exp(_Lv) when _Lv >= 359, _Lv =< 359 ->
		[{5,0,113975}];
get_exp(_Lv) when _Lv >= 360, _Lv =< 360 ->
		[{5,0,114361}];
get_exp(_Lv) when _Lv >= 361, _Lv =< 361 ->
		[{5,0,114748}];
get_exp(_Lv) when _Lv >= 362, _Lv =< 362 ->
		[{5,0,115136}];
get_exp(_Lv) when _Lv >= 363, _Lv =< 363 ->
		[{5,0,115526}];
get_exp(_Lv) when _Lv >= 364, _Lv =< 364 ->
		[{5,0,115917}];
get_exp(_Lv) when _Lv >= 365, _Lv =< 365 ->
		[{5,0,116309}];
get_exp(_Lv) when _Lv >= 366, _Lv =< 366 ->
		[{5,0,116703}];
get_exp(_Lv) when _Lv >= 367, _Lv =< 367 ->
		[{5,0,117098}];
get_exp(_Lv) when _Lv >= 368, _Lv =< 368 ->
		[{5,0,117494}];
get_exp(_Lv) when _Lv >= 369, _Lv =< 369 ->
		[{5,0,117892}];
get_exp(_Lv) when _Lv >= 370, _Lv =< 370 ->
		[{5,0,118291}];
get_exp(_Lv) when _Lv >= 371, _Lv =< 371 ->
		[{5,0,118691}];
get_exp(_Lv) when _Lv >= 372, _Lv =< 372 ->
		[{5,0,119093}];
get_exp(_Lv) when _Lv >= 373, _Lv =< 373 ->
		[{5,0,119496}];
get_exp(_Lv) when _Lv >= 374, _Lv =< 374 ->
		[{5,0,119900}];
get_exp(_Lv) when _Lv >= 375, _Lv =< 375 ->
		[{5,0,120306}];
get_exp(_Lv) when _Lv >= 376, _Lv =< 376 ->
		[{5,0,120713}];
get_exp(_Lv) when _Lv >= 377, _Lv =< 377 ->
		[{5,0,121122}];
get_exp(_Lv) when _Lv >= 378, _Lv =< 378 ->
		[{5,0,121532}];
get_exp(_Lv) when _Lv >= 379, _Lv =< 379 ->
		[{5,0,121943}];
get_exp(_Lv) when _Lv >= 380, _Lv =< 380 ->
		[{5,0,122356}];
get_exp(_Lv) when _Lv >= 381, _Lv =< 381 ->
		[{5,0,122770}];
get_exp(_Lv) when _Lv >= 382, _Lv =< 382 ->
		[{5,0,123186}];
get_exp(_Lv) when _Lv >= 383, _Lv =< 383 ->
		[{5,0,123602}];
get_exp(_Lv) when _Lv >= 384, _Lv =< 384 ->
		[{5,0,124021}];
get_exp(_Lv) when _Lv >= 385, _Lv =< 385 ->
		[{5,0,124441}];
get_exp(_Lv) when _Lv >= 386, _Lv =< 386 ->
		[{5,0,124862}];
get_exp(_Lv) when _Lv >= 387, _Lv =< 387 ->
		[{5,0,125284}];
get_exp(_Lv) when _Lv >= 388, _Lv =< 388 ->
		[{5,0,125708}];
get_exp(_Lv) when _Lv >= 389, _Lv =< 389 ->
		[{5,0,126134}];
get_exp(_Lv) when _Lv >= 390, _Lv =< 390 ->
		[{5,0,126561}];
get_exp(_Lv) when _Lv >= 391, _Lv =< 391 ->
		[{5,0,126989}];
get_exp(_Lv) when _Lv >= 392, _Lv =< 392 ->
		[{5,0,127419}];
get_exp(_Lv) when _Lv >= 393, _Lv =< 393 ->
		[{5,0,127850}];
get_exp(_Lv) when _Lv >= 394, _Lv =< 394 ->
		[{5,0,128283}];
get_exp(_Lv) when _Lv >= 395, _Lv =< 395 ->
		[{5,0,128717}];
get_exp(_Lv) when _Lv >= 396, _Lv =< 396 ->
		[{5,0,129153}];
get_exp(_Lv) when _Lv >= 397, _Lv =< 397 ->
		[{5,0,129590}];
get_exp(_Lv) when _Lv >= 398, _Lv =< 398 ->
		[{5,0,130028}];
get_exp(_Lv) when _Lv >= 399, _Lv =< 399 ->
		[{5,0,130469}];
get_exp(_Lv) when _Lv >= 400, _Lv =< 400 ->
		[{5,0,130910}];
get_exp(_Lv) when _Lv >= 401, _Lv =< 401 ->
		[{5,0,131353}];
get_exp(_Lv) when _Lv >= 402, _Lv =< 402 ->
		[{5,0,131798}];
get_exp(_Lv) when _Lv >= 403, _Lv =< 403 ->
		[{5,0,132244}];
get_exp(_Lv) when _Lv >= 404, _Lv =< 404 ->
		[{5,0,132691}];
get_exp(_Lv) when _Lv >= 405, _Lv =< 405 ->
		[{5,0,133141}];
get_exp(_Lv) when _Lv >= 406, _Lv =< 406 ->
		[{5,0,133591}];
get_exp(_Lv) when _Lv >= 407, _Lv =< 407 ->
		[{5,0,134043}];
get_exp(_Lv) when _Lv >= 408, _Lv =< 408 ->
		[{5,0,134497}];
get_exp(_Lv) when _Lv >= 409, _Lv =< 409 ->
		[{5,0,134952}];
get_exp(_Lv) when _Lv >= 410, _Lv =< 410 ->
		[{5,0,135409}];
get_exp(_Lv) when _Lv >= 411, _Lv =< 411 ->
		[{5,0,135867}];
get_exp(_Lv) when _Lv >= 412, _Lv =< 412 ->
		[{5,0,136327}];
get_exp(_Lv) when _Lv >= 413, _Lv =< 413 ->
		[{5,0,136789}];
get_exp(_Lv) when _Lv >= 414, _Lv =< 414 ->
		[{5,0,137252}];
get_exp(_Lv) when _Lv >= 415, _Lv =< 415 ->
		[{5,0,137716}];
get_exp(_Lv) when _Lv >= 416, _Lv =< 416 ->
		[{5,0,138182}];
get_exp(_Lv) when _Lv >= 417, _Lv =< 417 ->
		[{5,0,138650}];
get_exp(_Lv) when _Lv >= 418, _Lv =< 418 ->
		[{5,0,139119}];
get_exp(_Lv) when _Lv >= 419, _Lv =< 419 ->
		[{5,0,139590}];
get_exp(_Lv) when _Lv >= 420, _Lv =< 420 ->
		[{5,0,140063}];
get_exp(_Lv) when _Lv >= 421, _Lv =< 421 ->
		[{5,0,140537}];
get_exp(_Lv) when _Lv >= 422, _Lv =< 422 ->
		[{5,0,141012}];
get_exp(_Lv) when _Lv >= 423, _Lv =< 423 ->
		[{5,0,141489}];
get_exp(_Lv) when _Lv >= 424, _Lv =< 424 ->
		[{5,0,141968}];
get_exp(_Lv) when _Lv >= 425, _Lv =< 425 ->
		[{5,0,142449}];
get_exp(_Lv) when _Lv >= 426, _Lv =< 426 ->
		[{5,0,142931}];
get_exp(_Lv) when _Lv >= 427, _Lv =< 427 ->
		[{5,0,143415}];
get_exp(_Lv) when _Lv >= 428, _Lv =< 428 ->
		[{5,0,143900}];
get_exp(_Lv) when _Lv >= 429, _Lv =< 429 ->
		[{5,0,144387}];
get_exp(_Lv) when _Lv >= 430, _Lv =< 430 ->
		[{5,0,144876}];
get_exp(_Lv) when _Lv >= 431, _Lv =< 431 ->
		[{5,0,145366}];
get_exp(_Lv) when _Lv >= 432, _Lv =< 432 ->
		[{5,0,145858}];
get_exp(_Lv) when _Lv >= 433, _Lv =< 433 ->
		[{5,0,146352}];
get_exp(_Lv) when _Lv >= 434, _Lv =< 434 ->
		[{5,0,146847}];
get_exp(_Lv) when _Lv >= 435, _Lv =< 435 ->
		[{5,0,147344}];
get_exp(_Lv) when _Lv >= 436, _Lv =< 436 ->
		[{5,0,147843}];
get_exp(_Lv) when _Lv >= 437, _Lv =< 437 ->
		[{5,0,148343}];
get_exp(_Lv) when _Lv >= 438, _Lv =< 438 ->
		[{5,0,148845}];
get_exp(_Lv) when _Lv >= 439, _Lv =< 439 ->
		[{5,0,149349}];
get_exp(_Lv) when _Lv >= 440, _Lv =< 440 ->
		[{5,0,149855}];
get_exp(_Lv) when _Lv >= 441, _Lv =< 441 ->
		[{5,0,150362}];
get_exp(_Lv) when _Lv >= 442, _Lv =< 442 ->
		[{5,0,150871}];
get_exp(_Lv) when _Lv >= 443, _Lv =< 443 ->
		[{5,0,151381}];
get_exp(_Lv) when _Lv >= 444, _Lv =< 444 ->
		[{5,0,151894}];
get_exp(_Lv) when _Lv >= 445, _Lv =< 445 ->
		[{5,0,152408}];
get_exp(_Lv) when _Lv >= 446, _Lv =< 446 ->
		[{5,0,152924}];
get_exp(_Lv) when _Lv >= 447, _Lv =< 447 ->
		[{5,0,153441}];
get_exp(_Lv) when _Lv >= 448, _Lv =< 448 ->
		[{5,0,153961}];
get_exp(_Lv) when _Lv >= 449, _Lv =< 449 ->
		[{5,0,154482}];
get_exp(_Lv) when _Lv >= 450, _Lv =< 450 ->
		[{5,0,155005}];
get_exp(_Lv) when _Lv >= 451, _Lv =< 451 ->
		[{5,0,155529}];
get_exp(_Lv) when _Lv >= 452, _Lv =< 452 ->
		[{5,0,156056}];
get_exp(_Lv) when _Lv >= 453, _Lv =< 453 ->
		[{5,0,156584}];
get_exp(_Lv) when _Lv >= 454, _Lv =< 454 ->
		[{5,0,157114}];
get_exp(_Lv) when _Lv >= 455, _Lv =< 455 ->
		[{5,0,157646}];
get_exp(_Lv) when _Lv >= 456, _Lv =< 456 ->
		[{5,0,158179}];
get_exp(_Lv) when _Lv >= 457, _Lv =< 457 ->
		[{5,0,158715}];
get_exp(_Lv) when _Lv >= 458, _Lv =< 458 ->
		[{5,0,159252}];
get_exp(_Lv) when _Lv >= 459, _Lv =< 459 ->
		[{5,0,159791}];
get_exp(_Lv) when _Lv >= 460, _Lv =< 460 ->
		[{5,0,160332}];
get_exp(_Lv) when _Lv >= 461, _Lv =< 461 ->
		[{5,0,160874}];
get_exp(_Lv) when _Lv >= 462, _Lv =< 462 ->
		[{5,0,161419}];
get_exp(_Lv) when _Lv >= 463, _Lv =< 463 ->
		[{5,0,161965}];
get_exp(_Lv) when _Lv >= 464, _Lv =< 464 ->
		[{5,0,162513}];
get_exp(_Lv) when _Lv >= 465, _Lv =< 465 ->
		[{5,0,163063}];
get_exp(_Lv) when _Lv >= 466, _Lv =< 466 ->
		[{5,0,163615}];
get_exp(_Lv) when _Lv >= 467, _Lv =< 467 ->
		[{5,0,164169}];
get_exp(_Lv) when _Lv >= 468, _Lv =< 468 ->
		[{5,0,164725}];
get_exp(_Lv) when _Lv >= 469, _Lv =< 469 ->
		[{5,0,165282}];
get_exp(_Lv) when _Lv >= 470, _Lv =< 470 ->
		[{5,0,165842}];
get_exp(_Lv) when _Lv >= 471, _Lv =< 471 ->
		[{5,0,166403}];
get_exp(_Lv) when _Lv >= 472, _Lv =< 472 ->
		[{5,0,166966}];
get_exp(_Lv) when _Lv >= 473, _Lv =< 473 ->
		[{5,0,167531}];
get_exp(_Lv) when _Lv >= 474, _Lv =< 474 ->
		[{5,0,168098}];
get_exp(_Lv) when _Lv >= 475, _Lv =< 475 ->
		[{5,0,168667}];
get_exp(_Lv) when _Lv >= 476, _Lv =< 476 ->
		[{5,0,169238}];
get_exp(_Lv) when _Lv >= 477, _Lv =< 477 ->
		[{5,0,169811}];
get_exp(_Lv) when _Lv >= 478, _Lv =< 478 ->
		[{5,0,170386}];
get_exp(_Lv) when _Lv >= 479, _Lv =< 479 ->
		[{5,0,170962}];
get_exp(_Lv) when _Lv >= 480, _Lv =< 480 ->
		[{5,0,171541}];
get_exp(_Lv) when _Lv >= 481, _Lv =< 481 ->
		[{5,0,172121}];
get_exp(_Lv) when _Lv >= 482, _Lv =< 482 ->
		[{5,0,172704}];
get_exp(_Lv) when _Lv >= 483, _Lv =< 483 ->
		[{5,0,173289}];
get_exp(_Lv) when _Lv >= 484, _Lv =< 484 ->
		[{5,0,173875}];
get_exp(_Lv) when _Lv >= 485, _Lv =< 485 ->
		[{5,0,174464}];
get_exp(_Lv) when _Lv >= 486, _Lv =< 486 ->
		[{5,0,175054}];
get_exp(_Lv) when _Lv >= 487, _Lv =< 487 ->
		[{5,0,175646}];
get_exp(_Lv) when _Lv >= 488, _Lv =< 488 ->
		[{5,0,176241}];
get_exp(_Lv) when _Lv >= 489, _Lv =< 489 ->
		[{5,0,176837}];
get_exp(_Lv) when _Lv >= 490, _Lv =< 490 ->
		[{5,0,177436}];
get_exp(_Lv) when _Lv >= 491, _Lv =< 491 ->
		[{5,0,178037}];
get_exp(_Lv) when _Lv >= 492, _Lv =< 492 ->
		[{5,0,178639}];
get_exp(_Lv) when _Lv >= 493, _Lv =< 493 ->
		[{5,0,179244}];
get_exp(_Lv) when _Lv >= 494, _Lv =< 494 ->
		[{5,0,179850}];
get_exp(_Lv) when _Lv >= 495, _Lv =< 495 ->
		[{5,0,180459}];
get_exp(_Lv) when _Lv >= 496, _Lv =< 496 ->
		[{5,0,181070}];
get_exp(_Lv) when _Lv >= 497, _Lv =< 497 ->
		[{5,0,181683}];
get_exp(_Lv) when _Lv >= 498, _Lv =< 498 ->
		[{5,0,182298}];
get_exp(_Lv) when _Lv >= 499, _Lv =< 499 ->
		[{5,0,182915}];
get_exp(_Lv) when _Lv >= 500, _Lv =< 500 ->
		[{5,0,183534}];
get_exp(_Lv) when _Lv >= 501, _Lv =< 501 ->
		[{5,0,184155}];
get_exp(_Lv) when _Lv >= 502, _Lv =< 502 ->
		[{5,0,184778}];
get_exp(_Lv) when _Lv >= 503, _Lv =< 503 ->
		[{5,0,185404}];
get_exp(_Lv) when _Lv >= 504, _Lv =< 504 ->
		[{5,0,186031}];
get_exp(_Lv) when _Lv >= 505, _Lv =< 505 ->
		[{5,0,186661}];
get_exp(_Lv) when _Lv >= 506, _Lv =< 506 ->
		[{5,0,187293}];
get_exp(_Lv) when _Lv >= 507, _Lv =< 507 ->
		[{5,0,187927}];
get_exp(_Lv) when _Lv >= 508, _Lv =< 508 ->
		[{5,0,188563}];
get_exp(_Lv) when _Lv >= 509, _Lv =< 509 ->
		[{5,0,189201}];
get_exp(_Lv) when _Lv >= 510, _Lv =< 510 ->
		[{5,0,189841}];
get_exp(_Lv) when _Lv >= 511, _Lv =< 511 ->
		[{5,0,190484}];
get_exp(_Lv) when _Lv >= 512, _Lv =< 512 ->
		[{5,0,191128}];
get_exp(_Lv) when _Lv >= 513, _Lv =< 513 ->
		[{5,0,191775}];
get_exp(_Lv) when _Lv >= 514, _Lv =< 514 ->
		[{5,0,192424}];
get_exp(_Lv) when _Lv >= 515, _Lv =< 515 ->
		[{5,0,193076}];
get_exp(_Lv) when _Lv >= 516, _Lv =< 516 ->
		[{5,0,193729}];
get_exp(_Lv) when _Lv >= 517, _Lv =< 517 ->
		[{5,0,194385}];
get_exp(_Lv) when _Lv >= 518, _Lv =< 518 ->
		[{5,0,195043}];
get_exp(_Lv) when _Lv >= 519, _Lv =< 519 ->
		[{5,0,195703}];
get_exp(_Lv) when _Lv >= 520, _Lv =< 520 ->
		[{5,0,196365}];
get_exp(_Lv) when _Lv >= 521, _Lv =< 521 ->
		[{5,0,197030}];
get_exp(_Lv) when _Lv >= 522, _Lv =< 522 ->
		[{5,0,197697}];
get_exp(_Lv) when _Lv >= 523, _Lv =< 523 ->
		[{5,0,198366}];
get_exp(_Lv) when _Lv >= 524, _Lv =< 524 ->
		[{5,0,199037}];
get_exp(_Lv) when _Lv >= 525, _Lv =< 525 ->
		[{5,0,199711}];
get_exp(_Lv) when _Lv >= 526, _Lv =< 526 ->
		[{5,0,200387}];
get_exp(_Lv) when _Lv >= 527, _Lv =< 527 ->
		[{5,0,201065}];
get_exp(_Lv) when _Lv >= 528, _Lv =< 528 ->
		[{5,0,201746}];
get_exp(_Lv) when _Lv >= 529, _Lv =< 529 ->
		[{5,0,202428}];
get_exp(_Lv) when _Lv >= 530, _Lv =< 530 ->
		[{5,0,203114}];
get_exp(_Lv) when _Lv >= 531, _Lv =< 531 ->
		[{5,0,203801}];
get_exp(_Lv) when _Lv >= 532, _Lv =< 532 ->
		[{5,0,204491}];
get_exp(_Lv) when _Lv >= 533, _Lv =< 533 ->
		[{5,0,205183}];
get_exp(_Lv) when _Lv >= 534, _Lv =< 534 ->
		[{5,0,205877}];
get_exp(_Lv) when _Lv >= 535, _Lv =< 535 ->
		[{5,0,206574}];
get_exp(_Lv) when _Lv >= 536, _Lv =< 536 ->
		[{5,0,207273}];
get_exp(_Lv) when _Lv >= 537, _Lv =< 537 ->
		[{5,0,207975}];
get_exp(_Lv) when _Lv >= 538, _Lv =< 538 ->
		[{5,0,208679}];
get_exp(_Lv) when _Lv >= 539, _Lv =< 539 ->
		[{5,0,209385}];
get_exp(_Lv) when _Lv >= 540, _Lv =< 540 ->
		[{5,0,210094}];
get_exp(_Lv) when _Lv >= 541, _Lv =< 541 ->
		[{5,0,210805}];
get_exp(_Lv) when _Lv >= 542, _Lv =< 542 ->
		[{5,0,211518}];
get_exp(_Lv) when _Lv >= 543, _Lv =< 543 ->
		[{5,0,212234}];
get_exp(_Lv) when _Lv >= 544, _Lv =< 544 ->
		[{5,0,212953}];
get_exp(_Lv) when _Lv >= 545, _Lv =< 545 ->
		[{5,0,213673}];
get_exp(_Lv) when _Lv >= 546, _Lv =< 546 ->
		[{5,0,214397}];
get_exp(_Lv) when _Lv >= 547, _Lv =< 547 ->
		[{5,0,215122}];
get_exp(_Lv) when _Lv >= 548, _Lv =< 548 ->
		[{5,0,215850}];
get_exp(_Lv) when _Lv >= 549, _Lv =< 549 ->
		[{5,0,216581}];
get_exp(_Lv) when _Lv >= 550, _Lv =< 550 ->
		[{5,0,217314}];
get_exp(_Lv) when _Lv >= 551, _Lv =< 551 ->
		[{5,0,218049}];
get_exp(_Lv) when _Lv >= 552, _Lv =< 552 ->
		[{5,0,218787}];
get_exp(_Lv) when _Lv >= 553, _Lv =< 553 ->
		[{5,0,219528}];
get_exp(_Lv) when _Lv >= 554, _Lv =< 554 ->
		[{5,0,220271}];
get_exp(_Lv) when _Lv >= 555, _Lv =< 555 ->
		[{5,0,221016}];
get_exp(_Lv) when _Lv >= 556, _Lv =< 556 ->
		[{5,0,221764}];
get_exp(_Lv) when _Lv >= 557, _Lv =< 557 ->
		[{5,0,222515}];
get_exp(_Lv) when _Lv >= 558, _Lv =< 558 ->
		[{5,0,223268}];
get_exp(_Lv) when _Lv >= 559, _Lv =< 559 ->
		[{5,0,224024}];
get_exp(_Lv) when _Lv >= 560, _Lv =< 560 ->
		[{5,0,224782}];
get_exp(_Lv) when _Lv >= 561, _Lv =< 561 ->
		[{5,0,225543}];
get_exp(_Lv) when _Lv >= 562, _Lv =< 562 ->
		[{5,0,226306}];
get_exp(_Lv) when _Lv >= 563, _Lv =< 563 ->
		[{5,0,227072}];
get_exp(_Lv) when _Lv >= 564, _Lv =< 564 ->
		[{5,0,227841}];
get_exp(_Lv) when _Lv >= 565, _Lv =< 565 ->
		[{5,0,228612}];
get_exp(_Lv) when _Lv >= 566, _Lv =< 566 ->
		[{5,0,229386}];
get_exp(_Lv) when _Lv >= 567, _Lv =< 567 ->
		[{5,0,230162}];
get_exp(_Lv) when _Lv >= 568, _Lv =< 568 ->
		[{5,0,230941}];
get_exp(_Lv) when _Lv >= 569, _Lv =< 569 ->
		[{5,0,231723}];
get_exp(_Lv) when _Lv >= 570, _Lv =< 570 ->
		[{5,0,232507}];
get_exp(_Lv) when _Lv >= 571, _Lv =< 571 ->
		[{5,0,233294}];
get_exp(_Lv) when _Lv >= 572, _Lv =< 572 ->
		[{5,0,234083}];
get_exp(_Lv) when _Lv >= 573, _Lv =< 573 ->
		[{5,0,234876}];
get_exp(_Lv) when _Lv >= 574, _Lv =< 574 ->
		[{5,0,235671}];
get_exp(_Lv) when _Lv >= 575, _Lv =< 575 ->
		[{5,0,236468}];
get_exp(_Lv) when _Lv >= 576, _Lv =< 576 ->
		[{5,0,237269}];
get_exp(_Lv) when _Lv >= 577, _Lv =< 577 ->
		[{5,0,238072}];
get_exp(_Lv) when _Lv >= 578, _Lv =< 578 ->
		[{5,0,238878}];
get_exp(_Lv) when _Lv >= 579, _Lv =< 579 ->
		[{5,0,239686}];
get_exp(_Lv) when _Lv >= 580, _Lv =< 580 ->
		[{5,0,240497}];
get_exp(_Lv) when _Lv >= 581, _Lv =< 581 ->
		[{5,0,241311}];
get_exp(_Lv) when _Lv >= 582, _Lv =< 582 ->
		[{5,0,242128}];
get_exp(_Lv) when _Lv >= 583, _Lv =< 583 ->
		[{5,0,242948}];
get_exp(_Lv) when _Lv >= 584, _Lv =< 584 ->
		[{5,0,243770}];
get_exp(_Lv) when _Lv >= 585, _Lv =< 585 ->
		[{5,0,244595}];
get_exp(_Lv) when _Lv >= 586, _Lv =< 586 ->
		[{5,0,245423}];
get_exp(_Lv) when _Lv >= 587, _Lv =< 587 ->
		[{5,0,246253}];
get_exp(_Lv) when _Lv >= 588, _Lv =< 588 ->
		[{5,0,247087}];
get_exp(_Lv) when _Lv >= 589, _Lv =< 589 ->
		[{5,0,247923}];
get_exp(_Lv) when _Lv >= 590, _Lv =< 590 ->
		[{5,0,248762}];
get_exp(_Lv) when _Lv >= 591, _Lv =< 591 ->
		[{5,0,249604}];
get_exp(_Lv) when _Lv >= 592, _Lv =< 592 ->
		[{5,0,250449}];
get_exp(_Lv) when _Lv >= 593, _Lv =< 593 ->
		[{5,0,251297}];
get_exp(_Lv) when _Lv >= 594, _Lv =< 594 ->
		[{5,0,252147}];
get_exp(_Lv) when _Lv >= 595, _Lv =< 595 ->
		[{5,0,253001}];
get_exp(_Lv) when _Lv >= 596, _Lv =< 596 ->
		[{5,0,253857}];
get_exp(_Lv) when _Lv >= 597, _Lv =< 597 ->
		[{5,0,254716}];
get_exp(_Lv) when _Lv >= 598, _Lv =< 598 ->
		[{5,0,255578}];
get_exp(_Lv) when _Lv >= 599, _Lv =< 599 ->
		[{5,0,256443}];
get_exp(_Lv) when _Lv >= 600, _Lv =< 600 ->
		[{5,0,257311}];
get_exp(_Lv) when _Lv >= 601, _Lv =< 601 ->
		[{5,0,258182}];
get_exp(_Lv) when _Lv >= 602, _Lv =< 602 ->
		[{5,0,259056}];
get_exp(_Lv) when _Lv >= 603, _Lv =< 603 ->
		[{5,0,259933}];
get_exp(_Lv) when _Lv >= 604, _Lv =< 604 ->
		[{5,0,260813}];
get_exp(_Lv) when _Lv >= 605, _Lv =< 605 ->
		[{5,0,261695}];
get_exp(_Lv) when _Lv >= 606, _Lv =< 606 ->
		[{5,0,262581}];
get_exp(_Lv) when _Lv >= 607, _Lv =< 607 ->
		[{5,0,263470}];
get_exp(_Lv) when _Lv >= 608, _Lv =< 608 ->
		[{5,0,264361}];
get_exp(_Lv) when _Lv >= 609, _Lv =< 609 ->
		[{5,0,265256}];
get_exp(_Lv) when _Lv >= 610, _Lv =< 610 ->
		[{5,0,266154}];
get_exp(_Lv) when _Lv >= 611, _Lv =< 611 ->
		[{5,0,267055}];
get_exp(_Lv) when _Lv >= 612, _Lv =< 612 ->
		[{5,0,267959}];
get_exp(_Lv) when _Lv >= 613, _Lv =< 613 ->
		[{5,0,268866}];
get_exp(_Lv) when _Lv >= 614, _Lv =< 614 ->
		[{5,0,269776}];
get_exp(_Lv) when _Lv >= 615, _Lv =< 615 ->
		[{5,0,270689}];
get_exp(_Lv) when _Lv >= 616, _Lv =< 616 ->
		[{5,0,271605}];
get_exp(_Lv) when _Lv >= 617, _Lv =< 617 ->
		[{5,0,272524}];
get_exp(_Lv) when _Lv >= 618, _Lv =< 618 ->
		[{5,0,273447}];
get_exp(_Lv) when _Lv >= 619, _Lv =< 619 ->
		[{5,0,274372}];
get_exp(_Lv) when _Lv >= 620, _Lv =< 620 ->
		[{5,0,275301}];
get_exp(_Lv) when _Lv >= 621, _Lv =< 621 ->
		[{5,0,276232}];
get_exp(_Lv) when _Lv >= 622, _Lv =< 622 ->
		[{5,0,277167}];
get_exp(_Lv) when _Lv >= 623, _Lv =< 623 ->
		[{5,0,278106}];
get_exp(_Lv) when _Lv >= 624, _Lv =< 624 ->
		[{5,0,279047}];
get_exp(_Lv) when _Lv >= 625, _Lv =< 625 ->
		[{5,0,279991}];
get_exp(_Lv) when _Lv >= 626, _Lv =< 626 ->
		[{5,0,280939}];
get_exp(_Lv) when _Lv >= 627, _Lv =< 627 ->
		[{5,0,281890}];
get_exp(_Lv) when _Lv >= 628, _Lv =< 628 ->
		[{5,0,282844}];
get_exp(_Lv) when _Lv >= 629, _Lv =< 629 ->
		[{5,0,283801}];
get_exp(_Lv) when _Lv >= 630, _Lv =< 630 ->
		[{5,0,284762}];
get_exp(_Lv) when _Lv >= 631, _Lv =< 631 ->
		[{5,0,285726}];
get_exp(_Lv) when _Lv >= 632, _Lv =< 632 ->
		[{5,0,286693}];
get_exp(_Lv) when _Lv >= 633, _Lv =< 633 ->
		[{5,0,287663}];
get_exp(_Lv) when _Lv >= 634, _Lv =< 634 ->
		[{5,0,288637}];
get_exp(_Lv) when _Lv >= 635, _Lv =< 635 ->
		[{5,0,289613}];
get_exp(_Lv) when _Lv >= 636, _Lv =< 636 ->
		[{5,0,290594}];
get_exp(_Lv) when _Lv >= 637, _Lv =< 637 ->
		[{5,0,291577}];
get_exp(_Lv) when _Lv >= 638, _Lv =< 638 ->
		[{5,0,292564}];
get_exp(_Lv) when _Lv >= 639, _Lv =< 639 ->
		[{5,0,293554}];
get_exp(_Lv) when _Lv >= 640, _Lv =< 640 ->
		[{5,0,294548}];
get_exp(_Lv) when _Lv >= 641, _Lv =< 641 ->
		[{5,0,295545}];
get_exp(_Lv) when _Lv >= 642, _Lv =< 642 ->
		[{5,0,296545}];
get_exp(_Lv) when _Lv >= 643, _Lv =< 643 ->
		[{5,0,297549}];
get_exp(_Lv) when _Lv >= 644, _Lv =< 644 ->
		[{5,0,298556}];
get_exp(_Lv) when _Lv >= 645, _Lv =< 645 ->
		[{5,0,299566}];
get_exp(_Lv) when _Lv >= 646, _Lv =< 646 ->
		[{5,0,300580}];
get_exp(_Lv) when _Lv >= 647, _Lv =< 647 ->
		[{5,0,301598}];
get_exp(_Lv) when _Lv >= 648, _Lv =< 648 ->
		[{5,0,302618}];
get_exp(_Lv) when _Lv >= 649, _Lv =< 649 ->
		[{5,0,303643}];
get_exp(_Lv) when _Lv >= 650, _Lv =< 650 ->
		[{5,0,304670}];
get_exp(_Lv) when _Lv >= 651, _Lv =< 651 ->
		[{5,0,305701}];
get_exp(_Lv) when _Lv >= 652, _Lv =< 652 ->
		[{5,0,306736}];
get_exp(_Lv) when _Lv >= 653, _Lv =< 653 ->
		[{5,0,307774}];
get_exp(_Lv) when _Lv >= 654, _Lv =< 654 ->
		[{5,0,308816}];
get_exp(_Lv) when _Lv >= 655, _Lv =< 655 ->
		[{5,0,309861}];
get_exp(_Lv) when _Lv >= 656, _Lv =< 656 ->
		[{5,0,310910}];
get_exp(_Lv) when _Lv >= 657, _Lv =< 657 ->
		[{5,0,311962}];
get_exp(_Lv) when _Lv >= 658, _Lv =< 658 ->
		[{5,0,313018}];
get_exp(_Lv) when _Lv >= 659, _Lv =< 659 ->
		[{5,0,314078}];
get_exp(_Lv) when _Lv >= 660, _Lv =< 660 ->
		[{5,0,315141}];
get_exp(_Lv) when _Lv >= 661, _Lv =< 661 ->
		[{5,0,316207}];
get_exp(_Lv) when _Lv >= 662, _Lv =< 662 ->
		[{5,0,317277}];
get_exp(_Lv) when _Lv >= 663, _Lv =< 663 ->
		[{5,0,318351}];
get_exp(_Lv) when _Lv >= 664, _Lv =< 664 ->
		[{5,0,319429}];
get_exp(_Lv) when _Lv >= 665, _Lv =< 665 ->
		[{5,0,320510}];
get_exp(_Lv) when _Lv >= 666, _Lv =< 666 ->
		[{5,0,321595}];
get_exp(_Lv) when _Lv >= 667, _Lv =< 667 ->
		[{5,0,322683}];
get_exp(_Lv) when _Lv >= 668, _Lv =< 668 ->
		[{5,0,323775}];
get_exp(_Lv) when _Lv >= 669, _Lv =< 669 ->
		[{5,0,324871}];
get_exp(_Lv) when _Lv >= 670, _Lv =< 670 ->
		[{5,0,325971}];
get_exp(_Lv) when _Lv >= 671, _Lv =< 671 ->
		[{5,0,327074}];
get_exp(_Lv) when _Lv >= 672, _Lv =< 672 ->
		[{5,0,328181}];
get_exp(_Lv) when _Lv >= 673, _Lv =< 673 ->
		[{5,0,329292}];
get_exp(_Lv) when _Lv >= 674, _Lv =< 674 ->
		[{5,0,330406}];
get_exp(_Lv) when _Lv >= 675, _Lv =< 675 ->
		[{5,0,331525}];
get_exp(_Lv) when _Lv >= 676, _Lv =< 676 ->
		[{5,0,332647}];
get_exp(_Lv) when _Lv >= 677, _Lv =< 677 ->
		[{5,0,333773}];
get_exp(_Lv) when _Lv >= 678, _Lv =< 678 ->
		[{5,0,334902}];
get_exp(_Lv) when _Lv >= 679, _Lv =< 679 ->
		[{5,0,336036}];
get_exp(_Lv) when _Lv >= 680, _Lv =< 680 ->
		[{5,0,337173}];
get_exp(_Lv) when _Lv >= 681, _Lv =< 681 ->
		[{5,0,338314}];
get_exp(_Lv) when _Lv >= 682, _Lv =< 682 ->
		[{5,0,339459}];
get_exp(_Lv) when _Lv >= 683, _Lv =< 683 ->
		[{5,0,340608}];
get_exp(_Lv) when _Lv >= 684, _Lv =< 684 ->
		[{5,0,341761}];
get_exp(_Lv) when _Lv >= 685, _Lv =< 685 ->
		[{5,0,342918}];
get_exp(_Lv) when _Lv >= 686, _Lv =< 686 ->
		[{5,0,344078}];
get_exp(_Lv) when _Lv >= 687, _Lv =< 687 ->
		[{5,0,345243}];
get_exp(_Lv) when _Lv >= 688, _Lv =< 688 ->
		[{5,0,346412}];
get_exp(_Lv) when _Lv >= 689, _Lv =< 689 ->
		[{5,0,347584}];
get_exp(_Lv) when _Lv >= 690, _Lv =< 690 ->
		[{5,0,348760}];
get_exp(_Lv) when _Lv >= 691, _Lv =< 691 ->
		[{5,0,349941}];
get_exp(_Lv) when _Lv >= 692, _Lv =< 692 ->
		[{5,0,351125}];
get_exp(_Lv) when _Lv >= 693, _Lv =< 693 ->
		[{5,0,352314}];
get_exp(_Lv) when _Lv >= 694, _Lv =< 694 ->
		[{5,0,353506}];
get_exp(_Lv) when _Lv >= 695, _Lv =< 695 ->
		[{5,0,354703}];
get_exp(_Lv) when _Lv >= 696, _Lv =< 696 ->
		[{5,0,355903}];
get_exp(_Lv) when _Lv >= 697, _Lv =< 697 ->
		[{5,0,357108}];
get_exp(_Lv) when _Lv >= 698, _Lv =< 698 ->
		[{5,0,358316}];
get_exp(_Lv) when _Lv >= 699, _Lv =< 699 ->
		[{5,0,359529}];
get_exp(_Lv) when _Lv >= 700, _Lv =< 700 ->
		[{5,0,360746}];
get_exp(_Lv) when _Lv >= 701, _Lv =< 701 ->
		[{5,0,361967}];
get_exp(_Lv) when _Lv >= 702, _Lv =< 702 ->
		[{5,0,363192}];
get_exp(_Lv) when _Lv >= 703, _Lv =< 703 ->
		[{5,0,364421}];
get_exp(_Lv) when _Lv >= 704, _Lv =< 704 ->
		[{5,0,365655}];
get_exp(_Lv) when _Lv >= 705, _Lv =< 705 ->
		[{5,0,366892}];
get_exp(_Lv) when _Lv >= 706, _Lv =< 706 ->
		[{5,0,368134}];
get_exp(_Lv) when _Lv >= 707, _Lv =< 707 ->
		[{5,0,369380}];
get_exp(_Lv) when _Lv >= 708, _Lv =< 708 ->
		[{5,0,370630}];
get_exp(_Lv) when _Lv >= 709, _Lv =< 709 ->
		[{5,0,371885}];
get_exp(_Lv) when _Lv >= 710, _Lv =< 710 ->
		[{5,0,373143}];
get_exp(_Lv) when _Lv >= 711, _Lv =< 711 ->
		[{5,0,374406}];
get_exp(_Lv) when _Lv >= 712, _Lv =< 712 ->
		[{5,0,375674}];
get_exp(_Lv) when _Lv >= 713, _Lv =< 713 ->
		[{5,0,376945}];
get_exp(_Lv) when _Lv >= 714, _Lv =< 714 ->
		[{5,0,378221}];
get_exp(_Lv) when _Lv >= 715, _Lv =< 715 ->
		[{5,0,379501}];
get_exp(_Lv) when _Lv >= 716, _Lv =< 716 ->
		[{5,0,380785}];
get_exp(_Lv) when _Lv >= 717, _Lv =< 717 ->
		[{5,0,382074}];
get_exp(_Lv) when _Lv >= 718, _Lv =< 718 ->
		[{5,0,383367}];
get_exp(_Lv) when _Lv >= 719, _Lv =< 719 ->
		[{5,0,384665}];
get_exp(_Lv) when _Lv >= 720, _Lv =< 720 ->
		[{5,0,385967}];
get_exp(_Lv) when _Lv >= 721, _Lv =< 721 ->
		[{5,0,387273}];
get_exp(_Lv) when _Lv >= 722, _Lv =< 722 ->
		[{5,0,388584}];
get_exp(_Lv) when _Lv >= 723, _Lv =< 723 ->
		[{5,0,389899}];
get_exp(_Lv) when _Lv >= 724, _Lv =< 724 ->
		[{5,0,391219}];
get_exp(_Lv) when _Lv >= 725, _Lv =< 725 ->
		[{5,0,392543}];
get_exp(_Lv) when _Lv >= 726, _Lv =< 726 ->
		[{5,0,393872}];
get_exp(_Lv) when _Lv >= 727, _Lv =< 727 ->
		[{5,0,395205}];
get_exp(_Lv) when _Lv >= 728, _Lv =< 728 ->
		[{5,0,396542}];
get_exp(_Lv) when _Lv >= 729, _Lv =< 729 ->
		[{5,0,397884}];
get_exp(_Lv) when _Lv >= 730, _Lv =< 730 ->
		[{5,0,399231}];
get_exp(_Lv) when _Lv >= 731, _Lv =< 731 ->
		[{5,0,400582}];
get_exp(_Lv) when _Lv >= 732, _Lv =< 732 ->
		[{5,0,401938}];
get_exp(_Lv) when _Lv >= 733, _Lv =< 733 ->
		[{5,0,403298}];
get_exp(_Lv) when _Lv >= 734, _Lv =< 734 ->
		[{5,0,404663}];
get_exp(_Lv) when _Lv >= 735, _Lv =< 735 ->
		[{5,0,406033}];
get_exp(_Lv) when _Lv >= 736, _Lv =< 736 ->
		[{5,0,407407}];
get_exp(_Lv) when _Lv >= 737, _Lv =< 737 ->
		[{5,0,408786}];
get_exp(_Lv) when _Lv >= 738, _Lv =< 738 ->
		[{5,0,410170}];
get_exp(_Lv) when _Lv >= 739, _Lv =< 739 ->
		[{5,0,411558}];
get_exp(_Lv) when _Lv >= 740, _Lv =< 740 ->
		[{5,0,412951}];
get_exp(_Lv) when _Lv >= 741, _Lv =< 741 ->
		[{5,0,414349}];
get_exp(_Lv) when _Lv >= 742, _Lv =< 742 ->
		[{5,0,415751}];
get_exp(_Lv) when _Lv >= 743, _Lv =< 743 ->
		[{5,0,417158}];
get_exp(_Lv) when _Lv >= 744, _Lv =< 744 ->
		[{5,0,418570}];
get_exp(_Lv) when _Lv >= 745, _Lv =< 745 ->
		[{5,0,419987}];
get_exp(_Lv) when _Lv >= 746, _Lv =< 746 ->
		[{5,0,421408}];
get_exp(_Lv) when _Lv >= 747, _Lv =< 747 ->
		[{5,0,422835}];
get_exp(_Lv) when _Lv >= 748, _Lv =< 748 ->
		[{5,0,424266}];
get_exp(_Lv) when _Lv >= 749, _Lv =< 749 ->
		[{5,0,425702}];
get_exp(_Lv) when _Lv >= 750, _Lv =< 750 ->
		[{5,0,427143}];
get_exp(_Lv) when _Lv >= 751, _Lv =< 751 ->
		[{5,0,428588}];
get_exp(_Lv) when _Lv >= 752, _Lv =< 752 ->
		[{5,0,430039}];
get_exp(_Lv) when _Lv >= 753, _Lv =< 753 ->
		[{5,0,431494}];
get_exp(_Lv) when _Lv >= 754, _Lv =< 754 ->
		[{5,0,432955}];
get_exp(_Lv) when _Lv >= 755, _Lv =< 755 ->
		[{5,0,434420}];
get_exp(_Lv) when _Lv >= 756, _Lv =< 756 ->
		[{5,0,435890}];
get_exp(_Lv) when _Lv >= 757, _Lv =< 757 ->
		[{5,0,437366}];
get_exp(_Lv) when _Lv >= 758, _Lv =< 758 ->
		[{5,0,438846}];
get_exp(_Lv) when _Lv >= 759, _Lv =< 759 ->
		[{5,0,440331}];
get_exp(_Lv) when _Lv >= 760, _Lv =< 760 ->
		[{5,0,441822}];
get_exp(_Lv) when _Lv >= 761, _Lv =< 761 ->
		[{5,0,443317}];
get_exp(_Lv) when _Lv >= 762, _Lv =< 762 ->
		[{5,0,444818}];
get_exp(_Lv) when _Lv >= 763, _Lv =< 763 ->
		[{5,0,446323}];
get_exp(_Lv) when _Lv >= 764, _Lv =< 764 ->
		[{5,0,447834}];
get_exp(_Lv) when _Lv >= 765, _Lv =< 765 ->
		[{5,0,449349}];
get_exp(_Lv) when _Lv >= 766, _Lv =< 766 ->
		[{5,0,450870}];
get_exp(_Lv) when _Lv >= 767, _Lv =< 767 ->
		[{5,0,452396}];
get_exp(_Lv) when _Lv >= 768, _Lv =< 768 ->
		[{5,0,453928}];
get_exp(_Lv) when _Lv >= 769, _Lv =< 769 ->
		[{5,0,455464}];
get_exp(_Lv) when _Lv >= 770, _Lv =< 770 ->
		[{5,0,457005}];
get_exp(_Lv) when _Lv >= 771, _Lv =< 771 ->
		[{5,0,458552}];
get_exp(_Lv) when _Lv >= 772, _Lv =< 772 ->
		[{5,0,460104}];
get_exp(_Lv) when _Lv >= 773, _Lv =< 773 ->
		[{5,0,461662}];
get_exp(_Lv) when _Lv >= 774, _Lv =< 774 ->
		[{5,0,463224}];
get_exp(_Lv) when _Lv >= 775, _Lv =< 775 ->
		[{5,0,464792}];
get_exp(_Lv) when _Lv >= 776, _Lv =< 776 ->
		[{5,0,466365}];
get_exp(_Lv) when _Lv >= 777, _Lv =< 777 ->
		[{5,0,467943}];
get_exp(_Lv) when _Lv >= 778, _Lv =< 778 ->
		[{5,0,469527}];
get_exp(_Lv) when _Lv >= 779, _Lv =< 779 ->
		[{5,0,471116}];
get_exp(_Lv) when _Lv >= 780, _Lv =< 780 ->
		[{5,0,472711}];
get_exp(_Lv) when _Lv >= 781, _Lv =< 781 ->
		[{5,0,474311}];
get_exp(_Lv) when _Lv >= 782, _Lv =< 782 ->
		[{5,0,475916}];
get_exp(_Lv) when _Lv >= 783, _Lv =< 783 ->
		[{5,0,477527}];
get_exp(_Lv) when _Lv >= 784, _Lv =< 784 ->
		[{5,0,479143}];
get_exp(_Lv) when _Lv >= 785, _Lv =< 785 ->
		[{5,0,480765}];
get_exp(_Lv) when _Lv >= 786, _Lv =< 786 ->
		[{5,0,482392}];
get_exp(_Lv) when _Lv >= 787, _Lv =< 787 ->
		[{5,0,484025}];
get_exp(_Lv) when _Lv >= 788, _Lv =< 788 ->
		[{5,0,485663}];
get_exp(_Lv) when _Lv >= 789, _Lv =< 789 ->
		[{5,0,487307}];
get_exp(_Lv) when _Lv >= 790, _Lv =< 790 ->
		[{5,0,488956}];
get_exp(_Lv) when _Lv >= 791, _Lv =< 791 ->
		[{5,0,490611}];
get_exp(_Lv) when _Lv >= 792, _Lv =< 792 ->
		[{5,0,492272}];
get_exp(_Lv) when _Lv >= 793, _Lv =< 793 ->
		[{5,0,493938}];
get_exp(_Lv) when _Lv >= 794, _Lv =< 794 ->
		[{5,0,495610}];
get_exp(_Lv) when _Lv >= 795, _Lv =< 795 ->
		[{5,0,497287}];
get_exp(_Lv) when _Lv >= 796, _Lv =< 796 ->
		[{5,0,498970}];
get_exp(_Lv) when _Lv >= 797, _Lv =< 797 ->
		[{5,0,500659}];
get_exp(_Lv) when _Lv >= 798, _Lv =< 798 ->
		[{5,0,502353}];
get_exp(_Lv) when _Lv >= 799, _Lv =< 799 ->
		[{5,0,504054}];
get_exp(_Lv) when _Lv >= 800, _Lv =< 800 ->
		[{5,0,505760}];
get_exp(_Lv) when _Lv >= 801, _Lv =< 801 ->
		[{5,0,507471}];
get_exp(_Lv) when _Lv >= 802, _Lv =< 802 ->
		[{5,0,509189}];
get_exp(_Lv) when _Lv >= 803, _Lv =< 803 ->
		[{5,0,510912}];
get_exp(_Lv) when _Lv >= 804, _Lv =< 804 ->
		[{5,0,512642}];
get_exp(_Lv) when _Lv >= 805, _Lv =< 805 ->
		[{5,0,514377}];
get_exp(_Lv) when _Lv >= 806, _Lv =< 806 ->
		[{5,0,516118}];
get_exp(_Lv) when _Lv >= 807, _Lv =< 807 ->
		[{5,0,517865}];
get_exp(_Lv) when _Lv >= 808, _Lv =< 808 ->
		[{5,0,519617}];
get_exp(_Lv) when _Lv >= 809, _Lv =< 809 ->
		[{5,0,521376}];
get_exp(_Lv) when _Lv >= 810, _Lv =< 810 ->
		[{5,0,523141}];
get_exp(_Lv) when _Lv >= 811, _Lv =< 811 ->
		[{5,0,524911}];
get_exp(_Lv) when _Lv >= 812, _Lv =< 812 ->
		[{5,0,526688}];
get_exp(_Lv) when _Lv >= 813, _Lv =< 813 ->
		[{5,0,528470}];
get_exp(_Lv) when _Lv >= 814, _Lv =< 814 ->
		[{5,0,530259}];
get_exp(_Lv) when _Lv >= 815, _Lv =< 815 ->
		[{5,0,532054}];
get_exp(_Lv) when _Lv >= 816, _Lv =< 816 ->
		[{5,0,533855}];
get_exp(_Lv) when _Lv >= 817, _Lv =< 817 ->
		[{5,0,535662}];
get_exp(_Lv) when _Lv >= 818, _Lv =< 818 ->
		[{5,0,537475}];
get_exp(_Lv) when _Lv >= 819, _Lv =< 819 ->
		[{5,0,539294}];
get_exp(_Lv) when _Lv >= 820, _Lv =< 820 ->
		[{5,0,541119}];
get_exp(_Lv) when _Lv >= 821, _Lv =< 821 ->
		[{5,0,542950}];
get_exp(_Lv) when _Lv >= 822, _Lv =< 822 ->
		[{5,0,544788}];
get_exp(_Lv) when _Lv >= 823, _Lv =< 823 ->
		[{5,0,546632}];
get_exp(_Lv) when _Lv >= 824, _Lv =< 824 ->
		[{5,0,548482}];
get_exp(_Lv) when _Lv >= 825, _Lv =< 825 ->
		[{5,0,550338}];
get_exp(_Lv) when _Lv >= 826, _Lv =< 826 ->
		[{5,0,552201}];
get_exp(_Lv) when _Lv >= 827, _Lv =< 827 ->
		[{5,0,554070}];
get_exp(_Lv) when _Lv >= 828, _Lv =< 828 ->
		[{5,0,555945}];
get_exp(_Lv) when _Lv >= 829, _Lv =< 829 ->
		[{5,0,557827}];
get_exp(_Lv) when _Lv >= 830, _Lv =< 830 ->
		[{5,0,559715}];
get_exp(_Lv) when _Lv >= 831, _Lv =< 831 ->
		[{5,0,561609}];
get_exp(_Lv) when _Lv >= 832, _Lv =< 832 ->
		[{5,0,563510}];
get_exp(_Lv) when _Lv >= 833, _Lv =< 833 ->
		[{5,0,565418}];
get_exp(_Lv) when _Lv >= 834, _Lv =< 834 ->
		[{5,0,567331}];
get_exp(_Lv) when _Lv >= 835, _Lv =< 835 ->
		[{5,0,569251}];
get_exp(_Lv) when _Lv >= 836, _Lv =< 836 ->
		[{5,0,571178}];
get_exp(_Lv) when _Lv >= 837, _Lv =< 837 ->
		[{5,0,573111}];
get_exp(_Lv) when _Lv >= 838, _Lv =< 838 ->
		[{5,0,575051}];
get_exp(_Lv) when _Lv >= 839, _Lv =< 839 ->
		[{5,0,576997}];
get_exp(_Lv) when _Lv >= 840, _Lv =< 840 ->
		[{5,0,578950}];
get_exp(_Lv) when _Lv >= 841, _Lv =< 841 ->
		[{5,0,580910}];
get_exp(_Lv) when _Lv >= 842, _Lv =< 842 ->
		[{5,0,582876}];
get_exp(_Lv) when _Lv >= 843, _Lv =< 843 ->
		[{5,0,584849}];
get_exp(_Lv) when _Lv >= 844, _Lv =< 844 ->
		[{5,0,586828}];
get_exp(_Lv) when _Lv >= 845, _Lv =< 845 ->
		[{5,0,588814}];
get_exp(_Lv) when _Lv >= 846, _Lv =< 846 ->
		[{5,0,590807}];
get_exp(_Lv) when _Lv >= 847, _Lv =< 847 ->
		[{5,0,592807}];
get_exp(_Lv) when _Lv >= 848, _Lv =< 848 ->
		[{5,0,594813}];
get_exp(_Lv) when _Lv >= 849, _Lv =< 849 ->
		[{5,0,596827}];
get_exp(_Lv) when _Lv >= 850, _Lv =< 850 ->
		[{5,0,598847}];
get_exp(_Lv) when _Lv >= 851, _Lv =< 851 ->
		[{5,0,600873}];
get_exp(_Lv) when _Lv >= 852, _Lv =< 852 ->
		[{5,0,602907}];
get_exp(_Lv) when _Lv >= 853, _Lv =< 853 ->
		[{5,0,604948}];
get_exp(_Lv) when _Lv >= 854, _Lv =< 854 ->
		[{5,0,606995}];
get_exp(_Lv) when _Lv >= 855, _Lv =< 855 ->
		[{5,0,609050}];
get_exp(_Lv) when _Lv >= 856, _Lv =< 856 ->
		[{5,0,611111}];
get_exp(_Lv) when _Lv >= 857, _Lv =< 857 ->
		[{5,0,613179}];
get_exp(_Lv) when _Lv >= 858, _Lv =< 858 ->
		[{5,0,615255}];
get_exp(_Lv) when _Lv >= 859, _Lv =< 859 ->
		[{5,0,617337}];
get_exp(_Lv) when _Lv >= 860, _Lv =< 860 ->
		[{5,0,619427}];
get_exp(_Lv) when _Lv >= 861, _Lv =< 861 ->
		[{5,0,621523}];
get_exp(_Lv) when _Lv >= 862, _Lv =< 862 ->
		[{5,0,623627}];
get_exp(_Lv) when _Lv >= 863, _Lv =< 863 ->
		[{5,0,625737}];
get_exp(_Lv) when _Lv >= 864, _Lv =< 864 ->
		[{5,0,627855}];
get_exp(_Lv) when _Lv >= 865, _Lv =< 865 ->
		[{5,0,629980}];
get_exp(_Lv) when _Lv >= 866, _Lv =< 866 ->
		[{5,0,632113}];
get_exp(_Lv) when _Lv >= 867, _Lv =< 867 ->
		[{5,0,634252}];
get_exp(_Lv) when _Lv >= 868, _Lv =< 868 ->
		[{5,0,636399}];
get_exp(_Lv) when _Lv >= 869, _Lv =< 869 ->
		[{5,0,638553}];
get_exp(_Lv) when _Lv >= 870, _Lv =< 870 ->
		[{5,0,640714}];
get_exp(_Lv) when _Lv >= 871, _Lv =< 871 ->
		[{5,0,642882}];
get_exp(_Lv) when _Lv >= 872, _Lv =< 872 ->
		[{5,0,645058}];
get_exp(_Lv) when _Lv >= 873, _Lv =< 873 ->
		[{5,0,647242}];
get_exp(_Lv) when _Lv >= 874, _Lv =< 874 ->
		[{5,0,649432}];
get_exp(_Lv) when _Lv >= 875, _Lv =< 875 ->
		[{5,0,651630}];
get_exp(_Lv) when _Lv >= 876, _Lv =< 876 ->
		[{5,0,653836}];
get_exp(_Lv) when _Lv >= 877, _Lv =< 877 ->
		[{5,0,656049}];
get_exp(_Lv) when _Lv >= 878, _Lv =< 878 ->
		[{5,0,658269}];
get_exp(_Lv) when _Lv >= 879, _Lv =< 879 ->
		[{5,0,660497}];
get_exp(_Lv) when _Lv >= 880, _Lv =< 880 ->
		[{5,0,662733}];
get_exp(_Lv) when _Lv >= 881, _Lv =< 881 ->
		[{5,0,664976}];
get_exp(_Lv) when _Lv >= 882, _Lv =< 882 ->
		[{5,0,667226}];
get_exp(_Lv) when _Lv >= 883, _Lv =< 883 ->
		[{5,0,669485}];
get_exp(_Lv) when _Lv >= 884, _Lv =< 884 ->
		[{5,0,671751}];
get_exp(_Lv) when _Lv >= 885, _Lv =< 885 ->
		[{5,0,674024}];
get_exp(_Lv) when _Lv >= 886, _Lv =< 886 ->
		[{5,0,676306}];
get_exp(_Lv) when _Lv >= 887, _Lv =< 887 ->
		[{5,0,678595}];
get_exp(_Lv) when _Lv >= 888, _Lv =< 888 ->
		[{5,0,680891}];
get_exp(_Lv) when _Lv >= 889, _Lv =< 889 ->
		[{5,0,683196}];
get_exp(_Lv) when _Lv >= 890, _Lv =< 890 ->
		[{5,0,685508}];
get_exp(_Lv) when _Lv >= 891, _Lv =< 891 ->
		[{5,0,687828}];
get_exp(_Lv) when _Lv >= 892, _Lv =< 892 ->
		[{5,0,690156}];
get_exp(_Lv) when _Lv >= 893, _Lv =< 893 ->
		[{5,0,692492}];
get_exp(_Lv) when _Lv >= 894, _Lv =< 894 ->
		[{5,0,694836}];
get_exp(_Lv) when _Lv >= 895, _Lv =< 895 ->
		[{5,0,697188}];
get_exp(_Lv) when _Lv >= 896, _Lv =< 896 ->
		[{5,0,699547}];
get_exp(_Lv) when _Lv >= 897, _Lv =< 897 ->
		[{5,0,701915}];
get_exp(_Lv) when _Lv >= 898, _Lv =< 898 ->
		[{5,0,704291}];
get_exp(_Lv) when _Lv >= 899, _Lv =< 899 ->
		[{5,0,706675}];
get_exp(_Lv) when _Lv >= 900, _Lv =< 900 ->
		[{5,0,709066}];
get_exp(_Lv) when _Lv >= 901, _Lv =< 901 ->
		[{5,0,711466}];
get_exp(_Lv) when _Lv >= 902, _Lv =< 902 ->
		[{5,0,713874}];
get_exp(_Lv) when _Lv >= 903, _Lv =< 903 ->
		[{5,0,716291}];
get_exp(_Lv) when _Lv >= 904, _Lv =< 904 ->
		[{5,0,718715}];
get_exp(_Lv) when _Lv >= 905, _Lv =< 905 ->
		[{5,0,721147}];
get_exp(_Lv) when _Lv >= 906, _Lv =< 906 ->
		[{5,0,723588}];
get_exp(_Lv) when _Lv >= 907, _Lv =< 907 ->
		[{5,0,726037}];
get_exp(_Lv) when _Lv >= 908, _Lv =< 908 ->
		[{5,0,728495}];
get_exp(_Lv) when _Lv >= 909, _Lv =< 909 ->
		[{5,0,730960}];
get_exp(_Lv) when _Lv >= 910, _Lv =< 910 ->
		[{5,0,733434}];
get_exp(_Lv) when _Lv >= 911, _Lv =< 911 ->
		[{5,0,735917}];
get_exp(_Lv) when _Lv >= 912, _Lv =< 912 ->
		[{5,0,738407}];
get_exp(_Lv) when _Lv >= 913, _Lv =< 913 ->
		[{5,0,740907}];
get_exp(_Lv) when _Lv >= 914, _Lv =< 914 ->
		[{5,0,743414}];
get_exp(_Lv) when _Lv >= 915, _Lv =< 915 ->
		[{5,0,745930}];
get_exp(_Lv) when _Lv >= 916, _Lv =< 916 ->
		[{5,0,748455}];
get_exp(_Lv) when _Lv >= 917, _Lv =< 917 ->
		[{5,0,750988}];
get_exp(_Lv) when _Lv >= 918, _Lv =< 918 ->
		[{5,0,753530}];
get_exp(_Lv) when _Lv >= 919, _Lv =< 919 ->
		[{5,0,756080}];
get_exp(_Lv) when _Lv >= 920, _Lv =< 920 ->
		[{5,0,758640}];
get_exp(_Lv) when _Lv >= 921, _Lv =< 921 ->
		[{5,0,761207}];
get_exp(_Lv) when _Lv >= 922, _Lv =< 922 ->
		[{5,0,763784}];
get_exp(_Lv) when _Lv >= 923, _Lv =< 923 ->
		[{5,0,766369}];
get_exp(_Lv) when _Lv >= 924, _Lv =< 924 ->
		[{5,0,768963}];
get_exp(_Lv) when _Lv >= 925, _Lv =< 925 ->
		[{5,0,771565}];
get_exp(_Lv) when _Lv >= 926, _Lv =< 926 ->
		[{5,0,774177}];
get_exp(_Lv) when _Lv >= 927, _Lv =< 927 ->
		[{5,0,776797}];
get_exp(_Lv) when _Lv >= 928, _Lv =< 928 ->
		[{5,0,779426}];
get_exp(_Lv) when _Lv >= 929, _Lv =< 929 ->
		[{5,0,782064}];
get_exp(_Lv) when _Lv >= 930, _Lv =< 930 ->
		[{5,0,784711}];
get_exp(_Lv) when _Lv >= 931, _Lv =< 931 ->
		[{5,0,787367}];
get_exp(_Lv) when _Lv >= 932, _Lv =< 932 ->
		[{5,0,790032}];
get_exp(_Lv) when _Lv >= 933, _Lv =< 933 ->
		[{5,0,792706}];
get_exp(_Lv) when _Lv >= 934, _Lv =< 934 ->
		[{5,0,795389}];
get_exp(_Lv) when _Lv >= 935, _Lv =< 935 ->
		[{5,0,798081}];
get_exp(_Lv) when _Lv >= 936, _Lv =< 936 ->
		[{5,0,800782}];
get_exp(_Lv) when _Lv >= 937, _Lv =< 937 ->
		[{5,0,803492}];
get_exp(_Lv) when _Lv >= 938, _Lv =< 938 ->
		[{5,0,806212}];
get_exp(_Lv) when _Lv >= 939, _Lv =< 939 ->
		[{5,0,808940}];
get_exp(_Lv) when _Lv >= 940, _Lv =< 940 ->
		[{5,0,811678}];
get_exp(_Lv) when _Lv >= 941, _Lv =< 941 ->
		[{5,0,814426}];
get_exp(_Lv) when _Lv >= 942, _Lv =< 942 ->
		[{5,0,817182}];
get_exp(_Lv) when _Lv >= 943, _Lv =< 943 ->
		[{5,0,819948}];
get_exp(_Lv) when _Lv >= 944, _Lv =< 944 ->
		[{5,0,822723}];
get_exp(_Lv) when _Lv >= 945, _Lv =< 945 ->
		[{5,0,825508}];
get_exp(_Lv) when _Lv >= 946, _Lv =< 946 ->
		[{5,0,828302}];
get_exp(_Lv) when _Lv >= 947, _Lv =< 947 ->
		[{5,0,831105}];
get_exp(_Lv) when _Lv >= 948, _Lv =< 948 ->
		[{5,0,833918}];
get_exp(_Lv) when _Lv >= 949, _Lv =< 949 ->
		[{5,0,836741}];
get_exp(_Lv) when _Lv >= 950, _Lv =< 950 ->
		[{5,0,839573}];
get_exp(_Lv) when _Lv >= 951, _Lv =< 951 ->
		[{5,0,842414}];
get_exp(_Lv) when _Lv >= 952, _Lv =< 952 ->
		[{5,0,845265}];
get_exp(_Lv) when _Lv >= 953, _Lv =< 953 ->
		[{5,0,848126}];
get_exp(_Lv) when _Lv >= 954, _Lv =< 954 ->
		[{5,0,850997}];
get_exp(_Lv) when _Lv >= 955, _Lv =< 955 ->
		[{5,0,853877}];
get_exp(_Lv) when _Lv >= 956, _Lv =< 956 ->
		[{5,0,856767}];
get_exp(_Lv) when _Lv >= 957, _Lv =< 957 ->
		[{5,0,859667}];
get_exp(_Lv) when _Lv >= 958, _Lv =< 958 ->
		[{5,0,862577}];
get_exp(_Lv) when _Lv >= 959, _Lv =< 959 ->
		[{5,0,865496}];
get_exp(_Lv) when _Lv >= 960, _Lv =< 960 ->
		[{5,0,868425}];
get_exp(_Lv) when _Lv >= 961, _Lv =< 961 ->
		[{5,0,871365}];
get_exp(_Lv) when _Lv >= 962, _Lv =< 962 ->
		[{5,0,874314}];
get_exp(_Lv) when _Lv >= 963, _Lv =< 963 ->
		[{5,0,877273}];
get_exp(_Lv) when _Lv >= 964, _Lv =< 964 ->
		[{5,0,880242}];
get_exp(_Lv) when _Lv >= 965, _Lv =< 965 ->
		[{5,0,883222}];
get_exp(_Lv) when _Lv >= 966, _Lv =< 966 ->
		[{5,0,886211}];
get_exp(_Lv) when _Lv >= 967, _Lv =< 967 ->
		[{5,0,889210}];
get_exp(_Lv) when _Lv >= 968, _Lv =< 968 ->
		[{5,0,892220}];
get_exp(_Lv) when _Lv >= 969, _Lv =< 969 ->
		[{5,0,895240}];
get_exp(_Lv) when _Lv >= 970, _Lv =< 970 ->
		[{5,0,898270}];
get_exp(_Lv) when _Lv >= 971, _Lv =< 971 ->
		[{5,0,901310}];
get_exp(_Lv) when _Lv >= 972, _Lv =< 972 ->
		[{5,0,904361}];
get_exp(_Lv) when _Lv >= 973, _Lv =< 973 ->
		[{5,0,907422}];
get_exp(_Lv) when _Lv >= 974, _Lv =< 974 ->
		[{5,0,910493}];
get_exp(_Lv) when _Lv >= 975, _Lv =< 975 ->
		[{5,0,913574}];
get_exp(_Lv) when _Lv >= 976, _Lv =< 976 ->
		[{5,0,916667}];
get_exp(_Lv) when _Lv >= 977, _Lv =< 977 ->
		[{5,0,919769}];
get_exp(_Lv) when _Lv >= 978, _Lv =< 978 ->
		[{5,0,922882}];
get_exp(_Lv) when _Lv >= 979, _Lv =< 979 ->
		[{5,0,926006}];
get_exp(_Lv) when _Lv >= 980, _Lv =< 980 ->
		[{5,0,929140}];
get_exp(_Lv) when _Lv >= 981, _Lv =< 981 ->
		[{5,0,932285}];
get_exp(_Lv) when _Lv >= 982, _Lv =< 982 ->
		[{5,0,935440}];
get_exp(_Lv) when _Lv >= 983, _Lv =< 983 ->
		[{5,0,938606}];
get_exp(_Lv) when _Lv >= 984, _Lv =< 984 ->
		[{5,0,941783}];
get_exp(_Lv) when _Lv >= 985, _Lv =< 985 ->
		[{5,0,944970}];
get_exp(_Lv) when _Lv >= 986, _Lv =< 986 ->
		[{5,0,948169}];
get_exp(_Lv) when _Lv >= 987, _Lv =< 987 ->
		[{5,0,951378}];
get_exp(_Lv) when _Lv >= 988, _Lv =< 988 ->
		[{5,0,954598}];
get_exp(_Lv) when _Lv >= 989, _Lv =< 989 ->
		[{5,0,957829}];
get_exp(_Lv) when _Lv >= 990, _Lv =< 990 ->
		[{5,0,961071}];
get_exp(_Lv) when _Lv >= 991, _Lv =< 991 ->
		[{5,0,964324}];
get_exp(_Lv) when _Lv >= 992, _Lv =< 992 ->
		[{5,0,967587}];
get_exp(_Lv) when _Lv >= 993, _Lv =< 993 ->
		[{5,0,970862}];
get_exp(_Lv) when _Lv >= 994, _Lv =< 994 ->
		[{5,0,974148}];
get_exp(_Lv) when _Lv >= 995, _Lv =< 995 ->
		[{5,0,977445}];
get_exp(_Lv) when _Lv >= 996, _Lv =< 996 ->
		[{5,0,980754}];
get_exp(_Lv) when _Lv >= 997, _Lv =< 997 ->
		[{5,0,984073}];
get_exp(_Lv) when _Lv >= 998, _Lv =< 998 ->
		[{5,0,987404}];
get_exp(_Lv) when _Lv >= 999, _Lv =< 999 ->
		[{5,0,990746}];
get_exp(_Lv) when _Lv >= 1000, _Lv =< 1000 ->
		[{5,0,994099}];
get_exp(_Lv) when _Lv >= 1001, _Lv =< 1001 ->
		[{5,0,997464}];
get_exp(_Lv) when _Lv >= 1002, _Lv =< 1002 ->
		[{5,0,1000840}];
get_exp(_Lv) when _Lv >= 1003, _Lv =< 1003 ->
		[{5,0,1004227}];
get_exp(_Lv) when _Lv >= 1004, _Lv =< 1004 ->
		[{5,0,1007626}];
get_exp(_Lv) when _Lv >= 1005, _Lv =< 1005 ->
		[{5,0,1011036}];
get_exp(_Lv) when _Lv >= 1006, _Lv =< 1006 ->
		[{5,0,1014458}];
get_exp(_Lv) when _Lv >= 1007, _Lv =< 1007 ->
		[{5,0,1017892}];
get_exp(_Lv) when _Lv >= 1008, _Lv =< 1008 ->
		[{5,0,1021337}];
get_exp(_Lv) ->
	[].


get_battle_reward(1) ->
{[{0,12010108,4},{0,19020001,2},{0,19020001,1}],[{0,12010108,2},{0,19020001,1},{0,19020001,1}]};


get_battle_reward(2) ->
{[{0,12010108,5},{0,19020001,2},{0,19020001,2}],[{0,12010108,3},{0,19020001,1},{0,19020001,1}]};


get_battle_reward(4) ->
{[{0,12010108,6},{0,19020001,3},{0,19020001,2}],[{0,12010108,4},{0,19020001,2},{0,19020001,1}]};


get_battle_reward(8) ->
{[{0,12010108,7},{0,19020001,3},{0,19020001,3}],[{0,12010108,5},{0,19020001,2},{0,19020001,2}]};

get_battle_reward(_Mod) ->
	[].

get_role_reward(1,1) ->
[{0,19020001,2},{0,32010479,2},{0,32060111,1}];

get_role_reward(1,2) ->
[{0,19020001,2},{0,32010479,2},{0,32060111,1}];

get_role_reward(1,3) ->
[{0,19020001,2},{0,32010479,2}];

get_role_reward(1,4) ->
[{0,19020001,2},{0,32010479,2}];

get_role_reward(1,5) ->
[{0,19020001,2},{0,32010479,2}];

get_role_reward(1,6) ->
[{0,19020001,2},{0,32010479,2}];

get_role_reward(2,1) ->
[{0,19020001,2},{0,32010479,2},{0,32060111,1}];

get_role_reward(2,2) ->
[{0,19020001,2},{0,32010479,2},{0,32060111,1}];

get_role_reward(2,3) ->
[{0,19020001,2},{0,32010479,2}];

get_role_reward(2,4) ->
[{0,19020001,2},{0,32010479,2}];

get_role_reward(2,5) ->
[{0,19020001,2},{0,32010479,2}];

get_role_reward(2,6) ->
[{0,19020001,2},{0,32010479,2}];

get_role_reward(4,1) ->
[{0,19020001,2},{0,32010479,2},{0,32060111,1}];

get_role_reward(4,2) ->
[{0,19020001,2},{0,32010479,2},{0,32060111,1}];

get_role_reward(4,3) ->
[{0,19020001,2},{0,32010479,2}];

get_role_reward(4,4) ->
[{0,19020001,2},{0,32010479,2}];

get_role_reward(4,5) ->
[{0,19020001,2},{0,32010479,2}];

get_role_reward(4,6) ->
[{0,19020001,2},{0,32010479,2}];

get_role_reward(8,1) ->
[{0,19020001,2},{0,32010479,2},{0,32060111,1}];

get_role_reward(8,2) ->
[{0,19020001,2},{0,32010479,2},{0,32060111,1}];

get_role_reward(8,3) ->
[{0,19020001,2},{0,32010479,2}];

get_role_reward(8,4) ->
[{0,19020001,2},{0,32010479,2}];

get_role_reward(8,5) ->
[{0,19020001,2},{0,32010479,2}];

get_role_reward(8,6) ->
[{0,19020001,2},{0,32010479,2}];

get_role_reward(_Mod,_Stage) ->
	[].


get_role_reward_list(1) ->
[{1,500},{2,800},{3,1000},{4,1500},{5,2000},{6,2500}];


get_role_reward_list(2) ->
[{1,500},{2,800},{3,1000},{4,1500},{5,2000},{6,2500}];


get_role_reward_list(4) ->
[{1,500},{2,800},{3,1000},{4,1500},{5,2000},{6,2500}];


get_role_reward_list(8) ->
[{1,500},{2,800},{3,1000},{4,1500},{5,2000},{6,2500}];

get_role_reward_list(_Mod) ->
	[].

get_group_list() ->
[1,2,3].


get_bron_xy(1) ->
[{473,3140}];


get_bron_xy(2) ->
[{4290,3361}];


get_bron_xy(3) ->
[{2245,541}];

get_bron_xy(_Group) ->
	[].


get_group_name(1) ->
<<"海尊阵营"/utf8>>;


get_group_name(2) ->
<<"天尊阵营"/utf8>>;


get_group_name(3) ->
<<"夜尊阵营"/utf8>>;

get_group_name(_Group) ->
	<<>>.

