%%%---------------------------------------
%%% module      : data_midday_party
%%% description : 午间派对配置
%%%
%%%---------------------------------------
-module(data_midday_party).
-compile(export_all).




get_kv(box_coordinate) ->
[{2366,1113},{1769,1239},{1403,1728},{563,1614},{1043,2211},{1613,1509},{1622,972},{938,1728},{1556,2049},{374,1824},{2393,1413},{2000,1572},{569,1341},{161,1347},{2441,858},{1007,1944},{1529,2253},{368,2076}];


get_kv(mon_id) ->
29006;


get_kv(mon_id_cooordinate) ->
{1421,1722};


get_kv(reborn_time) ->
120;


get_kv(low_box_collect_limt) ->
20;


get_kv(high_box_collect_limt) ->
10;


get_kv(refresh_time) ->
30;


get_kv(refresh_box_num) ->
3;


get_kv(refresh_time_exp) ->
5;


get_kv(scene_id) ->
2029;


get_kv(low_box_collect_reward) ->
[{0,32010182,1}];


get_kv(high_box_collect_reward) ->
[{0,32010183,1}];


get_kv(box_num) ->
{2, 3};


get_kv(box_id) ->
{29007,29008};


get_kv(lv_limit) ->
100;


get_kv(act_time) ->
600;

get_kv(_Key) ->
	[].

get_exp(_Lv) when _Lv >= 1, _Lv =< 50 ->
		[{5,0,484975}];
get_exp(_Lv) when _Lv >= 51, _Lv =< 51 ->
		[{5,0,488925}];
get_exp(_Lv) when _Lv >= 52, _Lv =< 52 ->
		[{5,0,492900}];
get_exp(_Lv) when _Lv >= 53, _Lv =< 53 ->
		[{5,0,496900}];
get_exp(_Lv) when _Lv >= 54, _Lv =< 54 ->
		[{5,0,500950}];
get_exp(_Lv) when _Lv >= 55, _Lv =< 55 ->
		[{5,0,505025}];
get_exp(_Lv) when _Lv >= 56, _Lv =< 56 ->
		[{5,0,509125}];
get_exp(_Lv) when _Lv >= 57, _Lv =< 57 ->
		[{5,0,513300}];
get_exp(_Lv) when _Lv >= 58, _Lv =< 58 ->
		[{5,0,517475}];
get_exp(_Lv) when _Lv >= 59, _Lv =< 59 ->
		[{5,0,521675}];
get_exp(_Lv) when _Lv >= 60, _Lv =< 60 ->
		[{5,0,525950}];
get_exp(_Lv) when _Lv >= 61, _Lv =< 61 ->
		[{5,0,530200}];
get_exp(_Lv) when _Lv >= 62, _Lv =< 62 ->
		[{5,0,534550}];
get_exp(_Lv) when _Lv >= 63, _Lv =< 63 ->
		[{5,0,538875}];
get_exp(_Lv) when _Lv >= 64, _Lv =< 64 ->
		[{5,0,543275}];
get_exp(_Lv) when _Lv >= 65, _Lv =< 65 ->
		[{5,0,547700}];
get_exp(_Lv) when _Lv >= 66, _Lv =< 66 ->
		[{5,0,552150}];
get_exp(_Lv) when _Lv >= 67, _Lv =< 67 ->
		[{5,0,556650}];
get_exp(_Lv) when _Lv >= 68, _Lv =< 68 ->
		[{5,0,561175}];
get_exp(_Lv) when _Lv >= 69, _Lv =< 69 ->
		[{5,0,565750}];
get_exp(_Lv) when _Lv >= 70, _Lv =< 70 ->
		[{5,0,570350}];
get_exp(_Lv) when _Lv >= 71, _Lv =< 71 ->
		[{5,0,575000}];
get_exp(_Lv) when _Lv >= 72, _Lv =< 72 ->
		[{5,0,579675}];
get_exp(_Lv) when _Lv >= 73, _Lv =< 73 ->
		[{5,0,584400}];
get_exp(_Lv) when _Lv >= 74, _Lv =< 74 ->
		[{5,0,589150}];
get_exp(_Lv) when _Lv >= 75, _Lv =< 75 ->
		[{5,0,593950}];
get_exp(_Lv) when _Lv >= 76, _Lv =< 76 ->
		[{5,0,598800}];
get_exp(_Lv) when _Lv >= 77, _Lv =< 77 ->
		[{5,0,603675}];
get_exp(_Lv) when _Lv >= 78, _Lv =< 78 ->
		[{5,0,608600}];
get_exp(_Lv) when _Lv >= 79, _Lv =< 79 ->
		[{5,0,613525}];
get_exp(_Lv) when _Lv >= 80, _Lv =< 80 ->
		[{5,0,618525}];
get_exp(_Lv) when _Lv >= 81, _Lv =< 81 ->
		[{5,0,623575}];
get_exp(_Lv) when _Lv >= 82, _Lv =< 82 ->
		[{5,0,628650}];
get_exp(_Lv) when _Lv >= 83, _Lv =< 83 ->
		[{5,0,633775}];
get_exp(_Lv) when _Lv >= 84, _Lv =< 84 ->
		[{5,0,638950}];
get_exp(_Lv) when _Lv >= 85, _Lv =< 85 ->
		[{5,0,644125}];
get_exp(_Lv) when _Lv >= 86, _Lv =< 86 ->
		[{5,0,649375}];
get_exp(_Lv) when _Lv >= 87, _Lv =< 87 ->
		[{5,0,654650}];
get_exp(_Lv) when _Lv >= 88, _Lv =< 88 ->
		[{5,0,659975}];
get_exp(_Lv) when _Lv >= 89, _Lv =< 89 ->
		[{5,0,665375}];
get_exp(_Lv) when _Lv >= 90, _Lv =< 90 ->
		[{5,0,670800}];
get_exp(_Lv) when _Lv >= 91, _Lv =< 91 ->
		[{5,0,676250}];
get_exp(_Lv) when _Lv >= 92, _Lv =< 92 ->
		[{5,0,681750}];
get_exp(_Lv) when _Lv >= 93, _Lv =< 93 ->
		[{5,0,687300}];
get_exp(_Lv) when _Lv >= 94, _Lv =< 94 ->
		[{5,0,692900}];
get_exp(_Lv) when _Lv >= 95, _Lv =< 95 ->
		[{5,0,698550}];
get_exp(_Lv) when _Lv >= 96, _Lv =< 96 ->
		[{5,0,704225}];
get_exp(_Lv) when _Lv >= 97, _Lv =< 97 ->
		[{5,0,709975}];
get_exp(_Lv) when _Lv >= 98, _Lv =< 98 ->
		[{5,0,715750}];
get_exp(_Lv) when _Lv >= 99, _Lv =< 99 ->
		[{5,0,721575}];
get_exp(_Lv) when _Lv >= 100, _Lv =< 100 ->
		[{5,0,727450}];
get_exp(_Lv) when _Lv >= 101, _Lv =< 101 ->
		[{5,0,733350}];
get_exp(_Lv) when _Lv >= 102, _Lv =< 102 ->
		[{5,0,739325}];
get_exp(_Lv) when _Lv >= 103, _Lv =< 103 ->
		[{5,0,745350}];
get_exp(_Lv) when _Lv >= 104, _Lv =< 104 ->
		[{5,0,751425}];
get_exp(_Lv) when _Lv >= 105, _Lv =< 105 ->
		[{5,0,757550}];
get_exp(_Lv) when _Lv >= 106, _Lv =< 106 ->
		[{5,0,763700}];
get_exp(_Lv) when _Lv >= 107, _Lv =< 107 ->
		[{5,0,769925}];
get_exp(_Lv) when _Lv >= 108, _Lv =< 108 ->
		[{5,0,776200}];
get_exp(_Lv) when _Lv >= 109, _Lv =< 109 ->
		[{5,0,782525}];
get_exp(_Lv) when _Lv >= 110, _Lv =< 110 ->
		[{5,0,788900}];
get_exp(_Lv) when _Lv >= 111, _Lv =< 111 ->
		[{5,0,795325}];
get_exp(_Lv) when _Lv >= 112, _Lv =< 112 ->
		[{5,0,801800}];
get_exp(_Lv) when _Lv >= 113, _Lv =< 113 ->
		[{5,0,808350}];
get_exp(_Lv) when _Lv >= 114, _Lv =< 114 ->
		[{5,0,814925}];
get_exp(_Lv) when _Lv >= 115, _Lv =< 115 ->
		[{5,0,821550}];
get_exp(_Lv) when _Lv >= 116, _Lv =< 116 ->
		[{5,0,828225}];
get_exp(_Lv) when _Lv >= 117, _Lv =< 117 ->
		[{5,0,834975}];
get_exp(_Lv) when _Lv >= 118, _Lv =< 118 ->
		[{5,0,841775}];
get_exp(_Lv) when _Lv >= 119, _Lv =< 119 ->
		[{5,0,848625}];
get_exp(_Lv) when _Lv >= 120, _Lv =< 120 ->
		[{5,0,855525}];
get_exp(_Lv) when _Lv >= 121, _Lv =< 121 ->
		[{5,0,862500}];
get_exp(_Lv) when _Lv >= 122, _Lv =< 122 ->
		[{5,0,869525}];
get_exp(_Lv) when _Lv >= 123, _Lv =< 123 ->
		[{5,0,876625}];
get_exp(_Lv) when _Lv >= 124, _Lv =< 124 ->
		[{5,0,883725}];
get_exp(_Lv) when _Lv >= 125, _Lv =< 125 ->
		[{5,0,890950}];
get_exp(_Lv) when _Lv >= 126, _Lv =< 126 ->
		[{5,0,898200}];
get_exp(_Lv) when _Lv >= 127, _Lv =< 127 ->
		[{5,0,905525}];
get_exp(_Lv) when _Lv >= 128, _Lv =< 128 ->
		[{5,0,912900}];
get_exp(_Lv) when _Lv >= 129, _Lv =< 129 ->
		[{5,0,920300}];
get_exp(_Lv) when _Lv >= 130, _Lv =< 130 ->
		[{5,0,927825}];
get_exp(_Lv) when _Lv >= 131, _Lv =< 131 ->
		[{5,0,935350}];
get_exp(_Lv) when _Lv >= 132, _Lv =< 132 ->
		[{5,0,943000}];
get_exp(_Lv) when _Lv >= 133, _Lv =< 133 ->
		[{5,0,950650}];
get_exp(_Lv) when _Lv >= 134, _Lv =< 134 ->
		[{5,0,958400}];
get_exp(_Lv) when _Lv >= 135, _Lv =< 135 ->
		[{5,0,966200}];
get_exp(_Lv) when _Lv >= 136, _Lv =< 136 ->
		[{5,0,974075}];
get_exp(_Lv) when _Lv >= 137, _Lv =< 137 ->
		[{5,0,982000}];
get_exp(_Lv) when _Lv >= 138, _Lv =< 138 ->
		[{5,0,990000}];
get_exp(_Lv) when _Lv >= 139, _Lv =< 139 ->
		[{5,0,998050}];
get_exp(_Lv) when _Lv >= 140, _Lv =< 140 ->
		[{5,0,1006200}];
get_exp(_Lv) when _Lv >= 141, _Lv =< 141 ->
		[{5,0,1014375}];
get_exp(_Lv) when _Lv >= 142, _Lv =< 142 ->
		[{5,0,1022625}];
get_exp(_Lv) when _Lv >= 143, _Lv =< 143 ->
		[{5,0,1030975}];
get_exp(_Lv) when _Lv >= 144, _Lv =< 144 ->
		[{5,0,1039375}];
get_exp(_Lv) when _Lv >= 145, _Lv =< 145 ->
		[{5,0,1047800}];
get_exp(_Lv) when _Lv >= 146, _Lv =< 146 ->
		[{5,0,1056350}];
get_exp(_Lv) when _Lv >= 147, _Lv =< 147 ->
		[{5,0,1064950}];
get_exp(_Lv) when _Lv >= 148, _Lv =< 148 ->
		[{5,0,1073625}];
get_exp(_Lv) when _Lv >= 149, _Lv =< 149 ->
		[{5,0,1082375}];
get_exp(_Lv) when _Lv >= 150, _Lv =< 150 ->
		[{5,0,1091175}];
get_exp(_Lv) when _Lv >= 151, _Lv =< 151 ->
		[{5,0,1100075}];
get_exp(_Lv) when _Lv >= 152, _Lv =< 152 ->
		[{5,0,1109025}];
get_exp(_Lv) when _Lv >= 153, _Lv =< 153 ->
		[{5,0,1118050}];
get_exp(_Lv) when _Lv >= 154, _Lv =< 154 ->
		[{5,0,1127150}];
get_exp(_Lv) when _Lv >= 155, _Lv =< 155 ->
		[{5,0,1136325}];
get_exp(_Lv) when _Lv >= 156, _Lv =< 156 ->
		[{5,0,1145600}];
get_exp(_Lv) when _Lv >= 157, _Lv =< 157 ->
		[{5,0,1154900}];
get_exp(_Lv) when _Lv >= 158, _Lv =< 158 ->
		[{5,0,1164300}];
get_exp(_Lv) when _Lv >= 159, _Lv =< 159 ->
		[{5,0,1173800}];
