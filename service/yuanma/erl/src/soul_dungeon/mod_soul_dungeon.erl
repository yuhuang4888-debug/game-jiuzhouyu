%%%-----------------------------------
%%% @Module      : mod_soul_dungeon
%%% @Author      : chenyiming
%%% @Email       : chenyiming@suyougame.com
%%% @Created     : 16. 十一月 2018 15:02
%%% @Description : 聚魂副本
%%%-----------------------------------
-module(mod_soul_dungeon).
-author("chenyiming").

%% API
-compile(export_all).


-include("common.hrl").
-include("predefine.hrl").
-include("soul_dungeon.hrl").


%%启动
start_link() ->
	gen_server:start_link({global, ?MODULE}, ?MODULE, [], []).


init([]) ->
	State = lib_soul_dungeon:get_record_from_db(),
%%	?MYLOG("cym", "mod_soul_dungeon init   State ~p ~n", [State]),
	{ok, State}.


%%-------------------------------------------- 接口方法----------------------------------------start
%%quik_create_mon_cast(RoleId, DunPid) ->
%%	gen_server:cast({global, ?MODULE}, {quik_create_mon_cast, RoleId, DunPid}).
%%增加能量和击杀
add_power_and_kill_mon(RoleId, Power, KillNum) ->
%%	?MYLOG("cym", "log1 ~n", []),
	gen_server:cast({global, ?MODULE}, {'add_power_and_kill_mon', RoleId, Power, KillNum}).
%%进入副本
add_role_into_dungeon(RoleId) ->
	gen_server:cast({global, ?MODULE}, {'add_role_into_dungeon', RoleId}).
%%获取击杀
get_grade(RoleId) ->
	gen_server:cast({global, ?MODULE}, {'get_grade', RoleId}).
%%使用技能 暂时不能用
use_skill(RoleId, SkillId, DunPId) ->
	gen_server:cast({global, ?MODULE}, {'use_skill', RoleId, SkillId, DunPId}).
%%清理(主要是能量和击杀)
clear(RoleId) ->
	gen_server:cast({global, ?MODULE}, {'clear', RoleId}).
%%挑战失败
battle_fail(RoleId, DropList, DunId, SceneId) ->
	gen_server:cast({global, ?MODULE}, {'battle_fail', RoleId, DropList, DunId, SceneId}).
%%挑战成功
battle_success(RoleId, DropList, DunId, SceneId, WaveNum) ->
	gen_server:cast({global, ?MODULE}, {'battle_success', RoleId, DropList, DunId, SceneId, WaveNum}).


sweep(RoleId, DunId, Time, BossNum, Wave, Auto) ->
	gen_server:cast({global, ?MODULE}, {'sweep', RoleId, DunId, Time, BossNum, Wave, Auto}).

%%-------------------------------------------- 接口方法----------------------------------------end


%%-------------------------------------------- handle方法----------------------------------------start
handle_cast(Msg, State) ->
	case catch do_handle_cast(Msg, State) of
		{ok, NewState} ->
			{noreply, NewState};
		Err ->
			?ERR("handle_cast Msg:~p error:~p~n", [Msg, Err]),
			{noreply, State}
	end.


%%do_handle_cast({quik_create_mon_cast, RoleId, DunPid}, State) ->
%%	NewState = lib_soul_dungeon:quik_create_mon_cast(RoleId,  DunPid , State),
%%	{ok, NewState};

%% -----------------------------------------------------------------
%% @desc     功能描述  加能量
%% @param    参数
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
do_handle_cast({'add_power_and_kill_mon', RoleId, Power, KillNum}, State) ->
%%	?MYLOG("cym", "log1------------------------- ~n", []),
	NewState = lib_soul_dungeon:add_power_and_kill_mon(RoleId, Power, KillNum, State),
	{ok, NewState};

%% -----------------------------------------------------------------
%% @desc     功能描述  进入副本
%% @param    参数
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
do_handle_cast({'add_role_into_dungeon', RoleId}, State) ->
	NewState = lib_soul_dungeon:add_role_into_dungeon(RoleId, State),
	{ok, NewState};

%% -----------------------------------------------------------------
%% @desc     功能描述  获取评价
%% @param    参数
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
do_handle_cast({'get_grade', RoleId}, State) ->
	lib_soul_dungeon:get_grade(RoleId, State),
	{ok, State};

%% -----------------------------------------------------------------
%% @desc     功能描述  获取评价
%% @param    参数
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
do_handle_cast({'use_skill', RoleId, SkillId, DunPId}, State) ->
	lib_soul_dungeon:use_skill(RoleId, SkillId, DunPId, State),
	{ok, State};


%% -----------------------------------------------------------------
%% @desc     功能描述  挑战失败
%% @param    参数
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
do_handle_cast({'battle_fail', RoleId, DropList, DunId, SceneId}, State) ->
	NewState = lib_soul_dungeon:battle_fail(RoleId, DropList, State, DunId, SceneId),
	{ok, NewState};

%% -----------------------------------------------------------------
%% @desc     功能描述  挑战成功
%% @param    参数
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
do_handle_cast({'battle_success', RoleId, DropList,  DunId, SceneId, WaveNum}, State) ->
	NewState = lib_soul_dungeon:battle_success(RoleId, DropList, State,  DunId, SceneId, WaveNum),
	{ok, NewState};

%% -----------------------------------------------------------------
%% @desc     功能描述  清理能量和击杀
%% @param    参数
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
do_handle_cast({'clear', RoleId}, State) ->
	{NewState, _KillNum} = lib_soul_dungeon:clear(RoleId, State),
	{ok, NewState};

do_handle_cast({'sweep', RoleId, DunId, Time, BossNum, Wave, Auto}, #soul_dungeon{role_dungeon_list = _List} = State) ->
%%	KillNum =
%%		case lists:keyfind(RoleId, #role_soul_dungeon.role_id, List) of
%%			#role_soul_dungeon{max_kill = MaxKill} ->
%%				MaxKill;
%%			_ ->
%%				0
%%		end,
	lib_player:apply_cast(RoleId, ?APPLY_CALL_SAVE, lib_soul_dungeon, sweep,  [DunId, Time, BossNum, Wave, Auto]),
	{ok, State};

do_handle_cast(_, _State) ->
	{ok, _State}.


%%-------------------------------------------- handle方法------------------------------------------end