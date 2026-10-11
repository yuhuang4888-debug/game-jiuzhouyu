-module(pt_331).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(33101, _) ->
    {ok, []};
read(33104, Bin0) ->
    <<BaseType:16, Bin1/binary>> = Bin0, 
    <<SubType:16, _Bin2/binary>> = Bin1, 
    {ok, [BaseType, SubType]};
read(33105, Bin0) ->
    <<BaseType:16, Bin1/binary>> = Bin0, 
    <<SubType:16, Bin2/binary>> = Bin1, 
    <<Grade:16, _Bin3/binary>> = Bin2, 
    {ok, [BaseType, SubType, Grade]};
read(33106, Bin0) ->
    <<BaseType:16, Bin1/binary>> = Bin0, 
    <<SubType:16, Bin2/binary>> = Bin1, 
    <<ModId:16, Bin3/binary>> = Bin2, 
    <<CounterId:16, Bin4/binary>> = Bin3, 
    <<Grade:16, _Bin5/binary>> = Bin4, 
    {ok, [BaseType, SubType, ModId, CounterId, Grade]};
read(33107, Bin0) ->
    <<BaseType:16, Bin1/binary>> = Bin0, 
    <<SubType:16, _Bin2/binary>> = Bin1, 
    {ok, [BaseType, SubType]};
read(33110, _) ->
    {ok, []};
read(33111, Bin0) ->
    <<BaseType:16, Bin1/binary>> = Bin0, 
    <<SubType:16, _Bin2/binary>> = Bin1, 
    {ok, [BaseType, SubType]};
read(33112, Bin0) ->
    <<SubType:16, _Bin1/binary>> = Bin0, 
    {ok, [SubType]};
read(33113, Bin0) ->
    <<SubType:16, Bin1/binary>> = Bin0, 
    <<BuyNum:16, Bin2/binary>> = Bin1, 
    <<IfAutoBuy:8, _Bin3/binary>> = Bin2, 
    {ok, [SubType, BuyNum, IfAutoBuy]};
read(33114, Bin0) ->
    <<SubType:16, _Bin1/binary>> = Bin0, 
    {ok, [SubType]};
read(33115, Bin0) ->
    <<SubType:16, Bin1/binary>> = Bin0, 
    <<Opr:8, _Bin2/binary>> = Bin1, 
    {ok, [SubType, Opr]};
read(33118, _) ->
    {ok, []};
read(33120, Bin0) ->
    <<BaseType:16, Bin1/binary>> = Bin0, 
    <<SubType:16, _Bin2/binary>> = Bin1, 
    {ok, [BaseType, SubType]};
read(33121, Bin0) ->
    <<BaseType:16, Bin1/binary>> = Bin0, 
    <<SubType:16, _Bin2/binary>> = Bin1, 
    {ok, [BaseType, SubType]};
read(33122, Bin0) ->
    <<BaseType:16, Bin1/binary>> = Bin0, 
    <<SubType:16, Bin2/binary>> = Bin1, 
    <<Index:8, Bin3/binary>> = Bin2, 
    <<AutoBuy:8, _Bin4/binary>> = Bin3, 
    {ok, [BaseType, SubType, Index, AutoBuy]};
read(33123, Bin0) ->
    <<BaseType:16, Bin1/binary>> = Bin0, 
    <<SubType:16, Bin2/binary>> = Bin1, 
    <<GradeId:16, _Bin3/binary>> = Bin2, 
    {ok, [BaseType, SubType, GradeId]};
read(33126, _) ->
    {ok, []};
read(33127, Bin0) ->
    <<SceneId:32, _Bin1/binary>> = Bin0, 
    {ok, [SceneId]};
read(33128, Bin0) ->
    <<BaseType:16, Bin1/binary>> = Bin0, 
    <<SubType:16, _Bin2/binary>> = Bin1, 
    {ok, [BaseType, SubType]};
read(33129, Bin0) ->
    <<BaseType:16, Bin1/binary>> = Bin0, 
    <<SubType:16, Bin2/binary>> = Bin1, 
    FunArray0 = fun(<<RestBin0/binary>>) -> 
        <<Rare:8, _Args0_1/binary>> = RestBin0, 
        <<Grade:16, _Args0_2/binary>> = _Args0_1, 
        {{Rare, Grade},_Args0_2}
        end,
    {Pool, _Bin3} = pt:read_array(FunArray0, Bin2),

    {ok, [BaseType, SubType, Pool]};
read(33130, Bin0) ->
    <<BaseType:16, Bin1/binary>> = Bin0, 
    <<SubType:16, _Bin2/binary>> = Bin1, 
    {ok, [BaseType, SubType]};
read(33131, Bin0) ->
    <<BaseType:16, Bin1/binary>> = Bin0, 
    <<SubType:16, _Bin2/binary>> = Bin1, 
    {ok, [BaseType, SubType]};
read(33132, Bin0) ->
    <<BaseType:16, Bin1/binary>> = Bin0, 
    <<SubType:16, _Bin2/binary>> = Bin1, 
    {ok, [BaseType, SubType]};
read(33133, Bin0) ->
    <<BaseType:16, Bin1/binary>> = Bin0, 
    <<SubType:16, _Bin2/binary>> = Bin1, 
    {ok, [BaseType, SubType]};
read(33134, Bin0) ->
    <<BaseType:16, Bin1/binary>> = Bin0, 
    <<SubType:16, Bin2/binary>> = Bin1, 
    <<AutoBuy:8, _Bin3/binary>> = Bin2, 
    {ok, [BaseType, SubType, AutoBuy]};
read(33135, Bin0) ->
    <<BaseType:16, Bin1/binary>> = Bin0, 
    <<SubType:16, Bin2/binary>> = Bin1, 
    <<Grade:16, _Bin3/binary>> = Bin2, 
    {ok, [BaseType, SubType, Grade]};
read(33136, Bin0) ->
    <<SubType:16, _Bin1/binary>> = Bin0, 
    {ok, [SubType]};
read(33137, Bin0) ->
    <<SubType:16, Bin1/binary>> = Bin0, 
    <<Grade:16, _Bin2/binary>> = Bin1, 
    {ok, [SubType, Grade]};
read(33138, Bin0) ->
    <<SubType:16, Bin1/binary>> = Bin0, 
    <<Grade:16, _Bin2/binary>> = Bin1, 
    {ok, [SubType, Grade]};
read(33139, Bin0) ->
    <<BaseType:16, Bin1/binary>> = Bin0, 
    <<SubType:16, _Bin2/binary>> = Bin1, 
    {ok, [BaseType, SubType]};
read(33140, Bin0) ->
    <<SubType:16, _Bin1/binary>> = Bin0, 
    {ok, [SubType]};
read(33141, Bin0) ->
    <<BaseType:16, Bin1/binary>> = Bin0, 
    <<SubType:16, _Bin2/binary>> = Bin1, 
    {ok, [BaseType, SubType]};
read(33142, Bin0) ->
    <<BaseType:16, Bin1/binary>> = Bin0, 
    <<SubType:16, Bin2/binary>> = Bin1, 
    <<Grade:16, Bin3/binary>> = Bin2, 
    <<Times:16, Bin4/binary>> = Bin3, 
    <<AutoBuy:8, _Bin5/binary>> = Bin4, 
    {ok, [BaseType, SubType, Grade, Times, AutoBuy]};
read(33143, Bin0) ->
    <<SubType:16, _Bin1/binary>> = Bin0, 
    {ok, [SubType]};
read(33144, Bin0) ->
    <<BaseType:16, Bin1/binary>> = Bin0, 
    <<SubType:16, Bin2/binary>> = Bin1, 
    <<Grade:16, _Bin3/binary>> = Bin2, 
    {ok, [BaseType, SubType, Grade]};
read(33145, Bin0) ->
    <<SubType:16, _Bin1/binary>> = Bin0, 
    {ok, [SubType]};
read(33146, Bin0) ->
    <<SubType:16, Bin1/binary>> = Bin0, 
    <<Grade:16, Bin2/binary>> = Bin1, 
    <<BossId:32, _Bin3/binary>> = Bin2, 
    {ok, [SubType, Grade, BossId]};
read(33148, Bin0) ->
    <<SubType:16, _Bin1/binary>> = Bin0, 
    {ok, [SubType]};
read(33149, Bin0) ->
    <<SubType:16, _Bin1/binary>> = Bin0, 
    {ok, [SubType]};
read(33151, Bin0) ->
    <<SubType:16, Bin1/binary>> = Bin0, 
    <<Num:32, _Bin2/binary>> = Bin1, 
    {ok, [SubType, Num]};
read(33152, Bin0) ->
    <<SubType:16, _Bin1/binary>> = Bin0, 
    {ok, [SubType]};
read(33153, Bin0) ->
    <<SubType:16, Bin1/binary>> = Bin0, 
    <<Type:8, _Bin2/binary>> = Bin1, 
    {ok, [SubType, Type]};
read(33154, Bin0) ->
    <<SubType:16, _Bin1/binary>> = Bin0, 
    {ok, [SubType]};
read(33155, Bin0) ->
    <<SubType:16, _Bin1/binary>> = Bin0, 
    {ok, [SubType]};
read(33157, Bin0) ->
    <<SubType:16, _Bin1/binary>> = Bin0, 
    {ok, [SubType]};
read(33160, Bin0) ->
    <<SubType:16, _Bin1/binary>> = Bin0, 
    {ok, [SubType]};
read(33161, Bin0) ->
    <<SubType:16, Bin1/binary>> = Bin0, 
    <<Type:8, _Bin2/binary>> = Bin1, 
    {ok, [SubType, Type]};
read(33162, Bin0) ->
    <<SubType:16, _Bin1/binary>> = Bin0, 
    {ok, [SubType]};
read(33163, Bin0) ->
    <<SubType:16, Bin1/binary>> = Bin0, 
    <<PutType:8, _Bin2/binary>> = Bin1, 
    {ok, [SubType, PutType]};
read(33164, Bin0) ->
    <<SubType:16, _Bin1/binary>> = Bin0, 
    {ok, [SubType]};
read(33165, Bin0) ->
    <<BaseType:16, Bin1/binary>> = Bin0, 
    <<SubType:16, _Bin2/binary>> = Bin1, 
    {ok, [BaseType, SubType]};
read(33166, Bin0) ->
    <<BaseType:16, Bin1/binary>> = Bin0, 
    <<SubType:16, Bin2/binary>> = Bin1, 
    <<Stage:8, Bin3/binary>> = Bin2, 
    <<GradeStage:8, Bin4/binary>> = Bin3, 
    <<Buy:8, _Bin5/binary>> = Bin4, 
    {ok, [BaseType, SubType, Stage, GradeStage, Buy]};
