-module(pt_240).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(24000, Bin0) ->
    <<ActivityId:8, Bin1/binary>> = Bin0, 
    <<Subtype:8, Bin2/binary>> = Bin1, 
    <<SceneId:32, Bin3/binary>> = Bin2, 
    <<MinLv:16, Bin4/binary>> = Bin3, 
    <<MaxLv:16, Bin5/binary>> = Bin4, 
    <<JoinConValue:32, _Bin6/binary>> = Bin5, 
    {ok, [ActivityId, Subtype, SceneId, MinLv, MaxLv, JoinConValue]};
read(24002, Bin0) ->
    <<TeamId:64, Bin1/binary>> = Bin0, 
    <<ActivityId:8, Bin2/binary>> = Bin1, 
    <<Subtype:8, _Bin3/binary>> = Bin2, 
    {ok, [TeamId, ActivityId, Subtype]};
read(24003, _) ->
    {ok, []};
read(24004, Bin0) ->
    FunArray0 = fun(<<RestBin0/binary>>) -> 
        <<IsAgree:8, _Args1/binary>> = RestBin0, 
        <<ServerId:16, _Args2/binary>> = _Args1, 
        <<PlayerId:64, _Args3/binary>> = _Args2, 
        {{IsAgree, ServerId, PlayerId},_Args3}
        end,
    {ResRequest, _Bin1} = pt:read_array(FunArray0, Bin0),

    {ok, [ResRequest]};
read(24005, _) ->
    {ok, []};
read(24006, Bin0) ->
    <<ActivityId:8, Bin1/binary>> = Bin0, 
    <<Subtype:8, Bin2/binary>> = Bin1, 
    <<SceneId:32, Bin3/binary>> = Bin2, 
    <<MinLv:16, Bin4/binary>> = Bin3, 
    <<MaxLv:16, Bin5/binary>> = Bin4, 
    FunArray0 = fun(<<RestBin0/binary>>) -> 
        <<PlayerId:64, _Args1/binary>> = RestBin0, 
        {PlayerId,_Args1}
        end,
    {InviteList, _Bin6} = pt:read_array(FunArray0, Bin5),

    {ok, [ActivityId, Subtype, SceneId, MinLv, MaxLv, InviteList]};
read(24007, _) ->
    {ok, []};
read(24008, Bin0) ->
    FunArray0 = fun(<<RestBin0/binary>>) -> 
        <<TeamId:64, _Args1/binary>> = RestBin0, 
        <<Res:8, _Args2/binary>> = _Args1, 
        {{TeamId, Res},_Args2}
        end,
    {ResponseList, _Bin1} = pt:read_array(FunArray0, Bin0),

    {ok, [ResponseList]};
read(24009, Bin0) ->
    <<KickId:64, _Bin1/binary>> = Bin0, 
    {ok, [KickId]};
read(24010, _) ->
    {ok, []};
read(24011, Bin0) ->
    <<NewLeaderid:64, _Bin1/binary>> = Bin0, 
    {ok, [NewLeaderid]};
read(24012, Bin0) ->
    <<ActivityId:8, Bin1/binary>> = Bin0, 
    <<Subtype:8, Bin2/binary>> = Bin1, 
    <<SceneId:32, _Bin3/binary>> = Bin2, 
    {ok, [ActivityId, Subtype, SceneId]};
read(24016, Bin0) ->
    <<PlayerId:64, _Bin1/binary>> = Bin0, 
    {ok, [PlayerId]};
read(24017, Bin0) ->
    <<ActivityId:8, Bin1/binary>> = Bin0, 
    <<Subtype:8, Bin2/binary>> = Bin1, 
    <<SceneId:32, Bin3/binary>> = Bin2, 
    <<MinLv:16, Bin4/binary>> = Bin3, 
    <<MaxLv:16, Bin5/binary>> = Bin4, 
    <<JoinConValue:32, _Bin6/binary>> = Bin5, 
    {ok, [ActivityId, Subtype, SceneId, MinLv, MaxLv, JoinConValue]};
