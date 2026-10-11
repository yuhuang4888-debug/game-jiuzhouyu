%%% ------------------------------------------------------------------------------------------------
%%% @doc            faker.hrl
%%% @author         lzh
%%% @email          lu13824949032@gmail.com
%%% @created        2021-06-05
%%% @description    假人生成头文件
%%% ------------------------------------------------------------------------------------------------

%%% ======================================== general records =======================================

%% 构造假人参数
-record(make_faker_args, {
    server_id            = 0
    , server_num         = 0
    , server_name        = []
    , power_range        = []     % 战力范围
    , lv_range           = []     % 等级范围
    , turn_range         = []     % 转生数范围
    , appellation_range  = []     % 勋章范围
    , mount_list         = []     % 随机坐骑模型列表
    , wing_list          = []     % 随机翅膀模型列表
    , holyorgan_list     = []     % 随机神兵模型列表
    , attr_coe           = []     % 属性系数
    , companion_list     = []     % 随机使徒ID列表
    % , companion_lv_range = []     % 使徒随机等级
    % , companion_attr_coe = []     % 使徒属性系数
    , other              = #{}    % 其它模块特殊参数
}).

%% 假人参数
-record(faker_info, {
    role_id          = 0
    , server_id      = 0
    , server_num     = 0
    , server_name    = []
    , figure         = undefined    % #figure{}(figure.hrl)
    , combat_power   = 0
    , active_skills  = []
    , passive_skills = []
    , battle_attr    = undefined    % #battle_attr(battle.hrl)
    % , ob_companion  = undefined
    , other          = #{}
}).