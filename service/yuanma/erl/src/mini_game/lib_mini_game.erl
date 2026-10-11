%%% ---------------------------------------------------------------------------
%%% @doc            lib_mini_game.erl
%%% @author         kyd
%%% @email          kuangyaode@qq.com
%%% @created        2021-04-19
%%% @description    小游戏玩家库函数
%%% ---------------------------------------------------------------------------
-module(lib_mini_game).

-include("common.hrl").
-include("def_module.hrl").
-include("figure.hrl").
-include("guild.hrl").
-include("guild_feast.hrl").
-include("mini_game.hrl").
-include("server.hrl").

-export([
    game_start/2            % 游戏开始
    ,game_start2/1
    ,game_start_fail/1
    ,game_feedback/2        % 游戏信息反馈
    ,send_game_rank_list/2  % 实时排行榜
    ,reconnect/1			% 断线重连
    ,game_stop/2            % 主动结束游戏

    ,set_board/2            % 棋盘设置
]).

-export([
    get_game_duration/1
    ,get_code_module/1
]).

%%% ================================ 协议相关 ================================

%% 游戏开始(手动/自动)
%% 注:
%%  手动开启时,经过39901协议,再调用此函数
%%  自动开启时,由某活动进程cast到玩家进程,再调用此函数
%% @return NewPS | {false, ErrCode}
game_start(PS, [GameType, ModuleId, SubId]) ->
    Mod = get_code_module(GameType),
    PlayerInfo = trans_ps_to_game_player(PS),
    Mod:start([PlayerInfo, ModuleId, SubId]).

game_start2([GameType, RoleId, EndTime]) ->
    Mod = get_code_module(GameType),
    Mod:start2([RoleId, EndTime]).

%% 启动失败(因超时或其他原因)
game_start_fail([GameType, RoleId]) ->
    Mod = get_code_module(GameType),
    Mod:start_fail([RoleId]).

%% 断线重连
%% @return {ok, NewPS} | {next, NewPS}
reconnect(PS) ->
    #player_status{id = RoleId, scene = _Scene} = PS,
    % 对可能需要重连的小游戏都进行调用,自动适配到仍存在的小游戏进程
    mod_note_crash:reconnect([RoleId]),
    mod_rhythm_talent:reconnect([RoleId]),
    {ok, PS}.

%% 游戏信息反馈
game_feedback(PS, [GameType, ModuleId, SubId, InfoList]) ->
    Mod = get_code_module(GameType),
    #player_status{id = RoleId} = PS,
    Mod:game_feedback([RoleId, ModuleId, SubId, InfoList]).

%% 实时排行榜
send_game_rank_list(PS, [GameType, ModuleId, SubId]) ->
    case {ModuleId, SubId} of
        {?MOD_GUILD_ACT, ?MOD_GUILD_ACT_PARTY} ->
            PlayerInfo = lib_guild_feast:trans_ps_to_gfeast_player(PS),
            mod_guild_feast_mgr:send_game_rank_list(PlayerInfo, GameType);
        _ ->
            skip
    end.

%% 主动结束游戏
game_stop(PS, [GameType]) ->
    Mod = get_code_module(GameType),
    #player_status{id = RoleId} = PS,
    Mod:stop(RoleId).

%% ---------------------------------
%% 小游戏-音符碰撞
%% ---------------------------------

%% 棋盘初始化
set_board(PS, Args) ->
    #player_status{id = RoleId} = PS,
    mod_note_crash:set_board([RoleId | Args]).

%%% ================================ 工具函数 ================================

%% 组织玩家信息
%% @return #mini_game_player{}
trans_ps_to_game_player(PS) ->
    #player_status{id = RoleId, figure = Figure, guild = Guild} = PS,
    #figure{lv = Lv, name = RoleName, picture = Pic, picture_ver = PicVer} = Figure,
    #status_guild{id = GuildId, name = GuildName} = Guild,
    #mini_game_player{
        id 		= RoleId,
        lv		= Lv,
        name 	= RoleName,
        pic     = Pic,
        pic_ver	= PicVer,
        gid		= GuildId,
        gname	= GuildName
    }.

%% 根据游戏类型获取对应代码模块
get_code_module(GameType) ->
    case GameType of
        ?GAME_NOTE_CRASH ->
            mod_note_crash;
        ?GAME_RHYTHM_TALENT ->
            mod_rhythm_talent;
        _ ->
            undefined
    end.

%% 获取游戏默认时长
get_game_duration(GameType) ->
    case GameType of
        ?GAME_NOTE_CRASH ->
            ?DUR_NOTE_CRASH;
        ?GAME_RHYTHM_TALENT ->
            ?DUR_RHYTHM_TALENT;
        _ ->
            0
    end.