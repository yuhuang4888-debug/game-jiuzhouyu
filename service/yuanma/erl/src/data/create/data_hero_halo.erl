%%%---------------------------------------
%%% module      : data_hero_halo
%%% description : 主角光环配置
%%%
%%%---------------------------------------
-module(data_hero_halo).
-compile(export_all).
-include("hero_halo.hrl").



get_halo_cfg(1) ->
	#base_hero_halo{id = 1,picture = 101,desc = <<"主角光环称号"/utf8>>,supplement_desc = <<""/utf8>>,reward = [{0,38065414,1},{0,34,880},{0,35,880}],condition = [{lv,1}],weight = 999,value = []};

get_halo_cfg(2) ->
	#base_hero_halo{id = 2,picture = 102,desc = <<"掉落拾取速度提升"/utf8>>,supplement_desc = <<"单人进行大妖击杀时获得掉落奖励立即进入背包<br/>包括以下大妖：<br/>1.世界大妖<br/>2.大妖之境<br/>3.蛮荒大妖<br/>4.专属大妖<br/>5.秘境大妖<br/>6.蜃气楼及无限层"/utf8>>,reward = [{0,38370001,3},{0,38370003,3},{0,38160001,3}],condition = [{lv,1}],weight = 998,value = [58,56,34,22,2,16,43,12,54]};

get_halo_cfg(3) ->
	#base_hero_halo{id = 3,picture = 103,desc = <<"开放竞技场一键扫荡"/utf8>>,supplement_desc = <<"竞技场中对排名比自己低的玩家可进行一次扫荡，消耗所有剩余次数并获得对应奖励"/utf8>>,reward = [{0,32060124,1},{0,32060119,10},{0,38040044,5}],condition = [{lv,120}],weight = 997,value = []};

get_halo_cfg(4) ->
	#base_hero_halo{id = 4,picture = 104,desc = <<"璀璨之海免费升级次数+1"/utf8>>,supplement_desc = <<""/utf8>>,reward = [{0,38340001,1},{0,16020002,5},{0,17020002,5}],condition = [{lv,200}],weight = 996,value = [1]};

get_halo_cfg(5) ->
	#base_hero_halo{id = 5,picture = 105,desc = <<"副本合并挑战"/utf8>>,supplement_desc = <<"解锁寻装觅刃/神纹烙印副本合并次数挑战<br/>寻装觅刃：战斗结算时，奖励根据合并次数进行翻倍<br/>神纹烙印：进度奖励根据合并次数进行翻倍<br/>注：副本中途退出不返还次数"/utf8>>,reward = [{0,36255028,10},{0,38040030,10},{0,32010056,20}],condition = [{lv,270}],weight = 995,value = []};

get_halo_cfg(6) ->
	#base_hero_halo{id = 6,picture = 106,desc = <<"开启蜃妖装备一键合成"/utf8>>,supplement_desc = <<"解锁一键蜃妖装备合成，合成期间可自行暂停"/utf8>>,reward = [{0,38370002,3},{0,32010316,1},{0,32010570,1}],condition = [{lv,320}],weight = 994,value = []};

get_halo_cfg(7) ->
	#base_hero_halo{id = 7,picture = 107,desc = <<"怨灵封印pvp伤害减免+10%"/utf8>>,supplement_desc = <<"在怨灵封印场景中获得10%PVP伤害减免属性"/utf8>>,reward = [{0,38040019,1},{0,38040018,100},{0,38040018,50}],condition = [{lv,360}],weight = 993,value = [{60010101,1}]};

get_halo_cfg(8) ->
	#base_hero_halo{id = 8,picture = 108,desc = <<"遗迹探宝免费重置1次"/utf8>>,supplement_desc = <<""/utf8>>,reward = [{0,34010079,1},{0,32060124,1},{0,35,380}],condition = [{lv,371}],weight = 992,value = [1]};

get_halo_cfg(9) ->
	#base_hero_halo{id = 9,picture = 109,desc = <<"极地试炼中伤害提升+20%"/utf8>>,supplement_desc = <<"极寒之地：伤害加深属性0%→20%<br/>埋骨之地：伤害加深属性750%→900%"/utf8>>,reward = [{0,7305002,1},{0,7301001,5},{0,7301003,5}],condition = [{lv,450}],weight = 991,value = [{60010102,1}]};

get_halo_cfg(_Id) ->
	[].

get_all_id() ->
[1,2,3,4,5,6,7,8,9].

