%%%------------------------------------------------
%%% File    : record.hrl
%%% Author  : xyao
%%% Created : 2011-12-13
%%% Description: 物品相关信息
%%%------------------------------------------------

%% 物品有效期类型(有效期计算:lib_goods_util:calc_goods_expire_time/1)
-define(EXPIRE_PERMAMENT,   0).     % 永久有效(不过期)
-define(EXPIRE_DURATION,    1).     % 持续时间段有效(从获得物品开始计算)
-define(EXPIRE_TIMESTAMP,   2).     % 精确至时间戳有效
-define(EXPIRE_DAY,         3).     % 持续天数有效(凌晨4点为逻辑天数起始点)
-define(EXPIRE_OPEN_DAY,    4).     % 开服天数有效(凌晨4点为逻辑天数起始点)
-define(EXPIRE_ZERO_DAY,    5).     % 持续天数有效(凌晨0点为逻辑天数起始点)

%% 物品强化类型
-define(STREN_TYPE_ONCE,    1).     % 单次强化
-define(STREN_TYPE_AUTO,    2).     % 一键强化

%% 物品状态表：存于进程字典
-record(goods_status, {
          player_id = 0                         %% 用户ID
          , player_lv = 0                       %% 用户等级
          , null_cells = #{}                    %% 背包空格子位置 #{location => []} location为背包类型
          , num_cells = #{}                     %% 背包空格数量 #{location => {已用数量,最大数量}} location为背包类型
          , dict = undefined                    %% 物品dict
          , timeout_goods = []                  %% 过期物品列表 {type_id, num}
          , equip_stone_list = []               %% 装备宝石列表[ {equip_pos, #equip_stone{} } ]
          , equip_stren_list = []               %% 装备强化   [ {equip_pos, #equip_stren{}} ]
          , equip_refine_list = []              %% 装备精炼   [ {equip_pos, #equip_refine{}} ]
        % , equip_magic_list = []               %% 装备附魔列表[ {equip_pos, #{type => #equip_magic{}} } ]  其中type为魔石类型
          , equip_location = []                 %% 记录装备位置装备的物品[{equip_pos, equip_id}]
          , equip_special_attr = #{}            %% 装备的特殊属性加成 比如经验加成
          , equip_wash_map = #{}                %% 装备洗炼Map #{equip_pos => #equip_wash{}}
          , stren_award_list = []               %% 全身装备强化数奖励列表[{StrenLv, Num}]
          , stren_whole_lv = 0                  %% 当前装备全身强化等级
          , stone_award_list = []               %% 全身装备镶嵌数奖励列表[{StoneLv, Num}]
          , stone_whole_lv = 0                  %% 当前宝石全身强化等级
          , star_award_list = []                %% 全身装备星级数奖励列表[{Star, Num}]
          , refine_award_list = []              %% 全身装备精炼数奖励列表[{RefineLv,Num}]
          , stage_award_list = []               %% 全身装备阶数列表[{stage, num}]
          , color_award_list = []               %% 全身装备颜色列表[{color, num}]
          , red_equip_award_list = []           %% 全身红装列表 [{stage, num}]
          , gift_list = []                      %% 已领取礼包列表

          , fashion = undefined                 %% 当前穿戴的时装
          , angle_devil_ref = undefined         %% 天使恶魔定时器
          , equip_suit_list = []                %% 套装各部位状态
          , equip_suit_state = []               %% 套装状态信息
          , is_dirty_suit = false               %% 套装数据是否被修改过，在计算属性的时候用到
          , rune = undefined                    %% 符文#rune{}
          , soul = undefined                    %% 聚魂#soul{}
          , ring = undefined                    %% 戒指#ring{}
          , mount_equip_list = []               %% 坐骑装备部位列表 {equip_pos, #equip_mount{}}
          , equip_casting_spirit = []           %% 装备铸灵列表 [#equip_casting_spirit{}]
          , equip_spirit = undefined            %% 装备护灵 #equip_spirit{}
          , equip_awakening_list = []           %% 装备觉醒列表 [#equip_awakening{}]
          , equip_skill_list = []               %% 装备唤魔技能列表 [#equip_skill{}]
          , pet_equip_pos_list = []             %% 精灵装备部位列表[#pet_equip_pos{}]
          , mount_equip_pos_list = []           %% 坐骑装备部位列表 [#mount_equip_pos{}]
          , mate_equip_pos_list = []            %% 伙伴装备部位列表 [#mate_equip_pos{}]
          , rec_fusion = none                   %% 熔炼/吞噬 #rec_fusion{}
          , dec_level_list = []                 %% 幻饰强化
          , seal_stren_list = []                %% 圣印强化
          , draconic_stren_list = []            %% 龙语强化
          , god_equip_list = []                 %% 神装升阶 [{EquipPos, Level}]
          , revelation_equip_location = []      %% 记录天启装备位置装备的物品[{equip_pos, equip_id}]
          , equip_refinement = []               %% 神炼列表 [{EquipPos, Level}]
         }).

%% 物品状态表：PS record字段，用于计算战力。
%% !!! 无关计算战力的字段不要放这里，请放进程字段
-record(status_goods, {
          equip_attribute = undefined,        %% 装备加成属性
          equip_skill_power = 0,              %% 某些特殊属性的装备技能所加战力
          combat_power    = 0,                %% 装备战力
          fashion_attr    = undefined,        %% 时装属性 #{}
          equip_suit_attr = undefined,        %% 套装属性
          rune_attr = undefined,              %% 符文属性
          soul_attr = undefined,              %% 聚魂属性
          ring_attr = undefined,              %% 戒指属性
          bag_fusion_attr = undefined         %% 背包熔炼属性
          ,revelation_equip_attr = []         %% 天启装备属性
          ,revelation_equip_suit_attr = []    %% 天启套装属性
          ,equip_refinement_attr = []         %% 装备神炼属性
         }).

%%玩家物品额外记录
-record(goods_other, {
          suit_id=0,                          %% 套装ID，0为无
          skill_id=0,                         %% 技能ID，0为无
          addition=[],                        %% 附加属性列表，[{AttrType, Value, Color, CombatPower}]
          stren=0,                            %% 强化等级
          refine =0 ,                         %% 精炼等级
          overflow_exp = 0,                   %% 溢出经验
          fashion_stain_color = [],           %% 时装染色颜色列表
          rating = 0,                         %% 装备评分（不存数据库 只在数据从数据库加载到内容的时候计算一次）
          extra_attr = [],                    %% 扩展附加属性 支持{属性,值} {属性,基础值,成长间隔,单位成长}
          optional_data = []                  %% 特殊数据存储处 真是什么功能都放到物品上……
         }).

%%玩家物品记录
-record(goods, {
          id=0,                               %% 物品Id
          player_id=0,                        %% 角色Id
          guild_id=0,                         %% 帮派Id，只有存入帮派仓库才会有值
          goods_id=0,                         %% 物品类型Id，对应ets_goods_type.goods_id
          type=0,                             %% 物品类型
          subtype=0,                          %% 物品子类型
          equip_type=0,                       %% 装备类型
          price_type=0,                       %% 价格类型:0:物品(一般物品出售不配为物品);1:钻石;2:绑定钻石;3铜钱;4:公会贡献
          price=0,                            %% 购买价格
          bind=0,                             %% 绑定状态，0非绑定，1绑定
          trade=0,                            %% 交易状态，0不可交易，1可交易
          sell=0,                             %% 出售状态，0不可出售，1可出售
          isdrop=0,                           %% 丢弃状态，0不可丢弃，1可丢弃
          bag_location=0,                     %% 物品存放的背包位置, 见def_goods.hrl
          location=0,                         %% 物品所在位置, 见def_goods.hrl
          sub_location = 0,                   %% 物品子位置 见def_goods.hrl
          cell=0,                             %% 物品所在格子位置
          num=0,                              %% 物品数量
          expire_time=0,                      %% 有效期，0为无
          lock_time=0,                        %% 锁定结束时间戳，0为无：锁定期该物品不能上架出售
          level=0,                            %% 物品等级
          color=0,                            %% 物品颜色，0 白色，1 绿色，2 蓝色，3 紫色，4 橙色
          ctime = 0,                          %% 物品获得时间(创建):第一次使用程序时间:后面使用数据库的创建记录时间(时间有点误差)
          other = #goods_other{}              %% 物品额外记录 #goods_other{}
         }).

%%物品类型记录
-record(ets_goods_type, {
          goods_id,                           %% 物品类型Id
          goods_name,                         %% 物品名称
          type,                               %% 物品类型
          subtype,                            %% 物品子类型
          sell_category=0,                    %% 市场商品类型
          sell_subcategory=0,                 %% 市场商品子类型
          equip_type=0,                       %% 装备类型
          bind=0,                             %% 绑定状态，0非绑定，1绑定
          bag_location=4,                     %% 物品存放的背包位置
          trade=0,                            %% 交易状态，0不可交易，1可交易
          if_custom_price = 0,                %% 是否可自定义交易价格 0 否 1 是
          trade_price=[],                     %% 交易基准价格 [{服务器等级，价格}]
          lock_time=0,                        %% 交易锁定期(秒)：锁定期该物品不能上架出售
          use = 0,                            %% 是否在背包使用，0默认不可使用，1可使用
          compose = 0,                        %% 是否在背包合成，0默认不可使用，1可合成
          sell = 0,                           %% 是否在背包出售，0为不可出售，1为可出售
          quick_use = 0,                      %% 是否获得立即使用，0不立即使用，1立即使用
          use_one_key = 0,                    %% 是否一键使用，0不是，1是
          %% price_type=1,                       %% 价格类型:0:物品(一般物品出售不配为物品);1:钻石;2:绑定钻石;3金币;4:公会贡献
          %% price=0,                            %% 购买价格
          %% sell_price_type=3,                  %% 出售价格类型
          %% sell_price=0,                       %% 出售价格
          career=0,                           %% 职业限制:0为不限
          level=0,                            %% 等级限制
          max_overlap=0,                      %% 可叠加数:0为不可叠加
          color,                              %% 物品颜色:0白色 1绿色 2蓝色 3紫色 4橙色 5红装
          expire_type = 0,                    %% 有效期类型 0:普通时间戳,1:开服天数
          expire_time=0,                      %% 有效期，0为无
          base_attrlist=[],                   %% 基础属性
          addition=[],                        %% 附加属性 [{AttrType, Value, Color, CombatPower}]
          skill=[],                           %% 附加技能 [{skill_id, lv}]
          model_id = 0,                       %% 模型资源id
          suit_id=0,                          %% 套装ID，0为无
          sex=0,                              %% 性别限制，0为不限，1为男，2为女
          turn = 0,                           %% 转职限制
          jump = 0,                           %% 是否可以跳转:0否;1是
          effect_id = 0,                      %% 特效资源id
          can_storge = 1                       %% 能否存储于仓库
         }).

%% 物品价格表(不经常修改)
-record(goods_price, {
          goods_id = 0,                       %% 物品类型id
          price_type = 1,                     %% 价格类型:0:物品(一般物品出售不配为物品);1:钻石;2:绑定钻石;3金币;4:公会贡献
          price = 0,                          %% 购买价格
          sell_price_type = 3,                %% 出售价格类型
          sell_price = 0                      %% 出售价格
         }).

%% 快速购买价格
-record(quick_buy_price, {
     goods_type_id = 0,
     gold_price = 0,
     bgold_price = 0
}).

%% 装备背包容量
-record(base_equip_bag_num, {
     level_low = 0,
     level_high = 0,
     bag_num = 0
}).



%% ------------------------- 合成方式 -------------------------
-define(COMPOSE_TYPE_REGULAR,     1).             %% 只使用固定材料
-define(COMPOSE_TYPE_IRREGULAR,   2).             %% 只使用非固定材料
-define(COMPOSE_TYPE_MULTIPLE,    3).             %% 固定+非固定材料

%% ------------------------- 合成概率类型 -------------------------
-define(COMPOSE_RATIO_REGULAR,    1).             %% 固定成功率
-define(COMPOSE_RATIO_IRREGULAR,  2).             %% 不固定成功率

%% ------------------------- 合成物品绑定 -------------------------
-define(COMPOSE_BIND,             1).             %% 绑定
-define(COMPOSE_UNBIND,           2).             %% 不绑定
-define(COMPOSE_BIND_IF_MAT_BIND, 3).             %% 如果材料绑定则绑定

%% ------------------------- 合成传闻 -------------------------
-define(COMPOSE_TV_NULL,          0).             %% 没有传闻
-define(COMPOSE_TV_QF,            1).             %% 全服传闻

%% ------------------------- 合成类型 -------------------------
-define(COMPOSE_GOODS,              1).             %% 合成道具
-define(COMPOSE_EQUIP,              2).             %% 合成装备
-define(COMPOSE_RUNE,               3).             %% 合成符文
-define(COMPOSE_EUDEMONS,           4).             %% 幻兽装备
-define(COMPOSE_AWAKEN,             5).             %% 源力合成
-define(COMPOSE_SEAL,               8).             %% 圣印
-define(COMPOSE_RING,               9).             %% 戒蜀
-define(COMPOSE_RING_STAGE,         10).            %% 戒蜀升阶
-define(COMPOSE_GOD,                11).            %% 降神装备
-define(COMPOSE_BABY,               12).            %% 宝宝装备装备
-define(COMPOSE_REVELATION_EQUIP,   13).            %% 天启装备装备
-define(COMPOSE_GOD_DRAGON_LAN,     14).            %% 龙语合成
-define(COMPOSE_GOD_COURT,          15).            %% 神庭合成

-define(GOODS_COMPOSE_SPECIAL_NORMAL,  0).        %% 普通合成
-define(GOODS_COMPOSE_SPECIAL_1,  1).             %% 特殊合成：合成材料包含身上的装备的
-define(GOODS_COMPOSE_SPECIAL_2,  2).             %% 特殊合成：合成材料包含降神身上的装备的
-define(GOODS_COMPOSE_SPECIAL_3,  3).             %% 特殊合成：合成材料包含天启身上的装备的
-define(GOODS_COMPOSE_SPECIAL_4,  4).             %% 特殊合成：合成材料包含圣印身上的装备的
-define(GOODS_COMPOSE_SPECIAL_5,  5).             %% 特殊合成：合成材料包含龙语身上的装备的
-define(GOODS_COMPOSE_SPECIAL_6,  6).             %% 特殊合成：合成材料包含神庭核心身上的装备的
%% 物品合成配置
-record(goods_compose_cfg, {
          id = 0,                             %% 合成id
          name = "",                          %% 合成规则名字
          extra = "",                         %% 备注
          type = 0,                           %% 合成类型  1:道具合成
          role_lv = 0,                        %% 等级需求
          sex = 0,                            %% 性别限制
          condition = [],                     %% 合成开启条件
          subtype = 0,                        %% 合成方式  1:固定、2:非固定、3:固定+非固定
          regular_mat = [],                   %% 固定材料
          irregular_mat = [],                 %% 不固定材料
          hole_list = [],                     %% 孔位列表 [{hole, 1, Id}|{hole, 2, 0}|{hole, 0, 0}]
          cost = [],                          %% 消耗
          goods = [],                         %% 合成物品[{Type, GId, Num}]
          fail_goods = [],                    %% 失败奖励[{Type,Gid,Num}]
          ratio_type = 0,                     %% 概率类型 1:固定概率、2:动态概率(根据非固定材料的数量来取)
          ratio = [],                         %% 概率
          bind_type = 0,                      %% 绑定类型 1:绑定、2:非绑定、3:合成材料包含绑定材料则绑定
          tv_type = 0                         %% 0: 不发传闻 1: 全服传闻
         }).

%% 物品分解配置
-record(goods_decompose_cfg, {
          goods_id = 0,                       %% 物品类型id
          module = 0,                         %% 功能id
          irregular_num = 0,                  %% 随机材料能获得的种类
          irregular_mat = [],                 %% 分解获得的随机材料
          regular_num = 0,                    %% 固定材料种类
          regular_mat = []                    %% 分解获得的固定材料 [{type, goods_id, num}]
         }).

%% 物品效果
-record(goods_effect, {
          goods_id = 0,                       %% 物品类型ID
          goods_type = 0,                     %% 道具类型：0，即一次性道具；1BUFF道具
          buff_type = 0,                      %% BUFF类型ID
          effect_list = [],                   %% 效果[{coin,铜钱},{gold,元宝},{onhook_time, 1|2|5小时},{renet_day, Day}...]
          time = 0,                           %% 持续时长(秒)
          limit_type = 0,                     %% 限制类型：0无限制，1每日限制，2每周限制，3终生限制
          counter_module = 0,                 %% 次数所属模块ID
          counter_id = 0,                     %% 次数ID
          limit_scene = []                    %% BUFF或者道具可使用和生效的场景ID
         }).

%% 装备吞噬洗练配置
-record(base_equip_fusion, {
          goods_id = 0,                       %% 物品类型ID
          type = 0,                           %% 道具类型：1 吞噬 2 洗练
          fusion_exp = 0                       %% 吞噬所得经验
         }).

%% 装备吞噬洗练属性配置
-record(base_equip_fusion_attr, {
          level = 0,                       %% 等级
          exp_need = 0,                       %% 所需经验值
          attr_list = []                      %% 经验值
         }).

%% ================================= 兑换 =================================
%% 兑换类型
-define(EXCHANGE_TYPE_TREASURE_HUNT,    1).     %% 寻宝
-define(EXCHANGE_TYPE_SEEK_HELP, 2).            %% 求助兑换
-define(EXCHANGE_TYPE_HELP, 3).                 %% 助力兑换
-define(EXCHANGE_TYPE_KF_1VN, 4).               %% 战魂商城(kf1vn)
-define(EXCHANGE_TYPE_FRAGMENT, 5).               %% 碎片
-define(EXCHANGE_TYPE_DRAGON, 6).               %% 龙纹
-define(EXCHANGE_TYPE_COMPANION, 7).               %% 伙伴

%% 物品兑换规则
-record(goods_exchange_cfg, {
          id = 0,                             %% 兑换规则id
          type = 0,                           %% 兑换类型
          role_lv = 0,                        %% 需要的玩家等级
          cost_list = [],                     %% 消耗的物品列表
          obtain_list = [],                   %% 获得的物品列表
          lim_type = 0,                       %% 次数限制类型 0: 不限制 1: 每天限制 2: 每周限制 3: 终身限制
          module = 0,                         %% 模块id
          sub_module = 0,                     %% 模块子功能id
          lim_num = 0,                        %% 限制兑换数量
          condition = []                      %% 兑换开启条件[{Type, Value}], {Type:atom; Value：term}
         }).

%% ================================= 装备 =================================
-define(EQUIP, 1).                            %% 穿上装备
-define(UNEQUIP, 2).                          %% 卸下装备
-define(REPLACE_EQUIP, 3).                    %% 替换装备

%% 装备强化
-record (equip_stren, {
           stren       =  0 ,                 %% 当前强化等级(根据穿的装备变化)
           proficiency =  0                   %% 熟练度
          }).

%% 装备强化配置
-record (base_equip_stren, {
           part              = 0,             %% 装备部位
           stren             = 0,             %% 强化等级
           object_list       = [],            %% 消耗物品
           proficiency_plus  = 0,             %% 单次增加的熟练度
           ratio             = [],            %% 暴击率[{权重,倍率}]
           proficiency_limit = 0,             %% 当前等级的最大熟练度
           attr_list         = [],            %% 属性列表[{属性类型,属性值}]
           combat_power      = 0              %% 当前强化等级加的战力(只用于计算装备综合评分 不用于实际计算)
          }).

%% 装备精炼
-record (equip_refine,{
            refine = 0                        %%  精炼等级
        }).

%% 装备精炼配置
-record (base_equip_refine, {
            part         = 0,                 %% 装备部位
            refine       = 0,                 %% 精炼等级
            object_list  = 0,                 %% 消耗物品
            attr_list    = 0,                 %% 属性列表[{属性类型,属性值}]
            stren_ratio  = 0                  %% 强化属性加成百分比
        }).

%% 全身装备奖励加成
-record (base_whole_reward, {
           id = 0,                            %% 全身加成奖励id
           type = 0,                          %% 类型 1.强化 2.宝石
           need_lv = 0,                       %% 类型对应的总级别
           next_nlv = 0,                      %% 下一阶段需要的类型对应的总级别
           attr_list = [],                    %% 属性列表[{属性类型,属性值}]
           stren_ratio  = 0                   %% 全身强化属性加成百分比
          }).

%% 卸下宝石的原因
-define(UNLOAD_STONE_TYPE_UNEQUIP, 1).        %% 卸下装备
-define(UNLOAD_STONE_TYPE_REPLACE_EQUIP, 2).  %% 替换装备
-define(UNLOAD_STONE_TYPE_VIP_TIME_OUT, 3).   %% VIP过期

%% 宝石等级配置
-record(equip_stone_lv_cfg, {
          goods_id = 0,                       %% 物品id
          lv = 0,                             %% 等级
          rating = 0,                         %% 评分
          attr = [],                           %% 属性
          pre_lv_stone = 0,                   %% 上一等级
          next_lv_stone = 0,                  %% 下一等级
          need_num = 0                        %% 合成所需数量
         }).

%% 宝石精炼配置
-record(equip_stone_refine_cfg, {
          equip_pos = 0,                      %% 装备部位
          refine_lv = 0,                      %% 精炼等级
          attr = [],                          %% 当前等级的精炼属性
          overall_plus = 0,                   %% 总提升概率 百分倍放大
          exp = 0,                            %% 到下一精炼等级所需经验
          rating = 0                          %% 评分
         }).

%% 宝石精炼限制
-record(equip_stone_refine_limit, {
          equip_pos = 0,                      %% 装备部位
          limit = []                          %% 当前部位的精炼限制
         }).

%% 宝石数据
-record(equip_stone, {
          refine_lv = 0,                      %% 精炼等级
          exp = 0,                            %% 经验
          rating = 0,                         %% 宝石评分
          stone_list = []                     %% 宝石列表 [#stone_info{}]
         }).

%% 宝石数据
-record(stone_info, {
          pos = 0,                            %% 宝石孔位置
          bind = 0,                           %% 绑定状态
          gtype_id = 0                        %% 宝石物品类型id
         }).

%%装备套装归属表
-record(suit_belong, {
          suit_id,                            %% 套装ID
          level,                              %% 套装等级
          series,                             %% 套装系列, 1非人民币玩家,2人民币玩家
          max                                 %% 套装总件数
         }).

%% 套装属性表
-record(suit_attribute, {
          suit_id,                            %% 套装ID
          name = [],                          %% 套装名字
          suit_num,                           %% 套装件数
          value_type = []                     %% 属性值[{type, value}]
         }).

%% 装备属性配置
-record(equip_attr_cfg, {
          goods_id = 0,                       %% 物品类型id
          stage = 0,                          %% 装备阶级
          star = 0,                           %% 装备星级
          base_rating = 0,                    %% 基础装备评分(预览展示用)
          class_type = 0,                     %% 分类类型
          recommend_attr = [],                %% 推荐属性(预览展示用)
          nattr_1 = 0,                        %% 蓝属条数
          vattr_1 = [],                       %% 蓝属
          nattr_2 = 0,                        %% 紫属条数
          vattr_2 = [],                       %% 紫属
          nattr_3 = 0,                        %% 橙属条数
          vattr_3 = [],                       %% 橙属
          nattr_4 = 0,                        %% 红属条数
          vattr_4 = []                        %% 红属
          ,other_attr = []                    %% 额外属性
         }).

%% 装备进阶配置
-record(equip_upgrade_stage_cfg, {
          goods_id = 0,                       %% 物品类型id
          cost = [],                          %% 进阶消耗 [{type, goods_id, num}]
          ngoods_id = 0                       %% 进阶后的物品类型id
         }).

%%-define(DEF_EQUIP_DIVISION, 1).               %% 默认段位
-define(FREE_COUNT_ID,  1).                     %% 计数器id
-define(FREE_TIMES, 1).                         %% 每天免费次数
%% 装备洗练配置
-record(equip_wash_cfg, {                       %% base_equip_wash
          pos = 0,                              %% 部位
          duan = 0,                             %% 段位
          up_cost = [],                         %% 升段消耗
          need_rating = 0,                      %% 升段所需评分
          need_stage = 0 ,                      %% 升段所需装备阶数
          attr = [],                            %% 属性  [{权重,类型id}]
          wash_cost = [],                       %% 洗练基础消耗 [{lock_num, []}]
          extra_cost = [],                      %% 必出紫色额外消耗 [{lock_num, []}]
          extra_red_cost = [],                  %% 必出红属额外消耗 [{lock_num, []}]
          extra_orange_cost = []                %% 必出橙属额外消耗 [{lock_num, []}]
         }).

%% 装备洗练属性配置
-record(equip_wash_attr_cfg, {                %% base_equip_wash_attr
          pos = 0,                            %% 部位
          duan = 0,                           %% 段位
          attr_id = 0,                        %% 属性id
          attr_color = [],                    %% 属性颜色 [{权重, 颜色}]
          attr_white = [],                    %% 属性值  [{权重,[属性下限,属性上限]}]
          attr_green = [],                    %% 属性值  [{权重,[属性下限,属性上限]}]
          attr_blue = [],                     %% 属性值  [{权重,[属性下限,属性上限]}]
          attr_purple = [],                   %% 属性值  [{权重,[属性下限,属性上限]}]
          attr_orange = [],                   %% 属性值  [{权重,[属性下限,属性上限]}]
          attr_red = []                       %% 属性值  [{权重,[属性下限,属性上限]}]
         }).

-record(equip_wash_unlock_lv_cfg,{           %% base_equip_wash_unlock_lv
    pos =0,                                  %% 部位
    unlock_lv = 0,                           %% 洗炼解锁等级
    unlock_cost =[]                          %% 槽位解锁消耗
}).

%% 装备洗炼数据
-record(equip_wash, {
          duan = 0,                           %% 段位
          wash_rating = 0,                    %% 洗练评分
          attr = []                           %% [{槽位，颜色，属性id,属性值}] [{pos,color,attr_id,attr_val}]
         }).

-define(CASTING_SPIRIT_MIN_STAGE, 9).         %% 9阶装备才能铸灵
%% 装备铸灵阶数配置
-record(casting_spirit_stage_cfg, {
          pos = 0,                            %% 部位
          stage = 0,                          %% 阶数
          score = 0,                          %% 开启积分
          max_lv = 0,                         %% 本阶最高等级
          attr = []                           %% 特殊属性
         }).

%% 装备铸灵等级配置
-record(casting_spirit_lv_cfg, {
          pos = 0,                            %% 部位
          stage = 0,                          %% 阶数
          lv = 0,                             %% 等级
          attr_plus = 0,                      %% 属性加成(万分比)
          cost = []                           %% 升级消耗材料
         }).

%% 装备护灵数据
-record(spirit_lv_cfg, {
          lv = 1,                             %% 等级
          attr = [],                          %% 属性
          cost = []                           %% 升级消耗材料
         }).

%% 装备铸灵数据
-record(equip_casting_spirit, {
          pos = 0,                            %% 部位
          stage = 0,                          %% 阶数
          lv = 0,                             %% 等级
          rating = 0                          %% 评分
         }).

%% 装备护灵数据
-record(equip_spirit, {
          lv = 0                              %% 护灵等级
         }).

-define(EQUIP_AWAKENING_MIN_STAGE, 9).        %% 9阶装备才能觉醒
-define(EQUIP_AWAKENING_MIN_START, 2).        %% 2星装备才能觉醒

%% 装备吞噬/神器熔炼
-record(rec_fusion, {
          lv = 0
          , exp = 0
         }).

-record(equip_awakening_cfg, {
        stage = 0,
        lv_lim = 0
    }).

-record(equip_awakening_lv_cfg, {
        pos = 0,
        lv = 0,
        cost = [],
        base_plus = 0,
        stren_plus = 0,
        suit_base_plus = 0,
        suit_extra_plus = 0
    }).

-record(equip_awakening, {
        pos = 0,
        lv = 0
    }).

-record(equip_skill_lv_cfg, {
        skill_id = 0,
        lv = 0,
        cost = []
    }).

-record(equip_skill, {
        pos = 0,
        skill_id = 0,
        skill_lv = 0
    }).

%% ================================= 时装 =================================

-record(fashion_collect, {
          type = 0,                           %% 部位
          lv = 0,                             %% 收集等级
          exp = 0                             %% 当前收集度
         }).

%% ================================= 坐骑装备 =================================

-record(equip_mount, {
    lv = 0,                             %% 锻造等级
    exp = 0,                             %% 锻造经验
    stage = 0                            %% 阶
}).

%% ================================= 其他 =================================

%% 临时背包
-record(temp_bag, {
          id          = 0,
          pid         = none,
          goods_id    = 0,
          prefix      = 0,
          bind        = 0,
          stren       = 0,
          pos         = 0,
          num         = 0
         }).

%% 次数礼包数据
-record(count_gift, {
          day_count   = 0,   %% 今天使用次数
          use_count   = 0,   %% 总使用次数
          last_get_time = 0, %% 上次使用时间
          freeze_endtime = 0   %% 下次可使用时间
         }).

%% 消费
-record(consume, {
          type        = undefined :: atom(),  %% 类型
          goods_list  = [],                   %% 消耗的物品列表 [{GoodsTypeId, Num}]
          money_list  = [],                   %% 消耗的金钱 [{coin, Num}, {gold, Num}]
          other_list  = [],                   %% 其他消耗
          remark      = ""                    %% 备注
         }).

-define(SHOW_TIPS_0,    0).                   %% 0不飘
-define(SHOW_TIPS_1,    1).                   %% 1右下角飘字
-define(SHOW_TIPS_2,    2).                   %% 2聊天频道消息(目前客户端只会中间飘字)
-define(SHOW_TIPS_3,    3).                   %% 3右下角飘字 + 聊天频道消(目前客户端只会中间飘字)
-define(SHOW_TIPS_4,    4).                   %% 飘框特效
-define(SHOW_TIPS_5,    5).                   %% 5战魂加倍掉落专用(掉落物非战魂时请勿使用) 或者可以预留是双倍有客户端处理

%% 产出
-record(produce, {
        type        = undefined :: atom(),  %% 类型
        subtype     = 0,                    %% 子类型
        title       = "",                   %% 标题[背包不足]
        content     = "",                   %% 邮件[背包不足]
        off_title   = "",                   %% 不在线标题(off_title或off_content为"",则取title和content的内容)
        off_content = "",                   %% 不在线标题
        reward      = [],                   %% 奖励
        remark      = "",                   %% 备注
        show_tips   = 0                     %% 是否飘提示：0不飘|1右下角飘字|2聊天频道消息|3右下角飘字 + 聊天频道消
    }).


%% 奖励来源SOURCE
-define(REWARD_SOURCE_DROP,    0).          %% 普通掉落
-define(REWARD_SOURCE_OTHER_DROP,    1).    %% 额外掉落
-define(REWARD_SOURCE_FIRST, 2).            %% 首次击杀
-define(REWARD_SOURCE_TASK_DROP, 3).        %% 任务掉落
-define(REWARD_SOURCE_DUNGEON,   4).        %% 副本通关奖励
-define(REWARD_SOURCE_DUNGEON_MULTIPLE, 5). %% 副本多倍奖励
-define(REWARD_SOURCE_JOIN, 6).             %% 参与奖
-define(REWARD_SOURCE_ASSIST, 7).           %% 协助奖
-define(REWARD_SOURCE_WAVE, 8).             %% 副本波数奖励
-define(REWARD_SOURCE_WEEKLY_CARD, 9).      %% 周卡奖励

-define(REWARD_SOURCE_LIST, [?REWARD_SOURCE_DROP, ?REWARD_SOURCE_OTHER_DROP,
    ?REWARD_SOURCE_FIRST, ?REWARD_SOURCE_TASK_DROP, ?REWARD_SOURCE_DUNGEON, ?REWARD_SOURCE_WAVE]).  %%来源列表，除了多倍奖励

-define(REWARD_SOURCE_LIST_ALL, [?REWARD_SOURCE_DROP, ?REWARD_SOURCE_OTHER_DROP,
    ?REWARD_SOURCE_FIRST, ?REWARD_SOURCE_TASK_DROP, ?REWARD_SOURCE_DUNGEON, ?REWARD_SOURCE_DUNGEON_MULTIPLE, ?REWARD_SOURCE_WAVE, ?REWARD_SOURCE_WEEKLY_CARD]).  %%来源列表
%% 消耗额外参数
-record(cost_log_about, {
          type        = 0,                    %% 消费类型  商城为3 快速购买4
          data        = [],                   %% 自定义类型
          remark      = ""                    %% 备注
         }).

%% 奖励格式：通用的奖励筛选格式
%% {奖励类型, [ T, ...] }
-define(REWARD_TYPE_NORMAL, 0).           %% 通用的奖励##T = {Type, GoodsTypeId, Num}
-define(REWARD_TYPE_CAREER, 1).           %% 职业的奖励##T = {主键, [{Type, GoodsTypeId, Num}]}

%% 奖励参数:可动态变化
-record(reward_args, {
        career = 0                        %% 职业
    }).


%% 掉落传输信息record
-record(drop_transport_msg, {
    alloc = 0                        %% 分配方式
    ,mon_id = 0                      %% 怪物id
    ,mon_x  = 0                      %% 怪物死亡坐标
    ,mon_y  = 0
    ,hurt_role_list = []             %% 伤害列表
    ,bltype = 0                      %% 归属方式
    ,belong_list = []                %% 归属者列表，如果有归属则放里面
    ,drop_bag_list = []              %% 掉落包列表 [#drop_bag_transport_msg{}]
}).

%% 掉落传输信息record
-record(drop_bag_transport_msg, {
    drop_id = 0,                     %% 掉落包id
    x       = 0,                     %%掉落x坐标
    y       = 0                      %%掉落y坐标
    ,length2 = 0                     %%距离玩家直线距离的平方
}).

%% consume_record 消耗记录
-record(consume_record, {
    id = 0,                     %% id
    role_id = 0,
    mod_key = 0,                     %%功能主键
    mod = 0,
    sub_mod = 0,
    consume_list = [],                     %%消耗列表
    time = 0
}).

%% 静态背包
-record(static_bag, {
    gold = 0                    % 钻石
    , bgold = 0                 % 绑定钻石
    , coin = 0                  % 铜币
    % , goods_list = []           % 物品消耗##后续要支持
}).

%% 回收临界值
-define(RUNE_LIMIT_1, 1000).           % 符文临界值1
-define(RUNE_LIMIT_2, 1200).          % 符文临界值2
-define(SOUL_LIMIT_1, 1000).           % 源力临界值1
-define(SOUL_LIMIT_2, 1200).          % 源力临界值2

%% 物品回收一次性处理列表长度
-define(RUNE_DECOMPOSE_LENGTH, 1000).           % 符文自动分解一次处理长度
-define(LOGIN_RUNE_DECOMPOSE_LENGTH, 50).           % 登录符文自动分解一次处理长度
-define(SOUL_DECOMPOSE_LENGTH, 1000).           % 源力自动分解一次处理长度
-define(LOGIN_SOUL_DECOMPOSE_LENGTH, 50).           % 登录源力自动分解一次处理长度

%% =============== 新查看玩家信息面板功能ID定义 =====================

-define(MOD_BASE_EQUIP_DATA,        1).       %% 查看玩家的基本装备信息界面
-define(MOD_DRAGON_BALL_DATA,       2).       %% 星核界面
-define(MOD_SEAL_EQUIP_DATA,        3).       %% 影装界面
-define(MOD_DRACONIC_EQUIP_DATA,    4).       %% 神祭界面
-define(MOD_ILLUSION_DATA,          5).       %% 幻化界面
-define(MOD_REVELATION_EQUIP_DATA,  6).       %% 天启功能界面
-define(MOD_GOD_DATA,               7).       %% 降神界面 - 当前变身的
-define(MOD_DECORATION_EQUIP_DATA,  8).       %% 灵饰界面
-define(MOD_DRAGON_EQUIP_DATA,      9).       %% 神纹界面
-define(MOD_EUDEMONS_DATA,          10).      %% 蜃妖界面
-define(MOD_COMPANION_DEMONS_DATA,  11).      %% 神巫、妖灵界面
-define(MOD_RUNE_EQUIP_DATA,        12).      %% 御魂界面

%% 合法查看玩家ID列表，新增查看玩家信息面板功能ID时同时需添加到该列表
-define(LOOK_OVER_MODULE_LIST, [
    ?MOD_BASE_EQUIP_DATA, ?MOD_DRAGON_BALL_DATA, ?MOD_SEAL_EQUIP_DATA,
    ?MOD_DRACONIC_EQUIP_DATA, ?MOD_ILLUSION_DATA, ?MOD_REVELATION_EQUIP_DATA,
    ?MOD_GOD_DATA, ?MOD_DECORATION_EQUIP_DATA, ?MOD_DRAGON_EQUIP_DATA,
    ?MOD_EUDEMONS_DATA, ?MOD_COMPANION_DEMONS_DATA, ?MOD_RUNE_EQUIP_DATA
]).