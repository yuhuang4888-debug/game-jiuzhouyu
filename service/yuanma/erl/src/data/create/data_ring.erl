%%%---------------------------------------
%%% module      : data_ring
%%% description : 婚姻-戒指配额配置
%%%
%%%---------------------------------------
-module(data_ring).
-compile(export_all).
-include("marriage.hrl").



get_ring_stage_con(1) ->
	#ring_stage_con{stage = 1,name = <<"一阶"/utf8>>};

get_ring_stage_con(2) ->
	#ring_stage_con{stage = 2,name = <<"二阶"/utf8>>};

get_ring_stage_con(3) ->
	#ring_stage_con{stage = 3,name = <<"三阶"/utf8>>};

get_ring_stage_con(4) ->
	#ring_stage_con{stage = 4,name = <<"四阶"/utf8>>};

get_ring_stage_con(5) ->
	#ring_stage_con{stage = 5,name = <<"五阶"/utf8>>};

get_ring_stage_con(6) ->
	#ring_stage_con{stage = 6,name = <<"六阶"/utf8>>};

get_ring_stage_con(7) ->
	#ring_stage_con{stage = 7,name = <<"七阶"/utf8>>};

get_ring_stage_con(8) ->
	#ring_stage_con{stage = 8,name = <<"八阶"/utf8>>};

get_ring_stage_con(9) ->
	#ring_stage_con{stage = 9,name = <<"九阶"/utf8>>};

get_ring_stage_con(10) ->
	#ring_stage_con{stage = 10,name = <<"十阶"/utf8>>};

get_ring_stage_con(_Stage) ->
	[].

get_ring_star_con(1,0) ->
	#ring_star_con{stage = 1,star = 0,upgrade_pray_num = 0,attr_list = [{1,0},{2,0},{4,0},{3,0}],marriage_attr = []};

get_ring_star_con(1,1) ->
	#ring_star_con{stage = 1,star = 1,upgrade_pray_num = 0,attr_list = [{1,20},{2,300},{3,8},{4,8}],marriage_attr = [{19,100},{20,100},{22,100},{21,100}]};

get_ring_star_con(1,2) ->
	#ring_star_con{stage = 1,star = 2,upgrade_pray_num = 40,attr_list = [{1,30},{2,400},{3,10},{4,10}],marriage_attr = [{19,100},{20,100},{22,100},{21,100}]};

get_ring_star_con(1,3) ->
	#ring_star_con{stage = 1,star = 3,upgrade_pray_num = 40,attr_list = [{1,45},{2,600},{3,15},{4,15}],marriage_attr = [{19,100},{20,100},{22,100},{21,100}]};

get_ring_star_con(1,4) ->
	#ring_star_con{stage = 1,star = 4,upgrade_pray_num = 50,attr_list = [{1,60},{2,700},{3,18},{4,18}],marriage_attr = [{19,100},{20,100},{22,100},{21,100}]};

get_ring_star_con(1,5) ->
	#ring_star_con{stage = 1,star = 5,upgrade_pray_num = 40,attr_list = [{1,80},{2,900},{3,23},{4,23}],marriage_attr = [{19,100},{20,100},{22,100},{21,100}]};

get_ring_star_con(1,6) ->
	#ring_star_con{stage = 1,star = 6,upgrade_pray_num = 50,attr_list = [{1,105},{2,1100},{3,28},{4,28}],marriage_attr = [{19,100},{20,100},{22,100},{21,100}]};

get_ring_star_con(1,7) ->
	#ring_star_con{stage = 1,star = 7,upgrade_pray_num = 50,attr_list = [{1,130},{2,1300},{3,33},{4,33}],marriage_attr = [{19,100},{20,100},{22,100},{21,100}]};

get_ring_star_con(1,8) ->
	#ring_star_con{stage = 1,star = 8,upgrade_pray_num = 60,attr_list = [{1,155},{2,1500},{3,38},{4,38}],marriage_attr = [{19,100},{20,100},{22,100},{21,100}]};

get_ring_star_con(1,9) ->
	#ring_star_con{stage = 1,star = 9,upgrade_pray_num = 60,attr_list = [{1,185},{2,1800},{3,45},{4,45}],marriage_attr = [{19,100},{20,100},{22,100},{21,100}]};

