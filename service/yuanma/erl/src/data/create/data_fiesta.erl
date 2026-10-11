%%%---------------------------------------
%%% module      : data_fiesta
%%% description : 祭典配置
%%%
%%%---------------------------------------
-module(data_fiesta).
-compile(export_all).
-include("fiesta.hrl").




get(0) ->
[{8,1,7}];


get(1) ->
[{5,8,30},{6,38,30},{7,68,30}];

get(_Key) ->
	[].

get_base_fiesta_act(101) ->
	#base_fiesta_act{id = 101,act_id = 1,act_name = <<"新手祭典"/utf8>>,min_lv = 95,max_lv = 9999,duration = 7,content1 = [{cost1, [{product_id, 51}]},{reward,[{exp,0},{buff,37121001}]}],content2 = [{cost1, [{product_id, 52}]},{reward,[{exp,400},{buff,37121001}]}],link_id = 223};

get_base_fiesta_act(201) ->
	#base_fiesta_act{id = 201,act_id = 2,act_name = <<"祭典a1"/utf8>>,min_lv = 200,max_lv = 319,duration = 30,content1 = [{cost1, [{product_id, 53}]},{reward,[{exp,0},{buff,37121001}]}],content2 = [{cost1, [{product_id, 54}]},{reward,[{exp,900},{buff,37121001}]}],link_id = 223};

get_base_fiesta_act(202) ->
	#base_fiesta_act{id = 202,act_id = 2,act_name = <<"祭典a2"/utf8>>,min_lv = 320,max_lv = 449,duration = 30,content1 = [{cost1, [{product_id, 53}]},{reward,[{exp,0},{buff,37121001}]}],content2 = [{cost1, [{product_id, 54}]},{reward,[{exp,900},{buff,37121001}]}],link_id = 223};

get_base_fiesta_act(203) ->
	#base_fiesta_act{id = 203,act_id = 2,act_name = <<"祭典a3"/utf8>>,min_lv = 450,max_lv = 9999,duration = 30,content1 = [{cost1, [{product_id, 53}]},{reward,[{exp,0},{buff,37121001}]}],content2 = [{cost1, [{product_id, 54}]},{reward,[{exp,900},{buff,37121001}]}],link_id = 223};

get_base_fiesta_act(301) ->
	#base_fiesta_act{id = 301,act_id = 3,act_name = <<"祭典b1"/utf8>>,min_lv = 200,max_lv = 319,duration = 30,content1 = [{cost1, [{product_id, 53}]},{reward,[{exp,0},{buff,37121001}]}],content2 = [{cost1, [{product_id, 54}]},{reward,[{exp,900},{buff,37121001}]}],link_id = 223};

get_base_fiesta_act(302) ->
	#base_fiesta_act{id = 302,act_id = 3,act_name = <<"祭典b2"/utf8>>,min_lv = 320,max_lv = 449,duration = 30,content1 = [{cost1, [{product_id, 53}]},{reward,[{exp,0},{buff,37121001}]}],content2 = [{cost1, [{product_id, 54}]},{reward,[{exp,900},{buff,37121001}]}],link_id = 223};

get_base_fiesta_act(303) ->
	#base_fiesta_act{id = 303,act_id = 3,act_name = <<"祭典b3"/utf8>>,min_lv = 450,max_lv = 9999,duration = 30,content1 = [{cost1, [{product_id, 53}]},{reward,[{exp,0},{buff,37121001}]}],content2 = [{cost1, [{product_id, 54}]},{reward,[{exp,900},{buff,37121001}]}],link_id = 223};

get_base_fiesta_act(401) ->
	#base_fiesta_act{id = 401,act_id = 4,act_name = <<"祭典c1"/utf8>>,min_lv = 200,max_lv = 319,duration = 30,content1 = [{cost1, [{product_id, 53}]},{reward,[{exp,0},{buff,37121001}]}],content2 = [{cost1, [{product_id, 54}]},{reward,[{exp,900},{buff,37121001}]}],link_id = 223};

get_base_fiesta_act(402) ->
	#base_fiesta_act{id = 402,act_id = 4,act_name = <<"祭典c2"/utf8>>,min_lv = 320,max_lv = 449,duration = 30,content1 = [{cost1, [{product_id, 53}]},{reward,[{exp,0},{buff,37121001}]}],content2 = [{cost1, [{product_id, 54}]},{reward,[{exp,900},{buff,37121001}]}],link_id = 223};

get_base_fiesta_act(403) ->
	#base_fiesta_act{id = 403,act_id = 4,act_name = <<"祭典c3"/utf8>>,min_lv = 450,max_lv = 9999,duration = 30,content1 = [{cost1, [{product_id, 53}]},{reward,[{exp,0},{buff,37121001}]}],content2 = [{cost1, [{product_id, 54}]},{reward,[{exp,900},{buff,37121001}]}],link_id = 223};

get_base_fiesta_act(501) ->
	#base_fiesta_act{id = 501,act_id = 5,act_name = <<"祭典a1"/utf8>>,min_lv = 200,max_lv = 319,duration = 30,content1 = [{cost1, [{product_id, 53}]},{reward,[{exp,0},{buff,37121001}]}],content2 = [{cost1, [{product_id, 54}]},{reward,[{exp,900},{buff,37121001}]}],link_id = 223};

get_base_fiesta_act(502) ->
	#base_fiesta_act{id = 502,act_id = 5,act_name = <<"祭典a2"/utf8>>,min_lv = 320,max_lv = 449,duration = 30,content1 = [{cost1, [{product_id, 53}]},{reward,[{exp,0},{buff,37121001}]}],content2 = [{cost1, [{product_id, 54}]},{reward,[{exp,900},{buff,37121001}]}],link_id = 223};

get_base_fiesta_act(503) ->
	#base_fiesta_act{id = 503,act_id = 5,act_name = <<"祭典a3"/utf8>>,min_lv = 450,max_lv = 9999,duration = 30,content1 = [{cost1, [{product_id, 53}]},{reward,[{exp,0},{buff,37121001}]}],content2 = [{cost1, [{product_id, 54}]},{reward,[{exp,900},{buff,37121001}]}],link_id = 223};

get_base_fiesta_act(601) ->
	#base_fiesta_act{id = 601,act_id = 6,act_name = <<"祭典b1"/utf8>>,min_lv = 200,max_lv = 319,duration = 30,content1 = [{cost1, [{product_id, 53}]},{reward,[{exp,0},{buff,37121001}]}],content2 = [{cost1, [{product_id, 54}]},{reward,[{exp,900},{buff,37121001}]}],link_id = 223};

get_base_fiesta_act(602) ->
	#base_fiesta_act{id = 602,act_id = 6,act_name = <<"祭典b2"/utf8>>,min_lv = 320,max_lv = 449,duration = 30,content1 = [{cost1, [{product_id, 53}]},{reward,[{exp,0},{buff,37121001}]}],content2 = [{cost1, [{product_id, 54}]},{reward,[{exp,900},{buff,37121001}]}],link_id = 223};

get_base_fiesta_act(603) ->
	#base_fiesta_act{id = 603,act_id = 6,act_name = <<"祭典b3"/utf8>>,min_lv = 450,max_lv = 9999,duration = 30,content1 = [{cost1, [{product_id, 53}]},{reward,[{exp,0},{buff,37121001}]}],content2 = [{cost1, [{product_id, 54}]},{reward,[{exp,900},{buff,37121001}]}],link_id = 223};

get_base_fiesta_act(701) ->
	#base_fiesta_act{id = 701,act_id = 7,act_name = <<"祭典c1"/utf8>>,min_lv = 200,max_lv = 319,duration = 30,content1 = [{cost1, [{product_id, 53}]},{reward,[{exp,0},{buff,37121001}]}],content2 = [{cost1, [{product_id, 54}]},{reward,[{exp,900},{buff,37121001}]}],link_id = 223};

get_base_fiesta_act(702) ->
	#base_fiesta_act{id = 702,act_id = 7,act_name = <<"祭典c2"/utf8>>,min_lv = 320,max_lv = 449,duration = 30,content1 = [{cost1, [{product_id, 53}]},{reward,[{exp,0},{buff,37121001}]}],content2 = [{cost1, [{product_id, 54}]},{reward,[{exp,900},{buff,37121001}]}],link_id = 223};

get_base_fiesta_act(703) ->
	#base_fiesta_act{id = 703,act_id = 7,act_name = <<"祭典c3"/utf8>>,min_lv = 450,max_lv = 9999,duration = 30,content1 = [{cost1, [{product_id, 53}]},{reward,[{exp,0},{buff,37121001}]}],content2 = [{cost1, [{product_id, 54}]},{reward,[{exp,900},{buff,37121001}]}],link_id = 223};

get_base_fiesta_act(801) ->
	#base_fiesta_act{id = 801,act_id = 8,act_name = <<"新手祭典"/utf8>>,min_lv = 95,max_lv = 9999,duration = 7,content1 = [{cost1, [{product_id, 51}]},{reward,[{exp,0},{buff,37121001}]}],content2 = [{cost1, [{product_id, 52}]},{reward,[{exp,400},{buff,37121001}]}],link_id = 223};

get_base_fiesta_act(_Id) ->
	[].

get_base_fiesta_act(1,Lv) when Lv >= 95, Lv =< 9999 ->
	#base_fiesta_act{id=101,act_id=1,act_name= <<"新手祭典"/utf8>>,min_lv=95,max_lv=9999,duration=7,content1=[{cost1, [{product_id, 51}]},{reward,[{exp,0},{buff,37121001}]}],content2=[{cost1, [{product_id, 52}]},{reward,[{exp,400},{buff,37121001}]}],link_id=223};
get_base_fiesta_act(2,Lv) when Lv >= 200, Lv =< 319 ->
	#base_fiesta_act{id=201,act_id=2,act_name= <<"祭典a1"/utf8>>,min_lv=200,max_lv=319,duration=30,content1=[{cost1, [{product_id, 53}]},{reward,[{exp,0},{buff,37121001}]}],content2=[{cost1, [{product_id, 54}]},{reward,[{exp,900},{buff,37121001}]}],link_id=223};
get_base_fiesta_act(2,Lv) when Lv >= 320, Lv =< 449 ->
	#base_fiesta_act{id=202,act_id=2,act_name= <<"祭典a2"/utf8>>,min_lv=320,max_lv=449,duration=30,content1=[{cost1, [{product_id, 53}]},{reward,[{exp,0},{buff,37121001}]}],content2=[{cost1, [{product_id, 54}]},{reward,[{exp,900},{buff,37121001}]}],link_id=223};
get_base_fiesta_act(2,Lv) when Lv >= 450, Lv =< 9999 ->
	#base_fiesta_act{id=203,act_id=2,act_name= <<"祭典a3"/utf8>>,min_lv=450,max_lv=9999,duration=30,content1=[{cost1, [{product_id, 53}]},{reward,[{exp,0},{buff,37121001}]}],content2=[{cost1, [{product_id, 54}]},{reward,[{exp,900},{buff,37121001}]}],link_id=223};
get_base_fiesta_act(3,Lv) when Lv >= 200, Lv =< 319 ->
	#base_fiesta_act{id=301,act_id=3,act_name= <<"祭典b1"/utf8>>,min_lv=200,max_lv=319,duration=30,content1=[{cost1, [{product_id, 53}]},{reward,[{exp,0},{buff,37121001}]}],content2=[{cost1, [{product_id, 54}]},{reward,[{exp,900},{buff,37121001}]}],link_id=223};
get_base_fiesta_act(3,Lv) when Lv >= 320, Lv =< 449 ->
	#base_fiesta_act{id=302,act_id=3,act_name= <<"祭典b2"/utf8>>,min_lv=320,max_lv=449,duration=30,content1=[{cost1, [{product_id, 53}]},{reward,[{exp,0},{buff,37121001}]}],content2=[{cost1, [{product_id, 54}]},{reward,[{exp,900},{buff,37121001}]}],link_id=223};
get_base_fiesta_act(3,Lv) when Lv >= 450, Lv =< 9999 ->
	#base_fiesta_act{id=303,act_id=3,act_name= <<"祭典b3"/utf8>>,min_lv=450,max_lv=9999,duration=30,content1=[{cost1, [{product_id, 53}]},{reward,[{exp,0},{buff,37121001}]}],content2=[{cost1, [{product_id, 54}]},{reward,[{exp,900},{buff,37121001}]}],link_id=223};
get_base_fiesta_act(4,Lv) when Lv >= 200, Lv =< 319 ->
	#base_fiesta_act{id=401,act_id=4,act_name= <<"祭典c1"/utf8>>,min_lv=200,max_lv=319,duration=30,content1=[{cost1, [{product_id, 53}]},{reward,[{exp,0},{buff,37121001}]}],content2=[{cost1, [{product_id, 54}]},{reward,[{exp,900},{buff,37121001}]}],link_id=223};
get_base_fiesta_act(4,Lv) when Lv >= 320, Lv =< 449 ->
	#base_fiesta_act{id=402,act_id=4,act_name= <<"祭典c2"/utf8>>,min_lv=320,max_lv=449,duration=30,content1=[{cost1, [{product_id, 53}]},{reward,[{exp,0},{buff,37121001}]}],content2=[{cost1, [{product_id, 54}]},{reward,[{exp,900},{buff,37121001}]}],link_id=223};
get_base_fiesta_act(4,Lv) when Lv >= 450, Lv =< 9999 ->
	#base_fiesta_act{id=403,act_id=4,act_name= <<"祭典c3"/utf8>>,min_lv=450,max_lv=9999,duration=30,content1=[{cost1, [{product_id, 53}]},{reward,[{exp,0},{buff,37121001}]}],content2=[{cost1, [{product_id, 54}]},{reward,[{exp,900},{buff,37121001}]}],link_id=223};
get_base_fiesta_act(5,Lv) when Lv >= 200, Lv =< 319 ->
	#base_fiesta_act{id=501,act_id=5,act_name= <<"祭典a1"/utf8>>,min_lv=200,max_lv=319,duration=30,content1=[{cost1, [{product_id, 53}]},{reward,[{exp,0},{buff,37121001}]}],content2=[{cost1, [{product_id, 54}]},{reward,[{exp,900},{buff,37121001}]}],link_id=223};
get_base_fiesta_act(5,Lv) when Lv >= 320, Lv =< 449 ->
	#base_fiesta_act{id=502,act_id=5,act_name= <<"祭典a2"/utf8>>,min_lv=320,max_lv=449,duration=30,content1=[{cost1, [{product_id, 53}]},{reward,[{exp,0},{buff,37121001}]}],content2=[{cost1, [{product_id, 54}]},{reward,[{exp,900},{buff,37121001}]}],link_id=223};
get_base_fiesta_act(5,Lv) when Lv >= 450, Lv =< 9999 ->
	#base_fiesta_act{id=503,act_id=5,act_name= <<"祭典a3"/utf8>>,min_lv=450,max_lv=9999,duration=30,content1=[{cost1, [{product_id, 53}]},{reward,[{exp,0},{buff,37121001}]}],content2=[{cost1, [{product_id, 54}]},{reward,[{exp,900},{buff,37121001}]}],link_id=223};
get_base_fiesta_act(6,Lv) when Lv >= 200, Lv =< 319 ->
	#base_fiesta_act{id=601,act_id=6,act_name= <<"祭典b1"/utf8>>,min_lv=200,max_lv=319,duration=30,content1=[{cost1, [{product_id, 53}]},{reward,[{exp,0},{buff,37121001}]}],content2=[{cost1, [{product_id, 54}]},{reward,[{exp,900},{buff,37121001}]}],link_id=223};
get_base_fiesta_act(6,Lv) when Lv >= 320, Lv =< 449 ->
	#base_fiesta_act{id=602,act_id=6,act_name= <<"祭典b2"/utf8>>,min_lv=320,max_lv=449,duration=30,content1=[{cost1, [{product_id, 53}]},{reward,[{exp,0},{buff,37121001}]}],content2=[{cost1, [{product_id, 54}]},{reward,[{exp,900},{buff,37121001}]}],link_id=223};
get_base_fiesta_act(6,Lv) when Lv >= 450, Lv =< 9999 ->
	#base_fiesta_act{id=603,act_id=6,act_name= <<"祭典b3"/utf8>>,min_lv=450,max_lv=9999,duration=30,content1=[{cost1, [{product_id, 53}]},{reward,[{exp,0},{buff,37121001}]}],content2=[{cost1, [{product_id, 54}]},{reward,[{exp,900},{buff,37121001}]}],link_id=223};
get_base_fiesta_act(7,Lv) when Lv >= 200, Lv =< 319 ->
	#base_fiesta_act{id=701,act_id=7,act_name= <<"祭典c1"/utf8>>,min_lv=200,max_lv=319,duration=30,content1=[{cost1, [{product_id, 53}]},{reward,[{exp,0},{buff,37121001}]}],content2=[{cost1, [{product_id, 54}]},{reward,[{exp,900},{buff,37121001}]}],link_id=223};
get_base_fiesta_act(7,Lv) when Lv >= 320, Lv =< 449 ->
	#base_fiesta_act{id=702,act_id=7,act_name= <<"祭典c2"/utf8>>,min_lv=320,max_lv=449,duration=30,content1=[{cost1, [{product_id, 53}]},{reward,[{exp,0},{buff,37121001}]}],content2=[{cost1, [{product_id, 54}]},{reward,[{exp,900},{buff,37121001}]}],link_id=223};
get_base_fiesta_act(7,Lv) when Lv >= 450, Lv =< 9999 ->
	#base_fiesta_act{id=703,act_id=7,act_name= <<"祭典c3"/utf8>>,min_lv=450,max_lv=9999,duration=30,content1=[{cost1, [{product_id, 53}]},{reward,[{exp,0},{buff,37121001}]}],content2=[{cost1, [{product_id, 54}]},{reward,[{exp,900},{buff,37121001}]}],link_id=223};
get_base_fiesta_act(8,Lv) when Lv >= 95, Lv =< 9999 ->
	#base_fiesta_act{id=801,act_id=8,act_name= <<"新手祭典"/utf8>>,min_lv=95,max_lv=9999,duration=7,content1=[{cost1, [{product_id, 51}]},{reward,[{exp,0},{buff,37121001}]}],content2=[{cost1, [{product_id, 52}]},{reward,[{exp,400},{buff,37121001}]}],link_id=223};
get_base_fiesta_act(_Act_id,_Lv) ->
	[].

get_base_fiesta_lv_exp(101,1) ->
	#base_fiesta_lv_exp{id = 101,act_id = 1,lv = 1,exp = 130,reward = [{0,16020001,2}],premium_reward = [{0,16020002,1}]};

get_base_fiesta_lv_exp(101,2) ->
	#base_fiesta_lv_exp{id = 101,act_id = 1,lv = 2,exp = 260,reward = [{0,16010001,1}],premium_reward = [{0,16010003,1}]};

get_base_fiesta_lv_exp(101,3) ->
	#base_fiesta_lv_exp{id = 101,act_id = 1,lv = 3,exp = 390,reward = [{0,38370001,1}],premium_reward = [{0,37121002,1}]};

get_base_fiesta_lv_exp(101,4) ->
	#base_fiesta_lv_exp{id = 101,act_id = 1,lv = 4,exp = 520,reward = [{0,37020001,2}],premium_reward = [{0,37020002,1}]};

get_base_fiesta_lv_exp(101,5) ->
	#base_fiesta_lv_exp{id = 101,act_id = 1,lv = 5,exp = 650,reward = [{0,38030003,1}],premium_reward = [{0,38030004,2}]};

get_base_fiesta_lv_exp(101,6) ->
	#base_fiesta_lv_exp{id = 101,act_id = 1,lv = 6,exp = 780,reward = [{0,17020001,2}],premium_reward = [{0,17020002,1}]};

get_base_fiesta_lv_exp(101,7) ->
	#base_fiesta_lv_exp{id = 101,act_id = 1,lv = 7,exp = 910,reward = [{0,38040005,30}],premium_reward = [{0,38040027,1}]};

get_base_fiesta_lv_exp(101,8) ->
	#base_fiesta_lv_exp{id = 101,act_id = 1,lv = 8,exp = 1040,reward = [{0,38030001,1}],premium_reward = [{0,38280001,1}]};

get_base_fiesta_lv_exp(101,9) ->
	#base_fiesta_lv_exp{id = 101,act_id = 1,lv = 9,exp = 1170,reward = [{0,38370001,1}],premium_reward = [{0,38160001,1}]};

get_base_fiesta_lv_exp(101,10) ->
	#base_fiesta_lv_exp{id = 101,act_id = 1,lv = 10,exp = 1300,reward = [{0,12020004,1}],premium_reward = [{0,12010004,1}]};

get_base_fiesta_lv_exp(101,11) ->
	#base_fiesta_lv_exp{id = 101,act_id = 1,lv = 11,exp = 1430,reward = [{0,16010002,1}],premium_reward = [{0,16010003,1}]};

get_base_fiesta_lv_exp(101,12) ->
	#base_fiesta_lv_exp{id = 101,act_id = 1,lv = 12,exp = 1560,reward = [{0,32010001,1}],premium_reward = [{0,32010002,1}]};

get_base_fiesta_lv_exp(101,13) ->
	#base_fiesta_lv_exp{id = 101,act_id = 1,lv = 13,exp = 1690,reward = [{0,32010119,3}],premium_reward = [{0,32010120,3}]};

get_base_fiesta_lv_exp(101,14) ->
	#base_fiesta_lv_exp{id = 101,act_id = 1,lv = 14,exp = 1820,reward = [{0,38100002,3}],premium_reward = [{0,38100002,6}]};

get_base_fiesta_lv_exp(101,15) ->
	#base_fiesta_lv_exp{id = 101,act_id = 1,lv = 15,exp = 1950,reward = [{0,6011305,1}],premium_reward = [{0,6102001,1}]};

get_base_fiesta_lv_exp(201,1) ->
	#base_fiesta_lv_exp{id = 201,act_id = 2,lv = 1,exp = 300,reward = [{0,16020001,2}],premium_reward = [{0,16020002,1}]};

get_base_fiesta_lv_exp(201,2) ->
	#base_fiesta_lv_exp{id = 201,act_id = 2,lv = 2,exp = 600,reward = [{0,38040005,25}],premium_reward = [{0,38040005,50}]};

get_base_fiesta_lv_exp(201,3) ->
	#base_fiesta_lv_exp{id = 201,act_id = 2,lv = 3,exp = 900,reward = [{0,37020001,2}],premium_reward = [{0,37121002,1}]};

get_base_fiesta_lv_exp(201,4) ->
	#base_fiesta_lv_exp{id = 201,act_id = 2,lv = 4,exp = 1200,reward = [{0,16020001,2}],premium_reward = [{0,16020002,1}]};

get_base_fiesta_lv_exp(201,5) ->
	#base_fiesta_lv_exp{id = 201,act_id = 2,lv = 5,exp = 1500,reward = [{0,38370001,1}],premium_reward = [{0,38160001,1}]};

get_base_fiesta_lv_exp(201,6) ->
	#base_fiesta_lv_exp{id = 201,act_id = 2,lv = 6,exp = 1800,reward = [{0,32010119,2}],premium_reward = [{0,32010120,1}]};

get_base_fiesta_lv_exp(201,7) ->
	#base_fiesta_lv_exp{id = 201,act_id = 2,lv = 7,exp = 2100,reward = [{0,38030003,1}],premium_reward = [{0,38030004,2}]};

get_base_fiesta_lv_exp(201,8) ->
	#base_fiesta_lv_exp{id = 201,act_id = 2,lv = 8,exp = 2400,reward = [{0,16020001,2}],premium_reward = [{0,16020002,1}]};

get_base_fiesta_lv_exp(201,9) ->
	#base_fiesta_lv_exp{id = 201,act_id = 2,lv = 9,exp = 2700,reward = [{0,38100002,2}],premium_reward = [{0,38100002,5}]};

get_base_fiesta_lv_exp(201,10) ->
	#base_fiesta_lv_exp{id = 201,act_id = 2,lv = 10,exp = 3000,reward = [{0,39510021,1}],premium_reward = [{0,37121003,1}]};

get_base_fiesta_lv_exp(201,11) ->
	#base_fiesta_lv_exp{id = 201,act_id = 2,lv = 11,exp = 3300,reward = [{0,16020001,2}],premium_reward = [{0,16020002,1}]};

get_base_fiesta_lv_exp(201,12) ->
	#base_fiesta_lv_exp{id = 201,act_id = 2,lv = 12,exp = 3600,reward = [{0,38100002,2}],premium_reward = [{0,38100002,5}]};

get_base_fiesta_lv_exp(201,13) ->
	#base_fiesta_lv_exp{id = 201,act_id = 2,lv = 13,exp = 3900,reward = [{0,38040005,50}],premium_reward = [{0,38040027,1}]};

get_base_fiesta_lv_exp(201,14) ->
	#base_fiesta_lv_exp{id = 201,act_id = 2,lv = 14,exp = 4200,reward = [{0,32010119,2}],premium_reward = [{0,32010120,1}]};

get_base_fiesta_lv_exp(201,15) ->
	#base_fiesta_lv_exp{id = 201,act_id = 2,lv = 15,exp = 4500,reward = [{0,38160001,1}],premium_reward = [{0,37020002,1}]};

get_base_fiesta_lv_exp(201,16) ->
	#base_fiesta_lv_exp{id = 201,act_id = 2,lv = 16,exp = 4800,reward = [{0,32010001,1}],premium_reward = [{0,32010002,1}]};

get_base_fiesta_lv_exp(201,17) ->
	#base_fiesta_lv_exp{id = 201,act_id = 2,lv = 17,exp = 5100,reward = [{0,16020001,5}],premium_reward = [{0,16020002,2}]};

get_base_fiesta_lv_exp(201,18) ->
	#base_fiesta_lv_exp{id = 201,act_id = 2,lv = 18,exp = 5400,reward = [{0,38100002,3}],premium_reward = [{0,38100002,6}]};

get_base_fiesta_lv_exp(201,19) ->
	#base_fiesta_lv_exp{id = 201,act_id = 2,lv = 19,exp = 5700,reward = [{0,32010001,1}],premium_reward = [{0,32010002,1}]};

get_base_fiesta_lv_exp(201,20) ->
	#base_fiesta_lv_exp{id = 201,act_id = 2,lv = 20,exp = 6000,reward = [{0,16010003,1}],premium_reward = [{0,6101004,2}]};

get_base_fiesta_lv_exp(201,21) ->
	#base_fiesta_lv_exp{id = 201,act_id = 2,lv = 21,exp = 6300,reward = [{0,18020001,3}],premium_reward = [{0,18020002,1}]};

get_base_fiesta_lv_exp(201,22) ->
	#base_fiesta_lv_exp{id = 201,act_id = 2,lv = 22,exp = 6600,reward = [{0,38100002,3}],premium_reward = [{0,38100002,6}]};

get_base_fiesta_lv_exp(201,23) ->
	#base_fiesta_lv_exp{id = 201,act_id = 2,lv = 23,exp = 6900,reward = [{0,32010002,1}],premium_reward = [{0,32010003,1}]};

get_base_fiesta_lv_exp(201,24) ->
	#base_fiesta_lv_exp{id = 201,act_id = 2,lv = 24,exp = 7200,reward = [{0,18020001,3}],premium_reward = [{0,18020002,1}]};

get_base_fiesta_lv_exp(201,25) ->
	#base_fiesta_lv_exp{id = 201,act_id = 2,lv = 25,exp = 7500,reward = [{0,6101003,1}],premium_reward = [{0,6101004,1}]};

get_base_fiesta_lv_exp(201,26) ->
	#base_fiesta_lv_exp{id = 201,act_id = 2,lv = 26,exp = 7800,reward = [{0,32010119,3}],premium_reward = [{0,32010120,2}]};

get_base_fiesta_lv_exp(201,27) ->
	#base_fiesta_lv_exp{id = 201,act_id = 2,lv = 27,exp = 8100,reward = [{0,38030003,1}],premium_reward = [{0,38030004,2}]};

get_base_fiesta_lv_exp(201,28) ->
	#base_fiesta_lv_exp{id = 201,act_id = 2,lv = 28,exp = 8400,reward = [{0,18020001,3}],premium_reward = [{0,18020002,1}]};

get_base_fiesta_lv_exp(201,29) ->
	#base_fiesta_lv_exp{id = 201,act_id = 2,lv = 29,exp = 8700,reward = [{0,38040005,30}],premium_reward = [{0,38040005,60}]};

get_base_fiesta_lv_exp(201,30) ->
	#base_fiesta_lv_exp{id = 201,act_id = 2,lv = 30,exp = 9000,reward = [{0,34010390,1}],premium_reward = [{0,6102001,1}]};

get_base_fiesta_lv_exp(201,31) ->
	#base_fiesta_lv_exp{id = 201,act_id = 2,lv = 31,exp = 9300,reward = [{0,32010119,3}],premium_reward = [{0,32010120,3}]};

get_base_fiesta_lv_exp(201,32) ->
	#base_fiesta_lv_exp{id = 201,act_id = 2,lv = 32,exp = 9600,reward = [{0,38370003,1}],premium_reward = [{0,38030004,1}]};

get_base_fiesta_lv_exp(201,33) ->
	#base_fiesta_lv_exp{id = 201,act_id = 2,lv = 33,exp = 9900,reward = [{0,38040005,50}],premium_reward = [{0,38040027,1}]};

get_base_fiesta_lv_exp(201,34) ->
	#base_fiesta_lv_exp{id = 201,act_id = 2,lv = 34,exp = 10200,reward = [{0,38100002,3}],premium_reward = [{0,38100002,6}]};

get_base_fiesta_lv_exp(201,35) ->
	#base_fiesta_lv_exp{id = 201,act_id = 2,lv = 35,exp = 10500,reward = [{0,32010002,2}],premium_reward = [{0,32010004,1}]};

get_base_fiesta_lv_exp(201,36) ->
	#base_fiesta_lv_exp{id = 201,act_id = 2,lv = 36,exp = 10800,reward = [{0,18020001,3}],premium_reward = [{0,18020002,1}]};

get_base_fiesta_lv_exp(201,37) ->
	#base_fiesta_lv_exp{id = 201,act_id = 2,lv = 37,exp = 11100,reward = [{0,32010002,1}],premium_reward = [{0,32010003,1}]};

get_base_fiesta_lv_exp(201,38) ->
	#base_fiesta_lv_exp{id = 201,act_id = 2,lv = 38,exp = 11400,reward = [{0,32010119,3}],premium_reward = [{0,32010120,3}]};

get_base_fiesta_lv_exp(201,39) ->
	#base_fiesta_lv_exp{id = 201,act_id = 2,lv = 39,exp = 11700,reward = [{0,18020001,3}],premium_reward = [{0,18020002,1}]};

get_base_fiesta_lv_exp(201,40) ->
	#base_fiesta_lv_exp{id = 201,act_id = 2,lv = 40,exp = 12000,reward = [{0,34010391,1}],premium_reward = [{0,18030115,30}]};

get_base_fiesta_lv_exp(201,41) ->
	#base_fiesta_lv_exp{id = 201,act_id = 2,lv = 41,exp = 12500,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(201,42) ->
	#base_fiesta_lv_exp{id = 201,act_id = 2,lv = 42,exp = 13000,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(201,43) ->
	#base_fiesta_lv_exp{id = 201,act_id = 2,lv = 43,exp = 13500,reward = [{0,23020001,4}],premium_reward = [{0,38040041,5}]};

get_base_fiesta_lv_exp(201,44) ->
	#base_fiesta_lv_exp{id = 201,act_id = 2,lv = 44,exp = 14000,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(201,45) ->
	#base_fiesta_lv_exp{id = 201,act_id = 2,lv = 45,exp = 14500,reward = [{0,23020001,4}],premium_reward = [{0,38040041,5}]};

get_base_fiesta_lv_exp(201,46) ->
	#base_fiesta_lv_exp{id = 201,act_id = 2,lv = 46,exp = 15000,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(201,47) ->
	#base_fiesta_lv_exp{id = 201,act_id = 2,lv = 47,exp = 15500,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(201,48) ->
	#base_fiesta_lv_exp{id = 201,act_id = 2,lv = 48,exp = 16000,reward = [{0,23020001,4}],premium_reward = [{0,38040041,5}]};

get_base_fiesta_lv_exp(201,49) ->
	#base_fiesta_lv_exp{id = 201,act_id = 2,lv = 49,exp = 16500,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(201,50) ->
	#base_fiesta_lv_exp{id = 201,act_id = 2,lv = 50,exp = 17000,reward = [{0,23020001,4}],premium_reward = [{0,38040041,5}]};

get_base_fiesta_lv_exp(201,51) ->
	#base_fiesta_lv_exp{id = 201,act_id = 2,lv = 51,exp = 17500,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(201,52) ->
	#base_fiesta_lv_exp{id = 201,act_id = 2,lv = 52,exp = 18000,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(201,53) ->
	#base_fiesta_lv_exp{id = 201,act_id = 2,lv = 53,exp = 18500,reward = [{0,23020001,4}],premium_reward = [{0,38040041,5}]};

get_base_fiesta_lv_exp(201,54) ->
	#base_fiesta_lv_exp{id = 201,act_id = 2,lv = 54,exp = 19000,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(201,55) ->
	#base_fiesta_lv_exp{id = 201,act_id = 2,lv = 55,exp = 19500,reward = [{0,23020001,4}],premium_reward = [{0,38040041,5}]};

get_base_fiesta_lv_exp(201,56) ->
	#base_fiesta_lv_exp{id = 201,act_id = 2,lv = 56,exp = 20000,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(201,57) ->
	#base_fiesta_lv_exp{id = 201,act_id = 2,lv = 57,exp = 20500,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(201,58) ->
	#base_fiesta_lv_exp{id = 201,act_id = 2,lv = 58,exp = 21000,reward = [{0,23020001,4}],premium_reward = [{0,38040041,5}]};

get_base_fiesta_lv_exp(201,59) ->
	#base_fiesta_lv_exp{id = 201,act_id = 2,lv = 59,exp = 21500,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(201,60) ->
	#base_fiesta_lv_exp{id = 201,act_id = 2,lv = 60,exp = 22000,reward = [{0,23020001,4}],premium_reward = [{0,38040041,5}]};

get_base_fiesta_lv_exp(202,1) ->
	#base_fiesta_lv_exp{id = 202,act_id = 2,lv = 1,exp = 300,reward = [{0,19020001,2}],premium_reward = [{0,19020002,1}]};

get_base_fiesta_lv_exp(202,2) ->
	#base_fiesta_lv_exp{id = 202,act_id = 2,lv = 2,exp = 600,reward = [{0,38040005,25}],premium_reward = [{0,38040005,50}]};

get_base_fiesta_lv_exp(202,3) ->
	#base_fiesta_lv_exp{id = 202,act_id = 2,lv = 3,exp = 900,reward = [{0,37020001,2}],premium_reward = [{0,37121002,1}]};

get_base_fiesta_lv_exp(202,4) ->
	#base_fiesta_lv_exp{id = 202,act_id = 2,lv = 4,exp = 1200,reward = [{0,19020001,2}],premium_reward = [{0,19020002,1}]};

get_base_fiesta_lv_exp(202,5) ->
	#base_fiesta_lv_exp{id = 202,act_id = 2,lv = 5,exp = 1500,reward = [{0,38370001,1}],premium_reward = [{0,38160001,1}]};

get_base_fiesta_lv_exp(202,6) ->
	#base_fiesta_lv_exp{id = 202,act_id = 2,lv = 6,exp = 1800,reward = [{0,32010119,2}],premium_reward = [{0,32010120,1}]};

get_base_fiesta_lv_exp(202,7) ->
	#base_fiesta_lv_exp{id = 202,act_id = 2,lv = 7,exp = 2100,reward = [{0,38030005,1}],premium_reward = [{0,38030004,2}]};

get_base_fiesta_lv_exp(202,8) ->
	#base_fiesta_lv_exp{id = 202,act_id = 2,lv = 8,exp = 2400,reward = [{0,19020001,2}],premium_reward = [{0,19020002,1}]};

get_base_fiesta_lv_exp(202,9) ->
	#base_fiesta_lv_exp{id = 202,act_id = 2,lv = 9,exp = 2700,reward = [{0,38100002,2}],premium_reward = [{0,38100002,5}]};

get_base_fiesta_lv_exp(202,10) ->
	#base_fiesta_lv_exp{id = 202,act_id = 2,lv = 10,exp = 3000,reward = [{0,39510021,1}],premium_reward = [{0,37121003,1}]};

get_base_fiesta_lv_exp(202,11) ->
	#base_fiesta_lv_exp{id = 202,act_id = 2,lv = 11,exp = 3300,reward = [{0,19020001,2}],premium_reward = [{0,19020002,1}]};

get_base_fiesta_lv_exp(202,12) ->
	#base_fiesta_lv_exp{id = 202,act_id = 2,lv = 12,exp = 3600,reward = [{0,38100002,2}],premium_reward = [{0,38100002,5}]};

get_base_fiesta_lv_exp(202,13) ->
	#base_fiesta_lv_exp{id = 202,act_id = 2,lv = 13,exp = 3900,reward = [{0,38040005,50}],premium_reward = [{0,38040027,1}]};

get_base_fiesta_lv_exp(202,14) ->
	#base_fiesta_lv_exp{id = 202,act_id = 2,lv = 14,exp = 4200,reward = [{0,32010119,2}],premium_reward = [{0,32010120,1}]};

get_base_fiesta_lv_exp(202,15) ->
	#base_fiesta_lv_exp{id = 202,act_id = 2,lv = 15,exp = 4500,reward = [{0,38160001,1}],premium_reward = [{0,37020002,1}]};

get_base_fiesta_lv_exp(202,16) ->
	#base_fiesta_lv_exp{id = 202,act_id = 2,lv = 16,exp = 4800,reward = [{0,32010001,1}],premium_reward = [{0,32010002,1}]};

get_base_fiesta_lv_exp(202,17) ->
	#base_fiesta_lv_exp{id = 202,act_id = 2,lv = 17,exp = 5100,reward = [{0,19020001,5}],premium_reward = [{0,19020002,1}]};

get_base_fiesta_lv_exp(202,18) ->
	#base_fiesta_lv_exp{id = 202,act_id = 2,lv = 18,exp = 5400,reward = [{0,38100002,3}],premium_reward = [{0,38100002,6}]};

get_base_fiesta_lv_exp(202,19) ->
	#base_fiesta_lv_exp{id = 202,act_id = 2,lv = 19,exp = 5700,reward = [{0,32010001,1}],premium_reward = [{0,32010002,1}]};

get_base_fiesta_lv_exp(202,20) ->
	#base_fiesta_lv_exp{id = 202,act_id = 2,lv = 20,exp = 6000,reward = [{0,18010003,1}],premium_reward = [{0,6101004,2}]};

get_base_fiesta_lv_exp(202,21) ->
	#base_fiesta_lv_exp{id = 202,act_id = 2,lv = 21,exp = 6300,reward = [{0,20020001,3}],premium_reward = [{0,20020002,1}]};

get_base_fiesta_lv_exp(202,22) ->
	#base_fiesta_lv_exp{id = 202,act_id = 2,lv = 22,exp = 6600,reward = [{0,38100002,3}],premium_reward = [{0,38100002,6}]};

get_base_fiesta_lv_exp(202,23) ->
	#base_fiesta_lv_exp{id = 202,act_id = 2,lv = 23,exp = 6900,reward = [{0,32010002,1}],premium_reward = [{0,32010003,1}]};

get_base_fiesta_lv_exp(202,24) ->
	#base_fiesta_lv_exp{id = 202,act_id = 2,lv = 24,exp = 7200,reward = [{0,20020001,3}],premium_reward = [{0,20020002,1}]};

get_base_fiesta_lv_exp(202,25) ->
	#base_fiesta_lv_exp{id = 202,act_id = 2,lv = 25,exp = 7500,reward = [{0,6101003,1}],premium_reward = [{0,6101004,1}]};

get_base_fiesta_lv_exp(202,26) ->
	#base_fiesta_lv_exp{id = 202,act_id = 2,lv = 26,exp = 7800,reward = [{0,32010119,3}],premium_reward = [{0,32010120,2}]};

get_base_fiesta_lv_exp(202,27) ->
	#base_fiesta_lv_exp{id = 202,act_id = 2,lv = 27,exp = 8100,reward = [{0,38030005,1}],premium_reward = [{0,38030004,2}]};

get_base_fiesta_lv_exp(202,28) ->
	#base_fiesta_lv_exp{id = 202,act_id = 2,lv = 28,exp = 8400,reward = [{0,20020001,3}],premium_reward = [{0,20020002,1}]};

get_base_fiesta_lv_exp(202,29) ->
	#base_fiesta_lv_exp{id = 202,act_id = 2,lv = 29,exp = 8700,reward = [{0,38040005,30}],premium_reward = [{0,38040005,60}]};

get_base_fiesta_lv_exp(202,30) ->
	#base_fiesta_lv_exp{id = 202,act_id = 2,lv = 30,exp = 9000,reward = [{0,34010390,1}],premium_reward = [{0,6102001,1}]};

get_base_fiesta_lv_exp(202,31) ->
	#base_fiesta_lv_exp{id = 202,act_id = 2,lv = 31,exp = 9300,reward = [{0,32010119,3}],premium_reward = [{0,32010120,3}]};

get_base_fiesta_lv_exp(202,32) ->
	#base_fiesta_lv_exp{id = 202,act_id = 2,lv = 32,exp = 9600,reward = [{0,38370002,1}],premium_reward = [{0,38030004,1}]};

get_base_fiesta_lv_exp(202,33) ->
	#base_fiesta_lv_exp{id = 202,act_id = 2,lv = 33,exp = 9900,reward = [{0,38040005,50}],premium_reward = [{0,38040027,1}]};

get_base_fiesta_lv_exp(202,34) ->
	#base_fiesta_lv_exp{id = 202,act_id = 2,lv = 34,exp = 10200,reward = [{0,38100002,3}],premium_reward = [{0,38100002,6}]};

get_base_fiesta_lv_exp(202,35) ->
	#base_fiesta_lv_exp{id = 202,act_id = 2,lv = 35,exp = 10500,reward = [{0,32010002,2}],premium_reward = [{0,32010004,1}]};

get_base_fiesta_lv_exp(202,36) ->
	#base_fiesta_lv_exp{id = 202,act_id = 2,lv = 36,exp = 10800,reward = [{0,20020001,3}],premium_reward = [{0,20020002,1}]};

get_base_fiesta_lv_exp(202,37) ->
	#base_fiesta_lv_exp{id = 202,act_id = 2,lv = 37,exp = 11100,reward = [{0,32010002,1}],premium_reward = [{0,32010003,1}]};

get_base_fiesta_lv_exp(202,38) ->
	#base_fiesta_lv_exp{id = 202,act_id = 2,lv = 38,exp = 11400,reward = [{0,32010119,3}],premium_reward = [{0,32010120,3}]};

get_base_fiesta_lv_exp(202,39) ->
	#base_fiesta_lv_exp{id = 202,act_id = 2,lv = 39,exp = 11700,reward = [{0,20020001,3}],premium_reward = [{0,20020002,1}]};

get_base_fiesta_lv_exp(202,40) ->
	#base_fiesta_lv_exp{id = 202,act_id = 2,lv = 40,exp = 12000,reward = [{0,32010141,1}],premium_reward = [{0,18030115,30}]};

get_base_fiesta_lv_exp(202,41) ->
	#base_fiesta_lv_exp{id = 202,act_id = 2,lv = 41,exp = 12500,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(202,42) ->
	#base_fiesta_lv_exp{id = 202,act_id = 2,lv = 42,exp = 13000,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(202,43) ->
	#base_fiesta_lv_exp{id = 202,act_id = 2,lv = 43,exp = 13500,reward = [{0,39510000,4}],premium_reward = [{0,39510000,10}]};

get_base_fiesta_lv_exp(202,44) ->
	#base_fiesta_lv_exp{id = 202,act_id = 2,lv = 44,exp = 14000,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(202,45) ->
	#base_fiesta_lv_exp{id = 202,act_id = 2,lv = 45,exp = 14500,reward = [{0,38040018,4}],premium_reward = [{0,38040018,10}]};

get_base_fiesta_lv_exp(202,46) ->
	#base_fiesta_lv_exp{id = 202,act_id = 2,lv = 46,exp = 15000,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(202,47) ->
	#base_fiesta_lv_exp{id = 202,act_id = 2,lv = 47,exp = 15500,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(202,48) ->
	#base_fiesta_lv_exp{id = 202,act_id = 2,lv = 48,exp = 16000,reward = [{0,39510000,4}],premium_reward = [{0,39510000,10}]};

get_base_fiesta_lv_exp(202,49) ->
	#base_fiesta_lv_exp{id = 202,act_id = 2,lv = 49,exp = 16500,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(202,50) ->
	#base_fiesta_lv_exp{id = 202,act_id = 2,lv = 50,exp = 17000,reward = [{0,38040018,4}],premium_reward = [{0,38040018,10}]};

get_base_fiesta_lv_exp(202,51) ->
	#base_fiesta_lv_exp{id = 202,act_id = 2,lv = 51,exp = 17500,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(202,52) ->
	#base_fiesta_lv_exp{id = 202,act_id = 2,lv = 52,exp = 18000,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(202,53) ->
	#base_fiesta_lv_exp{id = 202,act_id = 2,lv = 53,exp = 18500,reward = [{0,39510000,4}],premium_reward = [{0,39510000,10}]};

get_base_fiesta_lv_exp(202,54) ->
	#base_fiesta_lv_exp{id = 202,act_id = 2,lv = 54,exp = 19000,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(202,55) ->
	#base_fiesta_lv_exp{id = 202,act_id = 2,lv = 55,exp = 19500,reward = [{0,38040018,4}],premium_reward = [{0,38040018,10}]};

get_base_fiesta_lv_exp(202,56) ->
	#base_fiesta_lv_exp{id = 202,act_id = 2,lv = 56,exp = 20000,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(202,57) ->
	#base_fiesta_lv_exp{id = 202,act_id = 2,lv = 57,exp = 20500,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(202,58) ->
	#base_fiesta_lv_exp{id = 202,act_id = 2,lv = 58,exp = 21000,reward = [{0,39510000,4}],premium_reward = [{0,39510000,10}]};

get_base_fiesta_lv_exp(202,59) ->
	#base_fiesta_lv_exp{id = 202,act_id = 2,lv = 59,exp = 21500,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(202,60) ->
	#base_fiesta_lv_exp{id = 202,act_id = 2,lv = 60,exp = 22000,reward = [{0,38040018,4}],premium_reward = [{0,38040018,10}]};

get_base_fiesta_lv_exp(203,1) ->
	#base_fiesta_lv_exp{id = 203,act_id = 2,lv = 1,exp = 300,reward = [{0,7301001,2}],premium_reward = [{0,7301002,1}]};

get_base_fiesta_lv_exp(203,2) ->
	#base_fiesta_lv_exp{id = 203,act_id = 2,lv = 2,exp = 600,reward = [{0,38040005,25}],premium_reward = [{0,38040005,50}]};

get_base_fiesta_lv_exp(203,3) ->
	#base_fiesta_lv_exp{id = 203,act_id = 2,lv = 3,exp = 900,reward = [{0,37020001,2}],premium_reward = [{0,37121002,1}]};

get_base_fiesta_lv_exp(203,4) ->
	#base_fiesta_lv_exp{id = 203,act_id = 2,lv = 4,exp = 1200,reward = [{0,7301001,2}],premium_reward = [{0,7301002,1}]};

get_base_fiesta_lv_exp(203,5) ->
	#base_fiesta_lv_exp{id = 203,act_id = 2,lv = 5,exp = 1500,reward = [{0,38370001,1}],premium_reward = [{0,38160001,1}]};

get_base_fiesta_lv_exp(203,6) ->
	#base_fiesta_lv_exp{id = 203,act_id = 2,lv = 6,exp = 1800,reward = [{0,32010119,2}],premium_reward = [{0,32010120,1}]};

get_base_fiesta_lv_exp(203,7) ->
	#base_fiesta_lv_exp{id = 203,act_id = 2,lv = 7,exp = 2100,reward = [{0,38030005,1}],premium_reward = [{0,38030004,2}]};

get_base_fiesta_lv_exp(203,8) ->
	#base_fiesta_lv_exp{id = 203,act_id = 2,lv = 8,exp = 2400,reward = [{0,7301001,2}],premium_reward = [{0,7301002,1}]};

get_base_fiesta_lv_exp(203,9) ->
	#base_fiesta_lv_exp{id = 203,act_id = 2,lv = 9,exp = 2700,reward = [{0,38100002,2}],premium_reward = [{0,38100002,5}]};

get_base_fiesta_lv_exp(203,10) ->
	#base_fiesta_lv_exp{id = 203,act_id = 2,lv = 10,exp = 3000,reward = [{0,39510021,1}],premium_reward = [{0,37121003,1}]};

get_base_fiesta_lv_exp(203,11) ->
	#base_fiesta_lv_exp{id = 203,act_id = 2,lv = 11,exp = 3300,reward = [{0,7301001,2}],premium_reward = [{0,7301002,1}]};

get_base_fiesta_lv_exp(203,12) ->
	#base_fiesta_lv_exp{id = 203,act_id = 2,lv = 12,exp = 3600,reward = [{0,38100002,2}],premium_reward = [{0,38100002,5}]};

get_base_fiesta_lv_exp(203,13) ->
	#base_fiesta_lv_exp{id = 203,act_id = 2,lv = 13,exp = 3900,reward = [{0,38040005,50}],premium_reward = [{0,38040027,1}]};

get_base_fiesta_lv_exp(203,14) ->
	#base_fiesta_lv_exp{id = 203,act_id = 2,lv = 14,exp = 4200,reward = [{0,32010119,2}],premium_reward = [{0,32010120,1}]};

get_base_fiesta_lv_exp(203,15) ->
	#base_fiesta_lv_exp{id = 203,act_id = 2,lv = 15,exp = 4500,reward = [{0,38160001,1}],premium_reward = [{0,37020002,1}]};

get_base_fiesta_lv_exp(203,16) ->
	#base_fiesta_lv_exp{id = 203,act_id = 2,lv = 16,exp = 4800,reward = [{0,32010001,1}],premium_reward = [{0,32010002,1}]};

get_base_fiesta_lv_exp(203,17) ->
	#base_fiesta_lv_exp{id = 203,act_id = 2,lv = 17,exp = 5100,reward = [{0,7301001,5}],premium_reward = [{0,7301002,1}]};

get_base_fiesta_lv_exp(203,18) ->
	#base_fiesta_lv_exp{id = 203,act_id = 2,lv = 18,exp = 5400,reward = [{0,38100002,3}],premium_reward = [{0,38100002,6}]};

get_base_fiesta_lv_exp(203,19) ->
	#base_fiesta_lv_exp{id = 203,act_id = 2,lv = 19,exp = 5700,reward = [{0,32010001,1}],premium_reward = [{0,32010002,1}]};

get_base_fiesta_lv_exp(203,20) ->
	#base_fiesta_lv_exp{id = 203,act_id = 2,lv = 20,exp = 6000,reward = [{0,20010003,1}],premium_reward = [{0,6101004,2}]};

get_base_fiesta_lv_exp(203,21) ->
	#base_fiesta_lv_exp{id = 203,act_id = 2,lv = 21,exp = 6300,reward = [{0,7301003,3}],premium_reward = [{0,7301004,1}]};

get_base_fiesta_lv_exp(203,22) ->
	#base_fiesta_lv_exp{id = 203,act_id = 2,lv = 22,exp = 6600,reward = [{0,38100002,3}],premium_reward = [{0,38100002,6}]};

get_base_fiesta_lv_exp(203,23) ->
	#base_fiesta_lv_exp{id = 203,act_id = 2,lv = 23,exp = 6900,reward = [{0,32010002,1}],premium_reward = [{0,32010003,1}]};

get_base_fiesta_lv_exp(203,24) ->
	#base_fiesta_lv_exp{id = 203,act_id = 2,lv = 24,exp = 7200,reward = [{0,7301003,3}],premium_reward = [{0,7301004,1}]};

get_base_fiesta_lv_exp(203,25) ->
	#base_fiesta_lv_exp{id = 203,act_id = 2,lv = 25,exp = 7500,reward = [{0,6101003,1}],premium_reward = [{0,6101004,1}]};

get_base_fiesta_lv_exp(203,26) ->
	#base_fiesta_lv_exp{id = 203,act_id = 2,lv = 26,exp = 7800,reward = [{0,32010119,3}],premium_reward = [{0,32010120,2}]};

get_base_fiesta_lv_exp(203,27) ->
	#base_fiesta_lv_exp{id = 203,act_id = 2,lv = 27,exp = 8100,reward = [{0,38030005,1}],premium_reward = [{0,38030004,2}]};

get_base_fiesta_lv_exp(203,28) ->
	#base_fiesta_lv_exp{id = 203,act_id = 2,lv = 28,exp = 8400,reward = [{0,7301003,3}],premium_reward = [{0,7301004,1}]};

get_base_fiesta_lv_exp(203,29) ->
	#base_fiesta_lv_exp{id = 203,act_id = 2,lv = 29,exp = 8700,reward = [{0,38040005,30}],premium_reward = [{0,38040005,60}]};

get_base_fiesta_lv_exp(203,30) ->
	#base_fiesta_lv_exp{id = 203,act_id = 2,lv = 30,exp = 9000,reward = [{0,34010390,1}],premium_reward = [{0,6102001,1}]};

get_base_fiesta_lv_exp(203,31) ->
	#base_fiesta_lv_exp{id = 203,act_id = 2,lv = 31,exp = 9300,reward = [{0,32010119,3}],premium_reward = [{0,32010120,3}]};

get_base_fiesta_lv_exp(203,32) ->
	#base_fiesta_lv_exp{id = 203,act_id = 2,lv = 32,exp = 9600,reward = [{0,38370002,1}],premium_reward = [{0,38030004,1}]};

get_base_fiesta_lv_exp(203,33) ->
	#base_fiesta_lv_exp{id = 203,act_id = 2,lv = 33,exp = 9900,reward = [{0,38040005,50}],premium_reward = [{0,38040027,1}]};

get_base_fiesta_lv_exp(203,34) ->
	#base_fiesta_lv_exp{id = 203,act_id = 2,lv = 34,exp = 10200,reward = [{0,38100002,3}],premium_reward = [{0,38100002,6}]};

get_base_fiesta_lv_exp(203,35) ->
	#base_fiesta_lv_exp{id = 203,act_id = 2,lv = 35,exp = 10500,reward = [{0,32010002,2}],premium_reward = [{0,32010004,1}]};

get_base_fiesta_lv_exp(203,36) ->
	#base_fiesta_lv_exp{id = 203,act_id = 2,lv = 36,exp = 10800,reward = [{0,7301003,3}],premium_reward = [{0,7301004,1}]};

get_base_fiesta_lv_exp(203,37) ->
	#base_fiesta_lv_exp{id = 203,act_id = 2,lv = 37,exp = 11100,reward = [{0,32010002,1}],premium_reward = [{0,32010003,1}]};

get_base_fiesta_lv_exp(203,38) ->
	#base_fiesta_lv_exp{id = 203,act_id = 2,lv = 38,exp = 11400,reward = [{0,32010119,3}],premium_reward = [{0,32010120,3}]};

get_base_fiesta_lv_exp(203,39) ->
	#base_fiesta_lv_exp{id = 203,act_id = 2,lv = 39,exp = 11700,reward = [{0,7301003,3}],premium_reward = [{0,7301004,1}]};

get_base_fiesta_lv_exp(203,40) ->
	#base_fiesta_lv_exp{id = 203,act_id = 2,lv = 40,exp = 12000,reward = [{0,39510025,1}],premium_reward = [{0,18030115,30}]};

get_base_fiesta_lv_exp(203,41) ->
	#base_fiesta_lv_exp{id = 203,act_id = 2,lv = 41,exp = 12500,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(203,42) ->
	#base_fiesta_lv_exp{id = 203,act_id = 2,lv = 42,exp = 13000,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(203,43) ->
	#base_fiesta_lv_exp{id = 203,act_id = 2,lv = 43,exp = 13500,reward = [{0,801701,2}],premium_reward = [{0,801702,1}]};

get_base_fiesta_lv_exp(203,44) ->
	#base_fiesta_lv_exp{id = 203,act_id = 2,lv = 44,exp = 14000,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(203,45) ->
	#base_fiesta_lv_exp{id = 203,act_id = 2,lv = 45,exp = 14500,reward = [{0,801701,2}],premium_reward = [{0,801702,1}]};

get_base_fiesta_lv_exp(203,46) ->
	#base_fiesta_lv_exp{id = 203,act_id = 2,lv = 46,exp = 15000,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(203,47) ->
	#base_fiesta_lv_exp{id = 203,act_id = 2,lv = 47,exp = 15500,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(203,48) ->
	#base_fiesta_lv_exp{id = 203,act_id = 2,lv = 48,exp = 16000,reward = [{0,801701,2}],premium_reward = [{0,801702,1}]};

get_base_fiesta_lv_exp(203,49) ->
	#base_fiesta_lv_exp{id = 203,act_id = 2,lv = 49,exp = 16500,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(203,50) ->
	#base_fiesta_lv_exp{id = 203,act_id = 2,lv = 50,exp = 17000,reward = [{0,801701,2}],premium_reward = [{0,801702,1}]};

get_base_fiesta_lv_exp(203,51) ->
	#base_fiesta_lv_exp{id = 203,act_id = 2,lv = 51,exp = 17500,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(203,52) ->
	#base_fiesta_lv_exp{id = 203,act_id = 2,lv = 52,exp = 18000,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(203,53) ->
	#base_fiesta_lv_exp{id = 203,act_id = 2,lv = 53,exp = 18500,reward = [{0,801701,2}],premium_reward = [{0,801702,1}]};

get_base_fiesta_lv_exp(203,54) ->
	#base_fiesta_lv_exp{id = 203,act_id = 2,lv = 54,exp = 19000,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(203,55) ->
	#base_fiesta_lv_exp{id = 203,act_id = 2,lv = 55,exp = 19500,reward = [{0,801701,2}],premium_reward = [{0,801702,1}]};

get_base_fiesta_lv_exp(203,56) ->
	#base_fiesta_lv_exp{id = 203,act_id = 2,lv = 56,exp = 20000,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(203,57) ->
	#base_fiesta_lv_exp{id = 203,act_id = 2,lv = 57,exp = 20500,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(203,58) ->
	#base_fiesta_lv_exp{id = 203,act_id = 2,lv = 58,exp = 21000,reward = [{0,801701,2}],premium_reward = [{0,801702,1}]};

get_base_fiesta_lv_exp(203,59) ->
	#base_fiesta_lv_exp{id = 203,act_id = 2,lv = 59,exp = 21500,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(203,60) ->
	#base_fiesta_lv_exp{id = 203,act_id = 2,lv = 60,exp = 22000,reward = [{0,801701,2}],premium_reward = [{0,801702,1}]};

get_base_fiesta_lv_exp(301,1) ->
	#base_fiesta_lv_exp{id = 301,act_id = 3,lv = 1,exp = 300,reward = [{0,16020001,2}],premium_reward = [{0,16020002,1}]};

get_base_fiesta_lv_exp(301,2) ->
	#base_fiesta_lv_exp{id = 301,act_id = 3,lv = 2,exp = 600,reward = [{0,38040005,25}],premium_reward = [{0,38040005,50}]};

get_base_fiesta_lv_exp(301,3) ->
	#base_fiesta_lv_exp{id = 301,act_id = 3,lv = 3,exp = 900,reward = [{0,37020001,2}],premium_reward = [{0,37121002,1}]};

get_base_fiesta_lv_exp(301,4) ->
	#base_fiesta_lv_exp{id = 301,act_id = 3,lv = 4,exp = 1200,reward = [{0,16020001,2}],premium_reward = [{0,16020002,1}]};

get_base_fiesta_lv_exp(301,5) ->
	#base_fiesta_lv_exp{id = 301,act_id = 3,lv = 5,exp = 1500,reward = [{0,38370001,1}],premium_reward = [{0,38160001,1}]};

get_base_fiesta_lv_exp(301,6) ->
	#base_fiesta_lv_exp{id = 301,act_id = 3,lv = 6,exp = 1800,reward = [{0,32010119,2}],premium_reward = [{0,32010120,1}]};

get_base_fiesta_lv_exp(301,7) ->
	#base_fiesta_lv_exp{id = 301,act_id = 3,lv = 7,exp = 2100,reward = [{0,38030003,1}],premium_reward = [{0,38030004,2}]};

get_base_fiesta_lv_exp(301,8) ->
	#base_fiesta_lv_exp{id = 301,act_id = 3,lv = 8,exp = 2400,reward = [{0,16020001,2}],premium_reward = [{0,16020002,1}]};

get_base_fiesta_lv_exp(301,9) ->
	#base_fiesta_lv_exp{id = 301,act_id = 3,lv = 9,exp = 2700,reward = [{0,38100002,2}],premium_reward = [{0,38100002,5}]};

get_base_fiesta_lv_exp(301,10) ->
	#base_fiesta_lv_exp{id = 301,act_id = 3,lv = 10,exp = 3000,reward = [{0,39510021,1}],premium_reward = [{0,37121003,1}]};

get_base_fiesta_lv_exp(301,11) ->
	#base_fiesta_lv_exp{id = 301,act_id = 3,lv = 11,exp = 3300,reward = [{0,16020001,2}],premium_reward = [{0,16020002,1}]};

get_base_fiesta_lv_exp(301,12) ->
	#base_fiesta_lv_exp{id = 301,act_id = 3,lv = 12,exp = 3600,reward = [{0,38100002,2}],premium_reward = [{0,38100002,5}]};

get_base_fiesta_lv_exp(301,13) ->
	#base_fiesta_lv_exp{id = 301,act_id = 3,lv = 13,exp = 3900,reward = [{0,38040005,50}],premium_reward = [{0,38040027,1}]};

get_base_fiesta_lv_exp(301,14) ->
	#base_fiesta_lv_exp{id = 301,act_id = 3,lv = 14,exp = 4200,reward = [{0,32010119,2}],premium_reward = [{0,32010120,1}]};

get_base_fiesta_lv_exp(301,15) ->
	#base_fiesta_lv_exp{id = 301,act_id = 3,lv = 15,exp = 4500,reward = [{0,38160001,1}],premium_reward = [{0,37020002,1}]};

get_base_fiesta_lv_exp(301,16) ->
	#base_fiesta_lv_exp{id = 301,act_id = 3,lv = 16,exp = 4800,reward = [{0,32010001,1}],premium_reward = [{0,32010002,1}]};

get_base_fiesta_lv_exp(301,17) ->
	#base_fiesta_lv_exp{id = 301,act_id = 3,lv = 17,exp = 5100,reward = [{0,16020001,5}],premium_reward = [{0,16020002,2}]};

get_base_fiesta_lv_exp(301,18) ->
	#base_fiesta_lv_exp{id = 301,act_id = 3,lv = 18,exp = 5400,reward = [{0,38100002,3}],premium_reward = [{0,38100002,6}]};

get_base_fiesta_lv_exp(301,19) ->
	#base_fiesta_lv_exp{id = 301,act_id = 3,lv = 19,exp = 5700,reward = [{0,32010001,1}],premium_reward = [{0,32010002,1}]};

get_base_fiesta_lv_exp(301,20) ->
	#base_fiesta_lv_exp{id = 301,act_id = 3,lv = 20,exp = 6000,reward = [{0,16010003,1}],premium_reward = [{0,6101004,2}]};

get_base_fiesta_lv_exp(301,21) ->
	#base_fiesta_lv_exp{id = 301,act_id = 3,lv = 21,exp = 6300,reward = [{0,18020001,3}],premium_reward = [{0,18020002,1}]};

get_base_fiesta_lv_exp(301,22) ->
	#base_fiesta_lv_exp{id = 301,act_id = 3,lv = 22,exp = 6600,reward = [{0,38100002,3}],premium_reward = [{0,38100002,6}]};

get_base_fiesta_lv_exp(301,23) ->
	#base_fiesta_lv_exp{id = 301,act_id = 3,lv = 23,exp = 6900,reward = [{0,32010002,1}],premium_reward = [{0,32010003,1}]};

get_base_fiesta_lv_exp(301,24) ->
	#base_fiesta_lv_exp{id = 301,act_id = 3,lv = 24,exp = 7200,reward = [{0,18020001,3}],premium_reward = [{0,18020002,1}]};

get_base_fiesta_lv_exp(301,25) ->
	#base_fiesta_lv_exp{id = 301,act_id = 3,lv = 25,exp = 7500,reward = [{0,6101003,1}],premium_reward = [{0,6101004,1}]};

get_base_fiesta_lv_exp(301,26) ->
	#base_fiesta_lv_exp{id = 301,act_id = 3,lv = 26,exp = 7800,reward = [{0,32010119,3}],premium_reward = [{0,32010120,2}]};

get_base_fiesta_lv_exp(301,27) ->
	#base_fiesta_lv_exp{id = 301,act_id = 3,lv = 27,exp = 8100,reward = [{0,38030003,1}],premium_reward = [{0,38030004,2}]};

get_base_fiesta_lv_exp(301,28) ->
	#base_fiesta_lv_exp{id = 301,act_id = 3,lv = 28,exp = 8400,reward = [{0,18020001,3}],premium_reward = [{0,18020002,1}]};

get_base_fiesta_lv_exp(301,29) ->
	#base_fiesta_lv_exp{id = 301,act_id = 3,lv = 29,exp = 8700,reward = [{0,38040005,30}],premium_reward = [{0,38040005,60}]};

get_base_fiesta_lv_exp(301,30) ->
	#base_fiesta_lv_exp{id = 301,act_id = 3,lv = 30,exp = 9000,reward = [{0,34010390,1}],premium_reward = [{0,6102001,1}]};

get_base_fiesta_lv_exp(301,31) ->
	#base_fiesta_lv_exp{id = 301,act_id = 3,lv = 31,exp = 9300,reward = [{0,32010119,3}],premium_reward = [{0,32010120,3}]};

get_base_fiesta_lv_exp(301,32) ->
	#base_fiesta_lv_exp{id = 301,act_id = 3,lv = 32,exp = 9600,reward = [{0,38370003,1}],premium_reward = [{0,38030004,1}]};

get_base_fiesta_lv_exp(301,33) ->
	#base_fiesta_lv_exp{id = 301,act_id = 3,lv = 33,exp = 9900,reward = [{0,38040005,50}],premium_reward = [{0,38040027,1}]};

get_base_fiesta_lv_exp(301,34) ->
	#base_fiesta_lv_exp{id = 301,act_id = 3,lv = 34,exp = 10200,reward = [{0,38100002,3}],premium_reward = [{0,38100002,6}]};

get_base_fiesta_lv_exp(301,35) ->
	#base_fiesta_lv_exp{id = 301,act_id = 3,lv = 35,exp = 10500,reward = [{0,32010002,2}],premium_reward = [{0,32010004,1}]};

get_base_fiesta_lv_exp(301,36) ->
	#base_fiesta_lv_exp{id = 301,act_id = 3,lv = 36,exp = 10800,reward = [{0,18020001,3}],premium_reward = [{0,18020002,1}]};

get_base_fiesta_lv_exp(301,37) ->
	#base_fiesta_lv_exp{id = 301,act_id = 3,lv = 37,exp = 11100,reward = [{0,32010002,1}],premium_reward = [{0,32010003,1}]};

get_base_fiesta_lv_exp(301,38) ->
	#base_fiesta_lv_exp{id = 301,act_id = 3,lv = 38,exp = 11400,reward = [{0,32010119,3}],premium_reward = [{0,32010120,3}]};

get_base_fiesta_lv_exp(301,39) ->
	#base_fiesta_lv_exp{id = 301,act_id = 3,lv = 39,exp = 11700,reward = [{0,18020001,3}],premium_reward = [{0,18020002,1}]};

get_base_fiesta_lv_exp(301,40) ->
	#base_fiesta_lv_exp{id = 301,act_id = 3,lv = 40,exp = 12000,reward = [{0,34010391,1}],premium_reward = [{0,18030116,30}]};

get_base_fiesta_lv_exp(301,41) ->
	#base_fiesta_lv_exp{id = 301,act_id = 3,lv = 41,exp = 12500,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(301,42) ->
	#base_fiesta_lv_exp{id = 301,act_id = 3,lv = 42,exp = 13000,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(301,43) ->
	#base_fiesta_lv_exp{id = 301,act_id = 3,lv = 43,exp = 13500,reward = [{0,23020001,4}],premium_reward = [{0,38040041,5}]};

get_base_fiesta_lv_exp(301,44) ->
	#base_fiesta_lv_exp{id = 301,act_id = 3,lv = 44,exp = 14000,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(301,45) ->
	#base_fiesta_lv_exp{id = 301,act_id = 3,lv = 45,exp = 14500,reward = [{0,23020001,4}],premium_reward = [{0,38040041,5}]};

get_base_fiesta_lv_exp(301,46) ->
	#base_fiesta_lv_exp{id = 301,act_id = 3,lv = 46,exp = 15000,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(301,47) ->
	#base_fiesta_lv_exp{id = 301,act_id = 3,lv = 47,exp = 15500,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(301,48) ->
	#base_fiesta_lv_exp{id = 301,act_id = 3,lv = 48,exp = 16000,reward = [{0,23020001,4}],premium_reward = [{0,38040041,5}]};

get_base_fiesta_lv_exp(301,49) ->
	#base_fiesta_lv_exp{id = 301,act_id = 3,lv = 49,exp = 16500,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(301,50) ->
	#base_fiesta_lv_exp{id = 301,act_id = 3,lv = 50,exp = 17000,reward = [{0,23020001,4}],premium_reward = [{0,38040041,5}]};

get_base_fiesta_lv_exp(301,51) ->
	#base_fiesta_lv_exp{id = 301,act_id = 3,lv = 51,exp = 17500,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(301,52) ->
	#base_fiesta_lv_exp{id = 301,act_id = 3,lv = 52,exp = 18000,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(301,53) ->
	#base_fiesta_lv_exp{id = 301,act_id = 3,lv = 53,exp = 18500,reward = [{0,23020001,4}],premium_reward = [{0,38040041,5}]};

get_base_fiesta_lv_exp(301,54) ->
	#base_fiesta_lv_exp{id = 301,act_id = 3,lv = 54,exp = 19000,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(301,55) ->
	#base_fiesta_lv_exp{id = 301,act_id = 3,lv = 55,exp = 19500,reward = [{0,23020001,4}],premium_reward = [{0,38040041,5}]};

get_base_fiesta_lv_exp(301,56) ->
	#base_fiesta_lv_exp{id = 301,act_id = 3,lv = 56,exp = 20000,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(301,57) ->
	#base_fiesta_lv_exp{id = 301,act_id = 3,lv = 57,exp = 20500,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(301,58) ->
	#base_fiesta_lv_exp{id = 301,act_id = 3,lv = 58,exp = 21000,reward = [{0,23020001,4}],premium_reward = [{0,38040041,5}]};

get_base_fiesta_lv_exp(301,59) ->
	#base_fiesta_lv_exp{id = 301,act_id = 3,lv = 59,exp = 21500,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(301,60) ->
	#base_fiesta_lv_exp{id = 301,act_id = 3,lv = 60,exp = 22000,reward = [{0,23020001,4}],premium_reward = [{0,38040041,5}]};

get_base_fiesta_lv_exp(302,1) ->
	#base_fiesta_lv_exp{id = 302,act_id = 3,lv = 1,exp = 300,reward = [{0,19020001,2}],premium_reward = [{0,19020002,1}]};

get_base_fiesta_lv_exp(302,2) ->
	#base_fiesta_lv_exp{id = 302,act_id = 3,lv = 2,exp = 600,reward = [{0,38040005,25}],premium_reward = [{0,38040005,50}]};

get_base_fiesta_lv_exp(302,3) ->
	#base_fiesta_lv_exp{id = 302,act_id = 3,lv = 3,exp = 900,reward = [{0,37020001,2}],premium_reward = [{0,37121002,1}]};

get_base_fiesta_lv_exp(302,4) ->
	#base_fiesta_lv_exp{id = 302,act_id = 3,lv = 4,exp = 1200,reward = [{0,19020001,2}],premium_reward = [{0,19020002,1}]};

get_base_fiesta_lv_exp(302,5) ->
	#base_fiesta_lv_exp{id = 302,act_id = 3,lv = 5,exp = 1500,reward = [{0,38370001,1}],premium_reward = [{0,38160001,1}]};

get_base_fiesta_lv_exp(302,6) ->
	#base_fiesta_lv_exp{id = 302,act_id = 3,lv = 6,exp = 1800,reward = [{0,32010119,2}],premium_reward = [{0,32010120,1}]};

get_base_fiesta_lv_exp(302,7) ->
	#base_fiesta_lv_exp{id = 302,act_id = 3,lv = 7,exp = 2100,reward = [{0,38030005,1}],premium_reward = [{0,38030004,2}]};

get_base_fiesta_lv_exp(302,8) ->
	#base_fiesta_lv_exp{id = 302,act_id = 3,lv = 8,exp = 2400,reward = [{0,19020001,2}],premium_reward = [{0,19020002,1}]};

get_base_fiesta_lv_exp(302,9) ->
	#base_fiesta_lv_exp{id = 302,act_id = 3,lv = 9,exp = 2700,reward = [{0,38100002,2}],premium_reward = [{0,38100002,5}]};

get_base_fiesta_lv_exp(302,10) ->
	#base_fiesta_lv_exp{id = 302,act_id = 3,lv = 10,exp = 3000,reward = [{0,39510021,1}],premium_reward = [{0,37121003,1}]};

get_base_fiesta_lv_exp(302,11) ->
	#base_fiesta_lv_exp{id = 302,act_id = 3,lv = 11,exp = 3300,reward = [{0,19020001,2}],premium_reward = [{0,19020002,1}]};

get_base_fiesta_lv_exp(302,12) ->
	#base_fiesta_lv_exp{id = 302,act_id = 3,lv = 12,exp = 3600,reward = [{0,38100002,2}],premium_reward = [{0,38100002,5}]};

get_base_fiesta_lv_exp(302,13) ->
	#base_fiesta_lv_exp{id = 302,act_id = 3,lv = 13,exp = 3900,reward = [{0,38040005,50}],premium_reward = [{0,38040027,1}]};

get_base_fiesta_lv_exp(302,14) ->
	#base_fiesta_lv_exp{id = 302,act_id = 3,lv = 14,exp = 4200,reward = [{0,32010119,2}],premium_reward = [{0,32010120,1}]};

get_base_fiesta_lv_exp(302,15) ->
	#base_fiesta_lv_exp{id = 302,act_id = 3,lv = 15,exp = 4500,reward = [{0,38160001,1}],premium_reward = [{0,37020002,1}]};

get_base_fiesta_lv_exp(302,16) ->
	#base_fiesta_lv_exp{id = 302,act_id = 3,lv = 16,exp = 4800,reward = [{0,32010001,1}],premium_reward = [{0,32010002,1}]};

get_base_fiesta_lv_exp(302,17) ->
	#base_fiesta_lv_exp{id = 302,act_id = 3,lv = 17,exp = 5100,reward = [{0,19020001,5}],premium_reward = [{0,19020002,1}]};

get_base_fiesta_lv_exp(302,18) ->
	#base_fiesta_lv_exp{id = 302,act_id = 3,lv = 18,exp = 5400,reward = [{0,38100002,3}],premium_reward = [{0,38100002,6}]};

get_base_fiesta_lv_exp(302,19) ->
	#base_fiesta_lv_exp{id = 302,act_id = 3,lv = 19,exp = 5700,reward = [{0,32010001,1}],premium_reward = [{0,32010002,1}]};

get_base_fiesta_lv_exp(302,20) ->
	#base_fiesta_lv_exp{id = 302,act_id = 3,lv = 20,exp = 6000,reward = [{0,18010003,1}],premium_reward = [{0,6101004,2}]};

get_base_fiesta_lv_exp(302,21) ->
	#base_fiesta_lv_exp{id = 302,act_id = 3,lv = 21,exp = 6300,reward = [{0,20020001,3}],premium_reward = [{0,20020002,1}]};

get_base_fiesta_lv_exp(302,22) ->
	#base_fiesta_lv_exp{id = 302,act_id = 3,lv = 22,exp = 6600,reward = [{0,38100002,3}],premium_reward = [{0,38100002,6}]};

get_base_fiesta_lv_exp(302,23) ->
	#base_fiesta_lv_exp{id = 302,act_id = 3,lv = 23,exp = 6900,reward = [{0,32010002,1}],premium_reward = [{0,32010003,1}]};

get_base_fiesta_lv_exp(302,24) ->
	#base_fiesta_lv_exp{id = 302,act_id = 3,lv = 24,exp = 7200,reward = [{0,20020001,3}],premium_reward = [{0,20020002,1}]};

get_base_fiesta_lv_exp(302,25) ->
	#base_fiesta_lv_exp{id = 302,act_id = 3,lv = 25,exp = 7500,reward = [{0,6101003,1}],premium_reward = [{0,6101004,1}]};

get_base_fiesta_lv_exp(302,26) ->
	#base_fiesta_lv_exp{id = 302,act_id = 3,lv = 26,exp = 7800,reward = [{0,32010119,3}],premium_reward = [{0,32010120,2}]};

get_base_fiesta_lv_exp(302,27) ->
	#base_fiesta_lv_exp{id = 302,act_id = 3,lv = 27,exp = 8100,reward = [{0,38030005,1}],premium_reward = [{0,38030004,2}]};

get_base_fiesta_lv_exp(302,28) ->
	#base_fiesta_lv_exp{id = 302,act_id = 3,lv = 28,exp = 8400,reward = [{0,20020001,3}],premium_reward = [{0,20020002,1}]};

get_base_fiesta_lv_exp(302,29) ->
	#base_fiesta_lv_exp{id = 302,act_id = 3,lv = 29,exp = 8700,reward = [{0,38040005,30}],premium_reward = [{0,38040005,60}]};

get_base_fiesta_lv_exp(302,30) ->
	#base_fiesta_lv_exp{id = 302,act_id = 3,lv = 30,exp = 9000,reward = [{0,34010390,1}],premium_reward = [{0,6102001,1}]};

get_base_fiesta_lv_exp(302,31) ->
	#base_fiesta_lv_exp{id = 302,act_id = 3,lv = 31,exp = 9300,reward = [{0,32010119,3}],premium_reward = [{0,32010120,3}]};

get_base_fiesta_lv_exp(302,32) ->
	#base_fiesta_lv_exp{id = 302,act_id = 3,lv = 32,exp = 9600,reward = [{0,38370002,1}],premium_reward = [{0,38030004,1}]};

get_base_fiesta_lv_exp(302,33) ->
	#base_fiesta_lv_exp{id = 302,act_id = 3,lv = 33,exp = 9900,reward = [{0,38040005,50}],premium_reward = [{0,38040027,1}]};

get_base_fiesta_lv_exp(302,34) ->
	#base_fiesta_lv_exp{id = 302,act_id = 3,lv = 34,exp = 10200,reward = [{0,38100002,3}],premium_reward = [{0,38100002,6}]};

get_base_fiesta_lv_exp(302,35) ->
	#base_fiesta_lv_exp{id = 302,act_id = 3,lv = 35,exp = 10500,reward = [{0,32010002,2}],premium_reward = [{0,32010004,1}]};

get_base_fiesta_lv_exp(302,36) ->
	#base_fiesta_lv_exp{id = 302,act_id = 3,lv = 36,exp = 10800,reward = [{0,20020001,3}],premium_reward = [{0,20020002,1}]};

get_base_fiesta_lv_exp(302,37) ->
	#base_fiesta_lv_exp{id = 302,act_id = 3,lv = 37,exp = 11100,reward = [{0,32010002,1}],premium_reward = [{0,32010003,1}]};

get_base_fiesta_lv_exp(302,38) ->
	#base_fiesta_lv_exp{id = 302,act_id = 3,lv = 38,exp = 11400,reward = [{0,32010119,3}],premium_reward = [{0,32010120,3}]};

get_base_fiesta_lv_exp(302,39) ->
	#base_fiesta_lv_exp{id = 302,act_id = 3,lv = 39,exp = 11700,reward = [{0,20020001,3}],premium_reward = [{0,20020002,1}]};

get_base_fiesta_lv_exp(302,40) ->
	#base_fiesta_lv_exp{id = 302,act_id = 3,lv = 40,exp = 12000,reward = [{0,32010141,1}],premium_reward = [{0,18030116,30}]};

get_base_fiesta_lv_exp(302,41) ->
	#base_fiesta_lv_exp{id = 302,act_id = 3,lv = 41,exp = 12500,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(302,42) ->
	#base_fiesta_lv_exp{id = 302,act_id = 3,lv = 42,exp = 13000,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(302,43) ->
	#base_fiesta_lv_exp{id = 302,act_id = 3,lv = 43,exp = 13500,reward = [{0,39510000,4}],premium_reward = [{0,39510000,10}]};

get_base_fiesta_lv_exp(302,44) ->
	#base_fiesta_lv_exp{id = 302,act_id = 3,lv = 44,exp = 14000,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(302,45) ->
	#base_fiesta_lv_exp{id = 302,act_id = 3,lv = 45,exp = 14500,reward = [{0,38040018,4}],premium_reward = [{0,38040018,10}]};

get_base_fiesta_lv_exp(302,46) ->
	#base_fiesta_lv_exp{id = 302,act_id = 3,lv = 46,exp = 15000,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(302,47) ->
	#base_fiesta_lv_exp{id = 302,act_id = 3,lv = 47,exp = 15500,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(302,48) ->
	#base_fiesta_lv_exp{id = 302,act_id = 3,lv = 48,exp = 16000,reward = [{0,39510000,4}],premium_reward = [{0,39510000,10}]};

get_base_fiesta_lv_exp(302,49) ->
	#base_fiesta_lv_exp{id = 302,act_id = 3,lv = 49,exp = 16500,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(302,50) ->
	#base_fiesta_lv_exp{id = 302,act_id = 3,lv = 50,exp = 17000,reward = [{0,38040018,4}],premium_reward = [{0,38040018,10}]};

get_base_fiesta_lv_exp(302,51) ->
	#base_fiesta_lv_exp{id = 302,act_id = 3,lv = 51,exp = 17500,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(302,52) ->
	#base_fiesta_lv_exp{id = 302,act_id = 3,lv = 52,exp = 18000,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(302,53) ->
	#base_fiesta_lv_exp{id = 302,act_id = 3,lv = 53,exp = 18500,reward = [{0,39510000,4}],premium_reward = [{0,39510000,10}]};

get_base_fiesta_lv_exp(302,54) ->
	#base_fiesta_lv_exp{id = 302,act_id = 3,lv = 54,exp = 19000,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(302,55) ->
	#base_fiesta_lv_exp{id = 302,act_id = 3,lv = 55,exp = 19500,reward = [{0,38040018,4}],premium_reward = [{0,38040018,10}]};

get_base_fiesta_lv_exp(302,56) ->
	#base_fiesta_lv_exp{id = 302,act_id = 3,lv = 56,exp = 20000,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(302,57) ->
	#base_fiesta_lv_exp{id = 302,act_id = 3,lv = 57,exp = 20500,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(302,58) ->
	#base_fiesta_lv_exp{id = 302,act_id = 3,lv = 58,exp = 21000,reward = [{0,39510000,4}],premium_reward = [{0,39510000,10}]};

get_base_fiesta_lv_exp(302,59) ->
	#base_fiesta_lv_exp{id = 302,act_id = 3,lv = 59,exp = 21500,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(302,60) ->
	#base_fiesta_lv_exp{id = 302,act_id = 3,lv = 60,exp = 22000,reward = [{0,38040018,4}],premium_reward = [{0,38040018,10}]};

get_base_fiesta_lv_exp(303,1) ->
	#base_fiesta_lv_exp{id = 303,act_id = 3,lv = 1,exp = 300,reward = [{0,7301001,2}],premium_reward = [{0,7301002,1}]};

get_base_fiesta_lv_exp(303,2) ->
	#base_fiesta_lv_exp{id = 303,act_id = 3,lv = 2,exp = 600,reward = [{0,38040005,25}],premium_reward = [{0,38040005,50}]};

get_base_fiesta_lv_exp(303,3) ->
	#base_fiesta_lv_exp{id = 303,act_id = 3,lv = 3,exp = 900,reward = [{0,37020001,2}],premium_reward = [{0,37121002,1}]};

get_base_fiesta_lv_exp(303,4) ->
	#base_fiesta_lv_exp{id = 303,act_id = 3,lv = 4,exp = 1200,reward = [{0,7301001,2}],premium_reward = [{0,7301002,1}]};

get_base_fiesta_lv_exp(303,5) ->
	#base_fiesta_lv_exp{id = 303,act_id = 3,lv = 5,exp = 1500,reward = [{0,38370001,1}],premium_reward = [{0,38160001,1}]};

get_base_fiesta_lv_exp(303,6) ->
	#base_fiesta_lv_exp{id = 303,act_id = 3,lv = 6,exp = 1800,reward = [{0,32010119,2}],premium_reward = [{0,32010120,1}]};

get_base_fiesta_lv_exp(303,7) ->
	#base_fiesta_lv_exp{id = 303,act_id = 3,lv = 7,exp = 2100,reward = [{0,38030005,1}],premium_reward = [{0,38030004,2}]};

get_base_fiesta_lv_exp(303,8) ->
	#base_fiesta_lv_exp{id = 303,act_id = 3,lv = 8,exp = 2400,reward = [{0,7301001,2}],premium_reward = [{0,7301002,1}]};

get_base_fiesta_lv_exp(303,9) ->
	#base_fiesta_lv_exp{id = 303,act_id = 3,lv = 9,exp = 2700,reward = [{0,38100002,2}],premium_reward = [{0,38100002,5}]};

get_base_fiesta_lv_exp(303,10) ->
	#base_fiesta_lv_exp{id = 303,act_id = 3,lv = 10,exp = 3000,reward = [{0,39510021,1}],premium_reward = [{0,37121003,1}]};

get_base_fiesta_lv_exp(303,11) ->
	#base_fiesta_lv_exp{id = 303,act_id = 3,lv = 11,exp = 3300,reward = [{0,7301001,2}],premium_reward = [{0,7301002,1}]};

get_base_fiesta_lv_exp(303,12) ->
	#base_fiesta_lv_exp{id = 303,act_id = 3,lv = 12,exp = 3600,reward = [{0,38100002,2}],premium_reward = [{0,38100002,5}]};

get_base_fiesta_lv_exp(303,13) ->
	#base_fiesta_lv_exp{id = 303,act_id = 3,lv = 13,exp = 3900,reward = [{0,38040005,50}],premium_reward = [{0,38040027,1}]};

get_base_fiesta_lv_exp(303,14) ->
	#base_fiesta_lv_exp{id = 303,act_id = 3,lv = 14,exp = 4200,reward = [{0,32010119,2}],premium_reward = [{0,32010120,1}]};

get_base_fiesta_lv_exp(303,15) ->
	#base_fiesta_lv_exp{id = 303,act_id = 3,lv = 15,exp = 4500,reward = [{0,38160001,1}],premium_reward = [{0,37020002,1}]};

get_base_fiesta_lv_exp(303,16) ->
	#base_fiesta_lv_exp{id = 303,act_id = 3,lv = 16,exp = 4800,reward = [{0,32010001,1}],premium_reward = [{0,32010002,1}]};

get_base_fiesta_lv_exp(303,17) ->
	#base_fiesta_lv_exp{id = 303,act_id = 3,lv = 17,exp = 5100,reward = [{0,7301001,5}],premium_reward = [{0,7301002,1}]};

get_base_fiesta_lv_exp(303,18) ->
	#base_fiesta_lv_exp{id = 303,act_id = 3,lv = 18,exp = 5400,reward = [{0,38100002,3}],premium_reward = [{0,38100002,6}]};

get_base_fiesta_lv_exp(303,19) ->
	#base_fiesta_lv_exp{id = 303,act_id = 3,lv = 19,exp = 5700,reward = [{0,32010001,1}],premium_reward = [{0,32010002,1}]};

get_base_fiesta_lv_exp(303,20) ->
	#base_fiesta_lv_exp{id = 303,act_id = 3,lv = 20,exp = 6000,reward = [{0,20010003,1}],premium_reward = [{0,6101004,2}]};

get_base_fiesta_lv_exp(303,21) ->
	#base_fiesta_lv_exp{id = 303,act_id = 3,lv = 21,exp = 6300,reward = [{0,7301003,3}],premium_reward = [{0,7301004,1}]};

get_base_fiesta_lv_exp(303,22) ->
	#base_fiesta_lv_exp{id = 303,act_id = 3,lv = 22,exp = 6600,reward = [{0,38100002,3}],premium_reward = [{0,38100002,6}]};

get_base_fiesta_lv_exp(303,23) ->
	#base_fiesta_lv_exp{id = 303,act_id = 3,lv = 23,exp = 6900,reward = [{0,32010002,1}],premium_reward = [{0,32010003,1}]};

get_base_fiesta_lv_exp(303,24) ->
	#base_fiesta_lv_exp{id = 303,act_id = 3,lv = 24,exp = 7200,reward = [{0,7301003,3}],premium_reward = [{0,7301004,1}]};

get_base_fiesta_lv_exp(303,25) ->
	#base_fiesta_lv_exp{id = 303,act_id = 3,lv = 25,exp = 7500,reward = [{0,6101003,1}],premium_reward = [{0,6101004,1}]};

get_base_fiesta_lv_exp(303,26) ->
	#base_fiesta_lv_exp{id = 303,act_id = 3,lv = 26,exp = 7800,reward = [{0,32010119,3}],premium_reward = [{0,32010120,2}]};

get_base_fiesta_lv_exp(303,27) ->
	#base_fiesta_lv_exp{id = 303,act_id = 3,lv = 27,exp = 8100,reward = [{0,38030005,1}],premium_reward = [{0,38030004,2}]};

get_base_fiesta_lv_exp(303,28) ->
	#base_fiesta_lv_exp{id = 303,act_id = 3,lv = 28,exp = 8400,reward = [{0,7301003,3}],premium_reward = [{0,7301004,1}]};

get_base_fiesta_lv_exp(303,29) ->
	#base_fiesta_lv_exp{id = 303,act_id = 3,lv = 29,exp = 8700,reward = [{0,38040005,30}],premium_reward = [{0,38040005,60}]};

get_base_fiesta_lv_exp(303,30) ->
	#base_fiesta_lv_exp{id = 303,act_id = 3,lv = 30,exp = 9000,reward = [{0,34010390,1}],premium_reward = [{0,6102001,1}]};

get_base_fiesta_lv_exp(303,31) ->
	#base_fiesta_lv_exp{id = 303,act_id = 3,lv = 31,exp = 9300,reward = [{0,32010119,3}],premium_reward = [{0,32010120,3}]};

get_base_fiesta_lv_exp(303,32) ->
	#base_fiesta_lv_exp{id = 303,act_id = 3,lv = 32,exp = 9600,reward = [{0,38370002,1}],premium_reward = [{0,38030004,1}]};

get_base_fiesta_lv_exp(303,33) ->
	#base_fiesta_lv_exp{id = 303,act_id = 3,lv = 33,exp = 9900,reward = [{0,38040005,50}],premium_reward = [{0,38040027,1}]};

get_base_fiesta_lv_exp(303,34) ->
	#base_fiesta_lv_exp{id = 303,act_id = 3,lv = 34,exp = 10200,reward = [{0,38100002,3}],premium_reward = [{0,38100002,6}]};

get_base_fiesta_lv_exp(303,35) ->
	#base_fiesta_lv_exp{id = 303,act_id = 3,lv = 35,exp = 10500,reward = [{0,32010002,2}],premium_reward = [{0,32010004,1}]};

get_base_fiesta_lv_exp(303,36) ->
	#base_fiesta_lv_exp{id = 303,act_id = 3,lv = 36,exp = 10800,reward = [{0,7301003,3}],premium_reward = [{0,7301004,1}]};

get_base_fiesta_lv_exp(303,37) ->
	#base_fiesta_lv_exp{id = 303,act_id = 3,lv = 37,exp = 11100,reward = [{0,32010002,1}],premium_reward = [{0,32010003,1}]};

get_base_fiesta_lv_exp(303,38) ->
	#base_fiesta_lv_exp{id = 303,act_id = 3,lv = 38,exp = 11400,reward = [{0,32010119,3}],premium_reward = [{0,32010120,3}]};

get_base_fiesta_lv_exp(303,39) ->
	#base_fiesta_lv_exp{id = 303,act_id = 3,lv = 39,exp = 11700,reward = [{0,7301003,3}],premium_reward = [{0,7301004,1}]};

get_base_fiesta_lv_exp(303,40) ->
	#base_fiesta_lv_exp{id = 303,act_id = 3,lv = 40,exp = 12000,reward = [{0,39510025,1}],premium_reward = [{0,18030116,30}]};

get_base_fiesta_lv_exp(303,41) ->
	#base_fiesta_lv_exp{id = 303,act_id = 3,lv = 41,exp = 12500,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(303,42) ->
	#base_fiesta_lv_exp{id = 303,act_id = 3,lv = 42,exp = 13000,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(303,43) ->
	#base_fiesta_lv_exp{id = 303,act_id = 3,lv = 43,exp = 13500,reward = [{0,801701,2}],premium_reward = [{0,801702,1}]};

get_base_fiesta_lv_exp(303,44) ->
	#base_fiesta_lv_exp{id = 303,act_id = 3,lv = 44,exp = 14000,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(303,45) ->
	#base_fiesta_lv_exp{id = 303,act_id = 3,lv = 45,exp = 14500,reward = [{0,801701,2}],premium_reward = [{0,801702,1}]};

get_base_fiesta_lv_exp(303,46) ->
	#base_fiesta_lv_exp{id = 303,act_id = 3,lv = 46,exp = 15000,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(303,47) ->
	#base_fiesta_lv_exp{id = 303,act_id = 3,lv = 47,exp = 15500,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(303,48) ->
	#base_fiesta_lv_exp{id = 303,act_id = 3,lv = 48,exp = 16000,reward = [{0,801701,2}],premium_reward = [{0,801702,1}]};

get_base_fiesta_lv_exp(303,49) ->
	#base_fiesta_lv_exp{id = 303,act_id = 3,lv = 49,exp = 16500,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(303,50) ->
	#base_fiesta_lv_exp{id = 303,act_id = 3,lv = 50,exp = 17000,reward = [{0,801701,2}],premium_reward = [{0,801702,1}]};

get_base_fiesta_lv_exp(303,51) ->
	#base_fiesta_lv_exp{id = 303,act_id = 3,lv = 51,exp = 17500,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(303,52) ->
	#base_fiesta_lv_exp{id = 303,act_id = 3,lv = 52,exp = 18000,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(303,53) ->
	#base_fiesta_lv_exp{id = 303,act_id = 3,lv = 53,exp = 18500,reward = [{0,801701,2}],premium_reward = [{0,801702,1}]};

get_base_fiesta_lv_exp(303,54) ->
	#base_fiesta_lv_exp{id = 303,act_id = 3,lv = 54,exp = 19000,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(303,55) ->
	#base_fiesta_lv_exp{id = 303,act_id = 3,lv = 55,exp = 19500,reward = [{0,801701,2}],premium_reward = [{0,801702,1}]};

get_base_fiesta_lv_exp(303,56) ->
	#base_fiesta_lv_exp{id = 303,act_id = 3,lv = 56,exp = 20000,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(303,57) ->
	#base_fiesta_lv_exp{id = 303,act_id = 3,lv = 57,exp = 20500,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(303,58) ->
	#base_fiesta_lv_exp{id = 303,act_id = 3,lv = 58,exp = 21000,reward = [{0,801701,2}],premium_reward = [{0,801702,1}]};

get_base_fiesta_lv_exp(303,59) ->
	#base_fiesta_lv_exp{id = 303,act_id = 3,lv = 59,exp = 21500,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(303,60) ->
	#base_fiesta_lv_exp{id = 303,act_id = 3,lv = 60,exp = 22000,reward = [{0,801701,2}],premium_reward = [{0,801702,1}]};

get_base_fiesta_lv_exp(401,1) ->
	#base_fiesta_lv_exp{id = 401,act_id = 4,lv = 1,exp = 300,reward = [{0,16020001,2}],premium_reward = [{0,16020002,1}]};

get_base_fiesta_lv_exp(401,2) ->
	#base_fiesta_lv_exp{id = 401,act_id = 4,lv = 2,exp = 600,reward = [{0,38040005,25}],premium_reward = [{0,38040005,50}]};

get_base_fiesta_lv_exp(401,3) ->
	#base_fiesta_lv_exp{id = 401,act_id = 4,lv = 3,exp = 900,reward = [{0,37020001,2}],premium_reward = [{0,37121002,1}]};

get_base_fiesta_lv_exp(401,4) ->
	#base_fiesta_lv_exp{id = 401,act_id = 4,lv = 4,exp = 1200,reward = [{0,16020001,2}],premium_reward = [{0,16020002,1}]};

get_base_fiesta_lv_exp(401,5) ->
	#base_fiesta_lv_exp{id = 401,act_id = 4,lv = 5,exp = 1500,reward = [{0,38370001,1}],premium_reward = [{0,38160001,1}]};

get_base_fiesta_lv_exp(401,6) ->
	#base_fiesta_lv_exp{id = 401,act_id = 4,lv = 6,exp = 1800,reward = [{0,32010119,2}],premium_reward = [{0,32010120,1}]};

get_base_fiesta_lv_exp(401,7) ->
	#base_fiesta_lv_exp{id = 401,act_id = 4,lv = 7,exp = 2100,reward = [{0,38030003,1}],premium_reward = [{0,38030004,2}]};

get_base_fiesta_lv_exp(401,8) ->
	#base_fiesta_lv_exp{id = 401,act_id = 4,lv = 8,exp = 2400,reward = [{0,16020001,2}],premium_reward = [{0,16020002,1}]};

get_base_fiesta_lv_exp(401,9) ->
	#base_fiesta_lv_exp{id = 401,act_id = 4,lv = 9,exp = 2700,reward = [{0,38100002,2}],premium_reward = [{0,38100002,5}]};

get_base_fiesta_lv_exp(401,10) ->
	#base_fiesta_lv_exp{id = 401,act_id = 4,lv = 10,exp = 3000,reward = [{0,39510021,1}],premium_reward = [{0,37121003,1}]};

get_base_fiesta_lv_exp(401,11) ->
	#base_fiesta_lv_exp{id = 401,act_id = 4,lv = 11,exp = 3300,reward = [{0,16020001,2}],premium_reward = [{0,16020002,1}]};

get_base_fiesta_lv_exp(401,12) ->
	#base_fiesta_lv_exp{id = 401,act_id = 4,lv = 12,exp = 3600,reward = [{0,38100002,2}],premium_reward = [{0,38100002,5}]};

get_base_fiesta_lv_exp(401,13) ->
	#base_fiesta_lv_exp{id = 401,act_id = 4,lv = 13,exp = 3900,reward = [{0,38040005,50}],premium_reward = [{0,38040027,1}]};

get_base_fiesta_lv_exp(401,14) ->
	#base_fiesta_lv_exp{id = 401,act_id = 4,lv = 14,exp = 4200,reward = [{0,32010119,2}],premium_reward = [{0,32010120,1}]};

get_base_fiesta_lv_exp(401,15) ->
	#base_fiesta_lv_exp{id = 401,act_id = 4,lv = 15,exp = 4500,reward = [{0,38160001,1}],premium_reward = [{0,37020002,1}]};

get_base_fiesta_lv_exp(401,16) ->
	#base_fiesta_lv_exp{id = 401,act_id = 4,lv = 16,exp = 4800,reward = [{0,32010001,1}],premium_reward = [{0,32010002,1}]};

get_base_fiesta_lv_exp(401,17) ->
	#base_fiesta_lv_exp{id = 401,act_id = 4,lv = 17,exp = 5100,reward = [{0,16020001,5}],premium_reward = [{0,16020002,2}]};

get_base_fiesta_lv_exp(401,18) ->
	#base_fiesta_lv_exp{id = 401,act_id = 4,lv = 18,exp = 5400,reward = [{0,38100002,3}],premium_reward = [{0,38100002,6}]};

get_base_fiesta_lv_exp(401,19) ->
	#base_fiesta_lv_exp{id = 401,act_id = 4,lv = 19,exp = 5700,reward = [{0,32010001,1}],premium_reward = [{0,32010002,1}]};

get_base_fiesta_lv_exp(401,20) ->
	#base_fiesta_lv_exp{id = 401,act_id = 4,lv = 20,exp = 6000,reward = [{0,16010003,1}],premium_reward = [{0,6101004,2}]};

get_base_fiesta_lv_exp(401,21) ->
	#base_fiesta_lv_exp{id = 401,act_id = 4,lv = 21,exp = 6300,reward = [{0,18020001,3}],premium_reward = [{0,18020002,1}]};

get_base_fiesta_lv_exp(401,22) ->
	#base_fiesta_lv_exp{id = 401,act_id = 4,lv = 22,exp = 6600,reward = [{0,38100002,3}],premium_reward = [{0,38100002,6}]};

get_base_fiesta_lv_exp(401,23) ->
	#base_fiesta_lv_exp{id = 401,act_id = 4,lv = 23,exp = 6900,reward = [{0,32010002,1}],premium_reward = [{0,32010003,1}]};

get_base_fiesta_lv_exp(401,24) ->
	#base_fiesta_lv_exp{id = 401,act_id = 4,lv = 24,exp = 7200,reward = [{0,18020001,3}],premium_reward = [{0,18020002,1}]};

get_base_fiesta_lv_exp(401,25) ->
	#base_fiesta_lv_exp{id = 401,act_id = 4,lv = 25,exp = 7500,reward = [{0,6101003,1}],premium_reward = [{0,6101004,1}]};

get_base_fiesta_lv_exp(401,26) ->
	#base_fiesta_lv_exp{id = 401,act_id = 4,lv = 26,exp = 7800,reward = [{0,32010119,3}],premium_reward = [{0,32010120,2}]};

get_base_fiesta_lv_exp(401,27) ->
	#base_fiesta_lv_exp{id = 401,act_id = 4,lv = 27,exp = 8100,reward = [{0,38030003,1}],premium_reward = [{0,38030004,2}]};

get_base_fiesta_lv_exp(401,28) ->
	#base_fiesta_lv_exp{id = 401,act_id = 4,lv = 28,exp = 8400,reward = [{0,18020001,3}],premium_reward = [{0,18020002,1}]};

get_base_fiesta_lv_exp(401,29) ->
	#base_fiesta_lv_exp{id = 401,act_id = 4,lv = 29,exp = 8700,reward = [{0,38040005,30}],premium_reward = [{0,38040005,60}]};

get_base_fiesta_lv_exp(401,30) ->
	#base_fiesta_lv_exp{id = 401,act_id = 4,lv = 30,exp = 9000,reward = [{0,34010390,1}],premium_reward = [{0,6102001,1}]};

get_base_fiesta_lv_exp(401,31) ->
	#base_fiesta_lv_exp{id = 401,act_id = 4,lv = 31,exp = 9300,reward = [{0,32010119,3}],premium_reward = [{0,32010120,3}]};

get_base_fiesta_lv_exp(401,32) ->
	#base_fiesta_lv_exp{id = 401,act_id = 4,lv = 32,exp = 9600,reward = [{0,38370003,1}],premium_reward = [{0,38030004,1}]};

get_base_fiesta_lv_exp(401,33) ->
	#base_fiesta_lv_exp{id = 401,act_id = 4,lv = 33,exp = 9900,reward = [{0,38040005,50}],premium_reward = [{0,38040027,1}]};

get_base_fiesta_lv_exp(401,34) ->
	#base_fiesta_lv_exp{id = 401,act_id = 4,lv = 34,exp = 10200,reward = [{0,38100002,3}],premium_reward = [{0,38100002,6}]};

get_base_fiesta_lv_exp(401,35) ->
	#base_fiesta_lv_exp{id = 401,act_id = 4,lv = 35,exp = 10500,reward = [{0,32010002,2}],premium_reward = [{0,32010004,1}]};

get_base_fiesta_lv_exp(401,36) ->
	#base_fiesta_lv_exp{id = 401,act_id = 4,lv = 36,exp = 10800,reward = [{0,18020001,3}],premium_reward = [{0,18020002,1}]};

get_base_fiesta_lv_exp(401,37) ->
	#base_fiesta_lv_exp{id = 401,act_id = 4,lv = 37,exp = 11100,reward = [{0,32010002,1}],premium_reward = [{0,32010003,1}]};

get_base_fiesta_lv_exp(401,38) ->
	#base_fiesta_lv_exp{id = 401,act_id = 4,lv = 38,exp = 11400,reward = [{0,32010119,3}],premium_reward = [{0,32010120,3}]};

get_base_fiesta_lv_exp(401,39) ->
	#base_fiesta_lv_exp{id = 401,act_id = 4,lv = 39,exp = 11700,reward = [{0,18020001,3}],premium_reward = [{0,18020002,1}]};

get_base_fiesta_lv_exp(401,40) ->
	#base_fiesta_lv_exp{id = 401,act_id = 4,lv = 40,exp = 12000,reward = [{0,34010391,1}],premium_reward = [{0,18030114,30}]};

get_base_fiesta_lv_exp(401,41) ->
	#base_fiesta_lv_exp{id = 401,act_id = 4,lv = 41,exp = 12500,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(401,42) ->
	#base_fiesta_lv_exp{id = 401,act_id = 4,lv = 42,exp = 13000,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(401,43) ->
	#base_fiesta_lv_exp{id = 401,act_id = 4,lv = 43,exp = 13500,reward = [{0,23020001,4}],premium_reward = [{0,38040041,5}]};

get_base_fiesta_lv_exp(401,44) ->
	#base_fiesta_lv_exp{id = 401,act_id = 4,lv = 44,exp = 14000,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(401,45) ->
	#base_fiesta_lv_exp{id = 401,act_id = 4,lv = 45,exp = 14500,reward = [{0,23020001,4}],premium_reward = [{0,38040041,5}]};

get_base_fiesta_lv_exp(401,46) ->
	#base_fiesta_lv_exp{id = 401,act_id = 4,lv = 46,exp = 15000,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(401,47) ->
	#base_fiesta_lv_exp{id = 401,act_id = 4,lv = 47,exp = 15500,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(401,48) ->
	#base_fiesta_lv_exp{id = 401,act_id = 4,lv = 48,exp = 16000,reward = [{0,23020001,4}],premium_reward = [{0,38040041,5}]};

get_base_fiesta_lv_exp(401,49) ->
	#base_fiesta_lv_exp{id = 401,act_id = 4,lv = 49,exp = 16500,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(401,50) ->
	#base_fiesta_lv_exp{id = 401,act_id = 4,lv = 50,exp = 17000,reward = [{0,23020001,4}],premium_reward = [{0,38040041,5}]};

get_base_fiesta_lv_exp(401,51) ->
	#base_fiesta_lv_exp{id = 401,act_id = 4,lv = 51,exp = 17500,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(401,52) ->
	#base_fiesta_lv_exp{id = 401,act_id = 4,lv = 52,exp = 18000,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(401,53) ->
	#base_fiesta_lv_exp{id = 401,act_id = 4,lv = 53,exp = 18500,reward = [{0,23020001,4}],premium_reward = [{0,38040041,5}]};

get_base_fiesta_lv_exp(401,54) ->
	#base_fiesta_lv_exp{id = 401,act_id = 4,lv = 54,exp = 19000,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(401,55) ->
	#base_fiesta_lv_exp{id = 401,act_id = 4,lv = 55,exp = 19500,reward = [{0,23020001,4}],premium_reward = [{0,38040041,5}]};

get_base_fiesta_lv_exp(401,56) ->
	#base_fiesta_lv_exp{id = 401,act_id = 4,lv = 56,exp = 20000,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(401,57) ->
	#base_fiesta_lv_exp{id = 401,act_id = 4,lv = 57,exp = 20500,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(401,58) ->
	#base_fiesta_lv_exp{id = 401,act_id = 4,lv = 58,exp = 21000,reward = [{0,23020001,4}],premium_reward = [{0,38040041,5}]};

get_base_fiesta_lv_exp(401,59) ->
	#base_fiesta_lv_exp{id = 401,act_id = 4,lv = 59,exp = 21500,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(401,60) ->
	#base_fiesta_lv_exp{id = 401,act_id = 4,lv = 60,exp = 22000,reward = [{0,23020001,4}],premium_reward = [{0,38040041,5}]};

get_base_fiesta_lv_exp(402,1) ->
	#base_fiesta_lv_exp{id = 402,act_id = 4,lv = 1,exp = 300,reward = [{0,19020001,2}],premium_reward = [{0,19020002,1}]};

get_base_fiesta_lv_exp(402,2) ->
	#base_fiesta_lv_exp{id = 402,act_id = 4,lv = 2,exp = 600,reward = [{0,38040005,25}],premium_reward = [{0,38040005,50}]};

get_base_fiesta_lv_exp(402,3) ->
	#base_fiesta_lv_exp{id = 402,act_id = 4,lv = 3,exp = 900,reward = [{0,37020001,2}],premium_reward = [{0,37121002,1}]};

get_base_fiesta_lv_exp(402,4) ->
	#base_fiesta_lv_exp{id = 402,act_id = 4,lv = 4,exp = 1200,reward = [{0,19020001,2}],premium_reward = [{0,19020002,1}]};

get_base_fiesta_lv_exp(402,5) ->
	#base_fiesta_lv_exp{id = 402,act_id = 4,lv = 5,exp = 1500,reward = [{0,38370001,1}],premium_reward = [{0,38160001,1}]};

get_base_fiesta_lv_exp(402,6) ->
	#base_fiesta_lv_exp{id = 402,act_id = 4,lv = 6,exp = 1800,reward = [{0,32010119,2}],premium_reward = [{0,32010120,1}]};

get_base_fiesta_lv_exp(402,7) ->
	#base_fiesta_lv_exp{id = 402,act_id = 4,lv = 7,exp = 2100,reward = [{0,38030005,1}],premium_reward = [{0,38030004,2}]};

get_base_fiesta_lv_exp(402,8) ->
	#base_fiesta_lv_exp{id = 402,act_id = 4,lv = 8,exp = 2400,reward = [{0,19020001,2}],premium_reward = [{0,19020002,1}]};

get_base_fiesta_lv_exp(402,9) ->
	#base_fiesta_lv_exp{id = 402,act_id = 4,lv = 9,exp = 2700,reward = [{0,38100002,2}],premium_reward = [{0,38100002,5}]};

get_base_fiesta_lv_exp(402,10) ->
	#base_fiesta_lv_exp{id = 402,act_id = 4,lv = 10,exp = 3000,reward = [{0,39510021,1}],premium_reward = [{0,37121003,1}]};

get_base_fiesta_lv_exp(402,11) ->
	#base_fiesta_lv_exp{id = 402,act_id = 4,lv = 11,exp = 3300,reward = [{0,19020001,2}],premium_reward = [{0,19020002,1}]};

get_base_fiesta_lv_exp(402,12) ->
	#base_fiesta_lv_exp{id = 402,act_id = 4,lv = 12,exp = 3600,reward = [{0,38100002,2}],premium_reward = [{0,38100002,5}]};

get_base_fiesta_lv_exp(402,13) ->
	#base_fiesta_lv_exp{id = 402,act_id = 4,lv = 13,exp = 3900,reward = [{0,38040005,50}],premium_reward = [{0,38040027,1}]};

get_base_fiesta_lv_exp(402,14) ->
	#base_fiesta_lv_exp{id = 402,act_id = 4,lv = 14,exp = 4200,reward = [{0,32010119,2}],premium_reward = [{0,32010120,1}]};

get_base_fiesta_lv_exp(402,15) ->
	#base_fiesta_lv_exp{id = 402,act_id = 4,lv = 15,exp = 4500,reward = [{0,38160001,1}],premium_reward = [{0,37020002,1}]};

get_base_fiesta_lv_exp(402,16) ->
	#base_fiesta_lv_exp{id = 402,act_id = 4,lv = 16,exp = 4800,reward = [{0,32010001,1}],premium_reward = [{0,32010002,1}]};

get_base_fiesta_lv_exp(402,17) ->
	#base_fiesta_lv_exp{id = 402,act_id = 4,lv = 17,exp = 5100,reward = [{0,19020001,5}],premium_reward = [{0,19020002,1}]};

get_base_fiesta_lv_exp(402,18) ->
	#base_fiesta_lv_exp{id = 402,act_id = 4,lv = 18,exp = 5400,reward = [{0,38100002,3}],premium_reward = [{0,38100002,6}]};

get_base_fiesta_lv_exp(402,19) ->
	#base_fiesta_lv_exp{id = 402,act_id = 4,lv = 19,exp = 5700,reward = [{0,32010001,1}],premium_reward = [{0,32010002,1}]};

get_base_fiesta_lv_exp(402,20) ->
	#base_fiesta_lv_exp{id = 402,act_id = 4,lv = 20,exp = 6000,reward = [{0,18010003,1}],premium_reward = [{0,6101004,2}]};

get_base_fiesta_lv_exp(402,21) ->
	#base_fiesta_lv_exp{id = 402,act_id = 4,lv = 21,exp = 6300,reward = [{0,20020001,3}],premium_reward = [{0,20020002,1}]};

get_base_fiesta_lv_exp(402,22) ->
	#base_fiesta_lv_exp{id = 402,act_id = 4,lv = 22,exp = 6600,reward = [{0,38100002,3}],premium_reward = [{0,38100002,6}]};

get_base_fiesta_lv_exp(402,23) ->
	#base_fiesta_lv_exp{id = 402,act_id = 4,lv = 23,exp = 6900,reward = [{0,32010002,1}],premium_reward = [{0,32010003,1}]};

get_base_fiesta_lv_exp(402,24) ->
	#base_fiesta_lv_exp{id = 402,act_id = 4,lv = 24,exp = 7200,reward = [{0,20020001,3}],premium_reward = [{0,20020002,1}]};

get_base_fiesta_lv_exp(402,25) ->
	#base_fiesta_lv_exp{id = 402,act_id = 4,lv = 25,exp = 7500,reward = [{0,6101003,1}],premium_reward = [{0,6101004,1}]};

get_base_fiesta_lv_exp(402,26) ->
	#base_fiesta_lv_exp{id = 402,act_id = 4,lv = 26,exp = 7800,reward = [{0,32010119,3}],premium_reward = [{0,32010120,2}]};

get_base_fiesta_lv_exp(402,27) ->
	#base_fiesta_lv_exp{id = 402,act_id = 4,lv = 27,exp = 8100,reward = [{0,38030005,1}],premium_reward = [{0,38030004,2}]};

get_base_fiesta_lv_exp(402,28) ->
	#base_fiesta_lv_exp{id = 402,act_id = 4,lv = 28,exp = 8400,reward = [{0,20020001,3}],premium_reward = [{0,20020002,1}]};

get_base_fiesta_lv_exp(402,29) ->
	#base_fiesta_lv_exp{id = 402,act_id = 4,lv = 29,exp = 8700,reward = [{0,38040005,30}],premium_reward = [{0,38040005,60}]};

get_base_fiesta_lv_exp(402,30) ->
	#base_fiesta_lv_exp{id = 402,act_id = 4,lv = 30,exp = 9000,reward = [{0,34010390,1}],premium_reward = [{0,6102001,1}]};

get_base_fiesta_lv_exp(402,31) ->
	#base_fiesta_lv_exp{id = 402,act_id = 4,lv = 31,exp = 9300,reward = [{0,32010119,3}],premium_reward = [{0,32010120,3}]};

get_base_fiesta_lv_exp(402,32) ->
	#base_fiesta_lv_exp{id = 402,act_id = 4,lv = 32,exp = 9600,reward = [{0,38370002,1}],premium_reward = [{0,38030004,1}]};

get_base_fiesta_lv_exp(402,33) ->
	#base_fiesta_lv_exp{id = 402,act_id = 4,lv = 33,exp = 9900,reward = [{0,38040005,50}],premium_reward = [{0,38040027,1}]};

get_base_fiesta_lv_exp(402,34) ->
	#base_fiesta_lv_exp{id = 402,act_id = 4,lv = 34,exp = 10200,reward = [{0,38100002,3}],premium_reward = [{0,38100002,6}]};

get_base_fiesta_lv_exp(402,35) ->
	#base_fiesta_lv_exp{id = 402,act_id = 4,lv = 35,exp = 10500,reward = [{0,32010002,2}],premium_reward = [{0,32010004,1}]};

get_base_fiesta_lv_exp(402,36) ->
	#base_fiesta_lv_exp{id = 402,act_id = 4,lv = 36,exp = 10800,reward = [{0,20020001,3}],premium_reward = [{0,20020002,1}]};

get_base_fiesta_lv_exp(402,37) ->
	#base_fiesta_lv_exp{id = 402,act_id = 4,lv = 37,exp = 11100,reward = [{0,32010002,1}],premium_reward = [{0,32010003,1}]};

get_base_fiesta_lv_exp(402,38) ->
	#base_fiesta_lv_exp{id = 402,act_id = 4,lv = 38,exp = 11400,reward = [{0,32010119,3}],premium_reward = [{0,32010120,3}]};

get_base_fiesta_lv_exp(402,39) ->
	#base_fiesta_lv_exp{id = 402,act_id = 4,lv = 39,exp = 11700,reward = [{0,20020001,3}],premium_reward = [{0,20020002,1}]};

get_base_fiesta_lv_exp(402,40) ->
	#base_fiesta_lv_exp{id = 402,act_id = 4,lv = 40,exp = 12000,reward = [{0,32010141,1}],premium_reward = [{0,18030114,30}]};

get_base_fiesta_lv_exp(402,41) ->
	#base_fiesta_lv_exp{id = 402,act_id = 4,lv = 41,exp = 12500,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(402,42) ->
	#base_fiesta_lv_exp{id = 402,act_id = 4,lv = 42,exp = 13000,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(402,43) ->
	#base_fiesta_lv_exp{id = 402,act_id = 4,lv = 43,exp = 13500,reward = [{0,39510000,4}],premium_reward = [{0,39510000,10}]};

get_base_fiesta_lv_exp(402,44) ->
	#base_fiesta_lv_exp{id = 402,act_id = 4,lv = 44,exp = 14000,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(402,45) ->
	#base_fiesta_lv_exp{id = 402,act_id = 4,lv = 45,exp = 14500,reward = [{0,38040018,4}],premium_reward = [{0,38040018,10}]};

get_base_fiesta_lv_exp(402,46) ->
	#base_fiesta_lv_exp{id = 402,act_id = 4,lv = 46,exp = 15000,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(402,47) ->
	#base_fiesta_lv_exp{id = 402,act_id = 4,lv = 47,exp = 15500,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(402,48) ->
	#base_fiesta_lv_exp{id = 402,act_id = 4,lv = 48,exp = 16000,reward = [{0,39510000,4}],premium_reward = [{0,39510000,10}]};

get_base_fiesta_lv_exp(402,49) ->
	#base_fiesta_lv_exp{id = 402,act_id = 4,lv = 49,exp = 16500,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(402,50) ->
	#base_fiesta_lv_exp{id = 402,act_id = 4,lv = 50,exp = 17000,reward = [{0,38040018,4}],premium_reward = [{0,38040018,10}]};

get_base_fiesta_lv_exp(402,51) ->
	#base_fiesta_lv_exp{id = 402,act_id = 4,lv = 51,exp = 17500,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(402,52) ->
	#base_fiesta_lv_exp{id = 402,act_id = 4,lv = 52,exp = 18000,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(402,53) ->
	#base_fiesta_lv_exp{id = 402,act_id = 4,lv = 53,exp = 18500,reward = [{0,39510000,4}],premium_reward = [{0,39510000,10}]};

get_base_fiesta_lv_exp(402,54) ->
	#base_fiesta_lv_exp{id = 402,act_id = 4,lv = 54,exp = 19000,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(402,55) ->
	#base_fiesta_lv_exp{id = 402,act_id = 4,lv = 55,exp = 19500,reward = [{0,38040018,4}],premium_reward = [{0,38040018,10}]};

get_base_fiesta_lv_exp(402,56) ->
	#base_fiesta_lv_exp{id = 402,act_id = 4,lv = 56,exp = 20000,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(402,57) ->
	#base_fiesta_lv_exp{id = 402,act_id = 4,lv = 57,exp = 20500,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(402,58) ->
	#base_fiesta_lv_exp{id = 402,act_id = 4,lv = 58,exp = 21000,reward = [{0,39510000,4}],premium_reward = [{0,39510000,10}]};

get_base_fiesta_lv_exp(402,59) ->
	#base_fiesta_lv_exp{id = 402,act_id = 4,lv = 59,exp = 21500,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(402,60) ->
	#base_fiesta_lv_exp{id = 402,act_id = 4,lv = 60,exp = 22000,reward = [{0,38040018,4}],premium_reward = [{0,38040018,10}]};

get_base_fiesta_lv_exp(403,1) ->
	#base_fiesta_lv_exp{id = 403,act_id = 4,lv = 1,exp = 300,reward = [{0,7301001,2}],premium_reward = [{0,7301002,1}]};

get_base_fiesta_lv_exp(403,2) ->
	#base_fiesta_lv_exp{id = 403,act_id = 4,lv = 2,exp = 600,reward = [{0,38040005,25}],premium_reward = [{0,38040005,50}]};

get_base_fiesta_lv_exp(403,3) ->
	#base_fiesta_lv_exp{id = 403,act_id = 4,lv = 3,exp = 900,reward = [{0,37020001,2}],premium_reward = [{0,37121002,1}]};

get_base_fiesta_lv_exp(403,4) ->
	#base_fiesta_lv_exp{id = 403,act_id = 4,lv = 4,exp = 1200,reward = [{0,7301001,2}],premium_reward = [{0,7301002,1}]};

get_base_fiesta_lv_exp(403,5) ->
	#base_fiesta_lv_exp{id = 403,act_id = 4,lv = 5,exp = 1500,reward = [{0,38370001,1}],premium_reward = [{0,38160001,1}]};

get_base_fiesta_lv_exp(403,6) ->
	#base_fiesta_lv_exp{id = 403,act_id = 4,lv = 6,exp = 1800,reward = [{0,32010119,2}],premium_reward = [{0,32010120,1}]};

get_base_fiesta_lv_exp(403,7) ->
	#base_fiesta_lv_exp{id = 403,act_id = 4,lv = 7,exp = 2100,reward = [{0,38030005,1}],premium_reward = [{0,38030004,2}]};

get_base_fiesta_lv_exp(403,8) ->
	#base_fiesta_lv_exp{id = 403,act_id = 4,lv = 8,exp = 2400,reward = [{0,7301001,2}],premium_reward = [{0,7301002,1}]};

get_base_fiesta_lv_exp(403,9) ->
	#base_fiesta_lv_exp{id = 403,act_id = 4,lv = 9,exp = 2700,reward = [{0,38100002,2}],premium_reward = [{0,38100002,5}]};

get_base_fiesta_lv_exp(403,10) ->
	#base_fiesta_lv_exp{id = 403,act_id = 4,lv = 10,exp = 3000,reward = [{0,39510021,1}],premium_reward = [{0,37121003,1}]};

get_base_fiesta_lv_exp(403,11) ->
	#base_fiesta_lv_exp{id = 403,act_id = 4,lv = 11,exp = 3300,reward = [{0,7301001,2}],premium_reward = [{0,7301002,1}]};

get_base_fiesta_lv_exp(403,12) ->
	#base_fiesta_lv_exp{id = 403,act_id = 4,lv = 12,exp = 3600,reward = [{0,38100002,2}],premium_reward = [{0,38100002,5}]};

get_base_fiesta_lv_exp(403,13) ->
	#base_fiesta_lv_exp{id = 403,act_id = 4,lv = 13,exp = 3900,reward = [{0,38040005,50}],premium_reward = [{0,38040027,1}]};

get_base_fiesta_lv_exp(403,14) ->
	#base_fiesta_lv_exp{id = 403,act_id = 4,lv = 14,exp = 4200,reward = [{0,32010119,2}],premium_reward = [{0,32010120,1}]};

get_base_fiesta_lv_exp(403,15) ->
	#base_fiesta_lv_exp{id = 403,act_id = 4,lv = 15,exp = 4500,reward = [{0,38160001,1}],premium_reward = [{0,37020002,1}]};

get_base_fiesta_lv_exp(403,16) ->
	#base_fiesta_lv_exp{id = 403,act_id = 4,lv = 16,exp = 4800,reward = [{0,32010001,1}],premium_reward = [{0,32010002,1}]};

get_base_fiesta_lv_exp(403,17) ->
	#base_fiesta_lv_exp{id = 403,act_id = 4,lv = 17,exp = 5100,reward = [{0,7301001,5}],premium_reward = [{0,7301002,1}]};

get_base_fiesta_lv_exp(403,18) ->
	#base_fiesta_lv_exp{id = 403,act_id = 4,lv = 18,exp = 5400,reward = [{0,38100002,3}],premium_reward = [{0,38100002,6}]};

get_base_fiesta_lv_exp(403,19) ->
	#base_fiesta_lv_exp{id = 403,act_id = 4,lv = 19,exp = 5700,reward = [{0,32010001,1}],premium_reward = [{0,32010002,1}]};

get_base_fiesta_lv_exp(403,20) ->
	#base_fiesta_lv_exp{id = 403,act_id = 4,lv = 20,exp = 6000,reward = [{0,20010003,1}],premium_reward = [{0,6101004,2}]};

get_base_fiesta_lv_exp(403,21) ->
	#base_fiesta_lv_exp{id = 403,act_id = 4,lv = 21,exp = 6300,reward = [{0,7301003,3}],premium_reward = [{0,7301004,1}]};

get_base_fiesta_lv_exp(403,22) ->
	#base_fiesta_lv_exp{id = 403,act_id = 4,lv = 22,exp = 6600,reward = [{0,38100002,3}],premium_reward = [{0,38100002,6}]};

get_base_fiesta_lv_exp(403,23) ->
	#base_fiesta_lv_exp{id = 403,act_id = 4,lv = 23,exp = 6900,reward = [{0,32010002,1}],premium_reward = [{0,32010003,1}]};

get_base_fiesta_lv_exp(403,24) ->
	#base_fiesta_lv_exp{id = 403,act_id = 4,lv = 24,exp = 7200,reward = [{0,7301003,3}],premium_reward = [{0,7301004,1}]};

get_base_fiesta_lv_exp(403,25) ->
	#base_fiesta_lv_exp{id = 403,act_id = 4,lv = 25,exp = 7500,reward = [{0,6101003,1}],premium_reward = [{0,6101004,1}]};

get_base_fiesta_lv_exp(403,26) ->
	#base_fiesta_lv_exp{id = 403,act_id = 4,lv = 26,exp = 7800,reward = [{0,32010119,3}],premium_reward = [{0,32010120,2}]};

get_base_fiesta_lv_exp(403,27) ->
	#base_fiesta_lv_exp{id = 403,act_id = 4,lv = 27,exp = 8100,reward = [{0,38030005,1}],premium_reward = [{0,38030004,2}]};

get_base_fiesta_lv_exp(403,28) ->
	#base_fiesta_lv_exp{id = 403,act_id = 4,lv = 28,exp = 8400,reward = [{0,7301003,3}],premium_reward = [{0,7301004,1}]};

get_base_fiesta_lv_exp(403,29) ->
	#base_fiesta_lv_exp{id = 403,act_id = 4,lv = 29,exp = 8700,reward = [{0,38040005,30}],premium_reward = [{0,38040005,60}]};

get_base_fiesta_lv_exp(403,30) ->
	#base_fiesta_lv_exp{id = 403,act_id = 4,lv = 30,exp = 9000,reward = [{0,34010390,1}],premium_reward = [{0,6102001,1}]};

get_base_fiesta_lv_exp(403,31) ->
	#base_fiesta_lv_exp{id = 403,act_id = 4,lv = 31,exp = 9300,reward = [{0,32010119,3}],premium_reward = [{0,32010120,3}]};

get_base_fiesta_lv_exp(403,32) ->
	#base_fiesta_lv_exp{id = 403,act_id = 4,lv = 32,exp = 9600,reward = [{0,38370002,1}],premium_reward = [{0,38030004,1}]};

get_base_fiesta_lv_exp(403,33) ->
	#base_fiesta_lv_exp{id = 403,act_id = 4,lv = 33,exp = 9900,reward = [{0,38040005,50}],premium_reward = [{0,38040027,1}]};

get_base_fiesta_lv_exp(403,34) ->
	#base_fiesta_lv_exp{id = 403,act_id = 4,lv = 34,exp = 10200,reward = [{0,38100002,3}],premium_reward = [{0,38100002,6}]};

get_base_fiesta_lv_exp(403,35) ->
	#base_fiesta_lv_exp{id = 403,act_id = 4,lv = 35,exp = 10500,reward = [{0,32010002,2}],premium_reward = [{0,32010004,1}]};

get_base_fiesta_lv_exp(403,36) ->
	#base_fiesta_lv_exp{id = 403,act_id = 4,lv = 36,exp = 10800,reward = [{0,7301003,3}],premium_reward = [{0,7301004,1}]};

get_base_fiesta_lv_exp(403,37) ->
	#base_fiesta_lv_exp{id = 403,act_id = 4,lv = 37,exp = 11100,reward = [{0,32010002,1}],premium_reward = [{0,32010003,1}]};

get_base_fiesta_lv_exp(403,38) ->
	#base_fiesta_lv_exp{id = 403,act_id = 4,lv = 38,exp = 11400,reward = [{0,32010119,3}],premium_reward = [{0,32010120,3}]};

get_base_fiesta_lv_exp(403,39) ->
	#base_fiesta_lv_exp{id = 403,act_id = 4,lv = 39,exp = 11700,reward = [{0,7301003,3}],premium_reward = [{0,7301004,1}]};

get_base_fiesta_lv_exp(403,40) ->
	#base_fiesta_lv_exp{id = 403,act_id = 4,lv = 40,exp = 12000,reward = [{0,39510025,1}],premium_reward = [{0,18030114,30}]};

get_base_fiesta_lv_exp(403,41) ->
	#base_fiesta_lv_exp{id = 403,act_id = 4,lv = 41,exp = 12500,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(403,42) ->
	#base_fiesta_lv_exp{id = 403,act_id = 4,lv = 42,exp = 13000,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(403,43) ->
	#base_fiesta_lv_exp{id = 403,act_id = 4,lv = 43,exp = 13500,reward = [{0,801701,2}],premium_reward = [{0,801702,1}]};

get_base_fiesta_lv_exp(403,44) ->
	#base_fiesta_lv_exp{id = 403,act_id = 4,lv = 44,exp = 14000,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(403,45) ->
	#base_fiesta_lv_exp{id = 403,act_id = 4,lv = 45,exp = 14500,reward = [{0,801701,2}],premium_reward = [{0,801702,1}]};

get_base_fiesta_lv_exp(403,46) ->
	#base_fiesta_lv_exp{id = 403,act_id = 4,lv = 46,exp = 15000,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(403,47) ->
	#base_fiesta_lv_exp{id = 403,act_id = 4,lv = 47,exp = 15500,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(403,48) ->
	#base_fiesta_lv_exp{id = 403,act_id = 4,lv = 48,exp = 16000,reward = [{0,801701,2}],premium_reward = [{0,801702,1}]};

get_base_fiesta_lv_exp(403,49) ->
	#base_fiesta_lv_exp{id = 403,act_id = 4,lv = 49,exp = 16500,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(403,50) ->
	#base_fiesta_lv_exp{id = 403,act_id = 4,lv = 50,exp = 17000,reward = [{0,801701,2}],premium_reward = [{0,801702,1}]};

get_base_fiesta_lv_exp(403,51) ->
	#base_fiesta_lv_exp{id = 403,act_id = 4,lv = 51,exp = 17500,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(403,52) ->
	#base_fiesta_lv_exp{id = 403,act_id = 4,lv = 52,exp = 18000,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(403,53) ->
	#base_fiesta_lv_exp{id = 403,act_id = 4,lv = 53,exp = 18500,reward = [{0,801701,2}],premium_reward = [{0,801702,1}]};

get_base_fiesta_lv_exp(403,54) ->
	#base_fiesta_lv_exp{id = 403,act_id = 4,lv = 54,exp = 19000,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(403,55) ->
	#base_fiesta_lv_exp{id = 403,act_id = 4,lv = 55,exp = 19500,reward = [{0,801701,2}],premium_reward = [{0,801702,1}]};

get_base_fiesta_lv_exp(403,56) ->
	#base_fiesta_lv_exp{id = 403,act_id = 4,lv = 56,exp = 20000,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(403,57) ->
	#base_fiesta_lv_exp{id = 403,act_id = 4,lv = 57,exp = 20500,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(403,58) ->
	#base_fiesta_lv_exp{id = 403,act_id = 4,lv = 58,exp = 21000,reward = [{0,801701,2}],premium_reward = [{0,801702,1}]};

get_base_fiesta_lv_exp(403,59) ->
	#base_fiesta_lv_exp{id = 403,act_id = 4,lv = 59,exp = 21500,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(403,60) ->
	#base_fiesta_lv_exp{id = 403,act_id = 4,lv = 60,exp = 22000,reward = [{0,801701,2}],premium_reward = [{0,801702,1}]};

get_base_fiesta_lv_exp(501,1) ->
	#base_fiesta_lv_exp{id = 501,act_id = 5,lv = 1,exp = 100,reward = [{0,16020001,2}],premium_reward = [{0,16020002,1}]};

get_base_fiesta_lv_exp(501,2) ->
	#base_fiesta_lv_exp{id = 501,act_id = 5,lv = 2,exp = 200,reward = [{0,38040005,20}],premium_reward = [{0,38040005,30}]};

get_base_fiesta_lv_exp(501,3) ->
	#base_fiesta_lv_exp{id = 501,act_id = 5,lv = 3,exp = 300,reward = [{0,16020001,2}],premium_reward = [{0,16020002,1}]};

get_base_fiesta_lv_exp(501,4) ->
	#base_fiesta_lv_exp{id = 501,act_id = 5,lv = 4,exp = 400,reward = [{0,38370001,1}],premium_reward = [{0,38160001,1}]};

get_base_fiesta_lv_exp(501,5) ->
	#base_fiesta_lv_exp{id = 501,act_id = 5,lv = 5,exp = 500,reward = [{0,37020001,2}],premium_reward = [{0,37121002,1}]};

get_base_fiesta_lv_exp(501,6) ->
	#base_fiesta_lv_exp{id = 501,act_id = 5,lv = 6,exp = 600,reward = [{0,32010119,1}],premium_reward = [{0,32010120,1}]};

get_base_fiesta_lv_exp(501,7) ->
	#base_fiesta_lv_exp{id = 501,act_id = 5,lv = 7,exp = 700,reward = [{0,38030003,1}],premium_reward = [{0,38030004,2}]};

get_base_fiesta_lv_exp(501,8) ->
	#base_fiesta_lv_exp{id = 501,act_id = 5,lv = 8,exp = 800,reward = [{0,16020001,2}],premium_reward = [{0,16020002,1}]};

get_base_fiesta_lv_exp(501,9) ->
	#base_fiesta_lv_exp{id = 501,act_id = 5,lv = 9,exp = 900,reward = [{0,38100002,2}],premium_reward = [{0,38100002,5}]};

get_base_fiesta_lv_exp(501,10) ->
	#base_fiesta_lv_exp{id = 501,act_id = 5,lv = 10,exp = 1000,reward = [{0,39510021,1}],premium_reward = [{0,35,128}]};

get_base_fiesta_lv_exp(501,11) ->
	#base_fiesta_lv_exp{id = 501,act_id = 5,lv = 11,exp = 1100,reward = [{0,16020001,2}],premium_reward = [{0,16020002,1}]};

get_base_fiesta_lv_exp(501,12) ->
	#base_fiesta_lv_exp{id = 501,act_id = 5,lv = 12,exp = 1200,reward = [{0,38100002,2}],premium_reward = [{0,38100002,5}]};

get_base_fiesta_lv_exp(501,13) ->
	#base_fiesta_lv_exp{id = 501,act_id = 5,lv = 13,exp = 1300,reward = [{0,38040005,20}],premium_reward = [{0,38040027,1}]};

get_base_fiesta_lv_exp(501,14) ->
	#base_fiesta_lv_exp{id = 501,act_id = 5,lv = 14,exp = 1400,reward = [{0,32010119,1}],premium_reward = [{0,32010120,1}]};

get_base_fiesta_lv_exp(501,15) ->
	#base_fiesta_lv_exp{id = 501,act_id = 5,lv = 15,exp = 1500,reward = [{0,38160001,1}],premium_reward = [{0,37020002,1}]};

get_base_fiesta_lv_exp(501,16) ->
	#base_fiesta_lv_exp{id = 501,act_id = 5,lv = 16,exp = 1600,reward = [{0,32010001,1}],premium_reward = [{0,32010002,1}]};

get_base_fiesta_lv_exp(501,17) ->
	#base_fiesta_lv_exp{id = 501,act_id = 5,lv = 17,exp = 1700,reward = [{0,16020001,2}],premium_reward = [{0,16020002,2}]};

get_base_fiesta_lv_exp(501,18) ->
	#base_fiesta_lv_exp{id = 501,act_id = 5,lv = 18,exp = 1800,reward = [{0,38100002,2}],premium_reward = [{0,38100002,5}]};

get_base_fiesta_lv_exp(501,19) ->
	#base_fiesta_lv_exp{id = 501,act_id = 5,lv = 19,exp = 1900,reward = [{0,32010001,1}],premium_reward = [{0,32010002,1}]};

get_base_fiesta_lv_exp(501,20) ->
	#base_fiesta_lv_exp{id = 501,act_id = 5,lv = 20,exp = 2000,reward = [{0,16010001,1}],premium_reward = [{0,37121003,1}]};

get_base_fiesta_lv_exp(501,21) ->
	#base_fiesta_lv_exp{id = 501,act_id = 5,lv = 21,exp = 2100,reward = [{0,18020001,2}],premium_reward = [{0,18020002,1}]};

get_base_fiesta_lv_exp(501,22) ->
	#base_fiesta_lv_exp{id = 501,act_id = 5,lv = 22,exp = 2200,reward = [{0,38100002,2}],premium_reward = [{0,38100002,5}]};

get_base_fiesta_lv_exp(501,23) ->
	#base_fiesta_lv_exp{id = 501,act_id = 5,lv = 23,exp = 2300,reward = [{0,32010001,1}],premium_reward = [{0,32010002,1}]};

get_base_fiesta_lv_exp(501,24) ->
	#base_fiesta_lv_exp{id = 501,act_id = 5,lv = 24,exp = 2400,reward = [{0,18020001,2}],premium_reward = [{0,18020002,1}]};

get_base_fiesta_lv_exp(501,25) ->
	#base_fiesta_lv_exp{id = 501,act_id = 5,lv = 25,exp = 2500,reward = [{0,16020001,2}],premium_reward = [{0,16020002,1}]};

get_base_fiesta_lv_exp(501,26) ->
	#base_fiesta_lv_exp{id = 501,act_id = 5,lv = 26,exp = 2600,reward = [{0,32010119,1}],premium_reward = [{0,32010120,1}]};

get_base_fiesta_lv_exp(501,27) ->
	#base_fiesta_lv_exp{id = 501,act_id = 5,lv = 27,exp = 2700,reward = [{0,38030003,1}],premium_reward = [{0,38030004,2}]};

get_base_fiesta_lv_exp(501,28) ->
	#base_fiesta_lv_exp{id = 501,act_id = 5,lv = 28,exp = 2800,reward = [{0,18020001,2}],premium_reward = [{0,18020002,1}]};

get_base_fiesta_lv_exp(501,29) ->
	#base_fiesta_lv_exp{id = 501,act_id = 5,lv = 29,exp = 2900,reward = [{0,38040005,20}],premium_reward = [{0,38040005,50}]};

get_base_fiesta_lv_exp(501,30) ->
	#base_fiesta_lv_exp{id = 501,act_id = 5,lv = 30,exp = 3000,reward = [{0,16010001,1}],premium_reward = [{0,35,188}]};

get_base_fiesta_lv_exp(501,31) ->
	#base_fiesta_lv_exp{id = 501,act_id = 5,lv = 31,exp = 3100,reward = [{0,32010119,1}],premium_reward = [{0,32010120,1}]};

get_base_fiesta_lv_exp(501,32) ->
	#base_fiesta_lv_exp{id = 501,act_id = 5,lv = 32,exp = 3200,reward = [{0,38370003,1}],premium_reward = [{0,38030004,1}]};

get_base_fiesta_lv_exp(501,33) ->
	#base_fiesta_lv_exp{id = 501,act_id = 5,lv = 33,exp = 3300,reward = [{0,38040005,20}],premium_reward = [{0,38040027,1}]};

get_base_fiesta_lv_exp(501,34) ->
	#base_fiesta_lv_exp{id = 501,act_id = 5,lv = 34,exp = 3400,reward = [{0,38100002,2}],premium_reward = [{0,38100002,5}]};

get_base_fiesta_lv_exp(501,35) ->
	#base_fiesta_lv_exp{id = 501,act_id = 5,lv = 35,exp = 3500,reward = [{0,32010001,2}],premium_reward = [{0,32010002,2}]};

get_base_fiesta_lv_exp(501,36) ->
	#base_fiesta_lv_exp{id = 501,act_id = 5,lv = 36,exp = 3600,reward = [{0,18020001,2}],premium_reward = [{0,18020002,1}]};

get_base_fiesta_lv_exp(501,37) ->
	#base_fiesta_lv_exp{id = 501,act_id = 5,lv = 37,exp = 3700,reward = [{0,32010001,2}],premium_reward = [{0,32010002,2}]};

get_base_fiesta_lv_exp(501,38) ->
	#base_fiesta_lv_exp{id = 501,act_id = 5,lv = 38,exp = 3800,reward = [{0,32010119,1}],premium_reward = [{0,32010120,1}]};

get_base_fiesta_lv_exp(501,39) ->
	#base_fiesta_lv_exp{id = 501,act_id = 5,lv = 39,exp = 3900,reward = [{0,18020001,2}],premium_reward = [{0,18020002,1}]};

get_base_fiesta_lv_exp(501,40) ->
	#base_fiesta_lv_exp{id = 501,act_id = 5,lv = 40,exp = 4000,reward = [{0,6101003,1}],premium_reward = [{0,6101004,1}]};

get_base_fiesta_lv_exp(501,41) ->
	#base_fiesta_lv_exp{id = 501,act_id = 5,lv = 41,exp = 4100,reward = [{0,16020001,2}],premium_reward = [{0,16020002,1}]};

get_base_fiesta_lv_exp(501,42) ->
	#base_fiesta_lv_exp{id = 501,act_id = 5,lv = 42,exp = 4200,reward = [{0,38100002,2}],premium_reward = [{0,38100002,5}]};

get_base_fiesta_lv_exp(501,43) ->
	#base_fiesta_lv_exp{id = 501,act_id = 5,lv = 43,exp = 4300,reward = [{0,38040005,20}],premium_reward = [{0,38040027,1}]};

get_base_fiesta_lv_exp(501,44) ->
	#base_fiesta_lv_exp{id = 501,act_id = 5,lv = 44,exp = 4400,reward = [{0,32010119,1}],premium_reward = [{0,32010120,1}]};

get_base_fiesta_lv_exp(501,45) ->
	#base_fiesta_lv_exp{id = 501,act_id = 5,lv = 45,exp = 4500,reward = [{0,38160001,1}],premium_reward = [{0,37020002,1}]};

get_base_fiesta_lv_exp(501,46) ->
	#base_fiesta_lv_exp{id = 501,act_id = 5,lv = 46,exp = 4600,reward = [{0,32010001,2}],premium_reward = [{0,32010002,2}]};

get_base_fiesta_lv_exp(501,47) ->
	#base_fiesta_lv_exp{id = 501,act_id = 5,lv = 47,exp = 4700,reward = [{0,16020001,2}],premium_reward = [{0,16020002,2}]};

get_base_fiesta_lv_exp(501,48) ->
	#base_fiesta_lv_exp{id = 501,act_id = 5,lv = 48,exp = 4800,reward = [{0,38100002,2}],premium_reward = [{0,38100002,5}]};

get_base_fiesta_lv_exp(501,49) ->
	#base_fiesta_lv_exp{id = 501,act_id = 5,lv = 49,exp = 4900,reward = [{0,38040005,20}],premium_reward = [{0,38040005,50}]};

get_base_fiesta_lv_exp(501,50) ->
	#base_fiesta_lv_exp{id = 501,act_id = 5,lv = 50,exp = 5000,reward = [{0,16010002,1}],premium_reward = [{0,32010517,1}]};

get_base_fiesta_lv_exp(501,51) ->
	#base_fiesta_lv_exp{id = 501,act_id = 5,lv = 51,exp = 5100,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(501,52) ->
	#base_fiesta_lv_exp{id = 501,act_id = 5,lv = 52,exp = 5200,reward = [{0,38100002,2}],premium_reward = [{0,38100002,5}]};

get_base_fiesta_lv_exp(501,53) ->
	#base_fiesta_lv_exp{id = 501,act_id = 5,lv = 53,exp = 5300,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(501,54) ->
	#base_fiesta_lv_exp{id = 501,act_id = 5,lv = 54,exp = 5400,reward = [{0,18020001,2}],premium_reward = [{0,18020002,1}]};

get_base_fiesta_lv_exp(501,55) ->
	#base_fiesta_lv_exp{id = 501,act_id = 5,lv = 55,exp = 5500,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(501,56) ->
	#base_fiesta_lv_exp{id = 501,act_id = 5,lv = 56,exp = 5600,reward = [{0,32010119,2}],premium_reward = [{0,32010120,1}]};

get_base_fiesta_lv_exp(501,57) ->
	#base_fiesta_lv_exp{id = 501,act_id = 5,lv = 57,exp = 5700,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(501,58) ->
	#base_fiesta_lv_exp{id = 501,act_id = 5,lv = 58,exp = 5800,reward = [{0,18020001,2}],premium_reward = [{0,18020002,1}]};

get_base_fiesta_lv_exp(501,59) ->
	#base_fiesta_lv_exp{id = 501,act_id = 5,lv = 59,exp = 5900,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(501,60) ->
	#base_fiesta_lv_exp{id = 501,act_id = 5,lv = 60,exp = 6000,reward = [{0,16010002,1}],premium_reward = [{0,35,268}]};

get_base_fiesta_lv_exp(501,61) ->
	#base_fiesta_lv_exp{id = 501,act_id = 5,lv = 61,exp = 6100,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(501,62) ->
	#base_fiesta_lv_exp{id = 501,act_id = 5,lv = 62,exp = 6200,reward = [{0,38370003,1}],premium_reward = [{0,38030004,1}]};

get_base_fiesta_lv_exp(501,63) ->
	#base_fiesta_lv_exp{id = 501,act_id = 5,lv = 63,exp = 6300,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(501,64) ->
	#base_fiesta_lv_exp{id = 501,act_id = 5,lv = 64,exp = 6400,reward = [{0,38100002,2}],premium_reward = [{0,38100002,5}]};

get_base_fiesta_lv_exp(501,65) ->
	#base_fiesta_lv_exp{id = 501,act_id = 5,lv = 65,exp = 6500,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(501,66) ->
	#base_fiesta_lv_exp{id = 501,act_id = 5,lv = 66,exp = 6600,reward = [{0,18020001,2}],premium_reward = [{0,18020002,1}]};

get_base_fiesta_lv_exp(501,67) ->
	#base_fiesta_lv_exp{id = 501,act_id = 5,lv = 67,exp = 6700,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(501,68) ->
	#base_fiesta_lv_exp{id = 501,act_id = 5,lv = 68,exp = 6800,reward = [{0,32010119,2}],premium_reward = [{0,32010120,1}]};

get_base_fiesta_lv_exp(501,69) ->
	#base_fiesta_lv_exp{id = 501,act_id = 5,lv = 69,exp = 6900,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(501,70) ->
	#base_fiesta_lv_exp{id = 501,act_id = 5,lv = 70,exp = 7000,reward = [{0,34010390,1}],premium_reward = [{0,6102001,1}]};

get_base_fiesta_lv_exp(501,71) ->
	#base_fiesta_lv_exp{id = 501,act_id = 5,lv = 71,exp = 7100,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(501,72) ->
	#base_fiesta_lv_exp{id = 501,act_id = 5,lv = 72,exp = 7200,reward = [{0,38100002,2}],premium_reward = [{0,38100002,5}]};

get_base_fiesta_lv_exp(501,73) ->
	#base_fiesta_lv_exp{id = 501,act_id = 5,lv = 73,exp = 7300,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(501,74) ->
	#base_fiesta_lv_exp{id = 501,act_id = 5,lv = 74,exp = 7400,reward = [{0,32010119,2}],premium_reward = [{0,32010120,1}]};

get_base_fiesta_lv_exp(501,75) ->
	#base_fiesta_lv_exp{id = 501,act_id = 5,lv = 75,exp = 7500,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(501,76) ->
	#base_fiesta_lv_exp{id = 501,act_id = 5,lv = 76,exp = 7600,reward = [{0,32010002,2}],premium_reward = [{0,32010003,2}]};

get_base_fiesta_lv_exp(501,77) ->
	#base_fiesta_lv_exp{id = 501,act_id = 5,lv = 77,exp = 7700,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(501,78) ->
	#base_fiesta_lv_exp{id = 501,act_id = 5,lv = 78,exp = 7800,reward = [{0,38100002,2}],premium_reward = [{0,38100002,5}]};

get_base_fiesta_lv_exp(501,79) ->
	#base_fiesta_lv_exp{id = 501,act_id = 5,lv = 79,exp = 7900,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(501,80) ->
	#base_fiesta_lv_exp{id = 501,act_id = 5,lv = 80,exp = 8000,reward = [{0,34010391,1}],premium_reward = [{0,35,368}]};

get_base_fiesta_lv_exp(501,81) ->
	#base_fiesta_lv_exp{id = 501,act_id = 5,lv = 81,exp = 8100,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(501,82) ->
	#base_fiesta_lv_exp{id = 501,act_id = 5,lv = 82,exp = 8200,reward = [{0,38370003,1}],premium_reward = [{0,38030004,1}]};

get_base_fiesta_lv_exp(501,83) ->
	#base_fiesta_lv_exp{id = 501,act_id = 5,lv = 83,exp = 8300,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(501,84) ->
	#base_fiesta_lv_exp{id = 501,act_id = 5,lv = 84,exp = 8400,reward = [{0,38100002,2}],premium_reward = [{0,38100002,5}]};

get_base_fiesta_lv_exp(501,85) ->
	#base_fiesta_lv_exp{id = 501,act_id = 5,lv = 85,exp = 8500,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(501,86) ->
	#base_fiesta_lv_exp{id = 501,act_id = 5,lv = 86,exp = 8600,reward = [{0,18020001,2}],premium_reward = [{0,18020002,1}]};

get_base_fiesta_lv_exp(501,87) ->
	#base_fiesta_lv_exp{id = 501,act_id = 5,lv = 87,exp = 8700,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(501,88) ->
	#base_fiesta_lv_exp{id = 501,act_id = 5,lv = 88,exp = 8800,reward = [{0,32010119,3}],premium_reward = [{0,32010120,2}]};

get_base_fiesta_lv_exp(501,89) ->
	#base_fiesta_lv_exp{id = 501,act_id = 5,lv = 89,exp = 8900,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(501,90) ->
	#base_fiesta_lv_exp{id = 501,act_id = 5,lv = 90,exp = 9000,reward = [{0,16010003,1}],premium_reward = [{0,32010517,1}]};

get_base_fiesta_lv_exp(501,91) ->
	#base_fiesta_lv_exp{id = 501,act_id = 5,lv = 91,exp = 9100,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(501,92) ->
	#base_fiesta_lv_exp{id = 501,act_id = 5,lv = 92,exp = 9200,reward = [{0,38100002,2}],premium_reward = [{0,38100002,5}]};

get_base_fiesta_lv_exp(501,93) ->
	#base_fiesta_lv_exp{id = 501,act_id = 5,lv = 93,exp = 9300,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(501,94) ->
	#base_fiesta_lv_exp{id = 501,act_id = 5,lv = 94,exp = 9400,reward = [{0,18020001,2}],premium_reward = [{0,18020002,1}]};

get_base_fiesta_lv_exp(501,95) ->
	#base_fiesta_lv_exp{id = 501,act_id = 5,lv = 95,exp = 9500,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(501,96) ->
	#base_fiesta_lv_exp{id = 501,act_id = 5,lv = 96,exp = 9600,reward = [{0,32010119,3}],premium_reward = [{0,32010120,3}]};

get_base_fiesta_lv_exp(501,97) ->
	#base_fiesta_lv_exp{id = 501,act_id = 5,lv = 97,exp = 9700,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(501,98) ->
	#base_fiesta_lv_exp{id = 501,act_id = 5,lv = 98,exp = 9800,reward = [{0,18020001,2}],premium_reward = [{0,18020002,1}]};

get_base_fiesta_lv_exp(501,99) ->
	#base_fiesta_lv_exp{id = 501,act_id = 5,lv = 99,exp = 9900,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(501,100) ->
	#base_fiesta_lv_exp{id = 501,act_id = 5,lv = 100,exp = 10000,reward = [{0,35,128}],premium_reward = [{0,18030115,30}]};

get_base_fiesta_lv_exp(501,101) ->
	#base_fiesta_lv_exp{id = 501,act_id = 5,lv = 101,exp = 10100,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(501,102) ->
	#base_fiesta_lv_exp{id = 501,act_id = 5,lv = 102,exp = 10200,reward = [{0,23020001,4}],premium_reward = [{0,38040041,5}]};

get_base_fiesta_lv_exp(501,103) ->
	#base_fiesta_lv_exp{id = 501,act_id = 5,lv = 103,exp = 10300,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(501,104) ->
	#base_fiesta_lv_exp{id = 501,act_id = 5,lv = 104,exp = 10400,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(501,105) ->
	#base_fiesta_lv_exp{id = 501,act_id = 5,lv = 105,exp = 10500,reward = [{0,23020001,4}],premium_reward = [{0,38040041,5}]};

get_base_fiesta_lv_exp(501,106) ->
	#base_fiesta_lv_exp{id = 501,act_id = 5,lv = 106,exp = 10600,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(501,107) ->
	#base_fiesta_lv_exp{id = 501,act_id = 5,lv = 107,exp = 10700,reward = [{0,23020001,4}],premium_reward = [{0,38040041,5}]};

get_base_fiesta_lv_exp(501,108) ->
	#base_fiesta_lv_exp{id = 501,act_id = 5,lv = 108,exp = 10800,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(501,109) ->
	#base_fiesta_lv_exp{id = 501,act_id = 5,lv = 109,exp = 10900,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(501,110) ->
	#base_fiesta_lv_exp{id = 501,act_id = 5,lv = 110,exp = 11000,reward = [{0,23020001,4}],premium_reward = [{0,38040041,5}]};

get_base_fiesta_lv_exp(501,111) ->
	#base_fiesta_lv_exp{id = 501,act_id = 5,lv = 111,exp = 11100,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(501,112) ->
	#base_fiesta_lv_exp{id = 501,act_id = 5,lv = 112,exp = 11200,reward = [{0,23020001,4}],premium_reward = [{0,38040041,5}]};

get_base_fiesta_lv_exp(501,113) ->
	#base_fiesta_lv_exp{id = 501,act_id = 5,lv = 113,exp = 11300,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(501,114) ->
	#base_fiesta_lv_exp{id = 501,act_id = 5,lv = 114,exp = 11400,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(501,115) ->
	#base_fiesta_lv_exp{id = 501,act_id = 5,lv = 115,exp = 11500,reward = [{0,23020001,4}],premium_reward = [{0,38040041,5}]};

get_base_fiesta_lv_exp(501,116) ->
	#base_fiesta_lv_exp{id = 501,act_id = 5,lv = 116,exp = 11600,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(501,117) ->
	#base_fiesta_lv_exp{id = 501,act_id = 5,lv = 117,exp = 11700,reward = [{0,23020001,4}],premium_reward = [{0,38040041,5}]};

get_base_fiesta_lv_exp(501,118) ->
	#base_fiesta_lv_exp{id = 501,act_id = 5,lv = 118,exp = 11800,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(501,119) ->
	#base_fiesta_lv_exp{id = 501,act_id = 5,lv = 119,exp = 11900,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(501,120) ->
	#base_fiesta_lv_exp{id = 501,act_id = 5,lv = 120,exp = 12000,reward = [{0,23020001,4}],premium_reward = [{0,38040041,5}]};

get_base_fiesta_lv_exp(501,121) ->
	#base_fiesta_lv_exp{id = 501,act_id = 5,lv = 121,exp = 12100,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(501,122) ->
	#base_fiesta_lv_exp{id = 501,act_id = 5,lv = 122,exp = 12200,reward = [{0,23020001,4}],premium_reward = [{0,38040041,5}]};

get_base_fiesta_lv_exp(501,123) ->
	#base_fiesta_lv_exp{id = 501,act_id = 5,lv = 123,exp = 12300,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(501,124) ->
	#base_fiesta_lv_exp{id = 501,act_id = 5,lv = 124,exp = 12400,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(501,125) ->
	#base_fiesta_lv_exp{id = 501,act_id = 5,lv = 125,exp = 12500,reward = [{0,23020001,4}],premium_reward = [{0,38040041,5}]};

get_base_fiesta_lv_exp(501,126) ->
	#base_fiesta_lv_exp{id = 501,act_id = 5,lv = 126,exp = 12600,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(501,127) ->
	#base_fiesta_lv_exp{id = 501,act_id = 5,lv = 127,exp = 12700,reward = [{0,23020001,4}],premium_reward = [{0,38040041,5}]};

get_base_fiesta_lv_exp(501,128) ->
	#base_fiesta_lv_exp{id = 501,act_id = 5,lv = 128,exp = 12800,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(501,129) ->
	#base_fiesta_lv_exp{id = 501,act_id = 5,lv = 129,exp = 12900,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(501,130) ->
	#base_fiesta_lv_exp{id = 501,act_id = 5,lv = 130,exp = 13000,reward = [{0,23020001,4}],premium_reward = [{0,38040041,5}]};

get_base_fiesta_lv_exp(501,131) ->
	#base_fiesta_lv_exp{id = 501,act_id = 5,lv = 131,exp = 13100,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(501,132) ->
	#base_fiesta_lv_exp{id = 501,act_id = 5,lv = 132,exp = 13200,reward = [{0,23020001,4}],premium_reward = [{0,38040041,5}]};

get_base_fiesta_lv_exp(501,133) ->
	#base_fiesta_lv_exp{id = 501,act_id = 5,lv = 133,exp = 13300,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(501,134) ->
	#base_fiesta_lv_exp{id = 501,act_id = 5,lv = 134,exp = 13400,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(501,135) ->
	#base_fiesta_lv_exp{id = 501,act_id = 5,lv = 135,exp = 13500,reward = [{0,23020001,4}],premium_reward = [{0,38040041,5}]};

get_base_fiesta_lv_exp(501,136) ->
	#base_fiesta_lv_exp{id = 501,act_id = 5,lv = 136,exp = 13600,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(501,137) ->
	#base_fiesta_lv_exp{id = 501,act_id = 5,lv = 137,exp = 13700,reward = [{0,23020001,4}],premium_reward = [{0,38040041,5}]};

get_base_fiesta_lv_exp(501,138) ->
	#base_fiesta_lv_exp{id = 501,act_id = 5,lv = 138,exp = 13800,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(501,139) ->
	#base_fiesta_lv_exp{id = 501,act_id = 5,lv = 139,exp = 13900,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(501,140) ->
	#base_fiesta_lv_exp{id = 501,act_id = 5,lv = 140,exp = 14000,reward = [{0,23020001,4}],premium_reward = [{0,38040041,5}]};

get_base_fiesta_lv_exp(501,141) ->
	#base_fiesta_lv_exp{id = 501,act_id = 5,lv = 141,exp = 14100,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(501,142) ->
	#base_fiesta_lv_exp{id = 501,act_id = 5,lv = 142,exp = 14200,reward = [{0,23020001,4}],premium_reward = [{0,38040041,5}]};

get_base_fiesta_lv_exp(501,143) ->
	#base_fiesta_lv_exp{id = 501,act_id = 5,lv = 143,exp = 14300,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(501,144) ->
	#base_fiesta_lv_exp{id = 501,act_id = 5,lv = 144,exp = 14400,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(501,145) ->
	#base_fiesta_lv_exp{id = 501,act_id = 5,lv = 145,exp = 14500,reward = [{0,23020001,4}],premium_reward = [{0,38040041,5}]};

get_base_fiesta_lv_exp(501,146) ->
	#base_fiesta_lv_exp{id = 501,act_id = 5,lv = 146,exp = 14600,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(501,147) ->
	#base_fiesta_lv_exp{id = 501,act_id = 5,lv = 147,exp = 14700,reward = [{0,23020001,4}],premium_reward = [{0,38040041,5}]};

get_base_fiesta_lv_exp(501,148) ->
	#base_fiesta_lv_exp{id = 501,act_id = 5,lv = 148,exp = 14800,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(501,149) ->
	#base_fiesta_lv_exp{id = 501,act_id = 5,lv = 149,exp = 14900,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(501,150) ->
	#base_fiesta_lv_exp{id = 501,act_id = 5,lv = 150,exp = 15000,reward = [{0,23020001,4}],premium_reward = [{0,38040041,5}]};

get_base_fiesta_lv_exp(502,1) ->
	#base_fiesta_lv_exp{id = 502,act_id = 5,lv = 1,exp = 100,reward = [{0,19020001,2}],premium_reward = [{0,19020002,1}]};

get_base_fiesta_lv_exp(502,2) ->
	#base_fiesta_lv_exp{id = 502,act_id = 5,lv = 2,exp = 200,reward = [{0,38040005,20}],premium_reward = [{0,38040005,30}]};

get_base_fiesta_lv_exp(502,3) ->
	#base_fiesta_lv_exp{id = 502,act_id = 5,lv = 3,exp = 300,reward = [{0,19020001,2}],premium_reward = [{0,19020002,1}]};

get_base_fiesta_lv_exp(502,4) ->
	#base_fiesta_lv_exp{id = 502,act_id = 5,lv = 4,exp = 400,reward = [{0,38370001,1}],premium_reward = [{0,38160001,1}]};

get_base_fiesta_lv_exp(502,5) ->
	#base_fiesta_lv_exp{id = 502,act_id = 5,lv = 5,exp = 500,reward = [{0,37020001,2}],premium_reward = [{0,37121002,1}]};

get_base_fiesta_lv_exp(502,6) ->
	#base_fiesta_lv_exp{id = 502,act_id = 5,lv = 6,exp = 600,reward = [{0,32010119,1}],premium_reward = [{0,32010120,1}]};

get_base_fiesta_lv_exp(502,7) ->
	#base_fiesta_lv_exp{id = 502,act_id = 5,lv = 7,exp = 700,reward = [{0,38030005,1}],premium_reward = [{0,38030004,2}]};

get_base_fiesta_lv_exp(502,8) ->
	#base_fiesta_lv_exp{id = 502,act_id = 5,lv = 8,exp = 800,reward = [{0,19020001,2}],premium_reward = [{0,19020002,1}]};

get_base_fiesta_lv_exp(502,9) ->
	#base_fiesta_lv_exp{id = 502,act_id = 5,lv = 9,exp = 900,reward = [{0,38100002,2}],premium_reward = [{0,38100002,5}]};

get_base_fiesta_lv_exp(502,10) ->
	#base_fiesta_lv_exp{id = 502,act_id = 5,lv = 10,exp = 1000,reward = [{0,39510021,1}],premium_reward = [{0,35,128}]};

get_base_fiesta_lv_exp(502,11) ->
	#base_fiesta_lv_exp{id = 502,act_id = 5,lv = 11,exp = 1100,reward = [{0,19020001,2}],premium_reward = [{0,19020002,1}]};

get_base_fiesta_lv_exp(502,12) ->
	#base_fiesta_lv_exp{id = 502,act_id = 5,lv = 12,exp = 1200,reward = [{0,38100002,2}],premium_reward = [{0,38100002,5}]};

get_base_fiesta_lv_exp(502,13) ->
	#base_fiesta_lv_exp{id = 502,act_id = 5,lv = 13,exp = 1300,reward = [{0,38040005,20}],premium_reward = [{0,38040027,1}]};

get_base_fiesta_lv_exp(502,14) ->
	#base_fiesta_lv_exp{id = 502,act_id = 5,lv = 14,exp = 1400,reward = [{0,32010119,1}],premium_reward = [{0,32010120,1}]};

get_base_fiesta_lv_exp(502,15) ->
	#base_fiesta_lv_exp{id = 502,act_id = 5,lv = 15,exp = 1500,reward = [{0,38160001,1}],premium_reward = [{0,37020002,1}]};

get_base_fiesta_lv_exp(502,16) ->
	#base_fiesta_lv_exp{id = 502,act_id = 5,lv = 16,exp = 1600,reward = [{0,32010001,1}],premium_reward = [{0,32010002,1}]};

get_base_fiesta_lv_exp(502,17) ->
	#base_fiesta_lv_exp{id = 502,act_id = 5,lv = 17,exp = 1700,reward = [{0,19020001,2}],premium_reward = [{0,19020002,2}]};

get_base_fiesta_lv_exp(502,18) ->
	#base_fiesta_lv_exp{id = 502,act_id = 5,lv = 18,exp = 1800,reward = [{0,38100002,2}],premium_reward = [{0,38100002,5}]};

get_base_fiesta_lv_exp(502,19) ->
	#base_fiesta_lv_exp{id = 502,act_id = 5,lv = 19,exp = 1900,reward = [{0,32010001,1}],premium_reward = [{0,32010002,1}]};

get_base_fiesta_lv_exp(502,20) ->
	#base_fiesta_lv_exp{id = 502,act_id = 5,lv = 20,exp = 2000,reward = [{0,18010001,1}],premium_reward = [{0,37121003,1}]};

get_base_fiesta_lv_exp(502,21) ->
	#base_fiesta_lv_exp{id = 502,act_id = 5,lv = 21,exp = 2100,reward = [{0,20020001,2}],premium_reward = [{0,20020002,1}]};

get_base_fiesta_lv_exp(502,22) ->
	#base_fiesta_lv_exp{id = 502,act_id = 5,lv = 22,exp = 2200,reward = [{0,38100002,2}],premium_reward = [{0,38100002,5}]};

get_base_fiesta_lv_exp(502,23) ->
	#base_fiesta_lv_exp{id = 502,act_id = 5,lv = 23,exp = 2300,reward = [{0,32010001,1}],premium_reward = [{0,32010002,1}]};

get_base_fiesta_lv_exp(502,24) ->
	#base_fiesta_lv_exp{id = 502,act_id = 5,lv = 24,exp = 2400,reward = [{0,20020001,2}],premium_reward = [{0,20020002,1}]};

get_base_fiesta_lv_exp(502,25) ->
	#base_fiesta_lv_exp{id = 502,act_id = 5,lv = 25,exp = 2500,reward = [{0,19020001,2}],premium_reward = [{0,19020002,1}]};

get_base_fiesta_lv_exp(502,26) ->
	#base_fiesta_lv_exp{id = 502,act_id = 5,lv = 26,exp = 2600,reward = [{0,32010119,1}],premium_reward = [{0,32010120,1}]};

get_base_fiesta_lv_exp(502,27) ->
	#base_fiesta_lv_exp{id = 502,act_id = 5,lv = 27,exp = 2700,reward = [{0,38030005,1}],premium_reward = [{0,38030004,2}]};

get_base_fiesta_lv_exp(502,28) ->
	#base_fiesta_lv_exp{id = 502,act_id = 5,lv = 28,exp = 2800,reward = [{0,20020001,2}],premium_reward = [{0,20020002,1}]};

get_base_fiesta_lv_exp(502,29) ->
	#base_fiesta_lv_exp{id = 502,act_id = 5,lv = 29,exp = 2900,reward = [{0,38040005,20}],premium_reward = [{0,38040005,50}]};

get_base_fiesta_lv_exp(502,30) ->
	#base_fiesta_lv_exp{id = 502,act_id = 5,lv = 30,exp = 3000,reward = [{0,18010001,1}],premium_reward = [{0,35,188}]};

get_base_fiesta_lv_exp(502,31) ->
	#base_fiesta_lv_exp{id = 502,act_id = 5,lv = 31,exp = 3100,reward = [{0,32010119,1}],premium_reward = [{0,32010120,1}]};

get_base_fiesta_lv_exp(502,32) ->
	#base_fiesta_lv_exp{id = 502,act_id = 5,lv = 32,exp = 3200,reward = [{0,38370002,1}],premium_reward = [{0,38030004,1}]};

get_base_fiesta_lv_exp(502,33) ->
	#base_fiesta_lv_exp{id = 502,act_id = 5,lv = 33,exp = 3300,reward = [{0,38040005,20}],premium_reward = [{0,38040027,1}]};

get_base_fiesta_lv_exp(502,34) ->
	#base_fiesta_lv_exp{id = 502,act_id = 5,lv = 34,exp = 3400,reward = [{0,38100002,2}],premium_reward = [{0,38100002,5}]};

get_base_fiesta_lv_exp(502,35) ->
	#base_fiesta_lv_exp{id = 502,act_id = 5,lv = 35,exp = 3500,reward = [{0,32010001,2}],premium_reward = [{0,32010002,2}]};

get_base_fiesta_lv_exp(502,36) ->
	#base_fiesta_lv_exp{id = 502,act_id = 5,lv = 36,exp = 3600,reward = [{0,20020001,2}],premium_reward = [{0,20020002,1}]};

get_base_fiesta_lv_exp(502,37) ->
	#base_fiesta_lv_exp{id = 502,act_id = 5,lv = 37,exp = 3700,reward = [{0,32010001,2}],premium_reward = [{0,32010002,2}]};

get_base_fiesta_lv_exp(502,38) ->
	#base_fiesta_lv_exp{id = 502,act_id = 5,lv = 38,exp = 3800,reward = [{0,32010119,1}],premium_reward = [{0,32010120,1}]};

get_base_fiesta_lv_exp(502,39) ->
	#base_fiesta_lv_exp{id = 502,act_id = 5,lv = 39,exp = 3900,reward = [{0,20020001,2}],premium_reward = [{0,20020002,1}]};

get_base_fiesta_lv_exp(502,40) ->
	#base_fiesta_lv_exp{id = 502,act_id = 5,lv = 40,exp = 4000,reward = [{0,6101003,1}],premium_reward = [{0,6101004,1}]};

get_base_fiesta_lv_exp(502,41) ->
	#base_fiesta_lv_exp{id = 502,act_id = 5,lv = 41,exp = 4100,reward = [{0,19020001,2}],premium_reward = [{0,19020002,1}]};

get_base_fiesta_lv_exp(502,42) ->
	#base_fiesta_lv_exp{id = 502,act_id = 5,lv = 42,exp = 4200,reward = [{0,38100002,2}],premium_reward = [{0,38100002,5}]};

get_base_fiesta_lv_exp(502,43) ->
	#base_fiesta_lv_exp{id = 502,act_id = 5,lv = 43,exp = 4300,reward = [{0,38040005,20}],premium_reward = [{0,38040027,1}]};

get_base_fiesta_lv_exp(502,44) ->
	#base_fiesta_lv_exp{id = 502,act_id = 5,lv = 44,exp = 4400,reward = [{0,32010119,1}],premium_reward = [{0,32010120,1}]};

get_base_fiesta_lv_exp(502,45) ->
	#base_fiesta_lv_exp{id = 502,act_id = 5,lv = 45,exp = 4500,reward = [{0,38160001,1}],premium_reward = [{0,37020002,1}]};

get_base_fiesta_lv_exp(502,46) ->
	#base_fiesta_lv_exp{id = 502,act_id = 5,lv = 46,exp = 4600,reward = [{0,32010001,2}],premium_reward = [{0,32010002,2}]};

get_base_fiesta_lv_exp(502,47) ->
	#base_fiesta_lv_exp{id = 502,act_id = 5,lv = 47,exp = 4700,reward = [{0,19020001,2}],premium_reward = [{0,19020002,2}]};

get_base_fiesta_lv_exp(502,48) ->
	#base_fiesta_lv_exp{id = 502,act_id = 5,lv = 48,exp = 4800,reward = [{0,38100002,2}],premium_reward = [{0,38100002,5}]};

get_base_fiesta_lv_exp(502,49) ->
	#base_fiesta_lv_exp{id = 502,act_id = 5,lv = 49,exp = 4900,reward = [{0,38040005,20}],premium_reward = [{0,38040005,50}]};

get_base_fiesta_lv_exp(502,50) ->
	#base_fiesta_lv_exp{id = 502,act_id = 5,lv = 50,exp = 5000,reward = [{0,18010002,1}],premium_reward = [{0,32010517,1}]};

get_base_fiesta_lv_exp(502,51) ->
	#base_fiesta_lv_exp{id = 502,act_id = 5,lv = 51,exp = 5100,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(502,52) ->
	#base_fiesta_lv_exp{id = 502,act_id = 5,lv = 52,exp = 5200,reward = [{0,38100002,2}],premium_reward = [{0,38100002,5}]};

get_base_fiesta_lv_exp(502,53) ->
	#base_fiesta_lv_exp{id = 502,act_id = 5,lv = 53,exp = 5300,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(502,54) ->
	#base_fiesta_lv_exp{id = 502,act_id = 5,lv = 54,exp = 5400,reward = [{0,20020001,2}],premium_reward = [{0,20020002,1}]};

get_base_fiesta_lv_exp(502,55) ->
	#base_fiesta_lv_exp{id = 502,act_id = 5,lv = 55,exp = 5500,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(502,56) ->
	#base_fiesta_lv_exp{id = 502,act_id = 5,lv = 56,exp = 5600,reward = [{0,32010119,2}],premium_reward = [{0,32010120,1}]};

get_base_fiesta_lv_exp(502,57) ->
	#base_fiesta_lv_exp{id = 502,act_id = 5,lv = 57,exp = 5700,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(502,58) ->
	#base_fiesta_lv_exp{id = 502,act_id = 5,lv = 58,exp = 5800,reward = [{0,20020001,2}],premium_reward = [{0,20020002,1}]};

get_base_fiesta_lv_exp(502,59) ->
	#base_fiesta_lv_exp{id = 502,act_id = 5,lv = 59,exp = 5900,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(502,60) ->
	#base_fiesta_lv_exp{id = 502,act_id = 5,lv = 60,exp = 6000,reward = [{0,18010002,1}],premium_reward = [{0,35,268}]};

get_base_fiesta_lv_exp(502,61) ->
	#base_fiesta_lv_exp{id = 502,act_id = 5,lv = 61,exp = 6100,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(502,62) ->
	#base_fiesta_lv_exp{id = 502,act_id = 5,lv = 62,exp = 6200,reward = [{0,38370002,1}],premium_reward = [{0,38030004,1}]};

get_base_fiesta_lv_exp(502,63) ->
	#base_fiesta_lv_exp{id = 502,act_id = 5,lv = 63,exp = 6300,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(502,64) ->
	#base_fiesta_lv_exp{id = 502,act_id = 5,lv = 64,exp = 6400,reward = [{0,38100002,2}],premium_reward = [{0,38100002,5}]};

get_base_fiesta_lv_exp(502,65) ->
	#base_fiesta_lv_exp{id = 502,act_id = 5,lv = 65,exp = 6500,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(502,66) ->
	#base_fiesta_lv_exp{id = 502,act_id = 5,lv = 66,exp = 6600,reward = [{0,20020001,2}],premium_reward = [{0,20020002,1}]};

get_base_fiesta_lv_exp(502,67) ->
	#base_fiesta_lv_exp{id = 502,act_id = 5,lv = 67,exp = 6700,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(502,68) ->
	#base_fiesta_lv_exp{id = 502,act_id = 5,lv = 68,exp = 6800,reward = [{0,32010119,2}],premium_reward = [{0,32010120,1}]};

get_base_fiesta_lv_exp(502,69) ->
	#base_fiesta_lv_exp{id = 502,act_id = 5,lv = 69,exp = 6900,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(502,70) ->
	#base_fiesta_lv_exp{id = 502,act_id = 5,lv = 70,exp = 7000,reward = [{0,34010390,1}],premium_reward = [{0,6102001,1}]};

get_base_fiesta_lv_exp(502,71) ->
	#base_fiesta_lv_exp{id = 502,act_id = 5,lv = 71,exp = 7100,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(502,72) ->
	#base_fiesta_lv_exp{id = 502,act_id = 5,lv = 72,exp = 7200,reward = [{0,38100002,2}],premium_reward = [{0,38100002,5}]};

get_base_fiesta_lv_exp(502,73) ->
	#base_fiesta_lv_exp{id = 502,act_id = 5,lv = 73,exp = 7300,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(502,74) ->
	#base_fiesta_lv_exp{id = 502,act_id = 5,lv = 74,exp = 7400,reward = [{0,32010119,2}],premium_reward = [{0,32010120,1}]};

get_base_fiesta_lv_exp(502,75) ->
	#base_fiesta_lv_exp{id = 502,act_id = 5,lv = 75,exp = 7500,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(502,76) ->
	#base_fiesta_lv_exp{id = 502,act_id = 5,lv = 76,exp = 7600,reward = [{0,32010002,2}],premium_reward = [{0,32010003,2}]};

get_base_fiesta_lv_exp(502,77) ->
	#base_fiesta_lv_exp{id = 502,act_id = 5,lv = 77,exp = 7700,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(502,78) ->
	#base_fiesta_lv_exp{id = 502,act_id = 5,lv = 78,exp = 7800,reward = [{0,38100002,2}],premium_reward = [{0,38100002,5}]};

get_base_fiesta_lv_exp(502,79) ->
	#base_fiesta_lv_exp{id = 502,act_id = 5,lv = 79,exp = 7900,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(502,80) ->
	#base_fiesta_lv_exp{id = 502,act_id = 5,lv = 80,exp = 8000,reward = [{0,32010141,1}],premium_reward = [{0,35,368}]};

get_base_fiesta_lv_exp(502,81) ->
	#base_fiesta_lv_exp{id = 502,act_id = 5,lv = 81,exp = 8100,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(502,82) ->
	#base_fiesta_lv_exp{id = 502,act_id = 5,lv = 82,exp = 8200,reward = [{0,38370002,1}],premium_reward = [{0,38030004,1}]};

get_base_fiesta_lv_exp(502,83) ->
	#base_fiesta_lv_exp{id = 502,act_id = 5,lv = 83,exp = 8300,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(502,84) ->
	#base_fiesta_lv_exp{id = 502,act_id = 5,lv = 84,exp = 8400,reward = [{0,38100002,2}],premium_reward = [{0,38100002,5}]};

get_base_fiesta_lv_exp(502,85) ->
	#base_fiesta_lv_exp{id = 502,act_id = 5,lv = 85,exp = 8500,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(502,86) ->
	#base_fiesta_lv_exp{id = 502,act_id = 5,lv = 86,exp = 8600,reward = [{0,20020001,2}],premium_reward = [{0,20020002,1}]};

get_base_fiesta_lv_exp(502,87) ->
	#base_fiesta_lv_exp{id = 502,act_id = 5,lv = 87,exp = 8700,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(502,88) ->
	#base_fiesta_lv_exp{id = 502,act_id = 5,lv = 88,exp = 8800,reward = [{0,32010119,3}],premium_reward = [{0,32010120,2}]};

get_base_fiesta_lv_exp(502,89) ->
	#base_fiesta_lv_exp{id = 502,act_id = 5,lv = 89,exp = 8900,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(502,90) ->
	#base_fiesta_lv_exp{id = 502,act_id = 5,lv = 90,exp = 9000,reward = [{0,18010003,1}],premium_reward = [{0,32010517,1}]};

get_base_fiesta_lv_exp(502,91) ->
	#base_fiesta_lv_exp{id = 502,act_id = 5,lv = 91,exp = 9100,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(502,92) ->
	#base_fiesta_lv_exp{id = 502,act_id = 5,lv = 92,exp = 9200,reward = [{0,38100002,2}],premium_reward = [{0,38100002,5}]};

get_base_fiesta_lv_exp(502,93) ->
	#base_fiesta_lv_exp{id = 502,act_id = 5,lv = 93,exp = 9300,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(502,94) ->
	#base_fiesta_lv_exp{id = 502,act_id = 5,lv = 94,exp = 9400,reward = [{0,20020001,2}],premium_reward = [{0,20020002,1}]};

get_base_fiesta_lv_exp(502,95) ->
	#base_fiesta_lv_exp{id = 502,act_id = 5,lv = 95,exp = 9500,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(502,96) ->
	#base_fiesta_lv_exp{id = 502,act_id = 5,lv = 96,exp = 9600,reward = [{0,32010119,3}],premium_reward = [{0,32010120,3}]};

get_base_fiesta_lv_exp(502,97) ->
	#base_fiesta_lv_exp{id = 502,act_id = 5,lv = 97,exp = 9700,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(502,98) ->
	#base_fiesta_lv_exp{id = 502,act_id = 5,lv = 98,exp = 9800,reward = [{0,20020001,2}],premium_reward = [{0,20020002,1}]};

get_base_fiesta_lv_exp(502,99) ->
	#base_fiesta_lv_exp{id = 502,act_id = 5,lv = 99,exp = 9900,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(502,100) ->
	#base_fiesta_lv_exp{id = 502,act_id = 5,lv = 100,exp = 10000,reward = [{0,35,128}],premium_reward = [{0,18030115,30}]};

get_base_fiesta_lv_exp(502,101) ->
	#base_fiesta_lv_exp{id = 502,act_id = 5,lv = 101,exp = 10100,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(502,102) ->
	#base_fiesta_lv_exp{id = 502,act_id = 5,lv = 102,exp = 10200,reward = [{0,39510000,4}],premium_reward = [{0,39510000,10}]};

get_base_fiesta_lv_exp(502,103) ->
	#base_fiesta_lv_exp{id = 502,act_id = 5,lv = 103,exp = 10300,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(502,104) ->
	#base_fiesta_lv_exp{id = 502,act_id = 5,lv = 104,exp = 10400,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(502,105) ->
	#base_fiesta_lv_exp{id = 502,act_id = 5,lv = 105,exp = 10500,reward = [{0,38040018,4}],premium_reward = [{0,38040018,10}]};

get_base_fiesta_lv_exp(502,106) ->
	#base_fiesta_lv_exp{id = 502,act_id = 5,lv = 106,exp = 10600,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(502,107) ->
	#base_fiesta_lv_exp{id = 502,act_id = 5,lv = 107,exp = 10700,reward = [{0,39510000,4}],premium_reward = [{0,39510000,10}]};

get_base_fiesta_lv_exp(502,108) ->
	#base_fiesta_lv_exp{id = 502,act_id = 5,lv = 108,exp = 10800,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(502,109) ->
	#base_fiesta_lv_exp{id = 502,act_id = 5,lv = 109,exp = 10900,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(502,110) ->
	#base_fiesta_lv_exp{id = 502,act_id = 5,lv = 110,exp = 11000,reward = [{0,38040018,4}],premium_reward = [{0,38040018,10}]};

get_base_fiesta_lv_exp(502,111) ->
	#base_fiesta_lv_exp{id = 502,act_id = 5,lv = 111,exp = 11100,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(502,112) ->
	#base_fiesta_lv_exp{id = 502,act_id = 5,lv = 112,exp = 11200,reward = [{0,39510000,4}],premium_reward = [{0,39510000,10}]};

get_base_fiesta_lv_exp(502,113) ->
	#base_fiesta_lv_exp{id = 502,act_id = 5,lv = 113,exp = 11300,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(502,114) ->
	#base_fiesta_lv_exp{id = 502,act_id = 5,lv = 114,exp = 11400,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(502,115) ->
	#base_fiesta_lv_exp{id = 502,act_id = 5,lv = 115,exp = 11500,reward = [{0,38040018,4}],premium_reward = [{0,38040018,10}]};

get_base_fiesta_lv_exp(502,116) ->
	#base_fiesta_lv_exp{id = 502,act_id = 5,lv = 116,exp = 11600,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(502,117) ->
	#base_fiesta_lv_exp{id = 502,act_id = 5,lv = 117,exp = 11700,reward = [{0,39510000,4}],premium_reward = [{0,39510000,10}]};

get_base_fiesta_lv_exp(502,118) ->
	#base_fiesta_lv_exp{id = 502,act_id = 5,lv = 118,exp = 11800,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(502,119) ->
	#base_fiesta_lv_exp{id = 502,act_id = 5,lv = 119,exp = 11900,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(502,120) ->
	#base_fiesta_lv_exp{id = 502,act_id = 5,lv = 120,exp = 12000,reward = [{0,38040018,4}],premium_reward = [{0,38040018,10}]};

get_base_fiesta_lv_exp(502,121) ->
	#base_fiesta_lv_exp{id = 502,act_id = 5,lv = 121,exp = 12100,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(502,122) ->
	#base_fiesta_lv_exp{id = 502,act_id = 5,lv = 122,exp = 12200,reward = [{0,39510000,4}],premium_reward = [{0,39510000,10}]};

get_base_fiesta_lv_exp(502,123) ->
	#base_fiesta_lv_exp{id = 502,act_id = 5,lv = 123,exp = 12300,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(502,124) ->
	#base_fiesta_lv_exp{id = 502,act_id = 5,lv = 124,exp = 12400,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(502,125) ->
	#base_fiesta_lv_exp{id = 502,act_id = 5,lv = 125,exp = 12500,reward = [{0,38040018,4}],premium_reward = [{0,38040018,10}]};

get_base_fiesta_lv_exp(502,126) ->
	#base_fiesta_lv_exp{id = 502,act_id = 5,lv = 126,exp = 12600,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(502,127) ->
	#base_fiesta_lv_exp{id = 502,act_id = 5,lv = 127,exp = 12700,reward = [{0,39510000,4}],premium_reward = [{0,39510000,10}]};

get_base_fiesta_lv_exp(502,128) ->
	#base_fiesta_lv_exp{id = 502,act_id = 5,lv = 128,exp = 12800,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(502,129) ->
	#base_fiesta_lv_exp{id = 502,act_id = 5,lv = 129,exp = 12900,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(502,130) ->
	#base_fiesta_lv_exp{id = 502,act_id = 5,lv = 130,exp = 13000,reward = [{0,38040018,4}],premium_reward = [{0,38040018,10}]};

get_base_fiesta_lv_exp(502,131) ->
	#base_fiesta_lv_exp{id = 502,act_id = 5,lv = 131,exp = 13100,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(502,132) ->
	#base_fiesta_lv_exp{id = 502,act_id = 5,lv = 132,exp = 13200,reward = [{0,39510000,4}],premium_reward = [{0,39510000,10}]};

get_base_fiesta_lv_exp(502,133) ->
	#base_fiesta_lv_exp{id = 502,act_id = 5,lv = 133,exp = 13300,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(502,134) ->
	#base_fiesta_lv_exp{id = 502,act_id = 5,lv = 134,exp = 13400,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(502,135) ->
	#base_fiesta_lv_exp{id = 502,act_id = 5,lv = 135,exp = 13500,reward = [{0,38040018,4}],premium_reward = [{0,38040018,10}]};

get_base_fiesta_lv_exp(502,136) ->
	#base_fiesta_lv_exp{id = 502,act_id = 5,lv = 136,exp = 13600,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(502,137) ->
	#base_fiesta_lv_exp{id = 502,act_id = 5,lv = 137,exp = 13700,reward = [{0,39510000,4}],premium_reward = [{0,39510000,10}]};

get_base_fiesta_lv_exp(502,138) ->
	#base_fiesta_lv_exp{id = 502,act_id = 5,lv = 138,exp = 13800,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(502,139) ->
	#base_fiesta_lv_exp{id = 502,act_id = 5,lv = 139,exp = 13900,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(502,140) ->
	#base_fiesta_lv_exp{id = 502,act_id = 5,lv = 140,exp = 14000,reward = [{0,38040018,4}],premium_reward = [{0,38040018,10}]};

get_base_fiesta_lv_exp(502,141) ->
	#base_fiesta_lv_exp{id = 502,act_id = 5,lv = 141,exp = 14100,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(502,142) ->
	#base_fiesta_lv_exp{id = 502,act_id = 5,lv = 142,exp = 14200,reward = [{0,39510000,4}],premium_reward = [{0,39510000,10}]};

get_base_fiesta_lv_exp(502,143) ->
	#base_fiesta_lv_exp{id = 502,act_id = 5,lv = 143,exp = 14300,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(502,144) ->
	#base_fiesta_lv_exp{id = 502,act_id = 5,lv = 144,exp = 14400,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(502,145) ->
	#base_fiesta_lv_exp{id = 502,act_id = 5,lv = 145,exp = 14500,reward = [{0,38040018,4}],premium_reward = [{0,38040018,10}]};

get_base_fiesta_lv_exp(502,146) ->
	#base_fiesta_lv_exp{id = 502,act_id = 5,lv = 146,exp = 14600,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(502,147) ->
	#base_fiesta_lv_exp{id = 502,act_id = 5,lv = 147,exp = 14700,reward = [{0,39510000,4}],premium_reward = [{0,39510000,10}]};

get_base_fiesta_lv_exp(502,148) ->
	#base_fiesta_lv_exp{id = 502,act_id = 5,lv = 148,exp = 14800,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(502,149) ->
	#base_fiesta_lv_exp{id = 502,act_id = 5,lv = 149,exp = 14900,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(502,150) ->
	#base_fiesta_lv_exp{id = 502,act_id = 5,lv = 150,exp = 15000,reward = [{0,38040018,4}],premium_reward = [{0,38040018,10}]};

get_base_fiesta_lv_exp(503,1) ->
	#base_fiesta_lv_exp{id = 503,act_id = 5,lv = 1,exp = 100,reward = [{0,7301001,2}],premium_reward = [{0,7301002,1}]};

get_base_fiesta_lv_exp(503,2) ->
	#base_fiesta_lv_exp{id = 503,act_id = 5,lv = 2,exp = 200,reward = [{0,38040005,20}],premium_reward = [{0,38040005,30}]};

get_base_fiesta_lv_exp(503,3) ->
	#base_fiesta_lv_exp{id = 503,act_id = 5,lv = 3,exp = 300,reward = [{0,7301001,2}],premium_reward = [{0,7301002,1}]};

get_base_fiesta_lv_exp(503,4) ->
	#base_fiesta_lv_exp{id = 503,act_id = 5,lv = 4,exp = 400,reward = [{0,38370001,1}],premium_reward = [{0,38160001,1}]};

get_base_fiesta_lv_exp(503,5) ->
	#base_fiesta_lv_exp{id = 503,act_id = 5,lv = 5,exp = 500,reward = [{0,37020001,2}],premium_reward = [{0,37121002,1}]};

get_base_fiesta_lv_exp(503,6) ->
	#base_fiesta_lv_exp{id = 503,act_id = 5,lv = 6,exp = 600,reward = [{0,32010119,1}],premium_reward = [{0,32010120,1}]};

get_base_fiesta_lv_exp(503,7) ->
	#base_fiesta_lv_exp{id = 503,act_id = 5,lv = 7,exp = 700,reward = [{0,38030005,1}],premium_reward = [{0,38030004,2}]};

get_base_fiesta_lv_exp(503,8) ->
	#base_fiesta_lv_exp{id = 503,act_id = 5,lv = 8,exp = 800,reward = [{0,7301001,2}],premium_reward = [{0,7301002,1}]};

get_base_fiesta_lv_exp(503,9) ->
	#base_fiesta_lv_exp{id = 503,act_id = 5,lv = 9,exp = 900,reward = [{0,38100002,2}],premium_reward = [{0,38100002,5}]};

get_base_fiesta_lv_exp(503,10) ->
	#base_fiesta_lv_exp{id = 503,act_id = 5,lv = 10,exp = 1000,reward = [{0,39510021,1}],premium_reward = [{0,35,128}]};

get_base_fiesta_lv_exp(503,11) ->
	#base_fiesta_lv_exp{id = 503,act_id = 5,lv = 11,exp = 1100,reward = [{0,7301001,2}],premium_reward = [{0,7301002,1}]};

get_base_fiesta_lv_exp(503,12) ->
	#base_fiesta_lv_exp{id = 503,act_id = 5,lv = 12,exp = 1200,reward = [{0,38100002,2}],premium_reward = [{0,38100002,5}]};

get_base_fiesta_lv_exp(503,13) ->
	#base_fiesta_lv_exp{id = 503,act_id = 5,lv = 13,exp = 1300,reward = [{0,38040005,20}],premium_reward = [{0,38040027,1}]};

get_base_fiesta_lv_exp(503,14) ->
	#base_fiesta_lv_exp{id = 503,act_id = 5,lv = 14,exp = 1400,reward = [{0,32010119,1}],premium_reward = [{0,32010120,1}]};

get_base_fiesta_lv_exp(503,15) ->
	#base_fiesta_lv_exp{id = 503,act_id = 5,lv = 15,exp = 1500,reward = [{0,38160001,1}],premium_reward = [{0,37020002,1}]};

get_base_fiesta_lv_exp(503,16) ->
	#base_fiesta_lv_exp{id = 503,act_id = 5,lv = 16,exp = 1600,reward = [{0,32010001,1}],premium_reward = [{0,32010002,1}]};

get_base_fiesta_lv_exp(503,17) ->
	#base_fiesta_lv_exp{id = 503,act_id = 5,lv = 17,exp = 1700,reward = [{0,7301001,2}],premium_reward = [{0,7301002,2}]};

get_base_fiesta_lv_exp(503,18) ->
	#base_fiesta_lv_exp{id = 503,act_id = 5,lv = 18,exp = 1800,reward = [{0,38100002,2}],premium_reward = [{0,38100002,5}]};

get_base_fiesta_lv_exp(503,19) ->
	#base_fiesta_lv_exp{id = 503,act_id = 5,lv = 19,exp = 1900,reward = [{0,32010001,1}],premium_reward = [{0,32010002,1}]};

get_base_fiesta_lv_exp(503,20) ->
	#base_fiesta_lv_exp{id = 503,act_id = 5,lv = 20,exp = 2000,reward = [{0,20010001,1}],premium_reward = [{0,37121003,1}]};

get_base_fiesta_lv_exp(503,21) ->
	#base_fiesta_lv_exp{id = 503,act_id = 5,lv = 21,exp = 2100,reward = [{0,7301003,2}],premium_reward = [{0,7301004,1}]};

get_base_fiesta_lv_exp(503,22) ->
	#base_fiesta_lv_exp{id = 503,act_id = 5,lv = 22,exp = 2200,reward = [{0,38100002,2}],premium_reward = [{0,38100002,5}]};

get_base_fiesta_lv_exp(503,23) ->
	#base_fiesta_lv_exp{id = 503,act_id = 5,lv = 23,exp = 2300,reward = [{0,32010001,1}],premium_reward = [{0,32010002,1}]};

get_base_fiesta_lv_exp(503,24) ->
	#base_fiesta_lv_exp{id = 503,act_id = 5,lv = 24,exp = 2400,reward = [{0,7301003,2}],premium_reward = [{0,7301004,1}]};

get_base_fiesta_lv_exp(503,25) ->
	#base_fiesta_lv_exp{id = 503,act_id = 5,lv = 25,exp = 2500,reward = [{0,7301001,2}],premium_reward = [{0,7301002,1}]};

get_base_fiesta_lv_exp(503,26) ->
	#base_fiesta_lv_exp{id = 503,act_id = 5,lv = 26,exp = 2600,reward = [{0,32010119,1}],premium_reward = [{0,32010120,1}]};

get_base_fiesta_lv_exp(503,27) ->
	#base_fiesta_lv_exp{id = 503,act_id = 5,lv = 27,exp = 2700,reward = [{0,38030005,1}],premium_reward = [{0,38030004,2}]};

get_base_fiesta_lv_exp(503,28) ->
	#base_fiesta_lv_exp{id = 503,act_id = 5,lv = 28,exp = 2800,reward = [{0,7301003,2}],premium_reward = [{0,7301004,1}]};

get_base_fiesta_lv_exp(503,29) ->
	#base_fiesta_lv_exp{id = 503,act_id = 5,lv = 29,exp = 2900,reward = [{0,38040005,20}],premium_reward = [{0,38040005,50}]};

get_base_fiesta_lv_exp(503,30) ->
	#base_fiesta_lv_exp{id = 503,act_id = 5,lv = 30,exp = 3000,reward = [{0,20010001,1}],premium_reward = [{0,35,188}]};

get_base_fiesta_lv_exp(503,31) ->
	#base_fiesta_lv_exp{id = 503,act_id = 5,lv = 31,exp = 3100,reward = [{0,32010119,1}],premium_reward = [{0,32010120,1}]};

get_base_fiesta_lv_exp(503,32) ->
	#base_fiesta_lv_exp{id = 503,act_id = 5,lv = 32,exp = 3200,reward = [{0,38370002,1}],premium_reward = [{0,38030004,1}]};

get_base_fiesta_lv_exp(503,33) ->
	#base_fiesta_lv_exp{id = 503,act_id = 5,lv = 33,exp = 3300,reward = [{0,38040005,20}],premium_reward = [{0,38040027,1}]};

get_base_fiesta_lv_exp(503,34) ->
	#base_fiesta_lv_exp{id = 503,act_id = 5,lv = 34,exp = 3400,reward = [{0,38100002,2}],premium_reward = [{0,38100002,5}]};

get_base_fiesta_lv_exp(503,35) ->
	#base_fiesta_lv_exp{id = 503,act_id = 5,lv = 35,exp = 3500,reward = [{0,32010001,2}],premium_reward = [{0,32010002,2}]};

get_base_fiesta_lv_exp(503,36) ->
	#base_fiesta_lv_exp{id = 503,act_id = 5,lv = 36,exp = 3600,reward = [{0,7301003,2}],premium_reward = [{0,7301004,1}]};

get_base_fiesta_lv_exp(503,37) ->
	#base_fiesta_lv_exp{id = 503,act_id = 5,lv = 37,exp = 3700,reward = [{0,32010001,2}],premium_reward = [{0,32010002,2}]};

get_base_fiesta_lv_exp(503,38) ->
	#base_fiesta_lv_exp{id = 503,act_id = 5,lv = 38,exp = 3800,reward = [{0,32010119,1}],premium_reward = [{0,32010120,1}]};

get_base_fiesta_lv_exp(503,39) ->
	#base_fiesta_lv_exp{id = 503,act_id = 5,lv = 39,exp = 3900,reward = [{0,7301003,2}],premium_reward = [{0,7301004,1}]};

get_base_fiesta_lv_exp(503,40) ->
	#base_fiesta_lv_exp{id = 503,act_id = 5,lv = 40,exp = 4000,reward = [{0,6101003,1}],premium_reward = [{0,6101004,1}]};

get_base_fiesta_lv_exp(503,41) ->
	#base_fiesta_lv_exp{id = 503,act_id = 5,lv = 41,exp = 4100,reward = [{0,7301001,2}],premium_reward = [{0,7301002,1}]};

get_base_fiesta_lv_exp(503,42) ->
	#base_fiesta_lv_exp{id = 503,act_id = 5,lv = 42,exp = 4200,reward = [{0,38100002,2}],premium_reward = [{0,38100002,5}]};

get_base_fiesta_lv_exp(503,43) ->
	#base_fiesta_lv_exp{id = 503,act_id = 5,lv = 43,exp = 4300,reward = [{0,38040005,20}],premium_reward = [{0,38040027,1}]};

get_base_fiesta_lv_exp(503,44) ->
	#base_fiesta_lv_exp{id = 503,act_id = 5,lv = 44,exp = 4400,reward = [{0,32010119,1}],premium_reward = [{0,32010120,1}]};

get_base_fiesta_lv_exp(503,45) ->
	#base_fiesta_lv_exp{id = 503,act_id = 5,lv = 45,exp = 4500,reward = [{0,38160001,1}],premium_reward = [{0,37020002,1}]};

get_base_fiesta_lv_exp(503,46) ->
	#base_fiesta_lv_exp{id = 503,act_id = 5,lv = 46,exp = 4600,reward = [{0,32010001,2}],premium_reward = [{0,32010002,2}]};

get_base_fiesta_lv_exp(503,47) ->
	#base_fiesta_lv_exp{id = 503,act_id = 5,lv = 47,exp = 4700,reward = [{0,7301001,2}],premium_reward = [{0,7301002,2}]};

get_base_fiesta_lv_exp(503,48) ->
	#base_fiesta_lv_exp{id = 503,act_id = 5,lv = 48,exp = 4800,reward = [{0,38100002,2}],premium_reward = [{0,38100002,5}]};

get_base_fiesta_lv_exp(503,49) ->
	#base_fiesta_lv_exp{id = 503,act_id = 5,lv = 49,exp = 4900,reward = [{0,38040005,20}],premium_reward = [{0,38040005,50}]};

get_base_fiesta_lv_exp(503,50) ->
	#base_fiesta_lv_exp{id = 503,act_id = 5,lv = 50,exp = 5000,reward = [{0,20010002,1}],premium_reward = [{0,32010517,1}]};

get_base_fiesta_lv_exp(503,51) ->
	#base_fiesta_lv_exp{id = 503,act_id = 5,lv = 51,exp = 5100,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(503,52) ->
	#base_fiesta_lv_exp{id = 503,act_id = 5,lv = 52,exp = 5200,reward = [{0,38100002,2}],premium_reward = [{0,38100002,5}]};

get_base_fiesta_lv_exp(503,53) ->
	#base_fiesta_lv_exp{id = 503,act_id = 5,lv = 53,exp = 5300,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(503,54) ->
	#base_fiesta_lv_exp{id = 503,act_id = 5,lv = 54,exp = 5400,reward = [{0,7301003,2}],premium_reward = [{0,7301004,1}]};

get_base_fiesta_lv_exp(503,55) ->
	#base_fiesta_lv_exp{id = 503,act_id = 5,lv = 55,exp = 5500,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(503,56) ->
	#base_fiesta_lv_exp{id = 503,act_id = 5,lv = 56,exp = 5600,reward = [{0,32010119,2}],premium_reward = [{0,32010120,1}]};

get_base_fiesta_lv_exp(503,57) ->
	#base_fiesta_lv_exp{id = 503,act_id = 5,lv = 57,exp = 5700,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(503,58) ->
	#base_fiesta_lv_exp{id = 503,act_id = 5,lv = 58,exp = 5800,reward = [{0,7301003,2}],premium_reward = [{0,7301004,1}]};

get_base_fiesta_lv_exp(503,59) ->
	#base_fiesta_lv_exp{id = 503,act_id = 5,lv = 59,exp = 5900,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(503,60) ->
	#base_fiesta_lv_exp{id = 503,act_id = 5,lv = 60,exp = 6000,reward = [{0,20010002,1}],premium_reward = [{0,35,268}]};

get_base_fiesta_lv_exp(503,61) ->
	#base_fiesta_lv_exp{id = 503,act_id = 5,lv = 61,exp = 6100,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(503,62) ->
	#base_fiesta_lv_exp{id = 503,act_id = 5,lv = 62,exp = 6200,reward = [{0,38370002,1}],premium_reward = [{0,38030004,1}]};

get_base_fiesta_lv_exp(503,63) ->
	#base_fiesta_lv_exp{id = 503,act_id = 5,lv = 63,exp = 6300,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(503,64) ->
	#base_fiesta_lv_exp{id = 503,act_id = 5,lv = 64,exp = 6400,reward = [{0,38100002,2}],premium_reward = [{0,38100002,5}]};

get_base_fiesta_lv_exp(503,65) ->
	#base_fiesta_lv_exp{id = 503,act_id = 5,lv = 65,exp = 6500,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(503,66) ->
	#base_fiesta_lv_exp{id = 503,act_id = 5,lv = 66,exp = 6600,reward = [{0,7301003,2}],premium_reward = [{0,7301004,1}]};

get_base_fiesta_lv_exp(503,67) ->
	#base_fiesta_lv_exp{id = 503,act_id = 5,lv = 67,exp = 6700,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(503,68) ->
	#base_fiesta_lv_exp{id = 503,act_id = 5,lv = 68,exp = 6800,reward = [{0,32010119,2}],premium_reward = [{0,32010120,1}]};

get_base_fiesta_lv_exp(503,69) ->
	#base_fiesta_lv_exp{id = 503,act_id = 5,lv = 69,exp = 6900,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(503,70) ->
	#base_fiesta_lv_exp{id = 503,act_id = 5,lv = 70,exp = 7000,reward = [{0,34010390,1}],premium_reward = [{0,6102001,1}]};

get_base_fiesta_lv_exp(503,71) ->
	#base_fiesta_lv_exp{id = 503,act_id = 5,lv = 71,exp = 7100,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(503,72) ->
	#base_fiesta_lv_exp{id = 503,act_id = 5,lv = 72,exp = 7200,reward = [{0,38100002,2}],premium_reward = [{0,38100002,5}]};

get_base_fiesta_lv_exp(503,73) ->
	#base_fiesta_lv_exp{id = 503,act_id = 5,lv = 73,exp = 7300,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(503,74) ->
	#base_fiesta_lv_exp{id = 503,act_id = 5,lv = 74,exp = 7400,reward = [{0,32010119,2}],premium_reward = [{0,32010120,1}]};

get_base_fiesta_lv_exp(503,75) ->
	#base_fiesta_lv_exp{id = 503,act_id = 5,lv = 75,exp = 7500,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(503,76) ->
	#base_fiesta_lv_exp{id = 503,act_id = 5,lv = 76,exp = 7600,reward = [{0,32010002,2}],premium_reward = [{0,32010003,2}]};

get_base_fiesta_lv_exp(503,77) ->
	#base_fiesta_lv_exp{id = 503,act_id = 5,lv = 77,exp = 7700,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(503,78) ->
	#base_fiesta_lv_exp{id = 503,act_id = 5,lv = 78,exp = 7800,reward = [{0,38100002,2}],premium_reward = [{0,38100002,5}]};

get_base_fiesta_lv_exp(503,79) ->
	#base_fiesta_lv_exp{id = 503,act_id = 5,lv = 79,exp = 7900,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(503,80) ->
	#base_fiesta_lv_exp{id = 503,act_id = 5,lv = 80,exp = 8000,reward = [{0,39510025,1}],premium_reward = [{0,35,368}]};

get_base_fiesta_lv_exp(503,81) ->
	#base_fiesta_lv_exp{id = 503,act_id = 5,lv = 81,exp = 8100,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(503,82) ->
	#base_fiesta_lv_exp{id = 503,act_id = 5,lv = 82,exp = 8200,reward = [{0,38370002,1}],premium_reward = [{0,38030004,1}]};

get_base_fiesta_lv_exp(503,83) ->
	#base_fiesta_lv_exp{id = 503,act_id = 5,lv = 83,exp = 8300,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(503,84) ->
	#base_fiesta_lv_exp{id = 503,act_id = 5,lv = 84,exp = 8400,reward = [{0,38100002,2}],premium_reward = [{0,38100002,5}]};

get_base_fiesta_lv_exp(503,85) ->
	#base_fiesta_lv_exp{id = 503,act_id = 5,lv = 85,exp = 8500,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(503,86) ->
	#base_fiesta_lv_exp{id = 503,act_id = 5,lv = 86,exp = 8600,reward = [{0,7301003,2}],premium_reward = [{0,7301004,1}]};

get_base_fiesta_lv_exp(503,87) ->
	#base_fiesta_lv_exp{id = 503,act_id = 5,lv = 87,exp = 8700,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(503,88) ->
	#base_fiesta_lv_exp{id = 503,act_id = 5,lv = 88,exp = 8800,reward = [{0,32010119,3}],premium_reward = [{0,32010120,2}]};

get_base_fiesta_lv_exp(503,89) ->
	#base_fiesta_lv_exp{id = 503,act_id = 5,lv = 89,exp = 8900,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(503,90) ->
	#base_fiesta_lv_exp{id = 503,act_id = 5,lv = 90,exp = 9000,reward = [{0,20010003,1}],premium_reward = [{0,32010517,1}]};

get_base_fiesta_lv_exp(503,91) ->
	#base_fiesta_lv_exp{id = 503,act_id = 5,lv = 91,exp = 9100,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(503,92) ->
	#base_fiesta_lv_exp{id = 503,act_id = 5,lv = 92,exp = 9200,reward = [{0,38100002,2}],premium_reward = [{0,38100002,5}]};

get_base_fiesta_lv_exp(503,93) ->
	#base_fiesta_lv_exp{id = 503,act_id = 5,lv = 93,exp = 9300,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(503,94) ->
	#base_fiesta_lv_exp{id = 503,act_id = 5,lv = 94,exp = 9400,reward = [{0,7301003,2}],premium_reward = [{0,7301004,1}]};

get_base_fiesta_lv_exp(503,95) ->
	#base_fiesta_lv_exp{id = 503,act_id = 5,lv = 95,exp = 9500,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(503,96) ->
	#base_fiesta_lv_exp{id = 503,act_id = 5,lv = 96,exp = 9600,reward = [{0,32010119,3}],premium_reward = [{0,32010120,3}]};

get_base_fiesta_lv_exp(503,97) ->
	#base_fiesta_lv_exp{id = 503,act_id = 5,lv = 97,exp = 9700,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(503,98) ->
	#base_fiesta_lv_exp{id = 503,act_id = 5,lv = 98,exp = 9800,reward = [{0,7301003,2}],premium_reward = [{0,7301004,1}]};

get_base_fiesta_lv_exp(503,99) ->
	#base_fiesta_lv_exp{id = 503,act_id = 5,lv = 99,exp = 9900,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(503,100) ->
	#base_fiesta_lv_exp{id = 503,act_id = 5,lv = 100,exp = 10000,reward = [{0,35,128}],premium_reward = [{0,18030115,30}]};

get_base_fiesta_lv_exp(503,101) ->
	#base_fiesta_lv_exp{id = 503,act_id = 5,lv = 101,exp = 10100,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(503,102) ->
	#base_fiesta_lv_exp{id = 503,act_id = 5,lv = 102,exp = 10200,reward = [{0,801701,2}],premium_reward = [{0,801702,5}]};

get_base_fiesta_lv_exp(503,103) ->
	#base_fiesta_lv_exp{id = 503,act_id = 5,lv = 103,exp = 10300,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(503,104) ->
	#base_fiesta_lv_exp{id = 503,act_id = 5,lv = 104,exp = 10400,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(503,105) ->
	#base_fiesta_lv_exp{id = 503,act_id = 5,lv = 105,exp = 10500,reward = [{0,801701,2}],premium_reward = [{0,801702,5}]};

get_base_fiesta_lv_exp(503,106) ->
	#base_fiesta_lv_exp{id = 503,act_id = 5,lv = 106,exp = 10600,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(503,107) ->
	#base_fiesta_lv_exp{id = 503,act_id = 5,lv = 107,exp = 10700,reward = [{0,801701,2}],premium_reward = [{0,801702,5}]};

get_base_fiesta_lv_exp(503,108) ->
	#base_fiesta_lv_exp{id = 503,act_id = 5,lv = 108,exp = 10800,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(503,109) ->
	#base_fiesta_lv_exp{id = 503,act_id = 5,lv = 109,exp = 10900,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(503,110) ->
	#base_fiesta_lv_exp{id = 503,act_id = 5,lv = 110,exp = 11000,reward = [{0,801701,2}],premium_reward = [{0,801702,5}]};

get_base_fiesta_lv_exp(503,111) ->
	#base_fiesta_lv_exp{id = 503,act_id = 5,lv = 111,exp = 11100,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(503,112) ->
	#base_fiesta_lv_exp{id = 503,act_id = 5,lv = 112,exp = 11200,reward = [{0,801701,2}],premium_reward = [{0,801702,5}]};

get_base_fiesta_lv_exp(503,113) ->
	#base_fiesta_lv_exp{id = 503,act_id = 5,lv = 113,exp = 11300,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(503,114) ->
	#base_fiesta_lv_exp{id = 503,act_id = 5,lv = 114,exp = 11400,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(503,115) ->
	#base_fiesta_lv_exp{id = 503,act_id = 5,lv = 115,exp = 11500,reward = [{0,801701,2}],premium_reward = [{0,801702,5}]};

get_base_fiesta_lv_exp(503,116) ->
	#base_fiesta_lv_exp{id = 503,act_id = 5,lv = 116,exp = 11600,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(503,117) ->
	#base_fiesta_lv_exp{id = 503,act_id = 5,lv = 117,exp = 11700,reward = [{0,801701,2}],premium_reward = [{0,801702,5}]};

get_base_fiesta_lv_exp(503,118) ->
	#base_fiesta_lv_exp{id = 503,act_id = 5,lv = 118,exp = 11800,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(503,119) ->
	#base_fiesta_lv_exp{id = 503,act_id = 5,lv = 119,exp = 11900,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(503,120) ->
	#base_fiesta_lv_exp{id = 503,act_id = 5,lv = 120,exp = 12000,reward = [{0,801701,2}],premium_reward = [{0,801702,5}]};

get_base_fiesta_lv_exp(503,121) ->
	#base_fiesta_lv_exp{id = 503,act_id = 5,lv = 121,exp = 12100,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(503,122) ->
	#base_fiesta_lv_exp{id = 503,act_id = 5,lv = 122,exp = 12200,reward = [{0,801701,2}],premium_reward = [{0,801702,5}]};

get_base_fiesta_lv_exp(503,123) ->
	#base_fiesta_lv_exp{id = 503,act_id = 5,lv = 123,exp = 12300,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(503,124) ->
	#base_fiesta_lv_exp{id = 503,act_id = 5,lv = 124,exp = 12400,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(503,125) ->
	#base_fiesta_lv_exp{id = 503,act_id = 5,lv = 125,exp = 12500,reward = [{0,801701,2}],premium_reward = [{0,801702,5}]};

get_base_fiesta_lv_exp(503,126) ->
	#base_fiesta_lv_exp{id = 503,act_id = 5,lv = 126,exp = 12600,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(503,127) ->
	#base_fiesta_lv_exp{id = 503,act_id = 5,lv = 127,exp = 12700,reward = [{0,801701,2}],premium_reward = [{0,801702,5}]};

get_base_fiesta_lv_exp(503,128) ->
	#base_fiesta_lv_exp{id = 503,act_id = 5,lv = 128,exp = 12800,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(503,129) ->
	#base_fiesta_lv_exp{id = 503,act_id = 5,lv = 129,exp = 12900,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(503,130) ->
	#base_fiesta_lv_exp{id = 503,act_id = 5,lv = 130,exp = 13000,reward = [{0,801701,2}],premium_reward = [{0,801702,5}]};

get_base_fiesta_lv_exp(503,131) ->
	#base_fiesta_lv_exp{id = 503,act_id = 5,lv = 131,exp = 13100,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(503,132) ->
	#base_fiesta_lv_exp{id = 503,act_id = 5,lv = 132,exp = 13200,reward = [{0,801701,2}],premium_reward = [{0,801702,5}]};

get_base_fiesta_lv_exp(503,133) ->
	#base_fiesta_lv_exp{id = 503,act_id = 5,lv = 133,exp = 13300,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(503,134) ->
	#base_fiesta_lv_exp{id = 503,act_id = 5,lv = 134,exp = 13400,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(503,135) ->
	#base_fiesta_lv_exp{id = 503,act_id = 5,lv = 135,exp = 13500,reward = [{0,801701,2}],premium_reward = [{0,801702,5}]};

get_base_fiesta_lv_exp(503,136) ->
	#base_fiesta_lv_exp{id = 503,act_id = 5,lv = 136,exp = 13600,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(503,137) ->
	#base_fiesta_lv_exp{id = 503,act_id = 5,lv = 137,exp = 13700,reward = [{0,801701,2}],premium_reward = [{0,801702,5}]};

get_base_fiesta_lv_exp(503,138) ->
	#base_fiesta_lv_exp{id = 503,act_id = 5,lv = 138,exp = 13800,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(503,139) ->
	#base_fiesta_lv_exp{id = 503,act_id = 5,lv = 139,exp = 13900,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(503,140) ->
	#base_fiesta_lv_exp{id = 503,act_id = 5,lv = 140,exp = 14000,reward = [{0,801701,2}],premium_reward = [{0,801702,5}]};

get_base_fiesta_lv_exp(503,141) ->
	#base_fiesta_lv_exp{id = 503,act_id = 5,lv = 141,exp = 14100,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(503,142) ->
	#base_fiesta_lv_exp{id = 503,act_id = 5,lv = 142,exp = 14200,reward = [{0,801701,2}],premium_reward = [{0,801702,5}]};

get_base_fiesta_lv_exp(503,143) ->
	#base_fiesta_lv_exp{id = 503,act_id = 5,lv = 143,exp = 14300,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(503,144) ->
	#base_fiesta_lv_exp{id = 503,act_id = 5,lv = 144,exp = 14400,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(503,145) ->
	#base_fiesta_lv_exp{id = 503,act_id = 5,lv = 145,exp = 14500,reward = [{0,801701,2}],premium_reward = [{0,801702,5}]};

get_base_fiesta_lv_exp(503,146) ->
	#base_fiesta_lv_exp{id = 503,act_id = 5,lv = 146,exp = 14600,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(503,147) ->
	#base_fiesta_lv_exp{id = 503,act_id = 5,lv = 147,exp = 14700,reward = [{0,801701,2}],premium_reward = [{0,801702,5}]};

get_base_fiesta_lv_exp(503,148) ->
	#base_fiesta_lv_exp{id = 503,act_id = 5,lv = 148,exp = 14800,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(503,149) ->
	#base_fiesta_lv_exp{id = 503,act_id = 5,lv = 149,exp = 14900,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(503,150) ->
	#base_fiesta_lv_exp{id = 503,act_id = 5,lv = 150,exp = 15000,reward = [{0,801701,2}],premium_reward = [{0,801702,5}]};

get_base_fiesta_lv_exp(601,1) ->
	#base_fiesta_lv_exp{id = 601,act_id = 6,lv = 1,exp = 100,reward = [{0,16020001,2}],premium_reward = [{0,16020002,1}]};

get_base_fiesta_lv_exp(601,2) ->
	#base_fiesta_lv_exp{id = 601,act_id = 6,lv = 2,exp = 200,reward = [{0,38040005,20}],premium_reward = [{0,38040005,30}]};

get_base_fiesta_lv_exp(601,3) ->
	#base_fiesta_lv_exp{id = 601,act_id = 6,lv = 3,exp = 300,reward = [{0,16020001,2}],premium_reward = [{0,16020002,1}]};

get_base_fiesta_lv_exp(601,4) ->
	#base_fiesta_lv_exp{id = 601,act_id = 6,lv = 4,exp = 400,reward = [{0,38370001,1}],premium_reward = [{0,38160001,1}]};

get_base_fiesta_lv_exp(601,5) ->
	#base_fiesta_lv_exp{id = 601,act_id = 6,lv = 5,exp = 500,reward = [{0,37020001,2}],premium_reward = [{0,37121002,1}]};

get_base_fiesta_lv_exp(601,6) ->
	#base_fiesta_lv_exp{id = 601,act_id = 6,lv = 6,exp = 600,reward = [{0,32010119,1}],premium_reward = [{0,32010120,1}]};

get_base_fiesta_lv_exp(601,7) ->
	#base_fiesta_lv_exp{id = 601,act_id = 6,lv = 7,exp = 700,reward = [{0,38030003,1}],premium_reward = [{0,38030004,2}]};

get_base_fiesta_lv_exp(601,8) ->
	#base_fiesta_lv_exp{id = 601,act_id = 6,lv = 8,exp = 800,reward = [{0,16020001,2}],premium_reward = [{0,16020002,1}]};

get_base_fiesta_lv_exp(601,9) ->
	#base_fiesta_lv_exp{id = 601,act_id = 6,lv = 9,exp = 900,reward = [{0,38100002,2}],premium_reward = [{0,38100002,5}]};

get_base_fiesta_lv_exp(601,10) ->
	#base_fiesta_lv_exp{id = 601,act_id = 6,lv = 10,exp = 1000,reward = [{0,39510021,1}],premium_reward = [{0,35,128}]};

get_base_fiesta_lv_exp(601,11) ->
	#base_fiesta_lv_exp{id = 601,act_id = 6,lv = 11,exp = 1100,reward = [{0,16020001,2}],premium_reward = [{0,16020002,1}]};

get_base_fiesta_lv_exp(601,12) ->
	#base_fiesta_lv_exp{id = 601,act_id = 6,lv = 12,exp = 1200,reward = [{0,38100002,2}],premium_reward = [{0,38100002,5}]};

get_base_fiesta_lv_exp(601,13) ->
	#base_fiesta_lv_exp{id = 601,act_id = 6,lv = 13,exp = 1300,reward = [{0,38040005,20}],premium_reward = [{0,38040027,1}]};

get_base_fiesta_lv_exp(601,14) ->
	#base_fiesta_lv_exp{id = 601,act_id = 6,lv = 14,exp = 1400,reward = [{0,32010119,1}],premium_reward = [{0,32010120,1}]};

get_base_fiesta_lv_exp(601,15) ->
	#base_fiesta_lv_exp{id = 601,act_id = 6,lv = 15,exp = 1500,reward = [{0,38160001,1}],premium_reward = [{0,37020002,1}]};

get_base_fiesta_lv_exp(601,16) ->
	#base_fiesta_lv_exp{id = 601,act_id = 6,lv = 16,exp = 1600,reward = [{0,32010001,1}],premium_reward = [{0,32010002,1}]};

get_base_fiesta_lv_exp(601,17) ->
	#base_fiesta_lv_exp{id = 601,act_id = 6,lv = 17,exp = 1700,reward = [{0,16020001,2}],premium_reward = [{0,16020002,2}]};

get_base_fiesta_lv_exp(601,18) ->
	#base_fiesta_lv_exp{id = 601,act_id = 6,lv = 18,exp = 1800,reward = [{0,38100002,2}],premium_reward = [{0,38100002,5}]};

get_base_fiesta_lv_exp(601,19) ->
	#base_fiesta_lv_exp{id = 601,act_id = 6,lv = 19,exp = 1900,reward = [{0,32010001,1}],premium_reward = [{0,32010002,1}]};

get_base_fiesta_lv_exp(601,20) ->
	#base_fiesta_lv_exp{id = 601,act_id = 6,lv = 20,exp = 2000,reward = [{0,16010001,1}],premium_reward = [{0,37121003,1}]};

get_base_fiesta_lv_exp(601,21) ->
	#base_fiesta_lv_exp{id = 601,act_id = 6,lv = 21,exp = 2100,reward = [{0,18020001,2}],premium_reward = [{0,18020002,1}]};

get_base_fiesta_lv_exp(601,22) ->
	#base_fiesta_lv_exp{id = 601,act_id = 6,lv = 22,exp = 2200,reward = [{0,38100002,2}],premium_reward = [{0,38100002,5}]};

get_base_fiesta_lv_exp(601,23) ->
	#base_fiesta_lv_exp{id = 601,act_id = 6,lv = 23,exp = 2300,reward = [{0,32010001,1}],premium_reward = [{0,32010002,1}]};

get_base_fiesta_lv_exp(601,24) ->
	#base_fiesta_lv_exp{id = 601,act_id = 6,lv = 24,exp = 2400,reward = [{0,18020001,2}],premium_reward = [{0,18020002,1}]};

get_base_fiesta_lv_exp(601,25) ->
	#base_fiesta_lv_exp{id = 601,act_id = 6,lv = 25,exp = 2500,reward = [{0,16020001,2}],premium_reward = [{0,16020002,1}]};

get_base_fiesta_lv_exp(601,26) ->
	#base_fiesta_lv_exp{id = 601,act_id = 6,lv = 26,exp = 2600,reward = [{0,32010119,1}],premium_reward = [{0,32010120,1}]};

get_base_fiesta_lv_exp(601,27) ->
	#base_fiesta_lv_exp{id = 601,act_id = 6,lv = 27,exp = 2700,reward = [{0,38030003,1}],premium_reward = [{0,38030004,2}]};

get_base_fiesta_lv_exp(601,28) ->
	#base_fiesta_lv_exp{id = 601,act_id = 6,lv = 28,exp = 2800,reward = [{0,18020001,2}],premium_reward = [{0,18020002,1}]};

get_base_fiesta_lv_exp(601,29) ->
	#base_fiesta_lv_exp{id = 601,act_id = 6,lv = 29,exp = 2900,reward = [{0,38040005,20}],premium_reward = [{0,38040005,50}]};

get_base_fiesta_lv_exp(601,30) ->
	#base_fiesta_lv_exp{id = 601,act_id = 6,lv = 30,exp = 3000,reward = [{0,16010001,1}],premium_reward = [{0,35,188}]};

get_base_fiesta_lv_exp(601,31) ->
	#base_fiesta_lv_exp{id = 601,act_id = 6,lv = 31,exp = 3100,reward = [{0,32010119,1}],premium_reward = [{0,32010120,1}]};

get_base_fiesta_lv_exp(601,32) ->
	#base_fiesta_lv_exp{id = 601,act_id = 6,lv = 32,exp = 3200,reward = [{0,38370003,1}],premium_reward = [{0,38030004,1}]};

get_base_fiesta_lv_exp(601,33) ->
	#base_fiesta_lv_exp{id = 601,act_id = 6,lv = 33,exp = 3300,reward = [{0,38040005,20}],premium_reward = [{0,38040027,1}]};

get_base_fiesta_lv_exp(601,34) ->
	#base_fiesta_lv_exp{id = 601,act_id = 6,lv = 34,exp = 3400,reward = [{0,38100002,2}],premium_reward = [{0,38100002,5}]};

get_base_fiesta_lv_exp(601,35) ->
	#base_fiesta_lv_exp{id = 601,act_id = 6,lv = 35,exp = 3500,reward = [{0,32010001,2}],premium_reward = [{0,32010002,2}]};

get_base_fiesta_lv_exp(601,36) ->
	#base_fiesta_lv_exp{id = 601,act_id = 6,lv = 36,exp = 3600,reward = [{0,18020001,2}],premium_reward = [{0,18020002,1}]};

get_base_fiesta_lv_exp(601,37) ->
	#base_fiesta_lv_exp{id = 601,act_id = 6,lv = 37,exp = 3700,reward = [{0,32010001,2}],premium_reward = [{0,32010002,2}]};

get_base_fiesta_lv_exp(601,38) ->
	#base_fiesta_lv_exp{id = 601,act_id = 6,lv = 38,exp = 3800,reward = [{0,32010119,1}],premium_reward = [{0,32010120,1}]};

get_base_fiesta_lv_exp(601,39) ->
	#base_fiesta_lv_exp{id = 601,act_id = 6,lv = 39,exp = 3900,reward = [{0,18020001,2}],premium_reward = [{0,18020002,1}]};

get_base_fiesta_lv_exp(601,40) ->
	#base_fiesta_lv_exp{id = 601,act_id = 6,lv = 40,exp = 4000,reward = [{0,6101003,1}],premium_reward = [{0,6101004,1}]};

get_base_fiesta_lv_exp(601,41) ->
	#base_fiesta_lv_exp{id = 601,act_id = 6,lv = 41,exp = 4100,reward = [{0,16020001,2}],premium_reward = [{0,16020002,1}]};

get_base_fiesta_lv_exp(601,42) ->
	#base_fiesta_lv_exp{id = 601,act_id = 6,lv = 42,exp = 4200,reward = [{0,38100002,2}],premium_reward = [{0,38100002,5}]};

get_base_fiesta_lv_exp(601,43) ->
	#base_fiesta_lv_exp{id = 601,act_id = 6,lv = 43,exp = 4300,reward = [{0,38040005,20}],premium_reward = [{0,38040027,1}]};

get_base_fiesta_lv_exp(601,44) ->
	#base_fiesta_lv_exp{id = 601,act_id = 6,lv = 44,exp = 4400,reward = [{0,32010119,1}],premium_reward = [{0,32010120,1}]};

get_base_fiesta_lv_exp(601,45) ->
	#base_fiesta_lv_exp{id = 601,act_id = 6,lv = 45,exp = 4500,reward = [{0,38160001,1}],premium_reward = [{0,37020002,1}]};

get_base_fiesta_lv_exp(601,46) ->
	#base_fiesta_lv_exp{id = 601,act_id = 6,lv = 46,exp = 4600,reward = [{0,32010001,2}],premium_reward = [{0,32010002,2}]};

get_base_fiesta_lv_exp(601,47) ->
	#base_fiesta_lv_exp{id = 601,act_id = 6,lv = 47,exp = 4700,reward = [{0,16020001,2}],premium_reward = [{0,16020002,2}]};

get_base_fiesta_lv_exp(601,48) ->
	#base_fiesta_lv_exp{id = 601,act_id = 6,lv = 48,exp = 4800,reward = [{0,38100002,2}],premium_reward = [{0,38100002,5}]};

get_base_fiesta_lv_exp(601,49) ->
	#base_fiesta_lv_exp{id = 601,act_id = 6,lv = 49,exp = 4900,reward = [{0,38040005,20}],premium_reward = [{0,38040005,50}]};

get_base_fiesta_lv_exp(601,50) ->
	#base_fiesta_lv_exp{id = 601,act_id = 6,lv = 50,exp = 5000,reward = [{0,16010002,1}],premium_reward = [{0,32010517,1}]};

get_base_fiesta_lv_exp(601,51) ->
	#base_fiesta_lv_exp{id = 601,act_id = 6,lv = 51,exp = 5100,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(601,52) ->
	#base_fiesta_lv_exp{id = 601,act_id = 6,lv = 52,exp = 5200,reward = [{0,38100002,2}],premium_reward = [{0,38100002,5}]};

get_base_fiesta_lv_exp(601,53) ->
	#base_fiesta_lv_exp{id = 601,act_id = 6,lv = 53,exp = 5300,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(601,54) ->
	#base_fiesta_lv_exp{id = 601,act_id = 6,lv = 54,exp = 5400,reward = [{0,18020001,2}],premium_reward = [{0,18020002,1}]};

get_base_fiesta_lv_exp(601,55) ->
	#base_fiesta_lv_exp{id = 601,act_id = 6,lv = 55,exp = 5500,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(601,56) ->
	#base_fiesta_lv_exp{id = 601,act_id = 6,lv = 56,exp = 5600,reward = [{0,32010119,2}],premium_reward = [{0,32010120,1}]};

get_base_fiesta_lv_exp(601,57) ->
	#base_fiesta_lv_exp{id = 601,act_id = 6,lv = 57,exp = 5700,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(601,58) ->
	#base_fiesta_lv_exp{id = 601,act_id = 6,lv = 58,exp = 5800,reward = [{0,18020001,2}],premium_reward = [{0,18020002,1}]};

get_base_fiesta_lv_exp(601,59) ->
	#base_fiesta_lv_exp{id = 601,act_id = 6,lv = 59,exp = 5900,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(601,60) ->
	#base_fiesta_lv_exp{id = 601,act_id = 6,lv = 60,exp = 6000,reward = [{0,16010002,1}],premium_reward = [{0,35,268}]};

get_base_fiesta_lv_exp(601,61) ->
	#base_fiesta_lv_exp{id = 601,act_id = 6,lv = 61,exp = 6100,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(601,62) ->
	#base_fiesta_lv_exp{id = 601,act_id = 6,lv = 62,exp = 6200,reward = [{0,38370003,1}],premium_reward = [{0,38030004,1}]};

get_base_fiesta_lv_exp(601,63) ->
	#base_fiesta_lv_exp{id = 601,act_id = 6,lv = 63,exp = 6300,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(601,64) ->
	#base_fiesta_lv_exp{id = 601,act_id = 6,lv = 64,exp = 6400,reward = [{0,38100002,2}],premium_reward = [{0,38100002,5}]};

get_base_fiesta_lv_exp(601,65) ->
	#base_fiesta_lv_exp{id = 601,act_id = 6,lv = 65,exp = 6500,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(601,66) ->
	#base_fiesta_lv_exp{id = 601,act_id = 6,lv = 66,exp = 6600,reward = [{0,18020001,2}],premium_reward = [{0,18020002,1}]};

get_base_fiesta_lv_exp(601,67) ->
	#base_fiesta_lv_exp{id = 601,act_id = 6,lv = 67,exp = 6700,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(601,68) ->
	#base_fiesta_lv_exp{id = 601,act_id = 6,lv = 68,exp = 6800,reward = [{0,32010119,2}],premium_reward = [{0,32010120,1}]};

get_base_fiesta_lv_exp(601,69) ->
	#base_fiesta_lv_exp{id = 601,act_id = 6,lv = 69,exp = 6900,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(601,70) ->
	#base_fiesta_lv_exp{id = 601,act_id = 6,lv = 70,exp = 7000,reward = [{0,34010390,1}],premium_reward = [{0,6102001,1}]};

get_base_fiesta_lv_exp(601,71) ->
	#base_fiesta_lv_exp{id = 601,act_id = 6,lv = 71,exp = 7100,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(601,72) ->
	#base_fiesta_lv_exp{id = 601,act_id = 6,lv = 72,exp = 7200,reward = [{0,38100002,2}],premium_reward = [{0,38100002,5}]};

get_base_fiesta_lv_exp(601,73) ->
	#base_fiesta_lv_exp{id = 601,act_id = 6,lv = 73,exp = 7300,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(601,74) ->
	#base_fiesta_lv_exp{id = 601,act_id = 6,lv = 74,exp = 7400,reward = [{0,32010119,2}],premium_reward = [{0,32010120,1}]};

get_base_fiesta_lv_exp(601,75) ->
	#base_fiesta_lv_exp{id = 601,act_id = 6,lv = 75,exp = 7500,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(601,76) ->
	#base_fiesta_lv_exp{id = 601,act_id = 6,lv = 76,exp = 7600,reward = [{0,32010002,2}],premium_reward = [{0,32010003,2}]};

get_base_fiesta_lv_exp(601,77) ->
	#base_fiesta_lv_exp{id = 601,act_id = 6,lv = 77,exp = 7700,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(601,78) ->
	#base_fiesta_lv_exp{id = 601,act_id = 6,lv = 78,exp = 7800,reward = [{0,38100002,2}],premium_reward = [{0,38100002,5}]};

get_base_fiesta_lv_exp(601,79) ->
	#base_fiesta_lv_exp{id = 601,act_id = 6,lv = 79,exp = 7900,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(601,80) ->
	#base_fiesta_lv_exp{id = 601,act_id = 6,lv = 80,exp = 8000,reward = [{0,34010391,1}],premium_reward = [{0,35,368}]};

get_base_fiesta_lv_exp(601,81) ->
	#base_fiesta_lv_exp{id = 601,act_id = 6,lv = 81,exp = 8100,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(601,82) ->
	#base_fiesta_lv_exp{id = 601,act_id = 6,lv = 82,exp = 8200,reward = [{0,38370003,1}],premium_reward = [{0,38030004,1}]};

get_base_fiesta_lv_exp(601,83) ->
	#base_fiesta_lv_exp{id = 601,act_id = 6,lv = 83,exp = 8300,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(601,84) ->
	#base_fiesta_lv_exp{id = 601,act_id = 6,lv = 84,exp = 8400,reward = [{0,38100002,2}],premium_reward = [{0,38100002,5}]};

get_base_fiesta_lv_exp(601,85) ->
	#base_fiesta_lv_exp{id = 601,act_id = 6,lv = 85,exp = 8500,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(601,86) ->
	#base_fiesta_lv_exp{id = 601,act_id = 6,lv = 86,exp = 8600,reward = [{0,18020001,2}],premium_reward = [{0,18020002,1}]};

get_base_fiesta_lv_exp(601,87) ->
	#base_fiesta_lv_exp{id = 601,act_id = 6,lv = 87,exp = 8700,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(601,88) ->
	#base_fiesta_lv_exp{id = 601,act_id = 6,lv = 88,exp = 8800,reward = [{0,32010119,3}],premium_reward = [{0,32010120,2}]};

get_base_fiesta_lv_exp(601,89) ->
	#base_fiesta_lv_exp{id = 601,act_id = 6,lv = 89,exp = 8900,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(601,90) ->
	#base_fiesta_lv_exp{id = 601,act_id = 6,lv = 90,exp = 9000,reward = [{0,16010003,1}],premium_reward = [{0,32010517,1}]};

get_base_fiesta_lv_exp(601,91) ->
	#base_fiesta_lv_exp{id = 601,act_id = 6,lv = 91,exp = 9100,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(601,92) ->
	#base_fiesta_lv_exp{id = 601,act_id = 6,lv = 92,exp = 9200,reward = [{0,38100002,2}],premium_reward = [{0,38100002,5}]};

get_base_fiesta_lv_exp(601,93) ->
	#base_fiesta_lv_exp{id = 601,act_id = 6,lv = 93,exp = 9300,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(601,94) ->
	#base_fiesta_lv_exp{id = 601,act_id = 6,lv = 94,exp = 9400,reward = [{0,18020001,2}],premium_reward = [{0,18020002,1}]};

get_base_fiesta_lv_exp(601,95) ->
	#base_fiesta_lv_exp{id = 601,act_id = 6,lv = 95,exp = 9500,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(601,96) ->
	#base_fiesta_lv_exp{id = 601,act_id = 6,lv = 96,exp = 9600,reward = [{0,32010119,3}],premium_reward = [{0,32010120,3}]};

get_base_fiesta_lv_exp(601,97) ->
	#base_fiesta_lv_exp{id = 601,act_id = 6,lv = 97,exp = 9700,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(601,98) ->
	#base_fiesta_lv_exp{id = 601,act_id = 6,lv = 98,exp = 9800,reward = [{0,18020001,2}],premium_reward = [{0,18020002,1}]};

get_base_fiesta_lv_exp(601,99) ->
	#base_fiesta_lv_exp{id = 601,act_id = 6,lv = 99,exp = 9900,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(601,100) ->
	#base_fiesta_lv_exp{id = 601,act_id = 6,lv = 100,exp = 10000,reward = [{0,35,128}],premium_reward = [{0,18030116,30}]};

get_base_fiesta_lv_exp(601,101) ->
	#base_fiesta_lv_exp{id = 601,act_id = 6,lv = 101,exp = 10100,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(601,102) ->
	#base_fiesta_lv_exp{id = 601,act_id = 6,lv = 102,exp = 10200,reward = [{0,23020001,4}],premium_reward = [{0,38040041,5}]};

get_base_fiesta_lv_exp(601,103) ->
	#base_fiesta_lv_exp{id = 601,act_id = 6,lv = 103,exp = 10300,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(601,104) ->
	#base_fiesta_lv_exp{id = 601,act_id = 6,lv = 104,exp = 10400,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(601,105) ->
	#base_fiesta_lv_exp{id = 601,act_id = 6,lv = 105,exp = 10500,reward = [{0,23020001,4}],premium_reward = [{0,38040041,5}]};

get_base_fiesta_lv_exp(601,106) ->
	#base_fiesta_lv_exp{id = 601,act_id = 6,lv = 106,exp = 10600,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(601,107) ->
	#base_fiesta_lv_exp{id = 601,act_id = 6,lv = 107,exp = 10700,reward = [{0,23020001,4}],premium_reward = [{0,38040041,5}]};

get_base_fiesta_lv_exp(601,108) ->
	#base_fiesta_lv_exp{id = 601,act_id = 6,lv = 108,exp = 10800,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(601,109) ->
	#base_fiesta_lv_exp{id = 601,act_id = 6,lv = 109,exp = 10900,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(601,110) ->
	#base_fiesta_lv_exp{id = 601,act_id = 6,lv = 110,exp = 11000,reward = [{0,23020001,4}],premium_reward = [{0,38040041,5}]};

get_base_fiesta_lv_exp(601,111) ->
	#base_fiesta_lv_exp{id = 601,act_id = 6,lv = 111,exp = 11100,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(601,112) ->
	#base_fiesta_lv_exp{id = 601,act_id = 6,lv = 112,exp = 11200,reward = [{0,23020001,4}],premium_reward = [{0,38040041,5}]};

get_base_fiesta_lv_exp(601,113) ->
	#base_fiesta_lv_exp{id = 601,act_id = 6,lv = 113,exp = 11300,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(601,114) ->
	#base_fiesta_lv_exp{id = 601,act_id = 6,lv = 114,exp = 11400,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(601,115) ->
	#base_fiesta_lv_exp{id = 601,act_id = 6,lv = 115,exp = 11500,reward = [{0,23020001,4}],premium_reward = [{0,38040041,5}]};

get_base_fiesta_lv_exp(601,116) ->
	#base_fiesta_lv_exp{id = 601,act_id = 6,lv = 116,exp = 11600,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(601,117) ->
	#base_fiesta_lv_exp{id = 601,act_id = 6,lv = 117,exp = 11700,reward = [{0,23020001,4}],premium_reward = [{0,38040041,5}]};

get_base_fiesta_lv_exp(601,118) ->
	#base_fiesta_lv_exp{id = 601,act_id = 6,lv = 118,exp = 11800,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(601,119) ->
	#base_fiesta_lv_exp{id = 601,act_id = 6,lv = 119,exp = 11900,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(601,120) ->
	#base_fiesta_lv_exp{id = 601,act_id = 6,lv = 120,exp = 12000,reward = [{0,23020001,4}],premium_reward = [{0,38040041,5}]};

get_base_fiesta_lv_exp(601,121) ->
	#base_fiesta_lv_exp{id = 601,act_id = 6,lv = 121,exp = 12100,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(601,122) ->
	#base_fiesta_lv_exp{id = 601,act_id = 6,lv = 122,exp = 12200,reward = [{0,23020001,4}],premium_reward = [{0,38040041,5}]};

get_base_fiesta_lv_exp(601,123) ->
	#base_fiesta_lv_exp{id = 601,act_id = 6,lv = 123,exp = 12300,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(601,124) ->
	#base_fiesta_lv_exp{id = 601,act_id = 6,lv = 124,exp = 12400,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(601,125) ->
	#base_fiesta_lv_exp{id = 601,act_id = 6,lv = 125,exp = 12500,reward = [{0,23020001,4}],premium_reward = [{0,38040041,5}]};

get_base_fiesta_lv_exp(601,126) ->
	#base_fiesta_lv_exp{id = 601,act_id = 6,lv = 126,exp = 12600,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(601,127) ->
	#base_fiesta_lv_exp{id = 601,act_id = 6,lv = 127,exp = 12700,reward = [{0,23020001,4}],premium_reward = [{0,38040041,5}]};

get_base_fiesta_lv_exp(601,128) ->
	#base_fiesta_lv_exp{id = 601,act_id = 6,lv = 128,exp = 12800,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(601,129) ->
	#base_fiesta_lv_exp{id = 601,act_id = 6,lv = 129,exp = 12900,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(601,130) ->
	#base_fiesta_lv_exp{id = 601,act_id = 6,lv = 130,exp = 13000,reward = [{0,23020001,4}],premium_reward = [{0,38040041,5}]};

get_base_fiesta_lv_exp(601,131) ->
	#base_fiesta_lv_exp{id = 601,act_id = 6,lv = 131,exp = 13100,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(601,132) ->
	#base_fiesta_lv_exp{id = 601,act_id = 6,lv = 132,exp = 13200,reward = [{0,23020001,4}],premium_reward = [{0,38040041,5}]};

get_base_fiesta_lv_exp(601,133) ->
	#base_fiesta_lv_exp{id = 601,act_id = 6,lv = 133,exp = 13300,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(601,134) ->
	#base_fiesta_lv_exp{id = 601,act_id = 6,lv = 134,exp = 13400,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(601,135) ->
	#base_fiesta_lv_exp{id = 601,act_id = 6,lv = 135,exp = 13500,reward = [{0,23020001,4}],premium_reward = [{0,38040041,5}]};

get_base_fiesta_lv_exp(601,136) ->
	#base_fiesta_lv_exp{id = 601,act_id = 6,lv = 136,exp = 13600,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(601,137) ->
	#base_fiesta_lv_exp{id = 601,act_id = 6,lv = 137,exp = 13700,reward = [{0,23020001,4}],premium_reward = [{0,38040041,5}]};

get_base_fiesta_lv_exp(601,138) ->
	#base_fiesta_lv_exp{id = 601,act_id = 6,lv = 138,exp = 13800,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(601,139) ->
	#base_fiesta_lv_exp{id = 601,act_id = 6,lv = 139,exp = 13900,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(601,140) ->
	#base_fiesta_lv_exp{id = 601,act_id = 6,lv = 140,exp = 14000,reward = [{0,23020001,4}],premium_reward = [{0,38040041,5}]};

get_base_fiesta_lv_exp(601,141) ->
	#base_fiesta_lv_exp{id = 601,act_id = 6,lv = 141,exp = 14100,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(601,142) ->
	#base_fiesta_lv_exp{id = 601,act_id = 6,lv = 142,exp = 14200,reward = [{0,23020001,4}],premium_reward = [{0,38040041,5}]};

get_base_fiesta_lv_exp(601,143) ->
	#base_fiesta_lv_exp{id = 601,act_id = 6,lv = 143,exp = 14300,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(601,144) ->
	#base_fiesta_lv_exp{id = 601,act_id = 6,lv = 144,exp = 14400,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(601,145) ->
	#base_fiesta_lv_exp{id = 601,act_id = 6,lv = 145,exp = 14500,reward = [{0,23020001,4}],premium_reward = [{0,38040041,5}]};

get_base_fiesta_lv_exp(601,146) ->
	#base_fiesta_lv_exp{id = 601,act_id = 6,lv = 146,exp = 14600,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(601,147) ->
	#base_fiesta_lv_exp{id = 601,act_id = 6,lv = 147,exp = 14700,reward = [{0,23020001,4}],premium_reward = [{0,38040041,5}]};

get_base_fiesta_lv_exp(601,148) ->
	#base_fiesta_lv_exp{id = 601,act_id = 6,lv = 148,exp = 14800,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(601,149) ->
	#base_fiesta_lv_exp{id = 601,act_id = 6,lv = 149,exp = 14900,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(601,150) ->
	#base_fiesta_lv_exp{id = 601,act_id = 6,lv = 150,exp = 15000,reward = [{0,23020001,4}],premium_reward = [{0,38040041,5}]};

get_base_fiesta_lv_exp(602,1) ->
	#base_fiesta_lv_exp{id = 602,act_id = 6,lv = 1,exp = 100,reward = [{0,19020001,2}],premium_reward = [{0,19020002,1}]};

get_base_fiesta_lv_exp(602,2) ->
	#base_fiesta_lv_exp{id = 602,act_id = 6,lv = 2,exp = 200,reward = [{0,38040005,20}],premium_reward = [{0,38040005,30}]};

get_base_fiesta_lv_exp(602,3) ->
	#base_fiesta_lv_exp{id = 602,act_id = 6,lv = 3,exp = 300,reward = [{0,19020001,2}],premium_reward = [{0,19020002,1}]};

get_base_fiesta_lv_exp(602,4) ->
	#base_fiesta_lv_exp{id = 602,act_id = 6,lv = 4,exp = 400,reward = [{0,38370001,1}],premium_reward = [{0,38160001,1}]};

get_base_fiesta_lv_exp(602,5) ->
	#base_fiesta_lv_exp{id = 602,act_id = 6,lv = 5,exp = 500,reward = [{0,37020001,2}],premium_reward = [{0,37121002,1}]};

get_base_fiesta_lv_exp(602,6) ->
	#base_fiesta_lv_exp{id = 602,act_id = 6,lv = 6,exp = 600,reward = [{0,32010119,1}],premium_reward = [{0,32010120,1}]};

get_base_fiesta_lv_exp(602,7) ->
	#base_fiesta_lv_exp{id = 602,act_id = 6,lv = 7,exp = 700,reward = [{0,38030005,1}],premium_reward = [{0,38030004,2}]};

get_base_fiesta_lv_exp(602,8) ->
	#base_fiesta_lv_exp{id = 602,act_id = 6,lv = 8,exp = 800,reward = [{0,19020001,2}],premium_reward = [{0,19020002,1}]};

get_base_fiesta_lv_exp(602,9) ->
	#base_fiesta_lv_exp{id = 602,act_id = 6,lv = 9,exp = 900,reward = [{0,38100002,2}],premium_reward = [{0,38100002,5}]};

get_base_fiesta_lv_exp(602,10) ->
	#base_fiesta_lv_exp{id = 602,act_id = 6,lv = 10,exp = 1000,reward = [{0,39510021,1}],premium_reward = [{0,35,128}]};

get_base_fiesta_lv_exp(602,11) ->
	#base_fiesta_lv_exp{id = 602,act_id = 6,lv = 11,exp = 1100,reward = [{0,19020001,2}],premium_reward = [{0,19020002,1}]};

get_base_fiesta_lv_exp(602,12) ->
	#base_fiesta_lv_exp{id = 602,act_id = 6,lv = 12,exp = 1200,reward = [{0,38100002,2}],premium_reward = [{0,38100002,5}]};

get_base_fiesta_lv_exp(602,13) ->
	#base_fiesta_lv_exp{id = 602,act_id = 6,lv = 13,exp = 1300,reward = [{0,38040005,20}],premium_reward = [{0,38040027,1}]};

get_base_fiesta_lv_exp(602,14) ->
	#base_fiesta_lv_exp{id = 602,act_id = 6,lv = 14,exp = 1400,reward = [{0,32010119,1}],premium_reward = [{0,32010120,1}]};

get_base_fiesta_lv_exp(602,15) ->
	#base_fiesta_lv_exp{id = 602,act_id = 6,lv = 15,exp = 1500,reward = [{0,38160001,1}],premium_reward = [{0,37020002,1}]};

get_base_fiesta_lv_exp(602,16) ->
	#base_fiesta_lv_exp{id = 602,act_id = 6,lv = 16,exp = 1600,reward = [{0,32010001,1}],premium_reward = [{0,32010002,1}]};

get_base_fiesta_lv_exp(602,17) ->
	#base_fiesta_lv_exp{id = 602,act_id = 6,lv = 17,exp = 1700,reward = [{0,19020001,2}],premium_reward = [{0,19020002,2}]};

get_base_fiesta_lv_exp(602,18) ->
	#base_fiesta_lv_exp{id = 602,act_id = 6,lv = 18,exp = 1800,reward = [{0,38100002,2}],premium_reward = [{0,38100002,5}]};

get_base_fiesta_lv_exp(602,19) ->
	#base_fiesta_lv_exp{id = 602,act_id = 6,lv = 19,exp = 1900,reward = [{0,32010001,1}],premium_reward = [{0,32010002,1}]};

get_base_fiesta_lv_exp(602,20) ->
	#base_fiesta_lv_exp{id = 602,act_id = 6,lv = 20,exp = 2000,reward = [{0,18010001,1}],premium_reward = [{0,37121003,1}]};

get_base_fiesta_lv_exp(602,21) ->
	#base_fiesta_lv_exp{id = 602,act_id = 6,lv = 21,exp = 2100,reward = [{0,20020001,2}],premium_reward = [{0,20020002,1}]};

get_base_fiesta_lv_exp(602,22) ->
	#base_fiesta_lv_exp{id = 602,act_id = 6,lv = 22,exp = 2200,reward = [{0,38100002,2}],premium_reward = [{0,38100002,5}]};

get_base_fiesta_lv_exp(602,23) ->
	#base_fiesta_lv_exp{id = 602,act_id = 6,lv = 23,exp = 2300,reward = [{0,32010001,1}],premium_reward = [{0,32010002,1}]};

get_base_fiesta_lv_exp(602,24) ->
	#base_fiesta_lv_exp{id = 602,act_id = 6,lv = 24,exp = 2400,reward = [{0,20020001,2}],premium_reward = [{0,20020002,1}]};

get_base_fiesta_lv_exp(602,25) ->
	#base_fiesta_lv_exp{id = 602,act_id = 6,lv = 25,exp = 2500,reward = [{0,19020001,2}],premium_reward = [{0,19020002,1}]};

get_base_fiesta_lv_exp(602,26) ->
	#base_fiesta_lv_exp{id = 602,act_id = 6,lv = 26,exp = 2600,reward = [{0,32010119,1}],premium_reward = [{0,32010120,1}]};

get_base_fiesta_lv_exp(602,27) ->
	#base_fiesta_lv_exp{id = 602,act_id = 6,lv = 27,exp = 2700,reward = [{0,38030005,1}],premium_reward = [{0,38030004,2}]};

get_base_fiesta_lv_exp(602,28) ->
	#base_fiesta_lv_exp{id = 602,act_id = 6,lv = 28,exp = 2800,reward = [{0,20020001,2}],premium_reward = [{0,20020002,1}]};

get_base_fiesta_lv_exp(602,29) ->
	#base_fiesta_lv_exp{id = 602,act_id = 6,lv = 29,exp = 2900,reward = [{0,38040005,20}],premium_reward = [{0,38040005,50}]};

get_base_fiesta_lv_exp(602,30) ->
	#base_fiesta_lv_exp{id = 602,act_id = 6,lv = 30,exp = 3000,reward = [{0,18010001,1}],premium_reward = [{0,35,188}]};

get_base_fiesta_lv_exp(602,31) ->
	#base_fiesta_lv_exp{id = 602,act_id = 6,lv = 31,exp = 3100,reward = [{0,32010119,1}],premium_reward = [{0,32010120,1}]};

get_base_fiesta_lv_exp(602,32) ->
	#base_fiesta_lv_exp{id = 602,act_id = 6,lv = 32,exp = 3200,reward = [{0,38370002,1}],premium_reward = [{0,38030004,1}]};

get_base_fiesta_lv_exp(602,33) ->
	#base_fiesta_lv_exp{id = 602,act_id = 6,lv = 33,exp = 3300,reward = [{0,38040005,20}],premium_reward = [{0,38040027,1}]};

get_base_fiesta_lv_exp(602,34) ->
	#base_fiesta_lv_exp{id = 602,act_id = 6,lv = 34,exp = 3400,reward = [{0,38100002,2}],premium_reward = [{0,38100002,5}]};

get_base_fiesta_lv_exp(602,35) ->
	#base_fiesta_lv_exp{id = 602,act_id = 6,lv = 35,exp = 3500,reward = [{0,32010001,2}],premium_reward = [{0,32010002,2}]};

get_base_fiesta_lv_exp(602,36) ->
	#base_fiesta_lv_exp{id = 602,act_id = 6,lv = 36,exp = 3600,reward = [{0,20020001,2}],premium_reward = [{0,20020002,1}]};

get_base_fiesta_lv_exp(602,37) ->
	#base_fiesta_lv_exp{id = 602,act_id = 6,lv = 37,exp = 3700,reward = [{0,32010001,2}],premium_reward = [{0,32010002,2}]};

get_base_fiesta_lv_exp(602,38) ->
	#base_fiesta_lv_exp{id = 602,act_id = 6,lv = 38,exp = 3800,reward = [{0,32010119,1}],premium_reward = [{0,32010120,1}]};

get_base_fiesta_lv_exp(602,39) ->
	#base_fiesta_lv_exp{id = 602,act_id = 6,lv = 39,exp = 3900,reward = [{0,20020001,2}],premium_reward = [{0,20020002,1}]};

get_base_fiesta_lv_exp(602,40) ->
	#base_fiesta_lv_exp{id = 602,act_id = 6,lv = 40,exp = 4000,reward = [{0,6101003,1}],premium_reward = [{0,6101004,1}]};

get_base_fiesta_lv_exp(602,41) ->
	#base_fiesta_lv_exp{id = 602,act_id = 6,lv = 41,exp = 4100,reward = [{0,19020001,2}],premium_reward = [{0,19020002,1}]};

get_base_fiesta_lv_exp(602,42) ->
	#base_fiesta_lv_exp{id = 602,act_id = 6,lv = 42,exp = 4200,reward = [{0,38100002,2}],premium_reward = [{0,38100002,5}]};

get_base_fiesta_lv_exp(602,43) ->
	#base_fiesta_lv_exp{id = 602,act_id = 6,lv = 43,exp = 4300,reward = [{0,38040005,20}],premium_reward = [{0,38040027,1}]};

get_base_fiesta_lv_exp(602,44) ->
	#base_fiesta_lv_exp{id = 602,act_id = 6,lv = 44,exp = 4400,reward = [{0,32010119,1}],premium_reward = [{0,32010120,1}]};

get_base_fiesta_lv_exp(602,45) ->
	#base_fiesta_lv_exp{id = 602,act_id = 6,lv = 45,exp = 4500,reward = [{0,38160001,1}],premium_reward = [{0,37020002,1}]};

get_base_fiesta_lv_exp(602,46) ->
	#base_fiesta_lv_exp{id = 602,act_id = 6,lv = 46,exp = 4600,reward = [{0,32010001,2}],premium_reward = [{0,32010002,2}]};

get_base_fiesta_lv_exp(602,47) ->
	#base_fiesta_lv_exp{id = 602,act_id = 6,lv = 47,exp = 4700,reward = [{0,19020001,2}],premium_reward = [{0,19020002,2}]};

get_base_fiesta_lv_exp(602,48) ->
	#base_fiesta_lv_exp{id = 602,act_id = 6,lv = 48,exp = 4800,reward = [{0,38100002,2}],premium_reward = [{0,38100002,5}]};

get_base_fiesta_lv_exp(602,49) ->
	#base_fiesta_lv_exp{id = 602,act_id = 6,lv = 49,exp = 4900,reward = [{0,38040005,20}],premium_reward = [{0,38040005,50}]};

get_base_fiesta_lv_exp(602,50) ->
	#base_fiesta_lv_exp{id = 602,act_id = 6,lv = 50,exp = 5000,reward = [{0,18010002,1}],premium_reward = [{0,32010517,1}]};

get_base_fiesta_lv_exp(602,51) ->
	#base_fiesta_lv_exp{id = 602,act_id = 6,lv = 51,exp = 5100,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(602,52) ->
	#base_fiesta_lv_exp{id = 602,act_id = 6,lv = 52,exp = 5200,reward = [{0,38100002,2}],premium_reward = [{0,38100002,5}]};

get_base_fiesta_lv_exp(602,53) ->
	#base_fiesta_lv_exp{id = 602,act_id = 6,lv = 53,exp = 5300,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(602,54) ->
	#base_fiesta_lv_exp{id = 602,act_id = 6,lv = 54,exp = 5400,reward = [{0,20020001,2}],premium_reward = [{0,20020002,1}]};

get_base_fiesta_lv_exp(602,55) ->
	#base_fiesta_lv_exp{id = 602,act_id = 6,lv = 55,exp = 5500,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(602,56) ->
	#base_fiesta_lv_exp{id = 602,act_id = 6,lv = 56,exp = 5600,reward = [{0,32010119,2}],premium_reward = [{0,32010120,1}]};

get_base_fiesta_lv_exp(602,57) ->
	#base_fiesta_lv_exp{id = 602,act_id = 6,lv = 57,exp = 5700,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(602,58) ->
	#base_fiesta_lv_exp{id = 602,act_id = 6,lv = 58,exp = 5800,reward = [{0,20020001,2}],premium_reward = [{0,20020002,1}]};

get_base_fiesta_lv_exp(602,59) ->
	#base_fiesta_lv_exp{id = 602,act_id = 6,lv = 59,exp = 5900,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(602,60) ->
	#base_fiesta_lv_exp{id = 602,act_id = 6,lv = 60,exp = 6000,reward = [{0,18010002,1}],premium_reward = [{0,35,268}]};

get_base_fiesta_lv_exp(602,61) ->
	#base_fiesta_lv_exp{id = 602,act_id = 6,lv = 61,exp = 6100,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(602,62) ->
	#base_fiesta_lv_exp{id = 602,act_id = 6,lv = 62,exp = 6200,reward = [{0,38370002,1}],premium_reward = [{0,38030004,1}]};

get_base_fiesta_lv_exp(602,63) ->
	#base_fiesta_lv_exp{id = 602,act_id = 6,lv = 63,exp = 6300,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(602,64) ->
	#base_fiesta_lv_exp{id = 602,act_id = 6,lv = 64,exp = 6400,reward = [{0,38100002,2}],premium_reward = [{0,38100002,5}]};

get_base_fiesta_lv_exp(602,65) ->
	#base_fiesta_lv_exp{id = 602,act_id = 6,lv = 65,exp = 6500,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(602,66) ->
	#base_fiesta_lv_exp{id = 602,act_id = 6,lv = 66,exp = 6600,reward = [{0,20020001,2}],premium_reward = [{0,20020002,1}]};

get_base_fiesta_lv_exp(602,67) ->
	#base_fiesta_lv_exp{id = 602,act_id = 6,lv = 67,exp = 6700,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(602,68) ->
	#base_fiesta_lv_exp{id = 602,act_id = 6,lv = 68,exp = 6800,reward = [{0,32010119,2}],premium_reward = [{0,32010120,1}]};

get_base_fiesta_lv_exp(602,69) ->
	#base_fiesta_lv_exp{id = 602,act_id = 6,lv = 69,exp = 6900,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(602,70) ->
	#base_fiesta_lv_exp{id = 602,act_id = 6,lv = 70,exp = 7000,reward = [{0,34010390,1}],premium_reward = [{0,6102001,1}]};

get_base_fiesta_lv_exp(602,71) ->
	#base_fiesta_lv_exp{id = 602,act_id = 6,lv = 71,exp = 7100,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(602,72) ->
	#base_fiesta_lv_exp{id = 602,act_id = 6,lv = 72,exp = 7200,reward = [{0,38100002,2}],premium_reward = [{0,38100002,5}]};

get_base_fiesta_lv_exp(602,73) ->
	#base_fiesta_lv_exp{id = 602,act_id = 6,lv = 73,exp = 7300,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(602,74) ->
	#base_fiesta_lv_exp{id = 602,act_id = 6,lv = 74,exp = 7400,reward = [{0,32010119,2}],premium_reward = [{0,32010120,1}]};

get_base_fiesta_lv_exp(602,75) ->
	#base_fiesta_lv_exp{id = 602,act_id = 6,lv = 75,exp = 7500,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(602,76) ->
	#base_fiesta_lv_exp{id = 602,act_id = 6,lv = 76,exp = 7600,reward = [{0,32010002,2}],premium_reward = [{0,32010003,2}]};

get_base_fiesta_lv_exp(602,77) ->
	#base_fiesta_lv_exp{id = 602,act_id = 6,lv = 77,exp = 7700,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(602,78) ->
	#base_fiesta_lv_exp{id = 602,act_id = 6,lv = 78,exp = 7800,reward = [{0,38100002,2}],premium_reward = [{0,38100002,5}]};

get_base_fiesta_lv_exp(602,79) ->
	#base_fiesta_lv_exp{id = 602,act_id = 6,lv = 79,exp = 7900,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(602,80) ->
	#base_fiesta_lv_exp{id = 602,act_id = 6,lv = 80,exp = 8000,reward = [{0,32010141,1}],premium_reward = [{0,35,368}]};

get_base_fiesta_lv_exp(602,81) ->
	#base_fiesta_lv_exp{id = 602,act_id = 6,lv = 81,exp = 8100,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(602,82) ->
	#base_fiesta_lv_exp{id = 602,act_id = 6,lv = 82,exp = 8200,reward = [{0,38370002,1}],premium_reward = [{0,38030004,1}]};

get_base_fiesta_lv_exp(602,83) ->
	#base_fiesta_lv_exp{id = 602,act_id = 6,lv = 83,exp = 8300,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(602,84) ->
	#base_fiesta_lv_exp{id = 602,act_id = 6,lv = 84,exp = 8400,reward = [{0,38100002,2}],premium_reward = [{0,38100002,5}]};

get_base_fiesta_lv_exp(602,85) ->
	#base_fiesta_lv_exp{id = 602,act_id = 6,lv = 85,exp = 8500,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(602,86) ->
	#base_fiesta_lv_exp{id = 602,act_id = 6,lv = 86,exp = 8600,reward = [{0,20020001,2}],premium_reward = [{0,20020002,1}]};

get_base_fiesta_lv_exp(602,87) ->
	#base_fiesta_lv_exp{id = 602,act_id = 6,lv = 87,exp = 8700,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(602,88) ->
	#base_fiesta_lv_exp{id = 602,act_id = 6,lv = 88,exp = 8800,reward = [{0,32010119,3}],premium_reward = [{0,32010120,2}]};

get_base_fiesta_lv_exp(602,89) ->
	#base_fiesta_lv_exp{id = 602,act_id = 6,lv = 89,exp = 8900,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(602,90) ->
	#base_fiesta_lv_exp{id = 602,act_id = 6,lv = 90,exp = 9000,reward = [{0,18010003,1}],premium_reward = [{0,32010517,1}]};

get_base_fiesta_lv_exp(602,91) ->
	#base_fiesta_lv_exp{id = 602,act_id = 6,lv = 91,exp = 9100,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(602,92) ->
	#base_fiesta_lv_exp{id = 602,act_id = 6,lv = 92,exp = 9200,reward = [{0,38100002,2}],premium_reward = [{0,38100002,5}]};

get_base_fiesta_lv_exp(602,93) ->
	#base_fiesta_lv_exp{id = 602,act_id = 6,lv = 93,exp = 9300,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(602,94) ->
	#base_fiesta_lv_exp{id = 602,act_id = 6,lv = 94,exp = 9400,reward = [{0,20020001,2}],premium_reward = [{0,20020002,1}]};

get_base_fiesta_lv_exp(602,95) ->
	#base_fiesta_lv_exp{id = 602,act_id = 6,lv = 95,exp = 9500,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(602,96) ->
	#base_fiesta_lv_exp{id = 602,act_id = 6,lv = 96,exp = 9600,reward = [{0,32010119,3}],premium_reward = [{0,32010120,3}]};

get_base_fiesta_lv_exp(602,97) ->
	#base_fiesta_lv_exp{id = 602,act_id = 6,lv = 97,exp = 9700,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(602,98) ->
	#base_fiesta_lv_exp{id = 602,act_id = 6,lv = 98,exp = 9800,reward = [{0,20020001,2}],premium_reward = [{0,20020002,1}]};

get_base_fiesta_lv_exp(602,99) ->
	#base_fiesta_lv_exp{id = 602,act_id = 6,lv = 99,exp = 9900,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(602,100) ->
	#base_fiesta_lv_exp{id = 602,act_id = 6,lv = 100,exp = 10000,reward = [{0,35,128}],premium_reward = [{0,18030116,30}]};

get_base_fiesta_lv_exp(602,101) ->
	#base_fiesta_lv_exp{id = 602,act_id = 6,lv = 101,exp = 10100,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(602,102) ->
	#base_fiesta_lv_exp{id = 602,act_id = 6,lv = 102,exp = 10200,reward = [{0,39510000,4}],premium_reward = [{0,39510000,10}]};

get_base_fiesta_lv_exp(602,103) ->
	#base_fiesta_lv_exp{id = 602,act_id = 6,lv = 103,exp = 10300,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(602,104) ->
	#base_fiesta_lv_exp{id = 602,act_id = 6,lv = 104,exp = 10400,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(602,105) ->
	#base_fiesta_lv_exp{id = 602,act_id = 6,lv = 105,exp = 10500,reward = [{0,38040018,4}],premium_reward = [{0,38040018,10}]};

get_base_fiesta_lv_exp(602,106) ->
	#base_fiesta_lv_exp{id = 602,act_id = 6,lv = 106,exp = 10600,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(602,107) ->
	#base_fiesta_lv_exp{id = 602,act_id = 6,lv = 107,exp = 10700,reward = [{0,39510000,4}],premium_reward = [{0,39510000,10}]};

get_base_fiesta_lv_exp(602,108) ->
	#base_fiesta_lv_exp{id = 602,act_id = 6,lv = 108,exp = 10800,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(602,109) ->
	#base_fiesta_lv_exp{id = 602,act_id = 6,lv = 109,exp = 10900,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(602,110) ->
	#base_fiesta_lv_exp{id = 602,act_id = 6,lv = 110,exp = 11000,reward = [{0,38040018,4}],premium_reward = [{0,38040018,10}]};

get_base_fiesta_lv_exp(602,111) ->
	#base_fiesta_lv_exp{id = 602,act_id = 6,lv = 111,exp = 11100,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(602,112) ->
	#base_fiesta_lv_exp{id = 602,act_id = 6,lv = 112,exp = 11200,reward = [{0,39510000,4}],premium_reward = [{0,39510000,10}]};

get_base_fiesta_lv_exp(602,113) ->
	#base_fiesta_lv_exp{id = 602,act_id = 6,lv = 113,exp = 11300,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(602,114) ->
	#base_fiesta_lv_exp{id = 602,act_id = 6,lv = 114,exp = 11400,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(602,115) ->
	#base_fiesta_lv_exp{id = 602,act_id = 6,lv = 115,exp = 11500,reward = [{0,38040018,4}],premium_reward = [{0,38040018,10}]};

get_base_fiesta_lv_exp(602,116) ->
	#base_fiesta_lv_exp{id = 602,act_id = 6,lv = 116,exp = 11600,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(602,117) ->
	#base_fiesta_lv_exp{id = 602,act_id = 6,lv = 117,exp = 11700,reward = [{0,39510000,4}],premium_reward = [{0,39510000,10}]};

get_base_fiesta_lv_exp(602,118) ->
	#base_fiesta_lv_exp{id = 602,act_id = 6,lv = 118,exp = 11800,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(602,119) ->
	#base_fiesta_lv_exp{id = 602,act_id = 6,lv = 119,exp = 11900,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(602,120) ->
	#base_fiesta_lv_exp{id = 602,act_id = 6,lv = 120,exp = 12000,reward = [{0,38040018,4}],premium_reward = [{0,38040018,10}]};

get_base_fiesta_lv_exp(602,121) ->
	#base_fiesta_lv_exp{id = 602,act_id = 6,lv = 121,exp = 12100,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(602,122) ->
	#base_fiesta_lv_exp{id = 602,act_id = 6,lv = 122,exp = 12200,reward = [{0,39510000,4}],premium_reward = [{0,39510000,10}]};

get_base_fiesta_lv_exp(602,123) ->
	#base_fiesta_lv_exp{id = 602,act_id = 6,lv = 123,exp = 12300,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(602,124) ->
	#base_fiesta_lv_exp{id = 602,act_id = 6,lv = 124,exp = 12400,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(602,125) ->
	#base_fiesta_lv_exp{id = 602,act_id = 6,lv = 125,exp = 12500,reward = [{0,38040018,4}],premium_reward = [{0,38040018,10}]};

get_base_fiesta_lv_exp(602,126) ->
	#base_fiesta_lv_exp{id = 602,act_id = 6,lv = 126,exp = 12600,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(602,127) ->
	#base_fiesta_lv_exp{id = 602,act_id = 6,lv = 127,exp = 12700,reward = [{0,39510000,4}],premium_reward = [{0,39510000,10}]};

get_base_fiesta_lv_exp(602,128) ->
	#base_fiesta_lv_exp{id = 602,act_id = 6,lv = 128,exp = 12800,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(602,129) ->
	#base_fiesta_lv_exp{id = 602,act_id = 6,lv = 129,exp = 12900,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(602,130) ->
	#base_fiesta_lv_exp{id = 602,act_id = 6,lv = 130,exp = 13000,reward = [{0,38040018,4}],premium_reward = [{0,38040018,10}]};

get_base_fiesta_lv_exp(602,131) ->
	#base_fiesta_lv_exp{id = 602,act_id = 6,lv = 131,exp = 13100,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(602,132) ->
	#base_fiesta_lv_exp{id = 602,act_id = 6,lv = 132,exp = 13200,reward = [{0,39510000,4}],premium_reward = [{0,39510000,10}]};

get_base_fiesta_lv_exp(602,133) ->
	#base_fiesta_lv_exp{id = 602,act_id = 6,lv = 133,exp = 13300,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(602,134) ->
	#base_fiesta_lv_exp{id = 602,act_id = 6,lv = 134,exp = 13400,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(602,135) ->
	#base_fiesta_lv_exp{id = 602,act_id = 6,lv = 135,exp = 13500,reward = [{0,38040018,4}],premium_reward = [{0,38040018,10}]};

get_base_fiesta_lv_exp(602,136) ->
	#base_fiesta_lv_exp{id = 602,act_id = 6,lv = 136,exp = 13600,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(602,137) ->
	#base_fiesta_lv_exp{id = 602,act_id = 6,lv = 137,exp = 13700,reward = [{0,39510000,4}],premium_reward = [{0,39510000,10}]};

get_base_fiesta_lv_exp(602,138) ->
	#base_fiesta_lv_exp{id = 602,act_id = 6,lv = 138,exp = 13800,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(602,139) ->
	#base_fiesta_lv_exp{id = 602,act_id = 6,lv = 139,exp = 13900,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(602,140) ->
	#base_fiesta_lv_exp{id = 602,act_id = 6,lv = 140,exp = 14000,reward = [{0,38040018,4}],premium_reward = [{0,38040018,10}]};

get_base_fiesta_lv_exp(602,141) ->
	#base_fiesta_lv_exp{id = 602,act_id = 6,lv = 141,exp = 14100,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(602,142) ->
	#base_fiesta_lv_exp{id = 602,act_id = 6,lv = 142,exp = 14200,reward = [{0,39510000,4}],premium_reward = [{0,39510000,10}]};

get_base_fiesta_lv_exp(602,143) ->
	#base_fiesta_lv_exp{id = 602,act_id = 6,lv = 143,exp = 14300,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(602,144) ->
	#base_fiesta_lv_exp{id = 602,act_id = 6,lv = 144,exp = 14400,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(602,145) ->
	#base_fiesta_lv_exp{id = 602,act_id = 6,lv = 145,exp = 14500,reward = [{0,38040018,4}],premium_reward = [{0,38040018,10}]};

get_base_fiesta_lv_exp(602,146) ->
	#base_fiesta_lv_exp{id = 602,act_id = 6,lv = 146,exp = 14600,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(602,147) ->
	#base_fiesta_lv_exp{id = 602,act_id = 6,lv = 147,exp = 14700,reward = [{0,39510000,4}],premium_reward = [{0,39510000,10}]};

get_base_fiesta_lv_exp(602,148) ->
	#base_fiesta_lv_exp{id = 602,act_id = 6,lv = 148,exp = 14800,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(602,149) ->
	#base_fiesta_lv_exp{id = 602,act_id = 6,lv = 149,exp = 14900,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(602,150) ->
	#base_fiesta_lv_exp{id = 602,act_id = 6,lv = 150,exp = 15000,reward = [{0,38040018,4}],premium_reward = [{0,38040018,10}]};

get_base_fiesta_lv_exp(603,1) ->
	#base_fiesta_lv_exp{id = 603,act_id = 6,lv = 1,exp = 100,reward = [{0,7301001,2}],premium_reward = [{0,7301002,1}]};

get_base_fiesta_lv_exp(603,2) ->
	#base_fiesta_lv_exp{id = 603,act_id = 6,lv = 2,exp = 200,reward = [{0,38040005,20}],premium_reward = [{0,38040005,30}]};

get_base_fiesta_lv_exp(603,3) ->
	#base_fiesta_lv_exp{id = 603,act_id = 6,lv = 3,exp = 300,reward = [{0,7301001,2}],premium_reward = [{0,7301002,1}]};

get_base_fiesta_lv_exp(603,4) ->
	#base_fiesta_lv_exp{id = 603,act_id = 6,lv = 4,exp = 400,reward = [{0,38370001,1}],premium_reward = [{0,38160001,1}]};

get_base_fiesta_lv_exp(603,5) ->
	#base_fiesta_lv_exp{id = 603,act_id = 6,lv = 5,exp = 500,reward = [{0,37020001,2}],premium_reward = [{0,37121002,1}]};

get_base_fiesta_lv_exp(603,6) ->
	#base_fiesta_lv_exp{id = 603,act_id = 6,lv = 6,exp = 600,reward = [{0,32010119,1}],premium_reward = [{0,32010120,1}]};

get_base_fiesta_lv_exp(603,7) ->
	#base_fiesta_lv_exp{id = 603,act_id = 6,lv = 7,exp = 700,reward = [{0,38030005,1}],premium_reward = [{0,38030004,2}]};

get_base_fiesta_lv_exp(603,8) ->
	#base_fiesta_lv_exp{id = 603,act_id = 6,lv = 8,exp = 800,reward = [{0,7301001,2}],premium_reward = [{0,7301002,1}]};

get_base_fiesta_lv_exp(603,9) ->
	#base_fiesta_lv_exp{id = 603,act_id = 6,lv = 9,exp = 900,reward = [{0,38100002,2}],premium_reward = [{0,38100002,5}]};

get_base_fiesta_lv_exp(603,10) ->
	#base_fiesta_lv_exp{id = 603,act_id = 6,lv = 10,exp = 1000,reward = [{0,39510021,1}],premium_reward = [{0,35,128}]};

get_base_fiesta_lv_exp(603,11) ->
	#base_fiesta_lv_exp{id = 603,act_id = 6,lv = 11,exp = 1100,reward = [{0,7301001,2}],premium_reward = [{0,7301002,1}]};

get_base_fiesta_lv_exp(603,12) ->
	#base_fiesta_lv_exp{id = 603,act_id = 6,lv = 12,exp = 1200,reward = [{0,38100002,2}],premium_reward = [{0,38100002,5}]};

get_base_fiesta_lv_exp(603,13) ->
	#base_fiesta_lv_exp{id = 603,act_id = 6,lv = 13,exp = 1300,reward = [{0,38040005,20}],premium_reward = [{0,38040027,1}]};

get_base_fiesta_lv_exp(603,14) ->
	#base_fiesta_lv_exp{id = 603,act_id = 6,lv = 14,exp = 1400,reward = [{0,32010119,1}],premium_reward = [{0,32010120,1}]};

get_base_fiesta_lv_exp(603,15) ->
	#base_fiesta_lv_exp{id = 603,act_id = 6,lv = 15,exp = 1500,reward = [{0,38160001,1}],premium_reward = [{0,37020002,1}]};

get_base_fiesta_lv_exp(603,16) ->
	#base_fiesta_lv_exp{id = 603,act_id = 6,lv = 16,exp = 1600,reward = [{0,32010001,1}],premium_reward = [{0,32010002,1}]};

get_base_fiesta_lv_exp(603,17) ->
	#base_fiesta_lv_exp{id = 603,act_id = 6,lv = 17,exp = 1700,reward = [{0,7301001,2}],premium_reward = [{0,7301002,2}]};

get_base_fiesta_lv_exp(603,18) ->
	#base_fiesta_lv_exp{id = 603,act_id = 6,lv = 18,exp = 1800,reward = [{0,38100002,2}],premium_reward = [{0,38100002,5}]};

get_base_fiesta_lv_exp(603,19) ->
	#base_fiesta_lv_exp{id = 603,act_id = 6,lv = 19,exp = 1900,reward = [{0,32010001,1}],premium_reward = [{0,32010002,1}]};

get_base_fiesta_lv_exp(603,20) ->
	#base_fiesta_lv_exp{id = 603,act_id = 6,lv = 20,exp = 2000,reward = [{0,20010001,1}],premium_reward = [{0,37121003,1}]};

get_base_fiesta_lv_exp(603,21) ->
	#base_fiesta_lv_exp{id = 603,act_id = 6,lv = 21,exp = 2100,reward = [{0,7301003,2}],premium_reward = [{0,7301004,1}]};

get_base_fiesta_lv_exp(603,22) ->
	#base_fiesta_lv_exp{id = 603,act_id = 6,lv = 22,exp = 2200,reward = [{0,38100002,2}],premium_reward = [{0,38100002,5}]};

get_base_fiesta_lv_exp(603,23) ->
	#base_fiesta_lv_exp{id = 603,act_id = 6,lv = 23,exp = 2300,reward = [{0,32010001,1}],premium_reward = [{0,32010002,1}]};

get_base_fiesta_lv_exp(603,24) ->
	#base_fiesta_lv_exp{id = 603,act_id = 6,lv = 24,exp = 2400,reward = [{0,7301003,2}],premium_reward = [{0,7301004,1}]};

get_base_fiesta_lv_exp(603,25) ->
	#base_fiesta_lv_exp{id = 603,act_id = 6,lv = 25,exp = 2500,reward = [{0,7301001,2}],premium_reward = [{0,7301002,1}]};

get_base_fiesta_lv_exp(603,26) ->
	#base_fiesta_lv_exp{id = 603,act_id = 6,lv = 26,exp = 2600,reward = [{0,32010119,1}],premium_reward = [{0,32010120,1}]};

get_base_fiesta_lv_exp(603,27) ->
	#base_fiesta_lv_exp{id = 603,act_id = 6,lv = 27,exp = 2700,reward = [{0,38030005,1}],premium_reward = [{0,38030004,2}]};

get_base_fiesta_lv_exp(603,28) ->
	#base_fiesta_lv_exp{id = 603,act_id = 6,lv = 28,exp = 2800,reward = [{0,7301003,2}],premium_reward = [{0,7301004,1}]};

get_base_fiesta_lv_exp(603,29) ->
	#base_fiesta_lv_exp{id = 603,act_id = 6,lv = 29,exp = 2900,reward = [{0,38040005,20}],premium_reward = [{0,38040005,50}]};

get_base_fiesta_lv_exp(603,30) ->
	#base_fiesta_lv_exp{id = 603,act_id = 6,lv = 30,exp = 3000,reward = [{0,20010001,1}],premium_reward = [{0,35,188}]};

get_base_fiesta_lv_exp(603,31) ->
	#base_fiesta_lv_exp{id = 603,act_id = 6,lv = 31,exp = 3100,reward = [{0,32010119,1}],premium_reward = [{0,32010120,1}]};

get_base_fiesta_lv_exp(603,32) ->
	#base_fiesta_lv_exp{id = 603,act_id = 6,lv = 32,exp = 3200,reward = [{0,38370002,1}],premium_reward = [{0,38030004,1}]};

get_base_fiesta_lv_exp(603,33) ->
	#base_fiesta_lv_exp{id = 603,act_id = 6,lv = 33,exp = 3300,reward = [{0,38040005,20}],premium_reward = [{0,38040027,1}]};

get_base_fiesta_lv_exp(603,34) ->
	#base_fiesta_lv_exp{id = 603,act_id = 6,lv = 34,exp = 3400,reward = [{0,38100002,2}],premium_reward = [{0,38100002,5}]};

get_base_fiesta_lv_exp(603,35) ->
	#base_fiesta_lv_exp{id = 603,act_id = 6,lv = 35,exp = 3500,reward = [{0,32010001,2}],premium_reward = [{0,32010002,2}]};

get_base_fiesta_lv_exp(603,36) ->
	#base_fiesta_lv_exp{id = 603,act_id = 6,lv = 36,exp = 3600,reward = [{0,7301003,2}],premium_reward = [{0,7301004,1}]};

get_base_fiesta_lv_exp(603,37) ->
	#base_fiesta_lv_exp{id = 603,act_id = 6,lv = 37,exp = 3700,reward = [{0,32010001,2}],premium_reward = [{0,32010002,2}]};

get_base_fiesta_lv_exp(603,38) ->
	#base_fiesta_lv_exp{id = 603,act_id = 6,lv = 38,exp = 3800,reward = [{0,32010119,1}],premium_reward = [{0,32010120,1}]};

get_base_fiesta_lv_exp(603,39) ->
	#base_fiesta_lv_exp{id = 603,act_id = 6,lv = 39,exp = 3900,reward = [{0,7301003,2}],premium_reward = [{0,7301004,1}]};

get_base_fiesta_lv_exp(603,40) ->
	#base_fiesta_lv_exp{id = 603,act_id = 6,lv = 40,exp = 4000,reward = [{0,6101003,1}],premium_reward = [{0,6101004,1}]};

get_base_fiesta_lv_exp(603,41) ->
	#base_fiesta_lv_exp{id = 603,act_id = 6,lv = 41,exp = 4100,reward = [{0,7301001,2}],premium_reward = [{0,7301002,1}]};

get_base_fiesta_lv_exp(603,42) ->
	#base_fiesta_lv_exp{id = 603,act_id = 6,lv = 42,exp = 4200,reward = [{0,38100002,2}],premium_reward = [{0,38100002,5}]};

get_base_fiesta_lv_exp(603,43) ->
	#base_fiesta_lv_exp{id = 603,act_id = 6,lv = 43,exp = 4300,reward = [{0,38040005,20}],premium_reward = [{0,38040027,1}]};

get_base_fiesta_lv_exp(603,44) ->
	#base_fiesta_lv_exp{id = 603,act_id = 6,lv = 44,exp = 4400,reward = [{0,32010119,1}],premium_reward = [{0,32010120,1}]};

get_base_fiesta_lv_exp(603,45) ->
	#base_fiesta_lv_exp{id = 603,act_id = 6,lv = 45,exp = 4500,reward = [{0,38160001,1}],premium_reward = [{0,37020002,1}]};

get_base_fiesta_lv_exp(603,46) ->
	#base_fiesta_lv_exp{id = 603,act_id = 6,lv = 46,exp = 4600,reward = [{0,32010001,2}],premium_reward = [{0,32010002,2}]};

get_base_fiesta_lv_exp(603,47) ->
	#base_fiesta_lv_exp{id = 603,act_id = 6,lv = 47,exp = 4700,reward = [{0,7301001,2}],premium_reward = [{0,7301002,2}]};

get_base_fiesta_lv_exp(603,48) ->
	#base_fiesta_lv_exp{id = 603,act_id = 6,lv = 48,exp = 4800,reward = [{0,38100002,2}],premium_reward = [{0,38100002,5}]};

get_base_fiesta_lv_exp(603,49) ->
	#base_fiesta_lv_exp{id = 603,act_id = 6,lv = 49,exp = 4900,reward = [{0,38040005,20}],premium_reward = [{0,38040005,50}]};

get_base_fiesta_lv_exp(603,50) ->
	#base_fiesta_lv_exp{id = 603,act_id = 6,lv = 50,exp = 5000,reward = [{0,20010002,1}],premium_reward = [{0,32010517,1}]};

get_base_fiesta_lv_exp(603,51) ->
	#base_fiesta_lv_exp{id = 603,act_id = 6,lv = 51,exp = 5100,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(603,52) ->
	#base_fiesta_lv_exp{id = 603,act_id = 6,lv = 52,exp = 5200,reward = [{0,38100002,2}],premium_reward = [{0,38100002,5}]};

get_base_fiesta_lv_exp(603,53) ->
	#base_fiesta_lv_exp{id = 603,act_id = 6,lv = 53,exp = 5300,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(603,54) ->
	#base_fiesta_lv_exp{id = 603,act_id = 6,lv = 54,exp = 5400,reward = [{0,7301003,2}],premium_reward = [{0,7301004,1}]};

get_base_fiesta_lv_exp(603,55) ->
	#base_fiesta_lv_exp{id = 603,act_id = 6,lv = 55,exp = 5500,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(603,56) ->
	#base_fiesta_lv_exp{id = 603,act_id = 6,lv = 56,exp = 5600,reward = [{0,32010119,2}],premium_reward = [{0,32010120,1}]};

get_base_fiesta_lv_exp(603,57) ->
	#base_fiesta_lv_exp{id = 603,act_id = 6,lv = 57,exp = 5700,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(603,58) ->
	#base_fiesta_lv_exp{id = 603,act_id = 6,lv = 58,exp = 5800,reward = [{0,7301003,2}],premium_reward = [{0,7301004,1}]};

get_base_fiesta_lv_exp(603,59) ->
	#base_fiesta_lv_exp{id = 603,act_id = 6,lv = 59,exp = 5900,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(603,60) ->
	#base_fiesta_lv_exp{id = 603,act_id = 6,lv = 60,exp = 6000,reward = [{0,20010002,1}],premium_reward = [{0,35,268}]};

get_base_fiesta_lv_exp(603,61) ->
	#base_fiesta_lv_exp{id = 603,act_id = 6,lv = 61,exp = 6100,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(603,62) ->
	#base_fiesta_lv_exp{id = 603,act_id = 6,lv = 62,exp = 6200,reward = [{0,38370002,1}],premium_reward = [{0,38030004,1}]};

get_base_fiesta_lv_exp(603,63) ->
	#base_fiesta_lv_exp{id = 603,act_id = 6,lv = 63,exp = 6300,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(603,64) ->
	#base_fiesta_lv_exp{id = 603,act_id = 6,lv = 64,exp = 6400,reward = [{0,38100002,2}],premium_reward = [{0,38100002,5}]};

get_base_fiesta_lv_exp(603,65) ->
	#base_fiesta_lv_exp{id = 603,act_id = 6,lv = 65,exp = 6500,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(603,66) ->
	#base_fiesta_lv_exp{id = 603,act_id = 6,lv = 66,exp = 6600,reward = [{0,7301003,2}],premium_reward = [{0,7301004,1}]};

get_base_fiesta_lv_exp(603,67) ->
	#base_fiesta_lv_exp{id = 603,act_id = 6,lv = 67,exp = 6700,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(603,68) ->
	#base_fiesta_lv_exp{id = 603,act_id = 6,lv = 68,exp = 6800,reward = [{0,32010119,2}],premium_reward = [{0,32010120,1}]};

get_base_fiesta_lv_exp(603,69) ->
	#base_fiesta_lv_exp{id = 603,act_id = 6,lv = 69,exp = 6900,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(603,70) ->
	#base_fiesta_lv_exp{id = 603,act_id = 6,lv = 70,exp = 7000,reward = [{0,34010390,1}],premium_reward = [{0,6102001,1}]};

get_base_fiesta_lv_exp(603,71) ->
	#base_fiesta_lv_exp{id = 603,act_id = 6,lv = 71,exp = 7100,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(603,72) ->
	#base_fiesta_lv_exp{id = 603,act_id = 6,lv = 72,exp = 7200,reward = [{0,38100002,2}],premium_reward = [{0,38100002,5}]};

get_base_fiesta_lv_exp(603,73) ->
	#base_fiesta_lv_exp{id = 603,act_id = 6,lv = 73,exp = 7300,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(603,74) ->
	#base_fiesta_lv_exp{id = 603,act_id = 6,lv = 74,exp = 7400,reward = [{0,32010119,2}],premium_reward = [{0,32010120,1}]};

get_base_fiesta_lv_exp(603,75) ->
	#base_fiesta_lv_exp{id = 603,act_id = 6,lv = 75,exp = 7500,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(603,76) ->
	#base_fiesta_lv_exp{id = 603,act_id = 6,lv = 76,exp = 7600,reward = [{0,32010002,2}],premium_reward = [{0,32010003,2}]};

get_base_fiesta_lv_exp(603,77) ->
	#base_fiesta_lv_exp{id = 603,act_id = 6,lv = 77,exp = 7700,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(603,78) ->
	#base_fiesta_lv_exp{id = 603,act_id = 6,lv = 78,exp = 7800,reward = [{0,38100002,2}],premium_reward = [{0,38100002,5}]};

get_base_fiesta_lv_exp(603,79) ->
	#base_fiesta_lv_exp{id = 603,act_id = 6,lv = 79,exp = 7900,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(603,80) ->
	#base_fiesta_lv_exp{id = 603,act_id = 6,lv = 80,exp = 8000,reward = [{0,39510025,1}],premium_reward = [{0,35,368}]};

get_base_fiesta_lv_exp(603,81) ->
	#base_fiesta_lv_exp{id = 603,act_id = 6,lv = 81,exp = 8100,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(603,82) ->
	#base_fiesta_lv_exp{id = 603,act_id = 6,lv = 82,exp = 8200,reward = [{0,38370002,1}],premium_reward = [{0,38030004,1}]};

get_base_fiesta_lv_exp(603,83) ->
	#base_fiesta_lv_exp{id = 603,act_id = 6,lv = 83,exp = 8300,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(603,84) ->
	#base_fiesta_lv_exp{id = 603,act_id = 6,lv = 84,exp = 8400,reward = [{0,38100002,2}],premium_reward = [{0,38100002,5}]};

get_base_fiesta_lv_exp(603,85) ->
	#base_fiesta_lv_exp{id = 603,act_id = 6,lv = 85,exp = 8500,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(603,86) ->
	#base_fiesta_lv_exp{id = 603,act_id = 6,lv = 86,exp = 8600,reward = [{0,7301003,2}],premium_reward = [{0,7301004,1}]};

get_base_fiesta_lv_exp(603,87) ->
	#base_fiesta_lv_exp{id = 603,act_id = 6,lv = 87,exp = 8700,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(603,88) ->
	#base_fiesta_lv_exp{id = 603,act_id = 6,lv = 88,exp = 8800,reward = [{0,32010119,3}],premium_reward = [{0,32010120,2}]};

get_base_fiesta_lv_exp(603,89) ->
	#base_fiesta_lv_exp{id = 603,act_id = 6,lv = 89,exp = 8900,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(603,90) ->
	#base_fiesta_lv_exp{id = 603,act_id = 6,lv = 90,exp = 9000,reward = [{0,20010003,1}],premium_reward = [{0,32010517,1}]};

get_base_fiesta_lv_exp(603,91) ->
	#base_fiesta_lv_exp{id = 603,act_id = 6,lv = 91,exp = 9100,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(603,92) ->
	#base_fiesta_lv_exp{id = 603,act_id = 6,lv = 92,exp = 9200,reward = [{0,38100002,2}],premium_reward = [{0,38100002,5}]};

get_base_fiesta_lv_exp(603,93) ->
	#base_fiesta_lv_exp{id = 603,act_id = 6,lv = 93,exp = 9300,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(603,94) ->
	#base_fiesta_lv_exp{id = 603,act_id = 6,lv = 94,exp = 9400,reward = [{0,7301003,2}],premium_reward = [{0,7301004,1}]};

get_base_fiesta_lv_exp(603,95) ->
	#base_fiesta_lv_exp{id = 603,act_id = 6,lv = 95,exp = 9500,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(603,96) ->
	#base_fiesta_lv_exp{id = 603,act_id = 6,lv = 96,exp = 9600,reward = [{0,32010119,3}],premium_reward = [{0,32010120,3}]};

get_base_fiesta_lv_exp(603,97) ->
	#base_fiesta_lv_exp{id = 603,act_id = 6,lv = 97,exp = 9700,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(603,98) ->
	#base_fiesta_lv_exp{id = 603,act_id = 6,lv = 98,exp = 9800,reward = [{0,7301003,2}],premium_reward = [{0,7301004,1}]};

get_base_fiesta_lv_exp(603,99) ->
	#base_fiesta_lv_exp{id = 603,act_id = 6,lv = 99,exp = 9900,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(603,100) ->
	#base_fiesta_lv_exp{id = 603,act_id = 6,lv = 100,exp = 10000,reward = [{0,35,128}],premium_reward = [{0,18030116,30}]};

get_base_fiesta_lv_exp(603,101) ->
	#base_fiesta_lv_exp{id = 603,act_id = 6,lv = 101,exp = 10100,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(603,102) ->
	#base_fiesta_lv_exp{id = 603,act_id = 6,lv = 102,exp = 10200,reward = [{0,801701,2}],premium_reward = [{0,801702,5}]};

get_base_fiesta_lv_exp(603,103) ->
	#base_fiesta_lv_exp{id = 603,act_id = 6,lv = 103,exp = 10300,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(603,104) ->
	#base_fiesta_lv_exp{id = 603,act_id = 6,lv = 104,exp = 10400,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(603,105) ->
	#base_fiesta_lv_exp{id = 603,act_id = 6,lv = 105,exp = 10500,reward = [{0,801701,2}],premium_reward = [{0,801702,5}]};

get_base_fiesta_lv_exp(603,106) ->
	#base_fiesta_lv_exp{id = 603,act_id = 6,lv = 106,exp = 10600,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(603,107) ->
	#base_fiesta_lv_exp{id = 603,act_id = 6,lv = 107,exp = 10700,reward = [{0,801701,2}],premium_reward = [{0,801702,5}]};

get_base_fiesta_lv_exp(603,108) ->
	#base_fiesta_lv_exp{id = 603,act_id = 6,lv = 108,exp = 10800,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(603,109) ->
	#base_fiesta_lv_exp{id = 603,act_id = 6,lv = 109,exp = 10900,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(603,110) ->
	#base_fiesta_lv_exp{id = 603,act_id = 6,lv = 110,exp = 11000,reward = [{0,801701,2}],premium_reward = [{0,801702,5}]};

get_base_fiesta_lv_exp(603,111) ->
	#base_fiesta_lv_exp{id = 603,act_id = 6,lv = 111,exp = 11100,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(603,112) ->
	#base_fiesta_lv_exp{id = 603,act_id = 6,lv = 112,exp = 11200,reward = [{0,801701,2}],premium_reward = [{0,801702,5}]};

get_base_fiesta_lv_exp(603,113) ->
	#base_fiesta_lv_exp{id = 603,act_id = 6,lv = 113,exp = 11300,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(603,114) ->
	#base_fiesta_lv_exp{id = 603,act_id = 6,lv = 114,exp = 11400,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(603,115) ->
	#base_fiesta_lv_exp{id = 603,act_id = 6,lv = 115,exp = 11500,reward = [{0,801701,2}],premium_reward = [{0,801702,5}]};

get_base_fiesta_lv_exp(603,116) ->
	#base_fiesta_lv_exp{id = 603,act_id = 6,lv = 116,exp = 11600,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(603,117) ->
	#base_fiesta_lv_exp{id = 603,act_id = 6,lv = 117,exp = 11700,reward = [{0,801701,2}],premium_reward = [{0,801702,5}]};

get_base_fiesta_lv_exp(603,118) ->
	#base_fiesta_lv_exp{id = 603,act_id = 6,lv = 118,exp = 11800,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(603,119) ->
	#base_fiesta_lv_exp{id = 603,act_id = 6,lv = 119,exp = 11900,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(603,120) ->
	#base_fiesta_lv_exp{id = 603,act_id = 6,lv = 120,exp = 12000,reward = [{0,801701,2}],premium_reward = [{0,801702,5}]};

get_base_fiesta_lv_exp(603,121) ->
	#base_fiesta_lv_exp{id = 603,act_id = 6,lv = 121,exp = 12100,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(603,122) ->
	#base_fiesta_lv_exp{id = 603,act_id = 6,lv = 122,exp = 12200,reward = [{0,801701,2}],premium_reward = [{0,801702,5}]};

get_base_fiesta_lv_exp(603,123) ->
	#base_fiesta_lv_exp{id = 603,act_id = 6,lv = 123,exp = 12300,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(603,124) ->
	#base_fiesta_lv_exp{id = 603,act_id = 6,lv = 124,exp = 12400,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(603,125) ->
	#base_fiesta_lv_exp{id = 603,act_id = 6,lv = 125,exp = 12500,reward = [{0,801701,2}],premium_reward = [{0,801702,5}]};

get_base_fiesta_lv_exp(603,126) ->
	#base_fiesta_lv_exp{id = 603,act_id = 6,lv = 126,exp = 12600,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(603,127) ->
	#base_fiesta_lv_exp{id = 603,act_id = 6,lv = 127,exp = 12700,reward = [{0,801701,2}],premium_reward = [{0,801702,5}]};

get_base_fiesta_lv_exp(603,128) ->
	#base_fiesta_lv_exp{id = 603,act_id = 6,lv = 128,exp = 12800,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(603,129) ->
	#base_fiesta_lv_exp{id = 603,act_id = 6,lv = 129,exp = 12900,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(603,130) ->
	#base_fiesta_lv_exp{id = 603,act_id = 6,lv = 130,exp = 13000,reward = [{0,801701,2}],premium_reward = [{0,801702,5}]};

get_base_fiesta_lv_exp(603,131) ->
	#base_fiesta_lv_exp{id = 603,act_id = 6,lv = 131,exp = 13100,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(603,132) ->
	#base_fiesta_lv_exp{id = 603,act_id = 6,lv = 132,exp = 13200,reward = [{0,801701,2}],premium_reward = [{0,801702,5}]};

get_base_fiesta_lv_exp(603,133) ->
	#base_fiesta_lv_exp{id = 603,act_id = 6,lv = 133,exp = 13300,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(603,134) ->
	#base_fiesta_lv_exp{id = 603,act_id = 6,lv = 134,exp = 13400,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(603,135) ->
	#base_fiesta_lv_exp{id = 603,act_id = 6,lv = 135,exp = 13500,reward = [{0,801701,2}],premium_reward = [{0,801702,5}]};

get_base_fiesta_lv_exp(603,136) ->
	#base_fiesta_lv_exp{id = 603,act_id = 6,lv = 136,exp = 13600,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(603,137) ->
	#base_fiesta_lv_exp{id = 603,act_id = 6,lv = 137,exp = 13700,reward = [{0,801701,2}],premium_reward = [{0,801702,5}]};

get_base_fiesta_lv_exp(603,138) ->
	#base_fiesta_lv_exp{id = 603,act_id = 6,lv = 138,exp = 13800,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(603,139) ->
	#base_fiesta_lv_exp{id = 603,act_id = 6,lv = 139,exp = 13900,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(603,140) ->
	#base_fiesta_lv_exp{id = 603,act_id = 6,lv = 140,exp = 14000,reward = [{0,801701,2}],premium_reward = [{0,801702,5}]};

get_base_fiesta_lv_exp(603,141) ->
	#base_fiesta_lv_exp{id = 603,act_id = 6,lv = 141,exp = 14100,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(603,142) ->
	#base_fiesta_lv_exp{id = 603,act_id = 6,lv = 142,exp = 14200,reward = [{0,801701,2}],premium_reward = [{0,801702,5}]};

get_base_fiesta_lv_exp(603,143) ->
	#base_fiesta_lv_exp{id = 603,act_id = 6,lv = 143,exp = 14300,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(603,144) ->
	#base_fiesta_lv_exp{id = 603,act_id = 6,lv = 144,exp = 14400,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(603,145) ->
	#base_fiesta_lv_exp{id = 603,act_id = 6,lv = 145,exp = 14500,reward = [{0,801701,2}],premium_reward = [{0,801702,5}]};

get_base_fiesta_lv_exp(603,146) ->
	#base_fiesta_lv_exp{id = 603,act_id = 6,lv = 146,exp = 14600,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(603,147) ->
	#base_fiesta_lv_exp{id = 603,act_id = 6,lv = 147,exp = 14700,reward = [{0,801701,2}],premium_reward = [{0,801702,5}]};

get_base_fiesta_lv_exp(603,148) ->
	#base_fiesta_lv_exp{id = 603,act_id = 6,lv = 148,exp = 14800,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(603,149) ->
	#base_fiesta_lv_exp{id = 603,act_id = 6,lv = 149,exp = 14900,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(603,150) ->
	#base_fiesta_lv_exp{id = 603,act_id = 6,lv = 150,exp = 15000,reward = [{0,801701,2}],premium_reward = [{0,801702,5}]};

get_base_fiesta_lv_exp(701,1) ->
	#base_fiesta_lv_exp{id = 701,act_id = 7,lv = 1,exp = 100,reward = [{0,16020001,2}],premium_reward = [{0,16020002,1}]};

get_base_fiesta_lv_exp(701,2) ->
	#base_fiesta_lv_exp{id = 701,act_id = 7,lv = 2,exp = 200,reward = [{0,38040005,20}],premium_reward = [{0,38040005,30}]};

get_base_fiesta_lv_exp(701,3) ->
	#base_fiesta_lv_exp{id = 701,act_id = 7,lv = 3,exp = 300,reward = [{0,16020001,2}],premium_reward = [{0,16020002,1}]};

get_base_fiesta_lv_exp(701,4) ->
	#base_fiesta_lv_exp{id = 701,act_id = 7,lv = 4,exp = 400,reward = [{0,38370001,1}],premium_reward = [{0,38160001,1}]};

get_base_fiesta_lv_exp(701,5) ->
	#base_fiesta_lv_exp{id = 701,act_id = 7,lv = 5,exp = 500,reward = [{0,37020001,2}],premium_reward = [{0,37121002,1}]};

get_base_fiesta_lv_exp(701,6) ->
	#base_fiesta_lv_exp{id = 701,act_id = 7,lv = 6,exp = 600,reward = [{0,32010119,1}],premium_reward = [{0,32010120,1}]};

get_base_fiesta_lv_exp(701,7) ->
	#base_fiesta_lv_exp{id = 701,act_id = 7,lv = 7,exp = 700,reward = [{0,38030003,1}],premium_reward = [{0,38030004,2}]};

get_base_fiesta_lv_exp(701,8) ->
	#base_fiesta_lv_exp{id = 701,act_id = 7,lv = 8,exp = 800,reward = [{0,16020001,2}],premium_reward = [{0,16020002,1}]};

get_base_fiesta_lv_exp(701,9) ->
	#base_fiesta_lv_exp{id = 701,act_id = 7,lv = 9,exp = 900,reward = [{0,38100002,2}],premium_reward = [{0,38100002,5}]};

get_base_fiesta_lv_exp(701,10) ->
	#base_fiesta_lv_exp{id = 701,act_id = 7,lv = 10,exp = 1000,reward = [{0,39510021,1}],premium_reward = [{0,35,128}]};

get_base_fiesta_lv_exp(701,11) ->
	#base_fiesta_lv_exp{id = 701,act_id = 7,lv = 11,exp = 1100,reward = [{0,16020001,2}],premium_reward = [{0,16020002,1}]};

get_base_fiesta_lv_exp(701,12) ->
	#base_fiesta_lv_exp{id = 701,act_id = 7,lv = 12,exp = 1200,reward = [{0,38100002,2}],premium_reward = [{0,38100002,5}]};

get_base_fiesta_lv_exp(701,13) ->
	#base_fiesta_lv_exp{id = 701,act_id = 7,lv = 13,exp = 1300,reward = [{0,38040005,20}],premium_reward = [{0,38040027,1}]};

get_base_fiesta_lv_exp(701,14) ->
	#base_fiesta_lv_exp{id = 701,act_id = 7,lv = 14,exp = 1400,reward = [{0,32010119,1}],premium_reward = [{0,32010120,1}]};

get_base_fiesta_lv_exp(701,15) ->
	#base_fiesta_lv_exp{id = 701,act_id = 7,lv = 15,exp = 1500,reward = [{0,38160001,1}],premium_reward = [{0,37020002,1}]};

get_base_fiesta_lv_exp(701,16) ->
	#base_fiesta_lv_exp{id = 701,act_id = 7,lv = 16,exp = 1600,reward = [{0,32010001,1}],premium_reward = [{0,32010002,1}]};

get_base_fiesta_lv_exp(701,17) ->
	#base_fiesta_lv_exp{id = 701,act_id = 7,lv = 17,exp = 1700,reward = [{0,16020001,2}],premium_reward = [{0,16020002,2}]};

get_base_fiesta_lv_exp(701,18) ->
	#base_fiesta_lv_exp{id = 701,act_id = 7,lv = 18,exp = 1800,reward = [{0,38100002,2}],premium_reward = [{0,38100002,5}]};

get_base_fiesta_lv_exp(701,19) ->
	#base_fiesta_lv_exp{id = 701,act_id = 7,lv = 19,exp = 1900,reward = [{0,32010001,1}],premium_reward = [{0,32010002,1}]};

get_base_fiesta_lv_exp(701,20) ->
	#base_fiesta_lv_exp{id = 701,act_id = 7,lv = 20,exp = 2000,reward = [{0,16010001,1}],premium_reward = [{0,37121003,1}]};

get_base_fiesta_lv_exp(701,21) ->
	#base_fiesta_lv_exp{id = 701,act_id = 7,lv = 21,exp = 2100,reward = [{0,18020001,2}],premium_reward = [{0,18020002,1}]};

get_base_fiesta_lv_exp(701,22) ->
	#base_fiesta_lv_exp{id = 701,act_id = 7,lv = 22,exp = 2200,reward = [{0,38100002,2}],premium_reward = [{0,38100002,5}]};

get_base_fiesta_lv_exp(701,23) ->
	#base_fiesta_lv_exp{id = 701,act_id = 7,lv = 23,exp = 2300,reward = [{0,32010001,1}],premium_reward = [{0,32010002,1}]};

get_base_fiesta_lv_exp(701,24) ->
	#base_fiesta_lv_exp{id = 701,act_id = 7,lv = 24,exp = 2400,reward = [{0,18020001,2}],premium_reward = [{0,18020002,1}]};

get_base_fiesta_lv_exp(701,25) ->
	#base_fiesta_lv_exp{id = 701,act_id = 7,lv = 25,exp = 2500,reward = [{0,16020001,2}],premium_reward = [{0,16020002,1}]};

get_base_fiesta_lv_exp(701,26) ->
	#base_fiesta_lv_exp{id = 701,act_id = 7,lv = 26,exp = 2600,reward = [{0,32010119,1}],premium_reward = [{0,32010120,1}]};

get_base_fiesta_lv_exp(701,27) ->
	#base_fiesta_lv_exp{id = 701,act_id = 7,lv = 27,exp = 2700,reward = [{0,38030003,1}],premium_reward = [{0,38030004,2}]};

get_base_fiesta_lv_exp(701,28) ->
	#base_fiesta_lv_exp{id = 701,act_id = 7,lv = 28,exp = 2800,reward = [{0,18020001,2}],premium_reward = [{0,18020002,1}]};

get_base_fiesta_lv_exp(701,29) ->
	#base_fiesta_lv_exp{id = 701,act_id = 7,lv = 29,exp = 2900,reward = [{0,38040005,20}],premium_reward = [{0,38040005,50}]};

get_base_fiesta_lv_exp(701,30) ->
	#base_fiesta_lv_exp{id = 701,act_id = 7,lv = 30,exp = 3000,reward = [{0,16010001,1}],premium_reward = [{0,35,188}]};

get_base_fiesta_lv_exp(701,31) ->
	#base_fiesta_lv_exp{id = 701,act_id = 7,lv = 31,exp = 3100,reward = [{0,32010119,1}],premium_reward = [{0,32010120,1}]};

get_base_fiesta_lv_exp(701,32) ->
	#base_fiesta_lv_exp{id = 701,act_id = 7,lv = 32,exp = 3200,reward = [{0,38370003,1}],premium_reward = [{0,38030004,1}]};

get_base_fiesta_lv_exp(701,33) ->
	#base_fiesta_lv_exp{id = 701,act_id = 7,lv = 33,exp = 3300,reward = [{0,38040005,20}],premium_reward = [{0,38040027,1}]};

get_base_fiesta_lv_exp(701,34) ->
	#base_fiesta_lv_exp{id = 701,act_id = 7,lv = 34,exp = 3400,reward = [{0,38100002,2}],premium_reward = [{0,38100002,5}]};

get_base_fiesta_lv_exp(701,35) ->
	#base_fiesta_lv_exp{id = 701,act_id = 7,lv = 35,exp = 3500,reward = [{0,32010001,2}],premium_reward = [{0,32010002,2}]};

get_base_fiesta_lv_exp(701,36) ->
	#base_fiesta_lv_exp{id = 701,act_id = 7,lv = 36,exp = 3600,reward = [{0,18020001,2}],premium_reward = [{0,18020002,1}]};

get_base_fiesta_lv_exp(701,37) ->
	#base_fiesta_lv_exp{id = 701,act_id = 7,lv = 37,exp = 3700,reward = [{0,32010001,2}],premium_reward = [{0,32010002,2}]};

get_base_fiesta_lv_exp(701,38) ->
	#base_fiesta_lv_exp{id = 701,act_id = 7,lv = 38,exp = 3800,reward = [{0,32010119,1}],premium_reward = [{0,32010120,1}]};

get_base_fiesta_lv_exp(701,39) ->
	#base_fiesta_lv_exp{id = 701,act_id = 7,lv = 39,exp = 3900,reward = [{0,18020001,2}],premium_reward = [{0,18020002,1}]};

get_base_fiesta_lv_exp(701,40) ->
	#base_fiesta_lv_exp{id = 701,act_id = 7,lv = 40,exp = 4000,reward = [{0,6101003,1}],premium_reward = [{0,6101004,1}]};

get_base_fiesta_lv_exp(701,41) ->
	#base_fiesta_lv_exp{id = 701,act_id = 7,lv = 41,exp = 4100,reward = [{0,16020001,2}],premium_reward = [{0,16020002,1}]};

get_base_fiesta_lv_exp(701,42) ->
	#base_fiesta_lv_exp{id = 701,act_id = 7,lv = 42,exp = 4200,reward = [{0,38100002,2}],premium_reward = [{0,38100002,5}]};

get_base_fiesta_lv_exp(701,43) ->
	#base_fiesta_lv_exp{id = 701,act_id = 7,lv = 43,exp = 4300,reward = [{0,38040005,20}],premium_reward = [{0,38040027,1}]};

get_base_fiesta_lv_exp(701,44) ->
	#base_fiesta_lv_exp{id = 701,act_id = 7,lv = 44,exp = 4400,reward = [{0,32010119,1}],premium_reward = [{0,32010120,1}]};

get_base_fiesta_lv_exp(701,45) ->
	#base_fiesta_lv_exp{id = 701,act_id = 7,lv = 45,exp = 4500,reward = [{0,38160001,1}],premium_reward = [{0,37020002,1}]};

get_base_fiesta_lv_exp(701,46) ->
	#base_fiesta_lv_exp{id = 701,act_id = 7,lv = 46,exp = 4600,reward = [{0,32010001,2}],premium_reward = [{0,32010002,2}]};

get_base_fiesta_lv_exp(701,47) ->
	#base_fiesta_lv_exp{id = 701,act_id = 7,lv = 47,exp = 4700,reward = [{0,16020001,2}],premium_reward = [{0,16020002,2}]};

get_base_fiesta_lv_exp(701,48) ->
	#base_fiesta_lv_exp{id = 701,act_id = 7,lv = 48,exp = 4800,reward = [{0,38100002,2}],premium_reward = [{0,38100002,5}]};

get_base_fiesta_lv_exp(701,49) ->
	#base_fiesta_lv_exp{id = 701,act_id = 7,lv = 49,exp = 4900,reward = [{0,38040005,20}],premium_reward = [{0,38040005,50}]};

get_base_fiesta_lv_exp(701,50) ->
	#base_fiesta_lv_exp{id = 701,act_id = 7,lv = 50,exp = 5000,reward = [{0,16010002,1}],premium_reward = [{0,32010517,1}]};

get_base_fiesta_lv_exp(701,51) ->
	#base_fiesta_lv_exp{id = 701,act_id = 7,lv = 51,exp = 5100,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(701,52) ->
	#base_fiesta_lv_exp{id = 701,act_id = 7,lv = 52,exp = 5200,reward = [{0,38100002,2}],premium_reward = [{0,38100002,5}]};

get_base_fiesta_lv_exp(701,53) ->
	#base_fiesta_lv_exp{id = 701,act_id = 7,lv = 53,exp = 5300,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(701,54) ->
	#base_fiesta_lv_exp{id = 701,act_id = 7,lv = 54,exp = 5400,reward = [{0,18020001,2}],premium_reward = [{0,18020002,1}]};

get_base_fiesta_lv_exp(701,55) ->
	#base_fiesta_lv_exp{id = 701,act_id = 7,lv = 55,exp = 5500,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(701,56) ->
	#base_fiesta_lv_exp{id = 701,act_id = 7,lv = 56,exp = 5600,reward = [{0,32010119,2}],premium_reward = [{0,32010120,1}]};

get_base_fiesta_lv_exp(701,57) ->
	#base_fiesta_lv_exp{id = 701,act_id = 7,lv = 57,exp = 5700,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(701,58) ->
	#base_fiesta_lv_exp{id = 701,act_id = 7,lv = 58,exp = 5800,reward = [{0,18020001,2}],premium_reward = [{0,18020002,1}]};

get_base_fiesta_lv_exp(701,59) ->
	#base_fiesta_lv_exp{id = 701,act_id = 7,lv = 59,exp = 5900,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(701,60) ->
	#base_fiesta_lv_exp{id = 701,act_id = 7,lv = 60,exp = 6000,reward = [{0,16010002,1}],premium_reward = [{0,35,268}]};

get_base_fiesta_lv_exp(701,61) ->
	#base_fiesta_lv_exp{id = 701,act_id = 7,lv = 61,exp = 6100,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(701,62) ->
	#base_fiesta_lv_exp{id = 701,act_id = 7,lv = 62,exp = 6200,reward = [{0,38370003,1}],premium_reward = [{0,38030004,1}]};

get_base_fiesta_lv_exp(701,63) ->
	#base_fiesta_lv_exp{id = 701,act_id = 7,lv = 63,exp = 6300,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(701,64) ->
	#base_fiesta_lv_exp{id = 701,act_id = 7,lv = 64,exp = 6400,reward = [{0,38100002,2}],premium_reward = [{0,38100002,5}]};

get_base_fiesta_lv_exp(701,65) ->
	#base_fiesta_lv_exp{id = 701,act_id = 7,lv = 65,exp = 6500,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(701,66) ->
	#base_fiesta_lv_exp{id = 701,act_id = 7,lv = 66,exp = 6600,reward = [{0,18020001,2}],premium_reward = [{0,18020002,1}]};

get_base_fiesta_lv_exp(701,67) ->
	#base_fiesta_lv_exp{id = 701,act_id = 7,lv = 67,exp = 6700,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(701,68) ->
	#base_fiesta_lv_exp{id = 701,act_id = 7,lv = 68,exp = 6800,reward = [{0,32010119,2}],premium_reward = [{0,32010120,1}]};

get_base_fiesta_lv_exp(701,69) ->
	#base_fiesta_lv_exp{id = 701,act_id = 7,lv = 69,exp = 6900,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(701,70) ->
	#base_fiesta_lv_exp{id = 701,act_id = 7,lv = 70,exp = 7000,reward = [{0,34010390,1}],premium_reward = [{0,6102001,1}]};

get_base_fiesta_lv_exp(701,71) ->
	#base_fiesta_lv_exp{id = 701,act_id = 7,lv = 71,exp = 7100,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(701,72) ->
	#base_fiesta_lv_exp{id = 701,act_id = 7,lv = 72,exp = 7200,reward = [{0,38100002,2}],premium_reward = [{0,38100002,5}]};

get_base_fiesta_lv_exp(701,73) ->
	#base_fiesta_lv_exp{id = 701,act_id = 7,lv = 73,exp = 7300,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(701,74) ->
	#base_fiesta_lv_exp{id = 701,act_id = 7,lv = 74,exp = 7400,reward = [{0,32010119,2}],premium_reward = [{0,32010120,1}]};

get_base_fiesta_lv_exp(701,75) ->
	#base_fiesta_lv_exp{id = 701,act_id = 7,lv = 75,exp = 7500,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(701,76) ->
	#base_fiesta_lv_exp{id = 701,act_id = 7,lv = 76,exp = 7600,reward = [{0,32010002,2}],premium_reward = [{0,32010003,2}]};

get_base_fiesta_lv_exp(701,77) ->
	#base_fiesta_lv_exp{id = 701,act_id = 7,lv = 77,exp = 7700,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(701,78) ->
	#base_fiesta_lv_exp{id = 701,act_id = 7,lv = 78,exp = 7800,reward = [{0,38100002,2}],premium_reward = [{0,38100002,5}]};

get_base_fiesta_lv_exp(701,79) ->
	#base_fiesta_lv_exp{id = 701,act_id = 7,lv = 79,exp = 7900,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(701,80) ->
	#base_fiesta_lv_exp{id = 701,act_id = 7,lv = 80,exp = 8000,reward = [{0,34010391,1}],premium_reward = [{0,35,368}]};

get_base_fiesta_lv_exp(701,81) ->
	#base_fiesta_lv_exp{id = 701,act_id = 7,lv = 81,exp = 8100,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(701,82) ->
	#base_fiesta_lv_exp{id = 701,act_id = 7,lv = 82,exp = 8200,reward = [{0,38370003,1}],premium_reward = [{0,38030004,1}]};

get_base_fiesta_lv_exp(701,83) ->
	#base_fiesta_lv_exp{id = 701,act_id = 7,lv = 83,exp = 8300,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(701,84) ->
	#base_fiesta_lv_exp{id = 701,act_id = 7,lv = 84,exp = 8400,reward = [{0,38100002,2}],premium_reward = [{0,38100002,5}]};

get_base_fiesta_lv_exp(701,85) ->
	#base_fiesta_lv_exp{id = 701,act_id = 7,lv = 85,exp = 8500,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(701,86) ->
	#base_fiesta_lv_exp{id = 701,act_id = 7,lv = 86,exp = 8600,reward = [{0,18020001,2}],premium_reward = [{0,18020002,1}]};

get_base_fiesta_lv_exp(701,87) ->
	#base_fiesta_lv_exp{id = 701,act_id = 7,lv = 87,exp = 8700,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(701,88) ->
	#base_fiesta_lv_exp{id = 701,act_id = 7,lv = 88,exp = 8800,reward = [{0,32010119,3}],premium_reward = [{0,32010120,2}]};

get_base_fiesta_lv_exp(701,89) ->
	#base_fiesta_lv_exp{id = 701,act_id = 7,lv = 89,exp = 8900,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(701,90) ->
	#base_fiesta_lv_exp{id = 701,act_id = 7,lv = 90,exp = 9000,reward = [{0,16010003,1}],premium_reward = [{0,32010517,1}]};

get_base_fiesta_lv_exp(701,91) ->
	#base_fiesta_lv_exp{id = 701,act_id = 7,lv = 91,exp = 9100,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(701,92) ->
	#base_fiesta_lv_exp{id = 701,act_id = 7,lv = 92,exp = 9200,reward = [{0,38100002,2}],premium_reward = [{0,38100002,5}]};

get_base_fiesta_lv_exp(701,93) ->
	#base_fiesta_lv_exp{id = 701,act_id = 7,lv = 93,exp = 9300,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(701,94) ->
	#base_fiesta_lv_exp{id = 701,act_id = 7,lv = 94,exp = 9400,reward = [{0,18020001,2}],premium_reward = [{0,18020002,1}]};

get_base_fiesta_lv_exp(701,95) ->
	#base_fiesta_lv_exp{id = 701,act_id = 7,lv = 95,exp = 9500,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(701,96) ->
	#base_fiesta_lv_exp{id = 701,act_id = 7,lv = 96,exp = 9600,reward = [{0,32010119,3}],premium_reward = [{0,32010120,3}]};

get_base_fiesta_lv_exp(701,97) ->
	#base_fiesta_lv_exp{id = 701,act_id = 7,lv = 97,exp = 9700,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(701,98) ->
	#base_fiesta_lv_exp{id = 701,act_id = 7,lv = 98,exp = 9800,reward = [{0,18020001,2}],premium_reward = [{0,18020002,1}]};

get_base_fiesta_lv_exp(701,99) ->
	#base_fiesta_lv_exp{id = 701,act_id = 7,lv = 99,exp = 9900,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(701,100) ->
	#base_fiesta_lv_exp{id = 701,act_id = 7,lv = 100,exp = 10000,reward = [{0,35,128}],premium_reward = [{0,18030114,30}]};

get_base_fiesta_lv_exp(701,101) ->
	#base_fiesta_lv_exp{id = 701,act_id = 7,lv = 101,exp = 10100,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(701,102) ->
	#base_fiesta_lv_exp{id = 701,act_id = 7,lv = 102,exp = 10200,reward = [{0,23020001,4}],premium_reward = [{0,38040041,5}]};

get_base_fiesta_lv_exp(701,103) ->
	#base_fiesta_lv_exp{id = 701,act_id = 7,lv = 103,exp = 10300,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(701,104) ->
	#base_fiesta_lv_exp{id = 701,act_id = 7,lv = 104,exp = 10400,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(701,105) ->
	#base_fiesta_lv_exp{id = 701,act_id = 7,lv = 105,exp = 10500,reward = [{0,23020001,4}],premium_reward = [{0,38040041,5}]};

get_base_fiesta_lv_exp(701,106) ->
	#base_fiesta_lv_exp{id = 701,act_id = 7,lv = 106,exp = 10600,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(701,107) ->
	#base_fiesta_lv_exp{id = 701,act_id = 7,lv = 107,exp = 10700,reward = [{0,23020001,4}],premium_reward = [{0,38040041,5}]};

get_base_fiesta_lv_exp(701,108) ->
	#base_fiesta_lv_exp{id = 701,act_id = 7,lv = 108,exp = 10800,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(701,109) ->
	#base_fiesta_lv_exp{id = 701,act_id = 7,lv = 109,exp = 10900,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(701,110) ->
	#base_fiesta_lv_exp{id = 701,act_id = 7,lv = 110,exp = 11000,reward = [{0,23020001,4}],premium_reward = [{0,38040041,5}]};

get_base_fiesta_lv_exp(701,111) ->
	#base_fiesta_lv_exp{id = 701,act_id = 7,lv = 111,exp = 11100,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(701,112) ->
	#base_fiesta_lv_exp{id = 701,act_id = 7,lv = 112,exp = 11200,reward = [{0,23020001,4}],premium_reward = [{0,38040041,5}]};

get_base_fiesta_lv_exp(701,113) ->
	#base_fiesta_lv_exp{id = 701,act_id = 7,lv = 113,exp = 11300,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(701,114) ->
	#base_fiesta_lv_exp{id = 701,act_id = 7,lv = 114,exp = 11400,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(701,115) ->
	#base_fiesta_lv_exp{id = 701,act_id = 7,lv = 115,exp = 11500,reward = [{0,23020001,4}],premium_reward = [{0,38040041,5}]};

get_base_fiesta_lv_exp(701,116) ->
	#base_fiesta_lv_exp{id = 701,act_id = 7,lv = 116,exp = 11600,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(701,117) ->
	#base_fiesta_lv_exp{id = 701,act_id = 7,lv = 117,exp = 11700,reward = [{0,23020001,4}],premium_reward = [{0,38040041,5}]};

get_base_fiesta_lv_exp(701,118) ->
	#base_fiesta_lv_exp{id = 701,act_id = 7,lv = 118,exp = 11800,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(701,119) ->
	#base_fiesta_lv_exp{id = 701,act_id = 7,lv = 119,exp = 11900,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(701,120) ->
	#base_fiesta_lv_exp{id = 701,act_id = 7,lv = 120,exp = 12000,reward = [{0,23020001,4}],premium_reward = [{0,38040041,5}]};

get_base_fiesta_lv_exp(701,121) ->
	#base_fiesta_lv_exp{id = 701,act_id = 7,lv = 121,exp = 12100,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(701,122) ->
	#base_fiesta_lv_exp{id = 701,act_id = 7,lv = 122,exp = 12200,reward = [{0,23020001,4}],premium_reward = [{0,38040041,5}]};

get_base_fiesta_lv_exp(701,123) ->
	#base_fiesta_lv_exp{id = 701,act_id = 7,lv = 123,exp = 12300,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(701,124) ->
	#base_fiesta_lv_exp{id = 701,act_id = 7,lv = 124,exp = 12400,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(701,125) ->
	#base_fiesta_lv_exp{id = 701,act_id = 7,lv = 125,exp = 12500,reward = [{0,23020001,4}],premium_reward = [{0,38040041,5}]};

get_base_fiesta_lv_exp(701,126) ->
	#base_fiesta_lv_exp{id = 701,act_id = 7,lv = 126,exp = 12600,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(701,127) ->
	#base_fiesta_lv_exp{id = 701,act_id = 7,lv = 127,exp = 12700,reward = [{0,23020001,4}],premium_reward = [{0,38040041,5}]};

get_base_fiesta_lv_exp(701,128) ->
	#base_fiesta_lv_exp{id = 701,act_id = 7,lv = 128,exp = 12800,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(701,129) ->
	#base_fiesta_lv_exp{id = 701,act_id = 7,lv = 129,exp = 12900,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(701,130) ->
	#base_fiesta_lv_exp{id = 701,act_id = 7,lv = 130,exp = 13000,reward = [{0,23020001,4}],premium_reward = [{0,38040041,5}]};

get_base_fiesta_lv_exp(701,131) ->
	#base_fiesta_lv_exp{id = 701,act_id = 7,lv = 131,exp = 13100,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(701,132) ->
	#base_fiesta_lv_exp{id = 701,act_id = 7,lv = 132,exp = 13200,reward = [{0,23020001,4}],premium_reward = [{0,38040041,5}]};

get_base_fiesta_lv_exp(701,133) ->
	#base_fiesta_lv_exp{id = 701,act_id = 7,lv = 133,exp = 13300,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(701,134) ->
	#base_fiesta_lv_exp{id = 701,act_id = 7,lv = 134,exp = 13400,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(701,135) ->
	#base_fiesta_lv_exp{id = 701,act_id = 7,lv = 135,exp = 13500,reward = [{0,23020001,4}],premium_reward = [{0,38040041,5}]};

get_base_fiesta_lv_exp(701,136) ->
	#base_fiesta_lv_exp{id = 701,act_id = 7,lv = 136,exp = 13600,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(701,137) ->
	#base_fiesta_lv_exp{id = 701,act_id = 7,lv = 137,exp = 13700,reward = [{0,23020001,4}],premium_reward = [{0,38040041,5}]};

get_base_fiesta_lv_exp(701,138) ->
	#base_fiesta_lv_exp{id = 701,act_id = 7,lv = 138,exp = 13800,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(701,139) ->
	#base_fiesta_lv_exp{id = 701,act_id = 7,lv = 139,exp = 13900,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(701,140) ->
	#base_fiesta_lv_exp{id = 701,act_id = 7,lv = 140,exp = 14000,reward = [{0,23020001,4}],premium_reward = [{0,38040041,5}]};

get_base_fiesta_lv_exp(701,141) ->
	#base_fiesta_lv_exp{id = 701,act_id = 7,lv = 141,exp = 14100,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(701,142) ->
	#base_fiesta_lv_exp{id = 701,act_id = 7,lv = 142,exp = 14200,reward = [{0,23020001,4}],premium_reward = [{0,38040041,5}]};

get_base_fiesta_lv_exp(701,143) ->
	#base_fiesta_lv_exp{id = 701,act_id = 7,lv = 143,exp = 14300,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(701,144) ->
	#base_fiesta_lv_exp{id = 701,act_id = 7,lv = 144,exp = 14400,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(701,145) ->
	#base_fiesta_lv_exp{id = 701,act_id = 7,lv = 145,exp = 14500,reward = [{0,23020001,4}],premium_reward = [{0,38040041,5}]};

get_base_fiesta_lv_exp(701,146) ->
	#base_fiesta_lv_exp{id = 701,act_id = 7,lv = 146,exp = 14600,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(701,147) ->
	#base_fiesta_lv_exp{id = 701,act_id = 7,lv = 147,exp = 14700,reward = [{0,23020001,4}],premium_reward = [{0,38040041,5}]};

get_base_fiesta_lv_exp(701,148) ->
	#base_fiesta_lv_exp{id = 701,act_id = 7,lv = 148,exp = 14800,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(701,149) ->
	#base_fiesta_lv_exp{id = 701,act_id = 7,lv = 149,exp = 14900,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(701,150) ->
	#base_fiesta_lv_exp{id = 701,act_id = 7,lv = 150,exp = 15000,reward = [{0,23020001,4}],premium_reward = [{0,38040041,5}]};

get_base_fiesta_lv_exp(702,1) ->
	#base_fiesta_lv_exp{id = 702,act_id = 7,lv = 1,exp = 100,reward = [{0,19020001,2}],premium_reward = [{0,19020002,1}]};

get_base_fiesta_lv_exp(702,2) ->
	#base_fiesta_lv_exp{id = 702,act_id = 7,lv = 2,exp = 200,reward = [{0,38040005,20}],premium_reward = [{0,38040005,30}]};

get_base_fiesta_lv_exp(702,3) ->
	#base_fiesta_lv_exp{id = 702,act_id = 7,lv = 3,exp = 300,reward = [{0,19020001,2}],premium_reward = [{0,19020002,1}]};

get_base_fiesta_lv_exp(702,4) ->
	#base_fiesta_lv_exp{id = 702,act_id = 7,lv = 4,exp = 400,reward = [{0,38370001,1}],premium_reward = [{0,38160001,1}]};

get_base_fiesta_lv_exp(702,5) ->
	#base_fiesta_lv_exp{id = 702,act_id = 7,lv = 5,exp = 500,reward = [{0,37020001,2}],premium_reward = [{0,37121002,1}]};

get_base_fiesta_lv_exp(702,6) ->
	#base_fiesta_lv_exp{id = 702,act_id = 7,lv = 6,exp = 600,reward = [{0,32010119,1}],premium_reward = [{0,32010120,1}]};

get_base_fiesta_lv_exp(702,7) ->
	#base_fiesta_lv_exp{id = 702,act_id = 7,lv = 7,exp = 700,reward = [{0,38030005,1}],premium_reward = [{0,38030004,2}]};

get_base_fiesta_lv_exp(702,8) ->
	#base_fiesta_lv_exp{id = 702,act_id = 7,lv = 8,exp = 800,reward = [{0,19020001,2}],premium_reward = [{0,19020002,1}]};

get_base_fiesta_lv_exp(702,9) ->
	#base_fiesta_lv_exp{id = 702,act_id = 7,lv = 9,exp = 900,reward = [{0,38100002,2}],premium_reward = [{0,38100002,5}]};

get_base_fiesta_lv_exp(702,10) ->
	#base_fiesta_lv_exp{id = 702,act_id = 7,lv = 10,exp = 1000,reward = [{0,39510021,1}],premium_reward = [{0,35,128}]};

get_base_fiesta_lv_exp(702,11) ->
	#base_fiesta_lv_exp{id = 702,act_id = 7,lv = 11,exp = 1100,reward = [{0,19020001,2}],premium_reward = [{0,19020002,1}]};

get_base_fiesta_lv_exp(702,12) ->
	#base_fiesta_lv_exp{id = 702,act_id = 7,lv = 12,exp = 1200,reward = [{0,38100002,2}],premium_reward = [{0,38100002,5}]};

get_base_fiesta_lv_exp(702,13) ->
	#base_fiesta_lv_exp{id = 702,act_id = 7,lv = 13,exp = 1300,reward = [{0,38040005,20}],premium_reward = [{0,38040027,1}]};

get_base_fiesta_lv_exp(702,14) ->
	#base_fiesta_lv_exp{id = 702,act_id = 7,lv = 14,exp = 1400,reward = [{0,32010119,1}],premium_reward = [{0,32010120,1}]};

get_base_fiesta_lv_exp(702,15) ->
	#base_fiesta_lv_exp{id = 702,act_id = 7,lv = 15,exp = 1500,reward = [{0,38160001,1}],premium_reward = [{0,37020002,1}]};

get_base_fiesta_lv_exp(702,16) ->
	#base_fiesta_lv_exp{id = 702,act_id = 7,lv = 16,exp = 1600,reward = [{0,32010001,1}],premium_reward = [{0,32010002,1}]};

get_base_fiesta_lv_exp(702,17) ->
	#base_fiesta_lv_exp{id = 702,act_id = 7,lv = 17,exp = 1700,reward = [{0,19020001,2}],premium_reward = [{0,19020002,2}]};

get_base_fiesta_lv_exp(702,18) ->
	#base_fiesta_lv_exp{id = 702,act_id = 7,lv = 18,exp = 1800,reward = [{0,38100002,2}],premium_reward = [{0,38100002,5}]};

get_base_fiesta_lv_exp(702,19) ->
	#base_fiesta_lv_exp{id = 702,act_id = 7,lv = 19,exp = 1900,reward = [{0,32010001,1}],premium_reward = [{0,32010002,1}]};

get_base_fiesta_lv_exp(702,20) ->
	#base_fiesta_lv_exp{id = 702,act_id = 7,lv = 20,exp = 2000,reward = [{0,18010001,1}],premium_reward = [{0,37121003,1}]};

get_base_fiesta_lv_exp(702,21) ->
	#base_fiesta_lv_exp{id = 702,act_id = 7,lv = 21,exp = 2100,reward = [{0,20020001,2}],premium_reward = [{0,20020002,1}]};

get_base_fiesta_lv_exp(702,22) ->
	#base_fiesta_lv_exp{id = 702,act_id = 7,lv = 22,exp = 2200,reward = [{0,38100002,2}],premium_reward = [{0,38100002,5}]};

get_base_fiesta_lv_exp(702,23) ->
	#base_fiesta_lv_exp{id = 702,act_id = 7,lv = 23,exp = 2300,reward = [{0,32010001,1}],premium_reward = [{0,32010002,1}]};

get_base_fiesta_lv_exp(702,24) ->
	#base_fiesta_lv_exp{id = 702,act_id = 7,lv = 24,exp = 2400,reward = [{0,20020001,2}],premium_reward = [{0,20020002,1}]};

get_base_fiesta_lv_exp(702,25) ->
	#base_fiesta_lv_exp{id = 702,act_id = 7,lv = 25,exp = 2500,reward = [{0,19020001,2}],premium_reward = [{0,19020002,1}]};

get_base_fiesta_lv_exp(702,26) ->
	#base_fiesta_lv_exp{id = 702,act_id = 7,lv = 26,exp = 2600,reward = [{0,32010119,1}],premium_reward = [{0,32010120,1}]};

get_base_fiesta_lv_exp(702,27) ->
	#base_fiesta_lv_exp{id = 702,act_id = 7,lv = 27,exp = 2700,reward = [{0,38030005,1}],premium_reward = [{0,38030004,2}]};

get_base_fiesta_lv_exp(702,28) ->
	#base_fiesta_lv_exp{id = 702,act_id = 7,lv = 28,exp = 2800,reward = [{0,20020001,2}],premium_reward = [{0,20020002,1}]};

get_base_fiesta_lv_exp(702,29) ->
	#base_fiesta_lv_exp{id = 702,act_id = 7,lv = 29,exp = 2900,reward = [{0,38040005,20}],premium_reward = [{0,38040005,50}]};

get_base_fiesta_lv_exp(702,30) ->
	#base_fiesta_lv_exp{id = 702,act_id = 7,lv = 30,exp = 3000,reward = [{0,18010001,1}],premium_reward = [{0,35,188}]};

get_base_fiesta_lv_exp(702,31) ->
	#base_fiesta_lv_exp{id = 702,act_id = 7,lv = 31,exp = 3100,reward = [{0,32010119,1}],premium_reward = [{0,32010120,1}]};

get_base_fiesta_lv_exp(702,32) ->
	#base_fiesta_lv_exp{id = 702,act_id = 7,lv = 32,exp = 3200,reward = [{0,38370002,1}],premium_reward = [{0,38030004,1}]};

get_base_fiesta_lv_exp(702,33) ->
	#base_fiesta_lv_exp{id = 702,act_id = 7,lv = 33,exp = 3300,reward = [{0,38040005,20}],premium_reward = [{0,38040027,1}]};

get_base_fiesta_lv_exp(702,34) ->
	#base_fiesta_lv_exp{id = 702,act_id = 7,lv = 34,exp = 3400,reward = [{0,38100002,2}],premium_reward = [{0,38100002,5}]};

get_base_fiesta_lv_exp(702,35) ->
	#base_fiesta_lv_exp{id = 702,act_id = 7,lv = 35,exp = 3500,reward = [{0,32010001,2}],premium_reward = [{0,32010002,2}]};

get_base_fiesta_lv_exp(702,36) ->
	#base_fiesta_lv_exp{id = 702,act_id = 7,lv = 36,exp = 3600,reward = [{0,20020001,2}],premium_reward = [{0,20020002,1}]};

get_base_fiesta_lv_exp(702,37) ->
	#base_fiesta_lv_exp{id = 702,act_id = 7,lv = 37,exp = 3700,reward = [{0,32010001,2}],premium_reward = [{0,32010002,2}]};

get_base_fiesta_lv_exp(702,38) ->
	#base_fiesta_lv_exp{id = 702,act_id = 7,lv = 38,exp = 3800,reward = [{0,32010119,1}],premium_reward = [{0,32010120,1}]};

get_base_fiesta_lv_exp(702,39) ->
	#base_fiesta_lv_exp{id = 702,act_id = 7,lv = 39,exp = 3900,reward = [{0,20020001,2}],premium_reward = [{0,20020002,1}]};

get_base_fiesta_lv_exp(702,40) ->
	#base_fiesta_lv_exp{id = 702,act_id = 7,lv = 40,exp = 4000,reward = [{0,6101003,1}],premium_reward = [{0,6101004,1}]};

get_base_fiesta_lv_exp(702,41) ->
	#base_fiesta_lv_exp{id = 702,act_id = 7,lv = 41,exp = 4100,reward = [{0,19020001,2}],premium_reward = [{0,19020002,1}]};

get_base_fiesta_lv_exp(702,42) ->
	#base_fiesta_lv_exp{id = 702,act_id = 7,lv = 42,exp = 4200,reward = [{0,38100002,2}],premium_reward = [{0,38100002,5}]};

get_base_fiesta_lv_exp(702,43) ->
	#base_fiesta_lv_exp{id = 702,act_id = 7,lv = 43,exp = 4300,reward = [{0,38040005,20}],premium_reward = [{0,38040027,1}]};

get_base_fiesta_lv_exp(702,44) ->
	#base_fiesta_lv_exp{id = 702,act_id = 7,lv = 44,exp = 4400,reward = [{0,32010119,1}],premium_reward = [{0,32010120,1}]};

get_base_fiesta_lv_exp(702,45) ->
	#base_fiesta_lv_exp{id = 702,act_id = 7,lv = 45,exp = 4500,reward = [{0,38160001,1}],premium_reward = [{0,37020002,1}]};

get_base_fiesta_lv_exp(702,46) ->
	#base_fiesta_lv_exp{id = 702,act_id = 7,lv = 46,exp = 4600,reward = [{0,32010001,2}],premium_reward = [{0,32010002,2}]};

get_base_fiesta_lv_exp(702,47) ->
	#base_fiesta_lv_exp{id = 702,act_id = 7,lv = 47,exp = 4700,reward = [{0,19020001,2}],premium_reward = [{0,19020002,2}]};

get_base_fiesta_lv_exp(702,48) ->
	#base_fiesta_lv_exp{id = 702,act_id = 7,lv = 48,exp = 4800,reward = [{0,38100002,2}],premium_reward = [{0,38100002,5}]};

get_base_fiesta_lv_exp(702,49) ->
	#base_fiesta_lv_exp{id = 702,act_id = 7,lv = 49,exp = 4900,reward = [{0,38040005,20}],premium_reward = [{0,38040005,50}]};

get_base_fiesta_lv_exp(702,50) ->
	#base_fiesta_lv_exp{id = 702,act_id = 7,lv = 50,exp = 5000,reward = [{0,18010002,1}],premium_reward = [{0,32010517,1}]};

get_base_fiesta_lv_exp(702,51) ->
	#base_fiesta_lv_exp{id = 702,act_id = 7,lv = 51,exp = 5100,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(702,52) ->
	#base_fiesta_lv_exp{id = 702,act_id = 7,lv = 52,exp = 5200,reward = [{0,38100002,2}],premium_reward = [{0,38100002,5}]};

get_base_fiesta_lv_exp(702,53) ->
	#base_fiesta_lv_exp{id = 702,act_id = 7,lv = 53,exp = 5300,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(702,54) ->
	#base_fiesta_lv_exp{id = 702,act_id = 7,lv = 54,exp = 5400,reward = [{0,20020001,2}],premium_reward = [{0,20020002,1}]};

get_base_fiesta_lv_exp(702,55) ->
	#base_fiesta_lv_exp{id = 702,act_id = 7,lv = 55,exp = 5500,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(702,56) ->
	#base_fiesta_lv_exp{id = 702,act_id = 7,lv = 56,exp = 5600,reward = [{0,32010119,2}],premium_reward = [{0,32010120,1}]};

get_base_fiesta_lv_exp(702,57) ->
	#base_fiesta_lv_exp{id = 702,act_id = 7,lv = 57,exp = 5700,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(702,58) ->
	#base_fiesta_lv_exp{id = 702,act_id = 7,lv = 58,exp = 5800,reward = [{0,20020001,2}],premium_reward = [{0,20020002,1}]};

get_base_fiesta_lv_exp(702,59) ->
	#base_fiesta_lv_exp{id = 702,act_id = 7,lv = 59,exp = 5900,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(702,60) ->
	#base_fiesta_lv_exp{id = 702,act_id = 7,lv = 60,exp = 6000,reward = [{0,18010002,1}],premium_reward = [{0,35,268}]};

get_base_fiesta_lv_exp(702,61) ->
	#base_fiesta_lv_exp{id = 702,act_id = 7,lv = 61,exp = 6100,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(702,62) ->
	#base_fiesta_lv_exp{id = 702,act_id = 7,lv = 62,exp = 6200,reward = [{0,38370002,1}],premium_reward = [{0,38030004,1}]};

get_base_fiesta_lv_exp(702,63) ->
	#base_fiesta_lv_exp{id = 702,act_id = 7,lv = 63,exp = 6300,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(702,64) ->
	#base_fiesta_lv_exp{id = 702,act_id = 7,lv = 64,exp = 6400,reward = [{0,38100002,2}],premium_reward = [{0,38100002,5}]};

get_base_fiesta_lv_exp(702,65) ->
	#base_fiesta_lv_exp{id = 702,act_id = 7,lv = 65,exp = 6500,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(702,66) ->
	#base_fiesta_lv_exp{id = 702,act_id = 7,lv = 66,exp = 6600,reward = [{0,20020001,2}],premium_reward = [{0,20020002,1}]};

get_base_fiesta_lv_exp(702,67) ->
	#base_fiesta_lv_exp{id = 702,act_id = 7,lv = 67,exp = 6700,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(702,68) ->
	#base_fiesta_lv_exp{id = 702,act_id = 7,lv = 68,exp = 6800,reward = [{0,32010119,2}],premium_reward = [{0,32010120,1}]};

get_base_fiesta_lv_exp(702,69) ->
	#base_fiesta_lv_exp{id = 702,act_id = 7,lv = 69,exp = 6900,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(702,70) ->
	#base_fiesta_lv_exp{id = 702,act_id = 7,lv = 70,exp = 7000,reward = [{0,34010390,1}],premium_reward = [{0,6102001,1}]};

get_base_fiesta_lv_exp(702,71) ->
	#base_fiesta_lv_exp{id = 702,act_id = 7,lv = 71,exp = 7100,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(702,72) ->
	#base_fiesta_lv_exp{id = 702,act_id = 7,lv = 72,exp = 7200,reward = [{0,38100002,2}],premium_reward = [{0,38100002,5}]};

get_base_fiesta_lv_exp(702,73) ->
	#base_fiesta_lv_exp{id = 702,act_id = 7,lv = 73,exp = 7300,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(702,74) ->
	#base_fiesta_lv_exp{id = 702,act_id = 7,lv = 74,exp = 7400,reward = [{0,32010119,2}],premium_reward = [{0,32010120,1}]};

get_base_fiesta_lv_exp(702,75) ->
	#base_fiesta_lv_exp{id = 702,act_id = 7,lv = 75,exp = 7500,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(702,76) ->
	#base_fiesta_lv_exp{id = 702,act_id = 7,lv = 76,exp = 7600,reward = [{0,32010002,2}],premium_reward = [{0,32010003,2}]};

get_base_fiesta_lv_exp(702,77) ->
	#base_fiesta_lv_exp{id = 702,act_id = 7,lv = 77,exp = 7700,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(702,78) ->
	#base_fiesta_lv_exp{id = 702,act_id = 7,lv = 78,exp = 7800,reward = [{0,38100002,2}],premium_reward = [{0,38100002,5}]};

get_base_fiesta_lv_exp(702,79) ->
	#base_fiesta_lv_exp{id = 702,act_id = 7,lv = 79,exp = 7900,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(702,80) ->
	#base_fiesta_lv_exp{id = 702,act_id = 7,lv = 80,exp = 8000,reward = [{0,32010141,1}],premium_reward = [{0,35,368}]};

get_base_fiesta_lv_exp(702,81) ->
	#base_fiesta_lv_exp{id = 702,act_id = 7,lv = 81,exp = 8100,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(702,82) ->
	#base_fiesta_lv_exp{id = 702,act_id = 7,lv = 82,exp = 8200,reward = [{0,38370002,1}],premium_reward = [{0,38030004,1}]};

get_base_fiesta_lv_exp(702,83) ->
	#base_fiesta_lv_exp{id = 702,act_id = 7,lv = 83,exp = 8300,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(702,84) ->
	#base_fiesta_lv_exp{id = 702,act_id = 7,lv = 84,exp = 8400,reward = [{0,38100002,2}],premium_reward = [{0,38100002,5}]};

get_base_fiesta_lv_exp(702,85) ->
	#base_fiesta_lv_exp{id = 702,act_id = 7,lv = 85,exp = 8500,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(702,86) ->
	#base_fiesta_lv_exp{id = 702,act_id = 7,lv = 86,exp = 8600,reward = [{0,20020001,2}],premium_reward = [{0,20020002,1}]};

get_base_fiesta_lv_exp(702,87) ->
	#base_fiesta_lv_exp{id = 702,act_id = 7,lv = 87,exp = 8700,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(702,88) ->
	#base_fiesta_lv_exp{id = 702,act_id = 7,lv = 88,exp = 8800,reward = [{0,32010119,3}],premium_reward = [{0,32010120,2}]};

get_base_fiesta_lv_exp(702,89) ->
	#base_fiesta_lv_exp{id = 702,act_id = 7,lv = 89,exp = 8900,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(702,90) ->
	#base_fiesta_lv_exp{id = 702,act_id = 7,lv = 90,exp = 9000,reward = [{0,18010003,1}],premium_reward = [{0,32010517,1}]};

get_base_fiesta_lv_exp(702,91) ->
	#base_fiesta_lv_exp{id = 702,act_id = 7,lv = 91,exp = 9100,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(702,92) ->
	#base_fiesta_lv_exp{id = 702,act_id = 7,lv = 92,exp = 9200,reward = [{0,38100002,2}],premium_reward = [{0,38100002,5}]};

get_base_fiesta_lv_exp(702,93) ->
	#base_fiesta_lv_exp{id = 702,act_id = 7,lv = 93,exp = 9300,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(702,94) ->
	#base_fiesta_lv_exp{id = 702,act_id = 7,lv = 94,exp = 9400,reward = [{0,20020001,2}],premium_reward = [{0,20020002,1}]};

get_base_fiesta_lv_exp(702,95) ->
	#base_fiesta_lv_exp{id = 702,act_id = 7,lv = 95,exp = 9500,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(702,96) ->
	#base_fiesta_lv_exp{id = 702,act_id = 7,lv = 96,exp = 9600,reward = [{0,32010119,3}],premium_reward = [{0,32010120,3}]};

get_base_fiesta_lv_exp(702,97) ->
	#base_fiesta_lv_exp{id = 702,act_id = 7,lv = 97,exp = 9700,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(702,98) ->
	#base_fiesta_lv_exp{id = 702,act_id = 7,lv = 98,exp = 9800,reward = [{0,20020001,2}],premium_reward = [{0,20020002,1}]};

get_base_fiesta_lv_exp(702,99) ->
	#base_fiesta_lv_exp{id = 702,act_id = 7,lv = 99,exp = 9900,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(702,100) ->
	#base_fiesta_lv_exp{id = 702,act_id = 7,lv = 100,exp = 10000,reward = [{0,35,128}],premium_reward = [{0,18030114,30}]};

get_base_fiesta_lv_exp(702,101) ->
	#base_fiesta_lv_exp{id = 702,act_id = 7,lv = 101,exp = 10100,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(702,102) ->
	#base_fiesta_lv_exp{id = 702,act_id = 7,lv = 102,exp = 10200,reward = [{0,39510000,4}],premium_reward = [{0,39510000,10}]};

get_base_fiesta_lv_exp(702,103) ->
	#base_fiesta_lv_exp{id = 702,act_id = 7,lv = 103,exp = 10300,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(702,104) ->
	#base_fiesta_lv_exp{id = 702,act_id = 7,lv = 104,exp = 10400,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(702,105) ->
	#base_fiesta_lv_exp{id = 702,act_id = 7,lv = 105,exp = 10500,reward = [{0,38040018,4}],premium_reward = [{0,38040018,10}]};

get_base_fiesta_lv_exp(702,106) ->
	#base_fiesta_lv_exp{id = 702,act_id = 7,lv = 106,exp = 10600,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(702,107) ->
	#base_fiesta_lv_exp{id = 702,act_id = 7,lv = 107,exp = 10700,reward = [{0,39510000,4}],premium_reward = [{0,39510000,10}]};

get_base_fiesta_lv_exp(702,108) ->
	#base_fiesta_lv_exp{id = 702,act_id = 7,lv = 108,exp = 10800,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(702,109) ->
	#base_fiesta_lv_exp{id = 702,act_id = 7,lv = 109,exp = 10900,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(702,110) ->
	#base_fiesta_lv_exp{id = 702,act_id = 7,lv = 110,exp = 11000,reward = [{0,38040018,4}],premium_reward = [{0,38040018,10}]};

get_base_fiesta_lv_exp(702,111) ->
	#base_fiesta_lv_exp{id = 702,act_id = 7,lv = 111,exp = 11100,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(702,112) ->
	#base_fiesta_lv_exp{id = 702,act_id = 7,lv = 112,exp = 11200,reward = [{0,39510000,4}],premium_reward = [{0,39510000,10}]};

get_base_fiesta_lv_exp(702,113) ->
	#base_fiesta_lv_exp{id = 702,act_id = 7,lv = 113,exp = 11300,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(702,114) ->
	#base_fiesta_lv_exp{id = 702,act_id = 7,lv = 114,exp = 11400,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(702,115) ->
	#base_fiesta_lv_exp{id = 702,act_id = 7,lv = 115,exp = 11500,reward = [{0,38040018,4}],premium_reward = [{0,38040018,10}]};

get_base_fiesta_lv_exp(702,116) ->
	#base_fiesta_lv_exp{id = 702,act_id = 7,lv = 116,exp = 11600,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(702,117) ->
	#base_fiesta_lv_exp{id = 702,act_id = 7,lv = 117,exp = 11700,reward = [{0,39510000,4}],premium_reward = [{0,39510000,10}]};

get_base_fiesta_lv_exp(702,118) ->
	#base_fiesta_lv_exp{id = 702,act_id = 7,lv = 118,exp = 11800,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(702,119) ->
	#base_fiesta_lv_exp{id = 702,act_id = 7,lv = 119,exp = 11900,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(702,120) ->
	#base_fiesta_lv_exp{id = 702,act_id = 7,lv = 120,exp = 12000,reward = [{0,38040018,4}],premium_reward = [{0,38040018,10}]};

get_base_fiesta_lv_exp(702,121) ->
	#base_fiesta_lv_exp{id = 702,act_id = 7,lv = 121,exp = 12100,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(702,122) ->
	#base_fiesta_lv_exp{id = 702,act_id = 7,lv = 122,exp = 12200,reward = [{0,39510000,4}],premium_reward = [{0,39510000,10}]};

get_base_fiesta_lv_exp(702,123) ->
	#base_fiesta_lv_exp{id = 702,act_id = 7,lv = 123,exp = 12300,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(702,124) ->
	#base_fiesta_lv_exp{id = 702,act_id = 7,lv = 124,exp = 12400,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(702,125) ->
	#base_fiesta_lv_exp{id = 702,act_id = 7,lv = 125,exp = 12500,reward = [{0,38040018,4}],premium_reward = [{0,38040018,10}]};

get_base_fiesta_lv_exp(702,126) ->
	#base_fiesta_lv_exp{id = 702,act_id = 7,lv = 126,exp = 12600,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(702,127) ->
	#base_fiesta_lv_exp{id = 702,act_id = 7,lv = 127,exp = 12700,reward = [{0,39510000,4}],premium_reward = [{0,39510000,10}]};

get_base_fiesta_lv_exp(702,128) ->
	#base_fiesta_lv_exp{id = 702,act_id = 7,lv = 128,exp = 12800,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(702,129) ->
	#base_fiesta_lv_exp{id = 702,act_id = 7,lv = 129,exp = 12900,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(702,130) ->
	#base_fiesta_lv_exp{id = 702,act_id = 7,lv = 130,exp = 13000,reward = [{0,38040018,4}],premium_reward = [{0,38040018,10}]};

get_base_fiesta_lv_exp(702,131) ->
	#base_fiesta_lv_exp{id = 702,act_id = 7,lv = 131,exp = 13100,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(702,132) ->
	#base_fiesta_lv_exp{id = 702,act_id = 7,lv = 132,exp = 13200,reward = [{0,39510000,4}],premium_reward = [{0,39510000,10}]};

get_base_fiesta_lv_exp(702,133) ->
	#base_fiesta_lv_exp{id = 702,act_id = 7,lv = 133,exp = 13300,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(702,134) ->
	#base_fiesta_lv_exp{id = 702,act_id = 7,lv = 134,exp = 13400,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(702,135) ->
	#base_fiesta_lv_exp{id = 702,act_id = 7,lv = 135,exp = 13500,reward = [{0,38040018,4}],premium_reward = [{0,38040018,10}]};

get_base_fiesta_lv_exp(702,136) ->
	#base_fiesta_lv_exp{id = 702,act_id = 7,lv = 136,exp = 13600,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(702,137) ->
	#base_fiesta_lv_exp{id = 702,act_id = 7,lv = 137,exp = 13700,reward = [{0,39510000,4}],premium_reward = [{0,39510000,10}]};

get_base_fiesta_lv_exp(702,138) ->
	#base_fiesta_lv_exp{id = 702,act_id = 7,lv = 138,exp = 13800,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(702,139) ->
	#base_fiesta_lv_exp{id = 702,act_id = 7,lv = 139,exp = 13900,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(702,140) ->
	#base_fiesta_lv_exp{id = 702,act_id = 7,lv = 140,exp = 14000,reward = [{0,38040018,4}],premium_reward = [{0,38040018,10}]};

get_base_fiesta_lv_exp(702,141) ->
	#base_fiesta_lv_exp{id = 702,act_id = 7,lv = 141,exp = 14100,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(702,142) ->
	#base_fiesta_lv_exp{id = 702,act_id = 7,lv = 142,exp = 14200,reward = [{0,39510000,4}],premium_reward = [{0,39510000,10}]};

get_base_fiesta_lv_exp(702,143) ->
	#base_fiesta_lv_exp{id = 702,act_id = 7,lv = 143,exp = 14300,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(702,144) ->
	#base_fiesta_lv_exp{id = 702,act_id = 7,lv = 144,exp = 14400,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(702,145) ->
	#base_fiesta_lv_exp{id = 702,act_id = 7,lv = 145,exp = 14500,reward = [{0,38040018,4}],premium_reward = [{0,38040018,10}]};

get_base_fiesta_lv_exp(702,146) ->
	#base_fiesta_lv_exp{id = 702,act_id = 7,lv = 146,exp = 14600,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(702,147) ->
	#base_fiesta_lv_exp{id = 702,act_id = 7,lv = 147,exp = 14700,reward = [{0,39510000,4}],premium_reward = [{0,39510000,10}]};

get_base_fiesta_lv_exp(702,148) ->
	#base_fiesta_lv_exp{id = 702,act_id = 7,lv = 148,exp = 14800,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(702,149) ->
	#base_fiesta_lv_exp{id = 702,act_id = 7,lv = 149,exp = 14900,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(702,150) ->
	#base_fiesta_lv_exp{id = 702,act_id = 7,lv = 150,exp = 15000,reward = [{0,38040018,4}],premium_reward = [{0,38040018,10}]};

get_base_fiesta_lv_exp(703,1) ->
	#base_fiesta_lv_exp{id = 703,act_id = 7,lv = 1,exp = 100,reward = [{0,7301001,2}],premium_reward = [{0,7301002,1}]};

get_base_fiesta_lv_exp(703,2) ->
	#base_fiesta_lv_exp{id = 703,act_id = 7,lv = 2,exp = 200,reward = [{0,38040005,20}],premium_reward = [{0,38040005,30}]};

get_base_fiesta_lv_exp(703,3) ->
	#base_fiesta_lv_exp{id = 703,act_id = 7,lv = 3,exp = 300,reward = [{0,7301001,2}],premium_reward = [{0,7301002,1}]};

get_base_fiesta_lv_exp(703,4) ->
	#base_fiesta_lv_exp{id = 703,act_id = 7,lv = 4,exp = 400,reward = [{0,38370001,1}],premium_reward = [{0,38160001,1}]};

get_base_fiesta_lv_exp(703,5) ->
	#base_fiesta_lv_exp{id = 703,act_id = 7,lv = 5,exp = 500,reward = [{0,37020001,2}],premium_reward = [{0,37121002,1}]};

get_base_fiesta_lv_exp(703,6) ->
	#base_fiesta_lv_exp{id = 703,act_id = 7,lv = 6,exp = 600,reward = [{0,32010119,1}],premium_reward = [{0,32010120,1}]};

get_base_fiesta_lv_exp(703,7) ->
	#base_fiesta_lv_exp{id = 703,act_id = 7,lv = 7,exp = 700,reward = [{0,38030005,1}],premium_reward = [{0,38030004,2}]};

get_base_fiesta_lv_exp(703,8) ->
	#base_fiesta_lv_exp{id = 703,act_id = 7,lv = 8,exp = 800,reward = [{0,7301001,2}],premium_reward = [{0,7301002,1}]};

get_base_fiesta_lv_exp(703,9) ->
	#base_fiesta_lv_exp{id = 703,act_id = 7,lv = 9,exp = 900,reward = [{0,38100002,2}],premium_reward = [{0,38100002,5}]};

get_base_fiesta_lv_exp(703,10) ->
	#base_fiesta_lv_exp{id = 703,act_id = 7,lv = 10,exp = 1000,reward = [{0,39510021,1}],premium_reward = [{0,35,128}]};

get_base_fiesta_lv_exp(703,11) ->
	#base_fiesta_lv_exp{id = 703,act_id = 7,lv = 11,exp = 1100,reward = [{0,7301001,2}],premium_reward = [{0,7301002,1}]};

get_base_fiesta_lv_exp(703,12) ->
	#base_fiesta_lv_exp{id = 703,act_id = 7,lv = 12,exp = 1200,reward = [{0,38100002,2}],premium_reward = [{0,38100002,5}]};

get_base_fiesta_lv_exp(703,13) ->
	#base_fiesta_lv_exp{id = 703,act_id = 7,lv = 13,exp = 1300,reward = [{0,38040005,20}],premium_reward = [{0,38040027,1}]};

get_base_fiesta_lv_exp(703,14) ->
	#base_fiesta_lv_exp{id = 703,act_id = 7,lv = 14,exp = 1400,reward = [{0,32010119,1}],premium_reward = [{0,32010120,1}]};

get_base_fiesta_lv_exp(703,15) ->
	#base_fiesta_lv_exp{id = 703,act_id = 7,lv = 15,exp = 1500,reward = [{0,38160001,1}],premium_reward = [{0,37020002,1}]};

get_base_fiesta_lv_exp(703,16) ->
	#base_fiesta_lv_exp{id = 703,act_id = 7,lv = 16,exp = 1600,reward = [{0,32010001,1}],premium_reward = [{0,32010002,1}]};

get_base_fiesta_lv_exp(703,17) ->
	#base_fiesta_lv_exp{id = 703,act_id = 7,lv = 17,exp = 1700,reward = [{0,7301001,2}],premium_reward = [{0,7301002,2}]};

get_base_fiesta_lv_exp(703,18) ->
	#base_fiesta_lv_exp{id = 703,act_id = 7,lv = 18,exp = 1800,reward = [{0,38100002,2}],premium_reward = [{0,38100002,5}]};

get_base_fiesta_lv_exp(703,19) ->
	#base_fiesta_lv_exp{id = 703,act_id = 7,lv = 19,exp = 1900,reward = [{0,32010001,1}],premium_reward = [{0,32010002,1}]};

get_base_fiesta_lv_exp(703,20) ->
	#base_fiesta_lv_exp{id = 703,act_id = 7,lv = 20,exp = 2000,reward = [{0,20010001,1}],premium_reward = [{0,37121003,1}]};

get_base_fiesta_lv_exp(703,21) ->
	#base_fiesta_lv_exp{id = 703,act_id = 7,lv = 21,exp = 2100,reward = [{0,7301003,2}],premium_reward = [{0,7301004,1}]};

get_base_fiesta_lv_exp(703,22) ->
	#base_fiesta_lv_exp{id = 703,act_id = 7,lv = 22,exp = 2200,reward = [{0,38100002,2}],premium_reward = [{0,38100002,5}]};

get_base_fiesta_lv_exp(703,23) ->
	#base_fiesta_lv_exp{id = 703,act_id = 7,lv = 23,exp = 2300,reward = [{0,32010001,1}],premium_reward = [{0,32010002,1}]};

get_base_fiesta_lv_exp(703,24) ->
	#base_fiesta_lv_exp{id = 703,act_id = 7,lv = 24,exp = 2400,reward = [{0,7301003,2}],premium_reward = [{0,7301004,1}]};

get_base_fiesta_lv_exp(703,25) ->
	#base_fiesta_lv_exp{id = 703,act_id = 7,lv = 25,exp = 2500,reward = [{0,7301001,2}],premium_reward = [{0,7301002,1}]};

get_base_fiesta_lv_exp(703,26) ->
	#base_fiesta_lv_exp{id = 703,act_id = 7,lv = 26,exp = 2600,reward = [{0,32010119,1}],premium_reward = [{0,32010120,1}]};

get_base_fiesta_lv_exp(703,27) ->
	#base_fiesta_lv_exp{id = 703,act_id = 7,lv = 27,exp = 2700,reward = [{0,38030005,1}],premium_reward = [{0,38030004,2}]};

get_base_fiesta_lv_exp(703,28) ->
	#base_fiesta_lv_exp{id = 703,act_id = 7,lv = 28,exp = 2800,reward = [{0,7301003,2}],premium_reward = [{0,7301004,1}]};

get_base_fiesta_lv_exp(703,29) ->
	#base_fiesta_lv_exp{id = 703,act_id = 7,lv = 29,exp = 2900,reward = [{0,38040005,20}],premium_reward = [{0,38040005,50}]};

get_base_fiesta_lv_exp(703,30) ->
	#base_fiesta_lv_exp{id = 703,act_id = 7,lv = 30,exp = 3000,reward = [{0,20010001,1}],premium_reward = [{0,35,188}]};

get_base_fiesta_lv_exp(703,31) ->
	#base_fiesta_lv_exp{id = 703,act_id = 7,lv = 31,exp = 3100,reward = [{0,32010119,1}],premium_reward = [{0,32010120,1}]};

get_base_fiesta_lv_exp(703,32) ->
	#base_fiesta_lv_exp{id = 703,act_id = 7,lv = 32,exp = 3200,reward = [{0,38370002,1}],premium_reward = [{0,38030004,1}]};

get_base_fiesta_lv_exp(703,33) ->
	#base_fiesta_lv_exp{id = 703,act_id = 7,lv = 33,exp = 3300,reward = [{0,38040005,20}],premium_reward = [{0,38040027,1}]};

get_base_fiesta_lv_exp(703,34) ->
	#base_fiesta_lv_exp{id = 703,act_id = 7,lv = 34,exp = 3400,reward = [{0,38100002,2}],premium_reward = [{0,38100002,5}]};

get_base_fiesta_lv_exp(703,35) ->
	#base_fiesta_lv_exp{id = 703,act_id = 7,lv = 35,exp = 3500,reward = [{0,32010001,2}],premium_reward = [{0,32010002,2}]};

get_base_fiesta_lv_exp(703,36) ->
	#base_fiesta_lv_exp{id = 703,act_id = 7,lv = 36,exp = 3600,reward = [{0,7301003,2}],premium_reward = [{0,7301004,1}]};

get_base_fiesta_lv_exp(703,37) ->
	#base_fiesta_lv_exp{id = 703,act_id = 7,lv = 37,exp = 3700,reward = [{0,32010001,2}],premium_reward = [{0,32010002,2}]};

get_base_fiesta_lv_exp(703,38) ->
	#base_fiesta_lv_exp{id = 703,act_id = 7,lv = 38,exp = 3800,reward = [{0,32010119,1}],premium_reward = [{0,32010120,1}]};

get_base_fiesta_lv_exp(703,39) ->
	#base_fiesta_lv_exp{id = 703,act_id = 7,lv = 39,exp = 3900,reward = [{0,7301003,2}],premium_reward = [{0,7301004,1}]};

get_base_fiesta_lv_exp(703,40) ->
	#base_fiesta_lv_exp{id = 703,act_id = 7,lv = 40,exp = 4000,reward = [{0,6101003,1}],premium_reward = [{0,6101004,1}]};

get_base_fiesta_lv_exp(703,41) ->
	#base_fiesta_lv_exp{id = 703,act_id = 7,lv = 41,exp = 4100,reward = [{0,7301001,2}],premium_reward = [{0,7301002,1}]};

get_base_fiesta_lv_exp(703,42) ->
	#base_fiesta_lv_exp{id = 703,act_id = 7,lv = 42,exp = 4200,reward = [{0,38100002,2}],premium_reward = [{0,38100002,5}]};

get_base_fiesta_lv_exp(703,43) ->
	#base_fiesta_lv_exp{id = 703,act_id = 7,lv = 43,exp = 4300,reward = [{0,38040005,20}],premium_reward = [{0,38040027,1}]};

get_base_fiesta_lv_exp(703,44) ->
	#base_fiesta_lv_exp{id = 703,act_id = 7,lv = 44,exp = 4400,reward = [{0,32010119,1}],premium_reward = [{0,32010120,1}]};

get_base_fiesta_lv_exp(703,45) ->
	#base_fiesta_lv_exp{id = 703,act_id = 7,lv = 45,exp = 4500,reward = [{0,38160001,1}],premium_reward = [{0,37020002,1}]};

get_base_fiesta_lv_exp(703,46) ->
	#base_fiesta_lv_exp{id = 703,act_id = 7,lv = 46,exp = 4600,reward = [{0,32010001,2}],premium_reward = [{0,32010002,2}]};

get_base_fiesta_lv_exp(703,47) ->
	#base_fiesta_lv_exp{id = 703,act_id = 7,lv = 47,exp = 4700,reward = [{0,7301001,2}],premium_reward = [{0,7301002,2}]};

get_base_fiesta_lv_exp(703,48) ->
	#base_fiesta_lv_exp{id = 703,act_id = 7,lv = 48,exp = 4800,reward = [{0,38100002,2}],premium_reward = [{0,38100002,5}]};

get_base_fiesta_lv_exp(703,49) ->
	#base_fiesta_lv_exp{id = 703,act_id = 7,lv = 49,exp = 4900,reward = [{0,38040005,20}],premium_reward = [{0,38040005,50}]};

get_base_fiesta_lv_exp(703,50) ->
	#base_fiesta_lv_exp{id = 703,act_id = 7,lv = 50,exp = 5000,reward = [{0,20010002,1}],premium_reward = [{0,32010517,1}]};

get_base_fiesta_lv_exp(703,51) ->
	#base_fiesta_lv_exp{id = 703,act_id = 7,lv = 51,exp = 5100,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(703,52) ->
	#base_fiesta_lv_exp{id = 703,act_id = 7,lv = 52,exp = 5200,reward = [{0,38100002,2}],premium_reward = [{0,38100002,5}]};

get_base_fiesta_lv_exp(703,53) ->
	#base_fiesta_lv_exp{id = 703,act_id = 7,lv = 53,exp = 5300,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(703,54) ->
	#base_fiesta_lv_exp{id = 703,act_id = 7,lv = 54,exp = 5400,reward = [{0,7301003,2}],premium_reward = [{0,7301004,1}]};

get_base_fiesta_lv_exp(703,55) ->
	#base_fiesta_lv_exp{id = 703,act_id = 7,lv = 55,exp = 5500,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(703,56) ->
	#base_fiesta_lv_exp{id = 703,act_id = 7,lv = 56,exp = 5600,reward = [{0,32010119,2}],premium_reward = [{0,32010120,1}]};

get_base_fiesta_lv_exp(703,57) ->
	#base_fiesta_lv_exp{id = 703,act_id = 7,lv = 57,exp = 5700,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(703,58) ->
	#base_fiesta_lv_exp{id = 703,act_id = 7,lv = 58,exp = 5800,reward = [{0,7301003,2}],premium_reward = [{0,7301004,1}]};

get_base_fiesta_lv_exp(703,59) ->
	#base_fiesta_lv_exp{id = 703,act_id = 7,lv = 59,exp = 5900,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(703,60) ->
	#base_fiesta_lv_exp{id = 703,act_id = 7,lv = 60,exp = 6000,reward = [{0,20010002,1}],premium_reward = [{0,35,268}]};

get_base_fiesta_lv_exp(703,61) ->
	#base_fiesta_lv_exp{id = 703,act_id = 7,lv = 61,exp = 6100,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(703,62) ->
	#base_fiesta_lv_exp{id = 703,act_id = 7,lv = 62,exp = 6200,reward = [{0,38370002,1}],premium_reward = [{0,38030004,1}]};

get_base_fiesta_lv_exp(703,63) ->
	#base_fiesta_lv_exp{id = 703,act_id = 7,lv = 63,exp = 6300,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(703,64) ->
	#base_fiesta_lv_exp{id = 703,act_id = 7,lv = 64,exp = 6400,reward = [{0,38100002,2}],premium_reward = [{0,38100002,5}]};

get_base_fiesta_lv_exp(703,65) ->
	#base_fiesta_lv_exp{id = 703,act_id = 7,lv = 65,exp = 6500,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(703,66) ->
	#base_fiesta_lv_exp{id = 703,act_id = 7,lv = 66,exp = 6600,reward = [{0,7301003,2}],premium_reward = [{0,7301004,1}]};

get_base_fiesta_lv_exp(703,67) ->
	#base_fiesta_lv_exp{id = 703,act_id = 7,lv = 67,exp = 6700,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(703,68) ->
	#base_fiesta_lv_exp{id = 703,act_id = 7,lv = 68,exp = 6800,reward = [{0,32010119,2}],premium_reward = [{0,32010120,1}]};

get_base_fiesta_lv_exp(703,69) ->
	#base_fiesta_lv_exp{id = 703,act_id = 7,lv = 69,exp = 6900,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(703,70) ->
	#base_fiesta_lv_exp{id = 703,act_id = 7,lv = 70,exp = 7000,reward = [{0,34010390,1}],premium_reward = [{0,6102001,1}]};

get_base_fiesta_lv_exp(703,71) ->
	#base_fiesta_lv_exp{id = 703,act_id = 7,lv = 71,exp = 7100,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(703,72) ->
	#base_fiesta_lv_exp{id = 703,act_id = 7,lv = 72,exp = 7200,reward = [{0,38100002,2}],premium_reward = [{0,38100002,5}]};

get_base_fiesta_lv_exp(703,73) ->
	#base_fiesta_lv_exp{id = 703,act_id = 7,lv = 73,exp = 7300,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(703,74) ->
	#base_fiesta_lv_exp{id = 703,act_id = 7,lv = 74,exp = 7400,reward = [{0,32010119,2}],premium_reward = [{0,32010120,1}]};

get_base_fiesta_lv_exp(703,75) ->
	#base_fiesta_lv_exp{id = 703,act_id = 7,lv = 75,exp = 7500,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(703,76) ->
	#base_fiesta_lv_exp{id = 703,act_id = 7,lv = 76,exp = 7600,reward = [{0,32010002,2}],premium_reward = [{0,32010003,2}]};

get_base_fiesta_lv_exp(703,77) ->
	#base_fiesta_lv_exp{id = 703,act_id = 7,lv = 77,exp = 7700,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(703,78) ->
	#base_fiesta_lv_exp{id = 703,act_id = 7,lv = 78,exp = 7800,reward = [{0,38100002,2}],premium_reward = [{0,38100002,5}]};

get_base_fiesta_lv_exp(703,79) ->
	#base_fiesta_lv_exp{id = 703,act_id = 7,lv = 79,exp = 7900,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(703,80) ->
	#base_fiesta_lv_exp{id = 703,act_id = 7,lv = 80,exp = 8000,reward = [{0,39510025,1}],premium_reward = [{0,35,368}]};

get_base_fiesta_lv_exp(703,81) ->
	#base_fiesta_lv_exp{id = 703,act_id = 7,lv = 81,exp = 8100,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(703,82) ->
	#base_fiesta_lv_exp{id = 703,act_id = 7,lv = 82,exp = 8200,reward = [{0,38370002,1}],premium_reward = [{0,38030004,1}]};

get_base_fiesta_lv_exp(703,83) ->
	#base_fiesta_lv_exp{id = 703,act_id = 7,lv = 83,exp = 8300,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(703,84) ->
	#base_fiesta_lv_exp{id = 703,act_id = 7,lv = 84,exp = 8400,reward = [{0,38100002,2}],premium_reward = [{0,38100002,5}]};

get_base_fiesta_lv_exp(703,85) ->
	#base_fiesta_lv_exp{id = 703,act_id = 7,lv = 85,exp = 8500,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(703,86) ->
	#base_fiesta_lv_exp{id = 703,act_id = 7,lv = 86,exp = 8600,reward = [{0,7301003,2}],premium_reward = [{0,7301004,1}]};

get_base_fiesta_lv_exp(703,87) ->
	#base_fiesta_lv_exp{id = 703,act_id = 7,lv = 87,exp = 8700,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(703,88) ->
	#base_fiesta_lv_exp{id = 703,act_id = 7,lv = 88,exp = 8800,reward = [{0,32010119,3}],premium_reward = [{0,32010120,2}]};

get_base_fiesta_lv_exp(703,89) ->
	#base_fiesta_lv_exp{id = 703,act_id = 7,lv = 89,exp = 8900,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(703,90) ->
	#base_fiesta_lv_exp{id = 703,act_id = 7,lv = 90,exp = 9000,reward = [{0,20010003,1}],premium_reward = [{0,32010517,1}]};

get_base_fiesta_lv_exp(703,91) ->
	#base_fiesta_lv_exp{id = 703,act_id = 7,lv = 91,exp = 9100,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(703,92) ->
	#base_fiesta_lv_exp{id = 703,act_id = 7,lv = 92,exp = 9200,reward = [{0,38100002,2}],premium_reward = [{0,38100002,5}]};

get_base_fiesta_lv_exp(703,93) ->
	#base_fiesta_lv_exp{id = 703,act_id = 7,lv = 93,exp = 9300,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(703,94) ->
	#base_fiesta_lv_exp{id = 703,act_id = 7,lv = 94,exp = 9400,reward = [{0,7301003,2}],premium_reward = [{0,7301004,1}]};

get_base_fiesta_lv_exp(703,95) ->
	#base_fiesta_lv_exp{id = 703,act_id = 7,lv = 95,exp = 9500,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(703,96) ->
	#base_fiesta_lv_exp{id = 703,act_id = 7,lv = 96,exp = 9600,reward = [{0,32010119,3}],premium_reward = [{0,32010120,3}]};

get_base_fiesta_lv_exp(703,97) ->
	#base_fiesta_lv_exp{id = 703,act_id = 7,lv = 97,exp = 9700,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(703,98) ->
	#base_fiesta_lv_exp{id = 703,act_id = 7,lv = 98,exp = 9800,reward = [{0,7301003,2}],premium_reward = [{0,7301004,1}]};

get_base_fiesta_lv_exp(703,99) ->
	#base_fiesta_lv_exp{id = 703,act_id = 7,lv = 99,exp = 9900,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(703,100) ->
	#base_fiesta_lv_exp{id = 703,act_id = 7,lv = 100,exp = 10000,reward = [{0,35,128}],premium_reward = [{0,18030114,30}]};

get_base_fiesta_lv_exp(703,101) ->
	#base_fiesta_lv_exp{id = 703,act_id = 7,lv = 101,exp = 10100,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(703,102) ->
	#base_fiesta_lv_exp{id = 703,act_id = 7,lv = 102,exp = 10200,reward = [{0,801701,2}],premium_reward = [{0,801702,5}]};

get_base_fiesta_lv_exp(703,103) ->
	#base_fiesta_lv_exp{id = 703,act_id = 7,lv = 103,exp = 10300,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(703,104) ->
	#base_fiesta_lv_exp{id = 703,act_id = 7,lv = 104,exp = 10400,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(703,105) ->
	#base_fiesta_lv_exp{id = 703,act_id = 7,lv = 105,exp = 10500,reward = [{0,801701,2}],premium_reward = [{0,801702,5}]};

get_base_fiesta_lv_exp(703,106) ->
	#base_fiesta_lv_exp{id = 703,act_id = 7,lv = 106,exp = 10600,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(703,107) ->
	#base_fiesta_lv_exp{id = 703,act_id = 7,lv = 107,exp = 10700,reward = [{0,801701,2}],premium_reward = [{0,801702,5}]};

get_base_fiesta_lv_exp(703,108) ->
	#base_fiesta_lv_exp{id = 703,act_id = 7,lv = 108,exp = 10800,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(703,109) ->
	#base_fiesta_lv_exp{id = 703,act_id = 7,lv = 109,exp = 10900,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(703,110) ->
	#base_fiesta_lv_exp{id = 703,act_id = 7,lv = 110,exp = 11000,reward = [{0,801701,2}],premium_reward = [{0,801702,5}]};

get_base_fiesta_lv_exp(703,111) ->
	#base_fiesta_lv_exp{id = 703,act_id = 7,lv = 111,exp = 11100,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(703,112) ->
	#base_fiesta_lv_exp{id = 703,act_id = 7,lv = 112,exp = 11200,reward = [{0,801701,2}],premium_reward = [{0,801702,5}]};

get_base_fiesta_lv_exp(703,113) ->
	#base_fiesta_lv_exp{id = 703,act_id = 7,lv = 113,exp = 11300,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(703,114) ->
	#base_fiesta_lv_exp{id = 703,act_id = 7,lv = 114,exp = 11400,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(703,115) ->
	#base_fiesta_lv_exp{id = 703,act_id = 7,lv = 115,exp = 11500,reward = [{0,801701,2}],premium_reward = [{0,801702,5}]};

get_base_fiesta_lv_exp(703,116) ->
	#base_fiesta_lv_exp{id = 703,act_id = 7,lv = 116,exp = 11600,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(703,117) ->
	#base_fiesta_lv_exp{id = 703,act_id = 7,lv = 117,exp = 11700,reward = [{0,801701,2}],premium_reward = [{0,801702,5}]};

get_base_fiesta_lv_exp(703,118) ->
	#base_fiesta_lv_exp{id = 703,act_id = 7,lv = 118,exp = 11800,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(703,119) ->
	#base_fiesta_lv_exp{id = 703,act_id = 7,lv = 119,exp = 11900,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(703,120) ->
	#base_fiesta_lv_exp{id = 703,act_id = 7,lv = 120,exp = 12000,reward = [{0,801701,2}],premium_reward = [{0,801702,5}]};

get_base_fiesta_lv_exp(703,121) ->
	#base_fiesta_lv_exp{id = 703,act_id = 7,lv = 121,exp = 12100,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(703,122) ->
	#base_fiesta_lv_exp{id = 703,act_id = 7,lv = 122,exp = 12200,reward = [{0,801701,2}],premium_reward = [{0,801702,5}]};

get_base_fiesta_lv_exp(703,123) ->
	#base_fiesta_lv_exp{id = 703,act_id = 7,lv = 123,exp = 12300,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(703,124) ->
	#base_fiesta_lv_exp{id = 703,act_id = 7,lv = 124,exp = 12400,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(703,125) ->
	#base_fiesta_lv_exp{id = 703,act_id = 7,lv = 125,exp = 12500,reward = [{0,801701,2}],premium_reward = [{0,801702,5}]};

get_base_fiesta_lv_exp(703,126) ->
	#base_fiesta_lv_exp{id = 703,act_id = 7,lv = 126,exp = 12600,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(703,127) ->
	#base_fiesta_lv_exp{id = 703,act_id = 7,lv = 127,exp = 12700,reward = [{0,801701,2}],premium_reward = [{0,801702,5}]};

get_base_fiesta_lv_exp(703,128) ->
	#base_fiesta_lv_exp{id = 703,act_id = 7,lv = 128,exp = 12800,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(703,129) ->
	#base_fiesta_lv_exp{id = 703,act_id = 7,lv = 129,exp = 12900,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(703,130) ->
	#base_fiesta_lv_exp{id = 703,act_id = 7,lv = 130,exp = 13000,reward = [{0,801701,2}],premium_reward = [{0,801702,5}]};

get_base_fiesta_lv_exp(703,131) ->
	#base_fiesta_lv_exp{id = 703,act_id = 7,lv = 131,exp = 13100,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(703,132) ->
	#base_fiesta_lv_exp{id = 703,act_id = 7,lv = 132,exp = 13200,reward = [{0,801701,2}],premium_reward = [{0,801702,5}]};

get_base_fiesta_lv_exp(703,133) ->
	#base_fiesta_lv_exp{id = 703,act_id = 7,lv = 133,exp = 13300,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(703,134) ->
	#base_fiesta_lv_exp{id = 703,act_id = 7,lv = 134,exp = 13400,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(703,135) ->
	#base_fiesta_lv_exp{id = 703,act_id = 7,lv = 135,exp = 13500,reward = [{0,801701,2}],premium_reward = [{0,801702,5}]};

get_base_fiesta_lv_exp(703,136) ->
	#base_fiesta_lv_exp{id = 703,act_id = 7,lv = 136,exp = 13600,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(703,137) ->
	#base_fiesta_lv_exp{id = 703,act_id = 7,lv = 137,exp = 13700,reward = [{0,801701,2}],premium_reward = [{0,801702,5}]};

get_base_fiesta_lv_exp(703,138) ->
	#base_fiesta_lv_exp{id = 703,act_id = 7,lv = 138,exp = 13800,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(703,139) ->
	#base_fiesta_lv_exp{id = 703,act_id = 7,lv = 139,exp = 13900,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(703,140) ->
	#base_fiesta_lv_exp{id = 703,act_id = 7,lv = 140,exp = 14000,reward = [{0,801701,2}],premium_reward = [{0,801702,5}]};

get_base_fiesta_lv_exp(703,141) ->
	#base_fiesta_lv_exp{id = 703,act_id = 7,lv = 141,exp = 14100,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(703,142) ->
	#base_fiesta_lv_exp{id = 703,act_id = 7,lv = 142,exp = 14200,reward = [{0,801701,2}],premium_reward = [{0,801702,5}]};

get_base_fiesta_lv_exp(703,143) ->
	#base_fiesta_lv_exp{id = 703,act_id = 7,lv = 143,exp = 14300,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(703,144) ->
	#base_fiesta_lv_exp{id = 703,act_id = 7,lv = 144,exp = 14400,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(703,145) ->
	#base_fiesta_lv_exp{id = 703,act_id = 7,lv = 145,exp = 14500,reward = [{0,801701,2}],premium_reward = [{0,801702,5}]};

get_base_fiesta_lv_exp(703,146) ->
	#base_fiesta_lv_exp{id = 703,act_id = 7,lv = 146,exp = 14600,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(703,147) ->
	#base_fiesta_lv_exp{id = 703,act_id = 7,lv = 147,exp = 14700,reward = [{0,801701,2}],premium_reward = [{0,801702,5}]};

get_base_fiesta_lv_exp(703,148) ->
	#base_fiesta_lv_exp{id = 703,act_id = 7,lv = 148,exp = 14800,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(703,149) ->
	#base_fiesta_lv_exp{id = 703,act_id = 7,lv = 149,exp = 14900,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(703,150) ->
	#base_fiesta_lv_exp{id = 703,act_id = 7,lv = 150,exp = 15000,reward = [{0,801701,2}],premium_reward = [{0,801702,5}]};

get_base_fiesta_lv_exp(801,1) ->
	#base_fiesta_lv_exp{id = 801,act_id = 8,lv = 1,exp = 100,reward = [{0,32060119,2}],premium_reward = [{0,37121001,1}]};

get_base_fiesta_lv_exp(801,2) ->
	#base_fiesta_lv_exp{id = 801,act_id = 8,lv = 2,exp = 200,reward = [{0,32010119,1}],premium_reward = [{0,32010120,1}]};

get_base_fiesta_lv_exp(801,3) ->
	#base_fiesta_lv_exp{id = 801,act_id = 8,lv = 3,exp = 300,reward = [{0,38370001,1}],premium_reward = [{0,37121002,1}]};

get_base_fiesta_lv_exp(801,4) ->
	#base_fiesta_lv_exp{id = 801,act_id = 8,lv = 4,exp = 400,reward = [{0,38100002,2}],premium_reward = [{0,38100002,5}]};

get_base_fiesta_lv_exp(801,5) ->
	#base_fiesta_lv_exp{id = 801,act_id = 8,lv = 5,exp = 500,reward = [{0,38030003,1}],premium_reward = [{0,35,168}]};

get_base_fiesta_lv_exp(801,6) ->
	#base_fiesta_lv_exp{id = 801,act_id = 8,lv = 6,exp = 600,reward = [{0,18020001,2}],premium_reward = [{0,18020002,1}]};

get_base_fiesta_lv_exp(801,7) ->
	#base_fiesta_lv_exp{id = 801,act_id = 8,lv = 7,exp = 700,reward = [{0,16020001,2}],premium_reward = [{0,16020002,1}]};

get_base_fiesta_lv_exp(801,8) ->
	#base_fiesta_lv_exp{id = 801,act_id = 8,lv = 8,exp = 800,reward = [{0,17020001,2}],premium_reward = [{0,17020002,1}]};

get_base_fiesta_lv_exp(801,9) ->
	#base_fiesta_lv_exp{id = 801,act_id = 8,lv = 9,exp = 900,reward = [{0,37020001,2}],premium_reward = [{0,37020002,1}]};

get_base_fiesta_lv_exp(801,10) ->
	#base_fiesta_lv_exp{id = 801,act_id = 8,lv = 10,exp = 1000,reward = [{0,38030001,1}],premium_reward = [{0,38280001,1}]};

get_base_fiesta_lv_exp(801,11) ->
	#base_fiesta_lv_exp{id = 801,act_id = 8,lv = 11,exp = 1100,reward = [{0,32010119,1}],premium_reward = [{0,32010120,1}]};

get_base_fiesta_lv_exp(801,12) ->
	#base_fiesta_lv_exp{id = 801,act_id = 8,lv = 12,exp = 1200,reward = [{0,18020001,2}],premium_reward = [{0,18020002,1}]};

get_base_fiesta_lv_exp(801,13) ->
	#base_fiesta_lv_exp{id = 801,act_id = 8,lv = 13,exp = 1300,reward = [{0,16020001,2}],premium_reward = [{0,16020002,1}]};

get_base_fiesta_lv_exp(801,14) ->
	#base_fiesta_lv_exp{id = 801,act_id = 8,lv = 14,exp = 1400,reward = [{0,17020001,2}],premium_reward = [{0,17020002,1}]};

get_base_fiesta_lv_exp(801,15) ->
	#base_fiesta_lv_exp{id = 801,act_id = 8,lv = 15,exp = 1500,reward = [{0,12020004,1}],premium_reward = [{0,12010004,1}]};

get_base_fiesta_lv_exp(801,16) ->
	#base_fiesta_lv_exp{id = 801,act_id = 8,lv = 16,exp = 1600,reward = [{0,38040005,20}],premium_reward = [{0,38040027,1}]};

get_base_fiesta_lv_exp(801,17) ->
	#base_fiesta_lv_exp{id = 801,act_id = 8,lv = 17,exp = 1700,reward = [{0,16010002,1}],premium_reward = [{0,16010003,1}]};

get_base_fiesta_lv_exp(801,18) ->
	#base_fiesta_lv_exp{id = 801,act_id = 8,lv = 18,exp = 1800,reward = [{0,32010001,1}],premium_reward = [{0,32010002,1}]};

get_base_fiesta_lv_exp(801,19) ->
	#base_fiesta_lv_exp{id = 801,act_id = 8,lv = 19,exp = 1900,reward = [{0,32010119,2}],premium_reward = [{0,32010120,2}]};

get_base_fiesta_lv_exp(801,20) ->
	#base_fiesta_lv_exp{id = 801,act_id = 8,lv = 20,exp = 2000,reward = [{0,32010517,1}],premium_reward = [{0,34,688}]};

get_base_fiesta_lv_exp(801,21) ->
	#base_fiesta_lv_exp{id = 801,act_id = 8,lv = 21,exp = 2100,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(801,22) ->
	#base_fiesta_lv_exp{id = 801,act_id = 8,lv = 22,exp = 2200,reward = [{0,18020001,2}],premium_reward = [{0,18020002,1}]};

get_base_fiesta_lv_exp(801,23) ->
	#base_fiesta_lv_exp{id = 801,act_id = 8,lv = 23,exp = 2300,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(801,24) ->
	#base_fiesta_lv_exp{id = 801,act_id = 8,lv = 24,exp = 2400,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(801,25) ->
	#base_fiesta_lv_exp{id = 801,act_id = 8,lv = 25,exp = 2500,reward = [{0,16020001,2}],premium_reward = [{0,16020002,1}]};

get_base_fiesta_lv_exp(801,26) ->
	#base_fiesta_lv_exp{id = 801,act_id = 8,lv = 26,exp = 2600,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(801,27) ->
	#base_fiesta_lv_exp{id = 801,act_id = 8,lv = 27,exp = 2700,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(801,28) ->
	#base_fiesta_lv_exp{id = 801,act_id = 8,lv = 28,exp = 2800,reward = [{0,17020001,2}],premium_reward = [{0,17020002,1}]};

get_base_fiesta_lv_exp(801,29) ->
	#base_fiesta_lv_exp{id = 801,act_id = 8,lv = 29,exp = 2900,reward = [],premium_reward = []};

get_base_fiesta_lv_exp(801,30) ->
	#base_fiesta_lv_exp{id = 801,act_id = 8,lv = 30,exp = 3000,reward = [{0,32010119,3}],premium_reward = [{0,32010120,2}]};

get_base_fiesta_lv_exp(_Id,_Lv) ->
	[].

get_fiesta_max_lv(101) -> 15;
get_fiesta_max_lv(201) -> 60;
get_fiesta_max_lv(202) -> 60;
get_fiesta_max_lv(203) -> 60;
get_fiesta_max_lv(301) -> 60;
get_fiesta_max_lv(302) -> 60;
get_fiesta_max_lv(303) -> 60;
get_fiesta_max_lv(401) -> 60;
get_fiesta_max_lv(402) -> 60;
get_fiesta_max_lv(403) -> 60;
get_fiesta_max_lv(501) -> 150;
get_fiesta_max_lv(502) -> 150;
get_fiesta_max_lv(503) -> 150;
get_fiesta_max_lv(601) -> 150;
get_fiesta_max_lv(602) -> 150;
get_fiesta_max_lv(603) -> 150;
get_fiesta_max_lv(701) -> 150;
get_fiesta_max_lv(702) -> 150;
get_fiesta_max_lv(703) -> 150;
get_fiesta_max_lv(801) -> 30;
get_fiesta_max_lv(_Id) -> 0.

get_base_fiesta_act_task(101,1) ->
	#base_fiesta_act_task{id = 101,act_id = 1,type = 1,task_list = [1001,1002,1003,1004,1005,1006,1007,1008,1009,1010,1011,1012,1013,1014,1015]};

get_base_fiesta_act_task(101,3) ->
	#base_fiesta_act_task{id = 101,act_id = 1,type = 3,task_list = [3001,3002,3003,3004,3005,3006,3007,3008,3009,3010,3011,3012,3013,3014,3015,3016,3017,3018,3019,3020]};

get_base_fiesta_act_task(201,1) ->
	#base_fiesta_act_task{id = 201,act_id = 2,type = 1,task_list = [1101,1102,1103,1104,1105,1106,1107,1108,1109,1110,1111,1112,1113,1114,1115,1116]};

get_base_fiesta_act_task(201,2) ->
	#base_fiesta_act_task{id = 201,act_id = 2,type = 2,task_list = [2101,2102,2103,2104,2105,2106,2107,2108,2109]};

get_base_fiesta_act_task(201,3) ->
	#base_fiesta_act_task{id = 201,act_id = 2,type = 3,task_list = [3101,3102,3103,3104,3105,3106,3107,3108,3109,3110,3111,3112,3113,3114,3115,3116,3117,3118,3119,3120,3121,3122]};

get_base_fiesta_act_task(202,1) ->
	#base_fiesta_act_task{id = 202,act_id = 2,type = 1,task_list = [1101,1102,1103,1104,1105,1106,1107,1108,1109,1110,1111,1112,1113,1114,1115,1116]};

get_base_fiesta_act_task(202,2) ->
	#base_fiesta_act_task{id = 202,act_id = 2,type = 2,task_list = [2101,2102,2103,2104,2105,2106,2107,2108,2109]};

get_base_fiesta_act_task(202,3) ->
	#base_fiesta_act_task{id = 202,act_id = 2,type = 3,task_list = [3101,3102,3103,3104,3105,3106,3107,3108,3109,3110,3111,3112,3113,3114,3115,3116,3117,3118,3119,3120,3121,3122]};

get_base_fiesta_act_task(203,1) ->
	#base_fiesta_act_task{id = 203,act_id = 2,type = 1,task_list = [1101,1102,1103,1104,1105,1106,1107,1108,1109,1110,1111,1112,1113,1114,1115,1116]};

get_base_fiesta_act_task(203,2) ->
	#base_fiesta_act_task{id = 203,act_id = 2,type = 2,task_list = [2101,2102,2103,2104,2105,2106,2107,2108,2109]};

get_base_fiesta_act_task(203,3) ->
	#base_fiesta_act_task{id = 203,act_id = 2,type = 3,task_list = [3101,3102,3103,3104,3105,3106,3107,3108,3109,3110,3111,3112,3113,3114,3115,3116,3117,3118,3119,3120,3121,3122]};

get_base_fiesta_act_task(301,1) ->
	#base_fiesta_act_task{id = 301,act_id = 3,type = 1,task_list = [1101,1102,1103,1104,1105,1106,1107,1108,1109,1110,1111,1112,1113,1114,1115,1116]};

get_base_fiesta_act_task(301,2) ->
	#base_fiesta_act_task{id = 301,act_id = 3,type = 2,task_list = [2101,2102,2103,2104,2105,2106,2107,2108,2109]};

get_base_fiesta_act_task(301,3) ->
	#base_fiesta_act_task{id = 301,act_id = 3,type = 3,task_list = [3101,3102,3103,3104,3105,3106,3107,3108,3109,3110,3111,3112,3113,3114,3115,3116,3117,3118,3119,3120,3121,3122]};

get_base_fiesta_act_task(302,1) ->
	#base_fiesta_act_task{id = 302,act_id = 3,type = 1,task_list = [1101,1102,1103,1104,1105,1106,1107,1108,1109,1110,1111,1112,1113,1114,1115,1116]};

get_base_fiesta_act_task(302,2) ->
	#base_fiesta_act_task{id = 302,act_id = 3,type = 2,task_list = [2101,2102,2103,2104,2105,2106,2107,2108,2109]};

get_base_fiesta_act_task(302,3) ->
	#base_fiesta_act_task{id = 302,act_id = 3,type = 3,task_list = [3101,3102,3103,3104,3105,3106,3107,3108,3109,3110,3111,3112,3113,3114,3115,3116,3117,3118,3119,3120,3121,3122]};

get_base_fiesta_act_task(303,1) ->
	#base_fiesta_act_task{id = 303,act_id = 3,type = 1,task_list = [1101,1102,1103,1104,1105,1106,1107,1108,1109,1110,1111,1112,1113,1114,1115,1116]};

get_base_fiesta_act_task(303,2) ->
	#base_fiesta_act_task{id = 303,act_id = 3,type = 2,task_list = [2101,2102,2103,2104,2105,2106,2107,2108,2109]};

get_base_fiesta_act_task(303,3) ->
	#base_fiesta_act_task{id = 303,act_id = 3,type = 3,task_list = [3101,3102,3103,3104,3105,3106,3107,3108,3109,3110,3111,3112,3113,3114,3115,3116,3117,3118,3119,3120,3121,3122]};

get_base_fiesta_act_task(401,1) ->
	#base_fiesta_act_task{id = 401,act_id = 4,type = 1,task_list = [1101,1102,1103,1104,1105,1106,1107,1108,1109,1110,1111,1112,1113,1114,1115,1116]};

get_base_fiesta_act_task(401,2) ->
	#base_fiesta_act_task{id = 401,act_id = 4,type = 2,task_list = [2101,2102,2103,2104,2105,2106,2107,2108,2109]};

get_base_fiesta_act_task(401,3) ->
	#base_fiesta_act_task{id = 401,act_id = 4,type = 3,task_list = [3101,3102,3103,3104,3105,3106,3107,3108,3109,3110,3111,3112,3113,3114,3115,3116,3117,3118,3119,3120,3121,3122]};

get_base_fiesta_act_task(402,1) ->
	#base_fiesta_act_task{id = 402,act_id = 4,type = 1,task_list = [1101,1102,1103,1104,1105,1106,1107,1108,1109,1110,1111,1112,1113,1114,1115,1116]};

get_base_fiesta_act_task(402,2) ->
	#base_fiesta_act_task{id = 402,act_id = 4,type = 2,task_list = [2101,2102,2103,2104,2105,2106,2107,2108,2109]};

get_base_fiesta_act_task(402,3) ->
	#base_fiesta_act_task{id = 402,act_id = 4,type = 3,task_list = [3101,3102,3103,3104,3105,3106,3107,3108,3109,3110,3111,3112,3113,3114,3115,3116,3117,3118,3119,3120,3121,3122]};

get_base_fiesta_act_task(403,1) ->
	#base_fiesta_act_task{id = 403,act_id = 4,type = 1,task_list = [1101,1102,1103,1104,1105,1106,1107,1108,1109,1110,1111,1112,1113,1114,1115,1116]};

get_base_fiesta_act_task(403,2) ->
	#base_fiesta_act_task{id = 403,act_id = 4,type = 2,task_list = [2101,2102,2103,2104,2105,2106,2107,2108,2109]};

get_base_fiesta_act_task(403,3) ->
	#base_fiesta_act_task{id = 403,act_id = 4,type = 3,task_list = [3101,3102,3103,3104,3105,3106,3107,3108,3109,3110,3111,3112,3113,3114,3115,3116,3117,3118,3119,3120,3121,3122]};

get_base_fiesta_act_task(501,1) ->
	#base_fiesta_act_task{id = 501,act_id = 5,type = 1,task_list = [1117,1118,1119,1120,1121,1122,1123,1124,1125,1126,1127,1128,1129]};

get_base_fiesta_act_task(501,2) ->
	#base_fiesta_act_task{id = 501,act_id = 5,type = 2,task_list = [2101,2102,2103,2104,2105,2106,2107,2108,2109]};

get_base_fiesta_act_task(501,3) ->
	#base_fiesta_act_task{id = 501,act_id = 5,type = 3,task_list = [3123,3124,3125,3126,3127,3128,3129,3130,3131,3132,3133,3134,3135,3136,3137,3138,3139,3140,3141,3142,3143,3144,3145,3146,3147]};

get_base_fiesta_act_task(502,1) ->
	#base_fiesta_act_task{id = 502,act_id = 5,type = 1,task_list = [1117,1118,1119,1120,1121,1122,1123,1124,1125,1126,1127,1128,1129]};

get_base_fiesta_act_task(502,2) ->
	#base_fiesta_act_task{id = 502,act_id = 5,type = 2,task_list = [2101,2102,2103,2104,2105,2106,2107,2108,2109]};

get_base_fiesta_act_task(502,3) ->
	#base_fiesta_act_task{id = 502,act_id = 5,type = 3,task_list = [3123,3124,3125,3126,3127,3128,3129,3130,3131,3132,3133,3134,3135,3136,3137,3138,3139,3140,3141,3142,3143,3144,3145,3146,3147]};

get_base_fiesta_act_task(503,1) ->
	#base_fiesta_act_task{id = 503,act_id = 5,type = 1,task_list = [1117,1118,1119,1120,1121,1122,1123,1124,1125,1126,1127,1128,1129]};

get_base_fiesta_act_task(503,2) ->
	#base_fiesta_act_task{id = 503,act_id = 5,type = 2,task_list = [2101,2102,2103,2104,2105,2106,2107,2108,2109]};

get_base_fiesta_act_task(503,3) ->
	#base_fiesta_act_task{id = 503,act_id = 5,type = 3,task_list = [3123,3124,3125,3126,3127,3128,3129,3130,3131,3132,3133,3134,3135,3136,3137,3138,3139,3140,3141,3142,3143,3144,3145,3146,3147]};

get_base_fiesta_act_task(601,1) ->
	#base_fiesta_act_task{id = 601,act_id = 6,type = 1,task_list = [1117,1118,1119,1120,1121,1122,1123,1124,1125,1126,1127,1128,1129]};

get_base_fiesta_act_task(601,2) ->
	#base_fiesta_act_task{id = 601,act_id = 6,type = 2,task_list = [2101,2102,2103,2104,2105,2106,2107,2108,2109]};

get_base_fiesta_act_task(601,3) ->
	#base_fiesta_act_task{id = 601,act_id = 6,type = 3,task_list = [3123,3124,3125,3126,3127,3128,3129,3130,3131,3132,3133,3134,3135,3136,3137,3138,3139,3140,3141,3142,3143,3144,3145,3146,3147]};

get_base_fiesta_act_task(602,1) ->
	#base_fiesta_act_task{id = 602,act_id = 6,type = 1,task_list = [1117,1118,1119,1120,1121,1122,1123,1124,1125,1126,1127,1128,1129]};

get_base_fiesta_act_task(602,2) ->
	#base_fiesta_act_task{id = 602,act_id = 6,type = 2,task_list = [2101,2102,2103,2104,2105,2106,2107,2108,2109]};

get_base_fiesta_act_task(602,3) ->
	#base_fiesta_act_task{id = 602,act_id = 6,type = 3,task_list = [3123,3124,3125,3126,3127,3128,3129,3130,3131,3132,3133,3134,3135,3136,3137,3138,3139,3140,3141,3142,3143,3144,3145,3146,3147]};

get_base_fiesta_act_task(603,1) ->
	#base_fiesta_act_task{id = 603,act_id = 6,type = 1,task_list = [1117,1118,1119,1120,1121,1122,1123,1124,1125,1126,1127,1128,1129]};

get_base_fiesta_act_task(603,2) ->
	#base_fiesta_act_task{id = 603,act_id = 6,type = 2,task_list = [2101,2102,2103,2104,2105,2106,2107,2108,2109]};

get_base_fiesta_act_task(603,3) ->
	#base_fiesta_act_task{id = 603,act_id = 6,type = 3,task_list = [3123,3124,3125,3126,3127,3128,3129,3130,3131,3132,3133,3134,3135,3136,3137,3138,3139,3140,3141,3142,3143,3144,3145,3146,3147]};

get_base_fiesta_act_task(701,1) ->
	#base_fiesta_act_task{id = 701,act_id = 7,type = 1,task_list = [1117,1118,1119,1120,1121,1122,1123,1124,1125,1126,1127,1128,1129]};

get_base_fiesta_act_task(701,2) ->
	#base_fiesta_act_task{id = 701,act_id = 7,type = 2,task_list = [2101,2102,2103,2104,2105,2106,2107,2108,2109]};

get_base_fiesta_act_task(701,3) ->
	#base_fiesta_act_task{id = 701,act_id = 7,type = 3,task_list = [3123,3124,3125,3126,3127,3128,3129,3130,3131,3132,3133,3134,3135,3136,3137,3138,3139,3140,3141,3142,3143,3144,3145,3146,3147]};

get_base_fiesta_act_task(702,1) ->
	#base_fiesta_act_task{id = 702,act_id = 7,type = 1,task_list = [1117,1118,1119,1120,1121,1122,1123,1124,1125,1126,1127,1128,1129]};

get_base_fiesta_act_task(702,2) ->
	#base_fiesta_act_task{id = 702,act_id = 7,type = 2,task_list = [2101,2102,2103,2104,2105,2106,2107,2108,2109]};

get_base_fiesta_act_task(702,3) ->
	#base_fiesta_act_task{id = 702,act_id = 7,type = 3,task_list = [3123,3124,3125,3126,3127,3128,3129,3130,3131,3132,3133,3134,3135,3136,3137,3138,3139,3140,3141,3142,3143,3144,3145,3146,3147]};

get_base_fiesta_act_task(703,1) ->
	#base_fiesta_act_task{id = 703,act_id = 7,type = 1,task_list = [1117,1118,1119,1120,1121,1122,1123,1124,1125,1126,1127,1128,1129]};

get_base_fiesta_act_task(703,2) ->
	#base_fiesta_act_task{id = 703,act_id = 7,type = 2,task_list = [2101,2102,2103,2104,2105,2106,2107,2108,2109]};

get_base_fiesta_act_task(703,3) ->
	#base_fiesta_act_task{id = 703,act_id = 7,type = 3,task_list = [3123,3124,3125,3126,3127,3128,3129,3130,3131,3132,3133,3134,3135,3136,3137,3138,3139,3140,3141,3142,3143,3144,3145,3146,3147]};

get_base_fiesta_act_task(801,1) ->
	#base_fiesta_act_task{id = 801,act_id = 8,type = 1,task_list = [1016,1017,1018,1019,1020,1021,1022,1023,1024,1025,1026,1027]};

get_base_fiesta_act_task(801,3) ->
	#base_fiesta_act_task{id = 801,act_id = 8,type = 3,task_list = [3021,3022,3023,3024,3025,3026,3027,3028,3029,3030,3031,3032,3033,3034,3035,3036,3037,3038,3039,3040,3041]};

get_base_fiesta_act_task(_Id,_Type) ->
	[].

get_base_fiesta_task(1001) ->
	#base_fiesta_task{id = 1001,content = acc_recharge,desc = <<"每天充值6元"/utf8>>,open_day = 1,open_lv = 95,times = 1,target_num = 60,exp = 15};

get_base_fiesta_task(1002) ->
	#base_fiesta_task{id = 1002,content = acc_recharge,desc = <<"每天充值98元"/utf8>>,open_day = 1,open_lv = 95,times = 1,target_num = 980,exp = 20};

get_base_fiesta_task(1003) ->
	#base_fiesta_task{id = 1003,content = acc_consume,desc = <<"每天花费60勾玉"/utf8>>,open_day = 1,open_lv = 95,times = 1,target_num = 60,exp = 15};

get_base_fiesta_task(1004) ->
	#base_fiesta_task{id = 1004,content = acc_consume,desc = <<"每天花费980勾玉"/utf8>>,open_day = 1,open_lv = 95,times = 1,target_num = 980,exp = 20};

get_base_fiesta_task(1005) ->
	#base_fiesta_task{id = 1005,content = kill_world_boss,desc = <<"击杀世界大妖1次"/utf8>>,open_day = 1,open_lv = 95,times = 5,target_num = 1,exp = 10};

get_base_fiesta_task(1006) ->
	#base_fiesta_task{id = 1006,content = kill_per_boss,desc = <<"击杀专属大妖1次"/utf8>>,open_day = 1,open_lv = 95,times = 1,target_num = 1,exp = 30};

get_base_fiesta_task(1007) ->
	#base_fiesta_task{id = 1007,content = compose_red_equip,desc = <<"合成1次红色装备"/utf8>>,open_day = 1,open_lv = 160,times = 1,target_num = 1,exp = 15};

get_base_fiesta_task(1008) ->
	#base_fiesta_task{id = 1008,content = enter_forbidden_dungeon,desc = <<"进入蛮荒大妖场景"/utf8>>,open_day = 1,open_lv = 95,times = 2,target_num = 1,exp = 20};

get_base_fiesta_task(1009) ->
	#base_fiesta_task{id = 1009,content = enter_sea_treasure,desc = <<"参与璀璨之海"/utf8>>,open_day = 5,open_lv = 200,times = 2,target_num = 1,exp = 10};

get_base_fiesta_task(1010) ->
	#base_fiesta_task{id = 1010,content = enter_midday_party,desc = <<"参与1次午间派对"/utf8>>,open_day = 1,open_lv = 95,times = 1,target_num = 1,exp = 15};

get_base_fiesta_task(1011) ->
	#base_fiesta_task{id = 1011,content = enter_guild_feast,desc = <<"参与1次结社晚宴"/utf8>>,open_day = 1,open_lv = 95,times = 1,target_num = 1,exp = 15};

get_base_fiesta_task(1012) ->
	#base_fiesta_task{id = 1012,content = pass_equip_dungeon,desc = <<"通关寻装觅刃"/utf8>>,open_day = 1,open_lv = 95,times = 3,target_num = 1,exp = 10};

get_base_fiesta_task(1013) ->
	#base_fiesta_task{id = 1013,content = sweep_partner_new_dungeon,desc = <<"扫荡1次神巫副本"/utf8>>,open_day = 2,open_lv = 95,times = 1,target_num = 1,exp = 20};

get_base_fiesta_task(1014) ->
	#base_fiesta_task{id = 1014,content = enter_jjc,desc = <<"完成10次竞技场"/utf8>>,open_day = 1,open_lv = 95,times = 1,target_num = 10,exp = 20};

get_base_fiesta_task(1015) ->
	#base_fiesta_task{id = 1015,content = liveness,desc = <<"活跃度到达150"/utf8>>,open_day = 1,open_lv = 95,times = 1,target_num = 150,exp = 30};

get_base_fiesta_task(1016) ->
	#base_fiesta_task{id = 1016,content = kill_world_boss,desc = <<"击杀世界大妖1次"/utf8>>,open_day = 1,open_lv = 95,times = 5,target_num = 1,exp = 10};

get_base_fiesta_task(1017) ->
	#base_fiesta_task{id = 1017,content = enter_forbidden_dungeon,desc = <<"进入蛮荒大妖场景"/utf8>>,open_day = 2,open_lv = 240,times = 2,target_num = 1,exp = 20};

get_base_fiesta_task(1018) ->
	#base_fiesta_task{id = 1018,content = enter_sea_treasure,desc = <<"参与璀璨之海"/utf8>>,open_day = 4,open_lv = 200,times = 2,target_num = 1,exp = 10};

get_base_fiesta_task(1019) ->
	#base_fiesta_task{id = 1019,content = pass_equip_dungeon,desc = <<"通关寻装觅刃"/utf8>>,open_day = 1,open_lv = 95,times = 3,target_num = 1,exp = 10};

get_base_fiesta_task(1020) ->
	#base_fiesta_task{id = 1020,content = kill_per_boss,desc = <<"击杀专属大妖1次"/utf8>>,open_day = 1,open_lv = 95,times = 1,target_num = 1,exp = 10};

get_base_fiesta_task(1021) ->
	#base_fiesta_task{id = 1021,content = compose_red_equip,desc = <<"合成1次红色装备"/utf8>>,open_day = 1,open_lv = 160,times = 1,target_num = 1,exp = 15};

get_base_fiesta_task(1022) ->
	#base_fiesta_task{id = 1022,content = enter_midday_party,desc = <<"参与1次午间派对"/utf8>>,open_day = 1,open_lv = 95,times = 1,target_num = 1,exp = 15};

get_base_fiesta_task(1023) ->
	#base_fiesta_task{id = 1023,content = enter_guild_feast,desc = <<"参与1次结社晚宴"/utf8>>,open_day = 1,open_lv = 95,times = 1,target_num = 1,exp = 15};

get_base_fiesta_task(1024) ->
	#base_fiesta_task{id = 1024,content = kill_sanctuary_boss,desc = <<"击杀异域大妖1次"/utf8>>,open_day = 2,open_lv = 95,times = 1,target_num = 1,exp = 20};

get_base_fiesta_task(1025) ->
	#base_fiesta_task{id = 1025,content = enter_jjc,desc = <<"完成10次竞技场"/utf8>>,open_day = 1,open_lv = 95,times = 1,target_num = 10,exp = 20};

get_base_fiesta_task(1026) ->
	#base_fiesta_task{id = 1026,content = liveness,desc = <<"活跃度到达150"/utf8>>,open_day = 1,open_lv = 95,times = 1,target_num = 150,exp = 30};

get_base_fiesta_task(1027) ->
	#base_fiesta_task{id = 1027,content = recharge_first,desc = <<"首次充值"/utf8>>,open_day = 1,open_lv = 95,times = 1,target_num = 1,exp = 30};

get_base_fiesta_task(1101) ->
	#base_fiesta_task{id = 1101,content = pass_equip_dungeon,desc = <<"通关3次寻装觅刃"/utf8>>,open_day = 8,open_lv = 200,times = 1,target_num = 3,exp = 30};

get_base_fiesta_task(1102) ->
	#base_fiesta_task{id = 1102,content = sweep_partner_new_dungeon,desc = <<"扫荡1次神巫副本"/utf8>>,open_day = 8,open_lv = 200,times = 1,target_num = 1,exp = 20};

get_base_fiesta_task(1103) ->
	#base_fiesta_task{id = 1103,content = enter_exp_dungeon,desc = <<"进入2次恶灵退治"/utf8>>,open_day = 8,open_lv = 200,times = 1,target_num = 2,exp = 20};

get_base_fiesta_task(1104) ->
	#base_fiesta_task{id = 1104,content = kill_per_boss,desc = <<"击杀专属大妖1次"/utf8>>,open_day = 8,open_lv = 200,times = 1,target_num = 1,exp = 20};

get_base_fiesta_task(1105) ->
	#base_fiesta_task{id = 1105,content = kill_world_boss,desc = <<"击杀世界大妖1次"/utf8>>,open_day = 8,open_lv = 200,times = 5,target_num = 1,exp = 10};

get_base_fiesta_task(1106) ->
	#base_fiesta_task{id = 1106,content = rune_hunt,desc = <<"进行一次御魂召唤"/utf8>>,open_day = 8,open_lv = 200,times = 1,target_num = 1,exp = 30};

get_base_fiesta_task(1107) ->
	#base_fiesta_task{id = 1107,content = liveness,desc = <<"活跃度到达150"/utf8>>,open_day = 8,open_lv = 200,times = 1,target_num = 150,exp = 50};

get_base_fiesta_task(1108) ->
	#base_fiesta_task{id = 1108,content = enter_jjc,desc = <<"完成10次竞技场"/utf8>>,open_day = 8,open_lv = 200,times = 1,target_num = 10,exp = 30};

get_base_fiesta_task(1109) ->
	#base_fiesta_task{id = 1109,content = sign_in,desc = <<"每日签到1次"/utf8>>,open_day = 8,open_lv = 200,times = 1,target_num = 1,exp = 10};

get_base_fiesta_task(1110) ->
	#base_fiesta_task{id = 1110,content = recharge_first,desc = <<"首次充值"/utf8>>,open_day = 8,open_lv = 200,times = 1,target_num = 1,exp = 30};

get_base_fiesta_task(1111) ->
	#base_fiesta_task{id = 1111,content = acc_consume,desc = <<"累计花费100勾玉"/utf8>>,open_day = 8,open_lv = 200,times = 1,target_num = 100,exp = 30};

get_base_fiesta_task(1112) ->
	#base_fiesta_task{id = 1112,content = enter_forbidden_dungeon,desc = <<"进入蛮荒大妖场景"/utf8>>,open_day = 8,open_lv = 240,times = 2,target_num = 1,exp = 10};

get_base_fiesta_task(1113) ->
	#base_fiesta_task{id = 1113,content = enter_dragon_dungeon,desc = <<"进入神纹副本"/utf8>>,open_day = 8,open_lv = 290,times = 2,target_num = 1,exp = 10};

get_base_fiesta_task(1114) ->
	#base_fiesta_task{id = 1114,content = kill_eudemons_boss,desc = <<"击杀蜃气楼大妖"/utf8>>,open_day = 8,open_lv = 320,times = 3,target_num = 1,exp = 20};

get_base_fiesta_task(1115) ->
	#base_fiesta_task{id = 1115,content = kill_decoration_boss,desc = <<"击杀怨灵封印大妖"/utf8>>,open_day = 8,open_lv = 360,times = 3,target_num = 1,exp = 20};

get_base_fiesta_task(1116) ->
	#base_fiesta_task{id = 1116,content = enter_fairyland_dungeon,desc = <<"进入秘境大妖场景"/utf8>>,open_day = 8,open_lv = 400,times = 2,target_num = 1,exp = 10};

get_base_fiesta_task(1117) ->
	#base_fiesta_task{id = 1117,content = kill_world_boss,desc = <<"击杀世界大妖1次"/utf8>>,open_day = 8,open_lv = 200,times = 5,target_num = 1,exp = 10};

get_base_fiesta_task(1118) ->
	#base_fiesta_task{id = 1118,content = enter_exp_dungeon,desc = <<"进入1次恶灵退治"/utf8>>,open_day = 8,open_lv = 200,times = 2,target_num = 1,exp = 10};

get_base_fiesta_task(1119) ->
	#base_fiesta_task{id = 1119,content = enter_sea_treasure,desc = <<"参与璀璨之海"/utf8>>,open_day = 8,open_lv = 200,times = 2,target_num = 1,exp = 10};

get_base_fiesta_task(1120) ->
	#base_fiesta_task{id = 1120,content = enter_forbidden_dungeon,desc = <<"进入蛮荒大妖场景"/utf8>>,open_day = 8,open_lv = 240,times = 2,target_num = 1,exp = 10};

get_base_fiesta_task(1121) ->
	#base_fiesta_task{id = 1121,content = enter_dragon_dungeon,desc = <<"进入神纹副本"/utf8>>,open_day = 8,open_lv = 290,times = 2,target_num = 1,exp = 10};

get_base_fiesta_task(1122) ->
	#base_fiesta_task{id = 1122,content = kill_eudemons_boss,desc = <<"击杀蜃气楼大妖"/utf8>>,open_day = 8,open_lv = 320,times = 3,target_num = 1,exp = 10};

get_base_fiesta_task(1123) ->
	#base_fiesta_task{id = 1123,content = pass_equip_dungeon,desc = <<"通关1次寻装觅刃"/utf8>>,open_day = 8,open_lv = 200,times = 1,target_num = 1,exp = 10};

get_base_fiesta_task(1124) ->
	#base_fiesta_task{id = 1124,content = kill_per_boss,desc = <<"击杀专属大妖1次"/utf8>>,open_day = 8,open_lv = 200,times = 1,target_num = 1,exp = 10};

get_base_fiesta_task(1125) ->
	#base_fiesta_task{id = 1125,content = treasure_hunt,desc = <<"进行装备夺宝1次"/utf8>>,open_day = 8,open_lv = 200,times = 1,target_num = 1,exp = 20};

get_base_fiesta_task(1126) ->
	#base_fiesta_task{id = 1126,content = enter_jjc,desc = <<"完成10次竞技场"/utf8>>,open_day = 8,open_lv = 200,times = 1,target_num = 10,exp = 20};

get_base_fiesta_task(1127) ->
	#base_fiesta_task{id = 1127,content = liveness,desc = <<"活跃度到达150"/utf8>>,open_day = 8,open_lv = 200,times = 1,target_num = 150,exp = 30};

get_base_fiesta_task(1128) ->
	#base_fiesta_task{id = 1128,content = acc_consume_bgold,desc = <<"累计花费300绑玉"/utf8>>,open_day = 8,open_lv = 95,times = 1,target_num = 300,exp = 30};

get_base_fiesta_task(1129) ->
	#base_fiesta_task{id = 1129,content = recharge_first,desc = <<"首次充值"/utf8>>,open_day = 8,open_lv = 200,times = 1,target_num = 1,exp = 30};

get_base_fiesta_task(2101) ->
	#base_fiesta_task{id = 2101,content = enter_midday_party,desc = <<"参与午间派对3次"/utf8>>,open_day = 8,open_lv = 200,times = 1,target_num = 3,exp = 20};

get_base_fiesta_task(2102) ->
	#base_fiesta_task{id = 2102,content = enter_midday_party,desc = <<"参与午间派对7次"/utf8>>,open_day = 8,open_lv = 200,times = 1,target_num = 7,exp = 40};

get_base_fiesta_task(2103) ->
	#base_fiesta_task{id = 2103,content = enter_guild_feast,desc = <<"参与结社晚宴3次"/utf8>>,open_day = 8,open_lv = 200,times = 1,target_num = 3,exp = 20};

get_base_fiesta_task(2104) ->
	#base_fiesta_task{id = 2104,content = enter_guild_feast,desc = <<"参与结社晚宴7次"/utf8>>,open_day = 8,open_lv = 200,times = 1,target_num = 7,exp = 40};

get_base_fiesta_task(2105) ->
	#base_fiesta_task{id = 2105,content = enter_nine_palace,desc = <<"参与九魂妖塔3次"/utf8>>,open_day = 8,open_lv = 200,times = 1,target_num = 3,exp = 30};

get_base_fiesta_task(2106) ->
	#base_fiesta_task{id = 2106,content = enter_holy_battlefield,desc = <<"参与尊神战场3次"/utf8>>,open_day = 8,open_lv = 200,times = 1,target_num = 3,exp = 30};

get_base_fiesta_task(2107) ->
	#base_fiesta_task{id = 2107,content = enter_top_pk,desc = <<"参与10次巅峰竞技"/utf8>>,open_day = 8,open_lv = 200,times = 1,target_num = 10,exp = 30};

get_base_fiesta_task(2108) ->
	#base_fiesta_task{id = 2108,content = enter_guild_war,desc = <<"参与1次结社争霸"/utf8>>,open_day = 8,open_lv = 200,times = 1,target_num = 1,exp = 30};

get_base_fiesta_task(2109) ->
	#base_fiesta_task{id = 2109,content = enter_drumwar,desc = <<"参与1次勾玉擂台"/utf8>>,open_day = 8,open_lv = 250,times = 1,target_num = 1,exp = 30};

get_base_fiesta_task(3001) ->
	#base_fiesta_task{id = 3001,content = acc_login_days,desc = <<"累计登录游戏3天"/utf8>>,open_day = 1,open_lv = 95,times = 1,target_num = 3,exp = 15};

get_base_fiesta_task(3002) ->
	#base_fiesta_task{id = 3002,content = acc_login_days,desc = <<"累计登录游戏7天"/utf8>>,open_day = 1,open_lv = 95,times = 1,target_num = 7,exp = 30};

get_base_fiesta_task(3003) ->
	#base_fiesta_task{id = 3003,content = turn_task1,desc = <<"完成1转任务"/utf8>>,open_day = 1,open_lv = 95,times = 1,target_num = 1,exp = 10};

get_base_fiesta_task(3004) ->
	#base_fiesta_task{id = 3004,content = turn_task2,desc = <<"完成2转任务"/utf8>>,open_day = 1,open_lv = 95,times = 1,target_num = 1,exp = 15};

get_base_fiesta_task(3005) ->
	#base_fiesta_task{id = 3005,content = turn_task3,desc = <<"完成3转任务"/utf8>>,open_day = 1,open_lv = 95,times = 1,target_num = 1,exp = 20};

get_base_fiesta_task(3006) ->
	#base_fiesta_task{id = 3006,content = acc_pray,desc = <<"累计祈愿5次"/utf8>>,open_day = 1,open_lv = 95,times = 1,target_num = 5,exp = 25};

get_base_fiesta_task(3007) ->
	#base_fiesta_task{id = 3007,content = acc_pray,desc = <<"累计祈愿20次"/utf8>>,open_day = 1,open_lv = 95,times = 1,target_num = 20,exp = 30};

get_base_fiesta_task(3008) ->
	#base_fiesta_task{id = 3008,content = acc_pray,desc = <<"累计祈愿50次"/utf8>>,open_day = 1,open_lv = 95,times = 1,target_num = 50,exp = 40};

get_base_fiesta_task(3009) ->
	#base_fiesta_task{id = 3009,content = acc_recharge,desc = <<"累计充值30元"/utf8>>,open_day = 1,open_lv = 95,times = 1,target_num = 300,exp = 20};

get_base_fiesta_task(3010) ->
	#base_fiesta_task{id = 3010,content = acc_recharge,desc = <<"累计充值100元"/utf8>>,open_day = 1,open_lv = 95,times = 1,target_num = 1000,exp = 25};

get_base_fiesta_task(3011) ->
	#base_fiesta_task{id = 3011,content = acc_recharge,desc = <<"累计充值300元"/utf8>>,open_day = 1,open_lv = 95,times = 1,target_num = 3000,exp = 30};

get_base_fiesta_task(3012) ->
	#base_fiesta_task{id = 3012,content = acc_recharge,desc = <<"累计充值600元"/utf8>>,open_day = 1,open_lv = 95,times = 1,target_num = 6000,exp = 40};

get_base_fiesta_task(3013) ->
	#base_fiesta_task{id = 3013,content = acc_recharge,desc = <<"累计充值1000元"/utf8>>,open_day = 1,open_lv = 95,times = 1,target_num = 10000,exp = 40};

get_base_fiesta_task(3014) ->
	#base_fiesta_task{id = 3014,content = acc_recharge,desc = <<"累计充值2000元"/utf8>>,open_day = 1,open_lv = 95,times = 1,target_num = 20000,exp = 40};

get_base_fiesta_task(3015) ->
	#base_fiesta_task{id = 3015,content = acc_consume,desc = <<"累计花费300勾玉"/utf8>>,open_day = 1,open_lv = 95,times = 1,target_num = 300,exp = 20};

get_base_fiesta_task(3016) ->
	#base_fiesta_task{id = 3016,content = acc_consume,desc = <<"累计花费1000勾玉"/utf8>>,open_day = 1,open_lv = 95,times = 1,target_num = 1000,exp = 25};

get_base_fiesta_task(3017) ->
	#base_fiesta_task{id = 3017,content = acc_consume,desc = <<"累计花费3000勾玉"/utf8>>,open_day = 1,open_lv = 95,times = 1,target_num = 3000,exp = 30};

get_base_fiesta_task(3018) ->
	#base_fiesta_task{id = 3018,content = acc_consume,desc = <<"累计花费6000勾玉"/utf8>>,open_day = 1,open_lv = 95,times = 1,target_num = 6000,exp = 40};

get_base_fiesta_task(3019) ->
	#base_fiesta_task{id = 3019,content = acc_consume,desc = <<"累计花费10000勾玉"/utf8>>,open_day = 1,open_lv = 95,times = 1,target_num = 10000,exp = 40};

get_base_fiesta_task(3020) ->
	#base_fiesta_task{id = 3020,content = acc_consume,desc = <<"累计花费20000勾玉"/utf8>>,open_day = 1,open_lv = 95,times = 1,target_num = 20000,exp = 40};

get_base_fiesta_task(3021) ->
	#base_fiesta_task{id = 3021,content = acc_login_days,desc = <<"累计登录游戏1天"/utf8>>,open_day = 1,open_lv = 95,times = 1,target_num = 1,exp = 100};

get_base_fiesta_task(3022) ->
	#base_fiesta_task{id = 3022,content = acc_login_days,desc = <<"累计登录游戏3天"/utf8>>,open_day = 1,open_lv = 95,times = 1,target_num = 3,exp = 25};

get_base_fiesta_task(3023) ->
	#base_fiesta_task{id = 3023,content = acc_login_days,desc = <<"累计登录游戏7天"/utf8>>,open_day = 1,open_lv = 95,times = 1,target_num = 7,exp = 30};

get_base_fiesta_task(3024) ->
	#base_fiesta_task{id = 3024,content = turn_task1,desc = <<"完成1转任务"/utf8>>,open_day = 1,open_lv = 95,times = 1,target_num = 1,exp = 20};

get_base_fiesta_task(3025) ->
	#base_fiesta_task{id = 3025,content = turn_task2,desc = <<"完成2转任务"/utf8>>,open_day = 1,open_lv = 95,times = 1,target_num = 1,exp = 30};

get_base_fiesta_task(3026) ->
	#base_fiesta_task{id = 3026,content = turn_task3,desc = <<"完成3转任务"/utf8>>,open_day = 1,open_lv = 95,times = 1,target_num = 1,exp = 50};

get_base_fiesta_task(3027) ->
	#base_fiesta_task{id = 3027,content = acc_pray,desc = <<"累计祈愿5次"/utf8>>,open_day = 1,open_lv = 95,times = 1,target_num = 5,exp = 25};

get_base_fiesta_task(3028) ->
	#base_fiesta_task{id = 3028,content = acc_pray,desc = <<"累计祈愿10次"/utf8>>,open_day = 1,open_lv = 95,times = 1,target_num = 10,exp = 30};

get_base_fiesta_task(3029) ->
	#base_fiesta_task{id = 3029,content = acc_pray,desc = <<"累计祈愿30次"/utf8>>,open_day = 1,open_lv = 95,times = 1,target_num = 30,exp = 50};

get_base_fiesta_task(3030) ->
	#base_fiesta_task{id = 3030,content = acc_consume_bgold,desc = <<"累计花费500绑玉"/utf8>>,open_day = 1,open_lv = 95,times = 1,target_num = 500,exp = 20};

get_base_fiesta_task(3031) ->
	#base_fiesta_task{id = 3031,content = acc_consume_bgold,desc = <<"累计花费1000绑玉"/utf8>>,open_day = 1,open_lv = 95,times = 1,target_num = 1000,exp = 30};

get_base_fiesta_task(3032) ->
	#base_fiesta_task{id = 3032,content = acc_consume_bgold,desc = <<"累计花费2000绑玉"/utf8>>,open_day = 1,open_lv = 95,times = 1,target_num = 2000,exp = 30};

get_base_fiesta_task(3033) ->
	#base_fiesta_task{id = 3033,content = acc_consume_bgold,desc = <<"累计花费5000绑玉"/utf8>>,open_day = 1,open_lv = 95,times = 1,target_num = 5000,exp = 40};

get_base_fiesta_task(3034) ->
	#base_fiesta_task{id = 3034,content = acc_consume_bgold,desc = <<"累计花费8000绑玉"/utf8>>,open_day = 1,open_lv = 95,times = 1,target_num = 8000,exp = 40};

get_base_fiesta_task(3035) ->
	#base_fiesta_task{id = 3035,content = acc_consume_bgold,desc = <<"累计花费10000绑玉"/utf8>>,open_day = 1,open_lv = 95,times = 1,target_num = 10000,exp = 50};

get_base_fiesta_task(3036) ->
	#base_fiesta_task{id = 3036,content = acc_recharge,desc = <<"累计充值10元"/utf8>>,open_day = 1,open_lv = 95,times = 1,target_num = 100,exp = 30};

get_base_fiesta_task(3037) ->
	#base_fiesta_task{id = 3037,content = acc_recharge,desc = <<"累计充值20元"/utf8>>,open_day = 1,open_lv = 95,times = 1,target_num = 200,exp = 50};

get_base_fiesta_task(3038) ->
	#base_fiesta_task{id = 3038,content = acc_recharge,desc = <<"累计充值50元"/utf8>>,open_day = 1,open_lv = 95,times = 1,target_num = 500,exp = 60};

get_base_fiesta_task(3039) ->
	#base_fiesta_task{id = 3039,content = acc_recharge,desc = <<"累计充值100元"/utf8>>,open_day = 1,open_lv = 95,times = 1,target_num = 1000,exp = 80};

get_base_fiesta_task(3040) ->
	#base_fiesta_task{id = 3040,content = acc_recharge,desc = <<"累计充值200元"/utf8>>,open_day = 1,open_lv = 95,times = 1,target_num = 2000,exp = 80};

get_base_fiesta_task(3041) ->
	#base_fiesta_task{id = 3041,content = acc_recharge,desc = <<"累计充值300元"/utf8>>,open_day = 1,open_lv = 95,times = 1,target_num = 3000,exp = 100};

get_base_fiesta_task(3101) ->
	#base_fiesta_task{id = 3101,content = acc_login_days,desc = <<"累计登录7天"/utf8>>,open_day = 8,open_lv = 200,times = 1,target_num = 7,exp = 20};

get_base_fiesta_task(3102) ->
	#base_fiesta_task{id = 3102,content = acc_login_days,desc = <<"累计登录15天"/utf8>>,open_day = 8,open_lv = 200,times = 1,target_num = 15,exp = 40};

get_base_fiesta_task(3103) ->
	#base_fiesta_task{id = 3103,content = acc_login_days,desc = <<"累计登录30天"/utf8>>,open_day = 8,open_lv = 200,times = 1,target_num = 30,exp = 60};

get_base_fiesta_task(3104) ->
	#base_fiesta_task{id = 3104,content = acc_consume,desc = <<"累计花费1000勾玉"/utf8>>,open_day = 8,open_lv = 200,times = 1,target_num = 1000,exp = 40};

get_base_fiesta_task(3105) ->
	#base_fiesta_task{id = 3105,content = acc_consume,desc = <<"累计花费5000勾玉"/utf8>>,open_day = 8,open_lv = 200,times = 1,target_num = 5000,exp = 60};

get_base_fiesta_task(3106) ->
	#base_fiesta_task{id = 3106,content = acc_consume,desc = <<"累计花费15000勾玉"/utf8>>,open_day = 8,open_lv = 200,times = 1,target_num = 15000,exp = 80};

get_base_fiesta_task(3107) ->
	#base_fiesta_task{id = 3107,content = acc_consume,desc = <<"累计花费30000勾玉"/utf8>>,open_day = 8,open_lv = 200,times = 1,target_num = 30000,exp = 100};

get_base_fiesta_task(3108) ->
	#base_fiesta_task{id = 3108,content = acc_consume,desc = <<"累计花费50000勾玉"/utf8>>,open_day = 8,open_lv = 200,times = 1,target_num = 50000,exp = 120};

get_base_fiesta_task(3109) ->
	#base_fiesta_task{id = 3109,content = acc_recharge,desc = <<"累计充值100元"/utf8>>,open_day = 8,open_lv = 200,times = 1,target_num = 1000,exp = 40};

get_base_fiesta_task(3110) ->
	#base_fiesta_task{id = 3110,content = acc_recharge,desc = <<"累计充值500元"/utf8>>,open_day = 8,open_lv = 200,times = 1,target_num = 5000,exp = 60};

get_base_fiesta_task(3111) ->
	#base_fiesta_task{id = 3111,content = acc_recharge,desc = <<"累计充值1500元"/utf8>>,open_day = 8,open_lv = 200,times = 1,target_num = 15000,exp = 80};

get_base_fiesta_task(3112) ->
	#base_fiesta_task{id = 3112,content = acc_recharge,desc = <<"累计充值3000元"/utf8>>,open_day = 8,open_lv = 200,times = 1,target_num = 30000,exp = 100};

get_base_fiesta_task(3113) ->
	#base_fiesta_task{id = 3113,content = acc_recharge,desc = <<"累计充值5000元"/utf8>>,open_day = 8,open_lv = 200,times = 1,target_num = 50000,exp = 120};

get_base_fiesta_task(3114) ->
	#base_fiesta_task{id = 3114,content = treasure_hunt,desc = <<"累计装备夺宝100次"/utf8>>,open_day = 8,open_lv = 200,times = 1,target_num = 100,exp = 30};

get_base_fiesta_task(3115) ->
	#base_fiesta_task{id = 3115,content = treasure_hunt,desc = <<"累计装备夺宝300次"/utf8>>,open_day = 8,open_lv = 200,times = 1,target_num = 300,exp = 50};

get_base_fiesta_task(3116) ->
	#base_fiesta_task{id = 3116,content = treasure_hunt,desc = <<"累计装备夺宝500次"/utf8>>,open_day = 8,open_lv = 200,times = 1,target_num = 500,exp = 80};

get_base_fiesta_task(3117) ->
	#base_fiesta_task{id = 3117,content = peak_hunt,desc = <<"累计巅峰夺宝100次"/utf8>>,open_day = 8,open_lv = 371,times = 1,target_num = 100,exp = 50};

get_base_fiesta_task(3118) ->
	#base_fiesta_task{id = 3118,content = peak_hunt,desc = <<"累计巅峰夺宝300次"/utf8>>,open_day = 8,open_lv = 371,times = 1,target_num = 300,exp = 80};

get_base_fiesta_task(3119) ->
	#base_fiesta_task{id = 3119,content = peak_hunt,desc = <<"累计巅峰夺宝500次"/utf8>>,open_day = 8,open_lv = 371,times = 1,target_num = 500,exp = 120};

get_base_fiesta_task(3120) ->
	#base_fiesta_task{id = 3120,content = extreme_hunt,desc = <<"累计至尊夺宝100次"/utf8>>,open_day = 8,open_lv = 500,times = 1,target_num = 100,exp = 50};

get_base_fiesta_task(3121) ->
	#base_fiesta_task{id = 3121,content = extreme_hunt,desc = <<"累计至尊夺宝300次"/utf8>>,open_day = 8,open_lv = 500,times = 1,target_num = 300,exp = 80};

get_base_fiesta_task(3122) ->
	#base_fiesta_task{id = 3122,content = extreme_hunt,desc = <<"累计至尊夺宝500次"/utf8>>,open_day = 8,open_lv = 500,times = 1,target_num = 500,exp = 120};

get_base_fiesta_task(3123) ->
	#base_fiesta_task{id = 3123,content = acc_login_days,desc = <<"累计登录7天"/utf8>>,open_day = 8,open_lv = 200,times = 1,target_num = 7,exp = 20};

get_base_fiesta_task(3124) ->
	#base_fiesta_task{id = 3124,content = acc_login_days,desc = <<"累计登录15天"/utf8>>,open_day = 8,open_lv = 200,times = 1,target_num = 15,exp = 40};

get_base_fiesta_task(3125) ->
	#base_fiesta_task{id = 3125,content = acc_login_days,desc = <<"累计登录30天"/utf8>>,open_day = 8,open_lv = 200,times = 1,target_num = 30,exp = 60};

get_base_fiesta_task(3126) ->
	#base_fiesta_task{id = 3126,content = rune_hunt,desc = <<"累计御魂召唤20次"/utf8>>,open_day = 8,open_lv = 200,times = 1,target_num = 20,exp = 40};

get_base_fiesta_task(3127) ->
	#base_fiesta_task{id = 3127,content = rune_hunt,desc = <<"累计御魂召唤30次"/utf8>>,open_day = 8,open_lv = 200,times = 1,target_num = 30,exp = 60};

get_base_fiesta_task(3128) ->
	#base_fiesta_task{id = 3128,content = rune_hunt,desc = <<"累计御魂召唤50次"/utf8>>,open_day = 8,open_lv = 200,times = 1,target_num = 50,exp = 100};

get_base_fiesta_task(3129) ->
	#base_fiesta_task{id = 3129,content = rune_hunt,desc = <<"累计御魂召唤100次"/utf8>>,open_day = 8,open_lv = 200,times = 1,target_num = 100,exp = 200};

get_base_fiesta_task(3130) ->
	#base_fiesta_task{id = 3130,content = peak_hunt,desc = <<"累计巅峰夺宝50次"/utf8>>,open_day = 8,open_lv = 371,times = 1,target_num = 50,exp = 50};

get_base_fiesta_task(3131) ->
	#base_fiesta_task{id = 3131,content = peak_hunt,desc = <<"累计巅峰夺宝100次"/utf8>>,open_day = 8,open_lv = 371,times = 1,target_num = 100,exp = 100};

get_base_fiesta_task(3132) ->
	#base_fiesta_task{id = 3132,content = peak_hunt,desc = <<"累计巅峰夺宝200次"/utf8>>,open_day = 8,open_lv = 371,times = 1,target_num = 200,exp = 200};

get_base_fiesta_task(3133) ->
	#base_fiesta_task{id = 3133,content = peak_hunt,desc = <<"累计巅峰夺宝300次"/utf8>>,open_day = 8,open_lv = 371,times = 1,target_num = 300,exp = 300};

get_base_fiesta_task(3134) ->
	#base_fiesta_task{id = 3134,content = extreme_hunt,desc = <<"累计至尊夺宝50次"/utf8>>,open_day = 8,open_lv = 500,times = 1,target_num = 50,exp = 50};

get_base_fiesta_task(3135) ->
	#base_fiesta_task{id = 3135,content = extreme_hunt,desc = <<"累计至尊夺宝100次"/utf8>>,open_day = 8,open_lv = 500,times = 1,target_num = 100,exp = 100};

get_base_fiesta_task(3136) ->
	#base_fiesta_task{id = 3136,content = extreme_hunt,desc = <<"累计至尊夺宝200次"/utf8>>,open_day = 8,open_lv = 500,times = 1,target_num = 200,exp = 200};

get_base_fiesta_task(3137) ->
	#base_fiesta_task{id = 3137,content = extreme_hunt,desc = <<"累计至尊夺宝300次"/utf8>>,open_day = 8,open_lv = 500,times = 1,target_num = 300,exp = 300};

get_base_fiesta_task(3138) ->
	#base_fiesta_task{id = 3138,content = acc_consume_bgold,desc = <<"累计花费500绑玉"/utf8>>,open_day = 8,open_lv = 200,times = 1,target_num = 500,exp = 20};

get_base_fiesta_task(3139) ->
	#base_fiesta_task{id = 3139,content = acc_consume_bgold,desc = <<"累计花费1000绑玉"/utf8>>,open_day = 8,open_lv = 200,times = 1,target_num = 1000,exp = 30};

get_base_fiesta_task(3140) ->
	#base_fiesta_task{id = 3140,content = acc_consume_bgold,desc = <<"累计花费3000绑玉"/utf8>>,open_day = 8,open_lv = 200,times = 1,target_num = 3000,exp = 40};

get_base_fiesta_task(3141) ->
	#base_fiesta_task{id = 3141,content = acc_consume_bgold,desc = <<"累计花费5000绑玉"/utf8>>,open_day = 8,open_lv = 200,times = 1,target_num = 5000,exp = 50};

get_base_fiesta_task(3142) ->
	#base_fiesta_task{id = 3142,content = acc_consume_bgold,desc = <<"累计花费10000绑玉"/utf8>>,open_day = 8,open_lv = 200,times = 1,target_num = 10000,exp = 60};

get_base_fiesta_task(3143) ->
	#base_fiesta_task{id = 3143,content = acc_recharge,desc = <<"累计充值100元"/utf8>>,open_day = 8,open_lv = 200,times = 1,target_num = 1000,exp = 50};

get_base_fiesta_task(3144) ->
	#base_fiesta_task{id = 3144,content = acc_recharge,desc = <<"累计充值300元"/utf8>>,open_day = 8,open_lv = 200,times = 1,target_num = 3000,exp = 80};

get_base_fiesta_task(3145) ->
	#base_fiesta_task{id = 3145,content = acc_recharge,desc = <<"累计充值600元"/utf8>>,open_day = 8,open_lv = 200,times = 1,target_num = 6000,exp = 100};

get_base_fiesta_task(3146) ->
	#base_fiesta_task{id = 3146,content = acc_recharge,desc = <<"累计充值1000元"/utf8>>,open_day = 8,open_lv = 200,times = 1,target_num = 10000,exp = 120};

get_base_fiesta_task(3147) ->
	#base_fiesta_task{id = 3147,content = acc_recharge,desc = <<"累计充值2000元"/utf8>>,open_day = 8,open_lv = 200,times = 1,target_num = 20000,exp = 150};

get_base_fiesta_task(_Id) ->
	[].


get_task_ids_by_ctype(acc_recharge) ->
[1001,1002,3009,3010,3011,3012,3013,3014,3036,3037,3038,3039,3040,3041,3109,3110,3111,3112,3113,3143,3144,3145,3146,3147];


get_task_ids_by_ctype(acc_consume) ->
[1003,1004,1111,3015,3016,3017,3018,3019,3020,3104,3105,3106,3107,3108];


get_task_ids_by_ctype(kill_world_boss) ->
[1005,1016,1105,1117];


get_task_ids_by_ctype(kill_per_boss) ->
[1006,1020,1104,1124];


get_task_ids_by_ctype(compose_red_equip) ->
[1007,1021];


get_task_ids_by_ctype(enter_forbidden_dungeon) ->
[1008,1017,1112,1120];


get_task_ids_by_ctype(enter_sea_treasure) ->
[1009,1018,1119];


get_task_ids_by_ctype(enter_midday_party) ->
[1010,1022,2101,2102];


get_task_ids_by_ctype(enter_guild_feast) ->
[1011,1023,2103,2104];


get_task_ids_by_ctype(pass_equip_dungeon) ->
[1012,1019,1101,1123];


get_task_ids_by_ctype(sweep_partner_new_dungeon) ->
[1013,1102];


get_task_ids_by_ctype(enter_jjc) ->
[1014,1025,1108,1126];


get_task_ids_by_ctype(liveness) ->
[1015,1026,1107,1127];


get_task_ids_by_ctype(kill_sanctuary_boss) ->
[1024];


get_task_ids_by_ctype(recharge_first) ->
[1027,1110,1129];


get_task_ids_by_ctype(enter_exp_dungeon) ->
[1103,1118];


get_task_ids_by_ctype(rune_hunt) ->
[1106,3126,3127,3128,3129];


get_task_ids_by_ctype(sign_in) ->
[1109];


get_task_ids_by_ctype(enter_dragon_dungeon) ->
[1113,1121];


get_task_ids_by_ctype(kill_eudemons_boss) ->
[1114,1122];


get_task_ids_by_ctype(kill_decoration_boss) ->
[1115];


get_task_ids_by_ctype(enter_fairyland_dungeon) ->
[1116];


get_task_ids_by_ctype(treasure_hunt) ->
[1125,3114,3115,3116];


get_task_ids_by_ctype(acc_consume_bgold) ->
[1128,3030,3031,3032,3033,3034,3035,3138,3139,3140,3141,3142];


get_task_ids_by_ctype(enter_nine_palace) ->
[2105];


get_task_ids_by_ctype(enter_holy_battlefield) ->
[2106];


get_task_ids_by_ctype(enter_top_pk) ->
[2107];


get_task_ids_by_ctype(enter_guild_war) ->
[2108];


get_task_ids_by_ctype(enter_drumwar) ->
[2109];


get_task_ids_by_ctype(acc_login_days) ->
[3001,3002,3021,3022,3023,3101,3102,3103,3123,3124,3125];


get_task_ids_by_ctype(turn_task1) ->
[3003,3024];


get_task_ids_by_ctype(turn_task2) ->
[3004,3025];


get_task_ids_by_ctype(turn_task3) ->
[3005,3026];


get_task_ids_by_ctype(acc_pray) ->
[3006,3007,3008,3027,3028,3029];


get_task_ids_by_ctype(peak_hunt) ->
[3117,3118,3119,3130,3131,3132,3133];


get_task_ids_by_ctype(extreme_hunt) ->
[3120,3121,3122,3134,3135,3136,3137];

get_task_ids_by_ctype(_Content) ->
	[].


get_task_desc_by_ctype(acc_recharge) ->
["每天充值6元","每天充值98元","累计充值30元","累计充值100元","累计充值300元","累计充值600元","累计充值1000元","累计充值2000元","累计充值10元","累计充值20元","累计充值50元","累计充值200元","累计充值500元","累计充值1500元","累计充值3000元","累计充值5000元"];


get_task_desc_by_ctype(acc_consume) ->
["每天花费60勾玉","每天花费980勾玉","累计花费100勾玉","累计花费300勾玉","累计花费1000勾玉","累计花费3000勾玉","累计花费6000勾玉","累计花费10000勾玉","累计花费20000勾玉","累计花费5000勾玉","累计花费15000勾玉","累计花费30000勾玉","累计花费50000勾玉"];


get_task_desc_by_ctype(kill_world_boss) ->
["击杀世界大妖1次"];


get_task_desc_by_ctype(kill_per_boss) ->
["击杀专属大妖1次"];


get_task_desc_by_ctype(compose_red_equip) ->
["合成1次红色装备"];


get_task_desc_by_ctype(enter_forbidden_dungeon) ->
["进入蛮荒大妖场景"];


get_task_desc_by_ctype(enter_sea_treasure) ->
["参与璀璨之海"];


get_task_desc_by_ctype(enter_midday_party) ->
["参与1次午间派对","参与午间派对3次","参与午间派对7次"];


get_task_desc_by_ctype(enter_guild_feast) ->
["参与1次结社晚宴","参与结社晚宴3次","参与结社晚宴7次"];


get_task_desc_by_ctype(pass_equip_dungeon) ->
["通关寻装觅刃","通关3次寻装觅刃","通关1次寻装觅刃"];


get_task_desc_by_ctype(sweep_partner_new_dungeon) ->
["扫荡1次神巫副本"];


get_task_desc_by_ctype(enter_jjc) ->
["完成10次竞技场"];


get_task_desc_by_ctype(liveness) ->
["活跃度到达150"];


get_task_desc_by_ctype(kill_sanctuary_boss) ->
["击杀异域大妖1次"];


get_task_desc_by_ctype(recharge_first) ->
["首次充值"];


get_task_desc_by_ctype(enter_exp_dungeon) ->
["进入2次恶灵退治","进入1次恶灵退治"];


get_task_desc_by_ctype(rune_hunt) ->
["进行一次御魂召唤","累计御魂召唤20次","累计御魂召唤30次","累计御魂召唤50次","累计御魂召唤100次"];


get_task_desc_by_ctype(sign_in) ->
["每日签到1次"];


get_task_desc_by_ctype(enter_dragon_dungeon) ->
["进入神纹副本"];


get_task_desc_by_ctype(kill_eudemons_boss) ->
["击杀蜃气楼大妖"];


get_task_desc_by_ctype(kill_decoration_boss) ->
["击杀怨灵封印大妖"];


get_task_desc_by_ctype(enter_fairyland_dungeon) ->
["进入秘境大妖场景"];


get_task_desc_by_ctype(treasure_hunt) ->
["进行装备夺宝1次","累计装备夺宝100次","累计装备夺宝300次","累计装备夺宝500次"];


get_task_desc_by_ctype(acc_consume_bgold) ->
["累计花费300绑玉","累计花费500绑玉","累计花费1000绑玉","累计花费2000绑玉","累计花费5000绑玉","累计花费8000绑玉","累计花费10000绑玉","累计花费3000绑玉"];


get_task_desc_by_ctype(enter_nine_palace) ->
["参与九魂妖塔3次"];


get_task_desc_by_ctype(enter_holy_battlefield) ->
["参与尊神战场3次"];


get_task_desc_by_ctype(enter_top_pk) ->
["参与10次巅峰竞技"];


get_task_desc_by_ctype(enter_guild_war) ->
["参与1次结社争霸"];


get_task_desc_by_ctype(enter_drumwar) ->
["参与1次勾玉擂台"];


get_task_desc_by_ctype(acc_login_days) ->
["累计登录游戏3天","累计登录游戏7天","累计登录游戏1天","累计登录7天","累计登录15天","累计登录30天"];


get_task_desc_by_ctype(turn_task1) ->
["完成1转任务"];


get_task_desc_by_ctype(turn_task2) ->
["完成2转任务"];


get_task_desc_by_ctype(turn_task3) ->
["完成3转任务"];


get_task_desc_by_ctype(acc_pray) ->
["累计祈愿5次","累计祈愿20次","累计祈愿50次","累计祈愿10次","累计祈愿30次"];


get_task_desc_by_ctype(peak_hunt) ->
["累计巅峰夺宝100次","累计巅峰夺宝300次","累计巅峰夺宝500次","累计巅峰夺宝50次","累计巅峰夺宝200次"];


get_task_desc_by_ctype(extreme_hunt) ->
["累计至尊夺宝100次","累计至尊夺宝300次","累计至尊夺宝500次","累计至尊夺宝50次","累计至尊夺宝200次"];

get_task_desc_by_ctype(_Content) ->
	[].

