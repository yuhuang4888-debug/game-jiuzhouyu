%%%---------------------------------------
%%% module      : data_transfer
%%% description : 转职配置
%%%
%%%---------------------------------------
-module(data_transfer).
-compile(export_all).




get_transfer_kv(1) ->
[{0,38390001,1}];


get_transfer_kv(2) ->
604800;


get_transfer_kv(3) ->
300;

get_transfer_kv(_Key) ->
	[].

get_arcana_transfer(1,2,101) ->
201;

get_arcana_transfer(1,2,102) ->
202;

get_arcana_transfer(1,2,103) ->
203;

get_arcana_transfer(1,2,104) ->
204;

get_arcana_transfer(1,2,105) ->
205;

get_arcana_transfer(1,2,106) ->
206;

get_arcana_transfer(1,2,107) ->
207;

get_arcana_transfer(1,2,108) ->
208;

get_arcana_transfer(1,2,111) ->
211;

get_arcana_transfer(1,2,112) ->
212;

get_arcana_transfer(1,2,113) ->
213;

get_arcana_transfer(1,2,114) ->
214;

get_arcana_transfer(1,2,115) ->
215;

get_arcana_transfer(1,2,121) ->
221;

get_arcana_transfer(1,2,122) ->
222;

get_arcana_transfer(1,2,123) ->
223;

get_arcana_transfer(1,2,124) ->
224;

get_arcana_transfer(1,2,125) ->
225;

get_arcana_transfer(2,1,201) ->
101;

get_arcana_transfer(2,1,202) ->
102;

get_arcana_transfer(2,1,203) ->
103;

get_arcana_transfer(2,1,204) ->
104;

get_arcana_transfer(2,1,205) ->
105;

get_arcana_transfer(2,1,206) ->
106;

get_arcana_transfer(2,1,207) ->
107;

get_arcana_transfer(2,1,208) ->
108;

get_arcana_transfer(2,1,211) ->
111;

get_arcana_transfer(2,1,212) ->
112;

get_arcana_transfer(2,1,213) ->
113;

get_arcana_transfer(2,1,214) ->
114;

get_arcana_transfer(2,1,215) ->
115;

get_arcana_transfer(2,1,221) ->
121;

get_arcana_transfer(2,1,222) ->
122;

get_arcana_transfer(2,1,223) ->
123;

get_arcana_transfer(2,1,224) ->
124;

get_arcana_transfer(2,1,225) ->
125;

get_arcana_transfer(_Oldcareer,_Newcareer,_Oldrule) ->
	0.

get_transfer_talent_skill(341105,2) ->
341205;

get_transfer_talent_skill(341105,3) ->
341305;

get_transfer_talent_skill(341105,4) ->
341405;

get_transfer_talent_skill(341106,2) ->
341206;

get_transfer_talent_skill(341106,3) ->
341306;

get_transfer_talent_skill(341106,4) ->
341406;

get_transfer_talent_skill(341107,2) ->
341207;

get_transfer_talent_skill(341107,3) ->
341307;

get_transfer_talent_skill(341107,4) ->
341407;

get_transfer_talent_skill(341108,2) ->
341208;

get_transfer_talent_skill(341108,3) ->
341308;

get_transfer_talent_skill(341108,4) ->
341408;

get_transfer_talent_skill(341109,2) ->
341209;

get_transfer_talent_skill(341109,3) ->
341309;

get_transfer_talent_skill(341109,4) ->
341409;

get_transfer_talent_skill(341110,2) ->
341210;

get_transfer_talent_skill(341110,3) ->
341310;

get_transfer_talent_skill(341110,4) ->
341410;

get_transfer_talent_skill(341205,1) ->
341105;

get_transfer_talent_skill(341205,3) ->
341305;

get_transfer_talent_skill(341205,4) ->
341405;

get_transfer_talent_skill(341206,1) ->
341106;

get_transfer_talent_skill(341206,3) ->
341306;

get_transfer_talent_skill(341206,4) ->
341406;

get_transfer_talent_skill(341207,1) ->
341107;

get_transfer_talent_skill(341207,3) ->
341307;

get_transfer_talent_skill(341207,4) ->
341407;

get_transfer_talent_skill(341208,1) ->
341108;

get_transfer_talent_skill(341208,3) ->
341308;

get_transfer_talent_skill(341208,4) ->
341408;

get_transfer_talent_skill(341209,1) ->
341109;

get_transfer_talent_skill(341209,3) ->
341309;

get_transfer_talent_skill(341209,4) ->
341409;

get_transfer_talent_skill(341210,1) ->
341110;

get_transfer_talent_skill(341210,3) ->
341310;

get_transfer_talent_skill(341210,4) ->
341410;

get_transfer_talent_skill(341305,1) ->
341105;

get_transfer_talent_skill(341305,2) ->
341205;

get_transfer_talent_skill(341305,4) ->
341405;

get_transfer_talent_skill(341306,1) ->
341106;

get_transfer_talent_skill(341306,2) ->
341206;

get_transfer_talent_skill(341306,4) ->
341406;

get_transfer_talent_skill(341307,1) ->
341107;

get_transfer_talent_skill(341307,2) ->
341207;

get_transfer_talent_skill(341307,4) ->
341407;

get_transfer_talent_skill(341308,1) ->
341108;

get_transfer_talent_skill(341308,2) ->
341208;

get_transfer_talent_skill(341308,4) ->
341408;

get_transfer_talent_skill(341309,1) ->
341109;

get_transfer_talent_skill(341309,2) ->
341209;

get_transfer_talent_skill(341309,4) ->
341409;

get_transfer_talent_skill(341310,1) ->
341110;

