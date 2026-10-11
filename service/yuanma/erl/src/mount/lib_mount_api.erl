%% ---------------------------------------------------------------------------
%% @doc lib_mount_api.erl

%% @author  lzh
%% @email  lu13824949032@gmail.com
%% @since  2019-09-04
%% @deprecated 
%% ---------------------------------------------------------------------------
-module(lib_mount_api).

-include("server.hrl").
-include("figure.hrl").
-include("common.hrl").
-include("mount.hrl").
-include("def_module.hrl").
-include("skill.hrl").
-include("def_fun.hrl").
-include("predefine.hrl").
-include("login.hrl").

-export ([
    cancel_swing/1
    ,cancel_illusion/2
    ,illusion_default/2
    ,active_mount_api/3             %% 培养系统激活
    ,power_change_event/2           %% 战力改变
    ,star_or_stage_change_event/4   %% 培养系统升阶/升级（非幻化）
    ,active_mount_figure_event/4    %% 激活幻化
    ,figure_stage_star_change/6     %% 幻化升级/升阶
    ,figure_color_lv_up/3           %% 染色剂使用
    ,other_mod_add_attr/4           %% 其他模块属性加成
    , get_mount_active_cnt/2        %% 获取已激活数量
    , get_mount_active_id_list/2    %% 获取已激活id列表
    , talent_skill_update/3         %% 天赋技能更新
    , reset_talent/1                %% 天赋技能重置
]).

-export([
    del_bag_num/4,
    gm_delete_used_goods_online/4,
    gm_refresh_win_rank/1,
    gm_refresh_win_rank/2,
    do_del_bag_num/4
]).

%==================================================================================
%% 通用接口
%==================================================================================
%% 当背饰幻化之后会调用该函数
%% 幻化翅膀成默认状态
%% 暂时模拟调用 翅膀取消幻化 的协议
cancel_swing(Player) ->
	% case pp_mount:handle(16003,Player, [3, 1, 1]) of
	% 	{ok, NewPlayer} ->  NewPlayer;
	% 	_ -> Player
	% end.
	case lib_mount:cancel_wing(Player) of 
		{ok, NewPlayer} -> NewPlayer;
		_ -> Player
	end.

