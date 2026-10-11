%% ---------------------------------------------------------
%% Author:  xyj
%% Email:   156702030@qq.com
%% Created: 2011-12-13
%% Description: 物品装备定义
%% --------------------------------------------------------

%% ----------------------------------------------------------------------------
%% @doc 特殊物品
%% ----------------------------------------------------------------------------

-define(GOODS_ID_GOLD,         34).             %% 钻石
-define(GOODS_ID_BGOLD,        35).             %% 绑钻
-define(GOODS_ID_COIN,         31).             %% 金币
-define(GOODS_ID_GDONATE,      38040009).       %% 公会贡献
-define(GOODS_ID_GFUNDS,       37).             %% 公会资金
-define(GOODS_ID_GACTIVITY,    39).             %% 公会活跃度
-define(GOODS_ID_GDRAGON_MAT,  36255046).       %% 公会龙魂
-define(GOODS_ID_SEA_EXPLOIT,  36255101).       %% 海域功勋
-define(GOODS_ID_EXP,          36060001).       %% 经验
-define(GOODS_ID_RUNE,         36100001).       %% 符文经验
-define(GOODS_ID_SOUL,         36110001).       %% 聚魂经验
-define(GOODS_ID_RUNE_CHIP,    36100002).       %% 符文碎片
-define(GOODS_ID_KEY,          38040001).       %% 背包钥匙
-define(GOODS_ID_SHOES,        38130001).       %% 小飞鞋
-define(GOODS_ID_DEVIL,      1011000001).       %% 小恶魔
-define(GOODS_ID_ANGER,      1011000002).       %% 小天使

%% 特殊货币
%% 清理货币的时候,不要delete掉,把值设置为0,否则会无法更新操作,因为数据库没有这个这个货币id
-define(GOODS_ID_THSCORE,                   36180001).          %% 寻宝积分
-define(GOODS_ID_BLUE_ARTI,                 36120001).          %% 蓝神器积分
-define(GOODS_ID_PURP_ARTI,                 36130001).          %% 紫神器积分
-define(GOODS_ID_ORAN_ARTI,                 36140001).          %% 橙神器积分
-define(GOODS_ID_PINK_ARTI,                 36150001).          %% 粉神器积分
-define(GOODS_ID_STAR,                      36200001).          %% 星力
-define(GOODS_ID_LOVE_NUM,                  40040001).          %% 恩爱值
-define(GOODS_ID_CHARM,                     36070001).          %% 魅力值
-define(GOODS_ID_FAME,                      36070002).          %% 名誉值
-define(GOODS_ID_3V3_HONOR,                 36070003).          %% 3v3声望值
-define(GOODS_ID_MON_SOUL,                  33).                %% 怪物精魄
-define(GOODS_ID_SEEK_HELP,                 36255001).          %% 求助币
-define(GOODS_ID_HELP,                      36255002).          %% 助力币
-define(GOODS_ID_KF_1VN,                    36255003).          %% 战魂
-define(GOODS_ID_KF_SAN,                    36255012).          %% 跨服圣域勋章
-define(GOODS_ID_ACHIEVE,                   40).                %% 成就点
-define(GOODS_ID_TOP_HONOR,                 41).                %% 荣耀值(巅峰竞技所得)
-define(GOODS_ID_SEAL,                      23).                %% 圣印强化材料
-define(GOODS_ID_DRACONIC,                  36255095).          %% 龙语强化材料
-define(GOODS_ID_MEDAL,                     42).                %% 圣域勋章
-define(GOODS_ID_SUMMON_CARD,               36255013).          %% 公会晚宴低级召唤卡
-define(GOODS_ID_MIDDLE_SUMMON_CARD,        36255014).          %% 公会晚宴中级级召唤卡
-define(GOODS_ID_HIGH_SUMMON_CARD,          36255015).          %% 公会晚宴高级召唤卡
-define(GOODS_ID_3V3_POINT,                 36255024).          %% 3v3功勋
-define(GOODS_ID_SUPVIP,                    36255042).          %% 至尊币
-define(GOODS_ID_EUDEMONS_SCORE,            36255041).          %% 圣兽领积分
-define(GOODS_ID_RDUNGEON_SCORE,            36255094).          %% 个人排行本积分
-define(GOODS_ID_LUCKY_SHOP_COIN,           36255096).          %% 幸运商店货币
-define(GOODS_ID_DRACONIC_SHOP_COIN,        36255097).          %% 龙语商店货币
-define(GOODS_ID_GODCOURT_SHOP_COIN,        36255099).          %% 神庭商店货币
-define(GOODS_ID_GUILD_PRESTIGE,            36255100).          %% 公会声望货币
-define(GOODS_ID_GUILD_PRESTIGE_GOOD,       38040091).          %% 公会声望货币物品
-define(GOODS_ID_ZEN_SOUL,                  36240001).          %% 战魂
-define(GOODS_ID_DEMONS_COIN,               36255103).          %% 魔元
-define(GOODS_ID_RECHARGE_COIN,             36210008).          %% 礼包货币代币
-define(GOODS_ID_NIGHT_GHOST_POINT,         36255115).          %% 百鬼夜行积分

-define(GOODS_ID_FASHION_NUM(PosId),            %% 时装精华
        case PosId of
            1 -> 12060001;
            2 -> 12060002;
            3 -> 12060003;
            4 -> 12060004;
            _ -> 0
        end).

%% ----------------------------------------------------------------------------
%% @doc 物品品质0-6 定义在 predefine.hrl
%% ----------------------------------------------------------------------------

%% ----------------------------------------------------------------------------
%% @doc 状态字段
%% ----------------------------------------------------------------------------
-define(UNBIND,                     0).         %% 非绑
-define(BIND,                       1).         %% 绑定
-define(NOT_QUICK_USE,              0).         %% 是否获得立即使用：0不立即使用
-define(QUICK_USE,                  1).         %% 是否获得立即使用：1立即使用
-define(CANNOT_TRADE,               0).         %% 不可交易
-define(CAN_TRADE,                  1).         %% 可交易
-define(CANNOT_BREAK,               0).         %% 可突破
-define(CAN_BREAK,                  1).         %% 不可突破


