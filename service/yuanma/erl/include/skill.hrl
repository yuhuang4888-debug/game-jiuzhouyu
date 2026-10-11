%%%------------------------------------------------
%%% File    : skill.hrl
%%% Author  : xyao
%%% Created : 2011-12-13
%%% Description: 技能
%%%------------------------------------------------
%% 技能职业用途
-define(SKILL_CAREER_ROLE,             1).  %%   职业技能
-define(SKILL_CAREER_COMMON,           10). %%   通用技能(职业通用技能):会根据条件自动学习的,一般不要填这个类型
-define(SKILL_CAREER_MON,              11). %%   怪物技能
-define(SKILL_CAREER_PET,              12). %%   宠物技能
-define(SKILL_CAREER_JUMP,             13). %%   特殊处理跳跃技能
-define(SKILL_CAREER_MOUNT,            14). %%   坐骑技能
-define(SKILL_CAREER_WING,             15). %%   翅膀技能
-define(SKILL_CAREER_TREASURE,         16). %%   法宝技能
-define(SKILL_CAREER_GOD_WEAPON,       17). %%   神兵技能
-define(SKILL_CAREER_CLOAK,            18). %%   披风技能
-define(SKILL_CAREER_MAGIC_BEAST,      19). %%   幻兽技能
-define(SKILL_CAREER_GUILD,            20). %%   公会技能
-define(SKILL_CAREER_DUN,              21). %%   副本技能
-define(SKILL_CAREER_BABY,             22). %%   宝宝技能
-define(SKILL_CAREER_HUSONG,           24). %%   护送技能
-define(SKILL_CAREER_HGHOST,           26). %%   圣灵技能
-define(SKILL_CAREER_MOUNT_EQUIP,      27). %%   坐骑装备技能
-define(SKILL_CAREER_KF_GWAR,          28). %%   跨服公会战技能
-define(SKILL_CAREER_MATE,             29). %%   伙伴技能
-define(SKILL_CAREER_SOUL_DUN,         30). %%   聚魂本技能
-define(SKILL_CAREER_ARBITRAMENT,      31). %%   圣裁
-define(SKILL_CAREER_SECRET,           32). %%   奥秘技能
-define(SKILL_CAREER_DRUM,             33). %%   钻石大战技能
-define(SKILL_CAREER_TALENT,           34). %%   天赋技能
-define(SKILL_CAREER_DRAGON,           36). %%   龙纹技能
-define(SKILL_CAREER_DEVIL_INSIDE,     37). %%   心魔技能
-define(SKILL_CAREER_GOD,              38). %%   降神技能
-define(SKILL_CAREER_FAZHEN,           39). %%   法阵技能
-define(SKILL_CAREER_REVELATION,       40). %%   天启装备技能
-define(SKILL_CAREER_DEMONS,           41). %%   使魔技能
-define(SKILL_CAREER_DEMONS_SLOT,      42). %%   使魔天赋技能
-define(SKILL_CAREER_SUPVIP,           43). %%   至尊vip技能
-define(SKILL_CAREER_RUNE,             44). %%   符文技能
-define(SKILL_CAREER_BACK_DECOR,       45). %%   背饰技能
-define(SKILL_CAREER_WEEK_DUNGEON,     46). %%   周常副本技能
-define(SKILL_CAREER_FAIRY,            47). %%   精灵技能
-define(SKILL_CAREER_ARCANA,           48). %%   远古奥术技能
-define(SKILL_CAREER_SPIRIT_BATTLE,    49). %%   圣灵战场技能
-define(SKILL_CAREER_SEACRAFT,         50). %%   怒海争霸技能
-define(SKILL_CAREER_SEACRAFT_DAILY,   51). %%   海战日常技能
-define(SKILL_CAREER_COMPANION,        52). %%   伙伴（新）技能
-define(SKILL_CAREER_DRAGONBALL,       53). %%   龙珠技能
-define(SKILL_CAREER_SUIT,             54). %%   史诗套装技能
-define(SKILL_FAIRY_BUY,               55). %%   仙灵直购技能
-define(SKILL_NEW_BACK_DECORATION,     56). %%   新版背饰技能
-define(SKILL_CAREER_HALO,             57). %%   主角光环特权技能

