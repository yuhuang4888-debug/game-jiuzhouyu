%%-----------------------------------------------------------------------------
%% @Module  :       mod_sea_treasure_local.erl
%% @Author  :       xlh
%% @Email   :
%% @Created :       2020-06-28
%% @Description:    璀璨之海（挖矿）本服数据管理进程
%%-----------------------------------------------------------------------------
-module(mod_sea_treasure_local).

-behaviour(gen_server).

-include("common.hrl").
-include("sea_treasure.hrl").
-include("def_id_create.hrl").
-include("predefine.hrl").
-include("errcode.hrl").
-include("def_module.hrl").
-include("def_fun.hrl").
-include("rec_assist.hrl").

%% API
-export([start_link/0]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
    terminate/2, code_change/3]).

-export([
        update_state/2              %% 更新本服数据
        ,init_after/6               %% 初始化
        ,midnight_do/0              %% 0点修复刷新机器人定时器
        ,four_clock/0               %% 4点 巡航奖励发放
        ,get_data_from_cluster/2    %% 接收跨服中心数据
        ,start_new_ship/3           %% 开启巡航
        ,rober_shipping/6           %% 掠夺/复仇/助战
        ,do_after_battle/3          %% 战场进程完成战斗回调
        ,do_after_robber_success/6  %% 跨服掠夺
        ,do_after_terminate/4       %% 跨服掠夺失败
        ,do_after_rob_back/4        %% 跨服复仇/助战返回
        ,delete_helper_pid/2        %% 助战成功清理正在助战玩家
        ,update_role_info/1         %% 玩家数据更新
        ,get_all_shipping_info/3    %% 界面信息
        ,get_all_log_info/1         %% 掠夺日志
        ,recieve_reward/5           %% 领取奖励
        ,create_robot_kf/1          %% 跨服创建机器人回调
        ,get_shipping_info/3        %% 获取巡航数据 完整
        ,get_enemy_info/1           %% 对战服务器相关
        ,launch_sea_treasure_assist/3   %% 公会协助 发起协助
        ,get_ship_status/4          %% 获取巡航数据 部分
        ,get_log_data_from_cluster/1    %% 同步本服所有被其他服玩家记录数据
        ,get_role_info_from_cluster/2   %% 更新本服日志/巡航数据
        ,server_open_day_change/1   %% 服务器信息更改
        ,send_clear_data_to_kf/3  %% 同步要清理的数据到跨服进程
        ,get_clear_data_from_cluster/1  %% 同步要清理的数据到本服
    ]).

-export([
        gm_end_ship/0               %% 结束本服所有巡航
        ,gm_clear_treasure_log/0    %% 清理本服所有巡航记录
        ,gm_clear_treasure_log/1    %% 清理玩家巡航记录
        ,gm_clear_ship_info/0       %% 修复巡航阶段数据，清理过期数据
        ,gm_create_robot/0          %% 创建机器人
        % ,time_test/3
        ,gm_repaire_log_data/0          %% 秘籍修复本服掠夺记录的AutoId（之前保存了其他服生成的AutoId,导致合服冲突）
        ,send_role_info_to_cluster/3
        ,do_update_log_map/3
        , gm_output_data/4          %% 输出数据
    ]).

%%=========================================================================
%% 接口函数
%%=========================================================================
update_state(Type, Data) ->
    gen_server:cast(?MODULE, {'update_state', Type, Data}).

init_after(ShopMod, SendBatList, UnSatisfyType, SendUnSatisfyList, SendServerInfo, BelogList) ->
    gen_server:cast(?MODULE, {'init_after', ShopMod, SendBatList, UnSatisfyType, SendUnSatisfyList, SendServerInfo, BelogList}).

midnight_do() ->
    gen_server:cast(?MODULE, {'midnight_do'}).

four_clock() ->
    gen_server:cast(?MODULE, {'four_clock'}).

get_data_from_cluster(ServerId, SendList) ->
    gen_server:cast(?MODULE, {'get_data_from_cluster', ServerId, SendList}).

get_log_data_from_cluster(List) ->
    gen_server:cast(?MODULE, {'get_log_data_from_cluster', List}).

get_clear_data_from_cluster(List) ->
    gen_server:cast(?MODULE, {'get_clear_data_from_cluster', List}).

get_role_info_from_cluster(FromServerId, List) ->
    gen_server:cast(?MODULE, {'get_role_info_from_cluster', FromServerId, List}).

start_new_ship(RoleId, ShippingType, Args) ->
    gen_server:cast(?MODULE, {'start_new_ship', RoleId, ShippingType, Args}).

rober_shipping(ShipSerId, ShipRoleId, AutoId, RoleId, BatType, Args) ->
    gen_server:cast(?MODULE, {'rober_shipping', ShipSerId, ShipRoleId, AutoId, RoleId, BatType, Args}).

do_after_battle(Arg, RoleId, BeHelperId) ->
    gen_server:cast(?MODULE, {'do_after_battle', Arg, RoleId, BeHelperId}).

do_after_robber_success(SerId, RoleId, EnemySerId, NewLog, ProtocolArg, Reward) ->
    gen_server:cast(?MODULE, {'do_after_robber_success', SerId, RoleId, EnemySerId, NewLog, ProtocolArg, Reward}).

do_after_terminate(SerId, AutoId, RoberId, RoberRName) ->
    gen_server:cast(?MODULE, {'do_after_terminate', SerId, AutoId, RoberId, RoberRName}).

do_after_rob_back(Arg, RoleId, BeHelperId, RoberInfo) ->
    gen_server:cast(?MODULE, {'do_after_rob_back', Arg, RoleId, BeHelperId, RoberInfo}).

delete_helper_pid(BeHelperId, HelperId) ->
    gen_server:cast(?MODULE, {'delete_helper_pid', BeHelperId, HelperId}).

update_role_info(Data) ->
    gen_server:cast(?MODULE, {'update_role_info', Data}).

%% 协议接口 主界面 18900
get_all_shipping_info(Args, ServerId, RoleId) ->
    gen_server:cast(?MODULE, {'get_all_shipping_info', Args, ServerId, RoleId}).

%% 记录 18901
get_all_log_info(RoleId) ->
    gen_server:cast(?MODULE, {'get_all_log_info', RoleId}).

recieve_reward(ServerId, RoleId, RoleLv, AutoId, RewardType) ->
    gen_server:cast(?MODULE, {'recieve_reward', ServerId, RoleId, RoleLv, AutoId, RewardType}).

create_robot_kf(Num) ->
    gen_server:cast(?MODULE, {'create_robot_kf', Num}).

get_shipping_info(AutoId, ServerId, RoleId) ->
    gen_server:cast(?MODULE, {'get_shipping_info', AutoId, ServerId, RoleId}).

get_enemy_info(RoleId) ->
    gen_server:cast(?MODULE, {'get_enemy_info', RoleId}).

launch_sea_treasure_assist(RoleId, Args, AutoId) ->
    gen_server:cast(?MODULE, {'launch_sea_treasure_assist', RoleId, Args, AutoId}).

get_ship_status(ServerId, RoleId, TreasureTimes, DayRewardTimes) ->
    gen_server:cast(?MODULE, {'get_ship_status', ServerId, RoleId, TreasureTimes, DayRewardTimes}).

%% 结束本服所有巡航
gm_end_ship() ->
    gen_server:cast(?MODULE, {'gm_end_ship'}).

%% 清理所有巡航记录
gm_clear_treasure_log() ->
    gen_server:cast(?MODULE, {'gm_clear_treasure_log'}).

%% 清理某玩家所有巡航记录
gm_clear_treasure_log(RoleId) ->
    gen_server:cast(?MODULE, {'gm_clear_treasure_log', RoleId}).

%% 清理过期数据
gm_clear_ship_info() ->
    gen_server:cast(?MODULE, {'gm_clear_ship_info'}).

%% 创建巡航机器人
gm_create_robot() ->
    gen_server:cast(?MODULE, {'gm_create_robot'}).

%% 先关闭璀璨之海掠夺/协助/复仇功能，2分钟后修复数据同步到跨服中心，然后清空璀璨之海协助列表
gm_repaire_log_data() ->
    lib_gm_stop:gm_close_sea_treasure_rob(1),
    spawn(fun() -> timer:sleep(120000), gen_server:cast(?MODULE, {'gm_repaire_log_data'}) end).

%% 输出数据
gm_output_data(DataType, AutoId, RoleId, ServerId) ->
    gen_server:cast(?MODULE, {'gm_output_data', DataType, AutoId, RoleId, ServerId}).

%% 开服天数改变
server_open_day_change(OpenTime) ->
    gen_server:cast(?MODULE, {'server_open_day_change', OpenTime}).
%%=========================================================================
%% 回调函数
%%=========================================================================

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

