%%------------------------------------------------------------------------------
%% @Module  : battle
%% @Author  : zzm
%% @Email   : ming_up@163.com
%% @Created : 2012.6.20
%% @Description: 战斗定义
%%------------------------------------------------------------------------------

-define(BATTLE_ATT_TYPE_SRD, 0). %% 近程攻击
-define(BATTLE_ATT_TYPE_RD,  1). %% 远程攻击

-define(HURT_TYPE_NORMAL,    0). %% 普通
-define(HURT_TYPE_MISS,      1). %% 闪避
-define(HURT_TYPE_CRIT,      2). %% 暴击
-define(HURT_TYPE_IMMUE,     3). %% 免疫伤害(无敌)
-define(HURT_TYPE_HEART,     4). %% 会心
-define(HURT_TYPE_SHIELD,    5). %% 护盾免伤
-define(HURT_TYPE_PARRY,     6). %% 格挡
-define(HURT_TYPE_NOTHING,   7). %% 无伤害##不触发效果,比如被动技能
-define(HURT_TYPE_EXC,       8). %% 卓越一击
-define(HURT_TYPE_CRIT_HEART, 9).  %% 暴击会心
-define(HURT_TYPE_EXC_HEART, 10).  %% 卓越会心

%% 是否进入战斗状态
-define(IS_BATTLE_NO, 0).     %% 没有进入战斗状态
-define(IS_BATTLE_YES, 1).    %% 进入战斗状态

% 采集返回code
-define(COLLECT_RES_START_SUCCESS,               1).%% 开始成功
-define(COLLECT_RES_SUCCESS,                     2).%% 采集成功
-define(COLLECT_RES_DISTANCE_ERR,                3).%% 距离太远
-define(COLLECT_RES_FAILURE,                     4).%% 采集失败
-define(COLLECT_RES_TIME_ERR,                    5).%% 采集时间不足
-define(COLLECT_RES_NOT_BELONG_GUILD,            6).%% 采集怪不属于本公会
-define(COLLECT_RES_TIMES_LIMIT,                 7).%% 采集次数已满
-define(COLLECT_RES_CFG_ERR,                     8).%% 采集怪配置id不对应
-define(COLLECT_RES_EUDEMONS_ERR1,               9).%% 幻兽之域普通采集次数已满
-define(COLLECT_RES_EUDEMONS_ERR2,              10).%% 幻兽之域珍惜采集次数已满
-define(COLLECT_RES_CHEST_TIMES_LIMIT,          11).%% 已达宝箱开启上限
-define(COLLECT_RES_CHEST_LV_LIMIT,             12).%% 达到x级才可开启青云夺宝哦
-define(COLLECT_RES_HAD_FINISHED,               13).%% 已经被采集完
-define(COLLECT_RES_CANCEL_SUCCESS,             14).%% 中断采集成功
-define(COLLECT_RES_BAG_FULL,                   15).%% 背包空间不足
-define(COLLECT_RES_EAT_ERR1,                   16).%% 本次食用普通喜糖次数已满
-define(COLLECT_RES_EAT_ERR2,                   17).%% 本次食用豪华喜糖次数已满
-define(COLLECT_RES_SELF_HAD_OCCUPY,            18).%% 已被我方占领
-define(COLLECT_RES_HAD_OCCUPY,                 19).%% 已被占领
-define(COLLECT_RES_YOU_HAD_OCCUPY,             20).%% 您已占领该图腾
-define(COLLECT_RES_DURATION,                   21).%% 正在采集中
-define(COLLECT_RES_MIDDAY_ERR1,                23).%% 午间派对普通宝箱采集已达上限
-define(COLLECT_RES_MIDDAY_ERR2,                24).%% 午间派对高级宝箱采集已达上限
-define(COLLECT_RES_NO_PERMISSION,              25).%% 没权限采集
-define(COLLECT_RES_NOT_SAME_CAMP,              26).%% 不在同一阵营
-define(COLLECT_RES_IN_CD,                      27).%% 采集CD中

%% 战斗中间状态
-record(mid_eff, {
          speed = [],        %% 速度buff
          att_speed = [],    %% 攻击速度buff
          hit_ratio = [],    %% 命中率buff
          superarmor = 0,    %% 免疫控制
          immue = 0,         %% 免疫伤害
          rebound = 0,       %% 反弹
          suck_blood = 0,    %% 吸血
          sheild = 0,        %% 盾
          airborne = 0,      %% 浮空
          sphit_up = 0,      %% 鹰眼buff
          move = 0,          %% 是否有移动
          taunt = {0, 0},    %% 嘲讽
          interrupt = 0,     %% 是否打断
          hide = 0           %% 是否隐身
         }).

