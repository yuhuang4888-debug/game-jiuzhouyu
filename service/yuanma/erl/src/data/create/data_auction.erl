%%%---------------------------------------
%%% module      : data_auction
%%% description : 拍卖行配置
%%%
%%%---------------------------------------
-module(data_auction).
-compile(export_all).
-include("rec_auction.hrl").



get_goods(284101,_Wlv) when _Wlv >= 1, _Wlv =< 290 ->
	#base_auction_goods{no=1,goods_id=284101,name= "荣光之证",wlv1=1,wlv2=290,gtype_id=38040045,goods_num=1,base_price=20,add_price=10,one_price=200,unsold_price=[{2,0,10}],tv=0,type=0,gold_type=1};
get_goods(284102,_Wlv) when _Wlv >= 1, _Wlv =< 290 ->
	#base_auction_goods{no=1,goods_id=284102,name= "大师之证",wlv1=1,wlv2=290,gtype_id=38040046,goods_num=1,base_price=50,add_price=25,one_price=500,unsold_price=[{2,0,25}],tv=0,type=0,gold_type=1};
get_goods(284103,_Wlv) when _Wlv >= 1, _Wlv =< 290 ->
	#base_auction_goods{no=1,goods_id=284103,name= "英雄之证",wlv1=1,wlv2=290,gtype_id=38040047,goods_num=1,base_price=125,add_price=63,one_price=1250,unsold_price=[{2,0,63}],tv=0,type=0,gold_type=1};
get_goods(284104,_Wlv) when _Wlv >= 1, _Wlv =< 290 ->
	#base_auction_goods{no=1,goods_id=284104,name= "勇气之证",wlv1=1,wlv2=290,gtype_id=38040044,goods_num=1,base_price=10,add_price=5,one_price=100,unsold_price=[{2,0,5}],tv=0,type=0,gold_type=1};
get_goods(284105,_Wlv) when _Wlv >= 1, _Wlv =< 290 ->
	#base_auction_goods{no=1,goods_id=284105,name= "符文魔晶",wlv1=1,wlv2=290,gtype_id=38040012,goods_num=200,base_price=120,add_price=30,one_price=300,unsold_price=[{2,0,60}],tv=0,type=0,gold_type=1};
get_goods(284106,_Wlv) when _Wlv >= 1, _Wlv =< 290 ->
	#base_auction_goods{no=1,goods_id=284106,name= "魅影项链",wlv1=1,wlv2=290,gtype_id=101034072,goods_num=1,base_price=100,add_price=50,one_price=1000,unsold_price=[{2,0,50}],tv=0,type=0,gold_type=1};
get_goods(284107,_Wlv) when _Wlv >= 1, _Wlv =< 290 ->
	#base_auction_goods{no=1,goods_id=284107,name= "追猎项链",wlv1=1,wlv2=290,gtype_id=101034082,goods_num=1,base_price=100,add_price=50,one_price=1000,unsold_price=[{2,0,50}],tv=0,type=0,gold_type=1};
get_goods(284108,_Wlv) when _Wlv >= 1, _Wlv =< 290 ->
	#base_auction_goods{no=1,goods_id=284108,name= "暗焰项链",wlv1=1,wlv2=290,gtype_id=101034092,goods_num=1,base_price=100,add_price=50,one_price=1000,unsold_price=[{2,0,50}],tv=0,type=0,gold_type=1};
get_goods(284109,_Wlv) when _Wlv >= 1, _Wlv =< 290 ->
	#base_auction_goods{no=1,goods_id=284109,name= "圣徒项链",wlv1=1,wlv2=290,gtype_id=101034102,goods_num=1,base_price=100,add_price=50,one_price=1000,unsold_price=[{2,0,50}],tv=0,type=0,gold_type=1};
get_goods(284110,_Wlv) when _Wlv >= 1, _Wlv =< 290 ->
	#base_auction_goods{no=1,goods_id=284110,name= "审判项链",wlv1=1,wlv2=290,gtype_id=101034112,goods_num=1,base_price=100,add_price=50,one_price=1000,unsold_price=[{2,0,50}],tv=0,type=0,gold_type=1};
get_goods(284111,_Wlv) when _Wlv >= 1, _Wlv =< 290 ->
	#base_auction_goods{no=1,goods_id=284111,name= "征服者项链",wlv1=1,wlv2=290,gtype_id=101034122,goods_num=1,base_price=100,add_price=50,one_price=1000,unsold_price=[{2,0,50}],tv=0,type=0,gold_type=1};
get_goods(284112,_Wlv) when _Wlv >= 1, _Wlv =< 290 ->
	#base_auction_goods{no=1,goods_id=284112,name= "王者项链",wlv1=1,wlv2=290,gtype_id=101034132,goods_num=1,base_price=100,add_price=50,one_price=1000,unsold_price=[{2,0,50}],tv=0,type=0,gold_type=1};
get_goods(284113,_Wlv) when _Wlv >= 1, _Wlv =< 290 ->
	#base_auction_goods{no=1,goods_id=284113,name= "斗士符文礼包",wlv1=1,wlv2=290,gtype_id=32010383,goods_num=1,base_price=150,add_price=50,one_price=1000,unsold_price=[{2,0,75}],tv=0,type=0,gold_type=1};
get_goods(284114,_Wlv) when _Wlv >= 1, _Wlv =< 290 ->
	#base_auction_goods{no=1,goods_id=284114,name= "勇士符文礼包",wlv1=1,wlv2=290,gtype_id=32010384,goods_num=1,base_price=150,add_price=50,one_price=1000,unsold_price=[{2,0,75}],tv=0,type=0,gold_type=1};
get_goods(284115,_Wlv) when _Wlv >= 1, _Wlv =< 290 ->
	#base_auction_goods{no=1,goods_id=284115,name= "侵略符文礼包",wlv1=1,wlv2=290,gtype_id=32010385,goods_num=1,base_price=200,add_price=100,one_price=2000,unsold_price=[{2,0,100}],tv=0,type=0,gold_type=1};
get_goods(284117,_Wlv) when _Wlv >= 1, _Wlv =< 290 ->
	#base_auction_goods{no=1,goods_id=284117,name= "永恒骑士碎片",wlv1=1,wlv2=290,gtype_id=17030107,goods_num=3,base_price=150,add_price=50,one_price=500,unsold_price=[{2,0,75}],tv=0,type=0,gold_type=1};
get_goods(284119,_Wlv) when _Wlv >= 1, _Wlv =< 290 ->
	#base_auction_goods{no=1,goods_id=284119,name= "永恒骑士碎片",wlv1=1,wlv2=290,gtype_id=17030107,goods_num=30,base_price=1000,add_price=500,one_price=5000,unsold_price=[{2,0,500}],tv=0,type=0,gold_type=1};
get_goods(284120,_Wlv) when _Wlv >= 1, _Wlv =< 290 ->
	#base_auction_goods{no=1,goods_id=284120,name= "天使铭刻",wlv1=1,wlv2=290,gtype_id=38040060,goods_num=1,base_price=15,add_price=10,one_price=50,unsold_price=[{2,0,8}],tv=0,type=0,gold_type=1};
get_goods(284121,_Wlv) when _Wlv >= 1, _Wlv =< 290 ->
	#base_auction_goods{no=1,goods_id=284121,name= "恶魔铭刻",wlv1=1,wlv2=290,gtype_id=38040056,goods_num=1,base_price=15,add_price=10,one_price=50,unsold_price=[{2,0,8}],tv=0,type=0,gold_type=1};
get_goods(284201,_Wlv) when _Wlv >= 1, _Wlv =< 290 ->
	#base_auction_goods{no=1,goods_id=284201,name= "符文魔晶",wlv1=1,wlv2=290,gtype_id=38040012,goods_num=60,base_price=36,add_price=18,one_price=90,unsold_price=[{2,0,18}],tv=0,type=0,gold_type=2};
get_goods(284202,_Wlv) when _Wlv >= 1, _Wlv =< 290 ->
	#base_auction_goods{no=1,goods_id=284202,name= "魅影项链",wlv1=1,wlv2=290,gtype_id=101035071,goods_num=1,base_price=80,add_price=40,one_price=400,unsold_price=[{2,0,40}],tv=0,type=0,gold_type=2};
get_goods(284203,_Wlv) when _Wlv >= 1, _Wlv =< 290 ->
	#base_auction_goods{no=1,goods_id=284203,name= "追猎项链",wlv1=1,wlv2=290,gtype_id=101035081,goods_num=1,base_price=80,add_price=40,one_price=400,unsold_price=[{2,0,40}],tv=0,type=0,gold_type=2};
get_goods(284204,_Wlv) when _Wlv >= 1, _Wlv =< 290 ->
	#base_auction_goods{no=1,goods_id=284204,name= "暗焰项链",wlv1=1,wlv2=290,gtype_id=101035091,goods_num=1,base_price=80,add_price=40,one_price=400,unsold_price=[{2,0,40}],tv=0,type=0,gold_type=2};
get_goods(284205,_Wlv) when _Wlv >= 1, _Wlv =< 290 ->
	#base_auction_goods{no=1,goods_id=284205,name= "圣徒项链",wlv1=1,wlv2=290,gtype_id=101035101,goods_num=1,base_price=80,add_price=40,one_price=400,unsold_price=[{2,0,40}],tv=0,type=0,gold_type=2};
get_goods(284206,_Wlv) when _Wlv >= 1, _Wlv =< 290 ->
	#base_auction_goods{no=1,goods_id=284206,name= "审判项链",wlv1=1,wlv2=290,gtype_id=101035111,goods_num=1,base_price=80,add_price=40,one_price=400,unsold_price=[{2,0,40}],tv=0,type=0,gold_type=2};
get_goods(284207,_Wlv) when _Wlv >= 1, _Wlv =< 290 ->
	#base_auction_goods{no=1,goods_id=284207,name= "征服者项链",wlv1=1,wlv2=290,gtype_id=101035121,goods_num=1,base_price=80,add_price=40,one_price=400,unsold_price=[{2,0,40}],tv=0,type=0,gold_type=2};
get_goods(284208,_Wlv) when _Wlv >= 1, _Wlv =< 290 ->
	#base_auction_goods{no=1,goods_id=284208,name= "王者项链",wlv1=1,wlv2=290,gtype_id=101035131,goods_num=1,base_price=80,add_price=40,one_price=400,unsold_price=[{2,0,40}],tv=0,type=0,gold_type=2};
get_goods(284209,_Wlv) when _Wlv >= 1, _Wlv =< 290 ->
	#base_auction_goods{no=1,goods_id=284209,name= "魔魂丹",wlv1=1,wlv2=290,gtype_id=6101001,goods_num=1,base_price=32,add_price=8,one_price=80,unsold_price=[{2,0,16}],tv=0,type=0,gold_type=2};
get_goods(284210,_Wlv) when _Wlv >= 1, _Wlv =< 290 ->
	#base_auction_goods{no=1,goods_id=284210,name= "龙魂丹",wlv1=1,wlv2=290,gtype_id=6101002,goods_num=1,base_price=40,add_price=10,one_price=100,unsold_price=[{2,0,20}],tv=0,type=0,gold_type=2};
get_goods(284211,_Wlv) when _Wlv >= 1, _Wlv =< 290 ->
	#base_auction_goods{no=1,goods_id=284211,name= "神魂丹",wlv1=1,wlv2=290,gtype_id=6101003,goods_num=1,base_price=64,add_price=16,one_price=160,unsold_price=[{2,0,32}],tv=0,type=0,gold_type=2};
get_goods(284212,_Wlv) when _Wlv >= 1, _Wlv =< 290 ->
	#base_auction_goods{no=1,goods_id=284212,name= "勇士符文礼包",wlv1=1,wlv2=290,gtype_id=32010384,goods_num=1,base_price=250,add_price=100,one_price=1000,unsold_price=[{2,0,125}],tv=0,type=0,gold_type=2};
get_goods(284213,_Wlv) when _Wlv >= 1, _Wlv =< 290 ->
	#base_auction_goods{no=1,goods_id=284213,name= "斗士符文礼包",wlv1=1,wlv2=290,gtype_id=32010383,goods_num=1,base_price=250,add_price=100,one_price=1000,unsold_price=[{2,0,125}],tv=0,type=0,gold_type=2};
get_goods(284214,_Wlv) when _Wlv >= 1, _Wlv =< 290 ->
	#base_auction_goods{no=1,goods_id=284214,name= "特殊符文礼包",wlv1=1,wlv2=290,gtype_id=34010130,goods_num=1,base_price=200,add_price=80,one_price=800,unsold_price=[{2,0,100}],tv=0,type=0,gold_type=2};
get_goods(284215,_Wlv) when _Wlv >= 1, _Wlv =< 290 ->
	#base_auction_goods{no=1,goods_id=284215,name= "圣魂丹",wlv1=1,wlv2=290,gtype_id=6101004,goods_num=1,base_price=200,add_price=50,one_price=500,unsold_price=[{2,0,100}],tv=0,type=0,gold_type=2};
get_goods(284216,_Wlv) when _Wlv >= 1, _Wlv =< 290 ->
	#base_auction_goods{no=1,goods_id=284216,name= "纯洁之灵",wlv1=1,wlv2=290,gtype_id=38040061,goods_num=1,base_price=75,add_price=30,one_price=300,unsold_price=[{2,0,38}],tv=0,type=0,gold_type=2};
get_goods(284217,_Wlv) when _Wlv >= 1, _Wlv =< 290 ->
	#base_auction_goods{no=1,goods_id=284217,name= "堕落之魂",wlv1=1,wlv2=290,gtype_id=38040057,goods_num=1,base_price=75,add_price=30,one_price=300,unsold_price=[{2,0,38}],tv=0,type=0,gold_type=2};
get_goods(4021001,_Wlv) when _Wlv >= 1, _Wlv =< 290 ->
	#base_auction_goods{no=1,goods_id=4021001,name= "勇气之证碎片",wlv1=1,wlv2=290,gtype_id=38040048,goods_num=3,base_price=6,add_price=3,one_price=60,unsold_price=[{2,0,3}],tv=0,type=0,gold_type=1};
get_goods(4021002,_Wlv) when _Wlv >= 1, _Wlv =< 290 ->
	#base_auction_goods{no=1,goods_id=4021002,name= "勇气之证",wlv1=1,wlv2=290,gtype_id=38040044,goods_num=1,base_price=10,add_price=5,one_price=100,unsold_price=[{2,0,5}],tv=0,type=0,gold_type=1};
get_goods(4021003,_Wlv) when _Wlv >= 1, _Wlv =< 290 ->
	#base_auction_goods{no=1,goods_id=4021003,name= "荣光之证碎片",wlv1=1,wlv2=290,gtype_id=38040049,goods_num=1,base_price=4,add_price=2,one_price=40,unsold_price=[{2,0,2}],tv=0,type=0,gold_type=1};
get_goods(4021004,_Wlv) when _Wlv >= 1, _Wlv =< 290 ->
	#base_auction_goods{no=1,goods_id=4021004,name= "荣光之证",wlv1=1,wlv2=290,gtype_id=38040045,goods_num=1,base_price=20,add_price=10,one_price=200,unsold_price=[{2,0,10}],tv=0,type=0,gold_type=1};
get_goods(4021005,_Wlv) when _Wlv >= 1, _Wlv =< 290 ->
	#base_auction_goods{no=1,goods_id=4021005,name= "大师之证碎片",wlv1=1,wlv2=290,gtype_id=38040050,goods_num=1,base_price=10,add_price=5,one_price=100,unsold_price=[{2,0,5}],tv=0,type=0,gold_type=1};
get_goods(4021006,_Wlv) when _Wlv >= 1, _Wlv =< 290 ->
	#base_auction_goods{no=1,goods_id=4021006,name= "大师之证",wlv1=1,wlv2=290,gtype_id=38040046,goods_num=1,base_price=50,add_price=25,one_price=500,unsold_price=[{2,0,25}],tv=0,type=0,gold_type=1};
get_goods(4021007,_Wlv) when _Wlv >= 1, _Wlv =< 290 ->
	#base_auction_goods{no=1,goods_id=4021007,name= "英雄之证碎片",wlv1=1,wlv2=290,gtype_id=38040051,goods_num=1,base_price=25,add_price=13,one_price=250,unsold_price=[{2,0,13}],tv=0,type=0,gold_type=1};
get_goods(4021008,_Wlv) when _Wlv >= 1, _Wlv =< 290 ->
	#base_auction_goods{no=1,goods_id=4021008,name= "英雄之证",wlv1=1,wlv2=290,gtype_id=38040047,goods_num=1,base_price=125,add_price=63,one_price=1250,unsold_price=[{2,0,63}],tv=0,type=0,gold_type=1};
get_goods(4021009,_Wlv) when _Wlv >= 1, _Wlv =< 290 ->
	#base_auction_goods{no=1,goods_id=4021009,name= "7阶橙2武防自选",wlv1=1,wlv2=290,gtype_id=34010087,goods_num=1,base_price=80,add_price=40,one_price=800,unsold_price=[{2,0,40}],tv=0,type=0,gold_type=1};
get_goods(4021010,_Wlv) when _Wlv >= 1, _Wlv =< 290 ->
	#base_auction_goods{no=1,goods_id=4021010,name= "8阶橙2武防自选",wlv1=1,wlv2=290,gtype_id=34010088,goods_num=1,base_price=80,add_price=40,one_price=800,unsold_price=[{2,0,40}],tv=0,type=0,gold_type=1};
get_goods(4021011,_Wlv) when _Wlv >= 1, _Wlv =< 290 ->
	#base_auction_goods{no=1,goods_id=4021011,name= "9阶橙2武防自选",wlv1=1,wlv2=290,gtype_id=34010089,goods_num=1,base_price=80,add_price=40,one_price=800,unsold_price=[{2,0,40}],tv=0,type=0,gold_type=1};
get_goods(4021012,_Wlv) when _Wlv >= 1, _Wlv =< 290 ->
	#base_auction_goods{no=1,goods_id=4021012,name= "10阶橙2武防自选",wlv1=1,wlv2=290,gtype_id=34010090,goods_num=1,base_price=80,add_price=40,one_price=800,unsold_price=[{2,0,40}],tv=0,type=0,gold_type=1};
get_goods(4021013,_Wlv) when _Wlv >= 1, _Wlv =< 290 ->
	#base_auction_goods{no=1,goods_id=4021013,name= "11阶橙2武防自选",wlv1=1,wlv2=290,gtype_id=34010091,goods_num=1,base_price=80,add_price=40,one_price=800,unsold_price=[{2,0,40}],tv=0,type=0,gold_type=1};
get_goods(4021014,_Wlv) when _Wlv >= 1, _Wlv =< 290 ->
	#base_auction_goods{no=1,goods_id=4021014,name= "12阶橙2武防自选",wlv1=1,wlv2=290,gtype_id=34010092,goods_num=1,base_price=80,add_price=40,one_price=800,unsold_price=[{2,0,40}],tv=0,type=0,gold_type=1};
get_goods(4021015,_Wlv) when _Wlv >= 1, _Wlv =< 290 ->
	#base_auction_goods{no=1,goods_id=4021015,name= "13阶橙2武防自选",wlv1=1,wlv2=290,gtype_id=34010093,goods_num=1,base_price=80,add_price=40,one_price=800,unsold_price=[{2,0,40}],tv=0,type=0,gold_type=1};
get_goods(4021016,_Wlv) when _Wlv >= 1, _Wlv =< 290 ->
	#base_auction_goods{no=1,goods_id=4021016,name= "秋名飞车碎片",wlv1=1,wlv2=290,gtype_id=16030104,goods_num=5,base_price=50,add_price=25,one_price=500,unsold_price=[{2,0,25}],tv=1,type=0,gold_type=1};
get_goods(4021017,_Wlv) when _Wlv >= 1, _Wlv =< 290 ->
	#base_auction_goods{no=1,goods_id=4021017,name= "秋名飞车碎片",wlv1=1,wlv2=290,gtype_id=16030104,goods_num=5,base_price=50,add_price=25,one_price=500,unsold_price=[{2,0,25}],tv=1,type=0,gold_type=1};
get_goods(4021018,_Wlv) when _Wlv >= 1, _Wlv =< 290 ->
	#base_auction_goods{no=1,goods_id=4021018,name= "阿波罗神魂",wlv1=1,wlv2=290,gtype_id=7120303,goods_num=5,base_price=100,add_price=50,one_price=1000,unsold_price=[{2,0,50}],tv=1,type=0,gold_type=1};
