%%%---------------------------------------
%%% module      : data_arcana
%%% description : 远古奥术配置
%%%
%%%---------------------------------------
-module(data_arcana).
-compile(export_all).
-include("arcana.hrl").



get_arcana_lv(101,1,1) ->
	#base_arcana_lv{id = 101,career = 1,lv = 1,condition = [{pre_skill,100101,2}],skill_id = 100101,skill_lv = 2,is_auto = 1};

get_arcana_lv(101,1,2) ->
	#base_arcana_lv{id = 101,career = 1,lv = 2,condition = [{cost,[{0,7802001,1}]}],skill_id = 100101,skill_lv = 3,is_auto = 0};

get_arcana_lv(101,1,3) ->
	#base_arcana_lv{id = 101,career = 1,lv = 3,condition = [{cost,[{0,7802001,1}]}],skill_id = 100101,skill_lv = 4,is_auto = 0};

get_arcana_lv(101,1,4) ->
	#base_arcana_lv{id = 101,career = 1,lv = 4,condition = [{cost,[{0,7802001,1}]}],skill_id = 100101,skill_lv = 5,is_auto = 0};

get_arcana_lv(102,1,1) ->
	#base_arcana_lv{id = 102,career = 1,lv = 1,condition = [{pre_skill,100201,2}],skill_id = 100201,skill_lv = 2,is_auto = 1};

get_arcana_lv(102,1,2) ->
	#base_arcana_lv{id = 102,career = 1,lv = 2,condition = [{cost,[{0,7802001,1}]}],skill_id = 100201,skill_lv = 3,is_auto = 0};

get_arcana_lv(102,1,3) ->
	#base_arcana_lv{id = 102,career = 1,lv = 3,condition = [{cost,[{0,7802001,1}]}],skill_id = 100201,skill_lv = 4,is_auto = 0};

get_arcana_lv(102,1,4) ->
	#base_arcana_lv{id = 102,career = 1,lv = 4,condition = [{cost,[{0,7802001,1}]}],skill_id = 100201,skill_lv = 5,is_auto = 0};

get_arcana_lv(103,1,1) ->
	#base_arcana_lv{id = 103,career = 1,lv = 1,condition = [{pre_skill,100301,2}],skill_id = 100301,skill_lv = 2,is_auto = 1};

get_arcana_lv(103,1,2) ->
	#base_arcana_lv{id = 103,career = 1,lv = 2,condition = [{cost,[{0,7802001,1}]}],skill_id = 100301,skill_lv = 3,is_auto = 0};

get_arcana_lv(103,1,3) ->
	#base_arcana_lv{id = 103,career = 1,lv = 3,condition = [{cost,[{0,7802001,1}]}],skill_id = 100301,skill_lv = 4,is_auto = 0};

get_arcana_lv(103,1,4) ->
	#base_arcana_lv{id = 103,career = 1,lv = 4,condition = [{cost,[{0,7802001,1}]}],skill_id = 100301,skill_lv = 5,is_auto = 0};

get_arcana_lv(104,1,1) ->
	#base_arcana_lv{id = 104,career = 1,lv = 1,condition = [{pre_skill,100401,2}],skill_id = 100401,skill_lv = 2,is_auto = 1};

get_arcana_lv(104,1,2) ->
	#base_arcana_lv{id = 104,career = 1,lv = 2,condition = [{cost,[{0,7802001,1}]}],skill_id = 100401,skill_lv = 3,is_auto = 0};

get_arcana_lv(104,1,3) ->
	#base_arcana_lv{id = 104,career = 1,lv = 3,condition = [{cost,[{0,7802001,1}]}],skill_id = 100401,skill_lv = 4,is_auto = 0};

get_arcana_lv(104,1,4) ->
	#base_arcana_lv{id = 104,career = 1,lv = 4,condition = [{cost,[{0,7802001,1}]}],skill_id = 100401,skill_lv = 5,is_auto = 0};

get_arcana_lv(105,1,1) ->
	#base_arcana_lv{id = 105,career = 1,lv = 1,condition = [{pre_skill,100501,2}],skill_id = 100501,skill_lv = 2,is_auto = 1};

get_arcana_lv(105,1,2) ->
	#base_arcana_lv{id = 105,career = 1,lv = 2,condition = [{cost,[{0,7802001,1}]}],skill_id = 100501,skill_lv = 3,is_auto = 0};

get_arcana_lv(105,1,3) ->
	#base_arcana_lv{id = 105,career = 1,lv = 3,condition = [{cost,[{0,7802001,1}]}],skill_id = 100501,skill_lv = 4,is_auto = 0};

get_arcana_lv(105,1,4) ->
	#base_arcana_lv{id = 105,career = 1,lv = 4,condition = [{cost,[{0,7802001,1}]}],skill_id = 100501,skill_lv = 5,is_auto = 0};

get_arcana_lv(105,1,5) ->
	#base_arcana_lv{id = 105,career = 1,lv = 5,condition = [{cost,[{0,7802001,1}]}],skill_id = 100501,skill_lv = 6,is_auto = 0};

get_arcana_lv(106,1,1) ->
	#base_arcana_lv{id = 106,career = 1,lv = 1,condition = [{pre_skill,100601,2}],skill_id = 100601,skill_lv = 2,is_auto = 1};

get_arcana_lv(106,1,2) ->
	#base_arcana_lv{id = 106,career = 1,lv = 2,condition = [{cost,[{0,7802001,1}]}],skill_id = 100601,skill_lv = 3,is_auto = 0};

get_arcana_lv(106,1,3) ->
	#base_arcana_lv{id = 106,career = 1,lv = 3,condition = [{cost,[{0,7802001,1}]}],skill_id = 100601,skill_lv = 4,is_auto = 0};

get_arcana_lv(106,1,4) ->
	#base_arcana_lv{id = 106,career = 1,lv = 4,condition = [{cost,[{0,7802001,1}]}],skill_id = 100601,skill_lv = 5,is_auto = 0};

get_arcana_lv(106,1,5) ->
	#base_arcana_lv{id = 106,career = 1,lv = 5,condition = [{cost,[{0,7802001,1}]}],skill_id = 100601,skill_lv = 6,is_auto = 0};

get_arcana_lv(107,1,1) ->
	#base_arcana_lv{id = 107,career = 1,lv = 1,condition = [{cost,[{0,7801001,1}]}],skill_id = 480107,skill_lv = 1,is_auto = 0};

get_arcana_lv(107,1,2) ->
	#base_arcana_lv{id = 107,career = 1,lv = 2,condition = [{cost,[{0,7802001,1}]}],skill_id = 480107,skill_lv = 2,is_auto = 0};

get_arcana_lv(107,1,3) ->
	#base_arcana_lv{id = 107,career = 1,lv = 3,condition = [{cost,[{0,7802001,1}]}],skill_id = 480107,skill_lv = 3,is_auto = 0};

get_arcana_lv(107,1,4) ->
	#base_arcana_lv{id = 107,career = 1,lv = 4,condition = [{cost,[{0,7802001,1}]}],skill_id = 480107,skill_lv = 4,is_auto = 0};

