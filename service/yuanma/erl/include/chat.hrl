%%%--------------------------------------
%%% @Author  : calvin
%%% @Email   : calvinzhong888@gmail.com
%%% @Created : 2012.5.9
%%% @Description: 聊天
%%%--------------------------------------

%% 11017协议
%% 目前暂时只有队伍频道
-define(FLOAT_TEXT_ONLY,    1).   %% 只飘字
-define(CHAT_WINDOW_ONLY,   2).   %% 只聊天框
-define(FLOAT_AND_CHAT,     3).   %% 飘字加聊天框

%% ----------------------------------------------------
%% 举报/禁言
%% ----------------------------------------------------

%% 禁言类型
-define(TALK_LIMIT_TYPE_1, 1).      %% gm或指导员禁言
-define(TALK_LIMIT_TYPE_2, 2).      %% 违反规则自动禁言A
-define(TALK_LIMIT_TYPE_3, 3).      %% 违反规则自动禁言B
-define(TALK_LIMIT_TYPE_4, 4).      %% 被举报次数过多禁言
-define(TALK_LIMIT_TYPE_5, 5).      %% 违反规则自动禁言C
-define(TALK_LIMIT_TYPE_6, 6).      %% 违反规则自动禁言D
-define(TALK_LIMIT_TYPE_7, 7).      %% 违反规则自动禁言E

%% 释放类型
-define(TALK_RELEASE_TYPE_1, 1).    %% gm或管理员手动解禁
-define(TALK_RELEASE_TYPE_2, 2).    %% 自动解禁

-define(HORN_TALK_LV, 30).            %% 发喇叭级别
-define(TALK_LIMIT_TIME, 180).        %% 禁言时
-define(TALK_LIMIT_TIME_0, 300).      %% 禁言5分钟
-define(TALK_LIMIT_TIME_1, 600).      %% 禁言10分钟
-define(TALK_LIMIT_TIME_2, 1800).     %% 禁言30分钟
-define(TALK_LIMIT_TIME_3, 3600).     %% 禁言1个小时
-define(TALK_LIMIT_TIME_4, 7200).     %% 禁言2小时
-define(TALK_LIMIT_TIME_5, 21600).    %% 禁言6小时
-define(TALK_LIMIT_TIME_6, 86400).    %% 禁言24小时
-define(TALK_LIMIT_TIME_7, (86400*3)). %% 禁言3天
-define(TALK_LIMIT_TIME_8, (86400*7)). %% 禁言一周
-define(TALK_LIMIT_TIME_9, (3*366*86400)). %% 禁言三年
-define(ALLOW_INFORM_NUM, 10).          %% 最多被举报次数
-define(ALLOW_CHAT_NUM_1, 20).          %% 40级下,每天最多私聊玩家数
-define(ALLOW_CHAT_NUM_2, 30).          %% 40级下,给非好友最多私聊次数
-define(CHAT_RULE_5_REJECT, [[43], [43,229,165,189,229,143,139]]). %% 聊天规则5,排除字符["+","+加好友"]
%% 玩家聊天时间线缓存，记录玩家发言的时间点，用于自动禁言
-define(CHAT_TIME_LINE, "P_CHAT_TIME_LINE").

-define(SQL_UPDATE_TALK_LIM, <<"update player_login set talk_lim=~p, talk_lim_type=~p, talk_lim_time=~p where id=~p">>).
-define(SQL_UPDATE_LIM_RIGHT, <<"update player_login set talk_lim_right=~p where id=~p">>).
-define(SQL_SELECT_TALK_LIM, <<"select talk_lim, talk_lim_time, talk_lim_right from player_login where id =~p">>).

%% 存储被举报的信息
-define(SQL_TALK_REPORT,<<"insert into `talk_report`(from_id, to_id, `msg`, `time`) values(~p, ~p, '~s', UNIX_TIMESTAMP() )">>).

-record(talk_accept, {
          all_accept = 1,         %% 世界消息的接受。1:接受|0:拒绝
          all_tv_accept = 1       %% 世界传闻消息的接受。1:接受|0:拒绝
         }).

%% ----------------------------------------------------
%% 聊天
%% ----------------------------------------------------
%% 聊天类型
-define(CHAT_CHANNEL_WORLD,     1).     %% 世界频道
-define(CHAT_CHANNEL_HORN,      2).     %% 喇叭
-define(CHAT_CHANNEL_NEARBY,    3).     %% 区域频道
-define(CHAT_CHANNEL_GUILD,     4).     %% 公会频道
-define(CHAT_CHANNEL_TEAM,      5).     %% 队伍频道
-define(CHAT_CHANNEL_PRIVATE,   6).     %% 私聊频道
-define(CHAT_CHANNEL_RELA,      7).     %% 好友频道
-define(CHAT_CHANNEL_RECRUIT,   8).     %% 招募频道
-define(CHAT_CHANNEL_INFORM,    9).     %% 举报频道
-define(CHAT_CHANNEL_SYS,      10).     %% 系统频道
-define(CHAT_CHANNEL_WAIT_TEAM,11).     %% 组队频道
-define(CHAT_CHANNEL_SCENE,    12).     %% 场景聊天(只针对活动场景的聊天)
-define(CHAT_CHANNEL_WORLD_KF, 13).     %% 跨服世界频道
-define(CHAT_CHANNEL_3V3_TEAM, 14).     %% 跨服3v3队伍
-define(CHAT_CHANNEL_SAME_CITY,15).     %% 同城聊天
-define(CHAT_CHANNEL_REPLY,    16).     %% 答题频道  公会内部使用
-define(CHAT_CHANNEL_ZONE,     17).     %% 小跨服频道
-define(CHAT_CHANNEL_CAMP,     18).     %% 阵营频道
-define(CHAT_CHANNEL_SEA,      19).     %% 海域频道
-define(CHAT_CHANNEL_NG,       20).     %% 百鬼夜行频道