get_goods(4021901,_Wlv) when _Wlv >= 1, _Wlv =< 290 ->
	#base_auction_goods{no=1,goods_id=4021901,name= "勇气之证碎片",wlv1=1,wlv2=290,gtype_id=38040048,goods_num=2,base_price=8,add_price=8,one_price=40,unsold_price=[{2,0,4}],tv=0,type=0,gold_type=2};
get_goods(4021902,_Wlv) when _Wlv >= 1, _Wlv =< 290 ->
	#base_auction_goods{no=1,goods_id=4021902,name= "荣光之证碎片",wlv1=1,wlv2=290,gtype_id=38040049,goods_num=1,base_price=8,add_price=8,one_price=40,unsold_price=[{2,0,4}],tv=0,type=0,gold_type=2};
get_goods(4021903,_Wlv) when _Wlv >= 1, _Wlv =< 290 ->
	#base_auction_goods{no=1,goods_id=4021903,name= "大师之证碎片",wlv1=1,wlv2=290,gtype_id=38040050,goods_num=1,base_price=20,add_price=20,one_price=100,unsold_price=[{2,0,10}],tv=0,type=0,gold_type=2};
get_goods(4021904,_Wlv) when _Wlv >= 1, _Wlv =< 290 ->
	#base_auction_goods{no=1,goods_id=4021904,name= "魔魂丹",wlv1=1,wlv2=290,gtype_id=6101001,goods_num=1,base_price=32,add_price=8,one_price=80,unsold_price=[{2,0,16}],tv=0,type=0,gold_type=2};
get_goods(4021905,_Wlv) when _Wlv >= 1, _Wlv =< 290 ->
	#base_auction_goods{no=1,goods_id=4021905,name= "龙魂丹",wlv1=1,wlv2=290,gtype_id=6101002,goods_num=1,base_price=40,add_price=10,one_price=100,unsold_price=[{2,0,20}],tv=0,type=0,gold_type=2};
get_goods(4021906,_Wlv) when _Wlv >= 1, _Wlv =< 290 ->
	#base_auction_goods{no=1,goods_id=4021906,name= "神魂丹",wlv1=1,wlv2=290,gtype_id=6101003,goods_num=1,base_price=64,add_price=16,one_price=160,unsold_price=[{2,0,32}],tv=0,type=0,gold_type=2};
get_goods(80000101,_Wlv) when _Wlv >= 1, _Wlv =< 999 ->
	#base_auction_goods{no=1,goods_id=80000101,name= "卫士神像碎片",wlv1=1,wlv2=999,gtype_id=38040087,goods_num=1,base_price=240,add_price=60,one_price=1200,unsold_price=[],tv=0,type=0,gold_type=1};
get_goods(80000102,_Wlv) when _Wlv >= 1, _Wlv =< 999 ->
	#base_auction_goods{no=1,goods_id=80000102,name= "骑士神像碎片",wlv1=1,wlv2=999,gtype_id=38040088,goods_num=1,base_price=300,add_price=75,one_price=1500,unsold_price=[],tv=0,type=0,gold_type=1};
get_goods(80000103,_Wlv) when _Wlv >= 651, _Wlv =< 999 ->
	#base_auction_goods{no=1,goods_id=80000103,name= "狂战神像碎片",wlv1=651,wlv2=999,gtype_id=38040089,goods_num=1,base_price=400,add_price=95,one_price=2000,unsold_price=[],tv=0,type=0,gold_type=1};
get_goods(80000104,_Wlv) when _Wlv >= 751, _Wlv =< 999 ->
	#base_auction_goods{no=1,goods_id=80000104,name= "战神神像碎片",wlv1=751,wlv2=999,gtype_id=38040090,goods_num=1,base_price=500,add_price=140,one_price=2500,unsold_price=[],tv=0,type=0,gold_type=1};
get_goods(80000105,_Wlv) when _Wlv >= 1, _Wlv =< 999 ->
	#base_auction_goods{no=1,goods_id=80000105,name= "飞马座之圣兵",wlv1=1,wlv2=999,gtype_id=34010310,goods_num=1,base_price=400,add_price=40,one_price=800,unsold_price=[],tv=0,type=0,gold_type=2};
get_goods(80000106,_Wlv) when _Wlv >= 1, _Wlv =< 999 ->
	#base_auction_goods{no=1,goods_id=80000106,name= "巨爵座之圣兵",wlv1=1,wlv2=999,gtype_id=34010311,goods_num=1,base_price=500,add_price=50,one_price=1000,unsold_price=[],tv=0,type=0,gold_type=2};
get_goods(80000107,_Wlv) when _Wlv >= 551, _Wlv =< 999 ->
	#base_auction_goods{no=1,goods_id=80000107,name= "北冕座之圣兵",wlv1=551,wlv2=999,gtype_id=34010312,goods_num=1,base_price=600,add_price=60,one_price=1200,unsold_price=[],tv=0,type=0,gold_type=2};
get_goods(80000108,_Wlv) when _Wlv >= 651, _Wlv =< 999 ->
	#base_auction_goods{no=1,goods_id=80000108,name= "天龙座之圣兵",wlv1=651,wlv2=999,gtype_id=34010313,goods_num=1,base_price=750,add_price=75,one_price=1500,unsold_price=[],tv=0,type=0,gold_type=2};
get_goods(80000109,_Wlv) when _Wlv >= 751, _Wlv =< 999 ->
	#base_auction_goods{no=1,goods_id=80000109,name= "仙王座之圣兵",wlv1=751,wlv2=999,gtype_id=34010314,goods_num=1,base_price=1000,add_price=100,one_price=2000,unsold_price=[],tv=0,type=0,gold_type=2};
get_goods(80000110,_Wlv) when _Wlv >= 551, _Wlv =< 999 ->
	#base_auction_goods{no=1,goods_id=80000110,name= "棘甲龙力之核",wlv1=551,wlv2=999,gtype_id=7711403,goods_num=1,base_price=160,add_price=60,one_price=800,unsold_price=[],tv=0,type=0,gold_type=1};
get_goods(80000111,_Wlv) when _Wlv >= 551, _Wlv =< 999 ->
	#base_auction_goods{no=1,goods_id=80000111,name= "3阶龙灵装备",wlv1=551,wlv2=999,gtype_id=32060087,goods_num=1,base_price=250,add_price=30,one_price=500,unsold_price=[],tv=0,type=0,gold_type=2};
get_goods(80000112,_Wlv) when _Wlv >= 551, _Wlv =< 999 ->
	#base_auction_goods{no=1,goods_id=80000112,name= "神炼石(武防)",wlv1=551,wlv2=999,gtype_id=38040092,goods_num=1,base_price=450,add_price=100,one_price=1500,unsold_price=[],tv=0,type=0,gold_type=1};
get_goods(284101,_Wlv) when _Wlv >= 291, _Wlv =< 350 ->
	#base_auction_goods{no=2,goods_id=284101,name= "荣光之证",wlv1=291,wlv2=350,gtype_id=38040045,goods_num=1,base_price=20,add_price=10,one_price=200,unsold_price=[{2,0,10}],tv=0,type=0,gold_type=1};
get_goods(284102,_Wlv) when _Wlv >= 291, _Wlv =< 350 ->
	#base_auction_goods{no=2,goods_id=284102,name= "大师之证",wlv1=291,wlv2=350,gtype_id=38040046,goods_num=1,base_price=50,add_price=25,one_price=500,unsold_price=[{2,0,25}],tv=0,type=0,gold_type=1};
get_goods(284103,_Wlv) when _Wlv >= 291, _Wlv =< 350 ->
	#base_auction_goods{no=2,goods_id=284103,name= "英雄之证",wlv1=291,wlv2=350,gtype_id=38040047,goods_num=1,base_price=125,add_price=63,one_price=1250,unsold_price=[{2,0,63}],tv=0,type=0,gold_type=1};
get_goods(284104,_Wlv) when _Wlv >= 291, _Wlv =< 350 ->
	#base_auction_goods{no=2,goods_id=284104,name= "勇气之证",wlv1=291,wlv2=350,gtype_id=38040044,goods_num=1,base_price=10,add_price=5,one_price=100,unsold_price=[{2,0,5}],tv=0,type=0,gold_type=1};
get_goods(284105,_Wlv) when _Wlv >= 291, _Wlv =< 350 ->
	#base_auction_goods{no=2,goods_id=284105,name= "符文魔晶",wlv1=291,wlv2=350,gtype_id=38040012,goods_num=200,base_price=120,add_price=30,one_price=300,unsold_price=[{2,0,60}],tv=0,type=0,gold_type=1};
get_goods(284106,_Wlv) when _Wlv >= 291, _Wlv =< 350 ->
	#base_auction_goods{no=2,goods_id=284106,name= "魅影项链",wlv1=291,wlv2=350,gtype_id=101034072,goods_num=1,base_price=100,add_price=50,one_price=1000,unsold_price=[{2,0,50}],tv=0,type=0,gold_type=1};
get_goods(284107,_Wlv) when _Wlv >= 291, _Wlv =< 350 ->
	#base_auction_goods{no=2,goods_id=284107,name= "追猎项链",wlv1=291,wlv2=350,gtype_id=101034082,goods_num=1,base_price=100,add_price=50,one_price=1000,unsold_price=[{2,0,50}],tv=0,type=0,gold_type=1};
get_goods(284108,_Wlv) when _Wlv >= 291, _Wlv =< 350 ->
	#base_auction_goods{no=2,goods_id=284108,name= "暗焰项链",wlv1=291,wlv2=350,gtype_id=101034092,goods_num=1,base_price=100,add_price=50,one_price=1000,unsold_price=[{2,0,50}],tv=0,type=0,gold_type=1};
get_goods(284109,_Wlv) when _Wlv >= 291, _Wlv =< 350 ->
	#base_auction_goods{no=2,goods_id=284109,name= "圣徒项链",wlv1=291,wlv2=350,gtype_id=101034102,goods_num=1,base_price=100,add_price=50,one_price=1000,unsold_price=[{2,0,50}],tv=0,type=0,gold_type=1};
get_goods(284110,_Wlv) when _Wlv >= 291, _Wlv =< 350 ->
	#base_auction_goods{no=2,goods_id=284110,name= "审判项链",wlv1=291,wlv2=350,gtype_id=101034112,goods_num=1,base_price=100,add_price=50,one_price=1000,unsold_price=[{2,0,50}],tv=0,type=0,gold_type=1};
get_goods(284111,_Wlv) when _Wlv >= 291, _Wlv =< 350 ->
	#base_auction_goods{no=2,goods_id=284111,name= "征服者项链",wlv1=291,wlv2=350,gtype_id=101034122,goods_num=1,base_price=100,add_price=50,one_price=1000,unsold_price=[{2,0,50}],tv=0,type=0,gold_type=1};
get_goods(284112,_Wlv) when _Wlv >= 291, _Wlv =< 350 ->
	#base_auction_goods{no=2,goods_id=284112,name= "王者项链",wlv1=291,wlv2=350,gtype_id=101034132,goods_num=1,base_price=100,add_price=50,one_price=1000,unsold_price=[{2,0,50}],tv=0,type=0,gold_type=1};
get_goods(284113,_Wlv) when _Wlv >= 291, _Wlv =< 350 ->
	#base_auction_goods{no=2,goods_id=284113,name= "斗士符文礼包",wlv1=291,wlv2=350,gtype_id=32010383,goods_num=1,base_price=150,add_price=50,one_price=1000,unsold_price=[{2,0,75}],tv=0,type=0,gold_type=1};
get_goods(284114,_Wlv) when _Wlv >= 291, _Wlv =< 350 ->
	#base_auction_goods{no=2,goods_id=284114,name= "勇士符文礼包",wlv1=291,wlv2=350,gtype_id=32010384,goods_num=1,base_price=150,add_price=50,one_price=1000,unsold_price=[{2,0,75}],tv=0,type=0,gold_type=1};
get_goods(284115,_Wlv) when _Wlv >= 291, _Wlv =< 350 ->
	#base_auction_goods{no=2,goods_id=284115,name= "侵略符文礼包",wlv1=291,wlv2=350,gtype_id=32010385,goods_num=1,base_price=200,add_price=100,one_price=2000,unsold_price=[{2,0,100}],tv=0,type=0,gold_type=1};
get_goods(284117,_Wlv) when _Wlv >= 291, _Wlv =< 350 ->
	#base_auction_goods{no=2,goods_id=284117,name= "永恒骑士碎片",wlv1=291,wlv2=350,gtype_id=17030107,goods_num=3,base_price=150,add_price=50,one_price=500,unsold_price=[{2,0,75}],tv=0,type=0,gold_type=1};
get_goods(284119,_Wlv) when _Wlv >= 291, _Wlv =< 350 ->
	#base_auction_goods{no=2,goods_id=284119,name= "永恒骑士碎片",wlv1=291,wlv2=350,gtype_id=17030107,goods_num=30,base_price=1000,add_price=500,one_price=5000,unsold_price=[{2,0,500}],tv=0,type=0,gold_type=1};
get_goods(284120,_Wlv) when _Wlv >= 291, _Wlv =< 350 ->
	#base_auction_goods{no=2,goods_id=284120,name= "天使铭刻",wlv1=291,wlv2=350,gtype_id=38040060,goods_num=1,base_price=15,add_price=10,one_price=50,unsold_price=[{2,0,8}],tv=0,type=0,gold_type=1};
get_goods(284121,_Wlv) when _Wlv >= 291, _Wlv =< 350 ->
	#base_auction_goods{no=2,goods_id=284121,name= "恶魔铭刻",wlv1=291,wlv2=350,gtype_id=38040056,goods_num=1,base_price=15,add_price=10,one_price=50,unsold_price=[{2,0,8}],tv=0,type=0,gold_type=1};
get_goods(284201,_Wlv) when _Wlv >= 291, _Wlv =< 350 ->
	#base_auction_goods{no=2,goods_id=284201,name= "符文魔晶",wlv1=291,wlv2=350,gtype_id=38040012,goods_num=60,base_price=36,add_price=18,one_price=90,unsold_price=[{2,0,18}],tv=0,type=0,gold_type=2};
get_goods(284202,_Wlv) when _Wlv >= 291, _Wlv =< 350 ->
	#base_auction_goods{no=2,goods_id=284202,name= "魅影项链",wlv1=291,wlv2=350,gtype_id=101035071,goods_num=1,base_price=80,add_price=40,one_price=400,unsold_price=[{2,0,40}],tv=0,type=0,gold_type=2};
get_goods(284203,_Wlv) when _Wlv >= 291, _Wlv =< 350 ->
	#base_auction_goods{no=2,goods_id=284203,name= "追猎项链",wlv1=291,wlv2=350,gtype_id=101035081,goods_num=1,base_price=80,add_price=40,one_price=400,unsold_price=[{2,0,40}],tv=0,type=0,gold_type=2};
get_goods(284204,_Wlv) when _Wlv >= 291, _Wlv =< 350 ->
	#base_auction_goods{no=2,goods_id=284204,name= "暗焰项链",wlv1=291,wlv2=350,gtype_id=101035091,goods_num=1,base_price=80,add_price=40,one_price=400,unsold_price=[{2,0,40}],tv=0,type=0,gold_type=2};
get_goods(284205,_Wlv) when _Wlv >= 291, _Wlv =< 350 ->
	#base_auction_goods{no=2,goods_id=284205,name= "圣徒项链",wlv1=291,wlv2=350,gtype_id=101035101,goods_num=1,base_price=80,add_price=40,one_price=400,unsold_price=[{2,0,40}],tv=0,type=0,gold_type=2};
get_goods(284206,_Wlv) when _Wlv >= 291, _Wlv =< 350 ->
	#base_auction_goods{no=2,goods_id=284206,name= "审判项链",wlv1=291,wlv2=350,gtype_id=101035111,goods_num=1,base_price=80,add_price=40,one_price=400,unsold_price=[{2,0,40}],tv=0,type=0,gold_type=2};
get_goods(284207,_Wlv) when _Wlv >= 291, _Wlv =< 350 ->
	#base_auction_goods{no=2,goods_id=284207,name= "征服者项链",wlv1=291,wlv2=350,gtype_id=101035121,goods_num=1,base_price=80,add_price=40,one_price=400,unsold_price=[{2,0,40}],tv=0,type=0,gold_type=2};
get_goods(284208,_Wlv) when _Wlv >= 291, _Wlv =< 350 ->
	#base_auction_goods{no=2,goods_id=284208,name= "王者项链",wlv1=291,wlv2=350,gtype_id=101035131,goods_num=1,base_price=80,add_price=40,one_price=400,unsold_price=[{2,0,40}],tv=0,type=0,gold_type=2};
get_goods(284209,_Wlv) when _Wlv >= 291, _Wlv =< 350 ->
	#base_auction_goods{no=2,goods_id=284209,name= "魔魂丹",wlv1=291,wlv2=350,gtype_id=6101001,goods_num=1,base_price=32,add_price=8,one_price=80,unsold_price=[{2,0,16}],tv=0,type=0,gold_type=2};
get_goods(284210,_Wlv) when _Wlv >= 291, _Wlv =< 350 ->
	#base_auction_goods{no=2,goods_id=284210,name= "龙魂丹",wlv1=291,wlv2=350,gtype_id=6101002,goods_num=1,base_price=40,add_price=10,one_price=100,unsold_price=[{2,0,20}],tv=0,type=0,gold_type=2};
get_goods(284211,_Wlv) when _Wlv >= 291, _Wlv =< 350 ->
	#base_auction_goods{no=2,goods_id=284211,name= "神魂丹",wlv1=291,wlv2=350,gtype_id=6101003,goods_num=1,base_price=64,add_price=16,one_price=160,unsold_price=[{2,0,32}],tv=0,type=0,gold_type=2};
get_goods(284212,_Wlv) when _Wlv >= 291, _Wlv =< 350 ->
	#base_auction_goods{no=2,goods_id=284212,name= "勇士符文礼包",wlv1=291,wlv2=350,gtype_id=32010384,goods_num=1,base_price=250,add_price=100,one_price=1000,unsold_price=[{2,0,125}],tv=0,type=0,gold_type=2};
get_goods(284213,_Wlv) when _Wlv >= 291, _Wlv =< 350 ->
	#base_auction_goods{no=2,goods_id=284213,name= "斗士符文礼包",wlv1=291,wlv2=350,gtype_id=32010383,goods_num=1,base_price=250,add_price=100,one_price=1000,unsold_price=[{2,0,125}],tv=0,type=0,gold_type=2};
get_goods(284214,_Wlv) when _Wlv >= 291, _Wlv =< 350 ->
	#base_auction_goods{no=2,goods_id=284214,name= "特殊符文礼包",wlv1=291,wlv2=350,gtype_id=34010130,goods_num=1,base_price=200,add_price=80,one_price=800,unsold_price=[{2,0,100}],tv=0,type=0,gold_type=2};
get_goods(284215,_Wlv) when _Wlv >= 291, _Wlv =< 350 ->
	#base_auction_goods{no=2,goods_id=284215,name= "圣魂丹",wlv1=291,wlv2=350,gtype_id=6101004,goods_num=1,base_price=200,add_price=50,one_price=500,unsold_price=[{2,0,100}],tv=0,type=0,gold_type=2};
get_goods(284216,_Wlv) when _Wlv >= 291, _Wlv =< 350 ->
	#base_auction_goods{no=2,goods_id=284216,name= "纯洁之灵",wlv1=291,wlv2=350,gtype_id=38040061,goods_num=1,base_price=75,add_price=30,one_price=300,unsold_price=[{2,0,38}],tv=0,type=0,gold_type=2};
get_goods(284217,_Wlv) when _Wlv >= 291, _Wlv =< 350 ->
	#base_auction_goods{no=2,goods_id=284217,name= "堕落之魂",wlv1=291,wlv2=350,gtype_id=38040057,goods_num=1,base_price=75,add_price=30,one_price=300,unsold_price=[{2,0,38}],tv=0,type=0,gold_type=2};
get_goods(4021001,_Wlv) when _Wlv >= 291, _Wlv =< 350 ->
	#base_auction_goods{no=2,goods_id=4021001,name= "勇气之证碎片",wlv1=291,wlv2=350,gtype_id=38040048,goods_num=3,base_price=6,add_price=3,one_price=60,unsold_price=[{2,0,3}],tv=0,type=0,gold_type=1};
