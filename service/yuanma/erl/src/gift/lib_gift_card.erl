%% ---------------------------------------------------------------------------
%% @doc 礼品卡
%% @author hhl
%% @since  2016-11-14
%% @deprecated
%% ---------------------------------------------------------------------------
-module(lib_gift_card).
-include("server.hrl").
-include("common.hrl").
-include("predefine.hrl").
-include("figure.hrl").
-include("errcode.hrl").
-include("goods.hrl").
-include("php.hrl").
-export([
        trigger_card/2,
        web_page_trigger_card/4,
        do_web_page_trigger_card/4,
        call_web_page_trigger_card/4,
        get_call_web_page_trigger_card_info_on_ps/1,
        do_call_web_page_trigger_card/4,
        extract_mochijson2/2
        %%        ,get_url/0
        ]).

%% 卡号的长度限制
-define(CARD_MIN_LEN, 3).
-define(CARD_MAX_LEN, 30).
-define(CardOpenLv,   50).
% -define(VERSION,    "cn").
% -define(GAME,     "yyhx").
% -define(APPKEY,   "e04201e54b49a941434c48d971b59af5").
% %%
% -ifdef(DEV_SERVER).
% -define(URL, "http://gamecenter.yyhx_kf.suyougame.com/api/api.php?"). %% 开发
% -else.
% -define(URL, "http://admin.userpic.suyougame.com/api/api.php?"). %% 外网
% -endif.

trigger_card(Ps, CardNo) ->
    #player_status{id = RoleId, source = Source, c_source = CSource, figure = Figure} = Ps,
    #figure{name = Name, lv = Lv, vip = Vip} = Figure,
    % ?PRINT("trigger_card CardNo:~p ~n", [CardNo]),
    case Lv >= ?CardOpenLv of
        false ->
            {false, ?LEVEL_LIMIT};
        true ->
            case util:check_length(CardNo, ?CARD_MIN_LEN, ?CARD_MAX_LEN) of
                false ->
                    {false, ?ERRCODE(err150_gift_card_err_len)};
                true ->
                    [GUrl, Appkey, Game, Version] = [lib_vsn:get_url(), ?APPKEY, ?GAME, ?VERSION],
                    NowTime = utime:unixtime(),
                    AuthStr = util:md5(lists:concat([Appkey, NowTime, "gift_card"])),
                    Url = lists:concat([GUrl, "time=", NowTime, "&method=gift_card&sign=", AuthStr]),
                    Recharge = lib_recharge_api:get_total(RoleId),
                    PostData = [
                        {card_no, CardNo}, {source, Source}, {c_source, CSource}, {vip_type, Vip}, {unique_id, RoleId},
                        {role_name, Name}, {game, Game}, {version, Version}, {role_lv, Lv}, {recharge, Recharge}
                        ],
                    StrBody = mochiweb_util:urlencode(PostData),
                    mod_gift_card:send_to_card_server(Url, StrBody, RoleId, CardNo, gift_card, null, 1), %% 1 是直接发奖励
                    ok
            end
    end.

%% ------------------------------------------ ---------------------------------
%% @doc 在网页推广兑换礼包(php调用)
%% web_page_trigger_card(PlayerId, CardNo, Title, Content) -> reture
%% {ok, 1}|{false, ErrorCode}
%% ErrorCode: 0失败异常  1成功 2操作过快 3卡号过长 4卡号已经被领取 5玩家不在线 6请求玩家数据异常 7玩家不存在
%% 1500105:礼包卡兑换成功，请到邮件查收！
%% 1500065:卡号错误
%% 1500119:该渠道不能使用
%% 1500069:未到领取卡号时间
%% 1500070:卡号过期
%% 1500068:卡号已经被领取
%% 1500071:已经使用过同类卡号
%% 1500139:卡号长度不符合规则
%% 1500143:充值金额不足
%% 1500142:兑换等级不足
%% 1500144:卡号使用次数不足
%% lib_gift_card:web_page_trigger_card(4294967297, "SGVlBtPG4zrmZS", <<"V+测试礼包">>, <<"V+测试测试内容">>).
web_page_trigger_card(PlayerId, CardNo, Title, Content) ->
    Key = {web_page_trigger_card, PlayerId},
    NowTime = utime:unixtime(),
    CdRes = case get(Key) of
                undefined -> put(Key, NowTime), true;
                LastTime ->
                    case NowTime - LastTime > 3 of
                        true -> put(Key, NowTime), true;
                        false -> false
                    end
            end,
    %% 是否操作过快
    case CdRes of
        false -> {false, 2}; %% 操作过快
        true ->
%%            RolePid = misc:get_player_process(PlayerId),
            case lib_player:apply_cast(PlayerId, ?APPLY_CAST_STATUS, ?HAND_OFFLINE, lib_gift_card, do_web_page_trigger_card, [CardNo, Title, Content]) of
                skip ->
                    {false, 5};
                _ ->
                    {ok, ?SUCCESS}
            end
    end.

%% 请求奖励发送邮件
%% 有可能是离线的登录的
do_web_page_trigger_card(Ps, CardNo, Title, Content) ->
%%    ?MYLOG("gift", "CardNo ~p~n", [CardNo]),
    #player_status{id = RoleId, source = Source, c_source = CSource, figure = Figure} = Ps,
    #figure{name = Name, vip = Vip, lv = Lv} = Figure,
    case util:check_length(CardNo, ?CARD_MIN_LEN, ?CARD_MAX_LEN) of
        false ->
