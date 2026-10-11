%%%---------------------------------------
%%% module      : data_exp_add
%%% description : 经验加成配置
%%%
%%%---------------------------------------
-module(data_exp_add).
-compile(export_all).



get_add(_ServerLv,_Lv) when _ServerLv >= 171, _ServerLv =< 180, _Lv >= 121, _Lv =< 130 ->
		275;
get_add(_ServerLv,_Lv) when _ServerLv >= 171, _ServerLv =< 180, _Lv >= 131, _Lv =< 140 ->
		165;
get_add(_ServerLv,_Lv) when _ServerLv >= 171, _ServerLv =< 180, _Lv >= 141, _Lv =< 150 ->
		110;
get_add(_ServerLv,_Lv) when _ServerLv >= 171, _ServerLv =< 180, _Lv >= 151, _Lv =< 160 ->
		65;
get_add(_ServerLv,_Lv) when _ServerLv >= 171, _ServerLv =< 180, _Lv >= 161, _Lv =< 170 ->
		35;
get_add(_ServerLv,_Lv) when _ServerLv >= 181, _ServerLv =< 190, _Lv >= 121, _Lv =< 130 ->
		275;
get_add(_ServerLv,_Lv) when _ServerLv >= 181, _ServerLv =< 190, _Lv >= 131, _Lv =< 140 ->
		220;
get_add(_ServerLv,_Lv) when _ServerLv >= 181, _ServerLv =< 190, _Lv >= 141, _Lv =< 150 ->
		165;
get_add(_ServerLv,_Lv) when _ServerLv >= 181, _ServerLv =< 190, _Lv >= 151, _Lv =< 160 ->
		110;
get_add(_ServerLv,_Lv) when _ServerLv >= 181, _ServerLv =< 190, _Lv >= 161, _Lv =< 170 ->
		65;
get_add(_ServerLv,_Lv) when _ServerLv >= 181, _ServerLv =< 190, _Lv >= 171, _Lv =< 180 ->
		35;
get_add(_ServerLv,_Lv) when _ServerLv >= 191, _ServerLv =< 200, _Lv >= 121, _Lv =< 130 ->
		330;
get_add(_ServerLv,_Lv) when _ServerLv >= 191, _ServerLv =< 200, _Lv >= 131, _Lv =< 140 ->
		275;
get_add(_ServerLv,_Lv) when _ServerLv >= 191, _ServerLv =< 200, _Lv >= 141, _Lv =< 150 ->
		220;
get_add(_ServerLv,_Lv) when _ServerLv >= 191, _ServerLv =< 200, _Lv >= 151, _Lv =< 160 ->
		165;
get_add(_ServerLv,_Lv) when _ServerLv >= 191, _ServerLv =< 200, _Lv >= 161, _Lv =< 170 ->
		110;
get_add(_ServerLv,_Lv) when _ServerLv >= 191, _ServerLv =< 200, _Lv >= 171, _Lv =< 180 ->
		65;
get_add(_ServerLv,_Lv) when _ServerLv >= 191, _ServerLv =< 200, _Lv >= 181, _Lv =< 190 ->
		35;
get_add(_ServerLv,_Lv) when _ServerLv >= 201, _ServerLv =< 210, _Lv >= 121, _Lv =< 130 ->
		385;
get_add(_ServerLv,_Lv) when _ServerLv >= 201, _ServerLv =< 210, _Lv >= 131, _Lv =< 140 ->
		275;
get_add(_ServerLv,_Lv) when _ServerLv >= 201, _ServerLv =< 210, _Lv >= 141, _Lv =< 150 ->
		275;
get_add(_ServerLv,_Lv) when _ServerLv >= 201, _ServerLv =< 210, _Lv >= 151, _Lv =< 160 ->
		220;
get_add(_ServerLv,_Lv) when _ServerLv >= 201, _ServerLv =< 210, _Lv >= 161, _Lv =< 170 ->
		165;
get_add(_ServerLv,_Lv) when _ServerLv >= 201, _ServerLv =< 210, _Lv >= 171, _Lv =< 180 ->
		110;
get_add(_ServerLv,_Lv) when _ServerLv >= 201, _ServerLv =< 210, _Lv >= 181, _Lv =< 190 ->
		65;
get_add(_ServerLv,_Lv) when _ServerLv >= 201, _ServerLv =< 210, _Lv >= 191, _Lv =< 200 ->
		35;
get_add(_ServerLv,_Lv) when _ServerLv >= 211, _ServerLv =< 220, _Lv >= 121, _Lv =< 130 ->
		440;
get_add(_ServerLv,_Lv) when _ServerLv >= 211, _ServerLv =< 220, _Lv >= 131, _Lv =< 140 ->
		330;
get_add(_ServerLv,_Lv) when _ServerLv >= 211, _ServerLv =< 220, _Lv >= 141, _Lv =< 150 ->
		275;
get_add(_ServerLv,_Lv) when _ServerLv >= 211, _ServerLv =< 220, _Lv >= 151, _Lv =< 160 ->
		275;
get_add(_ServerLv,_Lv) when _ServerLv >= 211, _ServerLv =< 220, _Lv >= 161, _Lv =< 170 ->
		220;
get_add(_ServerLv,_Lv) when _ServerLv >= 211, _ServerLv =< 220, _Lv >= 171, _Lv =< 180 ->
		165;
get_add(_ServerLv,_Lv) when _ServerLv >= 211, _ServerLv =< 220, _Lv >= 181, _Lv =< 190 ->
		110;
get_add(_ServerLv,_Lv) when _ServerLv >= 211, _ServerLv =< 220, _Lv >= 191, _Lv =< 200 ->
		65;
get_add(_ServerLv,_Lv) when _ServerLv >= 211, _ServerLv =< 220, _Lv >= 201, _Lv =< 210 ->
		35;
get_add(_ServerLv,_Lv) when _ServerLv >= 221, _ServerLv =< 230, _Lv >= 121, _Lv =< 130 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 221, _ServerLv =< 230, _Lv >= 131, _Lv =< 140 ->
		385;
get_add(_ServerLv,_Lv) when _ServerLv >= 221, _ServerLv =< 230, _Lv >= 141, _Lv =< 150 ->
		330;
get_add(_ServerLv,_Lv) when _ServerLv >= 221, _ServerLv =< 230, _Lv >= 151, _Lv =< 160 ->
		275;
get_add(_ServerLv,_Lv) when _ServerLv >= 221, _ServerLv =< 230, _Lv >= 161, _Lv =< 170 ->
		275;
get_add(_ServerLv,_Lv) when _ServerLv >= 221, _ServerLv =< 230, _Lv >= 171, _Lv =< 180 ->
		220;
get_add(_ServerLv,_Lv) when _ServerLv >= 221, _ServerLv =< 230, _Lv >= 181, _Lv =< 190 ->
		165;
get_add(_ServerLv,_Lv) when _ServerLv >= 221, _ServerLv =< 230, _Lv >= 191, _Lv =< 200 ->
		110;
get_add(_ServerLv,_Lv) when _ServerLv >= 221, _ServerLv =< 230, _Lv >= 201, _Lv =< 210 ->
		65;
get_add(_ServerLv,_Lv) when _ServerLv >= 221, _ServerLv =< 230, _Lv >= 211, _Lv =< 220 ->
		35;
get_add(_ServerLv,_Lv) when _ServerLv >= 231, _ServerLv =< 240, _Lv >= 121, _Lv =< 130 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 231, _ServerLv =< 240, _Lv >= 131, _Lv =< 140 ->
		440;
get_add(_ServerLv,_Lv) when _ServerLv >= 231, _ServerLv =< 240, _Lv >= 141, _Lv =< 150 ->
		385;
get_add(_ServerLv,_Lv) when _ServerLv >= 231, _ServerLv =< 240, _Lv >= 151, _Lv =< 160 ->
		330;
get_add(_ServerLv,_Lv) when _ServerLv >= 231, _ServerLv =< 240, _Lv >= 161, _Lv =< 170 ->
		275;
get_add(_ServerLv,_Lv) when _ServerLv >= 231, _ServerLv =< 240, _Lv >= 171, _Lv =< 180 ->
		275;
get_add(_ServerLv,_Lv) when _ServerLv >= 231, _ServerLv =< 240, _Lv >= 181, _Lv =< 190 ->
		220;
get_add(_ServerLv,_Lv) when _ServerLv >= 231, _ServerLv =< 240, _Lv >= 191, _Lv =< 200 ->
		165;
get_add(_ServerLv,_Lv) when _ServerLv >= 231, _ServerLv =< 240, _Lv >= 201, _Lv =< 210 ->
		110;
get_add(_ServerLv,_Lv) when _ServerLv >= 231, _ServerLv =< 240, _Lv >= 211, _Lv =< 220 ->
		65;
get_add(_ServerLv,_Lv) when _ServerLv >= 231, _ServerLv =< 240, _Lv >= 221, _Lv =< 230 ->
		35;
get_add(_ServerLv,_Lv) when _ServerLv >= 241, _ServerLv =< 250, _Lv >= 121, _Lv =< 130 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 241, _ServerLv =< 250, _Lv >= 131, _Lv =< 140 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 241, _ServerLv =< 250, _Lv >= 141, _Lv =< 150 ->
		440;
get_add(_ServerLv,_Lv) when _ServerLv >= 241, _ServerLv =< 250, _Lv >= 151, _Lv =< 160 ->
		385;
get_add(_ServerLv,_Lv) when _ServerLv >= 241, _ServerLv =< 250, _Lv >= 161, _Lv =< 170 ->
		330;
get_add(_ServerLv,_Lv) when _ServerLv >= 241, _ServerLv =< 250, _Lv >= 171, _Lv =< 180 ->
		275;
get_add(_ServerLv,_Lv) when _ServerLv >= 241, _ServerLv =< 250, _Lv >= 181, _Lv =< 190 ->
		275;
get_add(_ServerLv,_Lv) when _ServerLv >= 241, _ServerLv =< 250, _Lv >= 191, _Lv =< 200 ->
		220;
get_add(_ServerLv,_Lv) when _ServerLv >= 241, _ServerLv =< 250, _Lv >= 201, _Lv =< 210 ->
		165;
get_add(_ServerLv,_Lv) when _ServerLv >= 241, _ServerLv =< 250, _Lv >= 211, _Lv =< 220 ->
		110;
get_add(_ServerLv,_Lv) when _ServerLv >= 241, _ServerLv =< 250, _Lv >= 221, _Lv =< 230 ->
		65;
get_add(_ServerLv,_Lv) when _ServerLv >= 241, _ServerLv =< 250, _Lv >= 231, _Lv =< 240 ->
		35;
get_add(_ServerLv,_Lv) when _ServerLv >= 251, _ServerLv =< 260, _Lv >= 121, _Lv =< 130 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 251, _ServerLv =< 260, _Lv >= 131, _Lv =< 140 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 251, _ServerLv =< 260, _Lv >= 141, _Lv =< 150 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 251, _ServerLv =< 260, _Lv >= 151, _Lv =< 160 ->
		440;
get_add(_ServerLv,_Lv) when _ServerLv >= 251, _ServerLv =< 260, _Lv >= 161, _Lv =< 170 ->
		385;
get_add(_ServerLv,_Lv) when _ServerLv >= 251, _ServerLv =< 260, _Lv >= 171, _Lv =< 180 ->
		330;
get_add(_ServerLv,_Lv) when _ServerLv >= 251, _ServerLv =< 260, _Lv >= 181, _Lv =< 190 ->
		275;
get_add(_ServerLv,_Lv) when _ServerLv >= 251, _ServerLv =< 260, _Lv >= 191, _Lv =< 200 ->
		275;
get_add(_ServerLv,_Lv) when _ServerLv >= 251, _ServerLv =< 260, _Lv >= 201, _Lv =< 210 ->
		220;
get_add(_ServerLv,_Lv) when _ServerLv >= 251, _ServerLv =< 260, _Lv >= 211, _Lv =< 220 ->
		165;
get_add(_ServerLv,_Lv) when _ServerLv >= 251, _ServerLv =< 260, _Lv >= 221, _Lv =< 230 ->
		110;
get_add(_ServerLv,_Lv) when _ServerLv >= 251, _ServerLv =< 260, _Lv >= 231, _Lv =< 240 ->
		65;
get_add(_ServerLv,_Lv) when _ServerLv >= 251, _ServerLv =< 260, _Lv >= 241, _Lv =< 250 ->
		35;
get_add(_ServerLv,_Lv) when _ServerLv >= 261, _ServerLv =< 270, _Lv >= 121, _Lv =< 130 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 261, _ServerLv =< 270, _Lv >= 131, _Lv =< 140 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 261, _ServerLv =< 270, _Lv >= 141, _Lv =< 150 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 261, _ServerLv =< 270, _Lv >= 151, _Lv =< 160 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 261, _ServerLv =< 270, _Lv >= 161, _Lv =< 170 ->
		440;
get_add(_ServerLv,_Lv) when _ServerLv >= 261, _ServerLv =< 270, _Lv >= 171, _Lv =< 180 ->
		385;
get_add(_ServerLv,_Lv) when _ServerLv >= 261, _ServerLv =< 270, _Lv >= 181, _Lv =< 190 ->
		330;
get_add(_ServerLv,_Lv) when _ServerLv >= 261, _ServerLv =< 270, _Lv >= 191, _Lv =< 200 ->
		275;
get_add(_ServerLv,_Lv) when _ServerLv >= 261, _ServerLv =< 270, _Lv >= 201, _Lv =< 210 ->
		275;
get_add(_ServerLv,_Lv) when _ServerLv >= 261, _ServerLv =< 270, _Lv >= 211, _Lv =< 220 ->
		220;
get_add(_ServerLv,_Lv) when _ServerLv >= 261, _ServerLv =< 270, _Lv >= 221, _Lv =< 230 ->
		165;
get_add(_ServerLv,_Lv) when _ServerLv >= 261, _ServerLv =< 270, _Lv >= 231, _Lv =< 240 ->
		110;
get_add(_ServerLv,_Lv) when _ServerLv >= 261, _ServerLv =< 270, _Lv >= 241, _Lv =< 250 ->
		65;
get_add(_ServerLv,_Lv) when _ServerLv >= 261, _ServerLv =< 270, _Lv >= 251, _Lv =< 260 ->
		35;
get_add(_ServerLv,_Lv) when _ServerLv >= 271, _ServerLv =< 280, _Lv >= 121, _Lv =< 130 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 271, _ServerLv =< 280, _Lv >= 131, _Lv =< 140 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 271, _ServerLv =< 280, _Lv >= 141, _Lv =< 150 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 271, _ServerLv =< 280, _Lv >= 151, _Lv =< 160 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 271, _ServerLv =< 280, _Lv >= 161, _Lv =< 170 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 271, _ServerLv =< 280, _Lv >= 171, _Lv =< 180 ->
		440;
get_add(_ServerLv,_Lv) when _ServerLv >= 271, _ServerLv =< 280, _Lv >= 181, _Lv =< 190 ->
		385;
get_add(_ServerLv,_Lv) when _ServerLv >= 271, _ServerLv =< 280, _Lv >= 191, _Lv =< 200 ->
		330;
get_add(_ServerLv,_Lv) when _ServerLv >= 271, _ServerLv =< 280, _Lv >= 201, _Lv =< 210 ->
		275;
get_add(_ServerLv,_Lv) when _ServerLv >= 271, _ServerLv =< 280, _Lv >= 211, _Lv =< 220 ->
		275;
get_add(_ServerLv,_Lv) when _ServerLv >= 271, _ServerLv =< 280, _Lv >= 221, _Lv =< 230 ->
		220;
get_add(_ServerLv,_Lv) when _ServerLv >= 271, _ServerLv =< 280, _Lv >= 231, _Lv =< 240 ->
		165;
get_add(_ServerLv,_Lv) when _ServerLv >= 271, _ServerLv =< 280, _Lv >= 241, _Lv =< 250 ->
		110;
get_add(_ServerLv,_Lv) when _ServerLv >= 271, _ServerLv =< 280, _Lv >= 251, _Lv =< 260 ->
		65;
get_add(_ServerLv,_Lv) when _ServerLv >= 271, _ServerLv =< 280, _Lv >= 261, _Lv =< 270 ->
		35;
get_add(_ServerLv,_Lv) when _ServerLv >= 281, _ServerLv =< 290, _Lv >= 121, _Lv =< 130 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 281, _ServerLv =< 290, _Lv >= 131, _Lv =< 140 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 281, _ServerLv =< 290, _Lv >= 141, _Lv =< 150 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 281, _ServerLv =< 290, _Lv >= 151, _Lv =< 160 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 281, _ServerLv =< 290, _Lv >= 161, _Lv =< 170 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 281, _ServerLv =< 290, _Lv >= 171, _Lv =< 180 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 281, _ServerLv =< 290, _Lv >= 181, _Lv =< 190 ->
		440;
get_add(_ServerLv,_Lv) when _ServerLv >= 281, _ServerLv =< 290, _Lv >= 191, _Lv =< 200 ->
		385;
get_add(_ServerLv,_Lv) when _ServerLv >= 281, _ServerLv =< 290, _Lv >= 201, _Lv =< 210 ->
		330;
get_add(_ServerLv,_Lv) when _ServerLv >= 281, _ServerLv =< 290, _Lv >= 211, _Lv =< 220 ->
		275;
get_add(_ServerLv,_Lv) when _ServerLv >= 281, _ServerLv =< 290, _Lv >= 221, _Lv =< 230 ->
		275;
get_add(_ServerLv,_Lv) when _ServerLv >= 281, _ServerLv =< 290, _Lv >= 231, _Lv =< 240 ->
		220;
get_add(_ServerLv,_Lv) when _ServerLv >= 281, _ServerLv =< 290, _Lv >= 241, _Lv =< 250 ->
		165;
get_add(_ServerLv,_Lv) when _ServerLv >= 281, _ServerLv =< 290, _Lv >= 251, _Lv =< 260 ->
		110;
get_add(_ServerLv,_Lv) when _ServerLv >= 281, _ServerLv =< 290, _Lv >= 261, _Lv =< 270 ->
		65;
get_add(_ServerLv,_Lv) when _ServerLv >= 281, _ServerLv =< 290, _Lv >= 271, _Lv =< 280 ->
		35;
get_add(_ServerLv,_Lv) when _ServerLv >= 291, _ServerLv =< 300, _Lv >= 121, _Lv =< 130 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 291, _ServerLv =< 300, _Lv >= 131, _Lv =< 140 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 291, _ServerLv =< 300, _Lv >= 141, _Lv =< 150 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 291, _ServerLv =< 300, _Lv >= 151, _Lv =< 160 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 291, _ServerLv =< 300, _Lv >= 161, _Lv =< 170 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 291, _ServerLv =< 300, _Lv >= 171, _Lv =< 180 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 291, _ServerLv =< 300, _Lv >= 181, _Lv =< 190 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 291, _ServerLv =< 300, _Lv >= 191, _Lv =< 200 ->
		440;
get_add(_ServerLv,_Lv) when _ServerLv >= 291, _ServerLv =< 300, _Lv >= 201, _Lv =< 210 ->
		385;
get_add(_ServerLv,_Lv) when _ServerLv >= 291, _ServerLv =< 300, _Lv >= 211, _Lv =< 220 ->
		330;
get_add(_ServerLv,_Lv) when _ServerLv >= 291, _ServerLv =< 300, _Lv >= 221, _Lv =< 230 ->
		275;
get_add(_ServerLv,_Lv) when _ServerLv >= 291, _ServerLv =< 300, _Lv >= 231, _Lv =< 240 ->
		275;
get_add(_ServerLv,_Lv) when _ServerLv >= 291, _ServerLv =< 300, _Lv >= 241, _Lv =< 250 ->
		220;
get_add(_ServerLv,_Lv) when _ServerLv >= 291, _ServerLv =< 300, _Lv >= 251, _Lv =< 260 ->
		165;
get_add(_ServerLv,_Lv) when _ServerLv >= 291, _ServerLv =< 300, _Lv >= 261, _Lv =< 270 ->
		110;
get_add(_ServerLv,_Lv) when _ServerLv >= 291, _ServerLv =< 300, _Lv >= 271, _Lv =< 280 ->
		65;
get_add(_ServerLv,_Lv) when _ServerLv >= 291, _ServerLv =< 300, _Lv >= 281, _Lv =< 290 ->
		35;
get_add(_ServerLv,_Lv) when _ServerLv >= 301, _ServerLv =< 310, _Lv >= 121, _Lv =< 130 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 301, _ServerLv =< 310, _Lv >= 131, _Lv =< 140 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 301, _ServerLv =< 310, _Lv >= 141, _Lv =< 150 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 301, _ServerLv =< 310, _Lv >= 151, _Lv =< 160 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 301, _ServerLv =< 310, _Lv >= 161, _Lv =< 170 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 301, _ServerLv =< 310, _Lv >= 171, _Lv =< 180 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 301, _ServerLv =< 310, _Lv >= 181, _Lv =< 190 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 301, _ServerLv =< 310, _Lv >= 191, _Lv =< 200 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 301, _ServerLv =< 310, _Lv >= 201, _Lv =< 210 ->
		440;
get_add(_ServerLv,_Lv) when _ServerLv >= 301, _ServerLv =< 310, _Lv >= 211, _Lv =< 220 ->
		385;
get_add(_ServerLv,_Lv) when _ServerLv >= 301, _ServerLv =< 310, _Lv >= 221, _Lv =< 230 ->
		330;
get_add(_ServerLv,_Lv) when _ServerLv >= 301, _ServerLv =< 310, _Lv >= 231, _Lv =< 240 ->
		275;
get_add(_ServerLv,_Lv) when _ServerLv >= 301, _ServerLv =< 310, _Lv >= 241, _Lv =< 250 ->
		275;
get_add(_ServerLv,_Lv) when _ServerLv >= 301, _ServerLv =< 310, _Lv >= 251, _Lv =< 260 ->
		220;
get_add(_ServerLv,_Lv) when _ServerLv >= 301, _ServerLv =< 310, _Lv >= 261, _Lv =< 270 ->
		165;
get_add(_ServerLv,_Lv) when _ServerLv >= 301, _ServerLv =< 310, _Lv >= 271, _Lv =< 280 ->
		110;
get_add(_ServerLv,_Lv) when _ServerLv >= 301, _ServerLv =< 310, _Lv >= 281, _Lv =< 290 ->
		65;
get_add(_ServerLv,_Lv) when _ServerLv >= 301, _ServerLv =< 310, _Lv >= 291, _Lv =< 300 ->
		35;
get_add(_ServerLv,_Lv) when _ServerLv >= 311, _ServerLv =< 320, _Lv >= 121, _Lv =< 130 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 311, _ServerLv =< 320, _Lv >= 131, _Lv =< 140 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 311, _ServerLv =< 320, _Lv >= 141, _Lv =< 150 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 311, _ServerLv =< 320, _Lv >= 151, _Lv =< 160 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 311, _ServerLv =< 320, _Lv >= 161, _Lv =< 170 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 311, _ServerLv =< 320, _Lv >= 171, _Lv =< 180 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 311, _ServerLv =< 320, _Lv >= 181, _Lv =< 190 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 311, _ServerLv =< 320, _Lv >= 191, _Lv =< 200 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 311, _ServerLv =< 320, _Lv >= 201, _Lv =< 210 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 311, _ServerLv =< 320, _Lv >= 211, _Lv =< 220 ->
		440;
get_add(_ServerLv,_Lv) when _ServerLv >= 311, _ServerLv =< 320, _Lv >= 221, _Lv =< 230 ->
		385;
get_add(_ServerLv,_Lv) when _ServerLv >= 311, _ServerLv =< 320, _Lv >= 231, _Lv =< 240 ->
		330;
get_add(_ServerLv,_Lv) when _ServerLv >= 311, _ServerLv =< 320, _Lv >= 241, _Lv =< 250 ->
		275;
get_add(_ServerLv,_Lv) when _ServerLv >= 311, _ServerLv =< 320, _Lv >= 251, _Lv =< 260 ->
		275;
get_add(_ServerLv,_Lv) when _ServerLv >= 311, _ServerLv =< 320, _Lv >= 261, _Lv =< 270 ->
		220;
get_add(_ServerLv,_Lv) when _ServerLv >= 311, _ServerLv =< 320, _Lv >= 271, _Lv =< 280 ->
		165;
get_add(_ServerLv,_Lv) when _ServerLv >= 311, _ServerLv =< 320, _Lv >= 281, _Lv =< 290 ->
		110;
get_add(_ServerLv,_Lv) when _ServerLv >= 311, _ServerLv =< 320, _Lv >= 291, _Lv =< 300 ->
		65;
get_add(_ServerLv,_Lv) when _ServerLv >= 311, _ServerLv =< 320, _Lv >= 301, _Lv =< 310 ->
		35;
get_add(_ServerLv,_Lv) when _ServerLv >= 321, _ServerLv =< 330, _Lv >= 121, _Lv =< 130 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 321, _ServerLv =< 330, _Lv >= 131, _Lv =< 140 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 321, _ServerLv =< 330, _Lv >= 141, _Lv =< 150 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 321, _ServerLv =< 330, _Lv >= 151, _Lv =< 160 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 321, _ServerLv =< 330, _Lv >= 161, _Lv =< 170 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 321, _ServerLv =< 330, _Lv >= 171, _Lv =< 180 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 321, _ServerLv =< 330, _Lv >= 181, _Lv =< 190 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 321, _ServerLv =< 330, _Lv >= 191, _Lv =< 200 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 321, _ServerLv =< 330, _Lv >= 201, _Lv =< 210 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 321, _ServerLv =< 330, _Lv >= 211, _Lv =< 220 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 321, _ServerLv =< 330, _Lv >= 221, _Lv =< 230 ->
		440;
get_add(_ServerLv,_Lv) when _ServerLv >= 321, _ServerLv =< 330, _Lv >= 231, _Lv =< 240 ->
		385;
get_add(_ServerLv,_Lv) when _ServerLv >= 321, _ServerLv =< 330, _Lv >= 241, _Lv =< 250 ->
		330;
get_add(_ServerLv,_Lv) when _ServerLv >= 321, _ServerLv =< 330, _Lv >= 251, _Lv =< 260 ->
		275;
get_add(_ServerLv,_Lv) when _ServerLv >= 321, _ServerLv =< 330, _Lv >= 261, _Lv =< 270 ->
		275;
get_add(_ServerLv,_Lv) when _ServerLv >= 321, _ServerLv =< 330, _Lv >= 271, _Lv =< 280 ->
		220;
get_add(_ServerLv,_Lv) when _ServerLv >= 321, _ServerLv =< 330, _Lv >= 281, _Lv =< 290 ->
		165;
get_add(_ServerLv,_Lv) when _ServerLv >= 321, _ServerLv =< 330, _Lv >= 291, _Lv =< 300 ->
		110;
get_add(_ServerLv,_Lv) when _ServerLv >= 321, _ServerLv =< 330, _Lv >= 301, _Lv =< 310 ->
		65;
get_add(_ServerLv,_Lv) when _ServerLv >= 321, _ServerLv =< 330, _Lv >= 311, _Lv =< 320 ->
		35;
get_add(_ServerLv,_Lv) when _ServerLv >= 331, _ServerLv =< 340, _Lv >= 121, _Lv =< 130 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 331, _ServerLv =< 340, _Lv >= 131, _Lv =< 140 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 331, _ServerLv =< 340, _Lv >= 141, _Lv =< 150 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 331, _ServerLv =< 340, _Lv >= 151, _Lv =< 160 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 331, _ServerLv =< 340, _Lv >= 161, _Lv =< 170 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 331, _ServerLv =< 340, _Lv >= 171, _Lv =< 180 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 331, _ServerLv =< 340, _Lv >= 181, _Lv =< 190 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 331, _ServerLv =< 340, _Lv >= 191, _Lv =< 200 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 331, _ServerLv =< 340, _Lv >= 201, _Lv =< 210 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 331, _ServerLv =< 340, _Lv >= 211, _Lv =< 220 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 331, _ServerLv =< 340, _Lv >= 221, _Lv =< 230 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 331, _ServerLv =< 340, _Lv >= 231, _Lv =< 240 ->
		440;
get_add(_ServerLv,_Lv) when _ServerLv >= 331, _ServerLv =< 340, _Lv >= 241, _Lv =< 250 ->
		385;
get_add(_ServerLv,_Lv) when _ServerLv >= 331, _ServerLv =< 340, _Lv >= 251, _Lv =< 260 ->
		330;
get_add(_ServerLv,_Lv) when _ServerLv >= 331, _ServerLv =< 340, _Lv >= 261, _Lv =< 270 ->
		275;
get_add(_ServerLv,_Lv) when _ServerLv >= 331, _ServerLv =< 340, _Lv >= 271, _Lv =< 280 ->
		275;
get_add(_ServerLv,_Lv) when _ServerLv >= 331, _ServerLv =< 340, _Lv >= 281, _Lv =< 290 ->
		220;
get_add(_ServerLv,_Lv) when _ServerLv >= 331, _ServerLv =< 340, _Lv >= 291, _Lv =< 300 ->
		165;
get_add(_ServerLv,_Lv) when _ServerLv >= 331, _ServerLv =< 340, _Lv >= 301, _Lv =< 310 ->
		110;
get_add(_ServerLv,_Lv) when _ServerLv >= 331, _ServerLv =< 340, _Lv >= 311, _Lv =< 320 ->
		65;
get_add(_ServerLv,_Lv) when _ServerLv >= 331, _ServerLv =< 340, _Lv >= 321, _Lv =< 330 ->
		35;
get_add(_ServerLv,_Lv) when _ServerLv >= 341, _ServerLv =< 350, _Lv >= 121, _Lv =< 130 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 341, _ServerLv =< 350, _Lv >= 131, _Lv =< 140 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 341, _ServerLv =< 350, _Lv >= 141, _Lv =< 150 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 341, _ServerLv =< 350, _Lv >= 151, _Lv =< 160 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 341, _ServerLv =< 350, _Lv >= 161, _Lv =< 170 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 341, _ServerLv =< 350, _Lv >= 171, _Lv =< 180 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 341, _ServerLv =< 350, _Lv >= 181, _Lv =< 190 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 341, _ServerLv =< 350, _Lv >= 191, _Lv =< 200 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 341, _ServerLv =< 350, _Lv >= 201, _Lv =< 210 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 341, _ServerLv =< 350, _Lv >= 211, _Lv =< 220 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 341, _ServerLv =< 350, _Lv >= 221, _Lv =< 230 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 341, _ServerLv =< 350, _Lv >= 231, _Lv =< 240 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 341, _ServerLv =< 350, _Lv >= 241, _Lv =< 250 ->
		440;
get_add(_ServerLv,_Lv) when _ServerLv >= 341, _ServerLv =< 350, _Lv >= 251, _Lv =< 260 ->
		385;
get_add(_ServerLv,_Lv) when _ServerLv >= 341, _ServerLv =< 350, _Lv >= 261, _Lv =< 270 ->
		330;
get_add(_ServerLv,_Lv) when _ServerLv >= 341, _ServerLv =< 350, _Lv >= 271, _Lv =< 280 ->
		275;
get_add(_ServerLv,_Lv) when _ServerLv >= 341, _ServerLv =< 350, _Lv >= 281, _Lv =< 290 ->
		275;
get_add(_ServerLv,_Lv) when _ServerLv >= 341, _ServerLv =< 350, _Lv >= 291, _Lv =< 300 ->
		220;
get_add(_ServerLv,_Lv) when _ServerLv >= 341, _ServerLv =< 350, _Lv >= 301, _Lv =< 310 ->
		165;
get_add(_ServerLv,_Lv) when _ServerLv >= 341, _ServerLv =< 350, _Lv >= 311, _Lv =< 320 ->
		110;
get_add(_ServerLv,_Lv) when _ServerLv >= 341, _ServerLv =< 350, _Lv >= 321, _Lv =< 330 ->
		65;
get_add(_ServerLv,_Lv) when _ServerLv >= 341, _ServerLv =< 350, _Lv >= 331, _Lv =< 340 ->
		35;
