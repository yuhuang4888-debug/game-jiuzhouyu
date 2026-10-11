%%%---------------------------------------
%%% module      : data_talisman
%%% description : 法宝配置
%%%
%%%---------------------------------------
-module(data_talisman).
-compile(export_all).
-include("talisman.hrl").



get_star_cfg(1,0) ->
	#talisman_star_cfg{id = 1,star = 0,cost = [{0,24030006,2}],combat = 28000,attr_plus = [{1,700},{2,14000},{3,700},{4,700},{22,100}],attr = [{1,700},{2,14000},{3,700},{4,700},{22,100}]};

get_star_cfg(1,1) ->
	#talisman_star_cfg{id = 1,star = 1,cost = [{0,24030006,4}],combat = 56000,attr_plus = [{1,700},{2,14000},{3,700},{4,700},{22,100}],attr = [{1,1400},{2,28000},{3,1400},{4,1400},{21,200}]};

get_star_cfg(1,2) ->
	#talisman_star_cfg{id = 1,star = 2,cost = [{0,24030006,8}],combat = 84000,attr_plus = [{1,700},{2,14000},{3,700},{4,700},{22,100}],attr = [{1,2100},{2,42000},{3,2100},{4,2100},{21,300}]};

get_star_cfg(1,3) ->
	#talisman_star_cfg{id = 1,star = 3,cost = [{0,24030006,12}],combat = 112000,attr_plus = [{1,700},{2,14000},{3,700},{4,700},{22,100}],attr = [{1,2800},{2,56000},{3,2800},{4,2800},{21,400}]};

get_star_cfg(1,4) ->
	#talisman_star_cfg{id = 1,star = 4,cost = [{0,24030006,16}],combat = 140000,attr_plus = [{1,700},{2,14000},{3,700},{4,700},{22,100}],attr = [{1,3500},{2,70000},{3,35000},{4,3500},{21,500}]};

get_star_cfg(1,5) ->
	#talisman_star_cfg{id = 1,star = 5,cost = [{0,24030006,32}],combat = 168000,attr_plus = [],attr = [{1,4200},{2,84000},{3,4200},{4,4200},{21,600}]};

get_star_cfg(2,0) ->
	#talisman_star_cfg{id = 2,star = 0,cost = [{0,24030001,2}],combat = 16000,attr_plus = [{1,800},{2,16000},{3,200},{4,200},{22,100}],attr = [{1,400},{2,8000},{3,400},{4,400},{21,100}]};

get_star_cfg(2,1) ->
	#talisman_star_cfg{id = 2,star = 1,cost = [{0,24030001,4}],combat = 32000,attr_plus = [{1,800},{2,16000},{3,200},{4,200},{22,100}],attr = [{1,1200},{2,24000},{3,600},{4,600},{21,200}]};

get_star_cfg(2,2) ->
	#talisman_star_cfg{id = 2,star = 2,cost = [{0,24030001,8}],combat = 48000,attr_plus = [{1,800},{2,16000},{3,200},{4,200},{22,100}],attr = [{1,2000},{2,40000},{3,800},{4,800},{21,300}]};

get_star_cfg(2,3) ->
	#talisman_star_cfg{id = 2,star = 3,cost = [{0,24030001,12}],combat = 64000,attr_plus = [{1,800},{2,16000},{3,200},{4,200},{22,100}],attr = [{1,2800},{2,56000},{3,1000},{4,1000},{21,400}]};

get_star_cfg(2,4) ->
	#talisman_star_cfg{id = 2,star = 4,cost = [{0,24030001,16}],combat = 80000,attr_plus = [{1,800},{2,16000},{3,200},{4,200},{22,100}],attr = [{1,3600},{2,72000},{3,1200},{4,1200},{21,500}]};

get_star_cfg(2,5) ->
	#talisman_star_cfg{id = 2,star = 5,cost = [{0,24030001,32}],combat = 96000,attr_plus = [],attr = [{1,4400},{2,88000},{3,1400},{4,1400},{21,600}]};

get_star_cfg(3,0) ->
	#talisman_star_cfg{id = 3,star = 0,cost = [{0,24030002,2}],combat = 20000,attr_plus = [{1,800},{2,16000},{3,200},{4,200},{22,100}],attr = [{1,800},{2,16000},{3,200},{4,200},{21,100}]};

get_star_cfg(3,1) ->
	#talisman_star_cfg{id = 3,star = 1,cost = [{0,24030002,4}],combat = 40000,attr_plus = [{1,800},{2,16000},{3,200},{4,200},{22,100}],attr = [{1,1600},{2,32000},{3,400},{4,400},{21,200}]};

get_star_cfg(3,2) ->
	#talisman_star_cfg{id = 3,star = 2,cost = [{0,24030002,8}],combat = 60000,attr_plus = [{1,800},{2,16000},{3,200},{4,200},{22,100}],attr = [{1,2400},{2,48000},{3,600},{4,600},{21,300}]};

get_star_cfg(3,3) ->
	#talisman_star_cfg{id = 3,star = 3,cost = [{0,24030002,12}],combat = 80000,attr_plus = [{1,800},{2,16000},{3,200},{4,200},{22,100}],attr = [{1,3200},{2,64000},{3,800},{4,800},{21,400}]};

get_star_cfg(3,4) ->
	#talisman_star_cfg{id = 3,star = 4,cost = [{0,24030002,16}],combat = 100000,attr_plus = [{1,800},{2,16000},{3,200},{4,200},{22,100}],attr = [{1,4000},{2,80000},{3,1000},{4,1000},{21,500}]};

get_star_cfg(3,5) ->
	#talisman_star_cfg{id = 3,star = 5,cost = [{0,24030002,32}],combat = 120000,attr_plus = [],attr = [{1,4800},{2,96000},{3,1200},{4,1200},{21,600}]};

get_star_cfg(4,0) ->
	#talisman_star_cfg{id = 4,star = 0,cost = [{0,24030003,2}],combat = 24000,attr_plus = [{1,600},{2,12000},{3,600},{4,600},{22,100}],attr = [{1,600},{2,12000},{3,600},{4,600},{21,100}]};

get_star_cfg(4,1) ->
	#talisman_star_cfg{id = 4,star = 1,cost = [{0,24030003,4}],combat = 48000,attr_plus = [{1,600},{2,12000},{3,600},{4,600},{22,100}],attr = [{1,1200},{2,24000},{3,1200},{4,1200},{21,200}]};

get_star_cfg(4,2) ->
	#talisman_star_cfg{id = 4,star = 2,cost = [{0,24030003,8}],combat = 72000,attr_plus = [{1,600},{2,12000},{3,600},{4,600},{22,100}],attr = [{1,1800},{2,36000},{3,1800},{4,1800},{21,300}]};

get_star_cfg(4,3) ->
	#talisman_star_cfg{id = 4,star = 3,cost = [{0,24030003,12}],combat = 96000,attr_plus = [{1,600},{2,12000},{3,600},{4,600},{22,100}],attr = [{1,2400},{2,48000},{3,2400},{4,2400},{21,400}]};

get_star_cfg(4,4) ->
	#talisman_star_cfg{id = 4,star = 4,cost = [{0,24030003,16}],combat = 120000,attr_plus = [{1,600},{2,12000},{3,600},{4,600},{22,100}],attr = [{1,3000},{2,60000},{3,3000},{4,3000},{21,500}]};

get_star_cfg(4,5) ->
	#talisman_star_cfg{id = 4,star = 5,cost = [{0,24030003,32}],combat = 144000,attr_plus = [],attr = [{1,3600},{2,72000},{3,3600},{4,3600},{21,600}]};

get_star_cfg(5,0) ->
	#talisman_star_cfg{id = 5,star = 0,cost = [{0,24030004,2}],combat = 30000,attr_plus = [{1,1200},{2,24000},{3,300},{4,300},{22,100}],attr = [{1,1200},{2,24000},{3,300},{4,300},{21,100}]};

get_star_cfg(5,1) ->
	#talisman_star_cfg{id = 5,star = 1,cost = [{0,24030004,4}],combat = 60000,attr_plus = [{1,1200},{2,24000},{3,300},{4,300},{22,100}],attr = [{1,2400},{2,48000},{3,600},{4,600},{21,200}]};

get_star_cfg(5,2) ->
	#talisman_star_cfg{id = 5,star = 2,cost = [{0,24030004,8}],combat = 90000,attr_plus = [{1,1200},{2,24000},{3,300},{4,300},{22,100}],attr = [{1,3600},{2,72000},{3,900},{4,900},{21,300}]};

get_star_cfg(5,3) ->
	#talisman_star_cfg{id = 5,star = 3,cost = [{0,24030004,12}],combat = 120000,attr_plus = [{1,1200},{2,24000},{3,300},{4,300},{22,100}],attr = [{1,4800},{2,96000},{3,1200},{4,1200},{21,400}]};

get_star_cfg(5,4) ->
	#talisman_star_cfg{id = 5,star = 4,cost = [{0,24030004,16}],combat = 150000,attr_plus = [{1,1200},{2,24000},{3,300},{4,300},{22,100}],attr = [{1,6000},{2,120000},{3,1500},{4,1500},{21,500}]};

get_star_cfg(5,5) ->
	#talisman_star_cfg{id = 5,star = 5,cost = [{0,24030004,32}],combat = 180000,attr_plus = [],attr = [{1,7200},{2,144000},{3,1800},{4,1800},{21,600}]};

get_star_cfg(6,0) ->
	#talisman_star_cfg{id = 6,star = 0,cost = [{0,24030005,2}],combat = 32000,attr_plus = [{1,800},{2,16000},{3,800},{4,800},{22,100}],attr = [{1,800},{2,16000},{3,800},{4,800},{21,100}]};

get_star_cfg(6,1) ->
	#talisman_star_cfg{id = 6,star = 1,cost = [{0,24030005,4}],combat = 64000,attr_plus = [{1,800},{2,16000},{3,800},{4,800},{22,100}],attr = [{1,1600},{2,32000},{3,1600},{4,1600},{21,200}]};

get_star_cfg(6,2) ->
	#talisman_star_cfg{id = 6,star = 2,cost = [{0,24030005,8}],combat = 96000,attr_plus = [{1,800},{2,16000},{3,800},{4,800},{22,100}],attr = [{1,2400},{2,48000},{3,2400},{4,2400},{21,300}]};

get_star_cfg(6,3) ->
	#talisman_star_cfg{id = 6,star = 3,cost = [{0,24030005,12}],combat = 128000,attr_plus = [{1,800},{2,16000},{3,800},{4,800},{22,100}],attr = [{1,3200},{2,64000},{3,3200},{4,3200},{21,400}]};

get_star_cfg(6,4) ->
	#talisman_star_cfg{id = 6,star = 4,cost = [{0,24030005,16}],combat = 160000,attr_plus = [{1,800},{2,16000},{3,800},{4,800},{22,100}],attr = [{1,4000},{2,80000},{3,4000},{4,4000},{21,500}]};

