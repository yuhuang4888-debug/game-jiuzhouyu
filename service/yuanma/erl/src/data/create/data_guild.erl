%%%---------------------------------------
%%% module      : data_guild
%%% description : 公会配置
%%%
%%%---------------------------------------
-module(data_guild).
-compile(export_all).
-include("guild.hrl").



get_guild_pos_cfg(1) ->
	#guild_pos_cfg{position = 1,name = "会长",permission_list = [1,2,3,4,5,6,7,8,9,10,11,12,13],num = 1};

get_guild_pos_cfg(2) ->
	#guild_pos_cfg{position = 2,name = "副会长",permission_list = [1,3,5,6,7,9,10],num = 2};

get_guild_pos_cfg(3) ->
	#guild_pos_cfg{position = 3,name = "会员",permission_list = [7,10],num = 10000};

get_guild_pos_cfg(4) ->
	#guild_pos_cfg{position = 4,name = "宝贝",permission_list = [1,7,10],num = 2};

get_guild_pos_cfg(5) ->
	#guild_pos_cfg{position = 5,name = "精英",permission_list = [1,7,10],num = 2};

get_guild_pos_cfg(_Position) ->
	[].

get_guild_lv_cfg(1) ->
	#guild_lv_cfg{lv = 1,member_capacity = 30,growth_val_limit = 100,upgrade_desc = "可喜可贺！在结社所有成员的努力下，结社已经达到1级！结社成员上限达到30个！"};

get_guild_lv_cfg(2) ->
	#guild_lv_cfg{lv = 2,member_capacity = 35,growth_val_limit = 150,upgrade_desc = "可喜可贺！在结社所有成员的努力下，结社已经达到2级！结社成员上限达到35个！"};

get_guild_lv_cfg(3) ->
	#guild_lv_cfg{lv = 3,member_capacity = 40,growth_val_limit = 200,upgrade_desc = "可喜可贺！在结社所有成员的努力下，结社已经达到3级！结社成员上限达到40个！"};

get_guild_lv_cfg(4) ->
	#guild_lv_cfg{lv = 4,member_capacity = 45,growth_val_limit = 450,upgrade_desc = "可喜可贺！在结社所有成员的努力下，结社已经达到4级！结社成员上限达到45个！"};

get_guild_lv_cfg(5) ->
	#guild_lv_cfg{lv = 5,member_capacity = 50,growth_val_limit = 1000,upgrade_desc = "可喜可贺！在结社所有成员的努力下，结社已经达到5级！结社成员上限达到50个！"};

get_guild_lv_cfg(6) ->
	#guild_lv_cfg{lv = 6,member_capacity = 55,growth_val_limit = 2000,upgrade_desc = "可喜可贺！在结社所有成员的努力下，结社已经达到6级！结社成员上限达到55个！"};

get_guild_lv_cfg(7) ->
	#guild_lv_cfg{lv = 7,member_capacity = 60,growth_val_limit = 4000,upgrade_desc = "可喜可贺！在结社所有成员的努力下，结社已经达到7级！结社成员上限达到60个！"};

get_guild_lv_cfg(8) ->
	#guild_lv_cfg{lv = 8,member_capacity = 65,growth_val_limit = 8000,upgrade_desc = "可喜可贺！在结社所有成员的努力下，结社已经达到8级！结社成员上限达到65个！"};

get_guild_lv_cfg(9) ->
	#guild_lv_cfg{lv = 9,member_capacity = 70,growth_val_limit = 16000,upgrade_desc = "可喜可贺！在结社所有成员的努力下，结社已经达到9级！结社成员上限达到70个！"};

get_guild_lv_cfg(10) ->
	#guild_lv_cfg{lv = 10,member_capacity = 75,growth_val_limit = 32000,upgrade_desc = "可喜可贺！在结社所有成员的努力下，结社已经达到10级！结社成员上限达到75个！"};

get_guild_lv_cfg(_Lv) ->
	[].


get_cfg(member_capacity) ->
30;


get_cfg(guild_apply_len_limit) ->
20;


get_cfg(announce_len) ->
200;


get_cfg(auto_to_chief_max_offline_time_lim) ->
172800;


get_cfg(auto_to_chief_af_chief_leave_time) ->
172800;


get_cfg(apply_join_guild_lv) ->
45;


get_cfg(create_guild_lv) ->
45;


get_cfg(guild_name_len) ->
10;


get_cfg(free_modify_times) ->
10;


get_cfg(modify_announce_cost_gold) ->
30;


get_cfg(default_salary) ->
[{0,38070002,1},{3,0,10000}];


get_cfg(create_guild_normal_cost) ->
[{2, 0, 100}];


get_cfg(create_guild_special_cost) ->
[{1, 0, 50}];


get_cfg(rename_cost_goods) ->
[{1,[{0, 38210002, 1}]}, {2,[{1, 0, 688}]}];


get_cfg(guild_mail_title) ->
"来自会长的邮件";


get_cfg(guild_dun_open_lv) ->
1;


get_cfg(dun_score_reward_need) ->
10;


get_cfg(donate_total_times) ->
10;


get_cfg(depot_exp_goods_id) ->
38250022;


get_cfg(guild_dun_role_lv) ->
140;