%% ----------------------------------------------------------------------------
%% @doc 常量字段
%% ----------------------------------------------------------------------------
-define(NOT_COUNT_TRANSFER_POWER,   0).         %% 计算可转移战力：不计算（不在当个物品战力计算，统一算）
-define(COUNT_TRANSFER_POWER,       1).         %% 计算可转移战力：计算

-define(WHOLE_AWARD_STREN,          1).         %% 全身奖励：强化 [{强化等级, 部位数量}]
-define(WHOLE_AWARD_STAR,           2).         %% 全身奖励：星级 [{装备星级, 部位数量}]
-define(WHOLE_AWARD_STONE,          3).         %% 全身奖励：宝石 [{宝石等级, 数量}]
-define(WHOLE_AWARD_HOLY_SEAL_STREN,4).         %% 全身奖励：圣印强化 总等级
-define(WHOLE_AWARD_PET_EQUIP_POS_LV, 5).         %% 全身奖励：精灵装备 部位等级
-define(WHOLE_AWARD_PET_EQUIP_STAGE,  6).         %% 全身奖励：精灵装备 阶数
-define(WHOLE_AWARD_PET_EQUIP_STAR,   7).         %% 全身奖励：精灵装备 星数
-define(WHOLE_AWARD_REFINE,           8).         %% 全身奖励：精炼 [{强化等级, 部位数量}]
-define(WHOLE_AWARD_STAGE,          9).         %% 全身阶数： [{阶数, 数量}]
-define(WHOLE_AWARD_COLOR,          10).         %% 全身颜色： [{颜色, 数量}]
-define(WHOLE_AWARD_RED_EQUIP,      11).         %% 全身红装： [{阶数, 数量}]
-define(WHOLE_AWARD_MOUNT_EQUIP_POS_LV, 12).     %% 全身奖励：坐骑装备 部位等级
-define(WHOLE_AWARD_MOUNT_EQUIP_STAGE,  13).     %% 全身奖励：坐骑装备 阶数
-define(WHOLE_AWARD_MOUNT_EQUIP_STAR,   14).     %% 全身奖励：坐骑装备 星数
-define(WHOLE_AWARD_MATE_EQUIP_POS_LV,  15).     %% 全身奖励：伙伴装备 部位等级
-define(WHOLE_AWARD_MATE_EQUIP_STAGE,   16).     %% 全身奖励：伙伴装备 阶数
-define(WHOLE_AWARD_MATE_EQUIP_STAR,    17).     %% 全身奖励：伙伴装备 星数

% 需要手动激活全身奖励类型
-define(MANUAL_WHOLE_AWARD_LIST, [?WHOLE_AWARD_STREN, ?WHOLE_AWARD_STONE]).

%% 装备子功能战力值
-define(EQUIP_STONE_POWER, 1).           %% 宝石



-define(SHOP_TYPE_GOLD,             1).         %% 商店类型 - 商城
-define(SHOP_TYPE_VIP_DRUG,         10229).     %% 商店类型 - VIP药店
-define(SHOP_TYPE_VIP_STORAGE,      10230).     %% 商店类型 - VIP仓库
-define(SHOP_TYPE_FORGE,            99301).     %% 商店类型 - 炼化NPC
-define(SHOP_TYPE_ARENA,            30055).     %% 商店类型 - 竞技场兑换NPC
-define(SHOP_TYPE_BATTLE,           30058).     %% 商店类型 - 战功兑换NPC
-define(SHOP_TYPE_HOUNOR,           30064).     %% 商店类型 - 荣誉兑换NPC
-define(SHOP_TYPE_SIEGE_SHOP,       30075).     %% 商店类型 - 城战商店NPC
-define(SHOP_TYPE_SIEGE_SHOP2,      30073).     %% 商店类型 - 城战商店NPC
-define(SHOP_TYPE_KING_HOUNOR,      30069).     %% 商店类型 - 帝王谷兑换NPC

-define(SHOP_SUBTYPE_COMMON,         2).        %% 商城子类型 - 绑定元宝和元宝都能买(成长变强)
-define(SHOP_SUBTYPE_COMMON2,        3).        %% 商城子类型 - 绑定元宝和元宝都能买(日常消耗)
-define(SHOP_SUBTYPE_POINT,         19).        %% 商城子类型 - 积分区
-define(SHOP_SUBTYPE_GOLD_BIND,     20).        %% 商城子类型 - 绑定元宝区

-define(GIFT_GET_WAY_NPC,           npc).       %% 礼包领取方式 - NPC领取
-define(GIFT_GET_WAY_CLIENT,        client).    %% 礼包领取方式 - 客户端领取
-define(GIFT_GOODS_ID_MEMBER,       532501).    %% 礼包物品类型ID - 会员礼包
-define(GIFT_GOODS_ID_MEDIA,        533007).    %% 礼包物品类型ID - 媒体推广礼包

%% 发奖励结果
-define(REWARD_RESULT_SUCC,        1).    %% 发奖励成功          ?REWARD_RESULT_SUCC => ObjectList
-define(REWARD_RESULT_IGNOR,       2).    %% 发奖励被忽略的物品  ?REWARD_RESULT_IGNOR => ObjectList

%% ----------------------------------------------------------------------------
%% @doc 物品位置
%% ----------------------------------------------------------------------------

%% 物品所在位置
-define(GOODS_LOC_GROUND,           0).         %% 地上
-define(GOODS_LOC_EQUIP,            1).         %% 人物装备位置
-define(GOODS_LOC_BAG,              4).         %% 普通背包
-define(GOODS_LOC_STORAGE,          5).         %% 仓库位置
-define(GOODS_LOC_GUILD,            6).         %% 帮派仓库位置
-define(GOODS_LOC_EQUIP_BAG,        7).         %% 装备背包
-define(GOODS_LOC_GOD_EQUIP_BAG,    8).         %% 神器背包

