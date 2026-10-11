%%%-----------------------------------
%%% @Module  : pt_120
%%% @Author  : xyao
%%% @Email   : jiexiaowen@gmail.com
%%% @Created : 2011.06.23
%%% @Description: 12场景信息
%%%-----------------------------------
-module(pt_120).
-export([read/2, write/2, pack_elem_list/1, pack_npc_list/1]).
-include("server.hrl").
-include("scene.hrl").
-include("attr.hrl").
-include("figure.hrl").
-include("common.hrl").
-include("team.hrl").
-include("mount.hrl").
-include("battle.hrl").
-include("pet.hrl").
-include("kf_guild_war.hrl").
-include("def_fun.hrl").
-define (MAX_SENT_NUM, 40).
%%
%%客户端 -> 服务端 ----------------------------
%%

%%走路
read(12001, <<S:32, X:16, Y:16, Fly:8, BroadcastX:16, BroadcastY:16, FlyX:16, FlyY:16>>) ->
    {ok, [S, X, Y, Fly, BroadcastX, BroadcastY, FlyX, FlyY]};

%%加载场景
read(12002, _) ->
    {ok, []};

%%切换场景
read(12005, <<DunId:32, ChangeSceneId:32, CallBackValue:8, TransType:8, TX:16, TY:16>>) ->
    {ok, [DunId, ChangeSceneId, CallBackValue, TransType, TX, TY]};

%% 请求该场景npc状态
read(12018, _) ->
    {ok, []};

%% 请求该场景npc状态
read(12020, _) ->
    {ok, []};

read(12025, <<AutoId:32>>) ->
    {ok, [AutoId]};

%% 请求切换场景
read(12031, _) ->
    {ok, []};

%% 请求场景动态特效
read(12032, _) ->
    {ok, []};

%% 小飞鞋
read(12033, _) ->
    {ok, []};

%% 超链接场景传送
read(12034, <<SceneId:32, LineNo:16, X:16, Y:16>>) ->
    {ok, [SceneId, LineNo, X, Y]};

%% 跨服服战场景传送
read(12035, <<X:16, Y:16>>) ->
    {ok, [X, Y]};

%% 获取场景线路
read(12040, _) ->
    {ok, []};

%% 切换线路
read(12041, <<LineNo:16>>) ->
    {ok, LineNo};

%% 怪物的玩家求助列表
read(12043, <<AutoId:32>>) ->
    {ok, [AutoId]};

%% 玩家改变区域（客户端使用）
read(12085, <<Type:8>>) ->
    {ok, Type};

read(12087, <<SceneId:16>>) ->
    {ok, [SceneId]};

read(12088, <<>>) ->
    {ok, []};

read(12089, <<>>) ->
    {ok, []};

read(12092, Bin0) ->
    FunArray0 = fun(<<RestBin0/binary>>) ->
        <<GoodsId:64, _Args1/binary>> = RestBin0,
        {GoodsId,_Args1}
    end,
    {IdList, _Bin2} = pt:read_array(FunArray0, Bin0),
    {ok, [IdList]};

read(12093, <<>>) ->
    {ok, []};

read(_Cmd, _R) ->
    ?PRINT("120 error pt ~w~n", [{_Cmd, _R}]),
    {error, no_match}.

%%
%%服务端 -> 客户端 ------------------------------------
%%

%%走路
write(12001, [BX, BY, Id, F, FX, FY]) ->
    case F > 0 of
        true  -> {ok, pt:pack(12001, <<BX:16, BY:16, Id:64, F:8, FX:16, FY:16>>)};
        false -> {ok, pt:pack(12001, <<BX:16, BY:16, Id:64, F:8>>)}
    end;

%%加场景信息
write(12002, [User, Object, AreaMarkL]) ->
    Data1 = pack_scene_user_list(User),
    Data2 = pack_scene_object_list(Object),
    Data3 = pack_area_mark(AreaMarkL),
    Data = << Data1/binary, Data2/binary, Data3/binary>>,
    {ok, pt:pack(12002, Data, 1)};


%%进入新场景广播给本场景的人
write(12003, D) ->
    {ok, pt:pack(12003, binary_to_12003(D))};

%%离开场景
write(12004, Id) ->
    {ok, pt:pack(12004, <<Id:64>>)};

