%%%---------------------------------------
%%% module      : data_equip_awakening
%%% description : 装备觉醒配置
%%%
%%%---------------------------------------
-module(data_equip_awakening).
-compile(export_all).
-include("goods.hrl").




get_lv_lim(9) ->
1;


get_lv_lim(10) ->
2;


get_lv_lim(11) ->
3;


get_lv_lim(12) ->
4;


get_lv_lim(13) ->
5;


get_lv_lim(14) ->
6;


get_lv_lim(15) ->
7;


get_lv_lim(16) ->
8;

get_lv_lim(_Stage) ->
	0.

get_lv_cfg(1,0) ->
	#equip_awakening_lv_cfg{pos = 1,lv = 0,cost = [{0,38041200,35}],base_plus = 0,stren_plus = 0,suit_base_plus = 0,suit_extra_plus = 0};

get_lv_cfg(1,1) ->
	#equip_awakening_lv_cfg{pos = 1,lv = 1,cost = [{0,38041200,63}],base_plus = 800,stren_plus = 4000,suit_base_plus = 300,suit_extra_plus = 333};

get_lv_cfg(1,2) ->
	#equip_awakening_lv_cfg{pos = 1,lv = 2,cost = [{0,38041200,113},{0,38041210,1}],base_plus = 1600,stren_plus = 8000,suit_base_plus = 600,suit_extra_plus = 666};

get_lv_cfg(1,3) ->
	#equip_awakening_lv_cfg{pos = 1,lv = 3,cost = [{0,38041200,203},{0,38041210,2}],base_plus = 2400,stren_plus = 12000,suit_base_plus = 900,suit_extra_plus = 999};

get_lv_cfg(1,4) ->
	#equip_awakening_lv_cfg{pos = 1,lv = 4,cost = [{0,38041200,365},{0,38041210,4}],base_plus = 3200,stren_plus = 16000,suit_base_plus = 1200,suit_extra_plus = 1332};

get_lv_cfg(1,5) ->
	#equip_awakening_lv_cfg{pos = 1,lv = 5,cost = [{0,38041200,657},{0,38041210,7}],base_plus = 4000,stren_plus = 20000,suit_base_plus = 1500,suit_extra_plus = 1665};

get_lv_cfg(1,6) ->
	#equip_awakening_lv_cfg{pos = 1,lv = 6,cost = [{0,38041200,1183},{0,38041210,11}],base_plus = 4800,stren_plus = 24000,suit_base_plus = 1800,suit_extra_plus = 1998};

get_lv_cfg(1,7) ->
	#equip_awakening_lv_cfg{pos = 1,lv = 7,cost = [{0,38041200,2129},{0,38041210,16}],base_plus = 5600,stren_plus = 28000,suit_base_plus = 2100,suit_extra_plus = 2331};

get_lv_cfg(1,8) ->
	#equip_awakening_lv_cfg{pos = 1,lv = 8,cost = [],base_plus = 6400,stren_plus = 32000,suit_base_plus = 2400,suit_extra_plus = 2664};

get_lv_cfg(2,0) ->
	#equip_awakening_lv_cfg{pos = 2,lv = 0,cost = [{0,38041201,35}],base_plus = 0,stren_plus = 0,suit_base_plus = 0,suit_extra_plus = 0};

get_lv_cfg(2,1) ->
	#equip_awakening_lv_cfg{pos = 2,lv = 1,cost = [{0,38041201,63}],base_plus = 800,stren_plus = 4000,suit_base_plus = 300,suit_extra_plus = 333};

get_lv_cfg(2,2) ->
	#equip_awakening_lv_cfg{pos = 2,lv = 2,cost = [{0,38041201,113},{0,38041210,1}],base_plus = 1600,stren_plus = 8000,suit_base_plus = 600,suit_extra_plus = 666};

get_lv_cfg(2,3) ->
	#equip_awakening_lv_cfg{pos = 2,lv = 3,cost = [{0,38041201,203},{0,38041210,2}],base_plus = 2400,stren_plus = 12000,suit_base_plus = 900,suit_extra_plus = 999};

get_lv_cfg(2,4) ->
	#equip_awakening_lv_cfg{pos = 2,lv = 4,cost = [{0,38041201,365},{0,38041210,4}],base_plus = 3200,stren_plus = 16000,suit_base_plus = 1200,suit_extra_plus = 1332};

