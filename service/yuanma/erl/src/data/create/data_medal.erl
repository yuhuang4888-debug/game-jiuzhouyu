%%%---------------------------------------
%%% module      : data_medal
%%% description : 勋章配置
%%%
%%%---------------------------------------
-module(data_medal).
-compile(export_all).
-include("medal.hrl").



get_medal(1) ->
	#medal{id = 1,medal_name = "未获得",cost = [],add_attr = [],large_image_id = 0,small_image_id = 0,medal_start = 0,upgrade_power = 20000,other_condition = [],title = "0"};

get_medal(2) ->
	#medal{id = 2,medal_name = "一阶",cost = [],add_attr = [{2,5600},{1,140}],large_image_id = 1,small_image_id = 0,medal_start = 1,upgrade_power = 60000,other_condition = [],title = "1"};

get_medal(3) ->
	#medal{id = 3,medal_name = "二阶",cost = [],add_attr = [{2,7520},{1,188}],large_image_id = 1,small_image_id = 0,medal_start = 2,upgrade_power = 100000,other_condition = [],title = "1"};

get_medal(4) ->
	#medal{id = 4,medal_name = "三阶",cost = [],add_attr = [{2,9440},{1,236}],large_image_id = 1,small_image_id = 0,medal_start = 3,upgrade_power = 140000,other_condition = [],title = "1"};

get_medal(5) ->
	#medal{id = 5,medal_name = "四阶",cost = [],add_attr = [{2,11360},{1,284}],large_image_id = 1,small_image_id = 0,medal_start = 4,upgrade_power = 180000,other_condition = [],title = "1"};

get_medal(6) ->
	#medal{id = 6,medal_name = "五阶",cost = [],add_attr = [{2,13280},{1,332}],large_image_id = 1,small_image_id = 0,medal_start = 5,upgrade_power = 220000,other_condition = [],title = "1"};

get_medal(7) ->
	#medal{id = 7,medal_name = "六阶",cost = [],add_attr = [{2,15200},{1,380}],large_image_id = 1,small_image_id = 0,medal_start = 6,upgrade_power = 260000,other_condition = [],title = "1"};

get_medal(8) ->
	#medal{id = 8,medal_name = "七阶",cost = [],add_attr = [{2,17120},{1,428}],large_image_id = 1,small_image_id = 0,medal_start = 7,upgrade_power = 300000,other_condition = [],title = "1"};

get_medal(9) ->
	#medal{id = 9,medal_name = "八阶",cost = [],add_attr = [{2,19040},{1,476}],large_image_id = 1,small_image_id = 0,medal_start = 8,upgrade_power = 350000,other_condition = [],title = "1"};

get_medal(10) ->
	#medal{id = 10,medal_name = "九阶",cost = [{0,38040044,2}],add_attr = [{2,20960},{1,524}],large_image_id = 1,small_image_id = 0,medal_start = 9,upgrade_power = 0,other_condition = [{dunid, 19}],title = "1"};

get_medal(11) ->
	#medal{id = 11,medal_name = "初阶",cost = [],add_attr = [{2,29600},{1,740},{85,80}],large_image_id = 1,small_image_id = 0,medal_start = 0,upgrade_power = 565000,other_condition = [],title = "2"};

get_medal(12) ->
	#medal{id = 12,medal_name = "一阶",cost = [],add_attr = [{2,32400},{1,810},{85,80}],large_image_id = 1,small_image_id = 0,medal_start = 1,upgrade_power = 630000,other_condition = [],title = "2"};

get_medal(13) ->
	#medal{id = 13,medal_name = "二阶",cost = [],add_attr = [{2,35200},{1,880},{85,80}],large_image_id = 1,small_image_id = 0,medal_start = 2,upgrade_power = 695000,other_condition = [],title = "2"};

get_medal(14) ->
	#medal{id = 14,medal_name = "三阶",cost = [],add_attr = [{2,38000},{1,950},{85,80}],large_image_id = 1,small_image_id = 0,medal_start = 3,upgrade_power = 760000,other_condition = [],title = "2"};

get_medal(15) ->
	#medal{id = 15,medal_name = "四阶",cost = [],add_attr = [{2,40800},{1,1020},{85,80}],large_image_id = 1,small_image_id = 0,medal_start = 4,upgrade_power = 825000,other_condition = [],title = "2"};

get_medal(16) ->
	#medal{id = 16,medal_name = "五阶",cost = [],add_attr = [{2,43600},{1,1090},{85,80}],large_image_id = 1,small_image_id = 0,medal_start = 5,upgrade_power = 890000,other_condition = [],title = "2"};

get_medal(17) ->
	#medal{id = 17,medal_name = "六阶",cost = [],add_attr = [{2,46400},{1,1160},{85,80}],large_image_id = 1,small_image_id = 0,medal_start = 6,upgrade_power = 955000,other_condition = [],title = "2"};

get_medal(18) ->
	#medal{id = 18,medal_name = "七阶",cost = [],add_attr = [{2,49200},{1,1230},{85,80}],large_image_id = 1,small_image_id = 0,medal_start = 7,upgrade_power = 1020000,other_condition = [],title = "2"};

get_medal(19) ->
	#medal{id = 19,medal_name = "八阶",cost = [],add_attr = [{2,52000},{1,1300},{85,80}],large_image_id = 1,small_image_id = 0,medal_start = 8,upgrade_power = 1085000,other_condition = [],title = "2"};

get_medal(20) ->
	#medal{id = 20,medal_name = "九阶",cost = [{0,38040044,6}],add_attr = [{2,54800},{1,1370},{85,80}],large_image_id = 1,small_image_id = 0,medal_start = 9,upgrade_power = 0,other_condition = [{dunid, 30}],title = "2"};

get_medal(21) ->
	#medal{id = 21,medal_name = "初阶",cost = [],add_attr = [{2,84000},{1,2100},{85,160}],large_image_id = 1,small_image_id = 0,medal_start = 0,upgrade_power = 1650000,other_condition = [],title = "3"};

get_medal(22) ->
	#medal{id = 22,medal_name = "一阶",cost = [],add_attr = [{2,87533},{1,2188},{85,160}],large_image_id = 1,small_image_id = 0,medal_start = 1,upgrade_power = 1800000,other_condition = [],title = "3"};

get_medal(23) ->
	#medal{id = 23,medal_name = "二阶",cost = [],add_attr = [{2,91066},{1,2276},{85,160}],large_image_id = 1,small_image_id = 0,medal_start = 2,upgrade_power = 1950000,other_condition = [],title = "3"};

get_medal(24) ->
	#medal{id = 24,medal_name = "三阶",cost = [],add_attr = [{2,94599},{1,2364},{85,160}],large_image_id = 1,small_image_id = 0,medal_start = 3,upgrade_power = 2100000,other_condition = [],title = "3"};

get_medal(25) ->
	#medal{id = 25,medal_name = "四阶",cost = [],add_attr = [{2,98132},{1,2452},{85,160}],large_image_id = 1,small_image_id = 0,medal_start = 4,upgrade_power = 2250000,other_condition = [],title = "3"};

get_medal(26) ->
	#medal{id = 26,medal_name = "五阶",cost = [],add_attr = [{2,101665},{1,2540},{85,160}],large_image_id = 1,small_image_id = 0,medal_start = 5,upgrade_power = 2400000,other_condition = [],title = "3"};

get_medal(27) ->
	#medal{id = 27,medal_name = "六阶",cost = [],add_attr = [{2,105198},{1,2628},{85,160}],large_image_id = 1,small_image_id = 0,medal_start = 6,upgrade_power = 2550000,other_condition = [],title = "3"};

get_medal(28) ->
	#medal{id = 28,medal_name = "七阶",cost = [],add_attr = [{2,108731},{1,2716},{85,160}],large_image_id = 1,small_image_id = 0,medal_start = 7,upgrade_power = 2700000,other_condition = [],title = "3"};

get_medal(29) ->
	#medal{id = 29,medal_name = "八阶",cost = [],add_attr = [{2,112264},{1,2804},{85,160}],large_image_id = 1,small_image_id = 0,medal_start = 8,upgrade_power = 2850000,other_condition = [],title = "3"};

get_medal(30) ->
	#medal{id = 30,medal_name = "九阶",cost = [{0,38040044,12}],add_attr = [{2,115797},{1,2892},{85,160}],large_image_id = 1,small_image_id = 0,medal_start = 9,upgrade_power = 0,other_condition = [{dunid, 43}],title = "3"};

get_medal(31) ->
	#medal{id = 31,medal_name = "初阶",cost = [],add_attr = [{2,159997},{1,3997},{85,240}],large_image_id = 2,small_image_id = 0,medal_start = 0,upgrade_power = 3900000,other_condition = [],title = "4"};

get_medal(32) ->
	#medal{id = 32,medal_name = "一阶",cost = [],add_attr = [{2,165997},{1,4147},{85,240}],large_image_id = 2,small_image_id = 0,medal_start = 1,upgrade_power = 4150000,other_condition = [],title = "4"};

get_medal(33) ->
	#medal{id = 33,medal_name = "二阶",cost = [],add_attr = [{2,171997},{1,4297},{85,240}],large_image_id = 2,small_image_id = 0,medal_start = 2,upgrade_power = 4400000,other_condition = [],title = "4"};

get_medal(34) ->
	#medal{id = 34,medal_name = "三阶",cost = [],add_attr = [{2,177997},{1,4447},{85,240}],large_image_id = 2,small_image_id = 0,medal_start = 3,upgrade_power = 4650000,other_condition = [],title = "4"};

get_medal(35) ->
	#medal{id = 35,medal_name = "四阶",cost = [],add_attr = [{2,183997},{1,4597},{85,240}],large_image_id = 2,small_image_id = 0,medal_start = 4,upgrade_power = 4900000,other_condition = [],title = "4"};

get_medal(36) ->
	#medal{id = 36,medal_name = "五阶",cost = [],add_attr = [{2,189997},{1,4747},{85,240}],large_image_id = 2,small_image_id = 0,medal_start = 5,upgrade_power = 5150000,other_condition = [],title = "4"};

get_medal(37) ->
	#medal{id = 37,medal_name = "六阶",cost = [],add_attr = [{2,195997},{1,4897},{85,240}],large_image_id = 2,small_image_id = 0,medal_start = 6,upgrade_power = 5400000,other_condition = [],title = "4"};

get_medal(38) ->
	#medal{id = 38,medal_name = "七阶",cost = [],add_attr = [{2,201997},{1,5047},{85,240}],large_image_id = 2,small_image_id = 0,medal_start = 7,upgrade_power = 5650000,other_condition = [],title = "4"};

get_medal(39) ->
	#medal{id = 39,medal_name = "八阶",cost = [],add_attr = [{2,207997},{1,5197},{85,240}],large_image_id = 2,small_image_id = 0,medal_start = 8,upgrade_power = 5900000,other_condition = [],title = "4"};

get_medal(40) ->
	#medal{id = 40,medal_name = "九阶",cost = [{0,38040044,18}],add_attr = [{2,213997},{1,5347},{85,240}],large_image_id = 2,small_image_id = 0,medal_start = 9,upgrade_power = 0,other_condition = [{dunid, 56}],title = "4"};

get_medal(41) ->
	#medal{id = 41,medal_name = "初阶",cost = [],add_attr = [{2,306664},{1,7664},{85,320}],large_image_id = 2,small_image_id = 0,medal_start = 0,upgrade_power = 7650000,other_condition = [],title = "5"};

get_medal(42) ->
	#medal{id = 42,medal_name = "一阶",cost = [],add_attr = [{2,315797},{1,7892},{85,320}],large_image_id = 2,small_image_id = 0,medal_start = 1,upgrade_power = 8300000,other_condition = [],title = "5"};

