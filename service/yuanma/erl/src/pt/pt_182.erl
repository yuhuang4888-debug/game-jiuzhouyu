-module(pt_182).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(18201, _) ->
    {ok, []};
read(18202, Bin0) ->
    <<RoleId:64, _Bin1/binary>> = Bin0, 
    {ok, [RoleId]};
read(18203, _) ->
    {ok, []};
read(18204, _) ->
    {ok, []};
read(18205, _) ->
    {ok, []};
read(18206, _) ->
    {ok, []};
read(18207, _) ->
    {ok, []};
read(18208, _) ->
    {ok, []};
read(18209, _) ->
    {ok, []};
read(18210, _) ->
    {ok, []};
read(18211, _) ->
    {ok, []};
read(18213, Bin0) ->
    <<BabyId:32, _Bin1/binary>> = Bin0, 
    {ok, [BabyId]};
read(18214, Bin0) ->
    <<Type:8, Bin1/binary>> = Bin0, 
    <<BabyId:32, _Bin2/binary>> = Bin1, 
    {ok, [Type, BabyId]};
read(18215, Bin0) ->
    {BabyName, _Bin1} = pt:read_string(Bin0), 
    {ok, [BabyName]};
read(18216, _) ->
    {ok, []};
read(18217, Bin0) ->
    <<RoleId:64, Bin1/binary>> = Bin0, 
    <<Opr:8, _Bin2/binary>> = Bin1, 
    {ok, [RoleId, Opr]};
read(18218, Bin0) ->
    <<PosId:8, Bin1/binary>> = Bin0, 
    <<GoodsId:64, _Bin2/binary>> = Bin1, 
    {ok, [PosId, GoodsId]};
read(18219, Bin0) ->
    <<PosId:8, _Bin1/binary>> = Bin0, 
    {ok, [PosId]};
read(18220, Bin0) ->
    <<PosId:8, Bin1/binary>> = Bin0, 
    FunArray0 = fun(<<RestBin0/binary>>) -> 
        <<GoodsTypeId:32, _Args1/binary>> = RestBin0, 
        {GoodsTypeId,_Args1}
        end,
    {GoodsList, _Bin2} = pt:read_array(FunArray0, Bin1),

    {ok, [PosId, GoodsList]};
read(18222, Bin0) ->
    <<TaskId:16, _Bin1/binary>> = Bin0, 
    {ok, [TaskId]};
read(18223, Bin0) ->
    <<BabyId:32, _Bin1/binary>> = Bin0, 
    {ok, [BabyId]};
read(_Cmd, _R) -> {error, no_match}.

write (18200,[
    Cmd,
    ErrorCode,
    Args
]) ->
    Bin_Args = pt:write_string(Args), 

    Data = <<
        Cmd:16,
        ErrorCode:32,
        Bin_Args/binary
    >>,
    {ok, pt:pack(18200, Data)};

write (18201,[
    ActiveTime,
    BabyId,
    BabyName,
    IsChangeName
]) ->
    Bin_BabyName = pt:write_string(BabyName), 

    Data = <<
        ActiveTime:32,
        BabyId:32,
        Bin_BabyName/binary,
        IsChangeName:8
    >>,
    {ok, pt:pack(18201, Data)};

write (18202,[
    InfoList
]) ->
    BinList_InfoList = [
        item_to_bin_0(InfoList_Item) || InfoList_Item <- InfoList
    ], 

    InfoList_Len = length(InfoList), 
    Bin_InfoList = list_to_binary(BinList_InfoList),

    Data = <<
        InfoList_Len:16, Bin_InfoList/binary
    >>,
    {ok, pt:pack(18202, Data)};

write (18203,[
    RaiseLv,
    RaiseExp,
    TaskList,
    Power
]) ->
    BinList_TaskList = [
        item_to_bin_3(TaskList_Item) || TaskList_Item <- TaskList
    ], 

    TaskList_Len = length(TaskList), 
    Bin_TaskList = list_to_binary(BinList_TaskList),

    Data = <<
        RaiseLv:16,
        RaiseExp:32,
        TaskList_Len:16, Bin_TaskList/binary,
        Power:32
    >>,
    {ok, pt:pack(18203, Data)};

write (18204,[
    Stage,
    StageLv,
    StageExp,
    Power
]) ->
    Data = <<
        Stage:16,
        StageLv:8,
        StageExp:32,
        Power:32
    >>,
    {ok, pt:pack(18204, Data)};

write (18205,[
    EquipList,
    Power
]) ->
    BinList_EquipList = [
        item_to_bin_4(EquipList_Item) || EquipList_Item <- EquipList
    ], 

    EquipList_Len = length(EquipList), 
    Bin_EquipList = list_to_binary(BinList_EquipList),

    Data = <<
        EquipList_Len:16, Bin_EquipList/binary,
        Power:32
    >>,
    {ok, pt:pack(18205, Data)};