get_arcana_lv(108,1,1) ->
	#base_arcana_lv{id = 108,career = 1,lv = 1,condition = [{cost,[{0,7801002,1}]}],skill_id = 480108,skill_lv = 1,is_auto = 0};

get_arcana_lv(108,1,2) ->
	#base_arcana_lv{id = 108,career = 1,lv = 2,condition = [{cost,[{0,7802001,1}]}],skill_id = 480108,skill_lv = 2,is_auto = 0};

get_arcana_lv(108,1,3) ->
	#base_arcana_lv{id = 108,career = 1,lv = 3,condition = [{cost,[{0,7802001,1}]}],skill_id = 480108,skill_lv = 3,is_auto = 0};

get_arcana_lv(108,1,4) ->
	#base_arcana_lv{id = 108,career = 1,lv = 4,condition = [{cost,[{0,7802001,1}]}],skill_id = 480108,skill_lv = 4,is_auto = 0};

get_arcana_lv(111,1,1) ->
	#base_arcana_lv{id = 111,career = 1,lv = 1,condition = [{arcana,107,1},{arcana_lv,9},{cost,[{0,7801003,1}]}],skill_id = 480111,skill_lv = 1,is_auto = 0};

get_arcana_lv(111,1,2) ->
	#base_arcana_lv{id = 111,career = 1,lv = 2,condition = [{cost,[{0,7802001,1}]}],skill_id = 480111,skill_lv = 2,is_auto = 0};

get_arcana_lv(111,1,3) ->
	#base_arcana_lv{id = 111,career = 1,lv = 3,condition = [{cost,[{0,7802001,1}]}],skill_id = 480111,skill_lv = 3,is_auto = 0};

get_arcana_lv(111,1,4) ->
	#base_arcana_lv{id = 111,career = 1,lv = 4,condition = [{cost,[{0,7802001,1}]}],skill_id = 480111,skill_lv = 4,is_auto = 0};

get_arcana_lv(111,1,5) ->
	#base_arcana_lv{id = 111,career = 1,lv = 5,condition = [{cost,[{0,7802001,1}]}],skill_id = 480111,skill_lv = 5,is_auto = 0};

get_arcana_lv(112,1,1) ->
	#base_arcana_lv{id = 112,career = 1,lv = 1,condition = [{arcana,111,1},{arcana_lv,9},{cost,[{0,7801007,1}]}],skill_id = 480112,skill_lv = 1,is_auto = 0};

get_arcana_lv(112,1,2) ->
	#base_arcana_lv{id = 112,career = 1,lv = 2,condition = [{cost,[{0,7802001,1}]}],skill_id = 480112,skill_lv = 2,is_auto = 0};

get_arcana_lv(112,1,3) ->
	#base_arcana_lv{id = 112,career = 1,lv = 3,condition = [{cost,[{0,7802001,1}]}],skill_id = 480112,skill_lv = 3,is_auto = 0};

get_arcana_lv(112,1,4) ->
	#base_arcana_lv{id = 112,career = 1,lv = 4,condition = [{cost,[{0,7802001,1}]}],skill_id = 480112,skill_lv = 4,is_auto = 0};

get_arcana_lv(112,1,5) ->
	#base_arcana_lv{id = 112,career = 1,lv = 5,condition = [{cost,[{0,7802001,1}]}],skill_id = 480112,skill_lv = 5,is_auto = 0};

get_arcana_lv(113,1,1) ->
	#base_arcana_lv{id = 113,career = 1,lv = 1,condition = [{arcana,111,1},{arcana_lv,9},{cost,[{0,7801008,1}]}],skill_id = 480113,skill_lv = 1,is_auto = 0};

get_arcana_lv(113,1,2) ->
	#base_arcana_lv{id = 113,career = 1,lv = 2,condition = [{cost,[{0,7802001,1}]}],skill_id = 480113,skill_lv = 2,is_auto = 0};

get_arcana_lv(113,1,3) ->
	#base_arcana_lv{id = 113,career = 1,lv = 3,condition = [{cost,[{0,7802001,1}]}],skill_id = 480113,skill_lv = 3,is_auto = 0};

get_arcana_lv(113,1,4) ->
	#base_arcana_lv{id = 113,career = 1,lv = 4,condition = [{cost,[{0,7802001,1}]}],skill_id = 480113,skill_lv = 4,is_auto = 0};

get_arcana_lv(113,1,5) ->
	#base_arcana_lv{id = 113,career = 1,lv = 5,condition = [{cost,[{0,7802001,1}]}],skill_id = 480113,skill_lv = 5,is_auto = 0};

get_arcana_lv(114,1,1) ->
	#base_arcana_lv{id = 114,career = 1,lv = 1,condition = [{arcana,111,1},{arcana_lv,20},{cost,[{0,7801005,1}]}],skill_id = 480114,skill_lv = 1,is_auto = 0};

get_arcana_lv(114,1,2) ->
	#base_arcana_lv{id = 114,career = 1,lv = 2,condition = [{cost,[{0,7802001,1}]}],skill_id = 480114,skill_lv = 2,is_auto = 0};

get_arcana_lv(114,1,3) ->
	#base_arcana_lv{id = 114,career = 1,lv = 3,condition = [{cost,[{0,7802001,1}]}],skill_id = 480114,skill_lv = 3,is_auto = 0};

get_arcana_lv(114,1,4) ->
	#base_arcana_lv{id = 114,career = 1,lv = 4,condition = [{cost,[{0,7802001,1}]}],skill_id = 480114,skill_lv = 4,is_auto = 0};

get_arcana_lv(114,1,5) ->
	#base_arcana_lv{id = 114,career = 1,lv = 5,condition = [{cost,[{0,7802001,1}]}],skill_id = 480114,skill_lv = 5,is_auto = 0};

get_arcana_lv(115,1,1) ->
	#base_arcana_lv{id = 115,career = 1,lv = 1,condition = [{arcana,111,1},{arcana_lv,20},{cost,[{0,7801011,1}]}],skill_id = 480115,skill_lv = 1,is_auto = 0};

get_arcana_lv(115,1,2) ->
	#base_arcana_lv{id = 115,career = 1,lv = 2,condition = [{cost,[{0,7802001,1}]}],skill_id = 480115,skill_lv = 2,is_auto = 0};

get_arcana_lv(115,1,3) ->
	#base_arcana_lv{id = 115,career = 1,lv = 3,condition = [{cost,[{0,7802001,1}]}],skill_id = 480115,skill_lv = 3,is_auto = 0};

get_arcana_lv(115,1,4) ->
	#base_arcana_lv{id = 115,career = 1,lv = 4,condition = [{cost,[{0,7802001,1}]}],skill_id = 480115,skill_lv = 4,is_auto = 0};

get_arcana_lv(115,1,5) ->
	#base_arcana_lv{id = 115,career = 1,lv = 5,condition = [{cost,[{0,7802001,1}]}],skill_id = 480115,skill_lv = 5,is_auto = 0};

get_arcana_lv(121,1,1) ->
	#base_arcana_lv{id = 121,career = 1,lv = 1,condition = [{arcana,108,1},{arcana_lv,9},{cost,[{0,7801004,1}]}],skill_id = 480121,skill_lv = 1,is_auto = 0};