get_medal(43) ->
	#medal{id = 43,medal_name = "二阶",cost = [],add_attr = [{2,324930},{1,8120},{85,320}],large_image_id = 2,small_image_id = 0,medal_start = 2,upgrade_power = 8950000,other_condition = [],title = "5"};

get_medal(44) ->
	#medal{id = 44,medal_name = "三阶",cost = [],add_attr = [{2,334063},{1,8348},{85,320}],large_image_id = 2,small_image_id = 0,medal_start = 3,upgrade_power = 9600000,other_condition = [],title = "5"};

get_medal(45) ->
	#medal{id = 45,medal_name = "四阶",cost = [],add_attr = [{2,343196},{1,8576},{85,320}],large_image_id = 2,small_image_id = 0,medal_start = 4,upgrade_power = 10250000,other_condition = [],title = "5"};

get_medal(46) ->
	#medal{id = 46,medal_name = "五阶",cost = [],add_attr = [{2,352329},{1,8804},{85,320}],large_image_id = 2,small_image_id = 0,medal_start = 5,upgrade_power = 10900000,other_condition = [],title = "5"};

get_medal(47) ->
	#medal{id = 47,medal_name = "六阶",cost = [],add_attr = [{2,361462},{1,9032},{85,320}],large_image_id = 2,small_image_id = 0,medal_start = 6,upgrade_power = 11550000,other_condition = [],title = "5"};

get_medal(48) ->
	#medal{id = 48,medal_name = "七阶",cost = [],add_attr = [{2,370595},{1,9260},{85,320}],large_image_id = 2,small_image_id = 0,medal_start = 7,upgrade_power = 12200000,other_condition = [],title = "5"};

get_medal(49) ->
	#medal{id = 49,medal_name = "八阶",cost = [],add_attr = [{2,379728},{1,9488},{85,320}],large_image_id = 2,small_image_id = 0,medal_start = 8,upgrade_power = 12850000,other_condition = [],title = "5"};

get_medal(50) ->
	#medal{id = 50,medal_name = "九阶",cost = [{0,38040044,30}],add_attr = [{2,388861},{1,9716},{85,320}],large_image_id = 2,small_image_id = 0,medal_start = 9,upgrade_power = 0,other_condition = [{dunid, 75}],title = "5"};

get_medal(51) ->
	#medal{id = 51,medal_name = "初阶",cost = [],add_attr = [{2,510661},{1,12761},{85,400}],large_image_id = 2,small_image_id = 0,medal_start = 0,upgrade_power = 17580000,other_condition = [],title = "6"};

get_medal(52) ->
	#medal{id = 52,medal_name = "一阶",cost = [],add_attr = [{2,521528},{1,13033},{85,400}],large_image_id = 2,small_image_id = 0,medal_start = 1,upgrade_power = 18810000,other_condition = [],title = "6"};

get_medal(53) ->
	#medal{id = 53,medal_name = "二阶",cost = [],add_attr = [{2,532395},{1,13305},{85,400}],large_image_id = 2,small_image_id = 0,medal_start = 2,upgrade_power = 20040000,other_condition = [],title = "6"};

get_medal(54) ->
	#medal{id = 54,medal_name = "三阶",cost = [],add_attr = [{2,543262},{1,13577},{85,400}],large_image_id = 2,small_image_id = 0,medal_start = 3,upgrade_power = 21270000,other_condition = [],title = "6"};

get_medal(55) ->
	#medal{id = 55,medal_name = "四阶",cost = [],add_attr = [{2,554129},{1,13849},{85,400}],large_image_id = 2,small_image_id = 0,medal_start = 4,upgrade_power = 22500000,other_condition = [],title = "6"};

get_medal(56) ->
	#medal{id = 56,medal_name = "五阶",cost = [],add_attr = [{2,564996},{1,14121},{85,400}],large_image_id = 2,small_image_id = 0,medal_start = 5,upgrade_power = 23730000,other_condition = [],title = "6"};

get_medal(57) ->
	#medal{id = 57,medal_name = "六阶",cost = [],add_attr = [{2,575863},{1,14393},{85,400}],large_image_id = 2,small_image_id = 0,medal_start = 6,upgrade_power = 24960000,other_condition = [],title = "6"};

get_medal(58) ->
	#medal{id = 58,medal_name = "七阶",cost = [],add_attr = [{2,586730},{1,14665},{85,400}],large_image_id = 2,small_image_id = 0,medal_start = 7,upgrade_power = 26190000,other_condition = [],title = "6"};

get_medal(59) ->
	#medal{id = 59,medal_name = "八阶",cost = [],add_attr = [{2,597597},{1,14937},{85,400}],large_image_id = 2,small_image_id = 0,medal_start = 8,upgrade_power = 27420000,other_condition = [],title = "6"};

get_medal(60) ->
	#medal{id = 60,medal_name = "九阶",cost = [{0,38040044,45}],add_attr = [{2,608464},{1,15209},{85,400}],large_image_id = 2,small_image_id = 0,medal_start = 9,upgrade_power = 0,other_condition = [{dunid, 105}],title = "6"};

get_medal(61) ->
	#medal{id = 61,medal_name = "初阶",cost = [],add_attr = [{2,759997},{1,18997},{85,500}],large_image_id = 3,small_image_id = 0,medal_start = 0,upgrade_power = 37500000,other_condition = [],title = "7"};

get_medal(62) ->
	#medal{id = 62,medal_name = "一阶",cost = [],add_attr = [{2,771997},{1,19297},{85,500}],large_image_id = 3,small_image_id = 0,medal_start = 1,upgrade_power = 39480000,other_condition = [],title = "7"};

get_medal(63) ->
	#medal{id = 63,medal_name = "二阶",cost = [],add_attr = [{2,783997},{1,19597},{85,500}],large_image_id = 3,small_image_id = 0,medal_start = 2,upgrade_power = 41460000,other_condition = [],title = "7"};

get_medal(64) ->
	#medal{id = 64,medal_name = "三阶",cost = [],add_attr = [{2,795997},{1,19897},{85,500}],large_image_id = 3,small_image_id = 0,medal_start = 3,upgrade_power = 43440000,other_condition = [],title = "7"};

get_medal(65) ->
	#medal{id = 65,medal_name = "四阶",cost = [],add_attr = [{2,807997},{1,20197},{85,500}],large_image_id = 3,small_image_id = 0,medal_start = 4,upgrade_power = 45420000,other_condition = [],title = "7"};

get_medal(66) ->
	#medal{id = 66,medal_name = "五阶",cost = [],add_attr = [{2,819997},{1,20497},{85,500}],large_image_id = 3,small_image_id = 0,medal_start = 5,upgrade_power = 47400000,other_condition = [],title = "7"};

get_medal(67) ->
	#medal{id = 67,medal_name = "六阶",cost = [],add_attr = [{2,831997},{1,20797},{85,500}],large_image_id = 3,small_image_id = 0,medal_start = 6,upgrade_power = 49380000,other_condition = [],title = "7"};

get_medal(68) ->
	#medal{id = 68,medal_name = "七阶",cost = [],add_attr = [{2,843997},{1,21097},{85,500}],large_image_id = 3,small_image_id = 0,medal_start = 7,upgrade_power = 51360000,other_condition = [],title = "7"};

get_medal(69) ->
	#medal{id = 69,medal_name = "八阶",cost = [],add_attr = [{2,855997},{1,21397},{85,500}],large_image_id = 3,small_image_id = 0,medal_start = 8,upgrade_power = 53340000,other_condition = [],title = "7"};

get_medal(70) ->
	#medal{id = 70,medal_name = "九阶",cost = [{0,38040044,80}],add_attr = [{2,867997},{1,21697},{85,500}],large_image_id = 3,small_image_id = 0,medal_start = 9,upgrade_power = 0,other_condition = [{dunid, 140}],title = "7"};

get_medal(71) ->
	#medal{id = 71,medal_name = "初阶",cost = [],add_attr = [{2,1034664},{1,25864},{85,500}],large_image_id = 3,small_image_id = 0,medal_start = 0,upgrade_power = 74800000,other_condition = [],title = "8"};

get_medal(72) ->
	#medal{id = 72,medal_name = "一阶",cost = [],add_attr = [{2,1047731},{1,26191},{85,500}],large_image_id = 3,small_image_id = 0,medal_start = 1,upgrade_power = 77600000,other_condition = [],title = "8"};

get_medal(73) ->
	#medal{id = 73,medal_name = "二阶",cost = [],add_attr = [{2,1060798},{1,26518},{85,500}],large_image_id = 3,small_image_id = 0,medal_start = 2,upgrade_power = 80400000,other_condition = [],title = "8"};

get_medal(74) ->
	#medal{id = 74,medal_name = "三阶",cost = [],add_attr = [{2,1073865},{1,26845},{85,500}],large_image_id = 3,small_image_id = 0,medal_start = 3,upgrade_power = 83200000,other_condition = [],title = "8"};

get_medal(75) ->
	#medal{id = 75,medal_name = "四阶",cost = [],add_attr = [{2,1086932},{1,27172},{85,500}],large_image_id = 3,small_image_id = 0,medal_start = 4,upgrade_power = 86000000,other_condition = [],title = "8"};

get_medal(76) ->
	#medal{id = 76,medal_name = "五阶",cost = [],add_attr = [{2,1099999},{1,27499},{85,500}],large_image_id = 3,small_image_id = 0,medal_start = 5,upgrade_power = 88800000,other_condition = [],title = "8"};

get_medal(77) ->
	#medal{id = 77,medal_name = "六阶",cost = [],add_attr = [{2,1113066},{1,27826},{85,500}],large_image_id = 3,small_image_id = 0,medal_start = 6,upgrade_power = 91600000,other_condition = [],title = "8"};

get_medal(78) ->
	#medal{id = 78,medal_name = "七阶",cost = [],add_attr = [{2,1126133},{1,28153},{85,500}],large_image_id = 3,small_image_id = 0,medal_start = 7,upgrade_power = 94400000,other_condition = [],title = "8"};

get_medal(79) ->
	#medal{id = 79,medal_name = "八阶",cost = [],add_attr = [{2,1139200},{1,28480},{85,500}],large_image_id = 3,small_image_id = 0,medal_start = 8,upgrade_power = 97200000,other_condition = [],title = "8"};

get_medal(80) ->
	#medal{id = 80,medal_name = "九阶",cost = [{0,38040044,130}],add_attr = [{2,1152267},{1,28807},{85,500}],large_image_id = 3,small_image_id = 0,medal_start = 9,upgrade_power = 0,other_condition = [{dunid, 176}],title = "8"};

get_medal(81) ->
	#medal{id = 81,medal_name = "初阶",cost = [],add_attr = [{2,1346667},{1,33667},{85,500}],large_image_id = 3,small_image_id = 0,medal_start = 0,upgrade_power = 135000000,other_condition = [],title = "9"};

get_medal(82) ->
	#medal{id = 82,medal_name = "一阶",cost = [],add_attr = [{2,1360000},{1,34000},{85,500}],large_image_id = 3,small_image_id = 0,medal_start = 1,upgrade_power = 140000000,other_condition = [],title = "9"};

get_medal(83) ->
	#medal{id = 83,medal_name = "二阶",cost = [],add_attr = [{2,1373333},{1,34333},{85,500}],large_image_id = 3,small_image_id = 0,medal_start = 2,upgrade_power = 145000000,other_condition = [],title = "9"};

