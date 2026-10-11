%%%---------------------------------------
%%% module      : data_compensate_exp
%%% description : 补偿经验配置
%%%
%%%---------------------------------------
-module(data_compensate_exp).
-compile(export_all).
-include("compensate_exp.hrl").



get_exp_ratio(_Day,_Lv) when _Day >= 2, _Day =< 2, _Lv >= 0, _Lv =< 180 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 3, _Day =< 3, _Lv >= 0, _Lv =< 220 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 4, _Day =< 4, _Lv >= 0, _Lv =< 240 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 5, _Day =< 5, _Lv >= 0, _Lv =< 250 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 6, _Day =< 6, _Lv >= 0, _Lv =< 265 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 7, _Day =< 7, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 8, _Day =< 8, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 9, _Day =< 9, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 10, _Day =< 10, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 11, _Day =< 11, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 12, _Day =< 12, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 13, _Day =< 13, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 14, _Day =< 14, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 15, _Day =< 15, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 16, _Day =< 16, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 17, _Day =< 17, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 18, _Day =< 18, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 19, _Day =< 19, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 20, _Day =< 20, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 21, _Day =< 21, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 22, _Day =< 22, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 23, _Day =< 23, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 24, _Day =< 24, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 25, _Day =< 25, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 26, _Day =< 26, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 27, _Day =< 27, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 28, _Day =< 28, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 29, _Day =< 29, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 30, _Day =< 30, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 31, _Day =< 31, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 32, _Day =< 32, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 33, _Day =< 33, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 34, _Day =< 34, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 35, _Day =< 35, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 36, _Day =< 36, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 37, _Day =< 37, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 38, _Day =< 38, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 39, _Day =< 39, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 40, _Day =< 40, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 41, _Day =< 41, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 42, _Day =< 42, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 43, _Day =< 43, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 44, _Day =< 44, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 45, _Day =< 45, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 46, _Day =< 46, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 47, _Day =< 47, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 48, _Day =< 48, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 49, _Day =< 49, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 50, _Day =< 50, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 51, _Day =< 51, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 52, _Day =< 52, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 53, _Day =< 53, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 54, _Day =< 54, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 55, _Day =< 55, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 56, _Day =< 56, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 57, _Day =< 57, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 58, _Day =< 58, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 59, _Day =< 59, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 60, _Day =< 60, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 61, _Day =< 61, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 62, _Day =< 62, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 63, _Day =< 63, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 64, _Day =< 64, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 65, _Day =< 65, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 66, _Day =< 66, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 67, _Day =< 67, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 68, _Day =< 68, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 69, _Day =< 69, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 70, _Day =< 70, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 71, _Day =< 71, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 72, _Day =< 72, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 73, _Day =< 73, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 74, _Day =< 74, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 75, _Day =< 75, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 76, _Day =< 76, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 77, _Day =< 77, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 78, _Day =< 78, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 79, _Day =< 79, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 80, _Day =< 80, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 81, _Day =< 81, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 82, _Day =< 82, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 83, _Day =< 83, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 84, _Day =< 84, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 85, _Day =< 85, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 86, _Day =< 86, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 87, _Day =< 87, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 88, _Day =< 88, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 89, _Day =< 89, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 90, _Day =< 90, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 91, _Day =< 91, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 92, _Day =< 92, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 93, _Day =< 93, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 94, _Day =< 94, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 95, _Day =< 95, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 96, _Day =< 96, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 97, _Day =< 97, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 98, _Day =< 98, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 99, _Day =< 99, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 100, _Day =< 100, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 101, _Day =< 101, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 102, _Day =< 102, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 103, _Day =< 103, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 104, _Day =< 104, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 105, _Day =< 105, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 106, _Day =< 106, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 107, _Day =< 107, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 108, _Day =< 108, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 109, _Day =< 109, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 110, _Day =< 110, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 111, _Day =< 111, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 112, _Day =< 112, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 113, _Day =< 113, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 114, _Day =< 114, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 115, _Day =< 115, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 116, _Day =< 116, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 117, _Day =< 117, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 118, _Day =< 118, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 119, _Day =< 119, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 120, _Day =< 120, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 121, _Day =< 121, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 122, _Day =< 122, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 123, _Day =< 123, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 124, _Day =< 124, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 125, _Day =< 125, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 126, _Day =< 126, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 127, _Day =< 127, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 128, _Day =< 128, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 129, _Day =< 129, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 130, _Day =< 130, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 131, _Day =< 131, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 132, _Day =< 132, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 133, _Day =< 133, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 134, _Day =< 134, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 135, _Day =< 135, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 136, _Day =< 136, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 137, _Day =< 137, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 138, _Day =< 138, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 139, _Day =< 139, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 140, _Day =< 140, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 141, _Day =< 141, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 142, _Day =< 142, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 143, _Day =< 143, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 144, _Day =< 144, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 145, _Day =< 145, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 146, _Day =< 146, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 147, _Day =< 147, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 148, _Day =< 148, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 149, _Day =< 149, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 150, _Day =< 150, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 151, _Day =< 151, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 152, _Day =< 152, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 153, _Day =< 153, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 154, _Day =< 154, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 155, _Day =< 155, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 156, _Day =< 156, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 157, _Day =< 157, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 158, _Day =< 158, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 159, _Day =< 159, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 160, _Day =< 160, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 161, _Day =< 161, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 162, _Day =< 162, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 163, _Day =< 163, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 164, _Day =< 164, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 165, _Day =< 165, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 166, _Day =< 166, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 167, _Day =< 167, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 168, _Day =< 168, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 169, _Day =< 169, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 170, _Day =< 170, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 171, _Day =< 171, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 172, _Day =< 172, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 173, _Day =< 173, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 174, _Day =< 174, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 175, _Day =< 175, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 176, _Day =< 176, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 177, _Day =< 177, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 178, _Day =< 178, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 179, _Day =< 179, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 180, _Day =< 180, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 181, _Day =< 181, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 182, _Day =< 182, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 183, _Day =< 183, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 184, _Day =< 184, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 185, _Day =< 185, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 186, _Day =< 186, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 187, _Day =< 187, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 188, _Day =< 188, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 189, _Day =< 189, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 190, _Day =< 190, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 191, _Day =< 191, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 192, _Day =< 192, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 193, _Day =< 193, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 194, _Day =< 194, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 195, _Day =< 195, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 196, _Day =< 196, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 197, _Day =< 197, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 198, _Day =< 198, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 199, _Day =< 199, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 200, _Day =< 200, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 201, _Day =< 201, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 202, _Day =< 202, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 203, _Day =< 203, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 204, _Day =< 204, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 205, _Day =< 205, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 206, _Day =< 206, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 207, _Day =< 207, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 208, _Day =< 208, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 209, _Day =< 209, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 210, _Day =< 210, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 211, _Day =< 211, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 212, _Day =< 212, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 213, _Day =< 213, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 214, _Day =< 214, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 215, _Day =< 215, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 216, _Day =< 216, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 217, _Day =< 217, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 218, _Day =< 218, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 219, _Day =< 219, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 220, _Day =< 220, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 221, _Day =< 221, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 222, _Day =< 222, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 223, _Day =< 223, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 224, _Day =< 224, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 225, _Day =< 225, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 226, _Day =< 226, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 227, _Day =< 227, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 228, _Day =< 228, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 229, _Day =< 229, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 230, _Day =< 230, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 231, _Day =< 231, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 232, _Day =< 232, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 233, _Day =< 233, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 234, _Day =< 234, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 235, _Day =< 235, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 236, _Day =< 236, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 237, _Day =< 237, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 238, _Day =< 238, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 239, _Day =< 239, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 240, _Day =< 240, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 241, _Day =< 241, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 242, _Day =< 242, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 243, _Day =< 243, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 244, _Day =< 244, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 245, _Day =< 245, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 246, _Day =< 246, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 247, _Day =< 247, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 248, _Day =< 248, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 249, _Day =< 249, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 250, _Day =< 250, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 251, _Day =< 251, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 252, _Day =< 252, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 253, _Day =< 253, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 254, _Day =< 254, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 255, _Day =< 255, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 256, _Day =< 256, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 257, _Day =< 257, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 258, _Day =< 258, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 259, _Day =< 259, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 260, _Day =< 260, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 261, _Day =< 261, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 262, _Day =< 262, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 263, _Day =< 263, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 264, _Day =< 264, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 265, _Day =< 265, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 266, _Day =< 266, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 267, _Day =< 267, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 268, _Day =< 268, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 269, _Day =< 269, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 270, _Day =< 270, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 271, _Day =< 271, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 272, _Day =< 272, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 273, _Day =< 273, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 274, _Day =< 274, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 275, _Day =< 275, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 276, _Day =< 276, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 277, _Day =< 277, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 278, _Day =< 278, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 279, _Day =< 279, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 280, _Day =< 280, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 281, _Day =< 281, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 282, _Day =< 282, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 283, _Day =< 283, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 284, _Day =< 284, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 285, _Day =< 285, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 286, _Day =< 286, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 287, _Day =< 287, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 288, _Day =< 288, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 289, _Day =< 289, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 290, _Day =< 290, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 291, _Day =< 291, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 292, _Day =< 292, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 293, _Day =< 293, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 294, _Day =< 294, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 295, _Day =< 295, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 296, _Day =< 296, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 297, _Day =< 297, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 298, _Day =< 298, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 299, _Day =< 299, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 300, _Day =< 300, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 301, _Day =< 301, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 302, _Day =< 302, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 303, _Day =< 303, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 304, _Day =< 304, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 305, _Day =< 305, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 306, _Day =< 306, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 307, _Day =< 307, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 308, _Day =< 308, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 309, _Day =< 309, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 310, _Day =< 310, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 311, _Day =< 311, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 312, _Day =< 312, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 313, _Day =< 313, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 314, _Day =< 314, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 315, _Day =< 315, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 316, _Day =< 316, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 317, _Day =< 317, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 318, _Day =< 318, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 319, _Day =< 319, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 320, _Day =< 320, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 321, _Day =< 321, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 322, _Day =< 322, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 323, _Day =< 323, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 324, _Day =< 324, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 325, _Day =< 325, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 326, _Day =< 326, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 327, _Day =< 327, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 328, _Day =< 328, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 329, _Day =< 329, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 330, _Day =< 330, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 331, _Day =< 331, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 332, _Day =< 332, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 333, _Day =< 333, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 334, _Day =< 334, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 335, _Day =< 335, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 336, _Day =< 336, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 337, _Day =< 337, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 338, _Day =< 338, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 339, _Day =< 339, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 340, _Day =< 340, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 341, _Day =< 341, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 342, _Day =< 342, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 343, _Day =< 343, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 344, _Day =< 344, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 345, _Day =< 345, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 346, _Day =< 346, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 347, _Day =< 347, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 348, _Day =< 348, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 349, _Day =< 349, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 350, _Day =< 350, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 351, _Day =< 351, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 352, _Day =< 352, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 353, _Day =< 353, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 354, _Day =< 354, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 355, _Day =< 355, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 356, _Day =< 356, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 357, _Day =< 357, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 358, _Day =< 358, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 359, _Day =< 359, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) when _Day >= 360, _Day =< 360, _Lv >= 0, _Lv =< 270 ->
		10000;
get_exp_ratio(_Day,_Lv) ->
	0.

get_exp_goods_reward(_Day,_Lv) when _Day >= 3, _Day =< 3, _Lv >= 0, _Lv =< 205 ->
		[{0,37010014,10}];
get_exp_goods_reward(_Day,_Lv) when _Day >= 4, _Day =< 4, _Lv >= 0, _Lv =< 220 ->
		[{0,37010015,10}];
get_exp_goods_reward(_Day,_Lv) when _Day >= 5, _Day =< 5, _Lv >= 0, _Lv =< 245 ->
		[{0,37010015,15}];
get_exp_goods_reward(_Day,_Lv) when _Day >= 6, _Day =< 6, _Lv >= 0, _Lv =< 260 ->
		[{0,37010015,20}];
get_exp_goods_reward(_Day,_Lv) when _Day >= 7, _Day =< 7, _Lv >= 0, _Lv =< 270 ->
		[{0,37010015,20}];
get_exp_goods_reward(_Day,_Lv) ->
	[].

