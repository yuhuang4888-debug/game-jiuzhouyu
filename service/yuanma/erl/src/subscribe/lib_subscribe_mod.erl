%% ---------------------------------------------------------------------------
%% @doc lib_subscribe_mod.erl

%% @author  hjh
%% @email  hejiahua@163.com
%% @since  2020-03-05
%% @deprecated 订阅进程处理
%% ---------------------------------------------------------------------------
-module(lib_subscribe_mod).

-compile(export_all).

-include("common.hrl").
-include("def_module.hrl").
-include("php.hrl").
-include("subscribe.hrl").
-include("wx.hrl").

init() ->
    % DbList = db_role_subscribe_select_all(),
    % F = fun([SubscribeType, AccnameBin, LastLogoutTime], SubscribeMap) ->
    %     Accname = util:make_sure_list(AccnameBin),
    %     SubscribeL = maps:get(SubscribeType, SubscribeMap, []),
    %     case lists:keyfind(Accname, #subscribe.accname, SubscribeL) of
    %         false -> NewSubscribeL = [#subscribe{accname = Accname, last_logout_time = LastLogoutTime}|SubscribeL];
    %         #subscribe{last_logout_time = OldLastLogoutTime} = Subscribe ->
    %             NewSubscribe = Subscribe#subscribe{last_logout_time = max(LastLogoutTime, OldLastLogoutTime)},
    %             NewSubscribeL = lists:keystore(Accname, #subscribe.accname, SubscribeL, NewSubscribe)
    %     end,
    %     maps:put(SubscribeType, NewSubscribeL, SubscribeMap)
    % end,
    % SubscribeMap = lists:foldl(F, #{}, DbList),
    F1 = fun([ShUidBin, PackageCode, TemplateId, RoleId], SubscribeMap) ->
        ShUid = util:bitstring_to_term(ShUidBin),
        SubscribeL = maps:get(TemplateId, SubscribeMap, []),
        case lists:keyfind(ShUid, #subscribe_act.sh_uid, SubscribeL) of
            false -> NewSubscribeL = [#subscribe_act{sh_uid = ShUid, template_id=TemplateId, package_code = PackageCode, role_id = RoleId} | SubscribeL];
            #subscribe_act{} -> NewSubscribeL = SubscribeL
        end,
        maps:put(TemplateId, NewSubscribeL, SubscribeMap)
    end,
    ActSubList = db_role_subscribe_act_select_all(),
    NewSubscribeMap = lists:foldl(F1, #{}, ActSubList),

    {ok, #subscribe_state{subscribe_map = NewSubscribeMap}}.

% %% 设置
% set_subscribe_type(State, SubscribeType, Accname, LastLogoutTime) ->
%     #subscribe_state{subscribe_map = SubscribeMap} = State,
%     SubscribeL = maps:get(SubscribeType, SubscribeMap, []),
%     case lists:keyfind(Accname, #subscribe.accname, SubscribeL) of
%         false -> NewSubscribeL = [#subscribe{accname = Accname, last_logout_time = LastLogoutTime}|SubscribeL];
%         #subscribe{last_logout_time = OldLastLogoutTime} = Subscribe ->
%             NewSubscribe = Subscribe#subscribe{last_logout_time = max(LastLogoutTime, OldLastLogoutTime)},
%             NewSubscribeL = lists:keystore(Accname, #subscribe.accname, SubscribeL, NewSubscribe)
%     end,
%     NewSubscribeMap = maps:put(SubscribeType, NewSubscribeL, SubscribeMap),
%     State#subscribe_state{subscribe_map = NewSubscribeMap}.

% %% 移除订阅
% remove_subscribe(State, SubscribeType, Accname) ->
%     #subscribe_state{subscribe_map = SubscribeMap} = State,
%     SubscribeL = maps:get(SubscribeType, SubscribeMap, []),
%     NewSubscribeL = lists:keydelete(Accname, #subscribe.accname, SubscribeL),
%     NewSubscribeMap = maps:put(SubscribeType, NewSubscribeL, SubscribeMap),
%     State#subscribe_state{subscribe_map = NewSubscribeMap}.



%% ===================================================== 新版微信推送 ======================================================

%% 玩家登录
login(State, ?MOD_ONHOOK = ActType, AccName, _RoleId) ->
    #subscribe_state{subscribe_map = SubscribeM} = State,
    SubscribeL = maps:get(ActType, SubscribeM, []),
    case lists:keyfind(AccName, #subscribe_act.sh_uid, SubscribeL) of
        false -> State;
        #subscribe_act{onhook_tref = ORef} = SubscribeAct ->
            util:cancel_timer(ORef),
            NSubscribeAct = SubscribeAct#subscribe_act{onhook_tref = undefined},
            NewSubscribeL = lists:keyreplace(AccName, #subscribe_act.sh_uid, SubscribeL, NSubscribeAct),
            NSubscribeM = maps:put(ActType, NewSubscribeL, SubscribeM),
            State#subscribe_state{subscribe_map = NSubscribeM}
    end.

%% 玩家登出
logout(State, ?MOD_ONHOOK = ActType, AccName, _RoleId, [AfkLeftTime]) ->
    #subscribe_state{subscribe_map = SubscribeM} = State,
    SubscribeL = maps:get(ActType, SubscribeM, []),
    case lists:keyfind(AccName, #subscribe_act.sh_uid, SubscribeL) of
        false -> State; % 没有申请订阅推送
        #subscribe_act{onhook_tref = ORef} = SubscribeAct -> % 设置定时器推送提醒
            NRef = util:send_after(ORef, timer:seconds(AfkLeftTime), self(), {'onhook_timeout', ActType, AccName}),
            NSubscribeAct = SubscribeAct#subscribe_act{onhook_tref = NRef},
            NewSubscribeL = lists:keyreplace(AccName, #subscribe_act.sh_uid, SubscribeL, NSubscribeAct),
            NSubscribeM = maps:put(ActType, NewSubscribeL, SubscribeM),
            State#subscribe_state{subscribe_map = NSubscribeM}
    end.

%% 离线挂机到期推送
send_subscribe_act(State, ?MOD_ONHOOK = ActType, ShUid, _NowTime) ->
    % 获取订阅玩家信息
    #subscribe_state{subscribe_map = SubscribeMap} = State,
    SubscribeL = maps:get(ActType, SubscribeMap),
    SubscribeAct = lists:keyfind(ShUid, #subscribe_act.sh_uid, SubscribeL),
    #subscribe_act{sh_uid = ShUid, package_code = PackageCode, template_id = TemplateId, role_id = RoleId} = SubscribeAct,
    % 推送
    case lib_player:is_online_global(RoleId) of
        false -> % 离线推送
            WxParams = get_wx_params([TemplateId, ShUid, PackageCode]),
            send_subscribe_of_act(TemplateId, ShUid, WxParams);
        true -> % 在线不推送,取消一次性订阅
            lib_subscribe_api:cancel_subscribe(TemplateId, ShUid)
    end,
    State;
%% 限时活动推送
send_subscribe_act(State, ActType, StartTime, EndTime) ->
    #subscribe_state{subscribe_map = SubscribeMap} = State,
    SubscribeL = maps:get(ActType, SubscribeMap, []),
    [
    begin
        case lib_player:is_online_global(RoleId) of
            false -> % 离线推送
                WxParams = get_wx_params([TemplateId, ShUid, PackageCode, StartTime, EndTime]),
                send_subscribe_of_act(TemplateId, ShUid, WxParams);
            true -> % 在线不推送,取消一次性订阅
                lib_subscribe_api:cancel_subscribe(TemplateId, ShUid)
        end
    end || #subscribe_act{sh_uid = ShUid, package_code = PackageCode, template_id = TemplateId, role_id = RoleId} <- SubscribeL
    ],
    State.

%% 接口说明文档 http://doc.diaigame.com/doku.php?id=%E5%BE%AE%E4%BF%A1%E5%B0%8F%E6%B8%B8%E6%88%8Fsdk%E8%AF%B4%E6%98%8E%E6%96%87%E6%A1%A3#%E8%AE%A2%E9%98%85%E6%B6%88%E6%81%AF%E6%8E%88%E6%9D%83%E6%8E%A5%E5%8F%A3
%% 发送活动开启通知
send_subscribe_of_act(TemplateId, AccName, WxParams) ->
        Url = "https://mixsdk.921.com/wxxcx/sendSubscribeMessage?",
        StrBody = mochiweb_util:urlencode(WxParams),
        ParamsUrl = lists:concat([Url, StrBody]),
        % ?INFO("ParamUrl: ~p~n", [list_to_binary(ParamsUrl)]),
        PhpRequest = #php_request{mfa = {?MODULE, reply_send_subscribe_of_act, []}, data = {send_subscribe_of_act, TemplateId, AccName}},
        mod_php:request_get(ParamsUrl, PhpRequest),
        % 微信给游戏的推送是一次性推送，推送完毕后就失效了，所以推送后取消订阅状态
        lib_subscribe_api:cancel_subscribe(TemplateId, AccName).

%% 错误码说明
%% 40003	touser字段openid为空或者不正确
%% 40037	订阅模板id为空不正确
%% 43101	用户拒绝接受消息，如果用户之前曾经订阅过，则表示用户取消了订阅关系
%% 47003	模板参数不准确，可能为空或者不满足规则，errmsg会提示具体是哪个字段出错
%% 41030	page路径不正确，需要保证在现网版本小程序中存在，与app.json保持一致
reply_send_subscribe_of_act(Request, JoinData) ->
    #php_request{data = {_, TemplateId, AccName}} = Request,
    {struct, Params} = mochijson2:decode(JoinData),
    {_, RetMsg} = ulists:keyfind(<<"msg">>, 1, Params, {<<"msg">>, <<"0">>}),
    case RetMsg of
        <<_:27/bytes, RetCode:5/bytes, _/binary>> ->
            ErrCode = case catch list_to_integer(binary_to_list(RetCode)) of
                {'EXIT', _} -> 0;
                Res -> Res
            end;
        _ -> ErrCode = 0
    end,
    if
        ErrCode == 43101 ->  % 用户取消订阅
            lib_subscribe_api:cancel_subscribe(TemplateId, AccName);
        ErrCode /= 0 -> % 异常错误
            ?ERR("wx subscribe err: ~p~n", [{JoinData, ErrCode}]);
        true ->
            skip
    end.

%% 订阅某推送
subscribe(State, [TempId, PackageCode|_] = TemplateInfo, ShUid, RoleId) ->
    % 入库
    ShUidBin = util:term_to_bitstring(ShUid),
    db:execute(io_lib:format(?sql_role_wx_subscribe_replace, [ShUidBin, TempId, PackageCode, RoleId, utime:unixtime()])),
    % 订阅信息保存
    NewState = set_subscribe_act(State, TemplateInfo, ShUid, RoleId),
    % 反馈
    send_subscribe_status(NewState, RoleId, ShUid, [TempId]),
    NewState.

%% 取消订阅某推送
cancel_subscribe(State, TemplateId, ShUid) ->
    % 进程状态改变
    #subscribe_state{subscribe_map = SubscribeMap} = State,
    SubscribeL = maps:get(TemplateId, SubscribeMap, []),
    NewSubL = lists:keydelete(ShUid, #subscribe_act.sh_uid, SubscribeL),
    NewMap = maps:put(TemplateId, NewSubL, SubscribeMap),
    NewState = State#subscribe_state{subscribe_map = NewMap},
    % 数据库删除
    ShUidBin = util:term_to_bitstring(ShUid),
    db:execute(io_lib:format(?sql_role_wx_subscribe_delete, [ShUidBin, TemplateId])),
    NewState.

%% 清理订阅
clear_subscribe(State, 0) -> % 全部清理
    NewState = State#subscribe_state{subscribe_map = #{}},
    Sql = <<"TRUNCATE TABLE `role_wx_subscribe`">>,
    db:execute(io_lib:format(Sql, [])),
    NewState;
clear_subscribe(State, TemplateId) ->
    % 进程状态改变
    #subscribe_state{subscribe_map = SubscribeMap} = State,
    NewMap = maps:put(TemplateId, [], SubscribeMap),
    NewState = State#subscribe_state{subscribe_map = NewMap},
    % db删除
    Sql = <<"DELETE FROM `role_wx_subscribe` where `temp_id` = ~p">>,
    db:execute(io_lib:format(Sql, [TemplateId])),
    NewState.

send_subscribe_status(State, RoleId, AccName, TemIdL) ->
    #subscribe_state{subscribe_map = SubscribeMap} = State,
    F = fun(TemId, Acc) ->
        SubscribeL = maps:get(TemId, SubscribeMap, []),
        Res = case lists:keymember(AccName, #subscribe_act.sh_uid, SubscribeL) of
            false -> 0;
            true -> 1
        end,
        [{TemId, Res} | Acc]
    end,
    List = lists:foldl(F, [], TemIdL),
    {ok, BinData} = pt_113:write(11306, [List]),
    lib_server_send:send_to_uid(RoleId, BinData),
    State.

%% 离线挂机
get_wx_params([?MOD_ONHOOK, ShUid, PackageCode]) ->
    #base_wx_subscribe_temp{temp_id = TempId} = data_wx:get_temp(?MOD_ONHOOK),
    #base_wx_act_subscribe{title = Title, content = Content} = data_wx_subscribe:get_act_info(?MOD_ONHOOK),
    EndTime = lib_subscribe:format_unixtime_to_utf8(utime:unixtime()),
    [
        {"sh_uid", ShUid}, {"template_id", TempId}, {"package_code", PackageCode},
        {"data[thing1][value]", Title},
        {"data[date2][value]", EndTime},
        {"data[phrase6][value]", Content}
    ];
%% 限时活动
get_wx_params([TemplateId, ShUid, PackageCode, StartTime, EndTime]) ->
    #base_wx_subscribe_temp{temp_id = TempId} = data_wx:get_temp(TemplateId),
    #base_wx_act_subscribe{title = Title, content = Content} = data_wx_subscribe:get_act_info(TemplateId),
    ActStartTime = lib_subscribe:format_unixtime_to_utf8(StartTime),
    ActEndTime = lib_subscribe:format_unixtime_to_utf8(EndTime),
    [
        {"sh_uid", ShUid}, {"template_id", TempId}, {"package_code", PackageCode},
        {"data[thing1][value]", Title},
        {"data[time8][value]", ActStartTime},
        {"data[time9][value]", ActEndTime},
        {"data[thing12][value]", Content}
    ].

%% 订阅信息保存
set_subscribe_act(State, [TempId, PackageCode | _], ShUid, RoleId) ->
    #subscribe_state{subscribe_map = SubscribeMap} = State,
    SubscribeAct = #subscribe_act{sh_uid = ShUid, template_id = TempId, package_code = PackageCode, role_id = RoleId},
    SubscribeL = maps:get(TempId, SubscribeMap, []),
    NewSubL = lists:keystore(ShUid, #subscribe_act.sh_uid, SubscribeL, SubscribeAct),
    LastMap = maps:put(TempId, NewSubL, SubscribeMap),
    State#subscribe_state{subscribe_map = LastMap}.

% %% 获取订阅信息
% db_role_subscribe_select_all() ->
%     Sql = io_lib:format(?sql_role_subscribe_select_all, []),
%     db:get_all(Sql).

%% 获取活动开启订阅信息
db_role_subscribe_act_select_all() ->
    Sql = io_lib:format(?sql_role_subscribe_act_select_all, []),
    db:get_all(Sql).