%%            ?MYLOG("gift", "CardNo ~p~n", [CardNo]),
            3; %% 卡号过长
        true ->
            [GUrl, Appkey, Game, Version] = [lib_vsn:get_url(), ?APPKEY, ?GAME, ?VERSION],
            NowTime = utime:unixtime(),
            AuthStr = util:md5(lists:concat([Appkey, NowTime, "gift_card"])),
            Url = lists:concat([GUrl, "time=", NowTime, "&method=gift_card&sign=", AuthStr]),
            Recharge = lib_recharge_api:get_total(RoleId),
            PostData = [{card_no, CardNo}, {source, Source}, {c_source, CSource}, {vip_type, Vip}, {unique_id, RoleId},
                        {role_name, Name}, {game, Game}, {version, Version}, {role_lv, Lv}, {recharge, Recharge}],
            StrBody = mochiweb_util:urlencode(PostData),
            %% 2是发邮件
            % ?MYLOG("cym", "url ~p~n", [Url]),
            mod_gift_card:send_to_card_server(Url, StrBody, RoleId, CardNo, Title, Content, 2),
            ok
    end.

%% ------------------------------------------ ---------------------------------
%% @doc 在网页推广兑换礼包(php调用)，同步操作
%% web_page_trigger_card(PlayerId, CardNo, Title, Content) -> reture
%% {ok, 1}|{false, ErrorCode}
%% ErrorCode: 0失败异常  1成功 2操作过快 3卡号过长 4卡号已经被领取 5玩家不在线 6请求玩家数据异常 7玩家不存在
%% 1500105:礼包卡兑换成功，请到邮件查收！
%% 1500065:卡号错误
%% 1500119:该渠道不能使用
%% 1500069:未到领取卡号时间
%% 1500070:卡号过期
%% 1500068:卡号已经被领取
%% 1500071:已经使用过同类卡号
%% 1500139:卡号长度不符合规则
%% 1500143:充值金额不足
%% 1500142:兑换等级不足
%% 1500144:卡号使用次数不足
call_web_page_trigger_card(PlayerId, CardNo, Title, Content) ->
    Key = {call_web_page_trigger_card, PlayerId},
    NowTime = utime:unixtime(),
    CdRes = case get(Key) of
        undefined -> put(Key, NowTime), true;
        LastTime ->
            case NowTime - LastTime > 3 of
                true -> put(Key, NowTime), true;
                false -> false
            end
    end,
    %% 是否操作过快
    case CdRes of
        false -> {false, 2}; %% 操作过快
        true ->
            RolePid = misc:get_player_process(PlayerId),
            Ps = lib_offline_api:get_player_info(PlayerId, all),
            if
                Ps == not_exist -> {false, 7};
                true ->
                    case misc:is_process_alive(RolePid) of
                        true ->
                            case catch lib_player:apply_call(RolePid, ?APPLY_CALL_STATUS, lib_gift_card, get_call_web_page_trigger_card_info_on_ps, [], 3000) of
                                {ok, CSource} ->
                                    do_call_web_page_trigger_card(Ps#player_status{c_source=CSource}, CardNo, Title, Content);
                                _ ->
                                    {false, 6}
                            end;
                        false ->
                            do_call_web_page_trigger_card(Ps, CardNo, Title, Content)
                    end
            end
    end.

%% 获取必备信息
%% @return 信息
get_call_web_page_trigger_card_info_on_ps(Ps) ->
    #player_status{c_source = CSource} = Ps,
    {ok, CSource}.
    
%% 请求奖励发送邮件
%% 有可能是离线的登录的
do_call_web_page_trigger_card(Ps, CardNo, Title, Content) ->
    % ?MYLOG("gift", "CardNo ~p~n", [CardNo]),
    #player_status{id = RoleId, source = Source, c_source = CSource, figure = Figure} = Ps,
    #figure{name = Name, vip = Vip, lv = Lv} = Figure,
    case util:check_length(CardNo, ?CARD_MIN_LEN, ?CARD_MAX_LEN) of
        false ->
            % ?MYLOG("gift", "CardNo ~p~n", [CardNo]),
            {false, 3}; %% 卡号过长
        true ->
            [GUrl, Appkey, Game, Version] = [lib_vsn:get_url(), ?APPKEY, ?GAME, ?VERSION],
            NowTime = utime:unixtime(),
            AuthStr = util:md5(lists:concat([Appkey, NowTime, "gift_card"])),
            Url = lists:concat([GUrl, "time=", NowTime, "&method=gift_card&sign=", AuthStr]),
            Recharge = lib_recharge_api:get_total(RoleId),
            PostData = [{card_no, CardNo}, {source, Source}, {c_source, CSource}, {vip_type, Vip}, {unique_id, RoleId},
                        {role_name, Name}, {game, Game}, {version, Version}, {role_lv, Lv}, {recharge, Recharge}],
            StrBody = mochiweb_util:urlencode(PostData),
            %% 2是发邮件
            % ?MYLOG("cym", "url ~p~n", [Url]),
            mod_gift_card:call_send_to_card_server(Url, StrBody, RoleId, CardNo, Title, Content, 2)
    end.

extract_mochijson2([], Rest) -> [Rest];
extract_mochijson2([ElmKey | TElmKey],{struct, RestJSON} = A) when is_tuple(A)->
    [ Value || {Key, Rest} <- RestJSON, Key =:= ElmKey, Value <- extract_mochijson2(TElmKey, Rest)];
extract_mochijson2(List, A) ->
    [ Value || B <- A, Value <- extract_mochijson2(List, B)].