read(24018, Bin0) ->
    <<JoinType:8, _Bin1/binary>> = Bin0, 
    {ok, [JoinType]};
read(24020, Bin0) ->
    <<ActivityId:32, Bin1/binary>> = Bin0, 
    <<Subtype:8, _Bin2/binary>> = Bin1, 
    {ok, [ActivityId, Subtype]};
read(24021, Bin0) ->
    <<ArbitrateId:16, Bin1/binary>> = Bin0, 
    <<Res:8, _Bin2/binary>> = Bin1, 
    {ok, [ArbitrateId, Res]};
read(24022, _) ->
    {ok, []};
read(24023, Bin0) ->
    <<ActivityId:8, Bin1/binary>> = Bin0, 
    <<Subtype:8, _Bin2/binary>> = Bin1, 
    {ok, [ActivityId, Subtype]};
read(24024, Bin0) ->
    <<Type:8, Bin1/binary>> = Bin0, 
    <<FollowId:64, _Bin2/binary>> = Bin1, 
    {ok, [Type, FollowId]};
read(24025, Bin0) ->
    <<Id:64, _Bin1/binary>> = Bin0, 
    {ok, [Id]};
read(24026, _) ->
    {ok, []};
read(24032, Bin0) ->
    FunArray0 = fun(<<RestBin0/binary>>) -> 
        <<TeamId:64, _Args1/binary>> = RestBin0, 
        {TeamId,_Args1}
        end,
    {TeamIds, _Bin1} = pt:read_array(FunArray0, Bin0),

    {ok, [TeamIds]};
read(24033, Bin0) ->
    <<DunId:32, Bin1/binary>> = Bin0, 
    <<HelpType:8, _Bin2/binary>> = Bin1, 
    {ok, [DunId, HelpType]};
read(24035, _) ->
    {ok, []};
read(24039, _) ->
    {ok, []};
read(24042, Bin0) ->
    <<ActivityId:8, _Bin1/binary>> = Bin0, 
    {ok, [ActivityId]};
read(24043, Bin0) ->
    <<SceneId:32, Bin1/binary>> = Bin0, 
    <<MonId:32, Bin2/binary>> = Bin1, 
    <<X:16, Bin3/binary>> = Bin2, 
    <<Y:16, _Bin4/binary>> = Bin3, 
    {ok, [SceneId, MonId, X, Y]};
read(24044, Bin0) ->
    FunArray0 = fun(<<RestBin0/binary>>) -> 
        <<TeamId:64, _Args1/binary>> = RestBin0, 
        {TeamId,_Args1}
        end,
    {TeamIds, _Bin1} = pt:read_array(FunArray0, Bin0),

    {ok, [TeamIds]};
read(24045, _) ->
    {ok, []};
read(24047, _) ->
    {ok, []};
read(24048, Bin0) ->
    <<State:8, _Bin1/binary>> = Bin0, 
    {ok, [State]};
read(24049, Bin0) ->
    <<DunId:32, _Bin1/binary>> = Bin0, 
    {ok, [DunId]};
read(24050, _) ->
    {ok, []};
read(24053, Bin0) ->
    <<SceneId:32, _Bin1/binary>> = Bin0, 
    {ok, [SceneId]};
read(24054, Bin0) ->
    <<ActivityId:8, Bin1/binary>> = Bin0, 
    <<Subtype:8, _Bin2/binary>> = Bin1, 
    {ok, [ActivityId, Subtype]};
read(24055, _) ->
    {ok, []};
read(24057, Bin0) ->
    FunArray0 = fun(<<RestBin0/binary>>) -> 
        <<ServerId:16, _Args1/binary>> = RestBin0, 
        <<RoleId:64, _Args2/binary>> = _Args1, 
        {{ServerId, RoleId},_Args2}
        end,
    {InviteList, _Bin1} = pt:read_array(FunArray0, Bin0),

    {ok, [InviteList]};