get_lv_cfg(2,5) ->
	#equip_awakening_lv_cfg{pos = 2,lv = 5,cost = [{0,38041201,657},{0,38041210,7}],base_plus = 4000,stren_plus = 20000,suit_base_plus = 1500,suit_extra_plus = 1665};

get_lv_cfg(2,6) ->
	#equip_awakening_lv_cfg{pos = 2,lv = 6,cost = [{0,38041201,1183},{0,38041210,11}],base_plus = 4800,stren_plus = 24000,suit_base_plus = 1800,suit_extra_plus = 1998};

get_lv_cfg(2,7) ->
	#equip_awakening_lv_cfg{pos = 2,lv = 7,cost = [{0,38041201,2129},{0,38041210,16}],base_plus = 5600,stren_plus = 28000,suit_base_plus = 2100,suit_extra_plus = 2331};

get_lv_cfg(2,8) ->
	#equip_awakening_lv_cfg{pos = 2,lv = 8,cost = [],base_plus = 6400,stren_plus = 32000,suit_base_plus = 2400,suit_extra_plus = 2664};

get_lv_cfg(3,0) ->
	#equip_awakening_lv_cfg{pos = 3,lv = 0,cost = [{0,38041206,35}],base_plus = 0,stren_plus = 0,suit_base_plus = 0,suit_extra_plus = 0};

get_lv_cfg(3,1) ->
	#equip_awakening_lv_cfg{pos = 3,lv = 1,cost = [{0,38041206,63}],base_plus = 800,stren_plus = 4000,suit_base_plus = 300,suit_extra_plus = 333};

get_lv_cfg(3,2) ->
	#equip_awakening_lv_cfg{pos = 3,lv = 2,cost = [{0,38041206,113},{0,38041210,1}],base_plus = 1600,stren_plus = 8000,suit_base_plus = 600,suit_extra_plus = 666};

get_lv_cfg(3,3) ->
	#equip_awakening_lv_cfg{pos = 3,lv = 3,cost = [{0,38041206,203},{0,38041210,2}],base_plus = 2400,stren_plus = 12000,suit_base_plus = 900,suit_extra_plus = 999};

get_lv_cfg(3,4) ->
	#equip_awakening_lv_cfg{pos = 3,lv = 4,cost = [{0,38041206,365},{0,38041210,4}],base_plus = 3200,stren_plus = 16000,suit_base_plus = 1200,suit_extra_plus = 1332};

get_lv_cfg(3,5) ->
	#equip_awakening_lv_cfg{pos = 3,lv = 5,cost = [{0,38041206,657},{0,38041210,7}],base_plus = 4000,stren_plus = 20000,suit_base_plus = 1500,suit_extra_plus = 1665};

get_lv_cfg(3,6) ->
	#equip_awakening_lv_cfg{pos = 3,lv = 6,cost = [{0,38041206,1183},{0,38041210,11}],base_plus = 4800,stren_plus = 24000,suit_base_plus = 1800,suit_extra_plus = 1998};

get_lv_cfg(3,7) ->
	#equip_awakening_lv_cfg{pos = 3,lv = 7,cost = [{0,38041206,2129},{0,38041210,16}],base_plus = 5600,stren_plus = 28000,suit_base_plus = 2100,suit_extra_plus = 2331};

get_lv_cfg(3,8) ->
	#equip_awakening_lv_cfg{pos = 3,lv = 8,cost = [],base_plus = 6400,stren_plus = 32000,suit_base_plus = 2400,suit_extra_plus = 2664};

get_lv_cfg(4,0) ->
	#equip_awakening_lv_cfg{pos = 4,lv = 0,cost = [{0,38041202,35}],base_plus = 0,stren_plus = 0,suit_base_plus = 0,suit_extra_plus = 0};

get_lv_cfg(4,1) ->
	#equip_awakening_lv_cfg{pos = 4,lv = 1,cost = [{0,38041202,63}],base_plus = 800,stren_plus = 4000,suit_base_plus = 300,suit_extra_plus = 333};

get_lv_cfg(4,2) ->
	#equip_awakening_lv_cfg{pos = 4,lv = 2,cost = [{0,38041202,113},{0,38041210,1}],base_plus = 1600,stren_plus = 8000,suit_base_plus = 600,suit_extra_plus = 666};

