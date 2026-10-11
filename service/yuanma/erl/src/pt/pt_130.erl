%%%-----------------------------------
%%% @Module  : pt_130
%%% @Author  : xyao
%%% @Email   : jiexiaowen@gmail.com
%%% @Created : 2011.07.15
%%% @Description: 玩家信息
%%%-----------------------------------
-module(pt_130).
-export([read/2, write/2]).
-include("buff.hrl").
-include("common.hrl").

%%
%% 客户端 -> 服务端 ----------------------------
%%

%%走路
read(13001, <<>>) ->
    {ok, ok};

%% 指定ID玩家信息
read(13004, <<PlayerId:64>>) ->
    {ok, PlayerId};

%% 请求玩家铜币和元宝信息
read(13006, _) ->
    {ok, []};

%%获取快捷栏
read(13007, _) ->
    {ok, get};

%%保存快捷栏
read(13008, <<T:8, S:8, Id:32, AutoTag:8>>) ->

    {ok, [T, S, Id, AutoTag]};

%%删除快捷栏
read(13009, <<T:8>>) ->
    {ok, T};

%%替换快捷栏
read(13010, <<T1:8, T2:8>>) ->
    {ok, [T1, T2]};

%% 世界等级经验加成
read(13011, _) ->
    {ok, []};

%% 切换pk状态
read(13012, <<Type:8>>) ->
    {ok, [Type]};

%% 请求玩家figure
read(13013, <<ServerId:16, RoleId:64, ModId:16>>) ->
    {ok, [ServerId, RoleId, ModId]};

%% 请求公会会长figure
read(13014, <<ServerId:16, GuildId:64, ModId:16>>) ->
    {ok, [ServerId, GuildId, ModId]};

read(13015, <<ServerId:16, RoleId:64, ModId:16>>) ->
    {ok, [ServerId, RoleId, ModId]};

read(13017, _) ->
    {ok, []};

% %% BUFF状态
% read(13014, _) ->
%     {ok, []};

%% 红名值
read(13034, _) ->
    {ok, []};

%% 消除红名值
read(13035, <<Num:16>>) ->
    {ok, [Num]};

%% 转职
read(13045, <<Career:8, Sex:8>>) ->
    {ok, [Career, Sex]};

%% 转职信息
read(13046, _) ->
    {ok, []};

%% 请求充值
read(13051, _) ->
    {ok, get_pay};

%% 查询/修改用户配置
read(13070, <<Type:8, L:16, Bin/binary>>) ->
    List = read_arrary(13070, L, Bin, []),
	{ok, [Type, List]};

%% 激活的头像列表
read(13080, _) ->
    {ok, []};

%% 激活头像
read(13081, <<Id:64>>) ->
    {ok, [Id]};

%% 校验是否能上传图片
read(13082, <<>>) ->
    {ok, []};

%% 上传头像
read(13083, <<Id:64>>) ->
    %% {Picture, _Rest} = pt:read_string(String),
    {ok, [Id]};

%% 设置GPS经纬度
read(13084, <<Longitude:32/signed, Latitude:32/signed>>) ->
    {ok, [Longitude, Latitude]};

%% 查看玩家指定数据#渠道需求
read(13086, <<>>) ->
    {ok, []};

%% 挂后台切回游戏
read(13087, <<Notify:8>>) ->
    {ok, [Notify]};

%% 角色终身次数信息
read(13088, <<ModuleId:16, SubModule:16, ListBin/binary>>) ->
    {TypeList, _} = pt:read_array(fun(<<Type:16, LeftBin0/binary>>) -> {Type, LeftBin0} end, ListBin),
    {ok, [ModuleId, SubModule, TypeList]};

%% 角色终身次数信息+1
read(13089, <<ModuleId:16, SubModule:16, Type:16>>) ->
    {ok, [ModuleId, SubModule, Type]};

read(_Cmd, _R) ->
    {error, no_match}.

%%
%% 服务端 -> 客户端 ----------------------------
%%

%% 返回各种状态码
write(13000, ErrCode) ->
   {ok, pt:pack(13000, <<ErrCode:8>>)};

