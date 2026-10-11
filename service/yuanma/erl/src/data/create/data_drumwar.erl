%%%---------------------------------------
%%% module      : data_drumwar
%%% description : 钻石大战配置
%%%
%%%---------------------------------------
-module(data_drumwar).
-compile(export_all).
-include("drumwar.hrl").




get_kv(1) ->
250;


get_kv(2) ->
250;


get_kv(3) ->
2;


get_kv(4) ->
3;


get_kv(5) ->
20;


get_kv(6) ->
38040016;


get_kv(7) ->
24005;


get_kv(8) ->
24006;


get_kv(9) ->
[{1234,1081,200}];


get_kv(10) ->
[{975,890},{1667,883}];


get_kv(11) ->
[{975,890},{1667,883}];


get_kv(12) ->
[{1000001,1000002,1000003}];


get_kv(13) ->
[{1,0.001},{2,0.03},{3,0.01},{4,0.064},{5,0.006},{6,0.006},{7,0.006},{8,0.004}];


get_kv(14) ->
20;


get_kv(15) ->
5;


get_kv(16) ->
8;

get_kv(_Key) ->
	0.

get_war(1,1) ->
[{[{2,0,20}],[{2,0,10}]}];

get_war(1,2) ->
[{[{2,0,30}],[{2,0,10}]}];

get_war(1,3) ->
[{[{2,0,40}],[{2,0,20}]}];

get_war(1,4) ->
[{[{2,0,60}],[{2,0,30}]}];

get_war(1,5) ->
[{[{2,0,80}],[{2,0,40}]}];

get_war(1,6) ->
[{[{2,0,100}],[{2,0,50}]}];

get_war(1,7) ->
[{[{2,0,120}],[{2,0,60}]}];

get_war(1,8) ->
[{[{2,0,150}],[{2,0,70}]}];

get_war(1,9) ->
[{[{2,0,200}],[{2,0,80}]}];

get_war(1,10) ->
[{[{2,0,250}],[{2,0,100}]}];

get_war(1,11) ->
[{[{2,0,400}],[{2,0,120}]}];

get_war(1,12) ->
[{[{2,0,600}],[{2,0,150}]}];

get_war(_Zid,_Act) ->
	[{}].

get_rank(_Zid,_Rank) ->
	[].

get_open() ->
[[{1,0,0,0}]].

get_sign() ->
[75600].

get_sea_ready() ->
[180].

get_sea_prepare() ->
[30].

get_rank_prepare() ->
[30].

get_rank_ready() ->
[30].

get_sea_war() ->
[60].

get_rank_war() ->
[30].


get_choose(1) ->
[{[{2,0,20}],[{2,0,40}]}];


get_choose(2) ->
[{[{2,0,30}],[{2,0,60}]}];

get_choose(_Id) ->
	[].


get_zone_lv_range(1) ->
[{250,999}];

get_zone_lv_range(_Zid) ->
	[].

lv_to_zone(_Lv) when _Lv >= 250, _Lv =< 999 ->
		1;
lv_to_zone(_Lv) ->
	1.

get_max_zone() -> 1.

get_drum_ai_id() ->
[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,144,145,146,147,148,149,150,151,152,153,154,155,156,157,158,159,160,161,162,163,164,165,166,167,168,169,170,171,172,173,174,175,176,177,178,179,180,181,182,183,184,185,186,187,188,189,190,191,192,193,194,195,196,197,198,199,200,201,202,203,204,205,206,207,208,209,210,211,212,213,214,215,216,217,218,219,220,221,222,223,224,225,226,227,228,229,230,231,232,233,234,235,236,237,238,239,240,241,242,243,244,245,246,247,248,249,250,251,252,253,254,255,256,257,258,259,260,261,262,263,264,265,266,267,268,269,270,271,272,273,274,275,276,277,278,279,280,281,282,283,284,285,286,287,288,289,290,291,292,293,294,295,296,297,298,299,300,301,302,303,304,305,306,307,308,309,310,311,312,313,314,315,316,317,318,319,320,321,322,323,324,325,326,327,328,329,330,331,332,333,334,335,336,337,338,339,340,341,342,343,344,345,346,347,348,349,350,351,352,353,354,355,356,357,358,359,360,361,362,363,364,365,366,367,368,369,370,371,372,373,374,375,376,377,378,379,380,381,382,383,384,385,386,387,388,389,390,391,392,393,394,395,396,397,398,399,400,401,402,403,404,405,406,407,408,409,410,411,412,413,414,415,416,417,418,419,420,421,422,423,424,425,426,427,428,429,430,431,432,433,434,435,436,437,438,439,440,441,442,443,444,445,446,447,448,449,450,451,452,453,454,455,456,457,458,459,460,461,462,463,464,465,466,467,468,469,470,471,472,473,474,475,476,477,478,479,480,481,482,483,484,485,486,487,488,489,490,491,492,493,494,495,496,497,498,499,500,501,502,503,504,505,506,507,508,509,510,511,512,513,514,515,516,517,518,519,520,521,522,523,524,525,526,527,528,529,530,531,532,533,534,535,536,537,538,539,540,541,542,543,544,545,546,547,548,549,550,551,552,553,554,555,556,557,558,559,560,561,562,563,564,565,566,567,568,569,570,571,572,573,574,575,576,577,578,579,580,581,582,583,584,585,586,587,588,589,590,591,592,593,594,595,596,597,598,599,600,601,602,603,604,605,606,607,608,609,610,611,612,613,614,615,616,617,618,619,620,621,622,623,624,625,626,627,628,629,630,631,632,633,634,635,636,637,638,639,640,641,642,643,644,645,646,647,648,649,650,651,652,653,654,655,656,657,658,659,660,661,662,663,664,665,666,667,668,669,670,671,672,673,674,675,676,677,678,679,680,681,682,683,684,685,686,687,688,689,690,691,692,693,694,695,696,697,698,699,700,701,702,703,704,705,706,707,708,709,710,711,712,713,714,715,716,717,718,719,720,721,722,723,724,725,726,727,728,729,730,731,732,733,734,735,736,737,738,739,740,741,742,743,744,745,746,747,748,749,750,751,752,753,754,755,756,757,758,759,760,761,762,763,764,765,766,767,768,769,770,771,772,773,774,775,776,777,778,779,780,781,782,783,784,785,786,787,788,789,790,791,792,793,794,795,796,797,798,799,800,801,802,803,804,805,806,807,808,809,810,811,812,813,814,815,816,817,818,819,820,821,822,823,824,825,826,827,828,829,830,831,832,833,834,835,836,837,838,839,840,841,842,843,844,845,846,847,848,849,850,851,852,853,854,855,856,857,858,859,860,861,862,863,864,865,866,867,868,869,870,871,872,873,874,875,876,877,878,879,880,881,882,883,884,885,886,887,888,889,890,891,892,893,894,895,896,897,898,899,900,901,902,903,904,905,906,907,908,909,910,911,912,913,914,915,916,917,918,919,920,921,922,923,924,925,926,927,928,929,930,931,932,933,934,935,936,937,938,939,940,941,942,943,944,945,946,947,948,949,950,951,952,953,954,955,956,957,958,959,960,961,962,963,964,965,966,967,968,969,970,971,972,973,974,975,976,977,978,979,980,981,982,983,984,985,986,987,988,989,990,991,992,993,994,995,996,997,998,999,1000,1001,1002,1003,1004,1005,1006,1007,1008,1009,1010,1011,1012,1013,1014,1015,1016,1017,1018,1019,1020,1021,1022,1023,1024,1025,1026,1027,1028,1029,1030,1031,1032,1033,1034,1035,1036,1037,1038,1039,1040,1041,1042,1043,1044,1045,1046,1047,1048,1049,1050,1051,1052,1053,1054,1055,1056,1057,1058,1059,1060,1061,1062,1063,1064,1065,1066,1067,1068,1069,1070,1071,1072,1073,1074,1075,1076,1077,1078,1079,1080,1081,1082,1083,1084,1085,1086,1087,1088,1089,1090,1091,1092,1093,1094,1095,1096,1097,1098,1099,1100,1101,1102,1103,1104,1105,1106,1107,1108,1109,1110,1111,1112,1113,1114,1115,1116,1117,1118,1119,1120,1121,1122,1123,1124,1125,1126,1127,1128,1129,1130,1131,1132,1133,1134,1135,1136,1137,1138,1139,1140,1141,1142,1143,1144,1145,1146,1147,1148,1149,1150,1151,1152,1153,1154,1155,1156,1157,1158,1159,1160,1161,1162,1163,1164,1165,1166,1167,1168,1169,1170,1171,1172,1173,1174,1175,1176,1177,1178,1179,1180,1181,1182,1183,1184,1185,1186,1187,1188,1189,1190,1191,1192,1193,1194,1195,1196,1197,1198,1199,1200,1201,1202,1203,1204,1205,1206,1207,1208,1209,1210,1211,1212,1213,1214,1215,1216,1217,1218,1219,1220,1221,1222,1223,1224,1225,1226,1227,1228,1229,1230,1231,1232,1233,1234,1235,1236,1237,1238,1239,1240,1241,1242,1243,1244,1245,1246,1247,1248,1249,1250,1251,1252,1253,1254,1255,1256,1257,1258,1259,1260,1261,1262,1263,1264,1265,1266,1267,1268,1269,1270,1271,1272,1273,1274,1275,1276,1277,1278,1279,1280,1281,1282,1283,1284,1285,1286,1287,1288,1289,1290,1291,1292,1293,1294,1295,1296,1297,1298,1299,1300,1301,1302,1303,1304,1305,1306,1307,1308,1309,1310,1311,1312,1313,1314,1315,1316,1317,1318,1319,1320,1321,1322,1323,1324,1325,1326,1327,1328,1329,1330,1331,1332,1333,1334,1335,1336,1337,1338,1339,1340,1341,1342,1343,1344,1345,1346,1347,1348,1349,1350,1351,1352,1353,1354,1355,1356,1357,1358,1359,1360,1361,1362,1363,1364,1365,1366,1367,1368,1369,1370,1371,1372,1373,1374,1375,1376,1377,1378,1379,1380,1381,1382,1383,1384,1385,1386,1387,1388,1389,1390,1391,1392,1393,1394,1395,1396,1397,1398,1399,1400,1401,1402,1403,1404,1405,1406,1407,1408,1409,1410,1411,1412,1413,1414,1415,1416,1417,1418,1419,1420,1421,1422,1423,1424,1425,1426,1427,1428,1429,1430,1431,1432,1433,1434,1435,1436,1437,1438,1439,1440,1441,1442,1443,1444,1445,1446,1447,1448,1449,1450,1451,1452,1453,1454,1455,1456,1457,1458,1459,1460,1461,1462,1463,1464,1465,1466,1467,1468,1469,1470,1471,1472,1473,1474,1475,1476,1477,1478,1479,1480,1481,1482,1483,1484,1485,1486,1487,1488,1489,1490,1491,1492,1493,1494,1495,1496,1497,1498,1499,1500,1501,1502,1503,1504,1505,1506,1507,1508,1509,1510,1511,1512,1513,1514,1515,1516,1517,1518,1519,1520,1521,1522,1523,1524,1525,1526,1527,1528,1529,1530,1531,1532,1533,1534,1535,1536,1537,1538,1539,1540,1541,1542,1543,1544,1545,1546,1547,1548,1549,1550,1551,1552,1553,1554,1555,1556,1557,1558,1559,1560,1561,1562,1563,1564,1565,1566,1567,1568,1569,1570,1571,1572,1573,1574,1575,1576,1577,1578,1579,1580,1581,1582,1583,1584,1585].