get_arcana_lv(121,1,2) ->
	#base_arcana_lv{id = 121,career = 1,lv = 2,condition = [{cost,[{0,7802001,1}]}],skill_id = 480121,skill_lv = 2,is_auto = 0};

get_arcana_lv(121,1,3) ->
	#base_arcana_lv{id = 121,career = 1,lv = 3,condition = [{cost,[{0,7802001,1}]}],skill_id = 480121,skill_lv = 3,is_auto = 0};

get_arcana_lv(121,1,4) ->
	#base_arcana_lv{id = 121,career = 1,lv = 4,condition = [{cost,[{0,7802001,1}]}],skill_id = 480121,skill_lv = 4,is_auto = 0};

get_arcana_lv(121,1,5) ->
	#base_arcana_lv{id = 121,career = 1,lv = 5,condition = [{cost,[{0,7802001,1}]}],skill_id = 480121,skill_lv = 5,is_auto = 0};

get_arcana_lv(122,1,1) ->
	#base_arcana_lv{id = 122,career = 1,lv = 1,condition = [{arcana,121,1},{arcana_lv,9},{cost,[{0,7801009,1}]}],skill_id = 480122,skill_lv = 1,is_auto = 0};

get_arcana_lv(122,1,2) ->
	#base_arcana_lv{id = 122,career = 1,lv = 2,condition = [{cost,[{0,7802001,1}]}],skill_id = 480122,skill_lv = 2,is_auto = 0};

get_arcana_lv(122,1,3) ->
	#base_arcana_lv{id = 122,career = 1,lv = 3,condition = [{cost,[{0,7802001,1}]}],skill_id = 480122,skill_lv = 3,is_auto = 0};

get_arcana_lv(122,1,4) ->
	#base_arcana_lv{id = 122,career = 1,lv = 4,condition = [{cost,[{0,7802001,1}]}],skill_id = 480122,skill_lv = 4,is_auto = 0};

get_arcana_lv(122,1,5) ->
	#base_arcana_lv{id = 122,career = 1,lv = 5,condition = [{cost,[{0,7802001,1}]}],skill_id = 480122,skill_lv = 5,is_auto = 0};

get_arcana_lv(123,1,1) ->
	#base_arcana_lv{id = 123,career = 1,lv = 1,condition = [{arcana,121,1},{arcana_lv,9},{cost,[{0,7801010,1}]}],skill_id = 480123,skill_lv = 1,is_auto = 0};

get_arcana_lv(123,1,2) ->
	#base_arcana_lv{id = 123,career = 1,lv = 2,condition = [{cost,[{0,7802001,1}]}],skill_id = 480123,skill_lv = 2,is_auto = 0};

get_arcana_lv(123,1,3) ->
	#base_arcana_lv{id = 123,career = 1,lv = 3,condition = [{cost,[{0,7802001,1}]}],skill_id = 480123,skill_lv = 3,is_auto = 0};

get_arcana_lv(123,1,4) ->
	#base_arcana_lv{id = 123,career = 1,lv = 4,condition = [{cost,[{0,7802001,1}]}],skill_id = 480123,skill_lv = 4,is_auto = 0};

get_arcana_lv(123,1,5) ->
	#base_arcana_lv{id = 123,career = 1,lv = 5,condition = [{cost,[{0,7802001,1}]}],skill_id = 480123,skill_lv = 5,is_auto = 0};

get_arcana_lv(124,1,1) ->
	#base_arcana_lv{id = 124,career = 1,lv = 1,condition = [{arcana,121,1},{arcana_lv,20},{cost,[{0,7801006,1}]}],skill_id = 480124,skill_lv = 1,is_auto = 0};

get_arcana_lv(124,1,2) ->
	#base_arcana_lv{id = 124,career = 1,lv = 2,condition = [{cost,[{0,7802001,1}]}],skill_id = 480124,skill_lv = 2,is_auto = 0};

get_arcana_lv(124,1,3) ->
	#base_arcana_lv{id = 124,career = 1,lv = 3,condition = [{cost,[{0,7802001,1}]}],skill_id = 480124,skill_lv = 3,is_auto = 0};

get_arcana_lv(124,1,4) ->
	#base_arcana_lv{id = 124,career = 1,lv = 4,condition = [{cost,[{0,7802001,1}]}],skill_id = 480124,skill_lv = 4,is_auto = 0};

get_arcana_lv(124,1,5) ->
	#base_arcana_lv{id = 124,career = 1,lv = 5,condition = [{cost,[{0,7802001,1}]}],skill_id = 480124,skill_lv = 5,is_auto = 0};

get_arcana_lv(125,1,1) ->
	#base_arcana_lv{id = 125,career = 1,lv = 1,condition = [{arcana,121,1},{arcana_lv,20},{cost,[{0,7801012,1}]}],skill_id = 480125,skill_lv = 1,is_auto = 0};

get_arcana_lv(125,1,2) ->
	#base_arcana_lv{id = 125,career = 1,lv = 2,condition = [{cost,[{0,7802001,1}]}],skill_id = 480125,skill_lv = 2,is_auto = 0};

get_arcana_lv(125,1,3) ->
	#base_arcana_lv{id = 125,career = 1,lv = 3,condition = [{cost,[{0,7802001,1}]}],skill_id = 480125,skill_lv = 3,is_auto = 0};

get_arcana_lv(125,1,4) ->
	#base_arcana_lv{id = 125,career = 1,lv = 4,condition = [{cost,[{0,7802001,1}]}],skill_id = 480125,skill_lv = 4,is_auto = 0};

get_arcana_lv(125,1,5) ->
	#base_arcana_lv{id = 125,career = 1,lv = 5,condition = [{cost,[{0,7802001,1}]}],skill_id = 480125,skill_lv = 5,is_auto = 0};

get_arcana_lv(201,2,1) ->
	#base_arcana_lv{id = 201,career = 2,lv = 1,condition = [{pre_skill,200101,2}],skill_id = 200101,skill_lv = 2,is_auto = 1};

get_arcana_lv(201,2,2) ->
	#base_arcana_lv{id = 201,career = 2,lv = 2,condition = [{cost,[{0,7802001,1}]}],skill_id = 200101,skill_lv = 3,is_auto = 0};

get_arcana_lv(201,2,3) ->
	#base_arcana_lv{id = 201,career = 2,lv = 3,condition = [{cost,[{0,7802001,1}]}],skill_id = 200101,skill_lv = 4,is_auto = 0};

get_arcana_lv(201,2,4) ->
	#base_arcana_lv{id = 201,career = 2,lv = 4,condition = [{cost,[{0,7802001,1}]}],skill_id = 200101,skill_lv = 5,is_auto = 0};

get_arcana_lv(202,2,1) ->
	#base_arcana_lv{id = 202,career = 2,lv = 1,condition = [{pre_skill,200201,2}],skill_id = 200201,skill_lv = 2,is_auto = 1};

