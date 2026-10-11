%%%---------------------------------------
%%% module      : data_wing
%%% description : 翅膀配置
%%%
%%%---------------------------------------
-module(data_wing).
-compile(export_all).
-include("wing.hrl").



get_star_cfg(1,0) ->
	#wing_star_cfg{id = 1,star = 0,cost = [{0,20030003,2}],attr = [{1,600},{2,12000},{3,600},{4,600},{21,100}],attr_plus = [{1,600},{2,12000},{3,600},{4,600},{21,100}],combat = 24000};

get_star_cfg(1,1) ->
	#wing_star_cfg{id = 1,star = 1,cost = [{0,20030003,4}],attr = [{1,1200},{2,24000},{3,1200},{4,1200},{21,200}],attr_plus = [{1,600},{2,12000},{3,600},{4,600},{21,100}],combat = 48000};

get_star_cfg(1,2) ->
	#wing_star_cfg{id = 1,star = 2,cost = [{0,20030003,8}],attr = [{1,1800},{2,36000},{3,1800},{4,1800},{21,300}],attr_plus = [{1,600},{2,12000},{3,600},{4,600},{21,100}],combat = 72000};

get_star_cfg(1,3) ->
	#wing_star_cfg{id = 1,star = 3,cost = [{0,20030003,12}],attr = [{1,2400},{2,48000},{3,2400},{4,2400},{21,400}],attr_plus = [{1,600},{2,12000},{3,600},{4,600},{21,100}],combat = 96000};

get_star_cfg(1,4) ->
	#wing_star_cfg{id = 1,star = 4,cost = [{0,20030003,16}],attr = [{1,3000},{2,60000},{3,3000},{4,3000},{21,500}],attr_plus = [{1,600},{2,12000},{3,600},{4,600},{21,100}],combat = 120000};

get_star_cfg(1,5) ->
	#wing_star_cfg{id = 1,star = 5,cost = [{0,20030003,32}],attr = [{1,3600},{2,72000},{3,3600},{4,3600},{21,600}],attr_plus = [],combat = 144000};

get_star_cfg(2,0) ->
	#wing_star_cfg{id = 2,star = 0,cost = [{0,20030001,2}],attr = [{1,400},{2,8000},{3,400},{4,400},{21,100}],attr_plus = [{1,800},{2,16000},{3,200},{4,200},{21,100}],combat = 16000};

get_star_cfg(2,1) ->
	#wing_star_cfg{id = 2,star = 1,cost = [{0,20030001,4}],attr = [{1,1200},{2,24000},{3,600},{4,600},{21,200}],attr_plus = [{1,800},{2,16000},{3,200},{4,200},{21,100}],combat = 32000};

get_star_cfg(2,2) ->
	#wing_star_cfg{id = 2,star = 2,cost = [{0,20030001,8}],attr = [{1,2000},{2,40000},{3,800},{4,800},{21,300}],attr_plus = [{1,800},{2,16000},{3,200},{4,200},{21,100}],combat = 48000};

get_star_cfg(2,3) ->
	#wing_star_cfg{id = 2,star = 3,cost = [{0,20030001,12}],attr = [{1,2800},{2,56000},{3,1000},{4,1000},{21,400}],attr_plus = [{1,800},{2,16000},{3,200},{4,200},{21,100}],combat = 64000};

get_star_cfg(2,4) ->
	#wing_star_cfg{id = 2,star = 4,cost = [{0,20030001,16}],attr = [{1,3600},{2,72000},{3,1200},{4,1200},{21,500}],attr_plus = [{1,800},{2,16000},{3,200},{4,200},{21,100}],combat = 80000};

get_star_cfg(2,5) ->
	#wing_star_cfg{id = 2,star = 5,cost = [{0,20030001,32}],attr = [{1,4400},{2,88000},{3,1400},{4,1400},{21,600}],attr_plus = [],combat = 96000};

get_star_cfg(3,0) ->
	#wing_star_cfg{id = 3,star = 0,cost = [{0,20030002,2}],attr = [{1,800},{2,16000},{3,200},{4,200},{21,100}],attr_plus = [{1,800},{2,16000},{3,200},{4,200},{21,100}],combat = 20000};

get_star_cfg(3,1) ->
	#wing_star_cfg{id = 3,star = 1,cost = [{0,20030002,4}],attr = [{1,1600},{2,32000},{3,400},{4,400},{21,200}],attr_plus = [{1,800},{2,16000},{3,200},{4,200},{21,100}],combat = 40000};

get_star_cfg(3,2) ->
	#wing_star_cfg{id = 3,star = 2,cost = [{0,20030002,8}],attr = [{1,2400},{2,48000},{3,600},{4,600},{21,300}],attr_plus = [{1,800},{2,16000},{3,200},{4,200},{21,100}],combat = 60000};

get_star_cfg(3,3) ->
	#wing_star_cfg{id = 3,star = 3,cost = [{0,20030002,12}],attr = [{1,3200},{2,64000},{3,800},{4,800},{21,400}],attr_plus = [{1,800},{2,16000},{3,200},{4,200},{21,100}],combat = 80000};

get_star_cfg(3,4) ->
	#wing_star_cfg{id = 3,star = 4,cost = [{0,20030002,16}],attr = [{1,4000},{2,80000},{3,1000},{4,1000},{21,500}],attr_plus = [{1,800},{2,16000},{3,200},{4,200},{21,100}],combat = 100000};

get_star_cfg(3,5) ->
	#wing_star_cfg{id = 3,star = 5,cost = [{0,20030002,32}],attr = [{1,4800},{2,96000},{3,1200},{4,1200},{21,600}],attr_plus = [],combat = 120000};

get_star_cfg(4,0) ->
	#wing_star_cfg{id = 4,star = 0,cost = [{0,20030004,2}],attr = [{1,600},{2,12000},{3,600},{4,600},{21,100}],attr_plus = [{1,600},{2,12000},{3,600},{4,600},{21,100}],combat = 24000};

get_star_cfg(4,1) ->
	#wing_star_cfg{id = 4,star = 1,cost = [{0,20030004,4}],attr = [{1,1200},{2,24000},{3,1200},{4,1200},{21,200}],attr_plus = [{1,600},{2,12000},{3,600},{4,600},{21,100}],combat = 48000};

get_star_cfg(4,2) ->
	#wing_star_cfg{id = 4,star = 2,cost = [{0,20030004,8}],attr = [{1,1800},{2,36000},{3,1800},{4,1800},{21,300}],attr_plus = [{1,600},{2,12000},{3,600},{4,600},{21,100}],combat = 72000};

get_star_cfg(4,3) ->
	#wing_star_cfg{id = 4,star = 3,cost = [{0,20030004,12}],attr = [{1,2400},{2,48000},{3,2400},{4,2400},{21,400}],attr_plus = [{1,600},{2,12000},{3,600},{4,600},{21,100}],combat = 96000};

get_star_cfg(4,4) ->
	#wing_star_cfg{id = 4,star = 4,cost = [{0,20030004,16}],attr = [{1,3000},{2,60000},{3,3000},{4,3000},{21,500}],attr_plus = [{1,600},{2,12000},{3,600},{4,600},{21,100}],combat = 120000};

get_star_cfg(4,5) ->
	#wing_star_cfg{id = 4,star = 5,cost = [{0,20030004,32}],attr = [{1,3600},{2,72000},{3,3600},{4,3600},{21,600}],attr_plus = [],combat = 144000};

get_star_cfg(5,0) ->
	#wing_star_cfg{id = 5,star = 0,cost = [{0,20030005,2}],attr = [{1,1200},{2,24000},{3,300},{4,300},{21,100}],attr_plus = [{1,1200},{2,24000},{3,300},{4,300},{21,100}],combat = 30000};

get_star_cfg(5,1) ->
	#wing_star_cfg{id = 5,star = 1,cost = [{0,20030005,4}],attr = [{1,2400},{2,48000},{3,600},{4,600},{21,200}],attr_plus = [{1,1200},{2,24000},{3,300},{4,300},{21,100}],combat = 60000};

get_star_cfg(5,2) ->
	#wing_star_cfg{id = 5,star = 2,cost = [{0,20030005,8}],attr = [{1,3600},{2,72000},{3,900},{4,900},{21,300}],attr_plus = [{1,1200},{2,24000},{3,300},{4,300},{21,100}],combat = 90000};

get_star_cfg(5,3) ->
	#wing_star_cfg{id = 5,star = 3,cost = [{0,20030005,12}],attr = [{1,4800},{2,96000},{3,1200},{4,1200},{21,400}],attr_plus = [{1,1200},{2,24000},{3,300},{4,300},{21,100}],combat = 120000};

get_star_cfg(5,4) ->
	#wing_star_cfg{id = 5,star = 4,cost = [{0,20030005,16}],attr = [{1,6000},{2,120000},{3,1500},{4,1500},{21,500}],attr_plus = [{1,1200},{2,24000},{3,300},{4,300},{21,100}],combat = 150000};

get_star_cfg(5,5) ->
	#wing_star_cfg{id = 5,star = 5,cost = [{0,20030005,32}],attr = [{1,7200},{2,144000},{3,1800},{4,1800},{21,600}],attr_plus = [],combat = 180000};

get_star_cfg(6,0) ->
	#wing_star_cfg{id = 6,star = 0,cost = [{0,20030006,2}],attr = [{1,800},{2,16000},{3,800},{4,800},{21,100}],attr_plus = [{1,800},{2,16000},{3,800},{4,800},{21,100}],combat = 32000};

get_star_cfg(6,1) ->
	#wing_star_cfg{id = 6,star = 1,cost = [{0,20030006,4}],attr = [{1,1600},{2,32000},{3,1600},{4,1600},{21,200}],attr_plus = [{1,800},{2,16000},{3,800},{4,800},{21,100}],combat = 64000};

get_star_cfg(6,2) ->
	#wing_star_cfg{id = 6,star = 2,cost = [{0,20030006,8}],attr = [{1,2400},{2,48000},{3,2400},{4,2400},{21,300}],attr_plus = [{1,800},{2,16000},{3,800},{4,800},{21,100}],combat = 96000};

get_star_cfg(6,3) ->
	#wing_star_cfg{id = 6,star = 3,cost = [{0,20030006,12}],attr = [{1,3200},{2,64000},{3,3200},{4,3200},{21,400}],attr_plus = [{1,800},{2,16000},{3,800},{4,800},{21,100}],combat = 128000};

get_star_cfg(6,4) ->
	#wing_star_cfg{id = 6,star = 4,cost = [{0,20030006,16}],attr = [{1,4000},{2,80000},{3,4000},{4,4000},{21,500}],attr_plus = [{1,800},{2,16000},{3,800},{4,800},{21,100}],combat = 160000};