get_medal(84) ->
	#medal{id = 84,medal_name = "三阶",cost = [],add_attr = [{2,1386666},{1,34666},{85,500}],large_image_id = 3,small_image_id = 0,medal_start = 3,upgrade_power = 150000000,other_condition = [],title = "9"};

get_medal(85) ->
	#medal{id = 85,medal_name = "四阶",cost = [],add_attr = [{2,1399999},{1,34999},{85,500}],large_image_id = 3,small_image_id = 0,medal_start = 4,upgrade_power = 155000000,other_condition = [],title = "9"};

get_medal(86) ->
	#medal{id = 86,medal_name = "五阶",cost = [],add_attr = [{2,1413332},{1,35332},{85,500}],large_image_id = 3,small_image_id = 0,medal_start = 5,upgrade_power = 160000000,other_condition = [],title = "9"};

get_medal(87) ->
	#medal{id = 87,medal_name = "六阶",cost = [],add_attr = [{2,1426665},{1,35665},{85,500}],large_image_id = 3,small_image_id = 0,medal_start = 6,upgrade_power = 165000000,other_condition = [],title = "9"};

get_medal(88) ->
	#medal{id = 88,medal_name = "七阶",cost = [],add_attr = [{2,1439998},{1,35998},{85,500}],large_image_id = 3,small_image_id = 0,medal_start = 7,upgrade_power = 170000000,other_condition = [],title = "9"};

get_medal(89) ->
	#medal{id = 89,medal_name = "八阶",cost = [],add_attr = [{2,1453331},{1,36331},{85,500}],large_image_id = 3,small_image_id = 0,medal_start = 8,upgrade_power = 175000000,other_condition = [],title = "9"};

get_medal(90) ->
	#medal{id = 90,medal_name = "九阶",cost = [{0,38040044,180}],add_attr = [{2,1466664},{1,36664},{85,500}],large_image_id = 3,small_image_id = 0,medal_start = 9,upgrade_power = 0,other_condition = [{dunid, 213}],title = "9"};

get_medal(91) ->
	#medal{id = 91,medal_name = "初阶",cost = [],add_attr = [{2,1682664},{1,42064},{85,500}],large_image_id = 4,small_image_id = 0,medal_start = 0,upgrade_power = 256500000,other_condition = [],title = "10"};

get_medal(92) ->
	#medal{id = 92,medal_name = "一阶",cost = [],add_attr = [{2,1698664},{1,42464},{85,500}],large_image_id = 4,small_image_id = 0,medal_start = 1,upgrade_power = 263000000,other_condition = [],title = "10"};

get_medal(93) ->
	#medal{id = 93,medal_name = "二阶",cost = [],add_attr = [{2,1714664},{1,42864},{85,500}],large_image_id = 4,small_image_id = 0,medal_start = 2,upgrade_power = 269500000,other_condition = [],title = "10"};

get_medal(94) ->
	#medal{id = 94,medal_name = "三阶",cost = [],add_attr = [{2,1730664},{1,43264},{85,500}],large_image_id = 4,small_image_id = 0,medal_start = 3,upgrade_power = 276000000,other_condition = [],title = "10"};

get_medal(95) ->
	#medal{id = 95,medal_name = "四阶",cost = [],add_attr = [{2,1746664},{1,43664},{85,500}],large_image_id = 4,small_image_id = 0,medal_start = 4,upgrade_power = 282500000,other_condition = [],title = "10"};

get_medal(96) ->
	#medal{id = 96,medal_name = "五阶",cost = [],add_attr = [{2,1762664},{1,44064},{85,500}],large_image_id = 4,small_image_id = 0,medal_start = 5,upgrade_power = 289000000,other_condition = [],title = "10"};

get_medal(97) ->
	#medal{id = 97,medal_name = "六阶",cost = [],add_attr = [{2,1778664},{1,44464},{85,500}],large_image_id = 4,small_image_id = 0,medal_start = 6,upgrade_power = 295500000,other_condition = [],title = "10"};

get_medal(98) ->
	#medal{id = 98,medal_name = "七阶",cost = [],add_attr = [{2,1794664},{1,44864},{85,500}],large_image_id = 4,small_image_id = 0,medal_start = 7,upgrade_power = 302000000,other_condition = [],title = "10"};

get_medal(99) ->
	#medal{id = 99,medal_name = "八阶",cost = [],add_attr = [{2,1810664},{1,45264},{85,500}],large_image_id = 4,small_image_id = 0,medal_start = 8,upgrade_power = 308500000,other_condition = [],title = "10"};

get_medal(100) ->
	#medal{id = 100,medal_name = "九阶",cost = [{0,38040044,230}],add_attr = [{2,1826664},{1,45664},{85,500}],large_image_id = 4,small_image_id = 0,medal_start = 9,upgrade_power = 0,other_condition = [{dunid, 257}],title = "10"};

get_medal(101) ->
	#medal{id = 101,medal_name = "初阶",cost = [],add_attr = [{2,2053331},{1,51331},{85,500}],large_image_id = 4,small_image_id = 0,medal_start = 0,upgrade_power = 407500000,other_condition = [],title = "11"};

get_medal(102) ->
	#medal{id = 102,medal_name = "一阶",cost = [],add_attr = [{2,2070664},{1,51764},{85,500}],large_image_id = 4,small_image_id = 0,medal_start = 1,upgrade_power = 415000000,other_condition = [],title = "11"};

get_medal(103) ->
	#medal{id = 103,medal_name = "二阶",cost = [],add_attr = [{2,2087997},{1,52197},{85,500}],large_image_id = 4,small_image_id = 0,medal_start = 2,upgrade_power = 422500000,other_condition = [],title = "11"};

get_medal(104) ->
	#medal{id = 104,medal_name = "三阶",cost = [],add_attr = [{2,2105330},{1,52630},{85,500}],large_image_id = 4,small_image_id = 0,medal_start = 3,upgrade_power = 430000000,other_condition = [],title = "11"};

get_medal(105) ->
	#medal{id = 105,medal_name = "四阶",cost = [],add_attr = [{2,2122663},{1,53063},{85,500}],large_image_id = 4,small_image_id = 0,medal_start = 4,upgrade_power = 437500000,other_condition = [],title = "11"};

get_medal(106) ->
	#medal{id = 106,medal_name = "五阶",cost = [],add_attr = [{2,2139996},{1,53496},{85,500}],large_image_id = 4,small_image_id = 0,medal_start = 5,upgrade_power = 445000000,other_condition = [],title = "11"};

get_medal(107) ->
	#medal{id = 107,medal_name = "六阶",cost = [],add_attr = [{2,2157329},{1,53929},{85,500}],large_image_id = 4,small_image_id = 0,medal_start = 6,upgrade_power = 452500000,other_condition = [],title = "11"};

get_medal(108) ->
	#medal{id = 108,medal_name = "七阶",cost = [],add_attr = [{2,2174662},{1,54362},{85,500}],large_image_id = 4,small_image_id = 0,medal_start = 7,upgrade_power = 460000000,other_condition = [],title = "11"};

get_medal(109) ->
	#medal{id = 109,medal_name = "八阶",cost = [],add_attr = [{2,2191995},{1,54795},{85,500}],large_image_id = 4,small_image_id = 0,medal_start = 8,upgrade_power = 467500000,other_condition = [],title = "11"};

get_medal(110) ->
	#medal{id = 110,medal_name = "九阶",cost = [{0,38040044,280}],add_attr = [{2,2209328},{1,55228},{85,500}],large_image_id = 4,small_image_id = 0,medal_start = 9,upgrade_power = 0,other_condition = [{dunid, 290}],title = "11"};

get_medal(111) ->
	#medal{id = 111,medal_name = "初阶",cost = [],add_attr = [{2,2479995},{1,61995},{85,500}],large_image_id = 4,small_image_id = 0,medal_start = 0,upgrade_power = 590000000,other_condition = [],title = "12"};

get_medal(112) ->
	#medal{id = 112,medal_name = "一阶",cost = [],add_attr = [{2,2499995},{1,62495},{85,500}],large_image_id = 4,small_image_id = 0,medal_start = 1,upgrade_power = 600000000,other_condition = [],title = "12"};

get_medal(113) ->
	#medal{id = 113,medal_name = "二阶",cost = [],add_attr = [{2,2519995},{1,62995},{85,500}],large_image_id = 4,small_image_id = 0,medal_start = 2,upgrade_power = 610000000,other_condition = [],title = "12"};

get_medal(114) ->
	#medal{id = 114,medal_name = "三阶",cost = [],add_attr = [{2,2539995},{1,63495},{85,500}],large_image_id = 4,small_image_id = 0,medal_start = 3,upgrade_power = 620000000,other_condition = [],title = "12"};

get_medal(115) ->
	#medal{id = 115,medal_name = "四阶",cost = [],add_attr = [{2,2559995},{1,63995},{85,500}],large_image_id = 4,small_image_id = 0,medal_start = 4,upgrade_power = 630000000,other_condition = [],title = "12"};

get_medal(116) ->
	#medal{id = 116,medal_name = "五阶",cost = [],add_attr = [{2,2579995},{1,64495},{85,500}],large_image_id = 4,small_image_id = 0,medal_start = 5,upgrade_power = 640000000,other_condition = [],title = "12"};

get_medal(117) ->
	#medal{id = 117,medal_name = "六阶",cost = [],add_attr = [{2,2599995},{1,64995},{85,500}],large_image_id = 4,small_image_id = 0,medal_start = 6,upgrade_power = 650000000,other_condition = [],title = "12"};

get_medal(118) ->
	#medal{id = 118,medal_name = "七阶",cost = [],add_attr = [{2,2619995},{1,65495},{85,500}],large_image_id = 4,small_image_id = 0,medal_start = 7,upgrade_power = 660000000,other_condition = [],title = "12"};

get_medal(119) ->
	#medal{id = 119,medal_name = "八阶",cost = [],add_attr = [{2,2639995},{1,65995},{85,500}],large_image_id = 4,small_image_id = 0,medal_start = 8,upgrade_power = 670000000,other_condition = [],title = "12"};

get_medal(120) ->
	#medal{id = 120,medal_name = "九阶",cost = [{0,38040044,330}],add_attr = [{2,2659995},{1,66495},{85,500}],large_image_id = 4,small_image_id = 0,medal_start = 9,upgrade_power = 0,other_condition = [{dunid, 300}],title = "12"};

get_medal(121) ->
	#medal{id = 121,medal_name = "初阶",cost = [],add_attr = [{2,3003995},{1,75095},{85,500}],large_image_id = 5,small_image_id = 0,medal_start = 0,upgrade_power = 810000000,other_condition = [],title = "13"};

get_medal(122) ->
	#medal{id = 122,medal_name = "一阶",cost = [],add_attr = [{2,3026662},{1,75662},{85,500}],large_image_id = 5,small_image_id = 0,medal_start = 1,upgrade_power = 820000000,other_condition = [],title = "13"};

get_medal(123) ->
	#medal{id = 123,medal_name = "二阶",cost = [],add_attr = [{2,3049329},{1,76229},{85,500}],large_image_id = 5,small_image_id = 0,medal_start = 2,upgrade_power = 830000000,other_condition = [],title = "13"};

get_medal(124) ->
	#medal{id = 124,medal_name = "三阶",cost = [],add_attr = [{2,3071996},{1,76796},{85,500}],large_image_id = 5,small_image_id = 0,medal_start = 3,upgrade_power = 840000000,other_condition = [],title = "13"};

get_medal(125) ->
	#medal{id = 125,medal_name = "四阶",cost = [],add_attr = [{2,3094663},{1,77363},{85,500}],large_image_id = 5,small_image_id = 0,medal_start = 4,upgrade_power = 850000000,other_condition = [],title = "13"};

