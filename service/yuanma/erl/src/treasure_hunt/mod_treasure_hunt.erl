%%-----------------------------------------------------------------------------
%% @Module  :       mod_treasure_hunt
%% @Author  :       Czc
%% @Email   :       389853407@qq.com
%% @Created :       2017-11-22
%% @Description:    寻宝进程
%%-----------------------------------------------------------------------------
-module(mod_treasure_hunt).

-include("treasure_hunt.hrl").
-include("def_fun.hrl").
-include("common.hrl").
-include("def_module.hrl").
-include("counter.hrl").

-behaviour(gen_server).

-export([start_link/0]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-compile([export_all]).

start_link() -> %% 更改进程名注意别遗漏lib_treasure_hunt_data:update_luckey_value_map 334行
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

init([]) ->
    State = lib_treasure_hunt_mod:init(),
    {ok, State}.

gm_start_timer(Type) ->
    gen_server:cast(?MODULE, {'gm_start_timer', Type}).

init_common_map(RoleId) ->
    gen_server:cast(?MODULE,{'init_common_map', RoleId}).

set_luckey_value(ContinueTime) ->
    gen_server:cast(?MODULE, {'set_luckey_value', ContinueTime}).

gm_set_luckey_value(HType, Value) ->
    gen_server:cast(?MODULE, {'gm_set_luckey_value', HType, Value}).

get_luckey_value(ServerId, HType, RoleId) ->
    gen_server:cast(?MODULE, {'get_luckey_value', ServerId, HType, RoleId}).

add_common_map(RoleId, HType, Times, NextFreeTime) ->
    gen_server:cast(?MODULE, {'add_common_map',RoleId, HType, Times, NextFreeTime}).

remove_from_common_map(RoleId) ->
    gen_server:cast(?MODULE, {'remove_from_common_map', RoleId}).

get_treasure_hunt_record(RoleId, HType, RType) ->
    gen_server:cast(?MODULE, {'get_treasure_hunt_record', RoleId, HType, RType}).

equip_hunt_show(RoleId, RoleLv, HType, Type, Score) ->
    gen_server:cast(?MODULE, {'equip_hunt_show', RoleId, RoleLv, HType, Type, Score}).

add_treasure_hunt_record(RoleId, RoleName, RoleLv, FigArgs, RewardList) ->
    gen_server:cast(?MODULE, {add_treasure_hunt_record, RoleId, RoleName, RoleLv, FigArgs, RewardList}).

treasure_hunt(ServerId, ServerNum, RoleId, RoleName, RoleLv, MaskId, FigArgs, HType, Times, AutoBuy) ->
    gen_server:call(?MODULE, {'treasure_hunt', ServerId, ServerNum, RoleId, RoleName, RoleLv, MaskId, FigArgs, HType, Times, AutoBuy}).

get_free_treasure_hunt(RoleId, HType, Nowtime) ->
    gen_server:call(?MODULE, {'get_free_treasure_hunt', RoleId, HType, Nowtime}).

set_free_treasure_hunt(RoleId, HType, Times, Nowtime, CdDebuffRatio) ->
    gen_server:cast(?MODULE, {'set_free_treasure_hunt', RoleId, HType, Times, Nowtime, CdDebuffRatio}).

%%增加免费次数
add_free_treasure_hunt(RoleId, HType, AddTimes) ->
    gen_server:cast(?MODULE, {'add_free_treasure_hunt', RoleId, HType, AddTimes}).

refresh_old_luckey_map(HType) ->
    gen_server:cast(?MODULE, {'refresh_old_luckey_map', HType}).

gm_set_free_time(HType, Time) ->
    gen_server:cast(?MODULE, {'gm_set_free_time', HType, Time}).

gm_reset_treasure(RoleId) ->
    gen_server:cast(?MODULE, {'gm_reset_treasure', RoleId}).

cluster_set_luckey_value(LuckeyValueList) ->
    gen_server:cast(?MODULE, {'cluster_set_luckey_value', LuckeyValueList}).

handle_cast(Msg, State) ->
    case catch do_handle_cast(Msg, State) of
        {ok, NewState} ->
            {noreply, NewState};
        Err ->
            ?ERR("handle_cast Msg:~p error:~p~n", [Msg, Err]),
            {noreply, State}
    end.

do_handle_cast({'gm_start_timer', Type}, State) ->
    #treasure_hunt_state{luckey_val_ref = Oref} = State,
    util:cancel_timer(Oref),
    NewRef = erlang:send_after(max(1, Type)*1000, self(), 'timer_add_value'),
    {ok, State#treasure_hunt_state{luckey_val_ref = NewRef}};

do_handle_cast({'set_luckey_value', ContinueTime}, State) -> %% ContinueTime 结束时间戳
    #treasure_hunt_state{luckey_map = LuckeyMap, luckey_val_protect_ref = OProRef} = State,
    Value = data_treasure_hunt:get_cfg(equip_hunt_max_luckey_value),
    Nowtime = utime:unixtime(),
    util:cancel_timer(OProRef),
    case ContinueTime > Nowtime of
        true ->
            Pers = lib_treasure_hunt_data:get_show_percent(Value),
            Fun = fun(HType, TemMap) ->
                NewMap = maps:put(HType, Value, TemMap),
                OpenLv = lib_treasure_hunt_data:get_open_lv(HType),
                {ok, BinData} = pt_416:write(41610, [HType, Value, Pers]),
                lib_server_send:send_to_all(all_lv, {OpenLv, 99999}, BinData),
                db:execute(io_lib:format(?sql_replace_treasure_hunt_luckey_value, [HType, Value])),
                NewMap
            end,
            NewLuckeyMap = lists:foldl(Fun, LuckeyMap, ?LUCKEY_TREASURE_HUNT_TYPE_LIST),
            NewCtime = ContinueTime - Nowtime,
            OpenDayCfg = lib_treasure_hunt_data:get_cfg_data(kf_use_kf_luckey_value, 8),
            OpenDay = util:get_open_day(),
            if
                OpenDay >= OpenDayCfg ->
                    mod_cluster_luckey_value:cast_center([{'act_set_luckey_value', config:get_server_id(), ContinueTime}]);
                true ->
                    skip
            end,
            NewRef = erlang:send_after(NewCtime*1000, self(), {'luckey_val_protect_end', ?LUCKEY_TREASURE_HUNT_TYPE_LIST});
        _ ->
            NewRef = undefined,NewLuckeyMap = LuckeyMap
    end,
    {ok, State#treasure_hunt_state{luckey_map = NewLuckeyMap,luckey_val_protect_ref = NewRef}};

do_handle_cast({'gm_set_luckey_value', HType, Value}, State) ->
    #treasure_hunt_state{luckey_map = LuckeyMap, old_luckey_map = OldluckeyMap} = State,
    MaxValue = data_treasure_hunt:get_cfg(equip_hunt_max_luckey_value),
    LuckeyValue = min(Value, MaxValue),
    NewMap = maps:put(HType, LuckeyValue, LuckeyMap),
    lib_treasure_hunt_data:notify_client_luckey_value(HType, OldluckeyMap, NewMap),
    db:execute(io_lib:format(?sql_replace_treasure_hunt_luckey_value, [HType, LuckeyValue])),
    {ok, State#treasure_hunt_state{luckey_map = NewMap}};

do_handle_cast({'get_luckey_value', ServerId, HType, RoleId}, State) ->
    #treasure_hunt_state{
        luckey_map = LuckeyMap, old_luckey_map = OldluckeyMap, 
        luckey_val_protect_ref = Ref
    } = State,
    OpenDay = util:get_open_day(),
    OpenDayLimit = lib_treasure_hunt_data:get_cfg_data(kf_use_kf_luckey_value, 0),
    if
        OpenDay < OpenDayLimit orelse Ref =/= undefined ->
            lib_treasure_hunt_data:notify_client_luckey_value(HType, OldluckeyMap, LuckeyMap);
        true ->
            IsMember = lists:member(HType, ?LUCKEY_TREASURE_HUNT_TYPE_LIST),
            if
                IsMember == true ->
                    mod_cluster_luckey_value:cast_center([{'get_luckey_value', ServerId, HType, RoleId}]);
                true ->
                    lib_server_send:send_to_uid(RoleId, pt_416, 41610, [HType, 0, 0])
            end
            
    end,
    {ok, State};

do_handle_cast({'get_treasure_hunt_record', RoleId, HType, Type}, State) ->
    #treasure_hunt_state{record_map = RecordMap} = State,
    ObjId = ?IF(Type == ?OBJECT_TYPE_ALL, 0, RoleId),
    RecordSubList = maps:get({HType, ObjId}, RecordMap, []),
    PackList = lib_treasure_hunt_mod:pack_record_list(RecordSubList),
    NewPackList = lib_treasure_hunt_mod:get_htype_record(HType, PackList),
    {ok, BinData} = pt_416:write(41602, [Type, NewPackList]),
    lib_server_send:send_to_uid(RoleId, BinData),
    {ok, State};

do_handle_cast({'equip_hunt_show', RoleId, RoleLv, HType, Type, Score}, State) ->
    #treasure_hunt_state{record_map = RecordMap, common_map = CommonMap, statistics_reward_map = StatisticsRewardMap} = State,
    ObjId = ?IF(Type == ?OBJECT_TYPE_ALL, 0, RoleId),
    case maps:get({HType, 240, 0}, StatisticsRewardMap, false) of
        #reward_status{obtain_times = ObtainTimes} when ObtainTimes >= 1 -> DrawWeapon = 1;
        _ -> DrawWeapon = 0
    end,
    case maps:get({RoleId, HType}, CommonMap, []) of
        #common_funcation{free_times = Times, next_free_time = NextFreeTime} ->
            RecordSubList = maps:get({HType, ObjId}, RecordMap, []),
            PackList = lib_treasure_hunt_mod:pack_record_list(RecordSubList),
            NewPackList = lib_treasure_hunt_mod:get_htype_record(HType, PackList),
            % ?PRINT("HType:~p,RoleId:~p,Score:~p,Times:~p,NextFreeTime:~p, Nowtime:~p, NewPackList:~p ~n",[HType,RoleId,Score,Times, NextFreeTime,utime:unixtime(),NewPackList]),
            {ok, BinData} = pt_416:write(41608, [Score, HType, DrawWeapon, Type, Times, NextFreeTime, NewPackList]),
            lib_server_send:send_to_uid(RoleId, BinData);
        _Err ->
            Fun = fun(Type1) ->
                OpenLv = lib_treasure_hunt_data:get_open_lv(Type1),
                if
                    RoleLv >= OpenLv ->
                        AddTime = lib_treasure_hunt_data:get_free_hunt_time(Type1),
                        if
                            AddTime > 0 ->
                                mod_treasure_hunt:add_common_map(RoleId, Type1, 1, 0);
                            HType == ?TREASURE_HUNT_TYPE_BABY ->
                                RecordSubList = maps:get({HType, ObjId}, RecordMap, []),
                                PackList = lib_treasure_hunt_mod:pack_record_list(RecordSubList),
                                NewPackList = lib_treasure_hunt_mod:get_htype_record(HType, PackList),
                                {ok, BinData} = pt_416:write(41608, [0, HType, 0, Type, 0, 0, NewPackList]),
                                lib_server_send:send_to_uid(RoleId, BinData);
                            true ->
                                skip
                        end;
                    true ->
                        skip
                end
            end,
            lists:foreach(Fun, ?TREASURE_HUNT_TYPE_LIST)
    end, 
    {ok, State};

do_handle_cast({'gm_set_free_time', HType, Time}, State) ->
    #treasure_hunt_state{common_map = CommonMap} = State,
    Nowtime = utime:unixtime(),
    % AddTime = lib_treasure_hunt_data:get_free_hunt_time(HType),
    Fun = fun({_, THType}, #common_funcation{free_times = Times} = CommonFun) when HType == THType ->
        if
            Times == 0 ->
                NewComFun = CommonFun#common_funcation{next_free_time = Nowtime + Time};
            true ->
                NewComFun = CommonFun
        end,
        NewComFun;
        (_, Value) -> Value
    end,
    NewMap = maps:map(Fun, CommonMap),
    NewState = State#treasure_hunt_state{common_map = NewMap},
    {ok, NewState};

do_handle_cast({'gm_reset_treasure', RoleId}, State) ->
    db:execute(io_lib:format("truncate table treasure_hunt_reward",[])),
    db:execute(io_lib:format("truncate table treasure_hunt_times",[])),
    mod_counter:set_count(RoleId, ?MOD_TREASURE_HUNT, ?COUNT_ID_416_EQUIP_CHOOSE, 0),
    {ok, State#treasure_hunt_state{statistics_reward_map = #{}, statistics_times_map = #{}}};

do_handle_cast({add_treasure_hunt_record, RoleId, RoleName, RoleLv, FigArgs, RewardList}, State) ->
    #treasure_hunt_state{record_map = RecordMap} = State,
    NewRecordMap = lib_treasure_hunt_data:add_treasure_hunt_record(RecordMap, RewardList, RoleId, RoleName, RoleLv, FigArgs),
    NewState = State#treasure_hunt_state{record_map = NewRecordMap},
    {ok, NewState};

do_handle_cast({'set_free_treasure_hunt', RoleId, HType, Times, Nowtime, CdDebuffRatio}, State) ->
    #treasure_hunt_state{common_map = CommonMap} = State,
    AddTime = lib_treasure_hunt_data:get_free_hunt_time(HType),
    case maps:get({RoleId, HType}, CommonMap, []) of
        CommonFun when is_record(CommonFun, common_funcation) ->
            if
                AddTime > 0 ->
                    NewAddTime = round(AddTime * (1 - CdDebuffRatio)),
                    #common_funcation{next_free_time = OldTime} = CommonFun,
                    if
                        Times == 0 ->
                            NextFreeTime = Nowtime + NewAddTime;
                        true ->
                            NextFreeTime = OldTime
                    end,
%%                    ?MYLOG("cym", "Times ~p~n", [Times]),
                    NewComFun = CommonFun#common_funcation{free_times = Times, next_free_time = NextFreeTime},
                    db:execute(io_lib:format(?sql_update_treasure_hunt_extra, [Times, NextFreeTime, HType,RoleId])),
                    NewComMap = maps:put({RoleId, HType}, NewComFun, CommonMap),
                    NewState = State#treasure_hunt_state{common_map = NewComMap};
                true ->
                    NewState = State
            end;
        _ ->
            NewState = State
    end,
    {ok, NewState};

do_handle_cast({'add_free_treasure_hunt', RoleId, HType, AddTimes}, State) ->
    #treasure_hunt_state{common_map = CommonMap} = State,
    case maps:get({RoleId, HType}, CommonMap, []) of
        #common_funcation{free_times = Times, next_free_time = FreeTime} = CommonFun ->
            if
                AddTimes > 0 ->
                    NewComFun = CommonFun#common_funcation{free_times = Times + AddTimes},
                    db:execute(io_lib:format(?sql_update_treasure_hunt_extra, [Times + AddTimes, FreeTime, HType, RoleId])),
                    NewComMap = maps:put({RoleId, HType}, NewComFun, CommonMap),
                    NewState = State#treasure_hunt_state{common_map = NewComMap};
                true ->
                    NewState = State
            end;
        _ ->
            NewState = State
    end,
    {ok, NewState};



do_handle_cast({'init_common_map', RoleId}, State) ->
    #treasure_hunt_state{common_map = CommonMap} = State,
    NewComMap = lib_treasure_hunt_mod:get_common_map(RoleId, CommonMap),
    NewState = State#treasure_hunt_state{common_map = NewComMap},
    {ok, NewState};

do_handle_cast({'add_common_map',RoleId, HType, Times, NextFreeTime}, State) ->
    #treasure_hunt_state{common_map = CommonMap} = State,
    case maps:get({RoleId, HType}, CommonMap, []) of
        [] ->
            db:execute(io_lib:format(?sql_replace_treasure_hunt_extra, [RoleId, HType, 1, 0])),
            NewComMap = lib_treasure_hunt_mod:init_common_funcation_map([[RoleId, HType, Times, NextFreeTime]], CommonMap),
            NewState = State#treasure_hunt_state{common_map = NewComMap};
        _ ->
            NewState = State
    end,
    {ok, NewState};

do_handle_cast({'remove_from_common_map', RoleId}, State) ->
    #treasure_hunt_state{common_map = CommonMap} = State,
    Fun = fun(HType, Map) ->
        case maps:get({RoleId,HType}, CommonMap, []) of
            [] -> 
                CommonMap;
            #common_funcation{free_times = Times, next_free_time = NextFreeTime} ->
                db:execute(io_lib:format(?sql_update_treasure_hunt_extra, [Times,NextFreeTime,HType,RoleId])),
                NewMap = maps:remove({RoleId, HType}, Map),
                NewMap
        end
    end,
    NewComMap = lists:foldl(Fun, CommonMap, ?TREASURE_HUNT_TYPE_LIST),
    NewState = State#treasure_hunt_state{common_map = NewComMap},
    {ok, NewState};

do_handle_cast({'refresh_old_luckey_map', HType}, State) ->
    NewState = do_refresh(State, HType),
    {ok, NewState};

do_handle_cast(_Msg, State) -> {ok, State}.

do_refresh(State, HType) ->
    #treasure_hunt_state{
        luckey_map = LuckeyMap,
        protect_ref = Oldref,
        old_luckey_map = OldluckeyMap
    } = State,
    util:cancel_timer(Oldref),
    NewOlMap = maps:put(HType, 0, OldluckeyMap),
    OpenDay = util:get_open_day(),
    OpenDayCfg = lib_treasure_hunt_data:get_cfg_data(kf_use_kf_luckey_value, 8),
    ?PRINT("========= OpenDayCfg:~p~n",[OpenDayCfg]),
    OpenDay < OpenDayCfg andalso
        lib_treasure_hunt_data:notify_client_luckey_value(HType, NewOlMap, LuckeyMap),
    State#treasure_hunt_state{old_luckey_map = NewOlMap}.

handle_info(Info, State) ->
    case catch do_handle_info(Info, State) of
        {ok, NewState} ->
            {noreply, NewState};
        Err ->
            ?ERR("handle_info Info:~p error:~p~n", [Info, Err]),
            {noreply, State}
    end.

do_handle_info({'refresh_old_luckey_map', HType}, State) ->
    NewState = do_refresh(State, HType),
    {ok, NewState};

do_handle_info({'luckey_val_protect_end', HtypeList}, State) ->
    #treasure_hunt_state{
        luckey_map = LuckeyMap,
        luckey_val_protect_ref = Ref 
    } = State,
    util:cancel_timer(Ref),
    OpenDay = util:get_open_day(),
    OpenDayCfg = lib_treasure_hunt_data:get_cfg_data(kf_use_kf_luckey_value, 8),
    Fun = fun(HType, TemMap) ->
        NewMap = maps:put(HType, 0, TemMap),
        if
            OpenDay < OpenDayCfg ->
                OpenLv = lib_treasure_hunt_data:get_open_lv(HType),
                {ok, BinData} = pt_416:write(41610, [HType, 0, 0]),
                lib_server_send:send_to_all(all_lv, {OpenLv, 99999}, BinData);
            true ->
                skip
        end,
        db:execute(io_lib:format(?sql_replace_treasure_hunt_luckey_value, [HType, 0])),
        NewMap
    end,
    NewLuckeyMap = lists:foldl(Fun, LuckeyMap, HtypeList),
    if
        OpenDay >= OpenDayCfg ->
            mod_cluster_luckey_value:cast_center([{'act_end_get_luckey_value', config:get_server_id()}]);
        true ->
            skip
    end,
    
    NewRef = undefined,
    {ok, State#treasure_hunt_state{luckey_map = NewLuckeyMap, luckey_val_protect_ref = NewRef}};

do_handle_info('timer_add_value', State) ->
    #treasure_hunt_state{
        luckey_map = LuckeyMap,
        old_luckey_map = OldluckeyMap,
        luckey_val_ref = Ref,
        luckey_val_protect_ref = PRef
    } = State,
    util:cancel_timer(Ref),
    case data_treasure_hunt:get_cfg(equip_treasure_luckey_value) of
        [{htype, HtypeList},{time, Time},{add_value, AddVal}]  ->skip;
        _ ->
            Time = 300, AddVal = 1,HtypeList=[]
    end,
    OpenDay = util:get_open_day(),
    OpenDayCfg = lib_treasure_hunt_data:get_cfg_data(kf_use_kf_luckey_value, 8),
    MaxValue = data_treasure_hunt:get_cfg(equip_hunt_max_luckey_value),
    Fun = fun(HType, TemMap) ->
        OldValue = maps:get(HType, TemMap,0),
        OldLuckyValue = maps:get(HType, OldluckeyMap, 0),
        NewVal = min(OldValue+AddVal, MaxValue),
        NewMap = maps:put(HType, NewVal, TemMap),
        Value = max(OldLuckyValue, NewVal),
        Pers = lib_treasure_hunt_data:get_show_percent(Value),
        if
            OpenDay < OpenDayCfg orelse PRef =/= undefined ->
                OpenLv = lib_treasure_hunt_data:get_open_lv(HType),
                {ok, BinData} = pt_416:write(41610, [HType, Value, Pers]),
                lib_server_send:send_to_all(all_lv, {OpenLv, 99999}, BinData);
            true ->
                skip
        end,
        if
            OldValue < 99999 ->
                db:execute(io_lib:format(?sql_replace_treasure_hunt_luckey_value, [HType, NewVal]));
            true ->
                skip
        end,        
        NewMap
    end,
    NewLuckeyMap = lists:foldl(Fun, LuckeyMap, HtypeList),
    if
        Time =< 0 ->
            NewRef = undefined;
        true ->
            NewRef = erlang:send_after(Time*1000, self(), 'timer_add_value')
    end,
    {ok, State#treasure_hunt_state{luckey_map = NewLuckeyMap, luckey_val_ref = NewRef}};

do_handle_info(_Info, State) -> {ok, State}.

handle_call(Request, _From, State) ->
    case catch do_handle_call(Request, State)  of
        {ok, Reply, NewState} ->
            {reply, Reply, NewState};
        Err ->
            ?ERR("handle_call Request:~p error:~p~n", [Request, Err]),
            {noreply, State}
    end.

do_handle_call({'treasure_hunt', ServerId, ServerNum, RoleId, RoleName, RoleLv, MaskId, FigArgs, HType, Times, AutoBuy}, State) ->
    [Reply, NewState] = lib_treasure_hunt_mod:treasure_hunt(State, ServerId, ServerNum, RoleId, RoleName, RoleLv, MaskId, FigArgs, HType, Times, AutoBuy),
    {ok, Reply, NewState};

do_handle_call({'get_free_treasure_hunt', RoleId, HType, Nowtime}, State) ->
    Reply = lib_treasure_hunt_mod:get_free_treasure_hunt(State, RoleId, HType, Nowtime),
    {ok, Reply, State};

do_handle_call(_Request, _State) -> {ok, ok}.

terminate(_Reason, _State) ->
    ?ERR("~p is terminate:~p", [?MODULE, _Reason]),
    ok.

code_change(_OldVsn, State, _Extra) -> {ok, State}.