%% 战斗主体
-record(battle_status, {
          id = 0,                     %% 角色/怪物id
          node = none,                %% 来源节点
          server_id = 0,              %% 服务器唯一id
          server_num = 0,             %% 服数
          server_name = "",           %% 服名字
          figure = undefined,         %% 形象
          battle_attr=undefined,      %% 战斗通用属性 #battle_attr{} (attr.hrl)
          mid_eff = #mid_eff{},       %% 战斗中间状态
          config_id=0,                %% 场景对象配置id
          mid = 0,                    %% 怪物配置id
          kind = 0,                   %% 怪物类型
          boss = 0,                   %% boss类型
          att_type = 0,               %% 攻击类型（0近程，1远程）
          attr_type = 0,              %% 五行属性
          scene = 0,                  %% 所属场景
          scene_pool_id = 0,          %% 场景进程池id
          copy_id = 0,                %% 所属副本
          x = 0,                      %% X
          y = 0,                      %% y
          att_area = 0,               %% 攻击范围
          pid = none,                 %% 玩家/怪物进程
          sid = none,
          sign = 0,                   %% 标示是怪还是人 1:怪， 2：人
          skill = [],                 %% 技能
          skill_cd = [],              %% 技能cd记录
          skill_cd_map = #{},         %% 技能cdMap##{编号=>结束时间(毫秒)}
          skill_combo = [],           %% 技能连接（连技/多段）
          shaking_skill = 0,          %% 正在释放前摇的技能
          last_skill_id = 0,          %% 上一普通技能id
          pub_skill_cd_cfg = [],      %% 公共的cd配置##[{SkillId, No, Cd}],同一编号cd最好要一致,方便服务端取数据.（目前怪物支持）
          pub_skill_cd = [],          %% 公共的cd##[{No, 释放时间}]
          skill_owner = undefined,    %% #skill_onwer{}
          scene_partner = [],         %% 场景伙伴
          guild_id = 0,               %% 帮派id
          protect_end_time=0,         %% 保护时间
          team_id = 0,                %% 队伍id
          team_skill = 0,             %% 队伍临时技能(被动)荆棘之心
          team_skill_num = 0,         %% 荆棘之心的叠加层数
          group = 0,                  %% 战场阵营分组
          in_sea = 0,                 %% 是否在海里(跨服公会战)
          is_armor = 0,               %% 是否霸体
          is_be_atted = 1,            %% 是否被攻击
          skill_passive = [],         %% 玩家被动技能
          skill_passive_share = [],   %% 共享被动技能
          tmp_skill_passive = [],     %% 某些效果新增临时被动技能(每次战斗要重置本值)
                                      %% skill_lv.must_skill_list 会触发添加
          skill_pet_passive = [],     %% 宠物被动战斗触发技能
          trigger_skill = [],         %% 本次战斗触发的效果的技能ID（包括主动和被动）
          be_trigger_skill = [],      %% 本次战斗作为防守方触发的被动技能列表
          att_list = [],              %% 正在攻击我的怪物列表
          boss_tired = undefined,     %% 世界|神庙|幻兽之域boss疲劳值## #scene_boss_tired{}
          del_hp_each_time = [],      %% 每一次伤害固定值
          per_hurt = 0,               %% 本段时间的伤害
          per_hurt_time = 0,          %% 上一次清理伤害的时间(ms)
          quickbar = [],              %% 快捷栏节能表
          be_att_limit = none         %% none:不生效 List：存放能攻击scene_object的攻击对象id
          , world_lv = 0              %% 世界等级##用于计算跨服掉落
          , mod_level = 0             %% 功能等级##计算掉落等级
          , camp_id = 0               %% 阵营id(跨服圣域分配)
          , assist_id = 0
          , assist_ids = []           %% 玩家发起协助会添加协助id到怪物记录里
          , halo_privilege = []       %% 主角光环特权
         }).