get_cfg(prestige_limit_goods) ->
[37070001];


get_cfg(title_degrade_val) ->
1000;


get_cfg(prestige_day_max) ->
[{3,2500},{5,2650},{4,2800},{2,2900},{1,3000}];


get_cfg(day_assist_count) ->
5;


get_cfg(day_assist_extra_reward) ->
[{0,32010455,1}];


get_cfg(guild_assist_lv) ->
130;


get_cfg(rename_interval) ->
86400;


get_cfg(guild_assist_open_day) ->
1;


get_cfg(guild_merge_open_day) ->
5;


get_cfg(guild_merge_auto_agree) ->
86400;


get_cfg(guild_merge_login_day) ->
3;


get_cfg(guild_depot_excg_task_id) ->
201080;

get_cfg(_Key) ->
	false.

get_donate_by_type(1) ->
	#base_guild_donate{donate_type = 1,donate_cost = [{3,0,1000}],donate_reward = [{8,0,100},{4,0,100},{21,0,10}],donate_times = 10};

get_donate_by_type(2) ->
	#base_guild_donate{donate_type = 2,donate_cost = [{2,0,100}],donate_reward = [{8,0,500},{4,0,500},{21,0,20}],donate_times = 10};

get_donate_by_type(3) ->
	#base_guild_donate{donate_type = 3,donate_cost = [{1,0,100}],donate_reward = [{8,0,1000},{4,0,1000},{21,0,100}],donate_times = 10};

get_donate_by_type(_Donatetype) ->
	[].

get_donate_type_list() ->
[1,2,3].

get_activity_gift(1) ->
	#base_guild_activity_gift{id = 1,activity = 600,reward = [{3,0,10000},{0,38040002,10}]};

get_activity_gift(2) ->
	#base_guild_activity_gift{id = 2,activity = 1000,reward = [{0,32010001,2},{3,0,20000},{0,38040002,20}]};

get_activity_gift(3) ->
	#base_guild_activity_gift{id = 3,activity = 1500,reward = [{0,32010001,3},{3,0,30000},{0,38040002,30}]};

get_activity_gift(4) ->
	#base_guild_activity_gift{id = 4,activity = 2200,reward = [{0,32010001,4},{3,0,40000},{0,38040002,40}]};

get_activity_gift(5) ->
	#base_guild_activity_gift{id = 5,activity = 3000,reward = [{0,32010001,5},{3,0,70000},{0,38040002,50}]};

get_activity_gift(_Id) ->
	[].

get_activity_gift_id_list() ->
[1,2,3,4,5].


get_welcome_string(1) ->
"{1}，初次见面，请多指教！结社每晚8点都有活动可以参加哦~";


get_welcome_string(2) ->
"欢迎{1}加入结社，以后都是一家人了~";


get_welcome_string(3) ->
"{1}，缺对象吗？让会长给你发一个！";


get_welcome_string(4) ->
"欢迎{1}，结社仓库中有很多装备可以兑换，看看有需要的吗？";


get_welcome_string(5) ->
"{1}，加入结社福利多，积极协助其他成员还能提升结社头衔，让每日礼包的奖励更丰富！";


get_welcome_string(6) ->
"{1}，记得关注结社红包，手快有，手慢无噢！";


get_welcome_string(7) ->
"领取结社每日礼包，结社因我更强大~<color@3><a@open_fun@50>我也要领</a></color>";

get_welcome_string(_Id) ->
	"".


get_welcome_ids(1) ->
[1,2,3,4,5,6];


get_welcome_ids(2) ->
[7];

get_welcome_ids(_Type) ->
	[].

get_prestige_list() ->
[{11,450000},{10,325000},{9,225000},{8,150000},{7,100000},{6,62500},{5,37500},{4,20000},{3,12500},{2,5000},{1,0}].


get_title_name(1) ->
"萌新";


get_title_name(2) ->
"小善";


get_title_name(3) ->
"乐助";


get_title_name(4) ->
"暖心";


get_title_name(5) ->
"鼎力";


get_title_name(6) ->
"热忱";


get_title_name(7) ->
"勤勉";


get_title_name(8) ->
"无私";


get_title_name(9) ->
"慈悲";


get_title_name(10) ->
"普度";


get_title_name(11) ->
"忘我";

get_title_name(_Titleid) ->
	[].


get_title_reward(1) ->
[{0,37080001,200},{0,38040091,5}];


get_title_reward(2) ->
[{0,37080001,300},{0,38040091,8}];


get_title_reward(3) ->
[{0,37080001,350},{0,38040091,10}];


get_title_reward(4) ->
[{0,37080001,400},{0,38040091,12}];


get_title_reward(5) ->
[{0,37080001,450},{0,38040091,14}];


get_title_reward(6) ->
[{0,37080001,500},{0,38040091,15}];


get_title_reward(7) ->
[{0,37080001,550},{0,38040091,16}];


get_title_reward(8) ->
[{0,37080001,600},{0,38040091,17}];


get_title_reward(9) ->
[{0,37080001,650},{0,38040091,18}];


get_title_reward(10) ->
[{0,37080001,700},{0,38040091,19}];


get_title_reward(11) ->
[{0,37080001,800},{0,38040091,20}];

get_title_reward(_Titleid) ->
	[].