read(24059, Bin0) ->
    <<Auto:8, _Bin1/binary>> = Bin0, 
    {ok, [Auto]};
read(24060, Bin0) ->
    <<Type:8, Bin1/binary>> = Bin0, 
    <<DunId:32, _Bin2/binary>> = Bin1, 
    {ok, [Type, DunId]};
read(24061, Bin0) ->
    <<Type:8, _Bin1/binary>> = Bin0, 
    {ok, [Type]};
read(24062, _) ->
    {ok, []};
read(24063, _) ->
    {ok, []};
read(_Cmd, _R) -> {error, no_match}.

write (24000,[
    Res,
    ErrorCodeArgs
]) ->
    Bin_ErrorCodeArgs = pt:write_string(ErrorCodeArgs), 

    Data = <<
        Res:32,
        Bin_ErrorCodeArgs/binary
    >>,
    {ok, pt:pack(24000, Data)};

write (24002,[
    Res,
    ErrorCodeArgs
]) ->
    Bin_ErrorCodeArgs = pt:write_string(ErrorCodeArgs), 

    Data = <<
        Res:32,
        Bin_ErrorCodeArgs/binary
    >>,
    {ok, pt:pack(24002, Data)};

write (24003,[
    ServerId,
    PlayerId,
    Figure
]) ->
    Bin_Figure = pt:write_figure(Figure), 

    Data = <<
        ServerId:16,
        PlayerId:64,
        Bin_Figure/binary
    >>,
    {ok, pt:pack(24003, Data)};

write (24004,[
    Res
]) ->
    Data = <<
        Res:32
    >>,
    {ok, pt:pack(24004, Data)};

write (24005,[
    Res
]) ->
    Data = <<
        Res:32
    >>,
    {ok, pt:pack(24005, Data)};

write (24006,[
    Res
]) ->
    Data = <<
        Res:32
    >>,
    {ok, pt:pack(24006, Data)};

write (24007,[
    TeamId,
    Num,
    ActivityId,
    Subtype,
    SceneId,
    InviterId,
    InviterFigure,
    InviteSceneId,
    InviteType
]) ->
    Bin_InviterFigure = pt:write_figure(InviterFigure), 

    Data = <<
        TeamId:64,
        Num:8,
        ActivityId:32,
        Subtype:8,
        SceneId:32,
        InviterId:64,
        Bin_InviterFigure/binary,
        InviteSceneId:32,
        InviteType:8
    >>,
    {ok, pt:pack(24007, Data)};

write (24008,[
    Res,
    ErrorCodeArgs
]) ->
    Bin_ErrorCodeArgs = pt:write_string(ErrorCodeArgs), 

    Data = <<
        Res:32,
        Bin_ErrorCodeArgs/binary
    >>,
    {ok, pt:pack(24008, Data)};

write (24009,[
    Res
]) ->
    Data = <<
        Res:32
    >>,
    {ok, pt:pack(24009, Data)};

write (24010,[
    TeamId,
    ActivityId,
    Subtype,
    SceneId,
    PreNumFull,
    AutoMatching,
    MatchSt,
    MinLv,
    MaxLv,
    JoinConValue,
    AutoStart,
    JoinType,
    TeamMemberList
]) ->
    BinList_TeamMemberList = [
        item_to_bin_0(TeamMemberList_Item) || TeamMemberList_Item <- TeamMemberList
    ], 

    TeamMemberList_Len = length(TeamMemberList), 
    Bin_TeamMemberList = list_to_binary(BinList_TeamMemberList),

    Data = <<
        TeamId:64,
        ActivityId:8,
        Subtype:8,
        SceneId:32,
        PreNumFull:8,
        AutoMatching:8,
        MatchSt:32,
        MinLv:16,
        MaxLv:16,
        JoinConValue:32,
        AutoStart:8,
        JoinType:8,
        TeamMemberList_Len:16, Bin_TeamMemberList/binary
    >>,
    {ok, pt:pack(24010, Data)};

