%%%---------------------------------------
%%% module      : data_fairy_buy
%%% description : 仙灵直购配置
%%%
%%%---------------------------------------
-module(data_fairy_buy).
-compile(export_all).
-include("fairy_buy.hrl").



get_fairy_buy_cfg(1001) ->
	#fairy_buy_cfg{id = 1001,name = <<"兽灵使"/utf8>>,shape = 1001,open_lv = 210,open_day = 3,price = 30,module = 1,recharge_id = 141,show_price = 68};

get_fairy_buy_cfg(1002) ->
	#fairy_buy_cfg{id = 1002,name = <<"幽魂使"/utf8>>,shape = 1002,open_lv = 210,open_day = 4,price = 30,module = 2,recharge_id = 142,show_price = 68};

get_fairy_buy_cfg(1003) ->
	#fairy_buy_cfg{id = 1003,name = <<"梦羽使"/utf8>>,shape = 1003,open_lv = 210,open_day = 5,price = 30,module = 3,recharge_id = 143,show_price = 68};

get_fairy_buy_cfg(1004) ->
	#fairy_buy_cfg{id = 1004,name = <<"平安使"/utf8>>,shape = 1004,open_lv = 210,open_day = 6,price = 30,module = 4,recharge_id = 144,show_price = 68};

get_fairy_buy_cfg(1005) ->
	#fairy_buy_cfg{id = 1005,name = <<"武神使"/utf8>>,shape = 1005,open_lv = 210,open_day = 7,price = 68,module = 5,recharge_id = 145,show_price = 128};

get_fairy_buy_cfg(_Id) ->
	[].

get_all_fairy_id() ->
[1001,1002,1003,1004,1005].


get_fairy_id_by_recharge_id(141) ->
1001;


get_fairy_id_by_recharge_id(142) ->
1002;


get_fairy_id_by_recharge_id(143) ->
1003;


get_fairy_id_by_recharge_id(144) ->
1004;


get_fairy_id_by_recharge_id(145) ->
1005;

get_fairy_id_by_recharge_id(_Rechargeid) ->
	[].


get_fairy_id_by_mount_type(1) ->
1001;


get_fairy_id_by_mount_type(2) ->
1002;


get_fairy_id_by_mount_type(3) ->
1003;


get_fairy_id_by_mount_type(4) ->
1004;


get_fairy_id_by_mount_type(5) ->
1005;

get_fairy_id_by_mount_type(_Module) ->
	[].

get_fairy_buy_node(1001,1) ->
	#fairy_buy_node_cfg{fairy_id = 1001,fairy_lv = 1,condition = [{lv,210}],type = 1,attr = [{1,600},{3,300},{5,150},{7,150}],skill = [{55010001,1}]};

get_fairy_buy_node(1001,2) ->
	#fairy_buy_node_cfg{fairy_id = 1001,fairy_lv = 2,condition = [{lv,220}],type = 1,attr = [{1,100},{3,50},{5,25},{7,25}],skill = []};

get_fairy_buy_node(1001,3) ->
	#fairy_buy_node_cfg{fairy_id = 1001,fairy_lv = 3,condition = [{lv,230}],type = 1,attr = [{1,100},{3,50},{5,25},{7,25}],skill = []};

get_fairy_buy_node(1001,4) ->
	#fairy_buy_node_cfg{fairy_id = 1001,fairy_lv = 4,condition = [{lv,240}],type = 1,attr = [{1,100},{3,50},{5,25},{7,25}],skill = []};

get_fairy_buy_node(1001,5) ->
	#fairy_buy_node_cfg{fairy_id = 1001,fairy_lv = 5,condition = [{lv,250}],type = 2,attr = [],skill = [{55010001,2}]};

get_fairy_buy_node(1001,6) ->
	#fairy_buy_node_cfg{fairy_id = 1001,fairy_lv = 6,condition = [{lv,260}],type = 1,attr = [{1,250},{3,125},{5,63},{7,63}],skill = []};

get_fairy_buy_node(1001,7) ->
	#fairy_buy_node_cfg{fairy_id = 1001,fairy_lv = 7,condition = [{lv,270}],type = 1,attr = [{1,250},{3,125},{5,63},{7,63}],skill = []};

get_fairy_buy_node(1001,8) ->
	#fairy_buy_node_cfg{fairy_id = 1001,fairy_lv = 8,condition = [{lv,280}],type = 1,attr = [{1,250},{3,125},{5,63},{7,63}],skill = []};

get_fairy_buy_node(1001,9) ->
	#fairy_buy_node_cfg{fairy_id = 1001,fairy_lv = 9,condition = [{lv,290}],type = 1,attr = [{1,250},{3,125},{5,63},{7,63}],skill = []};

get_fairy_buy_node(1001,10) ->
	#fairy_buy_node_cfg{fairy_id = 1001,fairy_lv = 10,condition = [{lv,300}],type = 2,attr = [],skill = [{55010001,3}]};

get_fairy_buy_node(1001,11) ->
	#fairy_buy_node_cfg{fairy_id = 1001,fairy_lv = 11,condition = [{lv,310}],type = 1,attr = [{1,550},{3,275},{5,138},{7,138}],skill = []};

get_fairy_buy_node(1001,12) ->
	#fairy_buy_node_cfg{fairy_id = 1001,fairy_lv = 12,condition = [{lv,320}],type = 1,attr = [{1,550},{3,275},{5,138},{7,138}],skill = []};

get_fairy_buy_node(1001,13) ->
	#fairy_buy_node_cfg{fairy_id = 1001,fairy_lv = 13,condition = [{lv,330}],type = 1,attr = [{1,550},{3,275},{5,138},{7,138}],skill = []};

get_fairy_buy_node(1001,14) ->
	#fairy_buy_node_cfg{fairy_id = 1001,fairy_lv = 14,condition = [{lv,340}],type = 1,attr = [{1,550},{3,275},{5,138},{7,138}],skill = []};

get_fairy_buy_node(1001,15) ->
	#fairy_buy_node_cfg{fairy_id = 1001,fairy_lv = 15,condition = [{lv,350}],type = 2,attr = [],skill = [{55010001,4}]};

get_fairy_buy_node(1001,16) ->
	#fairy_buy_node_cfg{fairy_id = 1001,fairy_lv = 16,condition = [{lv,360}],type = 1,attr = [{1,1050},{3,525},{5,263},{7,263}],skill = []};

get_fairy_buy_node(1001,17) ->
	#fairy_buy_node_cfg{fairy_id = 1001,fairy_lv = 17,condition = [{lv,370}],type = 1,attr = [{1,1050},{3,525},{5,263},{7,263}],skill = []};

get_fairy_buy_node(1001,18) ->
	#fairy_buy_node_cfg{fairy_id = 1001,fairy_lv = 18,condition = [{lv,380}],type = 1,attr = [{1,1050},{3,525},{5,263},{7,263}],skill = []};

get_fairy_buy_node(1001,19) ->
	#fairy_buy_node_cfg{fairy_id = 1001,fairy_lv = 19,condition = [{lv,390}],type = 1,attr = [{1,1050},{3,525},{5,263},{7,263}],skill = []};

get_fairy_buy_node(1001,20) ->
	#fairy_buy_node_cfg{fairy_id = 1001,fairy_lv = 20,condition = [{lv,400}],type = 2,attr = [],skill = [{55010001,5}]};

get_fairy_buy_node(1001,21) ->
	#fairy_buy_node_cfg{fairy_id = 1001,fairy_lv = 21,condition = [{lv,410}],type = 1,attr = [{1,1700},{3,850},{5,425},{7,425}],skill = []};

get_fairy_buy_node(1001,22) ->
	#fairy_buy_node_cfg{fairy_id = 1001,fairy_lv = 22,condition = [{lv,420}],type = 1,attr = [{1,1700},{3,850},{5,425},{7,425}],skill = []};

get_fairy_buy_node(1001,23) ->
	#fairy_buy_node_cfg{fairy_id = 1001,fairy_lv = 23,condition = [{lv,430}],type = 1,attr = [{1,1700},{3,850},{5,425},{7,425}],skill = []};

