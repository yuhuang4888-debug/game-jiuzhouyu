%%-----------------------------------------------------------------------------
%% @Module  :       mod_custom_act_task
%% @Author  :       xlh
%% @Email   :       
%% @Created :       2020-05-26
%% @Description:    活动任务 -- 幸运寻宝
%%-----------------------------------------------------------------------------


-module(mod_custom_act_task).

-behaviour(gen_server).

-include("common.hrl").
-include("custom_act.hrl").
-include("def_fun.hrl").
-include("errcode.hrl").
% -include("custom_act_task.hrl").
%% API
-export([start_link/0]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
    terminate/2, code_change/3]).

-export([
    trigger/5
    ,clear_data/2
    ,get_act_info/4
    ,get_reward/4
    ]).


-record(act_task_state, {
        init_ref = undefined,   %% 初始化定时器
        act_data = #{}          %% {Type, SubType, Grade} => [{RoleId, Process, GetNum, Time}]
    }).

-define(SQL_SELECT_DATA,  <<"SELECT `type`, `subtype`, `grade`, `role_id`, `process`, 
        `get_num`, `time` from `custom_act_task`">>).

-define(SQL_DELETE_DATA,  <<"DELETE FROM `custom_act_task` WHERE `type` = ~p and subtype = ~p">>).
-define(SQL_DELETE_DATA_ROLE,  <<"DELETE FROM `custom_act_task` WHERE `type` = ~p and subtype = ~p and grade = ~p and role_id = ~p">>).
-define(SQL_REPLACE_DATA, <<"REPLACE INTO `custom_act_task` (`type`, `subtype`, `grade`, 
        `role_id`, `process`, `get_num`, `time`) VALUES (~p, ~p, ~p, ~p, ~p, ~p, ~p)">>).

trigger(ActList, Key, RoleId, Arg, Times) ->
    gen_server:cast(?MODULE, {'trigger', ActList, Key, RoleId, Arg, Times}).

clear_data(Type, SubType) ->
    gen_server:cast(?MODULE, {'clear_data', Type, SubType}).

get_act_info(Type, SubType, RoleId, RoleLv) ->
    gen_server:cast(?MODULE, {'get_act_info', Type, SubType, RoleId, RoleLv}).

get_reward(Type, SubType, Grade, RoleId) ->
    gen_server:call(?MODULE, {'get_reward', Type, SubType, Grade, RoleId}).

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

init([]) ->
    Ref = util:send_after(undefined, 1*1000, self(), {'init_after_ref'}),
    {ok, #act_task_state{init_ref = Ref}}.

handle_call(Request, _From, State) ->
    case catch do_handle_call(Request, State) of
        {reply, Resoult, NewState} ->
            {reply, Resoult, NewState};
        Res ->
            ?ERR("Error:~p~n", [[Request, Res]]),
            {reply, ok, State}
    end.

handle_cast(Msg, State) ->
    case catch do_handle_cast(Msg, State) of
        {noreply, NewState} ->
            {noreply, NewState};
        Res ->
            ?ERR("Error:~p~n", [[Msg, Res]]),
            {noreply, State}
    end.

handle_info(Info, State) ->
    case catch do_handle_info(Info, State) of
        {noreply, NewState} ->
            {noreply, NewState};
        Res ->
            ?ERR("Error:~p~n", [[Info, Res]]),
            {noreply, State}
    end.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%% 触发任务
do_handle_cast({'trigger', ActList, Key, RoleId, Arg, Times}, State) ->
    #act_task_state{act_data = Map} = State,
    Now = utime:unixtime(),
    Fun = fun({Type, SubType}, {TemMap, AccL}) ->
        GradeIdList = lib_custom_act_util:get_act_reward_grade_list(Type, SubType),
        F1 = fun(Grade, {AccMap, Acc, Acc1}) ->
            MapKey = {Type, SubType, Grade},
            TemList = maps:get(MapKey, AccMap, []),
            {_, OProcess, OGetNum, Time} = ulists:keyfind(RoleId, 1, TemList, {RoleId, 0, 0, Now}),
            %% 核对数据
            case check_is_need_clear(Now, Type, SubType, Time) of
                false -> Process = 0, GetNum = 0;
                _ -> Process = OProcess, GetNum = OGetNum
            end,
            #custom_act_reward_cfg{condition = Conditions} 
            = lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, Grade),
            case lists:keyfind(Key, 1, Conditions) of
                {_, OtherCfg, _NeedProcess} when OtherCfg == Arg ->  
                    NewProcess = Process+Times,
                    Turple = {RoleId, NewProcess, GetNum, Now},
                    NewTemList = lists:keystore(RoleId, 1, TemList, Turple),
                    NewAcc = [[Type, SubType, Grade, RoleId, NewProcess, GetNum, Now]|Acc],
                    NewAcc1 = [{Grade, NewProcess}|Acc1];
                _ ->
                    NewTemList = TemList, NewAcc = Acc, NewAcc1 = Acc1
            end,
            {maps:put(MapKey, NewTemList, AccMap), NewAcc, NewAcc1}
        end,
        {NewTemMap, NewAccL, SendList} = lists:foldl(F1, {TemMap, AccL, []}, GradeIdList),
        SendList =/= [] andalso lib_server_send:send_to_uid(RoleId, pt_332, 33242, [Type, SubType, SendList]),
        {NewTemMap, NewAccL}
    end,
    {NewMap, DbList} = lists:foldl(Fun, {Map, []}, ActList),
    DbList =/= [] andalso db:execute(
        usql:replace(custom_act_task, [type, subtype, grade, role_id, process, get_num, time], DbList)
    ),
    {noreply, State#act_task_state{act_data = NewMap}};

do_handle_cast({'clear_data', Type, SubType}, State) ->
    #act_task_state{act_data = Map} = State,
    KeyList = maps:keys(Map),
    RemoveKeyL = [T||{Type1, SubType1, _} = T <- KeyList, Type1 == Type, SubType1 == SubType],
    Fun = fun(MapKey, {TemMap, Acc}) ->
        NewAcc = clear_data_core(MapKey, TemMap, Acc),
        {maps:remove(MapKey, TemMap), NewAcc}
    end,
    {NewMap, RoleRewardL} = lists:foldl(Fun, {Map, []}, RemoveKeyL),
    {Title, Content} = get_mail_info(Type),
    F1 = fun({RoleId, Reward}) ->
        lib_mail_api:send_sys_mail([RoleId], Title, Content, Reward)
    end,
    lists:foreach(F1, RoleRewardL),
    db:execute(io_lib:format(?SQL_DELETE_DATA, [Type, SubType])),
    {noreply, State#act_task_state{act_data = NewMap}};

do_handle_cast({'get_act_info', Type, SubType, RoleId, RoleLv}, State) ->
    #act_task_state{act_data = Map} = State,
    SendList = get_act_info_core(Type, SubType, Map, RoleId, RoleLv),
    {_, Bin} = pt_332:write(33241, [Type, SubType, SendList]),
    lib_server_send:send_to_uid(RoleId, Bin),
    {noreply, State};
    
do_handle_cast(_Msg, State) ->
    {noreply, State}.

do_handle_call({'get_reward', Type, SubType, Grade, RoleId}, State) ->
    #act_task_state{act_data = Map} = State,
    MapKey = {Type, SubType, Grade},
    List = maps:get(MapKey, Map, []),
    Now = utime:unixtime(),
    {_, OProcess, OGetNum, Time} = ulists:keyfind(RoleId, 1, List, {RoleId, 0, 0, Now}),
    %% 核对下是否清理过数据
    case check_is_need_clear(Now, Type, SubType, Time) of
        false -> Process = 0, GetNum = 0, NeedChangeDb = true;
        _ -> Process = OProcess, GetNum = OGetNum, NeedChangeDb = false
    end,
    ?PRINT("OProcess:~p, OGetNum:~p, Time:~p~n",[OProcess, OGetNum, Time]),
    #custom_act_reward_cfg{condition = Conditions} = 
    lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, Grade),
    {_, Key} = ulists:keyfind(key, 1, Conditions, {key, 0}),
    case lists:keyfind(Key, 1, Conditions) of
        {_, _, NeedProcess} when Process >= NeedProcess andalso GetNum < 1 ->  
            Turple = {RoleId, Process, GetNum+1, Now},
            NewList = lists:keystore(RoleId, 1, List, Turple),
            NewMap = maps:put(MapKey, NewList, Map),
            Code = 1, IsNeedChange = false,
            db:execute(io_lib:format(?SQL_REPLACE_DATA, [Type, SubType, Grade, RoleId, Process, GetNum+1, Now]));
        {_, _, NeedProcess} ->
            NewMap = Map, IsNeedChange = NeedChangeDb,
            Code = ?IF(Process < NeedProcess, ?ERRCODE(err331_act_can_not_get), ?ERRCODE(err331_already_get_reward));
        _ ->
            NewMap = Map, IsNeedChange = NeedChangeDb,
            Code = ?ERRCODE(err331_no_act_reward_cfg)
    end,
    %% 保存清理后的状态
    if
        IsNeedChange == true ->
            NewList1 = lists:keydelete(RoleId, 1, List),
            NewMap1 = maps:put(MapKey, NewList1, NewMap),
            db:execute(io_lib:format(?SQL_REPLACE_DATA, [Type, SubType, Grade, RoleId, Process, GetNum, Now]));
        true ->
            NewMap1 = NewMap
    end,
    {reply, Code, State#act_task_state{act_data = NewMap1}};

do_handle_call(_, State) ->
    {reply, ok, State}.

do_handle_info({'init_after_ref'}, State) ->
    #act_task_state{init_ref = Ref} = State,
    util:cancel_timer(Ref),
    List = db:get_all(?SQL_SELECT_DATA),
    Fun = fun([Type, SubType, Grade, RoleId, Process, GetNum, Time], TemMap) ->
        MapKey = {Type, SubType, Grade},
        TemList = maps:get(MapKey, TemMap, []),
        NewList = lists:keystore(RoleId, 1, TemList, {RoleId, Process, GetNum, Time}),
        maps:put({Type, SubType, Grade}, NewList, TemMap)
    end,
    Map = lists:foldl(Fun, #{}, List),
    {noreply, State#act_task_state{init_ref = undefined, act_data = Map}};

do_handle_info(_Msg, State) ->
    {noreply, State}.

check_is_need_clear(Now, Type, SubType, Time) ->
    #custom_act_cfg{clear_type = ClearTypeCfg} = lib_custom_act_util:get_act_cfg_info(Type, SubType),
    if
        ClearTypeCfg == ?CUSTOM_ACT_CLEAR_ZERO -> IsSameDay = utime:is_same_day(Now, Time);
        ClearTypeCfg == ?CUSTOM_ACT_CLEAR_FOUR -> IsSameDay = utime_logic:is_logic_same_day(Now, Time);
        true -> IsSameDay = true
    end,
    IsSameDay.

clear_data_core(MapKey, Map, List) ->
    {Type, SubType, Grade} = MapKey,
    #custom_act_reward_cfg{condition = Conditions} = RewardCfg 
        = lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, Grade),
    {_, Key} = ulists:keyfind(key, 1, Conditions, {key, 0}),
    {_, _, NeedProcess} = ulists:keyfind(Key, 1, Conditions, {Key, 1, 999}),
    TemList = maps:get(MapKey, Map, []),
    Fun = fun
        ({RoleId, Process, GetNum, _Time}, Acc) when Process >= NeedProcess andalso GetNum < 1 ->
            RewardParam = lib_custom_act:make_rwparam(RoleId),
            Reward = lib_custom_act_util:count_act_reward(RewardParam, RewardCfg),
            {_, OldList} = ulists:keyfind(RoleId, 1, Acc, {RoleId, []}),
            NewList = ulists:object_list_plus([OldList, Reward]),
            lists:keystore(RoleId, 1, Acc, {RoleId, NewList});
        (_, Acc) -> Acc
    end,
    lists:foldl(Fun, List, TemList).


get_act_info_core(Type, SubType, Map, RoleId, RoleLv) ->
    GradeIds = lib_custom_act_util:get_act_reward_grade_list(Type, SubType),
    Wlv = util:get_world_lv(),
    F = fun(GradeId, Acc) ->
        case lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GradeId) of
            #custom_act_reward_cfg{
                name = Name,
                desc = Desc,
                condition = Condition,
                format = Format,
                reward = Reward
            } = RewardCfg ->
                case lib_custom_act_check:check_reward_in_wlv(Type, SubType, [{wlv, Wlv}, {role_lv, RoleLv}], RewardCfg) of 
                    true ->
                        TemList = maps:get({Type, SubType, GradeId}, Map, []),
                        {RoleId, Process, GetNum, _Time} 
                            = ulists:keyfind(RoleId, 1, TemList, {RoleId, 0, 0, 0}),
                        {_, Key} = ulists:keyfind(key, 1, Condition, {key, 0}),
                        case lists:keyfind(Key, 1, Condition) of
                            {_, _, NeedProcess} -> 
                                Status = ?IF(GetNum > 0, 2, ?IF(Process >= NeedProcess, 1, 0));
                            _ -> Status = 0
                        end,
                        ConditionStr = util:term_to_string(Condition),
                        RewardStr = util:term_to_string(Reward),
                        [{GradeId, Format, Status, Process, GetNum, Name, Desc, ConditionStr, RewardStr} | Acc];
                    _ ->
                        Acc
                end;
            _ -> Acc
        end
        end,
    lists:foldl(F, [], GradeIds).


get_mail_info(_Type) ->
    Title = utext:get(3310093), Content = utext:get(3310094),
    {Title, Content}.