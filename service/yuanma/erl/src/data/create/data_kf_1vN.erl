%%%---------------------------------------
%%% module      : data_kf_1vN
%%% description : 1vN配置
%%%
%%%---------------------------------------
-module(data_kf_1vN).
-compile(export_all).
-include("kf_1vN.hrl").



get_info(1) ->
	#kf_1vN_time_cfg{id = 1,open_week = [4],signtime = {4,0},optime = {21,0},race_1_pre = 120,race_1 = 920,race_1_m_time = 20,race_1_b_time = 60,race_2_pre = 60,race_2 = 1000,race_2_m_time = 10,race_2_b_time = 60};

get_info(_Id) ->
	[].

get_ac_ids() ->
[1].

get_area_list() ->
[1].

get_area(_Lv) when _Lv >= 250, _Lv =< 9999 ->
		1;
get_area(_Lv) ->
	0.

get_def_num(_SignNum) when _SignNum >= 2, _SignNum =< 31 ->
		[3,1];
get_def_num(_SignNum) when _SignNum >= 32, _SignNum =< 39 ->
		[4,2];
get_def_num(_SignNum) when _SignNum >= 40, _SignNum =< 47 ->
		[5,2];
get_def_num(_SignNum) when _SignNum >= 48, _SignNum =< 55 ->
		[6,3];
get_def_num(_SignNum) when _SignNum >= 56, _SignNum =< 63 ->
		[7,3];
get_def_num(_SignNum) when _SignNum >= 64, _SignNum =< 71 ->
		[8,4];
get_def_num(_SignNum) when _SignNum >= 72, _SignNum =< 79 ->
		[9,4];
get_def_num(_SignNum) when _SignNum >= 80, _SignNum =< 87 ->
		[10,5];
get_def_num(_SignNum) when _SignNum >= 88, _SignNum =< 95 ->
		[11,5];
get_def_num(_SignNum) when _SignNum >= 96, _SignNum =< 103 ->
		[12,6];
get_def_num(_SignNum) when _SignNum >= 104, _SignNum =< 111 ->
		[13,6];
get_def_num(_SignNum) when _SignNum >= 112, _SignNum =< 119 ->
		[14,7];
get_def_num(_SignNum) when _SignNum >= 120, _SignNum =< 127 ->
		[15,7];
get_def_num(_SignNum) when _SignNum >= 128, _SignNum =< 135 ->
		[16,8];
get_def_num(_SignNum) when _SignNum >= 136, _SignNum =< 143 ->
		[17,8];
get_def_num(_SignNum) when _SignNum >= 144, _SignNum =< 151 ->
		[18,9];
get_def_num(_SignNum) when _SignNum >= 152, _SignNum =< 159 ->
		[19,9];
get_def_num(_SignNum) when _SignNum >= 160, _SignNum =< 167 ->
		[20,10];
get_def_num(_SignNum) when _SignNum >= 168, _SignNum =< 175 ->
		[21,10];
get_def_num(_SignNum) when _SignNum >= 176, _SignNum =< 183 ->
		[22,11];
get_def_num(_SignNum) when _SignNum >= 184, _SignNum =< 191 ->
		[23,11];
get_def_num(_SignNum) when _SignNum >= 192, _SignNum =< 199 ->
		[24,12];
get_def_num(_SignNum) when _SignNum >= 200, _SignNum =< 207 ->
		[25,12];
get_def_num(_SignNum) when _SignNum >= 208, _SignNum =< 215 ->
		[26,13];
get_def_num(_SignNum) when _SignNum >= 216, _SignNum =< 223 ->
		[27,13];
get_def_num(_SignNum) when _SignNum >= 224, _SignNum =< 231 ->
		[28,14];
get_def_num(_SignNum) when _SignNum >= 232, _SignNum =< 239 ->
		[29,14];
get_def_num(_SignNum) when _SignNum >= 240, _SignNum =< 247 ->
		[30,15];
get_def_num(_SignNum) when _SignNum >= 248, _SignNum =< 255 ->
		[31,15];
get_def_num(_SignNum) when _SignNum >= 256, _SignNum =< 263 ->
		[32,16];
get_def_num(_SignNum) when _SignNum >= 264, _SignNum =< 271 ->
		[33,16];
get_def_num(_SignNum) when _SignNum >= 272, _SignNum =< 279 ->
		[34,17];
get_def_num(_SignNum) when _SignNum >= 280, _SignNum =< 287 ->
		[35,17];
get_def_num(_SignNum) when _SignNum >= 288, _SignNum =< 295 ->
		[36,18];
get_def_num(_SignNum) when _SignNum >= 296, _SignNum =< 303 ->
		[37,18];
get_def_num(_SignNum) when _SignNum >= 304, _SignNum =< 311 ->
		[38,19];
get_def_num(_SignNum) when _SignNum >= 312, _SignNum =< 319 ->
		[39,19];
get_def_num(_SignNum) when _SignNum >= 320, _SignNum =< 327 ->
		[40,20];
get_def_num(_SignNum) when _SignNum >= 328, _SignNum =< 335 ->
		[41,20];
get_def_num(_SignNum) when _SignNum >= 336, _SignNum =< 343 ->
		[42,21];
get_def_num(_SignNum) when _SignNum >= 344, _SignNum =< 351 ->
		[43,21];
get_def_num(_SignNum) when _SignNum >= 352, _SignNum =< 359 ->
		[44,22];
get_def_num(_SignNum) when _SignNum >= 360, _SignNum =< 367 ->
		[45,22];
get_def_num(_SignNum) when _SignNum >= 368, _SignNum =< 375 ->
		[46,23];
get_def_num(_SignNum) when _SignNum >= 376, _SignNum =< 383 ->
		[47,23];
get_def_num(_SignNum) when _SignNum >= 384, _SignNum =< 391 ->
		[48,24];
get_def_num(_SignNum) when _SignNum >= 392, _SignNum =< 399 ->
		[49,24];
get_def_num(_SignNum) when _SignNum >= 400, _SignNum =< 407 ->
		[50,25];
get_def_num(_SignNum) when _SignNum >= 408, _SignNum =< 415 ->
		[51,25];
get_def_num(_SignNum) when _SignNum >= 416, _SignNum =< 423 ->
		[52,26];
get_def_num(_SignNum) when _SignNum >= 424, _SignNum =< 431 ->
		[53,26];
get_def_num(_SignNum) when _SignNum >= 432, _SignNum =< 439 ->
		[54,27];
get_def_num(_SignNum) when _SignNum >= 440, _SignNum =< 447 ->
		[55,27];
get_def_num(_SignNum) when _SignNum >= 448, _SignNum =< 455 ->
		[56,28];
get_def_num(_SignNum) when _SignNum >= 456, _SignNum =< 463 ->
		[57,28];
get_def_num(_SignNum) when _SignNum >= 464, _SignNum =< 471 ->
		[58,29];
get_def_num(_SignNum) when _SignNum >= 472, _SignNum =< 479 ->
		[59,29];
get_def_num(_SignNum) when _SignNum >= 480, _SignNum =< 487 ->
		[60,30];
get_def_num(_SignNum) when _SignNum >= 488, _SignNum =< 495 ->
		[61,30];
get_def_num(_SignNum) when _SignNum >= 496, _SignNum =< 503 ->
		[62,31];
get_def_num(_SignNum) when _SignNum >= 504, _SignNum =< 511 ->
		[63,31];
get_def_num(_SignNum) when _SignNum >= 512, _SignNum =< 519 ->
		[64,32];
get_def_num(_SignNum) when _SignNum >= 520, _SignNum =< 527 ->
		[65,32];
get_def_num(_SignNum) when _SignNum >= 528, _SignNum =< 535 ->
		[66,33];
get_def_num(_SignNum) when _SignNum >= 536, _SignNum =< 543 ->
		[67,33];
get_def_num(_SignNum) when _SignNum >= 544, _SignNum =< 551 ->
		[68,34];
get_def_num(_SignNum) when _SignNum >= 552, _SignNum =< 559 ->
		[69,34];
get_def_num(_SignNum) when _SignNum >= 560, _SignNum =< 567 ->
		[70,35];
get_def_num(_SignNum) when _SignNum >= 568, _SignNum =< 575 ->
		[71,35];
get_def_num(_SignNum) when _SignNum >= 576, _SignNum =< 583 ->
		[72,36];
get_def_num(_SignNum) when _SignNum >= 584, _SignNum =< 591 ->
		[73,36];
get_def_num(_SignNum) when _SignNum >= 592, _SignNum =< 599 ->
		[74,37];
get_def_num(_SignNum) when _SignNum >= 600, _SignNum =< 607 ->
		[75,37];
get_def_num(_SignNum) when _SignNum >= 608, _SignNum =< 615 ->
		[76,38];
get_def_num(_SignNum) when _SignNum >= 616, _SignNum =< 623 ->
		[77,38];
get_def_num(_SignNum) when _SignNum >= 624, _SignNum =< 631 ->
		[78,39];
get_def_num(_SignNum) when _SignNum >= 632, _SignNum =< 639 ->
		[79,39];
get_def_num(_SignNum) when _SignNum >= 640, _SignNum =< 647 ->
		[80,40];
get_def_num(_SignNum) when _SignNum >= 648, _SignNum =< 655 ->
		[81,40];
get_def_num(_SignNum) when _SignNum >= 656, _SignNum =< 663 ->
		[82,41];
get_def_num(_SignNum) when _SignNum >= 664, _SignNum =< 671 ->
		[83,41];
get_def_num(_SignNum) when _SignNum >= 672, _SignNum =< 679 ->
		[84,42];
get_def_num(_SignNum) when _SignNum >= 680, _SignNum =< 687 ->
		[85,42];
get_def_num(_SignNum) when _SignNum >= 688, _SignNum =< 695 ->
		[86,43];
get_def_num(_SignNum) when _SignNum >= 696, _SignNum =< 703 ->
		[87,43];
get_def_num(_SignNum) when _SignNum >= 704, _SignNum =< 711 ->
		[88,44];
get_def_num(_SignNum) when _SignNum >= 712, _SignNum =< 719 ->
		[89,44];
get_def_num(_SignNum) when _SignNum >= 720, _SignNum =< 727 ->
		[90,45];
get_def_num(_SignNum) when _SignNum >= 728, _SignNum =< 735 ->
		[91,45];
get_def_num(_SignNum) when _SignNum >= 736, _SignNum =< 743 ->
		[92,46];
get_def_num(_SignNum) when _SignNum >= 744, _SignNum =< 751 ->
		[93,46];
get_def_num(_SignNum) when _SignNum >= 752, _SignNum =< 759 ->
		[94,47];
get_def_num(_SignNum) when _SignNum >= 760, _SignNum =< 767 ->
		[95,47];
get_def_num(_SignNum) when _SignNum >= 768, _SignNum =< 775 ->
		[96,48];
get_def_num(_SignNum) when _SignNum >= 776, _SignNum =< 783 ->
		[97,48];
get_def_num(_SignNum) when _SignNum >= 784, _SignNum =< 791 ->
		[98,49];
get_def_num(_SignNum) when _SignNum >= 792, _SignNum =< 799 ->
		[99,49];
get_def_num(_SignNum) when _SignNum >= 800, _SignNum =< 807 ->
		[100,50];
get_def_num(_SignNum) when _SignNum >= 808, _SignNum =< 815 ->
		[101,50];
get_def_num(_SignNum) when _SignNum >= 816, _SignNum =< 823 ->
		[102,51];
get_def_num(_SignNum) when _SignNum >= 824, _SignNum =< 831 ->
		[103,51];
get_def_num(_SignNum) when _SignNum >= 832, _SignNum =< 839 ->
		[104,52];
get_def_num(_SignNum) when _SignNum >= 840, _SignNum =< 847 ->
		[105,52];
get_def_num(_SignNum) when _SignNum >= 848, _SignNum =< 855 ->
		[106,53];
get_def_num(_SignNum) when _SignNum >= 856, _SignNum =< 863 ->
		[107,53];
get_def_num(_SignNum) when _SignNum >= 864, _SignNum =< 871 ->
		[108,54];
get_def_num(_SignNum) when _SignNum >= 872, _SignNum =< 879 ->
		[109,54];
get_def_num(_SignNum) when _SignNum >= 880, _SignNum =< 887 ->
		[110,55];
get_def_num(_SignNum) when _SignNum >= 888, _SignNum =< 895 ->
		[111,55];
get_def_num(_SignNum) when _SignNum >= 896, _SignNum =< 903 ->
		[112,56];
get_def_num(_SignNum) when _SignNum >= 904, _SignNum =< 911 ->
		[113,56];
get_def_num(_SignNum) when _SignNum >= 912, _SignNum =< 919 ->
		[114,57];
get_def_num(_SignNum) when _SignNum >= 920, _SignNum =< 927 ->
		[115,57];
get_def_num(_SignNum) when _SignNum >= 928, _SignNum =< 935 ->
		[116,58];
get_def_num(_SignNum) when _SignNum >= 936, _SignNum =< 943 ->
		[117,58];
get_def_num(_SignNum) when _SignNum >= 944, _SignNum =< 951 ->
		[118,59];
get_def_num(_SignNum) when _SignNum >= 952, _SignNum =< 959 ->
		[119,59];
get_def_num(_SignNum) when _SignNum >= 960, _SignNum =< 967 ->
		[120,60];
get_def_num(_SignNum) when _SignNum >= 968, _SignNum =< 975 ->
		[121,60];
get_def_num(_SignNum) when _SignNum >= 976, _SignNum =< 983 ->
		[122,61];
get_def_num(_SignNum) when _SignNum >= 984, _SignNum =< 991 ->
		[123,61];
get_def_num(_SignNum) when _SignNum >= 992, _SignNum =< 999 ->
		[124,62];
get_def_num(_SignNum) when _SignNum >= 1000, _SignNum =< 1007 ->
		[125,62];
get_def_num(_SignNum) when _SignNum >= 1008, _SignNum =< 1015 ->
		[126,63];
get_def_num(_SignNum) when _SignNum >= 1016, _SignNum =< 1023 ->
		[127,63];
get_def_num(_SignNum) when _SignNum >= 1024, _SignNum =< 1031 ->
		[128,64];
