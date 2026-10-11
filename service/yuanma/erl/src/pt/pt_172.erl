-module(pt_172).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(17200, Bin0) ->
    <<Page:8, _Bin1/binary>> = Bin0, 
    {ok, [Page]};
read(17201, Bin0) ->
    <<FollowRoleId:64, Bin1/binary>> = Bin0, 
    <<Type:8, _Bin2/binary>> = Bin1, 
    {ok, [FollowRoleId, Type]};
read(17202, Bin0) ->
    {Msg, Bin1} = pt:read_string(Bin0), 
    <<Type:8, Bin2/binary>> = Bin1, 
    FunArray0 = fun(<<RestBin0/binary>>) -> 
        <<TagId:8, _Args1/binary>> = RestBin0, 
        <<TagSubid:8, _Args2/binary>> = _Args1, 
        {{TagId, TagSubid},_Args2}
        end,
    {TagList, _Bin3} = pt:read_array(FunArray0, Bin2),

    {ok, [Msg, Type, TagList]};
read(17203, Bin0) ->
    <<Type:8, Bin1/binary>> = Bin0, 
    {Msg, _Bin2} = pt:read_string(Bin1), 
    {ok, [Type, Msg]};
read(17204, Bin0) ->
    {Msg, Bin1} = pt:read_string(Bin0), 
    FunArray0 = fun(<<RestBin0/binary>>) -> 
        <<TagId:8, _Args1/binary>> = RestBin0, 
        <<TagSubid:8, _Args2/binary>> = _Args1, 
        {{TagId, TagSubid},_Args2}
        end,
    {TagList, _Bin2} = pt:read_array(FunArray0, Bin1),

    {ok, [Msg, TagList]};
read(17205, Bin0) ->
    <<RoleId:64, _Bin1/binary>> = Bin0, 
    {ok, [RoleId]};
read(17210, _) ->
    {ok, []};
read(17211, _) ->
    {ok, []};
read(17212, Bin0) ->
    <<GoodsTypeId:32, _Bin1/binary>> = Bin0, 
    {ok, [GoodsTypeId]};
read(17213, _) ->
    {ok, []};
read(17220, Bin0) ->
    <<RoleId:64, _Bin1/binary>> = Bin0, 
    {ok, [RoleId]};
read(17221, Bin0) ->
    <<RoleId:64, Bin1/binary>> = Bin0, 
    {Msg, _Bin2} = pt:read_string(Bin1), 
    {ok, [RoleId, Msg]};
read(17223, Bin0) ->
    <<RoleId:64, Bin1/binary>> = Bin0, 
    <<Type:8, _Bin2/binary>> = Bin1, 
    {ok, [RoleId, Type]};
read(17225, Bin0) ->
    <<RoleId:64, _Bin1/binary>> = Bin0, 
    {ok, [RoleId]};
read(17226, _) ->
    {ok, []};
read(17230, Bin0) ->
    <<RoleId:64, _Bin1/binary>> = Bin0, 
    {ok, [RoleId]};
read(17231, Bin0) ->
    <<RoleId:64, Bin1/binary>> = Bin0, 
    <<WeddingType:8, Bin2/binary>> = Bin1, 
    {Msg, Bin3} = pt:read_string(Bin2), 
    <<IfAa:8, _Bin4/binary>> = Bin3, 
    {ok, [RoleId, WeddingType, Msg, IfAa]};
read(17232, _) ->
    {ok, []};
read(17233, _) ->
    {ok, []};
read(17234, Bin0) ->
    <<DivorceType:8, _Bin1/binary>> = Bin0, 
    {ok, [DivorceType]};
read(17235, Bin0) ->
    <<AnswerType:8, _Bin1/binary>> = Bin0, 
    {ok, [AnswerType]};
read(17236, Bin0) ->
    <<Id:8, _Bin1/binary>> = Bin0, 
    {ok, [Id]};
read(17237, _) ->
    {ok, []};
read(17238, _) ->
    {ok, []};
read(17239, Bin0) ->
    <<CountType:8, _Bin1/binary>> = Bin0, 
    {ok, [CountType]};
read(17240, _) ->
    {ok, []};
read(17241, _) ->
    {ok, []};
read(17242, Bin0) ->
    <<TypeId:8, _Bin1/binary>> = Bin0, 
    {ok, [TypeId]};
read(17243, Bin0) ->
    <<RoleIdM:64, Bin1/binary>> = Bin0, 
    <<RoleIdW:64, Bin2/binary>> = Bin1, 
    <<DogFoodId:32, _Bin3/binary>> = Bin2, 
    {ok, [RoleIdM, RoleIdW, DogFoodId]};
read(17245, Bin0) ->
    <<Type:8, Bin1/binary>> = Bin0, 
    <<DunId:32, _Bin2/binary>> = Bin1, 
    {ok, [Type, DunId]};
read(17249, _) ->
    {ok, []};
read(17250, _) ->
    {ok, []};
read(17251, Bin0) ->
    <<DayId:8, Bin1/binary>> = Bin0, 
    <<TimeId:8, Bin2/binary>> = Bin1, 
    <<WeddingType:8, _Bin3/binary>> = Bin2, 
    {ok, [DayId, TimeId, WeddingType]};
read(17252, _) ->
    {ok, []};
read(17253, Bin0) ->
    FunArray0 = fun(<<RestBin0/binary>>) -> 
        <<RoleId:64, _Args1/binary>> = RestBin0, 
        {RoleId,_Args1}
        end,
    {InviteList, _Bin1} = pt:read_array(FunArray0, Bin0),

    {ok, [InviteList]};
read(17254, _) ->
    {ok, []};
read(17255, Bin0) ->
    <<RoleIdM:64, Bin1/binary>> = Bin0, 
    <<AnswerType:8, _Bin2/binary>> = Bin1, 
    {ok, [RoleIdM, AnswerType]};
read(17256, _) ->
    {ok, []};
read(17257, Bin0) ->
    <<RoleIdM:64, _Bin1/binary>> = Bin0, 
    {ok, [RoleIdM]};
read(17258, Bin0) ->
    <<RoleIdM:64, _Bin1/binary>> = Bin0, 
    {ok, [RoleIdM]};
read(17259, Bin0) ->
    <<Num:8, _Bin1/binary>> = Bin0, 
    {ok, [Num]};
