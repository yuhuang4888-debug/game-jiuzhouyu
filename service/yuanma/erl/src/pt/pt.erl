%%%-----------------------------------
%%% @Module  : pt
%%% @Author  : xyao
%%% @Email   : jiexiaowen@gmail.com
%%% @Created : 2011.06.30
%%% @Description: 协议公共函数
%%%-----------------------------------
-module(pt). 
-include("attr.hrl").
-include("figure.hrl").
-include("common.hrl").

-ifdef(DEV_SERVER).
-define(SEND_CLIENT, true).
-else.
-define(SEND_CLIENT, false).
-endif.

-export([
         read_string/1,
         read_string_binary/1,
         write_string/1,
         read_voice_bin/1,
         write_voice_bin/1,
         read_float/2,
         write_float/2,
         write_attr/1,
         write_attr_list/1,
         read_figure/1,
         write_figure/1,
         write_battle_attr/1,
         write_object_list/1,
         read_array/2,
         write_array/2,
         pack/2,
         pack/3,
         error_pack/2
        ]).


%%读取字符串
read_string(Bin) ->
    case Bin of
        <<Len:16, Bin1/binary>> ->
            case Bin1 of
                <<Str:Len/binary-unit:8, Rest/binary>> ->
                    {binary_to_list(Str), Rest};
                _R1 ->
                    {[],<<>>}
            end;
        _R1 ->
            {[],<<>>}
    end.

%% 读取字符串 返回的是binary()
read_string_binary(Bin) ->
    case Bin of
        <<Len:16, Bin1/binary>> ->
            case Bin1 of
                <<Str:Len/binary-unit:8, Rest/binary>> ->
                    {Str, Rest};
                _R1 ->
                    {<<>>,<<>>}
            end;
        _R1 ->
            {<<>>,<<>>}
    end.


%% 读取语音信息
read_voice_bin(Bin) -> 
    case Bin of
        <<Len:32, Bin1/binary>> ->
            case Bin1 of
                <<VoiceBin:Len/binary, Rest/binary>> ->
                    {VoiceBin, Rest};
                _R1 ->
                    {<<>>,<<>>}
            end;
        _R1 ->
            {<<>>,<<>>}
    end.

%% 读取浮点数,3位精度
read_float(Bin, Bit) -> 
    <<Float:Bit, Rest/binary>> = Bin,
    {Float/1000, Rest}.

%% 读取数组
read_array(Fun, Bin) ->
    <<Len:16, RestBin/binary>> = Bin,
    read_array(0, Len, Fun, RestBin, []).
read_array(Max, Max, _, RestBin, Result) -> 
    {lists:reverse(Result), RestBin};
read_array(Min, Max, Fun, Bin, Result) -> 
    {One, RestBin} = Fun(Bin),
    read_array(Min+1, Max, Fun, RestBin, [One|Result]).

%% 打包数组
write_array(Fun, List) when is_list(List) ->
    Len = length(List),
    <<Len:16, (list_to_binary([Fun(E)||E<-List]))/binary>>.

%% 打包字符串
write_string(S) when is_list(S)-> 
    SB = ulists:list_to_bin(S),
    L = byte_size(SB),
    <<L:16, SB/binary>>;

write_string(S) when is_binary(S)->
    L = byte_size(S),
    <<L:16, S/binary>>;

write_string(S) when is_integer(S)->
	SS = integer_to_list(S),
	SB = list_to_binary(SS),
    L = byte_size(SB),
    <<L:16, SB/binary>>;

write_string(_S) ->
	<<0:16, <<>>/binary>>.

%% 打包语音二进制
write_voice_bin(VoiceBin) when is_binary(VoiceBin) -> 
    Len = byte_size(VoiceBin),
    <<Len:32, VoiceBin/binary>>.

%% 打包小数
write_float(Float, Bit) when is_float(Float); is_integer(Float) -> 
    Int = round(Float * 1000),
    <<Int:Bit>>.

%% 打包属性
write_attr(Attr) ->
    write_attr_list(Attr).

%% 打包属性列表
write_attr_list(AttrList) when is_list(AttrList) -> 
    List = [<<AttributeId:16, Value:32>> || {AttributeId, Value} <- AttrList, Value > 0],
    Len = length(List),
    AttrList_b = list_to_binary(List),
    <<Len:16, AttrList_b/binary>>;
write_attr_list(AttrMap) when is_map(AttrMap) -> 
    Length = maps:size(AttrMap),
    AttrB = maps:fold(fun(Key,Value,Bin) -> <<Key:8, Value:32, Bin/binary>> end, <<>>, AttrMap),  %% 使用时注意Key长度要改为 16位，部分属性键值超过8位了
    <<Length:16, AttrB/binary>>;
