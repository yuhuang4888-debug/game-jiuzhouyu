%% ---------------------------------------------------------------------------
%% @doc relationship.hrl

%% @author hjh
%% @since  2016-12-06
%% @deprecated 关系
%% ---------------------------------------------------------------------------
%% 人数上限
-define(FRIEND_NUM_LIMIT, 50).                      %% 好友数量上限
-define(BLACK_LIST_NUM_LIMIT, 20).                  %% 黑名单人数上限
-define(ENEMY_NUM_LIMIT, 99).                       %% 仇人数量上限
-define(RECOMMENDED_SEARCH_CD, 10).                 %% 推荐列表刷新CD
-define(RECOMMENDED_LIST_MAX_LEN, 6).               %% 推荐好友显示最大数量

-define(RELA_UPDATE_SWITCH, 1).                     %% 玩家关系更新开关
-define(RELA_UPDATE_REMOVE, 0).                     %% 从社交列表移除玩家
-define(RELA_UPDATE_ADD,    1).                     %% 从社交列表增加玩家

-define(RELA_LIST_TYPE_FRIEND,  1).                 %% 好友列表
-define(RELA_LIST_TYPE_ENEMY,   2).                 %% 仇人列表
-define(RELA_LIST_TYPE_BLACK,   3).                 %% 黑名单

%% 回复好友申请类型
-define(REPLY_TYPE_REFUSE, 0).                      %% 拒绝
-define(REPLY_TYPE_AGREE, 1).                       %% 同意
-define(REPLY_TYPE_PULL_BLACK, 2).                  %% 拉黑

-define(FRIEND_ASK_VAILD_TIME, 86400).              %% 好友请求有效时间 过期的在玩家登陆或者服务器重启时会清理掉

%% 获得亲密度的方式
%% 类型1000之前的为后台配置亲密度获得方式配置的类型,其他类型从1000之后开始
-define(INTIMACY_TYPE_DUN,          1).                 %% 各类副本
-define(INTIMACY_TYPE_MON,          2).                 %% 各类怪物

-define(INTIMACY_TYPE_PRESENT,      1000).              %% 赠送物品
-define(INTIMACY_TYPE_SHOW_LVE,     1001).              %% 秀恩爱
-define(INTIMACY_TYPE_HOUSE_GIFT,   1002).              %% 送房子礼物

%% ---------------- 关系类型定义(关系唯一不会同时存在两条关系数据) ------------------------------
-define(RELA_TYPE_NONE,                  0).        %% 没有关系
-define(RELA_TYPE_FRIEND,                1).        %% 好友
-define(RELA_TYPE_ENEMY,                 2).        %% 仇人
-define(RELA_TYPE_BLACK,                 3).        %% 黑名单
-define(RELA_TYPE_BLACK_AND_ENEMY,       4).        %% 仇人且黑名单
-define(RELA_TYPE_FRIEND_AND_ENEMY,      5).        %% 仇人且好友
-define(RELA_FRIEND_TYPES, [?RELA_TYPE_FRIEND, ?RELA_TYPE_FRIEND_AND_ENEMY]).
-define(RELA_BLACK_TYPES, [?RELA_TYPE_BLACK, ?RELA_TYPE_BLACK_AND_ENEMY]).
-define(RELA_ENEMY_TYPES, [?RELA_TYPE_ENEMY, ?RELA_TYPE_BLACK_AND_ENEMY, ?RELA_TYPE_FRIEND_AND_ENEMY]).
%% -----------------------------------------------------------------------

%% --------------------------关系操作-----------------------------
-define(ADD_FRIEND,         1).     %% 同意添加好友
-define(BE_ADD_FRIEND,      2).     %% 被同意添加好友
-define(DEL_FRIEND,         3).     %% 删除好友
-define(BE_DEL_FRIEND,      4).     %% 被删除好友
-define(ADD_BLACK,          5).     %% 拉黑
-define(BE_ADD_BLACK,       6).     %% 被拉黑
-define(DEL_BLACK,          7).     %% 取消拉黑
-define(ADD_ENEMY,          8).     %% 自动添加仇人
-define(DEL_ENEMY,          9).     %% 移除仇人