write (24011,[
    Res
]) ->
    Data = <<
        Res:32
    >>,
    {ok, pt:pack(24011, Data)};

write (24012,[
    ActivityId,
    Subtype,
    SceneId,
    TeamEnlist
]) ->
    BinList_TeamEnlist = [
        item_to_bin_1(TeamEnlist_Item) || TeamEnlist_Item <- TeamEnlist
    ], 

    TeamEnlist_Len = length(TeamEnlist), 
    Bin_TeamEnlist = list_to_binary(BinList_TeamEnlist),

    Data = <<
        ActivityId:8,
        Subtype:8,
        SceneId:32,
        TeamEnlist_Len:16, Bin_TeamEnlist/binary
    >>,
    {ok, pt:pack(24012, Data)};

write (24013,[
    Id,
    TeamId,
    Position
]) ->
    Data = <<
        Id:64,
        TeamId:64,
        Position:8
    >>,
    {ok, pt:pack(24013, Data)};

write (24014,[
    Id
]) ->
    Data = <<
        Id:64
    >>,
    {ok, pt:pack(24014, Data)};

write (24015,[
    Id
]) ->
    Data = <<
        Id:64
    >>,
    {ok, pt:pack(24015, Data)};

write (24016,[
    Res
]) ->
    Data = <<
        Res:32
    >>,
    {ok, pt:pack(24016, Data)};

write (24017,[
    Res,
    ActivityId,
    Subtype,
    SceneId,
    MinLv,
    MaxLv,
    JoinConValue
]) ->
    Data = <<
        Res:32,
        ActivityId:8,
        Subtype:8,
        SceneId:32,
        MinLv:16,
        MaxLv:16,
        JoinConValue:32
    >>,
    {ok, pt:pack(24017, Data)};

write (24018,[
    Res,
    JoinType
]) ->
    Data = <<
        Res:32,
        JoinType:8
    >>,
    {ok, pt:pack(24018, Data)};

write (24020,[
    ErrorCode,
    ErrorCodeArgs,
    ActivityId,
    Subtype,
    SceneId,
    ArbitrateId
]) ->
    Bin_ErrorCodeArgs = pt:write_string(ErrorCodeArgs), 

    Data = <<
        ErrorCode:32,
        Bin_ErrorCodeArgs/binary,
        ActivityId:32,
        Subtype:8,
        SceneId:32,
        ArbitrateId:16
    >>,
    {ok, pt:pack(24020, Data)};

write (24021,[
    ErrorCode,
    ErrorCodeArgs,
    Res
]) ->
    Bin_ErrorCodeArgs = pt:write_string(ErrorCodeArgs), 

    Data = <<
        ErrorCode:32,
        Bin_ErrorCodeArgs/binary,
        Res:8
    >>,
    {ok, pt:pack(24021, Data)};

write (24022,[
    AcList
]) ->
    BinList_AcList = [
        item_to_bin_3(AcList_Item) || AcList_Item <- AcList
    ], 

    AcList_Len = length(AcList), 
    Bin_AcList = list_to_binary(BinList_AcList),

    Data = <<
        AcList_Len:16, Bin_AcList/binary
    >>,
    {ok, pt:pack(24022, Data)};

write (24023,[
    Res,
    ActivityId,
    Subtype
]) ->
    Data = <<
        Res:32,
        ActivityId:8,
        Subtype:8
    >>,
    {ok, pt:pack(24023, Data)};

write (24024,[
    Res,
    FollowId
]) ->
    Data = <<
        Res:32,
        FollowId:64
    >>,
    {ok, pt:pack(24024, Data)};

write (24025,[
    Id,
    Scene,
    X,
    Y,
    IsFollow,
    ValhallaPkId
]) ->
    Data = <<
        Id:64,
        Scene:32,
        X:16,
        Y:16,
        IsFollow:8,
        ValhallaPkId:32
    >>,
    {ok, pt:pack(24025, Data)};