read(33167, Bin0) ->
    <<BaseType:16, Bin1/binary>> = Bin0, 
    <<SubType:16, Bin2/binary>> = Bin1, 
    <<Tiems:8, Bin3/binary>> = Bin2, 
    <<AutoBuy:8, _Bin4/binary>> = Bin3, 
    {ok, [BaseType, SubType, Tiems, AutoBuy]};
read(33168, Bin0) ->
    <<BaseType:16, Bin1/binary>> = Bin0, 
    <<SubType:16, Bin2/binary>> = Bin1, 
    <<GradeId:16, _Bin3/binary>> = Bin2, 
    {ok, [BaseType, SubType, GradeId]};
read(33169, _) ->
    {ok, []};
read(33170, Bin0) ->
    <<Type:16, Bin1/binary>> = Bin0, 
    <<Subtype:16, _Bin2/binary>> = Bin1, 
    {ok, [Type, Subtype]};
read(33171, Bin0) ->
    <<Type:16, Bin1/binary>> = Bin0, 
    <<Subtype:16, _Bin2/binary>> = Bin1, 
    {ok, [Type, Subtype]};
read(33172, Bin0) ->
    <<Type:16, Bin1/binary>> = Bin0, 
    <<Subtype:16, _Bin2/binary>> = Bin1, 
    {ok, [Type, Subtype]};
read(33174, Bin0) ->
    <<Type:16, Bin1/binary>> = Bin0, 
    <<Subtype:16, Bin2/binary>> = Bin1, 
    <<ProductId:32, Bin3/binary>> = Bin2, 
    <<BuyNum:16, _Bin4/binary>> = Bin3, 
    {ok, [Type, Subtype, ProductId, BuyNum]};
read(33175, Bin0) ->
    <<Type:16, Bin1/binary>> = Bin0, 
    <<Subtype:16, Bin2/binary>> = Bin1, 
    <<ProductId:32, _Bin3/binary>> = Bin2, 
    {ok, [Type, Subtype, ProductId]};
read(33176, Bin0) ->
    <<BaseType:16, Bin1/binary>> = Bin0, 
    <<SubType:16, Bin2/binary>> = Bin1, 
    <<DrawTimes:16, Bin3/binary>> = Bin2, 
    <<AutoBuy:8, _Bin4/binary>> = Bin3, 
    {ok, [BaseType, SubType, DrawTimes, AutoBuy]};
read(33177, Bin0) ->
    <<BaseType:16, Bin1/binary>> = Bin0, 
    <<SubType:16, _Bin2/binary>> = Bin1, 
    {ok, [BaseType, SubType]};
read(33178, Bin0) ->
    <<BaseType:16, Bin1/binary>> = Bin0, 
    <<SubType:16, Bin2/binary>> = Bin1, 
    <<Grade:16, _Bin3/binary>> = Bin2, 
    {ok, [BaseType, SubType, Grade]};
read(33179, Bin0) ->
    <<BaseType:16, Bin1/binary>> = Bin0, 
    <<SubType:16, Bin2/binary>> = Bin1, 
    <<Grade:16, Bin3/binary>> = Bin2, 
    <<Num:16, _Bin4/binary>> = Bin3, 
    {ok, [BaseType, SubType, Grade, Num]};
read(33180, Bin0) ->
    <<Type:16, Bin1/binary>> = Bin0, 
    <<Subtype:16, _Bin2/binary>> = Bin1, 
    {ok, [Type, Subtype]};
read(33181, Bin0) ->
    <<Type:16, Bin1/binary>> = Bin0, 
    <<Subtype:16, Bin2/binary>> = Bin1, 
    <<AutoBuy:8, _Bin3/binary>> = Bin2, 
    {ok, [Type, Subtype, AutoBuy]};
read(33182, Bin0) ->
    <<Type:16, Bin1/binary>> = Bin0, 
    <<Subtype:16, Bin2/binary>> = Bin1, 
    <<Pos:8, Bin3/binary>> = Bin2, 
    <<AutoBuy:8, _Bin4/binary>> = Bin3, 
    {ok, [Type, Subtype, Pos, AutoBuy]};
read(33183, Bin0) ->
    <<Type:16, Bin1/binary>> = Bin0, 
    <<Subtype:16, _Bin2/binary>> = Bin1, 
    {ok, [Type, Subtype]};
read(33186, Bin0) ->
    <<BaseType:16, Bin1/binary>> = Bin0, 
    <<SubType:16, Bin2/binary>> = Bin1, 
    <<Times:16, Bin3/binary>> = Bin2, 
    <<AutoBuy:8, _Bin4/binary>> = Bin3, 
    {ok, [BaseType, SubType, Times, AutoBuy]};
read(33187, Bin0) ->
    <<BaseType:16, Bin1/binary>> = Bin0, 
    <<SubType:16, _Bin2/binary>> = Bin1, 
    {ok, [BaseType, SubType]};
read(33188, _) ->
    {ok, []};
read(33189, Bin0) ->
    <<Subtype:16, _Bin1/binary>> = Bin0, 
    {ok, [Subtype]};
read(33190, Bin0) ->
    <<BaseType:16, Bin1/binary>> = Bin0, 
    <<SubType:16, _Bin2/binary>> = Bin1, 
    {ok, [BaseType, SubType]};
read(33191, Bin0) ->
    <<BaseType:16, Bin1/binary>> = Bin0, 
    <<SubType:16, Bin2/binary>> = Bin1, 
    <<Tiems:8, Bin3/binary>> = Bin2, 
    <<AutoBuy:8, _Bin4/binary>> = Bin3, 
    {ok, [BaseType, SubType, Tiems, AutoBuy]};
read(33192, Bin0) ->
    <<BaseType:16, Bin1/binary>> = Bin0, 
    <<SubType:16, Bin2/binary>> = Bin1, 
    <<GradeId:16, _Bin3/binary>> = Bin2, 
    {ok, [BaseType, SubType, GradeId]};
read(33193, Bin0) ->
    <<BaseType:16, Bin1/binary>> = Bin0, 
    <<SubType:16, _Bin2/binary>> = Bin1, 
    {ok, [BaseType, SubType]};
read(33194, Bin0) ->
    <<BaseType:16, Bin1/binary>> = Bin0, 
    <<SubType:16, Bin2/binary>> = Bin1, 
    <<CostType:8, _Bin3/binary>> = Bin2, 
    {ok, [BaseType, SubType, CostType]};
read(33195, Bin0) ->
    <<BaseType:16, Bin1/binary>> = Bin0, 
    <<SubType:16, Bin2/binary>> = Bin1, 
    <<GradeId:16, _Bin3/binary>> = Bin2, 
    {ok, [BaseType, SubType, GradeId]};
read(33197, Bin0) ->
    <<BaseType:16, Bin1/binary>> = Bin0, 
    <<SubType:16, _Bin2/binary>> = Bin1, 
    {ok, [BaseType, SubType]};
read(33198, Bin0) ->
    <<BaseType:16, Bin1/binary>> = Bin0, 
    <<SubType:16, _Bin2/binary>> = Bin1, 
    {ok, [BaseType, SubType]};
read(_Cmd, _R) -> {error, no_match}.

write (33100,[
    ErrorCode
]) ->
    Data = <<
        ErrorCode:32
    >>,
    {ok, pt:pack(33100, Data)};

write (33101,[
    List
]) ->
    BinList_List = [
        item_to_bin_0(List_Item) || List_Item <- List
    ], 

    List_Len = length(List), 
    Bin_List = list_to_binary(BinList_List),

    Data = <<
        List_Len:16, Bin_List/binary
    >>,
    {ok, pt:pack(33101, Data)};

write (33102,[
    List
]) ->
    BinList_List = [
        item_to_bin_1(List_Item) || List_Item <- List
    ], 

    List_Len = length(List), 
    Bin_List = list_to_binary(BinList_List),

    Data = <<
        List_Len:16, Bin_List/binary
    >>,
    {ok, pt:pack(33102, Data)};

write (33103,[
    List
]) ->
    BinList_List = [
        item_to_bin_2(List_Item) || List_Item <- List
    ], 

    List_Len = length(List), 
    Bin_List = list_to_binary(BinList_List),

    Data = <<
        List_Len:16, Bin_List/binary
    >>,
    {ok, pt:pack(33103, Data)};

write (33104,[
    BaseType,
    SubType,
    RewardList
]) ->
    BinList_RewardList = [
        item_to_bin_3(RewardList_Item) || RewardList_Item <- RewardList
    ], 

    RewardList_Len = length(RewardList), 
    Bin_RewardList = list_to_binary(BinList_RewardList),

    Data = <<
        BaseType:16,
        SubType:16,
        RewardList_Len:16, Bin_RewardList/binary
    >>,
    {ok, pt:pack(33104, Data)};

write (33105,[
    ErrorCode,
    BaseType,
    SubType,
    Grade
]) ->
    Data = <<
        ErrorCode:32,
        BaseType:16,
        SubType:16,
        Grade:16
    >>,
    {ok, pt:pack(33105, Data)};

write (33106,[
    BaseType,
    SubType,
    ModId,
    CounterId,
    Count,
    Grade
]) ->
    Data = <<
        BaseType:16,
        SubType:16,
        ModId:16,
        CounterId:16,
        Count:16,
        Grade:16
    >>,
    {ok, pt:pack(33106, Data)};

write (33107,[
    BaseType,
    SubType,
    Values
]) ->
    BinList_Values = [
        item_to_bin_4(Values_Item) || Values_Item <- Values
    ], 

    Values_Len = length(Values), 
    Bin_Values = list_to_binary(BinList_Values),

    Data = <<
        BaseType:16,
        SubType:16,
        Values_Len:16, Bin_Values/binary
    >>,
    {ok, pt:pack(33107, Data)};

write (33108,[
    Values
]) ->
    BinList_Values = [
        item_to_bin_5(Values_Item) || Values_Item <- Values
    ], 

    Values_Len = length(Values), 
    Bin_Values = list_to_binary(BinList_Values),

    Data = <<
        Values_Len:16, Bin_Values/binary
    >>,
    {ok, pt:pack(33108, Data)};

write (33110,[
    Code
]) ->
    Data = <<
        Code:32
    >>,
    {ok, pt:pack(33110, Data)};

write (33111,[
    Errcode,
    GradeNumList
]) ->
    BinList_GradeNumList = [
        item_to_bin_6(GradeNumList_Item) || GradeNumList_Item <- GradeNumList
    ], 

    GradeNumList_Len = length(GradeNumList), 
    Bin_GradeNumList = list_to_binary(BinList_GradeNumList),

    Data = <<
        Errcode:32,
        GradeNumList_Len:16, Bin_GradeNumList/binary
    >>,
    {ok, pt:pack(33111, Data)};