get_star_cfg(6,5) ->
	#talisman_star_cfg{id = 6,star = 5,cost = [{0,24030005,32}],combat = 192000,attr_plus = [],attr = [{1,4800},{2,96000},{3,4800},{4,4800},{21,600}]};

get_star_cfg(7,0) ->
	#talisman_star_cfg{id = 7,star = 0,cost = [{0,24030007,2}],combat = 40000,attr_plus = [{1,1000},{2,20000},{3,1000},{4,1000},{22,100}],attr = [{1,1000},{2,20000},{3,1000},{4,1000},{21,100}]};

get_star_cfg(7,1) ->
	#talisman_star_cfg{id = 7,star = 1,cost = [{0,24030007,4}],combat = 80000,attr_plus = [{1,1000},{2,20000},{3,1000},{4,1000},{22,100}],attr = [{1,2000},{2,40000},{3,2000},{4,2000},{21,200}]};

get_star_cfg(7,2) ->
	#talisman_star_cfg{id = 7,star = 2,cost = [{0,24030007,8}],combat = 120000,attr_plus = [{1,1000},{2,20000},{3,1000},{4,1000},{22,100}],attr = [{1,3000},{2,60000},{3,3000},{4,3000},{21,300}]};

get_star_cfg(7,3) ->
	#talisman_star_cfg{id = 7,star = 3,cost = [{0,24030007,12}],combat = 160000,attr_plus = [{1,1000},{2,20000},{3,1000},{4,1000},{22,100}],attr = [{1,4000},{2,80000},{3,4000},{4,4000},{21,400}]};

get_star_cfg(7,4) ->
	#talisman_star_cfg{id = 7,star = 4,cost = [{0,24030007,16}],combat = 200000,attr_plus = [{1,1000},{2,20000},{3,1000},{4,1000},{22,100}],attr = [{1,5000},{2,100000},{3,5000},{4,5000},{21,500}]};

get_star_cfg(7,5) ->
	#talisman_star_cfg{id = 7,star = 5,cost = [{0,24030007,32}],combat = 240000,attr_plus = [],attr = [{1,6000},{2,120000},{3,6000},{4,6000},{21,600}]};

get_star_cfg(_Id,_Star) ->
	[].

get_skill_cfg(16000001) ->
	#talisman_skill_cfg{skill_id = 16000001,lv = 1};

get_skill_cfg(16000002) ->
	#talisman_skill_cfg{skill_id = 16000002,lv = 21};

get_skill_cfg(16000003) ->
	#talisman_skill_cfg{skill_id = 16000003,lv = 41};

get_skill_cfg(16000004) ->
	#talisman_skill_cfg{skill_id = 16000004,lv = 61};

get_skill_cfg(16000005) ->
	#talisman_skill_cfg{skill_id = 16000005,lv = 91};

get_skill_cfg(_Skillid) ->
	[].

get_all_skill_ids() ->
[16000001,16000002,16000003,16000004,16000005].


get_unlock_skill(1) ->
[16000001];


get_unlock_skill(21) ->
[16000002];


get_unlock_skill(41) ->
[16000003];


get_unlock_skill(61) ->
[16000004];


get_unlock_skill(91) ->
[16000005];

get_unlock_skill(_Lv) ->
	[].

get_lv_cfg(1) ->
	#talisman_lv_cfg{lv = 1,max_exp = 10,attr = [{1,10},{2,200},{3,5},{4,5}],combat = 300,is_tv = 0,attr_plus = [{1,16},{2,320},{3,8},{4,8}]};

get_lv_cfg(2) ->
	#talisman_lv_cfg{lv = 2,max_exp = 11,attr = [{1,26},{2,520},{3,13},{4,13}],combat = 780,is_tv = 0,attr_plus = [{1,18},{2,360},{3,9},{4,9}]};

get_lv_cfg(3) ->
	#talisman_lv_cfg{lv = 3,max_exp = 12,attr = [{1,44},{2,880},{3,22},{4,22}],combat = 1320,is_tv = 0,attr_plus = [{1,20},{2,400},{3,10},{4,10}]};

get_lv_cfg(4) ->
	#talisman_lv_cfg{lv = 4,max_exp = 13,attr = [{1,64},{2,1280},{3,32},{4,32}],combat = 1920,is_tv = 0,attr_plus = [{1,22},{2,440},{3,11},{4,11}]};

get_lv_cfg(5) ->
	#talisman_lv_cfg{lv = 5,max_exp = 14,attr = [{1,86},{2,1720},{3,43},{4,43}],combat = 2580,is_tv = 0,attr_plus = [{1,24},{2,480},{3,12},{4,12}]};

get_lv_cfg(6) ->
	#talisman_lv_cfg{lv = 6,max_exp = 16,attr = [{1,110},{2,2200},{3,55},{4,55}],combat = 3300,is_tv = 0,attr_plus = [{1,26},{2,520},{3,13},{4,13}]};

get_lv_cfg(7) ->
	#talisman_lv_cfg{lv = 7,max_exp = 18,attr = [{1,136},{2,2720},{3,68},{4,68}],combat = 4080,is_tv = 0,attr_plus = [{1,28},{2,560},{3,14},{4,14}]};

get_lv_cfg(8) ->
	#talisman_lv_cfg{lv = 8,max_exp = 20,attr = [{1,164},{2,3280},{3,82},{4,82}],combat = 4920,is_tv = 0,attr_plus = [{1,30},{2,600},{3,15},{4,15}]};

get_lv_cfg(9) ->
	#talisman_lv_cfg{lv = 9,max_exp = 22,attr = [{1,194},{2,3880},{3,97},{4,97}],combat = 5820,is_tv = 0,attr_plus = [{1,32},{2,640},{3,16},{4,16}]};

get_lv_cfg(10) ->
	#talisman_lv_cfg{lv = 10,max_exp = 24,attr = [{1,226},{2,4520},{3,113},{4,113}],combat = 6780,is_tv = 1,attr_plus = [{1,48},{2,960},{3,24},{4,24}]};

get_lv_cfg(11) ->
	#talisman_lv_cfg{lv = 11,max_exp = 26,attr = [{1,274},{2,5480},{3,137},{4,137}],combat = 8220,is_tv = 0,attr_plus = [{1,16},{2,320},{3,8},{4,8}]};

get_lv_cfg(12) ->
	#talisman_lv_cfg{lv = 12,max_exp = 28,attr = [{1,290},{2,5800},{3,145},{4,145}],combat = 8700,is_tv = 0,attr_plus = [{1,18},{2,360},{3,9},{4,9}]};

get_lv_cfg(13) ->
	#talisman_lv_cfg{lv = 13,max_exp = 30,attr = [{1,308},{2,6160},{3,154},{4,154}],combat = 9240,is_tv = 0,attr_plus = [{1,20},{2,400},{3,10},{4,10}]};

get_lv_cfg(14) ->
	#talisman_lv_cfg{lv = 14,max_exp = 33,attr = [{1,328},{2,6560},{3,164},{4,164}],combat = 9840,is_tv = 0,attr_plus = [{1,22},{2,440},{3,11},{4,11}]};

get_lv_cfg(15) ->
	#talisman_lv_cfg{lv = 15,max_exp = 36,attr = [{1,350},{2,7000},{3,175},{4,175}],combat = 10500,is_tv = 0,attr_plus = [{1,24},{2,480},{3,12},{4,12}]};

get_lv_cfg(16) ->
	#talisman_lv_cfg{lv = 16,max_exp = 39,attr = [{1,374},{2,7480},{3,187},{4,187}],combat = 11220,is_tv = 0,attr_plus = [{1,26},{2,520},{3,13},{4,13}]};

get_lv_cfg(17) ->
	#talisman_lv_cfg{lv = 17,max_exp = 42,attr = [{1,400},{2,8000},{3,200},{4,200}],combat = 12000,is_tv = 0,attr_plus = [{1,28},{2,560},{3,14},{4,14}]};

get_lv_cfg(18) ->
	#talisman_lv_cfg{lv = 18,max_exp = 45,attr = [{1,428},{2,8560},{3,214},{4,214}],combat = 12840,is_tv = 0,attr_plus = [{1,30},{2,600},{3,15},{4,15}]};

get_lv_cfg(19) ->
	#talisman_lv_cfg{lv = 19,max_exp = 48,attr = [{1,458},{2,9160},{3,229},{4,229}],combat = 13740,is_tv = 0,attr_plus = [{1,32},{2,640},{3,16},{4,16}]};

get_lv_cfg(20) ->
	#talisman_lv_cfg{lv = 20,max_exp = 51,attr = [{1,490},{2,9800},{3,245},{4,245}],combat = 14700,is_tv = 1,attr_plus = [{1,48},{2,960},{3,24},{4,24}]};

get_lv_cfg(21) ->
	#talisman_lv_cfg{lv = 21,max_exp = 54,attr = [{1,538},{2,10760},{3,269},{4,269}],combat = 16140,is_tv = 0,attr_plus = [{1,16},{2,320},{3,8},{4,8}]};

get_lv_cfg(22) ->
	#talisman_lv_cfg{lv = 22,max_exp = 58,attr = [{1,554},{2,11080},{3,277},{4,277}],combat = 16620,is_tv = 0,attr_plus = [{1,18},{2,360},{3,9},{4,9}]};

get_lv_cfg(23) ->
	#talisman_lv_cfg{lv = 23,max_exp = 62,attr = [{1,572},{2,11440},{3,286},{4,286}],combat = 17160,is_tv = 0,attr_plus = [{1,20},{2,400},{3,10},{4,10}]};

get_lv_cfg(24) ->
	#talisman_lv_cfg{lv = 24,max_exp = 66,attr = [{1,592},{2,11840},{3,296},{4,296}],combat = 17760,is_tv = 0,attr_plus = [{1,22},{2,440},{3,11},{4,11}]};

get_lv_cfg(25) ->
	#talisman_lv_cfg{lv = 25,max_exp = 70,attr = [{1,614},{2,12280},{3,307},{4,307}],combat = 18420,is_tv = 0,attr_plus = [{1,24},{2,480},{3,12},{4,12}]};

get_lv_cfg(26) ->
	#talisman_lv_cfg{lv = 26,max_exp = 74,attr = [{1,638},{2,12760},{3,319},{4,319}],combat = 19140,is_tv = 0,attr_plus = [{1,26},{2,520},{3,13},{4,13}]};

get_lv_cfg(27) ->
	#talisman_lv_cfg{lv = 27,max_exp = 78,attr = [{1,664},{2,13280},{3,332},{4,332}],combat = 19920,is_tv = 0,attr_plus = [{1,28},{2,560},{3,14},{4,14}]};

get_lv_cfg(28) ->
	#talisman_lv_cfg{lv = 28,max_exp = 82,attr = [{1,692},{2,13840},{3,346},{4,346}],combat = 20760,is_tv = 0,attr_plus = [{1,30},{2,600},{3,15},{4,15}]};

