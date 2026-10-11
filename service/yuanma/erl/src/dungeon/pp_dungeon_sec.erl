%% ---------------------------------------------------------------------------
%% @doc pp_dungeon.erl

%% @author  hjh
%% @email  hejiahua@163.com
%% @since  2019-05-27
%% @deprecated 副本协议2处理
%% ---------------------------------------------------------------------------
-module(pp_dungeon_sec).
-export([handle/3]).

-include("server.hrl").
-include("dungeon.hrl").
-include("common.hrl").

handle(61101, Player, []) ->
    lib_dungeon_learn_skill:send_info(Player);

handle(61102, Player, [DunId, DemonIdList]) ->
    lib_dun_demon:enter(DunId, DemonIdList, Player);

handle(61103, Player, []) ->
    lib_dun_demon:get_current_dun(Player);

handle(61104, Player, [DunId]) ->
    lib_dun_demon:sweep(Player, DunId);

handle(61105, Player, [Level]) ->
    lib_dungeon_partner:get_level_info(Player, Level);


handle(61106, Player, [Level]) ->
    lib_dungeon_partner:get_stage_info(Player, Level);


%%handle(61107, Player, [DunId]) ->
%%    lib_dungeon_partner:get_first_success(Player, DunId);

handle(61108, Player, [Level, Score]) ->
    NewPs = lib_dungeon_partner:get_stage_reward(Player, Level, Score),
    {ok, NewPs};


handle(61109, Player, [Level]) ->
    NewPs = lib_dungeon_partner:sweep(Player, Level),
    {ok, NewPs};


handle(61110, Player, []) ->
    #player_status{dungeon = StatusDun, copy_id = CopyId, id = RoleId} = Player,
    #status_dungeon{dun_id = DunId} = StatusDun,
    case data_dungeon:get(DunId)  of
        #dungeon{type = ?DUNGEON_TYPE_PARTNER_NEW} ->
            erlang:send(CopyId, {get_partner_mon_msg, RoleId});
        _ ->
            skip
    end,
    {ok, Player};



%% 玩家完成副本切换， 只有延迟加载的副本才要发这个协议
handle(61111, Player, []) ->
    #player_status{dungeon = StatusDun, copy_id = CopyId, id = RoleId} = Player,
    #status_dungeon{dun_id = DunId} = StatusDun,
    case data_dungeon:get(DunId)  of
        #dungeon{type = DunType} ->
            case lists:member(DunType, ?DELAY_DUN_LIST) of
                true ->
                    erlang:send(CopyId, {role_finish_enter_dun, RoleId}),
                    mod_dungeon:send_dungeon_info(CopyId, Player#player_status.sid);
                _ ->
                    ok
            end;
        _ ->
            skip
    end,
    {ok, Player};

%% 领取副本通用奖励
handle(61112, Player, [RewardArgsList]) ->
    #player_status{id = RoleId, figure = Figure} = Player,
    lib_dungeon:receive_dun_reward(RoleId, Figure, RewardArgsList),
    {ok, Player};

%% 副本通用奖励列表
handle(61113, Player, [DunType]) ->
    lib_dungeon:send_dun_reward_info(Player#player_status.id, DunType);

%% 符文本领取每日奖励
handle(61114, Player, []) -> 
    lib_dungeon_rune:receive_daily_reward(Player);

handle(61115, Player, []) -> 
    lib_dungeon_rune:send_status(Player);

handle(61116, Player, [Level]) -> 
    lib_dungeon_rune:unlock_level(Player, Level);

handle(61119, _Player, []) -> skip;
    % case lib_dungeon:is_on_dungeon(Player) of
    %     true -> mod_dungeon:trigger_add_exp(CopyId, RoleId);
    %     false -> skip
    % end;

%% 限时爬塔的面板信息
handle(61117, Player, []) ->
    lib_dungeon_limit_tower:send_panel_info(Player);

%% 限时爬塔大奖领取
handle(61118, Player, [Round]) ->
    lib_dungeon_limit_tower:get_big_reward(Player, Round);

%% 资源副本的一键操作
handle(61120, Player, [Operate]) ->
    lib_dungeon_resource:material_one_operate(Player, Operate);

handle(61121, Player, [DunType]) ->
    case DunType == 0 orelse lib_dungeon_resource:is_resource_dungeon_type(DunType) of
        true ->
            lib_dungeon_resource:get_dungeon_count(Player, DunType);
        _ -> skip
    end;

handle(_Cmd, _Player, _Data) ->
    {error, atom_to_list(?MODULE) ++ " no match"}.
