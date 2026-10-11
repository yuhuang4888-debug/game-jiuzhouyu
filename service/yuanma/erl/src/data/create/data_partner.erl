%%%---------------------------------------
%%% @Module  : data_partner
%%% @Description : 伙伴
%%%
%%%---------------------------------------
-module(data_partner).
-compile(export_all).
-include("partner.hrl").



get_partner_by_id(101) ->
    #base_partner{partner_id = 101,name = "绿翼毒蜂",model_id = 5010074,weapon_id = 0,chartlet_id = 0,quality = 1,career = 1,born_attr = [800,73,102,73,44],grow_up = [3,4.2,3,1.8],attack_skill = 2001010,assist_skill = 2100001,assist_condition = [{0,249,1},{250,499,2},{500,749,3},{750,999,4},{1000,1499,5},{1500,999999,6}],talent_skill = 2201010,talent_describe = "对目标造成基础攻击*257%的伤害",personality = 1,personality_desc = "优先攻击对主人造成伤害的敌人，并降低其攻击力的10%（攻击降低持续3秒）",speciality = "忠诚",recruit_type = [{1,0,60},{2,0,18}]};

get_partner_by_id(102) ->
    #base_partner{partner_id = 102,name = "紫翼毒蜂",model_id = 5010074,weapon_id = 0,chartlet_id = 1,quality = 1,career = 2,born_attr = [800,102,73,87,29],grow_up = [4.2,3,3.6,1.2],attack_skill = 2001020,assist_skill = 2100003,assist_condition = [{0,249,1},{250,499,2},{500,749,3},{750,999,4},{1000,1499,5},{1500,999999,6}],talent_skill = 2201020,talent_describe = "对目标造成基础攻击*257%的伤害",personality = 2,personality_desc = "永久提升抗会心几率400点",speciality = "稳重",recruit_type = [{1,0,60},{2,0,18}]};

get_partner_by_id(103) ->
    #base_partner{partner_id = 103,name = "黄翼毒蜂",model_id = 5010074,weapon_id = 0,chartlet_id = 2,quality = 1,career = 3,born_attr = [800,102,73,44,73],grow_up = [4.2,3,1.8,3],attack_skill = 2001030,assist_skill = 2100002,assist_condition = [{0,249,1},{250,499,2},{500,749,3},{750,999,4},{1000,1499,5},{1500,999999,6}],talent_skill = 2201030,talent_describe = "对目标造成基础攻击*257%的伤害",personality = 3,personality_desc = "优先攻击对主人造成伤害的敌人，并对优先目标伤害提升10%",speciality = "护佑",recruit_type = [{1,0,60},{2,0,18}]};

get_partner_by_id(104) ->
    #base_partner{partner_id = 104,name = "顽皮蘑菇",model_id = 5010070,weapon_id = 0,chartlet_id = 0,quality = 1,career = 4,born_attr = [800,102,73,87,29],grow_up = [4.2,3,3.6,1.2],attack_skill = 2001040,assist_skill = 2100005,assist_condition = [{0,249,1},{250,499,2},{500,749,3},{750,999,4},{1000,1499,5},{1500,999999,6}],talent_skill = 2201040,talent_describe = "对目标造成基础攻击*257%的伤害",personality = 4,personality_desc = "优先攻击敌方玩家",speciality = "无畏",recruit_type = [{1,0,60},{2,0,18}]};

get_partner_by_id(105) ->
    #base_partner{partner_id = 105,name = "低落蘑菇",model_id = 5010070,weapon_id = 0,chartlet_id = 1,quality = 1,career = 5,born_attr = [800,87,73,102,29],grow_up = [3.6,3,4.2,1.2],attack_skill = 2001050,assist_skill = 2100006,assist_condition = [{0,249,1},{250,499,2},{500,749,3},{750,999,4},{1000,1499,5},{1500,999999,6}],talent_skill = 2201050,talent_describe = "对目标造成基础攻击*257%的伤害",personality = 5,personality_desc = "优先攻击血量最少的目标，并提升全身总抗性10%",speciality = "稳重",recruit_type = [{1,0,60},{2,0,18}]};

get_partner_by_id(106) ->
    #base_partner{partner_id = 106,name = "忧郁蘑菇",model_id = 5010070,weapon_id = 0,chartlet_id = 2,quality = 1,career = 3,born_attr = [800,87,73,44,87],grow_up = [3.6,3,1.8,3.6],attack_skill = 2001060,assist_skill = 2100007,assist_condition = [{0,249,1},{250,499,2},{500,749,3},{750,999,4},{1000,1499,5},{1500,999999,6}],talent_skill = 2201060,talent_describe = "对目标造成基础攻击*257%的伤害",personality = 6,personality_desc = "视野范围内属于你的敌人攻击力降低10%",speciality = "观测",recruit_type = [{1,0,60},{2,0,18}]};

get_partner_by_id(107) ->
    #base_partner{partner_id = 107,name = "愤怒蘑菇",model_id = 5010070,weapon_id = 0,chartlet_id = 3,quality = 1,career = 4,born_attr = [800,102,58,73,58],grow_up = [4.2,2.4,3,2.4],attack_skill = 2001070,assist_skill = 2100001,assist_condition = [{0,249,1},{250,499,2},{500,749,3},{750,999,4},{1000,1499,5},{1500,999999,6}],talent_skill = 2201070,talent_describe = "对目标造成基础攻击*257%的伤害",personality = 7,personality_desc = "优先攻击血量最少的目标，并提升自身攻击力的5%",speciality = "诡计",recruit_type = [{1,0,60},{2,0,18}]};

get_partner_by_id(108) ->
    #base_partner{partner_id = 108,name = "洞穴蝙蝠",model_id = 5010075,weapon_id = 0,chartlet_id = 0,quality = 1,career = 5,born_attr = [800,58,29,102,102],grow_up = [2.4,1.2,4.2,4.2],attack_skill = 2001080,assist_skill = 2100003,assist_condition = [{0,249,1},{250,499,2},{500,749,3},{750,999,4},{1000,1499,5},{1500,999999,6}],talent_skill = 2201080,talent_describe = "对目标造成基础攻击*257%的伤害",personality = 8,personality_desc = "优先攻击最近的目标，并提升全系抗性30%",speciality = "豪放",recruit_type = [{1,0,60},{2,0,18}]};

get_partner_by_id(109) ->
    #base_partner{partner_id = 109,name = "深渊蝙蝠",model_id = 5010075,weapon_id = 0,chartlet_id = 1,quality = 1,career = 1,born_attr = [800,102,87,44,58],grow_up = [4.2,3.6,1.8,2.4],attack_skill = 2001090,assist_skill = 2100004,assist_condition = [{0,249,1},{250,499,2},{500,749,3},{750,999,4},{1000,1499,5},{1500,999999,6}],talent_skill = 2201090,talent_describe = "对目标造成基础攻击*257%的伤害",personality = 9,personality_desc = "视野范围内战力低于你的敌人攻击力降低10%",speciality = "威慑",recruit_type = [{1,0,60},{2,0,18}]};

get_partner_by_id(110) ->
    #base_partner{partner_id = 110,name = "暗夜蝙蝠",model_id = 5010075,weapon_id = 0,chartlet_id = 2,quality = 1,career = 2,born_attr = [800,73,58,44,116],grow_up = [3,2.4,1.8,4.8],attack_skill = 2001100,assist_skill = 2100005,assist_condition = [{0,249,1},{250,499,2},{500,749,3},{750,999,4},{1000,1499,5},{1500,999999,6}],talent_skill = 2201100,talent_describe = "对目标造成基础攻击*257%的伤害",personality = 11,personality_desc = "与主人的攻击目标一致",speciality = "睿智",recruit_type = [{1,0,60},{2,0,18}]};

get_partner_by_id(111) ->
    #base_partner{partner_id = 111,name = "水傀儡",model_id = 5010007,weapon_id = 0,chartlet_id = 0,quality = 1,career = 4,born_attr = [800,58,73,58,102],grow_up = [2.4,3,2.4,4.2],attack_skill = 2001110,assist_skill = 2100006,assist_condition = [{0,249,1},{250,499,2},{500,749,3},{750,999,4},{1000,1499,5},{1500,999999,6}],talent_skill = 2201110,talent_describe = "对目标造成基础攻击*257%的伤害",personality = 12,personality_desc = "血量低于30%时全系抗性提升75%",speciality = "坚韧",recruit_type = [{1,0,60},{2,0,18}]};

get_partner_by_id(112) ->
    #base_partner{partner_id = 112,name = "工程地精",model_id = 5010076,weapon_id = 5010076,chartlet_id = 0,quality = 1,career = 4,born_attr = [800,73,15,87,116],grow_up = [3,0.6,3.6,4.8],attack_skill = 2001120,assist_skill = 2100007,assist_condition = [{0,249,1},{250,499,2},{500,749,3},{750,999,4},{1000,1499,5},{1500,999999,6}],talent_skill = 2201120,talent_describe = "对目标造成基础攻击*257%的伤害",personality = 13,personality_desc = "血量低于30%时攻击力提升45%",speciality = "狂战",recruit_type = [{1,0,60},{2,0,18}]};

get_partner_by_id(113) ->
    #base_partner{partner_id = 113,name = "学徒地精",model_id = 5010076,weapon_id = 5010076,chartlet_id = 1,quality = 1,career = 3,born_attr = [800,102,44,73,73],grow_up = [4.2,1.8,3,3],attack_skill = 2001130,assist_skill = 2100001,assist_condition = [{0,249,1},{250,499,2},{500,749,3},{750,999,4},{1000,1499,5},{1500,999999,6}],talent_skill = 2201130,talent_describe = "对目标造成基础攻击*257%的伤害",personality = 15,personality_desc = "优先攻击血量低于30%的目标，且血量低于30%时攻击力提升30%",speciality = "弑虐",recruit_type = [{1,0,60},{2,0,18}]};

get_partner_by_id(207) ->
    #base_partner{partner_id = 207,name = "暴食怪箱",model_id = 5010068,weapon_id = 0,chartlet_id = 0,quality = 2,career = 1,born_attr = [1000,124,104,124,62],grow_up = [4.8,4,4.8,2.4],attack_skill = 2002070,assist_skill = 2100005,assist_condition = [{0,249,1},{250,499,2},{500,749,3},{750,999,4},{1000,1499,5},{1500,1999,6},{2000,2499,7},{2500,999999,8}],talent_skill = 2202070,talent_describe = "对目标造成基础攻击*276%的伤害",personality = 5,personality_desc = "优先攻击血量最少的目标，并提升全身总抗性10%",speciality = "稳重",recruit_type = [{1,0,20},{2,0,28}]};

get_partner_by_id(208) ->
    #base_partner{partner_id = 208,name = "贪欲怪箱",model_id = 5010068,weapon_id = 0,chartlet_id = 1,quality = 2,career = 2,born_attr = [1000,124,124,124,41],grow_up = [4.8,4.8,4.8,1.6],attack_skill = 2002080,assist_skill = 2100004,assist_condition = [{0,249,1},{250,499,2},{500,749,3},{750,999,4},{1000,1499,5},{1500,1999,6},{2000,2499,7},{2500,999999,8}],talent_skill = 2202080,talent_describe = "对目标造成基础攻击*276%的伤害",personality = 6,personality_desc = "视野范围内属于你的敌人攻击力降低10%",speciality = "观测",recruit_type = [{1,0,20},{2,0,28}]};

get_partner_by_id(209) ->
    #base_partner{partner_id = 209,name = "元素怪箱",model_id = 5010068,weapon_id = 0,chartlet_id = 2,quality = 2,career = 3,born_attr = [1000,124,124,83,83],grow_up = [4.8,4.8,3.2,3.2],attack_skill = 2002090,assist_skill = 2100005,assist_condition = [{0,249,1},{250,499,2},{500,749,3},{750,999,4},{1000,1499,5},{1500,1999,6},{2000,2499,7},{2500,999999,8}],talent_skill = 2202090,talent_describe = "对目标造成基础攻击*276%的伤害",personality = 7,personality_desc = "优先攻击血量最少的目标，并提升自身攻击力的5%",speciality = "诡计",recruit_type = [{1,0,20},{2,0,28}]};

get_partner_by_id(210) ->
    #base_partner{partner_id = 210,name = "恐惧怪箱",model_id = 5010068,weapon_id = 0,chartlet_id = 3,quality = 2,career = 5,born_attr = [1000,104,124,83,104],grow_up = [4,4.8,3.2,4],attack_skill = 2002100,assist_skill = 2100011,assist_condition = [{0,249,1},{250,499,2},{500,749,3},{750,999,4},{1000,1499,5},{1500,1999,6},{2000,2499,7},{2500,999999,8}],talent_skill = 2202100,talent_describe = "对目标造成基础攻击*276%的伤害",personality = 8,personality_desc = "优先攻击最近的目标，并提升全系抗性30%",speciality = "豪放",recruit_type = [{1,0,20},{2,0,28}]};