get_def_num(_SignNum) when _SignNum >= 1032, _SignNum =< 1039 ->
		[129,64];
get_def_num(_SignNum) when _SignNum >= 1040, _SignNum =< 1047 ->
		[130,65];
get_def_num(_SignNum) when _SignNum >= 1048, _SignNum =< 1055 ->
		[131,65];
get_def_num(_SignNum) when _SignNum >= 1056, _SignNum =< 1063 ->
		[132,66];
get_def_num(_SignNum) when _SignNum >= 1064, _SignNum =< 1071 ->
		[133,66];
get_def_num(_SignNum) when _SignNum >= 1072, _SignNum =< 1079 ->
		[134,67];
get_def_num(_SignNum) when _SignNum >= 1080, _SignNum =< 1087 ->
		[135,67];
get_def_num(_SignNum) when _SignNum >= 1088, _SignNum =< 1095 ->
		[136,68];
get_def_num(_SignNum) when _SignNum >= 1096, _SignNum =< 1103 ->
		[137,68];
get_def_num(_SignNum) when _SignNum >= 1104, _SignNum =< 1111 ->
		[138,69];
get_def_num(_SignNum) when _SignNum >= 1112, _SignNum =< 1119 ->
		[139,69];
get_def_num(_SignNum) when _SignNum >= 1120, _SignNum =< 1127 ->
		[140,70];
get_def_num(_SignNum) when _SignNum >= 1128, _SignNum =< 1135 ->
		[141,70];
get_def_num(_SignNum) when _SignNum >= 1136, _SignNum =< 1143 ->
		[142,71];
get_def_num(_SignNum) when _SignNum >= 1144, _SignNum =< 1151 ->
		[143,71];
get_def_num(_SignNum) when _SignNum >= 1152, _SignNum =< 1159 ->
		[144,72];
get_def_num(_SignNum) when _SignNum >= 1160, _SignNum =< 1167 ->
		[145,72];
get_def_num(_SignNum) when _SignNum >= 1168, _SignNum =< 1175 ->
		[146,73];
get_def_num(_SignNum) when _SignNum >= 1176, _SignNum =< 1183 ->
		[147,73];
get_def_num(_SignNum) when _SignNum >= 1184, _SignNum =< 1191 ->
		[148,74];
get_def_num(_SignNum) when _SignNum >= 1192, _SignNum =< 1199 ->
		[149,74];
get_def_num(_SignNum) when _SignNum >= 1200, _SignNum =< 1207 ->
		[150,75];
get_def_num(_SignNum) when _SignNum >= 1208, _SignNum =< 1215 ->
		[151,75];
get_def_num(_SignNum) when _SignNum >= 1216, _SignNum =< 1223 ->
		[152,76];
get_def_num(_SignNum) when _SignNum >= 1224, _SignNum =< 1231 ->
		[153,76];
get_def_num(_SignNum) when _SignNum >= 1232, _SignNum =< 1239 ->
		[154,77];
get_def_num(_SignNum) when _SignNum >= 1240, _SignNum =< 1247 ->
		[155,77];
get_def_num(_SignNum) when _SignNum >= 1248, _SignNum =< 1255 ->
		[156,78];
get_def_num(_SignNum) when _SignNum >= 1256, _SignNum =< 1263 ->
		[157,78];
get_def_num(_SignNum) when _SignNum >= 1264, _SignNum =< 1271 ->
		[158,79];
get_def_num(_SignNum) when _SignNum >= 1272, _SignNum =< 1279 ->
		[159,79];
get_def_num(_SignNum) when _SignNum >= 1280, _SignNum =< 1287 ->
		[160,80];
get_def_num(_SignNum) when _SignNum >= 1288, _SignNum =< 1295 ->
		[161,80];
get_def_num(_SignNum) when _SignNum >= 1296, _SignNum =< 1303 ->
		[162,81];
get_def_num(_SignNum) when _SignNum >= 1304, _SignNum =< 1311 ->
		[163,81];
get_def_num(_SignNum) when _SignNum >= 1312, _SignNum =< 1319 ->
		[164,82];
get_def_num(_SignNum) when _SignNum >= 1320, _SignNum =< 1327 ->
		[165,82];
get_def_num(_SignNum) when _SignNum >= 1328, _SignNum =< 1335 ->
		[166,83];
get_def_num(_SignNum) when _SignNum >= 1336, _SignNum =< 1343 ->
		[167,83];
get_def_num(_SignNum) when _SignNum >= 1344, _SignNum =< 1351 ->
		[168,84];
get_def_num(_SignNum) when _SignNum >= 1352, _SignNum =< 1359 ->
		[169,84];
get_def_num(_SignNum) when _SignNum >= 1360, _SignNum =< 1367 ->
		[170,85];
get_def_num(_SignNum) when _SignNum >= 1368, _SignNum =< 1375 ->
		[171,85];
get_def_num(_SignNum) when _SignNum >= 1376, _SignNum =< 1383 ->
		[172,86];
get_def_num(_SignNum) when _SignNum >= 1384, _SignNum =< 1391 ->
		[173,86];
get_def_num(_SignNum) when _SignNum >= 1392, _SignNum =< 1399 ->
		[174,87];
get_def_num(_SignNum) when _SignNum >= 1400, _SignNum =< 1407 ->
		[175,87];
get_def_num(_SignNum) when _SignNum >= 1408, _SignNum =< 1415 ->
		[176,88];
get_def_num(_SignNum) when _SignNum >= 1416, _SignNum =< 1423 ->
		[177,88];
get_def_num(_SignNum) when _SignNum >= 1424, _SignNum =< 1431 ->
		[178,89];
get_def_num(_SignNum) when _SignNum >= 1432, _SignNum =< 1439 ->
		[179,89];
get_def_num(_SignNum) when _SignNum >= 1440, _SignNum =< 1447 ->
		[180,90];
get_def_num(_SignNum) when _SignNum >= 1448, _SignNum =< 1455 ->
		[181,90];
get_def_num(_SignNum) when _SignNum >= 1456, _SignNum =< 1463 ->
		[182,91];
get_def_num(_SignNum) when _SignNum >= 1464, _SignNum =< 1471 ->
		[183,91];
get_def_num(_SignNum) when _SignNum >= 1472, _SignNum =< 1479 ->
		[184,92];
get_def_num(_SignNum) when _SignNum >= 1480, _SignNum =< 1487 ->
		[185,92];
get_def_num(_SignNum) when _SignNum >= 1488, _SignNum =< 1495 ->
		[186,93];
get_def_num(_SignNum) when _SignNum >= 1496, _SignNum =< 1503 ->
		[187,93];
get_def_num(_SignNum) when _SignNum >= 1504, _SignNum =< 1511 ->
		[188,94];
get_def_num(_SignNum) when _SignNum >= 1512, _SignNum =< 1519 ->
		[189,94];
get_def_num(_SignNum) when _SignNum >= 1520, _SignNum =< 1527 ->
		[190,95];
get_def_num(_SignNum) when _SignNum >= 1528, _SignNum =< 1535 ->
		[191,95];
get_def_num(_SignNum) when _SignNum >= 1536, _SignNum =< 1543 ->
		[192,96];
get_def_num(_SignNum) when _SignNum >= 1544, _SignNum =< 1551 ->
		[193,96];
get_def_num(_SignNum) when _SignNum >= 1552, _SignNum =< 1559 ->
		[194,97];
get_def_num(_SignNum) when _SignNum >= 1560, _SignNum =< 1567 ->
		[195,97];
get_def_num(_SignNum) when _SignNum >= 1568, _SignNum =< 1575 ->
		[196,98];
get_def_num(_SignNum) when _SignNum >= 1576, _SignNum =< 1583 ->
		[197,98];
get_def_num(_SignNum) when _SignNum >= 1584, _SignNum =< 1591 ->
		[198,99];
get_def_num(_SignNum) when _SignNum >= 1592, _SignNum =< 1599 ->
		[199,99];
get_def_num(_SignNum) when _SignNum >= 1600, _SignNum =< 1607 ->
		[200,100];
get_def_num(_SignNum) when _SignNum >= 1608, _SignNum =< 1615 ->
		[201,100];
get_def_num(_SignNum) when _SignNum >= 1616, _SignNum =< 1623 ->
		[202,101];
get_def_num(_SignNum) when _SignNum >= 1624, _SignNum =< 1631 ->
		[203,101];
get_def_num(_SignNum) when _SignNum >= 1632, _SignNum =< 1639 ->
		[204,102];
get_def_num(_SignNum) when _SignNum >= 1640, _SignNum =< 1647 ->
		[205,102];
get_def_num(_SignNum) when _SignNum >= 1648, _SignNum =< 1655 ->
		[206,103];
get_def_num(_SignNum) when _SignNum >= 1656, _SignNum =< 1663 ->
		[207,103];
get_def_num(_SignNum) when _SignNum >= 1664, _SignNum =< 1671 ->
		[208,104];
get_def_num(_SignNum) when _SignNum >= 1672, _SignNum =< 1679 ->
		[209,104];
get_def_num(_SignNum) when _SignNum >= 1680, _SignNum =< 1687 ->
		[210,105];
get_def_num(_SignNum) when _SignNum >= 1688, _SignNum =< 1695 ->
		[211,105];
get_def_num(_SignNum) when _SignNum >= 1696, _SignNum =< 1703 ->
		[212,106];
get_def_num(_SignNum) when _SignNum >= 1704, _SignNum =< 1711 ->
		[213,106];
get_def_num(_SignNum) when _SignNum >= 1712, _SignNum =< 1719 ->
		[214,107];
get_def_num(_SignNum) when _SignNum >= 1720, _SignNum =< 1727 ->
		[215,107];
get_def_num(_SignNum) when _SignNum >= 1728, _SignNum =< 1735 ->
		[216,108];
get_def_num(_SignNum) when _SignNum >= 1736, _SignNum =< 1743 ->
		[217,108];
get_def_num(_SignNum) when _SignNum >= 1744, _SignNum =< 1751 ->
		[218,109];
get_def_num(_SignNum) when _SignNum >= 1752, _SignNum =< 1759 ->
		[219,109];
get_def_num(_SignNum) when _SignNum >= 1760, _SignNum =< 1767 ->
		[220,110];
get_def_num(_SignNum) when _SignNum >= 1768, _SignNum =< 1775 ->
		[221,110];
get_def_num(_SignNum) when _SignNum >= 1776, _SignNum =< 1783 ->
		[222,111];
get_def_num(_SignNum) when _SignNum >= 1784, _SignNum =< 1791 ->
		[223,111];
get_def_num(_SignNum) when _SignNum >= 1792, _SignNum =< 1799 ->
		[224,112];
get_def_num(_SignNum) when _SignNum >= 1800, _SignNum =< 1807 ->
		[225,112];
get_def_num(_SignNum) when _SignNum >= 1808, _SignNum =< 1815 ->
		[226,113];
get_def_num(_SignNum) when _SignNum >= 1816, _SignNum =< 1823 ->
		[227,113];
get_def_num(_SignNum) when _SignNum >= 1824, _SignNum =< 1831 ->
		[228,114];
get_def_num(_SignNum) when _SignNum >= 1832, _SignNum =< 1839 ->
		[229,114];
get_def_num(_SignNum) when _SignNum >= 1840, _SignNum =< 1847 ->
		[230,115];
get_def_num(_SignNum) when _SignNum >= 1848, _SignNum =< 1855 ->
		[231,115];
get_def_num(_SignNum) when _SignNum >= 1856, _SignNum =< 1863 ->
		[232,116];
get_def_num(_SignNum) when _SignNum >= 1864, _SignNum =< 1871 ->
		[233,116];
get_def_num(_SignNum) when _SignNum >= 1872, _SignNum =< 1879 ->
		[234,117];
get_def_num(_SignNum) when _SignNum >= 1880, _SignNum =< 1887 ->
		[235,117];
get_def_num(_SignNum) when _SignNum >= 1888, _SignNum =< 1895 ->
		[236,118];
get_def_num(_SignNum) when _SignNum >= 1896, _SignNum =< 1903 ->
		[237,118];
get_def_num(_SignNum) when _SignNum >= 1904, _SignNum =< 1911 ->
		[238,119];
get_def_num(_SignNum) when _SignNum >= 1912, _SignNum =< 1919 ->
		[239,119];
get_def_num(_SignNum) when _SignNum >= 1920, _SignNum =< 1927 ->
		[240,120];
get_def_num(_SignNum) when _SignNum >= 1928, _SignNum =< 1935 ->
		[241,120];
get_def_num(_SignNum) when _SignNum >= 1936, _SignNum =< 1943 ->
		[242,121];
get_def_num(_SignNum) when _SignNum >= 1944, _SignNum =< 1951 ->
		[243,121];
get_def_num(_SignNum) when _SignNum >= 1952, _SignNum =< 1959 ->
		[244,122];
get_def_num(_SignNum) when _SignNum >= 1960, _SignNum =< 1967 ->
		[245,122];
get_def_num(_SignNum) when _SignNum >= 1968, _SignNum =< 1975 ->
		[246,123];
get_def_num(_SignNum) when _SignNum >= 1976, _SignNum =< 1983 ->
		[247,123];
get_def_num(_SignNum) when _SignNum >= 1984, _SignNum =< 1991 ->
		[248,124];
get_def_num(_SignNum) when _SignNum >= 1992, _SignNum =< 1999 ->
		[249,124];
get_def_num(_SignNum) when _SignNum >= 2000, _SignNum =< 2007 ->
		[250,125];
get_def_num(_SignNum) when _SignNum >= 2008, _SignNum =< 2015 ->
		[251,125];
get_def_num(_SignNum) when _SignNum >= 2016, _SignNum =< 2023 ->
		[252,126];
get_def_num(_SignNum) when _SignNum >= 2024, _SignNum =< 2031 ->
		[253,126];
get_def_num(_SignNum) when _SignNum >= 2032, _SignNum =< 2039 ->
		[254,127];
get_def_num(_SignNum) when _SignNum >= 2040, _SignNum =< 2047 ->
		[255,127];
get_def_num(_SignNum) when _SignNum >= 2048, _SignNum =< 2055 ->
		[256,128];
get_def_num(_SignNum) when _SignNum >= 2056, _SignNum =< 2063 ->
		[257,128];
