%%%---------------------------------------
%%% module      : data_recharge_first2
%%% description : 添加有礼配置
%%%
%%%---------------------------------------
-module(data_recharge_first2).
-compile(export_all).




get_source_conditions("jzy_sh921_wx_P0010642") ->
[{mail_lv, 90}, {money, 60}, {mail, [{54, 55}]}];


get_source_conditions("jzy_sh921_wx_P0011415") ->
[{mail_lv, 90}, {money, 60}, {mail, [{54, 55}]}];


get_source_conditions("jzy_sh921_wx_PM002569") ->
[{mail_lv, 90}, {money, 60}, {mail, [{54, 55}]}];


get_source_conditions("jzy_sh921_wx_PM002676") ->
[{mail_lv, 90}, {money, 60}, {mail, [{54, 55}]}];


get_source_conditions("jzy_sh921_wx_PM002823") ->
[{mail_lv, 90}, {money, 60}, {mail, [{54, 55}]}];


get_source_conditions("yy_suyou_wx_1") ->
[{mail_lv, 90}, {money, 60}, {mail, [{54, 55}]}];


get_source_conditions("yy_suyou_wx_test1") ->
[{mail_lv, 90}, {money, 60}, {mail, [{54, 55}]}];


get_source_conditions("jzy_sh921_test_ios_P0010643") ->
[{mail_lv, 90}, {money, 60}, {mail, [{54, 55}]}];


get_source_conditions("jzy_sh921_test_P0010642") ->
[{mail_lv, 90}, {money, 60}, {mail, [{54, 55}]}];


get_source_conditions("jzy_sh921_wx_ios_P0010643") ->
[{mail_lv, 90}, {money, 60}, {mail, [{54, 55}]}];


get_source_conditions("jzy_sh921_wx_ios_P0011418") ->
[{mail_lv, 90}, {money, 60}, {mail, [{54, 55}]}];


get_source_conditions("yy_suyou") ->
[{mail_lv, 150}, {money, 300}, {mail, [{54, 55}]}];


get_source_conditions("jzy_sh921_test") ->
[{mail_lv, 90}, {money, 60}, {mail, [{54, 55}]}];

get_source_conditions(_Source) ->
	undefined.