read(17260, Bin0) ->
    FunArray0 = fun(<<RestBin0/binary>>) -> 
        <<Type:8, _Args1/binary>> = RestBin0, 
        {Type,_Args1}
        end,
    {TypeList, _Bin1} = pt:read_array(FunArray0, Bin0),

    {ok, [TypeList]};
read(17261, Bin0) ->
    FunArray0 = fun(<<RestBin0/binary>>) -> 
        <<RoleId:64, _Args1/binary>> = RestBin0, 
        <<AnswerType:8, _Args2/binary>> = _Args1, 
        {{RoleId, AnswerType},_Args2}
        end,
    {GuestRoleId, _Bin1} = pt:read_array(FunArray0, Bin0),

    {ok, [GuestRoleId]};
read(17262, _) ->
    {ok, []};
read(17263, Bin0) ->
    <<RoleIdM:64, _Bin1/binary>> = Bin0, 
    {ok, [RoleIdM]};
read(17264, _) ->
    {ok, []};
read(17265, _) ->
    {ok, []};
read(17266, Bin0) ->
    <<CandiesType:8, _Bin1/binary>> = Bin0, 
    {ok, [CandiesType]};
read(17267, Bin0) ->
    <<FiresType:8, _Bin1/binary>> = Bin0, 
    {ok, [FiresType]};
read(17270, Bin0) ->
    {Msg, Bin1} = pt:read_string(Bin0), 
    <<TkTime:32, _Bin2/binary>> = Bin1, 
    {ok, [Msg, TkTime]};
read(17272, _) ->
    {ok, []};
read(17274, _) ->
    {ok, []};
read(17275, _) ->
    {ok, []};
read(17280, _) ->
    {ok, []};
read(17281, _) ->
    {ok, []};
read(17282, _) ->
    {ok, []};
read(17283, Bin0) ->
    <<GoodsTypeId:32, _Bin1/binary>> = Bin0, 
    {ok, [GoodsTypeId]};
read(17284, _) ->
    {ok, []};
read(17285, _) ->
    {ok, []};
read(17286, _) ->
    {ok, []};
read(17287, _) ->
    {ok, []};
read(17288, Bin0) ->
    <<ImageId:8, _Bin1/binary>> = Bin0, 
    {ok, [ImageId]};
read(17289, Bin0) ->
    <<ImageId:8, Bin1/binary>> = Bin0, 
    <<GoodsTypeId:32, _Bin2/binary>> = Bin1, 
    {ok, [ImageId, GoodsTypeId]};
read(17290, Bin0) ->
    <<ImageId:8, _Bin1/binary>> = Bin0, 
    {ok, [ImageId]};
read(17291, Bin0) ->
    <<ChageStage:8, _Bin1/binary>> = Bin0, 
    {ok, [ChageStage]};
read(17292, Bin0) ->
    <<ImageId:8, _Bin1/binary>> = Bin0, 
    {ok, [ImageId]};
read(17293, _) ->
    {ok, []};
read(17295, Bin0) ->
    <<DunId:32, _Bin1/binary>> = Bin0, 
    {ok, [DunId]};
read(17297, Bin0) ->
    <<Agree:8, Bin1/binary>> = Bin0, 
    <<DunId:32, _Bin2/binary>> = Bin1, 
    {ok, [Agree, DunId]};
read(17298, _) ->
    {ok, []};
read(_Cmd, _R) -> {error, no_match}.

write (17200,[
    Code,
    Page,
    OwnPopularity,
    AskFollowTime,
    AskFlowerTime,
    LessFreeTimes,
    PlayerList
]) ->
    BinList_PlayerList = [
        item_to_bin_0(PlayerList_Item) || PlayerList_Item <- PlayerList
    ], 

    PlayerList_Len = length(PlayerList), 
    Bin_PlayerList = list_to_binary(BinList_PlayerList),

    Data = <<
        Code:32,
        Page:8,
        OwnPopularity:32,
        AskFollowTime:32,
        AskFlowerTime:32,
        LessFreeTimes:8,
        PlayerList_Len:16, Bin_PlayerList/binary
    >>,
    {ok, pt:pack(17200, Data)};

write (17201,[
    Code,
    FollowRoleId,
    Type
]) ->
    Data = <<
        Code:32,
        FollowRoleId:64,
        Type:8
    >>,
    {ok, pt:pack(17201, Data)};

write (17202,[
    Code,
    Type
]) ->
    Data = <<
        Code:32,
        Type:8
    >>,
    {ok, pt:pack(17202, Data)};

write (17203,[
    Code,
    Type,
    Time
]) ->
    Data = <<
        Code:32,
        Type:8,
        Time:32
    >>,
    {ok, pt:pack(17203, Data)};

write (17204,[
    Code,
    Msg,
    TagList
]) ->
    Bin_Msg = pt:write_string(Msg), 

    BinList_TagList = [
        item_to_bin_2(TagList_Item) || TagList_Item <- TagList
    ], 

    TagList_Len = length(TagList), 
    Bin_TagList = list_to_binary(BinList_TagList),

    Data = <<
        Code:32,
        Bin_Msg/binary,
        TagList_Len:16, Bin_TagList/binary
    >>,
    {ok, pt:pack(17204, Data)};

write (17205,[
    RoleId,
    GuildId,
    GuildName
]) ->
    Bin_GuildName = pt:write_string(GuildName), 

    Data = <<
        RoleId:64,
        GuildId:64,
        Bin_GuildName/binary
    >>,
    {ok, pt:pack(17205, Data)};

write (17210,[
    Code,
    Stage,
    Star,
    PrayNum,
    RingCombatPower,
    PolishList,
    AttrList
]) ->
    BinList_PolishList = [
        item_to_bin_3(PolishList_Item) || PolishList_Item <- PolishList
    ], 

    PolishList_Len = length(PolishList), 
    Bin_PolishList = list_to_binary(BinList_PolishList),

    BinList_AttrList = [
        item_to_bin_4(AttrList_Item) || AttrList_Item <- AttrList
    ], 

    AttrList_Len = length(AttrList), 
    Bin_AttrList = list_to_binary(BinList_AttrList),

    Data = <<
        Code:32,
        Stage:8,
        Star:8,
        PrayNum:32,
        RingCombatPower:32,
        PolishList_Len:16, Bin_PolishList/binary,
        AttrList_Len:16, Bin_AttrList/binary
    >>,
    {ok, pt:pack(17210, Data)};

write (17211,[
    Code,
    Stage,
    Star,
    PrayNum
]) ->
    Data = <<
        Code:32,
        Stage:8,
        Star:8,
        PrayNum:32
    >>,
    {ok, pt:pack(17211, Data)};