get_lv_cfg(29) ->
	#talisman_lv_cfg{lv = 29,max_exp = 86,attr = [{1,722},{2,14440},{3,361},{4,361}],combat = 21660,is_tv = 0,attr_plus = [{1,32},{2,640},{3,16},{4,16}]};

get_lv_cfg(30) ->
	#talisman_lv_cfg{lv = 30,max_exp = 91,attr = [{1,754},{2,15080},{3,377},{4,377}],combat = 22620,is_tv = 1,attr_plus = [{1,48},{2,960},{3,24},{4,24}]};

get_lv_cfg(31) ->
	#talisman_lv_cfg{lv = 31,max_exp = 96,attr = [{1,802},{2,16040},{3,401},{4,401}],combat = 24060,is_tv = 0,attr_plus = [{1,16},{2,320},{3,8},{4,8}]};

get_lv_cfg(32) ->
	#talisman_lv_cfg{lv = 32,max_exp = 101,attr = [{1,818},{2,16360},{3,409},{4,409}],combat = 24540,is_tv = 0,attr_plus = [{1,18},{2,360},{3,9},{4,9}]};

get_lv_cfg(33) ->
	#talisman_lv_cfg{lv = 33,max_exp = 106,attr = [{1,836},{2,16720},{3,418},{4,418}],combat = 25080,is_tv = 0,attr_plus = [{1,20},{2,400},{3,10},{4,10}]};

get_lv_cfg(34) ->
	#talisman_lv_cfg{lv = 34,max_exp = 111,attr = [{1,856},{2,17120},{3,428},{4,428}],combat = 25680,is_tv = 0,attr_plus = [{1,22},{2,440},{3,11},{4,11}]};

get_lv_cfg(35) ->
	#talisman_lv_cfg{lv = 35,max_exp = 116,attr = [{1,878},{2,17560},{3,439},{4,439}],combat = 26340,is_tv = 0,attr_plus = [{1,24},{2,480},{3,12},{4,12}]};

get_lv_cfg(36) ->
	#talisman_lv_cfg{lv = 36,max_exp = 121,attr = [{1,902},{2,18040},{3,451},{4,451}],combat = 27060,is_tv = 0,attr_plus = [{1,26},{2,520},{3,13},{4,13}]};

get_lv_cfg(37) ->
	#talisman_lv_cfg{lv = 37,max_exp = 126,attr = [{1,928},{2,18560},{3,464},{4,464}],combat = 27840,is_tv = 0,attr_plus = [{1,28},{2,560},{3,14},{4,14}]};

get_lv_cfg(38) ->
	#talisman_lv_cfg{lv = 38,max_exp = 132,attr = [{1,956},{2,19120},{3,478},{4,478}],combat = 28680,is_tv = 0,attr_plus = [{1,30},{2,600},{3,15},{4,15}]};

get_lv_cfg(39) ->
	#talisman_lv_cfg{lv = 39,max_exp = 138,attr = [{1,986},{2,19720},{3,493},{4,493}],combat = 29580,is_tv = 0,attr_plus = [{1,32},{2,640},{3,16},{4,16}]};

get_lv_cfg(40) ->
	#talisman_lv_cfg{lv = 40,max_exp = 144,attr = [{1,1018},{2,20360},{3,509},{4,509}],combat = 30540,is_tv = 1,attr_plus = [{1,48},{2,960},{3,24},{4,24}]};

get_lv_cfg(41) ->
	#talisman_lv_cfg{lv = 41,max_exp = 150,attr = [{1,1066},{2,21320},{3,533},{4,533}],combat = 31980,is_tv = 0,attr_plus = [{1,16},{2,320},{3,8},{4,8}]};

get_lv_cfg(42) ->
	#talisman_lv_cfg{lv = 42,max_exp = 156,attr = [{1,1082},{2,21640},{3,541},{4,541}],combat = 32460,is_tv = 0,attr_plus = [{1,18},{2,360},{3,9},{4,9}]};

get_lv_cfg(43) ->
	#talisman_lv_cfg{lv = 43,max_exp = 162,attr = [{1,1100},{2,22000},{3,550},{4,550}],combat = 33000,is_tv = 0,attr_plus = [{1,20},{2,400},{3,10},{4,10}]};

get_lv_cfg(44) ->
	#talisman_lv_cfg{lv = 44,max_exp = 168,attr = [{1,1120},{2,22400},{3,560},{4,560}],combat = 33600,is_tv = 0,attr_plus = [{1,22},{2,440},{3,11},{4,11}]};

get_lv_cfg(45) ->
	#talisman_lv_cfg{lv = 45,max_exp = 174,attr = [{1,1142},{2,22840},{3,571},{4,571}],combat = 34260,is_tv = 0,attr_plus = [{1,24},{2,480},{3,12},{4,12}]};

get_lv_cfg(46) ->
	#talisman_lv_cfg{lv = 46,max_exp = 181,attr = [{1,1166},{2,23320},{3,583},{4,583}],combat = 34980,is_tv = 0,attr_plus = [{1,26},{2,520},{3,13},{4,13}]};

get_lv_cfg(47) ->
	#talisman_lv_cfg{lv = 47,max_exp = 188,attr = [{1,1192},{2,23840},{3,596},{4,596}],combat = 35760,is_tv = 0,attr_plus = [{1,28},{2,560},{3,14},{4,14}]};

get_lv_cfg(48) ->
	#talisman_lv_cfg{lv = 48,max_exp = 195,attr = [{1,1220},{2,24400},{3,610},{4,610}],combat = 36600,is_tv = 0,attr_plus = [{1,30},{2,600},{3,15},{4,15}]};

get_lv_cfg(49) ->
	#talisman_lv_cfg{lv = 49,max_exp = 202,attr = [{1,1250},{2,25000},{3,625},{4,625}],combat = 37500,is_tv = 0,attr_plus = [{1,32},{2,640},{3,16},{4,16}]};

get_lv_cfg(50) ->
	#talisman_lv_cfg{lv = 50,max_exp = 209,attr = [{1,1282},{2,25640},{3,641},{4,641}],combat = 38460,is_tv = 1,attr_plus = [{1,48},{2,960},{3,24},{4,24}]};

get_lv_cfg(51) ->
	#talisman_lv_cfg{lv = 51,max_exp = 216,attr = [{1,1330},{2,26600},{3,665},{4,665}],combat = 39900,is_tv = 0,attr_plus = [{1,16},{2,320},{3,8},{4,8}]};

get_lv_cfg(52) ->
	#talisman_lv_cfg{lv = 52,max_exp = 223,attr = [{1,1346},{2,26920},{3,673},{4,673}],combat = 40380,is_tv = 0,attr_plus = [{1,18},{2,360},{3,9},{4,9}]};

get_lv_cfg(53) ->
	#talisman_lv_cfg{lv = 53,max_exp = 230,attr = [{1,1364},{2,27280},{3,682},{4,682}],combat = 40920,is_tv = 0,attr_plus = [{1,20},{2,400},{3,10},{4,10}]};

get_lv_cfg(54) ->
	#talisman_lv_cfg{lv = 54,max_exp = 238,attr = [{1,1384},{2,27680},{3,692},{4,692}],combat = 41520,is_tv = 0,attr_plus = [{1,22},{2,440},{3,11},{4,11}]};

get_lv_cfg(55) ->
	#talisman_lv_cfg{lv = 55,max_exp = 246,attr = [{1,1406},{2,28120},{3,703},{4,703}],combat = 42180,is_tv = 0,attr_plus = [{1,24},{2,480},{3,12},{4,12}]};

get_lv_cfg(56) ->
	#talisman_lv_cfg{lv = 56,max_exp = 254,attr = [{1,1430},{2,28600},{3,715},{4,715}],combat = 42900,is_tv = 0,attr_plus = [{1,26},{2,520},{3,13},{4,13}]};

get_lv_cfg(57) ->
	#talisman_lv_cfg{lv = 57,max_exp = 262,attr = [{1,1456},{2,29120},{3,728},{4,728}],combat = 43680,is_tv = 0,attr_plus = [{1,28},{2,560},{3,14},{4,14}]};

get_lv_cfg(58) ->
	#talisman_lv_cfg{lv = 58,max_exp = 270,attr = [{1,1484},{2,29680},{3,742},{4,742}],combat = 44520,is_tv = 0,attr_plus = [{1,30},{2,600},{3,15},{4,15}]};

get_lv_cfg(59) ->
	#talisman_lv_cfg{lv = 59,max_exp = 278,attr = [{1,1514},{2,30280},{3,757},{4,757}],combat = 45420,is_tv = 0,attr_plus = [{1,32},{2,640},{3,16},{4,16}]};

get_lv_cfg(60) ->
	#talisman_lv_cfg{lv = 60,max_exp = 286,attr = [{1,1546},{2,30920},{3,773},{4,773}],combat = 46380,is_tv = 1,attr_plus = [{1,48},{2,960},{3,24},{4,24}]};

get_lv_cfg(61) ->
	#talisman_lv_cfg{lv = 61,max_exp = 294,attr = [{1,1594},{2,31880},{3,797},{4,797}],combat = 47820,is_tv = 0,attr_plus = [{1,16},{2,320},{3,8},{4,8}]};

get_lv_cfg(62) ->
	#talisman_lv_cfg{lv = 62,max_exp = 303,attr = [{1,1610},{2,32200},{3,805},{4,805}],combat = 48300,is_tv = 0,attr_plus = [{1,18},{2,360},{3,9},{4,9}]};

get_lv_cfg(63) ->
	#talisman_lv_cfg{lv = 63,max_exp = 312,attr = [{1,1628},{2,32560},{3,814},{4,814}],combat = 48840,is_tv = 0,attr_plus = [{1,20},{2,400},{3,10},{4,10}]};

get_lv_cfg(64) ->
	#talisman_lv_cfg{lv = 64,max_exp = 321,attr = [{1,1648},{2,32960},{3,824},{4,824}],combat = 49440,is_tv = 0,attr_plus = [{1,22},{2,440},{3,11},{4,11}]};

get_lv_cfg(65) ->
	#talisman_lv_cfg{lv = 65,max_exp = 330,attr = [{1,1670},{2,33400},{3,835},{4,835}],combat = 50100,is_tv = 0,attr_plus = [{1,24},{2,480},{3,12},{4,12}]};

get_lv_cfg(66) ->
	#talisman_lv_cfg{lv = 66,max_exp = 339,attr = [{1,1694},{2,33880},{3,847},{4,847}],combat = 50820,is_tv = 0,attr_plus = [{1,26},{2,520},{3,13},{4,13}]};

get_lv_cfg(67) ->
	#talisman_lv_cfg{lv = 67,max_exp = 348,attr = [{1,1720},{2,34400},{3,860},{4,860}],combat = 51600,is_tv = 0,attr_plus = [{1,28},{2,560},{3,14},{4,14}]};