init([]) ->
    State = init(),
    {ok, State}.

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
            % ?MYLOG("xlh","Msg:~p, OldMod:~p, Mod:~p~n", [Msg, NewState#sea_treasure_local.shipping_map, State#sea_treasure_local.shipping_map]),
            {noreply, NewState};
        Res ->
            ?ERR("Error:~p~n", [[Msg, Res]]),
            {noreply, State}
    end.

handle_info(Info, State) ->
    case catch do_handle_info(Info, State) of
        {noreply, NewState} ->
            % ?MYLOG("xlh","Info:~p, OldMod:~p, Mod:~p~n", [Info, NewState#sea_treasure_local.shipping_map, State#sea_treasure_local.shipping_map]),
            {noreply, NewState};
        Res ->
            ?ERR("Error:~p~n", [[Info, Res]]),
            {noreply, State}
    end.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

init() ->
    Sql1 = io_lib:format(?sql_select_treasure_log, []),
    Sql2 = io_lib:format(?sql_select_treasure_shipping, []),
    Sql3 = io_lib:format(?sql_select_treasure_rback, []),
    LogList = db:get_all(Sql1),
    ShippingList = db:get_all(Sql2),
    ServerId = config:get_server_id(),
    Fun = fun(Val, {Type, Map, Map1}) ->
        case lib_sea_treasure:db_data_make_record(Type, Val) of
            #treasure_log{auto_id = AutoId, role_id = RoleId, rober_serid = RoberSerId, rober_id = RoberId} = R ->
                OldList = maps:get(RoleId, Map, []),
                NewList = [R|OldList],
                %NewList = lists:keystore(AutoId, #treasure_log.auto_id, OldList, R),
                OldASL = maps:get(RoberSerId, Map1, []),
                %NewASL = ?IF(RoberId =/= 0, lists:keystore(AutoId, 1, OldASL, {AutoId, RoleId, ServerId, RoberId}), OldASL),
                NewASL = ?IF(RoberId =/= 0, [{AutoId, RoleId, ServerId, RoberId}|OldASL], OldASL),
                NewMap1 = maps:put(RoberSerId, NewASL, Map1),
                {Type, maps:put(RoleId, NewList, Map), NewMap1};
            #shipping_info{auto_id = AutoId, ser_id = SerId} = R ->
                OldList = maps:get(SerId, Map, []),
                NewList = lists:keystore(AutoId, #shipping_info.auto_id, OldList, R),
                {Type, maps:put(SerId, NewList, Map), Map1};
            _ -> {Type, Map, Map1}
        end
    end,
    {_, LogMap, BeLogMap} = lists:foldl(Fun, {log, #{}, #{}}, lib_sea_treasure:change_list(LogList)),
    {_, ShippingMap, _} = lists:foldl(Fun, {ship, #{}, #{}}, ShippingList),
    case lib_sea_treasure:get_server_treasure_type() of
        {TreasureMod, IsInit} ->
            % Nowtime = utime:unixtime(),
            ServerNum = config:get_server_num(),
            RobotRef = erlang:send_after(1200 * 1000, self(), {'create_robot', ServerId, ServerNum, TreasureMod}), % 设为每20min创建一次
            % case lib_sea_treasure:calc_robot_refresh_time(Nowtime-120) of
            %     {true, NextRefreshT} ->
            %         RobotRef = util:send_after(undefined, max(NextRefreshT-Nowtime, 1)*1000, self(),
            %             {'create_robot', ServerId, ServerNum, TreasureMod});
            %     _ ->
            %         RobotRef = undefined
            % end,
            Wlv = util:get_world_lv();
        _ ->
            mod_sea_treasure_kf:local_init(ServerId, config:get_merge_server_ids()),
            TreasureMod = 0, IsInit = false, Wlv = 0, RobotRef = undefined
    end,

    RbackList = db:get_all(Sql3),
    Fun3 = fun([AutoId, RoleId, HpPer], {AccMap, AccL}) ->
        if
            HpPer == 100 -> %% 全部夺回数据没必要保存
                {AccMap, [AutoId|lists:delete(AutoId, AccL)]};
            true ->
                List = maps:get(AutoId, AccMap, []),
                NList = lists:keystore(RoleId, 1, List, {RoleId, HpPer}),
                {maps:put(AutoId, NList, AccMap), AccL}
        end
    end,
    {RbackMap, DeleteDbList} = lists:foldl(Fun3, {#{}, []}, RbackList),
    %% 删掉些数据，全部夺回后这个数据没用了
    lib_sea_treasure:usql_handle_delete(sea_treasure_rback, auto_id, DeleteDbList),

    NewShippingMap = do_repair_shipping_map(ServerId, ShippingMap),
    %% 15s后开启所有巡航中的船只结算定时器
    InitRef = util:send_after(undefined, 15*1000, self(), {'start_shipping_ref', ServerId}),
    #sea_treasure_local{
        treasure_mod = TreasureMod
        ,shipping_map = NewShippingMap
        ,log_map = LogMap
        ,is_init = IsInit
        ,init_ref = InitRef
        ,wlv = Wlv
        ,robot_ref = RobotRef
        ,rback_map = RbackMap
        ,belog_map = BeLogMap
    }.

%=========================================================
%% 成功连接跨服中心
%=========================================================
do_handle_cast({'init_after', ShopMod, SendBatList, UnSatisfyType, SendUnSatisfyList, SendServerInfo, BelogList}, State) ->
    #sea_treasure_local{shipping_map = ShippingMap, belog_map = BeLogMap} = State,
    KeyList = maps:keys(ShippingMap),
    ServerId = config:get_server_id(),
    Fun = fun(SerId, AccMap) ->
        case lists:member(SerId, SendBatList) of
            true -> AccMap;
            _ -> maps:remove(SerId, AccMap)
        end
    end,
    NewShippingMap = lists:foldl(Fun, ShippingMap, lists:delete(ServerId, KeyList)),
    Wlv = lib_sea_treasure:calc_wlv(SendBatList, SendServerInfo),
    NewState = State#sea_treasure_local{
        treasure_mod = ShopMod
        ,battle_list = SendBatList
        ,unsatisfy_mod = UnSatisfyType
        ,unsatisfy_list = SendUnSatisfyList
        ,server_info = SendServerInfo
        ,shipping_map = NewShippingMap
        ,is_init = true
        ,wlv = Wlv
        ,need_up_role = ulists:removal_duplicate([RId ||{_, _, _, RId} <- BelogList])
        ,belog_list = BelogList
    },
    %% 连接跨服中心成功，开始上传本地数据
    send_data_to_cluster(ShippingMap, BeLogMap, ServerId, SendBatList),
    {noreply, NewState};

%=========================================================
%% 服务器开服天数/世界等级改变
%=========================================================
do_handle_cast({'server_open_day_change', _OpenTime}, State) ->
    NewState = case lib_sea_treasure:get_server_treasure_type() of
        {_, _} ->  %% 本服模式重新加载数据
            init();
        _ ->
            State
    end,
    {noreply, NewState};

%=========================================================
%% state更新
%=========================================================
do_handle_cast({'update_state', battle_list, Data}, State) -> %% 对战列表/对战预告更新
    NewState = State#sea_treasure_local{battle_list = Data},
    {noreply, NewState};
do_handle_cast({'update_state', unsatisfy_list, Data}, State) -> %% 对战列表/对战预告更新
    NewState = State#sea_treasure_local{unsatisfy_list = Data},
    {noreply, NewState};
do_handle_cast({'update_state', af_clear_state, Data}, State) ->
    [NewLogMap, NewRBackMap, NewBelogMap] = Data,
    NewState = State#sea_treasure_local{log_map = NewLogMap, rback_map = NewRBackMap, belog_map = NewBelogMap},
    {noreply, NewState};
do_handle_cast({'update_state', belog_list, Data}, State) ->
    [NewBelogList] = Data,
    NewState = State#sea_treasure_local{belog_list = NewBelogList},
    {noreply, NewState};

%=========================================================
%% 4点 未领取奖励发放 + 数据清理
%=========================================================
do_handle_cast({'four_clock'}, State) ->
    #sea_treasure_local{
        shipping_map = ShippingMap
        , log_map = LogMap
        , rback_map = RBackMap
        , belog_map = BelogMap
    } = State,
    ServerId = config:get_server_id(),
    ShippingList = maps:get(ServerId, ShippingMap, []),
    Title = utext:get(1890001),
    Content = utext:get(1890002),
    Nowtime = utime:unixtime(),
    Fun = fun
        (#shipping_info{has_recieve = HasRecv, end_time = EndTime, role_id = RoleId} = Ship, {Acc, Acc1})
        when RoleId =/= 0 andalso HasRecv == ?ACHIEVE_SHIPPING_REWARD
        orelse (HasRecv == ?UNACHIEVE_SHIPPING_REWARD andalso EndTime < Nowtime) ->
            #shipping_info{auto_id = AutoId, id = ShippingType, rob_times = RobTimes, role_lv = RoleLv} = Ship,
            #base_sea_treasure_reward{
                reward = Reward, rob_reward = RobReward, exp_ratio = ExpRtio
            } = data_sea_treasure:get_reward_info(ShippingType),
            if
                RobTimes =:= ?CANT_ROB -> %% 被掠夺过
                    GetReward = lib_sea_treasure:calc_get_reward(Reward, RobReward);
                true ->
                    GetReward = Reward
            end,
            ExpReward = [{5, 0, erlang:round(math:pow(1.5, (RoleLv - 60)/120)*174679200*ExpRtio)}],
            pp_sea_treasure:send_error(RoleId, [AutoId], 18919),
            lib_mail_api:send_sys_mail([RoleId], Title, Content, GetReward++ExpReward),
            {Acc, [AutoId|Acc1]};
        (Ship, {Acc, Acc1}) -> {[Ship|Acc], Acc1}
    end,
    {NewShipList, AutoIdList} = lists:foldl(Fun, {[], []}, ShippingList),
    TemMap = maps:put(ServerId, NewShipList, ShippingMap),
    lib_sea_treasure:usql_handle_delete(sea_treasure_shipping, auto_id, AutoIdList),
    F1 = fun
        (Key, List) when Key == ServerId ->
            List;
        (_Key, List) ->
            F2 = fun
                (#shipping_info{end_time = EndTime} = Ship, Acc) ->
                    if
                        Nowtime >= EndTime ->
                            Acc;
                        true ->
                            [Ship|Acc]
                    end;
                (_, Acc) -> Acc
            end,
            lists:foldl(F2, [], List)
    end,
    NewMap = maps:map(F1, TemMap),
    NewState = State#sea_treasure_local{
        shipping_map = NewMap
    },
    %% 开启进程进行本地进程数据清理
    lib_sea_treasure:clear_data(state, [LogMap, RBackMap, BelogMap]),
    {noreply, NewState};

%========================================================
%% 0点矫正机器人刷新计时器
%========================================================
do_handle_cast({'midnight_do'}, State) ->
    % #sea_treasure_local{
    %     robot_ref = OldRef,
    %     treasure_mod = TreasureMod
    % } = State,
    % Nowtime = utime:unixtime(),
    % ServerId = config:get_server_id(),
    % ServerNum = config:get_server_num(),
    % case lib_sea_treasure:calc_robot_refresh_time(Nowtime+61) of
    %     {true, NextRefreshT} ->
    %         RobotRef = util:send_after(OldRef, max(NextRefreshT-Nowtime, 1)*1000, self(),
    %             {'create_robot', ServerId, ServerNum, TreasureMod});
    %     _ ->
    %         RobotRef = undefined
    % end,
    {noreply, State};

%========================================================
%% 同步巡航数据
%========================================================
do_handle_cast({'get_data_from_cluster', ServerId, SendList}, State) ->
    #sea_treasure_local{
        shipping_map = ShippingMap
    } = State,
    NewMap = lib_sea_treasure:calc_new_shipping_map(ServerId, ShippingMap, SendList),
    NewState = State#sea_treasure_local{
        shipping_map = NewMap
    },
    RealSendList = lib_sea_treasure:construct_list_data_to_client(SendList),
    {ok, Bin} = pt_189:write(18911, [RealSendList]),
    lib_sea_treasure:send_msg_to_all(Bin),
    SerId = config:get_server_id(),
    if
        SerId == ServerId ->
            lib_sea_treasure:save_more_ship_to_db(SendList);
        true ->
            skip
    end,
    {noreply, NewState};

%========================================================
%% 记录需要更新巡航日志数据的玩家
%========================================================
do_handle_cast({'get_log_data_from_cluster', List}, State) ->
    #sea_treasure_local{
        belog_list = BelogList,
        need_up_role = NeedUpRoleL
    } = State,
    %% ！！！一定要避免多次遍历belog_list(特别大)
    %% 先分离开两种格式的数据
    SplitF = fun
        ({_, _, _, _} = Data, {FDataL1, FDataL2}) -> {[Data | FDataL1], FDataL2};
        (AutoId, {FDataL1, FDataL2}) when is_integer(AutoId) -> {FDataL1, [AutoId | FDataL2]};
        (_, {FDataL1, FDataL2}) -> {FDataL1, FDataL2}
    end,
    %% DataL1 : [{AutoId, Rid, BeLogSerId, RoberId} | ...]，要添加的数据
    %% DataL2 : [AutoId, ....]，要删除的数据
    {DataL1, DataL2} = lists:foldl(SplitF, {[], []}, List),

    %% =============== 先删除(处理DataL2)再添加(处理DataL1) ===============
    if
        DataL2 =/= [] -> %% 有要删除的记录才遍历处理
            DelF = fun
                ({AutoId, _, _, RoberId} = Belog, {FBelogList, FNeedUpRoleL}) ->
                    case lists:member(AutoId, DataL2) of
                        true -> %% 不添加到新列表里
                            {FBelogList, FNeedUpRoleL -- [RoberId]};
                        _ ->
                            {[Belog | FBelogList], FNeedUpRoleL}
                    end;
                (_, {FBelogList, FNeedUpRoleL}) -> {FBelogList, FNeedUpRoleL}
            end,
            {NewBelogList, NewNeedUpRoleL} = lists:foldl(DelF, {[], NeedUpRoleL}, BelogList);
        true ->
            NewBelogList = BelogList,
            NewNeedUpRoleL = NeedUpRoleL
    end,

    AddF = fun
        ({_, _, _, AddRoberId} = AddBelog, {AddFBelogList, AddFNeedUpRoleL}) ->
            case lists:member(AddRoberId, AddFNeedUpRoleL) of
                true ->
                    {[AddBelog | AddFBelogList], AddFNeedUpRoleL};
                _ ->
                    {[AddBelog | AddFBelogList], [AddRoberId | AddFNeedUpRoleL]}
            end;
        (_, {AddFBelogList, AddFNeedUpRoleL}) -> {AddFBelogList, AddFNeedUpRoleL}
    end,
    {LastBelogList, LastNeedUpRoleL} = lists:foldl(AddF, {NewBelogList, NewNeedUpRoleL}, DataL1),
    NewState = State#sea_treasure_local{
        belog_list = LastBelogList, need_up_role = LastNeedUpRoleL
    },
    {noreply, NewState};

%========================================================
%% 同步清理belog_list
%========================================================
do_handle_cast({'get_clear_data_from_cluster', List}, State) ->
    #sea_treasure_local{
        belog_list = BelogList
    } = State,
    lib_sea_treasure:clear_data(belog_list, [BelogList, List]),
    {noreply, State};

%========================================================
%% 玩家数据更新
%========================================================
do_handle_cast({'get_role_info_from_cluster', FromServerId, List}, State) ->
    #sea_treasure_local{
        log_map = LogMap, belog_map = BeLogMap
    } = State,
    BelogList = maps:get(FromServerId, BeLogMap, []),
    NewLogMap = do_update_log_map(LogMap, BelogList, List),
    NewState = State#sea_treasure_local{
        log_map = NewLogMap
    },
    {noreply, NewState};

%========================================================
%% 巡航开启
%========================================================
do_handle_cast({'start_new_ship', RoleId, ShippingType, Args}, State) ->
    #sea_treasure_local{
        shipping_map = ShippingMap
        ,battle_list = EnemyList
        ,wlv = Wlv, treasure_mod = TreasureMod
    } = State,
    [ServerId, ServerNum, GuildId, GuildName, RoleId, RoleName, RoleLv, Power, Career, Sex, Turn, Pic, PicVer] = Args,
    OldList = maps:get(ServerId, ShippingMap, []),
    List = [{role_do_ship, RoleId, OldList}],
    case lib_sea_treasure:check(List) of
        true ->
            AutoId = mod_id_create:get_new_id(?SHIPPING_ID_CREATE),
            Nowtime = utime:unixtime(),
            #base_sea_treasure_reward{need_time = NeedTime} = data_sea_treasure:get_reward_info(ShippingType),
            EndTime = Nowtime + NeedTime,
            EndRef = util:send_after(undefined, NeedTime*1000, self(), {'time_to_get_reward', ServerId, AutoId}),
            NewArg = [ShippingType, AutoId, ServerId, ServerNum, GuildId, GuildName, RoleId, RoleName, RoleLv,
                Power, Career, Sex, Turn, Pic, PicVer, EndTime, EndRef, Wlv],
            case lib_sea_treasure:make_record(shipping_info, NewArg) of
                ShipInfo when is_record(ShipInfo, shipping_info) ->
                    lib_sea_treasure:save_ship_to_db(ShipInfo),
                    NewShippingList = lists:keystore(AutoId, #shipping_info.auto_id, OldList, ShipInfo),
                    NewShippingMap = maps:put(ServerId, NewShippingList, ShippingMap),

                    SendList = lib_sea_treasure:construct_list_data_to_client([ShipInfo]),
                    {ok, Bin} = pt_189:write(18911, [SendList]),
                    lib_sea_treasure:send_msg_to_all(Bin),
                    % ?PRINT("======== AutoId:~p~n",[AutoId]),
                    %%处理计数器
                    lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_sea_treasure, do_handle_counter_start_ship, []),
                    %% 日志
                    lib_log_api:log_sea_treasure(AutoId, ShippingType, ServerId, RoleId, RoleName, 0, 0, 0, <<"">>, []),
                    Code = ?SUCCESS,
                    % ?PRINT("==================== ~p~n",[EnemyList]),
                    %%自增id管理
                    db:execute(io_lib:format(?sql_auto_id_replace, [ServerId, AutoId])),
                    %% 同步数据到对手服
                    SendShip = ShipInfo#shipping_info{end_ref = undefined, pic = <<"">>, pic_ver = 0},
                    TreasureMod =/= ?one_server_mod
                        andalso mod_sea_treasure_kf:get_data_from_local(ServerId, [SendShip], EnemyList);
                _ ->
                    util:cancel_timer(EndRef),
                    Code = ?FAIL,
                    NewShippingMap = ShippingMap
            end,
            NewState = State#sea_treasure_local{shipping_map = NewShippingMap},
            pp_sea_treasure:send_error(RoleId, [ShippingType, Code], 18903);
        {false, Code} ->
            NewState = State,
            pp_sea_treasure:send_error(RoleId, [ShippingType, Code], 18903)
    end,
    {noreply, NewState};

