-define(RECRUIT_TYPE_INVALID,       0). %% 非有效招募类型
-define(RECRUIT_TYPE1,              1). %% 卢布招募
-define(RECRUIT_TYPE2,              2). %% 钻石招募

-define(NOT_GUARANTEE,              0). % 非保底
-define(GUARANTEE,                  1). % 保底

-define(STATE_SLEEP,                0). % 非出战
-define(STATE_BATTLE,               1). % 出战

-define(ATTR_QUALITY_1,             1). % 属性潜质 普通
-define(ATTR_QUALITY_2,             2). % 属性潜质 良好
-define(ATTR_QUALITY_3,             3). % 属性潜质 优秀
-define(ATTR_QUALITY_4,             4). % 属性潜质 卓越
-define(ATTR_QUALITY_5,             5). % 属性潜质 完美

% 个性
-define(PERSONALITY_1,              1). %% 个性1
-define(PERSONALITY_2,              2). %% 
-define(PERSONALITY_3,              3). %% 
-define(PERSONALITY_4,              4). %% 
-define(PERSONALITY_5,              5). %% 
-define(PERSONALITY_6,              6). %% 
-define(PERSONALITY_7,              7). %% 
-define(PERSONALITY_8,              8). %% 
-define(PERSONALITY_9,              9). %% 
-define(PERSONALITY_10,             10). %% 
-define(PERSONALITY_11,             11). %% 
-define(PERSONALITY_12,             12). %% 
-define(PERSONALITY_13,             13). %% 
-define(PERSONALITY_14,             14). %% 
-define(PERSONALITY_15,             15). %% 

-define(TV_RECRUIT_PARTNER_1,       1). % 伙伴卢币招募传闻
-define(TV_SUMMON_CARD_PARTNER,     2). % 伙伴召唤卡传闻
-define(TV_RECRUIT_PARTNER_2,       3). % 伙伴钻石招募传闻

% 布阵 上阵
-define(MAX_EMBATTLE,               6). % 最大布阵位置数量
-define(MAX_BATTLE,                 4). % 最大上阵伙伴数
% 遣散 类型
-define(TYPE_PAR,                   1). % 伙伴
-define(TYPE_SK,                    2). % 技能

%-define(DEFAULT_ATTR,                  [{?PHYSIQUE,0,0},{?AGILE,0,0},{?FORZA,0,0},{?DEXTEROUS,0,0}]).  % 最大上阵伙伴数

% 技能位置 1-5 为洗髓获得的普通技能位置, 8,9,10分别为普攻、护主、天赋技能位置
-define(COM_ATTACK,                 8). % 普攻技能
-define(ASSIST,                     9). % 护主技能
-define(TALENT,                     10).    % 天赋技能


%% -define(PARTNER_SKILL_BUFF,         #{?HP_RATIO=>0, ?HP=>0, ?ALL_RESIS=>0, ?DODGE=>0, ?ATT=>0, 
%%                                         ?METAL_ATT=>0,?WOOD_ATT=>0,?WATER_ATT=>0,?FIRE_ATT=>0,
%%                                         ?EARTH_ATT=>0,?METAL_RESIS=>0,?WOOD_RESIS=>0,?WATER_RESIS=>0,
%%                                         ?FIRE_RESIS=>0,?EARTH_RESIS=>0,?ALL_RESIS_DEL=>0,?DODGE_DEL=>0,
%%                                         ?CRIT=>0,?CRIT_HURT=>0,?CRIT_DEL=>0,?CRIT_HURT_DEL=>0,
%%                                         ?HP_RESUME=>0,?HP_RESUME_ADD=>0,?SUCK_BLOOD=>0,?ATT_SPEED=>0,?SPEED=>0,
%%                                         ?HIT=>0,?PHYSIQUE=>0,?AGILE=>0,?FORZA=>0,?DEXTEROUS=>0
%%                                         }). %% 默认技能属性表

-define(PARTNER_SKILL_BUFF,         #{?HP=>0,?DODGE=>0,
                                      ?ATT=>0, ?CRIT=>0,
                                      ?SPEED=>0, ?HIT=>0}). %% 默认技能属性表


% 五行属性 无
-define(NONE_ELEMENT,               6). % 五行 无

