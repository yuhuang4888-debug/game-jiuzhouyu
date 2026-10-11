%%%---------------------------------------
%%% module      : data_guild_god
%%% description : 公会神像配置
%%%
%%%---------------------------------------
-module(data_guild_god).
-compile(export_all).
-include("guild_god.hrl").



get_all_god_ids() ->
[1,2,3,4].


get_god_awake_condition(1) ->
[];


get_god_awake_condition(2) ->
[{guild_title_lv,3},{role_lv, 0}, {guild_lv,0}, {open_day, 0}];


get_god_awake_condition(3) ->
[{guild_title_lv,5},{role_lv, 0}, {guild_lv,0}, {open_day, 0}];


get_god_awake_condition(4) ->
[{guild_title_lv,7},{role_lv, 0}, {guild_lv,0}, {open_day, 0}];

get_god_awake_condition(_Godid) ->
	[].


get_god_name(1) ->
<<"武魂·仁"/utf8>>;


get_god_name(2) ->
<<"武魂·义"/utf8>>;


get_god_name(3) ->
<<"武魂·智"/utf8>>;


get_god_name(4) ->
<<"武魂·勇"/utf8>>;

get_god_name(_Godid) ->
	"".

get_next_color_cost(1,0) ->
[{0,38040087,30}];

get_next_color_cost(1,1) ->
[{0,38040087,30},{0,38040082,1}];

get_next_color_cost(1,2) ->
[{0,38040087,30},{0,38040082,2}];

get_next_color_cost(1,3) ->
[{0,38040087,30},{0,38040082,4}];

get_next_color_cost(1,4) ->
[{0,38040087,30},{0,38040082,6}];

get_next_color_cost(1,5) ->
[{0,38040087,30},{0,38040082,8}];

get_next_color_cost(1,6) ->
[];

get_next_color_cost(2,0) ->
[{0,38040088,30}];

get_next_color_cost(2,1) ->
[{0,38040088,30},{0,38040082,1}];

get_next_color_cost(2,2) ->
[{0,38040088,30},{0,38040082,2}];

get_next_color_cost(2,3) ->
[{0,38040088,30},{0,38040082,4}];

get_next_color_cost(2,4) ->
[{0,38040088,30},{0,38040082,6}];

get_next_color_cost(2,5) ->
[{0,38040088,30},{0,38040082,8}];

get_next_color_cost(2,6) ->
[];

get_next_color_cost(3,0) ->
[{0,38040089,30}];

get_next_color_cost(3,1) ->
[{0,38040089,30},{0,38040082,1}];

get_next_color_cost(3,2) ->
[{0,38040089,30},{0,38040082,2}];

get_next_color_cost(3,3) ->
[{0,38040089,30},{0,38040082,4}];

get_next_color_cost(3,4) ->
[{0,38040089,30},{0,38040082,6}];

get_next_color_cost(3,5) ->
[{0,38040089,30},{0,38040082,8}];

get_next_color_cost(3,6) ->
[];

get_next_color_cost(4,0) ->
[{0,38040090,30}];

get_next_color_cost(4,1) ->
[{0,38040090,30},{0,38040082,1}];

get_next_color_cost(4,2) ->
[{0,38040090,30},{0,38040082,2}];

get_next_color_cost(4,3) ->
[{0,38040090,30},{0,38040082,4}];

get_next_color_cost(4,4) ->
[{0,38040090,30},{0,38040082,6}];

get_next_color_cost(4,5) ->
[{0,38040090,30},{0,38040082,8}];

get_next_color_cost(4,6) ->
[];

get_next_color_cost(_Godid,_Color) ->
	[].

get_color_attr(1,0) ->
[];

get_color_attr(1,1) ->
[{1,3150},{2,94500},{3,1575},{4,2363}];

get_color_attr(1,2) ->
[{1,4320},{2,129600},{3,2160},{4,3240},{19,12},{21,12}];

get_color_attr(1,3) ->
[{1,5490},{2,164700},{3,2745},{4,4118},{19,24},{21,24}];