write_attr_list(Attr) when is_record(Attr, attr) ->
    #attr{
        att = Att, 
        wreck  = Wreck,
        hit = Hit, 
        dodge = Dodge, 
        crit = Crit,
        def = Def,
        ten = Ten,
        hurt_add_ratio = HurtAddRatio,
        hurt_del_ratio = HurtDelRatio,
        hit_ratio = HitRatio,
        dodge_ratio = DodgeRatio,
        crit_ratio = CritRatio,
        uncrit_ratio = UnCritRatio,
        heart_ratio = HeartRatio,
        elem_att = ElemAtt,
        elem_def = ElemDef,
        skill_hurt_add_ratio = SkillHurtAddR,
        skill_hurt_del_ratio = SkillHurtDelR,
        crit_hurt_add_ratio = CritHurtAddR,
        crit_hurt_del_ratio = CritHurtDelR,
        parry_ratio = ParryRatio,
        overload_ratio = OverloadRatio,
        parry = Parry,
        neglect = Neglect,
        heart_hurt_add_ratio = HearHurtAddRatio,
        heart_hurt_del_ratio = HearHurtDelRatio,
        heart_down_ratio = HeartDownRatio,
        att_add_ratio = AttAddR, 
        hp_add_ratio = HpAddR, 
        wreck_add_ratio  = WreckAddR,
        def_add_ratio = DefAddR, 
        hit_add_ratio = HitAddR, 
        dodge_add_ratio = DodgeAddR,
        crit_add_ratio = CritAddR, 
        ten_add_ratio = TenAddR,
        draconic_sacred = DraconicSAttr
        , draconic_tspace = DraconicTAttr
        , draconic_array = DraconicAAttr
        , exc_ratio = ExcRatio
        , unexc_ratio = UnExcRatio
        , exc_hurt_add_ratio = ExcHurtAddRatio
        , exc_hurt_del_ratio = ExcHurtDelRatio
        , armor = Armor
        , undizzy_ratio = UnDizzyRatio
        , neglect_def_ratio = NeglectDefRatio
        , pvp_hurt_add = PvpHurtAdd
        , pvp_hurt_del = PvpHurtDel
        , pvp_hurt_add_ratio = PvpHurtAddRatio
        , pvp_hurt_del_ratio = PvpHurtDelRatio
        , abs_att = AbsAtt
        , abs_def = AbsDef
        } = Attr,
    <<Att:32, Wreck:32, Def:32, Hit:32, Dodge:32, Crit:32, Ten:32, HurtAddRatio:32,
        HurtDelRatio:32, HitRatio:32, DodgeRatio:32, CritRatio:32, UnCritRatio:32, ElemAtt:32, ElemDef:32,
        HeartRatio:32, SkillHurtAddR:32, SkillHurtDelR:32, CritHurtAddR:32,
        CritHurtDelR:32, ParryRatio:32, OverloadRatio:32, Parry:32, Neglect:32, HearHurtAddRatio:32, HearHurtDelRatio:32, HeartDownRatio:32,
        AttAddR:32, HpAddR:32, WreckAddR:32, DefAddR:32, HitAddR:32, DodgeAddR:32, CritAddR:32, TenAddR:32, 
        DraconicSAttr:32, DraconicTAttr:32, DraconicAAttr:32, ExcRatio:32, UnExcRatio:32, ExcHurtAddRatio:32, ExcHurtDelRatio:32,
        Armor:32, UnDizzyRatio:32, NeglectDefRatio:32, PvpHurtAdd:32, PvpHurtDel:32, PvpHurtAddRatio:32, PvpHurtDelRatio:32, AbsAtt:32, AbsDef:32>>.