%%切换场景
write(12005, [Id, X, Y, ErrCode, DunId, Callback, TransType] = Args) ->
    Data = <<Id:32, X:16, Y:16, ErrCode:32, DunId:32, Callback:8, TransType:8>>,
    {ok, pt:pack(12005, Data)};

%% 怪物消失
write(12006, Id) ->
    {ok, pt:pack(12006, <<Id:32>>)};

%% 有怪物进入场景
write(12007, Info) ->
    {ok, pt:pack(12007, binary_12007(Info))};

%% 场景对象移动
write(12008, [X, Y, Id]) ->
    {ok, pt:pack(12008, <<X:16, Y:16, Id:32>>)};

%% 血量变化
write(12009, [PlayerId, Hp, HpLim]) ->
    {ok, pt:pack(12009, <<PlayerId:64, Hp:64, HpLim:64>>)};

%% 主角属性更新
write(12010, [Id, Attrs]) ->
    AttrsBin = pt:write_array(fun({Type, Value}) -> <<Type:8, Value:32>> end, Attrs),
    {ok, pt:pack(12010, <<Id:64, AttrsBin/binary>>)};

%% 9宫格加场景信息
write(12011, [User1, User2]) ->
    Data1 = pack_scene_user_list(User1),
    Data2 = pack_leave_list(User2),
    Data = << Data1/binary, Data2/binary>>,
    {ok, pt:pack(12011, Data)};

%% 九宫格加载怪物
write(12012, [ObjectAdd, ObjectDel]) ->
    Data1 = pack_scene_object_list(ObjectAdd),
    Data2 = pack_scene_object_leave_list(ObjectDel),
    {ok, pt:pack(12012, << Data1/binary, Data2/binary>>)};

%% 有伙伴进入场景
write(12013, Info) ->
    {ok, pt:pack(12013, binary_12013(Info))};

%% 场景一般对象
write(12014, Info) ->
    {ok, pt:pack(12014, binary_12014(Info))};

%% 场景假人
write(12015, Info) ->
    {ok, pt:pack(12015, binary_12015(Info))};

%%掉落包生成
write(12017, [MonId, Time, Scene, DropBin, X, Y, Boss]) ->
    ListNum = length(DropBin),
    ListBin = list_to_binary(DropBin),
    {ok, pt:pack(12017, <<MonId:32, Time:16, Scene:32, ListNum:16,
                          ListBin/binary, X:16, Y:16, Boss:8>>)};

%% 请求玩家可以拾取的掉落
write(12018, [DropBin]) ->
    ListNum = length(DropBin),
    ListBin = list_to_binary(DropBin),
    {ok, pt:pack(12018, <<ListNum:16, ListBin/binary >>)};

%% 掉落消失
write(12019, DropIdL) ->
    Len = length(DropIdL),
    Bin = list_to_binary([<<DropId:64>> || DropId <- DropIdL]),
    {ok, pt:pack(12019, <<Len:16, Bin/binary>>)};

%% 改变NPC状态图标
write(12020, []) ->
    {ok, pt:pack(12020, <<>>)};
write(12020, [NpcList]) ->
    NL = length(NpcList),
    Bin = list_to_binary([<<Id:32, Ico:8>> || [Id, Ico] <- NpcList]),
    Data = <<NL:16, Bin/binary>>,
    {ok, pt:pack(12020, Data)};

%% 掉落捡取信息
write(12021, [PlayerId, DropId, PlayerName]) ->
    Bin = pt:write_string(PlayerName),
    {ok, pt:pack(12021, <<PlayerId:64, DropId:64, Bin/binary>>)};

%% boss的归属(根据伤害最高)
write(12022, [PlayerId, BossFlag]) ->
    {ok, pt:pack(12022, <<PlayerId:64, BossFlag:8>>)};

%% 怪物说话
write(12023, [AutoId, Msg]) ->
    MsgBin = pt:write_string(Msg),
    {ok, pt:pack(12023, <<AutoId:32, MsgBin/binary>>)};

%% 开始拾取掉落
write(12024, [DropId, RoleId, DropEndTime]) ->
    {ok, pt:pack(12024, <<DropId:64, RoleId:64, DropEndTime:64>>)};

