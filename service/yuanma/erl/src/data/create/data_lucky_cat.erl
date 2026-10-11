%%%---------------------------------------
%%% @Module  : data_lucky_cat
%%% @Description : 招财猫配置
%%%
%%%---------------------------------------
-module(data_lucky_cat).
-compile(export_all).
-include("lucky_cat.hrl").



get_input(1) ->
    #input_cost{id = 1,cost = 88};

get_input(2) ->
    #input_cost{id = 2,cost = 128};

get_input(3) ->
    #input_cost{id = 3,cost = 168};

get_input(4) ->
    #input_cost{id = 4,cost = 208};

get_input(_Id) ->
    [].

get_input_list() ->
[1,2,3,4].

get_return(1) ->
    #input_return{id = 1,cost_id = 1,times = 1.1,ratio = 40,money_type = 1};

get_return(2) ->
    #input_return{id = 2,cost_id = 1,times = 1.2,ratio = 30,money_type = 1};

get_return(3) ->
    #input_return{id = 3,cost_id = 1,times = 1.3,ratio = 20,money_type = 1};

get_return(4) ->
    #input_return{id = 4,cost_id = 1,times = 2,ratio = 10,money_type = 2};

get_return(5) ->
    #input_return{id = 5,cost_id = 2,times = 1.1,ratio = 40,money_type = 2};

get_return(6) ->
    #input_return{id = 6,cost_id = 2,times = 1.2,ratio = 30,money_type = 1};

get_return(7) ->
    #input_return{id = 7,cost_id = 2,times = 1.3,ratio = 20,money_type = 1};

get_return(8) ->
    #input_return{id = 8,cost_id = 2,times = 2,ratio = 10,money_type = 1};

get_return(9) ->
    #input_return{id = 9,cost_id = 3,times = 1.1,ratio = 40,money_type = 1};

get_return(10) ->
    #input_return{id = 10,cost_id = 3,times = 1.2,ratio = 30,money_type = 2};

get_return(11) ->
    #input_return{id = 11,cost_id = 3,times = 1.3,ratio = 20,money_type = 1};

get_return(12) ->
    #input_return{id = 12,cost_id = 3,times = 2,ratio = 10,money_type = 1};

get_return(13) ->
    #input_return{id = 13,cost_id = 4,times = 1.1,ratio = 40,money_type = 1};

get_return(14) ->
    #input_return{id = 14,cost_id = 4,times = 1.2,ratio = 30,money_type = 1};

get_return(15) ->
    #input_return{id = 15,cost_id = 4,times = 1.3,ratio = 20,money_type = 2};

get_return(16) ->
    #input_return{id = 16,cost_id = 4,times = 2,ratio = 10,money_type = 1};

get_return(_Id) ->
    [].

get_ratio_list(1) ->
[{1,40},{2,30},{3,20},{4,10}];

get_ratio_list(2) ->
[{5,40},{6,30},{7,20},{8,10}];

get_ratio_list(3) ->
[{9,40},{10,30},{11,20},{12,10}];

get_ratio_list(4) ->
[{13,40},{14,30},{15,20},{16,10}];

get_ratio_list(_Costid) ->
    [].

