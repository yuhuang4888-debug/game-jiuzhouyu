%%%---------------------------------------
%%% module      : data_supreme_vip
%%% description : 至尊vip配置
%%%
%%%---------------------------------------
-module(data_supreme_vip).
-compile(export_all).
-include("supreme_vip.hrl").




get_kv(1) ->
[{1,0,199}];


get_kv(2) ->
259200;


get_kv(3) ->
[{1,0,999}];


get_kv(4) ->
{100,7};


get_kv(5) ->
150;


get_kv(6) ->
4;


get_kv(7) ->
1;


get_kv(8) ->
[7304401,7304402,7304403,7304404,7304405,7304406,7304407];

get_kv(_Key) ->
	[].

get_supreme_vip(1,1) ->
	#base_supreme_vip{supvip_type = 1,right_type = 1,name = "至尊标识",desc = "",value = 0,args = []};

get_supreme_vip(1,2) ->
	#base_supreme_vip{supvip_type = 1,right_type = 2,name = "蛮荒怒气上限up",desc = "",value = 10,args = []};

get_supreme_vip(1,3) ->
	#base_supreme_vip{supvip_type = 1,right_type = 3,name = "Boss安全时间",desc = "秒",value = 600,args = []};

get_supreme_vip(1,4) ->
	#base_supreme_vip{supvip_type = 1,right_type = 4,name = "合成概率up",desc = "万分比",value = 500,args = []};

get_supreme_vip(1,5) ->
	#base_supreme_vip{supvip_type = 1,right_type = 5,name = "掉率up",desc = "掉落包数量增加",value = 2000,args = [340010101,340010201,340010301,340010401,340010501,340020101,340020201,340020301,340020401,340020501,340030101,340030201,340030301,340030401,340030501,340030601,340040101,340040201,340040301,340040401,340040501,340040601,340050101,340050201,340050301,340050401,340050501,340050601,340060101,340060201,340060301,340060401,340060501,340060601,340070101,340070201,340070301,340070401,340070501,340070601,222000101,222000201,222000301,222000401,222000501,222000601,222000701,222010101,222010201,222010301,222010401,222010501,222010601,222010701,222020101,222020201,222020301,222020401,222020501,222020601,222030101,222030201,222030301,222030401,222030501,222030601,222040101,222040201,222040301,222040401,222040501,222040601,222040701,222050101,222050201,222050301,222050401,222050501,222060101,222060201,222060301,222060401,222060501,222060601,230010101,230010201,230010301,230010401,230010501,230010601,230010701,230010801,230020101,230020201,230020301,230020401,230020501,230020601,230020701,230020801,230030101,230030201,230030301,230030401,230030501,230030601,230030701,230030801,230040101,230040201,230040301,230040401,230040501,230040601,230040701,230040801,1000401,1000501,1000601,1000701,1000801,1000901,1001001,1001101,1001201,1001301,1001401,1001501,1001601]};

get_supreme_vip(1,6) ->
	#base_supreme_vip{supvip_type = 1,right_type = 6,name = "开启至尊商店",desc = "",value = 0,args = []};

get_supreme_vip(2,1) ->
	#base_supreme_vip{supvip_type = 2,right_type = 1,name = "至尊标识",desc = "",value = 0,args = []};

get_supreme_vip(2,2) ->
	#base_supreme_vip{supvip_type = 2,right_type = 2,name = "蛮荒怒气上限up",desc = "",value = 10,args = []};

get_supreme_vip(2,3) ->
	#base_supreme_vip{supvip_type = 2,right_type = 3,name = "Boss安全时间",desc = "秒",value = 600,args = []};

get_supreme_vip(2,4) ->
	#base_supreme_vip{supvip_type = 2,right_type = 4,name = "合成概率up",desc = "万分比",value = 500,args = []};

get_supreme_vip(2,5) ->
	#base_supreme_vip{supvip_type = 2,right_type = 5,name = "掉率up",desc = "掉落包数量增加",value = 2000,args = [340010101,340010201,340010301,340010401,340010501,340020101,340020201,340020301,340020401,340020501,340030101,340030201,340030301,340030401,340030501,340030601,340040101,340040201,340040301,340040401,340040501,340040601,340050101,340050201,340050301,340050401,340050501,340050601,340060101,340060201,340060301,340060401,340060501,340060601,340070101,340070201,340070301,340070401,340070501,340070601,222000101,222000201,222000301,222000401,222000501,222000601,222000701,222010101,222010201,222010301,222010401,222010501,222010601,222010701,222020101,222020201,222020301,222020401,222020501,222020601,222030101,222030201,222030301,222030401,222030501,222030601,222040101,222040201,222040301,222040401,222040501,222040601,222040701,222050101,222050201,222050301,222050401,222050501,222060101,222060201,222060301,222060401,222060501,222060601,230010101,230010201,230010301,230010401,230010501,230010601,230010701,230010801,230020101,230020201,230020301,230020401,230020501,230020601,230020701,230020801,230030101,230030201,230030301,230030401,230030501,230030601,230030701,230030801,230040101,230040201,230040301,230040401,230040501,230040601,230040701,230040801,1000401,1000501,1000601,1000701,1000801,1000901,1001001,1001101,1001201,1001301,1001401,1001501,1001601]};