%% 怪物伤害列表
write(12025, [AutoId, ConfigId, List]) ->
    F = fun({RoleId, Name, ServerId, ServerNum, ServerName, TeamId, TeamPos, Hurt, AssistId}) ->
        NameBin = pt:write_string(Name),
        ServerNameBin = pt:write_string(ServerName),
        <<RoleId:64, NameBin/binary, ServerId:16, ServerNum:16, ServerNameBin/binary, TeamId:64, TeamPos:8, Hurt:64, AssistId:64>>
    end,
    ListBin = pt:write_array(F, List),
    {ok, pt:pack(12025, <<AutoId:32, ConfigId:32, ListBin/binary>>)};

%% 增加怪物伤害
write(12026, [AutoId, ConfigId, RoleId, Name, ServerId, ServerNum, ServerName, TeamId, TeamPos, Hurt, AssistId]) ->
    NameBin = pt:write_string(Name),
    ServerNameBin = pt:write_string(ServerName),
    {ok, pt:pack(12026, <<AutoId:32, ConfigId:32, RoleId:64, NameBin/binary, ServerId:16, ServerNum:16, ServerNameBin/binary, TeamId:64, TeamPos:8, Hurt:64, AssistId:64>>)};

%% 去掉怪物伤害
write(12027, [AutoId, ConfigId, RoleIdL]) ->
    RoleIdLBin = pt:write_array(fun(RoleId) -> <<RoleId:64>> end, RoleIdL),
    {ok, pt:pack(12027, <<AutoId:32, ConfigId:32, RoleIdLBin/binary>>)};

%% 玩家协助id更改
write(12028, [AutoId, ConfigId, ChangeIds]) ->
    ChangeLBin = pt:write_array(fun({RoleId, AssistId}) -> <<RoleId:64, AssistId:64>> end, ChangeIds),
    {ok, pt:pack(12028, <<AutoId:32, ConfigId:32, ChangeLBin/binary>>)};

%% 掉落捡取信息
write(12030, AreaMarkL) ->
    Data = pack_area_mark(AreaMarkL),
    {ok, pt:pack(12030, Data)};

%% 请求切换场景
write(12031, Err) ->
    {ok, pt:pack(12031, <<Err:8>>)};

%% 场景特效改变通知
write(12032, [SceneId, EffValues]) ->
    EffValuesBin = pt:write_array(fun({EffId, DelOrAdd}) -> <<EffId:16, DelOrAdd:8>> end, EffValues),
    {ok, pt:pack(12032, <<SceneId:32, EffValuesBin/binary>>)};


%% 小飞鞋
write(12033, [Code]) ->
    {ok, pt:pack(12033, <<Code:32>>)};

%% 超链接场景传送
write(12034, [Code, X, Y]) ->
    {ok, pt:pack(12034, <<Code:32, X:16, Y:16>>)};

%% 跨服服战场景传送
write(12035, [Code, X, Y]) ->
    {ok, pt:pack(12035, <<Code:32, X:16, Y:16>>)};

%% 血量变化
write(12036, [Sign, Id, Hp, HpLim, IsMinus, Change, BuffId]) ->
    write(12036, [Sign, Id, Hp, HpLim, IsMinus, Change, BuffId, 0, 0]);
write(12036, [Sign, Id, Hp, HpLim, IsMinus, Change, BuffId, SourceSign, SourceId]) ->
    {ok, pt:pack(12036, <<Sign:8, Id:64, Hp:64, HpLim:64, IsMinus:8, Change:64, BuffId:16, SourceSign:8, SourceId:64>>)};

%% 查询线路状态
write(12040, [SceneId, LineNo, NumsL]) ->
    F = fun({CopyId, Num}) ->
                Status = if
                             Num >= 100 -> 3;
                             Num >= 80  -> 2;
                             true -> 1
                         end,
                <<(CopyId+1):16, Status:8>>
        end,
    Len = length(NumsL),
    NumsLBin = list_to_binary(lists:map(F, NumsL)),
    {ok, pt:pack(12040, <<SceneId:32, LineNo:16, Len:16, NumsLBin/binary>>)};

%% 切换场景线路
write(12041, ErrCode) ->
    {ok, pt:pack(12041, <<ErrCode:32>>)};