get_arcana_lv(202,2,2) ->
	#base_arcana_lv{id = 202,career = 2,lv = 2,condition = [{cost,[{0,7802001,1}]}],skill_id = 200201,skill_lv = 3,is_auto = 0};

get_arcana_lv(202,2,3) ->
	#base_arcana_lv{id = 202,career = 2,lv = 3,condition = [{cost,[{0,7802001,1}]}],skill_id = 200201,skill_lv = 4,is_auto = 0};

get_arcana_lv(202,2,4) ->
	#base_arcana_lv{id = 202,career = 2,lv = 4,condition = [{cost,[{0,7802001,1}]}],skill_id = 200201,skill_lv = 5,is_auto = 0};

get_arcana_lv(203,2,1) ->
	#base_arcana_lv{id = 203,career = 2,lv = 1,condition = [{pre_skill,200301,2}],skill_id = 200301,skill_lv = 2,is_auto = 1};

get_arcana_lv(203,2,2) ->
	#base_arcana_lv{id = 203,career = 2,lv = 2,condition = [{cost,[{0,7802001,1}]}],skill_id = 200301,skill_lv = 3,is_auto = 0};

get_arcana_lv(203,2,3) ->
	#base_arcana_lv{id = 203,career = 2,lv = 3,condition = [{cost,[{0,7802001,1}]}],skill_id = 200301,skill_lv = 4,is_auto = 0};

get_arcana_lv(203,2,4) ->
	#base_arcana_lv{id = 203,career = 2,lv = 4,condition = [{cost,[{0,7802001,1}]}],skill_id = 200301,skill_lv = 5,is_auto = 0};

get_arcana_lv(204,2,1) ->
	#base_arcana_lv{id = 204,career = 2,lv = 1,condition = [{pre_skill,200401,2}],skill_id = 200401,skill_lv = 2,is_auto = 1};

get_arcana_lv(204,2,2) ->
	#base_arcana_lv{id = 204,career = 2,lv = 2,condition = [{cost,[{0,7802001,1}]}],skill_id = 200401,skill_lv = 3,is_auto = 0};

get_arcana_lv(204,2,3) ->
	#base_arcana_lv{id = 204,career = 2,lv = 3,condition = [{cost,[{0,7802001,1}]}],skill_id = 200401,skill_lv = 4,is_auto = 0};

get_arcana_lv(204,2,4) ->
	#base_arcana_lv{id = 204,career = 2,lv = 4,condition = [{cost,[{0,7802001,1}]}],skill_id = 200401,skill_lv = 5,is_auto = 0};

get_arcana_lv(205,2,1) ->
	#base_arcana_lv{id = 205,career = 2,lv = 1,condition = [{pre_skill,200501,2}],skill_id = 200501,skill_lv = 2,is_auto = 1};

get_arcana_lv(205,2,2) ->
	#base_arcana_lv{id = 205,career = 2,lv = 2,condition = [{cost,[{0,7802001,1}]}],skill_id = 200501,skill_lv = 3,is_auto = 0};

get_arcana_lv(205,2,3) ->
	#base_arcana_lv{id = 205,career = 2,lv = 3,condition = [{cost,[{0,7802001,1}]}],skill_id = 200501,skill_lv = 4,is_auto = 0};

get_arcana_lv(205,2,4) ->
	#base_arcana_lv{id = 205,career = 2,lv = 4,condition = [{cost,[{0,7802001,1}]}],skill_id = 200501,skill_lv = 5,is_auto = 0};

get_arcana_lv(205,2,5) ->
	#base_arcana_lv{id = 205,career = 2,lv = 5,condition = [{cost,[{0,7802001,1}]}],skill_id = 200501,skill_lv = 6,is_auto = 0};

get_arcana_lv(206,2,1) ->
	#base_arcana_lv{id = 206,career = 2,lv = 1,condition = [{pre_skill,200601,2}],skill_id = 200601,skill_lv = 2,is_auto = 1};

get_arcana_lv(206,2,2) ->
	#base_arcana_lv{id = 206,career = 2,lv = 2,condition = [{cost,[{0,7802001,1}]}],skill_id = 200601,skill_lv = 3,is_auto = 0};

get_arcana_lv(206,2,3) ->
	#base_arcana_lv{id = 206,career = 2,lv = 3,condition = [{cost,[{0,7802001,1}]}],skill_id = 200601,skill_lv = 4,is_auto = 0};

get_arcana_lv(206,2,4) ->
	#base_arcana_lv{id = 206,career = 2,lv = 4,condition = [{cost,[{0,7802001,1}]}],skill_id = 200601,skill_lv = 5,is_auto = 0};

get_arcana_lv(206,2,5) ->
	#base_arcana_lv{id = 206,career = 2,lv = 5,condition = [{cost,[{0,7802001,1}]}],skill_id = 200601,skill_lv = 6,is_auto = 0};

get_arcana_lv(207,2,1) ->
	#base_arcana_lv{id = 207,career = 2,lv = 1,condition = [{cost,[{0,7801001,1}]}],skill_id = 480107,skill_lv = 1,is_auto = 0};

get_arcana_lv(207,2,2) ->
	#base_arcana_lv{id = 207,career = 2,lv = 2,condition = [{cost,[{0,7802001,1}]}],skill_id = 480107,skill_lv = 2,is_auto = 0};

get_arcana_lv(207,2,3) ->
	#base_arcana_lv{id = 207,career = 2,lv = 3,condition = [{cost,[{0,7802001,1}]}],skill_id = 480107,skill_lv = 3,is_auto = 0};

get_arcana_lv(207,2,4) ->
	#base_arcana_lv{id = 207,career = 2,lv = 4,condition = [{cost,[{0,7802001,1}]}],skill_id = 480107,skill_lv = 4,is_auto = 0};

get_arcana_lv(208,2,1) ->
	#base_arcana_lv{id = 208,career = 2,lv = 1,condition = [{cost,[{0,7801002,1}]}],skill_id = 480108,skill_lv = 1,is_auto = 0};

get_arcana_lv(208,2,2) ->
	#base_arcana_lv{id = 208,career = 2,lv = 2,condition = [{cost,[{0,7802001,1}]}],skill_id = 480108,skill_lv = 2,is_auto = 0};

get_arcana_lv(208,2,3) ->
	#base_arcana_lv{id = 208,career = 2,lv = 3,condition = [{cost,[{0,7802001,1}]}],skill_id = 480108,skill_lv = 3,is_auto = 0};

get_arcana_lv(208,2,4) ->
	#base_arcana_lv{id = 208,career = 2,lv = 4,condition = [{cost,[{0,7802001,1}]}],skill_id = 480108,skill_lv = 4,is_auto = 0};

get_arcana_lv(211,2,1) ->
	#base_arcana_lv{id = 211,career = 2,lv = 1,condition = [{arcana,207,1},{arcana_lv,9},{cost,[{0,7801003,1}]}],skill_id = 480111,skill_lv = 1,is_auto = 0};

get_arcana_lv(211,2,2) ->
	#base_arcana_lv{id = 211,career = 2,lv = 2,condition = [{cost,[{0,7802001,1}]}],skill_id = 480111,skill_lv = 2,is_auto = 0};

