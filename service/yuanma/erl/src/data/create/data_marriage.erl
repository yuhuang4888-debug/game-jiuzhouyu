%%%---------------------------------------
%%% module      : data_marriage
%%% description : 婚姻配置
%%%
%%%---------------------------------------
-module(data_marriage).
-compile(export_all).
-include("marriage.hrl").



get_marriage_life_stage_con(_) ->
	[].

get_marriage_life_heart_con(_,_) ->
	[].

get_marriage_show_love_con(_) ->
	[].

get_marriage_constant_con(1) ->
	#marriage_constant_con{id = 1,constant = 170,annotation = "婚姻开启等级"};

get_marriage_constant_con(2) ->
	#marriage_constant_con{id = 2,constant = 86400,annotation = "交友大厅发布信息的过期时效"};

get_marriage_constant_con(3) ->
	#marriage_constant_con{id = 3,constant = [],annotation = "交友大厅发布信息普通消耗"};

get_marriage_constant_con(4) ->
	#marriage_constant_con{id = 4,constant = [],annotation = "交友大厅发布信息特殊消耗"};

get_marriage_constant_con(5) ->
	#marriage_constant_con{id = 5,constant = 600,annotation = "求关注间隔时长(暂时不用)"};

get_marriage_constant_con(6) ->
	#marriage_constant_con{id = 6,constant = 600,annotation = "求送花间隔时长"};

get_marriage_constant_con(7) ->
	#marriage_constant_con{id = 7,constant = [{23020001,10,[]}],annotation = "戒指升星道具[{物品id,经验值,暴击列表}]"};

get_marriage_constant_con(8) ->
	#marriage_constant_con{id = 8,constant = 0,annotation = "表白需要的亲密度[暂时没有这个]"};

get_marriage_constant_con(9) ->
	#marriage_constant_con{id = 9,constant = 0,annotation = "求婚需要的亲密度"};

get_marriage_constant_con(10) ->
	#marriage_constant_con{id = 10,constant = 20,annotation = "求婚消息的过期时长"};

get_marriage_constant_con(11) ->
	#marriage_constant_con{id = 11,constant = [],annotation = "分手消耗(暂时没有分手)"};

get_marriage_constant_con(12) ->
	#marriage_constant_con{id = 12,constant = [{2,0,200}],annotation = "强制离婚的消耗"};

get_marriage_constant_con(13) ->
	#marriage_constant_con{id = 13,constant = [{2,0,520}],annotation = "礼包购买消耗"};

get_marriage_constant_con(14) ->
	#marriage_constant_con{id = 14,constant = 7,annotation = "礼包有效时长(天)"};

get_marriage_constant_con(15) ->
	#marriage_constant_con{id = 15,constant = [{2,0,520}],annotation = "礼包购买返还"};

get_marriage_constant_con(16) ->
	#marriage_constant_con{id = 16,constant = [{2,0,99},{0,23020001,4}],annotation = "礼包登陆领取奖励"};

get_marriage_constant_con(17) ->
	#marriage_constant_con{id = 17,constant = 600,annotation = "发布信息间隔"};

get_marriage_constant_con(18) ->
	#marriage_constant_con{id = 18,constant = 520,annotation = "异性进入副本所需的亲密度"};

get_marriage_constant_con(19) ->
	#marriage_constant_con{id = 19,constant = 5,annotation = "最大预约天数"};

get_marriage_constant_con(20) ->
	#marriage_constant_con{id = 20,constant = 8003,annotation = "婚宴场景"};

get_marriage_constant_con(21) ->
	#marriage_constant_con{id = 21,constant = [{2,0,20}],annotation = "增加宾客数量的价格"};

get_marriage_constant_con(22) ->
	#marriage_constant_con{id = 22,constant = 8002003,annotation = "普通喜糖id"};

get_marriage_constant_con(23) ->
	#marriage_constant_con{id = 23,constant = 8002004,annotation = "高级喜糖id"};

get_marriage_constant_con(24) ->
	#marriage_constant_con{id = 24,constant = 8002001,annotation = "餐桌1id"};

get_marriage_constant_con(25) ->
	#marriage_constant_con{id = 25,constant = 8002002,annotation = "餐桌2id"};

get_marriage_constant_con(26) ->
	#marriage_constant_con{id = 26,constant = 8002005,annotation = "餐桌3id"};

get_marriage_constant_con(27) ->
	#marriage_constant_con{id = 27,constant = 30,annotation = "气氛值增加时间间隔(秒)"};

get_marriage_constant_con(28) ->
	#marriage_constant_con{id = 28,constant = 0,annotation = "气氛值增加数值"};

get_marriage_constant_con(29) ->
	#marriage_constant_con{id = 29,constant = 300,annotation = "婚宴预告(秒)"};

get_marriage_constant_con(30) ->
	#marriage_constant_con{id = 30,constant = 75,annotation = "交友平台开启等级"};

get_marriage_constant_con(31) ->
	#marriage_constant_con{id = 31,constant = 40010001,annotation = "戒指解锁物品"};