%% 玩家当前场景线路
write(12042, [LineNo]) ->
    {ok, pt:pack(12042, <<LineNo:16>>)};

%% 怪物：玩家的求助列表
write(12043, [AutoId, ConfigId, List]) ->
    F = fun({AssistId, RoleId, Name, ServerId, ServerNum, ServerName}) ->
        NameBin = pt:write_string(Name),
        ServerNameBin = pt:write_string(ServerName),
        <<AssistId:64, RoleId:64, NameBin/binary, ServerId:16, ServerNum:16, ServerNameBin/binary>>
    end,
    ListBin = pt:write_array(F, List),
    {ok, pt:pack(12043, <<AutoId:32, ConfigId:32, ListBin/binary>>)};

%% 增加玩家求助
write(12044, [AutoId, ConfigId, AssistId, RoleId, Name, ServerId, ServerNum, ServerName]) ->
    NameBin = pt:write_string(Name),
    ServerNameBin = pt:write_string(ServerName),
    {ok, pt:pack(12044, <<AutoId:32, ConfigId:32, AssistId:64, RoleId:64, NameBin/binary, ServerId:16, ServerNum:16, ServerNameBin/binary>>)};

%% 删除玩家求助
write(12045, [AutoId, ConfigId, DelAssistId]) ->
    {ok, pt:pack(12045, <<AutoId:32, ConfigId:32, DelAssistId:64>>)};

%% 隐身字段广播
write(12070, [Sign, Id, Hide]) ->
    {ok, pt:pack(12070, <<Sign:8, Id:64, Hide:8>>)};

%% 幽灵字段广播
write(12071, [Sign, Id, Ghost]) ->
    {ok, pt:pack(12071, <<Sign:8, Id:64, Ghost:8>>)};

%% 分组字段广播
write(12072, [Sign, Id, Group]) ->
    {ok, pt:pack(12072, <<Sign:8, Id:64, Group:64>>)};


%% 嘲讽buff追踪对象
write(12073, [Sign, Id]) ->
    {ok, pt:pack(12073, <<Sign:8, Id:64>>)};

%% pk状态广播
write(12074, [Sign, Id, PkStatus]) ->
    {ok, pt:pack(12074, <<Sign:8, Id:64, PkStatus:8>>)};

%% 展示状态广播
write(12075, [Sign, Id, Show]) ->
    {ok, pt:pack(12075, <<Sign:8, Id:64, Show:8>>)};

write(12076, [Id, Id2]) ->
  {ok, pt:pack(12076, <<Id:64, Id2:64>>)};

write(12078, [Id, Figure]) ->
  FigureB = pt:write_figure(Figure),
  {ok, pt:pack(12078, <<Id:64, FigureB/binary>>)};

write(12079, [Id, ShipModel]) ->
  {ok, pt:pack(12079, <<Id:64, ShipModel:32>>)};

%% 怪物属性更新
write(12080, [Id, Attrs]) ->
    AttrsBin = pt:write_array(fun({Type, Value}) -> <<Type:8, Value:32>> end, Attrs),
    {ok, pt:pack(12080, <<Id:32, AttrsBin/binary>>)};

%% 怪物加血
write(12081, [Id, Hp]) ->
    {ok, pt:pack(12081, <<Id:32, Hp:64>>)};

%%改变速度
write(12082, [Sign, PlayerId, PlayerSpeed]) ->
    {ok, pt:pack(12082, <<Sign:8, PlayerId:64, PlayerSpeed:16>>)};

write(12083, [ReviveType,ScenceId, X,Y,ScenceName,Hp,Gold,BGold,AttProtectedTime]) ->
    ScenceNameBin = pt:write_string(ScenceName),
    {ok, pt:pack(12083, <<ReviveType:8,ScenceId:32, X:16,Y:16,ScenceNameBin/binary,Hp:64,Gold:32,BGold:32,AttProtectedTime:16>>)};

%% 改变攻速
write(12084, [Sign, Id, Value]) ->
    {ok, pt:pack(12084, <<Sign:8, Id:64, Value:16>>)};

%%玩家改变区域（客户端使用）
write(12085, [PlayerId, Type]) ->
    {ok, pt:pack(12085, <<PlayerId:64, Type:8>>)};