write (33112,[
    Errcode,
    SubType,
    IfKf,
    NextRewardTime,
    NotLimitBeginTime,
    AllBuyNum,
    BigRewardId,
    AllBuyList,
    Stage,
    SelfBuyNum,
    LessBuyNum,
    JoinNum
]) ->
    BinList_AllBuyList = [
        item_to_bin_7(AllBuyList_Item) || AllBuyList_Item <- AllBuyList
    ], 

    AllBuyList_Len = length(AllBuyList), 
    Bin_AllBuyList = list_to_binary(BinList_AllBuyList),

    BinList_Stage = [
        item_to_bin_9(Stage_Item) || Stage_Item <- Stage
    ], 

    Stage_Len = length(Stage), 
    Bin_Stage = list_to_binary(BinList_Stage),

    Data = <<
        Errcode:32,
        SubType:16,
        IfKf:8,
        NextRewardTime:32,
        NotLimitBeginTime:32,
        AllBuyNum:32,
        BigRewardId:16,
        AllBuyList_Len:16, Bin_AllBuyList/binary,
        Stage_Len:16, Bin_Stage/binary,
        SelfBuyNum:32,
        LessBuyNum:32,
        JoinNum:16
    >>,
    {ok, pt:pack(33112, Data)};

write (33113,[
    Errcode,
    SubType,
    BuyList,
    BuyTimesList
]) ->
    BinList_BuyList = [
        item_to_bin_10(BuyList_Item) || BuyList_Item <- BuyList
    ], 

    BuyList_Len = length(BuyList), 
    Bin_BuyList = list_to_binary(BinList_BuyList),

    BinList_BuyTimesList = [
        item_to_bin_11(BuyTimesList_Item) || BuyTimesList_Item <- BuyTimesList
    ], 

    BuyTimesList_Len = length(BuyTimesList), 
    Bin_BuyTimesList = list_to_binary(BinList_BuyTimesList),

    Data = <<
        Errcode:32,
        SubType:16,
        BuyList_Len:16, Bin_BuyList/binary,
        BuyTimesList_Len:16, Bin_BuyTimesList/binary
    >>,
    {ok, pt:pack(33113, Data)};

write (33114,[
    SubType,
    BingoPlayerList
]) ->
    BinList_BingoPlayerList = [
        item_to_bin_12(BingoPlayerList_Item) || BingoPlayerList_Item <- BingoPlayerList
    ], 

    BingoPlayerList_Len = length(BingoPlayerList), 
    Bin_BingoPlayerList = list_to_binary(BinList_BingoPlayerList),

    Data = <<
        SubType:16,
        BingoPlayerList_Len:16, Bin_BingoPlayerList/binary
    >>,
    {ok, pt:pack(33114, Data)};

write (33115,[
    Code,
    SubType,
    Opr,
    IfGetReward,
    WeddingTypeList
]) ->
    BinList_WeddingTypeList = [
        item_to_bin_13(WeddingTypeList_Item) || WeddingTypeList_Item <- WeddingTypeList
    ], 

    WeddingTypeList_Len = length(WeddingTypeList), 
    Bin_WeddingTypeList = list_to_binary(BinList_WeddingTypeList),

    Data = <<
        Code:32,
        SubType:16,
        Opr:8,
        IfGetReward:8,
        WeddingTypeList_Len:16, Bin_WeddingTypeList/binary
    >>,
    {ok, pt:pack(33115, Data)};

write (33116,[
    SubType,
    Stage
]) ->
    BinList_Stage = [
        item_to_bin_14(Stage_Item) || Stage_Item <- Stage
    ], 

    Stage_Len = length(Stage), 
    Bin_Stage = list_to_binary(BinList_Stage),

    Data = <<
        SubType:16,
        Stage_Len:16, Bin_Stage/binary
    >>,
    {ok, pt:pack(33116, Data)};

write (33118,[
    BaseType,
    SubType
]) ->
    Data = <<
        BaseType:16,
        SubType:16
    >>,
    {ok, pt:pack(33118, Data)};

write (33120,[
    BaseType,
    SubType,
    StartTime,
    FreeSmashedTimes,
    SmashedTimes,
    RefreshTimes,
    ShowList,
    Eggs,
    Record,
    CumulateReward
]) ->
    BinList_ShowList = [
        item_to_bin_15(ShowList_Item) || ShowList_Item <- ShowList
    ], 

    ShowList_Len = length(ShowList), 
    Bin_ShowList = list_to_binary(BinList_ShowList),

    BinList_Eggs = [
        item_to_bin_16(Eggs_Item) || Eggs_Item <- Eggs
    ], 

    Eggs_Len = length(Eggs), 
    Bin_Eggs = list_to_binary(BinList_Eggs),

    BinList_Record = [
        item_to_bin_17(Record_Item) || Record_Item <- Record
    ], 

    Record_Len = length(Record), 
    Bin_Record = list_to_binary(BinList_Record),

    BinList_CumulateReward = [
        item_to_bin_18(CumulateReward_Item) || CumulateReward_Item <- CumulateReward
    ], 

    CumulateReward_Len = length(CumulateReward), 
    Bin_CumulateReward = list_to_binary(BinList_CumulateReward),

    Data = <<
        BaseType:16,
        SubType:16,
        StartTime:32,
        FreeSmashedTimes:8,
        SmashedTimes:16,
        RefreshTimes:16,
        ShowList_Len:16, Bin_ShowList/binary,
        Eggs_Len:16, Bin_Eggs/binary,
        Record_Len:16, Bin_Record/binary,
        CumulateReward_Len:16, Bin_CumulateReward/binary
    >>,
    {ok, pt:pack(33120, Data)};

write (33121,[
    Errcode,
    BaseType,
    SubType
]) ->
    Data = <<
        Errcode:32,
        BaseType:16,
        SubType:16
    >>,
    {ok, pt:pack(33121, Data)};

write (33122,[
    Errcode,
    BaseType,
    SubType,
    FreeSmashedTimes,
    SmashedTimes,
    Eggs
]) ->
    BinList_Eggs = [
        item_to_bin_19(Eggs_Item) || Eggs_Item <- Eggs
    ], 

    Eggs_Len = length(Eggs), 
    Bin_Eggs = list_to_binary(BinList_Eggs),

    Data = <<
        Errcode:32,
        BaseType:16,
        SubType:16,
        FreeSmashedTimes:8,
        SmashedTimes:16,
        Eggs_Len:16, Bin_Eggs/binary
    >>,
    {ok, pt:pack(33122, Data)};

write (33123,[
    Errcode,
    BaseType,
    SubType,
    CumulateReward
]) ->
    BinList_CumulateReward = [
        item_to_bin_20(CumulateReward_Item) || CumulateReward_Item <- CumulateReward
    ], 

    CumulateReward_Len = length(CumulateReward), 
    Bin_CumulateReward = list_to_binary(BinList_CumulateReward),

    Data = <<
        Errcode:32,
        BaseType:16,
        SubType:16,
        CumulateReward_Len:16, Bin_CumulateReward/binary
    >>,
    {ok, pt:pack(33123, Data)};

write (33126,[
    Status,
    StageEtime,
    BossList
]) ->
    BinList_BossList = [
        item_to_bin_21(BossList_Item) || BossList_Item <- BossList
    ], 

    BossList_Len = length(BossList), 
    Bin_BossList = list_to_binary(BinList_BossList),

    Data = <<
        Status:8,
        StageEtime:32,
        BossList_Len:16, Bin_BossList/binary
    >>,
    {ok, pt:pack(33126, Data)};

write (33127,[
    Errcode
]) ->
    Data = <<
        Errcode:32
    >>,
    {ok, pt:pack(33127, Data)};

write (33128,[
    BaseType,
    SubType,
    DrawTimes,
    Reset,
    Pool,
    Stage,
    RewardList
]) ->
    BinList_Pool = [
        item_to_bin_22(Pool_Item) || Pool_Item <- Pool
    ], 

    Pool_Len = length(Pool), 
    Bin_Pool = list_to_binary(BinList_Pool),

    BinList_Stage = [
        item_to_bin_23(Stage_Item) || Stage_Item <- Stage
    ], 

    Stage_Len = length(Stage), 
    Bin_Stage = list_to_binary(BinList_Stage),

    BinList_RewardList = [
        item_to_bin_24(RewardList_Item) || RewardList_Item <- RewardList
    ], 

    RewardList_Len = length(RewardList), 
    Bin_RewardList = list_to_binary(BinList_RewardList),

    Data = <<
        BaseType:16,
        SubType:16,
        DrawTimes:16,
        Reset:16,
        Pool_Len:16, Bin_Pool/binary,
        Stage_Len:16, Bin_Stage/binary,
        RewardList_Len:16, Bin_RewardList/binary
    >>,
    {ok, pt:pack(33128, Data)};

write (33129,[
    BaseType,
    SubType,
    Pool,
    ErrorCode
]) ->
    BinList_Pool = [
        item_to_bin_25(Pool_Item) || Pool_Item <- Pool
    ], 

    Pool_Len = length(Pool), 
    Bin_Pool = list_to_binary(BinList_Pool),

    Data = <<
        BaseType:16,
        SubType:16,
        Pool_Len:16, Bin_Pool/binary,
        ErrorCode:32
    >>,
    {ok, pt:pack(33129, Data)};

write (33130,[
    BaseType,
    SubType,
    TicketNum,
    TotalTickets,
    TotalLeftTickets,
    ChargeGold,
    NeedGold,
    NTimesList,
    RewardList
]) ->
    BinList_NTimesList = [
        item_to_bin_26(NTimesList_Item) || NTimesList_Item <- NTimesList
    ], 

    NTimesList_Len = length(NTimesList), 
    Bin_NTimesList = list_to_binary(BinList_NTimesList),

    BinList_RewardList = [
        item_to_bin_27(RewardList_Item) || RewardList_Item <- RewardList
    ], 

    RewardList_Len = length(RewardList), 
    Bin_RewardList = list_to_binary(BinList_RewardList),

    Data = <<
        BaseType:16,
        SubType:16,
        TicketNum:32,
        TotalTickets:32,
        TotalLeftTickets:32,
        ChargeGold:32,
        NeedGold:16,
        NTimesList_Len:16, Bin_NTimesList/binary,
        RewardList_Len:16, Bin_RewardList/binary
    >>,
    {ok, pt:pack(33130, Data)};

write (33131,[
    BaseType,
    SubType,
    GoodsId,
    GoodsNum,
    NTimes,
    TicketNum,
    TotalLeftTickets
]) ->
    Data = <<
        BaseType:16,
        SubType:16,
        GoodsId:32,
        GoodsNum:32,
        NTimes:8,
        TicketNum:32,
        TotalLeftTickets:32
    >>,
    {ok, pt:pack(33131, Data)};

