%%% ---------------------------------------------------------------------------
%%% @doc            pp_armour.erl
%%% @author         kyd
%%% @email          kuangyaode@qq.com
%%% @since          2021-03-08
%%% @description    战甲协议路由
%%% ---------------------------------------------------------------------------
-module(pp_armour).

-include("common.hrl").
-include("server.hrl").
-include("errcode.hrl").
-include("armour.hrl").

-export([handle/3]).

handle(Cmd, PS, Data) ->
    do_handle(Cmd, PS, Data).

%% 获取玩家战甲信息
do_handle(Cmd = 14401, PS, [Stage, Type]) ->
    #player_status{sid = SId} = PS,
    ArmourInfos = lib_armour:get_armour_info(PS, Stage, Type),
    % ?MYLOG("kyd_armour", "14401 ~p", [ArmourInfos]),
    lib_server_send:send_to_sid(SId, pt_144, Cmd, [ArmourInfos]);

%% 战甲打造
do_handle(Cmd = 14402, PS, [Stage, Type, Pos]) ->
    #player_status{sid = SId} = PS,
    case lib_armour:make_armour(PS, Stage, Type, Pos) of
        {false, Code} ->
            {NewPS, ArmourInfo} = {PS, []};
        {NewPS, ArmourInfo} when is_record(NewPS, player_status) ->
            Code = ?SUCCESS;
        _ ->
            Code = ?FAIL,
            {NewPS, ArmourInfo} = {PS, []}
    end,
    lib_server_send:send_to_sid(SId, pt_144, Cmd, [Code, ArmourInfo]),
    {ok, NewPS};

%% 容错
do_handle(_Cmd, _PS, _Param) ->
    {error, "Illegal protocol~n"}.