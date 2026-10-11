%%%--------------------------------------
%%% @Module  : lib_perfect_lover
%%% @Author  : huyihao
%%% @Created : 2018.03.15
%%% @Description:  完美情人
%%%--------------------------------------
-module(lib_perfect_lover).
 
-include("server.hrl").
-include("figure.hrl").
-include("errcode.hrl").
-include("common.hrl").
-include("def_module.hrl").
-include("custom_act.hrl").
-include("perfect_lover.hrl").
-include("language.hrl").

-export([
    update_perfect_times_info/4,
    check_wedding_times/2,
    sql_perfect_lover/4,
    %open_perfect_lover/1,
    pl_send_mail/3
    ]).

update_perfect_times_info(RoleId, LoverRoleId, WeddingType, WeddingTimesList) ->
    case lists:keyfind(RoleId, #wedding_times_info.role_id, WeddingTimesList) of
        false ->
            NewLoverInfo = #wedding_times_lover_info{
                role_id = RoleId,
                lover_role_id = LoverRoleId,
                times_list = [{WeddingType, 1}]
            },
            NewWeddingTimesInfo = #wedding_times_info{
                role_id = RoleId,
                lover_list = [NewLoverInfo]
            },
            IfReward = false;
        WeddingTimesInfo ->
            #wedding_times_info{
                lover_list = LoverList
            } = WeddingTimesInfo,
            case lists:keyfind(LoverRoleId, #wedding_times_lover_info.lover_role_id, LoverList) of
                false ->
                    NewLoverInfo = #wedding_times_lover_info{
                        role_id = RoleId,
                        lover_role_id = LoverRoleId,
                        times_list = [{WeddingType, 1}]
                    },
                    IfReward = false;
                LoverInfo ->
                    #wedding_times_lover_info{
                        times_list = TimesList
                    } = LoverInfo,
                    case lists:keyfind(WeddingType, 1, TimesList) of
                        false ->
                            NewTimesList = [{WeddingType, 1}|TimesList],
                            %WeddingDIdList = data_wedding:get_wedding_designation_id_list(),
                            WeddingTypeList = data_marriage:get_wedding_type_list(),
                            WeddingTypeNum = length(WeddingTypeList),
                            %% 和本伴侣举行了本次婚礼刚好与同一人举行完所有类型的婚礼
                            case length(NewTimesList) =:= WeddingTypeNum of
                                true ->
                                    CheckLoverList = lists:delete(LoverInfo, LoverList),
                                    %% 排除本次婚礼的对象与其他人举行的婚礼是否已举行完所有婚礼
                                    case check_wedding_times(CheckLoverList, WeddingTypeNum) of
                                        true ->
                                            IfReward = false;
                                        false ->
                                            IfReward = true
                                    end;
                                false ->
                                    IfReward = false
                            end;
                        {_, WeddingTimes} ->
                            NewTimesList = lists:keyreplace(WeddingType, 1, TimesList, {WeddingType, WeddingTimes+1}),
                            IfReward = false
                    end,
                    NewLoverInfo = LoverInfo#wedding_times_lover_info{
                        times_list = NewTimesList
                    }
            end,
            NewLoverList = lists:keystore(LoverRoleId, #wedding_times_lover_info.lover_role_id, LoverList, NewLoverInfo),
            NewWeddingTimesInfo = WeddingTimesInfo#wedding_times_info{
                lover_list = NewLoverList
            }
    end,
    NewWeddingTimesList = lists:keystore(RoleId, #wedding_times_info.role_id, WeddingTimesList, NewWeddingTimesInfo),
    {IfReward, NewWeddingTimesList}.

%% 判断是否领取了奖励
check_wedding_times(List, WeddingTypeNum) ->
    AllTimesList = [TimesList ||#wedding_times_lover_info{times_list = TimesList} <- List],
    AllTimesListNew = util:combine_list(lists:flatten(AllTimesList)),
    case length(AllTimesListNew) >= WeddingTypeNum of
        false ->
            false;
        true ->
            true
    end.

sql_perfect_lover(RoleIdM, RoleIdW, WeddingType, Time) ->
    ReSql = io_lib:format(?InsertPerfectLoverSql, [RoleIdM, RoleIdW, WeddingType, Time]),
    db:execute(ReSql).

% open_perfect_lover(Argrs) ->
%     [SubType, RoleId, LoverRoleId, LoverName, IfGetReward, WeddingTimesSendList, WeddingLogList, SelfLogList] = Argrs,
%     F = fun({RoleIdM, RoleIdW, NowTime}, SendList1) ->
%         PsM = lib_offline_api:get_player_info(RoleIdM, all),
%         #player_status{
%             figure = FigureM
%         } = PsM,
%         #figure{
%             name = NameM
%         } = FigureM,
%         PsW = lib_offline_api:get_player_info(RoleIdW, all),
%         #player_status{
%             figure = FigureW
%         } = PsW,
%         #figure{
%             name = NameW
%         } = FigureW,
%         [{RoleIdM, util:make_sure_binary(NameM), RoleIdW, util:make_sure_binary(NameW), NowTime}|SendList1]
%     end,
%     WeddingLogSendList = lists:foldl(F, [], WeddingLogList),
%     SelfLogSendList = lists:foldl(F, [], SelfLogList),
%     lib_server_send:send_to_uid(RoleId, pt_331, 33115, [?SUCCESS, SubType, LoverRoleId, util:make_sure_binary(LoverName), IfGetReward, WeddingTimesSendList, WeddingLogSendList, SelfLogSendList]).

pl_send_mail(RoleId, LoverId, RewardList) ->
   %PsL = lib_offline_api:get_player_info(LoverId, all),
    #figure{name = LoverName} = lib_role:get_role_figure(LoverId),
    Title = ?LAN_MSG(?LAN_TITLE_PERFECT_LOVER),
    Content = utext:get(?LAN_CONTENT_PERFECT_LOVER, [LoverName]),
    lib_mail_api:send_sys_mail([RoleId], Title, Content, RewardList).