get_exp(_Lv) when _Lv >= 160, _Lv =< 160 ->
		[{5,0,1183350}];
get_exp(_Lv) when _Lv >= 161, _Lv =< 161 ->
		[{5,0,1192975}];
get_exp(_Lv) when _Lv >= 162, _Lv =< 162 ->
		[{5,0,1202700}];
get_exp(_Lv) when _Lv >= 163, _Lv =< 163 ->
		[{5,0,1212500}];
get_exp(_Lv) when _Lv >= 164, _Lv =< 164 ->
		[{5,0,1222375}];
get_exp(_Lv) when _Lv >= 165, _Lv =< 165 ->
		[{5,0,1232325}];
get_exp(_Lv) when _Lv >= 166, _Lv =< 166 ->
		[{5,0,1242375}];
get_exp(_Lv) when _Lv >= 167, _Lv =< 167 ->
		[{5,0,1252475}];
get_exp(_Lv) when _Lv >= 168, _Lv =< 168 ->
		[{5,0,1262675}];
get_exp(_Lv) when _Lv >= 169, _Lv =< 169 ->
		[{5,0,1272950}];
get_exp(_Lv) when _Lv >= 170, _Lv =< 170 ->
		[{5,0,1283325}];
get_exp(_Lv) when _Lv >= 171, _Lv =< 171 ->
		[{5,0,1293750}];
get_exp(_Lv) when _Lv >= 172, _Lv =< 172 ->
		[{5,0,1304325}];
get_exp(_Lv) when _Lv >= 173, _Lv =< 173 ->
		[{5,0,1314925}];
get_exp(_Lv) when _Lv >= 174, _Lv =< 174 ->
		[{5,0,1325625}];
get_exp(_Lv) when _Lv >= 175, _Lv =< 175 ->
		[{5,0,1336425}];
get_exp(_Lv) when _Lv >= 176, _Lv =< 176 ->
		[{5,0,1347300}];
get_exp(_Lv) when _Lv >= 177, _Lv =< 177 ->
		[{5,0,1358275}];
get_exp(_Lv) when _Lv >= 178, _Lv =< 178 ->
		[{5,0,1369350}];
get_exp(_Lv) when _Lv >= 179, _Lv =< 179 ->
		[{5,0,1380475}];
get_exp(_Lv) when _Lv >= 180, _Lv =< 180 ->
		[{5,0,1391700}];
get_exp(_Lv) when _Lv >= 181, _Lv =< 181 ->
		[{5,0,1403075}];
get_exp(_Lv) when _Lv >= 182, _Lv =< 182 ->
		[{5,0,1414500}];
get_exp(_Lv) when _Lv >= 183, _Lv =< 183 ->
		[{5,0,1426000}];
get_exp(_Lv) when _Lv >= 184, _Lv =< 184 ->
		[{5,0,1437625}];
get_exp(_Lv) when _Lv >= 185, _Lv =< 185 ->
		[{5,0,1449300}];
get_exp(_Lv) when _Lv >= 186, _Lv =< 186 ->
		[{5,0,1461100}];
get_exp(_Lv) when _Lv >= 187, _Lv =< 187 ->
		[{5,0,1473000}];
get_exp(_Lv) when _Lv >= 188, _Lv =< 188 ->
		[{5,0,1485000}];
get_exp(_Lv) when _Lv >= 189, _Lv =< 189 ->
		[{5,0,1497100}];
get_exp(_Lv) when _Lv >= 190, _Lv =< 190 ->
		[{5,0,1509300}];
get_exp(_Lv) when _Lv >= 191, _Lv =< 191 ->
		[{5,0,1521575}];
get_exp(_Lv) when _Lv >= 192, _Lv =< 192 ->
		[{5,0,1533975}];
get_exp(_Lv) when _Lv >= 193, _Lv =< 193 ->
		[{5,0,1546450}];
get_exp(_Lv) when _Lv >= 194, _Lv =< 194 ->
		[{5,0,1559050}];
get_exp(_Lv) when _Lv >= 195, _Lv =< 195 ->
		[{5,0,1571725}];
get_exp(_Lv) when _Lv >= 196, _Lv =< 196 ->
		[{5,0,1584525}];
get_exp(_Lv) when _Lv >= 197, _Lv =< 197 ->
		[{5,0,1597425}];
get_exp(_Lv) when _Lv >= 198, _Lv =< 198 ->
		[{5,0,1610450}];
get_exp(_Lv) when _Lv >= 199, _Lv =< 199 ->
		[{5,0,1623550}];
get_exp(_Lv) when _Lv >= 200, _Lv =< 200 ->
		[{5,0,1636775}];
get_exp(_Lv) when _Lv >= 201, _Lv =< 201 ->
		[{5,0,1650100}];
get_exp(_Lv) when _Lv >= 202, _Lv =< 202 ->
		[{5,0,1663550}];
get_exp(_Lv) when _Lv >= 203, _Lv =< 203 ->
		[{5,0,1677100}];
get_exp(_Lv) when _Lv >= 204, _Lv =< 204 ->
		[{5,0,1690725}];
get_exp(_Lv) when _Lv >= 205, _Lv =< 205 ->
		[{5,0,1704525}];
get_exp(_Lv) when _Lv >= 206, _Lv =< 206 ->
		[{5,0,1718375}];
get_exp(_Lv) when _Lv >= 207, _Lv =< 207 ->
		[{5,0,1732375}];
get_exp(_Lv) when _Lv >= 208, _Lv =< 208 ->
		[{5,0,1746500}];
get_exp(_Lv) when _Lv >= 209, _Lv =< 209 ->
		[{5,0,1760700}];
get_exp(_Lv) when _Lv >= 210, _Lv =< 210 ->
		[{5,0,1775050}];
get_exp(_Lv) when _Lv >= 211, _Lv =< 211 ->
		[{5,0,1789475}];
get_exp(_Lv) when _Lv >= 212, _Lv =< 212 ->
		[{5,0,1804075}];
get_exp(_Lv) when _Lv >= 213, _Lv =< 213 ->
		[{5,0,1818750}];
get_exp(_Lv) when _Lv >= 214, _Lv =< 214 ->
		[{5,0,1833575}];
get_exp(_Lv) when _Lv >= 215, _Lv =< 215 ->
		[{5,0,1848475}];
get_exp(_Lv) when _Lv >= 216, _Lv =< 216 ->
		[{5,0,1863525}];
get_exp(_Lv) when _Lv >= 217, _Lv =< 217 ->
		[{5,0,1878700}];
get_exp(_Lv) when _Lv >= 218, _Lv =< 218 ->
		[{5,0,1894000}];
get_exp(_Lv) when _Lv >= 219, _Lv =< 219 ->
		[{5,0,1909450}];
get_exp(_Lv) when _Lv >= 220, _Lv =< 220 ->
		[{5,0,1925000}];
get_exp(_Lv) when _Lv >= 221, _Lv =< 221 ->
		[{5,0,1940650}];
get_exp(_Lv) when _Lv >= 222, _Lv =< 222 ->
		[{5,0,1956475}];
get_exp(_Lv) when _Lv >= 223, _Lv =< 223 ->
		[{5,0,1972375}];
get_exp(_Lv) when _Lv >= 224, _Lv =< 224 ->
		[{5,0,1988450}];
get_exp(_Lv) when _Lv >= 225, _Lv =< 225 ->
		[{5,0,2004625}];
get_exp(_Lv) when _Lv >= 226, _Lv =< 226 ->
		[{5,0,2020950}];
get_exp(_Lv) when _Lv >= 227, _Lv =< 227 ->
		[{5,0,2037425}];
get_exp(_Lv) when _Lv >= 228, _Lv =< 228 ->
		[{5,0,2054000}];
get_exp(_Lv) when _Lv >= 229, _Lv =< 229 ->
		[{5,0,2070725}];
get_exp(_Lv) when _Lv >= 230, _Lv =< 230 ->
		[{5,0,2087600}];
get_exp(_Lv) when _Lv >= 231, _Lv =< 231 ->
		[{5,0,2104600}];
get_exp(_Lv) when _Lv >= 232, _Lv =< 232 ->
		[{5,0,2121725}];
get_exp(_Lv) when _Lv >= 233, _Lv =< 233 ->
		[{5,0,2139000}];
get_exp(_Lv) when _Lv >= 234, _Lv =< 234 ->
		[{5,0,2156425}];
get_exp(_Lv) when _Lv >= 235, _Lv =< 235 ->
		[{5,0,2173975}];
get_exp(_Lv) when _Lv >= 236, _Lv =< 236 ->
		[{5,0,2191675}];
get_exp(_Lv) when _Lv >= 237, _Lv =< 237 ->
		[{5,0,2209525}];
get_exp(_Lv) when _Lv >= 238, _Lv =< 238 ->
		[{5,0,2227525}];
get_exp(_Lv) when _Lv >= 239, _Lv =< 239 ->
		[{5,0,2245650}];
get_exp(_Lv) when _Lv >= 240, _Lv =< 240 ->
		[{5,0,2263925}];
get_exp(_Lv) when _Lv >= 241, _Lv =< 241 ->
		[{5,0,2282375}];
get_exp(_Lv) when _Lv >= 242, _Lv =< 242 ->
		[{5,0,2300950}];
get_exp(_Lv) when _Lv >= 243, _Lv =< 243 ->
		[{5,0,2319700}];
get_exp(_Lv) when _Lv >= 244, _Lv =< 244 ->
		[{5,0,2338575}];
get_exp(_Lv) when _Lv >= 245, _Lv =< 245 ->
		[{5,0,2357600}];
get_exp(_Lv) when _Lv >= 246, _Lv =< 246 ->
		[{5,0,2376825}];
get_exp(_Lv) when _Lv >= 247, _Lv =< 247 ->
		[{5,0,2396175}];
get_exp(_Lv) when _Lv >= 248, _Lv =< 248 ->
		[{5,0,2415675}];
get_exp(_Lv) when _Lv >= 249, _Lv =< 249 ->
		[{5,0,2435350}];
get_exp(_Lv) when _Lv >= 250, _Lv =< 250 ->
		[{5,0,2455175}];
get_exp(_Lv) when _Lv >= 251, _Lv =< 251 ->
		[{5,0,2475175}];
get_exp(_Lv) when _Lv >= 252, _Lv =< 252 ->
		[{5,0,2495325}];
get_exp(_Lv) when _Lv >= 253, _Lv =< 253 ->
		[{5,0,2515650}];
get_exp(_Lv) when _Lv >= 254, _Lv =< 254 ->
		[{5,0,2536125}];
get_exp(_Lv) when _Lv >= 255, _Lv =< 255 ->
		[{5,0,2556775}];
get_exp(_Lv) when _Lv >= 256, _Lv =< 256 ->
		[{5,0,2577575}];
get_exp(_Lv) when _Lv >= 257, _Lv =< 257 ->
		[{5,0,2598600}];
get_exp(_Lv) when _Lv >= 258, _Lv =< 258 ->
		[{5,0,2619725}];
get_exp(_Lv) when _Lv >= 259, _Lv =< 259 ->
		[{5,0,2641075}];
get_exp(_Lv) when _Lv >= 260, _Lv =< 260 ->
		[{5,0,2662575}];
get_exp(_Lv) when _Lv >= 261, _Lv =< 261 ->
		[{5,0,2684250}];
get_exp(_Lv) when _Lv >= 262, _Lv =< 262 ->
		[{5,0,2706100}];
get_exp(_Lv) when _Lv >= 263, _Lv =< 263 ->
		[{5,0,2728150}];
get_exp(_Lv) when _Lv >= 264, _Lv =< 264 ->
		[{5,0,2750350}];
get_exp(_Lv) when _Lv >= 265, _Lv =< 265 ->
		[{5,0,2772750}];
get_exp(_Lv) when _Lv >= 266, _Lv =< 266 ->
		[{5,0,2795325}];
get_exp(_Lv) when _Lv >= 267, _Lv =< 267 ->
		[{5,0,2818075}];
get_exp(_Lv) when _Lv >= 268, _Lv =< 268 ->
		[{5,0,2841050}];
get_exp(_Lv) when _Lv >= 269, _Lv =< 269 ->
		[{5,0,2864175}];
get_exp(_Lv) when _Lv >= 270, _Lv =< 270 ->
		[{5,0,2887500}];
get_exp(_Lv) when _Lv >= 271, _Lv =< 271 ->
		[{5,0,2910975}];
get_exp(_Lv) when _Lv >= 272, _Lv =< 272 ->
		[{5,0,2934700}];
get_exp(_Lv) when _Lv >= 273, _Lv =< 273 ->
		[{5,0,2958600}];
get_exp(_Lv) when _Lv >= 274, _Lv =< 274 ->
		[{5,0,2982700}];
get_exp(_Lv) when _Lv >= 275, _Lv =< 275 ->
		[{5,0,3006975}];
get_exp(_Lv) when _Lv >= 276, _Lv =< 276 ->
		[{5,0,3031450}];
get_exp(_Lv) when _Lv >= 277, _Lv =< 277 ->
		[{5,0,3056125}];
get_exp(_Lv) when _Lv >= 278, _Lv =< 278 ->
		[{5,0,3081025}];
get_exp(_Lv) when _Lv >= 279, _Lv =< 279 ->
		[{5,0,3106125}];
get_exp(_Lv) when _Lv >= 280, _Lv =< 280 ->
		[{5,0,3131400}];
