%%------------------------------------------------------------------------------
%% @Module  : mod_scene_monitor
%% @Author  : jiexiaowen
%% @Email   : 13931430@qq.com
%% @Created : 2012.7.24
%% @Description: 场景监控
%%------------------------------------------------------------------------------
-module(mod_scene_monitor).
-behaviour(gen_server).
-export([start_link/1]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-include("scene.hrl").
-include("common.hrl").

start_link(SceneId) ->
    gen_server:start_link(?MODULE, [SceneId], []).

init([SceneId]) ->
	erlang:send_after(60*1000, self(), 'monitor'), %% 一分钟后开启检测
    {ok, SceneId}.

%% 默认匹配
handle_call(Event, _From, State) ->
    catch ?ERR("mod_scene_monitor:handle_call not match: ~p", [Event]),
    {reply, ok, State}.

%% 默认匹配
handle_cast(Event, State) ->
    catch ?ERR("mod_scene_monitor:handle_cast not match: ~p", [Event]),
    {noreply, State}.

%% 监控玩家是否离开
handle_info('monitor', State) ->
	erlang:send_after(30*1000, self(), 'monitor'),
    %% 清除场景残余数据
    case data_scene:get(State) of
        [] -> skip;
        #ets_scene{cls_type=?SCENE_CLS_TYPE_CENTER} -> skip;
        %% #ets_scene{id=Id} when Id==1001 -> 
        %%     clear_dirty_data(State); %% 新手场景停止怪物随机走路
        #ets_scene{type=?SCENE_TYPE_OUTSIDE} -> 
            %% mon_auto_move(State), %% 怪物自动走路
            clear_dirty_data(State);
        _ -> 
            clear_dirty_data(State)
    end,
	{noreply, State};

%% 默认匹配
handle_info(Info, State) ->
    catch ?ERR("mod_scene_monitor:handle_info not match: ~p", [Info]),
    {noreply, State}.

%% 服务器停止.
terminate(_R, _State) ->
    ok.

code_change(_OldVsn, State, _Extra)->
    {ok, State}.

%% =========================== 内部函数 ============================================
%% 清除场景残余数据
%% 1小时一次
clear_dirty_data(Id) ->
    N = case get(clear_dirty_data) of
        undefined -> 1;
        _N -> 
            case  _N > 10000000 of
                true  -> 1;
                false -> _N
            end
    end,
    %% 每小时检查一次
    case N rem 120 =:= 0 of
        true ->
            mod_scene_agent:get_scene_pid(Id) ! 'monitor';
        false ->
            skip
    end,
    put(clear_dirty_data, N + 1).

%% 处理怪物移动
%% mon_auto_move(Id) ->
%%     AidList = get_aid_list(Id),
%%     F = fun(Aid) when is_pid(Aid) ->
%%             timer:sleep(500),
%%             Aid ! 'auto_move';
%%         (_Aid) ->         
%%             ?INFO("mon_auto_move:~p~n", [{Id, _Aid}])
%%     end,
%%     spawn(fun() -> lists:map(F, AidList) end),
%%     ok.

%% 获取怪物
%% get_aid_list([]) -> [];
%% get_aid_list(Id) ->
%%     Key = {timer_mon_get_mon, Id},
%%     OldAlist = get(Key),
%%     case OldAlist == undefined orelse OldAlist == [] of
%%         true ->
%%             case lib_mon:get_scene_mon(Id, 0, [], #scene_object.aid) of
%%                 Alist when is_list(Alist) -> 
%%                     ASubList = lists:sublist(ulists:list_shuffle(Alist), 40),
%%                     put(Key, ASubList),
%%                     ASubList;
%%                 _ -> []
%%             end;
%%         _ ->
%%             OldAlist
%%     end.
