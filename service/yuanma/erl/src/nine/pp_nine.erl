%% ---------------------------------------------------------------------------
%% @doc pp_nine.erl

%% @author  hjh
%% @email  hejiahua@163.com
%% @since  2018-09-30
%% @deprecated 九魂圣殿
%% ---------------------------------------------------------------------------
-module(pp_nine).
-export([handle/3]).

-include("server.hrl").
-include("predefine.hrl").

%% 获取状态
handle(13500, #player_status{id = RoleId}, [])->
    mod_nine_local:send_nine_info(RoleId);

%% 战场日志
handle(13501, #player_status{id = RoleId, server_id = ServerId}, _) ->
    mod_nine_local:send_nine_rank_list(RoleId, ServerId);

%% 参战
handle(13502, Player, [])->
    #player_status{id = RoleId} = Player,
    NewPlayer = case lib_nine:apply_war(Player) of
        {ok, Player0} ->
            StrongPs = lib_to_be_strong:update_data_nine(Player0),                                
            StrongPs;
        {false, ErrCode}->
            {ok, BinData} = pt_135:write(13502, [ErrCode]),
            lib_server_send:send_to_uid(RoleId, BinData),
            Player
    end,
    {ok, NewPlayer};

%% 小面板信息
handle(13503, Player, []) ->
    #player_status{id = RoleId, scene = SceneId} = Player,
    case lib_nine_api:is_nine_scene(SceneId) of
        false -> skip;
        true ->
            mod_nine_local:get_battle_info(RoleId),
            mod_nine_center:cast_center([{apply, get_battle_info, [RoleId]}])
    end,
    {ok, Player};

%% 秘宝信息
handle(13504, Player, [])->
    #player_status{id = RoleId, server_id = ServerId} = Player,
    mod_nine_local:send_flag_info(RoleId, ServerId),
    ok;

%% 离开
handle(13505, Player, [])->
    lib_nine:quit(Player);

handle(13510, Player, []) ->
    ok;

handle(_Cmd, _Player, _Data) ->
    {error, atom_to_list(?MODULE) ++ " no match"}.