-define(GOODS_LOC_TREASURE,         10).         %% 寻宝背包

-define(GOODS_LOC_RUNE_BAG,         11).         %% 符文背包
-define(GOODS_LOC_RUNE,             12).        %% 符文位置

-define(GOODS_LOC_ANIMA_EQUIP,      13).        %% 灵器位置

-define(GOODS_LOC_SOUL,             14).        %% 聚魂位置
-define(GOODS_LOC_SOUL_BAG,         15).        %% 聚魂背包位置
-define(GOODS_LOC_EUDEMONS,         16).        %% 幻兽装备身上
-define(GOODS_LOC_EUDEMONS_BAG,     17).        %% 幻兽背包

-define(GOODS_LOC_HOLY_SEAL,        18).        %% 圣印身上(圣纹？？？)
-define(GOODS_LOC_FURNITURE_BAG,    19).        %% 家具背包
-define(GOODS_LOC_FURNITURE,        20).        %% 家具身上（算属性和可放进房子）

-define(GOODS_LOC_MOUNT_EQUIP,      22).        %% 坐骑装备身上
-define(GOODS_LOC_MATE_EQUIP,       23).        %% 伙伴装备身上

-define(GOODS_LOC_PET_EQUIP,        24).        %% 精灵装备身上

-define(GOODS_LOC_GARDEN_BUILDING,  26).        %% 庭院建筑身上

-define(GOODS_LOC_EQUIP_HUNTTING,   27).        %% 装备寻宝背包

-define(GOODS_LOC_DECORATION,       28).        %% 幻饰位置
-define(GOODS_LOC_DECORATION_BAG,   29).        %% 幻饰背包位置

-define(GOODS_LOC_SEAL,             30).        %% 圣印背包
-define(GOODS_LOC_SEAL_EQUIP,       31).        %% 圣印身上（命名有可能重复了）

-define(GOODS_LOC_MOUNT_EQUIP_BAG,      32).        %% 坐骑装备背包上
-define(GOODS_LOC_MATE_EQUIP_BAG,       33).        %% 伙伴装备背包上

-define(GOODS_LOC_DRAGON_EQUIP,     34).        %% 龙纹装备位置
-define(GOODS_LOC_DRAGON,           35).        %% 龙纹背包

-define(GOODS_LOC_BABY_EQUIP,       36).        %% 宝宝装备身上
-define(GOODS_LOC_BABY_EQUIP_BAG,   37).        %% 宝宝装备背包

-define( GOODS_LOC_GOD2_EQUIP,        38).        %% 降神装备身上
-define(GOODS_LOC_GOD2_EQUIP_BAG,    39).        %% 降神装备背包

-define(GOODS_LOC_REVELATION,        40).        %% 天启装备身上
-define(GOODS_LOC_REVELATION_BAG,    41).        %% 天启装备背包

-define(GOODS_LOC_DEMONS_SKILL,      42).       %% 使魔天赋技能书背包

-define(GOODS_LOC_DRACONIC,             43).        %% 龙语背包
-define(GOODS_LOC_DRACONIC_EQUIP,       44).        %% 龙语身上

-define(GOODS_LOC_CONSTELLATION,        45).        %% 星宿背包
-define(GOODS_LOC_CONSTELLATION_EQUIP,  46).        %% 星宿身上

-define(GOODS_LOC_GOD_COURT,        47).        %% 神庭背包
-define(GOODS_LOC_GOD_COURT_EQUIP,  48).        %% 神庭身上

-define(GOODS_LOC_GOD_GUILD_GOD_BAG,        49).        %% 公会神像背包
-define(GOODS_LOC_GOD_GUILD_GOD_EQUIP,  50).        %% 公会神像身上

-define(GOODS_LOC_CACHE,                        %% 需缓存的位置
        [0,1,4,5,6,7,8,10,11,12,13,14,15,16,17,18,19,20,22,23,24,26,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48, 49, 50]).

%% ----------------------------------------------------------------------------
%% @doc GOODS_LOC_GOD_EQUIP_BAG: 子位置宏定义
%% ----------------------------------------------------------------------------
-define(GOODS_SUB_LOC_GOD_EQUIP_BAG,    1).         %% 神装背包保护箱


%% 背包类型 列表
-define(GOODS_LOC_BAG_TYPES,
        [
         ?GOODS_LOC_BAG,
         % ?GOODS_LOC_EQUIP_BAG,
         % ?GOODS_LOC_GOD_EQUIP_BAG,
         ?GOODS_LOC_STORAGE,
         ?GOODS_LOC_RUNE_BAG,
         ?GOODS_LOC_TREASURE,
         ?GOODS_LOC_SOUL_BAG,
         ?GOODS_LOC_EUDEMONS_BAG,
         ?GOODS_LOC_DECORATION_BAG,
         ?GOODS_LOC_SEAL,
         ?GOODS_LOC_DRACONIC,
         ?GOODS_LOC_MOUNT_EQUIP_BAG,
         ?GOODS_LOC_MATE_EQUIP_BAG,
         ?GOODS_LOC_DRAGON,
         ?GOODS_LOC_BABY_EQUIP_BAG,
         ?GOODS_LOC_GOD2_EQUIP_BAG,
         ?GOODS_LOC_REVELATION_BAG,
         ?GOODS_LOC_DEMONS_SKILL,
         ?GOODS_LOC_CONSTELLATION,
         ?GOODS_LOC_GOD_COURT
         ,?GOODS_LOC_GOD_GUILD_GOD_BAG
        ]
       ).