get_partner_by_id(211) ->
    #base_partner{partner_id = 211,name = "沙漠龙龟",model_id = 5010071,weapon_id = 0,chartlet_id = 0,quality = 2,career = 4,born_attr = [1000,124,62,104,124],grow_up = [4.8,2.4,4,4.8],attack_skill = 2002110,assist_skill = 2100002,assist_condition = [{0,249,1},{250,499,2},{500,749,3},{750,999,4},{1000,1499,5},{1500,1999,6},{2000,2499,7},{2500,999999,8}],talent_skill = 2202110,talent_describe = "对目标造成基础攻击*276%的伤害",personality = 9,personality_desc = "视野范围内战力低于你的敌人攻击力降低10%",speciality = "威慑",recruit_type = [{1,0,20},{2,0,28}]};

get_partner_by_id(212) ->
    #base_partner{partner_id = 212,name = "水华龙龟",model_id = 5010071,weapon_id = 0,chartlet_id = 1,quality = 2,career = 3,born_attr = [1000,124,83,124,83],grow_up = [4.8,3.2,4.8,3.2],attack_skill = 2002120,assist_skill = 2100001,assist_condition = [{0,249,1},{250,499,2},{500,749,3},{750,999,4},{1000,1499,5},{1500,1999,6},{2000,2499,7},{2500,999999,8}],talent_skill = 2202120,talent_describe = "对目标造成基础攻击*276%的伤害",personality = 12,personality_desc = "血量低于30%时全系抗性提升75%",speciality = "坚韧",recruit_type = [{1,0,20},{2,0,28}]};

get_partner_by_id(213) ->
    #base_partner{partner_id = 213,name = "亡灵射手",model_id = 5010077,weapon_id = 5010077,chartlet_id = 0,quality = 2,career = 2,born_attr = [1000,104,62,83,166],grow_up = [4,2.4,3.2,6.4],attack_skill = 2002130,assist_skill = 2100003,assist_condition = [{0,249,1},{250,499,2},{500,749,3},{750,999,4},{1000,1499,5},{1500,1999,6},{2000,2499,7},{2500,999999,8}],talent_skill = 2202130,talent_describe = "对目标造成基础攻击*276%的伤害",personality = 11,personality_desc = "与主人的攻击目标一致",speciality = "睿智",recruit_type = [{1,0,20},{2,0,28}]};

get_partner_by_id(214) ->
    #base_partner{partner_id = 214,name = "不死者射手",model_id = 5010078,weapon_id = 5010078,chartlet_id = 0,quality = 2,career = 5,born_attr = [1000,83,104,83,145],grow_up = [3.2,4,3.2,5.6],attack_skill = 2002140,assist_skill = 2100004,assist_condition = [{0,249,1},{250,499,2},{500,749,3},{750,999,4},{1000,1499,5},{1500,1999,6},{2000,2499,7},{2500,999999,8}],talent_skill = 2202140,talent_describe = "对目标造成基础攻击*276%的伤害",personality = 8,personality_desc = "优先攻击最近的目标，并提升全系抗性30%",speciality = "豪放",recruit_type = [{1,0,20},{2,0,28}]};

get_partner_by_id(215) ->
    #base_partner{partner_id = 215,name = "亡灵猎人",model_id = 5010079,weapon_id = 5010079,chartlet_id = 0,quality = 2,career = 3,born_attr = [1000,104,41,145,124],grow_up = [4,1.6,5.6,4.8],attack_skill = 2002150,assist_skill = 2100008,assist_condition = [{0,249,1},{250,499,2},{500,749,3},{750,999,4},{1000,1499,5},{1500,1999,6},{2000,2499,7},{2500,999999,8}],talent_skill = 2202150,talent_describe = "对目标造成基础攻击*276%的伤害",personality = 13,personality_desc = "血量低于30%时攻击力提升45%",speciality = "狂战",recruit_type = [{1,0,20},{2,0,28}]};

get_partner_by_id(216) ->
    #base_partner{partner_id = 216,name = "小火龙",model_id = 5010037,weapon_id = 0,chartlet_id = 0,quality = 2,career = 4,born_attr = [1000,104,62,124,124],grow_up = [4,2.4,4.8,4.8],attack_skill = 2002160,assist_skill = 2100006,assist_condition = [{0,249,1},{250,499,2},{500,749,3},{750,999,4},{1000,1499,5},{1500,1999,6},{2000,2499,7},{2500,999999,8}],talent_skill = 2202160,talent_describe = "对目标造成基础攻击*276%的伤害",personality = 14,personality_desc = "优先攻击对自身造成伤害的目标，并提升抗属性效果几率的45%",speciality = "强攻",recruit_type = [{1,0,20},{2,0,28}]};

get_partner_by_id(217) ->
    #base_partner{partner_id = 217,name = "炼",model_id = 2010201400,weapon_id = 2020201400,chartlet_id = 0,quality = 2,career = 2,born_attr = [1000,83,104,83,145],grow_up = [3.2,4,3.2,5.6],attack_skill = 2002170,assist_skill = 2100010,assist_condition = [{0,249,1},{250,499,2},{500,749,3},{750,999,4},{1000,1499,5},{1500,1999,6},{2000,2499,7},{2500,3499,8},{3500,4499,9},{4500,5999,10},{6000,7999,11},{8000,999999,12}],talent_skill = 2202170,talent_describe = "对目标造成基础攻击*150%的伤害和1秒受伤时间",personality = 15,personality_desc = "优先攻击血量低于30%的目标，且血量低于30%时攻击力提升30%",speciality = "弑虐",recruit_type = [{1,0,20},{2,0,28}]};

get_partner_by_id(301) ->
    #base_partner{partner_id = 301,name = "洛克",model_id = 2010200600,weapon_id = 2020200600,chartlet_id = 0,quality = 3,career = 1,born_attr = [1200,186,155,186,93],grow_up = [6,5,6,3],attack_skill = 2003010,assist_skill = 2100001,assist_condition = [{0,249,1},{250,499,2},{500,749,3},{750,999,4},{1000,1499,5},{1500,1999,6},{2000,2499,7},{2500,3499,8},{3500,4499,9},{4500,999999,10}],talent_skill = 2203010,talent_describe = "对目标造成基础攻击*400%的伤害",personality = 8,personality_desc = "优先攻击最近的目标，并提升全系抗性30%",speciality = "豪放",recruit_type = [{1,1,10},{2,0,8}]};

get_partner_by_id(302) ->
    #base_partner{partner_id = 302,name = "夜枭法师",model_id = 7010014,weapon_id = 0,chartlet_id = 0,quality = 3,career = 3,born_attr = [1200,217,93,186,124],grow_up = [7,3,6,4],attack_skill = 2003020,assist_skill = 2100003,assist_condition = [{0,249,1},{250,499,2},{500,749,3},{750,999,4},{1000,1499,5},{1500,1999,6},{2000,2499,7},{2500,3499,8},{3500,4499,9},{4500,999999,10}],talent_skill = 2203020,talent_describe = "对目标造成基础攻击*315%的伤害",personality = 9,personality_desc = "视野范围内战力低于你的敌人攻击力降低10%",speciality = "威慑",recruit_type = []};

get_partner_by_id(303) ->
    #base_partner{partner_id = 303,name = "地牢巨人",model_id = 6010012,weapon_id = 0,chartlet_id = 0,quality = 3,career = 4,born_attr = [1200,155,186,186,93],grow_up = [5,6,6,3],attack_skill = 2003030,assist_skill = 2100004,assist_condition = [{0,249,1},{250,499,2},{500,749,3},{750,999,4},{1000,1499,5},{1500,1999,6},{2000,2499,7},{2500,3499,8},{3500,4499,9},{4500,999999,10}],talent_skill = 2203030,talent_describe = "对目标造成基础攻击*315%的伤害",personality = 7,personality_desc = "优先攻击血量最少的目标，并提升自身攻击力的5%",speciality = "诡计",recruit_type = []};

get_partner_by_id(315) ->
    #base_partner{partner_id = 315,name = "独食巨花",model_id = 5010072,weapon_id = 0,chartlet_id = 0,quality = 3,career = 1,born_attr = [1200,93,155,124,248],grow_up = [3,5,4,8],attack_skill = 2003150,assist_skill = 2100007,assist_condition = [{0,249,1},{250,499,2},{500,749,3},{750,999,4},{1000,1499,5},{1500,1999,6},{2000,2499,7},{2500,3499,8},{3500,4499,9},{4500,999999,10}],talent_skill = 2203150,talent_describe = "对目标造成基础攻击*330%的伤害",personality = 14,personality_desc = "优先攻击对自身造成伤害的目标，并提升抗属性效果几率的45%",speciality = "强攻",recruit_type = [{1,1,10},{2,0,8}]};

get_partner_by_id(316) ->
    #base_partner{partner_id = 316,name = "剧毒巨花",model_id = 5010072,weapon_id = 0,chartlet_id = 1,quality = 3,career = 2,born_attr = [1200,124,93,155,248],grow_up = [4,3,5,8],attack_skill = 2003160,assist_skill = 2100001,assist_condition = [{0,249,1},{250,499,2},{500,749,3},{750,999,4},{1000,1499,5},{1500,1999,6},{2000,2499,7},{2500,3499,8},{3500,4499,9},{4500,999999,10}],talent_skill = 2203160,talent_describe = "对目标造成基础攻击*330%的伤害",personality = 15,personality_desc = "优先攻击血量低于30%的目标，且血量低于30%时攻击力提升30%",speciality = "弑虐",recruit_type = [{1,1,10},{2,0,8}]};

get_partner_by_id(317) ->
    #base_partner{partner_id = 317,name = "冰冻巨花",model_id = 5010072,weapon_id = 0,chartlet_id = 2,quality = 3,career = 3,born_attr = [1200,186,155,155,124],grow_up = [6,5,5,4],attack_skill = 2003170,assist_skill = 2100003,assist_condition = [{0,249,1},{250,499,2},{500,749,3},{750,999,4},{1000,1499,5},{1500,1999,6},{2000,2499,7},{2500,3499,8},{3500,4499,9},{4500,999999,10}],talent_skill = 2203170,talent_describe = "对目标造成基础攻击*330%的伤害",personality = 1,personality_desc = "优先攻击对主人造成伤害的敌人，并降低其攻击力的10%（攻击降低持续3秒）",speciality = "忠诚",recruit_type = [{1,1,10},{2,0,8}]};

get_partner_by_id(318) ->
    #base_partner{partner_id = 318,name = "陵墓守护者",model_id = 5010080,weapon_id = 0,chartlet_id = 0,quality = 3,career = 4,born_attr = [1200,93,62,186,279],grow_up = [3,2,6,9],attack_skill = 2003180,assist_skill = 2100002,assist_condition = [{0,249,1},{250,499,2},{500,749,3},{750,999,4},{1000,1499,5},{1500,1999,6},{2000,2499,7},{2500,3499,8},{3500,4499,9},{4500,999999,10}],talent_skill = 2203180,talent_describe = "对目标造成基础攻击*400%的伤害",personality = 2,personality_desc = "永久提升抗会心几率400点",speciality = "稳重",recruit_type = [{1,1,10},{2,0,8}]};

get_partner_by_id(319) ->
    #base_partner{partner_id = 319,name = "陵墓寻路者",model_id = 5010080,weapon_id = 0,chartlet_id = 1,quality = 3,career = 5,born_attr = [1200,155,186,124,155],grow_up = [5,6,4,5],attack_skill = 2003190,assist_skill = 2100011,assist_condition = [{0,249,1},{250,499,2},{500,749,3},{750,999,4},{1000,1499,5},{1500,1999,6},{2000,2499,7},{2500,3499,8},{3500,4499,9},{4500,999999,10}],talent_skill = 2203190,talent_describe = "对目标造成基础攻击*400%的伤害",personality = 3,personality_desc = "优先攻击对主人造成伤害的敌人，并对优先目标伤害提升10%",speciality = "护佑",recruit_type = [{1,1,10},{2,0,8}]};

get_partner_by_id(320) ->
    #base_partner{partner_id = 320,name = "冰霜战士",model_id = 5010083,weapon_id = 0,chartlet_id = 0,quality = 3,career = 1,born_attr = [1200,155,186,186,93],grow_up = [5,6,6,3],attack_skill = 2003200,assist_skill = 2100005,assist_condition = [{0,249,1},{250,499,2},{500,749,3},{750,999,4},{1000,1499,5},{1500,1999,6},{2000,2499,7},{2500,3499,8},{3500,4499,9},{4500,999999,10}],talent_skill = 2203200,talent_describe = "对目标造成基础攻击*180%的伤害，并晕眩1秒",personality = 4,personality_desc = "优先攻击敌方玩家",speciality = "无畏",recruit_type = [{1,1,10},{2,0,8}]};

get_partner_by_id(321) ->
    #base_partner{partner_id = 321,name = "冰霜勇士",model_id = 5010084,weapon_id = 0,chartlet_id = 0,quality = 3,career = 5,born_attr = [1200,186,186,186,62],grow_up = [6,6,6,2],attack_skill = 2003210,assist_skill = 2100007,assist_condition = [{0,249,1},{250,499,2},{500,749,3},{750,999,4},{1000,1499,5},{1500,1999,6},{2000,2499,7},{2500,3499,8},{3500,4499,9},{4500,999999,10}],talent_skill = 2203210,talent_describe = "对目标造成基础攻击*315%的伤害",personality = 5,personality_desc = "优先攻击血量最少的目标，并提升全身总抗性10%",speciality = "稳重",recruit_type = [{1,1,10},{2,0,8}]};