get_robot_name(1) ->
"萧青先";


get_robot_name(2) ->
"温婷菊";


get_robot_name(3) ->
"乐明潮";


get_robot_name(4) ->
"马润紫";


get_robot_name(5) ->
"计恩振";


get_robot_name(6) ->
"贲清世";


get_robot_name(7) ->
"古升冬";


get_robot_name(8) ->
"韦俊美";


get_robot_name(9) ->
"万杨宁";


get_robot_name(10) ->
"匡仲信";


get_robot_name(11) ->
"朱会连";


get_robot_name(12) ->
"费雯承";


get_robot_name(13) ->
"支雷臣";


get_robot_name(14) ->
"闾丘树标";


get_robot_name(15) ->
"万青爱";


get_robot_name(16) ->
"芮信";


get_robot_name(17) ->
"孙芬山";


get_robot_name(18) ->
"宣满昌";


get_robot_name(19) ->
"梅金学";


get_robot_name(20) ->
"廉继雪";


get_robot_name(21) ->
"闻露兆";


get_robot_name(22) ->
"虞方鸿";


get_robot_name(23) ->
"宣岚洪";


get_robot_name(24) ->
"夏侯雄洁";


get_robot_name(25) ->
"宗政世树";


get_robot_name(26) ->
"权皓";


get_robot_name(27) ->
"司文";


get_robot_name(28) ->
"牧茂保";


get_robot_name(29) ->
"党群鹏";


get_robot_name(30) ->
"籍家京";


get_robot_name(31) ->
"栾之道";


get_robot_name(32) ->
"韦威泽";


get_robot_name(33) ->
"万奎开";


get_robot_name(34) ->
"尤和颖";


get_robot_name(35) ->
"厍信年";


get_robot_name(36) ->
"鲁哲琳";


get_robot_name(37) ->
"温孝君";


get_robot_name(38) ->
"澹台文佳";


get_robot_name(39) ->
"幸茜哲";


get_robot_name(40) ->
"宁琴庭";


get_robot_name(41) ->
"却哲家";


get_robot_name(42) ->
"司宪石";


get_robot_name(43) ->
"羿方和";


get_robot_name(44) ->
"叶睿远";


get_robot_name(45) ->
"蓝麒碧";


get_robot_name(46) ->
"璩坚妮";


get_robot_name(47) ->
"沙瑜文";


get_robot_name(48) ->
"栾朝丹";


get_robot_name(49) ->
"邹桂士";


get_robot_name(50) ->
"赵铁利";


get_robot_name(51) ->
"古和恒";


get_robot_name(52) ->
"党建剑";


get_robot_name(53) ->
"曾川荣";


get_robot_name(54) ->
"别利日";


get_robot_name(55) ->
"厍全祖";


get_robot_name(56) ->
"易鲁利";


get_robot_name(57) ->
"喻贵";


get_robot_name(58) ->
"隗厚伯";


get_robot_name(59) ->
"却克祖";


get_robot_name(60) ->
"嵇辉尧";


get_robot_name(61) ->
"李锦传";


get_robot_name(62) ->
"司徒萌依";


get_robot_name(63) ->
"马雁为";


get_robot_name(64) ->
"赵梅恩";


get_robot_name(65) ->
"邢方怡";


get_robot_name(66) ->
"万萍琦";


get_robot_name(67) ->
"诸葛贵达";


get_robot_name(68) ->
"戴然铭";


get_robot_name(69) ->
"厍德进";


get_robot_name(70) ->
"贲滨有";


get_robot_name(71) ->
"闻子琪";


get_robot_name(72) ->
"闾丘宝";


get_robot_name(73) ->
"闾丘劲显";


get_robot_name(74) ->
"却有廷";


get_robot_name(75) ->
"尤祥佩";


get_robot_name(76) ->
"咸飞中";


get_robot_name(77) ->
"仇贤斌";


get_robot_name(78) ->
"司子革";


get_robot_name(79) ->
"公孙冰栋";


get_robot_name(80) ->
"公孙蕾天";


get_robot_name(81) ->
"支顺咏";


get_robot_name(82) ->
"伏嘉彬";


get_robot_name(83) ->
"朱景丽";


get_robot_name(84) ->
"马晶咏";


get_robot_name(85) ->
"穆仲华";


get_robot_name(86) ->
"山坤朝";


get_robot_name(87) ->
"文顺铁";


get_robot_name(88) ->
"盛萌安";


get_robot_name(89) ->
"仲孙钰夏";


get_robot_name(90) ->
"梅杨保";


get_robot_name(91) ->
"盛靖一";


get_robot_name(92) ->
"澹台立天";


get_robot_name(93) ->
"孙庆炳";


get_robot_name(94) ->
"秦珊升";


get_robot_name(95) ->
"沙乃镇";


get_robot_name(96) ->
"梅连吉";


get_robot_name(97) ->
"竺浩冬";


get_robot_name(98) ->
"隗舒铭";


get_robot_name(99) ->
"毋绍雷";


get_robot_name(100) ->
"刁梓桐";


get_robot_name(101) ->
"索恩岚";


get_robot_name(102) ->
"嵇进钧";


get_robot_name(103) ->
"于雄耀";


get_robot_name(104) ->
"赵锋廷";


get_robot_name(105) ->
"山双";


get_robot_name(106) ->
"匡晶健";


get_robot_name(107) ->
"计柏菊";


get_robot_name(108) ->
"易沛显";


get_robot_name(109) ->
"权焕";


get_robot_name(110) ->
"戴豪建";


get_robot_name(111) ->
"韦妮南";


get_robot_name(112) ->
"万申钢";


get_robot_name(113) ->
"闾丘方利";


get_robot_name(114) ->
"栾丹群";


get_robot_name(115) ->
"籍铭林";


get_robot_name(116) ->
"易全伯";


get_robot_name(117) ->
"费绍卫";


get_robot_name(118) ->
"宣锦";


get_robot_name(119) ->
"薛灿荣";


get_robot_name(120) ->
"杜运福";


get_robot_name(121) ->
"虞伟聪";


get_robot_name(122) ->
"叶露先";


get_robot_name(123) ->
"程靖显";


get_robot_name(124) ->
"伏书秀";


get_robot_name(125) ->
"储宇钰";


get_robot_name(126) ->
"许年";


get_robot_name(127) ->
"璩开波";


get_robot_name(128) ->
"储灵宜";


get_robot_name(129) ->
"国坤绍";


get_robot_name(130) ->
"厍毅镇";


get_robot_name(131) ->
"尤楠";


get_robot_name(132) ->
"古超启";


get_robot_name(133) ->
"许雄承";


get_robot_name(134) ->
"厍锋树";


get_robot_name(135) ->
"仲孙石逸";


get_robot_name(136) ->
"于钢菲";


get_robot_name(137) ->
"温辉淇";


get_robot_name(138) ->
"宗政群维";


get_robot_name(139) ->
"赵绍凤";


get_robot_name(140) ->
"李咏欣";


get_robot_name(141) ->
"傅山菲";


get_robot_name(142) ->
"羿洋光";


get_robot_name(143) ->
"尤亚树";


get_robot_name(144) ->
"邢哲智";


get_robot_name(145) ->
"闵旭诗";


get_robot_name(146) ->
"戚男光";


get_robot_name(147) ->
"权越卓";


get_robot_name(148) ->
"芮万浩";


get_robot_name(149) ->
"万宏孟";


get_robot_name(150) ->
"党亚芳";


get_robot_name(151) ->
"诸葛蕾琳";


get_robot_name(152) ->
"伏雄运";


get_robot_name(153) ->
"古洲惠";


get_robot_name(154) ->
"刁远广";


get_robot_name(155) ->
"朱浩麒";


get_robot_name(156) ->
"傅声珠";


get_robot_name(157) ->
"沙声铁";


get_robot_name(158) ->
"尹冠秀";


get_robot_name(159) ->
"嵇鸿";


get_robot_name(160) ->
"毋耀曼";


get_robot_name(161) ->
"尹心芳";


get_robot_name(162) ->
"支厚勋";


get_robot_name(163) ->
"韦菲崇";


get_robot_name(164) ->
"宣菊宁";


get_robot_name(165) ->
"宗政倩飞";


get_robot_name(166) ->
"别越新";


get_robot_name(167) ->
"贲同厚";


get_robot_name(168) ->
"古越凤";


get_robot_name(169) ->
"邹可臣";


get_robot_name(170) ->
"易龙西";


get_robot_name(171) ->
"尹立";


get_robot_name(172) ->
"邹满钧";


get_robot_name(173) ->
"党宝满";


get_robot_name(174) ->
"国祥";


get_robot_name(175) ->
"时芬";


get_robot_name(176) ->
"邹政其";


get_robot_name(177) ->
"公冶希利";


get_robot_name(178) ->
"权茂昊";


get_robot_name(179) ->
"仲孙平革";


get_robot_name(180) ->
"毋泽小";


get_robot_name(181) ->
"沙翔滨";


get_robot_name(182) ->
"幸君奎";


get_robot_name(183) ->
"闻雯南";


get_robot_name(184) ->
"叶祖曼";


get_robot_name(185) ->
"萧承友";


get_robot_name(186) ->
"游淇儿";


get_robot_name(187) ->
"宁洪小";


get_robot_name(188) ->
"叶翔庭";


get_robot_name(189) ->
"岑民琳";


get_robot_name(190) ->
"贲志勤";


get_robot_name(191) ->
"公冶先茂";


get_robot_name(192) ->
"于云松";


get_robot_name(193) ->
"尤鸣武";


get_robot_name(194) ->
"薛永兴";


get_robot_name(195) ->
"莘星";


get_robot_name(196) ->
"芮夫根";


get_robot_name(197) ->
"国潮民";


get_robot_name(198) ->
"费羽仲";


get_robot_name(199) ->
"籍蕾麟";


get_robot_name(200) ->
"李晨";


get_robot_name(201) ->
"曾湘仲";


get_robot_name(202) ->
"伏富基";


get_robot_name(203) ->
"仲孙晖世";


get_robot_name(204) ->
"夏侯芝中";


get_robot_name(205) ->
"岑学润";


get_robot_name(206) ->
"芮碧波";


get_robot_name(207) ->
"秦凤";


get_robot_name(208) ->
"丁怡其";


get_robot_name(209) ->
"虞捷";


get_robot_name(210) ->
"穆星灿";


get_robot_name(211) ->
"栾虎骏";


get_robot_name(212) ->
"时友庆";


get_robot_name(213) ->
"昌汝磊";


get_robot_name(214) ->
"巩根源";


get_robot_name(215) ->
"咸钧磊";


get_robot_name(216) ->
"邢贵勇";


get_robot_name(217) ->
"仇标利";


get_robot_name(218) ->
"闻权心";


get_robot_name(219) ->
"山天心";


get_robot_name(220) ->
"古彤吉";


get_robot_name(221) ->
"司徒贤";


get_robot_name(222) ->
"沙建涵";


get_robot_name(223) ->
"邹贤军";


get_robot_name(224) ->
"秦夏";


get_robot_name(225) ->
"璩蕾";


get_robot_name(226) ->
"秦菲";


get_robot_name(227) ->
"于基";


get_robot_name(228) ->
"咸咏乐";


