%%% ------------------------------------------------------------------------------------------------
%%% @doc            lib_gm_stop.erl
%%% @author         kyd
%%% @email          kuangyaode@qq.com
%%% @created        2021-12-22
%%% @modified
%%% @description    秘籍关闭/开启功能入口
%%% ------------------------------------------------------------------------------------------------
-module(lib_gm_stop).

-include("def_module.hrl").
-include("errcode.hrl").
-include("server.hrl").

-export([gm_change_mod/3, get_mod_states/0, get_mod_state/2]).

-export([check_gm_close_act/2, open/2]).

% -compile(export_all).

%% 如需要添加功能接口，则需要添加以下内容
%% 1.功能关闭函数映射宏定义(?MOD_CLOSE_FUNC_M)
%% 2.功能开启函数映射(可选)(?MOD_OPEN_FUNC_M)
%% 3.共用接口的特殊功能(可选)(?GEN_MODS)
%% 4.对应功能的活动关闭清理/开启函数，入口检查代码

%% 功能关闭函数映射
-define(MOD_CLOSE_FUNC_M, #{
        {?MOD_KF_SANCTUM, 0}                   => {lib_kf_sanctum, do_close_act}            % 永恒圣殿
    ,   {?MOD_BOSS, 0}                         => {lib_boss_api, do_gm_close_act}           % 本服boss
    ,   {?MOD_GUILD_ACT, ?MOD_GUILD_ACT_PARTY} => {lib_guild_feast, force_quit_scene}       % 公会晚宴
    ,   {?MOD_DECORATION_BOSS, 0}              => {lib_decoration_boss, gm_clear_user}      % 幻饰boss
    ,   {?MOD_DUNGEON, 0}                      => {lib_dungeon, force_quit_scene}           % 副本
    ,   {?MOD_DRAGON_LANGUAGE_BOSS, 0}         => {lib_dragon_language_boss, gm_clear_user} % 龙语boss
    ,   {?MOD_SEACRAFT_DAILY, 0}               => {lib_seacraft_daily, force_quit_scene}    % 海战日常
    ,   {?MOD_KF_1VN, 0}                       => {lib_kf_1vN, gm_clear_user}               % 跨服1vN
    }
).

%% 功能开启函数映射
-define(MOD_OPEN_FUNC_M, #{
        {?MOD_DECORATION_BOSS, 0} => {lib_decoration_boss, gm_open_act}
    ,   {?MOD_KF_1VN, 0}          => {lib_kf_1vN, gm_open_lock}
    }
).

%% 支持关闭/开启的功能模块
-define(ALL_MODS, maps:keys(?MOD_CLOSE_FUNC_M)).

%% 不同子类型调用同一接口的功能
-define(GEN_MODS, [?MOD_BOSS, ?MOD_DUNGEON]).

%%% ============================================== api =============================================

%% -------------------------------------------------------------------------------------------------
%% @doc 关闭/开启指定功能入口
%%      注：一律本服执行，如跨服活动或需要修改关闭/开启多个服入口，要选中多个服执行。
-spec
gm_change_mod(ModId, SubId, State) -> ok when
    ModId :: integer(),
    SubId :: integer(),
    State :: ?GM_CLOSE_MOD | ?GM_OPEN_MOD.
%% -------------------------------------------------------------------------------------------------
gm_change_mod(ModId, SubId, State) ->
    case lists:member({ModId, SubId}, ?ALL_MODS) of
        false -> error_not_support;
        true ->
            case get_mod_state(ModId, SubId) of
                State -> error_same_state;
                _ ->
                    do_gm_change_mod(ModId, SubId, State)
            end
    end.

%% -------------------------------------------------------------------------------------------------
%% @doc 获取ets表内记录的功能状态
-spec
get_mod_states() -> [{ModId, SubId, State},...] when
    ModId :: integer(),
    SubId :: integer(),
    State :: ?GM_CLOSE_MOD | ?GM_OPEN_MOD.
%% -------------------------------------------------------------------------------------------------
get_mod_states() ->
    ModInfos = ets:tab2list(?ETS_FUNC_GM_CLOSE),
    [{ModId, SubId, State} || #ets_func_gm_close{key = {ModId, SubId}, status = State} <- ModInfos].

%% -------------------------------------------------------------------------------------------------
%% @doc 获取单个功能的状态
-spec
get_mod_state(ModId, SubId) -> State when
    ModId :: integer(),
    SubId :: integer(),
    State :: ?GM_CLOSE_MOD | ?GM_OPEN_MOD.
%% -------------------------------------------------------------------------------------------------
get_mod_state(ModId, SubId) ->
    case ets:lookup(?ETS_FUNC_GM_CLOSE, {ModId, SubId}) of
        [#ets_func_gm_close{status = ?GM_CLOSE_MOD}] -> ?GM_CLOSE_MOD;
        _ -> ?GM_OPEN_MOD
    end.

%% -------------------------------------------------------------------------------------------------
%% @doc 检查功能是否开启
-spec
check_gm_close_act(ModId, SubId) -> true | {false, ErrCode} when
    ModId :: integer(),
    SubId :: integer(),
    ErrCode :: integer().
%% -------------------------------------------------------------------------------------------------
check_gm_close_act(ModId, SubId) ->
    case get_mod_state(ModId, SubId) of
        ?GM_CLOSE_MOD -> {false, ?ERR_GM_STOP};
        _ -> true
    end.

%%% ====================================== private functions =======================================

%% 修改目标功能的状态
%% 派发到功能代码处理 更新ets表
%% @return ok
do_gm_change_mod(ModId, SubId, ?GM_CLOSE_MOD) ->
    send_close_tv(ModId),
    % 派发到对应功能代码处理
    {M, F} = get_close_func(ModId, SubId),
    M:F(ModId, SubId),
    % 更新ets表
    ModInfo = #ets_func_gm_close{
        key = {ModId, SubId}
    ,   mod = ModId
    ,   sub_mod = SubId
    ,   status = ?GM_CLOSE_MOD
    },
    ets:insert(?ETS_FUNC_GM_CLOSE, ModInfo),
    ok;

do_gm_change_mod(ModId, SubId, ?GM_OPEN_MOD) ->
    send_open_tv(ModId),
    % 派发到对应功能代码处理
    {M, F} = get_open_func(ModId, SubId),
    M:F(ModId, SubId),
    % 更新ets表
    ets:delete(?ETS_FUNC_GM_CLOSE, {ModId, SubId}),
    ok.

%% 获取相应的处理函数
%% @return {M, F}
get_close_func(ModId, SubId) ->
    case lists:member(ModId, ?GEN_MODS) of
        true ->
            maps:get({ModId, 0}, ?MOD_CLOSE_FUNC_M);
        false ->
            maps:get({ModId, SubId}, ?MOD_CLOSE_FUNC_M)
    end.

get_open_func(ModId, SubId) ->
    case lists:member(ModId, ?GEN_MODS) of
        true ->
            maps:get({ModId, 0}, ?MOD_OPEN_FUNC_M, {?MODULE, open});
        false ->
            maps:get({ModId, SubId}, ?MOD_OPEN_FUNC_M, {?MODULE, open})
    end.

%% 广播通知
send_close_tv(ModId) ->
    lib_chat:send_TV({all}, ?MOD_0, 7, [data_module:get(ModId)]).

send_open_tv(ModId) ->
    lib_chat:send_TV({all}, ?MOD_0, 8, [data_module:get(ModId)]).

%% 空函数 部分功能开启不需要执行特定代码
open(_, _) -> ok.