get_partner_by_id(322) ->
    #base_partner{partner_id = 322,name = "冰霜女巫",model_id = 5010085,weapon_id = 0,chartlet_id = 0,quality = 3,career = 2,born_attr = [1200,217,93,186,124],grow_up = [7,3,6,4],attack_skill = 2003220,assist_skill = 2100010,assist_condition = [{0,249,1},{250,499,2},{500,749,3},{750,999,4},{1000,1499,5},{1500,1999,6},{2000,2499,7},{2500,3499,8},{3500,4499,9},{4500,999999,10}],talent_skill = 2203220,talent_describe = "对目标造成基础攻击*315%的伤害",personality = 15,personality_desc = "优先攻击血量低于30%的目标，且血量低于30%时攻击力提升30%",speciality = "弑虐",recruit_type = [{1,1,10},{2,0,8}]};

get_partner_by_id(323) ->
    #base_partner{partner_id = 323,name = "汉娜",model_id = 2010400100,weapon_id = 2020400100,chartlet_id = 0,quality = 3,career = 3,born_attr = [1200,248,124,124,124],grow_up = [8,4,4,4],attack_skill = 2003230,assist_skill = 2100005,assist_condition = [{0,249,1},{250,499,2},{500,749,3},{750,999,4},{1000,1499,5},{1500,1999,6},{2000,2499,7},{2500,3499,8},{3500,4499,9},{4500,5999,10},{6000,7999,11},{8000,999999,12}],talent_skill = 2203230,talent_describe = "回复一个目标的血量，持续5秒，每秒回复体质*1.5的血量",personality = 5,personality_desc = "优先攻击血量最少的目标，并提升全身总抗性10%",speciality = "稳重",recruit_type = [{1,1,10},{2,0,8}]};

get_partner_by_id(324) ->
    #base_partner{partner_id = 324,name = "冰晶恶魔",model_id = 6010013,weapon_id = 0,chartlet_id = 1,quality = 3,career = 3,born_attr = [1200,217,93,186,124],grow_up = [7,3,6,4],attack_skill = 2003240,assist_skill = 2100004,assist_condition = [{0,249,1},{250,499,2},{500,749,3},{750,999,4},{1000,1499,5},{1500,1999,6},{2000,2499,7},{2500,3499,8},{3500,4499,9},{4500,999999,10}],talent_skill = 2203240,talent_describe = "对目标造成基础攻击*180%的伤害，并造成1秒受伤",personality = 6,personality_desc = "视野范围内属于你的敌人攻击力降低10%",speciality = "观测",recruit_type = []};

get_partner_by_id(325) ->
    #base_partner{partner_id = 325,name = "暗石恶魔",model_id = 6010013,weapon_id = 0,chartlet_id = 2,quality = 3,career = 2,born_attr = [1200,248,124,124,124],grow_up = [8,4,4,4],attack_skill = 2003250,assist_skill = 2100002,assist_condition = [{0,249,1},{250,499,2},{500,749,3},{750,999,4},{1000,1499,5},{1500,1999,6},{2000,2499,7},{2500,3499,8},{3500,4499,9},{4500,5999,10},{6000,7999,11},{8000,999999,12}],talent_skill = 2203250,talent_describe = "对目标造成基础攻击*180%的伤害，并造成1秒迟缓",personality = 12,personality_desc = "血量低于30%时全系抗性提升75%",speciality = "坚韧",recruit_type = []};

get_partner_by_id(326) ->
    #base_partner{partner_id = 326,name = "熔岩恶魔",model_id = 6010013,weapon_id = 0,chartlet_id = 0,quality = 3,career = 5,born_attr = [1200,155,31,248,186],grow_up = [5,1,8,6],attack_skill = 2003260,assist_skill = 2100011,assist_condition = [{0,249,1},{250,499,2},{500,749,3},{750,999,4},{1000,1499,5},{1500,1999,6},{2000,2499,7},{2500,3499,8},{3500,4499,9},{4500,999999,10}],talent_skill = 2203260,talent_describe = "对目标造成基础攻击*180%的伤害，并造成1秒弱体",personality = 9,personality_desc = "视野范围内战力低于你的敌人攻击力降低10%",speciality = "威慑",recruit_type = []};

get_partner_by_id(401) ->
    #base_partner{partner_id = 401,name = "梅迪莎",model_id = 2010300200,weapon_id = 2020300200,chartlet_id = 0,quality = 4,career = 4,born_attr = [1500,173,86,345,259],grow_up = [4.8,2.4,9.6,7.2],attack_skill = 2004010,assist_skill = 2100007,assist_condition = [{0,249,1},{250,499,2},{500,749,3},{750,999,4},{1000,1499,5},{1500,1999,6},{2000,2499,7},{2500,3499,8},{3500,4499,9},{4500,5999,10},{6000,7999,11},{8000,999999,12}],talent_skill = 2204010,talent_describe = "向前射击3下，最后一下造成爆炸，对命中单位总共造成基础攻击*400%的伤害",personality = 15,personality_desc = "优先攻击血量低于30%的目标，且血量低于30%时攻击力提升30%",speciality = "弑虐",recruit_type = [{2,1,20}]};

get_partner_by_id(402) ->
    #base_partner{partner_id = 402,name = "夏洛特",model_id = 2010200300,weapon_id = 2020200300,chartlet_id = 0,quality = 4,career = 1,born_attr = [1500,259,216,259,129],grow_up = [7.2,6,7.2,3.6],attack_skill = 2004020,assist_skill = 2100005,assist_condition = [{0,249,1},{250,499,2},{500,749,3},{750,999,4},{1000,1499,5},{1500,1999,6},{2000,2499,7},{2500,3499,8},{3500,4499,9},{4500,5999,10},{6000,7999,11},{8000,999999,12}],talent_skill = 2204020,talent_describe = "持续剑舞攻击周围单位，对周围单位造成基础攻击*400%的伤害",personality = 13,personality_desc = "血量低于30%时攻击力提升45%",speciality = "狂战",recruit_type = [{2,1,20}]};

get_partner_by_id(403) ->
    #base_partner{partner_id = 403,name = "龙之魔女",model_id = 2010201200,weapon_id = 2020201200,chartlet_id = 0,quality = 4,career = 2,born_attr = [1500,129,173,173,388],grow_up = [3.6,4.8,4.8,10.8],attack_skill = 2004030,assist_skill = 2100010,assist_condition = [{0,249,1},{250,499,2},{500,749,3},{750,999,4},{1000,1499,5},{1500,1999,6},{2000,2499,7},{2500,3499,8},{3500,4499,9},{4500,5999,10},{6000,7999,11},{8000,999999,12}],talent_skill = 2204030,talent_describe = "对目标造成基础攻击*200%的伤害，并造成2秒受伤",personality = 14,personality_desc = "优先攻击对自身造成伤害的目标，并提升抗属性效果几率的45%",speciality = "强攻",recruit_type = [{2,1,20}]};

get_partner_by_id(406) ->
    #base_partner{partner_id = 406,name = "布莱克",model_id = 2010200800,weapon_id = 2020200800,chartlet_id = 0,quality = 4,career = 5,born_attr = [1500,259,259,216,129],grow_up = [7.2,7.2,6,3.6],attack_skill = 2004060,assist_skill = 2100004,assist_condition = [{0,249,1},{250,499,2},{500,749,3},{750,999,4},{1000,1499,5},{1500,1999,6},{2000,2499,7},{2500,3499,8},{3500,4499,9},{4500,5999,10},{6000,7999,11},{8000,999999,12}],talent_skill = 2204060,talent_describe = "对目标造成基础攻击*200%的伤害，并造成2秒受伤",personality = 11,personality_desc = "与主人的攻击目标一致",speciality = "睿智",recruit_type = [{2,1,20}]};

get_partner_by_id(407) ->
    #base_partner{partner_id = 407,name = "菲利斯",model_id = 2010200900,weapon_id = 2020200900,chartlet_id = 0,quality = 4,career = 4,born_attr = [1500,173,86,259,345],grow_up = [4.8,2.4,7.2,9.6],attack_skill = 2004070,assist_skill = 2100006,assist_condition = [{0,249,1},{250,499,2},{500,749,3},{750,999,4},{1000,1499,5},{1500,1999,6},{2000,2499,7},{2500,3499,8},{3500,4499,9},{4500,5999,10},{6000,7999,11},{8000,999999,12}],talent_skill = 2204070,talent_describe = "对目标造成基础攻击*200%的伤害，并造成2秒弱体",personality = 12,personality_desc = "血量低于30%时全系抗性提升75%",speciality = "坚韧",recruit_type = [{2,1,20}]};

get_partner_by_id(408) ->
    #base_partner{partner_id = 408,name = "圣少女贞德",model_id = 2010301000,weapon_id = 2020301000,chartlet_id = 0,quality = 4,career = 3,born_attr = [1500,216,173,129,345],grow_up = [6,4.8,3.6,9.6],attack_skill = 2004080,assist_skill = 2100008,assist_condition = [{0,249,1},{250,499,2},{500,749,3},{750,999,4},{1000,1499,5},{1500,1999,6},{2000,2499,7},{2500,3499,8},{3500,4499,9},{4500,5999,10},{6000,7999,11},{8000,999999,12}],talent_skill = 2204080,talent_describe = "对目标造成基础攻击*210%的伤害，并造成2秒迟缓",personality = 9,personality_desc = "视野范围内战力低于你的敌人攻击力降低10%",speciality = "威慑",recruit_type = [{2,1,20}]};

get_partner_by_id(413) ->
    #base_partner{partner_id = 413,name = "蔷薇皇女",model_id = 2010401600,weapon_id = 2020401600,chartlet_id = 0,quality = 4,career = 1,born_attr = [1500,259,216,302,86],grow_up = [7.2,6,8.4,2.4],attack_skill = 2004130,assist_skill = 2100007,assist_condition = [{0,249,1},{250,499,2},{500,749,3},{750,999,4},{1000,1499,5},{1500,1999,6},{2000,2499,7},{2500,3499,8},{3500,4499,9},{4500,5999,10},{6000,7999,11},{8000,999999,12}],talent_skill = 2204130,talent_describe = "给队友增加一个护盾，共抵挡攻击*1.5+600点伤害，持续5秒",personality = 8,personality_desc = "优先攻击最近的目标，并提升全系抗性30%",speciality = "豪放",recruit_type = [{2,1,20}]};

get_partner_by_id(417) ->
    #base_partner{partner_id = 417,name = "哥布林首领",model_id = 6010007,weapon_id = 0,chartlet_id = 0,quality = 4,career = 5,born_attr = [1500,173,43,259,388],grow_up = [4.8,1.2,7.2,10.8],attack_skill = 2004170,assist_skill = 2100010,assist_condition = [{0,249,1},{250,499,2},{500,749,3},{750,999,4},{1000,1499,5},{1500,1999,6},{2000,2499,7},{2500,3499,8},{3500,4499,9},{4500,5999,10},{6000,7999,11},{8000,999999,12}],talent_skill = 2204170,talent_describe = "对目标造成基础攻击*200%的伤害，并造成1.5秒晕眩",personality = 9,personality_desc = "视野范围内战力低于你的敌人攻击力降低10%",speciality = "威慑",recruit_type = []};

get_partner_by_id(418) ->
    #base_partner{partner_id = 418,name = "蜥蜴首领",model_id = 6010010,weapon_id = 0,chartlet_id = 0,quality = 4,career = 5,born_attr = [1500,259,216,259,129],grow_up = [7.2,6,7.2,3.6],attack_skill = 2004180,assist_skill = 2100003,assist_condition = [{0,249,1},{250,499,2},{500,749,3},{750,999,4},{1000,1499,5},{1500,1999,6},{2000,2499,7},{2500,3499,8},{3500,4499,9},{4500,5999,10},{6000,7999,11},{8000,999999,12}],talent_skill = 2204180,talent_describe = "攻击周围单位，造成基础攻击*200%伤害，并降低命中单位10%攻击和30%的会心几率",personality = 2,personality_desc = "永久提升抗会心几率400点",speciality = "稳重",recruit_type = []};

get_partner_by_id(422) ->
    #base_partner{partner_id = 422,name = "冥火之主",model_id = 7010001,weapon_id = 0,chartlet_id = 0,quality = 4,career = 2,born_attr = [1500,129,173,173,388],grow_up = [3.6,4.8,4.8,10.8],attack_skill = 2004220,assist_skill = 2100004,assist_condition = [{0,249,1},{250,499,2},{500,749,3},{750,999,4},{1000,1499,5},{1500,1999,6},{2000,2499,7},{2500,3499,8},{3500,4499,9},{4500,5999,10},{6000,7999,11},{8000,999999,12}],talent_skill = 2204220,talent_describe = "对目标造成基础攻击*315%的伤害",personality = 3,personality_desc = "优先攻击对主人造成伤害的敌人，并对优先目标伤害提升10%",speciality = "护佑",recruit_type = []};