get_goods(4021002,_Wlv) when _Wlv >= 291, _Wlv =< 350 ->
	#base_auction_goods{no=2,goods_id=4021002,name= "勇气之证",wlv1=291,wlv2=350,gtype_id=38040044,goods_num=1,base_price=10,add_price=5,one_price=100,unsold_price=[{2,0,5}],tv=0,type=0,gold_type=1};
get_goods(4021003,_Wlv) when _Wlv >= 291, _Wlv =< 350 ->
	#base_auction_goods{no=2,goods_id=4021003,name= "荣光之证碎片",wlv1=291,wlv2=350,gtype_id=38040049,goods_num=1,base_price=4,add_price=2,one_price=40,unsold_price=[{2,0,2}],tv=0,type=0,gold_type=1};
get_goods(4021004,_Wlv) when _Wlv >= 291, _Wlv =< 350 ->
	#base_auction_goods{no=2,goods_id=4021004,name= "荣光之证",wlv1=291,wlv2=350,gtype_id=38040045,goods_num=1,base_price=20,add_price=10,one_price=200,unsold_price=[{2,0,10}],tv=0,type=0,gold_type=1};
get_goods(4021005,_Wlv) when _Wlv >= 291, _Wlv =< 350 ->
	#base_auction_goods{no=2,goods_id=4021005,name= "大师之证碎片",wlv1=291,wlv2=350,gtype_id=38040050,goods_num=1,base_price=10,add_price=5,one_price=100,unsold_price=[{2,0,5}],tv=0,type=0,gold_type=1};
get_goods(4021006,_Wlv) when _Wlv >= 291, _Wlv =< 350 ->
	#base_auction_goods{no=2,goods_id=4021006,name= "大师之证",wlv1=291,wlv2=350,gtype_id=38040046,goods_num=1,base_price=50,add_price=25,one_price=500,unsold_price=[{2,0,25}],tv=0,type=0,gold_type=1};
get_goods(4021007,_Wlv) when _Wlv >= 291, _Wlv =< 350 ->
	#base_auction_goods{no=2,goods_id=4021007,name= "英雄之证碎片",wlv1=291,wlv2=350,gtype_id=38040051,goods_num=1,base_price=25,add_price=13,one_price=250,unsold_price=[{2,0,13}],tv=0,type=0,gold_type=1};
get_goods(4021008,_Wlv) when _Wlv >= 291, _Wlv =< 350 ->
	#base_auction_goods{no=2,goods_id=4021008,name= "英雄之证",wlv1=291,wlv2=350,gtype_id=38040047,goods_num=1,base_price=125,add_price=63,one_price=1250,unsold_price=[{2,0,63}],tv=0,type=0,gold_type=1};
get_goods(4021009,_Wlv) when _Wlv >= 291, _Wlv =< 350 ->
	#base_auction_goods{no=2,goods_id=4021009,name= "7阶橙2武防自选",wlv1=291,wlv2=350,gtype_id=34010087,goods_num=1,base_price=50,add_price=25,one_price=500,unsold_price=[{2,0,25}],tv=0,type=0,gold_type=1};
get_goods(4021010,_Wlv) when _Wlv >= 291, _Wlv =< 350 ->
	#base_auction_goods{no=2,goods_id=4021010,name= "8阶橙2武防自选",wlv1=291,wlv2=350,gtype_id=34010088,goods_num=1,base_price=80,add_price=40,one_price=800,unsold_price=[{2,0,40}],tv=0,type=0,gold_type=1};
get_goods(4021011,_Wlv) when _Wlv >= 291, _Wlv =< 350 ->
	#base_auction_goods{no=2,goods_id=4021011,name= "9阶橙2武防自选",wlv1=291,wlv2=350,gtype_id=34010089,goods_num=1,base_price=80,add_price=40,one_price=800,unsold_price=[{2,0,40}],tv=0,type=0,gold_type=1};
get_goods(4021012,_Wlv) when _Wlv >= 291, _Wlv =< 350 ->
	#base_auction_goods{no=2,goods_id=4021012,name= "10阶橙2武防自选",wlv1=291,wlv2=350,gtype_id=34010090,goods_num=1,base_price=80,add_price=40,one_price=800,unsold_price=[{2,0,40}],tv=0,type=0,gold_type=1};
get_goods(4021013,_Wlv) when _Wlv >= 291, _Wlv =< 350 ->
	#base_auction_goods{no=2,goods_id=4021013,name= "11阶橙2武防自选",wlv1=291,wlv2=350,gtype_id=34010091,goods_num=1,base_price=80,add_price=40,one_price=800,unsold_price=[{2,0,40}],tv=0,type=0,gold_type=1};
get_goods(4021014,_Wlv) when _Wlv >= 291, _Wlv =< 350 ->
	#base_auction_goods{no=2,goods_id=4021014,name= "12阶橙2武防自选",wlv1=291,wlv2=350,gtype_id=34010092,goods_num=1,base_price=80,add_price=40,one_price=800,unsold_price=[{2,0,40}],tv=0,type=0,gold_type=1};
get_goods(4021015,_Wlv) when _Wlv >= 291, _Wlv =< 350 ->
	#base_auction_goods{no=2,goods_id=4021015,name= "13阶橙2武防自选",wlv1=291,wlv2=350,gtype_id=34010093,goods_num=1,base_price=80,add_price=40,one_price=800,unsold_price=[{2,0,40}],tv=0,type=0,gold_type=1};
get_goods(4021016,_Wlv) when _Wlv >= 291, _Wlv =< 350 ->
	#base_auction_goods{no=2,goods_id=4021016,name= "秋名飞车碎片",wlv1=291,wlv2=350,gtype_id=16030104,goods_num=5,base_price=50,add_price=25,one_price=500,unsold_price=[{2,0,25}],tv=1,type=0,gold_type=1};
get_goods(4021017,_Wlv) when _Wlv >= 291, _Wlv =< 350 ->
	#base_auction_goods{no=2,goods_id=4021017,name= "秋名飞车碎片",wlv1=291,wlv2=350,gtype_id=16030104,goods_num=5,base_price=50,add_price=25,one_price=500,unsold_price=[{2,0,25}],tv=1,type=0,gold_type=1};
get_goods(4021018,_Wlv) when _Wlv >= 291, _Wlv =< 350 ->
	#base_auction_goods{no=2,goods_id=4021018,name= "阿波罗神魂",wlv1=291,wlv2=350,gtype_id=7120303,goods_num=5,base_price=100,add_price=50,one_price=1000,unsold_price=[{2,0,50}],tv=1,type=0,gold_type=1};
get_goods(4021901,_Wlv) when _Wlv >= 291, _Wlv =< 350 ->
	#base_auction_goods{no=2,goods_id=4021901,name= "勇气之证碎片",wlv1=291,wlv2=350,gtype_id=38040048,goods_num=2,base_price=8,add_price=8,one_price=40,unsold_price=[{2,0,4}],tv=0,type=0,gold_type=2};
get_goods(4021902,_Wlv) when _Wlv >= 291, _Wlv =< 350 ->
	#base_auction_goods{no=2,goods_id=4021902,name= "荣光之证碎片",wlv1=291,wlv2=350,gtype_id=38040049,goods_num=1,base_price=8,add_price=8,one_price=40,unsold_price=[{2,0,4}],tv=0,type=0,gold_type=2};
get_goods(4021903,_Wlv) when _Wlv >= 291, _Wlv =< 350 ->
	#base_auction_goods{no=2,goods_id=4021903,name= "大师之证碎片",wlv1=291,wlv2=350,gtype_id=38040050,goods_num=1,base_price=20,add_price=20,one_price=100,unsold_price=[{2,0,10}],tv=0,type=0,gold_type=2};
get_goods(4021904,_Wlv) when _Wlv >= 291, _Wlv =< 350 ->
	#base_auction_goods{no=2,goods_id=4021904,name= "魔魂丹",wlv1=291,wlv2=350,gtype_id=6101001,goods_num=1,base_price=32,add_price=8,one_price=80,unsold_price=[{2,0,16}],tv=0,type=0,gold_type=2};
get_goods(4021905,_Wlv) when _Wlv >= 291, _Wlv =< 350 ->
	#base_auction_goods{no=2,goods_id=4021905,name= "龙魂丹",wlv1=291,wlv2=350,gtype_id=6101002,goods_num=1,base_price=40,add_price=10,one_price=100,unsold_price=[{2,0,20}],tv=0,type=0,gold_type=2};
get_goods(4021906,_Wlv) when _Wlv >= 291, _Wlv =< 350 ->
	#base_auction_goods{no=2,goods_id=4021906,name= "神魂丹",wlv1=291,wlv2=350,gtype_id=6101003,goods_num=1,base_price=64,add_price=16,one_price=160,unsold_price=[{2,0,32}],tv=0,type=0,gold_type=2};
get_goods(284101,_Wlv) when _Wlv >= 351, _Wlv =< 400 ->
	#base_auction_goods{no=3,goods_id=284101,name= "荣光之证",wlv1=351,wlv2=400,gtype_id=38040045,goods_num=1,base_price=20,add_price=10,one_price=200,unsold_price=[{2,0,10}],tv=0,type=0,gold_type=1};
get_goods(284102,_Wlv) when _Wlv >= 351, _Wlv =< 400 ->
	#base_auction_goods{no=3,goods_id=284102,name= "大师之证",wlv1=351,wlv2=400,gtype_id=38040046,goods_num=1,base_price=50,add_price=25,one_price=500,unsold_price=[{2,0,25}],tv=0,type=0,gold_type=1};
get_goods(284103,_Wlv) when _Wlv >= 351, _Wlv =< 400 ->
	#base_auction_goods{no=3,goods_id=284103,name= "英雄之证",wlv1=351,wlv2=400,gtype_id=38040047,goods_num=1,base_price=125,add_price=63,one_price=1250,unsold_price=[{2,0,63}],tv=0,type=0,gold_type=1};
get_goods(284104,_Wlv) when _Wlv >= 351, _Wlv =< 400 ->
	#base_auction_goods{no=3,goods_id=284104,name= "勇气之证",wlv1=351,wlv2=400,gtype_id=38040044,goods_num=1,base_price=10,add_price=5,one_price=100,unsold_price=[{2,0,5}],tv=0,type=0,gold_type=1};
get_goods(284105,_Wlv) when _Wlv >= 351, _Wlv =< 400 ->
	#base_auction_goods{no=3,goods_id=284105,name= "符文魔晶",wlv1=351,wlv2=400,gtype_id=38040012,goods_num=200,base_price=120,add_price=30,one_price=300,unsold_price=[{2,0,60}],tv=0,type=0,gold_type=1};
get_goods(284106,_Wlv) when _Wlv >= 351, _Wlv =< 400 ->
	#base_auction_goods{no=3,goods_id=284106,name= "魅影项链",wlv1=351,wlv2=400,gtype_id=101034072,goods_num=1,base_price=100,add_price=50,one_price=1000,unsold_price=[{2,0,50}],tv=0,type=0,gold_type=1};
get_goods(284107,_Wlv) when _Wlv >= 351, _Wlv =< 400 ->
	#base_auction_goods{no=3,goods_id=284107,name= "追猎项链",wlv1=351,wlv2=400,gtype_id=101034082,goods_num=1,base_price=100,add_price=50,one_price=1000,unsold_price=[{2,0,50}],tv=0,type=0,gold_type=1};
get_goods(284108,_Wlv) when _Wlv >= 351, _Wlv =< 400 ->
	#base_auction_goods{no=3,goods_id=284108,name= "暗焰项链",wlv1=351,wlv2=400,gtype_id=101034092,goods_num=1,base_price=100,add_price=50,one_price=1000,unsold_price=[{2,0,50}],tv=0,type=0,gold_type=1};
get_goods(284109,_Wlv) when _Wlv >= 351, _Wlv =< 400 ->
	#base_auction_goods{no=3,goods_id=284109,name= "圣徒项链",wlv1=351,wlv2=400,gtype_id=101034102,goods_num=1,base_price=100,add_price=50,one_price=1000,unsold_price=[{2,0,50}],tv=0,type=0,gold_type=1};
get_goods(284110,_Wlv) when _Wlv >= 351, _Wlv =< 400 ->
	#base_auction_goods{no=3,goods_id=284110,name= "审判项链",wlv1=351,wlv2=400,gtype_id=101034112,goods_num=1,base_price=100,add_price=50,one_price=1000,unsold_price=[{2,0,50}],tv=0,type=0,gold_type=1};
get_goods(284111,_Wlv) when _Wlv >= 351, _Wlv =< 400 ->
	#base_auction_goods{no=3,goods_id=284111,name= "征服者项链",wlv1=351,wlv2=400,gtype_id=101034122,goods_num=1,base_price=100,add_price=50,one_price=1000,unsold_price=[{2,0,50}],tv=0,type=0,gold_type=1};
get_goods(284112,_Wlv) when _Wlv >= 351, _Wlv =< 400 ->
	#base_auction_goods{no=3,goods_id=284112,name= "王者项链",wlv1=351,wlv2=400,gtype_id=101034132,goods_num=1,base_price=100,add_price=50,one_price=1000,unsold_price=[{2,0,50}],tv=0,type=0,gold_type=1};
get_goods(284113,_Wlv) when _Wlv >= 351, _Wlv =< 400 ->
	#base_auction_goods{no=3,goods_id=284113,name= "斗士符文礼包",wlv1=351,wlv2=400,gtype_id=32010383,goods_num=1,base_price=150,add_price=50,one_price=1000,unsold_price=[{2,0,75}],tv=0,type=0,gold_type=1};
get_goods(284114,_Wlv) when _Wlv >= 351, _Wlv =< 400 ->
	#base_auction_goods{no=3,goods_id=284114,name= "勇士符文礼包",wlv1=351,wlv2=400,gtype_id=32010384,goods_num=1,base_price=150,add_price=50,one_price=1000,unsold_price=[{2,0,75}],tv=0,type=0,gold_type=1};
get_goods(284115,_Wlv) when _Wlv >= 351, _Wlv =< 400 ->
	#base_auction_goods{no=3,goods_id=284115,name= "侵略符文礼包",wlv1=351,wlv2=400,gtype_id=32010385,goods_num=1,base_price=200,add_price=100,one_price=2000,unsold_price=[{2,0,100}],tv=0,type=0,gold_type=1};
get_goods(284117,_Wlv) when _Wlv >= 351, _Wlv =< 400 ->
	#base_auction_goods{no=3,goods_id=284117,name= "永恒骑士碎片",wlv1=351,wlv2=400,gtype_id=17030107,goods_num=3,base_price=150,add_price=50,one_price=500,unsold_price=[{2,0,75}],tv=0,type=0,gold_type=1};
get_goods(284119,_Wlv) when _Wlv >= 351, _Wlv =< 400 ->
	#base_auction_goods{no=3,goods_id=284119,name= "永恒骑士碎片",wlv1=351,wlv2=400,gtype_id=17030107,goods_num=30,base_price=1000,add_price=500,one_price=5000,unsold_price=[{2,0,500}],tv=0,type=0,gold_type=1};
get_goods(284120,_Wlv) when _Wlv >= 351, _Wlv =< 400 ->
	#base_auction_goods{no=3,goods_id=284120,name= "天使铭刻",wlv1=351,wlv2=400,gtype_id=38040060,goods_num=1,base_price=15,add_price=10,one_price=50,unsold_price=[{2,0,8}],tv=0,type=0,gold_type=1};
get_goods(284121,_Wlv) when _Wlv >= 351, _Wlv =< 400 ->
	#base_auction_goods{no=3,goods_id=284121,name= "恶魔铭刻",wlv1=351,wlv2=400,gtype_id=38040056,goods_num=1,base_price=15,add_price=10,one_price=50,unsold_price=[{2,0,8}],tv=0,type=0,gold_type=1};
get_goods(284201,_Wlv) when _Wlv >= 351, _Wlv =< 400 ->
	#base_auction_goods{no=3,goods_id=284201,name= "符文魔晶",wlv1=351,wlv2=400,gtype_id=38040012,goods_num=60,base_price=36,add_price=18,one_price=90,unsold_price=[{2,0,18}],tv=0,type=0,gold_type=2};
get_goods(284202,_Wlv) when _Wlv >= 351, _Wlv =< 400 ->
	#base_auction_goods{no=3,goods_id=284202,name= "魅影项链",wlv1=351,wlv2=400,gtype_id=101035071,goods_num=1,base_price=80,add_price=40,one_price=400,unsold_price=[{2,0,40}],tv=0,type=0,gold_type=2};
get_goods(284203,_Wlv) when _Wlv >= 351, _Wlv =< 400 ->
	#base_auction_goods{no=3,goods_id=284203,name= "追猎项链",wlv1=351,wlv2=400,gtype_id=101035081,goods_num=1,base_price=80,add_price=40,one_price=400,unsold_price=[{2,0,40}],tv=0,type=0,gold_type=2};
get_goods(284204,_Wlv) when _Wlv >= 351, _Wlv =< 400 ->
	#base_auction_goods{no=3,goods_id=284204,name= "暗焰项链",wlv1=351,wlv2=400,gtype_id=101035091,goods_num=1,base_price=80,add_price=40,one_price=400,unsold_price=[{2,0,40}],tv=0,type=0,gold_type=2};
get_goods(284205,_Wlv) when _Wlv >= 351, _Wlv =< 400 ->
	#base_auction_goods{no=3,goods_id=284205,name= "圣徒项链",wlv1=351,wlv2=400,gtype_id=101035101,goods_num=1,base_price=80,add_price=40,one_price=400,unsold_price=[{2,0,40}],tv=0,type=0,gold_type=2};
get_goods(284206,_Wlv) when _Wlv >= 351, _Wlv =< 400 ->
	#base_auction_goods{no=3,goods_id=284206,name= "审判项链",wlv1=351,wlv2=400,gtype_id=101035111,goods_num=1,base_price=80,add_price=40,one_price=400,unsold_price=[{2,0,40}],tv=0,type=0,gold_type=2};
get_goods(284207,_Wlv) when _Wlv >= 351, _Wlv =< 400 ->
	#base_auction_goods{no=3,goods_id=284207,name= "征服者项链",wlv1=351,wlv2=400,gtype_id=101035121,goods_num=1,base_price=80,add_price=40,one_price=400,unsold_price=[{2,0,40}],tv=0,type=0,gold_type=2};
get_goods(284208,_Wlv) when _Wlv >= 351, _Wlv =< 400 ->
	#base_auction_goods{no=3,goods_id=284208,name= "王者项链",wlv1=351,wlv2=400,gtype_id=101035131,goods_num=1,base_price=80,add_price=40,one_price=400,unsold_price=[{2,0,40}],tv=0,type=0,gold_type=2};
get_goods(284209,_Wlv) when _Wlv >= 351, _Wlv =< 400 ->
	#base_auction_goods{no=3,goods_id=284209,name= "魔魂丹",wlv1=351,wlv2=400,gtype_id=6101001,goods_num=1,base_price=32,add_price=8,one_price=80,unsold_price=[{2,0,16}],tv=0,type=0,gold_type=2};
get_goods(284210,_Wlv) when _Wlv >= 351, _Wlv =< 400 ->
	#base_auction_goods{no=3,goods_id=284210,name= "龙魂丹",wlv1=351,wlv2=400,gtype_id=6101002,goods_num=1,base_price=40,add_price=10,one_price=100,unsold_price=[{2,0,20}],tv=0,type=0,gold_type=2};
get_goods(284211,_Wlv) when _Wlv >= 351, _Wlv =< 400 ->
	#base_auction_goods{no=3,goods_id=284211,name= "神魂丹",wlv1=351,wlv2=400,gtype_id=6101003,goods_num=1,base_price=64,add_price=16,one_price=160,unsold_price=[{2,0,32}],tv=0,type=0,gold_type=2};
get_goods(284212,_Wlv) when _Wlv >= 351, _Wlv =< 400 ->
	#base_auction_goods{no=3,goods_id=284212,name= "勇士符文礼包",wlv1=351,wlv2=400,gtype_id=32010384,goods_num=1,base_price=250,add_price=100,one_price=1000,unsold_price=[{2,0,125}],tv=0,type=0,gold_type=2};
get_goods(284213,_Wlv) when _Wlv >= 351, _Wlv =< 400 ->
	#base_auction_goods{no=3,goods_id=284213,name= "斗士符文礼包",wlv1=351,wlv2=400,gtype_id=32010383,goods_num=1,base_price=250,add_price=100,one_price=1000,unsold_price=[{2,0,125}],tv=0,type=0,gold_type=2};