write (24026,[
    FollowId
]) ->
    Data = <<
        FollowId:64
    >>,
    {ok, pt:pack(24026, Data)};

write (24030,[
    Res
]) ->
    Data = <<
        Res:32
    >>,
    {ok, pt:pack(24030, Data)};

write (24032,[
    TeamNums
]) ->
    BinList_TeamNums = [
        item_to_bin_4(TeamNums_Item) || TeamNums_Item <- TeamNums
    ], 

    TeamNums_Len = length(TeamNums), 
    Bin_TeamNums = list_to_binary(BinList_TeamNums),

    Data = <<
        TeamNums_Len:16, Bin_TeamNums/binary
    >>,
    {ok, pt:pack(24032, Data)};

write (24033,[
    ErrorCode,
    DunId,
    HelpType
]) ->
    Data = <<
        ErrorCode:32,
        DunId:32,
        HelpType:8
    >>,
    {ok, pt:pack(24033, Data)};

write (24034,[
    HelpTypeList
]) ->
    BinList_HelpTypeList = [
        item_to_bin_5(HelpTypeList_Item) || HelpTypeList_Item <- HelpTypeList
    ], 

    HelpTypeList_Len = length(HelpTypeList), 
    Bin_HelpTypeList = list_to_binary(BinList_HelpTypeList),

    Data = <<
        HelpTypeList_Len:16, Bin_HelpTypeList/binary
    >>,
    {ok, pt:pack(24034, Data)};

write (24035,[
    ActivityId,
    Subtype,
    SceneId,
    ArbitrateId,
    EndTime
]) ->
    Data = <<
        ActivityId:32,
        Subtype:8,
        SceneId:32,
        ArbitrateId:16,
        EndTime:32
    >>,
    {ok, pt:pack(24035, Data)};

write (24036,[
    RoleId,
    ArbitrateId,
    Res
]) ->
    Data = <<
        RoleId:64,
        ArbitrateId:16,
        Res:8
    >>,
    {ok, pt:pack(24036, Data)};

write (24037,[
    ErrorCode,
    ErrorCodeArgs
]) ->
    Bin_ErrorCodeArgs = pt:write_string(ErrorCodeArgs), 

    Data = <<
        ErrorCode:32,
        Bin_ErrorCodeArgs/binary
    >>,
    {ok, pt:pack(24037, Data)};

write (24038,[
    ErrorCode,
    ErrorCodeArgs
]) ->
    Bin_ErrorCodeArgs = pt:write_string(ErrorCodeArgs), 

    Data = <<
        ErrorCode:32,
        Bin_ErrorCodeArgs/binary
    >>,
    {ok, pt:pack(24038, Data)};

write (24039,[
    ErrorCode
]) ->
    Data = <<
        ErrorCode:32
    >>,
    {ok, pt:pack(24039, Data)};

write (24040,[
]) ->
    Data = <<
    >>,
    {ok, pt:pack(24040, Data)};

write (24041,[
    SceneId,
    X,
    Y
]) ->
    Data = <<
        SceneId:32,
        X:16,
        Y:16
    >>,
    {ok, pt:pack(24041, Data)};

write (24042,[
    Type,
    LeftTime
]) ->
    Data = <<
        Type:8,
        LeftTime:8
    >>,
    {ok, pt:pack(24042, Data)};

write (24043,[
    SceneId,
    MonId,
    X,
    Y
]) ->
    Data = <<
        SceneId:32,
        MonId:32,
        X:16,
        Y:16
    >>,
    {ok, pt:pack(24043, Data)};

write (24044,[
    Res
]) ->
    Data = <<
        Res:32
    >>,
    {ok, pt:pack(24044, Data)};

write (24045,[
    Res
]) ->
    Data = <<
        Res:32
    >>,
    {ok, pt:pack(24045, Data)};

write (24046,[
    RoleId,
    EndTime
]) ->
    Data = <<
        RoleId:64,
        EndTime:32
    >>,
    {ok, pt:pack(24046, Data)};