%% 聊天类型开放列表
-define(CHAT_CHANNEL_OPEN_LIST, [
        ?CHAT_CHANNEL_WORLD,
        ?CHAT_CHANNEL_HORN,
        ?CHAT_CHANNEL_NEARBY,
        ?CHAT_CHANNEL_GUILD,
        ?CHAT_CHANNEL_TEAM,
        ?CHAT_CHANNEL_PRIVATE,
        ?CHAT_CHANNEL_RELA,
        ?CHAT_CHANNEL_WAIT_TEAM,
        ?CHAT_CHANNEL_SCENE,
        ?CHAT_CHANNEL_WORLD_KF,
        ?CHAT_CHANNEL_3V3_TEAM,
        ?CHAT_CHANNEL_SAME_CITY,
        ?CHAT_CHANNEL_REPLY,
        ?CHAT_CHANNEL_ZONE,
        ?CHAT_CHANNEL_CAMP,
        ?CHAT_CHANNEL_SEA,
        ?CHAT_CHANNEL_NG
    ]).

%% 聊天内容
-define(CHAT_CONTENT_TEXT,      1). %% 文字聊天
-define(CHAT_CONTENT_PICTURE,   2). %% 图片聊天
-define(CHAT_CONTENT_VOICE,     3). %% 声音聊天

%% 聊天时间
-define(CHAT_GAP_WORLD,     5).     %% 世界频道发言间隔
-define(CHAT_GAP_HORN,      ?HORN_KV(send_msg_interval)).     %% 喇叭发言间隔 send_msg_interval
-define(CHAT_GAP_NEARBY,    5).     %% 附近频道发言间隔
-define(CHAT_GAP_GUILD,     3).     %% 帮派/家族频道发言间隔
-define(CHAT_GAP_TEAM,      3).     %% 队伍频道发言间隔
-define(CHAT_GAP_PRIVATE,   3).     %% 密聊频道发言间隔
-define(CHAT_GAP_RELA,      3).     %% 好友频道发言间隔
-define(CHAT_GAP_CAREER,    3).     %% 职业/门派频道
-define(CHAT_GAP_INFORM,    3).     %% 举报间隔
-define(CHAT_GAP_WAIT_TEAM, 10).    %% 组队邀请时间间隔
-define(CHAT_GAP_SCENE,     5).     %% 场景聊天时间间隔
-define(CHAT_GAP_WORLD_KF,  15).    %% 跨服世界频道聊天时间间隔
-define(CHAT_GAP_3V3_TEAM,  0.5).   %% 跨服世界频道聊天时间间隔
-define(CHAT_GAP_SAME_CITY, 5).     %% 同城聊天
-define(CHAT_GAP_REPLY,     3).     %% 答题时间间隔
-define(CHAT_GAP_ZONE,      10).    %% 小跨服频道时间间隔
-define(CHAT_GAP_CAMP,      5).     %% 阵营聊天间隔
-define(CHAT_GAP_DEFAULT,   3).     %% 默认发言间隔

%% 聊天等级
-define(CHAT_LV_WORLD,      60).    %% 世界频道发言等级
-define(CHAT_LV_HORN,       ?HORN_KV(open_lv)).   %% 喇叭
-define(CHAT_LV_NEARBY,     70).    %% 附近频道
-define(CHAT_LV_GUILD,      60).    %% 公会
-define(CHAT_LV_TEAM,       70).    %% 队伍频道
-define(CHAT_LV_PRIVATE,    60).    %% 密聊频道
-define(CHAT_LV_RELA,       60).    %% 好友频道
-define(CHAT_LV_CAREER,     60).    %% 职业/门派频道
-define(CHAT_LV_SCENE,      60).    %% 场景聊天频道
-define(CHAT_LV_WORLD_KF,   90).    %% 跨服世界频道
-define(CHAT_LV_SAME_CITY,  150).   %% 同城聊天
-define(CHAT_LV_ZONE,       200).   %% 小跨服聊天频道
-define(CHAT_LV_CAMP,       260).   %% 阵营频道开启等级
-define(CHAT_LV_DEFAULT,    60).    %% 默认发言等级

%% 聊天长度
-define(CHAT_LEN_DEFAULT,   120).   %% 默认长度(服务器放宽,1汉字=2单位长度,1数字字母=1单位长度)

%% 聊天道具
-define(CHAT_GOODS_HORN, 1102015065).   %% 喇叭道具