get_arcana_lv(211,2,3) ->
	#base_arcana_lv{id = 211,career = 2,lv = 3,condition = [{cost,[{0,7802001,1}]}],skill_id = 480111,skill_lv = 3,is_auto = 0};

get_arcana_lv(211,2,4) ->
	#base_arcana_lv{id = 211,career = 2,lv = 4,condition = [{cost,[{0,7802001,1}]}],skill_id = 480111,skill_lv = 4,is_auto = 0};

get_arcana_lv(211,2,5) ->
	#base_arcana_lv{id = 211,career = 2,lv = 5,condition = [{cost,[{0,7802001,1}]}],skill_id = 480111,skill_lv = 5,is_auto = 0};

get_arcana_lv(212,2,1) ->
	#base_arcana_lv{id = 212,career = 2,lv = 1,condition = [{arcana,211,1},{arcana_lv,9},{cost,[{0,7801007,1}]}],skill_id = 480212,skill_lv = 1,is_auto = 0};

get_arcana_lv(212,2,2) ->
	#base_arcana_lv{id = 212,career = 2,lv = 2,condition = [{cost,[{0,7802001,1}]}],skill_id = 480212,skill_lv = 2,is_auto = 0};

get_arcana_lv(212,2,3) ->
	#base_arcana_lv{id = 212,career = 2,lv = 3,condition = [{cost,[{0,7802001,1}]}],skill_id = 480212,skill_lv = 3,is_auto = 0};

get_arcana_lv(212,2,4) ->
	#base_arcana_lv{id = 212,career = 2,lv = 4,condition = [{cost,[{0,7802001,1}]}],skill_id = 480212,skill_lv = 4,is_auto = 0};

get_arcana_lv(212,2,5) ->
	#base_arcana_lv{id = 212,career = 2,lv = 5,condition = [{cost,[{0,7802001,1}]}],skill_id = 480212,skill_lv = 5,is_auto = 0};

get_arcana_lv(213,2,1) ->
	#base_arcana_lv{id = 213,career = 2,lv = 1,condition = [{arcana,211,1},{arcana_lv,9},{cost,[{0,7801008,1}]}],skill_id = 480213,skill_lv = 1,is_auto = 0};

get_arcana_lv(213,2,2) ->
	#base_arcana_lv{id = 213,career = 2,lv = 2,condition = [{cost,[{0,7802001,1}]}],skill_id = 480213,skill_lv = 2,is_auto = 0};

get_arcana_lv(213,2,3) ->
	#base_arcana_lv{id = 213,career = 2,lv = 3,condition = [{cost,[{0,7802001,1}]}],skill_id = 480213,skill_lv = 3,is_auto = 0};

get_arcana_lv(213,2,4) ->
	#base_arcana_lv{id = 213,career = 2,lv = 4,condition = [{cost,[{0,7802001,1}]}],skill_id = 480213,skill_lv = 4,is_auto = 0};

get_arcana_lv(213,2,5) ->
	#base_arcana_lv{id = 213,career = 2,lv = 5,condition = [{cost,[{0,7802001,1}]}],skill_id = 480213,skill_lv = 5,is_auto = 0};

get_arcana_lv(214,2,1) ->
	#base_arcana_lv{id = 214,career = 2,lv = 1,condition = [{arcana,211,1},{arcana_lv,20},{cost,[{0,7801005,1}]}],skill_id = 480114,skill_lv = 1,is_auto = 0};

get_arcana_lv(214,2,2) ->
	#base_arcana_lv{id = 214,career = 2,lv = 2,condition = [{cost,[{0,7802001,1}]}],skill_id = 480114,skill_lv = 2,is_auto = 0};

get_arcana_lv(214,2,3) ->
	#base_arcana_lv{id = 214,career = 2,lv = 3,condition = [{cost,[{0,7802001,1}]}],skill_id = 480114,skill_lv = 3,is_auto = 0};

get_arcana_lv(214,2,4) ->
	#base_arcana_lv{id = 214,career = 2,lv = 4,condition = [{cost,[{0,7802001,1}]}],skill_id = 480114,skill_lv = 4,is_auto = 0};

get_arcana_lv(214,2,5) ->
	#base_arcana_lv{id = 214,career = 2,lv = 5,condition = [{cost,[{0,7802001,1}]}],skill_id = 480114,skill_lv = 5,is_auto = 0};

get_arcana_lv(215,2,1) ->
	#base_arcana_lv{id = 215,career = 2,lv = 1,condition = [{arcana,211,1},{arcana_lv,20},{cost,[{0,7801011,1}]}],skill_id = 480215,skill_lv = 1,is_auto = 0};

get_arcana_lv(215,2,2) ->
	#base_arcana_lv{id = 215,career = 2,lv = 2,condition = [{cost,[{0,7802001,1}]}],skill_id = 480215,skill_lv = 2,is_auto = 0};

get_arcana_lv(215,2,3) ->
	#base_arcana_lv{id = 215,career = 2,lv = 3,condition = [{cost,[{0,7802001,1}]}],skill_id = 480215,skill_lv = 3,is_auto = 0};

get_arcana_lv(215,2,4) ->
	#base_arcana_lv{id = 215,career = 2,lv = 4,condition = [{cost,[{0,7802001,1}]}],skill_id = 480215,skill_lv = 4,is_auto = 0};

get_arcana_lv(215,2,5) ->
	#base_arcana_lv{id = 215,career = 2,lv = 5,condition = [{cost,[{0,7802001,1}]}],skill_id = 480215,skill_lv = 5,is_auto = 0};

get_arcana_lv(221,2,1) ->
	#base_arcana_lv{id = 221,career = 2,lv = 1,condition = [{arcana,208,1},{arcana_lv,9},{cost,[{0,7801004,1}]}],skill_id = 480121,skill_lv = 1,is_auto = 0};

get_arcana_lv(221,2,2) ->
	#base_arcana_lv{id = 221,career = 2,lv = 2,condition = [{cost,[{0,7802001,1}]}],skill_id = 480121,skill_lv = 2,is_auto = 0};

get_arcana_lv(221,2,3) ->
	#base_arcana_lv{id = 221,career = 2,lv = 3,condition = [{cost,[{0,7802001,1}]}],skill_id = 480121,skill_lv = 3,is_auto = 0};

get_arcana_lv(221,2,4) ->
	#base_arcana_lv{id = 221,career = 2,lv = 4,condition = [{cost,[{0,7802001,1}]}],skill_id = 480121,skill_lv = 4,is_auto = 0};

get_arcana_lv(221,2,5) ->
	#base_arcana_lv{id = 221,career = 2,lv = 5,condition = [{cost,[{0,7802001,1}]}],skill_id = 480121,skill_lv = 5,is_auto = 0};

get_arcana_lv(222,2,1) ->
	#base_arcana_lv{id = 222,career = 2,lv = 1,condition = [{arcana,221,1},{arcana_lv,9},{cost,[{0,7801009,1}]}],skill_id = 480222,skill_lv = 1,is_auto = 0};