get_star_cfg(6,5) ->
	#wing_star_cfg{id = 6,star = 5,cost = [{0,20030006,32}],attr = [{1,4800},{2,96000},{3,4800},{4,4800},{21,600}],attr_plus = [],combat = 192000};

get_star_cfg(7,0) ->
	#wing_star_cfg{id = 7,star = 0,cost = [{0,20030007,2}],attr = [{1,1600},{2,32000},{3,400},{4,400},{21,100}],attr_plus = [{1,1600},{2,32000},{3,400},{4,400},{21,100}],combat = 40000};

get_star_cfg(7,1) ->
	#wing_star_cfg{id = 7,star = 1,cost = [{0,20030007,4}],attr = [{1,3200},{2,64000},{3,800},{4,800},{21,200}],attr_plus = [{1,1600},{2,32000},{3,400},{4,400},{21,100}],combat = 80000};

get_star_cfg(7,2) ->
	#wing_star_cfg{id = 7,star = 2,cost = [{0,20030007,8}],attr = [{1,4800},{2,96000},{3,1200},{4,1200},{21,300}],attr_plus = [{1,1600},{2,32000},{3,400},{4,400},{21,100}],combat = 120000};

get_star_cfg(7,3) ->
	#wing_star_cfg{id = 7,star = 3,cost = [{0,20030007,12}],attr = [{1,6400},{2,128000},{3,1600},{4,1600},{21,400}],attr_plus = [{1,1600},{2,32000},{3,400},{4,400},{21,100}],combat = 160000};

get_star_cfg(7,4) ->
	#wing_star_cfg{id = 7,star = 4,cost = [{0,20030007,16}],attr = [{1,8000},{2,160000},{3,2000},{4,2000},{21,500}],attr_plus = [{1,1600},{2,32000},{3,400},{4,400},{21,100}],combat = 200000};

get_star_cfg(7,5) ->
	#wing_star_cfg{id = 7,star = 5,cost = [{0,20030007,32}],attr = [{1,9600},{2,192000},{3,2400},{4,2400},{21,600}],attr_plus = [],combat = 240000};

get_star_cfg(_Id,_Star) ->
	[].

get_skill_cfg(15000001) ->
	#wing_skill_cfg{skill_id = 15000001,lv = 1};

get_skill_cfg(15000002) ->
	#wing_skill_cfg{skill_id = 15000002,lv = 21};

get_skill_cfg(15000003) ->
	#wing_skill_cfg{skill_id = 15000003,lv = 41};

get_skill_cfg(15000004) ->
	#wing_skill_cfg{skill_id = 15000004,lv = 61};

get_skill_cfg(15000005) ->
	#wing_skill_cfg{skill_id = 15000005,lv = 91};

get_skill_cfg(_Skillid) ->
	[].

get_all_skill_ids() ->
[15000001,15000002,15000003,15000004,15000005].

get_lv_cfg(1) ->
	#wing_lv_cfg{lv = 1,max_exp = 10,attr = [{1,10},{2,200},{3,5},{4,5}],attr_plus = [{1,8},{2,480},{3,8},{4,8}],combat = 300,is_tv = 0};

get_lv_cfg(2) ->
	#wing_lv_cfg{lv = 2,max_exp = 11,attr = [{1,18},{2,680},{3,13},{4,13}],attr_plus = [{1,9},{2,540},{3,9},{4,9}],combat = 780,is_tv = 0};

get_lv_cfg(3) ->
	#wing_lv_cfg{lv = 3,max_exp = 12,attr = [{1,27},{2,1220},{3,22},{4,22}],attr_plus = [{1,10},{2,600},{3,10},{4,10}],combat = 1320,is_tv = 0};

get_lv_cfg(4) ->
	#wing_lv_cfg{lv = 4,max_exp = 13,attr = [{1,37},{2,1820},{3,32},{4,32}],attr_plus = [{1,11},{2,660},{3,11},{4,11}],combat = 1920,is_tv = 0};

get_lv_cfg(5) ->
	#wing_lv_cfg{lv = 5,max_exp = 14,attr = [{1,48},{2,2480},{3,43},{4,43}],attr_plus = [{1,12},{2,720},{3,12},{4,12}],combat = 2580,is_tv = 0};

get_lv_cfg(6) ->
	#wing_lv_cfg{lv = 6,max_exp = 16,attr = [{1,60},{2,3200},{3,55},{4,55}],attr_plus = [{1,13},{2,780},{3,13},{4,13}],combat = 3300,is_tv = 0};

get_lv_cfg(7) ->
	#wing_lv_cfg{lv = 7,max_exp = 18,attr = [{1,73},{2,3980},{3,68},{4,68}],attr_plus = [{1,14},{2,840},{3,14},{4,14}],combat = 4080,is_tv = 0};

get_lv_cfg(8) ->
	#wing_lv_cfg{lv = 8,max_exp = 20,attr = [{1,87},{2,4820},{3,82},{4,82}],attr_plus = [{1,15},{2,900},{3,15},{4,15}],combat = 4920,is_tv = 0};

get_lv_cfg(9) ->
	#wing_lv_cfg{lv = 9,max_exp = 22,attr = [{1,102},{2,5720},{3,97},{4,97}],attr_plus = [{1,16},{2,960},{3,16},{4,16}],combat = 5820,is_tv = 0};

get_lv_cfg(10) ->
	#wing_lv_cfg{lv = 10,max_exp = 24,attr = [{1,118},{2,6680},{3,113},{4,113}],attr_plus = [{1,24},{2,1440},{3,24},{4,24}],combat = 6780,is_tv = 1};

get_lv_cfg(11) ->
	#wing_lv_cfg{lv = 11,max_exp = 26,attr = [{1,142},{2,8120},{3,137},{4,137}],attr_plus = [{1,8},{2,480},{3,8},{4,8}],combat = 8220,is_tv = 0};

get_lv_cfg(12) ->
	#wing_lv_cfg{lv = 12,max_exp = 28,attr = [{1,150},{2,8600},{3,145},{4,145}],attr_plus = [{1,9},{2,540},{3,9},{4,9}],combat = 8700,is_tv = 0};

get_lv_cfg(13) ->
	#wing_lv_cfg{lv = 13,max_exp = 30,attr = [{1,159},{2,9140},{3,154},{4,154}],attr_plus = [{1,10},{2,600},{3,10},{4,10}],combat = 9240,is_tv = 0};

get_lv_cfg(14) ->
	#wing_lv_cfg{lv = 14,max_exp = 33,attr = [{1,169},{2,9740},{3,164},{4,164}],attr_plus = [{1,11},{2,660},{3,11},{4,11}],combat = 9840,is_tv = 0};

get_lv_cfg(15) ->
	#wing_lv_cfg{lv = 15,max_exp = 36,attr = [{1,180},{2,10400},{3,175},{4,175}],attr_plus = [{1,12},{2,720},{3,12},{4,12}],combat = 10500,is_tv = 0};

get_lv_cfg(16) ->
	#wing_lv_cfg{lv = 16,max_exp = 39,attr = [{1,192},{2,11120},{3,187},{4,187}],attr_plus = [{1,13},{2,780},{3,13},{4,13}],combat = 11220,is_tv = 0};

get_lv_cfg(17) ->
	#wing_lv_cfg{lv = 17,max_exp = 42,attr = [{1,205},{2,11900},{3,200},{4,200}],attr_plus = [{1,14},{2,840},{3,14},{4,14}],combat = 12000,is_tv = 0};

get_lv_cfg(18) ->
	#wing_lv_cfg{lv = 18,max_exp = 45,attr = [{1,219},{2,12740},{3,214},{4,214}],attr_plus = [{1,15},{2,900},{3,15},{4,15}],combat = 12840,is_tv = 0};

get_lv_cfg(19) ->
	#wing_lv_cfg{lv = 19,max_exp = 48,attr = [{1,234},{2,13640},{3,229},{4,229}],attr_plus = [{1,16},{2,960},{3,16},{4,16}],combat = 13740,is_tv = 0};

get_lv_cfg(20) ->
	#wing_lv_cfg{lv = 20,max_exp = 51,attr = [{1,250},{2,14600},{3,245},{4,245}],attr_plus = [{1,24},{2,1440},{3,24},{4,24}],combat = 14700,is_tv = 1};

get_lv_cfg(21) ->
	#wing_lv_cfg{lv = 21,max_exp = 54,attr = [{1,274},{2,16040},{3,269},{4,269}],attr_plus = [{1,8},{2,480},{3,8},{4,8}],combat = 16140,is_tv = 0};

get_lv_cfg(22) ->
	#wing_lv_cfg{lv = 22,max_exp = 58,attr = [{1,282},{2,16520},{3,277},{4,277}],attr_plus = [{1,9},{2,540},{3,9},{4,9}],combat = 16620,is_tv = 0};

get_lv_cfg(23) ->
	#wing_lv_cfg{lv = 23,max_exp = 62,attr = [{1,291},{2,17060},{3,286},{4,286}],attr_plus = [{1,10},{2,600},{3,10},{4,10}],combat = 17160,is_tv = 0};

get_lv_cfg(24) ->
	#wing_lv_cfg{lv = 24,max_exp = 66,attr = [{1,301},{2,17660},{3,296},{4,296}],attr_plus = [{1,11},{2,660},{3,11},{4,11}],combat = 17760,is_tv = 0};

get_lv_cfg(25) ->
	#wing_lv_cfg{lv = 25,max_exp = 70,attr = [{1,312},{2,18320},{3,307},{4,307}],attr_plus = [{1,12},{2,720},{3,12},{4,12}],combat = 18420,is_tv = 0};

get_lv_cfg(26) ->
	#wing_lv_cfg{lv = 26,max_exp = 74,attr = [{1,324},{2,19040},{3,319},{4,319}],attr_plus = [{1,13},{2,780},{3,13},{4,13}],combat = 19140,is_tv = 0};

get_lv_cfg(27) ->
	#wing_lv_cfg{lv = 27,max_exp = 78,attr = [{1,337},{2,19820},{3,332},{4,332}],attr_plus = [{1,14},{2,840},{3,14},{4,14}],combat = 19920,is_tv = 0};

get_lv_cfg(28) ->
	#wing_lv_cfg{lv = 28,max_exp = 82,attr = [{1,351},{2,20660},{3,346},{4,346}],attr_plus = [{1,15},{2,900},{3,15},{4,15}],combat = 20760,is_tv = 0};

get_lv_cfg(29) ->
	#wing_lv_cfg{lv = 29,max_exp = 86,attr = [{1,366},{2,21560},{3,361},{4,361}],attr_plus = [{1,16},{2,960},{3,16},{4,16}],combat = 21660,is_tv = 0};