get_goods(284214,_Wlv) when _Wlv >= 351, _Wlv =< 400 ->
	#base_auction_goods{no=3,goods_id=284214,name= "特殊符文礼包",wlv1=351,wlv2=400,gtype_id=34010130,goods_num=1,base_price=200,add_price=80,one_price=800,unsold_price=[{2,0,100}],tv=0,type=0,gold_type=2};
get_goods(284215,_Wlv) when _Wlv >= 351, _Wlv =< 400 ->
	#base_auction_goods{no=3,goods_id=284215,name= "圣魂丹",wlv1=351,wlv2=400,gtype_id=6101004,goods_num=1,base_price=200,add_price=50,one_price=500,unsold_price=[{2,0,100}],tv=0,type=0,gold_type=2};
get_goods(284216,_Wlv) when _Wlv >= 351, _Wlv =< 400 ->
	#base_auction_goods{no=3,goods_id=284216,name= "纯洁之灵",wlv1=351,wlv2=400,gtype_id=38040061,goods_num=1,base_price=75,add_price=30,one_price=300,unsold_price=[{2,0,38}],tv=0,type=0,gold_type=2};
get_goods(284217,_Wlv) when _Wlv >= 351, _Wlv =< 400 ->
	#base_auction_goods{no=3,goods_id=284217,name= "堕落之魂",wlv1=351,wlv2=400,gtype_id=38040057,goods_num=1,base_price=75,add_price=30,one_price=300,unsold_price=[{2,0,38}],tv=0,type=0,gold_type=2};
get_goods(4021001,_Wlv) when _Wlv >= 351, _Wlv =< 400 ->
	#base_auction_goods{no=3,goods_id=4021001,name= "勇气之证碎片",wlv1=351,wlv2=400,gtype_id=38040048,goods_num=3,base_price=5,add_price=2,one_price=48,unsold_price=[{2,0,3}],tv=0,type=0,gold_type=1};
get_goods(4021002,_Wlv) when _Wlv >= 351, _Wlv =< 400 ->
	#base_auction_goods{no=3,goods_id=4021002,name= "勇气之证",wlv1=351,wlv2=400,gtype_id=38040044,goods_num=1,base_price=8,add_price=4,one_price=80,unsold_price=[{2,0,4}],tv=0,type=0,gold_type=1};
get_goods(4021003,_Wlv) when _Wlv >= 351, _Wlv =< 400 ->
	#base_auction_goods{no=3,goods_id=4021003,name= "荣光之证碎片",wlv1=351,wlv2=400,gtype_id=38040049,goods_num=1,base_price=4,add_price=2,one_price=40,unsold_price=[{2,0,2}],tv=0,type=0,gold_type=1};
get_goods(4021004,_Wlv) when _Wlv >= 351, _Wlv =< 400 ->
	#base_auction_goods{no=3,goods_id=4021004,name= "荣光之证",wlv1=351,wlv2=400,gtype_id=38040045,goods_num=1,base_price=20,add_price=10,one_price=200,unsold_price=[{2,0,10}],tv=0,type=0,gold_type=1};
get_goods(4021005,_Wlv) when _Wlv >= 351, _Wlv =< 400 ->
	#base_auction_goods{no=3,goods_id=4021005,name= "大师之证碎片",wlv1=351,wlv2=400,gtype_id=38040050,goods_num=1,base_price=10,add_price=5,one_price=100,unsold_price=[{2,0,5}],tv=0,type=0,gold_type=1};
get_goods(4021006,_Wlv) when _Wlv >= 351, _Wlv =< 400 ->
	#base_auction_goods{no=3,goods_id=4021006,name= "大师之证",wlv1=351,wlv2=400,gtype_id=38040046,goods_num=1,base_price=50,add_price=25,one_price=500,unsold_price=[{2,0,25}],tv=0,type=0,gold_type=1};
get_goods(4021007,_Wlv) when _Wlv >= 351, _Wlv =< 400 ->
	#base_auction_goods{no=3,goods_id=4021007,name= "英雄之证碎片",wlv1=351,wlv2=400,gtype_id=38040051,goods_num=1,base_price=25,add_price=13,one_price=250,unsold_price=[{2,0,13}],tv=0,type=0,gold_type=1};
get_goods(4021008,_Wlv) when _Wlv >= 351, _Wlv =< 400 ->
	#base_auction_goods{no=3,goods_id=4021008,name= "英雄之证",wlv1=351,wlv2=400,gtype_id=38040047,goods_num=1,base_price=125,add_price=63,one_price=1250,unsold_price=[{2,0,63}],tv=0,type=0,gold_type=1};
get_goods(4021009,_Wlv) when _Wlv >= 351, _Wlv =< 400 ->
	#base_auction_goods{no=3,goods_id=4021009,name= "7阶橙2武防自选",wlv1=351,wlv2=400,gtype_id=34010087,goods_num=1,base_price=50,add_price=25,one_price=500,unsold_price=[{2,0,25}],tv=0,type=0,gold_type=1};
get_goods(4021010,_Wlv) when _Wlv >= 351, _Wlv =< 400 ->
	#base_auction_goods{no=3,goods_id=4021010,name= "8阶橙2武防自选",wlv1=351,wlv2=400,gtype_id=34010088,goods_num=1,base_price=50,add_price=25,one_price=500,unsold_price=[{2,0,25}],tv=0,type=0,gold_type=1};
get_goods(4021011,_Wlv) when _Wlv >= 351, _Wlv =< 400 ->
	#base_auction_goods{no=3,goods_id=4021011,name= "9阶橙2武防自选",wlv1=351,wlv2=400,gtype_id=34010089,goods_num=1,base_price=80,add_price=40,one_price=800,unsold_price=[{2,0,40}],tv=0,type=0,gold_type=1};
get_goods(4021012,_Wlv) when _Wlv >= 351, _Wlv =< 400 ->
	#base_auction_goods{no=3,goods_id=4021012,name= "10阶橙2武防自选",wlv1=351,wlv2=400,gtype_id=34010090,goods_num=1,base_price=80,add_price=40,one_price=800,unsold_price=[{2,0,40}],tv=0,type=0,gold_type=1};
get_goods(4021013,_Wlv) when _Wlv >= 351, _Wlv =< 400 ->
	#base_auction_goods{no=3,goods_id=4021013,name= "11阶橙2武防自选",wlv1=351,wlv2=400,gtype_id=34010091,goods_num=1,base_price=80,add_price=40,one_price=800,unsold_price=[{2,0,40}],tv=0,type=0,gold_type=1};
get_goods(4021014,_Wlv) when _Wlv >= 351, _Wlv =< 400 ->
	#base_auction_goods{no=3,goods_id=4021014,name= "12阶橙2武防自选",wlv1=351,wlv2=400,gtype_id=34010092,goods_num=1,base_price=80,add_price=40,one_price=800,unsold_price=[{2,0,40}],tv=0,type=0,gold_type=1};
get_goods(4021015,_Wlv) when _Wlv >= 351, _Wlv =< 400 ->
	#base_auction_goods{no=3,goods_id=4021015,name= "13阶橙2武防自选",wlv1=351,wlv2=400,gtype_id=34010093,goods_num=1,base_price=80,add_price=40,one_price=800,unsold_price=[{2,0,40}],tv=0,type=0,gold_type=1};
get_goods(4021016,_Wlv) when _Wlv >= 351, _Wlv =< 400 ->
	#base_auction_goods{no=3,goods_id=4021016,name= "秋名飞车碎片",wlv1=351,wlv2=400,gtype_id=16030104,goods_num=5,base_price=50,add_price=25,one_price=500,unsold_price=[{2,0,25}],tv=1,type=0,gold_type=1};
get_goods(4021017,_Wlv) when _Wlv >= 351, _Wlv =< 400 ->
	#base_auction_goods{no=3,goods_id=4021017,name= "秋名飞车碎片",wlv1=351,wlv2=400,gtype_id=16030104,goods_num=5,base_price=50,add_price=25,one_price=500,unsold_price=[{2,0,25}],tv=1,type=0,gold_type=1};
get_goods(4021018,_Wlv) when _Wlv >= 351, _Wlv =< 400 ->
	#base_auction_goods{no=3,goods_id=4021018,name= "阿波罗神魂",wlv1=351,wlv2=400,gtype_id=7120303,goods_num=5,base_price=100,add_price=50,one_price=1000,unsold_price=[{2,0,50}],tv=1,type=0,gold_type=1};
get_goods(4021901,_Wlv) when _Wlv >= 351, _Wlv =< 400 ->
	#base_auction_goods{no=3,goods_id=4021901,name= "勇气之证碎片",wlv1=351,wlv2=400,gtype_id=38040048,goods_num=2,base_price=8,add_price=8,one_price=40,unsold_price=[{2,0,4}],tv=0,type=0,gold_type=2};
get_goods(4021902,_Wlv) when _Wlv >= 351, _Wlv =< 400 ->
	#base_auction_goods{no=3,goods_id=4021902,name= "荣光之证碎片",wlv1=351,wlv2=400,gtype_id=38040049,goods_num=1,base_price=8,add_price=8,one_price=40,unsold_price=[{2,0,4}],tv=0,type=0,gold_type=2};
get_goods(4021903,_Wlv) when _Wlv >= 351, _Wlv =< 400 ->
	#base_auction_goods{no=3,goods_id=4021903,name= "大师之证碎片",wlv1=351,wlv2=400,gtype_id=38040050,goods_num=1,base_price=20,add_price=20,one_price=100,unsold_price=[{2,0,10}],tv=0,type=0,gold_type=2};
get_goods(4021904,_Wlv) when _Wlv >= 351, _Wlv =< 400 ->
	#base_auction_goods{no=3,goods_id=4021904,name= "魔魂丹",wlv1=351,wlv2=400,gtype_id=6101001,goods_num=1,base_price=32,add_price=8,one_price=80,unsold_price=[{2,0,16}],tv=0,type=0,gold_type=2};
get_goods(4021905,_Wlv) when _Wlv >= 351, _Wlv =< 400 ->
	#base_auction_goods{no=3,goods_id=4021905,name= "龙魂丹",wlv1=351,wlv2=400,gtype_id=6101002,goods_num=1,base_price=40,add_price=10,one_price=100,unsold_price=[{2,0,20}],tv=0,type=0,gold_type=2};
get_goods(4021906,_Wlv) when _Wlv >= 351, _Wlv =< 400 ->
	#base_auction_goods{no=3,goods_id=4021906,name= "神魂丹",wlv1=351,wlv2=400,gtype_id=6101003,goods_num=1,base_price=64,add_price=16,one_price=160,unsold_price=[{2,0,32}],tv=0,type=0,gold_type=2};
get_goods(284101,_Wlv) when _Wlv >= 401, _Wlv =< 450 ->
	#base_auction_goods{no=4,goods_id=284101,name= "荣光之证",wlv1=401,wlv2=450,gtype_id=38040045,goods_num=1,base_price=20,add_price=10,one_price=200,unsold_price=[{2,0,10}],tv=0,type=0,gold_type=1};
get_goods(284102,_Wlv) when _Wlv >= 401, _Wlv =< 450 ->
	#base_auction_goods{no=4,goods_id=284102,name= "大师之证",wlv1=401,wlv2=450,gtype_id=38040046,goods_num=1,base_price=50,add_price=25,one_price=500,unsold_price=[{2,0,25}],tv=0,type=0,gold_type=1};
get_goods(284103,_Wlv) when _Wlv >= 401, _Wlv =< 450 ->
	#base_auction_goods{no=4,goods_id=284103,name= "英雄之证",wlv1=401,wlv2=450,gtype_id=38040047,goods_num=1,base_price=125,add_price=63,one_price=1250,unsold_price=[{2,0,63}],tv=0,type=0,gold_type=1};
get_goods(284104,_Wlv) when _Wlv >= 401, _Wlv =< 450 ->
	#base_auction_goods{no=4,goods_id=284104,name= "勇气之证",wlv1=401,wlv2=450,gtype_id=38040044,goods_num=1,base_price=10,add_price=5,one_price=100,unsold_price=[{2,0,5}],tv=0,type=0,gold_type=1};
get_goods(284105,_Wlv) when _Wlv >= 401, _Wlv =< 450 ->
	#base_auction_goods{no=4,goods_id=284105,name= "符文魔晶",wlv1=401,wlv2=450,gtype_id=38040012,goods_num=200,base_price=120,add_price=30,one_price=300,unsold_price=[{2,0,60}],tv=0,type=0,gold_type=1};
get_goods(284106,_Wlv) when _Wlv >= 401, _Wlv =< 450 ->
	#base_auction_goods{no=4,goods_id=284106,name= "魅影项链",wlv1=401,wlv2=450,gtype_id=101034072,goods_num=1,base_price=100,add_price=50,one_price=1000,unsold_price=[{2,0,50}],tv=0,type=0,gold_type=1};
get_goods(284107,_Wlv) when _Wlv >= 401, _Wlv =< 450 ->
	#base_auction_goods{no=4,goods_id=284107,name= "追猎项链",wlv1=401,wlv2=450,gtype_id=101034082,goods_num=1,base_price=100,add_price=50,one_price=1000,unsold_price=[{2,0,50}],tv=0,type=0,gold_type=1};
get_goods(284108,_Wlv) when _Wlv >= 401, _Wlv =< 450 ->
	#base_auction_goods{no=4,goods_id=284108,name= "暗焰项链",wlv1=401,wlv2=450,gtype_id=101034092,goods_num=1,base_price=100,add_price=50,one_price=1000,unsold_price=[{2,0,50}],tv=0,type=0,gold_type=1};
get_goods(284109,_Wlv) when _Wlv >= 401, _Wlv =< 450 ->
	#base_auction_goods{no=4,goods_id=284109,name= "圣徒项链",wlv1=401,wlv2=450,gtype_id=101034102,goods_num=1,base_price=100,add_price=50,one_price=1000,unsold_price=[{2,0,50}],tv=0,type=0,gold_type=1};
get_goods(284110,_Wlv) when _Wlv >= 401, _Wlv =< 450 ->
	#base_auction_goods{no=4,goods_id=284110,name= "审判项链",wlv1=401,wlv2=450,gtype_id=101034112,goods_num=1,base_price=100,add_price=50,one_price=1000,unsold_price=[{2,0,50}],tv=0,type=0,gold_type=1};
get_goods(284111,_Wlv) when _Wlv >= 401, _Wlv =< 450 ->
	#base_auction_goods{no=4,goods_id=284111,name= "征服者项链",wlv1=401,wlv2=450,gtype_id=101034122,goods_num=1,base_price=100,add_price=50,one_price=1000,unsold_price=[{2,0,50}],tv=0,type=0,gold_type=1};
get_goods(284112,_Wlv) when _Wlv >= 401, _Wlv =< 450 ->
	#base_auction_goods{no=4,goods_id=284112,name= "王者项链",wlv1=401,wlv2=450,gtype_id=101034132,goods_num=1,base_price=100,add_price=50,one_price=1000,unsold_price=[{2,0,50}],tv=0,type=0,gold_type=1};
get_goods(284113,_Wlv) when _Wlv >= 401, _Wlv =< 450 ->
	#base_auction_goods{no=4,goods_id=284113,name= "斗士符文礼包",wlv1=401,wlv2=450,gtype_id=32010383,goods_num=1,base_price=150,add_price=50,one_price=1000,unsold_price=[{2,0,75}],tv=0,type=0,gold_type=1};
get_goods(284114,_Wlv) when _Wlv >= 401, _Wlv =< 450 ->
	#base_auction_goods{no=4,goods_id=284114,name= "勇士符文礼包",wlv1=401,wlv2=450,gtype_id=32010384,goods_num=1,base_price=150,add_price=50,one_price=1000,unsold_price=[{2,0,75}],tv=0,type=0,gold_type=1};
get_goods(284115,_Wlv) when _Wlv >= 401, _Wlv =< 450 ->
	#base_auction_goods{no=4,goods_id=284115,name= "侵略符文礼包",wlv1=401,wlv2=450,gtype_id=32010385,goods_num=1,base_price=200,add_price=100,one_price=2000,unsold_price=[{2,0,100}],tv=0,type=0,gold_type=1};
get_goods(284117,_Wlv) when _Wlv >= 401, _Wlv =< 450 ->
	#base_auction_goods{no=4,goods_id=284117,name= "永恒骑士碎片",wlv1=401,wlv2=450,gtype_id=17030107,goods_num=3,base_price=150,add_price=50,one_price=500,unsold_price=[{2,0,75}],tv=0,type=0,gold_type=1};
get_goods(284119,_Wlv) when _Wlv >= 401, _Wlv =< 450 ->
	#base_auction_goods{no=4,goods_id=284119,name= "永恒骑士碎片",wlv1=401,wlv2=450,gtype_id=17030107,goods_num=30,base_price=1000,add_price=500,one_price=5000,unsold_price=[{2,0,500}],tv=0,type=0,gold_type=1};
get_goods(284120,_Wlv) when _Wlv >= 401, _Wlv =< 450 ->
	#base_auction_goods{no=4,goods_id=284120,name= "天使铭刻",wlv1=401,wlv2=450,gtype_id=38040060,goods_num=1,base_price=15,add_price=10,one_price=50,unsold_price=[{2,0,8}],tv=0,type=0,gold_type=1};
get_goods(284121,_Wlv) when _Wlv >= 401, _Wlv =< 450 ->
	#base_auction_goods{no=4,goods_id=284121,name= "恶魔铭刻",wlv1=401,wlv2=450,gtype_id=38040056,goods_num=1,base_price=15,add_price=10,one_price=50,unsold_price=[{2,0,8}],tv=0,type=0,gold_type=1};
get_goods(284201,_Wlv) when _Wlv >= 401, _Wlv =< 450 ->
	#base_auction_goods{no=4,goods_id=284201,name= "符文魔晶",wlv1=401,wlv2=450,gtype_id=38040012,goods_num=60,base_price=36,add_price=18,one_price=90,unsold_price=[{2,0,18}],tv=0,type=0,gold_type=2};
get_goods(284202,_Wlv) when _Wlv >= 401, _Wlv =< 450 ->
	#base_auction_goods{no=4,goods_id=284202,name= "魅影项链",wlv1=401,wlv2=450,gtype_id=101035071,goods_num=1,base_price=80,add_price=40,one_price=400,unsold_price=[{2,0,40}],tv=0,type=0,gold_type=2};
get_goods(284203,_Wlv) when _Wlv >= 401, _Wlv =< 450 ->
	#base_auction_goods{no=4,goods_id=284203,name= "追猎项链",wlv1=401,wlv2=450,gtype_id=101035081,goods_num=1,base_price=80,add_price=40,one_price=400,unsold_price=[{2,0,40}],tv=0,type=0,gold_type=2};
get_goods(284204,_Wlv) when _Wlv >= 401, _Wlv =< 450 ->
	#base_auction_goods{no=4,goods_id=284204,name= "暗焰项链",wlv1=401,wlv2=450,gtype_id=101035091,goods_num=1,base_price=80,add_price=40,one_price=400,unsold_price=[{2,0,40}],tv=0,type=0,gold_type=2};
get_goods(284205,_Wlv) when _Wlv >= 401, _Wlv =< 450 ->
	#base_auction_goods{no=4,goods_id=284205,name= "圣徒项链",wlv1=401,wlv2=450,gtype_id=101035101,goods_num=1,base_price=80,add_price=40,one_price=400,unsold_price=[{2,0,40}],tv=0,type=0,gold_type=2};
get_goods(284206,_Wlv) when _Wlv >= 401, _Wlv =< 450 ->
	#base_auction_goods{no=4,goods_id=284206,name= "审判项链",wlv1=401,wlv2=450,gtype_id=101035111,goods_num=1,base_price=80,add_price=40,one_price=400,unsold_price=[{2,0,40}],tv=0,type=0,gold_type=2};
get_goods(284207,_Wlv) when _Wlv >= 401, _Wlv =< 450 ->
	#base_auction_goods{no=4,goods_id=284207,name= "征服者项链",wlv1=401,wlv2=450,gtype_id=101035121,goods_num=1,base_price=80,add_price=40,one_price=400,unsold_price=[{2,0,40}],tv=0,type=0,gold_type=2};
get_goods(284208,_Wlv) when _Wlv >= 401, _Wlv =< 450 ->
	#base_auction_goods{no=4,goods_id=284208,name= "王者项链",wlv1=401,wlv2=450,gtype_id=101035131,goods_num=1,base_price=80,add_price=40,one_price=400,unsold_price=[{2,0,40}],tv=0,type=0,gold_type=2};
