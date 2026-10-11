%%-----------------------------------------------------------------------------
%% @Module  :       red_envelopes
%% @Author  :       Czc
%% @Email   :       389853407@qq.com
%% @Created :       2017-09-20
%% @Description:    红包
%%-----------------------------------------------------------------------------

%% ------------------- 进程字典 --------------------
-define(PID, misc:get_global_pid(mod_red_envelopes)).
-define(P_RED_ENVELOPES, "P_Red_Envelopes").                % #{红包类型=>#{所属id=>[#red_envelopes{}]}}
-define(P_RED_ENVELOPES_RECORD, "P_Red_Envelopes_Record").  % #{红包类型=>#{所属id=>[#obtain_record{}]}}
-define(P_RED_ENVELOPES_NOSEND, "P_Red_Envelopes_Nosend").  % #{玩家id=>[红包id]}

%% ------------------- 红包类型 --------------------
%% 增加新的触发类型如果有次数限制需要在对应的次数配置里面增加次数id需跟配置触发id一样
-define(RED_ENVELOPES_TYPE_VIP, 1).                     % 提升vip等级赠送的红包
-define(RED_ENVELOPES_TYPE_RECHARGE, 2).                % 累充赠送的红包
-define(RED_ENVELOPES_TYPE_GFEAST, 3).                  % 公会晚宴红包
-define(RED_ENVELOPES_TYPE_FIR_RECHARGE, 4).            % 首冲红包
-define(RED_ENVELOPES_TYPE_MONTH_CARD, 5).              % 月卡投资
-define(RED_ENVELOPES_TYPE_LEVEL_INVEST, 6).             % 等级投资

-define(RED_ENVELOPES_TYPE_GOODS, 99).                  % 红包道具
-define(RED_ENVELOPES_TYPE_VIP_PLAYER_SEND, 100).       % VIP玩家红包

%% ------------------- 对红包类型的归类 --------------------
-define(SYSTEM_RED_ENVELOPES, 1).           % 系统赠送的红包
-define(GOODS_RED_ENVELOPES, 2).            % 道具红包
-define(VIP_RED_ENVELOPES, 3).              % VIP玩家红包


%% 不需要需要在获得记录里面显示的红包类型
-define(NOT_RECORD_TYPES, [
    ?RED_ENVELOPES_TYPE_GOODS,
    ?RED_ENVELOPES_TYPE_VIP_PLAYER_SEND
    ]).

%% ------------------- 红包归属类型 --------------------
-define(GUILD_RED_ENVELOPES,    1).            % 公会红包
-define(ACT_RED_ENVELOPES,      2).            % 定制活动红包

%% ------------------- 红包状态 --------------------
-define(NO_SEND, 0).                        % 未发送
-define(HAS_SEND, 1).                       % 已发送
-define(END, 2).                            % 已领完
-define(EXPIRED, 3).                        % 已过期

%% ------------------- 领取状态 --------------------
-define(HAS_RECEIVE, 1).                    % 已领取
-define(CAN_RECEIVE, 2).                    % 可领取

%% ------------------- 系统红包触发周期 --------------------
-define(NO_TIMES_LIMIT, 0).                 % 不限次数
-define(LIFELONG, 1).                       % 终身
-define(WEEK, 2).                           % 每周
-define(DAILY, 3).                          % 每天

%% ------------------- 通知客户端刷新的类型 ----------------
-define(NEW_RED_ENVELOPES, 1).              % 有新红包可领

%% ------------------- 其他宏 --------------------
-define(AUTO_SEND_AF_TIME, data_key_value:get(3390001)).          % 红包多久未发送后自动发送
-define(DEL_AF_SEND_TIME, data_key_value:get(3390002)).           % 红包发送多久后自动过期删除
-define(OBTAIN_RECORD_LEN, data_key_value:get(3390003)).             % 红包获得记录列表长度
-define(RED_ENVELOPES_MIN_SPLIT_NUM, 1).   % 红包默认最小拆分数量
-define(VIP_RED_ENVELOPES_SEND_LV, data_key_value:get(3390004)).      % VIP玩家红包发送等级
-define(VIP_RED_ENVELOPES_SEND_LIMIT, data_key_value:get(3390006)).      % VIP玩家红包发送数量限制
-define(VIP_RED_ENVELOPES_MIN_SPLIT_NUM, data_key_value:get(3390007)).      % VIP玩家红包数量
-define(VIP_RED_ENVELOPES_GOLD_MAX, data_key_value:get(3390010)).      % VIP玩家红包发送金额上限
-define(VIP_RED_ENVELOPES_MAX_MONEY, 1000). % VIP玩家红包一次最多发多少元宝

%% 需要记录未发送列表的红包类型
-define(RECORD_OWNERSHIP_NOSEND, [
    ?GUILD_RED_ENVELOPES
    ]).

%% ------------------- 红包其他数据键值 --------------------
-define(RED_OTHERS_PLAYERS, 1).                    % 可领取的玩家列表