get_robot_name(229) ->
"向琳先";


get_robot_name(230) ->
"隗蕾亮";


get_robot_name(231) ->
"萧然良";


get_robot_name(232) ->
"公孙大";


get_robot_name(233) ->
"程兆佳";


get_robot_name(234) ->
"公孙春海";


get_robot_name(235) ->
"梅斌";


get_robot_name(236) ->
"程中灿";


get_robot_name(237) ->
"盛诗昌";


get_robot_name(238) ->
"沙发";


get_robot_name(239) ->
"费汝刚";


get_robot_name(240) ->
"于尧可";


get_robot_name(241) ->
"毋爱祥";


get_robot_name(242) ->
"闵冠蔚";


get_robot_name(243) ->
"闻久";


get_robot_name(244) ->
"傅方维";


get_robot_name(245) ->
"孙钧化";


get_robot_name(246) ->
"喻菊楠";


get_robot_name(247) ->
"喻淑定";


get_robot_name(248) ->
"游恩洋";


get_robot_name(249) ->
"厍丹智";


get_robot_name(250) ->
"宗政震豪";


get_robot_name(251) ->
"仲孙光正";


get_robot_name(252) ->
"阮恒萌";


get_robot_name(253) ->
"许东枫";


get_robot_name(254) ->
"蓝正行";


get_robot_name(255) ->
"隗珠平";


get_robot_name(256) ->
"梅凌霖";


get_robot_name(257) ->
"岑岚真";


get_robot_name(258) ->
"朱滨儿";


get_robot_name(259) ->
"昌素清";


get_robot_name(260) ->
"岑传黎";


get_robot_name(261) ->
"仇庭素";


get_robot_name(262) ->
"李羽沛";


get_robot_name(263) ->
"鲁智";


get_robot_name(264) ->
"伏其宏";


get_robot_name(265) ->
"傅伦同";


get_robot_name(266) ->
"赵宏峰";


get_robot_name(267) ->
"仲孙萍银";


get_robot_name(268) ->
"闻传轩";


get_robot_name(269) ->
"莘国百";


get_robot_name(270) ->
"费伟国";


get_robot_name(271) ->
"古大庆";


get_robot_name(272) ->
"计政嘉";


get_robot_name(273) ->
"游满怀";


get_robot_name(274) ->
"别成东";


get_robot_name(275) ->
"盛彬阳";


get_robot_name(276) ->
"师雄勇";


get_robot_name(277) ->
"梅卫冰";


get_robot_name(278) ->
"桑林朝";


get_robot_name(279) ->
"桑其勇";


get_robot_name(280) ->
"岑乐春";


get_robot_name(281) ->
"廉麟诚";


get_robot_name(282) ->
"贲祥高";


get_robot_name(283) ->
"万保麟";


get_robot_name(284) ->
"莘然章";


get_robot_name(285) ->
"温茜志";


get_robot_name(286) ->
"竺云琴";


get_robot_name(287) ->
"杜雅涵";


get_robot_name(288) ->
"成佩雄";


get_robot_name(289) ->
"闻人琳曼";


get_robot_name(290) ->
"鲁裕彬";


get_robot_name(291) ->
"阮锋秀";


get_robot_name(292) ->
"曾贤晨";


get_robot_name(293) ->
"韦楠如";


get_robot_name(294) ->
"昌泰家";


get_robot_name(295) ->
"牧庆腾";


get_robot_name(296) ->
"隗宏银";


get_robot_name(297) ->
"李革永";


get_robot_name(298) ->
"山谦汉";


get_robot_name(299) ->
"尤虹玮";


get_robot_name(300) ->
"嵇栋克";


get_robot_name(301) ->
"莘云祖";


get_robot_name(302) ->
"韦湘洲";


get_robot_name(303) ->
"秦继兆";


get_robot_name(304) ->
"储鑫冬";


get_robot_name(305) ->
"却培信";


get_robot_name(306) ->
"巩艳德";


get_robot_name(307) ->
"喻雯桂";


get_robot_name(308) ->
"戚旭威";


get_robot_name(309) ->
"宣青彦";


get_robot_name(310) ->
"曾权";


get_robot_name(311) ->
"戚波廷";


get_robot_name(312) ->
"李绍可";


get_robot_name(313) ->
"计爱海";


get_robot_name(314) ->
"厍浩依";


get_robot_name(315) ->
"万光基";


get_robot_name(316) ->
"梅诚琳";


get_robot_name(317) ->
"游伊纯";


get_robot_name(318) ->
"曾富辰";


get_robot_name(319) ->
"岑安卫";


get_robot_name(320) ->
"索亚玉";


get_robot_name(321) ->
"竺良";


get_robot_name(322) ->
"闻云逸";


get_robot_name(323) ->
"储星扬";


get_robot_name(324) ->
"仲孙年彦";


get_robot_name(325) ->
"马磊风";


get_robot_name(326) ->
"文凌佩";


get_robot_name(327) ->
"穆利同";


get_robot_name(328) ->
"游启先";


get_robot_name(329) ->
"宣麟浩";


get_robot_name(330) ->
"巩延汝";


get_robot_name(331) ->
"尹慧轩";


get_robot_name(332) ->
"戴依森";


get_robot_name(333) ->
"仲孙西羽";


get_robot_name(334) ->
"程依奇";


get_robot_name(335) ->
"易超颖";


get_robot_name(336) ->
"宁崇洋";


get_robot_name(337) ->
"薛子广";


get_robot_name(338) ->
"尹坚小";


get_robot_name(339) ->
"易行声";


get_robot_name(340) ->
"尤祖明";


get_robot_name(341) ->
"毋基生";


get_robot_name(342) ->
"师宁刚";


get_robot_name(343) ->
"林江培";


get_robot_name(344) ->
"杜庆";


get_robot_name(345) ->
"易航宜";


get_robot_name(346) ->
"向显孝";


get_robot_name(347) ->
"却棋水";


get_robot_name(348) ->
"戚汝一";


get_robot_name(349) ->
"党德媛";


get_robot_name(350) ->
"宣杰坤";


get_robot_name(351) ->
"叶芬逸";


get_robot_name(352) ->
"璩菲善";


get_robot_name(353) ->
"叶皓露";


get_robot_name(354) ->
"庄臣生";


get_robot_name(355) ->
"司徒连民";


get_robot_name(356) ->
"尤茂月";


get_robot_name(357) ->
"匡贤宁";


get_robot_name(358) ->
"曾航丽";


get_robot_name(359) ->
"璩仁杨";


get_robot_name(360) ->
"咸斌连";


get_robot_name(361) ->
"轩辕伟传";


get_robot_name(362) ->
"宣才全";


get_robot_name(363) ->
"巩凯洋";


get_robot_name(364) ->
"闻人杨灿";


get_robot_name(365) ->
"时恒小";


get_robot_name(366) ->
"山义";


get_robot_name(367) ->
"璩翔靖";


get_robot_name(368) ->
"曾雅民";


get_robot_name(369) ->
"栾延欣";


get_robot_name(370) ->
"戴彦敬";


get_robot_name(371) ->
"闵维仁";


get_robot_name(372) ->
"司徒彬华";


get_robot_name(373) ->
"游舒龙";


get_robot_name(374) ->
"温有琴";


get_robot_name(375) ->
"索文岚";


get_robot_name(376) ->
"古西景";


get_robot_name(377) ->
"支焕心";


get_robot_name(378) ->
"喻鑫羽";


get_robot_name(379) ->
"邹东炜";


get_robot_name(380) ->
"别聪凌";


get_robot_name(381) ->
"牧妍非";


get_robot_name(382) ->
"赵良海";


get_robot_name(383) ->
"夏侯嘉豪";


get_robot_name(384) ->
"林景紫";


get_robot_name(385) ->
"巩腾凡";


get_robot_name(386) ->
"索博鸣";


get_robot_name(387) ->
"宗政龙艳";


get_robot_name(388) ->
"赵岳";


get_robot_name(389) ->
"费东廷";


get_robot_name(390) ->
"李满滨";


get_robot_name(391) ->
"别力梦";


get_robot_name(392) ->
"厍冠咏";


get_robot_name(393) ->
"宁达哲";


get_robot_name(394) ->
"仲孙岚杨";


get_robot_name(395) ->
"戴尧斌";


get_robot_name(396) ->
"山方月";


get_robot_name(397) ->
"牧力军";


get_robot_name(398) ->
"时伦万";


get_robot_name(399) ->
"万月胜";


get_robot_name(400) ->
"桑豪晋";


get_robot_name(401) ->
"隗元亚";


get_robot_name(402) ->
"公冶健艳";


get_robot_name(403) ->
"仇鲁征";


get_robot_name(404) ->
"桑惠嘉";


get_robot_name(405) ->
"赵忠天";


get_robot_name(406) ->
"诸葛杰焕";


get_robot_name(407) ->
"籍炳夏";


get_robot_name(408) ->
"傅泉生";


get_robot_name(409) ->
"咸耀祖";


get_robot_name(410) ->
"时勇佳";


get_robot_name(411) ->
"师宇依";


get_robot_name(412) ->
"岑启有";


get_robot_name(413) ->
"昌绍亮";


get_robot_name(414) ->
"成沛宇";


get_robot_name(415) ->
"程咏";


get_robot_name(416) ->
"昌曼民";


get_robot_name(417) ->
"贲家礼";


get_robot_name(418) ->
"钱吉之";


get_robot_name(419) ->
"贲宜怀";


get_robot_name(420) ->
"匡毅滨";


get_robot_name(421) ->
"万帆萌";


get_robot_name(422) ->
"时双君";


get_robot_name(423) ->
"权鲁奇";


get_robot_name(424) ->
"别翰仲";


get_robot_name(425) ->
"蓝延红";


get_robot_name(426) ->
"计培";


get_robot_name(427) ->
"喻依钢";


get_robot_name(428) ->
"芮兰倩";


get_robot_name(429) ->
"钱向阳";


get_robot_name(430) ->
"于泽一";


get_robot_name(431) ->
"马腾岳";


get_robot_name(432) ->
"别舒山";


get_robot_name(433) ->
"许权儿";


get_robot_name(434) ->
"璩洪士";


get_robot_name(435) ->
"鲜于菊";


get_robot_name(436) ->
"鲜于冠才";


get_robot_name(437) ->
"孙佩耀";


get_robot_name(438) ->
"却鸿镇";


get_robot_name(439) ->
"成满孝";


get_robot_name(440) ->
"咸博";


get_robot_name(441) ->
"却荣光";


get_robot_name(442) ->
"仲孙潮";


get_robot_name(443) ->
"杜伟天";


get_robot_name(444) ->
"公孙腾志";


get_robot_name(445) ->
"阮璇喜";


get_robot_name(446) ->
"宣中刚";


get_robot_name(447) ->
"谢臣军";


get_robot_name(448) ->
"竺元潮";


get_robot_name(449) ->
"芮迪莲";


get_robot_name(450) ->
"乐田棋";


get_robot_name(451) ->
"戴秀";


get_robot_name(452) ->
"司彪柏";


get_robot_name(453) ->
"万震道";


get_robot_name(454) ->
"夏侯泉静";


get_robot_name(455) ->
"游乐羽";


get_robot_name(456) ->
"程运尧";


get_robot_name(457) ->
"温凡琪";


get_robot_name(458) ->
"戚家博";


get_robot_name(459) ->
"咸思珠";