get_def_num(_SignNum) when _SignNum >= 2064, _SignNum =< 2071 ->
		[258,129];
get_def_num(_SignNum) when _SignNum >= 2072, _SignNum =< 2079 ->
		[259,129];
get_def_num(_SignNum) when _SignNum >= 2080, _SignNum =< 2087 ->
		[260,130];
get_def_num(_SignNum) when _SignNum >= 2088, _SignNum =< 2095 ->
		[261,130];
get_def_num(_SignNum) when _SignNum >= 2096, _SignNum =< 2103 ->
		[262,131];
get_def_num(_SignNum) when _SignNum >= 2104, _SignNum =< 2111 ->
		[263,131];
get_def_num(_SignNum) when _SignNum >= 2112, _SignNum =< 2119 ->
		[264,132];
get_def_num(_SignNum) when _SignNum >= 2120, _SignNum =< 2127 ->
		[265,132];
get_def_num(_SignNum) when _SignNum >= 2128, _SignNum =< 2135 ->
		[266,133];
get_def_num(_SignNum) when _SignNum >= 2136, _SignNum =< 2143 ->
		[267,133];
get_def_num(_SignNum) when _SignNum >= 2144, _SignNum =< 2151 ->
		[268,134];
get_def_num(_SignNum) when _SignNum >= 2152, _SignNum =< 2159 ->
		[269,134];
get_def_num(_SignNum) when _SignNum >= 2160, _SignNum =< 2167 ->
		[270,135];
get_def_num(_SignNum) when _SignNum >= 2168, _SignNum =< 2175 ->
		[271,135];
get_def_num(_SignNum) when _SignNum >= 2176, _SignNum =< 2183 ->
		[272,136];
get_def_num(_SignNum) when _SignNum >= 2184, _SignNum =< 2191 ->
		[273,136];
get_def_num(_SignNum) when _SignNum >= 2192, _SignNum =< 2199 ->
		[274,137];
get_def_num(_SignNum) when _SignNum >= 2200, _SignNum =< 2207 ->
		[275,137];
get_def_num(_SignNum) when _SignNum >= 2208, _SignNum =< 2215 ->
		[276,138];
get_def_num(_SignNum) when _SignNum >= 2216, _SignNum =< 2223 ->
		[277,138];
get_def_num(_SignNum) when _SignNum >= 2224, _SignNum =< 2231 ->
		[278,139];
get_def_num(_SignNum) when _SignNum >= 2232, _SignNum =< 2239 ->
		[279,139];
get_def_num(_SignNum) when _SignNum >= 2240, _SignNum =< 2247 ->
		[280,140];
get_def_num(_SignNum) when _SignNum >= 2248, _SignNum =< 2255 ->
		[281,140];
get_def_num(_SignNum) when _SignNum >= 2256, _SignNum =< 2263 ->
		[282,141];
get_def_num(_SignNum) when _SignNum >= 2264, _SignNum =< 2271 ->
		[283,141];
get_def_num(_SignNum) when _SignNum >= 2272, _SignNum =< 2279 ->
		[284,142];
get_def_num(_SignNum) when _SignNum >= 2280, _SignNum =< 2287 ->
		[285,142];
get_def_num(_SignNum) when _SignNum >= 2288, _SignNum =< 2295 ->
		[286,143];
get_def_num(_SignNum) when _SignNum >= 2296, _SignNum =< 2303 ->
		[287,143];
get_def_num(_SignNum) when _SignNum >= 2304, _SignNum =< 2311 ->
		[288,144];
get_def_num(_SignNum) when _SignNum >= 2312, _SignNum =< 2319 ->
		[289,144];
get_def_num(_SignNum) when _SignNum >= 2320, _SignNum =< 2327 ->
		[290,145];
get_def_num(_SignNum) when _SignNum >= 2328, _SignNum =< 2335 ->
		[291,145];
get_def_num(_SignNum) when _SignNum >= 2336, _SignNum =< 2343 ->
		[292,146];
get_def_num(_SignNum) when _SignNum >= 2344, _SignNum =< 2351 ->
		[293,146];
get_def_num(_SignNum) when _SignNum >= 2352, _SignNum =< 2359 ->
		[294,147];
get_def_num(_SignNum) when _SignNum >= 2360, _SignNum =< 2367 ->
		[295,147];
get_def_num(_SignNum) when _SignNum >= 2368, _SignNum =< 2375 ->
		[296,148];
get_def_num(_SignNum) when _SignNum >= 2376, _SignNum =< 2383 ->
		[297,148];
get_def_num(_SignNum) when _SignNum >= 2384, _SignNum =< 2391 ->
		[298,149];
get_def_num(_SignNum) when _SignNum >= 2392, _SignNum =< 2399 ->
		[299,149];
get_def_num(_SignNum) when _SignNum >= 2400, _SignNum =< 2407 ->
		[300,150];
get_def_num(_SignNum) when _SignNum >= 2408, _SignNum =< 2415 ->
		[301,150];
get_def_num(_SignNum) when _SignNum >= 2416, _SignNum =< 2423 ->
		[302,151];
get_def_num(_SignNum) when _SignNum >= 2424, _SignNum =< 2431 ->
		[303,151];
get_def_num(_SignNum) when _SignNum >= 2432, _SignNum =< 2439 ->
		[304,152];
get_def_num(_SignNum) when _SignNum >= 2440, _SignNum =< 2447 ->
		[305,152];
get_def_num(_SignNum) when _SignNum >= 2448, _SignNum =< 2455 ->
		[306,153];
get_def_num(_SignNum) when _SignNum >= 2456, _SignNum =< 2463 ->
		[307,153];
get_def_num(_SignNum) when _SignNum >= 2464, _SignNum =< 2471 ->
		[308,154];
get_def_num(_SignNum) when _SignNum >= 2472, _SignNum =< 2479 ->
		[309,154];
get_def_num(_SignNum) when _SignNum >= 2480, _SignNum =< 2487 ->
		[310,155];
get_def_num(_SignNum) when _SignNum >= 2488, _SignNum =< 2495 ->
		[311,155];
get_def_num(_SignNum) when _SignNum >= 2496, _SignNum =< 2503 ->
		[312,156];
get_def_num(_SignNum) when _SignNum >= 2504, _SignNum =< 2511 ->
		[313,156];
get_def_num(_SignNum) when _SignNum >= 2512, _SignNum =< 2519 ->
		[314,157];
get_def_num(_SignNum) when _SignNum >= 2520, _SignNum =< 2527 ->
		[315,157];
get_def_num(_SignNum) when _SignNum >= 2528, _SignNum =< 2535 ->
		[316,158];
get_def_num(_SignNum) when _SignNum >= 2536, _SignNum =< 2543 ->
		[317,158];
get_def_num(_SignNum) when _SignNum >= 2544, _SignNum =< 2551 ->
		[318,159];
get_def_num(_SignNum) when _SignNum >= 2552, _SignNum =< 2559 ->
		[319,159];
get_def_num(_SignNum) when _SignNum >= 2560, _SignNum =< 2567 ->
		[320,160];
get_def_num(_SignNum) when _SignNum >= 2568, _SignNum =< 2575 ->
		[321,160];
get_def_num(_SignNum) when _SignNum >= 2576, _SignNum =< 2583 ->
		[322,161];
get_def_num(_SignNum) when _SignNum >= 2584, _SignNum =< 2591 ->
		[323,161];
get_def_num(_SignNum) when _SignNum >= 2592, _SignNum =< 2599 ->
		[324,162];
get_def_num(_SignNum) when _SignNum >= 2600, _SignNum =< 2607 ->
		[325,162];
get_def_num(_SignNum) when _SignNum >= 2608, _SignNum =< 2615 ->
		[326,163];
get_def_num(_SignNum) when _SignNum >= 2616, _SignNum =< 2623 ->
		[327,163];
get_def_num(_SignNum) when _SignNum >= 2624, _SignNum =< 2631 ->
		[328,164];
get_def_num(_SignNum) when _SignNum >= 2632, _SignNum =< 2639 ->
		[329,164];
get_def_num(_SignNum) when _SignNum >= 2640, _SignNum =< 2647 ->
		[330,165];
get_def_num(_SignNum) when _SignNum >= 2648, _SignNum =< 2655 ->
		[331,165];
get_def_num(_SignNum) when _SignNum >= 2656, _SignNum =< 2663 ->
		[332,166];
get_def_num(_SignNum) when _SignNum >= 2664, _SignNum =< 2671 ->
		[333,166];
get_def_num(_SignNum) when _SignNum >= 2672, _SignNum =< 2679 ->
		[334,167];
get_def_num(_SignNum) when _SignNum >= 2680, _SignNum =< 2687 ->
		[335,167];
get_def_num(_SignNum) when _SignNum >= 2688, _SignNum =< 2695 ->
		[336,168];
get_def_num(_SignNum) when _SignNum >= 2696, _SignNum =< 2703 ->
		[337,168];
get_def_num(_SignNum) when _SignNum >= 2704, _SignNum =< 2711 ->
		[338,169];
get_def_num(_SignNum) when _SignNum >= 2712, _SignNum =< 2719 ->
		[339,169];
get_def_num(_SignNum) when _SignNum >= 2720, _SignNum =< 2727 ->
		[340,170];
get_def_num(_SignNum) when _SignNum >= 2728, _SignNum =< 2735 ->
		[341,170];
get_def_num(_SignNum) when _SignNum >= 2736, _SignNum =< 2743 ->
		[342,171];
get_def_num(_SignNum) when _SignNum >= 2744, _SignNum =< 2751 ->
		[343,171];
get_def_num(_SignNum) when _SignNum >= 2752, _SignNum =< 2759 ->
		[344,172];
get_def_num(_SignNum) when _SignNum >= 2760, _SignNum =< 2767 ->
		[345,172];
get_def_num(_SignNum) when _SignNum >= 2768, _SignNum =< 2775 ->
		[346,173];
get_def_num(_SignNum) when _SignNum >= 2776, _SignNum =< 2783 ->
		[347,173];
get_def_num(_SignNum) when _SignNum >= 2784, _SignNum =< 2791 ->
		[348,174];
get_def_num(_SignNum) when _SignNum >= 2792, _SignNum =< 2799 ->
		[349,174];
get_def_num(_SignNum) when _SignNum >= 2800, _SignNum =< 2807 ->
		[350,175];
get_def_num(_SignNum) when _SignNum >= 2808, _SignNum =< 2815 ->
		[351,175];
get_def_num(_SignNum) when _SignNum >= 2816, _SignNum =< 2823 ->
		[352,176];
get_def_num(_SignNum) when _SignNum >= 2824, _SignNum =< 2831 ->
		[353,176];
get_def_num(_SignNum) when _SignNum >= 2832, _SignNum =< 2839 ->
		[354,177];
get_def_num(_SignNum) when _SignNum >= 2840, _SignNum =< 2847 ->
		[355,177];
get_def_num(_SignNum) when _SignNum >= 2848, _SignNum =< 2855 ->
		[356,178];
get_def_num(_SignNum) when _SignNum >= 2856, _SignNum =< 2863 ->
		[357,178];
get_def_num(_SignNum) when _SignNum >= 2864, _SignNum =< 2871 ->
		[358,179];
get_def_num(_SignNum) when _SignNum >= 2872, _SignNum =< 2879 ->
		[359,179];
get_def_num(_SignNum) when _SignNum >= 2880, _SignNum =< 2887 ->
		[360,180];
get_def_num(_SignNum) when _SignNum >= 2888, _SignNum =< 2895 ->
		[361,180];
get_def_num(_SignNum) when _SignNum >= 2896, _SignNum =< 2903 ->
		[362,181];
get_def_num(_SignNum) when _SignNum >= 2904, _SignNum =< 2911 ->
		[363,181];
get_def_num(_SignNum) when _SignNum >= 2912, _SignNum =< 2919 ->
		[364,182];
get_def_num(_SignNum) when _SignNum >= 2920, _SignNum =< 2927 ->
		[365,182];
get_def_num(_SignNum) when _SignNum >= 2928, _SignNum =< 2935 ->
		[366,183];
get_def_num(_SignNum) when _SignNum >= 2936, _SignNum =< 2943 ->
		[367,183];
get_def_num(_SignNum) when _SignNum >= 2944, _SignNum =< 2951 ->
		[368,184];
get_def_num(_SignNum) when _SignNum >= 2952, _SignNum =< 2959 ->
		[369,184];
get_def_num(_SignNum) when _SignNum >= 2960, _SignNum =< 2967 ->
		[370,185];
get_def_num(_SignNum) when _SignNum >= 2968, _SignNum =< 2975 ->
		[371,185];
get_def_num(_SignNum) when _SignNum >= 2976, _SignNum =< 2983 ->
		[372,186];
get_def_num(_SignNum) when _SignNum >= 2984, _SignNum =< 2991 ->
		[373,186];
get_def_num(_SignNum) when _SignNum >= 2992, _SignNum =< 2999 ->
		[374,187];
get_def_num(_SignNum) when _SignNum >= 3000, _SignNum =< 3007 ->
		[375,187];
get_def_num(_SignNum) when _SignNum >= 3008, _SignNum =< 3015 ->
		[376,188];
get_def_num(_SignNum) when _SignNum >= 3016, _SignNum =< 3023 ->
		[377,188];
get_def_num(_SignNum) when _SignNum >= 3024, _SignNum =< 3031 ->
		[378,189];
get_def_num(_SignNum) when _SignNum >= 3032, _SignNum =< 3039 ->
		[379,189];
get_def_num(_SignNum) when _SignNum >= 3040, _SignNum =< 3047 ->
		[380,190];
get_def_num(_SignNum) when _SignNum >= 3048, _SignNum =< 3055 ->
		[381,190];
get_def_num(_SignNum) when _SignNum >= 3056, _SignNum =< 3063 ->
		[382,191];
get_def_num(_SignNum) when _SignNum >= 3064, _SignNum =< 3071 ->
		[383,191];
get_def_num(_SignNum) when _SignNum >= 3072, _SignNum =< 3079 ->
		[384,192];
get_def_num(_SignNum) when _SignNum >= 3080, _SignNum =< 3087 ->
		[385,192];
get_def_num(_SignNum) when _SignNum >= 3088, _SignNum =< 3095 ->
		[386,193];
