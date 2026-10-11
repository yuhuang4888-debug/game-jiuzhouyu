-module(pt_604).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(60401, _) ->
    {ok, []};
read(60402, _) ->
    {ok, []};
read(60403, _) ->
    {ok, []};
read(60404, _) ->
    {ok, []};
read(60405, _) ->
    {ok, []};
read(60406, _) ->
    {ok, []};
read(60410, _) ->
    {ok, []};
read(60411, Bin0) ->
    <<BuyNum:8, _Bin1/binary>> = Bin0, 
    {ok, [BuyNum]};
read(60412, _) ->
    {ok, []};
read(60413, Bin0) ->
    <<SkillId:32, _Bin1/binary>> = Bin0, 
    {ok, [SkillId]};
read(60415, _) ->
    {ok, []};
read(60416, _) ->
    {ok, []};
read(60417, Bin0) ->
    <<CycleIndex:16, _Bin1/binary>> = Bin0, 
    {ok, [CycleIndex]};
read(60419, _) ->
    {ok, []};
read(60420, _) ->
    {ok, []};
read(60421, Bin0) ->
    <<PriceId:8, Bin1/binary>> = Bin0, 
    FunArray0 = fun(<<RestBin0/binary>>) -> 
        <<PairId:8, _Args1/binary>> = RestBin0, 
        <<RoleId:64, _Args2/binary>> = _Args1, 
        {{PairId, RoleId},_Args2}
        end,
    {GuessList, _Bin2} = pt:read_array(FunArray0, Bin1),

    {ok, [PriceId, GuessList]};
read(60422, _) ->
    {ok, []};
read(60423, _) ->
    {ok, []};
read(60424, Bin0) ->
    <<Round:8, _Bin1/binary>> = Bin0, 
    {ok, [Round]};
read(60425, Bin0) ->
    <<RoleId:64, _Bin1/binary>> = Bin0, 
    {ok, [RoleId]};
read(60427, _) ->
    {ok, []};
read(60428, _) ->
    {ok, []};
read(60429, _) ->
    {ok, []};
read(_Cmd, _R) -> {error, no_match}.

write (60400,[
    Errcode,
    Errargs
]) ->
    Bin_Errargs = pt:write_string(Errargs), 

    Data = <<
        Errcode:32,
        Bin_Errargs/binary
    >>,
    {ok, pt:pack(60400, Data)};

write (60401,[
    Stage,
    EndTime
]) ->
    Data = <<
        Stage:8,
        EndTime:32
    >>,
    {ok, pt:pack(60401, Data)};

write (60402,[
    MyPower,
    MinPower
]) ->
    Data = <<
        MyPower:32,
        MinPower:32
    >>,
    {ok, pt:pack(60402, Data)};

write (60403,[
    IsApply,
    MyPower,
    MinPower
]) ->
    Data = <<
        IsApply:32,
        MyPower:32,
        MinPower:32
    >>,
    {ok, pt:pack(60403, Data)};

write (60404,[
    CycleIndex,
    IsApply,
    IsLost,
    MyRound
]) ->
    Data = <<
        CycleIndex:16,
        IsApply:32,
        IsLost:8,
        MyRound:8
    >>,
    {ok, pt:pack(60404, Data)};

write (60405,[
]) ->
    Data = <<
    >>,
    {ok, pt:pack(60405, Data)};

write (60406,[
    Stage,
    RoundIndex,
    Win,
    MyRound,
    LifeNum
]) ->
    Data = <<
        Stage:8,
        RoundIndex:8,
        Win:8,
        MyRound:8,
        LifeNum:8
    >>,
    {ok, pt:pack(60406, Data)};

write (60407,[
    LifeInfo
]) ->
    BinList_LifeInfo = [
        item_to_bin_0(LifeInfo_Item) || LifeInfo_Item <- LifeInfo
    ], 

    LifeInfo_Len = length(LifeInfo), 
    Bin_LifeInfo = list_to_binary(BinList_LifeInfo),

    Data = <<
        LifeInfo_Len:16, Bin_LifeInfo/binary
    >>,
    {ok, pt:pack(60407, Data)};

write (60408,[
    SkillList
]) ->
    BinList_SkillList = [
        item_to_bin_1(SkillList_Item) || SkillList_Item <- SkillList
    ], 

    SkillList_Len = length(SkillList), 
    Bin_SkillList = list_to_binary(BinList_SkillList),

    Data = <<
        SkillList_Len:16, Bin_SkillList/binary
    >>,
    {ok, pt:pack(60408, Data)};