get_lv_cfg(30) ->
	#wing_lv_cfg{lv = 30,max_exp = 91,attr = [{1,382},{2,22520},{3,377},{4,377}],attr_plus = [{1,24},{2,1440},{3,24},{4,24}],combat = 22620,is_tv = 1};

get_lv_cfg(31) ->
	#wing_lv_cfg{lv = 31,max_exp = 96,attr = [{1,406},{2,23960},{3,401},{4,401}],attr_plus = [{1,8},{2,480},{3,8},{4,8}],combat = 24060,is_tv = 0};

get_lv_cfg(32) ->
	#wing_lv_cfg{lv = 32,max_exp = 101,attr = [{1,414},{2,24440},{3,409},{4,409}],attr_plus = [{1,9},{2,540},{3,9},{4,9}],combat = 24540,is_tv = 0};

get_lv_cfg(33) ->
	#wing_lv_cfg{lv = 33,max_exp = 106,attr = [{1,423},{2,24980},{3,418},{4,418}],attr_plus = [{1,10},{2,600},{3,10},{4,10}],combat = 25080,is_tv = 0};

get_lv_cfg(34) ->
	#wing_lv_cfg{lv = 34,max_exp = 111,attr = [{1,433},{2,25580},{3,428},{4,428}],attr_plus = [{1,11},{2,660},{3,11},{4,11}],combat = 25680,is_tv = 0};

get_lv_cfg(35) ->
	#wing_lv_cfg{lv = 35,max_exp = 116,attr = [{1,444},{2,26240},{3,439},{4,439}],attr_plus = [{1,12},{2,720},{3,12},{4,12}],combat = 26340,is_tv = 0};

get_lv_cfg(36) ->
	#wing_lv_cfg{lv = 36,max_exp = 121,attr = [{1,456},{2,26960},{3,451},{4,451}],attr_plus = [{1,13},{2,780},{3,13},{4,13}],combat = 27060,is_tv = 0};

get_lv_cfg(37) ->
	#wing_lv_cfg{lv = 37,max_exp = 126,attr = [{1,469},{2,27740},{3,464},{4,464}],attr_plus = [{1,14},{2,840},{3,14},{4,14}],combat = 27840,is_tv = 0};

get_lv_cfg(38) ->
	#wing_lv_cfg{lv = 38,max_exp = 132,attr = [{1,483},{2,28580},{3,478},{4,478}],attr_plus = [{1,15},{2,900},{3,15},{4,15}],combat = 28680,is_tv = 0};

get_lv_cfg(39) ->
	#wing_lv_cfg{lv = 39,max_exp = 138,attr = [{1,498},{2,29480},{3,493},{4,493}],attr_plus = [{1,16},{2,960},{3,16},{4,16}],combat = 29580,is_tv = 0};

get_lv_cfg(40) ->
	#wing_lv_cfg{lv = 40,max_exp = 144,attr = [{1,514},{2,30440},{3,509},{4,509}],attr_plus = [{1,24},{2,1440},{3,24},{4,24}],combat = 30540,is_tv = 1};

get_lv_cfg(41) ->
	#wing_lv_cfg{lv = 41,max_exp = 150,attr = [{1,538},{2,31880},{3,533},{4,533}],attr_plus = [{1,8},{2,480},{3,8},{4,8}],combat = 31980,is_tv = 0};

get_lv_cfg(42) ->
	#wing_lv_cfg{lv = 42,max_exp = 156,attr = [{1,546},{2,32360},{3,541},{4,541}],attr_plus = [{1,9},{2,540},{3,9},{4,9}],combat = 32460,is_tv = 0};

get_lv_cfg(43) ->
	#wing_lv_cfg{lv = 43,max_exp = 162,attr = [{1,555},{2,32900},{3,550},{4,550}],attr_plus = [{1,10},{2,600},{3,10},{4,10}],combat = 33000,is_tv = 0};

get_lv_cfg(44) ->
	#wing_lv_cfg{lv = 44,max_exp = 168,attr = [{1,565},{2,33500},{3,560},{4,560}],attr_plus = [{1,11},{2,660},{3,11},{4,11}],combat = 33600,is_tv = 0};

get_lv_cfg(45) ->
	#wing_lv_cfg{lv = 45,max_exp = 174,attr = [{1,576},{2,34160},{3,571},{4,571}],attr_plus = [{1,12},{2,720},{3,12},{4,12}],combat = 34260,is_tv = 0};

get_lv_cfg(46) ->
	#wing_lv_cfg{lv = 46,max_exp = 181,attr = [{1,588},{2,34880},{3,583},{4,583}],attr_plus = [{1,13},{2,780},{3,13},{4,13}],combat = 34980,is_tv = 0};

get_lv_cfg(47) ->
	#wing_lv_cfg{lv = 47,max_exp = 188,attr = [{1,601},{2,35660},{3,596},{4,596}],attr_plus = [{1,14},{2,840},{3,14},{4,14}],combat = 35760,is_tv = 0};

get_lv_cfg(48) ->
	#wing_lv_cfg{lv = 48,max_exp = 195,attr = [{1,615},{2,36500},{3,610},{4,610}],attr_plus = [{1,15},{2,900},{3,15},{4,15}],combat = 36600,is_tv = 0};

get_lv_cfg(49) ->
	#wing_lv_cfg{lv = 49,max_exp = 202,attr = [{1,630},{2,37400},{3,625},{4,625}],attr_plus = [{1,16},{2,960},{3,16},{4,16}],combat = 37500,is_tv = 0};

get_lv_cfg(50) ->
	#wing_lv_cfg{lv = 50,max_exp = 209,attr = [{1,646},{2,38360},{3,641},{4,641}],attr_plus = [{1,24},{2,1440},{3,24},{4,24}],combat = 38460,is_tv = 1};

get_lv_cfg(51) ->
	#wing_lv_cfg{lv = 51,max_exp = 216,attr = [{1,670},{2,39800},{3,665},{4,665}],attr_plus = [{1,8},{2,480},{3,8},{4,8}],combat = 39900,is_tv = 0};

get_lv_cfg(52) ->
	#wing_lv_cfg{lv = 52,max_exp = 223,attr = [{1,678},{2,40280},{3,673},{4,673}],attr_plus = [{1,9},{2,540},{3,9},{4,9}],combat = 40380,is_tv = 0};

get_lv_cfg(53) ->
	#wing_lv_cfg{lv = 53,max_exp = 230,attr = [{1,687},{2,40820},{3,682},{4,682}],attr_plus = [{1,10},{2,600},{3,10},{4,10}],combat = 40920,is_tv = 0};

get_lv_cfg(54) ->
	#wing_lv_cfg{lv = 54,max_exp = 238,attr = [{1,697},{2,41420},{3,692},{4,692}],attr_plus = [{1,11},{2,660},{3,11},{4,11}],combat = 41520,is_tv = 0};

get_lv_cfg(55) ->
	#wing_lv_cfg{lv = 55,max_exp = 246,attr = [{1,708},{2,42080},{3,703},{4,703}],attr_plus = [{1,12},{2,720},{3,12},{4,12}],combat = 42180,is_tv = 0};

get_lv_cfg(56) ->
	#wing_lv_cfg{lv = 56,max_exp = 254,attr = [{1,720},{2,42800},{3,715},{4,715}],attr_plus = [{1,13},{2,780},{3,13},{4,13}],combat = 42900,is_tv = 0};

get_lv_cfg(57) ->
	#wing_lv_cfg{lv = 57,max_exp = 262,attr = [{1,733},{2,43580},{3,728},{4,728}],attr_plus = [{1,14},{2,840},{3,14},{4,14}],combat = 43680,is_tv = 0};

get_lv_cfg(58) ->
	#wing_lv_cfg{lv = 58,max_exp = 270,attr = [{1,747},{2,44420},{3,742},{4,742}],attr_plus = [{1,15},{2,900},{3,15},{4,15}],combat = 44520,is_tv = 0};

get_lv_cfg(59) ->
	#wing_lv_cfg{lv = 59,max_exp = 278,attr = [{1,762},{2,45320},{3,757},{4,757}],attr_plus = [{1,16},{2,960},{3,16},{4,16}],combat = 45420,is_tv = 0};

get_lv_cfg(60) ->
	#wing_lv_cfg{lv = 60,max_exp = 286,attr = [{1,778},{2,46280},{3,773},{4,773}],attr_plus = [{1,24},{2,1440},{3,24},{4,24}],combat = 46380,is_tv = 1};

get_lv_cfg(61) ->
	#wing_lv_cfg{lv = 61,max_exp = 294,attr = [{1,802},{2,47720},{3,797},{4,797}],attr_plus = [{1,8},{2,480},{3,8},{4,8}],combat = 47820,is_tv = 0};

get_lv_cfg(62) ->
	#wing_lv_cfg{lv = 62,max_exp = 303,attr = [{1,810},{2,48200},{3,805},{4,805}],attr_plus = [{1,9},{2,540},{3,9},{4,9}],combat = 48300,is_tv = 0};

get_lv_cfg(63) ->
	#wing_lv_cfg{lv = 63,max_exp = 312,attr = [{1,819},{2,48740},{3,814},{4,814}],attr_plus = [{1,10},{2,600},{3,10},{4,10}],combat = 48840,is_tv = 0};

get_lv_cfg(64) ->
	#wing_lv_cfg{lv = 64,max_exp = 321,attr = [{1,829},{2,49340},{3,824},{4,824}],attr_plus = [{1,11},{2,660},{3,11},{4,11}],combat = 49440,is_tv = 0};

get_lv_cfg(65) ->
	#wing_lv_cfg{lv = 65,max_exp = 330,attr = [{1,840},{2,50000},{3,835},{4,835}],attr_plus = [{1,12},{2,720},{3,12},{4,12}],combat = 50100,is_tv = 0};

get_lv_cfg(66) ->
	#wing_lv_cfg{lv = 66,max_exp = 339,attr = [{1,852},{2,50720},{3,847},{4,847}],attr_plus = [{1,13},{2,780},{3,13},{4,13}],combat = 50820,is_tv = 0};

get_lv_cfg(67) ->
	#wing_lv_cfg{lv = 67,max_exp = 348,attr = [{1,865},{2,51500},{3,860},{4,860}],attr_plus = [{1,14},{2,840},{3,14},{4,14}],combat = 51600,is_tv = 0};

get_lv_cfg(68) ->
	#wing_lv_cfg{lv = 68,max_exp = 357,attr = [{1,879},{2,52340},{3,874},{4,874}],attr_plus = [{1,15},{2,900},{3,15},{4,15}],combat = 52440,is_tv = 0};