%% 需要登陆获取的背包类型
-define(GOODS_LOC_BAG_TYPES_LOGIN,
        [
             ?GOODS_LOC_EQUIP            %% 装备在身物品
            ,?GOODS_LOC_BAG             %% 背包物品
            %,?GOODS_LOC_EQUIP_BAG       %% 装备背包
            %,?GOODS_LOC_GOD_EQUIP_BAG   %% 神器背包
            , ?GOODS_LOC_STORAGE        %% 仓库
            ,?GOODS_LOC_RUNE_BAG        %% 符文背包
            ,?GOODS_LOC_RUNE            %% 镶嵌在身上的符文
            ,?GOODS_LOC_ANIMA_EQUIP     %% 灵器
            ,?GOODS_LOC_TREASURE       %% 寻宝背包
            ,?GOODS_LOC_SOUL_BAG       %% 聚魂背包
            ,?GOODS_LOC_SOUL            %% 聚魂位置
            ,?GOODS_LOC_EUDEMONS        %% 幻兽装备身上
            ,?GOODS_LOC_EUDEMONS_BAG    %% 幻兽背包
            ,?GOODS_LOC_DECORATION      %% 幻饰位置
            ,?GOODS_LOC_DECORATION_BAG  %% 幻饰背包位置
            ,?GOODS_LOC_SEAL_EQUIP       %% 圣印身上
            ,?GOODS_LOC_SEAL            %% 圣印背包
            ,?GOODS_LOC_DRACONIC        %% 龙语背包
            ,?GOODS_LOC_DRACONIC_EQUIP  %% 龙语身上
            ,?GOODS_LOC_DRAGON_EQUIP    %% 龙纹背包身上
            ,?GOODS_LOC_DRAGON          %% 龙纹背包
            ,?GOODS_LOC_MOUNT_EQUIP_BAG
            ,?GOODS_LOC_MATE_EQUIP_BAG
            ,?GOODS_LOC_MOUNT_EQUIP
            ,?GOODS_LOC_MATE_EQUIP
            ,?GOODS_LOC_BABY_EQUIP
            ,?GOODS_LOC_BABY_EQUIP_BAG
            ,?GOODS_LOC_GOD2_EQUIP
            ,?GOODS_LOC_GOD2_EQUIP_BAG
            ,?GOODS_LOC_REVELATION
            ,?GOODS_LOC_REVELATION_BAG
            ,?GOODS_LOC_DEMONS_SKILL
            ,?GOODS_LOC_CONSTELLATION
            ,?GOODS_LOC_CONSTELLATION_EQUIP
            ,?GOODS_LOC_GOD_COURT
            ,?GOODS_LOC_GOD_COURT_EQUIP
            ,?GOODS_LOC_GOD_GUILD_GOD_BAG
            ,?GOODS_LOC_GOD_GUILD_GOD_EQUIP
        ]
       ).

%% 有数量限制的背包类型, 只定义背包不足会发送失败的背包类型
%% 例如：装备背包，是有数量限制，但是背包满了之后，是允许继续发送奖励的，多出的装备默认丢弃
%%       神器背包，神器背包满了之后，是不允许发送奖励的，会走发送失败流程
-define(GOODS_LOC_BAG_LIMIT_TYPES,
        [
         ?GOODS_LOC_BAG
         % ,?GOODS_LOC_GOD_EQUIP_BAG
         % ,?GOODS_LOC_EQUIP_BAG
        ,?GOODS_LOC_STORAGE        %% 仓库
        ,?GOODS_LOC_DECORATION_BAG
        ,?GOODS_LOC_SEAL
        ,?GOODS_LOC_MOUNT_EQUIP_BAG
        ,?GOODS_LOC_MATE_EQUIP_BAG
        ,?GOODS_LOC_DEMONS_SKILL
        ,?GOODS_LOC_CONSTELLATION
        ,?GOODS_LOC_GOD_COURT
        ]
       ).

-define(GET_BAG_MAX_CELL_NUM,   100).

-define(GOODS_BAG_DEF_NUM,          200).        %% 背包初始数量
-define(GOODS_BAG_MAX_NUM,          1000).       %% 背包最大数
-define(GOODS_BAG_EXTEND_GOLD,      40).        %% 背包扩展所需元宝
-define(GOODS_BAG_EXTEND_GOODS,      38250026).        %% 背包扩展所需道具
-define(GOODS_BAG_EXTEND_GOODS_NUM,  2).        %% 背包扩展所需道具数量
-define(GOODS_STORAGE_DEF_NUM,      200).        %% 仓库初始数量
-define(GOODS_STORAGE_MAX_NUM,      1000).        %% 仓库最大数
-define(GOODS_STORAGE_EXTEND_GOLD,  40).        %% 仓库扩展所需元宝
-define(RUNE_BAG_DEF_NUM,           100).       %% 符文背包初始数量

-define(GOD_EQUIP_BAG_MAX_NUM,      300).       %% 神装背包最大数量上限

-define(GOODS_GUILD_MAX_LEVEL,      10).        %% 帮派仓库最大等级
-define(GOODS_GUILD_EXTEND_MATERIAL,411001).    %% 帮派建设卡类型ID


