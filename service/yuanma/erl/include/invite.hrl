%% ---------------------------------------------------------------------------
%% @doc invite.hrl

%% @author  hjh
%% @email  hejiahua@163.com
%% @since  2018-10-31
%% @deprecated 邀请
%% ---------------------------------------------------------------------------

%% 注意：
%% (1)好友升级助战
%%  界面显示的玩家数量上限，最大的宝箱好友数量上限，指定等级列表计算 要通知php

-define(INVITE_KV(Key), data_invite:get_kv_value(Key)).       %% 邀请键值 
-define(INVITE_KV_CREATE_REWARD, ?INVITE_KV(1)).        %% 邀请创建角色的奖励##[{Type, GoodsTypeId, Num},..]
-define(INVITE_KV_BOX_DAILY_NUM, ?INVITE_KV(2)).        %% 宝箱每天开启的次数上限
-define(INVITE_KV_BOX_ADD_TIME, ?INVITE_KV(3)).         %% 宝箱恢复1次的时间(秒)
-define(INVITE_KV_BOX_MAX_NUM, ?INVITE_KV(4)).          %% 宝箱恢复最大值
-define(INVITE_KV_CALC_TOTAL_DAILY_NUM, ?INVITE_KV(5)). %% 每天前几次算进入累计次数
-define(INVITE_KV_LV_OF_REWARD_TYPE_LV, ?INVITE_KV(6)). %% 好友升级累计奖励的等级 
-define(INVITE_KV_LV_REWARD_LV_LIST, ?INVITE_KV(7)).    %% 等级奖励列表,部分等级奖励是一次性领取的,不需要一个位置一个位置领取##[{Lv,是否一次性领取}]
-define(INVITE_KV_LV_REWARD_HELP_LV, ?INVITE_KV(8)).    %% 帮助界面的等级
-define(INVITE_KV_LV_REWARD_LV_UP_LV, ?INVITE_KV(9)).   %% 升级界面的等级
-define(INVITE_KV_UPLOAD_MAX_LV, ?INVITE_KV(10)).       %% 邀请信息上传最大更新等级##减少数据的传送，比配置的等级高一些
-define(INVITE_KV_UPLOAD_GAP, ?INVITE_KV(11)).          %% 上传时间间隔(秒)，根据登出时间来计算间隔##减少数据的传送
-define(INVITE_KV_REQUEST_GAP, ?INVITE_KV(12)).         %% 请求邀请数据时间间隔(秒)，根据登出时间来计算间隔##减少数据的传送
-define(INVITE_KV_RED_PACKET_REWARD, ?INVITE_KV(13)).   %% 红包奖励##[{Type, GoodsTypeId, 返还比率},..]
-define(INVITE_KV_RED_PACKET_LEN, ?INVITE_KV(14)).      %% 红包列表长度,显示所有未领取的,不够长度就抽取被领取的
-define(INVITE_KV_TRIGGER_LV_LIST, ?INVITE_KV(15)).     %% 信息上传下载必然触发等级，目的是为了减少数据的传送##[等级,等级]
-define(INVITE_KV_REQUEST_MIN_LV, ?INVITE_KV(16)).      %% 邀请信息下载最低等级##减少数据的传送

-define(INVITE_REWARD_CAN_NOT_GET, 0).  %% 不可领取
-define(INVITE_REWARD_HAD_GET, 1).      %% 已经领取
-define(INVITE_REWARD_CAN_GET, 2).      %% 可以领取

%% 玩家邀请状态
-record(status_invite, {
        get_status = 0          % 宝箱领取状态##0:不可领取 1:已经领取 2可以领取
        , count = 0             % 当前可以领取的次数
        , last_count_time = 0   % 上次记录的领取时间
        , total_count = 0       % 总次数
        , reward_list = []      % 累计奖励列表##[{Type, RewardId}]
        , lv_list = []          % 领取的等级列表##[{Lv, Count}],Count:领取了多少次
        , pos_list = []         % 领取的位置列表##[{Lv, Pos}],Pos:位置
    }).

%% 被邀请玩家信息
-record(invitee_role, {
        role_id = 0             % 邀请者id
        , invitee_id = 0        % 被邀请者id
        , pos = 0               % 位置 
        , name = 0              % 被邀请者名字
        , lv = 0                % 被邀请者等级
        , career = 0            % 被邀请者职业
        , sex = 0               % 被邀请者性别
        , time = 0              % 邀请时间
    }).

