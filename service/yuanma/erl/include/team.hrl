%% ---------------------------------------------------------------------------
%% @doc team.hrl
%% @author ming_up@foxmail.com
%% @since  2016-11-02
%% @deprecated  组队模块记录
%% ---------------------------------------------------------------------------

%%------------------------------组队ETS宏定义---------------------------------
-define(ETS_TEAM, ets_team).                  %% 队伍缓存

%%------------------------------组队宏定义----------------------------------

-define(TEAM_NEED_LV, 1).                     %% 队伍等级开放条件
-define(TEAM_MEMBER_MAX, 3).                  %% 队伍最大人数

%% 队伍位置
-define(TEAM_LEADER, 1).                      %% 队长
-define(TEAM_MEMBER, 2).                      %% 队员
-define(TEAM_FAKER,  3).                      %% 假人

%% 队伍进入类型
-define(TEAM_JOIN_TYPE_NO, 1).              %% 不自动，要队长审核
-define(TEAM_JOIN_TYPE_AUTO, 2).            %% 自动同意进入队伍

-define(TEAM_JOIN_TYPE_TYPE_LIST, [
        ?TEAM_JOIN_TYPE_NO
        , ?TEAM_JOIN_TYPE_AUTO
    ]).

-define(CREATE_TYPE_NORMAL, 1).         %% 正常的创建
-define(CREATE_TYPE_TAKE_OVER, 2).      %% 因为队伍发生节点迁移而创造一个队伍来接管原来的队伍

-define(AUTO_START, 1). %% 自动开始
-define(NO_AUTO_START, 0). %% 不自动开始

%% 正式
% -define(FAKE_JOIN_IN_TIME, 15000).      %% 假人进入时间 ms
% %% 测试
% -define(FAKE_JOIN_IN_TIME, 10000).      %% 假人进入时间 ms

-define(FAKE_LEAVE_TIME, 600000).       %% 假人离队时间 ms

%% 队伍暂离成员列表
-record(ets_tmb_offline, {
        id = 0,                             %% 角色id
        team_pid = none,                    %% 组队进程pid
        offtime = 0,                        %% 离线时间
        dungeon_scene = 0,                  %% 离开时副本的场景id
        dungeon_pid = none,                 %% 副本进程
        dungeon_begin_sid = 0               %% 副本刚开始id
    }).

-record(waiting_status, {
        time = 0,
        info = undefined,
        msg_list = []
    }).

%% 检查##操作的检查
-record(after_check, {
        id = 0 :: integer(),
        pass = 0 :: integer(),                    %% 1 通过 0 未通过
        what2do :: term(),                        %% 执行操作的参数匹配 见 lib_team_mod:handle_after_check
        args = [] :: term(),
        ready_list = [] :: list(),
        timeout_ref :: reference()
    }).