%% ================== 物品大类--要实时更新（物品管理中的物品类型）=========================
-define(GOODS_TYPE_EQUIP,         10).          %% 类型 装备类
-define(GOODS_TYPE_EQUIP_MAT,     11).          %% 类型 装备材料类
-define(GOODS_TYPE_FASHION,       12).          %% 类型 时装类
-define(GOODS_TYPE_HOLY_SEAL,     13).          %% 类型 圣印类
-define(GOODS_TYPE_GEM,           14).          %% 类型 宝石类
-define(GOODS_TYPE_MOUNT,         16).          %% 类型 坐骑类
-define(GOODS_TYPE_PET,           18).          %% 类型 宠物类
-define(GOODS_TYPE_WING,          20).          %% 类型 翅膀类
-define(GOODS_TYPE_SUPER_WEAPON,  22).          %% 类型 神兵类
-define(GOODS_TYPE_MAGIC_WEAPON,  24).          %% 类型 法宝类
-define(GOODS_TYPE_RUNE,          26).          %% 类型 符文类
-define(GOODS_TYPE_SOUL,          28).          %% 类型 聚魂类
-define(GOODS_TYPE_DOGZ,          30).          %% 类型 神兽类
-define(GOODS_TYPE_GIFT,          32).          %% 类型 礼包类
-define(GOODS_TYPE_LV_GIFT,       33).          %% 类型 等级礼包类
-define(GOODS_TYPE_OPTIONAL_GIFT, 34).          %% 类型 自选礼包类
-define(GOODS_TYPE_COUNT_GIFT,    35).          %% 类型 次数礼包类
-define(GOODS_TYPE_OBJECT,        36).          %% 类型 特殊类
-define(GOODS_TYPE_GAIN,          37).          %% 类型 增益类
-define(GOODS_TYPE_PROPS,         38).          %% 类型 道具类
-define(GOODS_TYPE_EUDEMONS,      39).          %% 类型 幻兽类
-define(GOODS_TYPE_LOVE,          40).          %% 类型 姻缘类
-define(GOODS_TYPE_GUILD,         42).          %% 类型 公会类
-define(GOODS_TYPE_ARTIFACT,      44).          %% 类型 神器类
-define(GOODS_TYPE_FURNITURE,     45).          %% 类型 家具类
-define(GOODS_TYPE_MOUNT_EQUIP,   46).          %% 类型 坐骑装备类
-define(GOODS_TYPE_GARDEN_FURNITURE,   47).     %% 类型 坐骑装备类
-define(GOODS_TYPE_MATE_EQUIP,   48).          %% 类型 伙伴装备类
-define(GOODS_TYPE_PET_EQUIP,     50).          %% 类型 精灵装备类
-define(GOODS_TYPE_VIP,           52).          %% 类型 - VIP类
-define(GOODS_TYPE_DECORATION,    55).          %% 类型 - 幻饰类
-define(GOODS_TYPE_SEAL,          60).          %% 类型 - 圣印类
-define(GOODS_TYPE_DRAGON_EQUIP,  63).          %% 类型 - 龙纹类
-define(GOODS_TYPE_DRAGON_THING,  64).          %% 类型 - 龙纹材料类
-define(GOODS_TYPE_BABY_EQUIP,  65).            %% 类型 - 宝宝装备
-define(GOODS_TYPE_GOD_EQUIP,  70).             %% 类型 - 降神装备
-define(GOODS_TYPE_GOD_MATERIAL, 71).           %% 类型 - 降神材料类
-define(GOODS_TYPE_REVELATION, 72).           %% 类型 - 天启装备类
-define(GOODS_TYPE_TREASURE_MAP, 75).           %% 类型 - 藏宝图类
-define(GOODS_TYPE_DRACONIC,  77).              %% 类型 - 龙语类
-define(GOODS_TYPE_CONSTELLATION,  79).         %% 类型 - 星宿类
-define(GOODS_TYPE_GOD_COURT,      80).         %% 类型 - 神庭类
-define(GOODS_TYPE_GUILD_GOD,      81).         %% 类型 - 公会神像类
-define(GOODS_TYPE_ARMOUR,         82).         %% 类型 - 战甲类
-define(GOODS_TYPE_CLUE,           83).         %% 类型 - 斩妖线索类
-define(GOODS_TYPE_POOL_GIFT,      84).         %% 类型 奖池礼包类

-define(GOODS_TYPE_LOAD_OTHER,                  %% 需加载额外记录的类型
        [10, 12, 13, 26, 28, 32, 35, 39, 46, 48, 50, 55, 60, 65, 70, 72, 75, 76, 77, 79, 80, 81]).
-define(GOODS_TYPE_SELL_FORCE,  [12]).          %% 配置不能出售也可以强行出售的类型

%% ----------------------------------------------------------------------------
%% @doc 装备类型GOODS_TYPE_EQUIP:10专用的子类型宏定义
%% ----------------------------------------------------------------------------
-define(EQUIP_WEAPON,              1).          %% 装备子类型：武器
-define(EQUIP_PILEUM,              2).          %% 装备子类型：头冠1
-define(EQUIP_NECKLACE,            3).          %% 装备子类型：项链
-define(EQUIP_CLOTH,               4).          %% 装备子类型：衣服1
-define(EQUIP_AMULET,              5).          %% 装备子类型：护符
-define(EQUIP_TROUSERS,            6).          %% 装备子类型：裤子
-define(EQUIP_BRACELET,            7).          %% 装备子类型：手镯1
-define(EQUIP_CUFF,                8).          %% 装备子类型：护腕1
-define(EQUIP_RING,                9).          %% 装备子类型：戒子
-define(EQUIP_SHOE,               10).          %% 装备子类型：鞋子1
-define(EQUIP_ANGLE_DEVIL,        11).          %% 装备子类型：天使与恶魔

-define(EQUIP_TYPE_WEAPON,         1).          %% 武器类型
-define(EQUIP_TYPE_ARMOR,          2).          %% 防具类型
-define(EQUIP_TYPE_ORNAMENT,       3).          %% 仙器类型
-define(EQUIP_TYPE_SPECIAL,        4).          %% 特殊类型 小天使/小恶魔

-define(ALL_EQUIP_TYPES, [?EQUIP_WEAPON, ?EQUIP_PILEUM, ?EQUIP_NECKLACE,
                          ?EQUIP_CLOTH, ?EQUIP_AMULET, ?EQUIP_TROUSERS,
                          ?EQUIP_BRACELET, ?EQUIP_CUFF, ?EQUIP_RING, ?EQUIP_SHOE]). % 全部常规装备类型(可强化可穿戴...)

