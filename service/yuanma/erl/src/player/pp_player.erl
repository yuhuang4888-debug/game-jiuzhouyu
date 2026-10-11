%%%--------------------------------------
%%% @Module  : pp_player
%%% @Author  : xyao
%%% @Email   : jiexiaowen@gmail.com
%%% @Created : 2010.06.13
%%% @Description:  角色功能管理
%%%--------------------------------------
-module(pp_player).
-export([handle/3]).
-include("common.hrl").
-include("server.hrl").
-include("predefine.hrl").
-include("title.hrl").
-include("def_event.hrl").
-include("figure.hrl").
-include("guild.hrl").
-include("dungeon.hrl").
-include("career.hrl").
-include("errcode.hrl").
-include("attr.hrl").
-include("team.hrl").
-include("skill.hrl").
-include("def_module.hrl").
-include("scene.hrl").
-include("enchantment_guard.hrl").
-include("role.hrl").

%% 查询当前玩家信息(仅能登录时请求一遍)
handle(13001, Status, _) ->
    NewStatus = lib_shenhe_api:get_shenhe_config(Status),
    #player_status{
        id = Id,
        platform = Platform,
        server_num = ServerNum,
        c_server_msg = CServerMsg,
        server_id= ServerId,
        server_name = ServerName,
        % source = Source,
        figure = Figure,
        battle_attr = BattleAttr,
        scene = SceneId, x = X, y = Y,
        exp = Exp, exp_lim = ExpLim,
        gold = Gold, bgold = BGold, coin = Coin, gcoin = GCoin,
        combat_power=CombatPower,
        guild=#status_guild{id = GuildId, name = GuildName},
        dungeon=#status_dungeon{dun_id = DunId},
        team=#status_team{team_id=TeamId},
        sid = Sid,
        mate_role_id = MateRoleId,
        last_task_id = LastTaskId,
        ip = Ip,
        camp_id = Camp,
        reg_time = RegTime
    } = NewStatus,
    %% 审核配置预设(后续优化)
    % {NewFigure, TSceneId, TX, TY, TExp, TExpLim} = lib_shenhe_api:get_shenhe_config(Source, Figure, Scene, X, Y, Exp, ExpLim),
    % NewStatus = Status#player_status{figure = NewFigure, scene = TSceneId, x = TX, y = TY, exp = TExp, exp_lim = TExpLim},

    %% 强制设置一次socket
    %% Status#player_status.sid ! {modify_sock_13001, true, Status#player_status.socket},
    Sid ! {is_send, true},
    %% 再发送人物信息
    PkCd = lib_player:get_pk_cd_time(NewStatus),
    #battle_attr{pk = #pk{pk_value=PkValue}} = BattleAttr,
    {ok, BinData} = pt_130:write(13001, [Id, Platform, ServerNum, CServerMsg, ServerId, ServerName, Figure, BattleAttr, SceneId,
        X, Y, DunId, Exp, ExpLim, Gold, BGold, Coin, GCoin, CombatPower, GuildId,
        GuildName, PkCd, PkValue, TeamId, MateRoleId, Ip, Camp, RegTime]),
    lib_server_send:send_to_sid(Sid, BinData),
    lib_server_send:send_to_sid(Sid, pt_300, 30005, [LastTaskId]),
    %% 添加定时器
    lib_client:add_a_player_timer(Id),
    {ok, NewStatus};

%% 查询玩家信息
handle(13004, Status, Id) ->
    #player_status{sid = MySid} = Status,
    case lib_player:is_online_global(Id) of
        true -> lib_player:send_player_info_view(Status, Id);
        false -> lib_offline_api:send_player_info_view(MySid, Id)
    end;