get_ring_star_con(1,10) ->
	#ring_star_con{stage = 1,star = 10,upgrade_pray_num = 60,attr_list = [{1,220},{2,2100},{3,53},{4,53}],marriage_attr = [{19,120},{20,120},{22,120},{21,120}]};

get_ring_star_con(2,1) ->
	#ring_star_con{stage = 2,star = 1,upgrade_pray_num = 70,attr_list = [{1,560},{2,2400},{3,60},{4,60}],marriage_attr = [{19,120},{20,120},{22,120},{21,120}]};

get_ring_star_con(2,2) ->
	#ring_star_con{stage = 2,star = 2,upgrade_pray_num = 70,attr_list = [{1,595},{2,2700},{3,68},{4,68}],marriage_attr = [{19,120},{20,120},{22,120},{21,120}]};

get_ring_star_con(2,3) ->
	#ring_star_con{stage = 2,star = 3,upgrade_pray_num = 70,attr_list = [{1,640},{2,3000},{3,75},{4,75}],marriage_attr = [{19,120},{20,120},{22,120},{21,120}]};

get_ring_star_con(2,4) ->
	#ring_star_con{stage = 2,star = 4,upgrade_pray_num = 80,attr_list = [{1,685},{2,3300},{3,83},{4,83}],marriage_attr = [{19,120},{20,120},{22,120},{21,120}]};

get_ring_star_con(2,5) ->
	#ring_star_con{stage = 2,star = 5,upgrade_pray_num = 80,attr_list = [{1,735},{2,3700},{3,93},{4,93}],marriage_attr = [{19,120},{20,120},{22,120},{21,120}]};

get_ring_star_con(2,6) ->
	#ring_star_con{stage = 2,star = 6,upgrade_pray_num = 90,attr_list = [{1,785},{2,4100},{3,103},{4,103}],marriage_attr = [{19,120},{20,120},{22,120},{21,120}]};

get_ring_star_con(2,7) ->
	#ring_star_con{stage = 2,star = 7,upgrade_pray_num = 90,attr_list = [{1,840},{2,4400},{3,110},{4,110}],marriage_attr = [{19,120},{20,120},{22,120},{21,120}]};

get_ring_star_con(2,8) ->
	#ring_star_con{stage = 2,star = 8,upgrade_pray_num = 90,attr_list = [{1,900},{2,4800},{3,120},{4,120}],marriage_attr = [{19,120},{20,120},{22,120},{21,120}]};

get_ring_star_con(2,9) ->
	#ring_star_con{stage = 2,star = 9,upgrade_pray_num = 110,attr_list = [{1,960},{2,5300},{3,133},{4,133}],marriage_attr = [{19,120},{20,120},{22,120},{21,120}]};

get_ring_star_con(2,10) ->
	#ring_star_con{stage = 2,star = 10,upgrade_pray_num = 100,attr_list = [{1,1025},{2,5700},{3,143},{4,143}],marriage_attr = [{19,140},{20,140},{22,140},{21,140}]};

get_ring_star_con(3,1) ->
	#ring_star_con{stage = 3,star = 1,upgrade_pray_num = 110,attr_list = [{1,1395},{2,6200},{3,155},{4,155}],marriage_attr = [{19,140},{20,140},{22,140},{21,140}]};

get_ring_star_con(3,2) ->
	#ring_star_con{stage = 3,star = 2,upgrade_pray_num = 110,attr_list = [{1,1465},{2,6600},{3,165},{4,165}],marriage_attr = [{19,140},{20,140},{22,140},{21,140}]};

get_ring_star_con(3,3) ->
	#ring_star_con{stage = 3,star = 3,upgrade_pray_num = 120,attr_list = [{1,1540},{2,7100},{3,178},{4,178}],marriage_attr = [{19,140},{20,140},{22,140},{21,140}]};

get_ring_star_con(3,4) ->
	#ring_star_con{stage = 3,star = 4,upgrade_pray_num = 130,attr_list = [{1,1615},{2,7600},{3,190},{4,190}],marriage_attr = [{19,140},{20,140},{22,140},{21,140}]};

