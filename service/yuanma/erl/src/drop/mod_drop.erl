%% ---------------------------------------------------------
%% Author:  xyj
%% Email:   156702030@qq.com
%% Created: 2012-7-4
%% Description: 物品掉落(本服和跨服)
%% --------------------------------------------------------
-module(mod_drop).
-export([start_link/0, add_drop/1, delete_drop/1, get_drop/1, clean_drop/0, get_drop_id/0]).
-export([get_drops_info/7, pick_all/5, manual_drop_pickup/3, drop_pickup/3, drop_list_pickup/5]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
-include("drop.hrl").
-include("common.hrl").
-include("errcode.hrl").

-record(state, {
        n = 0,              % 自增
        server_id = 0,      % 服id
        dict = dict:new(),  % Key:#ets_drop.id Value: #ets_drop{}
        role_map = #{}      % Key:#drop_role.id Value: #drop_role{}
    }).

%% 插入掉落物品
add_drop(DropInfo) ->
    gen_server:call(?MODULE, {add, DropInfo}).

%% 删除掉落物品
delete_drop(DropId) ->
    gen_server:call(?MODULE, {delete, DropId}).

%% 获得掉落物品
get_drop(DropId) ->
    gen_server:call(?MODULE, {get, DropId}).

%% 清理掉落物品
clean_drop() ->
    gen_server:cast(?MODULE, {clean}).

%% 取掉落物品ID
get_drop_id() ->
    gen_server:call(?MODULE, {drop_id}).

%% 拾取所有的掉落
pick_all(RoleId, SceneId, ScenePoolId, Copy, MFA) ->
    gen_server:cast(?MODULE, {pick_all, RoleId, SceneId, ScenePoolId, Copy, MFA}).

%% 客户端登录请求掉落包信息(跨服和本服)
get_drops_info(Node, RoleId, Scene, PoolId, CopyId, RoleX, RoleY)->
    gen_server:cast(?MODULE, {get_drops_info, Node, RoleId, Scene, PoolId, CopyId, RoleX, RoleY}).

%% 拾取掉落
drop_pickup(Node, DropId, PsArgs)->
    gen_server:cast(?MODULE, {drop_pickup, Node, DropId, PsArgs}).

%% 手动拾取掉落
manual_drop_pickup(Node, DropId, PsArgs)->
    gen_server:cast(?MODULE, {manual_drop_pickup, Node, DropId, PsArgs}).

%% 拾取掉落列表
drop_list_pickup(Node, DropIdList, PsArgs, MonArgs, Alloc)->
    gen_server:cast(?MODULE, {drop_list_pickup, Node, DropIdList, PsArgs, MonArgs, Alloc}).

%% -----------------------------------------------------------------------

start_link() ->
    gen_server:start_link({local,?MODULE}, ?MODULE, [], []).

init([]) ->
    AutoId = case config:get_cls_type() of
        ?NODE_CENTER -> 2;
        _ -> 1
    end,
    SerId = config:get_server_id(),
    D = dict:new(),
    {ok, #state{n=AutoId, server_id=SerId, dict=D}}.

handle_call(Req, From, State) ->
    case catch do_handle_call(Req, From, State) of
        {'EXIT', _R} ->
            ?ERR("Req Error:~p~n", [[Req, _R]]),
            {reply, ok, State};
        Res ->
            Res
    end.

handle_cast(Msg, State) ->
    case catch do_handle_cast(Msg, State) of
        {'EXIT', _R} ->
            ?ERR("Msg Error:~p~n", [[Msg, _R]]),
            {noreply, State};
        Res ->
            Res
    end.

handle_info(Info, State) ->
    case catch do_handle_info(Info, State) of
        {'EXIT', _R} ->
            ?ERR("Info Error:~p~n", [[Info, _R]]),
            {noreply, State};
        Res ->
            Res
    end.

%% ================================= private fun =================================
do_handle_call({drop_id}, _FROM, State) ->
    #state{n=N, server_id=SerId} = State,
    <<AutoId:48>> = <<SerId:16, N:32>>,
    N1 = N + 2,
    {reply, AutoId, State#state{n=N1}};

do_handle_call({add, DropInfo}, _FROM, Status) ->
    #state{dict = OldDict} = Status,
    case is_record(DropInfo, ets_drop) of
        true ->
            Key = DropInfo#ets_drop.id,
            D = dict:store(Key, DropInfo, OldDict),
            NewD = D;
        false ->
            NewD = OldDict
    end,
    NewStatus = Status#state{dict = NewD},
    {reply, ok, NewStatus};

do_handle_call({delete, DropId}, _FROM, Status) ->
    #state{dict = OldDict} = Status,
    case dict:is_key(DropId, OldDict) of
        true ->
            NewD = dict:erase(DropId, OldDict);
        false ->
            NewD = OldDict
    end,
    NewStatus = Status#state{dict = NewD},
    {reply, ok, NewStatus};

do_handle_call({get, DropId}, _FROM, Status) ->
    #state{dict = OldDict} = Status,
    case dict:is_key(DropId, OldDict) of
        true ->
            {ok, DropInfo} = dict:find(DropId, OldDict);
        false ->
            DropInfo = {}
    end,
    {reply, DropInfo, Status};

do_handle_call(_Req, _From, State) ->
    {reply, ok, State}.

%% 
do_handle_cast({clean}, Status) ->
    #state{dict = OldDict, role_map = RoleMap} = Status,
    NowTime = utime:unixtime(),
    List = dict:to_list(OldDict),
    List2 = filter_list(List, [], NowTime),
    NewD = delete_expire_drop(List2, OldDict),
    NewRoleMap = delete_drop_role(RoleMap),
    NewStatus = Status#state{dict = NewD, role_map = NewRoleMap},
    {noreply, NewStatus};

do_handle_cast({pick_all, RoleId, SceneId, ScenePoolId, CopyId, Handler}, Status) ->
    #state{dict = Dict} = Status,
    F = fun(_, DropInfo) ->
        case DropInfo of %% 删除自己的
            #ets_drop{player_id = RoleId, scene = SceneId, 
                      scene_pool_id = ScenePoolId, copy_id = CopyId} -> false;
            _ -> true
        end
    end,
    Dict2 = dict:filter(F, Dict),
    
    NowTime = utime:unixtime(),
    F1 = fun(_, DropInfo, Acc) ->
        case DropInfo of %% 筛选出自己的
            #ets_drop{player_id = RoleId, scene = SceneId, copy_id = CopyId,
                    scene_pool_id = ScenePoolId, expire_time = ExpireTime}
                when NowTime =< ExpireTime -> [DropInfo|Acc];
             _ -> Acc
        end
    end,
    case Handler of
        {M, F, A} ->
            case dict:fold(F1, [], Dict) of 
                [] -> ok;
                MyDrops -> spawn(fun() -> M:F(MyDrops, A) end)
            end;
        _ -> ok
    end,
    {noreply, Status#state{dict = Dict2}};

%% 获取场景掉落
do_handle_cast({get_drops_info, Node, RoleId, Scene, PoolId, CopyId, RoleX, RoleY}, #state{dict=Dict}=State) ->
    NowTime = utime:unixtime(),
    Fun = fun(_, DropInfo, {AreaDrops, NoAreaDrops}) ->
        case DropInfo of 
            #ets_drop{
                    id = DId, drop_thing_type = DTType, goods_id = GId,
                    num = Num, x = X, y = Y, drop_leff = DropLeff, drop_icon = DropIcon,
                    player_id=RoleId, scene=Scene, scene_pool_id = PoolId,
                    alloc = Alloc, copy_id=CopyId, expire_time = ExpireTime, guild_id = GuildId,
                    pick_time = PickTime, pick_player_id = PickPlayerId, pick_end_time = PickEndTime, camp_id = Camp,
                    mon_id = Mid, drop_x = DropX, drop_y = DropY, server_id = ServerId, team_id = TeamId, drop_way = DropWay
                    } when (Alloc == ?ALLOC_EQUAL orelse Alloc == ?ALLOC_HURT_EQUAL) andalso NowTime =< ExpireTime ->
                Bin = make_12018(DId, DTType, GId, Num, RoleId, ServerId, TeamId, Camp, GuildId, X, Y, DropLeff, DropIcon, PickTime, PickPlayerId, PickEndTime,
                    ExpireTime, DropWay, Mid, DropX, DropY, Alloc),
                case lib_scene_calc:is_area_scene_by_scene_id(Scene, RoleX, RoleY, X, Y) of
                    true -> {[Bin|AreaDrops], NoAreaDrops};
                    false -> {AreaDrops, [Bin|NoAreaDrops]}
                end;
            #ets_drop{
                    id = DId, drop_thing_type = DTType, goods_id = GId,
                    num = Num, x = X, y = Y, drop_leff = DropLeff, drop_icon = DropIcon,
                    scene = Scene, scene_pool_id = PoolId, player_id = RId,
                    alloc = Alloc, copy_id = CopyId, expire_time = ExpireTime, guild_id = GuildId,
                    pick_time = PickTime, pick_player_id = PickPlayerId, pick_end_time = PickEndTime, camp_id = Camp,
                    mon_id = Mid, drop_x = DropX, drop_y = DropY, server_id = ServerId, team_id = TeamId, drop_way = DropWay
                    } when Alloc /= ?ALLOC_EQUAL, Alloc /= ?ALLOC_HURT_EQUAL, NowTime =< ExpireTime ->
                RRId = if RoleId == RId -> RoleId; true -> RId end,
                Bin = make_12018(DId, DTType, GId, Num, RRId, ServerId, TeamId, Camp, GuildId, X, Y, DropLeff, DropIcon, PickTime, PickPlayerId, PickEndTime,
                    ExpireTime, DropWay, Mid, DropX, DropY, Alloc),
                case lib_scene_calc:is_area_scene_by_scene_id(Scene, RoleX, RoleY, X, Y) of
                    true -> {[Bin|AreaDrops], NoAreaDrops};
                    false -> {AreaDrops, [Bin|NoAreaDrops]}
                end;
            _ -> 
                {AreaDrops, NoAreaDrops}
        end
    end,
    {AreaDrops, NoAreaDrops} = dict:fold(Fun, {[], []}, Dict),
    if
        length(AreaDrops) >= 150 -> MyDrops = AreaDrops;
        true -> MyDrops = lists:sublist(AreaDrops ++ NoAreaDrops, 150)
    end,
    {ok, Bin} = pt_120:write(12018, [MyDrops]),
    send_drop_msg_to_role(Node, RoleId, Bin),
    {noreply, State};

%% 掉落拾取：本服和跨服
do_handle_cast({manual_drop_pickup, Node, DropId, PsArgs}, State) ->
    manual_drop_pickup(State, Node, DropId, PsArgs);

%% 掉落拾取：本服和跨服
do_handle_cast({drop_pickup, Node, DropId, PsArgs}, State) ->
    drop_pickup(State, Node, DropId, PsArgs);

%% 掉落拾取：本服和跨服
do_handle_cast({drop_list_pickup, Node, DropIdList, PsArgs, MonArgs, Alloc}, State) ->
    drop_list_pickup(State, Node, DropIdList, PsArgs, MonArgs, Alloc);

do_handle_cast(_Msg, State) ->
    {noreply, State}.

do_handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, Status) ->
    ?ERR("~p is terminate:~p", [?MODULE, _Reason]),
    {ok, Status}.