%%队伍资料
-record(team, {
        id = 0,                             %% 队伍id
        pid = 0,                            %% 队伍进程pid
        cls_type = 0,                       %% 队伍所在节点 0 游戏节点 1 中心节点
        leader_id = 0,                      %% 队长玩家id
        leader_pid = none,                  %% 队长pid
        leader_node = undefined,            %% 队长所在节点(本服为undefined)
        name = "",                          %% 队名
        member = [],                        %% 队员列表
        free_location = [],                 %% 空闲位置
        join_type = ?TEAM_JOIN_TYPE_NO,     %% 队员加入类型##1:不自动，要队长审核2:自动同意进入队伍
        auto_type = 1,                      %% 活动开启类型 0:不自动，1:自动开始
        create_type = 0,                    %% 0:普通创建；2:副本创建
        is_allow_mem_invite = 0,            %% 队员邀请玩家加入队伍(0:不允许，1:允许)
        arbitrate = undefined,              %% 队伍仲裁记录 include/team.hrl #team_arbitrate{}
        dungeon = undefined,                %% 队伍副本相关参数 include/team.hrl #team_dungeon{}
        enlist = undefined,                 %% 队伍招募相关参数 include/team.hrl #team_enlist{}
        target_enlist = undefined,          %% 队伍目标相关参数 include/team.hrl #team_enlist{}
        arbitrate_result_ref = 0,           %% 投票系统定时器
        arbitrate_result_op_ref = 0,        %% (未做)投票系统超时操作定时器##比投票系统定时器要小,为了处理超时的处理
        fake_mb_ref,                        %% 假队员进队定时器
        %% bonfire_ids = [],                   %% 队伍篝火id列表
        %% barbecue = {0, 0},                  %% 最终加成和结束时间
        %% barbecue_ref = undefined,           %% 烤肉buff检查定时器
        rela = [],                          %% 亲密度列表[{IdA, IdB, Rela}...]
        pre_num_full = 0,                   %% 藏宝图副本首次满4人之后不允许再新增人员 每次进藏宝图副本都是重新建队，暂时不用考虑重置
        his_teammate = [],                  %%  藏宝图副本记录队伍历史人员，不允许再次邀请玩家进入队伍,服务端未做处理，由客户端限制
        %% is_flagwar = 0,                     %% 0不在夺旗战场中 1在夺旗战场中
        % lock_type = 0,                      %% 0未上锁 1夺旗战场锁住队伍
        % lock_ref = none,
        reqlist = [],                       %% 申请列表
        lv_limit_min = 0,                   %% 最小等级限制
        lv_limit_max = 0,                   %% 最大等级限制
        join_con_value = 0,                 %% 入队条件参数
        is_matching = 0,                    %% 是否正在自动匹配 0否 1是
        match_st = 0,                       %% 匹配开始时间
        delay_update_ref = undefined,       %% 延迟处理队员发生变化的计时器
        max_num = ?TEAM_MEMBER_MAX,         %% 最大组队人数
        team_skill = [],                    %% 荆棘之心：队伍谁有这个技能[{Id, Skill}]
        waiting_status = []                 %% 有些请求需要别的进程完成后，才能继续操作，因此在请求后，保存个状态
        , after_check = undefined           %% 检查##进入玩法的检查
    }).

%% 队伍仲裁
-record(team_arbitrate, {
        id = 0,                             %% id
        agree_num = 0,                      %% 同意玩家数量
        refuse_num = 0,                     %% 拒绝玩家数量
        vote_list = [],                     %% 投票 [{RoleId, 投票结果(0:不赞同1:赞同)}]
        end_time = 0                        %% 结束时间
    }).

%% 投票信息
-record (vote_info, {
        role_id = 0,                       %% 玩家id
        res = 0                            %% 投票结果 0拒绝 1接受
    }).

%% 队伍副本数据
-record(team_dungeon, {
        dun_id=0,                           %% 副本id
        dun_pid=0                           %% 副本进程pid mod_dungeon
    }).

%% 活动大类id
-define(ACTIVITY_ID_NO, 1).                 %% 无目标
-define(ACTIVITY_ID_EQUIP, 5).              %% 装备本
-define(ACTIVITY_ID_DRAGON, 6).             %% 龙纹本
-define(ACTIVITY_ID_WEEKDUN, 7).            %% 周常副本
-define(ACTIVITY_ID_BEINGS_GATE, 9).        %% 众生之门
-define(ACTIVITY_ID_NIGHT_GHOST, 10).       %% 百鬼夜行

%% 队伍招募面板数据
%% PS:队伍逻辑根据模块id和模块子模块进行处理
-record(team_enlist, {
        activity_id = 0,                    %% 活动大类id##作为排序
        subtype_id = 0,                     %% 活动子类id
        module_id = 0,                      %% 模块id
        sub_module = 0,                     %% 模块子id
        dun_id = 0,                         %% 副本id
        scene_id = 0                        %% 相关场景id
    }).