get_lv_cfg(68) ->
	#talisman_lv_cfg{lv = 68,max_exp = 357,attr = [{1,1748},{2,34960},{3,874},{4,874}],combat = 52440,is_tv = 0,attr_plus = [{1,30},{2,600},{3,15},{4,15}]};

get_lv_cfg(69) ->
	#talisman_lv_cfg{lv = 69,max_exp = 366,attr = [{1,1778},{2,35560},{3,889},{4,889}],combat = 53340,is_tv = 0,attr_plus = [{1,32},{2,640},{3,16},{4,16}]};

get_lv_cfg(70) ->
	#talisman_lv_cfg{lv = 70,max_exp = 376,attr = [{1,1810},{2,36200},{3,905},{4,905}],combat = 54300,is_tv = 1,attr_plus = [{1,48},{2,960},{3,24},{4,24}]};

get_lv_cfg(71) ->
	#talisman_lv_cfg{lv = 71,max_exp = 386,attr = [{1,1858},{2,37160},{3,929},{4,929}],combat = 55740,is_tv = 0,attr_plus = [{1,16},{2,320},{3,8},{4,8}]};

get_lv_cfg(72) ->
	#talisman_lv_cfg{lv = 72,max_exp = 396,attr = [{1,1874},{2,37480},{3,937},{4,937}],combat = 56220,is_tv = 0,attr_plus = [{1,18},{2,360},{3,9},{4,9}]};

get_lv_cfg(73) ->
	#talisman_lv_cfg{lv = 73,max_exp = 406,attr = [{1,1892},{2,37840},{3,946},{4,946}],combat = 56760,is_tv = 0,attr_plus = [{1,20},{2,400},{3,10},{4,10}]};

get_lv_cfg(74) ->
	#talisman_lv_cfg{lv = 74,max_exp = 416,attr = [{1,1912},{2,38240},{3,956},{4,956}],combat = 57360,is_tv = 0,attr_plus = [{1,22},{2,440},{3,11},{4,11}]};

get_lv_cfg(75) ->
	#talisman_lv_cfg{lv = 75,max_exp = 426,attr = [{1,1934},{2,38680},{3,967},{4,967}],combat = 58020,is_tv = 0,attr_plus = [{1,24},{2,480},{3,12},{4,12}]};

get_lv_cfg(76) ->
	#talisman_lv_cfg{lv = 76,max_exp = 436,attr = [{1,1958},{2,39160},{3,979},{4,979}],combat = 58740,is_tv = 0,attr_plus = [{1,26},{2,520},{3,13},{4,13}]};

get_lv_cfg(77) ->
	#talisman_lv_cfg{lv = 77,max_exp = 446,attr = [{1,1984},{2,39680},{3,992},{4,992}],combat = 59520,is_tv = 0,attr_plus = [{1,28},{2,560},{3,14},{4,14}]};

get_lv_cfg(78) ->
	#talisman_lv_cfg{lv = 78,max_exp = 457,attr = [{1,2012},{2,40240},{3,1006},{4,1006}],combat = 60360,is_tv = 0,attr_plus = [{1,30},{2,600},{3,15},{4,15}]};

get_lv_cfg(79) ->
	#talisman_lv_cfg{lv = 79,max_exp = 468,attr = [{1,2042},{2,40840},{3,1021},{4,1021}],combat = 61260,is_tv = 0,attr_plus = [{1,32},{2,640},{3,16},{4,16}]};

get_lv_cfg(80) ->
	#talisman_lv_cfg{lv = 80,max_exp = 479,attr = [{1,2074},{2,41480},{3,1037},{4,1037}],combat = 62220,is_tv = 1,attr_plus = [{1,48},{2,960},{3,24},{4,24}]};

get_lv_cfg(81) ->
	#talisman_lv_cfg{lv = 81,max_exp = 490,attr = [{1,2122},{2,42440},{3,1061},{4,1061}],combat = 63660,is_tv = 0,attr_plus = [{1,16},{2,320},{3,8},{4,8}]};

get_lv_cfg(82) ->
	#talisman_lv_cfg{lv = 82,max_exp = 501,attr = [{1,2138},{2,42760},{3,1069},{4,1069}],combat = 64140,is_tv = 0,attr_plus = [{1,18},{2,360},{3,9},{4,9}]};

get_lv_cfg(83) ->
	#talisman_lv_cfg{lv = 83,max_exp = 512,attr = [{1,2156},{2,43120},{3,1078},{4,1078}],combat = 64680,is_tv = 0,attr_plus = [{1,20},{2,400},{3,10},{4,10}]};

get_lv_cfg(84) ->
	#talisman_lv_cfg{lv = 84,max_exp = 523,attr = [{1,2176},{2,43520},{3,1088},{4,1088}],combat = 65280,is_tv = 0,attr_plus = [{1,22},{2,440},{3,11},{4,11}]};

get_lv_cfg(85) ->
	#talisman_lv_cfg{lv = 85,max_exp = 534,attr = [{1,2198},{2,43960},{3,1099},{4,1099}],combat = 65940,is_tv = 0,attr_plus = [{1,24},{2,480},{3,12},{4,12}]};

get_lv_cfg(86) ->
	#talisman_lv_cfg{lv = 86,max_exp = 546,attr = [{1,2222},{2,44440},{3,1111},{4,1111}],combat = 66660,is_tv = 0,attr_plus = [{1,26},{2,520},{3,13},{4,13}]};

get_lv_cfg(87) ->
	#talisman_lv_cfg{lv = 87,max_exp = 558,attr = [{1,2248},{2,44960},{3,1124},{4,1124}],combat = 67440,is_tv = 0,attr_plus = [{1,28},{2,560},{3,14},{4,14}]};

get_lv_cfg(88) ->
	#talisman_lv_cfg{lv = 88,max_exp = 570,attr = [{1,2276},{2,45520},{3,1138},{4,1138}],combat = 68280,is_tv = 0,attr_plus = [{1,30},{2,600},{3,15},{4,15}]};

get_lv_cfg(89) ->
	#talisman_lv_cfg{lv = 89,max_exp = 582,attr = [{1,2306},{2,46120},{3,1153},{4,1153}],combat = 69180,is_tv = 0,attr_plus = [{1,32},{2,640},{3,16},{4,16}]};

get_lv_cfg(90) ->
	#talisman_lv_cfg{lv = 90,max_exp = 594,attr = [{1,2338},{2,46760},{3,1169},{4,1169}],combat = 70140,is_tv = 1,attr_plus = [{1,48},{2,960},{3,24},{4,24}]};

get_lv_cfg(91) ->
	#talisman_lv_cfg{lv = 91,max_exp = 606,attr = [{1,2386},{2,47720},{3,1193},{4,1193}],combat = 71580,is_tv = 0,attr_plus = [{1,16},{2,320},{3,8},{4,8}]};

get_lv_cfg(92) ->
	#talisman_lv_cfg{lv = 92,max_exp = 618,attr = [{1,2402},{2,48040},{3,1201},{4,1201}],combat = 72060,is_tv = 0,attr_plus = [{1,18},{2,360},{3,9},{4,9}]};

get_lv_cfg(93) ->
	#talisman_lv_cfg{lv = 93,max_exp = 630,attr = [{1,2420},{2,48400},{3,1210},{4,1210}],combat = 72600,is_tv = 0,attr_plus = [{1,20},{2,400},{3,10},{4,10}]};

get_lv_cfg(94) ->
	#talisman_lv_cfg{lv = 94,max_exp = 643,attr = [{1,2440},{2,48800},{3,1220},{4,1220}],combat = 73200,is_tv = 0,attr_plus = [{1,22},{2,440},{3,11},{4,11}]};

get_lv_cfg(95) ->
	#talisman_lv_cfg{lv = 95,max_exp = 656,attr = [{1,2462},{2,49240},{3,1231},{4,1231}],combat = 73860,is_tv = 0,attr_plus = [{1,24},{2,480},{3,12},{4,12}]};

get_lv_cfg(96) ->
	#talisman_lv_cfg{lv = 96,max_exp = 669,attr = [{1,2486},{2,49720},{3,1243},{4,1243}],combat = 74580,is_tv = 0,attr_plus = [{1,26},{2,520},{3,13},{4,13}]};

get_lv_cfg(97) ->
	#talisman_lv_cfg{lv = 97,max_exp = 682,attr = [{1,2512},{2,50240},{3,1256},{4,1256}],combat = 75360,is_tv = 0,attr_plus = [{1,28},{2,560},{3,14},{4,14}]};

get_lv_cfg(98) ->
	#talisman_lv_cfg{lv = 98,max_exp = 695,attr = [{1,2540},{2,50800},{3,1270},{4,1270}],combat = 76200,is_tv = 0,attr_plus = [{1,30},{2,600},{3,15},{4,15}]};

get_lv_cfg(99) ->
	#talisman_lv_cfg{lv = 99,max_exp = 708,attr = [{1,2570},{2,51400},{3,1285},{4,1285}],combat = 77100,is_tv = 0,attr_plus = [{1,32},{2,640},{3,16},{4,16}]};

get_lv_cfg(100) ->
	#talisman_lv_cfg{lv = 100,max_exp = 721,attr = [{1,2602},{2,52040},{3,1301},{4,1301}],combat = 78060,is_tv = 1,attr_plus = [{1,48},{2,960},{3,24},{4,24}]};

get_lv_cfg(101) ->
	#talisman_lv_cfg{lv = 101,max_exp = 734,attr = [{1,2650},{2,53000},{3,1325},{4,1325}],combat = 79500,is_tv = 0,attr_plus = [{1,16},{2,320},{3,8},{4,8}]};

get_lv_cfg(102) ->
	#talisman_lv_cfg{lv = 102,max_exp = 748,attr = [{1,2666},{2,53320},{3,1333},{4,1333}],combat = 79980,is_tv = 0,attr_plus = [{1,18},{2,360},{3,9},{4,9}]};

get_lv_cfg(103) ->
	#talisman_lv_cfg{lv = 103,max_exp = 762,attr = [{1,2684},{2,53680},{3,1342},{4,1342}],combat = 80520,is_tv = 0,attr_plus = [{1,20},{2,400},{3,10},{4,10}]};

get_lv_cfg(104) ->
	#talisman_lv_cfg{lv = 104,max_exp = 776,attr = [{1,2704},{2,54080},{3,1352},{4,1352}],combat = 81120,is_tv = 0,attr_plus = [{1,22},{2,440},{3,11},{4,11}]};

get_lv_cfg(105) ->
	#talisman_lv_cfg{lv = 105,max_exp = 790,attr = [{1,2726},{2,54520},{3,1363},{4,1363}],combat = 81780,is_tv = 0,attr_plus = [{1,24},{2,480},{3,12},{4,12}]};