get_partner_by_id(423) ->
    #base_partner{partner_id = 423,name = "娜迦女王",model_id = 7010002,weapon_id = 0,chartlet_id = 0,quality = 4,career = 3,born_attr = [1500,259,129,259,216],grow_up = [7.2,3.6,7.2,6],attack_skill = 2004230,assist_skill = 2100005,assist_condition = [{0,249,1},{250,499,2},{500,749,3},{750,999,4},{1000,1499,5},{1500,1999,6},{2000,2499,7},{2500,3499,8},{3500,4499,9},{4500,5999,10},{6000,7999,11},{8000,999999,12}],talent_skill = 2204230,talent_describe = "对目标范围攻击四次，每次造成基础攻击*75%的伤害，并有20%概率造成1.5秒迟缓",personality = 1,personality_desc = "优先攻击对主人造成伤害的敌人，并降低其攻击力的10%（攻击降低持续3秒）",speciality = "忠诚",recruit_type = []};

get_partner_by_id(428) ->
    #base_partner{partner_id = 428,name = "炎魔赤主",model_id = 7010007,weapon_id = 0,chartlet_id = 0,quality = 4,career = 4,born_attr = [1500,129,129,302,302],grow_up = [3.6,3.6,8.4,8.4],attack_skill = 2004280,assist_skill = 2100011,assist_condition = [{0,249,1},{250,499,2},{500,749,3},{750,999,4},{1000,1499,5},{1500,1999,6},{2000,2499,7},{2500,3499,8},{3500,4499,9},{4500,5999,10},{6000,7999,11},{8000,999999,12}],talent_skill = 2204280,talent_describe = "对目标范围攻击四次，每次造成基础攻击*80%的伤害",personality = 14,personality_desc = "优先攻击对自身造成伤害的目标，并提升抗属性效果几率的45%",speciality = "强攻",recruit_type = []};

get_partner_by_id(431) ->
    #base_partner{partner_id = 431,name = "凯文",model_id = 2010443100,weapon_id = 2020443100,chartlet_id = 0,quality = 4,career = 4,born_attr = [1500,259,216,259,129],grow_up = [7.2,6,7.2,3.6],attack_skill = 2004310,assist_skill = 2100007,assist_condition = [{0,249,1},{250,499,2},{500,749,3},{750,999,4},{1000,1499,5},{1500,1999,6},{2000,2499,7},{2500,3499,8},{3500,4499,9},{4500,5999,10},{6000,7999,11},{8000,999999,12}],talent_skill = 2204310,talent_describe = "向前冲刺500距离，对命中的单位造成200%基础伤害，并晕眩1秒",personality = 11,personality_desc = "与主人的攻击目标一致",speciality = "睿智",recruit_type = [{2,1,20}]};

get_partner_by_id(432) ->
    #base_partner{partner_id = 432,name = "杰兰特",model_id = 2010443200,weapon_id = 2020443200,chartlet_id = 0,quality = 4,career = 5,born_attr = [1500,129,173,173,388],grow_up = [3.6,4.8,4.8,10.8],attack_skill = 2004320,assist_skill = 2100001,assist_condition = [{0,249,1},{250,499,2},{500,749,3},{750,999,4},{1000,1499,5},{1500,1999,6},{2000,2499,7},{2500,3499,8},{3500,4499,9},{4500,5999,10},{6000,7999,11},{8000,999999,12}],talent_skill = 2204320,talent_describe = "对目标持续攻击，造成400%基础攻击伤害",personality = 4,personality_desc = "优先攻击敌方玩家",speciality = "无畏",recruit_type = [{2,1,20}]};

get_partner_by_id(433) ->
    #base_partner{partner_id = 433,name = "樱",model_id = 2010443300,weapon_id = 2020443300,chartlet_id = 0,quality = 4,career = 2,born_attr = [1500,259,129,259,216],grow_up = [7.2,3.6,7.2,6],attack_skill = 2004330,assist_skill = 2100003,assist_condition = [{0,249,1},{250,499,2},{500,749,3},{750,999,4},{1000,1499,5},{1500,1999,6},{2000,2499,7},{2500,3499,8},{3500,4499,9},{4500,5999,10},{6000,7999,11},{8000,999999,12}],talent_skill = 2204330,talent_describe = "对目标造成200%基础伤害，并造成2秒受伤",personality = 5,personality_desc = "优先攻击血量最少的目标，并提升全身总抗性10%",speciality = "稳重",recruit_type = [{2,1,20}]};

get_partner_by_id(501) ->
    #base_partner{partner_id = 501,name = "圣女贞德",model_id = 2010420100,weapon_id = 2020420100,chartlet_id = 0,quality = 5,career = 3,born_attr = [2000,396,226,283,226],grow_up = [10.5,6,7.5,6],attack_skill = 2005010,assist_skill = 2100008,assist_condition = [{0,249,1},{250,499,2},{500,749,3},{750,999,4},{1000,1499,5},{1500,1999,6},{2000,2499,7},{2500,3499,8},{3500,4499,9},{4500,5999,10},{6000,7999,11},{8000,9999,12},{10000,14999,13},{15000,19999,14},{20000,24999,15},{25000,999999,16}],talent_skill = 2205010,talent_describe = "召唤剑阵围绕自己旋转，对靠近的单位每次造成基础攻击*80%的伤害",personality = 6,personality_desc = "视野范围内属于你的敌人攻击力降低10%",speciality = "观测",recruit_type = []};

get_partner_by_id(502) ->
    #base_partner{partner_id = 502,name = "亚瑟王",model_id = 2010420200,weapon_id = 2020420200,chartlet_id = 0,quality = 5,career = 1,born_attr = [2000,339,339,339,113],grow_up = [9,9,9,3],attack_skill = 2005020,assist_skill = 2100001,assist_condition = [{0,249,1},{250,499,2},{500,749,3},{750,999,4},{1000,1499,5},{1500,1999,6},{2000,2499,7},{2500,3499,8},{3500,4499,9},{4500,5999,10},{6000,7999,11},{8000,9999,12},{10000,14999,13},{15000,19999,14},{20000,24999,15},{25000,999999,16}],talent_skill = 2205020,talent_describe = "对目标区域造成390%基础伤害",personality = 2,personality_desc = "永久提升抗会心几率400点",speciality = "稳重",recruit_type = []};

get_partner_by_id(503) ->
    #base_partner{partner_id = 503,name = "布伦希尔德",model_id = 2010520300,weapon_id = 2020520300,chartlet_id = 0,quality = 5,career = 5,born_attr = [2000,339,339,226,226],grow_up = [9,9,6,6],attack_skill = 2005030,assist_skill = 2100009,assist_condition = [{0,249,1},{250,499,2},{500,749,3},{750,999,4},{1000,1499,5},{1500,1999,6},{2000,2499,7},{2500,3499,8},{3500,4499,9},{4500,5999,10},{6000,7999,11},{8000,9999,12},{10000,14999,13},{15000,19999,14},{20000,24999,15},{25000,999999,16}],talent_skill = 2205030,talent_describe = "对目标造成300%基础伤害，并造成2秒浮空",personality = 7,personality_desc = "优先攻击血量最少的目标，并提升自身攻击力的5%",speciality = "诡计",recruit_type = [{2,1,10}]};

get_partner_by_id(_Partnerid) ->
    [].

get_all_partner() ->
[{101,1,[{1,0,60},{2,0,18}]},{102,1,[{1,0,60},{2,0,18}]},{103,1,[{1,0,60},{2,0,18}]},{104,1,[{1,0,60},{2,0,18}]},{105,1,[{1,0,60},{2,0,18}]},{106,1,[{1,0,60},{2,0,18}]},{107,1,[{1,0,60},{2,0,18}]},{108,1,[{1,0,60},{2,0,18}]},{109,1,[{1,0,60},{2,0,18}]},{110,1,[{1,0,60},{2,0,18}]},{111,1,[{1,0,60},{2,0,18}]},{112,1,[{1,0,60},{2,0,18}]},{113,1,[{1,0,60},{2,0,18}]},{207,2,[{1,0,20},{2,0,28}]},{208,2,[{1,0,20},{2,0,28}]},{209,2,[{1,0,20},{2,0,28}]},{210,2,[{1,0,20},{2,0,28}]},{211,2,[{1,0,20},{2,0,28}]},{212,2,[{1,0,20},{2,0,28}]},{213,2,[{1,0,20},{2,0,28}]},{214,2,[{1,0,20},{2,0,28}]},{215,2,[{1,0,20},{2,0,28}]},{216,2,[{1,0,20},{2,0,28}]},{217,2,[{1,0,20},{2,0,28}]},{301,3,[{1,1,10},{2,0,8}]},{302,3,[]},{303,3,[]},{315,3,[{1,1,10},{2,0,8}]},{316,3,[{1,1,10},{2,0,8}]},{317,3,[{1,1,10},{2,0,8}]},{318,3,[{1,1,10},{2,0,8}]},{319,3,[{1,1,10},{2,0,8}]},{320,3,[{1,1,10},{2,0,8}]},{321,3,[{1,1,10},{2,0,8}]},{322,3,[{1,1,10},{2,0,8}]},{323,3,[{1,1,10},{2,0,8}]},{324,3,[]},{325,3,[]},{326,3,[]},{401,4,[{2,1,20}]},{402,4,[{2,1,20}]},{403,4,[{2,1,20}]},{406,4,[{2,1,20}]},{407,4,[{2,1,20}]},{408,4,[{2,1,20}]},{413,4,[{2,1,20}]},{417,4,[]},{418,4,[]},{422,4,[]},{423,4,[]},{428,4,[]},{431,4,[{2,1,20}]},{432,4,[{2,1,20}]},{433,4,[{2,1,20}]},{501,5,[]},{502,5,[]},{503,5,[{2,1,10}]}].

get_recuit(1) ->
    #base_partner_recruit{recruit_type = 1,free_cd = 28800,goods = [{0,212202,1}],single_recruit = [{3,0,30000}],ten_recruit = [{3,0,270000}],pr = 1000,guaran_num = 10,guaran_quality = [3]};

get_recuit(2) ->
    #base_partner_recruit{recruit_type = 2,free_cd = 172800,goods = [{0,212101,1}],single_recruit = [{1,0,240}],ten_recruit = [{1,0,1980}],pr = 1000,guaran_num = 10,guaran_quality = [4,5]};

get_recuit(_Recruittype) ->
    [].

get_all_recuit() ->
[1,2].

get_wash_cfg(1) ->
    #base_partner_wash{quality = 1,goods = [{0,212101,1}],wash_attr = [{1,100},{2,300},{3,300},{4,200},{5,100}],random_attr = [{30,600,700},{50,700,800},{18,800,900},{2,900,1050}],comm_skill = [{0,50},{1,40},{2,10}],sk_quality = [{1,100}],prodigy = [{1,50,50},{50,200,300}]};

get_wash_cfg(2) ->
    #base_partner_wash{quality = 2,goods = [{0,212101,2}],wash_attr = [{1,100},{2,300},{3,300},{4,200},{5,100}],random_attr = [{30,600,700},{50,700,800},{18,800,900},{2,900,1050}],comm_skill = [{0,40},{1,30},{2,20},{3,10}],sk_quality = [{1,75},{2,25}],prodigy = [{1,100,50},{100,500,300}]};

get_wash_cfg(3) ->
    #base_partner_wash{quality = 3,goods = [{0,212101,4}],wash_attr = [{1,100},{2,300},{3,300},{4,200},{5,100}],random_attr = [{30,600,700},{50,700,800},{18,800,900},{2,900,1050}],comm_skill = [{0,20},{1,40},{2,20},{3,15},{4,5}],sk_quality = [{1,60},{2,25},{3,15}],prodigy = [{1,250,80},{250,3000,400}]};

get_wash_cfg(4) ->
    #base_partner_wash{quality = 4,goods = [{0,212101,12}],wash_attr = [{1,50},{2,100},{3,300},{4,350},{5,200}],random_attr = [{10,400,500},{40,500,700},{38,700,800},{10,800,900},{2,900,1050}],comm_skill = [{1,10},{2,20},{3,50},{4,15},{5,5}],sk_quality = [{1,20},{2,35},{3,25},{4,20}],prodigy = [{1,1500,150},{1500,30000,400}]};

get_wash_cfg(5) ->
    #base_partner_wash{quality = 5,goods = [{0,212101,48}],wash_attr = [{1,50},{2,100},{3,300},{4,350},{5,200}],random_attr = [{30,500,700},{35,700,800},{30,800,900},{5,900,1050}],comm_skill = [{2,10},{3,50},{4,30},{5,10}],sk_quality = [{1,5},{2,30},{3,35},{4,20},{5,10}],prodigy = [{1,3000,200},{3000,30000,600}]};

get_wash_cfg(_Quality) ->
    [].

get_lv_upgrade(1) ->
    #base_partner_upgrade{lv = 1,max_exp = 2500,percentage = 25};

get_lv_upgrade(2) ->
    #base_partner_upgrade{lv = 2,max_exp = 5000,percentage = 25};