write (60409,[
    Res,
    MyRound,
    Reason
]) ->
    Data = <<
        Res:8,
        MyRound:8,
        Reason:8
    >>,
    {ok, pt:pack(60409, Data)};

write (60410,[
]) ->
    Data = <<
    >>,
    {ok, pt:pack(60410, Data)};

write (60411,[
    LifeNum
]) ->
    Data = <<
        LifeNum:8
    >>,
    {ok, pt:pack(60411, Data)};

write (60412,[
    CurRound,
    RoundList
]) ->
    BinList_RoundList = [
        item_to_bin_2(RoundList_Item) || RoundList_Item <- RoundList
    ], 

    RoundList_Len = length(RoundList), 
    Bin_RoundList = list_to_binary(BinList_RoundList),

    Data = <<
        CurRound:8,
        RoundList_Len:16, Bin_RoundList/binary
    >>,
    {ok, pt:pack(60412, Data)};

write (60413,[
    SkillId,
    NextPrice,
    NextUsedTime
]) ->
    Data = <<
        SkillId:32,
        NextPrice:32,
        NextUsedTime:32
    >>,
    {ok, pt:pack(60413, Data)};

write (60414,[
    RoleName,
    SkillId
]) ->
    Bin_RoleName = pt:write_string(RoleName), 

    Data = <<
        Bin_RoleName/binary,
        SkillId:32
    >>,
    {ok, pt:pack(60414, Data)};

write (60415,[
    Stage,
    EndTime
]) ->
    Data = <<
        Stage:8,
        EndTime:32
    >>,
    {ok, pt:pack(60415, Data)};

write (60416,[
    RoleList
]) ->
    BinList_RoleList = [
        item_to_bin_4(RoleList_Item) || RoleList_Item <- RoleList
    ], 

    RoleList_Len = length(RoleList), 
    Bin_RoleList = list_to_binary(BinList_RoleList),

    Data = <<
        RoleList_Len:16, Bin_RoleList/binary
    >>,
    {ok, pt:pack(60416, Data)};

write (60417,[
    CycleIndex,
    WinnerId,
    WinnerName,
    WinnerServerName,
    WinnerPower,
    WinnerCareer,
    WinnerSex,
    WinnerTurn,
    WinnerPic,
    WinnerPicVer,
    WinnerLvModel,
    WinnerFashion,
    GodWeaponModel,
    WingFigure,
    RoleList
]) ->
    Bin_WinnerName = pt:write_string(WinnerName), 

    Bin_WinnerServerName = pt:write_string(WinnerServerName), 

    Bin_WinnerPic = pt:write_string(WinnerPic), 

    BinList_WinnerLvModel = [
        item_to_bin_5(WinnerLvModel_Item) || WinnerLvModel_Item <- WinnerLvModel
    ], 

    WinnerLvModel_Len = length(WinnerLvModel), 
    Bin_WinnerLvModel = list_to_binary(BinList_WinnerLvModel),

    BinList_WinnerFashion = [
        item_to_bin_6(WinnerFashion_Item) || WinnerFashion_Item <- WinnerFashion
    ], 

    WinnerFashion_Len = length(WinnerFashion), 
    Bin_WinnerFashion = list_to_binary(BinList_WinnerFashion),

    BinList_GodWeaponModel = [
        item_to_bin_7(GodWeaponModel_Item) || GodWeaponModel_Item <- GodWeaponModel
    ], 

    GodWeaponModel_Len = length(GodWeaponModel), 
    Bin_GodWeaponModel = list_to_binary(BinList_GodWeaponModel),

    BinList_RoleList = [
        item_to_bin_8(RoleList_Item) || RoleList_Item <- RoleList
    ], 

    RoleList_Len = length(RoleList), 
    Bin_RoleList = list_to_binary(BinList_RoleList),

    Data = <<
        CycleIndex:16,
        WinnerId:64,
        Bin_WinnerName/binary,
        Bin_WinnerServerName/binary,
        WinnerPower:32,
        WinnerCareer:8,
        WinnerSex:8,
        WinnerTurn:8,
        Bin_WinnerPic/binary,
        WinnerPicVer:32,
        WinnerLvModel_Len:16, Bin_WinnerLvModel/binary,
        WinnerFashion_Len:16, Bin_WinnerFashion/binary,
        GodWeaponModel_Len:16, Bin_GodWeaponModel/binary,
        WingFigure:32,
        RoleList_Len:16, Bin_RoleList/binary
    >>,
    {ok, pt:pack(60417, Data)};

write (60418,[
    CurRound
]) ->
    Data = <<
        CurRound:8
    >>,
    {ok, pt:pack(60418, Data)};