%% 技能类型
-define(SKILL_TYPE_ACTIVE,         1).    %% 主动
-define(SKILL_TYPE_PASSIVE,        2).    %% 被动
-define(SKILL_TYPE_ASSIST,         3).    %% 辅助
-define(SKILL_TYPE_PERMANENT_GAIN, 4).    %% 永久增益
-define(SKILL_TYPE_TALENT_ATT,     5).    %% 天赋攻击
-define(SKILL_TYPE_TALENT_DEF,     6).    %% 天赋防守
-define(SKILL_TYPE_TALENT_COMMON,  7).    %% 天赋通用
-define(SKILL_TYPE_TALENT_ABS,     8).    %% 绝对天赋技能(精通系)

%% 技能分享类型
-define(SKILL_SHARE_TYPE_NO,       0).    %% 无
-define(SKILL_SHARE_TYPE_TEAM,     1).    %% 队伍共享

%% 技能模式 #skill.mod
-define(SKILL_MOD_SINGLE,          1).       %% 单体攻击
-define(SKILL_MOD_DOUBLE,          2).       %% 群体攻击

%% 释放目标 #skill.obj
-define(SKILL_OBJ_ME,              1).       %% 自己
-define(SKILL_OBJ_ATT_TARGET,      2).       %% 攻击目标
-define(SKILL_OBJ_SINGLE_TARGET,   3).       %% 选择单体目标
-define(SKILL_OBJ_TOWARD,          4).       %% 朝向
-define(SKILL_OBJ_HP_MIN_MB,       5).       %% 血量最少队友
-define(SKILL_OBJ_ASSIGN_MON,      6).       %% 指定怪物
-define(SKILL_OBJ_MASTER,          7).       %% 主人
-define(SKILL_OBJ_OTHER,           8).       %% 只对队友
-define(SKILL_OBJ_ENEMY,           9).       %% 针对敌人

%% Buff类型
-define(SKILL_NORMAL_BUFF,         0).    %% 普通buff
-define(SKILL_CTRL_BUFF,           1).    %% 控制buff
-define(SKILL_BUFF,                2).    %% 增益buff
-define(SKILL_DEBUFF,              3).    %% 减益buff
-define(SKILL_SP_BUFF,             4).    %% 特殊buff

%% buff作用方
-define(SKILL_AFFECT_MYSELF,       1).    %% 作用对象是自己
-define(SKILL_AFFECT_ENEMY,        2).    %% 作用对象是别人
-define(SKILL_AFFECT_ALL,          3).    %% 作用对象是双方

%% 被动技能触发时间点
-define(SKILL_BUFF_TG_TIME,        0).    %% 特殊血量不分前后触发
-define(SKILL_BUFF_TG_TIME_ATTBF,  1).    %% 攻击者计算伤害前触发
-define(SKILL_BUFF_TG_TIME_DEFBF,  2).    %% 防守者计算伤害前触发
-define(SKILL_BUFF_TG_TIME_ATTAF,  3).    %% 攻击者计算伤害后触发
-define(SKILL_BUFF_TG_TIME_DEFAF,  4).    %% 防守者计算伤害后触发