get_lv_cfg(106) ->
	#talisman_lv_cfg{lv = 106,max_exp = 804,attr = [{1,2750},{2,55000},{3,1375},{4,1375}],combat = 82500,is_tv = 0,attr_plus = [{1,26},{2,520},{3,13},{4,13}]};

get_lv_cfg(107) ->
	#talisman_lv_cfg{lv = 107,max_exp = 818,attr = [{1,2776},{2,55520},{3,1388},{4,1388}],combat = 83280,is_tv = 0,attr_plus = [{1,28},{2,560},{3,14},{4,14}]};

get_lv_cfg(108) ->
	#talisman_lv_cfg{lv = 108,max_exp = 832,attr = [{1,2804},{2,56080},{3,1402},{4,1402}],combat = 84120,is_tv = 0,attr_plus = [{1,30},{2,600},{3,15},{4,15}]};

get_lv_cfg(109) ->
	#talisman_lv_cfg{lv = 109,max_exp = 846,attr = [{1,2834},{2,56680},{3,1417},{4,1417}],combat = 85020,is_tv = 0,attr_plus = [{1,32},{2,640},{3,16},{4,16}]};

get_lv_cfg(110) ->
	#talisman_lv_cfg{lv = 110,max_exp = 861,attr = [{1,2866},{2,57320},{3,1433},{4,1433}],combat = 85980,is_tv = 1,attr_plus = [{1,48},{2,960},{3,24},{4,24}]};

get_lv_cfg(111) ->
	#talisman_lv_cfg{lv = 111,max_exp = 876,attr = [{1,2914},{2,58280},{3,1457},{4,1457}],combat = 87420,is_tv = 0,attr_plus = [{1,16},{2,320},{3,8},{4,8}]};

get_lv_cfg(112) ->
	#talisman_lv_cfg{lv = 112,max_exp = 891,attr = [{1,2930},{2,58600},{3,1465},{4,1465}],combat = 87900,is_tv = 0,attr_plus = [{1,18},{2,360},{3,9},{4,9}]};

get_lv_cfg(113) ->
	#talisman_lv_cfg{lv = 113,max_exp = 906,attr = [{1,2948},{2,58960},{3,1474},{4,1474}],combat = 88440,is_tv = 0,attr_plus = [{1,20},{2,400},{3,10},{4,10}]};

get_lv_cfg(114) ->
	#talisman_lv_cfg{lv = 114,max_exp = 921,attr = [{1,2968},{2,59360},{3,1484},{4,1484}],combat = 89040,is_tv = 0,attr_plus = [{1,22},{2,440},{3,11},{4,11}]};

get_lv_cfg(115) ->
	#talisman_lv_cfg{lv = 115,max_exp = 936,attr = [{1,2990},{2,59800},{3,1495},{4,1495}],combat = 89700,is_tv = 0,attr_plus = [{1,24},{2,480},{3,12},{4,12}]};

get_lv_cfg(116) ->
	#talisman_lv_cfg{lv = 116,max_exp = 951,attr = [{1,3014},{2,60280},{3,1507},{4,1507}],combat = 90420,is_tv = 0,attr_plus = [{1,26},{2,520},{3,13},{4,13}]};

get_lv_cfg(117) ->
	#talisman_lv_cfg{lv = 117,max_exp = 966,attr = [{1,3040},{2,60800},{3,1520},{4,1520}],combat = 91200,is_tv = 0,attr_plus = [{1,28},{2,560},{3,14},{4,14}]};

get_lv_cfg(118) ->
	#talisman_lv_cfg{lv = 118,max_exp = 982,attr = [{1,3068},{2,61360},{3,1534},{4,1534}],combat = 92040,is_tv = 0,attr_plus = [{1,30},{2,600},{3,15},{4,15}]};

get_lv_cfg(119) ->
	#talisman_lv_cfg{lv = 119,max_exp = 998,attr = [{1,3098},{2,61960},{3,1549},{4,1549}],combat = 92940,is_tv = 0,attr_plus = [{1,32},{2,640},{3,16},{4,16}]};

get_lv_cfg(120) ->
	#talisman_lv_cfg{lv = 120,max_exp = 1014,attr = [{1,3130},{2,62600},{3,1565},{4,1565}],combat = 93900,is_tv = 1,attr_plus = [{1,16},{2,320},{3,8},{4,8}]};

get_lv_cfg(121) ->
	#talisman_lv_cfg{lv = 121,max_exp = 1018,attr = [{1,3146},{2,62920},{3,1573},{4,1573}],combat = 94380,is_tv = 0,attr_plus = [{1,18},{2,360},{3,9},{4,9}]};

get_lv_cfg(122) ->
	#talisman_lv_cfg{lv = 122,max_exp = 1022,attr = [{1,3164},{2,63280},{3,1582},{4,1582}],combat = 94920,is_tv = 0,attr_plus = [{1,20},{2,400},{3,10},{4,10}]};

get_lv_cfg(123) ->
	#talisman_lv_cfg{lv = 123,max_exp = 1026,attr = [{1,3184},{2,63680},{3,1592},{4,1592}],combat = 95520,is_tv = 0,attr_plus = [{1,22},{2,440},{3,11},{4,11}]};

get_lv_cfg(124) ->
	#talisman_lv_cfg{lv = 124,max_exp = 1030,attr = [{1,3206},{2,64120},{3,1603},{4,1603}],combat = 96180,is_tv = 0,attr_plus = [{1,24},{2,480},{3,12},{4,12}]};

get_lv_cfg(125) ->
	#talisman_lv_cfg{lv = 125,max_exp = 1034,attr = [{1,3230},{2,64600},{3,1615},{4,1615}],combat = 96900,is_tv = 0,attr_plus = [{1,26},{2,520},{3,13},{4,13}]};

get_lv_cfg(126) ->
	#talisman_lv_cfg{lv = 126,max_exp = 1038,attr = [{1,3256},{2,65120},{3,1628},{4,1628}],combat = 97680,is_tv = 0,attr_plus = [{1,28},{2,560},{3,14},{4,14}]};

get_lv_cfg(127) ->
	#talisman_lv_cfg{lv = 127,max_exp = 1042,attr = [{1,3284},{2,65680},{3,1642},{4,1642}],combat = 98520,is_tv = 0,attr_plus = [{1,30},{2,600},{3,15},{4,15}]};

get_lv_cfg(128) ->
	#talisman_lv_cfg{lv = 128,max_exp = 1046,attr = [{1,3314},{2,66280},{3,1657},{4,1657}],combat = 99420,is_tv = 0,attr_plus = [{1,32},{2,640},{3,16},{4,16}]};

get_lv_cfg(129) ->
	#talisman_lv_cfg{lv = 129,max_exp = 1050,attr = [{1,3346},{2,66920},{3,1673},{4,1673}],combat = 100380,is_tv = 0,attr_plus = [{1,48},{2,960},{3,24},{4,24}]};

get_lv_cfg(130) ->
	#talisman_lv_cfg{lv = 130,max_exp = 1054,attr = [{1,3394},{2,67880},{3,1697},{4,1697}],combat = 101820,is_tv = 1,attr_plus = [{1,16},{2,320},{3,8},{4,8}]};

get_lv_cfg(131) ->
	#talisman_lv_cfg{lv = 131,max_exp = 1058,attr = [{1,3410},{2,68200},{3,1705},{4,1705}],combat = 102300,is_tv = 0,attr_plus = [{1,18},{2,360},{3,9},{4,9}]};

get_lv_cfg(132) ->
	#talisman_lv_cfg{lv = 132,max_exp = 1062,attr = [{1,3428},{2,68560},{3,1714},{4,1714}],combat = 102840,is_tv = 0,attr_plus = [{1,20},{2,400},{3,10},{4,10}]};

get_lv_cfg(133) ->
	#talisman_lv_cfg{lv = 133,max_exp = 1066,attr = [{1,3448},{2,68960},{3,1724},{4,1724}],combat = 103440,is_tv = 0,attr_plus = [{1,22},{2,440},{3,11},{4,11}]};

get_lv_cfg(134) ->
	#talisman_lv_cfg{lv = 134,max_exp = 1070,attr = [{1,3470},{2,69400},{3,1735},{4,1735}],combat = 104100,is_tv = 0,attr_plus = [{1,24},{2,480},{3,12},{4,12}]};

get_lv_cfg(135) ->
	#talisman_lv_cfg{lv = 135,max_exp = 1074,attr = [{1,3494},{2,69880},{3,1747},{4,1747}],combat = 104820,is_tv = 0,attr_plus = [{1,26},{2,520},{3,13},{4,13}]};

get_lv_cfg(136) ->
	#talisman_lv_cfg{lv = 136,max_exp = 1078,attr = [{1,3520},{2,70400},{3,1760},{4,1760}],combat = 105600,is_tv = 0,attr_plus = [{1,28},{2,560},{3,14},{4,14}]};

get_lv_cfg(137) ->
	#talisman_lv_cfg{lv = 137,max_exp = 1082,attr = [{1,3548},{2,70960},{3,1774},{4,1774}],combat = 106440,is_tv = 0,attr_plus = [{1,30},{2,600},{3,15},{4,15}]};

get_lv_cfg(138) ->
	#talisman_lv_cfg{lv = 138,max_exp = 1086,attr = [{1,3578},{2,71560},{3,1789},{4,1789}],combat = 107340,is_tv = 0,attr_plus = [{1,32},{2,640},{3,16},{4,16}]};

get_lv_cfg(139) ->
	#talisman_lv_cfg{lv = 139,max_exp = 1090,attr = [{1,3610},{2,72200},{3,1805},{4,1805}],combat = 108300,is_tv = 0,attr_plus = [{1,48},{2,960},{3,24},{4,24}]};

get_lv_cfg(140) ->
	#talisman_lv_cfg{lv = 140,max_exp = 1094,attr = [{1,3658},{2,73160},{3,1829},{4,1829}],combat = 109740,is_tv = 1,attr_plus = [{1,16},{2,320},{3,8},{4,8}]};

get_lv_cfg(141) ->
	#talisman_lv_cfg{lv = 141,max_exp = 1098,attr = [{1,3674},{2,73480},{3,1837},{4,1837}],combat = 110220,is_tv = 0,attr_plus = [{1,18},{2,360},{3,9},{4,9}]};

get_lv_cfg(142) ->
	#talisman_lv_cfg{lv = 142,max_exp = 1102,attr = [{1,3692},{2,73840},{3,1846},{4,1846}],combat = 110760,is_tv = 0,attr_plus = [{1,20},{2,400},{3,10},{4,10}]};

get_lv_cfg(143) ->
	#talisman_lv_cfg{lv = 143,max_exp = 1106,attr = [{1,3712},{2,74240},{3,1856},{4,1856}],combat = 111360,is_tv = 0,attr_plus = [{1,22},{2,440},{3,11},{4,11}]};

get_lv_cfg(144) ->
	#talisman_lv_cfg{lv = 144,max_exp = 1110,attr = [{1,3734},{2,74680},{3,1867},{4,1867}],combat = 112020,is_tv = 0,attr_plus = [{1,24},{2,480},{3,12},{4,12}]};

