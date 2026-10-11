%%%------------------------------------
%%% @Module  : mod_scene_agent_call
%%% @Author  : xyao
%%% @Email   : jiexiaowen@gmail.com
%%% @Created : 2012.05.18
%%% @Description: 场景管理call处理
%%%------------------------------------
-module(mod_scene_agent_call).
-export([handle_call/3]).
-include("scene.hrl").
-include("common.hrl").

%%显示本场景人员
handle_call({'scene_num'} , _FROM, State) ->
    Num = length(lib_scene_agent:get_scene_user()),
    {reply, Num, State};

%% 获取当前九宫格的玩家与怪物，gm秘籍调用,测试调用
handle_call({'scene_area_all', X, Y, CopyId}, _FROM, State) ->
    Area = lib_scene_calc:get_the_area(X, Y),
    ?PRINT("X ~p , Y ~p , Area ~w ~n", [X, Y, Area]),
    MonList = lib_scene_object_agent:get_all_area(Area, CopyId),
    PlayerList = lib_scene_agent:get_area(Area, CopyId),
    {reply, {ok, MonList, PlayerList}, State};

%% 获取玩家主动技能被动技能，gm秘籍调用,测试调用
handle_call({'get_player_skill', RoleId}, _FROM, State) ->
    case lib_scene_agent:get_user(RoleId) of
        #ets_scene_user{skill_list = SkillList, skill_passive = PassSkillList} ->
            {reply, {ok, SkillList, PassSkillList}, State};
        _ -> {reply, error, State}
    end;

handle_call({'get_player_attr', RoleId}, _FROM, State) ->
    case lib_scene_agent:get_user(RoleId) of
        #ets_scene_user{battle_attr = BattleAttr} ->
            {reply, {ok, BattleAttr}, State};
        _ -> {reply, error, State}
    end;

%% 统一模块+过程调用(call)
handle_call({'apply_call', Module, Method, Args}, _From, State) ->
    {reply, apply(Module, Method, Args), State};

handle_call({'apply_call_with_state', Module, Method, Args}, _From, State) ->
    {reply, apply(Module, Method, Args++[State]), State};

%% 默认匹配
handle_call(Event, _From, Status) ->
    catch ?ERR("mod_scene_agent_call:handle_call not match: ~p", [Event]),
    {reply, ok, Status}.
