%%-----------------------------------------------------------------------------
%% @Module  :       lib_share
%% @Author  :       Czc
%% @Email   :       389853407@qq.com
%% @Created :       2018-01-29
%% @Description:    分享有礼
%%-----------------------------------------------------------------------------
-module(lib_share).

-include("welfare.hrl").
-include("kv.hrl").
-include("errcode.hrl").
-include("server.hrl").

-export([
    login/1
    , send_share_status/2
    , share_success/2
    , receive_reward/1
    , get_open_lv/0
    ]).

login(RoleId) ->
    case db:get_row(io_lib:format(?sql_select_share, [RoleId])) of
        [Times, Status, LastReceiveTime] ->
            #status_share{times = Times, status = Status, last_receive_time = LastReceiveTime};
        _ ->
            #status_share{}
    end.

%% 发送分享有礼界面信息
send_share_status(RoleId, StatusShare) ->
    #status_share{times = Times, status = Status, last_receive_time = LastReceiveTime} = StatusShare,
    %% 计算下次可领取奖励时间
    ResetTime = get_reset_time(),
    NextReceiveTime = LastReceiveTime + ResetTime,
    NowTime = utime:unixtime(),
    case NowTime >= NextReceiveTime andalso Status == ?SHARE_STATUS_REC of
        true ->
            RealStatus = ?SHARE_STATUS_NO;
        false ->
            RealStatus = Status
    end,
    RewardL = data_key_value:get(?KEY_SHARE_REWARD),
    {ok, BinData} = pt_417:write(41710, [Times, RealStatus, NextReceiveTime, RewardL]),
    lib_server_send:send_to_uid(RoleId, BinData).

%% 分享成功
share_success(RoleId, StatusShare) ->
    #status_share{times = Times, status = Status, last_receive_time = LastReceiveTime} = StatusShare,
    ResetTime = get_reset_time(),
    NextReceiveTime = LastReceiveTime + ResetTime,
    NowTime = utime:unixtime(),
    NewTimes = Times + 1,
    case NowTime >= NextReceiveTime of
        true ->
            NewStatus = ?SHARE_STATUS_FIN;
        false -> %% 重置期间分享不改变分享状态
            NewStatus = Status
    end,
    case NewTimes == 1 of
        true ->
            db:execute(io_lib:format(?sql_insert_share, [RoleId, NewTimes, NewStatus, LastReceiveTime]));
        false ->
            db:execute(io_lib:format(?sql_update_share_times, [NewTimes, NewStatus, RoleId]))
    end,
    %% 日志
    lib_log_api:log_share_times(RoleId, NewTimes),
    {ok, BinData} = pt_417:write(41710, [NewTimes, NewStatus, NextReceiveTime]),
    lib_server_send:send_to_uid(RoleId, BinData),
    {ok, StatusShare#status_share{times = NewTimes, status = NewStatus}}.

%% 领取分享有礼奖励
receive_reward(PlayerStatus) ->
    #player_status{sid = Sid, id = RoleId, status_share = StatusShare} = PlayerStatus,
    #status_share{times = Times, status = Status, last_receive_time = LastReceiveTime} = StatusShare,
    NowTime = utime:unixtime(),
    ResetTime = get_reset_time(),
    NextReceiveTime = LastReceiveTime + ResetTime,
    case Status of
        ?SHARE_STATUS_FIN ->
            NewStatus = ?SHARE_STATUS_REC,
            db:execute(io_lib:format(?sql_update_share_reward_time, [NowTime, NewStatus, RoleId])),
            case data_key_value:get(?KEY_SHARE_REWARD) of
                RewardL when RewardL =/= [] ->
                    NewPlayerStatus = lib_goods_api:send_reward(PlayerStatus, RewardL, share_reward, 0, 1);
                _ -> NewPlayerStatus = PlayerStatus
            end,
            {ok, BinData} = pt_417:write(41710, [Times, NewStatus, NowTime + ResetTime]),
            lib_server_send:send_to_sid(Sid, BinData),
            NewStatusShare = StatusShare#status_share{status = NewStatus, last_receive_time = NowTime},
            {ok, NewPlayerStatus#player_status{status_share = NewStatusShare}};
        _ ->
            case NowTime >= NextReceiveTime andalso Status == ?SHARE_STATUS_REC of
                true ->
                    ErrCode = ?ERRCODE(err417_not_share);
                _ ->
                    ErrCode = ?ERRCODE(err417_has_receive_share_reward)
            end,
            {ok, BinData} = pt_417:write(41712, [ErrCode]),
            lib_server_send:send_to_sid(Sid, BinData)
    end.

get_reset_time() ->
    case data_key_value:get(?KEY_SHARE_RESET_TIME) of
        ResetTime when is_integer(ResetTime) -> ResetTime;
        _ -> ?DEFAULT_RESET_TIME
    end.

get_open_lv() ->
    case data_key_value:get(?KEY_SHARE_LV) of
        OpenLv when is_integer(OpenLv) -> OpenLv;
        _ -> ?DEFAULT_OPEN_LV
    end.
