%% ---------------------------------------------------------------------------
%% @doc supreme.erl

%% @author  hjh
%% @email  hejiahua@163.com
%% @since  2019-07-20
%% @deprecated 至尊vip配置
%% ---------------------------------------------------------------------------

-define(SUPVIP_KV(Key), data_supreme_vip:get_kv(Key)). 

-define(SUPVIP_KV_EX_COST, ?SUPVIP_KV(1)).      % 至尊vip体验消耗##[{Type,GoodsTypeId,Num}]
-define(SUPVIP_KV_EX_TIME, ?SUPVIP_KV(2)).      % 至尊vip体验时长##秒
-define(SUPVIP_KV_UP_FOREVER_COST, ?SUPVIP_KV(3)).   % 直升至尊vip永久的消耗##[{Type,GoodsTypeId,Num}]
-define(SUPVIP_KV_UP_FOREVER_RECHARGE, ?SUPVIP_KV(4)).  % 直升至尊vip永久的充值##{每日充值, 累计天数}
-define(SUPVIP_KV_BUY_EX_NEED_LV, ?SUPVIP_KV(5)).  % 购买体验等级
-define(SUPVIP_KV_BUY_EX_NEED_VIP_LV, ?SUPVIP_KV(6)).  % 购买体验vip等级限制
-define(SUPVIP_KV_CURRENCY_RATIO, ?SUPVIP_KV(7)).  % 充值元宝至尊币系数##体验永久可以触发,至尊币=充值元宝*系数
% -define(SUPVIP_KV_DAILY_REWARD, ?SUPVIP_KV(5)). % 每日礼包奖励##[{Type,GoodsTypeId,Num}]

% 奖励领取
-define(SUPVIP_CAN_NOT_GET, 0). % 不可领取
-define(SUPVIP_CAN_GET, 1).     % 可领取
-define(SUPVIP_HAD_GET, 2).     % 已经领取

%% 提交
-define(SUPVIP_COMMIT_NO, 0).   % 没有提交
-define(SUPVIP_COMMIT_YES, 1).  % 提交了

%% 完成
-define(SUPVIP_FINISH_NO, 0).   % 没有完成
-define(SUPVIP_FINISH_YES, 1).  % 完成了

