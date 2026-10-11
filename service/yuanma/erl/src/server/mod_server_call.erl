%%%------------------------------------
%%% @Module  : mod_server_call
%%% @Author  : xyao
%%% @Email   : jiexiaowen@gmail.com
%%% @Created : 2011.12.16
%%% @Description: 角色call处理
%%%------------------------------------
-module(mod_server_call).
-export([handle_call/3]).
-include("common.hrl").
-include("predefine.hrl").
-include("server.hrl").

%%==========基础功能base============


%%获取用户信息
handle_call('base_data', _from, Status) ->
    {reply, Status, Status};

%% 调用模块函数
handle_call({'apply_call', CallType, Moudle, Method, Args},  _From, Status) ->
    if
        CallType == ?APPLY_CALL -> NewArgs = Args;
        CallType == ?APPLY_CALL_STATUS orelse
        CallType == ?APPLY_CALL_SAVE -> NewArgs = [Status|Args]
    end,
    case apply(Moudle, Method, NewArgs) of        
        NewStatus when is_record(NewStatus, player_status) ->
            {reply, true, NewStatus};
        {Reply, NewStatus} when is_record(NewStatus, player_status) ->
            {reply, Reply, NewStatus};        
        {false, Reply, NewStatus} when is_record(NewStatus, player_status) ->
            {reply, Reply, NewStatus};
        _Info when CallType == ?APPLY_CALL_SAVE ->
            ?ERR("mod_server_call apply_call error CallType = ~p, Moudle = ~p, Method = ~p, Args = ~p, Reason = ~p~n",
                       [CallType, Moudle, Method, Args, _Info]),
            throw(player_status),
            {reply, false, Status};
        Reply ->
            {reply, Reply, Status}
    end;

%% 按照格式（ResultForm）返回记录中的字段集合
handle_call({'get_form_data', ResultForm}, _From, Status) ->
    Result = util:record_return_form(Status, ResultForm),
    {reply, Result, Status};

%% 默认匹配
handle_call(Event, _From, Status) ->
    catch ?ERR("mod_server:handle_call not match: ~p", [Event]),
    {reply, ok, Status}.
