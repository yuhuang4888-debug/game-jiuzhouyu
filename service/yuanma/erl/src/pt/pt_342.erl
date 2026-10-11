-module(pt_342).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(34201, _) ->
    {ok, []};
read(34202, Bin0) ->
    <<Type:8, _Bin1/binary>> = Bin0, 
    {ok, [Type]};
read(34203, Bin0) ->
    <<Type:8, Bin1/binary>> = Bin0, 
    <<Subtype:8, _Bin2/binary>> = Bin1, 
    {ok, [Type, Subtype]};
read(34204, Bin0) ->
    <<Type:8, Bin1/binary>> = Bin0, 
    <<Subtype:8, Bin2/binary>> = Bin1, 
    <<Id:32, Bin3/binary>> = Bin2, 
    <<Sel:8, _Bin4/binary>> = Bin3, 
    {ok, [Type, Subtype, Id, Sel]};
read(34205, Bin0) ->
    <<Type:8, Bin1/binary>> = Bin0, 
    <<Subtype:8, Bin2/binary>> = Bin1, 
    <<Id:32, Bin3/binary>> = Bin2, 
    <<Times:32, Bin4/binary>> = Bin3, 
    <<Sel:8, Bin5/binary>> = Bin4, 
    <<AutoBuy:8, _Bin6/binary>> = Bin5, 
    {ok, [Type, Subtype, Id, Times, Sel, AutoBuy]};
read(34206, Bin0) ->
    <<Type:8, _Bin1/binary>> = Bin0, 
    {ok, [Type]};
read(34207, Bin0) ->
    <<Type:8, Bin1/binary>> = Bin0, 
    <<Id:32, _Bin2/binary>> = Bin1, 
    {ok, [Type, Id]};
read(34208, Bin0) ->
    <<Type:8, Bin1/binary>> = Bin0, 
    <<Id:32, Bin2/binary>> = Bin1, 
    <<Times:32, Bin3/binary>> = Bin2, 
    <<AutoBuy:8, _Bin4/binary>> = Bin3, 
    {ok, [Type, Id, Times, AutoBuy]};
read(34209, Bin0) ->
    <<Type:8, Bin1/binary>> = Bin0, 
    <<Subtype:8, Bin2/binary>> = Bin1, 
    <<Id:32, _Bin3/binary>> = Bin2, 
    {ok, [Type, Subtype, Id]};
read(34210, Bin0) ->
    <<Type:8, Bin1/binary>> = Bin0, 
    <<Id:32, _Bin2/binary>> = Bin1, 
    {ok, [Type, Id]};
read(34212, Bin0) ->
    <<Type:8, _Bin1/binary>> = Bin0, 
    {ok, [Type]};
read(_Cmd, _R) -> {error, no_match}.

write (34200,[
    Errcode
]) ->
    Data = <<
        Errcode:32
    >>,
    {ok, pt:pack(34200, Data)};

write (34201,[
    Lists
]) ->
    BinList_Lists = [
        item_to_bin_0(Lists_Item) || Lists_Item <- Lists
    ], 

    Lists_Len = length(Lists), 
    Bin_Lists = list_to_binary(BinList_Lists),

    Data = <<
        Lists_Len:16, Bin_Lists/binary
    >>,
    {ok, pt:pack(34201, Data)};

write (34202,[
    Lists
]) ->
    BinList_Lists = [
        item_to_bin_1(Lists_Item) || Lists_Item <- Lists
    ], 

    Lists_Len = length(Lists), 
    Bin_Lists = list_to_binary(BinList_Lists),

    Data = <<
        Lists_Len:16, Bin_Lists/binary
    >>,
    {ok, pt:pack(34202, Data)};

write (34203,[
    Type,
    Subtype,
    Stime,
    Etime,
    Lists
]) ->
    BinList_Lists = [
        item_to_bin_2(Lists_Item) || Lists_Item <- Lists
    ], 

    Lists_Len = length(Lists), 
    Bin_Lists = list_to_binary(BinList_Lists),

    Data = <<
        Type:8,
        Subtype:8,
        Stime:32,
        Etime:32,
        Lists_Len:16, Bin_Lists/binary
    >>,
    {ok, pt:pack(34203, Data)};

write (34204,[
    Type,
    Subtype,
    Id,
    Aname,
    Aicon,
    Bname,
    Bicon,
    Times,
    TimesLim,
    Sel,
    Odds
]) ->
    Bin_Aname = pt:write_string(Aname), 

    Bin_Bname = pt:write_string(Bname), 

    Data = <<
        Type:8,
        Subtype:8,
        Id:32,
        Bin_Aname/binary,
        Aicon:16,
        Bin_Bname/binary,
        Bicon:16,
        Times:32,
        TimesLim:32,
        Sel:8,
        Odds:32
    >>,
    {ok, pt:pack(34204, Data)};

write (34205,[
    Errcode,
    Type,
    Subtype,
    Id,
    Times
]) ->
    Data = <<
        Errcode:32,
        Type:8,
        Subtype:8,
        Id:32,
        Times:32
    >>,
    {ok, pt:pack(34205, Data)};