write (33132,[
    BaseType,
    SubType,
    List
]) ->
    BinList_List = [
        item_to_bin_28(List_Item) || List_Item <- List
    ], 

    List_Len = length(List), 
    Bin_List = list_to_binary(BinList_List),

    Data = <<
        BaseType:16,
        SubType:16,
        List_Len:16, Bin_List/binary
    >>,
    {ok, pt:pack(33132, Data)};

write (33133,[
    BaseType,
    SubType,
    ErrorCode,
    DrawTimes,
    Reset,
    Pool,
    Stage
]) ->
    BinList_Pool = [
        item_to_bin_29(Pool_Item) || Pool_Item <- Pool
    ], 

    Pool_Len = length(Pool), 
    Bin_Pool = list_to_binary(BinList_Pool),

    BinList_Stage = [
        item_to_bin_30(Stage_Item) || Stage_Item <- Stage
    ], 

    Stage_Len = length(Stage), 
    Bin_Stage = list_to_binary(BinList_Stage),

    Data = <<
        BaseType:16,
        SubType:16,
        ErrorCode:32,
        DrawTimes:16,
        Reset:16,
        Pool_Len:16, Bin_Pool/binary,
        Stage_Len:16, Bin_Stage/binary
    >>,
    {ok, pt:pack(33133, Data)};

write (33134,[
    BaseType,
    SubType,
    DrawTimes,
    ErrorCode,
    Grade,
    Rare,
    Reward
]) ->
    Bin_Reward = pt:write_object_list(Reward), 

    Data = <<
        BaseType:16,
        SubType:16,
        DrawTimes:16,
        ErrorCode:32,
        Grade:16,
        Rare:8,
        Bin_Reward/binary
    >>,
    {ok, pt:pack(33134, Data)};

write (33135,[
    BaseType,
    SubType,
    Grade,
    ErrorCode
]) ->
    Data = <<
        BaseType:16,
        SubType:16,
        Grade:16,
        ErrorCode:32
    >>,
    {ok, pt:pack(33135, Data)};

write (33136,[
    Errcode,
    SubType,
    RewardList
]) ->
    BinList_RewardList = [
        item_to_bin_31(RewardList_Item) || RewardList_Item <- RewardList
    ], 

    RewardList_Len = length(RewardList), 
    Bin_RewardList = list_to_binary(BinList_RewardList),

    Data = <<
        Errcode:32,
        SubType:16,
        RewardList_Len:16, Bin_RewardList/binary
    >>,
    {ok, pt:pack(33136, Data)};

write (33137,[
    Errcode,
    Grade,
    SubType
]) ->
    Data = <<
        Errcode:32,
        Grade:16,
        SubType:16
    >>,
    {ok, pt:pack(33137, Data)};

write (33138,[
    Errcode,
    Grade,
    SubType
]) ->
    Data = <<
        Errcode:32,
        Grade:16,
        SubType:16
    >>,
    {ok, pt:pack(33138, Data)};

write (33139,[
    BaseType,
    SubType,
    Pool
]) ->
    BinList_Pool = [
        item_to_bin_32(Pool_Item) || Pool_Item <- Pool
    ], 

    Pool_Len = length(Pool), 
    Bin_Pool = list_to_binary(BinList_Pool),

    Data = <<
        BaseType:16,
        SubType:16,
        Pool_Len:16, Bin_Pool/binary
    >>,
    {ok, pt:pack(33139, Data)};

write (33140,[
    SumPoints,
    ModList
]) ->
    BinList_ModList = [
        item_to_bin_33(ModList_Item) || ModList_Item <- ModList
    ], 

    ModList_Len = length(ModList), 
    Bin_ModList = list_to_binary(BinList_ModList),

    Data = <<
        SumPoints:32,
        ModList_Len:16, Bin_ModList/binary
    >>,
    {ok, pt:pack(33140, Data)};

write (33141,[
    BaseType,
    SubType,
    RarePool
]) ->
    BinList_RarePool = [
        item_to_bin_34(RarePool_Item) || RarePool_Item <- RarePool
    ], 

    RarePool_Len = length(RarePool), 
    Bin_RarePool = list_to_binary(BinList_RarePool),

    Data = <<
        BaseType:16,
        SubType:16,
        RarePool_Len:16, Bin_RarePool/binary
    >>,
    {ok, pt:pack(33141, Data)};

write (33142,[
    BaseType,
    SubType,
    Grade,
    ErrorCode,
    RewardList,
    LuckyValue,
    FreeTimes,
    State
]) ->
    BinList_RewardList = [
        item_to_bin_35(RewardList_Item) || RewardList_Item <- RewardList
    ], 

    RewardList_Len = length(RewardList), 
    Bin_RewardList = list_to_binary(BinList_RewardList),

    Data = <<
        BaseType:16,
        SubType:16,
        Grade:16,
        ErrorCode:32,
        RewardList_Len:16, Bin_RewardList/binary,
        LuckyValue:16,
        FreeTimes:16,
        State:8
    >>,
    {ok, pt:pack(33142, Data)};

write (33143,[
    TodayConsume,
    ContinueDay
]) ->
    Data = <<
        TodayConsume:32,
        ContinueDay:8
    >>,
    {ok, pt:pack(33143, Data)};

write (33144,[
    BaseType,
    SubType,
    Grade,
    Code,
    LuckyValue,
    FreeTimes,
    State,
    MaxLuckeyValue
]) ->
    Data = <<
        BaseType:16,
        SubType:16,
        Grade:16,
        Code:32,
        LuckyValue:16,
        FreeTimes:16,
        State:8,
        MaxLuckeyValue:16
    >>,
    {ok, pt:pack(33144, Data)};

write (33145,[
    BossList
]) ->
    BinList_BossList = [
        item_to_bin_36(BossList_Item) || BossList_Item <- BossList
    ], 

    BossList_Len = length(BossList), 
    Bin_BossList = list_to_binary(BinList_BossList),

    Data = <<
        BossList_Len:16, Bin_BossList/binary
    >>,
    {ok, pt:pack(33145, Data)};

write (33146,[
    Errcode,
    BossId,
    RewardStatus
]) ->
    Data = <<
        Errcode:32,
        BossId:32,
        RewardStatus:8
    >>,
    {ok, pt:pack(33146, Data)};

write (33148,[
    SubType,
    Time
]) ->
    Data = <<
        SubType:16,
        Time:32
    >>,
    {ok, pt:pack(33148, Data)};

write (33149,[
    SubType,
    Time
]) ->
    Data = <<
        SubType:16,
        Time:32
    >>,
    {ok, pt:pack(33149, Data)};

write (33151,[
    Errcode
]) ->
    Data = <<
        Errcode:32
    >>,
    {ok, pt:pack(33151, Data)};

write (33152,[
    Wlv
]) ->
    Data = <<
        Wlv:16
    >>,
    {ok, pt:pack(33152, Data)};

write (33153,[
    Errcode,
    SubType,
    Type,
    GradeList
]) ->
    BinList_GradeList = [
        item_to_bin_38(GradeList_Item) || GradeList_Item <- GradeList
    ], 

    GradeList_Len = length(GradeList), 
    Bin_GradeList = list_to_binary(BinList_GradeList),

    Data = <<
        Errcode:32,
        SubType:16,
        Type:8,
        GradeList_Len:16, Bin_GradeList/binary
    >>,
    {ok, pt:pack(33153, Data)};

write (33154,[
    SubType,
    RecordList
]) ->
    BinList_RecordList = [
        item_to_bin_39(RecordList_Item) || RecordList_Item <- RecordList
    ], 

    RecordList_Len = length(RecordList), 
    Bin_RecordList = list_to_binary(BinList_RecordList),

    Data = <<
        SubType:16,
        RecordList_Len:16, Bin_RecordList/binary
    >>,
    {ok, pt:pack(33154, Data)};

write (33155,[
    SubType,
    ActValue,
    Wave,
    StartTime,
    ClearType,
    WaveReceive
]) ->
    BinList_WaveReceive = [
        item_to_bin_40(WaveReceive_Item) || WaveReceive_Item <- WaveReceive
    ], 

    WaveReceive_Len = length(WaveReceive), 
    Bin_WaveReceive = list_to_binary(BinList_WaveReceive),

    Data = <<
        SubType:16,
        ActValue:32,
        Wave:8,
        StartTime:32,
        ClearType:8,
        WaveReceive_Len:16, Bin_WaveReceive/binary
    >>,
    {ok, pt:pack(33155, Data)};

write (33157,[
    Errcode,
    SubType,
    Wave,
    Rewards
]) ->
    Bin_Rewards = pt:write_object_list(Rewards), 

    Data = <<
        Errcode:32,
        SubType:16,
        Wave:8,
        Bin_Rewards/binary
    >>,
    {ok, pt:pack(33157, Data)};

write (33158,[
    SubType,
    Wave,
    StartTime
]) ->
    Data = <<
        SubType:16,
        Wave:8,
        StartTime:32
    >>,
    {ok, pt:pack(33158, Data)};

write (33160,[
    Errcode,
    SubType,
    LuckyNum,
    LuckyNumMax
]) ->
    Data = <<
        Errcode:32,
        SubType:16,
        LuckyNum:32,
        LuckyNumMax:32
    >>,
    {ok, pt:pack(33160, Data)};

write (33161,[
    Errcode,
    SubType,
    Type,
    LuckyNum,
    RewardList
]) ->
    BinList_RewardList = [
        item_to_bin_41(RewardList_Item) || RewardList_Item <- RewardList
    ], 

    RewardList_Len = length(RewardList), 
    Bin_RewardList = list_to_binary(BinList_RewardList),

    Data = <<
        Errcode:32,
        SubType:16,
        Type:8,
        LuckyNum:32,
        RewardList_Len:16, Bin_RewardList/binary
    >>,
    {ok, pt:pack(33161, Data)};

write (33162,[
    Errcode,
    SubType,
    NowPoint,
    SelfNowPoint,
    ExpEndTime,
    DropEndTime,
    GetRewardIdList
]) ->
    BinList_GetRewardIdList = [
        item_to_bin_42(GetRewardIdList_Item) || GetRewardIdList_Item <- GetRewardIdList
    ], 

    GetRewardIdList_Len = length(GetRewardIdList), 
    Bin_GetRewardIdList = list_to_binary(BinList_GetRewardIdList),

    Data = <<
        Errcode:32,
        SubType:16,
        NowPoint:32,
        SelfNowPoint:32,
        ExpEndTime:32,
        DropEndTime:32,
        GetRewardIdList_Len:16, Bin_GetRewardIdList/binary
    >>,
    {ok, pt:pack(33162, Data)};