get_goods(284209,_Wlv) when _Wlv >= 401, _Wlv =< 450 ->
	#base_auction_goods{no=4,goods_id=284209,name= "魔魂丹",wlv1=401,wlv2=450,gtype_id=6101001,goods_num=1,base_price=32,add_price=8,one_price=80,unsold_price=[{2,0,16}],tv=0,type=0,gold_type=2};
get_goods(284210,_Wlv) when _Wlv >= 401, _Wlv =< 450 ->
	#base_auction_goods{no=4,goods_id=284210,name= "龙魂丹",wlv1=401,wlv2=450,gtype_id=6101002,goods_num=1,base_price=40,add_price=10,one_price=100,unsold_price=[{2,0,20}],tv=0,type=0,gold_type=2};
get_goods(284211,_Wlv) when _Wlv >= 401, _Wlv =< 450 ->
	#base_auction_goods{no=4,goods_id=284211,name= "神魂丹",wlv1=401,wlv2=450,gtype_id=6101003,goods_num=1,base_price=64,add_price=16,one_price=160,unsold_price=[{2,0,32}],tv=0,type=0,gold_type=2};
get_goods(284212,_Wlv) when _Wlv >= 401, _Wlv =< 450 ->
	#base_auction_goods{no=4,goods_id=284212,name= "勇士符文礼包",wlv1=401,wlv2=450,gtype_id=32010384,goods_num=1,base_price=250,add_price=100,one_price=1000,unsold_price=[{2,0,125}],tv=0,type=0,gold_type=2};
get_goods(284213,_Wlv) when _Wlv >= 401, _Wlv =< 450 ->
	#base_auction_goods{no=4,goods_id=284213,name= "斗士符文礼包",wlv1=401,wlv2=450,gtype_id=32010383,goods_num=1,base_price=250,add_price=100,one_price=1000,unsold_price=[{2,0,125}],tv=0,type=0,gold_type=2};
get_goods(284214,_Wlv) when _Wlv >= 401, _Wlv =< 450 ->
	#base_auction_goods{no=4,goods_id=284214,name= "特殊符文礼包",wlv1=401,wlv2=450,gtype_id=34010130,goods_num=1,base_price=200,add_price=80,one_price=800,unsold_price=[{2,0,100}],tv=0,type=0,gold_type=2};
get_goods(284215,_Wlv) when _Wlv >= 401, _Wlv =< 450 ->
	#base_auction_goods{no=4,goods_id=284215,name= "圣魂丹",wlv1=401,wlv2=450,gtype_id=6101004,goods_num=1,base_price=200,add_price=50,one_price=500,unsold_price=[{2,0,100}],tv=0,type=0,gold_type=2};
get_goods(284216,_Wlv) when _Wlv >= 401, _Wlv =< 450 ->
	#base_auction_goods{no=4,goods_id=284216,name= "纯洁之灵",wlv1=401,wlv2=450,gtype_id=38040061,goods_num=1,base_price=75,add_price=30,one_price=300,unsold_price=[{2,0,38}],tv=0,type=0,gold_type=2};
get_goods(284217,_Wlv) when _Wlv >= 401, _Wlv =< 450 ->
	#base_auction_goods{no=4,goods_id=284217,name= "堕落之魂",wlv1=401,wlv2=450,gtype_id=38040057,goods_num=1,base_price=75,add_price=30,one_price=300,unsold_price=[{2,0,38}],tv=0,type=0,gold_type=2};
get_goods(4021001,_Wlv) when _Wlv >= 401, _Wlv =< 455 ->
	#base_auction_goods{no=4,goods_id=4021001,name= "勇气之证碎片",wlv1=401,wlv2=455,gtype_id=38040048,goods_num=3,base_price=4,add_price=2,one_price=36,unsold_price=[{2,0,2}],tv=0,type=0,gold_type=1};
get_goods(4021002,_Wlv) when _Wlv >= 401, _Wlv =< 455 ->
	#base_auction_goods{no=4,goods_id=4021002,name= "勇气之证",wlv1=401,wlv2=455,gtype_id=38040044,goods_num=1,base_price=6,add_price=3,one_price=60,unsold_price=[{2,0,3}],tv=0,type=0,gold_type=1};
get_goods(4021003,_Wlv) when _Wlv >= 401, _Wlv =< 455 ->
	#base_auction_goods{no=4,goods_id=4021003,name= "荣光之证碎片",wlv1=401,wlv2=455,gtype_id=38040049,goods_num=1,base_price=3,add_price=2,one_price=32,unsold_price=[{2,0,2}],tv=0,type=0,gold_type=1};
get_goods(4021004,_Wlv) when _Wlv >= 401, _Wlv =< 455 ->
	#base_auction_goods{no=4,goods_id=4021004,name= "荣光之证",wlv1=401,wlv2=455,gtype_id=38040045,goods_num=1,base_price=16,add_price=8,one_price=160,unsold_price=[{2,0,8}],tv=0,type=0,gold_type=1};
get_goods(4021005,_Wlv) when _Wlv >= 401, _Wlv =< 455 ->
	#base_auction_goods{no=4,goods_id=4021005,name= "大师之证碎片",wlv1=401,wlv2=455,gtype_id=38040050,goods_num=1,base_price=10,add_price=5,one_price=100,unsold_price=[{2,0,5}],tv=0,type=0,gold_type=1};
get_goods(4021006,_Wlv) when _Wlv >= 401, _Wlv =< 455 ->
	#base_auction_goods{no=4,goods_id=4021006,name= "大师之证",wlv1=401,wlv2=455,gtype_id=38040046,goods_num=1,base_price=50,add_price=25,one_price=500,unsold_price=[{2,0,25}],tv=0,type=0,gold_type=1};
get_goods(4021007,_Wlv) when _Wlv >= 401, _Wlv =< 455 ->
	#base_auction_goods{no=4,goods_id=4021007,name= "英雄之证碎片",wlv1=401,wlv2=455,gtype_id=38040051,goods_num=1,base_price=25,add_price=13,one_price=250,unsold_price=[{2,0,13}],tv=0,type=0,gold_type=1};
get_goods(4021008,_Wlv) when _Wlv >= 401, _Wlv =< 455 ->
	#base_auction_goods{no=4,goods_id=4021008,name= "英雄之证",wlv1=401,wlv2=455,gtype_id=38040047,goods_num=1,base_price=125,add_price=63,one_price=1250,unsold_price=[{2,0,63}],tv=0,type=0,gold_type=1};
get_goods(4021009,_Wlv) when _Wlv >= 401, _Wlv =< 455 ->
	#base_auction_goods{no=4,goods_id=4021009,name= "7阶橙2武防自选",wlv1=401,wlv2=455,gtype_id=34010087,goods_num=1,base_price=50,add_price=25,one_price=500,unsold_price=[{2,0,25}],tv=0,type=0,gold_type=1};
get_goods(4021010,_Wlv) when _Wlv >= 401, _Wlv =< 455 ->
	#base_auction_goods{no=4,goods_id=4021010,name= "8阶橙2武防自选",wlv1=401,wlv2=455,gtype_id=34010088,goods_num=1,base_price=50,add_price=25,one_price=500,unsold_price=[{2,0,25}],tv=0,type=0,gold_type=1};
get_goods(4021011,_Wlv) when _Wlv >= 401, _Wlv =< 455 ->
	#base_auction_goods{no=4,goods_id=4021011,name= "9阶橙2武防自选",wlv1=401,wlv2=455,gtype_id=34010089,goods_num=1,base_price=50,add_price=25,one_price=500,unsold_price=[{2,0,25}],tv=0,type=0,gold_type=1};
get_goods(4021012,_Wlv) when _Wlv >= 401, _Wlv =< 455 ->
	#base_auction_goods{no=4,goods_id=4021012,name= "10阶橙2武防自选",wlv1=401,wlv2=455,gtype_id=34010090,goods_num=1,base_price=80,add_price=40,one_price=800,unsold_price=[{2,0,40}],tv=0,type=0,gold_type=1};
get_goods(4021013,_Wlv) when _Wlv >= 401, _Wlv =< 455 ->
	#base_auction_goods{no=4,goods_id=4021013,name= "11阶橙2武防自选",wlv1=401,wlv2=455,gtype_id=34010091,goods_num=1,base_price=80,add_price=40,one_price=800,unsold_price=[{2,0,40}],tv=0,type=0,gold_type=1};
get_goods(4021014,_Wlv) when _Wlv >= 401, _Wlv =< 455 ->
	#base_auction_goods{no=4,goods_id=4021014,name= "12阶橙2武防自选",wlv1=401,wlv2=455,gtype_id=34010092,goods_num=1,base_price=80,add_price=40,one_price=800,unsold_price=[{2,0,40}],tv=0,type=0,gold_type=1};
get_goods(4021015,_Wlv) when _Wlv >= 401, _Wlv =< 455 ->
	#base_auction_goods{no=4,goods_id=4021015,name= "13阶橙2武防自选",wlv1=401,wlv2=455,gtype_id=34010093,goods_num=1,base_price=80,add_price=40,one_price=800,unsold_price=[{2,0,40}],tv=0,type=0,gold_type=1};
get_goods(4021016,_Wlv) when _Wlv >= 401, _Wlv =< 455 ->
	#base_auction_goods{no=4,goods_id=4021016,name= "秋名飞车碎片",wlv1=401,wlv2=455,gtype_id=16030104,goods_num=5,base_price=50,add_price=25,one_price=500,unsold_price=[{2,0,25}],tv=1,type=0,gold_type=1};
get_goods(4021017,_Wlv) when _Wlv >= 401, _Wlv =< 455 ->
	#base_auction_goods{no=4,goods_id=4021017,name= "秋名飞车碎片",wlv1=401,wlv2=455,gtype_id=16030104,goods_num=5,base_price=50,add_price=25,one_price=500,unsold_price=[{2,0,25}],tv=1,type=0,gold_type=1};
get_goods(4021018,_Wlv) when _Wlv >= 401, _Wlv =< 455 ->
	#base_auction_goods{no=4,goods_id=4021018,name= "阿波罗神魂",wlv1=401,wlv2=455,gtype_id=7120303,goods_num=5,base_price=100,add_price=50,one_price=1000,unsold_price=[{2,0,50}],tv=1,type=0,gold_type=1};
get_goods(4021901,_Wlv) when _Wlv >= 401, _Wlv =< 455 ->
	#base_auction_goods{no=4,goods_id=4021901,name= "勇气之证碎片",wlv1=401,wlv2=455,gtype_id=38040048,goods_num=2,base_price=8,add_price=8,one_price=40,unsold_price=[{2,0,4}],tv=0,type=0,gold_type=2};
get_goods(4021902,_Wlv) when _Wlv >= 401, _Wlv =< 455 ->
	#base_auction_goods{no=4,goods_id=4021902,name= "荣光之证碎片",wlv1=401,wlv2=455,gtype_id=38040049,goods_num=1,base_price=8,add_price=8,one_price=40,unsold_price=[{2,0,4}],tv=0,type=0,gold_type=2};
get_goods(4021903,_Wlv) when _Wlv >= 401, _Wlv =< 455 ->
	#base_auction_goods{no=4,goods_id=4021903,name= "大师之证碎片",wlv1=401,wlv2=455,gtype_id=38040050,goods_num=1,base_price=20,add_price=20,one_price=100,unsold_price=[{2,0,10}],tv=0,type=0,gold_type=2};
get_goods(4021904,_Wlv) when _Wlv >= 401, _Wlv =< 455 ->
	#base_auction_goods{no=4,goods_id=4021904,name= "魔魂丹",wlv1=401,wlv2=455,gtype_id=6101001,goods_num=1,base_price=32,add_price=8,one_price=80,unsold_price=[{2,0,16}],tv=0,type=0,gold_type=2};
get_goods(4021905,_Wlv) when _Wlv >= 401, _Wlv =< 455 ->
	#base_auction_goods{no=4,goods_id=4021905,name= "龙魂丹",wlv1=401,wlv2=455,gtype_id=6101002,goods_num=1,base_price=40,add_price=10,one_price=100,unsold_price=[{2,0,20}],tv=0,type=0,gold_type=2};
get_goods(4021906,_Wlv) when _Wlv >= 401, _Wlv =< 455 ->
	#base_auction_goods{no=4,goods_id=4021906,name= "神魂丹",wlv1=401,wlv2=455,gtype_id=6101003,goods_num=1,base_price=64,add_price=16,one_price=160,unsold_price=[{2,0,32}],tv=0,type=0,gold_type=2};
get_goods(284101,_Wlv) when _Wlv >= 451, _Wlv =< 500 ->
	#base_auction_goods{no=5,goods_id=284101,name= "荣光之证",wlv1=451,wlv2=500,gtype_id=38040045,goods_num=1,base_price=20,add_price=10,one_price=200,unsold_price=[{2,0,10}],tv=0,type=0,gold_type=1};
get_goods(284102,_Wlv) when _Wlv >= 451, _Wlv =< 500 ->
	#base_auction_goods{no=5,goods_id=284102,name= "大师之证",wlv1=451,wlv2=500,gtype_id=38040046,goods_num=1,base_price=50,add_price=25,one_price=500,unsold_price=[{2,0,25}],tv=0,type=0,gold_type=1};
get_goods(284103,_Wlv) when _Wlv >= 451, _Wlv =< 500 ->
	#base_auction_goods{no=5,goods_id=284103,name= "英雄之证",wlv1=451,wlv2=500,gtype_id=38040047,goods_num=1,base_price=125,add_price=63,one_price=1250,unsold_price=[{2,0,63}],tv=0,type=0,gold_type=1};
get_goods(284104,_Wlv) when _Wlv >= 451, _Wlv =< 500 ->
	#base_auction_goods{no=5,goods_id=284104,name= "勇气之证",wlv1=451,wlv2=500,gtype_id=38040044,goods_num=1,base_price=10,add_price=5,one_price=100,unsold_price=[{2,0,5}],tv=0,type=0,gold_type=1};
get_goods(284105,_Wlv) when _Wlv >= 451, _Wlv =< 500 ->
	#base_auction_goods{no=5,goods_id=284105,name= "符文魔晶",wlv1=451,wlv2=500,gtype_id=38040012,goods_num=200,base_price=120,add_price=30,one_price=300,unsold_price=[{2,0,60}],tv=0,type=0,gold_type=1};
get_goods(284106,_Wlv) when _Wlv >= 451, _Wlv =< 500 ->
	#base_auction_goods{no=5,goods_id=284106,name= "魅影项链",wlv1=451,wlv2=500,gtype_id=101034072,goods_num=1,base_price=100,add_price=50,one_price=1000,unsold_price=[{2,0,50}],tv=0,type=0,gold_type=1};
get_goods(284107,_Wlv) when _Wlv >= 451, _Wlv =< 500 ->
	#base_auction_goods{no=5,goods_id=284107,name= "追猎项链",wlv1=451,wlv2=500,gtype_id=101034082,goods_num=1,base_price=100,add_price=50,one_price=1000,unsold_price=[{2,0,50}],tv=0,type=0,gold_type=1};
get_goods(284108,_Wlv) when _Wlv >= 451, _Wlv =< 500 ->
	#base_auction_goods{no=5,goods_id=284108,name= "暗焰项链",wlv1=451,wlv2=500,gtype_id=101034092,goods_num=1,base_price=100,add_price=50,one_price=1000,unsold_price=[{2,0,50}],tv=0,type=0,gold_type=1};
get_goods(284109,_Wlv) when _Wlv >= 451, _Wlv =< 500 ->
	#base_auction_goods{no=5,goods_id=284109,name= "圣徒项链",wlv1=451,wlv2=500,gtype_id=101034102,goods_num=1,base_price=100,add_price=50,one_price=1000,unsold_price=[{2,0,50}],tv=0,type=0,gold_type=1};
get_goods(284110,_Wlv) when _Wlv >= 451, _Wlv =< 500 ->
	#base_auction_goods{no=5,goods_id=284110,name= "审判项链",wlv1=451,wlv2=500,gtype_id=101034112,goods_num=1,base_price=100,add_price=50,one_price=1000,unsold_price=[{2,0,50}],tv=0,type=0,gold_type=1};
get_goods(284111,_Wlv) when _Wlv >= 451, _Wlv =< 500 ->
	#base_auction_goods{no=5,goods_id=284111,name= "征服者项链",wlv1=451,wlv2=500,gtype_id=101034122,goods_num=1,base_price=100,add_price=50,one_price=1000,unsold_price=[{2,0,50}],tv=0,type=0,gold_type=1};
get_goods(284112,_Wlv) when _Wlv >= 451, _Wlv =< 500 ->
	#base_auction_goods{no=5,goods_id=284112,name= "王者项链",wlv1=451,wlv2=500,gtype_id=101034132,goods_num=1,base_price=100,add_price=50,one_price=1000,unsold_price=[{2,0,50}],tv=0,type=0,gold_type=1};
get_goods(284113,_Wlv) when _Wlv >= 451, _Wlv =< 500 ->
	#base_auction_goods{no=5,goods_id=284113,name= "斗士符文礼包",wlv1=451,wlv2=500,gtype_id=32010383,goods_num=1,base_price=150,add_price=50,one_price=1000,unsold_price=[{2,0,75}],tv=0,type=0,gold_type=1};
get_goods(284114,_Wlv) when _Wlv >= 451, _Wlv =< 500 ->
	#base_auction_goods{no=5,goods_id=284114,name= "勇士符文礼包",wlv1=451,wlv2=500,gtype_id=32010384,goods_num=1,base_price=150,add_price=50,one_price=1000,unsold_price=[{2,0,75}],tv=0,type=0,gold_type=1};
get_goods(284115,_Wlv) when _Wlv >= 451, _Wlv =< 500 ->
	#base_auction_goods{no=5,goods_id=284115,name= "侵略符文礼包",wlv1=451,wlv2=500,gtype_id=32010385,goods_num=1,base_price=200,add_price=100,one_price=2000,unsold_price=[{2,0,100}],tv=0,type=0,gold_type=1};
get_goods(284117,_Wlv) when _Wlv >= 451, _Wlv =< 500 ->
	#base_auction_goods{no=5,goods_id=284117,name= "永恒骑士碎片",wlv1=451,wlv2=500,gtype_id=17030107,goods_num=3,base_price=150,add_price=50,one_price=500,unsold_price=[{2,0,75}],tv=0,type=0,gold_type=1};
get_goods(284119,_Wlv) when _Wlv >= 451, _Wlv =< 500 ->
	#base_auction_goods{no=5,goods_id=284119,name= "永恒骑士碎片",wlv1=451,wlv2=500,gtype_id=17030107,goods_num=30,base_price=1000,add_price=500,one_price=5000,unsold_price=[{2,0,500}],tv=0,type=0,gold_type=1};
get_goods(284120,_Wlv) when _Wlv >= 451, _Wlv =< 500 ->
	#base_auction_goods{no=5,goods_id=284120,name= "天使铭刻",wlv1=451,wlv2=500,gtype_id=38040060,goods_num=1,base_price=15,add_price=10,one_price=50,unsold_price=[{2,0,8}],tv=0,type=0,gold_type=1};
get_goods(284121,_Wlv) when _Wlv >= 451, _Wlv =< 500 ->
	#base_auction_goods{no=5,goods_id=284121,name= "恶魔铭刻",wlv1=451,wlv2=500,gtype_id=38040056,goods_num=1,base_price=15,add_price=10,one_price=50,unsold_price=[{2,0,8}],tv=0,type=0,gold_type=1};
get_goods(284201,_Wlv) when _Wlv >= 451, _Wlv =< 500 ->
	#base_auction_goods{no=5,goods_id=284201,name= "符文魔晶",wlv1=451,wlv2=500,gtype_id=38040012,goods_num=60,base_price=36,add_price=18,one_price=90,unsold_price=[{2,0,18}],tv=0,type=0,gold_type=2};
get_goods(284202,_Wlv) when _Wlv >= 451, _Wlv =< 500 ->
	#base_auction_goods{no=5,goods_id=284202,name= "魅影项链",wlv1=451,wlv2=500,gtype_id=101035071,goods_num=1,base_price=80,add_price=40,one_price=400,unsold_price=[{2,0,40}],tv=0,type=0,gold_type=2};
get_goods(284203,_Wlv) when _Wlv >= 451, _Wlv =< 500 ->
	#base_auction_goods{no=5,goods_id=284203,name= "追猎项链",wlv1=451,wlv2=500,gtype_id=101035081,goods_num=1,base_price=80,add_price=40,one_price=400,unsold_price=[{2,0,40}],tv=0,type=0,gold_type=2};
