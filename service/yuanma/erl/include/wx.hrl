%% ---------------------------------------------------------------------------
%% @doc wx.erl

%% @author  hjh
%% @email  hejiahua@163.com
%% @since 2019-09-23
%% @deprecated 微信需求
%% ---------------------------------------------------------------------------

-define(WX_KV(Key), data_wx:get_kv(Key)).

-define(WX_KV_SHARE_SOURCE_LIST, ?WX_KV(1)).      % 分享开启渠道列表##[渠道,...]
-define(WX_KV_SHARE_DAY_COUNT, ?WX_KV(2)).        % 分享的每天奖励次数
-define(WX_KV_SHARE_REWARD, ?WX_KV(3)).           % 分享奖励
-define(WX_KV_SUBSCRIBE_CHANGER, ?WX_KV(4)).      % 微信订阅开关
-define(WX_KV_SUBSCRIBE_BEFORE_TIME, ?WX_KV(5)).  % 活动开始前多久进行推送


-define(WX_KV_COLLECT_SOURCE_LIST, ?WX_KV(11)).           % 微信收藏渠道
-define(WX_KV_COLLECT_REWARD, ?WX_KV(12)).           % 微信收藏奖励
-define(WX_KV_MICRO_LOGIN_REWARD, ?WX_KV(13)).       % 微端首次登录奖励


%% -----------------------------------------------------------------
%% 微信分享
%% -----------------------------------------------------------------

%% 微信分享
-record(status_wx_share, {
        count = 0
        , utime = 0
    }).

-define(sql_role_wx_share_select, <<"SELECT `count`, `utime` FROM role_wx_share WHERE role_id = ~p">>).
-define(sql_role_wx_share_replace, <<"REPLACE INTO role_wx_share(role_id, `count`, `utime`) VALUES(~p, ~p, ~p)">>).


%% -----------------------------------------------------------------
%% 微信订阅消息
%% -----------------------------------------------------------------
-record(base_wx_subscribe_temp, {
        id = 0                         % 模板id
        , temp_id = 0                  % 微信配置模板id
        , package_code = 0             % 包代码
        , args = []                    % 模板参数
        , pos = 0                      % 模板订阅使用位置（客户端用）
        , desc = ""                    % 说明
    }).
-record(base_wx_subscribe_temp_arg, {
        arg_id = 0                     % 参数id
        , arg_str = ""                 % 参数字符串
        , lan_id = 0                   % 语言配置id
        , desc = ""                    % 说明
    }).

-record(base_wx_act_subscribe, {
        act_id = 0
        , title = ""
        , content = ""
        , rewards = ""
    }).

-define(sql_role_subscribe_act_select_all, <<"SELECT `sh_uid`, `package_code`, `temp_id`, `role_id` FROM `role_wx_subscribe`">>).
-define(sql_role_wx_subscribe_replace, <<"REPLACE INTO `role_wx_subscribe`(`sh_uid`, `temp_id`, `package_code`, `role_id`, `utime`) VALUES('~s', ~p, '~s', ~p, ~p)">>).
-define(sql_role_wx_subscribe_delete, <<"DELETE FROM `role_wx_subscribe` where `sh_uid` = '~s' and `temp_id` = ~p">>).
%% -----------------------------------------------------------------
%% 微信
%% -----------------------------------------------------------------