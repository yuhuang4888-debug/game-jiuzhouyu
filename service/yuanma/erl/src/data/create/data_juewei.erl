%%%---------------------------------------
%%% module      : data_juewei
%%% description : 爵位信息配置
%%%
%%%---------------------------------------
-module(data_juewei).
-compile(export_all).
-include("juewei.hrl").



get_juewei_con(1) ->
	#juewei_con{juewei_lv = 1,juewei_name = <<"平民"/utf8>>,need_power = 60000,goods_list = [{0,38040003,10}],attr_list = [{1,40},{2,800},{3,15},{4,15}],color = 0};

get_juewei_con(2) ->
	#juewei_con{juewei_lv = 2,juewei_name = <<"武士"/utf8>>,need_power = 120000,goods_list = [{0,38040003,20}],attr_list = [{1,120},{2,2400},{3,45},{4,45}],color = 1};

get_juewei_con(3) ->
	#juewei_con{juewei_lv = 3,juewei_name = <<"容克"/utf8>>,need_power = 200000,goods_list = [{0,38040003,40}],attr_list = [{1,240},{2,4800},{3,90},{4,90}],color = 1};

get_juewei_con(4) ->
	#juewei_con{juewei_lv = 4,juewei_name = <<"乡绅"/utf8>>,need_power = 350000,goods_list = [{0,38040003,70}],attr_list = [{1,400},{2,8000},{3,150},{4,150}],color = 2};

get_juewei_con(5) ->
	#juewei_con{juewei_lv = 5,juewei_name = <<"游侠"/utf8>>,need_power = 600000,goods_list = [{0,38040003,110}],attr_list = [{1,600},{2,12000},{3,225},{4,225}],color = 2};

get_juewei_con(6) ->
	#juewei_con{juewei_lv = 6,juewei_name = <<"士官"/utf8>>,need_power = 1000000,goods_list = [{0,38040003,160}],attr_list = [{1,840},{2,16800},{3,315},{4,315}],color = 2};

get_juewei_con(7) ->
	#juewei_con{juewei_lv = 7,juewei_name = <<"骑士"/utf8>>,need_power = 1500000,goods_list = [{0,38040003,220}],attr_list = [{1,1120},{2,22400},{3,420},{4,420}],color = 3};

get_juewei_con(8) ->
	#juewei_con{juewei_lv = 8,juewei_name = <<"骑士王"/utf8>>,need_power = 2300000,goods_list = [{0,38040003,300}],attr_list = [{1,1440},{2,28800},{3,540},{4,540}],color = 3};

get_juewei_con(9) ->
	#juewei_con{juewei_lv = 9,juewei_name = <<"勋爵"/utf8>>,need_power = 3500000,goods_list = [{0,38040003,400}],attr_list = [{1,1800},{2,36000},{3,675},{4,675}],color = 3};

get_juewei_con(10) ->
	#juewei_con{juewei_lv = 10,juewei_name = <<"从男爵"/utf8>>,need_power = 5000000,goods_list = [{0,38040003,550}],attr_list = [{1,2200},{2,44000},{3,825},{4,825}],color = 3};

get_juewei_con(11) ->
	#juewei_con{juewei_lv = 11,juewei_name = <<"男爵"/utf8>>,need_power = 6800000,goods_list = [{0,38040003,750}],attr_list = [{1,2640},{2,52800},{3,990},{4,990}],color = 4};

get_juewei_con(12) ->
	#juewei_con{juewei_lv = 12,juewei_name = <<"子爵"/utf8>>,need_power = 8800000,goods_list = [{0,38040003,1000}],attr_list = [{1,3120},{2,62400},{3,1170},{4,1170}],color = 4};

get_juewei_con(13) ->
	#juewei_con{juewei_lv = 13,juewei_name = <<"伯爵"/utf8>>,need_power = 11000000,goods_list = [{0,38040003,1500}],attr_list = [{1,3640},{2,72800},{3,1365},{4,1365}],color = 4};

get_juewei_con(14) ->
	#juewei_con{juewei_lv = 14,juewei_name = <<"侯爵"/utf8>>,need_power = 13400000,goods_list = [{0,38040003,2000}],attr_list = [{1,4200},{2,84000},{3,1575},{4,1575}],color = 4};

get_juewei_con(15) ->
	#juewei_con{juewei_lv = 15,juewei_name = <<"公爵"/utf8>>,need_power = 16000000,goods_list = [{0,38040003,2500}],attr_list = [{1,4800},{2,96000},{3,1800},{4,1800}],color = 4};

get_juewei_con(16) ->
	#juewei_con{juewei_lv = 16,juewei_name = <<"大公"/utf8>>,need_power = 18800000,goods_list = [{0,38040003,3000}],attr_list = [{1,5440},{2,108800},{3,2040},{4,2040}],color = 5};

get_juewei_con(17) ->
	#juewei_con{juewei_lv = 17,juewei_name = <<"亲王"/utf8>>,need_power = 21800000,goods_list = [{0,38040003,6000}],attr_list = [{1,6120},{2,122400},{3,2295},{4,2295}],color = 5};

get_juewei_con(18) ->
	#juewei_con{juewei_lv = 18,juewei_name = <<"王储"/utf8>>,need_power = 25000000,goods_list = [{0,38040003,10000}],attr_list = [{1,6840},{2,136800},{3,2565},{4,2565}],color = 5};

get_juewei_con(19) ->
	#juewei_con{juewei_lv = 19,juewei_name = <<"国王"/utf8>>,need_power = 28400000,goods_list = [{0,38040003,15000}],attr_list = [{1,7600},{2,152000},{3,2850},{4,2850}],color = 5};

get_juewei_con(20) ->
	#juewei_con{juewei_lv = 20,juewei_name = <<"大帝"/utf8>>,need_power = 33000000,goods_list = [{0,38040003,20000}],attr_list = [{1,8400},{2,168000},{3,3150},{4,3150}],color = 5};

get_juewei_con(_Jueweilv) ->
	[].

