%%%-----------------------------------
%%% @Module      : pp_seacraft
%%% @Author      : xlh
%%% @Email       : 1593315047@qq.com
%%% @Created     : 2020
%%% @Description : 怒海争霸协议管理
%%%-----------------------------------
-module(pp_seacraft).

-include("server.hrl").
-include("common.hrl").
-include("errcode.hrl").
-include("def_fun.hrl").
-include("figure.hrl").
-include("scene.hrl").
-include("predefine.hrl").
-include("guild.hrl").
-include("seacraft.hrl").
-include("attr.hrl").
-include("def_module.hrl").

-export([
        handle/3
    ]).

handle(Cmd, Player, Args) -> 
    #player_status{id = _RoleId, figure = #figure{lv = Lv}} = Player,
    Openday = util:get_open_day(),   
    case data_seacraft:get_value(open_lv) of
        LimitLv when is_integer(LimitLv) andalso Lv >= LimitLv -> %% 限制开启等级
            case data_seacraft:get_value(open_day) of
                LimitOpenDay when is_integer(LimitLv) andalso Openday >= LimitOpenDay -> %% 开服天数限制
                    case do_handle(Cmd, Player, Args) of
                        {ok, NewPlayer} when is_record(NewPlayer, player_status) -> {ok, NewPlayer};
                        _ -> {ok, Player}
                    end;
                _ ->
                    {ok, Player} 
            end;
        _ ->
            {ok, Player}
    end.

%% 海域信息界面
do_handle(18600, Player, []) ->
    #player_status{id = RoleId, server_id = ServerId, guild = #status_guild{id = GuildId, realm = Camp}} = Player,
    mod_seacraft_local:get_main_show_info(ServerId, GuildId, Camp, RoleId),
    {ok, Player};

%% 海王禁卫军信息
do_handle(18601, Player, []) ->
    #player_status{id = RoleId, server_id = ServerId, guild = #status_guild{id = GuildId, realm = Camp}} = Player,
    mod_seacraft_local:get_job_show(ServerId, GuildId, Camp, RoleId),
    {ok, Player};

%% 职位审批设置
do_handle(18602, Player, [LimitLv, LimitPower, Auto]) ->
    #player_status{id = RoleId, server_id = ServerId, guild = #status_guild{position = Position, id = GuildId, realm = Camp}} = Player,
    if
        is_integer(LimitLv) == false orelse LimitLv < 0 ->
            {ok, BinData} = pt_186:write(18602, [?ERRCODE(err186_error_data)]),
            lib_server_send:send_to_uid(RoleId, BinData);
        is_integer(LimitPower) == false orelse LimitPower < 0 ->
            {ok, BinData} = pt_186:write(18602, [?ERRCODE(err186_error_data)]),
            lib_server_send:send_to_uid(RoleId, BinData);
        is_integer(Auto) == false orelse Auto < 0 ->
            {ok, BinData} = pt_186:write(18602, [?ERRCODE(err186_error_data)]),
            lib_server_send:send_to_uid(RoleId, BinData);
        Position =/= ?POS_CHIEF ->
            {ok, BinData} = pt_186:write(18602, [?ERRCODE(err186_not_guild_chief)]),
            lib_server_send:send_to_uid(RoleId, BinData);
        Camp == 0 ->
            {ok, BinData} = pt_186:write(18602, [?ERRCODE(err186_join_a_camp)]),
            lib_server_send:send_to_uid(RoleId, BinData);
        true ->
            mod_kf_seacraft:set_join_limit(ServerId, GuildId, Camp, RoleId, LimitLv, LimitPower, Auto)
    end,
    {ok, Player};

