%%%--------------------------------------
%%% @Module  : lib_login_reward
%%% @Author  : hyh
%%% @Created : 2018.01.12
%%% @Description:  七天登录
%%%--------------------------------------
-module(lib_login_reward_merge).

-include("server.hrl").
-include("errcode.hrl").
-include("predefine.hrl").
-include("common.hrl").
-include("figure.hrl").
-include("scene.hrl").
-include("role.hrl").
-include("goods.hrl").
-include("def_module.hrl").
-include("def_goods.hrl").
-include("login_reward.hrl").


%% API
-compile(export_all).

%%  登录
login_reward_login(Ps) ->
    #player_status{
        id = RoleId,
        sid = Sid
    } = Ps,
    MergeDay = util:get_merge_day(),
    MaxMergeDayId = data_login_reward:get_max_day_id(),
    if
        MergeDay >= 1 andalso MergeDay =< MaxMergeDayId ->
            ReSql = io_lib:format(?SelectLoginRewardPlayerSqlMarge, [RoleId]),
            case db:get_row(ReSql) of
                [] ->
                    NewRewardStatus = init_reward_status(),
                    NewLoginReward = #login_reward{
                        reward_list = init_reward_status(),
                        create_time = utime:unixdate(),
                        login_day = 1      %%第一天登录
                        , last_login_time = utime:unixtime()   %%最后登录时间
                    };
                [_RewardStatus, CreateTime, OldLoginDay, OldTime] ->
                    LoginDay = get_login_day(OldLoginDay, OldTime, RoleId), %%第几天登录。
                    %%修正领取状态
                    RewardStatus = util:bitstring_to_term(_RewardStatus),
                    NewRewardStatus = update_login_reward_status(LoginDay, RewardStatus),
                    NewLoginReward = #login_reward{
                        reward_list = NewRewardStatus,
                        create_time = CreateTime,
                        login_day = LoginDay,
                        last_login_time = utime:unixtime()
                    }
            end,
            %%更新数据库
            save_to_db(NewLoginReward, RoleId),
            %%推送客户端
            MergeWlv = util:get_merge_wlv(),
            #login_reward{login_day = _Day} = NewLoginReward,
            {ok, Bin} = pt_175:write(17502, [?SUCCESS, _Day, MergeWlv, NewRewardStatus]),
            lib_server_send:send_to_sid(Sid, Bin),
            NewPs = Ps#player_status{
                login_merge_reward = NewLoginReward
            },
            NewPs;
        true ->
            Ps
    end.



%% -----------------------------------------------------------------
%% @desc     功能描述    0点更新状态
%% @param    参数
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
across_zero_helper(Ps) ->
    #player_status{
        id = RoleId,
        sid = Sid,
        login_merge_reward = OldLoginReward
    } = Ps,
    MergeDay = util:get_merge_day(),
    MaxMergeDayId = data_login_reward:get_max_day_id(),
    if
        MergeDay >= 1 andalso MergeDay =< MaxMergeDayId ->
            #login_reward{reward_list = OldRewardStatus, login_day = OldLoginDay, last_login_time = LastLoginTime} = OldLoginReward,
            LoginDay = get_login_day(OldLoginDay, LastLoginTime, RoleId), %%第几天登录。
            %%修正领取状态
            NewRewardStatus = update_login_reward_status(LoginDay, OldRewardStatus),
            NewLoginReward = OldLoginReward#login_reward{reward_list = NewRewardStatus, login_day = LoginDay, last_login_time = utime:unixtime()},
            %%更新数据库
            save_to_db(NewLoginReward, RoleId),
            %%    ?DEBUG("zero ~n", []),
            %%推送客户端
            MergeWlv = util:get_merge_wlv(),
            {ok, Bin} = pt_175:write(17502, [?SUCCESS, LoginDay, MergeWlv, NewRewardStatus]),
            lib_server_send:send_to_sid(Sid, Bin),
            NewPs = Ps#player_status{
                login_merge_reward = NewLoginReward
            },
            NewPs;
        true ->
            Ps
    end.



%%0点处理
across_zero(#player_status{id = RoleId}) ->
    lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_login_reward_merge, across_zero_helper, []).


%%奖励id  弃用
get_today_login_reward_id(_RoleId) ->
    1.


%%七天登录初始领取状态，默认第一天是可以领取的。
init_reward_status() ->
    %%	[{1, 1}, {2, 0}, {3, 0}, {4, 0}, {5, 0}, {6, 0}, {7, 0}],
    DayList = data_login_reward:get_login_merge_reward_day_list(),
    NotFirstDay = [{DayTmp, 0} || DayTmp <- DayList, DayTmp =/= 1],
    [{1, 1}] ++ NotFirstDay.