get_ring_star_con(3,5) ->
	#ring_star_con{stage = 3,star = 5,upgrade_pray_num = 130,attr_list = [{1,1695},{2,8100},{3,203},{4,203}],marriage_attr = [{19,140},{20,140},{22,140},{21,140}]};

get_ring_star_con(3,6) ->
	#ring_star_con{stage = 3,star = 6,upgrade_pray_num = 140,attr_list = [{1,1780},{2,8600},{3,215},{4,215}],marriage_attr = [{19,140},{20,140},{22,140},{21,140}]};

get_ring_star_con(3,7) ->
	#ring_star_con{stage = 3,star = 7,upgrade_pray_num = 140,attr_list = [{1,1865},{2,9200},{3,230},{4,230}],marriage_attr = [{19,140},{20,140},{22,140},{21,140}]};

get_ring_star_con(3,8) ->
	#ring_star_con{stage = 3,star = 8,upgrade_pray_num = 150,attr_list = [{1,1955},{2,9700},{3,243},{4,243}],marriage_attr = [{19,140},{20,140},{22,140},{21,140}]};

get_ring_star_con(3,9) ->
	#ring_star_con{stage = 3,star = 9,upgrade_pray_num = 150,attr_list = [{1,2050},{2,10300},{3,258},{4,258}],marriage_attr = [{19,140},{20,140},{22,140},{21,140}]};

get_ring_star_con(3,10) ->
	#ring_star_con{stage = 3,star = 10,upgrade_pray_num = 160,attr_list = [{1,2145},{2,10900},{3,273},{4,273}],marriage_attr = [{19,160},{20,160},{22,160},{21,160}]};

get_ring_star_con(4,1) ->
	#ring_star_con{stage = 4,star = 1,upgrade_pray_num = 160,attr_list = [{1,2645},{2,11500},{3,288},{4,288}],marriage_attr = [{19,160},{20,160},{22,160},{21,160}]};

get_ring_star_con(4,2) ->
	#ring_star_con{stage = 4,star = 2,upgrade_pray_num = 180,attr_list = [{1,2750},{2,12100},{3,303},{4,303}],marriage_attr = [{19,160},{20,160},{22,160},{21,160}]};

get_ring_star_con(4,3) ->
	#ring_star_con{stage = 4,star = 3,upgrade_pray_num = 170,attr_list = [{1,2855},{2,12700},{3,318},{4,318}],marriage_attr = [{19,160},{20,160},{22,160},{21,160}]};

get_ring_star_con(4,4) ->
	#ring_star_con{stage = 4,star = 4,upgrade_pray_num = 190,attr_list = [{1,2965},{2,13300},{3,333},{4,333}],marriage_attr = [{19,160},{20,160},{22,160},{21,160}]};

get_ring_star_con(4,5) ->
	#ring_star_con{stage = 4,star = 5,upgrade_pray_num = 190,attr_list = [{1,3080},{2,14000},{3,350},{4,350}],marriage_attr = [{19,160},{20,160},{22,160},{21,160}]};

get_ring_star_con(4,6) ->
	#ring_star_con{stage = 4,star = 6,upgrade_pray_num = 200,attr_list = [{1,3195},{2,14700},{3,368},{4,368}],marriage_attr = [{19,160},{20,160},{22,160},{21,160}]};

get_ring_star_con(4,7) ->
	#ring_star_con{stage = 4,star = 7,upgrade_pray_num = 200,attr_list = [{1,3315},{2,15400},{3,385},{4,385}],marriage_attr = [{19,160},{20,160},{22,160},{21,160}]};

get_ring_star_con(4,8) ->
	#ring_star_con{stage = 4,star = 8,upgrade_pray_num = 210,attr_list = [{1,3440},{2,16000},{3,400},{4,400}],marriage_attr = [{19,160},{20,160},{22,160},{21,160}]};

get_ring_star_con(4,9) ->
	#ring_star_con{stage = 4,star = 9,upgrade_pray_num = 220,attr_list = [{1,3565},{2,16800},{3,420},{4,420}],marriage_attr = [{19,160},{20,160},{22,160},{21,160}]};

get_ring_star_con(4,10) ->
	#ring_star_con{stage = 4,star = 10,upgrade_pray_num = 230,attr_list = [{1,3695},{2,17500},{3,438},{4,438}],marriage_attr = [{19,180},{20,180},{22,180},{21,180}]};