get_lv_cfg(4,3) ->
	#equip_awakening_lv_cfg{pos = 4,lv = 3,cost = [{0,38041202,203},{0,38041210,2}],base_plus = 2400,stren_plus = 12000,suit_base_plus = 900,suit_extra_plus = 999};

get_lv_cfg(4,4) ->
	#equip_awakening_lv_cfg{pos = 4,lv = 4,cost = [{0,38041202,365},{0,38041210,4}],base_plus = 3200,stren_plus = 16000,suit_base_plus = 1200,suit_extra_plus = 1332};

get_lv_cfg(4,5) ->
	#equip_awakening_lv_cfg{pos = 4,lv = 5,cost = [{0,38041202,657},{0,38041210,7}],base_plus = 4000,stren_plus = 20000,suit_base_plus = 1500,suit_extra_plus = 1665};

get_lv_cfg(4,6) ->
	#equip_awakening_lv_cfg{pos = 4,lv = 6,cost = [{0,38041202,1183},{0,38041210,11}],base_plus = 4800,stren_plus = 24000,suit_base_plus = 1800,suit_extra_plus = 1998};

get_lv_cfg(4,7) ->
	#equip_awakening_lv_cfg{pos = 4,lv = 7,cost = [{0,38041202,2129},{0,38041210,16}],base_plus = 5600,stren_plus = 28000,suit_base_plus = 2100,suit_extra_plus = 2331};

get_lv_cfg(4,8) ->
	#equip_awakening_lv_cfg{pos = 4,lv = 8,cost = [],base_plus = 6400,stren_plus = 32000,suit_base_plus = 2400,suit_extra_plus = 2664};

get_lv_cfg(5,0) ->
	#equip_awakening_lv_cfg{pos = 5,lv = 0,cost = [{0,38041207,35}],base_plus = 0,stren_plus = 0,suit_base_plus = 0,suit_extra_plus = 0};

get_lv_cfg(5,1) ->
	#equip_awakening_lv_cfg{pos = 5,lv = 1,cost = [{0,38041207,63}],base_plus = 800,stren_plus = 4000,suit_base_plus = 300,suit_extra_plus = 333};

get_lv_cfg(5,2) ->
	#equip_awakening_lv_cfg{pos = 5,lv = 2,cost = [{0,38041207,113},{0,38041210,1}],base_plus = 1600,stren_plus = 8000,suit_base_plus = 600,suit_extra_plus = 666};

get_lv_cfg(5,3) ->
	#equip_awakening_lv_cfg{pos = 5,lv = 3,cost = [{0,38041207,203},{0,38041210,2}],base_plus = 2400,stren_plus = 12000,suit_base_plus = 900,suit_extra_plus = 999};

get_lv_cfg(5,4) ->
	#equip_awakening_lv_cfg{pos = 5,lv = 4,cost = [{0,38041207,365},{0,38041210,4}],base_plus = 3200,stren_plus = 16000,suit_base_plus = 1200,suit_extra_plus = 1332};

get_lv_cfg(5,5) ->
	#equip_awakening_lv_cfg{pos = 5,lv = 5,cost = [{0,38041207,657},{0,38041210,7}],base_plus = 4000,stren_plus = 20000,suit_base_plus = 1500,suit_extra_plus = 1665};

get_lv_cfg(5,6) ->
	#equip_awakening_lv_cfg{pos = 5,lv = 6,cost = [{0,38041207,1183},{0,38041210,11}],base_plus = 4800,stren_plus = 24000,suit_base_plus = 1800,suit_extra_plus = 1998};

get_lv_cfg(5,7) ->
	#equip_awakening_lv_cfg{pos = 5,lv = 7,cost = [{0,38041207,2129},{0,38041210,16}],base_plus = 5600,stren_plus = 28000,suit_base_plus = 2100,suit_extra_plus = 2331};

get_lv_cfg(5,8) ->
	#equip_awakening_lv_cfg{pos = 5,lv = 8,cost = [],base_plus = 6400,stren_plus = 32000,suit_base_plus = 2400,suit_extra_plus = 2664};

get_lv_cfg(6,0) ->
	#equip_awakening_lv_cfg{pos = 6,lv = 0,cost = [{0,38041203,35}],base_plus = 0,stren_plus = 0,suit_base_plus = 0,suit_extra_plus = 0};

get_lv_cfg(6,1) ->
	#equip_awakening_lv_cfg{pos = 6,lv = 1,cost = [{0,38041203,63}],base_plus = 800,stren_plus = 4000,suit_base_plus = 300,suit_extra_plus = 333};

