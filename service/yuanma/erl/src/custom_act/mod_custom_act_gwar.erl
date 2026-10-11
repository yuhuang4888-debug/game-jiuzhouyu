%%-----------------------------------------------------------------------------
%% @Module  :       mod_custom_act_gwar
%% @Author  :       Czc
%% @Email   :       389853407@qq.com
%% @Created :       2018-03-20
%% @Description:    公会争霸运营活动
%%-----------------------------------------------------------------------------
-module(mod_custom_act_gwar).

-include("custom_act.hrl").
-include("common.hrl").
-include("def_module.hrl").
-include("def_fun.hrl").
-include("activitycalen.hrl").
-include("guild.hrl").
-include("errcode.hrl").
-include("goods.hrl").

-export([start_link/0]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-compile([export_all]).

-record(custom_act_gwar, {
    status = 0,             %% 状态 0：未初始化 1 已完成初始化
    cut_time = 0,           %% 截止时间
    dominator_guild_id = 0,
    gmember_ids = #{}       %% 可领取奖励人员 role_id => {guild_id, position, reward_state}
    }).

-define(DOMINATOR_GUILD_ID, 1).
-define(DOMINATOR_ID, 2).

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

init([]) ->
    %NowTime = utime:unixtime(),
    GWarOpen = get_act_open_time_region(?MOD_GUILD_BATTLE, 0, 1),
    LastState = case lib_custom_act_api:get_open_custom_act_infos(?CUSTOM_ACT_TYPE_GWAR) of
        [#act_info{key = {_Type, SubType}}|_] ->
            case lib_custom_act_util:get_act_cfg_info(?CUSTOM_ACT_TYPE_GWAR, SubType) of
                #custom_act_cfg{condition = Condition} ->
                    case lib_custom_act_check:check_act_condtion([need_opday], Condition) of
                        [NeedOpday] when GWarOpen =/= false -> %% 超过指定开服天数才能领取奖励
                            %{H, M, S} = data_guild_war:get_cfg(open_time),
                            {{_SH, _SM}, {EH, EM}} = GWarOpen,
                            GWarCutTime = util:get_open_time() + (NeedOpday-1) * 86400 + EH * 3600 + EM * 60 + 0,
                            ListActGWar = db:get_all(io_lib:format(<<"select id, val from custom_act_gwar">>, [])),
                            ListMembers = db:get_all(io_lib:format(<<"select role_id, guild_id, position, reward_state from custom_act_gwar_members">>, [])),
                            State = init_act_guild_members(ListMembers, #custom_act_gwar{cut_time = GWarCutTime}),
                            NewState = init_act_dominator_info(ListActGWar, State),
                            %?PRINT("init ~p~n", [NewState]),
                            NewState;
                        _ -> #custom_act_gwar{}
                    end;
                _ -> #custom_act_gwar{}
            end;
        _ ->
            db:execute(<<"truncate table custom_act_gwar">>),
            db:execute(<<"truncate table custom_act_gwar_members">>),
            #custom_act_gwar{}
    end,
    {ok, LastState}.

init_act_dominator_info([], State) -> State;
init_act_dominator_info([[Key, Val]|L], State) ->
    NewState = case Key of
        ?DOMINATOR_GUILD_ID ->
            State#custom_act_gwar{status = 1, dominator_guild_id = Val};
        _ -> State
    end,
    init_act_dominator_info(L, NewState).

init_act_guild_members([], State) -> State;
init_act_guild_members([[RoleId, GuildId, Position, RewardState]|ListMembers], State) ->
    #custom_act_gwar{gmember_ids = GMemberIds} = State,
    init_act_guild_members(ListMembers, State#custom_act_gwar{gmember_ids = maps:put(RoleId, {GuildId, Position, RewardState}, GMemberIds)}).

guild_war_end(DominatorGuildId, EndTime) ->
    gen_server:cast(?MODULE, {'guild_war_end', DominatorGuildId, EndTime}).

reset_custom_act_gwar_finish(AllMemberMap) ->
    gen_server:cast(?MODULE, {'reset_custom_act_gwar_finish', AllMemberMap}).

send_reward_status(RoleId, ActInfo) ->
    gen_server:cast(?MODULE, {'send_reward_status', RoleId, ActInfo}).

receive_reward(RoleId, ActInfo, GradeId, Reward) ->
    gen_server:cast(?MODULE, {'receive_reward', RoleId, ActInfo, GradeId, Reward}).

act_end(ActInfo) -> 
    gen_server:cast(?MODULE, {'act_end', ActInfo}).

gm_act_end() ->
    gen_server:cast(?MODULE, {'act_end', #act_info{key = {27,1}}}).

%% =================================================== 已不用 ===========================================================
update_join_list(RoleId) ->
    gen_server:cast(?MODULE, {'update_join_list', RoleId}).

update_dominator_info(DominatorId, DominatorGuildId, DominatorGuildMemberIds) ->
    gen_server:cast(?MODULE, {'update_dominator_info', DominatorId, DominatorGuildId, DominatorGuildMemberIds}).

join_guild(RoleId, _GuildId) ->
    gen_server:cast(?MODULE, {'join_guild', RoleId}).

quit_guild(RoleId, _GuildId) ->
    gen_server:cast(?MODULE, {'quit_guild', RoleId}).

change_guild_position(RoleId, GuildId) ->
    gen_server:cast(?MODULE, {'change_guild_position', RoleId, GuildId}).

check_receive_reward(RoleId, GuildId, GradeId) ->
    gen_server:call(?MODULE, {'check_receive_reward', RoleId, GuildId, GradeId}, 1000).
%% ========================================================================================================================

handle_cast(Msg, State) ->
    case catch do_handle_cast(Msg, State) of
        {ok, NewState} ->
            {noreply, NewState};
        Err ->
            util:errlog("handle_cast Msg:~p error:~p~n", [Msg, Err]),
            {noreply, State}
    end.

do_handle_cast({'guild_war_end', DominatorGuildId, EndTime}, State) ->
    case lib_custom_act_api:get_open_custom_act_infos(?CUSTOM_ACT_TYPE_GWAR) of
        [#act_info{key = {_Type, SubType}}|_] ->
            case check_custom_act_gwar_open(SubType) of
                true ->
                    %?PRINT("guild_war_end reset ~n", []),
                    NewState = reset_custom_act_gwar(DominatorGuildId, EndTime);
                _ -> NewState = State
            end;
        _ -> NewState = State
    end,
    {ok, NewState};

do_handle_cast({'reset_custom_act_gwar_finish', AllMemberMap}, State) ->
    NewState = State#custom_act_gwar{status = 1, gmember_ids = AllMemberMap},
    spawn(fun() -> notify_gwar_custom_act_info(AllMemberMap) end),
    spawn(fun() -> db_replace_all_members(AllMemberMap) end),
    %?PRINT("reset_custom_act_gwar_finish ~p~n", [NewState]),
    {ok, NewState};

do_handle_cast({'send_reward_status', RoleId, ActInfo}, State) ->
    #custom_act_gwar{dominator_guild_id = DominatorGuildId, gmember_ids = GMemberIds} = State,
    #act_info{ key = {_Type, SubType}} = ActInfo,
    GradeIds = lib_custom_act_util:get_act_reward_grade_list(?CUSTOM_ACT_TYPE_GWAR, SubType),
    {RoleGuildId, RolePosition, RoleRewardState} = maps:get(RoleId, GMemberIds, {0,0,0}),
    F = fun(GradeId, List) ->
        case lib_custom_act_util:get_act_reward_cfg_info(?CUSTOM_ACT_TYPE_GWAR, SubType, GradeId) of
            #custom_act_reward_cfg{name = Name, desc = Desc, condition = RewardCondition, format = Format, reward = Reward} ->
                ConditionStr = util:term_to_string(RewardCondition),
                RewardStr = util:term_to_string(Reward),
                CanGetReward = check_receive_reward(DominatorGuildId, GradeId, RoleGuildId, RolePosition),
                if
                    CanGetReward == true andalso RoleRewardState == 0 -> Status = ?ACT_REWARD_CAN_GET;
                    CanGetReward == true -> Status = ?ACT_REWARD_HAS_GET;
                    true -> Status = ?ACT_REWARD_CAN_NOT_GET
                end,   
                [{GradeId, Format, Status, 0, Name, Desc, ConditionStr, RewardStr} | List];
            _ -> List
        end
    end,
    SendList = lists:foldl(F, [], GradeIds),
    %?PRINT("send_reward_status ~p~n", [SendList]),
    lib_server_send:send_to_uid(RoleId, pt_331, 33104, [?CUSTOM_ACT_TYPE_GWAR, SubType, lists:reverse(SendList)]),
    {ok, State};

do_handle_cast({'receive_reward', RoleId, ActInfo, GradeId, Reward}, State) ->
    #custom_act_gwar{dominator_guild_id = DominatorGuildId, gmember_ids = GMemberIds} = State,
    #act_info{ key = {_Type, SubType}} = ActInfo,
    IsOpen = check_custom_act_gwar_open(SubType),
    {RoleGuildId, RolePosition, RoleRewardState} = maps:get(RoleId, GMemberIds, {0,0,0}),
    CanGetReward = check_receive_reward(DominatorGuildId, GradeId, RoleGuildId, RolePosition),
    if
        IsOpen == true andalso CanGetReward == true andalso RoleRewardState == 0 -> Status = ?ACT_REWARD_CAN_GET;
        CanGetReward == true -> Status = ?ACT_REWARD_HAS_GET;
        true -> Status = ?ACT_REWARD_CAN_NOT_GET
    end, 
    ?PRINT("receive_reward Status ~p~n", [Status]),
    case Status == ?ACT_REWARD_CAN_GET of 
        true ->
            lib_log_api:log_custom_act_gwar(RoleId, GradeId, Reward),
            lib_log_api:log_custom_act_reward(RoleId, _Type, SubType, GradeId, Reward),
            ?PRINT("receive_reward ~p~n", [Reward]),
            NewGMemberIds = maps:put(RoleId, {RoleGuildId, RolePosition, 1}, GMemberIds),
            Produce = #produce{type = custom_act_gwar, reward = Reward},
            lib_goods_api:send_reward_with_mail(RoleId, Produce),
            Sql = usql:replace(custom_act_gwar_members, [role_id, guild_id, position, reward_state], [[RoleId, RoleGuildId, RolePosition, 1]]),
            db:execute(Sql),
            lib_server_send:send_to_uid(RoleId, pt_331, 33105, [?SUCCESS, ?CUSTOM_ACT_TYPE_GWAR, SubType, GradeId]),
            NewState = State#custom_act_gwar{gmember_ids = NewGMemberIds};
        _ -> NewState = State
    end,
    {ok, NewState};

do_handle_cast({'act_end', ActInfo}, State) ->
    #custom_act_gwar{dominator_guild_id = DominatorGuildId, gmember_ids = GMemberIds} = State,
    #act_info{ key = {_Type, SubType}} = ActInfo,
    Fun = fun(RoleGuildId, RolePosition) -> 
        if 
            RoleGuildId == DominatorGuildId andalso RolePosition == ?POS_CHIEF -> 1;
            RoleGuildId == DominatorGuildId andalso RolePosition == ?POS_DUPTY_CHIEF -> 3;
            RoleGuildId == DominatorGuildId -> 3;
            RolePosition == ?POS_CHIEF -> 4;
            true -> 5
        end
    end,
    FunSendMail = fun(MailList) ->   
        FunSendMailDo = fun({RoleId, GuildId, Reward}, SendNum) ->
            case get({guild_name, GuildId}) of 
                undefined -> 
                    case catch mod_guild:get_guild_name(GuildId) of 
                        GuildName when is_list(GuildName);is_binary(GuildName) -> ok; _ -> GuildName = "???"
                    end,
                    put({guild_name, GuildId}, GuildName);
                GuildName -> ok
            end,
            case GuildId == DominatorGuildId of 
                true ->
                    Title = utext:get(3310033), Content = utext:get(3310034, [GuildName]);
                _ ->
                    Title = utext:get(3310033), Content = utext:get(3310035, [GuildName])
            end,
            lib_mail_api:send_sys_mail([RoleId], Title, Content, Reward),
            case SendNum > 30 of 
                true -> timer:sleep(1000), 0;
                _ -> SendNum+1
            end
        end,
        lists:foldl(FunSendMailDo, 0, MailList)
    end,
    F = fun(RoleId, {GuildId, Position, RewardState}, {List, SqlArgs, Map}) ->
        case RewardState == 0 of 
            true ->
                GradeId = Fun(GuildId, Position),
                RewardCfg = lib_custom_act_util:get_act_reward_cfg_info(?CUSTOM_ACT_TYPE_GWAR, SubType, GradeId),
                Reward = lib_custom_act_util:count_act_reward(RoleId, ActInfo, RewardCfg),
                {[{RoleId, GuildId, Reward}|List], [[RoleId, GuildId, Position, 1]|SqlArgs], maps:put(RoleId, {GuildId, Position, 1}, Map)};
            _ -> {List, SqlArgs, Map}
        end
    end,
    {MailList, SqlArgsList, NewGMemberIds} = maps:fold(F, {[], [], GMemberIds}, GMemberIds),
    case length(SqlArgsList) > 0 of 
        true ->
            Sql = usql:replace(custom_act_gwar_members, [role_id, guild_id, position, reward_state], SqlArgsList),
            db:execute(Sql),
            spawn(fun() -> FunSendMail(MailList) end),
            ok;
        _ ->
            ok
    end,
    %?PRINT("ACT END ~p~n", [MailList]),
    {ok, State#custom_act_gwar{gmember_ids = NewGMemberIds}};

% do_handle_cast({'update_join_list', RoleId}, State) ->
%     NewState = case lib_custom_act_api:get_open_custom_act_infos(?CUSTOM_ACT_TYPE_GWAR) of
%         [#act_info{key = {_Type, SubType}}|_] ->
%             case lib_custom_act_util:get_act_cfg_info(?CUSTOM_ACT_TYPE_GWAR, SubType) of
%                 #custom_act_cfg{condition = Condition} ->
%                     OpDay = util:get_open_day(),
%                     case lib_custom_act_check:check_act_condtion([need_opday], Condition) of
%                         [NeedOpday] when OpDay >= NeedOpday ->
%                             #custom_act_gwar{join_list = JoinList} = State,
%                             case lists:member(RoleId, JoinList) of
%                                 false ->
%                                     % ?ERR("RoleIds:~p", [[RoleId|JoinList]]),
%                                     State#custom_act_gwar{join_list = [RoleId|JoinList]};
%                                 _ -> State
%                             end;
%                         _ -> State
%                     end;
%                 _ -> State
%             end;
%         _ -> State
%     end,
%     {ok, NewState};

% do_handle_cast({'update_dominator_info', DominatorId, DominatorGuildId, DominatorGuildMemberIds}, State) ->
%     NewState = case lib_custom_act_api:get_open_custom_act_infos(?CUSTOM_ACT_TYPE_GWAR) of
%         [#act_info{key = {_Type, SubType}}|_] ->
%             case lib_custom_act_util:get_act_cfg_info(?CUSTOM_ACT_TYPE_GWAR, SubType) of
%                 #custom_act_cfg{condition = Condition} ->
%                     OpDay = util:get_open_day(),
%                     case lib_custom_act_check:check_act_condtion([need_opday], Condition) of
%                         [NeedOpday] when OpDay >= NeedOpday ->
%                             % ?ERR("DominatorGuildMemberIds:~p", [DominatorGuildMemberIds]),
%                             Sql = usql:replace(custom_act_gwar, [id, val], [[?DOMINATOR_GUILD_ID, DominatorGuildId], [?DOMINATOR_ID, DominatorId]]),
%                             db:execute(Sql),
%                             spawn(fun() ->
%                                 notify_gwar_custom_act_info(DominatorGuildMemberIds ++ State#custom_act_gwar.join_list)
%                             end),
%                             State#custom_act_gwar{gmember_ids = DominatorGuildMemberIds, dominator_guild_id = DominatorGuildId, dominator_id = DominatorId};
%                         _ -> State
%                     end;
%                 _ -> State
%             end;
%         _ -> State
%     end,
%     {ok, NewState};

% do_handle_cast({'join_guild', RoleId}, State) ->
%     case lib_custom_act_api:get_open_custom_act_infos(?CUSTOM_ACT_TYPE_GWAR) of
%         [#act_info{key = {_Type, SubType}}|_] ->
%             case lib_custom_act_util:get_act_cfg_info(?CUSTOM_ACT_TYPE_GWAR, SubType) of
%                 #custom_act_cfg{condition = Condition} ->
%                     OpDay = util:get_open_day(),
%                     case lib_custom_act_check:check_act_condtion([need_opday], Condition) of
%                         [NeedOpday] when OpDay >= NeedOpday ->
%                             #custom_act_gwar{join_list = JoinList, gmember_ids = GuildMemberIds} = State,
%                             %% 如果玩家是活动的参与者更新客户端状态
%                             case lists:member(RoleId, GuildMemberIds ++ JoinList) of
%                                 true ->
%                                     {ok, BinData} = pt_331:write(33118, [?CUSTOM_ACT_TYPE_GWAR, SubType]),
%                                     lib_server_send:send_to_uid(RoleId, BinData);
%                                 _ -> skip
%                             end;
%                         _ -> skip
%                     end;
%                 _ -> skip
%             end;
%         _ -> skip
%     end,
%     {ok, State};

% do_handle_cast({'quit_guild', RoleId}, State) ->
%     case lib_custom_act_api:get_open_custom_act_infos(?CUSTOM_ACT_TYPE_GWAR) of
%         [#act_info{key = {_Type, SubType}}|_] ->
%             case lib_custom_act_util:get_act_cfg_info(?CUSTOM_ACT_TYPE_GWAR, SubType) of
%                 #custom_act_cfg{condition = Condition} ->
%                     OpDay = util:get_open_day(),
%                     case lib_custom_act_check:check_act_condtion([need_opday], Condition) of
%                         [NeedOpday] when OpDay >= NeedOpday ->
%                             #custom_act_gwar{join_list = JoinList, gmember_ids = GuildMemberIds} = State,
%                             %% 如果玩家是活动的参与者更新客户端状态
%                             case lists:member(RoleId, GuildMemberIds ++ JoinList) of
%                                 true ->
%                                     {ok, BinData} = pt_331:write(33118, [?CUSTOM_ACT_TYPE_GWAR, SubType]),
%                                     lib_server_send:send_to_uid(RoleId, BinData);
%                                 _ -> skip
%                             end;
%                         _ -> skip
%                     end;
%                 _ -> skip
%             end;
%         _ -> skip
%     end,
%     {ok, State};

% do_handle_cast({'change_guild_position', RoleId, GuildId}, State) ->
%     case lib_custom_act_api:get_open_custom_act_infos(?CUSTOM_ACT_TYPE_GWAR) of
%         [#act_info{key = {_Type, SubType}}|_] ->
%             case lib_custom_act_util:get_act_cfg_info(?CUSTOM_ACT_TYPE_GWAR, SubType) of
%                 #custom_act_cfg{condition = Condition} ->
%                     OpDay = util:get_open_day(),
%                     case lib_custom_act_check:check_act_condtion([need_opday], Condition) of
%                         [NeedOpday] when OpDay >= NeedOpday ->
%                             #custom_act_gwar{dominator_guild_id = DominatorGuildId, dominator_id = DominatorId} = State,
%                             %% 如果是王者公会的会长职位发生变动，要通知客户端更新状态
%                             case RoleId == DominatorId andalso GuildId == DominatorGuildId of
%                                 true ->
%                                     {ok, BinData} = pt_331:write(33118, [?CUSTOM_ACT_TYPE_GWAR, SubType]),
%                                     lib_server_send:send_to_uid(RoleId, BinData);
%                                 _ -> skip
%                             end;
%                         _ -> skip
%                     end;
%                 _ -> skip
%             end;
%         _ -> skip
%     end,
%     {ok, State};

do_handle_cast(_Msg, State) -> {ok, State}.

handle_info(Info, State) ->
    case catch do_handle_info(Info, State) of
        {ok, NewState} ->
            {noreply, NewState};
        Err ->
            util:errlog("handle_info Info:~p error:~p~n", [Info, Err]),
            {noreply, State}
    end.

do_handle_info(_Info, State) -> {ok, State}.

handle_call(Request, _From, State) ->
    case catch do_handle_call(Request, State) of
        {ok, Reply} ->
            {reply, Reply, State};
        Err ->
            util:errlog("handle_call Request:~p error:~p~n", [Request, Err]),
            {noreply, State}
    end.

% do_handle_call({'check_receive_reward', RoleId, _GuildId, GradeId}, State) ->
%     #custom_act_gwar{
%         dominator_guild_id = DominatorGuildId,
%         gmember_ids = GMemberIds
%     } = State,
%     {RoleGuildId, RolePosition, RoleRewardState} = maps:get(RoleId, GMemberIds, {0,0,0}),
%     CanGetReward = check_receive_reward(DominatorGuildId, GradeId, RoleGuildId, RolePosition),
%     if
%         CanGetReward == true andalso RoleRewardState == 0 -> _Status = ?ACT_REWARD_CAN_GET;
%         CanGetReward == true -> _Status = ?ACT_REWARD_HAS_GET;
%         true -> _Status = ?ACT_REWARD_CAN_NOT_GET
%     end;

do_handle_call(_Request, _State) -> {ok, ok}.

terminate(_Reason, _State) ->
    ?ERR("~p is terminate:~p", [?MODULE, _Reason]),
    ok.

code_change(_OldVsn, State, _Extra) -> {ok, State}.


notify_gwar_custom_act_info(GMemberIds) ->
    case lib_custom_act_api:get_open_subtype_ids(?CUSTOM_ACT_TYPE_GWAR) of
        [Subtype|_] ->
            {ok, BinData} = pt_331:write(33118, [?CUSTOM_ACT_TYPE_GWAR, Subtype]),
            Fun = fun(RoleId, _, Acc) ->
                lib_server_send:send_to_uid(RoleId, BinData),
                case Acc > 20 of 
                    true -> timer:sleep(500), 0;
                    _ -> Acc+1
                end
            end,
            maps:fold(Fun, 0, GMemberIds);
        _ -> skip
    end.

check_receive_reward(0, _GradeId, _GuildId, _Position) -> false;
check_receive_reward(_DominatorGuildId, _GradeId, 0, _Position) -> false;
check_receive_reward(DominatorGuildId, GradeId, GuildId, Position) ->
    if
        GradeId == 1 -> %% 一档奖励只能王者公会会长领取
            case Position == ?POS_CHIEF andalso GuildId == DominatorGuildId of
                true -> true;
                false -> false
            end;
        GradeId == 2 -> %% 二挡奖励只能王者公会副会长
            case GuildId == DominatorGuildId andalso Position == ?POS_DUPTY_CHIEF of
                true -> true;
                false -> false
            end;
        GradeId == 3 -> %% 王者公会其他成员
            case GuildId == DominatorGuildId andalso Position =/= ?POS_CHIEF of
                true -> true;
                false -> false
            end;
        GradeId == 4 -> %% 其他公会会长
            case GuildId =/= DominatorGuildId andalso Position == ?POS_CHIEF of
                true -> true;
                false -> false
            end;
        GradeId == 5 -> %% 其他公会成员
            case GuildId =/= DominatorGuildId andalso Position =/= ?POS_CHIEF of
                true -> true;
                false -> false
            end;
        true -> false
    end.

check_custom_act_gwar_open(SubType) ->
    case lib_custom_act_util:get_act_cfg_info(?CUSTOM_ACT_TYPE_GWAR, SubType) of
        #custom_act_cfg{condition = Condition} ->
            OpDay = util:get_open_day(),
            case lib_custom_act_check:check_act_condtion([need_opday], Condition) of
                [NeedOpday] when OpDay == NeedOpday -> IsOpen = true;       
                _ -> IsOpen = false
            end;
        _ -> IsOpen = false
    end,
    IsOpen.

get_act_open_time_region(Module, ModuleSub, ActId) ->
    case data_activitycalen:get_ac(Module, ModuleSub, ActId) of 
        #base_ac{time_region = [{{SH, SM}, {EH, EM}}|_]} ->
            {{SH, SM}, {EH, EM}};
        _ -> false
    end.

reset_custom_act_gwar(DominatorGuildId, EndTime) ->
    mod_guild:apply_cast(?MODULE, get_guild_members, [EndTime]),
    Sql = usql:replace(custom_act_gwar, [id, val], [[?DOMINATOR_GUILD_ID, DominatorGuildId]]),
    db:execute(Sql),
    #custom_act_gwar{cut_time = EndTime, dominator_guild_id = DominatorGuildId}.

get_guild_members(EndTime) ->
    GuildMap = lib_guild_data:get_guild_map(),
    F = fun(GuildId, Map) ->
        GuildMemberMap = lib_guild_data:get_guild_member_map(GuildId),
        FI = fun(_, #guild_member{id = MemberId, position = Position, create_time = CreateTime}, MapI) ->
            ?IF(CreateTime =< EndTime, maps:put(MemberId, {GuildId, Position, 0}, MapI), MapI)
        end,
        maps:fold(FI, Map, GuildMemberMap)
    end,
    AllMemberMap = lists:foldl(F, #{}, maps:keys(GuildMap)),
    mod_custom_act_gwar:reset_custom_act_gwar_finish(AllMemberMap).

db_replace_all_members(AllMemberMap) ->
    F = fun(RoleId, {GuildId, Position, RewardState}, {Acc, SqlArgs}) ->
        case Acc >= 150 of 
            true ->
                Sql = usql:replace(custom_act_gwar_members, [role_id, guild_id, position, reward_state], [[RoleId, GuildId, Position, RewardState]|SqlArgs]),
                db:execute(Sql),
                timer:sleep(1000),
                {0, []};
            _ ->
                NewSqlArgs = [[RoleId, GuildId, Position, RewardState]|SqlArgs],
                {Acc+1, NewSqlArgs}
        end
    end,
    case maps:fold(F, {0, []}, AllMemberMap) of 
        {_, LeftList} when length(LeftList)>0 -> 
            Sql = usql:replace(custom_act_gwar_members, [role_id, guild_id, position, reward_state], LeftList),
            db:execute(Sql);
        _ -> ok
    end.

%% 这个接口在公会进程(已废弃)
sync_gwar_result(DominatorId, DominatorGuildId) ->
    DominatorGuildMemberIds = lib_guild_data:get_all_role_in_guild(DominatorGuildId),
    update_dominator_info(DominatorId, DominatorGuildId, DominatorGuildMemberIds).