write (24047,[
    Reqlist
]) ->
    BinList_Reqlist = [
        item_to_bin_6(Reqlist_Item) || Reqlist_Item <- Reqlist
    ], 

    Reqlist_Len = length(Reqlist), 
    Bin_Reqlist = list_to_binary(BinList_Reqlist),

    Data = <<
        Reqlist_Len:16, Bin_Reqlist/binary
    >>,
    {ok, pt:pack(24047, Data)};

write (24048,[
    Res,
    ErrorCodeArgs,
    State,
    MatchSt,
    ActivityId,
    Subtype,
    RoleId
]) ->
    Bin_ErrorCodeArgs = pt:write_string(ErrorCodeArgs), 

    Data = <<
        Res:32,
        Bin_ErrorCodeArgs/binary,
        State:8,
        MatchSt:32,
        ActivityId:8,
        Subtype:8,
        RoleId:64
    >>,
    {ok, pt:pack(24048, Data)};

write (24049,[
    DunId,
    State
]) ->
    Data = <<
        DunId:32,
        State:8
    >>,
    {ok, pt:pack(24049, Data)};

write (24050,[
    ExpScale
]) ->
    Data = <<
        ExpScale:16
    >>,
    {ok, pt:pack(24050, Data)};

write (24051,[
    RoleId,
    SceneId
]) ->
    Data = <<
        RoleId:64,
        SceneId:32
    >>,
    {ok, pt:pack(24051, Data)};

write (24052,[
    RoleId,
    Online
]) ->
    Data = <<
        RoleId:64,
        Online:8
    >>,
    {ok, pt:pack(24052, Data)};

write (24053,[
    SceneId,
    Users
]) ->
    BinList_Users = [
        item_to_bin_7(Users_Item) || Users_Item <- Users
    ], 

    Users_Len = length(Users), 
    Bin_Users = list_to_binary(BinList_Users),

    Data = <<
        SceneId:32,
        Users_Len:16, Bin_Users/binary
    >>,
    {ok, pt:pack(24053, Data)};



write (24055,[
]) ->
    Data = <<
    >>,
    {ok, pt:pack(24055, Data)};

write (24056,[
    Members
]) ->
    BinList_Members = [
        item_to_bin_8(Members_Item) || Members_Item <- Members
    ], 

    Members_Len = length(Members), 
    Bin_Members = list_to_binary(BinList_Members),

    Data = <<
        Members_Len:16, Bin_Members/binary
    >>,
    {ok, pt:pack(24056, Data)};

write (24057,[
    Res
]) ->
    Data = <<
        Res:32
    >>,
    {ok, pt:pack(24057, Data)};

write (24058,[
    Time
]) ->
    Data = <<
        Time:32
    >>,
    {ok, pt:pack(24058, Data)};

write (24059,[
    Auto
]) ->
    Data = <<
        Auto:8
    >>,
    {ok, pt:pack(24059, Data)};

write (24060,[
    Type,
    DunId,
    ArrayList
]) ->
    BinList_ArrayList = [
        item_to_bin_9(ArrayList_Item) || ArrayList_Item <- ArrayList
    ], 

    ArrayList_Len = length(ArrayList), 
    Bin_ArrayList = list_to_binary(BinList_ArrayList),

    Data = <<
        Type:8,
        DunId:32,
        ArrayList_Len:16, Bin_ArrayList/binary
    >>,
    {ok, pt:pack(24060, Data)};

write (24061,[
    Type,
    ArrayList
]) ->
    BinList_ArrayList = [
        item_to_bin_10(ArrayList_Item) || ArrayList_Item <- ArrayList
    ], 

    ArrayList_Len = length(ArrayList), 
    Bin_ArrayList = list_to_binary(BinList_ArrayList),

    Data = <<
        Type:8,
        ArrayList_Len:16, Bin_ArrayList/binary
    >>,
    {ok, pt:pack(24061, Data)};