get_robot_name(460) ->
"鲁松聪";


get_robot_name(461) ->
"薛士荣";


get_robot_name(462) ->
"竺维广";


get_robot_name(463) ->
"沙培化";


get_robot_name(464) ->
"于新强";


get_robot_name(465) ->
"山有兆";


get_robot_name(466) ->
"权冬丹";


get_robot_name(467) ->
"叶露奎";


get_robot_name(468) ->
"乐礼京";


get_robot_name(469) ->
"轩辕同";


get_robot_name(470) ->
"却祥坚";


get_robot_name(471) ->
"叶坚枫";


get_robot_name(472) ->
"赵民阳";


get_robot_name(473) ->
"易骏建";


get_robot_name(474) ->
"温敬彤";


get_robot_name(475) ->
"支信春";


get_robot_name(476) ->
"程绍雁";


get_robot_name(477) ->
"廉星";


get_robot_name(478) ->
"党珍";


get_robot_name(479) ->
"仇平建";


get_robot_name(480) ->
"叶杨";


get_robot_name(481) ->
"闻彪孟";


get_robot_name(482) ->
"隗柏洲";


get_robot_name(483) ->
"曾永爽";


get_robot_name(484) ->
"储伯开";


get_robot_name(485) ->
"诸葛卓雷";


get_robot_name(486) ->
"易向伟";


get_robot_name(487) ->
"栾保伟";


get_robot_name(488) ->
"游川厚";


get_robot_name(489) ->
"蓝西景";


get_robot_name(490) ->
"向国素";


get_robot_name(491) ->
"朱菁远";


get_robot_name(492) ->
"沙乐汝";


get_robot_name(493) ->
"喻川新";


get_robot_name(494) ->
"赵桐宏";


get_robot_name(495) ->
"赵威孟";


get_robot_name(496) ->
"易向男";


get_robot_name(497) ->
"竺国来";


get_robot_name(498) ->
"傅冠妍";


get_robot_name(499) ->
"尤翔伦";


get_robot_name(500) ->
"竺松珍";


get_robot_name(501) ->
"桑勇颖";


get_robot_name(502) ->
"邢勋心";


get_robot_name(503) ->
"戴恒菁";


get_robot_name(504) ->
"毋福娟";


get_robot_name(505) ->
"宁淑志";


get_robot_name(506) ->
"万学麒";


get_robot_name(507) ->
"戚年瑜";


get_robot_name(508) ->
"伏鸣彪";


get_robot_name(509) ->
"马之琴";


get_robot_name(510) ->
"穆智武";


get_robot_name(511) ->
"牧妮柏";


get_robot_name(512) ->
"乐开滨";


get_robot_name(513) ->
"昌银";


get_robot_name(514) ->
"曾福静";


get_robot_name(515) ->
"伏涛利";


get_robot_name(516) ->
"邹杨";


get_robot_name(517) ->
"游风尧";


get_robot_name(518) ->
"叶岳启";


get_robot_name(519) ->
"阮腾胜";


get_robot_name(520) ->
"毋长月";


get_robot_name(521) ->
"澹台兴艳";


get_robot_name(522) ->
"牧捷富";


get_robot_name(523) ->
"嵇洁旭";


get_robot_name(524) ->
"公孙方寿";


get_robot_name(525) ->
"宁咏";


get_robot_name(526) ->
"璩珍金";


get_robot_name(527) ->
"党奇山";


get_robot_name(528) ->
"闻人杰亦";


get_robot_name(529) ->
"廉京顺";


get_robot_name(530) ->
"虞轩龙";


get_robot_name(531) ->
"乐新淑";


get_robot_name(532) ->
"别小桂";


get_robot_name(533) ->
"司鑫";


get_robot_name(534) ->
"鲜于菲福";


get_robot_name(535) ->
"巩高富";


get_robot_name(536) ->
"沙龙兴";


get_robot_name(537) ->
"游辰茜";


get_robot_name(538) ->
"匡达向";


get_robot_name(539) ->
"厍旭爽";


get_robot_name(540) ->
"伏明紫";


get_robot_name(541) ->
"山淇";


get_robot_name(542) ->
"莘行达";


get_robot_name(543) ->
"李庭岚";


get_robot_name(544) ->
"曾学汝";


get_robot_name(545) ->
"费金欣";


get_robot_name(546) ->
"杜孟宇";


get_robot_name(547) ->
"山孝瑞";


get_robot_name(548) ->
"萧声潮";


get_robot_name(549) ->
"澹台高瑞";


get_robot_name(550) ->
"国菊连";


get_robot_name(551) ->
"向桂汝";


get_robot_name(552) ->
"嵇健璇";


get_robot_name(553) ->
"牧洲柏";


get_robot_name(554) ->
"宣声麒";


get_robot_name(555) ->
"权圣延";


get_robot_name(556) ->
"幸晖扬";


get_robot_name(557) ->
"闻珊琴";


get_robot_name(558) ->
"易芳志";


get_robot_name(559) ->
"诸葛刚";


get_robot_name(560) ->
"叶风奇";


get_robot_name(561) ->
"仇凡斌";


get_robot_name(562) ->
"鲜于基钧";


get_robot_name(563) ->
"庄昊钢";


get_robot_name(564) ->
"向宝";


get_robot_name(565) ->
"游梦喜";


get_robot_name(566) ->
"杜百达";


get_robot_name(567) ->
"薛兆雁";


get_robot_name(568) ->
"师子";


get_robot_name(569) ->
"古卫刚";


get_robot_name(570) ->
"宗政奇青";


get_robot_name(571) ->
"山静宏";


get_robot_name(572) ->
"林轩锦";


get_robot_name(573) ->
"傅勋森";


get_robot_name(574) ->
"嵇维艺";


get_robot_name(575) ->
"薛仲";


get_robot_name(576) ->
"司君洲";


get_robot_name(577) ->
"宗政玉锋";


get_robot_name(578) ->
"林捷炳";


get_robot_name(579) ->
"傅舒";


get_robot_name(580) ->
"宁仲铁";


get_robot_name(581) ->
"索晶景";


get_robot_name(582) ->
"程厚天";


get_robot_name(583) ->
"别珍宁";


get_robot_name(584) ->
"山晓有";


get_robot_name(585) ->
"索杰";


get_robot_name(586) ->
"却乃树";


get_robot_name(587) ->
"傅传焕";


get_robot_name(588) ->
"公冶清岚";


get_robot_name(589) ->
"诸葛爽良";


get_robot_name(590) ->
"温丹鸣";


get_robot_name(591) ->
"竺延娟";


get_robot_name(592) ->
"权怡进";


get_robot_name(593) ->
"国祖翰";


get_robot_name(594) ->
"贲宪";


get_robot_name(595) ->
"成善逸";


get_robot_name(596) ->
"巩群礼";


get_robot_name(597) ->
"宣征耀";


get_robot_name(598) ->
"毋云立";


get_robot_name(599) ->
"鲁友霖";


get_robot_name(600) ->
"鲁革圣";


get_robot_name(601) ->
"丁钢达";


get_robot_name(602) ->
"杜喜夏";


get_robot_name(603) ->
"傅洋紫";


get_robot_name(604) ->
"易恒道";


get_robot_name(605) ->
"支翰秀";


get_robot_name(606) ->
"钱淇生";


get_robot_name(607) ->
"马金风";


get_robot_name(608) ->
"刁跃发";


get_robot_name(609) ->
"咸树万";


get_robot_name(610) ->
"刁钧潮";


get_robot_name(611) ->
"国君川";


get_robot_name(612) ->
"叶申杨";


get_robot_name(613) ->
"林运燕";


get_robot_name(614) ->
"虞仲芬";


get_robot_name(615) ->
"邹化久";


get_robot_name(616) ->
"于汝建";


get_robot_name(617) ->
"薛传蕾";


get_robot_name(618) ->
"岑威萍";


get_robot_name(619) ->
"闻昌绍";


get_robot_name(620) ->
"傅会雄";


get_robot_name(621) ->
"薛紫光";


get_robot_name(622) ->
"厍孟春";


get_robot_name(623) ->
"闻庆涵";


get_robot_name(624) ->
"昌军翰";


get_robot_name(625) ->
"竺才凤";


get_robot_name(626) ->
"宗政小亚";


get_robot_name(627) ->
"闾丘恩欣";


get_robot_name(628) ->
"栾芳贤";


get_robot_name(629) ->
"邢杨雄";


get_robot_name(630) ->
"丁珠坚";


get_robot_name(631) ->
"闻西可";


get_robot_name(632) ->
"隗全向";


get_robot_name(633) ->
"澹台书楠";


get_robot_name(634) ->
"钱胜楚";


get_robot_name(635) ->
"澹台延凡";


get_robot_name(636) ->
"赵咏洪";


get_robot_name(637) ->
"巩恩霖";


get_robot_name(638) ->
"阮森可";


get_robot_name(639) ->
"宣楠志";


get_robot_name(640) ->
"李景";


get_robot_name(641) ->
"沙崇日";


get_robot_name(642) ->
"曾志昊";


get_robot_name(643) ->
"莘丹延";


get_robot_name(644) ->
"隗梓凤";


get_robot_name(645) ->
"古蔚";


get_robot_name(646) ->
"程晨晖";


get_robot_name(647) ->
"羿延光";


get_robot_name(648) ->
"傅泽桂";


get_robot_name(649) ->
"戴洲青";


get_robot_name(650) ->
"邹恩";


get_robot_name(651) ->
"党长楚";


get_robot_name(652) ->
"栾昊辉";


get_robot_name(653) ->
"乐永贤";


get_robot_name(654) ->
"李善";


get_robot_name(655) ->
"梅蔚佳";


get_robot_name(656) ->
"竺琦锡";


get_robot_name(657) ->
"公孙定逸";


get_robot_name(658) ->
"璩田道";


get_robot_name(659) ->
"杜安力";


get_robot_name(660) ->
"向士丹";


get_robot_name(661) ->
"喻瑜士";


get_robot_name(662) ->
"公孙波昌";


get_robot_name(663) ->
"易革奕";


get_robot_name(664) ->
"易西冰";


get_robot_name(665) ->
"计泰可";


get_robot_name(666) ->
"轩辕燕崇";


get_robot_name(667) ->
"廉洲";


get_robot_name(668) ->
"闻人坤茂";


get_robot_name(669) ->
"昌培";


get_robot_name(670) ->
"巩如继";


get_robot_name(671) ->
"万珊奇";


get_robot_name(672) ->
"咸贵万";


get_robot_name(673) ->
"却云";


get_robot_name(674) ->
"李菁真";


get_robot_name(675) ->
"喻雷湘";


get_robot_name(676) ->
"闻人刚景";


get_robot_name(677) ->
"梅武越";


get_robot_name(678) ->
"司曼亚";


get_robot_name(679) ->
"韦露满";


get_robot_name(680) ->
"费晖奎";


get_robot_name(681) ->
"索琳";


get_robot_name(682) ->
"闻夫湘";


get_robot_name(683) ->
"宗政琳腾";


get_robot_name(684) ->
"毋亮立";


get_robot_name(685) ->
"莘伦晖";


get_robot_name(686) ->
"计洪革";


get_robot_name(687) ->
"程久洋";


get_robot_name(688) ->
"巩亚元";


get_robot_name(689) ->
"山忠强";


get_robot_name(690) ->
"邹卓炳";


get_robot_name(691) ->
"向虎玉";