get_color_attr(1,4) ->
[{1,6660},{2,199800},{3,3330},{4,4995},{19,36},{21,36}];

get_color_attr(1,5) ->
[{1,7830},{2,234900},{3,3915},{4,5873},{19,48},{21,48}];

get_color_attr(1,6) ->
[{1,9000},{2,270000},{3,4500},{4,6750},{19,60},{21,60}];

get_color_attr(2,0) ->
[];

get_color_attr(2,1) ->
[{1,4200},{2,126000},{3,2100},{4,3150}];

get_color_attr(2,2) ->
[{1,5760},{2,172800},{3,2880},{4,4320},{19,16},{21,16}];

get_color_attr(2,3) ->
[{1,7320},{2,219600},{3,3660},{4,5490},{19,32},{21,32}];

get_color_attr(2,4) ->
[{1,8880},{2,266400},{3,4440},{4,6660},{19,48},{21,48}];

get_color_attr(2,5) ->
[{1,10440},{2,313200},{3,5220},{4,7830},{19,64},{21,64}];

get_color_attr(2,6) ->
[{1,12000},{2,360000},{3,6000},{4,9000},{19,80},{21,80}];

get_color_attr(3,0) ->
[];

get_color_attr(3,1) ->
[{1,5250},{2,157500},{3,2625},{4,3938}];

get_color_attr(3,2) ->
[{1,7200},{2,216000},{3,3600},{4,5400},{19,20},{21,20}];

get_color_attr(3,3) ->
[{1,9150},{2,274500},{3,4575},{4,6863},{19,40},{21,40}];

get_color_attr(3,4) ->
[{1,11100},{2,333000},{3,5550},{4,8325},{19,60},{21,60}];

get_color_attr(3,5) ->
[{1,13050},{2,391500},{3,6525},{4,9788},{19,80},{21,80}];

get_color_attr(3,6) ->
[{1,15000},{2,450000},{3,7500},{4,11250},{19,100},{21,100}];

get_color_attr(4,0) ->
[];

get_color_attr(4,1) ->
[{1,8400},{2,252000},{3,4200},{4,6300}];

get_color_attr(4,2) ->
[{1,11520},{2,345600},{3,5760},{4,8640},{19,32},{21,32}];

get_color_attr(4,3) ->
[{1,14640},{2,439200},{3,7320},{4,10980},{19,64},{21,64}];

get_color_attr(4,4) ->
[{1,17760},{2,532800},{3,8880},{4,13320},{19,96},{21,96}];

get_color_attr(4,5) ->
[{1,20880},{2,626400},{3,10440},{4,15660},{19,128},{21,128}];

get_color_attr(4,6) ->
[{1,24000},{2,720000},{3,12000},{4,18000},{19,160},{21,160}];

get_color_attr(_Godid,_Color) ->
	[].

get_next_lv_cost(1,0) ->
[{0, 38040083, 1}];

get_next_lv_cost(1,1) ->
[{0, 38040083, 2}];

get_next_lv_cost(1,2) ->
[{0, 38040083, 2}];

get_next_lv_cost(1,3) ->
[{0, 38040083, 3}];

get_next_lv_cost(1,4) ->
[{0, 38040083, 5}];

get_next_lv_cost(1,5) ->
[{0, 38040083, 7}];

get_next_lv_cost(1,6) ->
[{0, 38040083, 9}];

get_next_lv_cost(1,7) ->
[{0, 38040083, 11}];

get_next_lv_cost(1,8) ->
[{0, 38040083, 13}];

get_next_lv_cost(1,9) ->
[{0, 38040083, 15}];

get_next_lv_cost(1,10) ->
[];

get_next_lv_cost(2,0) ->
[{0, 38040083, 1}];

get_next_lv_cost(2,1) ->
[{0, 38040083, 2}];

get_next_lv_cost(2,2) ->
[{0, 38040083, 2}];

get_next_lv_cost(2,3) ->
[{0, 38040083, 3}];

get_next_lv_cost(2,4) ->
[{0, 38040083, 5}];