get_arcana_lv(222,2,2) ->
	#base_arcana_lv{id = 222,career = 2,lv = 2,condition = [{cost,[{0,7802001,1}]}],skill_id = 480222,skill_lv = 2,is_auto = 0};

get_arcana_lv(222,2,3) ->
	#base_arcana_lv{id = 222,career = 2,lv = 3,condition = [{cost,[{0,7802001,1}]}],skill_id = 480222,skill_lv = 3,is_auto = 0};

get_arcana_lv(222,2,4) ->
	#base_arcana_lv{id = 222,career = 2,lv = 4,condition = [{cost,[{0,7802001,1}]}],skill_id = 480222,skill_lv = 4,is_auto = 0};

get_arcana_lv(222,2,5) ->
	#base_arcana_lv{id = 222,career = 2,lv = 5,condition = [{cost,[{0,7802001,1}]}],skill_id = 480222,skill_lv = 5,is_auto = 0};

get_arcana_lv(223,2,1) ->
	#base_arcana_lv{id = 223,career = 2,lv = 1,condition = [{arcana,221,1},{arcana_lv,9},{cost,[{0,7801010,1}]}],skill_id = 480223,skill_lv = 1,is_auto = 0};

get_arcana_lv(223,2,2) ->
	#base_arcana_lv{id = 223,career = 2,lv = 2,condition = [{cost,[{0,7802001,1}]}],skill_id = 480223,skill_lv = 2,is_auto = 0};

get_arcana_lv(223,2,3) ->
	#base_arcana_lv{id = 223,career = 2,lv = 3,condition = [{cost,[{0,7802001,1}]}],skill_id = 480223,skill_lv = 3,is_auto = 0};

get_arcana_lv(223,2,4) ->
	#base_arcana_lv{id = 223,career = 2,lv = 4,condition = [{cost,[{0,7802001,1}]}],skill_id = 480223,skill_lv = 4,is_auto = 0};

get_arcana_lv(223,2,5) ->
	#base_arcana_lv{id = 223,career = 2,lv = 5,condition = [{cost,[{0,7802001,1}]}],skill_id = 480223,skill_lv = 5,is_auto = 0};

get_arcana_lv(224,2,1) ->
	#base_arcana_lv{id = 224,career = 2,lv = 1,condition = [{arcana,221,1},{arcana_lv,20},{cost,[{0,7801006,1}]}],skill_id = 480124,skill_lv = 1,is_auto = 0};

get_arcana_lv(224,2,2) ->
	#base_arcana_lv{id = 224,career = 2,lv = 2,condition = [{cost,[{0,7802001,1}]}],skill_id = 480124,skill_lv = 2,is_auto = 0};

get_arcana_lv(224,2,3) ->
	#base_arcana_lv{id = 224,career = 2,lv = 3,condition = [{cost,[{0,7802001,1}]}],skill_id = 480124,skill_lv = 3,is_auto = 0};

get_arcana_lv(224,2,4) ->
	#base_arcana_lv{id = 224,career = 2,lv = 4,condition = [{cost,[{0,7802001,1}]}],skill_id = 480124,skill_lv = 4,is_auto = 0};

get_arcana_lv(224,2,5) ->
	#base_arcana_lv{id = 224,career = 2,lv = 5,condition = [{cost,[{0,7802001,1}]}],skill_id = 480124,skill_lv = 5,is_auto = 0};

get_arcana_lv(225,2,1) ->
	#base_arcana_lv{id = 225,career = 2,lv = 1,condition = [{arcana,221,1},{arcana_lv,20},{cost,[{0,7801012,1}]}],skill_id = 480225,skill_lv = 1,is_auto = 0};

get_arcana_lv(225,2,2) ->
	#base_arcana_lv{id = 225,career = 2,lv = 2,condition = [{cost,[{0,7802001,1}]}],skill_id = 480225,skill_lv = 2,is_auto = 0};

get_arcana_lv(225,2,3) ->
	#base_arcana_lv{id = 225,career = 2,lv = 3,condition = [{cost,[{0,7802001,1}]}],skill_id = 480225,skill_lv = 3,is_auto = 0};

get_arcana_lv(225,2,4) ->
	#base_arcana_lv{id = 225,career = 2,lv = 4,condition = [{cost,[{0,7802001,1}]}],skill_id = 480225,skill_lv = 4,is_auto = 0};

get_arcana_lv(225,2,5) ->
	#base_arcana_lv{id = 225,career = 2,lv = 5,condition = [{cost,[{0,7802001,1}]}],skill_id = 480225,skill_lv = 5,is_auto = 0};

get_arcana_lv(_Id,_Career,_Lv) ->
	[].


get_arcana_lv_list(1) ->
[{101,1},{101,2},{101,3},{101,4},{102,1},{102,2},{102,3},{102,4},{103,1},{103,2},{103,3},{103,4},{104,1},{104,2},{104,3},{104,4},{105,1},{105,2},{105,3},{105,4},{105,5},{106,1},{106,2},{106,3},{106,4},{106,5},{107,1},{107,2},{107,3},{107,4},{108,1},{108,2},{108,3},{108,4},{111,1},{111,2},{111,3},{111,4},{111,5},{112,1},{112,2},{112,3},{112,4},{112,5},{113,1},{113,2},{113,3},{113,4},{113,5},{114,1},{114,2},{114,3},{114,4},{114,5},{115,1},{115,2},{115,3},{115,4},{115,5},{121,1},{121,2},{121,3},{121,4},{121,5},{122,1},{122,2},{122,3},{122,4},{122,5},{123,1},{123,2},{123,3},{123,4},{123,5},{124,1},{124,2},{124,3},{124,4},{124,5},{125,1},{125,2},{125,3},{125,4},{125,5}];


get_arcana_lv_list(2) ->
[{201,1},{201,2},{201,3},{201,4},{202,1},{202,2},{202,3},{202,4},{203,1},{203,2},{203,3},{203,4},{204,1},{204,2},{204,3},{204,4},{205,1},{205,2},{205,3},{205,4},{205,5},{206,1},{206,2},{206,3},{206,4},{206,5},{207,1},{207,2},{207,3},{207,4},{208,1},{208,2},{208,3},{208,4},{211,1},{211,2},{211,3},{211,4},{211,5},{212,1},{212,2},{212,3},{212,4},{212,5},{213,1},{213,2},{213,3},{213,4},{213,5},{214,1},{214,2},{214,3},{214,4},{214,5},{215,1},{215,2},{215,3},{215,4},{215,5},{221,1},{221,2},{221,3},{221,4},{221,5},{222,1},{222,2},{222,3},{222,4},{222,5},{223,1},{223,2},{223,3},{223,4},{223,5},{224,1},{224,2},{224,3},{224,4},{224,5},{225,1},{225,2},{225,3},{225,4},{225,5}];

get_arcana_lv_list(_Career) ->
	[].

get_arcana_break(102,1,1) ->
	#base_arcana_break{id = 102,career = 1,break_lv = 1,condition = [{cost,[{0,7803003,1}]}],skill_id = 100201,break_skill_id = 481102,desc = "继承<font color=#639c12>穿刺之刃</font>技能效果，并额外提升<font color=#639c12>大量技能伤害，输出拉满！</font>"};