get_fairy_buy_node(1001,24) ->
	#fairy_buy_node_cfg{fairy_id = 1001,fairy_lv = 24,condition = [{lv,440}],type = 1,attr = [{1,1700},{3,850},{5,425},{7,425}],skill = []};

get_fairy_buy_node(1001,25) ->
	#fairy_buy_node_cfg{fairy_id = 1001,fairy_lv = 25,condition = [{lv,450}],type = 2,attr = [],skill = [{55010001,6}]};

get_fairy_buy_node(1001,26) ->
	#fairy_buy_node_cfg{fairy_id = 1001,fairy_lv = 26,condition = [{lv,460}],type = 1,attr = [{1,2700},{3,1350},{5,675},{7,675}],skill = []};

get_fairy_buy_node(1001,27) ->
	#fairy_buy_node_cfg{fairy_id = 1001,fairy_lv = 27,condition = [{lv,470}],type = 1,attr = [{1,2700},{3,1350},{5,675},{7,675}],skill = []};

get_fairy_buy_node(1001,28) ->
	#fairy_buy_node_cfg{fairy_id = 1001,fairy_lv = 28,condition = [{lv,480}],type = 1,attr = [{1,2700},{3,1350},{5,675},{7,675}],skill = []};

get_fairy_buy_node(1001,29) ->
	#fairy_buy_node_cfg{fairy_id = 1001,fairy_lv = 29,condition = [{lv,490}],type = 1,attr = [{1,2700},{3,1350},{5,675},{7,675}],skill = []};

get_fairy_buy_node(1001,30) ->
	#fairy_buy_node_cfg{fairy_id = 1001,fairy_lv = 30,condition = [{lv,500}],type = 2,attr = [],skill = [{55010001,7}]};

get_fairy_buy_node(1001,31) ->
	#fairy_buy_node_cfg{fairy_id = 1001,fairy_lv = 31,condition = [{lv,510}],type = 1,attr = [{1,3350},{3,1675},{5,838},{7,838}],skill = []};

get_fairy_buy_node(1001,32) ->
	#fairy_buy_node_cfg{fairy_id = 1001,fairy_lv = 32,condition = [{lv,520}],type = 1,attr = [{1,3350},{3,1675},{5,838},{7,838}],skill = []};

get_fairy_buy_node(1001,33) ->
	#fairy_buy_node_cfg{fairy_id = 1001,fairy_lv = 33,condition = [{lv,530}],type = 1,attr = [{1,3350},{3,1675},{5,838},{7,838}],skill = []};

get_fairy_buy_node(1001,34) ->
	#fairy_buy_node_cfg{fairy_id = 1001,fairy_lv = 34,condition = [{lv,540}],type = 1,attr = [{1,3350},{3,1675},{5,838},{7,838}],skill = []};

get_fairy_buy_node(1001,35) ->
	#fairy_buy_node_cfg{fairy_id = 1001,fairy_lv = 35,condition = [{lv,550}],type = 2,attr = [],skill = [{55010001,8}]};

get_fairy_buy_node(1001,36) ->
	#fairy_buy_node_cfg{fairy_id = 1001,fairy_lv = 36,condition = [{lv,560}],type = 1,attr = [{1,4950},{3,2475},{5,1238},{7,1238}],skill = []};

get_fairy_buy_node(1001,37) ->
	#fairy_buy_node_cfg{fairy_id = 1001,fairy_lv = 37,condition = [{lv,570}],type = 1,attr = [{1,4950},{3,2475},{5,1238},{7,1238}],skill = []};

get_fairy_buy_node(1001,38) ->
	#fairy_buy_node_cfg{fairy_id = 1001,fairy_lv = 38,condition = [{lv,580}],type = 1,attr = [{1,4950},{3,2475},{5,1238},{7,1238}],skill = []};

get_fairy_buy_node(1001,39) ->
	#fairy_buy_node_cfg{fairy_id = 1001,fairy_lv = 39,condition = [{lv,590}],type = 1,attr = [{1,4950},{3,2475},{5,1238},{7,1238}],skill = []};

get_fairy_buy_node(1001,40) ->
	#fairy_buy_node_cfg{fairy_id = 1001,fairy_lv = 40,condition = [{lv,600}],type = 2,attr = [],skill = [{55010001,9}]};

get_fairy_buy_node(1001,41) ->
	#fairy_buy_node_cfg{fairy_id = 1001,fairy_lv = 41,condition = [{lv,610}],type = 1,attr = [{1,6450},{3,3225},{5,1613},{7,1613}],skill = []};

get_fairy_buy_node(1001,42) ->
	#fairy_buy_node_cfg{fairy_id = 1001,fairy_lv = 42,condition = [{lv,620}],type = 1,attr = [{1,6450},{3,3225},{5,1613},{7,1613}],skill = []};

get_fairy_buy_node(1001,43) ->
	#fairy_buy_node_cfg{fairy_id = 1001,fairy_lv = 43,condition = [{lv,630}],type = 1,attr = [{1,6450},{3,3225},{5,1613},{7,1613}],skill = []};

get_fairy_buy_node(1001,44) ->
	#fairy_buy_node_cfg{fairy_id = 1001,fairy_lv = 44,condition = [{lv,640}],type = 1,attr = [{1,6450},{3,3225},{5,1613},{7,1613}],skill = []};

get_fairy_buy_node(1001,45) ->
	#fairy_buy_node_cfg{fairy_id = 1001,fairy_lv = 45,condition = [{lv,650}],type = 2,attr = [],skill = [{55010001,10}]};

get_fairy_buy_node(1001,46) ->
	#fairy_buy_node_cfg{fairy_id = 1001,fairy_lv = 46,condition = [{lv,660}],type = 1,attr = [{1,9800},{3,4900},{5,2450},{7,2450}],skill = []};

get_fairy_buy_node(1001,47) ->
	#fairy_buy_node_cfg{fairy_id = 1001,fairy_lv = 47,condition = [{lv,670}],type = 1,attr = [{1,9800},{3,4900},{5,2450},{7,2450}],skill = []};

get_fairy_buy_node(1001,48) ->
	#fairy_buy_node_cfg{fairy_id = 1001,fairy_lv = 48,condition = [{lv,680}],type = 1,attr = [{1,9800},{3,4900},{5,2450},{7,2450}],skill = []};

get_fairy_buy_node(1001,49) ->
	#fairy_buy_node_cfg{fairy_id = 1001,fairy_lv = 49,condition = [{lv,690}],type = 1,attr = [{1,9800},{3,4900},{5,2450},{7,2450}],skill = []};

get_fairy_buy_node(1001,50) ->
	#fairy_buy_node_cfg{fairy_id = 1001,fairy_lv = 50,condition = [{lv,700}],type = 2,attr = [],skill = [{55010001,11}]};

get_fairy_buy_node(1002,1) ->
	#fairy_buy_node_cfg{fairy_id = 1002,fairy_lv = 1,condition = [{lv,210}],type = 1,attr = [{2,12000},{4,300},{6,150},{7,150}],skill = [{55010002,1}]};

get_fairy_buy_node(1002,2) ->
	#fairy_buy_node_cfg{fairy_id = 1002,fairy_lv = 2,condition = [{lv,220}],type = 1,attr = [{2,2000},{4,50},{6,25},{7,25}],skill = []};

get_fairy_buy_node(1002,3) ->
	#fairy_buy_node_cfg{fairy_id = 1002,fairy_lv = 3,condition = [{lv,230}],type = 1,attr = [{2,2000},{4,50},{6,25},{7,25}],skill = []};

get_fairy_buy_node(1002,4) ->
	#fairy_buy_node_cfg{fairy_id = 1002,fairy_lv = 4,condition = [{lv,240}],type = 1,attr = [{2,2000},{4,50},{6,25},{7,25}],skill = []};

get_fairy_buy_node(1002,5) ->
	#fairy_buy_node_cfg{fairy_id = 1002,fairy_lv = 5,condition = [{lv,250}],type = 2,attr = [],skill = [{55010002,2}]};

get_fairy_buy_node(1002,6) ->
	#fairy_buy_node_cfg{fairy_id = 1002,fairy_lv = 6,condition = [{lv,260}],type = 1,attr = [{2,5000},{4,125},{6,63},{7,63}],skill = []};