get_goods(284204,_Wlv) when _Wlv >= 451, _Wlv =< 500 ->
	#base_auction_goods{no=5,goods_id=284204,name= "暗焰项链",wlv1=451,wlv2=500,gtype_id=101035091,goods_num=1,base_price=80,add_price=40,one_price=400,unsold_price=[{2,0,40}],tv=0,type=0,gold_type=2};
get_goods(284205,_Wlv) when _Wlv >= 451, _Wlv =< 500 ->
	#base_auction_goods{no=5,goods_id=284205,name= "圣徒项链",wlv1=451,wlv2=500,gtype_id=101035101,goods_num=1,base_price=80,add_price=40,one_price=400,unsold_price=[{2,0,40}],tv=0,type=0,gold_type=2};
get_goods(284206,_Wlv) when _Wlv >= 451, _Wlv =< 500 ->
	#base_auction_goods{no=5,goods_id=284206,name= "审判项链",wlv1=451,wlv2=500,gtype_id=101035111,goods_num=1,base_price=80,add_price=40,one_price=400,unsold_price=[{2,0,40}],tv=0,type=0,gold_type=2};
get_goods(284207,_Wlv) when _Wlv >= 451, _Wlv =< 500 ->
	#base_auction_goods{no=5,goods_id=284207,name= "征服者项链",wlv1=451,wlv2=500,gtype_id=101035121,goods_num=1,base_price=80,add_price=40,one_price=400,unsold_price=[{2,0,40}],tv=0,type=0,gold_type=2};
get_goods(284208,_Wlv) when _Wlv >= 451, _Wlv =< 500 ->
	#base_auction_goods{no=5,goods_id=284208,name= "王者项链",wlv1=451,wlv2=500,gtype_id=101035131,goods_num=1,base_price=80,add_price=40,one_price=400,unsold_price=[{2,0,40}],tv=0,type=0,gold_type=2};
get_goods(284209,_Wlv) when _Wlv >= 451, _Wlv =< 500 ->
	#base_auction_goods{no=5,goods_id=284209,name= "魔魂丹",wlv1=451,wlv2=500,gtype_id=6101001,goods_num=1,base_price=32,add_price=8,one_price=80,unsold_price=[{2,0,16}],tv=0,type=0,gold_type=2};
get_goods(284210,_Wlv) when _Wlv >= 451, _Wlv =< 500 ->
	#base_auction_goods{no=5,goods_id=284210,name= "龙魂丹",wlv1=451,wlv2=500,gtype_id=6101002,goods_num=1,base_price=40,add_price=10,one_price=100,unsold_price=[{2,0,20}],tv=0,type=0,gold_type=2};
get_goods(284211,_Wlv) when _Wlv >= 451, _Wlv =< 500 ->
	#base_auction_goods{no=5,goods_id=284211,name= "神魂丹",wlv1=451,wlv2=500,gtype_id=6101003,goods_num=1,base_price=64,add_price=16,one_price=160,unsold_price=[{2,0,32}],tv=0,type=0,gold_type=2};
get_goods(284212,_Wlv) when _Wlv >= 451, _Wlv =< 500 ->
	#base_auction_goods{no=5,goods_id=284212,name= "勇士符文礼包",wlv1=451,wlv2=500,gtype_id=32010384,goods_num=1,base_price=250,add_price=100,one_price=1000,unsold_price=[{2,0,125}],tv=0,type=0,gold_type=2};
get_goods(284213,_Wlv) when _Wlv >= 451, _Wlv =< 500 ->
	#base_auction_goods{no=5,goods_id=284213,name= "斗士符文礼包",wlv1=451,wlv2=500,gtype_id=32010383,goods_num=1,base_price=250,add_price=100,one_price=1000,unsold_price=[{2,0,125}],tv=0,type=0,gold_type=2};
get_goods(284214,_Wlv) when _Wlv >= 451, _Wlv =< 500 ->
	#base_auction_goods{no=5,goods_id=284214,name= "特殊符文礼包",wlv1=451,wlv2=500,gtype_id=34010130,goods_num=1,base_price=200,add_price=80,one_price=800,unsold_price=[{2,0,100}],tv=0,type=0,gold_type=2};
get_goods(284215,_Wlv) when _Wlv >= 451, _Wlv =< 500 ->
	#base_auction_goods{no=5,goods_id=284215,name= "圣魂丹",wlv1=451,wlv2=500,gtype_id=6101004,goods_num=1,base_price=200,add_price=50,one_price=500,unsold_price=[{2,0,100}],tv=0,type=0,gold_type=2};
get_goods(284216,_Wlv) when _Wlv >= 451, _Wlv =< 500 ->
	#base_auction_goods{no=5,goods_id=284216,name= "纯洁之灵",wlv1=451,wlv2=500,gtype_id=38040061,goods_num=1,base_price=75,add_price=30,one_price=300,unsold_price=[{2,0,38}],tv=0,type=0,gold_type=2};
get_goods(284217,_Wlv) when _Wlv >= 451, _Wlv =< 500 ->
	#base_auction_goods{no=5,goods_id=284217,name= "堕落之魂",wlv1=451,wlv2=500,gtype_id=38040057,goods_num=1,base_price=75,add_price=30,one_price=300,unsold_price=[{2,0,38}],tv=0,type=0,gold_type=2};
get_goods(4021001,_Wlv) when _Wlv >= 456, _Wlv =< 500 ->
	#base_auction_goods{no=5,goods_id=4021001,name= "勇气之证碎片",wlv1=456,wlv2=500,gtype_id=38040048,goods_num=3,base_price=4,add_price=2,one_price=36,unsold_price=[{2,0,2}],tv=0,type=0,gold_type=1};
get_goods(4021002,_Wlv) when _Wlv >= 456, _Wlv =< 500 ->
	#base_auction_goods{no=5,goods_id=4021002,name= "勇气之证",wlv1=456,wlv2=500,gtype_id=38040044,goods_num=1,base_price=6,add_price=3,one_price=60,unsold_price=[{2,0,3}],tv=0,type=0,gold_type=1};
get_goods(4021003,_Wlv) when _Wlv >= 456, _Wlv =< 500 ->
	#base_auction_goods{no=5,goods_id=4021003,name= "荣光之证碎片",wlv1=456,wlv2=500,gtype_id=38040049,goods_num=1,base_price=2,add_price=1,one_price=24,unsold_price=[{2,0,1}],tv=0,type=0,gold_type=1};
get_goods(4021004,_Wlv) when _Wlv >= 456, _Wlv =< 500 ->
	#base_auction_goods{no=5,goods_id=4021004,name= "荣光之证",wlv1=456,wlv2=500,gtype_id=38040045,goods_num=1,base_price=12,add_price=6,one_price=120,unsold_price=[{2,0,6}],tv=0,type=0,gold_type=1};
get_goods(4021005,_Wlv) when _Wlv >= 456, _Wlv =< 500 ->
	#base_auction_goods{no=5,goods_id=4021005,name= "大师之证碎片",wlv1=456,wlv2=500,gtype_id=38040050,goods_num=1,base_price=10,add_price=5,one_price=100,unsold_price=[{2,0,5}],tv=0,type=0,gold_type=1};
get_goods(4021006,_Wlv) when _Wlv >= 456, _Wlv =< 500 ->
	#base_auction_goods{no=5,goods_id=4021006,name= "大师之证",wlv1=456,wlv2=500,gtype_id=38040046,goods_num=1,base_price=50,add_price=25,one_price=500,unsold_price=[{2,0,25}],tv=0,type=0,gold_type=1};
get_goods(4021007,_Wlv) when _Wlv >= 456, _Wlv =< 500 ->
	#base_auction_goods{no=5,goods_id=4021007,name= "英雄之证碎片",wlv1=456,wlv2=500,gtype_id=38040051,goods_num=1,base_price=25,add_price=13,one_price=250,unsold_price=[{2,0,13}],tv=0,type=0,gold_type=1};
get_goods(4021008,_Wlv) when _Wlv >= 456, _Wlv =< 500 ->
	#base_auction_goods{no=5,goods_id=4021008,name= "英雄之证",wlv1=456,wlv2=500,gtype_id=38040047,goods_num=1,base_price=125,add_price=63,one_price=1250,unsold_price=[{2,0,63}],tv=0,type=0,gold_type=1};
get_goods(4021009,_Wlv) when _Wlv >= 456, _Wlv =< 500 ->
	#base_auction_goods{no=5,goods_id=4021009,name= "7阶橙2武防自选",wlv1=456,wlv2=500,gtype_id=34010087,goods_num=1,base_price=50,add_price=25,one_price=500,unsold_price=[{2,0,25}],tv=0,type=0,gold_type=1};
get_goods(4021010,_Wlv) when _Wlv >= 456, _Wlv =< 500 ->
	#base_auction_goods{no=5,goods_id=4021010,name= "8阶橙2武防自选",wlv1=456,wlv2=500,gtype_id=34010088,goods_num=1,base_price=50,add_price=25,one_price=500,unsold_price=[{2,0,25}],tv=0,type=0,gold_type=1};
get_goods(4021011,_Wlv) when _Wlv >= 456, _Wlv =< 500 ->
	#base_auction_goods{no=5,goods_id=4021011,name= "9阶橙2武防自选",wlv1=456,wlv2=500,gtype_id=34010089,goods_num=1,base_price=50,add_price=25,one_price=500,unsold_price=[{2,0,25}],tv=0,type=0,gold_type=1};
get_goods(4021012,_Wlv) when _Wlv >= 456, _Wlv =< 500 ->
	#base_auction_goods{no=5,goods_id=4021012,name= "10阶橙2武防自选",wlv1=456,wlv2=500,gtype_id=34010090,goods_num=1,base_price=50,add_price=25,one_price=500,unsold_price=[{2,0,25}],tv=0,type=0,gold_type=1};
get_goods(4021013,_Wlv) when _Wlv >= 456, _Wlv =< 500 ->
	#base_auction_goods{no=5,goods_id=4021013,name= "11阶橙2武防自选",wlv1=456,wlv2=500,gtype_id=34010091,goods_num=1,base_price=80,add_price=40,one_price=800,unsold_price=[{2,0,40}],tv=0,type=0,gold_type=1};
get_goods(4021014,_Wlv) when _Wlv >= 456, _Wlv =< 500 ->
	#base_auction_goods{no=5,goods_id=4021014,name= "12阶橙2武防自选",wlv1=456,wlv2=500,gtype_id=34010092,goods_num=1,base_price=80,add_price=40,one_price=800,unsold_price=[{2,0,40}],tv=0,type=0,gold_type=1};
get_goods(4021015,_Wlv) when _Wlv >= 456, _Wlv =< 500 ->
	#base_auction_goods{no=5,goods_id=4021015,name= "13阶橙2武防自选",wlv1=456,wlv2=500,gtype_id=34010093,goods_num=1,base_price=80,add_price=40,one_price=800,unsold_price=[{2,0,40}],tv=0,type=0,gold_type=1};
get_goods(4021016,_Wlv) when _Wlv >= 456, _Wlv =< 500 ->
	#base_auction_goods{no=5,goods_id=4021016,name= "秋名飞车碎片",wlv1=456,wlv2=500,gtype_id=16030104,goods_num=5,base_price=50,add_price=25,one_price=500,unsold_price=[{2,0,25}],tv=1,type=0,gold_type=1};
get_goods(4021017,_Wlv) when _Wlv >= 456, _Wlv =< 500 ->
	#base_auction_goods{no=5,goods_id=4021017,name= "秋名飞车碎片",wlv1=456,wlv2=500,gtype_id=16030104,goods_num=5,base_price=50,add_price=25,one_price=500,unsold_price=[{2,0,25}],tv=1,type=0,gold_type=1};
get_goods(4021018,_Wlv) when _Wlv >= 456, _Wlv =< 500 ->
	#base_auction_goods{no=5,goods_id=4021018,name= "阿波罗神魂",wlv1=456,wlv2=500,gtype_id=7120303,goods_num=5,base_price=100,add_price=50,one_price=1000,unsold_price=[{2,0,50}],tv=1,type=0,gold_type=1};
get_goods(4021901,_Wlv) when _Wlv >= 456, _Wlv =< 500 ->
	#base_auction_goods{no=5,goods_id=4021901,name= "勇气之证碎片",wlv1=456,wlv2=500,gtype_id=38040048,goods_num=2,base_price=8,add_price=8,one_price=40,unsold_price=[{2,0,4}],tv=0,type=0,gold_type=2};
get_goods(4021902,_Wlv) when _Wlv >= 456, _Wlv =< 500 ->
	#base_auction_goods{no=5,goods_id=4021902,name= "荣光之证碎片",wlv1=456,wlv2=500,gtype_id=38040049,goods_num=1,base_price=8,add_price=8,one_price=40,unsold_price=[{2,0,4}],tv=0,type=0,gold_type=2};
get_goods(4021903,_Wlv) when _Wlv >= 456, _Wlv =< 500 ->
	#base_auction_goods{no=5,goods_id=4021903,name= "大师之证碎片",wlv1=456,wlv2=500,gtype_id=38040050,goods_num=1,base_price=20,add_price=20,one_price=100,unsold_price=[{2,0,10}],tv=0,type=0,gold_type=2};
get_goods(4021904,_Wlv) when _Wlv >= 456, _Wlv =< 500 ->
	#base_auction_goods{no=5,goods_id=4021904,name= "魔魂丹",wlv1=456,wlv2=500,gtype_id=6101001,goods_num=1,base_price=32,add_price=8,one_price=80,unsold_price=[{2,0,16}],tv=0,type=0,gold_type=2};
get_goods(4021905,_Wlv) when _Wlv >= 456, _Wlv =< 500 ->
	#base_auction_goods{no=5,goods_id=4021905,name= "龙魂丹",wlv1=456,wlv2=500,gtype_id=6101002,goods_num=1,base_price=40,add_price=10,one_price=100,unsold_price=[{2,0,20}],tv=0,type=0,gold_type=2};
get_goods(4021906,_Wlv) when _Wlv >= 456, _Wlv =< 500 ->
	#base_auction_goods{no=5,goods_id=4021906,name= "神魂丹",wlv1=456,wlv2=500,gtype_id=6101003,goods_num=1,base_price=64,add_price=16,one_price=160,unsold_price=[{2,0,32}],tv=0,type=0,gold_type=2};
get_goods(284101,_Wlv) when _Wlv >= 501, _Wlv =< 550 ->
	#base_auction_goods{no=6,goods_id=284101,name= "荣光之证",wlv1=501,wlv2=550,gtype_id=38040045,goods_num=1,base_price=20,add_price=10,one_price=200,unsold_price=[{2,0,10}],tv=0,type=0,gold_type=1};
get_goods(284102,_Wlv) when _Wlv >= 501, _Wlv =< 550 ->
	#base_auction_goods{no=6,goods_id=284102,name= "大师之证",wlv1=501,wlv2=550,gtype_id=38040046,goods_num=1,base_price=50,add_price=25,one_price=500,unsold_price=[{2,0,25}],tv=0,type=0,gold_type=1};
get_goods(284103,_Wlv) when _Wlv >= 501, _Wlv =< 550 ->
	#base_auction_goods{no=6,goods_id=284103,name= "英雄之证",wlv1=501,wlv2=550,gtype_id=38040047,goods_num=1,base_price=125,add_price=63,one_price=1250,unsold_price=[{2,0,63}],tv=0,type=0,gold_type=1};
get_goods(284104,_Wlv) when _Wlv >= 501, _Wlv =< 550 ->
	#base_auction_goods{no=6,goods_id=284104,name= "勇气之证",wlv1=501,wlv2=550,gtype_id=38040044,goods_num=1,base_price=10,add_price=5,one_price=100,unsold_price=[{2,0,5}],tv=0,type=0,gold_type=1};
get_goods(284105,_Wlv) when _Wlv >= 501, _Wlv =< 550 ->
	#base_auction_goods{no=6,goods_id=284105,name= "符文魔晶",wlv1=501,wlv2=550,gtype_id=38040012,goods_num=200,base_price=120,add_price=30,one_price=300,unsold_price=[{2,0,60}],tv=0,type=0,gold_type=1};
get_goods(284106,_Wlv) when _Wlv >= 501, _Wlv =< 550 ->
	#base_auction_goods{no=6,goods_id=284106,name= "魅影项链",wlv1=501,wlv2=550,gtype_id=101034072,goods_num=1,base_price=100,add_price=50,one_price=1000,unsold_price=[{2,0,50}],tv=0,type=0,gold_type=1};
get_goods(284107,_Wlv) when _Wlv >= 501, _Wlv =< 550 ->
	#base_auction_goods{no=6,goods_id=284107,name= "追猎项链",wlv1=501,wlv2=550,gtype_id=101034082,goods_num=1,base_price=100,add_price=50,one_price=1000,unsold_price=[{2,0,50}],tv=0,type=0,gold_type=1};
get_goods(284108,_Wlv) when _Wlv >= 501, _Wlv =< 550 ->
	#base_auction_goods{no=6,goods_id=284108,name= "暗焰项链",wlv1=501,wlv2=550,gtype_id=101034092,goods_num=1,base_price=100,add_price=50,one_price=1000,unsold_price=[{2,0,50}],tv=0,type=0,gold_type=1};
get_goods(284109,_Wlv) when _Wlv >= 501, _Wlv =< 550 ->
	#base_auction_goods{no=6,goods_id=284109,name= "圣徒项链",wlv1=501,wlv2=550,gtype_id=101034102,goods_num=1,base_price=100,add_price=50,one_price=1000,unsold_price=[{2,0,50}],tv=0,type=0,gold_type=1};
get_goods(284110,_Wlv) when _Wlv >= 501, _Wlv =< 550 ->
	#base_auction_goods{no=6,goods_id=284110,name= "审判项链",wlv1=501,wlv2=550,gtype_id=101034112,goods_num=1,base_price=100,add_price=50,one_price=1000,unsold_price=[{2,0,50}],tv=0,type=0,gold_type=1};
get_goods(284111,_Wlv) when _Wlv >= 501, _Wlv =< 550 ->
	#base_auction_goods{no=6,goods_id=284111,name= "征服者项链",wlv1=501,wlv2=550,gtype_id=101034122,goods_num=1,base_price=100,add_price=50,one_price=1000,unsold_price=[{2,0,50}],tv=0,type=0,gold_type=1};
get_goods(284112,_Wlv) when _Wlv >= 501, _Wlv =< 550 ->
	#base_auction_goods{no=6,goods_id=284112,name= "王者项链",wlv1=501,wlv2=550,gtype_id=101034132,goods_num=1,base_price=100,add_price=50,one_price=1000,unsold_price=[{2,0,50}],tv=0,type=0,gold_type=1};
get_goods(284113,_Wlv) when _Wlv >= 501, _Wlv =< 550 ->
	#base_auction_goods{no=6,goods_id=284113,name= "斗士符文礼包",wlv1=501,wlv2=550,gtype_id=32010383,goods_num=1,base_price=150,add_price=50,one_price=1000,unsold_price=[{2,0,75}],tv=0,type=0,gold_type=1};
get_goods(284114,_Wlv) when _Wlv >= 501, _Wlv =< 550 ->
	#base_auction_goods{no=6,goods_id=284114,name= "勇士符文礼包",wlv1=501,wlv2=550,gtype_id=32010384,goods_num=1,base_price=150,add_price=50,one_price=1000,unsold_price=[{2,0,75}],tv=0,type=0,gold_type=1};
get_goods(284115,_Wlv) when _Wlv >= 501, _Wlv =< 550 ->
	#base_auction_goods{no=6,goods_id=284115,name= "侵略符文礼包",wlv1=501,wlv2=550,gtype_id=32010385,goods_num=1,base_price=200,add_price=100,one_price=2000,unsold_price=[{2,0,100}],tv=0,type=0,gold_type=1};
get_goods(284117,_Wlv) when _Wlv >= 501, _Wlv =< 550 ->
	#base_auction_goods{no=6,goods_id=284117,name= "永恒骑士碎片",wlv1=501,wlv2=550,gtype_id=17030107,goods_num=3,base_price=150,add_price=50,one_price=500,unsold_price=[{2,0,75}],tv=0,type=0,gold_type=1};