%% skill_combo 列表中的元素
-record(skill_combo, {
          main_skill_id = 0,      %% 主技能id
          main_skill_lv = 1,      %% 主技能等级
          main_skill_cd = 0,      %% 主技能cd
          is_set_cd = 0,          %% 是否设置cd
          is_set_bullet = 0,      %% 是否已经设置子弹技能
          bullet_type = 0,        %% 弹道类型
          hurt_list = [],         %% 攻击列表[{Sign, [Id,..]},...]
          count = 0,              %% 子弹技能剩余次数
          bullet_dis = 0,         %% 每次碰撞的计算距离
          next_time = 0,          %% 释放下个combo技能时间间隔
          combo_list = []         %% 剩余combo技能
         }).

%% 战斗信息回传
-record(battle_return, {
          hp_lim = 0,             %% 防守方血量上限
          hp = 0,                 %% 防守方hp
          mp = 0,                 %% 防守方mp
          anger = 0,              %% 防守方怒气
          hurt = 0,               %% 防守方受到的伤害##实际对怪物造成的伤害
          real_hurt = 0,          %% 玩家对怪物打出的飘字伤害##攻击者能打出的伤害,不一定是对怪物造成的伤害，可能比扣掉的血量要高
          move_x = 0,             %% 防守方x位移
          move_y = 0,             %% 防守方y位移
          shield = 0,             %% 防守方盾血量
          attr_buff_list = [],    %% 防守方属性buff列表
          other_buff_list = [],   %% 防守方其他buff列表
          taunt = {0, 0},         %% 是否被嘲讽
          sign = 0,               %% 攻击方类型##真实释放类型
          hit_list = [],          %% 助攻列表 [#hit{},...]
          is_calc_hurt = 1,       %% 是否计算伤害(0不算,1算)
          atter = [],             %% 攻击方数据 #battle_return_atter{} | #battle_return_mon{}
          beattack_num = 0,       %% 受击次数
          skill_cd = []           %% 技能cd
         }).

%% 攻击方信息
-record(battle_return_atter, {
          sign = 0,               %% 攻击者类型 如果有所属，此为所属者类型
          id = 0,                 %% 攻击者id 如果有所属，此为所属者id
          server_id = 0,          %% 服务器唯一id
          server_num = 0,         %% 服数
          real_sign = 0,          %% 如果有所属，此为真实类型; 没有所属, 则计算真实类型(lib_battle:calc_real_sign);
          real_id = 0,            %% 如果有所属，此为真实id，没有所属和id一致
          real_name = [],         %% 如果有所属，此为真实名字，没有所属和name一致
          node = none,            %% 攻击者所在节点
          mid  = 0,               %% 怪物资源id
          kind = 0,               %% 怪物类型：14:原型怪
          pid = none,             %% 攻击者进程id
          name = [],              %% 攻击者名字
          team_id = 0,            %% 攻击者队伍id
          att_time = 0,           %% 攻击者攻击时刻
          guild_id = 0,           %% 帮派id
          lv = 0,                 %% 攻击者等级
          career = 0,             %% 职业
          power = 0,              %% 战力
          hp_lim = 0,             %% 血量上限
          hp = 0,                 %% 血量
          mp = 0,                 %% 蓝量
          x = 0,                  %% 攻击者所在x坐标
          y = 0,                  %% 攻击者所在y坐标
          hide = 0,               %% 攻击方是否隐身
          att_type = 0,           %% 攻击类型(0近程，1远程)
          attr_skill_id = 0       %% 攻击方使用的技能id
          , world_lv = 0          %% 世界等级
          , server_name = ""      %% 服名字
          , mod_level = 0                 %% 功能等级##计算掉落等级
          , camp_id = 0               %% 阵营id(跨服圣域分配)
          , mask_id = 0           %% 面具id(蒙面)
          , assist_id = 0         %% 协助id
          , halo_privilege = []       %% 主角光环特权
         }).

%% 攻击额外的参数
-record(battle_args, {
          att_key =  undefined,       %% 攻击者key
          att_user = undefined,       %% 攻击者的数据
          sign = 0,                   %% 宠物攻击字段有效
          mon_list = [],              %% 被攻击怪物列表：[MonId,...]第一个为锁定目标
          player_list = [],           %% 被攻击的玩家列表：[[PlayerId, Platform, ServerNum],...]第一个为锁定目标
          der_list = [],              %% 所有防御对象列表（包含玩家）
          is_combo = 0,               %% 是否连续技
          skill_id = 0,               %% 技能id
          skill_lv = 1,               %% 技能等级(默认1)
          skill_stren = 0,            %% 技能强化
          skill_call_back = [],       %% 某些技能使用成功之后要处理的后续逻辑
          att_x = 0,                  %% 攻击点x
          att_y = 0,                  %% 攻击点y
          att_angle = 0,              %% 攻击角度
          now_time = 0                %% 现在的时间
         }).

%% 被动技能额外的参数
-record(battle_passive_args, {
          aer = undefined,            %% 攻击者
          der = undefined,            %% 受击者
          trigger_time = 0,           %% 被动触发点
          hp = 0,                     %% 血量(攻击者或者被攻击)
          hurt_type = 0,              %% 伤害类型
          sec_hurt_type = 0,          %% 伤害第二类型
          hurt = 0,                   %% 伤害值
          skill_id = 0,               %% 技能id（当前计算的技能id）
          is_trigger = 0              %% 是否触发(初始化时不要赋值)
          , battle_skill_id = 0       %% 战斗技能id##玩家释放的技能id,即导致被动技能触发的技能id
          , ok_passive_list = []      %% 成功触发的被动技能列表
          , skill_calc_hurt = 0       %% 当前技能是否计算伤害(对应 #skill.calc 字段)
         }).

%% 怪物继承父类的属性记录
-record(skill_owner, {
          id=0,               %% 玩家id
          node=none,          %% 玩家节点
          pid=none,           %% 玩家进程id
          team_id=0,          %% 队伍id
          guild_id=0,         %% 公会id
          guild_name="",      %% 公会名
          sign=0              %% 类型 ?BATTLE_SIGN_MON | ?BATTLE_SIGN_PLAYER...
         }).

%% 场景对象返回必要的属性到进程
-record(assist_return, {
          skill_cd = [],
          skill_combo = []
         }).

%% 保存在怪物进程里，使用技能信息 cast的时候使用
-record (selected_skill, {
     att_time,      %% 攻击时间
     skill_id,      %% 技能id
     spell_time,    %% 吟唱时间
     is_refind_t,   %% 是否重新选择目标
     link_info,     %% 连接技能
     normal         %% 是否普通
     }).

%% 当前正在释放的技能
%% TODO:目前不打断,后续支持前摇技能打断
-record(release_skill, {
          skill_id = 0        %% 主技能id
          , spell_time = 0    %% 吟唱时间(毫秒)
          , end_time = 0      %% 结束时间(毫秒结束时间戳)
          , is_ok = 0         %% 成功释放
     }).

%% 使用技能后返回
-record (skill_return, {
     used_skill,    %% 使用的技能
     rx,            %% 使用技能前的x坐标
     ry,            %% 使用技能前的y坐标
     tx,            %% 技能作用的x坐标
     ty,            %% 技能作用的y坐标
     aer_info,      %% 使用技能后攻击方的一些数据
     main_skill,    %% 主技能
     radian         %% 技能角度（弧度）
     }).

%% 场景算法的参数
-record(scene_calc_args, {
          group = 0           %% 分组
          , sign = 0          %% 对象类型
          , id = 0            %% 对象唯一id
          , owner_sign = 0    %% 拥有者对象类型
          , owner_id = 0      %% 拥有者唯一id
          , kind = 0          %% 怪物kind
          , guild_id = 0      %% [未完成,不要使用这个字段]公会id
          % , is_calc_dead = 0  %% 是否计算死亡玩家##未处理
          , pk_status = undefined %% [未完成,不要使用这个字段]k状态##默认是 false | #pk.pk_status | undefined
     }).

%% 场景计算防守者信息
-record(scene_calc_args_def, {
    id = 0,
    sign = 0,
    hp = 0,
    x = 0,
    y = 0,
    is_be_atted = 0,     %% 是否能被攻击
    skill_owner = [],
    mon = undefined,
    ghost = 0,           %% 幽灵
    hide = 0,            %% 隐身
    group = 0           %% 分组
}).

% 禁术流血
-record(ban_bleed, {
          ref = none               %% 定时器
          , atter_id = 0           %% 攻击者
          , sign = 0               %% 类型
          , key = undefined        %% key值
          , stack = 0              %% 层数
          , int = 0                %% 整数
          , float = 0              %% 小数
          , attr_id = 0            %% 属性
     }).