%% ---------------------------------------------------------------------------
%% @doc lib_mon_util

%% @author  lzh
%% @email   lu13824949032@gmail.com
%% @since   2021/8/10 0010
%% @deprecated  
%% ---------------------------------------------------------------------------
-module(lib_mon_util).

%% API
-compile([export_all]).

%% 怪物进程的工具函数
-export([
      base_to_cache/2                                             %% 设置怪物参数
    , set_mon/6                                                   %% 设置怪物参数
    , set_mon_other/2                                             %% 设置怪物参数
    , add_hatred_list/3                                           %% 加入仇恨列表叠加伤害
    , get_boss_drop_bltype/2                                      %% 获取boss掉落归属
    , calc_boss_bl_who/7                                          %% 计算boss的归属返回一个列表
    , update_boss_bl_whos/8                                       %% 更新场景玩家的归属显示
    , calc_boss_bl_who_assist/4                                   %% 计算协助状态的玩家列表
    , update_boss_bl_whos_assist/8                                %% 更新协助状态的玩家列表
    , sync_team_boss_bl_whos/3                                    %% 同步队伍的归属
    , check_sync_team_boss_bl_whos/5                              %% 是否需要同步计算归属
    , is_forbid_stop_scene/1                                      %% 特定场景采集过程中不允许清理
    , get_bl_whos_first_attr/2                                    %% 获取归属中第一个攻击者
    , get_assist_ex_id/2                                          %% 获取协助者信息
    , combine_hurt_with_same_assist/2                             %% 将相同协助id的伤害加在一起后，再去计算归属
    , is_active_mon/1                                             %% 是否主动怪
    , is_collect_mon/1                                            %% 是否采集怪
]).

%% 怪物相关工具函数
-export([
      create_mon_atter/1
]).

-include("common.hrl").
-include("server.hrl").
-include("scene.hrl").
-include("battle.hrl").
-include("skill.hrl").
-include("attr.hrl").
-include("drop.hrl").
-include("def_fun.hrl").
-include("figure.hrl").
-include("team.hrl").

%% ====================================== Mon Process ======================================
%% =============================
%% 配置转化成内存记录
base_to_cache([Id, Scene, ScenePoolId, Xpx, Ypx, _Type, CopyId, Pid], M) ->
    #mon{
        id=Mid, boss=Boss, mon_sys=MonSys, kind=Kind, name=Name, career=_Career, color=Color, type=Type,
        icon=Icon, icon_effect=IconEffect, icon_texture=IconTextrue, weapon_id=WeaponId, lv=Lv,
        att=Att, hit=Hit, dodge=Dodge, crit=Crit,  hp_lim=Hp, def = Def, ten = Ten, wreck = Wreck, special_attr = SpecailAttr,
        striking_distance=StrikingDistance, tracing_distance=TracingDistance,  warning_range = WarningRange,
        att_time=AttTime, att_type=AttType, retime=ReTime, is_fight_back=IsFightBack, is_be_atted=IsBeAtt,
        is_be_clicked = IsBeClicked, skill=Skill, speed=Speed, exp=Exp, collect_time = CollectTime,
        collect_count=CollectCount, resum = Resume, auto = Auto, is_armor=IsArmor, is_hit_ac = IsHitAc,
        exp_share_type = ExpShareType, del_hp_each_time = DelHpEachTime
    } = M,
    case Resume of
        [_, NoBattleHpEx, ReGapTime] -> ok;
        [NoBattleHpEx, ReGapTime] -> ok;
        _ -> NoBattleHpEx = 0, ReGapTime = 0
    end,
    %% 初始化内存数据
    Attr = #attr{hp = Hp, att=Att, hit=Hit, dodge=Dodge,  crit=Crit, def = Def, ten = Ten, wreck = Wreck, speed = Speed},
    if
        SpecailAttr == [] -> NewAttr = Attr;
        true ->
            AttrList = lib_player_attr:to_kv_list(Attr),
            NewAttrList = ulists:kv_list_plus_extra([AttrList, SpecailAttr]),
            NewAttr = lib_player_attr:to_attr_record(NewAttrList)
    end,
    Figure      = #figure{name=Name, body=Icon, lv=Lv},
    BattleAttr  = #battle_attr{hp=Hp, hp_lim=Hp, attr=NewAttr, att_area=StrikingDistance, speed=Speed},
    SceneMon    = #scene_mon{d_x=Xpx, d_y=Ypx, mid=Mid, boss=Boss, mon_sys=MonSys, kind=Kind, collect_time = CollectTime,
        collect_count=CollectCount, auto=Auto, exp=Exp, retime=ReTime,
        exp_share_type = ExpShareType},
    #scene_object{
        sign=?BATTLE_SIGN_MON, id=Id, config_id=Mid, scene=Scene, scene_pool_id=ScenePoolId,
        copy_id=CopyId, x=Xpx, y=Ypx, type=Type, battle_attr=BattleAttr, figure=Figure, color=Color,
        icon_effect=IconEffect, icon_texture=IconTextrue, weapon_id=WeaponId, striking_distance=StrikingDistance,
        tracing_distance=TracingDistance, warning_range = WarningRange, att_time=AttTime, d_x=Xpx,
        d_y=Ypx, no_battle_hp_ex=NoBattleHpEx, hp_time=ReGapTime, is_fight_back=IsFightBack, is_be_atted=IsBeAtt,
        is_be_clicked = IsBeClicked, skill=Skill, att_type=AttType, aid=Pid,  is_armor=IsArmor, mon=SceneMon,
        is_hit_ac=IsHitAc, del_hp_each_time = DelHpEachTime
    }.