get_supreme_vip(2,6) ->
	#base_supreme_vip{supvip_type = 2,right_type = 6,name = "开启至尊商店",desc = "",value = 0,args = []};

get_supreme_vip(2,7) ->
	#base_supreme_vip{supvip_type = 2,right_type = 7,name = "个人boss次数上限",desc = "",value = 1,args = []};

get_supreme_vip(2,8) ->
	#base_supreme_vip{supvip_type = 2,right_type = 8,name = "日常礼包",desc = "奖励列表",value = 0,args = [{0,35,10},{255,36255042,30},{0,36255031,10},{0,38030001,1},{0,37020001,1}]};

get_supreme_vip(_Supviptype,_Righttype) ->
	[].


get_supvip_right_type_list(1) ->
[1,2,3,4,5,6];


get_supvip_right_type_list(2) ->
[1,2,3,4,5,6,7,8];

get_supvip_right_type_list(_Supviptype) ->
	[].

get_supreme_vip_skill(0,1) ->
	#base_supreme_vip_skill{stage = 0,sub_stage = 1,attr = [{1,100},{2,2000},{3,50},{4,50}],skill_list = []};

get_supreme_vip_skill(0,2) ->
	#base_supreme_vip_skill{stage = 0,sub_stage = 2,attr = [{1,100},{2,2000},{3,50},{4,50}],skill_list = []};

get_supreme_vip_skill(0,3) ->
	#base_supreme_vip_skill{stage = 0,sub_stage = 3,attr = [{1,100},{2,2000},{3,50},{4,50}],skill_list = []};

get_supreme_vip_skill(0,4) ->
	#base_supreme_vip_skill{stage = 0,sub_stage = 4,attr = [{1,100},{2,2000},{3,50},{4,50}],skill_list = []};

get_supreme_vip_skill(0,5) ->
	#base_supreme_vip_skill{stage = 0,sub_stage = 5,attr = [{1,100},{2,2000},{3,50},{4,50}],skill_list = []};

get_supreme_vip_skill(0,6) ->
	#base_supreme_vip_skill{stage = 0,sub_stage = 6,attr = [{1,100},{2,2000},{3,50},{4,50}],skill_list = []};

get_supreme_vip_skill(0,7) ->
	#base_supreme_vip_skill{stage = 0,sub_stage = 7,attr = [{1,100},{2,2000},{3,50},{4,50}],skill_list = []};

get_supreme_vip_skill(0,8) ->
	#base_supreme_vip_skill{stage = 0,sub_stage = 8,attr = [{1,100},{2,2000},{3,50},{4,50}],skill_list = [{4301001,1}]};

get_supreme_vip_skill(1,1) ->
	#base_supreme_vip_skill{stage = 1,sub_stage = 1,attr = [{1,130},{2,2600},{3,65},{4,65}],skill_list = []};

get_supreme_vip_skill(1,2) ->
	#base_supreme_vip_skill{stage = 1,sub_stage = 2,attr = [{1,130},{2,2600},{3,65},{4,65}],skill_list = []};

get_supreme_vip_skill(1,3) ->
	#base_supreme_vip_skill{stage = 1,sub_stage = 3,attr = [{1,130},{2,2600},{3,65},{4,65}],skill_list = []};

get_supreme_vip_skill(1,4) ->
	#base_supreme_vip_skill{stage = 1,sub_stage = 4,attr = [{1,130},{2,2600},{3,65},{4,65}],skill_list = []};

get_supreme_vip_skill(1,5) ->
	#base_supreme_vip_skill{stage = 1,sub_stage = 5,attr = [{1,130},{2,2600},{3,65},{4,65}],skill_list = []};

get_supreme_vip_skill(1,6) ->
	#base_supreme_vip_skill{stage = 1,sub_stage = 6,attr = [{1,130},{2,2600},{3,65},{4,65}],skill_list = []};