%% ---------------------------玩家进程定义--------------------------------
-define(RELAS_KEY, relas).                          %% 进程字典
-define(FRIEND_ASK_LIST, rela_friend_ask_list).     %% 好友请求列表
% %% !!!非玩家关系的玩家信息不要存到这张表
% %% !!!需要离线玩家用离线缓存拿数据 需要其他在线玩家用在线缓存拿数据 避免数据存多份浪费内存
% -define(ETS_RELA_ROLE_INFO, ets_rela_role_info).    %% 关系玩家记录
%% -----------------------------------------------------------------------

-record(intimacy_lv_cfg, {
    lv = 0,
    color = 0,
    name = "",
    intimacy = 0,
    attr = []
    }).

-record(intimacy_obtain_cfg, {
    type = 0,                           %% 亲密度获得类型
    trigger_obj = 0,                    %% 触发对象id
    intimacy = 0,                       %% 增加亲密度
    times = 0                           %% 次数限制 4点重置
    }).

%% 关系记录(玩家进程)
-record(rela, {
    role_id = 0,            % 玩家id
    other_rid = 0,          % 关系另一方的玩家id
    rela_type = 0,          % 关系类型
    intimacy = 0,           % 亲密度
    last_chat_time = 0,     % 最后聊天时间
    last_chat_utime = 0,    % 最后聊天的数据库更新时间
    ctime = 0               % 关系记录创建时间
    }).

%% 好友请求
-record(friend_ask, {
    role_id = 0,
    ask_id = 0,
    time = 0
    }).

%% 关系玩家记录(主要是用于关系模块中,数据基本是展示和判断,非社交用的数据不要放到这里来)
-record(ets_rela_role_info, {
    id  = 0,                    %% 玩家id
    figure = undefined,         %% 玩家形象
    % friend_num = 0,             %% 好友数量
    % guild_id = 0,
    % guild_name = "",
    combat_power = 0,
    last_login_time = 0,
    % last_login_ip = "127.0.0.1",
    online_flag = 0             %% 0: 不在线 1: 在线
    }).

% -define(sql_select_rela_role_info,
%     <<"select plow.nickname, plow.lv, plow.career, plow.sex, coalesce(pturn.turn, 0), plow.picture, plow.picture_ver, plogin.online_flag
%     from player_low plow left join player_login plogin on plow.id = plogin.id left join reincarnation pturn on plow.id = pturn.role_id where plow.id = ~p limit 1">>).
-define(sql_rela_select_by_role_id,
    <<"select role_id, other_rid, rela_type, intimacy, last_chat_time, ctime from relationship where role_id = ~p">>).
-define(sql_rela_select_by_rid_and_oid,
    <<"select role_id, other_rid, rela_type, intimacy, last_chat_time, ctime from relationship where role_id = ~p and other_rid = ~p">>).
-define(sql_rela_select_by_rid_and_type,
    <<"select role_id, other_rid, rela_type, intimacy, last_chat_time, ctime from relationship where role_id = ~p and rela_type = ~p">>).
-define(sql_rela_insert,
    <<"insert into relationship (from_id, to_id, rela_type, ctime) values(~p, ~p, ~p, ~p)">>).
-define(sql_update_last_chat_time,
    <<"update relationship set last_chat_time = ~p where (role_id = ~p and other_rid = ~p) or (other_rid = ~p and role_id = ~p)">>).
-define(sql_del_out_time_friend_ask_by_role_id,
    <<"delete from rela_friend_ask where UNIX_TIMESTAMP() - time >= ~p and role_id = ~p">>).
-define(sql_get_friend_ask_by_role_id,
    <<"select role_id, ask_id, time from rela_friend_ask where role_id = ~p">>).
-define(sql_add_friend_ask,
    <<"replace into rela_friend_ask(role_id, ask_id, time) values(~p, ~p, ~p)">>).
-define(db_del_friend_ask_by_asker_id,
    <<"delete from rela_friend_ask where role_id = ~p and ask_id = ~p">>).
-define(db_del_one_role_all_friend_ask,
    <<"delete from rela_friend_ask where role_id = ~p">>).
-define(sql_save_role_rela,
    <<"replace into relationship (role_id, other_rid, rela_type, intimacy, last_chat_time, ctime) values(~p, ~p, ~p, ~p, ~p, ~p)">>).
-define(sql_del_role_rela,
    <<"delete from relationship where role_id = ~p and other_rid = ~p">>).
-define(sql_update_intimacy,
    <<"update relationship set intimacy = ~p where role_id = ~p and other_rid = ~p">>).
-define(sql_select_rela_data_by_rela,
    <<"select role_id, rela_type from relationship where other_rid = ~p and rela_type in(~s)">>).