write (18206,[
    ActiveList
]) ->
    BinList_ActiveList = [
        item_to_bin_5(ActiveList_Item) || ActiveList_Item <- ActiveList
    ], 

    ActiveList_Len = length(ActiveList), 
    Bin_ActiveList = list_to_binary(BinList_ActiveList),

    Data = <<
        ActiveList_Len:16, Bin_ActiveList/binary
    >>,
    {ok, pt:pack(18206, Data)};

write (18207,[
    InfoList
]) ->
    BinList_InfoList = [
        item_to_bin_6(InfoList_Item) || InfoList_Item <- InfoList
    ], 

    InfoList_Len = length(InfoList), 
    Bin_InfoList = list_to_binary(BinList_InfoList),

    Data = <<
        InfoList_Len:16, Bin_InfoList/binary
    >>,
    {ok, pt:pack(18207, Data)};

write (18208,[
    RoleId,
    PraiseList
]) ->
    BinList_PraiseList = [
        item_to_bin_9(PraiseList_Item) || PraiseList_Item <- PraiseList
    ], 

    PraiseList_Len = length(PraiseList), 
    Bin_PraiseList = list_to_binary(BinList_PraiseList),

    Data = <<
        RoleId:64,
        PraiseList_Len:16, Bin_PraiseList/binary
    >>,
    {ok, pt:pack(18208, Data)};

write (18209,[
    PraiseRecord
]) ->
    BinList_PraiseRecord = [
        item_to_bin_10(PraiseRecord_Item) || PraiseRecord_Item <- PraiseRecord
    ], 

    PraiseRecord_Len = length(PraiseRecord), 
    Bin_PraiseRecord = list_to_binary(BinList_PraiseRecord),

    Data = <<
        PraiseRecord_Len:16, Bin_PraiseRecord/binary
    >>,
    {ok, pt:pack(18209, Data)};

write (18210,[
    Code
]) ->
    Data = <<
        Code:32
    >>,
    {ok, pt:pack(18210, Data)};

write (18211,[
    Code,
    Stage,
    StageLv,
    StageExp,
    Power
]) ->
    Data = <<
        Code:32,
        Stage:16,
        StageLv:8,
        StageExp:32,
        Power:32
    >>,
    {ok, pt:pack(18211, Data)};

write (18213,[
    Code,
    BabyId,
    BabyStar,
    Power,
    NextPower
]) ->
    Data = <<
        Code:32,
        BabyId:32,
        BabyStar:16,
        Power:64,
        NextPower:64
    >>,
    {ok, pt:pack(18213, Data)};

write (18214,[
    Code,
    Type,
    BabyId
]) ->
    Data = <<
        Code:32,
        Type:8,
        BabyId:32
    >>,
    {ok, pt:pack(18214, Data)};

write (18215,[
    Code,
    BabyName
]) ->
    Bin_BabyName = pt:write_string(BabyName), 

    Data = <<
        Code:32,
        Bin_BabyName/binary
    >>,
    {ok, pt:pack(18215, Data)};

write (18216,[
]) ->
    Data = <<
    >>,
    {ok, pt:pack(18216, Data)};

write (18217,[
    Code,
    RoleId,
    Opr,
    Rewards
]) ->
    Bin_Rewards = pt:write_object_list(Rewards), 

    Data = <<
        Code:32,
        RoleId:64,
        Opr:8,
        Bin_Rewards/binary
    >>,
    {ok, pt:pack(18217, Data)};

write (18218,[
    Code,
    PosId,
    GoodsId,
    GoodsTypeId,
    SkillId,
    Power
]) ->
    Data = <<
        Code:32,
        PosId:8,
        GoodsId:64,
        GoodsTypeId:32,
        SkillId:32,
        Power:32
    >>,
    {ok, pt:pack(18218, Data)};

write (18219,[
    Code,
    PosId,
    GoodsId,
    GoodsTypeId,
    Stage,
    StageLv,
    StageExp,
    Power
]) ->
    Data = <<
        Code:32,
        PosId:8,
        GoodsId:64,
        GoodsTypeId:32,
        Stage:16,
        StageLv:16,
        StageExp:32,
        Power:32
    >>,
    {ok, pt:pack(18219, Data)};

write (18220,[
    Code,
    PosId,
    GoodsId,
    GoodsTypeId,
    SkillId,
    Power
]) ->
    Data = <<
        Code:32,
        PosId:8,
        GoodsId:64,
        GoodsTypeId:32,
        SkillId:32,
        Power:32
    >>,
    {ok, pt:pack(18220, Data)};

write (18221,[
    TaskId,
    FinishNum,
    FinishState
]) ->
    Data = <<
        TaskId:16,
        FinishNum:16,
        FinishState:8
    >>,
    {ok, pt:pack(18221, Data)};

write (18222,[
    Code,
    TaskId,
    FinishNum,
    FinishState
]) ->
    Data = <<
        Code:32,
        TaskId:16,
        FinishNum:16,
        FinishState:8
    >>,
    {ok, pt:pack(18222, Data)};