get_ring_star_con(5,1) ->
	#ring_star_con{stage = 5,star = 1,upgrade_pray_num = 230,attr_list = [{1,4330},{2,18200},{3,455},{4,455}],marriage_attr = [{19,180},{20,180},{22,180},{21,180}]};

get_ring_star_con(5,2) ->
	#ring_star_con{stage = 5,star = 2,upgrade_pray_num = 240,attr_list = [{1,4465},{2,19000},{3,475},{4,475}],marriage_attr = [{19,180},{20,180},{22,180},{21,180}]};

get_ring_star_con(5,3) ->
	#ring_star_con{stage = 5,star = 3,upgrade_pray_num = 250,attr_list = [{1,4605},{2,19700},{3,493},{4,493}],marriage_attr = [{19,180},{20,180},{22,180},{21,180}]};

get_ring_star_con(5,4) ->
	#ring_star_con{stage = 5,star = 4,upgrade_pray_num = 260,attr_list = [{1,4750},{2,20500},{3,513},{4,513}],marriage_attr = [{19,180},{20,180},{22,180},{21,180}]};

get_ring_star_con(5,5) ->
	#ring_star_con{stage = 5,star = 5,upgrade_pray_num = 260,attr_list = [{1,4895},{2,21300},{3,533},{4,533}],marriage_attr = [{19,180},{20,180},{22,180},{21,180}]};

get_ring_star_con(5,6) ->
	#ring_star_con{stage = 5,star = 6,upgrade_pray_num = 270,attr_list = [{1,5045},{2,22100},{3,553},{4,553}],marriage_attr = [{19,180},{20,180},{22,180},{21,180}]};

get_ring_star_con(5,7) ->
	#ring_star_con{stage = 5,star = 7,upgrade_pray_num = 280,attr_list = [{1,5200},{2,22900},{3,573},{4,573}],marriage_attr = [{19,180},{20,180},{22,180},{21,180}]};

get_ring_star_con(5,8) ->
	#ring_star_con{stage = 5,star = 8,upgrade_pray_num = 290,attr_list = [{1,5355},{2,23700},{3,593},{4,593}],marriage_attr = [{19,180},{20,180},{22,180},{21,180}]};

get_ring_star_con(5,9) ->
	#ring_star_con{stage = 5,star = 9,upgrade_pray_num = 300,attr_list = [{1,5515},{2,24600},{3,615},{4,615}],marriage_attr = [{19,180},{20,180},{22,180},{21,180}]};

get_ring_star_con(5,10) ->
	#ring_star_con{stage = 5,star = 10,upgrade_pray_num = 300,attr_list = [{1,5680},{2,25400},{3,635},{4,635}],marriage_attr = [{19,200},{20,200},{22,200},{21,200}]};

get_ring_star_con(6,1) ->
	#ring_star_con{stage = 6,star = 1,upgrade_pray_num = 320,attr_list = [{1,6350},{2,26300},{3,658},{4,658}],marriage_attr = [{19,200},{20,200},{22,200},{21,200}]};

get_ring_star_con(6,2) ->
	#ring_star_con{stage = 6,star = 2,upgrade_pray_num = 320,attr_list = [{1,6520},{2,27200},{3,680},{4,680}],marriage_attr = [{19,200},{20,200},{22,200},{21,200}]};

get_ring_star_con(6,3) ->
	#ring_star_con{stage = 6,star = 3,upgrade_pray_num = 330,attr_list = [{1,6695},{2,28100},{3,703},{4,703}],marriage_attr = [{19,200},{20,200},{22,200},{21,200}]};

get_ring_star_con(6,4) ->
	#ring_star_con{stage = 6,star = 4,upgrade_pray_num = 340,attr_list = [{1,6870},{2,29000},{3,725},{4,725}],marriage_attr = [{19,200},{20,200},{22,200},{21,200}]};

get_ring_star_con(6,5) ->
	#ring_star_con{stage = 6,star = 5,upgrade_pray_num = 350,attr_list = [{1,7050},{2,29900},{3,748},{4,748}],marriage_attr = [{19,200},{20,200},{22,200},{21,200}]};