write (17212,[
    Code,
    GoodsTypeId,
    Stage,
    Star,
    PrayNum
]) ->
    Data = <<
        Code:32,
        GoodsTypeId:32,
        Stage:8,
        Star:8,
        PrayNum:32
    >>,
    {ok, pt:pack(17212, Data)};

write (17213,[
    Code,
    Stage,
    Star,
    PrayNum
]) ->
    Data = <<
        Code:32,
        Stage:8,
        Star:8,
        PrayNum:32
    >>,
    {ok, pt:pack(17213, Data)};

write (17220,[
    Code,
    RoleId,
    Name,
    Lv,
    CombatPower,
    Sex,
    Vip,
    Career,
    Turn
]) ->
    Bin_Name = pt:write_string(Name), 

    Data = <<
        Code:32,
        RoleId:64,
        Bin_Name/binary,
        Lv:16,
        CombatPower:32,
        Sex:8,
        Vip:32,
        Career:8,
        Turn:8
    >>,
    {ok, pt:pack(17220, Data)};

write (17221,[
    Code
]) ->
    Data = <<
        Code:32
    >>,
    {ok, pt:pack(17221, Data)};

write (17222,[
    RoleId,
    Name,
    Lv,
    CombatPower,
    Sex,
    Vip,
    Career,
    Turn,
    Picture,
    PictureVer,
    Type,
    ProposeType,
    Msg,
    IfAa,
    CostList
]) ->
    Bin_Name = pt:write_string(Name), 

    Bin_Picture = pt:write_string(Picture), 

    Bin_Msg = pt:write_string(Msg), 

    BinList_CostList = [
        item_to_bin_5(CostList_Item) || CostList_Item <- CostList
    ], 

    CostList_Len = length(CostList), 
    Bin_CostList = list_to_binary(BinList_CostList),

    Data = <<
        RoleId:64,
        Bin_Name/binary,
        Lv:16,
        CombatPower:32,
        Sex:8,
        Vip:32,
        Career:8,
        Turn:8,
        Bin_Picture/binary,
        PictureVer:32,
        Type:8,
        ProposeType:8,
        Bin_Msg/binary,
        IfAa:8,
        CostList_Len:16, Bin_CostList/binary
    >>,
    {ok, pt:pack(17222, Data)};

write (17223,[
    Code,
    RoleId,
    Type
]) ->
    Data = <<
        Code:32,
        RoleId:64,
        Type:8
    >>,
    {ok, pt:pack(17223, Data)};

write (17224,[
    RoleId,
    Type,
    AnswerType
]) ->
    Data = <<
        RoleId:64,
        Type:8,
        AnswerType:8
    >>,
    {ok, pt:pack(17224, Data)};

write (17225,[
    Code
]) ->
    Data = <<
        Code:32
    >>,
    {ok, pt:pack(17225, Data)};

write (17226,[
    BiaobaiList,
    BiaobaiAnswerList
]) ->
    BinList_BiaobaiList = [
        item_to_bin_6(BiaobaiList_Item) || BiaobaiList_Item <- BiaobaiList
    ], 

    BiaobaiList_Len = length(BiaobaiList), 
    Bin_BiaobaiList = list_to_binary(BinList_BiaobaiList),

    BinList_BiaobaiAnswerList = [
        item_to_bin_8(BiaobaiAnswerList_Item) || BiaobaiAnswerList_Item <- BiaobaiAnswerList
    ], 

    BiaobaiAnswerList_Len = length(BiaobaiAnswerList), 
    Bin_BiaobaiAnswerList = list_to_binary(BinList_BiaobaiAnswerList),

    Data = <<
        BiaobaiList_Len:16, Bin_BiaobaiList/binary,
        BiaobaiAnswerList_Len:16, Bin_BiaobaiAnswerList/binary
    >>,
    {ok, pt:pack(17226, Data)};

write (17229,[
    List
]) ->
    BinList_List = [
        item_to_bin_9(List_Item) || List_Item <- List
    ], 

    List_Len = length(List), 
    Bin_List = list_to_binary(BinList_List),

    Data = <<
        List_Len:16, Bin_List/binary
    >>,
    {ok, pt:pack(17229, Data)};

write (17230,[
    Code,
    RoleId,
    Name,
    Lv,
    CombatPower,
    Sex,
    Vip,
    Career,
    Turn
]) ->
    Bin_Name = pt:write_string(Name), 

    Data = <<
        Code:32,
        RoleId:64,
        Bin_Name/binary,
        Lv:16,
        CombatPower:64,
        Sex:8,
        Vip:32,
        Career:8,
        Turn:8
    >>,
    {ok, pt:pack(17230, Data)};

write (17231,[
    Code,
    RoleId
]) ->
    Data = <<
        Code:32,
        RoleId:64
    >>,
    {ok, pt:pack(17231, Data)};

write (17232,[
    Code,
    RoleId,
    CombatPower,
    Figure,
    Type,
    NowWeddingState,
    AnniversaryTime,
    LoveNum,
    FirstMarriage
]) ->
    Bin_Figure = pt:write_figure(Figure), 

    Data = <<
        Code:32,
        RoleId:64,
        CombatPower:64,
        Bin_Figure/binary,
        Type:8,
        NowWeddingState:8,
        AnniversaryTime:32,
        LoveNum:32,
        FirstMarriage:8
    >>,
    {ok, pt:pack(17232, Data)};

write (17233,[
    Code,
    Type,
    CostType,
    CostNum
]) ->
    Data = <<
        Code:32,
        Type:8,
        CostType:16,
        CostNum:32
    >>,
    {ok, pt:pack(17233, Data)};

write (17234,[
    Code
]) ->
    Data = <<
        Code:32
    >>,
    {ok, pt:pack(17234, Data)};

write (17235,[
    Code,
    AnswerType
]) ->
    Data = <<
        Code:32,
        AnswerType:8
    >>,
    {ok, pt:pack(17235, Data)};

write (17236,[
    Code,
    Id
]) ->
    Data = <<
        Code:32,
        Id:8
    >>,
    {ok, pt:pack(17236, Data)};

write (17237,[
    Code
]) ->
    Data = <<
        Code:32
    >>,
    {ok, pt:pack(17237, Data)};