%% 本玩家信息
write(13001, [Id, Platform, ServerNum, CServerMsg, ServerId, ServerName, Figure, BattleAttr, Scene, X, Y, DunId, Exp,
        ExpLim, Gold, BGold, Coin, GCoin, CombatPower, GuildId, GuildName, PkChangeTime, PkValue, TeamId, MateRoleId, Ip, Camp, RegTime]) ->
    PlatformBin = pt:write_string(Platform),
    ServerNameBin = pt:write_string(ServerName),
    CServerMsgBin = pt:write_string(CServerMsg),
    FigureBin = pt:write_figure(Figure),
    BattleAttrBin = pt:write_battle_attr(BattleAttr),
    GuildNameBin = pt:write_string(GuildName),
    IpBin = pt:write_string(Ip),
    Data = <<Id:64, PlatformBin/binary, ServerNum:16, CServerMsgBin/binary, ServerId:16, ServerNameBin/binary, FigureBin/binary, BattleAttrBin/binary, 
        Scene:32, X:16, Y:16, DunId:32,
        Exp:64, ExpLim:64, Gold:32, BGold:32, Coin:64, GCoin:32, CombatPower:64, GuildId:64, GuildNameBin/binary,
        PkChangeTime:16, PkValue:16, TeamId:64, MateRoleId:64, IpBin/binary, Camp:16, RegTime:32>>,
    {ok, pt:pack(13001, Data)};

%% 加经验
write(13002, [Exp]) ->
    {ok, pt:pack(13002, <<Exp:64>>)};

%% 升级
write(13003, [Lv, Exp, ExpLim]) ->
     {ok, pt:pack(13003, <<Lv:16, Exp:64, ExpLim:64>>)};

write(13004, []) -> %% 不在线
    write(13000, 1);

write(13004, [Id, Figure, BattleAttr, CombatPower]) ->  %% 在线
    FigureBin = pt:write_figure(Figure),
    BattleAttrBin = pt:write_battle_attr(BattleAttr),
    Bin = <<Id:64, FigureBin/binary, BattleAttrBin/binary, CombatPower:64>>,
    {ok, pt:pack(13004, Bin)};

%% 更新人物信息
write(13005, Type) ->
	{ok, pt:pack(13005, <<Type:8>>)};

%% 请求玩家铜币和元宝信息
write(13006, [Coin, Gold, BGold, GCoin]) ->
	{ok, pt:pack(13006, <<Coin:64, Gold:32, BGold:32, GCoin:32>>)};

%%获取快捷栏
write(13007, []) ->
    {ok, pt:pack(13007, <<0:16, <<>>/binary>>)};
write(13007, Quickbar) ->
    Rlen = length(Quickbar),
    F = fun({L, T, Id, AutoTag}) ->
        <<L:8, T:8, Id:32, AutoTag:8>>
    end,
    RB = list_to_binary([F(D) || D <- Quickbar]),
    {ok, pt:pack(13007, <<Rlen:16, RB/binary>>)};

%%保存快捷栏
write(13008, State) ->
    {ok, pt:pack(13008, <<State:8>>)};

%%删除快捷栏
write(13009, State) ->
    {ok, pt:pack(13009, <<State:8>>)};

%%替换快捷栏
write(13010, State) ->
    {ok, pt:pack(13010, <<State:8>>)};

%% 玩家世界等级经验加成
write(13011, [ExpAdd, ServerLv]) ->
    {ok, pt:pack(13011, <<ExpAdd:16/signed, ServerLv:16>>)};

%%切换PK状态
write(13012, [ErrorCode, PkType, LeftTime]) ->
    {ok, pt:pack(13012, <<ErrorCode:32, PkType:8, LeftTime:32>>)};

write(13013, [ServerId, ServerNum, Id, ModId, Power, Figure, ServerName]) ->
    FigureBin = pt:write_figure(Figure),
    ServerNameStr = pt:write_string(ServerName),
    {ok, pt:pack(13013, <<ServerId:16, ServerNum:16, Id:64, ModId:16, Power:64, FigureBin/binary, ServerNameStr/binary>>)};

write(13014, [ServerId, GuildId, ModId, RoleId, Figure]) ->
    FigureBin = pt:write_figure(Figure),
    {ok, pt:pack(13014, <<ServerId:16, GuildId:64, ModId:16, RoleId:64, FigureBin/binary>>)};

write(13015, [ServerId, ModId, RoleId, Figure]) ->
    FigureBin = pt:write_figure(Figure),
    {ok, pt:pack(13015, <<ServerId:16, ModId:16, RoleId:64, FigureBin/binary>>)};

write(13017, [Status]) ->
    {ok, pt:pack(13017, <<Status:8>>)};

% %% BUFF状态通知
% write(13014, [PlayerId, BuffList]) ->
%     NowTime = utime:unixtime(),
%     ListNum = length(BuffList),
%     F = fun(BuffInfo) ->
%         BuffId = BuffInfo#ets_buff.id,
%         GoodsTypeId = BuffInfo#ets_buff.goods_id,
%         EndTime = BuffInfo#ets_buff.end_time - NowTime,
%         <<BuffId:32, GoodsTypeId:32, EndTime:32>>
%     end,
%     ListBin = list_to_binary(lists:map(F, BuffList)),
%     {ok, pt:pack(13014, <<PlayerId:32, ListNum:16, ListBin/binary>>)};