get_lv_cfg(6,2) ->
	#equip_awakening_lv_cfg{pos = 6,lv = 2,cost = [{0,38041203,113},{0,38041210,1}],base_plus = 1600,stren_plus = 8000,suit_base_plus = 600,suit_extra_plus = 666};

get_lv_cfg(6,3) ->
	#equip_awakening_lv_cfg{pos = 6,lv = 3,cost = [{0,38041203,203},{0,38041210,2}],base_plus = 2400,stren_plus = 12000,suit_base_plus = 900,suit_extra_plus = 999};

get_lv_cfg(6,4) ->
	#equip_awakening_lv_cfg{pos = 6,lv = 4,cost = [{0,38041203,365},{0,38041210,4}],base_plus = 3200,stren_plus = 16000,suit_base_plus = 1200,suit_extra_plus = 1332};

get_lv_cfg(6,5) ->
	#equip_awakening_lv_cfg{pos = 6,lv = 5,cost = [{0,38041203,657},{0,38041210,7}],base_plus = 4000,stren_plus = 20000,suit_base_plus = 1500,suit_extra_plus = 1665};

get_lv_cfg(6,6) ->
	#equip_awakening_lv_cfg{pos = 6,lv = 6,cost = [{0,38041203,1183},{0,38041210,11}],base_plus = 4800,stren_plus = 24000,suit_base_plus = 1800,suit_extra_plus = 1998};

get_lv_cfg(6,7) ->
	#equip_awakening_lv_cfg{pos = 6,lv = 7,cost = [{0,38041203,2129},{0,38041210,16}],base_plus = 5600,stren_plus = 28000,suit_base_plus = 2100,suit_extra_plus = 2331};

get_lv_cfg(6,8) ->
	#equip_awakening_lv_cfg{pos = 6,lv = 8,cost = [],base_plus = 6400,stren_plus = 32000,suit_base_plus = 2400,suit_extra_plus = 2664};

get_lv_cfg(7,0) ->
	#equip_awakening_lv_cfg{pos = 7,lv = 0,cost = [{0,38041209,35}],base_plus = 0,stren_plus = 0,suit_base_plus = 0,suit_extra_plus = 0};

get_lv_cfg(7,1) ->
	#equip_awakening_lv_cfg{pos = 7,lv = 1,cost = [{0,38041209,63}],base_plus = 800,stren_plus = 4000,suit_base_plus = 300,suit_extra_plus = 333};

get_lv_cfg(7,2) ->
	#equip_awakening_lv_cfg{pos = 7,lv = 2,cost = [{0,38041209,113},{0,38041210,1}],base_plus = 1600,stren_plus = 8000,suit_base_plus = 600,suit_extra_plus = 666};

get_lv_cfg(7,3) ->
	#equip_awakening_lv_cfg{pos = 7,lv = 3,cost = [{0,38041209,203},{0,38041210,2}],base_plus = 2400,stren_plus = 12000,suit_base_plus = 900,suit_extra_plus = 999};

get_lv_cfg(7,4) ->
	#equip_awakening_lv_cfg{pos = 7,lv = 4,cost = [{0,38041209,365},{0,38041210,4}],base_plus = 3200,stren_plus = 16000,suit_base_plus = 1200,suit_extra_plus = 1332};

get_lv_cfg(7,5) ->
	#equip_awakening_lv_cfg{pos = 7,lv = 5,cost = [{0,38041209,657},{0,38041210,7}],base_plus = 4000,stren_plus = 20000,suit_base_plus = 1500,suit_extra_plus = 1665};

get_lv_cfg(7,6) ->
	#equip_awakening_lv_cfg{pos = 7,lv = 6,cost = [{0,38041209,1183},{0,38041210,11}],base_plus = 4800,stren_plus = 24000,suit_base_plus = 1800,suit_extra_plus = 1998};

get_lv_cfg(7,7) ->
	#equip_awakening_lv_cfg{pos = 7,lv = 7,cost = [{0,38041209,2129},{0,38041210,16}],base_plus = 5600,stren_plus = 28000,suit_base_plus = 2100,suit_extra_plus = 2331};

get_lv_cfg(7,8) ->
	#equip_awakening_lv_cfg{pos = 7,lv = 8,cost = [],base_plus = 6400,stren_plus = 32000,suit_base_plus = 2400,suit_extra_plus = 2664};