% 邮件标题和内容
-define(REWARD_TITLE,               29). % 标题 ： 物品奖励
-define(RECRUIT_CONTENT,            30). % 内容 ： 招募时背包不足，领取物品奖励
-define(REPLACE_CONTENT,            31). % 内容 ： 洗髓替换时背包不足，领取物品奖励
-define(DISBAND_CONTENT,            32). % 内容 ： 遣散时背包不足，领取物品奖励

%-define(LOG_BREAK_ATTR,          <<"physique(~s):~p/~p,agile(~s):~p/~p,gorza(~s):~p/~p,dexterous(~s):~p/~p">>).  %% 突破属性日志内容
-define(LOG_BREAK_ATTR,          134).  %% 突破属性日志内容

-define(LOG_PROMOTE_ATTR_PH,     135).  %% 提升属性日志内容
-define(LOG_PROMOTE_ATTR_AG,     136).  %% 提升属性日志内容
-define(LOG_PROMOTE_ATTR_FO,     137).  %% 提升属性日志内容
-define(LOG_PROMOTE_ATTR_DE,     138).  %% 提升属性日志内容

-define (ALIVE_STATUS_IDEL,         0).  %% 存活状态：0未出战
-define (ALIVE_STATUS_LIVE,         1).  %% 存活状态：1出战存活
-define (ALIVE_STATUS_DIE,          2).  %% 存活状态：2出战死亡 

% 装备状态
-define (PARTNER_EQUIP_UNACTIVE,          0).  %% 未激活
-define (PARTNER_EQUIP_ACTIVE,            1).  %% 已激活

-define (PLAYER_EMBATTLE_POS,            5).  %% 玩家初始布阵位置