get_exp(_Lv) when _Lv >= 281, _Lv =< 281 ->
		[{5,0,3156900}];
get_exp(_Lv) when _Lv >= 282, _Lv =< 282 ->
		[{5,0,3182600}];
get_exp(_Lv) when _Lv >= 283, _Lv =< 283 ->
		[{5,0,3208400}];
get_exp(_Lv) when _Lv >= 284, _Lv =< 284 ->
		[{5,0,3234750}];
get_exp(_Lv) when _Lv >= 285, _Lv =< 285 ->
		[{5,0,3261025}];
get_exp(_Lv) when _Lv >= 286, _Lv =< 286 ->
		[{5,0,3287450}];
get_exp(_Lv) when _Lv >= 287, _Lv =< 287 ->
		[{5,0,3314325}];
get_exp(_Lv) when _Lv >= 288, _Lv =< 288 ->
		[{5,0,3341350}];
get_exp(_Lv) when _Lv >= 289, _Lv =< 289 ->
		[{5,0,3368550}];
get_exp(_Lv) when _Lv >= 290, _Lv =< 290 ->
		[{5,0,3395925}];
get_exp(_Lv) when _Lv >= 291, _Lv =< 291 ->
		[{5,0,3423450}];
get_exp(_Lv) when _Lv >= 292, _Lv =< 292 ->
		[{5,0,3451425}];
get_exp(_Lv) when _Lv >= 293, _Lv =< 293 ->
		[{5,0,3479575}];
get_exp(_Lv) when _Lv >= 294, _Lv =< 294 ->
		[{5,0,3507900}];
get_exp(_Lv) when _Lv >= 295, _Lv =< 295 ->
		[{5,0,3536425}];
get_exp(_Lv) when _Lv >= 296, _Lv =< 296 ->
		[{5,0,3565100}];
get_exp(_Lv) when _Lv >= 297, _Lv =< 297 ->
		[{5,0,3594225}];
get_exp(_Lv) when _Lv >= 298, _Lv =< 298 ->
		[{5,0,3623525}];
get_exp(_Lv) when _Lv >= 299, _Lv =< 299 ->
		[{5,0,3653025}];
get_exp(_Lv) when _Lv >= 300, _Lv =< 300 ->
		[{5,0,3682700}];
get_exp(_Lv) when _Lv >= 301, _Lv =< 301 ->
		[{5,0,3712800}];
get_exp(_Lv) when _Lv >= 302, _Lv =< 302 ->
		[{5,0,3742875}];
get_exp(_Lv) when _Lv >= 303, _Lv =< 303 ->
		[{5,0,3773375}];
get_exp(_Lv) when _Lv >= 304, _Lv =< 304 ->
		[{5,0,3804050}];
get_exp(_Lv) when _Lv >= 305, _Lv =< 305 ->
		[{5,0,3835200}];
get_exp(_Lv) when _Lv >= 306, _Lv =< 306 ->
		[{5,0,3866275}];
get_exp(_Lv) when _Lv >= 307, _Lv =< 307 ->
		[{5,0,3897800}];
get_exp(_Lv) when _Lv >= 308, _Lv =< 308 ->
		[{5,0,3929525}];
get_exp(_Lv) when _Lv >= 309, _Lv =< 309 ->
		[{5,0,3961475}];
get_exp(_Lv) when _Lv >= 310, _Lv =< 310 ->
		[{5,0,3993850}];
get_exp(_Lv) when _Lv >= 311, _Lv =< 311 ->
		[{5,0,4026450}];
get_exp(_Lv) when _Lv >= 312, _Lv =< 312 ->
		[{5,0,4058975}];
get_exp(_Lv) when _Lv >= 313, _Lv =< 313 ->
		[{5,0,4092250}];
get_exp(_Lv) when _Lv >= 314, _Lv =< 314 ->
		[{5,0,4125450}];
get_exp(_Lv) when _Lv >= 315, _Lv =< 315 ->
		[{5,0,4159125}];
get_exp(_Lv) when _Lv >= 316, _Lv =< 316 ->
		[{5,0,4193025}];
get_exp(_Lv) when _Lv >= 317, _Lv =< 317 ->
		[{5,0,4227125}];
get_exp(_Lv) when _Lv >= 318, _Lv =< 318 ->
		[{5,0,4261450}];
get_exp(_Lv) when _Lv >= 319, _Lv =< 319 ->
		[{5,0,4296225}];
get_exp(_Lv) when _Lv >= 320, _Lv =< 320 ->
		[{5,0,4331250}];
get_exp(_Lv) when _Lv >= 321, _Lv =< 321 ->
		[{5,0,4366475}];
get_exp(_Lv) when _Lv >= 322, _Lv =< 322 ->
		[{5,0,4401925}];
get_exp(_Lv) when _Lv >= 323, _Lv =< 323 ->
		[{5,0,4437850}];
get_exp(_Lv) when _Lv >= 324, _Lv =< 324 ->
		[{5,0,4474000}];
get_exp(_Lv) when _Lv >= 325, _Lv =< 325 ->
		[{5,0,4510400}];
get_exp(_Lv) when _Lv >= 326, _Lv =< 326 ->
		[{5,0,4547250}];
get_exp(_Lv) when _Lv >= 327, _Lv =< 327 ->
		[{5,0,4584100}];
get_exp(_Lv) when _Lv >= 328, _Lv =< 328 ->
		[{5,0,4621450}];
get_exp(_Lv) when _Lv >= 329, _Lv =< 329 ->
		[{5,0,4659275}];
get_exp(_Lv) when _Lv >= 330, _Lv =< 330 ->
		[{5,0,4697075}];
get_exp(_Lv) when _Lv >= 331, _Lv =< 331 ->
		[{5,0,4735375}];
get_exp(_Lv) when _Lv >= 332, _Lv =< 332 ->
		[{5,0,4773925}];
get_exp(_Lv) when _Lv >= 333, _Lv =< 333 ->
		[{5,0,4812725}];
get_exp(_Lv) when _Lv >= 334, _Lv =< 334 ->
		[{5,0,4852000}];
get_exp(_Lv) when _Lv >= 335, _Lv =< 335 ->
		[{5,0,4891525}];
get_exp(_Lv) when _Lv >= 336, _Lv =< 336 ->
		[{5,0,4931325}];
get_exp(_Lv) when _Lv >= 337, _Lv =< 337 ->
		[{5,0,4971350}];
get_exp(_Lv) when _Lv >= 338, _Lv =< 338 ->
		[{5,0,5011900}];
get_exp(_Lv) when _Lv >= 339, _Lv =< 339 ->
		[{5,0,5052700}];
get_exp(_Lv) when _Lv >= 340, _Lv =< 340 ->
		[{5,0,5093750}];
get_exp(_Lv) when _Lv >= 341, _Lv =< 341 ->
		[{5,0,5135325}];
get_exp(_Lv) when _Lv >= 342, _Lv =< 342 ->
		[{5,0,5177150}];
get_exp(_Lv) when _Lv >= 343, _Lv =< 343 ->
		[{5,0,5219250}];
get_exp(_Lv) when _Lv >= 344, _Lv =< 344 ->
		[{5,0,5261875}];
get_exp(_Lv) when _Lv >= 345, _Lv =< 345 ->
		[{5,0,5304750}];
get_exp(_Lv) when _Lv >= 346, _Lv =< 346 ->
		[{5,0,5347900}];
get_exp(_Lv) when _Lv >= 347, _Lv =< 347 ->
		[{5,0,5391350}];
get_exp(_Lv) when _Lv >= 348, _Lv =< 348 ->
		[{5,0,5435300}];
get_exp(_Lv) when _Lv >= 349, _Lv =< 349 ->
		[{5,0,5479525}];
get_exp(_Lv) when _Lv >= 350, _Lv =< 350 ->
		[{5,0,5524050}];
get_exp(_Lv) when _Lv >= 351, _Lv =< 351 ->
		[{5,0,5569100}];
get_exp(_Lv) when _Lv >= 352, _Lv =< 352 ->
		[{5,0,5614425}];
get_exp(_Lv) when _Lv >= 353, _Lv =< 353 ->
		[{5,0,5660300}];
get_exp(_Lv) when _Lv >= 354, _Lv =< 354 ->
		[{5,0,5706200}];
get_exp(_Lv) when _Lv >= 355, _Lv =< 355 ->
		[{5,0,5752675}];
get_exp(_Lv) when _Lv >= 356, _Lv =< 356 ->
		[{5,0,5799675}];
get_exp(_Lv) when _Lv >= 357, _Lv =< 357 ->
		[{5,0,5846700}];
get_exp(_Lv) when _Lv >= 358, _Lv =< 358 ->
		[{5,0,5894300}];
get_exp(_Lv) when _Lv >= 359, _Lv =< 359 ->
		[{5,0,5942450}];
get_exp(_Lv) when _Lv >= 360, _Lv =< 360 ->
		[{5,0,5990650}];
get_exp(_Lv) when _Lv >= 361, _Lv =< 361 ->
		[{5,0,6039425}];
get_exp(_Lv) when _Lv >= 362, _Lv =< 362 ->
		[{5,0,6088725}];
get_exp(_Lv) when _Lv >= 363, _Lv =< 363 ->
		[{5,0,6138375}];
get_exp(_Lv) when _Lv >= 364, _Lv =< 364 ->
		[{5,0,6188325}];
get_exp(_Lv) when _Lv >= 365, _Lv =< 365 ->
		[{5,0,6238575}];
get_exp(_Lv) when _Lv >= 366, _Lv =< 366 ->
		[{5,0,6289400}];
get_exp(_Lv) when _Lv >= 367, _Lv =< 367 ->
		[{5,0,6340825}];
get_exp(_Lv) when _Lv >= 368, _Lv =< 368 ->
		[{5,0,6392300}];
get_exp(_Lv) when _Lv >= 369, _Lv =< 369 ->
		[{5,0,6444350}];
get_exp(_Lv) when _Lv >= 370, _Lv =< 370 ->
		[{5,0,6497000}];
get_exp(_Lv) when _Lv >= 371, _Lv =< 371 ->
		[{5,0,6549700}];
get_exp(_Lv) when _Lv >= 372, _Lv =< 372 ->
		[{5,0,6603025}];
get_exp(_Lv) when _Lv >= 373, _Lv =< 373 ->
		[{5,0,6656900}];
get_exp(_Lv) when _Lv >= 374, _Lv =< 374 ->
		[{5,0,6710900}];
get_exp(_Lv) when _Lv >= 375, _Lv =< 375 ->
		[{5,0,6765725}];
get_exp(_Lv) when _Lv >= 376, _Lv =< 376 ->
		[{5,0,6820650}];
get_exp(_Lv) when _Lv >= 377, _Lv =< 377 ->
		[{5,0,6876175}];
get_exp(_Lv) when _Lv >= 378, _Lv =< 378 ->
		[{5,0,6932300}];
get_exp(_Lv) when _Lv >= 379, _Lv =< 379 ->
		[{5,0,6988775}];
get_exp(_Lv) when _Lv >= 380, _Lv =< 380 ->
		[{5,0,7045625}];
get_exp(_Lv) when _Lv >= 381, _Lv =< 381 ->
		[{5,0,7103075}];
get_exp(_Lv) when _Lv >= 382, _Lv =< 382 ->
		[{5,0,7160900}];
get_exp(_Lv) when _Lv >= 383, _Lv =< 383 ->
		[{5,0,7219075}];
get_exp(_Lv) when _Lv >= 384, _Lv =< 384 ->
		[{5,0,7277875}];
get_exp(_Lv) when _Lv >= 385, _Lv =< 385 ->
		[{5,0,7337300}];
get_exp(_Lv) when _Lv >= 386, _Lv =< 386 ->
		[{5,0,7396850}];
get_exp(_Lv) when _Lv >= 387, _Lv =< 387 ->
		[{5,0,7457300}];
get_exp(_Lv) when _Lv >= 388, _Lv =< 388 ->
		[{5,0,7517850}];
get_exp(_Lv) when _Lv >= 389, _Lv =< 389 ->
		[{5,0,7579050}];
get_exp(_Lv) when _Lv >= 390, _Lv =< 390 ->
		[{5,0,7640900}];
get_exp(_Lv) when _Lv >= 391, _Lv =< 391 ->
		[{5,0,7703125}];
get_exp(_Lv) when _Lv >= 392, _Lv =< 392 ->
		[{5,0,7765750}];
get_exp(_Lv) when _Lv >= 393, _Lv =< 393 ->
		[{5,0,7829000}];
get_exp(_Lv) when _Lv >= 394, _Lv =< 394 ->
		[{5,0,7892675}];
get_exp(_Lv) when _Lv >= 395, _Lv =< 395 ->
		[{5,0,7957000}];
get_exp(_Lv) when _Lv >= 396, _Lv =< 396 ->
		[{5,0,8021750}];
get_exp(_Lv) when _Lv >= 397, _Lv =< 397 ->
		[{5,0,8087150}];
get_exp(_Lv) when _Lv >= 398, _Lv =< 398 ->
		[{5,0,8152950}];
get_exp(_Lv) when _Lv >= 399, _Lv =< 399 ->
		[{5,0,8219175}];
get_exp(_Lv) when _Lv >= 400, _Lv =< 400 ->
		[{5,0,8286325}];