get_marriage_constant_con(32) ->
	#marriage_constant_con{id = 32,constant = [1105,1205],annotation = "婚宴新人衣服时装[男方时装模型id,女方时装模型id]"};

get_marriage_constant_con(33) ->
	#marriage_constant_con{id = 33,constant = 180,annotation = "系统喜糖刷新间隔"};

get_marriage_constant_con(34) ->
	#marriage_constant_con{id = 34,constant = 8,annotation = "喜糖每次刷新个数"};

get_marriage_constant_con(35) ->
	#marriage_constant_con{id = 35,constant = 100,annotation = "喜糖刷新总数(超过就不会刷系统喜糖，没超过就继续刷新)"};

get_marriage_constant_con(36) ->
	#marriage_constant_con{id = 36,constant = 3,annotation = "系统喜糖最大刷新次数"};

get_marriage_constant_con(37) ->
	#marriage_constant_con{id = 37,constant = [{0,23020001,2}],annotation = "邀请奖励"};

get_marriage_constant_con(38) ->
	#marriage_constant_con{id = 38,constant = 100,annotation = "单场婚宴宾客总人数"};

get_marriage_constant_con(39) ->
	#marriage_constant_con{id = 39,constant = 7,annotation = "购买立得的等待天数"};

get_marriage_constant_con(40) ->
	#marriage_constant_con{id = 40,constant = 172800,annotation = "伴侣离线时长大于或等于X秒时，强制离婚不扣除消耗"};

get_marriage_constant_con(41) ->
	#marriage_constant_con{id = 41,constant = 37140001,annotation = "离婚时，根据恩爱值返还的道具ID"};

get_marriage_constant_con(_Id) ->
	[].


get_marriage_constant_val(1) ->
170;


get_marriage_constant_val(2) ->
86400;


get_marriage_constant_val(3) ->
[];


get_marriage_constant_val(4) ->
[];


get_marriage_constant_val(5) ->
600;


get_marriage_constant_val(6) ->
600;


get_marriage_constant_val(7) ->
[{23020001,10,[]}];


get_marriage_constant_val(8) ->
0;


get_marriage_constant_val(9) ->
0;


get_marriage_constant_val(10) ->
20;


get_marriage_constant_val(11) ->
[];


get_marriage_constant_val(12) ->
[{2,0,200}];


get_marriage_constant_val(13) ->
[{2,0,520}];


get_marriage_constant_val(14) ->
7;


get_marriage_constant_val(15) ->
[{2,0,520}];


get_marriage_constant_val(16) ->
[{2,0,99},{0,23020001,4}];


get_marriage_constant_val(17) ->
600;


get_marriage_constant_val(18) ->
520;


get_marriage_constant_val(19) ->
5;


get_marriage_constant_val(20) ->
8003;


get_marriage_constant_val(21) ->
[{2,0,20}];


get_marriage_constant_val(22) ->
8002003;


get_marriage_constant_val(23) ->
8002004;


get_marriage_constant_val(24) ->
8002001;


get_marriage_constant_val(25) ->
8002002;


get_marriage_constant_val(26) ->
8002005;


get_marriage_constant_val(27) ->
30;


get_marriage_constant_val(28) ->
0;


get_marriage_constant_val(29) ->
300;


get_marriage_constant_val(30) ->
75;


get_marriage_constant_val(31) ->
40010001;


get_marriage_constant_val(32) ->
[1105,1205];


get_marriage_constant_val(33) ->
180;


get_marriage_constant_val(34) ->
8;


get_marriage_constant_val(35) ->
100;


get_marriage_constant_val(36) ->
3;


get_marriage_constant_val(37) ->
[{0,23020001,2}];


get_marriage_constant_val(38) ->
100;


get_marriage_constant_val(39) ->
7;


get_marriage_constant_val(40) ->
172800;


get_marriage_constant_val(41) ->
37140001;

get_marriage_constant_val(_Id) ->
	0.

get_propose_info(1) ->
	#base_propose_cfg{propose_type = 1,propose_name = "温情守护",reward = [{0,40010001,1}],show_reward = [{one,[{0,40010001,1},{0,40020003,1}]},{tow,[{0,40020003,1}]}],dsgt = 401001,cost = [{2,0,199}],wedding_times = [{3,1}]};

get_propose_info(2) ->
	#base_propose_cfg{propose_type = 2,propose_name = "真爱无暇",reward = [{0,40010001,1},{0,32010588,1}],show_reward = [{one,[{0,40010001,1},{0,40020001,1},{0,32010588,1}]},{tow,[{0,40020001,1},{0,32010588,1}]}],dsgt = 401002,cost = [{1,0,520}],wedding_times = [{1,1}]};

get_propose_info(3) ->
	#base_propose_cfg{propose_type = 3,propose_name = "永恒眷恋",reward = [{0,40010001,1},{0,32010588,1}],show_reward = [{one,[{0,40010001,1},{0,40020002,1},{0,32010588,1}]},{tow,[{0,40020002,1},{0,32010588,1}]}],dsgt = 401003,cost = [{1,0,1314}],wedding_times = [{2,1}]};

