%%%------------------------------------------------
%%% File    : mail.erl
%%% Author  : zhenghehe
%%% Created : 2012-02-01
%%% Description: 信件record定义
%%%------------------------------------------------

%% ------------------ 进程字典 ------------------
-define(P_MAIL_KEY(RoleId), lists:concat(["P_Mail_Key", RoleId])). %% 邮件 value:[#mail{}|...]

%% ------------------ 邮件类型 ------------------
-define(MAIL_TYPE_SYS, 1).          % 系统邮件
-define(MAIL_TYPE_PRIV, 2).         % 私人邮件
-define(MAIL_TYPE_GUILD, 3).        % 公会邮件

%% ------------------ 邮件状态 ------------------
-define(MAIL_STATE_READ, 1).        % 已读
-define(MAIL_STATE_NO_READ, 2).     % 未读
-define(MAIL_STATE_HAS_RECEIVE, 3). % 已领取附件

%% ------------------ 锁定状态 ------------------
-define(MAIL_LOCKED_YES, 1).        % 邮件锁定
-define(MAIL_LOCKED_NO, 2).         % 邮件未锁定

%% ------------------ 附件类型 ------------------
-define(ATTACHMENT_TYPE_NO, 0).             % 没有附件
-define(ATTACHMENT_TYPE_OWN_SQ, 1).         % 拥有特殊物品的附件
-define(ATTACHMENT_TYPE_CM, 2).             % 只有普通附件

%% ------------------ 发送邮件日志的类型 ------------------
-define(SEND_LOG_TYPE_NO, 0).       % 不加入日志
-define(SEND_LOG_TYPE_YES, 1).      % 加入日志

%% ------------------ 文本 ------------------
% -define(MAIL_TXT_SYS_NAME, 1).      % 邮件系统名字

%% ------------------ 其他定义 ------------------


%% 邮件
-record(mail, {
        id = 0                  % 邮件id
        , type = 1              % 邮件类型
        , state = 2             % 邮件状态
        , locked = 2            % 锁定状态
        , sid = 0               % 发送者id
        , sname = undefined     % 发件人名字(第一次读信加载)
        , rid = 0               % 接受者id
        , title = <<>>          % 标题
        , content :: undefined | <<>>    % 信件内容(第一次读信加载)
        , cm_attachment = []    % 普通附件列表,[{Type,GoodsTypeId,Num},...]
        % , sq_attachment :: undefined | []    % 特殊附件列表(保留字段,后续处理)
        , timestamp = 0         % 时间戳(微秒)
        , time = 0              % 秒
        , effect_st = 0         % 有效开始时间
        , effect_et = 0         % 有效结束时间
    }).

%% ------------------ 邮件 ------------------
%% 邮件属性
-define(sql_mail_attr_insert, <<"
    INSERT INTO
        mail_attr(id, type, state, locked, sid, rid, title, cm_attachment, timestamp, effect_st)
    VALUES(~p, ~p, ~p, ~p, ~p, ~p, '~s', '~s', ~p, ~p)">>).
-define(sql_mail_attr_select, <<"SELECT id, type, state, locked, sid, rid, title, cm_attachment, timestamp, effect_st FROM mail_attr WHERE rid = ~p">>).
-define(sql_mail_attr_delete, <<"DELETE FROM mail_attr WHERE id = ~p">>).
-define(sql_mail_attr_delete_more, <<"DELETE FROM mail_attr WHERE id in (~s)">>).

-define(sql_mail_attr_update_cm_attachment, <<"UPDATE mail_attr SET cm_attachment = '~s' WHERE id = ~p">>).
-define(sql_mail_attr_update_state_read, <<"UPDATE mail_attr SET state = 1 WHERE id = ~p">>).
-define(sql_mail_attr_update_cm_attachment_and_effect_st, <<"UPDATE mail_attr SET cm_attachment = '~s', effect_st = ~p WHERE id = ~p">>).
-define(sql_mail_attr_update_state_and_effect_st, <<"UPDATE mail_attr SET state = ~p, effect_st = ~p WHERE id = ~p">>).
-define(sql_mail_attr_update_receive_state, <<"UPDATE mail_attr SET state = ~p, cm_attachment = '~s', effect_st = ~p WHERE id = ~p">>).

%% 邮件内容
-define(sql_mail_content_insert, <<"INSERT INTO mail_content(id, rid, content) VALUES(~p, ~p, '~s')">>).
-define(sql_mail_content_select, <<"SELECT content FROM mail_content WHERE id = ~p">>).
-define(sql_mail_content_delete, <<"DELETE FROM mail_content WHERE id = ~p">>).
-define(sql_mail_content_delete_more, <<"DELETE FROM mail_content WHERE id in (~s)">>).

% %% 特殊附件列表(保留,后续看需求处理)
% -define(sql_mail_sq_attachment_replace, <<"REPLACE INTO mail_sq_attachment(id, rid, goods_id) WHERE id = ~p">>).
% -define(sql_mail_sq_attachment_select, <<"SELECT goods_id FROM mail_sq_attachment WHERE id = ~p">>).
% -define(sql_mail_sq_attachment_delete, <<"DELETE FROM mail_sq_attachment WHERE id = ~p">>).

%% ------------------ PHP后台 ------------------
%% 根据在线、来源、等级来获取玩家id
-define(sql_role_id_by_source_and_onlineflag_and_lv, <<"
    SELECT
        player_low.id FROM player_low, player_login
    WHERE player_login.source = '~s' AND player_login.online_flag = ~p AND player_low.lv >= ~p AND player_login.id = player_low.id">>).
%% 根据在线、等级来获取玩家id
-define(sql_role_id_by_onlineflag_and_lv, <<"
    SELECT
        player_low.id FROM player_low, player_login
    WHERE player_login.online_flag = ~p AND player_low.lv >= ~p AND player_login.id = player_low.id">>).
%% 根据等级和平台来获取玩家id
-define(sql_role_id_by_source_and_lv, <<"
    SELECT
        player_low.id FROM player_low, player_login
    WHERE player_login.source = '~s' AND player_low.lv>= ~p AND player_login.id = player_low.id">>).
%% 根据等级来获取玩家id
-define(sql_role_id_by_lv, <<"SELECT id FROM player_low WHERE player_low.lv >= ~p">>).

%% ------------------ 反馈 ------------------
-define(sql_feedback_insert, <<"
    INSERT INTO feedback(
        player_id, player_name, content, timestamp, ip, server)
    VALUES(~p, '~s', '~s', ~p, '~s', '~s')">>).