-module(pt_111).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(11100, _) ->
    {ok, []};
read(11101, Bin0) ->
    {Command, _Bin1} = pt:read_string(Bin0), 
    {ok, [Command]};
read(_Cmd, _R) -> {error, no_match}.

write (11100,[
    CommandList
]) ->
    BinList_CommandList = [
        item_to_bin_0(CommandList_Item) || CommandList_Item <- CommandList
    ], 

    CommandList_Len = length(CommandList), 
    Bin_CommandList = list_to_binary(BinList_CommandList),

    Data = <<
        CommandList_Len:16, Bin_CommandList/binary
    >>,
    {ok, pt:pack(11100, Data)};



write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 ({
    FuncName,
    FuncCommands
}) ->
    Bin_FuncName = pt:write_string(FuncName), 

    BinList_FuncCommands = [
        item_to_bin_1(FuncCommands_Item) || FuncCommands_Item <- FuncCommands
    ], 

    FuncCommands_Len = length(FuncCommands), 
    Bin_FuncCommands = list_to_binary(BinList_FuncCommands),

    Data = <<
        Bin_FuncName/binary,
        FuncCommands_Len:16, Bin_FuncCommands/binary
    >>,
    Data.
item_to_bin_1 ({
    Command,
    CommandName,
    ArgsList,
    DefaultList
}) ->
    Bin_Command = pt:write_string(Command), 

    Bin_CommandName = pt:write_string(CommandName), 

    BinList_ArgsList = [
        item_to_bin_2(ArgsList_Item) || ArgsList_Item <- ArgsList
    ], 

    ArgsList_Len = length(ArgsList), 
    Bin_ArgsList = list_to_binary(BinList_ArgsList),

    BinList_DefaultList = [
        item_to_bin_3(DefaultList_Item) || DefaultList_Item <- DefaultList
    ], 

    DefaultList_Len = length(DefaultList), 
    Bin_DefaultList = list_to_binary(BinList_DefaultList),

    Data = <<
        Bin_Command/binary,
        Bin_CommandName/binary,
        ArgsList_Len:16, Bin_ArgsList/binary,
        DefaultList_Len:16, Bin_DefaultList/binary
    >>,
    Data.
item_to_bin_2 (
    Args
) ->
    Bin_Args = pt:write_string(Args), 

    Data = <<
        Bin_Args/binary
    >>,
    Data.
item_to_bin_3 (
    Args
) ->
    Bin_Args = pt:write_string(Args), 

    Data = <<
        Bin_Args/binary
    >>,
    Data.