get_lv_upgrade(3) ->
    #base_partner_upgrade{lv = 3,max_exp = 7500,percentage = 25};

get_lv_upgrade(4) ->
    #base_partner_upgrade{lv = 4,max_exp = 10000,percentage = 25};

get_lv_upgrade(5) ->
    #base_partner_upgrade{lv = 5,max_exp = 12500,percentage = 25};

get_lv_upgrade(6) ->
    #base_partner_upgrade{lv = 6,max_exp = 15000,percentage = 25};

get_lv_upgrade(7) ->
    #base_partner_upgrade{lv = 7,max_exp = 17500,percentage = 25};

get_lv_upgrade(8) ->
    #base_partner_upgrade{lv = 8,max_exp = 20000,percentage = 25};

get_lv_upgrade(9) ->
    #base_partner_upgrade{lv = 9,max_exp = 22500,percentage = 25};

get_lv_upgrade(10) ->
    #base_partner_upgrade{lv = 10,max_exp = 25000,percentage = 25};

get_lv_upgrade(11) ->
    #base_partner_upgrade{lv = 11,max_exp = 27500,percentage = 25};

get_lv_upgrade(12) ->
    #base_partner_upgrade{lv = 12,max_exp = 30000,percentage = 25};

get_lv_upgrade(13) ->
    #base_partner_upgrade{lv = 13,max_exp = 32500,percentage = 25};

get_lv_upgrade(14) ->
    #base_partner_upgrade{lv = 14,max_exp = 35000,percentage = 25};

get_lv_upgrade(15) ->
    #base_partner_upgrade{lv = 15,max_exp = 37500,percentage = 25};

get_lv_upgrade(16) ->
    #base_partner_upgrade{lv = 16,max_exp = 40000,percentage = 25};

get_lv_upgrade(17) ->
    #base_partner_upgrade{lv = 17,max_exp = 42500,percentage = 25};

get_lv_upgrade(18) ->
    #base_partner_upgrade{lv = 18,max_exp = 45000,percentage = 25};

get_lv_upgrade(19) ->
    #base_partner_upgrade{lv = 19,max_exp = 47500,percentage = 25};

get_lv_upgrade(20) ->
    #base_partner_upgrade{lv = 20,max_exp = 100000,percentage = 25};

get_lv_upgrade(21) ->
    #base_partner_upgrade{lv = 21,max_exp = 120000,percentage = 25};

get_lv_upgrade(22) ->
    #base_partner_upgrade{lv = 22,max_exp = 140000,percentage = 25};

get_lv_upgrade(23) ->
    #base_partner_upgrade{lv = 23,max_exp = 160000,percentage = 25};

get_lv_upgrade(24) ->
    #base_partner_upgrade{lv = 24,max_exp = 180000,percentage = 25};

get_lv_upgrade(25) ->
    #base_partner_upgrade{lv = 25,max_exp = 200000,percentage = 25};

get_lv_upgrade(26) ->
    #base_partner_upgrade{lv = 26,max_exp = 225000,percentage = 25};

get_lv_upgrade(27) ->
    #base_partner_upgrade{lv = 27,max_exp = 250000,percentage = 25};

get_lv_upgrade(28) ->
    #base_partner_upgrade{lv = 28,max_exp = 275000,percentage = 25};

get_lv_upgrade(29) ->
    #base_partner_upgrade{lv = 29,max_exp = 300000,percentage = 25};

get_lv_upgrade(30) ->
    #base_partner_upgrade{lv = 30,max_exp = 580000,percentage = 25};

get_lv_upgrade(31) ->
    #base_partner_upgrade{lv = 31,max_exp = 600000,percentage = 20};

get_lv_upgrade(32) ->
    #base_partner_upgrade{lv = 32,max_exp = 700000,percentage = 20};

get_lv_upgrade(33) ->
    #base_partner_upgrade{lv = 33,max_exp = 800000,percentage = 20};

get_lv_upgrade(34) ->
    #base_partner_upgrade{lv = 34,max_exp = 900000,percentage = 20};

get_lv_upgrade(35) ->
    #base_partner_upgrade{lv = 35,max_exp = 1000000,percentage = 20};

get_lv_upgrade(36) ->
    #base_partner_upgrade{lv = 36,max_exp = 1100000,percentage = 20};

get_lv_upgrade(37) ->
    #base_partner_upgrade{lv = 37,max_exp = 1200000,percentage = 20};

get_lv_upgrade(38) ->
    #base_partner_upgrade{lv = 38,max_exp = 1300000,percentage = 20};

get_lv_upgrade(39) ->
    #base_partner_upgrade{lv = 39,max_exp = 1400000,percentage = 20};

get_lv_upgrade(40) ->
    #base_partner_upgrade{lv = 40,max_exp = 2000000,percentage = 20};

get_lv_upgrade(41) ->
    #base_partner_upgrade{lv = 41,max_exp = 2090000,percentage = 19};

get_lv_upgrade(42) ->
    #base_partner_upgrade{lv = 42,max_exp = 2280000,percentage = 19};

get_lv_upgrade(43) ->
    #base_partner_upgrade{lv = 43,max_exp = 2470000,percentage = 19};

get_lv_upgrade(44) ->
    #base_partner_upgrade{lv = 44,max_exp = 2660000,percentage = 19};

get_lv_upgrade(45) ->
    #base_partner_upgrade{lv = 45,max_exp = 2850000,percentage = 19};

get_lv_upgrade(46) ->
    #base_partner_upgrade{lv = 46,max_exp = 3040000,percentage = 19};

get_lv_upgrade(47) ->
    #base_partner_upgrade{lv = 47,max_exp = 3230000,percentage = 19};

get_lv_upgrade(48) ->
    #base_partner_upgrade{lv = 48,max_exp = 3420000,percentage = 19};

get_lv_upgrade(49) ->
    #base_partner_upgrade{lv = 49,max_exp = 3610000,percentage = 19};

get_lv_upgrade(50) ->
    #base_partner_upgrade{lv = 50,max_exp = 4560000,percentage = 19};

get_lv_upgrade(51) ->
    #base_partner_upgrade{lv = 51,max_exp = 4680000,percentage = 18};

get_lv_upgrade(52) ->
    #base_partner_upgrade{lv = 52,max_exp = 5040000,percentage = 18};

get_lv_upgrade(53) ->
    #base_partner_upgrade{lv = 53,max_exp = 5400000,percentage = 18};

get_lv_upgrade(54) ->
    #base_partner_upgrade{lv = 54,max_exp = 5760000,percentage = 18};

get_lv_upgrade(55) ->
    #base_partner_upgrade{lv = 55,max_exp = 6120000,percentage = 18};

get_lv_upgrade(56) ->
    #base_partner_upgrade{lv = 56,max_exp = 6480000,percentage = 18};

get_lv_upgrade(57) ->
    #base_partner_upgrade{lv = 57,max_exp = 6840000,percentage = 18};

get_lv_upgrade(58) ->
    #base_partner_upgrade{lv = 58,max_exp = 7200000,percentage = 18};

get_lv_upgrade(59) ->
    #base_partner_upgrade{lv = 59,max_exp = 7560000,percentage = 18};

get_lv_upgrade(60) ->
    #base_partner_upgrade{lv = 60,max_exp = 8640000,percentage = 18};

get_lv_upgrade(61) ->
    #base_partner_upgrade{lv = 61,max_exp = 8670000,percentage = 17};

get_lv_upgrade(62) ->
    #base_partner_upgrade{lv = 62,max_exp = 9180000,percentage = 17};

get_lv_upgrade(63) ->
    #base_partner_upgrade{lv = 63,max_exp = 9690000,percentage = 17};

get_lv_upgrade(64) ->
    #base_partner_upgrade{lv = 64,max_exp = 10200000,percentage = 17};

get_lv_upgrade(65) ->
    #base_partner_upgrade{lv = 65,max_exp = 10710000,percentage = 17};

get_lv_upgrade(66) ->
    #base_partner_upgrade{lv = 66,max_exp = 11220000,percentage = 17};

get_lv_upgrade(67) ->
    #base_partner_upgrade{lv = 67,max_exp = 11730000,percentage = 17};

get_lv_upgrade(68) ->
    #base_partner_upgrade{lv = 68,max_exp = 12240000,percentage = 17};

get_lv_upgrade(69) ->
    #base_partner_upgrade{lv = 69,max_exp = 12750000,percentage = 17};

get_lv_upgrade(70) ->
    #base_partner_upgrade{lv = 70,max_exp = 13000000,percentage = 17};

get_lv_upgrade(71) ->
    #base_partner_upgrade{lv = 71,max_exp = 13360000,percentage = 16};

get_lv_upgrade(72) ->
    #base_partner_upgrade{lv = 72,max_exp = 13920000,percentage = 16};

get_lv_upgrade(73) ->
    #base_partner_upgrade{lv = 73,max_exp = 14480000,percentage = 16};

get_lv_upgrade(74) ->
    #base_partner_upgrade{lv = 74,max_exp = 15040000,percentage = 16};

get_lv_upgrade(75) ->
    #base_partner_upgrade{lv = 75,max_exp = 15600000,percentage = 16};

get_lv_upgrade(76) ->
    #base_partner_upgrade{lv = 76,max_exp = 16160000,percentage = 16};

get_lv_upgrade(77) ->
    #base_partner_upgrade{lv = 77,max_exp = 16720000,percentage = 16};

get_lv_upgrade(78) ->
    #base_partner_upgrade{lv = 78,max_exp = 17280000,percentage = 16};

get_lv_upgrade(79) ->
    #base_partner_upgrade{lv = 79,max_exp = 17840000,percentage = 16};

get_lv_upgrade(80) ->
    #base_partner_upgrade{lv = 80,max_exp = 19000000,percentage = 16};

get_lv_upgrade(81) ->
    #base_partner_upgrade{lv = 81,max_exp = 21000000,percentage = 15};

get_lv_upgrade(82) ->
    #base_partner_upgrade{lv = 82,max_exp = 21750000,percentage = 15};

get_lv_upgrade(83) ->
    #base_partner_upgrade{lv = 83,max_exp = 22500000,percentage = 15};

get_lv_upgrade(84) ->
    #base_partner_upgrade{lv = 84,max_exp = 23250000,percentage = 15};

get_lv_upgrade(85) ->
    #base_partner_upgrade{lv = 85,max_exp = 24000000,percentage = 15};

get_lv_upgrade(86) ->
    #base_partner_upgrade{lv = 86,max_exp = 24750000,percentage = 15};

get_lv_upgrade(87) ->
    #base_partner_upgrade{lv = 87,max_exp = 25500000,percentage = 15};

get_lv_upgrade(88) ->
    #base_partner_upgrade{lv = 88,max_exp = 26250000,percentage = 15};

get_lv_upgrade(89) ->
    #base_partner_upgrade{lv = 89,max_exp = 27000000,percentage = 15};

get_lv_upgrade(90) ->
    #base_partner_upgrade{lv = 90,max_exp = 29000000,percentage = 15};

get_lv_upgrade(91) ->
    #base_partner_upgrade{lv = 91,max_exp = 30520000,percentage = 14};

get_lv_upgrade(92) ->
    #base_partner_upgrade{lv = 92,max_exp = 31640000,percentage = 14};

get_lv_upgrade(93) ->
    #base_partner_upgrade{lv = 93,max_exp = 32760000,percentage = 14};

get_lv_upgrade(94) ->
    #base_partner_upgrade{lv = 94,max_exp = 33880000,percentage = 14};

get_lv_upgrade(95) ->
    #base_partner_upgrade{lv = 95,max_exp = 35000000,percentage = 14};

get_lv_upgrade(96) ->
    #base_partner_upgrade{lv = 96,max_exp = 36120000,percentage = 14};

get_lv_upgrade(97) ->
    #base_partner_upgrade{lv = 97,max_exp = 37240000,percentage = 14};

get_lv_upgrade(98) ->
    #base_partner_upgrade{lv = 98,max_exp = 38360000,percentage = 14};

get_lv_upgrade(99) ->
    #base_partner_upgrade{lv = 99,max_exp = 39480000,percentage = 14};

get_lv_upgrade(100) ->
    #base_partner_upgrade{lv = 100,max_exp = 40500000,percentage = 14};

get_lv_upgrade(101) ->
    #base_partner_upgrade{lv = 101,max_exp = 41990000,percentage = 13};

get_lv_upgrade(102) ->
    #base_partner_upgrade{lv = 102,max_exp = 43030000,percentage = 13};

get_lv_upgrade(103) ->
    #base_partner_upgrade{lv = 103,max_exp = 44070000,percentage = 13};

get_lv_upgrade(104) ->
    #base_partner_upgrade{lv = 104,max_exp = 45110000,percentage = 13};

get_lv_upgrade(105) ->
    #base_partner_upgrade{lv = 105,max_exp = 46150000,percentage = 13};

get_lv_upgrade(106) ->
    #base_partner_upgrade{lv = 106,max_exp = 47190000,percentage = 13};

get_lv_upgrade(107) ->
    #base_partner_upgrade{lv = 107,max_exp = 48230000,percentage = 13};

