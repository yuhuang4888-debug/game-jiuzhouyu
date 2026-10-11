%%%-------------------------------------------------------------------
%%% @author root <root@localhost.localdomain>
%%% @copyright (C) 2018, root
%%% @doc
%%% 场景线路管理
%%% @end
%%% Created : 25 Apr 2018 by root <root@localhost.localdomain>
%%%-------------------------------------------------------------------
-module(mod_scene_line).

%% API
-export([start_link/0]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).

-compile(export_all).

-include("common.hrl").
-include("scene.hrl").
-include("def_fun.hrl").

%%%===================================================================
%%% API
%%%===================================================================
start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

%% 获取线路情况
get_scene_lines_info(RoleId, MySceneId, MyPoolId, MyCopyId)->
    gen_server:cast(?MODULE, {'get_scene_lines_info', RoleId, MySceneId, MyPoolId, MyCopyId}).

%% 检查进入线路
check_can_enter_line(SceneId, PoolId, CopyId, NowTime)->
    gen_server:call(?MODULE, {'check_can_enter_line', SceneId, PoolId, CopyId, NowTime}).

%% 获取可以进入的场景pid和房间id
get_poolid_copyid(AutoLine, SceneId, PoolId, CopyId, RoleId)->
    gen_server:call(?MODULE, {'get_poolid_copyid', AutoLine, SceneId, PoolId, CopyId, RoleId}).

%% 减少场景人数
reduce_user_num(RoleId, SceneId, PoolId, CopyId, Num)->
    gen_server:cast(?MODULE, {'reduce_user_num', RoleId, SceneId, PoolId, CopyId, Num}).

%% 定时同步检查场景玩家人数
sync_scene_user_num()->
    gen_server:cast(?MODULE, {'sync_scene_user_num'}).

%% 设置场景玩家人数
set_scene_user_num(SceneId, PoolId, CopyId, Value, Ids)->
    gen_server:cast(?MODULE, {'set_scene_user_num', SceneId, PoolId, CopyId, Value, Ids}).

%%%===================================================================
%%% gen_server callbacks
%%%===================================================================

%%--------------------------------------------------------------------
init([]) ->
    process_flag(trap_exit, true),
    {ok, []}.

%%--------------------------------------------------------------------
handle_call(Request, From, State)->
    case catch do_handle_call(Request, From, State) of
        {'EXIT', _R} ->
            ?ERR("~p ~p call_error:~p~n", [?MODULE, ?LINE, _R]),
            io:format("~p ~p call_error:~p~n", [?MODULE, ?LINE, _R]),
            {reply, ok, State};
        Reply ->
            Reply
    end.