get_arcana_break(103,1,1) ->
	#base_arcana_break{id = 103,career = 1,break_lv = 1,condition = [{cost,[{0,7803004,1}]}],skill_id = 100301,break_skill_id = 481103,desc = "继承<font color=#639c12>烈焰冲击</font>技能效果，并对敌人造成<font color=#639c12>额外的能伤害，伤害爆表！</font>"};

get_arcana_break(104,1,1) ->
	#base_arcana_break{id = 104,career = 1,break_lv = 1,condition = [{cost,[{0,7803005,1}]}],skill_id = 100401,break_skill_id = 481104,desc = "继承<font color=#639c12>雷赦风云破</font>技能效果，并额外<font color=#639c12>增加攻击目标，超强群攻！</font>"};

get_arcana_break(107,1,1) ->
	#base_arcana_break{id = 107,career = 1,break_lv = 1,condition = [{cost,[{0,7803001,1}]}],skill_id = 480107,break_skill_id = 481107,desc = "学习后替换<font color=#639c12>天神下凡</font>为<font color=#639c12>真·天神下凡</font>，触发时额外<font color=#639c12>提升攻击，技能蜕变，超强效果</font>"};

get_arcana_break(108,1,1) ->
	#base_arcana_break{id = 108,career = 1,break_lv = 1,condition = [{cost,[{0,7803002,1}]}],skill_id = 480108,break_skill_id = 481108,desc = "学习后替换<font color=#639c12>流血致残</font>为<font color=#639c12>真·流血致残</font>，极大地<font color=#639c12>提高流血概率和造成的流血伤害，技能蜕变，超强效果</font>"};

get_arcana_break(202,2,1) ->
	#base_arcana_break{id = 202,career = 2,break_lv = 1,condition = [{cost,[{0,7803006,1}]}],skill_id = 200201,break_skill_id = 481202,desc = "继承<font color=#639c12>疾速射击</font>技能效果，并额外提升<font color=#639c12>大量技能伤害，输出拉满！</font>"};

get_arcana_break(203,2,1) ->
	#base_arcana_break{id = 203,career = 2,break_lv = 1,condition = [{cost,[{0,7803007,1}]}],skill_id = 200301,break_skill_id = 481203,desc = "继承<font color=#639c12>冰封千里</font>技能效果，并对敌人造成<font color=#639c12>额外的能伤害，伤害爆表！</font>"};

get_arcana_break(204,2,1) ->
	#base_arcana_break{id = 204,career = 2,break_lv = 1,condition = [{cost,[{0,7803008,1}]}],skill_id = 200401,break_skill_id = 481204,desc = "继承<font color=#639c12>猎手本能</font>技能效果，并额外<font color=#639c12>增加攻击目标，超强群攻！</font>"};

get_arcana_break(207,2,1) ->
	#base_arcana_break{id = 207,career = 2,break_lv = 1,condition = [{cost,[{0,7803001,1}]}],skill_id = 480107,break_skill_id = 481107,desc = "学习后替换<font color=#639c12>天神下凡</font>为<font color=#639c12>真·天神下凡</font>，触发时额外<font color=#639c12>提升攻击，技能蜕变，超强效果</font>"};

get_arcana_break(208,2,1) ->
	#base_arcana_break{id = 208,career = 2,break_lv = 1,condition = [{cost,[{0,7803002,1}]}],skill_id = 480108,break_skill_id = 481108,desc = "学习后替换<font color=#639c12>流血致残</font>为<font color=#639c12>真·流血致残</font>，极大地<font color=#639c12>提高流血概率和造成的流血伤害，技能蜕变，超强效果</font>"};

get_arcana_break(_Id,_Career,_Breaklv) ->
	[].

get_arcana(101) ->
	#base_arcana{id = 101,career = 1,is_core = 0,core_type = 0,pos = 1,max_lv = 4,max_break_lv = 0,desc = "骑士挥动武器对圆形范围内的敌人造成伤害"};

get_arcana(102) ->
	#base_arcana{id = 102,career = 1,is_core = 0,core_type = 0,pos = 2,max_lv = 4,max_break_lv = 1,desc = "骑士向前刺击发出巨型的尖刺气流，对直线范围内的敌人造成伤害"};

get_arcana(103) ->
	#base_arcana{id = 103,career = 1,is_core = 0,core_type = 0,pos = 3,max_lv = 4,max_break_lv = 1,desc = "骑士向前挥击武器并溅射出烈焰，对前方扇形范围内的敌人造成伤害"};

get_arcana(104) ->
	#base_arcana{id = 104,career = 1,is_core = 0,core_type = 0,pos = 5,max_lv = 4,max_break_lv = 1,desc = "骑士召唤雷电下落，对前方扇形范围内的敌人造成伤害"};

get_arcana(105) ->
	#base_arcana{id = 105,career = 1,is_core = 0,core_type = 0,pos = 6,max_lv = 5,max_break_lv = 0,desc = "骑士以自身为圆心形成圆形烈焰圈,对圆形范围内的敌人造成伤害"};

get_arcana(106) ->
	#base_arcana{id = 106,career = 1,is_core = 0,core_type = 0,pos = 7,max_lv = 5,max_break_lv = 0,desc = "骑士向四方发出强力剑气冲击，对圆形范围内的敌人造成伤害"};

get_arcana(107) ->
	#base_arcana{id = 107,career = 1,is_core = 0,core_type = 0,pos = 4,max_lv = 4,max_break_lv = 1,desc = "受到天神的帮助，使玩家每次攻击时都有概率附加神力在自己身上，增加攻击力"};

get_arcana(108) ->
	#base_arcana{id = 108,career = 1,is_core = 0,core_type = 0,pos = 8,max_lv = 4,max_break_lv = 1,desc = "受到古老的黑魔法影响，攻击时都有概率使对手陷入流血致残状态，对其造成伤害"};

get_arcana(111) ->
	#base_arcana{id = 111,career = 1,is_core = 1,core_type = 1,pos = 2,max_lv = 5,max_break_lv = 0,desc = "天神下凡状态下极大地减少自身受到的伤害，并有概率回复自身生命"};

get_arcana(112) ->
	#base_arcana{id = 112,career = 1,is_core = 1,core_type = 1,pos = 1,max_lv = 5,max_break_lv = 0,desc = "传说中可毁灭一切的奥术，对敌人造成伤害同时吸收伤害恢复自身已损失血量"};

get_arcana(113) ->
	#base_arcana{id = 113,career = 1,is_core = 1,core_type = 1,pos = 3,max_lv = 5,max_break_lv = 0,desc = "闪着金色光芒的力量之手，对敌人造成伤害同时极大提升格挡能力"};

get_arcana(114) ->
	#base_arcana{id = 114,career = 1,is_core = 1,core_type = 1,pos = 4,max_lv = 5,max_break_lv = 0,desc = "领悟时间真谛，极大减少各技能的冷却时间，并有概率刷新天神下凡的冷却时间"};

get_arcana(115) ->
	#base_arcana{id = 115,career = 1,is_core = 1,core_type = 1,pos = 5,max_lv = 5,max_break_lv = 0,desc = "湮灭一切摧毁所有，对目标造成大量技能伤害并概率使其无法移动"};