get_medal(126) ->
	#medal{id = 126,medal_name = "五阶",cost = [],add_attr = [{2,3117330},{1,77930},{85,500}],large_image_id = 5,small_image_id = 0,medal_start = 5,upgrade_power = 860000000,other_condition = [],title = "13"};

get_medal(127) ->
	#medal{id = 127,medal_name = "六阶",cost = [],add_attr = [{2,3139997},{1,78497},{85,500}],large_image_id = 5,small_image_id = 0,medal_start = 6,upgrade_power = 870000000,other_condition = [],title = "13"};

get_medal(128) ->
	#medal{id = 128,medal_name = "七阶",cost = [],add_attr = [{2,3162664},{1,79064},{85,500}],large_image_id = 5,small_image_id = 0,medal_start = 7,upgrade_power = 880000000,other_condition = [],title = "13"};

get_medal(129) ->
	#medal{id = 129,medal_name = "八阶",cost = [],add_attr = [{2,3185331},{1,79631},{85,500}],large_image_id = 5,small_image_id = 0,medal_start = 8,upgrade_power = 890000000,other_condition = [],title = "13"};

get_medal(130) ->
	#medal{id = 130,medal_name = "九阶",cost = [{0,38040044,400}],add_attr = [{2,3207998},{1,80198},{85,500}],large_image_id = 5,small_image_id = 0,medal_start = 9,upgrade_power = 0,other_condition = [{dunid, 300}],title = "13"};

get_medal(131) ->
	#medal{id = 131,medal_name = "满阶",cost = [],add_attr = [{2,3613331},{1,90331},{85,500}],large_image_id = 6,small_image_id = 0,medal_start = 0,upgrade_power = 0,other_condition = [],title = "14"};

get_medal(_Id) ->
	[].


get_new_medal_id(1) ->
{1,[]};


get_new_medal_id(2) ->
{15,[{0,38040044,3}]};


get_new_medal_id(3) ->
{20,[{0,38040044,3}]};


get_new_medal_id(4) ->
{20,[{0,38040044,3}]};


get_new_medal_id(5) ->
{30,[{0,38040044,5}]};


get_new_medal_id(6) ->
{30,[{0,38040044,5}]};


get_new_medal_id(7) ->
{30,[{0,38040044,5}]};


get_new_medal_id(8) ->
{40,[{0,38040044,8}]};


get_new_medal_id(9) ->
{40,[{0,38040044,8}]};


get_new_medal_id(10) ->
{40,[{0,38040044,8}]};


get_new_medal_id(11) ->
{50,[{0,38040044,10}]};


get_new_medal_id(12) ->
{50,[{0,38040044,10}]};


get_new_medal_id(13) ->
{55,[{0,38040044,10}]};


get_new_medal_id(14) ->
{60,[{0,38040045,5}]};


get_new_medal_id(15) ->
{60,[{0,38040045,5}]};


get_new_medal_id(16) ->
{70,[{0,38040045,8}]};


get_new_medal_id(17) ->
{70,[{0,38040045,8}]};


get_new_medal_id(18) ->
{80,[{0,38040045,10}]};


get_new_medal_id(19) ->
{80,[{0,38040045,10}]};


get_new_medal_id(20) ->
{80,[{0,38040045,10}]};


get_new_medal_id(21) ->
{90,[{0,38040045,14}]};


get_new_medal_id(22) ->
{90,[{0,38040045,14}]};


get_new_medal_id(23) ->
{100,[{0,38040046,8}]};


get_new_medal_id(24) ->
{100,[{0,38040046,8}]};


get_new_medal_id(25) ->
{100,[{0,38040046,8}]};


get_new_medal_id(26) ->
{110,[{0,38040046,10}]};


get_new_medal_id(27) ->
{110,[{0,38040046,10}]};


get_new_medal_id(28) ->
{110,[{0,38040046,10}]};


get_new_medal_id(29) ->
{120,[{0,38040046,12}]};


get_new_medal_id(30) ->
{120,[{0,38040046,12}]};


get_new_medal_id(31) ->
{120,[{0,38040046,12}]};


get_new_medal_id(32) ->
{128,[{0,38040046,12}]};


get_new_medal_id(33) ->
{130,[{0,38040046,14}]};


get_new_medal_id(34) ->
{130,[{0,38040046,14}]};


get_new_medal_id(35) ->
{130,[{0,38040046,14}]};


get_new_medal_id(36) ->
{140,[{0,38040047,10}]};


get_new_medal_id(37) ->
{140,[{0,38040047,10}]};


get_new_medal_id(38) ->
{140,[{0,38040047,10}]};


get_new_medal_id(39) ->
{150,[{0,38040047,14}]};


get_new_medal_id(40) ->
{150,[{0,38040047,14}]};


get_new_medal_id(41) ->
{150,[{0,38040047,14}]};


get_new_medal_id(42) ->
{160,[{0,38040047,18}]};


get_new_medal_id(43) ->
{160,[{0,38040047,18}]};


get_new_medal_id(44) ->
{160,[{0,38040047,18}]};


get_new_medal_id(45) ->
{166,[{0,38040047,18}]};


get_new_medal_id(46) ->
{170,[{0,38040047,20}]};


get_new_medal_id(47) ->
{170,[{0,38040047,20}]};


get_new_medal_id(48) ->
{170,[{0,38040047,20}]};


get_new_medal_id(49) ->
{180,[{0,38040047,20}]};


get_new_medal_id(50) ->
{180,[{0,38040047,20}]};


get_new_medal_id(51) ->
{180,[{0,38040047,20}]};

get_new_medal_id(_Oldid) ->
	[].


get_need_exp(1) ->
10;


get_need_exp(2) ->
11;


get_need_exp(3) ->
12;


get_need_exp(4) ->
13;


get_need_exp(5) ->
14;


get_need_exp(6) ->
15;


get_need_exp(7) ->
16;


get_need_exp(8) ->
17;


get_need_exp(9) ->
18;


get_need_exp(10) ->
19;


get_need_exp(11) ->
20;


get_need_exp(12) ->
21;


get_need_exp(13) ->
22;


get_need_exp(14) ->
23;


get_need_exp(15) ->
24;


get_need_exp(16) ->
25;


get_need_exp(17) ->
26;


get_need_exp(18) ->
27;


get_need_exp(19) ->
28;


get_need_exp(20) ->
29;


get_need_exp(21) ->
30;


get_need_exp(22) ->
31;


get_need_exp(23) ->
32;


get_need_exp(24) ->
33;


get_need_exp(25) ->
34;


get_need_exp(26) ->
35;


get_need_exp(27) ->
36;


get_need_exp(28) ->
37;


get_need_exp(29) ->
38;


get_need_exp(30) ->
39;


get_need_exp(31) ->
41;


get_need_exp(32) ->
43;


get_need_exp(33) ->
45;


get_need_exp(34) ->
47;


get_need_exp(35) ->
49;


get_need_exp(36) ->
51;


get_need_exp(37) ->
53;


get_need_exp(38) ->
55;


get_need_exp(39) ->
57;


get_need_exp(40) ->
59;


get_need_exp(41) ->
61;


get_need_exp(42) ->
63;


get_need_exp(43) ->
65;


get_need_exp(44) ->
67;


get_need_exp(45) ->
69;


get_need_exp(46) ->
71;


get_need_exp(47) ->
73;


get_need_exp(48) ->
75;


get_need_exp(49) ->
77;


get_need_exp(50) ->
79;


get_need_exp(51) ->
82;


get_need_exp(52) ->
85;


get_need_exp(53) ->
88;


get_need_exp(54) ->
91;


get_need_exp(55) ->
94;


get_need_exp(56) ->
97;


get_need_exp(57) ->
100;


get_need_exp(58) ->
103;


get_need_exp(59) ->
106;


get_need_exp(60) ->
109;


get_need_exp(61) ->
112;


get_need_exp(62) ->
115;


get_need_exp(63) ->
118;


get_need_exp(64) ->
121;


get_need_exp(65) ->
124;


get_need_exp(66) ->
127;


get_need_exp(67) ->
130;


get_need_exp(68) ->
133;


get_need_exp(69) ->
136;


get_need_exp(70) ->
139;


get_need_exp(71) ->
142;


get_need_exp(72) ->
145;


get_need_exp(73) ->
148;


get_need_exp(74) ->
151;


get_need_exp(75) ->
154;


get_need_exp(76) ->
157;


get_need_exp(77) ->
160;


get_need_exp(78) ->
163;


get_need_exp(79) ->
166;


get_need_exp(80) ->
169;


get_need_exp(81) ->
173;


get_need_exp(82) ->
177;


get_need_exp(83) ->
181;


get_need_exp(84) ->
185;


get_need_exp(85) ->
189;


get_need_exp(86) ->
193;


get_need_exp(87) ->
197;


get_need_exp(88) ->
201;


get_need_exp(89) ->
205;


get_need_exp(90) ->
209;


get_need_exp(91) ->
213;


get_need_exp(92) ->
217;


get_need_exp(93) ->
221;


get_need_exp(94) ->
225;


get_need_exp(95) ->
229;


get_need_exp(96) ->
233;


get_need_exp(97) ->
237;


get_need_exp(98) ->
241;


get_need_exp(99) ->
245;


get_need_exp(100) ->
249;


get_need_exp(101) ->
254;


get_need_exp(102) ->
259;


get_need_exp(103) ->
264;


get_need_exp(104) ->
269;


get_need_exp(105) ->
274;


get_need_exp(106) ->
279;


get_need_exp(107) ->
284;


get_need_exp(108) ->
289;


get_need_exp(109) ->
294;


get_need_exp(110) ->
299;


get_need_exp(111) ->
304;


get_need_exp(112) ->
309;


get_need_exp(113) ->
314;


get_need_exp(114) ->
319;


get_need_exp(115) ->
324;


get_need_exp(116) ->
329;


get_need_exp(117) ->
334;


get_need_exp(118) ->
339;


get_need_exp(119) ->
344;


get_need_exp(120) ->
349;


get_need_exp(121) ->
354;


get_need_exp(122) ->
359;


get_need_exp(123) ->
364;


get_need_exp(124) ->
369;


get_need_exp(125) ->
374;


get_need_exp(126) ->
379;


get_need_exp(127) ->
384;


get_need_exp(128) ->
389;


get_need_exp(129) ->
394;


get_need_exp(130) ->
399;


get_need_exp(131) ->
404;


get_need_exp(132) ->
409;


get_need_exp(133) ->
414;


get_need_exp(134) ->
419;


get_need_exp(135) ->
424;


get_need_exp(136) ->
429;


get_need_exp(137) ->
434;


get_need_exp(138) ->
439;


get_need_exp(139) ->
444;


get_need_exp(140) ->
449;


get_need_exp(141) ->
454;


get_need_exp(142) ->
459;


get_need_exp(143) ->
464;


get_need_exp(144) ->
469;


get_need_exp(145) ->
474;


get_need_exp(146) ->
479;


get_need_exp(147) ->
484;


get_need_exp(148) ->
489;


get_need_exp(149) ->
494;


get_need_exp(150) ->
500;


get_need_exp(151) ->
506;


get_need_exp(152) ->
512;


get_need_exp(153) ->
518;


get_need_exp(154) ->
524;


get_need_exp(155) ->
530;


get_need_exp(156) ->
536;


get_need_exp(157) ->
542;


get_need_exp(158) ->
548;


get_need_exp(159) ->
554;


get_need_exp(160) ->
560;


get_need_exp(161) ->
566;


get_need_exp(162) ->
572;


get_need_exp(163) ->
578;


get_need_exp(164) ->
584;


get_need_exp(165) ->
590;