write (17238,[
    LoveGiftTimeS,
    LoveGiftTimeO,
    GiftState
]) ->
    BinList_GiftState = [
        item_to_bin_10(GiftState_Item) || GiftState_Item <- GiftState
    ], 

    GiftState_Len = length(GiftState), 
    Bin_GiftState = list_to_binary(BinList_GiftState),

    Data = <<
        LoveGiftTimeS:32,
        LoveGiftTimeO:32,
        GiftState_Len:16, Bin_GiftState/binary
    >>,
    {ok, pt:pack(17238, Data)};

write (17239,[
    Code,
    CountType,
    Reward
]) ->
    Bin_Reward = pt:write_object_list(Reward), 

    Data = <<
        Code:32,
        CountType:8,
        Bin_Reward/binary
    >>,
    {ok, pt:pack(17239, Data)};

write (17240,[
    Code
]) ->
    Data = <<
        Code:32
    >>,
    {ok, pt:pack(17240, Data)};

write (17241,[
    Code,
    Stage,
    Heart,
    LoveNum,
    CombatPower
]) ->
    Data = <<
        Code:32,
        Stage:8,
        Heart:8,
        LoveNum:32,
        CombatPower:64
    >>,
    {ok, pt:pack(17241, Data)};

write (17242,[
    Code
]) ->
    Data = <<
        Code:32
    >>,
    {ok, pt:pack(17242, Data)};

write (17243,[
    Code,
    RoleIdM,
    RoleIdW,
    DogFoodId,
    GoodsNum
]) ->
    Data = <<
        Code:32,
        RoleIdM:64,
        RoleIdW:64,
        DogFoodId:32,
        GoodsNum:32
    >>,
    {ok, pt:pack(17243, Data)};

write (17244,[
    Type,
    RoleIdM,
    RoleIdW,
    DogFoodId,
    NameM,
    NameW,
    Time
]) ->
    Bin_NameM = pt:write_string(NameM), 

    Bin_NameW = pt:write_string(NameW), 

    Data = <<
        Type:8,
        RoleIdM:64,
        RoleIdW:64,
        DogFoodId:32,
        Bin_NameM/binary,
        Bin_NameW/binary,
        Time:32
    >>,
    {ok, pt:pack(17244, Data)};

write (17245,[
    Code,
    Type,
    DunId
]) ->
    Data = <<
        Code:32,
        Type:8,
        DunId:32
    >>,
    {ok, pt:pack(17245, Data)};

write (17246,[
    Code,
    List,
    EnterTime
]) ->
    BinList_List = [
        item_to_bin_11(List_Item) || List_Item <- List
    ], 

    List_Len = length(List), 
    Bin_List = list_to_binary(BinList_List),

    Data = <<
        Code:32,
        List_Len:16, Bin_List/binary,
        EnterTime:8
    >>,
    {ok, pt:pack(17246, Data)};

write (17249,[
    NowWeddingState,
    BeginTime
]) ->
    Data = <<
        NowWeddingState:8,
        BeginTime:32
    >>,
    {ok, pt:pack(17249, Data)};

write (17250,[
    Code,
    NowWeddingState,
    MyWeddingTimes,
    DayList
]) ->
    BinList_MyWeddingTimes = [
        item_to_bin_12(MyWeddingTimes_Item) || MyWeddingTimes_Item <- MyWeddingTimes
    ], 

    MyWeddingTimes_Len = length(MyWeddingTimes), 
    Bin_MyWeddingTimes = list_to_binary(BinList_MyWeddingTimes),

    BinList_DayList = [
        item_to_bin_13(DayList_Item) || DayList_Item <- DayList
    ], 

    DayList_Len = length(DayList), 
    Bin_DayList = list_to_binary(BinList_DayList),

    Data = <<
        Code:32,
        NowWeddingState:8,
        MyWeddingTimes_Len:16, Bin_MyWeddingTimes/binary,
        DayList_Len:16, Bin_DayList/binary
    >>,
    {ok, pt:pack(17250, Data)};

write (17251,[
    Code,
    Time,
    WeddingType,
    ManList,
    WomanList
]) ->
    BinList_ManList = [
        item_to_bin_16(ManList_Item) || ManList_Item <- ManList
    ], 

    ManList_Len = length(ManList), 
    Bin_ManList = list_to_binary(BinList_ManList),

    BinList_WomanList = [
        item_to_bin_17(WomanList_Item) || WomanList_Item <- WomanList
    ], 

    WomanList_Len = length(WomanList), 
    Bin_WomanList = list_to_binary(BinList_WomanList),

    Data = <<
        Code:32,
        Time:32,
        WeddingType:8,
        ManList_Len:16, Bin_ManList/binary,
        WomanList_Len:16, Bin_WomanList/binary
    >>,
    {ok, pt:pack(17251, Data)};

write (17252,[
    Code,
    MyRoleId,
    MyName,
    MyPicture,
    MyPictureVer,
    LoverRoleId,
    LoverName,
    LoverPicture,
    LoverPictureVer,
    WeddingType,
    WeddingTime,
    IfOrderAgain,
    LessInviteNum,
    GuestNum,
    GuestList,
    AskInviteList
]) ->
    Bin_MyName = pt:write_string(MyName), 

    Bin_MyPicture = pt:write_string(MyPicture), 

    Bin_LoverName = pt:write_string(LoverName), 

    Bin_LoverPicture = pt:write_string(LoverPicture), 

    BinList_GuestList = [
        item_to_bin_18(GuestList_Item) || GuestList_Item <- GuestList
    ], 

    GuestList_Len = length(GuestList), 
    Bin_GuestList = list_to_binary(BinList_GuestList),

    BinList_AskInviteList = [
        item_to_bin_19(AskInviteList_Item) || AskInviteList_Item <- AskInviteList
    ], 

    AskInviteList_Len = length(AskInviteList), 
    Bin_AskInviteList = list_to_binary(BinList_AskInviteList),

    Data = <<
        Code:32,
        MyRoleId:64,
        Bin_MyName/binary,
        Bin_MyPicture/binary,
        MyPictureVer:32,
        LoverRoleId:64,
        Bin_LoverName/binary,
        Bin_LoverPicture/binary,
        LoverPictureVer:32,
        WeddingType:8,
        WeddingTime:32,
        IfOrderAgain:8,
        LessInviteNum:8,
        GuestNum:8,
        GuestList_Len:16, Bin_GuestList/binary,
        AskInviteList_Len:16, Bin_AskInviteList/binary
    >>,
    {ok, pt:pack(17252, Data)};

