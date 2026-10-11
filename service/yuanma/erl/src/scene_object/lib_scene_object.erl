%% ---------------------------------------------------------------------------
%% @doc lib_scene_object
%% @author ming_up@foxmail.com
%% @since  2017-02-06
%% @deprecated  场景对象公共接口
%% ---------------------------------------------------------------------------
-module(lib_scene_object).

-include("common.hrl").
-include("scene.hrl").
-include("battle.hrl").
-include("partner.hrl").
-include("attr.hrl").
-include("skill.hrl").
-include("figure.hrl").
-include("faker.hrl").


-export([
        sync_create_a_dummy/9,
        async_create_a_dummy/9,

        sync_create_a_partner/9,
        sync_create_a_partner/8,
        async_create_a_partner/8

        %% sync_create_a_bonfire/8,
        %% async_create_a_bonfire/8
    ]).

%% 对外接口
-export([
        sync_create_object/10           %% 同步创建场景对象
        , async_create_object/10        %% 异步创建场景对象
        , async_create_objects/5         %% 批量异步创建场景对象
        , send_object_move_msg/3        %% 发送场景对象走路协议
        , send_event_after/3
        , get_scene_object_battle_attr_by_ids/4     %% 按格式返回对象的战斗属性
        , change_attr_by_ids/4
        , change_attr_by_ids/5
        , clear_scene_object/5           %% 清理场景所有对象
        , clear_scene_object_by_ids/4    %% 根据场景对象id清理
    ]).

%% 对场景怪物模块内部接口
-export(
    [
        change_xy/1,
        remove/1,
        remove/3,
        lookup/3,
        insert/1,
        insert/3,
        update/2,
        delete/1,
        delete/3,
        put_ai/7,
        del_ai/3,
        change_ai/9,
        del_all_area/3,
        broadcast_object/1,
        broadcast_object_attr/2,
        change_attr_broadcast/3,
        stop/2,
        set_args/5
        ,thorough_sleep/2
        ,change_mon_attr/2 %%改变怪物分组
        ,send_msg_to_mon_by_id/2
    ]
).

%% @doc Args参数参考 lib_scene_object:set_args/4

%% 生成一个玩家镜像
%% retrun: DummyId
sync_create_a_dummy(SceneId, ScenePoolId, X, Y, CopyId, BroadCast, Figure, BattleAttr, Args) ->
    Args1 = [{figure, Figure}, {battle_attr, init_battle_attr(BattleAttr)}] ++ Args,
    sync_create_object(?BATTLE_SIGN_DUMMY, 0, SceneId, ScenePoolId, X, Y, 1, CopyId, BroadCast, Args1).

%% 异步生成一个玩家镜像
async_create_a_dummy(SceneId, ScenePoolId, X, Y, CopyId, BroadCast, Figure, BattleAttr, Args) ->
    Args1 = [{figure, Figure}, {battle_attr, init_battle_attr(BattleAttr)}] ++ Args,
    async_create_object(?BATTLE_SIGN_DUMMY, 0, SceneId, ScenePoolId, X, Y, 1, CopyId, BroadCast, Args1),
    ok.