get_goods(284119,_Wlv) when _Wlv >= 501, _Wlv =< 550 ->
	#base_auction_goods{no=6,goods_id=284119,name= "永恒骑士碎片",wlv1=501,wlv2=550,gtype_id=17030107,goods_num=30,base_price=1000,add_price=500,one_price=5000,unsold_price=[{2,0,500}],tv=0,type=0,gold_type=1};
get_goods(284120,_Wlv) when _Wlv >= 501, _Wlv =< 550 ->
	#base_auction_goods{no=6,goods_id=284120,name= "天使铭刻",wlv1=501,wlv2=550,gtype_id=38040060,goods_num=1,base_price=15,add_price=10,one_price=50,unsold_price=[{2,0,8}],tv=0,type=0,gold_type=1};
get_goods(284121,_Wlv) when _Wlv >= 501, _Wlv =< 550 ->
	#base_auction_goods{no=6,goods_id=284121,name= "恶魔铭刻",wlv1=501,wlv2=550,gtype_id=38040056,goods_num=1,base_price=15,add_price=10,one_price=50,unsold_price=[{2,0,8}],tv=0,type=0,gold_type=1};
get_goods(284201,_Wlv) when _Wlv >= 501, _Wlv =< 550 ->
	#base_auction_goods{no=6,goods_id=284201,name= "符文魔晶",wlv1=501,wlv2=550,gtype_id=38040012,goods_num=60,base_price=36,add_price=18,one_price=90,unsold_price=[{2,0,18}],tv=0,type=0,gold_type=2};
get_goods(284202,_Wlv) when _Wlv >= 501, _Wlv =< 550 ->
	#base_auction_goods{no=6,goods_id=284202,name= "魅影项链",wlv1=501,wlv2=550,gtype_id=101035071,goods_num=1,base_price=80,add_price=40,one_price=400,unsold_price=[{2,0,40}],tv=0,type=0,gold_type=2};
get_goods(284203,_Wlv) when _Wlv >= 501, _Wlv =< 550 ->
	#base_auction_goods{no=6,goods_id=284203,name= "追猎项链",wlv1=501,wlv2=550,gtype_id=101035081,goods_num=1,base_price=80,add_price=40,one_price=400,unsold_price=[{2,0,40}],tv=0,type=0,gold_type=2};
get_goods(284204,_Wlv) when _Wlv >= 501, _Wlv =< 550 ->
	#base_auction_goods{no=6,goods_id=284204,name= "暗焰项链",wlv1=501,wlv2=550,gtype_id=101035091,goods_num=1,base_price=80,add_price=40,one_price=400,unsold_price=[{2,0,40}],tv=0,type=0,gold_type=2};
get_goods(284205,_Wlv) when _Wlv >= 501, _Wlv =< 550 ->
	#base_auction_goods{no=6,goods_id=284205,name= "圣徒项链",wlv1=501,wlv2=550,gtype_id=101035101,goods_num=1,base_price=80,add_price=40,one_price=400,unsold_price=[{2,0,40}],tv=0,type=0,gold_type=2};
get_goods(284206,_Wlv) when _Wlv >= 501, _Wlv =< 550 ->
	#base_auction_goods{no=6,goods_id=284206,name= "审判项链",wlv1=501,wlv2=550,gtype_id=101035111,goods_num=1,base_price=80,add_price=40,one_price=400,unsold_price=[{2,0,40}],tv=0,type=0,gold_type=2};
get_goods(284207,_Wlv) when _Wlv >= 501, _Wlv =< 550 ->
	#base_auction_goods{no=6,goods_id=284207,name= "征服者项链",wlv1=501,wlv2=550,gtype_id=101035121,goods_num=1,base_price=80,add_price=40,one_price=400,unsold_price=[{2,0,40}],tv=0,type=0,gold_type=2};
get_goods(284208,_Wlv) when _Wlv >= 501, _Wlv =< 550 ->
	#base_auction_goods{no=6,goods_id=284208,name= "王者项链",wlv1=501,wlv2=550,gtype_id=101035131,goods_num=1,base_price=80,add_price=40,one_price=400,unsold_price=[{2,0,40}],tv=0,type=0,gold_type=2};
get_goods(284209,_Wlv) when _Wlv >= 501, _Wlv =< 550 ->
	#base_auction_goods{no=6,goods_id=284209,name= "魔魂丹",wlv1=501,wlv2=550,gtype_id=6101001,goods_num=1,base_price=32,add_price=8,one_price=80,unsold_price=[{2,0,16}],tv=0,type=0,gold_type=2};
get_goods(284210,_Wlv) when _Wlv >= 501, _Wlv =< 550 ->
	#base_auction_goods{no=6,goods_id=284210,name= "龙魂丹",wlv1=501,wlv2=550,gtype_id=6101002,goods_num=1,base_price=40,add_price=10,one_price=100,unsold_price=[{2,0,20}],tv=0,type=0,gold_type=2};
get_goods(284211,_Wlv) when _Wlv >= 501, _Wlv =< 550 ->
	#base_auction_goods{no=6,goods_id=284211,name= "神魂丹",wlv1=501,wlv2=550,gtype_id=6101003,goods_num=1,base_price=64,add_price=16,one_price=160,unsold_price=[{2,0,32}],tv=0,type=0,gold_type=2};
get_goods(284212,_Wlv) when _Wlv >= 501, _Wlv =< 550 ->
	#base_auction_goods{no=6,goods_id=284212,name= "勇士符文礼包",wlv1=501,wlv2=550,gtype_id=32010384,goods_num=1,base_price=250,add_price=100,one_price=1000,unsold_price=[{2,0,125}],tv=0,type=0,gold_type=2};
get_goods(284213,_Wlv) when _Wlv >= 501, _Wlv =< 550 ->
	#base_auction_goods{no=6,goods_id=284213,name= "斗士符文礼包",wlv1=501,wlv2=550,gtype_id=32010383,goods_num=1,base_price=250,add_price=100,one_price=1000,unsold_price=[{2,0,125}],tv=0,type=0,gold_type=2};
get_goods(284214,_Wlv) when _Wlv >= 501, _Wlv =< 550 ->
	#base_auction_goods{no=6,goods_id=284214,name= "特殊符文礼包",wlv1=501,wlv2=550,gtype_id=34010130,goods_num=1,base_price=200,add_price=80,one_price=800,unsold_price=[{2,0,100}],tv=0,type=0,gold_type=2};
get_goods(284215,_Wlv) when _Wlv >= 501, _Wlv =< 550 ->
	#base_auction_goods{no=6,goods_id=284215,name= "圣魂丹",wlv1=501,wlv2=550,gtype_id=6101004,goods_num=1,base_price=200,add_price=50,one_price=500,unsold_price=[{2,0,100}],tv=0,type=0,gold_type=2};
get_goods(284216,_Wlv) when _Wlv >= 501, _Wlv =< 550 ->
	#base_auction_goods{no=6,goods_id=284216,name= "纯洁之灵",wlv1=501,wlv2=550,gtype_id=38040061,goods_num=1,base_price=75,add_price=30,one_price=300,unsold_price=[{2,0,38}],tv=0,type=0,gold_type=2};
get_goods(284217,_Wlv) when _Wlv >= 501, _Wlv =< 550 ->
	#base_auction_goods{no=6,goods_id=284217,name= "堕落之魂",wlv1=501,wlv2=550,gtype_id=38040057,goods_num=1,base_price=75,add_price=30,one_price=300,unsold_price=[{2,0,38}],tv=0,type=0,gold_type=2};
get_goods(4021001,_Wlv) when _Wlv >= 501, _Wlv =< 550 ->
	#base_auction_goods{no=6,goods_id=4021001,name= "勇气之证碎片",wlv1=501,wlv2=550,gtype_id=38040048,goods_num=3,base_price=4,add_price=2,one_price=36,unsold_price=[{2,0,2}],tv=0,type=0,gold_type=1};
get_goods(4021002,_Wlv) when _Wlv >= 501, _Wlv =< 550 ->
	#base_auction_goods{no=6,goods_id=4021002,name= "勇气之证",wlv1=501,wlv2=550,gtype_id=38040044,goods_num=1,base_price=6,add_price=3,one_price=60,unsold_price=[{2,0,3}],tv=0,type=0,gold_type=1};
get_goods(4021003,_Wlv) when _Wlv >= 501, _Wlv =< 550 ->
	#base_auction_goods{no=6,goods_id=4021003,name= "荣光之证碎片",wlv1=501,wlv2=550,gtype_id=38040049,goods_num=1,base_price=2,add_price=1,one_price=24,unsold_price=[{2,0,1}],tv=0,type=0,gold_type=1};
get_goods(4021004,_Wlv) when _Wlv >= 501, _Wlv =< 550 ->
	#base_auction_goods{no=6,goods_id=4021004,name= "荣光之证",wlv1=501,wlv2=550,gtype_id=38040045,goods_num=1,base_price=12,add_price=6,one_price=120,unsold_price=[{2,0,6}],tv=0,type=0,gold_type=1};
get_goods(4021005,_Wlv) when _Wlv >= 501, _Wlv =< 550 ->
	#base_auction_goods{no=6,goods_id=4021005,name= "大师之证碎片",wlv1=501,wlv2=550,gtype_id=38040050,goods_num=1,base_price=10,add_price=5,one_price=100,unsold_price=[{2,0,5}],tv=0,type=0,gold_type=1};
get_goods(4021006,_Wlv) when _Wlv >= 501, _Wlv =< 550 ->
	#base_auction_goods{no=6,goods_id=4021006,name= "大师之证",wlv1=501,wlv2=550,gtype_id=38040046,goods_num=1,base_price=50,add_price=25,one_price=500,unsold_price=[{2,0,25}],tv=0,type=0,gold_type=1};
get_goods(4021007,_Wlv) when _Wlv >= 501, _Wlv =< 550 ->
	#base_auction_goods{no=6,goods_id=4021007,name= "英雄之证碎片",wlv1=501,wlv2=550,gtype_id=38040051,goods_num=1,base_price=25,add_price=13,one_price=250,unsold_price=[{2,0,13}],tv=0,type=0,gold_type=1};
get_goods(4021008,_Wlv) when _Wlv >= 501, _Wlv =< 550 ->
	#base_auction_goods{no=6,goods_id=4021008,name= "英雄之证",wlv1=501,wlv2=550,gtype_id=38040047,goods_num=1,base_price=125,add_price=63,one_price=1250,unsold_price=[{2,0,63}],tv=0,type=0,gold_type=1};
get_goods(4021009,_Wlv) when _Wlv >= 501, _Wlv =< 550 ->
	#base_auction_goods{no=6,goods_id=4021009,name= "7阶橙2武防自选",wlv1=501,wlv2=550,gtype_id=34010087,goods_num=1,base_price=50,add_price=25,one_price=500,unsold_price=[{2,0,25}],tv=0,type=0,gold_type=1};
get_goods(4021010,_Wlv) when _Wlv >= 501, _Wlv =< 550 ->
	#base_auction_goods{no=6,goods_id=4021010,name= "8阶橙2武防自选",wlv1=501,wlv2=550,gtype_id=34010088,goods_num=1,base_price=50,add_price=25,one_price=500,unsold_price=[{2,0,25}],tv=0,type=0,gold_type=1};
get_goods(4021011,_Wlv) when _Wlv >= 501, _Wlv =< 550 ->
	#base_auction_goods{no=6,goods_id=4021011,name= "9阶橙2武防自选",wlv1=501,wlv2=550,gtype_id=34010089,goods_num=1,base_price=50,add_price=25,one_price=500,unsold_price=[{2,0,25}],tv=0,type=0,gold_type=1};
get_goods(4021012,_Wlv) when _Wlv >= 501, _Wlv =< 550 ->
	#base_auction_goods{no=6,goods_id=4021012,name= "10阶橙2武防自选",wlv1=501,wlv2=550,gtype_id=34010090,goods_num=1,base_price=50,add_price=25,one_price=500,unsold_price=[{2,0,25}],tv=0,type=0,gold_type=1};
get_goods(4021013,_Wlv) when _Wlv >= 501, _Wlv =< 550 ->
	#base_auction_goods{no=6,goods_id=4021013,name= "11阶橙2武防自选",wlv1=501,wlv2=550,gtype_id=34010091,goods_num=1,base_price=50,add_price=25,one_price=500,unsold_price=[{2,0,25}],tv=0,type=0,gold_type=1};
get_goods(4021014,_Wlv) when _Wlv >= 501, _Wlv =< 550 ->
	#base_auction_goods{no=6,goods_id=4021014,name= "12阶橙2武防自选",wlv1=501,wlv2=550,gtype_id=34010092,goods_num=1,base_price=80,add_price=40,one_price=800,unsold_price=[{2,0,40}],tv=0,type=0,gold_type=1};
get_goods(4021015,_Wlv) when _Wlv >= 501, _Wlv =< 550 ->
	#base_auction_goods{no=6,goods_id=4021015,name= "13阶橙2武防自选",wlv1=501,wlv2=550,gtype_id=34010093,goods_num=1,base_price=80,add_price=40,one_price=800,unsold_price=[{2,0,40}],tv=0,type=0,gold_type=1};
get_goods(4021016,_Wlv) when _Wlv >= 501, _Wlv =< 550 ->
	#base_auction_goods{no=6,goods_id=4021016,name= "秋名飞车碎片",wlv1=501,wlv2=550,gtype_id=16030104,goods_num=5,base_price=50,add_price=25,one_price=500,unsold_price=[{2,0,25}],tv=1,type=0,gold_type=1};
get_goods(4021017,_Wlv) when _Wlv >= 501, _Wlv =< 550 ->
	#base_auction_goods{no=6,goods_id=4021017,name= "秋名飞车碎片",wlv1=501,wlv2=550,gtype_id=16030104,goods_num=5,base_price=50,add_price=25,one_price=500,unsold_price=[{2,0,25}],tv=1,type=0,gold_type=1};
get_goods(4021018,_Wlv) when _Wlv >= 501, _Wlv =< 550 ->
	#base_auction_goods{no=6,goods_id=4021018,name= "阿波罗神魂",wlv1=501,wlv2=550,gtype_id=7120303,goods_num=5,base_price=100,add_price=50,one_price=1000,unsold_price=[{2,0,50}],tv=1,type=0,gold_type=1};
get_goods(4021901,_Wlv) when _Wlv >= 501, _Wlv =< 550 ->
	#base_auction_goods{no=6,goods_id=4021901,name= "勇气之证碎片",wlv1=501,wlv2=550,gtype_id=38040048,goods_num=2,base_price=8,add_price=8,one_price=40,unsold_price=[{2,0,4}],tv=0,type=0,gold_type=2};
get_goods(4021902,_Wlv) when _Wlv >= 501, _Wlv =< 550 ->
	#base_auction_goods{no=6,goods_id=4021902,name= "荣光之证碎片",wlv1=501,wlv2=550,gtype_id=38040049,goods_num=1,base_price=8,add_price=8,one_price=40,unsold_price=[{2,0,4}],tv=0,type=0,gold_type=2};
get_goods(4021903,_Wlv) when _Wlv >= 501, _Wlv =< 550 ->
	#base_auction_goods{no=6,goods_id=4021903,name= "大师之证碎片",wlv1=501,wlv2=550,gtype_id=38040050,goods_num=1,base_price=20,add_price=20,one_price=100,unsold_price=[{2,0,10}],tv=0,type=0,gold_type=2};
get_goods(4021904,_Wlv) when _Wlv >= 501, _Wlv =< 550 ->
	#base_auction_goods{no=6,goods_id=4021904,name= "魔魂丹",wlv1=501,wlv2=550,gtype_id=6101001,goods_num=1,base_price=32,add_price=8,one_price=80,unsold_price=[{2,0,16}],tv=0,type=0,gold_type=2};
get_goods(4021905,_Wlv) when _Wlv >= 501, _Wlv =< 550 ->
	#base_auction_goods{no=6,goods_id=4021905,name= "龙魂丹",wlv1=501,wlv2=550,gtype_id=6101002,goods_num=1,base_price=40,add_price=10,one_price=100,unsold_price=[{2,0,20}],tv=0,type=0,gold_type=2};
get_goods(4021906,_Wlv) when _Wlv >= 501, _Wlv =< 550 ->
	#base_auction_goods{no=6,goods_id=4021906,name= "神魂丹",wlv1=501,wlv2=550,gtype_id=6101003,goods_num=1,base_price=64,add_price=16,one_price=160,unsold_price=[{2,0,32}],tv=0,type=0,gold_type=2};
get_goods(284101,_Wlv) when _Wlv >= 551, _Wlv =< 9999 ->
	#base_auction_goods{no=7,goods_id=284101,name= "荣光之证",wlv1=551,wlv2=9999,gtype_id=38040045,goods_num=1,base_price=20,add_price=10,one_price=200,unsold_price=[{2,0,10}],tv=0,type=0,gold_type=1};
get_goods(284102,_Wlv) when _Wlv >= 551, _Wlv =< 9999 ->
	#base_auction_goods{no=7,goods_id=284102,name= "大师之证",wlv1=551,wlv2=9999,gtype_id=38040046,goods_num=1,base_price=50,add_price=25,one_price=500,unsold_price=[{2,0,25}],tv=0,type=0,gold_type=1};
get_goods(284103,_Wlv) when _Wlv >= 551, _Wlv =< 9999 ->
	#base_auction_goods{no=7,goods_id=284103,name= "英雄之证",wlv1=551,wlv2=9999,gtype_id=38040047,goods_num=1,base_price=125,add_price=63,one_price=1250,unsold_price=[{2,0,63}],tv=0,type=0,gold_type=1};
get_goods(284104,_Wlv) when _Wlv >= 551, _Wlv =< 9999 ->
	#base_auction_goods{no=7,goods_id=284104,name= "勇气之证",wlv1=551,wlv2=9999,gtype_id=38040044,goods_num=1,base_price=10,add_price=5,one_price=100,unsold_price=[{2,0,5}],tv=0,type=0,gold_type=1};
get_goods(284105,_Wlv) when _Wlv >= 551, _Wlv =< 9999 ->
	#base_auction_goods{no=7,goods_id=284105,name= "符文魔晶",wlv1=551,wlv2=9999,gtype_id=38040012,goods_num=200,base_price=120,add_price=30,one_price=300,unsold_price=[{2,0,60}],tv=0,type=0,gold_type=1};
get_goods(284106,_Wlv) when _Wlv >= 551, _Wlv =< 9999 ->
	#base_auction_goods{no=7,goods_id=284106,name= "魅影项链",wlv1=551,wlv2=9999,gtype_id=101034072,goods_num=1,base_price=100,add_price=50,one_price=1000,unsold_price=[{2,0,50}],tv=0,type=0,gold_type=1};
get_goods(284107,_Wlv) when _Wlv >= 551, _Wlv =< 9999 ->
	#base_auction_goods{no=7,goods_id=284107,name= "追猎项链",wlv1=551,wlv2=9999,gtype_id=101034082,goods_num=1,base_price=100,add_price=50,one_price=1000,unsold_price=[{2,0,50}],tv=0,type=0,gold_type=1};
get_goods(284108,_Wlv) when _Wlv >= 551, _Wlv =< 9999 ->
	#base_auction_goods{no=7,goods_id=284108,name= "暗焰项链",wlv1=551,wlv2=9999,gtype_id=101034092,goods_num=1,base_price=100,add_price=50,one_price=1000,unsold_price=[{2,0,50}],tv=0,type=0,gold_type=1};
get_goods(284109,_Wlv) when _Wlv >= 551, _Wlv =< 9999 ->
	#base_auction_goods{no=7,goods_id=284109,name= "圣徒项链",wlv1=551,wlv2=9999,gtype_id=101034102,goods_num=1,base_price=100,add_price=50,one_price=1000,unsold_price=[{2,0,50}],tv=0,type=0,gold_type=1};
get_goods(284110,_Wlv) when _Wlv >= 551, _Wlv =< 9999 ->
	#base_auction_goods{no=7,goods_id=284110,name= "审判项链",wlv1=551,wlv2=9999,gtype_id=101034112,goods_num=1,base_price=100,add_price=50,one_price=1000,unsold_price=[{2,0,50}],tv=0,type=0,gold_type=1};
get_goods(284111,_Wlv) when _Wlv >= 551, _Wlv =< 9999 ->
	#base_auction_goods{no=7,goods_id=284111,name= "征服者项链",wlv1=551,wlv2=9999,gtype_id=101034122,goods_num=1,base_price=100,add_price=50,one_price=1000,unsold_price=[{2,0,50}],tv=0,type=0,gold_type=1};