get_ring_star_con(6,6) ->
	#ring_star_con{stage = 6,star = 6,upgrade_pray_num = 360,attr_list = [{1,7235},{2,30900},{3,773},{4,773}],marriage_attr = [{19,200},{20,200},{22,200},{21,200}]};

get_ring_star_con(6,7) ->
	#ring_star_con{stage = 6,star = 7,upgrade_pray_num = 370,attr_list = [{1,7425},{2,31800},{3,795},{4,795}],marriage_attr = [{19,200},{20,200},{22,200},{21,200}]};

get_ring_star_con(6,8) ->
	#ring_star_con{stage = 6,star = 8,upgrade_pray_num = 370,attr_list = [{1,7615},{2,32800},{3,820},{4,820}],marriage_attr = [{19,200},{20,200},{22,200},{21,200}]};

get_ring_star_con(6,9) ->
	#ring_star_con{stage = 6,star = 9,upgrade_pray_num = 390,attr_list = [{1,7810},{2,33700},{3,843},{4,843}],marriage_attr = [{19,200},{20,200},{22,200},{21,200}]};

get_ring_star_con(6,10) ->
	#ring_star_con{stage = 6,star = 10,upgrade_pray_num = 400,attr_list = [{1,8010},{2,34700},{3,868},{4,868}],marriage_attr = [{19,220},{20,220},{22,220},{21,220}]};

get_ring_star_con(7,1) ->
	#ring_star_con{stage = 7,star = 1,upgrade_pray_num = 400,attr_list = [{1,9010},{2,35700},{3,893},{4,893}],marriage_attr = [{19,220},{20,220},{22,220},{21,220}]};

get_ring_star_con(7,2) ->
	#ring_star_con{stage = 7,star = 2,upgrade_pray_num = 420,attr_list = [{1,9215},{2,36700},{3,918},{4,918}],marriage_attr = [{19,220},{20,220},{22,220},{21,220}]};

get_ring_star_con(7,3) ->
	#ring_star_con{stage = 7,star = 3,upgrade_pray_num = 420,attr_list = [{1,9425},{2,37700},{3,943},{4,943}],marriage_attr = [{19,220},{20,220},{22,220},{21,220}]};

get_ring_star_con(7,4) ->
	#ring_star_con{stage = 7,star = 4,upgrade_pray_num = 440,attr_list = [{1,9640},{2,38800},{3,970},{4,970}],marriage_attr = [{19,220},{20,220},{22,220},{21,220}]};

get_ring_star_con(7,5) ->
	#ring_star_con{stage = 7,star = 5,upgrade_pray_num = 450,attr_list = [{1,9855},{2,39800},{3,995},{4,995}],marriage_attr = [{19,220},{20,220},{22,220},{21,220}]};

get_ring_star_con(7,6) ->
	#ring_star_con{stage = 7,star = 6,upgrade_pray_num = 450,attr_list = [{1,10075},{2,40900},{3,1023},{4,1023}],marriage_attr = [{19,220},{20,220},{22,220},{21,220}]};

get_ring_star_con(7,7) ->
	#ring_star_con{stage = 7,star = 7,upgrade_pray_num = 470,attr_list = [{1,10295},{2,41900},{3,1048},{4,1048}],marriage_attr = [{19,220},{20,220},{22,220},{21,220}]};

get_ring_star_con(7,8) ->
	#ring_star_con{stage = 7,star = 8,upgrade_pray_num = 480,attr_list = [{1,10525},{2,43000},{3,1075},{4,1075}],marriage_attr = [{19,220},{20,220},{22,220},{21,220}]};

get_ring_star_con(7,9) ->
	#ring_star_con{stage = 7,star = 9,upgrade_pray_num = 490,attr_list = [{1,10755},{2,44100},{3,1103},{4,1103}],marriage_attr = [{19,220},{20,220},{22,220},{21,220}]};

get_ring_star_con(7,10) ->
	#ring_star_con{stage = 7,star = 10,upgrade_pray_num = 500,attr_list = [{1,10985},{2,45200},{3,1130},{4,1130}],marriage_attr = [{19,240},{20,240},{22,240},{21,240}]};