get_arcana(121) ->
	#base_arcana{id = 121,career = 1,is_core = 1,core_type = 2,pos = 2,max_lv = 5,max_break_lv = 0,desc = "将鲜血凝聚成护盾包围自身，抵挡对方的攻击同时提高自身造成伤害"};

get_arcana(122) ->
	#base_arcana{id = 122,career = 1,is_core = 1,core_type = 2,pos = 1,max_lv = 5,max_break_lv = 0,desc = "撕裂对方身体并进行吞噬，对流血致残的目标造成更可怕的伤害"};

get_arcana(123) ->
	#base_arcana{id = 123,career = 1,is_core = 1,core_type = 2,pos = 3,max_lv = 5,max_break_lv = 0,desc = "对目标造成伤害后放空身体，极大地提高闪避，成功闪避后概率回复生命"};

get_arcana(124) ->
	#base_arcana{id = 124,career = 1,is_core = 1,core_type = 2,pos = 4,max_lv = 5,max_break_lv = 0,desc = "精通流血，极大地提高流血造成的伤害和持续时间"};

get_arcana(125) ->
	#base_arcana{id = 125,career = 1,is_core = 1,core_type = 2,pos = 5,max_lv = 5,max_break_lv = 0,desc = "燃烧目标身体的血液，对其造成巨大技能伤害并且概率使其无法移动一段时间"};

get_arcana(201) ->
	#base_arcana{id = 201,career = 2,is_core = 0,core_type = 0,pos = 1,max_lv = 4,max_break_lv = 0,desc = "弓箭手向前发射箭矢，对直线范围内的敌人造成伤害"};

get_arcana(202) ->
	#base_arcana{id = 202,career = 2,is_core = 0,core_type = 0,pos = 2,max_lv = 4,max_break_lv = 1,desc = "弓箭手向前发出烈焰箭矢,对扇形范围内的敌人造成伤害"};

get_arcana(203) ->
	#base_arcana{id = 203,career = 2,is_core = 0,core_type = 0,pos = 3,max_lv = 4,max_break_lv = 1,desc = "弓箭手向前发出冰刺，对直线范围内的敌人造成伤害"};

get_arcana(204) ->
	#base_arcana{id = 204,career = 2,is_core = 0,core_type = 0,pos = 5,max_lv = 4,max_break_lv = 1,desc = "弓箭手向前连续发射出箭矢，对直线范围内的敌人造成伤害"};

get_arcana(205) ->
	#base_arcana{id = 205,career = 2,is_core = 0,core_type = 0,pos = 6,max_lv = 5,max_break_lv = 0,desc = "弓箭手向前方发射出若干支寒冰箭矢，对扇形范围内的敌人造成伤害"};

get_arcana(206) ->
	#base_arcana{id = 206,career = 2,is_core = 0,core_type = 0,pos = 7,max_lv = 5,max_break_lv = 0,desc = "弓箭手召唤箭雨下落，对圆形范围内的敌人造成伤害"};

get_arcana(207) ->
	#base_arcana{id = 207,career = 2,is_core = 0,core_type = 0,pos = 4,max_lv = 4,max_break_lv = 1,desc = "受到天神的帮助，使玩家每次攻击时都有概率附加神力在自己身上，增加攻击力"};

get_arcana(208) ->
	#base_arcana{id = 208,career = 2,is_core = 0,core_type = 0,pos = 8,max_lv = 4,max_break_lv = 1,desc = "受到古老的黑魔法影响，攻击时都有概率使对手陷入流血致残状态，对其造成伤害"};

get_arcana(211) ->
	#base_arcana{id = 211,career = 2,is_core = 1,core_type = 1,pos = 2,max_lv = 5,max_break_lv = 0,desc = "天神下凡状态下极大地减少自身受到的伤害，并有概率回复自身生命"};

get_arcana(212) ->
	#base_arcana{id = 212,career = 2,is_core = 1,core_type = 1,pos = 1,max_lv = 5,max_break_lv = 0,desc = "传说中可毁灭一切的奥术，对敌人造成伤害同时吸收伤害恢复自身已损失血量"};

get_arcana(213) ->
	#base_arcana{id = 213,career = 2,is_core = 1,core_type = 1,pos = 3,max_lv = 5,max_break_lv = 0,desc = "闪着金色光芒的力量之手，对敌人造成伤害同时极大提升格挡能力"};

get_arcana(214) ->
	#base_arcana{id = 214,career = 2,is_core = 1,core_type = 1,pos = 4,max_lv = 5,max_break_lv = 0,desc = "领悟时间真谛，极大减少各技能的冷却时间，并有概率刷新天神下凡的冷却时间"};

get_arcana(215) ->
	#base_arcana{id = 215,career = 2,is_core = 1,core_type = 1,pos = 5,max_lv = 5,max_break_lv = 0,desc = "湮灭一切摧毁所有，对目标造成大量技能伤害并概率使其无法移动"};

get_arcana(221) ->
	#base_arcana{id = 221,career = 2,is_core = 1,core_type = 2,pos = 2,max_lv = 5,max_break_lv = 0,desc = "将鲜血凝聚成护盾包围自身，抵挡对方的攻击同时提高自身造成伤害"};

get_arcana(222) ->
	#base_arcana{id = 222,career = 2,is_core = 1,core_type = 2,pos = 1,max_lv = 5,max_break_lv = 0,desc = "撕裂对方身体吞噬其身上的流血效果，流血层数越多造成的伤害越高"};

get_arcana(223) ->
	#base_arcana{id = 223,career = 2,is_core = 1,core_type = 2,pos = 3,max_lv = 5,max_break_lv = 0,desc = "对目标造成伤害后放空身体，极大地提高闪避，成功闪避后概率回复生命"};

get_arcana(224) ->
	#base_arcana{id = 224,career = 2,is_core = 1,core_type = 2,pos = 4,max_lv = 5,max_break_lv = 0,desc = "精通流血，极大地提高流血造成的伤害和持续时间"};

get_arcana(225) ->
	#base_arcana{id = 225,career = 2,is_core = 1,core_type = 2,pos = 5,max_lv = 5,max_break_lv = 0,desc = "燃烧目标身体的血液，对其造成巨大技能伤害并且概率使其无法移动一段时间"};

get_arcana(_Id) ->
	[].

get_arcana_core_type(1,0) ->
[0];

get_arcana_core_type(1,1) ->
[1,2];

get_arcana_core_type(2,0) ->
[0];

get_arcana_core_type(2,1) ->
[1,2];

get_arcana_core_type(_Career,_Iscore) ->
	[].


get_arcana_id_list(1) ->
[101,102,103,104,105,106,107,108,111,112,113,114,115,121,122,123,124,125];


get_arcana_id_list(2) ->
[201,202,203,204,205,206,207,208,211,212,213,214,215,221,222,223,224,225];

get_arcana_id_list(_Career) ->
	[].


get_kv(1) ->
470;


get_kv(2) ->
30;

get_kv(_Key) ->
	[].