write (60419,[
    ApplyList
]) ->
    BinList_ApplyList = [
        item_to_bin_9(ApplyList_Item) || ApplyList_Item <- ApplyList
    ], 

    ApplyList_Len = length(ApplyList), 
    Bin_ApplyList = list_to_binary(BinList_ApplyList),

    Data = <<
        ApplyList_Len:16, Bin_ApplyList/binary
    >>,
    {ok, pt:pack(60419, Data)};

write (60420,[
    Round,
    MinNum,
    PriceId,
    EndTime,
    GuessList
]) ->
    BinList_GuessList = [
        item_to_bin_10(GuessList_Item) || GuessList_Item <- GuessList
    ], 

    GuessList_Len = length(GuessList), 
    Bin_GuessList = list_to_binary(BinList_GuessList),

    Data = <<
        Round:8,
        MinNum:8,
        PriceId:8,
        EndTime:32,
        GuessList_Len:16, Bin_GuessList/binary
    >>,
    {ok, pt:pack(60420, Data)};

write (60421,[
    Res,
    GuessList
]) ->
    BinList_GuessList = [
        item_to_bin_11(GuessList_Item) || GuessList_Item <- GuessList
    ], 

    GuessList_Len = length(GuessList), 
    Bin_GuessList = list_to_binary(BinList_GuessList),

    Data = <<
        Res:32,
        GuessList_Len:16, Bin_GuessList/binary
    >>,
    {ok, pt:pack(60421, Data)};

write (60422,[
    HasAward,
    HasGuess
]) ->
    Data = <<
        HasAward:8,
        HasGuess:8
    >>,
    {ok, pt:pack(60422, Data)};

write (60423,[
    GuessList
]) ->
    BinList_GuessList = [
        item_to_bin_12(GuessList_Item) || GuessList_Item <- GuessList
    ], 

    GuessList_Len = length(GuessList), 
    Bin_GuessList = list_to_binary(BinList_GuessList),

    Data = <<
        GuessList_Len:16, Bin_GuessList/binary
    >>,
    {ok, pt:pack(60423, Data)};

write (60424,[
    Round
]) ->
    Data = <<
        Round:8
    >>,
    {ok, pt:pack(60424, Data)};

write (60425,[
]) ->
    Data = <<
    >>,
    {ok, pt:pack(60425, Data)};

write (60426,[
    RoleName
]) ->
    Bin_RoleName = pt:write_string(RoleName), 

    Data = <<
        Bin_RoleName/binary
    >>,
    {ok, pt:pack(60426, Data)};



write (60428,[
    EndTime
]) ->
    Data = <<
        EndTime:32
    >>,
    {ok, pt:pack(60428, Data)};