get_need_exp(166) ->
596;


get_need_exp(167) ->
602;


get_need_exp(168) ->
608;


get_need_exp(169) ->
614;


get_need_exp(170) ->
620;


get_need_exp(171) ->
626;


get_need_exp(172) ->
632;


get_need_exp(173) ->
638;


get_need_exp(174) ->
644;


get_need_exp(175) ->
650;


get_need_exp(176) ->
656;


get_need_exp(177) ->
662;


get_need_exp(178) ->
668;


get_need_exp(179) ->
674;


get_need_exp(180) ->
680;


get_need_exp(181) ->
686;


get_need_exp(182) ->
692;


get_need_exp(183) ->
698;


get_need_exp(184) ->
704;


get_need_exp(185) ->
710;


get_need_exp(186) ->
716;


get_need_exp(187) ->
722;


get_need_exp(188) ->
728;


get_need_exp(189) ->
734;


get_need_exp(190) ->
740;


get_need_exp(191) ->
746;


get_need_exp(192) ->
752;


get_need_exp(193) ->
758;


get_need_exp(194) ->
764;


get_need_exp(195) ->
770;


get_need_exp(196) ->
776;


get_need_exp(197) ->
782;


get_need_exp(198) ->
788;


get_need_exp(199) ->
794;


get_need_exp(200) ->
800;


get_need_exp(201) ->
807;


get_need_exp(202) ->
814;


get_need_exp(203) ->
821;


get_need_exp(204) ->
828;


get_need_exp(205) ->
835;


get_need_exp(206) ->
842;


get_need_exp(207) ->
849;


get_need_exp(208) ->
856;


get_need_exp(209) ->
863;


get_need_exp(210) ->
870;


get_need_exp(211) ->
877;


get_need_exp(212) ->
884;


get_need_exp(213) ->
891;


get_need_exp(214) ->
898;


get_need_exp(215) ->
905;


get_need_exp(216) ->
912;


get_need_exp(217) ->
919;


get_need_exp(218) ->
926;


get_need_exp(219) ->
933;


get_need_exp(220) ->
940;


get_need_exp(221) ->
947;


get_need_exp(222) ->
954;


get_need_exp(223) ->
961;


get_need_exp(224) ->
968;


get_need_exp(225) ->
975;


get_need_exp(226) ->
982;


get_need_exp(227) ->
989;


get_need_exp(228) ->
996;


get_need_exp(229) ->
1003;


get_need_exp(230) ->
1010;


get_need_exp(231) ->
1017;


get_need_exp(232) ->
1024;


get_need_exp(233) ->
1031;


get_need_exp(234) ->
1038;


get_need_exp(235) ->
1045;


get_need_exp(236) ->
1052;


get_need_exp(237) ->
1059;


get_need_exp(238) ->
1066;


get_need_exp(239) ->
1073;


get_need_exp(240) ->
1080;


get_need_exp(241) ->
1087;


get_need_exp(242) ->
1094;


get_need_exp(243) ->
1101;


get_need_exp(244) ->
1108;


get_need_exp(245) ->
1115;


get_need_exp(246) ->
1122;


get_need_exp(247) ->
1129;


get_need_exp(248) ->
1136;


get_need_exp(249) ->
1143;


get_need_exp(250) ->
1150;


get_need_exp(251) ->
1157;


get_need_exp(252) ->
1164;


get_need_exp(253) ->
1171;


get_need_exp(254) ->
1178;


get_need_exp(255) ->
1185;


get_need_exp(256) ->
1192;


get_need_exp(257) ->
1199;


get_need_exp(258) ->
1206;


get_need_exp(259) ->
1213;


get_need_exp(260) ->
1220;


get_need_exp(261) ->
1227;


get_need_exp(262) ->
1234;


get_need_exp(263) ->
1241;


get_need_exp(264) ->
1248;


get_need_exp(265) ->
1255;


get_need_exp(266) ->
1262;


get_need_exp(267) ->
1269;


get_need_exp(268) ->
1276;


get_need_exp(269) ->
1283;


get_need_exp(270) ->
1290;


get_need_exp(271) ->
1297;


get_need_exp(272) ->
1304;


get_need_exp(273) ->
1311;


get_need_exp(274) ->
1318;


get_need_exp(275) ->
1325;


get_need_exp(276) ->
1332;


get_need_exp(277) ->
1339;


get_need_exp(278) ->
1346;


get_need_exp(279) ->
1353;


get_need_exp(280) ->
1360;


get_need_exp(281) ->
1367;


get_need_exp(282) ->
1374;


get_need_exp(283) ->
1381;


get_need_exp(284) ->
1388;


get_need_exp(285) ->
1395;


get_need_exp(286) ->
1402;


get_need_exp(287) ->
1409;


get_need_exp(288) ->
1416;


get_need_exp(289) ->
1423;


get_need_exp(290) ->
1430;


get_need_exp(291) ->
1437;


get_need_exp(292) ->
1444;


get_need_exp(293) ->
1451;


get_need_exp(294) ->
1458;


get_need_exp(295) ->
1465;


get_need_exp(296) ->
1472;


get_need_exp(297) ->
1479;


get_need_exp(298) ->
1486;


get_need_exp(299) ->
1493;


get_need_exp(300) ->
1500;


get_need_exp(301) ->
1508;


get_need_exp(302) ->
1516;


get_need_exp(303) ->
1524;


get_need_exp(304) ->
1532;


get_need_exp(305) ->
1540;


get_need_exp(306) ->
1548;


get_need_exp(307) ->
1556;


get_need_exp(308) ->
1564;


get_need_exp(309) ->
1572;


get_need_exp(310) ->
1580;


get_need_exp(311) ->
1588;


get_need_exp(312) ->
1596;


get_need_exp(313) ->
1604;


get_need_exp(314) ->
1612;


get_need_exp(315) ->
1620;


get_need_exp(316) ->
1628;


get_need_exp(317) ->
1636;


get_need_exp(318) ->
1644;


get_need_exp(319) ->
1652;


get_need_exp(320) ->
1660;


get_need_exp(321) ->
1668;


get_need_exp(322) ->
1676;


get_need_exp(323) ->
1684;


get_need_exp(324) ->
1692;


get_need_exp(325) ->
1700;


get_need_exp(326) ->
1708;


get_need_exp(327) ->
1716;


get_need_exp(328) ->
1724;


get_need_exp(329) ->
1732;


get_need_exp(330) ->
1740;


get_need_exp(331) ->
1748;


get_need_exp(332) ->
1756;


get_need_exp(333) ->
1764;


get_need_exp(334) ->
1772;


get_need_exp(335) ->
1780;


get_need_exp(336) ->
1788;


get_need_exp(337) ->
1796;


get_need_exp(338) ->
1804;


get_need_exp(339) ->
1812;


get_need_exp(340) ->
1820;


get_need_exp(341) ->
1828;


get_need_exp(342) ->
1836;


get_need_exp(343) ->
1844;


get_need_exp(344) ->
1852;


get_need_exp(345) ->
1860;


get_need_exp(346) ->
1868;


get_need_exp(347) ->
1876;


get_need_exp(348) ->
1884;


get_need_exp(349) ->
1892;


get_need_exp(350) ->
1900;


get_need_exp(351) ->
1910;


get_need_exp(352) ->
1920;


get_need_exp(353) ->
1930;


get_need_exp(354) ->
1940;


get_need_exp(355) ->
1950;


get_need_exp(356) ->
1960;


get_need_exp(357) ->
1970;


get_need_exp(358) ->
1980;


get_need_exp(359) ->
1990;


get_need_exp(360) ->
2000;


get_need_exp(361) ->
2010;


get_need_exp(362) ->
2020;


get_need_exp(363) ->
2030;


get_need_exp(364) ->
2040;


get_need_exp(365) ->
2050;


get_need_exp(366) ->
2060;


get_need_exp(367) ->
2070;


get_need_exp(368) ->
2080;


get_need_exp(369) ->
2090;


get_need_exp(370) ->
2100;


get_need_exp(371) ->
2110;


get_need_exp(372) ->
2120;


get_need_exp(373) ->
2130;


get_need_exp(374) ->
2140;


get_need_exp(375) ->
2150;


get_need_exp(376) ->
2160;


get_need_exp(377) ->
2170;


get_need_exp(378) ->
2180;


get_need_exp(379) ->
2190;


get_need_exp(380) ->
2200;


get_need_exp(381) ->
2210;


get_need_exp(382) ->
2220;


get_need_exp(383) ->
2230;


get_need_exp(384) ->
2240;


get_need_exp(385) ->
2250;


get_need_exp(386) ->
2260;


get_need_exp(387) ->
2270;


get_need_exp(388) ->
2280;


get_need_exp(389) ->
2290;


get_need_exp(390) ->
2300;


get_need_exp(391) ->
2310;


get_need_exp(392) ->
2320;


get_need_exp(393) ->
2330;


get_need_exp(394) ->
2340;


get_need_exp(395) ->
2350;


get_need_exp(396) ->
2360;


get_need_exp(397) ->
2370;


get_need_exp(398) ->
2380;


get_need_exp(399) ->
2390;


get_need_exp(400) ->
2400;

get_need_exp(_Lv) ->
	0.


get_attr(1) ->
[{1,10},{2,200},{3,5},{4,5}];


get_attr(2) ->
[{1,20},{2,400},{3,10},{4,10}];


get_attr(3) ->
[{1,30},{2,600},{3,15},{4,15}];


get_attr(4) ->
[{1,40},{2,800},{3,20},{4,20}];


get_attr(5) ->
[{1,50},{2,1000},{3,25},{4,25}];


get_attr(6) ->
[{1,60},{2,1200},{3,30},{4,30}];


get_attr(7) ->
[{1,70},{2,1400},{3,35},{4,35}];


get_attr(8) ->
[{1,80},{2,1600},{3,40},{4,40}];


get_attr(9) ->
[{1,90},{2,1800},{3,45},{4,45}];


get_attr(10) ->
[{1,100},{2,2000},{3,50},{4,50}];


get_attr(11) ->
[{1,112},{2,2240},{3,56},{4,56}];


get_attr(12) ->
[{1,124},{2,2480},{3,62},{4,62}];


get_attr(13) ->
[{1,136},{2,2720},{3,68},{4,68}];


get_attr(14) ->
[{1,148},{2,2960},{3,74},{4,74}];


get_attr(15) ->
[{1,160},{2,3200},{3,80},{4,80}];


get_attr(16) ->
[{1,172},{2,3440},{3,86},{4,86}];


get_attr(17) ->
[{1,184},{2,3680},{3,92},{4,92}];


get_attr(18) ->
[{1,196},{2,3920},{3,98},{4,98}];


get_attr(19) ->
[{1,208},{2,4160},{3,104},{4,104}];


get_attr(20) ->
[{1,220},{2,4400},{3,110},{4,110}];


get_attr(21) ->
[{1,234},{2,4680},{3,117},{4,117}];


get_attr(22) ->
[{1,248},{2,4960},{3,124},{4,124}];


get_attr(23) ->
[{1,262},{2,5240},{3,131},{4,131}];


get_attr(24) ->
[{1,276},{2,5520},{3,138},{4,138}];


get_attr(25) ->
[{1,290},{2,5800},{3,145},{4,145}];


get_attr(26) ->
[{1,304},{2,6080},{3,152},{4,152}];


get_attr(27) ->
[{1,318},{2,6360},{3,159},{4,159}];


get_attr(28) ->
[{1,332},{2,6640},{3,166},{4,166}];


get_attr(29) ->
[{1,346},{2,6920},{3,173},{4,173}];


get_attr(30) ->
[{1,360},{2,7200},{3,180},{4,180}];


