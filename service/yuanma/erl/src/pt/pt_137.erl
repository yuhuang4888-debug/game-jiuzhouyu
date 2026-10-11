-module(pt_137).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(13700, _) ->
    {ok, []};
read(13701, _) ->
    {ok, []};
read(13702, _) ->
    {ok, []};
read(13703, _) ->
    {ok, []};
read(13704, _) ->
    {ok, []};
read(13706, Bin0) ->
    <<Num:8, _Bin1/binary>> = Bin0, 
    {ok, [Num]};
read(13707, Bin0) ->
    <<Quit:8, _Bin1/binary>> = Bin0, 
    {ok, [Quit]};
read(13709, _) ->
    {ok, []};
read(13710, _) ->
    {ok, []};
read(13711, Bin0) ->
    <<WarNo:8, _Bin1/binary>> = Bin0, 
    {ok, [WarNo]};
read(13715, Bin0) ->
    <<SkillId:32, _Bin1/binary>> = Bin0, 
    {ok, [SkillId]};
read(13716, _) ->
    {ok, []};
read(13719, _) ->
    {ok, []};
read(13720, Bin0) ->
    <<GuessType:8, Bin1/binary>> = Bin0, 
    <<RoleId:64, Bin2/binary>> = Bin1, 
    <<ActionId:8, _Bin3/binary>> = Bin2, 
    {ok, [GuessType, RoleId, ActionId]};
read(13721, _) ->
    {ok, []};
read(13722, _) ->
    {ok, []};
read(13723, Bin0) ->
    <<Zone:8, Bin1/binary>> = Bin0, 
    <<Action:8, Bin2/binary>> = Bin1, 
    <<Suprid:64, _Bin3/binary>> = Bin2, 
    {ok, [Zone, Action, Suprid]};
read(_Cmd, _R) -> {error, no_match}.

write (13700,[
    WarState,
    EndTime
]) ->
    Data = <<
        WarState:8,
        EndTime:32
    >>,
    {ok, pt:pack(13700, Data)};

write (13701,[
    IsSign
]) ->
    Data = <<
        IsSign:8
    >>,
    {ok, pt:pack(13701, Data)};

write (13702,[
    Code
]) ->
    Data = <<
        Code:32
    >>,
    {ok, pt:pack(13702, Data)};

write (13703,[
    Action,
    Type,
    EndTime
]) ->
    Data = <<
        Action:8,
        Type:8,
        EndTime:32
    >>,
    {ok, pt:pack(13703, Data)};

write (13704,[
    Code
]) ->
    Data = <<
        Code:32
    >>,
    {ok, pt:pack(13704, Data)};

write (13705,[
    IsOut,
    Zone,
    Stage,
    WinNum,
    LoseNum,
    LifeNum
]) ->
    Data = <<
        IsOut:8,
        Zone:8,
        Stage:8,
        WinNum:8,
        LoseNum:8,
        LifeNum:8
    >>,
    {ok, pt:pack(13705, Data)};

write (13706,[
    Code,
    LifeNum
]) ->
    Data = <<
        Code:32,
        LifeNum:8
    >>,
    {ok, pt:pack(13706, Data)};

write (13707,[
    Code
]) ->
    Data = <<
        Code:32
    >>,
    {ok, pt:pack(13707, Data)};

write (13708,[
    Settlement,
    Result,
    ActionId
]) ->
    Data = <<
        Settlement:8,
        Result:8,
        ActionId:8
    >>,
    {ok, pt:pack(13708, Data)};

write (13709,[
]) ->
    Data = <<
    >>,
    {ok, pt:pack(13709, Data)};

write (13710,[
    SelfLife,
    OtherLife
]) ->
    Data = <<
        SelfLife:8,
        OtherLife:8
    >>,
    {ok, pt:pack(13710, Data)};