get_robot_name(692) ->
"虞昌";


get_robot_name(693) ->
"时骏芳";


get_robot_name(694) ->
"尹祖崇";


get_robot_name(695) ->
"游伟月";


get_robot_name(696) ->
"叶雷";


get_robot_name(697) ->
"阮素承";


get_robot_name(698) ->
"诸葛锦紫";


get_robot_name(699) ->
"伏树雅";


get_robot_name(700) ->
"喻恒爽";


get_robot_name(701) ->
"许英圣";


get_robot_name(702) ->
"闵灵霖";


get_robot_name(703) ->
"鲁清冰";


get_robot_name(704) ->
"梅进倩";


get_robot_name(705) ->
"伏欣慧";


get_robot_name(706) ->
"宁娜";


get_robot_name(707) ->
"宁兴桂";


get_robot_name(708) ->
"成孟友";


get_robot_name(709) ->
"匡金海";


get_robot_name(710) ->
"宁心梓";


get_robot_name(711) ->
"鲁桐书";


get_robot_name(712) ->
"支化璇";


get_robot_name(713) ->
"幸城祖";


get_robot_name(714) ->
"索先紫";


get_robot_name(715) ->
"司徒继敬";


get_robot_name(716) ->
"温媛";


get_robot_name(717) ->
"孙传棋";


get_robot_name(718) ->
"栾汉桐";


get_robot_name(719) ->
"向辉勇";


get_robot_name(720) ->
"程继星";


get_robot_name(721) ->
"孙万城";


get_robot_name(722) ->
"于真超";


get_robot_name(723) ->
"公孙润棋";


get_robot_name(724) ->
"梅潮发";


get_robot_name(725) ->
"穆行阳";


get_robot_name(726) ->
"权达惠";


get_robot_name(727) ->
"易国诗";


get_robot_name(728) ->
"璩然湘";


get_robot_name(729) ->
"萧立娜";


get_robot_name(730) ->
"闵海奎";


get_robot_name(731) ->
"虞平坤";


get_robot_name(732) ->
"诸葛森彪";


get_robot_name(733) ->
"芮钢孝";


get_robot_name(734) ->
"仲孙华化";


get_robot_name(735) ->
"薛来麒";


get_robot_name(736) ->
"竺学彪";


get_robot_name(737) ->
"傅铁天";


get_robot_name(738) ->
"蓝诚";


get_robot_name(739) ->
"轩辕耀显";


get_robot_name(740) ->
"程士焕";


get_robot_name(741) ->
"秦梓安";


get_robot_name(742) ->
"向卫勋";


get_robot_name(743) ->
"别琳良";


get_robot_name(744) ->
"文章妍";


get_robot_name(745) ->
"李红焕";


get_robot_name(746) ->
"宗政斌晋";


get_robot_name(747) ->
"毋雁吉";


get_robot_name(748) ->
"计黎萌";


get_robot_name(749) ->
"毋梦飞";


get_robot_name(750) ->
"成君祖";


get_robot_name(751) ->
"孙道珍";


get_robot_name(752) ->
"成靖宏";


get_robot_name(753) ->
"咸锡邦";


get_robot_name(754) ->
"璩如";


get_robot_name(755) ->
"邹城天";


get_robot_name(756) ->
"昌沛";


get_robot_name(757) ->
"叶化宪";


get_robot_name(758) ->
"刁舒庭";


get_robot_name(759) ->
"咸润保";


get_robot_name(760) ->
"廉保立";


get_robot_name(761) ->
"于静军";


get_robot_name(762) ->
"沙磊";


get_robot_name(763) ->
"蓝学久";


get_robot_name(764) ->
"喻沛喜";


get_robot_name(765) ->
"闾丘宗英";


get_robot_name(766) ->
"温佩云";


get_robot_name(767) ->
"计贵腾";


get_robot_name(768) ->
"璩超镇";


get_robot_name(769) ->
"贲振海";


get_robot_name(770) ->
"戴鸿家";


get_robot_name(771) ->
"林生恩";


get_robot_name(772) ->
"计康腾";


get_robot_name(773) ->
"韦政永";


get_robot_name(774) ->
"喻航萌";


get_robot_name(775) ->
"韦来";


get_robot_name(776) ->
"司雪敬";


get_robot_name(777) ->
"匡菲骏";


get_robot_name(778) ->
"璩豪贵";


get_robot_name(779) ->
"乐春勋";


get_robot_name(780) ->
"宁小湘";


get_robot_name(781) ->
"闵皓爽";


get_robot_name(782) ->
"程亦伟";


get_robot_name(783) ->
"邢凤琴";


get_robot_name(784) ->
"向萌";


get_robot_name(785) ->
"竺沛冬";


get_robot_name(786) ->
"时金";


get_robot_name(787) ->
"萧然越";


get_robot_name(788) ->
"竺东";


get_robot_name(789) ->
"权伟珊";


get_robot_name(790) ->
"权田根";


get_robot_name(791) ->
"游利晨";


get_robot_name(792) ->
"许基铭";


get_robot_name(793) ->
"邹依艺";


get_robot_name(794) ->
"籍学东";


get_robot_name(795) ->
"林化雨";


get_robot_name(796) ->
"乐向武";


get_robot_name(797) ->
"沙晨依";


get_robot_name(798) ->
"梅行敬";


get_robot_name(799) ->
"费健勇";


get_robot_name(800) ->
"仲孙善蔚";


get_robot_name(801) ->
"和颖楚";


get_robot_name(802) ->
"芮菲学";


get_robot_name(803) ->
"索云鲁";


get_robot_name(804) ->
"轩辕虹雨";


get_robot_name(805) ->
"嵇超开";


get_robot_name(806) ->
"李寿鸿";


get_robot_name(807) ->
"轩辕良运";


get_robot_name(808) ->
"刁莲显";


get_robot_name(809) ->
"许子沛";


get_robot_name(810) ->
"沙琳晨";


get_robot_name(811) ->
"丁桐涛";


get_robot_name(812) ->
"公冶跃刚";


get_robot_name(813) ->
"鲁顺";


get_robot_name(814) ->
"赵晨坚";


get_robot_name(815) ->
"嵇越圣";


get_robot_name(816) ->
"党征学";


get_robot_name(817) ->
"沙铭耀";


get_robot_name(818) ->
"喻岚兴";


get_robot_name(819) ->
"许孝鹏";


get_robot_name(820) ->
"成玲西";


get_robot_name(821) ->
"毋露仲";


get_robot_name(822) ->
"曾雷聪";


get_robot_name(823) ->
"梅瑜贵";


get_robot_name(824) ->
"幸中成";


get_robot_name(825) ->
"宗政荣炜";


get_robot_name(826) ->
"叶秀朝";


get_robot_name(827) ->
"莘珠旭";


get_robot_name(828) ->
"索宁涛";


get_robot_name(829) ->
"伏康桐";


get_robot_name(830) ->
"计平剑";


get_robot_name(831) ->
"阮进淇";


get_robot_name(832) ->
"费良晋";


get_robot_name(833) ->
"薛仪";


get_robot_name(834) ->
"山岩";


get_robot_name(835) ->
"巩君茂";


get_robot_name(836) ->
"匡兵奕";


get_robot_name(837) ->
"仲孙鑫";


get_robot_name(838) ->
"许昕媛";


get_robot_name(839) ->
"叶真凤";


get_robot_name(840) ->
"羿儿年";


get_robot_name(841) ->
"古钧茂";


get_robot_name(842) ->
"巩秀少";


get_robot_name(843) ->
"叶善兴";


get_robot_name(844) ->
"钱云奕";


get_robot_name(845) ->
"尤虎伊";


get_robot_name(846) ->
"蓝兆鑫";


get_robot_name(847) ->
"孙臣黎";


get_robot_name(848) ->
"孙宜钰";


get_robot_name(849) ->
"宁方鸣";


get_robot_name(850) ->
"巩红道";


get_robot_name(851) ->
"阮曼良";


get_robot_name(852) ->
"索希芬";


get_robot_name(853) ->
"虞燕跃";


get_robot_name(854) ->
"咸鹤政";


get_robot_name(855) ->
"成楚国";


get_robot_name(856) ->
"咸丹雪";


get_robot_name(857) ->
"桑诗凯";


get_robot_name(858) ->
"闾丘达菲";


get_robot_name(859) ->
"嵇凡云";


get_robot_name(860) ->
"索标军";


get_robot_name(861) ->
"叶栋石";


get_robot_name(862) ->
"籍日圣";


get_robot_name(863) ->
"籍燕建";


get_robot_name(864) ->
"仲孙朝萌";


get_robot_name(865) ->
"马惠瑞";


get_robot_name(866) ->
"竺来昌";


get_robot_name(867) ->
"公冶乐荣";


get_robot_name(868) ->
"梅扬安";


get_robot_name(869) ->
"庄年义";


get_robot_name(870) ->
"权彪洪";


get_robot_name(871) ->
"赵洲军";


get_robot_name(872) ->
"牧权如";


get_robot_name(873) ->
"巩翰雨";


get_robot_name(874) ->
"杜启家";


get_robot_name(875) ->
"仇学锦";


get_robot_name(876) ->
"许梓喜";


get_robot_name(877) ->
"厍枫祥";


get_robot_name(878) ->
"公孙全长";


get_robot_name(879) ->
"牧若基";


get_robot_name(880) ->
"储胜";


get_robot_name(881) ->
"尤文智";


get_robot_name(882) ->
"却欣琦";


get_robot_name(883) ->
"闻少城";


get_robot_name(884) ->
"山顺政";


get_robot_name(885) ->
"成青珠";


get_robot_name(886) ->
"司徒仪洋";


get_robot_name(887) ->
"咸书日";


get_robot_name(888) ->
"文孝楠";


get_robot_name(889) ->
"牧惠磊";


get_robot_name(890) ->
"伏山";


get_robot_name(891) ->
"孙智伟";


get_robot_name(892) ->
"桑高伊";


get_robot_name(893) ->
"嵇长岚";


get_robot_name(894) ->
"闻志天";


get_robot_name(895) ->
"蓝恩成";


get_robot_name(896) ->
"庄坚倩";


get_robot_name(897) ->
"羿璇少";


get_robot_name(898) ->
"昌琳丹";


get_robot_name(899) ->
"支旭洪";


get_robot_name(900) ->
"朱胜敬";


get_robot_name(901) ->
"费基发";


get_robot_name(902) ->
"支菁良";


get_robot_name(903) ->
"闾丘汝进";


get_robot_name(904) ->
"刁钢继";


get_robot_name(905) ->
"邢鹏西";


get_robot_name(906) ->
"梅权基";


get_robot_name(907) ->
"幸根若";


get_robot_name(908) ->
"闾丘儿东";


get_robot_name(909) ->
"璩琴进";


get_robot_name(910) ->
"沙谦咏";


get_robot_name(911) ->
"穆勤妮";


get_robot_name(912) ->
"计金凯";


get_robot_name(913) ->
"丁广光";


get_robot_name(914) ->
"程才凡";


get_robot_name(915) ->
"时静刚";


get_robot_name(916) ->
"厍坤俊";


get_robot_name(917) ->
"澹台风彤";


get_robot_name(918) ->
"山麒玉";


get_robot_name(919) ->
"索翰启";


get_robot_name(920) ->
"羿士湘";


get_robot_name(921) ->
"伏高革";


get_robot_name(922) ->
"宁艺久";