%% 被动技能触发类型
%% 注意:触发列表中的作用方等于0的话,取属性或者buff的作用方来计算.
-define(SKILL_BUFF_TRIGGER,        0).    %% 被动技能无条件触发
-define(SKILL_BUFF_TRIGGER_GET,    1).    %% 被动技能受到某个特殊效果时触发(必须填作用方)
-define(SKILL_BUFF_TRIGGER_HAVE,   2).    %% 被动技能身上有特殊效果时触发
-define(SKILL_BUFF_TRIGGER_HP,     3).    %% 被动技能血量触发
-define(SKILL_BUFF_TRIGGER_CRIT,   4).    %% 被动技能暴击时触发
-define(SKILL_BUFF_TRIGGER_HPRESUME, 5).  %% 被动技能回血时触发
-define(SKILL_BUFF_TRIGGER_DIE,    6).    %% 被动技能受到致死伤害时触发(免疫本次伤害)
-define(SKILL_BUFF_TRIGGER_MISS,   7).    %% 被动技能闪避时触发
-define(SKILL_BUFF_TRIGGER_PARRY, 8).     %% 被动技能格挡时触发
-define(SKILL_BUFF_TRIGGER_HEART, 9).     %% 被动技能会心时触发

%% 天赋技能
-define(TALENT_RESET_GOOD,  6200002).     %% 重置消耗的物品
-define(DEF_SKILL_POINT,           10).   %% 天赋技能开启给予的默认技能点

%% 特殊技能ID
-define(SP_SKILL_KILLING,   11000010).    %% 荆棘之心(个人反伤和队伍反伤被动)

%% 增加护盾
-define(SP_SKILL_HOPE,        103).     %% 吸血和概率##不灭希望(主动)
-define(SP_SKILL_SHIELD,      102).     %% 护盾

%% 减少cd的
-define(SP_SKILL_FIRE,      100601).    %% ##怒火(辅助)
-define(SP_SKILL_ICE,       200601).    %% ##破冰(辅助)

-define(SP_SKILL_TLDEF6,    12010106).    %% 天赋防御6：减少怒火|破冰的cd
-define(SP_SKILL_TLDEF9,    12010109).    %% 天赋防御9：减少不灭希望的cd

-define(SP_SKILL_TLDEF10,   342009).    %% 天赋防御10(回血触发)(yyhx)

%% 降神特殊技能
% -define(GOD_SKILL_SHIELD, 8202102).     %% 护盾加成技能

-define(DEFAULT_SKILL_LV,     1).         %% 默认技能等级

-define(SKILL_PROB_C, 10000).           %% 技能概率系数

%% 技能
-record(status_skill, {
        skill_attr = [],                %% 技能属性值[]
        skill_attr_other = [],          %% 技能其他类系属性值[]
        skill_cd = [],                  %% 技能cd[{id1, time1},{id2, time2}...]
        %% 职业技能
        skill_list = [],                %% 技能列表[{id1, lv1}, {id2, lv2}...]
        tmp_skill_list = [],            %% 临时技能列表[{id1, lv1}, {id2, lv2}...]
        skill_passive = [],             %% 战斗计算时触发的buff效果的被动技能,从已学被动技能中过滤得到[{id1, lv1}, {id2, lv2}...]
        combo_skill_ref=undefined,      %% 副技能
        %% 天赋技能
        skill_talent_list = [],         %% 所有的天赋技能
        skill_talent_passive = [],      %% 战斗计算时触发的buff效果的被动技能,从已学天赋技能中过滤得到[{id1, lv1}, {id2, lv2}...]
        skill_talent_attr = [],         %% 天赋技能属性值#attr{}
        skill_talent_attr_other = [],   %% 天赋技能其他类系属性值
        skill_talent_sec_attr = #{},    %% 天赋技能第二属性
        skill_power = 0,                %% 技能总战力
        use_point = 0,                  %% 使用的技能点数
        point = 0                       %% 技能总点数
        , stren_list = []             %% 强化列表##[{SkillId, SkillLv}];转职的时候需要修改
        , stren_power = 0             %% 强化战力
    }).