get_goods(284112,_Wlv) when _Wlv >= 551, _Wlv =< 9999 ->
	#base_auction_goods{no=7,goods_id=284112,name= "王者项链",wlv1=551,wlv2=9999,gtype_id=101034132,goods_num=1,base_price=100,add_price=50,one_price=1000,unsold_price=[{2,0,50}],tv=0,type=0,gold_type=1};
get_goods(284113,_Wlv) when _Wlv >= 551, _Wlv =< 9999 ->
	#base_auction_goods{no=7,goods_id=284113,name= "斗士符文礼包",wlv1=551,wlv2=9999,gtype_id=32010383,goods_num=1,base_price=150,add_price=50,one_price=1000,unsold_price=[{2,0,75}],tv=0,type=0,gold_type=1};
get_goods(284114,_Wlv) when _Wlv >= 551, _Wlv =< 9999 ->
	#base_auction_goods{no=7,goods_id=284114,name= "勇士符文礼包",wlv1=551,wlv2=9999,gtype_id=32010384,goods_num=1,base_price=150,add_price=50,one_price=1000,unsold_price=[{2,0,75}],tv=0,type=0,gold_type=1};
get_goods(284115,_Wlv) when _Wlv >= 551, _Wlv =< 9999 ->
	#base_auction_goods{no=7,goods_id=284115,name= "侵略符文礼包",wlv1=551,wlv2=9999,gtype_id=32010385,goods_num=1,base_price=200,add_price=100,one_price=2000,unsold_price=[{2,0,100}],tv=0,type=0,gold_type=1};
get_goods(284117,_Wlv) when _Wlv >= 551, _Wlv =< 9999 ->
	#base_auction_goods{no=7,goods_id=284117,name= "永恒骑士碎片",wlv1=551,wlv2=9999,gtype_id=17030107,goods_num=3,base_price=150,add_price=50,one_price=500,unsold_price=[{2,0,75}],tv=0,type=0,gold_type=1};
get_goods(284119,_Wlv) when _Wlv >= 551, _Wlv =< 9999 ->
	#base_auction_goods{no=7,goods_id=284119,name= "永恒骑士碎片",wlv1=551,wlv2=9999,gtype_id=17030107,goods_num=30,base_price=1000,add_price=500,one_price=5000,unsold_price=[{2,0,500}],tv=0,type=0,gold_type=1};
get_goods(284120,_Wlv) when _Wlv >= 551, _Wlv =< 9999 ->
	#base_auction_goods{no=7,goods_id=284120,name= "天使铭刻",wlv1=551,wlv2=9999,gtype_id=38040060,goods_num=1,base_price=15,add_price=10,one_price=50,unsold_price=[{2,0,8}],tv=0,type=0,gold_type=1};
get_goods(284121,_Wlv) when _Wlv >= 551, _Wlv =< 9999 ->
	#base_auction_goods{no=7,goods_id=284121,name= "恶魔铭刻",wlv1=551,wlv2=9999,gtype_id=38040056,goods_num=1,base_price=15,add_price=10,one_price=50,unsold_price=[{2,0,8}],tv=0,type=0,gold_type=1};
get_goods(284201,_Wlv) when _Wlv >= 551, _Wlv =< 9999 ->
	#base_auction_goods{no=7,goods_id=284201,name= "符文魔晶",wlv1=551,wlv2=9999,gtype_id=38040012,goods_num=60,base_price=36,add_price=18,one_price=90,unsold_price=[{2,0,18}],tv=0,type=0,gold_type=2};
get_goods(284202,_Wlv) when _Wlv >= 551, _Wlv =< 9999 ->
	#base_auction_goods{no=7,goods_id=284202,name= "魅影项链",wlv1=551,wlv2=9999,gtype_id=101035071,goods_num=1,base_price=80,add_price=40,one_price=400,unsold_price=[{2,0,40}],tv=0,type=0,gold_type=2};
get_goods(284203,_Wlv) when _Wlv >= 551, _Wlv =< 9999 ->
	#base_auction_goods{no=7,goods_id=284203,name= "追猎项链",wlv1=551,wlv2=9999,gtype_id=101035081,goods_num=1,base_price=80,add_price=40,one_price=400,unsold_price=[{2,0,40}],tv=0,type=0,gold_type=2};
get_goods(284204,_Wlv) when _Wlv >= 551, _Wlv =< 9999 ->
	#base_auction_goods{no=7,goods_id=284204,name= "暗焰项链",wlv1=551,wlv2=9999,gtype_id=101035091,goods_num=1,base_price=80,add_price=40,one_price=400,unsold_price=[{2,0,40}],tv=0,type=0,gold_type=2};
get_goods(284205,_Wlv) when _Wlv >= 551, _Wlv =< 9999 ->
	#base_auction_goods{no=7,goods_id=284205,name= "圣徒项链",wlv1=551,wlv2=9999,gtype_id=101035101,goods_num=1,base_price=80,add_price=40,one_price=400,unsold_price=[{2,0,40}],tv=0,type=0,gold_type=2};
get_goods(284206,_Wlv) when _Wlv >= 551, _Wlv =< 9999 ->
	#base_auction_goods{no=7,goods_id=284206,name= "审判项链",wlv1=551,wlv2=9999,gtype_id=101035111,goods_num=1,base_price=80,add_price=40,one_price=400,unsold_price=[{2,0,40}],tv=0,type=0,gold_type=2};
get_goods(284207,_Wlv) when _Wlv >= 551, _Wlv =< 9999 ->
	#base_auction_goods{no=7,goods_id=284207,name= "征服者项链",wlv1=551,wlv2=9999,gtype_id=101035121,goods_num=1,base_price=80,add_price=40,one_price=400,unsold_price=[{2,0,40}],tv=0,type=0,gold_type=2};
get_goods(284208,_Wlv) when _Wlv >= 551, _Wlv =< 9999 ->
	#base_auction_goods{no=7,goods_id=284208,name= "王者项链",wlv1=551,wlv2=9999,gtype_id=101035131,goods_num=1,base_price=80,add_price=40,one_price=400,unsold_price=[{2,0,40}],tv=0,type=0,gold_type=2};
get_goods(284209,_Wlv) when _Wlv >= 551, _Wlv =< 9999 ->
	#base_auction_goods{no=7,goods_id=284209,name= "魔魂丹",wlv1=551,wlv2=9999,gtype_id=6101001,goods_num=1,base_price=32,add_price=8,one_price=80,unsold_price=[{2,0,16}],tv=0,type=0,gold_type=2};
get_goods(284210,_Wlv) when _Wlv >= 551, _Wlv =< 9999 ->
	#base_auction_goods{no=7,goods_id=284210,name= "龙魂丹",wlv1=551,wlv2=9999,gtype_id=6101002,goods_num=1,base_price=40,add_price=10,one_price=100,unsold_price=[{2,0,20}],tv=0,type=0,gold_type=2};
get_goods(284211,_Wlv) when _Wlv >= 551, _Wlv =< 9999 ->
	#base_auction_goods{no=7,goods_id=284211,name= "神魂丹",wlv1=551,wlv2=9999,gtype_id=6101003,goods_num=1,base_price=64,add_price=16,one_price=160,unsold_price=[{2,0,32}],tv=0,type=0,gold_type=2};
get_goods(284212,_Wlv) when _Wlv >= 551, _Wlv =< 9999 ->
	#base_auction_goods{no=7,goods_id=284212,name= "勇士符文礼包",wlv1=551,wlv2=9999,gtype_id=32010384,goods_num=1,base_price=250,add_price=100,one_price=1000,unsold_price=[{2,0,125}],tv=0,type=0,gold_type=2};
get_goods(284213,_Wlv) when _Wlv >= 551, _Wlv =< 9999 ->
	#base_auction_goods{no=7,goods_id=284213,name= "斗士符文礼包",wlv1=551,wlv2=9999,gtype_id=32010383,goods_num=1,base_price=250,add_price=100,one_price=1000,unsold_price=[{2,0,125}],tv=0,type=0,gold_type=2};
get_goods(284214,_Wlv) when _Wlv >= 551, _Wlv =< 9999 ->
	#base_auction_goods{no=7,goods_id=284214,name= "特殊符文礼包",wlv1=551,wlv2=9999,gtype_id=34010130,goods_num=1,base_price=200,add_price=80,one_price=800,unsold_price=[{2,0,100}],tv=0,type=0,gold_type=2};
get_goods(284215,_Wlv) when _Wlv >= 551, _Wlv =< 9999 ->
	#base_auction_goods{no=7,goods_id=284215,name= "圣魂丹",wlv1=551,wlv2=9999,gtype_id=6101004,goods_num=1,base_price=200,add_price=50,one_price=500,unsold_price=[{2,0,100}],tv=0,type=0,gold_type=2};
get_goods(284216,_Wlv) when _Wlv >= 551, _Wlv =< 9999 ->
	#base_auction_goods{no=7,goods_id=284216,name= "纯洁之灵",wlv1=551,wlv2=9999,gtype_id=38040061,goods_num=1,base_price=75,add_price=30,one_price=300,unsold_price=[{2,0,38}],tv=0,type=0,gold_type=2};
get_goods(284217,_Wlv) when _Wlv >= 551, _Wlv =< 9999 ->
	#base_auction_goods{no=7,goods_id=284217,name= "堕落之魂",wlv1=551,wlv2=9999,gtype_id=38040057,goods_num=1,base_price=75,add_price=30,one_price=300,unsold_price=[{2,0,38}],tv=0,type=0,gold_type=2};
get_goods(4021001,_Wlv) when _Wlv >= 551, _Wlv =< 999 ->
	#base_auction_goods{no=7,goods_id=4021001,name= "勇气之证碎片",wlv1=551,wlv2=999,gtype_id=38040048,goods_num=3,base_price=4,add_price=2,one_price=36,unsold_price=[{2,0,2}],tv=0,type=0,gold_type=1};
get_goods(4021002,_Wlv) when _Wlv >= 551, _Wlv =< 999 ->
	#base_auction_goods{no=7,goods_id=4021002,name= "勇气之证",wlv1=551,wlv2=999,gtype_id=38040044,goods_num=1,base_price=6,add_price=3,one_price=60,unsold_price=[{2,0,3}],tv=0,type=0,gold_type=1};
get_goods(4021003,_Wlv) when _Wlv >= 551, _Wlv =< 999 ->
	#base_auction_goods{no=7,goods_id=4021003,name= "荣光之证碎片",wlv1=551,wlv2=999,gtype_id=38040049,goods_num=1,base_price=2,add_price=1,one_price=24,unsold_price=[{2,0,1}],tv=0,type=0,gold_type=1};
get_goods(4021004,_Wlv) when _Wlv >= 551, _Wlv =< 999 ->
	#base_auction_goods{no=7,goods_id=4021004,name= "荣光之证",wlv1=551,wlv2=999,gtype_id=38040045,goods_num=1,base_price=12,add_price=6,one_price=120,unsold_price=[{2,0,6}],tv=0,type=0,gold_type=1};
get_goods(4021005,_Wlv) when _Wlv >= 551, _Wlv =< 999 ->
	#base_auction_goods{no=7,goods_id=4021005,name= "大师之证碎片",wlv1=551,wlv2=999,gtype_id=38040050,goods_num=1,base_price=10,add_price=5,one_price=100,unsold_price=[{2,0,5}],tv=0,type=0,gold_type=1};
get_goods(4021006,_Wlv) when _Wlv >= 551, _Wlv =< 999 ->
	#base_auction_goods{no=7,goods_id=4021006,name= "大师之证",wlv1=551,wlv2=999,gtype_id=38040046,goods_num=1,base_price=50,add_price=25,one_price=500,unsold_price=[{2,0,25}],tv=0,type=0,gold_type=1};
get_goods(4021007,_Wlv) when _Wlv >= 551, _Wlv =< 999 ->
	#base_auction_goods{no=7,goods_id=4021007,name= "英雄之证碎片",wlv1=551,wlv2=999,gtype_id=38040051,goods_num=1,base_price=25,add_price=13,one_price=250,unsold_price=[{2,0,13}],tv=0,type=0,gold_type=1};
get_goods(4021008,_Wlv) when _Wlv >= 551, _Wlv =< 999 ->
	#base_auction_goods{no=7,goods_id=4021008,name= "英雄之证",wlv1=551,wlv2=999,gtype_id=38040047,goods_num=1,base_price=125,add_price=63,one_price=1250,unsold_price=[{2,0,63}],tv=0,type=0,gold_type=1};
get_goods(4021009,_Wlv) when _Wlv >= 551, _Wlv =< 999 ->
	#base_auction_goods{no=7,goods_id=4021009,name= "7阶橙2武防自选",wlv1=551,wlv2=999,gtype_id=34010087,goods_num=1,base_price=50,add_price=25,one_price=500,unsold_price=[{2,0,25}],tv=0,type=0,gold_type=1};
get_goods(4021010,_Wlv) when _Wlv >= 551, _Wlv =< 999 ->
	#base_auction_goods{no=7,goods_id=4021010,name= "8阶橙2武防自选",wlv1=551,wlv2=999,gtype_id=34010088,goods_num=1,base_price=50,add_price=25,one_price=500,unsold_price=[{2,0,25}],tv=0,type=0,gold_type=1};
get_goods(4021011,_Wlv) when _Wlv >= 551, _Wlv =< 999 ->
	#base_auction_goods{no=7,goods_id=4021011,name= "9阶橙2武防自选",wlv1=551,wlv2=999,gtype_id=34010089,goods_num=1,base_price=50,add_price=25,one_price=500,unsold_price=[{2,0,25}],tv=0,type=0,gold_type=1};
get_goods(4021012,_Wlv) when _Wlv >= 551, _Wlv =< 999 ->
	#base_auction_goods{no=7,goods_id=4021012,name= "10阶橙2武防自选",wlv1=551,wlv2=999,gtype_id=34010090,goods_num=1,base_price=50,add_price=25,one_price=500,unsold_price=[{2,0,25}],tv=0,type=0,gold_type=1};
get_goods(4021013,_Wlv) when _Wlv >= 551, _Wlv =< 999 ->
	#base_auction_goods{no=7,goods_id=4021013,name= "11阶橙2武防自选",wlv1=551,wlv2=999,gtype_id=34010091,goods_num=1,base_price=50,add_price=25,one_price=500,unsold_price=[{2,0,25}],tv=0,type=0,gold_type=1};
get_goods(4021014,_Wlv) when _Wlv >= 551, _Wlv =< 999 ->
	#base_auction_goods{no=7,goods_id=4021014,name= "12阶橙2武防自选",wlv1=551,wlv2=999,gtype_id=34010092,goods_num=1,base_price=50,add_price=25,one_price=500,unsold_price=[{2,0,25}],tv=0,type=0,gold_type=1};
get_goods(4021015,_Wlv) when _Wlv >= 551, _Wlv =< 999 ->
	#base_auction_goods{no=7,goods_id=4021015,name= "13阶橙2武防自选",wlv1=551,wlv2=999,gtype_id=34010093,goods_num=1,base_price=80,add_price=40,one_price=800,unsold_price=[{2,0,40}],tv=0,type=0,gold_type=1};
get_goods(4021016,_Wlv) when _Wlv >= 551, _Wlv =< 999 ->
	#base_auction_goods{no=7,goods_id=4021016,name= "秋名飞车碎片",wlv1=551,wlv2=999,gtype_id=16030104,goods_num=5,base_price=50,add_price=25,one_price=500,unsold_price=[{2,0,25}],tv=1,type=0,gold_type=1};
get_goods(4021017,_Wlv) when _Wlv >= 551, _Wlv =< 999 ->
	#base_auction_goods{no=7,goods_id=4021017,name= "秋名飞车碎片",wlv1=551,wlv2=999,gtype_id=16030104,goods_num=5,base_price=50,add_price=25,one_price=500,unsold_price=[{2,0,25}],tv=1,type=0,gold_type=1};
get_goods(4021018,_Wlv) when _Wlv >= 551, _Wlv =< 999 ->
	#base_auction_goods{no=7,goods_id=4021018,name= "阿波罗神魂",wlv1=551,wlv2=999,gtype_id=7120303,goods_num=5,base_price=100,add_price=50,one_price=1000,unsold_price=[{2,0,50}],tv=1,type=0,gold_type=1};
get_goods(4021901,_Wlv) when _Wlv >= 551, _Wlv =< 999 ->
	#base_auction_goods{no=7,goods_id=4021901,name= "勇气之证碎片",wlv1=551,wlv2=999,gtype_id=38040048,goods_num=2,base_price=8,add_price=8,one_price=40,unsold_price=[{2,0,4}],tv=0,type=0,gold_type=2};
get_goods(4021902,_Wlv) when _Wlv >= 551, _Wlv =< 999 ->
	#base_auction_goods{no=7,goods_id=4021902,name= "荣光之证碎片",wlv1=551,wlv2=999,gtype_id=38040049,goods_num=1,base_price=8,add_price=8,one_price=40,unsold_price=[{2,0,4}],tv=0,type=0,gold_type=2};
get_goods(4021903,_Wlv) when _Wlv >= 551, _Wlv =< 999 ->
	#base_auction_goods{no=7,goods_id=4021903,name= "大师之证碎片",wlv1=551,wlv2=999,gtype_id=38040050,goods_num=1,base_price=20,add_price=20,one_price=100,unsold_price=[{2,0,10}],tv=0,type=0,gold_type=2};
get_goods(4021904,_Wlv) when _Wlv >= 551, _Wlv =< 999 ->
	#base_auction_goods{no=7,goods_id=4021904,name= "魔魂丹",wlv1=551,wlv2=999,gtype_id=6101001,goods_num=1,base_price=32,add_price=8,one_price=80,unsold_price=[{2,0,16}],tv=0,type=0,gold_type=2};
get_goods(4021905,_Wlv) when _Wlv >= 551, _Wlv =< 999 ->
	#base_auction_goods{no=7,goods_id=4021905,name= "龙魂丹",wlv1=551,wlv2=999,gtype_id=6101002,goods_num=1,base_price=40,add_price=10,one_price=100,unsold_price=[{2,0,20}],tv=0,type=0,gold_type=2};
get_goods(4021906,_Wlv) when _Wlv >= 551, _Wlv =< 999 ->
	#base_auction_goods{no=7,goods_id=4021906,name= "神魂丹",wlv1=551,wlv2=999,gtype_id=6101003,goods_num=1,base_price=64,add_price=16,one_price=160,unsold_price=[{2,0,32}],tv=0,type=0,gold_type=2};
get_goods(_Goods_id,_Wlv) ->
	[].

get_time(_) ->
	[].

get_time_ids() ->
[].


get_world_bonus_modules(0) ->
[186,402,652];


get_world_bonus_modules(1) ->
[284];

get_world_bonus_modules(_Isbonus) ->
	[].


get_world_auction_duration(186) ->
1800;


get_world_auction_duration(284) ->
1800;


get_world_auction_duration(402) ->
1800;


get_world_auction_duration(652) ->
1800;

get_world_auction_duration(_Moduleid) ->
	1800.


get_module_name(186) ->
"怒海争霸";


get_module_name(284) ->
"跨服圣域";


get_module_name(402) ->
"八岐大蛇";


get_module_name(652) ->
"领地夺宝";

get_module_name(_Moduleid) ->
	"".


get_guild_auction_duration(186) ->
1800;


get_guild_auction_duration(284) ->
0;


get_guild_auction_duration(402) ->
1800;


get_guild_auction_duration(652) ->
1800;

get_guild_auction_duration(_Moduleid) ->
	1800.


get_guild_notice_duration(186) ->
0;


get_guild_notice_duration(284) ->
0;


get_guild_notice_duration(402) ->
60;


get_guild_notice_duration(652) ->
60;

get_guild_notice_duration(_Moduleid) ->
	0.


get_world_notice_duration(186) ->
60;


get_world_notice_duration(284) ->
0;


get_world_notice_duration(402) ->
60;


get_world_notice_duration(652) ->
0;

get_world_notice_duration(_Moduleid) ->
	0.


get_bonus_limit(186) ->
[{0,0}];


get_bonus_limit(284) ->
[{0,0}];


get_bonus_limit(402) ->
[{200,200}];


get_bonus_limit(652) ->
[{0,0}];

get_bonus_limit(_Moduleid) ->
	[].

get_limit_info(284,101100) ->
	#base_auction_produce_limit{mod_id = 284,id = 101100,day_limit = 5,num_limit = 20};

get_limit_info(_Modid,_Id) ->
	[].