get_add(_ServerLv,_Lv) when _ServerLv >= 351, _ServerLv =< 360, _Lv >= 121, _Lv =< 130 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 351, _ServerLv =< 360, _Lv >= 131, _Lv =< 140 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 351, _ServerLv =< 360, _Lv >= 141, _Lv =< 150 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 351, _ServerLv =< 360, _Lv >= 151, _Lv =< 160 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 351, _ServerLv =< 360, _Lv >= 161, _Lv =< 170 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 351, _ServerLv =< 360, _Lv >= 171, _Lv =< 180 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 351, _ServerLv =< 360, _Lv >= 181, _Lv =< 190 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 351, _ServerLv =< 360, _Lv >= 191, _Lv =< 200 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 351, _ServerLv =< 360, _Lv >= 201, _Lv =< 210 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 351, _ServerLv =< 360, _Lv >= 211, _Lv =< 220 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 351, _ServerLv =< 360, _Lv >= 221, _Lv =< 230 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 351, _ServerLv =< 360, _Lv >= 231, _Lv =< 240 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 351, _ServerLv =< 360, _Lv >= 241, _Lv =< 250 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 351, _ServerLv =< 360, _Lv >= 251, _Lv =< 260 ->
		440;
get_add(_ServerLv,_Lv) when _ServerLv >= 351, _ServerLv =< 360, _Lv >= 261, _Lv =< 270 ->
		385;
get_add(_ServerLv,_Lv) when _ServerLv >= 351, _ServerLv =< 360, _Lv >= 271, _Lv =< 280 ->
		330;
get_add(_ServerLv,_Lv) when _ServerLv >= 351, _ServerLv =< 360, _Lv >= 281, _Lv =< 290 ->
		275;
get_add(_ServerLv,_Lv) when _ServerLv >= 351, _ServerLv =< 360, _Lv >= 291, _Lv =< 300 ->
		275;
get_add(_ServerLv,_Lv) when _ServerLv >= 351, _ServerLv =< 360, _Lv >= 301, _Lv =< 310 ->
		220;
get_add(_ServerLv,_Lv) when _ServerLv >= 351, _ServerLv =< 360, _Lv >= 311, _Lv =< 320 ->
		165;
get_add(_ServerLv,_Lv) when _ServerLv >= 351, _ServerLv =< 360, _Lv >= 321, _Lv =< 330 ->
		110;
get_add(_ServerLv,_Lv) when _ServerLv >= 351, _ServerLv =< 360, _Lv >= 331, _Lv =< 340 ->
		65;
get_add(_ServerLv,_Lv) when _ServerLv >= 351, _ServerLv =< 360, _Lv >= 341, _Lv =< 350 ->
		35;
get_add(_ServerLv,_Lv) when _ServerLv >= 361, _ServerLv =< 370, _Lv >= 121, _Lv =< 130 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 361, _ServerLv =< 370, _Lv >= 131, _Lv =< 140 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 361, _ServerLv =< 370, _Lv >= 141, _Lv =< 150 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 361, _ServerLv =< 370, _Lv >= 151, _Lv =< 160 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 361, _ServerLv =< 370, _Lv >= 161, _Lv =< 170 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 361, _ServerLv =< 370, _Lv >= 171, _Lv =< 180 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 361, _ServerLv =< 370, _Lv >= 181, _Lv =< 190 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 361, _ServerLv =< 370, _Lv >= 191, _Lv =< 200 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 361, _ServerLv =< 370, _Lv >= 201, _Lv =< 210 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 361, _ServerLv =< 370, _Lv >= 211, _Lv =< 220 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 361, _ServerLv =< 370, _Lv >= 221, _Lv =< 230 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 361, _ServerLv =< 370, _Lv >= 231, _Lv =< 240 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 361, _ServerLv =< 370, _Lv >= 241, _Lv =< 250 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 361, _ServerLv =< 370, _Lv >= 251, _Lv =< 260 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 361, _ServerLv =< 370, _Lv >= 261, _Lv =< 270 ->
		440;
get_add(_ServerLv,_Lv) when _ServerLv >= 361, _ServerLv =< 370, _Lv >= 271, _Lv =< 280 ->
		385;
get_add(_ServerLv,_Lv) when _ServerLv >= 361, _ServerLv =< 370, _Lv >= 281, _Lv =< 290 ->
		330;
get_add(_ServerLv,_Lv) when _ServerLv >= 361, _ServerLv =< 370, _Lv >= 291, _Lv =< 300 ->
		275;
get_add(_ServerLv,_Lv) when _ServerLv >= 361, _ServerLv =< 370, _Lv >= 301, _Lv =< 310 ->
		275;
get_add(_ServerLv,_Lv) when _ServerLv >= 361, _ServerLv =< 370, _Lv >= 311, _Lv =< 320 ->
		220;
get_add(_ServerLv,_Lv) when _ServerLv >= 361, _ServerLv =< 370, _Lv >= 321, _Lv =< 330 ->
		165;
get_add(_ServerLv,_Lv) when _ServerLv >= 361, _ServerLv =< 370, _Lv >= 331, _Lv =< 340 ->
		110;
get_add(_ServerLv,_Lv) when _ServerLv >= 361, _ServerLv =< 370, _Lv >= 341, _Lv =< 350 ->
		65;
get_add(_ServerLv,_Lv) when _ServerLv >= 361, _ServerLv =< 370, _Lv >= 351, _Lv =< 360 ->
		35;
get_add(_ServerLv,_Lv) when _ServerLv >= 371, _ServerLv =< 380, _Lv >= 121, _Lv =< 130 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 371, _ServerLv =< 380, _Lv >= 131, _Lv =< 140 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 371, _ServerLv =< 380, _Lv >= 141, _Lv =< 150 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 371, _ServerLv =< 380, _Lv >= 151, _Lv =< 160 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 371, _ServerLv =< 380, _Lv >= 161, _Lv =< 170 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 371, _ServerLv =< 380, _Lv >= 171, _Lv =< 180 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 371, _ServerLv =< 380, _Lv >= 181, _Lv =< 190 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 371, _ServerLv =< 380, _Lv >= 191, _Lv =< 200 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 371, _ServerLv =< 380, _Lv >= 201, _Lv =< 210 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 371, _ServerLv =< 380, _Lv >= 211, _Lv =< 220 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 371, _ServerLv =< 380, _Lv >= 221, _Lv =< 230 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 371, _ServerLv =< 380, _Lv >= 231, _Lv =< 240 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 371, _ServerLv =< 380, _Lv >= 241, _Lv =< 250 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 371, _ServerLv =< 380, _Lv >= 251, _Lv =< 260 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 371, _ServerLv =< 380, _Lv >= 261, _Lv =< 270 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 371, _ServerLv =< 380, _Lv >= 271, _Lv =< 280 ->
		440;
get_add(_ServerLv,_Lv) when _ServerLv >= 371, _ServerLv =< 380, _Lv >= 281, _Lv =< 290 ->
		385;
get_add(_ServerLv,_Lv) when _ServerLv >= 371, _ServerLv =< 380, _Lv >= 291, _Lv =< 300 ->
		330;
get_add(_ServerLv,_Lv) when _ServerLv >= 371, _ServerLv =< 380, _Lv >= 301, _Lv =< 310 ->
		275;
get_add(_ServerLv,_Lv) when _ServerLv >= 371, _ServerLv =< 380, _Lv >= 311, _Lv =< 320 ->
		275;
get_add(_ServerLv,_Lv) when _ServerLv >= 371, _ServerLv =< 380, _Lv >= 321, _Lv =< 330 ->
		220;
get_add(_ServerLv,_Lv) when _ServerLv >= 371, _ServerLv =< 380, _Lv >= 331, _Lv =< 340 ->
		165;
get_add(_ServerLv,_Lv) when _ServerLv >= 371, _ServerLv =< 380, _Lv >= 341, _Lv =< 350 ->
		110;
get_add(_ServerLv,_Lv) when _ServerLv >= 371, _ServerLv =< 380, _Lv >= 351, _Lv =< 360 ->
		65;
get_add(_ServerLv,_Lv) when _ServerLv >= 371, _ServerLv =< 380, _Lv >= 361, _Lv =< 370 ->
		35;
get_add(_ServerLv,_Lv) when _ServerLv >= 381, _ServerLv =< 390, _Lv >= 121, _Lv =< 130 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 381, _ServerLv =< 390, _Lv >= 131, _Lv =< 140 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 381, _ServerLv =< 390, _Lv >= 141, _Lv =< 150 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 381, _ServerLv =< 390, _Lv >= 151, _Lv =< 160 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 381, _ServerLv =< 390, _Lv >= 161, _Lv =< 170 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 381, _ServerLv =< 390, _Lv >= 171, _Lv =< 180 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 381, _ServerLv =< 390, _Lv >= 181, _Lv =< 190 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 381, _ServerLv =< 390, _Lv >= 191, _Lv =< 200 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 381, _ServerLv =< 390, _Lv >= 201, _Lv =< 210 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 381, _ServerLv =< 390, _Lv >= 211, _Lv =< 220 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 381, _ServerLv =< 390, _Lv >= 221, _Lv =< 230 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 381, _ServerLv =< 390, _Lv >= 231, _Lv =< 240 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 381, _ServerLv =< 390, _Lv >= 241, _Lv =< 250 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 381, _ServerLv =< 390, _Lv >= 251, _Lv =< 260 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 381, _ServerLv =< 390, _Lv >= 261, _Lv =< 270 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 381, _ServerLv =< 390, _Lv >= 271, _Lv =< 280 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 381, _ServerLv =< 390, _Lv >= 281, _Lv =< 290 ->
		440;
get_add(_ServerLv,_Lv) when _ServerLv >= 381, _ServerLv =< 390, _Lv >= 291, _Lv =< 300 ->
		385;
get_add(_ServerLv,_Lv) when _ServerLv >= 381, _ServerLv =< 390, _Lv >= 301, _Lv =< 310 ->
		330;
get_add(_ServerLv,_Lv) when _ServerLv >= 381, _ServerLv =< 390, _Lv >= 311, _Lv =< 320 ->
		275;
get_add(_ServerLv,_Lv) when _ServerLv >= 381, _ServerLv =< 390, _Lv >= 321, _Lv =< 330 ->
		275;
get_add(_ServerLv,_Lv) when _ServerLv >= 381, _ServerLv =< 390, _Lv >= 331, _Lv =< 340 ->
		220;
get_add(_ServerLv,_Lv) when _ServerLv >= 381, _ServerLv =< 390, _Lv >= 341, _Lv =< 350 ->
		165;
get_add(_ServerLv,_Lv) when _ServerLv >= 381, _ServerLv =< 390, _Lv >= 351, _Lv =< 360 ->
		110;
get_add(_ServerLv,_Lv) when _ServerLv >= 381, _ServerLv =< 390, _Lv >= 361, _Lv =< 370 ->
		65;
get_add(_ServerLv,_Lv) when _ServerLv >= 381, _ServerLv =< 390, _Lv >= 371, _Lv =< 380 ->
		35;
get_add(_ServerLv,_Lv) when _ServerLv >= 391, _ServerLv =< 400, _Lv >= 121, _Lv =< 130 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 391, _ServerLv =< 400, _Lv >= 131, _Lv =< 140 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 391, _ServerLv =< 400, _Lv >= 141, _Lv =< 150 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 391, _ServerLv =< 400, _Lv >= 151, _Lv =< 160 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 391, _ServerLv =< 400, _Lv >= 161, _Lv =< 170 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 391, _ServerLv =< 400, _Lv >= 171, _Lv =< 180 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 391, _ServerLv =< 400, _Lv >= 181, _Lv =< 190 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 391, _ServerLv =< 400, _Lv >= 191, _Lv =< 200 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 391, _ServerLv =< 400, _Lv >= 201, _Lv =< 210 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 391, _ServerLv =< 400, _Lv >= 211, _Lv =< 220 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 391, _ServerLv =< 400, _Lv >= 221, _Lv =< 230 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 391, _ServerLv =< 400, _Lv >= 231, _Lv =< 240 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 391, _ServerLv =< 400, _Lv >= 241, _Lv =< 250 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 391, _ServerLv =< 400, _Lv >= 251, _Lv =< 260 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 391, _ServerLv =< 400, _Lv >= 261, _Lv =< 270 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 391, _ServerLv =< 400, _Lv >= 271, _Lv =< 280 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 391, _ServerLv =< 400, _Lv >= 281, _Lv =< 290 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 391, _ServerLv =< 400, _Lv >= 291, _Lv =< 300 ->
		440;
get_add(_ServerLv,_Lv) when _ServerLv >= 391, _ServerLv =< 400, _Lv >= 301, _Lv =< 310 ->
		385;
get_add(_ServerLv,_Lv) when _ServerLv >= 391, _ServerLv =< 400, _Lv >= 311, _Lv =< 320 ->
		330;
get_add(_ServerLv,_Lv) when _ServerLv >= 391, _ServerLv =< 400, _Lv >= 321, _Lv =< 330 ->
		275;
get_add(_ServerLv,_Lv) when _ServerLv >= 391, _ServerLv =< 400, _Lv >= 331, _Lv =< 340 ->
		275;
get_add(_ServerLv,_Lv) when _ServerLv >= 391, _ServerLv =< 400, _Lv >= 341, _Lv =< 350 ->
		220;
get_add(_ServerLv,_Lv) when _ServerLv >= 391, _ServerLv =< 400, _Lv >= 351, _Lv =< 360 ->
		165;
get_add(_ServerLv,_Lv) when _ServerLv >= 391, _ServerLv =< 400, _Lv >= 361, _Lv =< 370 ->
		110;
get_add(_ServerLv,_Lv) when _ServerLv >= 391, _ServerLv =< 400, _Lv >= 371, _Lv =< 380 ->
		65;
get_add(_ServerLv,_Lv) when _ServerLv >= 391, _ServerLv =< 400, _Lv >= 381, _Lv =< 390 ->
		35;
get_add(_ServerLv,_Lv) when _ServerLv >= 401, _ServerLv =< 410, _Lv >= 121, _Lv =< 130 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 401, _ServerLv =< 410, _Lv >= 131, _Lv =< 140 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 401, _ServerLv =< 410, _Lv >= 141, _Lv =< 150 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 401, _ServerLv =< 410, _Lv >= 151, _Lv =< 160 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 401, _ServerLv =< 410, _Lv >= 161, _Lv =< 170 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 401, _ServerLv =< 410, _Lv >= 171, _Lv =< 180 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 401, _ServerLv =< 410, _Lv >= 181, _Lv =< 190 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 401, _ServerLv =< 410, _Lv >= 191, _Lv =< 200 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 401, _ServerLv =< 410, _Lv >= 201, _Lv =< 210 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 401, _ServerLv =< 410, _Lv >= 211, _Lv =< 220 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 401, _ServerLv =< 410, _Lv >= 221, _Lv =< 230 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 401, _ServerLv =< 410, _Lv >= 231, _Lv =< 240 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 401, _ServerLv =< 410, _Lv >= 241, _Lv =< 250 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 401, _ServerLv =< 410, _Lv >= 251, _Lv =< 260 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 401, _ServerLv =< 410, _Lv >= 261, _Lv =< 270 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 401, _ServerLv =< 410, _Lv >= 271, _Lv =< 280 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 401, _ServerLv =< 410, _Lv >= 281, _Lv =< 290 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 401, _ServerLv =< 410, _Lv >= 291, _Lv =< 300 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 401, _ServerLv =< 410, _Lv >= 301, _Lv =< 310 ->
		440;
get_add(_ServerLv,_Lv) when _ServerLv >= 401, _ServerLv =< 410, _Lv >= 311, _Lv =< 320 ->
		385;
get_add(_ServerLv,_Lv) when _ServerLv >= 401, _ServerLv =< 410, _Lv >= 321, _Lv =< 330 ->
		330;
get_add(_ServerLv,_Lv) when _ServerLv >= 401, _ServerLv =< 410, _Lv >= 331, _Lv =< 340 ->
		275;
get_add(_ServerLv,_Lv) when _ServerLv >= 401, _ServerLv =< 410, _Lv >= 341, _Lv =< 350 ->
		275;
get_add(_ServerLv,_Lv) when _ServerLv >= 401, _ServerLv =< 410, _Lv >= 351, _Lv =< 360 ->
		220;
get_add(_ServerLv,_Lv) when _ServerLv >= 401, _ServerLv =< 410, _Lv >= 361, _Lv =< 370 ->
		165;
get_add(_ServerLv,_Lv) when _ServerLv >= 401, _ServerLv =< 410, _Lv >= 371, _Lv =< 380 ->
		110;
get_add(_ServerLv,_Lv) when _ServerLv >= 401, _ServerLv =< 410, _Lv >= 381, _Lv =< 390 ->
		65;
get_add(_ServerLv,_Lv) when _ServerLv >= 401, _ServerLv =< 410, _Lv >= 391, _Lv =< 400 ->
		35;
get_add(_ServerLv,_Lv) when _ServerLv >= 411, _ServerLv =< 420, _Lv >= 121, _Lv =< 130 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 411, _ServerLv =< 420, _Lv >= 131, _Lv =< 140 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 411, _ServerLv =< 420, _Lv >= 141, _Lv =< 150 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 411, _ServerLv =< 420, _Lv >= 151, _Lv =< 160 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 411, _ServerLv =< 420, _Lv >= 161, _Lv =< 170 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 411, _ServerLv =< 420, _Lv >= 171, _Lv =< 180 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 411, _ServerLv =< 420, _Lv >= 181, _Lv =< 190 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 411, _ServerLv =< 420, _Lv >= 191, _Lv =< 200 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 411, _ServerLv =< 420, _Lv >= 201, _Lv =< 210 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 411, _ServerLv =< 420, _Lv >= 211, _Lv =< 220 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 411, _ServerLv =< 420, _Lv >= 221, _Lv =< 230 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 411, _ServerLv =< 420, _Lv >= 231, _Lv =< 240 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 411, _ServerLv =< 420, _Lv >= 241, _Lv =< 250 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 411, _ServerLv =< 420, _Lv >= 251, _Lv =< 260 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 411, _ServerLv =< 420, _Lv >= 261, _Lv =< 270 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 411, _ServerLv =< 420, _Lv >= 271, _Lv =< 280 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 411, _ServerLv =< 420, _Lv >= 281, _Lv =< 290 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 411, _ServerLv =< 420, _Lv >= 291, _Lv =< 300 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 411, _ServerLv =< 420, _Lv >= 301, _Lv =< 310 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 411, _ServerLv =< 420, _Lv >= 311, _Lv =< 320 ->
		440;
get_add(_ServerLv,_Lv) when _ServerLv >= 411, _ServerLv =< 420, _Lv >= 321, _Lv =< 330 ->
		385;
get_add(_ServerLv,_Lv) when _ServerLv >= 411, _ServerLv =< 420, _Lv >= 331, _Lv =< 340 ->
		330;
get_add(_ServerLv,_Lv) when _ServerLv >= 411, _ServerLv =< 420, _Lv >= 341, _Lv =< 350 ->
		275;
get_add(_ServerLv,_Lv) when _ServerLv >= 411, _ServerLv =< 420, _Lv >= 351, _Lv =< 360 ->
		275;
get_add(_ServerLv,_Lv) when _ServerLv >= 411, _ServerLv =< 420, _Lv >= 361, _Lv =< 370 ->
		220;
get_add(_ServerLv,_Lv) when _ServerLv >= 411, _ServerLv =< 420, _Lv >= 371, _Lv =< 380 ->
		165;
get_add(_ServerLv,_Lv) when _ServerLv >= 411, _ServerLv =< 420, _Lv >= 381, _Lv =< 390 ->
		110;
get_add(_ServerLv,_Lv) when _ServerLv >= 411, _ServerLv =< 420, _Lv >= 391, _Lv =< 400 ->
		65;
get_add(_ServerLv,_Lv) when _ServerLv >= 411, _ServerLv =< 420, _Lv >= 401, _Lv =< 410 ->
		35;
get_add(_ServerLv,_Lv) when _ServerLv >= 421, _ServerLv =< 430, _Lv >= 121, _Lv =< 130 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 421, _ServerLv =< 430, _Lv >= 131, _Lv =< 140 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 421, _ServerLv =< 430, _Lv >= 141, _Lv =< 150 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 421, _ServerLv =< 430, _Lv >= 151, _Lv =< 160 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 421, _ServerLv =< 430, _Lv >= 161, _Lv =< 170 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 421, _ServerLv =< 430, _Lv >= 171, _Lv =< 180 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 421, _ServerLv =< 430, _Lv >= 181, _Lv =< 190 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 421, _ServerLv =< 430, _Lv >= 191, _Lv =< 200 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 421, _ServerLv =< 430, _Lv >= 201, _Lv =< 210 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 421, _ServerLv =< 430, _Lv >= 211, _Lv =< 220 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 421, _ServerLv =< 430, _Lv >= 221, _Lv =< 230 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 421, _ServerLv =< 430, _Lv >= 231, _Lv =< 240 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 421, _ServerLv =< 430, _Lv >= 241, _Lv =< 250 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 421, _ServerLv =< 430, _Lv >= 251, _Lv =< 260 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 421, _ServerLv =< 430, _Lv >= 261, _Lv =< 270 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 421, _ServerLv =< 430, _Lv >= 271, _Lv =< 280 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 421, _ServerLv =< 430, _Lv >= 281, _Lv =< 290 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 421, _ServerLv =< 430, _Lv >= 291, _Lv =< 300 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 421, _ServerLv =< 430, _Lv >= 301, _Lv =< 310 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 421, _ServerLv =< 430, _Lv >= 311, _Lv =< 320 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 421, _ServerLv =< 430, _Lv >= 321, _Lv =< 330 ->
		440;
get_add(_ServerLv,_Lv) when _ServerLv >= 421, _ServerLv =< 430, _Lv >= 331, _Lv =< 340 ->
		385;
get_add(_ServerLv,_Lv) when _ServerLv >= 421, _ServerLv =< 430, _Lv >= 341, _Lv =< 350 ->
		330;
get_add(_ServerLv,_Lv) when _ServerLv >= 421, _ServerLv =< 430, _Lv >= 351, _Lv =< 360 ->
		275;
get_add(_ServerLv,_Lv) when _ServerLv >= 421, _ServerLv =< 430, _Lv >= 361, _Lv =< 370 ->
		275;
get_add(_ServerLv,_Lv) when _ServerLv >= 421, _ServerLv =< 430, _Lv >= 371, _Lv =< 380 ->
		220;
get_add(_ServerLv,_Lv) when _ServerLv >= 421, _ServerLv =< 430, _Lv >= 381, _Lv =< 390 ->
		165;
get_add(_ServerLv,_Lv) when _ServerLv >= 421, _ServerLv =< 430, _Lv >= 391, _Lv =< 400 ->
		110;
get_add(_ServerLv,_Lv) when _ServerLv >= 421, _ServerLv =< 430, _Lv >= 401, _Lv =< 410 ->
		65;
get_add(_ServerLv,_Lv) when _ServerLv >= 421, _ServerLv =< 430, _Lv >= 411, _Lv =< 420 ->
		35;
get_add(_ServerLv,_Lv) when _ServerLv >= 431, _ServerLv =< 440, _Lv >= 121, _Lv =< 130 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 431, _ServerLv =< 440, _Lv >= 131, _Lv =< 140 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 431, _ServerLv =< 440, _Lv >= 141, _Lv =< 150 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 431, _ServerLv =< 440, _Lv >= 151, _Lv =< 160 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 431, _ServerLv =< 440, _Lv >= 161, _Lv =< 170 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 431, _ServerLv =< 440, _Lv >= 171, _Lv =< 180 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 431, _ServerLv =< 440, _Lv >= 181, _Lv =< 190 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 431, _ServerLv =< 440, _Lv >= 191, _Lv =< 200 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 431, _ServerLv =< 440, _Lv >= 201, _Lv =< 210 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 431, _ServerLv =< 440, _Lv >= 211, _Lv =< 220 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 431, _ServerLv =< 440, _Lv >= 221, _Lv =< 230 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 431, _ServerLv =< 440, _Lv >= 231, _Lv =< 240 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 431, _ServerLv =< 440, _Lv >= 241, _Lv =< 250 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 431, _ServerLv =< 440, _Lv >= 251, _Lv =< 260 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 431, _ServerLv =< 440, _Lv >= 261, _Lv =< 270 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 431, _ServerLv =< 440, _Lv >= 271, _Lv =< 280 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 431, _ServerLv =< 440, _Lv >= 281, _Lv =< 290 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 431, _ServerLv =< 440, _Lv >= 291, _Lv =< 300 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 431, _ServerLv =< 440, _Lv >= 301, _Lv =< 310 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 431, _ServerLv =< 440, _Lv >= 311, _Lv =< 320 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 431, _ServerLv =< 440, _Lv >= 321, _Lv =< 330 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 431, _ServerLv =< 440, _Lv >= 331, _Lv =< 340 ->
		440;
get_add(_ServerLv,_Lv) when _ServerLv >= 431, _ServerLv =< 440, _Lv >= 341, _Lv =< 350 ->
		385;
get_add(_ServerLv,_Lv) when _ServerLv >= 431, _ServerLv =< 440, _Lv >= 351, _Lv =< 360 ->
		330;
get_add(_ServerLv,_Lv) when _ServerLv >= 431, _ServerLv =< 440, _Lv >= 361, _Lv =< 370 ->
		275;
get_add(_ServerLv,_Lv) when _ServerLv >= 431, _ServerLv =< 440, _Lv >= 371, _Lv =< 380 ->
		275;
get_add(_ServerLv,_Lv) when _ServerLv >= 431, _ServerLv =< 440, _Lv >= 381, _Lv =< 390 ->
		220;
get_add(_ServerLv,_Lv) when _ServerLv >= 431, _ServerLv =< 440, _Lv >= 391, _Lv =< 400 ->
		165;
get_add(_ServerLv,_Lv) when _ServerLv >= 431, _ServerLv =< 440, _Lv >= 401, _Lv =< 410 ->
		110;
get_add(_ServerLv,_Lv) when _ServerLv >= 431, _ServerLv =< 440, _Lv >= 411, _Lv =< 420 ->
		65;
get_add(_ServerLv,_Lv) when _ServerLv >= 431, _ServerLv =< 440, _Lv >= 421, _Lv =< 430 ->
		35;
get_add(_ServerLv,_Lv) when _ServerLv >= 441, _ServerLv =< 450, _Lv >= 121, _Lv =< 130 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 441, _ServerLv =< 450, _Lv >= 131, _Lv =< 140 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 441, _ServerLv =< 450, _Lv >= 141, _Lv =< 150 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 441, _ServerLv =< 450, _Lv >= 151, _Lv =< 160 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 441, _ServerLv =< 450, _Lv >= 161, _Lv =< 170 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 441, _ServerLv =< 450, _Lv >= 171, _Lv =< 180 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 441, _ServerLv =< 450, _Lv >= 181, _Lv =< 190 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 441, _ServerLv =< 450, _Lv >= 191, _Lv =< 200 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 441, _ServerLv =< 450, _Lv >= 201, _Lv =< 210 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 441, _ServerLv =< 450, _Lv >= 211, _Lv =< 220 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 441, _ServerLv =< 450, _Lv >= 221, _Lv =< 230 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 441, _ServerLv =< 450, _Lv >= 231, _Lv =< 240 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 441, _ServerLv =< 450, _Lv >= 241, _Lv =< 250 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 441, _ServerLv =< 450, _Lv >= 251, _Lv =< 260 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 441, _ServerLv =< 450, _Lv >= 261, _Lv =< 270 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 441, _ServerLv =< 450, _Lv >= 271, _Lv =< 280 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 441, _ServerLv =< 450, _Lv >= 281, _Lv =< 290 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 441, _ServerLv =< 450, _Lv >= 291, _Lv =< 300 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 441, _ServerLv =< 450, _Lv >= 301, _Lv =< 310 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 441, _ServerLv =< 450, _Lv >= 311, _Lv =< 320 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 441, _ServerLv =< 450, _Lv >= 321, _Lv =< 330 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 441, _ServerLv =< 450, _Lv >= 331, _Lv =< 340 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 441, _ServerLv =< 450, _Lv >= 341, _Lv =< 350 ->
		440;
get_add(_ServerLv,_Lv) when _ServerLv >= 441, _ServerLv =< 450, _Lv >= 351, _Lv =< 360 ->
		385;
get_add(_ServerLv,_Lv) when _ServerLv >= 441, _ServerLv =< 450, _Lv >= 361, _Lv =< 370 ->
		330;
get_add(_ServerLv,_Lv) when _ServerLv >= 441, _ServerLv =< 450, _Lv >= 371, _Lv =< 380 ->
		275;
get_add(_ServerLv,_Lv) when _ServerLv >= 441, _ServerLv =< 450, _Lv >= 381, _Lv =< 390 ->
		275;
get_add(_ServerLv,_Lv) when _ServerLv >= 441, _ServerLv =< 450, _Lv >= 391, _Lv =< 400 ->
		220;
get_add(_ServerLv,_Lv) when _ServerLv >= 441, _ServerLv =< 450, _Lv >= 401, _Lv =< 410 ->
		165;
get_add(_ServerLv,_Lv) when _ServerLv >= 441, _ServerLv =< 450, _Lv >= 411, _Lv =< 420 ->
		110;
get_add(_ServerLv,_Lv) when _ServerLv >= 441, _ServerLv =< 450, _Lv >= 421, _Lv =< 430 ->
		65;
get_add(_ServerLv,_Lv) when _ServerLv >= 441, _ServerLv =< 450, _Lv >= 431, _Lv =< 440 ->
		35;
get_add(_ServerLv,_Lv) when _ServerLv >= 451, _ServerLv =< 460, _Lv >= 121, _Lv =< 130 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 451, _ServerLv =< 460, _Lv >= 131, _Lv =< 140 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 451, _ServerLv =< 460, _Lv >= 141, _Lv =< 150 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 451, _ServerLv =< 460, _Lv >= 151, _Lv =< 160 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 451, _ServerLv =< 460, _Lv >= 161, _Lv =< 170 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 451, _ServerLv =< 460, _Lv >= 171, _Lv =< 180 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 451, _ServerLv =< 460, _Lv >= 181, _Lv =< 190 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 451, _ServerLv =< 460, _Lv >= 191, _Lv =< 200 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 451, _ServerLv =< 460, _Lv >= 201, _Lv =< 210 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 451, _ServerLv =< 460, _Lv >= 211, _Lv =< 220 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 451, _ServerLv =< 460, _Lv >= 221, _Lv =< 230 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 451, _ServerLv =< 460, _Lv >= 231, _Lv =< 240 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 451, _ServerLv =< 460, _Lv >= 241, _Lv =< 250 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 451, _ServerLv =< 460, _Lv >= 251, _Lv =< 260 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 451, _ServerLv =< 460, _Lv >= 261, _Lv =< 270 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 451, _ServerLv =< 460, _Lv >= 271, _Lv =< 280 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 451, _ServerLv =< 460, _Lv >= 281, _Lv =< 290 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 451, _ServerLv =< 460, _Lv >= 291, _Lv =< 300 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 451, _ServerLv =< 460, _Lv >= 301, _Lv =< 310 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 451, _ServerLv =< 460, _Lv >= 311, _Lv =< 320 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 451, _ServerLv =< 460, _Lv >= 321, _Lv =< 330 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 451, _ServerLv =< 460, _Lv >= 331, _Lv =< 340 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 451, _ServerLv =< 460, _Lv >= 341, _Lv =< 350 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 451, _ServerLv =< 460, _Lv >= 351, _Lv =< 360 ->
		440;
get_add(_ServerLv,_Lv) when _ServerLv >= 451, _ServerLv =< 460, _Lv >= 361, _Lv =< 370 ->
		385;
get_add(_ServerLv,_Lv) when _ServerLv >= 451, _ServerLv =< 460, _Lv >= 371, _Lv =< 380 ->
		330;
get_add(_ServerLv,_Lv) when _ServerLv >= 451, _ServerLv =< 460, _Lv >= 381, _Lv =< 390 ->
		275;
get_add(_ServerLv,_Lv) when _ServerLv >= 451, _ServerLv =< 460, _Lv >= 391, _Lv =< 400 ->
		275;
get_add(_ServerLv,_Lv) when _ServerLv >= 451, _ServerLv =< 460, _Lv >= 401, _Lv =< 410 ->
		220;
get_add(_ServerLv,_Lv) when _ServerLv >= 451, _ServerLv =< 460, _Lv >= 411, _Lv =< 420 ->
		165;
get_add(_ServerLv,_Lv) when _ServerLv >= 451, _ServerLv =< 460, _Lv >= 421, _Lv =< 430 ->
		110;
get_add(_ServerLv,_Lv) when _ServerLv >= 451, _ServerLv =< 460, _Lv >= 431, _Lv =< 440 ->
		65;
get_add(_ServerLv,_Lv) when _ServerLv >= 451, _ServerLv =< 460, _Lv >= 441, _Lv =< 450 ->
		35;
