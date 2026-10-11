%% ---------------------------------------------------------------------------
%% @doc 玩家物品buff
%% @author hek
%% @since  2016-09-08
%% @deprecated 本模块提供玩家物品buff计算
%% ---------------------------------------------------------------------------
-module(lib_goods_buff).
-include("buff.hrl").
-include("server.hrl").
-include("attr.hrl").
-include("goods.hrl").
-include("errcode.hrl").
-include("predefine.hrl").
-include("def_fun.hrl").
-include("def_goods.hrl").
-include("def_event.hrl").
-include("rec_event.hrl").
-include("common.hrl").
-include("skill.hrl").
-include_lib("stdlib/include/ms_transform.hrl").
-define(TEMP_KEY(X), {0, X}).
-define(SKILL_KEY(X), {255, X}).

-export([
        use_buff_goods/3,                   %% 使用buff道具
        login/1,                            %% 初始玩家BUFF表
        logout/1,                           %% 玩家下线，移除ets_buff信息
        refresh_buff/0,                     %% 扫描ets，通知玩家进程移除buff
        refresh_player_buff/1,              %% 移除玩家身上过期的buff
        add_goods_buff/4,
        remove_goods_buff_by_type/2,        %% 通过buff类型移除玩家身上的buff
        remove_goods_buff_by_type/3,        %% 通过buff类型移除玩家身上的buff
        check_player_buff/1,                %% 检查玩家buff
        get_exp_buff/1,                     %% 获取经验buff
        get_exp_buff_other/1,               %% 获取其余加经验的buff
        get_module_extra_times/2,           %% 获取某模块次数加成buff
        get_goods_drop_buff/1,              %% 获取物品的掉落加成buff
        get_goods_buff_value/2,             %% 获取物品的buff加成
        get_player_buff/2,                  %% 获取buff
        send_buff_notice/1,                 %% 客户端获取buff列表
        add_buff/4,                         %% 添加buff，不存数据库
        remove_buff/2,                      %% 移除buff，不操作数据库
        add_goods_temp_buff/4,              %% 加临时的显示buff，不存数据库，不加属性，只是展示
        remove_goods_temp_buff/2,           %% 删除临时的显示buff，不操作数据库，不计算属性
        add_skill_buff_to_mul_role/3,
        add_skill_buff/3,                   %% 添加技能buff，不操作数据库
        add_skill_buff/4,                   %% 添加指定类型的技能buff，不操作数据库
        remove_skill_buff/2,                %% 删除技能buff，不操作数据库
        db_remove_goods_buff/1,              %% 直接从数据库移除某种类型Buff
        count_player_attr/1
    ]).