%% 生成一个伙伴
%% Partner:#partner{}
%% Type:需要跟随的为0|不需要的为1)
%% retrun: DummyId
sync_create_a_partner(SceneId, ScenePoolId, X, Y, Type, CopyId, BroadCast, Partner, Args) when is_record(Partner, partner) ->
    BA  = lib_player_attr:attr_to_battle_attr(Partner#partner.battle_attr),
    Args1 = [{battle_attr, BA#battle_attr{speed=?SPEED_VALUE, combat_power=Partner#partner.combat_power}}, {lv, Partner#partner.lv}] ++ Args,
    %?PRINT("BA ~p~n", [Partner#partner.battle_attr]),
    sync_create_object(?BATTLE_SIGN_PARTNER, Partner#partner.partner_id, SceneId, ScenePoolId, X, Y, Type, CopyId, BroadCast, Args1).

sync_create_a_partner(SceneId, ScenePoolId, X, Y, CopyId, BroadCast, RecEmbattle, Args) ->
    BA  = lib_player_attr:attr_to_battle_attr(RecEmbattle#rec_embattle.battle_attr),
    Args1 = [{battle_attr, BA#battle_attr{speed=?SPEED_VALUE, combat_power=RecEmbattle#rec_embattle.combat_power}}, {lv, RecEmbattle#rec_embattle.lv}] ++ Args,
    %?PRINT("BA ~p~n", [Partner#partner.battle_attr]),
    sync_create_object(?BATTLE_SIGN_PARTNER, RecEmbattle#rec_embattle.partner_id, SceneId, ScenePoolId, X, Y, 1, CopyId, BroadCast, Args1).

%% 异步生成一个伙伴
async_create_a_partner(SceneId, ScenePoolId, X, Y, CopyId, BroadCast, Partner, Args) ->
    BA = lib_player_attr:attr_to_battle_attr(Partner#partner.battle_attr),
    Args1 = [{battle_attr, BA#battle_attr{speed=?SPEED_VALUE}}, {lv, Partner#partner.lv}] ++ Args,
    async_create_object(?BATTLE_SIGN_PARTNER, Partner#partner.partner_id, SceneId, ScenePoolId, X, Y, 1, CopyId, BroadCast, Args1),
    ok.

%% %% 生成一个篝火
%% %% retrun: AutoId
%% sync_create_a_bonfire(ConfigId, SceneId, ScenePoolId, X, Y, CopyId, BroadCast, Args) ->
%%     sync_create_object(?BATTLE_SIGN_BONFIRE, ConfigId, SceneId, ScenePoolId, X, Y, 0, CopyId, BroadCast, Args).

%% %% 异步生成一个玩家镜像
%% async_create_a_bonfire(ConfigId, SceneId, ScenePoolId, X, Y, CopyId, BroadCast, Args) ->
%%     async_create_object(?BATTLE_SIGN_BONFIRE, ConfigId, SceneId, ScenePoolId, X, Y, 0, CopyId, BroadCast, Args),
%%     ok.

%% 同步创建怪物
%% @spec sync_create_object(Type, MonId, Scene, ScenePoolId, X, Y, Type, CopyId, BroadCast, Args) -> MonAutoId
%% @param ObjectType ?BATTLE_SIGN_MON|?BATTLE_SIGN_PARTNER...
%% @param ConfigId 配置ID
%% @param Scene 场景ID
%% @param ScenePoolId 场景进程id
%% @param X 坐标
%% @param X 坐标
%% @param Type       怪物战斗类型（0被动，1主动）
%% @param CopyId     房间号ID 为0时，普通房间，非0值切换房间。值相同，在同一个房间。
%% @param BroadCast  是否出生时广播（0不广播，1广播）
%% @param Args       其余动态创建属性
%%                   = list() = [Tuple1, Tuple2...]
%%            Tuple1 = tuple(), {auto_lv, V} | {group, V}
%% @return MonAutoId 怪物自增ID，每个怪物唯一
%% @end
sync_create_object(ObjectType, ConfigId, Scene, ScenePoolId, X, Y, Type, CopyId, BroadCast, Args) ->
    case mod_scene_agent:apply_call(Scene, ScenePoolId, mod_scene_object_create, create_object,
            [ObjectType, ConfigId, Scene, ScenePoolId, X, Y, Type, CopyId, BroadCast, Args]) of
		Id when is_integer(Id) -> Id;
		_Retrun -> 0
	end.

%% 异步场景对象
%% @spec async_create_object(Type, MonId, Scene, ScenePoolId, X, Y, Type, CopyId, BroadCast, Args) -> ok.
%% @end
async_create_object(ObjectType, ConfigId, Scene, ScenePoolId, X, Y, Type, CopyId, BroadCast, Args) ->
   mod_scene_agent:apply_cast(Scene, ScenePoolId, mod_scene_object_create, create_object_cast, [ObjectType, ConfigId, Scene, ScenePoolId, X, Y, Type, CopyId, BroadCast, Args]).

%% 批量异步创建对象
async_create_objects(Scene, ScenePoolId, CopyId, Broadcast, List) ->
    mod_scene_agent:apply_cast(Scene, ScenePoolId, mod_scene_object_create, create_more_cast, [Scene, ScenePoolId, CopyId, Broadcast, List]).

%% 按格式返回对象的战斗属性
%% SceneId    = int()           场景id
%% Ids        = list()          怪物唯一Id列表
%% ResultForm = list()          [#battle_attr.xx1, #battle_attr.xx2...] | all | #battle_attr.xx1 属性组装列表或者单项属性, 复合属性暂不支持
get_scene_object_battle_attr_by_ids(SceneId, ScenePoolId, Ids, ResultForm) ->
    mod_scene_agent:apply_call(SceneId, ScenePoolId, lib_scene_object_agent, get_scene_object_battle_attr_by_ids, [Ids, ResultForm]).

%% 更新场景对象属性
change_attr_by_ids(Scene, ScenePoolId, Ids, KeyValues) ->
    mod_scene_agent:apply_cast(Scene, ScenePoolId, lib_scene_object_agent, change_attr_by_ids, [Ids, KeyValues]).

%% 更新场景对象属性
change_attr_by_ids(Scene, ScenePoolId, CopyId, Ids, KeyValues) ->
    mod_scene_agent:apply_cast(Scene, ScenePoolId, lib_scene_object_agent, change_attr_by_mids, [CopyId, Ids, KeyValues]).

%% 清除全场景的怪物
%% Sign       = 0|?BATTLE_SIGN_MON | ?BATTLE_SIGN_PARTNER...
%% SceneId    = int()                 场景ID
%% CopyId     = int() | pid()         房间id,不分房间清理时置为 []
%% BroadCast  = 0 | 1                 是否需要在清除的时候广播(0不广播，1广播)
clear_scene_object(Sign, SceneId, ScenePoolId, CopyId, BroadCast) ->
    mod_scene_agent:apply_cast(SceneId, ScenePoolId, lib_scene_object_agent, clear_scene_object, [Sign, CopyId, BroadCast]),
    ok.

%% 清除id怪物
%% SceneId    = int()                 场景ID
%% BroadCast  = 0 | 1                 是否需要在清除的时候广播(0不广播，1广播)
%% Ids        = list()                怪物唯一Id列表 #scene_object.id
clear_scene_object_by_ids(SceneId, ScenePoolId, BroadCast, Ids) ->
    mod_scene_agent:apply_cast(SceneId, ScenePoolId, lib_scene_object_agent, clear_scene_object_by_ids, [BroadCast, Ids]),
    ok.

%% 场景对象移动
change_xy(#scene_object{id=ObjectId, scene=Scene, scene_pool_id=ScenePoolId, copy_id=CopyId, x=X, y=Y}) ->
    mod_scene_agent:cast_to_scene(Scene, ScenePoolId, {'scene_object_move', CopyId, X, Y, ObjectId}).

%% 清除场景对象
remove(#scene_object{id=ObjectId, aid=ObjectPid, scene=Scene, scene_pool_id=ScenePoolId, copy_id=CopyId, x=X, y=Y} = Object) ->
    case is_pid(ObjectPid) of
        true  -> mod_scene_agent:apply_cast(Scene, ScenePoolId, erlang, send, [ObjectPid, 'stop']);
        false -> delete(Object)
    end,
    {ok, BinData} = pt_120:write(12006, ObjectId),
    lib_server_send:send_to_area_scene(Scene, ScenePoolId, CopyId, X, Y, BinData),
    ok.
remove(Scene, ScenePoolId, MonId) ->
    case lookup(Scene, ScenePoolId, MonId) of
        [] -> ok;
        Object -> remove(Object)
    end.

%% 查找指定对象信息
lookup(Scene, ScenePoolId, IdList) when is_list(IdList) ->
    mod_scene_agent:apply_call(Scene, ScenePoolId, lib_scene_object_agent, get_object, [IdList]);
lookup(Scene, ScenePoolId, Id) ->
    mod_scene_agent:apply_call(Scene, ScenePoolId, lib_scene_object_agent, get_object, [Id]).

%% 修改或者插入数据
insert(Object) ->
    mod_scene_agent:apply_cast(Object#scene_object.scene, Object#scene_object.scene_pool_id, lib_scene_object_agent, put_object, [Object]).

insert(Scene, ScenePoolId, Object) ->
    mod_scene_agent:apply_cast(Scene, ScenePoolId, lib_scene_object_agent, put_object, [Object]).

update(Object, KeyValues) ->
    mod_scene_agent:apply_cast(Object#scene_object.scene, Object#scene_object.scene_pool_id, lib_scene_object_agent, update, [Object#scene_object.id, KeyValues]).

delete(Object) ->
    mod_scene_agent:apply_cast(Object#scene_object.scene, Object#scene_object.scene_pool_id, lib_scene_object_agent, del_object, [Object#scene_object.id]).
delete(Scene, ScenePoolId, Id) ->
    mod_scene_agent:apply_cast(Scene, ScenePoolId, lib_scene_object_agent, del_object, [Id]).

%% 写入警戒区
put_ai(Aid, SceneId, ScenePoolId, CopyId, X, Y, WaringRange) ->
    mod_scene_agent:apply_cast(SceneId, ScenePoolId, lib_scene_object_agent, do_for_trace, [Aid, CopyId, WaringRange, X, Y, 1]).

%% 改变警戒区
change_ai(Aid, SceneId, ScenePoolId, CopyId, X, Y, WaringRange, OX, OY) ->
    mod_scene_agent:apply_cast(SceneId, ScenePoolId, lib_scene_object_agent, change_ai, [Aid, CopyId, WaringRange, X, Y, OX, OY]).

%% 删除警戒区
del_ai(SceneId, ScenePoolId, CopyId) ->
    mod_scene_agent:apply_cast(SceneId, ScenePoolId, lib_scene_object_agent, del_trace, [CopyId]).

%% 删除9宫格数据
del_all_area(SceneId, ScenePoolId, CopyId) ->
    mod_scene_agent:apply_cast(SceneId, ScenePoolId, lib_scene_object_agent, del_all_area, [CopyId]).

%% 广播对象移动协议
send_object_move_msg(Oldx, Oldy, Object)->
    #scene_object{id = Id, scene = SceneId, scene_pool_id=ScenePoolId, copy_id = CopyId, x = X, y = Y} = Object,
    %% 告诉玩家有怪物移动
    {ok, BinData}  = pt_120:write(12008, [X, Y, Id]),
    % 告诉玩家有怪物被移除
    {ok, BinData1} = pt_120:write(12006, Id),
    %% 告诉玩家有怪物移动进入
    BinData2 = pack_scene_object_bin(Object),
    case lib_scene:is_broadcast_scene(SceneId) of
        true ->
            lib_server_send:send_to_scene(SceneId, ScenePoolId, CopyId, BinData);
        false ->
            mod_scene_agent:apply_cast_with_state(SceneId, ScenePoolId, lib_scene_calc, move_broadcast,
                [CopyId, X, Y, Oldx, Oldy, BinData, BinData1, BinData2, []])
    end.

%% 取消定时器和发送新的定时器消息
send_event_after(Ref, Time, Msg) ->
    util:cancel_timer(Ref),
    gen_fsm:send_event_after(Time, Msg).

%% 广播场景对象出现
broadcast_object(#scene_object{scene=Scene, scene_pool_id=ScenePoolId, copy_id=CopyId, x=Xpx, y=Ypx}=Object) ->
    BinData = pack_scene_object_bin(Object),
    lib_server_send:send_to_area_scene(Scene, ScenePoolId, CopyId, Xpx, Ypx, BinData).

%% 广播场景对象属性更新
broadcast_object_attr(#scene_object{id=Id, scene=Scene, scene_pool_id=ScenePoolId, copy_id=CopyId, x=Xpx, y=Ypx}, AttrKeyValues) ->
    if
        length(AttrKeyValues) > 0 ->
            {ok, BinData} = pt_120:write(12080, [Id, AttrKeyValues]),
            lib_server_send:send_to_area_scene(Scene, ScenePoolId, CopyId, Xpx, Ypx, BinData);
        true ->
            ok
    end.

change_attr_broadcast([], SceneObject, UpList) ->
    broadcast_object_attr(SceneObject, UpList);
change_attr_broadcast([{restore_hp}|L], SceneObject, UpList) ->
    #scene_object{battle_attr = BattleAttr} = SceneObject,
    change_attr_broadcast(L, SceneObject, [{5, BattleAttr#battle_attr.hp}|UpList]);
change_attr_broadcast([{hp, _Hp}|L], SceneObject, UpList) ->
    #scene_object{battle_attr = BattleAttr} = SceneObject,
    change_attr_broadcast(L, SceneObject, [{5, BattleAttr#battle_attr.hp}|UpList]);
change_attr_broadcast([{change_speed, Value}|L], SceneObject, UpList) ->
    #scene_object{id=Id, scene=Scene, scene_pool_id=ScenePoolId, copy_id=CopyId, x=Xpx, y=Ypx, sign = Sign} = SceneObject,
    {ok, BinData} = pt_120:write(12082, [Sign, Id, Value]),
    lib_server_send:send_to_area_scene(Scene, ScenePoolId, CopyId, Xpx, Ypx, BinData),
    change_attr_broadcast(L, SceneObject, UpList);
change_attr_broadcast([{group, Group}|L], SceneObject, UpList) ->
    #scene_object{id=AutoId, scene=SceneId, scene_pool_id=PoolId, copy_id=_CopyId, x=_Xpx, y=_Ypx, sign = Sign} = SceneObject,
    {ok, Bin}  = pt_120:write(12072, [Sign, AutoId, Group]),
    lib_server_send:send_to_scene(SceneId, PoolId, Bin),
    change_attr_broadcast(L, SceneObject, UpList);
change_attr_broadcast([{figure, Value}|L], SceneObject, UpList) ->
	#figure{guild_id = GuildId} = Value,
	#scene_object{id=AutoId, scene=SceneId, scene_pool_id=PoolId, copy_id=_CopyId, x=_Xpx, y=_Ypx, sign = Sign} = SceneObject,
	%%暂时只是广播公会id的改变
	{ok, Bin}  = pt_120:write(12090, [Sign, AutoId, GuildId]),
	lib_server_send:send_to_scene(SceneId, PoolId, Bin),
	change_attr_broadcast(L, SceneObject, UpList);
change_attr_broadcast([{is_be_atted, IsbeAtt}|L], SceneObject, UpList) ->
    change_attr_broadcast(L, SceneObject, [{3, IsbeAtt}|UpList]);
change_attr_broadcast([_T|L], SceneObject, UpList) ->
    change_attr_broadcast(L, SceneObject, UpList).

%% 打包场景对象
pack_scene_object_bin(#scene_object{sign=Sign} = Object) ->
    case Sign of
        ?BATTLE_SIGN_MON ->
            {ok, BinData} = pt_120:write(12007, Object),
            BinData;
        ?BATTLE_SIGN_PARTNER  ->
            {ok, BinData} = pt_120:write(12013, Object),
            BinData;
        ?BATTLE_SIGN_DUMMY ->
            {ok, BinData} = pt_120:write(12015, Object),
            BinData;
        _ ->
            {ok, BinData} = pt_120:write(12014, Object),
            BinData
    end.

%% 移除场景对象(Broadcast:0不广播|1广播)
stop(Object, Broadcast) ->
    delete(Object),
    case Broadcast of
        1 ->
            {ok, BinData} = pt_120:write(12006, Object#scene_object.id),
            lib_server_send:send_to_area_scene(Object#scene_object.scene, Object#scene_object.scene_pool_id, Object#scene_object.copy_id,
                                               Object#scene_object.x, Object#scene_object.y, BinData);
        _ -> skip
    end.


%% 设置场景对象参数
set_args([H|T], State, StateName, Broadcast, UpList) ->
    #ob_act{object=SceneObject} = State,
    [NewObj, UpList1] = case H of
        {faker_info, Value} ->
            #faker_info{
                server_id = SerId, server_num = SerNum, server_name = _SerName,
                figure = Figure, battle_attr = BA, active_skills = Skills
            } = Value,
            NewUpList = [{server_id, SerId}, {server_num, SerNum}, {figure, Figure}, {battle_attr, BA}, {filter_skill, Skills}|UpList],
            [ SceneObject#scene_object{server_id = SerId, server_num = SerNum, figure=Figure, battle_attr = BA, skill = Skills}, NewUpList];
        {server_id, SerId} ->
            [ SceneObject#scene_object{server_id = SerId}, [H|UpList] ];
        {server_num, SerNum} ->
            [ SceneObject#scene_object{server_num = SerNum}, [H|UpList] ];
        {skill_owner, SkillOwner} ->
            [ SceneObject#scene_object{skill_owner = SkillOwner}, [H|UpList] ];
        %% {barbecue, _Value, 0} when SceneObject#scene_object.sign==?BATTLE_SIGN_BONFIRE ->
        %%     SceneObject#scene_object.aid ! {'barbecue', 0, 0, 0}, SceneObject,
        %%     [SceneObject, UpList];
        %% {barbecue, Value, EndTime} when SceneObject#scene_object.sign==?BATTLE_SIGN_BONFIRE ->
        %%     SceneObject#scene_object.aid ! {'barbecue', 1, Value, EndTime}, SceneObject,
        %%     [SceneObject, UpList];
        {skill_owner_team_id, TeamId} ->
            SkillOwner = SceneObject#scene_object.skill_owner,
            case Broadcast of
                1 ->
                    {ok, BinData} = pt_120:write(12080, [SceneObject#scene_object.id, [{2, TeamId}] ]),
                    lib_server_send:send_to_area_scene(SceneObject#scene_object.scene, SceneObject#scene_object.scene_pool_id, SceneObject#scene_object.copy_id,
                        SceneObject#scene_object.x, SceneObject#scene_object.y, BinData);
                _ -> skip
            end,
            NewSkillOwner = SkillOwner#skill_owner{team_id=TeamId},
            [ SceneObject#scene_object{skill_owner = NewSkillOwner}, [{skill_owner, NewSkillOwner}|UpList] ];
        {figure, Value} ->
            [ SceneObject#scene_object{figure=Value}, [H|UpList] ];
        {lv, Value} ->
            Figure=SceneObject#scene_object.figure#figure{lv=Value},
            [ SceneObject#scene_object{figure=Figure}, [{figure, Figure}|UpList] ];
        {battle_attr, Value} ->
            [ SceneObject#scene_object{battle_attr=Value}, [H|UpList] ];
        {group, Value} ->
            BA = SceneObject#scene_object.battle_attr,
            NewBA = BA#battle_attr{group=Value},
            [ SceneObject#scene_object{battle_attr=NewBA}, [{battle_attr, NewBA}|UpList] ];
        {skill, Value} ->
            F = fun({SkillId, Lv}) ->
                    case data_skill:get(SkillId, Lv) of
                        #skill{type=Type} when Type == ?SKILL_TYPE_ACTIVE orelse Type == ?SKILL_TYPE_ASSIST -> true;
                        _ -> false
                    end
            end,
            Skill = lists:filter(F, Value),
            [ SceneObject#scene_object{skill = Skill}, [{filter_skill, Skill}|UpList] ];
        {mod_args, Value} ->
            [ SceneObject#scene_object{mod_args = Value}, [H|UpList] ];
        {find_target, Value} ->
            erlang:send_after(Value, SceneObject#scene_object.aid, 'find_target'),
            [SceneObject, UpList];
        {walk, Value} ->
            erlang:send_after(Value, SceneObject#scene_object.aid, 'walk'),
            [SceneObject, UpList];
        {pos, Pos} ->
            %% 带阵法属性
            [ SceneObject#scene_object{pos = Pos}, [H|UpList] ];
        {add_partner, {PartnerId, PartnerAid, Personality}} ->
            case SceneObject of
                #scene_object{sign=?BATTLE_SIGN_DUMMY, dummy=Dummy=#scene_dummy{partner=Partner}} ->
                    Partner1 = [{PartnerId, PartnerAid, Personality}|lists:keydelete(PartnerId, 1, Partner)],
                    Dummy1 = Dummy#scene_dummy{partner=Partner1},
                    [ SceneObject#scene_object{dummy = Dummy1}, [{dummy, Dummy1}|UpList] ];
                _ ->
                    [SceneObject, UpList]
            end;
        {dummy, Dummy} ->
            [ SceneObject#scene_object{dummy = Dummy}, [{dummy, Dummy}|UpList] ];
        {hp, Value} ->
            BA = SceneObject#scene_object.battle_attr,
            NewBA = BA#battle_attr{hp=Value},
            [ SceneObject#scene_object{battle_attr=NewBA}, [{battle_attr, NewBA}|UpList] ];
        {type, Value} ->
            [SceneObject#scene_object{type = Value}, UpList];
        {warning_range, Value} ->
            [SceneObject#scene_object{warning_range = Value}, UpList];
        {ghost, Value} ->
            BA = SceneObject#scene_object.battle_attr,
            NewBA = BA#battle_attr{ghost = Value},
            [SceneObject#scene_object{battle_attr = NewBA}, [{battle_attr, NewBA}|UpList]];
        _Other -> [SceneObject, UpList]
    end,
    NewSN = case H of
        {state, TmpSN} -> TmpSN;
        _ -> StateName
    end,
    NewState = case H of
        {die_handler, ObValue} ->
            State#ob_act{die_handler = ObValue};
        {born_handler, ObValue} ->
            State#ob_act{born_handler = ObValue};
        {check_block, ObValue} ->
            State#ob_act{check_block = ObValue};
        {path, ObValue} ->
            State#ob_act{path = ObValue};
        {revive_time, ObValue} ->
            State#ob_act{revive_time = ObValue};
        _ ->
            State
    end,
    LastState = NewState#ob_act{object=NewObj},
    set_args(T, LastState, NewSN, Broadcast, UpList1);
set_args(_, State, StateName, _, UpList) -> {State, StateName, UpList}.

%% 初始化场景对象battle_attr的一些中间状态
init_battle_attr(BattleAttr) ->
    BattleAttr#battle_attr{
        hp              = BattleAttr#battle_attr.hp_lim,
        skill_effect    = #skill_effect{},
        speed           = ?SPEED_VALUE,
        attr_buff_list  = [],
        other_buff_list = [],
        ghost           = 0,
        hide            = 0
    }.


thorough_sleep(AutoId, State) ->
    case lib_scene_object_agent:get_object(AutoId) of
        #scene_object{aid = Aid} ->
            erlang:send(Aid, 'thorough_sleep');
        _ ->
            skip
    end,
    State.
%% 动态改变同一个场景里的怪物属性
change_mon_attr(KeyValueList, State) ->
    %%#scene_object
    MonList = lib_scene_object_agent:get_scene_object(),
%%    ?MYLOG("cym3", "MonList ~p  Group ~p ~n", [MonList, Group]),
    change_mon_attr_help(MonList, KeyValueList),
    State.
change_mon_attr_help([], _KeyValueList) ->
    ok;
change_mon_attr_help([H |MonList], KeyValueList) ->
    case H of
        #scene_object{aid = Aid} ->
%%            ?MYLOG("cym3", "change_mon_group++++++++++++++ ~n", []),
            erlang:send(Aid, {'change_attr', KeyValueList});
        _ ->
            skip
    end,
    change_mon_attr_help(MonList, KeyValueList).

send_msg_to_mon_by_id(Id, Msg) ->
    case lib_scene_object_agent:get_object(Id) of
        #scene_object{aid = Aid} ->
            Aid ! Msg;
        _ ->
            ok
    end.