-define(ATTACK_EQUIP_TYPES, [?EQUIP_WEAPON, ?EQUIP_NECKLACE, ?EQUIP_AMULET, ?EQUIP_BRACELET, ?EQUIP_RING]). % 全部常规攻装类型
-define(DEFENCE_EQUIP_TYPES, [?EQUIP_PILEUM, ?EQUIP_CLOTH, ?EQUIP_TROUSERS, ?EQUIP_CUFF, ?EQUIP_SHOE]). % 全部常规防装类型

%% ----------------------------------------------------------------------------
%% @doc 装备材料类GOODS_TYPE_EQUIP_MAT:11专用的子类型宏定义
%% ----------------------------------------------------------------------------
-define(GOODS_SUBTYPE_MAGIC_STONE, 12).         %% 子类型 - 附魔石

%% ----------------------------------------------------------------------------
%% @doc 坐骑类GOODS_TYPE_MOUNT:16专用的子类型宏定义
%% ----------------------------------------------------------------------------
-define(GOODS_SUBTYPE_PANACEA,     1).          %% 子类型 - 灵丹
-define(GOODS_SUBTYPE_PET_STAR,    2).          %% 子类型 - 宠物星级培养道具

%% ----------------------------------------------------------------------------
%% @doc GOODS_TYPE_FASHION:12专用的子类型宏定义
%% ----------------------------------------------------------------------------
-define(GOODS_FASHION_CLOTHES,     1).          %% 子类型 - 衣服
-define(GOODS_FASHION_HAIR,        3).          %% 子类型 - 发饰

%% ----------------------------------------------------------------------------
%% @doc 宠物类GOODS_TYPE_PET:18专用的子类型宏定义
%% ----------------------------------------------------------------------------
-define(GOODS_SUBTYPE_BEAST_SOUL,  1).          %% 子类型 - 兽魂
-define(GOODS_SUBTYPE_MOUNT_STAR,  2).          %% 子类型 - 坐骑星级培养道具

%% ----------------------------------------------------------------------------
%% @doc 翅膀类GOODS_TYPE_WING:20专用的子类型宏定义
%% ----------------------------------------------------------------------------
-define(GOODS_SUBTYPE_FEATHER,  1).             %% 子类型 - 仙羽


%% ----------------------------------------------------------------------------
%% @doc GOODS_TYPE_GIFT:32专用的子类型宏定义
%% ----------------------------------------------------------------------------
-define(GOODS_GIFT_STYPE_NORMAL,    1).         %% 子类型 - 普通礼包
-define(GOODS_GIFT_STYPE_RUNE,      2).         %% 子类型 - 符文礼包
-define(GOODS_GIFT_STYPE_SOUL,      3).         %% 子类型 - 聚魂礼包
-define(GOODS_GIFT_STYPE_EUDEMONS,  4).         %% 子类型 - 幻兽礼包
-define(GOODS_GIFT_STYPE_FURNITURE, 5).         %% 子类型 - 家具礼包

-define(GOODS_GIFT_STYPE_MOUNT_EQUIP, 9).       %% 子类型 - 坐骑装备礼包
%%-define(GOODS_GIFT_STYPE_PET_EQUIP, 10).        %% 子类型 - 精灵装备礼包
-define(GOODS_GIFT_STYPE_MATE_EQUIP, 10).        %% 子类型 - 伙伴装备礼包
-define(GOODS_GIFT_STYPE_DECORATION, 14).        %% 子类型 - 幻饰礼包
-define(GOODS_GIFT_STYPE_EUDEMONS_LAND,  16).         %% 子类型 - 圣兽领礼包
-define(GOODS_GIFT_STYPE_CONSTELLATION,  17).         %% 子类型 - 星宿装备礼包
%% ----------------------------------------------------------------------------
%% @doc GOODS_TYPE_OBJECT:36专用的子类型宏定义
%% ----------------------------------------------------------------------------
-define(GOODS_SUBTYPE_GOLD, 1).              %% 子类型 - 钻石
-define(GOODS_SUBTYPE_BGOLD, 2).              %% 子类型 - 绑钻
-define(GOODS_SUBTYPE_COIN, 3).              %% 子类型 - 金币
-define(GOODS_SUBTYPE_VIPCARD, 4).              %% 子类型 - VIP卡
-define(GOODS_SUBTYPE_EXP, 6).              %% 子类型 - 经验
-define(GOODS_SUBTYPE_CHARGE_CARD, 21).         %% 子类型 - 钻石卡
-define(GOODS_SUBTYPE_CHARGE_COIN, 25).         %% 子类型 - 直购货币

-define(GOODS_SUBTYPE_CURRENCY, 255).         %% 子类型 - 特殊货币

-define(OBJECT_TO_MONEY_LIST, [1, 2, 3, 6]).         %% 子类型 - 货币物品转货币列表

%% ----------------------------------------------------------------------------
%% @doc 增益类GOODS_TYPE_GAIN:37专用的子类型宏定义
%% ----------------------------------------------------------------------------
-define(GOODS_GAIN_STYPE_EXP_PILL,   1).            %% 子类型 - 经验丹
-define(GOODS_GAIN_STYPE_EXP_WATER,  2).            %% 子类型 - 经验药水
-define(GOODS_GAIN_SUBTYPE_GOLD,  3).               %% 子类型 - 钻石
-define(GOODS_GAIN_SUBTYPE_BGOLD,  4).              %% 子类型 - 绑钻
-define(GOODS_GAIN_SUBTYPE_CURRENCY, 5).            %% 子类型 - 特殊货币
-define(GOODS_GAIN_SUBTYPE_CONTRACT_CHALLENGE, 6).  %% 子类型 - 契约挑战增益卡
-define(GOODS_GAIN_SUBTYPE_GUILD_PRESTIGE, 7).      %% 子类型 - 声望卡
-define(GOODS_GAIN_SUBTYPE_GUILD_DONATE, 8).        %% 子类型 - 帮贡道具
-define(GOODS_GAIN_SUBTYPE_LEVEL_UP_CARD, 9).       %% 子类型 - 等级直升卡
-define(GOODS_GAIN_SUBTYPE_DECORATION_BOSS, 10).    %% 子类型 - 幻饰Boss增益卡
-define(GOODS_GAIN_SUBTYPE_ZEN_SOUL, 11).           %% 子类型 - 战魂卡
-define(GOODS_GAIN_SUBTYPE_FIESTA_EXP, 12).         %% 子类型 - 祭典经验
-define(GOODS_GAIN_SUBTYPE_FIESTA_BUFF, 13).        %% 子类型 - 祭典增益卡
-define(GOODS_GAIN_SUBTYPE_LOVE_NUM, 14).           %% 子类型 - 恩爱值道具