code_change(_OldVsn, Status, _Extra)->
    {ok, Status}.

%% ---------------------------------------------------------------------

make_12018(DId, DTType, GId, Num, RRId, ServerId, TeamId, Camp, GuildId, X, Y, DropEff, DropIcon, PickTime, PickPlayerId, PickEndTime,
        ExpireTime, DropWay, Mid, DropX, DropY, Alloc) ->
    BDropEff = pt:write_string(DropEff),
    BDropIcon = pt:write_string(DropIcon),
    <<DId:64, DTType:8, GId:32, Num:32, RRId:64, ServerId:16, TeamId:64, Camp:16, GuildId:64, X:16, Y:16, BDropEff/binary, BDropIcon/binary,
        PickTime:32, PickPlayerId:64, PickEndTime:64, ExpireTime:32, DropWay:8, Mid:32, DropX:16, DropY:16, Alloc:8>>.

%% 掉落拾取：本服和跨服
manual_drop_pickup(State, Node, DropId, #ps_args{role_id = RoleId} = PsArgs) ->
    #state{dict=Dict, role_map=RoleMap}=State,
    case lib_drop:check_drop_pickup(Dict, DropId, PsArgs) of 
        {fail, ErrorCode} ->
            {ErrorCodeInt, ErrorCodeArgs} = util:parse_error_code(ErrorCode),
            {ok, Bin} = pt_150:write(15053, [ErrorCodeInt, ErrorCodeArgs, 0, DropId]),
            send_drop_msg_to_role(Node, PsArgs#ps_args.role_id, Bin),
            {noreply, State};
        {ok, #ets_drop{pick_time = PickTime, pick_player_id = PickRoleId, pick_end_time = PickEndTime} = DropInfo} ->
            Now = utime:longunixtime(),
            % ?MYLOG("hjhdrop2", "DropId:~p Now:~p PickEndTime:~p ~n", [DropId, Now, PickEndTime]),
            #drop_role{drop_id = OldDropId, pick_end_time = OldPickEndTime} = DropRole = maps:get(RoleId, RoleMap, #drop_role{id = RoleId}),
            {CheckManualPick, ManualErrorCode} = lib_drop:check_manual_drop_pickup(Dict, DropId, PsArgs),
            if
                CheckManualPick == false ->
                    {ErrorCodeInt, ErrorCodeArgs} = util:parse_error_code(ManualErrorCode),
                    {ok, Bin} = pt_150:write(15053, [ErrorCodeInt, ErrorCodeArgs, 0, DropId]),
                    send_drop_msg_to_role(Node, PsArgs#ps_args.role_id, Bin),
                    {noreply, State};
                PickTime == 0 ->
                    do_drop_pickup(State, Node, DropId, PsArgs, DropInfo);
                % 正在拾取其他
                OldDropId > 0 andalso DropId =/= OldDropId andalso Now < OldPickEndTime -> 
                    case dict:find(OldDropId, Dict) of
                        {ok, #ets_drop{pick_player_id = RoleId}=OldDropInfo} ->
                            #ps_args{scene = Scene, pool_id = PoolId, copy_id = CopyId} = PsArgs,
                            OldDropInfo2 = OldDropInfo#ets_drop{pick_player_id = 0, pick_end_time = 0},
                            % 替换掉之前的掉落
                            NewDict = dict:store(OldDropId, OldDropInfo2, Dict),
                            {ok, BinData} = pt_120:write(12024, [DropId, 0, 0]),
                            lib_server_send:send_to_scene(Scene, PoolId, CopyId, BinData),
                            NewState = State#state{dict=NewDict, role_map=maps:remove(RoleId, RoleMap)},
                            manual_drop_pickup(NewState, Node, DropId, PsArgs);
                        _ ->
                            NewState = State#state{role_map=maps:remove(RoleId, RoleMap)},
                            manual_drop_pickup(NewState, Node, DropId, PsArgs)
                    end;
                % 时间不足
                RoleId == PickRoleId andalso Now < PickEndTime -> 
                    {ErrorCodeInt, ErrorCodeArgs} = util:parse_error_code(?ERRCODE(err150_pick_time_not_enough)),
                    {ok, Bin} = pt_150:write(15053, [ErrorCodeInt, ErrorCodeArgs, 0, DropId]),
                    send_drop_msg_to_role(Node, PsArgs#ps_args.role_id, Bin),
                    {noreply, State};
                % 拾取
                RoleId == PickRoleId ->
                    NewState = State#state{role_map = maps:remove(RoleId, RoleMap)},
                    do_drop_pickup(NewState, Node, DropId, PsArgs, DropInfo);
                % 其他玩家正在采集[有玩家采集中,保留100毫秒再次发协议]
                Now < PickEndTime+?DROP_PICK_SAVE_TIME ->
                    {ErrorCodeInt, ErrorCodeArgs} = util:parse_error_code(?ERRCODE(err150_other_picking)),
                    {ok, Bin} = pt_150:write(15053, [ErrorCodeInt, ErrorCodeArgs, 0, DropId]),
                    send_drop_msg_to_role(Node, PsArgs#ps_args.role_id, Bin),
                    {noreply, State};
                % 开始拾取
                true ->
                    #ps_args{scene = Scene, pool_id = PoolId, copy_id = CopyId} = PsArgs,
                    NewDropEndTime = Now+PickTime,
                    {ok, BinData} = pt_120:write(12024, [DropId, RoleId, NewDropEndTime]),
                    lib_server_send:send_to_scene(Scene, PoolId, CopyId, BinData),
                    {ErrorCodeInt, ErrorCodeArgs} = util:parse_error_code(?ERRCODE(err150_start_pick_drop)),
                    {ok, BinData2} = pt_150:write(15053, [ErrorCodeInt, ErrorCodeArgs, 1, DropId]),
                    send_drop_msg_to_role(Node, PsArgs#ps_args.role_id, BinData2),
                    NewDropInfo = DropInfo#ets_drop{pick_player_id = RoleId, pick_end_time = NewDropEndTime},
                    NewDict = dict:store(DropId, NewDropInfo, Dict),
                    NewDropRole = DropRole#drop_role{drop_id = DropId, pick_end_time = NewDropEndTime},
                    NewRoleMap = maps:put(RoleId, NewDropRole, RoleMap),
                    NewState = State#state{dict=NewDict, role_map=NewRoleMap},
                    {noreply, NewState}
            end
    end.

%% 掉落拾取：本服和跨服
drop_pickup(State, Node, DropId, PsArgs) ->
    #state{dict=Dict}=State,
    case lib_drop:check_drop_pickup(Dict, DropId, PsArgs) of 
        {fail, ErrorCode} ->
            {ErrorCodeInt, ErrorCodeArgs} = util:parse_error_code(ErrorCode),
            {ok, Bin} = pt_150:write(15053, [ErrorCodeInt, ErrorCodeArgs, 0, DropId]),
            send_drop_msg_to_role(Node, PsArgs#ps_args.role_id, Bin),
            {noreply, State};
        {ok, DropInfo} ->
            do_drop_pickup(State, Node, DropId, PsArgs, DropInfo)
    end.

do_drop_pickup(#state{dict=Dict}=State, Node, DropId, PsArgs, #ets_drop{mon_id = MonId, notice = Notice, goods_id = GoodsId, show_tips = ShowTips} = DropInfo) ->
    case lib_drop:check_drop_pickup_info(DropInfo, PsArgs) of 
        {fail, ErrorCode} ->
            {ErrorCodeInt, ErrorCodeArgs} = util:parse_error_code(ErrorCode),
            {ok, Bin} = pt_150:write(15053, [ErrorCodeInt, ErrorCodeArgs, 0, DropId]),
            send_drop_msg_to_role(Node, PsArgs#ps_args.role_id, Bin),
            {noreply, State};
        {ok, []} ->
            #ps_args{role_id = _RoleId, scene = Scene, pool_id = PoolId, copy_id = CopyId, name = _Name} = PsArgs,
            %% 发送给玩家自己
            {ErrorCodeInt, ErrorCodeArgs} = util:parse_error_code(?SUCCESS),
            {ok, Bin} = pt_150:write(15053, [ErrorCodeInt, ErrorCodeArgs, 0, DropId]),
            send_drop_msg_to_role(Node, PsArgs#ps_args.role_id, Bin),
            %% 广播掉落消失
            {ok, BinData} = pt_120:write(12019, [DropId]),
            lib_server_send:send_to_scene(Scene, PoolId, CopyId, BinData),
            NewDict = dict:erase(DropId, Dict),
            {noreply, State#state{dict=NewDict}};
        {ok, DropReward} ->
            #ps_args{role_id = RoleId, scene = Scene, pool_id = PoolId, copy_id = CopyId, name = Name} = PsArgs,
            DropArgs = [DropId, Scene, MonId, Notice, GoodsId, ShowTips],
            if 
                Node == none -> %% 本服发送
                    lib_drop:send_drop_reward(RoleId, DropArgs, DropReward, mon_drop);
                true ->  %% 跨服发送
                    mod_clusters_center:apply_cast(Node, lib_drop, send_drop_reward, [RoleId, DropArgs, DropReward, clusters_mon_drop])
            end,
            %% 发送给玩家自己
            {ErrorCodeInt, ErrorCodeArgs} = util:parse_error_code(?SUCCESS),
            {ok, Bin} = pt_150:write(15053, [ErrorCodeInt, ErrorCodeArgs, 0, DropId]),
            send_drop_msg_to_role(Node, PsArgs#ps_args.role_id, Bin),
            lib_territory_treasure:drop_thing(Scene, MonId, RoleId, Name, DropReward),
            %% 广播掉落消失
            {ok, BinData} = pt_120:write(12019, [DropId]),
            lib_server_send:send_to_scene(Scene, PoolId, CopyId, BinData),
            NewDict = dict:erase(DropId, Dict),
            {noreply, State#state{dict=NewDict}}
    end.

%% 掉落列表拾取
drop_list_pickup(State, Node, DropIdList, PsArgs, MonArgs, Alloc) ->
    auto_drop_list_pickup(State, Node, DropIdList, PsArgs, MonArgs, Alloc).

%% 掉落列表拾取(自动拾取:只告诉掉落包消息)
auto_drop_list_pickup(State, Node, DropIdList, PsArgs, MonArgs, Alloc) ->
    {NewState, DropArgsL, PickDropIdL} = do_auto_drop_list_pickup(DropIdList, State, [], [], Node, PsArgs),
    #ps_args{role_id = RoleId, scene = Scene, pool_id = PoolId, copy_id = CopyId} = PsArgs,
    {ok, BinData} = pt_120:write(12019, PickDropIdL),
    lib_server_send:send_to_scene(Scene, PoolId, CopyId, BinData),
    if 
        Node == none -> %% 本服发送
            lib_drop:send_drop_list_reward(RoleId, MonArgs, Alloc, DropArgsL, mon_drop);
        true ->  %% 跨服发送
            mod_clusters_center:apply_cast(Node, lib_drop, send_drop_list_reward, [RoleId, MonArgs, Alloc, DropArgsL, clusters_mon_drop])
    end,
    {noreply, NewState}.

do_auto_drop_list_pickup([], State, DropArgsL, PickDropIdL, _Node, _PsArgs) -> {State, DropArgsL, PickDropIdL};
do_auto_drop_list_pickup([DropId|T], State, DropArgsL, PickDropIdL, Node, PsArgs) ->
    #state{dict=Dict}=State,
    case lib_drop:check_auto_drop_pickup(Dict, DropId, PsArgs) of 
        {fail, _ErrorCode} ->
            do_auto_drop_list_pickup(T, State, DropArgsL, PickDropIdL, Node, PsArgs);
        {ok, #ets_drop{mon_id = MonId, notice = Notice, goods_id = GoodsId, show_tips = ShowTips} = DropInfo} ->
            case lib_drop:check_drop_pickup_info(DropInfo, PsArgs) of 
                {fail, _ErrorCode} ->
                    do_auto_drop_list_pickup(T, State, DropArgsL, PickDropIdL, Node, PsArgs);
                {ok, []} ->
                    NewDict = dict:erase(DropId, Dict),
                    do_auto_drop_list_pickup(T, State#state{dict=NewDict}, DropArgsL, [DropId|PickDropIdL], Node, PsArgs);
                {ok, DropReward} ->
                    #ps_args{role_id = _RoleId, scene = Scene, pool_id = _PoolId, copy_id = _CopyId, name = _Name} = PsArgs,
                    DropArgs = {DropId, Scene, MonId, Notice, GoodsId, DropReward, ShowTips},
                    NewDict = dict:erase(DropId, Dict),
                    do_auto_drop_list_pickup(T, State#state{dict=NewDict}, [DropArgs|DropArgsL], [DropId|PickDropIdL], Node, PsArgs)
            end
    end.

%% 过滤列表
filter_list([], L, _) ->
    L;
filter_list([{_Key, DropInfo} | H], L, NowTime) ->
    case is_record(DropInfo, ets_drop) of
        true ->
            if NowTime > DropInfo#ets_drop.expire_time ->
                    filter_list(H, [DropInfo|L], NowTime);
               true ->
                    filter_list(H, L, NowTime)
            end;
        false ->
            filter_list(H, L, NowTime)
    end.

%% 删除过期物品
delete_expire_drop([], Status) ->
    Status;
delete_expire_drop([DropInfo | H], Status) ->
    case dict:is_key(DropInfo#ets_drop.id, Status) of
        true ->
            Status2 = dict:erase(DropInfo#ets_drop.id, Status);
        false ->
            Status2 = Status
    end,
    delete_expire_drop(H, Status2).

%% 删除过期的玩家掉落信息
delete_drop_role(RoleMap) ->
    Now = utime:longunixtime(),
    % 超过一分钟清理
    F = fun(_K, #drop_role{pick_end_time = PickEndTime}) -> Now > PickEndTime+60000 end,
    maps:filter(F, RoleMap).

%% 发送掉落信息给玩家
send_drop_msg_to_role(Node, RoleId, Bin) ->
    if 
        Node == none ->
            lib_server_send:send_to_uid(RoleId, Bin);
        true ->
            lib_clusters_center:send_to_uid(Node, RoleId, Bin)
    end.