get_supreme_vip_skill(1,7) ->
	#base_supreme_vip_skill{stage = 1,sub_stage = 7,attr = [{1,130},{2,2600},{3,65},{4,65}],skill_list = []};

get_supreme_vip_skill(1,8) ->
	#base_supreme_vip_skill{stage = 1,sub_stage = 8,attr = [{1,130},{2,2600},{3,65},{4,65}],skill_list = [{4301002,1}]};

get_supreme_vip_skill(2,1) ->
	#base_supreme_vip_skill{stage = 2,sub_stage = 1,attr = [{1,160},{2,3200},{3,80},{4,80}],skill_list = []};

get_supreme_vip_skill(2,2) ->
	#base_supreme_vip_skill{stage = 2,sub_stage = 2,attr = [{1,160},{2,3200},{3,80},{4,80}],skill_list = []};

get_supreme_vip_skill(2,3) ->
	#base_supreme_vip_skill{stage = 2,sub_stage = 3,attr = [{1,160},{2,3200},{3,80},{4,80}],skill_list = []};

get_supreme_vip_skill(2,4) ->
	#base_supreme_vip_skill{stage = 2,sub_stage = 4,attr = [{1,160},{2,3200},{3,80},{4,80}],skill_list = []};

get_supreme_vip_skill(2,5) ->
	#base_supreme_vip_skill{stage = 2,sub_stage = 5,attr = [{1,160},{2,3200},{3,80},{4,80}],skill_list = []};

get_supreme_vip_skill(2,6) ->
	#base_supreme_vip_skill{stage = 2,sub_stage = 6,attr = [{1,160},{2,3200},{3,80},{4,80}],skill_list = []};

get_supreme_vip_skill(2,7) ->
	#base_supreme_vip_skill{stage = 2,sub_stage = 7,attr = [{1,160},{2,3200},{3,80},{4,80}],skill_list = []};

get_supreme_vip_skill(2,8) ->
	#base_supreme_vip_skill{stage = 2,sub_stage = 8,attr = [{1,160},{2,3200},{3,80},{4,80}],skill_list = [{4301003,1}]};

get_supreme_vip_skill(3,1) ->
	#base_supreme_vip_skill{stage = 3,sub_stage = 1,attr = [{1,190},{2,3800},{3,95},{4,95}],skill_list = []};

get_supreme_vip_skill(3,2) ->
	#base_supreme_vip_skill{stage = 3,sub_stage = 2,attr = [{1,190},{2,3800},{3,95},{4,95}],skill_list = []};

get_supreme_vip_skill(3,3) ->
	#base_supreme_vip_skill{stage = 3,sub_stage = 3,attr = [{1,190},{2,3800},{3,95},{4,95}],skill_list = []};

get_supreme_vip_skill(3,4) ->
	#base_supreme_vip_skill{stage = 3,sub_stage = 4,attr = [{1,190},{2,3800},{3,95},{4,95}],skill_list = []};

get_supreme_vip_skill(3,5) ->
	#base_supreme_vip_skill{stage = 3,sub_stage = 5,attr = [{1,190},{2,3800},{3,95},{4,95}],skill_list = []};

get_supreme_vip_skill(3,6) ->
	#base_supreme_vip_skill{stage = 3,sub_stage = 6,attr = [{1,190},{2,3800},{3,95},{4,95}],skill_list = []};

get_supreme_vip_skill(3,7) ->
	#base_supreme_vip_skill{stage = 3,sub_stage = 7,attr = [{1,190},{2,3800},{3,95},{4,95}],skill_list = []};

get_supreme_vip_skill(3,8) ->
	#base_supreme_vip_skill{stage = 3,sub_stage = 8,attr = [{1,190},{2,3800},{3,95},{4,95}],skill_list = [{4301004,1}]};

get_supreme_vip_skill(4,1) ->
	#base_supreme_vip_skill{stage = 4,sub_stage = 1,attr = [{1,220},{2,4400},{3,110},{4,110}],skill_list = []};

get_supreme_vip_skill(4,2) ->
	#base_supreme_vip_skill{stage = 4,sub_stage = 2,attr = [{1,220},{2,4400},{3,110},{4,110}],skill_list = []};

get_supreme_vip_skill(4,3) ->
	#base_supreme_vip_skill{stage = 4,sub_stage = 3,attr = [{1,220},{2,4400},{3,110},{4,110}],skill_list = []};

get_supreme_vip_skill(4,4) ->
	#base_supreme_vip_skill{stage = 4,sub_stage = 4,attr = [{1,220},{2,4400},{3,110},{4,110}],skill_list = []};