get_lv_cfg(69) ->
	#wing_lv_cfg{lv = 69,max_exp = 366,attr = [{1,894},{2,53240},{3,889},{4,889}],attr_plus = [{1,16},{2,960},{3,16},{4,16}],combat = 53340,is_tv = 0};

get_lv_cfg(70) ->
	#wing_lv_cfg{lv = 70,max_exp = 376,attr = [{1,910},{2,54200},{3,905},{4,905}],attr_plus = [{1,24},{2,1440},{3,24},{4,24}],combat = 54300,is_tv = 1};

get_lv_cfg(71) ->
	#wing_lv_cfg{lv = 71,max_exp = 386,attr = [{1,934},{2,55640},{3,929},{4,929}],attr_plus = [{1,8},{2,480},{3,8},{4,8}],combat = 55740,is_tv = 0};

get_lv_cfg(72) ->
	#wing_lv_cfg{lv = 72,max_exp = 396,attr = [{1,942},{2,56120},{3,937},{4,937}],attr_plus = [{1,9},{2,540},{3,9},{4,9}],combat = 56220,is_tv = 0};

get_lv_cfg(73) ->
	#wing_lv_cfg{lv = 73,max_exp = 406,attr = [{1,951},{2,56660},{3,946},{4,946}],attr_plus = [{1,10},{2,600},{3,10},{4,10}],combat = 56760,is_tv = 0};

get_lv_cfg(74) ->
	#wing_lv_cfg{lv = 74,max_exp = 416,attr = [{1,961},{2,57260},{3,956},{4,956}],attr_plus = [{1,11},{2,660},{3,11},{4,11}],combat = 57360,is_tv = 0};

get_lv_cfg(75) ->
	#wing_lv_cfg{lv = 75,max_exp = 426,attr = [{1,972},{2,57920},{3,967},{4,967}],attr_plus = [{1,12},{2,720},{3,12},{4,12}],combat = 58020,is_tv = 0};

get_lv_cfg(76) ->
	#wing_lv_cfg{lv = 76,max_exp = 436,attr = [{1,984},{2,58640},{3,979},{4,979}],attr_plus = [{1,13},{2,780},{3,13},{4,13}],combat = 58740,is_tv = 0};

get_lv_cfg(77) ->
	#wing_lv_cfg{lv = 77,max_exp = 446,attr = [{1,997},{2,59420},{3,992},{4,992}],attr_plus = [{1,14},{2,840},{3,14},{4,14}],combat = 59520,is_tv = 0};

get_lv_cfg(78) ->
	#wing_lv_cfg{lv = 78,max_exp = 457,attr = [{1,1011},{2,60260},{3,1006},{4,1006}],attr_plus = [{1,15},{2,900},{3,15},{4,15}],combat = 60360,is_tv = 0};

get_lv_cfg(79) ->
	#wing_lv_cfg{lv = 79,max_exp = 468,attr = [{1,1026},{2,61160},{3,1021},{4,1021}],attr_plus = [{1,16},{2,960},{3,16},{4,16}],combat = 61260,is_tv = 0};

get_lv_cfg(80) ->
	#wing_lv_cfg{lv = 80,max_exp = 479,attr = [{1,1042},{2,62120},{3,1037},{4,1037}],attr_plus = [{1,24},{2,1440},{3,24},{4,24}],combat = 62220,is_tv = 1};

get_lv_cfg(81) ->
	#wing_lv_cfg{lv = 81,max_exp = 490,attr = [{1,1066},{2,63560},{3,1061},{4,1061}],attr_plus = [{1,8},{2,480},{3,8},{4,8}],combat = 63660,is_tv = 0};

get_lv_cfg(82) ->
	#wing_lv_cfg{lv = 82,max_exp = 501,attr = [{1,1074},{2,64040},{3,1069},{4,1069}],attr_plus = [{1,9},{2,540},{3,9},{4,9}],combat = 64140,is_tv = 0};

get_lv_cfg(83) ->
	#wing_lv_cfg{lv = 83,max_exp = 512,attr = [{1,1083},{2,64580},{3,1078},{4,1078}],attr_plus = [{1,10},{2,600},{3,10},{4,10}],combat = 64680,is_tv = 0};

get_lv_cfg(84) ->
	#wing_lv_cfg{lv = 84,max_exp = 523,attr = [{1,1093},{2,65180},{3,1088},{4,1088}],attr_plus = [{1,11},{2,660},{3,11},{4,11}],combat = 65280,is_tv = 0};

get_lv_cfg(85) ->
	#wing_lv_cfg{lv = 85,max_exp = 534,attr = [{1,1104},{2,65840},{3,1099},{4,1099}],attr_plus = [{1,12},{2,720},{3,12},{4,12}],combat = 65940,is_tv = 0};

get_lv_cfg(86) ->
	#wing_lv_cfg{lv = 86,max_exp = 546,attr = [{1,1116},{2,66560},{3,1111},{4,1111}],attr_plus = [{1,13},{2,780},{3,13},{4,13}],combat = 66660,is_tv = 0};

get_lv_cfg(87) ->
	#wing_lv_cfg{lv = 87,max_exp = 558,attr = [{1,1129},{2,67340},{3,1124},{4,1124}],attr_plus = [{1,14},{2,840},{3,14},{4,14}],combat = 67440,is_tv = 0};

get_lv_cfg(88) ->
	#wing_lv_cfg{lv = 88,max_exp = 570,attr = [{1,1143},{2,68180},{3,1138},{4,1138}],attr_plus = [{1,15},{2,900},{3,15},{4,15}],combat = 68280,is_tv = 0};

get_lv_cfg(89) ->
	#wing_lv_cfg{lv = 89,max_exp = 582,attr = [{1,1158},{2,69080},{3,1153},{4,1153}],attr_plus = [{1,16},{2,960},{3,16},{4,16}],combat = 69180,is_tv = 0};

get_lv_cfg(90) ->
	#wing_lv_cfg{lv = 90,max_exp = 594,attr = [{1,1174},{2,70040},{3,1169},{4,1169}],attr_plus = [{1,24},{2,1440},{3,24},{4,24}],combat = 70140,is_tv = 1};

get_lv_cfg(91) ->
	#wing_lv_cfg{lv = 91,max_exp = 606,attr = [{1,1198},{2,71480},{3,1193},{4,1193}],attr_plus = [{1,8},{2,480},{3,8},{4,8}],combat = 71580,is_tv = 0};

get_lv_cfg(92) ->
	#wing_lv_cfg{lv = 92,max_exp = 618,attr = [{1,1206},{2,71960},{3,1201},{4,1201}],attr_plus = [{1,9},{2,540},{3,9},{4,9}],combat = 72060,is_tv = 0};

get_lv_cfg(93) ->
	#wing_lv_cfg{lv = 93,max_exp = 630,attr = [{1,1215},{2,72500},{3,1210},{4,1210}],attr_plus = [{1,10},{2,600},{3,10},{4,10}],combat = 72600,is_tv = 0};

get_lv_cfg(94) ->
	#wing_lv_cfg{lv = 94,max_exp = 643,attr = [{1,1225},{2,73100},{3,1220},{4,1220}],attr_plus = [{1,11},{2,660},{3,11},{4,11}],combat = 73200,is_tv = 0};

get_lv_cfg(95) ->
	#wing_lv_cfg{lv = 95,max_exp = 656,attr = [{1,1236},{2,73760},{3,1231},{4,1231}],attr_plus = [{1,12},{2,720},{3,12},{4,12}],combat = 73860,is_tv = 0};

get_lv_cfg(96) ->
	#wing_lv_cfg{lv = 96,max_exp = 669,attr = [{1,1248},{2,74480},{3,1243},{4,1243}],attr_plus = [{1,13},{2,780},{3,13},{4,13}],combat = 74580,is_tv = 0};

get_lv_cfg(97) ->
	#wing_lv_cfg{lv = 97,max_exp = 682,attr = [{1,1261},{2,75260},{3,1256},{4,1256}],attr_plus = [{1,14},{2,840},{3,14},{4,14}],combat = 75360,is_tv = 0};

get_lv_cfg(98) ->
	#wing_lv_cfg{lv = 98,max_exp = 695,attr = [{1,1275},{2,76100},{3,1270},{4,1270}],attr_plus = [{1,15},{2,900},{3,15},{4,15}],combat = 76200,is_tv = 0};

get_lv_cfg(99) ->
	#wing_lv_cfg{lv = 99,max_exp = 708,attr = [{1,1290},{2,77000},{3,1285},{4,1285}],attr_plus = [{1,16},{2,960},{3,16},{4,16}],combat = 77100,is_tv = 0};

get_lv_cfg(100) ->
	#wing_lv_cfg{lv = 100,max_exp = 721,attr = [{1,1306},{2,77960},{3,1301},{4,1301}],attr_plus = [{1,24},{2,1440},{3,24},{4,24}],combat = 78060,is_tv = 1};

get_lv_cfg(101) ->
	#wing_lv_cfg{lv = 101,max_exp = 734,attr = [{1,1330},{2,79400},{3,1325},{4,1325}],attr_plus = [{1,8},{2,480},{3,8},{4,8}],combat = 79500,is_tv = 0};

get_lv_cfg(102) ->
	#wing_lv_cfg{lv = 102,max_exp = 748,attr = [{1,1338},{2,79880},{3,1333},{4,1333}],attr_plus = [{1,9},{2,540},{3,9},{4,9}],combat = 79980,is_tv = 0};

get_lv_cfg(103) ->
	#wing_lv_cfg{lv = 103,max_exp = 762,attr = [{1,1347},{2,80420},{3,1342},{4,1342}],attr_plus = [{1,10},{2,600},{3,10},{4,10}],combat = 80520,is_tv = 0};

get_lv_cfg(104) ->
	#wing_lv_cfg{lv = 104,max_exp = 776,attr = [{1,1357},{2,81020},{3,1352},{4,1352}],attr_plus = [{1,11},{2,660},{3,11},{4,11}],combat = 81120,is_tv = 0};

get_lv_cfg(105) ->
	#wing_lv_cfg{lv = 105,max_exp = 790,attr = [{1,1368},{2,81680},{3,1363},{4,1363}],attr_plus = [{1,12},{2,720},{3,12},{4,12}],combat = 81780,is_tv = 0};

get_lv_cfg(106) ->
	#wing_lv_cfg{lv = 106,max_exp = 804,attr = [{1,1380},{2,82400},{3,1375},{4,1375}],attr_plus = [{1,13},{2,780},{3,13},{4,13}],combat = 82500,is_tv = 0};