get_lv_cfg(8,0) ->
	#equip_awakening_lv_cfg{pos = 8,lv = 0,cost = [{0,38041204,35}],base_plus = 0,stren_plus = 0,suit_base_plus = 0,suit_extra_plus = 0};

get_lv_cfg(8,1) ->
	#equip_awakening_lv_cfg{pos = 8,lv = 1,cost = [{0,38041204,63}],base_plus = 800,stren_plus = 4000,suit_base_plus = 300,suit_extra_plus = 333};

get_lv_cfg(8,2) ->
	#equip_awakening_lv_cfg{pos = 8,lv = 2,cost = [{0,38041204,113},{0,38041210,1}],base_plus = 1600,stren_plus = 8000,suit_base_plus = 600,suit_extra_plus = 666};

get_lv_cfg(8,3) ->
	#equip_awakening_lv_cfg{pos = 8,lv = 3,cost = [{0,38041204,203},{0,38041210,2}],base_plus = 2400,stren_plus = 12000,suit_base_plus = 900,suit_extra_plus = 999};

get_lv_cfg(8,4) ->
	#equip_awakening_lv_cfg{pos = 8,lv = 4,cost = [{0,38041204,365},{0,38041210,4}],base_plus = 3200,stren_plus = 16000,suit_base_plus = 1200,suit_extra_plus = 1332};

get_lv_cfg(8,5) ->
	#equip_awakening_lv_cfg{pos = 8,lv = 5,cost = [{0,38041204,657},{0,38041210,7}],base_plus = 4000,stren_plus = 20000,suit_base_plus = 1500,suit_extra_plus = 1665};

get_lv_cfg(8,6) ->
	#equip_awakening_lv_cfg{pos = 8,lv = 6,cost = [{0,38041204,1183},{0,38041210,11}],base_plus = 4800,stren_plus = 24000,suit_base_plus = 1800,suit_extra_plus = 1998};

get_lv_cfg(8,7) ->
	#equip_awakening_lv_cfg{pos = 8,lv = 7,cost = [{0,38041204,2129},{0,38041210,16}],base_plus = 5600,stren_plus = 28000,suit_base_plus = 2100,suit_extra_plus = 2331};

get_lv_cfg(8,8) ->
	#equip_awakening_lv_cfg{pos = 8,lv = 8,cost = [],base_plus = 6400,stren_plus = 32000,suit_base_plus = 2400,suit_extra_plus = 2664};

get_lv_cfg(9,0) ->
	#equip_awakening_lv_cfg{pos = 9,lv = 0,cost = [{0,38041208,35}],base_plus = 0,stren_plus = 0,suit_base_plus = 0,suit_extra_plus = 0};

get_lv_cfg(9,1) ->
	#equip_awakening_lv_cfg{pos = 9,lv = 1,cost = [{0,38041208,63}],base_plus = 800,stren_plus = 4000,suit_base_plus = 300,suit_extra_plus = 333};

get_lv_cfg(9,2) ->
	#equip_awakening_lv_cfg{pos = 9,lv = 2,cost = [{0,38041208,113},{0,38041210,1}],base_plus = 1600,stren_plus = 8000,suit_base_plus = 600,suit_extra_plus = 666};

get_lv_cfg(9,3) ->
	#equip_awakening_lv_cfg{pos = 9,lv = 3,cost = [{0,38041208,203},{0,38041210,2}],base_plus = 2400,stren_plus = 12000,suit_base_plus = 900,suit_extra_plus = 999};

get_lv_cfg(9,4) ->
	#equip_awakening_lv_cfg{pos = 9,lv = 4,cost = [{0,38041208,365},{0,38041210,4}],base_plus = 3200,stren_plus = 16000,suit_base_plus = 1200,suit_extra_plus = 1332};

get_lv_cfg(9,5) ->
	#equip_awakening_lv_cfg{pos = 9,lv = 5,cost = [{0,38041208,657},{0,38041210,7}],base_plus = 4000,stren_plus = 20000,suit_base_plus = 1500,suit_extra_plus = 1665};

get_lv_cfg(9,6) ->
	#equip_awakening_lv_cfg{pos = 9,lv = 6,cost = [{0,38041208,1183},{0,38041210,11}],base_plus = 4800,stren_plus = 24000,suit_base_plus = 1800,suit_extra_plus = 1998};