get_supreme_vip_skill(4,5) ->
	#base_supreme_vip_skill{stage = 4,sub_stage = 5,attr = [{1,220},{2,4400},{3,110},{4,110}],skill_list = []};

get_supreme_vip_skill(4,6) ->
	#base_supreme_vip_skill{stage = 4,sub_stage = 6,attr = [{1,220},{2,4400},{3,110},{4,110}],skill_list = []};

get_supreme_vip_skill(4,7) ->
	#base_supreme_vip_skill{stage = 4,sub_stage = 7,attr = [{1,220},{2,4400},{3,110},{4,110}],skill_list = []};

get_supreme_vip_skill(4,8) ->
	#base_supreme_vip_skill{stage = 4,sub_stage = 8,attr = [{1,220},{2,4400},{3,110},{4,110}],skill_list = [{4301005,1}]};

get_supreme_vip_skill(5,1) ->
	#base_supreme_vip_skill{stage = 5,sub_stage = 1,attr = [{1,250},{2,5000},{3,125},{4,125}],skill_list = []};

get_supreme_vip_skill(5,2) ->
	#base_supreme_vip_skill{stage = 5,sub_stage = 2,attr = [{1,250},{2,5000},{3,125},{4,125}],skill_list = []};

get_supreme_vip_skill(5,3) ->
	#base_supreme_vip_skill{stage = 5,sub_stage = 3,attr = [{1,250},{2,5000},{3,125},{4,125}],skill_list = []};

get_supreme_vip_skill(5,4) ->
	#base_supreme_vip_skill{stage = 5,sub_stage = 4,attr = [{1,250},{2,5000},{3,125},{4,125}],skill_list = []};

get_supreme_vip_skill(5,5) ->
	#base_supreme_vip_skill{stage = 5,sub_stage = 5,attr = [{1,250},{2,5000},{3,125},{4,125}],skill_list = []};

get_supreme_vip_skill(5,6) ->
	#base_supreme_vip_skill{stage = 5,sub_stage = 6,attr = [{1,250},{2,5000},{3,125},{4,125}],skill_list = []};

get_supreme_vip_skill(5,7) ->
	#base_supreme_vip_skill{stage = 5,sub_stage = 7,attr = [{1,250},{2,5000},{3,125},{4,125}],skill_list = []};

get_supreme_vip_skill(5,8) ->
	#base_supreme_vip_skill{stage = 5,sub_stage = 8,attr = [{1,250},{2,5000},{3,125},{4,125}],skill_list = [{4301006,1}]};

get_supreme_vip_skill(_Stage,_Substage) ->
	[].

get_supvip_skill_stage_list() ->
[0,1,2,3,4,5].

get_supvip_skill_key_list() ->
[{0,1},{0,2},{0,3},{0,4},{0,5},{0,6},{0,7},{0,8},{1,1},{1,2},{1,3},{1,4},{1,5},{1,6},{1,7},{1,8},{2,1},{2,2},{2,3},{2,4},{2,5},{2,6},{2,7},{2,8},{3,1},{3,2},{3,3},{3,4},{3,5},{3,6},{3,7},{3,8},{4,1},{4,2},{4,3},{4,4},{4,5},{4,6},{4,7},{4,8},{5,1},{5,2},{5,3},{5,4},{5,5},{5,6},{5,7},{5,8}].


get_supvip_skill_sub_stage_list(0) ->
[1,2,3,4,5,6,7,8];


get_supvip_skill_sub_stage_list(1) ->
[1,2,3,4,5,6,7,8];


get_supvip_skill_sub_stage_list(2) ->
[1,2,3,4,5,6,7,8];


get_supvip_skill_sub_stage_list(3) ->
[1,2,3,4,5,6,7,8];


get_supvip_skill_sub_stage_list(4) ->
[1,2,3,4,5,6,7,8];


get_supvip_skill_sub_stage_list(5) ->
[1,2,3,4,5,6,7,8];

get_supvip_skill_sub_stage_list(_Stage) ->
	[].

get_supreme_vip_skill_effect(4301001) ->
	#base_supreme_vip_skill_effect{skill_id = 4301001,effect_list = [{1,3}]};

get_supreme_vip_skill_effect(_Skillid) ->
	[].

get_supreme_vip_skill_task(0,1001) ->
	#base_supreme_vip_skill_task{stage = 0,task_id = 1001,name = "坐骑升阶至<font color='#00fa64'>4阶</font>",content = [{2,4,1}],reward = [{0,16020002,1}]};

get_supreme_vip_skill_task(0,1002) ->
	#base_supreme_vip_skill_task{stage = 0,task_id = 1002,name = "激活<font color='#00fa64'>乐神音姬</font>神巫",content = [{27,2}],reward = [{0,22020001,30}]};