get_next_lv_cost(2,5) ->
[{0, 38040083, 7}];

get_next_lv_cost(2,6) ->
[{0, 38040083, 9}];

get_next_lv_cost(2,7) ->
[{0, 38040083, 11}];

get_next_lv_cost(2,8) ->
[{0, 38040083, 13}];

get_next_lv_cost(2,9) ->
[{0, 38040083, 15}];

get_next_lv_cost(2,10) ->
[];

get_next_lv_cost(3,0) ->
[{0, 38040083, 1}];

get_next_lv_cost(3,1) ->
[{0, 38040083, 2}];

get_next_lv_cost(3,2) ->
[{0, 38040083, 2}];

get_next_lv_cost(3,3) ->
[{0, 38040083, 3}];

get_next_lv_cost(3,4) ->
[{0, 38040083, 5}];

get_next_lv_cost(3,5) ->
[{0, 38040083, 7}];

get_next_lv_cost(3,6) ->
[{0, 38040083, 9}];

get_next_lv_cost(3,7) ->
[{0, 38040083, 11}];

get_next_lv_cost(3,8) ->
[{0, 38040083, 13}];

get_next_lv_cost(3,9) ->
[{0, 38040083, 15}];

get_next_lv_cost(3,10) ->
[];

get_next_lv_cost(4,0) ->
[{0, 38040083, 1}];

get_next_lv_cost(4,1) ->
[{0, 38040083, 2}];

get_next_lv_cost(4,2) ->
[{0, 38040083, 2}];

get_next_lv_cost(4,3) ->
[{0, 38040083, 3}];

get_next_lv_cost(4,4) ->
[{0, 38040083, 5}];

get_next_lv_cost(4,5) ->
[{0, 38040083, 7}];

get_next_lv_cost(4,6) ->
[{0, 38040083, 9}];

get_next_lv_cost(4,7) ->
[{0, 38040083, 11}];

get_next_lv_cost(4,8) ->
[{0, 38040083, 13}];

get_next_lv_cost(4,9) ->
[{0, 38040083, 15}];

get_next_lv_cost(4,10) ->
[];

get_next_lv_cost(_Godid,_Lv) ->
	[].

get_lv_attr(1,0) ->
[];

get_lv_attr(1,1) ->
[{1,168},{2,5040},{3,84},{4,126},{21,2},{22,2}];

get_lv_attr(1,2) ->
[{1,504},{2,15120},{3,252},{4,378},{21,5},{22,5}];

get_lv_attr(1,3) ->
[{1,1008},{2,30240},{3,504},{4,756},{21,10},{22,10}];

get_lv_attr(1,4) ->
[{1,1680},{2,50400},{3,840},{4,1260},{21,16},{22,16}];

get_lv_attr(1,5) ->
[{1,2520},{2,75600},{3,1260},{4,1890},{21,24},{22,24}];

get_lv_attr(1,6) ->
[{1,3570},{2,107100},{3,1785},{4,2678},{21,34},{22,34}];

get_lv_attr(1,7) ->
[{1,4830},{2,144900},{3,2415},{4,3623},{21,46},{22,46}];

get_lv_attr(1,8) ->
[{1,6300},{2,189000},{3,3150},{4,4725},{21,60},{22,60}];

get_lv_attr(1,9) ->
[{1,7980},{2,239400},{3,3990},{4,5985},{21,76},{22,76}];

get_lv_attr(1,10) ->
[{1,10080},{2,302400},{3,5040},{4,7560},{21,96},{22,96}];

get_lv_attr(2,0) ->
[];

get_lv_attr(2,1) ->
[{1,168},{2,5040},{3,84},{4,126},{21,2},{22,2}];

get_lv_attr(2,2) ->
[{1,504},{2,15120},{3,252},{4,378},{21,5},{22,5}];

get_lv_attr(2,3) ->
[{1,1008},{2,30240},{3,504},{4,756},{21,10},{22,10}];

get_lv_attr(2,4) ->
[{1,1680},{2,50400},{3,840},{4,1260},{21,16},{22,16}];