get_lv_upgrade(108) ->
    #base_partner_upgrade{lv = 108,max_exp = 49270000,percentage = 13};

get_lv_upgrade(109) ->
    #base_partner_upgrade{lv = 109,max_exp = 50310000,percentage = 13};

get_lv_upgrade(110) ->
    #base_partner_upgrade{lv = 110,max_exp = 50800000,percentage = 13};

get_lv_upgrade(111) ->
    #base_partner_upgrade{lv = 111,max_exp = 51600000,percentage = 12};

get_lv_upgrade(112) ->
    #base_partner_upgrade{lv = 112,max_exp = 52800000,percentage = 12};

get_lv_upgrade(113) ->
    #base_partner_upgrade{lv = 113,max_exp = 54000000,percentage = 12};

get_lv_upgrade(114) ->
    #base_partner_upgrade{lv = 114,max_exp = 55200000,percentage = 12};

get_lv_upgrade(115) ->
    #base_partner_upgrade{lv = 115,max_exp = 56400000,percentage = 12};

get_lv_upgrade(116) ->
    #base_partner_upgrade{lv = 116,max_exp = 57600000,percentage = 12};

get_lv_upgrade(117) ->
    #base_partner_upgrade{lv = 117,max_exp = 58800000,percentage = 12};

get_lv_upgrade(118) ->
    #base_partner_upgrade{lv = 118,max_exp = 60000000,percentage = 12};

get_lv_upgrade(119) ->
    #base_partner_upgrade{lv = 119,max_exp = 61200000,percentage = 12};

get_lv_upgrade(120) ->
    #base_partner_upgrade{lv = 120,max_exp = 62000000,percentage = 12};

get_lv_upgrade(121) ->
    #base_partner_upgrade{lv = 121,max_exp = 62920000,percentage = 11};

get_lv_upgrade(122) ->
    #base_partner_upgrade{lv = 122,max_exp = 64240000,percentage = 11};

get_lv_upgrade(123) ->
    #base_partner_upgrade{lv = 123,max_exp = 65560000,percentage = 11};

get_lv_upgrade(124) ->
    #base_partner_upgrade{lv = 124,max_exp = 66880000,percentage = 11};

get_lv_upgrade(125) ->
    #base_partner_upgrade{lv = 125,max_exp = 68200000,percentage = 11};

get_lv_upgrade(126) ->
    #base_partner_upgrade{lv = 126,max_exp = 69520000,percentage = 11};

get_lv_upgrade(127) ->
    #base_partner_upgrade{lv = 127,max_exp = 70840000,percentage = 11};

get_lv_upgrade(128) ->
    #base_partner_upgrade{lv = 128,max_exp = 72160000,percentage = 11};

get_lv_upgrade(129) ->
    #base_partner_upgrade{lv = 129,max_exp = 72600000,percentage = 11};

get_lv_upgrade(130) ->
    #base_partner_upgrade{lv = 130,max_exp = 73000000,percentage = 11};

get_lv_upgrade(131) ->
    #base_partner_upgrade{lv = 131,max_exp = 73400000,percentage = 10};

get_lv_upgrade(132) ->
    #base_partner_upgrade{lv = 132,max_exp = 74000000,percentage = 10};

get_lv_upgrade(133) ->
    #base_partner_upgrade{lv = 133,max_exp = 75500000,percentage = 10};

get_lv_upgrade(134) ->
    #base_partner_upgrade{lv = 134,max_exp = 77000000,percentage = 10};

get_lv_upgrade(135) ->
    #base_partner_upgrade{lv = 135,max_exp = 78500000,percentage = 10};

get_lv_upgrade(136) ->
    #base_partner_upgrade{lv = 136,max_exp = 80000000,percentage = 10};

get_lv_upgrade(137) ->
    #base_partner_upgrade{lv = 137,max_exp = 81500000,percentage = 10};

get_lv_upgrade(138) ->
    #base_partner_upgrade{lv = 138,max_exp = 83000000,percentage = 10};

get_lv_upgrade(139) ->
    #base_partner_upgrade{lv = 139,max_exp = 84500000,percentage = 10};

get_lv_upgrade(140) ->
    #base_partner_upgrade{lv = 140,max_exp = 90000000,percentage = 10};

get_lv_upgrade(141) ->
    #base_partner_upgrade{lv = 141,max_exp = 92250000,percentage = 9};

get_lv_upgrade(142) ->
    #base_partner_upgrade{lv = 142,max_exp = 94500000,percentage = 9};

get_lv_upgrade(143) ->
    #base_partner_upgrade{lv = 143,max_exp = 96750000,percentage = 9};

get_lv_upgrade(144) ->
    #base_partner_upgrade{lv = 144,max_exp = 99000000,percentage = 9};

get_lv_upgrade(145) ->
    #base_partner_upgrade{lv = 145,max_exp = 101250000,percentage = 9};

get_lv_upgrade(146) ->
    #base_partner_upgrade{lv = 146,max_exp = 103500000,percentage = 9};

get_lv_upgrade(147) ->
    #base_partner_upgrade{lv = 147,max_exp = 105750000,percentage = 9};

get_lv_upgrade(148) ->
    #base_partner_upgrade{lv = 148,max_exp = 108000000,percentage = 9};

get_lv_upgrade(149) ->
    #base_partner_upgrade{lv = 149,max_exp = 110250000,percentage = 9};

get_lv_upgrade(_Lv) ->
    [].

get_lv_list() ->
[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,144,145,146,147,148,149].

get_break(1,10) ->
    #base_partner_break{quality = 1,lv = 10,attr_val = 160,loss_coef = [{1,0.5},{2,0.375},{3,0.25},{4,0.125},{5,0}]};

get_break(1,20) ->
    #base_partner_break{quality = 1,lv = 20,attr_val = 160,loss_coef = [{1,0.5},{2,0.375},{3,0.25},{4,0.125},{5,0}]};

get_break(1,30) ->
    #base_partner_break{quality = 1,lv = 30,attr_val = 160,loss_coef = [{1,0.5},{2,0.375},{3,0.25},{4,0.125},{5,0}]};

get_break(1,40) ->
    #base_partner_break{quality = 1,lv = 40,attr_val = 160,loss_coef = [{1,0.5},{2,0.375},{3,0.25},{4,0.125},{5,0}]};

get_break(1,50) ->
    #base_partner_break{quality = 1,lv = 50,attr_val = 160,loss_coef = [{1,0.5},{2,0.375},{3,0.25},{4,0.125},{5,0}]};

get_break(1,60) ->
    #base_partner_break{quality = 1,lv = 60,attr_val = 160,loss_coef = [{1,0.5},{2,0.375},{3,0.25},{4,0.125},{5,0}]};

get_break(2,10) ->
    #base_partner_break{quality = 2,lv = 10,attr_val = 240,loss_coef = [{1,0.167},{2,0.125},{3,0.083},{4,0.042},{5,0}]};

get_break(2,20) ->
    #base_partner_break{quality = 2,lv = 20,attr_val = 240,loss_coef = [{1,0.167},{2,0.125},{3,0.083},{4,0.042},{5,0}]};

get_break(2,30) ->
    #base_partner_break{quality = 2,lv = 30,attr_val = 240,loss_coef = [{1,0.167},{2,0.125},{3,0.083},{4,0.042},{5,0}]};

get_break(2,40) ->
    #base_partner_break{quality = 2,lv = 40,attr_val = 240,loss_coef = [{1,0.167},{2,0.125},{3,0.083},{4,0.042},{5,0}]};

get_break(2,50) ->
    #base_partner_break{quality = 2,lv = 50,attr_val = 240,loss_coef = [{1,0.167},{2,0.125},{3,0.083},{4,0.042},{5,0}]};

get_break(2,60) ->
    #base_partner_break{quality = 2,lv = 60,attr_val = 240,loss_coef = [{1,0.167},{2,0.125},{3,0.083},{4,0.042},{5,0}]};

get_break(3,10) ->
    #base_partner_break{quality = 3,lv = 10,attr_val = 400,loss_coef = [{1,0.2},{2,0.15},{3,0.1},{4,0.05},{5,0}]};

get_break(3,20) ->
    #base_partner_break{quality = 3,lv = 20,attr_val = 400,loss_coef = [{1,0.2},{2,0.15},{3,0.1},{4,0.05},{5,0}]};

get_break(3,30) ->
    #base_partner_break{quality = 3,lv = 30,attr_val = 400,loss_coef = [{1,0.2},{2,0.15},{3,0.1},{4,0.05},{5,0}]};

get_break(3,40) ->
    #base_partner_break{quality = 3,lv = 40,attr_val = 400,loss_coef = [{1,0.2},{2,0.15},{3,0.1},{4,0.05},{5,0}]};

get_break(3,50) ->
    #base_partner_break{quality = 3,lv = 50,attr_val = 400,loss_coef = [{1,0.2},{2,0.15},{3,0.1},{4,0.05},{5,0}]};

get_break(3,60) ->
    #base_partner_break{quality = 3,lv = 60,attr_val = 400,loss_coef = [{1,0.2},{2,0.15},{3,0.1},{4,0.05},{5,0}]};

get_break(4,10) ->
    #base_partner_break{quality = 4,lv = 10,attr_val = 600,loss_coef = [{1,0.267},{2,0.2},{3,0.133},{4,0.067},{5,0}]};

get_break(4,20) ->
    #base_partner_break{quality = 4,lv = 20,attr_val = 600,loss_coef = [{1,0.267},{2,0.2},{3,0.133},{4,0.067},{5,0}]};

get_break(4,30) ->
    #base_partner_break{quality = 4,lv = 30,attr_val = 600,loss_coef = [{1,0.267},{2,0.2},{3,0.133},{4,0.067},{5,0}]};

get_break(4,40) ->
    #base_partner_break{quality = 4,lv = 40,attr_val = 600,loss_coef = [{1,0.267},{2,0.2},{3,0.133},{4,0.067},{5,0}]};

get_break(4,50) ->
    #base_partner_break{quality = 4,lv = 50,attr_val = 600,loss_coef = [{1,0.267},{2,0.2},{3,0.133},{4,0.067},{5,0}]};

get_break(4,60) ->
    #base_partner_break{quality = 4,lv = 60,attr_val = 600,loss_coef = [{1,0.267},{2,0.2},{3,0.133},{4,0.067},{5,0}]};

get_break(5,10) ->
    #base_partner_break{quality = 5,lv = 10,attr_val = 800,loss_coef = [{1,0.1},{2,0.075},{3,0.05},{4,0.025},{5,0}]};

get_break(5,20) ->
    #base_partner_break{quality = 5,lv = 20,attr_val = 800,loss_coef = [{1,0.1},{2,0.075},{3,0.05},{4,0.025},{5,0}]};

get_break(5,30) ->
    #base_partner_break{quality = 5,lv = 30,attr_val = 800,loss_coef = [{1,0.1},{2,0.075},{3,0.05},{4,0.025},{5,0}]};

get_break(5,40) ->
    #base_partner_break{quality = 5,lv = 40,attr_val = 800,loss_coef = [{1,0.1},{2,0.075},{3,0.05},{4,0.025},{5,0}]};

get_break(5,50) ->
    #base_partner_break{quality = 5,lv = 50,attr_val = 800,loss_coef = [{1,0.1},{2,0.075},{3,0.05},{4,0.025},{5,0}]};

get_break(5,60) ->
    #base_partner_break{quality = 5,lv = 60,attr_val = 800,loss_coef = [{1,0.1},{2,0.075},{3,0.05},{4,0.025},{5,0}]};

get_break(_Quality,_Lv) ->
    [].

get_break_lv(1) ->
[10,20,30,40,50,60];

get_break_lv(2) ->
[10,20,30,40,50,60];

get_break_lv(3) ->
[10,20,30,40,50,60];

get_break_lv(4) ->
[10,20,30,40,50,60];

get_break_lv(5) ->
[10,20,30,40,50,60];

get_break_lv(_Quality) ->
    [].

get_promote(1,0) ->
    #base_partner_promote{quality = 1,prodigy = 0,goods = [{0,212001,1}],promote = [{350,450,100}]};

get_promote(1,1) ->
    #base_partner_promote{quality = 1,prodigy = 1,goods = [{0,212001,1}],promote = [{350,450,100}]};

get_promote(2,0) ->
    #base_partner_promote{quality = 2,prodigy = 0,goods = [{0,212001,1}],promote = [{180,220,100}]};

get_promote(2,1) ->
    #base_partner_promote{quality = 2,prodigy = 1,goods = [{0,212001,1}],promote = [{180,220,100}]};

get_promote(3,0) ->
    #base_partner_promote{quality = 3,prodigy = 0,goods = [{0,212001,1}],promote = [{70,90,100}]};

get_promote(3,1) ->
    #base_partner_promote{quality = 3,prodigy = 1,goods = [{0,212001,1}],promote = [{70,90,100}]};

get_promote(4,0) ->
    #base_partner_promote{quality = 4,prodigy = 0,goods = [{0,212001,1}],promote = [{40,60,100}]};

get_promote(4,1) ->
    #base_partner_promote{quality = 4,prodigy = 1,goods = [{0,212001,1}],promote = [{40,60,100}]};