%%玩家改名通知
write(12086, [PlayerId, PlayerName]) ->
    Bin = pt:write_string(PlayerName),
    {ok, pt:pack(12086, <<PlayerId:64, Bin/binary>>)};

write(12087, [SceneId, Num]) ->
    {ok, pt:pack(12087, <<SceneId:16, Num:16>>)};

write(12088, [Users]) ->
    Len = length(Users),
    Bin = list_to_binary([pack_simple_user(U) || U <- Users]),
    {ok, pt:pack(12088, <<Len:16, Bin/binary>>)};

write(12089, [HeadUsers, LeftUser]) ->
    LLen = length(LeftUser),
    HUserB = pack_scene_user_list(HeadUsers),
    F = fun(EtsUser) ->
        #ets_scene_user{
            id=RoleId,
            platform=PlatForm,
            server_num=ServerNum,
            battle_attr=#battle_attr{hp_lim=HpLim, speed=Speed},
            figure=#figure{
                name=Name,
                sex=Sex,
                career=Career,
                lv=Lv,
                vip=Vip,
                guild_id=GuildId,
                guild_name=GuildName,
                position=Position,
                position_name=PositionName}
        } = EtsUser,
        PlatFormB = pt:write_string(PlatForm),
        NameB = pt:write_string(Name),
        PositionNameB = pt:write_string(PositionName),
        GuildNameB = pt:write_string(GuildName),
        <<PlatFormB/binary, ServerNum:16, RoleId:64, Sex:8, Career:8, Lv:16, NameB/binary, Vip:8,
        GuildId:64, GuildNameB/binary, Position:8, PositionNameB/binary, HpLim:64, Speed:16>>
    end,
    LeftUserB = list_to_binary([F(U) || U <- LeftUser]),
    {ok, pt:pack(12089, <<HUserB/binary, LLen:16, LeftUserB/binary>>)};

%% 公会id字段广播
write(12090, [Sign, Id, GuildId]) ->
    {ok, pt:pack(12090, <<Sign:8, Id:64, GuildId:64>>)};

write(12092, [List]) ->
    Len = length(List),
    F = fun({Id, AerBuffList}) -> <<Id:64, AerBuffList/binary>> end,
    Bin = list_to_binary([F(T) || T <- List]),
    {ok, pt:pack(12092, <<Len:16, Bin/binary>>)};

write(12093, [SkillL]) ->
    Len = length(SkillL),
    Bin = list_to_binary([<<SkillId:32, SkillLv:16>> || {SkillId, SkillLv} <- SkillL]),
    {ok, pt:pack(12093, <<Len:16, Bin/binary>>)};

write(_Cmd, _R) ->
    ?DEBUG("error cmd ~w R:~p~n", [_Cmd, _R]),
    {ok, pt:pack(0, <<>>)}.

%% =====私有函数=======

%% 打包元素列表
pack_elem_list([]) ->
    <<0:16>>;
pack_elem_list(Elem) ->
    Rlen = length(Elem),
    F = fun([Sid, Name, X, Y]) ->
                Name1 = pt:write_string(Name),
                <<Sid:32, Name1/binary, X:16, Y:16>>
        end,
    RB = list_to_binary([F(D) || D <- Elem]),
    <<Rlen:16, RB/binary>>.

%% 打包场景元素
pack_scene_object_list([]) ->
    <<0:16, 0:16, 0:16, 0:16>>;