get_lv_attr(2,5) ->
[{1,2520},{2,75600},{3,1260},{4,1890},{21,24},{22,24}];

get_lv_attr(2,6) ->
[{1,3570},{2,107100},{3,1785},{4,2678},{21,34},{22,34}];

get_lv_attr(2,7) ->
[{1,4830},{2,144900},{3,2415},{4,3623},{21,46},{22,46}];

get_lv_attr(2,8) ->
[{1,6300},{2,189000},{3,3150},{4,4725},{21,60},{22,60}];

get_lv_attr(2,9) ->
[{1,7980},{2,239400},{3,3990},{4,5985},{21,76},{22,76}];

get_lv_attr(2,10) ->
[{1,10080},{2,302400},{3,5040},{4,7560},{21,96},{22,96}];

get_lv_attr(3,0) ->
[];

get_lv_attr(3,1) ->
[{1,168},{2,5040},{3,84},{4,126},{21,2},{22,2}];

get_lv_attr(3,2) ->
[{1,504},{2,15120},{3,252},{4,378},{21,5},{22,5}];

get_lv_attr(3,3) ->
[{1,1008},{2,30240},{3,504},{4,756},{21,10},{22,10}];

get_lv_attr(3,4) ->
[{1,1680},{2,50400},{3,840},{4,1260},{21,16},{22,16}];

get_lv_attr(3,5) ->
[{1,2520},{2,75600},{3,1260},{4,1890},{21,24},{22,24}];

get_lv_attr(3,6) ->
[{1,3570},{2,107100},{3,1785},{4,2678},{21,34},{22,34}];

get_lv_attr(3,7) ->
[{1,4830},{2,144900},{3,2415},{4,3623},{21,46},{22,46}];

get_lv_attr(3,8) ->
[{1,6300},{2,189000},{3,3150},{4,4725},{21,60},{22,60}];

get_lv_attr(3,9) ->
[{1,7980},{2,239400},{3,3990},{4,5985},{21,76},{22,76}];

get_lv_attr(3,10) ->
[{1,10080},{2,302400},{3,5040},{4,7560},{21,96},{22,96}];

get_lv_attr(4,0) ->
[];

get_lv_attr(4,1) ->
[{1,168},{2,5040},{3,84},{4,126},{21,2},{22,2}];

get_lv_attr(4,2) ->
[{1,504},{2,15120},{3,252},{4,378},{21,5},{22,5}];

get_lv_attr(4,3) ->
[{1,1008},{2,30240},{3,504},{4,756},{21,10},{22,10}];

get_lv_attr(4,4) ->
[{1,1680},{2,50400},{3,840},{4,1260},{21,16},{22,16}];

get_lv_attr(4,5) ->
[{1,2520},{2,75600},{3,1260},{4,1890},{21,24},{22,24}];

get_lv_attr(4,6) ->
[{1,3570},{2,107100},{3,1785},{4,2678},{21,34},{22,34}];

get_lv_attr(4,7) ->
[{1,4830},{2,144900},{3,2415},{4,3623},{21,46},{22,46}];

get_lv_attr(4,8) ->
[{1,6300},{2,189000},{3,3150},{4,4725},{21,60},{22,60}];

get_lv_attr(4,9) ->
[{1,7980},{2,239400},{3,3990},{4,5985},{21,76},{22,76}];

get_lv_attr(4,10) ->
[{1,10080},{2,302400},{3,5040},{4,7560},{21,96},{22,96}];

get_lv_attr(_Godid,_Lv) ->
	[].

get_rune_cfg(81010031) ->
	#guild_rune_cfg{goods_id = 81010031,cost = [{0,38040085,10}],attr = [{1,50},{2,1485},{3,25},{4,37}],new_goods_id = 81010032,lv = 1};

get_rune_cfg(81010032) ->
	#guild_rune_cfg{goods_id = 81010032,cost = [{0,38040085,20}],attr = [{1,66},{2,1980},{3,33},{4,50}],new_goods_id = 81010033,lv = 2};