%========================================================
%% 战斗返回
%========================================================
do_handle_cast({'do_after_battle', Args, RoleId, BeHelperId}, State) ->
    #sea_treasure_local{
        log_map = LogMap, belog_map = BeLogMap
        ,shipping_map = ShippingMap
        ,battle_field = FieldPidMap
        ,rback_map = RbackMap
    } = State,
    [Res, BGoldNum, BatType, ShippingType, AutoId, _RHpPer, HpPer, RoberInfo, RoberGuild, Enemy, EnemyGuild] = Args,
    Nowtime = utime:unixtime(),
    SerId = config:get_server_id(),
    case BatType of
        ?BATTLE_TYPE_ROBER ->  %% 本服掠夺
            #role_info{
                ser_num = RoberSerNum, role_name = RoberRName, power = RoberPower
            } = RoberInfo,
            #fake_info{
                ser_num = EnemySerNum, role_id = EnemyId, role_name = EnemyName, power = EnemyPower
            } = Enemy,
            {EnemyGuildId, EnemyGuildName} = EnemyGuild,
            {RoberGuildId, RoberGuildName} = RoberGuild,
            if
                Res == 1 ->
                    RoberReward = lib_sea_treasure:get_rober_reward(ShippingType),
                    %% 掠夺记录处理
                    NewRoberLog = lib_sea_treasure:make_record(treasure_log, [
                        ShippingType, RoleId, AutoId, 0, SerId, EnemySerNum, EnemyGuildId,
                        EnemyGuildName, EnemyId, EnemyName, EnemyPower, RoberReward, 0, [], [], 0, Nowtime
                    ]),
                    if
                        EnemyId == 0 -> %% 机器人
                            %% 保存掠夺记录
                            lib_sea_treasure:save_more_log_to_db([NewRoberLog]),
                            SaveLogL = [{RoleId, NewRoberLog}];
                        true ->
                            BeRobLog = lib_sea_treasure:make_record(treasure_log, [
                                ShippingType, EnemyId, AutoId, 1, SerId, RoberSerNum, RoberGuildId,
                                RoberGuildName, RoleId, RoberRName, RoberPower, RoberReward, 0, [], [], 0, Nowtime
                            ]),
                            %% 保存掠夺记录
                            lib_sea_treasure:save_more_log_to_db([NewRoberLog, BeRobLog]),
                            SaveLogL = [{RoleId, NewRoberLog},{EnemyId, BeRobLog}],
                            %% 更新玩家掠夺记录
                            SendBeRobList = lib_sea_treasure:construct_list_data_to_client([BeRobLog]),
                            {ok, BeRobBin} = pt_189:write(18910, [SendBeRobList]),
                            lib_server_send:send_to_uid(EnemyId, BeRobBin)
                    end,
                    %% 更新巡航记录中的船只数据
                    ShippingList = maps:get(SerId, ShippingMap, []),
                    case lists:keyfind(AutoId, #shipping_info.auto_id, ShippingList) of
                        #shipping_info{} = OldShip ->
                            %% 更新为可被掠夺状态
                            NewShip = OldShip#shipping_info{rob_times = ?CANT_ROB},
                            NewShippingMap = lib_sea_treasure:save_to_map([{SerId, NewShip}], ShippingMap),

                            SendList = lib_sea_treasure:construct_list_data_to_client([NewShip]),
                            {ok, Bin1} = pt_189:write(18911, [SendList]),
                            lib_sea_treasure:send_msg_to_all(Bin1),

                            Sql = io_lib:format(?sql_update_shipping_role_robtimes, [?CAN_ROB, AutoId]),
                            db:execute(Sql);
                        _ ->
                            NewShippingMap = ShippingMap
                    end,

                    %% 保存记录
                    NLogMap = lib_sea_treasure:add_to_map(SaveLogL, LogMap),
                    %% 处理多余记录
                    {NewLogMap, NewRbackMap, DeleteAidList} = handle_log_map(NLogMap, RbackMap, SaveLogL, []),
                    DeleteAidList =/= [] andalso mod_sea_treasure_kf:get_log_data_from_local(DeleteAidList),
                    case lists:keyfind(SerId, 1, DeleteAidList) of
                        {_, DAutoIdL} ->
                            MapList = maps:get(SerId, BeLogMap, []),
                            NewMapList = [Turple || {TemAid, _, _, _} = Turple <- MapList, lists:member(TemAid, DAutoIdL) == false],
                            NewBeLogMap = maps:put(SerId, NewMapList, BeLogMap);
                        _ -> NewBeLogMap = BeLogMap
                    end,
                    %% 发送掠夺奖励
                    lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_sea_treasure, sea_treasure_reward, [sea_rob_reward, RoberReward]),
                    %% 更新玩家掠夺记录
                    SendRoberList = lib_sea_treasure:construct_list_data_to_client([NewRoberLog]),
                    {ok, RoberBin} = pt_189:write(18910, [SendRoberList]),
                    lib_server_send:send_to_uid(RoleId, RoberBin);
                true -> %% 掠夺失败
                    % %% 更新巡航记录中的船只数据 统一在战场进程结束处理
                    RoberReward = [], NewRbackMap = RbackMap, NewShippingMap = ShippingMap,
                    NewLogMap = LogMap, NewBeLogMap = BeLogMap
            end,
            lib_log_api:log_sea_treasure_rob(SerId, EnemyId, EnemyName, AutoId, ShippingType, SerId,
                RoleId, RoberRName, Res, RoberReward),
            %% 通知掠夺者掠夺结果
            ProtocolArg07 = lib_sea_treasure:construct_data_for_18907(Res, BatType, ShippingType, AutoId,
                RoberInfo, Enemy, BeHelperId, RoberReward),

            {ok, Bin} = pt_189:write(18907, ProtocolArg07),
            lib_server_send:send_to_uid(RoleId, Bin);
        _ ->%% 协助复仇
            LogList = maps:get(BeHelperId, LogMap, []),
            #role_info{
                ser_num = RoberSerNum, role_name = RoberRName, pic = Pic, pic_ver = PicVer
            } = RoberInfo,
            #fake_info{
                role_id = EnemyId, role_name = EnemyName, ser_num = EnemySerNum
            } = Enemy,
            case lists:keyfind(AutoId, #treasure_log.auto_id, LogList) of
                #treasure_log{
                    reward = RobReward, rober_hp = BeforeHpPer, back_times = OldRbackTimes,
                    back_reward = OldReward, recieve_reward = OldRecvReward
                } = OldLog ->
                    Log = OldLog#treasure_log{back_times = OldRbackTimes+1},
                    GetReward = lib_sea_treasure:calc_get_reward(RobReward, OldReward),
                    if
                        Res == 1 andalso GetReward =/= [] -> %% 胜利夺回剩下所有奖励
                            {Reward, NewHpPer, HelperReward, NewBGoldNum} =
                                lib_sea_treasure:calc_back_reward_by_hp(100, BeforeHpPer, RobReward, BGoldNum),
                            %% 清理这条协助的所有玩家，关闭对应战场进程
                            PidList = maps:get(BeHelperId, FieldPidMap, []),
                            lib_sea_treasure_battle:stop_all(lists:keydelete(RoleId, 1, PidList)),
                            NewBackReward = RobReward,
                            %% 保存记录发送奖励
                            ProtocolArg = [RoleId, RoberRName, Pic, PicVer, ShippingType, AutoId, Reward],
                            NewLog = do_after_rob_back_core(RoleId, BeHelperId, Log, NewHpPer, RobReward,
                                ProtocolArg, HelperReward, BGoldNum, NewBGoldNum, OldRecvReward, Reward);
                        true -> %% 小败
                            DeleteHpPer = 100 - HpPer,
                            {Reward, NewHpPer, HelperReward, NewBGoldNum} =
                                lib_sea_treasure:calc_back_reward_by_hp(DeleteHpPer, BeforeHpPer, RobReward, BGoldNum),
                            case Reward =/= [] of
                                true ->
                                    NewBackReward = ulists:object_list_plus([Reward, OldReward]),
                                    ProtocolArg = [RoleId, RoberRName, Pic, PicVer, ShippingType, AutoId, Reward],
                                    NewLog = do_after_rob_back_core(RoleId, BeHelperId, Log, NewHpPer, NewBackReward,
                                        ProtocolArg, HelperReward, BGoldNum, NewBGoldNum, OldRecvReward, Reward);
                                _ ->
                                    NewLog = Log#treasure_log{rback_status = ?RBACK_PEACE}, NewBackReward = OldReward
                            end
                    end,
                    NewRecvReward = NewLog#treasure_log.recieve_reward,
                    %% 更新数据库
                    Sql1 = io_lib:format(?sql_update_treasure_log, [NewHpPer, util:term_to_bitstring(Reward),
                        util:term_to_bitstring(NewBackReward), OldRbackTimes+1, AutoId]),
                    db:execute(Sql1),
                    NewLogMap = lib_sea_treasure:save_to_map([{BeHelperId, NewLog}], LogMap);

                _ ->
                    ?ERR("do_after_battle  log not exists AutoId:~p~n",[AutoId]),
                    Reward = [], NewLogMap = LogMap, NewRecvReward = [], NewHpPer = 0, HelperReward = []
            end,
            NewShippingMap = ShippingMap, NewBeLogMap = BeLogMap,
            lib_log_api:log_sea_treasure_rback(SerId, BeHelperId, RoleId, RoberRName, AutoId,
                ShippingType, SerId, EnemyId, EnemyName, Res, Reward, NewRecvReward),
            if
                Reward =/= [] ->
                    if
                        NewHpPer == 100 -> %% 全部夺回，数据清掉
                            db:execute(io_lib:format(?sql_delete_treasure_rback, [AutoId])),
                            NewRbackMap = maps:remove(AutoId, RbackMap);
                        true ->
                            RbackList = maps:get(AutoId, RbackMap, []),
                            NewRbackL = lists:keystore(RoleId, 1, RbackList, {RoleId, NewHpPer}),
                            db:execute(io_lib:format(?sql_insert_treasure_rback, [AutoId, RoleId, NewHpPer])),
                            NewRbackMap = maps:put(AutoId, NewRbackL, RbackMap)
                    end;
                true ->
                    NewRbackMap = RbackMap
            end,
            if
                RoleId =/= BeHelperId ->
                    %% 协助结果返回
                    lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_guild_assist,
                        rback_resoult, [AutoId, Res, Reward, [EnemySerNum, EnemyName]]);
                true -> %% 自己协助自己/复仇，无论有没有发起协助都执行一遍删除协助操作（自己协助自己的时候客户端没有发协助协议）
                    %% 协助结果返回
                    mod_guild_assist:rback_resoult_after_battle(RoleId, AutoId, Res, Reward, [RoberSerNum, RoberRName])
            end,

            %% 通知掠夺者掠夺结果
            ProtocolArg07 = lib_sea_treasure:construct_data_for_18907(Res, BatType, ShippingType, AutoId,
                RoberInfo, Enemy, BeHelperId, HelperReward),
            {ok, Bin} = pt_189:write(18907, ProtocolArg07),
            lib_server_send:send_to_uid(RoleId, Bin)
    end,
    NewState = State#sea_treasure_local{
        log_map = NewLogMap, rback_map = NewRbackMap, shipping_map = NewShippingMap, belog_map = NewBeLogMap
    },
    {noreply, NewState};