%% 队伍招募面板数据配置
-record(team_enlist_cfg, {
        activity_id = 0,                    %% 活动大类id##作为排序
        subtype_id = 0,                     %% 活动子类id
        module_id = 0,                      %% 模块id
        sub_module = 0,                     %% 模块子id
        dun_id = 0,                         %% 副本id
        scene_id = 0,                       %% 相关场景id
        activity_name = "",                 %% 目标名
        subtype_name = "",                  %% 目标子名
        auto_pos = [],                      %% 自动挂机点
        default_lv_min = 0,                 %% 等级下限
        default_lv_max = 0,                 %% 等级上限
        auto_pair = 1,                      %% 是否自动匹配
        exp_scale_type = 1,                 %% 经验加成类型 0不加成 1同场景加成 2同队伍加成
        num = ?TEAM_MEMBER_MAX,             %% 人数要求
        match_fake_man = 0,                 %% 是否匹配假人
        is_zone_mod = 0                     %% 是否248分服模式匹配
    }).

%% ----------------------- 助战类型 -----------------------
%% 副本通用:助战是没有奖励的,没有篝火.
-define(HELP_TYPE_NO, 0).                     %% 非助战
-define(HELP_TYPE_YES, 1).                    %% 助战
-define(HELP_TYPE_ASSIST, 2).             %% 协助(不扣次数)

-define(HELP_TYPE_TRANS_ANY, 1).              %% 任意都替换
-define(HELP_TYPE_TRANS_NOT_ENOUGH, 2).       %% 不够次数才转换

%%队员数据
-record(mb, {
        id = 0,                             %% 队员id
        node = undefined,                   %% 队员所在节点
        server_id = 0,                      %% 服务器id
        platform="",                        %% 平台
        server_num=0,                       %% 服数
        figure=undefined,                   %% 形象
        is_fake = 0,                        %% 是否假人
        %%          sid = 0,                            %% 玩家sid
        scene = 0,                          %% 队员场景
        scene_pool_id = 0,                  %% 队员场景进程池id
        copy_id = 0,                        %% 队员房间id
        power = 0,                          %% 战力
        join_value_list = [],               %% 入队参数
        location = 0,                       %% 队员位置
        picture = <<>>,                     %% 玩家上传的头像
        help_type = 0,                      %% 助战类型
        online = 1,                         %% 是否真实在线
        follow_id = 0,                      %% 跟战目标id
        follows = [],                       %% 跟战者ids
        join_time = undefined,              %% 入伍时间
        dungeon_id = 0,                     %% 现在在什么副本
        drop_ratio = 0,                     %% 每个人自己的自身掉落加成
        %% onhook_ref = undefined,             %% 离线挂机邀请队友
        skill = 0,                          %% 玩家特殊的被动技能11000012
        target_start_data = []              %% 开始参数
        ,match_ok = 0
        ,lock = free
        ,agree_ref = none                   %% 投票同意定时器
        ,task_map = #{}                     %% 特殊任务 #{taskid := 1}, 1某人接取, 没有则没有接
        ,share_skill_list = []              %% 共享技能列表##目前只支持被动,不要塞其他的进来
    }).

-record (slim_mb, {
        id = 0,
        scene = 0,
        online = 1
    }).

%% 队伍进程id缓存
-record(ets_team, {
        team_id = 0,
        pid = 0
    }).

%% 玩家缓存
-record(status_team, {
        team_id = 0,                        %% 队伍id
        team_pid = undefined,               %% 队伍pid
        positon = 0,                        %% 队伍职位(?TEAM_LEADER | ?TEAM_MEMBER)
        reqlist = [],                       %% 请求进入的队伍列表
        exp_scale = 0,                      %% 组队经验加成 千分数
        team_skill = 0,                     %% 玩家队伍临时技能:11000012(荆棘之心)
        skill_num = 0,                      %% 拥有技能11000012的玩家数量
        cls_create_time = 0,                %% 跨服队伍组建时间
        arbitrate_info = [],                %% 正在进行的投票信息
        match_info = [],                    %% 正在进行的投票信息
        intimacy_lv = 0                     %% 好友度等级
        ,match_after_created = false        %% 创建后匹配
    }).


-define(MAX_LV, 999).   %% 目前最大等级