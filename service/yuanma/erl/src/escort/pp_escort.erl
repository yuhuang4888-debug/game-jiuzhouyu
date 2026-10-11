-module(pp_escort).

-include("server.hrl").
-include("common.hrl").
-include("escort.hrl").
-include("errcode.hrl").
-include("def_fun.hrl").
-include("figure.hrl").
-include("scene.hrl").
-include("predefine.hrl").
-include("guild.hrl").

-export([
        handle/3
    ]).

handle(Cmd, Player, Args) -> 
    #player_status{id = RoleId, figure = #figure{lv = Lv}} = Player,
    Openday = util:get_open_day(),   
    case data_escort:get_escort_value(open_lv) of
        LimitLv when is_integer(LimitLv) andalso Lv >= LimitLv -> %% 限制开启等级
            case data_escort:get_escort_value(open_day) of
                LimitOpenDay when is_integer(LimitLv) andalso Openday >= LimitOpenDay -> %% 开服天数限制
                    case do_handle(Cmd, Player, Args) of
                        {ok, NewPlayer} when is_record(NewPlayer, player_status) -> {ok, NewPlayer};
                        _ -> {ok, Player}
                    end;
                _ ->
                    send_error(RoleId, ?ERRCODE(err185_open_day_limit)),
                    {ok, Player} 
            end;
        _ ->
            send_error(RoleId, ?ERRCODE(lv_limit)),
            {ok, Player}
    end.

%% -----------------------------------------------------------------
%% 错误码返回
%% -----------------------------------------------------------------
send_error(RoleId, Code) -> 
    {ok, BinData} = pt_185:write(18500, [Code]),
    lib_server_send:send_to_uid(RoleId, BinData).

%% -----------------------------------------------------------------
%% 界面数据
%% -----------------------------------------------------------------
do_handle(18501, Player, []) ->
    #player_status{id = RoleId, guild = #status_guild{id = GuildId}} = Player,
    mod_escort_local:send_first_guild_info(RoleId, GuildId),
    {ok, Player};

%% -----------------------------------------------------------------
%% 进入
%% -----------------------------------------------------------------
do_handle(18502, Player, [Scene]) ->
    #player_status{id = RoleId, server_num = ServerNum, server_id = ServerId, scene = SceneId,
        guild = #status_guild{id = GuildId, name = GuildName, position = Position}, figure = #figure{name = RoleName}} = Player,
    NeedOut = lib_boss:is_in_outside_scene(SceneId),
    Lock = ?ERRCODE(err185_enter_cluster),
    case data_scene:get(SceneId) of
        #ets_scene{type = Type} when Type == ?SCENE_TYPE_ESCORT ->  %% 水晶护送场景可以互相切换
            case lib_player_check:check_list(Player, [action_free]) of
                {false, Code} -> skip;
                true-> 
                    mod_escort_kf:exit(ServerId, GuildId, RoleId), %% 切换场景相关数据处理
                    Code = 1
            end;
        _ ->  %% 野外场景才能进入
            case lib_player_check:check_list(Player, [action_free, is_transferable]) of
                {false, Code} -> skip;
                true->
                    Code = 1
            end
    end,
    if
        GuildId == 0 -> %% 公会玩法
            NewPlayer = Player,
            {ok, BinData} = pt_185:write(18502, [?ERRCODE(err403_join_a_guild)]),
            % ?PRINT("enter_scene Code:~p~n",[Code]),
            lib_server_send:send_to_uid(RoleId, BinData);
        Code =/= 1  ->
            NewPlayer = Player,
            {ok, BinData} = pt_185:write(18502, [Code]),
            % ?PRINT("enter_scene Code:~p~n",[Code]),
            lib_server_send:send_to_uid(RoleId, BinData);
        Scene == SceneId ->
            NewPlayer = Player,
            {ok, BinData} = pt_185:write(18502, [?ERRCODE(err120_already_in_scene)]),
            % ?PRINT("enter_scene Code:~p~n",[err120_already_in_scene]),
            lib_server_send:send_to_uid(RoleId, BinData);
        true ->
            NewPlayer = Player#player_status{action_lock = {utime:unixtime() + 5, Lock}},%% 加锁，防止多次进入
            mod_escort_kf:enter_scene(ServerNum, ServerId, GuildId, GuildName, Position, RoleId, RoleName, Scene, NeedOut)
    end,
    {ok, NewPlayer};