%========================================================
%% 跨服掠夺成功
%========================================================
do_handle_cast({'do_after_robber_success', SerId, RoleId, EnemySerId, Log, ProtocolArg, Reward}, State) ->
    #sea_treasure_local{
        log_map = LogMap, shipping_map = ShippingMap,
        rback_map = RbackMap, belog_map = BeLogMap
    } = State,
    if
        RoleId == 0 -> %% 机器人
            NewRbackMap = RbackMap, NewLogMap = LogMap, NewShippingMap = ShippingMap,
            NewProtocolArg = ProtocolArg, NewBeLogMap = BeLogMap;
        true ->
            #treasure_log{auto_id = SAutoId, rober_id = RoberId} = Log,
            ShippingList = maps:get(SerId, ShippingMap, []),
            case lists:keyfind(SAutoId, #shipping_info.auto_id, ShippingList) of
                #shipping_info{} = OldShip ->
                    % ?PRINT("rob_times ~p~n",[OldShip#shipping_info.rob_times]),
                    %% 更新为被掠夺状态
                    NewShip = OldShip#shipping_info{rob_times = ?CANT_ROB},
                    NewShippingMap = lib_sea_treasure:save_to_map([{SerId, NewShip}], ShippingMap),
                    Sql = io_lib:format(?sql_update_shipping_role_robtimes, [?CANT_ROB, SAutoId]),
                    db:execute(Sql);
                _ ->
                    NewShippingMap = ShippingMap
            end,
            %% 保存掠夺记录
            NAutoId = lib_sea_treasure:get_auto_id(SerId, SAutoId), %% 跨服的话重新生成auto_id
            NewLog = Log#treasure_log{auto_id = NAutoId},
            if
                NAutoId == SAutoId -> NewProtocolArg = ProtocolArg;
                true ->
                    [R, BatT, ST, _, RI, Emy, BId, Re] = ProtocolArg,
                    NewProtocolArg = [R, BatT, ST, NAutoId, RI, Emy, BId, Re]
            end,
            lib_sea_treasure:save_more_log_to_db([NewLog]),
            NLogMap = lib_sea_treasure:add_to_map([{RoleId, NewLog}], LogMap),
            OldASL = maps:get(NewLog#treasure_log.rober_serid, BeLogMap, []),
            NewASL = ?IF(RoberId =/= 0, [{NAutoId, RoleId, SerId, RoberId}|OldASL], OldASL),
            NewBeLogMap = maps:put(NewLog#treasure_log.rober_serid, NewASL, BeLogMap),
            {NewLogMap, NewRbackMap, DeleteAuidList} = handle_log_map(NLogMap, RbackMap, [{RoleId, NewLog}], []),
            case lists:keyfind(EnemySerId, 1, DeleteAuidList) of
                {_, AuidL} ->
                    NewAuidL = [{NAutoId, RoleId, SerId, RoberId}|AuidL];
                _ -> NewAuidL = [{NAutoId, RoleId, SerId, RoberId}]
            end,
            NewDeleteAuidList = lists:keystore(EnemySerId, 1, DeleteAuidList, {EnemySerId, NewAuidL}),
            mod_sea_treasure_kf:get_log_data_from_local(NewDeleteAuidList),
            %% 更新玩家掠夺记录
            SendList = lib_sea_treasure:construct_list_data_to_client([NewLog]),
            {ok, Bin} = pt_189:write(18910, [SendList]),
            lib_server_send:send_to_uid(RoleId, Bin),
            %% 发送掠夺奖励
            Reward =/= [] andalso lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE,
                lib_sea_treasure, sea_treasure_reward, [sea_rob_reward, Reward])
    end,
    %% 通知掠夺者掠夺结果
    if
        NewProtocolArg =/= [] ->
            [Res, _, ShippingType, AutoId, RoberInfo, Enemy, _, _ProReward] = NewProtocolArg,
            [{_, _, _, _, _, RoberRName, _, _}] = RoberInfo,
            [{_, _, _, _, _, _, _, EnemyId, EnemyName, _, _}] = Enemy,
            lib_log_api:log_sea_treasure_rob(EnemySerId, EnemyId, EnemyName, AutoId, ShippingType, SerId,
                RoleId, RoberRName, Res, _ProReward),
            {ok, Bin1} = pt_189:write(18907, NewProtocolArg),
            lib_server_send:send_to_uid(RoleId, Bin1);
        true ->
            skip
    end,
    NewState = State#sea_treasure_local{log_map = NewLogMap, shipping_map = NewShippingMap, rback_map = NewRbackMap, belog_map = NewBeLogMap},
    {noreply, NewState};

%========================================================
%% 掠夺失败处理/战场进程关闭，设置为可被掠夺状态
%========================================================
do_handle_cast({'do_after_terminate', SerId, AutoId,  RoberId, RoberRName}, State) ->
    #sea_treasure_local{
        shipping_map = ShippingMap, treasure_mod = TreasureMod, battle_list = SendBatList
    } = State,
    %% 更新巡航记录中的船只数据
    ShippingList = maps:get(SerId, ShippingMap, []),
    case lists:keyfind(AutoId, #shipping_info.auto_id, ShippingList) of
        #shipping_info{id = ShippingType, ser_id = EnemySerId,
        role_id = EnemyId, role_name = EnemyName} = OldShip ->
            %% 更新为可被掠夺状态
            NewShip = OldShip#shipping_info{rob_times = ?CAN_ROB},
            NewShippingMap = lib_sea_treasure:save_to_map([{SerId, NewShip}], ShippingMap),

            SendList = lib_sea_treasure:construct_list_data_to_client([NewShip]),
            {ok, Bin1} = pt_189:write(18911, [SendList]),
            lib_sea_treasure:send_msg_to_all(Bin1),

            SendShipL = [{AutoId, {#shipping_info.rob_times, ?CAN_ROB}}],
            TreasureMod =/= ?one_server_mod
                andalso mod_sea_treasure_kf:get_data_from_local(SerId, SendShipL, SendBatList),

            Sql = io_lib:format(?sql_update_shipping_role_robtimes, [?CAN_ROB, AutoId]),
            lib_log_api:log_sea_treasure_rob(EnemySerId, EnemyId, EnemyName, AutoId, ShippingType, SerId,
                RoberId, RoberRName, 0, []),
            db:execute(Sql);
            % %% 更新各个服的数据(跨服处理了)
            % mod_sea_treasure_kf:get_data_from_local(SerId, [NewShip], SendBatList),
        _ -> %% 巡航已结束不处理/服务器id出错
            % ?PRINT("============= SerId:~p, ServerId:~p~n",[SerId, config:get_server_id()]),
            NewShippingMap = ShippingMap
    end,
    NewState = State#sea_treasure_local{shipping_map = NewShippingMap},
    {noreply, NewState};

%========================================================
%% 跨服协助
%========================================================
do_handle_cast({'do_after_rob_back', Arg, RoleId, BeHelperId, RoberInfo}, State) ->
    #sea_treasure_local{
        log_map = LogMap
    } = State,
    NewLogMap = do_after_rob_back_helper(Arg, LogMap, RoleId, BeHelperId, RoberInfo),
    NewState = State#sea_treasure_local{log_map = NewLogMap},
    {noreply, NewState};

%========================================================
%% 协助成功，清理所有战场进程
%========================================================
do_handle_cast({'delete_helper_pid', BeHelperId, HelperId}, State) ->
    #sea_treasure_local{
        battle_field = FieldPidMap
    } = State,
    PidList = maps:get(BeHelperId, FieldPidMap, []),
    case PidList of
        [{HelperId, _}] ->
            NewMap = maps:remove(BeHelperId, FieldPidMap);
        _ ->
            NewList = lists:keydelete(HelperId, 1, PidList),
            NewMap = maps:put(BeHelperId, NewList, FieldPidMap)
    end,
    {noreply, State#sea_treasure_local{battle_field = NewMap}};

%========================================================
%% 掠夺
%========================================================
do_handle_cast({'rober_shipping', ShipSerId, ShipRoleId, AutoId, RoleId, BatType, Args}, State)
when BatType == ?BATTLE_TYPE_ROBER ->
    #sea_treasure_local{
        shipping_map = ShippingMap
        ,treasure_mod = TreasureMod
        ,battle_list = SendBatList
    } = State,
    [ServerId, _ServerNum,_RoleName, _Power, BGoldNum, _] = Args,
    ShippingList = maps:get(ShipSerId, ShippingMap, []),
    case lists:keyfind(AutoId, #shipping_info.auto_id, ShippingList) of
        #shipping_info{
            role_id = EnemyRoleId, rob_times = ?CAN_ROB, guild_id = FakeGuildId,
            id = ShippingType, ser_num = ShipSerNum, guild_name = FakeGuildName,
            role_name = EnemyRoleName, wlv = FakeWlv, career = Career, sex = Sex,
            turn = Turn, role_lv = EnemyRoleLv, power = EnemyPower
        } = Ship ->
            case lib_sea_treasure:check_before_rober(Ship, RoleId) of
                true ->
                    RoleA = {role, RoleId, ServerId, BGoldNum},
                    RoleB = {enemy, EnemyRoleId, ShipSerId, ShipSerNum, EnemyPower, EnemyRoleLv,
                        EnemyRoleName, FakeWlv, FakeGuildId, FakeGuildName, Career, Sex, Turn},
                    NewShip = Ship#shipping_info{rob_times = ?BE_ROBBING},
                    if
                        ServerId == ShipSerId -> %% 相同服
                            Arg = [0, AutoId, ShippingType, TreasureMod, BatType, 0,
                                RoleA, RoleB, ?local_battle_scene, urand:rand(1,10)
                            ],
                            Sql = io_lib:format(?sql_update_shipping_role_robtimes, [?BE_ROBBING, AutoId]),
                            db:execute(Sql),
                            Pid = mod_battle_field:start(lib_sea_treasure_battle, Arg),
                            NewShippingMap = lib_sea_treasure:save_to_map([{ShipSerId, NewShip}], ShippingMap),
                            SendList = lib_sea_treasure:construct_list_data_to_client([NewShip]),
                            {ok, Bin1} = pt_189:write(18911, [SendList]),
                            lib_sea_treasure:send_msg_to_all(Bin1),

                            SendShipL = [{AutoId, {#shipping_info.rob_times, ?BE_ROBBING}}],
                            TreasureMod =/= ?one_server_mod
                                andalso mod_sea_treasure_kf:get_data_from_local(ServerId, SendShipL, SendBatList),

                            pp_sea_treasure:send_error(RoleId, [?SUCCESS, AutoId, ShipSerId, ShipRoleId, BatType], 18905),
                            %% 更新玩家身上战斗进程pid
                            lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_sea_treasure, change_role_battle_pid, [Pid]);
                        true ->
                            Arg = [0, AutoId, ShippingType, TreasureMod, BatType, 0,
                                RoleA, RoleB, ?cluster_mod_battle_scene, urand:rand(1,10)
                            ],
                            NewShippingMap = ShippingMap,
                            SendShipInfo = [AutoId, NewShip#shipping_info.ser_id, ?BE_ROBBING, ShipRoleId],
                            % mod_sea_treasure_kf:start_battle_filed(BatType, 0, ServerId, RoleId, Arg)
                            mod_sea_treasure_kf:rob_shipping_kf(SendShipInfo, SendBatList, BatType, ServerId, RoleId, Arg)
                    end;
                {false, Code} ->
                    pp_sea_treasure:send_error(RoleId, [Code, AutoId, ShipSerId, ShipRoleId, BatType], 18905),
                    lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_player,
                        break_action_lock, [?ERRCODE(err189_on_sea_treasure_scene)]),
                    NewShippingMap = ShippingMap
            end;
        #shipping_info{} ->
            pp_sea_treasure:send_error(RoleId, [?ERRCODE(err189_be_robbing), AutoId, ShipSerId, ShipRoleId, BatType], 18905),
            lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_player,
                break_action_lock, [?ERRCODE(err189_on_sea_treasure_scene)]),
            NewShippingMap = ShippingMap;
        _ ->
            pp_sea_treasure:send_error(RoleId, [?ERRCODE(err189_ship_end), AutoId, ShipSerId, ShipRoleId, BatType], 18905),
            lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_player,
                break_action_lock, [?ERRCODE(err189_on_sea_treasure_scene)]),
            NewShippingMap = ShippingMap
    end,
    {noreply, State#sea_treasure_local{shipping_map = NewShippingMap}};

%========================================================
%% 复仇
%========================================================
do_handle_cast({'rober_shipping', ServerId, ShipRoleId, AutoId, RoleId, BatType, Args}, State)
when BatType == ?BATTLE_TYPE_RBACK ->
    #sea_treasure_local{
        battle_field = FieldPidMap
        ,treasure_mod = TreasureMod
        ,log_map = LogMap
        , rback_map = RbackMap
    } = State,
    [_ServerId, _ServerNum, _RoleName, _Power, BGoldNum, AssistId] = Args,
    LogList = maps:get(ShipRoleId, LogMap, []),
    % ?PRINT("LogMap:~p~n",[LogMap]),
    % ?PRINT("ShipRoleId:~p, AutoId:~p~n",[ShipRoleId, AutoId]),
    case lists:keyfind(AutoId, #treasure_log.auto_id, LogList) of
        #treasure_log{
            id = ShippingType, rober_sernum = RoberSerNum, rober_gid = RoberGuildId,
            rober_gname = RoberGuildName, rober_serid = RoberSerId, rober_id = RoberId,
            rober_name = RoberName, back_times = BackTimes} = Log ->
            RbackList = maps:get(AutoId, RbackMap, []),
            case lib_sea_treasure:check_before_rober(Log, RoleId, RbackList) of
                true ->
                    RoleA = {role, RoleId, ServerId, BGoldNum},
                    RoleB = {enemy, RoberId, RoberSerId, RoberSerNum, 0, 0, RoberName, 0, RoberGuildId, RoberGuildName, 0, 0, 0},
                    if
                        ServerId == RoberSerId -> %% 相同服
                            PidList = maps:get(ShipRoleId, FieldPidMap, []),
                            Arg = [ShipRoleId, AutoId, ShippingType, TreasureMod, BatType, BackTimes,
                                RoleA, RoleB, ?local_battle_scene, RoleId
                            ],
                            Pid = mod_battle_field:start(lib_sea_treasure_battle, Arg),
                            %% 更新玩家身上战斗进程pid
                            lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_sea_treasure, change_role_battle_pid, [Pid]),
                            NewList = lists:keystore(RoleId, 1, PidList, {RoleId, Pid}),
                            pp_sea_treasure:send_error(RoleId, [?SUCCESS, AutoId, ServerId, ShipRoleId, BatType], 18905),
                            NewFieldPidMap = maps:put(ShipRoleId, NewList, FieldPidMap);
                        true ->
                            Arg = [ShipRoleId, AutoId, ShippingType, TreasureMod, BatType, BackTimes,
                                RoleA, RoleB, ?cluster_mod_battle_scene
                            ],
                            % pp_sea_treasure:send_error(RoleId, [?SUCCESS, AutoId, ServerId, ShipRoleId, BatType], 18905),
                            ProtocolArg = [AutoId, ServerId, ShipRoleId, BatType],
                            mod_sea_treasure_kf:start_battle_filed(BatType, ShipRoleId, RoberSerId, ServerId, RoleId, Arg, ProtocolArg),
                            NewFieldPidMap = FieldPidMap
                    end,
                    % 修改该巡航的复仇战斗状态(新需求:不能多人同时复仇)
                    NewLog     = Log#treasure_log{rback_status = ?RBACK_BATTLE},
                    NewLogList = lists:keyreplace(AutoId, #treasure_log.auto_id, LogList, NewLog),
                    NewMap     = LogMap#{ShipRoleId => NewLogList};
                {false, Code} ->
                    % case Code =:= ?ERRCODE(err189_be_rob_back) of
                    %     true ->
                    %         lib_sea_treasure:usql_handle_delete(sea_treasure_rback, auto_id, [AutoId]),
                    %         lib_sea_treasure:usql_handle_delete(sea_treasure_log, auto_id, [AutoId]), % 此处可能导致巡航玩家还未拿回复仇奖励就删掉记录 从而使得无法获取复仇奖励
                    %         LeftList = lists:keydelete(AutoId, #treasure_log.auto_id, LogList),
                    %         NewMap = maps:put(ShipRoleId, LeftList, LogMap);
                    %     _ ->
                    %         NewMap = LogMap
                    % end,
                    NewMap = LogMap,
                    Code == ?ERRCODE(err189_be_rob_back) andalso mod_guild_assist:del_assist_by_id(AssistId),
                    lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_sea_treasure,
                        rob_shipping_kf, [[Code, AutoId, ServerId, ShipRoleId, BatType]]),
                    NewFieldPidMap = FieldPidMap
            end;
        _ ->
            %% 同步删除协助记录
            mod_guild_assist:del_assist_by_id(AssistId),
            lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_sea_treasure,
                rob_shipping_kf, [[?ERRCODE(err189_rback_get_reward), AutoId, ServerId, ShipRoleId, BatType]]),
            NewMap = LogMap,
            NewFieldPidMap = FieldPidMap
    end,
    {noreply, State#sea_treasure_local{battle_field = NewFieldPidMap, log_map = NewMap}};

%========================================================
%% 汇总需要更新数据到跨服的玩家
%========================================================
do_handle_cast({'update_role_info', Data}, State) ->
    ServerId = config:get_server_id(),
    #sea_treasure_local{
        update_ref = UpRef, update_role = UpList, need_up_role = NeedUpRoleL, belog_map = BeLogMap
    } = State,
    % ShippingList = maps:get(ServerId, ShippingMap, []),
    BeLogInfoL = maps:get(ServerId, BeLogMap, []),
    NewUpList = calc_new_up_list(ServerId, Data, [], NeedUpRoleL, BeLogInfoL, UpList),
    if
        NewUpList =/= [] andalso is_reference(UpRef) == false ->
            Time = max(3600, ?update_role_info_time),
            NewRef = util:send_after(UpRef, Time*1000, self(), {'update_role_info', ServerId});
        true ->
            NewRef = UpRef
    end,
    {noreply, State#sea_treasure_local{update_ref = NewRef, update_role = NewUpList}};

%========================================================
%% 所有巡航数据
%========================================================
do_handle_cast({'get_all_shipping_info', Args, ServerId, RoleId}, State) ->
    #sea_treasure_local{
        shipping_map = ShippingMap
    } = State,
    ShippingList = maps:get(ServerId, ShippingMap, []),
    case lists:keyfind(RoleId, #shipping_info.role_id, ShippingList) of
        #shipping_info{auto_id = AutoId, has_recieve = HasRecv} -> skip;
        _ -> AutoId = 0, HasRecv = 0
    end,
    % ?MYLOG("xlh","ServerId:~p, ShippingMap:~p~n",[ServerId, ShippingMap]),
    [Pic, PicVer, TreasureTimes, DayRewardTimes, RobTimes, MaxRobTimes] = Args,
    F = fun(_, Value, Acc) ->
        ShipList = [Ship|| #shipping_info{rob_times = BeRobTimes, role_id = RId, has_recieve = TemHasRecv} = Ship <- Value,
            RoleId == RId orelse (BeRobTimes =/= ?CANT_ROB andalso TemHasRecv == ?UNACHIEVE_SHIPPING_REWARD)],
        lib_sea_treasure:construct_list_data_to_client(ShipList, RoleId, Acc)
    end,
    RealSendL = maps:fold(F, [], ShippingMap),

    % AllShippingL = maps:values(ShippingMap),
    % SendList = lib_sea_treasure:construct_list_data_to_client(lists:flatten(AllShippingL), RoleId),
    % RealSendL = [ T || {_, _, _, _, _, _, RId, _, _, _, _, _, _, _, _, _, BeRobTimes} = T <-SendList,
    %     RoleId == RId orelse BeRobTimes =/= ?CANT_ROB],
    {ok, Bin} = pt_189:write(18900, [Pic, PicVer, TreasureTimes, DayRewardTimes, RobTimes, MaxRobTimes, AutoId, HasRecv, RealSendL]),
    lib_server_send:send_to_uid(RoleId, Bin),
    {noreply, State};

%========================================================
%% 巡航数据，小红点
%========================================================
do_handle_cast({'get_ship_status', ServerId, RoleId, TreasureTimes, DayRewardTimes}, State) ->
    #sea_treasure_local{
        shipping_map = ShippingMap
    } = State,
    ShippingList = maps:get(ServerId, ShippingMap, []),
    case lists:keyfind(RoleId, #shipping_info.role_id, ShippingList) of
        #shipping_info{auto_id = AutoId, has_recieve = HasRecv} -> skip;
        _ -> AutoId = 0, HasRecv = 0
    end,
    {ok, Bin} = pt_189:write(18917, [AutoId, HasRecv, TreasureTimes, DayRewardTimes]),
    lib_server_send:send_to_uid(RoleId, Bin),
    {noreply, State};

%========================================================
%% 掠夺记录
%========================================================
do_handle_cast({'get_all_log_info', RoleId}, State) ->
    #sea_treasure_local{
        log_map = LogMap
    } = State,
    LogList = maps:get(RoleId, LogMap, []),
    SendList = lib_sea_treasure:construct_list_data_to_client(LogList),
    {ok, Bin} = pt_189:write(18901, [SendList]),
    % ?PRINT("SendList:~p~n",[SendList]),
    lib_server_send:send_to_uid(RoleId, Bin),
    {noreply, State};

%========================================================
%% 领取巡航奖励/协助/复仇奖励
%========================================================
do_handle_cast({'recieve_reward', ServerId, RoleId, RoleLv, AutoId, RewardType}, State) ->
    #sea_treasure_local{shipping_map = ShippingMap, log_map = LogMap} = State,
    LogList = maps:get(RoleId, LogMap, []),
    if
        RewardType == 1 -> %%掠夺奖励（被帮助夺回的奖励）
            NewShippingMap = ShippingMap,
            case lists:keyfind(AutoId, #treasure_log.auto_id, LogList) of
                #treasure_log{
                    rober_hp = HpPer, back_reward = BackReward, recieve_reward = RecvReward
                    ,id = ShippingType, back_times = BackTimes, role_id = RoleId
                } = Log when RecvReward =/= [] ->
                    NewLog = Log#treasure_log{recieve_reward = []},
                    Sql1 = io_lib:format(?sql_update_treasure_log, [HpPer, util:term_to_bitstring([]),
                        util:term_to_bitstring(BackReward), BackTimes, AutoId]),
                    NewLogMap = recieve_reward_helper(ShippingType, AutoId, RewardType,
                        RoleId, sea_rback_reward, RecvReward, Sql1, RoleId, NewLog, LogMap, true);
                #treasure_log{} ->
                    {ok, Bin1} = pt_189:write(18909, [AutoId, RewardType, 0, ?FAIL, []]),
                    lib_server_send:send_to_uid(RoleId, Bin1),
                    NewLogMap = LogMap;
                _ ->
                    {ok, Bin1} = pt_189:write(18909, [AutoId, RewardType, 0, ?ERRCODE(err189_has_recieve), []]),
                    lib_server_send:send_to_uid(RoleId, Bin1),
                    NewLogMap = LogMap
            end;
        true ->
            ShippingList = maps:get(ServerId, ShippingMap, []),
            NewLogMap = LogMap,
            case lists:keyfind(AutoId, #shipping_info.auto_id, ShippingList) of
                #shipping_info{
                    id = ShippingType, rob_times = RobTimes, has_recieve = HasRecv
                    ,role_name = RoleName, end_time = _EndTime, role_id = RoleId
                } = Ship when HasRecv == ?ACHIEVE_SHIPPING_REWARD ->
                    % ?PRINT("============== AutoId:~p~n",[AutoId]),
                    #base_sea_treasure_reward{
                        reward = Reward, rob_reward = RobReward, exp_ratio = ExpRtio
                    } = data_sea_treasure:get_reward_info(ShippingType),
                    if
                        RobTimes == ?CAN_ROB ->
                            RoberSerId = 0, RoberId = 0, RoberName = <<"">>,
                            GetReward = Reward;
                        true ->
                            case lists:keyfind(AutoId, #treasure_log.auto_id, LogList) of
                                #treasure_log{
                                    rober_serid = RoberSerId, rober_id = RoberId, rober_name = RoberName
                                } -> skip;
                                _ -> RoberSerId = 0, RoberId = 0, RoberName = <<"">>
                            end,
                            GetReward = lib_sea_treasure:calc_get_reward(Reward, RobReward)
                    end,
                    % math:pow(1.5,((玩家等级-60)/120))*174679200*ExpRtio
                    RealReward = [{?TYPE_EXP, 0, erlang:round(math:pow(1.5, (RoleLv - 60)/120)*174679200*ExpRtio)}|GetReward],
                    Sql1 = io_lib:format(?sql_delete_treasure_shipping, [AutoId]),
                    NewShip = Ship#shipping_info{has_recieve = ?RECIEVE_SHIPPING_REWARD},
                    lib_log_api:log_sea_treasure(AutoId, ShippingType, ServerId, RoleId, RoleName, 1, RoberSerId,
                        RoberId, RoberName, RealReward),
                    NShippingMap = recieve_reward_helper(ShippingType, AutoId, RewardType, RoleId, sea_treasure_reward,
                        RealReward, Sql1, ServerId, NewShip, ShippingMap, false),
                    NewShipList = lists:keydelete(AutoId, #shipping_info.auto_id, ShippingList),
                    NewShippingMap = maps:put(ServerId, NewShipList, NShippingMap);
                #shipping_info{} ->
                    {ok, Bin1} = pt_189:write(18909, [AutoId, RewardType, 0, ?FAIL, []]),
                    lib_server_send:send_to_uid(RoleId, Bin1),
                    NewShippingMap = ShippingMap;
                _ ->
                    % ?PRINT("============== AutoId:~p~n",[AutoId]),
                    {ok, Bin1} = pt_189:write(18909, [AutoId, RewardType, 0, ?ERRCODE(err189_has_recieve), []]),
                    lib_server_send:send_to_uid(RoleId, Bin1),
                    NewShippingMap = ShippingMap
            end
    end,
    {noreply, State#sea_treasure_local{shipping_map = NewShippingMap, log_map = NewLogMap}};

%========================================================
%% 巡航机器人创建
%========================================================
do_handle_cast({'create_robot_kf', Num}, State) ->
    #sea_treasure_local{
        battle_list = SendBatList,
        wlv = Wlv, shipping_map = ShippingMap
    } = State,
    ServerId = config:get_server_id(),
    ServerNum = config:get_server_num(),
    Nowtime = utime:unixtime(),

    %%定期清理过期假人数据
    MapF = fun(_, ShippingList) -> clear_robot_data(ShippingList, Nowtime, []) end,
    NShippingMap = maps:map(MapF, ShippingMap),

    ShippingList = maps:get(ServerId, NShippingMap, []),
    {NewShippingList, ShipList} = do_create_shipping_info(Num, ServerId, ServerNum, Wlv, Nowtime, ShippingList, []),

    SendList = lib_sea_treasure:construct_list_data_to_client(ShipList),
    {ok, Bin} = pt_189:write(18911, [SendList]),
    lib_sea_treasure:send_msg_to_all(Bin),

    lib_sea_treasure:save_more_ship_to_db(ShipList),
    NewShippingMap = maps:put(ServerId, NewShippingList, NShippingMap),

    RealSendL = [Ship#shipping_info{end_ref = undefined, pic = <<"">>, pic_ver = 0} || Ship <- ShipList, is_record(Ship, shipping_info)],
    mod_sea_treasure_kf:get_data_from_local(ServerId, RealSendL, SendBatList),
    NewState = State#sea_treasure_local{shipping_map = NewShippingMap},
    {noreply, NewState};

%========================================================
%% 巡航数据--详细
%========================================================
do_handle_cast({'get_shipping_info', AutoId, ServerId, RoleId}, State) ->
    #sea_treasure_local{
        log_map = LogMap,
        shipping_map = ShippingMap
    } = State,
    ShippingList = maps:get(ServerId, ShippingMap, []),
    case lists:keyfind(AutoId, #shipping_info.auto_id, ShippingList) of
        %% 非机器人
        #shipping_info{id = ShippingType, role_id = RoleId, role_lv = RoleLv, rob_times = RobTimes} ->
            #base_sea_treasure_reward{
                reward = Reward, rob_reward = RobReward, exp_ratio = ExpRtio
            } = data_sea_treasure:get_reward_info(ShippingType),
            ExpReward = [{?TYPE_EXP, 0, erlang:round(math:pow(1.5, (RoleLv - 60)/120)*174679200*ExpRtio)}],
            LogList = maps:get(RoleId, LogMap, []),
            case lists:keyfind(AutoId, #treasure_log.auto_id, LogList) of
                #treasure_log{
                    rober_serid = RoberSerId
                    ,rober_sernum = RoberSerNum
                    ,rober_id = RoberId
                    ,rober_name = RoberName
                    ,rober_power = RoberPower
                    ,time = RobTime
                } ->
                    if
                        RobTimes =:= ?CAN_ROB ->
                            GetReward = Reward;
                        true ->
                            GetReward = lib_sea_treasure:calc_get_reward(Reward, RobReward)
                    end,
                    lib_server_send:send_to_uid(RoleId, pt_189, 18904, [AutoId, RoberSerId,
                        RoberSerNum, RoberId, RoberName, RoberPower, ShippingType, ExpReward++GetReward, RobReward, RobTime]);
                _ ->
                    lib_server_send:send_to_uid(RoleId, pt_189,
                        18904, [AutoId, 0, 0, 0, <<"">>, 0, ShippingType, ExpReward++Reward, [], 0])
            end;
        _ ->
            lib_server_send:send_to_uid(RoleId, pt_189,
                18904, [AutoId, 0, 0, 0, <<>>, 0, 0, [], [], 0])
    end,
    {noreply, State};

%========================================================
%% 秘籍 -- 结束本服所有巡航
%========================================================
do_handle_cast({'gm_end_ship'}, State) ->
    #sea_treasure_local{
        shipping_map = ShippingMap
    } = State,
    ServerId = config:get_server_id(),
    ShippingList = maps:get(ServerId, ShippingMap, []),
    Nowtime = utime:unixtime(),
    NewShipList = [begin
        NewRef = util:send_after(EndRef, urand:rand(100, 1900), self(), {'time_to_get_reward', ServerId, AutoId}),
        Ship#shipping_info{end_ref = NewRef, end_time = Nowtime}
    end
    ||#shipping_info{auto_id = AutoId, end_ref = EndRef} = Ship <- ShippingList, is_reference(EndRef) == true],
    NewMap = maps:put(ServerId, NewShipList, ShippingMap),
    {noreply, State#sea_treasure_local{shipping_map = NewMap}};

%========================================================
%% 秘籍 -- 清理本人所有掠夺记录
%========================================================
do_handle_cast({'gm_clear_treasure_log', RoleId}, State) ->
    #sea_treasure_local{
        log_map = LogMap
    } = State,
    LogList = maps:get(RoleId, LogMap, []),
    AutoIdList = [AutoId || #treasure_log{auto_id = AutoId} <- LogList],
    lib_sea_treasure:usql_handle_delete(sea_treasure_rback, auto_id, AutoIdList),
    lib_sea_treasure:usql_handle_delete(sea_treasure_log, auto_id, AutoIdList),
    NewMap = maps:remove(RoleId, LogMap),
    {noreply, State#sea_treasure_local{log_map = NewMap}};

%========================================================
%% 秘籍 -- 清理所有巡航记录
%========================================================
do_handle_cast({'gm_clear_treasure_log'}, State) ->
    #sea_treasure_local{
        log_map = LogMap
    } = State,
    LogList = lists:flatten(maps:values(LogMap)),
    AutoIdList = [AutoId || #treasure_log{auto_id = AutoId} <- LogList],
    lib_sea_treasure:usql_handle_delete(sea_treasure_rback, auto_id, AutoIdList),
    lib_sea_treasure:usql_handle_delete(sea_treasure_log, auto_id, AutoIdList),
    {noreply, State#sea_treasure_local{log_map = #{}}};

%========================================================
%% 秘籍 -- 修复巡航数据
%========================================================
do_handle_cast({'gm_clear_ship_info'}, State) ->
    #sea_treasure_local{
        shipping_map = ShippingMap, battle_list = SendBatList, treasure_mod = TreasureMod
    } = State,
    ServerId = config:get_server_id(),
    Nowtime = utime:unixtime(),
    ShippingList = maps:get(ServerId, ShippingMap, []),
    Fun = fun(#shipping_info{has_recieve = HasRecv, end_time = EndTime} = Ship, {Acc, Acc1}) ->
        if
            HasRecv == ?RECIEVE_SHIPPING_REWARD ->
                {Acc, Acc1};
            HasRecv == ?UNACHIEVE_SHIPPING_REWARD andalso EndTime < Nowtime ->
                NewShip = Ship#shipping_info{has_recieve = ?ACHIEVE_SHIPPING_REWARD, end_time = Nowtime},
                AutoId = NewShip#shipping_info.auto_id,
                SendL = [{#shipping_info.has_recieve, ?ACHIEVE_SHIPPING_REWARD}, {#shipping_info.end_time, Nowtime}],
                {[NewShip|Acc], [{AutoId, SendL}|Acc1]};
            true ->
                {[Ship|Acc], Acc1}
        end
    end,
    {NewShipList, SendShipL} = lists:foldl(Fun, {[], []}, ShippingList),
    %% 同步数据到对手服
    TreasureMod =/= ?one_server_mod
        andalso mod_sea_treasure_kf:get_data_from_local(ServerId, SendShipL, SendBatList),
    NewMap = maps:put(ServerId, NewShipList, ShippingMap),
    {noreply, State#sea_treasure_local{shipping_map = NewMap}};

%========================================================
%% 秘籍 -- 巡航机器人数据创建
%========================================================
do_handle_cast({'gm_create_robot'}, State) ->
    #sea_treasure_local{
        treasure_mod = NowMod, wlv = _Wlv,
        robot_ref = OldRef, battle_list = _SendBatList,
        shipping_map = ShippingMap
    } = State,
    ServerId = config:get_server_id(),
    ServerNum = config:get_server_num(),
    ShippingList = maps:get(ServerId, ShippingMap, []),
    Nowtime = utime:unixtime(),
    TreasureMod = ?one_server_mod,
    % ?PRINT("NowMod:~p, TreasureMod:~p~n",[NowMod, TreasureMod]),
    if
        NowMod == TreasureMod ->
            Num = lib_sea_treasure:calc_robot_num(TreasureMod),
            Wlv1 = util:get_world_lv(),
            {NewShippingList, ShipList} = do_create_shipping_info(Num, ServerId, ServerNum, Wlv1, Nowtime, ShippingList, []),
            lib_sea_treasure:save_more_ship_to_db(ShipList),
            NewShippingMap = maps:put(ServerId, NewShippingList, ShippingMap),

            SendList = lib_sea_treasure:construct_list_data_to_client(ShipList),
            {ok, Bin} = pt_189:write(18911, [SendList]),
            lib_sea_treasure:send_msg_to_all(Bin),

            RobotRef = OldRef;
            % case lib_sea_treasure:calc_robot_refresh_time(Nowtime+61) of
            %     {true, NextRefreshT} ->
            %         ServerNum = config:get_server_num(),
            %         % ?PRINT("NextRefreshT ~p~n", [NextRefreshT]),
            %         RobotRef = util:send_after(OldRef, max(NextRefreshT-Nowtime, 1)*1000, self(),
            %             {'create_robot', ServerId, ServerNum, TreasureMod});
            %     _ ->
            %         RobotRef = undefined
            % end;
        true ->
            % Num = lib_sea_treasure:calc_robot_num(NowMod),
            % {NewShippingList, ShipList} = do_create_shipping_info(Num, ServerId, ServerNum, Wlv, Nowtime, ShippingList, []),
            % lib_sea_treasure:save_more_ship_to_db(ShipList),
            % NewShippingMap = maps:put(ServerId, NewShippingList, ShippingMap),
            % mod_sea_treasure_kf:get_data_from_local(ServerId, ShipList, SendBatList),

            util:cancel_timer(OldRef),
            RobotRef = undefined, NewShippingMap = ShippingMap,
            mod_sea_treasure_kf:gm_create_robot()
    end,
    NewState = State#sea_treasure_local{
        robot_ref = RobotRef, shipping_map = NewShippingMap
    },
    {noreply, NewState};

do_handle_cast({'gm_repaire_log_data'}, State) ->
    Sql1 = io_lib:format(?sql_select_treasure_log, []),
    LogList = db:get_all(Sql1),
    ServerId = config:get_server_id(),
    Fun = fun(Val, {Type, Map, Map1}) ->
        case lib_sea_treasure:db_data_make_record(Type, Val) of
            #treasure_log{auto_id = AutoId, role_id = RoleId, rober_serid = RoberSerId, rober_id = RoberId} = R ->
                OldList = maps:get(RoleId, Map, []),
                NewList = lists:keystore(AutoId, #treasure_log.auto_id, OldList, R),
                OldASL = maps:get(RoberSerId, Map1, []),
                NewASL = ?IF(RoberId =/= 0, lists:keystore(AutoId, 1, OldASL, {AutoId, RoleId, ServerId, RoberId}), OldASL),
                NewMap1 = maps:put(RoberSerId, NewASL, Map1),
                {Type, maps:put(RoleId, NewList, Map), NewMap1};
            _ -> {Type, Map, Map1}
        end
    end,
    {DeleteAidList, NewLogList} = lib_sea_treasure:change_list_gm(LogList),
    {_, LogMap, BeLogMap} = lists:foldl(Fun, {log, #{}, #{}}, NewLogList),
    NewBeLogMap = maps:remove(ServerId, BeLogMap),
    MapList = maps:to_list(NewBeLogMap),
    spawn(fun() ->
        send_log_data_to_cluster(ServerId, MapList),
        DeleteAidList =/= [] andalso mod_sea_treasure_kf:get_log_data_from_local(DeleteAidList)
    end),
    mod_guild_assist:clear_assist_monday(),
    NewState = State#sea_treasure_local{
        log_map = LogMap
        ,belog_map = BeLogMap
    },
    lib_gm_stop:gm_close_sea_treasure_rob(0),
    {noreply, NewState};

%========================================================
%% 对战分配数据
%========================================================
do_handle_cast({'get_enemy_info', RoleId}, State) ->
    #sea_treasure_local{
        treasure_mod = NowMod, wlv = Wlv, battle_list = SendBatList,
        unsatisfy_mod = UnSatisfyMod, unsatisfy_list = UnSatisfyList
        , server_info = ServerInfo
    } = State,
    Fun = fun(SerId, {Acc, AccN, AccC}) ->
        case lists:keyfind(SerId, 1, ServerInfo) of
            {ServerId, _, WorldLv, ServerNum, ServerName} ->
                {[{ServerId, ServerNum, ServerName, WorldLv}|Acc], AccN+WorldLv, AccC+1};
            _ -> {Acc, AccN, AccC}
        end
    end,
    {Enemy, _, _} = lists:foldl(Fun, {[], 0, 0}, SendBatList),
    {UnSatisfyE, Total, Num} = lists:foldl(Fun, {[], 0, 0}, UnSatisfyList),
    UnSatisfyWlv = erlang:round(Total div max(1, Num)),
    case data_sea_treasure:get_mod_info(UnSatisfyMod) of
        #base_sea_treasure_mod{wlv_min = MinLv} -> skip;
        _ -> MinLv = 0
    end,
    Args = [NowMod, Wlv, Enemy, UnSatisfyMod, UnSatisfyWlv, MinLv, UnSatisfyE],
    pp_sea_treasure:send_error(RoleId, Args, 18915),
    {noreply, State};

%========================================================
%% 发起协助
%========================================================
do_handle_cast({'launch_sea_treasure_assist', RoleId, Args, AutoId}, State) ->
    #sea_treasure_local{
        log_map = LogMap
    } = State,
    LogList = maps:get(RoleId, LogMap, []),
    case lists:keyfind(AutoId, #treasure_log.auto_id, LogList) of
        #treasure_log{
            id = ShippingType, role_id = RoleId, rober_id = RoberId,
            rober_serid = RoberSerId, rober_sernum = RoberSerNum, rober_name = RoberName,
            rober_power = RoberPower,reward = RobReward, back_reward = BackReward
        } ->
            GetReward = lib_sea_treasure:calc_get_reward(RobReward, BackReward),
            if
                GetReward =/= [] ->
                    ServerId = config:get_server_id(),
                    TarScene = ?IF(RoberSerId == ServerId, ?local_battle_scene, ?cluster_mod_battle_scene),
                    RoberInfo = [RoberSerId, RoberSerNum, RoberId, RoberName, RoberPower, RobReward, BackReward],
                    ExtraArg = [AutoId, ServerId, RoleId, TarScene, RoberInfo],
                    [AssistCfg] = Args,
                    lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE,
                        lib_guild_assist, launch_sea_treasure_assist, [AssistCfg, ShippingType, AutoId, ExtraArg]);
                true ->
                    lib_server_send:send_to_uid(RoleId, pt_404, 40401,
                        [?ERRCODE(err189_be_rob_back), 0, 0, 0, 0, AutoId])
            end;
        _ ->
            lib_server_send:send_to_uid(RoleId, pt_404, 40401,
                [?ERRCODE(err189_log_is_not_exist), 0, 0, 0, 0, AutoId])
    end,
    {noreply, State};

do_handle_cast({'gm_output_data', DataType, AutoId, RoleId, ServerId}, State) ->
    #sea_treasure_local{
        shipping_map = ShippingMap,
        log_map = LogMap
    } = State,
    ShippingList = maps:get(ServerId, ShippingMap, []),
    LogList = maps:get(RoleId, LogMap, []),
    if
        DataType == 1 -> %% 输出单只船只信息
            Ship = ulists:keyfind(AutoId, #shipping_info.auto_id, ShippingList, []),
            ?INFO("Ship:~p", [Ship]);
        DataType == 2 -> %% 输出整个ShippingList
            ?INFO("ShippingList:~p", [ShippingList]);
        DataType == 3 -> %% 输出单个 treasure_log 信息
            Log = ulists:keyfind(AutoId, #treasure_log.auto_id, LogList, []),
            ?INFO("Log:~p", [Log]);
        DataType == 4 -> %% 输出所有 treasure_log 信息
            ?INFO("LogList:~p", [LogList]);
        true ->
            skip
    end,
    {noreply, State};

do_handle_cast(_Msg, State) ->
    {noreply, State}.

do_handle_call(_, State) ->
    {reply, ok, State}.

%========================================================
%% 定时检查数据是否同步成功
%========================================================
do_handle_info({'check_need_synchronism', ServerId}, State) ->
    #sea_treasure_local{
        is_init = IsInit
        ,init_ref = InitRef
    } = State,
    if
        IsInit == false ->
            mod_sea_treasure_kf:local_init(ServerId, config:get_merge_server_ids()),
            NewRef = util:send_after(InitRef, 120*1000, self(), {'check_need_synchronism', ServerId});
        true ->
            util:cancel_timer(InitRef),
            NewRef = undefined
    end,
    NewState = State#sea_treasure_local{init_ref = NewRef},
    {noreply, NewState};

%========================================================
%% 定时同步玩家数据到跨服
%========================================================
do_handle_info({'update_role_info', ServerId}, State) ->
    #sea_treasure_local{
        update_ref = OldRef, update_role = UpList, belog_map = BeLogMap,
        log_map = LogMap, shipping_map = ShippingMap, battle_list = SendBatList,
        belog_list = BelogList
    } = State,
    util:cancel_timer(OldRef),
    ShippingList = maps:get(ServerId, ShippingMap, []),

    SelfSerLogList = maps:get(ServerId, BeLogMap, []),

    %% 本服掠夺记录更新
    NewLogMap = do_update_log_map(LogMap, SelfSerLogList, UpList),
    Fun = fun(RoleInfo, {Acc, Acc1}) ->
        #role_shipping_info{
            guild_id = GuildId, guild_name = GuildName, role_id = RoleId,
            role_name = RoleName, power = Power, role_lv = RoleLv
        } = RoleInfo,

        case lists:keyfind(RoleId, #shipping_info.role_id, Acc) of
            #shipping_info{} = Ship ->
                NewShip = update_role_shipping_help(Ship, GuildId, GuildName, RoleName, Power, RoleLv),
                {lists:keystore(RoleId, #shipping_info.role_id, Acc, NewShip),
                    [NewShip#shipping_info{end_ref = undefined, pic = <<"">>, pic_ver = 0}|Acc1]};
            _ ->
                {Acc, Acc1}
        end
    end,
    {NewShippingList, SendShipL} = lists:foldl(Fun, {ShippingList, []}, UpList),
    SendRoleInfoMap = do_make_send_role_info(BelogList, UpList, #{}),
    NewShippingMap = maps:put(ServerId, NewShippingList, ShippingMap),
    lib_sea_treasure:save_more_ship_to_db(SendShipL),
    spawn(fun() ->
        send_data_to_cluster_helper(SendShipL, 1, ServerId, SendBatList),
        maps:map(fun(Key, Value) -> send_role_info_to_cluster(ServerId, Key, Value) end, SendRoleInfoMap)
    end),
    NewState = State#sea_treasure_local{
        update_ref = undefined, update_role = [],
        log_map = NewLogMap, shipping_map = NewShippingMap
    },
    {noreply, NewState};

%========================================================
%% 服务器开启后12s，所有未完成的巡航都会启动定时器
%========================================================
do_handle_info({'start_shipping_ref', ServerId}, State) ->
    #sea_treasure_local{
        shipping_map = ShippingMap
        ,is_init = IsInit
        ,init_ref = InitRef
    } = State,
    if
        IsInit == false ->
            mod_sea_treasure_kf:local_init(ServerId, config:get_merge_server_ids()),
            NewRef = util:send_after(InitRef, 120*1000, self(), {'check_need_synchronism', ServerId});
        true ->
            util:cancel_timer(InitRef),
            NewRef = undefined
    end,
    ShippingList = maps:get(ServerId, ShippingMap, []),
    Nowtime = utime:unixtime(),

    Fun = fun
        (#shipping_info{has_recieve = ?UNACHIEVE_SHIPPING_REWARD} = Ship, {Acc1, Acc2}) ->
            #shipping_info{auto_id = AutoId, end_time = EndTime, end_ref = OldRef} = Ship,
            %% 开服2分钟后所有未完成的都会启动定时器
            NewERef = util:send_after(OldRef, max(EndTime - Nowtime, 15)*1000, self(), {'time_to_get_reward', ServerId, AutoId}),
            {[Ship#shipping_info{end_ref = NewERef}|Acc1], Acc2};
        (#shipping_info{has_recieve = ?ACHIEVE_SHIPPING_REWARD} = Ship, {Acc1, Acc2}) ->
            {[Ship|Acc1], Acc2};
        (#shipping_info{auto_id = AutoId}, {Acc1, Acc2}) ->
            {Acc1, [AutoId|Acc2]};
        (_, Acc) -> Acc
    end,
    {NewShippingList, DeleteAuidList} = lists:foldl(Fun, {[], []}, ShippingList),
    lib_sea_treasure:usql_handle_delete(sea_treasure_shipping, auto_id, DeleteAuidList),
    NewShippingMap = maps:put(ServerId, NewShippingList, ShippingMap),
    NewState = State#sea_treasure_local{
        shipping_map = NewShippingMap
        ,init_ref = NewRef
    },
    {noreply, NewState};

%========================================================
%% 巡航结束处理
%========================================================
do_handle_info({'time_to_get_reward', ServerId, AutoId}, State) ->
    %% 调试日志输出，LogType为3表示是暂时输出调试的
    lib_log_api:log_sea_treasure(AutoId, 0, ServerId, 0, <<"">>, 3, 0, 0, <<"">>, []),
    #sea_treasure_local{
        log_map = LogMap, battle_list = SendBatList,
        shipping_map = ShippingMap, treasure_mod = TreasureMod
    } = State,
    ShippingList = maps:get(ServerId, ShippingMap, []),
    case lists:keyfind(AutoId, #shipping_info.auto_id, ShippingList) of
        %% 非机器人
        #shipping_info{
            id = ShippingType, role_id = RoleId, role_name = RoleName, role_lv = RoleLv,
            has_recieve = HasRecv, end_ref = OldRef, rob_times = RobTimes
        } = OldShip when RoleId =/= 0 andalso HasRecv == ?UNACHIEVE_SHIPPING_REWARD ->
            util:cancel_timer(OldRef),
            NewRef = undefined,
            NewHasRecv = ?ACHIEVE_SHIPPING_REWARD,
            Sql = io_lib:format(?sql_update_shipping_role_recieve, [NewHasRecv, AutoId]),
            db:execute(Sql),
            NewShip = OldShip#shipping_info{has_recieve = NewHasRecv, end_ref = NewRef},
            #base_sea_treasure_reward{
                reward = Reward, rob_reward = RobReward, exp_ratio = ExpRtio
            } = data_sea_treasure:get_reward_info(ShippingType),
            ExpReward = [{?TYPE_EXP, 0, erlang:round(math:pow(1.5, (RoleLv - 60)/120)*174679200*ExpRtio)}],
            LogList = maps:get(RoleId, LogMap, []),
            case lists:keyfind(AutoId, #treasure_log.auto_id, LogList) of
                #treasure_log{
                    rober_serid = RoberSerId
                    ,rober_sernum = RoberSerNum
                    ,rober_id = RoberId
                    ,rober_name = RoberName
                    ,rober_power = RoberPower
                    ,time = RobTime
                } ->
                    if
                        RobTimes =:= ?CAN_ROB ->
                            GetReward = Reward;
                        true ->
                            GetReward = lib_sea_treasure:calc_get_reward(Reward, RobReward)
                    end,
                    %% 日志
                    lib_log_api:log_sea_treasure(AutoId, ShippingType, ServerId, RoleId,
                        RoleName, 2, RoberSerId, RoberId, RoberName, []),

                    lib_server_send:send_to_uid(RoleId, pt_189, 18904, [AutoId, RoberSerId, RoberSerNum,
                        RoberId, RoberName, RoberPower, ShippingType, GetReward++ExpReward, RobReward, RobTime]);
                _ ->
                    lib_server_send:send_to_uid(RoleId, pt_189,
                        18904, [AutoId, 0, 0, 0, <<"">>, 0, ShippingType, Reward++ExpReward, [], 0])
            end,
            SendShipL = [{AutoId, {#shipping_info.has_recieve, NewHasRecv}}],
            %% 同步数据到对手服
            TreasureMod =/= ?one_server_mod
                andalso mod_sea_treasure_kf:get_data_from_local(ServerId, SendShipL, SendBatList),
            NewShippingList = lists:keystore(AutoId, #shipping_info.auto_id, ShippingList, NewShip);
        %% 机器人直接删掉数据
        #shipping_info{has_recieve = HasRecv, end_ref = OldRef} when HasRecv == ?UNACHIEVE_SHIPPING_REWARD ->
            util:cancel_timer(OldRef),
            Sql = io_lib:format(?sql_delete_treasure_shipping, [AutoId]),
            db:execute(Sql),
            NewShippingList = lists:keydelete(AutoId, #shipping_info.auto_id, ShippingList);
        _ ->
            NewShippingList = ShippingList
    end,
    NewShippingMap = maps:put(ServerId, NewShippingList, ShippingMap),

    NewState = State#sea_treasure_local{
        shipping_map = NewShippingMap
    },
    {noreply, NewState};

%========================================================
%% 机器人创建
%========================================================
do_handle_info({'create_robot', ServerId, ServerNum, TreasureMod}, State) ->
    #sea_treasure_local{
        treasure_mod = NowMod,
        robot_ref = OldRef,
        shipping_map = ShippingMap
    } = State,
    ShippingList = maps:get(ServerId, ShippingMap, []),
    if
        NowMod == TreasureMod ->
            Num = lib_sea_treasure:calc_robot_num(TreasureMod),
            Nowtime = utime:unixtime(),
            Wlv = util:get_world_lv(),
            {NewShippingList, ShipList} = do_create_shipping_info(Num, ServerId, ServerNum, Wlv, Nowtime, ShippingList, []),
            lib_sea_treasure:save_more_ship_to_db(ShipList),

            SendList = lib_sea_treasure:construct_list_data_to_client(ShipList),
            {ok, Bin} = pt_189:write(18911, [SendList]),
            lib_sea_treasure:send_msg_to_all(Bin),

            NewShippingMap = maps:put(ServerId, NewShippingList, ShippingMap),
            RobotRef = erlang:send_after(1200 * 1000, self(), {'create_robot', ServerId, ServerNum, TreasureMod});
            % case lib_sea_treasure:calc_robot_refresh_time(Nowtime+61) of
            %     {true, NextRefreshT} ->
            %         ServerNum = config:get_server_num(),
            %         RobotRef = util:send_after(OldRef, max(NextRefreshT-Nowtime, 1)*1000, self(),
            %             {'create_robot', ServerId, ServerNum, TreasureMod});
            %     _ ->
            %         util:cancel_timer(OldRef),
            %         RobotRef = undefined
            % end;
        true ->
            util:cancel_timer(OldRef),
            RobotRef = undefined,
            NewShippingMap = ShippingMap
    end,
    NewState = State#sea_treasure_local{
        robot_ref = RobotRef, shipping_map = NewShippingMap
    },
    {noreply, NewState};

do_handle_info(_Msg, State) ->
    {noreply, State}.

%========================================================
%% 同步数据到跨服
%========================================================
send_data_to_cluster(ShippingMap, BeLogMap, ServerId, SendBatList) ->
    SendList = maps:get(ServerId, ShippingMap, []),
    NewBeLogMap = maps:remove(ServerId, BeLogMap),
    MapList = maps:to_list(NewBeLogMap),
    %% 上传数据前将定时器去掉, 头像数据去掉
    RealSendL = [Ship#shipping_info{end_ref = undefined, pic = <<"">>, pic_ver = 0}
    ||#shipping_info{has_recieve = HasRecv} = Ship <- SendList, HasRecv == ?UNACHIEVE_SHIPPING_REWARD],
    spawn(fun() ->
        send_data_to_cluster_helper(RealSendL, 1, ServerId, SendBatList),
        send_log_data_to_cluster(ServerId, MapList),
        mod_sea_treasure_kf:get_other_server_data(ServerId, SendBatList)
    end).

send_data_to_cluster_helper([], _, _, _) -> skip;
send_data_to_cluster_helper(List, StartPos, ServerId, SendBatList) ->
    case lists:sublist(List, StartPos, ?SEND_DATA_LENGTH) of
        [] -> skip;
        SendList ->
            mod_sea_treasure_kf:get_data_from_local(ServerId, SendList, SendBatList),
            timer:sleep(1000),
            send_data_to_cluster_helper(List -- SendList, StartPos, ServerId, SendBatList)
    end.

send_role_info_to_cluster(_, _, []) -> skip;
send_role_info_to_cluster(ServerId, ToServerId, List) ->
    case lists:sublist(List, 1, ?SEND_DATA_LENGTH) of
        [] -> skip;
        SendList ->
            mod_sea_treasure_kf:get_role_info_from_local(ServerId, ToServerId, SendList),
            timer:sleep(500),
            send_role_info_to_cluster(ServerId, ToServerId, List -- SendList)
    end.

send_log_data_to_cluster(_, []) -> skip;
send_log_data_to_cluster(ServerId, MapList) -> %% 本服掠夺的没必要上传跨服中心
    [send_log_data_to_cluster(RoberSerId, 1, List) || {RoberSerId, List} <- MapList, RoberSerId =/= ServerId],
    ok.

send_log_data_to_cluster(_, _, []) -> skip;
send_log_data_to_cluster(RoberSerId, StartPos, List) ->
    case lists:sublist(List, StartPos, 2*?SEND_DATA_LENGTH) of
        [] -> skip; %% 走到这一般是?SEND_DATA_LENGTH为0
        SendList ->
            mod_sea_treasure_kf:get_log_data_from_local(RoberSerId, SendList),
            timer:sleep(500),
            send_log_data_to_cluster(RoberSerId, StartPos, List -- SendList)
    end.

%% 发送需要清理AutoId列表跨服进程
send_clear_data_to_kf(_, _, []) -> skip;
send_clear_data_to_kf(RoberSerId, StartPos, List) ->
    case lists:sublist(List, StartPos, 2*?SEND_DATA_LENGTH) of
        [] -> skip; %% 走到这一般是?SEND_DATA_LENGTH为0
        SendList ->
            mod_clusters_node:apply_cast(mod_sea_treasure_kf, get_clear_data_from_local, [RoberSerId, SendList]),
            %% 休眠足够长时间，保证上一次发的数据已经处理完再发
            timer:sleep(300 * 1000),
            send_clear_data_to_kf(RoberSerId, StartPos, List -- SendList)
    end.

%========================================================
%% 复仇/助战数据、协议处理
%========================================================
do_after_rob_back_helper(Arg, LogMap, RoleId, BeHelperId, RoberInfo) ->
    [Res, BGoldNum, BatType, ShippingType, AutoId, _RHpPer, HpPer, _, _, Enemy, _] = Arg,
    LogList = maps:get(BeHelperId, LogMap, []),
    #role_info{
        pic = Pic, pic_ver = PicVer, role_name = RoberRName, ser_num = RoberSerNum
    } = RoberInfo,
    #fake_info{
        ser_num = EnemySerNum, role_id = EnemyId, role_name = EnemyName
    } = Enemy,
    case lists:keyfind(AutoId, #treasure_log.auto_id, LogList) of
        #treasure_log{
            reward = RobReward, rober_hp = BeforeHpPer, rober_serid = EnemySerId,
            back_reward = OldReward, recieve_reward = OldRecvReward, back_times = OldRbackTimes
        } = OldLog ->
            Log = OldLog#treasure_log{back_times = OldRbackTimes+1},
            GetReward = lib_sea_treasure:calc_get_reward(RobReward, OldReward),
            if
                Res == 1 andalso GetReward =/= [] -> %% 胜利夺回剩下所有奖励
                    NewBackReward = RobReward,
                    {Reward, NewHpPer, HelperReward, NewBGoldNum} =
                                lib_sea_treasure:calc_back_reward_by_hp(100, BeforeHpPer, RobReward, BGoldNum),
                    ProtocolArg = [RoleId, RoberRName, Pic, PicVer, ShippingType, AutoId, Reward],
                    NewLog = do_after_rob_back_core(RoleId, BeHelperId, Log, NewHpPer, RobReward,
                        ProtocolArg, HelperReward, BGoldNum, NewBGoldNum, OldRecvReward, Reward);
                true -> %% 小败
                    DeleteHpPer = 100 - HpPer,
                    {Reward, NewHpPer, HelperReward, NewBGoldNum} =
                        lib_sea_treasure:calc_back_reward_by_hp(DeleteHpPer, BeforeHpPer, RobReward, BGoldNum),
                    case Reward =/= [] of
                        true ->
                            NewBackReward = ulists:object_list_plus([Reward, OldReward]),
                            ProtocolArg = [RoleId, RoberRName, Pic, PicVer, ShippingType, AutoId, Reward],
                            NewLog = do_after_rob_back_core(RoleId, BeHelperId, Log, NewHpPer, NewBackReward,
                                ProtocolArg, HelperReward, BGoldNum, NewBGoldNum, OldRecvReward, Reward);
                        _ ->
                            NewLog = Log#treasure_log{rback_status = ?RBACK_PEACE}, NewBackReward = OldReward
                    end
            end,
            NewRecvReward = NewLog#treasure_log.recieve_reward,
            %% 更新数据库
            Sql1 = io_lib:format(?sql_update_treasure_log, [NewHpPer, util:term_to_bitstring(Reward),
                util:term_to_bitstring(NewBackReward), OldRbackTimes+1, AutoId]),
            db:execute(Sql1),
            NewLogMap = lib_sea_treasure:save_to_map([{BeHelperId, NewLog}], LogMap);
        _ ->
            ?ERR("do_after_battle  log not exists AutoId:~p~n",[AutoId]),
            Reward = [], NewLogMap = LogMap, NewRecvReward = [], EnemySerId = 0, HelperReward = []
    end,
    lib_log_api:log_sea_treasure_rback(config:get_server_id(), BeHelperId, RoleId, RoberRName, AutoId,
                ShippingType, EnemySerId, EnemyId, EnemyName, Res, Reward, NewRecvReward),
    %% 协助结果返回
    if
        RoleId =/= BeHelperId ->
            %% 协助结果返回
            lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_guild_assist,
                rback_resoult, [AutoId, Res, Reward, [EnemySerNum, EnemyName]]);
        true -> %% 自己协助自己/复仇，无论有没有发起协助都执行一遍删除协助操作（自己协助自己的时候客户端没有发协助协议）
            %% 协助结果返回
            mod_guild_assist:rback_resoult_after_battle(RoleId, AutoId, Res, Reward, [RoberSerNum, RoberRName])
    end,
    %% 通知协助者掠夺结果
    ProtocolArg07 = lib_sea_treasure:construct_data_for_18907(Res, BatType, ShippingType, AutoId, RoberInfo,
        Enemy, BeHelperId, HelperReward),

    {ok, Bin} = pt_189:write(18907, ProtocolArg07),
    lib_server_send:send_to_uid(RoleId, Bin),
    NewLogMap.

do_after_rob_back_core(RoleId, BeHelperId, Log, NewHpPer, NewBackReward, ProtocolArg,
HelperReward, BGoldNum, NBGoldNum, OldRecvReward, Reward) ->
    % Sql1 = io_lib:format(?sql_update_treasure_log, [NewHpPer, util:term_to_bitstring(Reward),
    %     util:term_to_bitstring(NewBackReward), OldRbackTimes, AutoId]),
    % db:execute(Sql1),
    % RoleId =/= BeHelperId andalso lib_relationship_api:add_firend_directly(RoleId, BeHelperId),
    if
        RoleId == BeHelperId ->
            NewBGoldNum = BGoldNum;
        true ->
            lib_relationship_api:add_firend_directly(RoleId, BeHelperId),
            NewBGoldNum = NBGoldNum,
            [RoleId, RoberRName, Pic, PicVer, ShippingType, AutoId, Reward] = ProtocolArg,
            ProtocolArg1 = [RoleId, RoberRName, Pic, PicVer, ShippingType, AutoId, Reward, 1],
            %% 通知求助者复仇结果
            {ok, Bin1} = pt_189:write(18908, ProtocolArg1),
            lib_server_send:send_to_uid(BeHelperId, Bin1)
    end,
    %% 发送奖励 %% 被协助者自己手动领取奖励
    % lib_player:apply_cast(BeHelperId, ?APPLY_CAST_STATUS, lib_sea_treasure,
    %     sea_treasure_reward, [sea_rob_back_reward, Reward]),
    lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_sea_treasure,
        sea_treasure_reward, [sea_rob_back_reward, HelperReward, NewBGoldNum]),
    NewRecvReward = ulists:object_list_plus([OldRecvReward, Reward]),
    Log#treasure_log{rober_hp = NewHpPer, back_reward = NewBackReward, recieve_reward = NewRecvReward, rback_status = ?RBACK_PEACE}.

%========================================================
%% 检测数据是否需要保存
%========================================================
check_need_save_role_info(RoleId, _ShippingList, RoleLogList, BeLogInfoL) ->
    case lists:member(RoleId, RoleLogList) of
        true -> true;
        _ ->
            case lists:keyfind(RoleId, 4, BeLogInfoL) of
                {_, _, _, _} -> true;
                _ -> false
            end
            %% 巡航中的数据不更新
            % case lists:keyfind(RoleId, #shipping_info.role_id, ShippingList) of
            %     #shipping_info{} -> true;
            %     _ -> false
            % end
    end.

%========================================================
%% 更新缓存数据
%========================================================
calc_new_up_list(_ServerId, {guild_quit, RoleId}, ShippingList, RoleLogList, BeLogInfoL, UpList) ->
    case check_need_save_role_info(RoleId, ShippingList, RoleLogList, BeLogInfoL) of
        true ->
            case lists:keyfind(RoleId, #role_shipping_info.role_id, UpList) of
                #role_shipping_info{} = Info ->
                    NewInfo = Info#role_shipping_info{guild_id = 0, guild_name = <<"">>};
                _ ->
                    NewInfo = #role_shipping_info{role_id = RoleId, guild_id = 0, guild_name = <<"">>}
            end,
            lists:keystore(RoleId, #role_shipping_info.role_id, UpList, NewInfo);
        _ -> UpList
    end;
calc_new_up_list(_ServerId, {guild_disband, []}, _ShippingList, _, _, UpList) -> UpList;
calc_new_up_list(ServerId, {guild_disband, [RoleId|RoleIdIdList]}, ShippingList, RoleLogList, BeLogInfoL, UpList) ->
    NewUpList = calc_new_up_list(ServerId, {guild_quit, RoleId}, ShippingList, RoleLogList, BeLogInfoL, UpList),
    calc_new_up_list(ServerId, {guild_disband, RoleIdIdList}, ShippingList, RoleLogList, BeLogInfoL, NewUpList);
calc_new_up_list(_ServerId, {guild, RoleId, GuildId, GuildName}, ShippingList, RoleLogList, BeLogInfoL, UpList) ->
    case check_need_save_role_info(RoleId, ShippingList, RoleLogList, BeLogInfoL) of
        true ->
            case lists:keyfind(RoleId, #role_shipping_info.role_id, UpList) of
                #role_shipping_info{} = Info ->
                    NewInfo = Info#role_shipping_info{guild_id = GuildId, guild_name = GuildName};
                _ ->
                    NewInfo = #role_shipping_info{role_id = RoleId, guild_id = GuildId, guild_name = GuildName}
            end,
            lists:keystore(RoleId, #role_shipping_info.role_id, UpList, NewInfo);
        _ -> UpList
    end;
calc_new_up_list(_ServerId, {role, RoleId, N, Value}, ShippingList, RoleLogList, BeLogInfoL, UpList) ->
    case check_need_save_role_info(RoleId, ShippingList, RoleLogList, BeLogInfoL) of
        true ->
            case lists:keyfind(RoleId, #role_shipping_info.role_id, UpList) of
                #role_shipping_info{} = Info -> skip;
                _ ->
                    Info = #role_shipping_info{role_id = RoleId}
            end,
            NewInfo = setelement(N, Info, Value),
            lists:keystore(RoleId, #role_shipping_info.role_id, UpList, NewInfo);
        _ -> UpList
    end;
calc_new_up_list(_, _, _, _, _, UpList) -> UpList.

%========================================================
%% 更新玩家缓存数据
%========================================================
update_role_shipping_help(Ship, GuildId, GuildName, RoleName, Power, RoleLv) ->
    #shipping_info{guild_id = OldGId, guild_name = OldGName,
        role_name = OldName, role_lv = OldLv, power = OldPower
    } = Ship,
    NewGId = calc_new_role_info(OldGId, GuildId),
    NewGName = calc_new_role_info(OldGName, GuildName),
    NewName = calc_new_role_info(OldName, RoleName),
    NewLv = calc_new_role_info(OldLv, RoleLv),
    NewPower = calc_new_role_info(OldPower, Power),
    Ship#shipping_info{
        guild_id = NewGId, guild_name = NewGName,
        role_name = NewName, role_lv = NewLv, power = NewPower
    }.

calc_new_role_info(OldVal, NewVal) ->
    ?IF(NewVal =/= null andalso OldVal =/= NewVal, NewVal, OldVal).
%========================================================
%% 领取奖励-- 协议处理
%========================================================
recieve_reward_helper(ShippingType, AutoId, RewardType, RoleId, ProduceType, Reward, Sql, Key, NewInfo, Map, NeedSave) ->
    lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE,
        lib_sea_treasure, sea_treasure_reward, [ProduceType, Reward]),
    db:execute(Sql),
    SendList = lib_sea_treasure:construct_list_data_to_client([NewInfo]),
    if
        is_record(NewInfo, treasure_log) ->
            {ok, Bin} = pt_189:write(18910, [SendList]);
        true ->
            {ok, Bin} = pt_189:write(18911, [SendList])
    end,
    lib_server_send:send_to_uid(RoleId, Bin),
    {ok, Bin1} = pt_189:write(18909, [AutoId, RewardType, ShippingType, ?SUCCESS, Reward]),
    lib_server_send:send_to_uid(RoleId, Bin1),
    if
        NeedSave == true ->
            lib_sea_treasure:save_to_map([{Key, NewInfo}], Map);
        true ->
            Map
    end.

%========================================================
%% 巡航机器人创建
%========================================================
do_create_shipping_info(0, _, _, _, _, NewShippingList, NewShipList) -> {NewShippingList, NewShipList};
do_create_shipping_info(Num, ServerId, ServerNum, Wlv, Nowtime, ShippingList, ShipList) ->
    ShippingType = lib_sea_treasure:calc_robot_shipping_id(),
    AutoId = mod_id_create:get_new_id(?SHIPPING_ID_CREATE),
    #base_sea_treasure_reward{need_time = NeedTime} = data_sea_treasure:get_reward_info(ShippingType),
    EndTime = Nowtime + NeedTime,
    EndRef = util:send_after(undefined, NeedTime*1000, self(), {'time_to_get_reward', ServerId, AutoId}),
    {Lv, Name, Power, Career, Sex, Turn} = lib_sea_treasure:get_fake_base_info(Wlv),

    NewArg = [ShippingType, AutoId, ServerId, ServerNum, 0, <<"">>, 0, Name, Lv,
        Power, Career, Sex, Turn, <<"">>, 0, EndTime, EndRef, Wlv],
    case lib_sea_treasure:make_record(shipping_info, NewArg) of
        ShipInfo when is_record(ShipInfo, shipping_info) ->
            NewShipList = [ShipInfo|ShipList],
            NewShippingList = lists:keystore(AutoId, #shipping_info.auto_id, ShippingList, ShipInfo);
        _ ->
            NewShipList = ShipList,
            NewShippingList = ShippingList
    end,
    do_create_shipping_info(Num - 1, ServerId, ServerNum, Wlv, Nowtime, NewShippingList, NewShipList).

%========================================================
%% 玩家掠夺日志更新/删除
%========================================================
handle_log_map(LogMap, RbackMap, [], DeleteAidList) -> {LogMap, RbackMap, DeleteAidList};
handle_log_map(LogMap, RbackMap, [{RoleId, _Log}|SaveLogL], DeleteAutoIdL) ->
    LogList = maps:get(RoleId, LogMap, []),
    SortList = lists:reverse(lists:keysort(#treasure_log.time, LogList)),
    Length = ?treasure_log_length,
    SortListLength = erlang:length(SortList),
    if
        SortListLength >= Length ->
            {RealLogList, NeedHandL} = lists:split(Length, SortList);
        true ->
            RealLogList = SortList, NeedHandL = []
    end,
    Fun = fun(L, {Acc, Acc1, AccMap, Acc2}) ->
        #treasure_log{
            auto_id = AutoId, reward = RobReward, rober_serid = RoberSerId,
            back_reward = BackReward, recieve_reward = RecvReward
        } = L,
        GetReward = lib_sea_treasure:calc_get_reward(RobReward, BackReward),
        if
            GetReward =/= [] ->
                {[L|Acc], Acc1, AccMap, Acc2};
            RecvReward =/= [] ->
                {[L|Acc], Acc1, AccMap, Acc2};
            true ->
                NewAcc1 = case lists:keyfind(RoberSerId, 1, Acc1) of
                    {_, DeleteAuidList} ->
                        lists:keystore(RoberSerId, 1, Acc1, {RoberSerId, [AutoId|DeleteAuidList]});
                    _ ->
                        lists:keystore(RoberSerId, 1, Acc1, {RoberSerId, [AutoId]})
                end,
                {Acc, NewAcc1, maps:remove(AutoId, AccMap), [AutoId|Acc2]}
        end
    end,
    {SaveList, DeleteAidList, NewRbackMap, DbList} = lists:foldl(Fun, {RealLogList, DeleteAutoIdL, RbackMap, []}, NeedHandL),
    lib_sea_treasure:usql_handle_delete(sea_treasure_rback, auto_id, DbList),
    lib_sea_treasure:usql_handle_delete(sea_treasure_log, auto_id, DbList),
    NewLogList = lists:reverse(SaveList),
    NewMap = maps:put(RoleId, NewLogList, LogMap),
    %% 同步协助信息
    if
        DbList =/= [] ->
            mod_guild_assist:del_assist_by_target_list(?ASSIST_TYPE_3, DbList);
        true ->
            skip
    end,
    handle_log_map(NewMap, NewRbackMap, SaveLogL, DeleteAidList).

%========================================================
%% 掠夺日志更新
%% @param SelfSerLogList 发送服的belog_map数据
%========================================================
do_update_log_map(LogMap, SelfSerLogList, UpList) ->
    Fun = fun({AutoId, RoleId, _, RoberId}, {AccMap, Acc}) ->
        case lists:keyfind(RoberId, #role_shipping_info.role_id, UpList) of
            #role_shipping_info{
                guild_id = GuildId, guild_name = GuildName,
                role_name = RoleName, power = Power
            } ->
                LogList = maps:get(RoleId, AccMap, []),
                case lists:keyfind(AutoId, #treasure_log.auto_id, LogList) of
                    #treasure_log{
                        rober_gid = OldGId, rober_gname = OldGName,
                        rober_name = OldName, rober_power = OldPower
                    } = Log ->
                        NewGId = calc_new_role_info(OldGId, GuildId),
                        NewGName = calc_new_role_info(OldGName, GuildName),
                        NewName = calc_new_role_info(OldName, RoleName),
                        NewPower = calc_new_role_info(OldPower, Power),
                        NewLog = Log#treasure_log{
                            rober_gid = NewGId, rober_gname = NewGName,
                            rober_name = NewName, rober_power = NewPower
                        },
                        %% 更新数据库
                        Sql1 = io_lib:format(?sql_update_treasure_log_role,
                            [NewGId, util:term_to_bitstring(NewGName),
                            util:term_to_bitstring(NewName), NewPower, AutoId]),
                        db:execute(Sql1),
                        NewAccMap = lib_sea_treasure:save_to_map([{RoleId, NewLog}], AccMap),
                        NewAcc = case lists:keyfind(RoleId, 1, Acc) of
                            {RoleId, RoleLogList} ->
                                lists:keystore(RoleId, 1, Acc, {RoleId, [NewLog|RoleLogList]});
                            _ ->
                                lists:keystore(RoleId, 1, Acc, {RoleId, [NewLog]})
                        end,
                        {NewAccMap, NewAcc};
                    _ -> {AccMap, Acc}
                end;
            _ -> {AccMap, Acc}
        end
    end,
    {NewLogMap, RoleLogInfoList} = lists:foldl(Fun, {LogMap, []}, SelfSerLogList),
    [begin
        SendList = lib_sea_treasure:construct_list_data_to_client(TemLogList),
        {ok, Bin} = pt_189:write(18901, [SendList]),
        lib_server_send:send_to_uid(RoleId, Bin)
    end ||{RoleId, TemLogList} <- RoleLogInfoList],
    NewLogMap.

%========================================================
%% 巡航数据修复，服务器开启时检测
%========================================================
do_repair_shipping_map(ServerId, ShippingMap) ->
    ShippingList = maps:get(ServerId, ShippingMap, []),
    Nowtime = utime:unixtime(),
    Fun = fun(Ship, Acc) ->
        #shipping_info{
            role_id = RoleId,
            auto_id = AutoId, end_ref = OldRef, end_time = EndTime, has_recieve = HasRecv
        } = Ship,
        if
            EndTime < Nowtime andalso HasRecv == ?UNACHIEVE_SHIPPING_REWARD ->
                NewHasRecv = ?ACHIEVE_SHIPPING_REWARD,
                NewShip = Ship#shipping_info{has_recieve = NewHasRecv, end_ref = undefined},
                util:cancel_timer(OldRef),
                Sql = io_lib:format(?sql_update_shipping_role_recieve, [NewHasRecv, AutoId]),
                db:execute(Sql),
                [NewShip|Acc];
            (HasRecv == ?ACHIEVE_SHIPPING_REWARD andalso RoleId == 0) orelse HasRecv == ?RECIEVE_SHIPPING_REWARD ->
                Sql = io_lib:format(?sql_delete_treasure_shipping, [AutoId]),
                db:execute(Sql),
                Acc;
            true ->
                [Ship|Acc]
        end
    end,
    NewShippingList = lists:foldl(Fun, [], ShippingList),
    NewShippingMap = maps:put(ServerId, NewShippingList, ShippingMap),
    NewShippingMap.

clear_robot_data([], _, Acc) -> Acc;
clear_robot_data([Ship|ShippingList], Nowtime, Acc) when is_record(Ship, shipping_info) ->
    #shipping_info{end_time = Endtime, role_id = RoleId} = Ship,
    if
        RoleId == 0 andalso Endtime =< Nowtime ->
            Acc;
        true ->
            clear_robot_data(ShippingList, Nowtime, [Ship|Acc])
    end;
clear_robot_data([_|ShippingList], Nowtime, Acc) ->
    clear_robot_data(ShippingList, Nowtime, Acc).

% time_test(Nowtime, Zore, Acc) ->
%     % TimeList = data_sea_treasure:get_sea_treasure_value(robot_refresh),
%     case utime:is_same_day(Nowtime, Zore) of
%         true ->
%             case lib_sea_treasure:calc_robot_refresh_time(Nowtime+61) of
%                 {true, NextRefreshT} ->
%                     NewAcc = [NextRefreshT|Acc],
%                     time_test(Nowtime+15*60, Zore, NewAcc);
%                 _ ->
%                     ?MYLOG("xlh_time","time_list:~p~n",[Acc])
%             end;
%         _ ->
%             ?MYLOG("xlh_time","time_list:~p~n",[Acc])
%     end.

do_make_send_role_info(_, [], Acc) -> Acc;
do_make_send_role_info([], _, Acc) -> Acc;
do_make_send_role_info([{_, _SerRoleId, SerId, RoleId}|BelogList], UpList, Acc) ->
    NewAcc =
    case lists:keyfind(RoleId, #role_shipping_info.role_id, UpList) of
        #role_shipping_info{} = RoleInfo ->
            List = maps:get(SerId, Acc, []),
            NewList = lists:keystore(RoleId, #role_shipping_info.role_id, List, RoleInfo),
            maps:put(SerId, NewList, Acc);
        _ ->
            Acc
    end,
    do_make_send_role_info(BelogList, UpList, NewAcc).