%% 打包形象，记得把read_figure也一起改
write_figure(Figure) ->
    #figure{
        name=Name, 
        sex=Sex, 
        realm=Realm, 
        career=Career, 
        lv=Lv, 
        gm=Gm, 
        vip=Vip,
        vip_hide = VipHide,
        title = Title,
        robot_type = RoBotType,
        lv_model = LvModel,
        fashion_model = FashionModel,
        picture = Picture,
        picture_ver = PictureVer,
        guild_id = GuildId,
        guild_name = GuildName,
        position = Position,
        position_name = PositionName,
        designation = Dsgt,
        liveness = Liveness,
        turn = Turn,
        turn_stage = TurnStage,
        juewei_lv = JueWeiLv,
        marriage_type = MarriageType,
        lover_role_id = LoverRoleId,
        lover_name = LoverName,
        husong_angel_id = AngelId,
        home_id = {BlockId, HouseId},
        house_lv = HouseLv,
        mount_figure = MountFigure,
        mount_figure_ride = MountFigureRide,
        achiv_stage = AchivStage,
        medal_id = MedalId,
        magic_circle_figure = MagicCircleFigureId,
        dress_list = DressList,
        god_id = GodId,
        revelation_suit = RevelationSuit,
        demons_id = DemonsId,
        is_supvip = IsSupvip,
        back_decora_figure = BackDecoraFigure,
        back_decora_figure_ride = BackDecoraFigureRide,
        title_id = TitleId,
        mask_id = MaskId,
        camp = Camp,
        brick_color = BrickColor,
        suit_clt_figure = SuitCltFigure,
        is_collecting = IsCollecting
    } = Figure,
    NameBin = write_string(Name),
    Fun = fun({Part, ModelId}) -> <<Part:8, ModelId:32>> end,
    LvModelBin = write_array(Fun, LvModel),
    Fun1 = fun({Part, FashionId, ColorId}) -> <<Part:8, FashionId:32, ColorId:8>> end,
    FashionModelBin = write_array(Fun1, FashionModel),
    PictureBin = write_string(Picture),
    GuildNameBin = write_string(GuildName),
    PositionNameBin = write_string(PositionName),
    LoverNameBin = write_string(LoverName),
    MountFigureBin = write_array(
        fun({FigureTypeId, FigureId, ColorId}) -> 
                <<FigureTypeId:8, FigureId:32, ColorId:32>>;
           ({FigureTypeId, FigureId}) ->
                ColorId = 0,
                <<FigureTypeId:8, FigureId:32, ColorId:32>>
        end,
        BackDecoraFigure ++ MountFigure
    ),
    MountFigureRideBin = write_array(fun({FigureTypeId, IsRide}) -> <<FigureTypeId:8, IsRide:8>> end, BackDecoraFigureRide ++ MountFigureRide),
    Fun2 = fun({DressType, DressId}) -> <<DressType:8, DressId:32>> end,
    DressUpBin = write_array(Fun2, DressList),
    <<NameBin/binary, Sex:8, Realm:8, Career:8, Lv:16, Gm:8, Vip:8, VipHide:8, Title:8,
    LvModelBin/binary, FashionModelBin/binary, PictureBin/binary, PictureVer:32,
    GuildId:64, GuildNameBin/binary, Position:8, PositionNameBin/binary, Dsgt:32,
    Liveness:32, Turn:8, TurnStage:8, JueWeiLv:8, MarriageType:8, LoverRoleId:64, LoverNameBin/binary,
    AngelId:32, BlockId:32, HouseId:32, HouseLv:16, MountFigureBin/binary, MountFigureRideBin/binary, AchivStage:16, MedalId:16, MagicCircleFigureId:32, DressUpBin/binary,
    GodId:32, RevelationSuit:32, DemonsId:32, IsSupvip:8, TitleId:32, MaskId:8, Camp:8, BrickColor:8, RoBotType:8, SuitCltFigure:8, IsCollecting:8>>.

