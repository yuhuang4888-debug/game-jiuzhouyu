%%%-----------------------------------
%%% @Module  : lib_kf_1vN_mgr
%%% @Email   : ming_up@foxmail.com
%%% @Created : 2018.1.24
%%% @Description: 跨服1vN 跨服中心库函数
%%%-----------------------------------
-module(lib_kf_1vN_mgr).

-include("common.hrl").
-include("record.hrl").
-include("server.hrl").
-include("scene.hrl").
-include("kf_1vN.hrl").

-export([
        load/0,
        db_save_sign/3,
        db_clean_sign/0
    ]).


load() ->
    #kf_1vN_info{
        all_time = #kf_1vN_time{},
        stage = ?KF_1VN_FREE,
        start_time = 0,
        end_time = 0,
        state = ?KF_1VN_STATE_WAIT
    }.


db_save_sign(ServerId, Id, Lv) -> 
    db:execute(io_lib:format(<<"replace into kf_1vn_sign_center set id=~w, server_id=~w, lv=~w, time=~w">>, [Id, ServerId, Lv, utime:unixtime()])).

db_clean_sign() -> 
    db:execute(<<"truncate kf_1vn_sign_center">>).