get_add(_ServerLv,_Lv) when _ServerLv >= 461, _ServerLv =< 470, _Lv >= 121, _Lv =< 130 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 461, _ServerLv =< 470, _Lv >= 131, _Lv =< 140 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 461, _ServerLv =< 470, _Lv >= 141, _Lv =< 150 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 461, _ServerLv =< 470, _Lv >= 151, _Lv =< 160 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 461, _ServerLv =< 470, _Lv >= 161, _Lv =< 170 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 461, _ServerLv =< 470, _Lv >= 171, _Lv =< 180 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 461, _ServerLv =< 470, _Lv >= 181, _Lv =< 190 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 461, _ServerLv =< 470, _Lv >= 191, _Lv =< 200 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 461, _ServerLv =< 470, _Lv >= 201, _Lv =< 210 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 461, _ServerLv =< 470, _Lv >= 211, _Lv =< 220 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 461, _ServerLv =< 470, _Lv >= 221, _Lv =< 230 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 461, _ServerLv =< 470, _Lv >= 231, _Lv =< 240 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 461, _ServerLv =< 470, _Lv >= 241, _Lv =< 250 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 461, _ServerLv =< 470, _Lv >= 251, _Lv =< 260 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 461, _ServerLv =< 470, _Lv >= 261, _Lv =< 270 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 461, _ServerLv =< 470, _Lv >= 271, _Lv =< 280 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 461, _ServerLv =< 470, _Lv >= 281, _Lv =< 290 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 461, _ServerLv =< 470, _Lv >= 291, _Lv =< 300 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 461, _ServerLv =< 470, _Lv >= 301, _Lv =< 310 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 461, _ServerLv =< 470, _Lv >= 311, _Lv =< 320 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 461, _ServerLv =< 470, _Lv >= 321, _Lv =< 330 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 461, _ServerLv =< 470, _Lv >= 331, _Lv =< 340 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 461, _ServerLv =< 470, _Lv >= 341, _Lv =< 350 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 461, _ServerLv =< 470, _Lv >= 351, _Lv =< 360 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 461, _ServerLv =< 470, _Lv >= 361, _Lv =< 370 ->
		440;
get_add(_ServerLv,_Lv) when _ServerLv >= 461, _ServerLv =< 470, _Lv >= 371, _Lv =< 380 ->
		385;
get_add(_ServerLv,_Lv) when _ServerLv >= 461, _ServerLv =< 470, _Lv >= 381, _Lv =< 390 ->
		330;
get_add(_ServerLv,_Lv) when _ServerLv >= 461, _ServerLv =< 470, _Lv >= 391, _Lv =< 400 ->
		275;
get_add(_ServerLv,_Lv) when _ServerLv >= 461, _ServerLv =< 470, _Lv >= 401, _Lv =< 410 ->
		275;
get_add(_ServerLv,_Lv) when _ServerLv >= 461, _ServerLv =< 470, _Lv >= 411, _Lv =< 420 ->
		220;
get_add(_ServerLv,_Lv) when _ServerLv >= 461, _ServerLv =< 470, _Lv >= 421, _Lv =< 430 ->
		165;
get_add(_ServerLv,_Lv) when _ServerLv >= 461, _ServerLv =< 470, _Lv >= 431, _Lv =< 440 ->
		110;
get_add(_ServerLv,_Lv) when _ServerLv >= 461, _ServerLv =< 470, _Lv >= 441, _Lv =< 450 ->
		65;
get_add(_ServerLv,_Lv) when _ServerLv >= 461, _ServerLv =< 470, _Lv >= 451, _Lv =< 460 ->
		35;
get_add(_ServerLv,_Lv) when _ServerLv >= 471, _ServerLv =< 480, _Lv >= 121, _Lv =< 130 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 471, _ServerLv =< 480, _Lv >= 131, _Lv =< 140 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 471, _ServerLv =< 480, _Lv >= 141, _Lv =< 150 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 471, _ServerLv =< 480, _Lv >= 151, _Lv =< 160 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 471, _ServerLv =< 480, _Lv >= 161, _Lv =< 170 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 471, _ServerLv =< 480, _Lv >= 171, _Lv =< 180 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 471, _ServerLv =< 480, _Lv >= 181, _Lv =< 190 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 471, _ServerLv =< 480, _Lv >= 191, _Lv =< 200 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 471, _ServerLv =< 480, _Lv >= 201, _Lv =< 210 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 471, _ServerLv =< 480, _Lv >= 211, _Lv =< 220 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 471, _ServerLv =< 480, _Lv >= 221, _Lv =< 230 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 471, _ServerLv =< 480, _Lv >= 231, _Lv =< 240 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 471, _ServerLv =< 480, _Lv >= 241, _Lv =< 250 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 471, _ServerLv =< 480, _Lv >= 251, _Lv =< 260 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 471, _ServerLv =< 480, _Lv >= 261, _Lv =< 270 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 471, _ServerLv =< 480, _Lv >= 271, _Lv =< 280 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 471, _ServerLv =< 480, _Lv >= 281, _Lv =< 290 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 471, _ServerLv =< 480, _Lv >= 291, _Lv =< 300 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 471, _ServerLv =< 480, _Lv >= 301, _Lv =< 310 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 471, _ServerLv =< 480, _Lv >= 311, _Lv =< 320 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 471, _ServerLv =< 480, _Lv >= 321, _Lv =< 330 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 471, _ServerLv =< 480, _Lv >= 331, _Lv =< 340 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 471, _ServerLv =< 480, _Lv >= 341, _Lv =< 350 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 471, _ServerLv =< 480, _Lv >= 351, _Lv =< 360 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 471, _ServerLv =< 480, _Lv >= 361, _Lv =< 370 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 471, _ServerLv =< 480, _Lv >= 371, _Lv =< 380 ->
		440;
get_add(_ServerLv,_Lv) when _ServerLv >= 471, _ServerLv =< 480, _Lv >= 381, _Lv =< 390 ->
		385;
get_add(_ServerLv,_Lv) when _ServerLv >= 471, _ServerLv =< 480, _Lv >= 391, _Lv =< 400 ->
		330;
get_add(_ServerLv,_Lv) when _ServerLv >= 471, _ServerLv =< 480, _Lv >= 401, _Lv =< 410 ->
		275;
get_add(_ServerLv,_Lv) when _ServerLv >= 471, _ServerLv =< 480, _Lv >= 411, _Lv =< 420 ->
		275;
get_add(_ServerLv,_Lv) when _ServerLv >= 471, _ServerLv =< 480, _Lv >= 421, _Lv =< 430 ->
		220;
get_add(_ServerLv,_Lv) when _ServerLv >= 471, _ServerLv =< 480, _Lv >= 431, _Lv =< 440 ->
		165;
get_add(_ServerLv,_Lv) when _ServerLv >= 471, _ServerLv =< 480, _Lv >= 441, _Lv =< 450 ->
		110;
get_add(_ServerLv,_Lv) when _ServerLv >= 471, _ServerLv =< 480, _Lv >= 451, _Lv =< 460 ->
		65;
get_add(_ServerLv,_Lv) when _ServerLv >= 471, _ServerLv =< 480, _Lv >= 461, _Lv =< 470 ->
		35;
get_add(_ServerLv,_Lv) when _ServerLv >= 481, _ServerLv =< 490, _Lv >= 121, _Lv =< 130 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 481, _ServerLv =< 490, _Lv >= 131, _Lv =< 140 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 481, _ServerLv =< 490, _Lv >= 141, _Lv =< 150 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 481, _ServerLv =< 490, _Lv >= 151, _Lv =< 160 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 481, _ServerLv =< 490, _Lv >= 161, _Lv =< 170 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 481, _ServerLv =< 490, _Lv >= 171, _Lv =< 180 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 481, _ServerLv =< 490, _Lv >= 181, _Lv =< 190 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 481, _ServerLv =< 490, _Lv >= 191, _Lv =< 200 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 481, _ServerLv =< 490, _Lv >= 201, _Lv =< 210 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 481, _ServerLv =< 490, _Lv >= 211, _Lv =< 220 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 481, _ServerLv =< 490, _Lv >= 221, _Lv =< 230 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 481, _ServerLv =< 490, _Lv >= 231, _Lv =< 240 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 481, _ServerLv =< 490, _Lv >= 241, _Lv =< 250 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 481, _ServerLv =< 490, _Lv >= 251, _Lv =< 260 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 481, _ServerLv =< 490, _Lv >= 261, _Lv =< 270 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 481, _ServerLv =< 490, _Lv >= 271, _Lv =< 280 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 481, _ServerLv =< 490, _Lv >= 281, _Lv =< 290 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 481, _ServerLv =< 490, _Lv >= 291, _Lv =< 300 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 481, _ServerLv =< 490, _Lv >= 301, _Lv =< 310 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 481, _ServerLv =< 490, _Lv >= 311, _Lv =< 320 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 481, _ServerLv =< 490, _Lv >= 321, _Lv =< 330 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 481, _ServerLv =< 490, _Lv >= 331, _Lv =< 340 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 481, _ServerLv =< 490, _Lv >= 341, _Lv =< 350 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 481, _ServerLv =< 490, _Lv >= 351, _Lv =< 360 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 481, _ServerLv =< 490, _Lv >= 361, _Lv =< 370 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 481, _ServerLv =< 490, _Lv >= 371, _Lv =< 380 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 481, _ServerLv =< 490, _Lv >= 381, _Lv =< 390 ->
		440;
get_add(_ServerLv,_Lv) when _ServerLv >= 481, _ServerLv =< 490, _Lv >= 391, _Lv =< 400 ->
		385;
get_add(_ServerLv,_Lv) when _ServerLv >= 481, _ServerLv =< 490, _Lv >= 401, _Lv =< 410 ->
		330;
get_add(_ServerLv,_Lv) when _ServerLv >= 481, _ServerLv =< 490, _Lv >= 411, _Lv =< 420 ->
		275;
get_add(_ServerLv,_Lv) when _ServerLv >= 481, _ServerLv =< 490, _Lv >= 421, _Lv =< 430 ->
		275;
get_add(_ServerLv,_Lv) when _ServerLv >= 481, _ServerLv =< 490, _Lv >= 431, _Lv =< 440 ->
		220;
get_add(_ServerLv,_Lv) when _ServerLv >= 481, _ServerLv =< 490, _Lv >= 441, _Lv =< 450 ->
		165;
get_add(_ServerLv,_Lv) when _ServerLv >= 481, _ServerLv =< 490, _Lv >= 451, _Lv =< 460 ->
		110;
get_add(_ServerLv,_Lv) when _ServerLv >= 481, _ServerLv =< 490, _Lv >= 461, _Lv =< 470 ->
		65;
get_add(_ServerLv,_Lv) when _ServerLv >= 481, _ServerLv =< 490, _Lv >= 471, _Lv =< 480 ->
		35;
get_add(_ServerLv,_Lv) when _ServerLv >= 491, _ServerLv =< 500, _Lv >= 121, _Lv =< 130 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 491, _ServerLv =< 500, _Lv >= 131, _Lv =< 140 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 491, _ServerLv =< 500, _Lv >= 141, _Lv =< 150 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 491, _ServerLv =< 500, _Lv >= 151, _Lv =< 160 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 491, _ServerLv =< 500, _Lv >= 161, _Lv =< 170 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 491, _ServerLv =< 500, _Lv >= 171, _Lv =< 180 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 491, _ServerLv =< 500, _Lv >= 181, _Lv =< 190 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 491, _ServerLv =< 500, _Lv >= 191, _Lv =< 200 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 491, _ServerLv =< 500, _Lv >= 201, _Lv =< 210 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 491, _ServerLv =< 500, _Lv >= 211, _Lv =< 220 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 491, _ServerLv =< 500, _Lv >= 221, _Lv =< 230 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 491, _ServerLv =< 500, _Lv >= 231, _Lv =< 240 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 491, _ServerLv =< 500, _Lv >= 241, _Lv =< 250 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 491, _ServerLv =< 500, _Lv >= 251, _Lv =< 260 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 491, _ServerLv =< 500, _Lv >= 261, _Lv =< 270 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 491, _ServerLv =< 500, _Lv >= 271, _Lv =< 280 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 491, _ServerLv =< 500, _Lv >= 281, _Lv =< 290 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 491, _ServerLv =< 500, _Lv >= 291, _Lv =< 300 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 491, _ServerLv =< 500, _Lv >= 301, _Lv =< 310 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 491, _ServerLv =< 500, _Lv >= 311, _Lv =< 320 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 491, _ServerLv =< 500, _Lv >= 321, _Lv =< 330 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 491, _ServerLv =< 500, _Lv >= 331, _Lv =< 340 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 491, _ServerLv =< 500, _Lv >= 341, _Lv =< 350 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 491, _ServerLv =< 500, _Lv >= 351, _Lv =< 360 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 491, _ServerLv =< 500, _Lv >= 361, _Lv =< 370 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 491, _ServerLv =< 500, _Lv >= 371, _Lv =< 380 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 491, _ServerLv =< 500, _Lv >= 381, _Lv =< 390 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 491, _ServerLv =< 500, _Lv >= 391, _Lv =< 400 ->
		440;
get_add(_ServerLv,_Lv) when _ServerLv >= 491, _ServerLv =< 500, _Lv >= 401, _Lv =< 410 ->
		385;
get_add(_ServerLv,_Lv) when _ServerLv >= 491, _ServerLv =< 500, _Lv >= 411, _Lv =< 420 ->
		330;
get_add(_ServerLv,_Lv) when _ServerLv >= 491, _ServerLv =< 500, _Lv >= 421, _Lv =< 430 ->
		275;
get_add(_ServerLv,_Lv) when _ServerLv >= 491, _ServerLv =< 500, _Lv >= 431, _Lv =< 440 ->
		275;
get_add(_ServerLv,_Lv) when _ServerLv >= 491, _ServerLv =< 500, _Lv >= 441, _Lv =< 450 ->
		220;
get_add(_ServerLv,_Lv) when _ServerLv >= 491, _ServerLv =< 500, _Lv >= 451, _Lv =< 460 ->
		165;
get_add(_ServerLv,_Lv) when _ServerLv >= 491, _ServerLv =< 500, _Lv >= 461, _Lv =< 470 ->
		110;
get_add(_ServerLv,_Lv) when _ServerLv >= 491, _ServerLv =< 500, _Lv >= 471, _Lv =< 480 ->
		65;
get_add(_ServerLv,_Lv) when _ServerLv >= 491, _ServerLv =< 500, _Lv >= 481, _Lv =< 490 ->
		35;
get_add(_ServerLv,_Lv) when _ServerLv >= 501, _ServerLv =< 510, _Lv >= 121, _Lv =< 130 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 501, _ServerLv =< 510, _Lv >= 131, _Lv =< 140 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 501, _ServerLv =< 510, _Lv >= 141, _Lv =< 150 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 501, _ServerLv =< 510, _Lv >= 151, _Lv =< 160 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 501, _ServerLv =< 510, _Lv >= 161, _Lv =< 170 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 501, _ServerLv =< 510, _Lv >= 171, _Lv =< 180 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 501, _ServerLv =< 510, _Lv >= 181, _Lv =< 190 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 501, _ServerLv =< 510, _Lv >= 191, _Lv =< 200 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 501, _ServerLv =< 510, _Lv >= 201, _Lv =< 210 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 501, _ServerLv =< 510, _Lv >= 211, _Lv =< 220 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 501, _ServerLv =< 510, _Lv >= 221, _Lv =< 230 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 501, _ServerLv =< 510, _Lv >= 231, _Lv =< 240 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 501, _ServerLv =< 510, _Lv >= 241, _Lv =< 250 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 501, _ServerLv =< 510, _Lv >= 251, _Lv =< 260 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 501, _ServerLv =< 510, _Lv >= 261, _Lv =< 270 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 501, _ServerLv =< 510, _Lv >= 271, _Lv =< 280 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 501, _ServerLv =< 510, _Lv >= 281, _Lv =< 290 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 501, _ServerLv =< 510, _Lv >= 291, _Lv =< 300 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 501, _ServerLv =< 510, _Lv >= 301, _Lv =< 310 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 501, _ServerLv =< 510, _Lv >= 311, _Lv =< 320 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 501, _ServerLv =< 510, _Lv >= 321, _Lv =< 330 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 501, _ServerLv =< 510, _Lv >= 331, _Lv =< 340 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 501, _ServerLv =< 510, _Lv >= 341, _Lv =< 350 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 501, _ServerLv =< 510, _Lv >= 351, _Lv =< 360 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 501, _ServerLv =< 510, _Lv >= 361, _Lv =< 370 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 501, _ServerLv =< 510, _Lv >= 371, _Lv =< 380 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 501, _ServerLv =< 510, _Lv >= 381, _Lv =< 390 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 501, _ServerLv =< 510, _Lv >= 391, _Lv =< 400 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 501, _ServerLv =< 510, _Lv >= 401, _Lv =< 410 ->
		440;
get_add(_ServerLv,_Lv) when _ServerLv >= 501, _ServerLv =< 510, _Lv >= 411, _Lv =< 420 ->
		385;
get_add(_ServerLv,_Lv) when _ServerLv >= 501, _ServerLv =< 510, _Lv >= 421, _Lv =< 430 ->
		330;
get_add(_ServerLv,_Lv) when _ServerLv >= 501, _ServerLv =< 510, _Lv >= 431, _Lv =< 440 ->
		275;
get_add(_ServerLv,_Lv) when _ServerLv >= 501, _ServerLv =< 510, _Lv >= 441, _Lv =< 450 ->
		275;
get_add(_ServerLv,_Lv) when _ServerLv >= 501, _ServerLv =< 510, _Lv >= 451, _Lv =< 460 ->
		220;
get_add(_ServerLv,_Lv) when _ServerLv >= 501, _ServerLv =< 510, _Lv >= 461, _Lv =< 470 ->
		165;
get_add(_ServerLv,_Lv) when _ServerLv >= 501, _ServerLv =< 510, _Lv >= 471, _Lv =< 480 ->
		110;
get_add(_ServerLv,_Lv) when _ServerLv >= 501, _ServerLv =< 510, _Lv >= 481, _Lv =< 490 ->
		65;
get_add(_ServerLv,_Lv) when _ServerLv >= 501, _ServerLv =< 510, _Lv >= 491, _Lv =< 500 ->
		35;
get_add(_ServerLv,_Lv) when _ServerLv >= 511, _ServerLv =< 520, _Lv >= 121, _Lv =< 130 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 511, _ServerLv =< 520, _Lv >= 131, _Lv =< 140 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 511, _ServerLv =< 520, _Lv >= 141, _Lv =< 150 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 511, _ServerLv =< 520, _Lv >= 151, _Lv =< 160 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 511, _ServerLv =< 520, _Lv >= 161, _Lv =< 170 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 511, _ServerLv =< 520, _Lv >= 171, _Lv =< 180 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 511, _ServerLv =< 520, _Lv >= 181, _Lv =< 190 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 511, _ServerLv =< 520, _Lv >= 191, _Lv =< 200 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 511, _ServerLv =< 520, _Lv >= 201, _Lv =< 210 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 511, _ServerLv =< 520, _Lv >= 211, _Lv =< 220 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 511, _ServerLv =< 520, _Lv >= 221, _Lv =< 230 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 511, _ServerLv =< 520, _Lv >= 231, _Lv =< 240 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 511, _ServerLv =< 520, _Lv >= 241, _Lv =< 250 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 511, _ServerLv =< 520, _Lv >= 251, _Lv =< 260 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 511, _ServerLv =< 520, _Lv >= 261, _Lv =< 270 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 511, _ServerLv =< 520, _Lv >= 271, _Lv =< 280 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 511, _ServerLv =< 520, _Lv >= 281, _Lv =< 290 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 511, _ServerLv =< 520, _Lv >= 291, _Lv =< 300 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 511, _ServerLv =< 520, _Lv >= 301, _Lv =< 310 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 511, _ServerLv =< 520, _Lv >= 311, _Lv =< 320 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 511, _ServerLv =< 520, _Lv >= 321, _Lv =< 330 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 511, _ServerLv =< 520, _Lv >= 331, _Lv =< 340 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 511, _ServerLv =< 520, _Lv >= 341, _Lv =< 350 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 511, _ServerLv =< 520, _Lv >= 351, _Lv =< 360 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 511, _ServerLv =< 520, _Lv >= 361, _Lv =< 370 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 511, _ServerLv =< 520, _Lv >= 371, _Lv =< 380 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 511, _ServerLv =< 520, _Lv >= 381, _Lv =< 390 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 511, _ServerLv =< 520, _Lv >= 391, _Lv =< 400 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 511, _ServerLv =< 520, _Lv >= 401, _Lv =< 410 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 511, _ServerLv =< 520, _Lv >= 411, _Lv =< 420 ->
		440;
get_add(_ServerLv,_Lv) when _ServerLv >= 511, _ServerLv =< 520, _Lv >= 421, _Lv =< 430 ->
		385;
get_add(_ServerLv,_Lv) when _ServerLv >= 511, _ServerLv =< 520, _Lv >= 431, _Lv =< 440 ->
		330;
get_add(_ServerLv,_Lv) when _ServerLv >= 511, _ServerLv =< 520, _Lv >= 441, _Lv =< 450 ->
		275;
get_add(_ServerLv,_Lv) when _ServerLv >= 511, _ServerLv =< 520, _Lv >= 451, _Lv =< 460 ->
		275;
get_add(_ServerLv,_Lv) when _ServerLv >= 511, _ServerLv =< 520, _Lv >= 461, _Lv =< 470 ->
		220;
get_add(_ServerLv,_Lv) when _ServerLv >= 511, _ServerLv =< 520, _Lv >= 471, _Lv =< 480 ->
		165;
get_add(_ServerLv,_Lv) when _ServerLv >= 511, _ServerLv =< 520, _Lv >= 481, _Lv =< 490 ->
		110;
get_add(_ServerLv,_Lv) when _ServerLv >= 511, _ServerLv =< 520, _Lv >= 491, _Lv =< 500 ->
		65;
get_add(_ServerLv,_Lv) when _ServerLv >= 511, _ServerLv =< 520, _Lv >= 501, _Lv =< 510 ->
		35;
get_add(_ServerLv,_Lv) when _ServerLv >= 521, _ServerLv =< 530, _Lv >= 121, _Lv =< 130 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 521, _ServerLv =< 530, _Lv >= 131, _Lv =< 140 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 521, _ServerLv =< 530, _Lv >= 141, _Lv =< 150 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 521, _ServerLv =< 530, _Lv >= 151, _Lv =< 160 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 521, _ServerLv =< 530, _Lv >= 161, _Lv =< 170 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 521, _ServerLv =< 530, _Lv >= 171, _Lv =< 180 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 521, _ServerLv =< 530, _Lv >= 181, _Lv =< 190 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 521, _ServerLv =< 530, _Lv >= 191, _Lv =< 200 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 521, _ServerLv =< 530, _Lv >= 201, _Lv =< 210 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 521, _ServerLv =< 530, _Lv >= 211, _Lv =< 220 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 521, _ServerLv =< 530, _Lv >= 221, _Lv =< 230 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 521, _ServerLv =< 530, _Lv >= 231, _Lv =< 240 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 521, _ServerLv =< 530, _Lv >= 241, _Lv =< 250 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 521, _ServerLv =< 530, _Lv >= 251, _Lv =< 260 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 521, _ServerLv =< 530, _Lv >= 261, _Lv =< 270 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 521, _ServerLv =< 530, _Lv >= 271, _Lv =< 280 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 521, _ServerLv =< 530, _Lv >= 281, _Lv =< 290 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 521, _ServerLv =< 530, _Lv >= 291, _Lv =< 300 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 521, _ServerLv =< 530, _Lv >= 301, _Lv =< 310 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 521, _ServerLv =< 530, _Lv >= 311, _Lv =< 320 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 521, _ServerLv =< 530, _Lv >= 321, _Lv =< 330 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 521, _ServerLv =< 530, _Lv >= 331, _Lv =< 340 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 521, _ServerLv =< 530, _Lv >= 341, _Lv =< 350 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 521, _ServerLv =< 530, _Lv >= 351, _Lv =< 360 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 521, _ServerLv =< 530, _Lv >= 361, _Lv =< 370 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 521, _ServerLv =< 530, _Lv >= 371, _Lv =< 380 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 521, _ServerLv =< 530, _Lv >= 381, _Lv =< 390 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 521, _ServerLv =< 530, _Lv >= 391, _Lv =< 400 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 521, _ServerLv =< 530, _Lv >= 401, _Lv =< 410 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 521, _ServerLv =< 530, _Lv >= 411, _Lv =< 420 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 521, _ServerLv =< 530, _Lv >= 421, _Lv =< 430 ->
		440;
get_add(_ServerLv,_Lv) when _ServerLv >= 521, _ServerLv =< 530, _Lv >= 431, _Lv =< 440 ->
		385;
get_add(_ServerLv,_Lv) when _ServerLv >= 521, _ServerLv =< 530, _Lv >= 441, _Lv =< 450 ->
		330;
get_add(_ServerLv,_Lv) when _ServerLv >= 521, _ServerLv =< 530, _Lv >= 451, _Lv =< 460 ->
		275;
get_add(_ServerLv,_Lv) when _ServerLv >= 521, _ServerLv =< 530, _Lv >= 461, _Lv =< 470 ->
		275;
get_add(_ServerLv,_Lv) when _ServerLv >= 521, _ServerLv =< 530, _Lv >= 471, _Lv =< 480 ->
		220;
get_add(_ServerLv,_Lv) when _ServerLv >= 521, _ServerLv =< 530, _Lv >= 481, _Lv =< 490 ->
		165;
get_add(_ServerLv,_Lv) when _ServerLv >= 521, _ServerLv =< 530, _Lv >= 491, _Lv =< 500 ->
		110;
get_add(_ServerLv,_Lv) when _ServerLv >= 521, _ServerLv =< 530, _Lv >= 501, _Lv =< 510 ->
		65;
get_add(_ServerLv,_Lv) when _ServerLv >= 521, _ServerLv =< 530, _Lv >= 511, _Lv =< 520 ->
		35;
get_add(_ServerLv,_Lv) when _ServerLv >= 531, _ServerLv =< 540, _Lv >= 121, _Lv =< 130 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 531, _ServerLv =< 540, _Lv >= 131, _Lv =< 140 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 531, _ServerLv =< 540, _Lv >= 141, _Lv =< 150 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 531, _ServerLv =< 540, _Lv >= 151, _Lv =< 160 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 531, _ServerLv =< 540, _Lv >= 161, _Lv =< 170 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 531, _ServerLv =< 540, _Lv >= 171, _Lv =< 180 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 531, _ServerLv =< 540, _Lv >= 181, _Lv =< 190 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 531, _ServerLv =< 540, _Lv >= 191, _Lv =< 200 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 531, _ServerLv =< 540, _Lv >= 201, _Lv =< 210 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 531, _ServerLv =< 540, _Lv >= 211, _Lv =< 220 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 531, _ServerLv =< 540, _Lv >= 221, _Lv =< 230 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 531, _ServerLv =< 540, _Lv >= 231, _Lv =< 240 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 531, _ServerLv =< 540, _Lv >= 241, _Lv =< 250 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 531, _ServerLv =< 540, _Lv >= 251, _Lv =< 260 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 531, _ServerLv =< 540, _Lv >= 261, _Lv =< 270 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 531, _ServerLv =< 540, _Lv >= 271, _Lv =< 280 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 531, _ServerLv =< 540, _Lv >= 281, _Lv =< 290 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 531, _ServerLv =< 540, _Lv >= 291, _Lv =< 300 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 531, _ServerLv =< 540, _Lv >= 301, _Lv =< 310 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 531, _ServerLv =< 540, _Lv >= 311, _Lv =< 320 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 531, _ServerLv =< 540, _Lv >= 321, _Lv =< 330 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 531, _ServerLv =< 540, _Lv >= 331, _Lv =< 340 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 531, _ServerLv =< 540, _Lv >= 341, _Lv =< 350 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 531, _ServerLv =< 540, _Lv >= 351, _Lv =< 360 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 531, _ServerLv =< 540, _Lv >= 361, _Lv =< 370 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 531, _ServerLv =< 540, _Lv >= 371, _Lv =< 380 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 531, _ServerLv =< 540, _Lv >= 381, _Lv =< 390 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 531, _ServerLv =< 540, _Lv >= 391, _Lv =< 400 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 531, _ServerLv =< 540, _Lv >= 401, _Lv =< 410 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 531, _ServerLv =< 540, _Lv >= 411, _Lv =< 420 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 531, _ServerLv =< 540, _Lv >= 421, _Lv =< 430 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 531, _ServerLv =< 540, _Lv >= 431, _Lv =< 440 ->
		440;
get_add(_ServerLv,_Lv) when _ServerLv >= 531, _ServerLv =< 540, _Lv >= 441, _Lv =< 450 ->
		385;
get_add(_ServerLv,_Lv) when _ServerLv >= 531, _ServerLv =< 540, _Lv >= 451, _Lv =< 460 ->
		330;
get_add(_ServerLv,_Lv) when _ServerLv >= 531, _ServerLv =< 540, _Lv >= 461, _Lv =< 470 ->
		275;
get_add(_ServerLv,_Lv) when _ServerLv >= 531, _ServerLv =< 540, _Lv >= 471, _Lv =< 480 ->
		275;
get_add(_ServerLv,_Lv) when _ServerLv >= 531, _ServerLv =< 540, _Lv >= 481, _Lv =< 490 ->
		220;
get_add(_ServerLv,_Lv) when _ServerLv >= 531, _ServerLv =< 540, _Lv >= 491, _Lv =< 500 ->
		165;
get_add(_ServerLv,_Lv) when _ServerLv >= 531, _ServerLv =< 540, _Lv >= 501, _Lv =< 510 ->
		110;
get_add(_ServerLv,_Lv) when _ServerLv >= 531, _ServerLv =< 540, _Lv >= 511, _Lv =< 520 ->
		65;
get_add(_ServerLv,_Lv) when _ServerLv >= 531, _ServerLv =< 540, _Lv >= 521, _Lv =< 530 ->
		35;
get_add(_ServerLv,_Lv) when _ServerLv >= 541, _ServerLv =< 550, _Lv >= 121, _Lv =< 130 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 541, _ServerLv =< 550, _Lv >= 131, _Lv =< 140 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 541, _ServerLv =< 550, _Lv >= 141, _Lv =< 150 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 541, _ServerLv =< 550, _Lv >= 151, _Lv =< 160 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 541, _ServerLv =< 550, _Lv >= 161, _Lv =< 170 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 541, _ServerLv =< 550, _Lv >= 171, _Lv =< 180 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 541, _ServerLv =< 550, _Lv >= 181, _Lv =< 190 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 541, _ServerLv =< 550, _Lv >= 191, _Lv =< 200 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 541, _ServerLv =< 550, _Lv >= 201, _Lv =< 210 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 541, _ServerLv =< 550, _Lv >= 211, _Lv =< 220 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 541, _ServerLv =< 550, _Lv >= 221, _Lv =< 230 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 541, _ServerLv =< 550, _Lv >= 231, _Lv =< 240 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 541, _ServerLv =< 550, _Lv >= 241, _Lv =< 250 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 541, _ServerLv =< 550, _Lv >= 251, _Lv =< 260 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 541, _ServerLv =< 550, _Lv >= 261, _Lv =< 270 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 541, _ServerLv =< 550, _Lv >= 271, _Lv =< 280 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 541, _ServerLv =< 550, _Lv >= 281, _Lv =< 290 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 541, _ServerLv =< 550, _Lv >= 291, _Lv =< 300 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 541, _ServerLv =< 550, _Lv >= 301, _Lv =< 310 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 541, _ServerLv =< 550, _Lv >= 311, _Lv =< 320 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 541, _ServerLv =< 550, _Lv >= 321, _Lv =< 330 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 541, _ServerLv =< 550, _Lv >= 331, _Lv =< 340 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 541, _ServerLv =< 550, _Lv >= 341, _Lv =< 350 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 541, _ServerLv =< 550, _Lv >= 351, _Lv =< 360 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 541, _ServerLv =< 550, _Lv >= 361, _Lv =< 370 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 541, _ServerLv =< 550, _Lv >= 371, _Lv =< 380 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 541, _ServerLv =< 550, _Lv >= 381, _Lv =< 390 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 541, _ServerLv =< 550, _Lv >= 391, _Lv =< 400 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 541, _ServerLv =< 550, _Lv >= 401, _Lv =< 410 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 541, _ServerLv =< 550, _Lv >= 411, _Lv =< 420 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 541, _ServerLv =< 550, _Lv >= 421, _Lv =< 430 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 541, _ServerLv =< 550, _Lv >= 431, _Lv =< 440 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 541, _ServerLv =< 550, _Lv >= 441, _Lv =< 450 ->
		440;