%% 解包figure
read_figure(Bin) ->
    FunArrayLvModel = fun(<<RestBin0/binary>>) -> 
        <<Part:8, ModelId:32, _Args1/binary>> = RestBin0, 
        {{Part, ModelId},_Args1}
        end,
    FunArrayFasionModel = fun(<<RestBin0/binary>>) -> 
        <<Part:8, FashionId:32, ColorId:8, _Args1/binary>> = RestBin0, 
        {{Part, FashionId, ColorId},_Args1}
        end,
    FunArrayMountFigure = fun(<<RestBin0/binary>>) -> 
        <<FigureTypeId:8, FigureId:32, ColorId:32, _Args1/binary>> = RestBin0, 
        {{FigureTypeId, FigureId, ColorId},_Args1}
        end,
    FunArrayMountFigureRide = fun(<<RestBin0/binary>>) -> 
        <<FigureTypeId:8, IsRide:8, _Args1/binary>> = RestBin0, 
        {{FigureTypeId, IsRide},_Args1}
        end,
    FunArrayDressUp = fun(<<RestBin0/binary>>) -> 
        <<DressType:8, DressId:32, _Args1/binary>> = RestBin0, 
        {{DressType, DressId},_Args1}
        end,

    {Name, Bin1} = pt:read_string(Bin),
    <<Sex:8, Realm:8, Career:8, Lv:16, Gm:8, Vip:8, VipHide:8, Title:8, Bin2/binary>> = Bin1,
    {LvModel, Bin3} = pt:read_array(FunArrayLvModel, Bin2),
    {FashionModel, Bin4} = pt:read_array(FunArrayFasionModel, Bin3),
    {Picture, Bin5} = pt:read_string(Bin4),
    <<PictureVer:32, GuildId:64, Bin6/binary>> = Bin5,
    {GuildName, Bin7} = pt:read_string(Bin6),
    <<Position:8, Bin8/binary>> = Bin7,
    {PositionName, Bin9} = pt:read_string(Bin8),
    <<Dsgt:32, Liveness:32, Turn:8, TurnStage:8, JueWeiLv:8, MarriageType:8, LoverRoleId:64, Bin10/binary>> = Bin9,
    {LoverName, Bin11} = pt:read_string(Bin10),
    <<AngelId:32, BlockId:32, HouseId:32, HouseLv:16, Bin12/binary>> = Bin11,
    {MountFigure, Bin13} = pt:read_array(FunArrayMountFigure, Bin12),
    {MountFigureRide, Bin14} = pt:read_array(FunArrayMountFigureRide, Bin13),
    <<AchivStage:16, MedalId:16, MagicCircleFigureId:32, Bin15/binary>> = Bin14,
    {DressList, Bin16} = pt:read_array(FunArrayDressUp, Bin15),
    <<GodId:32, RevelationSuit:32, DemonsId:32, IsSupvip:8, TitleId:32, MaskId:8, Camp:8, BrickColor:8, RoBotType:8, SuitCltFigure:8, IsCollecting:8, Left/binary>> = Bin16,
    Figure = #figure{
        name=Name, sex=Sex, realm=Realm, career=Career, lv=Lv, gm=Gm,
        vip=Vip, vip_hide = VipHide, title = Title, robot_type = RoBotType, lv_model = LvModel,
        fashion_model = FashionModel, picture = Picture, picture_ver = PictureVer,
        guild_id = GuildId, guild_name = GuildName, position = Position, position_name = PositionName,
        designation = Dsgt, liveness = Liveness, turn = Turn, turn_stage = TurnStage,
        juewei_lv = JueWeiLv, marriage_type = MarriageType, lover_role_id = LoverRoleId,
        lover_name = LoverName, husong_angel_id = AngelId, home_id = {BlockId, HouseId},
        house_lv = HouseLv, mount_figure = MountFigure, mount_figure_ride = MountFigureRide,
        achiv_stage = AchivStage, medal_id = MedalId, magic_circle_figure = MagicCircleFigureId,
        dress_list = DressList, god_id = GodId, revelation_suit = RevelationSuit,
        demons_id = DemonsId, is_supvip = IsSupvip, back_decora_figure = [],
        back_decora_figure_ride = [], title_id = TitleId, mask_id = MaskId,
        camp = Camp, brick_color = BrickColor, suit_clt_figure = SuitCltFigure,
        is_collecting = IsCollecting
    },
    {Figure, Left}.

%% 打包战斗属性
write_battle_attr(#battle_attr{hp=Hp, hp_lim=HpLim, speed=Speed, attr=Attr}) -> 
    AttrBin = write_attr_list(Attr),
    <<Hp:64, HpLim:64, Speed:16, AttrBin/binary>>.

%% 打包(奖励/消耗)列表
write_object_list(ObjectList) when is_list(ObjectList) -> 
    List    = [<<Type:8, ObjectTypeId:32, Num:32>> || {Type, ObjectTypeId, Num} <- ObjectList],
    Len     = length(List),
    ObjectList_b = list_to_binary(List),
    <<Len:16, ObjectList_b/binary>>.

%% 打包信息，添加消息头
%% Zip:1压缩0不压缩 默认不压缩, 当数据大于31个字节的时候，默认压缩
pack(Cmd, Data) ->
    pack(Cmd, Data, 0).
pack(Cmd, Data, _Zip) ->
    % L = byte_size(Data) + 4,
    % <<L:16, Cmd:16, Data/binary>>.
    L = byte_size(Data) + 7,
    <<L:32, Cmd:16, 0:8, Data/binary>>.
    %% case _Zip == 1 of %orelse byte_size(Data) > 31 of
    %%     true ->
    %%         Data1 = zlib:compress(Data),
    %%         L = byte_size(Data1) + 7,
    %%         <<L:32, Cmd:16, 1:8, Data1/binary>>;
    %%     false ->
    %%         L = byte_size(Data) + 7,
    %%         <<L:32, Cmd:16, 0:8, Data/binary>>
    %% end.

%% 打包错误，发送给客户端信息
error_pack(Cmd, Data) when is_integer(Cmd) -> 
    case ?SEND_CLIENT of
        true -> pack(59001, <<Cmd:16>>);
        _ -> ?DEBUG("error pt write cmd=~w, date=~p~n", [Cmd, Data]),  pack(0, <<>>) %% 非debug模式不发送客户端，保密
    end.
