%%%-----------------------------------
%%% @Module  : pt_200
%%% @Author  : xyao
%%% @Email   : jiexiaowen@gmail.com
%%% @Created : 2011.07.25
%%% @Description: 20战斗信息
%%%-----------------------------------
-module(pt_200).
-export([read/2, write/2]).
-include("common.hrl").

%%
%%客户端 -> 服务端 ----------------------------
%%


%% 玩家发起战斗
read(20001, Bin) ->
    FMonList = fun(<<Id:32, RestBin/binary>>) -> {Id, RestBin} end,
    {MonList, ResBin} = pt:read_array(FMonList, Bin),

    FPlayerList = fun(<<Id:64, RestBin/binary>>) -> {Id, RestBin} end,
    {PlayerIdList, ResBin2} = pt:read_array(FPlayerList, ResBin),
    
    <<SkillId:32, AttX:16, AttY:16, AttAngle:16, _/binary>> = ResBin2,
    {ok, [MonList, PlayerIdList, SkillId, AttX, AttY, AttAngle]};

%%复活:1正常复活，2原地复活
read(20004, <<Type:8>>) ->
    {ok, Type};

%%使用辅助技能
read(20006, <<Id:64, SkillId:32>>) ->
    {ok, [Id, SkillId]};

%%采集怪物
read(20008, <<MonId:32, Mid:32, Type:8>>) ->
    {ok, [MonId, Mid, Type]};

%%复活时间戳
read(20009, _) ->
    {ok, []};

%%拾取怪物
read(20010, Data) ->
    {MonList, _Rest} = pt:read_array(fun(<<Id:32, Rest/binary>>) -> {Id, Rest} end, Data),
    {ok, MonList};

%% 与赏金型怪物对话
read(20011, <<MonId:32>>) ->
    {ok, MonId};

%% 客户端申请扣取血量
read(20012, <<HpDel:32>>) ->
    {ok, HpDel};

%% 客户端申请扣取血量
read(20013, _) ->
    {ok, []};

%% 玩家五分钟内回城复活的次数
read(20017, _) ->
    {ok, []};

%% 抢夺归属
read(20020, <<MonId:32>>) ->
    {ok, [MonId]};

%% 查看归属
read(20021, <<MonId:32>>) ->
    {ok, [MonId]};

%% 能量值
read(20023, <<>>) ->
    {ok, []};

read(20024, <<Type:8>>) ->
    {ok, [Type]};

read(20025, <<MonId:32, Mid:32>>) ->
    {ok, [MonId, Mid]};

read(_Cmd, _R) ->
    {error, no_match}.

%%
%%服务端 -> 客户端 ------------------------------------
%%

%%广播战斗结果
write(20001, [AtterType, Id, Hp, Anger, MoveType, SkillId, SkillLv, AerX, AerY, AttX, AttY, AttAngle, AttBuffList, TriggerSkillL, DefList]) ->
    Data1 = <<AtterType:8, Id:64, Hp:64, Anger:32, MoveType:8, SkillId:32, SkillLv:16,
    AerX:16, AerY:16, AttX:16, AttY:16, AttAngle:16>>,
    DefList_b     = def_list(DefList),
    F = fun(TriggerId)-> <<TriggerId:32>> end,
    TriggerSkillL_b = pt:write_array(F, TriggerSkillL),
    Data          = <<Data1/binary, AttBuffList/binary, TriggerSkillL_b/binary, DefList_b/binary>>,
    {ok, pt:pack(20001, Data)};

%%复活结果
write(20004, [Type, Res]) ->
    Data = <<Type:8, Res:8 >>,
    {ok, pt:pack(20004, Data)};

%% 攻击失败返回
write(20005, [ErrCode, Sign1, User1, Hp1, X1, Y1, Sign2, User2, Hp2, X2, Y2, InexistenceList]) ->
    Len = length(InexistenceList),
    InexistenceList_b = list_to_binary([<<E:32>>||E<-InexistenceList]),   
    {ok, pt:pack(20005, <<ErrCode:8, Sign1:8, User1:64, Hp1:64, X1:16, Y1:16, 
            Sign2:8, User2:64, Hp2:64, X2:16, Y2:16, Len:16, InexistenceList_b/binary>>)};

%% 广播战斗结果 - 辅助技能
write(20006, [Sign, Id, SkillId, SkillLv, _Act, AssList]) ->
    Data1 = <<Id:64, Sign:8, SkillId:32, SkillLv:8>>,
    Data2 = assist_list(AssList),
    Data = << Data1/binary, Data2/binary>>,
    {ok, pt:pack(20006, Data)};

%% 广播战斗结果 - buff技能清理
write(20007, [Sign, Id, Dels]) ->
    Len = length(Dels),
    DelsBin = list_to_binary([<<BuffId:16, SkillId:32>>||{BuffId, SkillId}<-Dels]),   
    {ok, pt:pack(20007, <<Sign:8, Id:64, Len:16, DelsBin/binary>>)};