%% ----------------------------------------------------------------------------
%% @doc 道具类型GOODS_TYPE_PROPS:38专用的子类型宏定义
%% ----------------------------------------------------------------------------
-define(GOODS_PROPS_STYPE_TASK,     1).             %% 子类型 - 任务
-define(GOODS_PROPS_STYPE_PASS,     3).             %% 子类型 - 通行证
-define(GOODS_PROPS_STYPE_MATER,    4).             %% 子类型 - 材料
-define(GOODS_PROPS_STYPE_BUGLE,    5).             %% 子类型 - 喇叭
-define(GOODS_PROPS_STYPE_DESG,     6).             %% 子类型 - 称号
-define(GOODS_PROPS_STYPE_OFFCARD,  7).             %% 子类型 - 离线卡
-define(GOODS_PROPS_STYPE_RED_ENVELOPES,  8).       %% 子类型 - 红包
-define(GOODS_PROPS_STYPE_RED_NAME, 9).             %% 子类型 - 红名相关
-define(GOODS_PROPS_STYPE_RELA,     10).            %% 子类型 - 好友社交相关
-define(GOODS_PROPS_STYPE_WORLD_BOSS_TIRED,    16). %% 子类型 - 世界boss疲劳卡/ yyhx为新野外boss药水
-define(GOODS_PROPS_STYPE_EUDEMONS_BOSS_TIRED, 17). %% 子类型 - 幻兽boss疲劳卡
-define(GOODS_PROPS_STYPE_ACT,      22 ).           %% 子类型 - 活动道具
-define(GOODS_PROPS_STYPE_PICTURE,      26).        %% 子类型 - 头像类
-define(GOODS_PROPS_STYPE_LEVEL_UP,    27).         %% 子类型 - 直升丹类
-define(GOODS_PROPS_STYPE_DUNGEON, 28).             %% 子类型 - 副本次数
-define(GOODS_PROPS_STYPE_PROTECT, 32).             %% 子类型 - 免战保护
-define(GOODS_PROPS_STYPE_DECORATION_BOSS, 33).     %% 子类型 - 幻饰boss
-define(GOODS_PROPS_STYPE_HI, 35).                  %% 子类型 - 嗨点道具
-define(GOODS_PROPS_STYPE_MASK, 36).                %% 子类型 - 蒙面道具
-define(GOODS_PROPS_STYPE_PREMIUM_FIESTA, 37).      %% 子类型 - 高级祭典激活道具
-define(GOODS_PROPS_STYPE_REINCARNATION, 42).       %% 子类型 - 转生丹

%% ----------------------------------------------------------------------------
%% @doc GOODS_TYPE_LOVE:40专用的子类型宏定义
%% ----------------------------------------------------------------------------
-define(GOODS_SUBTYPE_MARRIAGE_RING, 6).            %% 子类型 - 戒指解锁道具

%% ----------------------------------------------------------------------------
%% @doc 帮派类型GOODS_TYPE_GUILD:42专用的子类型宏定义
%% ----------------------------------------------------------------------------
-define(GOODS_SUBTYPE_GBOSS_MAT, 1).            %% 子类型 - 魔粉
-define(GOODS_SUBTYPE_GDONATE_ITEM, 2).         %% 子类型 - 帮贡道具
-define(GOODS_SUBTYPE_RED_ENVELOPE, 6).         %% 子类型 - 公会红包

%% ----------------------------------------------------------------------------
%% @doc 家具类 GOODS_TYPE_FURNITURE:45专用子类型宏定义
%% ----------------------------------------------------------------------------
-define(GOODS_FURNITURE_STYPE_DECORATION,   1).        %% 子类型 - 摆设
-define(GOODS_FURNITURE_STYPE_DC,           2).        %% 子类型 - 桌椅
-define(GOODS_FURNITURE_STYPE_WALLORNAMENT, 3).        %% 子类型 - 墙饰
-define(GOODS_FURNITURE_STYPE_NT,           4).        %% 子类型 - 床柜
-define(GOODS_FURNITURE_STYPE_FLOOR,        5).        %% 子类型 - 地板

%% ----------------------------------------------------------------------------
%% @doc 坐骑装备类 GOODS_TYPE_MOUNT_EQUIP:46专用子类型宏定义
%% ----------------------------------------------------------------------------
-define(GOODS_MOUNT_EQUIP_STYPE_SADDLE,     1).        %% 子类型 - 坐鞍
-define(GOODS_MOUNT_EQUIP_STYPE_REIN,       2).        %% 子类型 - 缰绳
-define(GOODS_MOUNT_EQUIP_STYPE_PEDAL,      3).        %% 子类型 - 脚蹬
-define(GOODS_MOUNT_EQUIP_STYPE_ARMOR,      4).        %% 子类型 - 护甲
-define(GOODS_MOUNT_EQUIP_STYPE_NECKLACE,   5).        %% 子类型 - 项圈
-define(GOODS_MOUNT_EQUIP_STYPE_CASQUE,     6).        %% 子类型 - 头盔