get_lv_cfg(107) ->
	#wing_lv_cfg{lv = 107,max_exp = 818,attr = [{1,1393},{2,83180},{3,1388},{4,1388}],attr_plus = [{1,14},{2,840},{3,14},{4,14}],combat = 83280,is_tv = 0};

get_lv_cfg(108) ->
	#wing_lv_cfg{lv = 108,max_exp = 832,attr = [{1,1407},{2,84020},{3,1402},{4,1402}],attr_plus = [{1,15},{2,900},{3,15},{4,15}],combat = 84120,is_tv = 0};

get_lv_cfg(109) ->
	#wing_lv_cfg{lv = 109,max_exp = 846,attr = [{1,1422},{2,84920},{3,1417},{4,1417}],attr_plus = [{1,16},{2,960},{3,16},{4,16}],combat = 85020,is_tv = 0};

get_lv_cfg(110) ->
	#wing_lv_cfg{lv = 110,max_exp = 861,attr = [{1,1438},{2,85880},{3,1433},{4,1433}],attr_plus = [{1,24},{2,1440},{3,24},{4,24}],combat = 85980,is_tv = 1};

get_lv_cfg(111) ->
	#wing_lv_cfg{lv = 111,max_exp = 876,attr = [{1,1462},{2,87320},{3,1457},{4,1457}],attr_plus = [{1,8},{2,480},{3,8},{4,8}],combat = 87420,is_tv = 0};

get_lv_cfg(112) ->
	#wing_lv_cfg{lv = 112,max_exp = 891,attr = [{1,1470},{2,87800},{3,1465},{4,1465}],attr_plus = [{1,9},{2,540},{3,9},{4,9}],combat = 87900,is_tv = 0};

get_lv_cfg(113) ->
	#wing_lv_cfg{lv = 113,max_exp = 906,attr = [{1,1479},{2,88340},{3,1474},{4,1474}],attr_plus = [{1,10},{2,600},{3,10},{4,10}],combat = 88440,is_tv = 0};

get_lv_cfg(114) ->
	#wing_lv_cfg{lv = 114,max_exp = 921,attr = [{1,1489},{2,88940},{3,1484},{4,1484}],attr_plus = [{1,11},{2,660},{3,11},{4,11}],combat = 89040,is_tv = 0};

get_lv_cfg(115) ->
	#wing_lv_cfg{lv = 115,max_exp = 936,attr = [{1,1500},{2,89600},{3,1495},{4,1495}],attr_plus = [{1,12},{2,720},{3,12},{4,12}],combat = 89700,is_tv = 0};

get_lv_cfg(116) ->
	#wing_lv_cfg{lv = 116,max_exp = 951,attr = [{1,1512},{2,90320},{3,1507},{4,1507}],attr_plus = [{1,13},{2,780},{3,13},{4,13}],combat = 90420,is_tv = 0};

get_lv_cfg(117) ->
	#wing_lv_cfg{lv = 117,max_exp = 966,attr = [{1,1525},{2,91100},{3,1520},{4,1520}],attr_plus = [{1,14},{2,840},{3,14},{4,14}],combat = 91200,is_tv = 0};

get_lv_cfg(118) ->
	#wing_lv_cfg{lv = 118,max_exp = 982,attr = [{1,1539},{2,91940},{3,1534},{4,1534}],attr_plus = [{1,15},{2,900},{3,15},{4,15}],combat = 92040,is_tv = 0};

get_lv_cfg(119) ->
	#wing_lv_cfg{lv = 119,max_exp = 998,attr = [{1,1554},{2,92840},{3,1549},{4,1549}],attr_plus = [{1,16},{2,960},{3,16},{4,16}],combat = 92940,is_tv = 0};

get_lv_cfg(120) ->
	#wing_lv_cfg{lv = 120,max_exp = 1014,attr = [{1,1570},{2,93800},{3,1565},{4,1565}],attr_plus = [{1,8},{2,480},{3,8},{4,8}],combat = 93900,is_tv = 1};

get_lv_cfg(121) ->
	#wing_lv_cfg{lv = 121,max_exp = 1018,attr = [{1,1578},{2,94280},{3,1573},{4,1573}],attr_plus = [{1,9},{2,540},{3,9},{4,9}],combat = 94380,is_tv = 0};

get_lv_cfg(122) ->
	#wing_lv_cfg{lv = 122,max_exp = 1022,attr = [{1,1587},{2,94820},{3,1582},{4,1582}],attr_plus = [{1,10},{2,600},{3,10},{4,10}],combat = 94920,is_tv = 0};

get_lv_cfg(123) ->
	#wing_lv_cfg{lv = 123,max_exp = 1026,attr = [{1,1597},{2,95420},{3,1592},{4,1592}],attr_plus = [{1,11},{2,660},{3,11},{4,11}],combat = 95520,is_tv = 0};

get_lv_cfg(124) ->
	#wing_lv_cfg{lv = 124,max_exp = 1030,attr = [{1,1608},{2,96080},{3,1603},{4,1603}],attr_plus = [{1,12},{2,720},{3,12},{4,12}],combat = 96180,is_tv = 0};

get_lv_cfg(125) ->
	#wing_lv_cfg{lv = 125,max_exp = 1034,attr = [{1,1620},{2,96800},{3,1615},{4,1615}],attr_plus = [{1,13},{2,780},{3,13},{4,13}],combat = 96900,is_tv = 0};

get_lv_cfg(126) ->
	#wing_lv_cfg{lv = 126,max_exp = 1038,attr = [{1,1633},{2,97580},{3,1628},{4,1628}],attr_plus = [{1,14},{2,840},{3,14},{4,14}],combat = 97680,is_tv = 0};

get_lv_cfg(127) ->
	#wing_lv_cfg{lv = 127,max_exp = 1042,attr = [{1,1647},{2,98420},{3,1642},{4,1642}],attr_plus = [{1,15},{2,900},{3,15},{4,15}],combat = 98520,is_tv = 0};

get_lv_cfg(128) ->
	#wing_lv_cfg{lv = 128,max_exp = 1046,attr = [{1,1662},{2,99320},{3,1657},{4,1657}],attr_plus = [{1,16},{2,960},{3,16},{4,16}],combat = 99420,is_tv = 0};

get_lv_cfg(129) ->
	#wing_lv_cfg{lv = 129,max_exp = 1050,attr = [{1,1678},{2,100280},{3,1673},{4,1673}],attr_plus = [{1,24},{2,1440},{3,24},{4,24}],combat = 100380,is_tv = 0};

get_lv_cfg(130) ->
	#wing_lv_cfg{lv = 130,max_exp = 1054,attr = [{1,1702},{2,101720},{3,1697},{4,1697}],attr_plus = [{1,8},{2,480},{3,8},{4,8}],combat = 101820,is_tv = 1};

get_lv_cfg(131) ->
	#wing_lv_cfg{lv = 131,max_exp = 1058,attr = [{1,1710},{2,102200},{3,1705},{4,1705}],attr_plus = [{1,9},{2,540},{3,9},{4,9}],combat = 102300,is_tv = 0};

get_lv_cfg(132) ->
	#wing_lv_cfg{lv = 132,max_exp = 1062,attr = [{1,1719},{2,102740},{3,1714},{4,1714}],attr_plus = [{1,10},{2,600},{3,10},{4,10}],combat = 102840,is_tv = 0};

get_lv_cfg(133) ->
	#wing_lv_cfg{lv = 133,max_exp = 1066,attr = [{1,1729},{2,103340},{3,1724},{4,1724}],attr_plus = [{1,11},{2,660},{3,11},{4,11}],combat = 103440,is_tv = 0};

get_lv_cfg(134) ->
	#wing_lv_cfg{lv = 134,max_exp = 1070,attr = [{1,1740},{2,104000},{3,1735},{4,1735}],attr_plus = [{1,12},{2,720},{3,12},{4,12}],combat = 104100,is_tv = 0};

get_lv_cfg(135) ->
	#wing_lv_cfg{lv = 135,max_exp = 1074,attr = [{1,1752},{2,104720},{3,1747},{4,1747}],attr_plus = [{1,13},{2,780},{3,13},{4,13}],combat = 104820,is_tv = 0};

get_lv_cfg(136) ->
	#wing_lv_cfg{lv = 136,max_exp = 1078,attr = [{1,1765},{2,105500},{3,1760},{4,1760}],attr_plus = [{1,14},{2,840},{3,14},{4,14}],combat = 105600,is_tv = 0};

get_lv_cfg(137) ->
	#wing_lv_cfg{lv = 137,max_exp = 1082,attr = [{1,1779},{2,106340},{3,1774},{4,1774}],attr_plus = [{1,15},{2,900},{3,15},{4,15}],combat = 106440,is_tv = 0};

get_lv_cfg(138) ->
	#wing_lv_cfg{lv = 138,max_exp = 1086,attr = [{1,1794},{2,107240},{3,1789},{4,1789}],attr_plus = [{1,16},{2,960},{3,16},{4,16}],combat = 107340,is_tv = 0};

get_lv_cfg(139) ->
	#wing_lv_cfg{lv = 139,max_exp = 1090,attr = [{1,1810},{2,108200},{3,1805},{4,1805}],attr_plus = [{1,24},{2,1440},{3,24},{4,24}],combat = 108300,is_tv = 0};

get_lv_cfg(140) ->
	#wing_lv_cfg{lv = 140,max_exp = 1094,attr = [{1,1834},{2,109640},{3,1829},{4,1829}],attr_plus = [{1,8},{2,480},{3,8},{4,8}],combat = 109740,is_tv = 1};

get_lv_cfg(141) ->
	#wing_lv_cfg{lv = 141,max_exp = 1098,attr = [{1,1842},{2,110120},{3,1837},{4,1837}],attr_plus = [{1,9},{2,540},{3,9},{4,9}],combat = 110220,is_tv = 0};

get_lv_cfg(142) ->
	#wing_lv_cfg{lv = 142,max_exp = 1102,attr = [{1,1851},{2,110660},{3,1846},{4,1846}],attr_plus = [{1,10},{2,600},{3,10},{4,10}],combat = 110760,is_tv = 0};

get_lv_cfg(143) ->
	#wing_lv_cfg{lv = 143,max_exp = 1106,attr = [{1,1861},{2,111260},{3,1856},{4,1856}],attr_plus = [{1,11},{2,660},{3,11},{4,11}],combat = 111360,is_tv = 0};

get_lv_cfg(144) ->
	#wing_lv_cfg{lv = 144,max_exp = 1110,attr = [{1,1872},{2,111920},{3,1867},{4,1867}],attr_plus = [{1,12},{2,720},{3,12},{4,12}],combat = 112020,is_tv = 0};