get_def_num(_SignNum) when _SignNum >= 3096, _SignNum =< 3103 ->
		[387,193];
get_def_num(_SignNum) when _SignNum >= 3104, _SignNum =< 3111 ->
		[388,194];
get_def_num(_SignNum) when _SignNum >= 3112, _SignNum =< 3119 ->
		[389,194];
get_def_num(_SignNum) when _SignNum >= 3120, _SignNum =< 3127 ->
		[390,195];
get_def_num(_SignNum) when _SignNum >= 3128, _SignNum =< 3135 ->
		[391,195];
get_def_num(_SignNum) when _SignNum >= 3136, _SignNum =< 3143 ->
		[392,196];
get_def_num(_SignNum) when _SignNum >= 3144, _SignNum =< 3151 ->
		[393,196];
get_def_num(_SignNum) when _SignNum >= 3152, _SignNum =< 3159 ->
		[394,197];
get_def_num(_SignNum) when _SignNum >= 3160, _SignNum =< 3167 ->
		[395,197];
get_def_num(_SignNum) when _SignNum >= 3168, _SignNum =< 3175 ->
		[396,198];
get_def_num(_SignNum) when _SignNum >= 3176, _SignNum =< 3183 ->
		[397,198];
get_def_num(_SignNum) when _SignNum >= 3184, _SignNum =< 3191 ->
		[398,199];
get_def_num(_SignNum) when _SignNum >= 3192, _SignNum =< 3199 ->
		[399,199];
get_def_num(_SignNum) when _SignNum >= 3200, _SignNum =< 3207 ->
		[400,200];
get_def_num(_SignNum) when _SignNum >= 3208, _SignNum =< 3215 ->
		[401,200];
get_def_num(_SignNum) when _SignNum >= 3216, _SignNum =< 3223 ->
		[402,201];
get_def_num(_SignNum) when _SignNum >= 3224, _SignNum =< 3231 ->
		[403,201];
get_def_num(_SignNum) when _SignNum >= 3232, _SignNum =< 3239 ->
		[404,202];
get_def_num(_SignNum) when _SignNum >= 3240, _SignNum =< 3247 ->
		[405,202];
get_def_num(_SignNum) when _SignNum >= 3248, _SignNum =< 3255 ->
		[406,203];
get_def_num(_SignNum) when _SignNum >= 3256, _SignNum =< 3263 ->
		[407,203];
get_def_num(_SignNum) when _SignNum >= 3264, _SignNum =< 3271 ->
		[408,204];
get_def_num(_SignNum) when _SignNum >= 3272, _SignNum =< 3279 ->
		[409,204];
get_def_num(_SignNum) when _SignNum >= 3280, _SignNum =< 3287 ->
		[410,205];
get_def_num(_SignNum) when _SignNum >= 3288, _SignNum =< 3295 ->
		[411,205];
get_def_num(_SignNum) when _SignNum >= 3296, _SignNum =< 3303 ->
		[412,206];
get_def_num(_SignNum) when _SignNum >= 3304, _SignNum =< 3311 ->
		[413,206];
get_def_num(_SignNum) when _SignNum >= 3312, _SignNum =< 3319 ->
		[414,207];
get_def_num(_SignNum) when _SignNum >= 3320, _SignNum =< 3327 ->
		[415,207];
get_def_num(_SignNum) when _SignNum >= 3328, _SignNum =< 3335 ->
		[416,208];
get_def_num(_SignNum) when _SignNum >= 3336, _SignNum =< 3343 ->
		[417,208];
get_def_num(_SignNum) when _SignNum >= 3344, _SignNum =< 3351 ->
		[418,209];
get_def_num(_SignNum) when _SignNum >= 3352, _SignNum =< 3359 ->
		[419,209];
get_def_num(_SignNum) when _SignNum >= 3360, _SignNum =< 3367 ->
		[420,210];
get_def_num(_SignNum) when _SignNum >= 3368, _SignNum =< 3375 ->
		[421,210];
get_def_num(_SignNum) when _SignNum >= 3376, _SignNum =< 3383 ->
		[422,211];
get_def_num(_SignNum) when _SignNum >= 3384, _SignNum =< 3391 ->
		[423,211];
get_def_num(_SignNum) when _SignNum >= 3392, _SignNum =< 3399 ->
		[424,212];
get_def_num(_SignNum) when _SignNum >= 3400, _SignNum =< 3407 ->
		[425,212];
get_def_num(_SignNum) when _SignNum >= 3408, _SignNum =< 3415 ->
		[426,213];
get_def_num(_SignNum) when _SignNum >= 3416, _SignNum =< 3423 ->
		[427,213];
get_def_num(_SignNum) when _SignNum >= 3424, _SignNum =< 3431 ->
		[428,214];
get_def_num(_SignNum) when _SignNum >= 3432, _SignNum =< 3439 ->
		[429,214];
get_def_num(_SignNum) when _SignNum >= 3440, _SignNum =< 3447 ->
		[430,215];
get_def_num(_SignNum) when _SignNum >= 3448, _SignNum =< 3455 ->
		[431,215];
get_def_num(_SignNum) when _SignNum >= 3456, _SignNum =< 3463 ->
		[432,216];
get_def_num(_SignNum) when _SignNum >= 3464, _SignNum =< 3471 ->
		[433,216];
get_def_num(_SignNum) when _SignNum >= 3472, _SignNum =< 3479 ->
		[434,217];
get_def_num(_SignNum) when _SignNum >= 3480, _SignNum =< 3487 ->
		[435,217];
get_def_num(_SignNum) when _SignNum >= 3488, _SignNum =< 3495 ->
		[436,218];
get_def_num(_SignNum) when _SignNum >= 3496, _SignNum =< 3503 ->
		[437,218];
get_def_num(_SignNum) when _SignNum >= 3504, _SignNum =< 3511 ->
		[438,219];
get_def_num(_SignNum) when _SignNum >= 3512, _SignNum =< 3519 ->
		[439,219];
get_def_num(_SignNum) when _SignNum >= 3520, _SignNum =< 3527 ->
		[440,220];
get_def_num(_SignNum) when _SignNum >= 3528, _SignNum =< 3535 ->
		[441,220];
get_def_num(_SignNum) when _SignNum >= 3536, _SignNum =< 3543 ->
		[442,221];
get_def_num(_SignNum) when _SignNum >= 3544, _SignNum =< 3551 ->
		[443,221];
get_def_num(_SignNum) when _SignNum >= 3552, _SignNum =< 3559 ->
		[444,222];
get_def_num(_SignNum) when _SignNum >= 3560, _SignNum =< 3567 ->
		[445,222];
get_def_num(_SignNum) when _SignNum >= 3568, _SignNum =< 3575 ->
		[446,223];
get_def_num(_SignNum) when _SignNum >= 3576, _SignNum =< 3583 ->
		[447,223];
get_def_num(_SignNum) when _SignNum >= 3584, _SignNum =< 3591 ->
		[448,224];
get_def_num(_SignNum) when _SignNum >= 3592, _SignNum =< 3599 ->
		[449,224];
get_def_num(_SignNum) when _SignNum >= 3600, _SignNum =< 3607 ->
		[450,225];
get_def_num(_SignNum) when _SignNum >= 3608, _SignNum =< 3615 ->
		[451,225];
get_def_num(_SignNum) when _SignNum >= 3616, _SignNum =< 3623 ->
		[452,226];
get_def_num(_SignNum) when _SignNum >= 3624, _SignNum =< 3631 ->
		[453,226];
get_def_num(_SignNum) when _SignNum >= 3632, _SignNum =< 3639 ->
		[454,227];
get_def_num(_SignNum) when _SignNum >= 3640, _SignNum =< 3647 ->
		[455,227];
get_def_num(_SignNum) when _SignNum >= 3648, _SignNum =< 3655 ->
		[456,228];
get_def_num(_SignNum) when _SignNum >= 3656, _SignNum =< 3663 ->
		[457,228];
get_def_num(_SignNum) when _SignNum >= 3664, _SignNum =< 3671 ->
		[458,229];
get_def_num(_SignNum) when _SignNum >= 3672, _SignNum =< 3679 ->
		[459,229];
get_def_num(_SignNum) when _SignNum >= 3680, _SignNum =< 3687 ->
		[460,230];
get_def_num(_SignNum) when _SignNum >= 3688, _SignNum =< 3695 ->
		[461,230];
get_def_num(_SignNum) when _SignNum >= 3696, _SignNum =< 3703 ->
		[462,231];
get_def_num(_SignNum) when _SignNum >= 3704, _SignNum =< 3711 ->
		[463,231];
get_def_num(_SignNum) when _SignNum >= 3712, _SignNum =< 3719 ->
		[464,232];
get_def_num(_SignNum) when _SignNum >= 3720, _SignNum =< 3727 ->
		[465,232];
get_def_num(_SignNum) when _SignNum >= 3728, _SignNum =< 3735 ->
		[466,233];
get_def_num(_SignNum) when _SignNum >= 3736, _SignNum =< 3743 ->
		[467,233];
get_def_num(_SignNum) when _SignNum >= 3744, _SignNum =< 3751 ->
		[468,234];
get_def_num(_SignNum) when _SignNum >= 3752, _SignNum =< 3759 ->
		[469,234];
get_def_num(_SignNum) when _SignNum >= 3760, _SignNum =< 3767 ->
		[470,235];
get_def_num(_SignNum) when _SignNum >= 3768, _SignNum =< 3775 ->
		[471,235];
get_def_num(_SignNum) when _SignNum >= 3776, _SignNum =< 3783 ->
		[472,236];
get_def_num(_SignNum) when _SignNum >= 3784, _SignNum =< 3791 ->
		[473,236];
get_def_num(_SignNum) when _SignNum >= 3792, _SignNum =< 3799 ->
		[474,237];
get_def_num(_SignNum) when _SignNum >= 3800, _SignNum =< 3807 ->
		[475,237];
get_def_num(_SignNum) when _SignNum >= 3808, _SignNum =< 3815 ->
		[476,238];
get_def_num(_SignNum) when _SignNum >= 3816, _SignNum =< 3823 ->
		[477,238];
get_def_num(_SignNum) when _SignNum >= 3824, _SignNum =< 3831 ->
		[478,239];
get_def_num(_SignNum) when _SignNum >= 3832, _SignNum =< 3839 ->
		[479,239];
get_def_num(_SignNum) when _SignNum >= 3840, _SignNum =< 3847 ->
		[480,240];
get_def_num(_SignNum) when _SignNum >= 3848, _SignNum =< 3855 ->
		[481,240];
get_def_num(_SignNum) when _SignNum >= 3856, _SignNum =< 3863 ->
		[482,241];
get_def_num(_SignNum) when _SignNum >= 3864, _SignNum =< 3871 ->
		[483,241];
get_def_num(_SignNum) when _SignNum >= 3872, _SignNum =< 3879 ->
		[484,242];
get_def_num(_SignNum) when _SignNum >= 3880, _SignNum =< 3887 ->
		[485,242];
get_def_num(_SignNum) when _SignNum >= 3888, _SignNum =< 3895 ->
		[486,243];
get_def_num(_SignNum) when _SignNum >= 3896, _SignNum =< 3903 ->
		[487,243];
get_def_num(_SignNum) when _SignNum >= 3904, _SignNum =< 3911 ->
		[488,244];
get_def_num(_SignNum) when _SignNum >= 3912, _SignNum =< 3919 ->
		[489,244];
get_def_num(_SignNum) when _SignNum >= 3920, _SignNum =< 3927 ->
		[490,245];
get_def_num(_SignNum) when _SignNum >= 3928, _SignNum =< 3935 ->
		[491,245];
get_def_num(_SignNum) when _SignNum >= 3936, _SignNum =< 3943 ->
		[492,246];
get_def_num(_SignNum) when _SignNum >= 3944, _SignNum =< 3951 ->
		[493,246];
get_def_num(_SignNum) when _SignNum >= 3952, _SignNum =< 3959 ->
		[494,247];
get_def_num(_SignNum) when _SignNum >= 3960, _SignNum =< 3967 ->
		[495,247];
get_def_num(_SignNum) when _SignNum >= 3968, _SignNum =< 3975 ->
		[496,248];
get_def_num(_SignNum) when _SignNum >= 3976, _SignNum =< 3983 ->
		[497,248];
get_def_num(_SignNum) when _SignNum >= 3984, _SignNum =< 3991 ->
		[498,249];
get_def_num(_SignNum) when _SignNum >= 3992, _SignNum =< 3999 ->
		[499,249];
get_def_num(_SignNum) when _SignNum >= 4000, _SignNum =< 4007 ->
		[500,250];
get_def_num(_SignNum) when _SignNum >= 4008, _SignNum =< 4015 ->
		[501,250];
get_def_num(_SignNum) when _SignNum >= 4016, _SignNum =< 4023 ->
		[502,251];
get_def_num(_SignNum) when _SignNum >= 4024, _SignNum =< 4031 ->
		[503,251];
get_def_num(_SignNum) when _SignNum >= 4032, _SignNum =< 4039 ->
		[504,252];
get_def_num(_SignNum) when _SignNum >= 4040, _SignNum =< 4047 ->
		[505,252];
get_def_num(_SignNum) when _SignNum >= 4048, _SignNum =< 4055 ->
		[506,253];
get_def_num(_SignNum) when _SignNum >= 4056, _SignNum =< 4063 ->
		[507,253];
get_def_num(_SignNum) when _SignNum >= 4064, _SignNum =< 4071 ->
		[508,254];
get_def_num(_SignNum) when _SignNum >= 4072, _SignNum =< 4079 ->
		[509,254];
get_def_num(_SignNum) when _SignNum >= 4080, _SignNum =< 4087 ->
		[510,255];
get_def_num(_SignNum) when _SignNum >= 4088, _SignNum =< 4095 ->
		[511,255];
get_def_num(_SignNum) when _SignNum >= 4096, _SignNum =< 4103 ->
		[512,256];
get_def_num(_SignNum) when _SignNum >= 4104, _SignNum =< 4111 ->
		[513,256];
get_def_num(_SignNum) when _SignNum >= 4112, _SignNum =< 4119 ->
		[514,257];