write (24063,[
    ErrorCode
]) ->
    Data = <<
        ErrorCode:32
    >>,
    {ok, pt:pack(24063, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 ({
    Id,
    TeamPosition,
    Member,
    HelpType,
    SceneId,
    JoinTime,
    Power,
    Online,
    ServerId,
    ServerNum,
    JoinValue
}) ->
    Bin_Member = pt:write_figure(Member), 

    Data = <<
        Id:64,
        TeamPosition:8,
        Bin_Member/binary,
        HelpType:8,
        SceneId:32,
        JoinTime:32,
        Power:64,
        Online:8,
        ServerId:16,
        ServerNum:16,
        JoinValue:32
    >>,
    Data.
item_to_bin_1 ({
    TeamId,
    Num,
    JoinConValue,
    Members
}) ->
    BinList_Members = [
        item_to_bin_2(Members_Item) || Members_Item <- Members
    ], 

    Members_Len = length(Members), 
    Bin_Members = list_to_binary(BinList_Members),

    Data = <<
        TeamId:64,
        Num:8,
        JoinConValue:32,
        Members_Len:16, Bin_Members/binary
    >>,
    Data.
item_to_bin_2 ({
    Id,
    TeamPosition,
    Member,
    HelpType,
    SceneId,
    Online,
    ServerId,
    ServerNum,
    JoinValue,
    Power
}) ->
    Bin_Member = pt:write_figure(Member), 

    Data = <<
        Id:64,
        TeamPosition:8,
        Bin_Member/binary,
        HelpType:8,
        SceneId:32,
        Online:8,
        ServerId:16,
        ServerNum:16,
        JoinValue:32,
        Power:64
    >>,
    Data.
item_to_bin_3 ({
    ActivityId,
    Subtype,
    SceneId,
    Max,
    Now
}) ->
    Data = <<
        ActivityId:8,
        Subtype:8,
        SceneId:32,
        Max:32,
        Now:32
    >>,
    Data.
item_to_bin_4 ({
    Leader,
    TeamId,
    TeamNum,
    ActivityId,
    Subtype
}) ->
    Bin_Leader = pt:write_figure(Leader), 

    Data = <<
        Bin_Leader/binary,
        TeamId:64,
        TeamNum:8,
        ActivityId:32,
        Subtype:8
    >>,
    Data.
item_to_bin_5 ({
    RoleId,
    HelpType
}) ->
    Data = <<
        RoleId:64,
        HelpType:8
    >>,
    Data.
item_to_bin_6 ({
    ServerId,
    PlayerId,
    Figure,
    CombatPower,
    ServerNum
}) ->
    Bin_Figure = pt:write_figure(Figure), 

    Data = <<
        ServerId:16,
        PlayerId:64,
        Bin_Figure/binary,
        CombatPower:64,
        ServerNum:16
    >>,
    Data.
item_to_bin_7 ({
    RoleId,
    Platform,
    ServNum,
    ServId,
    Figure
}) ->
    Bin_Platform = pt:write_string(Platform), 

    Bin_Figure = pt:write_figure(Figure), 

    Data = <<
        RoleId:64,
        Bin_Platform/binary,
        ServNum:16,
        ServId:16,
        Bin_Figure/binary
    >>,
    Data.
item_to_bin_8 ({
    ServerId,
    RoleId
}) ->
    Data = <<
        ServerId:16,
        RoleId:64
    >>,
    Data.
item_to_bin_9 ({
    RoleId,
    Figure,
    Count,
    MaxCount,
    CombatPower
}) ->
    Bin_Figure = pt:write_figure(Figure), 

    Data = <<
        RoleId:64,
        Bin_Figure/binary,
        Count:8,
        MaxCount:8,
        CombatPower:64
    >>,
    Data.
item_to_bin_10 ({
    RoleId,
    Figure,
    CombatPower
}) ->
    Bin_Figure = pt:write_figure(Figure), 

    Data = <<
        RoleId:64,
        Bin_Figure/binary,
        CombatPower:64
    >>,
    Data.
