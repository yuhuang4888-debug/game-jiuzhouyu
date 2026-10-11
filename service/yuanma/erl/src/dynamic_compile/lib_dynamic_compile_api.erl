%%-----------------------------------------------------------------------------
%% @Module  :       lib_dynamic_compile_api
%% @Author  :       Czc
%% @Email   :       389853407@qq.com
%% @Created :       2018-06-08
%% @Description:    动态生成文件编译API
%%-----------------------------------------------------------------------------
-module(lib_dynamic_compile_api).

-include("extra.hrl").

-export([
    compile_all_cfg/0
    , compile_extra_custom_act_cfg/0
    , compile_extra_guess_cfg/0
    ]).

compile_all_cfg() ->
    lib_dynamic_compile:dynamic_compile_cfg(?EXTRA_CFG_GUESS),
    ok.

compile_extra_custom_act_cfg() ->
    lib_dynamic_compile:dynamic_compile_cfg(?EXTRA_CFG_CUSTOM_ACT),
    ok.

compile_extra_guess_cfg() ->
    lib_dynamic_compile:dynamic_compile_cfg(?EXTRA_CFG_GUESS),
    ok.