get_add(_ServerLv,_Lv) when _ServerLv >= 541, _ServerLv =< 550, _Lv >= 451, _Lv =< 460 ->
		385;
get_add(_ServerLv,_Lv) when _ServerLv >= 541, _ServerLv =< 550, _Lv >= 461, _Lv =< 470 ->
		330;
get_add(_ServerLv,_Lv) when _ServerLv >= 541, _ServerLv =< 550, _Lv >= 471, _Lv =< 480 ->
		275;
get_add(_ServerLv,_Lv) when _ServerLv >= 541, _ServerLv =< 550, _Lv >= 481, _Lv =< 490 ->
		275;
get_add(_ServerLv,_Lv) when _ServerLv >= 541, _ServerLv =< 550, _Lv >= 491, _Lv =< 500 ->
		220;
get_add(_ServerLv,_Lv) when _ServerLv >= 541, _ServerLv =< 550, _Lv >= 501, _Lv =< 510 ->
		165;
get_add(_ServerLv,_Lv) when _ServerLv >= 541, _ServerLv =< 550, _Lv >= 511, _Lv =< 520 ->
		110;
get_add(_ServerLv,_Lv) when _ServerLv >= 541, _ServerLv =< 550, _Lv >= 521, _Lv =< 530 ->
		65;
get_add(_ServerLv,_Lv) when _ServerLv >= 541, _ServerLv =< 550, _Lv >= 531, _Lv =< 540 ->
		35;
get_add(_ServerLv,_Lv) when _ServerLv >= 551, _ServerLv =< 560, _Lv >= 121, _Lv =< 130 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 551, _ServerLv =< 560, _Lv >= 131, _Lv =< 140 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 551, _ServerLv =< 560, _Lv >= 141, _Lv =< 150 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 551, _ServerLv =< 560, _Lv >= 151, _Lv =< 160 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 551, _ServerLv =< 560, _Lv >= 161, _Lv =< 170 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 551, _ServerLv =< 560, _Lv >= 171, _Lv =< 180 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 551, _ServerLv =< 560, _Lv >= 181, _Lv =< 190 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 551, _ServerLv =< 560, _Lv >= 191, _Lv =< 200 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 551, _ServerLv =< 560, _Lv >= 201, _Lv =< 210 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 551, _ServerLv =< 560, _Lv >= 211, _Lv =< 220 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 551, _ServerLv =< 560, _Lv >= 221, _Lv =< 230 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 551, _ServerLv =< 560, _Lv >= 231, _Lv =< 240 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 551, _ServerLv =< 560, _Lv >= 241, _Lv =< 250 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 551, _ServerLv =< 560, _Lv >= 251, _Lv =< 260 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 551, _ServerLv =< 560, _Lv >= 261, _Lv =< 270 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 551, _ServerLv =< 560, _Lv >= 271, _Lv =< 280 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 551, _ServerLv =< 560, _Lv >= 281, _Lv =< 290 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 551, _ServerLv =< 560, _Lv >= 291, _Lv =< 300 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 551, _ServerLv =< 560, _Lv >= 301, _Lv =< 310 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 551, _ServerLv =< 560, _Lv >= 311, _Lv =< 320 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 551, _ServerLv =< 560, _Lv >= 321, _Lv =< 330 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 551, _ServerLv =< 560, _Lv >= 331, _Lv =< 340 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 551, _ServerLv =< 560, _Lv >= 341, _Lv =< 350 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 551, _ServerLv =< 560, _Lv >= 351, _Lv =< 360 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 551, _ServerLv =< 560, _Lv >= 361, _Lv =< 370 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 551, _ServerLv =< 560, _Lv >= 371, _Lv =< 380 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 551, _ServerLv =< 560, _Lv >= 381, _Lv =< 390 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 551, _ServerLv =< 560, _Lv >= 391, _Lv =< 400 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 551, _ServerLv =< 560, _Lv >= 401, _Lv =< 410 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 551, _ServerLv =< 560, _Lv >= 411, _Lv =< 420 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 551, _ServerLv =< 560, _Lv >= 421, _Lv =< 430 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 551, _ServerLv =< 560, _Lv >= 431, _Lv =< 440 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 551, _ServerLv =< 560, _Lv >= 441, _Lv =< 450 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 551, _ServerLv =< 560, _Lv >= 451, _Lv =< 460 ->
		440;
get_add(_ServerLv,_Lv) when _ServerLv >= 551, _ServerLv =< 560, _Lv >= 461, _Lv =< 470 ->
		385;
get_add(_ServerLv,_Lv) when _ServerLv >= 551, _ServerLv =< 560, _Lv >= 471, _Lv =< 480 ->
		330;
get_add(_ServerLv,_Lv) when _ServerLv >= 551, _ServerLv =< 560, _Lv >= 481, _Lv =< 490 ->
		275;
get_add(_ServerLv,_Lv) when _ServerLv >= 551, _ServerLv =< 560, _Lv >= 491, _Lv =< 500 ->
		275;
get_add(_ServerLv,_Lv) when _ServerLv >= 551, _ServerLv =< 560, _Lv >= 501, _Lv =< 510 ->
		220;
get_add(_ServerLv,_Lv) when _ServerLv >= 551, _ServerLv =< 560, _Lv >= 511, _Lv =< 520 ->
		165;
get_add(_ServerLv,_Lv) when _ServerLv >= 551, _ServerLv =< 560, _Lv >= 521, _Lv =< 530 ->
		110;
get_add(_ServerLv,_Lv) when _ServerLv >= 551, _ServerLv =< 560, _Lv >= 531, _Lv =< 540 ->
		65;
get_add(_ServerLv,_Lv) when _ServerLv >= 551, _ServerLv =< 560, _Lv >= 541, _Lv =< 550 ->
		35;
get_add(_ServerLv,_Lv) when _ServerLv >= 561, _ServerLv =< 570, _Lv >= 121, _Lv =< 130 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 561, _ServerLv =< 570, _Lv >= 131, _Lv =< 140 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 561, _ServerLv =< 570, _Lv >= 141, _Lv =< 150 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 561, _ServerLv =< 570, _Lv >= 151, _Lv =< 160 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 561, _ServerLv =< 570, _Lv >= 161, _Lv =< 170 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 561, _ServerLv =< 570, _Lv >= 171, _Lv =< 180 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 561, _ServerLv =< 570, _Lv >= 181, _Lv =< 190 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 561, _ServerLv =< 570, _Lv >= 191, _Lv =< 200 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 561, _ServerLv =< 570, _Lv >= 201, _Lv =< 210 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 561, _ServerLv =< 570, _Lv >= 211, _Lv =< 220 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 561, _ServerLv =< 570, _Lv >= 221, _Lv =< 230 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 561, _ServerLv =< 570, _Lv >= 231, _Lv =< 240 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 561, _ServerLv =< 570, _Lv >= 241, _Lv =< 250 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 561, _ServerLv =< 570, _Lv >= 251, _Lv =< 260 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 561, _ServerLv =< 570, _Lv >= 261, _Lv =< 270 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 561, _ServerLv =< 570, _Lv >= 271, _Lv =< 280 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 561, _ServerLv =< 570, _Lv >= 281, _Lv =< 290 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 561, _ServerLv =< 570, _Lv >= 291, _Lv =< 300 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 561, _ServerLv =< 570, _Lv >= 301, _Lv =< 310 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 561, _ServerLv =< 570, _Lv >= 311, _Lv =< 320 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 561, _ServerLv =< 570, _Lv >= 321, _Lv =< 330 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 561, _ServerLv =< 570, _Lv >= 331, _Lv =< 340 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 561, _ServerLv =< 570, _Lv >= 341, _Lv =< 350 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 561, _ServerLv =< 570, _Lv >= 351, _Lv =< 360 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 561, _ServerLv =< 570, _Lv >= 361, _Lv =< 370 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 561, _ServerLv =< 570, _Lv >= 371, _Lv =< 380 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 561, _ServerLv =< 570, _Lv >= 381, _Lv =< 390 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 561, _ServerLv =< 570, _Lv >= 391, _Lv =< 400 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 561, _ServerLv =< 570, _Lv >= 401, _Lv =< 410 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 561, _ServerLv =< 570, _Lv >= 411, _Lv =< 420 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 561, _ServerLv =< 570, _Lv >= 421, _Lv =< 430 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 561, _ServerLv =< 570, _Lv >= 431, _Lv =< 440 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 561, _ServerLv =< 570, _Lv >= 441, _Lv =< 450 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 561, _ServerLv =< 570, _Lv >= 451, _Lv =< 460 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 561, _ServerLv =< 570, _Lv >= 461, _Lv =< 470 ->
		440;
get_add(_ServerLv,_Lv) when _ServerLv >= 561, _ServerLv =< 570, _Lv >= 471, _Lv =< 480 ->
		385;
get_add(_ServerLv,_Lv) when _ServerLv >= 561, _ServerLv =< 570, _Lv >= 481, _Lv =< 490 ->
		330;
get_add(_ServerLv,_Lv) when _ServerLv >= 561, _ServerLv =< 570, _Lv >= 491, _Lv =< 500 ->
		275;
get_add(_ServerLv,_Lv) when _ServerLv >= 561, _ServerLv =< 570, _Lv >= 501, _Lv =< 510 ->
		275;
get_add(_ServerLv,_Lv) when _ServerLv >= 561, _ServerLv =< 570, _Lv >= 511, _Lv =< 520 ->
		220;
get_add(_ServerLv,_Lv) when _ServerLv >= 561, _ServerLv =< 570, _Lv >= 521, _Lv =< 530 ->
		165;
get_add(_ServerLv,_Lv) when _ServerLv >= 561, _ServerLv =< 570, _Lv >= 531, _Lv =< 540 ->
		110;
get_add(_ServerLv,_Lv) when _ServerLv >= 561, _ServerLv =< 570, _Lv >= 541, _Lv =< 550 ->
		65;
get_add(_ServerLv,_Lv) when _ServerLv >= 561, _ServerLv =< 570, _Lv >= 551, _Lv =< 560 ->
		35;
get_add(_ServerLv,_Lv) when _ServerLv >= 571, _ServerLv =< 580, _Lv >= 121, _Lv =< 130 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 571, _ServerLv =< 580, _Lv >= 131, _Lv =< 140 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 571, _ServerLv =< 580, _Lv >= 141, _Lv =< 150 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 571, _ServerLv =< 580, _Lv >= 151, _Lv =< 160 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 571, _ServerLv =< 580, _Lv >= 161, _Lv =< 170 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 571, _ServerLv =< 580, _Lv >= 171, _Lv =< 180 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 571, _ServerLv =< 580, _Lv >= 181, _Lv =< 190 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 571, _ServerLv =< 580, _Lv >= 191, _Lv =< 200 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 571, _ServerLv =< 580, _Lv >= 201, _Lv =< 210 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 571, _ServerLv =< 580, _Lv >= 211, _Lv =< 220 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 571, _ServerLv =< 580, _Lv >= 221, _Lv =< 230 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 571, _ServerLv =< 580, _Lv >= 231, _Lv =< 240 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 571, _ServerLv =< 580, _Lv >= 241, _Lv =< 250 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 571, _ServerLv =< 580, _Lv >= 251, _Lv =< 260 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 571, _ServerLv =< 580, _Lv >= 261, _Lv =< 270 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 571, _ServerLv =< 580, _Lv >= 271, _Lv =< 280 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 571, _ServerLv =< 580, _Lv >= 281, _Lv =< 290 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 571, _ServerLv =< 580, _Lv >= 291, _Lv =< 300 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 571, _ServerLv =< 580, _Lv >= 301, _Lv =< 310 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 571, _ServerLv =< 580, _Lv >= 311, _Lv =< 320 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 571, _ServerLv =< 580, _Lv >= 321, _Lv =< 330 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 571, _ServerLv =< 580, _Lv >= 331, _Lv =< 340 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 571, _ServerLv =< 580, _Lv >= 341, _Lv =< 350 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 571, _ServerLv =< 580, _Lv >= 351, _Lv =< 360 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 571, _ServerLv =< 580, _Lv >= 361, _Lv =< 370 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 571, _ServerLv =< 580, _Lv >= 371, _Lv =< 380 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 571, _ServerLv =< 580, _Lv >= 381, _Lv =< 390 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 571, _ServerLv =< 580, _Lv >= 391, _Lv =< 400 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 571, _ServerLv =< 580, _Lv >= 401, _Lv =< 410 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 571, _ServerLv =< 580, _Lv >= 411, _Lv =< 420 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 571, _ServerLv =< 580, _Lv >= 421, _Lv =< 430 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 571, _ServerLv =< 580, _Lv >= 431, _Lv =< 440 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 571, _ServerLv =< 580, _Lv >= 441, _Lv =< 450 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 571, _ServerLv =< 580, _Lv >= 451, _Lv =< 460 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 571, _ServerLv =< 580, _Lv >= 461, _Lv =< 470 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 571, _ServerLv =< 580, _Lv >= 471, _Lv =< 480 ->
		440;
get_add(_ServerLv,_Lv) when _ServerLv >= 571, _ServerLv =< 580, _Lv >= 481, _Lv =< 490 ->
		385;
get_add(_ServerLv,_Lv) when _ServerLv >= 571, _ServerLv =< 580, _Lv >= 491, _Lv =< 500 ->
		330;
get_add(_ServerLv,_Lv) when _ServerLv >= 571, _ServerLv =< 580, _Lv >= 501, _Lv =< 510 ->
		275;
get_add(_ServerLv,_Lv) when _ServerLv >= 571, _ServerLv =< 580, _Lv >= 511, _Lv =< 520 ->
		275;
get_add(_ServerLv,_Lv) when _ServerLv >= 571, _ServerLv =< 580, _Lv >= 521, _Lv =< 530 ->
		220;
get_add(_ServerLv,_Lv) when _ServerLv >= 571, _ServerLv =< 580, _Lv >= 531, _Lv =< 540 ->
		165;
get_add(_ServerLv,_Lv) when _ServerLv >= 571, _ServerLv =< 580, _Lv >= 541, _Lv =< 550 ->
		110;
get_add(_ServerLv,_Lv) when _ServerLv >= 571, _ServerLv =< 580, _Lv >= 551, _Lv =< 560 ->
		65;
get_add(_ServerLv,_Lv) when _ServerLv >= 571, _ServerLv =< 580, _Lv >= 561, _Lv =< 570 ->
		35;
get_add(_ServerLv,_Lv) when _ServerLv >= 581, _ServerLv =< 590, _Lv >= 121, _Lv =< 130 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 581, _ServerLv =< 590, _Lv >= 131, _Lv =< 140 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 581, _ServerLv =< 590, _Lv >= 141, _Lv =< 150 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 581, _ServerLv =< 590, _Lv >= 151, _Lv =< 160 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 581, _ServerLv =< 590, _Lv >= 161, _Lv =< 170 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 581, _ServerLv =< 590, _Lv >= 171, _Lv =< 180 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 581, _ServerLv =< 590, _Lv >= 181, _Lv =< 190 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 581, _ServerLv =< 590, _Lv >= 191, _Lv =< 200 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 581, _ServerLv =< 590, _Lv >= 201, _Lv =< 210 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 581, _ServerLv =< 590, _Lv >= 211, _Lv =< 220 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 581, _ServerLv =< 590, _Lv >= 221, _Lv =< 230 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 581, _ServerLv =< 590, _Lv >= 231, _Lv =< 240 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 581, _ServerLv =< 590, _Lv >= 241, _Lv =< 250 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 581, _ServerLv =< 590, _Lv >= 251, _Lv =< 260 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 581, _ServerLv =< 590, _Lv >= 261, _Lv =< 270 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 581, _ServerLv =< 590, _Lv >= 271, _Lv =< 280 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 581, _ServerLv =< 590, _Lv >= 281, _Lv =< 290 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 581, _ServerLv =< 590, _Lv >= 291, _Lv =< 300 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 581, _ServerLv =< 590, _Lv >= 301, _Lv =< 310 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 581, _ServerLv =< 590, _Lv >= 311, _Lv =< 320 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 581, _ServerLv =< 590, _Lv >= 321, _Lv =< 330 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 581, _ServerLv =< 590, _Lv >= 331, _Lv =< 340 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 581, _ServerLv =< 590, _Lv >= 341, _Lv =< 350 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 581, _ServerLv =< 590, _Lv >= 351, _Lv =< 360 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 581, _ServerLv =< 590, _Lv >= 361, _Lv =< 370 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 581, _ServerLv =< 590, _Lv >= 371, _Lv =< 380 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 581, _ServerLv =< 590, _Lv >= 381, _Lv =< 390 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 581, _ServerLv =< 590, _Lv >= 391, _Lv =< 400 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 581, _ServerLv =< 590, _Lv >= 401, _Lv =< 410 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 581, _ServerLv =< 590, _Lv >= 411, _Lv =< 420 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 581, _ServerLv =< 590, _Lv >= 421, _Lv =< 430 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 581, _ServerLv =< 590, _Lv >= 431, _Lv =< 440 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 581, _ServerLv =< 590, _Lv >= 441, _Lv =< 450 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 581, _ServerLv =< 590, _Lv >= 451, _Lv =< 460 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 581, _ServerLv =< 590, _Lv >= 461, _Lv =< 470 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 581, _ServerLv =< 590, _Lv >= 471, _Lv =< 480 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 581, _ServerLv =< 590, _Lv >= 481, _Lv =< 490 ->
		440;
get_add(_ServerLv,_Lv) when _ServerLv >= 581, _ServerLv =< 590, _Lv >= 491, _Lv =< 500 ->
		385;
get_add(_ServerLv,_Lv) when _ServerLv >= 581, _ServerLv =< 590, _Lv >= 501, _Lv =< 510 ->
		330;
get_add(_ServerLv,_Lv) when _ServerLv >= 581, _ServerLv =< 590, _Lv >= 511, _Lv =< 520 ->
		275;
get_add(_ServerLv,_Lv) when _ServerLv >= 581, _ServerLv =< 590, _Lv >= 521, _Lv =< 530 ->
		275;
get_add(_ServerLv,_Lv) when _ServerLv >= 581, _ServerLv =< 590, _Lv >= 531, _Lv =< 540 ->
		220;
get_add(_ServerLv,_Lv) when _ServerLv >= 581, _ServerLv =< 590, _Lv >= 541, _Lv =< 550 ->
		165;
get_add(_ServerLv,_Lv) when _ServerLv >= 581, _ServerLv =< 590, _Lv >= 551, _Lv =< 560 ->
		110;
get_add(_ServerLv,_Lv) when _ServerLv >= 581, _ServerLv =< 590, _Lv >= 561, _Lv =< 570 ->
		65;
get_add(_ServerLv,_Lv) when _ServerLv >= 581, _ServerLv =< 590, _Lv >= 571, _Lv =< 580 ->
		35;
get_add(_ServerLv,_Lv) when _ServerLv >= 591, _ServerLv =< 600, _Lv >= 121, _Lv =< 130 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 591, _ServerLv =< 600, _Lv >= 131, _Lv =< 140 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 591, _ServerLv =< 600, _Lv >= 141, _Lv =< 150 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 591, _ServerLv =< 600, _Lv >= 151, _Lv =< 160 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 591, _ServerLv =< 600, _Lv >= 161, _Lv =< 170 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 591, _ServerLv =< 600, _Lv >= 171, _Lv =< 180 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 591, _ServerLv =< 600, _Lv >= 181, _Lv =< 190 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 591, _ServerLv =< 600, _Lv >= 191, _Lv =< 200 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 591, _ServerLv =< 600, _Lv >= 201, _Lv =< 210 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 591, _ServerLv =< 600, _Lv >= 211, _Lv =< 220 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 591, _ServerLv =< 600, _Lv >= 221, _Lv =< 230 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 591, _ServerLv =< 600, _Lv >= 231, _Lv =< 240 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 591, _ServerLv =< 600, _Lv >= 241, _Lv =< 250 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 591, _ServerLv =< 600, _Lv >= 251, _Lv =< 260 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 591, _ServerLv =< 600, _Lv >= 261, _Lv =< 270 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 591, _ServerLv =< 600, _Lv >= 271, _Lv =< 280 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 591, _ServerLv =< 600, _Lv >= 281, _Lv =< 290 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 591, _ServerLv =< 600, _Lv >= 291, _Lv =< 300 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 591, _ServerLv =< 600, _Lv >= 301, _Lv =< 310 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 591, _ServerLv =< 600, _Lv >= 311, _Lv =< 320 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 591, _ServerLv =< 600, _Lv >= 321, _Lv =< 330 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 591, _ServerLv =< 600, _Lv >= 331, _Lv =< 340 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 591, _ServerLv =< 600, _Lv >= 341, _Lv =< 350 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 591, _ServerLv =< 600, _Lv >= 351, _Lv =< 360 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 591, _ServerLv =< 600, _Lv >= 361, _Lv =< 370 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 591, _ServerLv =< 600, _Lv >= 371, _Lv =< 380 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 591, _ServerLv =< 600, _Lv >= 381, _Lv =< 390 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 591, _ServerLv =< 600, _Lv >= 391, _Lv =< 400 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 591, _ServerLv =< 600, _Lv >= 401, _Lv =< 410 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 591, _ServerLv =< 600, _Lv >= 411, _Lv =< 420 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 591, _ServerLv =< 600, _Lv >= 421, _Lv =< 430 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 591, _ServerLv =< 600, _Lv >= 431, _Lv =< 440 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 591, _ServerLv =< 600, _Lv >= 441, _Lv =< 450 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 591, _ServerLv =< 600, _Lv >= 451, _Lv =< 460 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 591, _ServerLv =< 600, _Lv >= 461, _Lv =< 470 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 591, _ServerLv =< 600, _Lv >= 471, _Lv =< 480 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 591, _ServerLv =< 600, _Lv >= 481, _Lv =< 490 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 591, _ServerLv =< 600, _Lv >= 491, _Lv =< 500 ->
		440;
get_add(_ServerLv,_Lv) when _ServerLv >= 591, _ServerLv =< 600, _Lv >= 501, _Lv =< 510 ->
		385;
get_add(_ServerLv,_Lv) when _ServerLv >= 591, _ServerLv =< 600, _Lv >= 511, _Lv =< 520 ->
		330;
get_add(_ServerLv,_Lv) when _ServerLv >= 591, _ServerLv =< 600, _Lv >= 521, _Lv =< 530 ->
		275;
get_add(_ServerLv,_Lv) when _ServerLv >= 591, _ServerLv =< 600, _Lv >= 531, _Lv =< 540 ->
		275;
get_add(_ServerLv,_Lv) when _ServerLv >= 591, _ServerLv =< 600, _Lv >= 541, _Lv =< 550 ->
		220;
get_add(_ServerLv,_Lv) when _ServerLv >= 591, _ServerLv =< 600, _Lv >= 551, _Lv =< 560 ->
		165;
get_add(_ServerLv,_Lv) when _ServerLv >= 591, _ServerLv =< 600, _Lv >= 561, _Lv =< 570 ->
		110;
get_add(_ServerLv,_Lv) when _ServerLv >= 591, _ServerLv =< 600, _Lv >= 571, _Lv =< 580 ->
		65;
get_add(_ServerLv,_Lv) when _ServerLv >= 591, _ServerLv =< 600, _Lv >= 581, _Lv =< 590 ->
		35;
get_add(_ServerLv,_Lv) when _ServerLv >= 601, _ServerLv =< 610, _Lv >= 121, _Lv =< 130 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 601, _ServerLv =< 610, _Lv >= 131, _Lv =< 140 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 601, _ServerLv =< 610, _Lv >= 141, _Lv =< 150 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 601, _ServerLv =< 610, _Lv >= 151, _Lv =< 160 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 601, _ServerLv =< 610, _Lv >= 161, _Lv =< 170 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 601, _ServerLv =< 610, _Lv >= 171, _Lv =< 180 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 601, _ServerLv =< 610, _Lv >= 181, _Lv =< 190 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 601, _ServerLv =< 610, _Lv >= 191, _Lv =< 200 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 601, _ServerLv =< 610, _Lv >= 201, _Lv =< 210 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 601, _ServerLv =< 610, _Lv >= 211, _Lv =< 220 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 601, _ServerLv =< 610, _Lv >= 221, _Lv =< 230 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 601, _ServerLv =< 610, _Lv >= 231, _Lv =< 240 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 601, _ServerLv =< 610, _Lv >= 241, _Lv =< 250 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 601, _ServerLv =< 610, _Lv >= 251, _Lv =< 260 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 601, _ServerLv =< 610, _Lv >= 261, _Lv =< 270 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 601, _ServerLv =< 610, _Lv >= 271, _Lv =< 280 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 601, _ServerLv =< 610, _Lv >= 281, _Lv =< 290 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 601, _ServerLv =< 610, _Lv >= 291, _Lv =< 300 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 601, _ServerLv =< 610, _Lv >= 301, _Lv =< 310 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 601, _ServerLv =< 610, _Lv >= 311, _Lv =< 320 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 601, _ServerLv =< 610, _Lv >= 321, _Lv =< 330 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 601, _ServerLv =< 610, _Lv >= 331, _Lv =< 340 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 601, _ServerLv =< 610, _Lv >= 341, _Lv =< 350 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 601, _ServerLv =< 610, _Lv >= 351, _Lv =< 360 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 601, _ServerLv =< 610, _Lv >= 361, _Lv =< 370 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 601, _ServerLv =< 610, _Lv >= 371, _Lv =< 380 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 601, _ServerLv =< 610, _Lv >= 381, _Lv =< 390 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 601, _ServerLv =< 610, _Lv >= 391, _Lv =< 400 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 601, _ServerLv =< 610, _Lv >= 401, _Lv =< 410 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 601, _ServerLv =< 610, _Lv >= 411, _Lv =< 420 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 601, _ServerLv =< 610, _Lv >= 421, _Lv =< 430 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 601, _ServerLv =< 610, _Lv >= 431, _Lv =< 440 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 601, _ServerLv =< 610, _Lv >= 441, _Lv =< 450 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 601, _ServerLv =< 610, _Lv >= 451, _Lv =< 460 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 601, _ServerLv =< 610, _Lv >= 461, _Lv =< 470 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 601, _ServerLv =< 610, _Lv >= 471, _Lv =< 480 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 601, _ServerLv =< 610, _Lv >= 481, _Lv =< 490 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 601, _ServerLv =< 610, _Lv >= 491, _Lv =< 500 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 601, _ServerLv =< 610, _Lv >= 501, _Lv =< 510 ->
		440;
get_add(_ServerLv,_Lv) when _ServerLv >= 601, _ServerLv =< 610, _Lv >= 511, _Lv =< 520 ->
		385;
get_add(_ServerLv,_Lv) when _ServerLv >= 601, _ServerLv =< 610, _Lv >= 521, _Lv =< 530 ->
		330;
get_add(_ServerLv,_Lv) when _ServerLv >= 601, _ServerLv =< 610, _Lv >= 531, _Lv =< 540 ->
		275;
get_add(_ServerLv,_Lv) when _ServerLv >= 601, _ServerLv =< 610, _Lv >= 541, _Lv =< 550 ->
		275;
get_add(_ServerLv,_Lv) when _ServerLv >= 601, _ServerLv =< 610, _Lv >= 551, _Lv =< 560 ->
		220;
get_add(_ServerLv,_Lv) when _ServerLv >= 601, _ServerLv =< 610, _Lv >= 561, _Lv =< 570 ->
		165;
get_add(_ServerLv,_Lv) when _ServerLv >= 601, _ServerLv =< 610, _Lv >= 571, _Lv =< 580 ->
		110;
get_add(_ServerLv,_Lv) when _ServerLv >= 601, _ServerLv =< 610, _Lv >= 581, _Lv =< 590 ->
		65;
get_add(_ServerLv,_Lv) when _ServerLv >= 601, _ServerLv =< 610, _Lv >= 591, _Lv =< 600 ->
		35;
get_add(_ServerLv,_Lv) when _ServerLv >= 611, _ServerLv =< 620, _Lv >= 121, _Lv =< 130 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 611, _ServerLv =< 620, _Lv >= 131, _Lv =< 140 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 611, _ServerLv =< 620, _Lv >= 141, _Lv =< 150 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 611, _ServerLv =< 620, _Lv >= 151, _Lv =< 160 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 611, _ServerLv =< 620, _Lv >= 161, _Lv =< 170 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 611, _ServerLv =< 620, _Lv >= 171, _Lv =< 180 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 611, _ServerLv =< 620, _Lv >= 181, _Lv =< 190 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 611, _ServerLv =< 620, _Lv >= 191, _Lv =< 200 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 611, _ServerLv =< 620, _Lv >= 201, _Lv =< 210 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 611, _ServerLv =< 620, _Lv >= 211, _Lv =< 220 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 611, _ServerLv =< 620, _Lv >= 221, _Lv =< 230 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 611, _ServerLv =< 620, _Lv >= 231, _Lv =< 240 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 611, _ServerLv =< 620, _Lv >= 241, _Lv =< 250 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 611, _ServerLv =< 620, _Lv >= 251, _Lv =< 260 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 611, _ServerLv =< 620, _Lv >= 261, _Lv =< 270 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 611, _ServerLv =< 620, _Lv >= 271, _Lv =< 280 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 611, _ServerLv =< 620, _Lv >= 281, _Lv =< 290 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 611, _ServerLv =< 620, _Lv >= 291, _Lv =< 300 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 611, _ServerLv =< 620, _Lv >= 301, _Lv =< 310 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 611, _ServerLv =< 620, _Lv >= 311, _Lv =< 320 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 611, _ServerLv =< 620, _Lv >= 321, _Lv =< 330 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 611, _ServerLv =< 620, _Lv >= 331, _Lv =< 340 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 611, _ServerLv =< 620, _Lv >= 341, _Lv =< 350 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 611, _ServerLv =< 620, _Lv >= 351, _Lv =< 360 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 611, _ServerLv =< 620, _Lv >= 361, _Lv =< 370 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 611, _ServerLv =< 620, _Lv >= 371, _Lv =< 380 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 611, _ServerLv =< 620, _Lv >= 381, _Lv =< 390 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 611, _ServerLv =< 620, _Lv >= 391, _Lv =< 400 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 611, _ServerLv =< 620, _Lv >= 401, _Lv =< 410 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 611, _ServerLv =< 620, _Lv >= 411, _Lv =< 420 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 611, _ServerLv =< 620, _Lv >= 421, _Lv =< 430 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 611, _ServerLv =< 620, _Lv >= 431, _Lv =< 440 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 611, _ServerLv =< 620, _Lv >= 441, _Lv =< 450 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 611, _ServerLv =< 620, _Lv >= 451, _Lv =< 460 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 611, _ServerLv =< 620, _Lv >= 461, _Lv =< 470 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 611, _ServerLv =< 620, _Lv >= 471, _Lv =< 480 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 611, _ServerLv =< 620, _Lv >= 481, _Lv =< 490 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 611, _ServerLv =< 620, _Lv >= 491, _Lv =< 500 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 611, _ServerLv =< 620, _Lv >= 501, _Lv =< 510 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 611, _ServerLv =< 620, _Lv >= 511, _Lv =< 520 ->
		440;
get_add(_ServerLv,_Lv) when _ServerLv >= 611, _ServerLv =< 620, _Lv >= 521, _Lv =< 530 ->
		385;
get_add(_ServerLv,_Lv) when _ServerLv >= 611, _ServerLv =< 620, _Lv >= 531, _Lv =< 540 ->
		330;
get_add(_ServerLv,_Lv) when _ServerLv >= 611, _ServerLv =< 620, _Lv >= 541, _Lv =< 550 ->
		275;
get_add(_ServerLv,_Lv) when _ServerLv >= 611, _ServerLv =< 620, _Lv >= 551, _Lv =< 560 ->
		275;
get_add(_ServerLv,_Lv) when _ServerLv >= 611, _ServerLv =< 620, _Lv >= 561, _Lv =< 570 ->
		220;
get_add(_ServerLv,_Lv) when _ServerLv >= 611, _ServerLv =< 620, _Lv >= 571, _Lv =< 580 ->
		165;
get_add(_ServerLv,_Lv) when _ServerLv >= 611, _ServerLv =< 620, _Lv >= 581, _Lv =< 590 ->
		110;
get_add(_ServerLv,_Lv) when _ServerLv >= 611, _ServerLv =< 620, _Lv >= 591, _Lv =< 600 ->
		65;