%% 技能等级数据
%% 描述 trigger_cond
% <br>{prob, 概率}：概率触发
% <br>{aer_sign, 攻击者类型(1怪,2人)} 
% <br>{der_sign, 防守者类型(1怪,2人)}
% <br>{skill_id_list, [SkillId,...]} : 包含当前攻击的技能才能触发
% <br>{pre_trigger_skill_id, SkillId} : 前置被动技能id触发成功,才能触发本技能
% <br>{trigger, TriggerType, TriggerTime} TriggerType:触发类型(只支持闪避,暴击,会心),TriggerTime:触发时间点
-record(skill_lv, {
        desc = <<>>,                  %% 技能描述|只有技能职业是37才会生成
        condition = [],               %% 学习条件[{point, 天赋技能类型, 类型总投入技能点}, {pre_skill, 前置技能id, 等级}]
        power = 0,                    %% 基础战力
        base_attr = [],               %% 添加的基础属性[{FuncId, AttType, Int|float}]:{作用Id(0|ModId|{ModId,SubModId}), 属性类型(属性id和属性类型万分比id), 整数加的数值|万分比数值}
                                    %% 被动和永久增益
        sec_attr = [],                %% 第二属性##[{Type, Args, Value}]
        trigger_cond = [],            %% 基础触发条件##[{prob, 概率},{aer_sign, 攻击者类型(1怪,2人)},{der_sign, 防守者类型(1怪,2人)},{skill_id_list(包含当前攻击的技能才能触发), [SkillId,...]},{pre_trigger_skill_id(前置技能触发成功), SkillId},{skill_calc_hurt, 当前技能calc字段匹配}]
        trigger = [],                 %% 触发列表,如:[{被动技能触发类型, 概率, 作用方(目前无效), 触发事件点, 整数型, 小数型, 特殊buffid(用于计算是否有某些buff然后触发), 被动技能的属性id}]
        relate_skill_list = [],       %% 关联技能##(目前只有被动有效)成功触发时,再触发对应的关联技能[SkillId,..]
        assist_skill_list = [],       %% 释放辅助技能##被动成功触发时,释放对应的辅助技能[{SkillId,Lv},...];若主动技能有这个值会无条件释放辅助技能
        must_skill_list = [],         %% 必然触发被动技能##(目前只有被动有效)本技能触发了,必然触发该被动, [{SkillId,Lv},...]
        cd = 0,                       %% 使用积攒
        distance = 0,                 %% 攻击距离
        area = 0,                     %% 每级的攻击范围
        num  = [0, 0],                %% [攻击人数,攻击怪物数量]
        attr = [],                    %% 基础属性效果[{属性类型ID,buff类型,概率,作用方,整数值,小数值,持续时间,叠加层数,特效id},...]
        hurt = 0,                     %% 固定伤害
        hurt_ratio = 0,               %% 伤害倍率##整数,万分比
        effect = []                   %% 特殊效果效果:[{特殊效果ID,buff类型,概率,作用方,整数值,小数值,属性类型ID,持续时间,作用次数,特效id},...]
        , assist_mon_list = []        %% 辅助技能的怪物列表##[{MonId, Num},...]
        , recalc_effect = []          %% 重算效果列表##[{buffid,效果类型,替换类型,替换效果列表}],效果类型0是基础属性效果,1是特殊效果类型；替换类型（0:替换；1:叠加）
    }).

%% buff列表(待扩展)
-record(buff, {
        buff_id = 0                   %% buffid##参考 attr.hrl，包括属性类型id和特殊效果id
        , buff_type = 0               %% buff类型
        , prob = 0                    %% 概率
        , party = 0                   %% 作用方
        , int = 0                     %% 整数
        , float = 0                   %% 小数值
        , attr_id = 0                 %% 属性类型id##参考 attr.hrl，会以属性id作为参考
        , last_time = 0               %% 持续时间
        , stack = 0                   %% 叠加层数
        , effect_id = 0               %% 特效id
    }).

-define(SKILL_BULLET_TYPE_NORMAL, 0).   %% 普通
-define(SKILL_BULLET_TYPE_ATT_NUM, 1).  %% 攻击人数