get_rune_cfg(81010033) ->
	#guild_rune_cfg{goods_id = 81010033,cost = [{0,38040085,25}],attr = [{1,99},{2,2970},{3,50},{4,74}],new_goods_id = 81010034,lv = 3};

get_rune_cfg(81010034) ->
	#guild_rune_cfg{goods_id = 81010034,cost = [{0,38040085,30}],attr = [{1,140},{2,4208},{3,70},{4,105}],new_goods_id = 81010035,lv = 4};

get_rune_cfg(81010035) ->
	#guild_rune_cfg{goods_id = 81010035,cost = [{0,38040085,35}],attr = [{1,206},{2,6188},{3,103},{4,155}],new_goods_id = 81010036,lv = 5};

get_rune_cfg(81010036) ->
	#guild_rune_cfg{goods_id = 81010036,cost = [{0,38040085,40}],attr = [{1,297},{2,8910},{3,149},{4,223}],new_goods_id = 81010037,lv = 6};

get_rune_cfg(81010037) ->
	#guild_rune_cfg{goods_id = 81010037,cost = [{0,38040085,45}],attr = [{1,413},{2,12375},{3,206},{4,309}],new_goods_id = 81010038,lv = 7};

get_rune_cfg(81010038) ->
	#guild_rune_cfg{goods_id = 81010038,cost = [{0,38040085,50}],attr = [{1,578},{2,17325},{3,289},{4,433}],new_goods_id = 81010039,lv = 8};

get_rune_cfg(81010039) ->
	#guild_rune_cfg{goods_id = 81010039,cost = [{0,38040085,55}],attr = [{1,866},{2,25988},{3,433},{4,650}],new_goods_id = 81010040,lv = 9};

get_rune_cfg(81010040) ->
	#guild_rune_cfg{goods_id = 81010040,cost = [],attr = [{1,1238},{2,37125},{3,619},{4,928}],new_goods_id = 0,lv = 10};

get_rune_cfg(81010041) ->
	#guild_rune_cfg{goods_id = 81010041,cost = [{0,38040085,50}],attr = [{1,99},{2,2970},{3,50},{4,74}],new_goods_id = 81010042,lv = 1};

get_rune_cfg(81010042) ->
	#guild_rune_cfg{goods_id = 81010042,cost = [{0,38040085,75}],attr = [{1,140},{2,4208},{3,70},{4,105}],new_goods_id = 81010043,lv = 2};

get_rune_cfg(81010043) ->
	#guild_rune_cfg{goods_id = 81010043,cost = [{0,38040085,100}],attr = [{1,198},{2,5940},{3,99},{4,149}],new_goods_id = 81010044,lv = 3};

get_rune_cfg(81010044) ->
	#guild_rune_cfg{goods_id = 81010044,cost = [{0,38040085,125}],attr = [{1,289},{2,8663},{3,144},{4,217}],new_goods_id = 81010045,lv = 4};

get_rune_cfg(81010045) ->
	#guild_rune_cfg{goods_id = 81010045,cost = [{0,38040085,150}],attr = [{1,413},{2,12375},{3,206},{4,309}],new_goods_id = 81010046,lv = 5};

get_rune_cfg(81010046) ->
	#guild_rune_cfg{goods_id = 81010046,cost = [{0,38040085,175}],attr = [{1,578},{2,17325},{3,289},{4,433}],new_goods_id = 81010047,lv = 6};

get_rune_cfg(81010047) ->
	#guild_rune_cfg{goods_id = 81010047,cost = [{0,38040085,200}],attr = [{1,825},{2,24750},{3,413},{4,619}],new_goods_id = 81010048,lv = 7};

get_rune_cfg(81010048) ->
	#guild_rune_cfg{goods_id = 81010048,cost = [{0,38040085,225}],attr = [{1,1238},{2,37125},{3,619},{4,928}],new_goods_id = 81010049,lv = 8};