get_add(_ServerLv,_Lv) when _ServerLv >= 611, _ServerLv =< 620, _Lv >= 601, _Lv =< 610 ->
		35;
get_add(_ServerLv,_Lv) when _ServerLv >= 621, _ServerLv =< 630, _Lv >= 121, _Lv =< 130 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 621, _ServerLv =< 630, _Lv >= 131, _Lv =< 140 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 621, _ServerLv =< 630, _Lv >= 141, _Lv =< 150 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 621, _ServerLv =< 630, _Lv >= 151, _Lv =< 160 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 621, _ServerLv =< 630, _Lv >= 161, _Lv =< 170 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 621, _ServerLv =< 630, _Lv >= 171, _Lv =< 180 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 621, _ServerLv =< 630, _Lv >= 181, _Lv =< 190 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 621, _ServerLv =< 630, _Lv >= 191, _Lv =< 200 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 621, _ServerLv =< 630, _Lv >= 201, _Lv =< 210 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 621, _ServerLv =< 630, _Lv >= 211, _Lv =< 220 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 621, _ServerLv =< 630, _Lv >= 221, _Lv =< 230 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 621, _ServerLv =< 630, _Lv >= 231, _Lv =< 240 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 621, _ServerLv =< 630, _Lv >= 241, _Lv =< 250 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 621, _ServerLv =< 630, _Lv >= 251, _Lv =< 260 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 621, _ServerLv =< 630, _Lv >= 261, _Lv =< 270 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 621, _ServerLv =< 630, _Lv >= 271, _Lv =< 280 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 621, _ServerLv =< 630, _Lv >= 281, _Lv =< 290 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 621, _ServerLv =< 630, _Lv >= 291, _Lv =< 300 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 621, _ServerLv =< 630, _Lv >= 301, _Lv =< 310 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 621, _ServerLv =< 630, _Lv >= 311, _Lv =< 320 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 621, _ServerLv =< 630, _Lv >= 321, _Lv =< 330 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 621, _ServerLv =< 630, _Lv >= 331, _Lv =< 340 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 621, _ServerLv =< 630, _Lv >= 341, _Lv =< 350 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 621, _ServerLv =< 630, _Lv >= 351, _Lv =< 360 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 621, _ServerLv =< 630, _Lv >= 361, _Lv =< 370 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 621, _ServerLv =< 630, _Lv >= 371, _Lv =< 380 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 621, _ServerLv =< 630, _Lv >= 381, _Lv =< 390 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 621, _ServerLv =< 630, _Lv >= 391, _Lv =< 400 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 621, _ServerLv =< 630, _Lv >= 401, _Lv =< 410 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 621, _ServerLv =< 630, _Lv >= 411, _Lv =< 420 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 621, _ServerLv =< 630, _Lv >= 421, _Lv =< 430 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 621, _ServerLv =< 630, _Lv >= 431, _Lv =< 440 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 621, _ServerLv =< 630, _Lv >= 441, _Lv =< 450 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 621, _ServerLv =< 630, _Lv >= 451, _Lv =< 460 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 621, _ServerLv =< 630, _Lv >= 461, _Lv =< 470 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 621, _ServerLv =< 630, _Lv >= 471, _Lv =< 480 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 621, _ServerLv =< 630, _Lv >= 481, _Lv =< 490 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 621, _ServerLv =< 630, _Lv >= 491, _Lv =< 500 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 621, _ServerLv =< 630, _Lv >= 501, _Lv =< 510 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 621, _ServerLv =< 630, _Lv >= 511, _Lv =< 520 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 621, _ServerLv =< 630, _Lv >= 521, _Lv =< 530 ->
		440;
get_add(_ServerLv,_Lv) when _ServerLv >= 621, _ServerLv =< 630, _Lv >= 531, _Lv =< 540 ->
		385;
get_add(_ServerLv,_Lv) when _ServerLv >= 621, _ServerLv =< 630, _Lv >= 541, _Lv =< 550 ->
		330;
get_add(_ServerLv,_Lv) when _ServerLv >= 621, _ServerLv =< 630, _Lv >= 551, _Lv =< 560 ->
		275;
get_add(_ServerLv,_Lv) when _ServerLv >= 621, _ServerLv =< 630, _Lv >= 561, _Lv =< 570 ->
		275;
get_add(_ServerLv,_Lv) when _ServerLv >= 621, _ServerLv =< 630, _Lv >= 571, _Lv =< 580 ->
		220;
get_add(_ServerLv,_Lv) when _ServerLv >= 621, _ServerLv =< 630, _Lv >= 581, _Lv =< 590 ->
		165;
get_add(_ServerLv,_Lv) when _ServerLv >= 621, _ServerLv =< 630, _Lv >= 591, _Lv =< 600 ->
		110;
get_add(_ServerLv,_Lv) when _ServerLv >= 621, _ServerLv =< 630, _Lv >= 601, _Lv =< 610 ->
		65;
get_add(_ServerLv,_Lv) when _ServerLv >= 621, _ServerLv =< 630, _Lv >= 611, _Lv =< 620 ->
		35;
get_add(_ServerLv,_Lv) when _ServerLv >= 631, _ServerLv =< 640, _Lv >= 121, _Lv =< 130 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 631, _ServerLv =< 640, _Lv >= 131, _Lv =< 140 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 631, _ServerLv =< 640, _Lv >= 141, _Lv =< 150 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 631, _ServerLv =< 640, _Lv >= 151, _Lv =< 160 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 631, _ServerLv =< 640, _Lv >= 161, _Lv =< 170 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 631, _ServerLv =< 640, _Lv >= 171, _Lv =< 180 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 631, _ServerLv =< 640, _Lv >= 181, _Lv =< 190 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 631, _ServerLv =< 640, _Lv >= 191, _Lv =< 200 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 631, _ServerLv =< 640, _Lv >= 201, _Lv =< 210 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 631, _ServerLv =< 640, _Lv >= 211, _Lv =< 220 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 631, _ServerLv =< 640, _Lv >= 221, _Lv =< 230 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 631, _ServerLv =< 640, _Lv >= 231, _Lv =< 240 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 631, _ServerLv =< 640, _Lv >= 241, _Lv =< 250 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 631, _ServerLv =< 640, _Lv >= 251, _Lv =< 260 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 631, _ServerLv =< 640, _Lv >= 261, _Lv =< 270 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 631, _ServerLv =< 640, _Lv >= 271, _Lv =< 280 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 631, _ServerLv =< 640, _Lv >= 281, _Lv =< 290 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 631, _ServerLv =< 640, _Lv >= 291, _Lv =< 300 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 631, _ServerLv =< 640, _Lv >= 301, _Lv =< 310 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 631, _ServerLv =< 640, _Lv >= 311, _Lv =< 320 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 631, _ServerLv =< 640, _Lv >= 321, _Lv =< 330 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 631, _ServerLv =< 640, _Lv >= 331, _Lv =< 340 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 631, _ServerLv =< 640, _Lv >= 341, _Lv =< 350 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 631, _ServerLv =< 640, _Lv >= 351, _Lv =< 360 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 631, _ServerLv =< 640, _Lv >= 361, _Lv =< 370 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 631, _ServerLv =< 640, _Lv >= 371, _Lv =< 380 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 631, _ServerLv =< 640, _Lv >= 381, _Lv =< 390 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 631, _ServerLv =< 640, _Lv >= 391, _Lv =< 400 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 631, _ServerLv =< 640, _Lv >= 401, _Lv =< 410 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 631, _ServerLv =< 640, _Lv >= 411, _Lv =< 420 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 631, _ServerLv =< 640, _Lv >= 421, _Lv =< 430 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 631, _ServerLv =< 640, _Lv >= 431, _Lv =< 440 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 631, _ServerLv =< 640, _Lv >= 441, _Lv =< 450 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 631, _ServerLv =< 640, _Lv >= 451, _Lv =< 460 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 631, _ServerLv =< 640, _Lv >= 461, _Lv =< 470 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 631, _ServerLv =< 640, _Lv >= 471, _Lv =< 480 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 631, _ServerLv =< 640, _Lv >= 481, _Lv =< 490 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 631, _ServerLv =< 640, _Lv >= 491, _Lv =< 500 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 631, _ServerLv =< 640, _Lv >= 501, _Lv =< 510 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 631, _ServerLv =< 640, _Lv >= 511, _Lv =< 520 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 631, _ServerLv =< 640, _Lv >= 521, _Lv =< 530 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 631, _ServerLv =< 640, _Lv >= 531, _Lv =< 540 ->
		440;
get_add(_ServerLv,_Lv) when _ServerLv >= 631, _ServerLv =< 640, _Lv >= 541, _Lv =< 550 ->
		385;
get_add(_ServerLv,_Lv) when _ServerLv >= 631, _ServerLv =< 640, _Lv >= 551, _Lv =< 560 ->
		330;
get_add(_ServerLv,_Lv) when _ServerLv >= 631, _ServerLv =< 640, _Lv >= 561, _Lv =< 570 ->
		275;
get_add(_ServerLv,_Lv) when _ServerLv >= 631, _ServerLv =< 640, _Lv >= 571, _Lv =< 580 ->
		275;
get_add(_ServerLv,_Lv) when _ServerLv >= 631, _ServerLv =< 640, _Lv >= 581, _Lv =< 590 ->
		220;
get_add(_ServerLv,_Lv) when _ServerLv >= 631, _ServerLv =< 640, _Lv >= 591, _Lv =< 600 ->
		165;
get_add(_ServerLv,_Lv) when _ServerLv >= 631, _ServerLv =< 640, _Lv >= 601, _Lv =< 610 ->
		110;
get_add(_ServerLv,_Lv) when _ServerLv >= 631, _ServerLv =< 640, _Lv >= 611, _Lv =< 620 ->
		65;
get_add(_ServerLv,_Lv) when _ServerLv >= 631, _ServerLv =< 640, _Lv >= 621, _Lv =< 630 ->
		35;
get_add(_ServerLv,_Lv) when _ServerLv >= 641, _ServerLv =< 650, _Lv >= 121, _Lv =< 130 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 641, _ServerLv =< 650, _Lv >= 131, _Lv =< 140 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 641, _ServerLv =< 650, _Lv >= 141, _Lv =< 150 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 641, _ServerLv =< 650, _Lv >= 151, _Lv =< 160 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 641, _ServerLv =< 650, _Lv >= 161, _Lv =< 170 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 641, _ServerLv =< 650, _Lv >= 171, _Lv =< 180 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 641, _ServerLv =< 650, _Lv >= 181, _Lv =< 190 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 641, _ServerLv =< 650, _Lv >= 191, _Lv =< 200 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 641, _ServerLv =< 650, _Lv >= 201, _Lv =< 210 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 641, _ServerLv =< 650, _Lv >= 211, _Lv =< 220 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 641, _ServerLv =< 650, _Lv >= 221, _Lv =< 230 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 641, _ServerLv =< 650, _Lv >= 231, _Lv =< 240 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 641, _ServerLv =< 650, _Lv >= 241, _Lv =< 250 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 641, _ServerLv =< 650, _Lv >= 251, _Lv =< 260 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 641, _ServerLv =< 650, _Lv >= 261, _Lv =< 270 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 641, _ServerLv =< 650, _Lv >= 271, _Lv =< 280 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 641, _ServerLv =< 650, _Lv >= 281, _Lv =< 290 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 641, _ServerLv =< 650, _Lv >= 291, _Lv =< 300 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 641, _ServerLv =< 650, _Lv >= 301, _Lv =< 310 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 641, _ServerLv =< 650, _Lv >= 311, _Lv =< 320 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 641, _ServerLv =< 650, _Lv >= 321, _Lv =< 330 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 641, _ServerLv =< 650, _Lv >= 331, _Lv =< 340 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 641, _ServerLv =< 650, _Lv >= 341, _Lv =< 350 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 641, _ServerLv =< 650, _Lv >= 351, _Lv =< 360 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 641, _ServerLv =< 650, _Lv >= 361, _Lv =< 370 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 641, _ServerLv =< 650, _Lv >= 371, _Lv =< 380 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 641, _ServerLv =< 650, _Lv >= 381, _Lv =< 390 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 641, _ServerLv =< 650, _Lv >= 391, _Lv =< 400 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 641, _ServerLv =< 650, _Lv >= 401, _Lv =< 410 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 641, _ServerLv =< 650, _Lv >= 411, _Lv =< 420 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 641, _ServerLv =< 650, _Lv >= 421, _Lv =< 430 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 641, _ServerLv =< 650, _Lv >= 431, _Lv =< 440 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 641, _ServerLv =< 650, _Lv >= 441, _Lv =< 450 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 641, _ServerLv =< 650, _Lv >= 451, _Lv =< 460 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 641, _ServerLv =< 650, _Lv >= 461, _Lv =< 470 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 641, _ServerLv =< 650, _Lv >= 471, _Lv =< 480 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 641, _ServerLv =< 650, _Lv >= 481, _Lv =< 490 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 641, _ServerLv =< 650, _Lv >= 491, _Lv =< 500 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 641, _ServerLv =< 650, _Lv >= 501, _Lv =< 510 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 641, _ServerLv =< 650, _Lv >= 511, _Lv =< 520 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 641, _ServerLv =< 650, _Lv >= 521, _Lv =< 530 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 641, _ServerLv =< 650, _Lv >= 531, _Lv =< 540 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 641, _ServerLv =< 650, _Lv >= 541, _Lv =< 550 ->
		440;
get_add(_ServerLv,_Lv) when _ServerLv >= 641, _ServerLv =< 650, _Lv >= 551, _Lv =< 560 ->
		385;
get_add(_ServerLv,_Lv) when _ServerLv >= 641, _ServerLv =< 650, _Lv >= 561, _Lv =< 570 ->
		330;
get_add(_ServerLv,_Lv) when _ServerLv >= 641, _ServerLv =< 650, _Lv >= 571, _Lv =< 580 ->
		275;
get_add(_ServerLv,_Lv) when _ServerLv >= 641, _ServerLv =< 650, _Lv >= 581, _Lv =< 590 ->
		275;
get_add(_ServerLv,_Lv) when _ServerLv >= 641, _ServerLv =< 650, _Lv >= 591, _Lv =< 600 ->
		220;
get_add(_ServerLv,_Lv) when _ServerLv >= 641, _ServerLv =< 650, _Lv >= 601, _Lv =< 610 ->
		165;
get_add(_ServerLv,_Lv) when _ServerLv >= 641, _ServerLv =< 650, _Lv >= 611, _Lv =< 620 ->
		110;
get_add(_ServerLv,_Lv) when _ServerLv >= 641, _ServerLv =< 650, _Lv >= 621, _Lv =< 630 ->
		65;
get_add(_ServerLv,_Lv) when _ServerLv >= 641, _ServerLv =< 650, _Lv >= 631, _Lv =< 640 ->
		35;
get_add(_ServerLv,_Lv) when _ServerLv >= 651, _ServerLv =< 660, _Lv >= 121, _Lv =< 130 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 651, _ServerLv =< 660, _Lv >= 131, _Lv =< 140 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 651, _ServerLv =< 660, _Lv >= 141, _Lv =< 150 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 651, _ServerLv =< 660, _Lv >= 151, _Lv =< 160 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 651, _ServerLv =< 660, _Lv >= 161, _Lv =< 170 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 651, _ServerLv =< 660, _Lv >= 171, _Lv =< 180 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 651, _ServerLv =< 660, _Lv >= 181, _Lv =< 190 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 651, _ServerLv =< 660, _Lv >= 191, _Lv =< 200 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 651, _ServerLv =< 660, _Lv >= 201, _Lv =< 210 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 651, _ServerLv =< 660, _Lv >= 211, _Lv =< 220 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 651, _ServerLv =< 660, _Lv >= 221, _Lv =< 230 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 651, _ServerLv =< 660, _Lv >= 231, _Lv =< 240 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 651, _ServerLv =< 660, _Lv >= 241, _Lv =< 250 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 651, _ServerLv =< 660, _Lv >= 251, _Lv =< 260 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 651, _ServerLv =< 660, _Lv >= 261, _Lv =< 270 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 651, _ServerLv =< 660, _Lv >= 271, _Lv =< 280 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 651, _ServerLv =< 660, _Lv >= 281, _Lv =< 290 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 651, _ServerLv =< 660, _Lv >= 291, _Lv =< 300 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 651, _ServerLv =< 660, _Lv >= 301, _Lv =< 310 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 651, _ServerLv =< 660, _Lv >= 311, _Lv =< 320 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 651, _ServerLv =< 660, _Lv >= 321, _Lv =< 330 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 651, _ServerLv =< 660, _Lv >= 331, _Lv =< 340 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 651, _ServerLv =< 660, _Lv >= 341, _Lv =< 350 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 651, _ServerLv =< 660, _Lv >= 351, _Lv =< 360 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 651, _ServerLv =< 660, _Lv >= 361, _Lv =< 370 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 651, _ServerLv =< 660, _Lv >= 371, _Lv =< 380 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 651, _ServerLv =< 660, _Lv >= 381, _Lv =< 390 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 651, _ServerLv =< 660, _Lv >= 391, _Lv =< 400 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 651, _ServerLv =< 660, _Lv >= 401, _Lv =< 410 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 651, _ServerLv =< 660, _Lv >= 411, _Lv =< 420 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 651, _ServerLv =< 660, _Lv >= 421, _Lv =< 430 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 651, _ServerLv =< 660, _Lv >= 431, _Lv =< 440 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 651, _ServerLv =< 660, _Lv >= 441, _Lv =< 450 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 651, _ServerLv =< 660, _Lv >= 451, _Lv =< 460 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 651, _ServerLv =< 660, _Lv >= 461, _Lv =< 470 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 651, _ServerLv =< 660, _Lv >= 471, _Lv =< 480 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 651, _ServerLv =< 660, _Lv >= 481, _Lv =< 490 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 651, _ServerLv =< 660, _Lv >= 491, _Lv =< 500 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 651, _ServerLv =< 660, _Lv >= 501, _Lv =< 510 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 651, _ServerLv =< 660, _Lv >= 511, _Lv =< 520 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 651, _ServerLv =< 660, _Lv >= 521, _Lv =< 530 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 651, _ServerLv =< 660, _Lv >= 531, _Lv =< 540 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 651, _ServerLv =< 660, _Lv >= 541, _Lv =< 550 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 651, _ServerLv =< 660, _Lv >= 551, _Lv =< 560 ->
		440;
get_add(_ServerLv,_Lv) when _ServerLv >= 651, _ServerLv =< 660, _Lv >= 561, _Lv =< 570 ->
		385;
get_add(_ServerLv,_Lv) when _ServerLv >= 651, _ServerLv =< 660, _Lv >= 571, _Lv =< 580 ->
		330;
get_add(_ServerLv,_Lv) when _ServerLv >= 651, _ServerLv =< 660, _Lv >= 581, _Lv =< 590 ->
		275;
get_add(_ServerLv,_Lv) when _ServerLv >= 651, _ServerLv =< 660, _Lv >= 591, _Lv =< 600 ->
		275;
get_add(_ServerLv,_Lv) when _ServerLv >= 651, _ServerLv =< 660, _Lv >= 601, _Lv =< 610 ->
		220;
get_add(_ServerLv,_Lv) when _ServerLv >= 651, _ServerLv =< 660, _Lv >= 611, _Lv =< 620 ->
		165;
get_add(_ServerLv,_Lv) when _ServerLv >= 651, _ServerLv =< 660, _Lv >= 621, _Lv =< 630 ->
		110;
get_add(_ServerLv,_Lv) when _ServerLv >= 651, _ServerLv =< 660, _Lv >= 631, _Lv =< 640 ->
		65;
get_add(_ServerLv,_Lv) when _ServerLv >= 651, _ServerLv =< 660, _Lv >= 641, _Lv =< 650 ->
		35;
get_add(_ServerLv,_Lv) when _ServerLv >= 661, _ServerLv =< 670, _Lv >= 121, _Lv =< 130 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 661, _ServerLv =< 670, _Lv >= 131, _Lv =< 140 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 661, _ServerLv =< 670, _Lv >= 141, _Lv =< 150 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 661, _ServerLv =< 670, _Lv >= 151, _Lv =< 160 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 661, _ServerLv =< 670, _Lv >= 161, _Lv =< 170 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 661, _ServerLv =< 670, _Lv >= 171, _Lv =< 180 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 661, _ServerLv =< 670, _Lv >= 181, _Lv =< 190 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 661, _ServerLv =< 670, _Lv >= 191, _Lv =< 200 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 661, _ServerLv =< 670, _Lv >= 201, _Lv =< 210 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 661, _ServerLv =< 670, _Lv >= 211, _Lv =< 220 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 661, _ServerLv =< 670, _Lv >= 221, _Lv =< 230 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 661, _ServerLv =< 670, _Lv >= 231, _Lv =< 240 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 661, _ServerLv =< 670, _Lv >= 241, _Lv =< 250 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 661, _ServerLv =< 670, _Lv >= 251, _Lv =< 260 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 661, _ServerLv =< 670, _Lv >= 261, _Lv =< 270 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 661, _ServerLv =< 670, _Lv >= 271, _Lv =< 280 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 661, _ServerLv =< 670, _Lv >= 281, _Lv =< 290 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 661, _ServerLv =< 670, _Lv >= 291, _Lv =< 300 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 661, _ServerLv =< 670, _Lv >= 301, _Lv =< 310 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 661, _ServerLv =< 670, _Lv >= 311, _Lv =< 320 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 661, _ServerLv =< 670, _Lv >= 321, _Lv =< 330 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 661, _ServerLv =< 670, _Lv >= 331, _Lv =< 340 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 661, _ServerLv =< 670, _Lv >= 341, _Lv =< 350 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 661, _ServerLv =< 670, _Lv >= 351, _Lv =< 360 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 661, _ServerLv =< 670, _Lv >= 361, _Lv =< 370 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 661, _ServerLv =< 670, _Lv >= 371, _Lv =< 380 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 661, _ServerLv =< 670, _Lv >= 381, _Lv =< 390 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 661, _ServerLv =< 670, _Lv >= 391, _Lv =< 400 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 661, _ServerLv =< 670, _Lv >= 401, _Lv =< 410 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 661, _ServerLv =< 670, _Lv >= 411, _Lv =< 420 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 661, _ServerLv =< 670, _Lv >= 421, _Lv =< 430 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 661, _ServerLv =< 670, _Lv >= 431, _Lv =< 440 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 661, _ServerLv =< 670, _Lv >= 441, _Lv =< 450 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 661, _ServerLv =< 670, _Lv >= 451, _Lv =< 460 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 661, _ServerLv =< 670, _Lv >= 461, _Lv =< 470 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 661, _ServerLv =< 670, _Lv >= 471, _Lv =< 480 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 661, _ServerLv =< 670, _Lv >= 481, _Lv =< 490 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 661, _ServerLv =< 670, _Lv >= 491, _Lv =< 500 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 661, _ServerLv =< 670, _Lv >= 501, _Lv =< 510 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 661, _ServerLv =< 670, _Lv >= 511, _Lv =< 520 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 661, _ServerLv =< 670, _Lv >= 521, _Lv =< 530 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 661, _ServerLv =< 670, _Lv >= 531, _Lv =< 540 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 661, _ServerLv =< 670, _Lv >= 541, _Lv =< 550 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 661, _ServerLv =< 670, _Lv >= 551, _Lv =< 560 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 661, _ServerLv =< 670, _Lv >= 561, _Lv =< 570 ->
		440;
get_add(_ServerLv,_Lv) when _ServerLv >= 661, _ServerLv =< 670, _Lv >= 571, _Lv =< 580 ->
		385;
get_add(_ServerLv,_Lv) when _ServerLv >= 661, _ServerLv =< 670, _Lv >= 581, _Lv =< 590 ->
		330;
get_add(_ServerLv,_Lv) when _ServerLv >= 661, _ServerLv =< 670, _Lv >= 591, _Lv =< 600 ->
		275;
get_add(_ServerLv,_Lv) when _ServerLv >= 661, _ServerLv =< 670, _Lv >= 601, _Lv =< 610 ->
		275;
get_add(_ServerLv,_Lv) when _ServerLv >= 661, _ServerLv =< 670, _Lv >= 611, _Lv =< 620 ->
		220;
get_add(_ServerLv,_Lv) when _ServerLv >= 661, _ServerLv =< 670, _Lv >= 621, _Lv =< 630 ->
		165;
get_add(_ServerLv,_Lv) when _ServerLv >= 661, _ServerLv =< 670, _Lv >= 631, _Lv =< 640 ->
		110;
get_add(_ServerLv,_Lv) when _ServerLv >= 661, _ServerLv =< 670, _Lv >= 641, _Lv =< 650 ->
		65;
get_add(_ServerLv,_Lv) when _ServerLv >= 661, _ServerLv =< 670, _Lv >= 651, _Lv =< 660 ->
		35;
get_add(_ServerLv,_Lv) when _ServerLv >= 671, _ServerLv =< 680, _Lv >= 121, _Lv =< 130 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 671, _ServerLv =< 680, _Lv >= 131, _Lv =< 140 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 671, _ServerLv =< 680, _Lv >= 141, _Lv =< 150 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 671, _ServerLv =< 680, _Lv >= 151, _Lv =< 160 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 671, _ServerLv =< 680, _Lv >= 161, _Lv =< 170 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 671, _ServerLv =< 680, _Lv >= 171, _Lv =< 180 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 671, _ServerLv =< 680, _Lv >= 181, _Lv =< 190 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 671, _ServerLv =< 680, _Lv >= 191, _Lv =< 200 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 671, _ServerLv =< 680, _Lv >= 201, _Lv =< 210 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 671, _ServerLv =< 680, _Lv >= 211, _Lv =< 220 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 671, _ServerLv =< 680, _Lv >= 221, _Lv =< 230 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 671, _ServerLv =< 680, _Lv >= 231, _Lv =< 240 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 671, _ServerLv =< 680, _Lv >= 241, _Lv =< 250 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 671, _ServerLv =< 680, _Lv >= 251, _Lv =< 260 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 671, _ServerLv =< 680, _Lv >= 261, _Lv =< 270 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 671, _ServerLv =< 680, _Lv >= 271, _Lv =< 280 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 671, _ServerLv =< 680, _Lv >= 281, _Lv =< 290 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 671, _ServerLv =< 680, _Lv >= 291, _Lv =< 300 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 671, _ServerLv =< 680, _Lv >= 301, _Lv =< 310 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 671, _ServerLv =< 680, _Lv >= 311, _Lv =< 320 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 671, _ServerLv =< 680, _Lv >= 321, _Lv =< 330 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 671, _ServerLv =< 680, _Lv >= 331, _Lv =< 340 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 671, _ServerLv =< 680, _Lv >= 341, _Lv =< 350 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 671, _ServerLv =< 680, _Lv >= 351, _Lv =< 360 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 671, _ServerLv =< 680, _Lv >= 361, _Lv =< 370 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 671, _ServerLv =< 680, _Lv >= 371, _Lv =< 380 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 671, _ServerLv =< 680, _Lv >= 381, _Lv =< 390 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 671, _ServerLv =< 680, _Lv >= 391, _Lv =< 400 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 671, _ServerLv =< 680, _Lv >= 401, _Lv =< 410 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 671, _ServerLv =< 680, _Lv >= 411, _Lv =< 420 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 671, _ServerLv =< 680, _Lv >= 421, _Lv =< 430 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 671, _ServerLv =< 680, _Lv >= 431, _Lv =< 440 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 671, _ServerLv =< 680, _Lv >= 441, _Lv =< 450 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 671, _ServerLv =< 680, _Lv >= 451, _Lv =< 460 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 671, _ServerLv =< 680, _Lv >= 461, _Lv =< 470 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 671, _ServerLv =< 680, _Lv >= 471, _Lv =< 480 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 671, _ServerLv =< 680, _Lv >= 481, _Lv =< 490 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 671, _ServerLv =< 680, _Lv >= 491, _Lv =< 500 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 671, _ServerLv =< 680, _Lv >= 501, _Lv =< 510 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 671, _ServerLv =< 680, _Lv >= 511, _Lv =< 520 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 671, _ServerLv =< 680, _Lv >= 521, _Lv =< 530 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 671, _ServerLv =< 680, _Lv >= 531, _Lv =< 540 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 671, _ServerLv =< 680, _Lv >= 541, _Lv =< 550 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 671, _ServerLv =< 680, _Lv >= 551, _Lv =< 560 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 671, _ServerLv =< 680, _Lv >= 561, _Lv =< 570 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 671, _ServerLv =< 680, _Lv >= 571, _Lv =< 580 ->
		440;
get_add(_ServerLv,_Lv) when _ServerLv >= 671, _ServerLv =< 680, _Lv >= 581, _Lv =< 590 ->
		385;
get_add(_ServerLv,_Lv) when _ServerLv >= 671, _ServerLv =< 680, _Lv >= 591, _Lv =< 600 ->
		330;
get_add(_ServerLv,_Lv) when _ServerLv >= 671, _ServerLv =< 680, _Lv >= 601, _Lv =< 610 ->
		275;
get_add(_ServerLv,_Lv) when _ServerLv >= 671, _ServerLv =< 680, _Lv >= 611, _Lv =< 620 ->
		275;
get_add(_ServerLv,_Lv) when _ServerLv >= 671, _ServerLv =< 680, _Lv >= 621, _Lv =< 630 ->
		220;
get_add(_ServerLv,_Lv) when _ServerLv >= 671, _ServerLv =< 680, _Lv >= 631, _Lv =< 640 ->
		165;
get_add(_ServerLv,_Lv) when _ServerLv >= 671, _ServerLv =< 680, _Lv >= 641, _Lv =< 650 ->
		110;
get_add(_ServerLv,_Lv) when _ServerLv >= 671, _ServerLv =< 680, _Lv >= 651, _Lv =< 660 ->
		65;
get_add(_ServerLv,_Lv) when _ServerLv >= 671, _ServerLv =< 680, _Lv >= 661, _Lv =< 670 ->
		35;
get_add(_ServerLv,_Lv) when _ServerLv >= 681, _ServerLv =< 690, _Lv >= 121, _Lv =< 130 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 681, _ServerLv =< 690, _Lv >= 131, _Lv =< 140 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 681, _ServerLv =< 690, _Lv >= 141, _Lv =< 150 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 681, _ServerLv =< 690, _Lv >= 151, _Lv =< 160 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 681, _ServerLv =< 690, _Lv >= 161, _Lv =< 170 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 681, _ServerLv =< 690, _Lv >= 171, _Lv =< 180 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 681, _ServerLv =< 690, _Lv >= 181, _Lv =< 190 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 681, _ServerLv =< 690, _Lv >= 191, _Lv =< 200 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 681, _ServerLv =< 690, _Lv >= 201, _Lv =< 210 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 681, _ServerLv =< 690, _Lv >= 211, _Lv =< 220 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 681, _ServerLv =< 690, _Lv >= 221, _Lv =< 230 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 681, _ServerLv =< 690, _Lv >= 231, _Lv =< 240 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 681, _ServerLv =< 690, _Lv >= 241, _Lv =< 250 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 681, _ServerLv =< 690, _Lv >= 251, _Lv =< 260 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 681, _ServerLv =< 690, _Lv >= 261, _Lv =< 270 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 681, _ServerLv =< 690, _Lv >= 271, _Lv =< 280 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 681, _ServerLv =< 690, _Lv >= 281, _Lv =< 290 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 681, _ServerLv =< 690, _Lv >= 291, _Lv =< 300 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 681, _ServerLv =< 690, _Lv >= 301, _Lv =< 310 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 681, _ServerLv =< 690, _Lv >= 311, _Lv =< 320 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 681, _ServerLv =< 690, _Lv >= 321, _Lv =< 330 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 681, _ServerLv =< 690, _Lv >= 331, _Lv =< 340 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 681, _ServerLv =< 690, _Lv >= 341, _Lv =< 350 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 681, _ServerLv =< 690, _Lv >= 351, _Lv =< 360 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 681, _ServerLv =< 690, _Lv >= 361, _Lv =< 370 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 681, _ServerLv =< 690, _Lv >= 371, _Lv =< 380 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 681, _ServerLv =< 690, _Lv >= 381, _Lv =< 390 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 681, _ServerLv =< 690, _Lv >= 391, _Lv =< 400 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 681, _ServerLv =< 690, _Lv >= 401, _Lv =< 410 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 681, _ServerLv =< 690, _Lv >= 411, _Lv =< 420 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 681, _ServerLv =< 690, _Lv >= 421, _Lv =< 430 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 681, _ServerLv =< 690, _Lv >= 431, _Lv =< 440 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 681, _ServerLv =< 690, _Lv >= 441, _Lv =< 450 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 681, _ServerLv =< 690, _Lv >= 451, _Lv =< 460 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 681, _ServerLv =< 690, _Lv >= 461, _Lv =< 470 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 681, _ServerLv =< 690, _Lv >= 471, _Lv =< 480 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 681, _ServerLv =< 690, _Lv >= 481, _Lv =< 490 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 681, _ServerLv =< 690, _Lv >= 491, _Lv =< 500 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 681, _ServerLv =< 690, _Lv >= 501, _Lv =< 510 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 681, _ServerLv =< 690, _Lv >= 511, _Lv =< 520 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 681, _ServerLv =< 690, _Lv >= 521, _Lv =< 530 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 681, _ServerLv =< 690, _Lv >= 531, _Lv =< 540 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 681, _ServerLv =< 690, _Lv >= 541, _Lv =< 550 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 681, _ServerLv =< 690, _Lv >= 551, _Lv =< 560 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 681, _ServerLv =< 690, _Lv >= 561, _Lv =< 570 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 681, _ServerLv =< 690, _Lv >= 571, _Lv =< 580 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 681, _ServerLv =< 690, _Lv >= 581, _Lv =< 590 ->
		440;
