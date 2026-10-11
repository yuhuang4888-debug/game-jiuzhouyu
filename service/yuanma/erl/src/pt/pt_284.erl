-module(pt_284).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(28400, _) ->
    {ok, []};
read(28401, Bin0) ->
    <<Scene:32, _Bin1/binary>> = Bin0, 
    {ok, [Scene]};
read(28403, Bin0) ->
    <<Scene:32, Bin1/binary>> = Bin0, 
    <<Bossid:32, _Bin2/binary>> = Bin1, 
    {ok, [Scene, Bossid]};
read(28404, Bin0) ->
    <<Scene:32, _Bin1/binary>> = Bin0, 
    {ok, [Scene]};
read(28405, _) ->
    {ok, []};
read(28406, _) ->
    {ok, []};
read(28407, _) ->
    {ok, []};
read(28408, Bin0) ->
    <<Scene:32, _Bin1/binary>> = Bin0, 
    {ok, [Scene]};
read(28409, Bin0) ->
    <<Score:32, _Bin1/binary>> = Bin0, 
    {ok, [Score]};
read(28410, _) ->
    {ok, []};
read(28412, Bin0) ->
    <<Scene:32, Bin1/binary>> = Bin0, 
    <<Monid:32, _Bin2/binary>> = Bin1, 
    {ok, [Scene, Monid]};
read(28415, _) ->
    {ok, []};
read(28419, _) ->
    {ok, []};
read(28420, _) ->
    {ok, []};
read(28421, _) ->
    {ok, []};
read(28422, Bin0) ->
    <<SceneId:16, _Bin1/binary>> = Bin0, 
    {ok, [SceneId]};
read(_Cmd, _R) -> {error, no_match}.

write (28400,[
    SanType,
    ServerIds
]) ->
    BinList_ServerIds = [
        item_to_bin_0(ServerIds_Item) || ServerIds_Item <- ServerIds
    ], 

    ServerIds_Len = length(ServerIds), 
    Bin_ServerIds = list_to_binary(BinList_ServerIds),

    Data = <<
        SanType:8,
        ServerIds_Len:16, Bin_ServerIds/binary
    >>,
    {ok, pt:pack(28400, Data)};

write (28401,[
    Scene,
    ConType,
    BlServer,
    BeforeBlserver,
    Server,
    BlRewardRecieve,
    Person,
    BossInfo,
    RankList
]) ->
    BinList_Server = [
        item_to_bin_1(Server_Item) || Server_Item <- Server
    ], 

    Server_Len = length(Server), 
    Bin_Server = list_to_binary(BinList_Server),

    BinList_BossInfo = [
        item_to_bin_2(BossInfo_Item) || BossInfo_Item <- BossInfo
    ], 

    BossInfo_Len = length(BossInfo), 
    Bin_BossInfo = list_to_binary(BinList_BossInfo),

    BinList_RankList = [
        item_to_bin_3(RankList_Item) || RankList_Item <- RankList
    ], 

    RankList_Len = length(RankList), 
    Bin_RankList = list_to_binary(BinList_RankList),

    Data = <<
        Scene:32,
        ConType:8,
        BlServer:32,
        BeforeBlserver:32,
        Server_Len:16, Bin_Server/binary,
        BlRewardRecieve:8,
        Person:16,
        BossInfo_Len:16, Bin_BossInfo/binary,
        RankList_Len:16, Bin_RankList/binary
    >>,
    {ok, pt:pack(28401, Data)};

write (28403,[
    Bossid,
    RankList
]) ->
    BinList_RankList = [
        item_to_bin_4(RankList_Item) || RankList_Item <- RankList
    ], 

    RankList_Len = length(RankList), 
    Bin_RankList = list_to_binary(BinList_RankList),

    Data = <<
        Bossid:32,
        RankList_Len:16, Bin_RankList/binary
    >>,
    {ok, pt:pack(28403, Data)};

write (28404,[
    Code,
    IsTask
]) ->
    Data = <<
        Code:32,
        IsTask:8
    >>,
    {ok, pt:pack(28404, Data)};