get_rune_cfg(81010049) ->
	#guild_rune_cfg{goods_id = 81010049,cost = [{0,38040085,250}],attr = [{1,1733},{2,51975},{3,866},{4,1299}],new_goods_id = 81010050,lv = 9};

get_rune_cfg(81010050) ->
	#guild_rune_cfg{goods_id = 81010050,cost = [],attr = [{1,2475},{2,74250},{3,1238},{4,1856}],new_goods_id = 0,lv = 10};

get_rune_cfg(81010051) ->
	#guild_rune_cfg{goods_id = 81010051,cost = [{0,38040086,100}],attr = [{1,495},{2,14850},{3,248},{4,371},{20,2},{22,4}],new_goods_id = 81010053,lv = 1};

get_rune_cfg(81010053) ->
	#guild_rune_cfg{goods_id = 81010053,cost = [{0,38040086,200}],attr = [{1,990},{2,29700},{3,495},{4,743},{20,3},{22,8}],new_goods_id = 81010055,lv = 3};

get_rune_cfg(81010055) ->
	#guild_rune_cfg{goods_id = 81010055,cost = [{0,38040086,300}],attr = [{1,2063},{2,61875},{3,1031},{4,1547},{20,6},{22,17}],new_goods_id = 81010058,lv = 5};

get_rune_cfg(81010058) ->
	#guild_rune_cfg{goods_id = 81010058,cost = [{0,38040086,500}],attr = [{1,4125},{2,123750},{3,2063},{4,3094},{20,13},{22,33}],new_goods_id = 81010060,lv = 8};

get_rune_cfg(81010060) ->
	#guild_rune_cfg{goods_id = 81010060,cost = [],attr = [{1,8250},{2,247500},{3,4125},{4,6188},{20,25},{22,67}],new_goods_id = 0,lv = 10};

get_rune_cfg(_Goodsid) ->
	[].

get_combo_cfg(1,1) ->
	#guild_god_combo_cfg{god_id = 1,combo_id = 1,condition = [{3,4},{4,2}],attr_skill = [{attr, [{19,6},{21,16},{13,5},{17,8},{14,5},{45,8}]}]};

get_combo_cfg(1,2) ->
	#guild_god_combo_cfg{god_id = 1,combo_id = 2,condition = [{4,6}],attr_skill = [{attr, [{19,12},{21,32},{13,10},{17,16},{14,10},{45,16}]}]};

get_combo_cfg(1,3) ->
	#guild_god_combo_cfg{god_id = 1,combo_id = 3,condition = [{4,4},{5,2}],attr_skill = [{attr, [{19,36},{21,96},{13,30},{17,48},{14,30},{45,48}]}]};

get_combo_cfg(1,4) ->
	#guild_god_combo_cfg{god_id = 1,combo_id = 4,condition = [{5,6}],attr_skill = [{attr, [{19,72},{21,192},{13,60},{17,96},{14,60},{45,96}]}]};

get_combo_cfg(2,1) ->
	#guild_god_combo_cfg{god_id = 2,combo_id = 1,condition = [{3,4},{4,2}],attr_skill = [{attr, [{19,6},{21,16},{13,5},{17,8},{14,5},{45,8}]}]};

get_combo_cfg(2,2) ->
	#guild_god_combo_cfg{god_id = 2,combo_id = 2,condition = [{4,6}],attr_skill = [{attr, [{19,12},{21,32},{13,10},{17,16},{14,10},{45,16}]}]};

get_combo_cfg(2,3) ->
	#guild_god_combo_cfg{god_id = 2,combo_id = 3,condition = [{4,4},{5,2}],attr_skill = [{attr, [{19,36},{21,96},{13,30},{17,48},{14,30},{45,48}]}]};

get_combo_cfg(2,4) ->
	#guild_god_combo_cfg{god_id = 2,combo_id = 4,condition = [{5,6}],attr_skill = [{attr, [{19,72},{21,192},{13,60},{17,96},{14,60},{45,96}]}]};

