-module(pt_619).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(61900, _) ->
    {ok, []};
read(_Cmd, _R) -> {error, no_match}.

write (61900,[
    SendList,
    KfSendList
]) ->
    BinList_SendList = [
        item_to_bin_0(SendList_Item) || SendList_Item <- SendList
    ], 

    SendList_Len = length(SendList), 
    Bin_SendList = list_to_binary(BinList_SendList),

    BinList_KfSendList = [
        item_to_bin_1(KfSendList_Item) || KfSendList_Item <- KfSendList
    ], 

    KfSendList_Len = length(KfSendList), 
    Bin_KfSendList = list_to_binary(BinList_KfSendList),

    Data = <<
        SendList_Len:16, Bin_SendList/binary,
        KfSendList_Len:16, Bin_KfSendList/binary
    >>,
    {ok, pt:pack(61900, Data)};

write (61901,[
    Sign,
    Time,
    SceneName,
    AttrName,
    AttrId
]) ->
    Bin_SceneName = pt:write_string(SceneName), 

    Bin_AttrName = pt:write_string(AttrName), 

    Data = <<
        Sign:8,
        Time:32,
        Bin_SceneName/binary,
        Bin_AttrName/binary,
        AttrId:64
    >>,
    {ok, pt:pack(61901, Data)};

write (61902,[
    Sign,
    Time,
    SceneName,
    ServerId,
    ServerNum,
    AttrName,
    AttrId
]) ->
    Bin_SceneName = pt:write_string(SceneName), 

    Bin_AttrName = pt:write_string(AttrName), 

    Data = <<
        Sign:8,
        Time:32,
        Bin_SceneName/binary,
        ServerId:32,
        ServerNum:32,
        Bin_AttrName/binary,
        AttrId:64
    >>,
    {ok, pt:pack(61902, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 ({
    Sign,
    Time,
    SceneName,
    AttrName,
    AttrId
}) ->
    Bin_SceneName = pt:write_string(SceneName), 

    Bin_AttrName = pt:write_string(AttrName), 

    Data = <<
        Sign:8,
        Time:32,
        Bin_SceneName/binary,
        Bin_AttrName/binary,
        AttrId:64
    >>,
    Data.
item_to_bin_1 ({
    Sign,
    Time,
    SceneName,
    ServerId,
    ServerNum,
    AttrName,
    AttrId
}) ->
    Bin_SceneName = pt:write_string(SceneName), 

    Bin_AttrName = pt:write_string(AttrName), 

    Data = <<
        Sign:8,
        Time:32,
        Bin_SceneName/binary,
        ServerId:32,
        ServerNum:32,
        Bin_AttrName/binary,
        AttrId:64
    >>,
    Data.
