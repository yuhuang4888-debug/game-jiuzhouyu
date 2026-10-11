%% ---------------------------------------------------------------------------
%% @doc server.hrl

%% @author ming_up@foxmail.com
%% @since  2016-04-06
%% @deprecated 功能性record保存在独立文件就可以了，在mod_login:server_login处初始化
%% ---------------------------------------------------------------------------
-define(ETS_ONLINE, ets_online).                   % 在线列表
-define(ETS_ROLE_FUNC_CHECK, ets_role_func_check). % 玩家在线功能定时检测超时的数据
-define(ETS_FUNC_GM_CLOSE, ets_func_gm_close).     % 秘籍关闭功能
-define(ACTION_SOFT_LOCK_TIME, 10). % 玩家在线功能定时检测超时的数据

-define(QUICKBAR, [1, 2, 3, 4, 5]).     % 快捷栏
-define(QUICKBAR_TYPE_GOODS, 1).        % 物品
-define(QUICKBAR_TYPE_SKILL, 2).        % 技能
-define(QUICKBAR_TYPE_ACTION, 3).       % 动作

%% #player_status.mark 用法
-define(MARK_SELF_CHARGE, 2#00000001).          %% 自充值标记
-define(CHECK_MARK_WITH(Mark, CheckMark), Mark band CheckMark > 0).
-define(ADD_MARK(OldMark, Mark), OldMark bor Mark).
-define(REMOVE_MARK(OldMark, Mark), OldMark band (bnot Mark)).

-define(GM_CLOSE_MOD, 0).
-define(GM_OPEN_MOD,  1).

-define(GMCLOSE_FUN, 1).

%% 玩家身上的过期时间检查
-record(ets_role_func_check, {
          key_id = {0, 0},                       % {RoleId, FuncType} 每分钟检查一次
          end_times = []                         % 结束时间列表|或者结束时间点:例如称号功能[{称号id, 结束时间}...]
         }).

-record(ets_func_gm_close, {
          key = {0, 0}                           % {mod, sub_mod}
          ,mod = 0                               % 模块id
          ,sub_mod = 0                           % 模块子id
          ,status = 0                            % 状态 0正常/1关闭
     }).

%% 只为玩家统计用的，不要加别的字段进来了
-record(ets_online, {
          id  = 0,                               % 角色id
          pid = 0,                               % 玩家进程
          sid = undefined,                       % 发送进程
          tid = none                             % 任务进程
         }).

%%记录用户一些常用信息
-record(player_status, {
          id = 0,                                % 角色在本服id
          server_id = 0,                         % 角色所在的服务器id
          platform = "",                         % 平台标示
          server_num = 0,                        % 所在的服标示
          server_name = <<>>,                    % 选择服务器的名字
          reg_server_id = 0,                     % 选择服务器的服id
          c_server_msg = <<>>,                   % 客户端展示的服信息(二进制)##具体看运营填写，如 中文，数字，英文都能支持;需要支持服信息更新(lib_php_api:reload_c_server_msg)
          server_type = 0,                       % 服类型
          accid = 0,                             % 平台账号id
          accname = [],                          % 平台账号
          accname_sdk = [],                      % sdk平台账号
          acc_roles = [],                        % 同一账号下的角色id列表
          source="",                             % 渠道来源
          c_source="",                           % 客户端渠道来源
          is_simulator=false,                    % 是否模拟器登录
          mark = 0,                              % 特殊记号 0无 1自充值账号
          first_state = 0,                       % 账户首个角色|0未确定，1是，2否
          login_time_before_last = 0,            % 上一次登陆时间
          last_login_time = 0,                   % 最后登陆时间
          last_logout_time = 0,                  % 上一次退出游戏时间(unixtime，秒)
          login_days_status = undefined,         % 玩家累积登陆信息 #login_days_status{}
          socket = none,                         % socket
          sh_monitor_pkg = undefined,            % sh聊天监控动态包编号

          c_rename = 0,                          % 是否可以免费改名
          c_rename_time = 0,                     % 上次改名时间(unixtime，秒)

          ip = "",                               % ip地址 如 "0.0.0.0"
          online = 1,                            % 是否真实在线 0:离线;1:在线;2离线挂机中
          delay_logout_ref = undefined,          % 延迟登出定时器
          revive_ref = undefined,                % 玩家复活定时器
          onhook_gc_ref = undefined,             % 离线挂机玩家半小时gc一次
          onhook_fix_ref = undefined,            % 离线挂机玩家半小时修复检查一次
          combat_ref = undefined,                % 战力保存定时器
          figure=undefined,                      % 角色独有外观信息#figure{}(include/figure.hrl)
          battle_attr=undefined,                 % 基础战斗属性#battle_attr{}(include/attr.hrl)
          original_attr = undefined,             % 原始属性记录（没有经过换算）

          gold = 0,                              % 元宝
          bgold = 0,                             % 绑定元宝
          coin = 0,                              % 铜钱
          bcoin = 0,                             % 绑定铜钱
          gcoin = 0,                             % 公会货币
          chat  = undefined,                     % 聊天设置 #status_chat{}
          skill = undefined,                     % 技能 #status_skill{}(include/skill.hrl)
          goods = undefined,                     % 物品 #status_goods{}(include/goods.hrl)

          scene = 0,                             % 场景id
          scene_pool_id=0,                       % 场景进程id（一般在跨服或者单进程无法承载的时候使用，默认为0）
          copy_id = 0,                           % 同一场景不同房间标示（可以数字，字符串任意）
          pre_scene_time = 0,                    % 准备切换场景时间(在野外或者pk场景需要原地等待5秒)
          fin_change_scene = 0,                  % 切换场景完成(0否|1是)
          is_change_scene_log = 0,               % 是否需要场景切换日志(1是|0否):根据功能设置状态,一般只记录一次切换12002
          y = 0,                                 % x坐标(px)
          x = 0,                                 % y坐标(px)
          longitude = 0,                         % 经度
          latitude = 0,                          % 纬度
          old_scene_info=undefined,              % {OldScene, OldScenePooldId, OldCopyId, OldX, OldY}
          reconnect=0,                           % 活动玩法中重连 0否| 1正常登录重连| 2relogin重连
          login_type=0,                          % 登录类型 0否| 1正常登录 | 2relogin重连

          pid = undefined,                       % 玩家服务进程
          tid = undefined,                       % 任务进程id

          exp = 0,                               % 角色当前经验
          exp_lim = 0,                           % 当前等级经验上限
          talk_lim= 0,                           % 是否被禁言(0否,1是)
          talk_lim_time = 0,                     % 禁言截止时间
          quickbar = [],                         % 快捷栏[{Pos,Type,Id,Auto}]:Pos:位置 Type:类型(1物品,2技能,3动作) Id:对应类型的id Auto:是否自动施放
          team = undefined,                      % 队伍记录,登录会初始化为#status_team{} include/team.hrl

          cell_num = 0,                          % 背包格子数
          storage_num = 0,                       % 仓库格子数

          nor_att_time = 0,                      % 上次玩家普攻时间(ms)
          att_time = 0,                          % 上次攻击时间(ms)
          last_att_time = 0,                     % 上次攻击玩家单位时间(ms)
          last_beatt_time = 0,                   % 上次被玩家攻单位击间(ms)
          is_battle = 0,                         % 是否进入战斗状态
          last_be_kill = [],                     % 上一次击杀我的玩家信息(用于玩家上线0血提示)[{sign, 1|2}, {name, Name}, {lv, Lv}]

          leader = 0,                            % 是否队长
          is_pay = false,                        % 是否有充值，true为有充值, 只要充了钱都会设置为true
          last_pay_time = 0,                     % 最后充值时间
          reg_time = 0,                          % 注册时间
          sid = undefined,                       % 异步广播进程(这个只在玩家进程使用，其他进程不要保存这个值，因为登录重连都会改变)

          change_scene_sign = 0,                 % 排队换线标志
          leave_scene_sign = 0,                  % 离开场景标志(某些活动在进入排队前就已经切换成离开场景标识) 这种状态下不能攻击和受到玩家攻击
          dailypid = none,                       % 玩家日次数处理进程
          week_pid = none,                       % 玩家周次数处理进程
          counter_pid = none,                    % 玩家终生次数处理进程
          combat_power = 0,                      % 战斗力
          hightest_combat_power = 0,             % 历史最高战斗力
          hightest_combat_power_cd = 0,          % 历史最高战斗力cd结束时间戳

          sell = undefined,                      % 交易 #player_sell{}(include/rec_sell.hrl)
          achieve = undefined,                   % 成就 #status_achieve{}(include/achieve.hrl)

          picture_lim = 0,                       % 是否允许提交头像 0:不禁止,1:禁止
          picture_list = [],                     % 拥有的头像id列表
          act = [],                              % 活动
          npc_info = [],                         % npc信息([{NpcId, IsShow, SceneId, X, Y}])

          player_buff = undefined,               % 玩家身上的BUFF
          buff_attr = undefined,                 % BUFF属性
          dsgt_status = undefined,               % 称号状态 格式:#dsgt_status{}
          guild = undefined,                     % 公会 格式:#status_guild{}
          partner = undefined,                   % 伙伴 格式:#status_partner{}
          status_mount = [],                     % 外形 格式:[#status_mount{} ]
          mount_ref = none,                      % 外形计时器
          mount_equip = undefined,               % 坐骑装备 格式: #mount_equip{}
          status_wing = undefined,               % 翅膀 格式:#status_wing{}
          status_talisman = undefined,           % 法宝 格式:#status_talisman{}
          status_godweapon = undefined,          % 神兵 格式:#status_godweapon{}
          status_fairy = undefined,              % 小精灵 格式:#status_fairy{}
          status_companion = undefined,          % 伙伴 格式：#status_companion
          setting = undefined,                   % 设置 格式:#status_setting{}
          onhook = undefined,                    % 挂机 格式:#status_onhook{}
          check_in = undefined,                  % 签到 格式:#checkin_status{}
          online_reward = undefined,             % 在线奖励 格式:#status_online_reward{}
          off = undefined,                       % 离线数据(用于查看面板) 格式:#status_off{}
          dungeon = undefined,                   % 副本 格式#status_dungeon{}
          follows = [],                          % 跟随玩家列表
          follow_target_xy={0,0},                % 跟随目标xy
          follow_target_conut=0,                 % 坐标变更次数
          status_pushmail = undefined,           % 邮件推送 格式#status_pushmail{}
          lucky_cat = undefined,                 % 招财猫   格式#lucky_cat{}
          vip = undefined,                       % VIP  #role_vip{}(include/vip.hrl) 更新此值请同步更新#figure.vip_type
          is_reviving = 0,                       % 正在复活 0:没有复活,切场景重置 1:正在复活,复活时设置
          revive_status = undefined,             % 死亡CD 格式 #revive_status{}
          recharge_status = undefined,           % 充值    格式#recharge_status{}
          recharge_act_status = undefined,       % 充值活动 格式#recharge_act_status{}
          recharge_statistic = undefined,        % 充值统计 格式#role_recharge_statistic{}
          resource_back = undefined,             % 资源找回
          liveness_back = undefined,             % 活跃度找回 #liveness_back{} (include/activitycalen.hrl)
          partner_battle = undefined,            % 伙伴战斗 格式#status_partner_battle{}
          status_ac_custom = undefined,          % 定制活动 格式 #status_ac_custom{}
          rename = [],                           % 曾用名
          flower = undefined,                    % 鲜花 格式 #flower
          dress_up = undefined,                  % 个性装扮  格式 #status_dress_up{}
          st_liveness = undefined,               % 玩家活跃度 格式 #st_liveness{}
          client_ver = 0,                        % 客户端版本号
          reincarnation = undefined,             % 转生信息 #reincarnation{}
          awakening = undefined,                 % 天命觉醒 #awakening{}
          guild_skill = undefined,               % 公会技能学习 #status_guild_skill{}
          status_artifact = undefined,           % 神器 #status_artifact{}
          status_pet = undefined                 % 宠物 #status_pet{}
          ,dungeon_record = undefined            % 副本记录 #{DunId, RecData}
          ,help_type_setting = undefined         % 副本助战设置
          ,eudemons = undefined                  % 幻兽数据
          ,marriage = undefined                  % 结婚#marriage_status{}
          ,boss_tired = 0                        % 本服世界BOSS疲劳值(缓存型)
          ,temple_boss_tired = 0                 % 上古神庙疲劳值
          ,phantom_tired = 0                      % 幻兽领疲劳值
          ,rush_giftbag = undefined              % 冲级礼包 #rush_giftbag{}
          ,jjc_battle_pid = undefined            % 竞技战场进程
          ,jjc_honour = 0                        % 竞技荣誉值
          % 行为互斥锁 当前在某个活动中的时候，不能参与别的活动，无锁的时候为free 其余为:Code :: integer()
          ,action_lock = free                    % free | Code | {锁失效时间戳, Code}
          ,top_pk = undefined                    % 巅峰竞技
          ,eudemons_boss = undefined             % 跨服幻兽BOSS
          ,guild_war = undefined                 % 公会争霸
          ,investment = undefined                % 投资活动
          ,baby = undefined                      % 宝宝
          ,status_baby = undefined
          ,status_pray = undefined               % 祈愿
          ,treasure_chest = undefined            % 青云夺宝 #player_treasure_chest{}
          ,star_map_status = undefined           % 星图#star_map_status{}
          ,currency_map = undefined              % 特殊货币#{}
          ,husong = undefined                    % 护送 #husong{}
          ,status_custom_act = undefined         % 定制活动 #status_custom_act{}
          ,eternal_valley = #{}                  % 永恒碑谷 #{}
          ,login_reward = undefined              % 登录奖励
          ,fly_state = 0                         % 小飞鞋状态
          ,forbid_pk_etime = 0                   % 玩家禁止释放技能状态结束时间戳
          ,status_share = undefined              % 分享有礼
          ,last_task_id = 0                      % 上一次完成的主线任务id
          ,goods_buff_exp_ratio = 0              % 物品buff经验加成（实数,不是万分比！！注意, 0.5， 0.1 都有可能）
          ,mate_role_id = 0                      % 配对玩家id 目前是海滩约会对象的id 默认为0
          ,cloud_buy_list = []                   % 众仙云购
          ,battle_field = undefined              % 战场信息  #{mod_lib => ModLib, pid => Pid}
          ,collect_checker = undefined           % 采集过滤器
          ,fireworks = undefined                 % 烟花活动
          ,limit_shop = undefined                % 神秘限购
          ,last_transfer_time = 0                % 最后一次转职时间
          ,collect = undefined                   % 收集活动数据
          ,scene_hide_type = 0                   % 场景隐藏类型
          ,role_3v3                              % 3v3数据
          ,overflow_gift = #{}                   % 超值礼包信息
          ,spec_sell_act = #{}                   % 精品特卖
          ,house = undefined                     % 家园信息#house_status{}
          ,holy_ghost = undefined                % 圣灵 #status_holy_ghost{}
          ,drop_rule_modifier = undefined        % 掉落规则修改器
          ,bl_who = 0                            % 怪物归属
          ,te_status = undefined                 % 幸运鉴宝#te_status{}
          ,kf_1vn = undefined                    % 跨服1vn
          ,role_saint = undefined                % 圣者殿
          ,status_kf_guild_war = undefined       % 跨服公会战
          ,daily_turntable = undefined           % 每日活跃转盘
          ,enchantment_guard = undefined         % 结界守护
          ,status_boss = undefined               % boss信息#status_boss{}
          ,medal = undefined                     % 勋章信息#medal{}  medal.hrl
          ,mon_pic = undefined                   % 怪物图鉴
          ,anima_status = undefined              % 灵器 #anima_status{}
          ,train_object = #{}                    % 其他培养系统属性列表  #{AttSign => #scene_train_object{}}
          , mystery_shop = undefined             % 功能内商店 格式 #status_func{}
          , guild_battle = undefined             % 公会战
          , terri_status = undefined                % 跨服领土战
          , rune_hunt  =  undefined              % 符文寻宝
          , race_act = undefined                 % 竞榜活动[#race_act{}]
          , pk_map = #{}                         % pk状态保留(重新上线不读取) Key:SceneId Value:PkStatus
          , hire_status = undefined              % 神兵租借
          , invite = undefined                   % 邀请 #status_invite{}
          , status_achievement = []              % yyhx使用的成就，保存成就等级[{star, State}]
          , status_shake   = undefined           % 摇摇乐的信息 #status_shake
          , magic_circle   = []                  % 魔法阵[#magic_circle{}]  magic_circle.hrl
          , role_drum = undefined                % 钻石大战
          , pk_endtime = 0                       % pk结束时间戳
          , decoration = undefined               % 幻饰 #decoration
          , fairy = undefined                    % 精灵 #fairy
          , task_attr = undefined                % 任务属性
          , drop_task_id_list = []               % 掉落的任务id列表##只针对特定的任务id进行掉落
          , drop_task_stage_list = []            % 掉落的任务阶段列表##只针对特定的任务id进行掉落
          , open_module_list = []                % 开放的功能预告列表
          , attr_medicament = []                 % 属性药剂 /attr_medicament.hrl
          , arbitrament_status = undefined       % 圣裁
          , glad_battle_pid = undefined          % 竞技场战场的进程
          , strong_status = undefined            % 我要变强
          , rush_shop = undefined                % 抢购商城
          , limit_gift = []                      % 限时礼包
          , pk_status = undefined                % pk记录
          , custom_drop = #{}                    % 活动掉落每日统计key:{ActType, ActSubType, Type, GoodsTypeId} => num
          , seal_status = undefined              % #seal_status{} /seal.hrl
          , draconic_status = undefined          % #draconic_status{} /draconic.hrl
          , ca_liveness = undefined              % #status_ca_liveness{}
          , sanctuary_role_in_ps = undefined     % 圣域个人信息
          , kf_sanctuary_info = undefined        % 跨服圣域 #kf_sanctuary_info
          , sanctuary_cluster = undefined       % 跨服圣域 #status_sanctuary_cluster{}
          , status_surprise = undefined          % 惊喜礼包 #status_surprise
          , monday_bonus = undefined             % 周一大奖 #monday_bonus_data{}
          , draw_reward = undefined              % 赛博夺宝
          , dragon = undefined                   % 龍紋系統 格式 #status_dragon{}
          , dragon_cb = undefined                % 龍紋熔爐 格式 #status_dragon_cb{}
          , lv_act = undefined                   % 等级活动（等级抢购商城）#lv_act_state
          , dungeon_skill = undefined            % 副本技能 格式 #status_dungeon_skill{}
          , status_adventure = undefined         % 天天冒险
          , god = undefined                      % 降神 格式 #status_god{}
          , fest_investment = undefined          % 节日投资 []
          , status_demons = undefined            % 使魔
          , mod_buff = []                        % 功能提供的buff
          , hunt_task_list = []
		, festival_recharge = undefined        % 节日首冲 #festival_recharge{} /festival_recharge.hrl
	     , soul_dun = undefined                 % 聚魂本
          , holy_summon = undefined              % 神圣召唤 #role_act_holy_summon{} /holy_summon.hrl
          , player_die = #{}                     % 玩家通用死亡复活 mod => #mod_player_die{}
          , revelation_equip = undefined         % 天启装备 #role_revelation_equip{} /revelation_equip.hrl
          , pray_status = undefined              % pray_status{} 神佑祈愿
          , jjc = undefined                      % status_jjc{} 竞技场
          , demon_dun = undefined                % 使魔副本
          , login_merge_reward = undefined       % 合服登录奖励
          , supvip = undefined                    % 至尊vip #status_supvip{}
          , team_3v3 = undefined                 % 3v3战队
          , status_protect = undefined            % 免战保护 #status_protect{}
          , select_pool = #{}                    % 自选奖次抽奖
          , status_decoration_boss = undefined   % 幻饰boss #status_decoration_boss{}
          , beta_data = undefined                % 封测活动数据  #beta_data
          , beta_recharge_return = undefined     % 封测充值返还 #status_beta_recharge_return{}
          , bonus_pool = #{}                     % 许愿池
          , back_decoration_status = undefined   % 背饰
          , title = undefined                    % 头衔 #title
          , weekdun_status = undefined           % 周常副本个人信息
          , wx_share = undefined                 % 微信分享 #status_wx_share{}
          , spirit_rotary_status = undefined     % 精灵转盘
          , boss_rotary = undefined              % boss转盘
          , arcana = undefined                   % 上古禁术 #status_arcana{}
          , camp_id = 0                          % 阵营id
          , mask_status = undefined              % 蒙面 #mask_status{}
          , holy_spirit_battlefield = undefined  % 圣灵战场数据
          , constellation = undefined            % 星宿 #constellation_status{}
          , player_real_info = undefined         % 玩家真实信息
          , contract_buff = undefined            % 传说契约增益 #contract_buff{}
          , god_court_status = undefined         % 神庭信息 #god_court_status{}
          , questionnaire = undefined            % 问卷调查 #status_questionnaire{}
          , chrono_rift = undefined              % 时空裂缝
          , act_sign_up = undefined              % 活动报名
          , guild_assist = undefined             % 协助 #status_assist{}
          , lunch_assist = #{}                   % 发起的协助（针对璀璨之海） {Id => #status_assist{}}
          , guild_god = undefined                % 公会神像
          , sea_craft_daily = undefined          % 海战日常
          , del_hp_each_time = []                % 伤害值区间##跟怪物定义一致
          , subscribe_type = 0                   % 订阅类型
          , suit_collect = undefined
          , afk = undefined                      % 挂机规则 #status_afk{}
          , role_boss_first_blood = #{}          % 新boss首杀角色数据 #{SubType => [#role_info{}]}
          , partner_dun = undefined              % 伙伴副本
          , task_map = #{}                       % 任务map# 存储一些特殊的任务 #{task_id => 0,1,2}
          , up_power_rank = #{}                  %
          , rank_power_gift_time = []            % 助力礼包领取状态[{Type, timestamp}|_]
          , push_gift_status = undefined         % 礼包推送
          , fake_client = undefined              % 伪造客户端
          , behavior_status = undefined          % 行为树状态
          , temple_awaken = undefined            % #status_temple_awaken{} 神殿觉醒
          , sea_treasure_pid = undefined         % 璀璨之星 战场进程pid
          , drop_ratio_map = #{}                 % 掉落概率map #drop_ratio.ratio_id => #drop_ratio{}
          , nine_battle = undefined              % 九魂圣殿战斗信息 #nine_battle{} /role_nine.hrl
          , dragon_ball = undefined              % #status_dragon_ball{}
          , armour = undefined                   % 战甲 #armour
          , advertisement = undefined                   % 广告
          , fiesta = undefined                   % 祭典 #fiesta{}
          , dun_rune_daily_reward = undefined    % 符文本每日奖励状态 #dun_rune_daily_reward{}
          , dun_rune_level_unlock = 0            % 符文本手动解锁层级(层级会自动解锁,手动仅做交互用)
          , popup = undefined                    % 玩家功能弹窗信息 #popup{}
          , grow_welfare = undefined             % 成长福利 #status_grow_welfare{}
          , combat_welfare = undefined           % 玩家战力福利信息 #status_combat_welfare{}
          , portal_id = 0                        % 传送门Id
          , ta_spcl_base = #{}                   % ta的额外特殊基础数据 【由前端提供，例如TA访客id】
          , ta_spcl_common = #{}                 % ta的额外特殊公共属性 【由前端提供，例如TA设备id】
          , network_type = 0                     % 网络类型## 见 predefine.hrl
          , limit_tower = #{}                    % 限时爬塔  #status_limit_tower{}
          , weekly_card_status = undefined       % 周卡
          , cycle_rank_data = []                 % 循环冲榜 玩家数据
          , sell_status = undefined              % 市场cd
          , fairy_buy_status = []                % 仙灵直购系统数据 [#fairy_buy_status{}]
          , delay_reward = []                    % 延迟发放奖励列表
          , halo_status = []                     % 主角光环数据
          , halo_setting = []                    % 主角光环特权设置
}).

%% 各职业选择情况表
-record(career_count, {sj = 0, tz = 0, ls = 0, jx = 0}).


%% 玩家金钱数据(用于玩家扣钱处理)
-record(ps_money, {
          id = 0,
          lv = 0,
          guild_id = 0,
          gold = 0,
          bgold = 0,
          coin = 0,
          gcoin = 0,
          currency_map = #{},
          type = none,

          %% 结果处理
          real_cost = [],
          real_reward = []
         }).


-record(mod_player_die,{
          mod = 0                         %% 模块id
          ,die_time_list = []             %% 死亡统计[dietime,...]
          ,die_time = 0                   %% 上次死亡时间
          ,buff_end = 0                   %% buff结束时间
          ,reborn_ref = undefined         %% 玩家死亡退出如果没有重连则开启定时器复活玩家
     }).

-record(beta_data, {
        data = #{}      %% key => Value
    }).

-record(login_days_status, {
        login_days = 0      %% 累积天数(新角色从注册时间算起,旧角色从更新功能后算起)
        , days_utime = 0    %% 累积天数变更时间
        , first_log_time = 0 %% 第一次记录的时间
        , login_days_detail = <<>>  %% 累积登陆明细
    }).