get_transfer_talent_skill(341310,2) ->
341210;

get_transfer_talent_skill(341310,4) ->
341410;

get_transfer_talent_skill(341405,1) ->
341105;

get_transfer_talent_skill(341405,2) ->
341205;

get_transfer_talent_skill(341405,3) ->
341305;

get_transfer_talent_skill(341406,1) ->
341106;

get_transfer_talent_skill(341406,2) ->
341206;

get_transfer_talent_skill(341406,3) ->
341306;

get_transfer_talent_skill(341407,1) ->
341107;

get_transfer_talent_skill(341407,2) ->
341207;

get_transfer_talent_skill(341407,3) ->
341307;

get_transfer_talent_skill(341408,1) ->
341108;

get_transfer_talent_skill(341408,2) ->
341208;

get_transfer_talent_skill(341408,3) ->
341308;

get_transfer_talent_skill(341409,1) ->
341109;

get_transfer_talent_skill(341409,2) ->
341209;

get_transfer_talent_skill(341409,3) ->
341309;

get_transfer_talent_skill(341410,1) ->
341110;

get_transfer_talent_skill(341410,2) ->
341210;

get_transfer_talent_skill(341410,3) ->
341310;

get_transfer_talent_skill(342105,2) ->
342205;

get_transfer_talent_skill(342105,3) ->
342305;

get_transfer_talent_skill(342105,4) ->
342405;

get_transfer_talent_skill(342106,2) ->
342206;

get_transfer_talent_skill(342106,3) ->
342306;

get_transfer_talent_skill(342106,4) ->
342406;

get_transfer_talent_skill(342108,2) ->
342208;

get_transfer_talent_skill(342108,3) ->
342308;

get_transfer_talent_skill(342108,4) ->
342408;

get_transfer_talent_skill(342109,2) ->
342209;

get_transfer_talent_skill(342109,3) ->
342309;

get_transfer_talent_skill(342109,4) ->
342409;

get_transfer_talent_skill(342110,2) ->
342210;

get_transfer_talent_skill(342110,3) ->
342310;

get_transfer_talent_skill(342110,4) ->
342410;

get_transfer_talent_skill(342205,1) ->
342105;

get_transfer_talent_skill(342205,3) ->
342305;

get_transfer_talent_skill(342205,4) ->
342405;

get_transfer_talent_skill(342206,1) ->
342106;

get_transfer_talent_skill(342206,3) ->
342306;

get_transfer_talent_skill(342206,4) ->
342406;

get_transfer_talent_skill(342208,1) ->
342108;

get_transfer_talent_skill(342208,3) ->
342308;

get_transfer_talent_skill(342208,4) ->
342408;

get_transfer_talent_skill(342209,1) ->
342109;

get_transfer_talent_skill(342209,3) ->
342309;

get_transfer_talent_skill(342209,4) ->
342409;

get_transfer_talent_skill(342210,1) ->
342110;

get_transfer_talent_skill(342210,3) ->
342310;

get_transfer_talent_skill(342210,4) ->
342410;

get_transfer_talent_skill(342305,1) ->
342105;

get_transfer_talent_skill(342305,2) ->
342205;

get_transfer_talent_skill(342305,4) ->
342405;

get_transfer_talent_skill(342306,1) ->
342106;

get_transfer_talent_skill(342306,2) ->
342206;

get_transfer_talent_skill(342306,4) ->
342406;

get_transfer_talent_skill(342308,1) ->
342108;

get_transfer_talent_skill(342308,2) ->
342208;

get_transfer_talent_skill(342308,4) ->
342408;

get_transfer_talent_skill(342309,1) ->
342109;

get_transfer_talent_skill(342309,2) ->
342209;

get_transfer_talent_skill(342309,4) ->
342409;

get_transfer_talent_skill(342310,1) ->
342110;

get_transfer_talent_skill(342310,2) ->
342210;

get_transfer_talent_skill(342310,4) ->
342410;

get_transfer_talent_skill(342405,1) ->
342105;

get_transfer_talent_skill(342405,2) ->
342205;

get_transfer_talent_skill(342405,3) ->
342305;

get_transfer_talent_skill(342406,1) ->
342106;

get_transfer_talent_skill(342406,2) ->
342206;

get_transfer_talent_skill(342406,3) ->
342306;

get_transfer_talent_skill(342408,1) ->
342108;

get_transfer_talent_skill(342408,2) ->
342208;

get_transfer_talent_skill(342408,3) ->
342308;

get_transfer_talent_skill(342409,1) ->
342109;

get_transfer_talent_skill(342409,2) ->
342209;

get_transfer_talent_skill(342409,3) ->
342309;

get_transfer_talent_skill(342410,1) ->
342110;

get_transfer_talent_skill(342410,2) ->
342210;

get_transfer_talent_skill(342410,3) ->
342310;

get_transfer_talent_skill(370013,2) ->
370023;

get_transfer_talent_skill(370013,3) ->
370033;

get_transfer_talent_skill(370013,4) ->
370043;

get_transfer_talent_skill(370023,1) ->
370013;

get_transfer_talent_skill(370023,3) ->
370033;

get_transfer_talent_skill(370023,4) ->
370043;

get_transfer_talent_skill(370033,1) ->
370013;

get_transfer_talent_skill(370033,2) ->
370023;

get_transfer_talent_skill(370033,4) ->
370043;

get_transfer_talent_skill(370043,1) ->
370013;

get_transfer_talent_skill(370043,2) ->
370023;

get_transfer_talent_skill(370043,3) ->
370033;

get_transfer_talent_skill(_Skillid,_Career) ->
	0.