pack_scene_object_list(List) ->
    F = fun(D, [TmpMonList, TmpPartnerList, TmpNormalList, TmpDummyList]) ->
        if
            D#scene_object.battle_attr#battle_attr.hp =< 0 -> [TmpMonList, TmpPartnerList, TmpNormalList, TmpDummyList];
            D#scene_object.sign == ?BATTLE_SIGN_MON -> [[binary_12007(D)|TmpMonList], TmpPartnerList, TmpNormalList, TmpDummyList];
            %% D#scene_object.sign == ?BATTLE_SIGN_PARTNER -> [TmpMonList, [binary_12013(D)|TmpPartnerList], TmpNormalList, TmpDummyList];
            D#scene_object.sign == ?BATTLE_SIGN_DUMMY -> [TmpMonList, TmpPartnerList, TmpNormalList, [binary_12015(D)|TmpDummyList]];
            is_record(D, scene_object) -> [TmpMonList, TmpPartnerList, [binary_12014(D)|TmpNormalList], TmpDummyList];
            true -> [TmpMonList, TmpPartnerList, TmpNormalList, TmpDummyList]
        end
    end,
    [MonList0, PartnerList0, NormalList0, DummyList0] = lists:foldl(F, [[],[],[],[]], List),
    MonList = lists:reverse(MonList0), PartnerList = lists:reverse(PartnerList0), NormalList = lists:reverse(NormalList0), DummyList = lists:reverse(DummyList0),
    MonLen = length(MonList), PartnerLen = length(PartnerList), NormalLen = length(NormalList), DummyLen = length(DummyList),
    MonListBin = list_to_binary(MonList), PartnerListBin = list_to_binary(PartnerList), NormalListBin = list_to_binary(NormalList), DummyListBin = list_to_binary(DummyList),
    <<MonLen:16, MonListBin/binary, PartnerLen:16, PartnerListBin/binary, NormalLen:16, NormalListBin/binary, DummyLen:16, DummyListBin/binary>>.

%% 打包NPC列表
pack_npc_list([]) ->
    <<0:16>>;
pack_npc_list(Npc) ->
    Rlen = length(Npc),
    F = fun(EtsNpc) ->
                Id = EtsNpc#ets_npc.id,
                Name = pt:write_string(EtsNpc#ets_npc.name),
                X = EtsNpc#ets_npc.x,
                Y = EtsNpc#ets_npc.y,
                Icon = EtsNpc#ets_npc.icon,
                Image = EtsNpc#ets_npc.image,
                Func = EtsNpc#ets_npc.func,
                Realm = EtsNpc#ets_npc.realm,
                <<Id:32, Id:32, Name/binary, X:16, Y:16, Icon:32, Func:8, Realm:8, Image:32>>
        end,
    RB = list_to_binary([F(D) || D <- Npc]),
    <<Rlen:16, RB/binary>>.

pack_scene_user_list([]) ->
    <<0:16, <<>>/binary>>;
pack_scene_user_list(User) ->
    UserBin = pack_scene_user_list_helper(User, [], 0),
    Rlen = length(UserBin),
    RB = list_to_binary(UserBin),
    <<Rlen:16, RB/binary>>.

%% 观战玩家不广播给其他人
pack_scene_user_list_helper([#ets_scene_user{hide_type = ?HIDE_TYPE_VISITOR}|T], List, Num) ->
  pack_scene_user_list_helper(T, List, Num);
pack_scene_user_list_helper([D | T], List, Num) when Num =< ?MAX_SENT_NUM ->
    case binary_to_12003(D) of
        false ->
            pack_scene_user_list_helper(T, List, Num);
        D1 ->
            pack_scene_user_list_helper(T, [D1 | List], Num+1)
    end;
pack_scene_user_list_helper(_, List, _) -> List.

%% 打包玩家离开列表
pack_leave_list([]) ->
    <<0:16, <<>>/binary>>;
pack_leave_list(User) ->
    Rlen = length(User),
    RB = list_to_binary([<<Id:64>> || Id <- User]),
    <<Rlen:16, RB/binary>>.

%% 打包场景对象离开列表
pack_scene_object_leave_list([]) ->
    <<0:16, <<>>/binary>>;
pack_scene_object_leave_list(List) ->
    Rlen = length(List),
    RB = list_to_binary([<<Id:32>> || Id <- List]),
    <<Rlen:16, RB/binary>>.

pack_area_mark([]) -> <<0:16>>;
pack_area_mark(List) ->
    Rlen = length(List),
    RB = list_to_binary([<<AreaId:8, ClientType:8>> || {AreaId, ClientType} <- List]),
    <<Rlen:16, RB/binary>>.

%% 假人
binary_12015(S) ->
    #scene_object{
       id      = Id,
       x       = X,
       y       = Y,
       server_id = SerId,
       server_num = SerNum,
       figure  = Figure,
       battle_attr = BA} = S,
    #battle_attr{hp=Hp, hp_lim=HpLim, speed=Speed, hide=Hide, ghost=Ghost, group=Group} = BA,
    FigureB = pt:write_figure(Figure),
    <<Id:32, 0:16, SerId:16, SerNum:16, FigureB/binary, X:16, Y:16, Hp:64, HpLim:64, Speed:16, Hide:8, Ghost:8, Group:64>>.

%% 一般场景物
binary_12014(S) ->
    #scene_object{
       x       = X,
       y       = Y,
       id      = Id,
       figure  = Figure,
       icon_effect = IconEffect,
       is_be_clicked = IsBeClicked,
       skill_owner = SkillOwer,
       battle_attr = BA} = S,
    #figure{name=Name, body=Body} = Figure,
    #battle_attr{speed=Speed} = BA,
    case SkillOwer of
        #skill_owner{id=PlayerId, team_id=TeamId} -> skip;
        _ -> PlayerId=0, TeamId=0
    end,
    NameBin = pt:write_string(Name),
    IconEffBin = pt:write_string(IconEffect),
    <<X:16, Y:16, Id:32, NameBin/binary, Body:32, IconEffBin/binary, Speed:16, IsBeClicked:8, TeamId:64, PlayerId:64>>.

%% 伙伴
binary_12013(S) ->
    #scene_object{
       x       = X,
       y       = Y,
       id      = Id,
       icon_texture=IconTextrue,
       figure  = Figure,
       skill_owner=SkillOwner,
       battle_attr = BA} = S,
    #figure{name=Name, lv = Lv, career=Career, lv_model=LvModel} = Figure,
    #battle_attr{speed=Speed, hp=Hp, hp_lim=HpLim, hide=Hide, group=Group} = BA,
    NameBin = pt:write_string(Name),
    Fun = fun({Part, ModelId}) -> <<Part:8, ModelId:32>> end,
    LvModelBin = pt:write_array(Fun, LvModel),
    case SkillOwner of
        #skill_owner{id=OwnerId} -> skip;
        _ -> OwnerId = 0
    end,
    <<X:16, Y:16, Id:32, Hp:64, HpLim:64, NameBin/binary, Lv:16, Speed:16, Career:8, Hide:8, Group:64, LvModelBin/binary, IconTextrue:32, OwnerId:64>>.