%% 申请加入海军禁卫
do_handle(18603, Player, []) ->
    #player_status{
        id = RoleId, server_id = ServerId, server_num = ServerNum, 
        guild = #status_guild{id = _GuildId, realm = Camp}, combat_power = Power,
        figure = #figure{name = RoleName, lv = RoleLv, picture = Picture, picture_ver = PictureVer}} = Player,
    if
        _GuildId == 0 ->
            {ok, BinData} = pt_186:write(18603, [?ERRCODE(err403_join_a_guild)]),
            lib_server_send:send_to_uid(RoleId, BinData);
        Camp == 0 ->
            {ok, BinData} = pt_186:write(18603, [?ERRCODE(err186_join_a_camp)]),
            lib_server_send:send_to_uid(RoleId, BinData);
        true ->
            mod_kf_seacraft:apply_to_join(Camp, ServerId, ServerNum, Picture, PictureVer, RoleLv, RoleId, RoleName, Power)
    end,
    {ok, Player};

%% 查看禁卫申请
do_handle(18604, Player, []) ->
    #player_status{
        id = RoleId, server_id = ServerId,
        guild = #status_guild{id = GuildId, realm = Camp, position = Position}
    } = Player,
    if
        Position =/= ?POS_CHIEF ->
            {ok, BinData} = pt_186:write(18604, [[]]),
            lib_server_send:send_to_uid(RoleId, BinData);
        true ->
            mod_seacraft_local:get_apply_list(Camp, GuildId, ServerId, RoleId)
    end,
    {ok, Player};

%% 处理禁卫申请
do_handle(18605, Player, [Agree, RId]) ->
    #player_status{id = RoleId, server_id = ServerId, guild = #status_guild{position = Position, id = GuildId, realm = Camp}} = Player,
    if
        Position =/= ?POS_CHIEF ->
            {ok, BinData} = pt_186:write(18605, [?ERRCODE(err186_not_guild_chief)]),
            lib_server_send:send_to_uid(RoleId, BinData);
        Camp == 0 ->
            {ok, BinData} = pt_186:write(18605, [?ERRCODE(err186_join_a_camp)]),
            lib_server_send:send_to_uid(RoleId, BinData);
        true ->
            mod_kf_seacraft:agree_join_apply(ServerId, GuildId, Camp, RoleId, Agree, RId)
    end,
    {ok, Player};

%% 职位管理
do_handle(18606, Player, [JobId, RoleIdList]) ->
    #player_status{id = RoleId, server_id = ServerId, guild = #status_guild{position = Position, id = GuildId, realm = Camp}} = Player,
    Length = erlang:length(RoleIdList),
    case data_seacraft:get_daily_reward(JobId) of
        #base_seacraft_daily_reward{limit = LimitNum} -> ok;
        _ -> LimitNum = 0
    end,
    if
        JobId == ?SEA_MASTER ->
            {ok, BinData} = pt_186:write(18606, [?ERRCODE(err186_error_data)]),
            lib_server_send:send_to_uid(RoleId, BinData);
        Position =/= ?POS_CHIEF ->
            {ok, BinData} = pt_186:write(18606, [?ERRCODE(err186_not_guild_chief)]),
            lib_server_send:send_to_uid(RoleId, BinData);
        JobId =/= ?SEA_MEMBER andalso Length > LimitNum ->    %% 因为RoleList会带有取消原有的玩家ID,会导致该条判断不过
             {ok, BinData} = pt_186:write(18606, [?ERRCODE(err186_job_limit)]),
             lib_server_send:send_to_uid(RoleId, BinData);
        Camp == 0 ->
            {ok, BinData} = pt_186:write(18606, [?ERRCODE(err186_join_a_camp)]),
            lib_server_send:send_to_uid(RoleId, BinData);
        true ->
            mod_kf_seacraft:handle_job(ServerId, GuildId, Camp, RoleId, JobId, RoleIdList)
    end,
    {ok, Player};

%% 获取海域争夺开启时间
do_handle(18607, Player, []) ->
    #player_status{id = RoleId, guild = #status_guild{id = GuildId, realm = Camp}} = Player,
    mod_seacraft_local:get_act_time(RoleId, Camp, GuildId),
    {ok, Player};