%% 至尊vip
-record(status_supvip, {
        supvip_type = 0         % 0:无;1:体验vip;2:永久vip
        , supvip_time = 0       % 至尊vip过期时间##
        , active_time = 0       % 至尊vip体验首次激活
        , charge_day = 0        % 充值天数##根据当天充值计算
        , today_gold = 0        % 今天充值数
        , today_gold_utime = 0  % 今天充值更新时间
        , ex_ref = none         % 至尊vip体验定时器
        , right_list = []       % 特权列表
        , skill_stage = 0       % 技能阶段
        , skill_sub_stage = 0   % 技能子阶段
        , skill_task_list = []  % 技能任务记录[#supvip_skill_task{}]
        , skill_list = []       % 总技能
        , skill_attr = []       % 技能属性
        , skill_power = 0       % 技能战力
        , exp_ratio = 0         % 经验加成比率
        , total_attr = []       % 属性汇总
        , passive_skills = []   % 被动技能列表##[{SkillId,Lv}]
        , skill_effect_list = []    % 技能效果记录[#supvip_skill_effect{}]
        , currency_task_list = []   % 至尊币阶段记录[#supvip_currency_task{}]
        , days_utime = 0        % 登录天数的更新时间
        , login_days = 0        % 登录天数
    }).

%% 特权记录
-record(supvip_right, {
        right_type = 0          % 特权类型
        , data = []             % 数据
        , utime = 0             % 更新时间
    }).

%% 技能阶段
%% content
%%  技能任务宏定义处理
-record(supvip_skill_task, {
        task_id = 0             % 任务id
        , is_finish = 0         % 是否完成
        , is_commit = 0         % 是否提交
        , content = []          % 内容##主键是条件
    }).

%% 技能效果
-record(supvip_skill_effect, {
        id = {0, 0}             % 主键{skill_id, effect_id}
        , skill_id = 0          % 技能id
        , effect_id = 0         % buffid
        , data = []             % 数据
        , utime = 0             % 更新时间
    }).

%% 至尊币任务
%% content
%%  至尊币任务宏定义处理
-record(supvip_currency_task, {
        task_id = 0             % 任务id
        , is_finish = 0         % 是否完成
        , is_commit = 0         % 是否提交
        , content = []          % 内容##主键是条件
        , utime = 0             % 更新时间
    }).

%% 类型
-define(SUPVIP_TYPE_NO, 0).        % 无
-define(SUPVIP_TYPE_EX, 1).        % 体验
-define(SUPVIP_TYPE_FOREVER, 2).   % 永久

%% 特权类型
-define(SUPVIP_RIGHT_MARK, 1).                  % 标识
-define(SUPVIP_RIGHT_FORBIDDEN_ANGER, 2).       % 蛮换怒气值
-define(SUPVIP_RIGHT_PK_SAFE, 3).               % pk安全时间
-define(SUPVIP_RIGHT_RED_EQUIP_RATIO, 4).       % 红装成功率提升
-define(SUPVIP_RIGHT_ORANGE_DROP_NUM, 5).       % 橙色2及以上装备掉落提升的数量##针对某些boss,参数=[{掉落规则id,数量,万分比}...]
-define(SUPVIP_RIGHT_SHOP, 6).                  % 至尊币商店
-define(SUPVIP_RIGHT_VIP_BOSS_COUNT, 7).        % 个人boss次数上限
-define(SUPVIP_RIGHT_DAILY_REWARD, 8).          % 日常奖励

% <br>5:(1)参数:[{掉落规则id,数量,万分比}...]
% <br>8:(1)参数:奖励列表[{Type, GoodsTypeId, Num}]

%% 至尊vip特权
-record(base_supreme_vip, {
        supvip_type = 0         % 至尊vip类型
        , right_type = 0        % 特权类型
        , name = ""             % 名字
        , desc = ""             % 描述
        , value = 0             % 值
        , args = []             % 对应的参数
    }).

%% 至尊vip技能
-record(base_supreme_vip_skill, {
        stage = 0               % 阶段
        , sub_stage = 0         % 子阶段
        , attr = []             % 属性
        , skill_list = []       % 技能列表
    }).

%% buff效果
-define(SUPVIP_SKILL_EFFECT_ONHOOK_TIME, 1).    % 增加挂机时间  

%% 至尊vip技能特殊效果
%% effect
% <br>{1, AddTime}:每日4点后玩家在线或首次登陆会增加AddTime小时离线挂机时间
-record(base_supreme_vip_skill_effect, {
        skill_id = 0            % 技能id
        , effect_list = []      % 技能效果
    }).

%% 技能任务
-define(SUPVIP_SKILL_TASK_EQUIP_STREN, 1).      % N件装备强化+M以上##{1,N,M}
-define(SUPVIP_SKILL_TASK_TRAIN, 2).            % N养成功能升阶至M阶##{2,N,M}
-define(SUPVIP_SKILL_TASK_RUNE_DUN, 3).         % 通关符文本第N层##{3,N}
-define(SUPVIP_SKILL_TASK_DUN_COUNT, 4).        % 完成N次M副本(材料、金币、经验)##{4,N,M}
-define(SUPVIP_SKILL_TASK_MEDAL_ID, 5).         % 勋章提升至N阶##{5,N}
-define(SUPVIP_SKILL_TASK_RECHARGE, 6).         % 充值任意金额N天##{6,N}
-define(SUPVIP_SKILL_TASK_TURN, 7).             % 完成N转##{7,N}##{7,N}##{7,N}
-define(SUPVIP_SKILL_TASK_KILL_BOSS, 8).        % 击败M级以上Y类型(世界boss等)N次##{8,N,M,Y}##{8,N}##{8,N}
-define(SUPVIP_SKILL_TASK_MOUNT_EQUIP, 9).      % 穿戴N件M(坐骑/伙伴)装备##{9,N,M}##{9,N}##{9,N}
-define(SUPVIP_SKILL_TASK_ETERNAL_VALLEY, 10).  % 激活N本契约之书##{10,N}##{10,N}##{10,N}
-define(SUPVIP_SKILL_TASK_ACHI_LV, 11).         % 成就等级##{11,N}##{11,N}##{11,N}
-define(SUPVIP_SKILL_TASK_MOUNT_FIGURE, 12).    % 激活M功能(坐骑,伙伴,法阵...)N个幻化外形##{12, N, M}##{12,N}##{12,N}
-define(SUPVIP_SKILL_TASK_DRAGON_EQUIP, 13).    % 装备M品质Y类型N个龙纹##{13,N,M,Y}##{13,N}##{13,N}
-define(SUPVIP_SKILL_TASK_BABY_LV, 14).         % 宝宝培养至N级##{14,N}##{14,N}##{14,N}
-define(SUPVIP_SKILL_TASK_GOD_EQUIP, 15).       % N件装备神装打造至M级#{15,N,M}##{15,N}##{15,N}
-define(SUPVIP_SKILL_TASK_GOD_NUM, 16).         % 激活N个降神##{16,N}##{16,N}##{16,N}
-define(SUPVIP_SKILL_TASK_DECORATION_STAGE, 17).% 任意幻饰升至N阶##{17,N}##{17,N}##{17,N}
-define(SUPVIP_SKILL_TASK_INVESTMENT, 18).      % 购买N类型投资##{18,N}##{18,N}##{18,N} 
-define(SUPVIP_SKILL_TASK_BABY_FIGURE, 19).     % 宝宝N个幻化外形##{19,N}##{19,N}##{19,N}
-define(SUPVIP_SKILL_TASK_PINK_EQUIP, 20).      % 穿戴粉红色装备N件##{20,N}##{20,N}##{20,N}
-define(SUPVIP_SKILL_TASK_REVELATION_EQUIP, 21).% 激活任意天启N件套##{21,N}##{21,N}##{21,N}
-define(SUPVIP_SKILL_TASK_REVELATION_EQUIP_SUIT, 22).% 激活M类型天启套装N件##{22,N,M}##{22,N}##{22,N}
-define(SUPVIP_SKILL_TASK_DEMONS, 23).          % 激活N个使魔##{23,N}##{23,N}##{23,N}
-define(SUPVIP_SKILL_TASK_DEMONS_SKILL, 24).    % 装备M品质使魔技能N种##{24,N,M}##{24,N}##{24,N}
-define(SUPVIP_SKILL_TASK_LOGIN_DAYS, 25).      % 累计登录N天##{25,N}##{25,N}##{25,N}
-define(SUPVIP_SKILL_TASK_SANCTUM, 26).         % 参与N次永恒圣殿玩法##{26,N}##{26,N}##{26,N,更新时间}
%% yyhx_3d 新加任务类型
-define(SUPVIP_SKILL_TASK_COMPANION_ACTIVE, 27).% 激活xx伙伴
-define(SUPVIP_SKILL_TASK_COMPANION_NUM, 28).   % 激活N个伙伴
-define(SUPVIP_SKILL_TASK_COMPOSE_PINK,  29).   % 合成n件粉装
-define(SUPVIP_SKILL_TASK_DRAGON_POS,    30).   % 龙纹槽位
-define(SUPVIP_SKILL_TASK_DEMONS_GOODS,  31).   % 获取使魔技能书
-define(SUPVIP_SKILL_TASK_EQUIP_STREN_SUM,32).  % 装备强化总等级

%% 后台备注
% <br>描述##配置##客户端格式##服务端格式
% <br>N件装备强化+M以上##{1,N,M}##{1,N}##{1,N}
% <br>M养成功能升阶至N阶##{2,N,M}##{2,N}##{2,N}
% <br>通关符文本第N层##{3,N}##{3,N}##{3,M}
% <br>完成N次M副本(材料、金币、经验)##{4,N,M}##{4,N}##{4,N}
% <br>勋章提升至N阶##{5,N}##{5,N}##{5,N}
% <br>充值任意金额N天##{6,N}##{6,N}##{6,N,更新时间}
% <br>完成N转##{7,N}##{7,N}##{7,N}
% <br>击败M级以上Y类型(世界boss等)N次##{8,N,M,Y}##{8,N}##{8,N}
% <br>穿戴N件M(坐骑/伙伴)装备##{9,N,M}##{9,N}##{9,N}
% <br>激活N本契约之书##{10,N}##{10,N}##{10,N}
% <br>成就等级##{11,N}##{11,N}##{11,N}
% <br>激活M功能(坐骑,伙伴,法阵...)N个幻化外形##{12, N, M}##{12,N}##{12,N}
% <br>装备M品质Y类型N个龙纹##{13,N,M,Y}##{13,N}##{13,N}
% <br>宝宝培养至N级##{14,N}##{14,N}##{14,N}
% <br>N件装备神装打造至M级#{15,N,M}##{15,N}##{15,N}
% <br>激活N个降神##{16,N}##{16,N}##{16,N}
% <br>任意幻饰升至N阶##{17,N}##{17,N}##{17,N}
% <br>购买N类型投资##{18,N}##{18,N}##{18,N} 
% <br>宝宝N个幻化外形##{19,N}##{19,N}##{19,N}
% <br>穿戴粉红色装备N件##{20,N}##{20,N}##{20,N}
% <br>激活任意天启N件套##{21,N}##{21,N}##{21,N}
% <br>激活M类型天启套装N件##{22,N,M}##{22,N}##{22,N}
% <br>激活N个使魔##{23,N}##{23,N}##{23,N}
% <br>穿戴粉红色装备N件##{20,N}##{20,N}##{20,N}
% <br>装备M品质使魔技能N种##{24,N,M}##{24,N}##{24,N}
% <br>累计登录N天##{25,N}##{25,N}##{25,N}
% <br>参与N次永恒圣殿玩法##{26,N}##{26,N}##{26,N,更新时间}
% <br>激活xx伙伴##{27,N}##{27,1}##{27,N}
% <br>激活N个伙伴##{28,N}##{28,N}##{28,N}
% <br>合成粉装N次##{29,N}##{29,N}##{29,N}
% <br>龙纹开启N个孔##{30,N}##{30,N}##{30,N}
% <br>获得N本S级使魔天赋##{31,N}##{31,N}##{31,N}
% <br>装备强化总等级达到XX级##{32,N}##{32,N}##{32,N}

%% 至尊vip技能任务
-record(base_supreme_vip_skill_task, {
        stage = 0               % 阶段
        , task_id = 0           % 任务id
        , name = ""             % 名字
        , content = []          % 内容
        , reward = []           % 奖励
    }).

%% 至尊币任务
-define(SUPVIP_CURRENCY_TASK_RECHARGE, 1).  % 充值N钻石##{1,N}
-define(SUPVIP_CURRENCY_TASK_BUY_DUN, 2).   % 购买N次M副本(材料，金币，经验)##{2, N, M}
-define(SUPVIP_CURRENCY_TASK_KILL_BOSS, 3). % 击杀N个M类型boss(个人boss,世界boss,boss之家)##{3, N, M}
-define(SUPVIP_CURRENCY_TASK_ENTER, 4).     % 进入N次M玩法(蛮荒,秘境)##{4, N, M}
-define(SUPVIP_CURRENCY_TASK_HUSONG, 5).    % 护送N次##{5,N}
-define(SUPVIP_CURRENCY_TASK_COST, 6).      % 消耗N钻石##{6,N}
-define(SUPVIP_CURRENCY_TASK_DUN_COUNT, 7). % 完成N次M副本(材料、金币、经验)##{7,N,M}##{7,N}##{7,N}
-define(SUPVIP_CURRENCY_TASK_DUN_CLEAN, 8). % 扫荡N次M副本##{8,N,M}##{8,N}##{8,N}
-define(SUPVIP_CURRENCY_TASK_SEA_TREA,  9). % 参与璀璨之海N次##{9,N}##{9,N}##{9,N}

%% 后台备注
% <br>充值N钻石##{1,N}##{1,N}
% <br>购买N次M副本(材料，金币，经验)##{2, N, M}##{2,N}
% <br>击杀N个M类型boss(个人boss,世界boss,boss之家)##{3, N, M}##{3,N}
% <br>进入N次M玩法(蛮荒,秘境)##{4, N, M}##{4,N}
% <br>护送N次##{5,N}##{5,N}
% <br>消耗N钻石##{6,N}##{6,N}
% <br>完成N次M副本(材料、金币、经验)##{7,N,M}##{7,N}##{7,N}
% <br>扫荡N次M副本(伙伴)##{8,N,M}##{8,N}##{8,N}
% <br>参与璀璨之海N次##{9,N}##{9,N}##{9,N}

%% 至尊币任务
%% cond
% <br>{lv, Lv}:等级
% <br>{open_day, StartOpenDay, EndOpenDay}:开服天数
-record(base_supreme_vip_currency_task, {
        task_id = 0             % 任务id
        , name = ""             % 名字
        , condition = []        % 接任务条件
        , content = []          % 内容
        , reward = []           % 奖励
    }).

%% 至尊vip
-define(sql_role_supvip_select, <<"
    SELECT 
        supvip_type, supvip_time, active_time, charge_day, today_gold, today_gold_utime, skill_stage, skill_sub_stage, days_utime, login_days 
    FROM role_supvip WHERE role_id = ~p">>).
-define(sql_role_supvip_replace, <<"
    REPLACE INTO 
        role_supvip(role_id, supvip_type, supvip_time, active_time, charge_day, today_gold, today_gold_utime, skill_stage, skill_sub_stage, days_utime, login_days) 
    VALUES(~p, ~p, ~p, ~p, ~p, ~p, ~p, ~p, ~p, ~p, ~p)">>).

-define(sql_role_supvip_type_select, <<"SELECT supvip_type, supvip_time FROM role_supvip WHERE role_id = ~p">>).
-define(sql_role_supvip_offline_select, <<"SELECT supvip_type, supvip_time, skill_stage, skill_sub_stage FROM role_supvip WHERE role_id = ~p">>).

%% 至尊vip特权
-define(sql_role_supvip_right_select, <<"SELECT right_type, `data`, utime FROM role_supvip_right WHERE role_id = ~p">>).
-define(sql_role_supvip_right_replace, <<"REPLACE INTO role_supvip_right(role_id, right_type, `data`, utime) VALUES(~p, ~p, '~s', ~p)">>).

%% 至尊vip技能
-define(sql_role_supvip_skill_task_select, <<"SELECT task_id, is_finish, is_commit, content FROM role_supvip_skill_task WHERE role_id = ~p">>).
-define(sql_role_supvip_skill_task_replace, 
    <<"REPLACE INTO role_supvip_skill_task(role_id, task_id, is_finish, is_commit, content) VALUES(~p, ~p, ~p, ~p, '~s')">>).
-define(sql_role_supvip_skill_task_delete, <<"DELETE FROM role_supvip_skill_task WHERE role_id = ~p">>).

%% 至尊vip技能效果
-define(sql_role_supvip_skill_effect_select, <<"SELECT skill_id, effect_id, `data`, utime FROM role_supvip_skill_effect WHERE role_id = ~p">>).
-define(sql_role_supvip_skill_effect_replace, 
    <<"REPLACE INTO role_supvip_skill_effect(role_id, skill_id, effect_id, `data`, utime) VALUES(~p, ~p, ~p, '~s', ~p)">>).

%% 至尊币任务
-define(sql_role_supvip_currency_task_select, <<"SELECT task_id, is_finish, is_commit, content, utime FROM role_supvip_currency_task WHERE role_id = ~p">>).
-define(sql_role_supvip_currency_task_replace, <<"REPLACE INTO role_supvip_currency_task(role_id, task_id, is_finish, is_commit, content, utime) VALUES(~p, ~p, ~p, ~p, '~s', ~p)">>).
-define(sql_role_supvip_currency_task_delete, <<"DELETE FROM role_supvip_currency_task WHERE role_id = ~p and utime < ~p">>).