get_fairy_buy_node(1002,7) ->
	#fairy_buy_node_cfg{fairy_id = 1002,fairy_lv = 7,condition = [{lv,270}],type = 1,attr = [{2,5000},{4,125},{6,63},{7,63}],skill = []};

get_fairy_buy_node(1002,8) ->
	#fairy_buy_node_cfg{fairy_id = 1002,fairy_lv = 8,condition = [{lv,280}],type = 1,attr = [{2,5000},{4,125},{6,63},{7,63}],skill = []};

get_fairy_buy_node(1002,9) ->
	#fairy_buy_node_cfg{fairy_id = 1002,fairy_lv = 9,condition = [{lv,290}],type = 1,attr = [{2,5000},{4,125},{6,63},{7,63}],skill = []};

get_fairy_buy_node(1002,10) ->
	#fairy_buy_node_cfg{fairy_id = 1002,fairy_lv = 10,condition = [{lv,300}],type = 2,attr = [],skill = [{55010002,3}]};

get_fairy_buy_node(1002,11) ->
	#fairy_buy_node_cfg{fairy_id = 1002,fairy_lv = 11,condition = [{lv,310}],type = 1,attr = [{2,11000},{4,275},{6,138},{7,138}],skill = []};

get_fairy_buy_node(1002,12) ->
	#fairy_buy_node_cfg{fairy_id = 1002,fairy_lv = 12,condition = [{lv,320}],type = 1,attr = [{2,11000},{4,275},{6,138},{7,138}],skill = []};

get_fairy_buy_node(1002,13) ->
	#fairy_buy_node_cfg{fairy_id = 1002,fairy_lv = 13,condition = [{lv,330}],type = 1,attr = [{2,11000},{4,275},{6,138},{7,138}],skill = []};

get_fairy_buy_node(1002,14) ->
	#fairy_buy_node_cfg{fairy_id = 1002,fairy_lv = 14,condition = [{lv,340}],type = 1,attr = [{2,11000},{4,275},{6,138},{7,138}],skill = []};

get_fairy_buy_node(1002,15) ->
	#fairy_buy_node_cfg{fairy_id = 1002,fairy_lv = 15,condition = [{lv,350}],type = 2,attr = [],skill = [{55010002,4}]};

get_fairy_buy_node(1002,16) ->
	#fairy_buy_node_cfg{fairy_id = 1002,fairy_lv = 16,condition = [{lv,360}],type = 1,attr = [{2,21000},{4,525},{6,263},{7,263}],skill = []};

get_fairy_buy_node(1002,17) ->
	#fairy_buy_node_cfg{fairy_id = 1002,fairy_lv = 17,condition = [{lv,370}],type = 1,attr = [{2,21000},{4,525},{6,263},{7,263}],skill = []};

get_fairy_buy_node(1002,18) ->
	#fairy_buy_node_cfg{fairy_id = 1002,fairy_lv = 18,condition = [{lv,380}],type = 1,attr = [{2,21000},{4,525},{6,263},{7,263}],skill = []};

get_fairy_buy_node(1002,19) ->
	#fairy_buy_node_cfg{fairy_id = 1002,fairy_lv = 19,condition = [{lv,390}],type = 1,attr = [{2,21000},{4,525},{6,263},{7,263}],skill = []};

get_fairy_buy_node(1002,20) ->
	#fairy_buy_node_cfg{fairy_id = 1002,fairy_lv = 20,condition = [{lv,400}],type = 2,attr = [],skill = [{55010002,5}]};

get_fairy_buy_node(1002,21) ->
	#fairy_buy_node_cfg{fairy_id = 1002,fairy_lv = 21,condition = [{lv,410}],type = 1,attr = [{2,34000},{4,850},{6,425},{7,425}],skill = []};

get_fairy_buy_node(1002,22) ->
	#fairy_buy_node_cfg{fairy_id = 1002,fairy_lv = 22,condition = [{lv,420}],type = 1,attr = [{2,34000},{4,850},{6,425},{7,425}],skill = []};

get_fairy_buy_node(1002,23) ->
	#fairy_buy_node_cfg{fairy_id = 1002,fairy_lv = 23,condition = [{lv,430}],type = 1,attr = [{2,34000},{4,850},{6,425},{7,425}],skill = []};

get_fairy_buy_node(1002,24) ->
	#fairy_buy_node_cfg{fairy_id = 1002,fairy_lv = 24,condition = [{lv,440}],type = 1,attr = [{2,34000},{4,850},{6,425},{7,425}],skill = []};

get_fairy_buy_node(1002,25) ->
	#fairy_buy_node_cfg{fairy_id = 1002,fairy_lv = 25,condition = [{lv,450}],type = 2,attr = [],skill = [{55010002,6}]};

get_fairy_buy_node(1002,26) ->
	#fairy_buy_node_cfg{fairy_id = 1002,fairy_lv = 26,condition = [{lv,460}],type = 1,attr = [{2,54000},{4,1350},{6,675},{7,675}],skill = []};

get_fairy_buy_node(1002,27) ->
	#fairy_buy_node_cfg{fairy_id = 1002,fairy_lv = 27,condition = [{lv,470}],type = 1,attr = [{2,54000},{4,1350},{6,675},{7,675}],skill = []};

get_fairy_buy_node(1002,28) ->
	#fairy_buy_node_cfg{fairy_id = 1002,fairy_lv = 28,condition = [{lv,480}],type = 1,attr = [{2,54000},{4,1350},{6,675},{7,675}],skill = []};

get_fairy_buy_node(1002,29) ->
	#fairy_buy_node_cfg{fairy_id = 1002,fairy_lv = 29,condition = [{lv,490}],type = 1,attr = [{2,54000},{4,1350},{6,675},{7,675}],skill = []};

get_fairy_buy_node(1002,30) ->
	#fairy_buy_node_cfg{fairy_id = 1002,fairy_lv = 30,condition = [{lv,500}],type = 2,attr = [],skill = [{55010002,7}]};

get_fairy_buy_node(1002,31) ->
	#fairy_buy_node_cfg{fairy_id = 1002,fairy_lv = 31,condition = [{lv,510}],type = 1,attr = [{2,67000},{4,1675},{6,838},{7,838}],skill = []};

get_fairy_buy_node(1002,32) ->
	#fairy_buy_node_cfg{fairy_id = 1002,fairy_lv = 32,condition = [{lv,520}],type = 1,attr = [{2,67000},{4,1675},{6,838},{7,838}],skill = []};

get_fairy_buy_node(1002,33) ->
	#fairy_buy_node_cfg{fairy_id = 1002,fairy_lv = 33,condition = [{lv,530}],type = 1,attr = [{2,67000},{4,1675},{6,838},{7,838}],skill = []};

get_fairy_buy_node(1002,34) ->
	#fairy_buy_node_cfg{fairy_id = 1002,fairy_lv = 34,condition = [{lv,540}],type = 1,attr = [{2,67000},{4,1675},{6,838},{7,838}],skill = []};

get_fairy_buy_node(1002,35) ->
	#fairy_buy_node_cfg{fairy_id = 1002,fairy_lv = 35,condition = [{lv,550}],type = 2,attr = [],skill = [{55010002,8}]};

get_fairy_buy_node(1002,36) ->
	#fairy_buy_node_cfg{fairy_id = 1002,fairy_lv = 36,condition = [{lv,560}],type = 1,attr = [{2,99000},{4,2475},{6,1238},{7,1238}],skill = []};

get_fairy_buy_node(1002,37) ->
	#fairy_buy_node_cfg{fairy_id = 1002,fairy_lv = 37,condition = [{lv,570}],type = 1,attr = [{2,99000},{4,2475},{6,1238},{7,1238}],skill = []};

get_fairy_buy_node(1002,38) ->
	#fairy_buy_node_cfg{fairy_id = 1002,fairy_lv = 38,condition = [{lv,580}],type = 1,attr = [{2,99000},{4,2475},{6,1238},{7,1238}],skill = []};

get_fairy_buy_node(1002,39) ->
	#fairy_buy_node_cfg{fairy_id = 1002,fairy_lv = 39,condition = [{lv,590}],type = 1,attr = [{2,99000},{4,2475},{6,1238},{7,1238}],skill = []};

