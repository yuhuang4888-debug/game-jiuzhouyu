%%%---------------------------------------
%%% module      : data_picture
%%% description : 头像配置
%%%
%%%---------------------------------------
-module(data_picture).
-compile(export_all).
-include("game.hrl").



get_picture_ids() ->
[1,2,3,4,101,102,103,104,105,106,107,201,202,203,204,205,206,207,301,302,303,304,305,306,307,401,402,403,404,405,406,407].


get_picture_info_by_id(1) ->
[{1,[]}];


get_picture_info_by_id(2) ->
[{2,[]}];


get_picture_info_by_id(3) ->
[{3,[]}];


get_picture_info_by_id(4) ->
[{4,[]}];


get_picture_info_by_id(101) ->
[{1,[{turn,1}]}];


get_picture_info_by_id(102) ->
[{1,[{turn,2}]}];


get_picture_info_by_id(103) ->
[{1,[{turn,3}]}];


get_picture_info_by_id(104) ->
[{1,[{turn,4}]}];


get_picture_info_by_id(105) ->
[{1,[{turn,5}]}];


get_picture_info_by_id(106) ->
[{1,[{turn,6}]}];


get_picture_info_by_id(107) ->
[{1,[{turn,7}]}];


get_picture_info_by_id(201) ->
[{2,[{turn,1}]}];


get_picture_info_by_id(202) ->
[{2,[{turn,2}]}];


get_picture_info_by_id(203) ->
[{2,[{turn,3}]}];


get_picture_info_by_id(204) ->
[{2,[{turn,4}]}];


get_picture_info_by_id(205) ->
[{2,[{turn,5}]}];


get_picture_info_by_id(206) ->
[{2,[{turn,6}]}];


get_picture_info_by_id(207) ->
[{2,[{turn,7}]}];


get_picture_info_by_id(301) ->
[{3,[{turn,1}]}];


get_picture_info_by_id(302) ->
[{3,[{turn,2}]}];


get_picture_info_by_id(303) ->
[{3,[{turn,3}]}];


get_picture_info_by_id(304) ->
[{3,[{turn,4}]}];


get_picture_info_by_id(305) ->
[{3,[{turn,5}]}];


get_picture_info_by_id(306) ->
[{3,[{turn,6}]}];


get_picture_info_by_id(307) ->
[{3,[{turn,7}]}];


get_picture_info_by_id(401) ->
[{4,[{turn,1}]}];


get_picture_info_by_id(402) ->
[{4,[{turn,2}]}];


get_picture_info_by_id(403) ->
[{4,[{turn,3}]}];


get_picture_info_by_id(404) ->
[{4,[{turn,4}]}];


get_picture_info_by_id(405) ->
[{4,[{turn,5}]}];


get_picture_info_by_id(406) ->
[{4,[{turn,6}]}];


get_picture_info_by_id(407) ->
[{4,[{turn,7}]}];

get_picture_info_by_id(_Id) ->
	[].


get_picture_by_career(1) ->
[1,101,102,103,104,105,106,107];


get_picture_by_career(2) ->
[2,201,202,203,204,205,206,207];


get_picture_by_career(3) ->
[3,301,302,303,304,305,306,307];


get_picture_by_career(4) ->
[4,401,402,403,404,405,406,407];

get_picture_by_career(_Sex) ->
	[].