write (60429,[
    ServerId,
    RoleId
]) ->
    Data = <<ServerId:16, RoleId:64>>,
    {ok, pt:pack(60429, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 ({
    RoleId,
    LifeNum
}) ->
    Data = <<
        RoleId:64,
        LifeNum:8
    >>,
    Data.
item_to_bin_1 ({
    SkillId,
    NextPrice,
    NextUsedTime
}) ->
    Data = <<
        SkillId:32,
        NextPrice:32,
        NextUsedTime:16
    >>,
    Data.
item_to_bin_2 ({
    Round,
    PairList
}) ->
    BinList_PairList = [
        item_to_bin_3(PairList_Item) || PairList_Item <- PairList
    ], 

    PairList_Len = length(PairList), 
    Bin_PairList = list_to_binary(BinList_PairList),

    Data = <<
        Round:8,
        PairList_Len:16, Bin_PairList/binary
    >>,
    Data.
item_to_bin_3 ({
    RoleId1,
    Name1,
    ServerName1,
    Power1,
    Sex1,
    Career1,
    Turn1,
    Pic1,
    Picvsn1,
    RoleId2,
    Name2,
    ServerName2,
    Power2,
    Sex2,
    Career2,
    Turn2,
    Pic2,
    Picvsn2
}) ->
    Bin_Name1 = pt:write_string(Name1), 

    Bin_ServerName1 = pt:write_string(ServerName1), 

    Bin_Pic1 = pt:write_string(Pic1), 

    Bin_Name2 = pt:write_string(Name2), 

    Bin_ServerName2 = pt:write_string(ServerName2), 

    Bin_Pic2 = pt:write_string(Pic2), 

    Data = <<
        RoleId1:64,
        Bin_Name1/binary,
        Bin_ServerName1/binary,
        Power1:32,
        Sex1:8,
        Career1:8,
        Turn1:8,
        Bin_Pic1/binary,
        Picvsn1:32,
        RoleId2:64,
        Bin_Name2/binary,
        Bin_ServerName2/binary,
        Power2:32,
        Sex2:8,
        Career2:8,
        Turn2:8,
        Bin_Pic2/binary,
        Picvsn2:32
    >>,
    Data.
item_to_bin_4 ({
    RoleName,
    ServerName
}) ->
    Bin_RoleName = pt:write_string(RoleName), 

    Bin_ServerName = pt:write_string(ServerName), 

    Data = <<
        Bin_RoleName/binary,
        Bin_ServerName/binary
    >>,
    Data.
item_to_bin_5 ({
    PartPos,
    LevelModelId
}) ->
    Data = <<
        PartPos:8,
        LevelModelId:32
    >>,
    Data.
item_to_bin_6 ({
    PartPos,
    FashionModelId,
    Color
}) ->
    Data = <<
        PartPos:8,
        FashionModelId:32,
        Color:32
    >>,
    Data.
item_to_bin_7 ({
    PartPos,
    GodweaponId
}) ->
    Data = <<
        PartPos:8,
        GodweaponId:32
    >>,
    Data.
item_to_bin_8 ({
    RoleName,
    ServerName,
    GuildName
}) ->
    Bin_RoleName = pt:write_string(RoleName), 

    Bin_ServerName = pt:write_string(ServerName), 

    Bin_GuildName = pt:write_string(GuildName), 

    Data = <<
        Bin_RoleName/binary,
        Bin_ServerName/binary,
        Bin_GuildName/binary
    >>,
    Data.
item_to_bin_9 ({
    RoleId,
    RoleName,
    ServerName,
    GuildName,
    Lv,
    Power
}) ->
    Bin_RoleName = pt:write_string(RoleName), 

    Bin_ServerName = pt:write_string(ServerName), 

    Bin_GuildName = pt:write_string(GuildName), 

    Data = <<
        RoleId:64,
        Bin_RoleName/binary,
        Bin_ServerName/binary,
        Bin_GuildName/binary,
        Lv:16,
        Power:32
    >>,
    Data.
item_to_bin_10 ({
    PairId,
    RoleId,
    Id1,
    Name1,
    ServerName1,
    Sex1,
    Career1,
    Turn1,
    Pic1,
    Picvsn1,
    Power1,
    Id2,
    Name2,
    ServerName2,
    Sex2,
    Career2,
    Turn2,
    Pic2,
    Picvsn2,
    Power2
}) ->
    Bin_Name1 = pt:write_string(Name1), 

    Bin_ServerName1 = pt:write_string(ServerName1), 

    Bin_Pic1 = pt:write_string(Pic1), 

    Bin_Name2 = pt:write_string(Name2), 

    Bin_ServerName2 = pt:write_string(ServerName2), 

    Bin_Pic2 = pt:write_string(Pic2), 

    Data = <<
        PairId:8,
        RoleId:64,
        Id1:64,
        Bin_Name1/binary,
        Bin_ServerName1/binary,
        Sex1:8,
        Career1:8,
        Turn1:8,
        Bin_Pic1/binary,
        Picvsn1:32,
        Power1:32,
        Id2:64,
        Bin_Name2/binary,
        Bin_ServerName2/binary,
        Sex2:8,
        Career2:8,
        Turn2:8,
        Bin_Pic2/binary,
        Picvsn2:32,
        Power2:32
    >>,
    Data.
item_to_bin_11 ({
    PairId,
    RoleId
}) ->
    Data = <<
        PairId:8,
        RoleId:64
    >>,
    Data.
item_to_bin_12 ({
    Round,
    PriceId,
    State,
    GuestItems,
    Rewards
}) ->
    BinList_GuestItems = [
        item_to_bin_13(GuestItems_Item) || GuestItems_Item <- GuestItems
    ], 

    GuestItems_Len = length(GuestItems), 
    Bin_GuestItems = list_to_binary(BinList_GuestItems),

    Bin_Rewards = pt:write_object_list(Rewards), 

    Data = <<
        Round:8,
        PriceId:8,
        State:8,
        GuestItems_Len:16, Bin_GuestItems/binary,
        Bin_Rewards/binary
    >>,
    Data.
item_to_bin_13 ({
    RoleId,
    WinId,
    Sex,
    Career,
    Turn,
    Pic,
    Picvsn
}) ->
    Bin_Pic = pt:write_string(Pic), 

    Data = <<
        RoleId:64,
        WinId:64,
        Sex:8,
        Career:8,
        Turn:8,
        Bin_Pic/binary,
        Picvsn:32
    >>,
    Data.
