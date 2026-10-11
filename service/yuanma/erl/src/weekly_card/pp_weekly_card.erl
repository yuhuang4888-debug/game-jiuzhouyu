%%% -------------------------------------------------------------------
%%% @doc        pp_weekly_card                 
%%% @author     lwc                      
%%% @email      liuweichao@suyougame.com
%%% @since      2022-03-21 11:01               
%%% @deprecated 周卡控制层
%%% -------------------------------------------------------------------

-module(pp_weekly_card).
%% API
-export([handle/3]).

handle(Cmd, PS, Data) ->
    do_handle(Cmd, PS, Data).

%% -----------------------------------------------------------------
%% @desc 发送周卡信息
%% @param
%% @return
%% -----------------------------------------------------------------
do_handle(45201, PS, []) ->
    lib_weekly_card:send_weekly_card_info(PS);

%% -----------------------------------------------------------------
%% @desc 一键领取礼包
%% @param
%% @return
%% -----------------------------------------------------------------
do_handle(45202, PS, []) ->
    lib_weekly_card:receive_gift_bag(PS);

%% -----------------------------------------------------------------
%% @desc 发送未激活周卡补发奖励
%% @param
%% @return
%% -----------------------------------------------------------------
do_handle(45203, PS, []) ->
    lib_weekly_card:send_reward_list(PS);

%% 容错
do_handle(_, _, _) ->
    {error, "Illegal protocol~n"}.