%% 聊天内容相同
-define(CHAT_CONTENT_SAME_NO, 0).   %% 不相同
-define(CHAT_CONTENT_SAME_YES, 1).  %% 相同

%% 参数结果类型
-define(CHAT_ARGS_RESULT_NO, 0).        %% 没有参数
-define(CHAT_ARGS_RESULT_PASS, 1).      %% 有参数校验正常
-define(CHAT_ARGS_RESULT_NO_PASS, 2).   %% 有参数校验失败

%% 小跨服聊天的天数
-define(CHAT_OPEN_DAY_ZONE, 2).    %% 小跨服聊天的开服天数

%% 小跨服聊天的服数
-define(CHAT_ZONE_SEVER_NUM, 1).    %% 小跨服聊天的服数

%% 其他
-define(HORN_KV(Key), data_horn:get_value(Key)).
-define(CHAT_HORN_SHOW_TIME, ?HORN_KV(horn_show_time)).    %% 喇叭展示时间


%% 聊天
-record(status_chat, {
        prev_record_time = 0,     %% 上次记录内容的时间
        record_content   = []     %% 记录的聊天内容
    }).

%% 缓存读取记录
-define(CAHT_CACHE_IS_READ_NO, 0).
-define(CAHT_CACHE_IS_READ_YES, 1).

%% 聊天记录
-record(chat, {
        channel = 0
        , chat_content = 0
        , sender_server_num = 0
        , sender_c_server_msg = <<>>
        , sender_id = 0
        , sender_figure = undefined
        , sender_server_id = 0
        , sender_server_name = <<>>
        , receive_id = 0
        , receive_figure = undefined
        , msg_send = ""
        , args = []
        , args_result = 0
        , utime = 0
        , is_read = ?CAHT_CACHE_IS_READ_NO      % 是否已读
        , voice_id = 0                          % 语音自增id
        , voice_time = 0                        % 语音时间
        , province = ""                         % 省
        , city = ""                             % 城市
        , horn_type = 0                         % 叭类型  1本服 2小跨服 3大跨服
    }).

%% 喇叭
-record(bugle, {
        role_id = 0,              %% 玩家id
        bugle_id = 0,             %% 喇叭id
        show_time = 0,            %% 展示时间
        send_type = 0,            %% 发送喇叭类型 SELF_SERVER SELF_ZONE ALL_SERVER
        msg = []                  %% 消息列表
    }).

%% 喇叭类型
-define(SELF_SERVER,    1).   %% 本服喇叭
-define(SELF_ZONE,      2).   %% 小跨服喇叭
-define(ALL_SERVER,     3).   %% 大跨服喇叭

%% 喇叭配置
-record(bugle_cfg, {
        id = 0,
        first_cost = [],
        second_cost = [],
        show_time = 0,
        conditions = []
    }).

%% ----------------------------------------------------
%% 小红点
%% ----------------------------------------------------
%% 公会
-define(RED_POINT_GUILD_APPLY, 1).            % 公会申请
-define(RED_POINT_GUILD_UPGRADE, 2).          % 公会升级
-define(RED_POINT_RECEIVE_FLOWER_GIFT, 1).    % 收到新的鲜花礼物


%% ----------------------------------------------------
%% 其他
%% ----------------------------------------------------
%% 公告Ets
-define(ETS_SYS_NOTICE, ets_sys_notice).

%% ================================= 聊天监控 =================================
-record(monitor_state, {
        timer_check = undefined,     % 定时器（用于清理多次通知远程monitor失败的数据）
        database = <<>>,             % 本地数据库名，用于远程monitor确认所在服
        log_to_monitor = false,      % 是否记录到远程monitor中
        timer_log = undefined,       % 数据本地入库定时器
        log_id = 0                   % 缓存记录id（用于本地入库前缓存）
    }).

-record(chat_info, {
        channel = 0,                 % 聊天频道类型
        source = <<>>,               % 渠道
        content = <<>>,              % 发言内容
        sh_monitor_pkg = 0,          % shenhai渠道聊天动态包编号
        time = 0,                    % 发言时间
        from_role = [],              % 发起人信息 #role_chat_info{}
        to_role = []                 % 接收人信息 #role_chat_info{}
    }).

-record(role_chat_info, {
        accname = "",                % 平台账号(不是平台帐号id)
        role_id = 0,                 % 角色id
        name = <<>>,                 % 角色名
        reg_server_id = 0,           % 选择服务器的服id
        platform = <<>>,             % 平台
        server_id = 0,               % 全服唯一id
        server_name = <<>>,          % 服务器名
        level = 0,                   % 角色等级
        vip = 0,                     % VIP等级
        career = 0,                  % 角色职业
        power = 0,                   % 战力
        address = <<>>,              % IP地址
        guild_id = 0,                % 帮派id
        guild_name = <<>>,           % 帮派名字
        scene_id = 0,                % 场景id
        recharge = 0,                % 充值数
        team_id = 0                  % 队伍id
    }).

-define(CHAT_CACHE_TIME_DELETE, 86400).    %% 只保留X秒前的聊天缓存记录