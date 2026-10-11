%%%-------------------------------------------------------------------
%%% @doc
%%%
%%% @end
%%% @desc :特殊boss进程（野外boss单人场景）
%%%-------------------------------------------------------------------
-module(mod_special_boss).

-behaviour(gen_server).

-include("boss.hrl").
-include("common.hrl").
%% API
-export([start_link/0]).

-compile(export_all).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
    terminate/2, code_change/3]).

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

refresh_boss(BossType, RoleId, Scene) ->
	gen_server:cast(?MODULE, {'refresh_boss', BossType, RoleId, Scene}).

refresh_boss_one(BossType, BossId, RoleId, Scene) ->
	gen_server:cast(?MODULE, {'refresh_boss_one', BossType, BossId, RoleId, Scene}).

%% 进入
enter(RoleId, RoleLv, BossType, BossId, NeedOut) ->
    gen_server:cast(?MODULE, {'enter', RoleId, RoleLv, BossType, BossId, NeedOut}).

reconnect(RoleId, RoleLv, Scene, BossType) ->
	gen_server:cast(?MODULE, {'reconnect', RoleId, RoleLv, Scene, BossType}).

exit(RoleId, BossType, Scene, OldX, OldY) ->
	gen_server:cast(?MODULE, {'exit', RoleId, BossType, Scene, OldX, OldY}).

get_boss_info(RoleId, RoleLv, Sid, LastTaskId, BossType, LCount, AllCount, LTired, AllTired, Vit, LastVitTime, LCollectTimes, AllCollectTimes) ->
	gen_server:cast(?MODULE,{'get_boss_info', RoleId, RoleLv, Sid, LastTaskId, BossType, LCount, AllCount, LTired, AllTired, Vit, LastVitTime, LCollectTimes, AllCollectTimes}).

%%登出清理数据
boss_data_remove(RoleId, RoleLv, BossType) ->
	gen_server:cast(?MODULE, {'boss_data_remove', RoleId, RoleLv, BossType}).

boss_init(RoleId, RoleLv, BossType) ->
	gen_server:cast(?MODULE, {'boss_init', RoleId, RoleLv, BossType}).

lv_up(RoleId, RoleLv) ->
	gen_server:cast(?MODULE, {'lv_up', RoleId, RoleLv}).

boss_remind_op(RoleId, BossType, BossId, Remind) ->
	gen_server:cast(?MODULE, {'boss_remind_op', RoleId, BossType, BossId, Remind}).

boss_be_kill(ScenePoolId, BossType, BossId, AttrId, AttrName, BLWho, DX, DY, FirstAttr, MonArgs) ->
	gen_server:cast(?MODULE, {'boss_be_kill', ScenePoolId, BossType, BossId, AttrId, AttrName, BLWho, DX, DY, FirstAttr, MonArgs}).

online_num_map_update(OnlineNumMap) ->
	gen_server:cast(?MODULE, {'online_num_map_update', OnlineNumMap}).

gm_refresh_boss(RoleId, BossType) ->
    gen_server:cast(?MODULE, {'gm_refresh_boss', RoleId, BossType}).