get_fairy_buy_node(1002,40) ->
	#fairy_buy_node_cfg{fairy_id = 1002,fairy_lv = 40,condition = [{lv,600}],type = 2,attr = [],skill = [{55010002,9}]};

get_fairy_buy_node(1002,41) ->
	#fairy_buy_node_cfg{fairy_id = 1002,fairy_lv = 41,condition = [{lv,610}],type = 1,attr = [{2,129000},{4,3225},{6,1613},{7,1613}],skill = []};

get_fairy_buy_node(1002,42) ->
	#fairy_buy_node_cfg{fairy_id = 1002,fairy_lv = 42,condition = [{lv,620}],type = 1,attr = [{2,129000},{4,3225},{6,1613},{7,1613}],skill = []};

get_fairy_buy_node(1002,43) ->
	#fairy_buy_node_cfg{fairy_id = 1002,fairy_lv = 43,condition = [{lv,630}],type = 1,attr = [{2,129000},{4,3225},{6,1613},{7,1613}],skill = []};

get_fairy_buy_node(1002,44) ->
	#fairy_buy_node_cfg{fairy_id = 1002,fairy_lv = 44,condition = [{lv,640}],type = 1,attr = [{2,129000},{4,3225},{6,1613},{7,1613}],skill = []};

get_fairy_buy_node(1002,45) ->
	#fairy_buy_node_cfg{fairy_id = 1002,fairy_lv = 45,condition = [{lv,650}],type = 2,attr = [],skill = [{55010002,10}]};

get_fairy_buy_node(1002,46) ->
	#fairy_buy_node_cfg{fairy_id = 1002,fairy_lv = 46,condition = [{lv,660}],type = 1,attr = [{2,196000},{4,4900},{6,2450},{7,2450}],skill = []};

get_fairy_buy_node(1002,47) ->
	#fairy_buy_node_cfg{fairy_id = 1002,fairy_lv = 47,condition = [{lv,670}],type = 1,attr = [{2,196000},{4,4900},{6,2450},{7,2450}],skill = []};

get_fairy_buy_node(1002,48) ->
	#fairy_buy_node_cfg{fairy_id = 1002,fairy_lv = 48,condition = [{lv,680}],type = 1,attr = [{2,196000},{4,4900},{6,2450},{7,2450}],skill = []};

get_fairy_buy_node(1002,49) ->
	#fairy_buy_node_cfg{fairy_id = 1002,fairy_lv = 49,condition = [{lv,690}],type = 1,attr = [{2,196000},{4,4900},{6,2450},{7,2450}],skill = []};

get_fairy_buy_node(1002,50) ->
	#fairy_buy_node_cfg{fairy_id = 1002,fairy_lv = 50,condition = [{lv,700}],type = 2,attr = [],skill = [{55010002,11}]};

get_fairy_buy_node(1003,1) ->
	#fairy_buy_node_cfg{fairy_id = 1003,fairy_lv = 1,condition = [{lv,210}],type = 1,attr = [{2,8000},{4,400},{6,200},{7,200}],skill = [{55010003,1}]};

get_fairy_buy_node(1003,2) ->
	#fairy_buy_node_cfg{fairy_id = 1003,fairy_lv = 2,condition = [{lv,220}],type = 1,attr = [{2,1333},{4,67},{6,33},{7,33}],skill = []};

get_fairy_buy_node(1003,3) ->
	#fairy_buy_node_cfg{fairy_id = 1003,fairy_lv = 3,condition = [{lv,230}],type = 1,attr = [{2,1333},{4,67},{6,33},{7,33}],skill = []};

get_fairy_buy_node(1003,4) ->
	#fairy_buy_node_cfg{fairy_id = 1003,fairy_lv = 4,condition = [{lv,240}],type = 1,attr = [{2,1333},{4,67},{6,33},{7,33}],skill = []};

get_fairy_buy_node(1003,5) ->
	#fairy_buy_node_cfg{fairy_id = 1003,fairy_lv = 5,condition = [{lv,250}],type = 2,attr = [],skill = [{55010003,2}]};

get_fairy_buy_node(1003,6) ->
	#fairy_buy_node_cfg{fairy_id = 1003,fairy_lv = 6,condition = [{lv,260}],type = 1,attr = [{2,3333},{4,167},{6,83},{7,83}],skill = []};

get_fairy_buy_node(1003,7) ->
	#fairy_buy_node_cfg{fairy_id = 1003,fairy_lv = 7,condition = [{lv,270}],type = 1,attr = [{2,3333},{4,167},{6,83},{7,83}],skill = []};

get_fairy_buy_node(1003,8) ->
	#fairy_buy_node_cfg{fairy_id = 1003,fairy_lv = 8,condition = [{lv,280}],type = 1,attr = [{2,3333},{4,167},{6,83},{7,83}],skill = []};

get_fairy_buy_node(1003,9) ->
	#fairy_buy_node_cfg{fairy_id = 1003,fairy_lv = 9,condition = [{lv,290}],type = 1,attr = [{2,3333},{4,167},{6,83},{7,83}],skill = []};

get_fairy_buy_node(1003,10) ->
	#fairy_buy_node_cfg{fairy_id = 1003,fairy_lv = 10,condition = [{lv,300}],type = 2,attr = [],skill = [{55010003,3}]};

get_fairy_buy_node(1003,11) ->
	#fairy_buy_node_cfg{fairy_id = 1003,fairy_lv = 11,condition = [{lv,310}],type = 1,attr = [{2,7333},{4,367},{6,183},{7,183}],skill = []};

get_fairy_buy_node(1003,12) ->
	#fairy_buy_node_cfg{fairy_id = 1003,fairy_lv = 12,condition = [{lv,320}],type = 1,attr = [{2,7333},{4,367},{6,183},{7,183}],skill = []};

get_fairy_buy_node(1003,13) ->
	#fairy_buy_node_cfg{fairy_id = 1003,fairy_lv = 13,condition = [{lv,330}],type = 1,attr = [{2,7333},{4,367},{6,183},{7,183}],skill = []};

get_fairy_buy_node(1003,14) ->
	#fairy_buy_node_cfg{fairy_id = 1003,fairy_lv = 14,condition = [{lv,340}],type = 1,attr = [{2,7333},{4,367},{6,183},{7,183}],skill = []};

get_fairy_buy_node(1003,15) ->
	#fairy_buy_node_cfg{fairy_id = 1003,fairy_lv = 15,condition = [{lv,350}],type = 2,attr = [],skill = [{55010003,4}]};

get_fairy_buy_node(1003,16) ->
	#fairy_buy_node_cfg{fairy_id = 1003,fairy_lv = 16,condition = [{lv,360}],type = 1,attr = [{2,14000},{4,700},{6,350},{7,350}],skill = []};

get_fairy_buy_node(1003,17) ->
	#fairy_buy_node_cfg{fairy_id = 1003,fairy_lv = 17,condition = [{lv,370}],type = 1,attr = [{2,14000},{4,700},{6,350},{7,350}],skill = []};

get_fairy_buy_node(1003,18) ->
	#fairy_buy_node_cfg{fairy_id = 1003,fairy_lv = 18,condition = [{lv,380}],type = 1,attr = [{2,14000},{4,700},{6,350},{7,350}],skill = []};

get_fairy_buy_node(1003,19) ->
	#fairy_buy_node_cfg{fairy_id = 1003,fairy_lv = 19,condition = [{lv,390}],type = 1,attr = [{2,14000},{4,700},{6,350},{7,350}],skill = []};

get_fairy_buy_node(1003,20) ->
	#fairy_buy_node_cfg{fairy_id = 1003,fairy_lv = 20,condition = [{lv,400}],type = 2,attr = [],skill = [{55010003,5}]};

get_fairy_buy_node(1003,21) ->
	#fairy_buy_node_cfg{fairy_id = 1003,fairy_lv = 21,condition = [{lv,410}],type = 1,attr = [{2,22667},{4,1133},{6,567},{7,567}],skill = []};

