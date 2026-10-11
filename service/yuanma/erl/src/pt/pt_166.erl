-module(pt_166).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(16600, _) ->
    {ok, []};
read(16601, _) ->
    {ok, []};
read(16602, _) ->
    {ok, []};
read(_Cmd, _R) -> {error, no_match}.

write (16600,[
    Code,
    Nowjuewei
]) ->
    Data = <<
        Code:8,
        Nowjuewei:8
    >>,
    {ok, pt:pack(16600, Data)};

write (16601,[
    Code,
    Nowjuewei
]) ->
    Data = <<
        Code:8,
        Nowjuewei:8
    >>,
    {ok, pt:pack(16601, Data)};

write (16602,[
    RoleId,
    Nowjuewei
]) ->
    Data = <<
        RoleId:64,
        Nowjuewei:8
    >>,
    {ok, pt:pack(16602, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


