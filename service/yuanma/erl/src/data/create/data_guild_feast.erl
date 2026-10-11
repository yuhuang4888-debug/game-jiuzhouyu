%%%---------------------------------------
%%% module      : data_guild_feast
%%% description : 公会晚宴配置
%%%
%%%---------------------------------------
-module(data_guild_feast).
-compile(export_all).
-include("guild_feast.hrl").




get_cfg(open_week) ->
[1,2,3,5,6];


get_cfg(open_time) ->
[{20,00,0}];


get_cfg(need_role_lv) ->
95;


get_cfg(duration) ->
900;


get_cfg(scene_id) ->
2007;


get_cfg(exp_plus_interval) ->
5;


get_cfg(gfeast_reward) ->
[];


get_cfg(topic_wait_time) ->
3;


get_cfg(act_desc) ->
0;


get_cfg(special_open_day) ->
[1,5];


get_cfg(topic_vaild_time) ->
15;


get_cfg(opday_lim) ->
3;


get_cfg(merge_day_lim) ->
3;


get_cfg(choose_question_num) ->
20;


get_cfg(short_answer_question_num) ->
0;


get_cfg(dragon_spirit) ->
500;


get_cfg(dragon_coord) ->
{2384,1641};


get_cfg(dragon_id) ->
29001;


get_cfg(dragon_time) ->
300;


get_cfg(dragon_pre_time) ->
0;


get_cfg(dragon_spirit_cost) ->
[{1, 0, 1}];


get_cfg(fire_wave) ->
10;


get_cfg(fire_reflush_time) ->
10;


get_cfg(fire_id) ->
701;


get_cfg(fire_coord) ->
{2384,1641};


get_cfg(guild_lv) ->
0;


get_cfg(enter_guild_time) ->
0;


get_cfg(enter_question_wait_time) ->
10;


get_cfg(rank_num) ->
50;


get_cfg(rank_point) ->
20;


get_cfg(fire_exist_time) ->
290;


get_cfg(fire_disappear) ->
8;


get_cfg(small_fire_coord) ->
[{1056,750},{1248,795}, {1440,882},{1428,1017},{1587,966},{1480,1125},{970,960},{924,1065},{1008,1158},{1149,1167},{1197,1191},{723,1119},{1044,843},{717,987},{1215,1359}];


get_cfg(white_fire_id) ->
702;


get_cfg(blue_fire_id) ->
703;


get_cfg(purple_fire_id) ->
704;


get_cfg(question_exist_time) ->
600;


get_cfg(short_topic_vaild_time) ->
30;


get_cfg(quiz_reward) ->
[{4,0,50},{3,0,5000}];


get_cfg(quiz_dragon_spirit) ->
8;


get_cfg(collect_fire_dragon_spirit) ->
8;


get_cfg(summon_cost) ->
[{1, 36255013},{2, 36255014},{3, 36255015}];


get_cfg(dragon_id_list) ->
[{1, 29003},{2, 29004},{3, 29005}];


get_cfg(dragon_id_reward) ->
[{1,5,16},{2,8,16},{3,10,16}];


get_cfg(summon_reward) ->
[{1, [{2,0,15},{3,0,200000}]}, {2, [{2,0,20},{3,0,300000}]}, {3, [{2,0,30},{3,0,500000}]}];


get_cfg(summon_time_limit) ->
240;


get_cfg(guild_boss_wait_time) ->
5;


get_cfg(food_cost) ->
[{1, [{2, 0,20}], [{0,32010498,1}]}, {2, [{2, 0, 100}], [{0,32010499,1}]}, {3, [{1, 0, 200}], [{0,32010500,1}]}];


get_cfg(food_buff) ->
[{1,5}, {2,10}, {3, 50}];


get_cfg(open_kf_day_limit) ->
6;


get_cfg(guild_feast_max_exp_ratio) ->
100;


get_cfg(game_type_ctrl) ->
[{quiz,[1,3,5,7]},{note_crash,[2,4,6]}];


get_cfg(quiz_game_name) ->
<<"结社答题"/utf8>>;


get_cfg(note_crash_game_name) ->
<<"结社消消乐"/utf8>>;

get_cfg(_Key) ->
	0.

get_topic(1) ->
	#gfeast_topic_cfg{id = 1,content = "古代六艺包括(?)、乐、射、御、书、数(1个字)",answer = "礼"};

get_topic(2) ->
	#gfeast_topic_cfg{id = 2,content = "股票市场中指数大幅上升又称(?)市(1个字)",answer = "牛"};

get_topic(3) ->
	#gfeast_topic_cfg{id = 3,content = "好莱坞位于美国(?)州(5个字)",answer = "加利福尼亚"};

get_topic(4) ->
	#gfeast_topic_cfg{id = 4,content = "太阳系中卫星最多的行星是(2个字)",answer = "土星"};

get_topic(5) ->
	#gfeast_topic_cfg{id = 5,content = "(?)是中国传统计算工具。(2个字)",answer = "算盘"};

get_topic(6) ->
	#gfeast_topic_cfg{id = 6,content = "“成也萧何，败也萧何”说的是谁的经历?(2个字)",answer = "韩信"};

get_topic(7) ->
	#gfeast_topic_cfg{id = 7,content = "“初出茅庐”中的“茅庐”本意是指谁的的住处?(3个字)",answer = "诸葛亮"};

get_topic(8) ->
	#gfeast_topic_cfg{id = 8,content = "“床前明月光”是唐代诗人(?)的千古名句(2个字)",answer = "李白"};

get_topic(9) ->
	#gfeast_topic_cfg{id = 9,content = "“春眠不觉晓”的下一句是(5个字)",answer = "处处闻啼鸟"};

get_topic(10) ->
	#gfeast_topic_cfg{id = 10,content = "“打蛇打七寸”的七寸是指：(2个字)",answer = "心脏"};

get_topic(11) ->
	#gfeast_topic_cfg{id = 11,content = "“独乐乐，与人乐乐，熟乐?”出自(?)(2个字)",answer = "孟子"};

get_topic(12) ->
	#gfeast_topic_cfg{id = 12,content = "“飞雪连天射白鹿，笑书神侠倚碧鸳”，其中“飞”是指哪一部小说?(4个字)",answer = "飞狐外传"};

get_topic(13) ->
	#gfeast_topic_cfg{id = 13,content = "“父母教，须敬听；父母责，须顺承”出自传统经典(?)(3个字)",answer = "弟子规"};

get_topic(14) ->
	#gfeast_topic_cfg{id = 14,content = "“会当凌绝顶，一览众山小“是杜甫的名句，诗人登上了哪座山发出了这样的感慨?(2个字)",answer = "泰山"};

get_topic(15) ->
	#gfeast_topic_cfg{id = 15,content = "“凯撒大帝”是古代哪一个国家的杰出军事统领?(3个字)",answer = "古罗马"};

get_topic(16) ->
	#gfeast_topic_cfg{id = 16,content = "“路漫漫其修远兮，吾将上下而求索。”这样的感慨出自谁之口。(2个字)",answer = "屈原"};

get_topic(17) ->
	#gfeast_topic_cfg{id = 17,content = "“明月几时有，把酒问青天”出自宋朝哪位词人之手?(2个字)",answer = "苏轼"};

get_topic(18) ->
	#gfeast_topic_cfg{id = 18,content = "“疱丁解牛“形容做事得心应手，“疱丁“指的是什么职业?(2个字)",answer = "厨师"};

get_topic(19) ->
	#gfeast_topic_cfg{id = 19,content = "“人生自古谁无死，留取丹心照汗青”的作者是(3个字)",answer = "文天祥"};

get_topic(20) ->
	#gfeast_topic_cfg{id = 20,content = "“三过家门而不人”是哪一历史人物的故事?(2个字)",answer = "大禹"};

get_topic(21) ->
	#gfeast_topic_cfg{id = 21,content = "“三人行，必有我师……敏而好学，不耻下问”出自?(2个字)",answer = "论语"};

get_topic(22) ->
	#gfeast_topic_cfg{id = 22,content = "“身在曹营，心在汉”说的是三国时期哪一位著名武将?(2个字)",answer = "关羽"};

get_topic(23) ->
	#gfeast_topic_cfg{id = 23,content = "“生当作人杰，死亦为鬼雄”是咏赞谁的名句?(2个字)",answer = "项羽"};

get_topic(24) ->
	#gfeast_topic_cfg{id = 24,content = "“吴带当风”是形容我国唐代哪个画家的笔法?吴道子(3个字)",answer = "吴道子"};

get_topic(25) ->
	#gfeast_topic_cfg{id = 25,content = "“夜来风雨声”的下一句是?(5个字)",answer = "花落知多少"};

get_topic(26) ->
	#gfeast_topic_cfg{id = 26,content = "“羽扇纶巾，谈笑间，樯橹灰飞烟灭”出自《念奴娇·赤壁怀古》，这首词的作者是?(2个字)",answer = "苏轼"};

get_topic(27) ->
	#gfeast_topic_cfg{id = 27,content = "“月上柳梢头，人约黄昏后“描写的是哪个传统节日?(3个字)",answer = "元宵节"};

get_topic(28) ->
	#gfeast_topic_cfg{id = 28,content = "“仲尼”是哪位春秋时期哲人的字?(2个字)",answer = "孔子"};

get_topic(29) ->
	#gfeast_topic_cfg{id = 29,content = "“醉里挑灯看剑，梦回吹角连营“出自谁的作品?(3个字)",answer = "辛弃疾"};

get_topic(30) ->
	#gfeast_topic_cfg{id = 30,content = "《本草纲目》的作者是(3个字)",answer = "李时珍"};

get_topic(31) ->
	#gfeast_topic_cfg{id = 31,content = "《第五交响曲》(即《命运交响曲》)的作者是?(3个字)",answer = "贝多芬"};

get_topic(32) ->
	#gfeast_topic_cfg{id = 32,content = "《红楼梦》的作者(?)是家喻户晓的文学家。(3个字)",answer = "曹雪芹"};

get_topic(33) ->
	#gfeast_topic_cfg{id = 33,content = "《红楼梦》是我国古代著名的长篇小说之一，它的别名是(3个字)",answer = "石头记"};

get_topic(34) ->
	#gfeast_topic_cfg{id = 34,content = "《京华烟云》是哪位享誉海内外的作家所著?(3个字)",answer = "林语堂"};

get_topic(35) ->
	#gfeast_topic_cfg{id = 35,content = "《康熙字典》成书于哪个朝代?(2个字)",answer = "清朝"};

get_topic(36) ->
	#gfeast_topic_cfg{id = 36,content = "《孟子》中“天时不如(?)，(?)不如人和”(2个字)",answer = "地利"};

get_topic(37) ->
	#gfeast_topic_cfg{id = 37,content = "《三国演义》中的凤雏是谁?(2个字)",answer = "庞统"};

get_topic(38) ->
	#gfeast_topic_cfg{id = 38,content = "《水浒传》里水泊梁山一百单八将中有(?)位女性(1个字)",answer = "3"};

get_topic(39) ->
	#gfeast_topic_cfg{id = 39,content = "《孙子兵法》的作者是(2个字)",answer = "孙武"};

get_topic(40) ->
	#gfeast_topic_cfg{id = 40,content = "《西游记》中，红孩儿的妈妈是谁?(4个字)",answer = "铁扇公主"};

get_topic(41) ->
	#gfeast_topic_cfg{id = 41,content = "《咏鹅》的作者是唐初的谁?(3个字)",answer = "骆宾王"};

get_topic(42) ->
	#gfeast_topic_cfg{id = 42,content = "180°经线是哪条重要地理界线?(7个字)",answer = "国际日期变更线"};

get_topic(43) ->
	#gfeast_topic_cfg{id = 43,content = "2斤棉花和1斤铁块，哪个更重?(2个字)",answer = "棉花"};

get_topic(44) ->
	#gfeast_topic_cfg{id = 44,content = "爱尔兰的首都是?(3个字)",answer = "都柏林"};

get_topic(45) ->
	#gfeast_topic_cfg{id = 45,content = "奥林匹克环一共由几种颜色组成?(请用阿拉伯数字作答)(1个字)",answer = "5"};

get_topic(46) ->
	#gfeast_topic_cfg{id = 46,content = "巴拿马运河是北美洲与(?)的分界线(3个字)",answer = "南美洲"};

get_topic(47) ->
	#gfeast_topic_cfg{id = 47,content = "白求恩是哪个国家的人?(3个字)",answer = "加拿大"};

get_topic(48) ->
	#gfeast_topic_cfg{id = 48,content = "白求恩是哪国人?(3个字)",answer = "加拿大"};

get_topic(49) ->
	#gfeast_topic_cfg{id = 49,content = "被称为“书圣”的古代书法家为：(3个字)",answer = "王羲之"};

get_topic(50) ->
	#gfeast_topic_cfg{id = 50,content = "被称作”法国号”的乐器是(2个字)",answer = "圆号"};

get_topic(51) ->
	#gfeast_topic_cfg{id = 51,content = "被人们称作“梦幻工厂”的是(3个字)",answer = "好莱坞"};

get_topic(52) ->
	#gfeast_topic_cfg{id = 52,content = "比利时的首都是?(4个字)",answer = "布鲁塞尔"};

get_topic(53) ->
	#gfeast_topic_cfg{id = 53,content = "碧螺春是一种(?)茶(1个字)",answer = "绿"};

get_topic(54) ->
	#gfeast_topic_cfg{id = 54,content = "冰球比赛中每队上场人数为?(1个字)",answer = "6"};

get_topic(55) ->
	#gfeast_topic_cfg{id = 55,content = "不识(?)真面目，只缘身在此山中(2个字)",answer = "庐山"};

get_topic(56) ->
	#gfeast_topic_cfg{id = 56,content = "草书、行书、楷书、隶书四种字体当中哪一种是其余三种的起源?(2个字)",answer = "隶书"};

get_topic(57) ->
	#gfeast_topic_cfg{id = 57,content = "朝鲜的首都是?(2个字)",answer = "平壤"};

get_topic(58) ->
	#gfeast_topic_cfg{id = 58,content = "成名于超级星光大道，有《王妃》、《新不了情》等代表舞曲的台湾男歌手是谁?(3个字)",answer = "萧敬腾"};

get_topic(59) ->
	#gfeast_topic_cfg{id = 59,content = "成语“(?)驹过隙”比喻时光飞逝(1个字)",answer = "白"};

get_topic(60) ->
	#gfeast_topic_cfg{id = 60,content = "成语“完璧归赵”中的壁的全称是什么?(3个字)",answer = "和氏璧"};

get_topic(61) ->
	#gfeast_topic_cfg{id = 61,content = "成语典故背水一战与哪位历史名人有关?(2个字)",answer = "韩信"};

get_topic(62) ->
	#gfeast_topic_cfg{id = 62,content = "成语典故破釜沉舟与哪位历史名人有关?(2个字)",answer = "项羽"};

get_topic(63) ->
	#gfeast_topic_cfg{id = 63,content = "川是我国哪里的简称?(2个字)",answer = "四川"};

get_topic(64) ->
	#gfeast_topic_cfg{id = 64,content = "德雷克海峡是南美洲与(?)的分界线(3个字)",answer = "南极洲"};

get_topic(65) ->
	#gfeast_topic_cfg{id = 65,content = "电影《变形金刚》中，与擎天柱作对的反派首领叫什么?(3个字)",answer = "威震天"};

get_topic(66) ->
	#gfeast_topic_cfg{id = 66,content = "东北最出名的传统曲艺是?(3个字)",answer = "二人转"};

get_topic(67) ->
	#gfeast_topic_cfg{id = 67,content = "冬季路面上容易结冰，我们一般会在路面上洒什么调味品?(1个字)",answer = "盐"};

get_topic(68) ->
	#gfeast_topic_cfg{id = 68,content = "动画片《喜羊羊与灰太狼》中，羊村最健壮最鲁莽的一只羊叫什么?(3个字)",answer = "沸羊羊"};

get_topic(69) ->
	#gfeast_topic_cfg{id = 69,content = "俄罗斯的首都是?(3个字)",answer = "莫斯科"};

get_topic(70) ->
	#gfeast_topic_cfg{id = 70,content = "烽火连三月，(?)抵万金(2个字)",answer = "家书"};

get_topic(71) ->
	#gfeast_topic_cfg{id = 71,content = "芙蓉花是(?)市的市花(2个字)",answer = "成都"};

get_topic(72) ->
	#gfeast_topic_cfg{id = 72,content = "甘是我国哪里的简称?(2个字)",answer = "甘肃"};

get_topic(73) ->
	#gfeast_topic_cfg{id = 73,content = "古代男子二十岁被称为?(2个字)",answer = "弱冠"};

get_topic(74) ->
	#gfeast_topic_cfg{id = 74,content = "古代战争中指挥军队进攻时要敲击(?)(1个字)",answer = "鼓"};

get_topic(75) ->
	#gfeast_topic_cfg{id = 75,content = "古语“近(?)者赤”(1个字)",answer = "朱"};

get_topic(76) ->
	#gfeast_topic_cfg{id = 76,content = "古筝和古琴哪一个的弦更多?(2个字)",answer = "古琴"};

get_topic(77) ->
	#gfeast_topic_cfg{id = 77,content = "谷氨酸钠在生活中俗称什么?(2个字)",answer = "味精"};

get_topic(78) ->
	#gfeast_topic_cfg{id = 78,content = "挂香包、插艾蒿、喝雄黄酒是哪个传统节日的习俗?(2个字)",answer = "端午"};

get_topic(79) ->
	#gfeast_topic_cfg{id = 79,content = "贯通河北和河南的河是哪条河?(2个字)",answer = "黄河"};

get_topic(80) ->
	#gfeast_topic_cfg{id = 80,content = "广州根据“五羊”的传说而有(?)之名。(2个字)",answer = "羊城"};

get_topic(81) ->
	#gfeast_topic_cfg{id = 81,content = "国产动画片《宝莲灯》当中“二郎神”是主人公“沉香”的：(2个字)",answer = "舅舅"};

get_topic(82) ->
	#gfeast_topic_cfg{id = 82,content = "荷兰的首都是?(5个字)",answer = "阿姆斯特丹"};

get_topic(83) ->
	#gfeast_topic_cfg{id = 83,content = "湖南湖北的“湖”是指(3个字)",answer = "洞庭湖"};

get_topic(84) ->
	#gfeast_topic_cfg{id = 84,content = "虎门销烟显示了中国人民禁烟斗争的伟大胜利，领导这场斗争的是?(3个字)",answer = "林则徐"};

get_topic(85) ->
	#gfeast_topic_cfg{id = 85,content = "沪是我国哪里的简称?(2个字)",answer = "上海"};

get_topic(86) ->
	#gfeast_topic_cfg{id = 86,content = "吉是我国哪里的简称?(2个字)",answer = "吉林"};

get_topic(87) ->
	#gfeast_topic_cfg{id = 87,content = "既是法国最大的王宫建筑，又是世界上最著名的艺术殿堂的是(3个字)",answer = "卢浮宫"};

get_topic(88) ->
	#gfeast_topic_cfg{id = 88,content = "冀是我国哪里的简称?(2个字)",answer = "河北"};

get_topic(89) ->
	#gfeast_topic_cfg{id = 89,content = "柬埔寨的首都是?(2个字)",answer = "金边"};

get_topic(90) ->
	#gfeast_topic_cfg{id = 90,content = "讲究“以柔克刚，以静制动，以弱胜强“的传统拳法是?(3个字)",answer = "太极拳"};

get_topic(91) ->
	#gfeast_topic_cfg{id = 91,content = "今天的吐鲁番盆地在<<西游记>>中可能是(?)(3个字)",answer = "火焰山"};

get_topic(92) ->
	#gfeast_topic_cfg{id = 92,content = "金屋藏娇的故事与哪一位皇帝有关?(3个字)",answer = "汉武帝"};

get_topic(93) ->
	#gfeast_topic_cfg{id = 93,content = "津是我国哪里的简称?(2个字)",answer = "天津"};

get_topic(94) ->
	#gfeast_topic_cfg{id = 94,content = "晋是我国哪里的简称?(2个字)",answer = "山西"};

get_topic(95) ->
	#gfeast_topic_cfg{id = 95,content = "京是我国哪里的简称?(2个字)",answer = "北京"};

get_topic(96) ->
	#gfeast_topic_cfg{id = 96,content = "经典故事集《一千零一夜》又名(?)(4个字)",answer = "天方夜谭"};

get_topic(97) ->
	#gfeast_topic_cfg{id = 97,content = "距离地球最近的恒星是?(2个字)",answer = "太阳"};

get_topic(98) ->
	#gfeast_topic_cfg{id = 98,content = "篮球比赛中，每队应派几位选手上场参加比赛?(请用阿拉伯数字作答)(1个字)",answer = "5"};

get_topic(99) ->
	#gfeast_topic_cfg{id = 99,content = "两个黄鹂鸣翠柳，一行(?)上青天(2个字)",answer = "白鹭"};

get_topic(100) ->
	#gfeast_topic_cfg{id = 100,content = "辽是我国哪里的简称?(2个字)",answer = "辽宁"};

get_topic(101) ->
	#gfeast_topic_cfg{id = 101,content = "六弦琴是什么乐器的别称?(2个字)",answer = "吉他"};

get_topic(102) ->
	#gfeast_topic_cfg{id = 102,content = "卢森堡的首都是?(3个字)",answer = "卢森堡"};

get_topic(103) ->
	#gfeast_topic_cfg{id = 103,content = "马来西亚的首都是?(3个字)",answer = "吉隆坡"};

get_topic(104) ->
	#gfeast_topic_cfg{id = 104,content = "馒头是谁发明的?(3个字)",answer = "诸葛亮"};

get_topic(105) ->
	#gfeast_topic_cfg{id = 105,content = "明朝永乐年间，从西洋归来的郑和船队带回了一只西方异域兽“麒麟“，就是现在我们所知的(3个字)",answer = "长颈鹿"};

get_topic(106) ->
	#gfeast_topic_cfg{id = 106,content = "莫斯科市最大规模的交通系统是?(2个字)",answer = "地铁"};

get_topic(107) ->
	#gfeast_topic_cfg{id = 107,content = "哪种水果视力最差?(2个字)",answer = "芒果"};

get_topic(108) ->
	#gfeast_topic_cfg{id = 108,content = "你爸爸和你妈妈生了个儿子，他既不是你哥哥又不是你弟弟，他是谁?(2个字)",answer = "自己"};

get_topic(109) ->
	#gfeast_topic_cfg{id = 109,content = "鸟类中最小的是(2个字)",answer = "蜂鸟"};

get_topic(110) ->
	#gfeast_topic_cfg{id = 110,content = "拍电影时常用的(?)来表示拍摄完成(2个字)",answer = "杀青"};

get_topic(111) ->
	#gfeast_topic_cfg{id = 111,content = "普洱茶的产地在哪?(2个字)",answer = "云南"};

get_topic(112) ->
	#gfeast_topic_cfg{id = 112,content = "恰似一江春水向东流的上一句是?(7个字)",answer = "问君能有几多愁"};

get_topic(113) ->
	#gfeast_topic_cfg{id = 113,content = "秦时(?)汉时关，万里长征人未还(2个字)",answer = "明月"};

get_topic(114) ->
	#gfeast_topic_cfg{id = 114,content = "琼是我国哪里的简称?(2个字)",answer = "海南"};

get_topic(115) ->
	#gfeast_topic_cfg{id = 115,content = "热气球，可以载着人升上天空，请问热气球是哪个国家人发明的?(2个字)",answer = "法国"};

get_topic(116) ->
	#gfeast_topic_cfg{id = 116,content = "人类最早使用的工具，是什么材料的?(2个字)",answer = "石头"};

get_topic(117) ->
	#gfeast_topic_cfg{id = 117,content = "人脑中控制人平衡力的是(2个字)",answer = "小脑"};

get_topic(118) ->
	#gfeast_topic_cfg{id = 118,content = "人体最坚硬的部分是?(2个字)",answer = "牙齿"};

get_topic(119) ->
	#gfeast_topic_cfg{id = 119,content = "日本的首都是?(2个字)",answer = "东京"};

get_topic(120) ->
	#gfeast_topic_cfg{id = 120,content = "山重水复疑无路，柳暗花明又一村是谁的诗句?(2个字)",answer = "陆游"};

get_topic(121) ->
	#gfeast_topic_cfg{id = 121,content = "陕西省一块著名的“无字碑“，它与哪位皇帝有关?(3个字)",answer = "武则天"};

get_topic(122) ->
	#gfeast_topic_cfg{id = 122,content = "少壮不(?)，老大徒伤悲(2个字)",answer = "努力"};

get_topic(123) ->
	#gfeast_topic_cfg{id = 123,content = "身无彩凤双飞翼，心有灵犀一点通是哪一个诗人的诗句(3个字)",answer = "李商隐"};

get_topic(124) ->
	#gfeast_topic_cfg{id = 124,content = "什么动物的尾巴像把扇?(2个字)",answer = "孔雀"};

get_topic(125) ->
	#gfeast_topic_cfg{id = 125,content = "什么人始终不敢洗澡?(2个字)",answer = "泥人"};

get_topic(126) ->
	#gfeast_topic_cfg{id = 126,content = "十二时辰中的(?)时是指23点——1点(1个字)",answer = "子"};

get_topic(127) ->
	#gfeast_topic_cfg{id = 127,content = "世界第一高峰是我国的什么山峰?(5个字)",answer = "珠穆朗玛峰"};

get_topic(128) ->
	#gfeast_topic_cfg{id = 128,content = "世界第一枚邮票出现在：(请用国家名作答)(2个字)",answer = "英国"};

get_topic(129) ->
	#gfeast_topic_cfg{id = 129,content = "世界上冰最多的地区是(?)大陆。(2个字)",answer = "南极"};

get_topic(130) ->
	#gfeast_topic_cfg{id = 130,content = "世界上的“风车之国”是指(2个字)",answer = "荷兰"};

get_topic(131) ->
	#gfeast_topic_cfg{id = 131,content = "世界上跨纬度最广，东西距离最大的大洲是?(2个字)",answer = "亚洲"};

get_topic(132) ->
	#gfeast_topic_cfg{id = 132,content = "世界上最大的岩石(4个字)",answer = "艾尔斯石"};

get_topic(133) ->
	#gfeast_topic_cfg{id = 133,content = "世界上最大的洲是?(2个字)",answer = "亚洲"};

get_topic(134) ->
	#gfeast_topic_cfg{id = 134,content = "世界上最早种植棉花的国家是：(2个字)",answer = "印度"};

get_topic(135) ->
	#gfeast_topic_cfg{id = 135,content = "世界上最长的海峡(6个字)",answer = "莫桑比克海峡"};

get_topic(136) ->
	#gfeast_topic_cfg{id = 136,content = "世界上最长的山脉是(4个字)",answer = "安第斯山"};

get_topic(137) ->
	#gfeast_topic_cfg{id = 137,content = "世界一共有几个大州?(请用阿拉伯数字作答)(1个字)",answer = "7"};

get_topic(138) ->
	#gfeast_topic_cfg{id = 138,content = "首开武举选拨人才的女皇帝是谁?(3个字)",answer = "武则天"};

get_topic(139) ->
	#gfeast_topic_cfg{id = 139,content = "书画作品中的“四君子”是指梅、兰、(?)、菊四种植物。(1个字)",answer = "竹"};

get_topic(140) ->
	#gfeast_topic_cfg{id = 140,content = "谁发明了地动仪?(2个字)",answer = "张衡"};

get_topic(141) ->
	#gfeast_topic_cfg{id = 141,content = "谁发明了炸药?(3个字)",answer = "诺贝尔"};

get_topic(142) ->
	#gfeast_topic_cfg{id = 142,content = "水蒸发后会变成什么?(3个字)",answer = "水蒸气"};

get_topic(143) ->
	#gfeast_topic_cfg{id = 143,content = "苏轼在《念奴娇·赤壁怀古》中提到了“羽扇纶巾，谈笑间，樯橹灰飞烟灭”，“羽扇纶巾“形容的是下面哪位历史人物?(2个字)",answer = "周瑜"};

get_topic(144) ->
	#gfeast_topic_cfg{id = 144,content = "俗称”四不象”的动物是(2个字)",answer = "麋鹿"};

get_topic(145) ->
	#gfeast_topic_cfg{id = 145,content = "俗语说“化干戈为玉帛“，干戈都是兵器，其中(?)指的是防御武器(1个字)",answer = "干"};

get_topic(146) ->
	#gfeast_topic_cfg{id = 146,content = "俗语说“化干戈为玉帛“，干戈都是兵器，其中(?)指的是进攻武器(1个字)",answer = "戈"};

get_topic(147) ->
	#gfeast_topic_cfg{id = 147,content = "太平洋的中间是什么?(1个字)",answer = "平"};

get_topic(148) ->
	#gfeast_topic_cfg{id = 148,content = "太阳系的八大行星为：水星、金星、地球、火星、木星、土星、海王星和什么星?(3个字)",answer = "天王星"};

get_topic(149) ->
	#gfeast_topic_cfg{id = 149,content = "坦克是哪个国家发明的?(2个字)",answer = "英国"};

get_topic(150) ->
	#gfeast_topic_cfg{id = 150,content = "唐朝盛世“贞观之治”出现于哪位皇帝的执政时期?(3个字)",answer = "李世民"};

get_topic(151) ->
	#gfeast_topic_cfg{id = 151,content = "皖是我国哪里的简称?(2个字)",answer = "安徽"};

get_topic(152) ->
	#gfeast_topic_cfg{id = 152,content = "王羲之对一种动物十分偏爱，并从它的体态姿势上领悟到书法执笔运笔的道理，这是什么动物?(B)(1个字)",answer = "鹅"};

get_topic(153) ->
	#gfeast_topic_cfg{id = 153,content = "文学史上被称作“小李杜“的是杜牧和谁?(3个字)",answer = "李商隐"};

get_topic(154) ->
	#gfeast_topic_cfg{id = 154,content = "问世间(?)为何物，直教生死相许“(1个字)",answer = "情"};

get_topic(155) ->
	#gfeast_topic_cfg{id = 155,content = "我国安徽省的省会城市是?(2个字)",answer = "合肥"};

get_topic(156) ->
	#gfeast_topic_cfg{id = 156,content = "我国被称为”不夜城”的城市是哪一座城市(2个字)",answer = "漠河"};

get_topic(157) ->
	#gfeast_topic_cfg{id = 157,content = "我国传统表示次序的“天干”共有(?)个字?(2个字)",answer = "10"};

get_topic(158) ->
	#gfeast_topic_cfg{id = 158,content = "我国大陆家庭电路的电压统一使用为多少伏(请用阿拉伯数字作答)(3个字)",answer = "220"};

get_topic(159) ->
	#gfeast_topic_cfg{id = 159,content = "我国的“冰城”是指哪一城市?(3个字)",answer = "哈尔滨"};

get_topic(160) ->
	#gfeast_topic_cfg{id = 160,content = "我国的京剧脸谱色彩含义丰富，(?)色一般表示阴险奸诈(1个字)",answer = "白"};

get_topic(161) ->
	#gfeast_topic_cfg{id = 161,content = "我国第一部诗歌总集是?(2个字)",answer = "诗经"};

get_topic(162) ->
	#gfeast_topic_cfg{id = 162,content = "我国甘肃省的省会城市是?(2个字)",answer = "兰州"};

get_topic(163) ->
	#gfeast_topic_cfg{id = 163,content = "我国广东省的省会城市是?(2个字)",answer = "广州"};

get_topic(164) ->
	#gfeast_topic_cfg{id = 164,content = "我国贵州省的省会城市是?(2个字)",answer = "贵阳"};

get_topic(165) ->
	#gfeast_topic_cfg{id = 165,content = "我国黑龙江省的省会城市是?(3个字)",answer = "哈尔滨"};

get_topic(166) ->
	#gfeast_topic_cfg{id = 166,content = "我国吉林省的省会城市是?(2个字)",answer = "长春"};

get_topic(167) ->
	#gfeast_topic_cfg{id = 167,content = "我国江苏省的省会城市是?(2个字)",answer = "南京"};

get_topic(168) ->
	#gfeast_topic_cfg{id = 168,content = "我国江西省的省会城市是?(2个字)",answer = "南昌"};

get_topic(169) ->
	#gfeast_topic_cfg{id = 169,content = "我国内蒙古自治区的省会城市是?(4个字)",answer = "呼和浩特"};

get_topic(170) ->
	#gfeast_topic_cfg{id = 170,content = "我国宁夏回族自治区的省会城市是?(2个字)",answer = "银川"};

get_topic(171) ->
	#gfeast_topic_cfg{id = 171,content = "我国山东省的省会城市是?(2个字)",answer = "济南"};

get_topic(172) ->
	#gfeast_topic_cfg{id = 172,content = "我国陕西省的省会城市是?(2个字)",answer = "西安"};

get_topic(173) ->
	#gfeast_topic_cfg{id = 173,content = "我国书法艺术博大精深，请问欧阳洵的字体被简称为(?)?(2个字)",answer = "欧体"};

get_topic(174) ->
	#gfeast_topic_cfg{id = 174,content = "我国四川省的省会城市是?(2个字)",answer = "成都"};

get_topic(175) ->
	#gfeast_topic_cfg{id = 175,content = "我国台湾省的省会城市是?(2个字)",answer = "台北"};

get_topic(176) ->
	#gfeast_topic_cfg{id = 176,content = "我国新疆维吾尔自治区的省会城市是?(4个字)",answer = "乌鲁木齐"};

get_topic(177) ->
	#gfeast_topic_cfg{id = 177,content = "我国云南省的省会城市是?(2个字)",answer = "昆明"};

get_topic(178) ->
	#gfeast_topic_cfg{id = 178,content = "我国著名的六朝古都是(2个字)",answer = "南京"};

get_topic(179) ->
	#gfeast_topic_cfg{id = 179,content = "我国著名的赵州桥建于哪个朝代?(1个字)",answer = "隋"};

get_topic(180) ->
	#gfeast_topic_cfg{id = 180,content = "我们通常所说的“五官”是指口、舌、眼还有哪两个部位?(2个字)",answer = "耳鼻"};

get_topic(181) ->
	#gfeast_topic_cfg{id = 181,content = "舞曲中的“圆舞曲”也叫作(?)(3个字)",answer = "华尔兹"};

get_topic(182) ->
	#gfeast_topic_cfg{id = 182,content = "西出阳关无故人中的”阳关”在现在的哪个省(区)(2个字)",answer = "甘肃"};

get_topic(183) ->
	#gfeast_topic_cfg{id = 183,content = "西印度群岛位于哪个大洋?(3个字)",answer = "大西洋"};

get_topic(184) ->
	#gfeast_topic_cfg{id = 184,content = "希腊的首都是?(2个字)",answer = "雅典"};

get_topic(185) ->
	#gfeast_topic_cfg{id = 185,content = "蟋蟀是靠什么发出鸣叫声的?(2个字)",answer = "翅膀"};

get_topic(186) ->
	#gfeast_topic_cfg{id = 186,content = "现在美国国旗星条旗上共有(?)颗星(2个字)",answer = "50"};

get_topic(187) ->
	#gfeast_topic_cfg{id = 187,content = "湘是我国哪里的简称?(2个字)",answer = "湖南"};

get_topic(188) ->
	#gfeast_topic_cfg{id = 188,content = "小说《包法利夫人》的作者是：(3个字)",answer = "福楼拜"};

get_topic(189) ->
	#gfeast_topic_cfg{id = 189,content = "小说《三国演义》中“单刀赴会“的故事主角是?(2个字)",answer = "关羽"};

get_topic(190) ->
	#gfeast_topic_cfg{id = 190,content = "嗅觉最灵敏的动物是(?)，其嗅觉细胞达22亿个。(1个字)",answer = "狗"};

get_topic(191) ->
	#gfeast_topic_cfg{id = 191,content = "徐霞客曾经盛赞一座山为“四海名山皆过目，就中此景难图录”。这座山指的是(3个字)",answer = "雁荡山"};

get_topic(192) ->
	#gfeast_topic_cfg{id = 192,content = "徐志摩的名诗《再别康桥》中的康桥是指今天的(?)大学。(2个字)",answer = "剑桥"};

get_topic(193) ->
	#gfeast_topic_cfg{id = 193,content = "雪莱的名句“冬天到了，(?)还会远吗”(2个字)",answer = "春天"};

get_topic(194) ->
	#gfeast_topic_cfg{id = 194,content = "亚洲耕地面积最大的国家是(2个字)",answer = "印度"};

get_topic(195) ->
	#gfeast_topic_cfg{id = 195,content = "一般金婚是纪念结婚多少周年?(请用阿拉伯数字作答)(2个字)",answer = "50"};

get_topic(196) ->
	#gfeast_topic_cfg{id = 196,content = "一般认为篮球起源于哪个国家?(2个字)",answer = "美国"};

get_topic(197) ->
	#gfeast_topic_cfg{id = 197,content = "一年有多少个月是31天的?(请用阿拉伯数字作答)(1个字)",answer = "7"};

get_topic(198) ->
	#gfeast_topic_cfg{id = 198,content = "一年有几个节气?(2个字)",answer = "24"};

get_topic(199) ->
	#gfeast_topic_cfg{id = 199,content = "一切物体在没有受到外力所用的时候，总保持匀速直线运动状态或静止状态，这是牛顿第几定律?(4个字)",answer = "第一定律"};

get_topic(200) ->
	#gfeast_topic_cfg{id = 200,content = "一群兔子排队，从左数小兔子是第100位，从右数小兔子是第99位，这群兔子一共有几只?(请用阿拉伯数字作答)(3个字)",answer = "198"};

get_topic(201) ->
	#gfeast_topic_cfg{id = 201,content = "一张桌子有四个角，砍去一个角，还剩几个角?(请用阿拉伯数字作答)(1个字)",answer = "5"};

get_topic(202) ->
	#gfeast_topic_cfg{id = 202,content = "一株竹子出笋时有18节，一年后有多少节?(请用阿拉伯数字作答)(2个字)",answer = "18"};

get_topic(203) ->
	#gfeast_topic_cfg{id = 203,content = "医生给你3颗药叫你每半小时吃一颗你吃完要多少小时?(请用阿拉伯数字作答)(1个字)",answer = "1"};

get_topic(204) ->
	#gfeast_topic_cfg{id = 204,content = "意大利的首都是?(2个字)",answer = "罗马"};

get_topic(205) ->
	#gfeast_topic_cfg{id = 205,content = "因蜀锦有名而得名“锦官城”的城市是?(2个字)",answer = "成都"};

get_topic(206) ->
	#gfeast_topic_cfg{id = 206,content = "婴儿出生时的哭啼声意味着婴儿开始有什么生理功能?(2个字)",answer = "呼吸"};

get_topic(207) ->
	#gfeast_topic_cfg{id = 207,content = "用来测量钻石重量单位是?(2个字)",answer = "克拉"};

get_topic(208) ->
	#gfeast_topic_cfg{id = 208,content = "由于推行开明务实政策，唐初出现了什么样的社会局面?(4个字)",answer = "贞观之治"};

get_topic(209) ->
	#gfeast_topic_cfg{id = 209,content = "有“世界童话大王之称”的安徒生是那个国家的?(2个字)",answer = "丹麦"};

get_topic(210) ->
	#gfeast_topic_cfg{id = 210,content = "有唐三藏主持建造的大雁塔是哪个城市的著名景点?(2个字)",answer = "西安"};

get_topic(211) ->
	#gfeast_topic_cfg{id = 211,content = "有意见要向当地的市政府反映应该拨打什么电话?(5个字)",answer = "12345"};

get_topic(212) ->
	#gfeast_topic_cfg{id = 212,content = "渝是我国哪里的简称?(2个字)",answer = "重庆"};

get_topic(213) ->
	#gfeast_topic_cfg{id = 213,content = "与“精忠报国”，“莫须有”等事件有关的历史人物是?(2个字)",answer = "岳飞"};

get_topic(214) ->
	#gfeast_topic_cfg{id = 214,content = "与杜牧并称为“小李杜”的是谁?(3个字)",answer = "李商隐"};

get_topic(215) ->
	#gfeast_topic_cfg{id = 215,content = "与清明节相关的,古代一个非常有名的,现在已经失传的节日是什么?(2个字)",answer = "寒食"};

get_topic(216) ->
	#gfeast_topic_cfg{id = 216,content = "遇到火灾时,我们应该拨打的火警电话号码是多少?(3个字)",answer = "119"};

get_topic(217) ->
	#gfeast_topic_cfg{id = 217,content = "粤是我国哪里的简称?(2个字)",answer = "广东"};

get_topic(218) ->
	#gfeast_topic_cfg{id = 218,content = "在古代，人们将乐器分为“丝“、“竹“，分别指弹弦乐器和吹奏乐器，其中(?)是指吹奏乐器。(1个字)",answer = "竹"};

get_topic(219) ->
	#gfeast_topic_cfg{id = 219,content = "在古代，人们将乐器分为“丝“、“竹“，分别指弹弦乐器和吹奏乐器，其中(?)是指弹弦乐器。(1个字)",answer = "丝"};

get_topic(220) ->
	#gfeast_topic_cfg{id = 220,content = "在三倍放大镜下，三角板角的度数会：(2个字)",answer = "不变"};

get_topic(221) ->
	#gfeast_topic_cfg{id = 221,content = "在世界杯历史上获得冠军次数最多的是哪个球队?(2个字)",answer = "巴西"};

get_topic(222) ->
	#gfeast_topic_cfg{id = 222,content = "在寺庙里总管各项事务的一位僧人称为(4个字)",answer = "主持方丈"};

get_topic(223) ->
	#gfeast_topic_cfg{id = 223,content = "在天愿做(?)，在地愿为连理枝(3个字)",answer = "比翼鸟"};

get_topic(224) ->
	#gfeast_topic_cfg{id = 224,content = "在天愿做比翼鸟，在地愿为(?)(3个字)",answer = "连理枝"};

get_topic(225) ->
	#gfeast_topic_cfg{id = 225,content = "在天愿做比翼鸟，在地愿为连理枝出自(3个字)",answer = "长恨歌"};

get_topic(226) ->
	#gfeast_topic_cfg{id = 226,content = "在围棋的棋盘上标有九个小圆点，这几个小圆点称作(?)(1个字)",answer = "星"};

get_topic(227) ->
	#gfeast_topic_cfg{id = 227,content = "在我国，“桃月”是指哪一月(请用阿拉伯数字作答)(1个字)",answer = "3"};

get_topic(228) ->
	#gfeast_topic_cfg{id = 228,content = "在我国，自古就有“天府之国”美誉的地区是(4个字)",answer = "四川盆地"};

get_topic(229) ->
	#gfeast_topic_cfg{id = 229,content = "在一天中，时钟的时针，分针和秒针完全重合在一起的时候有几次?(请用阿拉伯数字作答)(1个字)",answer = "2"};

get_topic(230) ->
	#gfeast_topic_cfg{id = 230,content = "在中国历史上治水三过家门而不入的是谁?(2个字)",answer = "大禹"};

get_topic(231) ->
	#gfeast_topic_cfg{id = 231,content = "在足球比赛中，裁判把运动员罚下场会使用什么牌?(2个字)",answer = "红牌"};

get_topic(232) ->
	#gfeast_topic_cfg{id = 232,content = "造纸术大约是在什么朝代发明的(2个字)",answer = "西汉"};

get_topic(233) ->
	#gfeast_topic_cfg{id = 233,content = "战国时期的兵器大多用哪种材料制成(2个字)",answer = "青铜"};

get_topic(234) ->
	#gfeast_topic_cfg{id = 234,content = "战国时著名的完璧归赵，这里的壁是指什么壁?(3个字)",answer = "和氏璧"};

get_topic(235) ->
	#gfeast_topic_cfg{id = 235,content = "制作太阳能热水器用什么颜色的容器吸收太阳能多?(2个字)",answer = "黑色"};

get_topic(236) ->
	#gfeast_topic_cfg{id = 236,content = "中国的“五行”是哪五行?(5个字)",answer = "金木水火土"};

get_topic(237) ->
	#gfeast_topic_cfg{id = 237,content = "中国的第一部按部首编排的中文字典叫什么?(4个字)",answer = "说文解字"};

get_topic(238) ->
	#gfeast_topic_cfg{id = 238,content = "中国的国球是什么球?(3个字)",answer = "乒乓球"};

get_topic(239) ->
	#gfeast_topic_cfg{id = 239,content = "中国第一位女性诺贝尔奖获得者是?(3个字)",answer = "屠呦呦"};

get_topic(240) ->
	#gfeast_topic_cfg{id = 240,content = "中国古代科举制度，殿试第一名为状元，第二名榜眼，第三名叫什么?(2个字)",answer = "探花"};

get_topic(241) ->
	#gfeast_topic_cfg{id = 241,content = "中国和朝鲜两国的界河是?(3个字)",answer = "鸭绿江"};

get_topic(242) ->
	#gfeast_topic_cfg{id = 242,content = "中国神话传说中人类的始祖是(2个字)",answer = "女娲"};

get_topic(243) ->
	#gfeast_topic_cfg{id = 243,content = "中国四大发明中的活字印刷术是谁发明的?(2个字)",answer = "毕昇"};

get_topic(244) ->
	#gfeast_topic_cfg{id = 244,content = "中国唯一一位女皇帝是谁?(3个字)",answer = "武则天"};

get_topic(245) ->
	#gfeast_topic_cfg{id = 245,content = "中国戏曲表演的四种艺术手段包括唱、念、做、(?)(1个字)",answer = "打"};

get_topic(246) ->
	#gfeast_topic_cfg{id = 246,content = "中国最大的湖泊是(3个字)",answer = "青海湖"};

get_topic(247) ->
	#gfeast_topic_cfg{id = 247,content = "中华历史上第一个皇帝是谁(3个字)",answer = "秦始皇"};

get_topic(248) ->
	#gfeast_topic_cfg{id = 248,content = "周瑜打黄盖(猜一歇后语)(8个字)",answer = "一个愿打一个愿挨"};

get_topic(249) ->
	#gfeast_topic_cfg{id = 249,content = "周长相等的等边三角形、正方形、圆形，哪一个的面积最大?(2个字)",answer = "圆形"};

get_topic(250) ->
	#gfeast_topic_cfg{id = 250,content = "诸葛亮与周瑜联手指挥的一场著名的以少胜多的战役是什么战役?(4个字)",answer = "赤壁之战"};

get_topic(251) ->
	#gfeast_topic_cfg{id = 251,content = "诸子百家中(?)家的特点是注重逻辑辩证，“白马非马”典故也出于此家。(1个字)",answer = "名"};

get_topic(252) ->
	#gfeast_topic_cfg{id = 252,content = "竹篮打水(猜一歇后语)(3个字)",answer = "一场空"};

get_topic(253) ->
	#gfeast_topic_cfg{id = 253,content = "著名的“自由女神”像坐落在美国的哪座城市?(2个字)",answer = "纽约"};

get_topic(254) ->
	#gfeast_topic_cfg{id = 254,content = "著名喜剧电影艺术家卓别林出生于哪个国家?(2个字)",answer = "英国"};

get_topic(255) ->
	#gfeast_topic_cfg{id = 255,content = "饭圈文化中xswl是什么意思(4个字)",answer = "笑死我了"};

get_topic(256) ->
	#gfeast_topic_cfg{id = 256,content = "饭圈文化中nsdd是什么意思(4个字)",answer = "你说的对"};

get_topic(257) ->
	#gfeast_topic_cfg{id = 257,content = "饭圈文化中“疯狂应援、支持”用什么表示(5个字)",answer = "打call"};

get_topic(258) ->
	#gfeast_topic_cfg{id = 258,content = "因“鸡你太美”而被全网嘲讽的娱乐明星是(3个字)",answer = "蔡徐坤"};

get_topic(259) ->
	#gfeast_topic_cfg{id = 259,content = "娱乐圈里贾乃亮和李小璐离婚事件的关键词是什么(3个字)",answer = "做头发"};

get_topic(260) ->
	#gfeast_topic_cfg{id = 260,content = "让演员翟天临陷入巨大风波的论文网站叫什么?(2个字)",answer = "知网"};

get_topic(261) ->
	#gfeast_topic_cfg{id = 261,content = "被誉为“大唐反恐24小时”的古装剧是(6个字)",answer = "长安十二时辰"};

get_topic(262) ->
	#gfeast_topic_cfg{id = 262,content = "2020年，以“时间管理大师”另类博人眼球的娱乐明星是(3个字)",answer = "罗志祥"};

get_topic(263) ->
	#gfeast_topic_cfg{id = 263,content = "2020年被说唱歌手认为最“恐惧”的穿搭风格是“淡黄的长裙，(?)”(5个字)",answer = "蓬松的头发"};

get_topic(264) ->
	#gfeast_topic_cfg{id = 264,content = "壁虎在遇到敌人攻击，很危险的情况下会舍弃身体的什么部分逃走(2个字)",answer = "尾巴"};

get_topic(265) ->
	#gfeast_topic_cfg{id = 265,content = "电影午夜凶铃中从电视剧爬出来的著名恐怖角色叫什么(2个字)",answer = "贞子"};

get_topic(266) ->
	#gfeast_topic_cfg{id = 266,content = "动画片中舒克贝塔历险记中，舒克是什么职业(3个字)",answer = "飞行员"};

get_topic(267) ->
	#gfeast_topic_cfg{id = 267,content = "骨质疏松症主要是身体缺乏哪种矿物质(1个字)",answer = "钙"};

get_topic(268) ->
	#gfeast_topic_cfg{id = 268,content = "人们常说花季的年纪指多少岁(3个字)",answer = "16岁"};

get_topic(269) ->
	#gfeast_topic_cfg{id = 269,content = "人们通常用来送花的蓝色妖姬其实是什么花(2个字)",answer = "玫瑰"};

get_topic(270) ->
	#gfeast_topic_cfg{id = 270,content = "世界上现存最大的两栖动物，因叫声很像幼儿哭声又名什么鱼(3个字)",answer = "娃娃鱼"};

get_topic(271) ->
	#gfeast_topic_cfg{id = 271,content = "我国古代时传统婚礼的拜天地有三拜，一拜天地，二拜(2个字)",answer = "高堂"};

get_topic(272) ->
	#gfeast_topic_cfg{id = 272,content = "我国铁道部的CRH高速动车，统一命名为什么号(3个字)",answer = "和谐号"};

get_topic(273) ->
	#gfeast_topic_cfg{id = 273,content = "歇后语黄鼠狼给鸡拜年的下一句是什么(4个字)",answer = "没安好心"};

get_topic(274) ->
	#gfeast_topic_cfg{id = 274,content = "歇后语十五个吊桶打水的下一句是什么(4个字)",answer = "七上八下"};

get_topic(275) ->
	#gfeast_topic_cfg{id = 275,content = "寻寻觅觅冷冷清清凄凄惨惨戚戚是出自宋朝那位女词人之手(3个字)",answer = "李清照"};

get_topic(276) ->
	#gfeast_topic_cfg{id = 276,content = "作为我国婚礼程序中，夫妻各执一杯酒，双手相交喝完表示相爱的喝酒形式叫什么(3个字)",answer = "交杯酒"};

get_topic(277) ->
	#gfeast_topic_cfg{id = 277,content = "电影《碟中谍4》中汤姆布鲁斯挑战的世界第一高的摩天大楼位于哪个城市(2个字)",answer = "迪拜"};

get_topic(278) ->
	#gfeast_topic_cfg{id = 278,content = "美国阿姆斯特朗登上月球后，说了“个人的一小步”，后一句是什么(6个字)",answer = "人类的一大步"};

get_topic(279) ->
	#gfeast_topic_cfg{id = 279,content = "世界上公认的第一架实用飞机的发明者是美国的什么人(4个字)",answer = "莱特兄弟"};

get_topic(280) ->
	#gfeast_topic_cfg{id = 280,content = "与刘德华，张学友，郭富城合称为香港“四大天王”的人是谁(2个字)",answer = "黎明"};

get_topic(281) ->
	#gfeast_topic_cfg{id = 281,content = "于2012年提出破产保护的原世界最大的照相机，胶卷生产供应商是哪家(2个字)",answer = "柯达"};

get_topic(282) ->
	#gfeast_topic_cfg{id = 282,content = "我国的吉利汽车公司成功收购了外国哪家汽车公司100%的股权(3个字)",answer = "沃尔沃"};

get_topic(283) ->
	#gfeast_topic_cfg{id = 283,content = "解放战争时期著名的“三大战役”中第一个打响的是哪个战役(4个字)",answer = "辽沈战役"};

get_topic(284) ->
	#gfeast_topic_cfg{id = 284,content = "股票交易中经常提到的术语“一手”，请问“一手”是指多少股(3个字)",answer = "100"};

get_topic(285) ->
	#gfeast_topic_cfg{id = 285,content = "我们通常吃的葵瓜子是什么植物的果实(3个字)",answer = "向日葵"};

get_topic(286) ->
	#gfeast_topic_cfg{id = 286,content = "国产动画片《喜羊羊与灰太狼》中，灰太狼的老婆叫什么名字(3个字)",answer = "红太狼"};

get_topic(287) ->
	#gfeast_topic_cfg{id = 287,content = "收藏有油画《蒙娜丽莎》等珍贵作品的法国博物馆是哪一座(3个字)",answer = "卢浮宫"};

get_topic(288) ->
	#gfeast_topic_cfg{id = 288,content = "著名的“自由女神”像坐落在美国的哪座城市(2个字)",answer = "纽约"};

get_topic(289) ->
	#gfeast_topic_cfg{id = 289,content = "历史上“焚书坑儒”的只中国的那一位皇帝(3个字)",answer = "秦始皇"};

get_topic(290) ->
	#gfeast_topic_cfg{id = 290,content = "28年作为央视春节联欢晚会结尾曲的歌曲叫什么名字(4个字)",answer = "难忘今宵"};

get_topic(291) ->
	#gfeast_topic_cfg{id = 291,content = "世界第一高峰是我国的什么山峰(5个字)",answer = "珠穆朗玛峰"};

get_topic(292) ->
	#gfeast_topic_cfg{id = 292,content = "迎客松是我国那个著名风景区的标志性景点(2个字)",answer = "黄山"};

get_topic(293) ->
	#gfeast_topic_cfg{id = 293,content = "“狗不理包子”是中国哪个城市的传统风味小吃(2个字)",answer = "天津"};

get_topic(294) ->
	#gfeast_topic_cfg{id = 294,content = "吃菠萝的时候人们一般会用什么水泡一会儿来减少麻木刺痛感(2个字)",answer = "盐水"};

get_topic(295) ->
	#gfeast_topic_cfg{id = 295,content = "清朝被称为“扬州八怪”的八个人中以画竹子闻名的是哪一位(3个字)",answer = "郑板桥"};

get_topic(296) ->
	#gfeast_topic_cfg{id = 296,content = "烟草里毒性最大的物质是什么(3个字)",answer = "尼古丁"};

get_topic(297) ->
	#gfeast_topic_cfg{id = 297,content = "小说《封神演义》中，传说由狐狸精变成的商纣王宠妃是谁(3个字)",answer = "苏妲己"};

get_topic(298) ->
	#gfeast_topic_cfg{id = 298,content = "创办“精武门”的中国清末爱国武术家是谁(3个字)",answer = "霍元甲"};

get_topic(299) ->
	#gfeast_topic_cfg{id = 299,content = "“有一个老人在中国的南海边画了一个圈”是哪首歌的歌词(5个字)",answer = "春天的故事"};

get_topic(300) ->
	#gfeast_topic_cfg{id = 300,content = "马可波罗是在哪个朝代来到中国的(2个字)",answer = "元朝"};

get_topic(301) ->
	#gfeast_topic_cfg{id = 301,content = "《马赛曲》是哪一位国家的国歌(2个字)",answer = "法国"};

get_topic(302) ->
	#gfeast_topic_cfg{id = 302,content = "广东话中的“老豆”是指普通话中的哪种称谓(2个字)",answer = "父亲"};

get_topic(303) ->
	#gfeast_topic_cfg{id = 303,content = "美国历史上著名的演讲《我有一个梦想》的演讲者是谁(5个字)",answer = "马丁路德金"};

get_topic(304) ->
	#gfeast_topic_cfg{id = 304,content = "电影《泰坦尼克号》的主题曲叫做(4个字)",answer = "我心永恒"};

get_topic(305) ->
	#gfeast_topic_cfg{id = 305,content = "冰箱或空调泄露的哪种物质会破坏大气层臭氧层(3个字)",answer = "氟利昂"};

get_topic(306) ->
	#gfeast_topic_cfg{id = 306,content = "现代奥运会起源于哪个国家(2个字)",answer = "希腊"};

get_topic(307) ->
	#gfeast_topic_cfg{id = 307,content = "“遥知兄弟登高处，遍插茱萸少一人”，描述的是什么节日(3个字)",answer = "重阳节"};

get_topic(308) ->
	#gfeast_topic_cfg{id = 308,content = "佛教中高僧经过火化后留下的结晶体，被作为圣物供奉的叫什么(3个字)",answer = "舍利子"};

get_topic(309) ->
	#gfeast_topic_cfg{id = 309,content = "陕西乾陵的“无字碑”，是哪位皇帝的功德碑(3个字)",answer = "武则天"};

get_topic(310) ->
	#gfeast_topic_cfg{id = 310,content = "我们经常用的“飘柔”洗发水，是美国哪家公司的产品(2个字)",answer = "宝洁"};

get_topic(311) ->
	#gfeast_topic_cfg{id = 311,content = "传说中开天辟地的上古人物叫做什么(2个字)",answer = "盘古"};

get_topic(312) ->
	#gfeast_topic_cfg{id = 312,content = "坐落在上海黄浦江畔的著名电视塔，叫做什么名字(4个字)",answer = "东方明珠"};

get_topic(313) ->
	#gfeast_topic_cfg{id = 313,content = "1987年徐克导演拍的《倩女幽魂》中饰演宁采臣的男主角是谁(3个字)",answer = "张国荣"};

get_topic(314) ->
	#gfeast_topic_cfg{id = 314,content = "指导《断背山》《卧虎藏龙》等电影的著名导演叫什么(2个字)",answer = "李安"};

get_topic(315) ->
	#gfeast_topic_cfg{id = 315,content = "经常听说的“工商管理硕士”的英文简称是什么(3个字)",answer = "MBA"};

get_topic(316) ->
	#gfeast_topic_cfg{id = 316,content = "我国六大古都中建都最早的是那座城市(2个字)",answer = "西安"};

get_topic(317) ->
	#gfeast_topic_cfg{id = 317,content = "一般被称为“万能献血者”的血型是什么(2个字)",answer = "0型"};

get_topic(318) ->
	#gfeast_topic_cfg{id = 318,content = "世界上第一家七星级酒店—“帆船酒店”，是在哪个城市(2个字)",answer = "迪拜"};

get_topic(319) ->
	#gfeast_topic_cfg{id = 319,content = "97年《还珠格格》中，因饰演小燕子一角而红遍亚洲的女演员是谁(2个字)",answer = "赵薇"};

get_topic(320) ->
	#gfeast_topic_cfg{id = 320,content = "经典台词“向我开炮!”出自中国哪一部老电影(4个字)",answer = "英雄儿女"};

get_topic(321) ->
	#gfeast_topic_cfg{id = 321,content = "清朝道光年间，在虎门销禁鸦片的民族英雄是谁(3个字)",answer = "林则徐"};

get_topic(322) ->
	#gfeast_topic_cfg{id = 322,content = "十二世纪十大画家之一，以画虾技术精湛而闻名的画家是谁(3个字)",answer = "齐白石"};

get_topic(323) ->
	#gfeast_topic_cfg{id = 323,content = "《西游记》中孙悟空的一个跟斗可以翻多远(5个字)",answer = "十万八千里"};

get_topic(324) ->
	#gfeast_topic_cfg{id = 324,content = "“西边的太阳快要落山了”这句歌词是出自哪部电影的插曲(5个字)",answer = "铁道游击队"};

get_topic(325) ->
	#gfeast_topic_cfg{id = 325,content = "中国的“雾都”是指哪个城市(2个字)",answer = "重庆"};

get_topic(326) ->
	#gfeast_topic_cfg{id = 326,content = "排球比赛中，一个队可以同时上场几名队员(2个字)",answer = "6人"};

get_topic(327) ->
	#gfeast_topic_cfg{id = 327,content = "吃多了皮蛋会造成哪种重金属元素中毒(1个字)",answer = "铅"};

get_topic(328) ->
	#gfeast_topic_cfg{id = 328,content = "人体分解和代谢酒精的主要器官是什么(1个字)",answer = "肝"};

get_topic(329) ->
	#gfeast_topic_cfg{id = 329,content = "电影《功夫》中，火云邪神最后被什么武功招式打败(4个字)",answer = "如来神掌"};

get_topic(330) ->
	#gfeast_topic_cfg{id = 330,content = "相传太极拳是由武当山哪位道士所创(3个字)",answer = "张三丰"};

get_topic(331) ->
	#gfeast_topic_cfg{id = 331,content = "蝌蚪靠什么呼吸(1个字)",answer = "腮"};

get_topic(332) ->
	#gfeast_topic_cfg{id = 332,content = "用来测量钻石重量单位是(2个字)",answer = "克拉"};

get_topic(333) ->
	#gfeast_topic_cfg{id = 333,content = "电影《白毛女》中，抢走喜儿的地主叫什么名字(3个字)",answer = "黄世仁"};

get_topic(334) ->
	#gfeast_topic_cfg{id = 334,content = "歇后语”泥菩萨过河“的下一句是什么(4个字)",answer = "自身难保"};

get_topic(335) ->
	#gfeast_topic_cfg{id = 335,content = "景泰蓝是中国哪个城市的著名手工艺品(2个字)",answer = "北京"};

get_topic(336) ->
	#gfeast_topic_cfg{id = 336,content = "美国历史上唯一一位任期达四届的总统是(3个字)",answer = "罗斯福"};

get_topic(337) ->
	#gfeast_topic_cfg{id = 337,content = "泼水节是我国哪个民族的传统节日也是他们的新年(2个字)",answer = "傣族"};

get_topic(338) ->
	#gfeast_topic_cfg{id = 338,content = "在感恩节这天，美国的家庭基本上都会吃的一道传统食物是什么(2个字)",answer = "火鸡"};

get_topic(339) ->
	#gfeast_topic_cfg{id = 339,content = "电视剧《新白娘子传奇》中，白素贞被压在什么塔中(3个字)",answer = "雷峰塔"};

get_topic(340) ->
	#gfeast_topic_cfg{id = 340,content = "1986版《西游记》中孙悟空的扮演者是叫什么名字(4个字)",answer = "六小龄童"};

get_topic(341) ->
	#gfeast_topic_cfg{id = 341,content = "被称为”天府之国“的地方是我国的哪个省(2个字)",answer = "四川"};

get_topic(342) ->
	#gfeast_topic_cfg{id = 342,content = "川菜”蚂蚁上树“的主要食材是肉末炒什么(2个字)",answer = "粉丝"};

get_topic(343) ->
	#gfeast_topic_cfg{id = 343,content = "驴打滚源于满洲，是我国哪个城市的古老小吃品种之一(2个字)",answer = "北京"};

get_topic(344) ->
	#gfeast_topic_cfg{id = 344,content = "人体缺少哪种元素会引起甲状腺肿大，俗称大脖子病(1个字)",answer = "碘"};

get_topic(345) ->
	#gfeast_topic_cfg{id = 345,content = "李白笔下的“飞流直下三千尺，疑是银河落九天”指的是哪个风景区?(2个字)",answer = "庐山"};

get_topic(346) ->
	#gfeast_topic_cfg{id = 346,content = "《西游记》中的火焰山位于：(请用省份名作答)(2个字)",answer = "新疆"};

get_topic(347) ->
	#gfeast_topic_cfg{id = 347,content = "“初出茅庐”中的“茅庐”本意是指谁的的住处?(3个字)",answer = "诸葛亮"};

get_topic(348) ->
	#gfeast_topic_cfg{id = 348,content = "“成也萧何，败也萧何”说的是谁的经历?(2个字)",answer = "韩信"};

get_topic(349) ->
	#gfeast_topic_cfg{id = 349,content = "古代小说常用“沉鱼落雁，闭月羞花”形容女性之美，其中“闭月”是指：(2个字)",answer = "貂蝉"};

get_topic(350) ->
	#gfeast_topic_cfg{id = 350,content = "东床快婿原本是指：(3个字)",answer = "王羲之"};

get_topic(351) ->
	#gfeast_topic_cfg{id = 351,content = "国产动画片《宝莲灯》当中“二郎神”是主人公“沉香”的：(2个字)",answer = "舅舅"};

get_topic(352) ->
	#gfeast_topic_cfg{id = 352,content = "“写鬼写妖高人一筹，刺贪刺虐入木三分”这一对联写的作家是(3个字)",answer = "蒲松龄"};

get_topic(353) ->
	#gfeast_topic_cfg{id = 353,content = "“路漫漫其修远兮，吾将上下而求索。”这样的感慨出自谁之口。(2个字)",answer = "屈原"};

get_topic(354) ->
	#gfeast_topic_cfg{id = 354,content = "最长的腿(打一成语)(4个字)",answer = "一步登天"};

get_topic(355) ->
	#gfeast_topic_cfg{id = 355,content = "最遥远的地方(打一成语)(4个字)",answer = "天涯海角"};

get_topic(356) ->
	#gfeast_topic_cfg{id = 356,content = "最贵的稿费(打一成语)(4个字)",answer = "一字千金"};

get_topic(357) ->
	#gfeast_topic_cfg{id = 357,content = "最高的巨人(打一成语)(4个字)",answer = "顶天立地"};

get_topic(358) ->
	#gfeast_topic_cfg{id = 358,content = "白求恩是哪国人?(3个字)",answer = "加拿大"};

get_topic(359) ->
	#gfeast_topic_cfg{id = 359,content = "文房四宝指的是哪四件东西?(4个字)",answer = "笔墨纸砚"};

get_topic(360) ->
	#gfeast_topic_cfg{id = 360,content = "谁发明了炸药?(3个字)",answer = "诺贝尔"};

get_topic(361) ->
	#gfeast_topic_cfg{id = 361,content = "世界上最大的洲是?(2个字)",answer = "亚洲"};

get_topic(362) ->
	#gfeast_topic_cfg{id = 362,content = "太平洋的中间是什么?(1个字)",answer = "平"};

get_topic(363) ->
	#gfeast_topic_cfg{id = 363,content = "你爸爸和你妈妈生了个儿子，他既不是你哥哥又不是你弟弟，他是谁?(2个字)",answer = "自己"};

get_topic(364) ->
	#gfeast_topic_cfg{id = 364,content = "中国的“五行”是哪五行?(5个字)",answer = "金木水火土"};

get_topic(365) ->
	#gfeast_topic_cfg{id = 365,content = "打什么东西，不必花力气?(3个字)",answer = "打瞌睡"};

get_topic(366) ->
	#gfeast_topic_cfg{id = 366,content = "冬瓜黄瓜西瓜南瓜都能吃，什么瓜不能吃?(2个字)",answer = "傻瓜"};

get_topic(367) ->
	#gfeast_topic_cfg{id = 367,content = "《本草纲目》的作者是?(3个字)",answer = "李时珍"};

get_topic(368) ->
	#gfeast_topic_cfg{id = 368,content = "依照西方习俗，订婚戒指戴在左手哪根手指上?(3个字)",answer = "无名指"};

get_topic(369) ->
	#gfeast_topic_cfg{id = 369,content = "举世闻名的泰姬陵在哪个国家?(2个字)",answer = "印度"};

get_topic(370) ->
	#gfeast_topic_cfg{id = 370,content = "人体消化道中最长的器官是：(2个字)",answer = "小肠"};

get_topic(371) ->
	#gfeast_topic_cfg{id = 371,content = "美国历史上第一所高等学府是：(4个字)",answer = "哈佛大学"};

get_topic(372) ->
	#gfeast_topic_cfg{id = 372,content = "距离地球最近的恒星是?(2个字)",answer = "太阳"};

get_topic(373) ->
	#gfeast_topic_cfg{id = 373,content = "“建元”是中国古代哪一个皇帝使用的年号?(3个字)",answer = "汉武帝"};

get_topic(374) ->
	#gfeast_topic_cfg{id = 374,content = "六弦琴是什么乐器的别称?(2个字)",answer = "吉他"};

get_topic(375) ->
	#gfeast_topic_cfg{id = 375,content = "人体最坚硬的部分是?(2个字)",answer = "牙齿"};

get_topic(376) ->
	#gfeast_topic_cfg{id = 376,content = "欧洲最长的河流是?(4个字)",answer = "伏尔加河"};

get_topic(377) ->
	#gfeast_topic_cfg{id = 377,content = "《义勇军进行曲》是哪部电影的主题歌?(4个字)",answer = "风云儿女"};

get_topic(378) ->
	#gfeast_topic_cfg{id = 378,content = "馒头是谁发明的?(3个字)",answer = "诸葛亮"};

get_topic(379) ->
	#gfeast_topic_cfg{id = 379,content = "马头琴是我国哪一民族的拉弦乐器?(3个字)",answer = "蒙古族"};

get_topic(380) ->
	#gfeast_topic_cfg{id = 380,content = "被称为“诗圣”的唐代诗人为：(2个字)",answer = "杜甫"};

get_topic(381) ->
	#gfeast_topic_cfg{id = 381,content = "“变脸”是哪个剧种的绝活?(2个字)",answer = "川剧"};

get_topic(382) ->
	#gfeast_topic_cfg{id = 382,content = "屈原是春秋时代哪国人?(2个字)",answer = "楚国"};

get_topic(383) ->
	#gfeast_topic_cfg{id = 383,content = "被称为“命运交响曲”的是贝多芬的第几交响曲?(请用阿拉伯数字作答)(1个字)",answer = "5"};

get_topic(384) ->
	#gfeast_topic_cfg{id = 384,content = "在三倍放大镜下，三角板角的度数会：(2个字)",answer = "不变"};

get_topic(385) ->
	#gfeast_topic_cfg{id = 385,content = "世界上最早种植棉花的国家是：(2个字)",answer = "印度"};

get_topic(386) ->
	#gfeast_topic_cfg{id = 386,content = "“知天命”代指多少岁?(请用阿拉伯数字作答)(2个字)",answer = "50"};

get_topic(387) ->
	#gfeast_topic_cfg{id = 387,content = "吉他有几根弦?(请用阿拉伯数字作答)(1个字)",answer = "6"};

get_topic(388) ->
	#gfeast_topic_cfg{id = 388,content = "世界上最大的宫殿是：(2个字)",answer = "故宫"};

get_topic(389) ->
	#gfeast_topic_cfg{id = 389,content = "蟋蟀是靠什么发出鸣叫声的?(2个字)",answer = "翅膀"};

get_topic(390) ->
	#gfeast_topic_cfg{id = 390,content = "被誉为“诗鬼”的唐代诗人是谁?(2个字)",answer = "李贺"};

get_topic(391) ->
	#gfeast_topic_cfg{id = 391,content = "世界卫生组织的英文缩写是：(3个字)",answer = "WHO"};

get_topic(392) ->
	#gfeast_topic_cfg{id = 392,content = "我国的“冰城”是指哪一城市?(3个字)",answer = "哈尔滨"};

get_topic(393) ->
	#gfeast_topic_cfg{id = 393,content = "公元618-907年，是我国古代的哪个朝代?(2个字)",answer = "唐代"};

get_topic(394) ->
	#gfeast_topic_cfg{id = 394,content = "哪项比赛是往后跑的?(2个字)",answer = "拔河"};

get_topic(395) ->
	#gfeast_topic_cfg{id = 395,content = "左无右有前无后有(打一个字)(1个字)",answer = "口"};

get_topic(396) ->
	#gfeast_topic_cfg{id = 396,content = "什么样的东西是假的，也有人愿意买?(2个字)",answer = "假发"};

get_topic(397) ->
	#gfeast_topic_cfg{id = 397,content = "什么字大家都会念错?(1个字)",answer = "错"};

get_topic(398) ->
	#gfeast_topic_cfg{id = 398,content = "8个人吃8份快餐需10分钟,16个人吃16份快餐需几分钟?(请用阿拉伯数字作答)(2个字)",answer = "10"};

get_topic(399) ->
	#gfeast_topic_cfg{id = 399,content = "小说《包法利夫人》的作者是：(3个字)",answer = "福楼拜"};

get_topic(400) ->
	#gfeast_topic_cfg{id = 400,content = "人体最大的器官是：(2个字)",answer = "皮肤"};

get_topic(401) ->
	#gfeast_topic_cfg{id = 401,content = "WTO是哪个组织的称呼?(6个字)",answer = "世界贸易组织"};

get_topic(402) ->
	#gfeast_topic_cfg{id = 402,content = "在所有植物中，什么植物是最老实的?(2个字)",answer = "芭蕉"};

get_topic(403) ->
	#gfeast_topic_cfg{id = 403,content = "“打蛇打七寸”的七寸是指：(2个字)",answer = "心脏"};

get_topic(404) ->
	#gfeast_topic_cfg{id = 404,content = "周长相等的等边三角形、正方形、圆形，哪一个的面积最大?(2个字)",answer = "圆形"};

get_topic(405) ->
	#gfeast_topic_cfg{id = 405,content = "欧洲最大的岛屿是：(5个字)",answer = "大不列颠岛"};

get_topic(406) ->
	#gfeast_topic_cfg{id = 406,content = "不明飞行物的英文字母简称是什么?(3个字)",answer = "UFO"};

get_topic(407) ->
	#gfeast_topic_cfg{id = 407,content = "第一次工业革命的发祥地在：(2个字)",answer = "英国"};

get_topic(408) ->
	#gfeast_topic_cfg{id = 408,content = "谁发明了蒸汽机?(2个字)",answer = "瓦特"};

get_topic(409) ->
	#gfeast_topic_cfg{id = 409,content = "我国被称为“不夜城”的城市是哪一座城市?(2个字)",answer = "漠河"};

get_topic(410) ->
	#gfeast_topic_cfg{id = 410,content = "电子计算机发明于哪一年?(4个字)",answer = "1946"};

get_topic(411) ->
	#gfeast_topic_cfg{id = 411,content = "缺少哪种维生素后，儿童易患佝偻病，成人易得软骨病?(4个字)",answer = "维生素D"};

get_topic(412) ->
	#gfeast_topic_cfg{id = 412,content = "唐代山水田园诗人的代表“王孟”中，“孟”指的是谁?(3个字)",answer = "孟浩然"};

get_topic(413) ->
	#gfeast_topic_cfg{id = 413,content = "世界上跨纬度最广，东西距离最大的大洲是?(2个字)",answer = "亚洲"};

get_topic(414) ->
	#gfeast_topic_cfg{id = 414,content = "表示氧元素的字母是?(1个字)",answer = "O"};

get_topic(415) ->
	#gfeast_topic_cfg{id = 415,content = "什么人始终不敢洗澡?(2个字)",answer = "泥人"};

get_topic(416) ->
	#gfeast_topic_cfg{id = 416,content = "在沙漠中怎样走路能使脚印在前方?(3个字)",answer = "倒着走"};

get_topic(417) ->
	#gfeast_topic_cfg{id = 417,content = "谁天天去看病?(2个字)",answer = "医生"};

get_topic(418) ->
	#gfeast_topic_cfg{id = 418,content = "《儒林外史》的作者是谁?(3个字)",answer = "吴敬梓"};

get_topic(_Id) ->
	[].

get_topic_ids() ->
[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,144,145,146,147,148,149,150,151,152,153,154,155,156,157,158,159,160,161,162,163,164,165,166,167,168,169,170,171,172,173,174,175,176,177,178,179,180,181,182,183,184,185,186,187,188,189,190,191,192,193,194,195,196,197,198,199,200,201,202,203,204,205,206,207,208,209,210,211,212,213,214,215,216,217,218,219,220,221,222,223,224,225,226,227,228,229,230,231,232,233,234,235,236,237,238,239,240,241,242,243,244,245,246,247,248,249,250,251,252,253,254,255,256,257,258,259,260,261,262,263,264,265,266,267,268,269,270,271,272,273,274,275,276,277,278,279,280,281,282,283,284,285,286,287,288,289,290,291,292,293,294,295,296,297,298,299,300,301,302,303,304,305,306,307,308,309,310,311,312,313,314,315,316,317,318,319,320,321,322,323,324,325,326,327,328,329,330,331,332,333,334,335,336,337,338,339,340,341,342,343,344,345,346,347,348,349,350,351,352,353,354,355,356,357,358,359,360,361,362,363,364,365,366,367,368,369,370,371,372,373,374,375,376,377,378,379,380,381,382,383,384,385,386,387,388,389,390,391,392,393,394,395,396,397,398,399,400,401,402,403,404,405,406,407,408,409,410,411,412,413,414,415,416,417,418].

get_question_cfg(1001) ->
	#gfeast_question_cfg{id = 1001,weight = 100,topic_type = 1,question = <<"1千克铁与0.001吨纸哪个更轻？"/utf8>>,right = 3,right_answer = <<"都很轻"/utf8>>,answer1 = <<"我怎么知道"/utf8>>,answer2 = <<"1千克铁"/utf8>>,answer3 = <<"都很轻"/utf8>>,answer4 = <<"0.001吨纸"/utf8>>};

get_question_cfg(1002) ->
	#gfeast_question_cfg{id = 1002,weight = 100,topic_type = 1,question = <<"古代六艺包括(?)、乐、射、御、书、数"/utf8>>,right = 1,right_answer = <<"礼"/utf8>>,answer1 = <<"礼"/utf8>>,answer2 = <<"仁"/utf8>>,answer3 = <<"义"/utf8>>,answer4 = <<"智"/utf8>>};

get_question_cfg(1003) ->
	#gfeast_question_cfg{id = 1003,weight = 100,topic_type = 1,question = <<"股票市场中指数大幅上升又称(?)市"/utf8>>,right = 1,right_answer = <<"牛"/utf8>>,answer1 = <<"牛"/utf8>>,answer2 = <<"马"/utf8>>,answer3 = <<"狗"/utf8>>,answer4 = <<"猪"/utf8>>};

get_question_cfg(1004) ->
	#gfeast_question_cfg{id = 1004,weight = 100,topic_type = 1,question = <<"好莱坞位于美国(?)州"/utf8>>,right = 1,right_answer = <<"加利福尼亚"/utf8>>,answer1 = <<"加利福尼亚"/utf8>>,answer2 = <<"阿拉斯加"/utf8>>,answer3 = <<"哥伦比亚"/utf8>>,answer4 = <<"印第安纳"/utf8>>};

get_question_cfg(1005) ->
	#gfeast_question_cfg{id = 1005,weight = 100,topic_type = 1,question = <<"太阳系中卫星最多的行星是"/utf8>>,right = 1,right_answer = <<"土星"/utf8>>,answer1 = <<"土星"/utf8>>,answer2 = <<"金星"/utf8>>,answer3 = <<"木星"/utf8>>,answer4 = <<"水星"/utf8>>};

get_question_cfg(1006) ->
	#gfeast_question_cfg{id = 1006,weight = 100,topic_type = 1,question = <<"(?)是中国传统计算工具。"/utf8>>,right = 1,right_answer = <<"算盘"/utf8>>,answer1 = <<"算盘"/utf8>>,answer2 = <<"计算器"/utf8>>,answer3 = <<"电脑"/utf8>>,answer4 = <<"手指"/utf8>>};

get_question_cfg(1007) ->
	#gfeast_question_cfg{id = 1007,weight = 100,topic_type = 1,question = <<"“成也萧何，败也萧何”说的是谁的经历?"/utf8>>,right = 1,right_answer = <<"韩信"/utf8>>,answer1 = <<"韩信"/utf8>>,answer2 = <<"萧何"/utf8>>,answer3 = <<"项羽"/utf8>>,answer4 = <<"刘邦"/utf8>>};

get_question_cfg(1008) ->
	#gfeast_question_cfg{id = 1008,weight = 100,topic_type = 1,question = <<"“初出茅庐”中的“茅庐”本意是指谁的的住处?"/utf8>>,right = 1,right_answer = <<"诸葛亮"/utf8>>,answer1 = <<"诸葛亮"/utf8>>,answer2 = <<"刘备"/utf8>>,answer3 = <<"张飞"/utf8>>,answer4 = <<"关羽"/utf8>>};

get_question_cfg(1009) ->
	#gfeast_question_cfg{id = 1009,weight = 100,topic_type = 1,question = <<"“床前明月光”是唐代诗人(?)的千古名句"/utf8>>,right = 1,right_answer = <<"李白"/utf8>>,answer1 = <<"李白"/utf8>>,answer2 = <<"杜甫"/utf8>>,answer3 = <<"李贺"/utf8>>,answer4 = <<"王勃"/utf8>>};

get_question_cfg(1010) ->
	#gfeast_question_cfg{id = 1010,weight = 100,topic_type = 1,question = <<"“春眠不觉晓”的下一句是："/utf8>>,right = 1,right_answer = <<"处处闻啼鸟"/utf8>>,answer1 = <<"处处闻啼鸟"/utf8>>,answer2 = <<"处处蚊子咬"/utf8>>,answer3 = <<"夜里不洗澡"/utf8>>,answer4 = <<"嗨也不嫌早"/utf8>>};

get_question_cfg(1011) ->
	#gfeast_question_cfg{id = 1011,weight = 100,topic_type = 1,question = <<"“打蛇打七寸”的七寸是指："/utf8>>,right = 1,right_answer = <<"心脏"/utf8>>,answer1 = <<"心脏"/utf8>>,answer2 = <<"头颅"/utf8>>,answer3 = <<"脖子"/utf8>>,answer4 = <<"肚子"/utf8>>};

get_question_cfg(1012) ->
	#gfeast_question_cfg{id = 1012,weight = 100,topic_type = 1,question = <<"“独乐乐，与人乐乐，熟乐?”出自(?)"/utf8>>,right = 1,right_answer = <<"孟子"/utf8>>,answer1 = <<"孟子"/utf8>>,answer2 = <<"孔子"/utf8>>,answer3 = <<"老子"/utf8>>,answer4 = <<"庄子"/utf8>>};

get_question_cfg(1013) ->
	#gfeast_question_cfg{id = 1013,weight = 100,topic_type = 1,question = <<"“飞雪连天射白鹿，笑书神侠倚碧鸳”，其中“飞”是指哪一部小说?"/utf8>>,right = 1,right_answer = <<"飞狐外传"/utf8>>,answer1 = <<"飞狐外传"/utf8>>,answer2 = <<"飞狐内传"/utf8>>,answer3 = <<"飞狐正传"/utf8>>,answer4 = <<"飞狐传"/utf8>>};

get_question_cfg(1014) ->
	#gfeast_question_cfg{id = 1014,weight = 100,topic_type = 1,question = <<"“父母教，须敬听；父母责，须顺承”出自传统经典(?)"/utf8>>,right = 1,right_answer = <<"弟子规"/utf8>>,answer1 = <<"弟子规"/utf8>>,answer2 = <<"道德经"/utf8>>,answer3 = <<"大学"/utf8>>,answer4 = <<"中庸"/utf8>>};

get_question_cfg(1015) ->
	#gfeast_question_cfg{id = 1015,weight = 100,topic_type = 1,question = <<"“会当凌绝顶，一览众山小“是杜甫的名句，诗人登上了哪座山发出了这样的感慨?"/utf8>>,right = 1,right_answer = <<"泰山"/utf8>>,answer1 = <<"泰山"/utf8>>,answer2 = <<"华山"/utf8>>,answer3 = <<"衡山"/utf8>>,answer4 = <<"嵩山"/utf8>>};

get_question_cfg(1016) ->
	#gfeast_question_cfg{id = 1016,weight = 100,topic_type = 1,question = <<"“凯撒大帝”是古代哪一个国家的杰出军事统领?"/utf8>>,right = 1,right_answer = <<"古罗马"/utf8>>,answer1 = <<"古罗马"/utf8>>,answer2 = <<"日耳曼"/utf8>>,answer3 = <<"不列颠"/utf8>>,answer4 = <<"西班牙"/utf8>>};

get_question_cfg(1017) ->
	#gfeast_question_cfg{id = 1017,weight = 100,topic_type = 1,question = <<"“路漫漫其修远兮，吾将上下而求索。”这样的感慨出自谁之口。"/utf8>>,right = 1,right_answer = <<"屈原"/utf8>>,answer1 = <<"屈原"/utf8>>,answer2 = <<"左丘明"/utf8>>,answer3 = <<"吕不韦"/utf8>>,answer4 = <<"宋玉"/utf8>>};

get_question_cfg(1018) ->
	#gfeast_question_cfg{id = 1018,weight = 100,topic_type = 1,question = <<"“明月几时有，把酒问青天”出自宋朝哪位词人之手?"/utf8>>,right = 1,right_answer = <<"苏轼"/utf8>>,answer1 = <<"苏轼"/utf8>>,answer2 = <<"陆游"/utf8>>,answer3 = <<"辛弃疾"/utf8>>,answer4 = <<"王安石"/utf8>>};

get_question_cfg(1019) ->
	#gfeast_question_cfg{id = 1019,weight = 100,topic_type = 1,question = <<"“疱丁解牛“形容做事得心应手，“疱丁“指的是什么职业?"/utf8>>,right = 1,right_answer = <<"厨师"/utf8>>,answer1 = <<"厨师"/utf8>>,answer2 = <<"屠夫"/utf8>>,answer3 = <<"农民"/utf8>>,answer4 = <<"车夫"/utf8>>};

get_question_cfg(1020) ->
	#gfeast_question_cfg{id = 1020,weight = 100,topic_type = 1,question = <<"“人生自古谁无死，留取丹心照汗青”的作者是"/utf8>>,right = 1,right_answer = <<"文天祥"/utf8>>,answer1 = <<"文天祥"/utf8>>,answer2 = <<"岳飞"/utf8>>,answer3 = <<"陆游"/utf8>>,answer4 = <<"杨万里"/utf8>>};

get_question_cfg(1021) ->
	#gfeast_question_cfg{id = 1021,weight = 100,topic_type = 1,question = <<"“三过家门而不人”是哪一历史人物的故事?"/utf8>>,right = 1,right_answer = <<"大禹"/utf8>>,answer1 = <<"大禹"/utf8>>,answer2 = <<"二禹"/utf8>>,answer3 = <<"三禹"/utf8>>,answer4 = <<"小禹"/utf8>>};

get_question_cfg(1022) ->
	#gfeast_question_cfg{id = 1022,weight = 100,topic_type = 1,question = <<"“三人行，必有我师……敏而好学，不耻下问”出自?"/utf8>>,right = 1,right_answer = <<"论语"/utf8>>,answer1 = <<"论语"/utf8>>,answer2 = <<"大学"/utf8>>,answer3 = <<"中庸"/utf8>>,answer4 = <<"孟子"/utf8>>};

get_question_cfg(1023) ->
	#gfeast_question_cfg{id = 1023,weight = 100,topic_type = 1,question = <<"“身在曹营，心在汉”说的是三国时期哪一位著名武将?"/utf8>>,right = 1,right_answer = <<"关羽"/utf8>>,answer1 = <<"关羽"/utf8>>,answer2 = <<"张飞"/utf8>>,answer3 = <<"赵云"/utf8>>,answer4 = <<"黄忠"/utf8>>};

get_question_cfg(1024) ->
	#gfeast_question_cfg{id = 1024,weight = 100,topic_type = 1,question = <<"“生当作人杰，死亦为鬼雄”是咏赞谁的名句?"/utf8>>,right = 1,right_answer = <<"项羽"/utf8>>,answer1 = <<"项羽"/utf8>>,answer2 = <<"孙武"/utf8>>,answer3 = <<"韩信"/utf8>>,answer4 = <<"萧何"/utf8>>};

get_question_cfg(1025) ->
	#gfeast_question_cfg{id = 1025,weight = 100,topic_type = 1,question = <<"“吴带当风”是形容我国唐代哪个画家的笔法?"/utf8>>,right = 1,right_answer = <<"吴道子"/utf8>>,answer1 = <<"吴道子"/utf8>>,answer2 = <<"吴承恩"/utf8>>,answer3 = <<"吴彦祖"/utf8>>,answer4 = <<"吴敬梓"/utf8>>};

get_question_cfg(1026) ->
	#gfeast_question_cfg{id = 1026,weight = 100,topic_type = 1,question = <<"“夜来风雨声”的下一句是?"/utf8>>,right = 1,right_answer = <<"花落知多少"/utf8>>,answer1 = <<"花落知多少"/utf8>>,answer2 = <<"声声皆入耳"/utf8>>,answer3 = <<"真的很烦人"/utf8>>,answer4 = <<"僧敲月下门"/utf8>>};

get_question_cfg(1027) ->
	#gfeast_question_cfg{id = 1027,weight = 100,topic_type = 1,question = <<"“羽扇纶巾，谈笑间，樯橹灰飞烟灭”出自《念奴娇·赤壁怀古》，这首词的作者是?"/utf8>>,right = 1,right_answer = <<"苏轼"/utf8>>,answer1 = <<"苏轼"/utf8>>,answer2 = <<"陆游"/utf8>>,answer3 = <<"辛弃疾"/utf8>>,answer4 = <<"王安石"/utf8>>};

get_question_cfg(1028) ->
	#gfeast_question_cfg{id = 1028,weight = 100,topic_type = 1,question = <<"“月上柳梢头，人约黄昏后“描写的是哪个传统节日?"/utf8>>,right = 1,right_answer = <<"元宵节"/utf8>>,answer1 = <<"元宵节"/utf8>>,answer2 = <<"端午节"/utf8>>,answer3 = <<"中秋节"/utf8>>,answer4 = <<"重阳节"/utf8>>};

get_question_cfg(1029) ->
	#gfeast_question_cfg{id = 1029,weight = 100,topic_type = 1,question = <<"“仲尼”是哪位春秋时期哲人的字?"/utf8>>,right = 1,right_answer = <<"孔子"/utf8>>,answer1 = <<"孔子"/utf8>>,answer2 = <<"孟子"/utf8>>,answer3 = <<"老子"/utf8>>,answer4 = <<"庄子"/utf8>>};

get_question_cfg(1030) ->
	#gfeast_question_cfg{id = 1030,weight = 100,topic_type = 1,question = <<"“醉里挑灯看剑，梦回吹角连营“出自谁的作品?"/utf8>>,right = 1,right_answer = <<"辛弃疾"/utf8>>,answer1 = <<"辛弃疾"/utf8>>,answer2 = <<"苏轼"/utf8>>,answer3 = <<"陆游"/utf8>>,answer4 = <<"王安石"/utf8>>};

get_question_cfg(1031) ->
	#gfeast_question_cfg{id = 1031,weight = 100,topic_type = 1,question = <<"《本草纲目》的作者是"/utf8>>,right = 1,right_answer = <<"李时珍"/utf8>>,answer1 = <<"李时珍"/utf8>>,answer2 = <<"扁鹊"/utf8>>,answer3 = <<"华佗"/utf8>>,answer4 = <<"孙思邈"/utf8>>};

get_question_cfg(1032) ->
	#gfeast_question_cfg{id = 1032,weight = 100,topic_type = 1,question = <<"《第五交响曲》(即《命运交响曲》)的作者是?"/utf8>>,right = 1,right_answer = <<"贝多芬"/utf8>>,answer1 = <<"贝多芬"/utf8>>,answer2 = <<"巴赫"/utf8>>,answer3 = <<"肖邦"/utf8>>,answer4 = <<"莫扎特"/utf8>>};

get_question_cfg(1033) ->
	#gfeast_question_cfg{id = 1033,weight = 100,topic_type = 1,question = <<"《红楼梦》的作者(?)是家喻户晓的文学家"/utf8>>,right = 1,right_answer = <<"曹雪芹"/utf8>>,answer1 = <<"曹雪芹"/utf8>>,answer2 = <<"吴承恩"/utf8>>,answer3 = <<"施耐庵"/utf8>>,answer4 = <<"罗贯中"/utf8>>};

get_question_cfg(1034) ->
	#gfeast_question_cfg{id = 1034,weight = 100,topic_type = 1,question = <<"《红楼梦》是我国古代著名的长篇小说之一，它的别名是"/utf8>>,right = 1,right_answer = <<"石头记"/utf8>>,answer1 = <<"石头记"/utf8>>,answer2 = <<"石头传"/utf8>>,answer3 = <<"石头学"/utf8>>,answer4 = <<"石头梦"/utf8>>};

get_question_cfg(1035) ->
	#gfeast_question_cfg{id = 1035,weight = 100,topic_type = 1,question = <<"《京华烟云》是哪位享誉海内外的作家所著?"/utf8>>,right = 1,right_answer = <<"林语堂"/utf8>>,answer1 = <<"林语堂"/utf8>>,answer2 = <<"林湄"/utf8>>,answer3 = <<"李尧棠"/utf8>>,answer4 = <<"莫言"/utf8>>};

get_question_cfg(1036) ->
	#gfeast_question_cfg{id = 1036,weight = 100,topic_type = 1,question = <<"《康熙字典》成书于哪个朝代?"/utf8>>,right = 1,right_answer = <<"清朝"/utf8>>,answer1 = <<"清朝"/utf8>>,answer2 = <<"明朝"/utf8>>,answer3 = <<"元朝"/utf8>>,answer4 = <<"民国"/utf8>>};

get_question_cfg(1037) ->
	#gfeast_question_cfg{id = 1037,weight = 100,topic_type = 1,question = <<"《孟子》中“天时不如(?)，(?)不如人和”"/utf8>>,right = 1,right_answer = <<"地利"/utf8>>,answer1 = <<"地利"/utf8>>,answer2 = <<"地优"/utf8>>,answer3 = <<"海利"/utf8>>,answer4 = <<"海优"/utf8>>};

get_question_cfg(1038) ->
	#gfeast_question_cfg{id = 1038,weight = 100,topic_type = 1,question = <<"《三国演义》中的凤雏是谁?"/utf8>>,right = 1,right_answer = <<"庞统"/utf8>>,answer1 = <<"庞统"/utf8>>,answer2 = <<"诸葛亮"/utf8>>,answer3 = <<"姜维"/utf8>>,answer4 = <<"司马懿"/utf8>>};

get_question_cfg(1039) ->
	#gfeast_question_cfg{id = 1039,weight = 100,topic_type = 1,question = <<"《水浒传》里水泊梁山一百单八将中有(?)位女性"/utf8>>,right = 1,right_answer = <<"3"/utf8>>,answer1 = <<"3"/utf8>>,answer2 = <<"5"/utf8>>,answer3 = <<"4"/utf8>>,answer4 = <<"6"/utf8>>};

get_question_cfg(1040) ->
	#gfeast_question_cfg{id = 1040,weight = 100,topic_type = 1,question = <<"《孙子兵法》的作者是"/utf8>>,right = 1,right_answer = <<"孙武"/utf8>>,answer1 = <<"孙武"/utf8>>,answer2 = <<"孙冯"/utf8>>,answer3 = <<"孙膑"/utf8>>,answer4 = <<"孙凭"/utf8>>};

get_question_cfg(1041) ->
	#gfeast_question_cfg{id = 1041,weight = 100,topic_type = 1,question = <<"《西游记》中，红孩儿的妈妈是谁?"/utf8>>,right = 1,right_answer = <<"铁扇公主"/utf8>>,answer1 = <<"铁扇公主"/utf8>>,answer2 = <<"玉面狐狸"/utf8>>,answer3 = <<"白骨精"/utf8>>,answer4 = <<"蝎子精"/utf8>>};

get_question_cfg(1042) ->
	#gfeast_question_cfg{id = 1042,weight = 100,topic_type = 1,question = <<"《咏鹅》的作者是唐初的谁?"/utf8>>,right = 1,right_answer = <<"骆宾王"/utf8>>,answer1 = <<"骆宾王"/utf8>>,answer2 = <<"白居易"/utf8>>,answer3 = <<"孟浩然"/utf8>>,answer4 = <<"刘禹锡"/utf8>>};

get_question_cfg(1043) ->
	#gfeast_question_cfg{id = 1043,weight = 100,topic_type = 1,question = <<"180°经线是哪条重要地理界线?"/utf8>>,right = 1,right_answer = <<"国际日期变更线"/utf8>>,answer1 = <<"国际日期变更线"/utf8>>,answer2 = <<"赤道"/utf8>>,answer3 = <<"南回归线"/utf8>>,answer4 = <<"北回归线"/utf8>>};

get_question_cfg(1044) ->
	#gfeast_question_cfg{id = 1044,weight = 100,topic_type = 1,question = <<"2斤棉花和1斤铁块，哪个更重?"/utf8>>,right = 1,right_answer = <<"棉花"/utf8>>,answer1 = <<"棉花"/utf8>>,answer2 = <<"铁块"/utf8>>,answer3 = <<"一样"/utf8>>,answer4 = <<"不知道"/utf8>>};

get_question_cfg(1045) ->
	#gfeast_question_cfg{id = 1045,weight = 100,topic_type = 1,question = <<"爱尔兰的首都是?"/utf8>>,right = 1,right_answer = <<"都柏林"/utf8>>,answer1 = <<"都柏林"/utf8>>,answer2 = <<"科克"/utf8>>,answer3 = <<"利默里克"/utf8>>,answer4 = <<"瓦特福德"/utf8>>};

get_question_cfg(1046) ->
	#gfeast_question_cfg{id = 1046,weight = 100,topic_type = 1,question = <<"奥林匹克环一共由几种颜色组成?"/utf8>>,right = 1,right_answer = <<"5"/utf8>>,answer1 = <<"5"/utf8>>,answer2 = <<"6"/utf8>>,answer3 = <<"7"/utf8>>,answer4 = <<"8"/utf8>>};

get_question_cfg(1047) ->
	#gfeast_question_cfg{id = 1047,weight = 100,topic_type = 1,question = <<"巴拿马运河是北美洲与(?)的分界线"/utf8>>,right = 1,right_answer = <<"南美洲"/utf8>>,answer1 = <<"南美洲"/utf8>>,answer2 = <<"欧洲"/utf8>>,answer3 = <<"亚洲"/utf8>>,answer4 = <<"大洋洲"/utf8>>};

get_question_cfg(1048) ->
	#gfeast_question_cfg{id = 1048,weight = 100,topic_type = 1,question = <<"白求恩是哪个国家的人?"/utf8>>,right = 1,right_answer = <<"加拿大"/utf8>>,answer1 = <<"加拿大"/utf8>>,answer2 = <<"美国"/utf8>>,answer3 = <<"法国"/utf8>>,answer4 = <<"英国"/utf8>>};

get_question_cfg(1049) ->
	#gfeast_question_cfg{id = 1049,weight = 100,topic_type = 1,question = <<"著名童话作家格林兄弟是哪国人?"/utf8>>,right = 1,right_answer = <<"德国"/utf8>>,answer1 = <<"德国"/utf8>>,answer2 = <<"加拿大"/utf8>>,answer3 = <<"美国"/utf8>>,answer4 = <<"法国"/utf8>>};

get_question_cfg(1050) ->
	#gfeast_question_cfg{id = 1050,weight = 100,topic_type = 1,question = <<"被称为“书圣”的古代书法家为"/utf8>>,right = 1,right_answer = <<"王羲之"/utf8>>,answer1 = <<"王羲之"/utf8>>,answer2 = <<"颜真卿"/utf8>>,answer3 = <<"柳公权"/utf8>>,answer4 = <<"欧阳修"/utf8>>};

get_question_cfg(1051) ->
	#gfeast_question_cfg{id = 1051,weight = 100,topic_type = 1,question = <<"被称作”法国号”的乐器是"/utf8>>,right = 1,right_answer = <<"圆号"/utf8>>,answer1 = <<"圆号"/utf8>>,answer2 = <<"小号"/utf8>>,answer3 = <<"长号"/utf8>>,answer4 = <<"大号"/utf8>>};

get_question_cfg(1052) ->
	#gfeast_question_cfg{id = 1052,weight = 100,topic_type = 1,question = <<"被人们称作“梦幻工厂”的是"/utf8>>,right = 1,right_answer = <<"好莱坞"/utf8>>,answer1 = <<"好莱坞"/utf8>>,answer2 = <<"拉蒙"/utf8>>,answer3 = <<"20世纪福克斯"/utf8>>,answer4 = <<"迪斯尼"/utf8>>};

get_question_cfg(1053) ->
	#gfeast_question_cfg{id = 1053,weight = 100,topic_type = 1,question = <<"比利时的首都是?"/utf8>>,right = 1,right_answer = <<"布鲁塞尔"/utf8>>,answer1 = <<"布鲁塞尔"/utf8>>,answer2 = <<"埃诺"/utf8>>,answer3 = <<"安特卫普"/utf8>>,answer4 = <<"卢森堡"/utf8>>};

get_question_cfg(1054) ->
	#gfeast_question_cfg{id = 1054,weight = 100,topic_type = 1,question = <<"碧螺春是一种(?)茶"/utf8>>,right = 1,right_answer = <<"绿"/utf8>>,answer1 = <<"绿"/utf8>>,answer2 = <<"红"/utf8>>,answer3 = <<"乌龙"/utf8>>,answer4 = <<"黑"/utf8>>};

get_question_cfg(1055) ->
	#gfeast_question_cfg{id = 1055,weight = 100,topic_type = 1,question = <<"冰球比赛中每队上场人数为?"/utf8>>,right = 1,right_answer = <<"6"/utf8>>,answer1 = <<"6"/utf8>>,answer2 = <<"7"/utf8>>,answer3 = <<"8"/utf8>>,answer4 = <<"9"/utf8>>};

get_question_cfg(1056) ->
	#gfeast_question_cfg{id = 1056,weight = 100,topic_type = 1,question = <<"不识(?)真面目，只缘身在此山中"/utf8>>,right = 1,right_answer = <<"庐山"/utf8>>,answer1 = <<"庐山"/utf8>>,answer2 = <<"泰山"/utf8>>,answer3 = <<"华山"/utf8>>,answer4 = <<"衡山"/utf8>>};

get_question_cfg(1057) ->
	#gfeast_question_cfg{id = 1057,weight = 100,topic_type = 1,question = <<"草书、行书、楷书、隶书四种字体当中哪一种是其余三种的起源?"/utf8>>,right = 1,right_answer = <<"隶书"/utf8>>,answer1 = <<"隶书"/utf8>>,answer2 = <<"草书"/utf8>>,answer3 = <<"行书"/utf8>>,answer4 = <<"楷书"/utf8>>};

get_question_cfg(1058) ->
	#gfeast_question_cfg{id = 1058,weight = 100,topic_type = 1,question = <<"朝鲜的首都是?"/utf8>>,right = 1,right_answer = <<"平壤"/utf8>>,answer1 = <<"平壤"/utf8>>,answer2 = <<"开城"/utf8>>,answer3 = <<"罗先"/utf8>>,answer4 = <<"咸兴"/utf8>>};

get_question_cfg(1059) ->
	#gfeast_question_cfg{id = 1059,weight = 100,topic_type = 1,question = <<"成名于超级星光大道，有《王妃》、《新不了情》等代表舞曲的台湾男歌手是谁?"/utf8>>,right = 1,right_answer = <<"萧敬腾"/utf8>>,answer1 = <<"萧敬腾"/utf8>>,answer2 = <<"林宥嘉"/utf8>>,answer3 = <<"潘裕文"/utf8>>,answer4 = <<"黄靖伦"/utf8>>};

get_question_cfg(1060) ->
	#gfeast_question_cfg{id = 1060,weight = 100,topic_type = 1,question = <<"成语“(?)驹过隙”比喻时光飞逝"/utf8>>,right = 1,right_answer = <<"白"/utf8>>,answer1 = <<"白"/utf8>>,answer2 = <<"黑"/utf8>>,answer3 = <<"棕"/utf8>>,answer4 = <<"灰"/utf8>>};

get_question_cfg(1061) ->
	#gfeast_question_cfg{id = 1061,weight = 100,topic_type = 1,question = <<"成语“完璧归赵”中的壁的全称是什么?"/utf8>>,right = 1,right_answer = <<"和氏璧"/utf8>>,answer1 = <<"和氏璧"/utf8>>,answer2 = <<"赵氏璧"/utf8>>,answer3 = <<"李氏璧"/utf8>>,answer4 = <<"孙氏璧"/utf8>>};

get_question_cfg(1062) ->
	#gfeast_question_cfg{id = 1062,weight = 100,topic_type = 1,question = <<"成语典故背水一战与哪位历史名人有关?"/utf8>>,right = 1,right_answer = <<"韩信"/utf8>>,answer1 = <<"韩信"/utf8>>,answer2 = <<"萧何"/utf8>>,answer3 = <<"项羽"/utf8>>,answer4 = <<"刘邦"/utf8>>};

get_question_cfg(1063) ->
	#gfeast_question_cfg{id = 1063,weight = 100,topic_type = 1,question = <<"成语典故破釜沉舟与哪位历史名人有关?"/utf8>>,right = 1,right_answer = <<"项羽"/utf8>>,answer1 = <<"项羽"/utf8>>,answer2 = <<"萧何"/utf8>>,answer3 = <<"韩信"/utf8>>,answer4 = <<"刘邦"/utf8>>};

get_question_cfg(1064) ->
	#gfeast_question_cfg{id = 1064,weight = 100,topic_type = 1,question = <<"川是我国哪里的简称?"/utf8>>,right = 1,right_answer = <<"四川"/utf8>>,answer1 = <<"四川"/utf8>>,answer2 = <<"重庆"/utf8>>,answer3 = <<"湖南"/utf8>>,answer4 = <<"湖北"/utf8>>};

get_question_cfg(1065) ->
	#gfeast_question_cfg{id = 1065,weight = 100,topic_type = 1,question = <<"德雷克海峡是南美洲与(?)的分界线"/utf8>>,right = 1,right_answer = <<"南极洲"/utf8>>,answer1 = <<"南极洲"/utf8>>,answer2 = <<"欧洲"/utf8>>,answer3 = <<"亚洲"/utf8>>,answer4 = <<"大洋洲"/utf8>>};

get_question_cfg(1066) ->
	#gfeast_question_cfg{id = 1066,weight = 100,topic_type = 1,question = <<"电影《变形金刚》中，与擎天柱作对的反派首领叫什么?"/utf8>>,right = 1,right_answer = <<"威震天"/utf8>>,answer1 = <<"威震天"/utf8>>,answer2 = <<"震荡波"/utf8>>,answer3 = <<"红蜘蛛"/utf8>>,answer4 = <<"路障"/utf8>>};

get_question_cfg(1067) ->
	#gfeast_question_cfg{id = 1067,weight = 100,topic_type = 1,question = <<"东北最出名的传统曲艺是?"/utf8>>,right = 1,right_answer = <<"二人转"/utf8>>,answer1 = <<"二人转"/utf8>>,answer2 = <<"花鼓戏"/utf8>>,answer3 = <<"快书"/utf8>>,answer4 = <<"琴书"/utf8>>};

get_question_cfg(1068) ->
	#gfeast_question_cfg{id = 1068,weight = 100,topic_type = 1,question = <<"冬季路面上容易结冰，我们一般会在路面上洒什么调味品?"/utf8>>,right = 1,right_answer = <<"盐"/utf8>>,answer1 = <<"盐"/utf8>>,answer2 = <<"油"/utf8>>,answer3 = <<"酱"/utf8>>,answer4 = <<"醋"/utf8>>};

get_question_cfg(1069) ->
	#gfeast_question_cfg{id = 1069,weight = 100,topic_type = 1,question = <<"动画片《喜羊羊与灰太狼》中，羊村最健壮最鲁莽的一只羊叫什么?"/utf8>>,right = 1,right_answer = <<"沸羊羊"/utf8>>,answer1 = <<"沸羊羊"/utf8>>,answer2 = <<"喜羊羊"/utf8>>,answer3 = <<"美羊羊"/utf8>>,answer4 = <<"懒羊羊"/utf8>>};

get_question_cfg(1070) ->
	#gfeast_question_cfg{id = 1070,weight = 100,topic_type = 1,question = <<"俄罗斯的首都是?"/utf8>>,right = 1,right_answer = <<"莫斯科"/utf8>>,answer1 = <<"莫斯科"/utf8>>,answer2 = <<"圣彼得堡"/utf8>>,answer3 = <<"罗斯托夫"/utf8>>,answer4 = <<"乌兰乌德"/utf8>>};

get_question_cfg(1071) ->
	#gfeast_question_cfg{id = 1071,weight = 100,topic_type = 1,question = <<"烽火连三月，(?)抵万金"/utf8>>,right = 1,right_answer = <<"家书"/utf8>>,answer1 = <<"家书"/utf8>>,answer2 = <<"情书"/utf8>>,answer3 = <<"休书"/utf8>>,answer4 = <<"禁书"/utf8>>};

get_question_cfg(1072) ->
	#gfeast_question_cfg{id = 1072,weight = 100,topic_type = 1,question = <<"芙蓉花是(?)市的市花"/utf8>>,right = 1,right_answer = <<"成都"/utf8>>,answer1 = <<"成都"/utf8>>,answer2 = <<"长沙"/utf8>>,answer3 = <<"武汉"/utf8>>,answer4 = <<"广州"/utf8>>};

get_question_cfg(1073) ->
	#gfeast_question_cfg{id = 1073,weight = 100,topic_type = 1,question = <<"甘是我国哪里的简称?"/utf8>>,right = 1,right_answer = <<"甘肃"/utf8>>,answer1 = <<"甘肃"/utf8>>,answer2 = <<"青海"/utf8>>,answer3 = <<"新疆"/utf8>>,answer4 = <<"山西"/utf8>>};

get_question_cfg(1074) ->
	#gfeast_question_cfg{id = 1074,weight = 100,topic_type = 1,question = <<"古代男子二十岁被称为?"/utf8>>,right = 1,right_answer = <<"弱冠"/utf8>>,answer1 = <<"弱冠"/utf8>>,answer2 = <<"而立"/utf8>>,answer3 = <<"不惑"/utf8>>,answer4 = <<"知天命"/utf8>>};

get_question_cfg(1075) ->
	#gfeast_question_cfg{id = 1075,weight = 100,topic_type = 1,question = <<"古代战争中指挥军队进攻时要敲击(?)"/utf8>>,right = 1,right_answer = <<"鼓"/utf8>>,answer1 = <<"鼓"/utf8>>,answer2 = <<"锣"/utf8>>,answer3 = <<"碗"/utf8>>,answer4 = <<"钟"/utf8>>};

get_question_cfg(1076) ->
	#gfeast_question_cfg{id = 1076,weight = 100,topic_type = 1,question = <<"古语“近(?)者赤”"/utf8>>,right = 1,right_answer = <<"朱"/utf8>>,answer1 = <<"朱"/utf8>>,answer2 = <<"玉"/utf8>>,answer3 = <<"漆"/utf8>>,answer4 = <<"水"/utf8>>};

get_question_cfg(1077) ->
	#gfeast_question_cfg{id = 1077,weight = 100,topic_type = 1,question = <<"古筝和古琴哪一个的弦更多?"/utf8>>,right = 1,right_answer = <<"古琴"/utf8>>,answer1 = <<"古琴"/utf8>>,answer2 = <<"古筝"/utf8>>,answer3 = <<"一样"/utf8>>,answer4 = <<"不知道"/utf8>>};

get_question_cfg(1078) ->
	#gfeast_question_cfg{id = 1078,weight = 100,topic_type = 1,question = <<"谷氨酸钠在生活中俗称什么?"/utf8>>,right = 1,right_answer = <<"味精"/utf8>>,answer1 = <<"味精"/utf8>>,answer2 = <<"食盐"/utf8>>,answer3 = <<"酱油"/utf8>>,answer4 = <<"陈醋"/utf8>>};

get_question_cfg(1079) ->
	#gfeast_question_cfg{id = 1079,weight = 100,topic_type = 1,question = <<"挂香包、插艾蒿、喝雄黄酒是哪个传统节日的习俗?"/utf8>>,right = 1,right_answer = <<"端午"/utf8>>,answer1 = <<"端午"/utf8>>,answer2 = <<"中秋"/utf8>>,answer3 = <<"晴明"/utf8>>,answer4 = <<"重阳"/utf8>>};

get_question_cfg(1080) ->
	#gfeast_question_cfg{id = 1080,weight = 100,topic_type = 1,question = <<"贯通河北和河南的河是哪条河?"/utf8>>,right = 1,right_answer = <<"黄河"/utf8>>,answer1 = <<"黄河"/utf8>>,answer2 = <<"长江"/utf8>>,answer3 = <<"淮河"/utf8>>,answer4 = <<"海河"/utf8>>};

get_question_cfg(1081) ->
	#gfeast_question_cfg{id = 1081,weight = 100,topic_type = 1,question = <<"广州根据“五羊”的传说而有(?)之名。"/utf8>>,right = 1,right_answer = <<"羊城"/utf8>>,answer1 = <<"羊城"/utf8>>,answer2 = <<"咩城"/utf8>>,answer3 = <<"洋城"/utf8>>,answer4 = <<"五城"/utf8>>};

get_question_cfg(1082) ->
	#gfeast_question_cfg{id = 1082,weight = 100,topic_type = 1,question = <<"国产动画片《宝莲灯》当中“二郎神”是主人公“沉香”的："/utf8>>,right = 1,right_answer = <<"舅舅"/utf8>>,answer1 = <<"舅舅"/utf8>>,answer2 = <<"哥哥"/utf8>>,answer3 = <<"爸爸"/utf8>>,answer4 = <<"爷爷"/utf8>>};

get_question_cfg(1083) ->
	#gfeast_question_cfg{id = 1083,weight = 100,topic_type = 1,question = <<"荷兰的首都是?"/utf8>>,right = 1,right_answer = <<"阿姆斯特丹"/utf8>>,answer1 = <<"阿姆斯特丹"/utf8>>,answer2 = <<"鹿特丹"/utf8>>,answer3 = <<"海牙"/utf8>>,answer4 = <<"乌得勒支"/utf8>>};

get_question_cfg(1084) ->
	#gfeast_question_cfg{id = 1084,weight = 100,topic_type = 1,question = <<"湖南湖北的“湖”是指"/utf8>>,right = 1,right_answer = <<"洞庭湖"/utf8>>,answer1 = <<"洞庭湖"/utf8>>,answer2 = <<"鄱阳湖"/utf8>>,answer3 = <<"太湖"/utf8>>,answer4 = <<"青海湖"/utf8>>};

get_question_cfg(1085) ->
	#gfeast_question_cfg{id = 1085,weight = 100,topic_type = 1,question = <<"虎门销烟显示了中国人民禁烟斗争的伟大胜利，领导这场斗争的是?"/utf8>>,right = 1,right_answer = <<"林则徐"/utf8>>,answer1 = <<"林则徐"/utf8>>,answer2 = <<"曾国藩"/utf8>>,answer3 = <<"左宗棠"/utf8>>,answer4 = <<"李鸿章"/utf8>>};

get_question_cfg(1086) ->
	#gfeast_question_cfg{id = 1086,weight = 100,topic_type = 1,question = <<"沪是我国哪里的简称?"/utf8>>,right = 1,right_answer = <<"上海"/utf8>>,answer1 = <<"上海"/utf8>>,answer2 = <<"吉林"/utf8>>,answer3 = <<"河北"/utf8>>,answer4 = <<"天津"/utf8>>};

get_question_cfg(1087) ->
	#gfeast_question_cfg{id = 1087,weight = 100,topic_type = 1,question = <<"吉是我国哪里的简称?"/utf8>>,right = 1,right_answer = <<"吉林"/utf8>>,answer1 = <<"吉林"/utf8>>,answer2 = <<"天津"/utf8>>,answer3 = <<"山西"/utf8>>,answer4 = <<"北京"/utf8>>};

get_question_cfg(1088) ->
	#gfeast_question_cfg{id = 1088,weight = 100,topic_type = 1,question = <<"既是法国最大的王宫建筑，又是世界上最著名的艺术殿堂的是"/utf8>>,right = 1,right_answer = <<"卢浮宫"/utf8>>,answer1 = <<"卢浮宫"/utf8>>,answer2 = <<"大英博物馆"/utf8>>,answer3 = <<"艾尔博物馆"/utf8>>,answer4 = <<"大都会博物馆"/utf8>>};

get_question_cfg(1089) ->
	#gfeast_question_cfg{id = 1089,weight = 100,topic_type = 1,question = <<"冀是我国哪里的简称?"/utf8>>,right = 1,right_answer = <<"河北"/utf8>>,answer1 = <<"河北"/utf8>>,answer2 = <<"天津"/utf8>>,answer3 = <<"北京"/utf8>>,answer4 = <<"山西"/utf8>>};

get_question_cfg(1090) ->
	#gfeast_question_cfg{id = 1090,weight = 100,topic_type = 1,question = <<"柬埔寨的首都是?"/utf8>>,right = 1,right_answer = <<"金边"/utf8>>,answer1 = <<"金边"/utf8>>,answer2 = <<"拜林"/utf8>>,answer3 = <<"西哈努克"/utf8>>,answer4 = <<"白马"/utf8>>};

get_question_cfg(1091) ->
	#gfeast_question_cfg{id = 1091,weight = 100,topic_type = 1,question = <<"讲究“以柔克刚，以静制动，以弱胜强“的传统拳法是?"/utf8>>,right = 1,right_answer = <<"太极拳"/utf8>>,answer1 = <<"太极拳"/utf8>>,answer2 = <<"通背拳"/utf8>>,answer3 = <<"地功拳"/utf8>>,answer4 = <<"八仙拳"/utf8>>};

get_question_cfg(1092) ->
	#gfeast_question_cfg{id = 1092,weight = 100,topic_type = 1,question = <<"今天的吐鲁番盆地在《西游记》中可能是(?)"/utf8>>,right = 1,right_answer = <<"火焰山"/utf8>>,answer1 = <<"火焰山"/utf8>>,answer2 = <<"花果山"/utf8>>,answer3 = <<"黑风山"/utf8>>,answer4 = <<"万寿山"/utf8>>};

get_question_cfg(1093) ->
	#gfeast_question_cfg{id = 1093,weight = 100,topic_type = 1,question = <<"金屋藏娇的故事与哪一位皇帝有关?"/utf8>>,right = 1,right_answer = <<"汉武帝"/utf8>>,answer1 = <<"汉武帝"/utf8>>,answer2 = <<"汉文帝"/utf8>>,answer3 = <<"汉景帝"/utf8>>,answer4 = <<"汉高祖"/utf8>>};

get_question_cfg(1094) ->
	#gfeast_question_cfg{id = 1094,weight = 100,topic_type = 1,question = <<"津是我国哪里的简称?"/utf8>>,right = 1,right_answer = <<"天津"/utf8>>,answer1 = <<"天津"/utf8>>,answer2 = <<"上海"/utf8>>,answer3 = <<"山西"/utf8>>,answer4 = <<"河北"/utf8>>};

get_question_cfg(1095) ->
	#gfeast_question_cfg{id = 1095,weight = 100,topic_type = 1,question = <<"晋是我国哪里的简称?"/utf8>>,right = 1,right_answer = <<"山西"/utf8>>,answer1 = <<"山西"/utf8>>,answer2 = <<"天津"/utf8>>,answer3 = <<"上海"/utf8>>,answer4 = <<"北京"/utf8>>};

get_question_cfg(1096) ->
	#gfeast_question_cfg{id = 1096,weight = 100,topic_type = 1,question = <<"京是我国哪里的简称?"/utf8>>,right = 1,right_answer = <<"北京"/utf8>>,answer1 = <<"北京"/utf8>>,answer2 = <<"山西"/utf8>>,answer3 = <<"天津"/utf8>>,answer4 = <<"上海"/utf8>>};

get_question_cfg(1097) ->
	#gfeast_question_cfg{id = 1097,weight = 100,topic_type = 1,question = <<"经典故事集《一千零一夜》又名(?)"/utf8>>,right = 1,right_answer = <<"天方夜谭"/utf8>>,answer1 = <<"天方夜谭"/utf8>>,answer2 = <<"格林童话"/utf8>>,answer3 = <<"安徒生童话"/utf8>>,answer4 = <<"床边故事"/utf8>>};

get_question_cfg(1098) ->
	#gfeast_question_cfg{id = 1098,weight = 100,topic_type = 1,question = <<"距离地球最近的恒星是?"/utf8>>,right = 1,right_answer = <<"太阳"/utf8>>,answer1 = <<"太阳"/utf8>>,answer2 = <<"月亮"/utf8>>,answer3 = <<"土星"/utf8>>,answer4 = <<"木星"/utf8>>};

get_question_cfg(1099) ->
	#gfeast_question_cfg{id = 1099,weight = 100,topic_type = 1,question = <<"篮球比赛中，每队应派几位选手上场参加比赛?"/utf8>>,right = 1,right_answer = <<"5"/utf8>>,answer1 = <<"5"/utf8>>,answer2 = <<"6"/utf8>>,answer3 = <<"7"/utf8>>,answer4 = <<"8"/utf8>>};

get_question_cfg(1100) ->
	#gfeast_question_cfg{id = 1100,weight = 100,topic_type = 1,question = <<"两个黄鹂鸣翠柳，一行(?)上青天"/utf8>>,right = 1,right_answer = <<"白鹭"/utf8>>,answer1 = <<"白鹭"/utf8>>,answer2 = <<"黄鹤"/utf8>>,answer3 = <<"鹦鹉"/utf8>>,answer4 = <<"鸳鸯"/utf8>>};

get_question_cfg(1101) ->
	#gfeast_question_cfg{id = 1101,weight = 100,topic_type = 1,question = <<"辽是我国哪里的简称?"/utf8>>,right = 1,right_answer = <<"辽宁"/utf8>>,answer1 = <<"辽宁"/utf8>>,answer2 = <<"天津"/utf8>>,answer3 = <<"河北"/utf8>>,answer4 = <<"山西"/utf8>>};

get_question_cfg(1102) ->
	#gfeast_question_cfg{id = 1102,weight = 100,topic_type = 1,question = <<"六弦琴是什么乐器的别称?"/utf8>>,right = 1,right_answer = <<"吉他"/utf8>>,answer1 = <<"吉他"/utf8>>,answer2 = <<"古琴"/utf8>>,answer3 = <<"琵琶"/utf8>>,answer4 = <<"二胡"/utf8>>};

get_question_cfg(1103) ->
	#gfeast_question_cfg{id = 1103,weight = 100,topic_type = 1,question = <<"卢森堡的首都是?"/utf8>>,right = 1,right_answer = <<"卢森堡"/utf8>>,answer1 = <<"卢森堡"/utf8>>,answer2 = <<"迪基希"/utf8>>,answer3 = <<"格雷文马赫"/utf8>>,answer4 = <<"雷米希"/utf8>>};

get_question_cfg(1104) ->
	#gfeast_question_cfg{id = 1104,weight = 100,topic_type = 1,question = <<"马来西亚的首都是?"/utf8>>,right = 1,right_answer = <<"吉隆坡"/utf8>>,answer1 = <<"吉隆坡"/utf8>>,answer2 = <<"纳闽"/utf8>>,answer3 = <<"布特拉再也"/utf8>>,answer4 = <<"马六甲"/utf8>>};

get_question_cfg(1105) ->
	#gfeast_question_cfg{id = 1105,weight = 100,topic_type = 1,question = <<"馒头是谁发明的?"/utf8>>,right = 1,right_answer = <<"诸葛亮"/utf8>>,answer1 = <<"诸葛亮"/utf8>>,answer2 = <<"张良"/utf8>>,answer3 = <<"刘伯温"/utf8>>,answer4 = <<"姜子牙"/utf8>>};

get_question_cfg(1106) ->
	#gfeast_question_cfg{id = 1106,weight = 100,topic_type = 1,question = <<"明朝永乐年间，从西洋归来的郑和船队带回了一只西方异域兽“麒麟“，就是现在我们所知的"/utf8>>,right = 2,right_answer = <<"长颈鹿"/utf8>>,answer1 = <<"狮子"/utf8>>,answer2 = <<"长颈鹿"/utf8>>,answer3 = <<"老虎"/utf8>>,answer4 = <<"猎豹"/utf8>>};

get_question_cfg(1107) ->
	#gfeast_question_cfg{id = 1107,weight = 100,topic_type = 1,question = <<"莫斯科市最大规模的交通系统是?"/utf8>>,right = 2,right_answer = <<"地铁"/utf8>>,answer1 = <<"电车"/utf8>>,answer2 = <<"地铁"/utf8>>,answer3 = <<"出租车"/utf8>>,answer4 = <<"轻轨"/utf8>>};

get_question_cfg(1108) ->
	#gfeast_question_cfg{id = 1108,weight = 100,topic_type = 1,question = <<"哪种水果视力最差?"/utf8>>,right = 2,right_answer = <<"芒果"/utf8>>,answer1 = <<"火龙果"/utf8>>,answer2 = <<"芒果"/utf8>>,answer3 = <<"苹果"/utf8>>,answer4 = <<"百香果"/utf8>>};

get_question_cfg(1109) ->
	#gfeast_question_cfg{id = 1109,weight = 100,topic_type = 1,question = <<"你爸爸和你妈妈生了个儿子，他既不是你哥哥又不是你弟弟，他是谁?"/utf8>>,right = 2,right_answer = <<"自己"/utf8>>,answer1 = <<"捡来的"/utf8>>,answer2 = <<"自己"/utf8>>,answer3 = <<"哥哥"/utf8>>,answer4 = <<"弟弟"/utf8>>};

get_question_cfg(1110) ->
	#gfeast_question_cfg{id = 1110,weight = 100,topic_type = 1,question = <<"鸟类中最小的是"/utf8>>,right = 2,right_answer = <<"蜂鸟"/utf8>>,answer1 = <<"鸵鸟"/utf8>>,answer2 = <<"蜂鸟"/utf8>>,answer3 = <<"杜鹃"/utf8>>,answer4 = <<"乌鸦"/utf8>>};

get_question_cfg(1111) ->
	#gfeast_question_cfg{id = 1111,weight = 100,topic_type = 1,question = <<"拍电影时常用的(?)来表示拍摄完成"/utf8>>,right = 2,right_answer = <<"杀青"/utf8>>,answer1 = <<"领盒饭"/utf8>>,answer2 = <<"杀青"/utf8>>,answer3 = <<"跑腿"/utf8>>,answer4 = <<"收官"/utf8>>};

get_question_cfg(1112) ->
	#gfeast_question_cfg{id = 1112,weight = 100,topic_type = 1,question = <<"普洱茶的产地在哪?"/utf8>>,right = 2,right_answer = <<"云南"/utf8>>,answer1 = <<"广西"/utf8>>,answer2 = <<"云南"/utf8>>,answer3 = <<"新疆"/utf8>>,answer4 = <<"西藏"/utf8>>};

get_question_cfg(1113) ->
	#gfeast_question_cfg{id = 1113,weight = 100,topic_type = 1,question = <<"恰似一江春水向东流的上一句是?"/utf8>>,right = 2,right_answer = <<"问君能有几多愁"/utf8>>,answer1 = <<"问君何事白满头"/utf8>>,answer2 = <<"问君能有几多愁"/utf8>>,answer3 = <<"借酒浇愁愁更愁"/utf8>>,answer4 = <<"为何天天不洗头"/utf8>>};

get_question_cfg(1114) ->
	#gfeast_question_cfg{id = 1114,weight = 100,topic_type = 1,question = <<"秦时(?)汉时关，万里长征人未还"/utf8>>,right = 2,right_answer = <<"明月"/utf8>>,answer1 = <<"新月"/utf8>>,answer2 = <<"明月"/utf8>>,answer3 = <<"满月"/utf8>>,answer4 = <<"皓月"/utf8>>};

get_question_cfg(1115) ->
	#gfeast_question_cfg{id = 1115,weight = 100,topic_type = 1,question = <<"琼是我国哪里的简称?"/utf8>>,right = 2,right_answer = <<"海南"/utf8>>,answer1 = <<"辽宁"/utf8>>,answer2 = <<"海南"/utf8>>,answer3 = <<"山西"/utf8>>,answer4 = <<"河北"/utf8>>};

get_question_cfg(1116) ->
	#gfeast_question_cfg{id = 1116,weight = 100,topic_type = 1,question = <<"热气球，可以载着人升上天空，请问热气球是哪个国家人发明的?"/utf8>>,right = 2,right_answer = <<"法国"/utf8>>,answer1 = <<"英国"/utf8>>,answer2 = <<"法国"/utf8>>,answer3 = <<"美国"/utf8>>,answer4 = <<"德国"/utf8>>};

get_question_cfg(1117) ->
	#gfeast_question_cfg{id = 1117,weight = 100,topic_type = 1,question = <<"人类最早使用的工具，是什么材料的?"/utf8>>,right = 2,right_answer = <<"石头"/utf8>>,answer1 = <<"木头"/utf8>>,answer2 = <<"石头"/utf8>>,answer3 = <<"草根"/utf8>>,answer4 = <<"泥土"/utf8>>};

get_question_cfg(1118) ->
	#gfeast_question_cfg{id = 1118,weight = 100,topic_type = 1,question = <<"人脑中控制人平衡力的是"/utf8>>,right = 2,right_answer = <<"小脑"/utf8>>,answer1 = <<"大脑"/utf8>>,answer2 = <<"小脑"/utf8>>,answer3 = <<"脑干"/utf8>>,answer4 = <<"脑叶"/utf8>>};

get_question_cfg(1119) ->
	#gfeast_question_cfg{id = 1119,weight = 100,topic_type = 1,question = <<"人体最坚硬的部分是?"/utf8>>,right = 2,right_answer = <<"牙齿"/utf8>>,answer1 = <<"脑袋"/utf8>>,answer2 = <<"牙齿"/utf8>>,answer3 = <<"脚趾"/utf8>>,answer4 = <<"屁股"/utf8>>};

get_question_cfg(1120) ->
	#gfeast_question_cfg{id = 1120,weight = 100,topic_type = 1,question = <<"日本的首都是?"/utf8>>,right = 2,right_answer = <<"东京"/utf8>>,answer1 = <<"大阪"/utf8>>,answer2 = <<"东京"/utf8>>,answer3 = <<"横滨"/utf8>>,answer4 = <<"神户"/utf8>>};

get_question_cfg(1121) ->
	#gfeast_question_cfg{id = 1121,weight = 100,topic_type = 1,question = <<"山重水复疑无路，柳暗花明又一村是谁的诗句?"/utf8>>,right = 2,right_answer = <<"陆游"/utf8>>,answer1 = <<"苏轼"/utf8>>,answer2 = <<"陆游"/utf8>>,answer3 = <<"辛弃疾"/utf8>>,answer4 = <<"王安石"/utf8>>};

get_question_cfg(1122) ->
	#gfeast_question_cfg{id = 1122,weight = 100,topic_type = 1,question = <<"陕西省一块著名的“无字碑“，它与哪位皇帝有关?"/utf8>>,right = 2,right_answer = <<"武则天"/utf8>>,answer1 = <<"秦始皇"/utf8>>,answer2 = <<"武则天"/utf8>>,answer3 = <<"唐太宗"/utf8>>,answer4 = <<"乾隆"/utf8>>};

get_question_cfg(1123) ->
	#gfeast_question_cfg{id = 1123,weight = 100,topic_type = 1,question = <<"少壮不(?)，老大徒伤悲"/utf8>>,right = 2,right_answer = <<"努力"/utf8>>,answer1 = <<"快乐"/utf8>>,answer2 = <<"努力"/utf8>>,answer3 = <<"读书"/utf8>>,answer4 = <<"恋爱"/utf8>>};

get_question_cfg(1124) ->
	#gfeast_question_cfg{id = 1124,weight = 100,topic_type = 1,question = <<"身无彩凤双飞翼，心有灵犀一点通是哪一个诗人的诗句"/utf8>>,right = 2,right_answer = <<"李商隐"/utf8>>,answer1 = <<"李白"/utf8>>,answer2 = <<"李商隐"/utf8>>,answer3 = <<"李贺"/utf8>>,answer4 = <<"李煜"/utf8>>};

get_question_cfg(1125) ->
	#gfeast_question_cfg{id = 1125,weight = 100,topic_type = 1,question = <<"什么动物的尾巴像把扇?"/utf8>>,right = 2,right_answer = <<"孔雀"/utf8>>,answer1 = <<"鸳鸯"/utf8>>,answer2 = <<"孔雀"/utf8>>,answer3 = <<"乌鸦"/utf8>>,answer4 = <<"凤凰"/utf8>>};

get_question_cfg(1126) ->
	#gfeast_question_cfg{id = 1126,weight = 100,topic_type = 1,question = <<"什么人始终不敢洗澡?"/utf8>>,right = 2,right_answer = <<"泥人"/utf8>>,answer1 = <<"草人"/utf8>>,answer2 = <<"泥人"/utf8>>,answer3 = <<"假人"/utf8>>,answer4 = <<"木人"/utf8>>};

get_question_cfg(1127) ->
	#gfeast_question_cfg{id = 1127,weight = 100,topic_type = 1,question = <<"十二时辰中的(?)时是指23点——1点"/utf8>>,right = 2,right_answer = <<"子"/utf8>>,answer1 = <<"亥"/utf8>>,answer2 = <<"子"/utf8>>,answer3 = <<"丑"/utf8>>,answer4 = <<"寅"/utf8>>};

get_question_cfg(1128) ->
	#gfeast_question_cfg{id = 1128,weight = 100,topic_type = 1,question = <<"世界第一高峰是我国的什么山峰?"/utf8>>,right = 2,right_answer = <<"珠穆朗玛峰"/utf8>>,answer1 = <<"乔戈里峰"/utf8>>,answer2 = <<"珠穆朗玛峰"/utf8>>,answer3 = <<"干城章嘉峰"/utf8>>,answer4 = <<"洛子峰"/utf8>>};

get_question_cfg(1129) ->
	#gfeast_question_cfg{id = 1129,weight = 100,topic_type = 1,question = <<"世界第一枚邮票出现在："/utf8>>,right = 2,right_answer = <<"英国"/utf8>>,answer1 = <<"美国"/utf8>>,answer2 = <<"英国"/utf8>>,answer3 = <<"法国"/utf8>>,answer4 = <<"德国"/utf8>>};

get_question_cfg(1130) ->
	#gfeast_question_cfg{id = 1130,weight = 100,topic_type = 1,question = <<"世界上冰最多的地区是(?)大陆。"/utf8>>,right = 2,right_answer = <<"南极"/utf8>>,answer1 = <<"非洲"/utf8>>,answer2 = <<"南极"/utf8>>,answer3 = <<"亚欧"/utf8>>,answer4 = <<"南美"/utf8>>};

get_question_cfg(1131) ->
	#gfeast_question_cfg{id = 1131,weight = 100,topic_type = 1,question = <<"世界上的“风车之国”是指"/utf8>>,right = 2,right_answer = <<"荷兰"/utf8>>,answer1 = <<"丹麦"/utf8>>,answer2 = <<"荷兰"/utf8>>,answer3 = <<"加拿大"/utf8>>,answer4 = <<"法国"/utf8>>};

get_question_cfg(1132) ->
	#gfeast_question_cfg{id = 1132,weight = 100,topic_type = 1,question = <<"世界上跨纬度最广，东西距离最大的大洲是?"/utf8>>,right = 2,right_answer = <<"亚洲"/utf8>>,answer1 = <<"非洲"/utf8>>,answer2 = <<"亚洲"/utf8>>,answer3 = <<"欧洲"/utf8>>,answer4 = <<"南美洲"/utf8>>};

get_question_cfg(1133) ->
	#gfeast_question_cfg{id = 1133,weight = 100,topic_type = 1,question = <<"世界上最大的岩石"/utf8>>,right = 2,right_answer = <<"艾尔斯石"/utf8>>,answer1 = <<"直布罗陀岩石"/utf8>>,answer2 = <<"艾尔斯石"/utf8>>,answer3 = <<"魔鬼塔"/utf8>>,answer4 = <<"祖玛岩"/utf8>>};

get_question_cfg(1134) ->
	#gfeast_question_cfg{id = 1134,weight = 100,topic_type = 1,question = <<"世界上最大的洲是?"/utf8>>,right = 2,right_answer = <<"亚洲"/utf8>>,answer1 = <<"非洲"/utf8>>,answer2 = <<"亚洲"/utf8>>,answer3 = <<"欧洲"/utf8>>,answer4 = <<"南美洲"/utf8>>};

get_question_cfg(1135) ->
	#gfeast_question_cfg{id = 1135,weight = 100,topic_type = 1,question = <<"世界上最早种植棉花的国家是："/utf8>>,right = 2,right_answer = <<"印度"/utf8>>,answer1 = <<"中国"/utf8>>,answer2 = <<"印度"/utf8>>,answer3 = <<"韩国"/utf8>>,answer4 = <<"日本"/utf8>>};

get_question_cfg(1136) ->
	#gfeast_question_cfg{id = 1136,weight = 100,topic_type = 1,question = <<"世界上最长的海峡"/utf8>>,right = 2,right_answer = <<"莫桑比克海峡"/utf8>>,answer1 = <<"白岭海峡"/utf8>>,answer2 = <<"莫桑比克海峡"/utf8>>,answer3 = <<"马六甲海峡"/utf8>>,answer4 = <<"直布罗陀海峡"/utf8>>};

get_question_cfg(1137) ->
	#gfeast_question_cfg{id = 1137,weight = 100,topic_type = 1,question = <<"世界上最长的山脉是"/utf8>>,right = 2,right_answer = <<"安第斯山"/utf8>>,answer1 = <<"落基山脉"/utf8>>,answer2 = <<"安第斯山"/utf8>>,answer3 = <<"大分水岭山脉"/utf8>>,answer4 = <<"天山山脉"/utf8>>};

get_question_cfg(1138) ->
	#gfeast_question_cfg{id = 1138,weight = 100,topic_type = 1,question = <<"世界一共有几个大州?"/utf8>>,right = 2,right_answer = <<"7"/utf8>>,answer1 = <<"6"/utf8>>,answer2 = <<"7"/utf8>>,answer3 = <<"8"/utf8>>,answer4 = <<"9"/utf8>>};

get_question_cfg(1139) ->
	#gfeast_question_cfg{id = 1139,weight = 100,topic_type = 1,question = <<"首开武举选拨人才的女皇帝是谁?"/utf8>>,right = 2,right_answer = <<"武则天"/utf8>>,answer1 = <<"殇帝元"/utf8>>,answer2 = <<"武则天"/utf8>>,answer3 = <<"陈硕真"/utf8>>,answer4 = <<"慈禧"/utf8>>};

get_question_cfg(1140) ->
	#gfeast_question_cfg{id = 1140,weight = 100,topic_type = 1,question = <<"书画作品中的“四君子”是指梅、兰、(?)、菊四种植物。"/utf8>>,right = 2,right_answer = <<"竹"/utf8>>,answer1 = <<"松"/utf8>>,answer2 = <<"竹"/utf8>>,answer3 = <<"莲"/utf8>>,answer4 = <<"山"/utf8>>};

get_question_cfg(1141) ->
	#gfeast_question_cfg{id = 1141,weight = 100,topic_type = 1,question = <<"谁发明了地动仪?"/utf8>>,right = 2,right_answer = <<"张衡"/utf8>>,answer1 = <<"蔡伦"/utf8>>,answer2 = <<"张衡"/utf8>>,answer3 = <<"郑和"/utf8>>,answer4 = <<"毕昇"/utf8>>};

get_question_cfg(1142) ->
	#gfeast_question_cfg{id = 1142,weight = 100,topic_type = 1,question = <<"谁发明了炸药?"/utf8>>,right = 2,right_answer = <<"诺贝尔"/utf8>>,answer1 = <<"鲁班"/utf8>>,answer2 = <<"诺贝尔"/utf8>>,answer3 = <<"爱迪生"/utf8>>,answer4 = <<"祖冲之"/utf8>>};

get_question_cfg(1143) ->
	#gfeast_question_cfg{id = 1143,weight = 100,topic_type = 1,question = <<"水蒸发后会变成什么?"/utf8>>,right = 2,right_answer = <<"水蒸气"/utf8>>,answer1 = <<"冰"/utf8>>,answer2 = <<"水蒸气"/utf8>>,answer3 = <<"空气"/utf8>>,answer4 = <<"水"/utf8>>};

get_question_cfg(1144) ->
	#gfeast_question_cfg{id = 1144,weight = 100,topic_type = 1,question = <<"苏轼在《念奴娇·赤壁怀古》中提到了“羽扇纶巾，谈笑间，樯橹灰飞烟灭”，“羽扇纶巾“形容的是下面哪位历史人物?"/utf8>>,right = 2,right_answer = <<"周瑜"/utf8>>,answer1 = <<"黄盖"/utf8>>,answer2 = <<"周瑜"/utf8>>,answer3 = <<"孙权"/utf8>>,answer4 = <<"刘备"/utf8>>};

get_question_cfg(1145) ->
	#gfeast_question_cfg{id = 1145,weight = 100,topic_type = 1,question = <<"俗称”四不象”的动物是"/utf8>>,right = 2,right_answer = <<"麋鹿"/utf8>>,answer1 = <<"麒麟"/utf8>>,answer2 = <<"麋鹿"/utf8>>,answer3 = <<"羊驼"/utf8>>,answer4 = <<"瑞兽"/utf8>>};

get_question_cfg(1146) ->
	#gfeast_question_cfg{id = 1146,weight = 100,topic_type = 1,question = <<"俗语说“化干戈为玉帛“，干戈都是兵器，其中(?)指的是防御武器"/utf8>>,right = 2,right_answer = <<"干"/utf8>>,answer1 = <<"玉"/utf8>>,answer2 = <<"干"/utf8>>,answer3 = <<"帛"/utf8>>,answer4 = <<"戈"/utf8>>};

get_question_cfg(1147) ->
	#gfeast_question_cfg{id = 1147,weight = 100,topic_type = 1,question = <<"俗语说“化干戈为玉帛“，干戈都是兵器，其中(?)指的是进攻武器"/utf8>>,right = 2,right_answer = <<"戈"/utf8>>,answer1 = <<"帛"/utf8>>,answer2 = <<"戈"/utf8>>,answer3 = <<"玉"/utf8>>,answer4 = <<"干"/utf8>>};

get_question_cfg(1148) ->
	#gfeast_question_cfg{id = 1148,weight = 100,topic_type = 1,question = <<"太平洋的中间是什么?"/utf8>>,right = 2,right_answer = <<"平"/utf8>>,answer1 = <<"鱼"/utf8>>,answer2 = <<"平"/utf8>>,answer3 = <<"虾"/utf8>>,answer4 = <<"龙"/utf8>>};

get_question_cfg(1149) ->
	#gfeast_question_cfg{id = 1149,weight = 100,topic_type = 1,question = <<"太阳系的八大行星为：水星、金星、地球、火星、木星、土星、海王星和什么?"/utf8>>,right = 2,right_answer = <<"天王星"/utf8>>,answer1 = <<"冥王星"/utf8>>,answer2 = <<"天王星"/utf8>>,answer3 = <<"月球"/utf8>>,answer4 = <<"卫星"/utf8>>};

get_question_cfg(1150) ->
	#gfeast_question_cfg{id = 1150,weight = 100,topic_type = 1,question = <<"坦克是哪个国家发明的?"/utf8>>,right = 2,right_answer = <<"英国"/utf8>>,answer1 = <<"美国"/utf8>>,answer2 = <<"英国"/utf8>>,answer3 = <<"法国"/utf8>>,answer4 = <<"德国"/utf8>>};

get_question_cfg(1151) ->
	#gfeast_question_cfg{id = 1151,weight = 100,topic_type = 1,question = <<"唐朝盛世“贞观之治”出现于哪位皇帝的执政时期?"/utf8>>,right = 2,right_answer = <<"李世民"/utf8>>,answer1 = <<"李渊"/utf8>>,answer2 = <<"李世民"/utf8>>,answer3 = <<"武则天"/utf8>>,answer4 = <<"李耳"/utf8>>};

get_question_cfg(1152) ->
	#gfeast_question_cfg{id = 1152,weight = 100,topic_type = 1,question = <<"皖是我国哪里的简称?"/utf8>>,right = 2,right_answer = <<"安徽"/utf8>>,answer1 = <<"河北"/utf8>>,answer2 = <<"安徽"/utf8>>,answer3 = <<"湖南"/utf8>>,answer4 = <<"甘肃"/utf8>>};

get_question_cfg(1153) ->
	#gfeast_question_cfg{id = 1153,weight = 100,topic_type = 1,question = <<"王羲之对一种动物十分偏爱，并从它的体态姿势上领悟到书法执笔运笔的道理，这是什么动物?"/utf8>>,right = 2,right_answer = <<"鹅"/utf8>>,answer1 = <<"鸡"/utf8>>,answer2 = <<"鹅"/utf8>>,answer3 = <<"鸭"/utf8>>,answer4 = <<"鸟"/utf8>>};

get_question_cfg(1154) ->
	#gfeast_question_cfg{id = 1154,weight = 100,topic_type = 1,question = <<"文学史上被称作“小李杜“的是杜牧和谁?"/utf8>>,right = 2,right_answer = <<"李商隐"/utf8>>,answer1 = <<"李白"/utf8>>,answer2 = <<"李商隐"/utf8>>,answer3 = <<"李贺"/utf8>>,answer4 = <<"李煜"/utf8>>};

get_question_cfg(1155) ->
	#gfeast_question_cfg{id = 1155,weight = 100,topic_type = 1,question = <<"问世间(?)为何物，直教生死相许“"/utf8>>,right = 2,right_answer = <<"情"/utf8>>,answer1 = <<"爱"/utf8>>,answer2 = <<"情"/utf8>>,answer3 = <<"恋"/utf8>>,answer4 = <<"钱"/utf8>>};

get_question_cfg(1156) ->
	#gfeast_question_cfg{id = 1156,weight = 100,topic_type = 1,question = <<"我国安徽省的省会城市是?"/utf8>>,right = 2,right_answer = <<"合肥"/utf8>>,answer1 = <<"芜湖"/utf8>>,answer2 = <<"合肥"/utf8>>,answer3 = <<"淮南"/utf8>>,answer4 = <<"淮北"/utf8>>};

get_question_cfg(1157) ->
	#gfeast_question_cfg{id = 1157,weight = 100,topic_type = 1,question = <<"我国被称为”不夜城”的城市是哪一座城市"/utf8>>,right = 2,right_answer = <<"漠河"/utf8>>,answer1 = <<"广州"/utf8>>,answer2 = <<"漠河"/utf8>>,answer3 = <<"上海"/utf8>>,answer4 = <<"深圳"/utf8>>};

get_question_cfg(1158) ->
	#gfeast_question_cfg{id = 1158,weight = 100,topic_type = 1,question = <<"我国传统表示次序的“天干”共有(?)个字?"/utf8>>,right = 2,right_answer = <<"10"/utf8>>,answer1 = <<"8"/utf8>>,answer2 = <<"10"/utf8>>,answer3 = <<"12"/utf8>>,answer4 = <<"16"/utf8>>};

get_question_cfg(1159) ->
	#gfeast_question_cfg{id = 1159,weight = 100,topic_type = 1,question = <<"我国大陆家庭电路的电压统一使用为多少伏"/utf8>>,right = 2,right_answer = <<"220"/utf8>>,answer1 = <<"180"/utf8>>,answer2 = <<"220"/utf8>>,answer3 = <<"260"/utf8>>,answer4 = <<"300"/utf8>>};

get_question_cfg(1160) ->
	#gfeast_question_cfg{id = 1160,weight = 100,topic_type = 1,question = <<"我国的“冰城”是指哪一城市?"/utf8>>,right = 2,right_answer = <<"哈尔滨"/utf8>>,answer1 = <<"昆明"/utf8>>,answer2 = <<"哈尔滨"/utf8>>,answer3 = <<"长春"/utf8>>,answer4 = <<"济南"/utf8>>};

get_question_cfg(1161) ->
	#gfeast_question_cfg{id = 1161,weight = 100,topic_type = 1,question = <<"我国的京剧脸谱色彩含义丰富，(?)色一般表示阴险奸诈"/utf8>>,right = 2,right_answer = <<"白"/utf8>>,answer1 = <<"黑"/utf8>>,answer2 = <<"白"/utf8>>,answer3 = <<"红"/utf8>>,answer4 = <<"蓝"/utf8>>};

get_question_cfg(1162) ->
	#gfeast_question_cfg{id = 1162,weight = 100,topic_type = 1,question = <<"我国第一部诗歌总集是?"/utf8>>,right = 2,right_answer = <<"诗经"/utf8>>,answer1 = <<"论语"/utf8>>,answer2 = <<"诗经"/utf8>>,answer3 = <<"春秋"/utf8>>,answer4 = <<"大学"/utf8>>};

get_question_cfg(1163) ->
	#gfeast_question_cfg{id = 1163,weight = 100,topic_type = 1,question = <<"我国甘肃省的省会城市是?"/utf8>>,right = 2,right_answer = <<"兰州"/utf8>>,answer1 = <<"北京"/utf8>>,answer2 = <<"兰州"/utf8>>,answer3 = <<"上海"/utf8>>,answer4 = <<"深圳"/utf8>>};

get_question_cfg(1164) ->
	#gfeast_question_cfg{id = 1164,weight = 100,topic_type = 1,question = <<"我国广东省的省会城市是?"/utf8>>,right = 2,right_answer = <<"广州"/utf8>>,answer1 = <<"深圳"/utf8>>,answer2 = <<"广州"/utf8>>,answer3 = <<"北京"/utf8>>,answer4 = <<"上海"/utf8>>};

get_question_cfg(1165) ->
	#gfeast_question_cfg{id = 1165,weight = 100,topic_type = 1,question = <<"我国贵州省的省会城市是?"/utf8>>,right = 2,right_answer = <<"贵阳"/utf8>>,answer1 = <<"上海"/utf8>>,answer2 = <<"贵阳"/utf8>>,answer3 = <<"深圳"/utf8>>,answer4 = <<"北京"/utf8>>};

get_question_cfg(1166) ->
	#gfeast_question_cfg{id = 1166,weight = 100,topic_type = 1,question = <<"我国黑龙江省的省会城市是?"/utf8>>,right = 2,right_answer = <<"哈尔滨"/utf8>>,answer1 = <<"北京"/utf8>>,answer2 = <<"哈尔滨"/utf8>>,answer3 = <<"上海"/utf8>>,answer4 = <<"深圳"/utf8>>};

get_question_cfg(1167) ->
	#gfeast_question_cfg{id = 1167,weight = 100,topic_type = 1,question = <<"我国吉林省的省会城市是?"/utf8>>,right = 2,right_answer = <<"长春"/utf8>>,answer1 = <<"深圳"/utf8>>,answer2 = <<"长春"/utf8>>,answer3 = <<"北京"/utf8>>,answer4 = <<"上海"/utf8>>};

get_question_cfg(1168) ->
	#gfeast_question_cfg{id = 1168,weight = 100,topic_type = 1,question = <<"我国江苏省的省会城市是?"/utf8>>,right = 2,right_answer = <<"南京"/utf8>>,answer1 = <<"上海"/utf8>>,answer2 = <<"南京"/utf8>>,answer3 = <<"深圳"/utf8>>,answer4 = <<"北京"/utf8>>};

get_question_cfg(1169) ->
	#gfeast_question_cfg{id = 1169,weight = 100,topic_type = 1,question = <<"我国江西省的省会城市是?"/utf8>>,right = 2,right_answer = <<"南昌"/utf8>>,answer1 = <<"北京"/utf8>>,answer2 = <<"南昌"/utf8>>,answer3 = <<"上海"/utf8>>,answer4 = <<"深圳"/utf8>>};

get_question_cfg(1170) ->
	#gfeast_question_cfg{id = 1170,weight = 100,topic_type = 1,question = <<"我国内蒙古自治区的省会城市是?"/utf8>>,right = 2,right_answer = <<"呼和浩特"/utf8>>,answer1 = <<"深圳"/utf8>>,answer2 = <<"呼和浩特"/utf8>>,answer3 = <<"北京"/utf8>>,answer4 = <<"上海"/utf8>>};

get_question_cfg(1171) ->
	#gfeast_question_cfg{id = 1171,weight = 100,topic_type = 1,question = <<"我国宁夏回族自治区的省会城市是?"/utf8>>,right = 2,right_answer = <<"银川"/utf8>>,answer1 = <<"上海"/utf8>>,answer2 = <<"银川"/utf8>>,answer3 = <<"深圳"/utf8>>,answer4 = <<"北京"/utf8>>};

get_question_cfg(1172) ->
	#gfeast_question_cfg{id = 1172,weight = 100,topic_type = 1,question = <<"我国山东省的省会城市是?"/utf8>>,right = 2,right_answer = <<"济南"/utf8>>,answer1 = <<"北京"/utf8>>,answer2 = <<"济南"/utf8>>,answer3 = <<"上海"/utf8>>,answer4 = <<"深圳"/utf8>>};

get_question_cfg(1173) ->
	#gfeast_question_cfg{id = 1173,weight = 100,topic_type = 1,question = <<"我国陕西省的省会城市是?"/utf8>>,right = 2,right_answer = <<"西安"/utf8>>,answer1 = <<"深圳"/utf8>>,answer2 = <<"西安"/utf8>>,answer3 = <<"北京"/utf8>>,answer4 = <<"上海"/utf8>>};

get_question_cfg(1174) ->
	#gfeast_question_cfg{id = 1174,weight = 100,topic_type = 1,question = <<"我国书法艺术博大精深，请问欧阳洵的字体被简称为(?)?"/utf8>>,right = 2,right_answer = <<"欧体"/utf8>>,answer1 = <<"上海"/utf8>>,answer2 = <<"欧体"/utf8>>,answer3 = <<"深圳"/utf8>>,answer4 = <<"北京"/utf8>>};

get_question_cfg(1175) ->
	#gfeast_question_cfg{id = 1175,weight = 100,topic_type = 1,question = <<"我国四川省的省会城市是?"/utf8>>,right = 2,right_answer = <<"成都"/utf8>>,answer1 = <<"北京"/utf8>>,answer2 = <<"成都"/utf8>>,answer3 = <<"上海"/utf8>>,answer4 = <<"深圳"/utf8>>};

get_question_cfg(1176) ->
	#gfeast_question_cfg{id = 1176,weight = 100,topic_type = 1,question = <<"我国台湾省的省会城市是?"/utf8>>,right = 2,right_answer = <<"台北"/utf8>>,answer1 = <<"深圳"/utf8>>,answer2 = <<"台北"/utf8>>,answer3 = <<"北京"/utf8>>,answer4 = <<"上海"/utf8>>};

get_question_cfg(1177) ->
	#gfeast_question_cfg{id = 1177,weight = 100,topic_type = 1,question = <<"我国新疆维吾尔自治区的省会城市是?"/utf8>>,right = 2,right_answer = <<"乌鲁木齐"/utf8>>,answer1 = <<"上海"/utf8>>,answer2 = <<"乌鲁木齐"/utf8>>,answer3 = <<"深圳"/utf8>>,answer4 = <<"北京"/utf8>>};

get_question_cfg(1178) ->
	#gfeast_question_cfg{id = 1178,weight = 100,topic_type = 1,question = <<"我国云南省的省会城市是?"/utf8>>,right = 2,right_answer = <<"昆明"/utf8>>,answer1 = <<"北京"/utf8>>,answer2 = <<"昆明"/utf8>>,answer3 = <<"上海"/utf8>>,answer4 = <<"深圳"/utf8>>};

get_question_cfg(1179) ->
	#gfeast_question_cfg{id = 1179,weight = 100,topic_type = 1,question = <<"我国著名的六朝古都是"/utf8>>,right = 2,right_answer = <<"南京"/utf8>>,answer1 = <<"深圳"/utf8>>,answer2 = <<"南京"/utf8>>,answer3 = <<"北京"/utf8>>,answer4 = <<"上海"/utf8>>};

get_question_cfg(1180) ->
	#gfeast_question_cfg{id = 1180,weight = 100,topic_type = 1,question = <<"我国著名的赵州桥建于哪个朝代?"/utf8>>,right = 2,right_answer = <<"隋"/utf8>>,answer1 = <<"南北朝"/utf8>>,answer2 = <<"隋"/utf8>>,answer3 = <<"唐"/utf8>>,answer4 = <<"宋"/utf8>>};

get_question_cfg(1181) ->
	#gfeast_question_cfg{id = 1181,weight = 100,topic_type = 1,question = <<"我们通常所说的“五官”是不包括？"/utf8>>,right = 2,right_answer = <<"皮肤"/utf8>>,answer1 = <<"口舌"/utf8>>,answer2 = <<"皮肤"/utf8>>,answer3 = <<"耳鼻"/utf8>>,answer4 = <<"眼睛"/utf8>>};

get_question_cfg(1182) ->
	#gfeast_question_cfg{id = 1182,weight = 100,topic_type = 1,question = <<"舞曲中的“圆舞曲”也叫作(?)"/utf8>>,right = 2,right_answer = <<"华尔兹"/utf8>>,answer1 = <<"拉丁舞"/utf8>>,answer2 = <<"华尔兹"/utf8>>,answer3 = <<"爵士舞"/utf8>>,answer4 = <<"芭蕾舞"/utf8>>};

get_question_cfg(1183) ->
	#gfeast_question_cfg{id = 1183,weight = 100,topic_type = 1,question = <<"西出阳关无故人中的”阳关”在现在的哪个省(区)"/utf8>>,right = 2,right_answer = <<"甘肃"/utf8>>,answer1 = <<"宁夏"/utf8>>,answer2 = <<"甘肃"/utf8>>,answer3 = <<"河北"/utf8>>,answer4 = <<"内蒙古"/utf8>>};

get_question_cfg(1184) ->
	#gfeast_question_cfg{id = 1184,weight = 100,topic_type = 1,question = <<"西印度群岛位于哪个大洋?"/utf8>>,right = 2,right_answer = <<"大西洋"/utf8>>,answer1 = <<"太平洋"/utf8>>,answer2 = <<"大西洋"/utf8>>,answer3 = <<"北冰洋"/utf8>>,answer4 = <<"印度洋"/utf8>>};

get_question_cfg(1185) ->
	#gfeast_question_cfg{id = 1185,weight = 100,topic_type = 1,question = <<"希腊的首都是?"/utf8>>,right = 2,right_answer = <<"雅典"/utf8>>,answer1 = <<"塞萨洛尼基"/utf8>>,answer2 = <<"雅典"/utf8>>,answer3 = <<"帕特雷"/utf8>>,answer4 = <<"伊拉克利翁"/utf8>>};

get_question_cfg(1186) ->
	#gfeast_question_cfg{id = 1186,weight = 100,topic_type = 1,question = <<"蟋蟀是靠什么发出鸣叫声的?"/utf8>>,right = 2,right_answer = <<"翅膀"/utf8>>,answer1 = <<"触角"/utf8>>,answer2 = <<"翅膀"/utf8>>,answer3 = <<"嘴巴"/utf8>>,answer4 = <<"尾巴"/utf8>>};

get_question_cfg(1187) ->
	#gfeast_question_cfg{id = 1187,weight = 100,topic_type = 1,question = <<"现在美国国旗星条旗上共有(?)颗星"/utf8>>,right = 2,right_answer = <<"50"/utf8>>,answer1 = <<"45"/utf8>>,answer2 = <<"50"/utf8>>,answer3 = <<"55"/utf8>>,answer4 = <<"60"/utf8>>};

get_question_cfg(1188) ->
	#gfeast_question_cfg{id = 1188,weight = 100,topic_type = 1,question = <<"湘是我国哪里的简称?"/utf8>>,right = 2,right_answer = <<"湖南"/utf8>>,answer1 = <<"海南"/utf8>>,answer2 = <<"湖南"/utf8>>,answer3 = <<"河南"/utf8>>,answer4 = <<"江南"/utf8>>};

get_question_cfg(1189) ->
	#gfeast_question_cfg{id = 1189,weight = 100,topic_type = 1,question = <<"小说《包法利夫人》的作者是："/utf8>>,right = 2,right_answer = <<"福楼拜"/utf8>>,answer1 = <<"莎士比亚"/utf8>>,answer2 = <<"福楼拜"/utf8>>,answer3 = <<"歌德"/utf8>>,answer4 = <<"但丁"/utf8>>};

get_question_cfg(1190) ->
	#gfeast_question_cfg{id = 1190,weight = 100,topic_type = 1,question = <<"小说《三国演义》中“单刀赴会“的故事主角是?"/utf8>>,right = 2,right_answer = <<"关羽"/utf8>>,answer1 = <<"张飞"/utf8>>,answer2 = <<"关羽"/utf8>>,answer3 = <<"刘备"/utf8>>,answer4 = <<"诸葛亮"/utf8>>};

get_question_cfg(1191) ->
	#gfeast_question_cfg{id = 1191,weight = 100,topic_type = 1,question = <<"嗅觉最灵敏的动物是(?)，其嗅觉细胞达22亿个。"/utf8>>,right = 2,right_answer = <<"狗"/utf8>>,answer1 = <<"猫"/utf8>>,answer2 = <<"狗"/utf8>>,answer3 = <<"猪"/utf8>>,answer4 = <<"狼"/utf8>>};

get_question_cfg(1192) ->
	#gfeast_question_cfg{id = 1192,weight = 100,topic_type = 1,question = <<"徐霞客曾经盛赞一座山为“四海名山皆过目，就中此景难图录”。这座山指的是"/utf8>>,right = 2,right_answer = <<"雁荡山"/utf8>>,answer1 = <<"白云山"/utf8>>,answer2 = <<"雁荡山"/utf8>>,answer3 = <<"峨眉山"/utf8>>,answer4 = <<"武当山"/utf8>>};

get_question_cfg(1193) ->
	#gfeast_question_cfg{id = 1193,weight = 100,topic_type = 1,question = <<"徐志摩的名诗《再别康桥》中的康桥是指今天的(?)大学。"/utf8>>,right = 2,right_answer = <<"剑桥"/utf8>>,answer1 = <<"哈佛"/utf8>>,answer2 = <<"剑桥"/utf8>>,answer3 = <<"耶鲁"/utf8>>,answer4 = <<"杜克"/utf8>>};

get_question_cfg(1194) ->
	#gfeast_question_cfg{id = 1194,weight = 100,topic_type = 1,question = <<"雪莱的名句“冬天到了，(?)还会远吗”"/utf8>>,right = 2,right_answer = <<"春天"/utf8>>,answer1 = <<"冬天"/utf8>>,answer2 = <<"春天"/utf8>>,answer3 = <<"夏天"/utf8>>,answer4 = <<"秋天"/utf8>>};

get_question_cfg(1195) ->
	#gfeast_question_cfg{id = 1195,weight = 100,topic_type = 1,question = <<"亚洲耕地面积最大的国家是"/utf8>>,right = 2,right_answer = <<"印度"/utf8>>,answer1 = <<"中国"/utf8>>,answer2 = <<"印度"/utf8>>,answer3 = <<"伊朗"/utf8>>,answer4 = <<"缅甸"/utf8>>};

get_question_cfg(1196) ->
	#gfeast_question_cfg{id = 1196,weight = 100,topic_type = 1,question = <<"一般金婚是纪念结婚多少周年?"/utf8>>,right = 2,right_answer = <<"50"/utf8>>,answer1 = <<"30"/utf8>>,answer2 = <<"50"/utf8>>,answer3 = <<"60"/utf8>>,answer4 = <<"70"/utf8>>};

get_question_cfg(1197) ->
	#gfeast_question_cfg{id = 1197,weight = 100,topic_type = 1,question = <<"一般认为篮球起源于哪个国家?"/utf8>>,right = 2,right_answer = <<"美国"/utf8>>,answer1 = <<"德国"/utf8>>,answer2 = <<"美国"/utf8>>,answer3 = <<"英国"/utf8>>,answer4 = <<"法国"/utf8>>};

get_question_cfg(1198) ->
	#gfeast_question_cfg{id = 1198,weight = 100,topic_type = 1,question = <<"一年有多少个月是31天的?"/utf8>>,right = 2,right_answer = <<"7"/utf8>>,answer1 = <<"6"/utf8>>,answer2 = <<"7"/utf8>>,answer3 = <<"8"/utf8>>,answer4 = <<"9"/utf8>>};

get_question_cfg(1199) ->
	#gfeast_question_cfg{id = 1199,weight = 100,topic_type = 1,question = <<"一年有几个节气?"/utf8>>,right = 2,right_answer = <<"24"/utf8>>,answer1 = <<"12"/utf8>>,answer2 = <<"24"/utf8>>,answer3 = <<"36"/utf8>>,answer4 = <<"48"/utf8>>};

get_question_cfg(1200) ->
	#gfeast_question_cfg{id = 1200,weight = 100,topic_type = 1,question = <<"一切物体在没有受到外力所用的时候，总保持匀速直线运动状态或静止状态，这是牛顿第几定律?"/utf8>>,right = 2,right_answer = <<"第一定律"/utf8>>,answer1 = <<"第零定律"/utf8>>,answer2 = <<"第一定律"/utf8>>,answer3 = <<"第二定律"/utf8>>,answer4 = <<"第三定律"/utf8>>};

get_question_cfg(1201) ->
	#gfeast_question_cfg{id = 1201,weight = 100,topic_type = 1,question = <<"一群兔子排队，从左数小兔子是第100位，从右数小兔子是第99位，这群兔子一共有几只?"/utf8>>,right = 2,right_answer = <<"198"/utf8>>,answer1 = <<"100"/utf8>>,answer2 = <<"198"/utf8>>,answer3 = <<"99"/utf8>>,answer4 = <<"199"/utf8>>};

get_question_cfg(1202) ->
	#gfeast_question_cfg{id = 1202,weight = 100,topic_type = 1,question = <<"一张桌子有四个角，砍去一个角，还剩几个角?"/utf8>>,right = 2,right_answer = <<"5"/utf8>>,answer1 = <<"4"/utf8>>,answer2 = <<"5"/utf8>>,answer3 = <<"6"/utf8>>,answer4 = <<"7"/utf8>>};

get_question_cfg(1203) ->
	#gfeast_question_cfg{id = 1203,weight = 100,topic_type = 1,question = <<"一株竹子出笋时有18节，一年后有多少节?"/utf8>>,right = 2,right_answer = <<"18"/utf8>>,answer1 = <<"0"/utf8>>,answer2 = <<"18"/utf8>>,answer3 = <<"36"/utf8>>,answer4 = <<"100"/utf8>>};

get_question_cfg(1204) ->
	#gfeast_question_cfg{id = 1204,weight = 100,topic_type = 1,question = <<"医生给你3颗药叫你每半小时吃一颗你吃完要多少小时?"/utf8>>,right = 2,right_answer = <<"1"/utf8>>,answer1 = <<"0"/utf8>>,answer2 = <<"1"/utf8>>,answer3 = <<"2"/utf8>>,answer4 = <<"3"/utf8>>};

get_question_cfg(1205) ->
	#gfeast_question_cfg{id = 1205,weight = 100,topic_type = 1,question = <<"意大利的首都是?"/utf8>>,right = 2,right_answer = <<"罗马"/utf8>>,answer1 = <<"米兰"/utf8>>,answer2 = <<"罗马"/utf8>>,answer3 = <<"都灵"/utf8>>,answer4 = <<"威尼斯"/utf8>>};

get_question_cfg(1206) ->
	#gfeast_question_cfg{id = 1206,weight = 100,topic_type = 1,question = <<"因蜀锦有名而得名“锦官城”的城市是?"/utf8>>,right = 2,right_answer = <<"成都"/utf8>>,answer1 = <<"昆明"/utf8>>,answer2 = <<"成都"/utf8>>,answer3 = <<"重庆"/utf8>>,answer4 = <<"贵阳"/utf8>>};

get_question_cfg(1207) ->
	#gfeast_question_cfg{id = 1207,weight = 100,topic_type = 1,question = <<"婴儿出生时的哭啼声意味着婴儿开始有什么生理功能?"/utf8>>,right = 2,right_answer = <<"呼吸"/utf8>>,answer1 = <<"心跳"/utf8>>,answer2 = <<"呼吸"/utf8>>,answer3 = <<"进食"/utf8>>,answer4 = <<"消化"/utf8>>};

get_question_cfg(1208) ->
	#gfeast_question_cfg{id = 1208,weight = 100,topic_type = 1,question = <<"用来测量钻石重量单位是?"/utf8>>,right = 2,right_answer = <<"克拉"/utf8>>,answer1 = <<"斤"/utf8>>,answer2 = <<"克拉"/utf8>>,answer3 = <<"两"/utf8>>,answer4 = <<"公斤"/utf8>>};

get_question_cfg(1209) ->
	#gfeast_question_cfg{id = 1209,weight = 100,topic_type = 1,question = <<"由于推行开明务实政策，唐初出现了什么样的社会局面?"/utf8>>,right = 2,right_answer = <<"贞观之治"/utf8>>,answer1 = <<"开元盛世"/utf8>>,answer2 = <<"贞观之治"/utf8>>,answer3 = <<"贞观遗风"/utf8>>,answer4 = <<"开元之治"/utf8>>};

get_question_cfg(1210) ->
	#gfeast_question_cfg{id = 1210,weight = 100,topic_type = 1,question = <<"有“世界童话大王之称”的安徒生是那个国家的?"/utf8>>,right = 2,right_answer = <<"丹麦"/utf8>>,answer1 = <<"加拿大"/utf8>>,answer2 = <<"丹麦"/utf8>>,answer3 = <<"德国"/utf8>>,answer4 = <<"法国"/utf8>>};

get_question_cfg(1211) ->
	#gfeast_question_cfg{id = 1211,weight = 100,topic_type = 1,question = <<"有唐三藏主持建造的大雁塔是哪个城市的著名景点?"/utf8>>,right = 3,right_answer = <<"西安"/utf8>>,answer1 = <<"南京"/utf8>>,answer2 = <<"北京"/utf8>>,answer3 = <<"西安"/utf8>>,answer4 = <<"东江"/utf8>>};

get_question_cfg(1212) ->
	#gfeast_question_cfg{id = 1212,weight = 100,topic_type = 1,question = <<"有意见要向当地的市政府反映应该拨打什么电话?"/utf8>>,right = 3,right_answer = <<"12345"/utf8>>,answer1 = <<"110"/utf8>>,answer2 = <<"10000"/utf8>>,answer3 = <<"12345"/utf8>>,answer4 = <<"10086"/utf8>>};

get_question_cfg(1213) ->
	#gfeast_question_cfg{id = 1213,weight = 100,topic_type = 1,question = <<"渝是我国哪里的简称?"/utf8>>,right = 3,right_answer = <<"重庆"/utf8>>,answer1 = <<"辽宁"/utf8>>,answer2 = <<"海南"/utf8>>,answer3 = <<"重庆"/utf8>>,answer4 = <<"山西"/utf8>>};

get_question_cfg(1214) ->
	#gfeast_question_cfg{id = 1214,weight = 100,topic_type = 1,question = <<"与“精忠报国”，“莫须有”等事件有关的历史人物是?"/utf8>>,right = 3,right_answer = <<"岳飞"/utf8>>,answer1 = <<"文天祥"/utf8>>,answer2 = <<"陆游"/utf8>>,answer3 = <<"岳飞"/utf8>>,answer4 = <<"杨万里"/utf8>>};

get_question_cfg(1215) ->
	#gfeast_question_cfg{id = 1215,weight = 100,topic_type = 1,question = <<"与李商隐并称为“小李杜”的是谁?"/utf8>>,right = 3,right_answer = <<"杜牧"/utf8>>,answer1 = <<"杜甫"/utf8>>,answer2 = <<"杜如晦"/utf8>>,answer3 = <<"杜牧"/utf8>>,answer4 = <<"杜康"/utf8>>};

get_question_cfg(1216) ->
	#gfeast_question_cfg{id = 1216,weight = 100,topic_type = 1,question = <<"与清明节相关的,古代一个非常有名的,现在已经失传的节日是什么?"/utf8>>,right = 3,right_answer = <<"寒食"/utf8>>,answer1 = <<"中和"/utf8>>,answer2 = <<"春龙"/utf8>>,answer3 = <<"寒食"/utf8>>,answer4 = <<"花朝"/utf8>>};

get_question_cfg(1217) ->
	#gfeast_question_cfg{id = 1217,weight = 100,topic_type = 1,question = <<"遇到火灾时,我们应该拨打的火警电话号码是多少?"/utf8>>,right = 3,right_answer = <<"119"/utf8>>,answer1 = <<"110"/utf8>>,answer2 = <<"10000"/utf8>>,answer3 = <<"119"/utf8>>,answer4 = <<"10086"/utf8>>};

get_question_cfg(1218) ->
	#gfeast_question_cfg{id = 1218,weight = 100,topic_type = 1,question = <<"粤是我国哪里的简称?"/utf8>>,right = 3,right_answer = <<"广东"/utf8>>,answer1 = <<"广西"/utf8>>,answer2 = <<"山西"/utf8>>,answer3 = <<"广东"/utf8>>,answer4 = <<"山东"/utf8>>};

get_question_cfg(1219) ->
	#gfeast_question_cfg{id = 1219,weight = 100,topic_type = 1,question = <<"在古代，人们将乐器分为“丝“、“竹“，分别指弹弦乐器和吹奏乐器，其中(?)是指吹奏乐器。"/utf8>>,right = 3,right_answer = <<"竹"/utf8>>,answer1 = <<"丝"/utf8>>,answer2 = <<"萧"/utf8>>,answer3 = <<"竹"/utf8>>,answer4 = <<"笛"/utf8>>};

get_question_cfg(1220) ->
	#gfeast_question_cfg{id = 1220,weight = 100,topic_type = 1,question = <<"在古代，人们将乐器分为“丝“、“竹“，分别指弹弦乐器和吹奏乐器，其中(?)是指弹弦乐器。"/utf8>>,right = 3,right_answer = <<"丝"/utf8>>,answer1 = <<"竹"/utf8>>,answer2 = <<"笛"/utf8>>,answer3 = <<"丝"/utf8>>,answer4 = <<"萧"/utf8>>};

get_question_cfg(1221) ->
	#gfeast_question_cfg{id = 1221,weight = 100,topic_type = 1,question = <<"在三倍放大镜下，三角板角的度数会："/utf8>>,right = 3,right_answer = <<"不变"/utf8>>,answer1 = <<"变大"/utf8>>,answer2 = <<"变小"/utf8>>,answer3 = <<"不变"/utf8>>,answer4 = <<"不知道"/utf8>>};

get_question_cfg(1222) ->
	#gfeast_question_cfg{id = 1222,weight = 100,topic_type = 1,question = <<"在世界杯历史上获得冠军次数最多的是哪个球队?"/utf8>>,right = 3,right_answer = <<"巴西"/utf8>>,answer1 = <<"乌拉圭"/utf8>>,answer2 = <<"德国"/utf8>>,answer3 = <<"巴西"/utf8>>,answer4 = <<"意大利"/utf8>>};

get_question_cfg(1223) ->
	#gfeast_question_cfg{id = 1223,weight = 100,topic_type = 1,question = <<"在寺庙里总管各项事务的一位僧人称为"/utf8>>,right = 3,right_answer = <<"住持方丈"/utf8>>,answer1 = <<"长老"/utf8>>,answer2 = <<"扫地僧"/utf8>>,answer3 = <<"住持方丈"/utf8>>,answer4 = <<"禅师"/utf8>>};

get_question_cfg(1224) ->
	#gfeast_question_cfg{id = 1224,weight = 100,topic_type = 1,question = <<"在天愿做(?)，在地愿为连理枝"/utf8>>,right = 3,right_answer = <<"比翼鸟"/utf8>>,answer1 = <<"鸳鸯鸟"/utf8>>,answer2 = <<"白鹭鸟"/utf8>>,answer3 = <<"比翼鸟"/utf8>>,answer4 = <<"黄鹂鸟"/utf8>>};

get_question_cfg(1225) ->
	#gfeast_question_cfg{id = 1225,weight = 100,topic_type = 1,question = <<"在天愿做比翼鸟，在地愿为(?)"/utf8>>,right = 3,right_answer = <<"连理枝"/utf8>>,answer1 = <<"相思豆"/utf8>>,answer2 = <<"猫猫头"/utf8>>,answer3 = <<"连理枝"/utf8>>,answer4 = <<"皮卡丘"/utf8>>};

get_question_cfg(1226) ->
	#gfeast_question_cfg{id = 1226,weight = 100,topic_type = 1,question = <<"在天愿做比翼鸟，在地愿为连理枝出自"/utf8>>,right = 3,right_answer = <<"长恨歌"/utf8>>,answer1 = <<"琵琶行"/utf8>>,answer2 = <<"声声慢"/utf8>>,answer3 = <<"长恨歌"/utf8>>,answer4 = <<"蝶恋花"/utf8>>};

get_question_cfg(1227) ->
	#gfeast_question_cfg{id = 1227,weight = 100,topic_type = 1,question = <<"在围棋的棋盘上标有九个小圆点，这几个小圆点称作(?)"/utf8>>,right = 3,right_answer = <<"星"/utf8>>,answer1 = <<"河"/utf8>>,answer2 = <<"月"/utf8>>,answer3 = <<"星"/utf8>>,answer4 = <<"圆"/utf8>>};

get_question_cfg(1228) ->
	#gfeast_question_cfg{id = 1228,weight = 100,topic_type = 1,question = <<"在我国，“桃月”是指哪一月"/utf8>>,right = 3,right_answer = <<"3"/utf8>>,answer1 = <<"1"/utf8>>,answer2 = <<"2"/utf8>>,answer3 = <<"3"/utf8>>,answer4 = <<"4"/utf8>>};

get_question_cfg(1229) ->
	#gfeast_question_cfg{id = 1229,weight = 100,topic_type = 1,question = <<"在我国，自古就有“天府之国”美誉的地区是"/utf8>>,right = 3,right_answer = <<"四川盆地"/utf8>>,answer1 = <<"青藏高原"/utf8>>,answer2 = <<"吐鲁番盆地"/utf8>>,answer3 = <<"四川盆地"/utf8>>,answer4 = <<"塔里木盆地"/utf8>>};

get_question_cfg(1230) ->
	#gfeast_question_cfg{id = 1230,weight = 100,topic_type = 1,question = <<"在一天中，时钟的时针，分针和秒针完全重合在一起的时候有几次?"/utf8>>,right = 3,right_answer = <<"2"/utf8>>,answer1 = <<"0"/utf8>>,answer2 = <<"1"/utf8>>,answer3 = <<"2"/utf8>>,answer4 = <<"3"/utf8>>};

get_question_cfg(1231) ->
	#gfeast_question_cfg{id = 1231,weight = 100,topic_type = 1,question = <<"中国历史上第一个朝代是"/utf8>>,right = 3,right_answer = <<"夏朝"/utf8>>,answer1 = <<"周朝"/utf8>>,answer2 = <<"商朝"/utf8>>,answer3 = <<"夏朝"/utf8>>,answer4 = <<"战国"/utf8>>};

get_question_cfg(1232) ->
	#gfeast_question_cfg{id = 1232,weight = 100,topic_type = 1,question = <<"在足球比赛中，裁判把运动员罚下场会使用什么牌?"/utf8>>,right = 3,right_answer = <<"红牌"/utf8>>,answer1 = <<"黄牌"/utf8>>,answer2 = <<"黑牌"/utf8>>,answer3 = <<"红牌"/utf8>>,answer4 = <<"绿牌"/utf8>>};

get_question_cfg(1233) ->
	#gfeast_question_cfg{id = 1233,weight = 100,topic_type = 1,question = <<"造纸术大约是在什么朝代发明的"/utf8>>,right = 3,right_answer = <<"西汉"/utf8>>,answer1 = <<"夏朝"/utf8>>,answer2 = <<"东汉"/utf8>>,answer3 = <<"西汉"/utf8>>,answer4 = <<"秦朝"/utf8>>};

get_question_cfg(1234) ->
	#gfeast_question_cfg{id = 1234,weight = 100,topic_type = 1,question = <<"战国时期的兵器大多用哪种材料制成"/utf8>>,right = 3,right_answer = <<"青铜"/utf8>>,answer1 = <<"铁"/utf8>>,answer2 = <<"金"/utf8>>,answer3 = <<"青铜"/utf8>>,answer4 = <<"银"/utf8>>};

get_question_cfg(1235) ->
	#gfeast_question_cfg{id = 1235,weight = 100,topic_type = 1,question = <<"中国传统中有多少种生肖"/utf8>>,right = 3,right_answer = <<"12"/utf8>>,answer1 = <<"10"/utf8>>,answer2 = <<"11"/utf8>>,answer3 = <<"12"/utf8>>,answer4 = <<"13"/utf8>>};

get_question_cfg(1236) ->
	#gfeast_question_cfg{id = 1236,weight = 100,topic_type = 1,question = <<"制作太阳能热水器用什么颜色的容器吸收太阳能多?"/utf8>>,right = 3,right_answer = <<"黑色"/utf8>>,answer1 = <<"白色"/utf8>>,answer2 = <<"红色"/utf8>>,answer3 = <<"黑色"/utf8>>,answer4 = <<"紫色"/utf8>>};

get_question_cfg(1237) ->
	#gfeast_question_cfg{id = 1237,weight = 100,topic_type = 1,question = <<"中国的“五行”是哪五行?"/utf8>>,right = 3,right_answer = <<"金木水火土"/utf8>>,answer1 = <<"风火雷电山"/utf8>>,answer2 = <<"金银铜铁锡"/utf8>>,answer3 = <<"金木水火土"/utf8>>,answer4 = <<"阴阳日月星"/utf8>>};

get_question_cfg(1238) ->
	#gfeast_question_cfg{id = 1238,weight = 100,topic_type = 1,question = <<"中国的第一部按部首编排的中文字典叫什么?"/utf8>>,right = 3,right_answer = <<"说文解字"/utf8>>,answer1 = <<"康熙字典"/utf8>>,answer2 = <<"新华字典"/utf8>>,answer3 = <<"说文解字"/utf8>>,answer4 = <<"中华大字典"/utf8>>};

get_question_cfg(1239) ->
	#gfeast_question_cfg{id = 1239,weight = 100,topic_type = 1,question = <<"中国的国球是什么球?"/utf8>>,right = 3,right_answer = <<"乒乓球"/utf8>>,answer1 = <<"羽毛球"/utf8>>,answer2 = <<"足球"/utf8>>,answer3 = <<"乒乓球"/utf8>>,answer4 = <<"篮球"/utf8>>};

get_question_cfg(1240) ->
	#gfeast_question_cfg{id = 1240,weight = 100,topic_type = 1,question = <<"中国第一位女性诺贝尔奖获得者是?"/utf8>>,right = 3,right_answer = <<"屠呦呦"/utf8>>,answer1 = <<"贝蒂·威廉斯"/utf8>>,answer2 = <<"玛丽·居里"/utf8>>,answer3 = <<"屠呦呦"/utf8>>,answer4 = <<"琳达·巴克"/utf8>>};

get_question_cfg(1241) ->
	#gfeast_question_cfg{id = 1241,weight = 100,topic_type = 1,question = <<"中国古代科举制度第三名叫什么?"/utf8>>,right = 3,right_answer = <<"探花"/utf8>>,answer1 = <<"状元"/utf8>>,answer2 = <<"榜眼"/utf8>>,answer3 = <<"探花"/utf8>>,answer4 = <<"小生"/utf8>>};

get_question_cfg(1242) ->
	#gfeast_question_cfg{id = 1242,weight = 100,topic_type = 1,question = <<"中国和朝鲜两国的界河是?"/utf8>>,right = 3,right_answer = <<"鸭绿江"/utf8>>,answer1 = <<"黑龙江"/utf8>>,answer2 = <<"汉江"/utf8>>,answer3 = <<"鸭绿江"/utf8>>,answer4 = <<"长江"/utf8>>};

get_question_cfg(1243) ->
	#gfeast_question_cfg{id = 1243,weight = 100,topic_type = 1,question = <<"中国神话传说中人类的始祖是"/utf8>>,right = 3,right_answer = <<"女娲"/utf8>>,answer1 = <<"亚当"/utf8>>,answer2 = <<"夏娃"/utf8>>,answer3 = <<"女娲"/utf8>>,answer4 = <<"夸父"/utf8>>};

get_question_cfg(1244) ->
	#gfeast_question_cfg{id = 1244,weight = 100,topic_type = 1,question = <<"中国四大发明中的活字印刷术是谁发明的?"/utf8>>,right = 3,right_answer = <<"毕昇"/utf8>>,answer1 = <<"蔡伦"/utf8>>,answer2 = <<"张衡"/utf8>>,answer3 = <<"毕昇"/utf8>>,answer4 = <<"郑和"/utf8>>};

get_question_cfg(1245) ->
	#gfeast_question_cfg{id = 1245,weight = 100,topic_type = 1,question = <<"中国唯一一位女皇帝是谁?"/utf8>>,right = 3,right_answer = <<"武则天"/utf8>>,answer1 = <<"殇帝元"/utf8>>,answer2 = <<"陈硕真"/utf8>>,answer3 = <<"武则天"/utf8>>,answer4 = <<"慈禧"/utf8>>};

get_question_cfg(1246) ->
	#gfeast_question_cfg{id = 1246,weight = 100,topic_type = 1,question = <<"中国戏曲表演的四种艺术手段包括唱、念、做、(?)"/utf8>>,right = 3,right_answer = <<"打"/utf8>>,answer1 = <<"学"/utf8>>,answer2 = <<"舞"/utf8>>,answer3 = <<"打"/utf8>>,answer4 = <<"说"/utf8>>};

get_question_cfg(1247) ->
	#gfeast_question_cfg{id = 1247,weight = 100,topic_type = 1,question = <<"中国最大的湖泊是"/utf8>>,right = 3,right_answer = <<"青海湖"/utf8>>,answer1 = <<"洞庭湖"/utf8>>,answer2 = <<"鄱阳湖"/utf8>>,answer3 = <<"青海湖"/utf8>>,answer4 = <<"太湖"/utf8>>};

get_question_cfg(1248) ->
	#gfeast_question_cfg{id = 1248,weight = 100,topic_type = 1,question = <<"中华历史上第一个皇帝是谁"/utf8>>,right = 3,right_answer = <<"秦始皇"/utf8>>,answer1 = <<"尧"/utf8>>,answer2 = <<"舜"/utf8>>,answer3 = <<"秦始皇"/utf8>>,answer4 = <<"禹"/utf8>>};

get_question_cfg(1249) ->
	#gfeast_question_cfg{id = 1249,weight = 100,topic_type = 1,question = <<"歇后语猪八戒照镜子的下一句是？"/utf8>>,right = 3,right_answer = <<"里外不是人"/utf8>>,answer1 = <<"人模猪样"/utf8>>,answer2 = <<"貌丑心善"/utf8>>,answer3 = <<"里外不是人"/utf8>>,answer4 = <<"猪也爱美丽"/utf8>>};

get_question_cfg(1250) ->
	#gfeast_question_cfg{id = 1250,weight = 100,topic_type = 1,question = <<"周长相等的等边三角形、正方形、圆形，哪一个的面积最大?"/utf8>>,right = 3,right_answer = <<"圆形"/utf8>>,answer1 = <<"等边三角形"/utf8>>,answer2 = <<"正方形"/utf8>>,answer3 = <<"圆形"/utf8>>,answer4 = <<"一样大"/utf8>>};

get_question_cfg(1251) ->
	#gfeast_question_cfg{id = 1251,weight = 100,topic_type = 1,question = <<"诸葛亮与周瑜联手指挥的一场著名的以少胜多的战役是什么战役?"/utf8>>,right = 3,right_answer = <<"赤壁之战"/utf8>>,answer1 = <<"潼关之战"/utf8>>,answer2 = <<"合肥之战"/utf8>>,answer3 = <<"赤壁之战"/utf8>>,answer4 = <<"荆州之战"/utf8>>};

get_question_cfg(1252) ->
	#gfeast_question_cfg{id = 1252,weight = 100,topic_type = 1,question = <<"诸子百家中(?)家的特点是注重逻辑辩证，“白马非马”典故也出于此家。"/utf8>>,right = 3,right_answer = <<"名"/utf8>>,answer1 = <<"儒"/utf8>>,answer2 = <<"道"/utf8>>,answer3 = <<"名"/utf8>>,answer4 = <<"法"/utf8>>};

get_question_cfg(1253) ->
	#gfeast_question_cfg{id = 1253,weight = 100,topic_type = 1,question = <<"竹篮打水(猜一歇后语)"/utf8>>,right = 3,right_answer = <<"一场空"/utf8>>,answer1 = <<"七上八下"/utf8>>,answer2 = <<"打不着"/utf8>>,answer3 = <<"一场空"/utf8>>,answer4 = <<"白用功"/utf8>>};

get_question_cfg(1254) ->
	#gfeast_question_cfg{id = 1254,weight = 100,topic_type = 1,question = <<"著名的“自由女神”像坐落在美国的哪座城市?"/utf8>>,right = 3,right_answer = <<"纽约"/utf8>>,answer1 = <<"洛杉矶"/utf8>>,answer2 = <<"芝加哥"/utf8>>,answer3 = <<"纽约"/utf8>>,answer4 = <<"休斯敦"/utf8>>};

get_question_cfg(1255) ->
	#gfeast_question_cfg{id = 1255,weight = 100,topic_type = 1,question = <<"著名喜剧电影艺术家卓别林出生于哪个国家?"/utf8>>,right = 3,right_answer = <<"英国"/utf8>>,answer1 = <<"美国"/utf8>>,answer2 = <<"法国"/utf8>>,answer3 = <<"英国"/utf8>>,answer4 = <<"德国"/utf8>>};

get_question_cfg(1256) ->
	#gfeast_question_cfg{id = 1256,weight = 100,topic_type = 1,question = <<"饭圈文化中xswl是什么意思"/utf8>>,right = 3,right_answer = <<"笑死我了"/utf8>>,answer1 = <<"吓死我了"/utf8>>,answer2 = <<"熏死我了"/utf8>>,answer3 = <<"笑死我了"/utf8>>,answer4 = <<"星神未来"/utf8>>};

get_question_cfg(1257) ->
	#gfeast_question_cfg{id = 1257,weight = 100,topic_type = 1,question = <<"饭圈文化中nsdd是什么意思"/utf8>>,right = 3,right_answer = <<"你说的对"/utf8>>,answer1 = <<"你是对的"/utf8>>,answer2 = <<"南山大道"/utf8>>,answer3 = <<"你说的对"/utf8>>,answer4 = <<"你是弟弟"/utf8>>};

get_question_cfg(1258) ->
	#gfeast_question_cfg{id = 1258,weight = 100,topic_type = 1,question = <<"饭圈文化中“疯狂应援、支持”用什么表示"/utf8>>,right = 3,right_answer = <<"打call"/utf8>>,answer1 = <<"投食"/utf8>>,answer2 = <<"投票"/utf8>>,answer3 = <<"打call"/utf8>>,answer4 = <<"粉"/utf8>>};

get_question_cfg(1259) ->
	#gfeast_question_cfg{id = 1259,weight = 100,topic_type = 1,question = <<"因“鸡你太美”而被全网嘲讽的娱乐明星是"/utf8>>,right = 3,right_answer = <<"蔡徐坤"/utf8>>,answer1 = <<"林宥嘉"/utf8>>,answer2 = <<"萧敬腾"/utf8>>,answer3 = <<"蔡徐坤"/utf8>>,answer4 = <<"黄靖伦"/utf8>>};

get_question_cfg(1260) ->
	#gfeast_question_cfg{id = 1260,weight = 100,topic_type = 1,question = <<"娱乐圈里贾乃亮和李小璐离婚事件的关键词是什么"/utf8>>,right = 3,right_answer = <<"做头发"/utf8>>,answer1 = <<"买衣服"/utf8>>,answer2 = <<"敷面膜"/utf8>>,answer3 = <<"做头发"/utf8>>,answer4 = <<"指甲油"/utf8>>};

get_question_cfg(1261) ->
	#gfeast_question_cfg{id = 1261,weight = 100,topic_type = 1,question = <<"让演员翟天临陷入巨大风波的论文网站叫什么?"/utf8>>,right = 3,right_answer = <<"知网"/utf8>>,answer1 = <<"百度"/utf8>>,answer2 = <<"谷歌"/utf8>>,answer3 = <<"知网"/utf8>>,answer4 = <<"微博"/utf8>>};

get_question_cfg(1262) ->
	#gfeast_question_cfg{id = 1262,weight = 100,topic_type = 1,question = <<"被誉为“大唐反恐24小时”的古装剧是"/utf8>>,right = 3,right_answer = <<"长安十二时辰"/utf8>>,answer1 = <<"长安十时辰"/utf8>>,answer2 = <<"长安十一时辰"/utf8>>,answer3 = <<"长安十二时辰"/utf8>>,answer4 = <<"长安十三时辰"/utf8>>};

get_question_cfg(1263) ->
	#gfeast_question_cfg{id = 1263,weight = 100,topic_type = 1,question = <<"2020年，以“时间管理大师”另类博人眼球的娱乐明星是"/utf8>>,right = 3,right_answer = <<"罗志祥"/utf8>>,answer1 = <<"吴亦凡"/utf8>>,answer2 = <<"陈冠希"/utf8>>,answer3 = <<"罗志祥"/utf8>>,answer4 = <<"王力宏"/utf8>>};

get_question_cfg(1264) ->
	#gfeast_question_cfg{id = 1264,weight = 100,topic_type = 1,question = <<"2020年被说唱歌手认为最“恐惧”的穿搭风格是“淡黄的长裙，(?)”"/utf8>>,right = 3,right_answer = <<"蓬松的头发"/utf8>>,answer1 = <<"油腻的头"/utf8>>,answer2 = <<"缤纷的头"/utf8>>,answer3 = <<"蓬松的头发"/utf8>>,answer4 = <<"光亮的头"/utf8>>};

get_question_cfg(1265) ->
	#gfeast_question_cfg{id = 1265,weight = 100,topic_type = 1,question = <<"壁虎在遇到敌人攻击，很危险的情况下会舍弃身体的什么部分逃走"/utf8>>,right = 3,right_answer = <<"尾巴"/utf8>>,answer1 = <<"舌头"/utf8>>,answer2 = <<"腿"/utf8>>,answer3 = <<"尾巴"/utf8>>,answer4 = <<"指甲"/utf8>>};

get_question_cfg(1266) ->
	#gfeast_question_cfg{id = 1266,weight = 100,topic_type = 1,question = <<"电影午夜凶铃中从电视剧爬出来的著名恐怖角色叫什么"/utf8>>,right = 3,right_answer = <<"贞子"/utf8>>,answer1 = <<"花子"/utf8>>,answer2 = <<"美美子"/utf8>>,answer3 = <<"贞子"/utf8>>,answer4 = <<"伽椰子"/utf8>>};

get_question_cfg(1267) ->
	#gfeast_question_cfg{id = 1267,weight = 100,topic_type = 1,question = <<"动画片中舒克贝塔历险记中，舒克是什么职业"/utf8>>,right = 3,right_answer = <<"飞行员"/utf8>>,answer1 = <<"枪手"/utf8>>,answer2 = <<"司机"/utf8>>,answer3 = <<"飞行员"/utf8>>,answer4 = <<"武士"/utf8>>};

get_question_cfg(1268) ->
	#gfeast_question_cfg{id = 1268,weight = 100,topic_type = 1,question = <<"骨质疏松症主要是身体缺乏哪种矿物质"/utf8>>,right = 3,right_answer = <<"钙"/utf8>>,answer1 = <<"铁"/utf8>>,answer2 = <<"锌"/utf8>>,answer3 = <<"钙"/utf8>>,answer4 = <<"硒"/utf8>>};

get_question_cfg(1269) ->
	#gfeast_question_cfg{id = 1269,weight = 100,topic_type = 1,question = <<"人们常说花季的年纪指多少岁"/utf8>>,right = 3,right_answer = <<"16岁"/utf8>>,answer1 = <<"13岁"/utf8>>,answer2 = <<"15岁"/utf8>>,answer3 = <<"16岁"/utf8>>,answer4 = <<"18岁"/utf8>>};

get_question_cfg(1270) ->
	#gfeast_question_cfg{id = 1270,weight = 100,topic_type = 1,question = <<"人们通常用来送花的蓝色妖姬其实是什么花"/utf8>>,right = 3,right_answer = <<"玫瑰"/utf8>>,answer1 = <<"牡丹"/utf8>>,answer2 = <<"月季"/utf8>>,answer3 = <<"玫瑰"/utf8>>,answer4 = <<"桃花"/utf8>>};

get_question_cfg(1271) ->
	#gfeast_question_cfg{id = 1271,weight = 100,topic_type = 1,question = <<"世界上现存最大的两栖动物，因叫声很像幼儿哭声又名什么鱼"/utf8>>,right = 3,right_answer = <<"娃娃鱼"/utf8>>,answer1 = <<"比目鱼"/utf8>>,answer2 = <<"小丑鱼"/utf8>>,answer3 = <<"娃娃鱼"/utf8>>,answer4 = <<"蝴蝶鱼"/utf8>>};

get_question_cfg(1272) ->
	#gfeast_question_cfg{id = 1272,weight = 100,topic_type = 1,question = <<"我国古代时传统婚礼的拜天地有三拜，一拜天地，二拜"/utf8>>,right = 3,right_answer = <<"高堂"/utf8>>,answer1 = <<"山河"/utf8>>,answer2 = <<"明月"/utf8>>,answer3 = <<"高堂"/utf8>>,answer4 = <<"亲友"/utf8>>};

get_question_cfg(1273) ->
	#gfeast_question_cfg{id = 1273,weight = 100,topic_type = 1,question = <<"我国铁道部的CRH高速动车，统一命名为什么号"/utf8>>,right = 3,right_answer = <<"和谐号"/utf8>>,answer1 = <<"疾风号"/utf8>>,answer2 = <<"飞速号"/utf8>>,answer3 = <<"和谐号"/utf8>>,answer4 = <<"温馨号"/utf8>>};

get_question_cfg(1274) ->
	#gfeast_question_cfg{id = 1274,weight = 100,topic_type = 1,question = <<"歇后语黄鼠狼给鸡拜年的下一句是什么"/utf8>>,right = 3,right_answer = <<"没安好心"/utf8>>,answer1 = <<"大吉大利"/utf8>>,answer2 = <<"今晚吃鸡"/utf8>>,answer3 = <<"没安好心"/utf8>>,answer4 = <<"臭气熏天"/utf8>>};

get_question_cfg(1275) ->
	#gfeast_question_cfg{id = 1275,weight = 100,topic_type = 1,question = <<"歇后语十五个吊桶打水的下一句是什么"/utf8>>,right = 3,right_answer = <<"七上八下"/utf8>>,answer1 = <<"一场空"/utf8>>,answer2 = <<"七零八落"/utf8>>,answer3 = <<"七上八下"/utf8>>,answer4 = <<"七七八八"/utf8>>};

get_question_cfg(1276) ->
	#gfeast_question_cfg{id = 1276,weight = 100,topic_type = 1,question = <<"寻寻觅觅冷冷清清凄凄惨惨戚戚是出自宋朝那位女词人之手"/utf8>>,right = 3,right_answer = <<"李清照"/utf8>>,answer1 = <<"朱淑真"/utf8>>,answer2 = <<"吴淑姬"/utf8>>,answer3 = <<"李清照"/utf8>>,answer4 = <<"张玉娘"/utf8>>};

get_question_cfg(1277) ->
	#gfeast_question_cfg{id = 1277,weight = 100,topic_type = 1,question = <<"作为我国婚礼程序中，夫妻各执一杯酒，双手相交喝完表示相爱的喝酒形式叫什么"/utf8>>,right = 3,right_answer = <<"交杯酒"/utf8>>,answer1 = <<"喜酒"/utf8>>,answer2 = <<"白酒"/utf8>>,answer3 = <<"交杯酒"/utf8>>,answer4 = <<"夫妻酒"/utf8>>};

get_question_cfg(1278) ->
	#gfeast_question_cfg{id = 1278,weight = 100,topic_type = 1,question = <<"电影《碟中谍4》中汤姆布鲁斯挑战的世界第一高的摩天大楼位于哪个城市"/utf8>>,right = 3,right_answer = <<"迪拜"/utf8>>,answer1 = <<"纽约"/utf8>>,answer2 = <<"悉尼"/utf8>>,answer3 = <<"迪拜"/utf8>>,answer4 = <<"巴黎"/utf8>>};

get_question_cfg(1279) ->
	#gfeast_question_cfg{id = 1279,weight = 100,topic_type = 1,question = <<"美国阿姆斯特朗登上月球后，说了“个人的一小步”，后一句是什么"/utf8>>,right = 3,right_answer = <<"人类的一大步"/utf8>>,answer1 = <<"世界的一大步"/utf8>>,answer2 = <<"生命的一大步"/utf8>>,answer3 = <<"人类的一大步"/utf8>>,answer4 = <<"地球的一大步"/utf8>>};

get_question_cfg(1280) ->
	#gfeast_question_cfg{id = 1280,weight = 100,topic_type = 1,question = <<"世界上公认的第一架实用飞机的发明者是美国的什么人"/utf8>>,right = 3,right_answer = <<"莱特兄弟"/utf8>>,answer1 = <<"格林兄弟"/utf8>>,answer2 = <<"卢米埃尔兄弟"/utf8>>,answer3 = <<"莱特兄弟"/utf8>>,answer4 = <<"麦克沃特兄弟"/utf8>>};

get_question_cfg(1281) ->
	#gfeast_question_cfg{id = 1281,weight = 100,topic_type = 1,question = <<"与刘德华，张学友，郭富城合称为香港“四大天王”的人是谁"/utf8>>,right = 3,right_answer = <<"黎明"/utf8>>,answer1 = <<"周杰伦"/utf8>>,answer2 = <<"谭咏麟"/utf8>>,answer3 = <<"黎明"/utf8>>,answer4 = <<"张国荣"/utf8>>};

get_question_cfg(1282) ->
	#gfeast_question_cfg{id = 1282,weight = 100,topic_type = 1,question = <<"于2012年提出破产保护的原世界最大的照相机，胶卷生产供应商是哪家"/utf8>>,right = 3,right_answer = <<"柯达"/utf8>>,answer1 = <<"佳能"/utf8>>,answer2 = <<"索尼"/utf8>>,answer3 = <<"柯达"/utf8>>,answer4 = <<"富士"/utf8>>};

get_question_cfg(1283) ->
	#gfeast_question_cfg{id = 1283,weight = 100,topic_type = 1,question = <<"我国的吉利汽车公司成功收购了外国哪家汽车公司100%的股权"/utf8>>,right = 3,right_answer = <<"沃尔沃"/utf8>>,answer1 = <<"福特"/utf8>>,answer2 = <<"吉普"/utf8>>,answer3 = <<"沃尔沃"/utf8>>,answer4 = <<"林肯"/utf8>>};

get_question_cfg(1284) ->
	#gfeast_question_cfg{id = 1284,weight = 100,topic_type = 1,question = <<"解放战争时期著名的“三大战役”中第一个打响的是哪个战役"/utf8>>,right = 3,right_answer = <<"辽沈战役"/utf8>>,answer1 = <<"淮海战役"/utf8>>,answer2 = <<"平津战役"/utf8>>,answer3 = <<"辽沈战役"/utf8>>,answer4 = <<"同时开始"/utf8>>};

get_question_cfg(1285) ->
	#gfeast_question_cfg{id = 1285,weight = 100,topic_type = 1,question = <<"股票交易中经常提到的术语“一手”，请问“一手”是指多少股"/utf8>>,right = 3,right_answer = <<"100"/utf8>>,answer1 = <<"50"/utf8>>,answer2 = <<"80"/utf8>>,answer3 = <<"100"/utf8>>,answer4 = <<"200"/utf8>>};

get_question_cfg(1286) ->
	#gfeast_question_cfg{id = 1286,weight = 100,topic_type = 1,question = <<"我们通常吃的葵瓜子是什么植物的果实"/utf8>>,right = 3,right_answer = <<"向日葵"/utf8>>,answer1 = <<"松树"/utf8>>,answer2 = <<"菊花"/utf8>>,answer3 = <<"向日葵"/utf8>>,answer4 = <<"含羞草"/utf8>>};

get_question_cfg(1287) ->
	#gfeast_question_cfg{id = 1287,weight = 100,topic_type = 1,question = <<"国产动画片《喜羊羊与灰太狼》中，灰太狼的老婆叫什么名字"/utf8>>,right = 3,right_answer = <<"红太狼"/utf8>>,answer1 = <<"黑太狼"/utf8>>,answer2 = <<"桃太狼"/utf8>>,answer3 = <<"红太狼"/utf8>>,answer4 = <<"粉太狼"/utf8>>};

get_question_cfg(1288) ->
	#gfeast_question_cfg{id = 1288,weight = 100,topic_type = 1,question = <<"收藏有油画《蒙娜丽莎》等珍贵作品的法国博物馆是哪一座"/utf8>>,right = 3,right_answer = <<"卢浮宫"/utf8>>,answer1 = <<"大英博物馆"/utf8>>,answer2 = <<"艾尔博物馆"/utf8>>,answer3 = <<"卢浮宫"/utf8>>,answer4 = <<"大都会博物馆"/utf8>>};

get_question_cfg(1289) ->
	#gfeast_question_cfg{id = 1289,weight = 100,topic_type = 1,question = <<"动画《鬼灭之刃》的主题曲叫什么？"/utf8>>,right = 3,right_answer = <<"红莲华"/utf8>>,answer1 = <<"绯色之空"/utf8>>,answer2 = <<"青鸟"/utf8>>,answer3 = <<"红莲华"/utf8>>,answer4 = <<"红莲之弓矢"/utf8>>};

get_question_cfg(1290) ->
	#gfeast_question_cfg{id = 1290,weight = 100,topic_type = 1,question = <<"历史上“焚书坑儒”的指中国的那一位皇帝"/utf8>>,right = 3,right_answer = <<"秦始皇"/utf8>>,answer1 = <<"汉高祖"/utf8>>,answer2 = <<"隋炀帝"/utf8>>,answer3 = <<"秦始皇"/utf8>>,answer4 = <<"唐玄宗"/utf8>>};

get_question_cfg(1291) ->
	#gfeast_question_cfg{id = 1291,weight = 100,topic_type = 1,question = <<"28年作为央视春节联欢晚会结尾曲的歌曲叫什么名字"/utf8>>,right = 3,right_answer = <<"难忘今宵"/utf8>>,answer1 = <<"明天会更好"/utf8>>,answer2 = <<"金蛇狂舞"/utf8>>,answer3 = <<"难忘今宵"/utf8>>,answer4 = <<"花好月圆"/utf8>>};

get_question_cfg(1292) ->
	#gfeast_question_cfg{id = 1292,weight = 100,topic_type = 1,question = <<"以下哪一部动漫不属于“民工漫”？"/utf8>>,right = 3,right_answer = <<"千与千寻"/utf8>>,answer1 = <<"死神"/utf8>>,answer2 = <<"火影忍者"/utf8>>,answer3 = <<"千与千寻"/utf8>>,answer4 = <<"名侦探柯南"/utf8>>};

get_question_cfg(1293) ->
	#gfeast_question_cfg{id = 1293,weight = 100,topic_type = 1,question = <<"迎客松是我国那个著名风景区的标志性景点"/utf8>>,right = 3,right_answer = <<"黄山"/utf8>>,answer1 = <<"泰山"/utf8>>,answer2 = <<"嵩山"/utf8>>,answer3 = <<"黄山"/utf8>>,answer4 = <<"衡山"/utf8>>};

get_question_cfg(1294) ->
	#gfeast_question_cfg{id = 1294,weight = 100,topic_type = 1,question = <<"“狗不理包子”是中国哪个城市的传统风味小吃"/utf8>>,right = 3,right_answer = <<"天津"/utf8>>,answer1 = <<"北京"/utf8>>,answer2 = <<"成都"/utf8>>,answer3 = <<"天津"/utf8>>,answer4 = <<"上海"/utf8>>};

get_question_cfg(1295) ->
	#gfeast_question_cfg{id = 1295,weight = 100,topic_type = 1,question = <<"吃菠萝的时候人们一般会用什么水泡一会儿来减少麻木刺痛感"/utf8>>,right = 3,right_answer = <<"盐水"/utf8>>,answer1 = <<"醋"/utf8>>,answer2 = <<"茶水"/utf8>>,answer3 = <<"盐水"/utf8>>,answer4 = <<"酱油"/utf8>>};

get_question_cfg(1296) ->
	#gfeast_question_cfg{id = 1296,weight = 100,topic_type = 1,question = <<"清朝被称为“扬州八怪”的八个人中以画竹子闻名的是哪一位"/utf8>>,right = 3,right_answer = <<"郑板桥"/utf8>>,answer1 = <<"金农"/utf8>>,answer2 = <<"黄慎"/utf8>>,answer3 = <<"郑板桥"/utf8>>,answer4 = <<"高翔"/utf8>>};

get_question_cfg(1297) ->
	#gfeast_question_cfg{id = 1297,weight = 100,topic_type = 1,question = <<"烟草里毒性最大的物质是什么"/utf8>>,right = 3,right_answer = <<"尼古丁"/utf8>>,answer1 = <<"乙醇"/utf8>>,answer2 = <<"水银"/utf8>>,answer3 = <<"尼古丁"/utf8>>,answer4 = <<"石油"/utf8>>};

get_question_cfg(1298) ->
	#gfeast_question_cfg{id = 1298,weight = 100,topic_type = 1,question = <<"小说《封神演义》中，传说由狐狸精变成的商纣王宠妃是谁"/utf8>>,right = 3,right_answer = <<"苏妲己"/utf8>>,answer1 = <<"邓婵玉"/utf8>>,answer2 = <<"石矶"/utf8>>,answer3 = <<"苏妲己"/utf8>>,answer4 = <<"王贵人"/utf8>>};

get_question_cfg(1299) ->
	#gfeast_question_cfg{id = 1299,weight = 100,topic_type = 1,question = <<"创办“精武门”的中国清末爱国武术家是谁"/utf8>>,right = 3,right_answer = <<"霍元甲"/utf8>>,answer1 = <<"叶问"/utf8>>,answer2 = <<"黄飞鸿"/utf8>>,answer3 = <<"霍元甲"/utf8>>,answer4 = <<"李小龙"/utf8>>};

get_question_cfg(1300) ->
	#gfeast_question_cfg{id = 1300,weight = 100,topic_type = 1,question = <<"“有一个老人在中国的南海边画了一个圈”是哪首歌的歌词"/utf8>>,right = 3,right_answer = <<"春天的故事"/utf8>>,answer1 = <<"秋天的故事"/utf8>>,answer2 = <<"冬天的故事"/utf8>>,answer3 = <<"春天的故事"/utf8>>,answer4 = <<"夏天的故事"/utf8>>};

get_question_cfg(1301) ->
	#gfeast_question_cfg{id = 1301,weight = 100,topic_type = 1,question = <<"马可波罗是在哪个朝代来到中国的"/utf8>>,right = 3,right_answer = <<"元朝"/utf8>>,answer1 = <<"唐朝"/utf8>>,answer2 = <<"宋朝"/utf8>>,answer3 = <<"元朝"/utf8>>,answer4 = <<"明朝"/utf8>>};

get_question_cfg(1302) ->
	#gfeast_question_cfg{id = 1302,weight = 100,topic_type = 1,question = <<"《马赛曲》是哪一位国家的国歌"/utf8>>,right = 3,right_answer = <<"法国"/utf8>>,answer1 = <<"美国"/utf8>>,answer2 = <<"英国"/utf8>>,answer3 = <<"法国"/utf8>>,answer4 = <<"德国"/utf8>>};

get_question_cfg(1303) ->
	#gfeast_question_cfg{id = 1303,weight = 100,topic_type = 1,question = <<"广东话中的“老豆”是指普通话中的哪种称谓"/utf8>>,right = 3,right_answer = <<"父亲"/utf8>>,answer1 = <<"哥哥"/utf8>>,answer2 = <<"弟弟"/utf8>>,answer3 = <<"父亲"/utf8>>,answer4 = <<"爷爷"/utf8>>};

get_question_cfg(1304) ->
	#gfeast_question_cfg{id = 1304,weight = 100,topic_type = 1,question = <<"美国历史上著名的演讲《我有一个梦想》的演讲者是谁"/utf8>>,right = 3,right_answer = <<"马丁路德金"/utf8>>,answer1 = <<"亚伯拉罕·林肯"/utf8>>,answer2 = <<"乔治·华盛顿"/utf8>>,answer3 = <<"马丁·路德·金"/utf8>>,answer4 = <<"约翰·亚当斯"/utf8>>};

get_question_cfg(1305) ->
	#gfeast_question_cfg{id = 1305,weight = 100,topic_type = 1,question = <<"电影《泰坦尼克号》的主题曲叫做"/utf8>>,right = 3,right_answer = <<"我心永恒"/utf8>>,answer1 = <<"真爱无敌"/utf8>>,answer2 = <<"生离死别"/utf8>>,answer3 = <<"我心永恒"/utf8>>,answer4 = <<"爱我别走"/utf8>>};

get_question_cfg(1306) ->
	#gfeast_question_cfg{id = 1306,weight = 100,topic_type = 1,question = <<"冰箱或空调泄露的哪种物质会破坏大气层臭氧层"/utf8>>,right = 3,right_answer = <<"氟利昂"/utf8>>,answer1 = <<"氧气"/utf8>>,answer2 = <<"二氧化碳"/utf8>>,answer3 = <<"氟利昂"/utf8>>,answer4 = <<"一氧化碳"/utf8>>};

get_question_cfg(1307) ->
	#gfeast_question_cfg{id = 1307,weight = 100,topic_type = 1,question = <<"现代奥运会起源于哪个国家"/utf8>>,right = 3,right_answer = <<"希腊"/utf8>>,answer1 = <<"雅典"/utf8>>,answer2 = <<"悉尼"/utf8>>,answer3 = <<"希腊"/utf8>>,answer4 = <<"北京"/utf8>>};

get_question_cfg(1308) ->
	#gfeast_question_cfg{id = 1308,weight = 100,topic_type = 1,question = <<"“遥知兄弟登高处，遍插茱萸少一人”，描述的是什么节日"/utf8>>,right = 3,right_answer = <<"重阳节"/utf8>>,answer1 = <<"端午节"/utf8>>,answer2 = <<"中秋节"/utf8>>,answer3 = <<"重阳节"/utf8>>,answer4 = <<"清明节"/utf8>>};

get_question_cfg(1309) ->
	#gfeast_question_cfg{id = 1309,weight = 100,topic_type = 1,question = <<"佛教中高僧经过火化后留下的结晶体，被作为圣物供奉的叫什么"/utf8>>,right = 3,right_answer = <<"舍利子"/utf8>>,answer1 = <<"圣晶"/utf8>>,answer2 = <<"佛珠"/utf8>>,answer3 = <<"舍利子"/utf8>>,answer4 = <<"圣石"/utf8>>};

get_question_cfg(1310) ->
	#gfeast_question_cfg{id = 1310,weight = 100,topic_type = 1,question = <<"《钢之炼金术师FA》中，角色张梅身边总跟着一只什么动物?"/utf8>>,right = 3,right_answer = <<"熊猫"/utf8>>,answer1 = <<"鸭子"/utf8>>,answer2 = <<"小狗"/utf8>>,answer3 = <<"熊猫"/utf8>>,answer4 = <<"猫猫"/utf8>>};

get_question_cfg(1311) ->
	#gfeast_question_cfg{id = 1311,weight = 100,topic_type = 1,question = <<"虚拟偶像初音未来的音源提供者是哪个声优?"/utf8>>,right = 3,right_answer = <<"藤田咲"/utf8>>,answer1 = <<"下田麻美"/utf8>>,answer2 = <<"浅川悠"/utf8>>,answer3 = <<"藤田咲"/utf8>>,answer4 = <<"中岛爱"/utf8>>};

get_question_cfg(1312) ->
	#gfeast_question_cfg{id = 1312,weight = 100,topic_type = 1,question = <<"传说中开天辟地的上古人物叫做什么"/utf8>>,right = 3,right_answer = <<"盘古"/utf8>>,answer1 = <<"女娲"/utf8>>,answer2 = <<"夸父"/utf8>>,answer3 = <<"盘古"/utf8>>,answer4 = <<"后羿"/utf8>>};

get_question_cfg(1313) ->
	#gfeast_question_cfg{id = 1313,weight = 100,topic_type = 1,question = <<"坐落在上海黄浦江畔的著名电视塔，叫做什么名字"/utf8>>,right = 3,right_answer = <<"东方明珠"/utf8>>,answer1 = <<"西方明珠"/utf8>>,answer2 = <<"北方明珠"/utf8>>,answer3 = <<"东方明珠"/utf8>>,answer4 = <<"南方明珠"/utf8>>};

get_question_cfg(1314) ->
	#gfeast_question_cfg{id = 1314,weight = 100,topic_type = 1,question = <<"1987年徐克导演拍的《倩女幽魂》中饰演宁采臣的男主角是谁"/utf8>>,right = 3,right_answer = <<"张国荣"/utf8>>,answer1 = <<"古天乐"/utf8>>,answer2 = <<"胡歌"/utf8>>,answer3 = <<"张国荣"/utf8>>,answer4 = <<"焦恩俊"/utf8>>};

get_question_cfg(1315) ->
	#gfeast_question_cfg{id = 1315,weight = 100,topic_type = 1,question = <<"⑨指的是东方project中的那个人物?"/utf8>>,right = 3,right_answer = <<"琪露诺"/utf8>>,answer1 = <<"魔理沙"/utf8>>,answer2 = <<"博丽灵梦"/utf8>>,answer3 = <<"琪露诺"/utf8>>,answer4 = <<"帕秋莉"/utf8>>};

get_question_cfg(1316) ->
	#gfeast_question_cfg{id = 1316,weight = 100,topic_type = 1,question = <<"经常听说的“工商管理硕士”的英文简称是什么"/utf8>>,right = 4,right_answer = <<"MBA"/utf8>>,answer1 = <<"NBA"/utf8>>,answer2 = <<"BBC"/utf8>>,answer3 = <<"NPC"/utf8>>,answer4 = <<"MBA"/utf8>>};

get_question_cfg(1317) ->
	#gfeast_question_cfg{id = 1317,weight = 100,topic_type = 1,question = <<"我国六大古都中建都最早的是那座城市"/utf8>>,right = 4,right_answer = <<"西安"/utf8>>,answer1 = <<"北京"/utf8>>,answer2 = <<"南京"/utf8>>,answer3 = <<"天津"/utf8>>,answer4 = <<"西安"/utf8>>};

get_question_cfg(1318) ->
	#gfeast_question_cfg{id = 1318,weight = 100,topic_type = 1,question = <<"一般被称为“万能献血者”的血型是什么"/utf8>>,right = 4,right_answer = <<"O型"/utf8>>,answer1 = <<"A型"/utf8>>,answer2 = <<"B型"/utf8>>,answer3 = <<"AB型"/utf8>>,answer4 = <<"O型"/utf8>>};

get_question_cfg(1319) ->
	#gfeast_question_cfg{id = 1319,weight = 100,topic_type = 1,question = <<"世界上第一家七星级酒店—“帆船酒店”，是在哪个城市"/utf8>>,right = 4,right_answer = <<"迪拜"/utf8>>,answer1 = <<"纽约"/utf8>>,answer2 = <<"悉尼"/utf8>>,answer3 = <<"巴黎"/utf8>>,answer4 = <<"迪拜"/utf8>>};

get_question_cfg(1320) ->
	#gfeast_question_cfg{id = 1320,weight = 100,topic_type = 1,question = <<"97年《还珠格格》中，因饰演小燕子一角而红遍亚洲的女演员是谁"/utf8>>,right = 4,right_answer = <<"赵薇"/utf8>>,answer1 = <<"林心如"/utf8>>,answer2 = <<"范冰冰"/utf8>>,answer3 = <<"王艳"/utf8>>,answer4 = <<"赵薇"/utf8>>};

get_question_cfg(1321) ->
	#gfeast_question_cfg{id = 1321,weight = 100,topic_type = 1,question = <<"经典台词“向我开炮!”出自中国哪一部老电影"/utf8>>,right = 4,right_answer = <<"英雄儿女"/utf8>>,answer1 = <<"亮剑"/utf8>>,answer2 = <<"开国大典"/utf8>>,answer3 = <<"风云儿女"/utf8>>,answer4 = <<"英雄儿女"/utf8>>};

get_question_cfg(1322) ->
	#gfeast_question_cfg{id = 1322,weight = 100,topic_type = 1,question = <<"二次元梗中：自古枪兵的幸运值是多少?"/utf8>>,right = 4,right_answer = <<"E"/utf8>>,answer1 = <<"B"/utf8>>,answer2 = <<"C"/utf8>>,answer3 = <<"D"/utf8>>,answer4 = <<"E"/utf8>>};

get_question_cfg(1323) ->
	#gfeast_question_cfg{id = 1323,weight = 100,topic_type = 1,question = <<"十二世纪十大画家之一，以画虾技术精湛而闻名的画家是谁"/utf8>>,right = 4,right_answer = <<"齐白石"/utf8>>,answer1 = <<"张大千"/utf8>>,answer2 = <<"徐悲鸿"/utf8>>,answer3 = <<"吴冠中"/utf8>>,answer4 = <<"齐白石"/utf8>>};

get_question_cfg(1324) ->
	#gfeast_question_cfg{id = 1324,weight = 100,topic_type = 1,question = <<"《西游记》中孙悟空的一个跟斗可以翻多远"/utf8>>,right = 4,right_answer = <<"十万八千里"/utf8>>,answer1 = <<"十万八百里"/utf8>>,answer2 = <<"十八万八千里"/utf8>>,answer3 = <<"十八万八百里"/utf8>>,answer4 = <<"十万八千里"/utf8>>};

get_question_cfg(1325) ->
	#gfeast_question_cfg{id = 1325,weight = 100,topic_type = 1,question = <<"“西边的太阳快要落山了”这句歌词是出自哪部电影的插曲"/utf8>>,right = 4,right_answer = <<"铁道游击队"/utf8>>,answer1 = <<"地道战"/utf8>>,answer2 = <<"亮剑"/utf8>>,answer3 = <<"英雄儿女"/utf8>>,answer4 = <<"铁道游击队"/utf8>>};

get_question_cfg(1326) ->
	#gfeast_question_cfg{id = 1326,weight = 100,topic_type = 1,question = <<"中国的“雾都”是指哪个城市"/utf8>>,right = 4,right_answer = <<"重庆"/utf8>>,answer1 = <<"银川"/utf8>>,answer2 = <<"长春"/utf8>>,answer3 = <<"沈阳"/utf8>>,answer4 = <<"重庆"/utf8>>};

get_question_cfg(1327) ->
	#gfeast_question_cfg{id = 1327,weight = 100,topic_type = 1,question = <<"排球比赛中，一个队可以同时上场几名队员"/utf8>>,right = 4,right_answer = <<"6人"/utf8>>,answer1 = <<"3人"/utf8>>,answer2 = <<"4人"/utf8>>,answer3 = <<"5人"/utf8>>,answer4 = <<"6人"/utf8>>};

get_question_cfg(1328) ->
	#gfeast_question_cfg{id = 1328,weight = 100,topic_type = 1,question = <<"吃多了皮蛋会造成哪种重金属元素中毒"/utf8>>,right = 4,right_answer = <<"铅"/utf8>>,answer1 = <<"铊"/utf8>>,answer2 = <<"砷"/utf8>>,answer3 = <<"镁"/utf8>>,answer4 = <<"铅"/utf8>>};

get_question_cfg(1329) ->
	#gfeast_question_cfg{id = 1329,weight = 100,topic_type = 1,question = <<"人体分解和代谢酒精的主要器官是什么"/utf8>>,right = 4,right_answer = <<"肝"/utf8>>,answer1 = <<"肾"/utf8>>,answer2 = <<"胃"/utf8>>,answer3 = <<"心"/utf8>>,answer4 = <<"肝"/utf8>>};

get_question_cfg(1330) ->
	#gfeast_question_cfg{id = 1330,weight = 100,topic_type = 1,question = <<"电影《功夫》中，火云邪神最后被什么武功招式打败"/utf8>>,right = 4,right_answer = <<"如来神掌"/utf8>>,answer1 = <<"龟派气功"/utf8>>,answer2 = <<"化骨绵掌"/utf8>>,answer3 = <<"九阳神功"/utf8>>,answer4 = <<"如来神掌"/utf8>>};

get_question_cfg(1331) ->
	#gfeast_question_cfg{id = 1331,weight = 100,topic_type = 1,question = <<"相传太极拳是由武当山哪位道士所创"/utf8>>,right = 4,right_answer = <<"张三丰"/utf8>>,answer1 = <<"张道陵"/utf8>>,answer2 = <<"吕洞宾"/utf8>>,answer3 = <<"林灵素"/utf8>>,answer4 = <<"张三丰"/utf8>>};

get_question_cfg(1332) ->
	#gfeast_question_cfg{id = 1332,weight = 100,topic_type = 1,question = <<"蝌蚪靠什么呼吸"/utf8>>,right = 4,right_answer = <<"鳃"/utf8>>,answer1 = <<"鼻子"/utf8>>,answer2 = <<"嘴巴"/utf8>>,answer3 = <<"眼睛"/utf8>>,answer4 = <<"鳃"/utf8>>};

get_question_cfg(1333) ->
	#gfeast_question_cfg{id = 1333,weight = 100,topic_type = 1,question = <<"“阿姆斯特朗回旋加速喷气式阿姆斯特朗炮”的名字出自哪部动漫?"/utf8>>,right = 4,right_answer = <<"银魂"/utf8>>,answer1 = <<"死神"/utf8>>,answer2 = <<"火影忍者"/utf8>>,answer3 = <<"犬夜叉"/utf8>>,answer4 = <<"银魂"/utf8>>};

get_question_cfg(1334) ->
	#gfeast_question_cfg{id = 1334,weight = 100,topic_type = 1,question = <<"电影《白毛女》中，抢走喜儿的地主叫什么名字"/utf8>>,right = 4,right_answer = <<"黄世仁"/utf8>>,answer1 = <<"李世仁"/utf8>>,answer2 = <<"赵世仁"/utf8>>,answer3 = <<"孙世仁"/utf8>>,answer4 = <<"黄世仁"/utf8>>};

get_question_cfg(1335) ->
	#gfeast_question_cfg{id = 1335,weight = 100,topic_type = 1,question = <<"歇后语”泥菩萨过河“的下一句是什么"/utf8>>,right = 4,right_answer = <<"自身难保"/utf8>>,answer1 = <<"胆子肥"/utf8>>,answer2 = <<"水土交融"/utf8>>,answer3 = <<"必须坐船"/utf8>>,answer4 = <<"自身难保"/utf8>>};

get_question_cfg(1336) ->
	#gfeast_question_cfg{id = 1336,weight = 100,topic_type = 1,question = <<"景泰蓝是中国哪个城市的著名手工艺品"/utf8>>,right = 4,right_answer = <<"北京"/utf8>>,answer1 = <<"天津"/utf8>>,answer2 = <<"上海"/utf8>>,answer3 = <<"广州"/utf8>>,answer4 = <<"北京"/utf8>>};

get_question_cfg(1337) ->
	#gfeast_question_cfg{id = 1337,weight = 100,topic_type = 1,question = <<"美国历史上唯一一位任期达四届的总统是"/utf8>>,right = 4,right_answer = <<"罗斯福"/utf8>>,answer1 = <<"林肯"/utf8>>,answer2 = <<"华盛顿"/utf8>>,answer3 = <<"亚当斯"/utf8>>,answer4 = <<"罗斯福"/utf8>>};

get_question_cfg(1338) ->
	#gfeast_question_cfg{id = 1338,weight = 100,topic_type = 1,question = <<"泼水节是我国哪个民族的传统节日也是他们的新年"/utf8>>,right = 4,right_answer = <<"傣族"/utf8>>,answer1 = <<"回族"/utf8>>,answer2 = <<"苗族"/utf8>>,answer3 = <<"藏族"/utf8>>,answer4 = <<"傣族"/utf8>>};

get_question_cfg(1339) ->
	#gfeast_question_cfg{id = 1339,weight = 100,topic_type = 1,question = <<"在感恩节这天，美国的家庭基本上都会吃的一道传统食物是什么"/utf8>>,right = 4,right_answer = <<"火鸡"/utf8>>,answer1 = <<"烤猪"/utf8>>,answer2 = <<"肥牛"/utf8>>,answer3 = <<"肥羊"/utf8>>,answer4 = <<"火鸡"/utf8>>};

get_question_cfg(1340) ->
	#gfeast_question_cfg{id = 1340,weight = 100,topic_type = 1,question = <<"电视剧《新白娘子传奇》中，白素贞被压在什么塔中"/utf8>>,right = 4,right_answer = <<"雷峰塔"/utf8>>,answer1 = <<"大雁塔"/utf8>>,answer2 = <<"六和塔"/utf8>>,answer3 = <<"飞虹塔"/utf8>>,answer4 = <<"雷峰塔"/utf8>>};

get_question_cfg(1341) ->
	#gfeast_question_cfg{id = 1341,weight = 100,topic_type = 1,question = <<"1986版《西游记》中孙悟空的扮演者是叫什么名字"/utf8>>,right = 4,right_answer = <<"六小龄童"/utf8>>,answer1 = <<"三小龄童"/utf8>>,answer2 = <<"四小龄童"/utf8>>,answer3 = <<"五小龄童"/utf8>>,answer4 = <<"六小龄童"/utf8>>};

get_question_cfg(1342) ->
	#gfeast_question_cfg{id = 1342,weight = 100,topic_type = 1,question = <<"被称为”天府之国“的地方是我国的哪个省"/utf8>>,right = 4,right_answer = <<"四川"/utf8>>,answer1 = <<"成都"/utf8>>,answer2 = <<"重庆"/utf8>>,answer3 = <<"贵阳"/utf8>>,answer4 = <<"四川"/utf8>>};

get_question_cfg(1343) ->
	#gfeast_question_cfg{id = 1343,weight = 100,topic_type = 1,question = <<"川菜”蚂蚁上树“的主要食材是肉末炒什么"/utf8>>,right = 4,right_answer = <<"粉丝"/utf8>>,answer1 = <<"白菜"/utf8>>,answer2 = <<"韭菜"/utf8>>,answer3 = <<"豆腐"/utf8>>,answer4 = <<"粉丝"/utf8>>};

get_question_cfg(1344) ->
	#gfeast_question_cfg{id = 1344,weight = 100,topic_type = 1,question = <<"驴打滚源于满洲，是我国哪个城市的古老小吃品种之一"/utf8>>,right = 4,right_answer = <<"北京"/utf8>>,answer1 = <<"南京"/utf8>>,answer2 = <<"天津"/utf8>>,answer3 = <<"西安"/utf8>>,answer4 = <<"北京"/utf8>>};

get_question_cfg(1345) ->
	#gfeast_question_cfg{id = 1345,weight = 100,topic_type = 1,question = <<"人体缺少哪种元素会引起甲状腺肿大，俗称大脖子病"/utf8>>,right = 4,right_answer = <<"碘"/utf8>>,answer1 = <<"钙"/utf8>>,answer2 = <<"铁"/utf8>>,answer3 = <<"锌"/utf8>>,answer4 = <<"碘"/utf8>>};

get_question_cfg(1346) ->
	#gfeast_question_cfg{id = 1346,weight = 100,topic_type = 1,question = <<"李白笔下的“飞流直下三千尺，疑是银河落九天”指的是哪个风景区?"/utf8>>,right = 4,right_answer = <<"庐山"/utf8>>,answer1 = <<"华山"/utf8>>,answer2 = <<"衡山"/utf8>>,answer3 = <<"嵩山"/utf8>>,answer4 = <<"庐山"/utf8>>};

get_question_cfg(1347) ->
	#gfeast_question_cfg{id = 1347,weight = 100,topic_type = 1,question = <<"《西游记》中的火焰山位于："/utf8>>,right = 4,right_answer = <<"新疆"/utf8>>,answer1 = <<"西藏"/utf8>>,answer2 = <<"青海"/utf8>>,answer3 = <<"四川"/utf8>>,answer4 = <<"新疆"/utf8>>};

get_question_cfg(1348) ->
	#gfeast_question_cfg{id = 1348,weight = 100,topic_type = 1,question = <<"古代小说常用“沉鱼落雁，闭月羞花”形容女性之美，其中“沉鱼”是指："/utf8>>,right = 2,right_answer = <<"西施"/utf8>>,answer1 = <<"杨玉环"/utf8>>,answer2 = <<"西施"/utf8>>,answer3 = <<"王昭君"/utf8>>,answer4 = <<"貂蝉"/utf8>>};

get_question_cfg(1349) ->
	#gfeast_question_cfg{id = 1349,weight = 100,topic_type = 1,question = <<"古代小说常用“沉鱼落雁，闭月羞花”形容女性之美，其中“落雁”是指："/utf8>>,right = 3,right_answer = <<"王昭君"/utf8>>,answer1 = <<"杨玉环"/utf8>>,answer2 = <<"西施"/utf8>>,answer3 = <<"王昭君"/utf8>>,answer4 = <<"貂蝉"/utf8>>};

get_question_cfg(1350) ->
	#gfeast_question_cfg{id = 1350,weight = 100,topic_type = 1,question = <<"古代小说常用“沉鱼落雁，闭月羞花”形容女性之美，其中“闭月”是指："/utf8>>,right = 4,right_answer = <<"貂蝉"/utf8>>,answer1 = <<"杨玉环"/utf8>>,answer2 = <<"西施"/utf8>>,answer3 = <<"王昭君"/utf8>>,answer4 = <<"貂蝉"/utf8>>};

get_question_cfg(1351) ->
	#gfeast_question_cfg{id = 1351,weight = 100,topic_type = 1,question = <<"古代小说常用“沉鱼落雁，闭月羞花”形容女性之美，其中“羞花”是指："/utf8>>,right = 1,right_answer = <<"杨玉环"/utf8>>,answer1 = <<"杨玉环"/utf8>>,answer2 = <<"西施"/utf8>>,answer3 = <<"王昭君"/utf8>>,answer4 = <<"貂蝉"/utf8>>};

get_question_cfg(1352) ->
	#gfeast_question_cfg{id = 1352,weight = 100,topic_type = 1,question = <<"东床快婿原本是指："/utf8>>,right = 4,right_answer = <<"王羲之"/utf8>>,answer1 = <<"颜真卿"/utf8>>,answer2 = <<"柳公权"/utf8>>,answer3 = <<"欧阳修"/utf8>>,answer4 = <<"王羲之"/utf8>>};

get_question_cfg(1353) ->
	#gfeast_question_cfg{id = 1353,weight = 100,topic_type = 1,question = <<"“写鬼写妖高人一筹，刺贪刺虐入木三分”这一对联写的作家是"/utf8>>,right = 4,right_answer = <<"蒲松龄"/utf8>>,answer1 = <<"屈原"/utf8>>,answer2 = <<"鬼谷子"/utf8>>,answer3 = <<"王羲之"/utf8>>,answer4 = <<"蒲松龄"/utf8>>};

get_question_cfg(1354) ->
	#gfeast_question_cfg{id = 1354,weight = 100,topic_type = 1,question = <<"《魔法少女小圆》的编剧(脚本)是谁?"/utf8>>,right = 4,right_answer = <<"虚渊玄"/utf8>>,answer1 = <<"伊藤润二"/utf8>>,answer2 = <<"冈本伦"/utf8>>,answer3 = <<"小高和刚"/utf8>>,answer4 = <<"虚渊玄"/utf8>>};

get_question_cfg(1355) ->
	#gfeast_question_cfg{id = 1355,weight = 100,topic_type = 1,question = <<"最长的腿(打一成语)"/utf8>>,right = 1,right_answer = <<"一步登天"/utf8>>,answer1 = <<"一步登天"/utf8>>,answer2 = <<"天涯海角"/utf8>>,answer3 = <<"一字千金"/utf8>>,answer4 = <<"顶天立地"/utf8>>};

get_question_cfg(1356) ->
	#gfeast_question_cfg{id = 1356,weight = 100,topic_type = 1,question = <<"最遥远的地方(打一成语)"/utf8>>,right = 2,right_answer = <<"天涯海角"/utf8>>,answer1 = <<"一步登天"/utf8>>,answer2 = <<"天涯海角"/utf8>>,answer3 = <<"一字千金"/utf8>>,answer4 = <<"顶天立地"/utf8>>};

get_question_cfg(1357) ->
	#gfeast_question_cfg{id = 1357,weight = 100,topic_type = 1,question = <<"最贵的稿费(打一成语)"/utf8>>,right = 3,right_answer = <<"一字千金"/utf8>>,answer1 = <<"一步登天"/utf8>>,answer2 = <<"天涯海角"/utf8>>,answer3 = <<"一字千金"/utf8>>,answer4 = <<"顶天立地"/utf8>>};

get_question_cfg(1358) ->
	#gfeast_question_cfg{id = 1358,weight = 100,topic_type = 1,question = <<"最高的巨人(打一成语)"/utf8>>,right = 4,right_answer = <<"顶天立地"/utf8>>,answer1 = <<"一步登天"/utf8>>,answer2 = <<"天涯海角"/utf8>>,answer3 = <<"一字千金"/utf8>>,answer4 = <<"顶天立地"/utf8>>};

get_question_cfg(1359) ->
	#gfeast_question_cfg{id = 1359,weight = 100,topic_type = 1,question = <<"动漫《火影忍者》中，宇智波佐助所拥有的瞳术的名字是?"/utf8>>,right = 4,right_answer = <<"写轮眼"/utf8>>,answer1 = <<"阴阳眼"/utf8>>,answer2 = <<"石化眼"/utf8>>,answer3 = <<"万花眼"/utf8>>,answer4 = <<"写轮眼"/utf8>>};

get_question_cfg(1360) ->
	#gfeast_question_cfg{id = 1360,weight = 100,topic_type = 1,question = <<"文房四宝指的是哪四件东西?"/utf8>>,right = 4,right_answer = <<"笔墨纸砚"/utf8>>,answer1 = <<"梅兰竹菊"/utf8>>,answer2 = <<"柴米油盐"/utf8>>,answer3 = <<"春夏秋冬"/utf8>>,answer4 = <<"笔墨纸砚"/utf8>>};

get_question_cfg(1361) ->
	#gfeast_question_cfg{id = 1361,weight = 100,topic_type = 1,question = <<"动漫《银魂》中，万事屋老板的名字是?"/utf8>>,right = 4,right_answer = <<"坂田银时"/utf8>>,answer1 = <<"志村新八"/utf8>>,answer2 = <<"伊丽莎白"/utf8>>,answer3 = <<"神乐"/utf8>>,answer4 = <<"坂田银时"/utf8>>};

get_question_cfg(1362) ->
	#gfeast_question_cfg{id = 1362,weight = 100,topic_type = 1,question = <<"“恋爱循环”的演唱者是？"/utf8>>,right = 4,right_answer = <<"花泽香菜"/utf8>>,answer1 = <<"仓木麻衣"/utf8>>,answer2 = <<"井口裕香"/utf8>>,answer3 = <<"中岛爱"/utf8>>,answer4 = <<"花泽香菜"/utf8>>};

get_question_cfg(1363) ->
	#gfeast_question_cfg{id = 1363,weight = 100,topic_type = 1,question = <<"在动漫《叛逆的鲁路修》中，C.C.的头发的颜色是?"/utf8>>,right = 4,right_answer = <<"绿色"/utf8>>,answer1 = <<"金色"/utf8>>,answer2 = <<"红色"/utf8>>,answer3 = <<"粉色"/utf8>>,answer4 = <<"绿色"/utf8>>};

get_question_cfg(1364) ->
	#gfeast_question_cfg{id = 1364,weight = 100,topic_type = 1,question = <<"以下哪一部作品的剧本不是虚渊玄所写?"/utf8>>,right = 4,right_answer = <<"弹丸论破"/utf8>>,answer1 = <<"沙耶之歌"/utf8>>,answer2 = <<"Fate/Zero"/utf8>>,answer3 = <<"魔法少女小圆"/utf8>>,answer4 = <<"弹丸论破"/utf8>>};

get_question_cfg(1365) ->
	#gfeast_question_cfg{id = 1365,weight = 100,topic_type = 1,question = <<"钉宫四萌哪个出现的最早?"/utf8>>,right = 4,right_answer = <<"夏娜"/utf8>>,answer1 = <<"露易丝"/utf8>>,answer2 = <<"三千院凪"/utf8>>,answer3 = <<"逢坂大河"/utf8>>,answer4 = <<"夏娜"/utf8>>};

get_question_cfg(1366) ->
	#gfeast_question_cfg{id = 1366,weight = 100,topic_type = 1,question = <<"“白学”是对哪部作品的研究与讨论？"/utf8>>,right = 4,right_answer = <<"白色相簿2"/utf8>>,answer1 = <<"赤发白雪姬"/utf8>>,answer2 = <<"纯白交响曲"/utf8>>,answer3 = <<"白色相簿"/utf8>>,answer4 = <<"白色相簿2"/utf8>>};

get_question_cfg(1367) ->
	#gfeast_question_cfg{id = 1367,weight = 100,topic_type = 1,question = <<"冬瓜黄瓜西瓜南瓜都能吃，什么瓜不能吃?"/utf8>>,right = 4,right_answer = <<"傻瓜"/utf8>>,answer1 = <<"冬瓜"/utf8>>,answer2 = <<"南瓜"/utf8>>,answer3 = <<"西瓜"/utf8>>,answer4 = <<"傻瓜"/utf8>>};

get_question_cfg(1368) ->
	#gfeast_question_cfg{id = 1368,weight = 100,topic_type = 1,question = <<"Key社三大催泪弹中，不包括以下哪一部？"/utf8>>,right = 4,right_answer = <<"little busters!"/utf8>>,answer1 = <<"clannad"/utf8>>,answer2 = <<"air"/utf8>>,answer3 = <<"kanon"/utf8>>,answer4 = <<"little busters!"/utf8>>};

get_question_cfg(1369) ->
	#gfeast_question_cfg{id = 1369,weight = 100,topic_type = 1,question = <<"依照西方习俗，订婚戒指戴在左手哪根手指上?"/utf8>>,right = 4,right_answer = <<"无名指"/utf8>>,answer1 = <<"大拇指"/utf8>>,answer2 = <<"食指"/utf8>>,answer3 = <<"中指"/utf8>>,answer4 = <<"无名指"/utf8>>};

get_question_cfg(1370) ->
	#gfeast_question_cfg{id = 1370,weight = 100,topic_type = 1,question = <<"举世闻名的泰姬陵在哪个国家?"/utf8>>,right = 4,right_answer = <<"印度"/utf8>>,answer1 = <<"中国"/utf8>>,answer2 = <<"缅甸"/utf8>>,answer3 = <<"伊朗"/utf8>>,answer4 = <<"印度"/utf8>>};

get_question_cfg(1371) ->
	#gfeast_question_cfg{id = 1371,weight = 100,topic_type = 1,question = <<"人体消化道中最长的器官是："/utf8>>,right = 4,right_answer = <<"小肠"/utf8>>,answer1 = <<"胃"/utf8>>,answer2 = <<"肝"/utf8>>,answer3 = <<"大肠"/utf8>>,answer4 = <<"小肠"/utf8>>};

get_question_cfg(1372) ->
	#gfeast_question_cfg{id = 1372,weight = 100,topic_type = 1,question = <<"美国历史上第一所高等学府是："/utf8>>,right = 4,right_answer = <<"哈佛大学"/utf8>>,answer1 = <<"剑桥大学"/utf8>>,answer2 = <<"耶鲁大学"/utf8>>,answer3 = <<"杜克大学"/utf8>>,answer4 = <<"哈佛大学"/utf8>>};

get_question_cfg(1373) ->
	#gfeast_question_cfg{id = 1373,weight = 100,topic_type = 1,question = <<"宫崎骏唯一获得奥斯卡最佳动画长篇奖项的动画电影是?"/utf8>>,right = 4,right_answer = <<"千与千寻"/utf8>>,answer1 = <<"龙猫"/utf8>>,answer2 = <<"哈尔的移动城堡"/utf8>>,answer3 = <<"悬崖上的金鱼姬"/utf8>>,answer4 = <<"千与千寻"/utf8>>};

get_question_cfg(1374) ->
	#gfeast_question_cfg{id = 1374,weight = 100,topic_type = 1,question = <<"“建元”是中国古代哪一个皇帝使用的年号?"/utf8>>,right = 4,right_answer = <<"汉武帝"/utf8>>,answer1 = <<"汉高祖"/utf8>>,answer2 = <<"汉文帝"/utf8>>,answer3 = <<"汉景帝"/utf8>>,answer4 = <<"汉武帝"/utf8>>};

get_question_cfg(1375) ->
	#gfeast_question_cfg{id = 1375,weight = 100,topic_type = 1,question = <<"谁证明了地球是圆的?"/utf8>>,right = 4,right_answer = <<"麦哲伦"/utf8>>,answer1 = <<"郑和"/utf8>>,answer2 = <<"哥伦布"/utf8>>,answer3 = <<"亚历山大"/utf8>>,answer4 = <<"麦哲伦"/utf8>>};

get_question_cfg(1376) ->
	#gfeast_question_cfg{id = 1376,weight = 100,topic_type = 1,question = <<"《哆啦A梦》中多啦A梦是从什么时代来的?"/utf8>>,right = 4,right_answer = <<"22世纪"/utf8>>,answer1 = <<"19世纪"/utf8>>,answer2 = <<"20世纪"/utf8>>,answer3 = <<"21世纪"/utf8>>,answer4 = <<"22世纪"/utf8>>};

get_question_cfg(1377) ->
	#gfeast_question_cfg{id = 1377,weight = 100,topic_type = 1,question = <<"欧洲最长的河流是?"/utf8>>,right = 4,right_answer = <<"伏尔加河"/utf8>>,answer1 = <<"多瑙河"/utf8>>,answer2 = <<"莱茵河"/utf8>>,answer3 = <<"顿河"/utf8>>,answer4 = <<"伏尔加河"/utf8>>};

get_question_cfg(1378) ->
	#gfeast_question_cfg{id = 1378,weight = 100,topic_type = 1,question = <<"《义勇军进行曲》是哪部电影的主题歌?"/utf8>>,right = 4,right_answer = <<"风云儿女"/utf8>>,answer1 = <<"英雄儿女"/utf8>>,answer2 = <<"亮剑"/utf8>>,answer3 = <<"开国大典"/utf8>>,answer4 = <<"风云儿女"/utf8>>};

get_question_cfg(1379) ->
	#gfeast_question_cfg{id = 1379,weight = 100,topic_type = 1,question = <<"《命运石之门》男主角的真名是?"/utf8>>,right = 4,right_answer = <<"冈部伦太郎"/utf8>>,answer1 = <<"狂气的科学家"/utf8>>,answer2 = <<"凤凰院凶真"/utf8>>,answer3 = <<"冈伦"/utf8>>,answer4 = <<"冈部伦太郎"/utf8>>};

get_question_cfg(1380) ->
	#gfeast_question_cfg{id = 1380,weight = 100,topic_type = 1,question = <<"马头琴是我国哪一民族的拉弦乐器?"/utf8>>,right = 4,right_answer = <<"蒙古族"/utf8>>,answer1 = <<"满族"/utf8>>,answer2 = <<"回族"/utf8>>,answer3 = <<"藏族"/utf8>>,answer4 = <<"蒙古族"/utf8>>};

get_question_cfg(1381) ->
	#gfeast_question_cfg{id = 1381,weight = 100,topic_type = 1,question = <<"被称为“诗圣”的唐代诗人为："/utf8>>,right = 4,right_answer = <<"杜甫"/utf8>>,answer1 = <<"李白"/utf8>>,answer2 = <<"李贺"/utf8>>,answer3 = <<"李商隐"/utf8>>,answer4 = <<"杜甫"/utf8>>};

get_question_cfg(1382) ->
	#gfeast_question_cfg{id = 1382,weight = 100,topic_type = 1,question = <<"“变脸”是哪个剧种的绝活?"/utf8>>,right = 4,right_answer = <<"川剧"/utf8>>,answer1 = <<"京剧"/utf8>>,answer2 = <<"越剧"/utf8>>,answer3 = <<"湘剧"/utf8>>,answer4 = <<"川剧"/utf8>>};

get_question_cfg(1383) ->
	#gfeast_question_cfg{id = 1383,weight = 100,topic_type = 1,question = <<"屈原是春秋时代哪国人?"/utf8>>,right = 4,right_answer = <<"楚国"/utf8>>,answer1 = <<"齐国"/utf8>>,answer2 = <<"燕国"/utf8>>,answer3 = <<"韩国"/utf8>>,answer4 = <<"楚国"/utf8>>};

get_question_cfg(1384) ->
	#gfeast_question_cfg{id = 1384,weight = 100,topic_type = 1,question = <<"被称为“命运交响曲”的是贝多芬的第几交响曲?"/utf8>>,right = 4,right_answer = <<"5"/utf8>>,answer1 = <<"2"/utf8>>,answer2 = <<"3"/utf8>>,answer3 = <<"4"/utf8>>,answer4 = <<"5"/utf8>>};

get_question_cfg(1385) ->
	#gfeast_question_cfg{id = 1385,weight = 100,topic_type = 1,question = <<"洛天依的声源是?"/utf8>>,right = 4,right_answer = <<"山新"/utf8>>,answer1 = <<"刘校妤"/utf8>>,answer2 = <<"醋醋"/utf8>>,answer3 = <<"小连杀"/utf8>>,answer4 = <<"山新"/utf8>>};

get_question_cfg(1386) ->
	#gfeast_question_cfg{id = 1386,weight = 100,topic_type = 1,question = <<"被网友戏称为“垃圾君”的是以下哪部动画的男主角？"/utf8>>,right = 4,right_answer = <<"化物语"/utf8>>,answer1 = <<"幸运星"/utf8>>,answer2 = <<"爱杀宝贝"/utf8>>,answer3 = <<"天降之物"/utf8>>,answer4 = <<"化物语"/utf8>>};

get_question_cfg(1387) ->
	#gfeast_question_cfg{id = 1387,weight = 100,topic_type = 1,question = <<"“知天命”代指多少岁?"/utf8>>,right = 4,right_answer = <<"50"/utf8>>,answer1 = <<"20"/utf8>>,answer2 = <<"30"/utf8>>,answer3 = <<"40"/utf8>>,answer4 = <<"50"/utf8>>};

get_question_cfg(1388) ->
	#gfeast_question_cfg{id = 1388,weight = 100,topic_type = 1,question = <<"吉他有几根弦?"/utf8>>,right = 4,right_answer = <<"6"/utf8>>,answer1 = <<"3"/utf8>>,answer2 = <<"4"/utf8>>,answer3 = <<"5"/utf8>>,answer4 = <<"6"/utf8>>};

get_question_cfg(1389) ->
	#gfeast_question_cfg{id = 1389,weight = 100,topic_type = 1,question = <<"世界上最大的宫殿是："/utf8>>,right = 4,right_answer = <<"故宫"/utf8>>,answer1 = <<"卢浮宫"/utf8>>,answer2 = <<"白宫"/utf8>>,answer3 = <<"泰姬陵"/utf8>>,answer4 = <<"故宫"/utf8>>};

get_question_cfg(1390) ->
	#gfeast_question_cfg{id = 1390,weight = 100,topic_type = 1,question = <<"蒙奇· D · 路飞出自哪个作品?"/utf8>>,right = 4,right_answer = <<"海贼王"/utf8>>,answer1 = <<"银魂"/utf8>>,answer2 = <<"进击的巨人"/utf8>>,answer3 = <<"死神"/utf8>>,answer4 = <<"海贼王"/utf8>>};

get_question_cfg(1391) ->
	#gfeast_question_cfg{id = 1391,weight = 100,topic_type = 1,question = <<"被誉为“诗鬼”的唐代诗人是谁?"/utf8>>,right = 4,right_answer = <<"李贺"/utf8>>,answer1 = <<"李白"/utf8>>,answer2 = <<"李商隐"/utf8>>,answer3 = <<"杜甫"/utf8>>,answer4 = <<"李贺"/utf8>>};

get_question_cfg(1392) ->
	#gfeast_question_cfg{id = 1392,weight = 100,topic_type = 1,question = <<"世界卫生组织的英文缩写是："/utf8>>,right = 4,right_answer = <<"WHO"/utf8>>,answer1 = <<"WTO"/utf8>>,answer2 = <<"UFO"/utf8>>,answer3 = <<"CPU"/utf8>>,answer4 = <<"WHO"/utf8>>};

get_question_cfg(1393) ->
	#gfeast_question_cfg{id = 1393,weight = 100,topic_type = 1,question = <<"《中二病也要谈恋爱》中小鸟游六花的姐姐叫什么名字?"/utf8>>,right = 4,right_answer = <<"小鸟游十花"/utf8>>,answer1 = <<"小鸟游七花"/utf8>>,answer2 = <<"小鸟游八花"/utf8>>,answer3 = <<"小鸟游九花"/utf8>>,answer4 = <<"小鸟游十花"/utf8>>};

get_question_cfg(1394) ->
	#gfeast_question_cfg{id = 1394,weight = 100,topic_type = 1,question = <<"公元618-907年，是我国古代的哪个朝代?"/utf8>>,right = 4,right_answer = <<"唐代"/utf8>>,answer1 = <<"晋朝"/utf8>>,answer2 = <<"南北朝"/utf8>>,answer3 = <<"隋朝"/utf8>>,answer4 = <<"唐代"/utf8>>};

get_question_cfg(1395) ->
	#gfeast_question_cfg{id = 1395,weight = 100,topic_type = 1,question = <<"哪项比赛是往后跑的?"/utf8>>,right = 4,right_answer = <<"拔河"/utf8>>,answer1 = <<"两人三足"/utf8>>,answer2 = <<"跨栏"/utf8>>,answer3 = <<"跳远"/utf8>>,answer4 = <<"拔河"/utf8>>};

get_question_cfg(1396) ->
	#gfeast_question_cfg{id = 1396,weight = 100,topic_type = 1,question = <<"左无右有前无后有(打一个字)"/utf8>>,right = 4,right_answer = <<"口"/utf8>>,answer1 = <<"心"/utf8>>,answer2 = <<"田"/utf8>>,answer3 = <<"一"/utf8>>,answer4 = <<"口"/utf8>>};

get_question_cfg(1397) ->
	#gfeast_question_cfg{id = 1397,weight = 100,topic_type = 1,question = <<"什么样的东西是假的，也有人愿意买?"/utf8>>,right = 4,right_answer = <<"假发"/utf8>>,answer1 = <<"手表"/utf8>>,answer2 = <<"包"/utf8>>,answer3 = <<"眼镜"/utf8>>,answer4 = <<"假发"/utf8>>};

get_question_cfg(1398) ->
	#gfeast_question_cfg{id = 1398,weight = 100,topic_type = 1,question = <<"什么字大家都会念错?"/utf8>>,right = 4,right_answer = <<"错"/utf8>>,answer1 = <<"淼"/utf8>>,answer2 = <<"耄"/utf8>>,answer3 = <<"冼"/utf8>>,answer4 = <<"错"/utf8>>};

get_question_cfg(1399) ->
	#gfeast_question_cfg{id = 1399,weight = 100,topic_type = 1,question = <<"8个人吃8份快餐需10分钟,16个人吃16份快餐需几分钟?"/utf8>>,right = 4,right_answer = <<"10"/utf8>>,answer1 = <<"4"/utf8>>,answer2 = <<"6"/utf8>>,answer3 = <<"8"/utf8>>,answer4 = <<"10"/utf8>>};

get_question_cfg(1400) ->
	#gfeast_question_cfg{id = 1400,weight = 100,topic_type = 1,question = <<"春秋战国时期，哪家学说的主张是“兼爱”“非攻”"/utf8>>,right = 4,right_answer = <<"墨家"/utf8>>,answer1 = <<"儒家"/utf8>>,answer2 = <<"法家"/utf8>>,answer3 = <<"道家"/utf8>>,answer4 = <<"墨家"/utf8>>};

get_question_cfg(1401) ->
	#gfeast_question_cfg{id = 1401,weight = 100,topic_type = 1,question = <<"人体最大的器官是："/utf8>>,right = 4,right_answer = <<"皮肤"/utf8>>,answer1 = <<"心脏"/utf8>>,answer2 = <<"大脑"/utf8>>,answer3 = <<"骨头"/utf8>>,answer4 = <<"皮肤"/utf8>>};

get_question_cfg(1402) ->
	#gfeast_question_cfg{id = 1402,weight = 100,topic_type = 1,question = <<"WTO是哪个组织的称呼?"/utf8>>,right = 4,right_answer = <<"世界贸易组织"/utf8>>,answer1 = <<"工商管理硕士"/utf8>>,answer2 = <<"世界卫生组织"/utf8>>,answer3 = <<"红十字会"/utf8>>,answer4 = <<"世界贸易组织"/utf8>>};

get_question_cfg(1403) ->
	#gfeast_question_cfg{id = 1403,weight = 100,topic_type = 1,question = <<"在所有植物中，什么植物是最老实的?"/utf8>>,right = 4,right_answer = <<"芭蕉"/utf8>>,answer1 = <<"苹果"/utf8>>,answer2 = <<"香蕉"/utf8>>,answer3 = <<"桃子"/utf8>>,answer4 = <<"芭蕉"/utf8>>};

get_question_cfg(1404) ->
	#gfeast_question_cfg{id = 1404,weight = 100,topic_type = 1,question = <<"在缩写“ACG”中字母“G”代表什么?"/utf8>>,right = 4,right_answer = <<"游戏"/utf8>>,answer1 = <<"动画"/utf8>>,answer2 = <<"漫画"/utf8>>,answer3 = <<"小说"/utf8>>,answer4 = <<"游戏"/utf8>>};

get_question_cfg(1405) ->
	#gfeast_question_cfg{id = 1405,weight = 100,topic_type = 1,question = <<"世界上面积最大的岛屿是？"/utf8>>,right = 4,right_answer = <<"格陵兰岛"/utf8>>,answer1 = <<"新几内亚岛"/utf8>>,answer2 = <<"马达加斯加岛"/utf8>>,answer3 = <<"苏门答腊岛"/utf8>>,answer4 = <<"格陵兰岛"/utf8>>};

get_question_cfg(1406) ->
	#gfeast_question_cfg{id = 1406,weight = 100,topic_type = 1,question = <<"欧洲最大的岛屿是："/utf8>>,right = 4,right_answer = <<"大不列颠岛"/utf8>>,answer1 = <<"马德拉岛"/utf8>>,answer2 = <<"罗德岛"/utf8>>,answer3 = <<"泽西岛"/utf8>>,answer4 = <<"大不列颠岛"/utf8>>};

get_question_cfg(1407) ->
	#gfeast_question_cfg{id = 1407,weight = 100,topic_type = 1,question = <<"不明飞行物的英文字母简称是什么?"/utf8>>,right = 4,right_answer = <<"UFO"/utf8>>,answer1 = <<"AFO"/utf8>>,answer2 = <<"KFO"/utf8>>,answer3 = <<"SFO"/utf8>>,answer4 = <<"UFO"/utf8>>};

get_question_cfg(1408) ->
	#gfeast_question_cfg{id = 1408,weight = 100,topic_type = 1,question = <<"第一次工业革命的发祥地在："/utf8>>,right = 4,right_answer = <<"英国"/utf8>>,answer1 = <<"美国"/utf8>>,answer2 = <<"法国"/utf8>>,answer3 = <<"德国"/utf8>>,answer4 = <<"英国"/utf8>>};

get_question_cfg(1409) ->
	#gfeast_question_cfg{id = 1409,weight = 100,topic_type = 1,question = <<"谁发明了蒸汽机?"/utf8>>,right = 4,right_answer = <<"瓦特"/utf8>>,answer1 = <<"格林"/utf8>>,answer2 = <<"海尔"/utf8>>,answer3 = <<"莱特"/utf8>>,answer4 = <<"瓦特"/utf8>>};

get_question_cfg(1410) ->
	#gfeast_question_cfg{id = 1410,weight = 100,topic_type = 1,question = <<"FFF团出自哪部动画？"/utf8>>,right = 4,right_answer = <<"笨蛋测试召唤兽"/utf8>>,answer1 = <<"我的朋友很少"/utf8>>,answer2 = <<"超科学的电磁炮"/utf8>>,answer3 = <<"齐木楠雄的灾难"/utf8>>,answer4 = <<"笨蛋测试召唤兽"/utf8>>};

get_question_cfg(1411) ->
	#gfeast_question_cfg{id = 1411,weight = 100,topic_type = 1,question = <<"电子计算机发明于哪一年?"/utf8>>,right = 4,right_answer = <<"1946"/utf8>>,answer1 = <<"1646"/utf8>>,answer2 = <<"1746"/utf8>>,answer3 = <<"1846"/utf8>>,answer4 = <<"1946"/utf8>>};

get_question_cfg(1412) ->
	#gfeast_question_cfg{id = 1412,weight = 100,topic_type = 1,question = <<"缺少哪种维生素后，儿童易患佝偻病，成人易得软骨病?"/utf8>>,right = 4,right_answer = <<"维生素D"/utf8>>,answer1 = <<"维生素A"/utf8>>,answer2 = <<"维生素B"/utf8>>,answer3 = <<"维生素C"/utf8>>,answer4 = <<"维生素D"/utf8>>};

get_question_cfg(1413) ->
	#gfeast_question_cfg{id = 1413,weight = 100,topic_type = 1,question = <<"唐代山水田园诗人的代表“王孟”中，“孟”指的是谁?"/utf8>>,right = 4,right_answer = <<"孟浩然"/utf8>>,answer1 = <<"孟子"/utf8>>,answer2 = <<"孟郊"/utf8>>,answer3 = <<"孟知祥"/utf8>>,answer4 = <<"孟浩然"/utf8>>};

get_question_cfg(1414) ->
	#gfeast_question_cfg{id = 1414,weight = 100,topic_type = 1,question = <<"这么可爱!一定是(?)"/utf8>>,right = 4,right_answer = <<"男孩子"/utf8>>,answer1 = <<"小猫猫"/utf8>>,answer2 = <<"二狗子"/utf8>>,answer3 = <<"女孩子"/utf8>>,answer4 = <<"男孩子"/utf8>>};

get_question_cfg(1415) ->
	#gfeast_question_cfg{id = 1415,weight = 100,topic_type = 1,question = <<"表示氧元素的字母是?"/utf8>>,right = 4,right_answer = <<"O"/utf8>>,answer1 = <<"H"/utf8>>,answer2 = <<"I"/utf8>>,answer3 = <<"M"/utf8>>,answer4 = <<"O"/utf8>>};

get_question_cfg(1416) ->
	#gfeast_question_cfg{id = 1416,weight = 100,topic_type = 1,question = <<"没有逻辑、非常玄幻、违规常理的事件,都可以用哪四个字来表达?"/utf8>>,right = 4,right_answer = <<"这不科学"/utf8>>,answer1 = <<"我不知道"/utf8>>,answer2 = <<"我不理解"/utf8>>,answer3 = <<"这是什么"/utf8>>,answer4 = <<"这不科学"/utf8>>};

get_question_cfg(1417) ->
	#gfeast_question_cfg{id = 1417,weight = 100,topic_type = 1,question = <<"拯救世界和毁灭世界的少年少女们都普遍患有一种疾病,这种疾病叫?"/utf8>>,right = 4,right_answer = <<"中二病"/utf8>>,answer1 = <<"神经病"/utf8>>,answer2 = <<"抑郁症"/utf8>>,answer3 = <<"脑震荡"/utf8>>,answer4 = <<"中二病"/utf8>>};

get_question_cfg(1418) ->
	#gfeast_question_cfg{id = 1418,weight = 100,topic_type = 1,question = <<"能让迷之音说:“神说了,你还不能在这里死去”的人一般都是"/utf8>>,right = 4,right_answer = <<"主角"/utf8>>,answer1 = <<"反派"/utf8>>,answer2 = <<"配角"/utf8>>,answer3 = <<"路人"/utf8>>,answer4 = <<"主角"/utf8>>};

get_question_cfg(1419) ->
	#gfeast_question_cfg{id = 1419,weight = 100,topic_type = 1,question = <<"普通作品中,互相敌对势均力敌的对手,联手的时候完美无缺并且气氛暧昧,这种情况一般说这是一对？"/utf8>>,right = 4,right_answer = <<"CP"/utf8>>,answer1 = <<"基友"/utf8>>,answer2 = <<"姐妹"/utf8>>,answer3 = <<"情侣"/utf8>>,answer4 = <<"CP"/utf8>>};

get_question_cfg(1420) ->
	#gfeast_question_cfg{id = 1420,weight = 100,topic_type = 1,question = <<"在JOJO世界里,喊出“the world”会发生什么?"/utf8>>,right = 1,right_answer = <<"时间暂停"/utf8>>,answer1 = <<"时间暂停"/utf8>>,answer2 = <<"时光倒流"/utf8>>,answer3 = <<"时间加速"/utf8>>,answer4 = <<"时光跳跃"/utf8>>};

get_question_cfg(1421) ->
	#gfeast_question_cfg{id = 1421,weight = 100,topic_type = 1,question = <<"有一种喜欢卖萌的外星人,当人类被它们萌到的时候,他们会想“愚蠢的人类啊”,问这是什么外星人?"/utf8>>,right = 1,right_answer = <<"喵星人"/utf8>>,answer1 = <<"喵星人"/utf8>>,answer2 = <<"汪星人"/utf8>>,answer3 = <<"火星人"/utf8>>,answer4 = <<"宇宙人"/utf8>>};

get_question_cfg(1422) ->
	#gfeast_question_cfg{id = 1422,weight = 100,topic_type = 1,question = <<"宫崎骏执导编剧的动画电影《千与千寻》中千寻的父母因贪吃变成了什么？"/utf8>>,right = 1,right_answer = <<"猪"/utf8>>,answer1 = <<"猪"/utf8>>,answer2 = <<"狗"/utf8>>,answer3 = <<"羊"/utf8>>,answer4 = <<"猫"/utf8>>};

get_question_cfg(1423) ->
	#gfeast_question_cfg{id = 1423,weight = 100,topic_type = 1,question = <<"《狐妖小红娘》中涂山苏苏的本体是？"/utf8>>,right = 2,right_answer = <<"涂山红红"/utf8>>,answer1 = <<"涂山雅雅"/utf8>>,answer2 = <<"涂山红红"/utf8>>,answer3 = <<"涂山容容"/utf8>>,answer4 = <<"涂山美美"/utf8>>};

get_question_cfg(1424) ->
	#gfeast_question_cfg{id = 1424,weight = 100,topic_type = 1,question = <<"下面哪部动画是国漫？"/utf8>>,right = 2,right_answer = <<"罗小黑战记"/utf8>>,answer1 = <<"中华小当家"/utf8>>,answer2 = <<"罗小黑战记"/utf8>>,answer3 = <<"十二国记"/utf8>>,answer4 = <<"驱魔少年"/utf8>>};

get_question_cfg(1425) ->
	#gfeast_question_cfg{id = 1425,weight = 100,topic_type = 1,question = <<"游戏改编动画《Fate/stay night》中Saber的真实身份是？"/utf8>>,right = 2,right_answer = <<"亚瑟王"/utf8>>,answer1 = <<"英雄王"/utf8>>,answer2 = <<"亚瑟王"/utf8>>,answer3 = <<"征服王"/utf8>>,answer4 = <<"匈奴王"/utf8>>};

get_question_cfg(1426) ->
	#gfeast_question_cfg{id = 1426,weight = 100,topic_type = 1,question = <<"下面哪一部不是新海诚所导演的动画作品？"/utf8>>,right = 3,right_answer = <<"天空之城"/utf8>>,answer1 = <<"你的名字"/utf8>>,answer2 = <<"天气之子"/utf8>>,answer3 = <<"天空之城"/utf8>>,answer4 = <<"秒速五厘米"/utf8>>};

get_question_cfg(1427) ->
	#gfeast_question_cfg{id = 1427,weight = 100,topic_type = 1,question = <<"下面哪一首不是初音未来的代表歌曲？"/utf8>>,right = 3,right_answer = <<"罗密欧与灰姑娘"/utf8>>,answer1 = <<"世界第一公主殿下"/utf8>>,answer2 = <<"千本樱"/utf8>>,answer3 = <<"罗密欧与灰姑娘"/utf8>>,answer4 = <<"甩葱歌"/utf8>>};

get_question_cfg(1428) ->
	#gfeast_question_cfg{id = 1428,weight = 100,topic_type = 1,question = <<"下面哪一位不是漫威宇宙的超级英雄？"/utf8>>,right = 3,right_answer = <<"奥特曼"/utf8>>,answer1 = <<"蜘蛛侠"/utf8>>,answer2 = <<"钢铁侠"/utf8>>,answer3 = <<"奥特曼"/utf8>>,answer4 = <<"绿巨人"/utf8>>};

get_question_cfg(1429) ->
	#gfeast_question_cfg{id = 1429,weight = 100,topic_type = 1,question = <<"动漫《弹丸论破》中，男主苗木诚被赋予的称号是？"/utf8>>,right = 4,right_answer = <<"超高校级的幸运"/utf8>>,answer1 = <<"超高校级的不幸"/utf8>>,answer2 = <<"超高校级的侦探"/utf8>>,answer3 = <<"超高校级的绝望"/utf8>>,answer4 = <<"超高校级的幸运"/utf8>>};

get_question_cfg(1430) ->
	#gfeast_question_cfg{id = 1430,weight = 100,topic_type = 1,question = <<"“真相只有一个”这句话在哪部动漫中最经典？"/utf8>>,right = 4,right_answer = <<"名侦探柯南"/utf8>>,answer1 = <<"侦探学院"/utf8>>,answer2 = <<"福尔摩斯探案集"/utf8>>,answer3 = <<"金田一事件簿"/utf8>>,answer4 = <<"名侦探柯南"/utf8>>};

get_question_cfg(1431) ->
	#gfeast_question_cfg{id = 1431,weight = 100,topic_type = 1,question = <<"“我要代表月亮消灭你”是出自哪一部动漫的经典台词？"/utf8>>,right = 4,right_answer = <<"美少女战士"/utf8>>,answer1 = <<"守护甜心"/utf8>>,answer2 = <<"花仙子"/utf8>>,answer3 = <<"魔法少女奈叶"/utf8>>,answer4 = <<"美少女战士"/utf8>>};

get_question_cfg(1432) ->
	#gfeast_question_cfg{id = 1432,weight = 100,topic_type = 1,question = <<"《精灵宝可梦》里，小智的第一只宝可梦是？"/utf8>>,right = 1,right_answer = <<"皮卡丘"/utf8>>,answer1 = <<"皮卡丘"/utf8>>,answer2 = <<"杰尼龟"/utf8>>,answer3 = <<"小火龙"/utf8>>,answer4 = <<"妙蛙种子"/utf8>>};

get_question_cfg(1433) ->
	#gfeast_question_cfg{id = 1433,weight = 100,topic_type = 1,question = <<"以下哪一部动漫属于“龙傲天”类型？"/utf8>>,right = 2,right_answer = <<"一拳超人"/utf8>>,answer1 = <<"无能力者娜娜"/utf8>>,answer2 = <<"一拳超人"/utf8>>,answer3 = <<"约定的梦幻岛"/utf8>>,answer4 = <<"夏目友人帐"/utf8>>};

get_question_cfg(_Id) ->
	[].

get_question_ids() ->
[1001,1002,1003,1004,1005,1006,1007,1008,1009,1010,1011,1012,1013,1014,1015,1016,1017,1018,1019,1020,1021,1022,1023,1024,1025,1026,1027,1028,1029,1030,1031,1032,1033,1034,1035,1036,1037,1038,1039,1040,1041,1042,1043,1044,1045,1046,1047,1048,1049,1050,1051,1052,1053,1054,1055,1056,1057,1058,1059,1060,1061,1062,1063,1064,1065,1066,1067,1068,1069,1070,1071,1072,1073,1074,1075,1076,1077,1078,1079,1080,1081,1082,1083,1084,1085,1086,1087,1088,1089,1090,1091,1092,1093,1094,1095,1096,1097,1098,1099,1100,1101,1102,1103,1104,1105,1106,1107,1108,1109,1110,1111,1112,1113,1114,1115,1116,1117,1118,1119,1120,1121,1122,1123,1124,1125,1126,1127,1128,1129,1130,1131,1132,1133,1134,1135,1136,1137,1138,1139,1140,1141,1142,1143,1144,1145,1146,1147,1148,1149,1150,1151,1152,1153,1154,1155,1156,1157,1158,1159,1160,1161,1162,1163,1164,1165,1166,1167,1168,1169,1170,1171,1172,1173,1174,1175,1176,1177,1178,1179,1180,1181,1182,1183,1184,1185,1186,1187,1188,1189,1190,1191,1192,1193,1194,1195,1196,1197,1198,1199,1200,1201,1202,1203,1204,1205,1206,1207,1208,1209,1210,1211,1212,1213,1214,1215,1216,1217,1218,1219,1220,1221,1222,1223,1224,1225,1226,1227,1228,1229,1230,1231,1232,1233,1234,1235,1236,1237,1238,1239,1240,1241,1242,1243,1244,1245,1246,1247,1248,1249,1250,1251,1252,1253,1254,1255,1256,1257,1258,1259,1260,1261,1262,1263,1264,1265,1266,1267,1268,1269,1270,1271,1272,1273,1274,1275,1276,1277,1278,1279,1280,1281,1282,1283,1284,1285,1286,1287,1288,1289,1290,1291,1292,1293,1294,1295,1296,1297,1298,1299,1300,1301,1302,1303,1304,1305,1306,1307,1308,1309,1310,1311,1312,1313,1314,1315,1316,1317,1318,1319,1320,1321,1322,1323,1324,1325,1326,1327,1328,1329,1330,1331,1332,1333,1334,1335,1336,1337,1338,1339,1340,1341,1342,1343,1344,1345,1346,1347,1348,1349,1350,1351,1352,1353,1354,1355,1356,1357,1358,1359,1360,1361,1362,1363,1364,1365,1366,1367,1368,1369,1370,1371,1372,1373,1374,1375,1376,1377,1378,1379,1380,1381,1382,1383,1384,1385,1386,1387,1388,1389,1390,1391,1392,1393,1394,1395,1396,1397,1398,1399,1400,1401,1402,1403,1404,1405,1406,1407,1408,1409,1410,1411,1412,1413,1414,1415,1416,1417,1418,1419,1420,1421,1422,1423,1424,1425,1426,1427,1428,1429,1430,1431,1432,1433].


get_question_ids_by_type(1) ->
[1001,1002,1003,1004,1005,1006,1007,1008,1009,1010,1011,1012,1013,1014,1015,1016,1017,1018,1019,1020,1021,1022,1023,1024,1025,1026,1027,1028,1029,1030,1031,1032,1033,1034,1035,1036,1037,1038,1039,1040,1041,1042,1043,1044,1045,1046,1047,1048,1049,1050,1051,1052,1053,1054,1055,1056,1057,1058,1059,1060,1061,1062,1063,1064,1065,1066,1067,1068,1069,1070,1071,1072,1073,1074,1075,1076,1077,1078,1079,1080,1081,1082,1083,1084,1085,1086,1087,1088,1089,1090,1091,1092,1093,1094,1095,1096,1097,1098,1099,1100,1101,1102,1103,1104,1105,1106,1107,1108,1109,1110,1111,1112,1113,1114,1115,1116,1117,1118,1119,1120,1121,1122,1123,1124,1125,1126,1127,1128,1129,1130,1131,1132,1133,1134,1135,1136,1137,1138,1139,1140,1141,1142,1143,1144,1145,1146,1147,1148,1149,1150,1151,1152,1153,1154,1155,1156,1157,1158,1159,1160,1161,1162,1163,1164,1165,1166,1167,1168,1169,1170,1171,1172,1173,1174,1175,1176,1177,1178,1179,1180,1181,1182,1183,1184,1185,1186,1187,1188,1189,1190,1191,1192,1193,1194,1195,1196,1197,1198,1199,1200,1201,1202,1203,1204,1205,1206,1207,1208,1209,1210,1211,1212,1213,1214,1215,1216,1217,1218,1219,1220,1221,1222,1223,1224,1225,1226,1227,1228,1229,1230,1231,1232,1233,1234,1235,1236,1237,1238,1239,1240,1241,1242,1243,1244,1245,1246,1247,1248,1249,1250,1251,1252,1253,1254,1255,1256,1257,1258,1259,1260,1261,1262,1263,1264,1265,1266,1267,1268,1269,1270,1271,1272,1273,1274,1275,1276,1277,1278,1279,1280,1281,1282,1283,1284,1285,1286,1287,1288,1289,1290,1291,1292,1293,1294,1295,1296,1297,1298,1299,1300,1301,1302,1303,1304,1305,1306,1307,1308,1309,1310,1311,1312,1313,1314,1315,1316,1317,1318,1319,1320,1321,1322,1323,1324,1325,1326,1327,1328,1329,1330,1331,1332,1333,1334,1335,1336,1337,1338,1339,1340,1341,1342,1343,1344,1345,1346,1347,1348,1349,1350,1351,1352,1353,1354,1355,1356,1357,1358,1359,1360,1361,1362,1363,1364,1365,1366,1367,1368,1369,1370,1371,1372,1373,1374,1375,1376,1377,1378,1379,1380,1381,1382,1383,1384,1385,1386,1387,1388,1389,1390,1391,1392,1393,1394,1395,1396,1397,1398,1399,1400,1401,1402,1403,1404,1405,1406,1407,1408,1409,1410,1411,1412,1413,1414,1415,1416,1417,1418,1419,1420,1421,1422,1423,1424,1425,1426,1427,1428,1429,1430,1431,1432,1433];

get_question_ids_by_type(_Topictype) ->
	[].

get_fire_pool(_Num) when _Num >= 1, _Num =< 5 ->
	#guild_fire_pool{min_role_num=1,max_role_num=5,fire_num_pool=[{3,50},{4,50}],blue_fire_pool=[{100,[{1,60},{2,40}]}],purple_fire_pool=[{50,[{1,100}]}]};
get_fire_pool(_Num) when _Num >= 6, _Num =< 10 ->
	#guild_fire_pool{min_role_num=6,max_role_num=10,fire_num_pool=[{5,60},{6,40}],blue_fire_pool=[{100,[{2,60},{3,40}]}],purple_fire_pool=[{100,[{1,60},{2,40}]}]};
get_fire_pool(_Num) when _Num >= 11, _Num =< 18 ->
	#guild_fire_pool{min_role_num=11,max_role_num=18,fire_num_pool=[{9,70},{10,30}],blue_fire_pool=[{100,[{4,60},{5,40}]}],purple_fire_pool=[{100,[{2,30},{3,70}]}]};
get_fire_pool(_Num) when _Num >= 19, _Num =< 28 ->
	#guild_fire_pool{min_role_num=19,max_role_num=28,fire_num_pool=[{14,50},{15,50}],blue_fire_pool=[{100,[{6,60},{7,40}]}],purple_fire_pool=[{100,[{4,40},{5,60}]}]};
get_fire_pool(_Num) when _Num >= 29, _Num =< 35 ->
	#guild_fire_pool{min_role_num=29,max_role_num=35,fire_num_pool=[{17,50},{18,50}],blue_fire_pool=[{100,[{8,60},{9,40}]}],purple_fire_pool=[{100,[{6,10},{7,90}]}]};
get_fire_pool(_Num) ->
	[].

get_fire_reward(1,_Day) when _Day >= 1, _Day =< 999 ->
		[{1,[{{2,0,1},70000},{{2,0,2},30000}]},{1,[{{3,0,2500},40000},{{0,38040002,10},40000},{{0,16020001,1},10000},{{2,0,1},10000}]}];
get_fire_reward(2,_Day) when _Day >= 1, _Day =< 999 ->
		[{1,[{{2,0,1},70000},{{2,0,2},30000}]},{1,[{{3,0,5000},30000},{{0,38040002,10},35000},{{0,16020001,1},10000},{{2,0,2},10000},{{0,16010001,1},5000},{{0,32010120,1},10000}]}];
get_fire_reward(3,_Day) when _Day >= 1, _Day =< 999 ->
		[{1,[{{2,0,1},70000},{{2,0,2},30000}]},{2,[{{3,0,5000},30000},{{0,38040002,15},35000},{{0,16020001,1},10000},{{2,0,2},10000},{{0,16010001,1},2500},{{0,32010120,1},10000}]}];
get_fire_reward(_Color,_Day) ->
	[].

get_question_point(_Rank) when _Rank >= 1, _Rank =< 1 ->
		10;
get_question_point(_Rank) when _Rank >= 2, _Rank =< 3 ->
		7;
get_question_point(_Rank) when _Rank >= 4, _Rank =< 5 ->
		6;
get_question_point(_Rank) when _Rank >= 6, _Rank =< 7 ->
		5;
get_question_point(_Rank) when _Rank >= 8, _Rank =< 9 ->
		4;
get_question_point(_Rank) when _Rank >= 10, _Rank =< 12 ->
		3;
get_question_point(_Rank) when _Rank >= 13, _Rank =< 15 ->
		2;
get_question_point(_Rank) when _Rank >= 16, _Rank =< 9999 ->
		1;
get_question_point(_Rank) ->
	0.

get_point_rank(0,_Rank) when _Rank >= 1, _Rank =< 1 ->
		[{4,0,2000},{0,38040005,50},{2,0,50}];
get_point_rank(0,_Rank) when _Rank >= 2, _Rank =< 2 ->
		[{4,0,1600},{0,38040005,40},{2,0,40}];
get_point_rank(0,_Rank) when _Rank >= 3, _Rank =< 3 ->
		[{4,0,1400},{0,38040005,35},{2,0,35}];
get_point_rank(0,_Rank) when _Rank >= 4, _Rank =< 100 ->
		[{4,0,1200},{0,38040005,30},{2,0,30}];
get_point_rank(1,_Rank) when _Rank >= 1, _Rank =< 1 ->
		[{4,0,2000},{0,38040005,50},{2,0,50}];
get_point_rank(1,_Rank) when _Rank >= 2, _Rank =< 2 ->
		[{4,0,1600},{0,38040005,40},{2,0,40}];
get_point_rank(1,_Rank) when _Rank >= 3, _Rank =< 3 ->
		[{4,0,1400},{0,38040005,35},{2,0,35}];
get_point_rank(1,_Rank) when _Rank >= 4, _Rank =< 100 ->
		[{4,0,1200},{0,38040005,30},{2,0,30}];
get_point_rank(_Game_type,_Rank) ->
	[].

get_max_rank() -> 100.


get_combo_reward(2) ->
[[]];


get_combo_reward(4) ->
[[]];


get_combo_reward(6) ->
[[]];


get_combo_reward(8) ->
[[]];

get_combo_reward(_Combo) ->
	[].

get_dragon_gift(_Day) when _Day >= 100, _Day =< 149 ->
		[[{1,[{{0,101014031,1},5354},{{0,101014032,1},972},{{0,101015031,1},714},{{0,101015032,1},108},{{0,101034032,1},16},{{0,101035031,1},20},{{0,101035032,1},2},{{0,101024031,1},5354},{{0,101024032,1},972},{{0,101025031,1},714},{{0,101025032,1},108},{{0,101054032,1},16},{{0,101055031,1},20},{{0,101055032,1},2},{{0,101044031,1},5354},{{0,101044032,1},972},{{0,101045031,1},714},{{0,101045032,1},108},{{0,101064031,1},5354},{{0,101064032,1},972},{{0,101065031,1},714},{{0,101065032,1},108},{{0,101084031,1},5354},{{0,101084032,1},972},{{0,101085031,1},714},{{0,101085032,1},108},{{0,101104031,1},5354},{{0,101104032,1},972},{{0,101105031,1},714},{{0,101105032,1},108},{{0,102014031,1},5354},{{0,102014032,1},972},{{0,102015031,1},714},{{0,102015032,1},108},{{0,102024031,1},5354},{{0,102024032,1},972},{{0,102025031,1},714},{{0,102025032,1},108},{{0,102044031,1},5354},{{0,102044032,1},972},{{0,102045031,1},714},{{0,102045032,1},108},{{0,102064031,1},5354},{{0,102064032,1},972},{{0,102065031,1},714},{{0,102065032,1},108},{{0,102084031,1},5354},{{0,102084032,1},972},{{0,102085031,1},714},{{0,102085032,1},108},{{0,102104031,1},5354},{{0,102104032,1},972},{{0,102105031,1},714},{{0,102105032,1},108}]},{6,[{{0,101014031,1},6426},{{0,101013031,1},714},{{0,101024031,1},6426},{{0,101023031,1},714},{{0,101044031,1},6426},{{0,101043031,1},714},{{0,101064031,1},6426},{{0,101063031,1},714},{{0,101084031,1},6426},{{0,101083031,1},714},{{0,101104031,1},6426},{{0,101103031,1},714},{{0,102014031,1},6426},{{0,102013031,1},714},{{0,102024031,1},6426},{{0,102023031,1},714},{{0,102044031,1},6426},{{0,102043031,1},714},{{0,102064031,1},6426},{{0,102063031,1},714},{{0,102084031,1},6426},{{0,102083031,1},714},{{0,102104031,1},6426},{{0,102103031,1},714},{{0,101034031,1},6426},{{0,101033031,1},714},{{0,101054031,1},6426},{{0,101053031,1},714}]},{1,[{{3,0,5000},94000},{{0,101072060,1},3000},{{0,101092060,1},3000}]}],[]];
get_dragon_gift(_Day) when _Day >= 150, _Day =< 199 ->
		[[{1,[{{0,101014041,1},5354},{{0,101014042,1},972},{{0,101015041,1},714},{{0,101015042,1},108},{{0,101034042,1},16},{{0,101035041,1},20},{{0,101035042,1},2},{{0,101024041,1},5354},{{0,101024042,1},972},{{0,101025041,1},714},{{0,101025042,1},108},{{0,101054042,1},16},{{0,101055041,1},20},{{0,101055042,1},2},{{0,101044041,1},5354},{{0,101044042,1},972},{{0,101045041,1},714},{{0,101045042,1},108},{{0,101064041,1},5354},{{0,101064042,1},972},{{0,101065041,1},714},{{0,101065042,1},108},{{0,101084041,1},5354},{{0,101084042,1},972},{{0,101085041,1},714},{{0,101085042,1},108},{{0,101104041,1},5354},{{0,101104042,1},972},{{0,101105041,1},714},{{0,101105042,1},108},{{0,102014041,1},5354},{{0,102014042,1},972},{{0,102015041,1},714},{{0,102015042,1},108},{{0,102024041,1},5354},{{0,102024042,1},972},{{0,102025041,1},714},{{0,102025042,1},108},{{0,102044041,1},5354},{{0,102044042,1},972},{{0,102045041,1},714},{{0,102045042,1},108},{{0,102064041,1},5354},{{0,102064042,1},972},{{0,102065041,1},714},{{0,102065042,1},108},{{0,102084041,1},5354},{{0,102084042,1},972},{{0,102085041,1},714},{{0,102085042,1},108},{{0,102104041,1},5354},{{0,102104042,1},972},{{0,102105041,1},714},{{0,102105042,1},108}]},{6,[{{0,101014041,1},6426},{{0,101013041,1},714},{{0,101024041,1},6426},{{0,101023041,1},714},{{0,101044041,1},6426},{{0,101043041,1},714},{{0,101064041,1},6426},{{0,101063041,1},714},{{0,101084041,1},6426},{{0,101083041,1},714},{{0,101104041,1},6426},{{0,101103041,1},714},{{0,102014041,1},6426},{{0,102013041,1},714},{{0,102024041,1},6426},{{0,102023041,1},714},{{0,102044041,1},6426},{{0,102043041,1},714},{{0,102064041,1},6426},{{0,102063041,1},714},{{0,102084041,1},6426},{{0,102083041,1},714},{{0,102104041,1},6426},{{0,102103041,1},714},{{0,101034041,1},6426},{{0,101033041,1},714},{{0,101054041,1},6426},{{0,101053041,1},714}]},{1,[{{3,0,5000},94000},{{0,101072060,1},3000},{{0,101092060,1},3000}]}],[]];
get_dragon_gift(_Day) when _Day >= 200, _Day =< 249 ->
		[[{1,[{{0,101014051,1},5354},{{0,101014052,1},972},{{0,101015051,1},714},{{0,101015052,1},108},{{0,101034052,1},16},{{0,101035051,1},20},{{0,101035052,1},2},{{0,101024051,1},5354},{{0,101024052,1},972},{{0,101025051,1},714},{{0,101025052,1},108},{{0,101054052,1},16},{{0,101055051,1},20},{{0,101055052,1},2},{{0,101044051,1},5354},{{0,101044052,1},972},{{0,101045051,1},714},{{0,101045052,1},108},{{0,101064051,1},5354},{{0,101064052,1},972},{{0,101065051,1},714},{{0,101065052,1},108},{{0,101084051,1},5354},{{0,101084052,1},972},{{0,101085051,1},714},{{0,101085052,1},108},{{0,101104051,1},5354},{{0,101104052,1},972},{{0,101105051,1},714},{{0,101105052,1},108},{{0,102014051,1},5354},{{0,102014052,1},972},{{0,102015051,1},714},{{0,102015052,1},108},{{0,102024051,1},5354},{{0,102024052,1},972},{{0,102025051,1},714},{{0,102025052,1},108},{{0,102044051,1},5354},{{0,102044052,1},972},{{0,102045051,1},714},{{0,102045052,1},108},{{0,102064051,1},5354},{{0,102064052,1},972},{{0,102065051,1},714},{{0,102065052,1},108},{{0,102084051,1},5354},{{0,102084052,1},972},{{0,102085051,1},714},{{0,102085052,1},108},{{0,102104051,1},5354},{{0,102104052,1},972},{{0,102105051,1},714},{{0,102105052,1},108}]},{6,[{{0,101014051,1},6426},{{0,101013051,1},714},{{0,101024051,1},6426},{{0,101023051,1},714},{{0,101044051,1},6426},{{0,101043051,1},714},{{0,101064051,1},6426},{{0,101063051,1},714},{{0,101084051,1},6426},{{0,101083051,1},714},{{0,101104051,1},6426},{{0,101103051,1},714},{{0,102014051,1},6426},{{0,102013051,1},714},{{0,102024051,1},6426},{{0,102023051,1},714},{{0,102044051,1},6426},{{0,102043051,1},714},{{0,102064051,1},6426},{{0,102063051,1},714},{{0,102084051,1},6426},{{0,102083051,1},714},{{0,102104051,1},6426},{{0,102103051,1},714},{{0,101034051,1},6426},{{0,101033051,1},714},{{0,101054051,1},6426},{{0,101053051,1},714}]},{1,[{{3,0,5000},94000},{{0,101072060,1},3000},{{0,101092060,1},3000}]}],[]];
get_dragon_gift(_Day) when _Day >= 250, _Day =< 299 ->
		[[{1,[{{0,101014061,1},5354},{{0,101014062,1},972},{{0,101015061,1},714},{{0,101015062,1},108},{{0,101034062,1},16},{{0,101035061,1},20},{{0,101035062,1},2},{{0,101024061,1},5354},{{0,101024062,1},972},{{0,101025061,1},714},{{0,101025062,1},108},{{0,101054062,1},16},{{0,101055061,1},20},{{0,101055062,1},2},{{0,101044061,1},5354},{{0,101044062,1},972},{{0,101045061,1},714},{{0,101045062,1},108},{{0,101064061,1},5354},{{0,101064062,1},972},{{0,101065061,1},714},{{0,101065062,1},108},{{0,101084061,1},5354},{{0,101084062,1},972},{{0,101085061,1},714},{{0,101085062,1},108},{{0,101104061,1},5354},{{0,101104062,1},972},{{0,101105061,1},714},{{0,101105062,1},108},{{0,102014061,1},5354},{{0,102014062,1},972},{{0,102015061,1},714},{{0,102015062,1},108},{{0,102024061,1},5354},{{0,102024062,1},972},{{0,102025061,1},714},{{0,102025062,1},108},{{0,102044061,1},5354},{{0,102044062,1},972},{{0,102045061,1},714},{{0,102045062,1},108},{{0,102064061,1},5354},{{0,102064062,1},972},{{0,102065061,1},714},{{0,102065062,1},108},{{0,102084061,1},5354},{{0,102084062,1},972},{{0,102085061,1},714},{{0,102085062,1},108},{{0,102104061,1},5354},{{0,102104062,1},972},{{0,102105061,1},714},{{0,102105062,1},108}]},{6,[{{0,101014061,1},6426},{{0,101013061,1},714},{{0,101024061,1},6426},{{0,101023061,1},714},{{0,101044061,1},6426},{{0,101043061,1},714},{{0,101064061,1},6426},{{0,101063061,1},714},{{0,101084061,1},6426},{{0,101083061,1},714},{{0,101104061,1},6426},{{0,101103061,1},714},{{0,102014061,1},6426},{{0,102013061,1},714},{{0,102024061,1},6426},{{0,102023061,1},714},{{0,102044061,1},6426},{{0,102043061,1},714},{{0,102064061,1},6426},{{0,102063061,1},714},{{0,102084061,1},6426},{{0,102083061,1},714},{{0,102104061,1},6426},{{0,102103061,1},714},{{0,101034061,1},6426},{{0,101033061,1},714},{{0,101054061,1},6426},{{0,101053061,1},714}]},{1,[{{3,0,5000},94000},{{0,101072060,1},3000},{{0,101092060,1},3000}]}],[]];
get_dragon_gift(_Day) when _Day >= 300, _Day =< 349 ->
		[[{1,[{{0,101014071,1},5354},{{0,101014072,1},972},{{0,101015071,1},714},{{0,101015072,1},108},{{0,101034072,1},16},{{0,101035071,1},20},{{0,101035072,1},2},{{0,101024071,1},5354},{{0,101024072,1},972},{{0,101025071,1},714},{{0,101025072,1},108},{{0,101054072,1},16},{{0,101055071,1},20},{{0,101055072,1},2},{{0,101044071,1},5354},{{0,101044072,1},972},{{0,101045071,1},714},{{0,101045072,1},108},{{0,101064071,1},5354},{{0,101064072,1},972},{{0,101065071,1},714},{{0,101065072,1},108},{{0,101084071,1},5354},{{0,101084072,1},972},{{0,101085071,1},714},{{0,101085072,1},108},{{0,101104071,1},5354},{{0,101104072,1},972},{{0,101105071,1},714},{{0,101105072,1},108},{{0,102014071,1},5354},{{0,102014072,1},972},{{0,102015071,1},714},{{0,102015072,1},108},{{0,102024071,1},5354},{{0,102024072,1},972},{{0,102025071,1},714},{{0,102025072,1},108},{{0,102044071,1},5354},{{0,102044072,1},972},{{0,102045071,1},714},{{0,102045072,1},108},{{0,102064071,1},5354},{{0,102064072,1},972},{{0,102065071,1},714},{{0,102065072,1},108},{{0,102084071,1},5354},{{0,102084072,1},972},{{0,102085071,1},714},{{0,102085072,1},108},{{0,102104071,1},5354},{{0,102104072,1},972},{{0,102105071,1},714},{{0,102105072,1},108}]},{6,[{{0,101014071,1},6426},{{0,101013071,1},714},{{0,101024071,1},6426},{{0,101023071,1},714},{{0,101044071,1},6426},{{0,101043071,1},714},{{0,101064071,1},6426},{{0,101063071,1},714},{{0,101084071,1},6426},{{0,101083071,1},714},{{0,101104071,1},6426},{{0,101103071,1},714},{{0,102014071,1},6426},{{0,102013071,1},714},{{0,102024071,1},6426},{{0,102023071,1},714},{{0,102044071,1},6426},{{0,102043071,1},714},{{0,102064071,1},6426},{{0,102063071,1},714},{{0,102084071,1},6426},{{0,102083071,1},714},{{0,102104071,1},6426},{{0,102103071,1},714},{{0,101034071,1},6426},{{0,101033071,1},714},{{0,101054071,1},6426},{{0,101053071,1},714}]},{1,[{{3,0,5000},94000},{{0,101072060,1},3000},{{0,101092060,1},3000}]}],[]];
get_dragon_gift(_Day) when _Day >= 350, _Day =< 399 ->
		[[{1,[{{0,101014081,1},5354},{{0,101014082,1},972},{{0,101015081,1},714},{{0,101015082,1},108},{{0,101034082,1},16},{{0,101035081,1},20},{{0,101035082,1},2},{{0,101024081,1},5354},{{0,101024082,1},972},{{0,101025081,1},714},{{0,101025082,1},108},{{0,101054082,1},16},{{0,101055081,1},20},{{0,101055082,1},2},{{0,101044081,1},5354},{{0,101044082,1},972},{{0,101045081,1},714},{{0,101045082,1},108},{{0,101064081,1},5354},{{0,101064082,1},972},{{0,101065081,1},714},{{0,101065082,1},108},{{0,101084081,1},5354},{{0,101084082,1},972},{{0,101085081,1},714},{{0,101085082,1},108},{{0,101104081,1},5354},{{0,101104082,1},972},{{0,101105081,1},714},{{0,101105082,1},108},{{0,102014081,1},5354},{{0,102014082,1},972},{{0,102015081,1},714},{{0,102015082,1},108},{{0,102024081,1},5354},{{0,102024082,1},972},{{0,102025081,1},714},{{0,102025082,1},108},{{0,102044081,1},5354},{{0,102044082,1},972},{{0,102045081,1},714},{{0,102045082,1},108},{{0,102064081,1},5354},{{0,102064082,1},972},{{0,102065081,1},714},{{0,102065082,1},108},{{0,102084081,1},5354},{{0,102084082,1},972},{{0,102085081,1},714},{{0,102085082,1},108},{{0,102104081,1},5354},{{0,102104082,1},972},{{0,102105081,1},714},{{0,102105082,1},108}]},{6,[{{0,101014081,1},6426},{{0,101013081,1},714},{{0,101024081,1},6426},{{0,101023081,1},714},{{0,101044081,1},6426},{{0,101043081,1},714},{{0,101064081,1},6426},{{0,101063081,1},714},{{0,101084081,1},6426},{{0,101083081,1},714},{{0,101104081,1},6426},{{0,101103081,1},714},{{0,102014081,1},6426},{{0,102013081,1},714},{{0,102024081,1},6426},{{0,102023081,1},714},{{0,102044081,1},6426},{{0,102043081,1},714},{{0,102064081,1},6426},{{0,102063081,1},714},{{0,102084081,1},6426},{{0,102083081,1},714},{{0,102104081,1},6426},{{0,102103081,1},714},{{0,101034081,1},6426},{{0,101033081,1},714},{{0,101054081,1},6426},{{0,101053081,1},714}]},{1,[{{3,0,5000},94000},{{0,101072060,1},3000},{{0,101092060,1},3000}]}],[]];
get_dragon_gift(_Day) when _Day >= 400, _Day =< 449 ->
		[[{1,[{{0,101014091,1},5354},{{0,101014092,1},972},{{0,101015091,1},714},{{0,101015092,1},108},{{0,101034092,1},16},{{0,101035091,1},20},{{0,101035092,1},2},{{0,101024091,1},5354},{{0,101024092,1},972},{{0,101025091,1},714},{{0,101025092,1},108},{{0,101054092,1},16},{{0,101055091,1},20},{{0,101055092,1},2},{{0,101044091,1},5354},{{0,101044092,1},972},{{0,101045091,1},714},{{0,101045092,1},108},{{0,101064091,1},5354},{{0,101064092,1},972},{{0,101065091,1},714},{{0,101065092,1},108},{{0,101084091,1},5354},{{0,101084092,1},972},{{0,101085091,1},714},{{0,101085092,1},108},{{0,101104091,1},5354},{{0,101104092,1},972},{{0,101105091,1},714},{{0,101105092,1},108},{{0,102014091,1},5354},{{0,102014092,1},972},{{0,102015091,1},714},{{0,102015092,1},108},{{0,102024091,1},5354},{{0,102024092,1},972},{{0,102025091,1},714},{{0,102025092,1},108},{{0,102044091,1},5354},{{0,102044092,1},972},{{0,102045091,1},714},{{0,102045092,1},108},{{0,102064091,1},5354},{{0,102064092,1},972},{{0,102065091,1},714},{{0,102065092,1},108},{{0,102084091,1},5354},{{0,102084092,1},972},{{0,102085091,1},714},{{0,102085092,1},108},{{0,102104091,1},5354},{{0,102104092,1},972},{{0,102105091,1},714},{{0,102105092,1},108}]},{6,[{{0,101014091,1},6426},{{0,101013091,1},714},{{0,101024091,1},6426},{{0,101023091,1},714},{{0,101044091,1},6426},{{0,101043091,1},714},{{0,101064091,1},6426},{{0,101063091,1},714},{{0,101084091,1},6426},{{0,101083091,1},714},{{0,101104091,1},6426},{{0,101103091,1},714},{{0,102014091,1},6426},{{0,102013091,1},714},{{0,102024091,1},6426},{{0,102023091,1},714},{{0,102044091,1},6426},{{0,102043091,1},714},{{0,102064091,1},6426},{{0,102063091,1},714},{{0,102084091,1},6426},{{0,102083091,1},714},{{0,102104091,1},6426},{{0,102103091,1},714},{{0,101034091,1},6426},{{0,101033091,1},714},{{0,101054091,1},6426},{{0,101053091,1},714}]},{1,[{{3,0,5000},94000},{{0,101072060,1},3000},{{0,101092060,1},3000}]}],[]];
get_dragon_gift(_Day) when _Day >= 450, _Day =< 499 ->
		[[{1,[{{0,101014101,1},5354},{{0,101014102,1},972},{{0,101015101,1},714},{{0,101015102,1},108},{{0,101034102,1},16},{{0,101035101,1},20},{{0,101035102,1},2},{{0,101024101,1},5354},{{0,101024102,1},972},{{0,101025101,1},714},{{0,101025102,1},108},{{0,101054102,1},16},{{0,101055101,1},20},{{0,101055102,1},2},{{0,101044101,1},5354},{{0,101044102,1},972},{{0,101045101,1},714},{{0,101045102,1},108},{{0,101064101,1},5354},{{0,101064102,1},972},{{0,101065101,1},714},{{0,101065102,1},108},{{0,101084101,1},5354},{{0,101084102,1},972},{{0,101085101,1},714},{{0,101085102,1},108},{{0,101104101,1},5354},{{0,101104102,1},972},{{0,101105101,1},714},{{0,101105102,1},108},{{0,102014101,1},5354},{{0,102014102,1},972},{{0,102015101,1},714},{{0,102015102,1},108},{{0,102024101,1},5354},{{0,102024102,1},972},{{0,102025101,1},714},{{0,102025102,1},108},{{0,102044101,1},5354},{{0,102044102,1},972},{{0,102045101,1},714},{{0,102045102,1},108},{{0,102064101,1},5354},{{0,102064102,1},972},{{0,102065101,1},714},{{0,102065102,1},108},{{0,102084101,1},5354},{{0,102084102,1},972},{{0,102085101,1},714},{{0,102085102,1},108},{{0,102104101,1},5354},{{0,102104102,1},972},{{0,102105101,1},714},{{0,102105102,1},108}]},{6,[{{0,101014101,1},6426},{{0,101013101,1},714},{{0,101024101,1},6426},{{0,101023101,1},714},{{0,101044101,1},6426},{{0,101043101,1},714},{{0,101064101,1},6426},{{0,101063101,1},714},{{0,101084101,1},6426},{{0,101083101,1},714},{{0,101104101,1},6426},{{0,101103101,1},714},{{0,102014101,1},6426},{{0,102013101,1},714},{{0,102024101,1},6426},{{0,102023101,1},714},{{0,102044101,1},6426},{{0,102043101,1},714},{{0,102064101,1},6426},{{0,102063101,1},714},{{0,102084101,1},6426},{{0,102083101,1},714},{{0,102104101,1},6426},{{0,102103101,1},714},{{0,101034101,1},6426},{{0,101033101,1},714},{{0,101054101,1},6426},{{0,101053101,1},714}]},{1,[{{3,0,5000},94000},{{0,101072060,1},3000},{{0,101092060,1},3000}]}],[]];
get_dragon_gift(_Day) when _Day >= 500, _Day =< 549 ->
		[[{1,[{{0,101014111,1},5354},{{0,101014112,1},972},{{0,101015111,1},714},{{0,101015112,1},108},{{0,101034112,1},16},{{0,101035111,1},20},{{0,101035112,1},2},{{0,101024111,1},5354},{{0,101024112,1},972},{{0,101025111,1},714},{{0,101025112,1},108},{{0,101054112,1},16},{{0,101055111,1},20},{{0,101055112,1},2},{{0,101044111,1},5354},{{0,101044112,1},972},{{0,101045111,1},714},{{0,101045112,1},108},{{0,101064111,1},5354},{{0,101064112,1},972},{{0,101065111,1},714},{{0,101065112,1},108},{{0,101084111,1},5354},{{0,101084112,1},972},{{0,101085111,1},714},{{0,101085112,1},108},{{0,101104111,1},5354},{{0,101104112,1},972},{{0,101105111,1},714},{{0,101105112,1},108},{{0,102014111,1},5354},{{0,102014112,1},972},{{0,102015111,1},714},{{0,102015112,1},108},{{0,102024111,1},5354},{{0,102024112,1},972},{{0,102025111,1},714},{{0,102025112,1},108},{{0,102044111,1},5354},{{0,102044112,1},972},{{0,102045111,1},714},{{0,102045112,1},108},{{0,102064111,1},5354},{{0,102064112,1},972},{{0,102065111,1},714},{{0,102065112,1},108},{{0,102084111,1},5354},{{0,102084112,1},972},{{0,102085111,1},714},{{0,102085112,1},108},{{0,102104111,1},5354},{{0,102104112,1},972},{{0,102105111,1},714},{{0,102105112,1},108}]},{6,[{{0,101014111,1},6426},{{0,101013111,1},714},{{0,101024111,1},6426},{{0,101023111,1},714},{{0,101044111,1},6426},{{0,101043111,1},714},{{0,101064111,1},6426},{{0,101063111,1},714},{{0,101084111,1},6426},{{0,101083111,1},714},{{0,101104111,1},6426},{{0,101103111,1},714},{{0,102014111,1},6426},{{0,102013111,1},714},{{0,102024111,1},6426},{{0,102023111,1},714},{{0,102044111,1},6426},{{0,102043111,1},714},{{0,102064111,1},6426},{{0,102063111,1},714},{{0,102084111,1},6426},{{0,102083111,1},714},{{0,102104111,1},6426},{{0,102103111,1},714},{{0,101034111,1},6426},{{0,101033111,1},714},{{0,101054111,1},6426},{{0,101053111,1},714}]},{1,[{{3,0,5000},94000},{{0,101072060,1},3000},{{0,101092060,1},3000}]}],[]];
get_dragon_gift(_Day) when _Day >= 550, _Day =< 599 ->
		[[{1,[{{0,101014121,1},5354},{{0,101014122,1},972},{{0,101015121,1},714},{{0,101015122,1},108},{{0,101034122,1},16},{{0,101035121,1},20},{{0,101035122,1},2},{{0,101024121,1},5354},{{0,101024122,1},972},{{0,101025121,1},714},{{0,101025122,1},108},{{0,101054122,1},16},{{0,101055121,1},20},{{0,101055122,1},2},{{0,101044121,1},5354},{{0,101044122,1},972},{{0,101045121,1},714},{{0,101045122,1},108},{{0,101064121,1},5354},{{0,101064122,1},972},{{0,101065121,1},714},{{0,101065122,1},108},{{0,101084121,1},5354},{{0,101084122,1},972},{{0,101085121,1},714},{{0,101085122,1},108},{{0,101104121,1},5354},{{0,101104122,1},972},{{0,101105121,1},714},{{0,101105122,1},108},{{0,102014121,1},5354},{{0,102014122,1},972},{{0,102015121,1},714},{{0,102015122,1},108},{{0,102024121,1},5354},{{0,102024122,1},972},{{0,102025121,1},714},{{0,102025122,1},108},{{0,102044121,1},5354},{{0,102044122,1},972},{{0,102045121,1},714},{{0,102045122,1},108},{{0,102064121,1},5354},{{0,102064122,1},972},{{0,102065121,1},714},{{0,102065122,1},108},{{0,102084121,1},5354},{{0,102084122,1},972},{{0,102085121,1},714},{{0,102085122,1},108},{{0,102104121,1},5354},{{0,102104122,1},972},{{0,102105121,1},714},{{0,102105122,1},108}]},{6,[{{0,101014121,1},6426},{{0,101013121,1},714},{{0,101024121,1},6426},{{0,101023121,1},714},{{0,101044121,1},6426},{{0,101043121,1},714},{{0,101064121,1},6426},{{0,101063121,1},714},{{0,101084121,1},6426},{{0,101083121,1},714},{{0,101104121,1},6426},{{0,101103121,1},714},{{0,102014121,1},6426},{{0,102013121,1},714},{{0,102024121,1},6426},{{0,102023121,1},714},{{0,102044121,1},6426},{{0,102043121,1},714},{{0,102064121,1},6426},{{0,102063121,1},714},{{0,102084121,1},6426},{{0,102083121,1},714},{{0,102104121,1},6426},{{0,102103121,1},714},{{0,101034121,1},6426},{{0,101033121,1},714},{{0,101054121,1},6426},{{0,101053121,1},714}]},{1,[{{3,0,5000},94000},{{0,101072060,1},3000},{{0,101092060,1},3000}]}],[]];
get_dragon_gift(_Day) when _Day >= 600, _Day =< 649 ->
		[[{1,[{{0,101014131,1},5354},{{0,101014132,1},972},{{0,101015131,1},714},{{0,101015132,1},108},{{0,101034132,1},16},{{0,101035131,1},20},{{0,101035132,1},2},{{0,101024131,1},5354},{{0,101024132,1},972},{{0,101025131,1},714},{{0,101025132,1},108},{{0,101054132,1},16},{{0,101055131,1},20},{{0,101055132,1},2},{{0,101044131,1},5354},{{0,101044132,1},972},{{0,101045131,1},714},{{0,101045132,1},108},{{0,101064131,1},5354},{{0,101064132,1},972},{{0,101065131,1},714},{{0,101065132,1},108},{{0,101084131,1},5354},{{0,101084132,1},972},{{0,101085131,1},714},{{0,101085132,1},108},{{0,101104131,1},5354},{{0,101104132,1},972},{{0,101105131,1},714},{{0,101105132,1},108},{{0,102014131,1},5354},{{0,102014132,1},972},{{0,102015131,1},714},{{0,102015132,1},108},{{0,102024131,1},5354},{{0,102024132,1},972},{{0,102025131,1},714},{{0,102025132,1},108},{{0,102044131,1},5354},{{0,102044132,1},972},{{0,102045131,1},714},{{0,102045132,1},108},{{0,102064131,1},5354},{{0,102064132,1},972},{{0,102065131,1},714},{{0,102065132,1},108},{{0,102084131,1},5354},{{0,102084132,1},972},{{0,102085131,1},714},{{0,102085132,1},108},{{0,102104131,1},5354},{{0,102104132,1},972},{{0,102105131,1},714},{{0,102105132,1},108}]},{6,[{{0,101014131,1},6426},{{0,101013131,1},714},{{0,101024131,1},6426},{{0,101023131,1},714},{{0,101044131,1},6426},{{0,101043131,1},714},{{0,101064131,1},6426},{{0,101063131,1},714},{{0,101084131,1},6426},{{0,101083131,1},714},{{0,101104131,1},6426},{{0,101103131,1},714},{{0,102014131,1},6426},{{0,102013131,1},714},{{0,102024131,1},6426},{{0,102023131,1},714},{{0,102044131,1},6426},{{0,102043131,1},714},{{0,102064131,1},6426},{{0,102063131,1},714},{{0,102084131,1},6426},{{0,102083131,1},714},{{0,102104131,1},6426},{{0,102103131,1},714},{{0,101034131,1},6426},{{0,101033131,1},714},{{0,101054131,1},6426},{{0,101053131,1},714}]},{1,[{{3,0,5000},94000},{{0,101072060,1},3000},{{0,101092060,1},3000}]}],[]];
get_dragon_gift(_Day) when _Day >= 650, _Day =< 699 ->
		[[{1,[{{0,101014141,1},5354},{{0,101014142,1},972},{{0,101015141,1},714},{{0,101015142,1},108},{{0,101034142,1},16},{{0,101035141,1},20},{{0,101035142,1},2},{{0,101024141,1},5354},{{0,101024142,1},972},{{0,101025141,1},714},{{0,101025142,1},108},{{0,101054142,1},16},{{0,101055141,1},20},{{0,101055142,1},2},{{0,101044141,1},5354},{{0,101044142,1},972},{{0,101045141,1},714},{{0,101045142,1},108},{{0,101064141,1},5354},{{0,101064142,1},972},{{0,101065141,1},714},{{0,101065142,1},108},{{0,101084141,1},5354},{{0,101084142,1},972},{{0,101085141,1},714},{{0,101085142,1},108},{{0,101104141,1},5354},{{0,101104142,1},972},{{0,101105141,1},714},{{0,101105142,1},108},{{0,102014141,1},5354},{{0,102014142,1},972},{{0,102015141,1},714},{{0,102015142,1},108},{{0,102024141,1},5354},{{0,102024142,1},972},{{0,102025141,1},714},{{0,102025142,1},108},{{0,102044141,1},5354},{{0,102044142,1},972},{{0,102045141,1},714},{{0,102045142,1},108},{{0,102064141,1},5354},{{0,102064142,1},972},{{0,102065141,1},714},{{0,102065142,1},108},{{0,102084141,1},5354},{{0,102084142,1},972},{{0,102085141,1},714},{{0,102085142,1},108},{{0,102104141,1},5354},{{0,102104142,1},972},{{0,102105141,1},714},{{0,102105142,1},108}]},{6,[{{0,101014141,1},6426},{{0,101013141,1},714},{{0,101024141,1},6426},{{0,101023141,1},714},{{0,101044141,1},6426},{{0,101043141,1},714},{{0,101064141,1},6426},{{0,101063141,1},714},{{0,101084141,1},6426},{{0,101083141,1},714},{{0,101104141,1},6426},{{0,101103141,1},714},{{0,102014141,1},6426},{{0,102013141,1},714},{{0,102024141,1},6426},{{0,102023141,1},714},{{0,102044141,1},6426},{{0,102043141,1},714},{{0,102064141,1},6426},{{0,102063141,1},714},{{0,102084141,1},6426},{{0,102083141,1},714},{{0,102104141,1},6426},{{0,102103141,1},714},{{0,101034141,1},6426},{{0,101033141,1},714},{{0,101054141,1},6426},{{0,101053141,1},714}]},{1,[{{3,0,5000},94000},{{0,101072060,1},3000},{{0,101092060,1},3000}]}],[]];
get_dragon_gift(_Day) when _Day >= 700, _Day =< 749 ->
		[[{1,[{{0,101014151,1},5354},{{0,101014152,1},972},{{0,101015151,1},714},{{0,101015152,1},108},{{0,101034152,1},16},{{0,101035151,1},20},{{0,101035152,1},2},{{0,101024151,1},5354},{{0,101024152,1},972},{{0,101025151,1},714},{{0,101025152,1},108},{{0,101054152,1},16},{{0,101055151,1},20},{{0,101055152,1},2},{{0,101044151,1},5354},{{0,101044152,1},972},{{0,101045151,1},714},{{0,101045152,1},108},{{0,101064151,1},5354},{{0,101064152,1},972},{{0,101065151,1},714},{{0,101065152,1},108},{{0,101084151,1},5354},{{0,101084152,1},972},{{0,101085151,1},714},{{0,101085152,1},108},{{0,101104151,1},5354},{{0,101104152,1},972},{{0,101105151,1},714},{{0,101105152,1},108},{{0,102014151,1},5354},{{0,102014152,1},972},{{0,102015151,1},714},{{0,102015152,1},108},{{0,102024151,1},5354},{{0,102024152,1},972},{{0,102025151,1},714},{{0,102025152,1},108},{{0,102044151,1},5354},{{0,102044152,1},972},{{0,102045151,1},714},{{0,102045152,1},108},{{0,102064151,1},5354},{{0,102064152,1},972},{{0,102065151,1},714},{{0,102065152,1},108},{{0,102084151,1},5354},{{0,102084152,1},972},{{0,102085151,1},714},{{0,102085152,1},108},{{0,102104151,1},5354},{{0,102104152,1},972},{{0,102105151,1},714},{{0,102105152,1},108}]},{6,[{{0,101014151,1},6426},{{0,101013151,1},714},{{0,101024151,1},6426},{{0,101023151,1},714},{{0,101044151,1},6426},{{0,101043151,1},714},{{0,101064151,1},6426},{{0,101063151,1},714},{{0,101084151,1},6426},{{0,101083151,1},714},{{0,101104151,1},6426},{{0,101103151,1},714},{{0,102014151,1},6426},{{0,102013151,1},714},{{0,102024151,1},6426},{{0,102023151,1},714},{{0,102044151,1},6426},{{0,102043151,1},714},{{0,102064151,1},6426},{{0,102063151,1},714},{{0,102084151,1},6426},{{0,102083151,1},714},{{0,102104151,1},6426},{{0,102103151,1},714},{{0,101034151,1},6426},{{0,101033151,1},714},{{0,101054151,1},6426},{{0,101053151,1},714}]},{1,[{{3,0,5000},94000},{{0,101072060,1},3000},{{0,101092060,1},3000}]}],[]];
get_dragon_gift(_Day) when _Day >= 750, _Day =< 799 ->
		[[{1,[{{0,101014161,1},5354},{{0,101014162,1},972},{{0,101015161,1},714},{{0,101015162,1},108},{{0,101034162,1},16},{{0,101035161,1},20},{{0,101035162,1},2},{{0,101024161,1},5354},{{0,101024162,1},972},{{0,101025161,1},714},{{0,101025162,1},108},{{0,101054162,1},16},{{0,101055161,1},20},{{0,101055162,1},2},{{0,101044161,1},5354},{{0,101044162,1},972},{{0,101045161,1},714},{{0,101045162,1},108},{{0,101064161,1},5354},{{0,101064162,1},972},{{0,101065161,1},714},{{0,101065162,1},108},{{0,101084161,1},5354},{{0,101084162,1},972},{{0,101085161,1},714},{{0,101085162,1},108},{{0,101104161,1},5354},{{0,101104162,1},972},{{0,101105161,1},714},{{0,101105162,1},108},{{0,102014161,1},5354},{{0,102014162,1},972},{{0,102015161,1},714},{{0,102015162,1},108},{{0,102024161,1},5354},{{0,102024162,1},972},{{0,102025161,1},714},{{0,102025162,1},108},{{0,102044161,1},5354},{{0,102044162,1},972},{{0,102045161,1},714},{{0,102045162,1},108},{{0,102064161,1},5354},{{0,102064162,1},972},{{0,102065161,1},714},{{0,102065162,1},108},{{0,102084161,1},5354},{{0,102084162,1},972},{{0,102085161,1},714},{{0,102085162,1},108},{{0,102104161,1},5354},{{0,102104162,1},972},{{0,102105161,1},714},{{0,102105162,1},108}]},{6,[{{0,101014161,1},6426},{{0,101013161,1},714},{{0,101024161,1},6426},{{0,101023161,1},714},{{0,101044161,1},6426},{{0,101043161,1},714},{{0,101064161,1},6426},{{0,101063161,1},714},{{0,101084161,1},6426},{{0,101083161,1},714},{{0,101104161,1},6426},{{0,101103161,1},714},{{0,102014161,1},6426},{{0,102013161,1},714},{{0,102024161,1},6426},{{0,102023161,1},714},{{0,102044161,1},6426},{{0,102043161,1},714},{{0,102064161,1},6426},{{0,102063161,1},714},{{0,102084161,1},6426},{{0,102083161,1},714},{{0,102104161,1},6426},{{0,102103161,1},714},{{0,101034161,1},6426},{{0,101033161,1},714},{{0,101054161,1},6426},{{0,101053161,1},714}]},{1,[{{3,0,5000},94000},{{0,101072060,1},3000},{{0,101092060,1},3000}]}],[]];
get_dragon_gift(_Day) ->
	[].

get_fire_exp_reward(_Lv) when _Lv >= 50, _Lv =< 50 ->
		[{5,0,1450163}];
get_fire_exp_reward(_Lv) when _Lv >= 51, _Lv =< 51 ->
		[{5,0,1455071}];
get_fire_exp_reward(_Lv) when _Lv >= 52, _Lv =< 52 ->
		[{5,0,1459996}];
get_fire_exp_reward(_Lv) when _Lv >= 53, _Lv =< 53 ->
		[{5,0,1464938}];
get_fire_exp_reward(_Lv) when _Lv >= 54, _Lv =< 54 ->
		[{5,0,1469896}];
get_fire_exp_reward(_Lv) when _Lv >= 55, _Lv =< 55 ->
		[{5,0,1474871}];
get_fire_exp_reward(_Lv) when _Lv >= 56, _Lv =< 56 ->
		[{5,0,1479863}];
get_fire_exp_reward(_Lv) when _Lv >= 57, _Lv =< 57 ->
		[{5,0,1484871}];
get_fire_exp_reward(_Lv) when _Lv >= 58, _Lv =< 58 ->
		[{5,0,1489897}];
get_fire_exp_reward(_Lv) when _Lv >= 59, _Lv =< 59 ->
		[{5,0,1494940}];
get_fire_exp_reward(_Lv) when _Lv >= 60, _Lv =< 60 ->
		[{5,0,1500000}];
get_fire_exp_reward(_Lv) when _Lv >= 61, _Lv =< 61 ->
		[{5,0,1505076}];
get_fire_exp_reward(_Lv) when _Lv >= 62, _Lv =< 62 ->
		[{5,0,1510170}];
get_fire_exp_reward(_Lv) when _Lv >= 63, _Lv =< 63 ->
		[{5,0,1515282}];
get_fire_exp_reward(_Lv) when _Lv >= 64, _Lv =< 64 ->
		[{5,0,1520410}];
get_fire_exp_reward(_Lv) when _Lv >= 65, _Lv =< 65 ->
		[{5,0,1525556}];
get_fire_exp_reward(_Lv) when _Lv >= 66, _Lv =< 66 ->
		[{5,0,1530720}];
get_fire_exp_reward(_Lv) when _Lv >= 67, _Lv =< 67 ->
		[{5,0,1535901}];
get_fire_exp_reward(_Lv) when _Lv >= 68, _Lv =< 68 ->
		[{5,0,1541099}];
get_fire_exp_reward(_Lv) when _Lv >= 69, _Lv =< 69 ->
		[{5,0,1546315}];
get_fire_exp_reward(_Lv) when _Lv >= 70, _Lv =< 70 ->
		[{5,0,1551549}];
get_fire_exp_reward(_Lv) when _Lv >= 71, _Lv =< 71 ->
		[{5,0,1556800}];
get_fire_exp_reward(_Lv) when _Lv >= 72, _Lv =< 72 ->
		[{5,0,1562069}];
get_fire_exp_reward(_Lv) when _Lv >= 73, _Lv =< 73 ->
		[{5,0,1567356}];
get_fire_exp_reward(_Lv) when _Lv >= 74, _Lv =< 74 ->
		[{5,0,1572661}];
get_fire_exp_reward(_Lv) when _Lv >= 75, _Lv =< 75 ->
		[{5,0,1577984}];
get_fire_exp_reward(_Lv) when _Lv >= 76, _Lv =< 76 ->
		[{5,0,1583325}];
get_fire_exp_reward(_Lv) when _Lv >= 77, _Lv =< 77 ->
		[{5,0,1588683}];
get_fire_exp_reward(_Lv) when _Lv >= 78, _Lv =< 78 ->
		[{5,0,1594061}];
get_fire_exp_reward(_Lv) when _Lv >= 79, _Lv =< 79 ->
		[{5,0,1599456}];
get_fire_exp_reward(_Lv) when _Lv >= 80, _Lv =< 80 ->
		[{5,0,1604869}];
get_fire_exp_reward(_Lv) when _Lv >= 81, _Lv =< 81 ->
		[{5,0,1610301}];
get_fire_exp_reward(_Lv) when _Lv >= 82, _Lv =< 82 ->
		[{5,0,1615751}];
get_fire_exp_reward(_Lv) when _Lv >= 83, _Lv =< 83 ->
		[{5,0,1621220}];
get_fire_exp_reward(_Lv) when _Lv >= 84, _Lv =< 84 ->
		[{5,0,1626707}];
get_fire_exp_reward(_Lv) when _Lv >= 85, _Lv =< 85 ->
		[{5,0,1632213}];
get_fire_exp_reward(_Lv) when _Lv >= 86, _Lv =< 86 ->
		[{5,0,1637737}];
get_fire_exp_reward(_Lv) when _Lv >= 87, _Lv =< 87 ->
		[{5,0,1643280}];
get_fire_exp_reward(_Lv) when _Lv >= 88, _Lv =< 88 ->
		[{5,0,1648842}];
get_fire_exp_reward(_Lv) when _Lv >= 89, _Lv =< 89 ->
		[{5,0,1654423}];
get_fire_exp_reward(_Lv) when _Lv >= 90, _Lv =< 90 ->
		[{5,0,1660022}];
get_fire_exp_reward(_Lv) when _Lv >= 91, _Lv =< 91 ->
		[{5,0,1665641}];
get_fire_exp_reward(_Lv) when _Lv >= 92, _Lv =< 92 ->
		[{5,0,1671278}];
get_fire_exp_reward(_Lv) when _Lv >= 93, _Lv =< 93 ->
		[{5,0,1676935}];
get_fire_exp_reward(_Lv) when _Lv >= 94, _Lv =< 94 ->
		[{5,0,1682611}];
get_fire_exp_reward(_Lv) when _Lv >= 95, _Lv =< 95 ->
		[{5,0,1688306}];
get_fire_exp_reward(_Lv) when _Lv >= 96, _Lv =< 96 ->
		[{5,0,1694020}];
get_fire_exp_reward(_Lv) when _Lv >= 97, _Lv =< 97 ->
		[{5,0,1699753}];
get_fire_exp_reward(_Lv) when _Lv >= 98, _Lv =< 98 ->
		[{5,0,1705506}];
get_fire_exp_reward(_Lv) when _Lv >= 99, _Lv =< 99 ->
		[{5,0,1711279}];
get_fire_exp_reward(_Lv) when _Lv >= 100, _Lv =< 100 ->
		[{5,0,1717071}];
get_fire_exp_reward(_Lv) when _Lv >= 101, _Lv =< 101 ->
		[{5,0,1722882}];
get_fire_exp_reward(_Lv) when _Lv >= 102, _Lv =< 102 ->
		[{5,0,1728714}];
get_fire_exp_reward(_Lv) when _Lv >= 103, _Lv =< 103 ->
		[{5,0,1734565}];
get_fire_exp_reward(_Lv) when _Lv >= 104, _Lv =< 104 ->
		[{5,0,1740435}];
get_fire_exp_reward(_Lv) when _Lv >= 105, _Lv =< 105 ->
		[{5,0,1746326}];
get_fire_exp_reward(_Lv) when _Lv >= 106, _Lv =< 106 ->
		[{5,0,1752237}];
get_fire_exp_reward(_Lv) when _Lv >= 107, _Lv =< 107 ->
		[{5,0,1758167}];
get_fire_exp_reward(_Lv) when _Lv >= 108, _Lv =< 108 ->
		[{5,0,1764118}];
get_fire_exp_reward(_Lv) when _Lv >= 109, _Lv =< 109 ->
		[{5,0,1770089}];
get_fire_exp_reward(_Lv) when _Lv >= 110, _Lv =< 110 ->
		[{5,0,1776080}];
get_fire_exp_reward(_Lv) when _Lv >= 111, _Lv =< 111 ->
		[{5,0,1782091}];
get_fire_exp_reward(_Lv) when _Lv >= 112, _Lv =< 112 ->
		[{5,0,1788123}];
get_fire_exp_reward(_Lv) when _Lv >= 113, _Lv =< 113 ->
		[{5,0,1794175}];
get_fire_exp_reward(_Lv) when _Lv >= 114, _Lv =< 114 ->
		[{5,0,1800247}];
get_fire_exp_reward(_Lv) when _Lv >= 115, _Lv =< 115 ->
		[{5,0,1806341}];
get_fire_exp_reward(_Lv) when _Lv >= 116, _Lv =< 116 ->
		[{5,0,1812454}];
get_fire_exp_reward(_Lv) when _Lv >= 117, _Lv =< 117 ->
		[{5,0,1818589}];
get_fire_exp_reward(_Lv) when _Lv >= 118, _Lv =< 118 ->
		[{5,0,1824744}];
get_fire_exp_reward(_Lv) when _Lv >= 119, _Lv =< 119 ->
		[{5,0,1830920}];
get_fire_exp_reward(_Lv) when _Lv >= 120, _Lv =< 120 ->
		[{5,0,1837117}];
get_fire_exp_reward(_Lv) when _Lv >= 121, _Lv =< 121 ->
		[{5,0,1843335}];
get_fire_exp_reward(_Lv) when _Lv >= 122, _Lv =< 122 ->
		[{5,0,1849574}];
get_fire_exp_reward(_Lv) when _Lv >= 123, _Lv =< 123 ->
		[{5,0,1855834}];
get_fire_exp_reward(_Lv) when _Lv >= 124, _Lv =< 124 ->
		[{5,0,1862115}];
get_fire_exp_reward(_Lv) when _Lv >= 125, _Lv =< 125 ->
		[{5,0,1868417}];
get_fire_exp_reward(_Lv) when _Lv >= 126, _Lv =< 126 ->
		[{5,0,1874741}];
get_fire_exp_reward(_Lv) when _Lv >= 127, _Lv =< 127 ->
		[{5,0,1881086}];
get_fire_exp_reward(_Lv) when _Lv >= 128, _Lv =< 128 ->
		[{5,0,1887453}];
get_fire_exp_reward(_Lv) when _Lv >= 129, _Lv =< 129 ->
		[{5,0,1893841}];
get_fire_exp_reward(_Lv) when _Lv >= 130, _Lv =< 130 ->
		[{5,0,1900251}];
get_fire_exp_reward(_Lv) when _Lv >= 131, _Lv =< 131 ->
		[{5,0,1906683}];
get_fire_exp_reward(_Lv) when _Lv >= 132, _Lv =< 132 ->
		[{5,0,1913136}];
get_fire_exp_reward(_Lv) when _Lv >= 133, _Lv =< 133 ->
		[{5,0,1919611}];
get_fire_exp_reward(_Lv) when _Lv >= 134, _Lv =< 134 ->
		[{5,0,1926109}];
get_fire_exp_reward(_Lv) when _Lv >= 135, _Lv =< 135 ->
		[{5,0,1932628}];
get_fire_exp_reward(_Lv) when _Lv >= 136, _Lv =< 136 ->
		[{5,0,1939169}];
get_fire_exp_reward(_Lv) when _Lv >= 137, _Lv =< 137 ->
		[{5,0,1945732}];
get_fire_exp_reward(_Lv) when _Lv >= 138, _Lv =< 138 ->
		[{5,0,1952318}];
get_fire_exp_reward(_Lv) when _Lv >= 139, _Lv =< 139 ->
		[{5,0,1958925}];
get_fire_exp_reward(_Lv) when _Lv >= 140, _Lv =< 140 ->
		[{5,0,1965556}];
get_fire_exp_reward(_Lv) when _Lv >= 141, _Lv =< 141 ->
		[{5,0,1972208}];
get_fire_exp_reward(_Lv) when _Lv >= 142, _Lv =< 142 ->
		[{5,0,1978883}];
get_fire_exp_reward(_Lv) when _Lv >= 143, _Lv =< 143 ->
		[{5,0,1985581}];
get_fire_exp_reward(_Lv) when _Lv >= 144, _Lv =< 144 ->
		[{5,0,1992301}];
get_fire_exp_reward(_Lv) when _Lv >= 145, _Lv =< 145 ->
		[{5,0,1999044}];
get_fire_exp_reward(_Lv) when _Lv >= 146, _Lv =< 146 ->
		[{5,0,2005810}];
get_fire_exp_reward(_Lv) when _Lv >= 147, _Lv =< 147 ->
		[{5,0,2012599}];
get_fire_exp_reward(_Lv) when _Lv >= 148, _Lv =< 148 ->
		[{5,0,2019411}];
get_fire_exp_reward(_Lv) when _Lv >= 149, _Lv =< 149 ->
		[{5,0,2026246}];
get_fire_exp_reward(_Lv) when _Lv >= 150, _Lv =< 150 ->
		[{5,0,2033104}];
get_fire_exp_reward(_Lv) when _Lv >= 151, _Lv =< 151 ->
		[{5,0,2039985}];
get_fire_exp_reward(_Lv) when _Lv >= 152, _Lv =< 152 ->
		[{5,0,2046890}];
get_fire_exp_reward(_Lv) when _Lv >= 153, _Lv =< 153 ->
		[{5,0,2053818}];
get_fire_exp_reward(_Lv) when _Lv >= 154, _Lv =< 154 ->
		[{5,0,2060769}];
get_fire_exp_reward(_Lv) when _Lv >= 155, _Lv =< 155 ->
		[{5,0,2067744}];
get_fire_exp_reward(_Lv) when _Lv >= 156, _Lv =< 156 ->
		[{5,0,2074742}];
get_fire_exp_reward(_Lv) when _Lv >= 157, _Lv =< 157 ->
		[{5,0,2081764}];
get_fire_exp_reward(_Lv) when _Lv >= 158, _Lv =< 158 ->
		[{5,0,2088810}];
get_fire_exp_reward(_Lv) when _Lv >= 159, _Lv =< 159 ->
		[{5,0,2095880}];
get_fire_exp_reward(_Lv) when _Lv >= 160, _Lv =< 160 ->
		[{5,0,2102974}];
get_fire_exp_reward(_Lv) when _Lv >= 161, _Lv =< 161 ->
		[{5,0,2110092}];
get_fire_exp_reward(_Lv) when _Lv >= 162, _Lv =< 162 ->
		[{5,0,2117233}];
get_fire_exp_reward(_Lv) when _Lv >= 163, _Lv =< 163 ->
		[{5,0,2124399}];
get_fire_exp_reward(_Lv) when _Lv >= 164, _Lv =< 164 ->
		[{5,0,2131590}];
get_fire_exp_reward(_Lv) when _Lv >= 165, _Lv =< 165 ->
		[{5,0,2138804}];
get_fire_exp_reward(_Lv) when _Lv >= 166, _Lv =< 166 ->
		[{5,0,2146043}];
get_fire_exp_reward(_Lv) when _Lv >= 167, _Lv =< 167 ->
		[{5,0,2153307}];
get_fire_exp_reward(_Lv) when _Lv >= 168, _Lv =< 168 ->
		[{5,0,2160595}];
get_fire_exp_reward(_Lv) when _Lv >= 169, _Lv =< 169 ->
		[{5,0,2167907}];
get_fire_exp_reward(_Lv) when _Lv >= 170, _Lv =< 170 ->
		[{5,0,2175245}];
get_fire_exp_reward(_Lv) when _Lv >= 171, _Lv =< 171 ->
		[{5,0,2182607}];
get_fire_exp_reward(_Lv) when _Lv >= 172, _Lv =< 172 ->
		[{5,0,2189994}];
get_fire_exp_reward(_Lv) when _Lv >= 173, _Lv =< 173 ->
		[{5,0,2197407}];
get_fire_exp_reward(_Lv) when _Lv >= 174, _Lv =< 174 ->
		[{5,0,2204844}];
get_fire_exp_reward(_Lv) when _Lv >= 175, _Lv =< 175 ->
		[{5,0,2212306}];
get_fire_exp_reward(_Lv) when _Lv >= 176, _Lv =< 176 ->
		[{5,0,2219794}];
get_fire_exp_reward(_Lv) when _Lv >= 177, _Lv =< 177 ->
		[{5,0,2227307}];
get_fire_exp_reward(_Lv) when _Lv >= 178, _Lv =< 178 ->
		[{5,0,2234846}];
get_fire_exp_reward(_Lv) when _Lv >= 179, _Lv =< 179 ->
		[{5,0,2242410}];
get_fire_exp_reward(_Lv) when _Lv >= 180, _Lv =< 180 ->
		[{5,0,2250000}];
get_fire_exp_reward(_Lv) when _Lv >= 181, _Lv =< 181 ->
		[{5,0,2257615}];
get_fire_exp_reward(_Lv) when _Lv >= 182, _Lv =< 182 ->
		[{5,0,2265256}];
get_fire_exp_reward(_Lv) when _Lv >= 183, _Lv =< 183 ->
		[{5,0,2272923}];
get_fire_exp_reward(_Lv) when _Lv >= 184, _Lv =< 184 ->
		[{5,0,2280616}];
get_fire_exp_reward(_Lv) when _Lv >= 185, _Lv =< 185 ->
		[{5,0,2288335}];
get_fire_exp_reward(_Lv) when _Lv >= 186, _Lv =< 186 ->
		[{5,0,2296080}];
get_fire_exp_reward(_Lv) when _Lv >= 187, _Lv =< 187 ->
		[{5,0,2303851}];
get_fire_exp_reward(_Lv) when _Lv >= 188, _Lv =< 188 ->
		[{5,0,2311649}];
get_fire_exp_reward(_Lv) when _Lv >= 189, _Lv =< 189 ->
		[{5,0,2319473}];
get_fire_exp_reward(_Lv) when _Lv >= 190, _Lv =< 190 ->
		[{5,0,2327323}];
get_fire_exp_reward(_Lv) when _Lv >= 191, _Lv =< 191 ->
		[{5,0,2335200}];
get_fire_exp_reward(_Lv) when _Lv >= 192, _Lv =< 192 ->
		[{5,0,2343104}];
get_fire_exp_reward(_Lv) when _Lv >= 193, _Lv =< 193 ->
		[{5,0,2351034}];
get_fire_exp_reward(_Lv) when _Lv >= 194, _Lv =< 194 ->
		[{5,0,2358992}];
get_fire_exp_reward(_Lv) when _Lv >= 195, _Lv =< 195 ->
		[{5,0,2366976}];
get_fire_exp_reward(_Lv) when _Lv >= 196, _Lv =< 196 ->
		[{5,0,2374987}];
get_fire_exp_reward(_Lv) when _Lv >= 197, _Lv =< 197 ->
		[{5,0,2383025}];
get_fire_exp_reward(_Lv) when _Lv >= 198, _Lv =< 198 ->
		[{5,0,2391091}];
get_fire_exp_reward(_Lv) when _Lv >= 199, _Lv =< 199 ->
		[{5,0,2399184}];
get_fire_exp_reward(_Lv) when _Lv >= 200, _Lv =< 200 ->
		[{5,0,2407304}];
get_fire_exp_reward(_Lv) when _Lv >= 201, _Lv =< 201 ->
		[{5,0,2415452}];
get_fire_exp_reward(_Lv) when _Lv >= 202, _Lv =< 202 ->
		[{5,0,2423627}];
get_fire_exp_reward(_Lv) when _Lv >= 203, _Lv =< 203 ->
		[{5,0,2431830}];
get_fire_exp_reward(_Lv) when _Lv >= 204, _Lv =< 204 ->
		[{5,0,2440061}];
get_fire_exp_reward(_Lv) when _Lv >= 205, _Lv =< 205 ->
		[{5,0,2448320}];
get_fire_exp_reward(_Lv) when _Lv >= 206, _Lv =< 206 ->
		[{5,0,2456606}];
get_fire_exp_reward(_Lv) when _Lv >= 207, _Lv =< 207 ->
		[{5,0,2464921}];
get_fire_exp_reward(_Lv) when _Lv >= 208, _Lv =< 208 ->
		[{5,0,2473264}];
get_fire_exp_reward(_Lv) when _Lv >= 209, _Lv =< 209 ->
		[{5,0,2481635}];
get_fire_exp_reward(_Lv) when _Lv >= 210, _Lv =< 210 ->
		[{5,0,2490034}];
get_fire_exp_reward(_Lv) when _Lv >= 211, _Lv =< 211 ->
		[{5,0,2498462}];
get_fire_exp_reward(_Lv) when _Lv >= 212, _Lv =< 212 ->
		[{5,0,2506918}];
get_fire_exp_reward(_Lv) when _Lv >= 213, _Lv =< 213 ->
		[{5,0,2515403}];
get_fire_exp_reward(_Lv) when _Lv >= 214, _Lv =< 214 ->
		[{5,0,2523916}];
get_fire_exp_reward(_Lv) when _Lv >= 215, _Lv =< 215 ->
		[{5,0,2532459}];
get_fire_exp_reward(_Lv) when _Lv >= 216, _Lv =< 216 ->
		[{5,0,2541030}];
get_fire_exp_reward(_Lv) when _Lv >= 217, _Lv =< 217 ->
		[{5,0,2549630}];
get_fire_exp_reward(_Lv) when _Lv >= 218, _Lv =< 218 ->
		[{5,0,2558260}];
get_fire_exp_reward(_Lv) when _Lv >= 219, _Lv =< 219 ->
		[{5,0,2566919}];
get_fire_exp_reward(_Lv) when _Lv >= 220, _Lv =< 220 ->
		[{5,0,2575607}];
get_fire_exp_reward(_Lv) when _Lv >= 221, _Lv =< 221 ->
		[{5,0,2584324}];
get_fire_exp_reward(_Lv) when _Lv >= 222, _Lv =< 222 ->
		[{5,0,2593071}];
get_fire_exp_reward(_Lv) when _Lv >= 223, _Lv =< 223 ->
		[{5,0,2601847}];
get_fire_exp_reward(_Lv) when _Lv >= 224, _Lv =< 224 ->
		[{5,0,2610653}];
get_fire_exp_reward(_Lv) when _Lv >= 225, _Lv =< 225 ->
		[{5,0,2619489}];
get_fire_exp_reward(_Lv) when _Lv >= 226, _Lv =< 226 ->
		[{5,0,2628355}];
get_fire_exp_reward(_Lv) when _Lv >= 227, _Lv =< 227 ->
		[{5,0,2637251}];
get_fire_exp_reward(_Lv) when _Lv >= 228, _Lv =< 228 ->
		[{5,0,2646177}];
get_fire_exp_reward(_Lv) when _Lv >= 229, _Lv =< 229 ->
		[{5,0,2655134}];
get_fire_exp_reward(_Lv) when _Lv >= 230, _Lv =< 230 ->
		[{5,0,2664120}];
get_fire_exp_reward(_Lv) when _Lv >= 231, _Lv =< 231 ->
		[{5,0,2673137}];
get_fire_exp_reward(_Lv) when _Lv >= 232, _Lv =< 232 ->
		[{5,0,2682185}];
get_fire_exp_reward(_Lv) when _Lv >= 233, _Lv =< 233 ->
		[{5,0,2691263}];
get_fire_exp_reward(_Lv) when _Lv >= 234, _Lv =< 234 ->
		[{5,0,2700371}];
get_fire_exp_reward(_Lv) when _Lv >= 235, _Lv =< 235 ->
		[{5,0,2709511}];
get_fire_exp_reward(_Lv) when _Lv >= 236, _Lv =< 236 ->
		[{5,0,2718682}];
get_fire_exp_reward(_Lv) when _Lv >= 237, _Lv =< 237 ->
		[{5,0,2727883}];
get_fire_exp_reward(_Lv) when _Lv >= 238, _Lv =< 238 ->
		[{5,0,2737116}];
get_fire_exp_reward(_Lv) when _Lv >= 239, _Lv =< 239 ->
		[{5,0,2746380}];
get_fire_exp_reward(_Lv) when _Lv >= 240, _Lv =< 240 ->
		[{5,0,2755675}];
get_fire_exp_reward(_Lv) when _Lv >= 241, _Lv =< 241 ->
		[{5,0,2765002}];
get_fire_exp_reward(_Lv) when _Lv >= 242, _Lv =< 242 ->
		[{5,0,2774361}];
get_fire_exp_reward(_Lv) when _Lv >= 243, _Lv =< 243 ->
		[{5,0,2783751}];
get_fire_exp_reward(_Lv) when _Lv >= 244, _Lv =< 244 ->
		[{5,0,2793173}];
get_fire_exp_reward(_Lv) when _Lv >= 245, _Lv =< 245 ->
		[{5,0,2802626}];
get_fire_exp_reward(_Lv) when _Lv >= 246, _Lv =< 246 ->
		[{5,0,2812112}];
get_fire_exp_reward(_Lv) when _Lv >= 247, _Lv =< 247 ->
		[{5,0,2821630}];
get_fire_exp_reward(_Lv) when _Lv >= 248, _Lv =< 248 ->
		[{5,0,2831180}];
get_fire_exp_reward(_Lv) when _Lv >= 249, _Lv =< 249 ->
		[{5,0,2840762}];
get_fire_exp_reward(_Lv) when _Lv >= 250, _Lv =< 250 ->
		[{5,0,2850377}];
get_fire_exp_reward(_Lv) when _Lv >= 251, _Lv =< 251 ->
		[{5,0,2860025}];
get_fire_exp_reward(_Lv) when _Lv >= 252, _Lv =< 252 ->
		[{5,0,2869705}];
get_fire_exp_reward(_Lv) when _Lv >= 253, _Lv =< 253 ->
		[{5,0,2879417}];
get_fire_exp_reward(_Lv) when _Lv >= 254, _Lv =< 254 ->
		[{5,0,2889163}];
get_fire_exp_reward(_Lv) when _Lv >= 255, _Lv =< 255 ->
		[{5,0,2898942}];
get_fire_exp_reward(_Lv) when _Lv >= 256, _Lv =< 256 ->
		[{5,0,2908753}];
get_fire_exp_reward(_Lv) when _Lv >= 257, _Lv =< 257 ->
		[{5,0,2918598}];
get_fire_exp_reward(_Lv) when _Lv >= 258, _Lv =< 258 ->
		[{5,0,2928477}];
get_fire_exp_reward(_Lv) when _Lv >= 259, _Lv =< 259 ->
		[{5,0,2938388}];
get_fire_exp_reward(_Lv) when _Lv >= 260, _Lv =< 260 ->
		[{5,0,2948334}];
get_fire_exp_reward(_Lv) when _Lv >= 261, _Lv =< 261 ->
		[{5,0,2958312}];
get_fire_exp_reward(_Lv) when _Lv >= 262, _Lv =< 262 ->
		[{5,0,2968325}];
get_fire_exp_reward(_Lv) when _Lv >= 263, _Lv =< 263 ->
		[{5,0,2978372}];
get_fire_exp_reward(_Lv) when _Lv >= 264, _Lv =< 264 ->
		[{5,0,2988452}];
get_fire_exp_reward(_Lv) when _Lv >= 265, _Lv =< 265 ->
		[{5,0,2998567}];
get_fire_exp_reward(_Lv) when _Lv >= 266, _Lv =< 266 ->
		[{5,0,3008716}];
get_fire_exp_reward(_Lv) when _Lv >= 267, _Lv =< 267 ->
		[{5,0,3018899}];
get_fire_exp_reward(_Lv) when _Lv >= 268, _Lv =< 268 ->
		[{5,0,3029117}];
get_fire_exp_reward(_Lv) when _Lv >= 269, _Lv =< 269 ->
		[{5,0,3039369}];
get_fire_exp_reward(_Lv) when _Lv >= 270, _Lv =< 270 ->
		[{5,0,3049656}];
get_fire_exp_reward(_Lv) when _Lv >= 271, _Lv =< 271 ->
		[{5,0,3059978}];
get_fire_exp_reward(_Lv) when _Lv >= 272, _Lv =< 272 ->
		[{5,0,3070335}];
get_fire_exp_reward(_Lv) when _Lv >= 273, _Lv =< 273 ->
		[{5,0,3080727}];
get_fire_exp_reward(_Lv) when _Lv >= 274, _Lv =< 274 ->
		[{5,0,3091154}];
get_fire_exp_reward(_Lv) when _Lv >= 275, _Lv =< 275 ->
		[{5,0,3101616}];
get_fire_exp_reward(_Lv) when _Lv >= 276, _Lv =< 276 ->
		[{5,0,3112114}];
get_fire_exp_reward(_Lv) when _Lv >= 277, _Lv =< 277 ->
		[{5,0,3122647}];
get_fire_exp_reward(_Lv) when _Lv >= 278, _Lv =< 278 ->
		[{5,0,3133216}];
get_fire_exp_reward(_Lv) when _Lv >= 279, _Lv =< 279 ->
		[{5,0,3143820}];
get_fire_exp_reward(_Lv) when _Lv >= 280, _Lv =< 280 ->
		[{5,0,3154461}];
get_fire_exp_reward(_Lv) when _Lv >= 281, _Lv =< 281 ->
		[{5,0,3165138}];
get_fire_exp_reward(_Lv) when _Lv >= 282, _Lv =< 282 ->
		[{5,0,3175850}];
get_fire_exp_reward(_Lv) when _Lv >= 283, _Lv =< 283 ->
		[{5,0,3186599}];
get_fire_exp_reward(_Lv) when _Lv >= 284, _Lv =< 284 ->
		[{5,0,3197385}];
get_fire_exp_reward(_Lv) when _Lv >= 285, _Lv =< 285 ->
		[{5,0,3208206}];
get_fire_exp_reward(_Lv) when _Lv >= 286, _Lv =< 286 ->
		[{5,0,3219065}];
get_fire_exp_reward(_Lv) when _Lv >= 287, _Lv =< 287 ->
		[{5,0,3229960}];
get_fire_exp_reward(_Lv) when _Lv >= 288, _Lv =< 288 ->
		[{5,0,3240892}];
get_fire_exp_reward(_Lv) when _Lv >= 289, _Lv =< 289 ->
		[{5,0,3251861}];
get_fire_exp_reward(_Lv) when _Lv >= 290, _Lv =< 290 ->
		[{5,0,3262868}];
get_fire_exp_reward(_Lv) when _Lv >= 291, _Lv =< 291 ->
		[{5,0,3273911}];
get_fire_exp_reward(_Lv) when _Lv >= 292, _Lv =< 292 ->
		[{5,0,3284992}];
get_fire_exp_reward(_Lv) when _Lv >= 293, _Lv =< 293 ->
		[{5,0,3296110}];
get_fire_exp_reward(_Lv) when _Lv >= 294, _Lv =< 294 ->
		[{5,0,3307266}];
get_fire_exp_reward(_Lv) when _Lv >= 295, _Lv =< 295 ->
		[{5,0,3318460}];
get_fire_exp_reward(_Lv) when _Lv >= 296, _Lv =< 296 ->
		[{5,0,3329692}];
get_fire_exp_reward(_Lv) when _Lv >= 297, _Lv =< 297 ->
		[{5,0,3340961}];
get_fire_exp_reward(_Lv) when _Lv >= 298, _Lv =< 298 ->
		[{5,0,3352269}];
get_fire_exp_reward(_Lv) when _Lv >= 299, _Lv =< 299 ->
		[{5,0,3363615}];
get_fire_exp_reward(_Lv) when _Lv >= 300, _Lv =< 300 ->
		[{5,0,3375000}];
get_fire_exp_reward(_Lv) when _Lv >= 301, _Lv =< 301 ->
		[{5,0,3386422}];
get_fire_exp_reward(_Lv) when _Lv >= 302, _Lv =< 302 ->
		[{5,0,3397884}];
get_fire_exp_reward(_Lv) when _Lv >= 303, _Lv =< 303 ->
		[{5,0,3409385}];
get_fire_exp_reward(_Lv) when _Lv >= 304, _Lv =< 304 ->
		[{5,0,3420924}];
get_fire_exp_reward(_Lv) when _Lv >= 305, _Lv =< 305 ->
		[{5,0,3432502}];
get_fire_exp_reward(_Lv) when _Lv >= 306, _Lv =< 306 ->
		[{5,0,3444120}];
get_fire_exp_reward(_Lv) when _Lv >= 307, _Lv =< 307 ->
		[{5,0,3455777}];
get_fire_exp_reward(_Lv) when _Lv >= 308, _Lv =< 308 ->
		[{5,0,3467473}];
get_fire_exp_reward(_Lv) when _Lv >= 309, _Lv =< 309 ->
		[{5,0,3479209}];
get_fire_exp_reward(_Lv) when _Lv >= 310, _Lv =< 310 ->
		[{5,0,3490985}];
get_fire_exp_reward(_Lv) when _Lv >= 311, _Lv =< 311 ->
		[{5,0,3502801}];
get_fire_exp_reward(_Lv) when _Lv >= 312, _Lv =< 312 ->
		[{5,0,3514656}];
get_fire_exp_reward(_Lv) when _Lv >= 313, _Lv =< 313 ->
		[{5,0,3526552}];
get_fire_exp_reward(_Lv) when _Lv >= 314, _Lv =< 314 ->
		[{5,0,3538488}];
get_fire_exp_reward(_Lv) when _Lv >= 315, _Lv =< 315 ->
		[{5,0,3550464}];
get_fire_exp_reward(_Lv) when _Lv >= 316, _Lv =< 316 ->
		[{5,0,3562481}];
get_fire_exp_reward(_Lv) when _Lv >= 317, _Lv =< 317 ->
		[{5,0,3574538}];
get_fire_exp_reward(_Lv) when _Lv >= 318, _Lv =< 318 ->
		[{5,0,3586637}];
get_fire_exp_reward(_Lv) when _Lv >= 319, _Lv =< 319 ->
		[{5,0,3598776}];
get_fire_exp_reward(_Lv) when _Lv >= 320, _Lv =< 320 ->
		[{5,0,3610957}];
get_fire_exp_reward(_Lv) when _Lv >= 321, _Lv =< 321 ->
		[{5,0,3623178}];
get_fire_exp_reward(_Lv) when _Lv >= 322, _Lv =< 322 ->
		[{5,0,3635441}];
get_fire_exp_reward(_Lv) when _Lv >= 323, _Lv =< 323 ->
		[{5,0,3647746}];
get_fire_exp_reward(_Lv) when _Lv >= 324, _Lv =< 324 ->
		[{5,0,3660092}];
get_fire_exp_reward(_Lv) when _Lv >= 325, _Lv =< 325 ->
		[{5,0,3672480}];
get_fire_exp_reward(_Lv) when _Lv >= 326, _Lv =< 326 ->
		[{5,0,3684909}];
get_fire_exp_reward(_Lv) when _Lv >= 327, _Lv =< 327 ->
		[{5,0,3697381}];
get_fire_exp_reward(_Lv) when _Lv >= 328, _Lv =< 328 ->
		[{5,0,3709896}];
get_fire_exp_reward(_Lv) when _Lv >= 329, _Lv =< 329 ->
		[{5,0,3722452}];
get_fire_exp_reward(_Lv) when _Lv >= 330, _Lv =< 330 ->
		[{5,0,3735051}];
get_fire_exp_reward(_Lv) when _Lv >= 331, _Lv =< 331 ->
		[{5,0,3747693}];
get_fire_exp_reward(_Lv) when _Lv >= 332, _Lv =< 332 ->
		[{5,0,3760377}];
get_fire_exp_reward(_Lv) when _Lv >= 333, _Lv =< 333 ->
		[{5,0,3773104}];
get_fire_exp_reward(_Lv) when _Lv >= 334, _Lv =< 334 ->
		[{5,0,3785875}];
get_fire_exp_reward(_Lv) when _Lv >= 335, _Lv =< 335 ->
		[{5,0,3798688}];
get_fire_exp_reward(_Lv) when _Lv >= 336, _Lv =< 336 ->
		[{5,0,3811545}];
get_fire_exp_reward(_Lv) when _Lv >= 337, _Lv =< 337 ->
		[{5,0,3824446}];
get_fire_exp_reward(_Lv) when _Lv >= 338, _Lv =< 338 ->
		[{5,0,3837390}];
get_fire_exp_reward(_Lv) when _Lv >= 339, _Lv =< 339 ->
		[{5,0,3850378}];
get_fire_exp_reward(_Lv) when _Lv >= 340, _Lv =< 340 ->
		[{5,0,3863410}];
get_fire_exp_reward(_Lv) when _Lv >= 341, _Lv =< 341 ->
		[{5,0,3876486}];
get_fire_exp_reward(_Lv) when _Lv >= 342, _Lv =< 342 ->
		[{5,0,3889606}];
get_fire_exp_reward(_Lv) when _Lv >= 343, _Lv =< 343 ->
		[{5,0,3902771}];
get_fire_exp_reward(_Lv) when _Lv >= 344, _Lv =< 344 ->
		[{5,0,3915980}];
get_fire_exp_reward(_Lv) when _Lv >= 345, _Lv =< 345 ->
		[{5,0,3929234}];
get_fire_exp_reward(_Lv) when _Lv >= 346, _Lv =< 346 ->
		[{5,0,3942533}];
get_fire_exp_reward(_Lv) when _Lv >= 347, _Lv =< 347 ->
		[{5,0,3955877}];
get_fire_exp_reward(_Lv) when _Lv >= 348, _Lv =< 348 ->
		[{5,0,3969266}];
get_fire_exp_reward(_Lv) when _Lv >= 349, _Lv =< 349 ->
		[{5,0,3982701}];
get_fire_exp_reward(_Lv) when _Lv >= 350, _Lv =< 350 ->
		[{5,0,3996180}];
get_fire_exp_reward(_Lv) when _Lv >= 351, _Lv =< 351 ->
		[{5,0,4009706}];
get_fire_exp_reward(_Lv) when _Lv >= 352, _Lv =< 352 ->
		[{5,0,4023277}];
get_fire_exp_reward(_Lv) when _Lv >= 353, _Lv =< 353 ->
		[{5,0,4036894}];
get_fire_exp_reward(_Lv) when _Lv >= 354, _Lv =< 354 ->
		[{5,0,4050557}];
get_fire_exp_reward(_Lv) when _Lv >= 355, _Lv =< 355 ->
		[{5,0,4064267}];
get_fire_exp_reward(_Lv) when _Lv >= 356, _Lv =< 356 ->
		[{5,0,4078023}];
get_fire_exp_reward(_Lv) when _Lv >= 357, _Lv =< 357 ->
		[{5,0,4091825}];
get_fire_exp_reward(_Lv) when _Lv >= 358, _Lv =< 358 ->
		[{5,0,4105674}];
get_fire_exp_reward(_Lv) when _Lv >= 359, _Lv =< 359 ->
		[{5,0,4119570}];
get_fire_exp_reward(_Lv) when _Lv >= 360, _Lv =< 360 ->
		[{5,0,4133513}];
get_fire_exp_reward(_Lv) when _Lv >= 361, _Lv =< 361 ->
		[{5,0,4147504}];
get_fire_exp_reward(_Lv) when _Lv >= 362, _Lv =< 362 ->
		[{5,0,4161541}];
get_fire_exp_reward(_Lv) when _Lv >= 363, _Lv =< 363 ->
		[{5,0,4175626}];
get_fire_exp_reward(_Lv) when _Lv >= 364, _Lv =< 364 ->
		[{5,0,4189759}];
get_fire_exp_reward(_Lv) when _Lv >= 365, _Lv =< 365 ->
		[{5,0,4203940}];
get_fire_exp_reward(_Lv) when _Lv >= 366, _Lv =< 366 ->
		[{5,0,4218168}];
get_fire_exp_reward(_Lv) when _Lv >= 367, _Lv =< 367 ->
		[{5,0,4232445}];
get_fire_exp_reward(_Lv) when _Lv >= 368, _Lv =< 368 ->
		[{5,0,4246770}];
get_fire_exp_reward(_Lv) when _Lv >= 369, _Lv =< 369 ->
		[{5,0,4261144}];
get_fire_exp_reward(_Lv) when _Lv >= 370, _Lv =< 370 ->
		[{5,0,4275566}];
get_fire_exp_reward(_Lv) when _Lv >= 371, _Lv =< 371 ->
		[{5,0,4290037}];
get_fire_exp_reward(_Lv) when _Lv >= 372, _Lv =< 372 ->
		[{5,0,4304557}];
get_fire_exp_reward(_Lv) when _Lv >= 373, _Lv =< 373 ->
		[{5,0,4319126}];
get_fire_exp_reward(_Lv) when _Lv >= 374, _Lv =< 374 ->
		[{5,0,4333745}];
get_fire_exp_reward(_Lv) when _Lv >= 375, _Lv =< 375 ->
		[{5,0,4348413}];
get_fire_exp_reward(_Lv) when _Lv >= 376, _Lv =< 376 ->
		[{5,0,4363130}];
get_fire_exp_reward(_Lv) when _Lv >= 377, _Lv =< 377 ->
		[{5,0,4377898}];
get_fire_exp_reward(_Lv) when _Lv >= 378, _Lv =< 378 ->
		[{5,0,4392715}];
get_fire_exp_reward(_Lv) when _Lv >= 379, _Lv =< 379 ->
		[{5,0,4407583}];
get_fire_exp_reward(_Lv) when _Lv >= 380, _Lv =< 380 ->
		[{5,0,4422501}];
get_fire_exp_reward(_Lv) when _Lv >= 381, _Lv =< 381 ->
		[{5,0,4437469}];
get_fire_exp_reward(_Lv) when _Lv >= 382, _Lv =< 382 ->
		[{5,0,4452488}];
get_fire_exp_reward(_Lv) when _Lv >= 383, _Lv =< 383 ->
		[{5,0,4467558}];
get_fire_exp_reward(_Lv) when _Lv >= 384, _Lv =< 384 ->
		[{5,0,4482679}];
get_fire_exp_reward(_Lv) when _Lv >= 385, _Lv =< 385 ->
		[{5,0,4497851}];
get_fire_exp_reward(_Lv) when _Lv >= 386, _Lv =< 386 ->
		[{5,0,4513074}];
get_fire_exp_reward(_Lv) when _Lv >= 387, _Lv =< 387 ->
		[{5,0,4528349}];
get_fire_exp_reward(_Lv) when _Lv >= 388, _Lv =< 388 ->
		[{5,0,4543676}];
get_fire_exp_reward(_Lv) when _Lv >= 389, _Lv =< 389 ->
		[{5,0,4559054}];
get_fire_exp_reward(_Lv) when _Lv >= 390, _Lv =< 390 ->
		[{5,0,4574485}];
get_fire_exp_reward(_Lv) when _Lv >= 391, _Lv =< 391 ->
		[{5,0,4589967}];
get_fire_exp_reward(_Lv) when _Lv >= 392, _Lv =< 392 ->
		[{5,0,4605503}];
get_fire_exp_reward(_Lv) when _Lv >= 393, _Lv =< 393 ->
		[{5,0,4621090}];
get_fire_exp_reward(_Lv) when _Lv >= 394, _Lv =< 394 ->
		[{5,0,4636731}];
get_fire_exp_reward(_Lv) when _Lv >= 395, _Lv =< 395 ->
		[{5,0,4652424}];
get_fire_exp_reward(_Lv) when _Lv >= 396, _Lv =< 396 ->
		[{5,0,4668171}];
get_fire_exp_reward(_Lv) when _Lv >= 397, _Lv =< 397 ->
		[{5,0,4683971}];
get_fire_exp_reward(_Lv) when _Lv >= 398, _Lv =< 398 ->
		[{5,0,4699824}];
get_fire_exp_reward(_Lv) when _Lv >= 399, _Lv =< 399 ->
		[{5,0,4715731}];
get_fire_exp_reward(_Lv) when _Lv >= 400, _Lv =< 400 ->
		[{5,0,4731692}];
get_fire_exp_reward(_Lv) when _Lv >= 401, _Lv =< 401 ->
		[{5,0,4747707}];
get_fire_exp_reward(_Lv) when _Lv >= 402, _Lv =< 402 ->
		[{5,0,4763776}];
get_fire_exp_reward(_Lv) when _Lv >= 403, _Lv =< 403 ->
		[{5,0,4779899}];
get_fire_exp_reward(_Lv) when _Lv >= 404, _Lv =< 404 ->
		[{5,0,4796077}];
get_fire_exp_reward(_Lv) when _Lv >= 405, _Lv =< 405 ->
		[{5,0,4812310}];
get_fire_exp_reward(_Lv) when _Lv >= 406, _Lv =< 406 ->
		[{5,0,4828598}];
get_fire_exp_reward(_Lv) when _Lv >= 407, _Lv =< 407 ->
		[{5,0,4844940}];
get_fire_exp_reward(_Lv) when _Lv >= 408, _Lv =< 408 ->
		[{5,0,4861339}];
get_fire_exp_reward(_Lv) when _Lv >= 409, _Lv =< 409 ->
		[{5,0,4877792}];
get_fire_exp_reward(_Lv) when _Lv >= 410, _Lv =< 410 ->
		[{5,0,4894302}];
get_fire_exp_reward(_Lv) when _Lv >= 411, _Lv =< 411 ->
		[{5,0,4910867}];
get_fire_exp_reward(_Lv) when _Lv >= 412, _Lv =< 412 ->
		[{5,0,4927488}];
get_fire_exp_reward(_Lv) when _Lv >= 413, _Lv =< 413 ->
		[{5,0,4944166}];
get_fire_exp_reward(_Lv) when _Lv >= 414, _Lv =< 414 ->
		[{5,0,4960900}];
get_fire_exp_reward(_Lv) when _Lv >= 415, _Lv =< 415 ->
		[{5,0,4977690}];
get_fire_exp_reward(_Lv) when _Lv >= 416, _Lv =< 416 ->
		[{5,0,4994538}];
get_fire_exp_reward(_Lv) when _Lv >= 417, _Lv =< 417 ->
		[{5,0,5011442}];
get_fire_exp_reward(_Lv) when _Lv >= 418, _Lv =< 418 ->
		[{5,0,5028404}];
get_fire_exp_reward(_Lv) when _Lv >= 419, _Lv =< 419 ->
		[{5,0,5045423}];
get_fire_exp_reward(_Lv) when _Lv >= 420, _Lv =< 420 ->
		[{5,0,5062500}];
get_fire_exp_reward(_Lv) when _Lv >= 421, _Lv =< 421 ->
		[{5,0,5079634}];
get_fire_exp_reward(_Lv) when _Lv >= 422, _Lv =< 422 ->
		[{5,0,5096826}];
get_fire_exp_reward(_Lv) when _Lv >= 423, _Lv =< 423 ->
		[{5,0,5114077}];
get_fire_exp_reward(_Lv) when _Lv >= 424, _Lv =< 424 ->
		[{5,0,5131386}];
get_fire_exp_reward(_Lv) when _Lv >= 425, _Lv =< 425 ->
		[{5,0,5148754}];
get_fire_exp_reward(_Lv) when _Lv >= 426, _Lv =< 426 ->
		[{5,0,5166180}];
get_fire_exp_reward(_Lv) when _Lv >= 427, _Lv =< 427 ->
		[{5,0,5183666}];
get_fire_exp_reward(_Lv) when _Lv >= 428, _Lv =< 428 ->
		[{5,0,5201210}];
get_fire_exp_reward(_Lv) when _Lv >= 429, _Lv =< 429 ->
		[{5,0,5218814}];
get_fire_exp_reward(_Lv) when _Lv >= 430, _Lv =< 430 ->
		[{5,0,5236478}];
get_fire_exp_reward(_Lv) when _Lv >= 431, _Lv =< 431 ->
		[{5,0,5254201}];
get_fire_exp_reward(_Lv) when _Lv >= 432, _Lv =< 432 ->
		[{5,0,5271984}];
get_fire_exp_reward(_Lv) when _Lv >= 433, _Lv =< 433 ->
		[{5,0,5289828}];
get_fire_exp_reward(_Lv) when _Lv >= 434, _Lv =< 434 ->
		[{5,0,5307732}];
get_fire_exp_reward(_Lv) when _Lv >= 435, _Lv =< 435 ->
		[{5,0,5325696}];
get_fire_exp_reward(_Lv) when _Lv >= 436, _Lv =< 436 ->
		[{5,0,5343722}];
get_fire_exp_reward(_Lv) when _Lv >= 437, _Lv =< 437 ->
		[{5,0,5361808}];
get_fire_exp_reward(_Lv) when _Lv >= 438, _Lv =< 438 ->
		[{5,0,5379956}];
get_fire_exp_reward(_Lv) when _Lv >= 439, _Lv =< 439 ->
		[{5,0,5398164}];
get_fire_exp_reward(_Lv) when _Lv >= 440, _Lv =< 440 ->
		[{5,0,5416435}];
get_fire_exp_reward(_Lv) when _Lv >= 441, _Lv =< 441 ->
		[{5,0,5434767}];
get_fire_exp_reward(_Lv) when _Lv >= 442, _Lv =< 442 ->
		[{5,0,5453162}];
get_fire_exp_reward(_Lv) when _Lv >= 443, _Lv =< 443 ->
		[{5,0,5471619}];
get_fire_exp_reward(_Lv) when _Lv >= 444, _Lv =< 444 ->
		[{5,0,5490138}];
get_fire_exp_reward(_Lv) when _Lv >= 445, _Lv =< 445 ->
		[{5,0,5508720}];
get_fire_exp_reward(_Lv) when _Lv >= 446, _Lv =< 446 ->
		[{5,0,5527364}];
get_fire_exp_reward(_Lv) when _Lv >= 447, _Lv =< 447 ->
		[{5,0,5546072}];
get_fire_exp_reward(_Lv) when _Lv >= 448, _Lv =< 448 ->
		[{5,0,5564844}];
get_fire_exp_reward(_Lv) when _Lv >= 449, _Lv =< 449 ->
		[{5,0,5583678}];
get_fire_exp_reward(_Lv) when _Lv >= 450, _Lv =< 450 ->
		[{5,0,5602577}];
get_fire_exp_reward(_Lv) when _Lv >= 451, _Lv =< 451 ->
		[{5,0,5621539}];
get_fire_exp_reward(_Lv) when _Lv >= 452, _Lv =< 452 ->
		[{5,0,5640566}];
get_fire_exp_reward(_Lv) when _Lv >= 453, _Lv =< 453 ->
		[{5,0,5659657}];
get_fire_exp_reward(_Lv) when _Lv >= 454, _Lv =< 454 ->
		[{5,0,5678812}];
get_fire_exp_reward(_Lv) when _Lv >= 455, _Lv =< 455 ->
		[{5,0,5698033}];
get_fire_exp_reward(_Lv) when _Lv >= 456, _Lv =< 456 ->
		[{5,0,5717318}];
get_fire_exp_reward(_Lv) when _Lv >= 457, _Lv =< 457 ->
		[{5,0,5736669}];
get_fire_exp_reward(_Lv) when _Lv >= 458, _Lv =< 458 ->
		[{5,0,5756085}];
get_fire_exp_reward(_Lv) when _Lv >= 459, _Lv =< 459 ->
		[{5,0,5775567}];
get_fire_exp_reward(_Lv) when _Lv >= 460, _Lv =< 460 ->
		[{5,0,5795115}];
get_fire_exp_reward(_Lv) when _Lv >= 461, _Lv =< 461 ->
		[{5,0,5814729}];
get_fire_exp_reward(_Lv) when _Lv >= 462, _Lv =< 462 ->
		[{5,0,5834410}];
get_fire_exp_reward(_Lv) when _Lv >= 463, _Lv =< 463 ->
		[{5,0,5854157}];
get_fire_exp_reward(_Lv) when _Lv >= 464, _Lv =< 464 ->
		[{5,0,5873971}];
get_fire_exp_reward(_Lv) when _Lv >= 465, _Lv =< 465 ->
		[{5,0,5893852}];
get_fire_exp_reward(_Lv) when _Lv >= 466, _Lv =< 466 ->
		[{5,0,5913800}];
get_fire_exp_reward(_Lv) when _Lv >= 467, _Lv =< 467 ->
		[{5,0,5933816}];
get_fire_exp_reward(_Lv) when _Lv >= 468, _Lv =< 468 ->
		[{5,0,5953900}];
get_fire_exp_reward(_Lv) when _Lv >= 469, _Lv =< 469 ->
		[{5,0,5974051}];
get_fire_exp_reward(_Lv) when _Lv >= 470, _Lv =< 470 ->
		[{5,0,5994271}];
get_fire_exp_reward(_Lv) when _Lv >= 471, _Lv =< 471 ->
		[{5,0,6014559}];
get_fire_exp_reward(_Lv) when _Lv >= 472, _Lv =< 472 ->
		[{5,0,6034916}];
get_fire_exp_reward(_Lv) when _Lv >= 473, _Lv =< 473 ->
		[{5,0,6055341}];
get_fire_exp_reward(_Lv) when _Lv >= 474, _Lv =< 474 ->
		[{5,0,6075836}];
get_fire_exp_reward(_Lv) when _Lv >= 475, _Lv =< 475 ->
		[{5,0,6096401}];
get_fire_exp_reward(_Lv) when _Lv >= 476, _Lv =< 476 ->
		[{5,0,6117034}];
get_fire_exp_reward(_Lv) when _Lv >= 477, _Lv =< 477 ->
		[{5,0,6137738}];
get_fire_exp_reward(_Lv) when _Lv >= 478, _Lv =< 478 ->
		[{5,0,6158512}];
get_fire_exp_reward(_Lv) when _Lv >= 479, _Lv =< 479 ->
		[{5,0,6179356}];
get_fire_exp_reward(_Lv) when _Lv >= 480, _Lv =< 480 ->
		[{5,0,6200270}];
get_fire_exp_reward(_Lv) when _Lv >= 481, _Lv =< 481 ->
		[{5,0,6221256}];
get_fire_exp_reward(_Lv) when _Lv >= 482, _Lv =< 482 ->
		[{5,0,6242312}];
get_fire_exp_reward(_Lv) when _Lv >= 483, _Lv =< 483 ->
		[{5,0,6263440}];
get_fire_exp_reward(_Lv) when _Lv >= 484, _Lv =< 484 ->
		[{5,0,6284639}];
get_fire_exp_reward(_Lv) when _Lv >= 485, _Lv =< 485 ->
		[{5,0,6305910}];
get_fire_exp_reward(_Lv) when _Lv >= 486, _Lv =< 486 ->
		[{5,0,6327253}];
get_fire_exp_reward(_Lv) when _Lv >= 487, _Lv =< 487 ->
		[{5,0,6348668}];
get_fire_exp_reward(_Lv) when _Lv >= 488, _Lv =< 488 ->
		[{5,0,6370156}];
get_fire_exp_reward(_Lv) when _Lv >= 489, _Lv =< 489 ->
		[{5,0,6391716}];
get_fire_exp_reward(_Lv) when _Lv >= 490, _Lv =< 490 ->
		[{5,0,6413349}];
get_fire_exp_reward(_Lv) when _Lv >= 491, _Lv =< 491 ->
		[{5,0,6435056}];
get_fire_exp_reward(_Lv) when _Lv >= 492, _Lv =< 492 ->
		[{5,0,6456836}];
get_fire_exp_reward(_Lv) when _Lv >= 493, _Lv =< 493 ->
		[{5,0,6478690}];
get_fire_exp_reward(_Lv) when _Lv >= 494, _Lv =< 494 ->
		[{5,0,6500617}];
get_fire_exp_reward(_Lv) when _Lv >= 495, _Lv =< 495 ->
		[{5,0,6522619}];
get_fire_exp_reward(_Lv) when _Lv >= 496, _Lv =< 496 ->
		[{5,0,6544696}];
get_fire_exp_reward(_Lv) when _Lv >= 497, _Lv =< 497 ->
		[{5,0,6566847}];
get_fire_exp_reward(_Lv) when _Lv >= 498, _Lv =< 498 ->
		[{5,0,6589073}];
get_fire_exp_reward(_Lv) when _Lv >= 499, _Lv =< 499 ->
		[{5,0,6611374}];
get_fire_exp_reward(_Lv) when _Lv >= 500, _Lv =< 500 ->
		[{5,0,6633751}];
get_fire_exp_reward(_Lv) when _Lv >= 501, _Lv =< 501 ->
		[{5,0,6656204}];
get_fire_exp_reward(_Lv) when _Lv >= 502, _Lv =< 502 ->
		[{5,0,6678732}];
get_fire_exp_reward(_Lv) when _Lv >= 503, _Lv =< 503 ->
		[{5,0,6701337}];
get_fire_exp_reward(_Lv) when _Lv >= 504, _Lv =< 504 ->
		[{5,0,6724018}];
get_fire_exp_reward(_Lv) when _Lv >= 505, _Lv =< 505 ->
		[{5,0,6746776}];
get_fire_exp_reward(_Lv) when _Lv >= 506, _Lv =< 506 ->
		[{5,0,6769611}];
get_fire_exp_reward(_Lv) when _Lv >= 507, _Lv =< 507 ->
		[{5,0,6792524}];
get_fire_exp_reward(_Lv) when _Lv >= 508, _Lv =< 508 ->
		[{5,0,6815514}];
get_fire_exp_reward(_Lv) when _Lv >= 509, _Lv =< 509 ->
		[{5,0,6838581}];
get_fire_exp_reward(_Lv) when _Lv >= 510, _Lv =< 510 ->
		[{5,0,6861727}];
get_fire_exp_reward(_Lv) when _Lv >= 511, _Lv =< 511 ->
		[{5,0,6884951}];
get_fire_exp_reward(_Lv) when _Lv >= 512, _Lv =< 512 ->
		[{5,0,6908254}];
get_fire_exp_reward(_Lv) when _Lv >= 513, _Lv =< 513 ->
		[{5,0,6931636}];
get_fire_exp_reward(_Lv) when _Lv >= 514, _Lv =< 514 ->
		[{5,0,6955096}];
get_fire_exp_reward(_Lv) when _Lv >= 515, _Lv =< 515 ->
		[{5,0,6978637}];
get_fire_exp_reward(_Lv) when _Lv >= 516, _Lv =< 516 ->
		[{5,0,7002256}];
get_fire_exp_reward(_Lv) when _Lv >= 517, _Lv =< 517 ->
		[{5,0,7025956}];
get_fire_exp_reward(_Lv) when _Lv >= 518, _Lv =< 518 ->
		[{5,0,7049736}];
get_fire_exp_reward(_Lv) when _Lv >= 519, _Lv =< 519 ->
		[{5,0,7073597}];
get_fire_exp_reward(_Lv) when _Lv >= 520, _Lv =< 520 ->
		[{5,0,7097538}];
get_fire_exp_reward(_Lv) when _Lv >= 521, _Lv =< 521 ->
		[{5,0,7121560}];
get_fire_exp_reward(_Lv) when _Lv >= 522, _Lv =< 522 ->
		[{5,0,7145664}];
get_fire_exp_reward(_Lv) when _Lv >= 523, _Lv =< 523 ->
		[{5,0,7169849}];
get_fire_exp_reward(_Lv) when _Lv >= 524, _Lv =< 524 ->
		[{5,0,7194116}];
get_fire_exp_reward(_Lv) when _Lv >= 525, _Lv =< 525 ->
		[{5,0,7218465}];
get_fire_exp_reward(_Lv) when _Lv >= 526, _Lv =< 526 ->
		[{5,0,7242897}];
get_fire_exp_reward(_Lv) when _Lv >= 527, _Lv =< 527 ->
		[{5,0,7267411}];
get_fire_exp_reward(_Lv) when _Lv >= 528, _Lv =< 528 ->
		[{5,0,7292008}];
get_fire_exp_reward(_Lv) when _Lv >= 529, _Lv =< 529 ->
		[{5,0,7316689}];
get_fire_exp_reward(_Lv) when _Lv >= 530, _Lv =< 530 ->
		[{5,0,7341453}];
get_fire_exp_reward(_Lv) when _Lv >= 531, _Lv =< 531 ->
		[{5,0,7366300}];
get_fire_exp_reward(_Lv) when _Lv >= 532, _Lv =< 532 ->
		[{5,0,7391232}];
get_fire_exp_reward(_Lv) when _Lv >= 533, _Lv =< 533 ->
		[{5,0,7416249}];
get_fire_exp_reward(_Lv) when _Lv >= 534, _Lv =< 534 ->
		[{5,0,7441350}];
get_fire_exp_reward(_Lv) when _Lv >= 535, _Lv =< 535 ->
		[{5,0,7466535}];
get_fire_exp_reward(_Lv) when _Lv >= 536, _Lv =< 536 ->
		[{5,0,7491807}];
get_fire_exp_reward(_Lv) when _Lv >= 537, _Lv =< 537 ->
		[{5,0,7517163}];
get_fire_exp_reward(_Lv) when _Lv >= 538, _Lv =< 538 ->
		[{5,0,7542606}];
get_fire_exp_reward(_Lv) when _Lv >= 539, _Lv =< 539 ->
		[{5,0,7568134}];
get_fire_exp_reward(_Lv) when _Lv >= 540, _Lv =< 540 ->
		[{5,0,7593750}];
get_fire_exp_reward(_Lv) when _Lv >= 541, _Lv =< 541 ->
		[{5,0,7619451}];
get_fire_exp_reward(_Lv) when _Lv >= 542, _Lv =< 542 ->
		[{5,0,7645240}];
get_fire_exp_reward(_Lv) when _Lv >= 543, _Lv =< 543 ->
		[{5,0,7671116}];
get_fire_exp_reward(_Lv) when _Lv >= 544, _Lv =< 544 ->
		[{5,0,7697080}];
get_fire_exp_reward(_Lv) when _Lv >= 545, _Lv =< 545 ->
		[{5,0,7723131}];
get_fire_exp_reward(_Lv) when _Lv >= 546, _Lv =< 546 ->
		[{5,0,7749271}];
get_fire_exp_reward(_Lv) when _Lv >= 547, _Lv =< 547 ->
		[{5,0,7775499}];
get_fire_exp_reward(_Lv) when _Lv >= 548, _Lv =< 548 ->
		[{5,0,7801816}];
get_fire_exp_reward(_Lv) when _Lv >= 549, _Lv =< 549 ->
		[{5,0,7828222}];
get_fire_exp_reward(_Lv) when _Lv >= 550, _Lv =< 550 ->
		[{5,0,7854717}];
get_fire_exp_reward(_Lv) when _Lv >= 551, _Lv =< 551 ->
		[{5,0,7881302}];
get_fire_exp_reward(_Lv) when _Lv >= 552, _Lv =< 552 ->
		[{5,0,7907977}];
get_fire_exp_reward(_Lv) when _Lv >= 553, _Lv =< 553 ->
		[{5,0,7934742}];
get_fire_exp_reward(_Lv) when _Lv >= 554, _Lv =< 554 ->
		[{5,0,7961598}];
get_fire_exp_reward(_Lv) when _Lv >= 555, _Lv =< 555 ->
		[{5,0,7988545}];
get_fire_exp_reward(_Lv) when _Lv >= 556, _Lv =< 556 ->
		[{5,0,8015583}];
get_fire_exp_reward(_Lv) when _Lv >= 557, _Lv =< 557 ->
		[{5,0,8042712}];
get_fire_exp_reward(_Lv) when _Lv >= 558, _Lv =< 558 ->
		[{5,0,8069934}];
get_fire_exp_reward(_Lv) when _Lv >= 559, _Lv =< 559 ->
		[{5,0,8097247}];
get_fire_exp_reward(_Lv) when _Lv >= 560, _Lv =< 560 ->
		[{5,0,8124653}];
get_fire_exp_reward(_Lv) when _Lv >= 561, _Lv =< 561 ->
		[{5,0,8152151}];
get_fire_exp_reward(_Lv) when _Lv >= 562, _Lv =< 562 ->
		[{5,0,8179743}];
get_fire_exp_reward(_Lv) when _Lv >= 563, _Lv =< 563 ->
		[{5,0,8207428}];
get_fire_exp_reward(_Lv) when _Lv >= 564, _Lv =< 564 ->
		[{5,0,8235207}];
get_fire_exp_reward(_Lv) when _Lv >= 565, _Lv =< 565 ->
		[{5,0,8263080}];
get_fire_exp_reward(_Lv) when _Lv >= 566, _Lv =< 566 ->
		[{5,0,8291047}];
get_fire_exp_reward(_Lv) when _Lv >= 567, _Lv =< 567 ->
		[{5,0,8319109}];
get_fire_exp_reward(_Lv) when _Lv >= 568, _Lv =< 568 ->
		[{5,0,8347266}];
get_fire_exp_reward(_Lv) when _Lv >= 569, _Lv =< 569 ->
		[{5,0,8375518}];
get_fire_exp_reward(_Lv) when _Lv >= 570, _Lv =< 570 ->
		[{5,0,8403865}];
get_fire_exp_reward(_Lv) when _Lv >= 571, _Lv =< 571 ->
		[{5,0,8432309}];
get_fire_exp_reward(_Lv) when _Lv >= 572, _Lv =< 572 ->
		[{5,0,8460849}];
get_fire_exp_reward(_Lv) when _Lv >= 573, _Lv =< 573 ->
		[{5,0,8489485}];
get_fire_exp_reward(_Lv) when _Lv >= 574, _Lv =< 574 ->
		[{5,0,8518219}];
get_fire_exp_reward(_Lv) when _Lv >= 575, _Lv =< 575 ->
		[{5,0,8547050}];
get_fire_exp_reward(_Lv) when _Lv >= 576, _Lv =< 576 ->
		[{5,0,8575978}];
get_fire_exp_reward(_Lv) when _Lv >= 577, _Lv =< 577 ->
		[{5,0,8605004}];
get_fire_exp_reward(_Lv) when _Lv >= 578, _Lv =< 578 ->
		[{5,0,8634128}];
get_fire_exp_reward(_Lv) when _Lv >= 579, _Lv =< 579 ->
		[{5,0,8663351}];
get_fire_exp_reward(_Lv) when _Lv >= 580, _Lv =< 580 ->
		[{5,0,8692673}];
get_fire_exp_reward(_Lv) when _Lv >= 581, _Lv =< 581 ->
		[{5,0,8722094}];
get_fire_exp_reward(_Lv) when _Lv >= 582, _Lv =< 582 ->
		[{5,0,8751615}];
get_fire_exp_reward(_Lv) when _Lv >= 583, _Lv =< 583 ->
		[{5,0,8781236}];
get_fire_exp_reward(_Lv) when _Lv >= 584, _Lv =< 584 ->
		[{5,0,8810957}];
get_fire_exp_reward(_Lv) when _Lv >= 585, _Lv =< 585 ->
		[{5,0,8840778}];
get_fire_exp_reward(_Lv) when _Lv >= 586, _Lv =< 586 ->
		[{5,0,8870701}];
get_fire_exp_reward(_Lv) when _Lv >= 587, _Lv =< 587 ->
		[{5,0,8900724}];
get_fire_exp_reward(_Lv) when _Lv >= 588, _Lv =< 588 ->
		[{5,0,8930850}];
get_fire_exp_reward(_Lv) when _Lv >= 589, _Lv =< 589 ->
		[{5,0,8961077}];
get_fire_exp_reward(_Lv) when _Lv >= 590, _Lv =< 590 ->
		[{5,0,8991406}];
get_fire_exp_reward(_Lv) when _Lv >= 591, _Lv =< 591 ->
		[{5,0,9021839}];
get_fire_exp_reward(_Lv) when _Lv >= 592, _Lv =< 592 ->
		[{5,0,9052374}];
get_fire_exp_reward(_Lv) when _Lv >= 593, _Lv =< 593 ->
		[{5,0,9083012}];
get_fire_exp_reward(_Lv) when _Lv >= 594, _Lv =< 594 ->
		[{5,0,9113755}];
get_fire_exp_reward(_Lv) when _Lv >= 595, _Lv =< 595 ->
		[{5,0,9144601}];
get_fire_exp_reward(_Lv) when _Lv >= 596, _Lv =< 596 ->
		[{5,0,9175552}];
get_fire_exp_reward(_Lv) when _Lv >= 597, _Lv =< 597 ->
		[{5,0,9206607}];
get_fire_exp_reward(_Lv) when _Lv >= 598, _Lv =< 598 ->
		[{5,0,9237768}];
get_fire_exp_reward(_Lv) when _Lv >= 599, _Lv =< 599 ->
		[{5,0,9269034}];
get_fire_exp_reward(_Lv) when _Lv >= 600, _Lv =< 600 ->
		[{5,0,9300406}];
get_fire_exp_reward(_Lv) when _Lv >= 601, _Lv =< 601 ->
		[{5,0,9331884}];
get_fire_exp_reward(_Lv) when _Lv >= 602, _Lv =< 602 ->
		[{5,0,9363469}];
get_fire_exp_reward(_Lv) when _Lv >= 603, _Lv =< 603 ->
		[{5,0,9395160}];
get_fire_exp_reward(_Lv) when _Lv >= 604, _Lv =< 604 ->
		[{5,0,9426959}];
get_fire_exp_reward(_Lv) when _Lv >= 605, _Lv =< 605 ->
		[{5,0,9458865}];
get_fire_exp_reward(_Lv) when _Lv >= 606, _Lv =< 606 ->
		[{5,0,9490880}];
get_fire_exp_reward(_Lv) when _Lv >= 607, _Lv =< 607 ->
		[{5,0,9523002}];
get_fire_exp_reward(_Lv) when _Lv >= 608, _Lv =< 608 ->
		[{5,0,9555234}];
get_fire_exp_reward(_Lv) when _Lv >= 609, _Lv =< 609 ->
		[{5,0,9587574}];
get_fire_exp_reward(_Lv) when _Lv >= 610, _Lv =< 610 ->
		[{5,0,9620024}];
get_fire_exp_reward(_Lv) when _Lv >= 611, _Lv =< 611 ->
		[{5,0,9652584}];
get_fire_exp_reward(_Lv) when _Lv >= 612, _Lv =< 612 ->
		[{5,0,9685254}];
get_fire_exp_reward(_Lv) when _Lv >= 613, _Lv =< 613 ->
		[{5,0,9718035}];
get_fire_exp_reward(_Lv) when _Lv >= 614, _Lv =< 614 ->
		[{5,0,9750926}];
get_fire_exp_reward(_Lv) when _Lv >= 615, _Lv =< 615 ->
		[{5,0,9783929}];
get_fire_exp_reward(_Lv) when _Lv >= 616, _Lv =< 616 ->
		[{5,0,9817044}];
get_fire_exp_reward(_Lv) when _Lv >= 617, _Lv =< 617 ->
		[{5,0,9850271}];
get_fire_exp_reward(_Lv) when _Lv >= 618, _Lv =< 618 ->
		[{5,0,9883610}];
get_fire_exp_reward(_Lv) when _Lv >= 619, _Lv =< 619 ->
		[{5,0,9917062}];
get_fire_exp_reward(_Lv) when _Lv >= 620, _Lv =< 620 ->
		[{5,0,9950627}];
get_fire_exp_reward(_Lv) when _Lv >= 621, _Lv =< 621 ->
		[{5,0,9984306}];
get_fire_exp_reward(_Lv) when _Lv >= 622, _Lv =< 622 ->
		[{5,0,10018099}];
get_fire_exp_reward(_Lv) when _Lv >= 623, _Lv =< 623 ->
		[{5,0,10052006}];
get_fire_exp_reward(_Lv) when _Lv >= 624, _Lv =< 624 ->
		[{5,0,10086028}];
get_fire_exp_reward(_Lv) when _Lv >= 625, _Lv =< 625 ->
		[{5,0,10120165}];
get_fire_exp_reward(_Lv) when _Lv >= 626, _Lv =< 626 ->
		[{5,0,10154417}];
get_fire_exp_reward(_Lv) when _Lv >= 627, _Lv =< 627 ->
		[{5,0,10188786}];
get_fire_exp_reward(_Lv) when _Lv >= 628, _Lv =< 628 ->
		[{5,0,10223271}];
get_fire_exp_reward(_Lv) when _Lv >= 629, _Lv =< 629 ->
		[{5,0,10257872}];
get_fire_exp_reward(_Lv) when _Lv >= 630, _Lv =< 630 ->
		[{5,0,10292591}];
get_fire_exp_reward(_Lv) when _Lv >= 631, _Lv =< 631 ->
		[{5,0,10327427}];
get_fire_exp_reward(_Lv) when _Lv >= 632, _Lv =< 632 ->
		[{5,0,10362381}];
get_fire_exp_reward(_Lv) when _Lv >= 633, _Lv =< 633 ->
		[{5,0,10397454}];
get_fire_exp_reward(_Lv) when _Lv >= 634, _Lv =< 634 ->
		[{5,0,10432645}];
get_fire_exp_reward(_Lv) when _Lv >= 635, _Lv =< 635 ->
		[{5,0,10467955}];
get_fire_exp_reward(_Lv) when _Lv >= 636, _Lv =< 636 ->
		[{5,0,10503385}];
get_fire_exp_reward(_Lv) when _Lv >= 637, _Lv =< 637 ->
		[{5,0,10538935}];
get_fire_exp_reward(_Lv) when _Lv >= 638, _Lv =< 638 ->
		[{5,0,10574605}];
get_fire_exp_reward(_Lv) when _Lv >= 639, _Lv =< 639 ->
		[{5,0,10610395}];
get_fire_exp_reward(_Lv) when _Lv >= 640, _Lv =< 640 ->
		[{5,0,10646307}];
get_fire_exp_reward(_Lv) when _Lv >= 641, _Lv =< 641 ->
		[{5,0,10682341}];
get_fire_exp_reward(_Lv) when _Lv >= 642, _Lv =< 642 ->
		[{5,0,10718496}];
get_fire_exp_reward(_Lv) when _Lv >= 643, _Lv =< 643 ->
		[{5,0,10754774}];
get_fire_exp_reward(_Lv) when _Lv >= 644, _Lv =< 644 ->
		[{5,0,10791174}];
get_fire_exp_reward(_Lv) when _Lv >= 645, _Lv =< 645 ->
		[{5,0,10827698}];
get_fire_exp_reward(_Lv) when _Lv >= 646, _Lv =< 646 ->
		[{5,0,10864345}];
get_fire_exp_reward(_Lv) when _Lv >= 647, _Lv =< 647 ->
		[{5,0,10901117}];
get_fire_exp_reward(_Lv) when _Lv >= 648, _Lv =< 648 ->
		[{5,0,10938012}];
get_fire_exp_reward(_Lv) when _Lv >= 649, _Lv =< 649 ->
		[{5,0,10975033}];
get_fire_exp_reward(_Lv) when _Lv >= 650, _Lv =< 650 ->
		[{5,0,11012179}];
get_fire_exp_reward(_Lv) when _Lv >= 651, _Lv =< 651 ->
		[{5,0,11049451}];
get_fire_exp_reward(_Lv) when _Lv >= 652, _Lv =< 652 ->
		[{5,0,11086849}];
get_fire_exp_reward(_Lv) when _Lv >= 653, _Lv =< 653 ->
		[{5,0,11124373}];
get_fire_exp_reward(_Lv) when _Lv >= 654, _Lv =< 654 ->
		[{5,0,11162025}];
get_fire_exp_reward(_Lv) when _Lv >= 655, _Lv =< 655 ->
		[{5,0,11199803}];
get_fire_exp_reward(_Lv) when _Lv >= 656, _Lv =< 656 ->
		[{5,0,11237710}];
get_fire_exp_reward(_Lv) when _Lv >= 657, _Lv =< 657 ->
		[{5,0,11275745}];
get_fire_exp_reward(_Lv) when _Lv >= 658, _Lv =< 658 ->
		[{5,0,11313909}];
get_fire_exp_reward(_Lv) when _Lv >= 659, _Lv =< 659 ->
		[{5,0,11352202}];
get_fire_exp_reward(_Lv) when _Lv >= 660, _Lv =< 660 ->
		[{5,0,11390625}];
get_fire_exp_reward(_Lv) when _Lv >= 661, _Lv =< 661 ->
		[{5,0,11429177}];
get_fire_exp_reward(_Lv) when _Lv >= 662, _Lv =< 662 ->
		[{5,0,11467860}];
get_fire_exp_reward(_Lv) when _Lv >= 663, _Lv =< 663 ->
		[{5,0,11506674}];
get_fire_exp_reward(_Lv) when _Lv >= 664, _Lv =< 664 ->
		[{5,0,11545620}];
get_fire_exp_reward(_Lv) when _Lv >= 665, _Lv =< 665 ->
		[{5,0,11584697}];
get_fire_exp_reward(_Lv) when _Lv >= 666, _Lv =< 666 ->
		[{5,0,11623906}];
get_fire_exp_reward(_Lv) when _Lv >= 667, _Lv =< 667 ->
		[{5,0,11663248}];
get_fire_exp_reward(_Lv) when _Lv >= 668, _Lv =< 668 ->
		[{5,0,11702724}];
get_fire_exp_reward(_Lv) when _Lv >= 669, _Lv =< 669 ->
		[{5,0,11742333}];
get_fire_exp_reward(_Lv) when _Lv >= 670, _Lv =< 670 ->
		[{5,0,11782076}];
get_fire_exp_reward(_Lv) when _Lv >= 671, _Lv =< 671 ->
		[{5,0,11821953}];
get_fire_exp_reward(_Lv) when _Lv >= 672, _Lv =< 672 ->
		[{5,0,11861966}];
get_fire_exp_reward(_Lv) when _Lv >= 673, _Lv =< 673 ->
		[{5,0,11902114}];
get_fire_exp_reward(_Lv) when _Lv >= 674, _Lv =< 674 ->
		[{5,0,11942397}];
get_fire_exp_reward(_Lv) when _Lv >= 675, _Lv =< 675 ->
		[{5,0,11982817}];
get_fire_exp_reward(_Lv) when _Lv >= 676, _Lv =< 676 ->
		[{5,0,12023374}];
get_fire_exp_reward(_Lv) when _Lv >= 677, _Lv =< 677 ->
		[{5,0,12064069}];
get_fire_exp_reward(_Lv) when _Lv >= 678, _Lv =< 678 ->
		[{5,0,12104901}];
get_fire_exp_reward(_Lv) when _Lv >= 679, _Lv =< 679 ->
		[{5,0,12145871}];
get_fire_exp_reward(_Lv) when _Lv >= 680, _Lv =< 680 ->
		[{5,0,12186979}];
get_fire_exp_reward(_Lv) when _Lv >= 681, _Lv =< 681 ->
		[{5,0,12228227}];
get_fire_exp_reward(_Lv) when _Lv >= 682, _Lv =< 682 ->
		[{5,0,12269615}];
get_fire_exp_reward(_Lv) when _Lv >= 683, _Lv =< 683 ->
		[{5,0,12311143}];
get_fire_exp_reward(_Lv) when _Lv >= 684, _Lv =< 684 ->
		[{5,0,12352811}];
get_fire_exp_reward(_Lv) when _Lv >= 685, _Lv =< 685 ->
		[{5,0,12394620}];
get_fire_exp_reward(_Lv) when _Lv >= 686, _Lv =< 686 ->
		[{5,0,12436571}];
get_fire_exp_reward(_Lv) when _Lv >= 687, _Lv =< 687 ->
		[{5,0,12478663}];
get_fire_exp_reward(_Lv) when _Lv >= 688, _Lv =< 688 ->
		[{5,0,12520899}];
get_fire_exp_reward(_Lv) when _Lv >= 689, _Lv =< 689 ->
		[{5,0,12563277}];
get_fire_exp_reward(_Lv) when _Lv >= 690, _Lv =< 690 ->
		[{5,0,12605798}];
get_fire_exp_reward(_Lv) when _Lv >= 691, _Lv =< 691 ->
		[{5,0,12648464}];
get_fire_exp_reward(_Lv) when _Lv >= 692, _Lv =< 692 ->
		[{5,0,12691274}];
get_fire_exp_reward(_Lv) when _Lv >= 693, _Lv =< 693 ->
		[{5,0,12734228}];
get_fire_exp_reward(_Lv) when _Lv >= 694, _Lv =< 694 ->
		[{5,0,12777329}];
get_fire_exp_reward(_Lv) when _Lv >= 695, _Lv =< 695 ->
		[{5,0,12820575}];
get_fire_exp_reward(_Lv) when _Lv >= 696, _Lv =< 696 ->
		[{5,0,12863967}];
get_fire_exp_reward(_Lv) when _Lv >= 697, _Lv =< 697 ->
		[{5,0,12907506}];
get_fire_exp_reward(_Lv) when _Lv >= 698, _Lv =< 698 ->
		[{5,0,12951193}];
get_fire_exp_reward(_Lv) when _Lv >= 699, _Lv =< 699 ->
		[{5,0,12995027}];
get_fire_exp_reward(_Lv) when _Lv >= 700, _Lv =< 700 ->
		[{5,0,13039010}];
get_fire_exp_reward(_Lv) when _Lv >= 701, _Lv =< 701 ->
		[{5,0,13083142}];
get_fire_exp_reward(_Lv) when _Lv >= 702, _Lv =< 702 ->
		[{5,0,13127423}];
get_fire_exp_reward(_Lv) when _Lv >= 703, _Lv =< 703 ->
		[{5,0,13171854}];
get_fire_exp_reward(_Lv) when _Lv >= 704, _Lv =< 704 ->
		[{5,0,13216435}];
get_fire_exp_reward(_Lv) when _Lv >= 705, _Lv =< 705 ->
		[{5,0,13261167}];
get_fire_exp_reward(_Lv) when _Lv >= 706, _Lv =< 706 ->
		[{5,0,13306051}];
get_fire_exp_reward(_Lv) when _Lv >= 707, _Lv =< 707 ->
		[{5,0,13351087}];
get_fire_exp_reward(_Lv) when _Lv >= 708, _Lv =< 708 ->
		[{5,0,13396275}];
get_fire_exp_reward(_Lv) when _Lv >= 709, _Lv =< 709 ->
		[{5,0,13441616}];
get_fire_exp_reward(_Lv) when _Lv >= 710, _Lv =< 710 ->
		[{5,0,13487110}];
get_fire_exp_reward(_Lv) when _Lv >= 711, _Lv =< 711 ->
		[{5,0,13532758}];
get_fire_exp_reward(_Lv) when _Lv >= 712, _Lv =< 712 ->
		[{5,0,13578561}];
get_fire_exp_reward(_Lv) when _Lv >= 713, _Lv =< 713 ->
		[{5,0,13624519}];
get_fire_exp_reward(_Lv) when _Lv >= 714, _Lv =< 714 ->
		[{5,0,13670632}];
get_fire_exp_reward(_Lv) when _Lv >= 715, _Lv =< 715 ->
		[{5,0,13716902}];
get_fire_exp_reward(_Lv) when _Lv >= 716, _Lv =< 716 ->
		[{5,0,13763328}];
get_fire_exp_reward(_Lv) when _Lv >= 717, _Lv =< 717 ->
		[{5,0,13809911}];
get_fire_exp_reward(_Lv) when _Lv >= 718, _Lv =< 718 ->
		[{5,0,13856652}];
get_fire_exp_reward(_Lv) when _Lv >= 719, _Lv =< 719 ->
		[{5,0,13903551}];
get_fire_exp_reward(_Lv) when _Lv >= 720, _Lv =< 720 ->
		[{5,0,13950609}];
get_fire_exp_reward(_Lv) when _Lv >= 721, _Lv =< 721 ->
		[{5,0,13997826}];
get_fire_exp_reward(_Lv) when _Lv >= 722, _Lv =< 722 ->
		[{5,0,14045203}];
get_fire_exp_reward(_Lv) when _Lv >= 723, _Lv =< 723 ->
		[{5,0,14092740}];
get_fire_exp_reward(_Lv) when _Lv >= 724, _Lv =< 724 ->
		[{5,0,14140438}];
get_fire_exp_reward(_Lv) when _Lv >= 725, _Lv =< 725 ->
		[{5,0,14188298}];
get_fire_exp_reward(_Lv) when _Lv >= 726, _Lv =< 726 ->
		[{5,0,14236320}];
get_fire_exp_reward(_Lv) when _Lv >= 727, _Lv =< 727 ->
		[{5,0,14284504}];
get_fire_exp_reward(_Lv) when _Lv >= 728, _Lv =< 728 ->
		[{5,0,14332851}];
get_fire_exp_reward(_Lv) when _Lv >= 729, _Lv =< 729 ->
		[{5,0,14381362}];
get_fire_exp_reward(_Lv) when _Lv >= 730, _Lv =< 730 ->
		[{5,0,14430037}];
get_fire_exp_reward(_Lv) when _Lv >= 731, _Lv =< 731 ->
		[{5,0,14478877}];
get_fire_exp_reward(_Lv) when _Lv >= 732, _Lv =< 732 ->
		[{5,0,14527882}];
get_fire_exp_reward(_Lv) when _Lv >= 733, _Lv =< 733 ->
		[{5,0,14577053}];
get_fire_exp_reward(_Lv) when _Lv >= 734, _Lv =< 734 ->
		[{5,0,14626390}];
get_fire_exp_reward(_Lv) when _Lv >= 735, _Lv =< 735 ->
		[{5,0,14675894}];
get_fire_exp_reward(_Lv) when _Lv >= 736, _Lv =< 736 ->
		[{5,0,14725566}];
get_fire_exp_reward(_Lv) when _Lv >= 737, _Lv =< 737 ->
		[{5,0,14775406}];
get_fire_exp_reward(_Lv) when _Lv >= 738, _Lv =< 738 ->
		[{5,0,14825415}];
get_fire_exp_reward(_Lv) when _Lv >= 739, _Lv =< 739 ->
		[{5,0,14875593}];
get_fire_exp_reward(_Lv) when _Lv >= 740, _Lv =< 740 ->
		[{5,0,14925941}];
get_fire_exp_reward(_Lv) when _Lv >= 741, _Lv =< 741 ->
		[{5,0,14976459}];
get_fire_exp_reward(_Lv) when _Lv >= 742, _Lv =< 742 ->
		[{5,0,15027148}];
get_fire_exp_reward(_Lv) when _Lv >= 743, _Lv =< 743 ->
		[{5,0,15078009}];
get_fire_exp_reward(_Lv) when _Lv >= 744, _Lv =< 744 ->
		[{5,0,15129042}];
get_fire_exp_reward(_Lv) when _Lv >= 745, _Lv =< 745 ->
		[{5,0,15180247}];
get_fire_exp_reward(_Lv) when _Lv >= 746, _Lv =< 746 ->
		[{5,0,15231626}];
get_fire_exp_reward(_Lv) when _Lv >= 747, _Lv =< 747 ->
		[{5,0,15283179}];
get_fire_exp_reward(_Lv) when _Lv >= 748, _Lv =< 748 ->
		[{5,0,15334906}];
get_fire_exp_reward(_Lv) when _Lv >= 749, _Lv =< 749 ->
		[{5,0,15386809}];
get_fire_exp_reward(_Lv) when _Lv >= 750, _Lv =< 750 ->
		[{5,0,15438887}];
get_fire_exp_reward(_Lv) when _Lv >= 751, _Lv =< 751 ->
		[{5,0,15491141}];
get_fire_exp_reward(_Lv) when _Lv >= 752, _Lv =< 752 ->
		[{5,0,15543572}];
get_fire_exp_reward(_Lv) when _Lv >= 753, _Lv =< 753 ->
		[{5,0,15596181}];
get_fire_exp_reward(_Lv) when _Lv >= 754, _Lv =< 754 ->
		[{5,0,15648968}];
get_fire_exp_reward(_Lv) when _Lv >= 755, _Lv =< 755 ->
		[{5,0,15701933}];
get_fire_exp_reward(_Lv) when _Lv >= 756, _Lv =< 756 ->
		[{5,0,15755078}];
get_fire_exp_reward(_Lv) when _Lv >= 757, _Lv =< 757 ->
		[{5,0,15808402}];
get_fire_exp_reward(_Lv) when _Lv >= 758, _Lv =< 758 ->
		[{5,0,15861907}];
get_fire_exp_reward(_Lv) when _Lv >= 759, _Lv =< 759 ->
		[{5,0,15915593}];
get_fire_exp_reward(_Lv) when _Lv >= 760, _Lv =< 760 ->
		[{5,0,15969461}];
get_fire_exp_reward(_Lv) when _Lv >= 761, _Lv =< 761 ->
		[{5,0,16023511}];
get_fire_exp_reward(_Lv) when _Lv >= 762, _Lv =< 762 ->
		[{5,0,16077744}];
get_fire_exp_reward(_Lv) when _Lv >= 763, _Lv =< 763 ->
		[{5,0,16132161}];
get_fire_exp_reward(_Lv) when _Lv >= 764, _Lv =< 764 ->
		[{5,0,16186761}];
get_fire_exp_reward(_Lv) when _Lv >= 765, _Lv =< 765 ->
		[{5,0,16241547}];
get_fire_exp_reward(_Lv) when _Lv >= 766, _Lv =< 766 ->
		[{5,0,16296518}];
get_fire_exp_reward(_Lv) when _Lv >= 767, _Lv =< 767 ->
		[{5,0,16351675}];
get_fire_exp_reward(_Lv) when _Lv >= 768, _Lv =< 768 ->
		[{5,0,16407019}];
get_fire_exp_reward(_Lv) when _Lv >= 769, _Lv =< 769 ->
		[{5,0,16462550}];
get_fire_exp_reward(_Lv) when _Lv >= 770, _Lv =< 770 ->
		[{5,0,16518269}];
get_fire_exp_reward(_Lv) when _Lv >= 771, _Lv =< 771 ->
		[{5,0,16574176}];
get_fire_exp_reward(_Lv) when _Lv >= 772, _Lv =< 772 ->
		[{5,0,16630273}];
get_fire_exp_reward(_Lv) when _Lv >= 773, _Lv =< 773 ->
		[{5,0,16686560}];
get_fire_exp_reward(_Lv) when _Lv >= 774, _Lv =< 774 ->
		[{5,0,16743037}];
get_fire_exp_reward(_Lv) when _Lv >= 775, _Lv =< 775 ->
		[{5,0,16799705}];
get_fire_exp_reward(_Lv) when _Lv >= 776, _Lv =< 776 ->
		[{5,0,16856565}];
get_fire_exp_reward(_Lv) when _Lv >= 777, _Lv =< 777 ->
		[{5,0,16913618}];
get_fire_exp_reward(_Lv) when _Lv >= 778, _Lv =< 778 ->
		[{5,0,16970864}];
get_fire_exp_reward(_Lv) when _Lv >= 779, _Lv =< 779 ->
		[{5,0,17028303}];
get_fire_exp_reward(_Lv) when _Lv >= 780, _Lv =< 780 ->
		[{5,0,17085937}];
get_fire_exp_reward(_Lv) when _Lv >= 781, _Lv =< 781 ->
		[{5,0,17143766}];
get_fire_exp_reward(_Lv) when _Lv >= 782, _Lv =< 782 ->
		[{5,0,17201791}];
get_fire_exp_reward(_Lv) when _Lv >= 783, _Lv =< 783 ->
		[{5,0,17260012}];
get_fire_exp_reward(_Lv) when _Lv >= 784, _Lv =< 784 ->
		[{5,0,17318430}];
get_fire_exp_reward(_Lv) when _Lv >= 785, _Lv =< 785 ->
		[{5,0,17377045}];
get_fire_exp_reward(_Lv) when _Lv >= 786, _Lv =< 786 ->
		[{5,0,17435860}];
get_fire_exp_reward(_Lv) when _Lv >= 787, _Lv =< 787 ->
		[{5,0,17494873}];
get_fire_exp_reward(_Lv) when _Lv >= 788, _Lv =< 788 ->
		[{5,0,17554086}];
get_fire_exp_reward(_Lv) when _Lv >= 789, _Lv =< 789 ->
		[{5,0,17613499}];
get_fire_exp_reward(_Lv) when _Lv >= 790, _Lv =< 790 ->
		[{5,0,17673114}];
get_fire_exp_reward(_Lv) when _Lv >= 791, _Lv =< 791 ->
		[{5,0,17732930}];
get_fire_exp_reward(_Lv) when _Lv >= 792, _Lv =< 792 ->
		[{5,0,17792949}];
get_fire_exp_reward(_Lv) when _Lv >= 793, _Lv =< 793 ->
		[{5,0,17853171}];
get_fire_exp_reward(_Lv) when _Lv >= 794, _Lv =< 794 ->
		[{5,0,17913596}];
get_fire_exp_reward(_Lv) when _Lv >= 795, _Lv =< 795 ->
		[{5,0,17974226}];
get_fire_exp_reward(_Lv) when _Lv >= 796, _Lv =< 796 ->
		[{5,0,18035062}];
get_fire_exp_reward(_Lv) when _Lv >= 797, _Lv =< 797 ->
		[{5,0,18096103}];
get_fire_exp_reward(_Lv) when _Lv >= 798, _Lv =< 798 ->
		[{5,0,18157351}];
get_fire_exp_reward(_Lv) when _Lv >= 799, _Lv =< 799 ->
		[{5,0,18218806}];
get_fire_exp_reward(_Lv) when _Lv >= 800, _Lv =< 800 ->
		[{5,0,18280469}];
get_fire_exp_reward(_Lv) when _Lv >= 801, _Lv =< 801 ->
		[{5,0,18342341}];
get_fire_exp_reward(_Lv) when _Lv >= 802, _Lv =< 802 ->
		[{5,0,18404423}];
get_fire_exp_reward(_Lv) when _Lv >= 803, _Lv =< 803 ->
		[{5,0,18466714}];
get_fire_exp_reward(_Lv) when _Lv >= 804, _Lv =< 804 ->
		[{5,0,18529216}];
get_fire_exp_reward(_Lv) when _Lv >= 805, _Lv =< 805 ->
		[{5,0,18591930}];
get_fire_exp_reward(_Lv) when _Lv >= 806, _Lv =< 806 ->
		[{5,0,18654856}];
get_fire_exp_reward(_Lv) when _Lv >= 807, _Lv =< 807 ->
		[{5,0,18717995}];
get_fire_exp_reward(_Lv) when _Lv >= 808, _Lv =< 808 ->
		[{5,0,18781348}];
get_fire_exp_reward(_Lv) when _Lv >= 809, _Lv =< 809 ->
		[{5,0,18844915}];
get_fire_exp_reward(_Lv) when _Lv >= 810, _Lv =< 810 ->
		[{5,0,18908698}];
get_fire_exp_reward(_Lv) when _Lv >= 811, _Lv =< 811 ->
		[{5,0,18972696}];
get_fire_exp_reward(_Lv) when _Lv >= 812, _Lv =< 812 ->
		[{5,0,19036911}];
get_fire_exp_reward(_Lv) when _Lv >= 813, _Lv =< 813 ->
		[{5,0,19101343}];
get_fire_exp_reward(_Lv) when _Lv >= 814, _Lv =< 814 ->
		[{5,0,19165993}];
get_fire_exp_reward(_Lv) when _Lv >= 815, _Lv =< 815 ->
		[{5,0,19230862}];
get_fire_exp_reward(_Lv) when _Lv >= 816, _Lv =< 816 ->
		[{5,0,19295951}];
get_fire_exp_reward(_Lv) when _Lv >= 817, _Lv =< 817 ->
		[{5,0,19361260}];
get_fire_exp_reward(_Lv) when _Lv >= 818, _Lv =< 818 ->
		[{5,0,19426789}];
get_fire_exp_reward(_Lv) when _Lv >= 819, _Lv =< 819 ->
		[{5,0,19492541}];
get_fire_exp_reward(_Lv) when _Lv >= 820, _Lv =< 820 ->
		[{5,0,19558516}];
get_fire_exp_reward(_Lv) when _Lv >= 821, _Lv =< 821 ->
		[{5,0,19624713}];
get_fire_exp_reward(_Lv) when _Lv >= 822, _Lv =< 822 ->
		[{5,0,19691135}];
get_fire_exp_reward(_Lv) when _Lv >= 823, _Lv =< 823 ->
		[{5,0,19757781}];
get_fire_exp_reward(_Lv) when _Lv >= 824, _Lv =< 824 ->
		[{5,0,19824653}];
get_fire_exp_reward(_Lv) when _Lv >= 825, _Lv =< 825 ->
		[{5,0,19891751}];
get_fire_exp_reward(_Lv) when _Lv >= 826, _Lv =< 826 ->
		[{5,0,19959077}];
get_fire_exp_reward(_Lv) when _Lv >= 827, _Lv =< 827 ->
		[{5,0,20026630}];
get_fire_exp_reward(_Lv) when _Lv >= 828, _Lv =< 828 ->
		[{5,0,20094412}];
get_fire_exp_reward(_Lv) when _Lv >= 829, _Lv =< 829 ->
		[{5,0,20162424}];
get_fire_exp_reward(_Lv) when _Lv >= 830, _Lv =< 830 ->
		[{5,0,20230665}];
get_fire_exp_reward(_Lv) when _Lv >= 831, _Lv =< 831 ->
		[{5,0,20299138}];
get_fire_exp_reward(_Lv) when _Lv >= 832, _Lv =< 832 ->
		[{5,0,20367842}];
get_fire_exp_reward(_Lv) when _Lv >= 833, _Lv =< 833 ->
		[{5,0,20436779}];
get_fire_exp_reward(_Lv) when _Lv >= 834, _Lv =< 834 ->
		[{5,0,20505949}];
get_fire_exp_reward(_Lv) when _Lv >= 835, _Lv =< 835 ->
		[{5,0,20575353}];
get_fire_exp_reward(_Lv) when _Lv >= 836, _Lv =< 836 ->
		[{5,0,20644992}];
get_fire_exp_reward(_Lv) when _Lv >= 837, _Lv =< 837 ->
		[{5,0,20714867}];
get_fire_exp_reward(_Lv) when _Lv >= 838, _Lv =< 838 ->
		[{5,0,20784978}];
get_fire_exp_reward(_Lv) when _Lv >= 839, _Lv =< 839 ->
		[{5,0,20855327}];
get_fire_exp_reward(_Lv) when _Lv >= 840, _Lv =< 840 ->
		[{5,0,20925914}];
get_fire_exp_reward(_Lv) when _Lv >= 841, _Lv =< 841 ->
		[{5,0,20996739}];
get_fire_exp_reward(_Lv) when _Lv >= 842, _Lv =< 842 ->
		[{5,0,21067805}];
get_fire_exp_reward(_Lv) when _Lv >= 843, _Lv =< 843 ->
		[{5,0,21139111}];
get_fire_exp_reward(_Lv) when _Lv >= 844, _Lv =< 844 ->
		[{5,0,21210658}];
get_fire_exp_reward(_Lv) when _Lv >= 845, _Lv =< 845 ->
		[{5,0,21282447}];
get_fire_exp_reward(_Lv) when _Lv >= 846, _Lv =< 846 ->
		[{5,0,21354480}];
get_fire_exp_reward(_Lv) when _Lv >= 847, _Lv =< 847 ->
		[{5,0,21426756}];
get_fire_exp_reward(_Lv) when _Lv >= 848, _Lv =< 848 ->
		[{5,0,21499277}];
get_fire_exp_reward(_Lv) when _Lv >= 849, _Lv =< 849 ->
		[{5,0,21572043}];
get_fire_exp_reward(_Lv) when _Lv >= 850, _Lv =< 850 ->
		[{5,0,21645056}];
get_fire_exp_reward(_Lv) when _Lv >= 851, _Lv =< 851 ->
		[{5,0,21718315}];
get_fire_exp_reward(_Lv) when _Lv >= 852, _Lv =< 852 ->
		[{5,0,21791823}];
get_fire_exp_reward(_Lv) when _Lv >= 853, _Lv =< 853 ->
		[{5,0,21865579}];
get_fire_exp_reward(_Lv) when _Lv >= 854, _Lv =< 854 ->
		[{5,0,21939585}];
get_fire_exp_reward(_Lv) when _Lv >= 855, _Lv =< 855 ->
		[{5,0,22013842}];
get_fire_exp_reward(_Lv) when _Lv >= 856, _Lv =< 856 ->
		[{5,0,22088350}];
get_fire_exp_reward(_Lv) when _Lv >= 857, _Lv =< 857 ->
		[{5,0,22163110}];
get_fire_exp_reward(_Lv) when _Lv >= 858, _Lv =< 858 ->
		[{5,0,22238123}];
get_fire_exp_reward(_Lv) when _Lv >= 859, _Lv =< 859 ->
		[{5,0,22313390}];
get_fire_exp_reward(_Lv) when _Lv >= 860, _Lv =< 860 ->
		[{5,0,22388911}];
get_fire_exp_reward(_Lv) when _Lv >= 861, _Lv =< 861 ->
		[{5,0,22464689}];
get_fire_exp_reward(_Lv) when _Lv >= 862, _Lv =< 862 ->
		[{5,0,22540722}];
get_fire_exp_reward(_Lv) when _Lv >= 863, _Lv =< 863 ->
		[{5,0,22617014}];
get_fire_exp_reward(_Lv) when _Lv >= 864, _Lv =< 864 ->
		[{5,0,22693563}];
get_fire_exp_reward(_Lv) when _Lv >= 865, _Lv =< 865 ->
		[{5,0,22770371}];
get_fire_exp_reward(_Lv) when _Lv >= 866, _Lv =< 866 ->
		[{5,0,22847440}];
get_fire_exp_reward(_Lv) when _Lv >= 867, _Lv =< 867 ->
		[{5,0,22924769}];
get_fire_exp_reward(_Lv) when _Lv >= 868, _Lv =< 868 ->
		[{5,0,23002360}];
get_fire_exp_reward(_Lv) when _Lv >= 869, _Lv =< 869 ->
		[{5,0,23080213}];
get_fire_exp_reward(_Lv) when _Lv >= 870, _Lv =< 870 ->
		[{5,0,23158331}];
get_fire_exp_reward(_Lv) when _Lv >= 871, _Lv =< 871 ->
		[{5,0,23236712}];
get_fire_exp_reward(_Lv) when _Lv >= 872, _Lv =< 872 ->
		[{5,0,23315359}];
get_fire_exp_reward(_Lv) when _Lv >= 873, _Lv =< 873 ->
		[{5,0,23394272}];
get_fire_exp_reward(_Lv) when _Lv >= 874, _Lv =< 874 ->
		[{5,0,23473452}];
get_fire_exp_reward(_Lv) when _Lv >= 875, _Lv =< 875 ->
		[{5,0,23552900}];
get_fire_exp_reward(_Lv) when _Lv >= 876, _Lv =< 876 ->
		[{5,0,23632617}];
get_fire_exp_reward(_Lv) when _Lv >= 877, _Lv =< 877 ->
		[{5,0,23712603}];
get_fire_exp_reward(_Lv) when _Lv >= 878, _Lv =< 878 ->
		[{5,0,23792861}];
get_fire_exp_reward(_Lv) when _Lv >= 879, _Lv =< 879 ->
		[{5,0,23873390}];
get_fire_exp_reward(_Lv) when _Lv >= 880, _Lv =< 880 ->
		[{5,0,23954192}];
get_fire_exp_reward(_Lv) when _Lv >= 881, _Lv =< 881 ->
		[{5,0,24035267}];
get_fire_exp_reward(_Lv) when _Lv >= 882, _Lv =< 882 ->
		[{5,0,24116616}];
get_fire_exp_reward(_Lv) when _Lv >= 883, _Lv =< 883 ->
		[{5,0,24198241}];
get_fire_exp_reward(_Lv) when _Lv >= 884, _Lv =< 884 ->
		[{5,0,24280142}];
get_fire_exp_reward(_Lv) when _Lv >= 885, _Lv =< 885 ->
		[{5,0,24362321}];
get_fire_exp_reward(_Lv) when _Lv >= 886, _Lv =< 886 ->
		[{5,0,24444777}];
get_fire_exp_reward(_Lv) when _Lv >= 887, _Lv =< 887 ->
		[{5,0,24527513}];
get_fire_exp_reward(_Lv) when _Lv >= 888, _Lv =< 888 ->
		[{5,0,24610528}];
get_fire_exp_reward(_Lv) when _Lv >= 889, _Lv =< 889 ->
		[{5,0,24693825}];
get_fire_exp_reward(_Lv) when _Lv >= 890, _Lv =< 890 ->
		[{5,0,24777403}];
get_fire_exp_reward(_Lv) when _Lv >= 891, _Lv =< 891 ->
		[{5,0,24861265}];
get_fire_exp_reward(_Lv) when _Lv >= 892, _Lv =< 892 ->
		[{5,0,24945410}];
get_fire_exp_reward(_Lv) when _Lv >= 893, _Lv =< 893 ->
		[{5,0,25029840}];
get_fire_exp_reward(_Lv) when _Lv >= 894, _Lv =< 894 ->
		[{5,0,25114556}];
get_fire_exp_reward(_Lv) when _Lv >= 895, _Lv =< 895 ->
		[{5,0,25199558}];
get_fire_exp_reward(_Lv) when _Lv >= 896, _Lv =< 896 ->
		[{5,0,25284848}];
get_fire_exp_reward(_Lv) when _Lv >= 897, _Lv =< 897 ->
		[{5,0,25370427}];
get_fire_exp_reward(_Lv) when _Lv >= 898, _Lv =< 898 ->
		[{5,0,25456296}];
get_fire_exp_reward(_Lv) when _Lv >= 899, _Lv =< 899 ->
		[{5,0,25542455}];
get_fire_exp_reward(_Lv) when _Lv >= 900, _Lv =< 900 ->
		[{5,0,25628906}];
get_fire_exp_reward(_Lv) when _Lv >= 901, _Lv =< 901 ->
		[{5,0,25715649}];
get_fire_exp_reward(_Lv) when _Lv >= 902, _Lv =< 902 ->
		[{5,0,25802686}];
get_fire_exp_reward(_Lv) when _Lv >= 903, _Lv =< 903 ->
		[{5,0,25890018}];
get_fire_exp_reward(_Lv) when _Lv >= 904, _Lv =< 904 ->
		[{5,0,25977645}];
get_fire_exp_reward(_Lv) when _Lv >= 905, _Lv =< 905 ->
		[{5,0,26065568}];
get_fire_exp_reward(_Lv) when _Lv >= 906, _Lv =< 906 ->
		[{5,0,26153790}];
get_fire_exp_reward(_Lv) when _Lv >= 907, _Lv =< 907 ->
		[{5,0,26242310}];
get_fire_exp_reward(_Lv) when _Lv >= 908, _Lv =< 908 ->
		[{5,0,26331129}];
get_fire_exp_reward(_Lv) when _Lv >= 909, _Lv =< 909 ->
		[{5,0,26420249}];
get_fire_exp_reward(_Lv) when _Lv >= 910, _Lv =< 910 ->
		[{5,0,26509671}];
get_fire_exp_reward(_Lv) when _Lv >= 911, _Lv =< 911 ->
		[{5,0,26599395}];
get_fire_exp_reward(_Lv) when _Lv >= 912, _Lv =< 912 ->
		[{5,0,26689423}];
get_fire_exp_reward(_Lv) when _Lv >= 913, _Lv =< 913 ->
		[{5,0,26779756}];
get_fire_exp_reward(_Lv) when _Lv >= 914, _Lv =< 914 ->
		[{5,0,26870395}];
get_fire_exp_reward(_Lv) when _Lv >= 915, _Lv =< 915 ->
		[{5,0,26961340}];
get_fire_exp_reward(_Lv) when _Lv >= 916, _Lv =< 916 ->
		[{5,0,27052593}];
get_fire_exp_reward(_Lv) when _Lv >= 917, _Lv =< 917 ->
		[{5,0,27144155}];
get_fire_exp_reward(_Lv) when _Lv >= 918, _Lv =< 918 ->
		[{5,0,27236027}];
get_fire_exp_reward(_Lv) when _Lv >= 919, _Lv =< 919 ->
		[{5,0,27328210}];
get_fire_exp_reward(_Lv) when _Lv >= 920, _Lv =< 920 ->
		[{5,0,27420704}];
get_fire_exp_reward(_Lv) when _Lv >= 921, _Lv =< 921 ->
		[{5,0,27513512}];
get_fire_exp_reward(_Lv) when _Lv >= 922, _Lv =< 922 ->
		[{5,0,27606634}];
get_fire_exp_reward(_Lv) when _Lv >= 923, _Lv =< 923 ->
		[{5,0,27700071}];
get_fire_exp_reward(_Lv) when _Lv >= 924, _Lv =< 924 ->
		[{5,0,27793825}];
get_fire_exp_reward(_Lv) when _Lv >= 925, _Lv =< 925 ->
		[{5,0,27887896}];
get_fire_exp_reward(_Lv) when _Lv >= 926, _Lv =< 926 ->
		[{5,0,27982285}];
get_fire_exp_reward(_Lv) when _Lv >= 927, _Lv =< 927 ->
		[{5,0,28076993}];
get_fire_exp_reward(_Lv) when _Lv >= 928, _Lv =< 928 ->
		[{5,0,28172022}];
get_fire_exp_reward(_Lv) when _Lv >= 929, _Lv =< 929 ->
		[{5,0,28267373}];
get_fire_exp_reward(_Lv) when _Lv >= 930, _Lv =< 930 ->
		[{5,0,28363047}];
get_fire_exp_reward(_Lv) when _Lv >= 931, _Lv =< 931 ->
		[{5,0,28459044}];
get_fire_exp_reward(_Lv) when _Lv >= 932, _Lv =< 932 ->
		[{5,0,28555366}];
get_fire_exp_reward(_Lv) when _Lv >= 933, _Lv =< 933 ->
		[{5,0,28652014}];
get_fire_exp_reward(_Lv) when _Lv >= 934, _Lv =< 934 ->
		[{5,0,28748990}];
get_fire_exp_reward(_Lv) when _Lv >= 935, _Lv =< 935 ->
		[{5,0,28846293}];
get_fire_exp_reward(_Lv) when _Lv >= 936, _Lv =< 936 ->
		[{5,0,28943926}];
get_fire_exp_reward(_Lv) when _Lv >= 937, _Lv =< 937 ->
		[{5,0,29041890}];
get_fire_exp_reward(_Lv) when _Lv >= 938, _Lv =< 938 ->
		[{5,0,29140184}];
get_fire_exp_reward(_Lv) when _Lv >= 939, _Lv =< 939 ->
		[{5,0,29238812}];
get_fire_exp_reward(_Lv) when _Lv >= 940, _Lv =< 940 ->
		[{5,0,29337774}];
get_fire_exp_reward(_Lv) when _Lv >= 941, _Lv =< 941 ->
		[{5,0,29437070}];
get_fire_exp_reward(_Lv) when _Lv >= 942, _Lv =< 942 ->
		[{5,0,29536702}];
get_fire_exp_reward(_Lv) when _Lv >= 943, _Lv =< 943 ->
		[{5,0,29636672}];
get_fire_exp_reward(_Lv) when _Lv >= 944, _Lv =< 944 ->
		[{5,0,29736980}];
get_fire_exp_reward(_Lv) when _Lv >= 945, _Lv =< 945 ->
		[{5,0,29837627}];
get_fire_exp_reward(_Lv) when _Lv >= 946, _Lv =< 946 ->
		[{5,0,29938616}];
get_fire_exp_reward(_Lv) when _Lv >= 947, _Lv =< 947 ->
		[{5,0,30039946}];
get_fire_exp_reward(_Lv) when _Lv >= 948, _Lv =< 948 ->
		[{5,0,30141619}];
get_fire_exp_reward(_Lv) when _Lv >= 949, _Lv =< 949 ->
		[{5,0,30243636}];
get_fire_exp_reward(_Lv) when _Lv >= 950, _Lv =< 950 ->
		[{5,0,30345998}];
get_fire_exp_reward(_Lv) when _Lv >= 951, _Lv =< 951 ->
		[{5,0,30448707}];
get_fire_exp_reward(_Lv) when _Lv >= 952, _Lv =< 952 ->
		[{5,0,30551763}];
get_fire_exp_reward(_Lv) when _Lv >= 953, _Lv =< 953 ->
		[{5,0,30655168}];
get_fire_exp_reward(_Lv) when _Lv >= 954, _Lv =< 954 ->
		[{5,0,30758923}];
get_fire_exp_reward(_Lv) when _Lv >= 955, _Lv =< 955 ->
		[{5,0,30863030}];
get_fire_exp_reward(_Lv) when _Lv >= 956, _Lv =< 956 ->
		[{5,0,30967489}];
get_fire_exp_reward(_Lv) when _Lv >= 957, _Lv =< 957 ->
		[{5,0,31072301}];
get_fire_exp_reward(_Lv) when _Lv >= 958, _Lv =< 958 ->
		[{5,0,31177468}];
get_fire_exp_reward(_Lv) when _Lv >= 959, _Lv =< 959 ->
		[{5,0,31282991}];
get_fire_exp_reward(_Lv) when _Lv >= 960, _Lv =< 960 ->
		[{5,0,31388871}];
get_fire_exp_reward(_Lv) when _Lv >= 961, _Lv =< 961 ->
		[{5,0,31495109}];
get_fire_exp_reward(_Lv) when _Lv >= 962, _Lv =< 962 ->
		[{5,0,31601708}];
get_fire_exp_reward(_Lv) when _Lv >= 963, _Lv =< 963 ->
		[{5,0,31708666}];
get_fire_exp_reward(_Lv) when _Lv >= 964, _Lv =< 964 ->
		[{5,0,31815987}];
get_fire_exp_reward(_Lv) when _Lv >= 965, _Lv =< 965 ->
		[{5,0,31923671}];
get_fire_exp_reward(_Lv) when _Lv >= 966, _Lv =< 966 ->
		[{5,0,32031720}];
get_fire_exp_reward(_Lv) when _Lv >= 967, _Lv =< 967 ->
		[{5,0,32140134}];
get_fire_exp_reward(_Lv) when _Lv >= 968, _Lv =< 968 ->
		[{5,0,32248915}];
get_fire_exp_reward(_Lv) when _Lv >= 969, _Lv =< 969 ->
		[{5,0,32358065}];
get_fire_exp_reward(_Lv) when _Lv >= 970, _Lv =< 970 ->
		[{5,0,32467584}];
get_fire_exp_reward(_Lv) when _Lv >= 971, _Lv =< 971 ->
		[{5,0,32577473}];
get_fire_exp_reward(_Lv) when _Lv >= 972, _Lv =< 972 ->
		[{5,0,32687734}];
get_fire_exp_reward(_Lv) when _Lv >= 973, _Lv =< 973 ->
		[{5,0,32798369}];
get_fire_exp_reward(_Lv) when _Lv >= 974, _Lv =< 974 ->
		[{5,0,32909378}];
get_fire_exp_reward(_Lv) when _Lv >= 975, _Lv =< 975 ->
		[{5,0,33020763}];
get_fire_exp_reward(_Lv) when _Lv >= 976, _Lv =< 976 ->
		[{5,0,33132525}];
get_fire_exp_reward(_Lv) when _Lv >= 977, _Lv =< 977 ->
		[{5,0,33244665}];
get_fire_exp_reward(_Lv) when _Lv >= 978, _Lv =< 978 ->
		[{5,0,33357184}];
get_fire_exp_reward(_Lv) when _Lv >= 979, _Lv =< 979 ->
		[{5,0,33470085}];
get_fire_exp_reward(_Lv) when _Lv >= 980, _Lv =< 980 ->
		[{5,0,33583367}];
get_fire_exp_reward(_Lv) when _Lv >= 981, _Lv =< 981 ->
		[{5,0,33697033}];
get_fire_exp_reward(_Lv) when _Lv >= 982, _Lv =< 982 ->
		[{5,0,33811084}];
get_fire_exp_reward(_Lv) when _Lv >= 983, _Lv =< 983 ->
		[{5,0,33925521}];
get_fire_exp_reward(_Lv) when _Lv >= 984, _Lv =< 984 ->
		[{5,0,34040345}];
get_fire_exp_reward(_Lv) when _Lv >= 985, _Lv =< 985 ->
		[{5,0,34155557}];
get_fire_exp_reward(_Lv) when _Lv >= 986, _Lv =< 986 ->
		[{5,0,34271160}];
get_fire_exp_reward(_Lv) when _Lv >= 987, _Lv =< 987 ->
		[{5,0,34387154}];
get_fire_exp_reward(_Lv) when _Lv >= 988, _Lv =< 988 ->
		[{5,0,34503540}];
get_fire_exp_reward(_Lv) when _Lv >= 989, _Lv =< 989 ->
		[{5,0,34620320}];
get_fire_exp_reward(_Lv) when _Lv >= 990, _Lv =< 990 ->
		[{5,0,34737496}];
get_fire_exp_reward(_Lv) when _Lv >= 991, _Lv =< 991 ->
		[{5,0,34855068}];
get_fire_exp_reward(_Lv) when _Lv >= 992, _Lv =< 992 ->
		[{5,0,34973038}];
get_fire_exp_reward(_Lv) when _Lv >= 993, _Lv =< 993 ->
		[{5,0,35091408}];
get_fire_exp_reward(_Lv) when _Lv >= 994, _Lv =< 994 ->
		[{5,0,35210178}];
get_fire_exp_reward(_Lv) when _Lv >= 995, _Lv =< 995 ->
		[{5,0,35329350}];
get_fire_exp_reward(_Lv) when _Lv >= 996, _Lv =< 996 ->
		[{5,0,35448925}];
get_fire_exp_reward(_Lv) when _Lv >= 997, _Lv =< 997 ->
		[{5,0,35568905}];
get_fire_exp_reward(_Lv) when _Lv >= 998, _Lv =< 998 ->
		[{5,0,35689292}];
get_fire_exp_reward(_Lv) when _Lv >= 999, _Lv =< 999 ->
		[{5,0,35810085}];
get_fire_exp_reward(_Lv) when _Lv >= 1000, _Lv =< 1000 ->
		[{5,0,35931288}];
get_fire_exp_reward(_Lv) ->
	[].