get_supreme_vip_skill_task(0,1003) ->
	#base_supreme_vip_skill_task{stage = 0,task_id = 1003,name = "境界提升至<font color='#00fa64'>部将</font>",content = [{5,21}],reward = [{0,38040044,1}]};

get_supreme_vip_skill_task(0,1004) ->
	#base_supreme_vip_skill_task{stage = 0,task_id = 1004,name = "装备强化总和达<font color='#00fa64'>300级</font>",content = [{32,300}],reward = [{0,32010097,1}]};

get_supreme_vip_skill_task(0,1005) ->
	#base_supreme_vip_skill_task{stage = 0,task_id = 1005,name = "完成<font color='#00fa64'>5次</font>恶灵退治",content = [{4,5,20}],reward = [{0,37020002,1}]};

get_supreme_vip_skill_task(0,1006) ->
	#base_supreme_vip_skill_task{stage = 0,task_id = 1006,name = "完成<font color='#00fa64'>二转</font>",content = [{7,2}],reward = [{0,35,50}]};

get_supreme_vip_skill_task(0,1007) ->
	#base_supreme_vip_skill_task{stage = 0,task_id = 1007,name = "击败<font color='#00fa64'>3次</font>265级及以上的世界大妖",content = [{8,3,265,12}],reward = [{0,32010115,1}]};

get_supreme_vip_skill_task(0,1008) ->
	#base_supreme_vip_skill_task{stage = 0,task_id = 1008,name = "充值任意金额累计<font color='#00fa64'>2天</font>",content = [{6,2}],reward = [{0,38250026,2}]};

get_supreme_vip_skill_task(1,2001) ->
	#base_supreme_vip_skill_task{stage = 1,task_id = 2001,name = "坐骑升阶至<font color='#00fa64'>5阶</font>",content = [{2,5,1}],reward = [{0,32010205,1}]};

get_supreme_vip_skill_task(1,2002) ->
	#base_supreme_vip_skill_task{stage = 1,task_id = 2002,name = "激活<font color='#00fa64'>桃神沫沫</font>神巫",content = [{27,3}],reward = [{0,22020001,50}]};

get_supreme_vip_skill_task(1,2003) ->
	#base_supreme_vip_skill_task{stage = 1,task_id = 2003,name = "境界提升至<font color='#00fa64'>护代</font>",content = [{5,41}],reward = [{0,38040044,2}]};

get_supreme_vip_skill_task(1,2004) ->
	#base_supreme_vip_skill_task{stage = 1,task_id = 2004,name = "神纹开启<font color='#00fa64'>5个</font>孔位",content = [{30,5}],reward = [{0,32010152,1}]};

get_supreme_vip_skill_task(1,2005) ->
	#base_supreme_vip_skill_task{stage = 1,task_id = 2005,name = "成就等级达到<font color='#00fa64'>50级</font>",content = [{11,50}],reward = [{0,38250026,2}]};

get_supreme_vip_skill_task(1,2006) ->
	#base_supreme_vip_skill_task{stage = 1,task_id = 2006,name = "完成<font color='#00fa64'>三转</font>",content = [{7,3}],reward = [{0,35,50}]};

get_supreme_vip_skill_task(1,2007) ->
	#base_supreme_vip_skill_task{stage = 1,task_id = 2007,name = "击败<font color='#00fa64'>5次</font>295级及以上的世界大妖",content = [{8,5,295,12}],reward = [{0,38160001,1}]};

get_supreme_vip_skill_task(1,2008) ->
	#base_supreme_vip_skill_task{stage = 1,task_id = 2008,name = "充值任意金额累计<font color='#00fa64'>5天</font>",content = [{6,5}],reward = [{0,38250026,2}]};

get_supreme_vip_skill_task(2,3001) ->
	#base_supreme_vip_skill_task{stage = 2,task_id = 3001,name = "激活任意<font color='#00fa64'>2个</font>坐骑幻化",content = [{12, 2, 1}],reward = [{0,32010206,1}]};

get_supreme_vip_skill_task(2,3002) ->
	#base_supreme_vip_skill_task{stage = 2,task_id = 3002,name = "装备<font color='#00fa64'>2个</font>红色<font color='#00fa64'>超然</font>神纹",content = [{13,2,5,3}],reward = [{0,38040030,5}]};

get_supreme_vip_skill_task(2,3003) ->
	#base_supreme_vip_skill_task{stage = 2,task_id = 3003,name = "境界提升至<font color='#00fa64'>正心</font>",content = [{5,81}],reward = [{0,38040044,3}]};