get_robot_name(923) ->
"闻艳桐";


get_robot_name(924) ->
"诸葛凤忠";


get_robot_name(925) ->
"戴玮丹";


get_robot_name(926) ->
"计黎妍";


get_robot_name(927) ->
"向风夫";


get_robot_name(928) ->
"文革麟";


get_robot_name(929) ->
"璩钰";


get_robot_name(930) ->
"杜菲娜";


get_robot_name(931) ->
"李枫逸";


get_robot_name(932) ->
"盛月高";


get_robot_name(933) ->
"庄远";


get_robot_name(934) ->
"璩鑫";


get_robot_name(935) ->
"国威全";


get_robot_name(936) ->
"轩辕珊孟";


get_robot_name(937) ->
"蓝全双";


get_robot_name(938) ->
"游京水";


get_robot_name(939) ->
"许宗冠";


get_robot_name(940) ->
"时灿睿";


get_robot_name(941) ->
"牧谦真";


get_robot_name(942) ->
"籍高川";


get_robot_name(943) ->
"贲道彪";


get_robot_name(944) ->
"赵淑高";


get_robot_name(945) ->
"梅孟江";


get_robot_name(946) ->
"马敬力";


get_robot_name(947) ->
"谢玲芳";


get_robot_name(948) ->
"司徒臣贵";


get_robot_name(949) ->
"岑善晋";


get_robot_name(950) ->
"羿光杰";


get_robot_name(951) ->
"诸葛宪凡";


get_robot_name(952) ->
"澹台仲剑";


get_robot_name(953) ->
"司徒依川";


get_robot_name(954) ->
"戚彪杰";


get_robot_name(955) ->
"阮廷翰";


get_robot_name(956) ->
"邹芝虎";


get_robot_name(957) ->
"羿鹤灿";


get_robot_name(958) ->
"幸勋亚";


get_robot_name(959) ->
"轩辕培鸿";


get_robot_name(960) ->
"杜瑜善";


get_robot_name(961) ->
"刁昊鑫";


get_robot_name(962) ->
"芮章";


get_robot_name(963) ->
"澹台国承";


get_robot_name(964) ->
"宗政茜爽";


get_robot_name(965) ->
"傅全刚";


get_robot_name(966) ->
"叶娜岩";


get_robot_name(967) ->
"沙全友";


get_robot_name(968) ->
"温青芬";


get_robot_name(969) ->
"幸文瑜";


get_robot_name(970) ->
"刁山强";


get_robot_name(971) ->
"尤超月";


get_robot_name(972) ->
"于楚岩";


get_robot_name(973) ->
"文菁礼";


get_robot_name(974) ->
"山杰彪";


get_robot_name(975) ->
"牧风凯";


get_robot_name(976) ->
"栾静云";


get_robot_name(977) ->
"乐敏皓";


get_robot_name(978) ->
"李智月";


get_robot_name(979) ->
"闻菊国";


get_robot_name(980) ->
"廉雄荣";


get_robot_name(981) ->
"别兴光";


get_robot_name(982) ->
"尤传琦";


get_robot_name(983) ->
"隗紫康";


get_robot_name(984) ->
"储乐龙";


get_robot_name(985) ->
"曾智艳";


get_robot_name(986) ->
"司徒仪玉";


get_robot_name(987) ->
"和艺剑";


get_robot_name(988) ->
"鲁芝";


get_robot_name(989) ->
"蓝达润";


get_robot_name(990) ->
"孙立朝";


get_robot_name(991) ->
"和亦";


get_robot_name(992) ->
"喻婷亦";


get_robot_name(993) ->
"时群靖";


get_robot_name(994) ->
"韦剑依";


get_robot_name(995) ->
"游咏";


get_robot_name(996) ->
"昌洲希";


get_robot_name(997) ->
"闵奇秋";


get_robot_name(998) ->
"杜秀";


get_robot_name(999) ->
"桑富水";


get_robot_name(1000) ->
"岑群成";


get_robot_name(1001) ->
"和百妮";


get_robot_name(1002) ->
"戴楚坤";


get_robot_name(1003) ->
"栾丹杨";


get_robot_name(1004) ->
"芮茂云";


get_robot_name(1005) ->
"和湘海";


get_robot_name(1006) ->
"孙利佳";


get_robot_name(1007) ->
"闻钢博";


get_robot_name(1008) ->
"薛扬";


get_robot_name(1009) ->
"万杨";


get_robot_name(1010) ->
"文露";


get_robot_name(1011) ->
"杜兰川";


get_robot_name(1012) ->
"芮骏建";


get_robot_name(1013) ->
"宁帆惠";


get_robot_name(1014) ->
"司革湘";


get_robot_name(1015) ->
"游露城";


get_robot_name(1016) ->
"杜君和";


get_robot_name(1017) ->
"公孙震大";


get_robot_name(1018) ->
"却钢";


get_robot_name(1019) ->
"虞光政";


get_robot_name(1020) ->
"国锋";


get_robot_name(1021) ->
"时莲";


get_robot_name(1022) ->
"沙权生";


get_robot_name(1023) ->
"萧洋奎";


get_robot_name(1024) ->
"国芳凡";


get_robot_name(1025) ->
"隗化非";


get_robot_name(1026) ->
"鲁小";


get_robot_name(1027) ->
"成鸣玲";


get_robot_name(1028) ->
"盛冠家";


get_robot_name(1029) ->
"于乐佳";


get_robot_name(1030) ->
"匡碧";


get_robot_name(1031) ->
"尤海百";


get_robot_name(1032) ->
"孙炜谦";


get_robot_name(1033) ->
"叶虹";


get_robot_name(1034) ->
"易运树";


get_robot_name(1035) ->
"戚雨爽";


get_robot_name(1036) ->
"司先";


get_robot_name(1037) ->
"万舒敏";


get_robot_name(1038) ->
"时祖";


get_robot_name(1039) ->
"虞清越";


get_robot_name(1040) ->
"支亚颖";


get_robot_name(1041) ->
"莘卓艳";


get_robot_name(1042) ->
"梅京奕";


get_robot_name(1043) ->
"闻人夏越";


get_robot_name(1044) ->
"萧炜菁";


get_robot_name(1045) ->
"盛崇宜";


get_robot_name(1046) ->
"莘静怡";


get_robot_name(1047) ->
"闾丘忠亚";


get_robot_name(1048) ->
"盛尧民";


get_robot_name(1049) ->
"毋淑传";


get_robot_name(1050) ->
"闻人恩夫";


get_robot_name(1051) ->
"和嘉满";


get_robot_name(1052) ->
"钱慧孝";


get_robot_name(1053) ->
"盛福义";


get_robot_name(1054) ->
"栾怀麟";


get_robot_name(1055) ->
"时艳羽";


get_robot_name(1056) ->
"阮兆凌";


get_robot_name(1057) ->
"厍邦沛";


get_robot_name(1058) ->
"温露双";


get_robot_name(1059) ->
"司晓先";


get_robot_name(1060) ->
"闵百";


get_robot_name(1061) ->
"尤伦延";


get_robot_name(1062) ->
"师锋";


get_robot_name(1063) ->
"公冶丹征";


get_robot_name(1064) ->
"李基琦";


get_robot_name(1065) ->
"古铁夫";


get_robot_name(1066) ->
"曾艺依";


get_robot_name(1067) ->
"桑骏尧";


get_robot_name(1068) ->
"巩崇铁";


get_robot_name(1069) ->
"钱富翔";


get_robot_name(1070) ->
"古威";


get_robot_name(1071) ->
"夏侯湘怀";


get_robot_name(1072) ->
"程皓林";


get_robot_name(1073) ->
"尹丹腾";


get_robot_name(1074) ->
"文桐夏";


get_robot_name(1075) ->
"权宪运";


get_robot_name(1076) ->
"党彦博";


get_robot_name(1077) ->
"和阳";


get_robot_name(1078) ->
"戴良骏";


get_robot_name(1079) ->
"师石裕";


get_robot_name(1080) ->
"却卓豪";


get_robot_name(1081) ->
"万会纯";


get_robot_name(1082) ->
"仇露";


get_robot_name(1083) ->
"于之云";


get_robot_name(1084) ->
"仲孙蔚中";


get_robot_name(1085) ->
"轩辕焕鲁";


get_robot_name(1086) ->
"公孙友万";


get_robot_name(1087) ->
"于喜芝";


get_robot_name(1088) ->
"司徒洋升";


get_robot_name(1089) ->
"羿仁富";


get_robot_name(1090) ->
"许镇贵";


get_robot_name(1091) ->
"璩涛芬";


get_robot_name(1092) ->
"闻人贤城";


get_robot_name(1093) ->
"闻人银仲";


get_robot_name(1094) ->
"万君友";


get_robot_name(1095) ->
"巩钧";


get_robot_name(1096) ->
"牧欣";


get_robot_name(1097) ->
"闻人宜逸";


get_robot_name(1098) ->
"戚少芝";


get_robot_name(1099) ->
"权捷";


get_robot_name(1100) ->
"闻人梅楚";


get_robot_name(1101) ->
"李泉彬";


get_robot_name(1102) ->
"时厚超";


get_robot_name(1103) ->
"桑惠扬";


get_robot_name(1104) ->
"盛皓瑞";


get_robot_name(1105) ->
"谢勤纯";


get_robot_name(1106) ->
"公孙兰";


get_robot_name(1107) ->
"曾阳裕";


get_robot_name(1108) ->
"巩颖银";


get_robot_name(1109) ->
"竺权敬";


get_robot_name(1110) ->
"闻正春";


get_robot_name(1111) ->
"易承宜";


get_robot_name(1112) ->
"山岚哲";


get_robot_name(1113) ->
"澹台善瑞";


get_robot_name(1114) ->
"隗耀开";


get_robot_name(1115) ->
"诸葛传珊";


get_robot_name(1116) ->
"喻晓福";


get_robot_name(1117) ->
"赵若道";


get_robot_name(1118) ->
"幸希宝";


get_robot_name(1119) ->
"闵芬孝";


get_robot_name(1120) ->
"师豪立";


get_robot_name(1121) ->
"鲁麟德";


get_robot_name(1122) ->
"诸葛根雁";


get_robot_name(1123) ->
"费风";


get_robot_name(1124) ->
"司波咏";


get_robot_name(1125) ->
"闻洁同";


get_robot_name(1126) ->
"司徒芬柏";


get_robot_name(1127) ->
"乐权萌";


get_robot_name(1128) ->
"牧剑娟";


get_robot_name(1129) ->
"时吉虎";


get_robot_name(1130) ->
"牧标满";


get_robot_name(1131) ->
"秦聪慧";


get_robot_name(1132) ->
"毋征培";


get_robot_name(1133) ->
"赵虹安";


get_robot_name(1134) ->
"山乐奎";


get_robot_name(1135) ->
"索寿钢";


get_robot_name(1136) ->
"于向凤";


get_robot_name(1137) ->
"向岳英";


get_robot_name(1138) ->
"易子";


get_robot_name(1139) ->
"萧来伊";


get_robot_name(1140) ->
"虞岩田";


get_robot_name(1141) ->
"匡圣中";


get_robot_name(1142) ->
"澹台超斌";


get_robot_name(1143) ->
"宁蔚会";


get_robot_name(1144) ->
"咸芬夫";


get_robot_name(1145) ->
"林双";


get_robot_name(1146) ->
"鲜于金捷";


get_robot_name(1147) ->
"山杰超";