get_propose_info(_Proposetype) ->
	[].

get_wedding_type_list() ->
[1,2,3].

get_love_dsgt(0) ->
	#base_love_dsgt_cfg{id = 0,dsgt = 401004,love_num = 250};

get_love_dsgt(1) ->
	#base_love_dsgt_cfg{id = 1,dsgt = 401005,love_num = 500};

get_love_dsgt(2) ->
	#base_love_dsgt_cfg{id = 2,dsgt = 401006,love_num = 1000};

get_love_dsgt(3) ->
	#base_love_dsgt_cfg{id = 3,dsgt = 401007,love_num = 2000};

get_love_dsgt(4) ->
	#base_love_dsgt_cfg{id = 4,dsgt = 401008,love_num = 4000};

get_love_dsgt(5) ->
	#base_love_dsgt_cfg{id = 5,dsgt = 401009,love_num = 8000};

get_love_dsgt(6) ->
	#base_love_dsgt_cfg{id = 6,dsgt = 401010,love_num = 16000};

get_love_dsgt(7) ->
	#base_love_dsgt_cfg{id = 7,dsgt = 401011,love_num = 32000};

get_love_dsgt(8) ->
	#base_love_dsgt_cfg{id = 8,dsgt = 401012,love_num = 64000};

get_love_dsgt(9) ->
	#base_love_dsgt_cfg{id = 9,dsgt = 401013,love_num = 128000};

get_love_dsgt(_Id) ->
	[].

get_dsgt_by_love() ->
[{401013,128000},{401012,64000},{401011,32000},{401010,16000},{401009,8000},{401008,4000},{401007,2000},{401006,1000},{401005,500},{401004,250}].

get_tag_info(1,1) ->
{1,1};

get_tag_info(1,2) ->
{1,2};

get_tag_info(1,3) ->
{1,3};

get_tag_info(1,4) ->
{1,4};

get_tag_info(1,5) ->
{1,5};

get_tag_info(1,6) ->
{1,6};

get_tag_info(1,7) ->
{1,7};

get_tag_info(1,8) ->
{1,8};

get_tag_info(1,9) ->
{1,9};

get_tag_info(1,10) ->
{1,10};

get_tag_info(1,11) ->
{1,11};

get_tag_info(1,12) ->
{1,12};

get_tag_info(1,13) ->
{1,13};

get_tag_info(2,1) ->
{2,1};

get_tag_info(2,2) ->
{2,2};

get_tag_info(2,3) ->
{2,3};

get_tag_info(2,4) ->
{2,4};

get_tag_info(2,5) ->
{2,5};

get_tag_info(2,6) ->
{2,6};

get_tag_info(2,7) ->
{2,7};

get_tag_info(2,8) ->
{2,8};

get_tag_info(2,9) ->
{2,9};

get_tag_info(2,10) ->
{2,10};

get_tag_info(2,11) ->
{2,11};

get_tag_info(2,12) ->
{2,12};

get_tag_info(2,13) ->
{2,13};

get_tag_info(2,14) ->
{2,14};

get_tag_info(2,15) ->
{2,15};

get_tag_info(3,1) ->
{3,1};

get_tag_info(3,2) ->
{3,2};

get_tag_info(3,3) ->
{3,3};

get_tag_info(3,4) ->
{3,4};

get_tag_info(3,5) ->
{3,5};

get_tag_info(3,6) ->
{3,6};

get_tag_info(4,1) ->
{4,1};

get_tag_info(4,2) ->
{4,2};

get_tag_info(4,3) ->
{4,3};

get_tag_info(4,4) ->
{4,4};

get_tag_info(4,5) ->
{4,5};

get_tag_info(4,6) ->
{4,6};

get_tag_info(4,7) ->
{4,7};

get_tag_info(4,8) ->
{4,8};

get_tag_info(5,1) ->
{5,1};

get_tag_info(5,2) ->
{5,2};

get_tag_info(5,3) ->
{5,3};

get_tag_info(5,4) ->
{5,4};

get_tag_info(5,5) ->
{5,5};

get_tag_info(5,6) ->
{5,6};

get_tag_info(5,7) ->
{5,7};

get_tag_info(5,8) ->
{5,8};

get_tag_info(5,9) ->
{5,9};

get_tag_info(5,10) ->
{5,10};

get_tag_info(5,11) ->
{5,11};

get_tag_info(5,12) ->
{5,12};

get_tag_info(5,13) ->
{5,13};

get_tag_info(5,14) ->
{5,14};

get_tag_info(5,15) ->
{5,15};

get_tag_info(5,16) ->
{5,16};

get_tag_info(5,17) ->
{5,17};

get_tag_info(5,18) ->
{5,18};

get_tag_info(_Tagid,_Tagsubid) ->
	[].

