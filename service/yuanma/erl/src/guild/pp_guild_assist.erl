%% ---------------------------------------------------------------------------
%% @doc pp_guild_assist.erl

%% @author  
%% @email  
%% @since  
%% @deprecated 公会协助
%% ---------------------------------------------------------------------------
-module(pp_guild_assist).
-export([handle/3]).

-include("server.hrl").
-include("common.hrl").
-include("guild.hrl").
-include("errcode.hrl").
-include("rec_assist.hrl").
-include("def_module.hrl").

%% 发起协助
handle(40401, PS, [Type, SubType, TargetCfgId, TargetId]) ->
    case lib_guild_assist:launch_assist(PS, Type, SubType, TargetCfgId, TargetId) of 
        {ok, NewPS} ->
            {ok, NewPS};
        {false, {ErrCode, ErrAgrs}} ->
            lib_game:send_error_to_sid(PS#player_status.sid, {ErrCode, ErrAgrs});
        {false, Res} ->
            lib_server_send:send_to_sid(PS#player_status.sid, pt_404, 40401, [Res, 0, Type, SubType, TargetCfgId, TargetId])
    end;

%% 协助他人
handle(40402, PS, [AssistId, Type]) ->
    case lib_guild_assist:assist_player(PS, AssistId) of 
        {ok, NewPS} ->
            {ok, NewPS};
        {false, {ErrCode, ErrAgrs}, NewPS} ->
            lib_game:send_error_to_sid(PS#player_status.sid, {ErrCode, ErrAgrs}),
            {ok, NewPS};
        {false, Res, NewPS} ->
            lib_server_send:send_to_sid(PS#player_status.sid, pt_404, 40402, [Res, AssistId, Type]),
            {ok, NewPS}
    end;

%% 取消协助
handle(40403, PS, [AssistId]) ->
    {ok, Res, NewPS} = lib_guild_assist:cancel_assist(PS, AssistId),
    case Res == ?SUCCESS of     
        true ->
            ok;
        _ ->
            lib_server_send:send_to_sid(PS#player_status.sid, pt_404, 40403, [Res, 1, AssistId, 0])
    end,
    {ok, NewPS};

%% 今日协助成功次数
handle(40404, PS, []) ->
    #player_status{id = RoleId, sid = Sid} = PS,
    %?PRINT("40404 :~p~n", [PS#player_status.guild_assist]),
    Count = mod_daily:get_count(RoleId, ?MOD_GUILD_ASSIST, 1),
    lib_server_send:send_to_sid(Sid, pt_404, 40404, [Count]);

%% 求助列表信息
handle(40405, PS, []) ->
    #player_status{id = RoleId, sid = Sid, guild = #status_guild{id = GuildId}} = PS,
    case GuildId > 0 of 
        true ->
            mod_guild_assist:send_guild_assist_list(RoleId, GuildId, Sid);
        _ ->
            lib_server_send:send_to_sid(Sid, pt_404, 40405, [])
    end;


%% 获取当前正在协助的对象信息
handle(40408, PS, []) ->
    #player_status{id = RoleId, sid = Sid, guild_assist = #status_assist{assist_id = AssistId, assist_process = AssistProcess}} = PS,
    case AssistId > 0 andalso AssistProcess == 1 of 
        true ->
            mod_guild_assist:send_my_assist_info(AssistId, RoleId, Sid);
        _ ->
            ok
    end;

handle(_Cmd, _Player, _Data) ->
    {error, atom_to_list(?MODULE) ++ " no match"}.