get_add(_ServerLv,_Lv) when _ServerLv >= 681, _ServerLv =< 690, _Lv >= 591, _Lv =< 600 ->
		385;
get_add(_ServerLv,_Lv) when _ServerLv >= 681, _ServerLv =< 690, _Lv >= 601, _Lv =< 610 ->
		330;
get_add(_ServerLv,_Lv) when _ServerLv >= 681, _ServerLv =< 690, _Lv >= 611, _Lv =< 620 ->
		275;
get_add(_ServerLv,_Lv) when _ServerLv >= 681, _ServerLv =< 690, _Lv >= 621, _Lv =< 630 ->
		275;
get_add(_ServerLv,_Lv) when _ServerLv >= 681, _ServerLv =< 690, _Lv >= 631, _Lv =< 640 ->
		220;
get_add(_ServerLv,_Lv) when _ServerLv >= 681, _ServerLv =< 690, _Lv >= 641, _Lv =< 650 ->
		165;
get_add(_ServerLv,_Lv) when _ServerLv >= 681, _ServerLv =< 690, _Lv >= 651, _Lv =< 660 ->
		110;
get_add(_ServerLv,_Lv) when _ServerLv >= 681, _ServerLv =< 690, _Lv >= 661, _Lv =< 670 ->
		65;
get_add(_ServerLv,_Lv) when _ServerLv >= 681, _ServerLv =< 690, _Lv >= 671, _Lv =< 680 ->
		35;
get_add(_ServerLv,_Lv) when _ServerLv >= 691, _ServerLv =< 700, _Lv >= 121, _Lv =< 130 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 691, _ServerLv =< 700, _Lv >= 131, _Lv =< 140 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 691, _ServerLv =< 700, _Lv >= 141, _Lv =< 150 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 691, _ServerLv =< 700, _Lv >= 151, _Lv =< 160 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 691, _ServerLv =< 700, _Lv >= 161, _Lv =< 170 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 691, _ServerLv =< 700, _Lv >= 171, _Lv =< 180 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 691, _ServerLv =< 700, _Lv >= 181, _Lv =< 190 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 691, _ServerLv =< 700, _Lv >= 191, _Lv =< 200 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 691, _ServerLv =< 700, _Lv >= 201, _Lv =< 210 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 691, _ServerLv =< 700, _Lv >= 211, _Lv =< 220 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 691, _ServerLv =< 700, _Lv >= 221, _Lv =< 230 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 691, _ServerLv =< 700, _Lv >= 231, _Lv =< 240 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 691, _ServerLv =< 700, _Lv >= 241, _Lv =< 250 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 691, _ServerLv =< 700, _Lv >= 251, _Lv =< 260 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 691, _ServerLv =< 700, _Lv >= 261, _Lv =< 270 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 691, _ServerLv =< 700, _Lv >= 271, _Lv =< 280 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 691, _ServerLv =< 700, _Lv >= 281, _Lv =< 290 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 691, _ServerLv =< 700, _Lv >= 291, _Lv =< 300 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 691, _ServerLv =< 700, _Lv >= 301, _Lv =< 310 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 691, _ServerLv =< 700, _Lv >= 311, _Lv =< 320 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 691, _ServerLv =< 700, _Lv >= 321, _Lv =< 330 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 691, _ServerLv =< 700, _Lv >= 331, _Lv =< 340 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 691, _ServerLv =< 700, _Lv >= 341, _Lv =< 350 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 691, _ServerLv =< 700, _Lv >= 351, _Lv =< 360 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 691, _ServerLv =< 700, _Lv >= 361, _Lv =< 370 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 691, _ServerLv =< 700, _Lv >= 371, _Lv =< 380 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 691, _ServerLv =< 700, _Lv >= 381, _Lv =< 390 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 691, _ServerLv =< 700, _Lv >= 391, _Lv =< 400 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 691, _ServerLv =< 700, _Lv >= 401, _Lv =< 410 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 691, _ServerLv =< 700, _Lv >= 411, _Lv =< 420 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 691, _ServerLv =< 700, _Lv >= 421, _Lv =< 430 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 691, _ServerLv =< 700, _Lv >= 431, _Lv =< 440 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 691, _ServerLv =< 700, _Lv >= 441, _Lv =< 450 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 691, _ServerLv =< 700, _Lv >= 451, _Lv =< 460 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 691, _ServerLv =< 700, _Lv >= 461, _Lv =< 470 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 691, _ServerLv =< 700, _Lv >= 471, _Lv =< 480 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 691, _ServerLv =< 700, _Lv >= 481, _Lv =< 490 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 691, _ServerLv =< 700, _Lv >= 491, _Lv =< 500 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 691, _ServerLv =< 700, _Lv >= 501, _Lv =< 510 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 691, _ServerLv =< 700, _Lv >= 511, _Lv =< 520 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 691, _ServerLv =< 700, _Lv >= 521, _Lv =< 530 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 691, _ServerLv =< 700, _Lv >= 531, _Lv =< 540 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 691, _ServerLv =< 700, _Lv >= 541, _Lv =< 550 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 691, _ServerLv =< 700, _Lv >= 551, _Lv =< 560 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 691, _ServerLv =< 700, _Lv >= 561, _Lv =< 570 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 691, _ServerLv =< 700, _Lv >= 571, _Lv =< 580 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 691, _ServerLv =< 700, _Lv >= 581, _Lv =< 590 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 691, _ServerLv =< 700, _Lv >= 591, _Lv =< 600 ->
		440;
get_add(_ServerLv,_Lv) when _ServerLv >= 691, _ServerLv =< 700, _Lv >= 601, _Lv =< 610 ->
		385;
get_add(_ServerLv,_Lv) when _ServerLv >= 691, _ServerLv =< 700, _Lv >= 611, _Lv =< 620 ->
		330;
get_add(_ServerLv,_Lv) when _ServerLv >= 691, _ServerLv =< 700, _Lv >= 621, _Lv =< 630 ->
		275;
get_add(_ServerLv,_Lv) when _ServerLv >= 691, _ServerLv =< 700, _Lv >= 631, _Lv =< 640 ->
		275;
get_add(_ServerLv,_Lv) when _ServerLv >= 691, _ServerLv =< 700, _Lv >= 641, _Lv =< 650 ->
		220;
get_add(_ServerLv,_Lv) when _ServerLv >= 691, _ServerLv =< 700, _Lv >= 651, _Lv =< 660 ->
		165;
get_add(_ServerLv,_Lv) when _ServerLv >= 691, _ServerLv =< 700, _Lv >= 661, _Lv =< 670 ->
		110;
get_add(_ServerLv,_Lv) when _ServerLv >= 691, _ServerLv =< 700, _Lv >= 671, _Lv =< 680 ->
		65;
get_add(_ServerLv,_Lv) when _ServerLv >= 691, _ServerLv =< 700, _Lv >= 681, _Lv =< 690 ->
		35;
get_add(_ServerLv,_Lv) when _ServerLv >= 701, _ServerLv =< 720, _Lv >= 121, _Lv =< 130 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 701, _ServerLv =< 720, _Lv >= 131, _Lv =< 140 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 701, _ServerLv =< 720, _Lv >= 141, _Lv =< 150 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 701, _ServerLv =< 720, _Lv >= 151, _Lv =< 160 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 701, _ServerLv =< 720, _Lv >= 161, _Lv =< 170 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 701, _ServerLv =< 720, _Lv >= 171, _Lv =< 180 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 701, _ServerLv =< 720, _Lv >= 181, _Lv =< 190 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 701, _ServerLv =< 720, _Lv >= 191, _Lv =< 200 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 701, _ServerLv =< 720, _Lv >= 201, _Lv =< 210 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 701, _ServerLv =< 720, _Lv >= 211, _Lv =< 220 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 701, _ServerLv =< 720, _Lv >= 221, _Lv =< 230 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 701, _ServerLv =< 720, _Lv >= 231, _Lv =< 240 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 701, _ServerLv =< 720, _Lv >= 241, _Lv =< 250 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 701, _ServerLv =< 720, _Lv >= 251, _Lv =< 260 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 701, _ServerLv =< 720, _Lv >= 261, _Lv =< 270 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 701, _ServerLv =< 720, _Lv >= 271, _Lv =< 280 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 701, _ServerLv =< 720, _Lv >= 281, _Lv =< 290 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 701, _ServerLv =< 720, _Lv >= 291, _Lv =< 300 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 701, _ServerLv =< 720, _Lv >= 301, _Lv =< 310 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 701, _ServerLv =< 720, _Lv >= 311, _Lv =< 320 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 701, _ServerLv =< 720, _Lv >= 321, _Lv =< 330 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 701, _ServerLv =< 720, _Lv >= 331, _Lv =< 340 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 701, _ServerLv =< 720, _Lv >= 341, _Lv =< 350 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 701, _ServerLv =< 720, _Lv >= 351, _Lv =< 360 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 701, _ServerLv =< 720, _Lv >= 361, _Lv =< 370 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 701, _ServerLv =< 720, _Lv >= 371, _Lv =< 380 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 701, _ServerLv =< 720, _Lv >= 381, _Lv =< 390 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 701, _ServerLv =< 720, _Lv >= 391, _Lv =< 400 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 701, _ServerLv =< 720, _Lv >= 401, _Lv =< 410 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 701, _ServerLv =< 720, _Lv >= 411, _Lv =< 420 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 701, _ServerLv =< 720, _Lv >= 421, _Lv =< 430 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 701, _ServerLv =< 720, _Lv >= 431, _Lv =< 440 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 701, _ServerLv =< 720, _Lv >= 441, _Lv =< 450 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 701, _ServerLv =< 720, _Lv >= 451, _Lv =< 460 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 701, _ServerLv =< 720, _Lv >= 461, _Lv =< 470 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 701, _ServerLv =< 720, _Lv >= 471, _Lv =< 480 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 701, _ServerLv =< 720, _Lv >= 481, _Lv =< 490 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 701, _ServerLv =< 720, _Lv >= 491, _Lv =< 500 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 701, _ServerLv =< 720, _Lv >= 501, _Lv =< 510 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 701, _ServerLv =< 720, _Lv >= 511, _Lv =< 520 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 701, _ServerLv =< 720, _Lv >= 521, _Lv =< 530 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 701, _ServerLv =< 720, _Lv >= 531, _Lv =< 540 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 701, _ServerLv =< 720, _Lv >= 541, _Lv =< 550 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 701, _ServerLv =< 720, _Lv >= 551, _Lv =< 560 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 701, _ServerLv =< 720, _Lv >= 561, _Lv =< 570 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 701, _ServerLv =< 720, _Lv >= 571, _Lv =< 580 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 701, _ServerLv =< 720, _Lv >= 581, _Lv =< 590 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 701, _ServerLv =< 720, _Lv >= 591, _Lv =< 600 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 701, _ServerLv =< 720, _Lv >= 601, _Lv =< 610 ->
		440;
get_add(_ServerLv,_Lv) when _ServerLv >= 701, _ServerLv =< 720, _Lv >= 611, _Lv =< 620 ->
		385;
get_add(_ServerLv,_Lv) when _ServerLv >= 701, _ServerLv =< 720, _Lv >= 621, _Lv =< 630 ->
		330;
get_add(_ServerLv,_Lv) when _ServerLv >= 701, _ServerLv =< 720, _Lv >= 631, _Lv =< 640 ->
		275;
get_add(_ServerLv,_Lv) when _ServerLv >= 701, _ServerLv =< 720, _Lv >= 641, _Lv =< 650 ->
		275;
get_add(_ServerLv,_Lv) when _ServerLv >= 701, _ServerLv =< 720, _Lv >= 651, _Lv =< 660 ->
		220;
get_add(_ServerLv,_Lv) when _ServerLv >= 701, _ServerLv =< 720, _Lv >= 661, _Lv =< 670 ->
		165;
get_add(_ServerLv,_Lv) when _ServerLv >= 701, _ServerLv =< 720, _Lv >= 671, _Lv =< 680 ->
		110;
get_add(_ServerLv,_Lv) when _ServerLv >= 701, _ServerLv =< 720, _Lv >= 681, _Lv =< 690 ->
		65;
get_add(_ServerLv,_Lv) when _ServerLv >= 701, _ServerLv =< 720, _Lv >= 691, _Lv =< 700 ->
		35;
get_add(_ServerLv,_Lv) when _ServerLv >= 721, _ServerLv =< 740, _Lv >= 121, _Lv =< 130 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 721, _ServerLv =< 740, _Lv >= 131, _Lv =< 140 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 721, _ServerLv =< 740, _Lv >= 141, _Lv =< 150 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 721, _ServerLv =< 740, _Lv >= 151, _Lv =< 160 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 721, _ServerLv =< 740, _Lv >= 161, _Lv =< 170 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 721, _ServerLv =< 740, _Lv >= 171, _Lv =< 180 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 721, _ServerLv =< 740, _Lv >= 181, _Lv =< 190 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 721, _ServerLv =< 740, _Lv >= 191, _Lv =< 200 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 721, _ServerLv =< 740, _Lv >= 201, _Lv =< 210 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 721, _ServerLv =< 740, _Lv >= 211, _Lv =< 220 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 721, _ServerLv =< 740, _Lv >= 221, _Lv =< 230 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 721, _ServerLv =< 740, _Lv >= 231, _Lv =< 240 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 721, _ServerLv =< 740, _Lv >= 241, _Lv =< 250 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 721, _ServerLv =< 740, _Lv >= 251, _Lv =< 260 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 721, _ServerLv =< 740, _Lv >= 261, _Lv =< 270 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 721, _ServerLv =< 740, _Lv >= 271, _Lv =< 280 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 721, _ServerLv =< 740, _Lv >= 281, _Lv =< 290 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 721, _ServerLv =< 740, _Lv >= 291, _Lv =< 300 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 721, _ServerLv =< 740, _Lv >= 301, _Lv =< 310 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 721, _ServerLv =< 740, _Lv >= 311, _Lv =< 320 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 721, _ServerLv =< 740, _Lv >= 321, _Lv =< 330 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 721, _ServerLv =< 740, _Lv >= 331, _Lv =< 340 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 721, _ServerLv =< 740, _Lv >= 341, _Lv =< 350 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 721, _ServerLv =< 740, _Lv >= 351, _Lv =< 360 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 721, _ServerLv =< 740, _Lv >= 361, _Lv =< 370 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 721, _ServerLv =< 740, _Lv >= 371, _Lv =< 380 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 721, _ServerLv =< 740, _Lv >= 381, _Lv =< 390 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 721, _ServerLv =< 740, _Lv >= 391, _Lv =< 400 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 721, _ServerLv =< 740, _Lv >= 401, _Lv =< 410 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 721, _ServerLv =< 740, _Lv >= 411, _Lv =< 420 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 721, _ServerLv =< 740, _Lv >= 421, _Lv =< 430 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 721, _ServerLv =< 740, _Lv >= 431, _Lv =< 440 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 721, _ServerLv =< 740, _Lv >= 441, _Lv =< 450 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 721, _ServerLv =< 740, _Lv >= 451, _Lv =< 460 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 721, _ServerLv =< 740, _Lv >= 461, _Lv =< 470 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 721, _ServerLv =< 740, _Lv >= 471, _Lv =< 480 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 721, _ServerLv =< 740, _Lv >= 481, _Lv =< 490 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 721, _ServerLv =< 740, _Lv >= 491, _Lv =< 500 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 721, _ServerLv =< 740, _Lv >= 501, _Lv =< 510 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 721, _ServerLv =< 740, _Lv >= 511, _Lv =< 520 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 721, _ServerLv =< 740, _Lv >= 521, _Lv =< 530 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 721, _ServerLv =< 740, _Lv >= 531, _Lv =< 540 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 721, _ServerLv =< 740, _Lv >= 541, _Lv =< 550 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 721, _ServerLv =< 740, _Lv >= 551, _Lv =< 560 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 721, _ServerLv =< 740, _Lv >= 561, _Lv =< 570 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 721, _ServerLv =< 740, _Lv >= 571, _Lv =< 580 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 721, _ServerLv =< 740, _Lv >= 581, _Lv =< 590 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 721, _ServerLv =< 740, _Lv >= 591, _Lv =< 600 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 721, _ServerLv =< 740, _Lv >= 601, _Lv =< 610 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 721, _ServerLv =< 740, _Lv >= 611, _Lv =< 620 ->
		440;
get_add(_ServerLv,_Lv) when _ServerLv >= 721, _ServerLv =< 740, _Lv >= 621, _Lv =< 630 ->
		385;
get_add(_ServerLv,_Lv) when _ServerLv >= 721, _ServerLv =< 740, _Lv >= 631, _Lv =< 640 ->
		330;
get_add(_ServerLv,_Lv) when _ServerLv >= 721, _ServerLv =< 740, _Lv >= 641, _Lv =< 650 ->
		275;
get_add(_ServerLv,_Lv) when _ServerLv >= 721, _ServerLv =< 740, _Lv >= 651, _Lv =< 660 ->
		275;
get_add(_ServerLv,_Lv) when _ServerLv >= 721, _ServerLv =< 740, _Lv >= 661, _Lv =< 670 ->
		220;
get_add(_ServerLv,_Lv) when _ServerLv >= 721, _ServerLv =< 740, _Lv >= 671, _Lv =< 680 ->
		165;
get_add(_ServerLv,_Lv) when _ServerLv >= 721, _ServerLv =< 740, _Lv >= 681, _Lv =< 690 ->
		110;
get_add(_ServerLv,_Lv) when _ServerLv >= 721, _ServerLv =< 740, _Lv >= 691, _Lv =< 700 ->
		65;
get_add(_ServerLv,_Lv) when _ServerLv >= 721, _ServerLv =< 740, _Lv >= 701, _Lv =< 720 ->
		35;
get_add(_ServerLv,_Lv) when _ServerLv >= 741, _ServerLv =< 760, _Lv >= 121, _Lv =< 130 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 741, _ServerLv =< 760, _Lv >= 131, _Lv =< 140 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 741, _ServerLv =< 760, _Lv >= 141, _Lv =< 150 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 741, _ServerLv =< 760, _Lv >= 151, _Lv =< 160 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 741, _ServerLv =< 760, _Lv >= 161, _Lv =< 170 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 741, _ServerLv =< 760, _Lv >= 171, _Lv =< 180 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 741, _ServerLv =< 760, _Lv >= 181, _Lv =< 190 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 741, _ServerLv =< 760, _Lv >= 191, _Lv =< 200 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 741, _ServerLv =< 760, _Lv >= 201, _Lv =< 210 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 741, _ServerLv =< 760, _Lv >= 211, _Lv =< 220 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 741, _ServerLv =< 760, _Lv >= 221, _Lv =< 230 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 741, _ServerLv =< 760, _Lv >= 231, _Lv =< 240 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 741, _ServerLv =< 760, _Lv >= 241, _Lv =< 250 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 741, _ServerLv =< 760, _Lv >= 251, _Lv =< 260 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 741, _ServerLv =< 760, _Lv >= 261, _Lv =< 270 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 741, _ServerLv =< 760, _Lv >= 271, _Lv =< 280 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 741, _ServerLv =< 760, _Lv >= 281, _Lv =< 290 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 741, _ServerLv =< 760, _Lv >= 291, _Lv =< 300 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 741, _ServerLv =< 760, _Lv >= 301, _Lv =< 310 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 741, _ServerLv =< 760, _Lv >= 311, _Lv =< 320 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 741, _ServerLv =< 760, _Lv >= 321, _Lv =< 330 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 741, _ServerLv =< 760, _Lv >= 331, _Lv =< 340 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 741, _ServerLv =< 760, _Lv >= 341, _Lv =< 350 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 741, _ServerLv =< 760, _Lv >= 351, _Lv =< 360 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 741, _ServerLv =< 760, _Lv >= 361, _Lv =< 370 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 741, _ServerLv =< 760, _Lv >= 371, _Lv =< 380 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 741, _ServerLv =< 760, _Lv >= 381, _Lv =< 390 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 741, _ServerLv =< 760, _Lv >= 391, _Lv =< 400 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 741, _ServerLv =< 760, _Lv >= 401, _Lv =< 410 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 741, _ServerLv =< 760, _Lv >= 411, _Lv =< 420 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 741, _ServerLv =< 760, _Lv >= 421, _Lv =< 430 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 741, _ServerLv =< 760, _Lv >= 431, _Lv =< 440 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 741, _ServerLv =< 760, _Lv >= 441, _Lv =< 450 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 741, _ServerLv =< 760, _Lv >= 451, _Lv =< 460 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 741, _ServerLv =< 760, _Lv >= 461, _Lv =< 470 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 741, _ServerLv =< 760, _Lv >= 471, _Lv =< 480 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 741, _ServerLv =< 760, _Lv >= 481, _Lv =< 490 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 741, _ServerLv =< 760, _Lv >= 491, _Lv =< 500 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 741, _ServerLv =< 760, _Lv >= 501, _Lv =< 510 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 741, _ServerLv =< 760, _Lv >= 511, _Lv =< 520 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 741, _ServerLv =< 760, _Lv >= 521, _Lv =< 530 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 741, _ServerLv =< 760, _Lv >= 531, _Lv =< 540 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 741, _ServerLv =< 760, _Lv >= 541, _Lv =< 550 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 741, _ServerLv =< 760, _Lv >= 551, _Lv =< 560 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 741, _ServerLv =< 760, _Lv >= 561, _Lv =< 570 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 741, _ServerLv =< 760, _Lv >= 571, _Lv =< 580 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 741, _ServerLv =< 760, _Lv >= 581, _Lv =< 590 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 741, _ServerLv =< 760, _Lv >= 591, _Lv =< 600 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 741, _ServerLv =< 760, _Lv >= 601, _Lv =< 610 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 741, _ServerLv =< 760, _Lv >= 611, _Lv =< 620 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 741, _ServerLv =< 760, _Lv >= 621, _Lv =< 630 ->
		440;
get_add(_ServerLv,_Lv) when _ServerLv >= 741, _ServerLv =< 760, _Lv >= 631, _Lv =< 640 ->
		385;
get_add(_ServerLv,_Lv) when _ServerLv >= 741, _ServerLv =< 760, _Lv >= 641, _Lv =< 650 ->
		330;
get_add(_ServerLv,_Lv) when _ServerLv >= 741, _ServerLv =< 760, _Lv >= 651, _Lv =< 660 ->
		275;
get_add(_ServerLv,_Lv) when _ServerLv >= 741, _ServerLv =< 760, _Lv >= 661, _Lv =< 670 ->
		275;
get_add(_ServerLv,_Lv) when _ServerLv >= 741, _ServerLv =< 760, _Lv >= 671, _Lv =< 680 ->
		220;
get_add(_ServerLv,_Lv) when _ServerLv >= 741, _ServerLv =< 760, _Lv >= 681, _Lv =< 690 ->
		165;
get_add(_ServerLv,_Lv) when _ServerLv >= 741, _ServerLv =< 760, _Lv >= 691, _Lv =< 700 ->
		110;
get_add(_ServerLv,_Lv) when _ServerLv >= 741, _ServerLv =< 760, _Lv >= 701, _Lv =< 720 ->
		65;
get_add(_ServerLv,_Lv) when _ServerLv >= 741, _ServerLv =< 760, _Lv >= 721, _Lv =< 740 ->
		35;
get_add(_ServerLv,_Lv) when _ServerLv >= 761, _ServerLv =< 780, _Lv >= 121, _Lv =< 130 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 761, _ServerLv =< 780, _Lv >= 131, _Lv =< 140 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 761, _ServerLv =< 780, _Lv >= 141, _Lv =< 150 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 761, _ServerLv =< 780, _Lv >= 151, _Lv =< 160 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 761, _ServerLv =< 780, _Lv >= 161, _Lv =< 170 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 761, _ServerLv =< 780, _Lv >= 171, _Lv =< 180 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 761, _ServerLv =< 780, _Lv >= 181, _Lv =< 190 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 761, _ServerLv =< 780, _Lv >= 191, _Lv =< 200 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 761, _ServerLv =< 780, _Lv >= 201, _Lv =< 210 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 761, _ServerLv =< 780, _Lv >= 211, _Lv =< 220 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 761, _ServerLv =< 780, _Lv >= 221, _Lv =< 230 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 761, _ServerLv =< 780, _Lv >= 231, _Lv =< 240 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 761, _ServerLv =< 780, _Lv >= 241, _Lv =< 250 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 761, _ServerLv =< 780, _Lv >= 251, _Lv =< 260 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 761, _ServerLv =< 780, _Lv >= 261, _Lv =< 270 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 761, _ServerLv =< 780, _Lv >= 271, _Lv =< 280 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 761, _ServerLv =< 780, _Lv >= 281, _Lv =< 290 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 761, _ServerLv =< 780, _Lv >= 291, _Lv =< 300 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 761, _ServerLv =< 780, _Lv >= 301, _Lv =< 310 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 761, _ServerLv =< 780, _Lv >= 311, _Lv =< 320 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 761, _ServerLv =< 780, _Lv >= 321, _Lv =< 330 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 761, _ServerLv =< 780, _Lv >= 331, _Lv =< 340 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 761, _ServerLv =< 780, _Lv >= 341, _Lv =< 350 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 761, _ServerLv =< 780, _Lv >= 351, _Lv =< 360 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 761, _ServerLv =< 780, _Lv >= 361, _Lv =< 370 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 761, _ServerLv =< 780, _Lv >= 371, _Lv =< 380 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 761, _ServerLv =< 780, _Lv >= 381, _Lv =< 390 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 761, _ServerLv =< 780, _Lv >= 391, _Lv =< 400 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 761, _ServerLv =< 780, _Lv >= 401, _Lv =< 410 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 761, _ServerLv =< 780, _Lv >= 411, _Lv =< 420 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 761, _ServerLv =< 780, _Lv >= 421, _Lv =< 430 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 761, _ServerLv =< 780, _Lv >= 431, _Lv =< 440 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 761, _ServerLv =< 780, _Lv >= 441, _Lv =< 450 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 761, _ServerLv =< 780, _Lv >= 451, _Lv =< 460 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 761, _ServerLv =< 780, _Lv >= 461, _Lv =< 470 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 761, _ServerLv =< 780, _Lv >= 471, _Lv =< 480 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 761, _ServerLv =< 780, _Lv >= 481, _Lv =< 490 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 761, _ServerLv =< 780, _Lv >= 491, _Lv =< 500 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 761, _ServerLv =< 780, _Lv >= 501, _Lv =< 510 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 761, _ServerLv =< 780, _Lv >= 511, _Lv =< 520 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 761, _ServerLv =< 780, _Lv >= 521, _Lv =< 530 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 761, _ServerLv =< 780, _Lv >= 531, _Lv =< 540 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 761, _ServerLv =< 780, _Lv >= 541, _Lv =< 550 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 761, _ServerLv =< 780, _Lv >= 551, _Lv =< 560 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 761, _ServerLv =< 780, _Lv >= 561, _Lv =< 570 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 761, _ServerLv =< 780, _Lv >= 571, _Lv =< 580 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 761, _ServerLv =< 780, _Lv >= 581, _Lv =< 590 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 761, _ServerLv =< 780, _Lv >= 591, _Lv =< 600 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 761, _ServerLv =< 780, _Lv >= 601, _Lv =< 610 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 761, _ServerLv =< 780, _Lv >= 611, _Lv =< 620 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 761, _ServerLv =< 780, _Lv >= 621, _Lv =< 630 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 761, _ServerLv =< 780, _Lv >= 631, _Lv =< 640 ->
		440;
get_add(_ServerLv,_Lv) when _ServerLv >= 761, _ServerLv =< 780, _Lv >= 641, _Lv =< 650 ->
		385;
get_add(_ServerLv,_Lv) when _ServerLv >= 761, _ServerLv =< 780, _Lv >= 651, _Lv =< 660 ->
		330;
get_add(_ServerLv,_Lv) when _ServerLv >= 761, _ServerLv =< 780, _Lv >= 661, _Lv =< 670 ->
		275;
get_add(_ServerLv,_Lv) when _ServerLv >= 761, _ServerLv =< 780, _Lv >= 671, _Lv =< 680 ->
		275;
get_add(_ServerLv,_Lv) when _ServerLv >= 761, _ServerLv =< 780, _Lv >= 681, _Lv =< 690 ->
		220;
get_add(_ServerLv,_Lv) when _ServerLv >= 761, _ServerLv =< 780, _Lv >= 691, _Lv =< 700 ->
		165;
get_add(_ServerLv,_Lv) when _ServerLv >= 761, _ServerLv =< 780, _Lv >= 701, _Lv =< 720 ->
		110;
get_add(_ServerLv,_Lv) when _ServerLv >= 761, _ServerLv =< 780, _Lv >= 721, _Lv =< 740 ->
		65;
get_add(_ServerLv,_Lv) when _ServerLv >= 761, _ServerLv =< 780, _Lv >= 741, _Lv =< 760 ->
		35;
get_add(_ServerLv,_Lv) when _ServerLv >= 781, _ServerLv =< 800, _Lv >= 121, _Lv =< 130 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 781, _ServerLv =< 800, _Lv >= 131, _Lv =< 140 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 781, _ServerLv =< 800, _Lv >= 141, _Lv =< 150 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 781, _ServerLv =< 800, _Lv >= 151, _Lv =< 160 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 781, _ServerLv =< 800, _Lv >= 161, _Lv =< 170 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 781, _ServerLv =< 800, _Lv >= 171, _Lv =< 180 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 781, _ServerLv =< 800, _Lv >= 181, _Lv =< 190 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 781, _ServerLv =< 800, _Lv >= 191, _Lv =< 200 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 781, _ServerLv =< 800, _Lv >= 201, _Lv =< 210 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 781, _ServerLv =< 800, _Lv >= 211, _Lv =< 220 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 781, _ServerLv =< 800, _Lv >= 221, _Lv =< 230 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 781, _ServerLv =< 800, _Lv >= 231, _Lv =< 240 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 781, _ServerLv =< 800, _Lv >= 241, _Lv =< 250 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 781, _ServerLv =< 800, _Lv >= 251, _Lv =< 260 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 781, _ServerLv =< 800, _Lv >= 261, _Lv =< 270 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 781, _ServerLv =< 800, _Lv >= 271, _Lv =< 280 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 781, _ServerLv =< 800, _Lv >= 281, _Lv =< 290 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 781, _ServerLv =< 800, _Lv >= 291, _Lv =< 300 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 781, _ServerLv =< 800, _Lv >= 301, _Lv =< 310 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 781, _ServerLv =< 800, _Lv >= 311, _Lv =< 320 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 781, _ServerLv =< 800, _Lv >= 321, _Lv =< 330 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 781, _ServerLv =< 800, _Lv >= 331, _Lv =< 340 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 781, _ServerLv =< 800, _Lv >= 341, _Lv =< 350 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 781, _ServerLv =< 800, _Lv >= 351, _Lv =< 360 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 781, _ServerLv =< 800, _Lv >= 361, _Lv =< 370 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 781, _ServerLv =< 800, _Lv >= 371, _Lv =< 380 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 781, _ServerLv =< 800, _Lv >= 381, _Lv =< 390 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 781, _ServerLv =< 800, _Lv >= 391, _Lv =< 400 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 781, _ServerLv =< 800, _Lv >= 401, _Lv =< 410 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 781, _ServerLv =< 800, _Lv >= 411, _Lv =< 420 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 781, _ServerLv =< 800, _Lv >= 421, _Lv =< 430 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 781, _ServerLv =< 800, _Lv >= 431, _Lv =< 440 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 781, _ServerLv =< 800, _Lv >= 441, _Lv =< 450 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 781, _ServerLv =< 800, _Lv >= 451, _Lv =< 460 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 781, _ServerLv =< 800, _Lv >= 461, _Lv =< 470 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 781, _ServerLv =< 800, _Lv >= 471, _Lv =< 480 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 781, _ServerLv =< 800, _Lv >= 481, _Lv =< 490 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 781, _ServerLv =< 800, _Lv >= 491, _Lv =< 500 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 781, _ServerLv =< 800, _Lv >= 501, _Lv =< 510 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 781, _ServerLv =< 800, _Lv >= 511, _Lv =< 520 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 781, _ServerLv =< 800, _Lv >= 521, _Lv =< 530 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 781, _ServerLv =< 800, _Lv >= 531, _Lv =< 540 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 781, _ServerLv =< 800, _Lv >= 541, _Lv =< 550 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 781, _ServerLv =< 800, _Lv >= 551, _Lv =< 560 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 781, _ServerLv =< 800, _Lv >= 561, _Lv =< 570 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 781, _ServerLv =< 800, _Lv >= 571, _Lv =< 580 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 781, _ServerLv =< 800, _Lv >= 581, _Lv =< 590 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 781, _ServerLv =< 800, _Lv >= 591, _Lv =< 600 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 781, _ServerLv =< 800, _Lv >= 601, _Lv =< 610 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 781, _ServerLv =< 800, _Lv >= 611, _Lv =< 620 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 781, _ServerLv =< 800, _Lv >= 621, _Lv =< 630 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 781, _ServerLv =< 800, _Lv >= 631, _Lv =< 640 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 781, _ServerLv =< 800, _Lv >= 641, _Lv =< 650 ->
		440;
