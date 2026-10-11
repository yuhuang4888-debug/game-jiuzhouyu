%%-----------------------------------------------------------------------------
%% @Module  :       mod_guild_create_act.erl
%% @Author  :       J
%% @Email   :       j-som@foxmail.com
%% @Created :       2018-03-15
%% @Description:    勇者盟约
%%-----------------------------------------------------------------------------

-module (mod_guild_create_act).
-include ("common.hrl").
-include ("custom_act.hrl").
-include ("guild_create_act.hrl").
-include ("errcode.hrl").
-include ("goods.hrl").
-behaviour (gen_server).
-export ([init/1, handle_call/3, handle_cast/2, handle_info/2, code_change/3, terminate/2]).
-export ([
    start_link/0
    ,get_reward_status/1
    ,get_reward/3
]).

-record (state, {
    act_info = #act_info{},
    reward_infos = []
    }).

-define (SERVER, ?MODULE).
%% API
start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

get_reward_status(Args) ->
    gen_server:cast(?SERVER, {get_reward_status, Args}).
get_reward(ActId, GradeId, Args) ->
    gen_server:cast(?SERVER, {get_reward, ActId, GradeId, Args}).

%% private
init([]) ->
    {ok, []}.

handle_call(Msg, From, State) ->
    case catch do_handle_call(Msg, From, State) of
        {'EXIT', Error} ->
            ?ERR("handle_call error: ~p~nMsg=~p~n", [Error, Msg]),
            {reply, error, State};
        Return  ->
            Return
    end.