get_supreme_vip_skill_task(2,3004) ->
	#base_supreme_vip_skill_task{stage = 2,task_id = 3004,name = "宝宝养育等级达到<font color='#00fa64'>50级</font>",content = [{14,50}],reward = [{0,38040042,2}]};

get_supreme_vip_skill_task(2,3005) ->
	#base_supreme_vip_skill_task{stage = 2,task_id = 3005,name = "将<font color='#00fa64'>4件</font>装备神装打造至<font color='#00fa64'>2级</font>",content = [{15,4,2}],reward = [{0,34010041,2}]};

get_supreme_vip_skill_task(2,3006) ->
	#base_supreme_vip_skill_task{stage = 2,task_id = 3006,name = "完成<font color='#00fa64'>四转</font>",content = [{7,4}],reward = [{0,35,50}]};

get_supreme_vip_skill_task(2,3007) ->
	#base_supreme_vip_skill_task{stage = 2,task_id = 3007,name = "蜃气楼中击杀<font color='#00fa64'>5个</font>390级及以上的蜃妖",content = [{8,5,390,10}],reward = [{0,32010316,1}]};

get_supreme_vip_skill_task(2,3008) ->
	#base_supreme_vip_skill_task{stage = 2,task_id = 3008,name = "累计登录<font color='#00fa64'>15天</font>",content = [{25,15}],reward = [{0,38250026,2}]};

get_supreme_vip_skill_task(3,4001) ->
	#base_supreme_vip_skill_task{stage = 3,task_id = 4001,name = "境界提升至<font color='#00fa64'>阴忍</font>",content = [{5,101}],reward = [{0,38040044,5}]};

get_supreme_vip_skill_task(3,4002) ->
	#base_supreme_vip_skill_task{stage = 3,task_id = 4002,name = "激活任意<font color='#00fa64'>2个</font>宝宝幻化",content = [{19,2}],reward = [{0,38040041,5}]};

get_supreme_vip_skill_task(3,4003) ->
	#base_supreme_vip_skill_task{stage = 3,task_id = 4003,name = "任意灵饰提升至<font color='#00fa64'>6阶</font>",content = [{17,6}],reward = [{0,38040019,1}]};

get_supreme_vip_skill_task(3,4004) ->
	#base_supreme_vip_skill_task{stage = 3,task_id = 4004,name = "成就等级达到<font color='#00fa64'>80级</font>",content = [{11,80}],reward = [{0,38040042,2}]};

get_supreme_vip_skill_task(3,4005) ->
	#base_supreme_vip_skill_task{stage = 3,task_id = 4005,name = "激活任意<font color='#00fa64'>3个</font>降神",content = [{16,3}],reward = [{0,7110002,2}]};

get_supreme_vip_skill_task(3,4006) ->
	#base_supreme_vip_skill_task{stage = 3,task_id = 4006,name = "购买任意档位<font color='#00fa64'>巅峰投资</font>",content = [{18,5}],reward = [{0,35,50}]};

get_supreme_vip_skill_task(3,4007) ->
	#base_supreme_vip_skill_task{stage = 3,task_id = 4007,name = "击杀任意<font color='#00fa64'>6个</font>秘境大妖",content = [{8,6,1,20}],reward = [{0,38030005,1}]};

get_supreme_vip_skill_task(3,4008) ->
	#base_supreme_vip_skill_task{stage = 3,task_id = 4008,name = "累计登录<font color='#00fa64'>30天</font>",content = [{25,30}],reward = [{0,38250026,2}]};

get_supreme_vip_skill_task(4,5001) ->
	#base_supreme_vip_skill_task{stage = 4,task_id = 5001,name = "境界提升至<font color='#00fa64'>绯色</font>",content = [{5,121}],reward = [{0,38040044,8}]};

get_supreme_vip_skill_task(4,5002) ->
	#base_supreme_vip_skill_task{stage = 4,task_id = 5002,name = "激活任意天启<font color='#00fa64'>3件套属性</font>",content = [{21,3}],reward = [{0,34010080,2}]};

get_supreme_vip_skill_task(4,5003) ->
	#base_supreme_vip_skill_task{stage = 4,task_id = 5003,name = "完成<font color='#00fa64'>五转</font>",content = [{7,5}],reward = [{0,35,50}]};

get_supreme_vip_skill_task(4,5004) ->
	#base_supreme_vip_skill_task{stage = 4,task_id = 5004,name = "合成<font color='#00fa64'>1件</font>粉装",content = [{29,1}],reward = [{0,34010041,2}]};