get_def_num(_SignNum) when _SignNum >= 4120, _SignNum =< 4127 ->
		[515,257];
get_def_num(_SignNum) when _SignNum >= 4128, _SignNum =< 4135 ->
		[516,258];
get_def_num(_SignNum) when _SignNum >= 4136, _SignNum =< 4143 ->
		[517,258];
get_def_num(_SignNum) when _SignNum >= 4144, _SignNum =< 4151 ->
		[518,259];
get_def_num(_SignNum) when _SignNum >= 4152, _SignNum =< 4159 ->
		[519,259];
get_def_num(_SignNum) when _SignNum >= 4160, _SignNum =< 4167 ->
		[520,260];
get_def_num(_SignNum) when _SignNum >= 4168, _SignNum =< 4175 ->
		[521,260];
get_def_num(_SignNum) when _SignNum >= 4176, _SignNum =< 4183 ->
		[522,261];
get_def_num(_SignNum) when _SignNum >= 4184, _SignNum =< 4191 ->
		[523,261];
get_def_num(_SignNum) when _SignNum >= 4192, _SignNum =< 4199 ->
		[524,262];
get_def_num(_SignNum) when _SignNum >= 4200, _SignNum =< 4207 ->
		[525,262];
get_def_num(_SignNum) when _SignNum >= 4208, _SignNum =< 4215 ->
		[526,263];
get_def_num(_SignNum) when _SignNum >= 4216, _SignNum =< 4223 ->
		[527,263];
get_def_num(_SignNum) when _SignNum >= 4224, _SignNum =< 4231 ->
		[528,264];
get_def_num(_SignNum) when _SignNum >= 4232, _SignNum =< 4239 ->
		[529,264];
get_def_num(_SignNum) when _SignNum >= 4240, _SignNum =< 4247 ->
		[530,265];
get_def_num(_SignNum) when _SignNum >= 4248, _SignNum =< 4255 ->
		[531,265];
get_def_num(_SignNum) when _SignNum >= 4256, _SignNum =< 4263 ->
		[532,266];
get_def_num(_SignNum) when _SignNum >= 4264, _SignNum =< 4271 ->
		[533,266];
get_def_num(_SignNum) when _SignNum >= 4272, _SignNum =< 4279 ->
		[534,267];
get_def_num(_SignNum) when _SignNum >= 4280, _SignNum =< 4287 ->
		[535,267];
get_def_num(_SignNum) when _SignNum >= 4288, _SignNum =< 4295 ->
		[536,268];
get_def_num(_SignNum) when _SignNum >= 4296, _SignNum =< 4303 ->
		[537,268];
get_def_num(_SignNum) when _SignNum >= 4304, _SignNum =< 4311 ->
		[538,269];
get_def_num(_SignNum) when _SignNum >= 4312, _SignNum =< 4319 ->
		[539,269];
get_def_num(_SignNum) when _SignNum >= 4320, _SignNum =< 4327 ->
		[540,270];
get_def_num(_SignNum) when _SignNum >= 4328, _SignNum =< 4335 ->
		[541,270];
get_def_num(_SignNum) when _SignNum >= 4336, _SignNum =< 4343 ->
		[542,271];
get_def_num(_SignNum) when _SignNum >= 4344, _SignNum =< 4351 ->
		[543,271];
get_def_num(_SignNum) when _SignNum >= 4352, _SignNum =< 4359 ->
		[544,272];
get_def_num(_SignNum) when _SignNum >= 4360, _SignNum =< 4367 ->
		[545,272];
get_def_num(_SignNum) when _SignNum >= 4368, _SignNum =< 4375 ->
		[546,273];
get_def_num(_SignNum) when _SignNum >= 4376, _SignNum =< 4383 ->
		[547,273];
get_def_num(_SignNum) when _SignNum >= 4384, _SignNum =< 4391 ->
		[548,274];
get_def_num(_SignNum) when _SignNum >= 4392, _SignNum =< 4399 ->
		[549,274];
get_def_num(_SignNum) when _SignNum >= 4400, _SignNum =< 4407 ->
		[550,275];
get_def_num(_SignNum) when _SignNum >= 4408, _SignNum =< 4415 ->
		[551,275];
get_def_num(_SignNum) when _SignNum >= 4416, _SignNum =< 4423 ->
		[552,276];
get_def_num(_SignNum) when _SignNum >= 4424, _SignNum =< 4431 ->
		[553,276];
get_def_num(_SignNum) when _SignNum >= 4432, _SignNum =< 4439 ->
		[554,277];
get_def_num(_SignNum) when _SignNum >= 4440, _SignNum =< 4447 ->
		[555,277];
get_def_num(_SignNum) when _SignNum >= 4448, _SignNum =< 4455 ->
		[556,278];
get_def_num(_SignNum) when _SignNum >= 4456, _SignNum =< 4463 ->
		[557,278];
get_def_num(_SignNum) when _SignNum >= 4464, _SignNum =< 4471 ->
		[558,279];
get_def_num(_SignNum) when _SignNum >= 4472, _SignNum =< 4479 ->
		[559,279];
get_def_num(_SignNum) when _SignNum >= 4480, _SignNum =< 4487 ->
		[560,280];
get_def_num(_SignNum) when _SignNum >= 4488, _SignNum =< 4495 ->
		[561,280];
get_def_num(_SignNum) when _SignNum >= 4496, _SignNum =< 4503 ->
		[562,281];
get_def_num(_SignNum) when _SignNum >= 4504, _SignNum =< 4511 ->
		[563,281];
get_def_num(_SignNum) when _SignNum >= 4512, _SignNum =< 4519 ->
		[564,282];
get_def_num(_SignNum) when _SignNum >= 4520, _SignNum =< 4527 ->
		[565,282];
get_def_num(_SignNum) when _SignNum >= 4528, _SignNum =< 4535 ->
		[566,283];
get_def_num(_SignNum) when _SignNum >= 4536, _SignNum =< 4543 ->
		[567,283];
get_def_num(_SignNum) when _SignNum >= 4544, _SignNum =< 4551 ->
		[568,284];
get_def_num(_SignNum) when _SignNum >= 4552, _SignNum =< 4559 ->
		[569,284];
get_def_num(_SignNum) when _SignNum >= 4560, _SignNum =< 4567 ->
		[570,285];
get_def_num(_SignNum) when _SignNum >= 4568, _SignNum =< 4575 ->
		[571,285];
get_def_num(_SignNum) when _SignNum >= 4576, _SignNum =< 4583 ->
		[572,286];
get_def_num(_SignNum) when _SignNum >= 4584, _SignNum =< 4591 ->
		[573,286];
get_def_num(_SignNum) when _SignNum >= 4592, _SignNum =< 4599 ->
		[574,287];
get_def_num(_SignNum) when _SignNum >= 4600, _SignNum =< 4607 ->
		[575,287];
get_def_num(_SignNum) when _SignNum >= 4608, _SignNum =< 4615 ->
		[576,288];
get_def_num(_SignNum) when _SignNum >= 4616, _SignNum =< 4623 ->
		[577,288];
get_def_num(_SignNum) when _SignNum >= 4624, _SignNum =< 4631 ->
		[578,289];
get_def_num(_SignNum) when _SignNum >= 4632, _SignNum =< 4639 ->
		[579,289];
get_def_num(_SignNum) when _SignNum >= 4640, _SignNum =< 4647 ->
		[580,290];
get_def_num(_SignNum) when _SignNum >= 4648, _SignNum =< 4655 ->
		[581,290];
get_def_num(_SignNum) when _SignNum >= 4656, _SignNum =< 4663 ->
		[582,291];
get_def_num(_SignNum) when _SignNum >= 4664, _SignNum =< 4671 ->
		[583,291];
get_def_num(_SignNum) when _SignNum >= 4672, _SignNum =< 4679 ->
		[584,292];
get_def_num(_SignNum) when _SignNum >= 4680, _SignNum =< 4687 ->
		[585,292];
get_def_num(_SignNum) when _SignNum >= 4688, _SignNum =< 4695 ->
		[586,293];
get_def_num(_SignNum) when _SignNum >= 4696, _SignNum =< 4703 ->
		[587,293];
get_def_num(_SignNum) when _SignNum >= 4704, _SignNum =< 4711 ->
		[588,294];
get_def_num(_SignNum) when _SignNum >= 4712, _SignNum =< 4719 ->
		[589,294];
get_def_num(_SignNum) when _SignNum >= 4720, _SignNum =< 4727 ->
		[590,295];
get_def_num(_SignNum) when _SignNum >= 4728, _SignNum =< 4735 ->
		[591,295];
get_def_num(_SignNum) when _SignNum >= 4736, _SignNum =< 4743 ->
		[592,296];
get_def_num(_SignNum) when _SignNum >= 4744, _SignNum =< 4751 ->
		[593,296];
get_def_num(_SignNum) when _SignNum >= 4752, _SignNum =< 4759 ->
		[594,297];
get_def_num(_SignNum) when _SignNum >= 4760, _SignNum =< 4767 ->
		[595,297];
get_def_num(_SignNum) when _SignNum >= 4768, _SignNum =< 4775 ->
		[596,298];
get_def_num(_SignNum) when _SignNum >= 4776, _SignNum =< 4783 ->
		[597,298];
get_def_num(_SignNum) when _SignNum >= 4784, _SignNum =< 4791 ->
		[598,299];
get_def_num(_SignNum) when _SignNum >= 4792, _SignNum =< 4799 ->
		[599,299];
get_def_num(_SignNum) when _SignNum >= 4800, _SignNum =< 4807 ->
		[600,300];
get_def_num(_SignNum) when _SignNum >= 4808, _SignNum =< 4815 ->
		[601,300];
get_def_num(_SignNum) when _SignNum >= 4816, _SignNum =< 4823 ->
		[602,301];
get_def_num(_SignNum) when _SignNum >= 4824, _SignNum =< 4831 ->
		[603,301];
get_def_num(_SignNum) when _SignNum >= 4832, _SignNum =< 4839 ->
		[604,302];
get_def_num(_SignNum) when _SignNum >= 4840, _SignNum =< 4847 ->
		[605,302];
get_def_num(_SignNum) when _SignNum >= 4848, _SignNum =< 4855 ->
		[606,303];
get_def_num(_SignNum) when _SignNum >= 4856, _SignNum =< 4863 ->
		[607,303];
get_def_num(_SignNum) when _SignNum >= 4864, _SignNum =< 4871 ->
		[608,304];
get_def_num(_SignNum) when _SignNum >= 4872, _SignNum =< 4879 ->
		[609,304];
get_def_num(_SignNum) when _SignNum >= 4880, _SignNum =< 4887 ->
		[610,305];
get_def_num(_SignNum) when _SignNum >= 4888, _SignNum =< 4895 ->
		[611,305];
get_def_num(_SignNum) when _SignNum >= 4896, _SignNum =< 4903 ->
		[612,306];
get_def_num(_SignNum) when _SignNum >= 4904, _SignNum =< 4911 ->
		[613,306];
get_def_num(_SignNum) when _SignNum >= 4912, _SignNum =< 4919 ->
		[614,307];
get_def_num(_SignNum) when _SignNum >= 4920, _SignNum =< 4927 ->
		[615,307];
get_def_num(_SignNum) when _SignNum >= 4928, _SignNum =< 4935 ->
		[616,308];
get_def_num(_SignNum) when _SignNum >= 4936, _SignNum =< 4943 ->
		[617,308];
get_def_num(_SignNum) when _SignNum >= 4944, _SignNum =< 4951 ->
		[618,309];
get_def_num(_SignNum) when _SignNum >= 4952, _SignNum =< 4959 ->
		[619,309];
get_def_num(_SignNum) when _SignNum >= 4960, _SignNum =< 4967 ->
		[620,310];
get_def_num(_SignNum) when _SignNum >= 4968, _SignNum =< 4975 ->
		[621,310];
get_def_num(_SignNum) when _SignNum >= 4976, _SignNum =< 4983 ->
		[622,311];
get_def_num(_SignNum) when _SignNum >= 4984, _SignNum =< 4991 ->
		[623,311];
get_def_num(_SignNum) when _SignNum >= 4992, _SignNum =< 4999 ->
		[624,312];
get_def_num(_SignNum) when _SignNum >= 5000, _SignNum =< 5007 ->
		[625,312];
get_def_num(_SignNum) when _SignNum >= 5008, _SignNum =< 5015 ->
		[626,313];
get_def_num(_SignNum) when _SignNum >= 5016, _SignNum =< 5023 ->
		[627,313];
get_def_num(_SignNum) when _SignNum >= 5024, _SignNum =< 5031 ->
		[628,314];
get_def_num(_SignNum) when _SignNum >= 5032, _SignNum =< 5039 ->
		[629,314];
get_def_num(_SignNum) when _SignNum >= 5040, _SignNum =< 5047 ->
		[630,315];
get_def_num(_SignNum) when _SignNum >= 5048, _SignNum =< 5055 ->
		[631,315];
get_def_num(_SignNum) when _SignNum >= 5056, _SignNum =< 5063 ->
		[632,316];
get_def_num(_SignNum) when _SignNum >= 5064, _SignNum =< 5071 ->
		[633,316];
get_def_num(_SignNum) when _SignNum >= 5072, _SignNum =< 5079 ->
		[634,317];
get_def_num(_SignNum) when _SignNum >= 5080, _SignNum =< 5087 ->
		[635,317];
get_def_num(_SignNum) when _SignNum >= 5088, _SignNum =< 5095 ->
		[636,318];
get_def_num(_SignNum) when _SignNum >= 5096, _SignNum =< 5103 ->
		[637,318];
get_def_num(_SignNum) when _SignNum >= 5104, _SignNum =< 5111 ->
		[638,319];
get_def_num(_SignNum) when _SignNum >= 5112, _SignNum =< 5119 ->
		[639,319];
get_def_num(_SignNum) when _SignNum >= 5120, _SignNum =< 5127 ->
		[640,320];
get_def_num(_SignNum) when _SignNum >= 5128, _SignNum =< 5135 ->
		[641,320];
get_def_num(_SignNum) when _SignNum >= 5136, _SignNum =< 5143 ->
		[642,321];
get_def_num(_SignNum) when _SignNum >= 5144, _SignNum =< 5151 ->
		[643,321];