get_add(_ServerLv,_Lv) when _ServerLv >= 781, _ServerLv =< 800, _Lv >= 651, _Lv =< 660 ->
		385;
get_add(_ServerLv,_Lv) when _ServerLv >= 781, _ServerLv =< 800, _Lv >= 661, _Lv =< 670 ->
		330;
get_add(_ServerLv,_Lv) when _ServerLv >= 781, _ServerLv =< 800, _Lv >= 671, _Lv =< 680 ->
		275;
get_add(_ServerLv,_Lv) when _ServerLv >= 781, _ServerLv =< 800, _Lv >= 681, _Lv =< 690 ->
		275;
get_add(_ServerLv,_Lv) when _ServerLv >= 781, _ServerLv =< 800, _Lv >= 691, _Lv =< 700 ->
		220;
get_add(_ServerLv,_Lv) when _ServerLv >= 781, _ServerLv =< 800, _Lv >= 701, _Lv =< 720 ->
		165;
get_add(_ServerLv,_Lv) when _ServerLv >= 781, _ServerLv =< 800, _Lv >= 721, _Lv =< 740 ->
		110;
get_add(_ServerLv,_Lv) when _ServerLv >= 781, _ServerLv =< 800, _Lv >= 741, _Lv =< 760 ->
		65;
get_add(_ServerLv,_Lv) when _ServerLv >= 781, _ServerLv =< 800, _Lv >= 761, _Lv =< 780 ->
		35;
get_add(_ServerLv,_Lv) when _ServerLv >= 801, _ServerLv =< 820, _Lv >= 121, _Lv =< 130 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 801, _ServerLv =< 820, _Lv >= 131, _Lv =< 140 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 801, _ServerLv =< 820, _Lv >= 141, _Lv =< 150 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 801, _ServerLv =< 820, _Lv >= 151, _Lv =< 160 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 801, _ServerLv =< 820, _Lv >= 161, _Lv =< 170 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 801, _ServerLv =< 820, _Lv >= 171, _Lv =< 180 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 801, _ServerLv =< 820, _Lv >= 181, _Lv =< 190 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 801, _ServerLv =< 820, _Lv >= 191, _Lv =< 200 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 801, _ServerLv =< 820, _Lv >= 201, _Lv =< 210 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 801, _ServerLv =< 820, _Lv >= 211, _Lv =< 220 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 801, _ServerLv =< 820, _Lv >= 221, _Lv =< 230 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 801, _ServerLv =< 820, _Lv >= 231, _Lv =< 240 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 801, _ServerLv =< 820, _Lv >= 241, _Lv =< 250 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 801, _ServerLv =< 820, _Lv >= 251, _Lv =< 260 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 801, _ServerLv =< 820, _Lv >= 261, _Lv =< 270 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 801, _ServerLv =< 820, _Lv >= 271, _Lv =< 280 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 801, _ServerLv =< 820, _Lv >= 281, _Lv =< 290 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 801, _ServerLv =< 820, _Lv >= 291, _Lv =< 300 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 801, _ServerLv =< 820, _Lv >= 301, _Lv =< 310 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 801, _ServerLv =< 820, _Lv >= 311, _Lv =< 320 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 801, _ServerLv =< 820, _Lv >= 321, _Lv =< 330 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 801, _ServerLv =< 820, _Lv >= 331, _Lv =< 340 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 801, _ServerLv =< 820, _Lv >= 341, _Lv =< 350 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 801, _ServerLv =< 820, _Lv >= 351, _Lv =< 360 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 801, _ServerLv =< 820, _Lv >= 361, _Lv =< 370 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 801, _ServerLv =< 820, _Lv >= 371, _Lv =< 380 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 801, _ServerLv =< 820, _Lv >= 381, _Lv =< 390 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 801, _ServerLv =< 820, _Lv >= 391, _Lv =< 400 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 801, _ServerLv =< 820, _Lv >= 401, _Lv =< 410 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 801, _ServerLv =< 820, _Lv >= 411, _Lv =< 420 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 801, _ServerLv =< 820, _Lv >= 421, _Lv =< 430 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 801, _ServerLv =< 820, _Lv >= 431, _Lv =< 440 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 801, _ServerLv =< 820, _Lv >= 441, _Lv =< 450 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 801, _ServerLv =< 820, _Lv >= 451, _Lv =< 460 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 801, _ServerLv =< 820, _Lv >= 461, _Lv =< 470 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 801, _ServerLv =< 820, _Lv >= 471, _Lv =< 480 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 801, _ServerLv =< 820, _Lv >= 481, _Lv =< 490 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 801, _ServerLv =< 820, _Lv >= 491, _Lv =< 500 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 801, _ServerLv =< 820, _Lv >= 501, _Lv =< 510 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 801, _ServerLv =< 820, _Lv >= 511, _Lv =< 520 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 801, _ServerLv =< 820, _Lv >= 521, _Lv =< 530 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 801, _ServerLv =< 820, _Lv >= 531, _Lv =< 540 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 801, _ServerLv =< 820, _Lv >= 541, _Lv =< 550 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 801, _ServerLv =< 820, _Lv >= 551, _Lv =< 560 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 801, _ServerLv =< 820, _Lv >= 561, _Lv =< 570 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 801, _ServerLv =< 820, _Lv >= 571, _Lv =< 580 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 801, _ServerLv =< 820, _Lv >= 581, _Lv =< 590 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 801, _ServerLv =< 820, _Lv >= 591, _Lv =< 600 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 801, _ServerLv =< 820, _Lv >= 601, _Lv =< 610 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 801, _ServerLv =< 820, _Lv >= 611, _Lv =< 620 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 801, _ServerLv =< 820, _Lv >= 621, _Lv =< 630 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 801, _ServerLv =< 820, _Lv >= 631, _Lv =< 640 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 801, _ServerLv =< 820, _Lv >= 641, _Lv =< 650 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 801, _ServerLv =< 820, _Lv >= 651, _Lv =< 660 ->
		440;
get_add(_ServerLv,_Lv) when _ServerLv >= 801, _ServerLv =< 820, _Lv >= 661, _Lv =< 670 ->
		385;
get_add(_ServerLv,_Lv) when _ServerLv >= 801, _ServerLv =< 820, _Lv >= 671, _Lv =< 680 ->
		330;
get_add(_ServerLv,_Lv) when _ServerLv >= 801, _ServerLv =< 820, _Lv >= 681, _Lv =< 690 ->
		275;
get_add(_ServerLv,_Lv) when _ServerLv >= 801, _ServerLv =< 820, _Lv >= 691, _Lv =< 700 ->
		275;
get_add(_ServerLv,_Lv) when _ServerLv >= 801, _ServerLv =< 820, _Lv >= 701, _Lv =< 720 ->
		220;
get_add(_ServerLv,_Lv) when _ServerLv >= 801, _ServerLv =< 820, _Lv >= 721, _Lv =< 740 ->
		165;
get_add(_ServerLv,_Lv) when _ServerLv >= 801, _ServerLv =< 820, _Lv >= 741, _Lv =< 760 ->
		110;
get_add(_ServerLv,_Lv) when _ServerLv >= 801, _ServerLv =< 820, _Lv >= 761, _Lv =< 780 ->
		65;
get_add(_ServerLv,_Lv) when _ServerLv >= 801, _ServerLv =< 820, _Lv >= 781, _Lv =< 800 ->
		35;
get_add(_ServerLv,_Lv) when _ServerLv >= 821, _ServerLv =< 840, _Lv >= 121, _Lv =< 130 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 821, _ServerLv =< 840, _Lv >= 131, _Lv =< 140 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 821, _ServerLv =< 840, _Lv >= 141, _Lv =< 150 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 821, _ServerLv =< 840, _Lv >= 151, _Lv =< 160 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 821, _ServerLv =< 840, _Lv >= 161, _Lv =< 170 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 821, _ServerLv =< 840, _Lv >= 171, _Lv =< 180 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 821, _ServerLv =< 840, _Lv >= 181, _Lv =< 190 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 821, _ServerLv =< 840, _Lv >= 191, _Lv =< 200 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 821, _ServerLv =< 840, _Lv >= 201, _Lv =< 210 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 821, _ServerLv =< 840, _Lv >= 211, _Lv =< 220 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 821, _ServerLv =< 840, _Lv >= 221, _Lv =< 230 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 821, _ServerLv =< 840, _Lv >= 231, _Lv =< 240 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 821, _ServerLv =< 840, _Lv >= 241, _Lv =< 250 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 821, _ServerLv =< 840, _Lv >= 251, _Lv =< 260 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 821, _ServerLv =< 840, _Lv >= 261, _Lv =< 270 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 821, _ServerLv =< 840, _Lv >= 271, _Lv =< 280 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 821, _ServerLv =< 840, _Lv >= 281, _Lv =< 290 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 821, _ServerLv =< 840, _Lv >= 291, _Lv =< 300 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 821, _ServerLv =< 840, _Lv >= 301, _Lv =< 310 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 821, _ServerLv =< 840, _Lv >= 311, _Lv =< 320 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 821, _ServerLv =< 840, _Lv >= 321, _Lv =< 330 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 821, _ServerLv =< 840, _Lv >= 331, _Lv =< 340 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 821, _ServerLv =< 840, _Lv >= 341, _Lv =< 350 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 821, _ServerLv =< 840, _Lv >= 351, _Lv =< 360 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 821, _ServerLv =< 840, _Lv >= 361, _Lv =< 370 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 821, _ServerLv =< 840, _Lv >= 371, _Lv =< 380 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 821, _ServerLv =< 840, _Lv >= 381, _Lv =< 390 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 821, _ServerLv =< 840, _Lv >= 391, _Lv =< 400 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 821, _ServerLv =< 840, _Lv >= 401, _Lv =< 410 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 821, _ServerLv =< 840, _Lv >= 411, _Lv =< 420 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 821, _ServerLv =< 840, _Lv >= 421, _Lv =< 430 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 821, _ServerLv =< 840, _Lv >= 431, _Lv =< 440 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 821, _ServerLv =< 840, _Lv >= 441, _Lv =< 450 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 821, _ServerLv =< 840, _Lv >= 451, _Lv =< 460 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 821, _ServerLv =< 840, _Lv >= 461, _Lv =< 470 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 821, _ServerLv =< 840, _Lv >= 471, _Lv =< 480 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 821, _ServerLv =< 840, _Lv >= 481, _Lv =< 490 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 821, _ServerLv =< 840, _Lv >= 491, _Lv =< 500 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 821, _ServerLv =< 840, _Lv >= 501, _Lv =< 510 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 821, _ServerLv =< 840, _Lv >= 511, _Lv =< 520 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 821, _ServerLv =< 840, _Lv >= 521, _Lv =< 530 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 821, _ServerLv =< 840, _Lv >= 531, _Lv =< 540 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 821, _ServerLv =< 840, _Lv >= 541, _Lv =< 550 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 821, _ServerLv =< 840, _Lv >= 551, _Lv =< 560 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 821, _ServerLv =< 840, _Lv >= 561, _Lv =< 570 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 821, _ServerLv =< 840, _Lv >= 571, _Lv =< 580 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 821, _ServerLv =< 840, _Lv >= 581, _Lv =< 590 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 821, _ServerLv =< 840, _Lv >= 591, _Lv =< 600 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 821, _ServerLv =< 840, _Lv >= 601, _Lv =< 610 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 821, _ServerLv =< 840, _Lv >= 611, _Lv =< 620 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 821, _ServerLv =< 840, _Lv >= 621, _Lv =< 630 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 821, _ServerLv =< 840, _Lv >= 631, _Lv =< 640 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 821, _ServerLv =< 840, _Lv >= 641, _Lv =< 650 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 821, _ServerLv =< 840, _Lv >= 651, _Lv =< 660 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 821, _ServerLv =< 840, _Lv >= 661, _Lv =< 670 ->
		440;
get_add(_ServerLv,_Lv) when _ServerLv >= 821, _ServerLv =< 840, _Lv >= 671, _Lv =< 680 ->
		385;
get_add(_ServerLv,_Lv) when _ServerLv >= 821, _ServerLv =< 840, _Lv >= 681, _Lv =< 690 ->
		330;
get_add(_ServerLv,_Lv) when _ServerLv >= 821, _ServerLv =< 840, _Lv >= 691, _Lv =< 700 ->
		275;
get_add(_ServerLv,_Lv) when _ServerLv >= 821, _ServerLv =< 840, _Lv >= 701, _Lv =< 720 ->
		275;
get_add(_ServerLv,_Lv) when _ServerLv >= 821, _ServerLv =< 840, _Lv >= 721, _Lv =< 740 ->
		220;
get_add(_ServerLv,_Lv) when _ServerLv >= 821, _ServerLv =< 840, _Lv >= 741, _Lv =< 760 ->
		165;
get_add(_ServerLv,_Lv) when _ServerLv >= 821, _ServerLv =< 840, _Lv >= 761, _Lv =< 780 ->
		110;
get_add(_ServerLv,_Lv) when _ServerLv >= 821, _ServerLv =< 840, _Lv >= 781, _Lv =< 800 ->
		65;
get_add(_ServerLv,_Lv) when _ServerLv >= 821, _ServerLv =< 840, _Lv >= 801, _Lv =< 820 ->
		35;
get_add(_ServerLv,_Lv) when _ServerLv >= 841, _ServerLv =< 860, _Lv >= 121, _Lv =< 130 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 841, _ServerLv =< 860, _Lv >= 131, _Lv =< 140 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 841, _ServerLv =< 860, _Lv >= 141, _Lv =< 150 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 841, _ServerLv =< 860, _Lv >= 151, _Lv =< 160 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 841, _ServerLv =< 860, _Lv >= 161, _Lv =< 170 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 841, _ServerLv =< 860, _Lv >= 171, _Lv =< 180 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 841, _ServerLv =< 860, _Lv >= 181, _Lv =< 190 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 841, _ServerLv =< 860, _Lv >= 191, _Lv =< 200 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 841, _ServerLv =< 860, _Lv >= 201, _Lv =< 210 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 841, _ServerLv =< 860, _Lv >= 211, _Lv =< 220 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 841, _ServerLv =< 860, _Lv >= 221, _Lv =< 230 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 841, _ServerLv =< 860, _Lv >= 231, _Lv =< 240 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 841, _ServerLv =< 860, _Lv >= 241, _Lv =< 250 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 841, _ServerLv =< 860, _Lv >= 251, _Lv =< 260 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 841, _ServerLv =< 860, _Lv >= 261, _Lv =< 270 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 841, _ServerLv =< 860, _Lv >= 271, _Lv =< 280 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 841, _ServerLv =< 860, _Lv >= 281, _Lv =< 290 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 841, _ServerLv =< 860, _Lv >= 291, _Lv =< 300 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 841, _ServerLv =< 860, _Lv >= 301, _Lv =< 310 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 841, _ServerLv =< 860, _Lv >= 311, _Lv =< 320 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 841, _ServerLv =< 860, _Lv >= 321, _Lv =< 330 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 841, _ServerLv =< 860, _Lv >= 331, _Lv =< 340 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 841, _ServerLv =< 860, _Lv >= 341, _Lv =< 350 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 841, _ServerLv =< 860, _Lv >= 351, _Lv =< 360 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 841, _ServerLv =< 860, _Lv >= 361, _Lv =< 370 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 841, _ServerLv =< 860, _Lv >= 371, _Lv =< 380 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 841, _ServerLv =< 860, _Lv >= 381, _Lv =< 390 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 841, _ServerLv =< 860, _Lv >= 391, _Lv =< 400 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 841, _ServerLv =< 860, _Lv >= 401, _Lv =< 410 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 841, _ServerLv =< 860, _Lv >= 411, _Lv =< 420 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 841, _ServerLv =< 860, _Lv >= 421, _Lv =< 430 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 841, _ServerLv =< 860, _Lv >= 431, _Lv =< 440 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 841, _ServerLv =< 860, _Lv >= 441, _Lv =< 450 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 841, _ServerLv =< 860, _Lv >= 451, _Lv =< 460 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 841, _ServerLv =< 860, _Lv >= 461, _Lv =< 470 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 841, _ServerLv =< 860, _Lv >= 471, _Lv =< 480 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 841, _ServerLv =< 860, _Lv >= 481, _Lv =< 490 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 841, _ServerLv =< 860, _Lv >= 491, _Lv =< 500 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 841, _ServerLv =< 860, _Lv >= 501, _Lv =< 510 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 841, _ServerLv =< 860, _Lv >= 511, _Lv =< 520 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 841, _ServerLv =< 860, _Lv >= 521, _Lv =< 530 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 841, _ServerLv =< 860, _Lv >= 531, _Lv =< 540 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 841, _ServerLv =< 860, _Lv >= 541, _Lv =< 550 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 841, _ServerLv =< 860, _Lv >= 551, _Lv =< 560 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 841, _ServerLv =< 860, _Lv >= 561, _Lv =< 570 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 841, _ServerLv =< 860, _Lv >= 571, _Lv =< 580 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 841, _ServerLv =< 860, _Lv >= 581, _Lv =< 590 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 841, _ServerLv =< 860, _Lv >= 591, _Lv =< 600 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 841, _ServerLv =< 860, _Lv >= 601, _Lv =< 610 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 841, _ServerLv =< 860, _Lv >= 611, _Lv =< 620 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 841, _ServerLv =< 860, _Lv >= 621, _Lv =< 630 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 841, _ServerLv =< 860, _Lv >= 631, _Lv =< 640 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 841, _ServerLv =< 860, _Lv >= 641, _Lv =< 650 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 841, _ServerLv =< 860, _Lv >= 651, _Lv =< 660 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 841, _ServerLv =< 860, _Lv >= 661, _Lv =< 670 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 841, _ServerLv =< 860, _Lv >= 671, _Lv =< 680 ->
		440;
get_add(_ServerLv,_Lv) when _ServerLv >= 841, _ServerLv =< 860, _Lv >= 681, _Lv =< 690 ->
		385;
get_add(_ServerLv,_Lv) when _ServerLv >= 841, _ServerLv =< 860, _Lv >= 691, _Lv =< 700 ->
		330;
get_add(_ServerLv,_Lv) when _ServerLv >= 841, _ServerLv =< 860, _Lv >= 701, _Lv =< 720 ->
		275;
get_add(_ServerLv,_Lv) when _ServerLv >= 841, _ServerLv =< 860, _Lv >= 721, _Lv =< 740 ->
		275;
get_add(_ServerLv,_Lv) when _ServerLv >= 841, _ServerLv =< 860, _Lv >= 741, _Lv =< 760 ->
		220;
get_add(_ServerLv,_Lv) when _ServerLv >= 841, _ServerLv =< 860, _Lv >= 761, _Lv =< 780 ->
		165;
get_add(_ServerLv,_Lv) when _ServerLv >= 841, _ServerLv =< 860, _Lv >= 781, _Lv =< 800 ->
		110;
get_add(_ServerLv,_Lv) when _ServerLv >= 841, _ServerLv =< 860, _Lv >= 801, _Lv =< 820 ->
		65;
get_add(_ServerLv,_Lv) when _ServerLv >= 841, _ServerLv =< 860, _Lv >= 821, _Lv =< 840 ->
		35;
get_add(_ServerLv,_Lv) when _ServerLv >= 861, _ServerLv =< 880, _Lv >= 121, _Lv =< 130 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 861, _ServerLv =< 880, _Lv >= 131, _Lv =< 140 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 861, _ServerLv =< 880, _Lv >= 141, _Lv =< 150 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 861, _ServerLv =< 880, _Lv >= 151, _Lv =< 160 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 861, _ServerLv =< 880, _Lv >= 161, _Lv =< 170 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 861, _ServerLv =< 880, _Lv >= 171, _Lv =< 180 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 861, _ServerLv =< 880, _Lv >= 181, _Lv =< 190 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 861, _ServerLv =< 880, _Lv >= 191, _Lv =< 200 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 861, _ServerLv =< 880, _Lv >= 201, _Lv =< 210 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 861, _ServerLv =< 880, _Lv >= 211, _Lv =< 220 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 861, _ServerLv =< 880, _Lv >= 221, _Lv =< 230 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 861, _ServerLv =< 880, _Lv >= 231, _Lv =< 240 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 861, _ServerLv =< 880, _Lv >= 241, _Lv =< 250 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 861, _ServerLv =< 880, _Lv >= 251, _Lv =< 260 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 861, _ServerLv =< 880, _Lv >= 261, _Lv =< 270 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 861, _ServerLv =< 880, _Lv >= 271, _Lv =< 280 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 861, _ServerLv =< 880, _Lv >= 281, _Lv =< 290 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 861, _ServerLv =< 880, _Lv >= 291, _Lv =< 300 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 861, _ServerLv =< 880, _Lv >= 301, _Lv =< 310 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 861, _ServerLv =< 880, _Lv >= 311, _Lv =< 320 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 861, _ServerLv =< 880, _Lv >= 321, _Lv =< 330 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 861, _ServerLv =< 880, _Lv >= 331, _Lv =< 340 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 861, _ServerLv =< 880, _Lv >= 341, _Lv =< 350 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 861, _ServerLv =< 880, _Lv >= 351, _Lv =< 360 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 861, _ServerLv =< 880, _Lv >= 361, _Lv =< 370 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 861, _ServerLv =< 880, _Lv >= 371, _Lv =< 380 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 861, _ServerLv =< 880, _Lv >= 381, _Lv =< 390 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 861, _ServerLv =< 880, _Lv >= 391, _Lv =< 400 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 861, _ServerLv =< 880, _Lv >= 401, _Lv =< 410 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 861, _ServerLv =< 880, _Lv >= 411, _Lv =< 420 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 861, _ServerLv =< 880, _Lv >= 421, _Lv =< 430 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 861, _ServerLv =< 880, _Lv >= 431, _Lv =< 440 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 861, _ServerLv =< 880, _Lv >= 441, _Lv =< 450 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 861, _ServerLv =< 880, _Lv >= 451, _Lv =< 460 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 861, _ServerLv =< 880, _Lv >= 461, _Lv =< 470 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 861, _ServerLv =< 880, _Lv >= 471, _Lv =< 480 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 861, _ServerLv =< 880, _Lv >= 481, _Lv =< 490 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 861, _ServerLv =< 880, _Lv >= 491, _Lv =< 500 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 861, _ServerLv =< 880, _Lv >= 501, _Lv =< 510 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 861, _ServerLv =< 880, _Lv >= 511, _Lv =< 520 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 861, _ServerLv =< 880, _Lv >= 521, _Lv =< 530 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 861, _ServerLv =< 880, _Lv >= 531, _Lv =< 540 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 861, _ServerLv =< 880, _Lv >= 541, _Lv =< 550 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 861, _ServerLv =< 880, _Lv >= 551, _Lv =< 560 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 861, _ServerLv =< 880, _Lv >= 561, _Lv =< 570 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 861, _ServerLv =< 880, _Lv >= 571, _Lv =< 580 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 861, _ServerLv =< 880, _Lv >= 581, _Lv =< 590 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 861, _ServerLv =< 880, _Lv >= 591, _Lv =< 600 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 861, _ServerLv =< 880, _Lv >= 601, _Lv =< 610 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 861, _ServerLv =< 880, _Lv >= 611, _Lv =< 620 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 861, _ServerLv =< 880, _Lv >= 621, _Lv =< 630 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 861, _ServerLv =< 880, _Lv >= 631, _Lv =< 640 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 861, _ServerLv =< 880, _Lv >= 641, _Lv =< 650 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 861, _ServerLv =< 880, _Lv >= 651, _Lv =< 660 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 861, _ServerLv =< 880, _Lv >= 661, _Lv =< 670 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 861, _ServerLv =< 880, _Lv >= 671, _Lv =< 680 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 861, _ServerLv =< 880, _Lv >= 681, _Lv =< 690 ->
		440;
get_add(_ServerLv,_Lv) when _ServerLv >= 861, _ServerLv =< 880, _Lv >= 691, _Lv =< 700 ->
		385;
get_add(_ServerLv,_Lv) when _ServerLv >= 861, _ServerLv =< 880, _Lv >= 701, _Lv =< 720 ->
		330;
get_add(_ServerLv,_Lv) when _ServerLv >= 861, _ServerLv =< 880, _Lv >= 721, _Lv =< 740 ->
		275;
get_add(_ServerLv,_Lv) when _ServerLv >= 861, _ServerLv =< 880, _Lv >= 741, _Lv =< 760 ->
		275;
get_add(_ServerLv,_Lv) when _ServerLv >= 861, _ServerLv =< 880, _Lv >= 761, _Lv =< 780 ->
		220;
get_add(_ServerLv,_Lv) when _ServerLv >= 861, _ServerLv =< 880, _Lv >= 781, _Lv =< 800 ->
		165;
get_add(_ServerLv,_Lv) when _ServerLv >= 861, _ServerLv =< 880, _Lv >= 801, _Lv =< 820 ->
		110;
get_add(_ServerLv,_Lv) when _ServerLv >= 861, _ServerLv =< 880, _Lv >= 821, _Lv =< 840 ->
		65;
get_add(_ServerLv,_Lv) when _ServerLv >= 861, _ServerLv =< 880, _Lv >= 841, _Lv =< 860 ->
		35;
get_add(_ServerLv,_Lv) when _ServerLv >= 881, _ServerLv =< 900, _Lv >= 121, _Lv =< 130 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 881, _ServerLv =< 900, _Lv >= 131, _Lv =< 140 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 881, _ServerLv =< 900, _Lv >= 141, _Lv =< 150 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 881, _ServerLv =< 900, _Lv >= 151, _Lv =< 160 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 881, _ServerLv =< 900, _Lv >= 161, _Lv =< 170 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 881, _ServerLv =< 900, _Lv >= 171, _Lv =< 180 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 881, _ServerLv =< 900, _Lv >= 181, _Lv =< 190 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 881, _ServerLv =< 900, _Lv >= 191, _Lv =< 200 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 881, _ServerLv =< 900, _Lv >= 201, _Lv =< 210 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 881, _ServerLv =< 900, _Lv >= 211, _Lv =< 220 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 881, _ServerLv =< 900, _Lv >= 221, _Lv =< 230 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 881, _ServerLv =< 900, _Lv >= 231, _Lv =< 240 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 881, _ServerLv =< 900, _Lv >= 241, _Lv =< 250 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 881, _ServerLv =< 900, _Lv >= 251, _Lv =< 260 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 881, _ServerLv =< 900, _Lv >= 261, _Lv =< 270 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 881, _ServerLv =< 900, _Lv >= 271, _Lv =< 280 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 881, _ServerLv =< 900, _Lv >= 281, _Lv =< 290 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 881, _ServerLv =< 900, _Lv >= 291, _Lv =< 300 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 881, _ServerLv =< 900, _Lv >= 301, _Lv =< 310 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 881, _ServerLv =< 900, _Lv >= 311, _Lv =< 320 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 881, _ServerLv =< 900, _Lv >= 321, _Lv =< 330 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 881, _ServerLv =< 900, _Lv >= 331, _Lv =< 340 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 881, _ServerLv =< 900, _Lv >= 341, _Lv =< 350 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 881, _ServerLv =< 900, _Lv >= 351, _Lv =< 360 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 881, _ServerLv =< 900, _Lv >= 361, _Lv =< 370 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 881, _ServerLv =< 900, _Lv >= 371, _Lv =< 380 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 881, _ServerLv =< 900, _Lv >= 381, _Lv =< 390 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 881, _ServerLv =< 900, _Lv >= 391, _Lv =< 400 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 881, _ServerLv =< 900, _Lv >= 401, _Lv =< 410 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 881, _ServerLv =< 900, _Lv >= 411, _Lv =< 420 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 881, _ServerLv =< 900, _Lv >= 421, _Lv =< 430 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 881, _ServerLv =< 900, _Lv >= 431, _Lv =< 440 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 881, _ServerLv =< 900, _Lv >= 441, _Lv =< 450 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 881, _ServerLv =< 900, _Lv >= 451, _Lv =< 460 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 881, _ServerLv =< 900, _Lv >= 461, _Lv =< 470 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 881, _ServerLv =< 900, _Lv >= 471, _Lv =< 480 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 881, _ServerLv =< 900, _Lv >= 481, _Lv =< 490 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 881, _ServerLv =< 900, _Lv >= 491, _Lv =< 500 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 881, _ServerLv =< 900, _Lv >= 501, _Lv =< 510 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 881, _ServerLv =< 900, _Lv >= 511, _Lv =< 520 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 881, _ServerLv =< 900, _Lv >= 521, _Lv =< 530 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 881, _ServerLv =< 900, _Lv >= 531, _Lv =< 540 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 881, _ServerLv =< 900, _Lv >= 541, _Lv =< 550 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 881, _ServerLv =< 900, _Lv >= 551, _Lv =< 560 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 881, _ServerLv =< 900, _Lv >= 561, _Lv =< 570 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 881, _ServerLv =< 900, _Lv >= 571, _Lv =< 580 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 881, _ServerLv =< 900, _Lv >= 581, _Lv =< 590 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 881, _ServerLv =< 900, _Lv >= 591, _Lv =< 600 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 881, _ServerLv =< 900, _Lv >= 601, _Lv =< 610 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 881, _ServerLv =< 900, _Lv >= 611, _Lv =< 620 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 881, _ServerLv =< 900, _Lv >= 621, _Lv =< 630 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 881, _ServerLv =< 900, _Lv >= 631, _Lv =< 640 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 881, _ServerLv =< 900, _Lv >= 641, _Lv =< 650 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 881, _ServerLv =< 900, _Lv >= 651, _Lv =< 660 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 881, _ServerLv =< 900, _Lv >= 661, _Lv =< 670 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 881, _ServerLv =< 900, _Lv >= 671, _Lv =< 680 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 881, _ServerLv =< 900, _Lv >= 681, _Lv =< 690 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 881, _ServerLv =< 900, _Lv >= 691, _Lv =< 700 ->
		440;
get_add(_ServerLv,_Lv) when _ServerLv >= 881, _ServerLv =< 900, _Lv >= 701, _Lv =< 720 ->
		385;
get_add(_ServerLv,_Lv) when _ServerLv >= 881, _ServerLv =< 900, _Lv >= 721, _Lv =< 740 ->
		330;
get_add(_ServerLv,_Lv) when _ServerLv >= 881, _ServerLv =< 900, _Lv >= 741, _Lv =< 760 ->
		275;
get_add(_ServerLv,_Lv) when _ServerLv >= 881, _ServerLv =< 900, _Lv >= 761, _Lv =< 780 ->
		275;
get_add(_ServerLv,_Lv) when _ServerLv >= 881, _ServerLv =< 900, _Lv >= 781, _Lv =< 800 ->
		220;
get_add(_ServerLv,_Lv) when _ServerLv >= 881, _ServerLv =< 900, _Lv >= 801, _Lv =< 820 ->
		165;