get_lv_cfg(145) ->
	#wing_lv_cfg{lv = 145,max_exp = 1114,attr = [{1,1884},{2,112640},{3,1879},{4,1879}],attr_plus = [{1,13},{2,780},{3,13},{4,13}],combat = 112740,is_tv = 0};

get_lv_cfg(146) ->
	#wing_lv_cfg{lv = 146,max_exp = 1118,attr = [{1,1897},{2,113420},{3,1892},{4,1892}],attr_plus = [{1,14},{2,840},{3,14},{4,14}],combat = 113520,is_tv = 0};

get_lv_cfg(147) ->
	#wing_lv_cfg{lv = 147,max_exp = 1122,attr = [{1,1911},{2,114260},{3,1906},{4,1906}],attr_plus = [{1,15},{2,900},{3,15},{4,15}],combat = 114360,is_tv = 0};

get_lv_cfg(148) ->
	#wing_lv_cfg{lv = 148,max_exp = 1126,attr = [{1,1926},{2,115160},{3,1921},{4,1921}],attr_plus = [{1,16},{2,960},{3,16},{4,16}],combat = 115260,is_tv = 0};

get_lv_cfg(149) ->
	#wing_lv_cfg{lv = 149,max_exp = 1130,attr = [{1,1942},{2,116120},{3,1937},{4,1937}],attr_plus = [{1,24},{2,1440},{3,24},{4,24}],combat = 116220,is_tv = 0};

get_lv_cfg(150) ->
	#wing_lv_cfg{lv = 150,max_exp = 1134,attr = [{1,1966},{2,117560},{3,1961},{4,1961}],attr_plus = [{1,8},{2,480},{3,8},{4,8}],combat = 117660,is_tv = 1};

get_lv_cfg(151) ->
	#wing_lv_cfg{lv = 151,max_exp = 1138,attr = [{1,1974},{2,118040},{3,1969},{4,1969}],attr_plus = [{1,9},{2,540},{3,9},{4,9}],combat = 118140,is_tv = 0};

get_lv_cfg(152) ->
	#wing_lv_cfg{lv = 152,max_exp = 1142,attr = [{1,1983},{2,118580},{3,1978},{4,1978}],attr_plus = [{1,10},{2,600},{3,10},{4,10}],combat = 118680,is_tv = 0};

get_lv_cfg(153) ->
	#wing_lv_cfg{lv = 153,max_exp = 1146,attr = [{1,1993},{2,119180},{3,1988},{4,1988}],attr_plus = [{1,11},{2,660},{3,11},{4,11}],combat = 119280,is_tv = 0};

get_lv_cfg(154) ->
	#wing_lv_cfg{lv = 154,max_exp = 1150,attr = [{1,2004},{2,119840},{3,1999},{4,1999}],attr_plus = [{1,12},{2,720},{3,12},{4,12}],combat = 119940,is_tv = 0};

get_lv_cfg(155) ->
	#wing_lv_cfg{lv = 155,max_exp = 1154,attr = [{1,2016},{2,120560},{3,2011},{4,2011}],attr_plus = [{1,13},{2,780},{3,13},{4,13}],combat = 120660,is_tv = 0};

get_lv_cfg(156) ->
	#wing_lv_cfg{lv = 156,max_exp = 1158,attr = [{1,2029},{2,121340},{3,2024},{4,2024}],attr_plus = [{1,14},{2,840},{3,14},{4,14}],combat = 121440,is_tv = 0};

get_lv_cfg(157) ->
	#wing_lv_cfg{lv = 157,max_exp = 1162,attr = [{1,2043},{2,122180},{3,2038},{4,2038}],attr_plus = [{1,15},{2,900},{3,15},{4,15}],combat = 122280,is_tv = 0};

get_lv_cfg(158) ->
	#wing_lv_cfg{lv = 158,max_exp = 1166,attr = [{1,2058},{2,123080},{3,2053},{4,2053}],attr_plus = [{1,16},{2,960},{3,16},{4,16}],combat = 123180,is_tv = 0};

get_lv_cfg(159) ->
	#wing_lv_cfg{lv = 159,max_exp = 1170,attr = [{1,2074},{2,124040},{3,2069},{4,2069}],attr_plus = [{1,24},{2,1440},{3,24},{4,24}],combat = 124140,is_tv = 0};

get_lv_cfg(160) ->
	#wing_lv_cfg{lv = 160,max_exp = 1174,attr = [{1,2098},{2,125480},{3,2093},{4,2093}],attr_plus = [{1,8},{2,480},{3,8},{4,8}],combat = 125580,is_tv = 1};

get_lv_cfg(161) ->
	#wing_lv_cfg{lv = 161,max_exp = 1178,attr = [{1,2106},{2,125960},{3,2101},{4,2101}],attr_plus = [{1,9},{2,540},{3,9},{4,9}],combat = 126060,is_tv = 0};

get_lv_cfg(162) ->
	#wing_lv_cfg{lv = 162,max_exp = 1182,attr = [{1,2115},{2,126500},{3,2110},{4,2110}],attr_plus = [{1,10},{2,600},{3,10},{4,10}],combat = 126600,is_tv = 0};

get_lv_cfg(163) ->
	#wing_lv_cfg{lv = 163,max_exp = 1186,attr = [{1,2125},{2,127100},{3,2120},{4,2120}],attr_plus = [{1,11},{2,660},{3,11},{4,11}],combat = 127200,is_tv = 0};

get_lv_cfg(164) ->
	#wing_lv_cfg{lv = 164,max_exp = 1190,attr = [{1,2136},{2,127760},{3,2131},{4,2131}],attr_plus = [{1,12},{2,720},{3,12},{4,12}],combat = 127860,is_tv = 0};

get_lv_cfg(165) ->
	#wing_lv_cfg{lv = 165,max_exp = 1194,attr = [{1,2148},{2,128480},{3,2143},{4,2143}],attr_plus = [{1,13},{2,780},{3,13},{4,13}],combat = 128580,is_tv = 0};

get_lv_cfg(166) ->
	#wing_lv_cfg{lv = 166,max_exp = 1198,attr = [{1,2161},{2,129260},{3,2156},{4,2156}],attr_plus = [{1,14},{2,840},{3,14},{4,14}],combat = 129360,is_tv = 0};

get_lv_cfg(167) ->
	#wing_lv_cfg{lv = 167,max_exp = 1202,attr = [{1,2175},{2,130100},{3,2170},{4,2170}],attr_plus = [{1,15},{2,900},{3,15},{4,15}],combat = 130200,is_tv = 0};

get_lv_cfg(168) ->
	#wing_lv_cfg{lv = 168,max_exp = 1206,attr = [{1,2190},{2,131000},{3,2185},{4,2185}],attr_plus = [{1,16},{2,960},{3,16},{4,16}],combat = 131100,is_tv = 0};

get_lv_cfg(169) ->
	#wing_lv_cfg{lv = 169,max_exp = 1210,attr = [{1,2206},{2,131960},{3,2201},{4,2201}],attr_plus = [{1,24},{2,1440},{3,24},{4,24}],combat = 132060,is_tv = 0};

get_lv_cfg(170) ->
	#wing_lv_cfg{lv = 170,max_exp = 1214,attr = [{1,2230},{2,133400},{3,2225},{4,2225}],attr_plus = [{1,8},{2,480},{3,8},{4,8}],combat = 133500,is_tv = 1};

get_lv_cfg(171) ->
	#wing_lv_cfg{lv = 171,max_exp = 1218,attr = [{1,2238},{2,133880},{3,2233},{4,2233}],attr_plus = [{1,9},{2,540},{3,9},{4,9}],combat = 133980,is_tv = 0};

get_lv_cfg(172) ->
	#wing_lv_cfg{lv = 172,max_exp = 1222,attr = [{1,2247},{2,134420},{3,2242},{4,2242}],attr_plus = [{1,10},{2,600},{3,10},{4,10}],combat = 134520,is_tv = 0};

get_lv_cfg(173) ->
	#wing_lv_cfg{lv = 173,max_exp = 1226,attr = [{1,2257},{2,135020},{3,2252},{4,2252}],attr_plus = [{1,11},{2,660},{3,11},{4,11}],combat = 135120,is_tv = 0};

get_lv_cfg(174) ->
	#wing_lv_cfg{lv = 174,max_exp = 1230,attr = [{1,2268},{2,135680},{3,2263},{4,2263}],attr_plus = [{1,12},{2,720},{3,12},{4,12}],combat = 135780,is_tv = 0};

get_lv_cfg(175) ->
	#wing_lv_cfg{lv = 175,max_exp = 1234,attr = [{1,2280},{2,136400},{3,2275},{4,2275}],attr_plus = [{1,13},{2,780},{3,13},{4,13}],combat = 136500,is_tv = 0};

get_lv_cfg(176) ->
	#wing_lv_cfg{lv = 176,max_exp = 1238,attr = [{1,2293},{2,137180},{3,2288},{4,2288}],attr_plus = [{1,14},{2,840},{3,14},{4,14}],combat = 137280,is_tv = 0};

get_lv_cfg(177) ->
	#wing_lv_cfg{lv = 177,max_exp = 1242,attr = [{1,2307},{2,138020},{3,2302},{4,2302}],attr_plus = [{1,15},{2,900},{3,15},{4,15}],combat = 138120,is_tv = 0};

get_lv_cfg(178) ->
	#wing_lv_cfg{lv = 178,max_exp = 1246,attr = [{1,2322},{2,138920},{3,2317},{4,2317}],attr_plus = [{1,16},{2,960},{3,16},{4,16}],combat = 139020,is_tv = 0};

get_lv_cfg(179) ->
	#wing_lv_cfg{lv = 179,max_exp = 1250,attr = [{1,2338},{2,139880},{3,2333},{4,2333}],attr_plus = [{1,24},{2,1440},{3,24},{4,24}],combat = 139980,is_tv = 0};

get_lv_cfg(180) ->
	#wing_lv_cfg{lv = 180,max_exp = 1254,attr = [{1,2362},{2,141320},{3,2357},{4,2357}],attr_plus = [{1,8},{2,480},{3,8},{4,8}],combat = 141420,is_tv = 1};

get_lv_cfg(181) ->
	#wing_lv_cfg{lv = 181,max_exp = 1258,attr = [{1,2370},{2,141800},{3,2365},{4,2365}],attr_plus = [{1,9},{2,540},{3,9},{4,9}],combat = 141900,is_tv = 0};

get_lv_cfg(182) ->
	#wing_lv_cfg{lv = 182,max_exp = 1262,attr = [{1,2379},{2,142340},{3,2374},{4,2374}],attr_plus = [{1,10},{2,600},{3,10},{4,10}],combat = 142440,is_tv = 0};