%% ----------------------------------------------------------------------------
%% @doc 精灵装备类 GOODS_TYPE_PET_EQUIP:48专用子类型宏定义
%% ----------------------------------------------------------------------------
-define(GOODS_PET_EQUIP_STYPE_WEAPON,    1).           %% 子类型 - 武器
-define(GOODS_PET_EQUIP_STYPE_CLOTH,     2).           %% 子类型 - 衣服
-define(GOODS_PET_EQUIP_STYPE_TROUSERS,  3).           %% 子类型 - 裤子
-define(GOODS_PET_EQUIP_STYPE_SHOE,      4).           %% 子类型 - 鞋子
-define(GOODS_PET_EQUIP_STYPE_NECKLACE,  5).           %% 子类型 - 项链
-define(GOODS_PET_EQUIP_STYPE_RING,      6).           %% 子类型 - 戒指

%% ----------------------------------------------------------------------------
%% @doc 精灵装备类 GOODS_TYPE_PET_EQUIP:55 专用子类型宏定义
%% ----------------------------------------------------------------------------
-define(GOODS_DECORATION_STYPE_MASK,        1).           %% 子类型 - 面具
-define(GOODS_DECORATION_STYPE_EARRING,     2).           %% 子类型 - 耳饰
-define(GOODS_DECORATION_STYPE_BADGE,       3).           %% 子类型 - 微章
-define(GOODS_DECORATION_STYPE_WATCH,       4).           %% 子类型 - 怀表
-define(GOODS_DECORATION_STYPE_CUFF,        5).           %% 子类型 - 袖口
-define(GOODS_DECORATION_STYPE_MAGIC,       6).           %% 子类型 - 魔法石


%% extra
-define (GOODS_OTHER_KEY_EUDEMONS_EXP, 1).    %% 物品额外数据之强化
-define (GOODS_OTHER_KEY_PET_EQUIP, 2).       %% 物品额外数据之精灵装备
-define (GOODS_OTHER_KEY_COUNT_GIFT, 3).      %% 物品额外数据之次数礼包
-define (GOODS_OTHER_KEY_GIFT, 4).            %% 物品额外数据之礼包
-define (GOODS_OTHER_KEY_SEAL, 5).
-define (GOODS_OTHER_KEY_MOUNT_EQUIP, 6).     %% 物品额外数据之坐骑装备
-define (GOODS_OTHER_KEY_MATE_EQUIP,  7).     %% 物品额外数据之伙伴装备
-define (GOODS_OTHER_KEY_GOD,  8).            %% 物品额外数据之降神装备
-define (GOODS_OTHER_KEY_SOUL, 9).            %% 物品额外数据之聚魂装备
-define (GOODS_OTHER_KEY_RUNE, 10).           %% 物品额外数据之符文数据
-define (GOODS_OTHER_KEY_TREASURE_MAP, 11).   %% 物品额外数据之藏宝图
-define (GOODS_OTHER_KEY_CONSTELLATION, 12).  %% 物品额外数据之星宿装备
-define (GOODS_OTHER_KEY_GOD_COURT,     13).  %% 物品额外数据之神庭装备
-define (GOODS_OTHER_KEY_GUILD_GOD,     14).  %% 物品额外数据之公会神像铭文

%% extra sub
%% 礼包subkey
-define (GOODS_OTHER_SUBKEY_GIFT_LV, 1).      %% 物品额外数据之礼包-等级礼包
-define (GOODS_OTHER_SUBKEY_GIFT_RUNE, 2).      %% 物品额外数据之礼包-符文礼包
-define (GOODS_OTHER_SUBKEY_GIFT_OPEN_DAY, 3).      %% 物品额外数据之礼包-开服天数礼包

%% ----------------------------------------------------------------------------
%% @doc GOODS_TYPE_DRAGON_EQUIP:63專用的子類型宏定義
%% ----------------------------------------------------------------------------
-define(GOODS_SUBTYPE_DRAGON_IMMORTAL,  1).         %% 子類型 - 不滅系
-define(GOODS_SUBTYPE_DRAGON_CRAFTY,    2).         %% 子類型 - 詭詐系
-define(GOODS_SUBTYPE_DRAGON_DETACH,    3).         %% 子類型 - 超然系

-define(GOODS_SUBTYPE_DRAGON_EQUIP_LIST,
    [?GOODS_SUBTYPE_DRAGON_IMMORTAL, ?GOODS_SUBTYPE_DRAGON_CRAFTY, ?GOODS_SUBTYPE_DRAGON_DETACH]).

%% ----------------------------------------------------------------------------
%% @doc GOODS_TYPE_ARMOUR:82專用的子類型宏定義
%% ----------------------------------------------------------------------------
-define(GOODS_SUBTYPE_HELMET,             1).     % 头盔
-define(GOODS_SUBTYPE_CLOTH,              2).     % 衣服
-define(GOODS_SUBTYPE_CUFF,               3).     % 护腕
-define(GOODS_SUBTYPE_TROUSERS,           4).     % 护腿
-define(GOODS_SUBTYPE_SHOES,              5).     % 鞋子
-define(GOODS_SUBTYPE_WEAPON,             6).     % 武器
-define(GOODS_SUBTYPE_RING,               7).     % 戒指
-define(GOODS_SUBTYPE_NECKLACE,           8).     % 项链
-define(GOODS_SUBTYPE_AMULET,             9).     % 护符
-define(GOODS_SUBTYPE_GUARD,              10).    % 守护
-define(GOODS_SUBTYPE_MATERIAL,           11).    % 材料

%% 装备部位列表
-define(GOODS_SUBTYPE_ARMOUR_EQUIP_LIST,
        [?GOODS_SUBTYPE_HELMET, ?GOODS_SUBTYPE_CLOTH, ?GOODS_SUBTYPE_CUFF, ?GOODS_SUBTYPE_TROUSERS, ?GOODS_SUBTYPE_SHOES,
        ?GOODS_SUBTYPE_WEAPON, ?GOODS_SUBTYPE_RING, ?GOODS_SUBTYPE_NECKLACE, ?GOODS_SUBTYPE_AMULET, ?GOODS_SUBTYPE_GUARD]).