%% 海域争夺公会列表
do_handle(18608, Player, [Camp]) ->
    #player_status{id = RoleId} = Player,
    mod_seacraft_local:get_camp_guild_list(RoleId, Camp),
    {ok, Player};

%% 怪物数据（海战场景内）
do_handle(18609, Player, []) ->
    #player_status{id = RoleId, scene = Scene, guild = #status_guild{realm = Camp}} = Player,
    case data_scene:get(Scene) of
        #ets_scene{type = Type} when Type == ?SCENE_TYPE_SEACRAFT ->
            mod_seacraft_local:get_camp_mon_list(RoleId, Camp);
        _ ->
            {ok, BinData} = pt_186:write(18609, [[]]),
            lib_server_send:send_to_uid(RoleId, BinData)
    end,
    {ok, Player};

%% 战舰切换
do_handle(18610, Player, [Type]) ->
    #player_status{id = RoleId, scene_pool_id = PoolId, scene = Scene, battle_attr = #battle_attr{group = Group}} = Player,
    case data_scene:get(Scene) of
        #ets_scene{type = SceneType} when SceneType == ?SCENE_TYPE_SEACRAFT ->
            if
                Group == Type ->
                    {ok, BinData} = pt_186:write(18610, [0, ?ERRCODE(err186_already_same_type), 0]),
                    lib_server_send:send_to_uid(RoleId, BinData);
                true ->
                    mod_seacraft_local:change_role_group(RoleId, [], Scene, PoolId, Type, Group)
            end;
        _ ->
            {ok, BinData} = pt_186:write(18610, [0, ?ERRCODE(err186_not_in_scene), 0]),
            lib_server_send:send_to_uid(RoleId, BinData)
    end,
    {ok, Player};

%% 战场统计信息
do_handle(18611, Player, []) ->
    #player_status{id = RoleId, guild = #status_guild{realm = Camp}} = Player,
    mod_seacraft_local:get_score_info(RoleId, Camp),
    {ok, Player};