%% =============================
%% 设置怪物参数
set_mon([], M, State, StateName, _Broadcast, UpList) -> {M, State, StateName, UpList};
set_mon([H|T], M, State, StateName, Broadcast, UpList) ->
    [LastM, UpList1] = case H of
        {create_key, Value}  ->
            Mon1 = M#scene_object.mon#scene_mon{create_key = Value},
            [ M#scene_object{mon = Mon1}, [{mon, Mon1}|UpList] ];
        {dungeon_hp_rate, HpRateList} ->
            put(dungeon_hp_rate, HpRateList),
            [M, UpList];
        {collect_time, CollectTime} ->
            Mon = M#scene_object.mon,
            case Broadcast of
                1 -> lib_scene_object:broadcast_object_attr(M, [{?SCENE_OB_COLLECT_TIME, CollectTime}]);
                _ -> skip
            end,
            [ M#scene_object{mon=Mon#scene_mon{collect_time=CollectTime}}, UpList];
        {skill_owner, SkillOwner} ->
            [ M#scene_object{skill_owner = SkillOwner}, [H|UpList] ];
        {special_event, Events} ->
            self() ! {'special_event', Events},
            [M, UpList];
        {group, Camp} ->
            BA = M#scene_object.battle_attr#battle_attr{group=Camp},
            [ M#scene_object{battle_attr = BA}, [{battle_attr, BA}|UpList ]];
        {mon_name, MonName} ->
            case MonName == [] of
                true -> [M, UpList];
                false ->
                    Figure1 = M#scene_object.figure#figure{name=MonName},
                    [ M#scene_object{figure=Figure1}, [{figure, Figure1}|UpList] ]
            end;
        {guild_id, GuildId} ->
            Figure1 = M#scene_object.figure#figure{guild_id=GuildId},
            [ M#scene_object{figure=Figure1}, [{figure, Figure1}|UpList] ];
        {guild_name, GuildName} ->
            Figure1 = M#scene_object.figure#figure{guild_name=GuildName},
            [ M#scene_object{figure=Figure1}, [{figure, Figure1}|UpList] ];
        {server_num, ServerNum} ->
            [ M#scene_object{server_num = ServerNum}, [{server_num, ServerNum}|UpList] ];
        {hp, Hp} ->
            BattleAttr = M#scene_object.battle_attr,
            [ M#scene_object{battle_attr = BattleAttr#battle_attr{hp = Hp}}, [{hp, Hp}|UpList] ];
        {is_be_atted, Value} ->
            [ M#scene_object{is_be_atted = Value}, [{is_be_atted, Value}|UpList] ];
        {is_be_clicked, Value} ->
            [ M#scene_object{is_be_clicked = Value}, [{is_be_clicked, Value}|UpList] ];
        {mod_args, Value} ->
            [ M#scene_object{mod_args = Value}, [{mod_args, Value}|UpList] ];
        {auto_lv, Value} ->
            Mon1 = M#scene_object.mon#scene_mon{auto_lv=Value},
            [ M#scene_object{mon=Mon1}, [{mon, Mon1}|UpList] ];
        {dun_r, Value} ->
            Mon1 = M#scene_object.mon#scene_mon{dun_r=Value},
            [ M#scene_object{mon=Mon1}, [{mon, Mon1}|UpList] ];
        {dun_crush_r, Value} ->
            Mon1 = M#scene_object.mon#scene_mon{dun_crush_r=Value},
            [ M#scene_object{mon=Mon1}, [{mon, Mon1}|UpList] ];
        {retime, Value} ->
            Mon1 = M#scene_object.mon#scene_mon{retime=Value},
            [ M#scene_object{mon=Mon1}, [{mon, Mon1}|UpList] ];
        {angle, Value} ->
            [ M#scene_object{angle=Value}, [H|UpList] ];
        {type, Value} ->
            [ M#scene_object{type=Value}, [H|UpList] ];
        {skill, Value} ->
            F = fun({SkillId, Lv}) ->
                case data_skill:get(SkillId, Lv) of
                    #skill{type=Type, is_anger=0} when Type == ?SKILL_TYPE_ACTIVE orelse Type== ?SKILL_TYPE_ASSIST -> true;
                    _ -> false
                end
                end,
            Skill = lists:filter(F, Value),
            [ M#scene_object{skill = Skill}, [{filter_skill, Skill}|UpList] ];
        {born_x_y, Value} ->
            {X, Y} = Value,
            Mon1 = M#scene_object.mon#scene_mon{d_x = X, d_y = Y},
            [ M#scene_object{mon=Mon1}, [{mon, Mon1}|UpList] ];
        {title, Value} ->
            Figure = M#scene_object.figure#figure{title=Value},
            [ M#scene_object{figure=Figure}, [{figure, Figure}|UpList] ];
        {lv, Value} ->
            Figure = M#scene_object.figure#figure{lv=Value},
            [ M#scene_object{figure=Figure}, [{figure, Figure}|UpList] ];
        {figure, Value} ->
            [ M#scene_object{figure=Value}, [{figure, Value}|UpList] ];
        {weapon_id, Value} ->
            [ M#scene_object{weapon_id=Value}, [{weapon_id, Value}|UpList] ];
        {die_info, Value} ->
            DieInfos = M#scene_object.die_info,
            case lists:member(Value, DieInfos) of
                false ->
                    NewDieInfos = [Value|DieInfos],
                    [M#scene_object{die_info = NewDieInfos}, [{die_info, NewDieInfos}|UpList]];
                _ ->
                    [M, UpList]
            end;
        {find_target, Value} ->
            erlang:send_after(Value, M#scene_object.aid, 'find_target'),
            [M, UpList];
        {ctime, Value} ->
            Mon = M#scene_object.mon,
            [ M#scene_object{mon=Mon#scene_mon{ctime=Value}}, UpList];
        {restore_hp} ->
            BattleAttr = M#scene_object.battle_attr,
            NewHp = BattleAttr#battle_attr.hp_lim,
            [ M#scene_object{battle_attr = BattleAttr#battle_attr{hp = NewHp}}, [{hp, NewHp}|UpList] ];
        {hurt_check, Value} ->
            [ M#scene_object{hurt_check = Value}, [{hurt_check, Value}|UpList] ];
        {hp_r, Value} ->
            BattleAttr = M#scene_object.battle_attr,
            NewHp = trunc(BattleAttr#battle_attr.hp_lim * Value),
            [ M#scene_object{battle_attr = BattleAttr#battle_attr{hp = NewHp, hp_lim = NewHp}}, [{hp, NewHp}|UpList] ];
        {attr_replace, Value} ->
            case Value of
                [] ->
                    [M, UpList];
                _ ->
                    BattleAttr = M#scene_object.battle_attr,
                    NewBattleAttr = BattleAttr#battle_attr{attr = Value,hp = Value#attr.hp, hp_lim = Value#attr.hp},
                    [M#scene_object{battle_attr = NewBattleAttr}, [{battle_attr, NewBattleAttr},{hp, Value#attr.hp}|UpList]]
            end;
        {att_r, Value} ->
            BattleAttr = M#scene_object.battle_attr,
            Attr = BattleAttr#battle_attr.attr,
            NewAtt = trunc(Attr#attr.att * Value),
            NewBA = BattleAttr#battle_attr{attr = Attr#attr{att = NewAtt}},
            [M#scene_object{battle_attr = NewBA}, [{battle_attr, NewBA}|UpList]];
        {icon_texture, IconTextrue} ->
            [ M#scene_object{icon_texture = IconTextrue}, UpList];
        {speed_r, Value} when Value > 0 ->
            case data_mon:get(M#scene_object.config_id) of
                #mon{speed = BaseSpeed} ->
                    #battle_attr{speed = OSpeed} = BattleAttr = M#scene_object.battle_attr,
                    case trunc(BaseSpeed * Value) of
                        OSpeed ->
                            [M, UpList];
                        Speed ->
                            NewBA = BattleAttr#battle_attr{speed = Speed},
                            [M#scene_object{battle_attr = NewBA}, [{change_speed, Speed}|UpList]]
                    end;
                _ ->
                    [M, UpList]
            end;
        {dynamic_lv, Value} ->
            #scene_object{mon = #scene_mon{dun_r=DunR}, config_id = MId} = M,
            Lv
                = if
                      Value > 0 -> Value;
                      true ->
                          case data_mon:get(MId) of
                              #ets_scene_mon{lv = V} -> V;
                              _ -> 0
                          end
                  end,
            M1 = set_dynamic_mon(M, Lv, DunR),
            [M1, [{figure, M1#scene_object.figure}, {battle_attr, M1#scene_object.battle_attr}|UpList]];
        {be_att_limit, Limit} ->
            [ M#scene_object{be_att_limit = Limit}, [{be_att_limit, Limit}|UpList ]];
        {next_collect_time, NextCollectTime} ->
            Mon = M#scene_object.mon,
            [ M#scene_object{mon=Mon#scene_mon{next_collect_time=NextCollectTime}}, UpList];
        {collect_times, Value} ->
            Mon = M#scene_object.mon,
            [ M#scene_object{mon=Mon#scene_mon{collect_times=Value}}, UpList];
        {attr_list, Value} ->
            BattleAttr = M#scene_object.battle_attr,
            NewBattleAttr = lib_player_attr:set_battle_attr(BattleAttr, Value),
            [ M#scene_object{battle_attr = NewBattleAttr}, [{attr_list, Value}|UpList] ];
        {bl_role_id, Value} ->
            [ M#scene_object{bl_role_id = Value}, [{bl_role_id, Value}|UpList]];
        {add_assist, Value} ->
            #assist_data{assist_id = AssistId} = Value,
            NewAssistIds = [AssistId|lists:delete(AssistId, M#scene_object.assist_ids)],
            [ M#scene_object{assist_ids = NewAssistIds}, [{up_assist_ids, NewAssistIds}|UpList]];
        {del_assist_id, Value} ->
            NewAssistIds = lists:delete(Value, M#scene_object.assist_ids),
            [ M#scene_object{assist_ids = NewAssistIds}, [{up_assist_ids, NewAssistIds}|UpList]];
        {camp_id, Value} ->
            [ M#scene_object{camp_id = Value}, UpList];
        {speed, Value} ->
            NewBA = M#scene_object.battle_attr#battle_attr{speed=Value},
            case Broadcast of
                1 -> [ M#scene_object{battle_attr = NewBA}, [{change_speed, Value}|UpList]];
                _ -> [ M#scene_object{battle_attr = NewBA}, UpList]
            end;
        {hide, Value} ->
            NewBA = M#scene_object.battle_attr#battle_attr{hide=Value},
            case Broadcast of
                1 -> [ M#scene_object{battle_attr = NewBA}, [{hide, Value}|UpList]];
                _ -> [ M#scene_object{battle_attr = NewBA}, UpList]
            end;
        _ -> [M, UpList]
      end,

    NewState = case H of
        {path, Path} -> State#ob_act{path = Path};
        %% 伤害定时器引用，毫秒
        {hurt_ref, DelayTime} ->
            put({?MODULE, hurt_ref}, DelayTime),
            HurtRef = lib_mon_ai:send_after(DelayTime, self(), 'broadcast_hurt_list', State#ob_act.hurt_ref),
            State#ob_act{hurt_ref = HurtRef};
        {att, Sign, Id} ->
            State#ob_act{att = #{sign=>Sign, id=>Id}};
        {hp_change_handler, ObValue} ->
            State#ob_act{hp_change_handler = ObValue};
        {born_handler, ObValue} ->
            State#ob_act{born_handler = ObValue};
        {die_handler, ObValue} ->
            State#ob_act{die_handler = ObValue};
        {collected_handler, ObValue} ->
            State#ob_act{collected_handler = ObValue};
        {add_assist, AssistData} ->
            #assist_data{assist_id = AddAssistId} = AssistData,
            lib_mon_event:assist_add(LastM, AssistData),
            State#ob_act{assist_list = [AssistData|lists:keydelete(AddAssistId, #assist_data.assist_id, State#ob_act.assist_list)]};
        {del_assist_id, DelAssistId} ->
            lib_mon_event:assist_remove(LastM, DelAssistId),
            State#ob_act{assist_list = lists:keydelete(DelAssistId, #assist_data.assist_id, State#ob_act.assist_list)};
        _ -> State
    end,

    case H of
        {state, NewStateName} -> skip;
        _ -> NewStateName = StateName
    end,
    set_mon(T, LastM, NewState, NewStateName, Broadcast, UpList1).

%% ==========================================================
%% 设置怪物其他系数
%% 1. 设置动态参数
%% 2. 设置副本碾压怪物
%% 3. 添加参数属性
set_mon_other(Mon, Args) ->
    %% 设置动态属性
    MonAfDynamic = set_dynamic_mon(Mon),
    %% 副本碾压系数
    MonAfDunCrush = set_dun_crush_mon(MonAfDynamic, MonAfDynamic#scene_object.mon#scene_mon.dun_crush_r),
    %% 添加参数属性
    MonAddAttr =
        case lists:keyfind(add_attr, 1, Args) of
            {add_attr, AttrObj} ->
                add_mon_attr(MonAfDunCrush, AttrObj);
            _ -> MonAfDunCrush
        end,
    MonAddAttr.

%% 设置动态参数
set_dynamic_mon(Mon) ->
    case Mon#scene_object.mon#scene_mon.auto of
        ?MON_AUTO_WORLD_LV ->
            Lv = max(1, util:get_world_lv()),
            DunRatio = Mon#scene_object.mon#scene_mon.dun_r,
            set_dynamic_mon(Mon, Lv, DunRatio);
        ?MON_AUTO_AUTO_LV ->
            Lv = Mon#scene_object.mon#scene_mon.auto_lv,
            DunRatio = Mon#scene_object.mon#scene_mon.dun_r,
            set_dynamic_mon(Mon, Lv, DunRatio);
        _ -> Mon
    end.
set_dynamic_mon(Mon, Lv, DunRatio) ->
    case data_mon_dynamic:get(Mon#scene_object.config_id, Lv) of
        #mon_dynamic{att = Att, hp = Hp, exp = Exp} ->
            #scene_object{
                figure=Figure, mon=SceneMon,
                battle_attr=BA=#battle_attr{attr=Attr, hp = Hp0, hp_lim = HpLim0}} = Mon,
            HpLim = max(1, calc_mon_dynamic(Hp, Lv, DunRatio)),
            Attr1 = Attr#attr{att = calc_mon_dynamic(Att, Lv, DunRatio), hp = HpLim},
            BA1 = BA#battle_attr{hp=trunc(Hp0/HpLim0*HpLim), hp_lim=HpLim, attr=Attr1},
            Mon#scene_object{figure=Figure#figure{lv=Lv}, battle_attr=BA1, mon = SceneMon#scene_mon{exp = Exp}};
        _ -> Mon
    end.
calc_mon_dynamic(Base, _Lv, DunRatio) ->
    %% max(0, round(Lv*Base/100)).
    max(0, round(Base*DunRatio)).

%% 设置副本碾压怪物
set_dun_crush_mon(Mon, DunCrushR) ->
    #scene_object{battle_attr=BA=#battle_attr{hp_lim = HpLim, attr=Attr, hp = Hp} } = Mon,
    #attr{att = Att} = Attr,
    NewHpLim = calc_dun_crush_mon(HpLim, DunCrushR),
    Attr1 = Attr#attr{att = calc_dun_crush_mon(Att, DunCrushR)},
    BA1 = BA#battle_attr{hp=trunc(Hp/HpLim*NewHpLim), hp_lim=NewHpLim, attr=Attr1},
    Mon#scene_object{battle_attr=BA1}.

calc_dun_crush_mon(Base, DunCrushR) ->
    %% max(0, round(Lv*Base/100)).
    max(0, round(Base*DunCrushR)).

%% 添加属性
add_mon_attr(Mon, AttrObj) ->
    #scene_object{battle_attr=BA=#battle_attr{hp_lim = HpLim, attr=Attr} } = Mon,
    #attr{hp = AddedHp} = lib_player_attr:to_attr_record(AttrObj),
    Attr1 = lib_player_attr:add_attr(record, [AttrObj, Attr]),
    NewHpLim = HpLim + AddedHp,
    BA1 = BA#battle_attr{hp=NewHpLim, hp_lim=NewHpLim, attr=Attr1},
    Mon#scene_object{battle_attr=BA1}.

%% =============================
%% 加入仇恨列表叠加伤害
add_hatred_list(Klist, MonAtter, Hurt)->
    case lists:keyfind(MonAtter#mon_atter.id, #mon_atter.id, Klist) of
        false ->
            [MonAtter#mon_atter{hurt = Hurt}|Klist];
        #mon_atter{hurt = OHurt} ->
            [MonAtter#mon_atter{hurt = Hurt+OHurt}|lists:keydelete(MonAtter#mon_atter.id, #mon_atter.id, Klist)]
    end.

%% =============================
%% 获取boss掉落归属
get_boss_drop_bltype(Mid, MonLv) ->
    case data_drop:get_rule_list(Mid) of
        [] -> skip;
        [DropAlloc|_] when DropAlloc == ?ALLOC_EQUAL -> 0;
        [DropAlloc|_] ->
            case data_drop:get_rule(Mid, DropAlloc, MonLv) of
                [] -> skip;
                #ets_drop_rule{bltype = BlType} ->
                    if
                        BlType == ?DROP_NO_ONE -> skip;
                        true -> BlType
                    end
            end
    end.

%% =============================
%% 计算boss的归属返回一个列表
%% @return {增加归属列表, 去掉归属列表, 归属列表}
calc_boss_bl_who(_Scene, _MonId, ?DROP_FIRST_ATT, OldBLWhos, _Klist, FirstAttr, AssistDataList) ->
    case FirstAttr of
        [] -> {[], OldBLWhos, []};
        _ ->
            BlWhosFirstAttr = get_bl_whos_first_attr(FirstAttr, AssistDataList),
            case lists:keyfind(BlWhosFirstAttr#mon_atter.id, #mon_atter.id, OldBLWhos) of
                false -> {[BlWhosFirstAttr], OldBLWhos, [BlWhosFirstAttr]};
                _ ->  {[], [], OldBLWhos}
            end
    end;
calc_boss_bl_who(Scene, MonId, BlType, OldBLWhos, Klist, _FirstAttr, AssistDataList) ->
    NewKList = combine_hurt_with_same_assist(Klist, AssistDataList),
    NewBLWhos = case lib_goods_drop:calc_max_plist(MonId, Scene, BlType, NewKList) of
                    [[P|_], []] -> [P];
                    [[], TP] -> TP;
                    _ -> []
                end,
    Fun = fun(E, [AL, L]) ->
        case lists:keyfind(E#mon_atter.id, #mon_atter.id, L) of false -> [[E|AL], L]; _ -> [AL, L] end
          end,
    [Adds, _] = lists:foldl(Fun, [[], OldBLWhos], NewBLWhos),
    [Dels, _] = lists:foldl(Fun, [[], NewBLWhos], OldBLWhos),
    {Adds, Dels, NewBLWhos}.

%% =============================
%% 更新场景玩家的归属显示
update_boss_bl_whos(ObjectId, Scene, PoolId, CopyId, X, Y, Adds, Dels) ->
    Fun = fun(#mon_atter{id = BlId, node = Node}, Flag) ->
        {ok, Bin} = pt_120:write(12022, [BlId, Flag]),
        ?IF(Flag == 1, skip, lib_battle:rpc_cast_to_node(Node, lib_server_send, send_to_uid, [BlId, Bin])),
        lib_server_send:send_to_role_area_scene(BlId, Scene, PoolId, CopyId, X, Y, Bin),
        mod_scene_agent:update(Scene, PoolId, BlId, [{bl_who, Flag}, {bl_who_op, {ObjectId, Flag}}]),
        Flag
          end,
    lists:foldl(Fun, 1, Adds),
    lists:foldl(Fun, 0, Dels).

%% =============================
%% 计算协助状态的玩家列表
calc_boss_bl_who_assist(OldBlWhosAssist, _BlWhos, _KList, []) -> {[], [], OldBlWhosAssist};
calc_boss_bl_who_assist(OldBlWhosAssist, BlWhos, KList, _AssistDataList) ->
    F = fun(#mon_atter{id = RoleId, assist_id = AssistId, assist_ex_id = AssistExId}=E, Acc) ->
        case AssistId > 0 andalso AssistExId > 0
            andalso RoleId =/= AssistExId andalso lists:keymember(AssistExId, #mon_atter.id, BlWhos) == true
        of
            true -> [E|Acc]; _ -> Acc
        end
        end,
    NewBlWhosAssist = lists:foldl(F, [], KList),
    Fun = fun(E, [AL, L]) ->
        case lists:keyfind(E#mon_atter.id, #mon_atter.id, L) of false -> [[E|AL], L]; _ -> [AL, L] end
          end,
    [Adds, _] = lists:foldl(Fun, [[], OldBlWhosAssist], NewBlWhosAssist),
    [Dels, _] = lists:foldl(Fun, [[], BlWhos++NewBlWhosAssist], OldBlWhosAssist),
    {Adds, Dels, NewBlWhosAssist}.

%% =============================
%% 更新协助状态的玩家列表
update_boss_bl_whos_assist(ObjectId, Scene, PoolId, CopyId, X, Y, Adds, Dels) ->
    Fun = fun(#mon_atter{id = BlId, node = Node}, Flag) ->
        {ok, Bin} = pt_120:write(12022, [BlId, Flag]),
        ?IF(Flag == 2, skip, lib_battle:rpc_cast_to_node(Node, lib_server_send, send_to_uid, [BlId, Bin])),
        lib_server_send:send_to_role_area_scene(BlId, Scene, PoolId, CopyId, X, Y, Bin),
        mod_scene_agent:update(Scene, PoolId, BlId, [{bl_who, Flag}, {bl_who_op, {ObjectId, Flag}}]),
        Flag
          end,
    lists:foldl(Fun, 2, Adds),
    lists:foldl(Fun, 0, Dels).

%% =============================
%% 同步队伍的归属
sync_team_boss_bl_whos(BlType, BlWhos, Object) when
    BlType == ?DROP_HURT ->
    #scene_object{
        aid = Aid,
        scene = SceneId, scene_pool_id = ScenePoolId, copy_id = CopyId,
        x=ObjectX, y=ObjectY, tracing_distance = TracingDistance
    } = Object,
    case BlWhos of
        [#mon_atter{team_id = TeamId}|_] when TeamId > 0 ->
            RoleIdL = [RoleId||#mon_atter{id = RoleId}<-BlWhos],
            mod_team:cast_to_team(TeamId, {'sync_team_boss_bl_whos', Aid, SceneId, ScenePoolId, CopyId, ObjectX, ObjectY, TracingDistance, RoleIdL});
        _ -> skip
    end;
sync_team_boss_bl_whos(_BlType, _BLWhos, _Object) ->
    skip.

%% =============================
%% 是否需要同步计算归属
check_sync_team_boss_bl_whos(BlType, RoleId, TeamId, BlWhos, Object) when
    BlType == ?DROP_HURT ->
    #scene_object{
        aid = Aid,
        scene = SceneId, scene_pool_id = ScenePoolId, copy_id = CopyId,
        x=ObjectX, y=ObjectY, tracing_distance = TracingDistance
    } = Object,
    % ?MYLOG("hjhteam", "check_sync_team_boss_bl_whos RoleId:~p TeamId:~p ~n", [RoleId, TeamId]),
    case lists:keymember(RoleId, #mon_atter.id, BlWhos) of
        true -> skip;
        false ->
            case BlWhos of
                [#mon_atter{team_id = TeamId}|_]  when TeamId > 0 ->
                    RoleIdL = [TmpRoleId||#mon_atter{id = TmpRoleId}<-BlWhos],
                    mod_team:cast_to_team(TeamId, {'sync_team_boss_bl_whos', Aid, SceneId, ScenePoolId, CopyId, ObjectX, ObjectY, TracingDistance, RoleIdL});
                _ ->
                    skip
            end
    end;
check_sync_team_boss_bl_whos(_BlType, _RoleId, _TeamId, _BLWhos, _Object) ->
    skip.

%% =============================
%% 特定场景采集过程中不允许清理
is_forbid_stop_scene(Scene) ->
    case data_scene:get(Scene) of
        #ets_scene{type = SceneType} ->
            lists:member(SceneType, ?CAN_NOT_STOP_SCENE_WHEN_COLLECT);
        _ ->
            false
    end.

%% =============================
%% 获取归属中第一个攻击者
get_bl_whos_first_attr(MonAttr, []) -> MonAttr;
get_bl_whos_first_attr(MonAttr, AssistDataList) ->
    #mon_atter{id = RoleId, assist_id = AssistId} = MonAttr,
    case lists:keyfind(AssistId, #assist_data.assist_id, AssistDataList) of
        #assist_data{mon_atter = AssistMonAttr} when AssistMonAttr#mon_atter.id =/= RoleId ->
            AssistMonAttr;
        _ -> MonAttr
    end.

%% =============================
%% 获取协助者信息
get_assist_ex_id(_AssistId, []) -> 0;
get_assist_ex_id(AssistId, AssistDataList) ->
    case lists:keyfind(AssistId, #assist_data.assist_id, AssistDataList) of
        #assist_data{mon_atter = #mon_atter{id = RoleId}} ->
            RoleId;
        _ -> 0
    end.

%% =============================
%% 将相同协助id的伤害加在一起后，再去计算归属
combine_hurt_with_same_assist(Klist, []) -> Klist;
combine_hurt_with_same_assist(Klist, AssistDataList) ->
    F = fun(MonAtter, {Acc, NewKlist}) ->
        #mon_atter{assist_id = AssistId, assist_ex_id = AssistExId, hurt = Hurt} = MonAtter,
        case AssistId > 0 andalso AssistExId > 0 of
            true ->
                {_, OldHurt} = ulists:keyfind(AssistId, 1, Acc, {AssistId, 0}),
                {lists:keystore(AssistId, 1, Acc, {AssistId, OldHurt + Hurt}), NewKlist};
            _ ->
                {Acc, [MonAtter|NewKlist]}
        end
        end,
    case lists:foldl(F, {[], []}, Klist) of
        {[], _} -> Klist;
        {List, NewKlist} ->
            F2 = fun({AssistId, AssistAllHurt}, Return) ->
                case lists:keyfind(AssistId, #assist_data.assist_id, AssistDataList) of
                    #assist_data{mon_atter = #mon_atter{id = RoleId}=MonAttr1} ->
                        case lists:keyfind(RoleId, #mon_atter.id, Return) of
                            false ->
                                [MonAttr1#mon_atter{hurt = AssistAllHurt}|Return];
                            MonAtter ->
                                lists:keyreplace(RoleId, #mon_atter.id, Return, MonAtter#mon_atter{hurt = AssistAllHurt})
                        end;
                    _ -> Return
                end
                 end,
            lists:foldl(F2, NewKlist, List)
    end.

%% 是否主动怪
is_active_mon(Mon) -> Mon#scene_object.type == 1.

%% 是否采集怪
is_collect_mon(#mon{kind = Kind}) ->
    is_collect_mon(Kind);
is_collect_mon(#scene_mon{kind = Kind}) ->
    is_collect_mon(Kind);
is_collect_mon(Kind) ->
    lists:member(Kind, [?MON_KIND_COLLECT, ?MON_KIND_TASK_COLLECT, ?MON_KIND_UNDIE_COLLECT, ?MON_KIND_COUNT_COLLECT]).

%% ====================================== Mon About ======================================
create_mon_atter(User) ->
    #ets_scene_user{
        id = RoleId, pid = Pid, node = Node, server_id = ServerId, server_num = ServerNum, team = #status_team{team_id = TeamId},
        figure = #figure{lv = Lv, name = Name, mask_id = MaskId}, world_lv = WorldLv, server_name = ServerName, mod_level = ModLevel, camp_id = Camp
    } = User,
    FirstAttr = #mon_atter{
        id = RoleId, pid = Pid, node = Node, server_id = ServerId, team_id = TeamId, att_sign = ?BATTLE_SIGN_PLAYER,
        att_lv = Lv, name = Name, server_num = ServerNum, world_lv = WorldLv, server_name = ServerName, mod_level = ModLevel,
        camp_id = Camp, mask_id = MaskId
    },
    FirstAttr.