write (28405,[
    Score,
    Cost,
    Anger,
    ScoreReward
]) ->
    BinList_ScoreReward = [
        item_to_bin_5(ScoreReward_Item) || ScoreReward_Item <- ScoreReward
    ], 

    ScoreReward_Len = length(ScoreReward), 
    Bin_ScoreReward = list_to_binary(BinList_ScoreReward),

    Data = <<
        Score:32,
        Cost:8,
        Anger:16,
        ScoreReward_Len:16, Bin_ScoreReward/binary
    >>,
    {ok, pt:pack(28405, Data)};

write (28406,[
    Code
]) ->
    Data = <<
        Code:32
    >>,
    {ok, pt:pack(28406, Data)};

write (28407,[
    Code
]) ->
    Data = <<
        Code:32
    >>,
    {ok, pt:pack(28407, Data)};

write (28408,[
    Scene,
    Code
]) ->
    Data = <<
        Scene:32,
        Code:32
    >>,
    {ok, pt:pack(28408, Data)};

write (28409,[
    Score,
    Code
]) ->
    Data = <<
        Score:32,
        Code:32
    >>,
    {ok, pt:pack(28409, Data)};

write (28410,[
    ActStart,
    ActEnd
]) ->
    Data = <<
        ActStart:32,
        ActEnd:32
    >>,
    {ok, pt:pack(28410, Data)};

write (28411,[
    Scene,
    ConType
]) ->
    Data = <<
        Scene:32,
        ConType:8
    >>,
    {ok, pt:pack(28411, Data)};

write (28412,[
    Scene,
    Monid,
    PkLog
]) ->
    BinList_PkLog = [
        item_to_bin_6(PkLog_Item) || PkLog_Item <- PkLog
    ], 

    PkLog_Len = length(PkLog), 
    Bin_PkLog = list_to_binary(BinList_PkLog),

    Data = <<
        Scene:32,
        Monid:32,
        PkLog_Len:16, Bin_PkLog/binary
    >>,
    {ok, pt:pack(28412, Data)};

write (28413,[
    Code
]) ->
    Data = <<
        Code:8
    >>,
    {ok, pt:pack(28413, Data)};

write (28414,[
    Code
]) ->
    Data = <<
        Code:32
    >>,
    {ok, pt:pack(28414, Data)};

write (28415,[
    DieTimes,
    Time,
    DebuffTime,
    SafeTime
]) ->
    Data = <<
        DieTimes:16,
        Time:32,
        DebuffTime:32,
        SafeTime:32
    >>,
    {ok, pt:pack(28415, Data)};

write (28416,[
    BossId,
    RebornTime
]) ->
    Data = <<
        BossId:32,
        RebornTime:32
    >>,
    {ok, pt:pack(28416, Data)};

write (28417,[
    OutTime
]) ->
    Data = <<
        OutTime:32
    >>,
    {ok, pt:pack(28417, Data)};

write (28418,[
    ProduceType,
    JoinNum,
    Goods
]) ->
    BinList_Goods = [
        item_to_bin_7(Goods_Item) || Goods_Item <- Goods
    ], 

    Goods_Len = length(Goods), 
    Bin_Goods = list_to_binary(BinList_Goods),

    Data = <<
        ProduceType:8,
        JoinNum:16,
        Goods_Len:16, Bin_Goods/binary
    >>,
    {ok, pt:pack(28418, Data)};

write (28419,[
    SelfRank,
    SelfValue,
    Info
]) ->
    BinList_Info = [
        item_to_bin_8(Info_Item) || Info_Item <- Info
    ], 

    Info_Len = length(Info), 
    Bin_Info = list_to_binary(BinList_Info),

    Data = <<
        SelfRank:16,
        SelfValue:16,
        Info_Len:16, Bin_Info/binary
    >>,
    {ok, pt:pack(28419, Data)};

write (28420,[
    EndTime
]) ->
    Data = <<
        EndTime:32
    >>,
    {ok, pt:pack(28420, Data)};