get_supreme_vip_skill_task(4,5005) ->
	#base_supreme_vip_skill_task{stage = 4,task_id = 5005,name = "参与<font color='#00fa64'>3次</font>天启之源",content = [{26,3}],reward = [{0,35,50}]};

get_supreme_vip_skill_task(4,5006) ->
	#base_supreme_vip_skill_task{stage = 4,task_id = 5006,name = "购买任意档位<font color='#00fa64'>至尊投资</font>",content = [{18,7}],reward = [{0,35,50}]};

get_supreme_vip_skill_task(4,5007) ->
	#base_supreme_vip_skill_task{stage = 4,task_id = 5007,name = "充值任意金额累计<font color='#00fa64'>15天</font>",content = [{6,15}],reward = [{0,38250026,2}]};

get_supreme_vip_skill_task(4,5008) ->
	#base_supreme_vip_skill_task{stage = 4,task_id = 5008,name = "累计登录<font color='#00fa64'>50天</font>",content = [{25,50}],reward = [{0,38040001,5}]};

get_supreme_vip_skill_task(5,6001) ->
	#base_supreme_vip_skill_task{stage = 5,task_id = 6001,name = "境界提升至<font color='#00fa64'>天时</font>",content = [{5,131}],reward = [{0,38040044,10}]};

get_supreme_vip_skill_task(5,6002) ->
	#base_supreme_vip_skill_task{stage = 5,task_id = 6002,name = "激活任意<font color='#00fa64'>3个</font>妖灵",content = [{23,3}],reward = [{0,7301005,2}]};

get_supreme_vip_skill_task(5,6003) ->
	#base_supreme_vip_skill_task{stage = 5,task_id = 6003,name = "激活<font color='#00fa64'>全套智·天启</font>",content = [{22,10,0}],reward = [{0,34010080,2}]};

get_supreme_vip_skill_task(5,6004) ->
	#base_supreme_vip_skill_task{stage = 5,task_id = 6004,name = "获得<font color='#00fa64'>3本S级</font>妖灵天赋书",content = [{31,3}],reward = [{0,7301004,2}]};

get_supreme_vip_skill_task(5,6005) ->
	#base_supreme_vip_skill_task{stage = 5,task_id = 6005,name = "合成<font color='#00fa64'>3件</font>粉装",content = [{29,3}],reward = [{0,34010041,4}]};

get_supreme_vip_skill_task(5,6006) ->
	#base_supreme_vip_skill_task{stage = 5,task_id = 6006,name = "激活<font color='#00fa64'>6个</font>神巫",content = [{28,6}],reward = [{0,35,50}]};

get_supreme_vip_skill_task(5,6007) ->
	#base_supreme_vip_skill_task{stage = 5,task_id = 6007,name = "通关御魂塔<font color='#00fa64'>第120层</font>",content = [{3,120}],reward = [{0,32010114,5}]};

get_supreme_vip_skill_task(5,6008) ->
	#base_supreme_vip_skill_task{stage = 5,task_id = 6008,name = "累计登录<font color='#00fa64'>75天</font>",content = [{25,75}],reward = [{0,38040001,5}]};

get_supreme_vip_skill_task(_Stage,_Taskid) ->
	[].


get_supvip_skill_task_id_list(0) ->
[1001,1002,1003,1004,1005,1006,1007,1008];


get_supvip_skill_task_id_list(1) ->
[2001,2002,2003,2004,2005,2006,2007,2008];


get_supvip_skill_task_id_list(2) ->
[3001,3002,3003,3004,3005,3006,3007,3008];


get_supvip_skill_task_id_list(3) ->
[4001,4002,4003,4004,4005,4006,4007,4008];


get_supvip_skill_task_id_list(4) ->
[5001,5002,5003,5004,5005,5006,5007,5008];


get_supvip_skill_task_id_list(5) ->
[6001,6002,6003,6004,6005,6006,6007,6008];

get_supvip_skill_task_id_list(_Stage) ->
	[].

get_supreme_vip_currency_task(101) ->
	#base_supreme_vip_currency_task{task_id = 101,name = "消耗<font color='#00fa64'>150</font>勾玉",condition = [{lv,1,9999},{open_day,1,9999}],content = [{6,150}],reward = [{255,36255042,10},{255,36255042,10},{255,36255042,10},{255,36255042,10}]};

get_supreme_vip_currency_task(102) ->
	#base_supreme_vip_currency_task{task_id = 102,name = "充值<font color='#00fa64'>12</font>元",condition = [{lv,1,9999},{open_day,1,9999}],content = [{1,120}],reward = [{255,36255042,10},{255,36255042,10},{255,36255042,10},{255,36255042,10}]};