get_attr(31) ->
[{1,376},{2,7520},{3,188},{4,188}];


get_attr(32) ->
[{1,392},{2,7840},{3,196},{4,196}];


get_attr(33) ->
[{1,408},{2,8160},{3,204},{4,204}];


get_attr(34) ->
[{1,424},{2,8480},{3,212},{4,212}];


get_attr(35) ->
[{1,440},{2,8800},{3,220},{4,220}];


get_attr(36) ->
[{1,456},{2,9120},{3,228},{4,228}];


get_attr(37) ->
[{1,472},{2,9440},{3,236},{4,236}];


get_attr(38) ->
[{1,488},{2,9760},{3,244},{4,244}];


get_attr(39) ->
[{1,504},{2,10080},{3,252},{4,252}];


get_attr(40) ->
[{1,520},{2,10400},{3,260},{4,260}];


get_attr(41) ->
[{1,538},{2,10760},{3,269},{4,269}];


get_attr(42) ->
[{1,556},{2,11120},{3,278},{4,278}];


get_attr(43) ->
[{1,574},{2,11480},{3,287},{4,287}];


get_attr(44) ->
[{1,592},{2,11840},{3,296},{4,296}];


get_attr(45) ->
[{1,610},{2,12200},{3,305},{4,305}];


get_attr(46) ->
[{1,628},{2,12560},{3,314},{4,314}];


get_attr(47) ->
[{1,646},{2,12920},{3,323},{4,323}];


get_attr(48) ->
[{1,664},{2,13280},{3,332},{4,332}];


get_attr(49) ->
[{1,682},{2,13640},{3,341},{4,341}];


get_attr(50) ->
[{1,700},{2,14000},{3,350},{4,350}];


get_attr(51) ->
[{1,720},{2,14400},{3,360},{4,360}];


get_attr(52) ->
[{1,740},{2,14800},{3,370},{4,370}];


get_attr(53) ->
[{1,760},{2,15200},{3,380},{4,380}];


get_attr(54) ->
[{1,780},{2,15600},{3,390},{4,390}];


get_attr(55) ->
[{1,800},{2,16000},{3,400},{4,400}];


get_attr(56) ->
[{1,820},{2,16400},{3,410},{4,410}];


get_attr(57) ->
[{1,840},{2,16800},{3,420},{4,420}];


get_attr(58) ->
[{1,860},{2,17200},{3,430},{4,430}];


get_attr(59) ->
[{1,880},{2,17600},{3,440},{4,440}];


get_attr(60) ->
[{1,900},{2,18000},{3,450},{4,450}];


get_attr(61) ->
[{1,922},{2,18440},{3,461},{4,461}];


get_attr(62) ->
[{1,944},{2,18880},{3,472},{4,472}];


get_attr(63) ->
[{1,966},{2,19320},{3,483},{4,483}];


get_attr(64) ->
[{1,988},{2,19760},{3,494},{4,494}];


get_attr(65) ->
[{1,1010},{2,20200},{3,505},{4,505}];


get_attr(66) ->
[{1,1032},{2,20640},{3,516},{4,516}];


get_attr(67) ->
[{1,1054},{2,21080},{3,527},{4,527}];


get_attr(68) ->
[{1,1076},{2,21520},{3,538},{4,538}];


get_attr(69) ->
[{1,1098},{2,21960},{3,549},{4,549}];


get_attr(70) ->
[{1,1120},{2,22400},{3,560},{4,560}];


get_attr(71) ->
[{1,1145},{2,22900},{3,573},{4,573}];


get_attr(72) ->
[{1,1170},{2,23400},{3,585},{4,585}];


get_attr(73) ->
[{1,1195},{2,23900},{3,598},{4,598}];


get_attr(74) ->
[{1,1220},{2,24400},{3,610},{4,610}];


get_attr(75) ->
[{1,1245},{2,24900},{3,623},{4,623}];


get_attr(76) ->
[{1,1270},{2,25400},{3,635},{4,635}];


get_attr(77) ->
[{1,1295},{2,25900},{3,648},{4,648}];


get_attr(78) ->
[{1,1320},{2,26400},{3,660},{4,660}];


get_attr(79) ->
[{1,1345},{2,26900},{3,673},{4,673}];


get_attr(80) ->
[{1,1370},{2,27400},{3,685},{4,685}];


get_attr(81) ->
[{1,1395},{2,27900},{3,698},{4,698}];


get_attr(82) ->
[{1,1420},{2,28400},{3,710},{4,710}];


get_attr(83) ->
[{1,1445},{2,28900},{3,723},{4,723}];


get_attr(84) ->
[{1,1470},{2,29400},{3,735},{4,735}];


get_attr(85) ->
[{1,1495},{2,29900},{3,748},{4,748}];


get_attr(86) ->
[{1,1520},{2,30400},{3,760},{4,760}];


get_attr(87) ->
[{1,1545},{2,30900},{3,773},{4,773}];


get_attr(88) ->
[{1,1570},{2,31400},{3,785},{4,785}];


get_attr(89) ->
[{1,1595},{2,31900},{3,798},{4,798}];


get_attr(90) ->
[{1,1620},{2,32400},{3,810},{4,810}];


get_attr(91) ->
[{1,1645},{2,32900},{3,823},{4,823}];


get_attr(92) ->
[{1,1670},{2,33400},{3,835},{4,835}];


get_attr(93) ->
[{1,1695},{2,33900},{3,848},{4,848}];


get_attr(94) ->
[{1,1720},{2,34400},{3,860},{4,860}];


get_attr(95) ->
[{1,1745},{2,34900},{3,873},{4,873}];


get_attr(96) ->
[{1,1770},{2,35400},{3,885},{4,885}];


get_attr(97) ->
[{1,1795},{2,35900},{3,898},{4,898}];


get_attr(98) ->
[{1,1820},{2,36400},{3,910},{4,910}];


get_attr(99) ->
[{1,1845},{2,36900},{3,923},{4,923}];


get_attr(100) ->
[{1,1870},{2,37400},{3,935},{4,935}];


get_attr(101) ->
[{1,1895},{2,37900},{3,948},{4,948}];


get_attr(102) ->
[{1,1920},{2,38400},{3,960},{4,960}];


get_attr(103) ->
[{1,1945},{2,38900},{3,973},{4,973}];


get_attr(104) ->
[{1,1970},{2,39400},{3,985},{4,985}];


get_attr(105) ->
[{1,1995},{2,39900},{3,998},{4,998}];


get_attr(106) ->
[{1,2020},{2,40400},{3,1010},{4,1010}];


get_attr(107) ->
[{1,2045},{2,40900},{3,1023},{4,1023}];


get_attr(108) ->
[{1,2070},{2,41400},{3,1035},{4,1035}];


get_attr(109) ->
[{1,2095},{2,41900},{3,1048},{4,1048}];


get_attr(110) ->
[{1,2120},{2,42400},{3,1060},{4,1060}];


get_attr(111) ->
[{1,2145},{2,42900},{3,1073},{4,1073}];


get_attr(112) ->
[{1,2170},{2,43400},{3,1085},{4,1085}];


get_attr(113) ->
[{1,2195},{2,43900},{3,1098},{4,1098}];


get_attr(114) ->
[{1,2220},{2,44400},{3,1110},{4,1110}];


get_attr(115) ->
[{1,2245},{2,44900},{3,1123},{4,1123}];


get_attr(116) ->
[{1,2270},{2,45400},{3,1135},{4,1135}];


get_attr(117) ->
[{1,2295},{2,45900},{3,1148},{4,1148}];


get_attr(118) ->
[{1,2320},{2,46400},{3,1160},{4,1160}];


get_attr(119) ->
[{1,2345},{2,46900},{3,1173},{4,1173}];


get_attr(120) ->
[{1,2370},{2,47400},{3,1185},{4,1185}];


get_attr(121) ->
[{1,2395},{2,47900},{3,1198},{4,1198}];


get_attr(122) ->
[{1,2420},{2,48400},{3,1210},{4,1210}];


get_attr(123) ->
[{1,2445},{2,48900},{3,1223},{4,1223}];


get_attr(124) ->
[{1,2470},{2,49400},{3,1235},{4,1235}];


get_attr(125) ->
[{1,2495},{2,49900},{3,1248},{4,1248}];


get_attr(126) ->
[{1,2520},{2,50400},{3,1260},{4,1260}];


get_attr(127) ->
[{1,2545},{2,50900},{3,1273},{4,1273}];


get_attr(128) ->
[{1,2570},{2,51400},{3,1285},{4,1285}];


get_attr(129) ->
[{1,2595},{2,51900},{3,1298},{4,1298}];


get_attr(130) ->
[{1,2620},{2,52400},{3,1310},{4,1310}];


get_attr(131) ->
[{1,2645},{2,52900},{3,1323},{4,1323}];


get_attr(132) ->
[{1,2670},{2,53400},{3,1335},{4,1335}];


get_attr(133) ->
[{1,2695},{2,53900},{3,1348},{4,1348}];


get_attr(134) ->
[{1,2720},{2,54400},{3,1360},{4,1360}];


get_attr(135) ->
[{1,2745},{2,54900},{3,1373},{4,1373}];


get_attr(136) ->
[{1,2770},{2,55400},{3,1385},{4,1385}];


get_attr(137) ->
[{1,2795},{2,55900},{3,1398},{4,1398}];


get_attr(138) ->
[{1,2820},{2,56400},{3,1410},{4,1410}];


get_attr(139) ->
[{1,2845},{2,56900},{3,1423},{4,1423}];


get_attr(140) ->
[{1,2870},{2,57400},{3,1435},{4,1435}];


get_attr(141) ->
[{1,2895},{2,57900},{3,1448},{4,1448}];


get_attr(142) ->
[{1,2920},{2,58400},{3,1460},{4,1460}];


get_attr(143) ->
[{1,2945},{2,58900},{3,1473},{4,1473}];


get_attr(144) ->
[{1,2970},{2,59400},{3,1485},{4,1485}];


get_attr(145) ->
[{1,2995},{2,59900},{3,1498},{4,1498}];


get_attr(146) ->
[{1,3020},{2,60400},{3,1510},{4,1510}];


get_attr(147) ->
[{1,3045},{2,60900},{3,1523},{4,1523}];


get_attr(148) ->
[{1,3070},{2,61400},{3,1535},{4,1535}];


get_attr(149) ->
[{1,3095},{2,61900},{3,1548},{4,1548}];


get_attr(150) ->
[{1,3120},{2,62400},{3,1560},{4,1560}];


get_attr(151) ->
[{1,3145},{2,62900},{3,1573},{4,1573}];


get_attr(152) ->
[{1,3170},{2,63400},{3,1585},{4,1585}];


get_attr(153) ->
[{1,3195},{2,63900},{3,1598},{4,1598}];


get_attr(154) ->
[{1,3220},{2,64400},{3,1610},{4,1610}];


get_attr(155) ->
[{1,3245},{2,64900},{3,1623},{4,1623}];


get_attr(156) ->
[{1,3270},{2,65400},{3,1635},{4,1635}];


get_attr(157) ->
[{1,3295},{2,65900},{3,1648},{4,1648}];


get_attr(158) ->
[{1,3320},{2,66400},{3,1660},{4,1660}];


get_attr(159) ->
[{1,3345},{2,66900},{3,1673},{4,1673}];


get_attr(160) ->
[{1,3370},{2,67400},{3,1685},{4,1685}];


get_attr(161) ->
[{1,3395},{2,67900},{3,1698},{4,1698}];


get_attr(162) ->
[{1,3420},{2,68400},{3,1710},{4,1710}];