%% 检查能不能进入场景线路
do_handle_call({'check_can_enter_line', SceneId, PoolId, CopyId, NowTime}, _From, Status)->
    %% 相应的场景poolid进程
    case ets:match_object(?ETS_SCENE_LINES,
                          #ets_scene_lines{scene=SceneId, pool_id=PoolId, _='_'}) of
        [] -> Res = false;
        [#ets_scene_lines{lines = Lines} = ScenePLine|_] ->
            case maps:get(CopyId, Lines, null) of
                null -> Res = false;
                {PeopleNum, RoleIds, ChangeTime} ->
                    if
                        NowTime - ChangeTime < 500 -> %% 判断是不是快到回收时间,减少ets表的操作次数
                            Res = true;
                        true ->
                            ets:match_delete(?ETS_SCENE_LINES,
                                             #ets_scene_lines{scene=SceneId, pool_id=PoolId, _='_'}),
                            %% 被玩家新切的线路，不会被回收
                            NewLines = maps:update(CopyId, {PeopleNum, RoleIds, NowTime}, Lines),
                            ets:insert(?ETS_SCENE_LINES, ScenePLine#ets_scene_lines{lines = NewLines}),
                            Res = true
                    end
            end
    end,
    {reply, Res, Status};

%% 选择进入的pool_id和copy_id
do_handle_call({'get_poolid_copyid', AutoLine, SceneId, PoolId, CopyId, RoleId}, _From, Status)->
    %% 找出相应场景所有的线路信息
    ScenePList = ets:match_object(?ETS_SCENE_LINES, #ets_scene_lines{scene=SceneId, _='_', _='_'}),
    %% 选取一个可以进入的线路
    {TPoolId, TCopyId} = do_get_poolid_copyid(ScenePList, AutoLine, SceneId, PoolId, CopyId, RoleId),
    if
        TCopyId >= ?MAX_ONE_ROOM->
            ?ERR("~p ~p select copy_id error AutoLine, SceneId, TPoolId, TCopyId, RoleId:~p~n",
                 [?MODULE, ?LINE, [AutoLine, SceneId, TPoolId, TCopyId, RoleId]]);
        true ->
            skip
    end,
    {reply, {TPoolId, TCopyId}, Status};

do_handle_call(_Request, _From, State)->
    io:format("~p ~p _Request:~w~n", [?MODULE, ?LINE, [_Request]]),
    {reply, ok, State}.

%%--------------------------------------------------------------------
handle_cast(Msg, State)->
    case catch do_handle_cast(Msg, State) of
        {'EXIT', _R} ->
            ?ERR("~p ~p cast_error:~p~n", [?MODULE, ?LINE, _R]),
            io:format("~p ~p cast_error:~p~n", [?MODULE, ?LINE, _R]),
            {noreply, State};
        Reply ->
            Reply
    end.

%% 获取场景的线路情况
do_handle_cast({'get_scene_lines_info', RoleId, SceneId, PoolId, CopyId}, State)->
    case data_scene:get(SceneId) of
        #ets_scene{type = Type} when Type == ?SCENE_TYPE_OUTSIDE;
                                     Type == ?SCENE_TYPE_NORMAL ->
            %% 相应场景的线路
            SceneList = ets:match_object(?ETS_SCENE_LINES,
                                         #ets_scene_lines{scene=SceneId, _='_', _='_'}),
            %% 查找所有的线路信息
            F = fun(Info, TLines) ->
                        #ets_scene_lines{pool_id = PoolId1, lines = Lines} = Info,
                        F1 = fun({N, {Num, _Ids, _Time}}, TTLines)->
                                     ?IF(N >= ?MAX_ONE_ROOM, TTLines,
                                         [{N+PoolId1*?MAX_ONE_ROOM, Num}|TTLines])
                             end,
                        lists:foldl(F1, TLines, maps:to_list(Lines))
                        %% NewList = [{N+PoolId1*?MAX_ONE_ROOM, Num}||
                        %%               {N, {Num, _Ids, _Time}} <- maps:to_list(Lines), N < ?MAX_ONE_ROOM],
                        %% TLines ++ NewList
                end,
            MyLine = CopyId+PoolId*?MAX_ONE_ROOM+1,
            case lists:foldl(F, [], SceneList) of
                [] ->  Lines = [{0, 0}];
                Lines -> skip
            end;
        _ ->
            {MyLine, Lines} = {1, [{0, 0}]}
    end,
    %% io:format("~p ~p [Scene, MyLine, Lines]:~p~n", [?MODULE, ?LINE, [SceneId, MyLine, Lines]]),
    lib_server_send:send_to_uid(RoleId, pt_120, 12040, [SceneId, MyLine, Lines]),
    {noreply, State};

%% 减少人数
do_handle_cast({'reduce_user_num', RoleId, SceneId, PoolId, CopyId, ReduceNum}, Status)->
    #ets_scene{type = SceneType} = data_scene:get(SceneId),
    case ets:match_object(?ETS_SCENE_LINES,
                          #ets_scene_lines{scene = SceneId, pool_id = PoolId, _='_'}) of
        [] when ReduceNum =< 0 -> skip;
        [] ->
            NowTime = utime:unixtime(),
            PeopleNum = max(0, ReduceNum),
            case lists:member(SceneType, ?SCENE_TYPE_NEED_SUB_LINE) of
                false ->
                    ets:insert(?ETS_SCENE_LINES,
                               #ets_scene_lines{scene = SceneId, pool_id = PoolId, num = PeopleNum});
                true  ->
                    if
                        CopyId >= ?MAX_ONE_ROOM ->
                            ?ERR("~p ~p ReduceNum CopyId Error RoleId, SceneId, PoolId, CopyId, ReduceNum:~p~n",
                                 [?MODULE, ?LINE, [RoleId, SceneId, PoolId, CopyId, ReduceNum]]);
                        true ->
                            skip
                    end,
                    ets:insert(?ETS_SCENE_LINES,
                               #ets_scene_lines{scene = SceneId, pool_id = PoolId,
                                                num = PeopleNum, lines=#{CopyId => {PeopleNum, [], NowTime}}})
            end;
        [ScenePLine|_] ->
            NowTime = utime:unixtime(),
            #ets_scene_lines{num = OAllPeopleNum, lines = Lines} = ScenePLine,
            ets:match_delete(?ETS_SCENE_LINES,
                             #ets_scene_lines{scene = SceneId, pool_id = PoolId, _='_'}),
            %% 更新玩家人数
            NewLines
                = case lists:member(SceneType, ?SCENE_TYPE_NEED_SUB_LINE) of
                      true ->
                          if
                              CopyId >= ?MAX_ONE_ROOM ->
                                  ?ERR("~p ~p ReduceNum CopyId Error RoleId, SceneId, PoolId, CopyId, ReduceNum:~p~n",
                                       [?MODULE, ?LINE, [RoleId, SceneId, PoolId, CopyId, ReduceNum]]);
                              true ->
                                  skip
                          end,
                          case maps:get(CopyId, Lines, null) of
                              null ->
                                  ?ERR("~p ~p can not get line RoleId, SceneId, PoolId, CopyId, ReduceNum:~p~n",
                                       [?MODULE, ?LINE, [RoleId, SceneId, PoolId, CopyId]]),
                                  Lines#{CopyId => {0, [], NowTime}};
                              {PeopleNum, Ids, _Time} ->
                                  case lists:member(RoleId, Ids) of
                                      false ->
                                          NPeopleNum = PeopleNum,
                                          NewIds = Ids;
                                      true ->
                                          NPeopleNum = max(0, PeopleNum + ReduceNum),
                                          NewIds = lists:delete(RoleId, Ids)
                                  end,
                                  maps:update(CopyId, {NPeopleNum, NewIds, NowTime}, Lines)
                          end;
                      false ->
                          Lines
                  end,
            %% io:format("~p ~p NewLines:~p~n", [?MODULE, ?LINE, [NewLines]]),
            NewScenePLine = ScenePLine#ets_scene_lines{num = max(0, OAllPeopleNum+ReduceNum), lines = NewLines},
            ets:insert(?ETS_SCENE_LINES, NewScenePLine)
    end,
    {noreply, Status};

%% 同步场景人数
do_handle_cast({'sync_scene_user_num'}, State)->
    SceneIds
        = data_scene:get_id_list_by_type(?SCENE_TYPE_NORMAL) ++
        data_scene:get_id_list_by_type(?SCENE_TYPE_OUTSIDE),
    do_sync_scene_user_num(SceneIds),
    {noreply, State};

%% 设置场景人数(上一次的操作时间和现在的操作时间如果大于10分钟，就清理掉)
do_handle_cast({'set_scene_user_num', SceneId, PoolId, CopyId, OCopyValue, Ids}, State)->
    case ets:match_object(?ETS_SCENE_LINES,
                          #ets_scene_lines{scene = SceneId, pool_id = PoolId, _='_'}) of
        [] -> %% 按道理不会出现的情况，直接忽略
            skip;
        [ScenePLine|_] ->
            NowTime = utime:unixtime(),
            #ets_scene_lines{lines = Lines} = ScenePLine,
            ets:match_delete(?ETS_SCENE_LINES,
                             #ets_scene_lines{scene = SceneId, pool_id = PoolId, _ = '_'}),
            %% 只会处理主城和野外
            %% 返回的场景玩家人数
            UserNum = length(Ids),
            {OldNum, OldChangeIds, OldChangeTime} = maps:get(CopyId, Lines),
            {ONum, OChangeIds, OChangeTime} = OCopyValue,
            NewLines
                = if
                      %% 时间一致，人数为0，最后修改时间大于10分钟，不可能出现 0 0的情况
                      OldChangeTime =:= OChangeTime andalso
                      UserNum == OldNum andalso OldNum == 0 andalso
                      NowTime - OldChangeTime > 600 ->
                          mod_scene_agent:clear_scene(SceneId, PoolId, CopyId),
                          ?ERR("~p ~p clear_scene:~p~n", [?MODULE, ?LINE, [SceneId, PoolId, CopyId]]),
                          %% 删除房间
                          maps:remove(CopyId, Lines);

                      %% 人数一致：可以不操作
                      OldNum == UserNum andalso OldNum == ONum andalso OldNum == 0 ->
                          Lines;

                      %% 其他情况
                      true ->
                          %% 计算最新的RoleIds
                          %% 先计算新旧差异，在添加到最新的场景玩家id列表(最初可能和实际的不同，但是到最后都会一致)
                          NewIds = calc_new_diff_ids(OldChangeIds, OChangeIds, Ids),
                          NewUserNum = length(NewIds),
                          %% 更新到最新
                          V = {NewUserNum, NewIds, OldChangeTime},
                          maps:update(CopyId, V, Lines)
                  end,
            ets:insert(?ETS_SCENE_LINES, ScenePLine#ets_scene_lines{lines = NewLines})
    end,
    {noreply, State};

do_handle_cast(_Msg, State)->
    io:format("~p ~p _Msg:~w~n", [?MODULE, ?LINE, [_Msg]]),
    {noreply, State}.

%%--------------------------------------------------------------------
handle_info(Info, State)->
    case catch do_handle_info(Info, State) of
        {'EXIT', _R} ->
            ?ERR("~p ~p info_error:~p~n", [?MODULE, ?LINE, _R]),
            io:format("~p ~p info_error:~p~n", [?MODULE, ?LINE, _R]),
            {noreply, State};
        Reply ->
            Reply
    end.

do_handle_info(_Info, State)->
    io:format("~p ~p _Info:~w~n", [?MODULE, ?LINE, [_Info]]),
    {noreply, State}.

%%--------------------------------------------------------------------
terminate(_Reason, _State) ->
    %% ?ERR("~p is terminate:~p", [?MODULE, _Reason]),
    ok.

%%--------------------------------------------------------------------
code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================

%% 在所有的场景线路选取一个可以进入房间
%% 12005中默认是PoolId=0, CopyId=0
%% 默认 pool_id = 0; copy_id = 0
%% 找不到场景的线路信息，直接默认为第一个人第一次进入场景
do_get_poolid_copyid([], _AutoLine, SceneId, _PoolId, _CopyId, RoleId) ->
    NowTime = utime:unixtime(),
    NSceneLines = #ets_scene_lines{scene = SceneId, pool_id = 0, num = 1,
                                   lines=#{0 => {1, [RoleId], NowTime}}},
    ets:insert(?ETS_SCENE_LINES, NSceneLines),
    {0, 0};
%% 自动选择线路操作
do_get_poolid_copyid(ScenePLines, AutoLine, SceneId, _PoolId, _CopyId, RoleId) when AutoLine ->
    %% 遍历所有的场景线路
    case for_all_pool_copy_id(ScenePLines, [], 0) of
        {rand_poolid, TPoolId, TCopyId} ->
            NowTime = utime:unixtime(),
            case lists:keyfind(TPoolId, #ets_scene_lines.pool_id,  ScenePLines) of
                false ->
                    skip;
                ScenePLine ->
                    update_new_scene_pool_lines(SceneId, TPoolId, TCopyId, RoleId, NowTime, ScenePLine)
            end,
            {TPoolId, TCopyId};

        %% 创建的新场景进程
        {create_poolid,  TPoolId, TCopyId, ScenePLine, CreatePoolId} ->
            NowTime = utime:unixtime(),
            case catch mod_scene_init:start_scene(SceneId, CreatePoolId) of
                ScenePid when is_pid(ScenePid) ->
                    ets:match_delete(?ETS_SCENE_LINES,
                                     #ets_scene_lines{scene=SceneId, pool_id=CreatePoolId, _ = '_'}),
                    ets:insert(?ETS_SCENE_LINES,
                               #ets_scene_lines{scene = SceneId, pool_id = CreatePoolId,
                                                num = 0, lines=#{0 => {0, [], NowTime}}});
                _R ->
                    ?ERR("~p ~p create_new_pool_id_R:~p~n", [?MODULE, ?LINE, _R])
            end,
            update_new_scene_pool_lines(SceneId, TPoolId, TCopyId, RoleId, NowTime, ScenePLine),
            {TPoolId, TCopyId};

        %% 复制一条线路
        {create_copyid, TPoolId, TCopyId, TScenePLines, CreateCopyId} ->
            NowTime = utime:unixtime(),
            #ets_scene_lines{lines = Lines} = TScenePLines,
            case catch mod_scene_init:copy_a_outside_scene(SceneId, TPoolId, CreateCopyId, 1) of
                true ->
                    NewLines = Lines#{CreateCopyId => {0, [], NowTime}};
                _R ->
                    ?ERR("~p ~p create_new_pool_id_R:~p~n", [?MODULE, ?LINE, _R]),
                    NewLines = Lines
            end,
            ScenePLine = TScenePLines#ets_scene_lines{lines = NewLines},
            update_new_scene_pool_lines(SceneId, TPoolId, TCopyId, RoleId, NowTime, ScenePLine),
            {TPoolId, TCopyId};

        %% 默认进入
        {def_enter_copyid, TPoolId, TCopyId, ScenePLine} ->
            NowTime = utime:unixtime(),
            update_new_scene_pool_lines(SceneId, TPoolId, TCopyId, RoleId, NowTime, ScenePLine),
            {TPoolId, TCopyId}
    end;
%% 直接设置线路操作
do_get_poolid_copyid(ScenePLines, _AutoLine, SceneId, TPoolId, TCopyId, RoleId)->
    if
        TPoolId > ?MAX_POOLID orelse TCopyId >= ?MAX_ONE_ROOM ->
            %% 当玩家发送错误线路的时候进入自动线路选择
            ?ERR("max_pool_id_orelse_max_copy_id:~p~n", [[SceneId, TPoolId, TCopyId, RoleId]]),
            do_get_poolid_copyid(ScenePLines, true, SceneId, TPoolId, TCopyId, RoleId);
        true ->
            case lists:keyfind(TPoolId, #ets_scene_lines.pool_id, ScenePLines) of
                false ->
                    %% 找不到的情况也默认进入随机选取线路
                    ?ERR("can_not_find_pool_id:~p~n", [[SceneId, TPoolId, TCopyId, RoleId]]),
                    do_get_poolid_copyid(ScenePLines, true, SceneId, TPoolId, TCopyId, RoleId);
                #ets_scene_lines{num = AllPeopleNum, lines = Lines} = ScenePLine ->
                    case maps:get(TCopyId, Lines, null) of
                        null ->
                            %% 找不到的情况也默认进入随机选取线路
                            ?ERR("can_not_find_line:~p~n", [[SceneId, TPoolId, TCopyId, RoleId]]),
                            do_get_poolid_copyid(ScenePLines, true, SceneId, TPoolId, TCopyId, RoleId);
                        {PepoleNum, Ids, _} ->
                            %% 先清理掉
                            ets:match_delete(?ETS_SCENE_LINES,
                                             #ets_scene_lines{scene = SceneId, pool_id = TPoolId, _ = '_'}),
                            NowTime = utime:unixtime(),
                            {NewAllPeopleNum, NewLines}
                                = case lists:member(RoleId, Ids) of
                                      false ->
                                          Lines1 = maps:update(TCopyId, {PepoleNum+1, [RoleId|Ids], NowTime}, Lines),
                                          {AllPeopleNum+1, Lines1};
                                      true ->
                                          Lines1 = maps:update(TCopyId, {PepoleNum, Ids, NowTime}, Lines),
                                          {AllPeopleNum, Lines1}
                                  end,
                            ets:insert(?ETS_SCENE_LINES,
                                       ScenePLine#ets_scene_lines{num = NewAllPeopleNum, lines = NewLines}),
                            {TPoolId, TCopyId}
                    end
            end
    end.

%% 选择一个可以进入的房间号:优先进有人但未满人的房间
%% 现在的规则优选选择人少的房间
%% return:false|{CopyId, Pepoles}
sel_a_copy_id(Lines, RoomMaxPepole) ->
    LinesList = maps:to_list(Lines),
    %% 优先进有人但未满人的房间
    case do_sel_copy_id(1, RoomMaxPepole, LinesList) of
        {CopyId, Pepoles} -> {CopyId, Pepoles};
        _ -> do_sel_copy_id(0, RoomMaxPepole, LinesList)
    end.

%% 返回房间数据copyid和roomnum
do_sel_copy_id(_Min, _Max, []) -> false;
do_sel_copy_id(Min, Max, [{CopyId, {PeopleNum, Ids, _ChangeTime}}|L])
  when CopyId < ?MAX_ONE_ROOM-> %% 房间号一定是小于10的
    IdsLen = length(Ids),
    if
        IdsLen >= Max orelse PeopleNum >= Max ->
            do_sel_copy_id(Min, Max, L);
        true ->
            {CopyId, PeopleNum}
    end;
do_sel_copy_id(Min, Max, [_|L]) -> do_sel_copy_id(Min, Max, L).

%% 优选选取人少的房间
sel_a_less_people_copyid(Lines, RoomMaxPepole)->
    LinesList = lists:sort(fun less_people_sort/2, maps:to_list(Lines)),
    %% io:format("~p ~p LinesList:~p~n", [?MODULE, ?LINE, [LinesList]]),
    %% 优先进人数最少的房间
    case do_sel_less_copy_id(0, RoomMaxPepole, LinesList) of
        {CopyId, Pepoles} -> {CopyId, Pepoles};
        _ -> false
    end.

%% 返回房间数据copyid和roomnum
do_sel_less_copy_id(_Min, _Max, []) -> false;
do_sel_less_copy_id(Min, Max, [{CopyId, {PeopleNum, Ids, _ChangeTime}}|L])
  when CopyId < ?MAX_ONE_ROOM-> %% 房间号一定是小于10的
    IdsLen = length(Ids),
    if
        IdsLen >= Max orelse PeopleNum >= Max ->
            do_sel_less_copy_id(Min, Max, L);
        true ->
            {CopyId, PeopleNum}
    end;
do_sel_less_copy_id(Min, Max, [_|L]) ->
    do_sel_less_copy_id(Min, Max, L).

%% 遍历所有的场景线路
for_all_pool_copy_id([], MinScenePLines, MaxPoolId)->
    #ets_scene_lines{pool_id = PoolId, lines = Lines} = MinScenePLines,
    MinSize = maps:size(Lines),
    if
        %% 所有都是满的线路,就随机选择(30条线)
        MinSize == ?MAX_ONE_ROOM andalso MaxPoolId == ?MAX_POOLID ->
            RandPoolId = urand:rand(0, ?MAX_POOLID),
            RandCopyId = urand:rand(0, ?MAX_ONE_ROOM-1),
            {rand_poolid, RandPoolId, RandCopyId};

        %% 这条线是满的,并且线路不是最大的pool_id
        MinSize == ?MAX_ONE_ROOM andalso MaxPoolId < ?MAX_POOLID ->
            NewMaxPoolId = MaxPoolId + 1,
            RandCopyId = urand:rand(0, ?MAX_ONE_ROOM-1),
            %% 先创建，丢进旧的房间
            {create_poolid, PoolId, RandCopyId, MinScenePLines, NewMaxPoolId};

        true -> %% 要创建一个新的房间(序号最小的)
            if
                PoolId == 0 ->
                    L = lists:seq(1, ?MAX_ONE_ROOM-1);
                true ->
                    L = lists:seq(0, ?MAX_ONE_ROOM-1)
            end,
            case get_min_copy_id(L, Lines) of
                false -> %% 默认进入
                    {def_enter_copyid, PoolId, 0, MinScenePLines};
                MinCopyId -> %% 先创建，丢进旧的房间
                    RandCopyId = urand:rand(0, MinCopyId-1),
                    {create_copyid, PoolId, RandCopyId, MinScenePLines, MinCopyId}
            end
    end;

%%
for_all_pool_copy_id([SPLine|ScenePLines], MinScenePLines, MaxPoolId) ->
    #ets_scene_lines{pool_id = PoolId, lines = Lines} = SPLine,
    %% 选一个可以进入的线路id
    %% case sel_a_copy_id(Lines, ?MAX_PEPOLE) of
    case sel_a_less_people_copyid(Lines, ?MAX_PEPOLE) of
        {EnterCopyId, _Pepoles} ->
            {def_enter_copyid, PoolId, EnterCopyId, SPLine};
        false ->
            if
                MinScenePLines == [] -> %% 刚开始直接默认第一个保存
                    for_all_pool_copy_id(ScenePLines, SPLine, PoolId);
                true ->
                    #ets_scene_lines{pool_id = MinPoolId, lines = MinLines} = MinScenePLines,
                    MinSize = maps:size(MinLines),
                    Size = maps:size(Lines),
                    %% 把最大的pool保存起来
                    NewMaxPoolId = max(PoolId, MaxPoolId),
                    if
                        %% 房间都是满的情况下
                        MinSize == Size andalso MinSize == ?MAX_ONE_ROOM ->
                            if
                                MinPoolId < PoolId ->
                                    for_all_pool_copy_id(ScenePLines, SPLine, NewMaxPoolId);
                                true ->
                                    for_all_pool_copy_id(ScenePLines, MinScenePLines, NewMaxPoolId)
                            end;

                        %% 上一次的满，就保留这次的场景pool数据
                        MinSize == ?MAX_ONE_ROOM ->
                            for_all_pool_copy_id(ScenePLines, SPLine, NewMaxPoolId);

                        %% 这一次的满，就保留上一次的场景数据
                        Size == ?MAX_ONE_ROOM ->
                            for_all_pool_copy_id(ScenePLines, MinScenePLines, NewMaxPoolId);

                        %% 都是不满的情况下:取小的保存
                        true ->
                            if
                                MinPoolId > PoolId ->
                                    for_all_pool_copy_id(ScenePLines, SPLine, NewMaxPoolId);
                                true ->
                                    for_all_pool_copy_id(ScenePLines, MinScenePLines, NewMaxPoolId)
                            end
                    end
            end
    end.


%% 获取最小的房间id
get_min_copy_id([], _Lines)-> %% 都找不到就是直接进入0默认房间
    false;
get_min_copy_id([H|L], Lines)->
    case maps:get(H, Lines, false) of
        false -> H;
        _ -> get_min_copy_id(L, Lines)
    end.

do_sync_scene_user_num([]) -> ok;
do_sync_scene_user_num([SceneId|T])->
    ScenePList = ets:match_object(?ETS_SCENE_LINES,
                                  #ets_scene_lines{scene=SceneId, _='_', _='_'}),
    do_sync_scene_user_num_helper(ScenePList),
    do_sync_scene_user_num(T).

do_sync_scene_user_num_helper([])-> ok;
do_sync_scene_user_num_helper([ScenePLine|T])->
    #ets_scene_lines{scene = SceneId, pool_id = PoolId, lines = Lines} = ScenePLine,
    F = fun({CopyId, V}) ->
                if
                    PoolId =:= 0 andalso CopyId =:= 0 -> skip; %% 00是特殊的存在
                    true -> mod_scene_agent:sync_scene_user_num(SceneId, PoolId, CopyId, V)
                end
        end,
    [F(X) || X <- maps:to_list(Lines)],
    do_sync_scene_user_num_helper(T).

%% 计算玩家新的id
calc_new_diff_ids(OldChangeIds, OChangeIds, NewIds)->
    F = fun(Id, TIds) ->
                case lists:member(Id, TIds) of
                    false ->
                        IsOId = lists:member(Id, OChangeIds),
                        if
                            IsOId -> TIds; %% 实际是不存在
                            true -> [Id|TIds]
                        end;
                    true ->
                        TIds
                end
        end,
    lists:foldl(F, NewIds, OldChangeIds).

%% 更新线路数据
update_new_scene_pool_lines(SceneId, TPoolId, TCopyId, RoleId, NowTime, ScenePLine)->
    #ets_scene_lines{num = AllPeopleNum, lines = Lines} = ScenePLine,
    ets:match_delete(?ETS_SCENE_LINES,
                     #ets_scene_lines{scene = SceneId, pool_id = TPoolId, _ = '_'}),
    %% 先计数,避免拥挤
    {NewAllPeopleNum, NewLines}
        = case maps:get(TCopyId, Lines, null) of
              null ->
                  {AllPeopleNum+1, Lines#{TCopyId => {1, [RoleId], NowTime}}};
              {PepoleNum, Ids, _} ->
                  case lists:member(RoleId, Ids) of
                      false ->
                          Lines1 = maps:update(TCopyId, {PepoleNum+1, [RoleId|Ids], NowTime}, Lines),
                          {AllPeopleNum+1, Lines1};
                      true ->
                          Lines1 = maps:update(TCopyId, {PepoleNum, Ids, NowTime}, Lines),
                          {AllPeopleNum, Lines1}
                  end
          end,
    ets:insert(?ETS_SCENE_LINES,
               ScenePLine#ets_scene_lines{num = NewAllPeopleNum, lines = NewLines}).

%% %% 单线最大人数
%% max_one_line_people() -> 30.
%% %% 单进程最大房间数
%% max_one_room() -> 10.
%% %% 最大房间数
%% max_all_room() -> 30.
%% %% 单场景最大进程数
%% max_scene_poolid() -> 2.

%% 客户端线路转为服务端的pool_id和copy_id
client_line_no_to_server(ClientLineNo)->
    LineSpan  = ?MAX_ONE_ROOM,
    NewLine   = ClientLineNo - 1,
    NewPoolId = NewLine div LineSpan,
    RealLine  = max(0, NewLine - NewPoolId*LineSpan),
    {NewPoolId, RealLine}.

%% 对人数最小的排序
less_people_sort({_, {AN, _, _}}, {_, {BN, _, _}})->
    if
        AN > BN -> false;
        true -> true
    end.