write (33163,[
    Errcode,
    SubType,
    PutType,
    RewardType,
    RewardId
]) ->
    Data = <<
        Errcode:32,
        SubType:16,
        PutType:8,
        RewardType:8,
        RewardId:32
    >>,
    {ok, pt:pack(33163, Data)};

write (33164,[
    Errcode,
    SubType,
    RechargeNum,
    ConsumeNum
]) ->
    Data = <<
        Errcode:32,
        SubType:16,
        RechargeNum:32,
        ConsumeNum:32
    >>,
    {ok, pt:pack(33164, Data)};

write (33165,[
    BaseType,
    SubType,
    Wave,
    AllTimes,
    TodayDrawtimes,
    Pool,
    StageS
]) ->
    BinList_Pool = [
        item_to_bin_43(Pool_Item) || Pool_Item <- Pool
    ], 

    Pool_Len = length(Pool), 
    Bin_Pool = list_to_binary(BinList_Pool),

    BinList_StageS = [
        item_to_bin_44(StageS_Item) || StageS_Item <- StageS
    ], 

    StageS_Len = length(StageS), 
    Bin_StageS = list_to_binary(BinList_StageS),

    Data = <<
        BaseType:16,
        SubType:16,
        Wave:8,
        AllTimes:16,
        TodayDrawtimes:16,
        Pool_Len:16, Bin_Pool/binary,
        StageS_Len:16, Bin_StageS/binary
    >>,
    {ok, pt:pack(33165, Data)};

write (33166,[
    ErrorCode,
    BaseType,
    SubType,
    Stage,
    GradeStage,
    Reward,
    Buy
]) ->
    Bin_Reward = pt:write_object_list(Reward), 

    Data = <<
        ErrorCode:32,
        BaseType:16,
        SubType:16,
        Stage:8,
        GradeStage:8,
        Bin_Reward/binary,
        Buy:8
    >>,
    {ok, pt:pack(33166, Data)};

write (33167,[
    ErrorCode,
    BaseType,
    SubType,
    AllTimes,
    TodayDrawtimes,
    RewardList
]) ->
    BinList_RewardList = [
        item_to_bin_46(RewardList_Item) || RewardList_Item <- RewardList
    ], 

    RewardList_Len = length(RewardList), 
    Bin_RewardList = list_to_binary(BinList_RewardList),

    Data = <<
        ErrorCode:32,
        BaseType:16,
        SubType:16,
        AllTimes:16,
        TodayDrawtimes:16,
        RewardList_Len:16, Bin_RewardList/binary
    >>,
    {ok, pt:pack(33167, Data)};

write (33168,[
    BaseType,
    SubType,
    GradeId,
    ErrorCode,
    Reward,
    Num,
    Score
]) ->
    Bin_Reward = pt:write_object_list(Reward), 

    Data = <<
        BaseType:16,
        SubType:16,
        GradeId:16,
        ErrorCode:32,
        Bin_Reward/binary,
        Num:16,
        Score:32
    >>,
    {ok, pt:pack(33168, Data)};

write (33169,[
]) ->
    Data = <<
    >>,
    {ok, pt:pack(33169, Data)};

write (33170,[
    Type,
    Subtype,
    Stage,
    Etime,
    ShowList
]) ->
    BinList_ShowList = [
        item_to_bin_47(ShowList_Item) || ShowList_Item <- ShowList
    ], 

    ShowList_Len = length(ShowList), 
    Bin_ShowList = list_to_binary(BinList_ShowList),

    Data = <<
        Type:16,
        Subtype:16,
        Stage:8,
        Etime:32,
        ShowList_Len:16, Bin_ShowList/binary
    >>,
    {ok, pt:pack(33170, Data)};

write (33171,[
    Type,
    Subtype,
    ProductList,
    Record
]) ->
    BinList_ProductList = [
        item_to_bin_48(ProductList_Item) || ProductList_Item <- ProductList
    ], 

    ProductList_Len = length(ProductList), 
    Bin_ProductList = list_to_binary(BinList_ProductList),

    BinList_Record = [
        item_to_bin_49(Record_Item) || Record_Item <- Record
    ], 

    Record_Len = length(Record), 
    Bin_Record = list_to_binary(BinList_Record),

    Data = <<
        Type:16,
        Subtype:16,
        ProductList_Len:16, Bin_ProductList/binary,
        Record_Len:16, Bin_Record/binary
    >>,
    {ok, pt:pack(33171, Data)};

write (33172,[
    Type,
    Subtype,
    ObtainList,
    Record
]) ->
    BinList_ObtainList = [
        item_to_bin_50(ObtainList_Item) || ObtainList_Item <- ObtainList
    ], 

    ObtainList_Len = length(ObtainList), 
    Bin_ObtainList = list_to_binary(BinList_ObtainList),

    BinList_Record = [
        item_to_bin_51(Record_Item) || Record_Item <- Record
    ], 

    Record_Len = length(Record), 
    Bin_Record = list_to_binary(BinList_Record),

    Data = <<
        Type:16,
        Subtype:16,
        ObtainList_Len:16, Bin_ObtainList/binary,
        Record_Len:16, Bin_Record/binary
    >>,
    {ok, pt:pack(33172, Data)};

write (33173,[
    Type,
    Subtype,
    Utype
]) ->
    Data = <<
        Type:16,
        Subtype:16,
        Utype:8
    >>,
    {ok, pt:pack(33173, Data)};

write (33174,[
    Errcode,
    Type,
    Subtype,
    ProductId,
    SelfBuyNum,
    SelfBuyLim,
    TotalBuyNum,
    TotalNumLim,
    Reward
]) ->
    BinList_Reward = [
        item_to_bin_52(Reward_Item) || Reward_Item <- Reward
    ], 

    Reward_Len = length(Reward), 
    Bin_Reward = list_to_binary(BinList_Reward),

    Data = <<
        Errcode:32,
        Type:16,
        Subtype:16,
        ProductId:32,
        SelfBuyNum:16,
        SelfBuyLim:16,
        TotalBuyNum:16,
        TotalNumLim:16,
        Reward_Len:16, Bin_Reward/binary
    >>,
    {ok, pt:pack(33174, Data)};

write (33175,[
    WinnerList
]) ->
    BinList_WinnerList = [
        item_to_bin_53(WinnerList_Item) || WinnerList_Item <- WinnerList
    ], 

    WinnerList_Len = length(WinnerList), 
    Bin_WinnerList = list_to_binary(BinList_WinnerList),

    Data = <<
        WinnerList_Len:16, Bin_WinnerList/binary
    >>,
    {ok, pt:pack(33175, Data)};

write (33176,[
    BaseType,
    SubType,
    ErrorCode,
    List,
    FreeTimes,
    TotalScore,
    Stage
]) ->
    BinList_List = [
        item_to_bin_54(List_Item) || List_Item <- List
    ], 

    List_Len = length(List), 
    Bin_List = list_to_binary(BinList_List),

    BinList_Stage = [
        item_to_bin_55(Stage_Item) || Stage_Item <- Stage
    ], 

    Stage_Len = length(Stage), 
    Bin_Stage = list_to_binary(BinList_Stage),

    Data = <<
        BaseType:16,
        SubType:16,
        ErrorCode:32,
        List_Len:16, Bin_List/binary,
        FreeTimes:8,
        TotalScore:16,
        Stage_Len:16, Bin_Stage/binary
    >>,
    {ok, pt:pack(33176, Data)};

write (33177,[
    BaseType,
    SubType,
    FreeTimes,
    TotalScore,
    RewardList,
    Stage
]) ->
    BinList_RewardList = [
        item_to_bin_56(RewardList_Item) || RewardList_Item <- RewardList
    ], 

    RewardList_Len = length(RewardList), 
    Bin_RewardList = list_to_binary(BinList_RewardList),

    BinList_Stage = [
        item_to_bin_57(Stage_Item) || Stage_Item <- Stage
    ], 

    Stage_Len = length(Stage), 
    Bin_Stage = list_to_binary(BinList_Stage),

    Data = <<
        BaseType:16,
        SubType:16,
        FreeTimes:8,
        TotalScore:16,
        RewardList_Len:16, Bin_RewardList/binary,
        Stage_Len:16, Bin_Stage/binary
    >>,
    {ok, pt:pack(33177, Data)};

write (33178,[
    BaseType,
    SubType,
    Grade,
    ErrorCode,
    Reward
]) ->
    Bin_Reward = pt:write_object_list(Reward), 

    Data = <<
        BaseType:16,
        SubType:16,
        Grade:16,
        ErrorCode:32,
        Bin_Reward/binary
    >>,
    {ok, pt:pack(33178, Data)};

write (33179,[
    ErrorCode,
    Num,
    BaseType,
    SubType,
    Grade
]) ->
    Data = <<
        ErrorCode:32,
        Num:16,
        BaseType:16,
        SubType:16,
        Grade:16
    >>,
    {ok, pt:pack(33179, Data)};

write (33180,[
    Type,
    Subtype,
    IsOpen,
    UseTimes,
    TotalUseTimes,
    IsFreeRefresh,
    RefreshTimes,
    RewardList,
    RecordList
]) ->
    BinList_RewardList = [
        item_to_bin_58(RewardList_Item) || RewardList_Item <- RewardList
    ], 

    RewardList_Len = length(RewardList), 
    Bin_RewardList = list_to_binary(BinList_RewardList),

    BinList_RecordList = [
        item_to_bin_59(RecordList_Item) || RecordList_Item <- RecordList
    ], 

    RecordList_Len = length(RecordList), 
    Bin_RecordList = list_to_binary(BinList_RecordList),

    Data = <<
        Type:16,
        Subtype:16,
        IsOpen:8,
        UseTimes:16,
        TotalUseTimes:16,
        IsFreeRefresh:8,
        RefreshTimes:16,
        RewardList_Len:16, Bin_RewardList/binary,
        RecordList_Len:16, Bin_RecordList/binary
    >>,
    {ok, pt:pack(33180, Data)};

write (33181,[
    Errcode
]) ->
    Data = <<
        Errcode:32
    >>,
    {ok, pt:pack(33181, Data)};

write (33182,[
    Errcode,
    Pos,
    GtypeId,
    Num,
    UseTimes,
    TotalUseTimes
]) ->
    Data = <<
        Errcode:32,
        Pos:8,
        GtypeId:32,
        Num:32,
        UseTimes:16,
        TotalUseTimes:16
    >>,
    {ok, pt:pack(33182, Data)};

write (33183,[
    Errcode,
    Type,
    Subtype
]) ->
    Data = <<
        Errcode:32,
        Type:16,
        Subtype:16
    >>,
    {ok, pt:pack(33183, Data)};