write (34206,[
    Type,
    Stime,
    Etime,
    Lists
]) ->
    BinList_Lists = [
        item_to_bin_3(Lists_Item) || Lists_Item <- Lists
    ], 

    Lists_Len = length(Lists), 
    Bin_Lists = list_to_binary(BinList_Lists),

    Data = <<
        Type:8,
        Stime:32,
        Etime:32,
        Lists_Len:16, Bin_Lists/binary
    >>,
    {ok, pt:pack(34206, Data)};

write (34207,[
    Type,
    Id,
    Name,
    Icon,
    Times,
    TimesLim,
    Odds,
    BetList
]) ->
    Bin_Name = pt:write_string(Name), 

    BinList_BetList = [
        item_to_bin_4(BetList_Item) || BetList_Item <- BetList
    ], 

    BetList_Len = length(BetList), 
    Bin_BetList = list_to_binary(BinList_BetList),

    Data = <<
        Type:8,
        Id:32,
        Bin_Name/binary,
        Icon:16,
        Times:32,
        TimesLim:32,
        Odds:32,
        BetList_Len:16, Bin_BetList/binary
    >>,
    {ok, pt:pack(34207, Data)};

write (34208,[
    Errcode,
    Type,
    Id,
    Times,
    PersonNum
]) ->
    Data = <<
        Errcode:32,
        Type:8,
        Id:32,
        Times:32,
        PersonNum:32
    >>,
    {ok, pt:pack(34208, Data)};

write (34209,[
    Errcode,
    Type,
    Subtype,
    Id
]) ->
    Data = <<
        Errcode:32,
        Type:8,
        Subtype:8,
        Id:32
    >>,
    {ok, pt:pack(34209, Data)};

write (34210,[
    Errcode,
    Type,
    Id
]) ->
    Data = <<
        Errcode:32,
        Type:8,
        Id:32
    >>,
    {ok, pt:pack(34210, Data)};

write (34211,[
    Lists
]) ->
    BinList_Lists = [
        item_to_bin_5(Lists_Item) || Lists_Item <- Lists
    ], 

    Lists_Len = length(Lists), 
    Bin_Lists = list_to_binary(BinList_Lists),

    Data = <<
        Lists_Len:16, Bin_Lists/binary
    >>,
    {ok, pt:pack(34211, Data)};

write (34212,[
    Lists
]) ->
    BinList_Lists = [
        item_to_bin_6(Lists_Item) || Lists_Item <- Lists
    ], 

    Lists_Len = length(Lists), 
    Bin_Lists = list_to_binary(BinList_Lists),

    Data = <<
        Lists_Len:16, Bin_Lists/binary
    >>,
    {ok, pt:pack(34212, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 ({
    Type,
    OpenLv,
    Stime,
    Etime
}) ->
    Data = <<
        Type:8,
        OpenLv:16,
        Stime:32,
        Etime:32
    >>,
    Data.
item_to_bin_1 ({
    Type,
    Subtype
}) ->
    Data = <<
        Type:8,
        Subtype:8
    >>,
    Data.
item_to_bin_2 ({
    Id,
    Name,
    Time,
    Aname,
    Aicon,
    Bname,
    Bicon,
    AwinOdds,
    AfailOdds,
    DrawOdds,
    IsBet,
    Result,
    ResultDesc,
    Status
}) ->
    Bin_Name = pt:write_string(Name), 

    Bin_Aname = pt:write_string(Aname), 

    Bin_Bname = pt:write_string(Bname), 

    Bin_ResultDesc = pt:write_string(ResultDesc), 

    Data = <<
        Id:32,
        Bin_Name/binary,
        Time:32,
        Bin_Aname/binary,
        Aicon:16,
        Bin_Bname/binary,
        Bicon:16,
        AwinOdds:32,
        AfailOdds:32,
        DrawOdds:32,
        IsBet:8,
        Result:8,
        Bin_ResultDesc/binary,
        Status:8
    >>,
    Data.
item_to_bin_3 ({
    Id,
    Name,
    Icon,
    Odds,
    IsBet,
    Result,
    Status,
    PersonNum
}) ->
    Bin_Name = pt:write_string(Name), 

    Data = <<
        Id:32,
        Bin_Name/binary,
        Icon:16,
        Odds:32,
        IsBet:8,
        Result:8,
        Status:8,
        PersonNum:32
    >>,
    Data.
item_to_bin_4 ({
    PreOdds,
    PreTimes
}) ->
    Data = <<
        PreOdds:32,
        PreTimes:32
    >>,
    Data.
item_to_bin_5 ({
    Type,
    OpenLv,
    Stime,
    Etime
}) ->
    Data = <<
        Type:8,
        OpenLv:16,
        Stime:32,
        Etime:32
    >>,
    Data.
item_to_bin_6 ({
    Type,
    CfgName,
    Times,
    Odds,
    SelResult,
    RewardNum,
    Time
}) ->
    Bin_CfgName = pt:write_string(CfgName), 

    Data = <<
        Type:8,
        Bin_CfgName/binary,
        Times:32,
        Odds:32,
        SelResult:8,
        RewardNum:32,
        Time:32
    >>,
    Data.