get_promote(5,0) ->
    #base_partner_promote{quality = 5,prodigy = 0,goods = [{0,212001,1}],promote = [{15,25,100}]};

get_promote(5,1) ->
    #base_partner_promote{quality = 5,prodigy = 1,goods = [{0,212001,1}],promote = [{15,25,100}]};

get_promote(_Quality,_Prodigy) ->
    [].

get_weapon_by_id(213101) ->
    #base_partner_weapon{goods_id = 213101,partner_id = 503,weapon_l = 0,weapon_r = 2020520300,attr = [{2,100}],combat_power = 1000};

get_weapon_by_id(213102) ->
    #base_partner_weapon{goods_id = 213102,partner_id = 402,weapon_l = 0,weapon_r = 2020200300,attr = [{2,100}],combat_power = 1000};

get_weapon_by_id(213103) ->
    #base_partner_weapon{goods_id = 213103,partner_id = 401,weapon_l = 0,weapon_r = 2020300200,attr = [{2,100}],combat_power = 1000};

get_weapon_by_id(213104) ->
    #base_partner_weapon{goods_id = 213104,partner_id = 413,weapon_l = 0,weapon_r = 2020401600,attr = [{2,100}],combat_power = 1000};

get_weapon_by_id(_Goodsid) ->
    [].

get_weapon_by_partnerid(503) ->
[{[{2,100}],1000}];

get_weapon_by_partnerid(402) ->
[{[{2,100}],1000}];

get_weapon_by_partnerid(401) ->
[{[{2,100}],1000}];

get_weapon_by_partnerid(413) ->
[{[{2,100}],1000}];

get_weapon_by_partnerid(_Partnerid) ->
    [].

get_disband_by_quality(1,1) ->
    #base_partner_disband{type = 1,quality = 1,award = [{0,212101,0.2},{0,212001,0.1}]};

get_disband_by_quality(1,2) ->
    #base_partner_disband{type = 1,quality = 2,award = [{0,212101,1},{0,212001,0.2}]};

get_disband_by_quality(1,3) ->
    #base_partner_disband{type = 1,quality = 3,award = [{0,212101,2.8},{0,212001,1.2}]};

get_disband_by_quality(1,4) ->
    #base_partner_disband{type = 1,quality = 4,award = [{0,212101,10.4},{0,212001,5.6}]};

get_disband_by_quality(1,5) ->
    #base_partner_disband{type = 1,quality = 5,award = [{0,212101,30},{0,212001,20}]};

get_disband_by_quality(2,1) ->
    #base_partner_disband{type = 2,quality = 1,award = [{0,212001,0.2}]};

get_disband_by_quality(2,2) ->
    #base_partner_disband{type = 2,quality = 2,award = [{0,212001,0.6}]};

get_disband_by_quality(2,3) ->
    #base_partner_disband{type = 2,quality = 3,award = [{0,212001,1.8}]};

get_disband_by_quality(2,4) ->
    #base_partner_disband{type = 2,quality = 4,award = [{0,212001,5.4}]};

get_disband_by_quality(2,5) ->
    #base_partner_disband{type = 2,quality = 5,award = [{0,212001,16}]};

get_disband_by_quality(_Type,_Quality) ->
    [].

get_callback(1) ->
    #base_partner_callback{quality = 1,goods = [{0,212101,2}]};

get_callback(2) ->
    #base_partner_callback{quality = 2,goods = [{0,212101,5}]};

get_callback(3) ->
    #base_partner_callback{quality = 3,goods = [{0,212101,10}]};

get_callback(4) ->
    #base_partner_callback{quality = 4,goods = [{0,212101,30}]};

get_callback(5) ->
    #base_partner_callback{quality = 5,goods = [{0,212101,125}]};

get_callback(_Quality) ->
    [].

get_lv_limit_by_slot(1) ->
9;

get_lv_limit_by_slot(2) ->
9;

get_lv_limit_by_slot(3) ->
20;

get_lv_limit_by_slot(4) ->
30;

get_lv_limit_by_slot(_Slot) ->
    0.

get_exp_book(212201) ->
    #base_exp_book{id = 212201,exp = 10000};

get_exp_book(212202) ->
    #base_exp_book{id = 212202,exp = 100000};

get_exp_book(212203) ->
    #base_exp_book{id = 212203,exp = 1000000};

get_exp_book(_Id) ->
    [].

get_skill_by_id(213001) ->
    #base_partner_sk{id = 213001,skill_id = 2300001,color = 2,power = 120,weight = 50,career = 6,sk_desc = "【被动】提升伙伴光抗"};

get_skill_by_id(213002) ->
    #base_partner_sk{id = 213002,skill_id = 2300002,color = 3,power = 400,weight = 50,career = 6,sk_desc = "【被动】提升伙伴光抗"};

get_skill_by_id(213003) ->
    #base_partner_sk{id = 213003,skill_id = 2300003,color = 4,power = 1250,weight = 50,career = 6,sk_desc = "【被动】提升伙伴光抗"};

get_skill_by_id(213004) ->
    #base_partner_sk{id = 213004,skill_id = 2300004,color = 2,power = 120,weight = 50,career = 6,sk_desc = "【被动】提升伙伴暗抗"};

get_skill_by_id(213005) ->
    #base_partner_sk{id = 213005,skill_id = 2300005,color = 3,power = 400,weight = 50,career = 6,sk_desc = "【被动】提升伙伴暗抗"};

get_skill_by_id(213006) ->
    #base_partner_sk{id = 213006,skill_id = 2300006,color = 4,power = 1250,weight = 50,career = 6,sk_desc = "【被动】提升伙伴暗抗"};

get_skill_by_id(213007) ->
    #base_partner_sk{id = 213007,skill_id = 2300007,color = 2,power = 120,weight = 50,career = 6,sk_desc = "【被动】提升伙伴水抗"};

get_skill_by_id(213008) ->
    #base_partner_sk{id = 213008,skill_id = 2300008,color = 3,power = 400,weight = 50,career = 6,sk_desc = "【被动】提升伙伴水抗"};

get_skill_by_id(213009) ->
    #base_partner_sk{id = 213009,skill_id = 2300009,color = 4,power = 1250,weight = 50,career = 6,sk_desc = "【被动】提升伙伴水抗"};

get_skill_by_id(213010) ->
    #base_partner_sk{id = 213010,skill_id = 2300010,color = 2,power = 120,weight = 50,career = 6,sk_desc = "【被动】提升伙伴火抗"};

get_skill_by_id(213011) ->
    #base_partner_sk{id = 213011,skill_id = 2300011,color = 3,power = 400,weight = 50,career = 6,sk_desc = "【被动】提升伙伴火抗"};

get_skill_by_id(213012) ->
    #base_partner_sk{id = 213012,skill_id = 2300012,color = 4,power = 1250,weight = 50,career = 6,sk_desc = "【被动】提升伙伴火抗"};

get_skill_by_id(213013) ->
    #base_partner_sk{id = 213013,skill_id = 2300013,color = 2,power = 120,weight = 50,career = 6,sk_desc = "【被动】提升伙伴风抗"};

get_skill_by_id(213014) ->
    #base_partner_sk{id = 213014,skill_id = 2300014,color = 3,power = 400,weight = 50,career = 6,sk_desc = "【被动】提升伙伴风抗"};

get_skill_by_id(213015) ->
    #base_partner_sk{id = 213015,skill_id = 2300015,color = 4,power = 1250,weight = 50,career = 6,sk_desc = "【被动】提升伙伴风抗"};

get_skill_by_id(213016) ->
    #base_partner_sk{id = 213016,skill_id = 2300016,color = 3,power = 400,weight = 50,career = 6,sk_desc = "【被动】提升伙伴全抗"};

get_skill_by_id(213017) ->
    #base_partner_sk{id = 213017,skill_id = 2300017,color = 4,power = 1250,weight = 50,career = 6,sk_desc = "【被动】提升伙伴全抗"};

get_skill_by_id(213018) ->
    #base_partner_sk{id = 213018,skill_id = 2300018,color = 5,power = 3750,weight = 50,career = 6,sk_desc = "【被动】提升伙伴全抗"};

get_skill_by_id(213019) ->
    #base_partner_sk{id = 213019,skill_id = 2300019,color = 2,power = 120,weight = 50,career = 6,sk_desc = "【被动】提升伙伴攻击"};

get_skill_by_id(213020) ->
    #base_partner_sk{id = 213020,skill_id = 2300020,color = 3,power = 400,weight = 50,career = 6,sk_desc = "【被动】提升伙伴攻击"};

get_skill_by_id(213021) ->
    #base_partner_sk{id = 213021,skill_id = 2300021,color = 4,power = 1250,weight = 50,career = 6,sk_desc = "【被动】提升伙伴攻击"};

get_skill_by_id(213022) ->
    #base_partner_sk{id = 213022,skill_id = 2300022,color = 3,power = 400,weight = 50,career = 6,sk_desc = "【被动】提升伙伴攻击速度"};

get_skill_by_id(213023) ->
    #base_partner_sk{id = 213023,skill_id = 2300023,color = 4,power = 1250,weight = 50,career = 6,sk_desc = "【被动】提升伙伴攻击速度"};

get_skill_by_id(213024) ->
    #base_partner_sk{id = 213024,skill_id = 2300024,color = 5,power = 3750,weight = 50,career = 6,sk_desc = "【被动】提升伙伴攻击速度"};

get_skill_by_id(213025) ->
    #base_partner_sk{id = 213025,skill_id = 2300025,color = 2,power = 120,weight = 50,career = 6,sk_desc = "【被动】提升伙伴抗属性效果"};

get_skill_by_id(213026) ->
    #base_partner_sk{id = 213026,skill_id = 2300026,color = 3,power = 400,weight = 50,career = 6,sk_desc = "【被动】提升伙伴抗属性效果"};

get_skill_by_id(213027) ->
    #base_partner_sk{id = 213027,skill_id = 2300027,color = 4,power = 1250,weight = 50,career = 6,sk_desc = "【被动】提升伙伴抗属性效果"};

get_skill_by_id(213028) ->
    #base_partner_sk{id = 213028,skill_id = 2300028,color = 3,power = 400,weight = 50,career = 6,sk_desc = "【被动】提升伙伴忽略全抗"};

get_skill_by_id(213029) ->
    #base_partner_sk{id = 213029,skill_id = 2300029,color = 4,power = 1250,weight = 50,career = 6,sk_desc = "【被动】提升伙伴忽略全抗"};

get_skill_by_id(213030) ->
    #base_partner_sk{id = 213030,skill_id = 2300030,color = 5,power = 3750,weight = 50,career = 6,sk_desc = "【被动】提升伙伴忽略全抗"};

get_skill_by_id(213031) ->
    #base_partner_sk{id = 213031,skill_id = 2300031,color = 3,power = 400,weight = 50,career = 6,sk_desc = "【被动】提升伙伴吸取生命"};

get_skill_by_id(213032) ->
    #base_partner_sk{id = 213032,skill_id = 2300032,color = 4,power = 1250,weight = 50,career = 6,sk_desc = "【被动】提升伙伴吸取生命"};

get_skill_by_id(213033) ->
    #base_partner_sk{id = 213033,skill_id = 2300033,color = 5,power = 3750,weight = 50,career = 6,sk_desc = "【被动】提升伙伴吸取生命"};

get_skill_by_id(213034) ->
    #base_partner_sk{id = 213034,skill_id = 2300034,color = 1,power = 40,weight = 50,career = 6,sk_desc = "【被动】提升伙伴闪避"};

get_skill_by_id(213035) ->
    #base_partner_sk{id = 213035,skill_id = 2300035,color = 2,power = 120,weight = 50,career = 6,sk_desc = "【被动】提升伙伴闪避"};

get_skill_by_id(213036) ->
    #base_partner_sk{id = 213036,skill_id = 2300036,color = 3,power = 400,weight = 50,career = 6,sk_desc = "【被动】提升伙伴闪避"};

get_skill_by_id(213037) ->
    #base_partner_sk{id = 213037,skill_id = 2300037,color = 1,power = 40,weight = 50,career = 6,sk_desc = "【被动】提升伙伴忽略闪避"};

get_skill_by_id(213038) ->
    #base_partner_sk{id = 213038,skill_id = 2300038,color = 2,power = 120,weight = 50,career = 6,sk_desc = "【被动】提升伙伴忽略闪避"};

get_skill_by_id(213039) ->
    #base_partner_sk{id = 213039,skill_id = 2300039,color = 3,power = 400,weight = 50,career = 6,sk_desc = "【被动】提升伙伴忽略闪避"};

get_skill_by_id(213040) ->
    #base_partner_sk{id = 213040,skill_id = 2300040,color = 1,power = 40,weight = 50,career = 6,sk_desc = "【被动】提升伙伴生命回复效果"};

get_skill_by_id(213041) ->
    #base_partner_sk{id = 213041,skill_id = 2300041,color = 2,power = 120,weight = 50,career = 6,sk_desc = "【被动】提升伙伴生命回复效果"};