get_fairy_buy_node(1003,22) ->
	#fairy_buy_node_cfg{fairy_id = 1003,fairy_lv = 22,condition = [{lv,420}],type = 1,attr = [{2,22667},{4,1133},{6,567},{7,567}],skill = []};

get_fairy_buy_node(1003,23) ->
	#fairy_buy_node_cfg{fairy_id = 1003,fairy_lv = 23,condition = [{lv,430}],type = 1,attr = [{2,22667},{4,1133},{6,567},{7,567}],skill = []};

get_fairy_buy_node(1003,24) ->
	#fairy_buy_node_cfg{fairy_id = 1003,fairy_lv = 24,condition = [{lv,440}],type = 1,attr = [{2,22667},{4,1133},{6,567},{7,567}],skill = []};

get_fairy_buy_node(1003,25) ->
	#fairy_buy_node_cfg{fairy_id = 1003,fairy_lv = 25,condition = [{lv,450}],type = 2,attr = [],skill = [{55010003,6}]};

get_fairy_buy_node(1003,26) ->
	#fairy_buy_node_cfg{fairy_id = 1003,fairy_lv = 26,condition = [{lv,460}],type = 1,attr = [{2,36000},{4,1800},{6,900},{7,900}],skill = []};

get_fairy_buy_node(1003,27) ->
	#fairy_buy_node_cfg{fairy_id = 1003,fairy_lv = 27,condition = [{lv,470}],type = 1,attr = [{2,36000},{4,1800},{6,900},{7,900}],skill = []};

get_fairy_buy_node(1003,28) ->
	#fairy_buy_node_cfg{fairy_id = 1003,fairy_lv = 28,condition = [{lv,480}],type = 1,attr = [{2,36000},{4,1800},{6,900},{7,900}],skill = []};

get_fairy_buy_node(1003,29) ->
	#fairy_buy_node_cfg{fairy_id = 1003,fairy_lv = 29,condition = [{lv,490}],type = 1,attr = [{2,36000},{4,1800},{6,900},{7,900}],skill = []};

get_fairy_buy_node(1003,30) ->
	#fairy_buy_node_cfg{fairy_id = 1003,fairy_lv = 30,condition = [{lv,500}],type = 2,attr = [],skill = [{55010003,7}]};

get_fairy_buy_node(1003,31) ->
	#fairy_buy_node_cfg{fairy_id = 1003,fairy_lv = 31,condition = [{lv,510}],type = 1,attr = [{2,44667},{4,2233},{6,1117},{7,1117}],skill = []};

get_fairy_buy_node(1003,32) ->
	#fairy_buy_node_cfg{fairy_id = 1003,fairy_lv = 32,condition = [{lv,520}],type = 1,attr = [{2,44667},{4,2233},{6,1117},{7,1117}],skill = []};

get_fairy_buy_node(1003,33) ->
	#fairy_buy_node_cfg{fairy_id = 1003,fairy_lv = 33,condition = [{lv,530}],type = 1,attr = [{2,44667},{4,2233},{6,1117},{7,1117}],skill = []};

get_fairy_buy_node(1003,34) ->
	#fairy_buy_node_cfg{fairy_id = 1003,fairy_lv = 34,condition = [{lv,540}],type = 1,attr = [{2,44667},{4,2233},{6,1117},{7,1117}],skill = []};

get_fairy_buy_node(1003,35) ->
	#fairy_buy_node_cfg{fairy_id = 1003,fairy_lv = 35,condition = [{lv,550}],type = 2,attr = [],skill = [{55010003,8}]};

get_fairy_buy_node(1003,36) ->
	#fairy_buy_node_cfg{fairy_id = 1003,fairy_lv = 36,condition = [{lv,560}],type = 1,attr = [{2,66000},{4,3300},{6,1650},{7,1650}],skill = []};

get_fairy_buy_node(1003,37) ->
	#fairy_buy_node_cfg{fairy_id = 1003,fairy_lv = 37,condition = [{lv,570}],type = 1,attr = [{2,66000},{4,3300},{6,1650},{7,1650}],skill = []};

get_fairy_buy_node(1003,38) ->
	#fairy_buy_node_cfg{fairy_id = 1003,fairy_lv = 38,condition = [{lv,580}],type = 1,attr = [{2,66000},{4,3300},{6,1650},{7,1650}],skill = []};

get_fairy_buy_node(1003,39) ->
	#fairy_buy_node_cfg{fairy_id = 1003,fairy_lv = 39,condition = [{lv,590}],type = 1,attr = [{2,66000},{4,3300},{6,1650},{7,1650}],skill = []};

get_fairy_buy_node(1003,40) ->
	#fairy_buy_node_cfg{fairy_id = 1003,fairy_lv = 40,condition = [{lv,600}],type = 2,attr = [],skill = [{55010003,9}]};

get_fairy_buy_node(1003,41) ->
	#fairy_buy_node_cfg{fairy_id = 1003,fairy_lv = 41,condition = [{lv,610}],type = 1,attr = [{2,86000},{4,4300},{6,2150},{7,2150}],skill = []};

get_fairy_buy_node(1003,42) ->
	#fairy_buy_node_cfg{fairy_id = 1003,fairy_lv = 42,condition = [{lv,620}],type = 1,attr = [{2,86000},{4,4300},{6,2150},{7,2150}],skill = []};

get_fairy_buy_node(1003,43) ->
	#fairy_buy_node_cfg{fairy_id = 1003,fairy_lv = 43,condition = [{lv,630}],type = 1,attr = [{2,86000},{4,4300},{6,2150},{7,2150}],skill = []};

get_fairy_buy_node(1003,44) ->
	#fairy_buy_node_cfg{fairy_id = 1003,fairy_lv = 44,condition = [{lv,640}],type = 1,attr = [{2,86000},{4,4300},{6,2150},{7,2150}],skill = []};

get_fairy_buy_node(1003,45) ->
	#fairy_buy_node_cfg{fairy_id = 1003,fairy_lv = 45,condition = [{lv,650}],type = 2,attr = [],skill = [{55010003,10}]};

get_fairy_buy_node(1003,46) ->
	#fairy_buy_node_cfg{fairy_id = 1003,fairy_lv = 46,condition = [{lv,660}],type = 1,attr = [{2,130667},{4,6533},{6,3267},{7,3267}],skill = []};

get_fairy_buy_node(1003,47) ->
	#fairy_buy_node_cfg{fairy_id = 1003,fairy_lv = 47,condition = [{lv,670}],type = 1,attr = [{2,130667},{4,6533},{6,3267},{7,3267}],skill = []};

get_fairy_buy_node(1003,48) ->
	#fairy_buy_node_cfg{fairy_id = 1003,fairy_lv = 48,condition = [{lv,680}],type = 1,attr = [{2,130667},{4,6533},{6,3267},{7,3267}],skill = []};

get_fairy_buy_node(1003,49) ->
	#fairy_buy_node_cfg{fairy_id = 1003,fairy_lv = 49,condition = [{lv,690}],type = 1,attr = [{2,130667},{4,6533},{6,3267},{7,3267}],skill = []};

get_fairy_buy_node(1003,50) ->
	#fairy_buy_node_cfg{fairy_id = 1003,fairy_lv = 50,condition = [{lv,700}],type = 2,attr = [],skill = [{55010003,11}]};

get_fairy_buy_node(1004,1) ->
	#fairy_buy_node_cfg{fairy_id = 1004,fairy_lv = 1,condition = [{lv,210}],type = 1,attr = [{1,400},{3,400},{5,200},{7,200}],skill = [{55010004,1}]};

get_fairy_buy_node(1004,2) ->
	#fairy_buy_node_cfg{fairy_id = 1004,fairy_lv = 2,condition = [{lv,220}],type = 1,attr = [{1,67},{3,67},{5,33},{7,33}],skill = []};

get_fairy_buy_node(1004,3) ->
	#fairy_buy_node_cfg{fairy_id = 1004,fairy_lv = 3,condition = [{lv,230}],type = 1,attr = [{1,67},{3,67},{5,33},{7,33}],skill = []};

get_fairy_buy_node(1004,4) ->
	#fairy_buy_node_cfg{fairy_id = 1004,fairy_lv = 4,condition = [{lv,240}],type = 1,attr = [{1,67},{3,67},{5,33},{7,33}],skill = []};

