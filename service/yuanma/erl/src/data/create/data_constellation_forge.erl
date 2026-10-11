%%%---------------------------------------
%%% module      : data_constellation_forge
%%% description : 星宿锻造配置
%%%
%%%---------------------------------------
-module(data_constellation_forge).
-compile(export_all).
-include("constellation_forge.hrl").



get_strength_cfg(1,1,0) ->
	#base_constellation_strength{equip_type = 1,pos = 1,lv = 0,cost = [{0,38040070,1}],attr = [{1,0},{3,0}],special_attr = []};

get_strength_cfg(1,1,1) ->
	#base_constellation_strength{equip_type = 1,pos = 1,lv = 1,cost = [{0,38040070,2}],attr = [{1,160},{3,96}],special_attr = []};

get_strength_cfg(1,1,2) ->
	#base_constellation_strength{equip_type = 1,pos = 1,lv = 2,cost = [{0,38040070,3}],attr = [{1,320},{3,192}],special_attr = []};

get_strength_cfg(1,1,3) ->
	#base_constellation_strength{equip_type = 1,pos = 1,lv = 3,cost = [{0,38040070,4}],attr = [{1,480},{3,288}],special_attr = []};

get_strength_cfg(1,1,4) ->
	#base_constellation_strength{equip_type = 1,pos = 1,lv = 4,cost = [{0,38040070,5}],attr = [{1,640},{3,384}],special_attr = []};

get_strength_cfg(1,1,5) ->
	#base_constellation_strength{equip_type = 1,pos = 1,lv = 5,cost = [{0,38040070,6},{0,38040071,1}],attr = [{1,800},{3,480}],special_attr = []};

get_strength_cfg(1,1,6) ->
	#base_constellation_strength{equip_type = 1,pos = 1,lv = 6,cost = [{0,38040070,7},{0,38040071,2}],attr = [{1,960},{3,576}],special_attr = []};

get_strength_cfg(1,1,7) ->
	#base_constellation_strength{equip_type = 1,pos = 1,lv = 7,cost = [{0,38040070,8},{0,38040071,3}],attr = [{1,1120},{3,672}],special_attr = []};

get_strength_cfg(1,1,8) ->
	#base_constellation_strength{equip_type = 1,pos = 1,lv = 8,cost = [{0,38040070,10},{0,38040071,4}],attr = [{1,1280},{3,768}],special_attr = []};

get_strength_cfg(1,1,9) ->
	#base_constellation_strength{equip_type = 1,pos = 1,lv = 9,cost = [{0,38040070,12},{0,38040071,5}],attr = [{1,1440},{3,864}],special_attr = []};

get_strength_cfg(1,1,10) ->
	#base_constellation_strength{equip_type = 1,pos = 1,lv = 10,cost = [{0,38040070,14},{0,38040071,6}],attr = [{1,1600},{3,960}],special_attr = []};

get_strength_cfg(1,1,11) ->
	#base_constellation_strength{equip_type = 1,pos = 1,lv = 11,cost = [],attr = [{1,1760},{3,1056}],special_attr = []};

get_strength_cfg(1,2,0) ->
	#base_constellation_strength{equip_type = 1,pos = 2,lv = 0,cost = [{0,38040070,1}],attr = [{2,0},{4,0}],special_attr = []};

get_strength_cfg(1,2,1) ->
	#base_constellation_strength{equip_type = 1,pos = 2,lv = 1,cost = [{0,38040070,2}],attr = [{2,3200},{4,96}],special_attr = []};

get_strength_cfg(1,2,2) ->
	#base_constellation_strength{equip_type = 1,pos = 2,lv = 2,cost = [{0,38040070,3}],attr = [{2,6400},{4,192}],special_attr = []};

get_strength_cfg(1,2,3) ->
	#base_constellation_strength{equip_type = 1,pos = 2,lv = 3,cost = [{0,38040070,4}],attr = [{2,9600},{4,288}],special_attr = []};

get_strength_cfg(1,2,4) ->
	#base_constellation_strength{equip_type = 1,pos = 2,lv = 4,cost = [{0,38040070,5}],attr = [{2,12800},{4,384}],special_attr = []};

get_strength_cfg(1,2,5) ->
	#base_constellation_strength{equip_type = 1,pos = 2,lv = 5,cost = [{0,38040070,6},{0,38040071,1}],attr = [{2,16000},{4,480}],special_attr = []};

get_strength_cfg(1,2,6) ->
	#base_constellation_strength{equip_type = 1,pos = 2,lv = 6,cost = [{0,38040070,7},{0,38040071,2}],attr = [{2,19200},{4,576}],special_attr = []};

get_strength_cfg(1,2,7) ->
	#base_constellation_strength{equip_type = 1,pos = 2,lv = 7,cost = [{0,38040070,8},{0,38040071,3}],attr = [{2,22400},{4,672}],special_attr = []};

get_strength_cfg(1,2,8) ->
	#base_constellation_strength{equip_type = 1,pos = 2,lv = 8,cost = [{0,38040070,10},{0,38040071,4}],attr = [{2,25600},{4,768}],special_attr = []};

get_strength_cfg(1,2,9) ->
	#base_constellation_strength{equip_type = 1,pos = 2,lv = 9,cost = [{0,38040070,12},{0,38040071,5}],attr = [{2,28800},{4,864}],special_attr = []};

get_strength_cfg(1,2,10) ->
	#base_constellation_strength{equip_type = 1,pos = 2,lv = 10,cost = [{0,38040070,14},{0,38040071,6}],attr = [{2,32000},{4,960}],special_attr = []};

get_strength_cfg(1,2,11) ->
	#base_constellation_strength{equip_type = 1,pos = 2,lv = 11,cost = [],attr = [{2,35200},{4,1056}],special_attr = []};

get_strength_cfg(1,3,0) ->
	#base_constellation_strength{equip_type = 1,pos = 3,lv = 0,cost = [{0,38040070,1}],attr = [{2,0},{4,0}],special_attr = []};

get_strength_cfg(1,3,1) ->
	#base_constellation_strength{equip_type = 1,pos = 3,lv = 1,cost = [{0,38040070,2}],attr = [{2,3200},{4,96}],special_attr = []};

get_strength_cfg(1,3,2) ->
	#base_constellation_strength{equip_type = 1,pos = 3,lv = 2,cost = [{0,38040070,3}],attr = [{2,6400},{4,192}],special_attr = []};

get_strength_cfg(1,3,3) ->
	#base_constellation_strength{equip_type = 1,pos = 3,lv = 3,cost = [{0,38040070,4}],attr = [{2,9600},{4,288}],special_attr = []};

get_strength_cfg(1,3,4) ->
	#base_constellation_strength{equip_type = 1,pos = 3,lv = 4,cost = [{0,38040070,5}],attr = [{2,12800},{4,384}],special_attr = []};

get_strength_cfg(1,3,5) ->
	#base_constellation_strength{equip_type = 1,pos = 3,lv = 5,cost = [{0,38040070,6},{0,38040071,1}],attr = [{2,16000},{4,480}],special_attr = []};

get_strength_cfg(1,3,6) ->
	#base_constellation_strength{equip_type = 1,pos = 3,lv = 6,cost = [{0,38040070,7},{0,38040071,2}],attr = [{2,19200},{4,576}],special_attr = []};

get_strength_cfg(1,3,7) ->
	#base_constellation_strength{equip_type = 1,pos = 3,lv = 7,cost = [{0,38040070,8},{0,38040071,3}],attr = [{2,22400},{4,672}],special_attr = []};

get_strength_cfg(1,3,8) ->
	#base_constellation_strength{equip_type = 1,pos = 3,lv = 8,cost = [{0,38040070,10},{0,38040071,4}],attr = [{2,25600},{4,768}],special_attr = []};

get_strength_cfg(1,3,9) ->
	#base_constellation_strength{equip_type = 1,pos = 3,lv = 9,cost = [{0,38040070,12},{0,38040071,5}],attr = [{2,28800},{4,864}],special_attr = []};

get_strength_cfg(1,3,10) ->
	#base_constellation_strength{equip_type = 1,pos = 3,lv = 10,cost = [{0,38040070,14},{0,38040071,6}],attr = [{2,32000},{4,960}],special_attr = []};

get_strength_cfg(1,3,11) ->
	#base_constellation_strength{equip_type = 1,pos = 3,lv = 11,cost = [],attr = [{2,35200},{4,1056}],special_attr = []};

get_strength_cfg(1,4,0) ->
	#base_constellation_strength{equip_type = 1,pos = 4,lv = 0,cost = [{0,38040070,1}],attr = [{2,0},{4,0}],special_attr = []};

get_strength_cfg(1,4,1) ->
	#base_constellation_strength{equip_type = 1,pos = 4,lv = 1,cost = [{0,38040070,2}],attr = [{2,3200},{4,96}],special_attr = []};

get_strength_cfg(1,4,2) ->
	#base_constellation_strength{equip_type = 1,pos = 4,lv = 2,cost = [{0,38040070,3}],attr = [{2,6400},{4,192}],special_attr = []};

get_strength_cfg(1,4,3) ->
	#base_constellation_strength{equip_type = 1,pos = 4,lv = 3,cost = [{0,38040070,4}],attr = [{2,9600},{4,288}],special_attr = []};

get_strength_cfg(1,4,4) ->
	#base_constellation_strength{equip_type = 1,pos = 4,lv = 4,cost = [{0,38040070,5}],attr = [{2,12800},{4,384}],special_attr = []};

get_strength_cfg(1,4,5) ->
	#base_constellation_strength{equip_type = 1,pos = 4,lv = 5,cost = [{0,38040070,6},{0,38040071,1}],attr = [{2,16000},{4,480}],special_attr = []};

get_strength_cfg(1,4,6) ->
	#base_constellation_strength{equip_type = 1,pos = 4,lv = 6,cost = [{0,38040070,7},{0,38040071,2}],attr = [{2,19200},{4,576}],special_attr = []};

get_strength_cfg(1,4,7) ->
	#base_constellation_strength{equip_type = 1,pos = 4,lv = 7,cost = [{0,38040070,8},{0,38040071,3}],attr = [{2,22400},{4,672}],special_attr = []};

get_strength_cfg(1,4,8) ->
	#base_constellation_strength{equip_type = 1,pos = 4,lv = 8,cost = [{0,38040070,10},{0,38040071,4}],attr = [{2,25600},{4,768}],special_attr = []};

get_strength_cfg(1,4,9) ->
	#base_constellation_strength{equip_type = 1,pos = 4,lv = 9,cost = [{0,38040070,12},{0,38040071,5}],attr = [{2,28800},{4,864}],special_attr = []};

get_strength_cfg(1,4,10) ->
	#base_constellation_strength{equip_type = 1,pos = 4,lv = 10,cost = [{0,38040070,14},{0,38040071,6}],attr = [{2,32000},{4,960}],special_attr = []};

get_strength_cfg(1,4,11) ->
	#base_constellation_strength{equip_type = 1,pos = 4,lv = 11,cost = [],attr = [{2,35200},{4,1056}],special_attr = []};

get_strength_cfg(1,5,0) ->
	#base_constellation_strength{equip_type = 1,pos = 5,lv = 0,cost = [{0,38040070,1}],attr = [{1,0},{3,0}],special_attr = []};

get_strength_cfg(1,5,1) ->
	#base_constellation_strength{equip_type = 1,pos = 5,lv = 1,cost = [{0,38040070,2}],attr = [{1,160},{3,96}],special_attr = []};

get_strength_cfg(1,5,2) ->
	#base_constellation_strength{equip_type = 1,pos = 5,lv = 2,cost = [{0,38040070,3}],attr = [{1,320},{3,192}],special_attr = []};

get_strength_cfg(1,5,3) ->
	#base_constellation_strength{equip_type = 1,pos = 5,lv = 3,cost = [{0,38040070,4}],attr = [{1,480},{3,288}],special_attr = []};

get_strength_cfg(1,5,4) ->
	#base_constellation_strength{equip_type = 1,pos = 5,lv = 4,cost = [{0,38040070,5}],attr = [{1,640},{3,384}],special_attr = []};

get_strength_cfg(1,5,5) ->
	#base_constellation_strength{equip_type = 1,pos = 5,lv = 5,cost = [{0,38040070,6},{0,38040071,1}],attr = [{1,800},{3,480}],special_attr = []};

get_strength_cfg(1,5,6) ->
	#base_constellation_strength{equip_type = 1,pos = 5,lv = 6,cost = [{0,38040070,7},{0,38040071,2}],attr = [{1,960},{3,576}],special_attr = []};

get_strength_cfg(1,5,7) ->
	#base_constellation_strength{equip_type = 1,pos = 5,lv = 7,cost = [{0,38040070,8},{0,38040071,3}],attr = [{1,1120},{3,672}],special_attr = []};

get_strength_cfg(1,5,8) ->
	#base_constellation_strength{equip_type = 1,pos = 5,lv = 8,cost = [{0,38040070,10},{0,38040071,4}],attr = [{1,1280},{3,768}],special_attr = []};

get_strength_cfg(1,5,9) ->
	#base_constellation_strength{equip_type = 1,pos = 5,lv = 9,cost = [{0,38040070,12},{0,38040071,5}],attr = [{1,1440},{3,864}],special_attr = []};

get_strength_cfg(1,5,10) ->
	#base_constellation_strength{equip_type = 1,pos = 5,lv = 10,cost = [{0,38040070,14},{0,38040071,6}],attr = [{1,1600},{3,960}],special_attr = []};

get_strength_cfg(1,5,11) ->
	#base_constellation_strength{equip_type = 1,pos = 5,lv = 11,cost = [],attr = [{1,1760},{3,1056}],special_attr = []};

get_strength_cfg(1,6,0) ->
	#base_constellation_strength{equip_type = 1,pos = 6,lv = 0,cost = [{0,38040070,1}],attr = [{2,0},{4,0}],special_attr = []};

get_strength_cfg(1,6,1) ->
	#base_constellation_strength{equip_type = 1,pos = 6,lv = 1,cost = [{0,38040070,2}],attr = [{2,3200},{4,96}],special_attr = []};

get_strength_cfg(1,6,2) ->
	#base_constellation_strength{equip_type = 1,pos = 6,lv = 2,cost = [{0,38040070,3}],attr = [{2,6400},{4,192}],special_attr = []};

get_strength_cfg(1,6,3) ->
	#base_constellation_strength{equip_type = 1,pos = 6,lv = 3,cost = [{0,38040070,4}],attr = [{2,9600},{4,288}],special_attr = []};

get_strength_cfg(1,6,4) ->
	#base_constellation_strength{equip_type = 1,pos = 6,lv = 4,cost = [{0,38040070,5}],attr = [{2,12800},{4,384}],special_attr = []};

get_strength_cfg(1,6,5) ->
	#base_constellation_strength{equip_type = 1,pos = 6,lv = 5,cost = [{0,38040070,6},{0,38040071,1}],attr = [{2,16000},{4,480}],special_attr = []};

get_strength_cfg(1,6,6) ->
	#base_constellation_strength{equip_type = 1,pos = 6,lv = 6,cost = [{0,38040070,7},{0,38040071,2}],attr = [{2,19200},{4,576}],special_attr = []};

get_strength_cfg(1,6,7) ->
	#base_constellation_strength{equip_type = 1,pos = 6,lv = 7,cost = [{0,38040070,8},{0,38040071,3}],attr = [{2,22400},{4,672}],special_attr = []};

get_strength_cfg(1,6,8) ->
	#base_constellation_strength{equip_type = 1,pos = 6,lv = 8,cost = [{0,38040070,10},{0,38040071,4}],attr = [{2,25600},{4,768}],special_attr = []};

get_strength_cfg(1,6,9) ->
	#base_constellation_strength{equip_type = 1,pos = 6,lv = 9,cost = [{0,38040070,12},{0,38040071,5}],attr = [{2,28800},{4,864}],special_attr = []};

get_strength_cfg(1,6,10) ->
	#base_constellation_strength{equip_type = 1,pos = 6,lv = 10,cost = [{0,38040070,14},{0,38040071,6}],attr = [{2,32000},{4,960}],special_attr = []};

get_strength_cfg(1,6,11) ->
	#base_constellation_strength{equip_type = 1,pos = 6,lv = 11,cost = [],attr = [{2,35200},{4,1056}],special_attr = []};

get_strength_cfg(1,7,0) ->
	#base_constellation_strength{equip_type = 1,pos = 7,lv = 0,cost = [{0,38040075,1}],attr = [{1,0},{3,0}],special_attr = []};

get_strength_cfg(1,7,1) ->
	#base_constellation_strength{equip_type = 1,pos = 7,lv = 1,cost = [{0,38040075,2}],attr = [{1,80},{3,48}],special_attr = []};

get_strength_cfg(1,7,2) ->
	#base_constellation_strength{equip_type = 1,pos = 7,lv = 2,cost = [{0,38040075,3}],attr = [{1,160},{3,96}],special_attr = []};

get_strength_cfg(1,7,3) ->
	#base_constellation_strength{equip_type = 1,pos = 7,lv = 3,cost = [{0,38040075,4}],attr = [{1,240},{3,144}],special_attr = [{21,150}]};

get_strength_cfg(1,7,4) ->
	#base_constellation_strength{equip_type = 1,pos = 7,lv = 4,cost = [{0,38040075,4}],attr = [{1,320},{3,192}],special_attr = []};

get_strength_cfg(1,7,5) ->
	#base_constellation_strength{equip_type = 1,pos = 7,lv = 5,cost = [{0,38040075,5}],attr = [{1,400},{3,240}],special_attr = []};

get_strength_cfg(1,7,6) ->
	#base_constellation_strength{equip_type = 1,pos = 7,lv = 6,cost = [{0,38040075,5}],attr = [{1,480},{3,288}],special_attr = []};

get_strength_cfg(1,7,7) ->
	#base_constellation_strength{equip_type = 1,pos = 7,lv = 7,cost = [{0,38040075,6}],attr = [{1,560},{3,336}],special_attr = [{17,150}]};

get_strength_cfg(1,7,8) ->
	#base_constellation_strength{equip_type = 1,pos = 7,lv = 8,cost = [{0,38040075,6}],attr = [{1,640},{3,384}],special_attr = []};

get_strength_cfg(1,7,9) ->
	#base_constellation_strength{equip_type = 1,pos = 7,lv = 9,cost = [{0,38040075,7}],attr = [{1,720},{3,432}],special_attr = []};

get_strength_cfg(1,7,10) ->
	#base_constellation_strength{equip_type = 1,pos = 7,lv = 10,cost = [{0,38040075,7}],attr = [{1,800},{3,480}],special_attr = []};

get_strength_cfg(1,7,11) ->
	#base_constellation_strength{equip_type = 1,pos = 7,lv = 11,cost = [{0,38040075,8}],attr = [{1,880},{3,528}],special_attr = [{19,70}]};

get_strength_cfg(1,7,12) ->
	#base_constellation_strength{equip_type = 1,pos = 7,lv = 12,cost = [{0,38040075,8}],attr = [{1,960},{3,576}],special_attr = []};

get_strength_cfg(1,7,13) ->
	#base_constellation_strength{equip_type = 1,pos = 7,lv = 13,cost = [{0,38040075,9}],attr = [{1,1040},{3,624}],special_attr = []};

get_strength_cfg(1,7,14) ->
	#base_constellation_strength{equip_type = 1,pos = 7,lv = 14,cost = [{0,38040075,9}],attr = [{1,1120},{3,672}],special_attr = [{27,140}]};

get_strength_cfg(1,7,15) ->
	#base_constellation_strength{equip_type = 1,pos = 7,lv = 15,cost = [{0,38040075,10}],attr = [{1,1200},{3,720}],special_attr = []};

get_strength_cfg(1,7,16) ->
	#base_constellation_strength{equip_type = 1,pos = 7,lv = 16,cost = [{0,38040075,10}],attr = [{1,1280},{3,768}],special_attr = []};

get_strength_cfg(1,7,17) ->
	#base_constellation_strength{equip_type = 1,pos = 7,lv = 17,cost = [{0,38040075,12}],attr = [{1,1360},{3,816}],special_attr = [{19,70}]};

get_strength_cfg(1,7,18) ->
	#base_constellation_strength{equip_type = 1,pos = 7,lv = 18,cost = [{0,38040075,12}],attr = [{1,1440},{3,864}],special_attr = []};

get_strength_cfg(1,7,19) ->
	#base_constellation_strength{equip_type = 1,pos = 7,lv = 19,cost = [{0,38040075,15}],attr = [{1,1520},{3,912}],special_attr = []};

get_strength_cfg(1,7,20) ->
	#base_constellation_strength{equip_type = 1,pos = 7,lv = 20,cost = [],attr = [{1,1600},{3,960}],special_attr = []};

get_strength_cfg(1,8,0) ->
	#base_constellation_strength{equip_type = 1,pos = 8,lv = 0,cost = [{0,38040075,1}],attr = [{2,0},{4,0}],special_attr = []};

get_strength_cfg(1,8,1) ->
	#base_constellation_strength{equip_type = 1,pos = 8,lv = 1,cost = [{0,38040075,2}],attr = [{2,1600},{4,48}],special_attr = []};

get_strength_cfg(1,8,2) ->
	#base_constellation_strength{equip_type = 1,pos = 8,lv = 2,cost = [{0,38040075,3}],attr = [{2,3200},{4,96}],special_attr = []};

get_strength_cfg(1,8,3) ->
	#base_constellation_strength{equip_type = 1,pos = 8,lv = 3,cost = [{0,38040075,4}],attr = [{2,4800},{4,144}],special_attr = [{22,120}]};

get_strength_cfg(1,8,4) ->
	#base_constellation_strength{equip_type = 1,pos = 8,lv = 4,cost = [{0,38040075,4}],attr = [{2,6400},{4,192}],special_attr = []};

get_strength_cfg(1,8,5) ->
	#base_constellation_strength{equip_type = 1,pos = 8,lv = 5,cost = [{0,38040075,5}],attr = [{2,8000},{4,240}],special_attr = []};

get_strength_cfg(1,8,6) ->
	#base_constellation_strength{equip_type = 1,pos = 8,lv = 6,cost = [{0,38040075,5}],attr = [{2,9600},{4,288}],special_attr = []};

get_strength_cfg(1,8,7) ->
	#base_constellation_strength{equip_type = 1,pos = 8,lv = 7,cost = [{0,38040075,6}],attr = [{2,11200},{4,336}],special_attr = [{45,150}]};

get_strength_cfg(1,8,8) ->
	#base_constellation_strength{equip_type = 1,pos = 8,lv = 8,cost = [{0,38040075,6}],attr = [{2,12800},{4,384}],special_attr = []};

get_strength_cfg(1,8,9) ->
	#base_constellation_strength{equip_type = 1,pos = 8,lv = 9,cost = [{0,38040075,7}],attr = [{2,14400},{4,432}],special_attr = []};

get_strength_cfg(1,8,10) ->
	#base_constellation_strength{equip_type = 1,pos = 8,lv = 10,cost = [{0,38040075,7}],attr = [{2,16000},{4,480}],special_attr = []};

get_strength_cfg(1,8,11) ->
	#base_constellation_strength{equip_type = 1,pos = 8,lv = 11,cost = [{0,38040075,8}],attr = [{2,17600},{4,528}],special_attr = [{20,70}]};

get_strength_cfg(1,8,12) ->
	#base_constellation_strength{equip_type = 1,pos = 8,lv = 12,cost = [{0,38040075,8}],attr = [{2,19200},{4,576}],special_attr = []};

get_strength_cfg(1,8,13) ->
	#base_constellation_strength{equip_type = 1,pos = 8,lv = 13,cost = [{0,38040075,9}],attr = [{2,20800},{4,624}],special_attr = []};

get_strength_cfg(1,8,14) ->
	#base_constellation_strength{equip_type = 1,pos = 8,lv = 14,cost = [{0,38040075,9}],attr = [{2,22400},{4,672}],special_attr = [{28,140}]};

get_strength_cfg(1,8,15) ->
	#base_constellation_strength{equip_type = 1,pos = 8,lv = 15,cost = [{0,38040075,10}],attr = [{2,24000},{4,720}],special_attr = []};

get_strength_cfg(1,8,16) ->
	#base_constellation_strength{equip_type = 1,pos = 8,lv = 16,cost = [{0,38040075,10}],attr = [{2,25600},{4,768}],special_attr = []};

get_strength_cfg(1,8,17) ->
	#base_constellation_strength{equip_type = 1,pos = 8,lv = 17,cost = [{0,38040075,12}],attr = [{2,27200},{4,816}],special_attr = [{20,70}]};

get_strength_cfg(1,8,18) ->
	#base_constellation_strength{equip_type = 1,pos = 8,lv = 18,cost = [{0,38040075,12}],attr = [{2,28800},{4,864}],special_attr = []};

get_strength_cfg(1,8,19) ->
	#base_constellation_strength{equip_type = 1,pos = 8,lv = 19,cost = [{0,38040075,15}],attr = [{2,30400},{4,912}],special_attr = []};

get_strength_cfg(1,8,20) ->
	#base_constellation_strength{equip_type = 1,pos = 8,lv = 20,cost = [],attr = [{2,32000},{4,960}],special_attr = []};

get_strength_cfg(1,9,0) ->
	#base_constellation_strength{equip_type = 1,pos = 9,lv = 0,cost = [{0,38040075,1}],attr = [{1,0},{3,0}],special_attr = []};

get_strength_cfg(1,9,1) ->
	#base_constellation_strength{equip_type = 1,pos = 9,lv = 1,cost = [{0,38040075,2}],attr = [{1,80},{3,48}],special_attr = []};

get_strength_cfg(1,9,2) ->
	#base_constellation_strength{equip_type = 1,pos = 9,lv = 2,cost = [{0,38040075,3}],attr = [{1,160},{3,96}],special_attr = []};

get_strength_cfg(1,9,3) ->
	#base_constellation_strength{equip_type = 1,pos = 9,lv = 3,cost = [{0,38040075,4}],attr = [{1,240},{3,144}],special_attr = [{21,150}]};

get_strength_cfg(1,9,4) ->
	#base_constellation_strength{equip_type = 1,pos = 9,lv = 4,cost = [{0,38040075,4}],attr = [{1,320},{3,192}],special_attr = []};

get_strength_cfg(1,9,5) ->
	#base_constellation_strength{equip_type = 1,pos = 9,lv = 5,cost = [{0,38040075,5}],attr = [{1,400},{3,240}],special_attr = []};

get_strength_cfg(1,9,6) ->
	#base_constellation_strength{equip_type = 1,pos = 9,lv = 6,cost = [{0,38040075,5}],attr = [{1,480},{3,288}],special_attr = []};

get_strength_cfg(1,9,7) ->
	#base_constellation_strength{equip_type = 1,pos = 9,lv = 7,cost = [{0,38040075,6}],attr = [{1,560},{3,336}],special_attr = [{17,150}]};

get_strength_cfg(1,9,8) ->
	#base_constellation_strength{equip_type = 1,pos = 9,lv = 8,cost = [{0,38040075,6}],attr = [{1,640},{3,384}],special_attr = []};

get_strength_cfg(1,9,9) ->
	#base_constellation_strength{equip_type = 1,pos = 9,lv = 9,cost = [{0,38040075,7}],attr = [{1,720},{3,432}],special_attr = []};

get_strength_cfg(1,9,10) ->
	#base_constellation_strength{equip_type = 1,pos = 9,lv = 10,cost = [{0,38040075,7}],attr = [{1,800},{3,480}],special_attr = []};

get_strength_cfg(1,9,11) ->
	#base_constellation_strength{equip_type = 1,pos = 9,lv = 11,cost = [{0,38040075,8}],attr = [{1,880},{3,528}],special_attr = [{19,70}]};

get_strength_cfg(1,9,12) ->
	#base_constellation_strength{equip_type = 1,pos = 9,lv = 12,cost = [{0,38040075,8}],attr = [{1,960},{3,576}],special_attr = []};

get_strength_cfg(1,9,13) ->
	#base_constellation_strength{equip_type = 1,pos = 9,lv = 13,cost = [{0,38040075,9}],attr = [{1,1040},{3,624}],special_attr = []};

get_strength_cfg(1,9,14) ->
	#base_constellation_strength{equip_type = 1,pos = 9,lv = 14,cost = [{0,38040075,9}],attr = [{1,1120},{3,672}],special_attr = [{37,240}]};

get_strength_cfg(1,9,15) ->
	#base_constellation_strength{equip_type = 1,pos = 9,lv = 15,cost = [{0,38040075,10}],attr = [{1,1200},{3,720}],special_attr = []};

get_strength_cfg(1,9,16) ->
	#base_constellation_strength{equip_type = 1,pos = 9,lv = 16,cost = [{0,38040075,10}],attr = [{1,1280},{3,768}],special_attr = []};

get_strength_cfg(1,9,17) ->
	#base_constellation_strength{equip_type = 1,pos = 9,lv = 17,cost = [{0,38040075,12}],attr = [{1,1360},{3,816}],special_attr = [{19,70}]};

get_strength_cfg(1,9,18) ->
	#base_constellation_strength{equip_type = 1,pos = 9,lv = 18,cost = [{0,38040075,12}],attr = [{1,1440},{3,864}],special_attr = []};

get_strength_cfg(1,9,19) ->
	#base_constellation_strength{equip_type = 1,pos = 9,lv = 19,cost = [{0,38040075,15}],attr = [{1,1520},{3,912}],special_attr = []};

get_strength_cfg(1,9,20) ->
	#base_constellation_strength{equip_type = 1,pos = 9,lv = 20,cost = [],attr = [{1,1600},{3,960}],special_attr = []};

get_strength_cfg(1,10,0) ->
	#base_constellation_strength{equip_type = 1,pos = 10,lv = 0,cost = [{0,38040075,1}],attr = [{1,0},{3,0}],special_attr = []};

get_strength_cfg(1,10,1) ->
	#base_constellation_strength{equip_type = 1,pos = 10,lv = 1,cost = [{0,38040075,2}],attr = [{1,80},{3,48}],special_attr = []};

get_strength_cfg(1,10,2) ->
	#base_constellation_strength{equip_type = 1,pos = 10,lv = 2,cost = [{0,38040075,3}],attr = [{1,160},{3,96}],special_attr = []};

get_strength_cfg(1,10,3) ->
	#base_constellation_strength{equip_type = 1,pos = 10,lv = 3,cost = [{0,38040075,4}],attr = [{1,240},{3,144}],special_attr = [{22,120}]};

get_strength_cfg(1,10,4) ->
	#base_constellation_strength{equip_type = 1,pos = 10,lv = 4,cost = [{0,38040075,4}],attr = [{1,320},{3,192}],special_attr = []};

get_strength_cfg(1,10,5) ->
	#base_constellation_strength{equip_type = 1,pos = 10,lv = 5,cost = [{0,38040075,5}],attr = [{1,400},{3,240}],special_attr = []};

get_strength_cfg(1,10,6) ->
	#base_constellation_strength{equip_type = 1,pos = 10,lv = 6,cost = [{0,38040075,5}],attr = [{1,480},{3,288}],special_attr = []};

get_strength_cfg(1,10,7) ->
	#base_constellation_strength{equip_type = 1,pos = 10,lv = 7,cost = [{0,38040075,6}],attr = [{1,560},{3,336}],special_attr = [{45,150}]};

get_strength_cfg(1,10,8) ->
	#base_constellation_strength{equip_type = 1,pos = 10,lv = 8,cost = [{0,38040075,6}],attr = [{1,640},{3,384}],special_attr = []};

get_strength_cfg(1,10,9) ->
	#base_constellation_strength{equip_type = 1,pos = 10,lv = 9,cost = [{0,38040075,7}],attr = [{1,720},{3,432}],special_attr = []};

get_strength_cfg(1,10,10) ->
	#base_constellation_strength{equip_type = 1,pos = 10,lv = 10,cost = [{0,38040075,7}],attr = [{1,800},{3,480}],special_attr = []};

get_strength_cfg(1,10,11) ->
	#base_constellation_strength{equip_type = 1,pos = 10,lv = 11,cost = [{0,38040075,8}],attr = [{1,880},{3,528}],special_attr = [{20,70}]};

get_strength_cfg(1,10,12) ->
	#base_constellation_strength{equip_type = 1,pos = 10,lv = 12,cost = [{0,38040075,8}],attr = [{1,960},{3,576}],special_attr = []};

get_strength_cfg(1,10,13) ->
	#base_constellation_strength{equip_type = 1,pos = 10,lv = 13,cost = [{0,38040075,9}],attr = [{1,1040},{3,624}],special_attr = []};

get_strength_cfg(1,10,14) ->
	#base_constellation_strength{equip_type = 1,pos = 10,lv = 14,cost = [{0,38040075,9}],attr = [{1,1120},{3,672}],special_attr = [{38,240}]};

get_strength_cfg(1,10,15) ->
	#base_constellation_strength{equip_type = 1,pos = 10,lv = 15,cost = [{0,38040075,10}],attr = [{1,1200},{3,720}],special_attr = []};

get_strength_cfg(1,10,16) ->
	#base_constellation_strength{equip_type = 1,pos = 10,lv = 16,cost = [{0,38040075,10}],attr = [{1,1280},{3,768}],special_attr = []};

get_strength_cfg(1,10,17) ->
	#base_constellation_strength{equip_type = 1,pos = 10,lv = 17,cost = [{0,38040075,12}],attr = [{1,1360},{3,816}],special_attr = [{20,70}]};

get_strength_cfg(1,10,18) ->
	#base_constellation_strength{equip_type = 1,pos = 10,lv = 18,cost = [{0,38040075,12}],attr = [{1,1440},{3,864}],special_attr = []};

get_strength_cfg(1,10,19) ->
	#base_constellation_strength{equip_type = 1,pos = 10,lv = 19,cost = [{0,38040075,15}],attr = [{1,1520},{3,912}],special_attr = []};

get_strength_cfg(1,10,20) ->
	#base_constellation_strength{equip_type = 1,pos = 10,lv = 20,cost = [],attr = [{1,1600},{3,960}],special_attr = []};

get_strength_cfg(2,1,0) ->
	#base_constellation_strength{equip_type = 2,pos = 1,lv = 0,cost = [{0,38040070,1}],attr = [{1,0},{3,0}],special_attr = []};

get_strength_cfg(2,1,1) ->
	#base_constellation_strength{equip_type = 2,pos = 1,lv = 1,cost = [{0,38040070,2}],attr = [{1,240},{3,144}],special_attr = []};

get_strength_cfg(2,1,2) ->
	#base_constellation_strength{equip_type = 2,pos = 1,lv = 2,cost = [{0,38040070,3}],attr = [{1,480},{3,288}],special_attr = []};

get_strength_cfg(2,1,3) ->
	#base_constellation_strength{equip_type = 2,pos = 1,lv = 3,cost = [{0,38040070,4}],attr = [{1,720},{3,432}],special_attr = []};

get_strength_cfg(2,1,4) ->
	#base_constellation_strength{equip_type = 2,pos = 1,lv = 4,cost = [{0,38040070,5}],attr = [{1,960},{3,576}],special_attr = []};

get_strength_cfg(2,1,5) ->
	#base_constellation_strength{equip_type = 2,pos = 1,lv = 5,cost = [{0,38040070,6},{0,38040071,1}],attr = [{1,1200},{3,720}],special_attr = []};

get_strength_cfg(2,1,6) ->
	#base_constellation_strength{equip_type = 2,pos = 1,lv = 6,cost = [{0,38040070,7},{0,38040071,2}],attr = [{1,1440},{3,864}],special_attr = []};

get_strength_cfg(2,1,7) ->
	#base_constellation_strength{equip_type = 2,pos = 1,lv = 7,cost = [{0,38040070,8},{0,38040071,3}],attr = [{1,1680},{3,1008}],special_attr = []};

get_strength_cfg(2,1,8) ->
	#base_constellation_strength{equip_type = 2,pos = 1,lv = 8,cost = [{0,38040070,10},{0,38040071,4}],attr = [{1,1920},{3,1152}],special_attr = []};

get_strength_cfg(2,1,9) ->
	#base_constellation_strength{equip_type = 2,pos = 1,lv = 9,cost = [{0,38040070,12},{0,38040071,5}],attr = [{1,2160},{3,1296}],special_attr = []};

get_strength_cfg(2,1,10) ->
	#base_constellation_strength{equip_type = 2,pos = 1,lv = 10,cost = [{0,38040070,14},{0,38040071,6}],attr = [{1,2400},{3,1440}],special_attr = []};

get_strength_cfg(2,1,11) ->
	#base_constellation_strength{equip_type = 2,pos = 1,lv = 11,cost = [{0,38040070,16},{0,38040071,7}],attr = [{1,2640},{3,1584}],special_attr = []};

get_strength_cfg(2,1,12) ->
	#base_constellation_strength{equip_type = 2,pos = 1,lv = 12,cost = [{0,38040070,18},{0,38040071,8}],attr = [{1,2880},{3,1728}],special_attr = []};

get_strength_cfg(2,1,13) ->
	#base_constellation_strength{equip_type = 2,pos = 1,lv = 13,cost = [],attr = [{1,3120},{3,1872}],special_attr = []};

get_strength_cfg(2,2,0) ->
	#base_constellation_strength{equip_type = 2,pos = 2,lv = 0,cost = [{0,38040070,1}],attr = [{2,0},{4,0}],special_attr = []};

get_strength_cfg(2,2,1) ->
	#base_constellation_strength{equip_type = 2,pos = 2,lv = 1,cost = [{0,38040070,2}],attr = [{2,4800},{4,144}],special_attr = []};

get_strength_cfg(2,2,2) ->
	#base_constellation_strength{equip_type = 2,pos = 2,lv = 2,cost = [{0,38040070,3}],attr = [{2,9600},{4,288}],special_attr = []};

get_strength_cfg(2,2,3) ->
	#base_constellation_strength{equip_type = 2,pos = 2,lv = 3,cost = [{0,38040070,4}],attr = [{2,14400},{4,432}],special_attr = []};

get_strength_cfg(2,2,4) ->
	#base_constellation_strength{equip_type = 2,pos = 2,lv = 4,cost = [{0,38040070,5}],attr = [{2,19200},{4,576}],special_attr = []};

get_strength_cfg(2,2,5) ->
	#base_constellation_strength{equip_type = 2,pos = 2,lv = 5,cost = [{0,38040070,6},{0,38040071,1}],attr = [{2,24000},{4,720}],special_attr = []};

get_strength_cfg(2,2,6) ->
	#base_constellation_strength{equip_type = 2,pos = 2,lv = 6,cost = [{0,38040070,7},{0,38040071,2}],attr = [{2,28800},{4,864}],special_attr = []};

get_strength_cfg(2,2,7) ->
	#base_constellation_strength{equip_type = 2,pos = 2,lv = 7,cost = [{0,38040070,8},{0,38040071,3}],attr = [{2,33600},{4,1008}],special_attr = []};

get_strength_cfg(2,2,8) ->
	#base_constellation_strength{equip_type = 2,pos = 2,lv = 8,cost = [{0,38040070,10},{0,38040071,4}],attr = [{2,38400},{4,1152}],special_attr = []};

get_strength_cfg(2,2,9) ->
	#base_constellation_strength{equip_type = 2,pos = 2,lv = 9,cost = [{0,38040070,12},{0,38040071,5}],attr = [{2,43200},{4,1296}],special_attr = []};

get_strength_cfg(2,2,10) ->
	#base_constellation_strength{equip_type = 2,pos = 2,lv = 10,cost = [{0,38040070,14},{0,38040071,6}],attr = [{2,48000},{4,1440}],special_attr = []};

get_strength_cfg(2,2,11) ->
	#base_constellation_strength{equip_type = 2,pos = 2,lv = 11,cost = [{0,38040070,16},{0,38040071,7}],attr = [{2,52800},{4,1584}],special_attr = []};

get_strength_cfg(2,2,12) ->
	#base_constellation_strength{equip_type = 2,pos = 2,lv = 12,cost = [{0,38040070,18},{0,38040071,8}],attr = [{2,57600},{4,1728}],special_attr = []};

get_strength_cfg(2,2,13) ->
	#base_constellation_strength{equip_type = 2,pos = 2,lv = 13,cost = [],attr = [{2,62400},{4,1872}],special_attr = []};

get_strength_cfg(2,3,0) ->
	#base_constellation_strength{equip_type = 2,pos = 3,lv = 0,cost = [{0,38040070,1}],attr = [{2,0},{4,0}],special_attr = []};

get_strength_cfg(2,3,1) ->
	#base_constellation_strength{equip_type = 2,pos = 3,lv = 1,cost = [{0,38040070,2}],attr = [{2,4800},{4,144}],special_attr = []};

get_strength_cfg(2,3,2) ->
	#base_constellation_strength{equip_type = 2,pos = 3,lv = 2,cost = [{0,38040070,3}],attr = [{2,9600},{4,288}],special_attr = []};

get_strength_cfg(2,3,3) ->
	#base_constellation_strength{equip_type = 2,pos = 3,lv = 3,cost = [{0,38040070,4}],attr = [{2,14400},{4,432}],special_attr = []};

get_strength_cfg(2,3,4) ->
	#base_constellation_strength{equip_type = 2,pos = 3,lv = 4,cost = [{0,38040070,5}],attr = [{2,19200},{4,576}],special_attr = []};

get_strength_cfg(2,3,5) ->
	#base_constellation_strength{equip_type = 2,pos = 3,lv = 5,cost = [{0,38040070,6},{0,38040071,1}],attr = [{2,24000},{4,720}],special_attr = []};

get_strength_cfg(2,3,6) ->
	#base_constellation_strength{equip_type = 2,pos = 3,lv = 6,cost = [{0,38040070,7},{0,38040071,2}],attr = [{2,28800},{4,864}],special_attr = []};

get_strength_cfg(2,3,7) ->
	#base_constellation_strength{equip_type = 2,pos = 3,lv = 7,cost = [{0,38040070,8},{0,38040071,3}],attr = [{2,33600},{4,1008}],special_attr = []};

get_strength_cfg(2,3,8) ->
	#base_constellation_strength{equip_type = 2,pos = 3,lv = 8,cost = [{0,38040070,10},{0,38040071,4}],attr = [{2,38400},{4,1152}],special_attr = []};

get_strength_cfg(2,3,9) ->
	#base_constellation_strength{equip_type = 2,pos = 3,lv = 9,cost = [{0,38040070,12},{0,38040071,5}],attr = [{2,43200},{4,1296}],special_attr = []};

get_strength_cfg(2,3,10) ->
	#base_constellation_strength{equip_type = 2,pos = 3,lv = 10,cost = [{0,38040070,14},{0,38040071,6}],attr = [{2,48000},{4,1440}],special_attr = []};

get_strength_cfg(2,3,11) ->
	#base_constellation_strength{equip_type = 2,pos = 3,lv = 11,cost = [{0,38040070,16},{0,38040071,7}],attr = [{2,52800},{4,1584}],special_attr = []};

get_strength_cfg(2,3,12) ->
	#base_constellation_strength{equip_type = 2,pos = 3,lv = 12,cost = [{0,38040070,18},{0,38040071,8}],attr = [{2,57600},{4,1728}],special_attr = []};

get_strength_cfg(2,3,13) ->
	#base_constellation_strength{equip_type = 2,pos = 3,lv = 13,cost = [],attr = [{2,62400},{4,1872}],special_attr = []};

get_strength_cfg(2,4,0) ->
	#base_constellation_strength{equip_type = 2,pos = 4,lv = 0,cost = [{0,38040070,1}],attr = [{2,0},{4,0}],special_attr = []};

get_strength_cfg(2,4,1) ->
	#base_constellation_strength{equip_type = 2,pos = 4,lv = 1,cost = [{0,38040070,2}],attr = [{2,4800},{4,144}],special_attr = []};

get_strength_cfg(2,4,2) ->
	#base_constellation_strength{equip_type = 2,pos = 4,lv = 2,cost = [{0,38040070,3}],attr = [{2,9600},{4,288}],special_attr = []};

get_strength_cfg(2,4,3) ->
	#base_constellation_strength{equip_type = 2,pos = 4,lv = 3,cost = [{0,38040070,4}],attr = [{2,14400},{4,432}],special_attr = []};

get_strength_cfg(2,4,4) ->
	#base_constellation_strength{equip_type = 2,pos = 4,lv = 4,cost = [{0,38040070,5}],attr = [{2,19200},{4,576}],special_attr = []};

get_strength_cfg(2,4,5) ->
	#base_constellation_strength{equip_type = 2,pos = 4,lv = 5,cost = [{0,38040070,6},{0,38040071,1}],attr = [{2,24000},{4,720}],special_attr = []};

get_strength_cfg(2,4,6) ->
	#base_constellation_strength{equip_type = 2,pos = 4,lv = 6,cost = [{0,38040070,7},{0,38040071,2}],attr = [{2,28800},{4,864}],special_attr = []};

get_strength_cfg(2,4,7) ->
	#base_constellation_strength{equip_type = 2,pos = 4,lv = 7,cost = [{0,38040070,8},{0,38040071,3}],attr = [{2,33600},{4,1008}],special_attr = []};

get_strength_cfg(2,4,8) ->
	#base_constellation_strength{equip_type = 2,pos = 4,lv = 8,cost = [{0,38040070,10},{0,38040071,4}],attr = [{2,38400},{4,1152}],special_attr = []};

get_strength_cfg(2,4,9) ->
	#base_constellation_strength{equip_type = 2,pos = 4,lv = 9,cost = [{0,38040070,12},{0,38040071,5}],attr = [{2,43200},{4,1296}],special_attr = []};

get_strength_cfg(2,4,10) ->
	#base_constellation_strength{equip_type = 2,pos = 4,lv = 10,cost = [{0,38040070,14},{0,38040071,6}],attr = [{2,48000},{4,1440}],special_attr = []};

get_strength_cfg(2,4,11) ->
	#base_constellation_strength{equip_type = 2,pos = 4,lv = 11,cost = [{0,38040070,16},{0,38040071,7}],attr = [{2,52800},{4,1584}],special_attr = []};

get_strength_cfg(2,4,12) ->
	#base_constellation_strength{equip_type = 2,pos = 4,lv = 12,cost = [{0,38040070,18},{0,38040071,8}],attr = [{2,57600},{4,1728}],special_attr = []};

get_strength_cfg(2,4,13) ->
	#base_constellation_strength{equip_type = 2,pos = 4,lv = 13,cost = [],attr = [{2,62400},{4,1872}],special_attr = []};

get_strength_cfg(2,5,0) ->
	#base_constellation_strength{equip_type = 2,pos = 5,lv = 0,cost = [{0,38040070,1}],attr = [{1,0},{3,0}],special_attr = []};

get_strength_cfg(2,5,1) ->
	#base_constellation_strength{equip_type = 2,pos = 5,lv = 1,cost = [{0,38040070,2}],attr = [{1,240},{3,144}],special_attr = []};

get_strength_cfg(2,5,2) ->
	#base_constellation_strength{equip_type = 2,pos = 5,lv = 2,cost = [{0,38040070,3}],attr = [{1,480},{3,288}],special_attr = []};

get_strength_cfg(2,5,3) ->
	#base_constellation_strength{equip_type = 2,pos = 5,lv = 3,cost = [{0,38040070,4}],attr = [{1,720},{3,432}],special_attr = []};

get_strength_cfg(2,5,4) ->
	#base_constellation_strength{equip_type = 2,pos = 5,lv = 4,cost = [{0,38040070,5}],attr = [{1,960},{3,576}],special_attr = []};

get_strength_cfg(2,5,5) ->
	#base_constellation_strength{equip_type = 2,pos = 5,lv = 5,cost = [{0,38040070,6},{0,38040071,1}],attr = [{1,1200},{3,720}],special_attr = []};

get_strength_cfg(2,5,6) ->
	#base_constellation_strength{equip_type = 2,pos = 5,lv = 6,cost = [{0,38040070,7},{0,38040071,2}],attr = [{1,1440},{3,864}],special_attr = []};

get_strength_cfg(2,5,7) ->
	#base_constellation_strength{equip_type = 2,pos = 5,lv = 7,cost = [{0,38040070,8},{0,38040071,3}],attr = [{1,1680},{3,1008}],special_attr = []};

get_strength_cfg(2,5,8) ->
	#base_constellation_strength{equip_type = 2,pos = 5,lv = 8,cost = [{0,38040070,10},{0,38040071,4}],attr = [{1,1920},{3,1152}],special_attr = []};

get_strength_cfg(2,5,9) ->
	#base_constellation_strength{equip_type = 2,pos = 5,lv = 9,cost = [{0,38040070,12},{0,38040071,5}],attr = [{1,2160},{3,1296}],special_attr = []};

get_strength_cfg(2,5,10) ->
	#base_constellation_strength{equip_type = 2,pos = 5,lv = 10,cost = [{0,38040070,14},{0,38040071,6}],attr = [{1,2400},{3,1440}],special_attr = []};

get_strength_cfg(2,5,11) ->
	#base_constellation_strength{equip_type = 2,pos = 5,lv = 11,cost = [{0,38040070,16},{0,38040071,7}],attr = [{1,2640},{3,1584}],special_attr = []};

get_strength_cfg(2,5,12) ->
	#base_constellation_strength{equip_type = 2,pos = 5,lv = 12,cost = [{0,38040070,18},{0,38040071,8}],attr = [{1,2880},{3,1728}],special_attr = []};

get_strength_cfg(2,5,13) ->
	#base_constellation_strength{equip_type = 2,pos = 5,lv = 13,cost = [],attr = [{1,3120},{3,1872}],special_attr = []};

get_strength_cfg(2,6,0) ->
	#base_constellation_strength{equip_type = 2,pos = 6,lv = 0,cost = [{0,38040070,1}],attr = [{2,0},{4,0}],special_attr = []};

get_strength_cfg(2,6,1) ->
	#base_constellation_strength{equip_type = 2,pos = 6,lv = 1,cost = [{0,38040070,2}],attr = [{2,4800},{4,144}],special_attr = []};

get_strength_cfg(2,6,2) ->
	#base_constellation_strength{equip_type = 2,pos = 6,lv = 2,cost = [{0,38040070,3}],attr = [{2,9600},{4,288}],special_attr = []};

get_strength_cfg(2,6,3) ->
	#base_constellation_strength{equip_type = 2,pos = 6,lv = 3,cost = [{0,38040070,4}],attr = [{2,14400},{4,432}],special_attr = []};

get_strength_cfg(2,6,4) ->
	#base_constellation_strength{equip_type = 2,pos = 6,lv = 4,cost = [{0,38040070,5}],attr = [{2,19200},{4,576}],special_attr = []};

get_strength_cfg(2,6,5) ->
	#base_constellation_strength{equip_type = 2,pos = 6,lv = 5,cost = [{0,38040070,6},{0,38040071,1}],attr = [{2,24000},{4,720}],special_attr = []};

get_strength_cfg(2,6,6) ->
	#base_constellation_strength{equip_type = 2,pos = 6,lv = 6,cost = [{0,38040070,7},{0,38040071,2}],attr = [{2,28800},{4,864}],special_attr = []};

get_strength_cfg(2,6,7) ->
	#base_constellation_strength{equip_type = 2,pos = 6,lv = 7,cost = [{0,38040070,8},{0,38040071,3}],attr = [{2,33600},{4,1008}],special_attr = []};

get_strength_cfg(2,6,8) ->
	#base_constellation_strength{equip_type = 2,pos = 6,lv = 8,cost = [{0,38040070,10},{0,38040071,4}],attr = [{2,38400},{4,1152}],special_attr = []};

get_strength_cfg(2,6,9) ->
	#base_constellation_strength{equip_type = 2,pos = 6,lv = 9,cost = [{0,38040070,12},{0,38040071,5}],attr = [{2,43200},{4,1296}],special_attr = []};

get_strength_cfg(2,6,10) ->
	#base_constellation_strength{equip_type = 2,pos = 6,lv = 10,cost = [{0,38040070,14},{0,38040071,6}],attr = [{2,48000},{4,1440}],special_attr = []};

get_strength_cfg(2,6,11) ->
	#base_constellation_strength{equip_type = 2,pos = 6,lv = 11,cost = [{0,38040070,16},{0,38040071,7}],attr = [{2,52800},{4,1584}],special_attr = []};

get_strength_cfg(2,6,12) ->
	#base_constellation_strength{equip_type = 2,pos = 6,lv = 12,cost = [{0,38040070,18},{0,38040071,8}],attr = [{2,57600},{4,1728}],special_attr = []};

get_strength_cfg(2,6,13) ->
	#base_constellation_strength{equip_type = 2,pos = 6,lv = 13,cost = [],attr = [{2,62400},{4,1872}],special_attr = []};

get_strength_cfg(2,7,0) ->
	#base_constellation_strength{equip_type = 2,pos = 7,lv = 0,cost = [{0,38040075,1}],attr = [{1,0},{3,0}],special_attr = []};

get_strength_cfg(2,7,1) ->
	#base_constellation_strength{equip_type = 2,pos = 7,lv = 1,cost = [{0,38040075,2}],attr = [{1,120},{3,72}],special_attr = []};

get_strength_cfg(2,7,2) ->
	#base_constellation_strength{equip_type = 2,pos = 7,lv = 2,cost = [{0,38040075,3}],attr = [{1,240},{3,144}],special_attr = []};

get_strength_cfg(2,7,3) ->
	#base_constellation_strength{equip_type = 2,pos = 7,lv = 3,cost = [{0,38040075,4}],attr = [{1,360},{3,216}],special_attr = [{21,150}]};

get_strength_cfg(2,7,4) ->
	#base_constellation_strength{equip_type = 2,pos = 7,lv = 4,cost = [{0,38040075,4}],attr = [{1,480},{3,288}],special_attr = []};

get_strength_cfg(2,7,5) ->
	#base_constellation_strength{equip_type = 2,pos = 7,lv = 5,cost = [{0,38040075,5}],attr = [{1,600},{3,360}],special_attr = []};

get_strength_cfg(2,7,6) ->
	#base_constellation_strength{equip_type = 2,pos = 7,lv = 6,cost = [{0,38040075,5}],attr = [{1,720},{3,432}],special_attr = []};

get_strength_cfg(2,7,7) ->
	#base_constellation_strength{equip_type = 2,pos = 7,lv = 7,cost = [{0,38040075,6}],attr = [{1,840},{3,504}],special_attr = [{19,70}]};

get_strength_cfg(2,7,8) ->
	#base_constellation_strength{equip_type = 2,pos = 7,lv = 8,cost = [{0,38040075,6}],attr = [{1,960},{3,576}],special_attr = []};

get_strength_cfg(2,7,9) ->
	#base_constellation_strength{equip_type = 2,pos = 7,lv = 9,cost = [{0,38040075,7}],attr = [{1,1080},{3,648}],special_attr = []};

get_strength_cfg(2,7,10) ->
	#base_constellation_strength{equip_type = 2,pos = 7,lv = 10,cost = [{0,38040075,7}],attr = [{1,1200},{3,720}],special_attr = []};

get_strength_cfg(2,7,11) ->
	#base_constellation_strength{equip_type = 2,pos = 7,lv = 11,cost = [{0,38040075,8}],attr = [{1,1320},{3,792}],special_attr = [{19,70}]};

get_strength_cfg(2,7,12) ->
	#base_constellation_strength{equip_type = 2,pos = 7,lv = 12,cost = [{0,38040075,8}],attr = [{1,1440},{3,864}],special_attr = []};

get_strength_cfg(2,7,13) ->
	#base_constellation_strength{equip_type = 2,pos = 7,lv = 13,cost = [{0,38040075,9}],attr = [{1,1560},{3,936}],special_attr = []};

get_strength_cfg(2,7,14) ->
	#base_constellation_strength{equip_type = 2,pos = 7,lv = 14,cost = [{0,38040075,9}],attr = [{1,1680},{3,1008}],special_attr = [{27,140}]};

get_strength_cfg(2,7,15) ->
	#base_constellation_strength{equip_type = 2,pos = 7,lv = 15,cost = [{0,38040075,10}],attr = [{1,1800},{3,1080}],special_attr = []};

get_strength_cfg(2,7,16) ->
	#base_constellation_strength{equip_type = 2,pos = 7,lv = 16,cost = [{0,38040075,10}],attr = [{1,1920},{3,1152}],special_attr = []};

get_strength_cfg(2,7,17) ->
	#base_constellation_strength{equip_type = 2,pos = 7,lv = 17,cost = [{0,38040075,12}],attr = [{1,2040},{3,1224}],special_attr = [{19,70}]};

get_strength_cfg(2,7,18) ->
	#base_constellation_strength{equip_type = 2,pos = 7,lv = 18,cost = [{0,38040075,12}],attr = [{1,2160},{3,1296}],special_attr = []};

get_strength_cfg(2,7,19) ->
	#base_constellation_strength{equip_type = 2,pos = 7,lv = 19,cost = [{0,38040075,15}],attr = [{1,2280},{3,1368}],special_attr = []};

get_strength_cfg(2,7,20) ->
	#base_constellation_strength{equip_type = 2,pos = 7,lv = 20,cost = [],attr = [{1,2400},{3,1440}],special_attr = []};

get_strength_cfg(2,8,0) ->
	#base_constellation_strength{equip_type = 2,pos = 8,lv = 0,cost = [{0,38040075,1}],attr = [{2,0},{4,0}],special_attr = []};

get_strength_cfg(2,8,1) ->
	#base_constellation_strength{equip_type = 2,pos = 8,lv = 1,cost = [{0,38040075,2}],attr = [{2,2400},{4,72}],special_attr = []};

get_strength_cfg(2,8,2) ->
	#base_constellation_strength{equip_type = 2,pos = 8,lv = 2,cost = [{0,38040075,3}],attr = [{2,4800},{4,144}],special_attr = []};

get_strength_cfg(2,8,3) ->
	#base_constellation_strength{equip_type = 2,pos = 8,lv = 3,cost = [{0,38040075,4}],attr = [{2,7200},{4,216}],special_attr = [{22,120}]};

get_strength_cfg(2,8,4) ->
	#base_constellation_strength{equip_type = 2,pos = 8,lv = 4,cost = [{0,38040075,4}],attr = [{2,9600},{4,288}],special_attr = []};

get_strength_cfg(2,8,5) ->
	#base_constellation_strength{equip_type = 2,pos = 8,lv = 5,cost = [{0,38040075,5}],attr = [{2,12000},{4,360}],special_attr = []};

get_strength_cfg(2,8,6) ->
	#base_constellation_strength{equip_type = 2,pos = 8,lv = 6,cost = [{0,38040075,5}],attr = [{2,14400},{4,432}],special_attr = []};

get_strength_cfg(2,8,7) ->
	#base_constellation_strength{equip_type = 2,pos = 8,lv = 7,cost = [{0,38040075,6}],attr = [{2,16800},{4,504}],special_attr = [{20,70}]};

get_strength_cfg(2,8,8) ->
	#base_constellation_strength{equip_type = 2,pos = 8,lv = 8,cost = [{0,38040075,6}],attr = [{2,19200},{4,576}],special_attr = []};

get_strength_cfg(2,8,9) ->
	#base_constellation_strength{equip_type = 2,pos = 8,lv = 9,cost = [{0,38040075,7}],attr = [{2,21600},{4,648}],special_attr = []};

get_strength_cfg(2,8,10) ->
	#base_constellation_strength{equip_type = 2,pos = 8,lv = 10,cost = [{0,38040075,7}],attr = [{2,24000},{4,720}],special_attr = []};

get_strength_cfg(2,8,11) ->
	#base_constellation_strength{equip_type = 2,pos = 8,lv = 11,cost = [{0,38040075,8}],attr = [{2,26400},{4,792}],special_attr = [{20,70}]};

get_strength_cfg(2,8,12) ->
	#base_constellation_strength{equip_type = 2,pos = 8,lv = 12,cost = [{0,38040075,8}],attr = [{2,28800},{4,864}],special_attr = []};

get_strength_cfg(2,8,13) ->
	#base_constellation_strength{equip_type = 2,pos = 8,lv = 13,cost = [{0,38040075,9}],attr = [{2,31200},{4,936}],special_attr = []};

get_strength_cfg(2,8,14) ->
	#base_constellation_strength{equip_type = 2,pos = 8,lv = 14,cost = [{0,38040075,9}],attr = [{2,33600},{4,1008}],special_attr = [{28,140}]};

get_strength_cfg(2,8,15) ->
	#base_constellation_strength{equip_type = 2,pos = 8,lv = 15,cost = [{0,38040075,10}],attr = [{2,36000},{4,1080}],special_attr = []};

get_strength_cfg(2,8,16) ->
	#base_constellation_strength{equip_type = 2,pos = 8,lv = 16,cost = [{0,38040075,10}],attr = [{2,38400},{4,1152}],special_attr = []};

get_strength_cfg(2,8,17) ->
	#base_constellation_strength{equip_type = 2,pos = 8,lv = 17,cost = [{0,38040075,12}],attr = [{2,40800},{4,1224}],special_attr = [{20,70}]};

get_strength_cfg(2,8,18) ->
	#base_constellation_strength{equip_type = 2,pos = 8,lv = 18,cost = [{0,38040075,12}],attr = [{2,43200},{4,1296}],special_attr = []};

get_strength_cfg(2,8,19) ->
	#base_constellation_strength{equip_type = 2,pos = 8,lv = 19,cost = [{0,38040075,15}],attr = [{2,45600},{4,1368}],special_attr = []};

get_strength_cfg(2,8,20) ->
	#base_constellation_strength{equip_type = 2,pos = 8,lv = 20,cost = [],attr = [{2,48000},{4,1440}],special_attr = []};

get_strength_cfg(2,9,0) ->
	#base_constellation_strength{equip_type = 2,pos = 9,lv = 0,cost = [{0,38040075,1}],attr = [{1,0},{3,0}],special_attr = []};

get_strength_cfg(2,9,1) ->
	#base_constellation_strength{equip_type = 2,pos = 9,lv = 1,cost = [{0,38040075,2}],attr = [{1,120},{3,72}],special_attr = []};

get_strength_cfg(2,9,2) ->
	#base_constellation_strength{equip_type = 2,pos = 9,lv = 2,cost = [{0,38040075,3}],attr = [{1,240},{3,144}],special_attr = []};

get_strength_cfg(2,9,3) ->
	#base_constellation_strength{equip_type = 2,pos = 9,lv = 3,cost = [{0,38040075,4}],attr = [{1,360},{3,216}],special_attr = [{21,150}]};

get_strength_cfg(2,9,4) ->
	#base_constellation_strength{equip_type = 2,pos = 9,lv = 4,cost = [{0,38040075,4}],attr = [{1,480},{3,288}],special_attr = []};

get_strength_cfg(2,9,5) ->
	#base_constellation_strength{equip_type = 2,pos = 9,lv = 5,cost = [{0,38040075,5}],attr = [{1,600},{3,360}],special_attr = []};

get_strength_cfg(2,9,6) ->
	#base_constellation_strength{equip_type = 2,pos = 9,lv = 6,cost = [{0,38040075,5}],attr = [{1,720},{3,432}],special_attr = []};

get_strength_cfg(2,9,7) ->
	#base_constellation_strength{equip_type = 2,pos = 9,lv = 7,cost = [{0,38040075,6}],attr = [{1,840},{3,504}],special_attr = [{19,70}]};

get_strength_cfg(2,9,8) ->
	#base_constellation_strength{equip_type = 2,pos = 9,lv = 8,cost = [{0,38040075,6}],attr = [{1,960},{3,576}],special_attr = []};

get_strength_cfg(2,9,9) ->
	#base_constellation_strength{equip_type = 2,pos = 9,lv = 9,cost = [{0,38040075,7}],attr = [{1,1080},{3,648}],special_attr = []};

get_strength_cfg(2,9,10) ->
	#base_constellation_strength{equip_type = 2,pos = 9,lv = 10,cost = [{0,38040075,7}],attr = [{1,1200},{3,720}],special_attr = []};

get_strength_cfg(2,9,11) ->
	#base_constellation_strength{equip_type = 2,pos = 9,lv = 11,cost = [{0,38040075,8}],attr = [{1,1320},{3,792}],special_attr = [{19,70}]};

get_strength_cfg(2,9,12) ->
	#base_constellation_strength{equip_type = 2,pos = 9,lv = 12,cost = [{0,38040075,8}],attr = [{1,1440},{3,864}],special_attr = []};

get_strength_cfg(2,9,13) ->
	#base_constellation_strength{equip_type = 2,pos = 9,lv = 13,cost = [{0,38040075,9}],attr = [{1,1560},{3,936}],special_attr = []};

get_strength_cfg(2,9,14) ->
	#base_constellation_strength{equip_type = 2,pos = 9,lv = 14,cost = [{0,38040075,9}],attr = [{1,1680},{3,1008}],special_attr = [{37,240}]};

get_strength_cfg(2,9,15) ->
	#base_constellation_strength{equip_type = 2,pos = 9,lv = 15,cost = [{0,38040075,10}],attr = [{1,1800},{3,1080}],special_attr = []};

get_strength_cfg(2,9,16) ->
	#base_constellation_strength{equip_type = 2,pos = 9,lv = 16,cost = [{0,38040075,10}],attr = [{1,1920},{3,1152}],special_attr = []};

get_strength_cfg(2,9,17) ->
	#base_constellation_strength{equip_type = 2,pos = 9,lv = 17,cost = [{0,38040075,12}],attr = [{1,2040},{3,1224}],special_attr = [{19,70}]};

get_strength_cfg(2,9,18) ->
	#base_constellation_strength{equip_type = 2,pos = 9,lv = 18,cost = [{0,38040075,12}],attr = [{1,2160},{3,1296}],special_attr = []};

get_strength_cfg(2,9,19) ->
	#base_constellation_strength{equip_type = 2,pos = 9,lv = 19,cost = [{0,38040075,15}],attr = [{1,2280},{3,1368}],special_attr = []};

get_strength_cfg(2,9,20) ->
	#base_constellation_strength{equip_type = 2,pos = 9,lv = 20,cost = [],attr = [{1,2400},{3,1440}],special_attr = []};

get_strength_cfg(2,10,0) ->
	#base_constellation_strength{equip_type = 2,pos = 10,lv = 0,cost = [{0,38040075,1}],attr = [{1,0},{3,0}],special_attr = []};

get_strength_cfg(2,10,1) ->
	#base_constellation_strength{equip_type = 2,pos = 10,lv = 1,cost = [{0,38040075,2}],attr = [{1,120},{3,72}],special_attr = []};

get_strength_cfg(2,10,2) ->
	#base_constellation_strength{equip_type = 2,pos = 10,lv = 2,cost = [{0,38040075,3}],attr = [{1,240},{3,144}],special_attr = []};

get_strength_cfg(2,10,3) ->
	#base_constellation_strength{equip_type = 2,pos = 10,lv = 3,cost = [{0,38040075,4}],attr = [{1,360},{3,216}],special_attr = [{22,120}]};

get_strength_cfg(2,10,4) ->
	#base_constellation_strength{equip_type = 2,pos = 10,lv = 4,cost = [{0,38040075,4}],attr = [{1,480},{3,288}],special_attr = []};

get_strength_cfg(2,10,5) ->
	#base_constellation_strength{equip_type = 2,pos = 10,lv = 5,cost = [{0,38040075,5}],attr = [{1,600},{3,360}],special_attr = []};

get_strength_cfg(2,10,6) ->
	#base_constellation_strength{equip_type = 2,pos = 10,lv = 6,cost = [{0,38040075,5}],attr = [{1,720},{3,432}],special_attr = []};

get_strength_cfg(2,10,7) ->
	#base_constellation_strength{equip_type = 2,pos = 10,lv = 7,cost = [{0,38040075,6}],attr = [{1,840},{3,504}],special_attr = [{20,70}]};

get_strength_cfg(2,10,8) ->
	#base_constellation_strength{equip_type = 2,pos = 10,lv = 8,cost = [{0,38040075,6}],attr = [{1,960},{3,576}],special_attr = []};

get_strength_cfg(2,10,9) ->
	#base_constellation_strength{equip_type = 2,pos = 10,lv = 9,cost = [{0,38040075,7}],attr = [{1,1080},{3,648}],special_attr = []};

get_strength_cfg(2,10,10) ->
	#base_constellation_strength{equip_type = 2,pos = 10,lv = 10,cost = [{0,38040075,7}],attr = [{1,1200},{3,720}],special_attr = []};

get_strength_cfg(2,10,11) ->
	#base_constellation_strength{equip_type = 2,pos = 10,lv = 11,cost = [{0,38040075,8}],attr = [{1,1320},{3,792}],special_attr = [{20,70}]};

get_strength_cfg(2,10,12) ->
	#base_constellation_strength{equip_type = 2,pos = 10,lv = 12,cost = [{0,38040075,8}],attr = [{1,1440},{3,864}],special_attr = []};

get_strength_cfg(2,10,13) ->
	#base_constellation_strength{equip_type = 2,pos = 10,lv = 13,cost = [{0,38040075,9}],attr = [{1,1560},{3,936}],special_attr = []};

get_strength_cfg(2,10,14) ->
	#base_constellation_strength{equip_type = 2,pos = 10,lv = 14,cost = [{0,38040075,9}],attr = [{1,1680},{3,1008}],special_attr = [{38,240}]};

get_strength_cfg(2,10,15) ->
	#base_constellation_strength{equip_type = 2,pos = 10,lv = 15,cost = [{0,38040075,10}],attr = [{1,1800},{3,1080}],special_attr = []};

get_strength_cfg(2,10,16) ->
	#base_constellation_strength{equip_type = 2,pos = 10,lv = 16,cost = [{0,38040075,10}],attr = [{1,1920},{3,1152}],special_attr = []};

get_strength_cfg(2,10,17) ->
	#base_constellation_strength{equip_type = 2,pos = 10,lv = 17,cost = [{0,38040075,12}],attr = [{1,2040},{3,1224}],special_attr = [{20,70}]};

get_strength_cfg(2,10,18) ->
	#base_constellation_strength{equip_type = 2,pos = 10,lv = 18,cost = [{0,38040075,12}],attr = [{1,2160},{3,1296}],special_attr = []};

get_strength_cfg(2,10,19) ->
	#base_constellation_strength{equip_type = 2,pos = 10,lv = 19,cost = [{0,38040075,15}],attr = [{1,2280},{3,1368}],special_attr = []};

get_strength_cfg(2,10,20) ->
	#base_constellation_strength{equip_type = 2,pos = 10,lv = 20,cost = [],attr = [{1,2400},{3,1440}],special_attr = []};

get_strength_cfg(3,1,0) ->
	#base_constellation_strength{equip_type = 3,pos = 1,lv = 0,cost = [{0,38040070,1}],attr = [{1,0},{3,0}],special_attr = []};

get_strength_cfg(3,1,1) ->
	#base_constellation_strength{equip_type = 3,pos = 1,lv = 1,cost = [{0,38040070,2}],attr = [{1,320},{3,192}],special_attr = []};

get_strength_cfg(3,1,2) ->
	#base_constellation_strength{equip_type = 3,pos = 1,lv = 2,cost = [{0,38040070,3}],attr = [{1,640},{3,384}],special_attr = []};

get_strength_cfg(3,1,3) ->
	#base_constellation_strength{equip_type = 3,pos = 1,lv = 3,cost = [{0,38040070,4}],attr = [{1,960},{3,576}],special_attr = []};

get_strength_cfg(3,1,4) ->
	#base_constellation_strength{equip_type = 3,pos = 1,lv = 4,cost = [{0,38040070,5}],attr = [{1,1280},{3,768}],special_attr = []};

get_strength_cfg(3,1,5) ->
	#base_constellation_strength{equip_type = 3,pos = 1,lv = 5,cost = [{0,38040070,6},{0,38040071,1}],attr = [{1,1600},{3,960}],special_attr = []};

get_strength_cfg(3,1,6) ->
	#base_constellation_strength{equip_type = 3,pos = 1,lv = 6,cost = [{0,38040070,7},{0,38040071,2}],attr = [{1,1920},{3,1152}],special_attr = []};

get_strength_cfg(3,1,7) ->
	#base_constellation_strength{equip_type = 3,pos = 1,lv = 7,cost = [{0,38040070,8},{0,38040071,3}],attr = [{1,2240},{3,1344}],special_attr = []};

get_strength_cfg(3,1,8) ->
	#base_constellation_strength{equip_type = 3,pos = 1,lv = 8,cost = [{0,38040070,10},{0,38040071,4}],attr = [{1,2560},{3,1536}],special_attr = []};

get_strength_cfg(3,1,9) ->
	#base_constellation_strength{equip_type = 3,pos = 1,lv = 9,cost = [{0,38040070,12},{0,38040071,5}],attr = [{1,2880},{3,1728}],special_attr = []};

get_strength_cfg(3,1,10) ->
	#base_constellation_strength{equip_type = 3,pos = 1,lv = 10,cost = [{0,38040070,14},{0,38040071,6},{0,38040072,1}],attr = [{1,3200},{3,1920}],special_attr = []};

get_strength_cfg(3,1,11) ->
	#base_constellation_strength{equip_type = 3,pos = 1,lv = 11,cost = [{0,38040070,16},{0,38040071,7},{0,38040072,2}],attr = [{1,3520},{3,2112}],special_attr = []};

get_strength_cfg(3,1,12) ->
	#base_constellation_strength{equip_type = 3,pos = 1,lv = 12,cost = [{0,38040070,18},{0,38040071,8},{0,38040072,3}],attr = [{1,3840},{3,2304}],special_attr = []};

get_strength_cfg(3,1,13) ->
	#base_constellation_strength{equip_type = 3,pos = 1,lv = 13,cost = [{0,38040070,20},{0,38040071,9},{0,38040072,4}],attr = [{1,4160},{3,2496}],special_attr = []};

get_strength_cfg(3,1,14) ->
	#base_constellation_strength{equip_type = 3,pos = 1,lv = 14,cost = [{0,38040070,22},{0,38040071,10},{0,38040072,5}],attr = [{1,4480},{3,2688}],special_attr = []};

get_strength_cfg(3,1,15) ->
	#base_constellation_strength{equip_type = 3,pos = 1,lv = 15,cost = [],attr = [{1,4800},{3,2880}],special_attr = []};

get_strength_cfg(3,2,0) ->
	#base_constellation_strength{equip_type = 3,pos = 2,lv = 0,cost = [{0,38040070,1}],attr = [{2,0},{4,0}],special_attr = []};

get_strength_cfg(3,2,1) ->
	#base_constellation_strength{equip_type = 3,pos = 2,lv = 1,cost = [{0,38040070,2}],attr = [{2,6400},{4,192}],special_attr = []};

get_strength_cfg(3,2,2) ->
	#base_constellation_strength{equip_type = 3,pos = 2,lv = 2,cost = [{0,38040070,3}],attr = [{2,12800},{4,384}],special_attr = []};

get_strength_cfg(3,2,3) ->
	#base_constellation_strength{equip_type = 3,pos = 2,lv = 3,cost = [{0,38040070,4}],attr = [{2,19200},{4,576}],special_attr = []};

get_strength_cfg(3,2,4) ->
	#base_constellation_strength{equip_type = 3,pos = 2,lv = 4,cost = [{0,38040070,5}],attr = [{2,25600},{4,768}],special_attr = []};

get_strength_cfg(3,2,5) ->
	#base_constellation_strength{equip_type = 3,pos = 2,lv = 5,cost = [{0,38040070,6},{0,38040071,1}],attr = [{2,32000},{4,960}],special_attr = []};

get_strength_cfg(3,2,6) ->
	#base_constellation_strength{equip_type = 3,pos = 2,lv = 6,cost = [{0,38040070,7},{0,38040071,2}],attr = [{2,38400},{4,1152}],special_attr = []};

get_strength_cfg(3,2,7) ->
	#base_constellation_strength{equip_type = 3,pos = 2,lv = 7,cost = [{0,38040070,8},{0,38040071,3}],attr = [{2,44800},{4,1344}],special_attr = []};

get_strength_cfg(3,2,8) ->
	#base_constellation_strength{equip_type = 3,pos = 2,lv = 8,cost = [{0,38040070,10},{0,38040071,4}],attr = [{2,51200},{4,1536}],special_attr = []};

get_strength_cfg(3,2,9) ->
	#base_constellation_strength{equip_type = 3,pos = 2,lv = 9,cost = [{0,38040070,12},{0,38040071,5}],attr = [{2,57600},{4,1728}],special_attr = []};

get_strength_cfg(3,2,10) ->
	#base_constellation_strength{equip_type = 3,pos = 2,lv = 10,cost = [{0,38040070,14},{0,38040071,6},{0,38040072,1}],attr = [{2,64000},{4,1920}],special_attr = []};

get_strength_cfg(3,2,11) ->
	#base_constellation_strength{equip_type = 3,pos = 2,lv = 11,cost = [{0,38040070,16},{0,38040071,7},{0,38040072,2}],attr = [{2,70400},{4,2112}],special_attr = []};

get_strength_cfg(3,2,12) ->
	#base_constellation_strength{equip_type = 3,pos = 2,lv = 12,cost = [{0,38040070,18},{0,38040071,8},{0,38040072,3}],attr = [{2,76800},{4,2304}],special_attr = []};

get_strength_cfg(3,2,13) ->
	#base_constellation_strength{equip_type = 3,pos = 2,lv = 13,cost = [{0,38040070,20},{0,38040071,9},{0,38040072,4}],attr = [{2,83200},{4,2496}],special_attr = []};

get_strength_cfg(3,2,14) ->
	#base_constellation_strength{equip_type = 3,pos = 2,lv = 14,cost = [{0,38040070,22},{0,38040071,10},{0,38040072,5}],attr = [{2,89600},{4,2688}],special_attr = []};

get_strength_cfg(3,2,15) ->
	#base_constellation_strength{equip_type = 3,pos = 2,lv = 15,cost = [],attr = [{2,96000},{4,2880}],special_attr = []};

get_strength_cfg(3,3,0) ->
	#base_constellation_strength{equip_type = 3,pos = 3,lv = 0,cost = [{0,38040070,1}],attr = [{2,0},{4,0}],special_attr = []};

get_strength_cfg(3,3,1) ->
	#base_constellation_strength{equip_type = 3,pos = 3,lv = 1,cost = [{0,38040070,2}],attr = [{2,6400},{4,192}],special_attr = []};

get_strength_cfg(3,3,2) ->
	#base_constellation_strength{equip_type = 3,pos = 3,lv = 2,cost = [{0,38040070,3}],attr = [{2,12800},{4,384}],special_attr = []};

get_strength_cfg(3,3,3) ->
	#base_constellation_strength{equip_type = 3,pos = 3,lv = 3,cost = [{0,38040070,4}],attr = [{2,19200},{4,576}],special_attr = []};

get_strength_cfg(3,3,4) ->
	#base_constellation_strength{equip_type = 3,pos = 3,lv = 4,cost = [{0,38040070,5}],attr = [{2,25600},{4,768}],special_attr = []};

get_strength_cfg(3,3,5) ->
	#base_constellation_strength{equip_type = 3,pos = 3,lv = 5,cost = [{0,38040070,6},{0,38040071,1}],attr = [{2,32000},{4,960}],special_attr = []};

get_strength_cfg(3,3,6) ->
	#base_constellation_strength{equip_type = 3,pos = 3,lv = 6,cost = [{0,38040070,7},{0,38040071,2}],attr = [{2,38400},{4,1152}],special_attr = []};

get_strength_cfg(3,3,7) ->
	#base_constellation_strength{equip_type = 3,pos = 3,lv = 7,cost = [{0,38040070,8},{0,38040071,3}],attr = [{2,44800},{4,1344}],special_attr = []};

get_strength_cfg(3,3,8) ->
	#base_constellation_strength{equip_type = 3,pos = 3,lv = 8,cost = [{0,38040070,10},{0,38040071,4}],attr = [{2,51200},{4,1536}],special_attr = []};

get_strength_cfg(3,3,9) ->
	#base_constellation_strength{equip_type = 3,pos = 3,lv = 9,cost = [{0,38040070,12},{0,38040071,5}],attr = [{2,57600},{4,1728}],special_attr = []};

get_strength_cfg(3,3,10) ->
	#base_constellation_strength{equip_type = 3,pos = 3,lv = 10,cost = [{0,38040070,14},{0,38040071,6},{0,38040072,1}],attr = [{2,64000},{4,1920}],special_attr = []};

get_strength_cfg(3,3,11) ->
	#base_constellation_strength{equip_type = 3,pos = 3,lv = 11,cost = [{0,38040070,16},{0,38040071,7},{0,38040072,2}],attr = [{2,70400},{4,2112}],special_attr = []};

get_strength_cfg(3,3,12) ->
	#base_constellation_strength{equip_type = 3,pos = 3,lv = 12,cost = [{0,38040070,18},{0,38040071,8},{0,38040072,3}],attr = [{2,76800},{4,2304}],special_attr = []};

get_strength_cfg(3,3,13) ->
	#base_constellation_strength{equip_type = 3,pos = 3,lv = 13,cost = [{0,38040070,20},{0,38040071,9},{0,38040072,4}],attr = [{2,83200},{4,2496}],special_attr = []};

get_strength_cfg(3,3,14) ->
	#base_constellation_strength{equip_type = 3,pos = 3,lv = 14,cost = [{0,38040070,22},{0,38040071,10},{0,38040072,5}],attr = [{2,89600},{4,2688}],special_attr = []};

get_strength_cfg(3,3,15) ->
	#base_constellation_strength{equip_type = 3,pos = 3,lv = 15,cost = [],attr = [{2,96000},{4,2880}],special_attr = []};

get_strength_cfg(3,4,0) ->
	#base_constellation_strength{equip_type = 3,pos = 4,lv = 0,cost = [{0,38040070,1}],attr = [{2,0},{4,0}],special_attr = []};

get_strength_cfg(3,4,1) ->
	#base_constellation_strength{equip_type = 3,pos = 4,lv = 1,cost = [{0,38040070,2}],attr = [{2,6400},{4,192}],special_attr = []};

get_strength_cfg(3,4,2) ->
	#base_constellation_strength{equip_type = 3,pos = 4,lv = 2,cost = [{0,38040070,3}],attr = [{2,12800},{4,384}],special_attr = []};

get_strength_cfg(3,4,3) ->
	#base_constellation_strength{equip_type = 3,pos = 4,lv = 3,cost = [{0,38040070,4}],attr = [{2,19200},{4,576}],special_attr = []};

get_strength_cfg(3,4,4) ->
	#base_constellation_strength{equip_type = 3,pos = 4,lv = 4,cost = [{0,38040070,5}],attr = [{2,25600},{4,768}],special_attr = []};

get_strength_cfg(3,4,5) ->
	#base_constellation_strength{equip_type = 3,pos = 4,lv = 5,cost = [{0,38040070,6},{0,38040071,1}],attr = [{2,32000},{4,960}],special_attr = []};

get_strength_cfg(3,4,6) ->
	#base_constellation_strength{equip_type = 3,pos = 4,lv = 6,cost = [{0,38040070,7},{0,38040071,2}],attr = [{2,38400},{4,1152}],special_attr = []};

get_strength_cfg(3,4,7) ->
	#base_constellation_strength{equip_type = 3,pos = 4,lv = 7,cost = [{0,38040070,8},{0,38040071,3}],attr = [{2,44800},{4,1344}],special_attr = []};

get_strength_cfg(3,4,8) ->
	#base_constellation_strength{equip_type = 3,pos = 4,lv = 8,cost = [{0,38040070,10},{0,38040071,4}],attr = [{2,51200},{4,1536}],special_attr = []};

get_strength_cfg(3,4,9) ->
	#base_constellation_strength{equip_type = 3,pos = 4,lv = 9,cost = [{0,38040070,12},{0,38040071,5}],attr = [{2,57600},{4,1728}],special_attr = []};

get_strength_cfg(3,4,10) ->
	#base_constellation_strength{equip_type = 3,pos = 4,lv = 10,cost = [{0,38040070,14},{0,38040071,6},{0,38040072,1}],attr = [{2,64000},{4,1920}],special_attr = []};

get_strength_cfg(3,4,11) ->
	#base_constellation_strength{equip_type = 3,pos = 4,lv = 11,cost = [{0,38040070,16},{0,38040071,7},{0,38040072,2}],attr = [{2,70400},{4,2112}],special_attr = []};

get_strength_cfg(3,4,12) ->
	#base_constellation_strength{equip_type = 3,pos = 4,lv = 12,cost = [{0,38040070,18},{0,38040071,8},{0,38040072,3}],attr = [{2,76800},{4,2304}],special_attr = []};

get_strength_cfg(3,4,13) ->
	#base_constellation_strength{equip_type = 3,pos = 4,lv = 13,cost = [{0,38040070,20},{0,38040071,9},{0,38040072,4}],attr = [{2,83200},{4,2496}],special_attr = []};

get_strength_cfg(3,4,14) ->
	#base_constellation_strength{equip_type = 3,pos = 4,lv = 14,cost = [{0,38040070,22},{0,38040071,10},{0,38040072,5}],attr = [{2,89600},{4,2688}],special_attr = []};

get_strength_cfg(3,4,15) ->
	#base_constellation_strength{equip_type = 3,pos = 4,lv = 15,cost = [],attr = [{2,96000},{4,2880}],special_attr = []};

get_strength_cfg(3,5,0) ->
	#base_constellation_strength{equip_type = 3,pos = 5,lv = 0,cost = [{0,38040070,1}],attr = [{1,0},{3,0}],special_attr = []};

get_strength_cfg(3,5,1) ->
	#base_constellation_strength{equip_type = 3,pos = 5,lv = 1,cost = [{0,38040070,2}],attr = [{1,320},{3,192}],special_attr = []};

get_strength_cfg(3,5,2) ->
	#base_constellation_strength{equip_type = 3,pos = 5,lv = 2,cost = [{0,38040070,3}],attr = [{1,640},{3,384}],special_attr = []};

get_strength_cfg(3,5,3) ->
	#base_constellation_strength{equip_type = 3,pos = 5,lv = 3,cost = [{0,38040070,4}],attr = [{1,960},{3,576}],special_attr = []};

get_strength_cfg(3,5,4) ->
	#base_constellation_strength{equip_type = 3,pos = 5,lv = 4,cost = [{0,38040070,5}],attr = [{1,1280},{3,768}],special_attr = []};

get_strength_cfg(3,5,5) ->
	#base_constellation_strength{equip_type = 3,pos = 5,lv = 5,cost = [{0,38040070,6},{0,38040071,1}],attr = [{1,1600},{3,960}],special_attr = []};

get_strength_cfg(3,5,6) ->
	#base_constellation_strength{equip_type = 3,pos = 5,lv = 6,cost = [{0,38040070,7},{0,38040071,2}],attr = [{1,1920},{3,1152}],special_attr = []};

get_strength_cfg(3,5,7) ->
	#base_constellation_strength{equip_type = 3,pos = 5,lv = 7,cost = [{0,38040070,8},{0,38040071,3}],attr = [{1,2240},{3,1344}],special_attr = []};

get_strength_cfg(3,5,8) ->
	#base_constellation_strength{equip_type = 3,pos = 5,lv = 8,cost = [{0,38040070,10},{0,38040071,4}],attr = [{1,2560},{3,1536}],special_attr = []};

get_strength_cfg(3,5,9) ->
	#base_constellation_strength{equip_type = 3,pos = 5,lv = 9,cost = [{0,38040070,12},{0,38040071,5}],attr = [{1,2880},{3,1728}],special_attr = []};

get_strength_cfg(3,5,10) ->
	#base_constellation_strength{equip_type = 3,pos = 5,lv = 10,cost = [{0,38040070,14},{0,38040071,6},{0,38040072,1}],attr = [{1,3200},{3,1920}],special_attr = []};

get_strength_cfg(3,5,11) ->
	#base_constellation_strength{equip_type = 3,pos = 5,lv = 11,cost = [{0,38040070,16},{0,38040071,7},{0,38040072,2}],attr = [{1,3520},{3,2112}],special_attr = []};

get_strength_cfg(3,5,12) ->
	#base_constellation_strength{equip_type = 3,pos = 5,lv = 12,cost = [{0,38040070,18},{0,38040071,8},{0,38040072,3}],attr = [{1,3840},{3,2304}],special_attr = []};

get_strength_cfg(3,5,13) ->
	#base_constellation_strength{equip_type = 3,pos = 5,lv = 13,cost = [{0,38040070,20},{0,38040071,9},{0,38040072,4}],attr = [{1,4160},{3,2496}],special_attr = []};

get_strength_cfg(3,5,14) ->
	#base_constellation_strength{equip_type = 3,pos = 5,lv = 14,cost = [{0,38040070,22},{0,38040071,10},{0,38040072,5}],attr = [{1,4480},{3,2688}],special_attr = []};

get_strength_cfg(3,5,15) ->
	#base_constellation_strength{equip_type = 3,pos = 5,lv = 15,cost = [],attr = [{1,4800},{3,2880}],special_attr = []};

get_strength_cfg(3,6,0) ->
	#base_constellation_strength{equip_type = 3,pos = 6,lv = 0,cost = [{0,38040070,1}],attr = [{2,0},{4,0}],special_attr = []};

get_strength_cfg(3,6,1) ->
	#base_constellation_strength{equip_type = 3,pos = 6,lv = 1,cost = [{0,38040070,2}],attr = [{2,6400},{4,192}],special_attr = []};

get_strength_cfg(3,6,2) ->
	#base_constellation_strength{equip_type = 3,pos = 6,lv = 2,cost = [{0,38040070,3}],attr = [{2,12800},{4,384}],special_attr = []};

get_strength_cfg(3,6,3) ->
	#base_constellation_strength{equip_type = 3,pos = 6,lv = 3,cost = [{0,38040070,4}],attr = [{2,19200},{4,576}],special_attr = []};

get_strength_cfg(3,6,4) ->
	#base_constellation_strength{equip_type = 3,pos = 6,lv = 4,cost = [{0,38040070,5}],attr = [{2,25600},{4,768}],special_attr = []};

get_strength_cfg(3,6,5) ->
	#base_constellation_strength{equip_type = 3,pos = 6,lv = 5,cost = [{0,38040070,6},{0,38040071,1}],attr = [{2,32000},{4,960}],special_attr = []};

get_strength_cfg(3,6,6) ->
	#base_constellation_strength{equip_type = 3,pos = 6,lv = 6,cost = [{0,38040070,7},{0,38040071,2}],attr = [{2,38400},{4,1152}],special_attr = []};

get_strength_cfg(3,6,7) ->
	#base_constellation_strength{equip_type = 3,pos = 6,lv = 7,cost = [{0,38040070,8},{0,38040071,3}],attr = [{2,44800},{4,1344}],special_attr = []};

get_strength_cfg(3,6,8) ->
	#base_constellation_strength{equip_type = 3,pos = 6,lv = 8,cost = [{0,38040070,10},{0,38040071,4}],attr = [{2,51200},{4,1536}],special_attr = []};

get_strength_cfg(3,6,9) ->
	#base_constellation_strength{equip_type = 3,pos = 6,lv = 9,cost = [{0,38040070,12},{0,38040071,5}],attr = [{2,57600},{4,1728}],special_attr = []};

get_strength_cfg(3,6,10) ->
	#base_constellation_strength{equip_type = 3,pos = 6,lv = 10,cost = [{0,38040070,14},{0,38040071,6},{0,38040072,1}],attr = [{2,64000},{4,1920}],special_attr = []};

get_strength_cfg(3,6,11) ->
	#base_constellation_strength{equip_type = 3,pos = 6,lv = 11,cost = [{0,38040070,16},{0,38040071,7},{0,38040072,2}],attr = [{2,70400},{4,2112}],special_attr = []};

get_strength_cfg(3,6,12) ->
	#base_constellation_strength{equip_type = 3,pos = 6,lv = 12,cost = [{0,38040070,18},{0,38040071,8},{0,38040072,3}],attr = [{2,76800},{4,2304}],special_attr = []};

get_strength_cfg(3,6,13) ->
	#base_constellation_strength{equip_type = 3,pos = 6,lv = 13,cost = [{0,38040070,20},{0,38040071,9},{0,38040072,4}],attr = [{2,83200},{4,2496}],special_attr = []};

get_strength_cfg(3,6,14) ->
	#base_constellation_strength{equip_type = 3,pos = 6,lv = 14,cost = [{0,38040070,22},{0,38040071,10},{0,38040072,5}],attr = [{2,89600},{4,2688}],special_attr = []};

get_strength_cfg(3,6,15) ->
	#base_constellation_strength{equip_type = 3,pos = 6,lv = 15,cost = [],attr = [{2,96000},{4,2880}],special_attr = []};

get_strength_cfg(3,7,0) ->
	#base_constellation_strength{equip_type = 3,pos = 7,lv = 0,cost = [{0,38040075,1}],attr = [{1,0},{3,0}],special_attr = []};

get_strength_cfg(3,7,1) ->
	#base_constellation_strength{equip_type = 3,pos = 7,lv = 1,cost = [{0,38040075,2}],attr = [{1,160},{3,96}],special_attr = []};

get_strength_cfg(3,7,2) ->
	#base_constellation_strength{equip_type = 3,pos = 7,lv = 2,cost = [{0,38040075,3}],attr = [{1,320},{3,192}],special_attr = []};

get_strength_cfg(3,7,3) ->
	#base_constellation_strength{equip_type = 3,pos = 7,lv = 3,cost = [{0,38040075,4}],attr = [{1,480},{3,288}],special_attr = [{21,150}]};

get_strength_cfg(3,7,4) ->
	#base_constellation_strength{equip_type = 3,pos = 7,lv = 4,cost = [{0,38040075,4}],attr = [{1,640},{3,384}],special_attr = []};

get_strength_cfg(3,7,5) ->
	#base_constellation_strength{equip_type = 3,pos = 7,lv = 5,cost = [{0,38040075,5}],attr = [{1,800},{3,480}],special_attr = []};

get_strength_cfg(3,7,6) ->
	#base_constellation_strength{equip_type = 3,pos = 7,lv = 6,cost = [{0,38040075,5}],attr = [{1,960},{3,576}],special_attr = []};

get_strength_cfg(3,7,7) ->
	#base_constellation_strength{equip_type = 3,pos = 7,lv = 7,cost = [{0,38040075,6}],attr = [{1,1120},{3,672}],special_attr = [{43,500}]};

get_strength_cfg(3,7,8) ->
	#base_constellation_strength{equip_type = 3,pos = 7,lv = 8,cost = [{0,38040075,6}],attr = [{1,1280},{3,768}],special_attr = []};

get_strength_cfg(3,7,9) ->
	#base_constellation_strength{equip_type = 3,pos = 7,lv = 9,cost = [{0,38040075,7}],attr = [{1,1440},{3,864}],special_attr = []};

get_strength_cfg(3,7,10) ->
	#base_constellation_strength{equip_type = 3,pos = 7,lv = 10,cost = [{0,38040075,7}],attr = [{1,1600},{3,960}],special_attr = []};

get_strength_cfg(3,7,11) ->
	#base_constellation_strength{equip_type = 3,pos = 7,lv = 11,cost = [{0,38040075,8}],attr = [{1,1760},{3,1056}],special_attr = [{19,70}]};

get_strength_cfg(3,7,12) ->
	#base_constellation_strength{equip_type = 3,pos = 7,lv = 12,cost = [{0,38040075,8}],attr = [{1,1920},{3,1152}],special_attr = []};

get_strength_cfg(3,7,13) ->
	#base_constellation_strength{equip_type = 3,pos = 7,lv = 13,cost = [{0,38040075,9}],attr = [{1,2080},{3,1248}],special_attr = []};

get_strength_cfg(3,7,14) ->
	#base_constellation_strength{equip_type = 3,pos = 7,lv = 14,cost = [{0,38040075,9}],attr = [{1,2240},{3,1344}],special_attr = [{27,140}]};

get_strength_cfg(3,7,15) ->
	#base_constellation_strength{equip_type = 3,pos = 7,lv = 15,cost = [{0,38040075,10}],attr = [{1,2400},{3,1440}],special_attr = []};

get_strength_cfg(3,7,16) ->
	#base_constellation_strength{equip_type = 3,pos = 7,lv = 16,cost = [{0,38040075,10}],attr = [{1,2560},{3,1536}],special_attr = []};

get_strength_cfg(3,7,17) ->
	#base_constellation_strength{equip_type = 3,pos = 7,lv = 17,cost = [{0,38040075,12}],attr = [{1,2720},{3,1632}],special_attr = [{19,70}]};

get_strength_cfg(3,7,18) ->
	#base_constellation_strength{equip_type = 3,pos = 7,lv = 18,cost = [{0,38040075,12}],attr = [{1,2880},{3,1728}],special_attr = []};

get_strength_cfg(3,7,19) ->
	#base_constellation_strength{equip_type = 3,pos = 7,lv = 19,cost = [{0,38040075,15}],attr = [{1,3040},{3,1824}],special_attr = []};

get_strength_cfg(3,7,20) ->
	#base_constellation_strength{equip_type = 3,pos = 7,lv = 20,cost = [],attr = [{1,3200},{3,1920}],special_attr = []};

get_strength_cfg(3,8,0) ->
	#base_constellation_strength{equip_type = 3,pos = 8,lv = 0,cost = [{0,38040075,1}],attr = [{2,0},{4,0}],special_attr = []};

get_strength_cfg(3,8,1) ->
	#base_constellation_strength{equip_type = 3,pos = 8,lv = 1,cost = [{0,38040075,2}],attr = [{2,3200},{4,96}],special_attr = []};

get_strength_cfg(3,8,2) ->
	#base_constellation_strength{equip_type = 3,pos = 8,lv = 2,cost = [{0,38040075,3}],attr = [{2,6400},{4,192}],special_attr = []};

get_strength_cfg(3,8,3) ->
	#base_constellation_strength{equip_type = 3,pos = 8,lv = 3,cost = [{0,38040075,4}],attr = [{2,9600},{4,288}],special_attr = [{22,120}]};

get_strength_cfg(3,8,4) ->
	#base_constellation_strength{equip_type = 3,pos = 8,lv = 4,cost = [{0,38040075,4}],attr = [{2,12800},{4,384}],special_attr = []};

get_strength_cfg(3,8,5) ->
	#base_constellation_strength{equip_type = 3,pos = 8,lv = 5,cost = [{0,38040075,5}],attr = [{2,16000},{4,480}],special_attr = []};

get_strength_cfg(3,8,6) ->
	#base_constellation_strength{equip_type = 3,pos = 8,lv = 6,cost = [{0,38040075,5}],attr = [{2,19200},{4,576}],special_attr = []};

get_strength_cfg(3,8,7) ->
	#base_constellation_strength{equip_type = 3,pos = 8,lv = 7,cost = [{0,38040075,6}],attr = [{2,22400},{4,672}],special_attr = [{44,500}]};

get_strength_cfg(3,8,8) ->
	#base_constellation_strength{equip_type = 3,pos = 8,lv = 8,cost = [{0,38040075,6}],attr = [{2,25600},{4,768}],special_attr = []};

get_strength_cfg(3,8,9) ->
	#base_constellation_strength{equip_type = 3,pos = 8,lv = 9,cost = [{0,38040075,7}],attr = [{2,28800},{4,864}],special_attr = []};

get_strength_cfg(3,8,10) ->
	#base_constellation_strength{equip_type = 3,pos = 8,lv = 10,cost = [{0,38040075,7}],attr = [{2,32000},{4,960}],special_attr = []};

get_strength_cfg(3,8,11) ->
	#base_constellation_strength{equip_type = 3,pos = 8,lv = 11,cost = [{0,38040075,8}],attr = [{2,35200},{4,1056}],special_attr = [{20,70}]};

get_strength_cfg(3,8,12) ->
	#base_constellation_strength{equip_type = 3,pos = 8,lv = 12,cost = [{0,38040075,8}],attr = [{2,38400},{4,1152}],special_attr = []};

get_strength_cfg(3,8,13) ->
	#base_constellation_strength{equip_type = 3,pos = 8,lv = 13,cost = [{0,38040075,9}],attr = [{2,41600},{4,1248}],special_attr = []};

get_strength_cfg(3,8,14) ->
	#base_constellation_strength{equip_type = 3,pos = 8,lv = 14,cost = [{0,38040075,9}],attr = [{2,44800},{4,1344}],special_attr = [{28,140}]};

get_strength_cfg(3,8,15) ->
	#base_constellation_strength{equip_type = 3,pos = 8,lv = 15,cost = [{0,38040075,10}],attr = [{2,48000},{4,1440}],special_attr = []};

get_strength_cfg(3,8,16) ->
	#base_constellation_strength{equip_type = 3,pos = 8,lv = 16,cost = [{0,38040075,10}],attr = [{2,51200},{4,1536}],special_attr = []};

get_strength_cfg(3,8,17) ->
	#base_constellation_strength{equip_type = 3,pos = 8,lv = 17,cost = [{0,38040075,12}],attr = [{2,54400},{4,1632}],special_attr = [{20,70}]};

get_strength_cfg(3,8,18) ->
	#base_constellation_strength{equip_type = 3,pos = 8,lv = 18,cost = [{0,38040075,12}],attr = [{2,57600},{4,1728}],special_attr = []};

get_strength_cfg(3,8,19) ->
	#base_constellation_strength{equip_type = 3,pos = 8,lv = 19,cost = [{0,38040075,15}],attr = [{2,60800},{4,1824}],special_attr = []};

get_strength_cfg(3,8,20) ->
	#base_constellation_strength{equip_type = 3,pos = 8,lv = 20,cost = [],attr = [{2,64000},{4,1920}],special_attr = []};

get_strength_cfg(3,9,0) ->
	#base_constellation_strength{equip_type = 3,pos = 9,lv = 0,cost = [{0,38040075,1}],attr = [{1,0},{3,0}],special_attr = []};

get_strength_cfg(3,9,1) ->
	#base_constellation_strength{equip_type = 3,pos = 9,lv = 1,cost = [{0,38040075,2}],attr = [{1,160},{3,96}],special_attr = []};

get_strength_cfg(3,9,2) ->
	#base_constellation_strength{equip_type = 3,pos = 9,lv = 2,cost = [{0,38040075,3}],attr = [{1,320},{3,192}],special_attr = []};

get_strength_cfg(3,9,3) ->
	#base_constellation_strength{equip_type = 3,pos = 9,lv = 3,cost = [{0,38040075,4}],attr = [{1,480},{3,288}],special_attr = [{21,150}]};

get_strength_cfg(3,9,4) ->
	#base_constellation_strength{equip_type = 3,pos = 9,lv = 4,cost = [{0,38040075,4}],attr = [{1,640},{3,384}],special_attr = []};

get_strength_cfg(3,9,5) ->
	#base_constellation_strength{equip_type = 3,pos = 9,lv = 5,cost = [{0,38040075,5}],attr = [{1,800},{3,480}],special_attr = []};

get_strength_cfg(3,9,6) ->
	#base_constellation_strength{equip_type = 3,pos = 9,lv = 6,cost = [{0,38040075,5}],attr = [{1,960},{3,576}],special_attr = []};

get_strength_cfg(3,9,7) ->
	#base_constellation_strength{equip_type = 3,pos = 9,lv = 7,cost = [{0,38040075,6}],attr = [{1,1120},{3,672}],special_attr = [{43,500}]};

get_strength_cfg(3,9,8) ->
	#base_constellation_strength{equip_type = 3,pos = 9,lv = 8,cost = [{0,38040075,6}],attr = [{1,1280},{3,768}],special_attr = []};

get_strength_cfg(3,9,9) ->
	#base_constellation_strength{equip_type = 3,pos = 9,lv = 9,cost = [{0,38040075,7}],attr = [{1,1440},{3,864}],special_attr = []};

get_strength_cfg(3,9,10) ->
	#base_constellation_strength{equip_type = 3,pos = 9,lv = 10,cost = [{0,38040075,7}],attr = [{1,1600},{3,960}],special_attr = []};

get_strength_cfg(3,9,11) ->
	#base_constellation_strength{equip_type = 3,pos = 9,lv = 11,cost = [{0,38040075,8}],attr = [{1,1760},{3,1056}],special_attr = [{19,70}]};

get_strength_cfg(3,9,12) ->
	#base_constellation_strength{equip_type = 3,pos = 9,lv = 12,cost = [{0,38040075,8}],attr = [{1,1920},{3,1152}],special_attr = []};

get_strength_cfg(3,9,13) ->
	#base_constellation_strength{equip_type = 3,pos = 9,lv = 13,cost = [{0,38040075,9}],attr = [{1,2080},{3,1248}],special_attr = []};

get_strength_cfg(3,9,14) ->
	#base_constellation_strength{equip_type = 3,pos = 9,lv = 14,cost = [{0,38040075,9}],attr = [{1,2240},{3,1344}],special_attr = [{37,240}]};

get_strength_cfg(3,9,15) ->
	#base_constellation_strength{equip_type = 3,pos = 9,lv = 15,cost = [{0,38040075,10}],attr = [{1,2400},{3,1440}],special_attr = []};

get_strength_cfg(3,9,16) ->
	#base_constellation_strength{equip_type = 3,pos = 9,lv = 16,cost = [{0,38040075,10}],attr = [{1,2560},{3,1536}],special_attr = []};

get_strength_cfg(3,9,17) ->
	#base_constellation_strength{equip_type = 3,pos = 9,lv = 17,cost = [{0,38040075,12}],attr = [{1,2720},{3,1632}],special_attr = [{19,70}]};

get_strength_cfg(3,9,18) ->
	#base_constellation_strength{equip_type = 3,pos = 9,lv = 18,cost = [{0,38040075,12}],attr = [{1,2880},{3,1728}],special_attr = []};

get_strength_cfg(3,9,19) ->
	#base_constellation_strength{equip_type = 3,pos = 9,lv = 19,cost = [{0,38040075,15}],attr = [{1,3040},{3,1824}],special_attr = []};

get_strength_cfg(3,9,20) ->
	#base_constellation_strength{equip_type = 3,pos = 9,lv = 20,cost = [],attr = [{1,3200},{3,1920}],special_attr = []};

get_strength_cfg(3,10,0) ->
	#base_constellation_strength{equip_type = 3,pos = 10,lv = 0,cost = [{0,38040075,1}],attr = [{1,0},{3,0}],special_attr = []};

get_strength_cfg(3,10,1) ->
	#base_constellation_strength{equip_type = 3,pos = 10,lv = 1,cost = [{0,38040075,2}],attr = [{1,160},{3,96}],special_attr = []};

get_strength_cfg(3,10,2) ->
	#base_constellation_strength{equip_type = 3,pos = 10,lv = 2,cost = [{0,38040075,3}],attr = [{1,320},{3,192}],special_attr = []};

get_strength_cfg(3,10,3) ->
	#base_constellation_strength{equip_type = 3,pos = 10,lv = 3,cost = [{0,38040075,4}],attr = [{1,480},{3,288}],special_attr = [{22,120}]};

get_strength_cfg(3,10,4) ->
	#base_constellation_strength{equip_type = 3,pos = 10,lv = 4,cost = [{0,38040075,4}],attr = [{1,640},{3,384}],special_attr = []};

get_strength_cfg(3,10,5) ->
	#base_constellation_strength{equip_type = 3,pos = 10,lv = 5,cost = [{0,38040075,5}],attr = [{1,800},{3,480}],special_attr = []};

get_strength_cfg(3,10,6) ->
	#base_constellation_strength{equip_type = 3,pos = 10,lv = 6,cost = [{0,38040075,5}],attr = [{1,960},{3,576}],special_attr = []};

get_strength_cfg(3,10,7) ->
	#base_constellation_strength{equip_type = 3,pos = 10,lv = 7,cost = [{0,38040075,6}],attr = [{1,1120},{3,672}],special_attr = [{44,500}]};

get_strength_cfg(3,10,8) ->
	#base_constellation_strength{equip_type = 3,pos = 10,lv = 8,cost = [{0,38040075,6}],attr = [{1,1280},{3,768}],special_attr = []};

get_strength_cfg(3,10,9) ->
	#base_constellation_strength{equip_type = 3,pos = 10,lv = 9,cost = [{0,38040075,7}],attr = [{1,1440},{3,864}],special_attr = []};

get_strength_cfg(3,10,10) ->
	#base_constellation_strength{equip_type = 3,pos = 10,lv = 10,cost = [{0,38040075,7}],attr = [{1,1600},{3,960}],special_attr = []};

get_strength_cfg(3,10,11) ->
	#base_constellation_strength{equip_type = 3,pos = 10,lv = 11,cost = [{0,38040075,8}],attr = [{1,1760},{3,1056}],special_attr = [{20,70}]};

get_strength_cfg(3,10,12) ->
	#base_constellation_strength{equip_type = 3,pos = 10,lv = 12,cost = [{0,38040075,8}],attr = [{1,1920},{3,1152}],special_attr = []};

get_strength_cfg(3,10,13) ->
	#base_constellation_strength{equip_type = 3,pos = 10,lv = 13,cost = [{0,38040075,9}],attr = [{1,2080},{3,1248}],special_attr = []};

get_strength_cfg(3,10,14) ->
	#base_constellation_strength{equip_type = 3,pos = 10,lv = 14,cost = [{0,38040075,9}],attr = [{1,2240},{3,1344}],special_attr = [{38,240}]};

get_strength_cfg(3,10,15) ->
	#base_constellation_strength{equip_type = 3,pos = 10,lv = 15,cost = [{0,38040075,10}],attr = [{1,2400},{3,1440}],special_attr = []};

get_strength_cfg(3,10,16) ->
	#base_constellation_strength{equip_type = 3,pos = 10,lv = 16,cost = [{0,38040075,10}],attr = [{1,2560},{3,1536}],special_attr = []};

get_strength_cfg(3,10,17) ->
	#base_constellation_strength{equip_type = 3,pos = 10,lv = 17,cost = [{0,38040075,12}],attr = [{1,2720},{3,1632}],special_attr = [{20,70}]};

get_strength_cfg(3,10,18) ->
	#base_constellation_strength{equip_type = 3,pos = 10,lv = 18,cost = [{0,38040075,12}],attr = [{1,2880},{3,1728}],special_attr = []};

get_strength_cfg(3,10,19) ->
	#base_constellation_strength{equip_type = 3,pos = 10,lv = 19,cost = [{0,38040075,15}],attr = [{1,3040},{3,1824}],special_attr = []};

get_strength_cfg(3,10,20) ->
	#base_constellation_strength{equip_type = 3,pos = 10,lv = 20,cost = [],attr = [{1,3200},{3,1920}],special_attr = []};

get_strength_cfg(4,1,0) ->
	#base_constellation_strength{equip_type = 4,pos = 1,lv = 0,cost = [{0,38040070,1}],attr = [{1,0},{3,0}],special_attr = []};

get_strength_cfg(4,1,1) ->
	#base_constellation_strength{equip_type = 4,pos = 1,lv = 1,cost = [{0,38040070,2}],attr = [{1,400},{3,240}],special_attr = []};

get_strength_cfg(4,1,2) ->
	#base_constellation_strength{equip_type = 4,pos = 1,lv = 2,cost = [{0,38040070,3}],attr = [{1,800},{3,480}],special_attr = []};

get_strength_cfg(4,1,3) ->
	#base_constellation_strength{equip_type = 4,pos = 1,lv = 3,cost = [{0,38040070,4}],attr = [{1,1200},{3,720}],special_attr = []};

get_strength_cfg(4,1,4) ->
	#base_constellation_strength{equip_type = 4,pos = 1,lv = 4,cost = [{0,38040070,5}],attr = [{1,1600},{3,960}],special_attr = []};

get_strength_cfg(4,1,5) ->
	#base_constellation_strength{equip_type = 4,pos = 1,lv = 5,cost = [{0,38040070,6},{0,38040071,1}],attr = [{1,2000},{3,1200}],special_attr = []};

get_strength_cfg(4,1,6) ->
	#base_constellation_strength{equip_type = 4,pos = 1,lv = 6,cost = [{0,38040070,7},{0,38040071,2}],attr = [{1,2400},{3,1440}],special_attr = []};

get_strength_cfg(4,1,7) ->
	#base_constellation_strength{equip_type = 4,pos = 1,lv = 7,cost = [{0,38040070,8},{0,38040071,3}],attr = [{1,2800},{3,1680}],special_attr = []};

get_strength_cfg(4,1,8) ->
	#base_constellation_strength{equip_type = 4,pos = 1,lv = 8,cost = [{0,38040070,10},{0,38040071,4}],attr = [{1,3200},{3,1920}],special_attr = []};

get_strength_cfg(4,1,9) ->
	#base_constellation_strength{equip_type = 4,pos = 1,lv = 9,cost = [{0,38040070,12},{0,38040071,5}],attr = [{1,3600},{3,2160}],special_attr = []};

get_strength_cfg(4,1,10) ->
	#base_constellation_strength{equip_type = 4,pos = 1,lv = 10,cost = [{0,38040070,14},{0,38040071,6},{0,38040072,1}],attr = [{1,4000},{3,2400}],special_attr = []};

get_strength_cfg(4,1,11) ->
	#base_constellation_strength{equip_type = 4,pos = 1,lv = 11,cost = [{0,38040070,16},{0,38040071,7},{0,38040072,2}],attr = [{1,4400},{3,2640}],special_attr = []};

get_strength_cfg(4,1,12) ->
	#base_constellation_strength{equip_type = 4,pos = 1,lv = 12,cost = [{0,38040070,18},{0,38040071,8},{0,38040072,3}],attr = [{1,4800},{3,2880}],special_attr = []};

get_strength_cfg(4,1,13) ->
	#base_constellation_strength{equip_type = 4,pos = 1,lv = 13,cost = [{0,38040070,20},{0,38040071,9},{0,38040072,4}],attr = [{1,5200},{3,3120}],special_attr = []};

get_strength_cfg(4,1,14) ->
	#base_constellation_strength{equip_type = 4,pos = 1,lv = 14,cost = [{0,38040070,22},{0,38040071,10},{0,38040072,5}],attr = [{1,5600},{3,3360}],special_attr = []};

get_strength_cfg(4,1,15) ->
	#base_constellation_strength{equip_type = 4,pos = 1,lv = 15,cost = [],attr = [{1,6000},{3,3600}],special_attr = []};

get_strength_cfg(4,2,0) ->
	#base_constellation_strength{equip_type = 4,pos = 2,lv = 0,cost = [{0,38040070,1}],attr = [{2,0},{4,0}],special_attr = []};

get_strength_cfg(4,2,1) ->
	#base_constellation_strength{equip_type = 4,pos = 2,lv = 1,cost = [{0,38040070,2}],attr = [{2,8000},{4,240}],special_attr = []};

get_strength_cfg(4,2,2) ->
	#base_constellation_strength{equip_type = 4,pos = 2,lv = 2,cost = [{0,38040070,3}],attr = [{2,16000},{4,480}],special_attr = []};

get_strength_cfg(4,2,3) ->
	#base_constellation_strength{equip_type = 4,pos = 2,lv = 3,cost = [{0,38040070,4}],attr = [{2,24000},{4,720}],special_attr = []};

get_strength_cfg(4,2,4) ->
	#base_constellation_strength{equip_type = 4,pos = 2,lv = 4,cost = [{0,38040070,5}],attr = [{2,32000},{4,960}],special_attr = []};

get_strength_cfg(4,2,5) ->
	#base_constellation_strength{equip_type = 4,pos = 2,lv = 5,cost = [{0,38040070,6},{0,38040071,1}],attr = [{2,40000},{4,1200}],special_attr = []};

get_strength_cfg(4,2,6) ->
	#base_constellation_strength{equip_type = 4,pos = 2,lv = 6,cost = [{0,38040070,7},{0,38040071,2}],attr = [{2,48000},{4,1440}],special_attr = []};

get_strength_cfg(4,2,7) ->
	#base_constellation_strength{equip_type = 4,pos = 2,lv = 7,cost = [{0,38040070,8},{0,38040071,3}],attr = [{2,56000},{4,1680}],special_attr = []};

get_strength_cfg(4,2,8) ->
	#base_constellation_strength{equip_type = 4,pos = 2,lv = 8,cost = [{0,38040070,10},{0,38040071,4}],attr = [{2,64000},{4,1920}],special_attr = []};

get_strength_cfg(4,2,9) ->
	#base_constellation_strength{equip_type = 4,pos = 2,lv = 9,cost = [{0,38040070,12},{0,38040071,5}],attr = [{2,72000},{4,2160}],special_attr = []};

get_strength_cfg(4,2,10) ->
	#base_constellation_strength{equip_type = 4,pos = 2,lv = 10,cost = [{0,38040070,14},{0,38040071,6},{0,38040072,1}],attr = [{2,80000},{4,2400}],special_attr = []};

get_strength_cfg(4,2,11) ->
	#base_constellation_strength{equip_type = 4,pos = 2,lv = 11,cost = [{0,38040070,16},{0,38040071,7},{0,38040072,2}],attr = [{2,88000},{4,2640}],special_attr = []};

get_strength_cfg(4,2,12) ->
	#base_constellation_strength{equip_type = 4,pos = 2,lv = 12,cost = [{0,38040070,18},{0,38040071,8},{0,38040072,3}],attr = [{2,96000},{4,2880}],special_attr = []};

get_strength_cfg(4,2,13) ->
	#base_constellation_strength{equip_type = 4,pos = 2,lv = 13,cost = [{0,38040070,20},{0,38040071,9},{0,38040072,4}],attr = [{2,104000},{4,3120}],special_attr = []};

get_strength_cfg(4,2,14) ->
	#base_constellation_strength{equip_type = 4,pos = 2,lv = 14,cost = [{0,38040070,22},{0,38040071,10},{0,38040072,5}],attr = [{2,112000},{4,3360}],special_attr = []};

get_strength_cfg(4,2,15) ->
	#base_constellation_strength{equip_type = 4,pos = 2,lv = 15,cost = [],attr = [{2,120000},{4,3600}],special_attr = []};

get_strength_cfg(4,3,0) ->
	#base_constellation_strength{equip_type = 4,pos = 3,lv = 0,cost = [{0,38040070,1}],attr = [{2,0},{4,0}],special_attr = []};

get_strength_cfg(4,3,1) ->
	#base_constellation_strength{equip_type = 4,pos = 3,lv = 1,cost = [{0,38040070,2}],attr = [{2,8000},{4,240}],special_attr = []};

get_strength_cfg(4,3,2) ->
	#base_constellation_strength{equip_type = 4,pos = 3,lv = 2,cost = [{0,38040070,3}],attr = [{2,16000},{4,480}],special_attr = []};

get_strength_cfg(4,3,3) ->
	#base_constellation_strength{equip_type = 4,pos = 3,lv = 3,cost = [{0,38040070,4}],attr = [{2,24000},{4,720}],special_attr = []};

get_strength_cfg(4,3,4) ->
	#base_constellation_strength{equip_type = 4,pos = 3,lv = 4,cost = [{0,38040070,5}],attr = [{2,32000},{4,960}],special_attr = []};

get_strength_cfg(4,3,5) ->
	#base_constellation_strength{equip_type = 4,pos = 3,lv = 5,cost = [{0,38040070,6},{0,38040071,1}],attr = [{2,40000},{4,1200}],special_attr = []};

get_strength_cfg(4,3,6) ->
	#base_constellation_strength{equip_type = 4,pos = 3,lv = 6,cost = [{0,38040070,7},{0,38040071,2}],attr = [{2,48000},{4,1440}],special_attr = []};

get_strength_cfg(4,3,7) ->
	#base_constellation_strength{equip_type = 4,pos = 3,lv = 7,cost = [{0,38040070,8},{0,38040071,3}],attr = [{2,56000},{4,1680}],special_attr = []};

get_strength_cfg(4,3,8) ->
	#base_constellation_strength{equip_type = 4,pos = 3,lv = 8,cost = [{0,38040070,10},{0,38040071,4}],attr = [{2,64000},{4,1920}],special_attr = []};

get_strength_cfg(4,3,9) ->
	#base_constellation_strength{equip_type = 4,pos = 3,lv = 9,cost = [{0,38040070,12},{0,38040071,5}],attr = [{2,72000},{4,2160}],special_attr = []};

get_strength_cfg(4,3,10) ->
	#base_constellation_strength{equip_type = 4,pos = 3,lv = 10,cost = [{0,38040070,14},{0,38040071,6},{0,38040072,1}],attr = [{2,80000},{4,2400}],special_attr = []};

get_strength_cfg(4,3,11) ->
	#base_constellation_strength{equip_type = 4,pos = 3,lv = 11,cost = [{0,38040070,16},{0,38040071,7},{0,38040072,2}],attr = [{2,88000},{4,2640}],special_attr = []};

get_strength_cfg(4,3,12) ->
	#base_constellation_strength{equip_type = 4,pos = 3,lv = 12,cost = [{0,38040070,18},{0,38040071,8},{0,38040072,3}],attr = [{2,96000},{4,2880}],special_attr = []};

get_strength_cfg(4,3,13) ->
	#base_constellation_strength{equip_type = 4,pos = 3,lv = 13,cost = [{0,38040070,20},{0,38040071,9},{0,38040072,4}],attr = [{2,104000},{4,3120}],special_attr = []};

get_strength_cfg(4,3,14) ->
	#base_constellation_strength{equip_type = 4,pos = 3,lv = 14,cost = [{0,38040070,22},{0,38040071,10},{0,38040072,5}],attr = [{2,112000},{4,3360}],special_attr = []};

get_strength_cfg(4,3,15) ->
	#base_constellation_strength{equip_type = 4,pos = 3,lv = 15,cost = [],attr = [{2,120000},{4,3600}],special_attr = []};

get_strength_cfg(4,4,0) ->
	#base_constellation_strength{equip_type = 4,pos = 4,lv = 0,cost = [{0,38040070,1}],attr = [{2,0},{4,0}],special_attr = []};

get_strength_cfg(4,4,1) ->
	#base_constellation_strength{equip_type = 4,pos = 4,lv = 1,cost = [{0,38040070,2}],attr = [{2,8000},{4,240}],special_attr = []};

get_strength_cfg(4,4,2) ->
	#base_constellation_strength{equip_type = 4,pos = 4,lv = 2,cost = [{0,38040070,3}],attr = [{2,16000},{4,480}],special_attr = []};

get_strength_cfg(4,4,3) ->
	#base_constellation_strength{equip_type = 4,pos = 4,lv = 3,cost = [{0,38040070,4}],attr = [{2,24000},{4,720}],special_attr = []};

get_strength_cfg(4,4,4) ->
	#base_constellation_strength{equip_type = 4,pos = 4,lv = 4,cost = [{0,38040070,5}],attr = [{2,32000},{4,960}],special_attr = []};

get_strength_cfg(4,4,5) ->
	#base_constellation_strength{equip_type = 4,pos = 4,lv = 5,cost = [{0,38040070,6},{0,38040071,1}],attr = [{2,40000},{4,1200}],special_attr = []};

get_strength_cfg(4,4,6) ->
	#base_constellation_strength{equip_type = 4,pos = 4,lv = 6,cost = [{0,38040070,7},{0,38040071,2}],attr = [{2,48000},{4,1440}],special_attr = []};

get_strength_cfg(4,4,7) ->
	#base_constellation_strength{equip_type = 4,pos = 4,lv = 7,cost = [{0,38040070,8},{0,38040071,3}],attr = [{2,56000},{4,1680}],special_attr = []};

get_strength_cfg(4,4,8) ->
	#base_constellation_strength{equip_type = 4,pos = 4,lv = 8,cost = [{0,38040070,10},{0,38040071,4}],attr = [{2,64000},{4,1920}],special_attr = []};

get_strength_cfg(4,4,9) ->
	#base_constellation_strength{equip_type = 4,pos = 4,lv = 9,cost = [{0,38040070,12},{0,38040071,5}],attr = [{2,72000},{4,2160}],special_attr = []};

get_strength_cfg(4,4,10) ->
	#base_constellation_strength{equip_type = 4,pos = 4,lv = 10,cost = [{0,38040070,14},{0,38040071,6},{0,38040072,1}],attr = [{2,80000},{4,2400}],special_attr = []};

get_strength_cfg(4,4,11) ->
	#base_constellation_strength{equip_type = 4,pos = 4,lv = 11,cost = [{0,38040070,16},{0,38040071,7},{0,38040072,2}],attr = [{2,88000},{4,2640}],special_attr = []};

get_strength_cfg(4,4,12) ->
	#base_constellation_strength{equip_type = 4,pos = 4,lv = 12,cost = [{0,38040070,18},{0,38040071,8},{0,38040072,3}],attr = [{2,96000},{4,2880}],special_attr = []};

get_strength_cfg(4,4,13) ->
	#base_constellation_strength{equip_type = 4,pos = 4,lv = 13,cost = [{0,38040070,20},{0,38040071,9},{0,38040072,4}],attr = [{2,104000},{4,3120}],special_attr = []};

get_strength_cfg(4,4,14) ->
	#base_constellation_strength{equip_type = 4,pos = 4,lv = 14,cost = [{0,38040070,22},{0,38040071,10},{0,38040072,5}],attr = [{2,112000},{4,3360}],special_attr = []};

get_strength_cfg(4,4,15) ->
	#base_constellation_strength{equip_type = 4,pos = 4,lv = 15,cost = [],attr = [{2,120000},{4,3600}],special_attr = []};

get_strength_cfg(4,5,0) ->
	#base_constellation_strength{equip_type = 4,pos = 5,lv = 0,cost = [{0,38040070,1}],attr = [{1,0},{3,0}],special_attr = []};

get_strength_cfg(4,5,1) ->
	#base_constellation_strength{equip_type = 4,pos = 5,lv = 1,cost = [{0,38040070,2}],attr = [{1,400},{3,240}],special_attr = []};

get_strength_cfg(4,5,2) ->
	#base_constellation_strength{equip_type = 4,pos = 5,lv = 2,cost = [{0,38040070,3}],attr = [{1,800},{3,480}],special_attr = []};

get_strength_cfg(4,5,3) ->
	#base_constellation_strength{equip_type = 4,pos = 5,lv = 3,cost = [{0,38040070,4}],attr = [{1,1200},{3,720}],special_attr = []};

get_strength_cfg(4,5,4) ->
	#base_constellation_strength{equip_type = 4,pos = 5,lv = 4,cost = [{0,38040070,5}],attr = [{1,1600},{3,960}],special_attr = []};

get_strength_cfg(4,5,5) ->
	#base_constellation_strength{equip_type = 4,pos = 5,lv = 5,cost = [{0,38040070,6},{0,38040071,1}],attr = [{1,2000},{3,1200}],special_attr = []};

get_strength_cfg(4,5,6) ->
	#base_constellation_strength{equip_type = 4,pos = 5,lv = 6,cost = [{0,38040070,7},{0,38040071,2}],attr = [{1,2400},{3,1440}],special_attr = []};

get_strength_cfg(4,5,7) ->
	#base_constellation_strength{equip_type = 4,pos = 5,lv = 7,cost = [{0,38040070,8},{0,38040071,3}],attr = [{1,2800},{3,1680}],special_attr = []};

get_strength_cfg(4,5,8) ->
	#base_constellation_strength{equip_type = 4,pos = 5,lv = 8,cost = [{0,38040070,10},{0,38040071,4}],attr = [{1,3200},{3,1920}],special_attr = []};

get_strength_cfg(4,5,9) ->
	#base_constellation_strength{equip_type = 4,pos = 5,lv = 9,cost = [{0,38040070,12},{0,38040071,5}],attr = [{1,3600},{3,2160}],special_attr = []};

get_strength_cfg(4,5,10) ->
	#base_constellation_strength{equip_type = 4,pos = 5,lv = 10,cost = [{0,38040070,14},{0,38040071,6},{0,38040072,1}],attr = [{1,4000},{3,2400}],special_attr = []};

get_strength_cfg(4,5,11) ->
	#base_constellation_strength{equip_type = 4,pos = 5,lv = 11,cost = [{0,38040070,16},{0,38040071,7},{0,38040072,2}],attr = [{1,4400},{3,2640}],special_attr = []};

get_strength_cfg(4,5,12) ->
	#base_constellation_strength{equip_type = 4,pos = 5,lv = 12,cost = [{0,38040070,18},{0,38040071,8},{0,38040072,3}],attr = [{1,4800},{3,2880}],special_attr = []};

get_strength_cfg(4,5,13) ->
	#base_constellation_strength{equip_type = 4,pos = 5,lv = 13,cost = [{0,38040070,20},{0,38040071,9},{0,38040072,4}],attr = [{1,5200},{3,3120}],special_attr = []};

get_strength_cfg(4,5,14) ->
	#base_constellation_strength{equip_type = 4,pos = 5,lv = 14,cost = [{0,38040070,22},{0,38040071,10},{0,38040072,5}],attr = [{1,5600},{3,3360}],special_attr = []};

get_strength_cfg(4,5,15) ->
	#base_constellation_strength{equip_type = 4,pos = 5,lv = 15,cost = [],attr = [{1,400},{3,240}],special_attr = []};

get_strength_cfg(4,6,0) ->
	#base_constellation_strength{equip_type = 4,pos = 6,lv = 0,cost = [{0,38040070,1}],attr = [{2,0},{4,0}],special_attr = []};

get_strength_cfg(4,6,1) ->
	#base_constellation_strength{equip_type = 4,pos = 6,lv = 1,cost = [{0,38040070,2}],attr = [{2,8000},{4,240}],special_attr = []};

get_strength_cfg(4,6,2) ->
	#base_constellation_strength{equip_type = 4,pos = 6,lv = 2,cost = [{0,38040070,3}],attr = [{2,16000},{4,480}],special_attr = []};

get_strength_cfg(4,6,3) ->
	#base_constellation_strength{equip_type = 4,pos = 6,lv = 3,cost = [{0,38040070,4}],attr = [{2,24000},{4,720}],special_attr = []};

get_strength_cfg(4,6,4) ->
	#base_constellation_strength{equip_type = 4,pos = 6,lv = 4,cost = [{0,38040070,5}],attr = [{2,32000},{4,960}],special_attr = []};

get_strength_cfg(4,6,5) ->
	#base_constellation_strength{equip_type = 4,pos = 6,lv = 5,cost = [{0,38040070,6},{0,38040071,1}],attr = [{2,40000},{4,1200}],special_attr = []};

get_strength_cfg(4,6,6) ->
	#base_constellation_strength{equip_type = 4,pos = 6,lv = 6,cost = [{0,38040070,7},{0,38040071,2}],attr = [{2,48000},{4,1440}],special_attr = []};

get_strength_cfg(4,6,7) ->
	#base_constellation_strength{equip_type = 4,pos = 6,lv = 7,cost = [{0,38040070,8},{0,38040071,3}],attr = [{2,56000},{4,1680}],special_attr = []};

get_strength_cfg(4,6,8) ->
	#base_constellation_strength{equip_type = 4,pos = 6,lv = 8,cost = [{0,38040070,10},{0,38040071,4}],attr = [{2,64000},{4,1920}],special_attr = []};

get_strength_cfg(4,6,9) ->
	#base_constellation_strength{equip_type = 4,pos = 6,lv = 9,cost = [{0,38040070,12},{0,38040071,5}],attr = [{2,72000},{4,2160}],special_attr = []};

get_strength_cfg(4,6,10) ->
	#base_constellation_strength{equip_type = 4,pos = 6,lv = 10,cost = [{0,38040070,14},{0,38040071,6},{0,38040072,1}],attr = [{2,80000},{4,2400}],special_attr = []};

get_strength_cfg(4,6,11) ->
	#base_constellation_strength{equip_type = 4,pos = 6,lv = 11,cost = [{0,38040070,16},{0,38040071,7},{0,38040072,2}],attr = [{2,88000},{4,2640}],special_attr = []};

get_strength_cfg(4,6,12) ->
	#base_constellation_strength{equip_type = 4,pos = 6,lv = 12,cost = [{0,38040070,18},{0,38040071,8},{0,38040072,3}],attr = [{2,96000},{4,2880}],special_attr = []};

get_strength_cfg(4,6,13) ->
	#base_constellation_strength{equip_type = 4,pos = 6,lv = 13,cost = [{0,38040070,20},{0,38040071,9},{0,38040072,4}],attr = [{2,104000},{4,3120}],special_attr = []};

get_strength_cfg(4,6,14) ->
	#base_constellation_strength{equip_type = 4,pos = 6,lv = 14,cost = [{0,38040070,22},{0,38040071,10},{0,38040072,5}],attr = [{2,112000},{4,3360}],special_attr = []};

get_strength_cfg(4,6,15) ->
	#base_constellation_strength{equip_type = 4,pos = 6,lv = 15,cost = [],attr = [{2,120000},{4,3600}],special_attr = []};

get_strength_cfg(4,7,0) ->
	#base_constellation_strength{equip_type = 4,pos = 7,lv = 0,cost = [{0,38040075,1}],attr = [{1,0},{3,0}],special_attr = []};

get_strength_cfg(4,7,1) ->
	#base_constellation_strength{equip_type = 4,pos = 7,lv = 1,cost = [{0,38040075,2}],attr = [{1,200},{3,120}],special_attr = []};

get_strength_cfg(4,7,2) ->
	#base_constellation_strength{equip_type = 4,pos = 7,lv = 2,cost = [{0,38040075,3}],attr = [{1,400},{3,240}],special_attr = []};

get_strength_cfg(4,7,3) ->
	#base_constellation_strength{equip_type = 4,pos = 7,lv = 3,cost = [{0,38040075,4}],attr = [{1,600},{3,360}],special_attr = [{21,150}]};

get_strength_cfg(4,7,4) ->
	#base_constellation_strength{equip_type = 4,pos = 7,lv = 4,cost = [{0,38040075,4}],attr = [{1,800},{3,480}],special_attr = []};

get_strength_cfg(4,7,5) ->
	#base_constellation_strength{equip_type = 4,pos = 7,lv = 5,cost = [{0,38040075,5}],attr = [{1,1000},{3,600}],special_attr = []};

get_strength_cfg(4,7,6) ->
	#base_constellation_strength{equip_type = 4,pos = 7,lv = 6,cost = [{0,38040075,5}],attr = [{1,1200},{3,720}],special_attr = []};

get_strength_cfg(4,7,7) ->
	#base_constellation_strength{equip_type = 4,pos = 7,lv = 7,cost = [{0,38040075,6}],attr = [{1,1400},{3,840}],special_attr = [{19,70}]};

get_strength_cfg(4,7,8) ->
	#base_constellation_strength{equip_type = 4,pos = 7,lv = 8,cost = [{0,38040075,6}],attr = [{1,1600},{3,960}],special_attr = []};

get_strength_cfg(4,7,9) ->
	#base_constellation_strength{equip_type = 4,pos = 7,lv = 9,cost = [{0,38040075,7}],attr = [{1,1800},{3,1080}],special_attr = []};

get_strength_cfg(4,7,10) ->
	#base_constellation_strength{equip_type = 4,pos = 7,lv = 10,cost = [{0,38040075,7}],attr = [{1,2000},{3,1200}],special_attr = []};

get_strength_cfg(4,7,11) ->
	#base_constellation_strength{equip_type = 4,pos = 7,lv = 11,cost = [{0,38040075,8}],attr = [{1,2200},{3,1320}],special_attr = [{19,70}]};

get_strength_cfg(4,7,12) ->
	#base_constellation_strength{equip_type = 4,pos = 7,lv = 12,cost = [{0,38040075,8}],attr = [{1,2400},{3,1440}],special_attr = []};

get_strength_cfg(4,7,13) ->
	#base_constellation_strength{equip_type = 4,pos = 7,lv = 13,cost = [{0,38040075,9}],attr = [{1,2600},{3,1560}],special_attr = []};

get_strength_cfg(4,7,14) ->
	#base_constellation_strength{equip_type = 4,pos = 7,lv = 14,cost = [{0,38040075,9}],attr = [{1,2800},{3,1680}],special_attr = [{27,140}]};

get_strength_cfg(4,7,15) ->
	#base_constellation_strength{equip_type = 4,pos = 7,lv = 15,cost = [{0,38040075,10}],attr = [{1,3000},{3,1800}],special_attr = []};

get_strength_cfg(4,7,16) ->
	#base_constellation_strength{equip_type = 4,pos = 7,lv = 16,cost = [{0,38040075,10}],attr = [{1,3200},{3,1920}],special_attr = []};

get_strength_cfg(4,7,17) ->
	#base_constellation_strength{equip_type = 4,pos = 7,lv = 17,cost = [{0,38040075,12}],attr = [{1,3400},{3,2040}],special_attr = [{19,70}]};

get_strength_cfg(4,7,18) ->
	#base_constellation_strength{equip_type = 4,pos = 7,lv = 18,cost = [{0,38040075,12}],attr = [{1,3600},{3,2160}],special_attr = []};

get_strength_cfg(4,7,19) ->
	#base_constellation_strength{equip_type = 4,pos = 7,lv = 19,cost = [{0,38040075,15}],attr = [{1,3800},{3,2280}],special_attr = []};

get_strength_cfg(4,7,20) ->
	#base_constellation_strength{equip_type = 4,pos = 7,lv = 20,cost = [],attr = [{1,4000},{3,2400}],special_attr = []};

get_strength_cfg(4,8,0) ->
	#base_constellation_strength{equip_type = 4,pos = 8,lv = 0,cost = [{0,38040075,1}],attr = [{2,0},{4,0}],special_attr = []};

get_strength_cfg(4,8,1) ->
	#base_constellation_strength{equip_type = 4,pos = 8,lv = 1,cost = [{0,38040075,2}],attr = [{2,4000},{4,120}],special_attr = []};

get_strength_cfg(4,8,2) ->
	#base_constellation_strength{equip_type = 4,pos = 8,lv = 2,cost = [{0,38040075,3}],attr = [{2,8000},{4,240}],special_attr = []};

get_strength_cfg(4,8,3) ->
	#base_constellation_strength{equip_type = 4,pos = 8,lv = 3,cost = [{0,38040075,4}],attr = [{2,12000},{4,360}],special_attr = [{22,120}]};

get_strength_cfg(4,8,4) ->
	#base_constellation_strength{equip_type = 4,pos = 8,lv = 4,cost = [{0,38040075,4}],attr = [{2,16000},{4,480}],special_attr = []};

get_strength_cfg(4,8,5) ->
	#base_constellation_strength{equip_type = 4,pos = 8,lv = 5,cost = [{0,38040075,5}],attr = [{2,20000},{4,600}],special_attr = []};

get_strength_cfg(4,8,6) ->
	#base_constellation_strength{equip_type = 4,pos = 8,lv = 6,cost = [{0,38040075,5}],attr = [{2,24000},{4,720}],special_attr = []};

get_strength_cfg(4,8,7) ->
	#base_constellation_strength{equip_type = 4,pos = 8,lv = 7,cost = [{0,38040075,6}],attr = [{2,28000},{4,840}],special_attr = [{20,70}]};

get_strength_cfg(4,8,8) ->
	#base_constellation_strength{equip_type = 4,pos = 8,lv = 8,cost = [{0,38040075,6}],attr = [{2,32000},{4,960}],special_attr = []};

get_strength_cfg(4,8,9) ->
	#base_constellation_strength{equip_type = 4,pos = 8,lv = 9,cost = [{0,38040075,7}],attr = [{2,36000},{4,1080}],special_attr = []};

get_strength_cfg(4,8,10) ->
	#base_constellation_strength{equip_type = 4,pos = 8,lv = 10,cost = [{0,38040075,7}],attr = [{2,40000},{4,1200}],special_attr = []};

get_strength_cfg(4,8,11) ->
	#base_constellation_strength{equip_type = 4,pos = 8,lv = 11,cost = [{0,38040075,8}],attr = [{2,44000},{4,1320}],special_attr = [{20,70}]};

get_strength_cfg(4,8,12) ->
	#base_constellation_strength{equip_type = 4,pos = 8,lv = 12,cost = [{0,38040075,8}],attr = [{2,48000},{4,1440}],special_attr = []};

get_strength_cfg(4,8,13) ->
	#base_constellation_strength{equip_type = 4,pos = 8,lv = 13,cost = [{0,38040075,9}],attr = [{2,52000},{4,1560}],special_attr = []};

get_strength_cfg(4,8,14) ->
	#base_constellation_strength{equip_type = 4,pos = 8,lv = 14,cost = [{0,38040075,9}],attr = [{2,56000},{4,1680}],special_attr = [{28,140}]};

get_strength_cfg(4,8,15) ->
	#base_constellation_strength{equip_type = 4,pos = 8,lv = 15,cost = [{0,38040075,10}],attr = [{2,60000},{4,1800}],special_attr = []};

get_strength_cfg(4,8,16) ->
	#base_constellation_strength{equip_type = 4,pos = 8,lv = 16,cost = [{0,38040075,10}],attr = [{2,64000},{4,1920}],special_attr = []};

get_strength_cfg(4,8,17) ->
	#base_constellation_strength{equip_type = 4,pos = 8,lv = 17,cost = [{0,38040075,12}],attr = [{2,68000},{4,2040}],special_attr = [{20,70}]};

get_strength_cfg(4,8,18) ->
	#base_constellation_strength{equip_type = 4,pos = 8,lv = 18,cost = [{0,38040075,12}],attr = [{2,72000},{4,2160}],special_attr = []};

get_strength_cfg(4,8,19) ->
	#base_constellation_strength{equip_type = 4,pos = 8,lv = 19,cost = [{0,38040075,15}],attr = [{2,76000},{4,2280}],special_attr = []};

get_strength_cfg(4,8,20) ->
	#base_constellation_strength{equip_type = 4,pos = 8,lv = 20,cost = [],attr = [{2,80000},{4,2400}],special_attr = []};

get_strength_cfg(4,9,0) ->
	#base_constellation_strength{equip_type = 4,pos = 9,lv = 0,cost = [{0,38040075,1}],attr = [{1,0},{3,0}],special_attr = []};

get_strength_cfg(4,9,1) ->
	#base_constellation_strength{equip_type = 4,pos = 9,lv = 1,cost = [{0,38040075,2}],attr = [{1,200},{3,120}],special_attr = []};

get_strength_cfg(4,9,2) ->
	#base_constellation_strength{equip_type = 4,pos = 9,lv = 2,cost = [{0,38040075,3}],attr = [{1,400},{3,240}],special_attr = []};

get_strength_cfg(4,9,3) ->
	#base_constellation_strength{equip_type = 4,pos = 9,lv = 3,cost = [{0,38040075,4}],attr = [{1,600},{3,360}],special_attr = [{21,150}]};

get_strength_cfg(4,9,4) ->
	#base_constellation_strength{equip_type = 4,pos = 9,lv = 4,cost = [{0,38040075,4}],attr = [{1,800},{3,480}],special_attr = []};

get_strength_cfg(4,9,5) ->
	#base_constellation_strength{equip_type = 4,pos = 9,lv = 5,cost = [{0,38040075,5}],attr = [{1,1000},{3,600}],special_attr = []};

get_strength_cfg(4,9,6) ->
	#base_constellation_strength{equip_type = 4,pos = 9,lv = 6,cost = [{0,38040075,5}],attr = [{1,1200},{3,720}],special_attr = []};

get_strength_cfg(4,9,7) ->
	#base_constellation_strength{equip_type = 4,pos = 9,lv = 7,cost = [{0,38040075,6}],attr = [{1,1400},{3,840}],special_attr = [{19,70}]};

get_strength_cfg(4,9,8) ->
	#base_constellation_strength{equip_type = 4,pos = 9,lv = 8,cost = [{0,38040075,6}],attr = [{1,1600},{3,960}],special_attr = []};

get_strength_cfg(4,9,9) ->
	#base_constellation_strength{equip_type = 4,pos = 9,lv = 9,cost = [{0,38040075,7}],attr = [{1,1800},{3,1080}],special_attr = []};

get_strength_cfg(4,9,10) ->
	#base_constellation_strength{equip_type = 4,pos = 9,lv = 10,cost = [{0,38040075,7}],attr = [{1,2000},{3,1200}],special_attr = []};

get_strength_cfg(4,9,11) ->
	#base_constellation_strength{equip_type = 4,pos = 9,lv = 11,cost = [{0,38040075,8}],attr = [{1,2200},{3,1320}],special_attr = [{19,70}]};

get_strength_cfg(4,9,12) ->
	#base_constellation_strength{equip_type = 4,pos = 9,lv = 12,cost = [{0,38040075,8}],attr = [{1,2400},{3,1440}],special_attr = []};

get_strength_cfg(4,9,13) ->
	#base_constellation_strength{equip_type = 4,pos = 9,lv = 13,cost = [{0,38040075,9}],attr = [{1,2600},{3,1560}],special_attr = []};

get_strength_cfg(4,9,14) ->
	#base_constellation_strength{equip_type = 4,pos = 9,lv = 14,cost = [{0,38040075,9}],attr = [{1,2800},{3,1680}],special_attr = [{37,240}]};

get_strength_cfg(4,9,15) ->
	#base_constellation_strength{equip_type = 4,pos = 9,lv = 15,cost = [{0,38040075,10}],attr = [{1,3000},{3,1800}],special_attr = []};

get_strength_cfg(4,9,16) ->
	#base_constellation_strength{equip_type = 4,pos = 9,lv = 16,cost = [{0,38040075,10}],attr = [{1,3200},{3,1920}],special_attr = []};

get_strength_cfg(4,9,17) ->
	#base_constellation_strength{equip_type = 4,pos = 9,lv = 17,cost = [{0,38040075,12}],attr = [{1,3400},{3,2040}],special_attr = [{19,70}]};

get_strength_cfg(4,9,18) ->
	#base_constellation_strength{equip_type = 4,pos = 9,lv = 18,cost = [{0,38040075,12}],attr = [{1,3600},{3,2160}],special_attr = []};

get_strength_cfg(4,9,19) ->
	#base_constellation_strength{equip_type = 4,pos = 9,lv = 19,cost = [{0,38040075,15}],attr = [{1,3800},{3,2280}],special_attr = []};

get_strength_cfg(4,9,20) ->
	#base_constellation_strength{equip_type = 4,pos = 9,lv = 20,cost = [],attr = [{1,4000},{3,2400}],special_attr = []};

get_strength_cfg(4,10,0) ->
	#base_constellation_strength{equip_type = 4,pos = 10,lv = 0,cost = [{0,38040075,1}],attr = [{1,0},{3,0}],special_attr = []};

get_strength_cfg(4,10,1) ->
	#base_constellation_strength{equip_type = 4,pos = 10,lv = 1,cost = [{0,38040075,2}],attr = [{1,200},{3,120}],special_attr = []};

get_strength_cfg(4,10,2) ->
	#base_constellation_strength{equip_type = 4,pos = 10,lv = 2,cost = [{0,38040075,3}],attr = [{1,400},{3,240}],special_attr = []};

get_strength_cfg(4,10,3) ->
	#base_constellation_strength{equip_type = 4,pos = 10,lv = 3,cost = [{0,38040075,4}],attr = [{1,600},{3,360}],special_attr = [{22,120}]};

get_strength_cfg(4,10,4) ->
	#base_constellation_strength{equip_type = 4,pos = 10,lv = 4,cost = [{0,38040075,4}],attr = [{1,800},{3,480}],special_attr = []};

get_strength_cfg(4,10,5) ->
	#base_constellation_strength{equip_type = 4,pos = 10,lv = 5,cost = [{0,38040075,5}],attr = [{1,1000},{3,600}],special_attr = []};

get_strength_cfg(4,10,6) ->
	#base_constellation_strength{equip_type = 4,pos = 10,lv = 6,cost = [{0,38040075,5}],attr = [{1,1200},{3,720}],special_attr = []};

get_strength_cfg(4,10,7) ->
	#base_constellation_strength{equip_type = 4,pos = 10,lv = 7,cost = [{0,38040075,6}],attr = [{1,1400},{3,840}],special_attr = [{20,70}]};

get_strength_cfg(4,10,8) ->
	#base_constellation_strength{equip_type = 4,pos = 10,lv = 8,cost = [{0,38040075,6}],attr = [{1,1600},{3,960}],special_attr = []};

get_strength_cfg(4,10,9) ->
	#base_constellation_strength{equip_type = 4,pos = 10,lv = 9,cost = [{0,38040075,7}],attr = [{1,1800},{3,1080}],special_attr = []};

get_strength_cfg(4,10,10) ->
	#base_constellation_strength{equip_type = 4,pos = 10,lv = 10,cost = [{0,38040075,7}],attr = [{1,2000},{3,1200}],special_attr = []};

get_strength_cfg(4,10,11) ->
	#base_constellation_strength{equip_type = 4,pos = 10,lv = 11,cost = [{0,38040075,8}],attr = [{1,2200},{3,1320}],special_attr = [{20,70}]};

get_strength_cfg(4,10,12) ->
	#base_constellation_strength{equip_type = 4,pos = 10,lv = 12,cost = [{0,38040075,8}],attr = [{1,2400},{3,1440}],special_attr = []};

get_strength_cfg(4,10,13) ->
	#base_constellation_strength{equip_type = 4,pos = 10,lv = 13,cost = [{0,38040075,9}],attr = [{1,2600},{3,1560}],special_attr = []};

get_strength_cfg(4,10,14) ->
	#base_constellation_strength{equip_type = 4,pos = 10,lv = 14,cost = [{0,38040075,9}],attr = [{1,2800},{3,1680}],special_attr = [{38,240}]};

get_strength_cfg(4,10,15) ->
	#base_constellation_strength{equip_type = 4,pos = 10,lv = 15,cost = [{0,38040075,10}],attr = [{1,3000},{3,1800}],special_attr = []};

get_strength_cfg(4,10,16) ->
	#base_constellation_strength{equip_type = 4,pos = 10,lv = 16,cost = [{0,38040075,10}],attr = [{1,3200},{3,1920}],special_attr = []};

get_strength_cfg(4,10,17) ->
	#base_constellation_strength{equip_type = 4,pos = 10,lv = 17,cost = [{0,38040075,12}],attr = [{1,3400},{3,2040}],special_attr = [{20,70}]};

get_strength_cfg(4,10,18) ->
	#base_constellation_strength{equip_type = 4,pos = 10,lv = 18,cost = [{0,38040075,12}],attr = [{1,3600},{3,2160}],special_attr = []};

get_strength_cfg(4,10,19) ->
	#base_constellation_strength{equip_type = 4,pos = 10,lv = 19,cost = [{0,38040075,15}],attr = [{1,3800},{3,2280}],special_attr = []};

get_strength_cfg(4,10,20) ->
	#base_constellation_strength{equip_type = 4,pos = 10,lv = 20,cost = [],attr = [{1,4000},{3,2400}],special_attr = []};

get_strength_cfg(5,1,0) ->
	#base_constellation_strength{equip_type = 5,pos = 1,lv = 0,cost = [{0,38040070,1}],attr = [{1,0},{3,0}],special_attr = []};

get_strength_cfg(5,1,1) ->
	#base_constellation_strength{equip_type = 5,pos = 1,lv = 1,cost = [{0,38040070,2}],attr = [{1,480},{3,288}],special_attr = []};

get_strength_cfg(5,1,2) ->
	#base_constellation_strength{equip_type = 5,pos = 1,lv = 2,cost = [{0,38040070,3}],attr = [{1,960},{3,576}],special_attr = []};

get_strength_cfg(5,1,3) ->
	#base_constellation_strength{equip_type = 5,pos = 1,lv = 3,cost = [{0,38040070,4}],attr = [{1,1440},{3,864}],special_attr = []};

get_strength_cfg(5,1,4) ->
	#base_constellation_strength{equip_type = 5,pos = 1,lv = 4,cost = [{0,38040070,5}],attr = [{1,1920},{3,1152}],special_attr = []};

get_strength_cfg(5,1,5) ->
	#base_constellation_strength{equip_type = 5,pos = 1,lv = 5,cost = [{0,38040070,6},{0,38040071,1}],attr = [{1,2400},{3,1440}],special_attr = []};

get_strength_cfg(5,1,6) ->
	#base_constellation_strength{equip_type = 5,pos = 1,lv = 6,cost = [{0,38040070,7},{0,38040071,2}],attr = [{1,2880},{3,1728}],special_attr = []};

get_strength_cfg(5,1,7) ->
	#base_constellation_strength{equip_type = 5,pos = 1,lv = 7,cost = [{0,38040070,8},{0,38040071,3}],attr = [{1,3360},{3,2016}],special_attr = []};

get_strength_cfg(5,1,8) ->
	#base_constellation_strength{equip_type = 5,pos = 1,lv = 8,cost = [{0,38040070,10},{0,38040071,4}],attr = [{1,3840},{3,2304}],special_attr = []};

get_strength_cfg(5,1,9) ->
	#base_constellation_strength{equip_type = 5,pos = 1,lv = 9,cost = [{0,38040070,12},{0,38040071,5}],attr = [{1,4320},{3,2592}],special_attr = []};

get_strength_cfg(5,1,10) ->
	#base_constellation_strength{equip_type = 5,pos = 1,lv = 10,cost = [{0,38040070,14},{0,38040071,6},{0,38040072,1}],attr = [{1,4800},{3,2880}],special_attr = []};

get_strength_cfg(5,1,11) ->
	#base_constellation_strength{equip_type = 5,pos = 1,lv = 11,cost = [{0,38040070,16},{0,38040071,7},{0,38040072,2}],attr = [{1,5280},{3,3168}],special_attr = []};

get_strength_cfg(5,1,12) ->
	#base_constellation_strength{equip_type = 5,pos = 1,lv = 12,cost = [{0,38040070,18},{0,38040071,8},{0,38040072,3}],attr = [{1,5760},{3,3456}],special_attr = []};

get_strength_cfg(5,1,13) ->
	#base_constellation_strength{equip_type = 5,pos = 1,lv = 13,cost = [{0,38040070,20},{0,38040071,9},{0,38040072,4}],attr = [{1,6240},{3,3744}],special_attr = []};

get_strength_cfg(5,1,14) ->
	#base_constellation_strength{equip_type = 5,pos = 1,lv = 14,cost = [{0,38040070,22},{0,38040071,10},{0,38040072,5}],attr = [{1,6720},{3,4032}],special_attr = []};

get_strength_cfg(5,1,15) ->
	#base_constellation_strength{equip_type = 5,pos = 1,lv = 15,cost = [{0,38040070,25},{0,38040071,11},{0,38040072,6}],attr = [{1,7200},{3,4320}],special_attr = []};

get_strength_cfg(5,1,16) ->
	#base_constellation_strength{equip_type = 5,pos = 1,lv = 16,cost = [{0,38040070,30},{0,38040071,12},{0,38040072,7}],attr = [{1,7680},{3,4608}],special_attr = []};

get_strength_cfg(5,1,17) ->
	#base_constellation_strength{equip_type = 5,pos = 1,lv = 17,cost = [],attr = [{1,8160},{3,4896}],special_attr = []};

get_strength_cfg(5,2,0) ->
	#base_constellation_strength{equip_type = 5,pos = 2,lv = 0,cost = [{0,38040070,1}],attr = [{2,0},{4,0}],special_attr = []};

get_strength_cfg(5,2,1) ->
	#base_constellation_strength{equip_type = 5,pos = 2,lv = 1,cost = [{0,38040070,2}],attr = [{2,9600},{4,288}],special_attr = []};

get_strength_cfg(5,2,2) ->
	#base_constellation_strength{equip_type = 5,pos = 2,lv = 2,cost = [{0,38040070,3}],attr = [{2,19200},{4,576}],special_attr = []};

get_strength_cfg(5,2,3) ->
	#base_constellation_strength{equip_type = 5,pos = 2,lv = 3,cost = [{0,38040070,4}],attr = [{2,28800},{4,864}],special_attr = []};

get_strength_cfg(5,2,4) ->
	#base_constellation_strength{equip_type = 5,pos = 2,lv = 4,cost = [{0,38040070,5}],attr = [{2,38400},{4,1152}],special_attr = []};

get_strength_cfg(5,2,5) ->
	#base_constellation_strength{equip_type = 5,pos = 2,lv = 5,cost = [{0,38040070,6},{0,38040071,1}],attr = [{2,48000},{4,1440}],special_attr = []};

get_strength_cfg(5,2,6) ->
	#base_constellation_strength{equip_type = 5,pos = 2,lv = 6,cost = [{0,38040070,7},{0,38040071,2}],attr = [{2,57600},{4,1728}],special_attr = []};

get_strength_cfg(5,2,7) ->
	#base_constellation_strength{equip_type = 5,pos = 2,lv = 7,cost = [{0,38040070,8},{0,38040071,3}],attr = [{2,67200},{4,2016}],special_attr = []};

get_strength_cfg(5,2,8) ->
	#base_constellation_strength{equip_type = 5,pos = 2,lv = 8,cost = [{0,38040070,10},{0,38040071,4}],attr = [{2,76800},{4,2304}],special_attr = []};

get_strength_cfg(5,2,9) ->
	#base_constellation_strength{equip_type = 5,pos = 2,lv = 9,cost = [{0,38040070,12},{0,38040071,5}],attr = [{2,86400},{4,2592}],special_attr = []};

get_strength_cfg(5,2,10) ->
	#base_constellation_strength{equip_type = 5,pos = 2,lv = 10,cost = [{0,38040070,14},{0,38040071,6},{0,38040072,1}],attr = [{2,96000},{4,2880}],special_attr = []};

get_strength_cfg(5,2,11) ->
	#base_constellation_strength{equip_type = 5,pos = 2,lv = 11,cost = [{0,38040070,16},{0,38040071,7},{0,38040072,2}],attr = [{2,105600},{4,3168}],special_attr = []};

get_strength_cfg(5,2,12) ->
	#base_constellation_strength{equip_type = 5,pos = 2,lv = 12,cost = [{0,38040070,18},{0,38040071,8},{0,38040072,3}],attr = [{2,115200},{4,3456}],special_attr = []};

get_strength_cfg(5,2,13) ->
	#base_constellation_strength{equip_type = 5,pos = 2,lv = 13,cost = [{0,38040070,20},{0,38040071,9},{0,38040072,4}],attr = [{2,124800},{4,3744}],special_attr = []};

get_strength_cfg(5,2,14) ->
	#base_constellation_strength{equip_type = 5,pos = 2,lv = 14,cost = [{0,38040070,22},{0,38040071,10},{0,38040072,5}],attr = [{2,134400},{4,4032}],special_attr = []};

get_strength_cfg(5,2,15) ->
	#base_constellation_strength{equip_type = 5,pos = 2,lv = 15,cost = [{0,38040070,25},{0,38040071,11},{0,38040072,6}],attr = [{2,144000},{4,4320}],special_attr = []};

get_strength_cfg(5,2,16) ->
	#base_constellation_strength{equip_type = 5,pos = 2,lv = 16,cost = [{0,38040070,30},{0,38040071,12},{0,38040072,7}],attr = [{2,153600},{4,4608}],special_attr = []};

get_strength_cfg(5,2,17) ->
	#base_constellation_strength{equip_type = 5,pos = 2,lv = 17,cost = [],attr = [{2,163200},{4,4896}],special_attr = []};

get_strength_cfg(5,3,0) ->
	#base_constellation_strength{equip_type = 5,pos = 3,lv = 0,cost = [{0,38040070,1}],attr = [{2,0},{4,0}],special_attr = []};

get_strength_cfg(5,3,1) ->
	#base_constellation_strength{equip_type = 5,pos = 3,lv = 1,cost = [{0,38040070,2}],attr = [{2,9600},{4,288}],special_attr = []};

get_strength_cfg(5,3,2) ->
	#base_constellation_strength{equip_type = 5,pos = 3,lv = 2,cost = [{0,38040070,3}],attr = [{2,19200},{4,576}],special_attr = []};

get_strength_cfg(5,3,3) ->
	#base_constellation_strength{equip_type = 5,pos = 3,lv = 3,cost = [{0,38040070,4}],attr = [{2,28800},{4,864}],special_attr = []};

get_strength_cfg(5,3,4) ->
	#base_constellation_strength{equip_type = 5,pos = 3,lv = 4,cost = [{0,38040070,5}],attr = [{2,38400},{4,1152}],special_attr = []};

get_strength_cfg(5,3,5) ->
	#base_constellation_strength{equip_type = 5,pos = 3,lv = 5,cost = [{0,38040070,6},{0,38040071,1}],attr = [{2,48000},{4,1440}],special_attr = []};

get_strength_cfg(5,3,6) ->
	#base_constellation_strength{equip_type = 5,pos = 3,lv = 6,cost = [{0,38040070,7},{0,38040071,2}],attr = [{2,57600},{4,1728}],special_attr = []};

get_strength_cfg(5,3,7) ->
	#base_constellation_strength{equip_type = 5,pos = 3,lv = 7,cost = [{0,38040070,8},{0,38040071,3}],attr = [{2,67200},{4,2016}],special_attr = []};

get_strength_cfg(5,3,8) ->
	#base_constellation_strength{equip_type = 5,pos = 3,lv = 8,cost = [{0,38040070,10},{0,38040071,4}],attr = [{2,76800},{4,2304}],special_attr = []};

get_strength_cfg(5,3,9) ->
	#base_constellation_strength{equip_type = 5,pos = 3,lv = 9,cost = [{0,38040070,12},{0,38040071,5}],attr = [{2,86400},{4,2592}],special_attr = []};

get_strength_cfg(5,3,10) ->
	#base_constellation_strength{equip_type = 5,pos = 3,lv = 10,cost = [{0,38040070,14},{0,38040071,6},{0,38040072,1}],attr = [{2,96000},{4,2880}],special_attr = []};

get_strength_cfg(5,3,11) ->
	#base_constellation_strength{equip_type = 5,pos = 3,lv = 11,cost = [{0,38040070,16},{0,38040071,7},{0,38040072,2}],attr = [{2,105600},{4,3168}],special_attr = []};

get_strength_cfg(5,3,12) ->
	#base_constellation_strength{equip_type = 5,pos = 3,lv = 12,cost = [{0,38040070,18},{0,38040071,8},{0,38040072,3}],attr = [{2,115200},{4,3456}],special_attr = []};

get_strength_cfg(5,3,13) ->
	#base_constellation_strength{equip_type = 5,pos = 3,lv = 13,cost = [{0,38040070,20},{0,38040071,9},{0,38040072,4}],attr = [{2,124800},{4,3744}],special_attr = []};

get_strength_cfg(5,3,14) ->
	#base_constellation_strength{equip_type = 5,pos = 3,lv = 14,cost = [{0,38040070,22},{0,38040071,10},{0,38040072,5}],attr = [{2,134400},{4,4032}],special_attr = []};

get_strength_cfg(5,3,15) ->
	#base_constellation_strength{equip_type = 5,pos = 3,lv = 15,cost = [{0,38040070,25},{0,38040071,11},{0,38040072,6}],attr = [{2,144000},{4,4320}],special_attr = []};

get_strength_cfg(5,3,16) ->
	#base_constellation_strength{equip_type = 5,pos = 3,lv = 16,cost = [{0,38040070,30},{0,38040071,12},{0,38040072,7}],attr = [{2,153600},{4,4608}],special_attr = []};

get_strength_cfg(5,3,17) ->
	#base_constellation_strength{equip_type = 5,pos = 3,lv = 17,cost = [],attr = [{2,163200},{4,4896}],special_attr = []};

get_strength_cfg(5,4,0) ->
	#base_constellation_strength{equip_type = 5,pos = 4,lv = 0,cost = [{0,38040070,1}],attr = [{2,0},{4,0}],special_attr = []};

get_strength_cfg(5,4,1) ->
	#base_constellation_strength{equip_type = 5,pos = 4,lv = 1,cost = [{0,38040070,2}],attr = [{2,9600},{4,288}],special_attr = []};

get_strength_cfg(5,4,2) ->
	#base_constellation_strength{equip_type = 5,pos = 4,lv = 2,cost = [{0,38040070,3}],attr = [{2,19200},{4,576}],special_attr = []};

get_strength_cfg(5,4,3) ->
	#base_constellation_strength{equip_type = 5,pos = 4,lv = 3,cost = [{0,38040070,4}],attr = [{2,28800},{4,864}],special_attr = []};

get_strength_cfg(5,4,4) ->
	#base_constellation_strength{equip_type = 5,pos = 4,lv = 4,cost = [{0,38040070,5}],attr = [{2,38400},{4,1152}],special_attr = []};

get_strength_cfg(5,4,5) ->
	#base_constellation_strength{equip_type = 5,pos = 4,lv = 5,cost = [{0,38040070,6},{0,38040071,1}],attr = [{2,48000},{4,1440}],special_attr = []};

get_strength_cfg(5,4,6) ->
	#base_constellation_strength{equip_type = 5,pos = 4,lv = 6,cost = [{0,38040070,7},{0,38040071,2}],attr = [{2,57600},{4,1728}],special_attr = []};

get_strength_cfg(5,4,7) ->
	#base_constellation_strength{equip_type = 5,pos = 4,lv = 7,cost = [{0,38040070,8},{0,38040071,3}],attr = [{2,67200},{4,2016}],special_attr = []};

get_strength_cfg(5,4,8) ->
	#base_constellation_strength{equip_type = 5,pos = 4,lv = 8,cost = [{0,38040070,10},{0,38040071,4}],attr = [{2,76800},{4,2304}],special_attr = []};

get_strength_cfg(5,4,9) ->
	#base_constellation_strength{equip_type = 5,pos = 4,lv = 9,cost = [{0,38040070,12},{0,38040071,5}],attr = [{2,86400},{4,2592}],special_attr = []};

get_strength_cfg(5,4,10) ->
	#base_constellation_strength{equip_type = 5,pos = 4,lv = 10,cost = [{0,38040070,14},{0,38040071,6},{0,38040072,1}],attr = [{2,96000},{4,2880}],special_attr = []};

get_strength_cfg(5,4,11) ->
	#base_constellation_strength{equip_type = 5,pos = 4,lv = 11,cost = [{0,38040070,16},{0,38040071,7},{0,38040072,2}],attr = [{2,105600},{4,3168}],special_attr = []};

get_strength_cfg(5,4,12) ->
	#base_constellation_strength{equip_type = 5,pos = 4,lv = 12,cost = [{0,38040070,18},{0,38040071,8},{0,38040072,3}],attr = [{2,115200},{4,3456}],special_attr = []};

get_strength_cfg(5,4,13) ->
	#base_constellation_strength{equip_type = 5,pos = 4,lv = 13,cost = [{0,38040070,20},{0,38040071,9},{0,38040072,4}],attr = [{2,124800},{4,3744}],special_attr = []};

get_strength_cfg(5,4,14) ->
	#base_constellation_strength{equip_type = 5,pos = 4,lv = 14,cost = [{0,38040070,22},{0,38040071,10},{0,38040072,5}],attr = [{2,134400},{4,4032}],special_attr = []};

get_strength_cfg(5,4,15) ->
	#base_constellation_strength{equip_type = 5,pos = 4,lv = 15,cost = [{0,38040070,25},{0,38040071,11},{0,38040072,6}],attr = [{2,144000},{4,4320}],special_attr = []};

get_strength_cfg(5,4,16) ->
	#base_constellation_strength{equip_type = 5,pos = 4,lv = 16,cost = [{0,38040070,30},{0,38040071,12},{0,38040072,7}],attr = [{2,153600},{4,4608}],special_attr = []};

get_strength_cfg(5,4,17) ->
	#base_constellation_strength{equip_type = 5,pos = 4,lv = 17,cost = [],attr = [{2,163200},{4,4896}],special_attr = []};

get_strength_cfg(5,5,0) ->
	#base_constellation_strength{equip_type = 5,pos = 5,lv = 0,cost = [{0,38040070,1}],attr = [{1,0},{3,0}],special_attr = []};

get_strength_cfg(5,5,1) ->
	#base_constellation_strength{equip_type = 5,pos = 5,lv = 1,cost = [{0,38040070,2}],attr = [{1,480},{3,288}],special_attr = []};

get_strength_cfg(5,5,2) ->
	#base_constellation_strength{equip_type = 5,pos = 5,lv = 2,cost = [{0,38040070,3}],attr = [{1,960},{3,576}],special_attr = []};

get_strength_cfg(5,5,3) ->
	#base_constellation_strength{equip_type = 5,pos = 5,lv = 3,cost = [{0,38040070,4}],attr = [{1,1440},{3,864}],special_attr = []};

get_strength_cfg(5,5,4) ->
	#base_constellation_strength{equip_type = 5,pos = 5,lv = 4,cost = [{0,38040070,5}],attr = [{1,1920},{3,1152}],special_attr = []};

get_strength_cfg(5,5,5) ->
	#base_constellation_strength{equip_type = 5,pos = 5,lv = 5,cost = [{0,38040070,6},{0,38040071,1}],attr = [{1,2400},{3,1440}],special_attr = []};

get_strength_cfg(5,5,6) ->
	#base_constellation_strength{equip_type = 5,pos = 5,lv = 6,cost = [{0,38040070,7},{0,38040071,2}],attr = [{1,2880},{3,1728}],special_attr = []};

get_strength_cfg(5,5,7) ->
	#base_constellation_strength{equip_type = 5,pos = 5,lv = 7,cost = [{0,38040070,8},{0,38040071,3}],attr = [{1,3360},{3,2016}],special_attr = []};

get_strength_cfg(5,5,8) ->
	#base_constellation_strength{equip_type = 5,pos = 5,lv = 8,cost = [{0,38040070,10},{0,38040071,4}],attr = [{1,3840},{3,2304}],special_attr = []};

get_strength_cfg(5,5,9) ->
	#base_constellation_strength{equip_type = 5,pos = 5,lv = 9,cost = [{0,38040070,12},{0,38040071,5}],attr = [{1,4320},{3,2592}],special_attr = []};

get_strength_cfg(5,5,10) ->
	#base_constellation_strength{equip_type = 5,pos = 5,lv = 10,cost = [{0,38040070,14},{0,38040071,6},{0,38040072,1}],attr = [{1,4800},{3,2880}],special_attr = []};

get_strength_cfg(5,5,11) ->
	#base_constellation_strength{equip_type = 5,pos = 5,lv = 11,cost = [{0,38040070,16},{0,38040071,7},{0,38040072,2}],attr = [{1,5280},{3,3168}],special_attr = []};

get_strength_cfg(5,5,12) ->
	#base_constellation_strength{equip_type = 5,pos = 5,lv = 12,cost = [{0,38040070,18},{0,38040071,8},{0,38040072,3}],attr = [{1,5760},{3,3456}],special_attr = []};

get_strength_cfg(5,5,13) ->
	#base_constellation_strength{equip_type = 5,pos = 5,lv = 13,cost = [{0,38040070,20},{0,38040071,9},{0,38040072,4}],attr = [{1,6240},{3,3744}],special_attr = []};

get_strength_cfg(5,5,14) ->
	#base_constellation_strength{equip_type = 5,pos = 5,lv = 14,cost = [{0,38040070,22},{0,38040071,10},{0,38040072,5}],attr = [{1,6720},{3,4032}],special_attr = []};

get_strength_cfg(5,5,15) ->
	#base_constellation_strength{equip_type = 5,pos = 5,lv = 15,cost = [{0,38040070,25},{0,38040071,11},{0,38040072,6}],attr = [{1,7200},{3,4320}],special_attr = []};

get_strength_cfg(5,5,16) ->
	#base_constellation_strength{equip_type = 5,pos = 5,lv = 16,cost = [{0,38040070,30},{0,38040071,12},{0,38040072,7}],attr = [{1,7680},{3,4608}],special_attr = []};

get_strength_cfg(5,5,17) ->
	#base_constellation_strength{equip_type = 5,pos = 5,lv = 17,cost = [],attr = [{1,8160},{3,4896}],special_attr = []};

get_strength_cfg(5,6,0) ->
	#base_constellation_strength{equip_type = 5,pos = 6,lv = 0,cost = [{0,38040070,1}],attr = [{2,0},{4,0}],special_attr = []};

get_strength_cfg(5,6,1) ->
	#base_constellation_strength{equip_type = 5,pos = 6,lv = 1,cost = [{0,38040070,2}],attr = [{2,9600},{4,288}],special_attr = []};

get_strength_cfg(5,6,2) ->
	#base_constellation_strength{equip_type = 5,pos = 6,lv = 2,cost = [{0,38040070,3}],attr = [{2,19200},{4,576}],special_attr = []};

get_strength_cfg(5,6,3) ->
	#base_constellation_strength{equip_type = 5,pos = 6,lv = 3,cost = [{0,38040070,4}],attr = [{2,28800},{4,864}],special_attr = []};

get_strength_cfg(5,6,4) ->
	#base_constellation_strength{equip_type = 5,pos = 6,lv = 4,cost = [{0,38040070,5}],attr = [{2,38400},{4,1152}],special_attr = []};

get_strength_cfg(5,6,5) ->
	#base_constellation_strength{equip_type = 5,pos = 6,lv = 5,cost = [{0,38040070,6},{0,38040071,1}],attr = [{2,48000},{4,1440}],special_attr = []};

get_strength_cfg(5,6,6) ->
	#base_constellation_strength{equip_type = 5,pos = 6,lv = 6,cost = [{0,38040070,7},{0,38040071,2}],attr = [{2,57600},{4,1728}],special_attr = []};

get_strength_cfg(5,6,7) ->
	#base_constellation_strength{equip_type = 5,pos = 6,lv = 7,cost = [{0,38040070,8},{0,38040071,3}],attr = [{2,67200},{4,2016}],special_attr = []};

get_strength_cfg(5,6,8) ->
	#base_constellation_strength{equip_type = 5,pos = 6,lv = 8,cost = [{0,38040070,10},{0,38040071,4}],attr = [{2,76800},{4,2304}],special_attr = []};

get_strength_cfg(5,6,9) ->
	#base_constellation_strength{equip_type = 5,pos = 6,lv = 9,cost = [{0,38040070,12},{0,38040071,5}],attr = [{2,86400},{4,2592}],special_attr = []};

get_strength_cfg(5,6,10) ->
	#base_constellation_strength{equip_type = 5,pos = 6,lv = 10,cost = [{0,38040070,14},{0,38040071,6},{0,38040072,1}],attr = [{2,96000},{4,2880}],special_attr = []};

get_strength_cfg(5,6,11) ->
	#base_constellation_strength{equip_type = 5,pos = 6,lv = 11,cost = [{0,38040070,16},{0,38040071,7},{0,38040072,2}],attr = [{2,105600},{4,3168}],special_attr = []};

get_strength_cfg(5,6,12) ->
	#base_constellation_strength{equip_type = 5,pos = 6,lv = 12,cost = [{0,38040070,18},{0,38040071,8},{0,38040072,3}],attr = [{2,115200},{4,3456}],special_attr = []};

get_strength_cfg(5,6,13) ->
	#base_constellation_strength{equip_type = 5,pos = 6,lv = 13,cost = [{0,38040070,20},{0,38040071,9},{0,38040072,4}],attr = [{2,124800},{4,3744}],special_attr = []};

get_strength_cfg(5,6,14) ->
	#base_constellation_strength{equip_type = 5,pos = 6,lv = 14,cost = [{0,38040070,22},{0,38040071,10},{0,38040072,5}],attr = [{2,134400},{4,4032}],special_attr = []};

get_strength_cfg(5,6,15) ->
	#base_constellation_strength{equip_type = 5,pos = 6,lv = 15,cost = [{0,38040070,25},{0,38040071,11},{0,38040072,6}],attr = [{2,144000},{4,4320}],special_attr = []};

get_strength_cfg(5,6,16) ->
	#base_constellation_strength{equip_type = 5,pos = 6,lv = 16,cost = [{0,38040070,30},{0,38040071,12},{0,38040072,7}],attr = [{2,153600},{4,4608}],special_attr = []};

get_strength_cfg(5,6,17) ->
	#base_constellation_strength{equip_type = 5,pos = 6,lv = 17,cost = [],attr = [{2,163200},{4,4896}],special_attr = []};

get_strength_cfg(5,7,0) ->
	#base_constellation_strength{equip_type = 5,pos = 7,lv = 0,cost = [{0,38040075,1}],attr = [{1,0},{3,0}],special_attr = []};

get_strength_cfg(5,7,1) ->
	#base_constellation_strength{equip_type = 5,pos = 7,lv = 1,cost = [{0,38040075,2}],attr = [{1,240},{3,144}],special_attr = []};

get_strength_cfg(5,7,2) ->
	#base_constellation_strength{equip_type = 5,pos = 7,lv = 2,cost = [{0,38040075,3}],attr = [{1,480},{3,288}],special_attr = []};

get_strength_cfg(5,7,3) ->
	#base_constellation_strength{equip_type = 5,pos = 7,lv = 3,cost = [{0,38040075,4}],attr = [{1,720},{3,432}],special_attr = [{21,150}]};

get_strength_cfg(5,7,4) ->
	#base_constellation_strength{equip_type = 5,pos = 7,lv = 4,cost = [{0,38040075,4}],attr = [{1,960},{3,576}],special_attr = []};

get_strength_cfg(5,7,5) ->
	#base_constellation_strength{equip_type = 5,pos = 7,lv = 5,cost = [{0,38040075,5}],attr = [{1,1200},{3,720}],special_attr = []};

get_strength_cfg(5,7,6) ->
	#base_constellation_strength{equip_type = 5,pos = 7,lv = 6,cost = [{0,38040075,5}],attr = [{1,1440},{3,864}],special_attr = []};

get_strength_cfg(5,7,7) ->
	#base_constellation_strength{equip_type = 5,pos = 7,lv = 7,cost = [{0,38040075,6}],attr = [{1,1680},{3,1008}],special_attr = [{19,70}]};

get_strength_cfg(5,7,8) ->
	#base_constellation_strength{equip_type = 5,pos = 7,lv = 8,cost = [{0,38040075,6}],attr = [{1,1920},{3,1152}],special_attr = []};

get_strength_cfg(5,7,9) ->
	#base_constellation_strength{equip_type = 5,pos = 7,lv = 9,cost = [{0,38040075,7}],attr = [{1,2160},{3,1296}],special_attr = []};

get_strength_cfg(5,7,10) ->
	#base_constellation_strength{equip_type = 5,pos = 7,lv = 10,cost = [{0,38040075,7}],attr = [{1,2400},{3,1440}],special_attr = []};

get_strength_cfg(5,7,11) ->
	#base_constellation_strength{equip_type = 5,pos = 7,lv = 11,cost = [{0,38040075,8}],attr = [{1,2640},{3,1584}],special_attr = [{19,70}]};

get_strength_cfg(5,7,12) ->
	#base_constellation_strength{equip_type = 5,pos = 7,lv = 12,cost = [{0,38040075,8}],attr = [{1,2880},{3,1728}],special_attr = []};

get_strength_cfg(5,7,13) ->
	#base_constellation_strength{equip_type = 5,pos = 7,lv = 13,cost = [{0,38040075,9}],attr = [{1,3120},{3,1872}],special_attr = []};

get_strength_cfg(5,7,14) ->
	#base_constellation_strength{equip_type = 5,pos = 7,lv = 14,cost = [{0,38040075,9}],attr = [{1,3360},{3,2016}],special_attr = [{27,140}]};

get_strength_cfg(5,7,15) ->
	#base_constellation_strength{equip_type = 5,pos = 7,lv = 15,cost = [{0,38040075,10}],attr = [{1,3600},{3,2160}],special_attr = []};

get_strength_cfg(5,7,16) ->
	#base_constellation_strength{equip_type = 5,pos = 7,lv = 16,cost = [{0,38040075,10}],attr = [{1,3840},{3,2304}],special_attr = []};

get_strength_cfg(5,7,17) ->
	#base_constellation_strength{equip_type = 5,pos = 7,lv = 17,cost = [{0,38040075,12}],attr = [{1,4080},{3,2448}],special_attr = [{19,70}]};

get_strength_cfg(5,7,18) ->
	#base_constellation_strength{equip_type = 5,pos = 7,lv = 18,cost = [{0,38040075,12}],attr = [{1,4320},{3,2592}],special_attr = []};

get_strength_cfg(5,7,19) ->
	#base_constellation_strength{equip_type = 5,pos = 7,lv = 19,cost = [{0,38040075,15}],attr = [{1,4560},{3,2736}],special_attr = []};

get_strength_cfg(5,7,20) ->
	#base_constellation_strength{equip_type = 5,pos = 7,lv = 20,cost = [],attr = [{1,4800},{3,2880}],special_attr = []};

get_strength_cfg(5,8,0) ->
	#base_constellation_strength{equip_type = 5,pos = 8,lv = 0,cost = [{0,38040075,1}],attr = [{2,0},{4,0}],special_attr = []};

get_strength_cfg(5,8,1) ->
	#base_constellation_strength{equip_type = 5,pos = 8,lv = 1,cost = [{0,38040075,2}],attr = [{2,4800},{4,144}],special_attr = []};

get_strength_cfg(5,8,2) ->
	#base_constellation_strength{equip_type = 5,pos = 8,lv = 2,cost = [{0,38040075,3}],attr = [{2,9600},{4,288}],special_attr = []};

get_strength_cfg(5,8,3) ->
	#base_constellation_strength{equip_type = 5,pos = 8,lv = 3,cost = [{0,38040075,4}],attr = [{2,14400},{4,432}],special_attr = [{22,120}]};

get_strength_cfg(5,8,4) ->
	#base_constellation_strength{equip_type = 5,pos = 8,lv = 4,cost = [{0,38040075,4}],attr = [{2,19200},{4,576}],special_attr = []};

get_strength_cfg(5,8,5) ->
	#base_constellation_strength{equip_type = 5,pos = 8,lv = 5,cost = [{0,38040075,5}],attr = [{2,24000},{4,720}],special_attr = []};

get_strength_cfg(5,8,6) ->
	#base_constellation_strength{equip_type = 5,pos = 8,lv = 6,cost = [{0,38040075,5}],attr = [{2,28800},{4,864}],special_attr = []};

get_strength_cfg(5,8,7) ->
	#base_constellation_strength{equip_type = 5,pos = 8,lv = 7,cost = [{0,38040075,6}],attr = [{2,33600},{4,1008}],special_attr = [{20,70}]};

get_strength_cfg(5,8,8) ->
	#base_constellation_strength{equip_type = 5,pos = 8,lv = 8,cost = [{0,38040075,6}],attr = [{2,38400},{4,1152}],special_attr = []};

get_strength_cfg(5,8,9) ->
	#base_constellation_strength{equip_type = 5,pos = 8,lv = 9,cost = [{0,38040075,7}],attr = [{2,43200},{4,1296}],special_attr = []};

get_strength_cfg(5,8,10) ->
	#base_constellation_strength{equip_type = 5,pos = 8,lv = 10,cost = [{0,38040075,7}],attr = [{2,48000},{4,1440}],special_attr = []};

get_strength_cfg(5,8,11) ->
	#base_constellation_strength{equip_type = 5,pos = 8,lv = 11,cost = [{0,38040075,8}],attr = [{2,52800},{4,1584}],special_attr = [{20,70}]};

get_strength_cfg(5,8,12) ->
	#base_constellation_strength{equip_type = 5,pos = 8,lv = 12,cost = [{0,38040075,8}],attr = [{2,57600},{4,1728}],special_attr = []};

get_strength_cfg(5,8,13) ->
	#base_constellation_strength{equip_type = 5,pos = 8,lv = 13,cost = [{0,38040075,9}],attr = [{2,62400},{4,1872}],special_attr = []};

get_strength_cfg(5,8,14) ->
	#base_constellation_strength{equip_type = 5,pos = 8,lv = 14,cost = [{0,38040075,9}],attr = [{2,67200},{4,2016}],special_attr = [{28,140}]};

get_strength_cfg(5,8,15) ->
	#base_constellation_strength{equip_type = 5,pos = 8,lv = 15,cost = [{0,38040075,10}],attr = [{2,72000},{4,2160}],special_attr = []};

get_strength_cfg(5,8,16) ->
	#base_constellation_strength{equip_type = 5,pos = 8,lv = 16,cost = [{0,38040075,10}],attr = [{2,76800},{4,2304}],special_attr = []};

get_strength_cfg(5,8,17) ->
	#base_constellation_strength{equip_type = 5,pos = 8,lv = 17,cost = [{0,38040075,12}],attr = [{2,81600},{4,2448}],special_attr = [{20,70}]};

get_strength_cfg(5,8,18) ->
	#base_constellation_strength{equip_type = 5,pos = 8,lv = 18,cost = [{0,38040075,12}],attr = [{2,86400},{4,2592}],special_attr = []};

get_strength_cfg(5,8,19) ->
	#base_constellation_strength{equip_type = 5,pos = 8,lv = 19,cost = [{0,38040075,15}],attr = [{2,91200},{4,2736}],special_attr = []};

get_strength_cfg(5,8,20) ->
	#base_constellation_strength{equip_type = 5,pos = 8,lv = 20,cost = [],attr = [{2,96000},{4,2880}],special_attr = []};

get_strength_cfg(5,9,0) ->
	#base_constellation_strength{equip_type = 5,pos = 9,lv = 0,cost = [{0,38040075,1}],attr = [{1,0},{3,0}],special_attr = []};

get_strength_cfg(5,9,1) ->
	#base_constellation_strength{equip_type = 5,pos = 9,lv = 1,cost = [{0,38040075,2}],attr = [{1,240},{3,144}],special_attr = []};

get_strength_cfg(5,9,2) ->
	#base_constellation_strength{equip_type = 5,pos = 9,lv = 2,cost = [{0,38040075,3}],attr = [{1,480},{3,288}],special_attr = []};

get_strength_cfg(5,9,3) ->
	#base_constellation_strength{equip_type = 5,pos = 9,lv = 3,cost = [{0,38040075,4}],attr = [{1,720},{3,432}],special_attr = [{21,150}]};

get_strength_cfg(5,9,4) ->
	#base_constellation_strength{equip_type = 5,pos = 9,lv = 4,cost = [{0,38040075,4}],attr = [{1,960},{3,576}],special_attr = []};

get_strength_cfg(5,9,5) ->
	#base_constellation_strength{equip_type = 5,pos = 9,lv = 5,cost = [{0,38040075,5}],attr = [{1,1200},{3,720}],special_attr = []};

get_strength_cfg(5,9,6) ->
	#base_constellation_strength{equip_type = 5,pos = 9,lv = 6,cost = [{0,38040075,5}],attr = [{1,1440},{3,864}],special_attr = []};

get_strength_cfg(5,9,7) ->
	#base_constellation_strength{equip_type = 5,pos = 9,lv = 7,cost = [{0,38040075,6}],attr = [{1,1680},{3,1008}],special_attr = [{19,70}]};

get_strength_cfg(5,9,8) ->
	#base_constellation_strength{equip_type = 5,pos = 9,lv = 8,cost = [{0,38040075,6}],attr = [{1,1920},{3,1152}],special_attr = []};

get_strength_cfg(5,9,9) ->
	#base_constellation_strength{equip_type = 5,pos = 9,lv = 9,cost = [{0,38040075,7}],attr = [{1,2160},{3,1296}],special_attr = []};

get_strength_cfg(5,9,10) ->
	#base_constellation_strength{equip_type = 5,pos = 9,lv = 10,cost = [{0,38040075,7}],attr = [{1,2400},{3,1440}],special_attr = []};

get_strength_cfg(5,9,11) ->
	#base_constellation_strength{equip_type = 5,pos = 9,lv = 11,cost = [{0,38040075,8}],attr = [{1,2640},{3,1584}],special_attr = [{19,70}]};

get_strength_cfg(5,9,12) ->
	#base_constellation_strength{equip_type = 5,pos = 9,lv = 12,cost = [{0,38040075,8}],attr = [{1,2880},{3,1728}],special_attr = []};

get_strength_cfg(5,9,13) ->
	#base_constellation_strength{equip_type = 5,pos = 9,lv = 13,cost = [{0,38040075,9}],attr = [{1,3120},{3,1872}],special_attr = []};

get_strength_cfg(5,9,14) ->
	#base_constellation_strength{equip_type = 5,pos = 9,lv = 14,cost = [{0,38040075,9}],attr = [{1,3360},{3,2016}],special_attr = [{37,240}]};

get_strength_cfg(5,9,15) ->
	#base_constellation_strength{equip_type = 5,pos = 9,lv = 15,cost = [{0,38040075,10}],attr = [{1,3600},{3,2160}],special_attr = []};

get_strength_cfg(5,9,16) ->
	#base_constellation_strength{equip_type = 5,pos = 9,lv = 16,cost = [{0,38040075,10}],attr = [{1,3840},{3,2304}],special_attr = []};

get_strength_cfg(5,9,17) ->
	#base_constellation_strength{equip_type = 5,pos = 9,lv = 17,cost = [{0,38040075,12}],attr = [{1,4080},{3,2448}],special_attr = [{19,70}]};

get_strength_cfg(5,9,18) ->
	#base_constellation_strength{equip_type = 5,pos = 9,lv = 18,cost = [{0,38040075,12}],attr = [{1,4320},{3,2592}],special_attr = []};

get_strength_cfg(5,9,19) ->
	#base_constellation_strength{equip_type = 5,pos = 9,lv = 19,cost = [{0,38040075,15}],attr = [{1,4560},{3,2736}],special_attr = []};

get_strength_cfg(5,9,20) ->
	#base_constellation_strength{equip_type = 5,pos = 9,lv = 20,cost = [],attr = [{1,4800},{3,2880}],special_attr = []};

get_strength_cfg(5,10,0) ->
	#base_constellation_strength{equip_type = 5,pos = 10,lv = 0,cost = [{0,38040075,1}],attr = [{1,0},{3,0}],special_attr = []};

get_strength_cfg(5,10,1) ->
	#base_constellation_strength{equip_type = 5,pos = 10,lv = 1,cost = [{0,38040075,2}],attr = [{1,240},{3,144}],special_attr = []};

get_strength_cfg(5,10,2) ->
	#base_constellation_strength{equip_type = 5,pos = 10,lv = 2,cost = [{0,38040075,3}],attr = [{1,480},{3,288}],special_attr = []};

get_strength_cfg(5,10,3) ->
	#base_constellation_strength{equip_type = 5,pos = 10,lv = 3,cost = [{0,38040075,4}],attr = [{1,720},{3,432}],special_attr = [{22,120}]};

get_strength_cfg(5,10,4) ->
	#base_constellation_strength{equip_type = 5,pos = 10,lv = 4,cost = [{0,38040075,4}],attr = [{1,960},{3,576}],special_attr = []};

get_strength_cfg(5,10,5) ->
	#base_constellation_strength{equip_type = 5,pos = 10,lv = 5,cost = [{0,38040075,5}],attr = [{1,1200},{3,720}],special_attr = []};

get_strength_cfg(5,10,6) ->
	#base_constellation_strength{equip_type = 5,pos = 10,lv = 6,cost = [{0,38040075,5}],attr = [{1,1440},{3,864}],special_attr = []};

get_strength_cfg(5,10,7) ->
	#base_constellation_strength{equip_type = 5,pos = 10,lv = 7,cost = [{0,38040075,6}],attr = [{1,1680},{3,1008}],special_attr = [{20,70}]};

get_strength_cfg(5,10,8) ->
	#base_constellation_strength{equip_type = 5,pos = 10,lv = 8,cost = [{0,38040075,6}],attr = [{1,1920},{3,1152}],special_attr = []};

get_strength_cfg(5,10,9) ->
	#base_constellation_strength{equip_type = 5,pos = 10,lv = 9,cost = [{0,38040075,7}],attr = [{1,2160},{3,1296}],special_attr = []};

get_strength_cfg(5,10,10) ->
	#base_constellation_strength{equip_type = 5,pos = 10,lv = 10,cost = [{0,38040075,7}],attr = [{1,2400},{3,1440}],special_attr = []};

get_strength_cfg(5,10,11) ->
	#base_constellation_strength{equip_type = 5,pos = 10,lv = 11,cost = [{0,38040075,8}],attr = [{1,2640},{3,1584}],special_attr = [{20,70}]};

get_strength_cfg(5,10,12) ->
	#base_constellation_strength{equip_type = 5,pos = 10,lv = 12,cost = [{0,38040075,8}],attr = [{1,2880},{3,1728}],special_attr = []};

get_strength_cfg(5,10,13) ->
	#base_constellation_strength{equip_type = 5,pos = 10,lv = 13,cost = [{0,38040075,9}],attr = [{1,3120},{3,1872}],special_attr = []};

get_strength_cfg(5,10,14) ->
	#base_constellation_strength{equip_type = 5,pos = 10,lv = 14,cost = [{0,38040075,9}],attr = [{1,3360},{3,2016}],special_attr = [{38,240}]};

get_strength_cfg(5,10,15) ->
	#base_constellation_strength{equip_type = 5,pos = 10,lv = 15,cost = [{0,38040075,10}],attr = [{1,3600},{3,2160}],special_attr = []};

get_strength_cfg(5,10,16) ->
	#base_constellation_strength{equip_type = 5,pos = 10,lv = 16,cost = [{0,38040075,10}],attr = [{1,3840},{3,2304}],special_attr = []};

get_strength_cfg(5,10,17) ->
	#base_constellation_strength{equip_type = 5,pos = 10,lv = 17,cost = [{0,38040075,12}],attr = [{1,4080},{3,2448}],special_attr = [{20,70}]};

get_strength_cfg(5,10,18) ->
	#base_constellation_strength{equip_type = 5,pos = 10,lv = 18,cost = [{0,38040075,12}],attr = [{1,4320},{3,2592}],special_attr = []};

get_strength_cfg(5,10,19) ->
	#base_constellation_strength{equip_type = 5,pos = 10,lv = 19,cost = [{0,38040075,15}],attr = [{1,4560},{3,2736}],special_attr = []};

get_strength_cfg(5,10,20) ->
	#base_constellation_strength{equip_type = 5,pos = 10,lv = 20,cost = [],attr = [{1,4800},{3,2880}],special_attr = []};

get_strength_cfg(_Equiptype,_Pos,_Lv) ->
	#base_constellation_strength{}.

get_strength_master(1,7) ->
	#base_constellation_strength_master{equip_type = 1,lv = 7,satisfy_status = [{1,7},{2,7},{3,7},{4,7},{5,7},{6,7}],attr = [{56,500},{21,100}]};

get_strength_master(1,9) ->
	#base_constellation_strength_master{equip_type = 1,lv = 9,satisfy_status = [{1,9},{2,9},{3,9},{4,9},{5,9},{6,9}],attr = [{55,500},{22,100}]};

get_strength_master(1,11) ->
	#base_constellation_strength_master{equip_type = 1,lv = 11,satisfy_status = [{1,11},{2,11},{3,11},{4,11},{5,11},{6,11}],attr = [{28,100},{22,100}]};

get_strength_master(2,7) ->
	#base_constellation_strength_master{equip_type = 2,lv = 7,satisfy_status = [{1,7},{2,7},{3,7},{4,7},{5,7},{6,7}],attr = [{56,500},{21,100}]};

get_strength_master(2,9) ->
	#base_constellation_strength_master{equip_type = 2,lv = 9,satisfy_status = [{1,9},{2,9},{3,9},{4,9},{5,9},{6,9}],attr = [{55,500},{22,100}]};

get_strength_master(2,11) ->
	#base_constellation_strength_master{equip_type = 2,lv = 11,satisfy_status = [{1,11},{2,11},{3,11},{4,11},{5,11},{6,11}],attr = [{28,100},{22,100}]};

get_strength_master(2,13) ->
	#base_constellation_strength_master{equip_type = 2,lv = 13,satisfy_status = [{1,13},{2,13},{3,13},{4,13},{5,13},{6,13}],attr = [{27,100},{21,100}]};

get_strength_master(3,7) ->
	#base_constellation_strength_master{equip_type = 3,lv = 7,satisfy_status = [{1,7},{2,7},{3,7},{4,7},{5,7},{6,7}],attr = [{56,500},{21,100}]};

get_strength_master(3,9) ->
	#base_constellation_strength_master{equip_type = 3,lv = 9,satisfy_status = [{1,9},{2,9},{3,9},{4,9},{5,9},{6,9}],attr = [{55,500},{22,100}]};

get_strength_master(3,11) ->
	#base_constellation_strength_master{equip_type = 3,lv = 11,satisfy_status = [{1,11},{2,11},{3,11},{4,11},{5,11},{6,11}],attr = [{28,100},{22,100}]};

get_strength_master(3,13) ->
	#base_constellation_strength_master{equip_type = 3,lv = 13,satisfy_status = [{1,13},{2,13},{3,13},{4,13},{5,13},{6,13}],attr = [{27,100},{21,100}]};

get_strength_master(3,15) ->
	#base_constellation_strength_master{equip_type = 3,lv = 15,satisfy_status = [{1,15},{2,15},{3,15},{4,15},{5,15},{6,15}],attr = [{39,100},{22,100}]};

get_strength_master(4,7) ->
	#base_constellation_strength_master{equip_type = 4,lv = 7,satisfy_status = [{1,7},{2,7},{3,7},{4,7},{5,7},{6,7}],attr = [{56,500},{21,100}]};

get_strength_master(4,9) ->
	#base_constellation_strength_master{equip_type = 4,lv = 9,satisfy_status = [{1,9},{2,9},{3,9},{4,9},{5,9},{6,9}],attr = [{55,500},{22,100}]};

get_strength_master(4,11) ->
	#base_constellation_strength_master{equip_type = 4,lv = 11,satisfy_status = [{1,11},{2,11},{3,11},{4,11},{5,11},{6,11}],attr = [{28,100},{22,100}]};

get_strength_master(4,13) ->
	#base_constellation_strength_master{equip_type = 4,lv = 13,satisfy_status = [{1,13},{2,13},{3,13},{4,13},{5,13},{6,13}],attr = [{27,100},{21,100}]};

get_strength_master(4,15) ->
	#base_constellation_strength_master{equip_type = 4,lv = 15,satisfy_status = [{1,15},{2,15},{3,15},{4,15},{5,15},{6,15}],attr = [{39,100},{22,100}]};

get_strength_master(5,7) ->
	#base_constellation_strength_master{equip_type = 5,lv = 7,satisfy_status = [{1,7},{2,7},{3,7},{4,7},{5,7},{6,7}],attr = [{56,500},{21,100}]};

get_strength_master(5,9) ->
	#base_constellation_strength_master{equip_type = 5,lv = 9,satisfy_status = [{1,9},{2,9},{3,9},{4,9},{5,9},{6,9}],attr = [{55,500},{22,100}]};

get_strength_master(5,11) ->
	#base_constellation_strength_master{equip_type = 5,lv = 11,satisfy_status = [{1,11},{2,11},{3,11},{4,11},{5,11},{6,11}],attr = [{28,100},{22,100}]};

get_strength_master(5,13) ->
	#base_constellation_strength_master{equip_type = 5,lv = 13,satisfy_status = [{1,13},{2,13},{3,13},{4,13},{5,13},{6,13}],attr = [{27,100},{21,100}]};

get_strength_master(5,15) ->
	#base_constellation_strength_master{equip_type = 5,lv = 15,satisfy_status = [{1,15},{2,15},{3,15},{4,15},{5,15},{6,15}],attr = [{39,100},{22,100}]};

get_strength_master(5,17) ->
	#base_constellation_strength_master{equip_type = 5,lv = 17,satisfy_status = [{1,17},{2,17},{3,17},{4,17},{5,17},{6,17}],attr = [{27,100},{21,100}]};

get_strength_master(_Equiptype,_Lv) ->
	#base_constellation_strength_master{}.


get_strength_master_lv(1) ->
[7,9,11];


get_strength_master_lv(2) ->
[7,9,11,13];


get_strength_master_lv(3) ->
[7,9,11,13,15];


get_strength_master_lv(4) ->
[7,9,11,13,15];


get_strength_master_lv(5) ->
[7,9,11,13,15,17];

get_strength_master_lv(_Equiptype) ->
	[].

get_evolution_cfg(1,1,0) ->
	#base_constellation_evolution{equip_type = 1,pos = 1,lv = 0,ev_point = 100,rate = 6000,cost = [{0,38040076,1}],attr = [{1,0},{3,0},{19,0}]};

get_evolution_cfg(1,1,1) ->
	#base_constellation_evolution{equip_type = 1,pos = 1,lv = 1,ev_point = 200,rate = 5000,cost = [{0,38040076,2}],attr = [{1,480},{3,288},{19,20}]};

get_evolution_cfg(1,1,2) ->
	#base_constellation_evolution{equip_type = 1,pos = 1,lv = 2,ev_point = 300,rate = 4000,cost = [{0,38040076,3}],attr = [{1,960},{3,576},{19,40}]};

get_evolution_cfg(1,1,3) ->
	#base_constellation_evolution{equip_type = 1,pos = 1,lv = 3,ev_point = 400,rate = 3000,cost = [{0,38040076,4}],attr = [{1,1440},{3,864},{19,60}]};

get_evolution_cfg(1,1,4) ->
	#base_constellation_evolution{equip_type = 1,pos = 1,lv = 4,ev_point = 0,rate = 0,cost = [],attr = [{1,1920},{3,1152},{19,80}]};

get_evolution_cfg(1,2,0) ->
	#base_constellation_evolution{equip_type = 1,pos = 2,lv = 0,ev_point = 100,rate = 6000,cost = [{0,38040076,1}],attr = [{2,0},{4,0},{22,0}]};

get_evolution_cfg(1,2,1) ->
	#base_constellation_evolution{equip_type = 1,pos = 2,lv = 1,ev_point = 200,rate = 5000,cost = [{0,38040076,2}],attr = [{2,9600},{4,288},{22,40}]};

get_evolution_cfg(1,2,2) ->
	#base_constellation_evolution{equip_type = 1,pos = 2,lv = 2,ev_point = 300,rate = 4000,cost = [{0,38040076,3}],attr = [{2,19200},{4,576},{22,80}]};

get_evolution_cfg(1,2,3) ->
	#base_constellation_evolution{equip_type = 1,pos = 2,lv = 3,ev_point = 400,rate = 3000,cost = [{0,38040076,4}],attr = [{2,28800},{4,864},{22,120}]};

get_evolution_cfg(1,2,4) ->
	#base_constellation_evolution{equip_type = 1,pos = 2,lv = 4,ev_point = 0,rate = 0,cost = [],attr = [{2,38400},{4,1152},{22,160}]};

get_evolution_cfg(1,3,0) ->
	#base_constellation_evolution{equip_type = 1,pos = 3,lv = 0,ev_point = 100,rate = 6000,cost = [{0,38040076,1}],attr = [{2,0},{4,0},{20,0}]};

get_evolution_cfg(1,3,1) ->
	#base_constellation_evolution{equip_type = 1,pos = 3,lv = 1,ev_point = 200,rate = 5000,cost = [{0,38040076,2}],attr = [{2,9600},{4,288},{20,20}]};

get_evolution_cfg(1,3,2) ->
	#base_constellation_evolution{equip_type = 1,pos = 3,lv = 2,ev_point = 300,rate = 4000,cost = [{0,38040076,3}],attr = [{2,19200},{4,576},{20,40}]};

get_evolution_cfg(1,3,3) ->
	#base_constellation_evolution{equip_type = 1,pos = 3,lv = 3,ev_point = 400,rate = 3000,cost = [{0,38040076,4}],attr = [{2,28800},{4,864},{20,60}]};

get_evolution_cfg(1,3,4) ->
	#base_constellation_evolution{equip_type = 1,pos = 3,lv = 4,ev_point = 0,rate = 0,cost = [],attr = [{2,38400},{4,1152},{20,80}]};

get_evolution_cfg(1,4,0) ->
	#base_constellation_evolution{equip_type = 1,pos = 4,lv = 0,ev_point = 100,rate = 6000,cost = [{0,38040076,1}],attr = [{2,0},{4,0},{20,0}]};

get_evolution_cfg(1,4,1) ->
	#base_constellation_evolution{equip_type = 1,pos = 4,lv = 1,ev_point = 200,rate = 5000,cost = [{0,38040076,2}],attr = [{2,9600},{4,288},{20,20}]};

get_evolution_cfg(1,4,2) ->
	#base_constellation_evolution{equip_type = 1,pos = 4,lv = 2,ev_point = 300,rate = 4000,cost = [{0,38040076,3}],attr = [{2,19200},{4,576},{20,40}]};

get_evolution_cfg(1,4,3) ->
	#base_constellation_evolution{equip_type = 1,pos = 4,lv = 3,ev_point = 400,rate = 3000,cost = [{0,38040076,4}],attr = [{2,28800},{4,864},{20,60}]};

get_evolution_cfg(1,4,4) ->
	#base_constellation_evolution{equip_type = 1,pos = 4,lv = 4,ev_point = 0,rate = 0,cost = [],attr = [{2,38400},{4,1152},{20,80}]};

get_evolution_cfg(1,5,0) ->
	#base_constellation_evolution{equip_type = 1,pos = 5,lv = 0,ev_point = 100,rate = 6000,cost = [{0,38040076,1}],attr = [{1,0},{3,0},{21,0}]};

get_evolution_cfg(1,5,1) ->
	#base_constellation_evolution{equip_type = 1,pos = 5,lv = 1,ev_point = 200,rate = 5000,cost = [{0,38040076,2}],attr = [{1,480},{3,288},{21,30}]};

get_evolution_cfg(1,5,2) ->
	#base_constellation_evolution{equip_type = 1,pos = 5,lv = 2,ev_point = 300,rate = 4000,cost = [{0,38040076,3}],attr = [{1,960},{3,576},{21,60}]};

get_evolution_cfg(1,5,3) ->
	#base_constellation_evolution{equip_type = 1,pos = 5,lv = 3,ev_point = 400,rate = 3000,cost = [{0,38040076,4}],attr = [{1,1440},{3,864},{21,90}]};

get_evolution_cfg(1,5,4) ->
	#base_constellation_evolution{equip_type = 1,pos = 5,lv = 4,ev_point = 0,rate = 0,cost = [],attr = [{1,1920},{3,1152},{21,120}]};

get_evolution_cfg(1,6,0) ->
	#base_constellation_evolution{equip_type = 1,pos = 6,lv = 0,ev_point = 100,rate = 6000,cost = [{0,38040076,1}],attr = [{2,0},{4,0},{22,0}]};

get_evolution_cfg(1,6,1) ->
	#base_constellation_evolution{equip_type = 1,pos = 6,lv = 1,ev_point = 200,rate = 5000,cost = [{0,38040076,2}],attr = [{2,9600},{4,288},{22,40}]};

get_evolution_cfg(1,6,2) ->
	#base_constellation_evolution{equip_type = 1,pos = 6,lv = 2,ev_point = 300,rate = 4000,cost = [{0,38040076,3}],attr = [{2,19200},{4,576},{22,80}]};

get_evolution_cfg(1,6,3) ->
	#base_constellation_evolution{equip_type = 1,pos = 6,lv = 3,ev_point = 400,rate = 3000,cost = [{0,38040076,4}],attr = [{2,28800},{4,864},{22,120}]};

get_evolution_cfg(1,6,4) ->
	#base_constellation_evolution{equip_type = 1,pos = 6,lv = 4,ev_point = 0,rate = 0,cost = [],attr = [{2,38400},{4,1152},{22,160}]};

get_evolution_cfg(2,1,0) ->
	#base_constellation_evolution{equip_type = 2,pos = 1,lv = 0,ev_point = 150,rate = 6000,cost = [{0,38040076,1}],attr = [{1,0},{3,0},{19,0}]};

get_evolution_cfg(2,1,1) ->
	#base_constellation_evolution{equip_type = 2,pos = 1,lv = 1,ev_point = 300,rate = 5000,cost = [{0,38040076,2}],attr = [{1,560},{3,336},{19,22}]};

get_evolution_cfg(2,1,2) ->
	#base_constellation_evolution{equip_type = 2,pos = 1,lv = 2,ev_point = 450,rate = 4000,cost = [{0,38040076,3}],attr = [{1,1120},{3,672},{19,44}]};

get_evolution_cfg(2,1,3) ->
	#base_constellation_evolution{equip_type = 2,pos = 1,lv = 3,ev_point = 600,rate = 3000,cost = [{0,38040076,4}],attr = [{1,1680},{3,1008},{19,66}]};

get_evolution_cfg(2,1,4) ->
	#base_constellation_evolution{equip_type = 2,pos = 1,lv = 4,ev_point = 750,rate = 2000,cost = [{0,38040076,5}],attr = [{1,2240},{3,1344},{19,88}]};

get_evolution_cfg(2,1,5) ->
	#base_constellation_evolution{equip_type = 2,pos = 1,lv = 5,ev_point = 900,rate = 1000,cost = [{0,38040076,6}],attr = [{1,2800},{3,1680},{19,110}]};

get_evolution_cfg(2,1,6) ->
	#base_constellation_evolution{equip_type = 2,pos = 1,lv = 6,ev_point = 0,rate = 0,cost = [],attr = [{1,3360},{3,2016},{19,132}]};

get_evolution_cfg(2,2,0) ->
	#base_constellation_evolution{equip_type = 2,pos = 2,lv = 0,ev_point = 150,rate = 6000,cost = [{0,38040076,1}],attr = [{2,0},{4,0},{22,0}]};

get_evolution_cfg(2,2,1) ->
	#base_constellation_evolution{equip_type = 2,pos = 2,lv = 1,ev_point = 300,rate = 5000,cost = [{0,38040076,2}],attr = [{2,11200},{4,336},{22,44}]};

get_evolution_cfg(2,2,2) ->
	#base_constellation_evolution{equip_type = 2,pos = 2,lv = 2,ev_point = 450,rate = 4000,cost = [{0,38040076,3}],attr = [{2,22400},{4,672},{22,88}]};

get_evolution_cfg(2,2,3) ->
	#base_constellation_evolution{equip_type = 2,pos = 2,lv = 3,ev_point = 600,rate = 3000,cost = [{0,38040076,4}],attr = [{2,33600},{4,1008},{22,132}]};

get_evolution_cfg(2,2,4) ->
	#base_constellation_evolution{equip_type = 2,pos = 2,lv = 4,ev_point = 750,rate = 2000,cost = [{0,38040076,5}],attr = [{2,44800},{4,1344},{22,176}]};

get_evolution_cfg(2,2,5) ->
	#base_constellation_evolution{equip_type = 2,pos = 2,lv = 5,ev_point = 900,rate = 1000,cost = [{0,38040076,6}],attr = [{2,56000},{4,1680},{22,220}]};

get_evolution_cfg(2,2,6) ->
	#base_constellation_evolution{equip_type = 2,pos = 2,lv = 6,ev_point = 0,rate = 0,cost = [],attr = [{2,67200},{4,2016},{22,264}]};

get_evolution_cfg(2,3,0) ->
	#base_constellation_evolution{equip_type = 2,pos = 3,lv = 0,ev_point = 150,rate = 6000,cost = [{0,38040076,1}],attr = [{2,0},{4,0},{20,0}]};

get_evolution_cfg(2,3,1) ->
	#base_constellation_evolution{equip_type = 2,pos = 3,lv = 1,ev_point = 300,rate = 5000,cost = [{0,38040076,2}],attr = [{2,11200},{4,336},{20,22}]};

get_evolution_cfg(2,3,2) ->
	#base_constellation_evolution{equip_type = 2,pos = 3,lv = 2,ev_point = 450,rate = 4000,cost = [{0,38040076,3}],attr = [{2,22400},{4,672},{20,44}]};

get_evolution_cfg(2,3,3) ->
	#base_constellation_evolution{equip_type = 2,pos = 3,lv = 3,ev_point = 600,rate = 3000,cost = [{0,38040076,4}],attr = [{2,33600},{4,1008},{20,66}]};

get_evolution_cfg(2,3,4) ->
	#base_constellation_evolution{equip_type = 2,pos = 3,lv = 4,ev_point = 750,rate = 2000,cost = [{0,38040076,5}],attr = [{2,44800},{4,1344},{20,88}]};

get_evolution_cfg(2,3,5) ->
	#base_constellation_evolution{equip_type = 2,pos = 3,lv = 5,ev_point = 900,rate = 1000,cost = [{0,38040076,6}],attr = [{2,56000},{4,1680},{20,110}]};

get_evolution_cfg(2,3,6) ->
	#base_constellation_evolution{equip_type = 2,pos = 3,lv = 6,ev_point = 0,rate = 0,cost = [],attr = [{2,67200},{4,2016},{20,132}]};

get_evolution_cfg(2,4,0) ->
	#base_constellation_evolution{equip_type = 2,pos = 4,lv = 0,ev_point = 150,rate = 6000,cost = [{0,38040076,1}],attr = [{2,0},{4,0},{20,0}]};

get_evolution_cfg(2,4,1) ->
	#base_constellation_evolution{equip_type = 2,pos = 4,lv = 1,ev_point = 300,rate = 5000,cost = [{0,38040076,2}],attr = [{2,11200},{4,336},{20,22}]};

get_evolution_cfg(2,4,2) ->
	#base_constellation_evolution{equip_type = 2,pos = 4,lv = 2,ev_point = 450,rate = 4000,cost = [{0,38040076,3}],attr = [{2,22400},{4,672},{20,44}]};

get_evolution_cfg(2,4,3) ->
	#base_constellation_evolution{equip_type = 2,pos = 4,lv = 3,ev_point = 600,rate = 3000,cost = [{0,38040076,4}],attr = [{2,33600},{4,1008},{20,66}]};

get_evolution_cfg(2,4,4) ->
	#base_constellation_evolution{equip_type = 2,pos = 4,lv = 4,ev_point = 750,rate = 2000,cost = [{0,38040076,5}],attr = [{2,44800},{4,1344},{20,88}]};

get_evolution_cfg(2,4,5) ->
	#base_constellation_evolution{equip_type = 2,pos = 4,lv = 5,ev_point = 900,rate = 1000,cost = [{0,38040076,6}],attr = [{2,56000},{4,1680},{20,110}]};

get_evolution_cfg(2,4,6) ->
	#base_constellation_evolution{equip_type = 2,pos = 4,lv = 6,ev_point = 0,rate = 0,cost = [],attr = [{2,67200},{4,2016},{20,132}]};

get_evolution_cfg(2,5,0) ->
	#base_constellation_evolution{equip_type = 2,pos = 5,lv = 0,ev_point = 150,rate = 6000,cost = [{0,38040076,1}],attr = [{1,0},{3,0},{21,0}]};

get_evolution_cfg(2,5,1) ->
	#base_constellation_evolution{equip_type = 2,pos = 5,lv = 1,ev_point = 300,rate = 5000,cost = [{0,38040076,2}],attr = [{1,560},{3,336},{21,33}]};

get_evolution_cfg(2,5,2) ->
	#base_constellation_evolution{equip_type = 2,pos = 5,lv = 2,ev_point = 450,rate = 4000,cost = [{0,38040076,3}],attr = [{1,1120},{3,672},{21,66}]};

get_evolution_cfg(2,5,3) ->
	#base_constellation_evolution{equip_type = 2,pos = 5,lv = 3,ev_point = 600,rate = 3000,cost = [{0,38040076,4}],attr = [{1,1680},{3,1008},{21,99}]};

get_evolution_cfg(2,5,4) ->
	#base_constellation_evolution{equip_type = 2,pos = 5,lv = 4,ev_point = 750,rate = 2000,cost = [{0,38040076,5}],attr = [{1,2240},{3,1344},{21,132}]};

get_evolution_cfg(2,5,5) ->
	#base_constellation_evolution{equip_type = 2,pos = 5,lv = 5,ev_point = 900,rate = 1000,cost = [{0,38040076,6}],attr = [{1,2800},{3,1680},{21,165}]};

get_evolution_cfg(2,5,6) ->
	#base_constellation_evolution{equip_type = 2,pos = 5,lv = 6,ev_point = 0,rate = 0,cost = [],attr = [{1,3360},{3,2016},{21,198}]};

get_evolution_cfg(2,6,0) ->
	#base_constellation_evolution{equip_type = 2,pos = 6,lv = 0,ev_point = 150,rate = 6000,cost = [{0,38040076,1}],attr = [{2,0},{4,0},{22,0}]};

get_evolution_cfg(2,6,1) ->
	#base_constellation_evolution{equip_type = 2,pos = 6,lv = 1,ev_point = 300,rate = 5000,cost = [{0,38040076,2}],attr = [{2,11200},{4,336},{22,44}]};

get_evolution_cfg(2,6,2) ->
	#base_constellation_evolution{equip_type = 2,pos = 6,lv = 2,ev_point = 450,rate = 4000,cost = [{0,38040076,3}],attr = [{2,22400},{4,672},{22,88}]};

get_evolution_cfg(2,6,3) ->
	#base_constellation_evolution{equip_type = 2,pos = 6,lv = 3,ev_point = 600,rate = 3000,cost = [{0,38040076,4}],attr = [{2,33600},{4,1008},{22,132}]};

get_evolution_cfg(2,6,4) ->
	#base_constellation_evolution{equip_type = 2,pos = 6,lv = 4,ev_point = 750,rate = 2000,cost = [{0,38040076,5}],attr = [{2,44800},{4,1344},{22,176}]};

get_evolution_cfg(2,6,5) ->
	#base_constellation_evolution{equip_type = 2,pos = 6,lv = 5,ev_point = 900,rate = 1000,cost = [{0,38040076,6}],attr = [{2,56000},{4,1680},{22,220}]};

get_evolution_cfg(2,6,6) ->
	#base_constellation_evolution{equip_type = 2,pos = 6,lv = 6,ev_point = 0,rate = 0,cost = [],attr = [{2,67200},{4,2016},{22,264}]};

get_evolution_cfg(3,1,0) ->
	#base_constellation_evolution{equip_type = 3,pos = 1,lv = 0,ev_point = 150,rate = 6000,cost = [{0,38040076,1}],attr = [{1,0},{3,0},{19,0}]};

get_evolution_cfg(3,1,1) ->
	#base_constellation_evolution{equip_type = 3,pos = 1,lv = 1,ev_point = 300,rate = 5000,cost = [{0,38040076,2}],attr = [{1,640},{3,384},{19,24}]};

get_evolution_cfg(3,1,2) ->
	#base_constellation_evolution{equip_type = 3,pos = 1,lv = 2,ev_point = 450,rate = 4000,cost = [{0,38040076,3}],attr = [{1,1280},{3,768},{19,48}]};

get_evolution_cfg(3,1,3) ->
	#base_constellation_evolution{equip_type = 3,pos = 1,lv = 3,ev_point = 600,rate = 3000,cost = [{0,38040076,4}],attr = [{1,1920},{3,1152},{19,72}]};

get_evolution_cfg(3,1,4) ->
	#base_constellation_evolution{equip_type = 3,pos = 1,lv = 4,ev_point = 750,rate = 2000,cost = [{0,38040076,5}],attr = [{1,2560},{3,1536},{19,96}]};

get_evolution_cfg(3,1,5) ->
	#base_constellation_evolution{equip_type = 3,pos = 1,lv = 5,ev_point = 900,rate = 1000,cost = [{0,38040076,6}],attr = [{1,3200},{3,1920},{19,120}]};

get_evolution_cfg(3,1,6) ->
	#base_constellation_evolution{equip_type = 3,pos = 1,lv = 6,ev_point = 1050,rate = 500,cost = [{0,38040076,7}],attr = [{1,3840},{3,2304},{19,144}]};

get_evolution_cfg(3,1,7) ->
	#base_constellation_evolution{equip_type = 3,pos = 1,lv = 7,ev_point = 0,rate = 0,cost = [],attr = [{1,4480},{3,2688},{19,168}]};

get_evolution_cfg(3,2,0) ->
	#base_constellation_evolution{equip_type = 3,pos = 2,lv = 0,ev_point = 150,rate = 6000,cost = [{0,38040076,1}],attr = [{2,0},{4,0},{22,0}]};

get_evolution_cfg(3,2,1) ->
	#base_constellation_evolution{equip_type = 3,pos = 2,lv = 1,ev_point = 300,rate = 5000,cost = [{0,38040076,2}],attr = [{2,12800},{4,384},{22,48}]};

get_evolution_cfg(3,2,2) ->
	#base_constellation_evolution{equip_type = 3,pos = 2,lv = 2,ev_point = 450,rate = 4000,cost = [{0,38040076,3}],attr = [{2,25600},{4,768},{22,96}]};

get_evolution_cfg(3,2,3) ->
	#base_constellation_evolution{equip_type = 3,pos = 2,lv = 3,ev_point = 600,rate = 3000,cost = [{0,38040076,4}],attr = [{2,38400},{4,1152},{22,144}]};

get_evolution_cfg(3,2,4) ->
	#base_constellation_evolution{equip_type = 3,pos = 2,lv = 4,ev_point = 750,rate = 2000,cost = [{0,38040076,5}],attr = [{2,51200},{4,1536},{22,192}]};

get_evolution_cfg(3,2,5) ->
	#base_constellation_evolution{equip_type = 3,pos = 2,lv = 5,ev_point = 900,rate = 1000,cost = [{0,38040076,6}],attr = [{2,64000},{4,1920},{22,240}]};

get_evolution_cfg(3,2,6) ->
	#base_constellation_evolution{equip_type = 3,pos = 2,lv = 6,ev_point = 1050,rate = 500,cost = [{0,38040076,7}],attr = [{2,76800},{4,2304},{22,288}]};

get_evolution_cfg(3,2,7) ->
	#base_constellation_evolution{equip_type = 3,pos = 2,lv = 7,ev_point = 0,rate = 0,cost = [],attr = [{2,89600},{4,2688},{22,336}]};

get_evolution_cfg(3,3,0) ->
	#base_constellation_evolution{equip_type = 3,pos = 3,lv = 0,ev_point = 150,rate = 6000,cost = [{0,38040076,1}],attr = [{2,0},{4,0},{20,0}]};

get_evolution_cfg(3,3,1) ->
	#base_constellation_evolution{equip_type = 3,pos = 3,lv = 1,ev_point = 300,rate = 5000,cost = [{0,38040076,2}],attr = [{2,12800},{4,384},{20,24}]};

get_evolution_cfg(3,3,2) ->
	#base_constellation_evolution{equip_type = 3,pos = 3,lv = 2,ev_point = 450,rate = 4000,cost = [{0,38040076,3}],attr = [{2,25600},{4,768},{20,48}]};

get_evolution_cfg(3,3,3) ->
	#base_constellation_evolution{equip_type = 3,pos = 3,lv = 3,ev_point = 600,rate = 3000,cost = [{0,38040076,4}],attr = [{2,38400},{4,1152},{20,72}]};

get_evolution_cfg(3,3,4) ->
	#base_constellation_evolution{equip_type = 3,pos = 3,lv = 4,ev_point = 750,rate = 2000,cost = [{0,38040076,5}],attr = [{2,51200},{4,1536},{20,96}]};

get_evolution_cfg(3,3,5) ->
	#base_constellation_evolution{equip_type = 3,pos = 3,lv = 5,ev_point = 900,rate = 1000,cost = [{0,38040076,6}],attr = [{2,64000},{4,1920},{20,120}]};

get_evolution_cfg(3,3,6) ->
	#base_constellation_evolution{equip_type = 3,pos = 3,lv = 6,ev_point = 1050,rate = 500,cost = [{0,38040076,7}],attr = [{2,76800},{4,2304},{20,144}]};

get_evolution_cfg(3,3,7) ->
	#base_constellation_evolution{equip_type = 3,pos = 3,lv = 7,ev_point = 0,rate = 0,cost = [],attr = [{2,89600},{4,2688},{20,168}]};

get_evolution_cfg(3,4,0) ->
	#base_constellation_evolution{equip_type = 3,pos = 4,lv = 0,ev_point = 150,rate = 6000,cost = [{0,38040076,1}],attr = [{2,0},{4,0},{20,0}]};

get_evolution_cfg(3,4,1) ->
	#base_constellation_evolution{equip_type = 3,pos = 4,lv = 1,ev_point = 300,rate = 5000,cost = [{0,38040076,2}],attr = [{2,12800},{4,384},{20,24}]};

get_evolution_cfg(3,4,2) ->
	#base_constellation_evolution{equip_type = 3,pos = 4,lv = 2,ev_point = 450,rate = 4000,cost = [{0,38040076,3}],attr = [{2,25600},{4,768},{20,48}]};

get_evolution_cfg(3,4,3) ->
	#base_constellation_evolution{equip_type = 3,pos = 4,lv = 3,ev_point = 600,rate = 3000,cost = [{0,38040076,4}],attr = [{2,38400},{4,1152},{20,72}]};

get_evolution_cfg(3,4,4) ->
	#base_constellation_evolution{equip_type = 3,pos = 4,lv = 4,ev_point = 750,rate = 2000,cost = [{0,38040076,5}],attr = [{2,51200},{4,1536},{20,96}]};

get_evolution_cfg(3,4,5) ->
	#base_constellation_evolution{equip_type = 3,pos = 4,lv = 5,ev_point = 900,rate = 1000,cost = [{0,38040076,6}],attr = [{2,64000},{4,1920},{20,120}]};

get_evolution_cfg(3,4,6) ->
	#base_constellation_evolution{equip_type = 3,pos = 4,lv = 6,ev_point = 1050,rate = 500,cost = [{0,38040076,7}],attr = [{2,76800},{4,2304},{20,144}]};

get_evolution_cfg(3,4,7) ->
	#base_constellation_evolution{equip_type = 3,pos = 4,lv = 7,ev_point = 0,rate = 0,cost = [],attr = [{2,89600},{4,2688},{20,168}]};

get_evolution_cfg(3,5,0) ->
	#base_constellation_evolution{equip_type = 3,pos = 5,lv = 0,ev_point = 150,rate = 6000,cost = [{0,38040076,1}],attr = [{1,0},{3,0},{21,0}]};

get_evolution_cfg(3,5,1) ->
	#base_constellation_evolution{equip_type = 3,pos = 5,lv = 1,ev_point = 300,rate = 5000,cost = [{0,38040076,2}],attr = [{1,640},{3,384},{21,36}]};

get_evolution_cfg(3,5,2) ->
	#base_constellation_evolution{equip_type = 3,pos = 5,lv = 2,ev_point = 450,rate = 4000,cost = [{0,38040076,3}],attr = [{1,1280},{3,768},{21,72}]};

get_evolution_cfg(3,5,3) ->
	#base_constellation_evolution{equip_type = 3,pos = 5,lv = 3,ev_point = 600,rate = 3000,cost = [{0,38040076,4}],attr = [{1,1920},{3,1152},{21,108}]};

get_evolution_cfg(3,5,4) ->
	#base_constellation_evolution{equip_type = 3,pos = 5,lv = 4,ev_point = 750,rate = 2000,cost = [{0,38040076,5}],attr = [{1,640},{3,384},{21,36}]};

get_evolution_cfg(3,5,5) ->
	#base_constellation_evolution{equip_type = 3,pos = 5,lv = 5,ev_point = 900,rate = 1000,cost = [{0,38040076,6}],attr = [{1,1280},{3,768},{21,72}]};

get_evolution_cfg(3,5,6) ->
	#base_constellation_evolution{equip_type = 3,pos = 5,lv = 6,ev_point = 1050,rate = 500,cost = [{0,38040076,7}],attr = [{1,1920},{3,1152},{21,108}]};

get_evolution_cfg(3,5,7) ->
	#base_constellation_evolution{equip_type = 3,pos = 5,lv = 7,ev_point = 0,rate = 0,cost = [],attr = [{1,2560},{3,1536},{21,144}]};

get_evolution_cfg(3,6,0) ->
	#base_constellation_evolution{equip_type = 3,pos = 6,lv = 0,ev_point = 150,rate = 6000,cost = [{0,38040076,1}],attr = [{2,0},{4,0},{22,0}]};

get_evolution_cfg(3,6,1) ->
	#base_constellation_evolution{equip_type = 3,pos = 6,lv = 1,ev_point = 300,rate = 5000,cost = [{0,38040076,2}],attr = [{2,12800},{4,384},{22,48}]};

get_evolution_cfg(3,6,2) ->
	#base_constellation_evolution{equip_type = 3,pos = 6,lv = 2,ev_point = 450,rate = 4000,cost = [{0,38040076,3}],attr = [{2,25600},{4,768},{22,96}]};

get_evolution_cfg(3,6,3) ->
	#base_constellation_evolution{equip_type = 3,pos = 6,lv = 3,ev_point = 600,rate = 3000,cost = [{0,38040076,4}],attr = [{2,38400},{4,1152},{22,144}]};

get_evolution_cfg(3,6,4) ->
	#base_constellation_evolution{equip_type = 3,pos = 6,lv = 4,ev_point = 750,rate = 2000,cost = [{0,38040076,5}],attr = [{2,51200},{4,1536},{22,192}]};

get_evolution_cfg(3,6,5) ->
	#base_constellation_evolution{equip_type = 3,pos = 6,lv = 5,ev_point = 900,rate = 1000,cost = [{0,38040076,6}],attr = [{2,64000},{4,1920},{22,240}]};

get_evolution_cfg(3,6,6) ->
	#base_constellation_evolution{equip_type = 3,pos = 6,lv = 6,ev_point = 1050,rate = 500,cost = [{0,38040076,7}],attr = [{2,76800},{4,2304},{22,288}]};

get_evolution_cfg(3,6,7) ->
	#base_constellation_evolution{equip_type = 3,pos = 6,lv = 7,ev_point = 0,rate = 0,cost = [],attr = [{2,89600},{4,2688},{22,336}]};

get_evolution_cfg(4,1,0) ->
	#base_constellation_evolution{equip_type = 4,pos = 1,lv = 0,ev_point = 350,rate = 6000,cost = [{0,38040076,1}],attr = [{1,0},{3,0},{19,0}]};

get_evolution_cfg(4,1,1) ->
	#base_constellation_evolution{equip_type = 4,pos = 1,lv = 1,ev_point = 525,rate = 5000,cost = [{0,38040076,2}],attr = [{1,720},{3,432},{19,26}]};

get_evolution_cfg(4,1,2) ->
	#base_constellation_evolution{equip_type = 4,pos = 1,lv = 2,ev_point = 700,rate = 4000,cost = [{0,38040076,3}],attr = [{1,1440},{3,864},{19,52}]};

get_evolution_cfg(4,1,3) ->
	#base_constellation_evolution{equip_type = 4,pos = 1,lv = 3,ev_point = 875,rate = 3000,cost = [{0,38040076,4}],attr = [{1,2160},{3,1296},{19,78}]};

get_evolution_cfg(4,1,4) ->
	#base_constellation_evolution{equip_type = 4,pos = 1,lv = 4,ev_point = 1050,rate = 2000,cost = [{0,38040076,5}],attr = [{1,2880},{3,1728},{19,104}]};

get_evolution_cfg(4,1,5) ->
	#base_constellation_evolution{equip_type = 4,pos = 1,lv = 5,ev_point = 1225,rate = 1000,cost = [{0,38040076,6}],attr = [{1,3600},{3,2160},{19,130}]};

get_evolution_cfg(4,1,6) ->
	#base_constellation_evolution{equip_type = 4,pos = 1,lv = 6,ev_point = 1400,rate = 500,cost = [{0,38040076,7}],attr = [{1,4320},{3,2592},{19,156}]};

get_evolution_cfg(4,1,7) ->
	#base_constellation_evolution{equip_type = 4,pos = 1,lv = 7,ev_point = 0,rate = 0,cost = [],attr = [{1,5040},{3,3024},{19,182}]};

get_evolution_cfg(4,2,0) ->
	#base_constellation_evolution{equip_type = 4,pos = 2,lv = 0,ev_point = 350,rate = 6000,cost = [{0,38040076,1}],attr = [{2,0},{4,0},{22,0}]};

get_evolution_cfg(4,2,1) ->
	#base_constellation_evolution{equip_type = 4,pos = 2,lv = 1,ev_point = 525,rate = 5000,cost = [{0,38040076,2}],attr = [{2,14400},{4,432},{22,52}]};

get_evolution_cfg(4,2,2) ->
	#base_constellation_evolution{equip_type = 4,pos = 2,lv = 2,ev_point = 700,rate = 4000,cost = [{0,38040076,3}],attr = [{2,28800},{4,864},{22,104}]};

get_evolution_cfg(4,2,3) ->
	#base_constellation_evolution{equip_type = 4,pos = 2,lv = 3,ev_point = 875,rate = 3000,cost = [{0,38040076,4}],attr = [{2,43200},{4,1296},{22,156}]};

get_evolution_cfg(4,2,4) ->
	#base_constellation_evolution{equip_type = 4,pos = 2,lv = 4,ev_point = 1050,rate = 2000,cost = [{0,38040076,5}],attr = [{2,57600},{4,1728},{22,208}]};

get_evolution_cfg(4,2,5) ->
	#base_constellation_evolution{equip_type = 4,pos = 2,lv = 5,ev_point = 1225,rate = 1000,cost = [{0,38040076,6}],attr = [{2,72000},{4,2160},{22,260}]};

get_evolution_cfg(4,2,6) ->
	#base_constellation_evolution{equip_type = 4,pos = 2,lv = 6,ev_point = 1400,rate = 500,cost = [{0,38040076,7}],attr = [{2,86400},{4,2592},{22,312}]};

get_evolution_cfg(4,2,7) ->
	#base_constellation_evolution{equip_type = 4,pos = 2,lv = 7,ev_point = 0,rate = 0,cost = [],attr = [{2,100800},{4,3024},{22,364}]};

get_evolution_cfg(4,3,0) ->
	#base_constellation_evolution{equip_type = 4,pos = 3,lv = 0,ev_point = 350,rate = 6000,cost = [{0,38040076,1}],attr = [{2,0},{4,0},{20,0}]};

get_evolution_cfg(4,3,1) ->
	#base_constellation_evolution{equip_type = 4,pos = 3,lv = 1,ev_point = 525,rate = 5000,cost = [{0,38040076,2}],attr = [{2,14400},{4,432},{20,26}]};

get_evolution_cfg(4,3,2) ->
	#base_constellation_evolution{equip_type = 4,pos = 3,lv = 2,ev_point = 700,rate = 4000,cost = [{0,38040076,3}],attr = [{2,28800},{4,864},{20,52}]};

get_evolution_cfg(4,3,3) ->
	#base_constellation_evolution{equip_type = 4,pos = 3,lv = 3,ev_point = 875,rate = 3000,cost = [{0,38040076,4}],attr = [{2,43200},{4,1296},{20,78}]};

get_evolution_cfg(4,3,4) ->
	#base_constellation_evolution{equip_type = 4,pos = 3,lv = 4,ev_point = 1050,rate = 2000,cost = [{0,38040076,5}],attr = [{2,57600},{4,1728},{20,104}]};

get_evolution_cfg(4,3,5) ->
	#base_constellation_evolution{equip_type = 4,pos = 3,lv = 5,ev_point = 1225,rate = 1000,cost = [{0,38040076,6}],attr = [{2,72000},{4,2160},{20,130}]};

get_evolution_cfg(4,3,6) ->
	#base_constellation_evolution{equip_type = 4,pos = 3,lv = 6,ev_point = 1400,rate = 500,cost = [{0,38040076,7}],attr = [{2,86400},{4,2592},{20,156}]};

get_evolution_cfg(4,3,7) ->
	#base_constellation_evolution{equip_type = 4,pos = 3,lv = 7,ev_point = 0,rate = 0,cost = [],attr = [{2,100800},{4,3024},{20,182}]};

get_evolution_cfg(4,4,0) ->
	#base_constellation_evolution{equip_type = 4,pos = 4,lv = 0,ev_point = 350,rate = 6000,cost = [{0,38040076,1}],attr = [{2,0},{4,0},{20,0}]};

get_evolution_cfg(4,4,1) ->
	#base_constellation_evolution{equip_type = 4,pos = 4,lv = 1,ev_point = 525,rate = 5000,cost = [{0,38040076,2}],attr = [{2,14400},{4,432},{20,26}]};

get_evolution_cfg(4,4,2) ->
	#base_constellation_evolution{equip_type = 4,pos = 4,lv = 2,ev_point = 700,rate = 4000,cost = [{0,38040076,3}],attr = [{2,28800},{4,864},{20,52}]};

get_evolution_cfg(4,4,3) ->
	#base_constellation_evolution{equip_type = 4,pos = 4,lv = 3,ev_point = 875,rate = 3000,cost = [{0,38040076,4}],attr = [{2,43200},{4,1296},{20,78}]};

get_evolution_cfg(4,4,4) ->
	#base_constellation_evolution{equip_type = 4,pos = 4,lv = 4,ev_point = 1050,rate = 2000,cost = [{0,38040076,5}],attr = [{2,57600},{4,1728},{20,104}]};

get_evolution_cfg(4,4,5) ->
	#base_constellation_evolution{equip_type = 4,pos = 4,lv = 5,ev_point = 1225,rate = 1000,cost = [{0,38040076,6}],attr = [{2,72000},{4,2160},{20,130}]};

get_evolution_cfg(4,4,6) ->
	#base_constellation_evolution{equip_type = 4,pos = 4,lv = 6,ev_point = 1400,rate = 500,cost = [{0,38040076,7}],attr = [{2,86400},{4,2592},{20,156}]};

get_evolution_cfg(4,4,7) ->
	#base_constellation_evolution{equip_type = 4,pos = 4,lv = 7,ev_point = 0,rate = 0,cost = [],attr = [{2,100800},{4,3024},{20,182}]};

get_evolution_cfg(4,5,0) ->
	#base_constellation_evolution{equip_type = 4,pos = 5,lv = 0,ev_point = 350,rate = 6000,cost = [{0,38040076,1}],attr = [{1,0},{3,0},{21,0}]};

get_evolution_cfg(4,5,1) ->
	#base_constellation_evolution{equip_type = 4,pos = 5,lv = 1,ev_point = 525,rate = 5000,cost = [{0,38040076,2}],attr = [{1,720},{3,432},{21,39}]};

get_evolution_cfg(4,5,2) ->
	#base_constellation_evolution{equip_type = 4,pos = 5,lv = 2,ev_point = 700,rate = 4000,cost = [{0,38040076,3}],attr = [{1,1440},{3,864},{21,78}]};

get_evolution_cfg(4,5,3) ->
	#base_constellation_evolution{equip_type = 4,pos = 5,lv = 3,ev_point = 875,rate = 3000,cost = [{0,38040076,4}],attr = [{1,2160},{3,1296},{21,117}]};

get_evolution_cfg(4,5,4) ->
	#base_constellation_evolution{equip_type = 4,pos = 5,lv = 4,ev_point = 1050,rate = 2000,cost = [{0,38040076,5}],attr = [{1,2880},{3,1728},{21,156}]};

get_evolution_cfg(4,5,5) ->
	#base_constellation_evolution{equip_type = 4,pos = 5,lv = 5,ev_point = 1225,rate = 1000,cost = [{0,38040076,6}],attr = [{1,3600},{3,2160},{21,195}]};

get_evolution_cfg(4,5,6) ->
	#base_constellation_evolution{equip_type = 4,pos = 5,lv = 6,ev_point = 1400,rate = 500,cost = [{0,38040076,7}],attr = [{1,4320},{3,2592},{21,234}]};

get_evolution_cfg(4,5,7) ->
	#base_constellation_evolution{equip_type = 4,pos = 5,lv = 7,ev_point = 0,rate = 0,cost = [],attr = [{1,5040},{3,3024},{21,273}]};

get_evolution_cfg(4,6,0) ->
	#base_constellation_evolution{equip_type = 4,pos = 6,lv = 0,ev_point = 350,rate = 6000,cost = [{0,38040076,1}],attr = [{2,0},{4,0},{22,0}]};

get_evolution_cfg(4,6,1) ->
	#base_constellation_evolution{equip_type = 4,pos = 6,lv = 1,ev_point = 525,rate = 5000,cost = [{0,38040076,2}],attr = [{2,14400},{4,432},{22,52}]};

get_evolution_cfg(4,6,2) ->
	#base_constellation_evolution{equip_type = 4,pos = 6,lv = 2,ev_point = 700,rate = 4000,cost = [{0,38040076,3}],attr = [{2,28800},{4,864},{22,104}]};

get_evolution_cfg(4,6,3) ->
	#base_constellation_evolution{equip_type = 4,pos = 6,lv = 3,ev_point = 875,rate = 3000,cost = [{0,38040076,4}],attr = [{2,43200},{4,1296},{22,156}]};

get_evolution_cfg(4,6,4) ->
	#base_constellation_evolution{equip_type = 4,pos = 6,lv = 4,ev_point = 1050,rate = 2000,cost = [{0,38040076,5}],attr = [{2,57600},{4,1728},{22,208}]};

get_evolution_cfg(4,6,5) ->
	#base_constellation_evolution{equip_type = 4,pos = 6,lv = 5,ev_point = 1225,rate = 1000,cost = [{0,38040076,6}],attr = [{2,72000},{4,2160},{22,260}]};

get_evolution_cfg(4,6,6) ->
	#base_constellation_evolution{equip_type = 4,pos = 6,lv = 6,ev_point = 1400,rate = 500,cost = [{0,38040076,7}],attr = [{2,86400},{4,2592},{22,312}]};

get_evolution_cfg(4,6,7) ->
	#base_constellation_evolution{equip_type = 4,pos = 6,lv = 7,ev_point = 0,rate = 0,cost = [],attr = [{2,100800},{4,3024},{22,364}]};

get_evolution_cfg(5,1,0) ->
	#base_constellation_evolution{equip_type = 5,pos = 1,lv = 0,ev_point = 400,rate = 6000,cost = [{0,38040076,1}],attr = [{1,0},{3,0},{19,0}]};

get_evolution_cfg(5,1,1) ->
	#base_constellation_evolution{equip_type = 5,pos = 1,lv = 1,ev_point = 600,rate = 5000,cost = [{0,38040076,2}],attr = [{1,800},{3,480},{19,30}]};

get_evolution_cfg(5,1,2) ->
	#base_constellation_evolution{equip_type = 5,pos = 1,lv = 2,ev_point = 800,rate = 4000,cost = [{0,38040076,3}],attr = [{1,1600},{3,960},{19,60}]};

get_evolution_cfg(5,1,3) ->
	#base_constellation_evolution{equip_type = 5,pos = 1,lv = 3,ev_point = 1000,rate = 3000,cost = [{0,38040076,4}],attr = [{1,2400},{3,1440},{19,90}]};

get_evolution_cfg(5,1,4) ->
	#base_constellation_evolution{equip_type = 5,pos = 1,lv = 4,ev_point = 1200,rate = 2000,cost = [{0,38040076,5}],attr = [{1,3200},{3,1920},{19,120}]};

get_evolution_cfg(5,1,5) ->
	#base_constellation_evolution{equip_type = 5,pos = 1,lv = 5,ev_point = 1400,rate = 1000,cost = [{0,38040076,6}],attr = [{1,4000},{3,2400},{19,150}]};

get_evolution_cfg(5,1,6) ->
	#base_constellation_evolution{equip_type = 5,pos = 1,lv = 6,ev_point = 1600,rate = 500,cost = [{0,38040076,7}],attr = [{1,4800},{3,2880},{19,180}]};

get_evolution_cfg(5,1,7) ->
	#base_constellation_evolution{equip_type = 5,pos = 1,lv = 7,ev_point = 1800,rate = 0,cost = [{0,38040076,8}],attr = [{1,5600},{3,3360},{19,210}]};

get_evolution_cfg(5,1,8) ->
	#base_constellation_evolution{equip_type = 5,pos = 1,lv = 8,ev_point = 0,rate = 0,cost = [],attr = [{1,6400},{3,3840},{19,240}]};

get_evolution_cfg(5,2,0) ->
	#base_constellation_evolution{equip_type = 5,pos = 2,lv = 0,ev_point = 400,rate = 6000,cost = [{0,38040076,1}],attr = [{2,0},{4,0},{22,0}]};

get_evolution_cfg(5,2,1) ->
	#base_constellation_evolution{equip_type = 5,pos = 2,lv = 1,ev_point = 600,rate = 5000,cost = [{0,38040076,2}],attr = [{2,16000},{4,480},{22,60}]};

get_evolution_cfg(5,2,2) ->
	#base_constellation_evolution{equip_type = 5,pos = 2,lv = 2,ev_point = 800,rate = 4000,cost = [{0,38040076,3}],attr = [{2,32000},{4,960},{22,120}]};

get_evolution_cfg(5,2,3) ->
	#base_constellation_evolution{equip_type = 5,pos = 2,lv = 3,ev_point = 1000,rate = 3000,cost = [{0,38040076,4}],attr = [{2,48000},{4,1440},{22,180}]};

get_evolution_cfg(5,2,4) ->
	#base_constellation_evolution{equip_type = 5,pos = 2,lv = 4,ev_point = 1200,rate = 2000,cost = [{0,38040076,5}],attr = [{2,64000},{4,1920},{22,240}]};

get_evolution_cfg(5,2,5) ->
	#base_constellation_evolution{equip_type = 5,pos = 2,lv = 5,ev_point = 1400,rate = 1000,cost = [{0,38040076,6}],attr = [{2,80000},{4,2400},{22,300}]};

get_evolution_cfg(5,2,6) ->
	#base_constellation_evolution{equip_type = 5,pos = 2,lv = 6,ev_point = 1600,rate = 500,cost = [{0,38040076,7}],attr = [{2,96000},{4,2880},{22,360}]};

get_evolution_cfg(5,2,7) ->
	#base_constellation_evolution{equip_type = 5,pos = 2,lv = 7,ev_point = 1800,rate = 0,cost = [{0,38040076,8}],attr = [{2,112000},{4,3360},{22,420}]};

get_evolution_cfg(5,2,8) ->
	#base_constellation_evolution{equip_type = 5,pos = 2,lv = 8,ev_point = 0,rate = 0,cost = [],attr = [{2,128000},{4,3840},{22,480}]};

get_evolution_cfg(5,3,0) ->
	#base_constellation_evolution{equip_type = 5,pos = 3,lv = 0,ev_point = 400,rate = 6000,cost = [{0,38040076,1}],attr = [{2,0},{4,0},{20,0}]};

get_evolution_cfg(5,3,1) ->
	#base_constellation_evolution{equip_type = 5,pos = 3,lv = 1,ev_point = 600,rate = 5000,cost = [{0,38040076,2}],attr = [{2,16000},{4,480},{20,30}]};

get_evolution_cfg(5,3,2) ->
	#base_constellation_evolution{equip_type = 5,pos = 3,lv = 2,ev_point = 800,rate = 4000,cost = [{0,38040076,3}],attr = [{2,32000},{4,960},{20,60}]};

get_evolution_cfg(5,3,3) ->
	#base_constellation_evolution{equip_type = 5,pos = 3,lv = 3,ev_point = 1000,rate = 3000,cost = [{0,38040076,4}],attr = [{2,48000},{4,1440},{20,90}]};

get_evolution_cfg(5,3,4) ->
	#base_constellation_evolution{equip_type = 5,pos = 3,lv = 4,ev_point = 1200,rate = 2000,cost = [{0,38040076,5}],attr = [{2,64000},{4,1920},{20,120}]};

get_evolution_cfg(5,3,5) ->
	#base_constellation_evolution{equip_type = 5,pos = 3,lv = 5,ev_point = 1400,rate = 1000,cost = [{0,38040076,6}],attr = [{2,80000},{4,2400},{20,150}]};

get_evolution_cfg(5,3,6) ->
	#base_constellation_evolution{equip_type = 5,pos = 3,lv = 6,ev_point = 1600,rate = 500,cost = [{0,38040076,7}],attr = [{2,96000},{4,2880},{20,180}]};

get_evolution_cfg(5,3,7) ->
	#base_constellation_evolution{equip_type = 5,pos = 3,lv = 7,ev_point = 1800,rate = 0,cost = [{0,38040076,8}],attr = [{2,112000},{4,3360},{20,210}]};

get_evolution_cfg(5,3,8) ->
	#base_constellation_evolution{equip_type = 5,pos = 3,lv = 8,ev_point = 0,rate = 0,cost = [],attr = [{2,128000},{4,3840},{20,240}]};

get_evolution_cfg(5,4,0) ->
	#base_constellation_evolution{equip_type = 5,pos = 4,lv = 0,ev_point = 400,rate = 6000,cost = [{0,38040076,1}],attr = [{2,0},{4,0},{20,0}]};

get_evolution_cfg(5,4,1) ->
	#base_constellation_evolution{equip_type = 5,pos = 4,lv = 1,ev_point = 600,rate = 5000,cost = [{0,38040076,2}],attr = [{2,16000},{4,480},{20,30}]};

get_evolution_cfg(5,4,2) ->
	#base_constellation_evolution{equip_type = 5,pos = 4,lv = 2,ev_point = 800,rate = 4000,cost = [{0,38040076,3}],attr = [{2,32000},{4,960},{20,60}]};

get_evolution_cfg(5,4,3) ->
	#base_constellation_evolution{equip_type = 5,pos = 4,lv = 3,ev_point = 1000,rate = 3000,cost = [{0,38040076,4}],attr = [{2,48000},{4,1440},{20,90}]};

get_evolution_cfg(5,4,4) ->
	#base_constellation_evolution{equip_type = 5,pos = 4,lv = 4,ev_point = 1200,rate = 2000,cost = [{0,38040076,5}],attr = [{2,64000},{4,1920},{20,120}]};

get_evolution_cfg(5,4,5) ->
	#base_constellation_evolution{equip_type = 5,pos = 4,lv = 5,ev_point = 1400,rate = 1000,cost = [{0,38040076,6}],attr = [{2,80000},{4,2400},{20,150}]};

get_evolution_cfg(5,4,6) ->
	#base_constellation_evolution{equip_type = 5,pos = 4,lv = 6,ev_point = 1600,rate = 500,cost = [{0,38040076,7}],attr = [{2,96000},{4,2880},{20,180}]};

get_evolution_cfg(5,4,7) ->
	#base_constellation_evolution{equip_type = 5,pos = 4,lv = 7,ev_point = 1800,rate = 0,cost = [{0,38040076,8}],attr = [{2,112000},{4,3360},{20,210}]};

get_evolution_cfg(5,4,8) ->
	#base_constellation_evolution{equip_type = 5,pos = 4,lv = 8,ev_point = 0,rate = 0,cost = [],attr = [{2,128000},{4,3840},{20,240}]};

get_evolution_cfg(5,5,0) ->
	#base_constellation_evolution{equip_type = 5,pos = 5,lv = 0,ev_point = 400,rate = 6000,cost = [{0,38040076,1}],attr = [{1,0},{3,0},{21,0}]};

get_evolution_cfg(5,5,1) ->
	#base_constellation_evolution{equip_type = 5,pos = 5,lv = 1,ev_point = 600,rate = 5000,cost = [{0,38040076,2}],attr = [{1,800},{3,480},{21,42}]};

get_evolution_cfg(5,5,2) ->
	#base_constellation_evolution{equip_type = 5,pos = 5,lv = 2,ev_point = 800,rate = 4000,cost = [{0,38040076,3}],attr = [{1,1600},{3,960},{21,84}]};

get_evolution_cfg(5,5,3) ->
	#base_constellation_evolution{equip_type = 5,pos = 5,lv = 3,ev_point = 1000,rate = 3000,cost = [{0,38040076,4}],attr = [{1,2400},{3,1440},{21,126}]};

get_evolution_cfg(5,5,4) ->
	#base_constellation_evolution{equip_type = 5,pos = 5,lv = 4,ev_point = 1200,rate = 2000,cost = [{0,38040076,5}],attr = [{1,3200},{3,1920},{21,168}]};

get_evolution_cfg(5,5,5) ->
	#base_constellation_evolution{equip_type = 5,pos = 5,lv = 5,ev_point = 1400,rate = 1000,cost = [{0,38040076,6}],attr = [{1,4000},{3,2400},{21,210}]};

get_evolution_cfg(5,5,6) ->
	#base_constellation_evolution{equip_type = 5,pos = 5,lv = 6,ev_point = 1600,rate = 500,cost = [{0,38040076,7}],attr = [{1,4800},{3,2880},{21,252}]};

get_evolution_cfg(5,5,7) ->
	#base_constellation_evolution{equip_type = 5,pos = 5,lv = 7,ev_point = 1800,rate = 0,cost = [{0,38040076,8}],attr = [{1,5600},{3,3360},{21,294}]};

get_evolution_cfg(5,5,8) ->
	#base_constellation_evolution{equip_type = 5,pos = 5,lv = 8,ev_point = 0,rate = 0,cost = [],attr = [{1,6400},{3,3840},{21,336}]};

get_evolution_cfg(5,6,0) ->
	#base_constellation_evolution{equip_type = 5,pos = 6,lv = 0,ev_point = 400,rate = 6000,cost = [{0,38040076,1}],attr = [{2,0},{4,0},{22,0}]};

get_evolution_cfg(5,6,1) ->
	#base_constellation_evolution{equip_type = 5,pos = 6,lv = 1,ev_point = 600,rate = 5000,cost = [{0,38040076,2}],attr = [{2,16000},{4,480},{22,60}]};

get_evolution_cfg(5,6,2) ->
	#base_constellation_evolution{equip_type = 5,pos = 6,lv = 2,ev_point = 800,rate = 4000,cost = [{0,38040076,3}],attr = [{2,32000},{4,960},{22,120}]};

get_evolution_cfg(5,6,3) ->
	#base_constellation_evolution{equip_type = 5,pos = 6,lv = 3,ev_point = 1000,rate = 3000,cost = [{0,38040076,4}],attr = [{2,48000},{4,1440},{22,180}]};

get_evolution_cfg(5,6,4) ->
	#base_constellation_evolution{equip_type = 5,pos = 6,lv = 4,ev_point = 1200,rate = 2000,cost = [{0,38040076,5}],attr = [{2,64000},{4,1920},{22,240}]};

get_evolution_cfg(5,6,5) ->
	#base_constellation_evolution{equip_type = 5,pos = 6,lv = 5,ev_point = 1400,rate = 1000,cost = [{0,38040076,6}],attr = [{2,80000},{4,2400},{22,300}]};

get_evolution_cfg(5,6,6) ->
	#base_constellation_evolution{equip_type = 5,pos = 6,lv = 6,ev_point = 1600,rate = 500,cost = [{0,38040076,7}],attr = [{2,96000},{4,2880},{22,360}]};

get_evolution_cfg(5,6,7) ->
	#base_constellation_evolution{equip_type = 5,pos = 6,lv = 7,ev_point = 1800,rate = 0,cost = [{0,38040076,8}],attr = [{2,112000},{4,3360},{22,420}]};

get_evolution_cfg(5,6,8) ->
	#base_constellation_evolution{equip_type = 5,pos = 6,lv = 8,ev_point = 0,rate = 0,cost = [],attr = [{2,128000},{4,3840},{22,480}]};

get_evolution_cfg(_Equiptype,_Pos,_Lv) ->
	#base_constellation_evolution{}.

get_enchantment_cfg(1,1,0) ->
	#base_constellation_enchantment{equip_type = 1,pos = 1,lv = 0,cost = [{0,38040073,1}],attr = [{1,0},{3,0}]};

get_enchantment_cfg(1,1,1) ->
	#base_constellation_enchantment{equip_type = 1,pos = 1,lv = 1,cost = [{0,38040073,2}],attr = [{1,80},{3,48}]};

get_enchantment_cfg(1,1,2) ->
	#base_constellation_enchantment{equip_type = 1,pos = 1,lv = 2,cost = [{0,38040073,3}],attr = [{1,160},{3,96}]};

get_enchantment_cfg(1,1,3) ->
	#base_constellation_enchantment{equip_type = 1,pos = 1,lv = 3,cost = [{0,38040073,4}],attr = [{1,240},{3,144}]};

get_enchantment_cfg(1,1,4) ->
	#base_constellation_enchantment{equip_type = 1,pos = 1,lv = 4,cost = [{0,38040073,5}],attr = [{1,320},{3,192}]};

get_enchantment_cfg(1,1,5) ->
	#base_constellation_enchantment{equip_type = 1,pos = 1,lv = 5,cost = [{0,38040073,6}],attr = [{1,400},{3,240}]};

get_enchantment_cfg(1,1,6) ->
	#base_constellation_enchantment{equip_type = 1,pos = 1,lv = 6,cost = [{0,38040073,7}],attr = [{1,480},{3,288}]};

get_enchantment_cfg(1,1,7) ->
	#base_constellation_enchantment{equip_type = 1,pos = 1,lv = 7,cost = [{0,38040073,8}],attr = [{1,560},{3,336}]};

get_enchantment_cfg(1,1,8) ->
	#base_constellation_enchantment{equip_type = 1,pos = 1,lv = 8,cost = [{0,38040073,9}],attr = [{1,640},{3,384}]};

get_enchantment_cfg(1,1,9) ->
	#base_constellation_enchantment{equip_type = 1,pos = 1,lv = 9,cost = [{0,38040073,10}],attr = [{1,720},{3,432}]};

get_enchantment_cfg(1,1,10) ->
	#base_constellation_enchantment{equip_type = 1,pos = 1,lv = 10,cost = [{0,38040073,11}],attr = [{1,800},{3,480}]};

get_enchantment_cfg(1,1,11) ->
	#base_constellation_enchantment{equip_type = 1,pos = 1,lv = 11,cost = [{0,38040073,12}],attr = [{1,880},{3,528}]};

get_enchantment_cfg(1,1,12) ->
	#base_constellation_enchantment{equip_type = 1,pos = 1,lv = 12,cost = [{0,38040073,13}],attr = [{1,960},{3,576}]};

get_enchantment_cfg(1,1,13) ->
	#base_constellation_enchantment{equip_type = 1,pos = 1,lv = 13,cost = [{0,38040073,14}],attr = [{1,1040},{3,624}]};

get_enchantment_cfg(1,1,14) ->
	#base_constellation_enchantment{equip_type = 1,pos = 1,lv = 14,cost = [{0,38040073,15}],attr = [{1,1120},{3,672}]};

get_enchantment_cfg(1,1,15) ->
	#base_constellation_enchantment{equip_type = 1,pos = 1,lv = 15,cost = [{0,38040073,16}],attr = [{1,1200},{3,720}]};

get_enchantment_cfg(1,1,16) ->
	#base_constellation_enchantment{equip_type = 1,pos = 1,lv = 16,cost = [{0,38040073,17}],attr = [{1,1280},{3,768}]};

get_enchantment_cfg(1,1,17) ->
	#base_constellation_enchantment{equip_type = 1,pos = 1,lv = 17,cost = [{0,38040073,18}],attr = [{1,1360},{3,816}]};

get_enchantment_cfg(1,1,18) ->
	#base_constellation_enchantment{equip_type = 1,pos = 1,lv = 18,cost = [{0,38040073,19}],attr = [{1,1440},{3,864}]};

get_enchantment_cfg(1,1,19) ->
	#base_constellation_enchantment{equip_type = 1,pos = 1,lv = 19,cost = [{0,38040073,20}],attr = [{1,1520},{3,912}]};

get_enchantment_cfg(1,1,20) ->
	#base_constellation_enchantment{equip_type = 1,pos = 1,lv = 20,cost = [{0,38040073,21}],attr = [{1,1600},{3,960}]};

get_enchantment_cfg(1,1,21) ->
	#base_constellation_enchantment{equip_type = 1,pos = 1,lv = 21,cost = [{0,38040073,22}],attr = [{1,1680},{3,1008}]};

get_enchantment_cfg(1,1,22) ->
	#base_constellation_enchantment{equip_type = 1,pos = 1,lv = 22,cost = [{0,38040073,23}],attr = [{1,1760},{3,1056}]};

get_enchantment_cfg(1,1,23) ->
	#base_constellation_enchantment{equip_type = 1,pos = 1,lv = 23,cost = [{0,38040073,24}],attr = [{1,1840},{3,1104}]};

get_enchantment_cfg(1,1,24) ->
	#base_constellation_enchantment{equip_type = 1,pos = 1,lv = 24,cost = [{0,38040073,25}],attr = [{1,1920},{3,1152}]};

get_enchantment_cfg(1,1,25) ->
	#base_constellation_enchantment{equip_type = 1,pos = 1,lv = 25,cost = [{0,38040073,26}],attr = [{1,2000},{3,1200}]};

get_enchantment_cfg(1,1,26) ->
	#base_constellation_enchantment{equip_type = 1,pos = 1,lv = 26,cost = [{0,38040073,27}],attr = [{1,2080},{3,1248}]};

get_enchantment_cfg(1,1,27) ->
	#base_constellation_enchantment{equip_type = 1,pos = 1,lv = 27,cost = [{0,38040073,28}],attr = [{1,2160},{3,1296}]};

get_enchantment_cfg(1,1,28) ->
	#base_constellation_enchantment{equip_type = 1,pos = 1,lv = 28,cost = [{0,38040073,29}],attr = [{1,2240},{3,1344}]};

get_enchantment_cfg(1,1,29) ->
	#base_constellation_enchantment{equip_type = 1,pos = 1,lv = 29,cost = [{0,38040073,30}],attr = [{1,2320},{3,1392}]};

get_enchantment_cfg(1,1,30) ->
	#base_constellation_enchantment{equip_type = 1,pos = 1,lv = 30,cost = [],attr = [{1,2400},{3,1440}]};

get_enchantment_cfg(1,2,0) ->
	#base_constellation_enchantment{equip_type = 1,pos = 2,lv = 0,cost = [{0,38040073,1}],attr = [{2,0},{4,0}]};

get_enchantment_cfg(1,2,1) ->
	#base_constellation_enchantment{equip_type = 1,pos = 2,lv = 1,cost = [{0,38040073,2}],attr = [{2,1600},{4,48}]};

get_enchantment_cfg(1,2,2) ->
	#base_constellation_enchantment{equip_type = 1,pos = 2,lv = 2,cost = [{0,38040073,3}],attr = [{2,3200},{4,96}]};

get_enchantment_cfg(1,2,3) ->
	#base_constellation_enchantment{equip_type = 1,pos = 2,lv = 3,cost = [{0,38040073,4}],attr = [{2,4800},{4,144}]};

get_enchantment_cfg(1,2,4) ->
	#base_constellation_enchantment{equip_type = 1,pos = 2,lv = 4,cost = [{0,38040073,5}],attr = [{2,6400},{4,192}]};

get_enchantment_cfg(1,2,5) ->
	#base_constellation_enchantment{equip_type = 1,pos = 2,lv = 5,cost = [{0,38040073,6}],attr = [{2,8000},{4,240}]};

get_enchantment_cfg(1,2,6) ->
	#base_constellation_enchantment{equip_type = 1,pos = 2,lv = 6,cost = [{0,38040073,7}],attr = [{2,9600},{4,288}]};

get_enchantment_cfg(1,2,7) ->
	#base_constellation_enchantment{equip_type = 1,pos = 2,lv = 7,cost = [{0,38040073,8}],attr = [{2,11200},{4,336}]};

get_enchantment_cfg(1,2,8) ->
	#base_constellation_enchantment{equip_type = 1,pos = 2,lv = 8,cost = [{0,38040073,9}],attr = [{2,12800},{4,384}]};

get_enchantment_cfg(1,2,9) ->
	#base_constellation_enchantment{equip_type = 1,pos = 2,lv = 9,cost = [{0,38040073,10}],attr = [{2,14400},{4,432}]};

get_enchantment_cfg(1,2,10) ->
	#base_constellation_enchantment{equip_type = 1,pos = 2,lv = 10,cost = [{0,38040073,11}],attr = [{2,16000},{4,480}]};

get_enchantment_cfg(1,2,11) ->
	#base_constellation_enchantment{equip_type = 1,pos = 2,lv = 11,cost = [{0,38040073,12}],attr = [{2,17600},{4,528}]};

get_enchantment_cfg(1,2,12) ->
	#base_constellation_enchantment{equip_type = 1,pos = 2,lv = 12,cost = [{0,38040073,13}],attr = [{2,19200},{4,576}]};

get_enchantment_cfg(1,2,13) ->
	#base_constellation_enchantment{equip_type = 1,pos = 2,lv = 13,cost = [{0,38040073,14}],attr = [{2,20800},{4,624}]};

get_enchantment_cfg(1,2,14) ->
	#base_constellation_enchantment{equip_type = 1,pos = 2,lv = 14,cost = [{0,38040073,15}],attr = [{2,22400},{4,672}]};

get_enchantment_cfg(1,2,15) ->
	#base_constellation_enchantment{equip_type = 1,pos = 2,lv = 15,cost = [{0,38040073,16}],attr = [{2,24000},{4,720}]};

get_enchantment_cfg(1,2,16) ->
	#base_constellation_enchantment{equip_type = 1,pos = 2,lv = 16,cost = [{0,38040073,17}],attr = [{2,25600},{4,768}]};

get_enchantment_cfg(1,2,17) ->
	#base_constellation_enchantment{equip_type = 1,pos = 2,lv = 17,cost = [{0,38040073,18}],attr = [{2,27200},{4,816}]};

get_enchantment_cfg(1,2,18) ->
	#base_constellation_enchantment{equip_type = 1,pos = 2,lv = 18,cost = [{0,38040073,19}],attr = [{2,28800},{4,864}]};

get_enchantment_cfg(1,2,19) ->
	#base_constellation_enchantment{equip_type = 1,pos = 2,lv = 19,cost = [{0,38040073,20}],attr = [{2,30400},{4,912}]};

get_enchantment_cfg(1,2,20) ->
	#base_constellation_enchantment{equip_type = 1,pos = 2,lv = 20,cost = [{0,38040073,21}],attr = [{2,32000},{4,960}]};

get_enchantment_cfg(1,2,21) ->
	#base_constellation_enchantment{equip_type = 1,pos = 2,lv = 21,cost = [{0,38040073,22}],attr = [{2,33600},{4,1008}]};

get_enchantment_cfg(1,2,22) ->
	#base_constellation_enchantment{equip_type = 1,pos = 2,lv = 22,cost = [{0,38040073,23}],attr = [{2,35200},{4,1056}]};

get_enchantment_cfg(1,2,23) ->
	#base_constellation_enchantment{equip_type = 1,pos = 2,lv = 23,cost = [{0,38040073,24}],attr = [{2,36800},{4,1104}]};

get_enchantment_cfg(1,2,24) ->
	#base_constellation_enchantment{equip_type = 1,pos = 2,lv = 24,cost = [{0,38040073,25}],attr = [{2,38400},{4,1152}]};

get_enchantment_cfg(1,2,25) ->
	#base_constellation_enchantment{equip_type = 1,pos = 2,lv = 25,cost = [{0,38040073,26}],attr = [{2,40000},{4,1200}]};

get_enchantment_cfg(1,2,26) ->
	#base_constellation_enchantment{equip_type = 1,pos = 2,lv = 26,cost = [{0,38040073,27}],attr = [{2,41600},{4,1248}]};

get_enchantment_cfg(1,2,27) ->
	#base_constellation_enchantment{equip_type = 1,pos = 2,lv = 27,cost = [{0,38040073,28}],attr = [{2,43200},{4,1296}]};

get_enchantment_cfg(1,2,28) ->
	#base_constellation_enchantment{equip_type = 1,pos = 2,lv = 28,cost = [{0,38040073,29}],attr = [{2,44800},{4,1344}]};

get_enchantment_cfg(1,2,29) ->
	#base_constellation_enchantment{equip_type = 1,pos = 2,lv = 29,cost = [{0,38040073,30}],attr = [{2,46400},{4,1392}]};

get_enchantment_cfg(1,2,30) ->
	#base_constellation_enchantment{equip_type = 1,pos = 2,lv = 30,cost = [],attr = [{2,48000},{4,1440}]};

get_enchantment_cfg(1,3,0) ->
	#base_constellation_enchantment{equip_type = 1,pos = 3,lv = 0,cost = [{0,38040073,1}],attr = [{2,0},{4,0}]};

get_enchantment_cfg(1,3,1) ->
	#base_constellation_enchantment{equip_type = 1,pos = 3,lv = 1,cost = [{0,38040073,2}],attr = [{2,1600},{4,48}]};

get_enchantment_cfg(1,3,2) ->
	#base_constellation_enchantment{equip_type = 1,pos = 3,lv = 2,cost = [{0,38040073,3}],attr = [{2,3200},{4,96}]};

get_enchantment_cfg(1,3,3) ->
	#base_constellation_enchantment{equip_type = 1,pos = 3,lv = 3,cost = [{0,38040073,4}],attr = [{2,4800},{4,144}]};

get_enchantment_cfg(1,3,4) ->
	#base_constellation_enchantment{equip_type = 1,pos = 3,lv = 4,cost = [{0,38040073,5}],attr = [{2,6400},{4,192}]};

get_enchantment_cfg(1,3,5) ->
	#base_constellation_enchantment{equip_type = 1,pos = 3,lv = 5,cost = [{0,38040073,6}],attr = [{2,8000},{4,240}]};

get_enchantment_cfg(1,3,6) ->
	#base_constellation_enchantment{equip_type = 1,pos = 3,lv = 6,cost = [{0,38040073,7}],attr = [{2,9600},{4,288}]};

get_enchantment_cfg(1,3,7) ->
	#base_constellation_enchantment{equip_type = 1,pos = 3,lv = 7,cost = [{0,38040073,8}],attr = [{2,11200},{4,336}]};

get_enchantment_cfg(1,3,8) ->
	#base_constellation_enchantment{equip_type = 1,pos = 3,lv = 8,cost = [{0,38040073,9}],attr = [{2,12800},{4,384}]};

get_enchantment_cfg(1,3,9) ->
	#base_constellation_enchantment{equip_type = 1,pos = 3,lv = 9,cost = [{0,38040073,10}],attr = [{2,14400},{4,432}]};

get_enchantment_cfg(1,3,10) ->
	#base_constellation_enchantment{equip_type = 1,pos = 3,lv = 10,cost = [{0,38040073,11}],attr = [{2,16000},{4,480}]};

get_enchantment_cfg(1,3,11) ->
	#base_constellation_enchantment{equip_type = 1,pos = 3,lv = 11,cost = [{0,38040073,12}],attr = [{2,17600},{4,528}]};

get_enchantment_cfg(1,3,12) ->
	#base_constellation_enchantment{equip_type = 1,pos = 3,lv = 12,cost = [{0,38040073,13}],attr = [{2,19200},{4,576}]};

get_enchantment_cfg(1,3,13) ->
	#base_constellation_enchantment{equip_type = 1,pos = 3,lv = 13,cost = [{0,38040073,14}],attr = [{2,20800},{4,624}]};

get_enchantment_cfg(1,3,14) ->
	#base_constellation_enchantment{equip_type = 1,pos = 3,lv = 14,cost = [{0,38040073,15}],attr = [{2,22400},{4,672}]};

get_enchantment_cfg(1,3,15) ->
	#base_constellation_enchantment{equip_type = 1,pos = 3,lv = 15,cost = [{0,38040073,16}],attr = [{2,24000},{4,720}]};

get_enchantment_cfg(1,3,16) ->
	#base_constellation_enchantment{equip_type = 1,pos = 3,lv = 16,cost = [{0,38040073,17}],attr = [{2,25600},{4,768}]};

get_enchantment_cfg(1,3,17) ->
	#base_constellation_enchantment{equip_type = 1,pos = 3,lv = 17,cost = [{0,38040073,18}],attr = [{2,27200},{4,816}]};

get_enchantment_cfg(1,3,18) ->
	#base_constellation_enchantment{equip_type = 1,pos = 3,lv = 18,cost = [{0,38040073,19}],attr = [{2,28800},{4,864}]};

get_enchantment_cfg(1,3,19) ->
	#base_constellation_enchantment{equip_type = 1,pos = 3,lv = 19,cost = [{0,38040073,20}],attr = [{2,30400},{4,912}]};

get_enchantment_cfg(1,3,20) ->
	#base_constellation_enchantment{equip_type = 1,pos = 3,lv = 20,cost = [{0,38040073,21}],attr = [{2,32000},{4,960}]};

get_enchantment_cfg(1,3,21) ->
	#base_constellation_enchantment{equip_type = 1,pos = 3,lv = 21,cost = [{0,38040073,22}],attr = [{2,33600},{4,1008}]};

get_enchantment_cfg(1,3,22) ->
	#base_constellation_enchantment{equip_type = 1,pos = 3,lv = 22,cost = [{0,38040073,23}],attr = [{2,35200},{4,1056}]};

get_enchantment_cfg(1,3,23) ->
	#base_constellation_enchantment{equip_type = 1,pos = 3,lv = 23,cost = [{0,38040073,24}],attr = [{2,36800},{4,1104}]};

get_enchantment_cfg(1,3,24) ->
	#base_constellation_enchantment{equip_type = 1,pos = 3,lv = 24,cost = [{0,38040073,25}],attr = [{2,38400},{4,1152}]};

get_enchantment_cfg(1,3,25) ->
	#base_constellation_enchantment{equip_type = 1,pos = 3,lv = 25,cost = [{0,38040073,26}],attr = [{2,40000},{4,1200}]};

get_enchantment_cfg(1,3,26) ->
	#base_constellation_enchantment{equip_type = 1,pos = 3,lv = 26,cost = [{0,38040073,27}],attr = [{2,41600},{4,1248}]};

get_enchantment_cfg(1,3,27) ->
	#base_constellation_enchantment{equip_type = 1,pos = 3,lv = 27,cost = [{0,38040073,28}],attr = [{2,43200},{4,1296}]};

get_enchantment_cfg(1,3,28) ->
	#base_constellation_enchantment{equip_type = 1,pos = 3,lv = 28,cost = [{0,38040073,29}],attr = [{2,44800},{4,1344}]};

get_enchantment_cfg(1,3,29) ->
	#base_constellation_enchantment{equip_type = 1,pos = 3,lv = 29,cost = [{0,38040073,30}],attr = [{2,46400},{4,1392}]};

get_enchantment_cfg(1,3,30) ->
	#base_constellation_enchantment{equip_type = 1,pos = 3,lv = 30,cost = [],attr = [{2,48000},{4,1440}]};

get_enchantment_cfg(1,4,0) ->
	#base_constellation_enchantment{equip_type = 1,pos = 4,lv = 0,cost = [{0,38040073,1}],attr = [{2,0},{4,0}]};

get_enchantment_cfg(1,4,1) ->
	#base_constellation_enchantment{equip_type = 1,pos = 4,lv = 1,cost = [{0,38040073,2}],attr = [{2,1600},{4,48}]};

get_enchantment_cfg(1,4,2) ->
	#base_constellation_enchantment{equip_type = 1,pos = 4,lv = 2,cost = [{0,38040073,3}],attr = [{2,3200},{4,96}]};

get_enchantment_cfg(1,4,3) ->
	#base_constellation_enchantment{equip_type = 1,pos = 4,lv = 3,cost = [{0,38040073,4}],attr = [{2,4800},{4,144}]};

get_enchantment_cfg(1,4,4) ->
	#base_constellation_enchantment{equip_type = 1,pos = 4,lv = 4,cost = [{0,38040073,5}],attr = [{2,6400},{4,192}]};

get_enchantment_cfg(1,4,5) ->
	#base_constellation_enchantment{equip_type = 1,pos = 4,lv = 5,cost = [{0,38040073,6}],attr = [{2,8000},{4,240}]};

get_enchantment_cfg(1,4,6) ->
	#base_constellation_enchantment{equip_type = 1,pos = 4,lv = 6,cost = [{0,38040073,7}],attr = [{2,9600},{4,288}]};

get_enchantment_cfg(1,4,7) ->
	#base_constellation_enchantment{equip_type = 1,pos = 4,lv = 7,cost = [{0,38040073,8}],attr = [{2,11200},{4,336}]};

get_enchantment_cfg(1,4,8) ->
	#base_constellation_enchantment{equip_type = 1,pos = 4,lv = 8,cost = [{0,38040073,9}],attr = [{2,12800},{4,384}]};

get_enchantment_cfg(1,4,9) ->
	#base_constellation_enchantment{equip_type = 1,pos = 4,lv = 9,cost = [{0,38040073,10}],attr = [{2,14400},{4,432}]};

get_enchantment_cfg(1,4,10) ->
	#base_constellation_enchantment{equip_type = 1,pos = 4,lv = 10,cost = [{0,38040073,11}],attr = [{2,16000},{4,480}]};

get_enchantment_cfg(1,4,11) ->
	#base_constellation_enchantment{equip_type = 1,pos = 4,lv = 11,cost = [{0,38040073,12}],attr = [{2,17600},{4,528}]};

get_enchantment_cfg(1,4,12) ->
	#base_constellation_enchantment{equip_type = 1,pos = 4,lv = 12,cost = [{0,38040073,13}],attr = [{2,19200},{4,576}]};

get_enchantment_cfg(1,4,13) ->
	#base_constellation_enchantment{equip_type = 1,pos = 4,lv = 13,cost = [{0,38040073,14}],attr = [{2,20800},{4,624}]};

get_enchantment_cfg(1,4,14) ->
	#base_constellation_enchantment{equip_type = 1,pos = 4,lv = 14,cost = [{0,38040073,15}],attr = [{2,22400},{4,672}]};

get_enchantment_cfg(1,4,15) ->
	#base_constellation_enchantment{equip_type = 1,pos = 4,lv = 15,cost = [{0,38040073,16}],attr = [{2,24000},{4,720}]};

get_enchantment_cfg(1,4,16) ->
	#base_constellation_enchantment{equip_type = 1,pos = 4,lv = 16,cost = [{0,38040073,17}],attr = [{2,25600},{4,768}]};

get_enchantment_cfg(1,4,17) ->
	#base_constellation_enchantment{equip_type = 1,pos = 4,lv = 17,cost = [{0,38040073,18}],attr = [{2,27200},{4,816}]};

get_enchantment_cfg(1,4,18) ->
	#base_constellation_enchantment{equip_type = 1,pos = 4,lv = 18,cost = [{0,38040073,19}],attr = [{2,28800},{4,864}]};

get_enchantment_cfg(1,4,19) ->
	#base_constellation_enchantment{equip_type = 1,pos = 4,lv = 19,cost = [{0,38040073,20}],attr = [{2,30400},{4,912}]};

get_enchantment_cfg(1,4,20) ->
	#base_constellation_enchantment{equip_type = 1,pos = 4,lv = 20,cost = [{0,38040073,21}],attr = [{2,32000},{4,960}]};

get_enchantment_cfg(1,4,21) ->
	#base_constellation_enchantment{equip_type = 1,pos = 4,lv = 21,cost = [{0,38040073,22}],attr = [{2,33600},{4,1008}]};

get_enchantment_cfg(1,4,22) ->
	#base_constellation_enchantment{equip_type = 1,pos = 4,lv = 22,cost = [{0,38040073,23}],attr = [{2,35200},{4,1056}]};

get_enchantment_cfg(1,4,23) ->
	#base_constellation_enchantment{equip_type = 1,pos = 4,lv = 23,cost = [{0,38040073,24}],attr = [{2,36800},{4,1104}]};

get_enchantment_cfg(1,4,24) ->
	#base_constellation_enchantment{equip_type = 1,pos = 4,lv = 24,cost = [{0,38040073,25}],attr = [{2,38400},{4,1152}]};

get_enchantment_cfg(1,4,25) ->
	#base_constellation_enchantment{equip_type = 1,pos = 4,lv = 25,cost = [{0,38040073,26}],attr = [{2,40000},{4,1200}]};

get_enchantment_cfg(1,4,26) ->
	#base_constellation_enchantment{equip_type = 1,pos = 4,lv = 26,cost = [{0,38040073,27}],attr = [{2,41600},{4,1248}]};

get_enchantment_cfg(1,4,27) ->
	#base_constellation_enchantment{equip_type = 1,pos = 4,lv = 27,cost = [{0,38040073,28}],attr = [{2,43200},{4,1296}]};

get_enchantment_cfg(1,4,28) ->
	#base_constellation_enchantment{equip_type = 1,pos = 4,lv = 28,cost = [{0,38040073,29}],attr = [{2,44800},{4,1344}]};

get_enchantment_cfg(1,4,29) ->
	#base_constellation_enchantment{equip_type = 1,pos = 4,lv = 29,cost = [{0,38040073,30}],attr = [{2,46400},{4,1392}]};

get_enchantment_cfg(1,4,30) ->
	#base_constellation_enchantment{equip_type = 1,pos = 4,lv = 30,cost = [],attr = [{2,48000},{4,1440}]};

get_enchantment_cfg(1,5,0) ->
	#base_constellation_enchantment{equip_type = 1,pos = 5,lv = 0,cost = [{0,38040073,1}],attr = [{1,0},{3,0}]};

get_enchantment_cfg(1,5,1) ->
	#base_constellation_enchantment{equip_type = 1,pos = 5,lv = 1,cost = [{0,38040073,2}],attr = [{1,80},{3,48}]};

get_enchantment_cfg(1,5,2) ->
	#base_constellation_enchantment{equip_type = 1,pos = 5,lv = 2,cost = [{0,38040073,3}],attr = [{1,160},{3,96}]};

get_enchantment_cfg(1,5,3) ->
	#base_constellation_enchantment{equip_type = 1,pos = 5,lv = 3,cost = [{0,38040073,4}],attr = [{1,240},{3,144}]};

get_enchantment_cfg(1,5,4) ->
	#base_constellation_enchantment{equip_type = 1,pos = 5,lv = 4,cost = [{0,38040073,5}],attr = [{1,320},{3,192}]};

get_enchantment_cfg(1,5,5) ->
	#base_constellation_enchantment{equip_type = 1,pos = 5,lv = 5,cost = [{0,38040073,6}],attr = [{1,400},{3,240}]};

get_enchantment_cfg(1,5,6) ->
	#base_constellation_enchantment{equip_type = 1,pos = 5,lv = 6,cost = [{0,38040073,7}],attr = [{1,480},{3,288}]};

get_enchantment_cfg(1,5,7) ->
	#base_constellation_enchantment{equip_type = 1,pos = 5,lv = 7,cost = [{0,38040073,8}],attr = [{1,560},{3,336}]};

get_enchantment_cfg(1,5,8) ->
	#base_constellation_enchantment{equip_type = 1,pos = 5,lv = 8,cost = [{0,38040073,9}],attr = [{1,640},{3,384}]};

get_enchantment_cfg(1,5,9) ->
	#base_constellation_enchantment{equip_type = 1,pos = 5,lv = 9,cost = [{0,38040073,10}],attr = [{1,720},{3,432}]};

get_enchantment_cfg(1,5,10) ->
	#base_constellation_enchantment{equip_type = 1,pos = 5,lv = 10,cost = [{0,38040073,11}],attr = [{1,800},{3,480}]};

get_enchantment_cfg(1,5,11) ->
	#base_constellation_enchantment{equip_type = 1,pos = 5,lv = 11,cost = [{0,38040073,12}],attr = [{1,880},{3,528}]};

get_enchantment_cfg(1,5,12) ->
	#base_constellation_enchantment{equip_type = 1,pos = 5,lv = 12,cost = [{0,38040073,13}],attr = [{1,960},{3,576}]};

get_enchantment_cfg(1,5,13) ->
	#base_constellation_enchantment{equip_type = 1,pos = 5,lv = 13,cost = [{0,38040073,14}],attr = [{1,1040},{3,624}]};

get_enchantment_cfg(1,5,14) ->
	#base_constellation_enchantment{equip_type = 1,pos = 5,lv = 14,cost = [{0,38040073,15}],attr = [{1,1120},{3,672}]};

get_enchantment_cfg(1,5,15) ->
	#base_constellation_enchantment{equip_type = 1,pos = 5,lv = 15,cost = [{0,38040073,16}],attr = [{1,1200},{3,720}]};

get_enchantment_cfg(1,5,16) ->
	#base_constellation_enchantment{equip_type = 1,pos = 5,lv = 16,cost = [{0,38040073,17}],attr = [{1,1280},{3,768}]};

get_enchantment_cfg(1,5,17) ->
	#base_constellation_enchantment{equip_type = 1,pos = 5,lv = 17,cost = [{0,38040073,18}],attr = [{1,1360},{3,816}]};

get_enchantment_cfg(1,5,18) ->
	#base_constellation_enchantment{equip_type = 1,pos = 5,lv = 18,cost = [{0,38040073,19}],attr = [{1,1440},{3,864}]};

get_enchantment_cfg(1,5,19) ->
	#base_constellation_enchantment{equip_type = 1,pos = 5,lv = 19,cost = [{0,38040073,20}],attr = [{1,1520},{3,912}]};

get_enchantment_cfg(1,5,20) ->
	#base_constellation_enchantment{equip_type = 1,pos = 5,lv = 20,cost = [{0,38040073,21}],attr = [{1,1600},{3,960}]};

get_enchantment_cfg(1,5,21) ->
	#base_constellation_enchantment{equip_type = 1,pos = 5,lv = 21,cost = [{0,38040073,22}],attr = [{1,1680},{3,1008}]};

get_enchantment_cfg(1,5,22) ->
	#base_constellation_enchantment{equip_type = 1,pos = 5,lv = 22,cost = [{0,38040073,23}],attr = [{1,1760},{3,1056}]};

get_enchantment_cfg(1,5,23) ->
	#base_constellation_enchantment{equip_type = 1,pos = 5,lv = 23,cost = [{0,38040073,24}],attr = [{1,1840},{3,1104}]};

get_enchantment_cfg(1,5,24) ->
	#base_constellation_enchantment{equip_type = 1,pos = 5,lv = 24,cost = [{0,38040073,25}],attr = [{1,1920},{3,1152}]};

get_enchantment_cfg(1,5,25) ->
	#base_constellation_enchantment{equip_type = 1,pos = 5,lv = 25,cost = [{0,38040073,26}],attr = [{1,2000},{3,1200}]};

get_enchantment_cfg(1,5,26) ->
	#base_constellation_enchantment{equip_type = 1,pos = 5,lv = 26,cost = [{0,38040073,27}],attr = [{1,2080},{3,1248}]};

get_enchantment_cfg(1,5,27) ->
	#base_constellation_enchantment{equip_type = 1,pos = 5,lv = 27,cost = [{0,38040073,28}],attr = [{1,2160},{3,1296}]};

get_enchantment_cfg(1,5,28) ->
	#base_constellation_enchantment{equip_type = 1,pos = 5,lv = 28,cost = [{0,38040073,29}],attr = [{1,2240},{3,1344}]};

get_enchantment_cfg(1,5,29) ->
	#base_constellation_enchantment{equip_type = 1,pos = 5,lv = 29,cost = [{0,38040073,30}],attr = [{1,2320},{3,1392}]};

get_enchantment_cfg(1,5,30) ->
	#base_constellation_enchantment{equip_type = 1,pos = 5,lv = 30,cost = [],attr = [{1,2400},{3,1440}]};

get_enchantment_cfg(1,6,0) ->
	#base_constellation_enchantment{equip_type = 1,pos = 6,lv = 0,cost = [{0,38040073,1}],attr = [{2,0},{4,0}]};

get_enchantment_cfg(1,6,1) ->
	#base_constellation_enchantment{equip_type = 1,pos = 6,lv = 1,cost = [{0,38040073,2}],attr = [{2,1600},{4,48}]};

get_enchantment_cfg(1,6,2) ->
	#base_constellation_enchantment{equip_type = 1,pos = 6,lv = 2,cost = [{0,38040073,3}],attr = [{2,3200},{4,96}]};

get_enchantment_cfg(1,6,3) ->
	#base_constellation_enchantment{equip_type = 1,pos = 6,lv = 3,cost = [{0,38040073,4}],attr = [{2,4800},{4,144}]};

get_enchantment_cfg(1,6,4) ->
	#base_constellation_enchantment{equip_type = 1,pos = 6,lv = 4,cost = [{0,38040073,5}],attr = [{2,6400},{4,192}]};

get_enchantment_cfg(1,6,5) ->
	#base_constellation_enchantment{equip_type = 1,pos = 6,lv = 5,cost = [{0,38040073,6}],attr = [{2,8000},{4,240}]};

get_enchantment_cfg(1,6,6) ->
	#base_constellation_enchantment{equip_type = 1,pos = 6,lv = 6,cost = [{0,38040073,7}],attr = [{2,9600},{4,288}]};

get_enchantment_cfg(1,6,7) ->
	#base_constellation_enchantment{equip_type = 1,pos = 6,lv = 7,cost = [{0,38040073,8}],attr = [{2,11200},{4,336}]};

get_enchantment_cfg(1,6,8) ->
	#base_constellation_enchantment{equip_type = 1,pos = 6,lv = 8,cost = [{0,38040073,9}],attr = [{2,12800},{4,384}]};

get_enchantment_cfg(1,6,9) ->
	#base_constellation_enchantment{equip_type = 1,pos = 6,lv = 9,cost = [{0,38040073,10}],attr = [{2,14400},{4,432}]};

get_enchantment_cfg(1,6,10) ->
	#base_constellation_enchantment{equip_type = 1,pos = 6,lv = 10,cost = [{0,38040073,11}],attr = [{2,16000},{4,480}]};

get_enchantment_cfg(1,6,11) ->
	#base_constellation_enchantment{equip_type = 1,pos = 6,lv = 11,cost = [{0,38040073,12}],attr = [{2,17600},{4,528}]};

get_enchantment_cfg(1,6,12) ->
	#base_constellation_enchantment{equip_type = 1,pos = 6,lv = 12,cost = [{0,38040073,13}],attr = [{2,19200},{4,576}]};

get_enchantment_cfg(1,6,13) ->
	#base_constellation_enchantment{equip_type = 1,pos = 6,lv = 13,cost = [{0,38040073,14}],attr = [{2,20800},{4,624}]};

get_enchantment_cfg(1,6,14) ->
	#base_constellation_enchantment{equip_type = 1,pos = 6,lv = 14,cost = [{0,38040073,15}],attr = [{2,22400},{4,672}]};

get_enchantment_cfg(1,6,15) ->
	#base_constellation_enchantment{equip_type = 1,pos = 6,lv = 15,cost = [{0,38040073,16}],attr = [{2,24000},{4,720}]};

get_enchantment_cfg(1,6,16) ->
	#base_constellation_enchantment{equip_type = 1,pos = 6,lv = 16,cost = [{0,38040073,17}],attr = [{2,25600},{4,768}]};

get_enchantment_cfg(1,6,17) ->
	#base_constellation_enchantment{equip_type = 1,pos = 6,lv = 17,cost = [{0,38040073,18}],attr = [{2,27200},{4,816}]};

get_enchantment_cfg(1,6,18) ->
	#base_constellation_enchantment{equip_type = 1,pos = 6,lv = 18,cost = [{0,38040073,19}],attr = [{2,28800},{4,864}]};

get_enchantment_cfg(1,6,19) ->
	#base_constellation_enchantment{equip_type = 1,pos = 6,lv = 19,cost = [{0,38040073,20}],attr = [{2,30400},{4,912}]};

get_enchantment_cfg(1,6,20) ->
	#base_constellation_enchantment{equip_type = 1,pos = 6,lv = 20,cost = [{0,38040073,21}],attr = [{2,32000},{4,960}]};

get_enchantment_cfg(1,6,21) ->
	#base_constellation_enchantment{equip_type = 1,pos = 6,lv = 21,cost = [{0,38040073,22}],attr = [{2,33600},{4,1008}]};

get_enchantment_cfg(1,6,22) ->
	#base_constellation_enchantment{equip_type = 1,pos = 6,lv = 22,cost = [{0,38040073,23}],attr = [{2,35200},{4,1056}]};

get_enchantment_cfg(1,6,23) ->
	#base_constellation_enchantment{equip_type = 1,pos = 6,lv = 23,cost = [{0,38040073,24}],attr = [{2,36800},{4,1104}]};

get_enchantment_cfg(1,6,24) ->
	#base_constellation_enchantment{equip_type = 1,pos = 6,lv = 24,cost = [{0,38040073,25}],attr = [{2,38400},{4,1152}]};

get_enchantment_cfg(1,6,25) ->
	#base_constellation_enchantment{equip_type = 1,pos = 6,lv = 25,cost = [{0,38040073,26}],attr = [{2,40000},{4,1200}]};

get_enchantment_cfg(1,6,26) ->
	#base_constellation_enchantment{equip_type = 1,pos = 6,lv = 26,cost = [{0,38040073,27}],attr = [{2,41600},{4,1248}]};

get_enchantment_cfg(1,6,27) ->
	#base_constellation_enchantment{equip_type = 1,pos = 6,lv = 27,cost = [{0,38040073,28}],attr = [{2,43200},{4,1296}]};

get_enchantment_cfg(1,6,28) ->
	#base_constellation_enchantment{equip_type = 1,pos = 6,lv = 28,cost = [{0,38040073,29}],attr = [{2,44800},{4,1344}]};

get_enchantment_cfg(1,6,29) ->
	#base_constellation_enchantment{equip_type = 1,pos = 6,lv = 29,cost = [{0,38040073,30}],attr = [{2,46400},{4,1392}]};

get_enchantment_cfg(1,6,30) ->
	#base_constellation_enchantment{equip_type = 1,pos = 6,lv = 30,cost = [],attr = [{2,48000},{4,1440}]};

get_enchantment_cfg(2,1,0) ->
	#base_constellation_enchantment{equip_type = 2,pos = 1,lv = 0,cost = [{0,38040073,1}],attr = [{1,0},{3,0}]};

get_enchantment_cfg(2,1,1) ->
	#base_constellation_enchantment{equip_type = 2,pos = 1,lv = 1,cost = [{0,38040073,2}],attr = [{1,120},{3,72}]};

get_enchantment_cfg(2,1,2) ->
	#base_constellation_enchantment{equip_type = 2,pos = 1,lv = 2,cost = [{0,38040073,3}],attr = [{1,240},{3,144}]};

get_enchantment_cfg(2,1,3) ->
	#base_constellation_enchantment{equip_type = 2,pos = 1,lv = 3,cost = [{0,38040073,4}],attr = [{1,360},{3,216}]};

get_enchantment_cfg(2,1,4) ->
	#base_constellation_enchantment{equip_type = 2,pos = 1,lv = 4,cost = [{0,38040073,5}],attr = [{1,480},{3,288}]};

get_enchantment_cfg(2,1,5) ->
	#base_constellation_enchantment{equip_type = 2,pos = 1,lv = 5,cost = [{0,38040073,6}],attr = [{1,600},{3,360}]};

get_enchantment_cfg(2,1,6) ->
	#base_constellation_enchantment{equip_type = 2,pos = 1,lv = 6,cost = [{0,38040073,7}],attr = [{1,720},{3,432}]};

get_enchantment_cfg(2,1,7) ->
	#base_constellation_enchantment{equip_type = 2,pos = 1,lv = 7,cost = [{0,38040073,8}],attr = [{1,840},{3,504}]};

get_enchantment_cfg(2,1,8) ->
	#base_constellation_enchantment{equip_type = 2,pos = 1,lv = 8,cost = [{0,38040073,9}],attr = [{1,960},{3,576}]};

get_enchantment_cfg(2,1,9) ->
	#base_constellation_enchantment{equip_type = 2,pos = 1,lv = 9,cost = [{0,38040073,10}],attr = [{1,1080},{3,648}]};

get_enchantment_cfg(2,1,10) ->
	#base_constellation_enchantment{equip_type = 2,pos = 1,lv = 10,cost = [{0,38040073,11}],attr = [{1,1200},{3,720}]};

get_enchantment_cfg(2,1,11) ->
	#base_constellation_enchantment{equip_type = 2,pos = 1,lv = 11,cost = [{0,38040073,12}],attr = [{1,1320},{3,792}]};

get_enchantment_cfg(2,1,12) ->
	#base_constellation_enchantment{equip_type = 2,pos = 1,lv = 12,cost = [{0,38040073,13}],attr = [{1,1440},{3,864}]};

get_enchantment_cfg(2,1,13) ->
	#base_constellation_enchantment{equip_type = 2,pos = 1,lv = 13,cost = [{0,38040073,14}],attr = [{1,1560},{3,936}]};

get_enchantment_cfg(2,1,14) ->
	#base_constellation_enchantment{equip_type = 2,pos = 1,lv = 14,cost = [{0,38040073,15}],attr = [{1,1680},{3,1008}]};

get_enchantment_cfg(2,1,15) ->
	#base_constellation_enchantment{equip_type = 2,pos = 1,lv = 15,cost = [{0,38040073,16}],attr = [{1,1800},{3,1080}]};

get_enchantment_cfg(2,1,16) ->
	#base_constellation_enchantment{equip_type = 2,pos = 1,lv = 16,cost = [{0,38040073,17}],attr = [{1,1920},{3,1152}]};

get_enchantment_cfg(2,1,17) ->
	#base_constellation_enchantment{equip_type = 2,pos = 1,lv = 17,cost = [{0,38040073,18}],attr = [{1,2040},{3,1224}]};

get_enchantment_cfg(2,1,18) ->
	#base_constellation_enchantment{equip_type = 2,pos = 1,lv = 18,cost = [{0,38040073,19}],attr = [{1,2160},{3,1296}]};

get_enchantment_cfg(2,1,19) ->
	#base_constellation_enchantment{equip_type = 2,pos = 1,lv = 19,cost = [{0,38040073,20}],attr = [{1,2280},{3,1368}]};

get_enchantment_cfg(2,1,20) ->
	#base_constellation_enchantment{equip_type = 2,pos = 1,lv = 20,cost = [{0,38040073,21}],attr = [{1,2400},{3,1440}]};

get_enchantment_cfg(2,1,21) ->
	#base_constellation_enchantment{equip_type = 2,pos = 1,lv = 21,cost = [{0,38040073,22}],attr = [{1,2520},{3,1512}]};

get_enchantment_cfg(2,1,22) ->
	#base_constellation_enchantment{equip_type = 2,pos = 1,lv = 22,cost = [{0,38040073,23}],attr = [{1,2640},{3,1584}]};

get_enchantment_cfg(2,1,23) ->
	#base_constellation_enchantment{equip_type = 2,pos = 1,lv = 23,cost = [{0,38040073,24}],attr = [{1,2760},{3,1656}]};

get_enchantment_cfg(2,1,24) ->
	#base_constellation_enchantment{equip_type = 2,pos = 1,lv = 24,cost = [{0,38040073,25}],attr = [{1,2880},{3,1728}]};

get_enchantment_cfg(2,1,25) ->
	#base_constellation_enchantment{equip_type = 2,pos = 1,lv = 25,cost = [{0,38040073,26}],attr = [{1,3000},{3,1800}]};

get_enchantment_cfg(2,1,26) ->
	#base_constellation_enchantment{equip_type = 2,pos = 1,lv = 26,cost = [{0,38040073,27}],attr = [{1,3120},{3,1872}]};

get_enchantment_cfg(2,1,27) ->
	#base_constellation_enchantment{equip_type = 2,pos = 1,lv = 27,cost = [{0,38040073,28}],attr = [{1,3240},{3,1944}]};

get_enchantment_cfg(2,1,28) ->
	#base_constellation_enchantment{equip_type = 2,pos = 1,lv = 28,cost = [{0,38040073,29}],attr = [{1,3360},{3,2016}]};

get_enchantment_cfg(2,1,29) ->
	#base_constellation_enchantment{equip_type = 2,pos = 1,lv = 29,cost = [{0,38040073,30}],attr = [{1,3480},{3,2088}]};

get_enchantment_cfg(2,1,30) ->
	#base_constellation_enchantment{equip_type = 2,pos = 1,lv = 30,cost = [],attr = [{1,3600},{3,2160}]};

get_enchantment_cfg(2,2,0) ->
	#base_constellation_enchantment{equip_type = 2,pos = 2,lv = 0,cost = [{0,38040073,1}],attr = [{2,0},{4,0}]};

get_enchantment_cfg(2,2,1) ->
	#base_constellation_enchantment{equip_type = 2,pos = 2,lv = 1,cost = [{0,38040073,2}],attr = [{2,2400},{4,72}]};

get_enchantment_cfg(2,2,2) ->
	#base_constellation_enchantment{equip_type = 2,pos = 2,lv = 2,cost = [{0,38040073,3}],attr = [{2,4800},{4,144}]};

get_enchantment_cfg(2,2,3) ->
	#base_constellation_enchantment{equip_type = 2,pos = 2,lv = 3,cost = [{0,38040073,4}],attr = [{2,7200},{4,216}]};

get_enchantment_cfg(2,2,4) ->
	#base_constellation_enchantment{equip_type = 2,pos = 2,lv = 4,cost = [{0,38040073,5}],attr = [{2,9600},{4,288}]};

get_enchantment_cfg(2,2,5) ->
	#base_constellation_enchantment{equip_type = 2,pos = 2,lv = 5,cost = [{0,38040073,6}],attr = [{2,12000},{4,360}]};

get_enchantment_cfg(2,2,6) ->
	#base_constellation_enchantment{equip_type = 2,pos = 2,lv = 6,cost = [{0,38040073,7}],attr = [{2,14400},{4,432}]};

get_enchantment_cfg(2,2,7) ->
	#base_constellation_enchantment{equip_type = 2,pos = 2,lv = 7,cost = [{0,38040073,8}],attr = [{2,16800},{4,504}]};

get_enchantment_cfg(2,2,8) ->
	#base_constellation_enchantment{equip_type = 2,pos = 2,lv = 8,cost = [{0,38040073,9}],attr = [{2,19200},{4,576}]};

get_enchantment_cfg(2,2,9) ->
	#base_constellation_enchantment{equip_type = 2,pos = 2,lv = 9,cost = [{0,38040073,10}],attr = [{2,21600},{4,648}]};

get_enchantment_cfg(2,2,10) ->
	#base_constellation_enchantment{equip_type = 2,pos = 2,lv = 10,cost = [{0,38040073,11}],attr = [{2,24000},{4,720}]};

get_enchantment_cfg(2,2,11) ->
	#base_constellation_enchantment{equip_type = 2,pos = 2,lv = 11,cost = [{0,38040073,12}],attr = [{2,26400},{4,792}]};

get_enchantment_cfg(2,2,12) ->
	#base_constellation_enchantment{equip_type = 2,pos = 2,lv = 12,cost = [{0,38040073,13}],attr = [{2,28800},{4,864}]};

get_enchantment_cfg(2,2,13) ->
	#base_constellation_enchantment{equip_type = 2,pos = 2,lv = 13,cost = [{0,38040073,14}],attr = [{2,31200},{4,936}]};

get_enchantment_cfg(2,2,14) ->
	#base_constellation_enchantment{equip_type = 2,pos = 2,lv = 14,cost = [{0,38040073,15}],attr = [{2,33600},{4,1008}]};

get_enchantment_cfg(2,2,15) ->
	#base_constellation_enchantment{equip_type = 2,pos = 2,lv = 15,cost = [{0,38040073,16}],attr = [{2,36000},{4,1080}]};

get_enchantment_cfg(2,2,16) ->
	#base_constellation_enchantment{equip_type = 2,pos = 2,lv = 16,cost = [{0,38040073,17}],attr = [{2,38400},{4,1152}]};

get_enchantment_cfg(2,2,17) ->
	#base_constellation_enchantment{equip_type = 2,pos = 2,lv = 17,cost = [{0,38040073,18}],attr = [{2,40800},{4,1224}]};

get_enchantment_cfg(2,2,18) ->
	#base_constellation_enchantment{equip_type = 2,pos = 2,lv = 18,cost = [{0,38040073,19}],attr = [{2,43200},{4,1296}]};

get_enchantment_cfg(2,2,19) ->
	#base_constellation_enchantment{equip_type = 2,pos = 2,lv = 19,cost = [{0,38040073,20}],attr = [{2,45600},{4,1368}]};

get_enchantment_cfg(2,2,20) ->
	#base_constellation_enchantment{equip_type = 2,pos = 2,lv = 20,cost = [{0,38040073,21}],attr = [{2,48000},{4,1440}]};

get_enchantment_cfg(2,2,21) ->
	#base_constellation_enchantment{equip_type = 2,pos = 2,lv = 21,cost = [{0,38040073,22}],attr = [{2,50400},{4,1512}]};

get_enchantment_cfg(2,2,22) ->
	#base_constellation_enchantment{equip_type = 2,pos = 2,lv = 22,cost = [{0,38040073,23}],attr = [{2,52800},{4,1584}]};

get_enchantment_cfg(2,2,23) ->
	#base_constellation_enchantment{equip_type = 2,pos = 2,lv = 23,cost = [{0,38040073,24}],attr = [{2,55200},{4,1656}]};

get_enchantment_cfg(2,2,24) ->
	#base_constellation_enchantment{equip_type = 2,pos = 2,lv = 24,cost = [{0,38040073,25}],attr = [{2,57600},{4,1728}]};

get_enchantment_cfg(2,2,25) ->
	#base_constellation_enchantment{equip_type = 2,pos = 2,lv = 25,cost = [{0,38040073,26}],attr = [{2,60000},{4,1800}]};

get_enchantment_cfg(2,2,26) ->
	#base_constellation_enchantment{equip_type = 2,pos = 2,lv = 26,cost = [{0,38040073,27}],attr = [{2,62400},{4,1872}]};

get_enchantment_cfg(2,2,27) ->
	#base_constellation_enchantment{equip_type = 2,pos = 2,lv = 27,cost = [{0,38040073,28}],attr = [{2,64800},{4,1944}]};

get_enchantment_cfg(2,2,28) ->
	#base_constellation_enchantment{equip_type = 2,pos = 2,lv = 28,cost = [{0,38040073,29}],attr = [{2,67200},{4,2016}]};

get_enchantment_cfg(2,2,29) ->
	#base_constellation_enchantment{equip_type = 2,pos = 2,lv = 29,cost = [{0,38040073,30}],attr = [{2,69600},{4,2088}]};

get_enchantment_cfg(2,2,30) ->
	#base_constellation_enchantment{equip_type = 2,pos = 2,lv = 30,cost = [],attr = [{2,72000},{4,2160}]};

get_enchantment_cfg(2,3,0) ->
	#base_constellation_enchantment{equip_type = 2,pos = 3,lv = 0,cost = [{0,38040073,1}],attr = [{2,0},{4,0}]};

get_enchantment_cfg(2,3,1) ->
	#base_constellation_enchantment{equip_type = 2,pos = 3,lv = 1,cost = [{0,38040073,2}],attr = [{2,2400},{4,72}]};

get_enchantment_cfg(2,3,2) ->
	#base_constellation_enchantment{equip_type = 2,pos = 3,lv = 2,cost = [{0,38040073,3}],attr = [{2,4800},{4,144}]};

get_enchantment_cfg(2,3,3) ->
	#base_constellation_enchantment{equip_type = 2,pos = 3,lv = 3,cost = [{0,38040073,4}],attr = [{2,7200},{4,216}]};

get_enchantment_cfg(2,3,4) ->
	#base_constellation_enchantment{equip_type = 2,pos = 3,lv = 4,cost = [{0,38040073,5}],attr = [{2,9600},{4,288}]};

get_enchantment_cfg(2,3,5) ->
	#base_constellation_enchantment{equip_type = 2,pos = 3,lv = 5,cost = [{0,38040073,6}],attr = [{2,12000},{4,360}]};

get_enchantment_cfg(2,3,6) ->
	#base_constellation_enchantment{equip_type = 2,pos = 3,lv = 6,cost = [{0,38040073,7}],attr = [{2,14400},{4,432}]};

get_enchantment_cfg(2,3,7) ->
	#base_constellation_enchantment{equip_type = 2,pos = 3,lv = 7,cost = [{0,38040073,8}],attr = [{2,16800},{4,504}]};

get_enchantment_cfg(2,3,8) ->
	#base_constellation_enchantment{equip_type = 2,pos = 3,lv = 8,cost = [{0,38040073,9}],attr = [{2,19200},{4,576}]};

get_enchantment_cfg(2,3,9) ->
	#base_constellation_enchantment{equip_type = 2,pos = 3,lv = 9,cost = [{0,38040073,10}],attr = [{2,21600},{4,648}]};

get_enchantment_cfg(2,3,10) ->
	#base_constellation_enchantment{equip_type = 2,pos = 3,lv = 10,cost = [{0,38040073,11}],attr = [{2,24000},{4,720}]};

get_enchantment_cfg(2,3,11) ->
	#base_constellation_enchantment{equip_type = 2,pos = 3,lv = 11,cost = [{0,38040073,12}],attr = [{2,26400},{4,792}]};

get_enchantment_cfg(2,3,12) ->
	#base_constellation_enchantment{equip_type = 2,pos = 3,lv = 12,cost = [{0,38040073,13}],attr = [{2,28800},{4,864}]};

get_enchantment_cfg(2,3,13) ->
	#base_constellation_enchantment{equip_type = 2,pos = 3,lv = 13,cost = [{0,38040073,14}],attr = [{2,31200},{4,936}]};

get_enchantment_cfg(2,3,14) ->
	#base_constellation_enchantment{equip_type = 2,pos = 3,lv = 14,cost = [{0,38040073,15}],attr = [{2,33600},{4,1008}]};

get_enchantment_cfg(2,3,15) ->
	#base_constellation_enchantment{equip_type = 2,pos = 3,lv = 15,cost = [{0,38040073,16}],attr = [{2,36000},{4,1080}]};

get_enchantment_cfg(2,3,16) ->
	#base_constellation_enchantment{equip_type = 2,pos = 3,lv = 16,cost = [{0,38040073,17}],attr = [{2,38400},{4,1152}]};

get_enchantment_cfg(2,3,17) ->
	#base_constellation_enchantment{equip_type = 2,pos = 3,lv = 17,cost = [{0,38040073,18}],attr = [{2,40800},{4,1224}]};

get_enchantment_cfg(2,3,18) ->
	#base_constellation_enchantment{equip_type = 2,pos = 3,lv = 18,cost = [{0,38040073,19}],attr = [{2,43200},{4,1296}]};

get_enchantment_cfg(2,3,19) ->
	#base_constellation_enchantment{equip_type = 2,pos = 3,lv = 19,cost = [{0,38040073,20}],attr = [{2,45600},{4,1368}]};

get_enchantment_cfg(2,3,20) ->
	#base_constellation_enchantment{equip_type = 2,pos = 3,lv = 20,cost = [{0,38040073,21}],attr = [{2,48000},{4,1440}]};

get_enchantment_cfg(2,3,21) ->
	#base_constellation_enchantment{equip_type = 2,pos = 3,lv = 21,cost = [{0,38040073,22}],attr = [{2,50400},{4,1512}]};

get_enchantment_cfg(2,3,22) ->
	#base_constellation_enchantment{equip_type = 2,pos = 3,lv = 22,cost = [{0,38040073,23}],attr = [{2,52800},{4,1584}]};

get_enchantment_cfg(2,3,23) ->
	#base_constellation_enchantment{equip_type = 2,pos = 3,lv = 23,cost = [{0,38040073,24}],attr = [{2,55200},{4,1656}]};

get_enchantment_cfg(2,3,24) ->
	#base_constellation_enchantment{equip_type = 2,pos = 3,lv = 24,cost = [{0,38040073,25}],attr = [{2,57600},{4,1728}]};

get_enchantment_cfg(2,3,25) ->
	#base_constellation_enchantment{equip_type = 2,pos = 3,lv = 25,cost = [{0,38040073,26}],attr = [{2,60000},{4,1800}]};

get_enchantment_cfg(2,3,26) ->
	#base_constellation_enchantment{equip_type = 2,pos = 3,lv = 26,cost = [{0,38040073,27}],attr = [{2,62400},{4,1872}]};

get_enchantment_cfg(2,3,27) ->
	#base_constellation_enchantment{equip_type = 2,pos = 3,lv = 27,cost = [{0,38040073,28}],attr = [{2,64800},{4,1944}]};

get_enchantment_cfg(2,3,28) ->
	#base_constellation_enchantment{equip_type = 2,pos = 3,lv = 28,cost = [{0,38040073,29}],attr = [{2,67200},{4,2016}]};

get_enchantment_cfg(2,3,29) ->
	#base_constellation_enchantment{equip_type = 2,pos = 3,lv = 29,cost = [{0,38040073,30}],attr = [{2,69600},{4,2088}]};

get_enchantment_cfg(2,3,30) ->
	#base_constellation_enchantment{equip_type = 2,pos = 3,lv = 30,cost = [],attr = [{2,72000},{4,2160}]};

get_enchantment_cfg(2,4,0) ->
	#base_constellation_enchantment{equip_type = 2,pos = 4,lv = 0,cost = [{0,38040073,1}],attr = [{2,0},{4,0}]};

get_enchantment_cfg(2,4,1) ->
	#base_constellation_enchantment{equip_type = 2,pos = 4,lv = 1,cost = [{0,38040073,2}],attr = [{2,2400},{4,72}]};

get_enchantment_cfg(2,4,2) ->
	#base_constellation_enchantment{equip_type = 2,pos = 4,lv = 2,cost = [{0,38040073,3}],attr = [{2,4800},{4,144}]};

get_enchantment_cfg(2,4,3) ->
	#base_constellation_enchantment{equip_type = 2,pos = 4,lv = 3,cost = [{0,38040073,4}],attr = [{2,7200},{4,216}]};

get_enchantment_cfg(2,4,4) ->
	#base_constellation_enchantment{equip_type = 2,pos = 4,lv = 4,cost = [{0,38040073,5}],attr = [{2,9600},{4,288}]};

get_enchantment_cfg(2,4,5) ->
	#base_constellation_enchantment{equip_type = 2,pos = 4,lv = 5,cost = [{0,38040073,6}],attr = [{2,12000},{4,360}]};

get_enchantment_cfg(2,4,6) ->
	#base_constellation_enchantment{equip_type = 2,pos = 4,lv = 6,cost = [{0,38040073,7}],attr = [{2,14400},{4,432}]};

get_enchantment_cfg(2,4,7) ->
	#base_constellation_enchantment{equip_type = 2,pos = 4,lv = 7,cost = [{0,38040073,8}],attr = [{2,16800},{4,504}]};

get_enchantment_cfg(2,4,8) ->
	#base_constellation_enchantment{equip_type = 2,pos = 4,lv = 8,cost = [{0,38040073,9}],attr = [{2,19200},{4,576}]};

get_enchantment_cfg(2,4,9) ->
	#base_constellation_enchantment{equip_type = 2,pos = 4,lv = 9,cost = [{0,38040073,10}],attr = [{2,21600},{4,648}]};

get_enchantment_cfg(2,4,10) ->
	#base_constellation_enchantment{equip_type = 2,pos = 4,lv = 10,cost = [{0,38040073,11}],attr = [{2,24000},{4,720}]};

get_enchantment_cfg(2,4,11) ->
	#base_constellation_enchantment{equip_type = 2,pos = 4,lv = 11,cost = [{0,38040073,12}],attr = [{2,26400},{4,792}]};

get_enchantment_cfg(2,4,12) ->
	#base_constellation_enchantment{equip_type = 2,pos = 4,lv = 12,cost = [{0,38040073,13}],attr = [{2,28800},{4,864}]};

get_enchantment_cfg(2,4,13) ->
	#base_constellation_enchantment{equip_type = 2,pos = 4,lv = 13,cost = [{0,38040073,14}],attr = [{2,31200},{4,936}]};

get_enchantment_cfg(2,4,14) ->
	#base_constellation_enchantment{equip_type = 2,pos = 4,lv = 14,cost = [{0,38040073,15}],attr = [{2,33600},{4,1008}]};

get_enchantment_cfg(2,4,15) ->
	#base_constellation_enchantment{equip_type = 2,pos = 4,lv = 15,cost = [{0,38040073,16}],attr = [{2,36000},{4,1080}]};

get_enchantment_cfg(2,4,16) ->
	#base_constellation_enchantment{equip_type = 2,pos = 4,lv = 16,cost = [{0,38040073,17}],attr = [{2,38400},{4,1152}]};

get_enchantment_cfg(2,4,17) ->
	#base_constellation_enchantment{equip_type = 2,pos = 4,lv = 17,cost = [{0,38040073,18}],attr = [{2,40800},{4,1224}]};

get_enchantment_cfg(2,4,18) ->
	#base_constellation_enchantment{equip_type = 2,pos = 4,lv = 18,cost = [{0,38040073,19}],attr = [{2,43200},{4,1296}]};

get_enchantment_cfg(2,4,19) ->
	#base_constellation_enchantment{equip_type = 2,pos = 4,lv = 19,cost = [{0,38040073,20}],attr = [{2,45600},{4,1368}]};

get_enchantment_cfg(2,4,20) ->
	#base_constellation_enchantment{equip_type = 2,pos = 4,lv = 20,cost = [{0,38040073,21}],attr = [{2,48000},{4,1440}]};

get_enchantment_cfg(2,4,21) ->
	#base_constellation_enchantment{equip_type = 2,pos = 4,lv = 21,cost = [{0,38040073,22}],attr = [{2,50400},{4,1512}]};

get_enchantment_cfg(2,4,22) ->
	#base_constellation_enchantment{equip_type = 2,pos = 4,lv = 22,cost = [{0,38040073,23}],attr = [{2,52800},{4,1584}]};

get_enchantment_cfg(2,4,23) ->
	#base_constellation_enchantment{equip_type = 2,pos = 4,lv = 23,cost = [{0,38040073,24}],attr = [{2,55200},{4,1656}]};

get_enchantment_cfg(2,4,24) ->
	#base_constellation_enchantment{equip_type = 2,pos = 4,lv = 24,cost = [{0,38040073,25}],attr = [{2,57600},{4,1728}]};

get_enchantment_cfg(2,4,25) ->
	#base_constellation_enchantment{equip_type = 2,pos = 4,lv = 25,cost = [{0,38040073,26}],attr = [{2,60000},{4,1800}]};

get_enchantment_cfg(2,4,26) ->
	#base_constellation_enchantment{equip_type = 2,pos = 4,lv = 26,cost = [{0,38040073,27}],attr = [{2,62400},{4,1872}]};

get_enchantment_cfg(2,4,27) ->
	#base_constellation_enchantment{equip_type = 2,pos = 4,lv = 27,cost = [{0,38040073,28}],attr = [{2,64800},{4,1944}]};

get_enchantment_cfg(2,4,28) ->
	#base_constellation_enchantment{equip_type = 2,pos = 4,lv = 28,cost = [{0,38040073,29}],attr = [{2,67200},{4,2016}]};

get_enchantment_cfg(2,4,29) ->
	#base_constellation_enchantment{equip_type = 2,pos = 4,lv = 29,cost = [{0,38040073,30}],attr = [{2,69600},{4,2088}]};

get_enchantment_cfg(2,4,30) ->
	#base_constellation_enchantment{equip_type = 2,pos = 4,lv = 30,cost = [],attr = [{2,72000},{4,2160}]};

get_enchantment_cfg(2,5,0) ->
	#base_constellation_enchantment{equip_type = 2,pos = 5,lv = 0,cost = [{0,38040073,1}],attr = [{1,0},{3,0}]};

get_enchantment_cfg(2,5,1) ->
	#base_constellation_enchantment{equip_type = 2,pos = 5,lv = 1,cost = [{0,38040073,2}],attr = [{1,120},{3,72}]};

get_enchantment_cfg(2,5,2) ->
	#base_constellation_enchantment{equip_type = 2,pos = 5,lv = 2,cost = [{0,38040073,3}],attr = [{1,240},{3,144}]};

get_enchantment_cfg(2,5,3) ->
	#base_constellation_enchantment{equip_type = 2,pos = 5,lv = 3,cost = [{0,38040073,4}],attr = [{1,360},{3,216}]};

get_enchantment_cfg(2,5,4) ->
	#base_constellation_enchantment{equip_type = 2,pos = 5,lv = 4,cost = [{0,38040073,5}],attr = [{1,480},{3,288}]};

get_enchantment_cfg(2,5,5) ->
	#base_constellation_enchantment{equip_type = 2,pos = 5,lv = 5,cost = [{0,38040073,6}],attr = [{1,600},{3,360}]};

get_enchantment_cfg(2,5,6) ->
	#base_constellation_enchantment{equip_type = 2,pos = 5,lv = 6,cost = [{0,38040073,7}],attr = [{1,720},{3,432}]};

get_enchantment_cfg(2,5,7) ->
	#base_constellation_enchantment{equip_type = 2,pos = 5,lv = 7,cost = [{0,38040073,8}],attr = [{1,840},{3,504}]};

get_enchantment_cfg(2,5,8) ->
	#base_constellation_enchantment{equip_type = 2,pos = 5,lv = 8,cost = [{0,38040073,9}],attr = [{1,960},{3,576}]};

get_enchantment_cfg(2,5,9) ->
	#base_constellation_enchantment{equip_type = 2,pos = 5,lv = 9,cost = [{0,38040073,10}],attr = [{1,1080},{3,648}]};

get_enchantment_cfg(2,5,10) ->
	#base_constellation_enchantment{equip_type = 2,pos = 5,lv = 10,cost = [{0,38040073,11}],attr = [{1,1200},{3,720}]};

get_enchantment_cfg(2,5,11) ->
	#base_constellation_enchantment{equip_type = 2,pos = 5,lv = 11,cost = [{0,38040073,12}],attr = [{1,1320},{3,792}]};

get_enchantment_cfg(2,5,12) ->
	#base_constellation_enchantment{equip_type = 2,pos = 5,lv = 12,cost = [{0,38040073,13}],attr = [{1,1440},{3,864}]};

get_enchantment_cfg(2,5,13) ->
	#base_constellation_enchantment{equip_type = 2,pos = 5,lv = 13,cost = [{0,38040073,14}],attr = [{1,1560},{3,936}]};

get_enchantment_cfg(2,5,14) ->
	#base_constellation_enchantment{equip_type = 2,pos = 5,lv = 14,cost = [{0,38040073,15}],attr = [{1,1680},{3,1008}]};

get_enchantment_cfg(2,5,15) ->
	#base_constellation_enchantment{equip_type = 2,pos = 5,lv = 15,cost = [{0,38040073,16}],attr = [{1,1800},{3,1080}]};

get_enchantment_cfg(2,5,16) ->
	#base_constellation_enchantment{equip_type = 2,pos = 5,lv = 16,cost = [{0,38040073,17}],attr = [{1,1920},{3,1152}]};

get_enchantment_cfg(2,5,17) ->
	#base_constellation_enchantment{equip_type = 2,pos = 5,lv = 17,cost = [{0,38040073,18}],attr = [{1,2040},{3,1224}]};

get_enchantment_cfg(2,5,18) ->
	#base_constellation_enchantment{equip_type = 2,pos = 5,lv = 18,cost = [{0,38040073,19}],attr = [{1,2160},{3,1296}]};

get_enchantment_cfg(2,5,19) ->
	#base_constellation_enchantment{equip_type = 2,pos = 5,lv = 19,cost = [{0,38040073,20}],attr = [{1,2280},{3,1368}]};

get_enchantment_cfg(2,5,20) ->
	#base_constellation_enchantment{equip_type = 2,pos = 5,lv = 20,cost = [{0,38040073,21}],attr = [{1,2400},{3,1440}]};

get_enchantment_cfg(2,5,21) ->
	#base_constellation_enchantment{equip_type = 2,pos = 5,lv = 21,cost = [{0,38040073,22}],attr = [{1,2520},{3,1512}]};

get_enchantment_cfg(2,5,22) ->
	#base_constellation_enchantment{equip_type = 2,pos = 5,lv = 22,cost = [{0,38040073,23}],attr = [{1,2640},{3,1584}]};

get_enchantment_cfg(2,5,23) ->
	#base_constellation_enchantment{equip_type = 2,pos = 5,lv = 23,cost = [{0,38040073,24}],attr = [{1,2760},{3,1656}]};

get_enchantment_cfg(2,5,24) ->
	#base_constellation_enchantment{equip_type = 2,pos = 5,lv = 24,cost = [{0,38040073,25}],attr = [{1,2880},{3,1728}]};

get_enchantment_cfg(2,5,25) ->
	#base_constellation_enchantment{equip_type = 2,pos = 5,lv = 25,cost = [{0,38040073,26}],attr = [{1,3000},{3,1800}]};

get_enchantment_cfg(2,5,26) ->
	#base_constellation_enchantment{equip_type = 2,pos = 5,lv = 26,cost = [{0,38040073,27}],attr = [{1,3120},{3,1872}]};

get_enchantment_cfg(2,5,27) ->
	#base_constellation_enchantment{equip_type = 2,pos = 5,lv = 27,cost = [{0,38040073,28}],attr = [{1,3240},{3,1944}]};

get_enchantment_cfg(2,5,28) ->
	#base_constellation_enchantment{equip_type = 2,pos = 5,lv = 28,cost = [{0,38040073,29}],attr = [{1,3360},{3,2016}]};

get_enchantment_cfg(2,5,29) ->
	#base_constellation_enchantment{equip_type = 2,pos = 5,lv = 29,cost = [{0,38040073,30}],attr = [{1,3480},{3,2088}]};

get_enchantment_cfg(2,5,30) ->
	#base_constellation_enchantment{equip_type = 2,pos = 5,lv = 30,cost = [],attr = [{1,3600},{3,2160}]};

get_enchantment_cfg(2,6,0) ->
	#base_constellation_enchantment{equip_type = 2,pos = 6,lv = 0,cost = [{0,38040073,1}],attr = [{2,0},{4,0}]};

get_enchantment_cfg(2,6,1) ->
	#base_constellation_enchantment{equip_type = 2,pos = 6,lv = 1,cost = [{0,38040073,2}],attr = [{2,2400},{4,72}]};

get_enchantment_cfg(2,6,2) ->
	#base_constellation_enchantment{equip_type = 2,pos = 6,lv = 2,cost = [{0,38040073,3}],attr = [{2,4800},{4,144}]};

get_enchantment_cfg(2,6,3) ->
	#base_constellation_enchantment{equip_type = 2,pos = 6,lv = 3,cost = [{0,38040073,4}],attr = [{2,7200},{4,216}]};

get_enchantment_cfg(2,6,4) ->
	#base_constellation_enchantment{equip_type = 2,pos = 6,lv = 4,cost = [{0,38040073,5}],attr = [{2,9600},{4,288}]};

get_enchantment_cfg(2,6,5) ->
	#base_constellation_enchantment{equip_type = 2,pos = 6,lv = 5,cost = [{0,38040073,6}],attr = [{2,12000},{4,360}]};

get_enchantment_cfg(2,6,6) ->
	#base_constellation_enchantment{equip_type = 2,pos = 6,lv = 6,cost = [{0,38040073,7}],attr = [{2,14400},{4,432}]};

get_enchantment_cfg(2,6,7) ->
	#base_constellation_enchantment{equip_type = 2,pos = 6,lv = 7,cost = [{0,38040073,8}],attr = [{2,16800},{4,504}]};

get_enchantment_cfg(2,6,8) ->
	#base_constellation_enchantment{equip_type = 2,pos = 6,lv = 8,cost = [{0,38040073,9}],attr = [{2,19200},{4,576}]};

get_enchantment_cfg(2,6,9) ->
	#base_constellation_enchantment{equip_type = 2,pos = 6,lv = 9,cost = [{0,38040073,10}],attr = [{2,21600},{4,648}]};

get_enchantment_cfg(2,6,10) ->
	#base_constellation_enchantment{equip_type = 2,pos = 6,lv = 10,cost = [{0,38040073,11}],attr = [{2,24000},{4,720}]};

get_enchantment_cfg(2,6,11) ->
	#base_constellation_enchantment{equip_type = 2,pos = 6,lv = 11,cost = [{0,38040073,12}],attr = [{2,26400},{4,792}]};

get_enchantment_cfg(2,6,12) ->
	#base_constellation_enchantment{equip_type = 2,pos = 6,lv = 12,cost = [{0,38040073,13}],attr = [{2,28800},{4,864}]};

get_enchantment_cfg(2,6,13) ->
	#base_constellation_enchantment{equip_type = 2,pos = 6,lv = 13,cost = [{0,38040073,14}],attr = [{2,31200},{4,936}]};

get_enchantment_cfg(2,6,14) ->
	#base_constellation_enchantment{equip_type = 2,pos = 6,lv = 14,cost = [{0,38040073,15}],attr = [{2,33600},{4,1008}]};

get_enchantment_cfg(2,6,15) ->
	#base_constellation_enchantment{equip_type = 2,pos = 6,lv = 15,cost = [{0,38040073,16}],attr = [{2,36000},{4,1080}]};

get_enchantment_cfg(2,6,16) ->
	#base_constellation_enchantment{equip_type = 2,pos = 6,lv = 16,cost = [{0,38040073,17}],attr = [{2,38400},{4,1152}]};

get_enchantment_cfg(2,6,17) ->
	#base_constellation_enchantment{equip_type = 2,pos = 6,lv = 17,cost = [{0,38040073,18}],attr = [{2,40800},{4,1224}]};

get_enchantment_cfg(2,6,18) ->
	#base_constellation_enchantment{equip_type = 2,pos = 6,lv = 18,cost = [{0,38040073,19}],attr = [{2,43200},{4,1296}]};

get_enchantment_cfg(2,6,19) ->
	#base_constellation_enchantment{equip_type = 2,pos = 6,lv = 19,cost = [{0,38040073,20}],attr = [{2,45600},{4,1368}]};

get_enchantment_cfg(2,6,20) ->
	#base_constellation_enchantment{equip_type = 2,pos = 6,lv = 20,cost = [{0,38040073,21}],attr = [{2,48000},{4,1440}]};

get_enchantment_cfg(2,6,21) ->
	#base_constellation_enchantment{equip_type = 2,pos = 6,lv = 21,cost = [{0,38040073,22}],attr = [{2,50400},{4,1512}]};

get_enchantment_cfg(2,6,22) ->
	#base_constellation_enchantment{equip_type = 2,pos = 6,lv = 22,cost = [{0,38040073,23}],attr = [{2,52800},{4,1584}]};

get_enchantment_cfg(2,6,23) ->
	#base_constellation_enchantment{equip_type = 2,pos = 6,lv = 23,cost = [{0,38040073,24}],attr = [{2,55200},{4,1656}]};

get_enchantment_cfg(2,6,24) ->
	#base_constellation_enchantment{equip_type = 2,pos = 6,lv = 24,cost = [{0,38040073,25}],attr = [{2,57600},{4,1728}]};

get_enchantment_cfg(2,6,25) ->
	#base_constellation_enchantment{equip_type = 2,pos = 6,lv = 25,cost = [{0,38040073,26}],attr = [{2,60000},{4,1800}]};

get_enchantment_cfg(2,6,26) ->
	#base_constellation_enchantment{equip_type = 2,pos = 6,lv = 26,cost = [{0,38040073,27}],attr = [{2,62400},{4,1872}]};

get_enchantment_cfg(2,6,27) ->
	#base_constellation_enchantment{equip_type = 2,pos = 6,lv = 27,cost = [{0,38040073,28}],attr = [{2,64800},{4,1944}]};

get_enchantment_cfg(2,6,28) ->
	#base_constellation_enchantment{equip_type = 2,pos = 6,lv = 28,cost = [{0,38040073,29}],attr = [{2,67200},{4,2016}]};

get_enchantment_cfg(2,6,29) ->
	#base_constellation_enchantment{equip_type = 2,pos = 6,lv = 29,cost = [{0,38040073,30}],attr = [{2,69600},{4,2088}]};

get_enchantment_cfg(2,6,30) ->
	#base_constellation_enchantment{equip_type = 2,pos = 6,lv = 30,cost = [],attr = [{2,72000},{4,2160}]};

get_enchantment_cfg(3,1,0) ->
	#base_constellation_enchantment{equip_type = 3,pos = 1,lv = 0,cost = [{0,38040073,1}],attr = [{1,0},{3,0}]};

get_enchantment_cfg(3,1,1) ->
	#base_constellation_enchantment{equip_type = 3,pos = 1,lv = 1,cost = [{0,38040073,2}],attr = [{1,160},{3,96}]};

get_enchantment_cfg(3,1,2) ->
	#base_constellation_enchantment{equip_type = 3,pos = 1,lv = 2,cost = [{0,38040073,3}],attr = [{1,320},{3,192}]};

get_enchantment_cfg(3,1,3) ->
	#base_constellation_enchantment{equip_type = 3,pos = 1,lv = 3,cost = [{0,38040073,4}],attr = [{1,480},{3,288}]};

get_enchantment_cfg(3,1,4) ->
	#base_constellation_enchantment{equip_type = 3,pos = 1,lv = 4,cost = [{0,38040073,5}],attr = [{1,640},{3,384}]};

get_enchantment_cfg(3,1,5) ->
	#base_constellation_enchantment{equip_type = 3,pos = 1,lv = 5,cost = [{0,38040073,6}],attr = [{1,800},{3,480}]};

get_enchantment_cfg(3,1,6) ->
	#base_constellation_enchantment{equip_type = 3,pos = 1,lv = 6,cost = [{0,38040073,7}],attr = [{1,960},{3,576}]};

get_enchantment_cfg(3,1,7) ->
	#base_constellation_enchantment{equip_type = 3,pos = 1,lv = 7,cost = [{0,38040073,8}],attr = [{1,1120},{3,672}]};

get_enchantment_cfg(3,1,8) ->
	#base_constellation_enchantment{equip_type = 3,pos = 1,lv = 8,cost = [{0,38040073,9}],attr = [{1,1280},{3,768}]};

get_enchantment_cfg(3,1,9) ->
	#base_constellation_enchantment{equip_type = 3,pos = 1,lv = 9,cost = [{0,38040073,10}],attr = [{1,1440},{3,864}]};

get_enchantment_cfg(3,1,10) ->
	#base_constellation_enchantment{equip_type = 3,pos = 1,lv = 10,cost = [{0,38040073,11}],attr = [{1,1600},{3,960}]};

get_enchantment_cfg(3,1,11) ->
	#base_constellation_enchantment{equip_type = 3,pos = 1,lv = 11,cost = [{0,38040073,12}],attr = [{1,1760},{3,1056}]};

get_enchantment_cfg(3,1,12) ->
	#base_constellation_enchantment{equip_type = 3,pos = 1,lv = 12,cost = [{0,38040073,13}],attr = [{1,1920},{3,1152}]};

get_enchantment_cfg(3,1,13) ->
	#base_constellation_enchantment{equip_type = 3,pos = 1,lv = 13,cost = [{0,38040073,14}],attr = [{1,2080},{3,1248}]};

get_enchantment_cfg(3,1,14) ->
	#base_constellation_enchantment{equip_type = 3,pos = 1,lv = 14,cost = [{0,38040073,15}],attr = [{1,2240},{3,1344}]};

get_enchantment_cfg(3,1,15) ->
	#base_constellation_enchantment{equip_type = 3,pos = 1,lv = 15,cost = [{0,38040073,16}],attr = [{1,2400},{3,1440}]};

get_enchantment_cfg(3,1,16) ->
	#base_constellation_enchantment{equip_type = 3,pos = 1,lv = 16,cost = [{0,38040073,17}],attr = [{1,2560},{3,1536}]};

get_enchantment_cfg(3,1,17) ->
	#base_constellation_enchantment{equip_type = 3,pos = 1,lv = 17,cost = [{0,38040073,18}],attr = [{1,2720},{3,1632}]};

get_enchantment_cfg(3,1,18) ->
	#base_constellation_enchantment{equip_type = 3,pos = 1,lv = 18,cost = [{0,38040073,19}],attr = [{1,2880},{3,1728}]};

get_enchantment_cfg(3,1,19) ->
	#base_constellation_enchantment{equip_type = 3,pos = 1,lv = 19,cost = [{0,38040073,20}],attr = [{1,3040},{3,1824}]};

get_enchantment_cfg(3,1,20) ->
	#base_constellation_enchantment{equip_type = 3,pos = 1,lv = 20,cost = [{0,38040073,21}],attr = [{1,3200},{3,1920}]};

get_enchantment_cfg(3,1,21) ->
	#base_constellation_enchantment{equip_type = 3,pos = 1,lv = 21,cost = [{0,38040073,22}],attr = [{1,3360},{3,2016}]};

get_enchantment_cfg(3,1,22) ->
	#base_constellation_enchantment{equip_type = 3,pos = 1,lv = 22,cost = [{0,38040073,23}],attr = [{1,3520},{3,2112}]};

get_enchantment_cfg(3,1,23) ->
	#base_constellation_enchantment{equip_type = 3,pos = 1,lv = 23,cost = [{0,38040073,24}],attr = [{1,3680},{3,2208}]};

get_enchantment_cfg(3,1,24) ->
	#base_constellation_enchantment{equip_type = 3,pos = 1,lv = 24,cost = [{0,38040073,25}],attr = [{1,3840},{3,2304}]};

get_enchantment_cfg(3,1,25) ->
	#base_constellation_enchantment{equip_type = 3,pos = 1,lv = 25,cost = [{0,38040073,26}],attr = [{1,4000},{3,2400}]};

get_enchantment_cfg(3,1,26) ->
	#base_constellation_enchantment{equip_type = 3,pos = 1,lv = 26,cost = [{0,38040073,27}],attr = [{1,4160},{3,2496}]};

get_enchantment_cfg(3,1,27) ->
	#base_constellation_enchantment{equip_type = 3,pos = 1,lv = 27,cost = [{0,38040073,28}],attr = [{1,4320},{3,2592}]};

get_enchantment_cfg(3,1,28) ->
	#base_constellation_enchantment{equip_type = 3,pos = 1,lv = 28,cost = [{0,38040073,29}],attr = [{1,4480},{3,2688}]};

get_enchantment_cfg(3,1,29) ->
	#base_constellation_enchantment{equip_type = 3,pos = 1,lv = 29,cost = [{0,38040073,30}],attr = [{1,4640},{3,2784}]};

get_enchantment_cfg(3,1,30) ->
	#base_constellation_enchantment{equip_type = 3,pos = 1,lv = 30,cost = [],attr = [{1,4800},{3,2880}]};

get_enchantment_cfg(3,2,0) ->
	#base_constellation_enchantment{equip_type = 3,pos = 2,lv = 0,cost = [{0,38040073,1}],attr = [{2,0},{4,0}]};

get_enchantment_cfg(3,2,1) ->
	#base_constellation_enchantment{equip_type = 3,pos = 2,lv = 1,cost = [{0,38040073,2}],attr = [{2,3200},{4,96}]};

get_enchantment_cfg(3,2,2) ->
	#base_constellation_enchantment{equip_type = 3,pos = 2,lv = 2,cost = [{0,38040073,3}],attr = [{2,6400},{4,192}]};

get_enchantment_cfg(3,2,3) ->
	#base_constellation_enchantment{equip_type = 3,pos = 2,lv = 3,cost = [{0,38040073,4}],attr = [{2,9600},{4,288}]};

get_enchantment_cfg(3,2,4) ->
	#base_constellation_enchantment{equip_type = 3,pos = 2,lv = 4,cost = [{0,38040073,5}],attr = [{2,12800},{4,384}]};

get_enchantment_cfg(3,2,5) ->
	#base_constellation_enchantment{equip_type = 3,pos = 2,lv = 5,cost = [{0,38040073,6}],attr = [{2,16000},{4,480}]};

get_enchantment_cfg(3,2,6) ->
	#base_constellation_enchantment{equip_type = 3,pos = 2,lv = 6,cost = [{0,38040073,7}],attr = [{2,19200},{4,576}]};

get_enchantment_cfg(3,2,7) ->
	#base_constellation_enchantment{equip_type = 3,pos = 2,lv = 7,cost = [{0,38040073,8}],attr = [{2,22400},{4,672}]};

get_enchantment_cfg(3,2,8) ->
	#base_constellation_enchantment{equip_type = 3,pos = 2,lv = 8,cost = [{0,38040073,9}],attr = [{2,25600},{4,768}]};

get_enchantment_cfg(3,2,9) ->
	#base_constellation_enchantment{equip_type = 3,pos = 2,lv = 9,cost = [{0,38040073,10}],attr = [{2,28800},{4,864}]};

get_enchantment_cfg(3,2,10) ->
	#base_constellation_enchantment{equip_type = 3,pos = 2,lv = 10,cost = [{0,38040073,11}],attr = [{2,32000},{4,960}]};

get_enchantment_cfg(3,2,11) ->
	#base_constellation_enchantment{equip_type = 3,pos = 2,lv = 11,cost = [{0,38040073,12}],attr = [{2,35200},{4,1056}]};

get_enchantment_cfg(3,2,12) ->
	#base_constellation_enchantment{equip_type = 3,pos = 2,lv = 12,cost = [{0,38040073,13}],attr = [{2,38400},{4,1152}]};

get_enchantment_cfg(3,2,13) ->
	#base_constellation_enchantment{equip_type = 3,pos = 2,lv = 13,cost = [{0,38040073,14}],attr = [{2,41600},{4,1248}]};

get_enchantment_cfg(3,2,14) ->
	#base_constellation_enchantment{equip_type = 3,pos = 2,lv = 14,cost = [{0,38040073,15}],attr = [{2,44800},{4,1344}]};

get_enchantment_cfg(3,2,15) ->
	#base_constellation_enchantment{equip_type = 3,pos = 2,lv = 15,cost = [{0,38040073,16}],attr = [{2,48000},{4,1440}]};

get_enchantment_cfg(3,2,16) ->
	#base_constellation_enchantment{equip_type = 3,pos = 2,lv = 16,cost = [{0,38040073,17}],attr = [{2,51200},{4,1536}]};

get_enchantment_cfg(3,2,17) ->
	#base_constellation_enchantment{equip_type = 3,pos = 2,lv = 17,cost = [{0,38040073,18}],attr = [{2,54400},{4,1632}]};

get_enchantment_cfg(3,2,18) ->
	#base_constellation_enchantment{equip_type = 3,pos = 2,lv = 18,cost = [{0,38040073,19}],attr = [{2,57600},{4,1728}]};

get_enchantment_cfg(3,2,19) ->
	#base_constellation_enchantment{equip_type = 3,pos = 2,lv = 19,cost = [{0,38040073,20}],attr = [{2,60800},{4,1824}]};

get_enchantment_cfg(3,2,20) ->
	#base_constellation_enchantment{equip_type = 3,pos = 2,lv = 20,cost = [{0,38040073,21}],attr = [{2,64000},{4,1920}]};

get_enchantment_cfg(3,2,21) ->
	#base_constellation_enchantment{equip_type = 3,pos = 2,lv = 21,cost = [{0,38040073,22}],attr = [{2,67200},{4,2016}]};

get_enchantment_cfg(3,2,22) ->
	#base_constellation_enchantment{equip_type = 3,pos = 2,lv = 22,cost = [{0,38040073,23}],attr = [{2,70400},{4,2112}]};

get_enchantment_cfg(3,2,23) ->
	#base_constellation_enchantment{equip_type = 3,pos = 2,lv = 23,cost = [{0,38040073,24}],attr = [{2,73600},{4,2208}]};

get_enchantment_cfg(3,2,24) ->
	#base_constellation_enchantment{equip_type = 3,pos = 2,lv = 24,cost = [{0,38040073,25}],attr = [{2,76800},{4,2304}]};

get_enchantment_cfg(3,2,25) ->
	#base_constellation_enchantment{equip_type = 3,pos = 2,lv = 25,cost = [{0,38040073,26}],attr = [{2,80000},{4,2400}]};

get_enchantment_cfg(3,2,26) ->
	#base_constellation_enchantment{equip_type = 3,pos = 2,lv = 26,cost = [{0,38040073,27}],attr = [{2,83200},{4,2496}]};

get_enchantment_cfg(3,2,27) ->
	#base_constellation_enchantment{equip_type = 3,pos = 2,lv = 27,cost = [{0,38040073,28}],attr = [{2,86400},{4,2592}]};

get_enchantment_cfg(3,2,28) ->
	#base_constellation_enchantment{equip_type = 3,pos = 2,lv = 28,cost = [{0,38040073,29}],attr = [{2,89600},{4,2688}]};

get_enchantment_cfg(3,2,29) ->
	#base_constellation_enchantment{equip_type = 3,pos = 2,lv = 29,cost = [{0,38040073,30}],attr = [{2,92800},{4,2784}]};

get_enchantment_cfg(3,2,30) ->
	#base_constellation_enchantment{equip_type = 3,pos = 2,lv = 30,cost = [],attr = [{2,96000},{4,2880}]};

get_enchantment_cfg(3,3,0) ->
	#base_constellation_enchantment{equip_type = 3,pos = 3,lv = 0,cost = [{0,38040073,1}],attr = [{2,0},{4,0}]};

get_enchantment_cfg(3,3,1) ->
	#base_constellation_enchantment{equip_type = 3,pos = 3,lv = 1,cost = [{0,38040073,2}],attr = [{2,3200},{4,96}]};

get_enchantment_cfg(3,3,2) ->
	#base_constellation_enchantment{equip_type = 3,pos = 3,lv = 2,cost = [{0,38040073,3}],attr = [{2,6400},{4,192}]};

get_enchantment_cfg(3,3,3) ->
	#base_constellation_enchantment{equip_type = 3,pos = 3,lv = 3,cost = [{0,38040073,4}],attr = [{2,9600},{4,288}]};

get_enchantment_cfg(3,3,4) ->
	#base_constellation_enchantment{equip_type = 3,pos = 3,lv = 4,cost = [{0,38040073,5}],attr = [{2,12800},{4,384}]};

get_enchantment_cfg(3,3,5) ->
	#base_constellation_enchantment{equip_type = 3,pos = 3,lv = 5,cost = [{0,38040073,6}],attr = [{2,16000},{4,480}]};

get_enchantment_cfg(3,3,6) ->
	#base_constellation_enchantment{equip_type = 3,pos = 3,lv = 6,cost = [{0,38040073,7}],attr = [{2,19200},{4,576}]};

get_enchantment_cfg(3,3,7) ->
	#base_constellation_enchantment{equip_type = 3,pos = 3,lv = 7,cost = [{0,38040073,8}],attr = [{2,22400},{4,672}]};

get_enchantment_cfg(3,3,8) ->
	#base_constellation_enchantment{equip_type = 3,pos = 3,lv = 8,cost = [{0,38040073,9}],attr = [{2,25600},{4,768}]};

get_enchantment_cfg(3,3,9) ->
	#base_constellation_enchantment{equip_type = 3,pos = 3,lv = 9,cost = [{0,38040073,10}],attr = [{2,28800},{4,864}]};

get_enchantment_cfg(3,3,10) ->
	#base_constellation_enchantment{equip_type = 3,pos = 3,lv = 10,cost = [{0,38040073,11}],attr = [{2,32000},{4,960}]};

get_enchantment_cfg(3,3,11) ->
	#base_constellation_enchantment{equip_type = 3,pos = 3,lv = 11,cost = [{0,38040073,12}],attr = [{2,35200},{4,1056}]};

get_enchantment_cfg(3,3,12) ->
	#base_constellation_enchantment{equip_type = 3,pos = 3,lv = 12,cost = [{0,38040073,13}],attr = [{2,38400},{4,1152}]};

get_enchantment_cfg(3,3,13) ->
	#base_constellation_enchantment{equip_type = 3,pos = 3,lv = 13,cost = [{0,38040073,14}],attr = [{2,41600},{4,1248}]};

get_enchantment_cfg(3,3,14) ->
	#base_constellation_enchantment{equip_type = 3,pos = 3,lv = 14,cost = [{0,38040073,15}],attr = [{2,44800},{4,1344}]};

get_enchantment_cfg(3,3,15) ->
	#base_constellation_enchantment{equip_type = 3,pos = 3,lv = 15,cost = [{0,38040073,16}],attr = [{2,48000},{4,1440}]};

get_enchantment_cfg(3,3,16) ->
	#base_constellation_enchantment{equip_type = 3,pos = 3,lv = 16,cost = [{0,38040073,17}],attr = [{2,51200},{4,1536}]};

get_enchantment_cfg(3,3,17) ->
	#base_constellation_enchantment{equip_type = 3,pos = 3,lv = 17,cost = [{0,38040073,18}],attr = [{2,54400},{4,1632}]};

get_enchantment_cfg(3,3,18) ->
	#base_constellation_enchantment{equip_type = 3,pos = 3,lv = 18,cost = [{0,38040073,19}],attr = [{2,57600},{4,1728}]};

get_enchantment_cfg(3,3,19) ->
	#base_constellation_enchantment{equip_type = 3,pos = 3,lv = 19,cost = [{0,38040073,20}],attr = [{2,60800},{4,1824}]};

get_enchantment_cfg(3,3,20) ->
	#base_constellation_enchantment{equip_type = 3,pos = 3,lv = 20,cost = [{0,38040073,21}],attr = [{2,64000},{4,1920}]};

get_enchantment_cfg(3,3,21) ->
	#base_constellation_enchantment{equip_type = 3,pos = 3,lv = 21,cost = [{0,38040073,22}],attr = [{2,67200},{4,2016}]};

get_enchantment_cfg(3,3,22) ->
	#base_constellation_enchantment{equip_type = 3,pos = 3,lv = 22,cost = [{0,38040073,23}],attr = [{2,70400},{4,2112}]};

get_enchantment_cfg(3,3,23) ->
	#base_constellation_enchantment{equip_type = 3,pos = 3,lv = 23,cost = [{0,38040073,24}],attr = [{2,73600},{4,2208}]};

get_enchantment_cfg(3,3,24) ->
	#base_constellation_enchantment{equip_type = 3,pos = 3,lv = 24,cost = [{0,38040073,25}],attr = [{2,76800},{4,2304}]};

get_enchantment_cfg(3,3,25) ->
	#base_constellation_enchantment{equip_type = 3,pos = 3,lv = 25,cost = [{0,38040073,26}],attr = [{2,80000},{4,2400}]};

get_enchantment_cfg(3,3,26) ->
	#base_constellation_enchantment{equip_type = 3,pos = 3,lv = 26,cost = [{0,38040073,27}],attr = [{2,83200},{4,2496}]};

get_enchantment_cfg(3,3,27) ->
	#base_constellation_enchantment{equip_type = 3,pos = 3,lv = 27,cost = [{0,38040073,28}],attr = [{2,86400},{4,2592}]};

get_enchantment_cfg(3,3,28) ->
	#base_constellation_enchantment{equip_type = 3,pos = 3,lv = 28,cost = [{0,38040073,29}],attr = [{2,89600},{4,2688}]};

get_enchantment_cfg(3,3,29) ->
	#base_constellation_enchantment{equip_type = 3,pos = 3,lv = 29,cost = [{0,38040073,30}],attr = [{2,92800},{4,2784}]};

get_enchantment_cfg(3,3,30) ->
	#base_constellation_enchantment{equip_type = 3,pos = 3,lv = 30,cost = [],attr = [{2,96000},{4,2880}]};

get_enchantment_cfg(3,4,0) ->
	#base_constellation_enchantment{equip_type = 3,pos = 4,lv = 0,cost = [{0,38040073,1}],attr = [{2,0},{4,0}]};

get_enchantment_cfg(3,4,1) ->
	#base_constellation_enchantment{equip_type = 3,pos = 4,lv = 1,cost = [{0,38040073,2}],attr = [{2,3200},{4,96}]};

get_enchantment_cfg(3,4,2) ->
	#base_constellation_enchantment{equip_type = 3,pos = 4,lv = 2,cost = [{0,38040073,3}],attr = [{2,6400},{4,192}]};

get_enchantment_cfg(3,4,3) ->
	#base_constellation_enchantment{equip_type = 3,pos = 4,lv = 3,cost = [{0,38040073,4}],attr = [{2,9600},{4,288}]};

get_enchantment_cfg(3,4,4) ->
	#base_constellation_enchantment{equip_type = 3,pos = 4,lv = 4,cost = [{0,38040073,5}],attr = [{2,12800},{4,384}]};

get_enchantment_cfg(3,4,5) ->
	#base_constellation_enchantment{equip_type = 3,pos = 4,lv = 5,cost = [{0,38040073,6}],attr = [{2,16000},{4,480}]};

get_enchantment_cfg(3,4,6) ->
	#base_constellation_enchantment{equip_type = 3,pos = 4,lv = 6,cost = [{0,38040073,7}],attr = [{2,19200},{4,576}]};

get_enchantment_cfg(3,4,7) ->
	#base_constellation_enchantment{equip_type = 3,pos = 4,lv = 7,cost = [{0,38040073,8}],attr = [{2,22400},{4,672}]};

get_enchantment_cfg(3,4,8) ->
	#base_constellation_enchantment{equip_type = 3,pos = 4,lv = 8,cost = [{0,38040073,9}],attr = [{2,25600},{4,768}]};

get_enchantment_cfg(3,4,9) ->
	#base_constellation_enchantment{equip_type = 3,pos = 4,lv = 9,cost = [{0,38040073,10}],attr = [{2,28800},{4,864}]};

get_enchantment_cfg(3,4,10) ->
	#base_constellation_enchantment{equip_type = 3,pos = 4,lv = 10,cost = [{0,38040073,11}],attr = [{2,32000},{4,960}]};

get_enchantment_cfg(3,4,11) ->
	#base_constellation_enchantment{equip_type = 3,pos = 4,lv = 11,cost = [{0,38040073,12}],attr = [{2,35200},{4,1056}]};

get_enchantment_cfg(3,4,12) ->
	#base_constellation_enchantment{equip_type = 3,pos = 4,lv = 12,cost = [{0,38040073,13}],attr = [{2,38400},{4,1152}]};

get_enchantment_cfg(3,4,13) ->
	#base_constellation_enchantment{equip_type = 3,pos = 4,lv = 13,cost = [{0,38040073,14}],attr = [{2,41600},{4,1248}]};

get_enchantment_cfg(3,4,14) ->
	#base_constellation_enchantment{equip_type = 3,pos = 4,lv = 14,cost = [{0,38040073,15}],attr = [{2,44800},{4,1344}]};

get_enchantment_cfg(3,4,15) ->
	#base_constellation_enchantment{equip_type = 3,pos = 4,lv = 15,cost = [{0,38040073,16}],attr = [{2,48000},{4,1440}]};

get_enchantment_cfg(3,4,16) ->
	#base_constellation_enchantment{equip_type = 3,pos = 4,lv = 16,cost = [{0,38040073,17}],attr = [{2,51200},{4,1536}]};

get_enchantment_cfg(3,4,17) ->
	#base_constellation_enchantment{equip_type = 3,pos = 4,lv = 17,cost = [{0,38040073,18}],attr = [{2,54400},{4,1632}]};

get_enchantment_cfg(3,4,18) ->
	#base_constellation_enchantment{equip_type = 3,pos = 4,lv = 18,cost = [{0,38040073,19}],attr = [{2,57600},{4,1728}]};

get_enchantment_cfg(3,4,19) ->
	#base_constellation_enchantment{equip_type = 3,pos = 4,lv = 19,cost = [{0,38040073,20}],attr = [{2,60800},{4,1824}]};

get_enchantment_cfg(3,4,20) ->
	#base_constellation_enchantment{equip_type = 3,pos = 4,lv = 20,cost = [{0,38040073,21}],attr = [{2,64000},{4,1920}]};

get_enchantment_cfg(3,4,21) ->
	#base_constellation_enchantment{equip_type = 3,pos = 4,lv = 21,cost = [{0,38040073,22}],attr = [{2,67200},{4,2016}]};

get_enchantment_cfg(3,4,22) ->
	#base_constellation_enchantment{equip_type = 3,pos = 4,lv = 22,cost = [{0,38040073,23}],attr = [{2,70400},{4,2112}]};

get_enchantment_cfg(3,4,23) ->
	#base_constellation_enchantment{equip_type = 3,pos = 4,lv = 23,cost = [{0,38040073,24}],attr = [{2,73600},{4,2208}]};

get_enchantment_cfg(3,4,24) ->
	#base_constellation_enchantment{equip_type = 3,pos = 4,lv = 24,cost = [{0,38040073,25}],attr = [{2,76800},{4,2304}]};

get_enchantment_cfg(3,4,25) ->
	#base_constellation_enchantment{equip_type = 3,pos = 4,lv = 25,cost = [{0,38040073,26}],attr = [{2,80000},{4,2400}]};

get_enchantment_cfg(3,4,26) ->
	#base_constellation_enchantment{equip_type = 3,pos = 4,lv = 26,cost = [{0,38040073,27}],attr = [{2,83200},{4,2496}]};

get_enchantment_cfg(3,4,27) ->
	#base_constellation_enchantment{equip_type = 3,pos = 4,lv = 27,cost = [{0,38040073,28}],attr = [{2,86400},{4,2592}]};

get_enchantment_cfg(3,4,28) ->
	#base_constellation_enchantment{equip_type = 3,pos = 4,lv = 28,cost = [{0,38040073,29}],attr = [{2,89600},{4,2688}]};

get_enchantment_cfg(3,4,29) ->
	#base_constellation_enchantment{equip_type = 3,pos = 4,lv = 29,cost = [{0,38040073,30}],attr = [{2,92800},{4,2784}]};

get_enchantment_cfg(3,4,30) ->
	#base_constellation_enchantment{equip_type = 3,pos = 4,lv = 30,cost = [],attr = [{2,96000},{4,2880}]};

get_enchantment_cfg(3,5,0) ->
	#base_constellation_enchantment{equip_type = 3,pos = 5,lv = 0,cost = [{0,38040073,1}],attr = [{1,0},{3,0}]};

get_enchantment_cfg(3,5,1) ->
	#base_constellation_enchantment{equip_type = 3,pos = 5,lv = 1,cost = [{0,38040073,2}],attr = [{1,160},{3,96}]};

get_enchantment_cfg(3,5,2) ->
	#base_constellation_enchantment{equip_type = 3,pos = 5,lv = 2,cost = [{0,38040073,3}],attr = [{1,320},{3,192}]};

get_enchantment_cfg(3,5,3) ->
	#base_constellation_enchantment{equip_type = 3,pos = 5,lv = 3,cost = [{0,38040073,4}],attr = [{1,480},{3,288}]};

get_enchantment_cfg(3,5,4) ->
	#base_constellation_enchantment{equip_type = 3,pos = 5,lv = 4,cost = [{0,38040073,5}],attr = [{1,640},{3,384}]};

get_enchantment_cfg(3,5,5) ->
	#base_constellation_enchantment{equip_type = 3,pos = 5,lv = 5,cost = [{0,38040073,6}],attr = [{1,800},{3,480}]};

get_enchantment_cfg(3,5,6) ->
	#base_constellation_enchantment{equip_type = 3,pos = 5,lv = 6,cost = [{0,38040073,7}],attr = [{1,960},{3,576}]};

get_enchantment_cfg(3,5,7) ->
	#base_constellation_enchantment{equip_type = 3,pos = 5,lv = 7,cost = [{0,38040073,8}],attr = [{1,1120},{3,672}]};

get_enchantment_cfg(3,5,8) ->
	#base_constellation_enchantment{equip_type = 3,pos = 5,lv = 8,cost = [{0,38040073,9}],attr = [{1,1280},{3,768}]};

get_enchantment_cfg(3,5,9) ->
	#base_constellation_enchantment{equip_type = 3,pos = 5,lv = 9,cost = [{0,38040073,10}],attr = [{1,1440},{3,864}]};

get_enchantment_cfg(3,5,10) ->
	#base_constellation_enchantment{equip_type = 3,pos = 5,lv = 10,cost = [{0,38040073,11}],attr = [{1,1600},{3,960}]};

get_enchantment_cfg(3,5,11) ->
	#base_constellation_enchantment{equip_type = 3,pos = 5,lv = 11,cost = [{0,38040073,12}],attr = [{1,1760},{3,1056}]};

get_enchantment_cfg(3,5,12) ->
	#base_constellation_enchantment{equip_type = 3,pos = 5,lv = 12,cost = [{0,38040073,13}],attr = [{1,1920},{3,1152}]};

get_enchantment_cfg(3,5,13) ->
	#base_constellation_enchantment{equip_type = 3,pos = 5,lv = 13,cost = [{0,38040073,14}],attr = [{1,2080},{3,1248}]};

get_enchantment_cfg(3,5,14) ->
	#base_constellation_enchantment{equip_type = 3,pos = 5,lv = 14,cost = [{0,38040073,15}],attr = [{1,2240},{3,1344}]};

get_enchantment_cfg(3,5,15) ->
	#base_constellation_enchantment{equip_type = 3,pos = 5,lv = 15,cost = [{0,38040073,16}],attr = [{1,2400},{3,1440}]};

get_enchantment_cfg(3,5,16) ->
	#base_constellation_enchantment{equip_type = 3,pos = 5,lv = 16,cost = [{0,38040073,17}],attr = [{1,2560},{3,1536}]};

get_enchantment_cfg(3,5,17) ->
	#base_constellation_enchantment{equip_type = 3,pos = 5,lv = 17,cost = [{0,38040073,18}],attr = [{1,2720},{3,1632}]};

get_enchantment_cfg(3,5,18) ->
	#base_constellation_enchantment{equip_type = 3,pos = 5,lv = 18,cost = [{0,38040073,19}],attr = [{1,2880},{3,1728}]};

get_enchantment_cfg(3,5,19) ->
	#base_constellation_enchantment{equip_type = 3,pos = 5,lv = 19,cost = [{0,38040073,20}],attr = [{1,3040},{3,1824}]};

get_enchantment_cfg(3,5,20) ->
	#base_constellation_enchantment{equip_type = 3,pos = 5,lv = 20,cost = [{0,38040073,21}],attr = [{1,3200},{3,1920}]};

get_enchantment_cfg(3,5,21) ->
	#base_constellation_enchantment{equip_type = 3,pos = 5,lv = 21,cost = [{0,38040073,22}],attr = [{1,3360},{3,2016}]};

get_enchantment_cfg(3,5,22) ->
	#base_constellation_enchantment{equip_type = 3,pos = 5,lv = 22,cost = [{0,38040073,23}],attr = [{1,3520},{3,2112}]};

get_enchantment_cfg(3,5,23) ->
	#base_constellation_enchantment{equip_type = 3,pos = 5,lv = 23,cost = [{0,38040073,24}],attr = [{1,3680},{3,2208}]};

get_enchantment_cfg(3,5,24) ->
	#base_constellation_enchantment{equip_type = 3,pos = 5,lv = 24,cost = [{0,38040073,25}],attr = [{1,3840},{3,2304}]};

get_enchantment_cfg(3,5,25) ->
	#base_constellation_enchantment{equip_type = 3,pos = 5,lv = 25,cost = [{0,38040073,26}],attr = [{1,4000},{3,2400}]};

get_enchantment_cfg(3,5,26) ->
	#base_constellation_enchantment{equip_type = 3,pos = 5,lv = 26,cost = [{0,38040073,27}],attr = [{1,4160},{3,2496}]};

get_enchantment_cfg(3,5,27) ->
	#base_constellation_enchantment{equip_type = 3,pos = 5,lv = 27,cost = [{0,38040073,28}],attr = [{1,4320},{3,2592}]};

get_enchantment_cfg(3,5,28) ->
	#base_constellation_enchantment{equip_type = 3,pos = 5,lv = 28,cost = [{0,38040073,29}],attr = [{1,4480},{3,2688}]};

get_enchantment_cfg(3,5,29) ->
	#base_constellation_enchantment{equip_type = 3,pos = 5,lv = 29,cost = [{0,38040073,30}],attr = [{1,4640},{3,2784}]};

get_enchantment_cfg(3,5,30) ->
	#base_constellation_enchantment{equip_type = 3,pos = 5,lv = 30,cost = [],attr = [{1,4800},{3,2880}]};

get_enchantment_cfg(3,6,0) ->
	#base_constellation_enchantment{equip_type = 3,pos = 6,lv = 0,cost = [{0,38040073,1}],attr = [{2,0},{4,0}]};

get_enchantment_cfg(3,6,1) ->
	#base_constellation_enchantment{equip_type = 3,pos = 6,lv = 1,cost = [{0,38040073,2}],attr = [{2,3200},{4,96}]};

get_enchantment_cfg(3,6,2) ->
	#base_constellation_enchantment{equip_type = 3,pos = 6,lv = 2,cost = [{0,38040073,3}],attr = [{2,6400},{4,192}]};

get_enchantment_cfg(3,6,3) ->
	#base_constellation_enchantment{equip_type = 3,pos = 6,lv = 3,cost = [{0,38040073,4}],attr = [{2,9600},{4,288}]};

get_enchantment_cfg(3,6,4) ->
	#base_constellation_enchantment{equip_type = 3,pos = 6,lv = 4,cost = [{0,38040073,5}],attr = [{2,12800},{4,384}]};

get_enchantment_cfg(3,6,5) ->
	#base_constellation_enchantment{equip_type = 3,pos = 6,lv = 5,cost = [{0,38040073,6}],attr = [{2,16000},{4,480}]};

get_enchantment_cfg(3,6,6) ->
	#base_constellation_enchantment{equip_type = 3,pos = 6,lv = 6,cost = [{0,38040073,7}],attr = [{2,19200},{4,576}]};

get_enchantment_cfg(3,6,7) ->
	#base_constellation_enchantment{equip_type = 3,pos = 6,lv = 7,cost = [{0,38040073,8}],attr = [{2,22400},{4,672}]};

get_enchantment_cfg(3,6,8) ->
	#base_constellation_enchantment{equip_type = 3,pos = 6,lv = 8,cost = [{0,38040073,9}],attr = [{2,25600},{4,768}]};

get_enchantment_cfg(3,6,9) ->
	#base_constellation_enchantment{equip_type = 3,pos = 6,lv = 9,cost = [{0,38040073,10}],attr = [{2,28800},{4,864}]};

get_enchantment_cfg(3,6,10) ->
	#base_constellation_enchantment{equip_type = 3,pos = 6,lv = 10,cost = [{0,38040073,11}],attr = [{2,32000},{4,960}]};

get_enchantment_cfg(3,6,11) ->
	#base_constellation_enchantment{equip_type = 3,pos = 6,lv = 11,cost = [{0,38040073,12}],attr = [{2,35200},{4,1056}]};

get_enchantment_cfg(3,6,12) ->
	#base_constellation_enchantment{equip_type = 3,pos = 6,lv = 12,cost = [{0,38040073,13}],attr = [{2,38400},{4,1152}]};

get_enchantment_cfg(3,6,13) ->
	#base_constellation_enchantment{equip_type = 3,pos = 6,lv = 13,cost = [{0,38040073,14}],attr = [{2,41600},{4,1248}]};

get_enchantment_cfg(3,6,14) ->
	#base_constellation_enchantment{equip_type = 3,pos = 6,lv = 14,cost = [{0,38040073,15}],attr = [{2,44800},{4,1344}]};

get_enchantment_cfg(3,6,15) ->
	#base_constellation_enchantment{equip_type = 3,pos = 6,lv = 15,cost = [{0,38040073,16}],attr = [{2,48000},{4,1440}]};

get_enchantment_cfg(3,6,16) ->
	#base_constellation_enchantment{equip_type = 3,pos = 6,lv = 16,cost = [{0,38040073,17}],attr = [{2,51200},{4,1536}]};

get_enchantment_cfg(3,6,17) ->
	#base_constellation_enchantment{equip_type = 3,pos = 6,lv = 17,cost = [{0,38040073,18}],attr = [{2,54400},{4,1632}]};

get_enchantment_cfg(3,6,18) ->
	#base_constellation_enchantment{equip_type = 3,pos = 6,lv = 18,cost = [{0,38040073,19}],attr = [{2,57600},{4,1728}]};

get_enchantment_cfg(3,6,19) ->
	#base_constellation_enchantment{equip_type = 3,pos = 6,lv = 19,cost = [{0,38040073,20}],attr = [{2,60800},{4,1824}]};

get_enchantment_cfg(3,6,20) ->
	#base_constellation_enchantment{equip_type = 3,pos = 6,lv = 20,cost = [{0,38040073,21}],attr = [{2,64000},{4,1920}]};

get_enchantment_cfg(3,6,21) ->
	#base_constellation_enchantment{equip_type = 3,pos = 6,lv = 21,cost = [{0,38040073,22}],attr = [{2,67200},{4,2016}]};

get_enchantment_cfg(3,6,22) ->
	#base_constellation_enchantment{equip_type = 3,pos = 6,lv = 22,cost = [{0,38040073,23}],attr = [{2,70400},{4,2112}]};

get_enchantment_cfg(3,6,23) ->
	#base_constellation_enchantment{equip_type = 3,pos = 6,lv = 23,cost = [{0,38040073,24}],attr = [{2,73600},{4,2208}]};

get_enchantment_cfg(3,6,24) ->
	#base_constellation_enchantment{equip_type = 3,pos = 6,lv = 24,cost = [{0,38040073,25}],attr = [{2,76800},{4,2304}]};

get_enchantment_cfg(3,6,25) ->
	#base_constellation_enchantment{equip_type = 3,pos = 6,lv = 25,cost = [{0,38040073,26}],attr = [{2,80000},{4,2400}]};

get_enchantment_cfg(3,6,26) ->
	#base_constellation_enchantment{equip_type = 3,pos = 6,lv = 26,cost = [{0,38040073,27}],attr = [{2,83200},{4,2496}]};

get_enchantment_cfg(3,6,27) ->
	#base_constellation_enchantment{equip_type = 3,pos = 6,lv = 27,cost = [{0,38040073,28}],attr = [{2,86400},{4,2592}]};

get_enchantment_cfg(3,6,28) ->
	#base_constellation_enchantment{equip_type = 3,pos = 6,lv = 28,cost = [{0,38040073,29}],attr = [{2,89600},{4,2688}]};

get_enchantment_cfg(3,6,29) ->
	#base_constellation_enchantment{equip_type = 3,pos = 6,lv = 29,cost = [{0,38040073,30}],attr = [{2,92800},{4,2784}]};

get_enchantment_cfg(3,6,30) ->
	#base_constellation_enchantment{equip_type = 3,pos = 6,lv = 30,cost = [],attr = [{2,96000},{4,2880}]};

get_enchantment_cfg(4,1,0) ->
	#base_constellation_enchantment{equip_type = 4,pos = 1,lv = 0,cost = [{0,38040073,1}],attr = [{1,0},{3,0}]};

get_enchantment_cfg(4,1,1) ->
	#base_constellation_enchantment{equip_type = 4,pos = 1,lv = 1,cost = [{0,38040073,2}],attr = [{1,200},{3,120}]};

get_enchantment_cfg(4,1,2) ->
	#base_constellation_enchantment{equip_type = 4,pos = 1,lv = 2,cost = [{0,38040073,3}],attr = [{1,400},{3,240}]};

get_enchantment_cfg(4,1,3) ->
	#base_constellation_enchantment{equip_type = 4,pos = 1,lv = 3,cost = [{0,38040073,4}],attr = [{1,600},{3,360}]};

get_enchantment_cfg(4,1,4) ->
	#base_constellation_enchantment{equip_type = 4,pos = 1,lv = 4,cost = [{0,38040073,5}],attr = [{1,800},{3,480}]};

get_enchantment_cfg(4,1,5) ->
	#base_constellation_enchantment{equip_type = 4,pos = 1,lv = 5,cost = [{0,38040073,6}],attr = [{1,1000},{3,600}]};

get_enchantment_cfg(4,1,6) ->
	#base_constellation_enchantment{equip_type = 4,pos = 1,lv = 6,cost = [{0,38040073,7}],attr = [{1,1200},{3,720}]};

get_enchantment_cfg(4,1,7) ->
	#base_constellation_enchantment{equip_type = 4,pos = 1,lv = 7,cost = [{0,38040073,8}],attr = [{1,1400},{3,840}]};

get_enchantment_cfg(4,1,8) ->
	#base_constellation_enchantment{equip_type = 4,pos = 1,lv = 8,cost = [{0,38040073,9}],attr = [{1,1600},{3,960}]};

get_enchantment_cfg(4,1,9) ->
	#base_constellation_enchantment{equip_type = 4,pos = 1,lv = 9,cost = [{0,38040073,10}],attr = [{1,1800},{3,1080}]};

get_enchantment_cfg(4,1,10) ->
	#base_constellation_enchantment{equip_type = 4,pos = 1,lv = 10,cost = [{0,38040073,11}],attr = [{1,2000},{3,1200}]};

get_enchantment_cfg(4,1,11) ->
	#base_constellation_enchantment{equip_type = 4,pos = 1,lv = 11,cost = [{0,38040073,12}],attr = [{1,2200},{3,1320}]};

get_enchantment_cfg(4,1,12) ->
	#base_constellation_enchantment{equip_type = 4,pos = 1,lv = 12,cost = [{0,38040073,13}],attr = [{1,2400},{3,1440}]};

get_enchantment_cfg(4,1,13) ->
	#base_constellation_enchantment{equip_type = 4,pos = 1,lv = 13,cost = [{0,38040073,14}],attr = [{1,2600},{3,1560}]};

get_enchantment_cfg(4,1,14) ->
	#base_constellation_enchantment{equip_type = 4,pos = 1,lv = 14,cost = [{0,38040073,15}],attr = [{1,2800},{3,1680}]};

get_enchantment_cfg(4,1,15) ->
	#base_constellation_enchantment{equip_type = 4,pos = 1,lv = 15,cost = [{0,38040073,16}],attr = [{1,3000},{3,1800}]};

get_enchantment_cfg(4,1,16) ->
	#base_constellation_enchantment{equip_type = 4,pos = 1,lv = 16,cost = [{0,38040073,17}],attr = [{1,3200},{3,1920}]};

get_enchantment_cfg(4,1,17) ->
	#base_constellation_enchantment{equip_type = 4,pos = 1,lv = 17,cost = [{0,38040073,18}],attr = [{1,3400},{3,2040}]};

get_enchantment_cfg(4,1,18) ->
	#base_constellation_enchantment{equip_type = 4,pos = 1,lv = 18,cost = [{0,38040073,19}],attr = [{1,3600},{3,2160}]};

get_enchantment_cfg(4,1,19) ->
	#base_constellation_enchantment{equip_type = 4,pos = 1,lv = 19,cost = [{0,38040073,20}],attr = [{1,3800},{3,2280}]};

get_enchantment_cfg(4,1,20) ->
	#base_constellation_enchantment{equip_type = 4,pos = 1,lv = 20,cost = [{0,38040073,21}],attr = [{1,4000},{3,2400}]};

get_enchantment_cfg(4,1,21) ->
	#base_constellation_enchantment{equip_type = 4,pos = 1,lv = 21,cost = [{0,38040073,22}],attr = [{1,4200},{3,2520}]};

get_enchantment_cfg(4,1,22) ->
	#base_constellation_enchantment{equip_type = 4,pos = 1,lv = 22,cost = [{0,38040073,23}],attr = [{1,4400},{3,2640}]};

get_enchantment_cfg(4,1,23) ->
	#base_constellation_enchantment{equip_type = 4,pos = 1,lv = 23,cost = [{0,38040073,24}],attr = [{1,4600},{3,2760}]};

get_enchantment_cfg(4,1,24) ->
	#base_constellation_enchantment{equip_type = 4,pos = 1,lv = 24,cost = [{0,38040073,25}],attr = [{1,4800},{3,2880}]};

get_enchantment_cfg(4,1,25) ->
	#base_constellation_enchantment{equip_type = 4,pos = 1,lv = 25,cost = [{0,38040073,26}],attr = [{1,5000},{3,3000}]};

get_enchantment_cfg(4,1,26) ->
	#base_constellation_enchantment{equip_type = 4,pos = 1,lv = 26,cost = [{0,38040073,27}],attr = [{1,5200},{3,3120}]};

get_enchantment_cfg(4,1,27) ->
	#base_constellation_enchantment{equip_type = 4,pos = 1,lv = 27,cost = [{0,38040073,28}],attr = [{1,5400},{3,3240}]};

get_enchantment_cfg(4,1,28) ->
	#base_constellation_enchantment{equip_type = 4,pos = 1,lv = 28,cost = [{0,38040073,29}],attr = [{1,5600},{3,3360}]};

get_enchantment_cfg(4,1,29) ->
	#base_constellation_enchantment{equip_type = 4,pos = 1,lv = 29,cost = [{0,38040073,30}],attr = [{1,5800},{3,3480}]};

get_enchantment_cfg(4,1,30) ->
	#base_constellation_enchantment{equip_type = 4,pos = 1,lv = 30,cost = [],attr = [{1,6000},{3,3600}]};

get_enchantment_cfg(4,2,0) ->
	#base_constellation_enchantment{equip_type = 4,pos = 2,lv = 0,cost = [{0,38040073,1}],attr = [{2,0},{4,0}]};

get_enchantment_cfg(4,2,1) ->
	#base_constellation_enchantment{equip_type = 4,pos = 2,lv = 1,cost = [{0,38040073,2}],attr = [{2,4000},{4,120}]};

get_enchantment_cfg(4,2,2) ->
	#base_constellation_enchantment{equip_type = 4,pos = 2,lv = 2,cost = [{0,38040073,3}],attr = [{2,8000},{4,240}]};

get_enchantment_cfg(4,2,3) ->
	#base_constellation_enchantment{equip_type = 4,pos = 2,lv = 3,cost = [{0,38040073,4}],attr = [{2,12000},{4,360}]};

get_enchantment_cfg(4,2,4) ->
	#base_constellation_enchantment{equip_type = 4,pos = 2,lv = 4,cost = [{0,38040073,5}],attr = [{2,16000},{4,480}]};

get_enchantment_cfg(4,2,5) ->
	#base_constellation_enchantment{equip_type = 4,pos = 2,lv = 5,cost = [{0,38040073,6}],attr = [{2,20000},{4,600}]};

get_enchantment_cfg(4,2,6) ->
	#base_constellation_enchantment{equip_type = 4,pos = 2,lv = 6,cost = [{0,38040073,7}],attr = [{2,24000},{4,720}]};

get_enchantment_cfg(4,2,7) ->
	#base_constellation_enchantment{equip_type = 4,pos = 2,lv = 7,cost = [{0,38040073,8}],attr = [{2,28000},{4,840}]};

get_enchantment_cfg(4,2,8) ->
	#base_constellation_enchantment{equip_type = 4,pos = 2,lv = 8,cost = [{0,38040073,9}],attr = [{2,32000},{4,960}]};

get_enchantment_cfg(4,2,9) ->
	#base_constellation_enchantment{equip_type = 4,pos = 2,lv = 9,cost = [{0,38040073,10}],attr = [{2,36000},{4,1080}]};

get_enchantment_cfg(4,2,10) ->
	#base_constellation_enchantment{equip_type = 4,pos = 2,lv = 10,cost = [{0,38040073,11}],attr = [{2,40000},{4,1200}]};

get_enchantment_cfg(4,2,11) ->
	#base_constellation_enchantment{equip_type = 4,pos = 2,lv = 11,cost = [{0,38040073,12}],attr = [{2,44000},{4,1320}]};

get_enchantment_cfg(4,2,12) ->
	#base_constellation_enchantment{equip_type = 4,pos = 2,lv = 12,cost = [{0,38040073,13}],attr = [{2,48000},{4,1440}]};

get_enchantment_cfg(4,2,13) ->
	#base_constellation_enchantment{equip_type = 4,pos = 2,lv = 13,cost = [{0,38040073,14}],attr = [{2,52000},{4,1560}]};

get_enchantment_cfg(4,2,14) ->
	#base_constellation_enchantment{equip_type = 4,pos = 2,lv = 14,cost = [{0,38040073,15}],attr = [{2,56000},{4,1680}]};

get_enchantment_cfg(4,2,15) ->
	#base_constellation_enchantment{equip_type = 4,pos = 2,lv = 15,cost = [{0,38040073,16}],attr = [{2,60000},{4,1800}]};

get_enchantment_cfg(4,2,16) ->
	#base_constellation_enchantment{equip_type = 4,pos = 2,lv = 16,cost = [{0,38040073,17}],attr = [{2,64000},{4,1920}]};

get_enchantment_cfg(4,2,17) ->
	#base_constellation_enchantment{equip_type = 4,pos = 2,lv = 17,cost = [{0,38040073,18}],attr = [{2,68000},{4,2040}]};

get_enchantment_cfg(4,2,18) ->
	#base_constellation_enchantment{equip_type = 4,pos = 2,lv = 18,cost = [{0,38040073,19}],attr = [{2,72000},{4,2160}]};

get_enchantment_cfg(4,2,19) ->
	#base_constellation_enchantment{equip_type = 4,pos = 2,lv = 19,cost = [{0,38040073,20}],attr = [{2,76000},{4,2280}]};

get_enchantment_cfg(4,2,20) ->
	#base_constellation_enchantment{equip_type = 4,pos = 2,lv = 20,cost = [{0,38040073,21}],attr = [{2,80000},{4,2400}]};

get_enchantment_cfg(4,2,21) ->
	#base_constellation_enchantment{equip_type = 4,pos = 2,lv = 21,cost = [{0,38040073,22}],attr = [{2,84000},{4,2520}]};

get_enchantment_cfg(4,2,22) ->
	#base_constellation_enchantment{equip_type = 4,pos = 2,lv = 22,cost = [{0,38040073,23}],attr = [{2,88000},{4,2640}]};

get_enchantment_cfg(4,2,23) ->
	#base_constellation_enchantment{equip_type = 4,pos = 2,lv = 23,cost = [{0,38040073,24}],attr = [{2,92000},{4,2760}]};

get_enchantment_cfg(4,2,24) ->
	#base_constellation_enchantment{equip_type = 4,pos = 2,lv = 24,cost = [{0,38040073,25}],attr = [{2,96000},{4,2880}]};

get_enchantment_cfg(4,2,25) ->
	#base_constellation_enchantment{equip_type = 4,pos = 2,lv = 25,cost = [{0,38040073,26}],attr = [{2,100000},{4,3000}]};

get_enchantment_cfg(4,2,26) ->
	#base_constellation_enchantment{equip_type = 4,pos = 2,lv = 26,cost = [{0,38040073,27}],attr = [{2,104000},{4,3120}]};

get_enchantment_cfg(4,2,27) ->
	#base_constellation_enchantment{equip_type = 4,pos = 2,lv = 27,cost = [{0,38040073,28}],attr = [{2,108000},{4,3240}]};

get_enchantment_cfg(4,2,28) ->
	#base_constellation_enchantment{equip_type = 4,pos = 2,lv = 28,cost = [{0,38040073,29}],attr = [{2,112000},{4,3360}]};

get_enchantment_cfg(4,2,29) ->
	#base_constellation_enchantment{equip_type = 4,pos = 2,lv = 29,cost = [{0,38040073,30}],attr = [{2,116000},{4,3480}]};

get_enchantment_cfg(4,2,30) ->
	#base_constellation_enchantment{equip_type = 4,pos = 2,lv = 30,cost = [],attr = [{2,120000},{4,3600}]};

get_enchantment_cfg(4,3,0) ->
	#base_constellation_enchantment{equip_type = 4,pos = 3,lv = 0,cost = [{0,38040073,1}],attr = [{2,0},{4,0}]};

get_enchantment_cfg(4,3,1) ->
	#base_constellation_enchantment{equip_type = 4,pos = 3,lv = 1,cost = [{0,38040073,2}],attr = [{2,4000},{4,120}]};

get_enchantment_cfg(4,3,2) ->
	#base_constellation_enchantment{equip_type = 4,pos = 3,lv = 2,cost = [{0,38040073,3}],attr = [{2,8000},{4,240}]};

get_enchantment_cfg(4,3,3) ->
	#base_constellation_enchantment{equip_type = 4,pos = 3,lv = 3,cost = [{0,38040073,4}],attr = [{2,12000},{4,360}]};

get_enchantment_cfg(4,3,4) ->
	#base_constellation_enchantment{equip_type = 4,pos = 3,lv = 4,cost = [{0,38040073,5}],attr = [{2,16000},{4,480}]};

get_enchantment_cfg(4,3,5) ->
	#base_constellation_enchantment{equip_type = 4,pos = 3,lv = 5,cost = [{0,38040073,6}],attr = [{2,20000},{4,600}]};

get_enchantment_cfg(4,3,6) ->
	#base_constellation_enchantment{equip_type = 4,pos = 3,lv = 6,cost = [{0,38040073,7}],attr = [{2,24000},{4,720}]};

get_enchantment_cfg(4,3,7) ->
	#base_constellation_enchantment{equip_type = 4,pos = 3,lv = 7,cost = [{0,38040073,8}],attr = [{2,28000},{4,840}]};

get_enchantment_cfg(4,3,8) ->
	#base_constellation_enchantment{equip_type = 4,pos = 3,lv = 8,cost = [{0,38040073,9}],attr = [{2,32000},{4,960}]};

get_enchantment_cfg(4,3,9) ->
	#base_constellation_enchantment{equip_type = 4,pos = 3,lv = 9,cost = [{0,38040073,10}],attr = [{2,36000},{4,1080}]};

get_enchantment_cfg(4,3,10) ->
	#base_constellation_enchantment{equip_type = 4,pos = 3,lv = 10,cost = [{0,38040073,11}],attr = [{2,40000},{4,1200}]};

get_enchantment_cfg(4,3,11) ->
	#base_constellation_enchantment{equip_type = 4,pos = 3,lv = 11,cost = [{0,38040073,12}],attr = [{2,44000},{4,1320}]};

get_enchantment_cfg(4,3,12) ->
	#base_constellation_enchantment{equip_type = 4,pos = 3,lv = 12,cost = [{0,38040073,13}],attr = [{2,48000},{4,1440}]};

get_enchantment_cfg(4,3,13) ->
	#base_constellation_enchantment{equip_type = 4,pos = 3,lv = 13,cost = [{0,38040073,14}],attr = [{2,52000},{4,1560}]};

get_enchantment_cfg(4,3,14) ->
	#base_constellation_enchantment{equip_type = 4,pos = 3,lv = 14,cost = [{0,38040073,15}],attr = [{2,56000},{4,1680}]};

get_enchantment_cfg(4,3,15) ->
	#base_constellation_enchantment{equip_type = 4,pos = 3,lv = 15,cost = [{0,38040073,16}],attr = [{2,60000},{4,1800}]};

get_enchantment_cfg(4,3,16) ->
	#base_constellation_enchantment{equip_type = 4,pos = 3,lv = 16,cost = [{0,38040073,17}],attr = [{2,64000},{4,1920}]};

get_enchantment_cfg(4,3,17) ->
	#base_constellation_enchantment{equip_type = 4,pos = 3,lv = 17,cost = [{0,38040073,18}],attr = [{2,68000},{4,2040}]};

get_enchantment_cfg(4,3,18) ->
	#base_constellation_enchantment{equip_type = 4,pos = 3,lv = 18,cost = [{0,38040073,19}],attr = [{2,72000},{4,2160}]};

get_enchantment_cfg(4,3,19) ->
	#base_constellation_enchantment{equip_type = 4,pos = 3,lv = 19,cost = [{0,38040073,20}],attr = [{2,76000},{4,2280}]};

get_enchantment_cfg(4,3,20) ->
	#base_constellation_enchantment{equip_type = 4,pos = 3,lv = 20,cost = [{0,38040073,21}],attr = [{2,80000},{4,2400}]};

get_enchantment_cfg(4,3,21) ->
	#base_constellation_enchantment{equip_type = 4,pos = 3,lv = 21,cost = [{0,38040073,22}],attr = [{2,84000},{4,2520}]};

get_enchantment_cfg(4,3,22) ->
	#base_constellation_enchantment{equip_type = 4,pos = 3,lv = 22,cost = [{0,38040073,23}],attr = [{2,88000},{4,2640}]};

get_enchantment_cfg(4,3,23) ->
	#base_constellation_enchantment{equip_type = 4,pos = 3,lv = 23,cost = [{0,38040073,24}],attr = [{2,92000},{4,2760}]};

get_enchantment_cfg(4,3,24) ->
	#base_constellation_enchantment{equip_type = 4,pos = 3,lv = 24,cost = [{0,38040073,25}],attr = [{2,96000},{4,2880}]};

get_enchantment_cfg(4,3,25) ->
	#base_constellation_enchantment{equip_type = 4,pos = 3,lv = 25,cost = [{0,38040073,26}],attr = [{2,100000},{4,3000}]};

get_enchantment_cfg(4,3,26) ->
	#base_constellation_enchantment{equip_type = 4,pos = 3,lv = 26,cost = [{0,38040073,27}],attr = [{2,104000},{4,3120}]};

get_enchantment_cfg(4,3,27) ->
	#base_constellation_enchantment{equip_type = 4,pos = 3,lv = 27,cost = [{0,38040073,28}],attr = [{2,108000},{4,3240}]};

get_enchantment_cfg(4,3,28) ->
	#base_constellation_enchantment{equip_type = 4,pos = 3,lv = 28,cost = [{0,38040073,29}],attr = [{2,112000},{4,3360}]};

get_enchantment_cfg(4,3,29) ->
	#base_constellation_enchantment{equip_type = 4,pos = 3,lv = 29,cost = [{0,38040073,30}],attr = [{2,116000},{4,3480}]};

get_enchantment_cfg(4,3,30) ->
	#base_constellation_enchantment{equip_type = 4,pos = 3,lv = 30,cost = [],attr = [{2,120000},{4,3600}]};

get_enchantment_cfg(4,4,0) ->
	#base_constellation_enchantment{equip_type = 4,pos = 4,lv = 0,cost = [{0,38040073,1}],attr = [{2,0},{4,0}]};

get_enchantment_cfg(4,4,1) ->
	#base_constellation_enchantment{equip_type = 4,pos = 4,lv = 1,cost = [{0,38040073,2}],attr = [{2,4000},{4,120}]};

get_enchantment_cfg(4,4,2) ->
	#base_constellation_enchantment{equip_type = 4,pos = 4,lv = 2,cost = [{0,38040073,3}],attr = [{2,8000},{4,240}]};

get_enchantment_cfg(4,4,3) ->
	#base_constellation_enchantment{equip_type = 4,pos = 4,lv = 3,cost = [{0,38040073,4}],attr = [{2,12000},{4,360}]};

get_enchantment_cfg(4,4,4) ->
	#base_constellation_enchantment{equip_type = 4,pos = 4,lv = 4,cost = [{0,38040073,5}],attr = [{2,16000},{4,480}]};

get_enchantment_cfg(4,4,5) ->
	#base_constellation_enchantment{equip_type = 4,pos = 4,lv = 5,cost = [{0,38040073,6}],attr = [{2,20000},{4,600}]};

get_enchantment_cfg(4,4,6) ->
	#base_constellation_enchantment{equip_type = 4,pos = 4,lv = 6,cost = [{0,38040073,7}],attr = [{2,24000},{4,720}]};

get_enchantment_cfg(4,4,7) ->
	#base_constellation_enchantment{equip_type = 4,pos = 4,lv = 7,cost = [{0,38040073,8}],attr = [{2,28000},{4,840}]};

get_enchantment_cfg(4,4,8) ->
	#base_constellation_enchantment{equip_type = 4,pos = 4,lv = 8,cost = [{0,38040073,9}],attr = [{2,32000},{4,960}]};

get_enchantment_cfg(4,4,9) ->
	#base_constellation_enchantment{equip_type = 4,pos = 4,lv = 9,cost = [{0,38040073,10}],attr = [{2,36000},{4,1080}]};

get_enchantment_cfg(4,4,10) ->
	#base_constellation_enchantment{equip_type = 4,pos = 4,lv = 10,cost = [{0,38040073,11}],attr = [{2,40000},{4,1200}]};

get_enchantment_cfg(4,4,11) ->
	#base_constellation_enchantment{equip_type = 4,pos = 4,lv = 11,cost = [{0,38040073,12}],attr = [{2,44000},{4,1320}]};

get_enchantment_cfg(4,4,12) ->
	#base_constellation_enchantment{equip_type = 4,pos = 4,lv = 12,cost = [{0,38040073,13}],attr = [{2,48000},{4,1440}]};

get_enchantment_cfg(4,4,13) ->
	#base_constellation_enchantment{equip_type = 4,pos = 4,lv = 13,cost = [{0,38040073,14}],attr = [{2,52000},{4,1560}]};

get_enchantment_cfg(4,4,14) ->
	#base_constellation_enchantment{equip_type = 4,pos = 4,lv = 14,cost = [{0,38040073,15}],attr = [{2,56000},{4,1680}]};

get_enchantment_cfg(4,4,15) ->
	#base_constellation_enchantment{equip_type = 4,pos = 4,lv = 15,cost = [{0,38040073,16}],attr = [{2,60000},{4,1800}]};

get_enchantment_cfg(4,4,16) ->
	#base_constellation_enchantment{equip_type = 4,pos = 4,lv = 16,cost = [{0,38040073,17}],attr = [{2,64000},{4,1920}]};

get_enchantment_cfg(4,4,17) ->
	#base_constellation_enchantment{equip_type = 4,pos = 4,lv = 17,cost = [{0,38040073,18}],attr = [{2,68000},{4,2040}]};

get_enchantment_cfg(4,4,18) ->
	#base_constellation_enchantment{equip_type = 4,pos = 4,lv = 18,cost = [{0,38040073,19}],attr = [{2,72000},{4,2160}]};

get_enchantment_cfg(4,4,19) ->
	#base_constellation_enchantment{equip_type = 4,pos = 4,lv = 19,cost = [{0,38040073,20}],attr = [{2,76000},{4,2280}]};

get_enchantment_cfg(4,4,20) ->
	#base_constellation_enchantment{equip_type = 4,pos = 4,lv = 20,cost = [{0,38040073,21}],attr = [{2,80000},{4,2400}]};

get_enchantment_cfg(4,4,21) ->
	#base_constellation_enchantment{equip_type = 4,pos = 4,lv = 21,cost = [{0,38040073,22}],attr = [{2,84000},{4,2520}]};

get_enchantment_cfg(4,4,22) ->
	#base_constellation_enchantment{equip_type = 4,pos = 4,lv = 22,cost = [{0,38040073,23}],attr = [{2,88000},{4,2640}]};

get_enchantment_cfg(4,4,23) ->
	#base_constellation_enchantment{equip_type = 4,pos = 4,lv = 23,cost = [{0,38040073,24}],attr = [{2,92000},{4,2760}]};

get_enchantment_cfg(4,4,24) ->
	#base_constellation_enchantment{equip_type = 4,pos = 4,lv = 24,cost = [{0,38040073,25}],attr = [{2,96000},{4,2880}]};

get_enchantment_cfg(4,4,25) ->
	#base_constellation_enchantment{equip_type = 4,pos = 4,lv = 25,cost = [{0,38040073,26}],attr = [{2,100000},{4,3000}]};

get_enchantment_cfg(4,4,26) ->
	#base_constellation_enchantment{equip_type = 4,pos = 4,lv = 26,cost = [{0,38040073,27}],attr = [{2,104000},{4,3120}]};

get_enchantment_cfg(4,4,27) ->
	#base_constellation_enchantment{equip_type = 4,pos = 4,lv = 27,cost = [{0,38040073,28}],attr = [{2,108000},{4,3240}]};

get_enchantment_cfg(4,4,28) ->
	#base_constellation_enchantment{equip_type = 4,pos = 4,lv = 28,cost = [{0,38040073,29}],attr = [{2,112000},{4,3360}]};

get_enchantment_cfg(4,4,29) ->
	#base_constellation_enchantment{equip_type = 4,pos = 4,lv = 29,cost = [{0,38040073,30}],attr = [{2,116000},{4,3480}]};

get_enchantment_cfg(4,4,30) ->
	#base_constellation_enchantment{equip_type = 4,pos = 4,lv = 30,cost = [],attr = [{2,120000},{4,3600}]};

get_enchantment_cfg(4,5,0) ->
	#base_constellation_enchantment{equip_type = 4,pos = 5,lv = 0,cost = [{0,38040073,1}],attr = [{1,0},{3,0}]};

get_enchantment_cfg(4,5,1) ->
	#base_constellation_enchantment{equip_type = 4,pos = 5,lv = 1,cost = [{0,38040073,2}],attr = [{1,200},{3,120}]};

get_enchantment_cfg(4,5,2) ->
	#base_constellation_enchantment{equip_type = 4,pos = 5,lv = 2,cost = [{0,38040073,3}],attr = [{1,400},{3,240}]};

get_enchantment_cfg(4,5,3) ->
	#base_constellation_enchantment{equip_type = 4,pos = 5,lv = 3,cost = [{0,38040073,4}],attr = [{1,600},{3,360}]};

get_enchantment_cfg(4,5,4) ->
	#base_constellation_enchantment{equip_type = 4,pos = 5,lv = 4,cost = [{0,38040073,5}],attr = [{1,800},{3,480}]};

get_enchantment_cfg(4,5,5) ->
	#base_constellation_enchantment{equip_type = 4,pos = 5,lv = 5,cost = [{0,38040073,6}],attr = [{1,1000},{3,600}]};

get_enchantment_cfg(4,5,6) ->
	#base_constellation_enchantment{equip_type = 4,pos = 5,lv = 6,cost = [{0,38040073,7}],attr = [{1,1200},{3,720}]};

get_enchantment_cfg(4,5,7) ->
	#base_constellation_enchantment{equip_type = 4,pos = 5,lv = 7,cost = [{0,38040073,8}],attr = [{1,1400},{3,840}]};

get_enchantment_cfg(4,5,8) ->
	#base_constellation_enchantment{equip_type = 4,pos = 5,lv = 8,cost = [{0,38040073,9}],attr = [{1,1600},{3,960}]};

get_enchantment_cfg(4,5,9) ->
	#base_constellation_enchantment{equip_type = 4,pos = 5,lv = 9,cost = [{0,38040073,10}],attr = [{1,1800},{3,1080}]};

get_enchantment_cfg(4,5,10) ->
	#base_constellation_enchantment{equip_type = 4,pos = 5,lv = 10,cost = [{0,38040073,11}],attr = [{1,2000},{3,1200}]};

get_enchantment_cfg(4,5,11) ->
	#base_constellation_enchantment{equip_type = 4,pos = 5,lv = 11,cost = [{0,38040073,12}],attr = [{1,2200},{3,1320}]};

get_enchantment_cfg(4,5,12) ->
	#base_constellation_enchantment{equip_type = 4,pos = 5,lv = 12,cost = [{0,38040073,13}],attr = [{1,2400},{3,1440}]};

get_enchantment_cfg(4,5,13) ->
	#base_constellation_enchantment{equip_type = 4,pos = 5,lv = 13,cost = [{0,38040073,14}],attr = [{1,2600},{3,1560}]};

get_enchantment_cfg(4,5,14) ->
	#base_constellation_enchantment{equip_type = 4,pos = 5,lv = 14,cost = [{0,38040073,15}],attr = [{1,2800},{3,1680}]};

get_enchantment_cfg(4,5,15) ->
	#base_constellation_enchantment{equip_type = 4,pos = 5,lv = 15,cost = [{0,38040073,16}],attr = [{1,3000},{3,1800}]};

get_enchantment_cfg(4,5,16) ->
	#base_constellation_enchantment{equip_type = 4,pos = 5,lv = 16,cost = [{0,38040073,17}],attr = [{1,3200},{3,1920}]};

get_enchantment_cfg(4,5,17) ->
	#base_constellation_enchantment{equip_type = 4,pos = 5,lv = 17,cost = [{0,38040073,18}],attr = [{1,3400},{3,2040}]};

get_enchantment_cfg(4,5,18) ->
	#base_constellation_enchantment{equip_type = 4,pos = 5,lv = 18,cost = [{0,38040073,19}],attr = [{1,3600},{3,2160}]};

get_enchantment_cfg(4,5,19) ->
	#base_constellation_enchantment{equip_type = 4,pos = 5,lv = 19,cost = [{0,38040073,20}],attr = [{1,3800},{3,2280}]};

get_enchantment_cfg(4,5,20) ->
	#base_constellation_enchantment{equip_type = 4,pos = 5,lv = 20,cost = [{0,38040073,21}],attr = [{1,4000},{3,2400}]};

get_enchantment_cfg(4,5,21) ->
	#base_constellation_enchantment{equip_type = 4,pos = 5,lv = 21,cost = [{0,38040073,22}],attr = [{1,4200},{3,2520}]};

get_enchantment_cfg(4,5,22) ->
	#base_constellation_enchantment{equip_type = 4,pos = 5,lv = 22,cost = [{0,38040073,23}],attr = [{1,4400},{3,2640}]};

get_enchantment_cfg(4,5,23) ->
	#base_constellation_enchantment{equip_type = 4,pos = 5,lv = 23,cost = [{0,38040073,24}],attr = [{1,4600},{3,2760}]};

get_enchantment_cfg(4,5,24) ->
	#base_constellation_enchantment{equip_type = 4,pos = 5,lv = 24,cost = [{0,38040073,25}],attr = [{1,4800},{3,2880}]};

get_enchantment_cfg(4,5,25) ->
	#base_constellation_enchantment{equip_type = 4,pos = 5,lv = 25,cost = [{0,38040073,26}],attr = [{1,5000},{3,3000}]};

get_enchantment_cfg(4,5,26) ->
	#base_constellation_enchantment{equip_type = 4,pos = 5,lv = 26,cost = [{0,38040073,27}],attr = [{1,5200},{3,3120}]};

get_enchantment_cfg(4,5,27) ->
	#base_constellation_enchantment{equip_type = 4,pos = 5,lv = 27,cost = [{0,38040073,28}],attr = [{1,5400},{3,3240}]};

get_enchantment_cfg(4,5,28) ->
	#base_constellation_enchantment{equip_type = 4,pos = 5,lv = 28,cost = [{0,38040073,29}],attr = [{1,5600},{3,3360}]};

get_enchantment_cfg(4,5,29) ->
	#base_constellation_enchantment{equip_type = 4,pos = 5,lv = 29,cost = [{0,38040073,30}],attr = [{1,5800},{3,3480}]};

get_enchantment_cfg(4,5,30) ->
	#base_constellation_enchantment{equip_type = 4,pos = 5,lv = 30,cost = [],attr = [{1,6000},{3,3600}]};

get_enchantment_cfg(4,6,0) ->
	#base_constellation_enchantment{equip_type = 4,pos = 6,lv = 0,cost = [{0,38040073,1}],attr = [{2,0},{4,0}]};

get_enchantment_cfg(4,6,1) ->
	#base_constellation_enchantment{equip_type = 4,pos = 6,lv = 1,cost = [{0,38040073,2}],attr = [{2,4000},{4,120}]};

get_enchantment_cfg(4,6,2) ->
	#base_constellation_enchantment{equip_type = 4,pos = 6,lv = 2,cost = [{0,38040073,3}],attr = [{2,8000},{4,240}]};

get_enchantment_cfg(4,6,3) ->
	#base_constellation_enchantment{equip_type = 4,pos = 6,lv = 3,cost = [{0,38040073,4}],attr = [{2,12000},{4,360}]};

get_enchantment_cfg(4,6,4) ->
	#base_constellation_enchantment{equip_type = 4,pos = 6,lv = 4,cost = [{0,38040073,5}],attr = [{2,16000},{4,480}]};

get_enchantment_cfg(4,6,5) ->
	#base_constellation_enchantment{equip_type = 4,pos = 6,lv = 5,cost = [{0,38040073,6}],attr = [{2,20000},{4,600}]};

get_enchantment_cfg(4,6,6) ->
	#base_constellation_enchantment{equip_type = 4,pos = 6,lv = 6,cost = [{0,38040073,7}],attr = [{2,24000},{4,720}]};

get_enchantment_cfg(4,6,7) ->
	#base_constellation_enchantment{equip_type = 4,pos = 6,lv = 7,cost = [{0,38040073,8}],attr = [{2,28000},{4,840}]};

get_enchantment_cfg(4,6,8) ->
	#base_constellation_enchantment{equip_type = 4,pos = 6,lv = 8,cost = [{0,38040073,9}],attr = [{2,32000},{4,960}]};

get_enchantment_cfg(4,6,9) ->
	#base_constellation_enchantment{equip_type = 4,pos = 6,lv = 9,cost = [{0,38040073,10}],attr = [{2,36000},{4,1080}]};

get_enchantment_cfg(4,6,10) ->
	#base_constellation_enchantment{equip_type = 4,pos = 6,lv = 10,cost = [{0,38040073,11}],attr = [{2,40000},{4,1200}]};

get_enchantment_cfg(4,6,11) ->
	#base_constellation_enchantment{equip_type = 4,pos = 6,lv = 11,cost = [{0,38040073,12}],attr = [{2,44000},{4,1320}]};

get_enchantment_cfg(4,6,12) ->
	#base_constellation_enchantment{equip_type = 4,pos = 6,lv = 12,cost = [{0,38040073,13}],attr = [{2,48000},{4,1440}]};

get_enchantment_cfg(4,6,13) ->
	#base_constellation_enchantment{equip_type = 4,pos = 6,lv = 13,cost = [{0,38040073,14}],attr = [{2,52000},{4,1560}]};

get_enchantment_cfg(4,6,14) ->
	#base_constellation_enchantment{equip_type = 4,pos = 6,lv = 14,cost = [{0,38040073,15}],attr = [{2,56000},{4,1680}]};

get_enchantment_cfg(4,6,15) ->
	#base_constellation_enchantment{equip_type = 4,pos = 6,lv = 15,cost = [{0,38040073,16}],attr = [{2,60000},{4,1800}]};

get_enchantment_cfg(4,6,16) ->
	#base_constellation_enchantment{equip_type = 4,pos = 6,lv = 16,cost = [{0,38040073,17}],attr = [{2,64000},{4,1920}]};

get_enchantment_cfg(4,6,17) ->
	#base_constellation_enchantment{equip_type = 4,pos = 6,lv = 17,cost = [{0,38040073,18}],attr = [{2,68000},{4,2040}]};

get_enchantment_cfg(4,6,18) ->
	#base_constellation_enchantment{equip_type = 4,pos = 6,lv = 18,cost = [{0,38040073,19}],attr = [{2,72000},{4,2160}]};

get_enchantment_cfg(4,6,19) ->
	#base_constellation_enchantment{equip_type = 4,pos = 6,lv = 19,cost = [{0,38040073,20}],attr = [{2,76000},{4,2280}]};

get_enchantment_cfg(4,6,20) ->
	#base_constellation_enchantment{equip_type = 4,pos = 6,lv = 20,cost = [{0,38040073,21}],attr = [{2,80000},{4,2400}]};

get_enchantment_cfg(4,6,21) ->
	#base_constellation_enchantment{equip_type = 4,pos = 6,lv = 21,cost = [{0,38040073,22}],attr = [{2,84000},{4,2520}]};

get_enchantment_cfg(4,6,22) ->
	#base_constellation_enchantment{equip_type = 4,pos = 6,lv = 22,cost = [{0,38040073,23}],attr = [{2,88000},{4,2640}]};

get_enchantment_cfg(4,6,23) ->
	#base_constellation_enchantment{equip_type = 4,pos = 6,lv = 23,cost = [{0,38040073,24}],attr = [{2,92000},{4,2760}]};

get_enchantment_cfg(4,6,24) ->
	#base_constellation_enchantment{equip_type = 4,pos = 6,lv = 24,cost = [{0,38040073,25}],attr = [{2,96000},{4,2880}]};

get_enchantment_cfg(4,6,25) ->
	#base_constellation_enchantment{equip_type = 4,pos = 6,lv = 25,cost = [{0,38040073,26}],attr = [{2,100000},{4,3000}]};

get_enchantment_cfg(4,6,26) ->
	#base_constellation_enchantment{equip_type = 4,pos = 6,lv = 26,cost = [{0,38040073,27}],attr = [{2,104000},{4,3120}]};

get_enchantment_cfg(4,6,27) ->
	#base_constellation_enchantment{equip_type = 4,pos = 6,lv = 27,cost = [{0,38040073,28}],attr = [{2,108000},{4,3240}]};

get_enchantment_cfg(4,6,28) ->
	#base_constellation_enchantment{equip_type = 4,pos = 6,lv = 28,cost = [{0,38040073,29}],attr = [{2,112000},{4,3360}]};

get_enchantment_cfg(4,6,29) ->
	#base_constellation_enchantment{equip_type = 4,pos = 6,lv = 29,cost = [{0,38040073,30}],attr = [{2,116000},{4,3480}]};

get_enchantment_cfg(4,6,30) ->
	#base_constellation_enchantment{equip_type = 4,pos = 6,lv = 30,cost = [],attr = [{2,120000},{4,3600}]};

get_enchantment_cfg(5,1,0) ->
	#base_constellation_enchantment{equip_type = 5,pos = 1,lv = 0,cost = [{0,38040073,1}],attr = [{1,0},{3,0}]};

get_enchantment_cfg(5,1,1) ->
	#base_constellation_enchantment{equip_type = 5,pos = 1,lv = 1,cost = [{0,38040073,2}],attr = [{1,240},{3,144}]};

get_enchantment_cfg(5,1,2) ->
	#base_constellation_enchantment{equip_type = 5,pos = 1,lv = 2,cost = [{0,38040073,3}],attr = [{1,480},{3,288}]};

get_enchantment_cfg(5,1,3) ->
	#base_constellation_enchantment{equip_type = 5,pos = 1,lv = 3,cost = [{0,38040073,4}],attr = [{1,720},{3,432}]};

get_enchantment_cfg(5,1,4) ->
	#base_constellation_enchantment{equip_type = 5,pos = 1,lv = 4,cost = [{0,38040073,5}],attr = [{1,960},{3,576}]};

get_enchantment_cfg(5,1,5) ->
	#base_constellation_enchantment{equip_type = 5,pos = 1,lv = 5,cost = [{0,38040073,6}],attr = [{1,1200},{3,720}]};

get_enchantment_cfg(5,1,6) ->
	#base_constellation_enchantment{equip_type = 5,pos = 1,lv = 6,cost = [{0,38040073,7}],attr = [{1,1440},{3,864}]};

get_enchantment_cfg(5,1,7) ->
	#base_constellation_enchantment{equip_type = 5,pos = 1,lv = 7,cost = [{0,38040073,8}],attr = [{1,1680},{3,1008}]};

get_enchantment_cfg(5,1,8) ->
	#base_constellation_enchantment{equip_type = 5,pos = 1,lv = 8,cost = [{0,38040073,9}],attr = [{1,1920},{3,1152}]};

get_enchantment_cfg(5,1,9) ->
	#base_constellation_enchantment{equip_type = 5,pos = 1,lv = 9,cost = [{0,38040073,10}],attr = [{1,2160},{3,1296}]};

get_enchantment_cfg(5,1,10) ->
	#base_constellation_enchantment{equip_type = 5,pos = 1,lv = 10,cost = [{0,38040073,11}],attr = [{1,2400},{3,1440}]};

get_enchantment_cfg(5,1,11) ->
	#base_constellation_enchantment{equip_type = 5,pos = 1,lv = 11,cost = [{0,38040073,12}],attr = [{1,2640},{3,1584}]};

get_enchantment_cfg(5,1,12) ->
	#base_constellation_enchantment{equip_type = 5,pos = 1,lv = 12,cost = [{0,38040073,13}],attr = [{1,2880},{3,1728}]};

get_enchantment_cfg(5,1,13) ->
	#base_constellation_enchantment{equip_type = 5,pos = 1,lv = 13,cost = [{0,38040073,14}],attr = [{1,3120},{3,1872}]};

get_enchantment_cfg(5,1,14) ->
	#base_constellation_enchantment{equip_type = 5,pos = 1,lv = 14,cost = [{0,38040073,15}],attr = [{1,3360},{3,2016}]};

get_enchantment_cfg(5,1,15) ->
	#base_constellation_enchantment{equip_type = 5,pos = 1,lv = 15,cost = [{0,38040073,16}],attr = [{1,3600},{3,2160}]};

get_enchantment_cfg(5,1,16) ->
	#base_constellation_enchantment{equip_type = 5,pos = 1,lv = 16,cost = [{0,38040073,17}],attr = [{1,3840},{3,2304}]};

get_enchantment_cfg(5,1,17) ->
	#base_constellation_enchantment{equip_type = 5,pos = 1,lv = 17,cost = [{0,38040073,18}],attr = [{1,4080},{3,2448}]};

get_enchantment_cfg(5,1,18) ->
	#base_constellation_enchantment{equip_type = 5,pos = 1,lv = 18,cost = [{0,38040073,19}],attr = [{1,4320},{3,2592}]};

get_enchantment_cfg(5,1,19) ->
	#base_constellation_enchantment{equip_type = 5,pos = 1,lv = 19,cost = [{0,38040073,20}],attr = [{1,4560},{3,2736}]};

get_enchantment_cfg(5,1,20) ->
	#base_constellation_enchantment{equip_type = 5,pos = 1,lv = 20,cost = [{0,38040073,21}],attr = [{1,4800},{3,2880}]};

get_enchantment_cfg(5,1,21) ->
	#base_constellation_enchantment{equip_type = 5,pos = 1,lv = 21,cost = [{0,38040073,22}],attr = [{1,5040},{3,3024}]};

get_enchantment_cfg(5,1,22) ->
	#base_constellation_enchantment{equip_type = 5,pos = 1,lv = 22,cost = [{0,38040073,23}],attr = [{1,5280},{3,3168}]};

get_enchantment_cfg(5,1,23) ->
	#base_constellation_enchantment{equip_type = 5,pos = 1,lv = 23,cost = [{0,38040073,24}],attr = [{1,5520},{3,3312}]};

get_enchantment_cfg(5,1,24) ->
	#base_constellation_enchantment{equip_type = 5,pos = 1,lv = 24,cost = [{0,38040073,25}],attr = [{1,5760},{3,3456}]};

get_enchantment_cfg(5,1,25) ->
	#base_constellation_enchantment{equip_type = 5,pos = 1,lv = 25,cost = [{0,38040073,26}],attr = [{1,6000},{3,3600}]};

get_enchantment_cfg(5,1,26) ->
	#base_constellation_enchantment{equip_type = 5,pos = 1,lv = 26,cost = [{0,38040073,27}],attr = [{1,6240},{3,3744}]};

get_enchantment_cfg(5,1,27) ->
	#base_constellation_enchantment{equip_type = 5,pos = 1,lv = 27,cost = [{0,38040073,28}],attr = [{1,6480},{3,3888}]};

get_enchantment_cfg(5,1,28) ->
	#base_constellation_enchantment{equip_type = 5,pos = 1,lv = 28,cost = [{0,38040073,29}],attr = [{1,6720},{3,4032}]};

get_enchantment_cfg(5,1,29) ->
	#base_constellation_enchantment{equip_type = 5,pos = 1,lv = 29,cost = [{0,38040073,30}],attr = [{1,6960},{3,4176}]};

get_enchantment_cfg(5,1,30) ->
	#base_constellation_enchantment{equip_type = 5,pos = 1,lv = 30,cost = [],attr = [{1,7200},{3,4320}]};

get_enchantment_cfg(5,2,0) ->
	#base_constellation_enchantment{equip_type = 5,pos = 2,lv = 0,cost = [{0,38040073,1}],attr = [{2,0},{4,0}]};

get_enchantment_cfg(5,2,1) ->
	#base_constellation_enchantment{equip_type = 5,pos = 2,lv = 1,cost = [{0,38040073,2}],attr = [{2,4800},{4,144}]};

get_enchantment_cfg(5,2,2) ->
	#base_constellation_enchantment{equip_type = 5,pos = 2,lv = 2,cost = [{0,38040073,3}],attr = [{2,9600},{4,288}]};

get_enchantment_cfg(5,2,3) ->
	#base_constellation_enchantment{equip_type = 5,pos = 2,lv = 3,cost = [{0,38040073,4}],attr = [{2,14400},{4,432}]};

get_enchantment_cfg(5,2,4) ->
	#base_constellation_enchantment{equip_type = 5,pos = 2,lv = 4,cost = [{0,38040073,5}],attr = [{2,19200},{4,576}]};

get_enchantment_cfg(5,2,5) ->
	#base_constellation_enchantment{equip_type = 5,pos = 2,lv = 5,cost = [{0,38040073,6}],attr = [{2,24000},{4,720}]};

get_enchantment_cfg(5,2,6) ->
	#base_constellation_enchantment{equip_type = 5,pos = 2,lv = 6,cost = [{0,38040073,7}],attr = [{2,28800},{4,864}]};

get_enchantment_cfg(5,2,7) ->
	#base_constellation_enchantment{equip_type = 5,pos = 2,lv = 7,cost = [{0,38040073,8}],attr = [{2,33600},{4,1008}]};

get_enchantment_cfg(5,2,8) ->
	#base_constellation_enchantment{equip_type = 5,pos = 2,lv = 8,cost = [{0,38040073,9}],attr = [{2,38400},{4,1152}]};

get_enchantment_cfg(5,2,9) ->
	#base_constellation_enchantment{equip_type = 5,pos = 2,lv = 9,cost = [{0,38040073,10}],attr = [{2,43200},{4,1296}]};

get_enchantment_cfg(5,2,10) ->
	#base_constellation_enchantment{equip_type = 5,pos = 2,lv = 10,cost = [{0,38040073,11}],attr = [{2,48000},{4,1440}]};

get_enchantment_cfg(5,2,11) ->
	#base_constellation_enchantment{equip_type = 5,pos = 2,lv = 11,cost = [{0,38040073,12}],attr = [{2,52800},{4,1584}]};

get_enchantment_cfg(5,2,12) ->
	#base_constellation_enchantment{equip_type = 5,pos = 2,lv = 12,cost = [{0,38040073,13}],attr = [{2,57600},{4,1728}]};

get_enchantment_cfg(5,2,13) ->
	#base_constellation_enchantment{equip_type = 5,pos = 2,lv = 13,cost = [{0,38040073,14}],attr = [{2,62400},{4,1872}]};

get_enchantment_cfg(5,2,14) ->
	#base_constellation_enchantment{equip_type = 5,pos = 2,lv = 14,cost = [{0,38040073,15}],attr = [{2,67200},{4,2016}]};

get_enchantment_cfg(5,2,15) ->
	#base_constellation_enchantment{equip_type = 5,pos = 2,lv = 15,cost = [{0,38040073,16}],attr = [{2,72000},{4,2160}]};

get_enchantment_cfg(5,2,16) ->
	#base_constellation_enchantment{equip_type = 5,pos = 2,lv = 16,cost = [{0,38040073,17}],attr = [{2,76800},{4,2304}]};

get_enchantment_cfg(5,2,17) ->
	#base_constellation_enchantment{equip_type = 5,pos = 2,lv = 17,cost = [{0,38040073,18}],attr = [{2,81600},{4,2448}]};

get_enchantment_cfg(5,2,18) ->
	#base_constellation_enchantment{equip_type = 5,pos = 2,lv = 18,cost = [{0,38040073,19}],attr = [{2,86400},{4,2592}]};

get_enchantment_cfg(5,2,19) ->
	#base_constellation_enchantment{equip_type = 5,pos = 2,lv = 19,cost = [{0,38040073,20}],attr = [{2,91200},{4,2736}]};

get_enchantment_cfg(5,2,20) ->
	#base_constellation_enchantment{equip_type = 5,pos = 2,lv = 20,cost = [{0,38040073,21}],attr = [{2,96000},{4,2880}]};

get_enchantment_cfg(5,2,21) ->
	#base_constellation_enchantment{equip_type = 5,pos = 2,lv = 21,cost = [{0,38040073,22}],attr = [{2,100800},{4,3024}]};

get_enchantment_cfg(5,2,22) ->
	#base_constellation_enchantment{equip_type = 5,pos = 2,lv = 22,cost = [{0,38040073,23}],attr = [{2,105600},{4,3168}]};

get_enchantment_cfg(5,2,23) ->
	#base_constellation_enchantment{equip_type = 5,pos = 2,lv = 23,cost = [{0,38040073,24}],attr = [{2,110400},{4,3312}]};

get_enchantment_cfg(5,2,24) ->
	#base_constellation_enchantment{equip_type = 5,pos = 2,lv = 24,cost = [{0,38040073,25}],attr = [{2,115200},{4,3456}]};

get_enchantment_cfg(5,2,25) ->
	#base_constellation_enchantment{equip_type = 5,pos = 2,lv = 25,cost = [{0,38040073,26}],attr = [{2,120000},{4,3600}]};

get_enchantment_cfg(5,2,26) ->
	#base_constellation_enchantment{equip_type = 5,pos = 2,lv = 26,cost = [{0,38040073,27}],attr = [{2,124800},{4,3744}]};

get_enchantment_cfg(5,2,27) ->
	#base_constellation_enchantment{equip_type = 5,pos = 2,lv = 27,cost = [{0,38040073,28}],attr = [{2,129600},{4,3888}]};

get_enchantment_cfg(5,2,28) ->
	#base_constellation_enchantment{equip_type = 5,pos = 2,lv = 28,cost = [{0,38040073,29}],attr = [{2,134400},{4,4032}]};

get_enchantment_cfg(5,2,29) ->
	#base_constellation_enchantment{equip_type = 5,pos = 2,lv = 29,cost = [{0,38040073,30}],attr = [{2,139200},{4,4176}]};

get_enchantment_cfg(5,2,30) ->
	#base_constellation_enchantment{equip_type = 5,pos = 2,lv = 30,cost = [],attr = [{2,144000},{4,4320}]};

get_enchantment_cfg(5,3,0) ->
	#base_constellation_enchantment{equip_type = 5,pos = 3,lv = 0,cost = [{0,38040073,1}],attr = [{2,0},{4,0}]};

get_enchantment_cfg(5,3,1) ->
	#base_constellation_enchantment{equip_type = 5,pos = 3,lv = 1,cost = [{0,38040073,2}],attr = [{2,4800},{4,144}]};

get_enchantment_cfg(5,3,2) ->
	#base_constellation_enchantment{equip_type = 5,pos = 3,lv = 2,cost = [{0,38040073,3}],attr = [{2,9600},{4,288}]};

get_enchantment_cfg(5,3,3) ->
	#base_constellation_enchantment{equip_type = 5,pos = 3,lv = 3,cost = [{0,38040073,4}],attr = [{2,14400},{4,432}]};

get_enchantment_cfg(5,3,4) ->
	#base_constellation_enchantment{equip_type = 5,pos = 3,lv = 4,cost = [{0,38040073,5}],attr = [{2,19200},{4,576}]};

get_enchantment_cfg(5,3,5) ->
	#base_constellation_enchantment{equip_type = 5,pos = 3,lv = 5,cost = [{0,38040073,6}],attr = [{2,24000},{4,720}]};

get_enchantment_cfg(5,3,6) ->
	#base_constellation_enchantment{equip_type = 5,pos = 3,lv = 6,cost = [{0,38040073,7}],attr = [{2,28800},{4,864}]};

get_enchantment_cfg(5,3,7) ->
	#base_constellation_enchantment{equip_type = 5,pos = 3,lv = 7,cost = [{0,38040073,8}],attr = [{2,33600},{4,1008}]};

get_enchantment_cfg(5,3,8) ->
	#base_constellation_enchantment{equip_type = 5,pos = 3,lv = 8,cost = [{0,38040073,9}],attr = [{2,38400},{4,1152}]};

get_enchantment_cfg(5,3,9) ->
	#base_constellation_enchantment{equip_type = 5,pos = 3,lv = 9,cost = [{0,38040073,10}],attr = [{2,43200},{4,1296}]};

get_enchantment_cfg(5,3,10) ->
	#base_constellation_enchantment{equip_type = 5,pos = 3,lv = 10,cost = [{0,38040073,11}],attr = [{2,48000},{4,1440}]};

get_enchantment_cfg(5,3,11) ->
	#base_constellation_enchantment{equip_type = 5,pos = 3,lv = 11,cost = [{0,38040073,12}],attr = [{2,52800},{4,1584}]};

get_enchantment_cfg(5,3,12) ->
	#base_constellation_enchantment{equip_type = 5,pos = 3,lv = 12,cost = [{0,38040073,13}],attr = [{2,57600},{4,1728}]};

get_enchantment_cfg(5,3,13) ->
	#base_constellation_enchantment{equip_type = 5,pos = 3,lv = 13,cost = [{0,38040073,14}],attr = [{2,62400},{4,1872}]};

get_enchantment_cfg(5,3,14) ->
	#base_constellation_enchantment{equip_type = 5,pos = 3,lv = 14,cost = [{0,38040073,15}],attr = [{2,67200},{4,2016}]};

get_enchantment_cfg(5,3,15) ->
	#base_constellation_enchantment{equip_type = 5,pos = 3,lv = 15,cost = [{0,38040073,16}],attr = [{2,72000},{4,2160}]};

get_enchantment_cfg(5,3,16) ->
	#base_constellation_enchantment{equip_type = 5,pos = 3,lv = 16,cost = [{0,38040073,17}],attr = [{2,76800},{4,2304}]};

get_enchantment_cfg(5,3,17) ->
	#base_constellation_enchantment{equip_type = 5,pos = 3,lv = 17,cost = [{0,38040073,18}],attr = [{2,81600},{4,2448}]};

get_enchantment_cfg(5,3,18) ->
	#base_constellation_enchantment{equip_type = 5,pos = 3,lv = 18,cost = [{0,38040073,19}],attr = [{2,86400},{4,2592}]};

get_enchantment_cfg(5,3,19) ->
	#base_constellation_enchantment{equip_type = 5,pos = 3,lv = 19,cost = [{0,38040073,20}],attr = [{2,91200},{4,2736}]};

get_enchantment_cfg(5,3,20) ->
	#base_constellation_enchantment{equip_type = 5,pos = 3,lv = 20,cost = [{0,38040073,21}],attr = [{2,96000},{4,2880}]};

get_enchantment_cfg(5,3,21) ->
	#base_constellation_enchantment{equip_type = 5,pos = 3,lv = 21,cost = [{0,38040073,22}],attr = [{2,100800},{4,3024}]};

get_enchantment_cfg(5,3,22) ->
	#base_constellation_enchantment{equip_type = 5,pos = 3,lv = 22,cost = [{0,38040073,23}],attr = [{2,105600},{4,3168}]};

get_enchantment_cfg(5,3,23) ->
	#base_constellation_enchantment{equip_type = 5,pos = 3,lv = 23,cost = [{0,38040073,24}],attr = [{2,110400},{4,3312}]};

get_enchantment_cfg(5,3,24) ->
	#base_constellation_enchantment{equip_type = 5,pos = 3,lv = 24,cost = [{0,38040073,25}],attr = [{2,115200},{4,3456}]};

get_enchantment_cfg(5,3,25) ->
	#base_constellation_enchantment{equip_type = 5,pos = 3,lv = 25,cost = [{0,38040073,26}],attr = [{2,120000},{4,3600}]};

get_enchantment_cfg(5,3,26) ->
	#base_constellation_enchantment{equip_type = 5,pos = 3,lv = 26,cost = [{0,38040073,27}],attr = [{2,124800},{4,3744}]};

get_enchantment_cfg(5,3,27) ->
	#base_constellation_enchantment{equip_type = 5,pos = 3,lv = 27,cost = [{0,38040073,28}],attr = [{2,129600},{4,3888}]};

get_enchantment_cfg(5,3,28) ->
	#base_constellation_enchantment{equip_type = 5,pos = 3,lv = 28,cost = [{0,38040073,29}],attr = [{2,134400},{4,4032}]};

get_enchantment_cfg(5,3,29) ->
	#base_constellation_enchantment{equip_type = 5,pos = 3,lv = 29,cost = [{0,38040073,30}],attr = [{2,139200},{4,4176}]};

get_enchantment_cfg(5,3,30) ->
	#base_constellation_enchantment{equip_type = 5,pos = 3,lv = 30,cost = [],attr = [{2,144000},{4,4320}]};

get_enchantment_cfg(5,4,0) ->
	#base_constellation_enchantment{equip_type = 5,pos = 4,lv = 0,cost = [{0,38040073,1}],attr = [{2,0},{4,0}]};

get_enchantment_cfg(5,4,1) ->
	#base_constellation_enchantment{equip_type = 5,pos = 4,lv = 1,cost = [{0,38040073,2}],attr = [{2,4800},{4,144}]};

get_enchantment_cfg(5,4,2) ->
	#base_constellation_enchantment{equip_type = 5,pos = 4,lv = 2,cost = [{0,38040073,3}],attr = [{2,9600},{4,288}]};

get_enchantment_cfg(5,4,3) ->
	#base_constellation_enchantment{equip_type = 5,pos = 4,lv = 3,cost = [{0,38040073,4}],attr = [{2,14400},{4,432}]};

get_enchantment_cfg(5,4,4) ->
	#base_constellation_enchantment{equip_type = 5,pos = 4,lv = 4,cost = [{0,38040073,5}],attr = [{2,19200},{4,576}]};

get_enchantment_cfg(5,4,5) ->
	#base_constellation_enchantment{equip_type = 5,pos = 4,lv = 5,cost = [{0,38040073,6}],attr = [{2,24000},{4,720}]};

get_enchantment_cfg(5,4,6) ->
	#base_constellation_enchantment{equip_type = 5,pos = 4,lv = 6,cost = [{0,38040073,7}],attr = [{2,28800},{4,864}]};

get_enchantment_cfg(5,4,7) ->
	#base_constellation_enchantment{equip_type = 5,pos = 4,lv = 7,cost = [{0,38040073,8}],attr = [{2,33600},{4,1008}]};

get_enchantment_cfg(5,4,8) ->
	#base_constellation_enchantment{equip_type = 5,pos = 4,lv = 8,cost = [{0,38040073,9}],attr = [{2,38400},{4,1152}]};

get_enchantment_cfg(5,4,9) ->
	#base_constellation_enchantment{equip_type = 5,pos = 4,lv = 9,cost = [{0,38040073,10}],attr = [{2,43200},{4,1296}]};

get_enchantment_cfg(5,4,10) ->
	#base_constellation_enchantment{equip_type = 5,pos = 4,lv = 10,cost = [{0,38040073,11}],attr = [{2,48000},{4,1440}]};

get_enchantment_cfg(5,4,11) ->
	#base_constellation_enchantment{equip_type = 5,pos = 4,lv = 11,cost = [{0,38040073,12}],attr = [{2,52800},{4,1584}]};

get_enchantment_cfg(5,4,12) ->
	#base_constellation_enchantment{equip_type = 5,pos = 4,lv = 12,cost = [{0,38040073,13}],attr = [{2,57600},{4,1728}]};

get_enchantment_cfg(5,4,13) ->
	#base_constellation_enchantment{equip_type = 5,pos = 4,lv = 13,cost = [{0,38040073,14}],attr = [{2,62400},{4,1872}]};

get_enchantment_cfg(5,4,14) ->
	#base_constellation_enchantment{equip_type = 5,pos = 4,lv = 14,cost = [{0,38040073,15}],attr = [{2,67200},{4,2016}]};

get_enchantment_cfg(5,4,15) ->
	#base_constellation_enchantment{equip_type = 5,pos = 4,lv = 15,cost = [{0,38040073,16}],attr = [{2,72000},{4,2160}]};

get_enchantment_cfg(5,4,16) ->
	#base_constellation_enchantment{equip_type = 5,pos = 4,lv = 16,cost = [{0,38040073,17}],attr = [{2,76800},{4,2304}]};

get_enchantment_cfg(5,4,17) ->
	#base_constellation_enchantment{equip_type = 5,pos = 4,lv = 17,cost = [{0,38040073,18}],attr = [{2,81600},{4,2448}]};

get_enchantment_cfg(5,4,18) ->
	#base_constellation_enchantment{equip_type = 5,pos = 4,lv = 18,cost = [{0,38040073,19}],attr = [{2,86400},{4,2592}]};

get_enchantment_cfg(5,4,19) ->
	#base_constellation_enchantment{equip_type = 5,pos = 4,lv = 19,cost = [{0,38040073,20}],attr = [{2,91200},{4,2736}]};

get_enchantment_cfg(5,4,20) ->
	#base_constellation_enchantment{equip_type = 5,pos = 4,lv = 20,cost = [{0,38040073,21}],attr = [{2,96000},{4,2880}]};

get_enchantment_cfg(5,4,21) ->
	#base_constellation_enchantment{equip_type = 5,pos = 4,lv = 21,cost = [{0,38040073,22}],attr = [{2,100800},{4,3024}]};

get_enchantment_cfg(5,4,22) ->
	#base_constellation_enchantment{equip_type = 5,pos = 4,lv = 22,cost = [{0,38040073,23}],attr = [{2,105600},{4,3168}]};

get_enchantment_cfg(5,4,23) ->
	#base_constellation_enchantment{equip_type = 5,pos = 4,lv = 23,cost = [{0,38040073,24}],attr = [{2,110400},{4,3312}]};

get_enchantment_cfg(5,4,24) ->
	#base_constellation_enchantment{equip_type = 5,pos = 4,lv = 24,cost = [{0,38040073,25}],attr = [{2,115200},{4,3456}]};

get_enchantment_cfg(5,4,25) ->
	#base_constellation_enchantment{equip_type = 5,pos = 4,lv = 25,cost = [{0,38040073,26}],attr = [{2,120000},{4,3600}]};

get_enchantment_cfg(5,4,26) ->
	#base_constellation_enchantment{equip_type = 5,pos = 4,lv = 26,cost = [{0,38040073,27}],attr = [{2,124800},{4,3744}]};

get_enchantment_cfg(5,4,27) ->
	#base_constellation_enchantment{equip_type = 5,pos = 4,lv = 27,cost = [{0,38040073,28}],attr = [{2,129600},{4,3888}]};

get_enchantment_cfg(5,4,28) ->
	#base_constellation_enchantment{equip_type = 5,pos = 4,lv = 28,cost = [{0,38040073,29}],attr = [{2,134400},{4,4032}]};

get_enchantment_cfg(5,4,29) ->
	#base_constellation_enchantment{equip_type = 5,pos = 4,lv = 29,cost = [{0,38040073,30}],attr = [{2,139200},{4,4176}]};

get_enchantment_cfg(5,4,30) ->
	#base_constellation_enchantment{equip_type = 5,pos = 4,lv = 30,cost = [],attr = [{2,144000},{4,4320}]};

get_enchantment_cfg(5,5,0) ->
	#base_constellation_enchantment{equip_type = 5,pos = 5,lv = 0,cost = [{0,38040073,1}],attr = [{1,0},{3,0}]};

get_enchantment_cfg(5,5,1) ->
	#base_constellation_enchantment{equip_type = 5,pos = 5,lv = 1,cost = [{0,38040073,2}],attr = [{1,240},{3,144}]};

get_enchantment_cfg(5,5,2) ->
	#base_constellation_enchantment{equip_type = 5,pos = 5,lv = 2,cost = [{0,38040073,3}],attr = [{1,480},{3,288}]};

get_enchantment_cfg(5,5,3) ->
	#base_constellation_enchantment{equip_type = 5,pos = 5,lv = 3,cost = [{0,38040073,4}],attr = [{1,720},{3,432}]};

get_enchantment_cfg(5,5,4) ->
	#base_constellation_enchantment{equip_type = 5,pos = 5,lv = 4,cost = [{0,38040073,5}],attr = [{1,960},{3,576}]};

get_enchantment_cfg(5,5,5) ->
	#base_constellation_enchantment{equip_type = 5,pos = 5,lv = 5,cost = [{0,38040073,6}],attr = [{1,1200},{3,720}]};

get_enchantment_cfg(5,5,6) ->
	#base_constellation_enchantment{equip_type = 5,pos = 5,lv = 6,cost = [{0,38040073,7}],attr = [{1,1440},{3,864}]};

get_enchantment_cfg(5,5,7) ->
	#base_constellation_enchantment{equip_type = 5,pos = 5,lv = 7,cost = [{0,38040073,8}],attr = [{1,1680},{3,1008}]};

get_enchantment_cfg(5,5,8) ->
	#base_constellation_enchantment{equip_type = 5,pos = 5,lv = 8,cost = [{0,38040073,9}],attr = [{1,1920},{3,1152}]};

get_enchantment_cfg(5,5,9) ->
	#base_constellation_enchantment{equip_type = 5,pos = 5,lv = 9,cost = [{0,38040073,10}],attr = [{1,2160},{3,1296}]};

get_enchantment_cfg(5,5,10) ->
	#base_constellation_enchantment{equip_type = 5,pos = 5,lv = 10,cost = [{0,38040073,11}],attr = [{1,2400},{3,1440}]};

get_enchantment_cfg(5,5,11) ->
	#base_constellation_enchantment{equip_type = 5,pos = 5,lv = 11,cost = [{0,38040073,12}],attr = [{1,2640},{3,1584}]};

get_enchantment_cfg(5,5,12) ->
	#base_constellation_enchantment{equip_type = 5,pos = 5,lv = 12,cost = [{0,38040073,13}],attr = [{1,2880},{3,1728}]};

get_enchantment_cfg(5,5,13) ->
	#base_constellation_enchantment{equip_type = 5,pos = 5,lv = 13,cost = [{0,38040073,14}],attr = [{1,3120},{3,1872}]};

get_enchantment_cfg(5,5,14) ->
	#base_constellation_enchantment{equip_type = 5,pos = 5,lv = 14,cost = [{0,38040073,15}],attr = [{1,3360},{3,2016}]};

get_enchantment_cfg(5,5,15) ->
	#base_constellation_enchantment{equip_type = 5,pos = 5,lv = 15,cost = [{0,38040073,16}],attr = [{1,3600},{3,2160}]};

get_enchantment_cfg(5,5,16) ->
	#base_constellation_enchantment{equip_type = 5,pos = 5,lv = 16,cost = [{0,38040073,17}],attr = [{1,3840},{3,2304}]};

get_enchantment_cfg(5,5,17) ->
	#base_constellation_enchantment{equip_type = 5,pos = 5,lv = 17,cost = [{0,38040073,18}],attr = [{1,4080},{3,2448}]};

get_enchantment_cfg(5,5,18) ->
	#base_constellation_enchantment{equip_type = 5,pos = 5,lv = 18,cost = [{0,38040073,19}],attr = [{1,4320},{3,2592}]};

get_enchantment_cfg(5,5,19) ->
	#base_constellation_enchantment{equip_type = 5,pos = 5,lv = 19,cost = [{0,38040073,20}],attr = [{1,4560},{3,2736}]};

get_enchantment_cfg(5,5,20) ->
	#base_constellation_enchantment{equip_type = 5,pos = 5,lv = 20,cost = [{0,38040073,21}],attr = [{1,4800},{3,2880}]};

get_enchantment_cfg(5,5,21) ->
	#base_constellation_enchantment{equip_type = 5,pos = 5,lv = 21,cost = [{0,38040073,22}],attr = [{1,5040},{3,3024}]};

get_enchantment_cfg(5,5,22) ->
	#base_constellation_enchantment{equip_type = 5,pos = 5,lv = 22,cost = [{0,38040073,23}],attr = [{1,5280},{3,3168}]};

get_enchantment_cfg(5,5,23) ->
	#base_constellation_enchantment{equip_type = 5,pos = 5,lv = 23,cost = [{0,38040073,24}],attr = [{1,5520},{3,3312}]};

get_enchantment_cfg(5,5,24) ->
	#base_constellation_enchantment{equip_type = 5,pos = 5,lv = 24,cost = [{0,38040073,25}],attr = [{1,5760},{3,3456}]};

get_enchantment_cfg(5,5,25) ->
	#base_constellation_enchantment{equip_type = 5,pos = 5,lv = 25,cost = [{0,38040073,26}],attr = [{1,6000},{3,3600}]};

get_enchantment_cfg(5,5,26) ->
	#base_constellation_enchantment{equip_type = 5,pos = 5,lv = 26,cost = [{0,38040073,27}],attr = [{1,6240},{3,3744}]};

get_enchantment_cfg(5,5,27) ->
	#base_constellation_enchantment{equip_type = 5,pos = 5,lv = 27,cost = [{0,38040073,28}],attr = [{1,6480},{3,3888}]};

get_enchantment_cfg(5,5,28) ->
	#base_constellation_enchantment{equip_type = 5,pos = 5,lv = 28,cost = [{0,38040073,29}],attr = [{1,6720},{3,4032}]};

get_enchantment_cfg(5,5,29) ->
	#base_constellation_enchantment{equip_type = 5,pos = 5,lv = 29,cost = [{0,38040073,30}],attr = [{1,6960},{3,4176}]};

get_enchantment_cfg(5,5,30) ->
	#base_constellation_enchantment{equip_type = 5,pos = 5,lv = 30,cost = [],attr = [{1,7200},{3,4320}]};

get_enchantment_cfg(5,6,0) ->
	#base_constellation_enchantment{equip_type = 5,pos = 6,lv = 0,cost = [{0,38040073,1}],attr = [{2,0},{4,0}]};

get_enchantment_cfg(5,6,1) ->
	#base_constellation_enchantment{equip_type = 5,pos = 6,lv = 1,cost = [{0,38040073,2}],attr = [{2,4800},{4,144}]};

get_enchantment_cfg(5,6,2) ->
	#base_constellation_enchantment{equip_type = 5,pos = 6,lv = 2,cost = [{0,38040073,3}],attr = [{2,9600},{4,288}]};

get_enchantment_cfg(5,6,3) ->
	#base_constellation_enchantment{equip_type = 5,pos = 6,lv = 3,cost = [{0,38040073,4}],attr = [{2,14400},{4,432}]};

get_enchantment_cfg(5,6,4) ->
	#base_constellation_enchantment{equip_type = 5,pos = 6,lv = 4,cost = [{0,38040073,5}],attr = [{2,19200},{4,576}]};

get_enchantment_cfg(5,6,5) ->
	#base_constellation_enchantment{equip_type = 5,pos = 6,lv = 5,cost = [{0,38040073,6}],attr = [{2,24000},{4,720}]};

get_enchantment_cfg(5,6,6) ->
	#base_constellation_enchantment{equip_type = 5,pos = 6,lv = 6,cost = [{0,38040073,7}],attr = [{2,28800},{4,864}]};

get_enchantment_cfg(5,6,7) ->
	#base_constellation_enchantment{equip_type = 5,pos = 6,lv = 7,cost = [{0,38040073,8}],attr = [{2,33600},{4,1008}]};

get_enchantment_cfg(5,6,8) ->
	#base_constellation_enchantment{equip_type = 5,pos = 6,lv = 8,cost = [{0,38040073,9}],attr = [{2,38400},{4,1152}]};

get_enchantment_cfg(5,6,9) ->
	#base_constellation_enchantment{equip_type = 5,pos = 6,lv = 9,cost = [{0,38040073,10}],attr = [{2,43200},{4,1296}]};

get_enchantment_cfg(5,6,10) ->
	#base_constellation_enchantment{equip_type = 5,pos = 6,lv = 10,cost = [{0,38040073,11}],attr = [{2,48000},{4,1440}]};

get_enchantment_cfg(5,6,11) ->
	#base_constellation_enchantment{equip_type = 5,pos = 6,lv = 11,cost = [{0,38040073,12}],attr = [{2,52800},{4,1584}]};

get_enchantment_cfg(5,6,12) ->
	#base_constellation_enchantment{equip_type = 5,pos = 6,lv = 12,cost = [{0,38040073,13}],attr = [{2,57600},{4,1728}]};

get_enchantment_cfg(5,6,13) ->
	#base_constellation_enchantment{equip_type = 5,pos = 6,lv = 13,cost = [{0,38040073,14}],attr = [{2,62400},{4,1872}]};

get_enchantment_cfg(5,6,14) ->
	#base_constellation_enchantment{equip_type = 5,pos = 6,lv = 14,cost = [{0,38040073,15}],attr = [{2,67200},{4,2016}]};

get_enchantment_cfg(5,6,15) ->
	#base_constellation_enchantment{equip_type = 5,pos = 6,lv = 15,cost = [{0,38040073,16}],attr = [{2,72000},{4,2160}]};

get_enchantment_cfg(5,6,16) ->
	#base_constellation_enchantment{equip_type = 5,pos = 6,lv = 16,cost = [{0,38040073,17}],attr = [{2,76800},{4,2304}]};

get_enchantment_cfg(5,6,17) ->
	#base_constellation_enchantment{equip_type = 5,pos = 6,lv = 17,cost = [{0,38040073,18}],attr = [{2,81600},{4,2448}]};

get_enchantment_cfg(5,6,18) ->
	#base_constellation_enchantment{equip_type = 5,pos = 6,lv = 18,cost = [{0,38040073,19}],attr = [{2,86400},{4,2592}]};

get_enchantment_cfg(5,6,19) ->
	#base_constellation_enchantment{equip_type = 5,pos = 6,lv = 19,cost = [{0,38040073,20}],attr = [{2,91200},{4,2736}]};

get_enchantment_cfg(5,6,20) ->
	#base_constellation_enchantment{equip_type = 5,pos = 6,lv = 20,cost = [{0,38040073,21}],attr = [{2,96000},{4,2880}]};

get_enchantment_cfg(5,6,21) ->
	#base_constellation_enchantment{equip_type = 5,pos = 6,lv = 21,cost = [{0,38040073,22}],attr = [{2,100800},{4,3024}]};

get_enchantment_cfg(5,6,22) ->
	#base_constellation_enchantment{equip_type = 5,pos = 6,lv = 22,cost = [{0,38040073,23}],attr = [{2,105600},{4,3168}]};

get_enchantment_cfg(5,6,23) ->
	#base_constellation_enchantment{equip_type = 5,pos = 6,lv = 23,cost = [{0,38040073,24}],attr = [{2,110400},{4,3312}]};

get_enchantment_cfg(5,6,24) ->
	#base_constellation_enchantment{equip_type = 5,pos = 6,lv = 24,cost = [{0,38040073,25}],attr = [{2,115200},{4,3456}]};

get_enchantment_cfg(5,6,25) ->
	#base_constellation_enchantment{equip_type = 5,pos = 6,lv = 25,cost = [{0,38040073,26}],attr = [{2,120000},{4,3600}]};

get_enchantment_cfg(5,6,26) ->
	#base_constellation_enchantment{equip_type = 5,pos = 6,lv = 26,cost = [{0,38040073,27}],attr = [{2,124800},{4,3744}]};

get_enchantment_cfg(5,6,27) ->
	#base_constellation_enchantment{equip_type = 5,pos = 6,lv = 27,cost = [{0,38040073,28}],attr = [{2,129600},{4,3888}]};

get_enchantment_cfg(5,6,28) ->
	#base_constellation_enchantment{equip_type = 5,pos = 6,lv = 28,cost = [{0,38040073,29}],attr = [{2,134400},{4,4032}]};

get_enchantment_cfg(5,6,29) ->
	#base_constellation_enchantment{equip_type = 5,pos = 6,lv = 29,cost = [{0,38040073,30}],attr = [{2,139200},{4,4176}]};

get_enchantment_cfg(5,6,30) ->
	#base_constellation_enchantment{equip_type = 5,pos = 6,lv = 30,cost = [],attr = [{2,144000},{4,4320}]};

get_enchantment_cfg(_Equiptype,_Pos,_Lv) ->
	#base_constellation_enchantment{}.

get_enchantment_master(1,1) ->
	#base_constellation_enchantment_master{equip_type = 1,lv = 1,satisfy_status = [{1,1},{2,1},{3,1},{4,1},{5,1},{6,1}],attr = [{22,150},{325,300}]};

get_enchantment_master(1,3) ->
	#base_constellation_enchantment_master{equip_type = 1,lv = 3,satisfy_status = [{1,3},{2,3},{3,3},{4,3},{5,3},{6,3}],attr = [{21,200},{326,300}]};

get_enchantment_master(1,5) ->
	#base_constellation_enchantment_master{equip_type = 1,lv = 5,satisfy_status = [{1,5},{2,5},{3,5},{4,5},{5,5},{6,5}],attr = [{22,300},{325,600}]};

get_enchantment_master(1,7) ->
	#base_constellation_enchantment_master{equip_type = 1,lv = 7,satisfy_status = [{1,7},{2,7},{3,7},{4,7},{5,7},{6,7}],attr = [{20,200},{326,600}]};

get_enchantment_master(1,9) ->
	#base_constellation_enchantment_master{equip_type = 1,lv = 9,satisfy_status = [{1,9},{2,9},{3,9},{4,9},{5,9},{6,9}],attr = [{19,200},{325,900}]};

get_enchantment_master(1,11) ->
	#base_constellation_enchantment_master{equip_type = 1,lv = 11,satisfy_status = [{1,11},{2,11},{3,11},{4,11},{5,11},{6,11}],attr = [{21,500},{326,900}]};

get_enchantment_master(1,13) ->
	#base_constellation_enchantment_master{equip_type = 1,lv = 13,satisfy_status = [{1,13},{2,13},{3,13},{4,13},{5,13},{6,13}],attr = [{22,500},{325,1200}]};

get_enchantment_master(1,15) ->
	#base_constellation_enchantment_master{equip_type = 1,lv = 15,satisfy_status = [{1,15},{2,15},{3,15},{4,15},{5,15},{6,15}],attr = [{21,600},{326,1200}]};

get_enchantment_master(1,20) ->
	#base_constellation_enchantment_master{equip_type = 1,lv = 20,satisfy_status = [{1,20},{2,20},{3,20},{4,20},{5,20},{6,20}],attr = [{20,700},{28,500}]};

get_enchantment_master(1,25) ->
	#base_constellation_enchantment_master{equip_type = 1,lv = 25,satisfy_status = [{1,25},{2,25},{3,25},{4,25},{5,25},{6,25}],attr = [{19,700},{9,300}]};

get_enchantment_master(1,30) ->
	#base_constellation_enchantment_master{equip_type = 1,lv = 30,satisfy_status = [{1,30},{2,30},{3,30},{4,30},{5,30},{6,30}],attr = [{20,700},{10,300}]};

get_enchantment_master(2,1) ->
	#base_constellation_enchantment_master{equip_type = 2,lv = 1,satisfy_status = [{1,1},{2,1},{3,1},{4,1},{5,1},{6,1}],attr = [{22,150},{325,300}]};

get_enchantment_master(2,3) ->
	#base_constellation_enchantment_master{equip_type = 2,lv = 3,satisfy_status = [{1,3},{2,3},{3,3},{4,3},{5,3},{6,3}],attr = [{21,200},{326,300}]};

get_enchantment_master(2,5) ->
	#base_constellation_enchantment_master{equip_type = 2,lv = 5,satisfy_status = [{1,5},{2,5},{3,5},{4,5},{5,5},{6,5}],attr = [{22,300},{325,600}]};

get_enchantment_master(2,7) ->
	#base_constellation_enchantment_master{equip_type = 2,lv = 7,satisfy_status = [{1,7},{2,7},{3,7},{4,7},{5,7},{6,7}],attr = [{20,200},{326,600}]};

get_enchantment_master(2,9) ->
	#base_constellation_enchantment_master{equip_type = 2,lv = 9,satisfy_status = [{1,9},{2,9},{3,9},{4,9},{5,9},{6,9}],attr = [{19,200},{325,900}]};

get_enchantment_master(2,11) ->
	#base_constellation_enchantment_master{equip_type = 2,lv = 11,satisfy_status = [{1,11},{2,11},{3,11},{4,11},{5,11},{6,11}],attr = [{21,500},{326,900}]};

get_enchantment_master(2,13) ->
	#base_constellation_enchantment_master{equip_type = 2,lv = 13,satisfy_status = [{1,13},{2,13},{3,13},{4,13},{5,13},{6,13}],attr = [{22,500},{325,1200}]};

get_enchantment_master(2,15) ->
	#base_constellation_enchantment_master{equip_type = 2,lv = 15,satisfy_status = [{1,15},{2,15},{3,15},{4,15},{5,15},{6,15}],attr = [{21,600},{326,1200}]};

get_enchantment_master(2,20) ->
	#base_constellation_enchantment_master{equip_type = 2,lv = 20,satisfy_status = [{1,20},{2,20},{3,20},{4,20},{5,20},{6,20}],attr = [{20,700},{28,500}]};

get_enchantment_master(2,25) ->
	#base_constellation_enchantment_master{equip_type = 2,lv = 25,satisfy_status = [{1,25},{2,25},{3,25},{4,25},{5,25},{6,25}],attr = [{19,700},{9,300}]};

get_enchantment_master(2,30) ->
	#base_constellation_enchantment_master{equip_type = 2,lv = 30,satisfy_status = [{1,30},{2,30},{3,30},{4,30},{5,30},{6,30}],attr = [{20,700},{10,300}]};

get_enchantment_master(3,1) ->
	#base_constellation_enchantment_master{equip_type = 3,lv = 1,satisfy_status = [{1,1},{2,1},{3,1},{4,1},{5,1},{6,1}],attr = [{22,150},{325,300}]};

get_enchantment_master(3,3) ->
	#base_constellation_enchantment_master{equip_type = 3,lv = 3,satisfy_status = [{1,3},{2,3},{3,3},{4,3},{5,3},{6,3}],attr = [{21,200},{326,300}]};

get_enchantment_master(3,5) ->
	#base_constellation_enchantment_master{equip_type = 3,lv = 5,satisfy_status = [{1,5},{2,5},{3,5},{4,5},{5,5},{6,5}],attr = [{22,300},{325,600}]};

get_enchantment_master(3,7) ->
	#base_constellation_enchantment_master{equip_type = 3,lv = 7,satisfy_status = [{1,7},{2,7},{3,7},{4,7},{5,7},{6,7}],attr = [{20,200},{326,600}]};

get_enchantment_master(3,9) ->
	#base_constellation_enchantment_master{equip_type = 3,lv = 9,satisfy_status = [{1,9},{2,9},{3,9},{4,9},{5,9},{6,9}],attr = [{19,200},{325,900}]};

get_enchantment_master(3,11) ->
	#base_constellation_enchantment_master{equip_type = 3,lv = 11,satisfy_status = [{1,11},{2,11},{3,11},{4,11},{5,11},{6,11}],attr = [{21,500},{326,900}]};

get_enchantment_master(3,13) ->
	#base_constellation_enchantment_master{equip_type = 3,lv = 13,satisfy_status = [{1,13},{2,13},{3,13},{4,13},{5,13},{6,13}],attr = [{22,500},{325,1200}]};

get_enchantment_master(3,15) ->
	#base_constellation_enchantment_master{equip_type = 3,lv = 15,satisfy_status = [{1,15},{2,15},{3,15},{4,15},{5,15},{6,15}],attr = [{21,600},{326,1200}]};

get_enchantment_master(3,20) ->
	#base_constellation_enchantment_master{equip_type = 3,lv = 20,satisfy_status = [{1,20},{2,20},{3,20},{4,20},{5,20},{6,20}],attr = [{20,700},{28,500}]};

get_enchantment_master(3,25) ->
	#base_constellation_enchantment_master{equip_type = 3,lv = 25,satisfy_status = [{1,25},{2,25},{3,25},{4,25},{5,25},{6,25}],attr = [{19,700},{9,300}]};

get_enchantment_master(3,30) ->
	#base_constellation_enchantment_master{equip_type = 3,lv = 30,satisfy_status = [{1,30},{2,30},{3,30},{4,30},{5,30},{6,30}],attr = [{20,700},{10,300}]};

get_enchantment_master(4,1) ->
	#base_constellation_enchantment_master{equip_type = 4,lv = 1,satisfy_status = [{1,1},{2,1},{3,1},{4,1},{5,1},{6,1}],attr = [{22,150},{325,300}]};

get_enchantment_master(4,3) ->
	#base_constellation_enchantment_master{equip_type = 4,lv = 3,satisfy_status = [{1,3},{2,3},{3,3},{4,3},{5,3},{6,3}],attr = [{21,200},{326,300}]};

get_enchantment_master(4,5) ->
	#base_constellation_enchantment_master{equip_type = 4,lv = 5,satisfy_status = [{1,5},{2,5},{3,5},{4,5},{5,5},{6,5}],attr = [{22,300},{325,600}]};

get_enchantment_master(4,7) ->
	#base_constellation_enchantment_master{equip_type = 4,lv = 7,satisfy_status = [{1,7},{2,7},{3,7},{4,7},{5,7},{6,7}],attr = [{20,200},{326,600}]};

get_enchantment_master(4,9) ->
	#base_constellation_enchantment_master{equip_type = 4,lv = 9,satisfy_status = [{1,9},{2,9},{3,9},{4,9},{5,9},{6,9}],attr = [{19,200},{325,900}]};

get_enchantment_master(4,11) ->
	#base_constellation_enchantment_master{equip_type = 4,lv = 11,satisfy_status = [{1,11},{2,11},{3,11},{4,11},{5,11},{6,11}],attr = [{21,500},{326,900}]};

get_enchantment_master(4,13) ->
	#base_constellation_enchantment_master{equip_type = 4,lv = 13,satisfy_status = [{1,13},{2,13},{3,13},{4,13},{5,13},{6,13}],attr = [{22,500},{325,1200}]};

get_enchantment_master(4,15) ->
	#base_constellation_enchantment_master{equip_type = 4,lv = 15,satisfy_status = [{1,15},{2,15},{3,15},{4,15},{5,15},{6,15}],attr = [{21,600},{326,1200}]};

get_enchantment_master(4,20) ->
	#base_constellation_enchantment_master{equip_type = 4,lv = 20,satisfy_status = [{1,20},{2,20},{3,20},{4,20},{5,20},{6,20}],attr = [{20,700},{28,500}]};

get_enchantment_master(4,25) ->
	#base_constellation_enchantment_master{equip_type = 4,lv = 25,satisfy_status = [{1,25},{2,25},{3,25},{4,25},{5,25},{6,25}],attr = [{19,700},{9,300}]};

get_enchantment_master(4,30) ->
	#base_constellation_enchantment_master{equip_type = 4,lv = 30,satisfy_status = [{1,30},{2,30},{3,30},{4,30},{5,30},{6,30}],attr = [{20,700},{10,300}]};

get_enchantment_master(5,1) ->
	#base_constellation_enchantment_master{equip_type = 5,lv = 1,satisfy_status = [{1,1},{2,1},{3,1},{4,1},{5,1},{6,1}],attr = [{22,150},{325,300}]};

get_enchantment_master(5,3) ->
	#base_constellation_enchantment_master{equip_type = 5,lv = 3,satisfy_status = [{1,3},{2,3},{3,3},{4,3},{5,3},{6,3}],attr = [{21,200},{326,300}]};

get_enchantment_master(5,5) ->
	#base_constellation_enchantment_master{equip_type = 5,lv = 5,satisfy_status = [{1,5},{2,5},{3,5},{4,5},{5,5},{6,5}],attr = [{22,300},{325,600}]};

get_enchantment_master(5,7) ->
	#base_constellation_enchantment_master{equip_type = 5,lv = 7,satisfy_status = [{1,7},{2,7},{3,7},{4,7},{5,7},{6,7}],attr = [{20,200},{326,600}]};

get_enchantment_master(5,9) ->
	#base_constellation_enchantment_master{equip_type = 5,lv = 9,satisfy_status = [{1,9},{2,9},{3,9},{4,9},{5,9},{6,9}],attr = [{19,200},{325,900}]};

get_enchantment_master(5,11) ->
	#base_constellation_enchantment_master{equip_type = 5,lv = 11,satisfy_status = [{1,11},{2,11},{3,11},{4,11},{5,11},{6,11}],attr = [{21,500},{326,900}]};

get_enchantment_master(5,13) ->
	#base_constellation_enchantment_master{equip_type = 5,lv = 13,satisfy_status = [{1,13},{2,13},{3,13},{4,13},{5,13},{6,13}],attr = [{22,500},{325,1200}]};

get_enchantment_master(5,15) ->
	#base_constellation_enchantment_master{equip_type = 5,lv = 15,satisfy_status = [{1,15},{2,15},{3,15},{4,15},{5,15},{6,15}],attr = [{21,600},{326,1200}]};

get_enchantment_master(5,20) ->
	#base_constellation_enchantment_master{equip_type = 5,lv = 20,satisfy_status = [{1,20},{2,20},{3,20},{4,20},{5,20},{6,20}],attr = [{20,700},{28,500}]};

get_enchantment_master(5,25) ->
	#base_constellation_enchantment_master{equip_type = 5,lv = 25,satisfy_status = [{1,25},{2,25},{3,25},{4,25},{5,25},{6,25}],attr = [{19,700},{9,300}]};

get_enchantment_master(5,30) ->
	#base_constellation_enchantment_master{equip_type = 5,lv = 30,satisfy_status = [{1,30},{2,30},{3,30},{4,30},{5,30},{6,30}],attr = [{20,700},{10,300}]};

get_enchantment_master(_Equiptype,_Lv) ->
	#base_constellation_enchantment_master{}.


get_enchantment_master_lv(1) ->
[1,3,5,7,9,11,13,15,20,25,30];


get_enchantment_master_lv(2) ->
[1,3,5,7,9,11,13,15,20,25,30];


get_enchantment_master_lv(3) ->
[1,3,5,7,9,11,13,15,20,25,30];


get_enchantment_master_lv(4) ->
[1,3,5,7,9,11,13,15,20,25,30];


get_enchantment_master_lv(5) ->
[1,3,5,7,9,11,13,15,20,25,30];

get_enchantment_master_lv(_Equiptype) ->
	[].

get_spirit_cfg(1,1) ->
	#base_constellation_spirit{equip_type = 1,pos = 1,cost = [{0,38040074,1}],attr = [{19,200},{21,200},{9,60}]};

get_spirit_cfg(1,2) ->
	#base_constellation_spirit{equip_type = 1,pos = 2,cost = [{0,38040074,1}],attr = [{20,200},{22,200},{10,60}]};

get_spirit_cfg(1,3) ->
	#base_constellation_spirit{equip_type = 1,pos = 3,cost = [{0,38040074,1}],attr = [{20,200},{22,200},{10,60}]};

get_spirit_cfg(1,4) ->
	#base_constellation_spirit{equip_type = 1,pos = 4,cost = [{0,38040074,1}],attr = [{20,200},{22,200},{10,60}]};

get_spirit_cfg(1,5) ->
	#base_constellation_spirit{equip_type = 1,pos = 5,cost = [{0,38040074,1}],attr = [{19,200},{21,200},{9,60}]};

get_spirit_cfg(1,6) ->
	#base_constellation_spirit{equip_type = 1,pos = 6,cost = [{0,38040074,1}],attr = [{20,200},{22,200},{10,60}]};

get_spirit_cfg(2,1) ->
	#base_constellation_spirit{equip_type = 2,pos = 1,cost = [{0,38040074,1}],attr = [{19,200},{21,200},{9,60}]};

get_spirit_cfg(2,2) ->
	#base_constellation_spirit{equip_type = 2,pos = 2,cost = [{0,38040074,1}],attr = [{20,200},{22,200},{10,60}]};

get_spirit_cfg(2,3) ->
	#base_constellation_spirit{equip_type = 2,pos = 3,cost = [{0,38040074,1}],attr = [{20,200},{22,200},{10,60}]};

get_spirit_cfg(2,4) ->
	#base_constellation_spirit{equip_type = 2,pos = 4,cost = [{0,38040074,1}],attr = [{20,200},{22,200},{10,60}]};

get_spirit_cfg(2,5) ->
	#base_constellation_spirit{equip_type = 2,pos = 5,cost = [{0,38040074,1}],attr = [{19,200},{21,200},{9,60}]};

get_spirit_cfg(2,6) ->
	#base_constellation_spirit{equip_type = 2,pos = 6,cost = [{0,38040074,1}],attr = [{20,200},{22,200},{10,60}]};

get_spirit_cfg(3,1) ->
	#base_constellation_spirit{equip_type = 3,pos = 1,cost = [{0,38040074,1}],attr = [{19,200},{21,200},{9,60}]};

get_spirit_cfg(3,2) ->
	#base_constellation_spirit{equip_type = 3,pos = 2,cost = [{0,38040074,1}],attr = [{20,200},{22,200},{10,60}]};

get_spirit_cfg(3,3) ->
	#base_constellation_spirit{equip_type = 3,pos = 3,cost = [{0,38040074,1}],attr = [{20,200},{22,200},{10,60}]};

get_spirit_cfg(3,4) ->
	#base_constellation_spirit{equip_type = 3,pos = 4,cost = [{0,38040074,1}],attr = [{20,200},{22,200},{10,60}]};

get_spirit_cfg(3,5) ->
	#base_constellation_spirit{equip_type = 3,pos = 5,cost = [{0,38040074,1}],attr = [{19,200},{21,200},{9,60}]};

get_spirit_cfg(3,6) ->
	#base_constellation_spirit{equip_type = 3,pos = 6,cost = [{0,38040074,1}],attr = [{20,200},{22,200},{10,60}]};

get_spirit_cfg(4,1) ->
	#base_constellation_spirit{equip_type = 4,pos = 1,cost = [{0,38040074,1}],attr = [{19,200},{21,200},{9,60}]};

get_spirit_cfg(4,2) ->
	#base_constellation_spirit{equip_type = 4,pos = 2,cost = [{0,38040074,1}],attr = [{20,200},{22,200},{10,60}]};

get_spirit_cfg(4,3) ->
	#base_constellation_spirit{equip_type = 4,pos = 3,cost = [{0,38040074,1}],attr = [{20,200},{22,200},{10,60}]};

get_spirit_cfg(4,4) ->
	#base_constellation_spirit{equip_type = 4,pos = 4,cost = [{0,38040074,1}],attr = [{20,200},{22,200},{10,60}]};

get_spirit_cfg(4,5) ->
	#base_constellation_spirit{equip_type = 4,pos = 5,cost = [{0,38040074,1}],attr = [{19,200},{21,200},{9,60}]};

get_spirit_cfg(4,6) ->
	#base_constellation_spirit{equip_type = 4,pos = 6,cost = [{0,38040074,1}],attr = [{20,200},{22,200},{10,60}]};

get_spirit_cfg(5,1) ->
	#base_constellation_spirit{equip_type = 5,pos = 1,cost = [{0,38040074,1}],attr = [{19,200},{21,200},{9,60}]};

get_spirit_cfg(5,2) ->
	#base_constellation_spirit{equip_type = 5,pos = 2,cost = [{0,38040074,1}],attr = [{20,200},{22,200},{10,60}]};

get_spirit_cfg(5,3) ->
	#base_constellation_spirit{equip_type = 5,pos = 3,cost = [{0,38040074,1}],attr = [{20,200},{22,200},{10,60}]};

get_spirit_cfg(5,4) ->
	#base_constellation_spirit{equip_type = 5,pos = 4,cost = [{0,38040074,1}],attr = [{20,200},{22,200},{10,60}]};

get_spirit_cfg(5,5) ->
	#base_constellation_spirit{equip_type = 5,pos = 5,cost = [{0,38040074,1}],attr = [{19,200},{21,200},{9,60}]};

get_spirit_cfg(5,6) ->
	#base_constellation_spirit{equip_type = 5,pos = 6,cost = [{0,38040074,1}],attr = [{20,200},{22,200},{10,60}]};

get_spirit_cfg(_Equiptype,_Pos) ->
	#base_constellation_spirit{}.


get(1) ->
580;


get(2) ->
580;


get(3) ->
580;


get(4) ->
2;


get(5) ->
580;


get(6) ->
1;


get(7) ->
2;


get(8) ->
3;


get(9) ->
4;


get(10) ->
[1,2,3,4,5,6,7,8];

get(_Id) ->
	[].

get_evolution_pool(1,1) ->
	#base_constellation_evolution_pool{equip_type = 1,pos = 1,attr_pool = [{19,20,3,1,800},{21,40,3,1,800},{56,200,3,1,800},{1,1200,3,0,1700},{3,720,3,0,1700},{203,100,3,0,1700}]};

get_evolution_pool(1,2) ->
	#base_constellation_evolution_pool{equip_type = 1,pos = 2,attr_pool = [{20,20,3,1,800},{22,40,3,1,800},{28,40,3,1,800},{2,24000,3,0,1700},{4,720,3,0,1700},{303,0,3,0,1700,1,1}]};

get_evolution_pool(1,3) ->
	#base_constellation_evolution_pool{equip_type = 1,pos = 3,attr_pool = [{20,20,3,1,800},{22,40,3,1,800},{28,40,3,1,800},{2,24000,3,0,1700},{4,720,3,0,1700},{303,0,3,0,1700,1,1}]};

get_evolution_pool(1,4) ->
	#base_constellation_evolution_pool{equip_type = 1,pos = 4,attr_pool = [{20,20,3,1,800},{22,40,3,1,800},{28,40,3,1,800},{2,24000,3,0,1700},{4,720,3,0,1700},{303,0,3,0,1700,1,1}]};

get_evolution_pool(1,5) ->
	#base_constellation_evolution_pool{equip_type = 1,pos = 5,attr_pool = [{19,20,3,1,800},{21,40,3,1,800},{56,200,3,1,800},{1,1200,3,0,1700},{3,720,3,0,1700},{203,100,3,0,1700}]};

get_evolution_pool(1,6) ->
	#base_constellation_evolution_pool{equip_type = 1,pos = 6,attr_pool = [{20,20,3,1,800},{22,40,3,1,800},{28,40,3,1,800},{2,24000,3,0,1700},{4,720,3,0,1700},{303,0,3,0,1700,1,1}]};

get_evolution_pool(2,1) ->
	#base_constellation_evolution_pool{equip_type = 2,pos = 1,attr_pool = [{19,20,3,1,800},{21,40,3,1,800},{56,200,3,1,800},{27,40,3,1,800},{1,1200,3,0,1700},{3,720,3,0,1700},{203,100,3,0,1700},{46,2400,3,0,1700}]};

get_evolution_pool(2,2) ->
	#base_constellation_evolution_pool{equip_type = 2,pos = 2,attr_pool = [{20,20,3,1,800},{22,40,3,1,800},{28,40,3,1,800},{38,80,3,1,800},{2,24000,3,0,1700},{4,720,3,0,1700},{303,0,3,0,1700,1,1},{47,1440,3,0,1700}]};

get_evolution_pool(2,3) ->
	#base_constellation_evolution_pool{equip_type = 2,pos = 3,attr_pool = [{20,20,3,1,800},{22,40,3,1,800},{28,40,3,1,800},{38,80,3,1,800},{2,24000,3,0,1700},{4,720,3,0,1700},{303,0,3,0,1700,1,1},{47,1440,3,0,1700}]};

get_evolution_pool(2,4) ->
	#base_constellation_evolution_pool{equip_type = 2,pos = 4,attr_pool = [{20,20,3,1,800},{22,40,3,1,800},{28,40,3,1,800},{38,80,3,1,800},{2,24000,3,0,1700},{4,720,3,0,1700},{303,0,3,0,1700,1,1},{47,1440,3,0,1700}]};

get_evolution_pool(2,5) ->
	#base_constellation_evolution_pool{equip_type = 2,pos = 5,attr_pool = [{19,20,3,1,800},{21,40,3,1,800},{56,200,3,1,800},{27,40,3,1,800},{1,1200,3,0,1700},{3,720,3,0,1700},{203,100,3,0,1700},{46,2400,3,0,1700}]};

get_evolution_pool(2,6) ->
	#base_constellation_evolution_pool{equip_type = 2,pos = 6,attr_pool = [{20,20,3,1,800},{22,40,3,1,800},{28,40,3,1,800},{38,80,3,1,800},{2,24000,3,0,1700},{4,720,3,0,1700},{303,0,3,0,1700,1,1},{47,1440,3,0,1700}]};

get_evolution_pool(3,1) ->
	#base_constellation_evolution_pool{equip_type = 3,pos = 1,attr_pool = [{19,20,3,1,800},{21,40,3,1,800},{56,200,3,1,800},{27,40,3,1,800},{1,1200,3,0,1700},{3,720,3,0,1700},{203,100,3,0,1700},{46,2400,3,0,1700},{300,0,3,0,1700,1,3}]};

get_evolution_pool(3,2) ->
	#base_constellation_evolution_pool{equip_type = 3,pos = 2,attr_pool = [{20,20,3,1,800},{22,40,3,1,800},{28,40,3,1,800},{38,80,3,1,800},{2,24000,3,0,1700},{4,720,3,0,1700},{303,0,3,0,1700,1,1},{47,1440,3,0,1700},{301,0,3,0,1700,1,500}]};

get_evolution_pool(3,3) ->
	#base_constellation_evolution_pool{equip_type = 3,pos = 3,attr_pool = [{20,20,3,1,800},{22,40,3,1,800},{28,40,3,1,800},{38,80,3,1,800},{2,24000,3,0,1700},{4,720,3,0,1700},{303,0,3,0,1700,1,1},{47,1440,3,0,1700},{301,0,3,0,1700,1,500}]};

get_evolution_pool(3,4) ->
	#base_constellation_evolution_pool{equip_type = 3,pos = 4,attr_pool = [{20,20,3,1,800},{22,40,3,1,800},{28,40,3,1,800},{38,80,3,1,800},{2,24000,3,0,1700},{4,720,3,0,1700},{303,0,3,0,1700,1,1},{47,1440,3,0,1700},{301,0,3,0,1700,1,500}]};

get_evolution_pool(3,5) ->
	#base_constellation_evolution_pool{equip_type = 3,pos = 5,attr_pool = [{19,20,3,1,800},{21,40,3,1,800},{56,200,3,1,800},{27,40,3,1,800},{1,1200,3,0,1700},{3,720,3,0,1700},{203,100,3,0,1700},{46,2400,3,0,1700},{300,0,3,0,1700,1,3}]};

get_evolution_pool(3,6) ->
	#base_constellation_evolution_pool{equip_type = 3,pos = 6,attr_pool = [{20,20,3,1,800},{22,40,3,1,800},{28,40,3,1,800},{38,80,3,1,800},{2,24000,3,0,1700},{4,720,3,0,1700},{303,0,3,0,1700,1,1},{47,1440,3,0,1700},{301,0,3,0,1700,1,500}]};

get_evolution_pool(4,1) ->
	#base_constellation_evolution_pool{equip_type = 4,pos = 1,attr_pool = [{19,20,3,1,800},{21,40,3,1,800},{56,200,3,1,800},{27,40,3,1,800},{1,1200,3,0,1700},{3,720,3,0,1700},{203,100,3,0,1700},{46,2400,3,0,1700},{300,0,3,0,1700,1,3}]};

get_evolution_pool(4,2) ->
	#base_constellation_evolution_pool{equip_type = 4,pos = 2,attr_pool = [{20,20,3,1,800},{22,40,3,1,800},{28,40,3,1,800},{38,80,3,1,800},{2,24000,3,0,1700},{4,720,3,0,1700},{303,0,3,0,1700,1,1},{47,1440,3,0,1700},{301,0,3,0,1700,1,500}]};

get_evolution_pool(4,3) ->
	#base_constellation_evolution_pool{equip_type = 4,pos = 3,attr_pool = [{20,20,3,1,800},{22,40,3,1,800},{28,40,3,1,800},{38,80,3,1,800},{2,24000,3,0,1700},{4,720,3,0,1700},{303,0,3,0,1700,1,1},{47,1440,3,0,1700},{301,0,3,0,1700,1,500}]};

get_evolution_pool(4,4) ->
	#base_constellation_evolution_pool{equip_type = 4,pos = 4,attr_pool = [{20,20,3,1,800},{22,40,3,1,800},{28,40,3,1,800},{38,80,3,1,800},{2,24000,3,0,1700},{4,720,3,0,1700},{303,0,3,0,1700,1,1},{47,1440,3,0,1700},{301,0,3,0,1700,1,500}]};

get_evolution_pool(4,5) ->
	#base_constellation_evolution_pool{equip_type = 4,pos = 5,attr_pool = [{19,20,3,1,800},{21,40,3,1,800},{56,200,3,1,800},{27,40,3,1,800},{1,1200,3,0,1700},{3,720,3,0,1700},{203,100,3,0,1700},{46,2400,3,0,1700},{300,0,3,0,1700,1,3}]};

get_evolution_pool(4,6) ->
	#base_constellation_evolution_pool{equip_type = 4,pos = 6,attr_pool = [{20,20,3,1,800},{22,40,3,1,800},{28,40,3,1,800},{38,80,3,1,800},{2,24000,3,0,1700},{4,720,3,0,1700},{303,0,3,0,1700,1,1},{47,1440,3,0,1700},{301,0,3,0,1700,1,500}]};

get_evolution_pool(5,1) ->
	#base_constellation_evolution_pool{equip_type = 5,pos = 1,attr_pool = [{19,20,3,1,800},{21,40,3,1,800},{56,200,3,1,800},{27,40,3,1,800},{49,20,3,1,800},{1,1200,3,0,1700},{3,720,3,0,1700},{203,100,3,0,1700},{46,2400,3,0,1700},{300,0,3,0,1700,1,3}]};

get_evolution_pool(5,2) ->
	#base_constellation_evolution_pool{equip_type = 5,pos = 2,attr_pool = [{20,20,3,1,800},{22,40,3,1,800},{28,40,3,1,800},{38,80,3,1,800},{14,20,3,1,800},{2,24000,3,0,1700},{4,720,3,0,1700},{303,0,3,0,1700,1,1},{47,1440,3,0,1700},{301,0,3,0,1700,1,500}]};

get_evolution_pool(5,3) ->
	#base_constellation_evolution_pool{equip_type = 5,pos = 3,attr_pool = [{20,20,3,1,800},{22,40,3,1,800},{28,40,3,1,800},{38,80,3,1,800},{14,20,3,1,800},{2,24000,3,0,1700},{4,720,3,0,1700},{303,0,3,0,1700,1,1},{47,1440,3,0,1700},{301,0,3,0,1700,1,500}]};

get_evolution_pool(5,4) ->
	#base_constellation_evolution_pool{equip_type = 5,pos = 4,attr_pool = [{20,20,3,1,800},{22,40,3,1,800},{28,40,3,1,800},{38,80,3,1,800},{14,20,3,1,800},{2,24000,3,0,1700},{4,720,3,0,1700},{303,0,3,0,1700,1,1},{47,1440,3,0,1700},{301,0,3,0,1700,1,500}]};

get_evolution_pool(5,5) ->
	#base_constellation_evolution_pool{equip_type = 5,pos = 5,attr_pool = [{19,20,3,1,800},{21,40,3,1,800},{56,200,3,1,800},{27,40,3,1,800},{49,20,3,1,800},{1,1200,3,0,1700},{3,720,3,0,1700},{203,100,3,0,1700},{46,2400,3,0,1700},{300,0,3,0,1700,1,3}]};

get_evolution_pool(5,6) ->
	#base_constellation_evolution_pool{equip_type = 5,pos = 6,attr_pool = [{20,20,3,1,800},{22,40,3,1,800},{28,40,3,1,800},{38,80,3,1,800},{14,20,3,1,800},{2,24000,3,0,1700},{4,720,3,0,1700},{303,0,3,0,1700,1,1},{47,1440,3,0,1700},{301,0,3,0,1700,1,500}]};

get_evolution_pool(_Equiptype,_Pos) ->
	#base_constellation_evolution_pool{}.

