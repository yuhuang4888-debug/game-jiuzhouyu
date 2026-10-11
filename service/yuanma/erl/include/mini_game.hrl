%%% ---------------------------------------------------------------------------
%%% @doc            mini_game.hrl
%%% @author         kyd
%%% @email          kuangyaode@qq.com
%%% @created        2021-04-19
%%% @description    小游戏头文件
%%% ---------------------------------------------------------------------------

%%% ================================ 宏变量 ================================

%% kv值
-define(MINI_GAME_KV(Key),      data_mini_game:get(Key)).

%% 小游戏类型
-define(GAME_NOTE_CRASH,        1).     % 音符碰撞(消消乐)
-define(GAME_RHYTHM_TALENT,     2).     % 节奏达人(节奏大师)

%% 通用
-define(GAME_START_SIGNAL,      0).     % 游戏开启信号
-define(SETTLE_TIME,            ?MINI_GAME_KV(5)).  % 游戏结算预留时间

%% 音符碰撞
-define(INITIALIZE,             0).     % 39921发送类型-初始化
-define(UPDATE,                 1).     % 39921发送类型-更新
-define(UP,                     1).     % 上
-define(RIGHT,                  2).     % 右
-define(DOWN,                   3).     % 下
-define(LEFT,                   4).     % 左
-define(DIRECTIONS,             [?UP, ?RIGHT, ?DOWN, ?LEFT]).
-define(DUR_NOTE_CRASH,         ?MINI_GAME_KV(7)).  % 游戏时间
-define(BOARD_SIZE,             ?MINI_GAME_KV(10)). % 棋盘大小

%% 节奏达人
-define(GRADE_PERFECT,          1).     % 分数评级:perfect
-define(GRADE_EXCELLENT,        2).     % 分数评级:excellent
-define(GRADE_GOOD,             3).     % 分数评级:good
-define(DUR_RHYTHM_TALENT,      ?MINI_GAME_KV(8)).  % 游戏时间
-define(SCORE_GRADES,           ?MINI_GAME_KV(3)).  % 单个鼓点分数等级
-define(TSCORE_GRADES,          ?MINI_GAME_KV(9)).  % 总分等级

%%% ================================ 配置数据record ================================

%% 鼓点配置
-record(base_rhythm_talent, {
    id          = 0     % 配置id(歌曲id)
    ,beat_id    = 0     % 鼓点id
    ,type       = 0     % 鼓点类型
    ,time       = 0     % 出现相对时间
    ,speed      = 0     % 移动速度 单位:px/s
}).

%%% ================================ 普通数据record ================================

%% 小游戏玩家
-record(mini_game_player, {
    id              = 0         % 玩家id
    ,lv             = 0         % 玩家等级
    ,name           = ""        % 玩家名
    ,pic            = ""        % 头像地址
    ,pic_ver        = 0         % 头像版本号
    ,gid            = 0         % 军团等级
    ,gname          = ""        % 军团名
}).

%% 音符碰撞游戏进程状态
-record(note_crash_state, {
    module_id       = 0         % 模块id
    ,sub_id         = 0         % 子模块id
    ,player         = undefined % 对应玩家 #mini_game_player{}
    ,start_time     = 0         % 开启时间戳
    ,end_time       = 0         % 结束时间戳
    ,board          = #{}       % 棋盘 #{row => [note_id...]}
    ,effects        = []        % 特殊音符效果 [{x, y, type, param}...]
    ,rates          = []        % 音符倍率 [{note_id, rate}...]
    ,score          = 0         % 分数
    ,tref           = []        % 游戏计时器
}).

%% 节奏达人游戏进程状态
-record(rhythm_talent_state, {
    module_id       = 0         % 模块id
    ,sub_id         = 0         % 子模块id
    ,player         = undefined % 对应玩家 #mini_game_player{}
    ,start_time     = 0         % 开启时间戳
    ,song_id        = 0         % 歌曲配置id
    ,score_map      = #{}       % 鼓点分数映射
    ,tref           = []        % 游戏计时器
}).

%%% ================================ sql宏定义 ================================