%% -----------------------------------------------------------------
%% 退出
%% -----------------------------------------------------------------
do_handle(18503, Player, []) ->
    % ?PRINT("Scene:~p, CopyId:~p, Pool:~p~n",[Player#player_status.scene, Player#player_status.copy_id, Player#player_status.scene_pool_id]),
    {IsOut, ErrCode} = lib_scene:is_transferable_out(Player),
    case IsOut of
        true ->
            #player_status{id = RoleId, server_id = ServerId, scene = Scene, guild = #status_guild{id = GuildId}} = Player, %% 可以切换pk状态的场景在退出时都需要将pk状态设置为和平模式
            case data_scene:get(Scene) of
                #ets_scene{type = Type} when Type == ?SCENE_TYPE_ESCORT ->
                    NewPs = lib_scene:change_scene(Player, 0, 0, 0, 0, 0, true, 
                        [{group, 0}, {change_scene_hp_lim, 100}, {pk, {?PK_PEACE, true}}]),
                    mod_escort_kf:exit(ServerId, GuildId, RoleId);
                _ ->
                    NewPs = Player
            end;
        false ->
            NewPs = Player
    end,
    {ok, BinData} = pt_185:write(18503, [ErrCode]),
    lib_server_send:send_to_uid(NewPs#player_status.id, BinData),
    {ok, NewPs};

%% -----------------------------------------------------------------
%% 召唤水晶
%% -----------------------------------------------------------------
do_handle(18504, Player, [Type]) ->
    % GoodsStatus = lib_goods_do:get_goods_status(), 
    #player_status{id = RoleId, scene = SceneId, server_id = ServerId, server_num = ServerNum, figure = #figure{name = RoleName},
        guild = #status_guild{id = GuildId, name = GuildName, position = Position}} = Player, 
    CheckList = [{cost, Type, Player},{config, Type}],
    case lib_escort:check(CheckList) of
        true ->
            {Scene, MonId, Cost, X, Y} = lib_escort:get_config_after_check(Type),
            HasJoin = mod_escort_local:judge_guild_has_join(ServerId, GuildId),
            if
                SceneId =/= Scene -> %% 指定场景召唤
                    NewPlayer = Player,
                    {ok, BinData} = pt_185:write(18504, [?ERRCODE(err185_cant_reborn_in_scene)]),
                    % ?PRINT("mon_reborn Code:~p~n",[err185_cant_reborn_in_scene]),
                    lib_server_send:send_to_uid(Player#player_status.id, BinData);
                HasJoin == true ->  %% 单次活动只能召唤一次
                    NewPlayer = Player,
                    {ok, BinData} = pt_185:write(18504, [?ERRCODE(err185_has_create_mon)]),
                    % ?PRINT("mon_reborn Code:~p~n",[err185_has_create_mon]),
                    lib_server_send:send_to_uid(Player#player_status.id, BinData);
                is_list(Cost) -> %% 消耗的不是公会资金
                    About = lists:concat(["Type", Type]),
                    case lib_goods_api:cost_object_list(Player, Cost, escort_cost, About) of
                        {false, Code, NewPlayer} -> 
                            {ok, BinData} = pt_185:write(18504, [Code]),
                            % ?PRINT("mon_reborn Code:~p~n",[Code]),
                            lib_server_send:send_to_uid(Player#player_status.id, BinData);
                        {true, NewPlayer} ->
                            mod_escort_kf:mon_reborn(ServerId, ServerNum, GuildId, GuildName, Type, Scene, X, Y, MonId, RoleId, RoleName, Position, Cost)
                    end;
                true -> %% 消耗公会资金
                    NewPlayer = Player,
                    case mod_guild:cost_gfunds(RoleId, Cost) of
                        true -> 
                            mod_escort_kf:mon_reborn(ServerId, ServerNum, GuildId, GuildName, Type, Scene, X, Y, MonId, RoleId, RoleName, Position, [{8,0,Cost}]);
                        _ ->
                            Code = ?ERRCODE(err400_gfunds_not_enough),
                            {ok, BinData} = pt_185:write(18504, [Code]),
                            % ?PRINT("mon_reborn Code:~p~n",[Code]),
                            lib_server_send:send_to_uid(Player#player_status.id, BinData)
                    end
            end;
        {false, Code} ->
            {ok, BinData} = pt_185:write(18504, [Code]),
            % ?PRINT("mon_reborn Code:~p~n",[Code]),
            lib_server_send:send_to_uid(Player#player_status.id, BinData),
            NewPlayer = Player
    end,
    {ok, NewPlayer};

%% -----------------------------------------------------------------
%% 获取排行榜数据
%% -----------------------------------------------------------------
do_handle(18505, Player, []) ->
    #player_status{id = RoleId} = Player,
    mod_escort_local:send_rank_info(RoleId),
    {ok, Player};

%% -----------------------------------------------------------------
%% 界面护送列表
%% -----------------------------------------------------------------
do_handle(18506, Player, []) ->
    #player_status{id = RoleId} = Player,
    mod_escort_local:send_escort_list(RoleId),
    {ok, Player};

%% -----------------------------------------------------------------
%% 公会内部排行榜
%% -----------------------------------------------------------------
do_handle(18507, Player, []) ->
    #player_status{id = RoleId, guild = #status_guild{id = GuildId}} = Player,
    mod_escort_local:send_role_rank(RoleId, GuildId),
    {ok, Player};

%% -----------------------------------------------------------------
%% 场景护送列表
%% -----------------------------------------------------------------
do_handle(18508, Player, [Scene]) ->
    #player_status{id = RoleId, guild = #status_guild{id = GuildId}} = Player,
    case data_scene:get(Scene) of
        #ets_scene{type = Type} when Type == ?SCENE_TYPE_ESCORT ->
            mod_escort_local:send_scene_show_list(RoleId, GuildId, Scene);
        _ ->
            % Code = ?ERRCODE(err185_not_in_scene)
            {ok, BinData} = pt_185:write(18508, [[],0,0]),
            lib_server_send:send_to_uid(Player#player_status.id, BinData)
    end,
    {ok, Player};

%% -----------------------------------------------------------------
%% 催促会长/副会长召唤水晶，召唤成员
%% -----------------------------------------------------------------
do_handle(18509, Player, [Notify]) ->
    #player_status{id = RoleId, scene = Scene, guild = #status_guild{id = GuildId}} = Player,
    mod_escort_local:notify_guild(RoleId, GuildId, Notify, Scene),
    {ok, Player};

%% -----------------------------------------------------------------
%% 护送数据
%% -----------------------------------------------------------------
do_handle(18510, Player, []) ->
    #player_status{id = RoleId, guild = #status_guild{id = GuildId}} = Player,
    mod_escort_local:get_guild_escort_info(RoleId, GuildId),
    {ok, Player};

%% -----------------------------------------------------------------
%% 积分数据
%% -----------------------------------------------------------------
do_handle(18511, Player, []) ->
    #player_status{id = RoleId, guild = #status_guild{id = GuildId}} = Player,
    mod_escort_local:get_guild_score_info(RoleId, GuildId),
    {ok, Player};

%% -----------------------------------------------------------------
%% 获取活动时间
%% -----------------------------------------------------------------
do_handle(18512, Player, []) ->
    #player_status{id = RoleId} = Player,
    mod_escort_local:get_act_time(RoleId),
    {ok, Player};

%% -----------------------------------------------------------------
%% 个人积分数据
%% -----------------------------------------------------------------
do_handle(18513, Player, []) ->
    #player_status{id = RoleId, guild = #status_guild{id = GuildId}} = Player,
    mod_escort_local:get_self_score_info(RoleId, GuildId),
    {ok, Player};

do_handle(_, Player, _) -> {ok, Player}.