get_lv_cfg(9,7) ->
	#equip_awakening_lv_cfg{pos = 9,lv = 7,cost = [{0,38041208,2129},{0,38041210,16}],base_plus = 5600,stren_plus = 28000,suit_base_plus = 2100,suit_extra_plus = 2331};

get_lv_cfg(9,8) ->
	#equip_awakening_lv_cfg{pos = 9,lv = 8,cost = [],base_plus = 6400,stren_plus = 32000,suit_base_plus = 2400,suit_extra_plus = 2664};

get_lv_cfg(10,0) ->
	#equip_awakening_lv_cfg{pos = 10,lv = 0,cost = [{0,38041205,35}],base_plus = 0,stren_plus = 0,suit_base_plus = 0,suit_extra_plus = 0};

get_lv_cfg(10,1) ->
	#equip_awakening_lv_cfg{pos = 10,lv = 1,cost = [{0,38041205,63}],base_plus = 800,stren_plus = 4000,suit_base_plus = 300,suit_extra_plus = 333};

get_lv_cfg(10,2) ->
	#equip_awakening_lv_cfg{pos = 10,lv = 2,cost = [{0,38041205,113},{0,38041210,1}],base_plus = 1600,stren_plus = 8000,suit_base_plus = 600,suit_extra_plus = 666};

get_lv_cfg(10,3) ->
	#equip_awakening_lv_cfg{pos = 10,lv = 3,cost = [{0,38041205,203},{0,38041210,2}],base_plus = 2400,stren_plus = 12000,suit_base_plus = 900,suit_extra_plus = 999};

get_lv_cfg(10,4) ->
	#equip_awakening_lv_cfg{pos = 10,lv = 4,cost = [{0,38041205,365},{0,38041210,4}],base_plus = 3200,stren_plus = 16000,suit_base_plus = 1200,suit_extra_plus = 1332};

get_lv_cfg(10,5) ->
	#equip_awakening_lv_cfg{pos = 10,lv = 5,cost = [{0,38041205,657},{0,38041210,7}],base_plus = 4000,stren_plus = 20000,suit_base_plus = 1500,suit_extra_plus = 1665};

get_lv_cfg(10,6) ->
	#equip_awakening_lv_cfg{pos = 10,lv = 6,cost = [{0,38041205,1183},{0,38041210,11}],base_plus = 4800,stren_plus = 24000,suit_base_plus = 1800,suit_extra_plus = 1998};

get_lv_cfg(10,7) ->
	#equip_awakening_lv_cfg{pos = 10,lv = 7,cost = [{0,38041205,2129},{0,38041210,16}],base_plus = 5600,stren_plus = 28000,suit_base_plus = 2100,suit_extra_plus = 2331};

get_lv_cfg(10,8) ->
	#equip_awakening_lv_cfg{pos = 10,lv = 8,cost = [],base_plus = 6400,stren_plus = 32000,suit_base_plus = 2400,suit_extra_plus = 2664};

get_lv_cfg(_Pos,_Lv) ->
	[].


get_skill_list(1) ->
[23000001,23000002,23000009];


get_skill_list(2) ->
[23000005,23000008,23000010];


get_skill_list(3) ->
[23000001,23000004,23000007];


get_skill_list(4) ->
[23000003,23000000,23000010];


get_skill_list(5) ->
[23000004,23000002,23000009];


get_skill_list(6) ->
[23000000,23000005,23000010];


get_skill_list(7) ->
[23000001,23000002,23000006];


get_skill_list(8) ->
[23000003,23000000,23000008];


get_skill_list(9) ->
[23000004,23000006,23000007];


get_skill_list(10) ->
[23000003,23000005,23000008];

get_skill_list(_Pos) ->
	[].

get_skill_lv_cfg(23000000,1) ->
	#equip_skill_lv_cfg{skill_id = 23000000,lv = 1,cost = [{0,38041303,1}]};

get_skill_lv_cfg(23000000,2) ->
	#equip_skill_lv_cfg{skill_id = 23000000,lv = 2,cost = [{0,38041303,2}]};

get_skill_lv_cfg(23000000,3) ->
	#equip_skill_lv_cfg{skill_id = 23000000,lv = 3,cost = [{0,38041303,4}]};

get_skill_lv_cfg(23000000,4) ->
	#equip_skill_lv_cfg{skill_id = 23000000,lv = 4,cost = [{0,38041303,7}]};

