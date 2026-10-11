%%%--------------------------------------
%%% @Module  : husong.hrl
%%% @Author  : huyihao
%%% @Created : 2018.01.06
%%% @Description:  护送
%%%--------------------------------------

-define(HuSongOpenLv, 130).                             % 护送开启时间
-define(HuSongSucessFirstExp, 50).
-define(HuSongSucessFinalExp, 60).
-define(HuSongFreeDailyId, 1).                          % 每日可免费刷新的次数
-define(HuSongDailyId, 2).                              % 每日可护送次数
-define(HuSongTakeDailyId, 3).                          % 每日可拦截次数
-define(HuSongTakeExpDailyId, 4).                       % 每日拦截获得经验
-define(HuSongTakeCoinDailyId, 5).                      % 每日拦截获得铜币
-define(HuSongBestCounterId, 1).                        % 完成最高品质天使护送次数获得称号
-define(HuSongFirstRefleshCounterId, 2).                % 第一次刷新护送天使
-define(HuSongFirstOpenCounterId, 3).                   % 第一次打开护送
-define(HuSongRefleshCost, [{0, 38040020, 1}]).         % 护送刷新消耗
-define(HuSongScene, 5181).                             % 目标场景ID
-define(HuSongTime, 60).                                % 护送时间
-define(HuSongAskHelpCD, 30).                           % 求助冷却cd
-define(HuSongFirstSuccessRewardPercent, 40).
-define(HuSongSecondSuccessRewardPercent, 60).
-define(HuSongFirstFailRewardPercent, 20).
-define(HuSongSecondFailRewardPercent, 30).
-define(HuSongTakeRewardPercent, 10).
-define(HuSongInvincibleSkillNum, 1).
-define(HuSongInvincibleSkillId, 24000001).            % 护送技能
-define(HuSongDesignationId, 400001).
-define(HuSongExpFun(Lv, Exp), round(math:pow(1.5, (Lv-60)/120) * 174679200 * Exp/1000) ).   % 护送经验加成
-define(HuSongSceneId , 1003).                          % 护送任务场景

-record(husong, {
    role_id = 0,                % 玩家id
    angel_id = 0,               % 天使id
    reward_stage = 0,           % 阶段完成状态：0没有完成阶段一 1完成阶段一
    stage = 0,                  % 阶段
    start_time = 0,             % 开始护送时间 0为不在护送期间
    end_timer = 0,              % 结束时间
    invincible_skill = 0,       % 庇护次数（一次护送庇护一次）
    ask_help_time = 0           % 求助时间
}).

-record(husong_angel_con, {     % base_husong_angel
    angel_id = 0,               % 天使id
    name = "",                  % 天使名字
    rand_list = [],             % 刷新权重列表
    other_reward_list = [],     % 额外权重列表
    coin = 0,                   % 金币奖励
    exp = 0  ,                  % 经验系数
    cost = []                   % 消耗道具
}).

-record(husong_position_con, {    % base_husong_position
    id = 0,
    x = 0,
    y = 0
}).
%% 获取护送玩家信息记录表
-define(SelectHuSongPlayerSql,
    <<"SELECT `role_id`, `angel_id`, `stage`, `reward_stage`, `start_time`, `invincible_skill`, `ask_help_time` FROM `husong_player` WHERE `role_id` = ~p">>).

%% 更新护送玩家数据
-define(ReplaceHuSongPlayerSql,
    <<"REPLACE INTO `husong_player` (`role_id`, `angel_id`, `stage`, `reward_stage`, `start_time`, `invincible_skill`, `ask_help_time`) values (~p, ~p, ~p, ~p, ~p, ~p, ~p)">>).