get_attr(163) ->
[{1,3445},{2,68900},{3,1723},{4,1723}];


get_attr(164) ->
[{1,3470},{2,69400},{3,1735},{4,1735}];


get_attr(165) ->
[{1,3495},{2,69900},{3,1748},{4,1748}];


get_attr(166) ->
[{1,3520},{2,70400},{3,1760},{4,1760}];


get_attr(167) ->
[{1,3545},{2,70900},{3,1773},{4,1773}];


get_attr(168) ->
[{1,3570},{2,71400},{3,1785},{4,1785}];


get_attr(169) ->
[{1,3595},{2,71900},{3,1798},{4,1798}];


get_attr(170) ->
[{1,3620},{2,72400},{3,1810},{4,1810}];


get_attr(171) ->
[{1,3645},{2,72900},{3,1823},{4,1823}];


get_attr(172) ->
[{1,3670},{2,73400},{3,1835},{4,1835}];


get_attr(173) ->
[{1,3695},{2,73900},{3,1848},{4,1848}];


get_attr(174) ->
[{1,3720},{2,74400},{3,1860},{4,1860}];


get_attr(175) ->
[{1,3745},{2,74900},{3,1873},{4,1873}];


get_attr(176) ->
[{1,3770},{2,75400},{3,1885},{4,1885}];


get_attr(177) ->
[{1,3795},{2,75900},{3,1898},{4,1898}];


get_attr(178) ->
[{1,3820},{2,76400},{3,1910},{4,1910}];


get_attr(179) ->
[{1,3845},{2,76900},{3,1923},{4,1923}];


get_attr(180) ->
[{1,3870},{2,77400},{3,1935},{4,1935}];


get_attr(181) ->
[{1,3895},{2,77900},{3,1948},{4,1948}];


get_attr(182) ->
[{1,3920},{2,78400},{3,1960},{4,1960}];


get_attr(183) ->
[{1,3945},{2,78900},{3,1973},{4,1973}];


get_attr(184) ->
[{1,3970},{2,79400},{3,1985},{4,1985}];


get_attr(185) ->
[{1,3995},{2,79900},{3,1998},{4,1998}];


get_attr(186) ->
[{1,4020},{2,80400},{3,2010},{4,2010}];


get_attr(187) ->
[{1,4045},{2,80900},{3,2023},{4,2023}];


get_attr(188) ->
[{1,4070},{2,81400},{3,2035},{4,2035}];


get_attr(189) ->
[{1,4095},{2,81900},{3,2048},{4,2048}];


get_attr(190) ->
[{1,4120},{2,82400},{3,2060},{4,2060}];


get_attr(191) ->
[{1,4145},{2,82900},{3,2073},{4,2073}];


get_attr(192) ->
[{1,4170},{2,83400},{3,2085},{4,2085}];


get_attr(193) ->
[{1,4195},{2,83900},{3,2098},{4,2098}];


get_attr(194) ->
[{1,4220},{2,84400},{3,2110},{4,2110}];


get_attr(195) ->
[{1,4245},{2,84900},{3,2123},{4,2123}];


get_attr(196) ->
[{1,4270},{2,85400},{3,2135},{4,2135}];


get_attr(197) ->
[{1,4295},{2,85900},{3,2148},{4,2148}];


get_attr(198) ->
[{1,4320},{2,86400},{3,2160},{4,2160}];


get_attr(199) ->
[{1,4345},{2,86900},{3,2173},{4,2173}];


get_attr(200) ->
[{1,4370},{2,87400},{3,2185},{4,2185}];


get_attr(201) ->
[{1,4395},{2,87900},{3,2198},{4,2198}];


get_attr(202) ->
[{1,4420},{2,88400},{3,2210},{4,2210}];


get_attr(203) ->
[{1,4445},{2,88900},{3,2223},{4,2223}];


get_attr(204) ->
[{1,4470},{2,89400},{3,2235},{4,2235}];


get_attr(205) ->
[{1,4495},{2,89900},{3,2248},{4,2248}];


get_attr(206) ->
[{1,4520},{2,90400},{3,2260},{4,2260}];


get_attr(207) ->
[{1,4545},{2,90900},{3,2273},{4,2273}];


get_attr(208) ->
[{1,4570},{2,91400},{3,2285},{4,2285}];


get_attr(209) ->
[{1,4595},{2,91900},{3,2298},{4,2298}];


get_attr(210) ->
[{1,4620},{2,92400},{3,2310},{4,2310}];


get_attr(211) ->
[{1,4645},{2,92900},{3,2323},{4,2323}];


get_attr(212) ->
[{1,4670},{2,93400},{3,2335},{4,2335}];


get_attr(213) ->
[{1,4695},{2,93900},{3,2348},{4,2348}];


get_attr(214) ->
[{1,4720},{2,94400},{3,2360},{4,2360}];


get_attr(215) ->
[{1,4745},{2,94900},{3,2373},{4,2373}];


get_attr(216) ->
[{1,4770},{2,95400},{3,2385},{4,2385}];


get_attr(217) ->
[{1,4795},{2,95900},{3,2398},{4,2398}];


get_attr(218) ->
[{1,4820},{2,96400},{3,2410},{4,2410}];


get_attr(219) ->
[{1,4845},{2,96900},{3,2423},{4,2423}];


get_attr(220) ->
[{1,4870},{2,97400},{3,2435},{4,2435}];


get_attr(221) ->
[{1,4895},{2,97900},{3,2448},{4,2448}];


get_attr(222) ->
[{1,4920},{2,98400},{3,2460},{4,2460}];


get_attr(223) ->
[{1,4945},{2,98900},{3,2473},{4,2473}];


get_attr(224) ->
[{1,4970},{2,99400},{3,2485},{4,2485}];


get_attr(225) ->
[{1,4995},{2,99900},{3,2498},{4,2498}];


get_attr(226) ->
[{1,5020},{2,100400},{3,2510},{4,2510}];


get_attr(227) ->
[{1,5045},{2,100900},{3,2523},{4,2523}];


get_attr(228) ->
[{1,5070},{2,101400},{3,2535},{4,2535}];


get_attr(229) ->
[{1,5095},{2,101900},{3,2548},{4,2548}];


get_attr(230) ->
[{1,5120},{2,102400},{3,2560},{4,2560}];


get_attr(231) ->
[{1,5145},{2,102900},{3,2573},{4,2573}];


get_attr(232) ->
[{1,5170},{2,103400},{3,2585},{4,2585}];


get_attr(233) ->
[{1,5195},{2,103900},{3,2598},{4,2598}];


get_attr(234) ->
[{1,5220},{2,104400},{3,2610},{4,2610}];


get_attr(235) ->
[{1,5245},{2,104900},{3,2623},{4,2623}];


get_attr(236) ->
[{1,5270},{2,105400},{3,2635},{4,2635}];


get_attr(237) ->
[{1,5295},{2,105900},{3,2648},{4,2648}];


get_attr(238) ->
[{1,5320},{2,106400},{3,2660},{4,2660}];


get_attr(239) ->
[{1,5345},{2,106900},{3,2673},{4,2673}];


get_attr(240) ->
[{1,5370},{2,107400},{3,2685},{4,2685}];


get_attr(241) ->
[{1,5395},{2,107900},{3,2698},{4,2698}];


get_attr(242) ->
[{1,5420},{2,108400},{3,2710},{4,2710}];


get_attr(243) ->
[{1,5445},{2,108900},{3,2723},{4,2723}];


get_attr(244) ->
[{1,5470},{2,109400},{3,2735},{4,2735}];


get_attr(245) ->
[{1,5495},{2,109900},{3,2748},{4,2748}];


get_attr(246) ->
[{1,5520},{2,110400},{3,2760},{4,2760}];


get_attr(247) ->
[{1,5545},{2,110900},{3,2773},{4,2773}];


get_attr(248) ->
[{1,5570},{2,111400},{3,2785},{4,2785}];


get_attr(249) ->
[{1,5595},{2,111900},{3,2798},{4,2798}];


get_attr(250) ->
[{1,5620},{2,112400},{3,2810},{4,2810}];


get_attr(251) ->
[{1,5645},{2,112900},{3,2823},{4,2823}];


get_attr(252) ->
[{1,5670},{2,113400},{3,2835},{4,2835}];


get_attr(253) ->
[{1,5695},{2,113900},{3,2848},{4,2848}];


get_attr(254) ->
[{1,5720},{2,114400},{3,2860},{4,2860}];


get_attr(255) ->
[{1,5745},{2,114900},{3,2873},{4,2873}];


get_attr(256) ->
[{1,5770},{2,115400},{3,2885},{4,2885}];


get_attr(257) ->
[{1,5795},{2,115900},{3,2898},{4,2898}];


get_attr(258) ->
[{1,5820},{2,116400},{3,2910},{4,2910}];


get_attr(259) ->
[{1,5845},{2,116900},{3,2923},{4,2923}];


get_attr(260) ->
[{1,5870},{2,117400},{3,2935},{4,2935}];


get_attr(261) ->
[{1,5895},{2,117900},{3,2948},{4,2948}];


get_attr(262) ->
[{1,5920},{2,118400},{3,2960},{4,2960}];


get_attr(263) ->
[{1,5945},{2,118900},{3,2973},{4,2973}];


get_attr(264) ->
[{1,5970},{2,119400},{3,2985},{4,2985}];


get_attr(265) ->
[{1,5995},{2,119900},{3,2998},{4,2998}];


get_attr(266) ->
[{1,6020},{2,120400},{3,3010},{4,3010}];


get_attr(267) ->
[{1,6045},{2,120900},{3,3023},{4,3023}];


get_attr(268) ->
[{1,6070},{2,121400},{3,3035},{4,3035}];


get_attr(269) ->
[{1,6095},{2,121900},{3,3048},{4,3048}];


get_attr(270) ->
[{1,6120},{2,122400},{3,3060},{4,3060}];


get_attr(271) ->
[{1,6145},{2,122900},{3,3073},{4,3073}];


get_attr(272) ->
[{1,6170},{2,123400},{3,3085},{4,3085}];


get_attr(273) ->
[{1,6195},{2,123900},{3,3098},{4,3098}];


get_attr(274) ->
[{1,6220},{2,124400},{3,3110},{4,3110}];


get_attr(275) ->
[{1,6245},{2,124900},{3,3123},{4,3123}];


get_attr(276) ->
[{1,6270},{2,125400},{3,3135},{4,3135}];


get_attr(277) ->
[{1,6295},{2,125900},{3,3148},{4,3148}];


get_attr(278) ->
[{1,6320},{2,126400},{3,3160},{4,3160}];


get_attr(279) ->
[{1,6345},{2,126900},{3,3173},{4,3173}];


get_attr(280) ->
[{1,6370},{2,127400},{3,3185},{4,3185}];


get_attr(281) ->
[{1,6395},{2,127900},{3,3198},{4,3198}];


get_attr(282) ->
[{1,6420},{2,128400},{3,3210},{4,3210}];


get_attr(283) ->
[{1,6445},{2,128900},{3,3223},{4,3223}];


get_attr(284) ->
[{1,6470},{2,129400},{3,3235},{4,3235}];


get_attr(285) ->
[{1,6495},{2,129900},{3,3248},{4,3248}];


get_attr(286) ->
[{1,6520},{2,130400},{3,3260},{4,3260}];


get_attr(287) ->
[{1,6545},{2,130900},{3,3273},{4,3273}];


get_attr(288) ->
[{1,6570},{2,131400},{3,3285},{4,3285}];


get_attr(289) ->
[{1,6595},{2,131900},{3,3298},{4,3298}];


get_attr(290) ->
[{1,6620},{2,132400},{3,3310},{4,3310}];