get_lv_cfg(145) ->
	#talisman_lv_cfg{lv = 145,max_exp = 1114,attr = [{1,3758},{2,75160},{3,1879},{4,1879}],combat = 112740,is_tv = 0,attr_plus = [{1,26},{2,520},{3,13},{4,13}]};

get_lv_cfg(146) ->
	#talisman_lv_cfg{lv = 146,max_exp = 1118,attr = [{1,3784},{2,75680},{3,1892},{4,1892}],combat = 113520,is_tv = 0,attr_plus = [{1,28},{2,560},{3,14},{4,14}]};

get_lv_cfg(147) ->
	#talisman_lv_cfg{lv = 147,max_exp = 1122,attr = [{1,3812},{2,76240},{3,1906},{4,1906}],combat = 114360,is_tv = 0,attr_plus = [{1,30},{2,600},{3,15},{4,15}]};

get_lv_cfg(148) ->
	#talisman_lv_cfg{lv = 148,max_exp = 1126,attr = [{1,3842},{2,76840},{3,1921},{4,1921}],combat = 115260,is_tv = 0,attr_plus = [{1,32},{2,640},{3,16},{4,16}]};

get_lv_cfg(149) ->
	#talisman_lv_cfg{lv = 149,max_exp = 1130,attr = [{1,3874},{2,77480},{3,1937},{4,1937}],combat = 116220,is_tv = 0,attr_plus = [{1,48},{2,960},{3,24},{4,24}]};

get_lv_cfg(150) ->
	#talisman_lv_cfg{lv = 150,max_exp = 1134,attr = [{1,3922},{2,78440},{3,1961},{4,1961}],combat = 117660,is_tv = 1,attr_plus = [{1,16},{2,320},{3,8},{4,8}]};

get_lv_cfg(151) ->
	#talisman_lv_cfg{lv = 151,max_exp = 1138,attr = [{1,3938},{2,78760},{3,1969},{4,1969}],combat = 118140,is_tv = 0,attr_plus = [{1,18},{2,360},{3,9},{4,9}]};

get_lv_cfg(152) ->
	#talisman_lv_cfg{lv = 152,max_exp = 1142,attr = [{1,3956},{2,79120},{3,1978},{4,1978}],combat = 118680,is_tv = 0,attr_plus = [{1,20},{2,400},{3,10},{4,10}]};

get_lv_cfg(153) ->
	#talisman_lv_cfg{lv = 153,max_exp = 1146,attr = [{1,3976},{2,79520},{3,1988},{4,1988}],combat = 119280,is_tv = 0,attr_plus = [{1,22},{2,440},{3,11},{4,11}]};

get_lv_cfg(154) ->
	#talisman_lv_cfg{lv = 154,max_exp = 1150,attr = [{1,3998},{2,79960},{3,1999},{4,1999}],combat = 119940,is_tv = 0,attr_plus = [{1,24},{2,480},{3,12},{4,12}]};

get_lv_cfg(155) ->
	#talisman_lv_cfg{lv = 155,max_exp = 1154,attr = [{1,4022},{2,80440},{3,2011},{4,2011}],combat = 120660,is_tv = 0,attr_plus = [{1,26},{2,520},{3,13},{4,13}]};

get_lv_cfg(156) ->
	#talisman_lv_cfg{lv = 156,max_exp = 1158,attr = [{1,4048},{2,80960},{3,2024},{4,2024}],combat = 121440,is_tv = 0,attr_plus = [{1,28},{2,560},{3,14},{4,14}]};

get_lv_cfg(157) ->
	#talisman_lv_cfg{lv = 157,max_exp = 1162,attr = [{1,4076},{2,81520},{3,2038},{4,2038}],combat = 122280,is_tv = 0,attr_plus = [{1,30},{2,600},{3,15},{4,15}]};

get_lv_cfg(158) ->
	#talisman_lv_cfg{lv = 158,max_exp = 1166,attr = [{1,4106},{2,82120},{3,2053},{4,2053}],combat = 123180,is_tv = 0,attr_plus = [{1,32},{2,640},{3,16},{4,16}]};

get_lv_cfg(159) ->
	#talisman_lv_cfg{lv = 159,max_exp = 1170,attr = [{1,4138},{2,82760},{3,2069},{4,2069}],combat = 124140,is_tv = 0,attr_plus = [{1,48},{2,960},{3,24},{4,24}]};

get_lv_cfg(160) ->
	#talisman_lv_cfg{lv = 160,max_exp = 1174,attr = [{1,4186},{2,83720},{3,2093},{4,2093}],combat = 125580,is_tv = 1,attr_plus = [{1,16},{2,320},{3,8},{4,8}]};

get_lv_cfg(161) ->
	#talisman_lv_cfg{lv = 161,max_exp = 1178,attr = [{1,4202},{2,84040},{3,2101},{4,2101}],combat = 126060,is_tv = 0,attr_plus = [{1,18},{2,360},{3,9},{4,9}]};

get_lv_cfg(162) ->
	#talisman_lv_cfg{lv = 162,max_exp = 1182,attr = [{1,4220},{2,84400},{3,2110},{4,2110}],combat = 126600,is_tv = 0,attr_plus = [{1,20},{2,400},{3,10},{4,10}]};

get_lv_cfg(163) ->
	#talisman_lv_cfg{lv = 163,max_exp = 1186,attr = [{1,4240},{2,84800},{3,2120},{4,2120}],combat = 127200,is_tv = 0,attr_plus = [{1,22},{2,440},{3,11},{4,11}]};

get_lv_cfg(164) ->
	#talisman_lv_cfg{lv = 164,max_exp = 1190,attr = [{1,4262},{2,85240},{3,2131},{4,2131}],combat = 127860,is_tv = 0,attr_plus = [{1,24},{2,480},{3,12},{4,12}]};

get_lv_cfg(165) ->
	#talisman_lv_cfg{lv = 165,max_exp = 1194,attr = [{1,4286},{2,85720},{3,2143},{4,2143}],combat = 128580,is_tv = 0,attr_plus = [{1,26},{2,520},{3,13},{4,13}]};

get_lv_cfg(166) ->
	#talisman_lv_cfg{lv = 166,max_exp = 1198,attr = [{1,4312},{2,86240},{3,2156},{4,2156}],combat = 129360,is_tv = 0,attr_plus = [{1,28},{2,560},{3,14},{4,14}]};

get_lv_cfg(167) ->
	#talisman_lv_cfg{lv = 167,max_exp = 1202,attr = [{1,4340},{2,86800},{3,2170},{4,2170}],combat = 130200,is_tv = 0,attr_plus = [{1,30},{2,600},{3,15},{4,15}]};

get_lv_cfg(168) ->
	#talisman_lv_cfg{lv = 168,max_exp = 1206,attr = [{1,4370},{2,87400},{3,2185},{4,2185}],combat = 131100,is_tv = 0,attr_plus = [{1,32},{2,640},{3,16},{4,16}]};

get_lv_cfg(169) ->
	#talisman_lv_cfg{lv = 169,max_exp = 1210,attr = [{1,4402},{2,88040},{3,2201},{4,2201}],combat = 132060,is_tv = 0,attr_plus = [{1,48},{2,960},{3,24},{4,24}]};

get_lv_cfg(170) ->
	#talisman_lv_cfg{lv = 170,max_exp = 1214,attr = [{1,4450},{2,89000},{3,2225},{4,2225}],combat = 133500,is_tv = 1,attr_plus = [{1,16},{2,320},{3,8},{4,8}]};

get_lv_cfg(171) ->
	#talisman_lv_cfg{lv = 171,max_exp = 1218,attr = [{1,4466},{2,89320},{3,2233},{4,2233}],combat = 133980,is_tv = 0,attr_plus = [{1,18},{2,360},{3,9},{4,9}]};

get_lv_cfg(172) ->
	#talisman_lv_cfg{lv = 172,max_exp = 1222,attr = [{1,4484},{2,89680},{3,2242},{4,2242}],combat = 134520,is_tv = 0,attr_plus = [{1,20},{2,400},{3,10},{4,10}]};

get_lv_cfg(173) ->
	#talisman_lv_cfg{lv = 173,max_exp = 1226,attr = [{1,4504},{2,90080},{3,2252},{4,2252}],combat = 135120,is_tv = 0,attr_plus = [{1,22},{2,440},{3,11},{4,11}]};

get_lv_cfg(174) ->
	#talisman_lv_cfg{lv = 174,max_exp = 1230,attr = [{1,4526},{2,90520},{3,2263},{4,2263}],combat = 135780,is_tv = 0,attr_plus = [{1,24},{2,480},{3,12},{4,12}]};

get_lv_cfg(175) ->
	#talisman_lv_cfg{lv = 175,max_exp = 1234,attr = [{1,4550},{2,91000},{3,2275},{4,2275}],combat = 136500,is_tv = 0,attr_plus = [{1,26},{2,520},{3,13},{4,13}]};

get_lv_cfg(176) ->
	#talisman_lv_cfg{lv = 176,max_exp = 1238,attr = [{1,4576},{2,91520},{3,2288},{4,2288}],combat = 137280,is_tv = 0,attr_plus = [{1,28},{2,560},{3,14},{4,14}]};

get_lv_cfg(177) ->
	#talisman_lv_cfg{lv = 177,max_exp = 1242,attr = [{1,4604},{2,92080},{3,2302},{4,2302}],combat = 138120,is_tv = 0,attr_plus = [{1,30},{2,600},{3,15},{4,15}]};

get_lv_cfg(178) ->
	#talisman_lv_cfg{lv = 178,max_exp = 1246,attr = [{1,4634},{2,92680},{3,2317},{4,2317}],combat = 139020,is_tv = 0,attr_plus = [{1,32},{2,640},{3,16},{4,16}]};

get_lv_cfg(179) ->
	#talisman_lv_cfg{lv = 179,max_exp = 1250,attr = [{1,4666},{2,93320},{3,2333},{4,2333}],combat = 139980,is_tv = 0,attr_plus = [{1,48},{2,960},{3,24},{4,24}]};

get_lv_cfg(180) ->
	#talisman_lv_cfg{lv = 180,max_exp = 1254,attr = [{1,4714},{2,94280},{3,2357},{4,2357}],combat = 141420,is_tv = 1,attr_plus = [{1,16},{2,320},{3,8},{4,8}]};

get_lv_cfg(181) ->
	#talisman_lv_cfg{lv = 181,max_exp = 1258,attr = [{1,4730},{2,94600},{3,2365},{4,2365}],combat = 141900,is_tv = 0,attr_plus = [{1,18},{2,360},{3,9},{4,9}]};

get_lv_cfg(182) ->
	#talisman_lv_cfg{lv = 182,max_exp = 1262,attr = [{1,4748},{2,94960},{3,2374},{4,2374}],combat = 142440,is_tv = 0,attr_plus = [{1,20},{2,400},{3,10},{4,10}]};

