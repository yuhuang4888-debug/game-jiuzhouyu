%%% @author root <root@localhost.localdomain>
%%% @copyright (C) 2018, root
%%% @doc
%%%
%%% @end
%%% Created :  3 Feb 2018 by root <root@localhost.localdomain>

-module(lib_designation_util).

-include("server.hrl").
-include("figure.hrl").
-include("designation.hrl").
-include("common.hrl").
-include("guild.hrl").
-include("career.hrl").
-include("def_fun.hrl").
-include("errcode.hrl").

-compile(export_all).

%% 玩家登陆时称号初始化
login(PlayerStatus) ->
    #player_status{id = PlayerId, figure = Figure} = PlayerStatus,
    List = get_actived_dgst(PlayerId),
    {DsgtStatus, CurrentUse} = login_init_dsgt_status(PlayerId, List),
    NewFigure = Figure#figure{designation = CurrentUse}, %% , designation_name = CurName},
    PlayerStatus#player_status{figure = NewFigure, dsgt_status = DsgtStatus}.

%% 初始化玩家的称号状态
%% List：从数据库中获取到的被激活过的称号列表
login_init_dsgt_status(PlayerId, List) ->
    NowTime = utime:unixtime(),
    {DsgtMap, UsedDsgtId, AttrList, ExpireList, HaveExpire}
        = init_info_and_attr(List, NowTime, #{}, 0, [], [], []),

    %% 删除过期称号
    update_expired_dsgt(ExpireList, PlayerId),
    %% 定时处理过期称号
    ?IF(HaveExpire == [], skip, lib_player_record:role_func_check_insert(PlayerId, designation, HaveExpire)),
    {#dsgt_status{player_id = PlayerId, dsgt_map = DsgtMap, attr = AttrList}, UsedDsgtId}.

%% 初始化 #dsgt_status.dsgt_map
init_info_and_attr([], _NowTime, Map, UsedId, AttrList, ExpireList, HaveExpire) ->
    {Map, UsedId, AttrList, ExpireList, HaveExpire};
init_info_and_attr([[DsgtId, Status, ActiveTime, EndTime, OpTime, Order]|T], NowTime, Map, UsedId, AttrList, ExpireList, HaveExpire) ->
    if
        EndTime =/= 0 andalso NowTime >= EndTime ->
            init_info_and_attr(T, NowTime, Map, UsedId, AttrList, [{DsgtId, EndTime}|ExpireList], HaveExpire);
        true ->
            case data_designation:get_by_id(DsgtId) of
                #base_designation{attr_list = DefAttr1, main_type = MainType, order_limit = MaxOrder} ->
                    R = #designation{id = DsgtId, status = Status, active_time = ActiveTime, end_time = EndTime, time = OpTime, dsgt_order = Order},
                    DefAttr = case MainType =:= ?GROWUP_DSGT of
                        true ->
                            case data_designation:get_by_id_order(DsgtId, Order) of
                                #base_dsgt_order{attr_list = DefAttr2} ->
                                    DefAttr2;
                                _ -> 
                                    case data_designation:get_by_id_order(DsgtId, MaxOrder) of
                                        #base_dsgt_order{attr_list = DefAttr2} ->
                                            DefAttr2;
                                        [] -> []
                                    end
                            end;
                        false -> DefAttr1
                    end,
                    NewMap = maps:put(DsgtId, R, Map),
                    NewAttrList = ulists:kv_list_plus_extra([DefAttr, AttrList]),
                    NewUsedId = ?IF(Status =/= ?STATUS_USED, UsedId, DsgtId),
                    NHaveExpire = ?IF(EndTime > NowTime, [{DsgtId, EndTime}|HaveExpire], HaveExpire),
                    init_info_and_attr(T, NowTime, NewMap, NewUsedId, NewAttrList, ExpireList, NHaveExpire);
                _ -> %% 配置不存在干掉
                    init_info_and_attr(T, NowTime, Map, UsedId, AttrList, [{DsgtId, EndTime}|ExpireList], HaveExpire)
            end
    end;
init_info_and_attr([_H|T], NowTime, Map, UsedId, AttrList, ExpireList, HaveExpire) ->
    init_info_and_attr(T, NowTime, Map, UsedId, AttrList, ExpireList, HaveExpire).

%% 批量删除玩家称号
update_expired_dsgt([], _PlyaerId) -> ok;
update_expired_dsgt(ExpiredList, PlayerId) ->
    Fun = fun({Id, EndTime}, {I, Acc, List}) when I==1 ->
                  {I+1, lists:append(Acc, integer_to_list(Id)), [{Id, EndTime}|List]};
             ({Id,EndTime}, {I, Acc, List}) ->
                  {I+1, lists:append(Acc, "," ++ integer_to_list(Id)), [{Id, EndTime}|List]}
          end,
    {_I, IdList, DeleteLog} = lists:foldl(Fun, {1, "", []}, ExpiredList),
    Sql = io_lib:format(?SQL_DSGT_AUTOID_BATCH_DELETE, [PlayerId, IdList]),
    lib_designation:log_delete_designation_list(PlayerId, DeleteLog),
    db:execute(Sql).

%% 找出需要删除全局称号的玩家id
%% OwnerList：旧的拥有者
%% PlayerIdList：需要激活的玩家
%% Global：该称号同时拥有的数量
find_delete_list(OwnerList, PlayerIdList, Global) ->
    F1 = fun([_PlayerId1, ActiveTime1], [_PlayerId2, ActiveTime2]) -> ActiveTime1 > ActiveTime2 end,
    OldOwnerList = lists:sort(F1, OwnerList),
    ActiveLen = length(PlayerIdList),
    FreeLen = max(Global - ActiveLen, 0),
    F2 = fun([PId, _AcT], {Acc, List}) ->
                 case lists:member(PId, PlayerIdList) of
                     false when Acc =< FreeLen -> {Acc+1, List};
                     false -> {Acc+1, [PId|List]};
                     _ -> {Acc+1, List}
                 end
         end,
    {_, DeleteList} = lists:foldl(F2, {1, []}, OldOwnerList),
    DeleteList.

%% ================================= db fun =================================
%% 获取玩家所有的称号
get_actived_dgst(PlayerId) ->
    Sql = io_lib:format(?SQL_All_DSGT_SELECT, [PlayerId]),
    db:get_all(Sql).

%% 获取称号的拥有者
get_dsgt_owner(DsgtId) ->
    Sql = io_lib:format(?SQL_DSGT_PLAYER_SELECT, [DsgtId]),
    db:get_all(Sql).

delete_all_dsgt_same_id(DsgtId) ->
    Sql = io_lib:format(?SQL_DSGT_DELETE_ID, [DsgtId]),
    db:execute(Sql).

%% 获取玩家所有的称号id
get_player_designation_ids(PlayerId) ->
    Sql = io_lib:format(?SQL_DSGT_SEL_ID, [PlayerId]),
    db:get_all(Sql).

%% 删除数据库中称号
delete_dsgt(PlayerId, Id) ->
    Sql = io_lib:format(?SQL_DSGT_DELETE, [PlayerId, Id]),
    db:execute(Sql).

%% 更新称号数据
update_dsgt_status(PlayerId, Designation) ->
    #designation{id = Id, status = Status, active_time = ActiveTime,
                 end_time = EndTime, time = Time, dsgt_order = Order} = Designation,
    Sql = io_lib:format(?SQL_DSGT_REPLACE, [PlayerId, Id, Status, ActiveTime, EndTime, Time, Order]),
    db:execute(Sql).

%% 更新玩家的称号信息
update_dsgt_status(PlayerId, Id, Status, ActiveTime, EndTime) ->
    NowTime = utime:unixtime(),
    Sql = io_lib:format(?SQL_DSGT_UP, [Status, ActiveTime, EndTime, NowTime, PlayerId, Id]),
    db:execute(Sql).

%% 获取称号的佩戴和时效
select_dsgt_by_id(PlayerId, Id) ->
    Sql = io_lib:format(?SQL_DSGT_SEL_STATUS, [PlayerId, Id]),
    db:get_row(Sql).

%% 更新佩戴和卸下状态
update_dsgt_state(PlayerId, Id, Status) ->
    NowTime = utime:unixtime(),
    Sql = io_lib:format(?SQL_DSGT_STATE_UP, [Status, NowTime, PlayerId, Id]),
    db:execute(Sql).

%% ================================= 称号检查 =================================
checklist([]) -> true;
checklist([H|T]) ->
    case check(H) of
        true -> checklist(T);
        {fail, Errno} -> {fail, Errno}
    end.

%% 检查id是否等于当前使用的称号id
check({check_hide_current, {Id, CurrentId}}) ->
    if
    	Id =:= CurrentId -> true;
    	true -> {fail, ?ERRCODE(err411_hide_error)}
    end;
%% 检查当前使用的称号是否存在
check({check_current_exist, {CurrentId, DsgtMap}}) when CurrentId =/= 0->
    case maps:find(CurrentId, DsgtMap) of
    	{ok, _Value} -> true;
    	error -> {fail, ?ERRCODE(err411_current_not_exist)}
    end;
%% 检查更换id是否是当前使用的id
check({check_change_same_id, {Id, CurrentId}}) ->
    if
    	Id =:= CurrentId -> {fail, ?ERRCODE(err411_not_need_change)};
    	true -> true
    end;
%% 检查id是否已经激活
check({check_id_valid, {Id, DsgtMap}}) ->
    case maps:find(Id, DsgtMap) of
		{ok, _Value} -> true;
		error -> {fail, ?ERRCODE(err411_change_error)}
	end;
%% 检查id是否过期
check({check_is_expire, {Id, DsgtMap}}) ->
	NowTime = utime:unixtime(),
	{ok, Designation} = maps:find(Id, DsgtMap),
	if
		Designation#designation.end_time =/= 0, NowTime >= Designation#designation.end_time ->
			{fail, ?ERRCODE(err411_is_expired)};		
        true ->
			true
	end;
check(Msg) ->
    Msg.