write (33184,[
    Type,
    Subtype,
    RecordList
]) ->
    BinList_RecordList = [
        item_to_bin_60(RecordList_Item) || RecordList_Item <- RecordList
    ], 

    RecordList_Len = length(RecordList), 
    Bin_RecordList = list_to_binary(BinList_RecordList),

    Data = <<
        Type:16,
        Subtype:16,
        RecordList_Len:16, Bin_RecordList/binary
    >>,
    {ok, pt:pack(33184, Data)};

write (33185,[
    Code
]) ->
    Data = <<
        Code:8
    >>,
    {ok, pt:pack(33185, Data)};

write (33186,[
    Errcode,
    RewardList
]) ->
    BinList_RewardList = [
        item_to_bin_61(RewardList_Item) || RewardList_Item <- RewardList
    ], 

    RewardList_Len = length(RewardList), 
    Bin_RewardList = list_to_binary(BinList_RewardList),

    Data = <<
        Errcode:32,
        RewardList_Len:16, Bin_RewardList/binary
    >>,
    {ok, pt:pack(33186, Data)};

write (33187,[
    Errcode,
    ShakeTimes
]) ->
    Data = <<
        Errcode:32,
        ShakeTimes:32
    >>,
    {ok, pt:pack(33187, Data)};

write (33188,[
    MyRank,
    Cost,
    RankList
]) ->
    BinList_RankList = [
        item_to_bin_62(RankList_Item) || RankList_Item <- RankList
    ], 

    RankList_Len = length(RankList), 
    Bin_RankList = list_to_binary(BinList_RankList),

    Data = <<
        MyRank:32,
        Cost:64,
        RankList_Len:16, Bin_RankList/binary
    >>,
    {ok, pt:pack(33188, Data)};

write (33189,[
    Subtype,
    RankList
]) ->
    BinList_RankList = [
        item_to_bin_63(RankList_Item) || RankList_Item <- RankList
    ], 

    RankList_Len = length(RankList), 
    Bin_RankList = list_to_binary(BinList_RankList),

    Data = <<
        Subtype:16,
        RankList_Len:16, Bin_RankList/binary
    >>,
    {ok, pt:pack(33189, Data)};

write (33190,[
    BaseType,
    SubType,
    ErrorCode,
    AllTimes,
    FreeTimes,
    ShowList,
    CumulateReward,
    Score,
    Shop
]) ->
    BinList_ShowList = [
        item_to_bin_64(ShowList_Item) || ShowList_Item <- ShowList
    ], 

    ShowList_Len = length(ShowList), 
    Bin_ShowList = list_to_binary(BinList_ShowList),

    BinList_CumulateReward = [
        item_to_bin_65(CumulateReward_Item) || CumulateReward_Item <- CumulateReward
    ], 

    CumulateReward_Len = length(CumulateReward), 
    Bin_CumulateReward = list_to_binary(BinList_CumulateReward),

    BinList_Shop = [
        item_to_bin_66(Shop_Item) || Shop_Item <- Shop
    ], 

    Shop_Len = length(Shop), 
    Bin_Shop = list_to_binary(BinList_Shop),

    Data = <<
        BaseType:16,
        SubType:16,
        ErrorCode:32,
        AllTimes:16,
        FreeTimes:16,
        ShowList_Len:16, Bin_ShowList/binary,
        CumulateReward_Len:16, Bin_CumulateReward/binary,
        Score:32,
        Shop_Len:16, Bin_Shop/binary
    >>,
    {ok, pt:pack(33190, Data)};

write (33191,[
    ErrorCode,
    BaseType,
    SubType,
    AllTimes,
    FreeTimes,
    RewardList,
    Score
]) ->
    BinList_RewardList = [
        item_to_bin_67(RewardList_Item) || RewardList_Item <- RewardList
    ], 

    RewardList_Len = length(RewardList), 
    Bin_RewardList = list_to_binary(BinList_RewardList),

    Data = <<
        ErrorCode:32,
        BaseType:16,
        SubType:16,
        AllTimes:16,
        FreeTimes:16,
        RewardList_Len:16, Bin_RewardList/binary,
        Score:32
    >>,
    {ok, pt:pack(33191, Data)};

write (33192,[
    ErrorCode,
    BaseType,
    SubType,
    CumulateReward
]) ->
    BinList_CumulateReward = [
        item_to_bin_68(CumulateReward_Item) || CumulateReward_Item <- CumulateReward
    ], 

    CumulateReward_Len = length(CumulateReward), 
    Bin_CumulateReward = list_to_binary(BinList_CumulateReward),

    Data = <<
        ErrorCode:32,
        BaseType:16,
        SubType:16,
        CumulateReward_Len:16, Bin_CumulateReward/binary
    >>,
    {ok, pt:pack(33192, Data)};

write (33193,[
    BaseType,
    SubType,
    PersonTimes,
    ServerTimes,
    SerRewardList
]) ->
    BinList_SerRewardList = [
        item_to_bin_69(SerRewardList_Item) || SerRewardList_Item <- SerRewardList
    ], 

    SerRewardList_Len = length(SerRewardList), 
    Bin_SerRewardList = list_to_binary(BinList_SerRewardList),

    Data = <<
        BaseType:16,
        SubType:16,
        PersonTimes:16,
        ServerTimes:16,
        SerRewardList_Len:16, Bin_SerRewardList/binary
    >>,
    {ok, pt:pack(33193, Data)};

write (33194,[
    ErrorCode,
    BaseType,
    SubType,
    CostType,
    RewardList,
    PersonTimes
]) ->
    BinList_RewardList = [
        item_to_bin_70(RewardList_Item) || RewardList_Item <- RewardList
    ], 

    RewardList_Len = length(RewardList), 
    Bin_RewardList = list_to_binary(BinList_RewardList),

    Data = <<
        ErrorCode:32,
        BaseType:16,
        SubType:16,
        CostType:8,
        RewardList_Len:16, Bin_RewardList/binary,
        PersonTimes:16
    >>,
    {ok, pt:pack(33194, Data)};

write (33195,[
    ErrorCode,
    BaseType,
    SubType,
    GradeId,
    Reward
]) ->
    Bin_Reward = pt:write_object_list(Reward), 

    Data = <<
        ErrorCode:32,
        BaseType:16,
        SubType:16,
        GradeId:16,
        Bin_Reward/binary
    >>,
    {ok, pt:pack(33195, Data)};

write (33196,[
    BaseType,
    SubType,
    ServerTimes,
    IsAsk,
    TriggerTypeList
]) ->
    BinList_TriggerTypeList = [
        item_to_bin_71(TriggerTypeList_Item) || TriggerTypeList_Item <- TriggerTypeList
    ], 

    TriggerTypeList_Len = length(TriggerTypeList), 
    Bin_TriggerTypeList = list_to_binary(BinList_TriggerTypeList),

    Data = <<
        BaseType:16,
        SubType:16,
        ServerTimes:16,
        IsAsk:8,
        TriggerTypeList_Len:16, Bin_TriggerTypeList/binary
    >>,
    {ok, pt:pack(33196, Data)};

write (33197,[
    BaseType,
    SubType,
    LogList,
    SelfList
]) ->
    BinList_LogList = [
        item_to_bin_72(LogList_Item) || LogList_Item <- LogList
    ], 

    LogList_Len = length(LogList), 
    Bin_LogList = list_to_binary(BinList_LogList),

    BinList_SelfList = [
        item_to_bin_73(SelfList_Item) || SelfList_Item <- SelfList
    ], 

    SelfList_Len = length(SelfList), 
    Bin_SelfList = list_to_binary(BinList_SelfList),

    Data = <<
        BaseType:16,
        SubType:16,
        LogList_Len:16, Bin_LogList/binary,
        SelfList_Len:16, Bin_SelfList/binary
    >>,
    {ok, pt:pack(33197, Data)};

write (33198,[
    Errcode,
    BaseType,
    SubType,
    List
]) ->
    BinList_List = [
        item_to_bin_74(List_Item) || List_Item <- List
    ], 

    List_Len = length(List), 
    Bin_List = list_to_binary(BinList_List),

    Data = <<
        Errcode:32,
        BaseType:16,
        SubType:16,
        List_Len:16, Bin_List/binary
    >>,
    {ok, pt:pack(33198, Data)};