%% 进入
do_handle(18613, Player, [Scene]) ->
    #player_status{id = RoleId, server_num = ServerNum, server_id = ServerId, scene = SceneId, combat_power = Power,
        guild = #status_guild{id = GuildId, name = GuildName, realm = Camp}, 
        figure = #figure{lv = RoleLv, name = RoleName, picture = Picture, picture_ver = PictureVer} = Figure} = Player,
    NeedOut = lib_boss:is_in_outside_scene(SceneId),
    Lock = ?ERRCODE(err186_enter_cluster),
    case lib_player_check:check_list(Player, [action_free, is_transferable, {is_gm_stop, ?MOD_SEACRAFT, 0}]) of
        {false, Code} -> skip;
        true->
            case data_scene:get(Scene) of
                #ets_scene{type = Type} when Type == ?SCENE_TYPE_SEACRAFT ->
                    Code = 1;
                _ ->
                    Code = ?ERRCODE(err186_error_data)
            end
    end,
    % lib_role:update_role_show(RoleId, [{figure, Figure#figure{camp = Camp}}]),
    % mod_scene_agent:update(SceneId, PoolId, RoleId, [{figure, Figure#figure{camp = Camp}}]),
    if
        GuildId == 0 -> %% 公会玩法
            NewPlayer = Player,
            {ok, BinData} = pt_186:write(18613, [0, ?ERRCODE(err403_join_a_guild)]),
            lib_server_send:send_to_uid(RoleId, BinData);
        Camp == 0 ->
            NewPlayer = Player,
            {ok, BinData} = pt_186:write(18613, [0, ?ERRCODE(err186_join_a_camp)]),
            lib_server_send:send_to_uid(RoleId, BinData);
        Code =/= 1  ->
            NewPlayer = Player,
            {ok, BinData} = pt_186:write(18613, [0, Code]),
            lib_server_send:send_to_uid(RoleId, BinData);
        Scene == SceneId ->
            NewPlayer = Player,
            {ok, BinData} = pt_186:write(18613, [0, ?ERRCODE(err120_already_in_scene)]),
            lib_server_send:send_to_uid(RoleId, BinData);
        true ->
            NewPlayer = Player#player_status{action_lock = {utime:unixtime() + 5, Lock}, figure = Figure#figure{camp = Camp}},%% 加锁，防止多次进入
            mod_kf_seacraft:enter_scene(ServerNum, ServerId, GuildId, GuildName, RoleId, RoleName, RoleLv, Power, Picture, PictureVer, Scene, NeedOut, Camp)
    end,
    {ok, NewPlayer};

%% 退出
do_handle(18614, Player, []) ->
    % ?PRINT("Scene:~p, CopyId:~p, Pool:~p~n",[Player#player_status.scene, Player#player_status.copy_id, Player#player_status.scene_pool_id]),
    {IsOut, ErrCode} = lib_scene:is_transferable_out(Player),
    case IsOut of
        true ->
            #player_status{id = _RoleId, server_id = _ServerId, scene = Scene, guild = #status_guild{id = _GuildId}} = Player, %% 可以切换pk状态的场景在退出时都需要将pk状态设置为和平模式
            case data_scene:get(Scene) of
                #ets_scene{type = Type} when Type == ?SCENE_TYPE_SEACRAFT ->
                    NewPs = lib_scene:change_scene(Player, 0, 0, 0, 0, 0, true, 
                        [{group, 0}, {camp, 0}, {change_scene_hp_lim, 100}, {pk, {?PK_PEACE, true}}]);
                _ ->
                    NewPs = Player
            end;
        false ->
            NewPs = Player
    end,
    {ok, BinData} = pt_186:write(18614, [ErrCode]),
    lib_server_send:send_to_uid(NewPs#player_status.id, BinData),
    LastPlayer = lib_player:count_player_attribute(NewPs),
    %% 通知客户端属性改变
    lib_player:send_attribute_change_notify(LastPlayer, ?NOTIFY_ATTR),
    {ok, LastPlayer};

%% 海域霸主界面
do_handle(18615, Player, []) ->
    #player_status{id = RoleId} = Player,
    mod_seacraft_local:get_sea_master_info(RoleId),
    {ok, Player};

%% 连胜分配
do_handle(18616, Player, [SerId, RId, Times]) ->
    #player_status{id = RoleId, server_id = ServerId, figure = #figure{name = RoleName},
        guild = #status_guild{name = GuildName, position = Position, id = GuildId, realm = Camp}} = Player,
    if
        Position =/= ?POS_CHIEF ->
            {ok, BinData} = pt_186:write(18616, [?ERRCODE(err186_not_guild_chief)]),
            lib_server_send:send_to_uid(RoleId, BinData);
        true ->
            mod_kf_seacraft:divide_win_reward(ServerId, GuildId, GuildName, Camp, RoleId, RoleName, SerId, RId, Times)
    end,
    {ok, Player};

%% 攻守防
do_handle(18617, Player, []) ->
    #player_status{
        id = RoleId, server_id = _ServerId,
        guild = #status_guild{id = _GuildId, realm = Camp}
    } = Player,
    mod_seacraft_local:get_att_def_list(Camp, RoleId),
    {ok, Player};

%% 势力（海域）列表
do_handle(18618, Player, []) ->
    #player_status{id = RoleId} = Player,
    mod_seacraft_local:get_camp_info(RoleId),
    {ok, Player};

%% 加入势力（海域）
do_handle(18619, Player, [Camp]) ->
    #player_status{
        id = RoleId, server_id = ServerId, server_num = ServerNum, figure = #figure{name = RoleName, lv = RoleLv, picture = Picture, picture_ver = PictureVer},
        guild = #status_guild{position = Position, name = GuildName, id = GuildId, realm = NowCamp}, combat_power = Power
    } = Player,
    if
        Camp == 0 ->
            {ok, BinData} = pt_186:write(18619, [?ERRCODE(err186_error_data)]),
            lib_server_send:send_to_uid(RoleId, BinData);
        NowCamp =/= 0 ->
            {ok, BinData} = pt_186:write(18619, [?ERRCODE(err186_has_join_a_camp)]),
            lib_server_send:send_to_uid(RoleId, BinData);
        Position =/= ?POS_CHIEF ->
            {ok, BinData} = pt_186:write(18619, [?ERRCODE(err186_not_guild_chief)]),
            lib_server_send:send_to_uid(RoleId, BinData);
        true ->
            % case mod_guild:get_guild_by_id([GuildId]) of
            %     [#guild{member_num = GuildUserNum, combat_power_ten = CombatPowerTen}|_] ->
            %         mod_kf_seacraft:join_camp(ServerId, ServerNum, GuildId, GuildName, CombatPowerTen, RoleId, RoleName, GuildUserNum, Camp, RoleLv, Power, Picture);
            %     _ ->
            %         {ok, BinData} = pt_186:write(18619, [?ERRCODE(err186_error_data)]),
            %         lib_server_send:send_to_uid(RoleId, BinData)
            % end
            mod_guild:join_sea_camp({ServerId, ServerNum, GuildId, GuildName, RoleId, RoleName, Camp, RoleLv, Power, Picture, PictureVer})
    end,
    {ok, Player};

%% 退出势力（海域）
do_handle(18620, Player, []) ->
    #player_status{
        id = RoleId, server_id = ServerId,
        guild = #status_guild{position = Position, id = GuildId, realm = Camp}
    } = Player,
    if
        Camp == 0 ->
            {ok, BinData} = pt_186:write(18619, [?ERRCODE(err186_join_a_camp)]),
            lib_server_send:send_to_uid(RoleId, BinData);
        Position =/= ?POS_CHIEF ->
            {ok, BinData} = pt_186:write(18619, [?ERRCODE(err186_not_guild_chief)]),
            lib_server_send:send_to_uid(RoleId, BinData);
        true ->
            mod_kf_seacraft:exit_camp(ServerId, GuildId, RoleId, Camp)
    end,
    {ok, Player};

%% 领取每日福利
do_handle(18621, Player, []) ->
    #player_status{
        id = RoleId, server_id = ServerId, figure = #figure{name = RoleName},
        guild = #status_guild{name = GuildName, id = GuildId, realm = Camp}
    } = Player,
    if
        GuildId == 0 ->
            {ok, BinData} = pt_186:write(1621, [[],?ERRCODE(err403_join_a_guild)]),
            lib_server_send:send_to_uid(RoleId, BinData);
        Camp == 0 ->
            {ok, BinData} = pt_186:write(1621, [[],?ERRCODE(err186_join_a_camp)]),
            lib_server_send:send_to_uid(RoleId, BinData);
        true ->
            mod_seacraft_local:recieve_daily_reward(ServerId, GuildId, GuildName, RoleId, RoleName, Camp)
    end,
    {ok, Player};

%% 查看本阵营申请限制
do_handle(18622, Player, []) ->
    #player_status{
        id = RoleId, server_id = ServerId,
        guild = #status_guild{id = GuildId, realm = Camp}
    } = Player,
    mod_seacraft_local:get_apply_limit(Camp, GuildId, ServerId, RoleId),
    {ok, Player};

%% 下次活动时间
do_handle(18624, Player, []) ->
    mod_seacraft_local:get_next_act_time(Player#player_status.id),
    {ok, Player};

%% 活动报名时间
do_handle(18625, Player, []) ->
    mod_seacraft_local:get_join_camp_end_time(Player#player_status.id),
    {ok, Player};

%% 每日奖励
do_handle(18656, Player, []) ->
    mod_seacraft_local:get_old_job_id(Player#player_status.id),
    {ok, Player};

do_handle(_Cmd, _Player, _Data) -> pp_seacraft_extra:do_handle(_Cmd, _Player, _Data).