%% 被邀请者充值
-record(invitee_recharge, {
        role_id = 0             % 邀请者id
        , invitee_id = 0        % 被邀请者id
        , name = 0              % 被邀请者名字
        , gold = 0              % 充值的元宝数
        , get_gold = 0          % 已经领取的元宝数
        , last_get_gold = 0     % 上次获得的元宝数
        , time = 0              % 更改时间
    }).

%% 邀请
-record(invite, {
        role_id = 0             % 邀请者id
        , lv_list = []          % 等级列表##[{Lv, Count}],php过滤发过来
        , is_invitee = 0        % 是否被邀请##没有被邀请则不发等级到php
        , role_list = []        % 玩家列表##[#invitee_role{}],php过滤发过来
        , recharge_list = []    % 被邀请者充值列表##[#invitee_recharge{}],php过滤发过来
    }).

%% 邀请进程状态
-record(invite_state, {
        invite_map = #{}        % Map##Key:RoleId,Value:#invite{}
    }).

%% -----------------------------------------------------------------
%% 配置
%% -----------------------------------------------------------------

%% 不生成 record
%% data_invite:get_box_reward(Num) -> Reward;
% %% 宝箱奖励配置
% -record(base_invite_box_reward, {
%         num = 0             % 数量
%         , reward = []       % 奖励列表
%     }).

%% 奖励类型
-define(INVITE_REWARD_TYPE_BOX, 1).     % 开宝箱累计
-define(INVITE_REWARD_TYPE_LV, 2).      % 好友升级累计
-define(INVITE_REWARD_TYPE_WELFARE, 3). % 福利奖励

%% 奖励配置
-record(base_invite_reward, {
        type = 0            % 奖励类型##1、开宝箱累计 2、好友升级累计 3、福利奖励
        , reward_id = 0     % 奖励id
        , num = 0           % 数量
        , reward = []       % 奖励
    }).

%% 不生成 record
%% data_invite:get_lv_reward(Lv, Pos) -> Reward;
% %% 升级奖励配置
% -record(base_invite_lv_reward, {
%         lv = 0              % 等级
%         , min = 0           % 开始位置
%         , max = 0           % 结束位置
%         , reward = []       % 奖励
%     }).

%% -----------------------------------------------------------------
%% 数据库
%% -----------------------------------------------------------------

-define(sql_role_invite_select, <<"SELECT get_status, count, last_count_time, total_count, reward_list, lv_list, pos_list FROM role_invite WHERE role_id = ~p">>).
-define(sql_role_invite_replace, <<"
    REPLACE INTO 
        role_invite(role_id, get_status, count, last_count_time, total_count, reward_list, lv_list, pos_list) 
    VALUES(~p, ~p, ~p, ~p, ~p, '~s', '~s', '~s')">>).

-define(sql_invite_select, <<"SELECT role_id, lv_list, is_invitee FROM invite">>).
-define(sql_invite_replace, <<"REPLACE INTO invite(role_id, lv_list, is_invitee) VALUES(~p, '~s', ~p)">>).

-define(sql_invitee_role_select, <<"SELECT role_id, invitee_id, pos, name, lv, career, sex, time FROM invitee_role">>).
-define(sql_invitee_role_batch, <<"REPLACE INTO invitee_role(role_id, invitee_id, pos, name, lv, career, sex, time) VALUES ~ts">>).
-define(sql_invitee_role_values, <<"(~p, ~p, ~p, '~s', ~p, ~p, ~p, ~p)">>).
-define(sql_invitee_role_delete, <<"DELETE FROM invitee_role WHERE role_id = ~p">>).

-define(sql_invitee_recharge_select, <<"SELECT  role_id, invitee_id, name, gold, get_gold, last_get_gold, time FROM invitee_recharge">>).
-define(sql_invitee_recharge_batch, <<"REPLACE INTO invitee_recharge(role_id, invitee_id, name, gold, get_gold, last_get_gold, time) VALUES ~ts">>).
-define(sql_invitee_recharge_values, <<"(~p, ~p, '~s', ~p, ~p, ~p, ~p)">>).