-define(SKILL_RANGE_CIRCLE, 1).         %% 圆形
-define(SKILL_RANGE_LINE, 2).           %% 直线
-define(SKILL_RANGE_SECTOR, 3).         %% 扇形
-define(SKILL_RANGE_CROSS, 4).          %% 十字星

%% 是否触发被动
%% 注意:技能类型等于指定类型(2,4-7类型)且基础属性不等于[],触发被动,否则不是;如果填了1就是强制是被动。因为之前技能类型填错很多填了被动,实际是增益,只能临时处理
-define(SKILL_IS_PASSIVE_NO, 0).        %% 不触发
-define(SKILL_IS_PASSIVE_YES, 1).       %% 触发

%% 技能
-record(skill, {
        id = 0,                       %% 技能id
        name = "",                    %% 技能名字
        lv = 1,                       %% 等级
        career = 0,                   %% 职业归属:1职业;10通用;11;怪物;12宠物
        sex = 0,                      %% 性别
        type = 0,                     %% 技能类型:(1主动, 2被动, 3辅助, 4.永久增益 5.天赋攻击 6.天赋防守 7.天赋通用 )
        is_passive = 0,               %% 触发被动##1:触发,0:不触发;注意:技能类型等于指定类型(2,4-7类型)且基础属性等于[],触发被动,否则不是;如果填了1就是强制是被动。因为之前技能类型填错很多填了被动,实际是增益,只能临时处理
        share_type = 0,               %% 共享类型##0:无; 1:队伍共享
        %% TODO:防止无效的被动效果
        % is_not_passive = 0,           %% 是否非被动触发##非被动技能类型,也会触发战斗被动,用于过滤非战斗被动触发,比如说只是加属性,不触发基础属性效果和特殊buff效果
        is_normal = 0,                %% 是否普攻
        is_combo = 0,                 %% 是否副技能(0|1)
        is_anger = 0,                 %% 是否怒气技能
        refind_target=0,              %% 是否重新选取目标(0|1) del
        mod = 0,                      %% 技能模式(1单体攻击, 2群体攻击)
        obj = 0,                      %% 释放目标(1自己,2攻击目标,3选择单体目标,4朝向,5血量最少队友,6指定怪物,7主人,8.只对队友)
        att_obj = 0,                  %% 攻击参照对象(1.自己; 2.选择目标)
        is_att = 1,                   %% 是否攻击##不攻击不会选择目标施放技能,也就是不会触发被动技能
        calc = 1,                     %% 是否计算伤害
        release=1,                    %% 技能释放模式 1.普通为即时释放 2.蓄能表示伤害以蓄能时间长短来计算 3.移动施法
        around_hurt=1000,             %% 群攻周围伤害比
        range=1,                      %% 群攻范围模式(1圆形，2直线，3扇形, 4十字)
        talent=[],                    %% 天赋技能id列表
        combo=[],                     %% 连技##[{技能id,释放时间ms,可否打断(0,1)},...] (有副技能时，主副技能都要配置改字段)
        bullet_type = 0,              %% 子弹类型##0:普通;1:根据攻击数量(不可重复)
        bullet_spd = 0,               %% 子弹速度
        bullet_att_time = 0,          %% 子弹攻击间隔
        count = 0,                    %% 子弹碰撞次数
        skill_link=[],                %% 关联技能，如三连击
        time=0,                       %% 技能施放时间
        time_no=0,                    %% 施放时间编号##同一个编号,只有等待技能释放时间结束才可能释放,目前1是主角的技能,0不处理
        is_shake_pre = 0,             %% 是否前摇技能##目前还没处理好,暂时不要配置前摇
        broadcast = 0,                %% 是否在服务器返回在播放动作
        lv_data=#skill_lv{}           %% 各等级数据
    }).

