-module(pt_190).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(19001, _) ->
    {ok, []};
read(19002, Bin0) ->
    <<MailId:64, _Bin1/binary>> = Bin0, 
    {ok, [MailId]};
read(19003, Bin0) ->
    FunArray0 = fun(<<RestBin0/binary>>) -> 
        <<MailId:64, _Args1/binary>> = RestBin0, 
        {MailId,_Args1}
        end,
    {MailIds, _Bin1} = pt:read_array(FunArray0, Bin0),

    {ok, [MailIds]};
read(19005, Bin0) ->
    FunArray0 = fun(<<RestBin0/binary>>) -> 
        <<MailId:64, _Args1/binary>> = RestBin0, 
        {MailId,_Args1}
        end,
    {MailIds, _Bin1} = pt:read_array(FunArray0, Bin0),

    {ok, [MailIds]};
read(19006, Bin0) ->
    {Title, Bin1} = pt:read_string(Bin0), 
    {Content, _Bin2} = pt:read_string(Bin1), 
    {ok, [Title, Content]};
read(19007, Bin0) ->
    <<MailId:64, _Bin1/binary>> = Bin0, 
    {ok, [MailId]};
read(19008, _) ->
    {ok, []};
read(19009, _) ->
    {ok, []};
read(19010, Bin0) ->
    {Content, _Bin1} = pt:read_string(Bin0), 
    {ok, [Content]};
read(_Cmd, _R) -> {error, no_match}.

write (19000,[
    ErrorCode
]) ->
    Data = <<
        ErrorCode:32
    >>,
    {ok, pt:pack(19000, Data)};

write (19001,[
    MailList
]) ->
    BinList_MailList = [
        item_to_bin_0(MailList_Item) || MailList_Item <- MailList
    ], 

    MailList_Len = length(MailList), 
    Bin_MailList = list_to_binary(BinList_MailList),

    Data = <<
        MailList_Len:16, Bin_MailList/binary
    >>,
    {ok, pt:pack(19001, Data)};

write (19002,[
    MailId,
    Sender,
    Title,
    Content,
    Attachment,
    Time,
    IsReceive
]) ->
    Bin_Sender = pt:write_string(Sender), 

    Bin_Title = pt:write_string(Title), 

    Bin_Content = pt:write_string(Content), 

    BinList_Attachment = [
        item_to_bin_1(Attachment_Item) || Attachment_Item <- Attachment
    ], 

    Attachment_Len = length(Attachment), 
    Bin_Attachment = list_to_binary(BinList_Attachment),

    Data = <<
        MailId:64,
        Bin_Sender/binary,
        Bin_Title/binary,
        Bin_Content/binary,
        Attachment_Len:16, Bin_Attachment/binary,
        Time:32,
        IsReceive:8
    >>,
    {ok, pt:pack(19002, Data)};

write (19003,[
    ErrorCode,
    MailIds
]) ->
    BinList_MailIds = [
        item_to_bin_3(MailIds_Item) || MailIds_Item <- MailIds
    ], 

    MailIds_Len = length(MailIds), 
    Bin_MailIds = list_to_binary(BinList_MailIds),

    Data = <<
        ErrorCode:32,
        MailIds_Len:16, Bin_MailIds/binary
    >>,
    {ok, pt:pack(19003, Data)};

write (19004,[
    MailList
]) ->
    BinList_MailList = [
        item_to_bin_4(MailList_Item) || MailList_Item <- MailList
    ], 

    MailList_Len = length(MailList), 
    Bin_MailList = list_to_binary(BinList_MailList),

    Data = <<
        MailList_Len:16, Bin_MailList/binary
    >>,
    {ok, pt:pack(19004, Data)};

write (19005,[
    ErrorCode,
    MailIds,
    Reward
]) ->
    BinList_MailIds = [
        item_to_bin_5(MailIds_Item) || MailIds_Item <- MailIds
    ], 

    MailIds_Len = length(MailIds), 
    Bin_MailIds = list_to_binary(BinList_MailIds),

    Bin_Reward = pt:write_object_list(Reward), 

    Data = <<
        ErrorCode:32,
        MailIds_Len:16, Bin_MailIds/binary,
        Bin_Reward/binary
    >>,
    {ok, pt:pack(19005, Data)};

write (19006,[
    ErrorCode
]) ->
    Data = <<
        ErrorCode:32
    >>,
    {ok, pt:pack(19006, Data)};

write (19007,[
    MailId,
    Type,
    State,
    Title,
    IsAttach,
    Time,
    EffectEt
]) ->
    Bin_Title = pt:write_string(Title), 

    Data = <<
        MailId:64,
        Type:8,
        State:8,
        Bin_Title/binary,
        IsAttach:8,
        Time:32,
        EffectEt:32
    >>,
    {ok, pt:pack(19007, Data)};

write (19008,[
    IsUnreadMail
]) ->
    Data = <<
        IsUnreadMail:8
    >>,
    {ok, pt:pack(19008, Data)};

write (19009,[
    LeftNum
]) ->
    Data = <<
        LeftNum:8
    >>,
    {ok, pt:pack(19009, Data)};

write (19010,[
    ErrorCode
]) ->
    Data = <<
        ErrorCode:32
    >>,
    {ok, pt:pack(19010, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 ({
    MailId,
    Type,
    State,
    Title,
    IsAttach,
    Time,
    EffectEt
}) ->
    Bin_Title = pt:write_string(Title), 

    Data = <<
        MailId:64,
        Type:8,
        State:8,
        Bin_Title/binary,
        IsAttach:8,
        Time:32,
        EffectEt:32
    >>,
    Data.
item_to_bin_1 ({
    ObjectType,
    TypeId,
    Num,
    ExtraAttr
}) ->
    BinList_ExtraAttr = [
        item_to_bin_2(ExtraAttr_Item) || ExtraAttr_Item <- ExtraAttr
    ], 

    ExtraAttr_Len = length(ExtraAttr), 
    Bin_ExtraAttr = list_to_binary(BinList_ExtraAttr),

    Data = <<
        ObjectType:8,
        TypeId:32,
        Num:32,
        ExtraAttr_Len:16, Bin_ExtraAttr/binary
    >>,
    Data.
item_to_bin_2 ({
    Color,
    TypeId,
    AttrId,
    AttrVal,
    PlusInterval,
    PlusUnit
}) ->
    Data = <<
        Color:8,
        TypeId:8,
        AttrId:16,
        AttrVal:32,
        PlusInterval:8,
        PlusUnit:32
    >>,
    Data.
item_to_bin_3 (
    MailId
) ->
    Data = <<
        MailId:64
    >>,
    Data.
item_to_bin_4 ({
    MailId,
    Type,
    State,
    Title,
    IsAttach,
    Time,
    EffectEt
}) ->
    Bin_Title = pt:write_string(Title), 

    Data = <<
        MailId:64,
        Type:8,
        State:8,
        Bin_Title/binary,
        IsAttach:8,
        Time:32,
        EffectEt:32
    >>,
    Data.
item_to_bin_5 (
    MailId
) ->
    Data = <<
        MailId:64
    >>,
    Data.