get_ring_star_con(8,1) ->
	#ring_star_con{stage = 8,star = 1,upgrade_pray_num = 510,attr_list = [{1,12225},{2,46400},{3,1160},{4,1160}],marriage_attr = [{19,240},{20,240},{22,240},{21,240}]};

get_ring_star_con(8,2) ->
	#ring_star_con{stage = 8,star = 2,upgrade_pray_num = 520,attr_list = [{1,12465},{2,47500},{3,1188},{4,1188}],marriage_attr = [{19,240},{20,240},{22,240},{21,240}]};

get_ring_star_con(8,3) ->
	#ring_star_con{stage = 8,star = 3,upgrade_pray_num = 530,attr_list = [{1,12710},{2,48600},{3,1215},{4,1215}],marriage_attr = [{19,240},{20,240},{22,240},{21,240}]};

get_ring_star_con(8,4) ->
	#ring_star_con{stage = 8,star = 4,upgrade_pray_num = 550,attr_list = [{1,12955},{2,49800},{3,1245},{4,1245}],marriage_attr = [{19,240},{20,240},{22,240},{21,240}]};

get_ring_star_con(8,5) ->
	#ring_star_con{stage = 8,star = 5,upgrade_pray_num = 550,attr_list = [{1,13210},{2,51000},{3,1275},{4,1275}],marriage_attr = [{19,240},{20,240},{22,240},{21,240}]};

get_ring_star_con(8,6) ->
	#ring_star_con{stage = 8,star = 6,upgrade_pray_num = 570,attr_list = [{1,13465},{2,52100},{3,1303},{4,1303}],marriage_attr = [{19,240},{20,240},{22,240},{21,240}]};

get_ring_star_con(8,7) ->
	#ring_star_con{stage = 8,star = 7,upgrade_pray_num = 580,attr_list = [{1,13720},{2,53300},{3,1333},{4,1333}],marriage_attr = [{19,240},{20,240},{22,240},{21,240}]};

get_ring_star_con(8,8) ->
	#ring_star_con{stage = 8,star = 8,upgrade_pray_num = 590,attr_list = [{1,13985},{2,54500},{3,1363},{4,1363}],marriage_attr = [{19,240},{20,240},{22,240},{21,240}]};

get_ring_star_con(8,9) ->
	#ring_star_con{stage = 8,star = 9,upgrade_pray_num = 610,attr_list = [{1,14250},{2,55800},{3,1395},{4,1395}],marriage_attr = [{19,240},{20,240},{22,240},{21,240}]};

get_ring_star_con(8,10) ->
	#ring_star_con{stage = 8,star = 10,upgrade_pray_num = 610,attr_list = [{1,14520},{2,57000},{3,1425},{4,1425}],marriage_attr = [{19,260},{20,260},{22,260},{21,260}]};

get_ring_star_con(9,1) ->
	#ring_star_con{stage = 9,star = 1,upgrade_pray_num = 630,attr_list = [{1,15990},{2,58200},{3,1455},{4,1455}],marriage_attr = [{19,260},{20,260},{22,260},{21,260}]};

get_ring_star_con(9,2) ->
	#ring_star_con{stage = 9,star = 2,upgrade_pray_num = 640,attr_list = [{1,16270},{2,59500},{3,1488},{4,1488}],marriage_attr = [{19,260},{20,260},{22,260},{21,260}]};

get_ring_star_con(9,3) ->
	#ring_star_con{stage = 9,star = 3,upgrade_pray_num = 650,attr_list = [{1,16550},{2,60700},{3,1518},{4,1518}],marriage_attr = [{19,260},{20,260},{22,260},{21,260}]};

get_ring_star_con(9,4) ->
	#ring_star_con{stage = 9,star = 4,upgrade_pray_num = 670,attr_list = [{1,16835},{2,62000},{3,1550},{4,1550}],marriage_attr = [{19,260},{20,260},{22,260},{21,260}]};

get_ring_star_con(9,5) ->
	#ring_star_con{stage = 9,star = 5,upgrade_pray_num = 680,attr_list = [{1,17120},{2,63300},{3,1583},{4,1583}],marriage_attr = [{19,260},{20,260},{22,260},{21,260}]};