handle_cast(Msg, #state{act_info = #act_info{key = {_, ActId}}} = State0) ->
    State 
    = case lib_custom_act_api:get_open_custom_act_infos(?CUSTOM_ACT_TYPE_GUILD_CREAT) of
        [#act_info{key = {_, NewActId}} = NewInfo|_] when ActId =/= NewActId ->
            #state{act_info = NewInfo, reward_infos = []};
        [] when ActId > 0 ->
            #state{};
        _ ->
            State0
    end,
    case catch do_handle_cast(Msg, State) of
        {'EXIT', Error} ->
            ?ERR("handle_cast error: ~p~nMsg=~p~n", [Error, Msg]),
            {noreply, State};
        Return  ->
            Return
    end;

handle_cast(Msg, _) ->
    State = load(),
    handle_cast(Msg, State).

handle_info(Info, State) ->
    case catch do_handle_info(Info, State) of
        {'EXIT', Error} ->
            ?ERR("handle_info error: ~p~nInfo=~p~n", [Error, Info]),
            {noreply, State};
        Return  ->
            Return
    end.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

terminate(_Reason, _State) ->
    ok.

do_handle_call(_Msg, _From, State) ->
    {reply, ok, State}.

do_handle_cast({get_reward_status, Args}, State) ->
    #state{act_info = #act_info{key = {_, ActId}}, reward_infos = RewardInfos} = State,
    if
        ActId > 0 ->
            [RoleId, GuildId, PresidentId, MemCount, VicePresidentCount, GuildLv] = Args,
            Param 
            = #reward_check_param{
                guild_id = GuildId,
                role_id = RoleId,
                president_id = PresidentId,
                vice_president_count = VicePresidentCount,
                guild_lv = GuildLv,
                member_count = MemCount,
                global_info = RewardInfos
            },
            lib_custom_act:send_reward_status_direct(RoleId, ?CUSTOM_ACT_TYPE_GUILD_CREAT, ActId, {lib_guild_create_act, calc_reward_status, Param}, {lib_guild_create_act, calc_receive_times, RewardInfos});
        true ->
            skip
    end,
    {noreply, State};

do_handle_cast({get_reward, ActId, GradeId, Args}, #state{act_info = ActInfo, reward_infos = RewardInfos} = State) ->
    case ActInfo of
        #act_info{key = {_, ActId}} ->
            [RoleId, GuildId, PresidentId, MemCount, VicePresidentCount, GuildLv, RewardList] = Args,
            Param 
            = #reward_check_param{
                guild_id = GuildId,
                role_id = RoleId,
                president_id = PresidentId,
                vice_president_count = VicePresidentCount,
                guild_lv = GuildLv,
                member_count = MemCount,
                global_info = RewardInfos
            },
            case lib_custom_act_util:get_act_reward_cfg_info(?CUSTOM_ACT_TYPE_GUILD_CREAT, ActId, GradeId) of
                #custom_act_reward_cfg{condition = Conditions, name = TargetName} ->
                    case lib_guild_create_act:check_reward_conditions(GradeId, Conditions, Param) of
                        true ->
                            case lib_guild_create_act:reward_has_got(RewardInfos, RoleId, GuildId, GradeId) of
                                false ->
                                    ActName = lib_custom_act_util:get_act_name(?CUSTOM_ACT_TYPE_GUILD_CREAT, ActId),
                                    % TargetNameBin = util:make_sure_binary(TargetName),
                                    NewRewardInfos
                                    = case lists:keyfind(GradeId, 1, RewardInfos) of
                                        {GradeId, List} ->
                                            lists:keystore(GradeId, 1, RewardInfos, {GradeId, [{GuildId, RoleId}|List]});
                                        _ ->
                                            [{GradeId, [{GuildId, RoleId}]}|RewardInfos]
                                    end,
                                    SQL = io_lib:format("REPLACE INTO `guild_create_act_reward` (`act_id`, `reward_id`, `guild_id`, `role_id`, `time`) VALUE (~p, ~p, ~p, ~p, ~p)", [ActId, GradeId, GuildId, RoleId, utime:unixtime()]),
                                    db:execute(SQL),
                                    Produce = #produce{type = guild_create_act_reward, reward = RewardList, subtype = ActId, title = utext:get(3310009, [ActName]), content = utext:get(3310011, [TargetName])},
                                    lib_goods_api:send_reward_with_mail(RoleId, Produce),
                                    NewState = State#state{reward_infos = NewRewardInfos},
                                    do_handle_cast({get_reward_status, [RoleId, GuildId, PresidentId, MemCount, VicePresidentCount, GuildLv]}, NewState);
                                _ ->
                                    lib_custom_act:send_error_code(RoleId, ?ERRCODE(err331_already_get_reward)),
                                    {noreply, State}
                            end;
                        {false, Code} ->
                            lib_custom_act:send_error_code(RoleId, Code),
                            case Code =:= ?ERRCODE(err331_count_limit) of
                                true ->
                                    do_handle_cast({get_reward_status, [RoleId, GuildId, PresidentId, MemCount, VicePresidentCount, GuildLv]}, State);
                                _ ->
                                    {noreply, State}
                            end
                    end;
                _ ->
                    lib_custom_act:send_error_code(RoleId, ?FAIL),
                    {noreply, State}
            end;
        _ ->
            [RoleId|_] = Args,
            lib_custom_act:send_error_code(RoleId, ?ERRCODE(err331_act_closed)),
            {noreply, State}
    end;


do_handle_cast(_Msg, State) ->
    {noreply, State}.

do_handle_info(_Msg, State) ->
    {noreply, State}.

%% internal

load() ->
    case lib_custom_act_api:get_open_custom_act_infos(?CUSTOM_ACT_TYPE_GUILD_CREAT) of
        [#act_info{key = {_, ASubtype}, stime = Stime, etime = Etime} = Info|_] ->
            SQL = io_lib:format("SELECT `reward_id`, `guild_id`, `role_id` FROM `guild_create_act_reward` WHERE `time` >= ~p AND `time` < ~p AND `act_id` = ~p", [Stime, Etime, ASubtype]),
            All = db:get_all(SQL),
            RewardInfos = init_rewards_by_db_data(All, []),
            #state{act_info = Info, reward_infos = RewardInfos};
        _ ->
            db:execute("TRUNCATE TABLE `guild_create_act_reward`"),
            #state{}
    end.

init_rewards_by_db_data([[RewardId, GuildId, RoleId]|T], Acc) ->
    case lists:keyfind(RewardId, 1, Acc) of
        {RewardId, List} ->
            NewAcc = lists:keystore(RewardId, 1, Acc, {RewardId, [{GuildId, RoleId}|List]});
        _ ->
            NewAcc = [{RewardId, [{GuildId, RoleId}]}|Acc]
    end,
    init_rewards_by_db_data(T, NewAcc);

init_rewards_by_db_data([], Acc) -> Acc.