get_attr(291) ->
[{1,6645},{2,132900},{3,3323},{4,3323}];


get_attr(292) ->
[{1,6670},{2,133400},{3,3335},{4,3335}];


get_attr(293) ->
[{1,6695},{2,133900},{3,3348},{4,3348}];


get_attr(294) ->
[{1,6720},{2,134400},{3,3360},{4,3360}];


get_attr(295) ->
[{1,6745},{2,134900},{3,3373},{4,3373}];


get_attr(296) ->
[{1,6770},{2,135400},{3,3385},{4,3385}];


get_attr(297) ->
[{1,6795},{2,135900},{3,3398},{4,3398}];


get_attr(298) ->
[{1,6820},{2,136400},{3,3410},{4,3410}];


get_attr(299) ->
[{1,6845},{2,136900},{3,3423},{4,3423}];


get_attr(300) ->
[{1,6870},{2,137400},{3,3435},{4,3435}];


get_attr(301) ->
[{1,6895},{2,137900},{3,3448},{4,3448}];


get_attr(302) ->
[{1,6920},{2,138400},{3,3460},{4,3460}];


get_attr(303) ->
[{1,6945},{2,138900},{3,3473},{4,3473}];


get_attr(304) ->
[{1,6970},{2,139400},{3,3485},{4,3485}];


get_attr(305) ->
[{1,6995},{2,139900},{3,3498},{4,3498}];


get_attr(306) ->
[{1,7020},{2,140400},{3,3510},{4,3510}];


get_attr(307) ->
[{1,7045},{2,140900},{3,3523},{4,3523}];


get_attr(308) ->
[{1,7070},{2,141400},{3,3535},{4,3535}];


get_attr(309) ->
[{1,7095},{2,141900},{3,3548},{4,3548}];


get_attr(310) ->
[{1,7120},{2,142400},{3,3560},{4,3560}];


get_attr(311) ->
[{1,7145},{2,142900},{3,3573},{4,3573}];


get_attr(312) ->
[{1,7170},{2,143400},{3,3585},{4,3585}];


get_attr(313) ->
[{1,7195},{2,143900},{3,3598},{4,3598}];


get_attr(314) ->
[{1,7220},{2,144400},{3,3610},{4,3610}];


get_attr(315) ->
[{1,7245},{2,144900},{3,3623},{4,3623}];


get_attr(316) ->
[{1,7270},{2,145400},{3,3635},{4,3635}];


get_attr(317) ->
[{1,7295},{2,145900},{3,3648},{4,3648}];


get_attr(318) ->
[{1,7320},{2,146400},{3,3660},{4,3660}];


get_attr(319) ->
[{1,7345},{2,146900},{3,3673},{4,3673}];


get_attr(320) ->
[{1,7370},{2,147400},{3,3685},{4,3685}];


get_attr(321) ->
[{1,7395},{2,147900},{3,3698},{4,3698}];


get_attr(322) ->
[{1,7420},{2,148400},{3,3710},{4,3710}];


get_attr(323) ->
[{1,7445},{2,148900},{3,3723},{4,3723}];


get_attr(324) ->
[{1,7470},{2,149400},{3,3735},{4,3735}];


get_attr(325) ->
[{1,7495},{2,149900},{3,3748},{4,3748}];


get_attr(326) ->
[{1,7520},{2,150400},{3,3760},{4,3760}];


get_attr(327) ->
[{1,7545},{2,150900},{3,3773},{4,3773}];


get_attr(328) ->
[{1,7570},{2,151400},{3,3785},{4,3785}];


get_attr(329) ->
[{1,7595},{2,151900},{3,3798},{4,3798}];


get_attr(330) ->
[{1,7620},{2,152400},{3,3810},{4,3810}];


get_attr(331) ->
[{1,7645},{2,152900},{3,3823},{4,3823}];


get_attr(332) ->
[{1,7670},{2,153400},{3,3835},{4,3835}];


get_attr(333) ->
[{1,7695},{2,153900},{3,3848},{4,3848}];


get_attr(334) ->
[{1,7720},{2,154400},{3,3860},{4,3860}];


get_attr(335) ->
[{1,7745},{2,154900},{3,3873},{4,3873}];


get_attr(336) ->
[{1,7770},{2,155400},{3,3885},{4,3885}];


get_attr(337) ->
[{1,7795},{2,155900},{3,3898},{4,3898}];


get_attr(338) ->
[{1,7820},{2,156400},{3,3910},{4,3910}];


get_attr(339) ->
[{1,7845},{2,156900},{3,3923},{4,3923}];


get_attr(340) ->
[{1,7870},{2,157400},{3,3935},{4,3935}];


get_attr(341) ->
[{1,7895},{2,157900},{3,3948},{4,3948}];


get_attr(342) ->
[{1,7920},{2,158400},{3,3960},{4,3960}];


get_attr(343) ->
[{1,7945},{2,158900},{3,3973},{4,3973}];


get_attr(344) ->
[{1,7970},{2,159400},{3,3985},{4,3985}];


get_attr(345) ->
[{1,7995},{2,159900},{3,3998},{4,3998}];


get_attr(346) ->
[{1,8020},{2,160400},{3,4010},{4,4010}];


get_attr(347) ->
[{1,8045},{2,160900},{3,4023},{4,4023}];


get_attr(348) ->
[{1,8070},{2,161400},{3,4035},{4,4035}];


get_attr(349) ->
[{1,8095},{2,161900},{3,4048},{4,4048}];


get_attr(350) ->
[{1,8120},{2,162400},{3,4060},{4,4060}];


get_attr(351) ->
[{1,8145},{2,162900},{3,4073},{4,4073}];


get_attr(352) ->
[{1,8170},{2,163400},{3,4085},{4,4085}];


get_attr(353) ->
[{1,8195},{2,163900},{3,4098},{4,4098}];


get_attr(354) ->
[{1,8220},{2,164400},{3,4110},{4,4110}];


get_attr(355) ->
[{1,8245},{2,164900},{3,4123},{4,4123}];


get_attr(356) ->
[{1,8270},{2,165400},{3,4135},{4,4135}];


get_attr(357) ->
[{1,8295},{2,165900},{3,4148},{4,4148}];


get_attr(358) ->
[{1,8320},{2,166400},{3,4160},{4,4160}];


get_attr(359) ->
[{1,8345},{2,166900},{3,4173},{4,4173}];


get_attr(360) ->
[{1,8370},{2,167400},{3,4185},{4,4185}];


get_attr(361) ->
[{1,8395},{2,167900},{3,4198},{4,4198}];


get_attr(362) ->
[{1,8420},{2,168400},{3,4210},{4,4210}];


get_attr(363) ->
[{1,8445},{2,168900},{3,4223},{4,4223}];


get_attr(364) ->
[{1,8470},{2,169400},{3,4235},{4,4235}];


get_attr(365) ->
[{1,8495},{2,169900},{3,4248},{4,4248}];


get_attr(366) ->
[{1,8520},{2,170400},{3,4260},{4,4260}];


get_attr(367) ->
[{1,8545},{2,170900},{3,4273},{4,4273}];


get_attr(368) ->
[{1,8570},{2,171400},{3,4285},{4,4285}];


get_attr(369) ->
[{1,8595},{2,171900},{3,4298},{4,4298}];


get_attr(370) ->
[{1,8620},{2,172400},{3,4310},{4,4310}];


get_attr(371) ->
[{1,8645},{2,172900},{3,4323},{4,4323}];


get_attr(372) ->
[{1,8670},{2,173400},{3,4335},{4,4335}];


get_attr(373) ->
[{1,8695},{2,173900},{3,4348},{4,4348}];


get_attr(374) ->
[{1,8720},{2,174400},{3,4360},{4,4360}];


get_attr(375) ->
[{1,8745},{2,174900},{3,4373},{4,4373}];


get_attr(376) ->
[{1,8770},{2,175400},{3,4385},{4,4385}];


get_attr(377) ->
[{1,8795},{2,175900},{3,4398},{4,4398}];


get_attr(378) ->
[{1,8820},{2,176400},{3,4410},{4,4410}];


get_attr(379) ->
[{1,8845},{2,176900},{3,4423},{4,4423}];


get_attr(380) ->
[{1,8870},{2,177400},{3,4435},{4,4435}];


get_attr(381) ->
[{1,8895},{2,177900},{3,4448},{4,4448}];


get_attr(382) ->
[{1,8920},{2,178400},{3,4460},{4,4460}];


get_attr(383) ->
[{1,8945},{2,178900},{3,4473},{4,4473}];


get_attr(384) ->
[{1,8970},{2,179400},{3,4485},{4,4485}];


get_attr(385) ->
[{1,8995},{2,179900},{3,4498},{4,4498}];


get_attr(386) ->
[{1,9020},{2,180400},{3,4510},{4,4510}];


get_attr(387) ->
[{1,9045},{2,180900},{3,4523},{4,4523}];


get_attr(388) ->
[{1,9070},{2,181400},{3,4535},{4,4535}];


get_attr(389) ->
[{1,9095},{2,181900},{3,4548},{4,4548}];


get_attr(390) ->
[{1,9120},{2,182400},{3,4560},{4,4560}];


get_attr(391) ->
[{1,9145},{2,182900},{3,4573},{4,4573}];


get_attr(392) ->
[{1,9170},{2,183400},{3,4585},{4,4585}];


get_attr(393) ->
[{1,9195},{2,183900},{3,4598},{4,4598}];


get_attr(394) ->
[{1,9220},{2,184400},{3,4610},{4,4610}];


get_attr(395) ->
[{1,9245},{2,184900},{3,4623},{4,4623}];


get_attr(396) ->
[{1,9270},{2,185400},{3,4635},{4,4635}];


get_attr(397) ->
[{1,9295},{2,185900},{3,4648},{4,4648}];


get_attr(398) ->
[{1,9320},{2,186400},{3,4660},{4,4660}];


get_attr(399) ->
[{1,9345},{2,186900},{3,4673},{4,4673}];


get_attr(400) ->
[{1,9370},{2,187400},{3,4685},{4,4685}];

get_attr(_Lv) ->
	[].


get_goods_exp(38040044) ->
50;


get_goods_exp(38040045) ->
100;


get_goods_exp(38040046) ->
400;


get_goods_exp(38040047) ->
1250;


get_goods_exp(38040048) ->
10;


get_goods_exp(38040049) ->
20;


get_goods_exp(38040050) ->
80;


get_goods_exp(38040051) ->
250;

get_goods_exp(_Goodsid) ->
	0.


get_title_name(0) ->
<<"未获得"/utf8>>;


get_title_name(1) ->
<<"浪人"/utf8>>;


get_title_name(2) ->
<<"足轻"/utf8>>;


get_title_name(3) ->
<<"部将"/utf8>>;


get_title_name(4) ->
<<"大名"/utf8>>;


get_title_name(5) ->
<<"护代"/utf8>>;


get_title_name(6) ->
<<"御家"/utf8>>;


get_title_name(7) ->
<<"征夷"/utf8>>;


get_title_name(8) ->
<<"居合"/utf8>>;


get_title_name(9) ->
<<"正心"/utf8>>;


get_title_name(10) ->
<<"将知"/utf8>>;


get_title_name(11) ->
<<"阴忍"/utf8>>;


get_title_name(12) ->
<<"阳忍"/utf8>>;


get_title_name(13) ->
<<"绯色"/utf8>>;


get_title_name(14) ->
<<"天时"/utf8>>;


get_title_name(15) ->
<<"横纲"/utf8>>;


get_title_name(16) ->
<<"止水"/utf8>>;

get_title_name(_Id) ->
	[].