get_lv_cfg(183) ->
	#talisman_lv_cfg{lv = 183,max_exp = 1266,attr = [{1,4768},{2,95360},{3,2384},{4,2384}],combat = 143040,is_tv = 0,attr_plus = [{1,22},{2,440},{3,11},{4,11}]};

get_lv_cfg(184) ->
	#talisman_lv_cfg{lv = 184,max_exp = 1270,attr = [{1,4790},{2,95800},{3,2395},{4,2395}],combat = 143700,is_tv = 0,attr_plus = [{1,24},{2,480},{3,12},{4,12}]};

get_lv_cfg(185) ->
	#talisman_lv_cfg{lv = 185,max_exp = 1274,attr = [{1,4814},{2,96280},{3,2407},{4,2407}],combat = 144420,is_tv = 0,attr_plus = [{1,26},{2,520},{3,13},{4,13}]};

get_lv_cfg(186) ->
	#talisman_lv_cfg{lv = 186,max_exp = 1278,attr = [{1,4840},{2,96800},{3,2420},{4,2420}],combat = 145200,is_tv = 0,attr_plus = [{1,28},{2,560},{3,14},{4,14}]};

get_lv_cfg(187) ->
	#talisman_lv_cfg{lv = 187,max_exp = 1282,attr = [{1,4868},{2,97360},{3,2434},{4,2434}],combat = 146040,is_tv = 0,attr_plus = [{1,30},{2,600},{3,15},{4,15}]};

get_lv_cfg(188) ->
	#talisman_lv_cfg{lv = 188,max_exp = 1286,attr = [{1,4898},{2,97960},{3,2449},{4,2449}],combat = 146940,is_tv = 0,attr_plus = [{1,32},{2,640},{3,16},{4,16}]};

get_lv_cfg(189) ->
	#talisman_lv_cfg{lv = 189,max_exp = 1290,attr = [{1,4930},{2,98600},{3,2465},{4,2465}],combat = 147900,is_tv = 0,attr_plus = [{1,48},{2,960},{3,24},{4,24}]};

get_lv_cfg(190) ->
	#talisman_lv_cfg{lv = 190,max_exp = 1294,attr = [{1,4978},{2,99560},{3,2489},{4,2489}],combat = 149340,is_tv = 1,attr_plus = [{1,16},{2,320},{3,8},{4,8}]};

get_lv_cfg(191) ->
	#talisman_lv_cfg{lv = 191,max_exp = 1298,attr = [{1,4994},{2,99880},{3,2497},{4,2497}],combat = 149820,is_tv = 0,attr_plus = [{1,18},{2,360},{3,9},{4,9}]};

get_lv_cfg(192) ->
	#talisman_lv_cfg{lv = 192,max_exp = 1302,attr = [{1,5012},{2,100240},{3,2506},{4,2506}],combat = 150360,is_tv = 0,attr_plus = [{1,20},{2,400},{3,10},{4,10}]};

get_lv_cfg(193) ->
	#talisman_lv_cfg{lv = 193,max_exp = 1306,attr = [{1,5032},{2,100640},{3,2516},{4,2516}],combat = 150960,is_tv = 0,attr_plus = [{1,22},{2,440},{3,11},{4,11}]};

get_lv_cfg(194) ->
	#talisman_lv_cfg{lv = 194,max_exp = 1310,attr = [{1,5054},{2,101080},{3,2527},{4,2527}],combat = 151620,is_tv = 0,attr_plus = [{1,24},{2,480},{3,12},{4,12}]};

get_lv_cfg(195) ->
	#talisman_lv_cfg{lv = 195,max_exp = 1314,attr = [{1,5078},{2,101560},{3,2539},{4,2539}],combat = 152340,is_tv = 0,attr_plus = [{1,26},{2,520},{3,13},{4,13}]};

get_lv_cfg(196) ->
	#talisman_lv_cfg{lv = 196,max_exp = 1318,attr = [{1,5104},{2,102080},{3,2552},{4,2552}],combat = 153120,is_tv = 0,attr_plus = [{1,28},{2,560},{3,14},{4,14}]};

get_lv_cfg(197) ->
	#talisman_lv_cfg{lv = 197,max_exp = 1322,attr = [{1,5132},{2,102640},{3,2566},{4,2566}],combat = 153960,is_tv = 0,attr_plus = [{1,30},{2,600},{3,15},{4,15}]};

get_lv_cfg(198) ->
	#talisman_lv_cfg{lv = 198,max_exp = 1326,attr = [{1,5162},{2,103240},{3,2581},{4,2581}],combat = 154860,is_tv = 0,attr_plus = [{1,32},{2,640},{3,16},{4,16}]};

get_lv_cfg(199) ->
	#talisman_lv_cfg{lv = 199,max_exp = 1330,attr = [{1,5194},{2,103880},{3,2597},{4,2597}],combat = 155820,is_tv = 0,attr_plus = [{1,48},{2,960},{3,24},{4,24}]};

get_lv_cfg(200) ->
	#talisman_lv_cfg{lv = 200,max_exp = 1334,attr = [{1,5242},{2,104840},{3,2621},{4,2621}],combat = 157260,is_tv = 1,attr_plus = [{1,16},{2,320},{3,8},{4,8}]};

get_lv_cfg(201) ->
	#talisman_lv_cfg{lv = 201,max_exp = 1338,attr = [{1,5258},{2,105160},{3,2629},{4,2629}],combat = 157740,is_tv = 0,attr_plus = [{1,18},{2,360},{3,9},{4,9}]};

get_lv_cfg(202) ->
	#talisman_lv_cfg{lv = 202,max_exp = 1342,attr = [{1,5276},{2,105520},{3,2638},{4,2638}],combat = 158280,is_tv = 0,attr_plus = [{1,20},{2,400},{3,10},{4,10}]};

get_lv_cfg(203) ->
	#talisman_lv_cfg{lv = 203,max_exp = 1346,attr = [{1,5296},{2,105920},{3,2648},{4,2648}],combat = 158880,is_tv = 0,attr_plus = [{1,22},{2,440},{3,11},{4,11}]};

get_lv_cfg(204) ->
	#talisman_lv_cfg{lv = 204,max_exp = 1350,attr = [{1,5318},{2,106360},{3,2659},{4,2659}],combat = 159540,is_tv = 0,attr_plus = [{1,24},{2,480},{3,12},{4,12}]};

get_lv_cfg(205) ->
	#talisman_lv_cfg{lv = 205,max_exp = 1354,attr = [{1,5342},{2,106840},{3,2671},{4,2671}],combat = 160260,is_tv = 0,attr_plus = [{1,26},{2,520},{3,13},{4,13}]};

get_lv_cfg(206) ->
	#talisman_lv_cfg{lv = 206,max_exp = 1358,attr = [{1,5368},{2,107360},{3,2684},{4,2684}],combat = 161040,is_tv = 0,attr_plus = [{1,28},{2,560},{3,14},{4,14}]};

get_lv_cfg(207) ->
	#talisman_lv_cfg{lv = 207,max_exp = 1362,attr = [{1,5396},{2,107920},{3,2698},{4,2698}],combat = 161880,is_tv = 0,attr_plus = [{1,30},{2,600},{3,15},{4,15}]};

get_lv_cfg(208) ->
	#talisman_lv_cfg{lv = 208,max_exp = 1366,attr = [{1,5426},{2,108520},{3,2713},{4,2713}],combat = 162780,is_tv = 0,attr_plus = [{1,32},{2,640},{3,16},{4,16}]};

get_lv_cfg(209) ->
	#talisman_lv_cfg{lv = 209,max_exp = 1370,attr = [{1,5458},{2,109160},{3,2729},{4,2729}],combat = 163740,is_tv = 0,attr_plus = [{1,48},{2,960},{3,24},{4,24}]};

get_lv_cfg(210) ->
	#talisman_lv_cfg{lv = 210,max_exp = 1374,attr = [{1,5506},{2,110120},{3,2753},{4,2753}],combat = 165180,is_tv = 1,attr_plus = [{1,16},{2,320},{3,8},{4,8}]};

get_lv_cfg(211) ->
	#talisman_lv_cfg{lv = 211,max_exp = 1378,attr = [{1,5522},{2,110440},{3,2761},{4,2761}],combat = 165660,is_tv = 0,attr_plus = [{1,18},{2,360},{3,9},{4,9}]};

get_lv_cfg(212) ->
	#talisman_lv_cfg{lv = 212,max_exp = 1382,attr = [{1,5540},{2,110800},{3,2770},{4,2770}],combat = 166200,is_tv = 0,attr_plus = [{1,20},{2,400},{3,10},{4,10}]};

get_lv_cfg(213) ->
	#talisman_lv_cfg{lv = 213,max_exp = 1386,attr = [{1,5560},{2,111200},{3,2780},{4,2780}],combat = 166800,is_tv = 0,attr_plus = [{1,22},{2,440},{3,11},{4,11}]};

get_lv_cfg(214) ->
	#talisman_lv_cfg{lv = 214,max_exp = 1390,attr = [{1,5582},{2,111640},{3,2791},{4,2791}],combat = 167460,is_tv = 0,attr_plus = [{1,24},{2,480},{3,12},{4,12}]};

get_lv_cfg(215) ->
	#talisman_lv_cfg{lv = 215,max_exp = 1394,attr = [{1,5606},{2,112120},{3,2803},{4,2803}],combat = 168180,is_tv = 0,attr_plus = [{1,26},{2,520},{3,13},{4,13}]};

get_lv_cfg(216) ->
	#talisman_lv_cfg{lv = 216,max_exp = 1398,attr = [{1,5632},{2,112640},{3,2816},{4,2816}],combat = 168960,is_tv = 0,attr_plus = [{1,28},{2,560},{3,14},{4,14}]};

get_lv_cfg(217) ->
	#talisman_lv_cfg{lv = 217,max_exp = 1402,attr = [{1,5660},{2,113200},{3,2830},{4,2830}],combat = 169800,is_tv = 0,attr_plus = [{1,30},{2,600},{3,15},{4,15}]};

get_lv_cfg(218) ->
	#talisman_lv_cfg{lv = 218,max_exp = 1406,attr = [{1,5690},{2,113800},{3,2845},{4,2845}],combat = 170700,is_tv = 0,attr_plus = [{1,32},{2,640},{3,16},{4,16}]};

get_lv_cfg(219) ->
	#talisman_lv_cfg{lv = 219,max_exp = 1410,attr = [{1,5722},{2,114440},{3,2861},{4,2861}],combat = 171660,is_tv = 0,attr_plus = [{1,48},{2,960},{3,24},{4,24}]};

get_lv_cfg(220) ->
	#talisman_lv_cfg{lv = 220,max_exp = 1414,attr = [{1,5770},{2,115400},{3,2885},{4,2885}],combat = 173100,is_tv = 1,attr_plus = [{1,16},{2,320},{3,8},{4,8}]};