get_skill_by_id(213042) ->
    #base_partner_sk{id = 213042,skill_id = 2300042,color = 3,power = 400,weight = 50,career = 6,sk_desc = "【被动】提升伙伴生命回复效果"};

get_skill_by_id(213043) ->
    #base_partner_sk{id = 213043,skill_id = 2300043,color = 2,power = 120,weight = 50,career = 6,sk_desc = "【被动】提升伙伴生命"};

get_skill_by_id(213044) ->
    #base_partner_sk{id = 213044,skill_id = 2300044,color = 3,power = 400,weight = 50,career = 6,sk_desc = "【被动】提升伙伴生命"};

get_skill_by_id(213045) ->
    #base_partner_sk{id = 213045,skill_id = 2300045,color = 4,power = 1250,weight = 50,career = 6,sk_desc = "【被动】提升伙伴生命"};

get_skill_by_id(213046) ->
    #base_partner_sk{id = 213046,skill_id = 2300046,color = 1,power = 40,weight = 50,career = 6,sk_desc = "【被动】提升伙伴命中"};

get_skill_by_id(213047) ->
    #base_partner_sk{id = 213047,skill_id = 2300047,color = 2,power = 120,weight = 50,career = 6,sk_desc = "【被动】提升伙伴命中"};

get_skill_by_id(213048) ->
    #base_partner_sk{id = 213048,skill_id = 2300048,color = 3,power = 400,weight = 50,career = 6,sk_desc = "【被动】提升伙伴命中"};

get_skill_by_id(213049) ->
    #base_partner_sk{id = 213049,skill_id = 2300049,color = 2,power = 120,weight = 50,career = 6,sk_desc = "【被动】提升伙伴会心几率"};

get_skill_by_id(213050) ->
    #base_partner_sk{id = 213050,skill_id = 2300050,color = 3,power = 400,weight = 50,career = 6,sk_desc = "【被动】提升伙伴会心几率"};

get_skill_by_id(213051) ->
    #base_partner_sk{id = 213051,skill_id = 2300051,color = 4,power = 1250,weight = 50,career = 6,sk_desc = "【被动】提升伙伴会心几率"};

get_skill_by_id(213052) ->
    #base_partner_sk{id = 213052,skill_id = 2300052,color = 1,power = 40,weight = 50,career = 6,sk_desc = "【被动】提升伙伴抗会心几率"};

get_skill_by_id(213053) ->
    #base_partner_sk{id = 213053,skill_id = 2300053,color = 2,power = 120,weight = 50,career = 6,sk_desc = "【被动】提升伙伴抗会心几率"};

get_skill_by_id(213054) ->
    #base_partner_sk{id = 213054,skill_id = 2300054,color = 3,power = 400,weight = 50,career = 6,sk_desc = "【被动】提升伙伴抗会心几率"};

get_skill_by_id(_Id) ->
    [].

get_skill_by_skid(2300001) ->
[{213001,2,120,6}];

get_skill_by_skid(2300002) ->
[{213002,3,400,6}];

get_skill_by_skid(2300003) ->
[{213003,4,1250,6}];

get_skill_by_skid(2300004) ->
[{213004,2,120,6}];

get_skill_by_skid(2300005) ->
[{213005,3,400,6}];

get_skill_by_skid(2300006) ->
[{213006,4,1250,6}];

get_skill_by_skid(2300007) ->
[{213007,2,120,6}];

get_skill_by_skid(2300008) ->
[{213008,3,400,6}];

get_skill_by_skid(2300009) ->
[{213009,4,1250,6}];

get_skill_by_skid(2300010) ->
[{213010,2,120,6}];

get_skill_by_skid(2300011) ->
[{213011,3,400,6}];

get_skill_by_skid(2300012) ->
[{213012,4,1250,6}];

get_skill_by_skid(2300013) ->
[{213013,2,120,6}];

get_skill_by_skid(2300014) ->
[{213014,3,400,6}];

get_skill_by_skid(2300015) ->
[{213015,4,1250,6}];

get_skill_by_skid(2300016) ->
[{213016,3,400,6}];

get_skill_by_skid(2300017) ->
[{213017,4,1250,6}];

get_skill_by_skid(2300018) ->
[{213018,5,3750,6}];

get_skill_by_skid(2300019) ->
[{213019,2,120,6}];

get_skill_by_skid(2300020) ->
[{213020,3,400,6}];

get_skill_by_skid(2300021) ->
[{213021,4,1250,6}];

get_skill_by_skid(2300022) ->
[{213022,3,400,6}];

get_skill_by_skid(2300023) ->
[{213023,4,1250,6}];

get_skill_by_skid(2300024) ->
[{213024,5,3750,6}];

get_skill_by_skid(2300025) ->
[{213025,2,120,6}];

get_skill_by_skid(2300026) ->
[{213026,3,400,6}];

get_skill_by_skid(2300027) ->
[{213027,4,1250,6}];

get_skill_by_skid(2300028) ->
[{213028,3,400,6}];

get_skill_by_skid(2300029) ->
[{213029,4,1250,6}];

get_skill_by_skid(2300030) ->
[{213030,5,3750,6}];

get_skill_by_skid(2300031) ->
[{213031,3,400,6}];

get_skill_by_skid(2300032) ->
[{213032,4,1250,6}];

get_skill_by_skid(2300033) ->
[{213033,5,3750,6}];

get_skill_by_skid(2300034) ->
[{213034,1,40,6}];

get_skill_by_skid(2300035) ->
[{213035,2,120,6}];

get_skill_by_skid(2300036) ->
[{213036,3,400,6}];

get_skill_by_skid(2300037) ->
[{213037,1,40,6}];

get_skill_by_skid(2300038) ->
[{213038,2,120,6}];

get_skill_by_skid(2300039) ->
[{213039,3,400,6}];

get_skill_by_skid(2300040) ->
[{213040,1,40,6}];

get_skill_by_skid(2300041) ->
[{213041,2,120,6}];

get_skill_by_skid(2300042) ->
[{213042,3,400,6}];

get_skill_by_skid(2300043) ->
[{213043,2,120,6}];

get_skill_by_skid(2300044) ->
[{213044,3,400,6}];

get_skill_by_skid(2300045) ->
[{213045,4,1250,6}];

get_skill_by_skid(2300046) ->
[{213046,1,40,6}];

get_skill_by_skid(2300047) ->
[{213047,2,120,6}];

get_skill_by_skid(2300048) ->
[{213048,3,400,6}];

get_skill_by_skid(2300049) ->
[{213049,2,120,6}];

get_skill_by_skid(2300050) ->
[{213050,3,400,6}];

get_skill_by_skid(2300051) ->
[{213051,4,1250,6}];

get_skill_by_skid(2300052) ->
[{213052,1,40,6}];

get_skill_by_skid(2300053) ->
[{213053,2,120,6}];

get_skill_by_skid(2300054) ->
[{213054,3,400,6}];

get_skill_by_skid(_Skillid) ->
    [].

get_skill_by_quality(2,6) ->
[{2300001,120,50},{2300004,120,50},{2300007,120,50},{2300010,120,50},{2300013,120,50},{2300019,120,50},{2300025,120,50},{2300035,120,50},{2300038,120,50},{2300041,120,50},{2300043,120,50},{2300047,120,50},{2300049,120,50},{2300053,120,50}];

get_skill_by_quality(3,6) ->
[{2300002,400,50},{2300005,400,50},{2300008,400,50},{2300011,400,50},{2300014,400,50},{2300016,400,50},{2300020,400,50},{2300022,400,50},{2300026,400,50},{2300028,400,50},{2300031,400,50},{2300036,400,50},{2300039,400,50},{2300042,400,50},{2300044,400,50},{2300048,400,50},{2300050,400,50},{2300054,400,50}];

get_skill_by_quality(4,6) ->
[{2300003,1250,50},{2300006,1250,50},{2300009,1250,50},{2300012,1250,50},{2300015,1250,50},{2300017,1250,50},{2300021,1250,50},{2300023,1250,50},{2300027,1250,50},{2300029,1250,50},{2300032,1250,50},{2300045,1250,50},{2300051,1250,50}];

get_skill_by_quality(5,6) ->
[{2300018,3750,50},{2300024,3750,50},{2300030,3750,50},{2300033,3750,50}];

get_skill_by_quality(1,6) ->
[{2300034,40,50},{2300037,40,50},{2300040,40,50},{2300046,40,50},{2300052,40,50}];

get_skill_by_quality(_Color,_Career) ->
    [].

get_power_coef(1) ->
[{0.1875,130}];

get_power_coef(2) ->
[{0.375,174}];

get_power_coef(3) ->
[{0.9375,300}];

get_power_coef(4) ->
[{1.5,263}];

get_power_coef(5) ->
[{3.75,330}];

get_power_coef(_Quality) ->
    [].

get_summon_card(211207) ->
    #base_summon_card{id = 211207,partner_id = 207};

get_summon_card(211208) ->
    #base_summon_card{id = 211208,partner_id = 208};

get_summon_card(211209) ->
    #base_summon_card{id = 211209,partner_id = 209};

get_summon_card(211210) ->
    #base_summon_card{id = 211210,partner_id = 210};

get_summon_card(211211) ->
    #base_summon_card{id = 211211,partner_id = 211};

get_summon_card(211212) ->
    #base_summon_card{id = 211212,partner_id = 212};

get_summon_card(211213) ->
    #base_summon_card{id = 211213,partner_id = 213};

get_summon_card(211214) ->
    #base_summon_card{id = 211214,partner_id = 214};

get_summon_card(211215) ->
    #base_summon_card{id = 211215,partner_id = 215};

get_summon_card(211216) ->
    #base_summon_card{id = 211216,partner_id = 216};

get_summon_card(211217) ->
    #base_summon_card{id = 211217,partner_id = 217};

get_summon_card(211301) ->
    #base_summon_card{id = 211301,partner_id = 301};

get_summon_card(211302) ->
    #base_summon_card{id = 211302,partner_id = 302};

get_summon_card(211303) ->
    #base_summon_card{id = 211303,partner_id = 303};

get_summon_card(211304) ->
    #base_summon_card{id = 211304,partner_id = 304};

get_summon_card(211313) ->
    #base_summon_card{id = 211313,partner_id = 313};

get_summon_card(211315) ->
    #base_summon_card{id = 211315,partner_id = 315};

get_summon_card(211316) ->
    #base_summon_card{id = 211316,partner_id = 316};

get_summon_card(211317) ->
    #base_summon_card{id = 211317,partner_id = 317};

get_summon_card(211318) ->
    #base_summon_card{id = 211318,partner_id = 318};

get_summon_card(211319) ->
    #base_summon_card{id = 211319,partner_id = 319};

get_summon_card(211320) ->
    #base_summon_card{id = 211320,partner_id = 320};

get_summon_card(211321) ->
    #base_summon_card{id = 211321,partner_id = 321};

get_summon_card(211322) ->
    #base_summon_card{id = 211322,partner_id = 322};

get_summon_card(211323) ->
    #base_summon_card{id = 211323,partner_id = 323};

get_summon_card(211324) ->
    #base_summon_card{id = 211324,partner_id = 324};

get_summon_card(211325) ->
    #base_summon_card{id = 211325,partner_id = 325};

get_summon_card(211326) ->
    #base_summon_card{id = 211326,partner_id = 326};

get_summon_card(211399) ->
    #base_summon_card{id = 211399,partner_id = 323};

get_summon_card(211401) ->
    #base_summon_card{id = 211401,partner_id = 401};

get_summon_card(211402) ->
    #base_summon_card{id = 211402,partner_id = 402};

get_summon_card(211403) ->
    #base_summon_card{id = 211403,partner_id = 403};

get_summon_card(211406) ->
    #base_summon_card{id = 211406,partner_id = 406};

get_summon_card(211407) ->
    #base_summon_card{id = 211407,partner_id = 407};

get_summon_card(211408) ->
    #base_summon_card{id = 211408,partner_id = 408};

get_summon_card(211413) ->
    #base_summon_card{id = 211413,partner_id = 413};

get_summon_card(211417) ->
    #base_summon_card{id = 211417,partner_id = 417};

get_summon_card(211418) ->
    #base_summon_card{id = 211418,partner_id = 418};

get_summon_card(211422) ->
    #base_summon_card{id = 211422,partner_id = 422};

get_summon_card(211423) ->
    #base_summon_card{id = 211423,partner_id = 423};

get_summon_card(211428) ->
    #base_summon_card{id = 211428,partner_id = 428};

get_summon_card(211431) ->
    #base_summon_card{id = 211431,partner_id = 431};

get_summon_card(211432) ->
    #base_summon_card{id = 211432,partner_id = 432};

get_summon_card(211433) ->
    #base_summon_card{id = 211433,partner_id = 433};

get_summon_card(211434) ->
    #base_summon_card{id = 211434,partner_id = 434};

get_summon_card(211501) ->
    #base_summon_card{id = 211501,partner_id = 501};

get_summon_card(211502) ->
    #base_summon_card{id = 211502,partner_id = 502};

get_summon_card(211503) ->
    #base_summon_card{id = 211503,partner_id = 503};

get_summon_card(_Id) ->
    [].