get_def_num(_SignNum) when _SignNum >= 5152, _SignNum =< 5159 ->
		[644,322];
get_def_num(_SignNum) when _SignNum >= 5160, _SignNum =< 5167 ->
		[645,322];
get_def_num(_SignNum) when _SignNum >= 5168, _SignNum =< 5175 ->
		[646,323];
get_def_num(_SignNum) when _SignNum >= 5176, _SignNum =< 5183 ->
		[647,323];
get_def_num(_SignNum) when _SignNum >= 5184, _SignNum =< 5191 ->
		[648,324];
get_def_num(_SignNum) when _SignNum >= 5192, _SignNum =< 5199 ->
		[649,324];
get_def_num(_SignNum) when _SignNum >= 5200, _SignNum =< 5207 ->
		[650,325];
get_def_num(_SignNum) when _SignNum >= 5208, _SignNum =< 5215 ->
		[651,325];
get_def_num(_SignNum) when _SignNum >= 5216, _SignNum =< 5223 ->
		[652,326];
get_def_num(_SignNum) when _SignNum >= 5224, _SignNum =< 5231 ->
		[653,326];
get_def_num(_SignNum) when _SignNum >= 5232, _SignNum =< 5239 ->
		[654,327];
get_def_num(_SignNum) when _SignNum >= 5240, _SignNum =< 5247 ->
		[655,327];
get_def_num(_SignNum) when _SignNum >= 5248, _SignNum =< 5255 ->
		[656,328];
get_def_num(_SignNum) when _SignNum >= 5256, _SignNum =< 5263 ->
		[657,328];
get_def_num(_SignNum) when _SignNum >= 5264, _SignNum =< 5271 ->
		[658,329];
get_def_num(_SignNum) when _SignNum >= 5272, _SignNum =< 5279 ->
		[659,329];
get_def_num(_SignNum) when _SignNum >= 5280, _SignNum =< 5287 ->
		[660,330];
get_def_num(_SignNum) when _SignNum >= 5288, _SignNum =< 5295 ->
		[661,330];
get_def_num(_SignNum) when _SignNum >= 5296, _SignNum =< 5303 ->
		[662,331];
get_def_num(_SignNum) when _SignNum >= 5304, _SignNum =< 5311 ->
		[663,331];
get_def_num(_SignNum) when _SignNum >= 5312, _SignNum =< 5319 ->
		[664,332];
get_def_num(_SignNum) when _SignNum >= 5320, _SignNum =< 5327 ->
		[665,332];
get_def_num(_SignNum) when _SignNum >= 5328, _SignNum =< 5335 ->
		[666,333];
get_def_num(_SignNum) when _SignNum >= 5336, _SignNum =< 5343 ->
		[667,333];
get_def_num(_SignNum) when _SignNum >= 5344, _SignNum =< 5351 ->
		[668,334];
get_def_num(_SignNum) when _SignNum >= 5352, _SignNum =< 5359 ->
		[669,334];
get_def_num(_SignNum) when _SignNum >= 5360, _SignNum =< 5367 ->
		[670,335];
get_def_num(_SignNum) when _SignNum >= 5368, _SignNum =< 5375 ->
		[671,335];
get_def_num(_SignNum) when _SignNum >= 5376, _SignNum =< 5383 ->
		[672,336];
get_def_num(_SignNum) when _SignNum >= 5384, _SignNum =< 5391 ->
		[673,336];
get_def_num(_SignNum) when _SignNum >= 5392, _SignNum =< 99999 ->
		[674,337];
get_def_num(_SignNum) ->
	[0,0].

get_group(1) ->
	#kf_1vN_group{hard = 1,robot_args = 76,height = 100};

get_group(2) ->
	#kf_1vN_group{hard = 2,robot_args = 80,height = 150};

get_group(3) ->
	#kf_1vN_group{hard = 3,robot_args = 84,height = 250};

get_group(4) ->
	#kf_1vN_group{hard = 4,robot_args = 88,height = 250};

get_group(5) ->
	#kf_1vN_group{hard = 5,robot_args = 92,height = 150};

get_group(6) ->
	#kf_1vN_group{hard = 6,robot_args = 96,height = 100};

get_group(_Hard) ->
	[].

get_all_groups() ->
[1,2,3,4,5,6].

get_stage_args(1) ->
	#kf_1vN_race_2_match{stage = 1,hard = 8,c_num = 2};

get_stage_args(2) ->
	#kf_1vN_race_2_match{stage = 2,hard = 17,c_num = 4};

get_stage_args(3) ->
	#kf_1vN_race_2_match{stage = 3,hard = 28,c_num = 6};

get_stage_args(4) ->
	#kf_1vN_race_2_match{stage = 4,hard = 50,c_num = 8};

get_stage_args(5) ->
	#kf_1vN_race_2_match{stage = 5,hard = 87,c_num = 10};

get_stage_args(6) ->
	#kf_1vN_race_2_match{stage = 6,hard = 137,c_num = 13};

get_stage_args(7) ->
	#kf_1vN_race_2_match{stage = 7,hard = 192,c_num = 16};

get_stage_args(_Stage) ->
	[].

get_score_rank_reward(1,_Rank) when _Rank >= 1, _Rank =< 1 ->
		[{0,32010004,1},{0,32010214,5}];
get_score_rank_reward(1,_Rank) when _Rank >= 2, _Rank =< 10 ->
		[{0,32010003,1},{0,32010214,4}];
get_score_rank_reward(1,_Rank) when _Rank >= 11, _Rank =< 50 ->
		[{0,32010002,1},{0,32010214,3}];
get_score_rank_reward(1,_Rank) when _Rank >= 51, _Rank =< 200 ->
		[{0,32010001,1},{0,32010214,2}];
get_score_rank_reward(1,_Rank) when _Rank >= 201, _Rank =< 1000 ->
		[{0,32010001,1},{0,32010214,1}];
get_score_rank_reward(2,_Rank) when _Rank >= 1, _Rank =< 1 ->
		[{0,38064009,1},{0,68010006,20},{0,38040030,100},{0,32010006,1}];
get_score_rank_reward(2,_Rank) when _Rank >= 2, _Rank =< 2 ->
		[{0,38064008,1},{0,68010006,15},{0,38040030,80},{0,32010005,1}];
get_score_rank_reward(2,_Rank) when _Rank >= 3, _Rank =< 3 ->
		[{0,38064007,1},{0,68010006,15},{0,38040030,60},{0,32010005,1}];
get_score_rank_reward(2,_Rank) when _Rank >= 4, _Rank =< 5 ->
		[{0,68010006,12},{0,38040030,60},{0,32010005,1}];
get_score_rank_reward(2,_Rank) when _Rank >= 6, _Rank =< 20 ->
		[{0,68010006,9},{0,38040030,48},{0,32010004,1}];
get_score_rank_reward(2,_Rank) when _Rank >= 21, _Rank =< 50 ->
		[{0,68010006,6},{0,38040030,32},{0,32010004,1}];
get_score_rank_reward(2,_Rank) when _Rank >= 51, _Rank =< 200 ->
		[{0,68010006,4},{0,38040030,25},{0,32010003,1}];
get_score_rank_reward(2,_Rank) when _Rank >= 201, _Rank =< 1000 ->
		[{0,68010006,2},{0,38040030,20},{0,32010003,1}];
get_score_rank_reward(_Race_type,_Rank) ->
	[].


get_value(1) ->
250;


get_value(2) ->
[{733,1172},{2105,944}];


get_value(3) ->
{1489,1134};


get_value(4) ->
[{1489,1396},{1869,1294},{1893,990},{1635,878},{1290,900},{1020,1106},{1529,730},{1475,1560},{511,1124},{2407,1068},{1953,876},{1027,878},{953,1374},{1993,1370},{275,972},{547,862},{1003,638},{1450,422},{1777,524},{1983,624},{2300,770},{423,1334},{797,1512},{1175,820},{1173,790},{1823,1425},{1123,1417},{795,1132},{2195,1092},{1515,550},{288,1132},{1480,1680},{2430,1135}];


get_value(5) ->
[{1489,1396},{1869,1294},{1893,990},{1635,878},{1290,900},{1020,1106},{1529,730},{1475,1560},{511,1124},{2407,1068},{1953,876},{1027,878},{953,1374},{1993,1370},{275,972},{547,862},{1003,638},{1450,422},{1777,524},{1983,624},{2300,770},{423,1334},{797,1512},{1175,820},{1173,790},{1823,1425},{1123,1417},{795,1132},{2195,1092},{1515,550},{288,1132},{1480,1680},{2430,1135},{1489,1134},{733,1172},{2105,944}];


get_value(6) ->
60;


get_value(7) ->
2;


get_value(8) ->
17;


get_value(9) ->
310;


get_value(10) ->
6;


get_value(11) ->
3;


get_value(12) ->
46;


get_value(13) ->
5;

get_value(_Key) ->
	false.

get_race_2_award(1,1) ->
{[{255,36255003,50},{0,32010215,1}],[{255,36255003,50}]};

get_race_2_award(1,2) ->
{[{255,36255003,100},{0,32010215,1}],[{255,36255003,100}]};

get_race_2_award(1,3) ->
{[{255,36255003,150},{0,32010215,1}],[{255,36255003,150}]};

get_race_2_award(1,4) ->
{[{255,36255003,200},{0,38064010,1},{0,32010215,1}],[{255,36255003,200}]};

get_race_2_award(1,5) ->
{[{255,36255003,300},{0,38064011,1},{0,32010215,1}],[{255,36255003,250}]};

get_race_2_award(1,6) ->
{[{255,36255003,400},{0,38064012,1},{0,32010215,1}],[{255,36255003,300}]};

get_race_2_award(1,7) ->
{[{255,36255003,500},{0,38064013,1},{0,32010215,1}],[{255,36255003,300}]};

get_race_2_award(2,1) ->
{[{0,32010152,1},{0,36020001,30}],[{0,38040005,20},{0,36020001,10}]};

get_race_2_award(2,2) ->
{[{0,32010152,1},{0,36020001,30}],[{0,38040005,20},{0,36020001,10}]};

get_race_2_award(2,3) ->
{[{0,32010152,1},{0,36020001,30}],[{0,38040005,20},{0,36020001,10}]};

get_race_2_award(2,4) ->
{[{0,32010152,1},{0,36020001,30}],[{0,38040005,20},{0,36020001,10}]};

get_race_2_award(2,5) ->
{[{0,32010152,1},{0,36020001,30}],[{0,38040005,20},{0,36020001,10}]};

get_race_2_award(2,6) ->
{[{0,32010152,1},{0,36020001,30}],[{0,38040005,20},{0,36020001,10}]};

get_race_2_award(2,7) ->
{[{0,32010152,1},{0,36020001,30}],[{0,38040005,20},{0,36020001,10}]};

get_race_2_award(_Type,_Turn) ->
	false.

get_bet(1) ->
	#base_kf_1vn_bet{turn = 1,type = 0,opt_list = [{1,1},{2,2}],cost_list = [{1,[{2,0,50}],[{255,36255003,100}],[{255,36255003,60}]},{2,[{1,0,30}],[{255,36255003,500}],[{255,36255003,300}]}]};

get_bet(2) ->
	#base_kf_1vn_bet{turn = 2,type = 0,opt_list = [{1,1},{2,2}],cost_list = [{1,[{2,0,80}],[{255,36255003,180}],[{255,36255003,108}]},{2,[{1,0,50}],[{255,36255003,900}],[{255,36255003,540}]}]};

get_bet(3) ->
	#base_kf_1vn_bet{turn = 3,type = 0,opt_list = [{1,1},{2,2}],cost_list = [{1,[{2,0,100}],[{255,36255003,250}],[{255,36255003,150}]},{2,[{1,0,80}],[{255,36255003,1250}],[{255,36255003,750}]}]};

get_bet(4) ->
	#base_kf_1vn_bet{turn = 4,type = 1,opt_list = [{1,70,100},{2,40,69},{3,10,39},{4,0,9}],cost_list = [{1,[{2,0,150}],[{255,36255003,400}],[{255,36255003,240}]},{2,[{1,0,100}],[{255,36255003,2000}],[{255,36255003,1200}]}]};

get_bet(5) ->
	#base_kf_1vn_bet{turn = 5,type = 1,opt_list = [{1,70,100},{2,40,69},{3,10,39},{4,0,9}],cost_list = [{1,[{2,0,200}],[{255,36255003,600}],[{255,36255003,360}]},{2,[{1,0,150}],[{255,36255003,3000}],[{255,36255003,1800}]}]};

get_bet(6) ->
	#base_kf_1vn_bet{turn = 6,type = 2,opt_list = [{1,0,0},{2,1,8},{3,9,16},{4,17,24}],cost_list = [{1,[{1,0,200}],[{255,36255003,4800}],[{255,36255003,2880}]}]};

get_bet(7) ->
	#base_kf_1vn_bet{turn = 7,type = 2,opt_list = [{1,0,0},{2,1,8},{3,9,16},{4,17,32}],cost_list = [{1,[{1,0,300}],[{255,36255003,6500}],[{255,36255003,3900}]}]};

get_bet(_Turn) ->
	[].


get_cost_list(1) ->
[{1,[{2,0,50}],[{255,36255003,100}],[{255,36255003,60}]},{2,[{1,0,30}],[{255,36255003,500}],[{255,36255003,300}]}];


get_cost_list(2) ->
[{1,[{2,0,80}],[{255,36255003,180}],[{255,36255003,108}]},{2,[{1,0,50}],[{255,36255003,900}],[{255,36255003,540}]}];


get_cost_list(3) ->
[{1,[{2,0,100}],[{255,36255003,250}],[{255,36255003,150}]},{2,[{1,0,80}],[{255,36255003,1250}],[{255,36255003,750}]}];


get_cost_list(4) ->
[{1,[{2,0,150}],[{255,36255003,400}],[{255,36255003,240}]},{2,[{1,0,100}],[{255,36255003,2000}],[{255,36255003,1200}]}];


get_cost_list(5) ->
[{1,[{2,0,200}],[{255,36255003,600}],[{255,36255003,360}]},{2,[{1,0,150}],[{255,36255003,3000}],[{255,36255003,1800}]}];