%% partner_status 存放在进程字典中
-record(partner_status, {
    pid = 0,                % 玩家id
    recruit_type1 = {0, 0}, % 卢布招募次数和结束时间戳
    recruit_type2 = {0, 0}, % 钻石招募次数和结束时间戳
    partners = #{},         % id => #partner{}
    embattle = [],          % 布阵 [#rec_embattle]
    wash_partner = undefined,   % 洗髓时暂时保留的数据
    recruit_list = []           % 已经招募过的伙伴记录 [{PartnerId, WeaponSt}] WeaponSt专属武器激活状态
    }).

%% status_partner 存放在PS中
-record(status_partner, {
    combat_power = 0,       % 上阵伙伴带来的战力
    attr = #{}              % 上阵伙伴给玩家增加的属性
    }).

-record(partner, {
    id = 0,                     % 伙伴唯一id
    player_id = 0,              % 玩家id
    partner_id = 0,             % 伙伴id
    quality = 0,                % 品质
    career = 0,                 % 伙伴五行属性 （1-6分别对应金木水火土和无五行限制）
    personality = 0,            % 伙伴个性
    state = 0,                  % 状态 是否出战
    pos = 0,                    % 上阵位置
    break_st = 0,               % 突破状态 0 非突破 1 突破
    break = [],                 % 已突破等级列表 [lv]
    lv = 1,                     % 等级
    exp = 0,                    % 当前经验值
    grow_up = [],               % 成长
    apti_take = [],             % 资质丹服用数量 
    skill_learn = [],           % 学习技能id列表 [id]

    attr_quality = [],          % 属性品质 [{体质, 品质}]
    total_attr = [],            % 基础、升级、突破四围属性 [{体质,当前体质,体质上限},{}]
    battle_attr = #{},          % attr属性 map形式
    
    skill = undefined,          % #partner_skill{}
    equip = undefined,          % 伙伴携带专属装备 #partner_equip{}

    combat_power = 0,           % 战力
    prodigy = 0                 % 奇才
    }).

%% 布阵信息
-record(rec_embattle, {
    key = none,             % {type,id}
    pos = 0,                % 位置
    type = 3,               % 类型 与scene.hrl中BATTLE_SIGN_*一致
    id = 0,                 % 唯一id
    partner_id = 0,         % 类型id 玩家为0
    create_id  = 0,         % create_id 须由mod_scene_object_create获得
    lv = 0,                 % 等级 玩家为0
    battle_attr = #{},      % attr属性 map形式 
    alive = 0,              % 存活状态 0未出战, 1出战存活, 2出战死亡
    combat_power = 0        % 战力
    }).

-record(partner_skill, {
    %com_skill = undefined,         % 技能 #status_skill{}
    skill_attr = #{},           % #attr{}
    skill_list = [],            % 技能列表[{id1, lv1, pos}, {id2, lv2, pos}...]
    skill_cd = [],              % 技能cd [{id1, time1},{id2, time2}...]
    sk_power = 0                    % 普通技能的总战力
    }).

-record(partner_equip, {
    weapon_st = 0               % 武器激活状态
    }).

-record(base_partner, {
    partner_id = 0,             % 伙伴id
    name = "",                  % 名称
    model_id = 0,               % 伙伴模型id, 客户端要用
    weapon_id = 0,              % 武器id
    chartlet_id = 0,            % 贴图id
    quality = 0,                % 品质
    career = 0,                 % 五行
    born_attr = [],             % [生命，体质值，敏捷值，力量值，灵巧值]
    grow_up = [],               % 成长
    attack_skill = 0,           % 普通攻击技能id
    assist_skill = 0,           % 护主技能id
    assist_condition = [],      % [{伙伴战力区间下限，伙伴战力区间上限，护主技能等级}，{伙伴战力区间下限，伙伴战力区间上限，护主技能等级}]
    talent_skill = 0,           % 天赋技能id
    talent_describe = "",       % 天赋描述
    personality = 0,            % 个性编号（1-15）
    personality_desc = "",      % 个性描述
    speciality = 0,             % 特性
    recruit_type = []           % [{招募类型，是否保底，权重}]
    }).

-record(base_partner_recruit, {
    recruit_type = 0,       % 1 卢布 2 钻石
    free_cd = 0,            %   免费cd
    goods = 0,              % 招募必得物品
    single_recruit = 0,     % 单次招募消耗
    ten_recruit = 0,        % 十连招消耗
    pr = 0,                 % 获得伙伴概率
    guaran_num = 0,         % 保底次数
    guaran_quality = []     % [品质1，品质2] 表示到底保底次数可以获得品质1或者品质2的伙伴
    }).

-record(base_partner_wash, {
    quality = 0,            % 品质
    goods = [],             %格式为：[洗髓消耗物品，物品数量]
    wash_attr = [],         % [{潜能品质（1-5分别对应普通、良好、优秀、卓越、完美），概率}，{潜能品质，概率}，{潜能品质，概率}，{潜能品质，概率}，{潜能品质，概率}]
    random_attr = [],       % [{体质, 概率，加成比例下限，加成比例上限}，{敏捷, 概率，加成比例下限，加成比例上限}，{灵巧, 概率，加成比例下限，加成比例上限}]
    comm_skill = [],        % [{技能数量，概率},{技能数量，概率},{技能数量，概率},{技能数量，概率}]
    sk_quality = [],        % [{技能品质，概率},{技能品质，概率},{技能品质，概率},{技能品质，概率}]
    prodigy = []            % [{伙伴洗髓后战力范围下限，伙伴洗髓后战力范围上限，对应为奇才概率},{伙伴洗髓后战力范围下限，伙伴洗髓后战力范围上限，对应为奇才概率}]
    }).

-record(base_partner_sk, {
    id = 0,                 % 物品类型id
    skill_id = 0,           % 技能id
    color = 0,              % 技能品质
    power = 0,              % 战力
    weight = 0,             % 权重
    career = 0,             % 五行 1-6分别对应金木水火土和无五行限制
    sk_desc = ""            % 描述
    }).

-record(base_partner_upgrade, {
    lv = 0,                 % 等级
    max_exp = 0,            % 最大经验值
    percentage = 0          % 获取玩家经验百分比
    }).

-record(base_exp_book, {
    id = 0,                 % 物品类型id
    exp = 0                 % 经验值
    }).

-record(base_partner_break, {
    quality = 0,            % 品质
    lv = 0,                 % 等级
    attr_val = 0,           % 突破值
    loss_coef = []          % 损耗系数
    }).

-record(base_partner_promote, {
    quality = 0,        % 品质
    prodigy = 0,        % 奇才
    goods = [],         % 消耗
    promote = []        % 资质提升条件
    }).


-record(base_partner_battle_slot, {
    slot = 0,               % 位置
    player_lv = 0           % 开启等级
    }).

-record(base_partner_callback, {
    quality = 0,            % 品质
    goods = 0               % 消耗
    }).

-record(base_partner_weapon, {
    goods_id = 0,           % 物品类型id
    partner_id = 0,         % 伙伴id
    weapon_l = 0,           % 左手武器资源id
    weapon_r = 0,           % 右手武器资源id
    attr = [],              % 属性
    combat_power = 0        % 战力
    }).

-record(base_partner_disband, {
    type = 1,           % 1 伙伴 2 技能
    quality = 0,        % 品质
    award = []          % [{?TYPE_GOOD, GoodsTypeId, 期望值}] 遣散时希望获得洗髓丹或者资质丹的期望值
    }).

-record(base_par_combat, {
    quality = 1,            % 品质
    quality_coef = 0,       % 品质系数
    ignore_power = 0        % 忽略战值
    }).

-record(base_summon_card, {
    id = 0,                 % 物品类型id
    partner_id = 0          % 伙伴id
    }).


% -------------------------- partner ---------------------------
-define(SQL_LAST_INSERT_ID,         <<"SELECT LAST_INSERT_ID() ">>).
-define(SQL_PARTNER_INSERT,  		<<"insert into `partner` set id=~p, player_id=~p, partner_id=~p, lv=~p, exp=~p, break_st=~p, break='~s', state=~p, pos=~p, attr_quality='~s', total_attr='~s', prodigy=~p, apti_take='~s', skill_learn='~s' ">>).
-define(SQL_BATCH_REPLACE_PARTNER,         "replace into `partner`(id, player_id, partner_id, lv, exp, break_st, break, state, pos, attr_quality, total_attr, prodigy, apti_take, skill_learn) values").
-define(SQL_BATCH_REPLACE_VALUES,         <<"(~p, ~p, ~p, ~p, ~p, ~p, '~s', ~p, ~p, '~s', '~s', ~p, '~s', '~s') ">>).

-define(SQL_PARTNER_DELETE,         <<"delete from `partner` where id in (~s) ">>).

-define(SQL_PARTNER_ALL_SELECT,         <<"select id, partner_id, lv, exp, break_st, break, state, pos, attr_quality, total_attr, prodigy, apti_take, skill_learn from `partner` where player_id=~p ">>).
-define(SQL_PARTNER_SELECT_BY_STATE,    <<"select id, partner_id, lv, exp, break_st, break, state, pos, attr_quality, total_attr, prodigy, apti_take, skill_learn from `partner` where player_id=~p and state=~p">>).

% -------------------------- player_partner ---------------------------

-define(SQL_PLAYER_PARTNER_REPLACE,         <<"replace into `player_partner` set id=~p, coin_recruit_tms=~p, coin_recruit_et=~p, gold_recruit_tms=~p, gold_recruit_et=~p, embattle='~s', recruit_list='~s' ">>).

-define(SQL_PLAYER_PARTNER_SELECT,          <<"select coin_recruit_tms, coin_recruit_et, gold_recruit_tms, gold_recruit_et, embattle, recruit_list from `player_partner` where id=~p ">>).
% -------------------------- skill ---------------------------
-define(SQL_PARTNER_SKILL_INSERT,       <<"insert into `partner_sk` set id=~p, player_id=~p, sk_id=~p, lv=~p, pos=~p ">>).
-define(SQL_PARTNER_SKILL_REPLACE,          "replace into `partner_sk`(id, player_id, sk_id, lv, pos) values").
-define(SQL_BATCH_SKS_VALUES,       <<"(~p, ~p, ~p, ~p, ~p)">>).

-define(SQL_PARTNER_SK_DELETE,         <<"delete from `partner_sk` where id in (~s) ">>).

-define(SQL_SK_ALL_SELECT,          <<"select id, sk_id, lv, pos from `partner_sk` where player_id=~p ">>).

% -------------------------- equip ---------------------------

-define(SQL_PARTNER_EQUIP_INSERT,       <<"insert into `partner_equip` set id=~p, player_id=~p, type=~p, weapon=~p ">>).
-define(SQL_PARTNER_EQUIP_REPLACE,          "replace into `partner_equip`(id, player_id, type, weapon) values").
-define(SQL_BATCH_EQUIPS_VALUES,        <<"(~p, ~p, ~p, ~p)">>).

-define(SQL_PARTNER_EQUIP_DELETE,         <<"delete from `partner_equip` where id in (~s) ">>).

-define(SQL_EQUIP_ALL_SELECT,       <<"select id, type, weapon from `partner_equip` where player_id=~p ">>).