get_skill_lv_cfg(23000000,5) ->
	#equip_skill_lv_cfg{skill_id = 23000000,lv = 5,cost = [{0,38041303,11}]};

get_skill_lv_cfg(23000001,1) ->
	#equip_skill_lv_cfg{skill_id = 23000001,lv = 1,cost = [{0,38041300,1}]};

get_skill_lv_cfg(23000001,2) ->
	#equip_skill_lv_cfg{skill_id = 23000001,lv = 2,cost = [{0,38041300,2}]};

get_skill_lv_cfg(23000001,3) ->
	#equip_skill_lv_cfg{skill_id = 23000001,lv = 3,cost = [{0,38041300,4}]};

get_skill_lv_cfg(23000001,4) ->
	#equip_skill_lv_cfg{skill_id = 23000001,lv = 4,cost = [{0,38041300,7}]};

get_skill_lv_cfg(23000001,5) ->
	#equip_skill_lv_cfg{skill_id = 23000001,lv = 5,cost = [{0,38041300,11}]};

get_skill_lv_cfg(23000002,1) ->
	#equip_skill_lv_cfg{skill_id = 23000002,lv = 1,cost = [{0,38041304,1}]};

get_skill_lv_cfg(23000002,2) ->
	#equip_skill_lv_cfg{skill_id = 23000002,lv = 2,cost = [{0,38041304,2}]};

get_skill_lv_cfg(23000002,3) ->
	#equip_skill_lv_cfg{skill_id = 23000002,lv = 3,cost = [{0,38041304,4}]};

get_skill_lv_cfg(23000002,4) ->
	#equip_skill_lv_cfg{skill_id = 23000002,lv = 4,cost = [{0,38041304,7}]};

get_skill_lv_cfg(23000002,5) ->
	#equip_skill_lv_cfg{skill_id = 23000002,lv = 5,cost = [{0,38041304,11}]};

get_skill_lv_cfg(23000003,1) ->
	#equip_skill_lv_cfg{skill_id = 23000003,lv = 1,cost = [{0,38041301,1}]};

get_skill_lv_cfg(23000003,2) ->
	#equip_skill_lv_cfg{skill_id = 23000003,lv = 2,cost = [{0,38041301,2}]};

get_skill_lv_cfg(23000003,3) ->
	#equip_skill_lv_cfg{skill_id = 23000003,lv = 3,cost = [{0,38041301,4}]};

get_skill_lv_cfg(23000003,4) ->
	#equip_skill_lv_cfg{skill_id = 23000003,lv = 4,cost = [{0,38041301,7}]};

get_skill_lv_cfg(23000003,5) ->
	#equip_skill_lv_cfg{skill_id = 23000003,lv = 5,cost = [{0,38041301,11}]};

get_skill_lv_cfg(23000004,1) ->
	#equip_skill_lv_cfg{skill_id = 23000004,lv = 1,cost = [{0,38041302,1}]};

get_skill_lv_cfg(23000004,2) ->
	#equip_skill_lv_cfg{skill_id = 23000004,lv = 2,cost = [{0,38041302,2}]};

get_skill_lv_cfg(23000004,3) ->
	#equip_skill_lv_cfg{skill_id = 23000004,lv = 3,cost = [{0,38041302,4}]};

get_skill_lv_cfg(23000004,4) ->
	#equip_skill_lv_cfg{skill_id = 23000004,lv = 4,cost = [{0,38041302,7}]};

get_skill_lv_cfg(23000004,5) ->
	#equip_skill_lv_cfg{skill_id = 23000004,lv = 5,cost = [{0,38041302,11}]};

get_skill_lv_cfg(23000005,1) ->
	#equip_skill_lv_cfg{skill_id = 23000005,lv = 1,cost = [{0,38041305,1}]};

get_skill_lv_cfg(23000005,2) ->
	#equip_skill_lv_cfg{skill_id = 23000005,lv = 2,cost = [{0,38041305,2}]};

get_skill_lv_cfg(23000005,3) ->
	#equip_skill_lv_cfg{skill_id = 23000005,lv = 3,cost = [{0,38041305,4}]};

get_skill_lv_cfg(23000005,4) ->
	#equip_skill_lv_cfg{skill_id = 23000005,lv = 4,cost = [{0,38041305,7}]};

get_skill_lv_cfg(23000005,5) ->
	#equip_skill_lv_cfg{skill_id = 23000005,lv = 5,cost = [{0,38041305,11}]};