get_ring_star_con(9,6) ->
	#ring_star_con{stage = 9,star = 6,upgrade_pray_num = 690,attr_list = [{1,17410},{2,64600},{3,1615},{4,1615}],marriage_attr = [{19,260},{20,260},{22,260},{21,260}]};

get_ring_star_con(9,7) ->
	#ring_star_con{stage = 9,star = 7,upgrade_pray_num = 700,attr_list = [{1,17705},{2,65900},{3,1648},{4,1648}],marriage_attr = [{19,260},{20,260},{22,260},{21,260}]};

get_ring_star_con(9,8) ->
	#ring_star_con{stage = 9,star = 8,upgrade_pray_num = 720,attr_list = [{1,18005},{2,67200},{3,1680},{4,1680}],marriage_attr = [{19,260},{20,260},{22,260},{21,260}]};

get_ring_star_con(9,9) ->
	#ring_star_con{stage = 9,star = 9,upgrade_pray_num = 730,attr_list = [{1,18305},{2,68600},{3,1715},{4,1715}],marriage_attr = [{19,260},{20,260},{22,260},{21,260}]};

get_ring_star_con(9,10) ->
	#ring_star_con{stage = 9,star = 10,upgrade_pray_num = 740,attr_list = [{1,18610},{2,69900},{3,1748},{4,1748}],marriage_attr = [{19,280},{20,280},{22,280},{21,280}]};

get_ring_star_con(10,1) ->
	#ring_star_con{stage = 10,star = 1,upgrade_pray_num = 760,attr_list = [{1,20420},{2,71300},{3,1783},{4,1783}],marriage_attr = [{19,280},{20,280},{22,280},{21,280}]};

get_ring_star_con(10,2) ->
	#ring_star_con{stage = 10,star = 2,upgrade_pray_num = 770,attr_list = [{1,20735},{2,72600},{3,1815},{4,1815}],marriage_attr = [{19,280},{20,280},{22,280},{21,280}]};

get_ring_star_con(10,3) ->
	#ring_star_con{stage = 10,star = 3,upgrade_pray_num = 780,attr_list = [{1,21050},{2,74000},{3,1850},{4,1850}],marriage_attr = [{19,280},{20,280},{22,280},{21,280}]};

get_ring_star_con(10,4) ->
	#ring_star_con{stage = 10,star = 4,upgrade_pray_num = 800,attr_list = [{1,21370},{2,75400},{3,1885},{4,1885}],marriage_attr = [{19,280},{20,280},{22,280},{21,280}]};

get_ring_star_con(10,5) ->
	#ring_star_con{stage = 10,star = 5,upgrade_pray_num = 810,attr_list = [{1,21695},{2,76800},{3,1920},{4,1920}],marriage_attr = [{19,280},{20,280},{22,280},{21,280}]};

get_ring_star_con(10,6) ->
	#ring_star_con{stage = 10,star = 6,upgrade_pray_num = 830,attr_list = [{1,22020},{2,78200},{3,1955},{4,1955}],marriage_attr = [{19,280},{20,280},{22,280},{21,280}]};

get_ring_star_con(10,7) ->
	#ring_star_con{stage = 10,star = 7,upgrade_pray_num = 840,attr_list = [{1,22350},{2,79700},{3,1993},{4,1993}],marriage_attr = [{19,280},{20,280},{22,280},{21,280}]};

get_ring_star_con(10,8) ->
	#ring_star_con{stage = 10,star = 8,upgrade_pray_num = 850,attr_list = [{1,22685},{2,81100},{3,2028},{4,2028}],marriage_attr = [{19,280},{20,280},{22,280},{21,280}]};

get_ring_star_con(10,9) ->
	#ring_star_con{stage = 10,star = 9,upgrade_pray_num = 870,attr_list = [{1,23025},{2,82600},{3,2065},{4,2065}],marriage_attr = [{19,280},{20,280},{22,280},{21,280}]};

get_ring_star_con(10,10) ->
	#ring_star_con{stage = 10,star = 10,upgrade_pray_num = 880,attr_list = [{1,23365},{2,84000},{3,2100},{4,2100}],marriage_attr = [{19,300},{20,300},{22,300},{21,300}]};

get_ring_star_con(_Stage,_Star) ->
	[].

get_ring_polish_con(_) ->
	[].