%% 请求玩家铜币和元宝信息
handle(13006, Status, _) ->
    {ok, BinData} = pt_130:write(13006, [Status#player_status.coin, Status#player_status.gold, Status#player_status.bgold]),
    lib_server_send:send_to_sid(Status#player_status.sid, BinData);

%% 请求快捷栏
handle(13007, Status, _) ->
    lib_player:send_quickbar_info(Status);

%% 保存快捷栏
handle(13008, Status, [Local, Type, Id, AutoTag]) ->
    FixedQuickbarPosL = data_skill_m:get_fixed_quickbar_pos_list(),
    FixedSkillL = data_skill_m:get_fixed_quickbar_skill_list(Status#player_status.figure#figure.career),
    IsFixedLocal = lists:member(Local, FixedQuickbarPosL),
    IsFixedSkill = lists:member(Id, FixedSkillL),
    {IsVaild, Code} = if
        IsFixedLocal ->
            {false, 0};
        Type == ?QUICKBAR_TYPE_SKILL andalso IsFixedSkill ->
            {false, 0};
        Type == ?QUICKBAR_TYPE_SKILL ->
            BfSkillId = lib_arcana:get_before_reskill_id(Status, Id),
            case lists:keyfind(BfSkillId, 1, Status#player_status.skill#status_skill.skill_list) of
                {BfSkillId, Lv} when Lv > 0 -> 
                    ReSkillId = lib_arcana:get_high_reskill_id(Status, BfSkillId),
                    case ReSkillId == Id of
                        true -> {true, 1};
                        false -> {false, 0}
                    end;
                _ -> 
                    case lists:keyfind(Id, 1, lib_arcana:get_active_skill(Status)) of
                        {_SkillId, Lv} when Lv > 0 -> {true, 1};
                        _ -> {false, 0}
                    end
            end;
        true ->
            {true, 0}
    end,
    {ok, BinData} = pt_130:write(13008, Code),
    lib_server_send:send_to_sid(Status#player_status.sid, BinData),
    case IsVaild of
        true ->
            Quickbar = lib_player:save_quickbar([Local, Type, Id, AutoTag], Status#player_status.quickbar),
            Status1 = Status#player_status{quickbar = Quickbar},
            lib_player:db_save_quickbar(Status#player_status.id, Quickbar),
            {ok, Status1};
        false -> 
            skip
    end;

% %%删除快捷栏
% handle(13009, Status, Local) when Local =/= 1 ->
%     {ok, BinData} = pt_130:write(13009, 1),
%     lib_server_send:send_to_sid(Status#player_status.sid, BinData),
%     Quickbar = lib_player:delete_quickbar(Local, Status#player_status.quickbar),
%     Status1 = Status#player_status{quickbar= Quickbar},
%     lib_player:db_save_quickbar(Status1),
%     {ok, Status1};

%% 替换快捷栏
handle(13010, Status, [Local1, Local2]) ->
    FixedQuickbarPosL = data_skill_m:get_fixed_quickbar_pos_list(),
    IsFixedLocal1 = lists:member(Local1, FixedQuickbarPosL),
    IsFixedLocal2 = lists:member(Local2, FixedQuickbarPosL),
    case IsFixedLocal1 orelse IsFixedLocal2 of
        true -> 
            {ok, BinData} = pt_130:write(13010, 0),
            lib_server_send:send_to_sid(Status#player_status.sid, BinData);
        false ->
            {ok, BinData} = pt_130:write(13010, 1),
            lib_server_send:send_to_sid(Status#player_status.sid, BinData),
            Quickbar = lib_player:replace_quickbar(Local1, Local2, Status#player_status.quickbar),
            Status1 = Status#player_status{quickbar= Quickbar},
            lib_player:db_save_quickbar(Status1),
            mod_scene_agent:update(Status1, [{qucikbar, Quickbar}]),
            {ok, Status1}
    end;

%% 玩家是否可以打开世界等级
handle(13011, Status, _) ->
    lib_player:send_world_exp_add_to_client(Status),
    ok;

%% 切换PK状态
handle(13012, Status, [Type]) when Type>=?PK_PEACE, Type=<?PK_CAMP ->
    %%圣域特殊处理
    #player_status{scene = Scene, guild = Guild} = Status,
    IsSanctuaryScene = lib_sanctuary:is_sanctuary_scene(Scene),
    if
        IsSanctuaryScene == true andalso Type == ?PK_ALL andalso Guild#status_guild.id =/= 0 ->
            mod_sanctuary:change_pk(Status#player_status.id, Guild#status_guild.id, Type, Scene),
            skip;
        true ->
            case lib_player:change_pkstatus(Status, Type) of
                false -> skip;
                {ok, #player_status{id = RoleId, scene = SceneId, pk_map = PkMap, guild = Guild} = NewStatus} ->
                    % 场景编辑器有问题,先在代码上写死判断
                    IsNeedScene = lib_boss:is_in_forbdden_boss(SceneId) orelse lib_boss:is_in_fairy_boss(SceneId),
                    lib_sanctuary:change_pk_mod(RoleId, Type, Guild, SceneId),
                    case data_scene:get(SceneId) of
                        #ets_scene{is_stay_pk_status = IsStay} when IsStay == 1 orelse IsNeedScene ->
                            NewPkMap = maps:put(SceneId, Type, PkMap),
                            % lib_player_record:db_role_pk_status_replace(RoleId, SceneId, Type),
                            {ok, NewStatus#player_status{pk_map = NewPkMap}};
                        _ ->
                            {ok, NewStatus}
                    end
            end
    end;

handle(13013, Status, [ServerId, RoleId, ModId]) ->
    if
        RoleId =:= Status#player_status.id ->
            lib_player:send_figure_to_uid(Status, ServerId, ModId, RoleId);
        true ->
            case lists:member(ServerId, config:get_merge_server_ids()) of
                true ->
                    lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, ?HAND_OFFLINE, lib_player, send_figure_to_uid, [ServerId, ModId, Status#player_status.id]);
                _ ->
                    Node = mod_disperse:get_clusters_node(),
                    mod_clusters_node:apply_cast(lib_player, get_figure_from_other_server, [ServerId, RoleId, ModId, Node, Status#player_status.id])
            end
    end;

%% 请求公会会长figure
handle(13014, Status, [ServerId, GuildId, ModId]) ->
    ArgsMap = #{ser_id => ServerId, mod_id => ModId},
    case lists:member(ServerId, config:get_merge_server_ids()) of
        true ->
            mod_guild:send_chief_figure_info(none, Status#player_status.id, GuildId, ArgsMap);
        _ when ServerId =/= 0 ->
            Node = mod_disperse:get_clusters_node(),
            mod_clusters_node:apply_cast(lib_guild_api, send_chief_figure_info_in_center, [Node, Status#player_status.id, GuildId, ArgsMap]);
        _ -> skip
    end;

handle(13015, Status, [ServerId, RoleId, ModId]) ->
    case lists:member(ServerId, config:get_merge_server_ids()) of
        true ->
            case lib_role:get_role_show(RoleId) of
                #ets_role_show{figure = Figure} ->
                    {ok, BinData} = pt_130:write(13015, [ServerId, ModId, RoleId, Figure]),
                    lib_server_send:send_to_sid(Status#player_status.sid, BinData);
                _ ->
                    skip
            end;
        _ when ServerId =/= 0 ->
            Node = mod_disperse:get_clusters_node(),
            mod_clusters_node:apply_cast(lib_player, send_role_figure_cls, [Node, Status#player_status.id, RoleId, ServerId, ModId]);
        _ -> skip
    end;

handle(13017, Status, _) ->
    IsInBehavior = lib_player_behavior_api:is_in_behavior(Status),
    Val = case IsInBehavior of true -> 1; _ -> 0 end,
    {ok, BinData} = pt_130:write(13017, [Val]),
    lib_server_send:send_to_uid(Status#player_status.id, BinData);

%% 玩家红名值
handle(13034, Status, _) ->
    lib_player:send_attribute_change_notify(Status, ?NOTIFY_PK);

%% 玩家消除红名值
handle(13035, Ps, [Num]) when Num > 0 ->
    #player_status{id = RoleId, sid = Sid, battle_attr = BA,
                   scene = SceneId, scene_pool_id = ScenePId, copy_id = CopyId, x = X, y = Y} = Ps,
    #battle_attr{pk = Pk} = BA,
    #pk{pk_value = PkValue, pk_value_ref = PkValueRef} = Pk,
    if
        PkValue =< 0 -> lib_server_send:send_to_sid(Sid,  pt_130, 13035, [?ERRCODE(err150_pk_value_0), 0, 0]);
        true ->
            NewNum = if PkValue < Num -> PkValue; true -> Num end,
            case lib_goods_api:cost_money(Ps, ?GOLD, 50*NewNum, red_name_cost, "") of
                {0, _} -> lib_server_send:send_to_sid(Sid, pt_130, 13035, [?ERRCODE(gold_not_enough), 0, 0]);
                {1, NewPs} ->
                    NewPkValue = max(0, PkValue-NewNum),
                    NewPk = if
                                NewPkValue == 0 ->
                                    util:cancel_timer(PkValueRef),
                                    {ok, BinData1} = pt_200:write(20015, [RoleId, NewPkValue]),
                                    lib_server_send:send_to_area_scene(SceneId, ScenePId, CopyId, X, Y, BinData1),
                                    Pk#pk{pk_value = 0, pk_value_change_time = 0, pk_value_ref = undefined};
                                true ->
                                    Pk#pk{pk_value = NewPkValue}
                            end,
                    SQL = <<"update player_state set pk_value = ~w where id = ~w">>,
                    db:execute(io_lib:format(SQL, [NewPkValue, RoleId])),
                    NewPS = NewPs#player_status{battle_attr = BA#battle_attr{pk = NewPk}},
                    lib_player:send_attribute_change_notify(NewPS, ?NOTIFY_PK),
                    mod_scene_agent:update(NewPS, [{battle_attr, NewPS#player_status.battle_attr}]),
                    lib_server_send:send_to_sid(Sid, pt_130, 13035, [?SUCCESS, NewNum, NewPkValue]),
                    %% 触发成就
                    lib_achievement_api:red_name_wash_event(NewPS, [])
            end
    end;

%% 转职
handle(13045, Status, [NewCareer, NewSex]) ->
    #player_status{sid = Sid} = Status,
    case lib_transfer:transfer(Status, NewCareer, NewSex) of
        {ok, NewStatus} -> ErrCode = ?SUCCESS;
        {false, ErrCode, NewStatus} -> skip;
        {false, ErrCode} -> NewStatus = Status
    end,
    {ErrorCodeInt, ErrorCodeArgs} = util:parse_error_code(ErrCode),
    {ok, BinData} = pt_130:write(13045, [ErrorCodeInt, ErrorCodeArgs, NewCareer, NewSex]),
    lib_server_send:send_to_sid(Sid, BinData),
    {ok, NewStatus};

%% 转职
handle(13046, Status, _) ->
    lib_transfer:send_transfer_info(Status);

%% 请求充值
handle(13051, Status, _) ->
    case catch lib_recharge:pay(Status) of
        [NewStatus, _]  ->
            %% 发送属性变化通知
            lib_player:send_attribute_change_notify(NewStatus, ?NOTIFY_MONEY),
            {ok, NewStatus};
        R->
            ?ERR("13051, pay, recharge :  error = ~p~n", [R]),
            %% 关闭socket
            lib_server_send:send_to_sid(Status#player_status.sid, close)
    end;

%% 修改/查询玩家配置
%% handle(13070, Status, [Type, List]) ->
%%     {Res, Conf}
%%         = if
%%               Type == 0 -> %% 请求
%%                   {1, Status#player_status.conf};
%%               Type == 1 -> %% 修改
%%                   NewSysConf = lib_player:set_sys_conf(List, Status#player_status.conf),
%%                   {1, NewSysConf};
%%               true -> %% 错误类型
%%                   {0, Status#player_status.conf}
%%           end,
%%     {ok, BinData} = pt_130:write(13070, [Res, Conf]),
%%     lib_server_send:send_to_sid(Status#player_status.sid, BinData),
%%     {ok, Status#player_status{conf = Conf}};

%% 获取激活的头像列表
handle(13080, Status, []) ->
    #player_status{sid = Sid, picture_list = PictureList} = Status,
    {ok, Bin} = pt_130:write(13080, [PictureList]),
    lib_server_send:send_to_sid(Sid, Bin);

%% 激活头像
handle(13081, Status, [_Id]) ->
    {ok, Status};


%% 校验是否能上传头像
handle(13082, Status, _) ->
    Count =
        case lib_vsn:is_jp() of
            true -> 0;
            _ -> mod_daily:get_count(Status#player_status.id, ?MOD_PLAYER, 1)
        end ,
    if
        Status#player_status.picture_lim =/= 0 ->
            Res = ?ERRCODE(err130_picture_limit);
        Count >= 1 ->
            Res = ?ERRCODE(err130_has_uploaded_daily);
        true ->
            Res = ?SUCCESS
    end,
    {ok, BinData} = pt_130:write(13082, [Res]),
    lib_server_send:send_to_sid(Status#player_status.sid, BinData);

%% 设置头像
handle(13083, Status, [Id]) ->
    NewPicture = integer_to_list(Id),
    #player_status{id = _RoleId, figure = Figure, picture_lim = PictureLim, sid = Sid, picture_list = PictureList} = Status,
    %Count = mod_daily:get_count(RoleId, ?MOD_PLAYER, 1),
    HadPicture = lists:member(Id, PictureList),
    if
        PictureLim =/= 0 ->
            Res = ?ERRCODE(err130_picture_limit),
            {ok, BinData} = pt_130:write(13083, [Res, 0, ""]),
            lib_server_send:send_to_sid(Sid, BinData);
        HadPicture =/= true ->
            Res = ?ERRCODE(err130_no_picture),
            {ok, BinData} = pt_130:write(13083, [Res, 0, ""]),
            lib_server_send:send_to_sid(Sid, BinData);
        true ->
            %% 版本号,客户端根据版本号来判断是否请求头像
            NewPictureVer = Figure#figure.picture_ver,
            %% 触发头像更改(在线不在线都需要处理：秘籍才需要这样处理)
            %% lib_player:notify_picture_change(RoleId, NewPicture, NewPictureVer),
            %% 更新玩家身上picture
            %mod_daily:increment(RoleId, ?MOD_PLAYER, 1),
            {ok, NewStatus1} = lib_player:update_player_picture_online(Status, NewPicture, NewPictureVer),

            {ok, NewStatus1}
    end;

%% 设置GPS经纬度
handle(13084, Status, [Longitude, Latitude]) when is_integer(Longitude) andalso is_integer(Latitude) ->
    {ok, BinData} = pt_130:write(13084, 1),
    lib_server_send:send_to_sid(Status#player_status.sid, BinData),
    mod_disperse:cast_to_unite(lib_relationship, update_user_lat_lng, [Status#player_status.id, Longitude, Latitude]),
    {ok, Status#player_status{longitude=Longitude, latitude=Latitude}};

%% 查看玩家指定数据
handle(13086, Status, []) ->
    #player_status{id = RoleId, sid = Sid, enchantment_guard = #enchantment_guard{gate = Gate}} = Status,
    VipBossCount = mod_counter:get_count(RoleId, ?MOD_BOSS, 10),
    ExpDunCount = mod_counter:get_count(RoleId, ?MOD_DUNGEON, 3),
    lib_server_send:send_to_sid(Sid, pt_130, 13086, [[{1, ExpDunCount}, {2, VipBossCount}, {3, Gate}]]);

handle(13087, Status, [Notify]) ->
    NewStatus = if
        Notify == 1 ->
            lib_boss_api:cancel_timer_revive(Status);
        true ->
            Status
    end,
    {ok, NewStatus};

%% 终身次数信息
handle(13088, Status, [ModuleId, SubModule, TypeList]) ->
    #player_status{id = RoleId} = Status,
    List = [{ModuleId, SubModule, Type}||Type<-TypeList],
    CountList = mod_counter:get_count(RoleId, List),
    SendL = [{Type, Num}||{{_Mod, _SubMod, Type}, Num}<-CountList],
    lib_server_send:send_to_uid(RoleId, pt_130, 13088, [ModuleId, SubModule, SendL]);

%% 终身次数信息 + 1
handle(13089, Status, [ModuleId, SubModule, Type]) when ModuleId == 300, SubModule == 1 ->
    #player_status{id = RoleId} = Status,
    Count = mod_counter:increment(RoleId, ModuleId, SubModule, Type),
    lib_server_send:send_to_uid(RoleId, pt_130, 13089, [ModuleId, SubModule, Type, Count]);

handle(_Cmd, _Status, _Data) ->
    {error, "pp_player no match"}.
