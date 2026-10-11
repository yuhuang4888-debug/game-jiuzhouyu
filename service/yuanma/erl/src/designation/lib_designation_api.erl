%%%-----------------------------------------------------------------------------
%%%	@Module  : lib_designation_api
%%% @Author  : liuxl
%%% @Email   : liuxingli@suyougame.com
%%% @Created : 2016-11-21
%%% @Description : 称号系统
%%%-----------------------------------------------------------------------------
-module(lib_designation_api).
-include("server.hrl").
-include("predefine.hrl").
-include("common.hrl").
-include("designation.hrl").
-include("def_event.hrl").
-include("rec_event.hrl").
-include("def_fun.hrl").
%% -include_lib("stdlib/include/ms_transform.hrl").

-export([
         handle_event/2,            %% 事件回调
         active_dsgt_common/2,      %% 其他进程调用激活称号通用接口; 玩家进程调用激活称号:lib_designation:active_dsgt
         active_dsgt_common/3,
         active_global_dsgt/2,      %% 激活全局称号
         active_global_dsgt/4,      %% 激活全局称号
         cancel_dsgt/2,             %% 取消称号
         cancel_dsgt_online/2,      %% 取消称号(玩家在线的时候使用)
         get_dsgt_name/1,
         is_dsgt_active/2           %% 判断称号是否已激活
         ,remove_dsgt/1             %% 删除所有玩家称号列表中的称号
         ,remove_dsgt/2             %% 强制移除称号包括离线情况
        ]).

%% 玩家进程回调事件处理
handle_event(PS, _Event) ->
    {ok, PS}.