get_exp(_Lv) when _Lv >= 401, _Lv =< 401 ->
		[{5,0,8353650}];
get_exp(_Lv) when _Lv >= 402, _Lv =< 402 ->
		[{5,0,8421650}];
get_exp(_Lv) when _Lv >= 403, _Lv =< 403 ->
		[{5,0,8490325}];
get_exp(_Lv) when _Lv >= 404, _Lv =< 404 ->
		[{5,0,8559450}];
get_exp(_Lv) when _Lv >= 405, _Lv =< 405 ->
		[{5,0,8629250}];
get_exp(_Lv) when _Lv >= 406, _Lv =< 406 ->
		[{5,0,8699500}];
get_exp(_Lv) when _Lv >= 407, _Lv =< 407 ->
		[{5,0,8770200}];
get_exp(_Lv) when _Lv >= 408, _Lv =< 408 ->
		[{5,0,8841600}];
get_exp(_Lv) when _Lv >= 409, _Lv =< 409 ->
		[{5,0,8913700}];
get_exp(_Lv) when _Lv >= 410, _Lv =< 410 ->
		[{5,0,8986250}];
get_exp(_Lv) when _Lv >= 411, _Lv =< 411 ->
		[{5,0,9059250}];
get_exp(_Lv) when _Lv >= 412, _Lv =< 412 ->
		[{5,0,9132975}];
get_exp(_Lv) when _Lv >= 413, _Lv =< 413 ->
		[{5,0,9207425}];
get_exp(_Lv) when _Lv >= 414, _Lv =< 414 ->
		[{5,0,9282350}];
get_exp(_Lv) when _Lv >= 415, _Lv =< 415 ->
		[{5,0,9358000}];
get_exp(_Lv) when _Lv >= 416, _Lv =< 416 ->
		[{5,0,9434125}];
get_exp(_Lv) when _Lv >= 417, _Lv =< 417 ->
		[{5,0,9510975}];
get_exp(_Lv) when _Lv >= 418, _Lv =< 418 ->
		[{5,0,9588575}];
get_exp(_Lv) when _Lv >= 419, _Lv =< 419 ->
		[{5,0,9666650}];
get_exp(_Lv) when _Lv >= 420, _Lv =< 420 ->
		[{5,0,9745250}];
get_exp(_Lv) when _Lv >= 421, _Lv =< 421 ->
		[{5,0,9824575}];
get_exp(_Lv) when _Lv >= 422, _Lv =< 422 ->
		[{5,0,9904650}];
get_exp(_Lv) when _Lv >= 423, _Lv =< 423 ->
		[{5,0,9985250}];
get_exp(_Lv) when _Lv >= 424, _Lv =< 424 ->
		[{5,0,10066600}];
get_exp(_Lv) when _Lv >= 425, _Lv =< 425 ->
		[{5,0,10148475}];
get_exp(_Lv) when _Lv >= 426, _Lv =< 426 ->
		[{5,0,10231100}];
get_exp(_Lv) when _Lv >= 427, _Lv =< 427 ->
		[{5,0,10314525}];
get_exp(_Lv) when _Lv >= 428, _Lv =< 428 ->
		[{5,0,10398450}];
get_exp(_Lv) when _Lv >= 429, _Lv =< 429 ->
		[{5,0,10483175}];
get_exp(_Lv) when _Lv >= 430, _Lv =< 430 ->
		[{5,0,10568450}];
get_exp(_Lv) when _Lv >= 431, _Lv =< 431 ->
		[{5,0,10654500}];
get_exp(_Lv) when _Lv >= 432, _Lv =< 432 ->
		[{5,0,10741350}];
get_exp(_Lv) when _Lv >= 433, _Lv =< 433 ->
		[{5,0,10828750}];
get_exp(_Lv) when _Lv >= 434, _Lv =< 434 ->
		[{5,0,10916950}];
get_exp(_Lv) when _Lv >= 435, _Lv =< 435 ->
		[{5,0,11005725}];
get_exp(_Lv) when _Lv >= 436, _Lv =< 436 ->
		[{5,0,11095550}];
get_exp(_Lv) when _Lv >= 437, _Lv =< 437 ->
		[{5,0,11185700}];
get_exp(_Lv) when _Lv >= 438, _Lv =< 438 ->
		[{5,0,11276900}];
get_exp(_Lv) when _Lv >= 439, _Lv =< 439 ->
		[{5,0,11368700}];
get_exp(_Lv) when _Lv >= 440, _Lv =< 440 ->
		[{5,0,11461350}];
get_exp(_Lv) when _Lv >= 441, _Lv =< 441 ->
		[{5,0,11554550}];
get_exp(_Lv) when _Lv >= 442, _Lv =< 442 ->
		[{5,0,11648625}];
get_exp(_Lv) when _Lv >= 443, _Lv =< 443 ->
		[{5,0,11743525}];
get_exp(_Lv) when _Lv >= 444, _Lv =< 444 ->
		[{5,0,11839025}];
get_exp(_Lv) when _Lv >= 445, _Lv =< 445 ->
		[{5,0,11935400}];
get_exp(_Lv) when _Lv >= 446, _Lv =< 446 ->
		[{5,0,12032625}];
get_exp(_Lv) when _Lv >= 447, _Lv =< 447 ->
		[{5,0,12130725}];
get_exp(_Lv) when _Lv >= 448, _Lv =< 448 ->
		[{5,0,12229425}];
get_exp(_Lv) when _Lv >= 449, _Lv =< 449 ->
		[{5,0,12329025}];
get_exp(_Lv) when _Lv >= 450, _Lv =< 450 ->
		[{5,0,12429500}];
get_exp(_Lv) when _Lv >= 451, _Lv =< 451 ->
		[{5,0,12530600}];
get_exp(_Lv) when _Lv >= 452, _Lv =< 452 ->
		[{5,0,12632600}];
get_exp(_Lv) when _Lv >= 453, _Lv =< 453 ->
		[{5,0,12735500}];
get_exp(_Lv) when _Lv >= 454, _Lv =< 454 ->
		[{5,0,12839050}];
get_exp(_Lv) when _Lv >= 455, _Lv =< 455 ->
		[{5,0,12943775}];
get_exp(_Lv) when _Lv >= 456, _Lv =< 456 ->
		[{5,0,13049150}];
get_exp(_Lv) when _Lv >= 457, _Lv =< 457 ->
		[{5,0,13155425}];
get_exp(_Lv) when _Lv >= 458, _Lv =< 458 ->
		[{5,0,13262400}];
get_exp(_Lv) when _Lv >= 459, _Lv =< 459 ->
		[{5,0,13370550}];
get_exp(_Lv) when _Lv >= 460, _Lv =< 460 ->
		[{5,0,13479375}];
get_exp(_Lv) when _Lv >= 461, _Lv =< 461 ->
		[{5,0,13589150}];
get_exp(_Lv) when _Lv >= 462, _Lv =< 462 ->
		[{5,0,13699600}];
get_exp(_Lv) when _Lv >= 463, _Lv =< 463 ->
		[{5,0,13811275}];
get_exp(_Lv) when _Lv >= 464, _Lv =< 464 ->
		[{5,0,13923650}];
get_exp(_Lv) when _Lv >= 465, _Lv =< 465 ->
		[{5,0,14037000}];
get_exp(_Lv) when _Lv >= 466, _Lv =< 466 ->
		[{5,0,14151300}];
get_exp(_Lv) when _Lv >= 467, _Lv =< 467 ->
		[{5,0,14266600}];
get_exp(_Lv) when _Lv >= 468, _Lv =< 468 ->
		[{5,0,14382875}];
get_exp(_Lv) when _Lv >= 469, _Lv =< 469 ->
		[{5,0,14499875}];
get_exp(_Lv) when _Lv >= 470, _Lv =< 470 ->
		[{5,0,14617875}];
get_exp(_Lv) when _Lv >= 471, _Lv =< 471 ->
		[{5,0,14736850}];
get_exp(_Lv) when _Lv >= 472, _Lv =< 472 ->
		[{5,0,14856850}];
get_exp(_Lv) when _Lv >= 473, _Lv =< 473 ->
		[{5,0,14977875}];
get_exp(_Lv) when _Lv >= 474, _Lv =< 474 ->
		[{5,0,15099900}];
get_exp(_Lv) when _Lv >= 475, _Lv =< 475 ->
		[{5,0,15222700}];
get_exp(_Lv) when _Lv >= 476, _Lv =< 476 ->
		[{5,0,15346775}];
get_exp(_Lv) when _Lv >= 477, _Lv =< 477 ->
		[{5,0,15471650}];
get_exp(_Lv) when _Lv >= 478, _Lv =< 478 ->
		[{5,0,15597825}];
get_exp(_Lv) when _Lv >= 479, _Lv =< 479 ->
		[{5,0,15724775}];
get_exp(_Lv) when _Lv >= 480, _Lv =< 480 ->
		[{5,0,15852800}];
get_exp(_Lv) when _Lv >= 481, _Lv =< 481 ->
		[{5,0,15981875}];
get_exp(_Lv) when _Lv >= 482, _Lv =< 482 ->
		[{5,0,16112025}];
get_exp(_Lv) when _Lv >= 483, _Lv =< 483 ->
		[{5,0,16243250}];
get_exp(_Lv) when _Lv >= 484, _Lv =< 484 ->
		[{5,0,16375300}];
get_exp(_Lv) when _Lv >= 485, _Lv =< 485 ->
		[{5,0,16508700}];
get_exp(_Lv) when _Lv >= 486, _Lv =< 486 ->
		[{5,0,16643200}];
get_exp(_Lv) when _Lv >= 487, _Lv =< 487 ->
		[{5,0,16778550}];
get_exp(_Lv) when _Lv >= 488, _Lv =< 488 ->
		[{5,0,16915250}];
get_exp(_Lv) when _Lv >= 489, _Lv =< 489 ->
		[{5,0,17053075}];
get_exp(_Lv) when _Lv >= 490, _Lv =< 490 ->
		[{5,0,17191775}];
get_exp(_Lv) when _Lv >= 491, _Lv =< 491 ->
		[{5,0,17331850}];
get_exp(_Lv) when _Lv >= 492, _Lv =< 492 ->
		[{5,0,17473050}];
get_exp(_Lv) when _Lv >= 493, _Lv =< 493 ->
		[{5,0,17615175}];
get_exp(_Lv) when _Lv >= 494, _Lv =< 494 ->
		[{5,0,17758675}];
get_exp(_Lv) when _Lv >= 495, _Lv =< 495 ->
		[{5,0,17903350}];
get_exp(_Lv) when _Lv >= 496, _Lv =< 496 ->
		[{5,0,18048925}];
get_exp(_Lv) when _Lv >= 497, _Lv =< 497 ->
		[{5,0,18195950}];
get_exp(_Lv) when _Lv >= 498, _Lv =< 498 ->
		[{5,0,18344150}];
get_exp(_Lv) when _Lv >= 499, _Lv =< 499 ->
		[{5,0,18493525}];
get_exp(_Lv) when _Lv >= 500, _Lv =< 500 ->
		[{5,0,18644125}];
get_exp(_Lv) when _Lv >= 501, _Lv =< 501 ->
		[{5,0,18795900}];
get_exp(_Lv) when _Lv >= 502, _Lv =< 502 ->
		[{5,0,18948925}];
get_exp(_Lv) when _Lv >= 503, _Lv =< 503 ->
		[{5,0,19103125}];
get_exp(_Lv) when _Lv >= 504, _Lv =< 504 ->
		[{5,0,19258850}];
get_exp(_Lv) when _Lv >= 505, _Lv =< 505 ->
		[{5,0,19415525}];
get_exp(_Lv) when _Lv >= 506, _Lv =< 506 ->
		[{5,0,19573725}];
get_exp(_Lv) when _Lv >= 507, _Lv =< 507 ->
		[{5,0,19732900}];
get_exp(_Lv) when _Lv >= 508, _Lv =< 508 ->
		[{5,0,19893600}];
get_exp(_Lv) when _Lv >= 509, _Lv =< 509 ->
		[{5,0,20055575}];
get_exp(_Lv) when _Lv >= 510, _Lv =< 510 ->
		[{5,0,20219075}];
get_exp(_Lv) when _Lv >= 511, _Lv =< 511 ->
		[{5,0,20383600}];
get_exp(_Lv) when _Lv >= 512, _Lv =< 512 ->
		[{5,0,20549675}];
get_exp(_Lv) when _Lv >= 513, _Lv =< 513 ->
		[{5,0,20716800}];
get_exp(_Lv) when _Lv >= 514, _Lv =< 514 ->
		[{5,0,20885500}];
get_exp(_Lv) when _Lv >= 515, _Lv =< 515 ->
		[{5,0,21055750}];
get_exp(_Lv) when _Lv >= 516, _Lv =< 516 ->
		[{5,0,21227100}];
get_exp(_Lv) when _Lv >= 517, _Lv =< 517 ->
		[{5,0,21400025}];
get_exp(_Lv) when _Lv >= 518, _Lv =< 518 ->
		[{5,0,21574050}];
get_exp(_Lv) when _Lv >= 519, _Lv =< 519 ->
		[{5,0,21749675}];
get_exp(_Lv) when _Lv >= 520, _Lv =< 520 ->
		[{5,0,21926925}];
