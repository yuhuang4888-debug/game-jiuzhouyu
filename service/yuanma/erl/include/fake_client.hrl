%% ---------------------------------------------------------------------------
%% @doc 
%% @author lxl
%% @since  
%% @deprecated 伪造客户端
%% ---------------------------------------------------------------------------

%% 行为定义
-define(BEHAVIOUR_WAIT,            0).     % 等待状态
-define(BEHAVIOUR_IDEL,            1).     % 空闲中
-define(BEHAVIOUR_MOVE,            2).     % 移动中
-define(BEHAVIOUR_BATTLE,          3).     % 攻击中
-define(BEHAVIOUR_MOVE_COLLECT,    4).     % 走去采集点|拾取点
-define(BEHAVIOUR_IN_COLLECT,      5).     % 采集中
-define(BEHAVIOUR_IN_REVIVE,       6).     % 复活中
-define(BEHAVIOUR_IN_PICK,         7).     % 拾取中

%% 时间定义
-define(DEFAULT_IDLE_TIME,         5000).     % 空闲时长

-define(ON_HOOK_BEHAVIOR,          behavior). %行为树控制
-define(ON_HOOK_STATE_M,           state_m).  %状态机控制

-record(fake_client, {
		start_client = 0                 %% 是否开启了客户端功能
        , behaviour = 0                  %% 行为
        , behaviour_ref = undefined  %% 行为定时器
        , att_target = undefined          %% 攻击目标
        , last_ten_xy = []
        , scene_object_data = #{}      %% 场景数据 #{user => #{}, object => #{}}
        , forbid_clt_mon = []          %% 禁止采集列表
        , att_skill_data = undefined   %% 攻击技能数据
        , drop_goods_data = #{}        %% 掉落包 #{DropId => #ets_drop{}}
        , forbid_pick = []             %% 禁止拾取的掉落包id [{id, IdList}]
        , in_module = 0                %% 处于哪个功能
        , in_sub_module = 0            %% 子功能id
        , module_data = undefined       %% 模块数据
        , module_rewards = []          %% 活动奖励
        , cost_info = {0, 0, 0}         %% 活动消耗的{钻石, 绑钻, 金币}
        , add_exp = 0                   %% 活动获得的经验|最后连同module_rewards一起发放
        , begin_hook_coin = 0           %% 开始托管时消耗的托管币数
    }).

-record(att_target, {
		key = 0             % key: user|object|module_object|module_user
        , id = 0                  %% id
        , mon_id = 0
        , x = 0
        , y = 0
    }).

-record(att_skill_data, {
		skill_cd = []
        , last_skill_id = 0    
        , skill_link = []
    }).