%% 其他进程调用发送称号接口
%% PalyerId:玩家id
%% Id:称号id
active_dsgt_common(PlayerId, DsgtId) ->
    case data_designation:get_by_id(DsgtId) of
        #base_designation{expire_time = ExpireTime, is_global = Global}->
            EndTime = ?IF(ExpireTime == 0, 0, utime:unixtime() + ExpireTime),
            ?IF(Global > 0,
                active_global_dsgt(DsgtId, [PlayerId], Global, EndTime),
                active_dsgt_cast(PlayerId, #active_para{id=DsgtId, expire_time = EndTime}));
        _ ->
            skip
    end.

%%--------------------------------------------------
%% 其他进程调用发送称号接口
%% @param  PlayerId 玩家id
%% @param  DsgtId   称号id
%% @param  EndTime  称号过期时间
%% @return          description
%%--------------------------------------------------
active_dsgt_common(PlayerId, DsgtId, EndTime) ->
    case data_designation:get_by_id(DsgtId) of
        #base_designation{expire_time = ExpireTime, is_global = Global}->
            RealEndTime = ?IF(ExpireTime == 0, 0, EndTime),
            ?IF(Global > 0,
                active_global_dsgt(DsgtId, [PlayerId], Global, RealEndTime),
                active_dsgt_cast(PlayerId, #active_para{id=DsgtId, expire_time = RealEndTime}));
        _ ->
            skip
    end.

%% 激活玩家全局称号
active_global_dsgt(Id, PlayerIdList) ->
    case data_designation:get_by_id(Id) of
        #base_designation{expire_time = ExpireTime, is_global = Global} ->
            EndTime = ?IF(ExpireTime == 0, 0, utime:unixtime() + ExpireTime),
            active_global_dsgt(Id, PlayerIdList, Global, EndTime);
        _ ->
            ok
    end.

%% 激活全局称号
active_global_dsgt(DsgtId, PlayerIdList, Global, ExpireTime) ->
    %% 删除称号的玩家
    OwnerList = lib_designation_util:get_dsgt_owner(DsgtId),
    DeleteList = lib_designation_util:find_delete_list(OwnerList, PlayerIdList, Global),
    DelArgs = #active_para{id = DsgtId},
    [cancel_global_dsgt(DelId, DelArgs) || DelId <- DeleteList],
    %% 激活称号
    ActiveArgs = #active_para{id=DsgtId, expire_time = ExpireTime},
    [active_dsgt_cast(PlayerId, ActiveArgs) || PlayerId <- PlayerIdList].

%% 转发到玩家进程处理
active_dsgt_cast(PlayerId, ActivePara) ->
    case misc:get_player_process(PlayerId) of
        Pid when is_pid(Pid) ->
            case misc:is_process_alive(Pid) of
                true ->
                    gen_server:cast(Pid, {'apply_cast', ?APPLY_CAST_SAVE, lib_designation, active_dsgt, [ActivePara]});
                false ->
                    ?ERR("active_dsgt not found player process, RoleId:~p~n",[PlayerId])
            end;
        _ ->
            %% 离线激活
            lib_designation:active_dsgt_not_online(PlayerId, ActivePara)
    end.

%% 取消称号，到结束时效时被调用
cancel_dsgt(PlayerId, DsgtId) ->
    Pid = misc:get_player_process(PlayerId),
    case misc:is_process_alive(Pid) of
        true ->
            gen_server:cast(Pid, {'apply_cast', ?APPLY_CAST_SAVE, lib_designation, cancel_dsgt, [DsgtId]});
        _ -> %% 离线取消
            NowTime = utime:unixtime(),
            case lib_designation_util:select_dsgt_by_id(PlayerId, DsgtId) of
                [_Status, EndTime] ->
                    case EndTime < NowTime + 5 of
                        true ->
                            lib_designation_util:delete_dsgt(PlayerId, DsgtId),
                            lib_designation:log_active_dsgt(?OP_REMOVE, PlayerId, DsgtId, NowTime, 0);
                        false ->
                            skip
                    end;
                _ ->
                    skip
            end
    end.

%% 在线取消称号 只有玩家在线的时候才操作
cancel_dsgt_online(PlayerId, DsgtId) ->
    Pid = misc:get_player_process(PlayerId),
    case misc:is_process_alive(Pid) of
        true ->
            gen_server:cast(Pid, {'apply_cast', ?APPLY_CAST_SAVE, lib_designation, cancel_dsgt, [DsgtId]});
        _ ->
            skip
    end.

%% 取消称号，全局称号被其他人替换的时候调用
cancel_global_dsgt(PlayerId, #active_para{id=Id}=ActivePara) ->
    case misc:get_player_process(PlayerId) of
        Pid when is_pid(Pid) ->
            case misc:is_process_alive(Pid) of
                true ->
                    gen_server:cast(Pid, {'apply_cast', ?APPLY_CAST_SAVE, lib_designation, cancel_dsgt_by_id, [ActivePara]});
                false ->
                    ?ERR("cancel_dsgt not found player process, RoleId:~p~n",[PlayerId])
            end;
        _ ->
            lib_designation_util:delete_dsgt(PlayerId, Id),
            lib_designation:log_active_dsgt(?OP_REMOVE, PlayerId, Id, utime:unixtime(), 0),
            false
    end.

get_dsgt_name(DsgtId) ->
    case data_designation:get_by_id(DsgtId) of
        #base_designation{name = Name} ->
            util:make_sure_binary(Name);
        _ -> <<>>
    end.

%% 判断称号是否已激活
is_dsgt_active(PS, DsgtId) ->
    #player_status{dsgt_status = DsgtStatus} = PS,
    DsgtMap = DsgtStatus#dsgt_status.dsgt_map,
    case maps:get(DsgtId, DsgtMap, none) of
        none -> false;
        _ -> true
    end.


%% 取消称号，在线不在线都可以用
remove_dsgt(PlayerId,  DesignationId) ->
    case misc:get_player_process(PlayerId) of
        Pid when is_pid(Pid) ->
            case misc:is_process_alive(Pid) of
                true ->
                    gen_server:cast(Pid, {'apply_cast', ?APPLY_CAST_SAVE, lib_designation, remove_dsgt, [DesignationId]});
                false ->
                    ?ERR("cancel_dsgt not found player process, RoleId:~p~n",[PlayerId])
            end;
        _ ->
            lib_designation_util:delete_dsgt(PlayerId, DesignationId),
            lib_designation:log_active_dsgt(?OP_REMOVE, PlayerId, DesignationId, utime:unixtime(), 0),
            false
    end.

remove_dsgt(DsgtIdList) ->
    OnlineRoles = ets:tab2list(?ETS_ONLINE),
    [remove_dsgt_list(E#ets_online.id, DsgtIdList) || E <- OnlineRoles],
    NowTime = utime:unixtime(),
    spawn(
        fun() ->
            [begin 
                timer:sleep(50),
                OwnerList = lib_designation_util:get_dsgt_owner(DsgtId),
                [lib_designation:log_active_dsgt(?OP_REMOVE, RoleId, DsgtId, NowTime, 0) || [RoleId, _] <- OwnerList],
                lib_designation_util:delete_all_dsgt_same_id(DsgtId)
            end || DsgtId <- DsgtIdList]
        end).
     

remove_dsgt_list(RoleId, DsgtIdList) ->
    case misc:get_player_process(RoleId) of
        Pid when is_pid(Pid) ->
            case misc:is_process_alive(Pid) of
                true ->
                    gen_server:cast(Pid, {'apply_cast', ?APPLY_CAST_SAVE, lib_designation, remove_dsgt_list, [DsgtIdList]});
                false ->
                    ?ERR("cancel_dsgt not found player process, RoleId:~p~n",[RoleId])
            end;
        _ ->
            false
    end.