%% 技能造成的中间属性
-record(skill_effect, {
        superarmor = 0,               %% 免疫控制
        immue = 0,                    %% 免疫伤害
        un_speed = 0,                 %% 免疫减速
        rebound = 0,                  %% 反弹
        suck_blood = 0,               %% 吸血
        shield = 0,                  %% 次数盾
        %% airborne = 0,                 %% 浮空
        %% sphit_up = 0,                 %% 鹰眼buff
        move = 0,                     %% 是否有移动
        %% taunt = {0, 0},               %% 嘲讽
        interrupt = 0,                %% 是否打断
        %% hide = 0,                     %% 是否隐身
        un_die = 0,                   %% 致死触发标记
        current_un_dizzy = 0          %% 免疫当前眩晕
        , hp_lim_hurt = {0, 0}        %% 血量上限最大伤害比例##最大伤害值=Int+血量上限*Float
        , un_resume = 0               %% 是否禁止回血
        , ban_god = 0                 %% 禁术天神
        , ban_bleed = 0               %% 禁术流血
        , free_die = 0                %% 免死
        , hp_lock = {0, 0}            %% 锁血##{锁固定值(Int), 锁百分比(Float)}
    }).

%% 技能使用成功之后的回调参数
-record(call_back_skill_use, {
        skill_id = 0,
        skill_lv = 0,
        mfa = {0, 0, 0}
    }).

%% 技能强化配置
-record(base_skill_stren, {
        skill_id = 0             % 技能
        , min_stren = 0          % 最小强化等级
        , max_stren = 0          % 最大强化等级
        , hurt = 0               % 伤害
        , per_hurt = 0           % 每强化增加伤害
        , cost = []              % 消耗##[{Type, GoodsTypeId, Num}]
        , per_cost = []          % 每强化增加消耗##[{Type, GoodsTypeId, Num}]
        , condition = []         % 条件##[{lv, Lv}, {turn, Turn}]
        , power = 0              % 战力
        , per_power = 0          % 每强化增加战力值
    }).

%% 技能属性配置
-record(base_skill_attr, {
        skill_id = 0
        , skill_lv = 0
        , condition = []            % 属性条件
        , base_attr = []            % 属性列表##添加的基础属性[{FuncId, AttType, Int|float}]:{作用Id(0|ModId|{ModId,SubModId}), 属性类型(属性id和属性类型万分比id), 整数加的数值|万分比数值}
    }).

%% skill
-define(sql_get_all_skill,   <<"select skill_id, lv from skill where id = ~w">>).
-define(sql_insert_skill,    <<"insert into skill set id = ~w, skill_id = ~w, lv = ~w">>).
-define(sql_update_skill_lv, <<"update skill set lv = ~w where id = ~w and skill_id = ~w">>).
-define(sql_reset_skill_lv,  <<"update skill set lv = ~w where id = ~w">>).
-define(sql_del_skill,       <<"delete from skill where id = ~w and skill_id = ~w">>).

%% talent skill
-define(sql_get_all_talent_skill,      <<"select skill_id, lv from talent_skill where role_id = ~w">>).
-define(sql_replace_talent_skill,      <<"replace into talent_skill (role_id, skill_id, lv) values (~w, ~w, ~w)">>).
-define(sql_reset_talent_skill,        <<"delete from talent_skill where role_id = ~w">>).
-define(sql_update_talent_skill_point, <<"update `player_state` set `skill_extra_point` = ~p where id=~w ">>).

%% 技能强化
-define(sql_role_skill_stren_select, <<"SELECT skill_id, stren FROM role_skill_stren WHERE role_id = ~p">>).
-define(sql_role_skill_stren_replace, <<"REPLACE INTO role_skill_stren(role_id, skill_id, stren) VALUES(~p, ~p, ~p)">>).
-define(sql_role_skill_stren_batch, <<"REPLACE INTO role_skill_stren(role_id, skill_id, stren) VALUES ~ts">>).
-define(sql_role_skill_stren_values, <<"(~p, ~p, ~p)">>).