get_fairy_buy_node(1004,5) ->
	#fairy_buy_node_cfg{fairy_id = 1004,fairy_lv = 5,condition = [{lv,250}],type = 2,attr = [],skill = [{55010004,2}]};

get_fairy_buy_node(1004,6) ->
	#fairy_buy_node_cfg{fairy_id = 1004,fairy_lv = 6,condition = [{lv,260}],type = 1,attr = [{1,167},{3,167},{5,83},{7,83}],skill = []};

get_fairy_buy_node(1004,7) ->
	#fairy_buy_node_cfg{fairy_id = 1004,fairy_lv = 7,condition = [{lv,270}],type = 1,attr = [{1,167},{3,167},{5,83},{7,83}],skill = []};

get_fairy_buy_node(1004,8) ->
	#fairy_buy_node_cfg{fairy_id = 1004,fairy_lv = 8,condition = [{lv,280}],type = 1,attr = [{1,167},{3,167},{5,83},{7,83}],skill = []};

get_fairy_buy_node(1004,9) ->
	#fairy_buy_node_cfg{fairy_id = 1004,fairy_lv = 9,condition = [{lv,290}],type = 1,attr = [{1,167},{3,167},{5,83},{7,83}],skill = []};

get_fairy_buy_node(1004,10) ->
	#fairy_buy_node_cfg{fairy_id = 1004,fairy_lv = 10,condition = [{lv,300}],type = 2,attr = [],skill = [{55010004,3}]};

get_fairy_buy_node(1004,11) ->
	#fairy_buy_node_cfg{fairy_id = 1004,fairy_lv = 11,condition = [{lv,310}],type = 1,attr = [{1,367},{3,367},{5,183},{7,183}],skill = []};

get_fairy_buy_node(1004,12) ->
	#fairy_buy_node_cfg{fairy_id = 1004,fairy_lv = 12,condition = [{lv,320}],type = 1,attr = [{1,367},{3,367},{5,183},{7,183}],skill = []};

get_fairy_buy_node(1004,13) ->
	#fairy_buy_node_cfg{fairy_id = 1004,fairy_lv = 13,condition = [{lv,330}],type = 1,attr = [{1,367},{3,367},{5,183},{7,183}],skill = []};

get_fairy_buy_node(1004,14) ->
	#fairy_buy_node_cfg{fairy_id = 1004,fairy_lv = 14,condition = [{lv,340}],type = 1,attr = [{1,367},{3,367},{5,183},{7,183}],skill = []};

get_fairy_buy_node(1004,15) ->
	#fairy_buy_node_cfg{fairy_id = 1004,fairy_lv = 15,condition = [{lv,350}],type = 2,attr = [],skill = [{55010004,4}]};

get_fairy_buy_node(1004,16) ->
	#fairy_buy_node_cfg{fairy_id = 1004,fairy_lv = 16,condition = [{lv,360}],type = 1,attr = [{1,700},{3,700},{5,350},{7,350}],skill = []};

get_fairy_buy_node(1004,17) ->
	#fairy_buy_node_cfg{fairy_id = 1004,fairy_lv = 17,condition = [{lv,370}],type = 1,attr = [{1,700},{3,700},{5,350},{7,350}],skill = []};

get_fairy_buy_node(1004,18) ->
	#fairy_buy_node_cfg{fairy_id = 1004,fairy_lv = 18,condition = [{lv,380}],type = 1,attr = [{1,700},{3,700},{5,350},{7,350}],skill = []};

get_fairy_buy_node(1004,19) ->
	#fairy_buy_node_cfg{fairy_id = 1004,fairy_lv = 19,condition = [{lv,390}],type = 1,attr = [{1,700},{3,700},{5,350},{7,350}],skill = []};

get_fairy_buy_node(1004,20) ->
	#fairy_buy_node_cfg{fairy_id = 1004,fairy_lv = 20,condition = [{lv,400}],type = 2,attr = [],skill = [{55010004,5}]};

get_fairy_buy_node(1004,21) ->
	#fairy_buy_node_cfg{fairy_id = 1004,fairy_lv = 21,condition = [{lv,410}],type = 1,attr = [{1,1133},{3,1133},{5,567},{7,567}],skill = []};

get_fairy_buy_node(1004,22) ->
	#fairy_buy_node_cfg{fairy_id = 1004,fairy_lv = 22,condition = [{lv,420}],type = 1,attr = [{1,1133},{3,1133},{5,567},{7,567}],skill = []};

get_fairy_buy_node(1004,23) ->
	#fairy_buy_node_cfg{fairy_id = 1004,fairy_lv = 23,condition = [{lv,430}],type = 1,attr = [{1,1133},{3,1133},{5,567},{7,567}],skill = []};

get_fairy_buy_node(1004,24) ->
	#fairy_buy_node_cfg{fairy_id = 1004,fairy_lv = 24,condition = [{lv,440}],type = 1,attr = [{1,1133},{3,1133},{5,567},{7,567}],skill = []};

get_fairy_buy_node(1004,25) ->
	#fairy_buy_node_cfg{fairy_id = 1004,fairy_lv = 25,condition = [{lv,450}],type = 2,attr = [],skill = [{55010004,6}]};

get_fairy_buy_node(1004,26) ->
	#fairy_buy_node_cfg{fairy_id = 1004,fairy_lv = 26,condition = [{lv,460}],type = 1,attr = [{1,1800},{3,1800},{5,900},{7,900}],skill = []};

get_fairy_buy_node(1004,27) ->
	#fairy_buy_node_cfg{fairy_id = 1004,fairy_lv = 27,condition = [{lv,470}],type = 1,attr = [{1,1800},{3,1800},{5,900},{7,900}],skill = []};

get_fairy_buy_node(1004,28) ->
	#fairy_buy_node_cfg{fairy_id = 1004,fairy_lv = 28,condition = [{lv,480}],type = 1,attr = [{1,1800},{3,1800},{5,900},{7,900}],skill = []};

get_fairy_buy_node(1004,29) ->
	#fairy_buy_node_cfg{fairy_id = 1004,fairy_lv = 29,condition = [{lv,490}],type = 1,attr = [{1,1800},{3,1800},{5,900},{7,900}],skill = []};

get_fairy_buy_node(1004,30) ->
	#fairy_buy_node_cfg{fairy_id = 1004,fairy_lv = 30,condition = [{lv,500}],type = 2,attr = [],skill = [{55010004,7}]};

get_fairy_buy_node(1004,31) ->
	#fairy_buy_node_cfg{fairy_id = 1004,fairy_lv = 31,condition = [{lv,510}],type = 1,attr = [{1,2233},{3,2233},{5,1117},{7,1117}],skill = []};

get_fairy_buy_node(1004,32) ->
	#fairy_buy_node_cfg{fairy_id = 1004,fairy_lv = 32,condition = [{lv,520}],type = 1,attr = [{1,2233},{3,2233},{5,1117},{7,1117}],skill = []};

get_fairy_buy_node(1004,33) ->
	#fairy_buy_node_cfg{fairy_id = 1004,fairy_lv = 33,condition = [{lv,530}],type = 1,attr = [{1,2233},{3,2233},{5,1117},{7,1117}],skill = []};

get_fairy_buy_node(1004,34) ->
	#fairy_buy_node_cfg{fairy_id = 1004,fairy_lv = 34,condition = [{lv,540}],type = 1,attr = [{1,2233},{3,2233},{5,1117},{7,1117}],skill = []};

get_fairy_buy_node(1004,35) ->
	#fairy_buy_node_cfg{fairy_id = 1004,fairy_lv = 35,condition = [{lv,550}],type = 2,attr = [],skill = [{55010004,8}]};

get_fairy_buy_node(1004,36) ->
	#fairy_buy_node_cfg{fairy_id = 1004,fairy_lv = 36,condition = [{lv,560}],type = 1,attr = [{1,3300},{3,3300},{5,1650},{7,1650}],skill = []};

get_fairy_buy_node(1004,37) ->
	#fairy_buy_node_cfg{fairy_id = 1004,fairy_lv = 37,condition = [{lv,570}],type = 1,attr = [{1,3300},{3,3300},{5,1650},{7,1650}],skill = []};