write (33199,[
    List
]) ->
    BinList_List = [
        item_to_bin_75(List_Item) || List_Item <- List
    ], 

    List_Len = length(List), 
    Bin_List = list_to_binary(BinList_List),

    Data = <<
        List_Len:16, Bin_List/binary
    >>,
    {ok, pt:pack(33199, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 ({
    BaseType,
    SubType,
    ActType,
    ShowId,
    Wlv,
    Name,
    Desc,
    Condition,
    Stime,
    Etime
}) ->
    Bin_Name = pt:write_string(Name), 

    Bin_Desc = pt:write_string(Desc), 

    Bin_Condition = pt:write_string(Condition), 

    Data = <<
        BaseType:16,
        SubType:16,
        ActType:8,
        ShowId:16,
        Wlv:16,
        Bin_Name/binary,
        Bin_Desc/binary,
        Bin_Condition/binary,
        Stime:32,
        Etime:32
    >>,
    Data.
item_to_bin_1 ({
    BaseType,
    SubType,
    ActType,
    ShowId,
    Wlv,
    Name,
    Desc,
    Condition,
    Stime,
    Etime
}) ->
    Bin_Name = pt:write_string(Name), 

    Bin_Desc = pt:write_string(Desc), 

    Bin_Condition = pt:write_string(Condition), 

    Data = <<
        BaseType:16,
        SubType:16,
        ActType:8,
        ShowId:16,
        Wlv:16,
        Bin_Name/binary,
        Bin_Desc/binary,
        Bin_Condition/binary,
        Stime:32,
        Etime:32
    >>,
    Data.
item_to_bin_2 ({
    BaseType,
    SubType
}) ->
    Data = <<
        BaseType:16,
        SubType:16
    >>,
    Data.
item_to_bin_3 ({
    Grade,
    FormType,
    Status,
    ReceiveTimes,
    Name,
    Desc,
    Condition,
    Reward
}) ->
    Bin_Name = pt:write_string(Name), 

    Bin_Desc = pt:write_string(Desc), 

    Bin_Condition = pt:write_string(Condition), 

    Bin_Reward = pt:write_string(Reward), 

    Data = <<
        Grade:16,
        FormType:8,
        Status:8,
        ReceiveTimes:16,
        Bin_Name/binary,
        Bin_Desc/binary,
        Bin_Condition/binary,
        Bin_Reward/binary
    >>,
    Data.
item_to_bin_4 ({
    Type,
    Value
}) ->
    Data = <<
        Type:8,
        Value:32
    >>,
    Data.
item_to_bin_5 ({
    BaseType,
    SubType
}) ->
    Data = <<
        BaseType:16,
        SubType:16
    >>,
    Data.
item_to_bin_6 ({
    Grade,
    CostType,
    CostNum,
    CostDiscount,
    LessNum,
    AllNum,
    LessNumSelf,
    AllNumSelf
}) ->
    Data = <<
        Grade:16,
        CostType:16,
        CostNum:32,
        CostDiscount:16,
        LessNum:16,
        AllNum:16,
        LessNumSelf:16,
        AllNumSelf:16
    >>,
    Data.
item_to_bin_7 ({
    Platform,
    ServerNum,
    Name,
    GoodsIdList,
    PlayerBuyNum,
    AwardTime
}) ->
    Bin_Platform = pt:write_string(Platform), 

    Bin_Name = pt:write_string(Name), 

    BinList_GoodsIdList = [
        item_to_bin_8(GoodsIdList_Item) || GoodsIdList_Item <- GoodsIdList
    ], 

    GoodsIdList_Len = length(GoodsIdList), 
    Bin_GoodsIdList = list_to_binary(BinList_GoodsIdList),

    Data = <<
        Bin_Platform/binary,
        ServerNum:16,
        Bin_Name/binary,
        GoodsIdList_Len:16, Bin_GoodsIdList/binary,
        PlayerBuyNum:16,
        AwardTime:32
    >>,
    Data.
item_to_bin_8 (
    GoodsId
) ->
    Data = <<
        GoodsId:32
    >>,
    Data.
item_to_bin_9 ({
    BuyTimes,
    State
}) ->
    Data = <<
        BuyTimes:16,
        State:8
    >>,
    Data.
item_to_bin_10 ({
    GoodType,
    RewardId,
    RewardNum
}) ->
    Data = <<
        GoodType:16,
        RewardId:32,
        RewardNum:16
    >>,
    Data.
item_to_bin_11 (
    BuyTimes
) ->
    Data = <<
        BuyTimes:16
    >>,
    Data.
item_to_bin_12 ({
    BigBingoId,
    AwardTime,
    Platform,
    ServerNum,
    Name,
    RoleId,
    BuyTimes
}) ->
    Bin_Platform = pt:write_string(Platform), 

    Bin_Name = pt:write_string(Name), 

    Data = <<
        BigBingoId:16,
        AwardTime:32,
        Bin_Platform/binary,
        ServerNum:16,
        Bin_Name/binary,
        RoleId:64,
        BuyTimes:16
    >>,
    Data.
item_to_bin_13 ({
    WeddingTypeId,
    WeddingTimes
}) ->
    Data = <<
        WeddingTypeId:8,
        WeddingTimes:16
    >>,
    Data.
item_to_bin_14 ({
    BuyTimes,
    State
}) ->
    Data = <<
        BuyTimes:16,
        State:8
    >>,
    Data.
item_to_bin_15 (
    GoodsList
) ->
    Bin_GoodsList = pt:write_object_list(GoodsList), 

    Data = <<
        Bin_GoodsList/binary
    >>,
    Data.
item_to_bin_16 ({
    Id,
    Etype,
    Status,
    GoodsList
}) ->
    Bin_GoodsList = pt:write_object_list(GoodsList), 

    Data = <<
        Id:8,
        Etype:8,
        Status:8,
        Bin_GoodsList/binary
    >>,
    Data.
item_to_bin_17 ({
    Name,
    GoodsList,
    Time
}) ->
    Bin_Name = pt:write_string(Name), 

    Bin_GoodsList = pt:write_object_list(GoodsList), 

    Data = <<
        Bin_Name/binary,
        Bin_GoodsList/binary,
        Time:32
    >>,
    Data.
item_to_bin_18 ({
    GradeId,
    Times,
    Reward,
    Status
}) ->
    Bin_Reward = pt:write_object_list(Reward), 

    Data = <<
        GradeId:16,
        Times:16,
        Bin_Reward/binary,
        Status:8
    >>,
    Data.
item_to_bin_19 ({
    Id,
    GoodsList
}) ->
    Bin_GoodsList = pt:write_object_list(GoodsList), 

    Data = <<
        Id:8,
        Bin_GoodsList/binary
    >>,
    Data.
item_to_bin_20 ({
    GradeId,
    Times,
    Reward,
    Status
}) ->
    Bin_Reward = pt:write_object_list(Reward), 

    Data = <<
        GradeId:16,
        Times:16,
        Bin_Reward/binary,
        Status:8
    >>,
    Data.
item_to_bin_21 ({
    SceneId,
    RemainNum
}) ->
    Data = <<
        SceneId:32,
        RemainNum:8
    >>,
    Data.
item_to_bin_22 ({
    Rare,
    Grade,
    Status
}) ->
    Data = <<
        Rare:8,
        Grade:16,
        Status:8
    >>,
    Data.
item_to_bin_23 ({
    Grade,
    Status
}) ->
    Data = <<
        Grade:16,
        Status:8
    >>,
    Data.
item_to_bin_24 ({
    Grade,
    FormType,
    Name,
    Desc,
    Condition,
    Reward
}) ->
    Bin_Name = pt:write_string(Name), 

    Bin_Desc = pt:write_string(Desc), 

    Bin_Condition = pt:write_string(Condition), 

    Bin_Reward = pt:write_string(Reward), 

    Data = <<
        Grade:16,
        FormType:8,
        Bin_Name/binary,
        Bin_Desc/binary,
        Bin_Condition/binary,
        Bin_Reward/binary
    >>,
    Data.
item_to_bin_25 ({
    Rare,
    Grade,
    Status
}) ->
    Data = <<
        Rare:8,
        Grade:16,
        Status:8
    >>,
    Data.
item_to_bin_26 (
    NTimes
) ->
    Data = <<
        NTimes:8
    >>,
    Data.
item_to_bin_27 ({
    GoodsId,
    GoodsNum
}) ->
    Data = <<
        GoodsId:32,
        GoodsNum:32
    >>,
    Data.
item_to_bin_28 ({
    RoleId,
    RoleName,
    GoodsId,
    GoodsNum,
    NTimes
}) ->
    Bin_RoleName = pt:write_string(RoleName), 

    Data = <<
        RoleId:32,
        Bin_RoleName/binary,
        GoodsId:32,
        GoodsNum:32,
        NTimes:8
    >>,
    Data.
item_to_bin_29 ({
    Rare,
    Grade,
    Status
}) ->
    Data = <<
        Rare:8,
        Grade:16,
        Status:8
    >>,
    Data.
item_to_bin_30 ({
    Grade,
    Status
}) ->
    Data = <<
        Grade:16,
        Status:8
    >>,
    Data.
item_to_bin_31 ({
    Grade,
    FormType,
    Status,
    ReceiveTime,
    Name,
    Desc,
    Condition,
    Reward
}) ->
    Bin_Name = pt:write_string(Name), 

    Bin_Desc = pt:write_string(Desc), 

    Bin_Condition = pt:write_string(Condition), 

    Bin_Reward = pt:write_string(Reward), 

    Data = <<
        Grade:16,
        FormType:8,
        Status:8,
        ReceiveTime:32,
        Bin_Name/binary,
        Bin_Desc/binary,
        Bin_Condition/binary,
        Bin_Reward/binary
    >>,
    Data.
item_to_bin_32 ({
    Rare,
    Grade
}) ->
    Data = <<
        Rare:8,
        Grade:16
    >>,
    Data.
item_to_bin_33 ({
    ModId,
    SubId,
    ConditionType,
    Name,
    OrderId,
    JumpId,
    SecValue,
    IconType,
    ProValue,
    IsPro,
    CondiVal,
    RewardPoint,
    Dec,
    IsCom
}) ->
    Bin_ConditionType = pt:write_string(ConditionType), 

    Bin_Name = pt:write_string(Name), 

    Bin_IconType = pt:write_string(IconType), 

    Bin_Dec = pt:write_string(Dec), 

    Data = <<
        ModId:32,
        SubId:32,
        Bin_ConditionType/binary,
        Bin_Name/binary,
        OrderId:16,
        JumpId:16,
        SecValue:32,
        Bin_IconType/binary,
        ProValue:64,
        IsPro:16,
        CondiVal:32,
        RewardPoint:32,
        Bin_Dec/binary,
        IsCom:16
    >>,
    Data.
item_to_bin_34 ({
    Grade,
    LuckyValue,
    FreeTimes,
    State,
    MaxLuckeyValue
}) ->
    Data = <<
        Grade:16,
        LuckyValue:16,
        FreeTimes:16,
        State:8,
        MaxLuckeyValue:16
    >>,
    Data.
item_to_bin_35 ({
    Reward,
    IsRare
}) ->
    Bin_Reward = pt:write_object_list(Reward), 

    Data = <<
        Bin_Reward/binary,
        IsRare:8
    >>,
    Data.
item_to_bin_36 ({
    Grade,
    BossId,
    Killed,
    RewardState,
    BlList,
    RewardList
}) ->
    BinList_BlList = [
        item_to_bin_37(BlList_Item) || BlList_Item <- BlList
    ], 

    BlList_Len = length(BlList), 
    Bin_BlList = list_to_binary(BinList_BlList),

    Bin_RewardList = pt:write_object_list(RewardList), 

    Data = <<
        Grade:16,
        BossId:32,
        Killed:8,
        RewardState:8,
        BlList_Len:16, Bin_BlList/binary,
        Bin_RewardList/binary
    >>,
    Data.
item_to_bin_37 ({
    RoleId,
    Name
}) ->
    Bin_Name = pt:write_string(Name), 

    Data = <<
        RoleId:64,
        Bin_Name/binary
    >>,
    Data.
item_to_bin_38 (
    GradeId
) ->
    Data = <<
        GradeId:16
    >>,
    Data.
item_to_bin_39 ({
    RoleId,
    RoleName,
    GradeId,
    Time
}) ->
    Bin_RoleName = pt:write_string(RoleName), 

    Data = <<
        RoleId:32,
        Bin_RoleName/binary,
        GradeId:16,
        Time:32
    >>,
    Data.
item_to_bin_40 ({
    Wave2,
    IsReceive,
    Rewards
}) ->
    Bin_Rewards = pt:write_object_list(Rewards), 

    Data = <<
        Wave2:8,
        IsReceive:8,
        Bin_Rewards/binary
    >>,
    Data.
item_to_bin_41 (
    RewardId
) ->
    Data = <<
        RewardId:32
    >>,
    Data.
item_to_bin_42 (
    RewardId
) ->
    Data = <<
        RewardId:32
    >>,
    Data.
item_to_bin_43 ({
    Reward,
    GradeId,
    IsRare,
    Sort,
    State
}) ->
    Bin_Reward = pt:write_object_list(Reward), 

    Data = <<
        Bin_Reward/binary,
        GradeId:16,
        IsRare:8,
        Sort:8,
        State:8
    >>,
    Data.
item_to_bin_44 ({
    Stage,
    GradeState
}) ->
    BinList_GradeState = [
        item_to_bin_45(GradeState_Item) || GradeState_Item <- GradeState
    ], 

    GradeState_Len = length(GradeState), 
    Bin_GradeState = list_to_binary(BinList_GradeState),

    Data = <<
        Stage:8,
        GradeState_Len:16, Bin_GradeState/binary
    >>,
    Data.
item_to_bin_45 ({
    GradeStage,
    GradeReward,
    BuyReward,
    StateStage,
    DiscountState
}) ->
    Bin_GradeReward = pt:write_object_list(GradeReward), 

    Bin_BuyReward = pt:write_object_list(BuyReward), 

    Data = <<
        GradeStage:8,
        Bin_GradeReward/binary,
        Bin_BuyReward/binary,
        StateStage:8,
        DiscountState:8
    >>,
    Data.
item_to_bin_46 ({
    GradeId,
    IsRare,
    Reward,
    Sort
}) ->
    Bin_Reward = pt:write_object_list(Reward), 

    Data = <<
        GradeId:16,
        IsRare:8,
        Bin_Reward/binary,
        Sort:8
    >>,
    Data.
item_to_bin_47 ({
    ObjectType,
    GtypeId,
    Num,
    IsRare
}) ->
    Data = <<
        ObjectType:8,
        GtypeId:32,
        Num:32,
        IsRare:8
    >>,
    Data.
item_to_bin_48 ({
    ProductId,
    ProductName,
    GtypeId,
    GoodsNum,
    TotalBuyNum,
    TotalNumLim,
    SelfBuyNum,
    SelfBuyLim,
    WinnerNum,
    WinnerNumLim
}) ->
    Bin_ProductName = pt:write_string(ProductName), 

    Data = <<
        ProductId:32,
        Bin_ProductName/binary,
        GtypeId:32,
        GoodsNum:32,
        TotalBuyNum:16,
        TotalNumLim:16,
        SelfBuyNum:16,
        SelfBuyLim:16,
        WinnerNum:16,
        WinnerNumLim:16
    >>,
    Data.
item_to_bin_49 ({
    ServerName,
    RoleName,
    ProductName,
    BuyNum
}) ->
    Bin_ServerName = pt:write_string(ServerName), 

    Bin_RoleName = pt:write_string(RoleName), 

    Bin_ProductName = pt:write_string(ProductName), 

    Data = <<
        Bin_ServerName/binary,
        Bin_RoleName/binary,
        Bin_ProductName/binary,
        BuyNum:16
    >>,
    Data.
item_to_bin_50 ({
    ObjectType,
    GtypeId,
    Num
}) ->
    Data = <<
        ObjectType:8,
        GtypeId:32,
        Num:32
    >>,
    Data.
item_to_bin_51 ({
    ServerName,
    RoleName,
    ProductName,
    ProductNum
}) ->
    Bin_ServerName = pt:write_string(ServerName), 

    Bin_RoleName = pt:write_string(RoleName), 

    Bin_ProductName = pt:write_string(ProductName), 

    Data = <<
        Bin_ServerName/binary,
        Bin_RoleName/binary,
        Bin_ProductName/binary,
        ProductNum:32
    >>,
    Data.
item_to_bin_52 ({
    ObjectType,
    GtypeId,
    Num
}) ->
    Data = <<
        ObjectType:8,
        GtypeId:32,
        Num:32
    >>,
    Data.
item_to_bin_53 ({
    ServerName,
    RoleName
}) ->
    Bin_ServerName = pt:write_string(ServerName), 

    Bin_RoleName = pt:write_string(RoleName), 

    Data = <<
        Bin_ServerName/binary,
        Bin_RoleName/binary
    >>,
    Data.
item_to_bin_54 ({
    IsRare,
    Reward
}) ->
    Bin_Reward = pt:write_object_list(Reward), 

    Data = <<
        IsRare:16,
        Bin_Reward/binary
    >>,
    Data.
item_to_bin_55 ({
    Grade,
    Score,
    Reward,
    Status
}) ->
    Bin_Reward = pt:write_object_list(Reward), 

    Data = <<
        Grade:16,
        Score:16,
        Bin_Reward/binary,
        Status:8
    >>,
    Data.
item_to_bin_56 ({
    Grade,
    FormType,
    Status,
    ReceiveTimes,
    Name,
    Desc,
    Condition,
    Reward
}) ->
    Bin_Name = pt:write_string(Name), 

    Bin_Desc = pt:write_string(Desc), 

    Bin_Condition = pt:write_string(Condition), 

    Bin_Reward = pt:write_string(Reward), 

    Data = <<
        Grade:16,
        FormType:8,
        Status:8,
        ReceiveTimes:16,
        Bin_Name/binary,
        Bin_Desc/binary,
        Bin_Condition/binary,
        Bin_Reward/binary
    >>,
    Data.
item_to_bin_57 ({
    Grade,
    Score,
    Reward,
    Status
}) ->
    Bin_Reward = pt:write_object_list(Reward), 

    Data = <<
        Grade:16,
        Score:16,
        Bin_Reward/binary,
        Status:8
    >>,
    Data.
item_to_bin_58 ({
    GtypeId,
    Num,
    Pos
}) ->
    Data = <<
        GtypeId:32,
        Num:32,
        Pos:8
    >>,
    Data.
item_to_bin_59 ({
    RoleName,
    GtypeId,
    Num,
    Time
}) ->
    Bin_RoleName = pt:write_string(RoleName), 

    Data = <<
        Bin_RoleName/binary,
        GtypeId:32,
        Num:32,
        Time:32
    >>,
    Data.
item_to_bin_60 ({
    RoleName,
    GtypeId,
    Num,
    Time
}) ->
    Bin_RoleName = pt:write_string(RoleName), 

    Data = <<
        Bin_RoleName/binary,
        GtypeId:32,
        Num:32,
        Time:32
    >>,
    Data.
item_to_bin_61 ({
    GradeId,
    SameNum,
    Reward
}) ->
    Bin_Reward = pt:write_object_list(Reward), 

    Data = <<
        GradeId:16,
        SameNum:8,
        Bin_Reward/binary
    >>,
    Data.
item_to_bin_62 ({
    RoleId,
    RoleName,
    Rank,
    Cost
}) ->
    Bin_RoleName = pt:write_string(RoleName), 

    Data = <<
        RoleId:64,
        Bin_RoleName/binary,
        Rank:16,
        Cost:64
    >>,
    Data.
item_to_bin_63 ({
    GradeId,
    LimitCost,
    MinRank,
    MaxRank,
    Reward
}) ->
    Bin_Reward = pt:write_object_list(Reward), 

    Data = <<
        GradeId:16,
        LimitCost:64,
        MinRank:16,
        MaxRank:16,
        Bin_Reward/binary
    >>,
    Data.
item_to_bin_64 ({
    GradeId,
    IsRare,
    Reward
}) ->
    Bin_Reward = pt:write_object_list(Reward), 

    Data = <<
        GradeId:16,
        IsRare:8,
        Bin_Reward/binary
    >>,
    Data.
item_to_bin_65 ({
    GradeId,
    Times,
    Reward,
    Status
}) ->
    Bin_Reward = pt:write_object_list(Reward), 

    Data = <<
        GradeId:16,
        Times:16,
        Bin_Reward/binary,
        Status:8
    >>,
    Data.
item_to_bin_66 ({
    GradeId,
    Reward,
    NeedScore,
    Num,
    MaxNum,
    ClearType
}) ->
    Bin_Reward = pt:write_object_list(Reward), 

    Data = <<
        GradeId:16,
        Bin_Reward/binary,
        NeedScore:32,
        Num:16,
        MaxNum:16,
        ClearType:8
    >>,
    Data.
item_to_bin_67 ({
    GradeId,
    IsRare,
    Reward
}) ->
    Bin_Reward = pt:write_object_list(Reward), 

    Data = <<
        GradeId:16,
        IsRare:8,
        Bin_Reward/binary
    >>,
    Data.
item_to_bin_68 ({
    GradeId,
    Times,
    Reward,
    Status
}) ->
    Bin_Reward = pt:write_object_list(Reward), 

    Data = <<
        GradeId:16,
        Times:16,
        Bin_Reward/binary,
        Status:8
    >>,
    Data.
item_to_bin_69 ({
    GradeId,
    TriggerType,
    Param,
    Times,
    Reward,
    Status
}) ->
    Bin_Param = pt:write_string(Param), 

    Bin_Reward = pt:write_object_list(Reward), 

    Data = <<
        GradeId:16,
        TriggerType:8,
        Bin_Param/binary,
        Times:16,
        Bin_Reward/binary,
        Status:8
    >>,
    Data.
item_to_bin_70 ({
    GradeId,
    IsRare,
    Reward
}) ->
    Bin_Reward = pt:write_object_list(Reward), 

    Data = <<
        GradeId:16,
        IsRare:8,
        Bin_Reward/binary
    >>,
    Data.
item_to_bin_71 (
    TriggerType
) ->
    Data = <<
        TriggerType:8
    >>,
    Data.
item_to_bin_72 ({
    RoleId,
    Name,
    RewardList
}) ->
    Bin_Name = pt:write_string(Name), 

    Bin_RewardList = pt:write_object_list(RewardList), 

    Data = <<
        RoleId:64,
        Bin_Name/binary,
        Bin_RewardList/binary
    >>,
    Data.
item_to_bin_73 ({
    RoleId,
    Name,
    RewardList
}) ->
    Bin_Name = pt:write_string(Name), 

    Bin_RewardList = pt:write_object_list(RewardList), 

    Data = <<
        RoleId:64,
        Bin_Name/binary,
        Bin_RewardList/binary
    >>,
    Data.
item_to_bin_74 ({
    RoleId,
    RoleName,
    GoodsId,
    Num,
    Time
}) ->
    Bin_RoleName = pt:write_string(RoleName), 

    Data = <<
        RoleId:64,
        Bin_RoleName/binary,
        GoodsId:32,
        Num:32,
        Time:32
    >>,
    Data.
item_to_bin_75 ({
    RoleId,
    RoleName,
    GoodsId,
    Num,
    Time
}) ->
    Bin_RoleName = pt:write_string(RoleName), 

    Data = <<
        RoleId:64,
        Bin_RoleName/binary,
        GoodsId:32,
        Num:32,
        Time:32
    >>,
    Data.