write (17253,[
    Code,
    InviteList
]) ->
    BinList_InviteList = [
        item_to_bin_20(InviteList_Item) || InviteList_Item <- InviteList
    ], 

    InviteList_Len = length(InviteList), 
    Bin_InviteList = list_to_binary(BinList_InviteList),

    Data = <<
        Code:32,
        InviteList_Len:16, Bin_InviteList/binary
    >>,
    {ok, pt:pack(17253, Data)};

write (17254,[
    InviteList
]) ->
    BinList_InviteList = [
        item_to_bin_21(InviteList_Item) || InviteList_Item <- InviteList
    ], 

    InviteList_Len = length(InviteList), 
    Bin_InviteList = list_to_binary(BinList_InviteList),

    Data = <<
        InviteList_Len:16, Bin_InviteList/binary
    >>,
    {ok, pt:pack(17254, Data)};

write (17255,[
    Code,
    RoleIdM,
    AnswerType
]) ->
    Data = <<
        Code:32,
        RoleIdM:64,
        AnswerType:8
    >>,
    {ok, pt:pack(17255, Data)};

write (17256,[
    Type,
    WeddingList
]) ->
    BinList_WeddingList = [
        item_to_bin_24(WeddingList_Item) || WeddingList_Item <- WeddingList
    ], 

    WeddingList_Len = length(WeddingList), 
    Bin_WeddingList = list_to_binary(BinList_WeddingList),

    Data = <<
        Type:8,
        WeddingList_Len:16, Bin_WeddingList/binary
    >>,
    {ok, pt:pack(17256, Data)};

write (17257,[
    Code
]) ->
    Data = <<
        Code:32
    >>,
    {ok, pt:pack(17257, Data)};

write (17258,[
    Code,
    RoleIdM
]) ->
    Data = <<
        Code:32,
        RoleIdM:64
    >>,
    {ok, pt:pack(17258, Data)};

write (17259,[
    Code,
    LessInviteNum,
    GuestNum
]) ->
    Data = <<
        Code:32,
        LessInviteNum:8,
        GuestNum:8
    >>,
    {ok, pt:pack(17259, Data)};

write (17260,[
    Code,
    LessInviteNum,
    List
]) ->
    BinList_List = [
        item_to_bin_28(List_Item) || List_Item <- List
    ], 

    List_Len = length(List), 
    Bin_List = list_to_binary(BinList_List),

    Data = <<
        Code:32,
        LessInviteNum:8,
        List_Len:16, Bin_List/binary
    >>,
    {ok, pt:pack(17260, Data)};

write (17261,[
    Code
]) ->
    Data = <<
        Code:32
    >>,
    {ok, pt:pack(17261, Data)};

write (17262,[
    Code,
    ManList,
    WomanList,
    GuestPositionList
]) ->
    BinList_ManList = [
        item_to_bin_30(ManList_Item) || ManList_Item <- ManList
    ], 

    ManList_Len = length(ManList), 
    Bin_ManList = list_to_binary(BinList_ManList),

    BinList_WomanList = [
        item_to_bin_31(WomanList_Item) || WomanList_Item <- WomanList
    ], 

    WomanList_Len = length(WomanList), 
    Bin_WomanList = list_to_binary(BinList_WomanList),

    BinList_GuestPositionList = [
        item_to_bin_32(GuestPositionList_Item) || GuestPositionList_Item <- GuestPositionList
    ], 

    GuestPositionList_Len = length(GuestPositionList), 
    Bin_GuestPositionList = list_to_binary(BinList_GuestPositionList),

    Data = <<
        Code:32,
        ManList_Len:16, Bin_ManList/binary,
        WomanList_Len:16, Bin_WomanList/binary,
        GuestPositionList_Len:16, Bin_GuestPositionList/binary
    >>,
    {ok, pt:pack(17262, Data)};

write (17263,[
    Code
]) ->
    Data = <<
        Code:32
    >>,
    {ok, pt:pack(17263, Data)};

write (17264,[
    Code
]) ->
    Data = <<
        Code:32
    >>,
    {ok, pt:pack(17264, Data)};

write (17265,[
    Code,
    StageId,
    StageEndTime,
    Aura,
    LessNormalCandies,
    LessSpecialCandies,
    GuestsNum
]) ->
    Data = <<
        Code:32,
        StageId:8,
        StageEndTime:32,
        Aura:32,
        LessNormalCandies:32,
        LessSpecialCandies:32,
        GuestsNum:8
    >>,
    {ok, pt:pack(17265, Data)};

write (17266,[
    Code
]) ->
    Data = <<
        Code:32
    >>,
    {ok, pt:pack(17266, Data)};

write (17267,[
    Code,
    ErrorCodeArgs,
    FiresType,
    RoleId
]) ->
    Bin_ErrorCodeArgs = pt:write_string(ErrorCodeArgs), 

    Data = <<
        Code:32,
        Bin_ErrorCodeArgs/binary,
        FiresType:8,
        RoleId:64
    >>,
    {ok, pt:pack(17267, Data)};

write (17270,[
    Code
]) ->
    Data = <<
        Code:32
    >>,
    {ok, pt:pack(17270, Data)};

write (17271,[
    Code,
    ErrorCodeArgs,
    Type
]) ->
    Bin_ErrorCodeArgs = pt:write_string(ErrorCodeArgs), 

    Data = <<
        Code:32,
        Bin_ErrorCodeArgs/binary,
        Type:8
    >>,
    {ok, pt:pack(17271, Data)};

write (17272,[
    Code,
    IfMaster,
    FreeCandies,
    FreeFires,
    CollectTableList
]) ->
    BinList_CollectTableList = [
        item_to_bin_33(CollectTableList_Item) || CollectTableList_Item <- CollectTableList
    ], 

    CollectTableList_Len = length(CollectTableList), 
    Bin_CollectTableList = list_to_binary(BinList_CollectTableList),

    Data = <<
        Code:32,
        IfMaster:8,
        FreeCandies:8,
        FreeFires:8,
        CollectTableList_Len:16, Bin_CollectTableList/binary
    >>,
    {ok, pt:pack(17272, Data)};

write (17273,[
    Code
]) ->
    Data = <<
        Code:32
    >>,
    {ok, pt:pack(17273, Data)};

write (17274,[
    Type
]) ->
    Data = <<
        Type:8
    >>,
    {ok, pt:pack(17274, Data)};

write (17275,[
    AllExp
]) ->
    Data = <<
        AllExp:64
    >>,
    {ok, pt:pack(17275, Data)};