%% 红包
-record(red_envelopes, {
    id = 0,
    type = 0,                               % 红包类型
    ownership_type = 0,                     % 1: 公会红包
    ownership_id = 0,                       % 归属id 公会红包为公会id
    owner_id = 0,                           % 红包拥有者玩家id
    % owner_figure = undefine,                % 拥有者玩家形象
    status = 0,                             % 红包状态
    money = 0,                              % 红包额度
    split_num = 0,                          % 红包的拆分数量
    recipients_num = 0,                     % 已领取人数
    recipients_lists = [],                  % 领取的玩家数据列表 [#recipients_record{}]
    extra = 0,                              % 系统赠送红包为配置id 道具红包为道具id
    stime = 0,                              % 红包发送时间
    ctime = 0,                               % 红包获得时间
    msg = <<>>,
    others = []                            % 红包其他数据
    }).

%% 红包获得记录
-record(obtain_record, {
    id = 0,
    role_id = 0,                            % 玩家id
    role_name = 0,                          % 玩家名字
    cfg_id = 0,                             % 红包配置id
    time = 0                                % 时间
    }).

%% 领取记录
-record(recipients_record, {
    role_id = 0,                            % 玩家id
    red_envelopes_id = 0,                   % 红包id
    % figure = undefine,                      % 玩家形象
    money = 0,                              % 领取的额度
    time = 0                                % 时间
    }).

%% ps， 记录没发送的个人红包
-record(status_red_envelopes, {
        red_list = []
    }).

%% ------------------- 配置 --------------------
%% 触发条件获得红包的配置
-record(red_envelopes_cfg, {
    id = 0,
    type = 0,                   % 红包子类型
    ownership_type = 0,         % 1: 公会红包
    name = <<>>,                % 红包名字
    desc = <<>>,                % 描述
    greetings = <<>>,           % 祝福语
    trigger_interval = 0,       % 1: 终身 2: 每周 3: 每日
    trigger_times = 0,          % 触发次数
    condition = [],             % 获得红包的条件
    money = 0,                  % 额度
    min_num = 0                 % 最小红包个数
    }).

%% 红包道具配置
-record(red_envelopes_goods_cfg, {
    goods_type_id = 0,          % 物品类型id
    ownership_type = 0,         % 见红包归属类型
    name = <<>>,                % 红包名字
    desc = <<>>,                % 描述
    greetings = <<>>,           % 祝福语
    money_type = 0,             % 货币类型
    money = 0,                  % 额度
    min_num = 0,                % 最小红包拆分个数
    times_lim = 0               % 使用次数限制
    }).

%% ------------------- 数据库 --------------------
-define(sql_select_red_envelopes,
    <<"select id, type, ownership_type, ownership_id, owner_id, status,
    money, split_num, extra, stime, ctime, msg, others from red_envelopes">>).
-define(sql_select_recipients_record,
    <<"select role_id, red_envelopes_id, money, time from red_envelopes_recipients_record">>).
-define(sql_insert_red_envelopes,
    <<"insert into red_envelopes(id, type, ownership_type, ownership_id, owner_id, status, money, split_num,
        extra, stime, ctime, msg, others) values(~p, ~p, ~p, ~p, ~p, ~p, ~p, ~p, ~p, ~p, ~p, '~s', '~s')">>).
-define(sql_insert_recipients_record,
    <<"insert into red_envelopes_recipients_record(role_id, red_envelopes_id, ownership_id, money, stime, time)
        values(~p, ~p, ~p, ~p, ~p, ~p)">>).
-define(sql_update_red_envelopes_status,
    <<"update red_envelopes set status = ~p, stime = ~p where id = ~p">>).
-define(sql_update_red_envelopes_status_and_split_num,
    <<"update red_envelopes set status = ~p, split_num = ~p, stime = ~p where id = ~p">>).
-define(sql_update_red_envelopes_ownership,
    <<"update red_envelopes set ownership_id = ~p where id in (~s) ">>).
% -define(sql_del_red_envelopes_by_guild_id_and_role_id,
%     <<"delete from red_envelopes where ownership_id = ~p and owner_id = ~p and status = ~p">>).
% -define(sql_del_red_envelopes_by_guild_id,
%     <<"delete from red_envelopes where ownership_id = ~p">>).
-define(sql_del_red_envelopes_by_ownership_type_and_id,
    <<"delete from red_envelopes where ownership_type = ~p and ownership_id = ~p">>).
-define(sql_del_red_envelopes_by_stime,
    <<"delete from red_envelopes where status > 0 and stime <= ~p">>).
-define(sql_del_nosend_red_envelopes_by_ctime,
    <<"delete from red_envelopes where status = 0 and ctime <= ~p">>).
-define(sql_del_red_envelopes_recipients_record_by_stime,
    <<"delete from red_envelopes_recipients_record where stime <= ~p">>).
-define(sql_del_red_envelopes_by_ids,
    <<"delete from red_envelopes where id in (~s)">>).
-define(sql_del_red_envelopes_record_by_ownership_id,
    <<"delete from red_envelopes_recipients_record where ownership_id = ~p">>).