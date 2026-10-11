%% ---------------------------------------------------------------------------
%% @doc lib_invite_api.erl

%% @author  hjh
%% @email  hejiahua@163.com
%% @since  2018-11-20
%% @deprecated 邀请接口
%% ---------------------------------------------------------------------------
-module(lib_invite_api).
-compile([export_all]).

-include("common.hrl").
-include("php.hrl").
-include("server.hrl").
-include("figure.hrl").
-include("invite.hrl").
-include("rec_event.hrl").
-include("def_event.hrl").

% %% 充值排行榜
% handle_event(Player, #event_callback{type_id = ?EVENT_RECHARGE,data = #callback_recharge_data{gold = AddGold}}) ->
%     upload_inivtee_recharge(Player, AddGold),
%     {ok, Player};

%% 发送公会邀请
handle_event(
        Player
        , #event_callback{type_id = ?EVENT_LV_UP}
        ) when is_record(Player, player_status) ->
    #player_status{figure = #figure{lv = Lv}} = Player,
    IsMember = lists:member(Lv, ?INVITE_KV_TRIGGER_LV_LIST),
    if
        IsMember -> 
            upload_inivtee_info(Player),
            request_update_invite_state(Player);
        true -> 
            skip
    end,
    {ok, Player};

handle_event(Player, _Ec) ->
    ?ERR("unkown event_callback:~p", [_Ec]),
    {ok, Player}.

%% test 
%%      lib_invite_api:upload_new_inivtee(1, 2, "2", "2", 1, 1, 1).
%%      lib_invite_api:upload_new_inivtee(1, 3, "3", "3", 1, 1, 1).
%%      lib_invite_api:upload_inivtee_info(3, "3333", 33, 333, 333).
%%      lib_invite_api:request_update_invite_state(1).

%% 上传新被邀请者到php
%% 上传参数={role_id, invitee_id, accname, name, lv, career, sex}
%% 返回=无论失败成功返回1
upload_new_inivtee(Player, InviteId) ->
    #player_status{id = InviteeId, accid = Accid, accname = Accname, figure = #figure{name = Name, lv = Lv, career = Career, sex = Sex}} = Player,
    upload_new_inivtee([], InviteId, InviteeId, Name, Accid, Accname, Lv, Career, Sex),
    ok.

%% @param Ids 本账号是否有其他角色
%% Accid, Accname 确定唯一账号
upload_new_inivtee(Ids, InviteId, InviteeId, Name, Accid, Accname, Lv, Career, Sex) when Ids == [], InviteId =/= InviteeId, InviteId > 0, InviteeId > 0 ->
    PostData = [
        {role_id, InviteId}, {invitee_id, InviteeId}, {name, Name}, {accid, Accid}, {accname, Accname}, 
        {lv, Lv}, {career, Career}, {sex, Sex}
        ],
    %?MYLOG("hjh", "InviteId:~p InviteeId:~p Lv:~p Career:~p, Sex:~p~n ", [InviteId, InviteeId, Lv, Career, Sex]),
    PhpRequest = #php_request{role_id = InviteeId, data = upload_new_inivtee},
    % 上传数据
    lib_php_api:request(role_invite, PostData, PhpRequest),
    % 下载数据
    request_update_invite_state(InviteeId),
    % % 设置成被邀请者,需要上传数据
    % mod_invite:set_new_inivtee(InviteeId),
    ok;
upload_new_inivtee(_Ids, _InviteId, _InviteeId, _Name, _Accid, _Accname, _Lv, _Career, _Sex) ->
    ok.

%% 上传被邀请者信息到php,只更新数据,没有就不处理
%% 上传参数={invitee_id, name, lv, career, sex}
%% 返回=无论失败成功返回1
upload_inivtee_info(Player) ->
    #player_status{id = InviteeId, figure = #figure{name = Name, lv = Lv, career = Career, sex = Sex}} = Player,
    upload_inivtee_info(InviteeId, Name, Lv, Career, Sex),
    ok.

upload_inivtee_info(InviteeId, Name, Lv, Career, Sex) ->
    PostData = [{invitee_id, InviteeId}, {name, Name}, {lv, Lv}, {career, Career}, {sex, Sex}],
    PhpRequest = #php_request{role_id = InviteeId, data = upload_inivtee_info},
    Args = [role_invitee_update, PostData, PhpRequest],
    % 再次判断是否上传数据
    mod_invite:upload_inivtee_info(InviteeId, Args),
    ok.

%% 上传被邀请者充值到php,只更新数据,没有就不处理
%% 上传参数={invitee_id, name, lv, career, sex, add_gold}
%% 返回=无论失败成功返回1
upload_inivtee_recharge(Player, AddGold) ->
    #player_status{id = InviteeId, figure = #figure{name = Name, lv = Lv, career = Career, sex = Sex}} = Player,
    upload_inivtee_recharge(InviteeId, Name, Lv, Career, Sex, AddGold),
    ok.

upload_inivtee_recharge(InviteeId, Name, Lv, Career, Sex, AddGold) ->
    PostData = [{invitee_id, InviteeId}, {name, Name}, {lv, Lv}, {career, Career}, {sex, Sex}, {add_gold, AddGold}],
    PhpRequest = #php_request{role_id = InviteeId, data = upload_inivtee_recharge},
    Args = [role_invitee_update_gold, PostData, PhpRequest],
    % 再次判断是否上传数据
    mod_invite:upload_inivtee_recharge(InviteeId, Args),
    ok.

%% 请求更新邀请信息
%% 上传参数={role_id, RoleId}
request_update_invite_state(Player) when is_record(Player, player_status) ->
    #player_status{id = RoleId} = Player,
    request_update_invite_state(RoleId),
    ok;
request_update_invite_state(RoleId) ->
    PostData = [{role_id, RoleId}],
    PhpRequest = #php_request{role_id = RoleId, mfa = {?MODULE, reply_request_update_invite_state, []}, data = request_update_invite_state},
    lib_php_api:request(role_invite_list, PostData, PhpRequest),
    ok.

%% 回应请求更新邀请信息[php回调]
%% @return
%%  lv_list : [{Lv, Count}] 目前只需要统计10级和60级,[{10(指的是10级到59级的玩家数量), Count}, {60(指的是60等级后的玩家数量), Count}]
%%      8级是邀请宝箱奖励中的累积奖励
%%      60级是邀请等级奖励中的等级
%%  is_invitee : 是否被邀请,检查被邀请者是否有本玩家
%%  role_list ： [{InviteeId, Pos, Name, Lv, Career, Sex, Time},...]
%%  recharge_list ： [{InviteeId, Name, Gold},...],只有元宝数大于0才返回
reply_request_update_invite_state(#php_request{role_id = _RoleId} = _Request, <<>>) -> skip;
reply_request_update_invite_state(#php_request{role_id = RoleId} = _Request, JsonData) ->
     case catch mochijson2:decode(JsonData) of
         {'EXIT', Error} -> ?ERR("~p Error:~p~n JsonData:~p ~n", [?FUNCTION_NAME, Error, JsonData]);
        JsonTuple ->
            [Code] = lib_gift_card:extract_mochijson2([<<"ret">>], JsonTuple),
            case Code of
                0 -> 
                    case lib_gift_card:extract_mochijson2([<<"data">>, <<"lv_list">>], JsonTuple) of
                        [] -> LvList = false;
                        [LvListBin] ->
                            case util:bitstring_to_term(LvListBin) of
                                undefined -> LvList = false;
                                LvList -> ok
                            end
                    end,
                    case lib_gift_card:extract_mochijson2([<<"data">>, <<"is_invitee">>], JsonTuple) of
                        [] -> IsInvitee = false;
                        [IsInvitee] -> ok
                    end,
                    case lib_gift_card:extract_mochijson2([<<"data">>, <<"role_list">>], JsonTuple) of
                        [] -> RoleList = false;
                        [RoleListBin] -> 
                            % ?PRINT("~p RoleListBin:~w ~n", [?FUNCTION_NAME, RoleListBin]),
                            case util:bitstring_to_term(RoleListBin) of
                                undefined -> RoleList = false;
                                RoleList -> ok
                            end
                    end,
                    case lib_gift_card:extract_mochijson2([<<"data">>, <<"recharge_list">>], JsonTuple) of
                        [] -> RechargeList = false;
                        [RechargeListBin] -> 
                            % ?PRINT("~p RechargeListBin:~w ~n", [?FUNCTION_NAME, RechargeListBin]),
                            case util:bitstring_to_term(RechargeListBin) of
                                undefined -> RechargeList = false;
                                RechargeList -> ok
                            end
                    end,
                    % ?PRINT("~p reply_args_error LvList:~p, IsInvitee:~p, IsInviteeInt:~p RoleList:~p RechargeList:~p ~n", 
                    %     [?FUNCTION_NAME, LvList, IsInvitee, is_integer(IsInvitee), RoleList, RechargeList]),
                    % ?MYLOG("hjhinvite", "~p reply_args_error, RoleId:~p  LvList:~p, IsInvitee:~p, RoleList:~p RechargeList:~p ~n", 
                    %             [?FUNCTION_NAME, RoleId, LvList, IsInvitee, RoleList, RechargeList]),
                    F = fun(T) -> T == false end,
                    case lists:any(F, [LvList, IsInvitee, RoleList, RechargeList]) of
                        true -> 
                            ?ERR("~p reply_args_error LvList:~p, IsInvitee:~p, RoleList:~p RechargeList:~p ~n", 
                                [?FUNCTION_NAME, LvList, IsInvitee, RoleList, RechargeList]);
                        false -> 
                            mod_invite:update_invite_state(RoleId, LvList, IsInvitee, RoleList, RechargeList)
                            % F2 = fun(T) -> is_record(T, invitee_role) andalso T#invitee_role.role_id == RoleId end,
                            % case lists:all(F2, RoleList) of
                            %     true -> mod_invite:update_invite_state(RoleId, LvList, IsInvitee, RoleList);
                            %     false -> ?ERR("~p reply_args_error RoleList:~p ~n", [?FUNCTION_NAME, RoleList])
                            % end
                    end;
                _ ->
                    skip
            end
    end,
    ok.