%%采集怪物
write(20008, Res) ->
    {ok, pt:pack(20008, <<Res:8>>)};

% %%采集怪物
% write(20008, ErrCode) ->
%     {ok, pt:pack(20008, <<ErrCode:32>>)};

%%复活时间戳
write(20009, [IsRevive, ReviveTime]) ->
    {ok, pt:pack(20009, <<IsRevive:8, ReviveTime:32>>)};

%%拾取怪物
write(20010, ResList) -> 
    F = fun({Res, SrcId}) -> 
            <<Res:8, SrcId:32>>
    end,
    Data = pt:write_array(F, ResList),
    {ok, pt:pack(20010, Data)};

%%与赏金怪物对话
write(20011, [Res]) ->
    {ok, pt:pack(20011, <<Res:8>>)};

%% 被杀信息
write(20013, [AttSign, Name, PkValue, BGold, Lv, Turn, AttId]) ->
    NameB = pt:write_string(Name),
    {ok, pt:pack(20013, <<AttSign:8, NameB/binary, PkValue:16, BGold:8, Lv:16, Turn:8, AttId:64>>)};

%% 击杀信息
write(20014, [Name, IsShowPkV, PkValue]) ->
    NameB = pt:write_string(Name),
    {ok, pt:pack(20014, <<NameB/binary, IsShowPkV:8, PkValue:16>>)};

%% 广播pk值
write(20015, [RoleId, PkValue]) ->
    {ok, pt:pack(20015, <<RoleId:64, PkValue:16>>)};

%% 通知客户端最近五分钟内的回城复活次数
write(20017, [ReviveNum, EndTime]) ->
    {ok, pt:pack(20017, <<ReviveNum:16, EndTime:32>>)};

%% 通知客户端清理刚放技能cd
write(20018, [SkillId]) ->
    {ok, pt:pack(20018, <<SkillId:32>>)};

%% 通知客户端释放特殊的技能Id
write(20019, [SkillId]) ->
    {ok, pt:pack(20019, <<SkillId:32>>)};

write(20020, [ErrCode, MonId]) ->
    {ok, pt:pack(20020, <<ErrCode:32, MonId:32>>)};

%% 查看归属
write(20021, [MonId, FirstId]) ->
    {ok, pt:pack(20021, <<MonId:32, FirstId:64>>)};

%% 模拟战斗结果
write(20022, [KillerId, PlayerId, Hp, HpLim]) ->
    {ok, pt:pack(20022, <<KillerId:64, PlayerId:64, Hp:64, HpLim:64>>)};

%% 能量值
write(20023, [Energy]) ->
    {ok, pt:pack(20023, <<Energy:16>>)};

write(20024, [Type]) ->
    {ok, pt:pack(20024, <<Type:8>>)};

write(20025, [PlayerIdList]) ->
    BinList  = [<<PlayerId:64>> || PlayerId <- PlayerIdList],
    Bin_PlayerIdList = list_to_binary(BinList),
    PlayerLen = length(BinList),
    Data = <<PlayerLen:16, Bin_PlayerIdList/binary>>,
    {ok, pt:pack(20025, Data)};

%% 玩家采集被打断
write(20026, StopperId) ->
    {ok, pt:pack(20026, <<StopperId:64>>)};

write(20027, [SkillId, EndTime]) ->
    {ok, pt:pack(20027, <<SkillId:32, EndTime:64>>)};

write(20028, [SkillIdL]) ->
    F = fun(SkillId)-> <<SkillId:32>> end,
    SkillIdL_b = pt:write_array(F, SkillIdL),
    {ok, pt:pack(20028, <<SkillIdL_b/binary>>)};

write(_Cmd, _R) ->
    ?DEBUG("error cmd ~w R:~p~n", [_Cmd, _R]),
    {ok, pt:pack(0, <<>>)}.

def_list([]) -> <<0:16, <<>>/binary>>;
def_list(DefList) ->
    F = fun([Sign, Id, Hp, _Mp, Anger, Hurt, HurtType, SecHurtType, X, Y, Move, InteruptSkillId, DBuffList]) ->
        <<Sign:8, Id:64, Hp:64, Anger:32, Hurt:32, HurtType:8, SecHurtType:8, X:16, Y:16, Move:8, InteruptSkillId:32, DBuffList/binary>>
    end,
    L  = [F(D) || D <- DefList, D =/= []],
    RB = list_to_binary(L),
    RLen = length(L),
    <<RLen:16, RB/binary>>.

assist_list([]) -> <<0:16, <<>>/binary>>;
assist_list(List) ->
    Rlen = length(List),
    F = fun([Sign, Id, Hp, DBuffList]) ->
            <<Sign:8, Id:64, Hp:64, DBuffList/binary>>
    end,
    RB = list_to_binary([F(D) || D <- List]),
    <<Rlen:16, RB/binary>>.