%% 初始玩家BUFF表+功能统计类buff
login(#player_status{id = PlayerId, scene = SceneId, skill = SkillStatus} = PlayerStatus) ->
    NowTime = utime:unixtime(),
    %% 先移除玩家过期的buff
    % 因为经验药水可能有附加的未过期，不再事先删除，而是载入后调用一次refresh
    % db:execute(io_lib:format(?sql_delete_player_expired_buff, [PlayerId, NowTime])),
    Sql = io_lib:format(?sql_select_buff_all, [PlayerId]),
    F = fun(E, PlayerBuff) ->
                case E of
                    [Id, Pid, Type, GoodsId, EffectList, EndTime, Scene]
                      when Type =:= ?BUFF_EXP_KILL_MON orelse EndTime == 0 orelse EndTime > NowTime ->
                        Buff = #ets_buff{
                                  id = Id, pid = Pid, type = Type, goods_id = GoodsId, end_time = EndTime,
                                  effect_list = util:bitstring_to_term(EffectList),
                                  scene = util:bitstring_to_term(Scene)
                                 },
                        save_ets_buff(Buff),
                        store_player_buff(PlayerBuff, Buff);
                    _ -> PlayerBuff
                end
        end,
    {PlayerBuff, BuffAttr}
        = case db:get_all(Sql) of
              BuffList when is_list(BuffList) ->
                  L1 = lists:foldl(F, [], BuffList),
                  L = calc_exp_buff_on_login(L1),
                  {L, get_buff_attr(L, SceneId)};
              _ ->
                  {[], #{}}
          end,
    
    ExpRatio = get_exp_buff(PlayerBuff, 0),
    %% 特殊的技能临时buff:展示
    NewPlayer = case lists:keyfind(?SP_SKILL_KILLING, 1, SkillStatus#status_skill.skill_passive) of
        false -> PlayerStatus#player_status{player_buff = PlayerBuff, buff_attr = BuffAttr, goods_buff_exp_ratio = ExpRatio};
        _ ->
            Ps = PlayerStatus#player_status{player_buff = PlayerBuff, buff_attr = BuffAttr, goods_buff_exp_ratio = ExpRatio},
            add_goods_temp_buff(Ps, ?BUFF_TEAM_SHOW, [{?SPBUFF_REBOUND, 1}], 0)
    end,
    {ok, LastPlayer} = refresh_player_buff(NewPlayer), 
    LastPlayer.

%% 玩家下线，移除ets_buff信息
logout(PlayerStatus) ->
    PlayerBuff = PlayerStatus#player_status.player_buff,
    [delete_ets_buff(Buff) || Buff <- PlayerBuff].

%% 使用buff道具
use_buff_goods(PlayerStatus, GoodsInfo, GoodsNum) ->
    case data_goods:get_effect_val(GoodsInfo#goods.goods_id, buff) of
        [] -> {fail, ?ERRCODE(err150_type_err)};
        BuffArgs -> do_use_buff_goods(PlayerStatus, GoodsInfo, GoodsNum, BuffArgs)
    end.

do_use_buff_goods(PlayerStatus, GoodsInfo, GoodsNum, BuffArgs) ->
    SceneId = PlayerStatus#player_status.scene,
    {_BuffType, _EffectList, _Time, LimitScene} = BuffArgs,
    case LimitScene of
        [] ->
            {ok, NewPlayerStatus} = do_add_goods_buff(PlayerStatus, GoodsInfo#goods.goods_id, GoodsNum, BuffArgs, []),
            %% 派发使用buff物品事件
            CallBackData = #callback_use_buff_goods_data{goods = GoodsInfo},
            lib_player_event:dispatch(NewPlayerStatus, ?EVENT_USE_BUFF_GOODS, CallBackData);
        true ->
            case lists:member(SceneId, LimitScene) of
                false -> {fail, ?ERRCODE(err150_scene_wrong)};
                true ->
                    {ok, NewPlayerStatus} = do_add_goods_buff(PlayerStatus, GoodsInfo#goods.goods_id, GoodsNum, BuffArgs, []),
                    %% 派发使用buff物品事件
                    CallBackData = #callback_use_buff_goods_data{goods = GoodsInfo},
                    lib_player_event:dispatch(NewPlayerStatus, ?EVENT_USE_BUFF_GOODS, CallBackData)
            end
    end.

add_skill_buff_to_mul_role([], _, _) -> ok;
add_skill_buff_to_mul_role([RoleId|L], SkillId, SkillLv) ->
    lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_goods_buff, add_skill_buff, [SkillId, SkillLv]),
    add_skill_buff_to_mul_role(L, SkillId, SkillLv).

%% 为了把需要显示的buff写在一起，不对技能buff另外写一套，统一写在这儿 技能buff不存库
%% 技能id将作为图标buff的类型
add_skill_buff(Ps, SkillId, SkillLv) ->
    add_skill_buff(Ps, SkillId, SkillLv, ?BUFF_SKILL).

add_skill_buff(Ps, SkillId, SkillLv, BuffType) ->
    case lib_skill_buff:skill_buff_to_goods_buff(SkillId, SkillLv) of
        {SkillId, Time, EffectList} ->
            EndTime = if
                Time =:= 0 ->
                    0;
                true ->
                    round(utime:unixtime() + Time / 1000)
            end,
            #player_status{id = PlayerId, player_buff = PlayerBuff, scene = SceneId, buff_attr = OldBuffAttr} = Ps,
            case lib_kf_guild_war_api:is_kf_guild_war_skill(SkillId) of
                true ->
                    KfGWarScene = lib_kf_guild_war_api:get_kf_guild_war_scene(),
                    SceneList = [KfGWarScene];
                _ -> SceneList = []
            end,
            TeamBuff = #ets_buff{id = ?SKILL_KEY(SkillId), pid = PlayerId, type = BuffType, goods_id = SkillId,
                                 end_time = EndTime, effect_list = [{attr, EffectList}], scene = SceneList},
            save_ets_buff(TeamBuff),
            NewPF = store_player_buff(PlayerBuff, TeamBuff),
            BuffAttr = get_buff_attr(NewPF, SceneId),
            ExpRatio = get_exp_buff(NewPF, 0),
            NewPlayerStatus = Ps#player_status{player_buff = NewPF, buff_attr = BuffAttr, goods_buff_exp_ratio = ExpRatio},
            send_buff_notice(PlayerId, SceneId, NewPF),
            case BuffAttr =/= OldBuffAttr of
                true ->
                    count_player_attr(NewPlayerStatus);
                false ->
                    NewPlayerStatus
            end;
        _ ->
            Ps
    end.

remove_skill_buff(RoleId, SkillId) when is_integer(RoleId) ->
    lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_goods_buff, remove_skill_buff, [SkillId]);
remove_skill_buff(Ps, SkillId) ->
    #player_status{id = PlayerId, player_buff = PlayerBuff, scene = SceneId, buff_attr = OldBuffAttr} = Ps,
    Id = ?SKILL_KEY(SkillId),
    case lists:keyfind(Id, #ets_buff.id, PlayerBuff) of
        Buff when is_record(Buff, ets_buff) ->
            NewPF = delete_player_buff(PlayerBuff, Buff),
            ExpRatio = get_exp_buff(NewPF, 0),
            delete_ets_buff(Buff),
            BuffAttr = get_buff_attr(NewPF, SceneId),
            send_buff_notice(PlayerId, SceneId, NewPF),
            NewPlayerStatus = Ps#player_status{player_buff = NewPF, buff_attr = BuffAttr, goods_buff_exp_ratio = ExpRatio},
            case BuffAttr =/= OldBuffAttr of
                true ->
                    count_player_attr(NewPlayerStatus);
                false ->
                    NewPlayerStatus
            end;
        _ ->
            Ps
    end.

%% 添加不存库的buff 如果buff没有战斗属性，推荐使用add_goods_temp_buff
add_buff(Ps, BuffType, EffectList, Time) ->
    #player_status{id = PlayerId, player_buff = PlayerBuff, scene = SceneId, buff_attr = OldBuffAttr} = Ps,
    TeamBuff = #ets_buff{id = ?TEMP_KEY(BuffType), pid = PlayerId, type = BuffType,
                         end_time = Time, effect_list = EffectList},
    save_ets_buff(TeamBuff),
    NewPF = store_player_buff(PlayerBuff, TeamBuff),
    BuffAttr = get_buff_attr(NewPF, SceneId),
    ExpRatio = get_exp_buff(NewPF, 0),
    NewPlayerStatus = Ps#player_status{player_buff = NewPF, buff_attr = BuffAttr, goods_buff_exp_ratio = ExpRatio},
    if
        BuffType =< 16#FF ->
            send_buff_notice(PlayerId, SceneId, NewPF);
        true -> ok
    end,
    case BuffAttr =/= OldBuffAttr of
        true ->
            count_player_attr(NewPlayerStatus);
        false ->
            NewPlayerStatus
    end.

%% 移除不存库的buff
remove_buff(Ps, BuffType) ->
    #player_status{player_buff = PlayerBuff, id = PlayerId, buff_attr = OldBuffAttr, scene = SceneId} = Ps,
    case get_player_buff(PlayerBuff, BuffType) of
        false -> Ps;
        Buff ->
            NewPF = delete_player_buff(PlayerBuff, Buff),
            ExpRatio = get_exp_buff(NewPF, 0),
            delete_ets_buff(Buff),
            BuffAttr = get_buff_attr(NewPF, SceneId),
            if
                BuffType =< 16#FF ->
                    send_buff_notice(PlayerId, SceneId, NewPF);
                true -> ok
            end,
            NewPlayerStatus = Ps#player_status{player_buff = NewPF, buff_attr = BuffAttr, goods_buff_exp_ratio = ExpRatio},
            case BuffAttr =/= OldBuffAttr of
                true ->
                    count_player_attr(NewPlayerStatus);
                false ->
                    NewPlayerStatus
            end
    end.

%% 加临时的显示buff，不存数据库，不加战斗属性，经验加成生效 如果已经加的buff没有战斗属性，使用这个比add_buff好
add_goods_temp_buff(Ps, BuffType, EffectList, Time)->
    #player_status{id = PlayerId, player_buff = PlayerBuff, scene = SceneId} = Ps,
    TeamBuff = #ets_buff{id = ?TEMP_KEY(BuffType), pid = PlayerId, type = BuffType,
                         end_time = Time, effect_list = EffectList},
    save_ets_buff(TeamBuff),
    NewPF = store_player_buff(PlayerBuff, TeamBuff),
    ExpRatio = get_exp_buff(NewPF, 0),
    if
        BuffType =< 16#FF ->
            send_buff_notice(PlayerId, SceneId, NewPF);
        true -> ok
    end,
    Ps#player_status{player_buff = NewPF, goods_buff_exp_ratio = ExpRatio}.

%% 删除临时显示buff
remove_goods_temp_buff(Ps, BuffType)->
    #player_status{id = PlayerId, player_buff = PlayerBuff, scene = SceneId} = Ps,
    case get_player_buff(PlayerBuff, BuffType) of
        false -> Ps;
        Buff ->
            NewPF = delete_player_buff(PlayerBuff, Buff),
            delete_ets_buff(Buff),
            ExpRatio = get_exp_buff(NewPF, 0),
            if
                BuffType =< 16#FF ->
                    send_buff_notice(PlayerId, SceneId, NewPF);
                true -> ok
            end,
            Ps#player_status{player_buff = NewPF, goods_buff_exp_ratio = ExpRatio}
    end.

%% 直接给玩家加上某个物品的buff 不用消耗物品
add_goods_buff(PlayerId, GoodsTypeId, GoodsNum, KeyValList) when is_integer(PlayerId) andalso PlayerId > 0 ->
    lib_player:apply_cast(PlayerId, ?APPLY_CAST_SAVE, lib_goods_buff, add_goods_buff, [GoodsTypeId, GoodsNum, KeyValList]);

add_goods_buff(PlayerStatus, GoodsTypeId, GoodsNum, KeyValList) when is_record(PlayerStatus, player_status) ->
    case data_goods:get_effect_val(GoodsTypeId, buff) of
        [] -> {ok, PlayerStatus};
        BuffArgs ->
            do_add_goods_buff(PlayerStatus, GoodsTypeId, GoodsNum, BuffArgs, KeyValList)
    end.

do_add_goods_buff(PlayerStatus, GoodsTypeId, GoodsNum, {BuffType, EffectList, Time, LimitScene}, KeyValList) ->
    #player_status{id = PlayerId, scene = SceneId, player_buff = PlayerBuff, buff_attr = OldBuffAttr} = PlayerStatus,
    %% 后台配置buff有效时间为0永久buff 已经有了不用重复添加 需代码里面手动移除改buff
    case Time == 0 of
        true ->
            Duration = 0,
            EndTime = 0;
        false ->
            Duration = Time * GoodsNum,
            EndTime = Duration + utime:unixtime()
    end,
    %% 外部设置buff的结束时间和属性
    case lists:keyfind(etime, 1, KeyValList) of
        {etime, EtimeArgs} ->
            RealEtime = EtimeArgs;
        _ -> RealEtime = EndTime
    end,
    case lists:keyfind(effect_list, 1, KeyValList) of
        {effect_list, EffectListArgs} ->
            RealEffectList = EffectListArgs;
        _ -> RealEffectList = EffectList
    end,
    case get_player_buff(PlayerBuff, BuffType) of
        false ->
            {NewBuff, NewPlayerBuff} = add_player_buff(PlayerBuff, PlayerId, BuffType, GoodsTypeId, RealEffectList, RealEtime, LimitScene);
        _ when RealEtime == 0 -> %% 如果后台配置的是手动移除类型buff不需要重复添加！！！
            NewBuff = false, NewPlayerBuff = PlayerBuff;
        #ets_buff{} = Buff when BuffType =:= ?BUFF_EXP_KILL_MON ->
            {NewBuff, NewPlayerBuff} = exp_mod_buff(PlayerBuff, Buff, GoodsTypeId, RealEffectList, RealEtime, LimitScene);
        #ets_buff{goods_id = OldGoodsTypeId, end_time = OldEndTime} = Buff when OldGoodsTypeId == GoodsTypeId andalso RealEtime =/= 0 -> %% 同类型同效果
            {NewBuff, NewPlayerBuff} = mod_buff(PlayerBuff, Buff, GoodsTypeId, RealEffectList, OldEndTime + Duration, LimitScene);
        #ets_buff{} = _Buff when BuffType == ?BUFF_FIESTA -> % 特殊类型buff,可存在多个祭典buff
            {NewBuff, NewPlayerBuff} = add_player_buff(PlayerBuff, PlayerId, BuffType, GoodsTypeId, EffectList, RealEtime, LimitScene);        
        Buff when Time =/= 0 -> % 更新同类型buff
            {NewBuff, NewPlayerBuff} = mod_buff(PlayerBuff, Buff, GoodsTypeId, RealEffectList, RealEtime, LimitScene);
        _ -> NewBuff = false, NewPlayerBuff = PlayerBuff
    end,
    case is_record(NewBuff, ets_buff) of
        true ->
            save_ets_buff(NewBuff),
            BuffAttr = get_buff_attr(NewPlayerBuff, SceneId),
            ExpRatio = get_exp_buff(NewPlayerBuff, 0),
            NewPlayerStatus = PlayerStatus#player_status{player_buff = NewPlayerBuff, buff_attr = BuffAttr, goods_buff_exp_ratio = ExpRatio},
            send_buff_notice(PlayerId, SceneId, NewPlayerBuff),
            case BuffAttr =/= OldBuffAttr of
                true ->
                    LastPlayerStatus = count_player_attr(NewPlayerStatus);
                false ->
                    LastPlayerStatus = NewPlayerStatus
            end,
            case data_goods_effect:get(GoodsTypeId) of
                #goods_effect{
                   limit_type = LimitType,
                   counter_module = CounterModule,
                   counter_id = CounterId
                  } when LimitType =/= 0 ->
                    lib_goods_util:plus_counter(PlayerId, CounterModule, CounterId, LimitType, GoodsNum);
                _ -> skip
            end,
            %%  通知主线副本exp buff更新
            OnhookStatus = case BuffType of
                ?BUFF_EXP_KILL_MON ->
                    % BuffRatio = case lists:keyfind(?BUFF_EFFECT_EXP_KILL_MON, 1, NewBuff#ets_buff.effect_list) of
                    %     false -> 0;
                    %     {_, Ratio} -> round(Ratio * 100)
                    % end,
                    % %% 暂时不考虑多个的经验buff的问题
                    % lib_onhook:add_goods_exp_buff(LastPlayerStatus, BuffRatio, NewBuff#ets_buff.end_time);
                    LastPlayerStatus;
                _ ->
                    LastPlayerStatus
            end,
            DungeonStatus = lib_dungeon:add_goods_buff(OnhookStatus, BuffType),
            {ok, DungeonStatus};
        _ -> {ok, PlayerStatus}
    end.

%% 移除玩家某个类型的Buff
remove_goods_buff_by_type(PlayerId, BuffType, HandleOffline) when is_integer(PlayerId) andalso PlayerId > 0 ->
    Pid = misc:get_player_process(PlayerId),
    case misc:is_process_alive(Pid) of
        true ->
            lib_player:apply_cast(PlayerId, ?APPLY_CAST_SAVE, lib_goods_buff, remove_goods_buff_by_type, [BuffType]);
        _  when HandleOffline == ?HAND_OFFLINE ->
            %% 玩家不在线直接删除数据库
            db:execute(io_lib:format(?sql_delete_player_buff_by_type, [PlayerId, BuffType]));
        _ ->
            skip
    end;
remove_goods_buff_by_type(_, _, _) -> skip.

remove_goods_buff_by_type(PlayerStatus, BuffType) when is_record(PlayerStatus, player_status) ->
    #player_status{id = PlayerId, scene = SceneId, player_buff = PlayerBuff, buff_attr = OldBuffAttr} = PlayerStatus,
    case get_player_buff(PlayerBuff, BuffType) of
        Buff when is_record(Buff, ets_buff) ->
            db:execute(io_lib:format(?sql_delete_player_buff_by_type, [PlayerId, BuffType])),
            F = fun(T, Acc) ->
                        case T of
                            #ets_buff{
                               type = BuffType
                              } = BuffInfo ->
                                delete_ets_buff(BuffInfo),
                                delete_player_buff(Acc, BuffInfo);
                            _ -> Acc
                        end
                end,
            NewPlayerBuff = lists:foldl(F, PlayerBuff, PlayerBuff),
            send_buff_notice(PlayerId, SceneId, NewPlayerBuff),
            BuffAttr = get_buff_attr(NewPlayerBuff, SceneId),
            ExpRatio = get_exp_buff(NewPlayerBuff, 0),
            NewPlayerStatus = PlayerStatus#player_status{player_buff = NewPlayerBuff, buff_attr = BuffAttr, goods_buff_exp_ratio = ExpRatio},
            case BuffAttr =/= OldBuffAttr of
                true ->
                    count_player_attr(NewPlayerStatus);
                false ->
                    NewPlayerStatus
            end;
        _ -> PlayerStatus
    end.

%% 直接从数据库移除某种类型的buff
db_remove_goods_buff(BuffType) ->
    db:execute(io_lib:format(?sql_delete_buff_by_type, [BuffType])).

%% 取玩家BUFF属性
get_buff_attr(PlayerBuff, SceneId) ->
    NowTime = utime:unixtime(),
    F = fun(Buff, AttrMaps) ->
                #ets_buff{scene = SceneList, end_time = EndTime, effect_list = EffectList} = Buff,
                VaildScene = ?IF(SceneList == [] orelse lists:member(SceneId, SceneList), true, false),
                IsExpired = ?IF(EndTime > 0 andalso NowTime >= EndTime, true, false),
                case VaildScene andalso not IsExpired of
                    true ->
                        case lists:keyfind(attr, 1, EffectList) of
                            {attr, Attr} ->
                                lib_player_attr:list_add_to_attr(Attr, AttrMaps);
                            _ -> AttrMaps
                        end;
                    false -> AttrMaps
                end
        end,
    lists:foldl(F, #{}, PlayerBuff).

%% 扫描ets，通知玩家进程移除buff
%% 定时器进程调用
refresh_buff() ->
    NowTime = utime:unixtime(),
    %% 查找有过期buff的玩家进程
    MatchSpec = ets:fun2ms(fun(#ets_buff{pid = _Pid, end_time = EndTime} = Buff) when EndTime > 0 andalso NowTime >= EndTime -> Buff end),
    RefreshList = ets:select(?ETS_BUFF, MatchSpec),
    IdList = util:ulist([Pid || #ets_buff{pid = Pid} <- RefreshList]),
    do_batch(IdList, fun do_refresh_buff/1, 1, {10, 200}).

do_refresh_buff(PlayerId) ->
    lib_player:apply_cast(PlayerId, ?APPLY_CAST_SAVE, lib_goods_buff, refresh_player_buff, []).

%% 移除玩家身上过期的buff
refresh_player_buff(PlayerStatus) ->
    NowTime = utime:unixtime(),
    #player_status{id = PlayerId, scene = SceneId, player_buff = PlayerBuff, buff_attr = OldBuffAttr} = PlayerStatus,
    F = fun(#ets_buff{type = Type, end_time = EndTime} = BuffInfo, {NeedBrodcast, Acc}) when EndTime > 0 andalso EndTime < NowTime ->
                % 经验药水特殊处理
                case Type of 
                    ?BUFF_EXP_KILL_MON ->
                        refresh_exp_buff(BuffInfo, Acc, PlayerStatus);
                    _ ->
                        delete_ets_buff(BuffInfo),
                        NewPlayerBuff = delete_player_buff(Acc, BuffInfo), 
                        {NeedBrodcast, NewPlayerBuff}
                end;
           (_BuffInfo, Acc) -> Acc
        end,
    {NeedBrodcast, NewPlayerBuff} = lists:foldl(F, {false, PlayerBuff}, PlayerBuff),
    %% 移除玩家过期的buff
    db:execute(io_lib:format(?sql_delete_player_expired_buff, [PlayerId, NowTime])),
    ExpRatio = get_exp_buff(NewPlayerBuff, 0),
    send_buff_notice(PlayerId, SceneId, NewPlayerBuff),
    BuffAttr = get_buff_attr(NewPlayerBuff, SceneId),
    NewPlayerStatus = PlayerStatus#player_status{player_buff = NewPlayerBuff, buff_attr = BuffAttr, goods_buff_exp_ratio = ExpRatio},
    % 有改变的buff要通知
    NeedBrodcast andalso send_buff_notice(NewPlayerStatus),
    % lib_onhook:del_goods_exp_buff(NewPlayerStatus),
    case BuffAttr =/= OldBuffAttr of
        true ->
            CountAttrPS = count_player_attr(NewPlayerStatus),
            {ok, LastPlayerStatus} = lib_player_event:dispatch(CountAttrPS, ?EVENT_REFRESH_BUFF);
        false ->
            LastPlayerStatus = NewPlayerStatus
    end,
    {ok, LastPlayerStatus}.

do_batch([], _F, _Index, {_SleepNum, _SleepTime}) -> ok;
do_batch([Args|T], F, Index, {SleepNum, SleepTime}) ->
    case Index of
        SleepNum ->
            timer:sleep(SleepTime),
            NewIndex = 1;
        _ ->
            NewIndex = Index + 1
    end,
    F(Args),
    do_batch(T, F, NewIndex, {SleepNum, SleepTime}).

%% 检查玩家BUFF
check_player_buff(PlayerStatus) ->
    #player_status{id = PlayerId, scene = SceneId, player_buff = PlayerBuff, buff_attr = OldBuffAttr} = PlayerStatus,
    case PlayerBuff of
        [] ->
            {ok, PlayerStatus};
        BuffList ->
            NowTime = utime:unixtime(),
            NewBuffList = [BuffInfo || BuffInfo <- BuffList, BuffInfo#ets_buff.end_time > NowTime orelse BuffInfo#ets_buff.end_time == 0,
                                       BuffInfo#ets_buff.scene =:= [] orelse lists:member(SceneId, BuffInfo#ets_buff.scene)],
            send_buff_notice(PlayerId, SceneId, NewBuffList),
            %% 属性变化
            BuffAttr = get_buff_attr(NewBuffList, SceneId),
            NewPlayerStatus = PlayerStatus#player_status{buff_attr = BuffAttr},
            case BuffAttr =/= OldBuffAttr of
                true ->
                    LastPlayerStatus = count_player_attr(NewPlayerStatus);
                false ->
                    LastPlayerStatus = NewPlayerStatus
            end,
            {ok, LastPlayerStatus}
    end.

count_player_attr(PlayerStatus) ->
    LastPlayerStatus = lib_player:count_player_attribute(PlayerStatus),
    lib_player:send_attribute_change_notify(LastPlayerStatus, ?NOTIFY_ATTR),
    mod_scene_agent:update(LastPlayerStatus, [{battle_attr, LastPlayerStatus#player_status.battle_attr}]),
    LastPlayerStatus.

%% 获取经验buff(经验加成符+特殊物品的加成)
get_exp_buff(PS) ->
     #player_status{player_buff = PlayerBuff} = PS,
     get_exp_buff(PlayerBuff, 0).

get_exp_buff([], Acc) -> Acc;

get_exp_buff([#ets_buff{type = ?BUFF_EXP_KILL_MON, effect_list = EffectList}|PlayerBuff], Acc) ->
    case lists:keyfind(?BUFF_EFFECT_EXP_KILL_MON, 1, EffectList) of
        {_, Value} ->
            get_exp_buff(PlayerBuff, Acc + Value);
        _ ->
            get_exp_buff(PlayerBuff, Acc)
    end;

get_exp_buff([#ets_buff{effect_list = EffectList}|PlayerBuff], Acc) ->
    case lists:keyfind(attr, 1, EffectList) of
        {_, AttrList} ->
            case lists:keyfind(?EXP_ADD, 1, AttrList) of
                {_, Value} ->
                    get_exp_buff(PlayerBuff, Acc + Value/?RATIO_COEFFICIENT);
                _ ->
                    get_exp_buff(PlayerBuff, Acc)
            end;
        _ ->
            get_exp_buff(PlayerBuff, Acc)
    end.

%% 获取经验buff(特殊物品的加成，不包括经验符)
get_exp_buff_other(PS) ->
    #player_status{player_buff = PlayerBuff} = PS,
    get_exp_buff_other(PlayerBuff, 0).

get_exp_buff_other([], Acc) -> Acc;
get_exp_buff_other([#ets_buff{effect_list = EffectList}|PlayerBuff], Acc) ->
    case lists:keyfind(attr, 1, EffectList) of
        {_, AttrList} ->
            case lists:keyfind(?EXP_ADD, 1, AttrList) of
                {_, Value} ->
                    get_exp_buff_other(PlayerBuff, Acc + Value/?RATIO_COEFFICIENT);
                _ ->
                    get_exp_buff_other(PlayerBuff, Acc)
            end;
        _ ->
            get_exp_buff_other(PlayerBuff, Acc)
    end.

%% 获取某模块次数加成buff
%% @param ModuleInfo :: {ModuleId, SubModuleId}
get_module_extra_times(PS, ModuleInfo) ->
    #player_status{player_buff = PlayerBuff} = PS,
    get_module_extra_times(PlayerBuff, ModuleInfo, 0).

get_module_extra_times([], _, Acc) -> Acc;
get_module_extra_times([#ets_buff{effect_list = EffectList} | PlayerBuff], ModuleInfo, Acc) ->
    case lists:keyfind(mod_times, 1, EffectList) of
        {_, ModuleInfo, TimesAdd} ->
            get_module_extra_times(PlayerBuff, ModuleInfo, Acc + TimesAdd);
        _ ->
            get_module_extra_times(PlayerBuff, ModuleInfo, Acc)
    end.

get_goods_drop_buff(PS)->
    Buff1 = get_player_buff(PS#player_status.player_buff, ?BUFF_DROP_KILL_MON),
    BuffExpMon = ?IF(Buff1==false, #ets_buff{}, Buff1),
    Value1 = exp_buff_helper(BuffExpMon#ets_buff.effect_list, 0),
    Value1.

get_goods_buff_value(PS, BuffType)->
    Buff1 = get_player_buff(PS#player_status.player_buff, BuffType),
    BuffExpMon = ?IF(Buff1==false, #ets_buff{}, Buff1),
    Value1 = exp_buff_helper(BuffExpMon#ets_buff.effect_list, 0),
    Value1.


exp_buff_helper([], Value) -> Value;
exp_buff_helper([{?BUFF_EFFECT_EXP_KILL_MON, Value}|T], Acc) ->
    exp_buff_helper(T, Value + Acc);
exp_buff_helper([{?BUFF_EFFECT_DROP_KILL_MON, Value}|T], Acc) ->
    exp_buff_helper(T, Value + Acc);
exp_buff_helper([{?BUFF_EFFECT_ZEN_SOUL_WORLD_BOSS, Value}|T], Acc) ->
    exp_buff_helper(T, Value + Acc);
exp_buff_helper([{_Key, _Value}|T], Acc) ->
    exp_buff_helper(T, Acc).



%% 添加BUFF状态
add_player_buff(PlayerBuff, PlayerId, Type, GoodsTypeId, EffectList, EndTime, Scene) ->
    F = fun() ->
                Sql = io_lib:format(?sql_insert_buff, [PlayerId, Type, GoodsTypeId, util:term_to_string(EffectList), EndTime, util:term_to_string(Scene)]),
                db:execute(Sql),
                Sql1 = io_lib:format(?sql_select_buff_last_id, [PlayerId, Type]),
                LastId = lists:max(lists:flatten(db:get_all(Sql1))),
                {ok, LastId}
        end,
    case catch db:transaction(F) of
        {ok, LastId} ->
            NewBuffInfo = #ets_buff{id = LastId, pid = PlayerId, type = Type, goods_id = GoodsTypeId, effect_list = EffectList, end_time = EndTime, scene = Scene},
            NewPlayerBuff = store_player_buff(PlayerBuff, NewBuffInfo),
            {NewBuffInfo, NewPlayerBuff};
        _Err ->
            ?ERR("add_player_buff err:~p", [_Err]),
            {false, PlayerBuff}
    end.

%% 修改BUFF状态
mod_buff(PlayerBuff, BuffInfo, GoodsTypeId, EffectList, EndTime, Scene) ->
    Sql = io_lib:format(?sql_update_buff, [GoodsTypeId, util:term_to_string(EffectList), EndTime, util:term_to_string(Scene), BuffInfo#ets_buff.id]),
    db:execute(Sql),
    NewBuffInfo = BuffInfo#ets_buff{goods_id = GoodsTypeId, effect_list = EffectList, end_time = EndTime, scene = Scene},
    NewPlayerBuff = store_player_buff(PlayerBuff, NewBuffInfo),
    {NewBuffInfo, NewPlayerBuff}.

%% 经验药水修改buff状态
exp_mod_buff(PlayerBuff, BuffInfo, GoodsTypeId, EffectList, EndTime, Scene) -> 
    #ets_buff{effect_list = OldEffects, end_time = OldEndTime, scene = OldScene, goods_id = OldGoodsTypeId} = BuffInfo, 
    {_, AddExpRatio} = ulists:keyfind(?BUFF_EFFECT_EXP_KILL_MON, 1, EffectList, {?BUFF_EFFECT_EXP_KILL_MON, 0}), 
    {_, ExpRatio} = ulists:keyfind(?BUFF_EFFECT_EXP_KILL_MON, 1, OldEffects, {?BUFF_EFFECT_EXP_KILL_MON, 0}), 
    {_, Remains} = ulists:keyfind(?BUFF_EFFECT_EXP_STOP, 1, OldEffects, {?BUFF_EFFECT_EXP_STOP, []}), 
    AddTime = EndTime - utime:unixtime(), 
    if 
        AddExpRatio =:= ExpRatio -> 
            mod_buff(PlayerBuff, BuffInfo, GoodsTypeId, OldEffects, OldEndTime + AddTime, Scene);
        AddExpRatio > ExpRatio ->  
            % 使用了比现在更高级的药水, 则暂停当前的，启用新的效果
            NewRemains = lists:keystore(ExpRatio, 1, Remains, {ExpRatio, OldGoodsTypeId, OldEndTime - utime:unixtime(), OldScene}), 
            NewEffects1 = lists:keystore(?BUFF_EFFECT_EXP_KILL_MON, 1, OldEffects, {?BUFF_EFFECT_EXP_KILL_MON, AddExpRatio}),
            NewEffects = lists:keystore(?BUFF_EFFECT_EXP_STOP, 1, NewEffects1, {?BUFF_EFFECT_EXP_STOP, NewRemains}), 
            mod_buff(PlayerBuff, BuffInfo, GoodsTypeId, NewEffects, EndTime, Scene);
        true -> 
            % 使用了比现在低级的药水
            {_, OldLowGoodsType, OldLowLastTime, _} = ulists:keyfind(AddExpRatio, 1, Remains, {AddExpRatio, GoodsTypeId, 0, []}), 
            NewRemains = lists:keystore(AddExpRatio, 1, Remains, {AddExpRatio, OldLowGoodsType, OldLowLastTime + AddTime, Scene}),
            NewEffects = lists:keystore(?BUFF_EFFECT_EXP_STOP, 1, OldEffects, {?BUFF_EFFECT_EXP_STOP,NewRemains}),
            mod_buff(PlayerBuff, BuffInfo, OldGoodsTypeId, NewEffects, OldEndTime, OldScene)
    end.

%% 登录时计算经验药水的时效
calc_exp_buff_on_login(PlayerBuff) -> 
    ExpBuff = ulists:keyfind(?BUFF_EXP_KILL_MON, #ets_buff.type, PlayerBuff, []),  
    AfterDelPlayerBuff = lists:keydelete(?BUFF_EXP_KILL_MON, #ets_buff.type, PlayerBuff),
    _NewPlayerBuff =
        case calc_exp_buff(ExpBuff) of
            [] -> AfterDelPlayerBuff;
            NewBuffInfo ->
                #ets_buff{effect_list = NewEffects, end_time = NewEndTime, scene = NewScene, goods_id = GoodsTypeId, id = NewId} = NewBuffInfo,
                Sql = io_lib:format(?sql_update_buff, [GoodsTypeId, util:term_to_string(NewEffects), NewEndTime, util:term_to_string(NewScene), NewId]),
                db:execute(Sql),
                [NewBuffInfo | AfterDelPlayerBuff]
        end.

calc_exp_buff([]) -> [];
calc_exp_buff(BuffInfo) ->
    #ets_buff{effect_list = Effects, end_time = OldEndTime, pid = Pid, id = Id} = BuffInfo,
    NowTime = utime:unixtime(), 
    F = fun({ExpRatio, GoodsTypeId, RemainTime, Scenes},{LastEndTime, Res, AfterEffects, IsEnd}) ->
        case IsEnd of 
            true -> {LastEndTime, Res, AfterEffects, IsEnd};
            _ ->
                {_, Remains} = ulists:keyfind(?BUFF_EFFECT_EXP_STOP, 1, AfterEffects, {?BUFF_EFFECT_EXP_STOP, []}), 
                NewRemains = lists:keydelete(ExpRatio, 1, Remains),
                NewEffects1 = lists:keystore(?BUFF_EFFECT_EXP_STOP, 1, AfterEffects, {?BUFF_EFFECT_EXP_STOP, NewRemains}), 
                case LastEndTime + RemainTime > NowTime of 
                    true -> 
                        % 没有过期
                        NewEffects = lists:keystore(?BUFF_EFFECT_EXP_KILL_MON, 1, NewEffects1, {?BUFF_EFFECT_EXP_KILL_MON, ExpRatio}), 
                        NewRes = #ets_buff{id = Id, pid = Pid, type = ?BUFF_EXP_KILL_MON, goods_id = GoodsTypeId, effect_list = NewEffects, end_time = LastEndTime + RemainTime, scene = Scenes}, 
                        {LastEndTime + RemainTime, NewRes, NewEffects, true};
                    false -> 
                        % 过期处理
                        {LastEndTime + RemainTime, Res, NewEffects1, false} 
                end 
        end
    end, 
         
    case NowTime < OldEndTime of 
        true -> BuffInfo;
        _ -> 
            {_, Remains} = ulists:keyfind(?BUFF_EFFECT_EXP_STOP, 1, Effects, {?BUFF_EFFECT_EXP_STOP, []}), 
            SortedRemains = lists:reverse(lists:keysort(1, Remains)),     
            {_, NewBuffInfo, _, _}  = lists:foldl(F, {OldEndTime, [], Effects, false}, SortedRemains),
            NewBuffInfo
    end.

%% 经验药水清理
%% Ret: {bool, NewPlayerBuff} {是否有新增buff, 新的PlayerBuff状态}
refresh_exp_buff(BuffInfo, Acc, Player) ->
    #player_status{player_buff = PlayerBuff} = Player,
    #ets_buff{effect_list = Effects} = BuffInfo, 
    {_, Remains} = ulists:keyfind(?BUFF_EFFECT_EXP_STOP, 1, Effects, {?BUFF_EFFECT_EXP_STOP, []}), 
    case Remains =:= [] of 
        true -> 
            delete_ets_buff(BuffInfo),
            NewPlayerBuff = delete_player_buff(Acc, BuffInfo), 
            {false, NewPlayerBuff};
        _ -> 
            [{ExpRatio, GoodsTypeId, RemainTime, Scene} | _] = lists:reverse(lists:keysort(1, Remains)), 
            NewRemains = lists:keydelete(ExpRatio, 1, Remains), 
            NewEffects1 = lists:keystore(?BUFF_EFFECT_EXP_STOP, 1, Effects, {?BUFF_EFFECT_EXP_STOP, NewRemains}), 
            NewEffects = lists:keystore(?BUFF_EFFECT_EXP_KILL_MON, 1, NewEffects1, {?BUFF_EFFECT_EXP_KILL_MON, ExpRatio}), 
            EndTime = utime:unixtime() + RemainTime, 
            % 将状态加回来
            {_, NewPlayerBuff} = mod_buff(PlayerBuff, BuffInfo, GoodsTypeId, NewEffects, EndTime, Scene),
            % 发送经验buff改变通知
            {true, NewPlayerBuff}
    end. 


%% ------------------------- local function -------------------------
get_player_buff(PlayerBuff, BuffType) ->
    lists:keyfind(BuffType, #ets_buff.type, PlayerBuff).

store_player_buff(PlayerBuff, BuffInfo) ->
    lists:keystore(BuffInfo#ets_buff.id, #ets_buff.id, PlayerBuff, BuffInfo).

delete_player_buff(PlayerBuff, BuffInfo) ->
    lists:keydelete(BuffInfo#ets_buff.id, #ets_buff.id, PlayerBuff).

save_ets_buff(NewBuff) ->
    ets:insert(?ETS_BUFF, NewBuff).

delete_ets_buff(NewBuff) ->
    ets:delete(?ETS_BUFF, NewBuff#ets_buff.id).

%% 客户端请求和发送BUFF状态通知
send_buff_notice(PlayerStatus) ->
    #player_status{id = RoleId, scene = SceneId, player_buff = PlayerBuff} = PlayerStatus,
    send_buff_notice(RoleId, SceneId, PlayerBuff).

%% 除了物品buff外的，其他功能的显示
send_buff_notice(RoleId, SceneId, PlayerBuff) ->
    NowTime  = utime:unixtime(),
    F = fun(BuffInfo, Acc) ->
        #ets_buff{
           goods_id = GoodsTypeId,
           type = BuffType,
           end_time = EndTime,
           effect_list = EffectList,
           scene = LimitScene
        } = BuffInfo,
        case BuffType =:= ?BUFF_EXP_KILL_MON andalso EndTime < NowTime of 
            % 经验卡过期通知
            true -> do_refresh_buff(RoleId);
            _ -> skip 
        end, 
        case (BuffType =:= ?BUFF_EXP_KILL_MON orelse EndTime == 0 orelse EndTime > NowTime) of
            true ->
                case data_goods_effect:get(GoodsTypeId) of
                    #goods_effect{
                       time = SingleTime,
                       limit_scene = CfgLimitScene
                    } ->
                        case BuffType =< 16#FF andalso (CfgLimitScene == [] orelse lists:member(SceneId, CfgLimitScene)) of
                            true ->
                                LeftTime = max(EndTime - NowTime, 0),
                                [{GoodsTypeId, BuffType, util:term_to_string(EffectList), LeftTime, SingleTime}| Acc];
                            false -> Acc
                        end;
                    _ when BuffType =< 16#FF ->
                        case LimitScene == [] orelse lists:member(SceneId, LimitScene) of
                            true ->
                                LeftTime = max(EndTime - NowTime, 0),
                                [{GoodsTypeId, BuffType, util:term_to_string(EffectList), LeftTime, 0}| Acc];
                            _ ->
                                Acc
                        end;
                    _ ->
                        Acc
                end;
            _ -> Acc
        end
    end,
    PackList = lists:foldl(F, [], PlayerBuff),
    {ok, BinData} = pt_150:write(15055, [RoleId, PackList]),
    lib_server_send:send_to_uid(RoleId, BinData).
