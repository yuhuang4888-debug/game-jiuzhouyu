%% ---------------------------------------------------------------------------
%% @doc lib_subscribe_api.erl

%% @author  hjh
%% @email  hejiahua@163.com
%% @since  2020-03-05
%% @deprecated 订阅接口
%% ---------------------------------------------------------------------------
-module(lib_subscribe_api).

-compile(export_all).

-include("subscribe.hrl").
-include("server.hrl").
-include("common.hrl").
-include("php.hrl").
-include("wx.hrl").
-include("def_module.hrl").

% %% 离线收益领取提醒通用
% %% 离线收益、通知时间、通知日期、温馨提示、奖励内容
% %% 测试例子
% % ParamsUrl = binary_to_list(<<"https://mixsdk.921.com/package/query/package_code/P0006365/type/send_subscribe_message?sh_uid=42985912&template_id=af892fa9dd02ea88e628ec9c61a26344&data[离线收益][value]=339208499&data[通知时间][value]=通知时间&data[通知日期][value]=通知日期&data[温馨提示][value]=温馨提示&data[奖励内容][value]=奖励内容"/utf8>>),
% send_subscribe_of_onhook(Player) ->
%     #player_status{subscribe_type = SubscribeType, accname = Accname} = Player,
%     case lib_subscribe:get_url(SubscribeType) of
%         [] -> skip;
%         Url ->
%             ComonStr = binary_to_list(<<"挂机经验已满，请上线领取"/utf8>>),
%             {{Y,Month,D},{H,M,S}} = utime:localtime(),
%             Time = lists:flatten(io_lib:format("~2..0w:~2..0w:~2..0w", [H, M, S])),
%             Date = lists:flatten(io_lib:format("~4..0w-~2..0w-~2..0w", [Y, Month, D])),
%             Params = [
%                 {"sh_uid", Accname}, {"template_id", "af892fa9dd02ea88e628ec9c61a26344"},
%                 {binary_to_list(<<"data[离线收益][value]"/utf8>>), ComonStr},
%                 {binary_to_list(<<"data[通知时间][value]"/utf8>>), Time},
%                 {binary_to_list(<<"data[通知日期][value]"/utf8>>), Date},
%                 {binary_to_list(<<"data[温馨提示][value]"/utf8>>), ComonStr},
%                 {binary_to_list(<<"data[奖励内容][value]"/utf8>>), ComonStr}
%             ],
%             StrBody = mochiweb_util:urlencode(Params),
%             ParamsUrl = lists:concat([Url, StrBody]),
%             PhpRequest = #php_request{mfa = {?MODULE, reply_send_subscribe_of_onhook, []}, data = send_subscribe_of_onhook},
%             % ?MYLOG("phphttp", "================ Accname:~p ParamsUrl:~p~n", [Accname, ParamsUrl]),
%             mod_php:request_get(ParamsUrl, PhpRequest)
%     end,
%     ok.

% reply_send_subscribe_of_onhook(_Request, _JoinData) ->
%     % ?MYLOG("phphttp", "================ Request:~p, JoinData:~p~n", [_Request, _JoinData]),
%     ok.

% %% 福利发放通用
% %% 福利内容、活动说明、活动时间、礼包信息、礼包详情、截至时间、新版本内容
% send_subscribe_of_welfare() ->
%     ok.

%% 离线挂机订阅登录处理
login(?MOD_ONHOOK, AccName, RoleId) ->
    case check_subscribe_is_open() of
        true -> mod_subscribe:login(?MOD_ONHOOK, AccName, RoleId);
        _ -> skip
    end;
login(_, _, _) -> skip.

%% 离线挂机订阅登出处理
logout(?MOD_ONHOOK, AccName, RoleId, [AfkLeftTime]) when AfkLeftTime > 0 ->
    case check_subscribe_is_open() of
        true -> mod_subscribe:logout(?MOD_ONHOOK, AccName, RoleId, [AfkLeftTime]);
        _ -> skip
    end;
logout(_, _, _, _) -> skip.

%% 活动通知通用
%% 只在国内发
%% Args:
%% ActType: 活动类型，定义在后台微信推送活动配置页签里
%% StartTime EndTime 开始时间和结束时间，unix时间戳
send_subscribe_of_act(ActType, StartTime, EndTime) ->
    case check_subscribe_is_open() of
        true -> mod_subscribe:send_subscribe_of_act(ActType, StartTime, EndTime);
        _ -> skip
    end.

%% 订阅某推送
subscribe(TemplateInfo, ShUid, RoleId) ->
    case check_subscribe_is_open() of
        true -> mod_subscribe:subscribe(TemplateInfo, ShUid, RoleId);
        _ -> skip
    end.

%% 取消订阅某推送
cancel_subscribe(TemplateId, ShUid) ->
    mod_subscribe:cancel_subscribe(TemplateId, ShUid).


%% 检测微信订阅是否开启
check_subscribe_is_open() ->
    ?WX_KV_SUBSCRIBE_CHANGER == 1 andalso lib_vsn:is_cn().

%% 秘籍：清空微信订阅
clear_subscribe(TemplateId) ->
    mod_subscribe:clear_subscribe(TemplateId).