write (13711,[
    WarNo,
    List
]) ->
    BinList_List = [
        item_to_bin_0(List_Item) || List_Item <- List
    ], 

    List_Len = length(List), 
    Bin_List = list_to_binary(BinList_List),

    Data = <<
        WarNo:8,
        List_Len:16, Bin_List/binary
    >>,
    {ok, pt:pack(13711, Data)};

write (13712,[
    Zone,
    RoleName
]) ->
    Bin_RoleName = pt:write_string(RoleName), 

    Data = <<
        Zone:8,
        Bin_RoleName/binary
    >>,
    {ok, pt:pack(13712, Data)};

write (13714,[
    Power,
    ServerId,
    ServerNum,
    ServerName
]) ->
    Bin_ServerName = pt:write_string(ServerName), 

    Data = <<
        Power:64,
        ServerId:32,
        ServerNum:32,
        Bin_ServerName/binary
    >>,
    {ok, pt:pack(13714, Data)};

write (13715,[
    Code,
    SkillId,
    CdEndTime
]) ->
    Data = <<
        Code:32,
        SkillId:32,
        CdEndTime:32
    >>,
    {ok, pt:pack(13715, Data)};

write (13716,[
    Zone
]) ->
    Data = <<
        Zone:8
    >>,
    {ok, pt:pack(13716, Data)};

write (13718,[
    EndTime,
    Update
]) ->
    Data = <<
        EndTime:32,
        Update:8
    >>,
    {ok, pt:pack(13718, Data)};

write (13719,[
    EndTime,
    List
]) ->
    BinList_List = [
        item_to_bin_1(List_Item) || List_Item <- List
    ], 

    List_Len = length(List), 
    Bin_List = list_to_binary(BinList_List),

    Data = <<
        EndTime:32,
        List_Len:16, Bin_List/binary
    >>,
    {ok, pt:pack(13719, Data)};

write (13720,[
    Code,
    RoleId,
    ActionId
]) ->
    Data = <<
        Code:32,
        RoleId:64,
        ActionId:8
    >>,
    {ok, pt:pack(13720, Data)};

write (13721,[
    List
]) ->
    BinList_List = [
        item_to_bin_3(List_Item) || List_Item <- List
    ], 

    List_Len = length(List), 
    Bin_List = list_to_binary(BinList_List),

    Data = <<
        List_Len:16, Bin_List/binary
    >>,
    {ok, pt:pack(13721, Data)};

write (13722,[
    Zone,
    Action,
    Suprid,
    GuessType,
    RewardSt,
    Winner,
    Arid,
    Asid,
    Asnum,
    Aname,
    Alv,
    Asex,
    Acareer,
    Apic,
    Apicver,
    Apower,
    Brid,
    Bsid,
    Bsnum,
    Bname,
    Blv,
    Bsex,
    Bcareer,
    Bpic,
    Bpicver,
    Bpower
]) ->
    Bin_Aname = pt:write_string(Aname), 

    Bin_Apic = pt:write_string(Apic), 

    Bin_Bname = pt:write_string(Bname), 

    Bin_Bpic = pt:write_string(Bpic), 

    Data = <<
        Zone:8,
        Action:8,
        Suprid:64,
        GuessType:8,
        RewardSt:8,
        Winner:64,
        Arid:64,
        Asid:16,
        Asnum:16,
        Bin_Aname/binary,
        Alv:32,
        Asex:8,
        Acareer:8,
        Bin_Apic/binary,
        Apicver:8,
        Apower:64,
        Brid:64,
        Bsid:16,
        Bsnum:16,
        Bin_Bname/binary,
        Blv:32,
        Bsex:8,
        Bcareer:8,
        Bin_Bpic/binary,
        Bpicver:8,
        Bpower:64
    >>,
    {ok, pt:pack(13722, Data)};

write (13723,[
    Code,
    Zone,
    Action,
    Suprid,
    GuessType,
    RewardSt
]) ->
    Data = <<
        Code:32,
        Zone:8,
        Action:8,
        Suprid:64,
        GuessType:8,
        RewardSt:8
    >>,
    {ok, pt:pack(13723, Data)};