get_exp(_Lv) when _Lv >= 521, _Lv =< 521 ->
		[{5,0,22105550}];
get_exp(_Lv) when _Lv >= 522, _Lv =< 522 ->
		[{5,0,22285550}];
get_exp(_Lv) when _Lv >= 523, _Lv =< 523 ->
		[{5,0,22466925}];
get_exp(_Lv) when _Lv >= 524, _Lv =< 524 ->
		[{5,0,22649725}];
get_exp(_Lv) when _Lv >= 525, _Lv =< 525 ->
		[{5,0,22834175}];
get_exp(_Lv) when _Lv >= 526, _Lv =< 526 ->
		[{5,0,23020050}];
get_exp(_Lv) when _Lv >= 527, _Lv =< 527 ->
		[{5,0,23207625}];
get_exp(_Lv) when _Lv >= 528, _Lv =< 528 ->
		[{5,0,23396600}];
get_exp(_Lv) when _Lv >= 529, _Lv =< 529 ->
		[{5,0,23587050}];
get_exp(_Lv) when _Lv >= 530, _Lv =< 530 ->
		[{5,0,23779200}];
get_exp(_Lv) when _Lv >= 531, _Lv =< 531 ->
		[{5,0,23972825}];
get_exp(_Lv) when _Lv >= 532, _Lv =< 532 ->
		[{5,0,24167925}];
get_exp(_Lv) when _Lv >= 533, _Lv =< 533 ->
		[{5,0,24364750}];
get_exp(_Lv) when _Lv >= 534, _Lv =< 534 ->
		[{5,0,24563100}];
get_exp(_Lv) when _Lv >= 535, _Lv =< 535 ->
		[{5,0,24763200}];
get_exp(_Lv) when _Lv >= 536, _Lv =< 536 ->
		[{5,0,24964800}];
get_exp(_Lv) when _Lv >= 537, _Lv =< 537 ->
		[{5,0,25167950}];
get_exp(_Lv) when _Lv >= 538, _Lv =< 538 ->
		[{5,0,25372875}];
get_exp(_Lv) when _Lv >= 539, _Lv =< 539 ->
		[{5,0,25579600}];
get_exp(_Lv) when _Lv >= 540, _Lv =< 540 ->
		[{5,0,25787650}];
get_exp(_Lv) when _Lv >= 541, _Lv =< 541 ->
		[{5,0,25997775}];
get_exp(_Lv) when _Lv >= 542, _Lv =< 542 ->
		[{5,0,26209450}];
get_exp(_Lv) when _Lv >= 543, _Lv =< 543 ->
		[{5,0,26422750}];
get_exp(_Lv) when _Lv >= 544, _Lv =< 544 ->
		[{5,0,26637900}];
get_exp(_Lv) when _Lv >= 545, _Lv =< 545 ->
		[{5,0,26854900}];
get_exp(_Lv) when _Lv >= 546, _Lv =< 546 ->
		[{5,0,27073525}];
get_exp(_Lv) when _Lv >= 547, _Lv =< 547 ->
		[{5,0,27294050}];
get_exp(_Lv) when _Lv >= 548, _Lv =< 548 ->
		[{5,0,27516225}];
get_exp(_Lv) when _Lv >= 549, _Lv =< 549 ->
		[{5,0,27740300}];
get_exp(_Lv) when _Lv >= 550, _Lv =< 550 ->
		[{5,0,27966050}];
get_exp(_Lv) when _Lv >= 551, _Lv =< 551 ->
		[{5,0,28193750}];
get_exp(_Lv) when _Lv >= 552, _Lv =< 552 ->
		[{5,0,28423375}];
get_exp(_Lv) when _Lv >= 553, _Lv =< 553 ->
		[{5,0,28654700}];
get_exp(_Lv) when _Lv >= 554, _Lv =< 554 ->
		[{5,0,28888275}];
get_exp(_Lv) when _Lv >= 555, _Lv =< 555 ->
		[{5,0,29123300}];
get_exp(_Lv) when _Lv >= 556, _Lv =< 556 ->
		[{5,0,29360575}];
get_exp(_Lv) when _Lv >= 557, _Lv =< 557 ->
		[{5,0,29599600}];
get_exp(_Lv) when _Lv >= 558, _Lv =< 558 ->
		[{5,0,29840650}];
get_exp(_Lv) when _Lv >= 559, _Lv =< 559 ->
		[{5,0,30083475}];
get_exp(_Lv) when _Lv >= 560, _Lv =< 560 ->
		[{5,0,30328600}];
get_exp(_Lv) when _Lv >= 561, _Lv =< 561 ->
		[{5,0,30575525}];
get_exp(_Lv) when _Lv >= 562, _Lv =< 562 ->
		[{5,0,30824525}];
get_exp(_Lv) when _Lv >= 563, _Lv =< 563 ->
		[{5,0,31075325}];
get_exp(_Lv) when _Lv >= 564, _Lv =< 564 ->
		[{5,0,31328500}];
get_exp(_Lv) when _Lv >= 565, _Lv =< 565 ->
		[{5,0,31583525}];
get_exp(_Lv) when _Lv >= 566, _Lv =< 566 ->
		[{5,0,31840650}];
get_exp(_Lv) when _Lv >= 567, _Lv =< 567 ->
		[{5,0,32100425}];
get_exp(_Lv) when _Lv >= 568, _Lv =< 568 ->
		[{5,0,32361575}];
get_exp(_Lv) when _Lv >= 569, _Lv =< 569 ->
		[{5,0,32624400}];
get_exp(_Lv) when _Lv >= 570, _Lv =< 570 ->
		[{5,0,32888900}];
get_exp(_Lv) when _Lv >= 571, _Lv =< 571 ->
		[{5,0,33157575}];
get_exp(_Lv) when _Lv >= 572, _Lv =< 572 ->
		[{5,0,33427950}];
get_exp(_Lv) when _Lv >= 573, _Lv =< 573 ->
		[{5,0,33700025}];
get_exp(_Lv) when _Lv >= 574, _Lv =< 574 ->
		[{5,0,33973850}];
get_exp(_Lv) when _Lv >= 575, _Lv =< 575 ->
		[{5,0,34251900}];
get_exp(_Lv) when _Lv >= 576, _Lv =< 576 ->
		[{5,0,34529225}];
get_exp(_Lv) when _Lv >= 577, _Lv =< 577 ->
		[{5,0,34810800}];
get_exp(_Lv) when _Lv >= 578, _Lv =< 578 ->
		[{5,0,35094175}];
get_exp(_Lv) when _Lv >= 579, _Lv =< 579 ->
		[{5,0,35379325}];
get_exp(_Lv) when _Lv >= 580, _Lv =< 580 ->
		[{5,0,35668825}];
get_exp(_Lv) when _Lv >= 581, _Lv =< 581 ->
		[{5,0,35960125}];
get_exp(_Lv) when _Lv >= 582, _Lv =< 582 ->
		[{5,0,36250775}];
get_exp(_Lv) when _Lv >= 583, _Lv =< 583 ->
		[{5,0,36545775}];
get_exp(_Lv) when _Lv >= 584, _Lv =< 584 ->
		[{5,0,36845150}];
get_exp(_Lv) when _Lv >= 585, _Lv =< 585 ->
		[{5,0,37143925}];
get_exp(_Lv) when _Lv >= 586, _Lv =< 586 ->
		[{5,0,37447075}];
get_exp(_Lv) when _Lv >= 587, _Lv =< 587 ->
		[{5,0,37752175}];
get_exp(_Lv) when _Lv >= 588, _Lv =< 588 ->
		[{5,0,38059200}];
get_exp(_Lv) when _Lv >= 589, _Lv =< 589 ->
		[{5,0,38368175}];
get_exp(_Lv) when _Lv >= 590, _Lv =< 590 ->
		[{5,0,38681600}];
get_exp(_Lv) when _Lv >= 591, _Lv =< 591 ->
		[{5,0,38997025}];
get_exp(_Lv) when _Lv >= 592, _Lv =< 592 ->
		[{5,0,39314450}];
get_exp(_Lv) when _Lv >= 593, _Lv =< 593 ->
		[{5,0,39633875}];
get_exp(_Lv) when _Lv >= 594, _Lv =< 594 ->
		[{5,0,39957850}];
get_exp(_Lv) when _Lv >= 595, _Lv =< 595 ->
		[{5,0,40281350}];
get_exp(_Lv) when _Lv >= 596, _Lv =< 596 ->
		[{5,0,40609425}];
get_exp(_Lv) when _Lv >= 597, _Lv =< 597 ->
		[{5,0,40939600}];
get_exp(_Lv) when _Lv >= 598, _Lv =< 598 ->
		[{5,0,41274350}];
get_exp(_Lv) when _Lv >= 599, _Lv =< 599 ->
		[{5,0,41611225}];
get_exp(_Lv) when _Lv >= 600, _Lv =< 600 ->
		[{5,0,41950225}];
get_exp(_Lv) when _Lv >= 601, _Lv =< 601 ->
		[{5,0,42291375}];
get_exp(_Lv) when _Lv >= 602, _Lv =< 602 ->
		[{5,0,42634700}];
get_exp(_Lv) when _Lv >= 603, _Lv =< 603 ->
		[{5,0,42982700}];
get_exp(_Lv) when _Lv >= 604, _Lv =< 604 ->
		[{5,0,43332900}];
get_exp(_Lv) when _Lv >= 605, _Lv =< 605 ->
		[{5,0,43685325}];
get_exp(_Lv) when _Lv >= 606, _Lv =< 606 ->
		[{5,0,44040000}];
get_exp(_Lv) when _Lv >= 607, _Lv =< 607 ->
		[{5,0,44399425}];
get_exp(_Lv) when _Lv >= 608, _Lv =< 608 ->
		[{5,0,44761125}];
get_exp(_Lv) when _Lv >= 609, _Lv =< 609 ->
		[{5,0,45125100}];
get_exp(_Lv) when _Lv >= 610, _Lv =< 610 ->
		[{5,0,45491425}];
get_exp(_Lv) when _Lv >= 611, _Lv =< 611 ->
		[{5,0,45862550}];
get_exp(_Lv) when _Lv >= 612, _Lv =< 612 ->
		[{5,0,46236025}];
get_exp(_Lv) when _Lv >= 613, _Lv =< 613 ->
		[{5,0,46611875}];
get_exp(_Lv) when _Lv >= 614, _Lv =< 614 ->
		[{5,0,46992625}];
get_exp(_Lv) when _Lv >= 615, _Lv =< 615 ->
		[{5,0,47375775}];
get_exp(_Lv) when _Lv >= 616, _Lv =< 616 ->
		[{5,0,47761350}];
get_exp(_Lv) when _Lv >= 617, _Lv =< 617 ->
		[{5,0,48149375}];
get_exp(_Lv) when _Lv >= 618, _Lv =< 618 ->
		[{5,0,48542375}];
get_exp(_Lv) when _Lv >= 619, _Lv =< 619 ->
		[{5,0,48937850}];
get_exp(_Lv) when _Lv >= 620, _Lv =< 620 ->
		[{5,0,49335850}];
get_exp(_Lv) when _Lv >= 621, _Lv =< 621 ->
		[{5,0,49736375}];
get_exp(_Lv) when _Lv >= 622, _Lv =< 622 ->
		[{5,0,50141925}];
get_exp(_Lv) when _Lv >= 623, _Lv =< 623 ->
		[{5,0,50550050}];
get_exp(_Lv) when _Lv >= 624, _Lv =< 624 ->
		[{5,0,50960775}];
get_exp(_Lv) when _Lv >= 625, _Lv =< 625 ->
		[{5,0,51376625}];
get_exp(_Lv) when _Lv >= 626, _Lv =< 626 ->
		[{5,0,51795100}];
get_exp(_Lv) when _Lv >= 627, _Lv =< 627 ->
		[{5,0,52216225}];
get_exp(_Lv) when _Lv >= 628, _Lv =< 628 ->
		[{5,0,52642525}];
get_exp(_Lv) when _Lv >= 629, _Lv =< 629 ->
		[{5,0,53071500}];
get_exp(_Lv) when _Lv >= 630, _Lv =< 630 ->
		[{5,0,53503225}];
get_exp(_Lv) when _Lv >= 631, _Lv =< 631 ->
		[{5,0,53937675}];
get_exp(_Lv) when _Lv >= 632, _Lv =< 632 ->
		[{5,0,54377400}];
get_exp(_Lv) when _Lv >= 633, _Lv =< 633 ->
		[{5,0,54819900}];
get_exp(_Lv) when _Lv >= 634, _Lv =< 634 ->
		[{5,0,55267725}];
get_exp(_Lv) when _Lv >= 635, _Lv =< 635 ->
		[{5,0,55715875}];
get_exp(_Lv) when _Lv >= 636, _Lv =< 636 ->
		[{5,0,56169375}];
get_exp(_Lv) when _Lv >= 637, _Lv =< 637 ->
		[{5,0,56628275}];
get_exp(_Lv) when _Lv >= 638, _Lv =< 638 ->
		[{5,0,57090050}];
get_exp(_Lv) when _Lv >= 639, _Lv =< 639 ->
		[{5,0,57552250}];
get_exp(_Lv) when _Lv >= 640, _Lv =< 640 ->
		[{5,0,58022425}];