get_robot_name(1148) ->
"庄绍仪";


get_robot_name(1149) ->
"穆儿琳";


get_robot_name(1150) ->
"澹台夏";


get_robot_name(1151) ->
"宗政磊";


get_robot_name(1152) ->
"司徒森孟";


get_robot_name(1153) ->
"索茂乐";


get_robot_name(1154) ->
"芮轩芝";


get_robot_name(1155) ->
"虞孝菁";


get_robot_name(1156) ->
"党善奎";


get_robot_name(1157) ->
"秦锋楚";


get_robot_name(1158) ->
"牧青晓";


get_robot_name(1159) ->
"昌景洲";


get_robot_name(1160) ->
"虞彦兵";


get_robot_name(1161) ->
"咸阳彬";


get_robot_name(1162) ->
"喻洲正";


get_robot_name(1163) ->
"邢伟可";


get_robot_name(1164) ->
"夏侯宇小";


get_robot_name(1165) ->
"傅儿冠";


get_robot_name(1166) ->
"隗家若";


get_robot_name(1167) ->
"宗政咏中";


get_robot_name(1168) ->
"权利";


get_robot_name(1169) ->
"谢碧迪";


get_robot_name(1170) ->
"向潮久";


get_robot_name(1171) ->
"喻启仁";


get_robot_name(1172) ->
"向棋升";


get_robot_name(1173) ->
"邢奎静";


get_robot_name(1174) ->
"栾君日";


get_robot_name(1175) ->
"宣虹晓";


get_robot_name(1176) ->
"蓝捷定";


get_robot_name(1177) ->
"林庭芬";


get_robot_name(1178) ->
"盛林志";


get_robot_name(1179) ->
"游水嘉";


get_robot_name(1180) ->
"璩军鹏";


get_robot_name(1181) ->
"乐善非";


get_robot_name(1182) ->
"莘顺锦";


get_robot_name(1183) ->
"索君先";


get_robot_name(1184) ->
"隗惠奎";


get_robot_name(1185) ->
"幸喜旭";


get_robot_name(1186) ->
"宁斌西";


get_robot_name(1187) ->
"戴诚";


get_robot_name(1188) ->
"权红仲";


get_robot_name(1189) ->
"闵方佩";


get_robot_name(1190) ->
"毋倩光";


get_robot_name(1191) ->
"穆珍富";


get_robot_name(1192) ->
"鲁钧双";


get_robot_name(1193) ->
"刁琴冬";


get_robot_name(1194) ->
"司徒年寿";


get_robot_name(1195) ->
"毋谦翔";


get_robot_name(1196) ->
"易琦彤";


get_robot_name(1197) ->
"别远菁";


get_robot_name(1198) ->
"夏侯启兆";


get_robot_name(1199) ->
"支树";


get_robot_name(1200) ->
"邢强运";


get_robot_name(1201) ->
"程富菁";


get_robot_name(1202) ->
"钱德心";


get_robot_name(1203) ->
"毋跃勤";


get_robot_name(1204) ->
"公孙祖彦";


get_robot_name(1205) ->
"司倩鹏";


get_robot_name(1206) ->
"梅若泽";


get_robot_name(1207) ->
"叶行振";


get_robot_name(1208) ->
"山京欣";


get_robot_name(1209) ->
"韦锦声";


get_robot_name(1210) ->
"宁利茜";


get_robot_name(1211) ->
"莘化行";


get_robot_name(1212) ->
"秦辉鸣";


get_robot_name(1213) ->
"程胜惠";


get_robot_name(1214) ->
"羿尧国";


get_robot_name(1215) ->
"林发博";


get_robot_name(1216) ->
"沙雅铭";


get_robot_name(1217) ->
"古光和";


get_robot_name(1218) ->
"栾杨卓";


get_robot_name(1219) ->
"程真方";


get_robot_name(1220) ->
"阮滨彤";


get_robot_name(1221) ->
"莘申南";


get_robot_name(1222) ->
"闻文慧";


get_robot_name(1223) ->
"师德";


get_robot_name(1224) ->
"匡同";


get_robot_name(1225) ->
"杜倩伟";


get_robot_name(1226) ->
"赵非为";


get_robot_name(1227) ->
"宁厚斌";


get_robot_name(1228) ->
"仇鹏恩";


get_robot_name(1229) ->
"马媛继";


get_robot_name(1230) ->
"向奕";


get_robot_name(1231) ->
"时男政";


get_robot_name(1232) ->
"朱双萍";


get_robot_name(1233) ->
"文蕾璇";


get_robot_name(1234) ->
"李荣";


get_robot_name(1235) ->
"厍升章";


get_robot_name(1236) ->
"闵全怀";


get_robot_name(1237) ->
"贲雯申";


get_robot_name(1238) ->
"别松阳";


get_robot_name(1239) ->
"于世";


get_robot_name(1240) ->
"孙丽震";


get_robot_name(1241) ->
"澹台丽曼";


get_robot_name(1242) ->
"贲标文";


get_robot_name(1243) ->
"穆承迪";


get_robot_name(1244) ->
"岑承昕";


get_robot_name(1245) ->
"闵升坤";


get_robot_name(1246) ->
"穆喜宏";


get_robot_name(1247) ->
"和行妮";


get_robot_name(1248) ->
"党莲向";


get_robot_name(1249) ->
"昌秀晨";


get_robot_name(1250) ->
"古开松";


get_robot_name(1251) ->
"桑强";


get_robot_name(1252) ->
"索显臣";


get_robot_name(1253) ->
"杜权菊";


get_robot_name(1254) ->
"山铁";


get_robot_name(1255) ->
"嵇连佩";


get_robot_name(1256) ->
"闻人铭贤";


get_robot_name(1257) ->
"闾丘永佩";


get_robot_name(1258) ->
"宣信怡";


get_robot_name(1259) ->
"马久田";


get_robot_name(1260) ->
"戴聪忠";


get_robot_name(1261) ->
"温保纯";


get_robot_name(1262) ->
"杜君泰";


get_robot_name(1263) ->
"宗政军杰";


get_robot_name(1264) ->
"岑羽启";


get_robot_name(1265) ->
"叶洁男";


get_robot_name(1266) ->
"权琦信";


get_robot_name(1267) ->
"游怡钢";


get_robot_name(1268) ->
"幸国晋";


get_robot_name(1269) ->
"邹子祥";


get_robot_name(1270) ->
"计岩龙";


get_robot_name(1271) ->
"宗政然清";


get_robot_name(1272) ->
"仲孙诗全";


get_robot_name(1273) ->
"璩宇书";


get_robot_name(1274) ->
"闻佩凯";


get_robot_name(1275) ->
"闻秀鲁";


get_robot_name(1276) ->
"莘娜桐";


get_robot_name(1277) ->
"于舒双";


get_robot_name(1278) ->
"邹佩燕";


get_robot_name(1279) ->
"嵇骏睿";


get_robot_name(1280) ->
"林宗如";


get_robot_name(1281) ->
"师风舒";


get_robot_name(1282) ->
"萧艺慧";


get_robot_name(1283) ->
"伏顺泉";


get_robot_name(1284) ->
"幸越睿";


get_robot_name(1285) ->
"伏红玲";


get_robot_name(1286) ->
"竺申涛";


get_robot_name(1287) ->
"羿水小";


get_robot_name(1288) ->
"闻人邦远";


get_robot_name(1289) ->
"幸帆海";


get_robot_name(1290) ->
"秦方康";


get_robot_name(1291) ->
"沙滨越";


get_robot_name(1292) ->
"薛显彦";


get_robot_name(1293) ->
"闵良亦";


get_robot_name(1294) ->
"秦玮世";


get_robot_name(1295) ->
"韦孟伯";


get_robot_name(1296) ->
"庄婷炳";


get_robot_name(1297) ->
"林崇";


get_robot_name(1298) ->
"却贤敏";


get_robot_name(1299) ->
"匡惠会";


get_robot_name(1300) ->
"李福虹";


get_robot_name(1301) ->
"轩辕涛灿";


get_robot_name(1302) ->
"谢来哲";


get_robot_name(1303) ->
"易廷";


get_robot_name(1304) ->
"宣轩";


get_robot_name(1305) ->
"廉碧";


get_robot_name(1306) ->
"廉裕";


get_robot_name(1307) ->
"仲孙廷焕";


get_robot_name(1308) ->
"桑吉威";


get_robot_name(1309) ->
"支森桐";


get_robot_name(1310) ->
"尹健方";


get_robot_name(1311) ->
"司徒润松";


get_robot_name(1312) ->
"咸娜凡";


get_robot_name(1313) ->
"伏洁月";


get_robot_name(1314) ->
"盛西锋";


get_robot_name(1315) ->
"薛世珊";


get_robot_name(1316) ->
"虞民";


get_robot_name(1317) ->
"栾振蕾";


get_robot_name(1318) ->
"羿向雁";


get_robot_name(1319) ->
"尹雨坤";


get_robot_name(1320) ->
"费振美";


get_robot_name(1321) ->
"文全克";


get_robot_name(1322) ->
"文英鑫";


get_robot_name(1323) ->
"傅泽信";


get_robot_name(1324) ->
"林标";


get_robot_name(1325) ->
"闾丘永政";


get_robot_name(1326) ->
"闾丘双";


get_robot_name(1327) ->
"万震群";


get_robot_name(1328) ->
"穆洪豪";


get_robot_name(1329) ->
"匡进诚";


get_robot_name(1330) ->
"鲜于宏兴";


get_robot_name(1331) ->
"璩惠舒";


get_robot_name(1332) ->
"闵根光";


get_robot_name(1333) ->
"厍培琦";


get_robot_name(1334) ->
"嵇群佳";


get_robot_name(1335) ->
"秦运露";


get_robot_name(1336) ->
"沙其鹏";


get_robot_name(1337) ->
"韦燕金";


get_robot_name(1338) ->
"谢鸿琳";


get_robot_name(1339) ->
"戚镇强";


get_robot_name(1340) ->
"幸伟";


get_robot_name(1341) ->
"巩信柏";


get_robot_name(1342) ->
"储楚立";


get_robot_name(1343) ->
"沙志凡";


get_robot_name(1344) ->
"傅灿新";


get_robot_name(1345) ->
"喻炜静";


get_robot_name(1346) ->
"戴曼惠";


get_robot_name(1347) ->
"鲁灿满";


get_robot_name(1348) ->
"穆辰恒";


get_robot_name(1349) ->
"乐爱君";


get_robot_name(1350) ->
"权雨政";


get_robot_name(1351) ->
"盛伦男";


get_robot_name(1352) ->
"莘征清";


get_robot_name(1353) ->
"戴鸣润";


get_robot_name(1354) ->
"国超伦";


get_robot_name(1355) ->
"轩辕炜炜";


get_robot_name(1356) ->
"游蕾坚";


get_robot_name(1357) ->
"咸全麒";


get_robot_name(1358) ->
"籍仪光";


get_robot_name(1359) ->
"盛勇珊";


get_robot_name(1360) ->
"时菁英";


get_robot_name(1361) ->
"宗政伟传";


get_robot_name(1362) ->
"轩辕嘉元";


get_robot_name(1363) ->
"戚晖百";


get_robot_name(1364) ->
"司徒良百";


get_robot_name(1365) ->
"羿梦";


get_robot_name(1366) ->
"储萍星";


get_robot_name(1367) ->
"轩辕寿孝";