%% 新技能获得
write(13020, [List]) ->
    ListLen = length(List),
    %% ListBin = list_to_binary([<<SkillId:32>> || {SkillId, _SkillLv} <- List]),
    ListBin = list_to_binary([<<SkillId:32>> || SkillId <- List]),
    {ok, pt:pack(13020, <<ListLen:16, ListBin/binary>>)};

%% 更新玩家战斗属性信息
write(13033, [CombatPower, BattleAttr]) ->
    BattleAttrBin = pt:write_battle_attr(BattleAttr),
    Data = <<CombatPower:64, BattleAttrBin/binary>>,
    {ok, pt:pack(13033, Data)};

%% 更新玩家pk信息
write(13034, [PkValue, PkValueChangeTime]) ->
    {ok, pt:pack(13034, <<PkValue:16, PkValueChangeTime:32>>)};

%% 更新玩家pk信息
write(13035, [Code, Num, PkValue]) ->
    {ok, pt:pack(13035, <<Code:32, Num:16, PkValue:16>>)};

%% 玩家加经验提示
write(13036, [ExpType, Exp, ExpAddRatio]) ->
    {ok, pt:pack(13036, <<ExpType:8, Exp:64, ExpAddRatio:16>>)};

%% 转生成功
write(13040, [Career, Sex, Turn, TurnStage]) ->
    {ok, pt:pack(13040, <<Career:8, Sex:8, Turn:8, TurnStage:8>>)};

%% 转生阶段变化
write(13041, [TurnStage]) ->
    {ok, pt:pack(13041, <<TurnStage:8>>)};

%% 转职
write(13045, [ErrorCode, ErrorCodeArgs, NewCareer, NewSex]) ->
    ErrorCodeArgsBin = pt:write_string(ErrorCodeArgs),
    {ok, pt:pack(13045, <<ErrorCode:32, ErrorCodeArgsBin/binary, NewCareer:8, NewSex:8>>)};

%% 转职信息
write(13046, [NextTransferTime]) ->
    {ok, pt:pack(13046, <<NextTransferTime:32>>)};

%% 修改/查询玩家配置
write(13070, [Res, List]) ->
    Len = length(List),
    Bin = list_to_binary([<<SubType:8, Value:8>> || {SubType, Value}<-List]),
	{ok, pt:pack(13070, <<Res:8, Len:16, Bin/binary>>)};

%% 激活头像列表
write(13080, [List]) ->
    Len = length(List),
    Bin = list_to_binary([<<Id:32>> || Id<-List]),
    {ok, pt:pack(13080, <<Len:16, Bin/binary>>)};

%% 激活头像
write(13081, [Res, Id]) ->
    {ok, pt:pack(13081, <<Res:32, Id:64>>)};

%% 校验是否能上传图片
write(13082, [Res]) ->
    {ok, pt:pack(13082, <<Res:32>>)};

%% 上传图像
write(13083, [Res, PictureVer, String]) ->
    Bin = pt:write_string(String),
    {ok, pt:pack(13083, <<Res:32, PictureVer:32, Bin/binary>>)};

%% 设置GPS经纬度
write(13084, Res) ->
    {ok, pt:pack(13084, <<Res:8>>)};

%% 上传图像
write(13085, [RoleId, String, PictureVer]) ->
    Bin = pt:write_string(String),
    {ok, pt:pack(13085, <<RoleId:64, Bin/binary, PictureVer:32>>)};

%% 查看玩家指定数据
write(13086, [List]) ->
    Len = length(List),
    Bin = list_to_binary([<<Type:8, Value:32>> || {Type, Value}<-List]),
    {ok, pt:pack(13086, <<Len:16, Bin/binary>>)};

write(13088, [ModuleId, SubModule, List]) ->
    ListBin = pt:write_array(fun({Type, Count}) -> <<Type:16, Count:16>> end, List),
    {ok, pt:pack(13088, <<ModuleId:16, SubModule:16, ListBin/binary>>)};

write(13089, [ModuleId, SubModule, Type, Count]) ->
    {ok, pt:pack(13089, <<ModuleId:16, SubModule:16, Type:16, Count:16>>)};

write(_Cmd, _R) ->
    ?DEBUG("error cmd ~w R:~p~n", [_Cmd, _R]),
    {ok, pt:pack(0, <<>>)}.

%% 读取数组
read_arrary(13070, 0, _, Arrary) -> Arrary;
read_arrary(13070, L, <<SubType:8, Value:8, Bin/binary>>, Arrary) ->
    read_arrary(13070, L-1, Bin, [{SubType, Value}|Arrary]).
