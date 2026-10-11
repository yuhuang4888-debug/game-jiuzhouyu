%% ---------------------------------------------------------------------------
%% @doc lib_star_trek

%% @author  lzh
%% @email   lu13824949032@gmail.com
%% @since   2020/1/3
%% @deprecated  
%% ---------------------------------------------------------------------------
-module(lib_star_trek).

%% API
-compile([export_all]).

-include("custom_act.hrl").
-include("server.hrl").
-include("common.hrl").
-include("errcode.hrl").
-include("goods.hrl").
-include("figure.hrl").
-include("def_fun.hrl").
-include("def_module.hrl").
-include("predefine.hrl").

-define(BOARD_STATUS,  1).   %% 登船
-define(ARRIVE_STATUS, 2).   %% 已到达
-define(NOOPEN_STATUS, 0).   %% 未开放

send_reward_status(Ps, #act_info{key = {Type, SubType}}) ->
    {NewPs, ActData} = get_act_data(Ps, Type, SubType),
    F = fun({GradeId, GStatus}, Acc) ->
        case lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GradeId) of
            #custom_act_reward_cfg{
                name = Name,
                desc = Desc,
                condition = Condition,
                format = Format,
                reward = Reward
            } ->
                [{GradeId, Format, GStatus, 0, Name, Desc, util:term_to_string(Condition), util:term_to_string(Reward)}|Acc];
            _ -> Acc
        end
        end,
    SendList = lists:foldl(F, [], ActData),
    lib_server_send:send_to_uid(NewPs#player_status.id, pt_331, 33104, [Type, SubType, SendList]),
    {ok, NewPs}.

receive_reward(Ps, Type, SubType, GradeId) ->
    #player_status{id = RoleId} = Ps,
    {NewPsTmp, ActData} = get_act_data(Ps, Type, SubType),
    case ulists:keyfind(GradeId, 1, ActData, false) of
        false -> lib_custom_act:send_error_code(RoleId, ?ERRCODE(err331_no_act_reward_cfg));
        {GradeId, ?ARRIVE_STATUS} -> lib_custom_act:send_error_code(RoleId, ?ERRCODE(err331_login_return_reward_has_buy));
        {GradeId, ?NOOPEN_STATUS} -> lib_custom_act:send_error_code(RoleId, ?ERRCODE(err331_can_not_recieve));
        {GradeId, ?BOARD_STATUS} ->
            #custom_act_reward_cfg{condition = Condition, reward = Rewards} = RewardCfg = lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GradeId),
            case lists:keyfind(cost, 1, Condition) of
                false -> lib_custom_act:send_error_code(RoleId, ?FAIL);
                {cost, Cost} ->
                    case lib_goods_api:cost_object_list_with_check(NewPsTmp, Cost, cost_star_trek, "") of
                        {false, ErrorCode, NewPsTmp1} -> lib_custom_act:send_error_code(RoleId, ErrorCode), {ok, NewPsTmp1};
                        {true, NewPsTmp2} ->
                            NewActData = lists:keystore(GradeId, 1, ActData, {GradeId, ?ARRIVE_STATUS}),
                            LastData = #custom_act_data{id = {Type, SubType}, type = Type, subtype = SubType, data = [{get_act_open_day(Type, SubType), NewActData}]},
                            NewPsTmp3 = lib_custom_act:save_act_data_to_player(NewPsTmp2, LastData),
                            Remark = lists:concat(["SubType:", SubType, "GradeId:", GradeId]),
                            Produce = #produce{type = star_trek_rewards, subtype = Type, remark = Remark, reward = Rewards, show_tips = ?SHOW_TIPS_1},
                            NewPs = lib_goods_api:send_reward(NewPsTmp3, Produce),
                            {ok, BinData} = pt_331:write(33105, [?SUCCESS, Type, SubType, GradeId]),
                            send_tv(NewPs, RewardCfg),
                            lib_log_api:log_custom_act_cost(RoleId, Type, SubType, Cost, [GradeId]),
                            lib_log_api:log_custom_act_reward(RoleId, Type, SubType, GradeId, Rewards),
                            lib_server_send:send_to_sid(NewPs#player_status.sid, BinData),
                            {ok, NewPs}
                    end
            end;
        _ -> lib_custom_act:send_error_code(RoleId, ?FAIL)
    end.

get_act_data(PS, Type, SubType) ->
    GradeIds = lib_custom_act_util:get_act_reward_grade_list(Type, SubType),
    OpenDay = get_act_open_day(Type, SubType),
    ?PRINT("act OpenDay ~p ~n", [OpenDay]),
    case lib_custom_act:act_data(PS, Type, SubType) of
        #custom_act_data{data = []} ->
            ResData =
                [begin
                     #custom_act_reward_cfg{condition = Condition} = lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GradeId),
                     {day, NeedDay} = ulists:keyfind(day, 1, Condition, {day, 1}),
                     GStatus = ?IF(OpenDay >= NeedDay, ?BOARD_STATUS, ?NOOPEN_STATUS),
                     {GradeId, GStatus}
                 end||GradeId <- GradeIds],
            ActData = #custom_act_data{id = {Type, SubType}, type = Type, subtype = SubType, data = [{OpenDay, ResData}]},
            NewPs = lib_custom_act:save_act_data_to_player(PS, ActData),
            {NewPs, ResData};
        #custom_act_data{data = [{Day, ResData}|_]} ->
            case OpenDay == Day of
                true -> {PS, ResData};
                _ ->
                    NewResData =
                        [begin
                             case GStatus == ?NOOPEN_STATUS of
                                 false -> {GradeId, GStatus};
                                 true ->
                                     case lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GradeId) of
                                         #custom_act_reward_cfg{condition = Condition} ->
                                             {day, NeedDay} = ulists:keyfind(day, 1, Condition, {day, 1}),
                                             GGStatus = ?IF(OpenDay >= NeedDay, ?BOARD_STATUS, ?NOOPEN_STATUS),
                                             {GradeId, GGStatus};
                                         _ -> {GradeId, GStatus}
                                     end
                             end
                         end||{GradeId, GStatus} <- ResData],
                    ActData = #custom_act_data{id = {Type, SubType}, type = Type, subtype = SubType, data = [{OpenDay, NewResData}]},
                    NewPs = lib_custom_act:save_act_data_to_player(PS, ActData),
                    {NewPs, NewResData}
            end;
        false ->
            ResData =
                [begin
                     #custom_act_reward_cfg{condition = Condition} = lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GradeId),
                     {day, NeedDay} = ulists:keyfind(day, 1, Condition, {day, 1}),
                     GStatus = ?IF(OpenDay >= NeedDay, ?BOARD_STATUS, ?NOOPEN_STATUS),
                     {GradeId, GStatus}
                 end||GradeId <- GradeIds],
            ActData = #custom_act_data{id = {Type, SubType}, type = Type, subtype = SubType, data = [{OpenDay, ResData}]},
            NewPs = lib_custom_act:save_act_data_to_player(PS, ActData),
            {NewPs, ResData}
    end.

get_act_open_day(Type, SubType) ->
    #custom_act_cfg{opday_lim = OpDayLimit, start_time = StartTime} = lib_custom_act_util:get_act_cfg_info(Type, SubType),
    [{BOpenDay, _}|_] = OpDayLimit,
    ServerOpenDay2 = util:get_open_day(StartTime),
    case ServerOpenDay2 >= BOpenDay of
        true -> utime:logic_diff_days(StartTime) + 1;
        false ->
            util:get_open_day() - BOpenDay + 1
    end.

act_end(#act_info{key = {Type, SubType}, etime = ETime}) ->
    case utime:unixtime() > ETime of
        true ->
            lib_custom_act:db_delete_custom_act_data(Type, SubType),
            OnlineRoles = ets:tab2list(?ETS_ONLINE),
            [lib_player:apply_cast(E#ets_online.id, ?APPLY_CAST_SAVE, lib_star_trek, clear_custom_info, [Type, SubType]) || E <- OnlineRoles];
        false -> skip
    end.

clear_custom_info(Ps, Type, SubType) ->
    LastData = #custom_act_data{id = {Type, SubType}, type = Type, subtype = SubType, data = []},
    NewPs = lib_custom_act:save_act_data_to_player(Ps, LastData),
    {ok, NewPs}.

send_tv(Ps, RewardCfg) ->
    #player_status{id = RoleId, figure = #figure{name = RoleName}} = Ps,
    #custom_act_reward_cfg{type = Type, subtype = SubType, name = RName} = RewardCfg,
    lib_chat:send_TV({all}, ?MOD_AC_CUSTOM, 56, [RoleName, RoleId, RName, Type, SubType]).

gm_clear_data(Type, SubType) ->
    lib_custom_act:db_delete_custom_act_data(Type, SubType),
    OnlineRoles = ets:tab2list(?ETS_ONLINE),
    [lib_player:apply_cast(E#ets_online.id, ?APPLY_CAST_SAVE, lib_star_trek, clear_custom_info, [Type, SubType]) || E <- OnlineRoles].