get_fairy_buy_node(1004,38) ->
	#fairy_buy_node_cfg{fairy_id = 1004,fairy_lv = 38,condition = [{lv,580}],type = 1,attr = [{1,3300},{3,3300},{5,1650},{7,1650}],skill = []};

get_fairy_buy_node(1004,39) ->
	#fairy_buy_node_cfg{fairy_id = 1004,fairy_lv = 39,condition = [{lv,590}],type = 1,attr = [{1,3300},{3,3300},{5,1650},{7,1650}],skill = []};

get_fairy_buy_node(1004,40) ->
	#fairy_buy_node_cfg{fairy_id = 1004,fairy_lv = 40,condition = [{lv,600}],type = 2,attr = [],skill = [{55010004,9}]};

get_fairy_buy_node(1004,41) ->
	#fairy_buy_node_cfg{fairy_id = 1004,fairy_lv = 41,condition = [{lv,610}],type = 1,attr = [{1,4300},{3,4300},{5,2150},{7,2150}],skill = []};

get_fairy_buy_node(1004,42) ->
	#fairy_buy_node_cfg{fairy_id = 1004,fairy_lv = 42,condition = [{lv,620}],type = 1,attr = [{1,4300},{3,4300},{5,2150},{7,2150}],skill = []};

get_fairy_buy_node(1004,43) ->
	#fairy_buy_node_cfg{fairy_id = 1004,fairy_lv = 43,condition = [{lv,630}],type = 1,attr = [{1,4300},{3,4300},{5,2150},{7,2150}],skill = []};

get_fairy_buy_node(1004,44) ->
	#fairy_buy_node_cfg{fairy_id = 1004,fairy_lv = 44,condition = [{lv,640}],type = 1,attr = [{1,4300},{3,4300},{5,2150},{7,2150}],skill = []};

get_fairy_buy_node(1004,45) ->
	#fairy_buy_node_cfg{fairy_id = 1004,fairy_lv = 45,condition = [{lv,650}],type = 2,attr = [],skill = [{55010004,10}]};

get_fairy_buy_node(1004,46) ->
	#fairy_buy_node_cfg{fairy_id = 1004,fairy_lv = 46,condition = [{lv,660}],type = 1,attr = [{1,6533},{3,6533},{5,3267},{7,3267}],skill = []};

get_fairy_buy_node(1004,47) ->
	#fairy_buy_node_cfg{fairy_id = 1004,fairy_lv = 47,condition = [{lv,670}],type = 1,attr = [{1,6533},{3,6533},{5,3267},{7,3267}],skill = []};

get_fairy_buy_node(1004,48) ->
	#fairy_buy_node_cfg{fairy_id = 1004,fairy_lv = 48,condition = [{lv,680}],type = 1,attr = [{1,6533},{3,6533},{5,3267},{7,3267}],skill = []};

get_fairy_buy_node(1004,49) ->
	#fairy_buy_node_cfg{fairy_id = 1004,fairy_lv = 49,condition = [{lv,690}],type = 1,attr = [{1,6533},{3,6533},{5,3267},{7,3267}],skill = []};

get_fairy_buy_node(1004,50) ->
	#fairy_buy_node_cfg{fairy_id = 1004,fairy_lv = 50,condition = [{lv,700}],type = 2,attr = [],skill = [{55010004,11}]};

get_fairy_buy_node(1005,1) ->
	#fairy_buy_node_cfg{fairy_id = 1005,fairy_lv = 1,condition = [{lv,210}],type = 1,attr = [{1,720},{2,14400},{3,360},{4,360}],skill = [{55010005,1}]};

get_fairy_buy_node(1005,2) ->
	#fairy_buy_node_cfg{fairy_id = 1005,fairy_lv = 2,condition = [{lv,220}],type = 1,attr = [{1,120},{2,2400},{3,60},{4,60}],skill = []};

get_fairy_buy_node(1005,3) ->
	#fairy_buy_node_cfg{fairy_id = 1005,fairy_lv = 3,condition = [{lv,230}],type = 1,attr = [{1,120},{2,2400},{3,60},{4,60}],skill = []};

get_fairy_buy_node(1005,4) ->
	#fairy_buy_node_cfg{fairy_id = 1005,fairy_lv = 4,condition = [{lv,240}],type = 1,attr = [{1,120},{2,2400},{3,60},{4,60}],skill = []};

get_fairy_buy_node(1005,5) ->
	#fairy_buy_node_cfg{fairy_id = 1005,fairy_lv = 5,condition = [{lv,250}],type = 2,attr = [],skill = [{55010005,2}]};

get_fairy_buy_node(1005,6) ->
	#fairy_buy_node_cfg{fairy_id = 1005,fairy_lv = 6,condition = [{lv,260}],type = 1,attr = [{1,300},{2,6000},{3,150},{4,150}],skill = []};

get_fairy_buy_node(1005,7) ->
	#fairy_buy_node_cfg{fairy_id = 1005,fairy_lv = 7,condition = [{lv,270}],type = 1,attr = [{1,300},{2,6000},{3,150},{4,150}],skill = []};

get_fairy_buy_node(1005,8) ->
	#fairy_buy_node_cfg{fairy_id = 1005,fairy_lv = 8,condition = [{lv,280}],type = 1,attr = [{1,300},{2,6000},{3,150},{4,150}],skill = []};

get_fairy_buy_node(1005,9) ->
	#fairy_buy_node_cfg{fairy_id = 1005,fairy_lv = 9,condition = [{lv,290}],type = 1,attr = [{1,300},{2,6000},{3,150},{4,150}],skill = []};

get_fairy_buy_node(1005,10) ->
	#fairy_buy_node_cfg{fairy_id = 1005,fairy_lv = 10,condition = [{lv,300}],type = 2,attr = [],skill = [{55010005,3}]};

get_fairy_buy_node(1005,11) ->
	#fairy_buy_node_cfg{fairy_id = 1005,fairy_lv = 11,condition = [{lv,310}],type = 1,attr = [{1,660},{2,13200},{3,330},{4,330}],skill = []};

get_fairy_buy_node(1005,12) ->
	#fairy_buy_node_cfg{fairy_id = 1005,fairy_lv = 12,condition = [{lv,320}],type = 1,attr = [{1,660},{2,13200},{3,330},{4,330}],skill = []};

get_fairy_buy_node(1005,13) ->
	#fairy_buy_node_cfg{fairy_id = 1005,fairy_lv = 13,condition = [{lv,330}],type = 1,attr = [{1,660},{2,13200},{3,330},{4,330}],skill = []};

get_fairy_buy_node(1005,14) ->
	#fairy_buy_node_cfg{fairy_id = 1005,fairy_lv = 14,condition = [{lv,340}],type = 1,attr = [{1,660},{2,13200},{3,330},{4,330}],skill = []};

get_fairy_buy_node(1005,15) ->
	#fairy_buy_node_cfg{fairy_id = 1005,fairy_lv = 15,condition = [{lv,350}],type = 2,attr = [],skill = [{55010005,4}]};

get_fairy_buy_node(1005,16) ->
	#fairy_buy_node_cfg{fairy_id = 1005,fairy_lv = 16,condition = [{lv,360}],type = 1,attr = [{1,1260},{2,25200},{3,630},{4,630}],skill = []};

get_fairy_buy_node(1005,17) ->
	#fairy_buy_node_cfg{fairy_id = 1005,fairy_lv = 17,condition = [{lv,370}],type = 1,attr = [{1,1260},{2,25200},{3,630},{4,630}],skill = []};

get_fairy_buy_node(1005,18) ->
	#fairy_buy_node_cfg{fairy_id = 1005,fairy_lv = 18,condition = [{lv,380}],type = 1,attr = [{1,1260},{2,25200},{3,630},{4,630}],skill = []};

get_fairy_buy_node(1005,19) ->
	#fairy_buy_node_cfg{fairy_id = 1005,fairy_lv = 19,condition = [{lv,390}],type = 1,attr = [{1,1260},{2,25200},{3,630},{4,630}],skill = []};