get_robot_name(1368) ->
"杜璇龙";


get_robot_name(1369) ->
"廉子捷";


get_robot_name(1370) ->
"盛帆勋";


get_robot_name(1371) ->
"竺骏晨";


get_robot_name(1372) ->
"莘源博";


get_robot_name(1373) ->
"刁杨少";


get_robot_name(1374) ->
"羿迪翔";


get_robot_name(1375) ->
"司鸣铁";


get_robot_name(1376) ->
"轩辕怡永";


get_robot_name(1377) ->
"钱鹏扬";


get_robot_name(1378) ->
"梅和同";


get_robot_name(1379) ->
"和国静";


get_robot_name(1380) ->
"竺耀权";


get_robot_name(1381) ->
"支显";


get_robot_name(1382) ->
"成和庭";


get_robot_name(1383) ->
"毋孝同";


get_robot_name(1384) ->
"杜国祥";


get_robot_name(1385) ->
"盛岳";


get_robot_name(1386) ->
"牧妍兴";


get_robot_name(1387) ->
"山方莲";


get_robot_name(1388) ->
"傅仲为";


get_robot_name(1389) ->
"谢毅坤";


get_robot_name(1390) ->
"游珍";


get_robot_name(1391) ->
"戴菁夏";


get_robot_name(1392) ->
"蓝棋燕";


get_robot_name(1393) ->
"匡大荣";


get_robot_name(1394) ->
"籍厚妍";


get_robot_name(1395) ->
"夏侯平娜";


get_robot_name(1396) ->
"牧奎庆";


get_robot_name(1397) ->
"易雄之";


get_robot_name(1398) ->
"宣礼跃";


get_robot_name(1399) ->
"许兰道";


get_robot_name(1400) ->
"戚德皓";


get_robot_name(1401) ->
"和高小";


get_robot_name(1402) ->
"尤栋民";


get_robot_name(1403) ->
"韦南怡";


get_robot_name(1404) ->
"蓝艳庆";


get_robot_name(1405) ->
"游茜艳";


get_robot_name(1406) ->
"山宏";


get_robot_name(1407) ->
"岑依奇";


get_robot_name(1408) ->
"文萌麟";


get_robot_name(1409) ->
"索保婷";


get_robot_name(1410) ->
"鲁岳芳";


get_robot_name(1411) ->
"莘欣颖";


get_robot_name(1412) ->
"国丹鑫";


get_robot_name(1413) ->
"虞月楚";


get_robot_name(1414) ->
"赵淑君";


get_robot_name(1415) ->
"匡帆福";


get_robot_name(1416) ->
"宁智燕";


get_robot_name(1417) ->
"支虎怡";


get_robot_name(1418) ->
"戚婷捷";


get_robot_name(1419) ->
"孙鹏和";


get_robot_name(1420) ->
"戴宜全";


get_robot_name(1421) ->
"傅培贤";


get_robot_name(1422) ->
"幸宇树";


get_robot_name(1423) ->
"傅孝友";


get_robot_name(1424) ->
"马孝";


get_robot_name(1425) ->
"许雨";


get_robot_name(1426) ->
"谢鹤旭";


get_robot_name(1427) ->
"李顺东";


get_robot_name(1428) ->
"温贵运";


get_robot_name(1429) ->
"庄俊武";


get_robot_name(1430) ->
"梅茜顺";


get_robot_name(1431) ->
"钱可";


get_robot_name(1432) ->
"廉国中";


get_robot_name(1433) ->
"计菊怀";


get_robot_name(1434) ->
"穆根潮";


get_robot_name(1435) ->
"丁尧珍";


get_robot_name(1436) ->
"闾丘汉敏";


get_robot_name(1437) ->
"竺镇宝";


get_robot_name(1438) ->
"曾芬圣";


get_robot_name(1439) ->
"桑梓征";


get_robot_name(1440) ->
"萧裕京";


get_robot_name(1441) ->
"厍麟";


get_robot_name(1442) ->
"阮裕劲";


get_robot_name(1443) ->
"匡星蕾";


get_robot_name(1444) ->
"赵胜石";


get_robot_name(1445) ->
"游铁翰";


get_robot_name(1446) ->
"桑大桐";


get_robot_name(1447) ->
"夏侯红迪";


get_robot_name(1448) ->
"璩双";


get_robot_name(1449) ->
"毋蔚克";


get_robot_name(1450) ->
"孙喜可";


get_robot_name(1451) ->
"万瑞世";


get_robot_name(1452) ->
"匡希来";


get_robot_name(1453) ->
"温宝";


get_robot_name(1454) ->
"孙雁伯";


get_robot_name(1455) ->
"尤莲菲";


get_robot_name(1456) ->
"盛银革";


get_robot_name(1457) ->
"时钢航";


get_robot_name(1458) ->
"仲孙亮钢";


get_robot_name(1459) ->
"匡纯培";


get_robot_name(1460) ->
"储嘉茜";


get_robot_name(1461) ->
"诸葛运国";


get_robot_name(1462) ->
"廉武";


get_robot_name(1463) ->
"孙敏善";


get_robot_name(1464) ->
"闵思芬";


get_robot_name(1465) ->
"璩之琳";


get_robot_name(1466) ->
"尹锡鹤";


get_robot_name(1467) ->
"韦湘棋";


get_robot_name(1468) ->
"宗政尧灵";


get_robot_name(1469) ->
"梅川志";


get_robot_name(1470) ->
"诸葛根菁";


get_robot_name(1471) ->
"韦尧智";


get_robot_name(1472) ->
"喻辰志";


get_robot_name(1473) ->
"万忠钰";


get_robot_name(1474) ->
"宗政瑜淑";


get_robot_name(1475) ->
"闻人麒伊";


get_robot_name(1476) ->
"璩孝鹤";


get_robot_name(1477) ->
"籍厚";


get_robot_name(1478) ->
"曾菁道";


get_robot_name(1479) ->
"戚义士";


get_robot_name(1480) ->
"韦山雨";


get_robot_name(1481) ->
"尹钢菁";


get_robot_name(1482) ->
"栾尧奎";


get_robot_name(1483) ->
"计梦圣";


get_robot_name(1484) ->
"厍萍";


get_robot_name(1485) ->
"毋怡玲";


get_robot_name(1486) ->
"温依英";


get_robot_name(1487) ->
"储心方";


get_robot_name(1488) ->
"薛伊扬";


get_robot_name(1489) ->
"乐振凯";


get_robot_name(1490) ->
"许依厚";


get_robot_name(1491) ->
"毋达";


get_robot_name(1492) ->
"易祖尧";


get_robot_name(1493) ->
"党杨";


get_robot_name(1494) ->
"羿为敬";


get_robot_name(1495) ->
"谢菊兆";


get_robot_name(1496) ->
"莘霖清";


get_robot_name(1497) ->
"沙申";


get_robot_name(1498) ->
"邢诚杨";


get_robot_name(1499) ->
"仲孙清一";


get_robot_name(1500) ->
"刁强";


get_robot_name(1501) ->
"马洁卓";


get_robot_name(1502) ->
"杜新仲";


get_robot_name(1503) ->
"孙潮良";


get_robot_name(1504) ->
"诸葛彦敏";


get_robot_name(1505) ->
"宁耀沛";


get_robot_name(1506) ->
"岑非根";


get_robot_name(1507) ->
"幸兰锦";


get_robot_name(1508) ->
"刁镇锦";


get_robot_name(1509) ->
"丁玉信";


get_robot_name(1510) ->
"叶仲祥";


get_robot_name(1511) ->
"匡耀阳";


get_robot_name(1512) ->
"戚秋恩";


get_robot_name(1513) ->
"昌生炳";


get_robot_name(1514) ->
"国圣会";


get_robot_name(1515) ->
"别敬铁";


get_robot_name(1516) ->
"却仲晓";


get_robot_name(1517) ->
"温媛诗";


get_robot_name(1518) ->
"李正冠";


get_robot_name(1519) ->
"乐淇奎";


get_robot_name(1520) ->
"易丹双";


get_robot_name(1521) ->
"马伯";


get_robot_name(1522) ->
"宣哲宗";


get_robot_name(1523) ->
"程正厚";


get_robot_name(1524) ->
"秦梦钢";


get_robot_name(1525) ->
"叶骏曼";


get_robot_name(1526) ->
"韦敏龙";


get_robot_name(1527) ->
"桑来之";


get_robot_name(1528) ->
"时新树";


get_robot_name(1529) ->
"古素鹏";


get_robot_name(1530) ->
"璩华乐";


get_robot_name(1531) ->
"钱寿斌";


get_robot_name(1532) ->
"师彪国";


get_robot_name(1533) ->
"萧卫西";


get_robot_name(1534) ->
"毋海梓";


get_robot_name(1535) ->
"计靖涵";


get_robot_name(1536) ->
"向皓";


get_robot_name(1537) ->
"杜珍蔚";


get_robot_name(1538) ->
"幸汝石";


get_robot_name(1539) ->
"蓝昕凯";


get_robot_name(1540) ->
"莘宇吉";


get_robot_name(1541) ->
"师骏怀";


get_robot_name(1542) ->
"鲜于健";


get_robot_name(1543) ->
"师尧菊";


get_robot_name(1544) ->
"虞永哲";


get_robot_name(1545) ->
"尤延民";


get_robot_name(1546) ->
"澹台楠儿";


get_robot_name(1547) ->
"幸智杰";


get_robot_name(1548) ->
"杜建丽";


get_robot_name(1549) ->
"叶怀洁";


get_robot_name(1550) ->
"杜琳玲";


get_robot_name(1551) ->
"澹台方洁";


get_robot_name(1552) ->
"璩兆为";


get_robot_name(1553) ->
"党耀嘉";


get_robot_name(1554) ->
"时麒波";


get_robot_name(1555) ->
"廉紫景";


get_robot_name(1556) ->
"宁睿枫";


get_robot_name(1557) ->
"权江飞";


get_robot_name(1558) ->
"赵卫";


get_robot_name(1559) ->
"梅洁长";


get_robot_name(1560) ->
"党乐义";


get_robot_name(1561) ->
"尤洋震";


get_robot_name(1562) ->
"岑国伦";


get_robot_name(1563) ->
"丁文";


get_robot_name(1564) ->
"谢兆腾";


get_robot_name(1565) ->
"却焕开";


get_robot_name(1566) ->
"鲁涵会";


get_robot_name(1567) ->
"韦年奕";


get_robot_name(1568) ->
"穆乐如";


get_robot_name(1569) ->
"巩源学";


get_robot_name(1570) ->
"尤丽京";


get_robot_name(1571) ->
"程连德";


get_robot_name(1572) ->
"芮炳蕾";


get_robot_name(1573) ->
"虞冬涵";


get_robot_name(1574) ->
"朱斌儿";


get_robot_name(1575) ->
"古哲晖";


get_robot_name(1576) ->
"党城倩";


get_robot_name(1577) ->
"和月丽";


get_robot_name(1578) ->
"乐汉";


get_robot_name(1579) ->
"权天";


get_robot_name(1580) ->
"栾克敬";


get_robot_name(1581) ->
"程凌旭";


get_robot_name(1582) ->
"桑沛";


get_robot_name(1583) ->
"谢潮兴";


get_robot_name(1584) ->
"莘泉珊";


get_robot_name(1585) ->
"匡泉鲁";

get_robot_name(_Id) ->
	"来自异界的灵魂".