write (28421,[
    SceneId,
    Camp,
    RankList
]) ->
    BinList_RankList = [
        item_to_bin_9(RankList_Item) || RankList_Item <- RankList
    ], 

    RankList_Len = length(RankList), 
    Bin_RankList = list_to_binary(BinList_RankList),

    Data = <<
        SceneId:32,
        Camp:8,
        RankList_Len:16, Bin_RankList/binary
    >>,
    {ok, pt:pack(28421, Data)};

write (28422,[
    SceneId,
    Rank,
    Score,
    KillScore
]) ->
    Data = <<
        SceneId:16,
        Rank:8,
        Score:16,
        KillScore:16
    >>,
    {ok, pt:pack(28422, Data)};

write (28423,[
    SceneId
]) ->
    Data = <<
        SceneId:16
    >>,
    {ok, pt:pack(28423, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 ({
    ServerId,
    ServerNum,
    ServerName,
    OpenDay,
    Camp
}) ->
    Bin_ServerName = pt:write_string(ServerName), 

    Data = <<
        ServerId:32,
        ServerNum:16,
        Bin_ServerName/binary,
        OpenDay:16,
        Camp:8
    >>,
    Data.
item_to_bin_1 ({
    Camp,
    Score
}) ->
    Data = <<
        Camp:8,
        Score:16
    >>,
    Data.
item_to_bin_2 ({
    Bossid,
    MonType,
    BossLv,
    RebornTime
}) ->
    Data = <<
        Bossid:32,
        MonType:8,
        BossLv:16,
        RebornTime:32
    >>,
    Data.
item_to_bin_3 ({
    PlayerId,
    RoleName,
    ServerId,
    ServerNum,
    Score,
    KillNum,
    Rank
}) ->
    Bin_RoleName = pt:write_string(RoleName), 

    Data = <<
        PlayerId:64,
        Bin_RoleName/binary,
        ServerId:32,
        ServerNum:16,
        Score:32,
        KillNum:64,
        Rank:8
    >>,
    Data.
item_to_bin_4 ({
    ServerId,
    ServerNum,
    ServerName,
    RoleId,
    Name,
    Hurt
}) ->
    Bin_ServerName = pt:write_string(ServerName), 

    Bin_Name = pt:write_string(Name), 

    Data = <<
        ServerId:32,
        ServerNum:16,
        Bin_ServerName/binary,
        RoleId:32,
        Bin_Name/binary,
        Hurt:16
    >>,
    Data.
item_to_bin_5 ({
    ScoreCfg,
    State
}) ->
    Data = <<
        ScoreCfg:16,
        State:8
    >>,
    Data.
item_to_bin_6 ({
    ServerId,
    ServerNum,
    RoleId,
    RoleName,
    Time
}) ->
    Bin_RoleName = pt:write_string(RoleName), 

    Data = <<
        ServerId:32,
        ServerNum:32,
        RoleId:32,
        Bin_RoleName/binary,
        Time:32
    >>,
    Data.
item_to_bin_7 ({
    GoodsId,
    Num,
    GoldType,
    Worth
}) ->
    Data = <<
        GoodsId:32,
        Num:16,
        GoldType:8,
        Worth:16
    >>,
    Data.
item_to_bin_8 ({
    Rank,
    ServerNum,
    RoleId,
    RoleName,
    TotalPoint
}) ->
    Bin_RoleName = pt:write_string(RoleName), 

    Data = <<
        Rank:16,
        ServerNum:32,
        RoleId:32,
        Bin_RoleName/binary,
        TotalPoint:32
    >>,
    Data.
item_to_bin_9 ({
    PlayerId,
    RoleName,
    ServerId,
    ServerNum,
    Score,
    KillNum,
    Rank
}) ->
    Bin_RoleName = pt:write_string(RoleName), 

    Data = <<
        PlayerId:64,
        Bin_RoleName/binary,
        ServerId:32,
        ServerNum:16,
        Score:32,
        KillNum:64,
        Rank:8
    >>,
    Data.