write (18223,[
    BabyId,
    BabyStar,
    Power,
    NextPower
]) ->
    Data = <<
        BabyId:32,
        BabyStar:16,
        Power:64,
        NextPower:64
    >>,
    {ok, pt:pack(18223, Data)};

write (18224,[
    PraiserId
]) ->
    Data = <<
        PraiserId:64
    >>,
    {ok, pt:pack(18224, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 ({
    RoleId,
    RoleName,
    ActiveTime,
    BabyId,
    BabyName,
    RaiseLv,
    Stage,
    StageLv,
    BabyPower,
    EquipList,
    ActiveList
}) ->
    Bin_RoleName = pt:write_string(RoleName), 

    Bin_BabyName = pt:write_string(BabyName), 

    BinList_EquipList = [
        item_to_bin_1(EquipList_Item) || EquipList_Item <- EquipList
    ], 

    EquipList_Len = length(EquipList), 
    Bin_EquipList = list_to_binary(BinList_EquipList),

    BinList_ActiveList = [
        item_to_bin_2(ActiveList_Item) || ActiveList_Item <- ActiveList
    ], 

    ActiveList_Len = length(ActiveList), 
    Bin_ActiveList = list_to_binary(BinList_ActiveList),

    Data = <<
        RoleId:64,
        Bin_RoleName/binary,
        ActiveTime:32,
        BabyId:32,
        Bin_BabyName/binary,
        RaiseLv:16,
        Stage:16,
        StageLv:8,
        BabyPower:32,
        EquipList_Len:16, Bin_EquipList/binary,
        ActiveList_Len:16, Bin_ActiveList/binary
    >>,
    Data.
item_to_bin_1 ({
    PosId,
    GoodsTypeId,
    Estage,
    EstageLv,
    SkillId
}) ->
    Data = <<
        PosId:8,
        GoodsTypeId:32,
        Estage:16,
        EstageLv:16,
        SkillId:32
    >>,
    Data.
item_to_bin_2 ({
    BabyIdA,
    BabyStar
}) ->
    Data = <<
        BabyIdA:32,
        BabyStar:16
    >>,
    Data.
item_to_bin_3 ({
    TaskId,
    FinishNum,
    FinishState
}) ->
    Data = <<
        TaskId:16,
        FinishNum:16,
        FinishState:8
    >>,
    Data.
item_to_bin_4 ({
    PosId,
    Id,
    GoodsTypeId,
    Estage,
    EstageLv,
    EstageExp,
    SkillId
}) ->
    Data = <<
        PosId:8,
        Id:64,
        GoodsTypeId:32,
        Estage:16,
        EstageLv:16,
        EstageExp:32,
        SkillId:32
    >>,
    Data.
item_to_bin_5 ({
    BabyIdA,
    BabyStar
}) ->
    Data = <<
        BabyIdA:32,
        BabyStar:16
    >>,
    Data.
item_to_bin_6 ({
    RoleId,
    ActiveTime,
    BabyId,
    BabyName,
    RaiseLv,
    Stage,
    StageLv,
    BabyPower,
    AttrInfo
}) ->
    Bin_BabyName = pt:write_string(BabyName), 

    BinList_AttrInfo = [
        item_to_bin_7(AttrInfo_Item) || AttrInfo_Item <- AttrInfo
    ], 

    AttrInfo_Len = length(AttrInfo), 
    Bin_AttrInfo = list_to_binary(BinList_AttrInfo),

    Data = <<
        RoleId:64,
        ActiveTime:32,
        BabyId:32,
        Bin_BabyName/binary,
        RaiseLv:16,
        Stage:16,
        StageLv:8,
        BabyPower:32,
        AttrInfo_Len:16, Bin_AttrInfo/binary
    >>,
    Data.
item_to_bin_7 ({
    Type,
    AttrList
}) ->
    BinList_AttrList = [
        item_to_bin_8(AttrList_Item) || AttrList_Item <- AttrList
    ], 

    AttrList_Len = length(AttrList), 
    Bin_AttrList = list_to_binary(BinList_AttrList),

    Data = <<
        Type:8,
        AttrList_Len:16, Bin_AttrList/binary
    >>,
    Data.
item_to_bin_8 ({
    AttrId,
    Values
}) ->
    Data = <<
        AttrId:16,
        Values:32
    >>,
    Data.
item_to_bin_9 ({
    RoleIdA,
    RoleName,
    BabyPower,
    PraiseNum
}) ->
    Bin_RoleName = pt:write_string(RoleName), 

    Data = <<
        RoleIdA:64,
        Bin_RoleName/binary,
        BabyPower:32,
        PraiseNum:32
    >>,
    Data.
item_to_bin_10 ({
    PraiserId,
    PraiserName,
    IsPraiseBack
}) ->
    Bin_PraiserName = pt:write_string(PraiserName), 

    Data = <<
        PraiserId:64,
        Bin_PraiserName/binary,
        IsPraiseBack:8
    >>,
    Data.