%% 取消幻型
cancel_illusion(Player, TypeId) ->
    #player_status{status_mount = StatusMount} = Player,
    case lists:keyfind(TypeId, #status_mount.type_id, StatusMount) of
        #status_mount{
            type_id = TypeId, stage = Stage,
            illusion_type = IllusionType, illusion_id = IllusionId
        } ->
            %% 获取当前正在穿戴的状态
            Args = ?IF(IllusionType == ?BASE_MOUNT_FIGURE, [TypeId, IllusionType, Stage, 0], [TypeId, IllusionType, IllusionId, 0]),
            %% 卸下当前的幻型
            case pp_mount:handle(16003, Player, Args) of
                {ok, LastPlayer} -> skip;
                _ -> LastPlayer = Player
            end;
        _ -> LastPlayer = Player
    end,
    ?PRINT("============== ~p ~n", [LastPlayer#player_status.figure#figure.mount_figure]),
    {ok, LastPlayer}.
%% 激活成默认的幻型状态
illusion_default(Player, TypeId) ->
    #player_status{status_mount = StatusMount} = Player,
    case lists:keyfind(TypeId, #status_mount.type_id, StatusMount) of
        #status_mount{
            type_id = TypeId, stage = Stage
        } ->
            Args = [TypeId, ?BASE_MOUNT_FIGURE, Stage, 0],
            case pp_mount:handle(16003, Player, Args) of
                {ok, LastPlayer} -> skip;
                _ -> LastPlayer = Player
            end;
        _ -> LastPlayer = Player
    end,
    ?PRINT("============== ~p ~n", [LastPlayer#player_status.figure#figure.mount_figure]),
    {ok, LastPlayer}.

%% 激活培养系统接口
active_mount_api(Player, StatusType, _TypeId) ->
    %% 任务
    lib_task_api:train_something(Player, StatusType#status_mount.type_id,
        StatusType#status_mount.stage, StatusType#status_mount.star), 
    if
        StatusType#status_mount.type_id == ?MOUNT_ID ->
            NewPlayer = lib_push_gift_api:mount_active(Player, 0);
        StatusType#status_mount.type_id == ?HOLYORGAN_ID ->
            NewPlayer = lib_push_gift_api:holyoran_active(Player, 0);
        StatusType#status_mount.type_id == ?MATE_ID ->
            NewPlayer = lib_push_gift_api:mate_active(Player, 0);
        true ->
            NewPlayer = Player
    end,
    NewPlayer.

%% 培养类战力改变执行
power_change_event(Player, TypeId) ->
    lib_common_rank_api:refresh_rank_by_upgrade(Player, TypeId),
    %% 升阶升战活动
    lib_train_act:mount_train_stage_up(Player, TypeId),
    lib_train_act:mount_train_power_up(Player, TypeId),
    case TypeId of
        ?MOUNT_ID ->
            lib_rush_rank_api:reflash_rank_by_mount_rush(Player);
        ?MATE_ID ->
            lib_rush_rank_api:reflash_rank_by_spirit_rush(Player);
        ?FLY_ID ->
            lib_rush_rank_api:reflash_rank_by_wing_rush(Player);
        _ ->
            skip
    end,
    Player.

%% 非幻化阶数/星数改变执行
star_or_stage_change_event(Player, TypeId, NewStage, NewStar) ->
    lib_task_api:train_something(Player, TypeId, NewStage, NewStar),
    %%    升级或升阶时调用排行
%%    ?PRINT("TypeId, NewStage, NewStar ~p~n", [{TypeId, NewStage, NewStar}]),
    case TypeId of
        ?MOUNT_ID ->
            EventPS = lib_push_gift_api:mount_up(Player, NewStage, NewStar),
            lib_rush_rank_api:reflash_rank_by_mount_rush(Player);
        ?MATE_ID ->
            EventPS = lib_push_gift_api:mate_up(Player, NewStage, NewStar),
            lib_rush_rank_api:reflash_rank_by_spirit_rush(Player);
        ?HOLYORGAN_ID ->
            EventPS = lib_push_gift_api:holyoran_up(Player, NewStar);
        ?ARTIFACT_ID ->
            EventPS = lib_push_gift_api:artifact_up(Player, NewStar);
        ?FLY_ID ->
            EventPS = lib_push_gift_api:flv_up(Player, NewStage, NewStar),
            lib_activitycalen_api:role_success_end_activity(Player#player_status.id, ?MOD_WING, 1),
            lib_rush_rank_api:reflash_rank_by_wing_rush(Player);
        _ ->
            EventPS = Player,
            skip
    end,
    %% 排行榜
    lib_common_rank_api:refresh_rank_by_upgrade(EventPS, TypeId),
    % 成就
    lib_achievement_api:handle_achievement(TypeId, EventPS, NewStage, NewStar),
    {ok, NewPlayer} = lib_temple_awaken_api:trigger_mount_stage(EventPS, TypeId, NewStage, NewStar),
    {ok, PlayerAfSupvip} = lib_supreme_vip_api:train_something(NewPlayer, TypeId, NewStage, NewStar),
    PlayerAfSupvip.

%% 激活幻化
active_mount_figure_event(Player, TypeId, Id, NewFigureList) ->
    %% 成就
    lib_achievement_api:handle_achievement_figure(Player, TypeId, erlang:length(NewFigureList)),
    lib_task_api:train_something(Player, TypeId, 1, 0), %% 更新任务
    {ok, PlayerAfSupVip} = lib_supreme_vip_api:mount_acti_figure_event(Player, TypeId, Id),
    % 成就api
    {ok, PlayerAfAchi} = lib_achievement_api:mount_acti_figure_event(PlayerAfSupVip, Id), 
    if
        TypeId == ?MOUNT_ID ->
            LastPlayer = lib_push_gift_api:mount_active(PlayerAfAchi, Id);
        TypeId == ?HOLYORGAN_ID ->
            LastPlayer = lib_push_gift_api:holyoran_active(PlayerAfAchi, Id);
        TypeId == ?MATE_ID ->
            LastPlayer = lib_push_gift_api:mate_active(PlayerAfAchi, Id);
        true ->
            LastPlayer = Player
    end,
    LastPlayer.

%% 幻化升阶/升星
figure_stage_star_change(Player, NewFigureList, TypeId, _Id, _NewStage, _NewStar) ->
    TypeId == ?PET_ID andalso 
        lib_achievement_api:async_event(Player#player_status.id, lib_achievement_api, pet_lv_up_event, NewFigureList),
    lib_common_rank_api:refresh_rank_by_upgrade(Player, TypeId),
    Player.

%% 使用染色剂
figure_color_lv_up(Player, _ColorId, _NewColorLv) ->
    Player.

%% 计算其他模块对某个培养系统属性加成
%% TypeId  培养系统 坐骑 翅膀。。。
%% StageAttr 等阶属性
%% MagicBaseAttr 魔晶属性
%% StarAttr 星级属性 
other_mod_add_attr(Player1, TypeId, _MagicBaseAttr, StarAttr) ->
    #player_status{skill = SkillStatus} = Player1,
    #status_skill{skill_talent_list = SkillTalentList} = SkillStatus,
    %% 天赋技能加成
    AddTalentAttr = calc_skill_talent_attr(TypeId, SkillTalentList, StarAttr),
    AddTalentAttr.

%% 获取坐骑的激活数量(基础的 + 幻型里面的)
get_mount_active_cnt(Player, TypeId) ->
    #player_status{status_mount = StatusMount} = Player,
    case lists:keyfind(TypeId, #status_mount.type_id, StatusMount) of 
        false -> 0;
        #status_mount{figure_list = FigureList} -> length(FigureList) + 1
    end.

get_mount_active_id_list(Player, TypeId) ->
    #player_status{status_mount = StatusMount} = Player,
    case lists:keyfind(TypeId, #status_mount.type_id, StatusMount) of 
        false -> [];
        #status_mount{figure_list = FigureList} -> 
            [Id ||#mount_figure{id = Id} <- FigureList]
    end.

%% 天赋技能更新（导致坐骑属性修改
talent_skill_update(Player, SkillId, SkillLv) ->
    case data_skill_attr:get_skill_attr(SkillId, SkillLv) of
        #base_skill_attr{base_attr = [Attr|_]} ->
            case Attr of
                {{?MOD_MOUNT, TypeId}, _, _} ->
                    StatusMount = Player#player_status.status_mount,
                    StatuType = ulists:keyfind(TypeId, #status_mount.type_id, StatusMount, #status_mount{}),
                    {NewStatuType, _} = lib_mount:count_mount_attr_core(Player, StatuType),
                    LastStatusMount = lists:keyreplace(TypeId, #status_mount.type_id, Player#player_status.status_mount, NewStatuType),
                    Player#player_status{status_mount = LastStatusMount};
                _ -> Player
            end;
        _ -> Player
    end.

%% 天赋技能重置
reset_talent(Player) ->
    lib_mount:login_count_mount_attr(Player).


%==================================================================================
%% 内部方法
%==================================================================================
%% 天赋技能加成属性计算
calc_skill_talent_attr(TypeId, SkillTalentList, StarAttr) ->
    SkillTalentAttr = lib_skill_api:get_skill_attr2mod({?MOD_MOUNT, TypeId}, SkillTalentList), % 技能包括%
    TalentAttrAfCalc = lib_player_attr:partial_attr_convert(util:combine_list(SkillTalentAttr ++ StarAttr)),
    Fun2 =
        fun({AttrIdTmp2, AttrNumTmp2}, TalentAttrTmp) ->
            case lists:keyfind(AttrIdTmp2, 1, StarAttr) of
                {_, AttrValTmp2} ->
                    NewAttrNumTmp2 = max(0, AttrNumTmp2 - AttrValTmp2),
                    [{AttrIdTmp2, NewAttrNumTmp2} | TalentAttrTmp];
                _ ->
                    TalentAttrTmp
            end
        end,
    lists:foldl(Fun2, [], TalentAttrAfCalc).

%==================================================================================
%% gm 秘籍
%==================================================================================

del_bag_num(GoodsTypeId1, GoodsTypeId2, OverNum, LeftNum) ->
    %% select pid, gtype_id,sum(1) from goods_low group by gtype_id, pid order by sum(1) desc limit 10;
    Sql_vio = io_lib:format(<<"select * from (select player_id, sum(goods_num) as sum from log_goods where goods_id = ~p group by player_id) as t where t.sum >= ~p">>, [GoodsTypeId1, OverNum]),
    case db:get_all(Sql_vio) of
        [] -> skip;
        ViolationList ->
            ?PRINT("ViolationList ~p ~n", [ViolationList]),
            Fun = fun([PlayerId, AllNum]) ->
                    timer:sleep(1000),
                    DelNum = AllNum - LeftNum,
                    case is_pid(misc:get_player_process(PlayerId)) of
                        true ->
                            lib_player:apply_cast(PlayerId, ?APPLY_CAST_SAVE, ?MODULE, do_del_bag_num, [GoodsTypeId1, DelNum, GoodsTypeId2]);
                        false ->
                            Sql = io_lib:format("select accid, accname, accname_sdk, last_login_ip from player_login where id=~p ", [PlayerId]),
                            case db:get_row(Sql) of
                                [AccId, AccName, AccNameSdk, Ip] ->
                                    % case catch mod_server:start([PlayerId, Ip, none, AccId, AccName, AccNameSdk, util:get_server_name(), [PlayerId], 1, none, gsrv_tcp, reader_ws, ?ONHOOK_AGENT_LOGIN]) of
                                    LoginParams = #login_params{
                                        id = PlayerId, ip = Ip, socket = none, accid = AccId, accname = AccName, accname_sdk = AccNameSdk, server_name = util:get_server_name(), ids = [PlayerId], reg_server_id = 1, 
                                        c_source = none, trans_mod = gsrv_tcp, proto_mod = reader_ws
                                    },
                                    case catch mod_server:start([LoginParams, ?ONHOOK_AGENT_LOGIN]) of
                                        {ok, Pid} ->
                                            %% 走完正的流程
                                            erlang:unlink(Pid),
                                            lib_player:apply_cast(PlayerId, ?APPLY_CAST_SAVE, ?MODULE, do_del_bag_num, [GoodsTypeId1, DelNum, GoodsTypeId2]),
                                            mod_server:stop(Pid);
                                        _R -> ?ERR("gm del_goods start_fake_client login:~p~n", [_R])
                                    end;
                                _R -> ?ERR("gm del_goods start_fake_client login:~p~n", [_R])
                            end
                    end
                end,
            spawn( fun() -> lists:map(Fun, ViolationList) end ),
            ok
    end,
    ok.

do_del_bag_num(Player, GoodsType1, DelNum, GoodsTypeId2) ->
    [{_, OwnNum}] = lib_goods_api:get_goods_num(Player, [GoodsType1]),
    Res =
    if
        OwnNum >= DelNum ->
            lib_goods_api:cost_object_list_with_check(Player, [{?TYPE_GOODS, GoodsType1, DelNum}], gm, "");
        true ->
            DelType1Num = OwnNum,
            DelNum2 = ?IF(Player#player_status.id == 1460288880799, (DelNum - OwnNum) - 193, (DelNum - OwnNum)),
            [{_, OwnNum2}] = lib_goods_api:get_goods_num(Player, [GoodsTypeId2]),
            {DelType2Num, DelMountNum} = ?IF(OwnNum2 >= DelNum2, {DelNum2, 0}, {OwnNum2, DelNum2-OwnNum2}),

            Cost = [Item||{_,_,N} = Item<-[{?TYPE_GOODS, GoodsType1, DelType1Num}, {?TYPE_GOODS, GoodsTypeId2, DelType2Num}], N > 0],

            CurrentNum = mod_counter:get_count(Player#player_status.id, ?MOD_GOODS, GoodsTypeId2),
            NewMountNum = max(CurrentNum - DelMountNum, 0),
            {_, PlayerTmp} =
            case NewMountNum > 0 of
                true -> gm_delete_used_goods_online(Player, ?FLY_ID, GoodsTypeId2, NewMountNum);
                _ -> {ok, Player}
            end,
            case Cost of
                [] -> {true, PlayerTmp};
                _ -> lib_goods_api:cost_object_list_with_check(Player, Cost, gm, "")
            end
    end,
    case Res of
        {true, ResPlayer} -> {ok, ResPlayer};
        {false, Errcode, ResPlayer} ->
            ?ERR("do_del_bag_num had a error errcode:~p ~n", [Errcode]),
            {ok, ResPlayer}
    end.

gm_delete_used_goods_online(Player, TypeId, GoodsTypeId, Num) ->
    #player_status{id = RoleId, status_mount = StatusMount, figure = Figure} = Player,
    #figure{lv = RoleLv} = Figure,
    StatusType = lists:keyfind(TypeId, #status_mount.type_id, StatusMount),
    #mount_goods_cfg{attr = Attr, max_times = MaxTimesL} = data_mount:get_goods_cfg(TypeId, GoodsTypeId),
    MaxTimes = lib_mount:get_goods_max_times(MaxTimesL, RoleLv), % 物品使用上限
    NewAttr = [{Type_Id, TypeNum * Num} || {Type_Id, TypeNum} <- Attr],
    NewBaseAttr = util:combine_list(NewAttr),
    db:execute(io_lib:format(?sql_update_mount_base_attr, [util:term_to_string(NewBaseAttr), RoleId, TypeId])),
    mod_counter:set_count(RoleId, ?MOD_GOODS, GoodsTypeId, Num),
    NewStatusType = StatusType#status_mount{base_attr = NewBaseAttr},
    NewStatusMount = lists:keyreplace(TypeId, #status_mount.type_id, StatusMount, NewStatusType),
    NewPlayerTmp1 = lib_mount:count_mount_attr(Player#player_status{status_mount = NewStatusMount}),
    LastStatusMount = NewPlayerTmp1#player_status.status_mount,
    LastStatusType = lists:keyfind(TypeId, #status_mount.type_id, LastStatusMount), % 这里不用判断false
    %% 日志
    lib_log_api:log_mount_goods_use(RoleId, TypeId, GoodsTypeId, Num, MaxTimes,
        StatusType#status_mount.attr, LastStatusType#status_mount.attr),
    NewPlayer = lib_player:count_player_attribute(NewPlayerTmp1),
    lib_player:send_attribute_change_notify(NewPlayer, ?NOTIFY_ATTR),
    lib_common_rank_api:gm_refresh_rank(NewPlayer, TypeId),
    pp_mount:handle(16011, NewPlayer, [TypeId]),
    pp_mount:handle(16002, NewPlayer, [TypeId]),
    {ok, NewPlayer}.

gm_refresh_win_rank(RoleId) ->
    lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, ?MODULE, gm_refresh_win_rank, [?FLY_ID]).
    
gm_refresh_win_rank(Player, TypeId) ->
    lib_common_rank_api:gm_refresh_rank(Player, TypeId),
    {ok, Player}.