%% -----------------------------------------------------------------
%% @desc     功能描述  获取登录天数。
%% @param    参数      Day::integer  旧登录天数
%%                     RoleId::integer  玩家id
%%                     LastLoginTime ::integer() 上一次登录时间
%% @return   返回值    DayNum::integer()   天数。最大就返回8
%% @history  修改历史
%% -----------------------------------------------------------------
get_login_day(Day, LastLoginTime, _RoleId) ->
    case utime:unixdate() > utime:unixdate(LastLoginTime) of
        true ->
            Day + 1;
        false ->
            Day
    end.


%% -----------------------------------------------------------------
%% @desc     功能描述     更新领取状态 达到登录天数的，设置为1。
%% @param    参数         LoginDay::integer()  登录天数
%%                        RewardStatus::[{天数， 状态}]
%% @return   返回值       NewRewardStatus::list()   [{天数， 状态}]
%% @history  修改历史
%% -----------------------------------------------------------------
update_login_reward_status(LoginDay, RewardStatus) ->
    DayList = data_login_reward:get_login_merge_reward_day_list(),
    F = fun(DayTmp, AccList) ->
        case lists:keyfind(DayTmp, 1, RewardStatus) of
            {DayTmp, Status} = Reward ->
                NewReward =
                    case Status of %%本来状态
                        0 -> %%
                            if
                                LoginDay >= DayTmp -> %%   如果达到了次数
                                    {DayTmp, 1};      %%   可以领取
                                true ->
                                    {DayTmp, Status}  %%   还不能领取
                            end;
                        1 -> %%   可以领取
                            Reward;
                        2 -> %%   已经领取了
                            Reward
                    end,
                [NewReward | AccList];
            _ ->
                NewReward =
                    if
                        LoginDay >= DayTmp -> %%   如果达到了次数
                            {DayTmp, 1};      %%   可以领取
                        true ->
                            {DayTmp, 0}       %%   还不能领取
                    end,
                [NewReward | AccList]
        end
    end,
    NewRewardStatus = lists:keysort(1, lists:foldl(F, [], DayList)),
    NewRewardStatus.


%% -----------------------------------------------------------------
%% @desc     功能描述  同步到数据库，
%% @param    参数      LoginReward::#login_reward{}
%%                     RoleId::integer() 玩家角色id
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
save_to_db(LoginReward, RoleId) ->
    #login_reward{reward_list = RewardList, create_time = CreateTime, login_day = Day, last_login_time = Time} = LoginReward,
    ReSql = io_lib:format(?ReplaceLoginRewardPlayerSqlMarge, [RoleId, util:term_to_string(RewardList), CreateTime, Day, Time]),
    db:execute(ReSql).

%%重置领取状态
reset(#player_status{id = ROleId} = Status, Day) ->
    #player_status{login_merge_reward = LoginReward} = Status,
    NewLoginReward = LoginReward#login_reward{reward_list = update_login_reward_status(Day, init_reward_status()), login_day = Day},
    save_to_db(NewLoginReward, ROleId),
    {ok, Status#player_status{login_merge_reward = NewLoginReward}}.

%%获取奖励
get_reward_by_sex(Sex, DayId) ->
    MergeWlv = util:get_merge_wlv(),
    case data_login_reward:get_login_merge_reward_day_con(DayId, MergeWlv) of
        #login_merge_reward_day_con{reward_list = _Reward} ->
            get_reward_by_sex_helper(_Reward, Sex);
        _ ->
            []
    end.



get_reward_by_sex_helper([], _Sex) ->
    [];
get_reward_by_sex_helper([H | T], Sex) ->
    case H of
        {CfgSex, Reward} ->
            case CfgSex of
                Sex ->
                    Reward;
                _ ->
                    get_reward_by_sex_helper(T, Sex)
            end;
        _ ->
            []
    end.


gm_clear() ->
    Sql =  io_lib:format(<<"TRUNCATE   login_merge_reward_player">>, []),
    db:execute(Sql),
    OnlineList = ets:tab2list(?ETS_ONLINE),
    IdList = [PlayerId || #ets_online{id = PlayerId} <- OnlineList],
    [lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_login_reward_merge, login_reward_login, []) || RoleId <- IdList].




get_reward_by_career(Career, DayId) ->
    MergeWlv = util:get_merge_wlv(),
    case data_login_reward:get_login_merge_reward_day_con(DayId, MergeWlv) of
        #login_merge_reward_day_con{reward_list = _Reward} ->
            get_reward_by_career_helper(_Reward, Career);
        _ ->
            []
    end.


get_reward_by_career_helper([], _Career) ->
    [];
get_reward_by_career_helper([H | T], Career) ->
    %%    ?DEBUG("H ~p ~n", [H]),
    case H of
        {CfgCareer, Reward} ->
            case CfgCareer of
                Career ->
                    Reward;
                _ ->
                    get_reward_by_sex_helper(T, Career)
            end;
        _ ->
            []
    end.