get_exp(_Lv) when _Lv >= 641, _Lv =< 641 ->
		[{5,0,58495550}];
get_exp(_Lv) when _Lv >= 642, _Lv =< 642 ->
		[{5,0,58971675}];
get_exp(_Lv) when _Lv >= 643, _Lv =< 643 ->
		[{5,0,59450825}];
get_exp(_Lv) when _Lv >= 644, _Lv =< 644 ->
		[{5,0,59935525}];
get_exp(_Lv) when _Lv >= 645, _Lv =< 645 ->
		[{5,0,60423300}];
get_exp(_Lv) when _Lv >= 646, _Lv =< 646 ->
		[{5,0,60914150}];
get_exp(_Lv) when _Lv >= 647, _Lv =< 647 ->
		[{5,0,61410650}];
get_exp(_Lv) when _Lv >= 648, _Lv =< 648 ->
		[{5,0,61910275}];
get_exp(_Lv) when _Lv >= 649, _Lv =< 649 ->
		[{5,0,62415575}];
get_exp(_Lv) when _Lv >= 650, _Lv =< 650 ->
		[{5,0,62924100}];
get_exp(_Lv) when _Lv >= 651, _Lv =< 651 ->
		[{5,0,63435825}];
get_exp(_Lv) when _Lv >= 652, _Lv =< 652 ->
		[{5,0,63953300}];
get_exp(_Lv) when _Lv >= 653, _Lv =< 653 ->
		[{5,0,64474050}];
get_exp(_Lv) when _Lv >= 654, _Lv =< 654 ->
		[{5,0,64998125}];
get_exp(_Lv) when _Lv >= 655, _Lv =< 655 ->
		[{5,0,65528000}];
get_exp(_Lv) when _Lv >= 656, _Lv =< 656 ->
		[{5,0,66061250}];
get_exp(_Lv) when _Lv >= 657, _Lv =< 657 ->
		[{5,0,66597875}];
get_exp(_Lv) when _Lv >= 658, _Lv =< 658 ->
		[{5,0,67140425}];
get_exp(_Lv) when _Lv >= 659, _Lv =< 659 ->
		[{5,0,67686425}];
get_exp(_Lv) when _Lv >= 660, _Lv =< 660 ->
		[{5,0,68238375}];
get_exp(_Lv) when _Lv >= 661, _Lv =< 661 ->
		[{5,0,68793825}];
get_exp(_Lv) when _Lv >= 662, _Lv =< 662 ->
		[{5,0,69355300}];
get_exp(_Lv) when _Lv >= 663, _Lv =< 663 ->
		[{5,0,69920325}];
get_exp(_Lv) when _Lv >= 664, _Lv =< 664 ->
		[{5,0,70488950}];
get_exp(_Lv) when _Lv >= 665, _Lv =< 665 ->
		[{5,0,71063675}];
get_exp(_Lv) when _Lv >= 666, _Lv =< 666 ->
		[{5,0,71642050}];
get_exp(_Lv) when _Lv >= 667, _Lv =< 667 ->
		[{5,0,72224075}];
get_exp(_Lv) when _Lv >= 668, _Lv =< 668 ->
		[{5,0,72812325}];
get_exp(_Lv) when _Lv >= 669, _Lv =< 669 ->
		[{5,0,73404300}];
get_exp(_Lv) when _Lv >= 670, _Lv =< 670 ->
		[{5,0,74002525}];
get_exp(_Lv) when _Lv >= 671, _Lv =< 671 ->
		[{5,0,74604550}];
get_exp(_Lv) when _Lv >= 672, _Lv =< 672 ->
		[{5,0,75212900}];
get_exp(_Lv) when _Lv >= 673, _Lv =< 673 ->
		[{5,0,75825100}];
get_exp(_Lv) when _Lv >= 674, _Lv =< 674 ->
		[{5,0,76443675}];
get_exp(_Lv) when _Lv >= 675, _Lv =< 675 ->
		[{5,0,77066200}];
get_exp(_Lv) when _Lv >= 676, _Lv =< 676 ->
		[{5,0,77692650}];
get_exp(_Lv) when _Lv >= 677, _Lv =< 677 ->
		[{5,0,78325575}];
get_exp(_Lv) when _Lv >= 678, _Lv =< 678 ->
		[{5,0,78962525}];
get_exp(_Lv) when _Lv >= 679, _Lv =< 679 ->
		[{5,0,79606025}];
get_exp(_Lv) when _Lv >= 680, _Lv =< 680 ->
		[{5,0,80253600}];
get_exp(_Lv) when _Lv >= 681, _Lv =< 681 ->
		[{5,0,80907775}];
get_exp(_Lv) when _Lv >= 682, _Lv =< 682 ->
		[{5,0,81566100}];
get_exp(_Lv) when _Lv >= 683, _Lv =< 683 ->
		[{5,0,82231125}];
get_exp(_Lv) when _Lv >= 684, _Lv =< 684 ->
		[{5,0,82900350}];
get_exp(_Lv) when _Lv >= 685, _Lv =< 685 ->
		[{5,0,83576325}];
get_exp(_Lv) when _Lv >= 686, _Lv =< 686 ->
		[{5,0,84256575}];
get_exp(_Lv) when _Lv >= 687, _Lv =< 687 ->
		[{5,0,84941150}];
get_exp(_Lv) when _Lv >= 688, _Lv =< 688 ->
		[{5,0,85632575}];
get_exp(_Lv) when _Lv >= 689, _Lv =< 689 ->
		[{5,0,86330900}];
get_exp(_Lv) when _Lv >= 690, _Lv =< 690 ->
		[{5,0,87033625}];
get_exp(_Lv) when _Lv >= 691, _Lv =< 691 ->
		[{5,0,87743325}];
get_exp(_Lv) when _Lv >= 692, _Lv =< 692 ->
		[{5,0,88457525}];
get_exp(_Lv) when _Lv >= 693, _Lv =< 693 ->
		[{5,0,89176250}];
get_exp(_Lv) when _Lv >= 694, _Lv =< 694 ->
		[{5,0,89902050}];
get_exp(_Lv) when _Lv >= 695, _Lv =< 695 ->
		[{5,0,90634950}];
get_exp(_Lv) when _Lv >= 696, _Lv =< 696 ->
		[{5,0,91372500}];
get_exp(_Lv) when _Lv >= 697, _Lv =< 697 ->
		[{5,0,92117225}];
get_exp(_Lv) when _Lv >= 698, _Lv =< 698 ->
		[{5,0,92866675}];
get_exp(_Lv) when _Lv >= 699, _Lv =< 699 ->
		[{5,0,93623375}];
get_exp(_Lv) when _Lv >= 700, _Lv =< 700 ->
		[{5,0,94384900}];
get_exp(_Lv) when _Lv >= 701, _Lv =< 701 ->
		[{5,0,95153725}];
get_exp(_Lv) when _Lv >= 702, _Lv =< 702 ->
		[{5,0,95927450}];
get_exp(_Lv) when _Lv >= 703, _Lv =< 703 ->
		[{5,0,96711075}];
get_exp(_Lv) when _Lv >= 704, _Lv =< 704 ->
		[{5,0,97497175}];
get_exp(_Lv) when _Lv >= 705, _Lv =< 705 ->
		[{5,0,98290775}];
get_exp(_Lv) when _Lv >= 706, _Lv =< 706 ->
		[{5,0,99091875}];
get_exp(_Lv) when _Lv >= 707, _Lv =< 707 ->
		[{5,0,99898075}];
get_exp(_Lv) when _Lv >= 708, _Lv =< 708 ->
		[{5,0,100711900}];
get_exp(_Lv) when _Lv >= 709, _Lv =< 709 ->
		[{5,0,101530875}];
get_exp(_Lv) when _Lv >= 710, _Lv =< 710 ->
		[{5,0,102357575}];
get_exp(_Lv) when _Lv >= 711, _Lv =< 711 ->
		[{5,0,103192000}];
get_exp(_Lv) when _Lv >= 712, _Lv =< 712 ->
		[{5,0,104031725}];
get_exp(_Lv) when _Lv >= 713, _Lv =< 713 ->
		[{5,0,104879250}];
get_exp(_Lv) when _Lv >= 714, _Lv =< 714 ->
		[{5,0,105732175}];
get_exp(_Lv) when _Lv >= 715, _Lv =< 715 ->
		[{5,0,106593025}];
get_exp(_Lv) when _Lv >= 716, _Lv =< 716 ->
		[{5,0,107461825}];
get_exp(_Lv) when _Lv >= 717, _Lv =< 717 ->
		[{5,0,108336125}];
get_exp(_Lv) when _Lv >= 718, _Lv =< 718 ->
		[{5,0,109218500}];
get_exp(_Lv) when _Lv >= 719, _Lv =< 719 ->
		[{5,0,110108950}];
get_exp(_Lv) when _Lv >= 720, _Lv =< 720 ->
		[{5,0,111005050}];
get_exp(_Lv) when _Lv >= 721, _Lv =< 721 ->
		[{5,0,111909325}];
get_exp(_Lv) when _Lv >= 722, _Lv =< 722 ->
		[{5,0,112819350}];
get_exp(_Lv) when _Lv >= 723, _Lv =< 723 ->
		[{5,0,113737650}];
get_exp(_Lv) when _Lv >= 724, _Lv =< 724 ->
		[{5,0,114664275}];
get_exp(_Lv) when _Lv >= 725, _Lv =< 725 ->
		[{5,0,115599300}];
get_exp(_Lv) when _Lv >= 726, _Lv =< 726 ->
		[{5,0,116540225}];
get_exp(_Lv) when _Lv >= 727, _Lv =< 727 ->
		[{5,0,117487125}];
get_exp(_Lv) when _Lv >= 728, _Lv =< 728 ->
		[{5,0,118445050}];
get_exp(_Lv) when _Lv >= 729, _Lv =< 729 ->
		[{5,0,119409050}];
get_exp(_Lv) when _Lv >= 730, _Lv =< 730 ->
		[{5,0,120381650}];
get_exp(_Lv) when _Lv >= 731, _Lv =< 731 ->
		[{5,0,121362925}];
get_exp(_Lv) when _Lv >= 732, _Lv =< 732 ->
		[{5,0,122350425}];
get_exp(_Lv) when _Lv >= 733, _Lv =< 733 ->
		[{5,0,123346700}];
get_exp(_Lv) when _Lv >= 734, _Lv =< 734 ->
		[{5,0,124349275}];
get_exp(_Lv) when _Lv >= 735, _Lv =< 735 ->
		[{5,0,125363250}];
get_exp(_Lv) when _Lv >= 736, _Lv =< 736 ->
		[{5,0,126383625}];
get_exp(_Lv) when _Lv >= 737, _Lv =< 737 ->
		[{5,0,127412975}];
get_exp(_Lv) when _Lv >= 738, _Lv =< 738 ->
		[{5,0,128451375}];
get_exp(_Lv) when _Lv >= 739, _Lv =< 739 ->
		[{5,0,129496350}];
get_exp(_Lv) when _Lv >= 740, _Lv =< 740 ->
		[{5,0,130550450}];
get_exp(_Lv) when _Lv >= 741, _Lv =< 741 ->
		[{5,0,131613750}];
get_exp(_Lv) when _Lv >= 742, _Lv =< 742 ->
		[{5,0,132686300}];
get_exp(_Lv) when _Lv >= 743, _Lv =< 743 ->
		[{5,0,133765625}];
get_exp(_Lv) when _Lv >= 744, _Lv =< 744 ->
		[{5,0,134854325}];
get_exp(_Lv) when _Lv >= 745, _Lv =< 745 ->
		[{5,0,135952425}];
get_exp(_Lv) when _Lv >= 746, _Lv =< 746 ->
		[{5,0,137060000}];
get_exp(_Lv) when _Lv >= 747, _Lv =< 747 ->
		[{5,0,138174600}];
get_exp(_Lv) when _Lv >= 748, _Lv =< 748 ->
		[{5,0,139301275}];
get_exp(_Lv) when _Lv >= 749, _Lv =< 749 ->
		[{5,0,140435075}];
get_exp(_Lv) when _Lv >= 750, _Lv =< 750 ->
		[{5,0,141578600}];
get_exp(_Lv) when _Lv >= 751, _Lv =< 751 ->
		[{5,0,142731850}];
get_exp(_Lv) when _Lv >= 752, _Lv =< 752 ->
		[{5,0,143892425}];
get_exp(_Lv) when _Lv >= 753, _Lv =< 753 ->
		[{5,0,145065375}];
get_exp(_Lv) when _Lv >= 754, _Lv =< 754 ->
		[{5,0,146245775}];
get_exp(_Lv) when _Lv >= 755, _Lv =< 755 ->
		[{5,0,147436150}];
get_exp(_Lv) when _Lv >= 756, _Lv =< 756 ->
		[{5,0,148636575}];
get_exp(_Lv) when _Lv >= 757, _Lv =< 757 ->
		[{5,0,149847125}];
get_exp(_Lv) when _Lv >= 758, _Lv =< 758 ->
		[{5,0,151067875}];
get_exp(_Lv) when _Lv >= 759, _Lv =< 759 ->
		[{5,0,152298825}];
get_exp(_Lv) when _Lv >= 760, _Lv =< 760 ->
		[{5,0,153537600}];