write (17276,[
    RoleIdM,
    RoleIdW
]) ->
    Data = <<
        RoleIdM:64,
        RoleIdW:64
    >>,
    {ok, pt:pack(17276, Data)};

write (17277,[
    InfoList
]) ->
    BinList_InfoList = [
        item_to_bin_34(InfoList_Item) || InfoList_Item <- InfoList
    ], 

    InfoList_Len = length(InfoList), 
    Bin_InfoList = list_to_binary(BinList_InfoList),

    Data = <<
        InfoList_Len:16, Bin_InfoList/binary
    >>,
    {ok, pt:pack(17277, Data)};

write (17278,[
    AuraNum,
    Reward
]) ->
    Bin_Reward = pt:write_object_list(Reward), 

    Data = <<
        AuraNum:32,
        Bin_Reward/binary
    >>,
    {ok, pt:pack(17278, Data)};

write (17279,[
    Type,
    Reward
]) ->
    Bin_Reward = pt:write_object_list(Reward), 

    Data = <<
        Type:8,
        Bin_Reward/binary
    >>,
    {ok, pt:pack(17279, Data)};

write (17280,[
    Code,
    IfActive,
    ImageActiveList
]) ->
    BinList_ImageActiveList = [
        item_to_bin_35(ImageActiveList_Item) || ImageActiveList_Item <- ImageActiveList
    ], 

    ImageActiveList_Len = length(ImageActiveList), 
    Bin_ImageActiveList = list_to_binary(BinList_ImageActiveList),

    Data = <<
        Code:32,
        IfActive:8,
        ImageActiveList_Len:16, Bin_ImageActiveList/binary
    >>,
    {ok, pt:pack(17280, Data)};

write (17281,[
    Code
]) ->
    Data = <<
        Code:32
    >>,
    {ok, pt:pack(17281, Data)};

write (17282,[
    Code,
    Stage,
    Star,
    PrayNum,
    BabyCombatPower
]) ->
    Data = <<
        Code:32,
        Stage:8,
        Star:8,
        PrayNum:32,
        BabyCombatPower:32
    >>,
    {ok, pt:pack(17282, Data)};

write (17283,[
    Code,
    NewStage,
    NewStar,
    NewPrayNum
]) ->
    Data = <<
        Code:32,
        NewStage:16,
        NewStar:16,
        NewPrayNum:32
    >>,
    {ok, pt:pack(17283, Data)};

write (17284,[
    Code,
    NewStage,
    NewStar,
    NewPrayNum
]) ->
    Data = <<
        Code:32,
        NewStage:16,
        NewStar:16,
        NewPrayNum:32
    >>,
    {ok, pt:pack(17284, Data)};

write (17285,[
    Code,
    AptitudeLv,
    BabyCombatPower
]) ->
    Data = <<
        Code:32,
        AptitudeLv:8,
        BabyCombatPower:32
    >>,
    {ok, pt:pack(17285, Data)};

write (17286,[
    Code
]) ->
    Data = <<
        Code:32
    >>,
    {ok, pt:pack(17286, Data)};

write (17287,[
    Code,
    ImageList
]) ->
    BinList_ImageList = [
        item_to_bin_36(ImageList_Item) || ImageList_Item <- ImageList
    ], 

    ImageList_Len = length(ImageList), 
    Bin_ImageList = list_to_binary(BinList_ImageList),

    Data = <<
        Code:32,
        ImageList_Len:16, Bin_ImageList/binary
    >>,
    {ok, pt:pack(17287, Data)};

write (17288,[
    Code,
    ImageId
]) ->
    Data = <<
        Code:32,
        ImageId:8
    >>,
    {ok, pt:pack(17288, Data)};

write (17289,[
    Code,
    ImageId,
    NewStage,
    NewPrayNum
]) ->
    Data = <<
        Code:32,
        ImageId:8,
        NewStage:16,
        NewPrayNum:32
    >>,
    {ok, pt:pack(17289, Data)};

write (17290,[
    Code,
    ImageId,
    NewStage,
    NewPrayNum
]) ->
    Data = <<
        Code:32,
        ImageId:8,
        NewStage:16,
        NewPrayNum:32
    >>,
    {ok, pt:pack(17290, Data)};

write (17291,[
    Code
]) ->
    Data = <<
        Code:32
    >>,
    {ok, pt:pack(17291, Data)};

write (17292,[
    Code
]) ->
    Data = <<
        Code:32
    >>,
    {ok, pt:pack(17292, Data)};

write (17293,[
    Code,
    BabyId,
    BabyIfShow
]) ->
    Data = <<
        Code:32,
        BabyId:32,
        BabyIfShow:8
    >>,
    {ok, pt:pack(17293, Data)};

write (17294,[
    RoleId,
    BabyId,
    BabyIfShow
]) ->
    Data = <<
        RoleId:64,
        BabyId:32,
        BabyIfShow:8
    >>,
    {ok, pt:pack(17294, Data)};

write (17295,[
    Code
]) ->
    Data = <<
        Code:32
    >>,
    {ok, pt:pack(17295, Data)};

write (17296,[
    RoleId,
    RoleName,
    DunId
]) ->
    Bin_RoleName = pt:write_string(RoleName), 

    Data = <<
        RoleId:64,
        Bin_RoleName/binary,
        DunId:32
    >>,
    {ok, pt:pack(17296, Data)};

write (17297,[
    Agree,
    DunId,
    RoleId,
    RoleName
]) ->
    Bin_RoleName = pt:write_string(RoleName), 

    Data = <<
        Agree:8,
        DunId:32,
        RoleId:64,
        Bin_RoleName/binary
    >>,
    {ok, pt:pack(17297, Data)};