get_cost_list(6) ->
[{1,[{1,0,200}],[{255,36255003,4800}],[{255,36255003,2880}]}];


get_cost_list(7) ->
[{1,[{1,0,300}],[{255,36255003,6500}],[{255,36255003,3900}]}];

get_cost_list(_Turn) ->
	[].


get_exp(250) ->
17102262;


get_exp(251) ->
17102262;


get_exp(252) ->
17102262;


get_exp(253) ->
17102262;


get_exp(254) ->
17102262;


get_exp(255) ->
17102262;


get_exp(256) ->
17102262;


get_exp(257) ->
17102262;


get_exp(258) ->
17102262;


get_exp(259) ->
17102262;


get_exp(260) ->
17690004;


get_exp(261) ->
17690004;


get_exp(262) ->
17690004;


get_exp(263) ->
17690004;


get_exp(264) ->
17690004;


get_exp(265) ->
17690004;


get_exp(266) ->
17690004;


get_exp(267) ->
17690004;


get_exp(268) ->
17690004;


get_exp(269) ->
17690004;


get_exp(270) ->
18297936;


get_exp(271) ->
18297936;


get_exp(272) ->
18297936;


get_exp(273) ->
18297936;


get_exp(274) ->
18297936;


get_exp(275) ->
18297936;


get_exp(276) ->
18297936;


get_exp(277) ->
18297936;


get_exp(278) ->
18297936;


get_exp(279) ->
18297936;


get_exp(280) ->
18926766;


get_exp(281) ->
18926766;


get_exp(282) ->
18926766;


get_exp(283) ->
18926766;


get_exp(284) ->
18926766;


get_exp(285) ->
18926766;


get_exp(286) ->
18926766;


get_exp(287) ->
18926766;


get_exp(288) ->
18926766;


get_exp(289) ->
18926766;


get_exp(290) ->
19577208;


get_exp(291) ->
19577208;


get_exp(292) ->
19577208;


get_exp(293) ->
19577208;


get_exp(294) ->
19577208;


get_exp(295) ->
19577208;


get_exp(296) ->
19577208;


get_exp(297) ->
19577208;


get_exp(298) ->
19577208;


get_exp(299) ->
19577208;


get_exp(300) ->
20250000;


get_exp(301) ->
20250000;


get_exp(302) ->
20250000;


get_exp(303) ->
20250000;


get_exp(304) ->
20250000;


get_exp(305) ->
20250000;


get_exp(306) ->
20250000;


get_exp(307) ->
20250000;


get_exp(308) ->
20250000;


get_exp(309) ->
20250000;


get_exp(310) ->
20945910;


get_exp(311) ->
20945910;


get_exp(312) ->
20945910;


get_exp(313) ->
20945910;


get_exp(314) ->
20945910;


get_exp(315) ->
20945910;


get_exp(316) ->
20945910;


get_exp(317) ->
20945910;


get_exp(318) ->
20945910;


get_exp(319) ->
20945910;


get_exp(320) ->
21665742;


get_exp(321) ->
21665742;


get_exp(322) ->
21665742;


get_exp(323) ->
21665742;


get_exp(324) ->
21665742;


get_exp(325) ->
21665742;


get_exp(326) ->
21665742;


get_exp(327) ->
21665742;


get_exp(328) ->
21665742;


get_exp(329) ->
21665742;


get_exp(330) ->
22410306;


get_exp(331) ->
22410306;


get_exp(332) ->
22410306;


get_exp(333) ->
22410306;


get_exp(334) ->
22410306;


get_exp(335) ->
22410306;


get_exp(336) ->
22410306;


get_exp(337) ->
22410306;


get_exp(338) ->
22410306;


get_exp(339) ->
22410306;


get_exp(340) ->
23180460;


get_exp(341) ->
23180460;


get_exp(342) ->
23180460;


get_exp(343) ->
23180460;


get_exp(344) ->
23180460;


get_exp(345) ->
23180460;


get_exp(346) ->
23180460;


get_exp(347) ->
23180460;


get_exp(348) ->
23180460;


get_exp(349) ->
23180460;


get_exp(350) ->
23977080;


get_exp(351) ->
23977080;


get_exp(352) ->
23977080;


get_exp(353) ->
23977080;


get_exp(354) ->
23977080;


get_exp(355) ->
23977080;


get_exp(356) ->
23977080;


get_exp(357) ->
23977080;


get_exp(358) ->
23977080;


get_exp(359) ->
23977080;


get_exp(360) ->
24801078;


get_exp(361) ->
24801078;


get_exp(362) ->
24801078;


get_exp(363) ->
24801078;


get_exp(364) ->
24801078;


get_exp(365) ->
24801078;


get_exp(366) ->
24801078;


get_exp(367) ->
24801078;


get_exp(368) ->
24801078;


get_exp(369) ->
24801078;


get_exp(370) ->
25653396;


get_exp(371) ->
25653396;


get_exp(372) ->
25653396;


get_exp(373) ->
25653396;


get_exp(374) ->
25653396;


get_exp(375) ->
25653396;


get_exp(376) ->
25653396;


get_exp(377) ->
25653396;


get_exp(378) ->
25653396;


get_exp(379) ->
25653396;


get_exp(380) ->
26535006;


get_exp(381) ->
26535006;


get_exp(382) ->
26535006;


get_exp(383) ->
26535006;


get_exp(384) ->
26535006;


get_exp(385) ->
26535006;


get_exp(386) ->
26535006;


get_exp(387) ->
26535006;


get_exp(388) ->
26535006;


get_exp(389) ->
26535006;


get_exp(390) ->
27446910;


get_exp(391) ->
27446910;


get_exp(392) ->
27446910;


get_exp(393) ->
27446910;


get_exp(394) ->
27446910;


get_exp(395) ->
27446910;


get_exp(396) ->
27446910;


get_exp(397) ->
27446910;


get_exp(398) ->
27446910;


get_exp(399) ->
27446910;


get_exp(400) ->
28390152;


get_exp(401) ->
28390152;


get_exp(402) ->
28390152;


get_exp(403) ->
28390152;


get_exp(404) ->
28390152;


get_exp(405) ->
28390152;


get_exp(406) ->
28390152;


get_exp(407) ->
28390152;


get_exp(408) ->
28390152;


get_exp(409) ->
28390152;


get_exp(410) ->
29365812;


get_exp(411) ->
29365812;


get_exp(412) ->
29365812;


get_exp(413) ->
29365812;


get_exp(414) ->
29365812;


get_exp(415) ->
29365812;


get_exp(416) ->
29365812;


get_exp(417) ->
29365812;


get_exp(418) ->
29365812;


get_exp(419) ->
29365812;


get_exp(420) ->
30375000;


get_exp(421) ->
30375000;


get_exp(422) ->
30375000;


get_exp(423) ->
30375000;


get_exp(424) ->
30375000;


get_exp(425) ->
30375000;


get_exp(426) ->
30375000;


get_exp(427) ->
30375000;


get_exp(428) ->
30375000;


get_exp(429) ->
30375000;


get_exp(430) ->
31418868;


get_exp(431) ->
31418868;


get_exp(432) ->
31418868;


get_exp(433) ->
31418868;


get_exp(434) ->
31418868;


get_exp(435) ->
31418868;


get_exp(436) ->
31418868;


get_exp(437) ->
31418868;


get_exp(438) ->
31418868;


get_exp(439) ->
31418868;


get_exp(440) ->
32498610;


get_exp(441) ->
32498610;


get_exp(442) ->
32498610;


get_exp(443) ->
32498610;


get_exp(444) ->
32498610;


get_exp(445) ->
32498610;


get_exp(446) ->
32498610;


get_exp(447) ->
32498610;


get_exp(448) ->
32498610;


get_exp(449) ->
32498610;


get_exp(450) ->
33615462;


get_exp(451) ->
33615462;


get_exp(452) ->
33615462;


get_exp(453) ->
33615462;


get_exp(454) ->
33615462;


get_exp(455) ->
33615462;


get_exp(456) ->
33615462;


get_exp(457) ->
33615462;


get_exp(458) ->
33615462;


get_exp(459) ->
33615462;


get_exp(460) ->
34770690;


get_exp(461) ->
34770690;


get_exp(462) ->
34770690;


get_exp(463) ->
34770690;


get_exp(464) ->
34770690;


get_exp(465) ->
34770690;


get_exp(466) ->
34770690;


get_exp(467) ->
34770690;


get_exp(468) ->
34770690;


get_exp(469) ->
34770690;


get_exp(470) ->
35965626;


get_exp(471) ->
35965626;


get_exp(472) ->
35965626;


get_exp(473) ->
35965626;


get_exp(474) ->
35965626;


get_exp(475) ->
35965626;


get_exp(476) ->
35965626;


get_exp(477) ->
35965626;


get_exp(478) ->
35965626;


get_exp(479) ->
35965626;


get_exp(480) ->
37201620;


get_exp(481) ->
37201620;


get_exp(482) ->
37201620;


get_exp(483) ->
37201620;


get_exp(484) ->
37201620;


get_exp(485) ->
37201620;


get_exp(486) ->
37201620;


get_exp(487) ->
37201620;


get_exp(488) ->
37201620;


get_exp(489) ->
37201620;


get_exp(490) ->
38480094;


get_exp(491) ->
38480094;


get_exp(492) ->
38480094;


get_exp(493) ->
38480094;


get_exp(494) ->
38480094;


get_exp(495) ->
38480094;


get_exp(496) ->
38480094;


get_exp(497) ->
38480094;


get_exp(498) ->
38480094;


get_exp(499) ->
38480094;


get_exp(500) ->
39802506;


get_exp(501) ->
39802506;


get_exp(502) ->
39802506;


get_exp(503) ->
39802506;


get_exp(504) ->
39802506;


get_exp(505) ->
39802506;


get_exp(506) ->
39802506;


get_exp(507) ->
39802506;


get_exp(508) ->
39802506;


get_exp(509) ->
39802506;


get_exp(510) ->
41170362;


get_exp(511) ->
41170362;


get_exp(512) ->
41170362;


get_exp(513) ->
41170362;


get_exp(514) ->
41170362;


get_exp(515) ->
41170362;


get_exp(516) ->
41170362;


get_exp(517) ->
41170362;


get_exp(518) ->
41170362;


get_exp(519) ->
41170362;


get_exp(520) ->
42585228;


get_exp(521) ->
42585228;


get_exp(522) ->
42585228;


get_exp(523) ->
42585228;


get_exp(524) ->
42585228;


get_exp(525) ->
42585228;


get_exp(526) ->
42585228;


get_exp(527) ->
42585228;


get_exp(528) ->
42585228;


get_exp(529) ->
42585228;


get_exp(530) ->
44048718;


get_exp(531) ->
44048718;


get_exp(532) ->
44048718;


get_exp(533) ->
44048718;


get_exp(534) ->
44048718;


get_exp(535) ->
44048718;


get_exp(536) ->
44048718;


get_exp(537) ->
44048718;


get_exp(538) ->
44048718;


get_exp(539) ->
44048718;


get_exp(540) ->
45562500;


get_exp(541) ->
45562500;


get_exp(542) ->
45562500;


get_exp(543) ->
45562500;


get_exp(544) ->
45562500;


get_exp(545) ->
45562500;


get_exp(546) ->
45562500;


get_exp(547) ->
45562500;


get_exp(548) ->
45562500;


get_exp(549) ->
45562500;


get_exp(550) ->
47128302;


get_exp(551) ->
47128302;


get_exp(552) ->
47128302;


get_exp(553) ->
47128302;


get_exp(554) ->
47128302;


get_exp(555) ->
47128302;


get_exp(556) ->
47128302;


get_exp(557) ->
47128302;


get_exp(558) ->
47128302;


get_exp(559) ->
47128302;


get_exp(560) ->
48747918;


get_exp(561) ->
48747918;


get_exp(562) ->
48747918;


get_exp(563) ->
48747918;


get_exp(564) ->
48747918;


get_exp(565) ->
48747918;


get_exp(566) ->
48747918;


get_exp(567) ->
48747918;


get_exp(568) ->
48747918;


get_exp(569) ->
48747918;


get_exp(570) ->
50423190;


get_exp(571) ->
50423190;


get_exp(572) ->
50423190;


get_exp(573) ->
50423190;


get_exp(574) ->
50423190;


get_exp(575) ->
50423190;


get_exp(576) ->
50423190;


get_exp(577) ->
50423190;


get_exp(578) ->
50423190;


get_exp(579) ->
50423190;


get_exp(580) ->
52156038;


get_exp(581) ->
52156038;


get_exp(582) ->
52156038;


get_exp(583) ->
52156038;


get_exp(584) ->
52156038;


get_exp(585) ->
52156038;


get_exp(586) ->
52156038;


get_exp(587) ->
52156038;


get_exp(588) ->
52156038;


get_exp(589) ->
52156038;


get_exp(590) ->
53948436;


get_exp(591) ->
53948436;


get_exp(592) ->
53948436;


get_exp(593) ->
53948436;


get_exp(594) ->
53948436;


get_exp(595) ->
53948436;


get_exp(596) ->
53948436;


get_exp(597) ->
53948436;


get_exp(598) ->
53948436;


get_exp(599) ->
53948436;


get_exp(600) ->
55802436;


get_exp(601) ->
55802436;


get_exp(602) ->
55802436;


get_exp(603) ->
55802436;


get_exp(604) ->
55802436;


get_exp(605) ->
55802436;


get_exp(606) ->
55802436;


get_exp(607) ->
55802436;


get_exp(608) ->
55802436;


get_exp(609) ->
55802436;


get_exp(610) ->
57720144;


get_exp(611) ->
57720144;


get_exp(612) ->
57720144;


get_exp(613) ->
57720144;


get_exp(614) ->
57720144;


get_exp(615) ->
57720144;


get_exp(616) ->
57720144;


get_exp(617) ->
57720144;


get_exp(618) ->
57720144;


get_exp(619) ->
57720144;


get_exp(620) ->
59703762;


get_exp(621) ->
59703762;


get_exp(622) ->
59703762;


get_exp(623) ->
59703762;


get_exp(624) ->
59703762;


get_exp(625) ->
59703762;


get_exp(626) ->
59703762;


get_exp(627) ->
59703762;


get_exp(628) ->
59703762;