get_skill_lv_cfg(23000006,1) ->
	#equip_skill_lv_cfg{skill_id = 23000006,lv = 1,cost = [{0,38041306,1}]};

get_skill_lv_cfg(23000006,2) ->
	#equip_skill_lv_cfg{skill_id = 23000006,lv = 2,cost = [{0,38041306,2}]};

get_skill_lv_cfg(23000006,3) ->
	#equip_skill_lv_cfg{skill_id = 23000006,lv = 3,cost = [{0,38041306,4}]};

get_skill_lv_cfg(23000006,4) ->
	#equip_skill_lv_cfg{skill_id = 23000006,lv = 4,cost = [{0,38041306,7}]};

get_skill_lv_cfg(23000006,5) ->
	#equip_skill_lv_cfg{skill_id = 23000006,lv = 5,cost = [{0,38041306,11}]};

get_skill_lv_cfg(23000007,1) ->
	#equip_skill_lv_cfg{skill_id = 23000007,lv = 1,cost = [{0,38041307,1}]};

get_skill_lv_cfg(23000007,2) ->
	#equip_skill_lv_cfg{skill_id = 23000007,lv = 2,cost = [{0,38041307,2}]};

get_skill_lv_cfg(23000007,3) ->
	#equip_skill_lv_cfg{skill_id = 23000007,lv = 3,cost = [{0,38041307,4}]};

get_skill_lv_cfg(23000007,4) ->
	#equip_skill_lv_cfg{skill_id = 23000007,lv = 4,cost = [{0,38041307,7}]};

get_skill_lv_cfg(23000007,5) ->
	#equip_skill_lv_cfg{skill_id = 23000007,lv = 5,cost = [{0,38041307,11}]};

get_skill_lv_cfg(23000008,1) ->
	#equip_skill_lv_cfg{skill_id = 23000008,lv = 1,cost = [{0,38041308,1}]};

get_skill_lv_cfg(23000008,2) ->
	#equip_skill_lv_cfg{skill_id = 23000008,lv = 2,cost = [{0,38041308,2}]};

get_skill_lv_cfg(23000008,3) ->
	#equip_skill_lv_cfg{skill_id = 23000008,lv = 3,cost = [{0,38041308,4}]};

get_skill_lv_cfg(23000008,4) ->
	#equip_skill_lv_cfg{skill_id = 23000008,lv = 4,cost = [{0,38041308,7}]};

get_skill_lv_cfg(23000008,5) ->
	#equip_skill_lv_cfg{skill_id = 23000008,lv = 5,cost = [{0,38041308,11}]};

get_skill_lv_cfg(23000009,1) ->
	#equip_skill_lv_cfg{skill_id = 23000009,lv = 1,cost = [{0,38041309,1}]};

get_skill_lv_cfg(23000009,2) ->
	#equip_skill_lv_cfg{skill_id = 23000009,lv = 2,cost = [{0,38041309,2}]};

get_skill_lv_cfg(23000009,3) ->
	#equip_skill_lv_cfg{skill_id = 23000009,lv = 3,cost = [{0,38041309,4}]};

get_skill_lv_cfg(23000009,4) ->
	#equip_skill_lv_cfg{skill_id = 23000009,lv = 4,cost = [{0,38041309,7}]};

get_skill_lv_cfg(23000009,5) ->
	#equip_skill_lv_cfg{skill_id = 23000009,lv = 5,cost = [{0,38041309,11}]};

get_skill_lv_cfg(23000010,1) ->
	#equip_skill_lv_cfg{skill_id = 23000010,lv = 1,cost = [{0,38041310,1}]};

get_skill_lv_cfg(23000010,2) ->
	#equip_skill_lv_cfg{skill_id = 23000010,lv = 2,cost = [{0,38041310,2}]};

get_skill_lv_cfg(23000010,3) ->
	#equip_skill_lv_cfg{skill_id = 23000010,lv = 3,cost = [{0,38041310,4}]};

get_skill_lv_cfg(23000010,4) ->
	#equip_skill_lv_cfg{skill_id = 23000010,lv = 4,cost = [{0,38041310,7}]};

get_skill_lv_cfg(23000010,5) ->
	#equip_skill_lv_cfg{skill_id = 23000010,lv = 5,cost = [{0,38041310,11}]};

get_skill_lv_cfg(_Skillid,_Lv) ->
	[].

