%%%---------------------------------------
%%% module      : data_pushmail
%%% description : 邮件推送配置
%%%
%%%---------------------------------------
-module(data_pushmail).
-compile(export_all).
-include("pushmail.hrl").



get_pushmail_config(1) ->
	#base_pushmail{id = 1,time = [],open_day = 0,merge_day = 0,lv = 95,career = [],sex = [],dun = 0,other = [],title = "【境界】系统开启",msg = "尊敬的阴阳师，境界系统开启了，提升战力，收集足够的晋升卷轴即可快速提升境界等级哦，提升后更可获得大量战力提升！<color@1><a@open_fun@12>前往查看</a></color>",accessory = [{2,0,10}],about = "境界"};

get_pushmail_config(3) ->
	#base_pushmail{id = 3,time = [],open_day = 0,merge_day = 0,lv = 240,career = [],sex = [],dun = 0,other = [],title = "【共鸣】功能开启",msg = "尊敬的阴阳师，共鸣功能系统开启了！收集足够共鸣资源打造共鸣即可获得套装特效和大量属性战力提升！<color@1><a@open_fun@24>前往查看</a></color>",accessory = [{2,0,10}],about = "共鸣"};

get_pushmail_config(4) ->
	#base_pushmail{id = 4,time = [],open_day = 1,merge_day = 0,lv = 130,career = [],sex = [],dun = 0,other = [],title = "【托管】活动开启",msg = "尊敬的阴阳师，【托管】功能开启了，为了避免您因为繁忙而遗漏活动，您可以前往日常页面的托管中心对活动进行托管，达到以逸待劳的作用哦~<color@1><a@open_fun@199>前往查看</a></color>",accessory = [{2,0,10}],about = "托管"};

get_pushmail_config(5) ->
	#base_pushmail{id = 5,time = [],open_day = 50,merge_day = 0,lv = 520,career = [],sex = [],dun = 0,other = [],title = "【神炼】功能开启",msg = "尊敬的阴阳师，神炼系统开启了，提升战力，收集足够的神炼石材料提升装备神炼等级，提升后更可获得大量战力提升！<color@1><a@open_fun@224>前往查看</a></color>",accessory = [{2,0,10}],about = "神炼"};

get_pushmail_config(_Id) ->
	#base_pushmail{}.

get_id_list() ->
[1,3,4,5].