write (13724,[
    Zone,
    Action,
    Winner
]) ->
    Data = <<
        Zone:8,
        Action:8,
        Winner:64
    >>,
    {ok, pt:pack(13724, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 ({
    Zone,
    Rank,
    RoleId,
    ServerId,
    Platform,
    PlatformId,
    RoleName,
    GuildName,
    Vip,
    Power,
    Career
}) ->
    Bin_Platform = pt:write_string(Platform), 

    Bin_RoleName = pt:write_string(RoleName), 

    Bin_GuildName = pt:write_string(GuildName), 

    Data = <<
        Zone:8,
        Rank:8,
        RoleId:64,
        ServerId:32,
        Bin_Platform/binary,
        PlatformId:32,
        Bin_RoleName/binary,
        Bin_GuildName/binary,
        Vip:8,
        Power:64,
        Career:8
    >>,
    Data.
item_to_bin_1 ({
    ActionId,
    List3
}) ->
    BinList_List3 = [
        item_to_bin_2(List3_Item) || List3_Item <- List3
    ], 

    List3_Len = length(List3), 
    Bin_List3 = list_to_binary(BinList_List3),

    Data = <<
        ActionId:8,
        List3_Len:16, Bin_List3/binary
    >>,
    Data.
item_to_bin_2 ({
    Suprid,
    Arid,
    Asid,
    Asnum,
    Aname,
    Apic,
    Apicver,
    Alv,
    Acareer,
    Apower,
    Brid,
    Bsid,
    Bsnum,
    Bname,
    Bpic,
    Bpicver,
    Blv,
    Bcareer,
    Bpower,
    Winner
}) ->
    Bin_Aname = pt:write_string(Aname), 

    Bin_Apic = pt:write_string(Apic), 

    Bin_Bname = pt:write_string(Bname), 

    Bin_Bpic = pt:write_string(Bpic), 

    Data = <<
        Suprid:64,
        Arid:64,
        Asid:16,
        Asnum:16,
        Bin_Aname/binary,
        Bin_Apic/binary,
        Apicver:8,
        Alv:32,
        Acareer:8,
        Apower:64,
        Brid:64,
        Bsid:16,
        Bsnum:16,
        Bin_Bname/binary,
        Bin_Bpic/binary,
        Bpicver:8,
        Blv:32,
        Bcareer:8,
        Bpower:64,
        Winner:64
    >>,
    Data.
item_to_bin_3 ({
    Zone,
    Action,
    Suprid,
    GuessType,
    RewardSt,
    Winner,
    Arid,
    Asid,
    Asnum,
    Aname,
    Alv,
    Asex,
    Acareer,
    Apic,
    Apicver,
    Apower,
    Brid,
    Bsid,
    Bsnum,
    Bname,
    Blv,
    Bsex,
    Bcareer,
    Bpic,
    Bpicver,
    Bpower
}) ->
    Bin_Aname = pt:write_string(Aname), 

    Bin_Apic = pt:write_string(Apic), 

    Bin_Bname = pt:write_string(Bname), 

    Bin_Bpic = pt:write_string(Bpic), 

    Data = <<
        Zone:8,
        Action:8,
        Suprid:64,
        GuessType:8,
        RewardSt:8,
        Winner:64,
        Arid:64,
        Asid:16,
        Asnum:16,
        Bin_Aname/binary,
        Alv:32,
        Asex:8,
        Acareer:8,
        Bin_Apic/binary,
        Apicver:8,
        Apower:64,
        Brid:64,
        Bsid:16,
        Bsnum:16,
        Bin_Bname/binary,
        Blv:32,
        Bsex:8,
        Bcareer:8,
        Bin_Bpic/binary,
        Bpicver:8,
        Bpower:64
    >>,
    Data.