write (17298,[
    ErrorCode
]) ->
    Data = <<
        ErrorCode:32
    >>,
    {ok, pt:pack(17298, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 ({
    RoleId,
    Name,
    Lv,
    Sex,
    Vip,
    Career,
    Turn,
    IfMarriage,
    Picture,
    PictureVer,
    IfOnline,
    Popularity,
    Msg,
    Type,
    Time,
    IfFollow,
    IfFriend,
    Intimacy,
    TagList,
    VipExp,
    VipHide,
    IsSupvip
}) ->
    Bin_Name = pt:write_string(Name), 

    Bin_Picture = pt:write_string(Picture), 

    Bin_Msg = pt:write_string(Msg), 

    BinList_TagList = [
        item_to_bin_1(TagList_Item) || TagList_Item <- TagList
    ], 

    TagList_Len = length(TagList), 
    Bin_TagList = list_to_binary(BinList_TagList),

    Data = <<
        RoleId:64,
        Bin_Name/binary,
        Lv:16,
        Sex:8,
        Vip:32,
        Career:8,
        Turn:8,
        IfMarriage:8,
        Bin_Picture/binary,
        PictureVer:32,
        IfOnline:8,
        Popularity:32,
        Bin_Msg/binary,
        Type:8,
        Time:32,
        IfFollow:8,
        IfFriend:8,
        Intimacy:32,
        TagList_Len:16, Bin_TagList/binary,
        VipExp:32,
        VipHide:8,
        IsSupvip:8
    >>,
    Data.
item_to_bin_1 ({
    TagId,
    TagSubid
}) ->
    Data = <<
        TagId:8,
        TagSubid:8
    >>,
    Data.
item_to_bin_2 ({
    TagId,
    TagSubid
}) ->
    Data = <<
        TagId:8,
        TagSubid:8
    >>,
    Data.
item_to_bin_3 ({
    GoodsTypeId,
    UseNum
}) ->
    Data = <<
        GoodsTypeId:32,
        UseNum:16
    >>,
    Data.
item_to_bin_4 ({
    AttrType,
    AttrNum
}) ->
    Data = <<
        AttrType:32,
        AttrNum:32
    >>,
    Data.
item_to_bin_5 ({
    GoodsType,
    GoodsTypeId,
    GoodsNum
}) ->
    Data = <<
        GoodsType:32,
        GoodsTypeId:32,
        GoodsNum:32
    >>,
    Data.
item_to_bin_6 ({
    RoleId,
    Name,
    Lv,
    CombatPower,
    Sex,
    Vip,
    Career,
    Turn,
    Type,
    ProposeType,
    Msg,
    IfAa,
    CostList
}) ->
    Bin_Name = pt:write_string(Name), 

    Bin_Msg = pt:write_string(Msg), 

    BinList_CostList = [
        item_to_bin_7(CostList_Item) || CostList_Item <- CostList
    ], 

    CostList_Len = length(CostList), 
    Bin_CostList = list_to_binary(BinList_CostList),

    Data = <<
        RoleId:64,
        Bin_Name/binary,
        Lv:16,
        CombatPower:64,
        Sex:8,
        Vip:32,
        Career:8,
        Turn:8,
        Type:8,
        ProposeType:8,
        Bin_Msg/binary,
        IfAa:8,
        CostList_Len:16, Bin_CostList/binary
    >>,
    Data.
item_to_bin_7 ({
    GoodsType,
    GoodsTypeId,
    GoodsNum
}) ->
    Data = <<
        GoodsType:32,
        GoodsTypeId:32,
        GoodsNum:32
    >>,
    Data.
item_to_bin_8 ({
    RoleId,
    Name,
    Lv,
    CombatPower,
    Sex,
    Vip,
    Career,
    Turn,
    Type,
    AnswerType
}) ->
    Bin_Name = pt:write_string(Name), 

    Data = <<
        RoleId:64,
        Bin_Name/binary,
        Lv:16,
        CombatPower:64,
        Sex:8,
        Vip:32,
        Career:8,
        Turn:8,
        Type:8,
        AnswerType:8
    >>,
    Data.
item_to_bin_9 ({
    Key,
    Val
}) ->
    Data = <<
        Key:8,
        Val:32
    >>,
    Data.
item_to_bin_10 ({
    CountType,
    State,
    Time
}) ->
    Data = <<
        CountType:8,
        State:8,
        Time:32
    >>,
    Data.
item_to_bin_11 ({
    Type,
    RoleId,
    Figure,
    Power
}) ->
    Bin_Figure = pt:write_figure(Figure), 

    Data = <<
        Type:8,
        RoleId:64,
        Bin_Figure/binary,
        Power:64
    >>,
    Data.
item_to_bin_12 ({
    WeddingType,
    UseTimes,
    MaxTimes,
    OrderToday
}) ->
    Data = <<
        WeddingType:8,
        UseTimes:16,
        MaxTimes:16,
        OrderToday:8
    >>,
    Data.
item_to_bin_13 ({
    OrderUnixDate,
    TimeList
}) ->
    BinList_TimeList = [
        item_to_bin_14(TimeList_Item) || TimeList_Item <- TimeList
    ], 

    TimeList_Len = length(TimeList), 
    Bin_TimeList = list_to_binary(BinList_TimeList),

    Data = <<
        OrderUnixDate:32,
        TimeList_Len:16, Bin_TimeList/binary
    >>,
    Data.
item_to_bin_14 ({
    TimeId,
    OrderList
}) ->
    BinList_OrderList = [
        item_to_bin_15(OrderList_Item) || OrderList_Item <- OrderList
    ], 

    OrderList_Len = length(OrderList), 
    Bin_OrderList = list_to_binary(BinList_OrderList),

    Data = <<
        TimeId:8,
        OrderList_Len:16, Bin_OrderList/binary
    >>,
    Data.
item_to_bin_15 ({
    RoleIdM,
    RoleIdW,
    WeddingType,
    IfOwn
}) ->
    Data = <<
        RoleIdM:64,
        RoleIdW:64,
        WeddingType:8,
        IfOwn:8
    >>,
    Data.
item_to_bin_16 ({
    RoleIdM,
    Name,
    Lv,
    CombatPower,
    Sex,
    Vip,
    Career,
    Turn
}) ->
    Bin_Name = pt:write_string(Name), 

    Data = <<
        RoleIdM:64,
        Bin_Name/binary,
        Lv:16,
        CombatPower:64,
        Sex:8,
        Vip:32,
        Career:8,
        Turn:8
    >>,
    Data.
item_to_bin_17 ({
    RoleIdW,
    Name,
    Lv,
    CombatPower,
    Sex,
    Vip,
    Career,
    Turn
}) ->
    Bin_Name = pt:write_string(Name), 

    Data = <<
        RoleIdW:64,
        Bin_Name/binary,
        Lv:16,
        CombatPower:64,
        Sex:8,
        Vip:32,
        Career:8,
        Turn:8
    >>,
    Data.
item_to_bin_18 ({
    RoleId,
    AnswerType,
    Name
}) ->
    Bin_Name = pt:write_string(Name), 

    Data = <<
        RoleId:64,
        AnswerType:8,
        Bin_Name/binary
    >>,
    Data.
item_to_bin_19 ({
    RoleId,
    Name
}) ->
    Bin_Name = pt:write_string(Name), 

    Data = <<
        RoleId:64,
        Bin_Name/binary
    >>,
    Data.
item_to_bin_20 (
    RoleId
) ->
    Data = <<
        RoleId:64
    >>,
    Data.
item_to_bin_21 ({
    WeddingType,
    StartTime,
    IfAnswer,
    ManList,
    WomanList
}) ->
    BinList_ManList = [
        item_to_bin_22(ManList_Item) || ManList_Item <- ManList
    ], 

    ManList_Len = length(ManList), 
    Bin_ManList = list_to_binary(BinList_ManList),

    BinList_WomanList = [
        item_to_bin_23(WomanList_Item) || WomanList_Item <- WomanList
    ], 

    WomanList_Len = length(WomanList), 
    Bin_WomanList = list_to_binary(BinList_WomanList),

    Data = <<
        WeddingType:8,
        StartTime:32,
        IfAnswer:8,
        ManList_Len:16, Bin_ManList/binary,
        WomanList_Len:16, Bin_WomanList/binary
    >>,
    Data.
item_to_bin_22 ({
    RoleId,
    Name,
    Lv,
    CombatPower,
    Sex,
    Vip,
    Career,
    Turn
}) ->
    Bin_Name = pt:write_string(Name), 

    Data = <<
        RoleId:64,
        Bin_Name/binary,
        Lv:16,
        CombatPower:64,
        Sex:8,
        Vip:32,
        Career:8,
        Turn:8
    >>,
    Data.
item_to_bin_23 ({
    RoleId,
    Name,
    Lv,
    CombatPower,
    Sex,
    Vip,
    Career,
    Turn
}) ->
    Bin_Name = pt:write_string(Name), 

    Data = <<
        RoleId:64,
        Bin_Name/binary,
        Lv:16,
        CombatPower:64,
        Sex:8,
        Vip:32,
        Career:8,
        Turn:8
    >>,
    Data.
item_to_bin_24 ({
    WeddingType,
    StartTime,
    ManList,
    WomanList,
    GuestList
}) ->
    BinList_ManList = [
        item_to_bin_25(ManList_Item) || ManList_Item <- ManList
    ], 

    ManList_Len = length(ManList), 
    Bin_ManList = list_to_binary(BinList_ManList),

    BinList_WomanList = [
        item_to_bin_26(WomanList_Item) || WomanList_Item <- WomanList
    ], 

    WomanList_Len = length(WomanList), 
    Bin_WomanList = list_to_binary(BinList_WomanList),

    BinList_GuestList = [
        item_to_bin_27(GuestList_Item) || GuestList_Item <- GuestList
    ], 

    GuestList_Len = length(GuestList), 
    Bin_GuestList = list_to_binary(BinList_GuestList),

    Data = <<
        WeddingType:8,
        StartTime:32,
        ManList_Len:16, Bin_ManList/binary,
        WomanList_Len:16, Bin_WomanList/binary,
        GuestList_Len:16, Bin_GuestList/binary
    >>,
    Data.
item_to_bin_25 ({
    RoleId,
    Name,
    Lv,
    CombatPower,
    Sex,
    Vip,
    Career,
    Turn,
    Picture,
    PictureVer
}) ->
    Bin_Name = pt:write_string(Name), 

    Bin_Picture = pt:write_string(Picture), 

    Data = <<
        RoleId:64,
        Bin_Name/binary,
        Lv:16,
        CombatPower:64,
        Sex:8,
        Vip:32,
        Career:8,
        Turn:8,
        Bin_Picture/binary,
        PictureVer:32
    >>,
    Data.
item_to_bin_26 ({
    RoleId,
    Name,
    Lv,
    CombatPower,
    Sex,
    Vip,
    Career,
    Turn,
    Picture,
    PictureVer
}) ->
    Bin_Name = pt:write_string(Name), 

    Bin_Picture = pt:write_string(Picture), 

    Data = <<
        RoleId:64,
        Bin_Name/binary,
        Lv:16,
        CombatPower:64,
        Sex:8,
        Vip:32,
        Career:8,
        Turn:8,
        Bin_Picture/binary,
        PictureVer:32
    >>,
    Data.
item_to_bin_27 (
    RoleId
) ->
    Data = <<
        RoleId:64
    >>,
    Data.
item_to_bin_28 ({
    Type,
    InfoList
}) ->
    BinList_InfoList = [
        item_to_bin_29(InfoList_Item) || InfoList_Item <- InfoList
    ], 

    InfoList_Len = length(InfoList), 
    Bin_InfoList = list_to_binary(BinList_InfoList),

    Data = <<
        Type:8,
        InfoList_Len:16, Bin_InfoList/binary
    >>,
    Data.
item_to_bin_29 ({
    RoleId,
    AnswerType,
    Name
}) ->
    Bin_Name = pt:write_string(Name), 

    Data = <<
        RoleId:64,
        AnswerType:8,
        Bin_Name/binary
    >>,
    Data.
item_to_bin_30 ({
    RoleIdM,
    FigureM
}) ->
    Bin_FigureM = pt:write_figure(FigureM), 

    Data = <<
        RoleIdM:64,
        Bin_FigureM/binary
    >>,
    Data.
item_to_bin_31 ({
    RoleIdW,
    FigureW
}) ->
    Bin_FigureW = pt:write_figure(FigureW), 

    Data = <<
        RoleIdW:64,
        Bin_FigureW/binary
    >>,
    Data.
item_to_bin_32 ({
    PosId,
    GuestRoleId,
    IfEnter
}) ->
    Data = <<
        PosId:8,
        GuestRoleId:64,
        IfEnter:8
    >>,
    Data.
item_to_bin_33 (
    TableMonOnlyId
) ->
    Data = <<
        TableMonOnlyId:32
    >>,
    Data.
item_to_bin_34 ({
    Type,
    Values
}) ->
    Data = <<
        Type:8,
        Values:32
    >>,
    Data.
item_to_bin_35 ({
    ImageId,
    IfActive
}) ->
    Data = <<
        ImageId:8,
        IfActive:8
    >>,
    Data.
item_to_bin_36 ({
    ImageId,
    IfActive,
    Stage,
    PrayNum,
    ImageCombatPower
}) ->
    Data = <<
        ImageId:8,
        IfActive:8,
        Stage:8,
        PrayNum:32,
        ImageCombatPower:32
    >>,
    Data.