%% 怪物
binary_12007(#scene_object{sign=?BATTLE_SIGN_MON} = S) ->
    #scene_object{
       x = X, y = Y, id = Id, angle=_Angle,
       figure  = Figure, battle_attr = BA,
       att_type = AttType, color = Color,
       is_be_atted = IsBeAtted, is_be_clicked = IsBeClicked,
       icon_effect = IconEffect, icon_texture = IconTextrue,
       weapon_id = WeaponId, attr_type=_AttrType,
       mon = Mon, skill_owner = SkillOwner, bl_role_id = BlRoleId, frenzy_enter_time = FrenzyEnterTime,
       server_num = ServerNum} = S,
    #figure{lv=Lv, name=Name, body=Body, title = _Title, guild_id = MonGuildId, guild_name = GuildName} = Figure,
    #battle_attr{speed=Speed, hp=Hp, hp_lim=HpLim, hide=Hide, ghost=Ghost, group=Group} = BA,
    #scene_mon{mid=Mid, kind=Kind, out=Out, boss=Boss, collect_time=CollectTime, next_collect_time = NextCollectTime} = Mon,
    NameBin = pt:write_string(Name),
    IconEffBin = pt:write_string(IconEffect),
    GuildNameBin = pt:write_string(GuildName),
    case SkillOwner of #skill_owner{guild_id = GuildId} -> skip; _ -> GuildId = MonGuildId end,
    <<X:16, Y:16, Id:32, Mid:32, Hp:64, HpLim:64, Lv:16, NameBin/binary, Speed:16, Body:32, IconEffBin/binary, IconTextrue:32, WeaponId:32, AttType:8, Kind:8,
        Color:8, Out:8, Boss:8, CollectTime:32, IsBeClicked:8, IsBeAtted:8, Hide:8, Ghost:8, Group:64, GuildId:64, BlRoleId:64, FrenzyEnterTime:32,
        GuildNameBin/binary, ServerNum:16, NextCollectTime:32>>.
      %Angle:16, AttrType:8, Title:32>>.