get_exp(_Lv) when _Lv >= 761, _Lv =< 761 ->
		[{5,0,154786750}];
get_exp(_Lv) when _Lv >= 762, _Lv =< 762 ->
		[{5,0,156048825}];
get_exp(_Lv) when _Lv >= 763, _Lv =< 763 ->
		[{5,0,157318900}];
get_exp(_Lv) when _Lv >= 764, _Lv =< 764 ->
		[{5,0,158599525}];
get_exp(_Lv) when _Lv >= 765, _Lv =< 765 ->
		[{5,0,159890800}];
get_exp(_Lv) when _Lv >= 766, _Lv =< 766 ->
		[{5,0,161192750}];
get_exp(_Lv) when _Lv >= 767, _Lv =< 767 ->
		[{5,0,162505450}];
get_exp(_Lv) when _Lv >= 768, _Lv =< 768 ->
		[{5,0,163829000}];
get_exp(_Lv) when _Lv >= 769, _Lv =< 769 ->
		[{5,0,165163425}];
get_exp(_Lv) when _Lv >= 770, _Lv =< 770 ->
		[{5,0,166506325}];
get_exp(_Lv) when _Lv >= 771, _Lv =< 771 ->
		[{5,0,167862750}];
get_exp(_Lv) when _Lv >= 772, _Lv =< 772 ->
		[{5,0,169230275}];
get_exp(_Lv) when _Lv >= 773, _Lv =< 773 ->
		[{5,0,170609000}];
get_exp(_Lv) when _Lv >= 774, _Lv =< 774 ->
		[{5,0,171996425}];
get_exp(_Lv) when _Lv >= 775, _Lv =< 775 ->
		[{5,0,173397700}];
get_exp(_Lv) when _Lv >= 776, _Lv =< 776 ->
		[{5,0,174810350}];
get_exp(_Lv) when _Lv >= 777, _Lv =< 777 ->
		[{5,0,176231950}];
get_exp(_Lv) when _Lv >= 778, _Lv =< 778 ->
		[{5,0,177667575}];
get_exp(_Lv) when _Lv >= 779, _Lv =< 779 ->
		[{5,0,179114825}];
get_exp(_Lv) when _Lv >= 780, _Lv =< 780 ->
		[{5,0,180573725}];
get_exp(_Lv) when _Lv >= 781, _Lv =< 781 ->
		[{5,0,182041900}];
get_exp(_Lv) when _Lv >= 782, _Lv =< 782 ->
		[{5,0,183524400}];
get_exp(_Lv) when _Lv >= 783, _Lv =< 783 ->
		[{5,0,185018800}];
get_exp(_Lv) when _Lv >= 784, _Lv =< 784 ->
		[{5,0,186525175}];
get_exp(_Lv) when _Lv >= 785, _Lv =< 785 ->
		[{5,0,188043625}];
get_exp(_Lv) when _Lv >= 786, _Lv =< 786 ->
		[{5,0,189576700}];
get_exp(_Lv) when _Lv >= 787, _Lv =< 787 ->
		[{5,0,191119475}];
get_exp(_Lv) when _Lv >= 788, _Lv =< 788 ->
		[{5,0,192674575}];
get_exp(_Lv) when _Lv >= 789, _Lv =< 789 ->
		[{5,0,194244525}];
get_exp(_Lv) when _Lv >= 790, _Lv =< 790 ->
		[{5,0,195826925}];
get_exp(_Lv) when _Lv >= 791, _Lv =< 791 ->
		[{5,0,197419375}];
get_exp(_Lv) when _Lv >= 792, _Lv =< 792 ->
		[{5,0,199026950}];
get_exp(_Lv) when _Lv >= 793, _Lv =< 793 ->
		[{5,0,200647200}];
get_exp(_Lv) when _Lv >= 794, _Lv =< 794 ->
		[{5,0,202282750}];
get_exp(_Lv) when _Lv >= 795, _Lv =< 795 ->
		[{5,0,203928650}];
get_exp(_Lv) when _Lv >= 796, _Lv =< 796 ->
		[{5,0,205590000}];
get_exp(_Lv) when _Lv >= 797, _Lv =< 797 ->
		[{5,0,207264400}];
get_exp(_Lv) when _Lv >= 798, _Lv =< 798 ->
		[{5,0,208951900}];
get_exp(_Lv) when _Lv >= 799, _Lv =< 799 ->
		[{5,0,210652625}];
get_exp(_Lv) when _Lv >= 800, _Lv =< 800 ->
		[{5,0,212366650}];
get_exp(_Lv) when _Lv >= 801, _Lv =< 801 ->
		[{5,0,214096550}];
get_exp(_Lv) when _Lv >= 802, _Lv =< 802 ->
		[{5,0,215839900}];
get_exp(_Lv) when _Lv >= 803, _Lv =< 803 ->
		[{5,0,217596825}];
get_exp(_Lv) when _Lv >= 804, _Lv =< 804 ->
		[{5,0,219369925}];
get_exp(_Lv) when _Lv >= 805, _Lv =< 805 ->
		[{5,0,221154225}];
get_exp(_Lv) when _Lv >= 806, _Lv =< 806 ->
		[{5,0,222954875}];
get_exp(_Lv) when _Lv >= 807, _Lv =< 807 ->
		[{5,0,224771950}];
get_exp(_Lv) when _Lv >= 808, _Lv =< 808 ->
		[{5,0,226603050}];
get_exp(_Lv) when _Lv >= 809, _Lv =< 809 ->
		[{5,0,228445750}];
get_exp(_Lv) when _Lv >= 810, _Lv =< 810 ->
		[{5,0,230307675}];
get_exp(_Lv) when _Lv >= 811, _Lv =< 811 ->
		[{5,0,232181400}];
get_exp(_Lv) when _Lv >= 812, _Lv =< 812 ->
		[{5,0,234072000}];
get_exp(_Lv) when _Lv >= 813, _Lv =< 813 ->
		[{5,0,235977100}];
get_exp(_Lv) when _Lv >= 814, _Lv =< 814 ->
		[{5,0,237899300}];
get_exp(_Lv) when _Lv >= 815, _Lv =< 815 ->
		[{5,0,239836200}];
get_exp(_Lv) when _Lv >= 816, _Lv =< 816 ->
		[{5,0,241790375}];
get_exp(_Lv) when _Lv >= 817, _Lv =< 817 ->
		[{5,0,243759425}];
get_exp(_Lv) when _Lv >= 818, _Lv =< 818 ->
		[{5,0,245743500}];
get_exp(_Lv) when _Lv >= 819, _Lv =< 819 ->
		[{5,0,247745150}];
get_exp(_Lv) when _Lv >= 820, _Lv =< 820 ->
		[{5,0,249762000}];
get_exp(_Lv) when _Lv >= 821, _Lv =< 821 ->
		[{5,0,251794150}];
get_exp(_Lv) when _Lv >= 822, _Lv =< 822 ->
		[{5,0,253844175}];
get_exp(_Lv) when _Lv >= 823, _Lv =< 823 ->
		[{5,0,255912250}];
get_exp(_Lv) when _Lv >= 824, _Lv =< 824 ->
		[{5,0,257995900}];
get_exp(_Lv) when _Lv >= 825, _Lv =< 825 ->
		[{5,0,260097800}];
get_exp(_Lv) when _Lv >= 826, _Lv =< 826 ->
		[{5,0,262215525}];
get_exp(_Lv) when _Lv >= 827, _Lv =< 827 ->
		[{5,0,264349175}];
get_exp(_Lv) when _Lv >= 828, _Lv =< 828 ->
		[{5,0,266501375}];
get_exp(_Lv) when _Lv >= 829, _Lv =< 829 ->
		[{5,0,268672225}];
get_exp(_Lv) when _Lv >= 830, _Lv =< 830 ->
		[{5,0,270859350}];
get_exp(_Lv) when _Lv >= 831, _Lv =< 831 ->
		[{5,0,273065350}];
get_exp(_Lv) when _Lv >= 832, _Lv =< 832 ->
		[{5,0,275287850}];
get_exp(_Lv) when _Lv >= 833, _Lv =< 833 ->
		[{5,0,277529450}];
get_exp(_Lv) when _Lv >= 834, _Lv =< 834 ->
		[{5,0,279790275}];
get_exp(_Lv) when _Lv >= 835, _Lv =< 835 ->
		[{5,0,282067925}];
get_exp(_Lv) when _Lv >= 836, _Lv =< 836 ->
		[{5,0,284365050}];
get_exp(_Lv) when _Lv >= 837, _Lv =< 837 ->
		[{5,0,286679225}];
get_exp(_Lv) when _Lv >= 838, _Lv =< 838 ->
		[{5,0,289013100}];
get_exp(_Lv) when _Lv >= 839, _Lv =< 839 ->
		[{5,0,291366800}];
get_exp(_Lv) when _Lv >= 840, _Lv =< 840 ->
		[{5,0,293740400}];
get_exp(_Lv) when _Lv >= 841, _Lv =< 841 ->
		[{5,0,296131575}];
get_exp(_Lv) when _Lv >= 842, _Lv =< 842 ->
		[{5,0,298542925}];
get_exp(_Lv) when _Lv >= 843, _Lv =< 843 ->
		[{5,0,300972050}];
get_exp(_Lv) when _Lv >= 844, _Lv =< 844 ->
		[{5,0,303424125}];
get_exp(_Lv) when _Lv >= 845, _Lv =< 845 ->
		[{5,0,305894225}];
get_exp(_Lv) when _Lv >= 846, _Lv =< 846 ->
		[{5,0,308385025}];
get_exp(_Lv) when _Lv >= 847, _Lv =< 847 ->
		[{5,0,310896600}];
get_exp(_Lv) when _Lv >= 848, _Lv =< 848 ->
		[{5,0,313426625}];
get_exp(_Lv) when _Lv >= 849, _Lv =< 849 ->
		[{5,0,315980200}];
get_exp(_Lv) when _Lv >= 850, _Lv =< 850 ->
		[{5,0,318552475}];
get_exp(_Lv) when _Lv >= 851, _Lv =< 851 ->
		[{5,0,321143575}];
get_exp(_Lv) when _Lv >= 852, _Lv =< 852 ->
		[{5,0,323756125}];
get_exp(_Lv) when _Lv >= 853, _Lv =< 853 ->
		[{5,0,326385250}];
get_exp(_Lv) when _Lv >= 854, _Lv =< 854 ->
		[{5,0,329056125}];
get_exp(_Lv) when _Lv >= 855, _Lv =< 855 ->
		[{5,0,331718850}];
get_exp(_Lv) when _Lv >= 856, _Lv =< 856 ->
		[{5,0,334423575}];
get_exp(_Lv) when _Lv >= 857, _Lv =< 857 ->
		[{5,0,337145450}];
get_exp(_Lv) when _Lv >= 858, _Lv =< 858 ->
		[{5,0,339909600}];
get_exp(_Lv) when _Lv >= 859, _Lv =< 859 ->
		[{5,0,342666150}];
get_exp(_Lv) when _Lv >= 860, _Lv =< 860 ->
		[{5,0,345465275}];
get_exp(_Lv) when _Lv >= 861, _Lv =< 861 ->
		[{5,0,348282100}];
get_exp(_Lv) when _Lv >= 862, _Lv =< 862 ->
		[{5,0,351116750}];
get_exp(_Lv) when _Lv >= 863, _Lv =< 863 ->
		[{5,0,353969425}];
get_exp(_Lv) when _Lv >= 864, _Lv =< 864 ->
		[{5,0,356840200}];
get_exp(_Lv) when _Lv >= 865, _Lv =< 865 ->
		[{5,0,359754300}];
get_exp(_Lv) when _Lv >= 866, _Lv =< 866 ->
		[{5,0,362686800}];
get_exp(_Lv) when _Lv >= 867, _Lv =< 867 ->
		[{5,0,365637900}];
get_exp(_Lv) when _Lv >= 868, _Lv =< 868 ->
		[{5,0,368607750}];
get_exp(_Lv) when _Lv >= 869, _Lv =< 869 ->
		[{5,0,371621475}];
get_exp(_Lv) when _Lv >= 870, _Lv =< 870 ->
		[{5,0,374629250}];
get_exp(_Lv) when _Lv >= 871, _Lv =< 871 ->
		[{5,0,377681225}];
get_exp(_Lv) when _Lv >= 872, _Lv =< 872 ->
		[{5,0,380777525}];
get_exp(_Lv) when _Lv >= 873, _Lv =< 873 ->
		[{5,0,383868375}];
get_exp(_Lv) when _Lv >= 874, _Lv =< 874 ->
		[{5,0,387003875}];
get_exp(_Lv) when _Lv >= 875, _Lv =< 875 ->
		[{5,0,390134200}];
get_exp(_Lv) when _Lv >= 876, _Lv =< 876 ->
		[{5,0,393309525}];
get_exp(_Lv) when _Lv >= 877, _Lv =< 877 ->
		[{5,0,396530000}];
get_exp(_Lv) when _Lv >= 878, _Lv =< 878 ->
		[{5,0,399745800}];
get_exp(_Lv) when _Lv >= 879, _Lv =< 879 ->
		[{5,0,403007100}];
get_exp(_Lv) when _Lv >= 880, _Lv =< 880 ->
		[{5,0,406289025}];