get_lv_cfg(183) ->
	#wing_lv_cfg{lv = 183,max_exp = 1266,attr = [{1,2389},{2,142940},{3,2384},{4,2384}],attr_plus = [{1,11},{2,660},{3,11},{4,11}],combat = 143040,is_tv = 0};

get_lv_cfg(184) ->
	#wing_lv_cfg{lv = 184,max_exp = 1270,attr = [{1,2400},{2,143600},{3,2395},{4,2395}],attr_plus = [{1,12},{2,720},{3,12},{4,12}],combat = 143700,is_tv = 0};

get_lv_cfg(185) ->
	#wing_lv_cfg{lv = 185,max_exp = 1274,attr = [{1,2412},{2,144320},{3,2407},{4,2407}],attr_plus = [{1,13},{2,780},{3,13},{4,13}],combat = 144420,is_tv = 0};

get_lv_cfg(186) ->
	#wing_lv_cfg{lv = 186,max_exp = 1278,attr = [{1,2425},{2,145100},{3,2420},{4,2420}],attr_plus = [{1,14},{2,840},{3,14},{4,14}],combat = 145200,is_tv = 0};

get_lv_cfg(187) ->
	#wing_lv_cfg{lv = 187,max_exp = 1282,attr = [{1,2439},{2,145940},{3,2434},{4,2434}],attr_plus = [{1,15},{2,900},{3,15},{4,15}],combat = 146040,is_tv = 0};

get_lv_cfg(188) ->
	#wing_lv_cfg{lv = 188,max_exp = 1286,attr = [{1,2454},{2,146840},{3,2449},{4,2449}],attr_plus = [{1,16},{2,960},{3,16},{4,16}],combat = 146940,is_tv = 0};

get_lv_cfg(189) ->
	#wing_lv_cfg{lv = 189,max_exp = 1290,attr = [{1,2470},{2,147800},{3,2465},{4,2465}],attr_plus = [{1,24},{2,1440},{3,24},{4,24}],combat = 147900,is_tv = 0};

get_lv_cfg(190) ->
	#wing_lv_cfg{lv = 190,max_exp = 1294,attr = [{1,2494},{2,149240},{3,2489},{4,2489}],attr_plus = [{1,8},{2,480},{3,8},{4,8}],combat = 149340,is_tv = 1};

get_lv_cfg(191) ->
	#wing_lv_cfg{lv = 191,max_exp = 1298,attr = [{1,2502},{2,149720},{3,2497},{4,2497}],attr_plus = [{1,9},{2,540},{3,9},{4,9}],combat = 149820,is_tv = 0};

get_lv_cfg(192) ->
	#wing_lv_cfg{lv = 192,max_exp = 1302,attr = [{1,2511},{2,150260},{3,2506},{4,2506}],attr_plus = [{1,10},{2,600},{3,10},{4,10}],combat = 150360,is_tv = 0};

get_lv_cfg(193) ->
	#wing_lv_cfg{lv = 193,max_exp = 1306,attr = [{1,2521},{2,150860},{3,2516},{4,2516}],attr_plus = [{1,11},{2,660},{3,11},{4,11}],combat = 150960,is_tv = 0};

get_lv_cfg(194) ->
	#wing_lv_cfg{lv = 194,max_exp = 1310,attr = [{1,2532},{2,151520},{3,2527},{4,2527}],attr_plus = [{1,12},{2,720},{3,12},{4,12}],combat = 151620,is_tv = 0};

get_lv_cfg(195) ->
	#wing_lv_cfg{lv = 195,max_exp = 1314,attr = [{1,2544},{2,152240},{3,2539},{4,2539}],attr_plus = [{1,13},{2,780},{3,13},{4,13}],combat = 152340,is_tv = 0};

get_lv_cfg(196) ->
	#wing_lv_cfg{lv = 196,max_exp = 1318,attr = [{1,2557},{2,153020},{3,2552},{4,2552}],attr_plus = [{1,14},{2,840},{3,14},{4,14}],combat = 153120,is_tv = 0};

get_lv_cfg(197) ->
	#wing_lv_cfg{lv = 197,max_exp = 1322,attr = [{1,2571},{2,153860},{3,2566},{4,2566}],attr_plus = [{1,15},{2,900},{3,15},{4,15}],combat = 153960,is_tv = 0};

get_lv_cfg(198) ->
	#wing_lv_cfg{lv = 198,max_exp = 1326,attr = [{1,2586},{2,154760},{3,2581},{4,2581}],attr_plus = [{1,16},{2,960},{3,16},{4,16}],combat = 154860,is_tv = 0};

get_lv_cfg(199) ->
	#wing_lv_cfg{lv = 199,max_exp = 1330,attr = [{1,2602},{2,155720},{3,2597},{4,2597}],attr_plus = [{1,24},{2,1440},{3,24},{4,24}],combat = 155820,is_tv = 0};

get_lv_cfg(200) ->
	#wing_lv_cfg{lv = 200,max_exp = 1334,attr = [{1,2626},{2,157160},{3,2621},{4,2621}],attr_plus = [{1,8},{2,480},{3,8},{4,8}],combat = 157260,is_tv = 1};

get_lv_cfg(201) ->
	#wing_lv_cfg{lv = 201,max_exp = 1338,attr = [{1,2634},{2,157640},{3,2629},{4,2629}],attr_plus = [{1,9},{2,540},{3,9},{4,9}],combat = 157740,is_tv = 0};

get_lv_cfg(202) ->
	#wing_lv_cfg{lv = 202,max_exp = 1342,attr = [{1,2643},{2,158180},{3,2638},{4,2638}],attr_plus = [{1,10},{2,600},{3,10},{4,10}],combat = 158280,is_tv = 0};

get_lv_cfg(203) ->
	#wing_lv_cfg{lv = 203,max_exp = 1346,attr = [{1,2653},{2,158780},{3,2648},{4,2648}],attr_plus = [{1,11},{2,660},{3,11},{4,11}],combat = 158880,is_tv = 0};

get_lv_cfg(204) ->
	#wing_lv_cfg{lv = 204,max_exp = 1350,attr = [{1,2664},{2,159440},{3,2659},{4,2659}],attr_plus = [{1,12},{2,720},{3,12},{4,12}],combat = 159540,is_tv = 0};

get_lv_cfg(205) ->
	#wing_lv_cfg{lv = 205,max_exp = 1354,attr = [{1,2676},{2,160160},{3,2671},{4,2671}],attr_plus = [{1,13},{2,780},{3,13},{4,13}],combat = 160260,is_tv = 0};

get_lv_cfg(206) ->
	#wing_lv_cfg{lv = 206,max_exp = 1358,attr = [{1,2689},{2,160940},{3,2684},{4,2684}],attr_plus = [{1,14},{2,840},{3,14},{4,14}],combat = 161040,is_tv = 0};

get_lv_cfg(207) ->
	#wing_lv_cfg{lv = 207,max_exp = 1362,attr = [{1,2703},{2,161780},{3,2698},{4,2698}],attr_plus = [{1,15},{2,900},{3,15},{4,15}],combat = 161880,is_tv = 0};

get_lv_cfg(208) ->
	#wing_lv_cfg{lv = 208,max_exp = 1366,attr = [{1,2718},{2,162680},{3,2713},{4,2713}],attr_plus = [{1,16},{2,960},{3,16},{4,16}],combat = 162780,is_tv = 0};

get_lv_cfg(209) ->
	#wing_lv_cfg{lv = 209,max_exp = 1370,attr = [{1,2734},{2,163640},{3,2729},{4,2729}],attr_plus = [{1,24},{2,1440},{3,24},{4,24}],combat = 163740,is_tv = 0};

get_lv_cfg(210) ->
	#wing_lv_cfg{lv = 210,max_exp = 1374,attr = [{1,2758},{2,165080},{3,2753},{4,2753}],attr_plus = [{1,8},{2,480},{3,8},{4,8}],combat = 165180,is_tv = 1};

get_lv_cfg(211) ->
	#wing_lv_cfg{lv = 211,max_exp = 1378,attr = [{1,2766},{2,165560},{3,2761},{4,2761}],attr_plus = [{1,9},{2,540},{3,9},{4,9}],combat = 165660,is_tv = 0};

get_lv_cfg(212) ->
	#wing_lv_cfg{lv = 212,max_exp = 1382,attr = [{1,2775},{2,166100},{3,2770},{4,2770}],attr_plus = [{1,10},{2,600},{3,10},{4,10}],combat = 166200,is_tv = 0};

get_lv_cfg(213) ->
	#wing_lv_cfg{lv = 213,max_exp = 1386,attr = [{1,2785},{2,166700},{3,2780},{4,2780}],attr_plus = [{1,11},{2,660},{3,11},{4,11}],combat = 166800,is_tv = 0};

get_lv_cfg(214) ->
	#wing_lv_cfg{lv = 214,max_exp = 1390,attr = [{1,2796},{2,167360},{3,2791},{4,2791}],attr_plus = [{1,12},{2,720},{3,12},{4,12}],combat = 167460,is_tv = 0};

get_lv_cfg(215) ->
	#wing_lv_cfg{lv = 215,max_exp = 1394,attr = [{1,2808},{2,168080},{3,2803},{4,2803}],attr_plus = [{1,13},{2,780},{3,13},{4,13}],combat = 168180,is_tv = 0};

get_lv_cfg(216) ->
	#wing_lv_cfg{lv = 216,max_exp = 1398,attr = [{1,2821},{2,168860},{3,2816},{4,2816}],attr_plus = [{1,14},{2,840},{3,14},{4,14}],combat = 168960,is_tv = 0};

get_lv_cfg(217) ->
	#wing_lv_cfg{lv = 217,max_exp = 1402,attr = [{1,2835},{2,169700},{3,2830},{4,2830}],attr_plus = [{1,15},{2,900},{3,15},{4,15}],combat = 169800,is_tv = 0};

get_lv_cfg(218) ->
	#wing_lv_cfg{lv = 218,max_exp = 1406,attr = [{1,2850},{2,170600},{3,2845},{4,2845}],attr_plus = [{1,16},{2,960},{3,16},{4,16}],combat = 170700,is_tv = 0};

get_lv_cfg(219) ->
	#wing_lv_cfg{lv = 219,max_exp = 1410,attr = [{1,2866},{2,171560},{3,2861},{4,2861}],attr_plus = [{1,24},{2,1440},{3,24},{4,24}],combat = 171660,is_tv = 0};

get_lv_cfg(220) ->
	#wing_lv_cfg{lv = 220,max_exp = 1414,attr = [{1,2890},{2,173000},{3,2885},{4,2885}],attr_plus = [{1,8},{2,480},{3,8},{4,8}],combat = 173100,is_tv = 1};

