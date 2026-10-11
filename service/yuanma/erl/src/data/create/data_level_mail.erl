%%%---------------------------------------
%%% module      : data_level_mail
%%% description : 等级邮件配置
%%%
%%%---------------------------------------
-module(data_level_mail).
-compile(export_all).
-include("level_mail.hrl").



get_all_source() ->
[{2,[yy_sh921_lj_xunlei_PM001432]}].

get_reward(2,2) ->
[{0,14010001,1}];

get_reward(_Sourceno,_Level) ->
	[].

get_title(2,2) ->
"迅雷平台专属称号";

get_title(_Sourceno,_Level) ->
	"".

get_content(2,2) ->
"亲爱的冒险者，请查收您的专属礼物";

get_content(_Sourceno,_Level) ->
	"".

