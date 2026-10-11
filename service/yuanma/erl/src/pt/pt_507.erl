-module(pt_507).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(50701, _) ->
    {ok, []};
read(50702, Bin0) ->
    <<AreaId:8, _Bin1/binary>> = Bin0, 
    {ok, [AreaId]};
read(50703, Bin0) ->
    <<AreaId:8, _Bin1/binary>> = Bin0, 
    {ok, [AreaId]};
read(50704, _) ->
    {ok, []};
read(50705, _) ->
    {ok, []};
read(_Cmd, _R) -> {error, no_match}.

write (50701,[
    StartLevel,
    RwState,
    LevelList
]) ->
    BinList_LevelList = [
        item_to_bin_0(LevelList_Item) || LevelList_Item <- LevelList
    ], 

    LevelList_Len = length(LevelList), 
    Bin_LevelList = list_to_binary(BinList_LevelList),

    Data = <<
        StartLevel:8,
        RwState:8,
        LevelList_Len:16, Bin_LevelList/binary
    >>,
    {ok, pt:pack(50701, Data)};

write (50702,[
    AreaId,
    Challengers
]) ->
    BinList_Challengers = [
        item_to_bin_1(Challengers_Item) || Challengers_Item <- Challengers
    ], 

    Challengers_Len = length(Challengers), 
    Bin_Challengers = list_to_binary(BinList_Challengers),

    Data = <<
        AreaId:8,
        Challengers_Len:16, Bin_Challengers/binary
    >>,
    {ok, pt:pack(50702, Data)};

write (50703,[
    AreaId,
    Challengers
]) ->
    BinList_Challengers = [
        item_to_bin_2(Challengers_Item) || Challengers_Item <- Challengers
    ], 

    Challengers_Len = length(Challengers), 
    Bin_Challengers = list_to_binary(BinList_Challengers),

    Data = <<
        AreaId:8,
        Challengers_Len:16, Bin_Challengers/binary
    >>,
    {ok, pt:pack(50703, Data)};

write (50704,[
    ErrorCode,
    RwState
]) ->
    Data = <<
        ErrorCode:32,
        RwState:8
    >>,
    {ok, pt:pack(50704, Data)};

write (50705,[
    ResultType,
    Level,
    GoTime,
    BecomeChallengers,
    RewardList
]) ->
    Bin_RewardList = pt:write_object_list(RewardList), 

    Data = <<
        ResultType:8,
        Level:8,
        GoTime:32,
        BecomeChallengers:8,
        Bin_RewardList/binary
    >>,
    {ok, pt:pack(50705, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 ({
    Level,
    GoTime
}) ->
    Data = <<
        Level:8,
        GoTime:32
    >>,
    Data.
item_to_bin_1 ({
    Level,
    RoleId,
    RoleName,
    ServerId,
    ServerNum,
    Lv,
    Career,
    Sex,
    Turn,
    Picture,
    PictureVer,
    GoTime
}) ->
    Bin_RoleName = pt:write_string(RoleName), 

    Bin_Picture = pt:write_string(Picture), 

    Data = <<
        Level:8,
        RoleId:64,
        Bin_RoleName/binary,
        ServerId:16,
        ServerNum:16,
        Lv:16,
        Career:8,
        Sex:8,
        Turn:8,
        Bin_Picture/binary,
        PictureVer:8,
        GoTime:32
    >>,
    Data.
item_to_bin_2 ({
    Level,
    RoleId,
    RoleName,
    ServerNum,
    GoTime
}) ->
    Bin_RoleName = pt:write_string(RoleName), 

    Data = <<
        Level:8,
        RoleId:64,
        Bin_RoleName/binary,
        ServerNum:16,
        GoTime:32
    >>,
    Data.