get_fairy_buy_node(1005,20) ->
	#fairy_buy_node_cfg{fairy_id = 1005,fairy_lv = 20,condition = [{lv,400}],type = 2,attr = [],skill = [{55010005,5}]};

get_fairy_buy_node(1005,21) ->
	#fairy_buy_node_cfg{fairy_id = 1005,fairy_lv = 21,condition = [{lv,410}],type = 1,attr = [{1,2040},{2,40800},{3,1020},{4,1020}],skill = []};

get_fairy_buy_node(1005,22) ->
	#fairy_buy_node_cfg{fairy_id = 1005,fairy_lv = 22,condition = [{lv,420}],type = 1,attr = [{1,2040},{2,40800},{3,1020},{4,1020}],skill = []};

get_fairy_buy_node(1005,23) ->
	#fairy_buy_node_cfg{fairy_id = 1005,fairy_lv = 23,condition = [{lv,430}],type = 1,attr = [{1,2040},{2,40800},{3,1020},{4,1020}],skill = []};

get_fairy_buy_node(1005,24) ->
	#fairy_buy_node_cfg{fairy_id = 1005,fairy_lv = 24,condition = [{lv,440}],type = 1,attr = [{1,2040},{2,40800},{3,1020},{4,1020}],skill = []};

get_fairy_buy_node(1005,25) ->
	#fairy_buy_node_cfg{fairy_id = 1005,fairy_lv = 25,condition = [{lv,450}],type = 2,attr = [],skill = [{55010005,6}]};

get_fairy_buy_node(1005,26) ->
	#fairy_buy_node_cfg{fairy_id = 1005,fairy_lv = 26,condition = [{lv,460}],type = 1,attr = [{1,3240},{2,64800},{3,1620},{4,1620}],skill = []};

get_fairy_buy_node(1005,27) ->
	#fairy_buy_node_cfg{fairy_id = 1005,fairy_lv = 27,condition = [{lv,470}],type = 1,attr = [{1,3240},{2,64800},{3,1620},{4,1620}],skill = []};

get_fairy_buy_node(1005,28) ->
	#fairy_buy_node_cfg{fairy_id = 1005,fairy_lv = 28,condition = [{lv,480}],type = 1,attr = [{1,3240},{2,64800},{3,1620},{4,1620}],skill = []};

get_fairy_buy_node(1005,29) ->
	#fairy_buy_node_cfg{fairy_id = 1005,fairy_lv = 29,condition = [{lv,490}],type = 1,attr = [{1,3240},{2,64800},{3,1620},{4,1620}],skill = []};

get_fairy_buy_node(1005,30) ->
	#fairy_buy_node_cfg{fairy_id = 1005,fairy_lv = 30,condition = [{lv,500}],type = 2,attr = [],skill = [{55010005,7}]};

get_fairy_buy_node(1005,31) ->
	#fairy_buy_node_cfg{fairy_id = 1005,fairy_lv = 31,condition = [{lv,510}],type = 1,attr = [{1,4033},{2,80667},{3,2017},{4,2017}],skill = []};

get_fairy_buy_node(1005,32) ->
	#fairy_buy_node_cfg{fairy_id = 1005,fairy_lv = 32,condition = [{lv,520}],type = 1,attr = [{1,4033},{2,80667},{3,2017},{4,2017}],skill = []};

get_fairy_buy_node(1005,33) ->
	#fairy_buy_node_cfg{fairy_id = 1005,fairy_lv = 33,condition = [{lv,530}],type = 1,attr = [{1,4033},{2,80667},{3,2017},{4,2017}],skill = []};

get_fairy_buy_node(1005,34) ->
	#fairy_buy_node_cfg{fairy_id = 1005,fairy_lv = 34,condition = [{lv,540}],type = 1,attr = [{1,4033},{2,80667},{3,2017},{4,2017}],skill = []};

get_fairy_buy_node(1005,35) ->
	#fairy_buy_node_cfg{fairy_id = 1005,fairy_lv = 35,condition = [{lv,550}],type = 2,attr = [],skill = [{55010005,8}]};

get_fairy_buy_node(1005,36) ->
	#fairy_buy_node_cfg{fairy_id = 1005,fairy_lv = 36,condition = [{lv,560}],type = 1,attr = [{1,5940},{2,118800},{3,2970},{4,2970}],skill = []};

get_fairy_buy_node(1005,37) ->
	#fairy_buy_node_cfg{fairy_id = 1005,fairy_lv = 37,condition = [{lv,570}],type = 1,attr = [{1,5940},{2,118800},{3,2970},{4,2970}],skill = []};

get_fairy_buy_node(1005,38) ->
	#fairy_buy_node_cfg{fairy_id = 1005,fairy_lv = 38,condition = [{lv,580}],type = 1,attr = [{1,5940},{2,118800},{3,2970},{4,2970}],skill = []};

get_fairy_buy_node(1005,39) ->
	#fairy_buy_node_cfg{fairy_id = 1005,fairy_lv = 39,condition = [{lv,590}],type = 1,attr = [{1,5940},{2,118800},{3,2970},{4,2970}],skill = []};

get_fairy_buy_node(1005,40) ->
	#fairy_buy_node_cfg{fairy_id = 1005,fairy_lv = 40,condition = [{lv,600}],type = 2,attr = [],skill = [{55010005,9}]};

get_fairy_buy_node(1005,41) ->
	#fairy_buy_node_cfg{fairy_id = 1005,fairy_lv = 41,condition = [{lv,610}],type = 1,attr = [{1,7740},{2,154800},{3,3870},{4,3870}],skill = []};

get_fairy_buy_node(1005,42) ->
	#fairy_buy_node_cfg{fairy_id = 1005,fairy_lv = 42,condition = [{lv,620}],type = 1,attr = [{1,7740},{2,154800},{3,3870},{4,3870}],skill = []};

get_fairy_buy_node(1005,43) ->
	#fairy_buy_node_cfg{fairy_id = 1005,fairy_lv = 43,condition = [{lv,630}],type = 1,attr = [{1,7740},{2,154800},{3,3870},{4,3870}],skill = []};

get_fairy_buy_node(1005,44) ->
	#fairy_buy_node_cfg{fairy_id = 1005,fairy_lv = 44,condition = [{lv,640}],type = 1,attr = [{1,7740},{2,154800},{3,3870},{4,3870}],skill = []};

get_fairy_buy_node(1005,45) ->
	#fairy_buy_node_cfg{fairy_id = 1005,fairy_lv = 45,condition = [{lv,650}],type = 2,attr = [],skill = [{55010005,10}]};

get_fairy_buy_node(1005,46) ->
	#fairy_buy_node_cfg{fairy_id = 1005,fairy_lv = 46,condition = [{lv,660}],type = 1,attr = [{1,11760},{2,235200},{3,5880},{4,5880}],skill = []};

get_fairy_buy_node(1005,47) ->
	#fairy_buy_node_cfg{fairy_id = 1005,fairy_lv = 47,condition = [{lv,670}],type = 1,attr = [{1,11760},{2,235200},{3,5880},{4,5880}],skill = []};

get_fairy_buy_node(1005,48) ->
	#fairy_buy_node_cfg{fairy_id = 1005,fairy_lv = 48,condition = [{lv,680}],type = 1,attr = [{1,11760},{2,235200},{3,5880},{4,5880}],skill = []};

get_fairy_buy_node(1005,49) ->
	#fairy_buy_node_cfg{fairy_id = 1005,fairy_lv = 49,condition = [{lv,690}],type = 1,attr = [{1,11760},{2,235200},{3,5880},{4,5880}],skill = []};

get_fairy_buy_node(1005,50) ->
	#fairy_buy_node_cfg{fairy_id = 1005,fairy_lv = 50,condition = [{lv,700}],type = 2,attr = [],skill = [{55010005,11}]};

get_fairy_buy_node(_Fairyid,_Fairylv) ->
	[].


get_all_node_by_id(1001) ->
[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50];


get_all_node_by_id(1002) ->
[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50];


get_all_node_by_id(1003) ->
[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50];


get_all_node_by_id(1004) ->
[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50];


get_all_node_by_id(1005) ->
[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50];

get_all_node_by_id(_Fairyid) ->
	[].