%% 人物
binary_to_12003(D) when is_record(D, ets_scene_user) ->
    PlatFomrBin = pt:write_string(D#ets_scene_user.platform),
    ServerNameBin = pt:write_string(D#ets_scene_user.server_name),
    FigureBin = pt:write_figure(D#ets_scene_user.figure),
    BA = D#ets_scene_user.battle_attr,
    ShipModelId = lib_kf_guild_war_api:get_ship_model_id(D#ets_scene_user.ship_id),
    <<
        (D#ets_scene_user.id):64,
        PlatFomrBin/binary,
        (D#ets_scene_user.server_id):16,
        (D#ets_scene_user.server_num):16,
        ServerNameBin/binary,
        FigureBin/binary,
        (D#ets_scene_user.x):16,
        (D#ets_scene_user.y):16,
        (D#ets_scene_user.battle_attr#battle_attr.hp):64,
        (D#ets_scene_user.battle_attr#battle_attr.hp_lim):64,
        (D#ets_scene_user.battle_attr#battle_attr.speed):16,
        (D#ets_scene_user.battle_attr#battle_attr.hide):8,
        (D#ets_scene_user.battle_attr#battle_attr.ghost):8,
        (D#ets_scene_user.battle_attr#battle_attr.group):64,
        (D#ets_scene_user.bl_who):8, %% boss归属标志
        (D#ets_scene_user.team#status_team.team_id):64,
        (D#ets_scene_user.team#status_team.positon):8,
        (BA#battle_attr.pk#pk.pk_status):8,
        (D#ets_scene_user.battle_attr#battle_attr.combat_power):64,
        (BA#battle_attr.pk#pk.pk_value):16,
        (BA#battle_attr.pk#pk.pk_protect_time):32
        ,(D#ets_scene_user.mate_role_id):64
        ,(ShipModelId):32
        ,(BA#battle_attr.pk#pk.protect_time):32
        ,(D#ets_scene_user.camp_id):16
    >>;

binary_to_12003(D) when is_record(D, player_status)->
    PlatFomrBin = pt:write_string(D#player_status.platform),
    ServerNameBin = pt:write_string(D#player_status.server_name),
    FigureBin = pt:write_figure(D#player_status.figure),
    BA = D#player_status.battle_attr,
    ShipModelId = lib_kf_guild_war_api:get_ship_model_id(D#player_status.status_kf_guild_war#status_kf_guild_war.ship_id),
    <<
        (D#player_status.id):64,
        PlatFomrBin/binary,
        (D#player_status.server_id):16,
        (D#player_status.server_num):16,
        ServerNameBin/binary,
        FigureBin/binary,
        (D#player_status.x):16,
        (D#player_status.y):16,
        (D#player_status.battle_attr#battle_attr.hp):64,
        (D#player_status.battle_attr#battle_attr.hp_lim):64,
        (D#player_status.battle_attr#battle_attr.speed):16,
        (D#player_status.battle_attr#battle_attr.hide):8,
        (D#player_status.battle_attr#battle_attr.ghost):8,
        (D#player_status.battle_attr#battle_attr.group):64,
        (D#player_status.bl_who):8, %% boss归属标志
        (D#player_status.team#status_team.team_id):64,
        (D#player_status.team#status_team.positon):8,
        (BA#battle_attr.pk#pk.pk_status):8,
        (D#player_status.battle_attr#battle_attr.combat_power):64,
        (BA#battle_attr.pk#pk.pk_value):16,
        (BA#battle_attr.pk#pk.pk_protect_time):32
        ,(D#player_status.mate_role_id):64
        ,ShipModelId:32
        ,(BA#battle_attr.pk#pk.protect_time):32
        ,(D#player_status.camp_id):16
    >>;

binary_to_12003(_Status) ->
    false.

pack_simple_user(User) ->
    #ets_scene_user{platform = Platform, figure = Figure, server_num = SerNum, id = Id} = User,
    #figure{name = Name, sex = Sex, realm = Realm, career = Career, lv = Lv, picture = Pic, picture_ver = PicVer} = Figure,
    PlatFomrBin = pt:write_string(Platform),
    NameBin = pt:write_string(Name),
    PicBin = pt:write_string(Pic),
    <<PlatFomrBin/binary, SerNum:16, Id:64, Sex:8, Realm:8, Career:8, Lv:16, NameBin/binary, PicBin/binary, PicVer:32>>.