init([]) ->
	BossMap = #{},
    {ok, #special_boss_state{boss_map = BossMap}}.

handle_call(Request, _From, State) ->
    case catch do_handle_call(Request, State) of
        {reply, Resoult, NewState} ->
            {reply, Resoult, NewState};
        Res ->
            ?ERR("Boss Msg Error:~p~n", [[Request, Res]]),
            {reply, ok, State}
    end.

handle_cast(Msg, State) ->
    case catch do_handle_cast(Msg, State) of
        {noreply, NewState} ->
            {noreply, NewState};
        Res ->
            ?ERR("Boss Msg Error:~p~n", [[Msg, Res]]),
            {noreply, State}
    end.

handle_info(Info, State) ->
    case catch do_handle_info(Info, State) of
        {noreply, NewState} ->
            {noreply, NewState};
        Res ->
            ?ERR("Boss Info Error:~p~n", [[Info, Res]]),
            {noreply, State}
    end.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

do_handle_call(_, State) ->
	{reply, ok, State}.

do_handle_cast({'boss_init', RoleId, RoleLv, BossType}, State) ->
	NewState = lib_special_boss_mod:boss_init(RoleId, RoleLv, BossType, State),
	{noreply, NewState};

do_handle_cast({'lv_up', RoleId, RoleLv}, State) ->
	NewState = lib_special_boss_mod:lv_up(State, RoleId, RoleLv),
	{noreply, NewState};

do_handle_cast({'refresh_boss', BossType, RoleId, Scene}, State) ->
	NewState = lib_special_boss_mod:refresh_boss(State, BossType, RoleId, Scene),
	{noreply, NewState};

do_handle_cast({'refresh_boss_one', BossType, BossId, RoleId, Scene}, State) ->
	NewState = lib_special_boss_mod:refresh_boss_one(State, BossType, BossId, RoleId, Scene, true),
	{noreply, NewState};

do_handle_cast({'enter', RoleId, RoleLv, BossType, BossId, NeedOut}, State) ->
	NewState = lib_special_boss_mod:enter(RoleId, RoleLv, BossType, BossId, NeedOut, State),
	{noreply, NewState};

do_handle_cast({'reconnect', RoleId, RoleLv, Scene, BossType}, State) ->
	NewState = lib_special_boss_mod:reconnect(RoleId, RoleLv, Scene, BossType, State),
	{noreply, NewState};

do_handle_cast({'exit', RoleId, BossType, Scene, OldX, OldY}, State) ->
	NewState = lib_special_boss_mod:exit(RoleId, BossType, Scene, OldX, OldY, State),
	{noreply, NewState};

do_handle_cast({'get_boss_info', RoleId, RoleLv, Sid, LastTaskId, BossType, LCount, AllCount, LTired, AllTired, Vit, LastVitTime, LCollectTimes, AllCollectTimes}, State) ->
	NewState = lib_special_boss_mod:get_boss_info(State, RoleId, RoleLv, Sid, LastTaskId, BossType, LCount, AllCount, LTired, AllTired, Vit, LastVitTime, LCollectTimes, AllCollectTimes),
	{noreply, NewState};

do_handle_cast({'boss_data_remove', RoleId, RoleLv, BossType}, State) ->
	NewState = lib_special_boss_mod:boss_data_remove(RoleId, RoleLv, BossType, State),
	{noreply, NewState};
do_handle_cast({'boss_remind_op', RoleId, BossType, BossId, Remind}, State) ->
	NewState = lib_special_boss_mod:boss_remind_op(State, RoleId, BossType, BossId, Remind),
	{noreply, NewState};

do_handle_cast({'boss_be_kill', ScenePoolId, BossType, BossId, AttrId, AttrName, BLWho, DX, DY, FirstAttr, MonArgs}, State) ->
	NewState = lib_special_boss_mod:boss_be_kill(State, ScenePoolId, BossType, BossId, AttrId, AttrName, BLWho, DX, DY, FirstAttr, MonArgs),
	{noreply, NewState};

do_handle_cast({'online_num_map_update', OnlineNumMap}, State) ->
    {noreply, State#special_boss_state{online_num_map = OnlineNumMap}};

do_handle_cast({'gm_refresh_boss', RoleId, BossType}, State) ->
    NewState = lib_special_boss_mod:gm_refresh_boss(State, RoleId, BossType),
    {noreply, NewState};

do_handle_cast(_, State) ->
	{noreply, State}.

do_handle_info({'boss_remind', RoleId, BossType, BossId}, State) ->
	NewState = lib_special_boss_mod:boss_remind(RoleId, BossType, BossId, State),
	{noreply, NewState};

do_handle_info({'boss_reborn_on_scene', RoleId, BossType, BossId}, State) ->
	NewState = lib_special_boss_mod:boss_reborn_on_scene(RoleId, BossType, BossId, State),
	{noreply, NewState};

do_handle_info({'boss_reborn', RoleId, BossType, BossId}, State) ->
	NewState = lib_special_boss_mod:boss_reborn(RoleId, BossType, BossId, State),
	{noreply, NewState};

do_handle_info(_, State) ->
	{noreply, State}.