get_exp(_Lv) when _Lv >= 881, _Lv =< 881 ->
		[{5,0,409591775}];
get_exp(_Lv) when _Lv >= 882, _Lv =< 882 ->
		[{5,0,412940525}];
get_exp(_Lv) when _Lv >= 883, _Lv =< 883 ->
		[{5,0,416285425}];
get_exp(_Lv) when _Lv >= 884, _Lv =< 884 ->
		[{5,0,419676675}];
get_exp(_Lv) when _Lv >= 885, _Lv =< 885 ->
		[{5,0,423089400}];
get_exp(_Lv) when _Lv >= 886, _Lv =< 886 ->
		[{5,0,426548825}];
get_exp(_Lv) when _Lv >= 887, _Lv =< 887 ->
		[{5,0,430030100}];
get_exp(_Lv) when _Lv >= 888, _Lv =< 888 ->
		[{5,0,433508425}];
get_exp(_Lv) when _Lv >= 889, _Lv =< 889 ->
		[{5,0,437058950}];
get_exp(_Lv) when _Lv >= 890, _Lv =< 890 ->
		[{5,0,440606875}];
get_exp(_Lv) when _Lv >= 891, _Lv =< 891 ->
		[{5,0,444202375}];
get_exp(_Lv) when _Lv >= 892, _Lv =< 892 ->
		[{5,0,447795625}];
get_exp(_Lv) when _Lv >= 893, _Lv =< 893 ->
		[{5,0,451461850}];
get_exp(_Lv) when _Lv >= 894, _Lv =< 894 ->
		[{5,0,455126175}];
get_exp(_Lv) when _Lv >= 895, _Lv =< 895 ->
		[{5,0,458838850}];
get_exp(_Lv) when _Lv >= 896, _Lv =< 896 ->
		[{5,0,462575025}];
get_exp(_Lv) when _Lv >= 897, _Lv =< 897 ->
		[{5,0,466334925}];
get_exp(_Lv) when _Lv >= 898, _Lv =< 898 ->
		[{5,0,470143700}];
get_exp(_Lv) when _Lv >= 899, _Lv =< 899 ->
		[{5,0,473976550}];
get_exp(_Lv) when _Lv >= 900, _Lv =< 900 ->
		[{5,0,477833725}];
get_exp(_Lv) when _Lv >= 901, _Lv =< 901 ->
		[{5,0,481715350}];
get_exp(_Lv) when _Lv >= 902, _Lv =< 902 ->
		[{5,0,485646700}];
get_exp(_Lv) when _Lv >= 903, _Lv =< 903 ->
		[{5,0,489602900}];
get_exp(_Lv) when _Lv >= 904, _Lv =< 904 ->
		[{5,0,493584200}];
get_exp(_Lv) when _Lv >= 905, _Lv =< 905 ->
		[{5,0,497590800}];
get_exp(_Lv) when _Lv >= 906, _Lv =< 906 ->
		[{5,0,501647875}];
get_exp(_Lv) when _Lv >= 907, _Lv =< 907 ->
		[{5,0,505730675}];
get_exp(_Lv) when _Lv >= 908, _Lv =< 908 ->
		[{5,0,509839400}];
get_exp(_Lv) when _Lv >= 909, _Lv =< 909 ->
		[{5,0,513999225}];
get_exp(_Lv) when _Lv >= 910, _Lv =< 910 ->
		[{5,0,518185400}];
get_exp(_Lv) when _Lv >= 911, _Lv =< 911 ->
		[{5,0,522398150}];
get_exp(_Lv) when _Lv >= 912, _Lv =< 912 ->
		[{5,0,526662650}];
get_exp(_Lv) when _Lv >= 913, _Lv =< 913 ->
		[{5,0,530954125}];
get_exp(_Lv) when _Lv >= 914, _Lv =< 914 ->
		[{5,0,535272825}];
get_exp(_Lv) when _Lv >= 915, _Lv =< 915 ->
		[{5,0,539618950}];
get_exp(_Lv) when _Lv >= 916, _Lv =< 916 ->
		[{5,0,544017725}];
get_exp(_Lv) when _Lv >= 917, _Lv =< 917 ->
		[{5,0,548444375}];
get_exp(_Lv) when _Lv >= 918, _Lv =< 918 ->
		[{5,0,552924125}];
get_exp(_Lv) when _Lv >= 919, _Lv =< 919 ->
		[{5,0,557432225}];
get_exp(_Lv) when _Lv >= 920, _Lv =< 920 ->
		[{5,0,561968875}];
get_exp(_Lv) when _Lv >= 921, _Lv =< 921 ->
		[{5,0,566534325}];
get_exp(_Lv) when _Lv >= 922, _Lv =< 922 ->
		[{5,0,571153800}];
get_exp(_Lv) when _Lv >= 923, _Lv =< 923 ->
		[{5,0,575802550}];
get_exp(_Lv) when _Lv >= 924, _Lv =< 924 ->
		[{5,0,580480825}];
get_exp(_Lv) when _Lv >= 925, _Lv =< 925 ->
		[{5,0,585213825}];
get_exp(_Lv) when _Lv >= 926, _Lv =< 926 ->
		[{5,0,589976800}];
get_exp(_Lv) when _Lv >= 927, _Lv =< 927 ->
		[{5,0,594770025}];
get_exp(_Lv) when _Lv >= 928, _Lv =< 928 ->
		[{5,0,599618725}];
get_exp(_Lv) when _Lv >= 929, _Lv =< 929 ->
		[{5,0,604498150}];
get_exp(_Lv) when _Lv >= 930, _Lv =< 930 ->
		[{5,0,609433550}];
get_exp(_Lv) when _Lv >= 931, _Lv =< 931 ->
		[{5,0,614400175}];
get_exp(_Lv) when _Lv >= 932, _Lv =< 932 ->
		[{5,0,619398300}];
get_exp(_Lv) when _Lv >= 933, _Lv =< 933 ->
		[{5,0,624453150}];
get_exp(_Lv) when _Lv >= 934, _Lv =< 934 ->
		[{5,0,629515000}];
get_exp(_Lv) when _Lv >= 935, _Lv =< 935 ->
		[{5,0,634659100}];
get_exp(_Lv) when _Lv >= 936, _Lv =< 936 ->
		[{5,0,639810750}];
get_exp(_Lv) when _Lv >= 937, _Lv =< 937 ->
		[{5,0,645020150}];
get_exp(_Lv) when _Lv >= 938, _Lv =< 938 ->
		[{5,0,650287625}];
get_exp(_Lv) when _Lv >= 939, _Lv =< 939 ->
		[{5,0,655563425}];
get_exp(_Lv) when _Lv >= 940, _Lv =< 940 ->
		[{5,0,660897800}];
get_exp(_Lv) when _Lv >= 941, _Lv =< 941 ->
		[{5,0,666291050}];
get_exp(_Lv) when _Lv >= 942, _Lv =< 942 ->
		[{5,0,671718450}];
get_exp(_Lv) when _Lv >= 943, _Lv =< 943 ->
		[{5,0,677180275}];
get_exp(_Lv) when _Lv >= 944, _Lv =< 944 ->
		[{5,0,682701775}];
get_exp(_Lv) when _Lv >= 945, _Lv =< 945 ->
		[{5,0,688258275}];
get_exp(_Lv) when _Lv >= 946, _Lv =< 946 ->
		[{5,0,693875050}];
get_exp(_Lv) when _Lv >= 947, _Lv =< 947 ->
		[{5,0,699527375}];
get_exp(_Lv) when _Lv >= 948, _Lv =< 948 ->
		[{5,0,705215550}];
get_exp(_Lv) when _Lv >= 949, _Lv =< 949 ->
		[{5,0,710939850}];
get_exp(_Lv) when _Lv >= 950, _Lv =< 950 ->
		[{5,0,716750575}];
get_exp(_Lv) when _Lv >= 951, _Lv =< 951 ->
		[{5,0,722573050}];
get_exp(_Lv) when _Lv >= 952, _Lv =< 952 ->
		[{5,0,728457550}];
get_exp(_Lv) when _Lv >= 953, _Lv =< 953 ->
		[{5,0,734404350}];
get_exp(_Lv) when _Lv >= 954, _Lv =< 954 ->
		[{5,0,740363800}];
get_exp(_Lv) when _Lv >= 955, _Lv =< 955 ->
		[{5,0,746386200}];
get_exp(_Lv) when _Lv >= 956, _Lv =< 956 ->
		[{5,0,752471825}];
get_exp(_Lv) when _Lv >= 957, _Lv =< 957 ->
		[{5,0,758596025}];
get_exp(_Lv) when _Lv >= 958, _Lv =< 958 ->
		[{5,0,764784100}];
get_exp(_Lv) when _Lv >= 959, _Lv =< 959 ->
		[{5,0,771011350}];
get_exp(_Lv) when _Lv >= 960, _Lv =< 960 ->
		[{5,0,777278125}];
get_exp(_Lv) when _Lv >= 961, _Lv =< 961 ->
		[{5,0,783609725}];
get_exp(_Lv) when _Lv >= 962, _Lv =< 962 ->
		[{5,0,790006475}];
get_exp(_Lv) when _Lv >= 963, _Lv =< 963 ->
		[{5,0,796418700}];
get_exp(_Lv) when _Lv >= 964, _Lv =< 964 ->
		[{5,0,802896750}];
get_exp(_Lv) when _Lv >= 965, _Lv =< 965 ->
		[{5,0,809440925}];
get_exp(_Lv) when _Lv >= 966, _Lv =< 966 ->
		[{5,0,816051600}];
get_exp(_Lv) when _Lv >= 967, _Lv =< 967 ->
		[{5,0,822679075}];
get_exp(_Lv) when _Lv >= 968, _Lv =< 968 ->
		[{5,0,829373700}];
get_exp(_Lv) when _Lv >= 969, _Lv =< 969 ->
		[{5,0,836135850}];
get_exp(_Lv) when _Lv >= 970, _Lv =< 970 ->
		[{5,0,842940825}];
get_exp(_Lv) when _Lv >= 971, _Lv =< 971 ->
		[{5,0,849814000}];
get_exp(_Lv) when _Lv >= 972, _Lv =< 972 ->
		[{5,0,856730725}];
get_exp(_Lv) when _Lv >= 973, _Lv =< 973 ->
		[{5,0,863691350}];
get_exp(_Lv) when _Lv >= 974, _Lv =< 974 ->
		[{5,0,870721225}];
get_exp(_Lv) when _Lv >= 975, _Lv =< 975 ->
		[{5,0,877820725}];
get_exp(_Lv) when _Lv >= 976, _Lv =< 976 ->
		[{5,0,884965200}];
get_exp(_Lv) when _Lv >= 977, _Lv =< 977 ->
		[{5,0,892180050}];
get_exp(_Lv) when _Lv >= 978, _Lv =< 978 ->
		[{5,0,899440600}];
get_exp(_Lv) when _Lv >= 979, _Lv =< 979 ->
		[{5,0,906772225}];
get_exp(_Lv) when _Lv >= 980, _Lv =< 980 ->
		[{5,0,914150325}];
get_exp(_Lv) when _Lv >= 981, _Lv =< 981 ->
		[{5,0,921600275}];
get_exp(_Lv) when _Lv >= 982, _Lv =< 982 ->
		[{5,0,929097450}];
get_exp(_Lv) when _Lv >= 983, _Lv =< 983 ->
		[{5,0,936667225}];
get_exp(_Lv) when _Lv >= 984, _Lv =< 984 ->
		[{5,0,944285000}];
get_exp(_Lv) when _Lv >= 985, _Lv =< 985 ->
		[{5,0,951976175}];
get_exp(_Lv) when _Lv >= 986, _Lv =< 986 ->
		[{5,0,959716125}];
get_exp(_Lv) when _Lv >= 987, _Lv =< 987 ->
		[{5,0,967530250}];
get_exp(_Lv) when _Lv >= 988, _Lv =< 988 ->
		[{5,0,975418950}];
get_exp(_Lv) when _Lv >= 989, _Lv =< 989 ->
		[{5,0,983357625}];
get_exp(_Lv) when _Lv >= 990, _Lv =< 990 ->
		[{5,0,991371725}];
get_exp(_Lv) when _Lv >= 991, _Lv =< 991 ->
		[{5,0,999436600}];
get_exp(_Lv) when _Lv >= 992, _Lv =< 992 ->
		[{5,0,1007577675}];
get_exp(_Lv) when _Lv >= 993, _Lv =< 993 ->
		[{5,0,1015770400}];
get_exp(_Lv) when _Lv >= 994, _Lv =< 994 ->
		[{5,0,1024040175}];
get_exp(_Lv) when _Lv >= 995, _Lv =< 995 ->
		[{5,0,1032387425}];
get_exp(_Lv) when _Lv >= 996, _Lv =< 996 ->
		[{5,0,1040787575}];
get_exp(_Lv) when _Lv >= 997, _Lv =< 997 ->
		[{5,0,1049266075}];
get_exp(_Lv) when _Lv >= 998, _Lv =< 998 ->
		[{5,0,1057823325}];
get_exp(_Lv) when _Lv >= 999, _Lv =< 999 ->
		[{5,0,1066434775}];
get_exp(_Lv) when _Lv >= 1000, _Lv =< 1000 ->
		[{5,0,1075125875}];
get_exp(_Lv) ->
	[].