get_combo_cfg(3,1) ->
	#guild_god_combo_cfg{god_id = 3,combo_id = 1,condition = [{3,4},{4,2}],attr_skill = [{attr, [{19,6},{21,16},{13,5},{17,8},{14,5},{45,8}]}]};

get_combo_cfg(3,2) ->
	#guild_god_combo_cfg{god_id = 3,combo_id = 2,condition = [{4,6}],attr_skill = [{attr, [{19,12},{21,32},{13,10},{17,16},{14,10},{45,16}]}]};

get_combo_cfg(3,3) ->
	#guild_god_combo_cfg{god_id = 3,combo_id = 3,condition = [{4,4},{5,2}],attr_skill = [{attr, [{19,36},{21,96},{13,30},{17,48},{14,30},{45,48}]}]};

get_combo_cfg(3,4) ->
	#guild_god_combo_cfg{god_id = 3,combo_id = 4,condition = [{5,6}],attr_skill = [{attr, [{19,72},{21,192},{13,60},{17,96},{14,60},{45,96}]}]};

get_combo_cfg(4,1) ->
	#guild_god_combo_cfg{god_id = 4,combo_id = 1,condition = [{3,4},{4,2}],attr_skill = [{attr, [{19,6},{21,16},{13,5},{17,8},{14,5},{45,8}]}]};

get_combo_cfg(4,2) ->
	#guild_god_combo_cfg{god_id = 4,combo_id = 2,condition = [{4,6}],attr_skill = [{attr, [{19,12},{21,32},{13,10},{17,16},{14,10},{45,16}]}]};

get_combo_cfg(4,3) ->
	#guild_god_combo_cfg{god_id = 4,combo_id = 3,condition = [{4,4},{5,2}],attr_skill = [{attr, [{19,36},{21,96},{13,30},{17,48},{14,30},{45,48}]}]};

get_combo_cfg(4,4) ->
	#guild_god_combo_cfg{god_id = 4,combo_id = 4,condition = [{5,6}],attr_skill = [{attr, [{19,72},{21,192},{13,60},{17,96},{14,60},{45,96}]}]};

get_combo_cfg(_Godid,_Comboid) ->
	[].


get_combo_ids(1) ->
"1,2,3,4";


get_combo_ids(2) ->
"1,2,3,4";


get_combo_ids(3) ->
"1,2,3,4";


get_combo_ids(4) ->
"1,2,3,4";

get_combo_ids(_Godid) ->
	[].


get_combo_name(1) ->
"暗裔血脉";


get_combo_name(2) ->
"铭文掌控";


get_combo_name(3) ->
"贯注仪式";


get_combo_name(4) ->
"传奇之力";

get_combo_name(_Comboid) ->
	"".


get_rune_achievement(1) ->
[10,7,5,3];


get_rune_achievement(2) ->
[10,7,5,3];


get_rune_achievement(3) ->
[10,7,5,3];


get_rune_achievement(4) ->
[10,7,5,3];

get_rune_achievement(_Godid) ->
	[].

get_rune_achievement_attr(1,3) ->
25;

get_rune_achievement_attr(1,5) ->
25;

get_rune_achievement_attr(1,7) ->
25;

get_rune_achievement_attr(1,10) ->
25;

get_rune_achievement_attr(2,3) ->
25;

get_rune_achievement_attr(2,5) ->
25;

get_rune_achievement_attr(2,7) ->
25;

get_rune_achievement_attr(2,10) ->
25;

get_rune_achievement_attr(3,3) ->
25;

get_rune_achievement_attr(3,5) ->
25;

get_rune_achievement_attr(3,7) ->
25;

get_rune_achievement_attr(3,10) ->
25;

get_rune_achievement_attr(4,3) ->
25;

get_rune_achievement_attr(4,5) ->
25;

get_rune_achievement_attr(4,7) ->
25;

get_rune_achievement_attr(4,10) ->
25;

get_rune_achievement_attr(_Godid,_Needlv) ->
	[].


get_kv(combo_tv_time) ->
300;


get_kv(lv_limit) ->
130;


get_kv(open_day) ->
1;

get_kv(_Key) ->
	[].