get_lv_cfg(221) ->
	#talisman_lv_cfg{lv = 221,max_exp = 1418,attr = [{1,5786},{2,115720},{3,2893},{4,2893}],combat = 173580,is_tv = 0,attr_plus = [{1,18},{2,360},{3,9},{4,9}]};

get_lv_cfg(222) ->
	#talisman_lv_cfg{lv = 222,max_exp = 1422,attr = [{1,5804},{2,116080},{3,2902},{4,2902}],combat = 174120,is_tv = 0,attr_plus = [{1,20},{2,400},{3,10},{4,10}]};

get_lv_cfg(223) ->
	#talisman_lv_cfg{lv = 223,max_exp = 1426,attr = [{1,5824},{2,116480},{3,2912},{4,2912}],combat = 174720,is_tv = 0,attr_plus = [{1,22},{2,440},{3,11},{4,11}]};

get_lv_cfg(224) ->
	#talisman_lv_cfg{lv = 224,max_exp = 1430,attr = [{1,5846},{2,116920},{3,2923},{4,2923}],combat = 175380,is_tv = 0,attr_plus = [{1,24},{2,480},{3,12},{4,12}]};

get_lv_cfg(225) ->
	#talisman_lv_cfg{lv = 225,max_exp = 1434,attr = [{1,5870},{2,117400},{3,2935},{4,2935}],combat = 176100,is_tv = 0,attr_plus = [{1,26},{2,520},{3,13},{4,13}]};

get_lv_cfg(226) ->
	#talisman_lv_cfg{lv = 226,max_exp = 1438,attr = [{1,5896},{2,117920},{3,2948},{4,2948}],combat = 176880,is_tv = 0,attr_plus = [{1,28},{2,560},{3,14},{4,14}]};

get_lv_cfg(227) ->
	#talisman_lv_cfg{lv = 227,max_exp = 1442,attr = [{1,5924},{2,118480},{3,2962},{4,2962}],combat = 177720,is_tv = 0,attr_plus = [{1,30},{2,600},{3,15},{4,15}]};

get_lv_cfg(228) ->
	#talisman_lv_cfg{lv = 228,max_exp = 1446,attr = [{1,5954},{2,119080},{3,2977},{4,2977}],combat = 178620,is_tv = 0,attr_plus = [{1,32},{2,640},{3,16},{4,16}]};

get_lv_cfg(229) ->
	#talisman_lv_cfg{lv = 229,max_exp = 1450,attr = [{1,5986},{2,119720},{3,2993},{4,2993}],combat = 179580,is_tv = 0,attr_plus = [{1,48},{2,960},{3,24},{4,24}]};

get_lv_cfg(230) ->
	#talisman_lv_cfg{lv = 230,max_exp = 1454,attr = [{1,6034},{2,120680},{3,3017},{4,3017}],combat = 181020,is_tv = 1,attr_plus = [{1,16},{2,320},{3,8},{4,8}]};

get_lv_cfg(231) ->
	#talisman_lv_cfg{lv = 231,max_exp = 1458,attr = [{1,6050},{2,121000},{3,3025},{4,3025}],combat = 181500,is_tv = 0,attr_plus = [{1,18},{2,360},{3,9},{4,9}]};

get_lv_cfg(232) ->
	#talisman_lv_cfg{lv = 232,max_exp = 1462,attr = [{1,6068},{2,121360},{3,3034},{4,3034}],combat = 182040,is_tv = 0,attr_plus = [{1,20},{2,400},{3,10},{4,10}]};

get_lv_cfg(233) ->
	#talisman_lv_cfg{lv = 233,max_exp = 1466,attr = [{1,6088},{2,121760},{3,3044},{4,3044}],combat = 182640,is_tv = 0,attr_plus = [{1,22},{2,440},{3,11},{4,11}]};

get_lv_cfg(234) ->
	#talisman_lv_cfg{lv = 234,max_exp = 1470,attr = [{1,6110},{2,122200},{3,3055},{4,3055}],combat = 183300,is_tv = 0,attr_plus = [{1,24},{2,480},{3,12},{4,12}]};

get_lv_cfg(235) ->
	#talisman_lv_cfg{lv = 235,max_exp = 1474,attr = [{1,6134},{2,122680},{3,3067},{4,3067}],combat = 184020,is_tv = 0,attr_plus = [{1,26},{2,520},{3,13},{4,13}]};

get_lv_cfg(236) ->
	#talisman_lv_cfg{lv = 236,max_exp = 1478,attr = [{1,6160},{2,123200},{3,3080},{4,3080}],combat = 184800,is_tv = 0,attr_plus = [{1,28},{2,560},{3,14},{4,14}]};

get_lv_cfg(237) ->
	#talisman_lv_cfg{lv = 237,max_exp = 1482,attr = [{1,6188},{2,123760},{3,3094},{4,3094}],combat = 185640,is_tv = 0,attr_plus = [{1,30},{2,600},{3,15},{4,15}]};

get_lv_cfg(238) ->
	#talisman_lv_cfg{lv = 238,max_exp = 1486,attr = [{1,6218},{2,124360},{3,3109},{4,3109}],combat = 186540,is_tv = 0,attr_plus = [{1,32},{2,640},{3,16},{4,16}]};

get_lv_cfg(239) ->
	#talisman_lv_cfg{lv = 239,max_exp = 1490,attr = [{1,6250},{2,125000},{3,3125},{4,3125}],combat = 187500,is_tv = 0,attr_plus = [{1,48},{2,960},{3,24},{4,24}]};

get_lv_cfg(240) ->
	#talisman_lv_cfg{lv = 240,max_exp = 1494,attr = [{1,6298},{2,125960},{3,3149},{4,3149}],combat = 188940,is_tv = 1,attr_plus = [{1,16},{2,320},{3,8},{4,8}]};

get_lv_cfg(241) ->
	#talisman_lv_cfg{lv = 241,max_exp = 1498,attr = [{1,6314},{2,126280},{3,3157},{4,3157}],combat = 189420,is_tv = 0,attr_plus = [{1,18},{2,360},{3,9},{4,9}]};

get_lv_cfg(242) ->
	#talisman_lv_cfg{lv = 242,max_exp = 1502,attr = [{1,6332},{2,126640},{3,3166},{4,3166}],combat = 189960,is_tv = 0,attr_plus = [{1,20},{2,400},{3,10},{4,10}]};

get_lv_cfg(243) ->
	#talisman_lv_cfg{lv = 243,max_exp = 1506,attr = [{1,6352},{2,127040},{3,3176},{4,3176}],combat = 190560,is_tv = 0,attr_plus = [{1,22},{2,440},{3,11},{4,11}]};

get_lv_cfg(244) ->
	#talisman_lv_cfg{lv = 244,max_exp = 1510,attr = [{1,6374},{2,127480},{3,3187},{4,3187}],combat = 191220,is_tv = 0,attr_plus = [{1,24},{2,480},{3,12},{4,12}]};

get_lv_cfg(245) ->
	#talisman_lv_cfg{lv = 245,max_exp = 1514,attr = [{1,6398},{2,127960},{3,3199},{4,3199}],combat = 191940,is_tv = 0,attr_plus = [{1,26},{2,520},{3,13},{4,13}]};

get_lv_cfg(246) ->
	#talisman_lv_cfg{lv = 246,max_exp = 1518,attr = [{1,6424},{2,128480},{3,3212},{4,3212}],combat = 192720,is_tv = 0,attr_plus = [{1,28},{2,560},{3,14},{4,14}]};

get_lv_cfg(247) ->
	#talisman_lv_cfg{lv = 247,max_exp = 1522,attr = [{1,6452},{2,129040},{3,3226},{4,3226}],combat = 193560,is_tv = 0,attr_plus = [{1,30},{2,600},{3,15},{4,15}]};

get_lv_cfg(248) ->
	#talisman_lv_cfg{lv = 248,max_exp = 1526,attr = [{1,6482},{2,129640},{3,3241},{4,3241}],combat = 194460,is_tv = 0,attr_plus = [{1,32},{2,640},{3,16},{4,16}]};

get_lv_cfg(249) ->
	#talisman_lv_cfg{lv = 249,max_exp = 1530,attr = [{1,6514},{2,130280},{3,3257},{4,3257}],combat = 195420,is_tv = 0,attr_plus = [{1,48},{2,960},{3,24},{4,24}]};

get_lv_cfg(250) ->
	#talisman_lv_cfg{lv = 250,max_exp = 1534,attr = [{1,6562},{2,131240},{3,3281},{4,3281}],combat = 196860,is_tv = 1,attr_plus = []};

get_lv_cfg(_Lv) ->
	[].

get_goods_exp(24010001) ->
	#talisman_goods_exp_cfg{goods_id = 24010001,exp = 10};

get_goods_exp(24010002) ->
	#talisman_goods_exp_cfg{goods_id = 24010002,exp = 100};

get_goods_exp(24010003) ->
	#talisman_goods_exp_cfg{goods_id = 24010003,exp = 300};

get_goods_exp(_Goodsid) ->
	[].

get_goods_ids() ->
[24010001,24010002,24010003].

get_feather_cfg(_) ->
	[].

get_feather_ids() ->
[].

get_stage_cfg(0) ->
	#talisman_stage_cfg{id = 0,prop = [],name = "魔法之书",turn = 0,figure_id = 240001,max_star = 0};

get_stage_cfg(1) ->
	#talisman_stage_cfg{id = 1,prop = [{0,24030006,1}],name = "仙女竖琴",turn = 0,figure_id = 240007,max_star = 5};

get_stage_cfg(2) ->
	#talisman_stage_cfg{id = 2,prop = [{0,24030001,1}],name = "奥术水晶",turn = 1,figure_id = 240002,max_star = 5};

get_stage_cfg(3) ->
	#talisman_stage_cfg{id = 3,prop = [{0,24030002,1}],name = "上古王冠",turn = 2,figure_id = 240003,max_star = 5};

get_stage_cfg(4) ->
	#talisman_stage_cfg{id = 4,prop = [{0,24030003,1}],name = "海神圣杯",turn = 3,figure_id = 240004,max_star = 5};

get_stage_cfg(5) ->
	#talisman_stage_cfg{id = 5,prop = [{0,24030004,1}],name = "苍龙徽章",turn = 4,figure_id = 240005,max_star = 5};

get_stage_cfg(6) ->
	#talisman_stage_cfg{id = 6,prop = [{0,24030005,1}],name = "天使权杖",turn = 5,figure_id = 240006,max_star = 5};

get_stage_cfg(7) ->
	#talisman_stage_cfg{id = 7,prop = [{0,24030007,1}],name = "魅惑面具",turn = 6,figure_id = 240008,max_star = 5};

get_stage_cfg(_Id) ->
	[].

get_all_stages() ->
[0,1,2,3,4,5,6,7].