get_add(_ServerLv,_Lv) when _ServerLv >= 881, _ServerLv =< 900, _Lv >= 821, _Lv =< 840 ->
		110;
get_add(_ServerLv,_Lv) when _ServerLv >= 881, _ServerLv =< 900, _Lv >= 841, _Lv =< 860 ->
		65;
get_add(_ServerLv,_Lv) when _ServerLv >= 881, _ServerLv =< 900, _Lv >= 861, _Lv =< 880 ->
		35;
get_add(_ServerLv,_Lv) when _ServerLv >= 901, _ServerLv =< 920, _Lv >= 121, _Lv =< 130 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 901, _ServerLv =< 920, _Lv >= 131, _Lv =< 140 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 901, _ServerLv =< 920, _Lv >= 141, _Lv =< 150 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 901, _ServerLv =< 920, _Lv >= 151, _Lv =< 160 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 901, _ServerLv =< 920, _Lv >= 161, _Lv =< 170 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 901, _ServerLv =< 920, _Lv >= 171, _Lv =< 180 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 901, _ServerLv =< 920, _Lv >= 181, _Lv =< 190 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 901, _ServerLv =< 920, _Lv >= 191, _Lv =< 200 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 901, _ServerLv =< 920, _Lv >= 201, _Lv =< 210 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 901, _ServerLv =< 920, _Lv >= 211, _Lv =< 220 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 901, _ServerLv =< 920, _Lv >= 221, _Lv =< 230 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 901, _ServerLv =< 920, _Lv >= 231, _Lv =< 240 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 901, _ServerLv =< 920, _Lv >= 241, _Lv =< 250 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 901, _ServerLv =< 920, _Lv >= 251, _Lv =< 260 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 901, _ServerLv =< 920, _Lv >= 261, _Lv =< 270 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 901, _ServerLv =< 920, _Lv >= 271, _Lv =< 280 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 901, _ServerLv =< 920, _Lv >= 281, _Lv =< 290 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 901, _ServerLv =< 920, _Lv >= 291, _Lv =< 300 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 901, _ServerLv =< 920, _Lv >= 301, _Lv =< 310 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 901, _ServerLv =< 920, _Lv >= 311, _Lv =< 320 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 901, _ServerLv =< 920, _Lv >= 321, _Lv =< 330 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 901, _ServerLv =< 920, _Lv >= 331, _Lv =< 340 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 901, _ServerLv =< 920, _Lv >= 341, _Lv =< 350 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 901, _ServerLv =< 920, _Lv >= 351, _Lv =< 360 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 901, _ServerLv =< 920, _Lv >= 361, _Lv =< 370 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 901, _ServerLv =< 920, _Lv >= 371, _Lv =< 380 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 901, _ServerLv =< 920, _Lv >= 381, _Lv =< 390 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 901, _ServerLv =< 920, _Lv >= 391, _Lv =< 400 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 901, _ServerLv =< 920, _Lv >= 401, _Lv =< 410 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 901, _ServerLv =< 920, _Lv >= 411, _Lv =< 420 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 901, _ServerLv =< 920, _Lv >= 421, _Lv =< 430 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 901, _ServerLv =< 920, _Lv >= 431, _Lv =< 440 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 901, _ServerLv =< 920, _Lv >= 441, _Lv =< 450 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 901, _ServerLv =< 920, _Lv >= 451, _Lv =< 460 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 901, _ServerLv =< 920, _Lv >= 461, _Lv =< 470 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 901, _ServerLv =< 920, _Lv >= 471, _Lv =< 480 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 901, _ServerLv =< 920, _Lv >= 481, _Lv =< 490 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 901, _ServerLv =< 920, _Lv >= 491, _Lv =< 500 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 901, _ServerLv =< 920, _Lv >= 501, _Lv =< 510 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 901, _ServerLv =< 920, _Lv >= 511, _Lv =< 520 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 901, _ServerLv =< 920, _Lv >= 521, _Lv =< 530 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 901, _ServerLv =< 920, _Lv >= 531, _Lv =< 540 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 901, _ServerLv =< 920, _Lv >= 541, _Lv =< 550 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 901, _ServerLv =< 920, _Lv >= 551, _Lv =< 560 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 901, _ServerLv =< 920, _Lv >= 561, _Lv =< 570 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 901, _ServerLv =< 920, _Lv >= 571, _Lv =< 580 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 901, _ServerLv =< 920, _Lv >= 581, _Lv =< 590 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 901, _ServerLv =< 920, _Lv >= 591, _Lv =< 600 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 901, _ServerLv =< 920, _Lv >= 601, _Lv =< 610 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 901, _ServerLv =< 920, _Lv >= 611, _Lv =< 620 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 901, _ServerLv =< 920, _Lv >= 621, _Lv =< 630 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 901, _ServerLv =< 920, _Lv >= 631, _Lv =< 640 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 901, _ServerLv =< 920, _Lv >= 641, _Lv =< 650 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 901, _ServerLv =< 920, _Lv >= 651, _Lv =< 660 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 901, _ServerLv =< 920, _Lv >= 661, _Lv =< 670 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 901, _ServerLv =< 920, _Lv >= 671, _Lv =< 680 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 901, _ServerLv =< 920, _Lv >= 681, _Lv =< 690 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 901, _ServerLv =< 920, _Lv >= 691, _Lv =< 700 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 901, _ServerLv =< 920, _Lv >= 701, _Lv =< 720 ->
		440;
get_add(_ServerLv,_Lv) when _ServerLv >= 901, _ServerLv =< 920, _Lv >= 721, _Lv =< 740 ->
		385;
get_add(_ServerLv,_Lv) when _ServerLv >= 901, _ServerLv =< 920, _Lv >= 741, _Lv =< 760 ->
		330;
get_add(_ServerLv,_Lv) when _ServerLv >= 901, _ServerLv =< 920, _Lv >= 761, _Lv =< 780 ->
		275;
get_add(_ServerLv,_Lv) when _ServerLv >= 901, _ServerLv =< 920, _Lv >= 781, _Lv =< 800 ->
		275;
get_add(_ServerLv,_Lv) when _ServerLv >= 901, _ServerLv =< 920, _Lv >= 801, _Lv =< 820 ->
		220;
get_add(_ServerLv,_Lv) when _ServerLv >= 901, _ServerLv =< 920, _Lv >= 821, _Lv =< 840 ->
		165;
get_add(_ServerLv,_Lv) when _ServerLv >= 901, _ServerLv =< 920, _Lv >= 841, _Lv =< 860 ->
		110;
get_add(_ServerLv,_Lv) when _ServerLv >= 901, _ServerLv =< 920, _Lv >= 861, _Lv =< 880 ->
		65;
get_add(_ServerLv,_Lv) when _ServerLv >= 901, _ServerLv =< 920, _Lv >= 881, _Lv =< 900 ->
		35;
get_add(_ServerLv,_Lv) when _ServerLv >= 921, _ServerLv =< 940, _Lv >= 121, _Lv =< 130 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 921, _ServerLv =< 940, _Lv >= 131, _Lv =< 140 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 921, _ServerLv =< 940, _Lv >= 141, _Lv =< 150 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 921, _ServerLv =< 940, _Lv >= 151, _Lv =< 160 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 921, _ServerLv =< 940, _Lv >= 161, _Lv =< 170 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 921, _ServerLv =< 940, _Lv >= 171, _Lv =< 180 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 921, _ServerLv =< 940, _Lv >= 181, _Lv =< 190 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 921, _ServerLv =< 940, _Lv >= 191, _Lv =< 200 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 921, _ServerLv =< 940, _Lv >= 201, _Lv =< 210 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 921, _ServerLv =< 940, _Lv >= 211, _Lv =< 220 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 921, _ServerLv =< 940, _Lv >= 221, _Lv =< 230 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 921, _ServerLv =< 940, _Lv >= 231, _Lv =< 240 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 921, _ServerLv =< 940, _Lv >= 241, _Lv =< 250 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 921, _ServerLv =< 940, _Lv >= 251, _Lv =< 260 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 921, _ServerLv =< 940, _Lv >= 261, _Lv =< 270 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 921, _ServerLv =< 940, _Lv >= 271, _Lv =< 280 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 921, _ServerLv =< 940, _Lv >= 281, _Lv =< 290 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 921, _ServerLv =< 940, _Lv >= 291, _Lv =< 300 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 921, _ServerLv =< 940, _Lv >= 301, _Lv =< 310 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 921, _ServerLv =< 940, _Lv >= 311, _Lv =< 320 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 921, _ServerLv =< 940, _Lv >= 321, _Lv =< 330 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 921, _ServerLv =< 940, _Lv >= 331, _Lv =< 340 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 921, _ServerLv =< 940, _Lv >= 341, _Lv =< 350 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 921, _ServerLv =< 940, _Lv >= 351, _Lv =< 360 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 921, _ServerLv =< 940, _Lv >= 361, _Lv =< 370 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 921, _ServerLv =< 940, _Lv >= 371, _Lv =< 380 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 921, _ServerLv =< 940, _Lv >= 381, _Lv =< 390 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 921, _ServerLv =< 940, _Lv >= 391, _Lv =< 400 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 921, _ServerLv =< 940, _Lv >= 401, _Lv =< 410 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 921, _ServerLv =< 940, _Lv >= 411, _Lv =< 420 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 921, _ServerLv =< 940, _Lv >= 421, _Lv =< 430 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 921, _ServerLv =< 940, _Lv >= 431, _Lv =< 440 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 921, _ServerLv =< 940, _Lv >= 441, _Lv =< 450 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 921, _ServerLv =< 940, _Lv >= 451, _Lv =< 460 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 921, _ServerLv =< 940, _Lv >= 461, _Lv =< 470 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 921, _ServerLv =< 940, _Lv >= 471, _Lv =< 480 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 921, _ServerLv =< 940, _Lv >= 481, _Lv =< 490 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 921, _ServerLv =< 940, _Lv >= 491, _Lv =< 500 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 921, _ServerLv =< 940, _Lv >= 501, _Lv =< 510 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 921, _ServerLv =< 940, _Lv >= 511, _Lv =< 520 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 921, _ServerLv =< 940, _Lv >= 521, _Lv =< 530 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 921, _ServerLv =< 940, _Lv >= 531, _Lv =< 540 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 921, _ServerLv =< 940, _Lv >= 541, _Lv =< 550 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 921, _ServerLv =< 940, _Lv >= 551, _Lv =< 560 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 921, _ServerLv =< 940, _Lv >= 561, _Lv =< 570 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 921, _ServerLv =< 940, _Lv >= 571, _Lv =< 580 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 921, _ServerLv =< 940, _Lv >= 581, _Lv =< 590 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 921, _ServerLv =< 940, _Lv >= 591, _Lv =< 600 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 921, _ServerLv =< 940, _Lv >= 601, _Lv =< 610 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 921, _ServerLv =< 940, _Lv >= 611, _Lv =< 620 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 921, _ServerLv =< 940, _Lv >= 621, _Lv =< 630 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 921, _ServerLv =< 940, _Lv >= 631, _Lv =< 640 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 921, _ServerLv =< 940, _Lv >= 641, _Lv =< 650 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 921, _ServerLv =< 940, _Lv >= 651, _Lv =< 660 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 921, _ServerLv =< 940, _Lv >= 661, _Lv =< 670 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 921, _ServerLv =< 940, _Lv >= 671, _Lv =< 680 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 921, _ServerLv =< 940, _Lv >= 681, _Lv =< 690 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 921, _ServerLv =< 940, _Lv >= 691, _Lv =< 700 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 921, _ServerLv =< 940, _Lv >= 701, _Lv =< 720 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 921, _ServerLv =< 940, _Lv >= 721, _Lv =< 740 ->
		440;
get_add(_ServerLv,_Lv) when _ServerLv >= 921, _ServerLv =< 940, _Lv >= 741, _Lv =< 760 ->
		385;
get_add(_ServerLv,_Lv) when _ServerLv >= 921, _ServerLv =< 940, _Lv >= 761, _Lv =< 780 ->
		330;
get_add(_ServerLv,_Lv) when _ServerLv >= 921, _ServerLv =< 940, _Lv >= 781, _Lv =< 800 ->
		275;
get_add(_ServerLv,_Lv) when _ServerLv >= 921, _ServerLv =< 940, _Lv >= 801, _Lv =< 820 ->
		275;
get_add(_ServerLv,_Lv) when _ServerLv >= 921, _ServerLv =< 940, _Lv >= 821, _Lv =< 840 ->
		220;
get_add(_ServerLv,_Lv) when _ServerLv >= 921, _ServerLv =< 940, _Lv >= 841, _Lv =< 860 ->
		165;
get_add(_ServerLv,_Lv) when _ServerLv >= 921, _ServerLv =< 940, _Lv >= 861, _Lv =< 880 ->
		110;
get_add(_ServerLv,_Lv) when _ServerLv >= 921, _ServerLv =< 940, _Lv >= 881, _Lv =< 900 ->
		65;
get_add(_ServerLv,_Lv) when _ServerLv >= 921, _ServerLv =< 940, _Lv >= 901, _Lv =< 920 ->
		35;
get_add(_ServerLv,_Lv) when _ServerLv >= 941, _ServerLv =< 960, _Lv >= 121, _Lv =< 130 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 941, _ServerLv =< 960, _Lv >= 131, _Lv =< 140 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 941, _ServerLv =< 960, _Lv >= 141, _Lv =< 150 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 941, _ServerLv =< 960, _Lv >= 151, _Lv =< 160 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 941, _ServerLv =< 960, _Lv >= 161, _Lv =< 170 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 941, _ServerLv =< 960, _Lv >= 171, _Lv =< 180 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 941, _ServerLv =< 960, _Lv >= 181, _Lv =< 190 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 941, _ServerLv =< 960, _Lv >= 191, _Lv =< 200 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 941, _ServerLv =< 960, _Lv >= 201, _Lv =< 210 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 941, _ServerLv =< 960, _Lv >= 211, _Lv =< 220 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 941, _ServerLv =< 960, _Lv >= 221, _Lv =< 230 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 941, _ServerLv =< 960, _Lv >= 231, _Lv =< 240 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 941, _ServerLv =< 960, _Lv >= 241, _Lv =< 250 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 941, _ServerLv =< 960, _Lv >= 251, _Lv =< 260 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 941, _ServerLv =< 960, _Lv >= 261, _Lv =< 270 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 941, _ServerLv =< 960, _Lv >= 271, _Lv =< 280 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 941, _ServerLv =< 960, _Lv >= 281, _Lv =< 290 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 941, _ServerLv =< 960, _Lv >= 291, _Lv =< 300 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 941, _ServerLv =< 960, _Lv >= 301, _Lv =< 310 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 941, _ServerLv =< 960, _Lv >= 311, _Lv =< 320 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 941, _ServerLv =< 960, _Lv >= 321, _Lv =< 330 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 941, _ServerLv =< 960, _Lv >= 331, _Lv =< 340 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 941, _ServerLv =< 960, _Lv >= 341, _Lv =< 350 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 941, _ServerLv =< 960, _Lv >= 351, _Lv =< 360 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 941, _ServerLv =< 960, _Lv >= 361, _Lv =< 370 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 941, _ServerLv =< 960, _Lv >= 371, _Lv =< 380 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 941, _ServerLv =< 960, _Lv >= 381, _Lv =< 390 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 941, _ServerLv =< 960, _Lv >= 391, _Lv =< 400 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 941, _ServerLv =< 960, _Lv >= 401, _Lv =< 410 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 941, _ServerLv =< 960, _Lv >= 411, _Lv =< 420 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 941, _ServerLv =< 960, _Lv >= 421, _Lv =< 430 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 941, _ServerLv =< 960, _Lv >= 431, _Lv =< 440 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 941, _ServerLv =< 960, _Lv >= 441, _Lv =< 450 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 941, _ServerLv =< 960, _Lv >= 451, _Lv =< 460 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 941, _ServerLv =< 960, _Lv >= 461, _Lv =< 470 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 941, _ServerLv =< 960, _Lv >= 471, _Lv =< 480 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 941, _ServerLv =< 960, _Lv >= 481, _Lv =< 490 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 941, _ServerLv =< 960, _Lv >= 491, _Lv =< 500 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 941, _ServerLv =< 960, _Lv >= 501, _Lv =< 510 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 941, _ServerLv =< 960, _Lv >= 511, _Lv =< 520 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 941, _ServerLv =< 960, _Lv >= 521, _Lv =< 530 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 941, _ServerLv =< 960, _Lv >= 531, _Lv =< 540 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 941, _ServerLv =< 960, _Lv >= 541, _Lv =< 550 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 941, _ServerLv =< 960, _Lv >= 551, _Lv =< 560 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 941, _ServerLv =< 960, _Lv >= 561, _Lv =< 570 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 941, _ServerLv =< 960, _Lv >= 571, _Lv =< 580 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 941, _ServerLv =< 960, _Lv >= 581, _Lv =< 590 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 941, _ServerLv =< 960, _Lv >= 591, _Lv =< 600 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 941, _ServerLv =< 960, _Lv >= 601, _Lv =< 610 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 941, _ServerLv =< 960, _Lv >= 611, _Lv =< 620 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 941, _ServerLv =< 960, _Lv >= 621, _Lv =< 630 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 941, _ServerLv =< 960, _Lv >= 631, _Lv =< 640 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 941, _ServerLv =< 960, _Lv >= 641, _Lv =< 650 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 941, _ServerLv =< 960, _Lv >= 651, _Lv =< 660 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 941, _ServerLv =< 960, _Lv >= 661, _Lv =< 670 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 941, _ServerLv =< 960, _Lv >= 671, _Lv =< 680 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 941, _ServerLv =< 960, _Lv >= 681, _Lv =< 690 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 941, _ServerLv =< 960, _Lv >= 691, _Lv =< 700 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 941, _ServerLv =< 960, _Lv >= 701, _Lv =< 720 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 941, _ServerLv =< 960, _Lv >= 721, _Lv =< 740 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 941, _ServerLv =< 960, _Lv >= 741, _Lv =< 760 ->
		440;
get_add(_ServerLv,_Lv) when _ServerLv >= 941, _ServerLv =< 960, _Lv >= 761, _Lv =< 780 ->
		385;
get_add(_ServerLv,_Lv) when _ServerLv >= 941, _ServerLv =< 960, _Lv >= 781, _Lv =< 800 ->
		330;
get_add(_ServerLv,_Lv) when _ServerLv >= 941, _ServerLv =< 960, _Lv >= 801, _Lv =< 820 ->
		275;
get_add(_ServerLv,_Lv) when _ServerLv >= 941, _ServerLv =< 960, _Lv >= 821, _Lv =< 840 ->
		275;
get_add(_ServerLv,_Lv) when _ServerLv >= 941, _ServerLv =< 960, _Lv >= 841, _Lv =< 860 ->
		220;
get_add(_ServerLv,_Lv) when _ServerLv >= 941, _ServerLv =< 960, _Lv >= 861, _Lv =< 880 ->
		165;
get_add(_ServerLv,_Lv) when _ServerLv >= 941, _ServerLv =< 960, _Lv >= 881, _Lv =< 900 ->
		110;
get_add(_ServerLv,_Lv) when _ServerLv >= 941, _ServerLv =< 960, _Lv >= 901, _Lv =< 920 ->
		65;
get_add(_ServerLv,_Lv) when _ServerLv >= 941, _ServerLv =< 960, _Lv >= 921, _Lv =< 940 ->
		35;
get_add(_ServerLv,_Lv) when _ServerLv >= 961, _ServerLv =< 980, _Lv >= 121, _Lv =< 130 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 961, _ServerLv =< 980, _Lv >= 131, _Lv =< 140 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 961, _ServerLv =< 980, _Lv >= 141, _Lv =< 150 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 961, _ServerLv =< 980, _Lv >= 151, _Lv =< 160 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 961, _ServerLv =< 980, _Lv >= 161, _Lv =< 170 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 961, _ServerLv =< 980, _Lv >= 171, _Lv =< 180 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 961, _ServerLv =< 980, _Lv >= 181, _Lv =< 190 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 961, _ServerLv =< 980, _Lv >= 191, _Lv =< 200 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 961, _ServerLv =< 980, _Lv >= 201, _Lv =< 210 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 961, _ServerLv =< 980, _Lv >= 211, _Lv =< 220 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 961, _ServerLv =< 980, _Lv >= 221, _Lv =< 230 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 961, _ServerLv =< 980, _Lv >= 231, _Lv =< 240 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 961, _ServerLv =< 980, _Lv >= 241, _Lv =< 250 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 961, _ServerLv =< 980, _Lv >= 251, _Lv =< 260 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 961, _ServerLv =< 980, _Lv >= 261, _Lv =< 270 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 961, _ServerLv =< 980, _Lv >= 271, _Lv =< 280 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 961, _ServerLv =< 980, _Lv >= 281, _Lv =< 290 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 961, _ServerLv =< 980, _Lv >= 291, _Lv =< 300 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 961, _ServerLv =< 980, _Lv >= 301, _Lv =< 310 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 961, _ServerLv =< 980, _Lv >= 311, _Lv =< 320 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 961, _ServerLv =< 980, _Lv >= 321, _Lv =< 330 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 961, _ServerLv =< 980, _Lv >= 331, _Lv =< 340 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 961, _ServerLv =< 980, _Lv >= 341, _Lv =< 350 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 961, _ServerLv =< 980, _Lv >= 351, _Lv =< 360 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 961, _ServerLv =< 980, _Lv >= 361, _Lv =< 370 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 961, _ServerLv =< 980, _Lv >= 371, _Lv =< 380 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 961, _ServerLv =< 980, _Lv >= 381, _Lv =< 390 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 961, _ServerLv =< 980, _Lv >= 391, _Lv =< 400 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 961, _ServerLv =< 980, _Lv >= 401, _Lv =< 410 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 961, _ServerLv =< 980, _Lv >= 411, _Lv =< 420 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 961, _ServerLv =< 980, _Lv >= 421, _Lv =< 430 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 961, _ServerLv =< 980, _Lv >= 431, _Lv =< 440 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 961, _ServerLv =< 980, _Lv >= 441, _Lv =< 450 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 961, _ServerLv =< 980, _Lv >= 451, _Lv =< 460 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 961, _ServerLv =< 980, _Lv >= 461, _Lv =< 470 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 961, _ServerLv =< 980, _Lv >= 471, _Lv =< 480 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 961, _ServerLv =< 980, _Lv >= 481, _Lv =< 490 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 961, _ServerLv =< 980, _Lv >= 491, _Lv =< 500 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 961, _ServerLv =< 980, _Lv >= 501, _Lv =< 510 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 961, _ServerLv =< 980, _Lv >= 511, _Lv =< 520 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 961, _ServerLv =< 980, _Lv >= 521, _Lv =< 530 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 961, _ServerLv =< 980, _Lv >= 531, _Lv =< 540 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 961, _ServerLv =< 980, _Lv >= 541, _Lv =< 550 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 961, _ServerLv =< 980, _Lv >= 551, _Lv =< 560 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 961, _ServerLv =< 980, _Lv >= 561, _Lv =< 570 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 961, _ServerLv =< 980, _Lv >= 571, _Lv =< 580 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 961, _ServerLv =< 980, _Lv >= 581, _Lv =< 590 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 961, _ServerLv =< 980, _Lv >= 591, _Lv =< 600 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 961, _ServerLv =< 980, _Lv >= 601, _Lv =< 610 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 961, _ServerLv =< 980, _Lv >= 611, _Lv =< 620 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 961, _ServerLv =< 980, _Lv >= 621, _Lv =< 630 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 961, _ServerLv =< 980, _Lv >= 631, _Lv =< 640 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 961, _ServerLv =< 980, _Lv >= 641, _Lv =< 650 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 961, _ServerLv =< 980, _Lv >= 651, _Lv =< 660 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 961, _ServerLv =< 980, _Lv >= 661, _Lv =< 670 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 961, _ServerLv =< 980, _Lv >= 671, _Lv =< 680 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 961, _ServerLv =< 980, _Lv >= 681, _Lv =< 690 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 961, _ServerLv =< 980, _Lv >= 691, _Lv =< 700 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 961, _ServerLv =< 980, _Lv >= 701, _Lv =< 720 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 961, _ServerLv =< 980, _Lv >= 721, _Lv =< 740 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 961, _ServerLv =< 980, _Lv >= 741, _Lv =< 760 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 961, _ServerLv =< 980, _Lv >= 761, _Lv =< 780 ->
		440;
get_add(_ServerLv,_Lv) when _ServerLv >= 961, _ServerLv =< 980, _Lv >= 781, _Lv =< 800 ->
		385;
get_add(_ServerLv,_Lv) when _ServerLv >= 961, _ServerLv =< 980, _Lv >= 801, _Lv =< 820 ->
		330;
get_add(_ServerLv,_Lv) when _ServerLv >= 961, _ServerLv =< 980, _Lv >= 821, _Lv =< 840 ->
		275;
get_add(_ServerLv,_Lv) when _ServerLv >= 961, _ServerLv =< 980, _Lv >= 841, _Lv =< 860 ->
		275;
get_add(_ServerLv,_Lv) when _ServerLv >= 961, _ServerLv =< 980, _Lv >= 861, _Lv =< 880 ->
		220;
get_add(_ServerLv,_Lv) when _ServerLv >= 961, _ServerLv =< 980, _Lv >= 881, _Lv =< 900 ->
		165;
get_add(_ServerLv,_Lv) when _ServerLv >= 961, _ServerLv =< 980, _Lv >= 901, _Lv =< 920 ->
		110;
get_add(_ServerLv,_Lv) when _ServerLv >= 961, _ServerLv =< 980, _Lv >= 921, _Lv =< 940 ->
		65;
get_add(_ServerLv,_Lv) when _ServerLv >= 961, _ServerLv =< 980, _Lv >= 941, _Lv =< 960 ->
		35;
get_add(_ServerLv,_Lv) when _ServerLv >= 981, _ServerLv =< 1000, _Lv >= 121, _Lv =< 130 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 981, _ServerLv =< 1000, _Lv >= 131, _Lv =< 140 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 981, _ServerLv =< 1000, _Lv >= 141, _Lv =< 150 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 981, _ServerLv =< 1000, _Lv >= 151, _Lv =< 160 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 981, _ServerLv =< 1000, _Lv >= 161, _Lv =< 170 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 981, _ServerLv =< 1000, _Lv >= 171, _Lv =< 180 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 981, _ServerLv =< 1000, _Lv >= 181, _Lv =< 190 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 981, _ServerLv =< 1000, _Lv >= 191, _Lv =< 200 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 981, _ServerLv =< 1000, _Lv >= 201, _Lv =< 210 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 981, _ServerLv =< 1000, _Lv >= 211, _Lv =< 220 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 981, _ServerLv =< 1000, _Lv >= 221, _Lv =< 230 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 981, _ServerLv =< 1000, _Lv >= 231, _Lv =< 240 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 981, _ServerLv =< 1000, _Lv >= 241, _Lv =< 250 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 981, _ServerLv =< 1000, _Lv >= 251, _Lv =< 260 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 981, _ServerLv =< 1000, _Lv >= 261, _Lv =< 270 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 981, _ServerLv =< 1000, _Lv >= 271, _Lv =< 280 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 981, _ServerLv =< 1000, _Lv >= 281, _Lv =< 290 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 981, _ServerLv =< 1000, _Lv >= 291, _Lv =< 300 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 981, _ServerLv =< 1000, _Lv >= 301, _Lv =< 310 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 981, _ServerLv =< 1000, _Lv >= 311, _Lv =< 320 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 981, _ServerLv =< 1000, _Lv >= 321, _Lv =< 330 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 981, _ServerLv =< 1000, _Lv >= 331, _Lv =< 340 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 981, _ServerLv =< 1000, _Lv >= 341, _Lv =< 350 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 981, _ServerLv =< 1000, _Lv >= 351, _Lv =< 360 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 981, _ServerLv =< 1000, _Lv >= 361, _Lv =< 370 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 981, _ServerLv =< 1000, _Lv >= 371, _Lv =< 380 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 981, _ServerLv =< 1000, _Lv >= 381, _Lv =< 390 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 981, _ServerLv =< 1000, _Lv >= 391, _Lv =< 400 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 981, _ServerLv =< 1000, _Lv >= 401, _Lv =< 410 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 981, _ServerLv =< 1000, _Lv >= 411, _Lv =< 420 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 981, _ServerLv =< 1000, _Lv >= 421, _Lv =< 430 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 981, _ServerLv =< 1000, _Lv >= 431, _Lv =< 440 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 981, _ServerLv =< 1000, _Lv >= 441, _Lv =< 450 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 981, _ServerLv =< 1000, _Lv >= 451, _Lv =< 460 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 981, _ServerLv =< 1000, _Lv >= 461, _Lv =< 470 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 981, _ServerLv =< 1000, _Lv >= 471, _Lv =< 480 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 981, _ServerLv =< 1000, _Lv >= 481, _Lv =< 490 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 981, _ServerLv =< 1000, _Lv >= 491, _Lv =< 500 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 981, _ServerLv =< 1000, _Lv >= 501, _Lv =< 510 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 981, _ServerLv =< 1000, _Lv >= 511, _Lv =< 520 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 981, _ServerLv =< 1000, _Lv >= 521, _Lv =< 530 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 981, _ServerLv =< 1000, _Lv >= 531, _Lv =< 540 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 981, _ServerLv =< 1000, _Lv >= 541, _Lv =< 550 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 981, _ServerLv =< 1000, _Lv >= 551, _Lv =< 560 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 981, _ServerLv =< 1000, _Lv >= 561, _Lv =< 570 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 981, _ServerLv =< 1000, _Lv >= 571, _Lv =< 580 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 981, _ServerLv =< 1000, _Lv >= 581, _Lv =< 590 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 981, _ServerLv =< 1000, _Lv >= 591, _Lv =< 600 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 981, _ServerLv =< 1000, _Lv >= 601, _Lv =< 610 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 981, _ServerLv =< 1000, _Lv >= 611, _Lv =< 620 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 981, _ServerLv =< 1000, _Lv >= 621, _Lv =< 630 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 981, _ServerLv =< 1000, _Lv >= 631, _Lv =< 640 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 981, _ServerLv =< 1000, _Lv >= 641, _Lv =< 650 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 981, _ServerLv =< 1000, _Lv >= 651, _Lv =< 660 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 981, _ServerLv =< 1000, _Lv >= 661, _Lv =< 670 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 981, _ServerLv =< 1000, _Lv >= 671, _Lv =< 680 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 981, _ServerLv =< 1000, _Lv >= 681, _Lv =< 690 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 981, _ServerLv =< 1000, _Lv >= 691, _Lv =< 700 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 981, _ServerLv =< 1000, _Lv >= 701, _Lv =< 720 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 981, _ServerLv =< 1000, _Lv >= 721, _Lv =< 740 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 981, _ServerLv =< 1000, _Lv >= 741, _Lv =< 760 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 981, _ServerLv =< 1000, _Lv >= 761, _Lv =< 780 ->
		550;
get_add(_ServerLv,_Lv) when _ServerLv >= 981, _ServerLv =< 1000, _Lv >= 781, _Lv =< 800 ->
		440;
get_add(_ServerLv,_Lv) when _ServerLv >= 981, _ServerLv =< 1000, _Lv >= 801, _Lv =< 820 ->
		385;
get_add(_ServerLv,_Lv) when _ServerLv >= 981, _ServerLv =< 1000, _Lv >= 821, _Lv =< 840 ->
		330;
get_add(_ServerLv,_Lv) when _ServerLv >= 981, _ServerLv =< 1000, _Lv >= 841, _Lv =< 860 ->
		275;
get_add(_ServerLv,_Lv) when _ServerLv >= 981, _ServerLv =< 1000, _Lv >= 861, _Lv =< 880 ->
		275;
get_add(_ServerLv,_Lv) when _ServerLv >= 981, _ServerLv =< 1000, _Lv >= 881, _Lv =< 900 ->
		220;
get_add(_ServerLv,_Lv) when _ServerLv >= 981, _ServerLv =< 1000, _Lv >= 901, _Lv =< 920 ->
		165;
get_add(_ServerLv,_Lv) when _ServerLv >= 981, _ServerLv =< 1000, _Lv >= 921, _Lv =< 940 ->
		110;
get_add(_ServerLv,_Lv) when _ServerLv >= 981, _ServerLv =< 1000, _Lv >= 941, _Lv =< 960 ->
		65;
get_add(_ServerLv,_Lv) when _ServerLv >= 981, _ServerLv =< 1000, _Lv >= 961, _Lv =< 980 ->
		35;
get_add(_ServerLv,_Lv) ->
	0.