get_supreme_vip_currency_task(103) ->
	#base_supreme_vip_currency_task{task_id = 103,name = "购买<font color='#00fa64'>1次</font>恶灵退治",condition = [{lv,1,9999},{open_day,1,9999}],content = [{2,1,20}],reward = [{255,36255042,10},{255,36255042,10}]};

get_supreme_vip_currency_task(104) ->
	#base_supreme_vip_currency_task{task_id = 104,name = "扫荡<font color='#00fa64'>3次</font>驯兽之旅",condition = [{lv,1,9999},{open_day,1,9999}],content = [{8,3,42}],reward = [{255,36255042,10},{255,36255042,10},{255,36255042,10},{255,36255042,10}]};

get_supreme_vip_currency_task(105) ->
	#base_supreme_vip_currency_task{task_id = 105,name = "扫荡<font color='#00fa64'>3次</font>万物有灵",condition = [{lv,1,419},{open_day,1,9999}],content = [{8,3,18}],reward = [{255,36255042,10},{255,36255042,10},{255,36255042,10},{255,36255042,10}]};

get_supreme_vip_currency_task(106) ->
	#base_supreme_vip_currency_task{task_id = 106,name = "购买<font color='#00fa64'>1次</font>怨灵封印挑战次数",condition = [{lv,420,9999},{open_day,1,9999}],content = [{2,1,26}],reward = [{255,36255042,10},{255,36255042,10},{255,36255042,10},{255,36255042,10}]};

get_supreme_vip_currency_task(107) ->
	#base_supreme_vip_currency_task{task_id = 107,name = "扫荡<font color='#00fa64'>3次</font>神巫副本",condition = [{lv,1,9999},{open_day,1,9999}],content = [{8,3,37}],reward = [{255,36255042,10},{255,36255042,10},{255,36255042,10},{255,36255042,10}]};

get_supreme_vip_currency_task(108) ->
	#base_supreme_vip_currency_task{task_id = 108,name = "击败任意<font color='#00fa64'>3只</font>大妖之境中的大妖",condition = [{lv,1,349},{open_day,1,9999}],content = [{3,3,7}],reward = [{255,36255042,10},{255,36255042,10}]};

get_supreme_vip_currency_task(109) ->
	#base_supreme_vip_currency_task{task_id = 109,name = "击败任意<font color='#00fa64'>3只</font>蜃气楼大妖",condition = [{lv,350,9999},{open_day,1,9999}],content = [{3,3,10}],reward = [{255,36255042,10},{255,36255042,10}]};

get_supreme_vip_currency_task(110) ->
	#base_supreme_vip_currency_task{task_id = 110,name = "进入<font color='#00fa64'>1次</font>蛮荒大妖",condition = [{lv,240},{open_day,1,9999}],content = [{4,1,4}],reward = [{255,36255042,10},{255,36255042,10}]};

get_supreme_vip_currency_task(111) ->
	#base_supreme_vip_currency_task{task_id = 111,name = "进入<font color='#00fa64'>1次</font>专属大妖",condition = [{lv,1,419},{open_day,1,9999}],content = [{7,1,10}],reward = [{255,36255042,10},{255,36255042,10}]};

get_supreme_vip_currency_task(112) ->
	#base_supreme_vip_currency_task{task_id = 112,name = "参与璀璨之海<font color='#00fa64'>2次</font>",condition = [{lv,1,9999},{open_day,1,9999}],content = [{9,2}],reward = [{255,36255042,10},{255,36255042,10},{255,36255042,10},{255,36255042,10}]};

get_supreme_vip_currency_task(113) ->
	#base_supreme_vip_currency_task{task_id = 113,name = "进入<font color='#00fa64'>1次</font>秘境大妖",condition = [{lv,420,9999},{open_day,1,9999}],content = [{4,1,20}],reward = [{255,36255042,10},{255,36255042,10}]};

get_supreme_vip_currency_task(_Taskid) ->
	[].

get_supvip_currency_task_id_list() ->
[101,102,103,104,105,106,107,108,109,110,111,112,113].


get_replace_skill_id(4301004) ->
370003;


get_replace_skill_id(4301005) ->
300201;


get_replace_skill_id(4301006) ->
300202;

get_replace_skill_id(_Skillid) ->
	0.


get_back_skill_id(370003) ->
4301004;


get_back_skill_id(300201) ->
4301005;


get_back_skill_id(300202) ->
4301006;

get_back_skill_id(_Replaceskillid) ->
	0.