get_lv_cfg(221) ->
	#wing_lv_cfg{lv = 221,max_exp = 1418,attr = [{1,2898},{2,173480},{3,2893},{4,2893}],attr_plus = [{1,9},{2,540},{3,9},{4,9}],combat = 173580,is_tv = 0};

get_lv_cfg(222) ->
	#wing_lv_cfg{lv = 222,max_exp = 1422,attr = [{1,2907},{2,174020},{3,2902},{4,2902}],attr_plus = [{1,10},{2,600},{3,10},{4,10}],combat = 174120,is_tv = 0};

get_lv_cfg(223) ->
	#wing_lv_cfg{lv = 223,max_exp = 1426,attr = [{1,2917},{2,174620},{3,2912},{4,2912}],attr_plus = [{1,11},{2,660},{3,11},{4,11}],combat = 174720,is_tv = 0};

get_lv_cfg(224) ->
	#wing_lv_cfg{lv = 224,max_exp = 1430,attr = [{1,2928},{2,175280},{3,2923},{4,2923}],attr_plus = [{1,12},{2,720},{3,12},{4,12}],combat = 175380,is_tv = 0};

get_lv_cfg(225) ->
	#wing_lv_cfg{lv = 225,max_exp = 1434,attr = [{1,2940},{2,176000},{3,2935},{4,2935}],attr_plus = [{1,13},{2,780},{3,13},{4,13}],combat = 176100,is_tv = 0};

get_lv_cfg(226) ->
	#wing_lv_cfg{lv = 226,max_exp = 1438,attr = [{1,2953},{2,176780},{3,2948},{4,2948}],attr_plus = [{1,14},{2,840},{3,14},{4,14}],combat = 176880,is_tv = 0};

get_lv_cfg(227) ->
	#wing_lv_cfg{lv = 227,max_exp = 1442,attr = [{1,2967},{2,177620},{3,2962},{4,2962}],attr_plus = [{1,15},{2,900},{3,15},{4,15}],combat = 177720,is_tv = 0};

get_lv_cfg(228) ->
	#wing_lv_cfg{lv = 228,max_exp = 1446,attr = [{1,2982},{2,178520},{3,2977},{4,2977}],attr_plus = [{1,16},{2,960},{3,16},{4,16}],combat = 178620,is_tv = 0};

get_lv_cfg(229) ->
	#wing_lv_cfg{lv = 229,max_exp = 1450,attr = [{1,2998},{2,179480},{3,2993},{4,2993}],attr_plus = [{1,24},{2,1440},{3,24},{4,24}],combat = 179580,is_tv = 0};

get_lv_cfg(230) ->
	#wing_lv_cfg{lv = 230,max_exp = 1454,attr = [{1,3022},{2,180920},{3,3017},{4,3017}],attr_plus = [{1,8},{2,480},{3,8},{4,8}],combat = 181020,is_tv = 1};

get_lv_cfg(231) ->
	#wing_lv_cfg{lv = 231,max_exp = 1458,attr = [{1,3030},{2,181400},{3,3025},{4,3025}],attr_plus = [{1,9},{2,540},{3,9},{4,9}],combat = 181500,is_tv = 0};

get_lv_cfg(232) ->
	#wing_lv_cfg{lv = 232,max_exp = 1462,attr = [{1,3039},{2,181940},{3,3034},{4,3034}],attr_plus = [{1,10},{2,600},{3,10},{4,10}],combat = 182040,is_tv = 0};

get_lv_cfg(233) ->
	#wing_lv_cfg{lv = 233,max_exp = 1466,attr = [{1,3049},{2,182540},{3,3044},{4,3044}],attr_plus = [{1,11},{2,660},{3,11},{4,11}],combat = 182640,is_tv = 0};

get_lv_cfg(234) ->
	#wing_lv_cfg{lv = 234,max_exp = 1470,attr = [{1,3060},{2,183200},{3,3055},{4,3055}],attr_plus = [{1,12},{2,720},{3,12},{4,12}],combat = 183300,is_tv = 0};

get_lv_cfg(235) ->
	#wing_lv_cfg{lv = 235,max_exp = 1474,attr = [{1,3072},{2,183920},{3,3067},{4,3067}],attr_plus = [{1,13},{2,780},{3,13},{4,13}],combat = 184020,is_tv = 0};

get_lv_cfg(236) ->
	#wing_lv_cfg{lv = 236,max_exp = 1478,attr = [{1,3085},{2,184700},{3,3080},{4,3080}],attr_plus = [{1,14},{2,840},{3,14},{4,14}],combat = 184800,is_tv = 0};

get_lv_cfg(237) ->
	#wing_lv_cfg{lv = 237,max_exp = 1482,attr = [{1,3099},{2,185540},{3,3094},{4,3094}],attr_plus = [{1,15},{2,900},{3,15},{4,15}],combat = 185640,is_tv = 0};

get_lv_cfg(238) ->
	#wing_lv_cfg{lv = 238,max_exp = 1486,attr = [{1,3114},{2,186440},{3,3109},{4,3109}],attr_plus = [{1,16},{2,960},{3,16},{4,16}],combat = 186540,is_tv = 0};

get_lv_cfg(239) ->
	#wing_lv_cfg{lv = 239,max_exp = 1490,attr = [{1,3130},{2,187400},{3,3125},{4,3125}],attr_plus = [{1,24},{2,1440},{3,24},{4,24}],combat = 187500,is_tv = 0};

get_lv_cfg(240) ->
	#wing_lv_cfg{lv = 240,max_exp = 1494,attr = [{1,3154},{2,188840},{3,3149},{4,3149}],attr_plus = [{1,8},{2,480},{3,8},{4,8}],combat = 188940,is_tv = 1};

get_lv_cfg(241) ->
	#wing_lv_cfg{lv = 241,max_exp = 1498,attr = [{1,3162},{2,189320},{3,3157},{4,3157}],attr_plus = [{1,9},{2,540},{3,9},{4,9}],combat = 189420,is_tv = 0};

get_lv_cfg(242) ->
	#wing_lv_cfg{lv = 242,max_exp = 1502,attr = [{1,3171},{2,189860},{3,3166},{4,3166}],attr_plus = [{1,10},{2,600},{3,10},{4,10}],combat = 189960,is_tv = 0};

get_lv_cfg(243) ->
	#wing_lv_cfg{lv = 243,max_exp = 1506,attr = [{1,3181},{2,190460},{3,3176},{4,3176}],attr_plus = [{1,11},{2,660},{3,11},{4,11}],combat = 190560,is_tv = 0};

get_lv_cfg(244) ->
	#wing_lv_cfg{lv = 244,max_exp = 1510,attr = [{1,3192},{2,191120},{3,3187},{4,3187}],attr_plus = [{1,12},{2,720},{3,12},{4,12}],combat = 191220,is_tv = 0};

get_lv_cfg(245) ->
	#wing_lv_cfg{lv = 245,max_exp = 1514,attr = [{1,3204},{2,191840},{3,3199},{4,3199}],attr_plus = [{1,13},{2,780},{3,13},{4,13}],combat = 191940,is_tv = 0};

get_lv_cfg(246) ->
	#wing_lv_cfg{lv = 246,max_exp = 1518,attr = [{1,3217},{2,192620},{3,3212},{4,3212}],attr_plus = [{1,14},{2,840},{3,14},{4,14}],combat = 192720,is_tv = 0};

get_lv_cfg(247) ->
	#wing_lv_cfg{lv = 247,max_exp = 1522,attr = [{1,3231},{2,193460},{3,3226},{4,3226}],attr_plus = [{1,15},{2,900},{3,15},{4,15}],combat = 193560,is_tv = 0};

get_lv_cfg(248) ->
	#wing_lv_cfg{lv = 248,max_exp = 1526,attr = [{1,3246},{2,194360},{3,3241},{4,3241}],attr_plus = [{1,16},{2,960},{3,16},{4,16}],combat = 194460,is_tv = 0};

get_lv_cfg(249) ->
	#wing_lv_cfg{lv = 249,max_exp = 1530,attr = [{1,3262},{2,195320},{3,3257},{4,3257}],attr_plus = [{1,24},{2,1440},{3,24},{4,24}],combat = 195420,is_tv = 0};

get_lv_cfg(250) ->
	#wing_lv_cfg{lv = 250,max_exp = 1534,attr = [{1,3286},{2,196760},{3,3281},{4,3281}],attr_plus = [],combat = 196860,is_tv = 1};

get_lv_cfg(_Lv) ->
	[].

get_goods_exp(20010001) ->
	#wing_goods_exp_cfg{goods_id = 20010001,exp = 10};

get_goods_exp(20010002) ->
	#wing_goods_exp_cfg{goods_id = 20010002,exp = 100};

get_goods_exp(20010003) ->
	#wing_goods_exp_cfg{goods_id = 20010003,exp = 300};

get_goods_exp(_Goodsid) ->
	[].

get_goods_ids() ->
[20010001,20010002,20010003].

get_feather_cfg(_) ->
	[].

get_feather_ids() ->
[].

get_stage_cfg(0) ->
	#wing_stage_cfg{id = 0,prop = [],name = "天使之翼",turn = 0,figure_id = 104009,max_star = 0};

get_stage_cfg(1) ->
	#wing_stage_cfg{id = 1,prop = [{0,20030003,1}],name = "黄金之翼",turn = 0,figure_id = 104009,max_star = 5};

get_stage_cfg(2) ->
	#wing_stage_cfg{id = 2,prop = [{0,20030001,1}],name = "彩虹之翼",turn = 1,figure_id = 104009,max_star = 5};

get_stage_cfg(3) ->
	#wing_stage_cfg{id = 3,prop = [{0,20030002,1}],name = "星空之翼",turn = 2,figure_id = 104009,max_star = 5};

get_stage_cfg(4) ->
	#wing_stage_cfg{id = 4,prop = [{0,20030004,1}],name = "丛林之翼",turn = 3,figure_id = 104009,max_star = 5};

get_stage_cfg(5) ->
	#wing_stage_cfg{id = 5,prop = [{0,20030005,1}],name = "烈焰之翼",turn = 4,figure_id = 104009,max_star = 5};

get_stage_cfg(6) ->
	#wing_stage_cfg{id = 6,prop = [{0,20030006,1}],name = "冰霜之翼",turn = 5,figure_id = 104009,max_star = 5};

get_stage_cfg(7) ->
	#wing_stage_cfg{id = 7,prop = [{0,20030007,1}],name = "上古之翼",turn = 6,figure_id = 104009,max_star = 5};

get_stage_cfg(_Id) ->
	[].

get_all_stages() ->
[0,1,2,3,4,5,6,7].

get_all_figure_ids() ->
[104009].