get_exp(629) ->
59703762;


get_exp(630) ->
61755546;


get_exp(631) ->
61755546;


get_exp(632) ->
61755546;


get_exp(633) ->
61755546;


get_exp(634) ->
61755546;


get_exp(635) ->
61755546;


get_exp(636) ->
61755546;


get_exp(637) ->
61755546;


get_exp(638) ->
61755546;


get_exp(639) ->
61755546;


get_exp(640) ->
63877842;


get_exp(641) ->
63877842;


get_exp(642) ->
63877842;


get_exp(643) ->
63877842;


get_exp(644) ->
63877842;


get_exp(645) ->
63877842;


get_exp(646) ->
63877842;


get_exp(647) ->
63877842;


get_exp(648) ->
63877842;


get_exp(649) ->
63877842;


get_exp(650) ->
66073074;


get_exp(651) ->
66073074;


get_exp(652) ->
66073074;


get_exp(653) ->
66073074;


get_exp(654) ->
66073074;


get_exp(655) ->
66073074;


get_exp(656) ->
66073074;


get_exp(657) ->
66073074;


get_exp(658) ->
66073074;


get_exp(659) ->
66073074;


get_exp(660) ->
68343750;


get_exp(661) ->
68343750;


get_exp(662) ->
68343750;


get_exp(663) ->
68343750;


get_exp(664) ->
68343750;


get_exp(665) ->
68343750;


get_exp(666) ->
68343750;


get_exp(667) ->
68343750;


get_exp(668) ->
68343750;


get_exp(669) ->
68343750;


get_exp(670) ->
70692456;


get_exp(671) ->
70692456;


get_exp(672) ->
70692456;


get_exp(673) ->
70692456;


get_exp(674) ->
70692456;


get_exp(675) ->
70692456;


get_exp(676) ->
70692456;


get_exp(677) ->
70692456;


get_exp(678) ->
70692456;


get_exp(679) ->
70692456;


get_exp(680) ->
73121874;


get_exp(681) ->
73121874;


get_exp(682) ->
73121874;


get_exp(683) ->
73121874;


get_exp(684) ->
73121874;


get_exp(685) ->
73121874;


get_exp(686) ->
73121874;


get_exp(687) ->
73121874;


get_exp(688) ->
73121874;


get_exp(689) ->
73121874;


get_exp(690) ->
75634788;


get_exp(691) ->
75634788;


get_exp(692) ->
75634788;


get_exp(693) ->
75634788;


get_exp(694) ->
75634788;


get_exp(695) ->
75634788;


get_exp(696) ->
75634788;


get_exp(697) ->
75634788;


get_exp(698) ->
75634788;


get_exp(699) ->
75634788;


get_exp(700) ->
78234060;


get_exp(701) ->
78234060;


get_exp(702) ->
78234060;


get_exp(703) ->
78234060;


get_exp(704) ->
78234060;


get_exp(705) ->
78234060;


get_exp(706) ->
78234060;


get_exp(707) ->
78234060;


get_exp(708) ->
78234060;


get_exp(709) ->
78234060;


get_exp(710) ->
80922660;


get_exp(711) ->
80922660;


get_exp(712) ->
80922660;


get_exp(713) ->
80922660;


get_exp(714) ->
80922660;


get_exp(715) ->
80922660;


get_exp(716) ->
80922660;


get_exp(717) ->
80922660;


get_exp(718) ->
80922660;


get_exp(719) ->
80922660;


get_exp(720) ->
83703654;


get_exp(721) ->
83703654;


get_exp(722) ->
83703654;


get_exp(723) ->
83703654;


get_exp(724) ->
83703654;


get_exp(725) ->
83703654;


get_exp(726) ->
83703654;


get_exp(727) ->
83703654;


get_exp(728) ->
83703654;


get_exp(729) ->
83703654;


get_exp(730) ->
86580222;


get_exp(731) ->
86580222;


get_exp(732) ->
86580222;


get_exp(733) ->
86580222;


get_exp(734) ->
86580222;


get_exp(735) ->
86580222;


get_exp(736) ->
86580222;


get_exp(737) ->
86580222;


get_exp(738) ->
86580222;


get_exp(739) ->
86580222;


get_exp(740) ->
89555646;


get_exp(741) ->
89555646;


get_exp(742) ->
89555646;


get_exp(743) ->
89555646;


get_exp(744) ->
89555646;


get_exp(745) ->
89555646;


get_exp(746) ->
89555646;


get_exp(747) ->
89555646;


get_exp(748) ->
89555646;


get_exp(749) ->
89555646;


get_exp(750) ->
92633322;


get_exp(751) ->
92633322;


get_exp(752) ->
92633322;


get_exp(753) ->
92633322;


get_exp(754) ->
92633322;


get_exp(755) ->
92633322;


get_exp(756) ->
92633322;


get_exp(757) ->
92633322;


get_exp(758) ->
92633322;


get_exp(759) ->
92633322;


get_exp(760) ->
95816766;


get_exp(761) ->
95816766;


get_exp(762) ->
95816766;


get_exp(763) ->
95816766;


get_exp(764) ->
95816766;


get_exp(765) ->
95816766;


get_exp(766) ->
95816766;


get_exp(767) ->
95816766;


get_exp(768) ->
95816766;


get_exp(769) ->
95816766;


get_exp(770) ->
99109614;


get_exp(771) ->
99109614;


get_exp(772) ->
99109614;


get_exp(773) ->
99109614;


get_exp(774) ->
99109614;


get_exp(775) ->
99109614;


get_exp(776) ->
99109614;


get_exp(777) ->
99109614;


get_exp(778) ->
99109614;


get_exp(779) ->
99109614;


get_exp(780) ->
102515622;


get_exp(781) ->
102515622;


get_exp(782) ->
102515622;


get_exp(783) ->
102515622;


get_exp(784) ->
102515622;


get_exp(785) ->
102515622;


get_exp(786) ->
102515622;


get_exp(787) ->
102515622;


get_exp(788) ->
102515622;


get_exp(789) ->
102515622;


get_exp(790) ->
106038684;


get_exp(791) ->
106038684;


get_exp(792) ->
106038684;


get_exp(793) ->
106038684;


get_exp(794) ->
106038684;


get_exp(795) ->
106038684;


get_exp(796) ->
106038684;


get_exp(797) ->
106038684;


get_exp(798) ->
106038684;


get_exp(799) ->
106038684;


get_exp(800) ->
109682814;


get_exp(801) ->
109682814;


get_exp(802) ->
109682814;


get_exp(803) ->
109682814;


get_exp(804) ->
109682814;


get_exp(805) ->
109682814;


get_exp(806) ->
109682814;


get_exp(807) ->
109682814;


get_exp(808) ->
109682814;


get_exp(809) ->
109682814;


get_exp(810) ->
113452188;


get_exp(811) ->
113452188;


get_exp(812) ->
113452188;


get_exp(813) ->
113452188;


get_exp(814) ->
113452188;


get_exp(815) ->
113452188;


get_exp(816) ->
113452188;


get_exp(817) ->
113452188;


get_exp(818) ->
113452188;


get_exp(819) ->
113452188;


get_exp(820) ->
117351096;


get_exp(821) ->
117351096;


get_exp(822) ->
117351096;


get_exp(823) ->
117351096;


get_exp(824) ->
117351096;


get_exp(825) ->
117351096;


get_exp(826) ->
117351096;


get_exp(827) ->
117351096;


get_exp(828) ->
117351096;


get_exp(829) ->
117351096;


get_exp(830) ->
121383990;


get_exp(831) ->
121383990;


get_exp(832) ->
121383990;


get_exp(833) ->
121383990;


get_exp(834) ->
121383990;


get_exp(835) ->
121383990;


get_exp(836) ->
121383990;


get_exp(837) ->
121383990;


get_exp(838) ->
121383990;


get_exp(839) ->
121383990;


get_exp(840) ->
125555484;


get_exp(841) ->
125555484;


get_exp(842) ->
125555484;


get_exp(843) ->
125555484;


get_exp(844) ->
125555484;


get_exp(845) ->
125555484;


get_exp(846) ->
125555484;


get_exp(847) ->
125555484;


get_exp(848) ->
125555484;


get_exp(849) ->
125555484;


get_exp(850) ->
129870336;


get_exp(851) ->
129870336;


get_exp(852) ->
129870336;


get_exp(853) ->
129870336;


get_exp(854) ->
129870336;


get_exp(855) ->
129870336;


get_exp(856) ->
129870336;


get_exp(857) ->
129870336;


get_exp(858) ->
129870336;


get_exp(859) ->
129870336;


get_exp(860) ->
134333466;


get_exp(861) ->
134333466;


get_exp(862) ->
134333466;


get_exp(863) ->
134333466;


get_exp(864) ->
134333466;


get_exp(865) ->
134333466;


get_exp(866) ->
134333466;


get_exp(867) ->
134333466;


get_exp(868) ->
134333466;


get_exp(869) ->
134333466;


get_exp(870) ->
138949986;


get_exp(871) ->
138949986;


get_exp(872) ->
138949986;


get_exp(873) ->
138949986;


get_exp(874) ->
138949986;


get_exp(875) ->
138949986;


get_exp(876) ->
138949986;


get_exp(877) ->
138949986;


get_exp(878) ->
138949986;


get_exp(879) ->
138949986;


get_exp(880) ->
143725152;


get_exp(881) ->
143725152;


get_exp(882) ->
143725152;


get_exp(883) ->
143725152;


get_exp(884) ->
143725152;


get_exp(885) ->
143725152;


get_exp(886) ->
143725152;


get_exp(887) ->
143725152;


get_exp(888) ->
143725152;


get_exp(889) ->
143725152;


get_exp(890) ->
148664418;


get_exp(891) ->
148664418;


get_exp(892) ->
148664418;


get_exp(893) ->
148664418;


get_exp(894) ->
148664418;


get_exp(895) ->
148664418;


get_exp(896) ->
148664418;


get_exp(897) ->
148664418;


get_exp(898) ->
148664418;


get_exp(899) ->
148664418;


get_exp(900) ->
153773436;


get_exp(901) ->
153773436;


get_exp(902) ->
153773436;


get_exp(903) ->
153773436;


get_exp(904) ->
153773436;


get_exp(905) ->
153773436;


get_exp(906) ->
153773436;


get_exp(907) ->
153773436;


get_exp(908) ->
153773436;


get_exp(909) ->
153773436;


get_exp(910) ->
159058026;


get_exp(911) ->
159058026;


get_exp(912) ->
159058026;


get_exp(913) ->
159058026;


get_exp(914) ->
159058026;


get_exp(915) ->
159058026;


get_exp(916) ->
159058026;


get_exp(917) ->
159058026;


get_exp(918) ->
159058026;


get_exp(919) ->
159058026;


get_exp(920) ->
164524224;


get_exp(921) ->
164524224;


get_exp(922) ->
164524224;


get_exp(923) ->
164524224;


get_exp(924) ->
164524224;


get_exp(925) ->
164524224;


get_exp(926) ->
164524224;


get_exp(927) ->
164524224;


get_exp(928) ->
164524224;


get_exp(929) ->
164524224;


get_exp(930) ->
170178282;


get_exp(931) ->
170178282;


get_exp(932) ->
170178282;


get_exp(933) ->
170178282;


get_exp(934) ->
170178282;


get_exp(935) ->
170178282;


get_exp(936) ->
170178282;


get_exp(937) ->
170178282;


get_exp(938) ->
170178282;


get_exp(939) ->
170178282;


get_exp(940) ->
176026644;


get_exp(941) ->
176026644;


get_exp(942) ->
176026644;


get_exp(943) ->
176026644;


get_exp(944) ->
176026644;


get_exp(945) ->
176026644;


get_exp(946) ->
176026644;


get_exp(947) ->
176026644;


get_exp(948) ->
176026644;


get_exp(949) ->
176026644;


get_exp(950) ->
182075988;


get_exp(951) ->
182075988;


get_exp(952) ->
182075988;


get_exp(953) ->
182075988;


get_exp(954) ->
182075988;


get_exp(955) ->
182075988;


get_exp(956) ->
182075988;


get_exp(957) ->
182075988;


get_exp(958) ->
182075988;


get_exp(959) ->
182075988;


get_exp(960) ->
188333226;


get_exp(961) ->
188333226;


get_exp(962) ->
188333226;


get_exp(963) ->
188333226;


get_exp(964) ->
188333226;


get_exp(965) ->
188333226;


get_exp(966) ->
188333226;


get_exp(967) ->
188333226;


get_exp(968) ->
188333226;


get_exp(969) ->
188333226;


get_exp(970) ->
194805504;


get_exp(971) ->
194805504;


get_exp(972) ->
194805504;


get_exp(973) ->
194805504;


get_exp(974) ->
194805504;


get_exp(975) ->
194805504;


get_exp(976) ->
194805504;


get_exp(977) ->
194805504;


get_exp(978) ->
194805504;


get_exp(979) ->
194805504;


get_exp(980) ->
201500202;


get_exp(981) ->
201500202;


get_exp(982) ->
201500202;


get_exp(983) ->
201500202;


get_exp(984) ->
201500202;


get_exp(985) ->
201500202;


get_exp(986) ->
201500202;


get_exp(987) ->
201500202;


get_exp(988) ->
201500202;


get_exp(989) ->
201500202;


get_exp(990) ->
208424976;


get_exp(991) ->
208424976;


get_exp(992) ->
208424976;


get_exp(993) ->
208424976;


get_exp(994) ->
208424976;


get_exp(995) ->
208424976;


get_exp(996) ->
208424976;


get_exp(997) ->
208424976;


get_exp(998) ->
208424976;


get_exp(999) ->
208424976;


get_exp(1000) ->
215587728;

get_exp(_Lv) ->
	0.

get_auction_info(1) ->
	#kf_1vN_auction_cfg{id = 1,goods = [{0,18100004,1}],cost = [{1,0, 6000}],ser_award = [{0,18090003,2}]};

get_auction_info(2) ->
	#kf_1vN_auction_cfg{id = 2,goods = [{0,18100002,1}],cost = [{1,0,1500}],ser_award = [{0,18090002,5}]};

get_auction_info(_Id) ->
	[].

get_auction_ids() ->
[1,2].

