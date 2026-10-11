%%-----------------------------------------------------------------------------
%% @Module  :       custom_act
%% @Author  :       Czc
%% @Email   :       389853407@qq.com
%% @Created :       2018-01-05
%% @Description:    定制活动
%%-----------------------------------------------------------------------------

%% 进程字典存储有效的定制活动[{Type, SubType}]
-define(P_VAILD_ACT_TYPE_LIST, "VAILD_ACT_TYPE_LIST").

%% 进程字典存储官服定制活动文件最后修改的时间
%% 如果修改时间不一样重新加载定制活动
-define(P_CUSTOM_ACT_NORMAL_LAST_MTIME, "LAST_MTIME").

%% 用ets存储当前已经开启的定制活动
-define(ETS_CUSTOM_ACT, ets_custom_act).            %% #act_info{}

%% ==================================== 定制活动类型 ==================================
-define(CUSTOM_ACT_TYPE_FLOWER_RANK_LOCAL,      1).         %% 本服魅力榜活动
-define(CUSTOM_ACT_TYPE_FLOWER_RANK,            2).         %% 跨服魅力榜活动
-define(CUSTOM_ACT_TYPE_WED_RANK,               3).         %% 结婚榜活动
-define(CUSTOM_ACT_TYPE_COLWORD,                4).         %% 开服集字兑换
-define(CUSTOM_ACT_TYPE_DAILY_CHARGE,           6).         %% 每日累充 有重置的
-define(CUSTOM_ACT_TYPE_7_RECHARGE,             7).         %% 开服七日累充
-define(CUSTOM_ACT_TYPE_SER_FES_DROP,           8).         %% 本服节日掉落
-define(CUSTOM_ACT_TYPE_CLS_FES_DROP,           9).         %% 跨服节日掉落
-define(CUSTOM_ACT_TYPE_RUSH_RANK,              10).        %% 开服冲榜
-define(CUSTOM_ACT_TYPE_FIVE_STAR,              11).        %% 五星评价
-define(CUSTOM_ACT_TYPE_DUN_MUL_DROP,           12).        %% 副本多倍掉落
-define(CUSTOM_ACT_TYPE_SMASHED_EGG,            13).        %% 砸蛋
-define(CUSTOM_ACT_TYPE_RECHARGE_GIFT,          14).        %% 充值有礼
-define(CUSTOM_ACT_TYPE_SIGN_REWARD,            15).        %% 登录送礼
-define(CUSTOM_ACT_TYPE_DUN_MUL_EXP,            16).        %% 副本多倍经验
-define(CUSTOM_ACT_TYPE_LIMIT_BUY,              17).        %% 特惠商城
-define(CUSTOM_ACT_TYPE_CLOUD_BUY,              18).        %% 众仙云购/幸运之星
-define(CUSTOM_ACT_TYPE_EUDEMONS_ATTACK,        19).        %% 幻兽入侵活动
-define(CUSTOM_ACT_TYPE_ACT_BOSS,               20).        %% 活动Boss
-define(CUSTOM_ACT_TYPE_ACT_EXCHANGE,           21).        %% 活动兑换
-define(CUSTOM_ACT_TYPE_ACT_FIREWORKS,          22).        %% 烟花盛典
-define(CUSTOM_ACT_TYPE_HI_POINT,               23).        %% 嗨点(狂欢活动)
-define(CUSTOM_ACT_TYPE_GUILD_CREAT,            24).        %% 勇者盟约
-define(CUSTOM_ACT_TYPE_PERFECT_LOVER,          25).        %% 完美恋人
-define(CUSTOM_ACT_TYPE_BOSS_FIRST_BLOOD,       26).        %% BOSS首杀
-define(CUSTOM_ACT_TYPE_GWAR,                   27).        %% 公会争霸运营活动
-define(CUSTOM_ACT_TYPE_LUCKY_TURNTABLE,        28).        %% 幸运转盘
-define(CUSTOM_ACT_TYPE_RED_ENVELOPES,          29).        %% 活动红包 同时只能有一个子类型生效
-define(CUSTOM_ACT_TYPE_CONSUME,                30).        %% 消费活动
-define(CUSTOM_ACT_TYPE_TREASURE_EVALUATION,    31).        %% 幸运鉴宝活动
-define(CUSTOM_ACT_TYPE_COLLECT,                32).        %% 收集活动
-define(CUSTOM_ACT_TYPE_RECHARGE_RANK,          33).        %% 本服充值排行
-define(CUSTOM_ACT_TYPE_RECHARGE_CONSUME,       34).        %% 充值消费活动
-define(CUSTOM_ACT_TYPE_LUCAY_FLOP,             35).        %% 幸运翻牌
-define(CUSTOM_ACT_TYPE_LOGIN_RETURN_REWARD,    36).        %% 0元豪礼
-define(CUSTOM_ACT_TYPE_KF_CLOUD_BUY_GOLD,      37).        %% 跨服云购(消耗钻石)
-define(CUSTOM_ACT_TYPE_KF_CLOUD_BUY_GBOLD,     38).        %% 跨服云购(消耗绑钻)
-define(CUSTOM_ACT_TYPE_CONSUME_RANK,           39).        %% 本服消费排行(钻石)
-define(CUSTOM_ACT_TYPE_CONTINUE_CONSUME,       40).        %% 连续消费
-define(CUSTOM_ACT_TYPE_OVERFLOW_GIFTBAG,       41).        %% 超值礼包
-define(CUSTOM_ACT_TYPE_SPEC_SELL,              42).        %% 精品特卖
-define(CUSTOM_ACT_TYPE_DAILY_TURNTABLE,        43).        %% 每日活跃转盘
-define(CUSTOM_ACT_TYPE_HOLYORGAN_HIRE,         44).        %% 神兵租借
-define(CUSTOM_ACT_TYPE_FASHION_ACT,            45).        %% 时装盛典
-define(CUSTOM_ACT_TYPE_SEVEN_DAY,              46).        %% 七日挑战
-define(CUSTOM_ACT_TYPE_SHAKE,                  47).        %% 摇摇乐
-define(CUSTOM_ACT_TYPE_FEAST_COST_RANK,        48).        %% 节日消费排行榜
-define(CUSTOM_ACT_TYPE_EXCHANGE_NEW,           49).        %% 节日兑换活动
-define(CUSTOM_ACT_TYPE_BONUS_TREE,             50).        %% 摇钱树
-define(CUSTOM_ACT_TYPE_FEAST_BOSS,             51).        %% 节日BOSS
-define(CUSTOM_ACT_TYPE_MON_INVADE,             52).        %% 异兽入侵
-define(CUSTOM_ACT_TYPE_FEAST_COST_RANK2,       53).        %% 跨服消费排行榜
-define(CUSTOM_ACT_TYPE_MOUNT_TURNTABLE,        54).        %% 坐骑转盘
-define(CUSTOM_ACT_TYPE_TIME_LIMIT_GIFT,        55).        %% 限时礼包
-define(CUSTOM_ACT_TYPE_LIVENESS,               56).        %% 节日活跃奖励
-define(CUSTOM_ACT_TYPE_DRAW_REWARD,            58).        %% 赛博夺宝
-define(CUSTOM_ACT_TYPE_FEAST_SHOP,             59).        %% 节日抢购商城
-define(CUSTOM_ACT_TYPE_LUCKEY_EGG,             60).        %% 幸运扭蛋
-define(CUSTOM_ACT_TYPE_SUPPLY,                 61).        %% 每日补给
-define(CUSTOM_ACT_TYPE_INVESTMENT,             62).        %% 节日投资
-define(CUSTOM_ACT_TYPE_LEVEL_ACT,              63).        %% 等级抢购活动
-define(CUSTOM_ACT_TYPE_FESTIVAL_RECHARGE,      64).        %% 节日首冲
-define(CUSTOM_ACT_TYPE_TRAIN_STAGE,            65).        %% 宠物升阶活动
-define(CUSTOM_ACT_TYPE_TRAIN_POWER,            66).        %% 宠物战力活动
-define(CUSTOM_ACT_TYPE_HOLY_SUMMON,            67).        %% 神圣召唤
-define(CUSTOM_ACT_TYPE_BUY,                    68).        %% 抢购
-define(CUSTOM_ACT_TYPE_NAME_VERIFICATION,      69).        %% 实名验证
-define(CUSTOM_ACT_TYPE_FOLLOW,                 70).        %% 关注公众号
-define(CUSTOM_ACT_TYPE_VIP_GIFT,               71).        %% vip特惠礼包
-define(CUSTOM_ACT_TYPE_PRAY,                   72).        %% 神佑祈愿
-define(CUSTOM_ACT_RECHARGE_ONE,                73).        %% 一元充值
-define(CUSTOM_ACT_TYPE_RECHARGE_RETURN_SHOW,   74).        %% 充值返还展示
-define(CUSTOM_ACT_TYPE_LEVEL_ACT_1,            75).        %% 等级抢购活动
-define(CUSTOM_ACT_TYPE_COHOSE_REWARD_DRAW,     76).        %% 自选奖池奖励抽奖
-define(CUSTOM_ACT_TYPE_BETA_RECORD,            77).        %% 封测活动----记录数据
-define(CUSTOM_ACT_TYPE_BETA_REWARD,            78).        %% 封测活动----发放奖励
-define(CUSTOM_ACT_TYPE_BONUS_POOL,             79).        %% 许愿池
-define(CUSTOM_ACT_TYPE_LUCKEY_WHEEL,           80).        %% 幸运探宝
-define(CUSTOM_ACT_TYPE_LEVEL_DRAW_REWARD,      81).        %% 等级抽奖
-define(CUSTOM_ACT_TYPE_RED_ENVELOPES_RAIN,     82).        %% 红包雨
-define(CUSTOM_ACT_TYPE_ACTIVATION,             83).        %% 活跃度转盘  抽奖
-define(CUSTOM_ACT_TYPE_RECHARGE,               84).        %% 充值转盘    抽奖
 -define(CUSTOM_ACT_TYPE_FIRST_KILL,            85).        %% 活动首杀
-define(CUSTOM_ACT_TYPE_RECHARGE_RETURN_RESET,  86).        %% 充值返还重置
-define(CUSTOM_ACT_TYPE_FORTUNE_CAT,            87).        %% 招财猫
-define(CUSTOM_ACT_TYPE_KF_GROUP_BUY,           88).        %% 跨服团购
-define(CUSTOM_ACT_TYPE_TREE_SHOP,              89).        %% 摇钱树商城
-define(CUSTOM_ACT_TYPE_QUESTIONNAIRE,          90).        %% 问卷调查
-define(CUSTOM_ACT_TYPE_CONTRACT_CHALLENGE,     91).        %% 契约挑战
-define(CUSTOM_ACT_TYPE_ESCORT,                 92).        %% 矿石护送
-define(CUSTOM_ACT_TYPE_STAR_TREK,              93).        %% 星际旅行
-define(CUSTOM_ACT_TYPE_EN_ZERO_GIFT,           94).        %% 英文0元礼包
-define(CUSTOM_ACT_TYPE_BOSS_FIRST_BLOOD_PLUS,  96).        %% 新版boss首杀
-define(CUSTOM_ACT_TYPE_DUN_FIRST_KILL,         97).        %% 副本首杀
-define(CUSTOM_ACT_TYPE_SPECIAL_GIFT,           98).        %% 超值特惠礼包
-define(CUSTOM_ACT_TYPE_DESTINY_TURN,           99).        %% 天命转盘
-define(CUSTOM_ACT_TYPE_TASK_REWARD,           100).        %% 活动  --幸运寻宝
-define(CUSTOM_ACT_TYPE_SHOP_REWARD,           101).        %% 活动  --限时抢购
-define(CUSTOM_ACT_TYPE_TREASURE_HUNT,         102).        %% 幸运鉴宝
-define(CUSTOM_ACT_TYPE_COMMON_DRAW,           103).        %% 通用抽奖
-define(CUSTOM_ACT_TYPE_UP_POWER_RANK,         104).        %% 战力冲榜%%
-define(CUSTOM_ACT_TYPE_PASS_DUN,              105).        %% 副本首通
-define(CUSTOM_ACT_TYPE_CREATE_ROLE,           106).        %% 回归登录活动
-define(CUSTOM_ACT_TYPE_RECHARGE_REBATE,       107).        %% 充值大回馈活动
-define(CUSTOM_ACT_TYPE_LV_BLOCK,              108).        %% 等级弹窗奖励活动
-define(CUSTOM_ACT_TYPE_CONTINUOUS_RECHARGE,   109).        %% 连续充值
-define(CUSTOM_ACT_TYPE_LV_GIFT,               110).        %% 冲级礼包
-define(CUSTOM_ACT_TYPE_ADVERTISEMENT,         111).        %% 广告advertisement_id
-define(CUSTOM_ACT_TYPE_RUSH_PACKAGE,          112).        %% 冲榜特惠礼包
-define(CUSTOM_ACT_TYPE_LOGIN_REWARD,          113).        %% 每日登陆活动
-define(CUSTOM_ACT_TYPE_RUSH_BUY,              114).        %% 冲榜抢购
-define(CUSTOM_ACT_TYPE_DAILY_DIRECT_BUY,      115).        %% 每日直购礼包
-define(CUSTOM_ACT_TYPE_RUSH_TREASURE,         116).        %% 冲榜夺宝
-define(CUSTOM_ACT_TYPE_ENVELOPE_REBATE,       117).        %% 红包返利
-define(CUSTOM_ACT_TYPE_THE_CARNIVAL,          118).        %% 全民狂欢
-define(CUSTOM_ACT_TYPE_SUBSCRIBE_MAIL,        119).        %% 预约邮件奖励
-define(CUSTOM_ACT_TYPE_SALE,                  120).        %% 超值礼包yy25d
-define(CUSTOM_ACT_TYPE_RECHARGE_POLITE,       121).        %% 累充有礼
-define(CUSTOM_ACT_TYPE_FIRST_DAY_BENEFITS,    122).        %% 首日福利礼包
-define(CUSTOM_ACT_TYPE_CREATE_GIFT,           123).        %% 首发活动-创角奖励
-define(CUSTOM_ACT_CYCLE_RANK_RECHARGE,        124).        %% 循环冲榜的累充活动
-define(CUSTOM_ACT_CYCLE_RANK_ONE_CHARGE,      125).        %% 循环冲榜单笔充值活动
-define(CUSTOM_ACT_TYPE_WEEK_OVERVIEW,         126).        %% 节日活动总览（周中、周末、节日活动）
-define(CUSTOM_ACT_TYPE_WISH_DRAW,             127).        %% 勾玉祈愿抽奖
-define(CUSTOM_ACT_TYPE_FIGURE_BUY,            128).        %% 外形直购
-define(CUSTOM_ACT_TYPE_FAIRY_BUY,             129).        %% 仙灵直购
-define(CUSTOM_ACT_TYPE_SYS_MAIL,              130).        %% 系统邮件(活动期间内系统按规则自动发放邮件)
-define(CUSTOM_ACT_TYPE_OVERSEAS_RECHARGE,     131).        %% 新海外累充活动

%% ==================================== 定制活动类型 ==================================

%% 同一时间只能开一个的类型(优先开启子类型更高的)
-define(UNIQUE_CUSTOM_ACT_TYPE, [
    ?CUSTOM_ACT_TYPE_TREASURE_HUNT,
    ?CUSTOM_ACT_TYPE_LEVEL_ACT
]).

%% 跨服活动类型
-define(KF_CUSTOM_ACT_TYPE, [
    ?CUSTOM_ACT_TYPE_FLOWER_RANK,
    ?CUSTOM_ACT_TYPE_CLS_FES_DROP,
    % ?CUSTOM_ACT_TYPE_CLOUD_BUY,
    ?CUSTOM_ACT_TYPE_KF_CLOUD_BUY_GOLD,
    ?CUSTOM_ACT_TYPE_FEAST_COST_RANK2,
    ?CUSTOM_ACT_TYPE_KF_CLOUD_BUY_GBOLD,
    ?CUSTOM_ACT_TYPE_KF_GROUP_BUY,
    ?CUSTOM_ACT_TYPE_ESCORT
    ]).

%% 改版时候未处理的跨服活动列表,这些定制活动走自己的流程
-define(UN_HANDLE_KF_CUSTOM_ACT_TYPE, [
    ?CUSTOM_ACT_TYPE_FLOWER_RANK,
    ?CUSTOM_ACT_TYPE_FEAST_COST_RANK2,
    ?CUSTOM_ACT_TYPE_CLOUD_BUY
    ]).

-define(CUSTOM_ACT_COUNTER_OFFSET, 10000). % 定制活动计数器偏移因子

-define(CUSTOM_ACT_COUNTER_TYPE(Param1, Param2), Param1*?CUSTOM_ACT_COUNTER_OFFSET+Param2). % 定制活动计数器类型转换

%% ==================================== showid ==================================
%% 服务端需要特殊处理的showid
%%

%% ======================== 注意事项 =========================
%% 定制活动关闭发奖的时候做好日志,数据会在活动关闭的时候清理
%% 定制活动目前支持主类型下的多个子类型同时开启,程序写代码的要做好兼容!!!!!!!!!
%% 相关的活动数据最好加一个数据的更新时间戳字段,通过判断最后的更新时间是否大于本次活动的开启时间,不是的话表示该份数据是过期数据,不能继续使用
%% 增加新活动的时候要检查一些通常函数
%%  （1）奖励是否领取,不领取要去掉。 见 lib_custom_act:receive_reward/4

%% 特殊定制活动的条件,配置condition字段的值,在这里加上备注
%% 通用的定制活动条件
%% {role_lv,        玩家等级}
%% {rank_len,       榜单长度}
%% {rank_limit,     榜单阈值}
%% {gap_time,       间隔天数(针对分为活动时间和领取奖励时间的活动)}
%% {sp_gap_time,    间隔天数(针对分为活动时间和全程领取奖励时间的活动)}

%% 通用的定制活动奖励条件
%% {role_lv,        玩家等级}
%% {role_lv,        [{玩家等级下限，玩家等级上限}]} 暂不不支持多个等级区间
%% {wlv,            世界等级}
%% {wlv,            [{世界等级下限，世界等级上限}]} 暂不不支持多个等级区间
%% {open_day,       开服天数}
%% {open_day,       [{开服天数下限，开服天数上限}]} 支持多个区间

%% 最好每个活动都把自己的详细条件写清楚
%% CUSTOM_ACT_TYPE_COLWORD      %% 开服集字兑换
%% 活动条件   [{role_lv, 100}, {sp_gap_time, 7}(间隔天数(针对分为活动时间和全程领取奖励时间的活动))]
%%            {clear_type, day} day每日清理,其他都表示活动期间不清理;{drops,[{道具ID,每天掉落上限,千分比}]}必填
%%            {time_drop, 秒} 物品掉落上一次与下一次的间隔时间不填默认5秒
%% 活动奖励条件[{goods_exchange, ExGoods, ModId, CounterId(一般就是奖励id)} mod_id和counter_id都填0就不记录全服今天兑换了几次]
%%            {personal_num, 0}个人兑换限制 {all_num, 0}全服兑换限制


%% CUSTOM_ACT_TYPE_SMASHED_EGG 砸蛋
%% {free_refresh_times, 每日免费刷新次数}
%% {smashed_times_lim, 每日钻石砸蛋次数上限}

%% CUSTOM_ACT_TYPE_ACT_BOSS 活动Boss
%% {time_points, [{{开始时,开始分,开始秒},{结束时,结束分,结束秒}}]
%% {num_lim, 创建Boss总数量限制}
%% {single_scene_max_num, 单个场景最多生成多少只Boss}
%% {boss_id, BossId}

%% CUSTOM_ACT_TYPE_ACT_EXCHANGE 活动兑换
%% 活动条件 [{clear_type, Type}] Type为 day:每日更新 act:活动结束更新
%% 活动奖励条件[{goods_exchange, ExGoods, ModId, CounterId(一般就是奖励id)} mod_id和counter_id都填0就不记录全服今天兑换了几次
%%              {exchange_limit, Limit}] 兑换上限

%% CUSTOM_ACT_TYPE_HI_POINT 嗨点
%% 活动条件
%% 活动奖励条件 {hi_points, Num}

%% CUSTOM_ACT_TYPE_BOSS_FIRST_BLOOD BOSS首杀
%% 活动奖励条件 {boss_id, BOSS_ID}

%% CUSTOM_ACT_TYPE_SIGN_REWARD 登录送礼
%% 活动条件
%% {role_lv, 200} 活动开启等级
%% {source_list, [平台标识...]} 平台标识列表##原子
%% 活动奖励条件
%% {sign_count, 累计天数} 累计天数奖励（一个活动只填一个）
%% {recharge, Num} 当日充值达到Num领取
%% {last_day, Day} 活动开启第几天领取

%% CUSTOM_ACT_TYPE_LIMIT_BUY 特惠商城
%% 活动条件 无
%% 活动奖励条件
%% [{cost, [{物品类型, 物品类型id, 物品数量}]（消耗列表）}, {discount, 折扣（例如70为7折）}, {limit, 限购数量}]

%% CUSTOM_ACT_TYPE_CLOUD_BUY 众仙云购/幸运之星
%% 活动条件
%% [{unlimited_time,[不限制购买次数时, 不限制购买次数分]},（不限制购买次数的开始时间，精确到分）
%% {award_time,[奖励发放时, 奖励发放分]}, 奖励发放时间，（精确到分）
%% {big_award_ids, [大奖id]}（大奖id列表，循环使用）]
%% 活动奖励条件 无

%% CUSTOM_ACT_TYPE_PERFECT_LOVER 完美恋人
%% [{reward, [{物品类型, 物品类型id, 物品数量}]}]（完美恋人奖励列表）
%% 活动奖励条件 无

%% CUSTOM_ACT_TYPE_DAILY_CHARGE 累计充值
%% 奖励条件说明
%% {type, N}    N :: 1|2  1每日累充类型 2周期累充类型 完成所有奖励的档次为1周期
%% {gold, N}    N :: integer()  累计充值钻石数量
%% {day, N}     N :: integer()  周期累充类型特有，表示N天累充达到多少钱
%% 每日充值达到300钻石 [{type,1},{gold,300}]
%% 累计2天充值达到300钻石 [{type,2},{day,2},{gold,300}]

%% CUSTOM_ACT_TYPE_7_RECHARGE 7天累充
%% 奖励条件说明
%% {gold, N}    N :: integer()  累计充值钻石数量
%% 充值达到1980钻石 [{gold,1980}]

%% CUSTOM_ACT_TYPE_DUN_MUL_DROP 副本多倍掉落
%% CUSTOM_ACT_TYPE_DUN_MUL_EXP  副本多倍经验
%% 活动条件说明
%% {lv,Lv} Lv :: integer() 玩家等级限制
%% [{types,[{DunType,N}]}]  DunType :: integer() 副本类型 N :: integer() 倍数
%% {time, [{{H1,M1},{H2,M2}}]} H1开始小时 M1开始分钟 H2结束小时 M2结束分钟
%% 宠物副本、金币副本掉落双倍 [{types,[{2,2},{3,2}]},{time,{{23,45,0},{23,59,59}}}]
%% 经验副本多倍经验 [{types,[{4,10000}]},{time,{{23,45,0},{23,59,59}}}]

%% CUSTOM_ACT_TYPE_EUDEMONS_ATTACK  幻兽入侵活动
%% 活动条件说明
%% {lv,Lv} Lv :: integer() 玩家等级限制
%% {time, [{{H1,M1},{H2,M2}}]} H1开始小时 M1开始分钟 H2结束小时 M2结束分钟
%% {buff,[{GoodsId, SkillId}]} 鼓舞效果 使用物品对应的buff技能
%% 活动期间每天18点、20点开启，持续30分钟 [{{18,0},{18,30}},{{20,0},{20,30}}]
%% 奖励条件说明 只有排行奖励配在了定制活动奖励里，最后一击和阶段伤害奖励请参考幻兽入侵活动配置
%% [{hurt_rank,{Min,Max}}] 排名在Min-Max之间(包含Min和Max)

%% CUSTOM_ACT_TYPE_GUILD_CREAT 勇者盟约
%% 奖励条件说明
%% {count,N}全服限制N个
%% {vice_count,N} 任命N个副会长
%% {member, N}公会达到多少人
%% {guild_lv,N}公会达到多少级
%% 所有条件都有个大前提，会长才能领取

%% CUSTOM_ACT_TYPE_LUCKY_TURNTABLE 幸运抽奖
%% 活动条件说明
%% [{ticket_price, 100}]  充值100元宝获得一张券
%% 奖励条件说明
%% [{weight, 权重},{n_times,倍数}] 根据权重获得该奖励id 奖励内容会乘以倍数
%% {tv, {ModuleId, Id}} 传闻主键 ModuleId:模块id, Id:语言表的id

%% CUSTOM_ACT_TYPE_CONSUME 消费活动
%% 活动条件说明
%% [{money_types,[gold,bgold,coin]}] 参与活动的消费种类 gold钻石消费 bgold绑钻消费 coin铜币消费
%% 活动奖励条件说明
%% [{money_type,Type,N}] Type = gold|bgold|coin
%% 例如活动期间累计消费888钻石 [{money_type,gold,888}]
%% 假如一个活动的所有奖励包含多个种类，则活动条件的money_types则需要对应全部种类

%% CUSTOM_ACT_TYPE_KF_CLOUD_BUY_GOLD|CUSTOM_ACT_TYPE_KF_CLOUD_BUY_BGOLD 跨服云购
%% 活动条件说明
%% [{draw_time, [{年,月,日,时,分}]}]目前每次活动只能开一期抽奖
%% 活动奖励条件说明
%% [{buy_num_lim, 个人购买基础次数}] 购买的基础次数 总购买次数 = 基础购买次数 * (1 + VIP次数加成系数) 结果向上取整
%% [{total_buy_num_lim, 跨服组总购买次数}]
%% [{winner_num_lim, 中奖人数}]

%% CUSTOM_ACT_TYPE_LOGIN_RETURN_REWARD 0元豪礼
%% 活动条件说明
%% 注意：活动的结束时间必须大于限购天数(buy_day)+返利奖励领取需要的最大天数，如果限购天数是3，最后一档奖励需要7天后才能领取，则结束时间必须在开始时间10天后
%% [{role_lv, 120}] 玩家参与等级
%% [{buy_day, 3}] 活动开始后多少天内允许购买商品，此天数按满24小时算一天
%% 活动奖励条件说明
%% [{lv, 170}] 购买需要的玩家等级
%% [{cost, [{1,0,688}]}] 购买商品需要的消耗
%% [{receive_day, 3}] 购买商品后多少天能领取返利
%% [{return_reward, [{2,0,388}]}] 返利奖励
%% [{icon,[{0,38140001,1}]}] 客户端展示用的返利图标 具体格式咨询客户端
%% [{model,[{0,12020007,1},{0,12010007,1},{0,12030007,1}]}] 客户端展示用的返利模型 具体格式咨询客户端

%% CUSTOM_ACT_TYPE_CONTINUE_CONSUME
%% 奖励条件说明
%% {type, N}    N :: 1|2  1每日消费 2累计天数消费
%% {gold, N}    N :: integer()  累计消费钻石数量
%% {day, N}     N :: integer()  累计天数消费特有，表示每天消费达到多少钱累计N天

%% CUSTOM_ACT_TYPE_OVERFLOW_GIFTBAG 超值礼包
%% 活动条件说明
%% [{role_lv, 120}] 玩家参与等级
%% [{buy_day, 3}] 玩家到达配置等级后多少天内允许购买商品，此天数按满24小时算一天
%% 奖励条件说明
%% {gift_id, 礼包ID} 有这项的话发此礼包(奖励仅当显示用) 否则直接发配的奖励
%% {old_price, 物品正则} 格式[{Type, Id, Num}] 旧价格
%% {now_price, 物品正则} 格式[{Type, Id, Num}] 现价格
%% {icon, 资源id} 宝箱资源 客户端用

%% CUSTOM_ACT_TYPE_SPEC_SELL 精品特卖
%% 活动条件说明
%% [{role_lv, 120}] 玩家参与等级
%% [{buy_day, 3}] 玩家到达配置等级后多少天内允许购买商品，此天数按满24小时算一天 如果不配的话 活动时间内都能买
%% 奖励条件说明
%% {now_price, 物品正则} 格式[{Type, Id, Num}] 现价格
%% {icon, 资源id} 资源 客户端用

%% CUSTOM_ACT_TYPE_LUCKY_FLOP 幸运翻牌
%% 活动条件说明
%% {role_lv, 120} 玩家参与等级
%% {times_lim, 120} 每日翻牌总次数
%% {refresh_cost, [{[1,2],3}]} 刷新消耗 {[次数下限, 次数上限], 道具数量}
%% {flop_cost, [{[1,2],3}]} 翻牌消耗 {[次数下限, 次数上限], 道具数量}
%% 奖励条件说明
%% {rweight, 刷新权重}
%% {sweight, 抽取权重}

%% CUSTOM_ACT_TYPE_DAILY_TURNTABLE 每日活跃转盘
%% 活动条件说明
%% {role_lv, 120} 玩家参与等级
%% {one_cost, [{0, 3310001, 1}]} 转一次消耗
%% {ten_cost, [{0, 3310001, 9}]} 转十次消耗
%% 奖励条件说明
%% 奖品条件
%% {weight, 权重}
%% {is_tv, 1|0} 是否发传闻 1:是 0:否
%% {is_rare, 1|0} 是否大奖  1:是 0:否
%% {limit_type, 1|0} 限制类型 0:个人 1:全服
%% {refresh_num, 数量} 重置所需次数
%% {limit_num, 数量}  限制数量
%% {topic, 1}  标题 客户端用
%% 活跃度奖励 偏移值100+
%% {liveness, 活跃度}

%% CUSTOM_ACT_TYPE_HOLYORGAN_HIRE 神兵租借
%% 活动条件说明
%% {hire_cost, 120} 租借的钻石消耗
%% {acc_hire_times, 3} 累积租借N次后永久获得
%% {hire_content, 外形类型id, id} 坐骑表的id

%% CUSTOM_ACT_TYPE_FEAST_COST_RANK 节日消费排行榜
%% 活动条件说明
%% {rank_len,       榜单长度}
%% {role_lv,        玩家上榜等级}
%% {rank_limit,     榜单阈值}

%% CUSTOM_ACT_TYPE_FEAST_BOSS
%% 活动条件说明

%% CUSTOM_ACT_TYPE_FEAST_COST_RANK 节日消费排行榜
%% 活动条件说明
%% {rank_len,       榜单长度}
%% {role_lv,        玩家上榜等级}
%% {rank_limit,     榜单阈值}

%% CUSTOM_ACT_TYPE_BONUS_TREE
%% CUSTOM_ACT_TYPE_MOUNT_TURNTABLE
%% 活动条件说明
%% {one_cost,[{Type,GoodsTypeId,Num}]} 抽奖一次的消耗
%% {ten_cost,[{Type,GoodsTypeId,Num}]} 抽奖10次的消耗
%% {score, Score} 抽奖一次增加的积分
%% {doomed, Times} 累计多少次必中大奖
%% {role_lv, LV} 等级限制
%% {act, Type, Subtype} 兑换商城活动
%% {add_reward, [{255, Gtype, Num}]} 抽一次增加的特殊货币
%% 奖励条件说明
%% {weight, 权重} 
%% {is_tv, 1|0} 是否发传闻 1: 是 0: 否 
%% {tv, {ModuleId, Id}} 传闻主键 ModuleId:模块id, Id:语言表的id
%% {is_rare, 1|0} 是否大奖 1: 是 0: 否 
%% {refresh_num, 数量} 重置所需次数 (0 为无限制) 
%% {limit_num, 数量} 限制数量 (0 为无限制) 
%% {total, Num} 领取累计奖励需要的累计抽奖次数
%% {rare_award, Weight} Weight大于1表示参与必中筛选，0或者不填表示不参与
%% {need_score, Score} 0或者不填表示非积分商城物品，大于零表示兑换需要的积分
%% {exchange_num, Num:可兑换数量, ClearType: 1:不清理/2:0点清理/3:4点清理}

%% CUSTOM_ACT_TYPE_MON_INVADE 异兽入侵
%% 活动条件说明
%% 奖励条件说明   只是用来控制图标出现，活动开启

% CUSTOM_ACT_TYPE_LIVENESS 节日活跃奖励
% 活动条件说明
% {cost1, [{0, 3310001, 1}]} 提交消耗(钻石提交)
% {cost2, [{0, 3310001, 1}]} 提交消耗(物品提交),会根据group尽量提交
% {group, 5} 组别次数
% {is_clear_count, 0|1} : 是否需要清理次数
% {drop_hour_list, [{H1, H2},...]} 掉落的小时范围 H1:开始小时 H2:结束小时(0点就填0)。(不配置默认不检查)
% {open_hour_list, [{H1, H2},...]} 开启消耗时间 H1:开始小时 H2:结束小时(0点就填0)。(不配置默认不检查)
% 奖励条件说明
% {weight, {StartTimes, EndTimes, Weight, SpecialWeight}} 权重
% {is_tv, 1|0} 是否发传闻 1: 是 0: 否 
% {is_rare, 1|0} 是否大奖 1: 是 0: 否 
% {refresh_num, 数量} 重置所需次数 (0 为无限制) 
% {limit_num, 数量} 限制数量 (0 为无限制) 
% {total, Num} 领取累计奖励需要的累计抽奖次数
% {limit_type, 1|0} 限制类型 0:个人 1:全服
% {ser_reward_type, {类型, 参数}} 全服奖励效果
% 类型=>参数
% 1经验本双倍收益=>持续时间(会延续,不超过活动时间和当前的逻辑结束时间(4点))
% 2材料本双倍收益=>持续时间(会延续,不超过活动时间和当前的逻辑结束时间(4点))
% 3全服boss立即刷新
% 4全服获得指定道具
% 5全服装备寻宝满幸运值=>持续时间(会延续,不超过活动时间和当前的逻辑结束时间(4点))
% {liveness, [{Min, Max, Value}]} 活跃度系数，上线的玩家在Min和Max之间,取对应的值
% {day, N} 本奖励的天数.0是任意天数,大于0指的是活动开始的逻辑天数(4点和明天四点是同一天)
% {clear_type, 1|2|3} 清理. 跟活动主类型的清理定义一致。1:不清理;2:0点清理;3:4点清理

%% CUSTOM_ACT_TYPE_DRAW_REWARD 赛博夺宝
%% 活动条件说明
%% {goods,[{TYPE, GOODTYPE, NUM}]} 基础消耗,NUM:基本数量
%% {role_lv, LV} 等级限制
%% {clear, [sum,day,wave]} !!顺序保持sum一定放在最前面，wave放在最后面!! sum：清理阶段奖励以及总次数；day:清理每日抽奖次数；wave:清理波数。清理时间与活动配置的清理类型保持一致，列表填需要清理的内容，保持顺序！！
%% {show_model,[{0,101010,1}]}客户端展示大奖模型用
%% {fighting,150000}大奖增加的战力
%% {wave, N} 波数控制 {normal, Num}普通奖励数量 {special, Num}高级奖励数量
%% 奖励条件说明
%% 见赛博夺宝配置

%% CUSTOM_ACT_TYPE_FEAST_SHOP 节日抢购商城
%% CUSTOM_ACT_TYPE_BUY 抢购
%% CUSTOM_ACT_TYPE_SHOP_REWARD 限时抢购
%% 活动条件说明
%% {role_lv, LV}
%% 奖励条件说明
%% {sp_gap_time, 7}(间隔天数(针对分为活动时间和全程领取奖励时间的活动))
%% {role_lv, LV}{role_lv, [{Min,Max}]} 该档次只有等级大于该等级或者在等级区间才能兑换
%% {clear_type, day} 每日重置，其他或者不填表示活动结束重置
%% {price,消耗货币类型,原价,折后价}
%% [{counter, ModId, CounterId(一般就是奖励id)} mod_id和counter_id都填0就不记录全服今天兑换了几次]
%% {personal_num, 0}个人兑换限制 {all_num, 0}全服兑换限制
%% {tv_id, 传闻id} 传闻id，0或者不填表示不发,

%% CUSTOM_ACT_TYPE_LUCKEY_EGG 幸运扭蛋
%% 活动条件说明
%% {free_times, 3} 免费次数
%% {one_cost, []}, {ten_cost, []} 消耗(1次，10次)
%% {show_time, 300} 幸运值展示时长
%% {luckey_ratio, list} 幸运值加成列表
%% {tv_list, list}
%% {luckey_increase, val} 幸运值增加时间间隔
%% {luckey_max, val} 幸运值上限
%% 奖励条件说明
%% {luckey_egg, 1, 100, 权重, 额外权重}
%% {total, Num} 领取累计奖励需要的累计抽奖次数

%% CUSTOM_ACT_TYPE_INVESTMENT 节日投资
%% 活动条件说明
%% {buy_day, 3} 购买天数
%% {invest_cost, [{投资档次, 现价[{type,id,num}], 原价[{type,id,num}]}]} 消耗
%% {invest_reward, [{投资档次, 奖励列表}]} 购买奖励
%% 奖励条件说明
%% {investment_lv, 所属投资档次}
%% {login_days, 登陆天数}

%% CUSTOM_ACT_TYPE_LEVEL_ACT 等级抢购活动
%% 定制活动控制开启
%% {wlv, 需要世界等级} 达到该等级才会真正开启

%% CUSTOM_ACT_TYPE_TRAIN_STAGE 培养物升阶活动
%% 活动条件说明
%% {max_show_num, 7} 最大显示数量
%% {level_reward, []} 层数奖励
%% 奖励条件说明
%% {fix_show, 1} 固定显示
%% {stage, 阶数, 星数}
%% {stage_show, 阶数下限, 星数下限, 阶数上限, 阶数上限}
%% {train_type, mount|fashion, 1} 宠物类型(坐骑配置的类型)

%% CUSTOM_ACT_TYPE_TRAIN_PWOER 培养物战力活动
%% 活动条件说明
%% {train_type, mount|fashion, TypeList}
%% 奖励条件说明
%% {power, 战力}
%% {power_show, 战力下限, 战力上限}
%% {train_type, mount|fashion, 1} 宠物类型(坐骑配置的类型)

%% CUSTOM_ACT_TYPE_HOLY_SUMMON 神圣召唤
%% {one_cost,[{Type,GoodsTypeId,Num}]} 抽奖一次的消耗
%% {ten_cost,[{Type,GoodsTypeId,Num}]} 抽奖10次的消耗
%% {role_lv, LV} 等级限制
%% 奖励条件说明
%% {weight, 权重} 
%% {is_tv, 1|0} 是否发传闻 1: 是 0: 否 
%% {tv, {ModuleId, Id}} 传闻主键 ModuleId:模块id, Id:语言表的id
%% {is_rare, 1|0} 是否大奖 1: 是 0: 否 
%% {is_show, 1|0} 是否要展示 1: 是 0: 否   客户端使用
%% {total, Num} 领取累计奖励需要的累计抽奖次数
%% {rare_draw, DrawTimes} 稀有奖池抽奖次数
%% {rare_pool, 0/1} 1表示属于稀有奖池 0或者不填则为普通奖池

%% CUSTOM_ACT_TYPE_VIP_GIFT
%% 奖励条件说明
%% {gold, 原价} 
%% {discount,现价列表}
%% {vip, Vip等级}

%% CUSTOM_ACT_TYPE_PRAY
%% 活动条件说明
%% {one_cost, GtypeId, Num} 单次抽奖消耗
%% {ten_cost, GtypeId, Num} 十抽消耗
%% {show_model, []} 模型 {show_effect, []} 特效 {show_icon, []}图片
%% {total_num, [{轮数下限, 上限, 每轮最大抽奖次数}...]} 每轮达到最大次数必中
%% {clrear_type, day} 每日清理，不填或其他表示活动期间不清理
%% {add_score,  Score} 每次抽奖获得积分
%% {wlv, Wlv} 世界等级限制
%% {free_times, Times} 免费次数
%% 奖励条件说明
%% {weight, [{入库次数,出库次数,基础权重,额外权重}]}
%% {record, 1} 是否全服记录 1表示需要，其他或者不填不需要记录
%% {tv_id, 传闻id} 传闻id，0或者不填表示不发,
%% {rare,0/1} 是否稀有 0普通 1稀有
%% {total, Score} 阶段奖励

%% CUSTOM_ACT_TYPE_COHOSE_REWARD_DRAW
%% 活动条件说明
%% {lv, 等级} 开启等级
%% {rare_0, Num}稀有数量
%% {rare_1, Num}史诗数量
%% {rare_2, Num}传说数量
%% {cost, [{次数下限, 次数上限, [{Type, Gtype, Num}]}]}    抽奖消耗
%% {refresh, [{次数下限, 次数上限, [{Type, Gtype, Num}]}]} 重置消耗
%% {rare_weight, [传说权重, 史诗权重, 稀有权重]} 稀有度权重列表
%% {add_weight, [{次数下限, 次数上限, 传说加成权重, 史诗加成权重, 稀有加成权重, 必中稀有度(2/1/0)}]}
%% 奖励条件说明
%% {weight, 权重};{weight, 权重, TimesList} TimesList：[{Times, 增加权重}],当抽奖次数大于等于times
%% 使用权重 = 权重 + 增加权重.ps:只会取最大入库次数的加成权重
%% {rare, 0/1/2} 2——传说, 1——史诗, 0——普通
%% {tv, 传闻id}
%% {stage, 次数} 阶段奖励

%% CUSTOM_ACT_TYPE_BETA_RECORD 封测活动记录数据
%% 活动条件说明
%% {login_open_lv, Lv} 登陆活动开启等级
%% {login_lv, Lv} 登陆活动奖励触发记录等级
%% {source_list, [平台标识...]} 平台标识列表##原子

%% CUSTOM_ACT_TYPE_BETA_REWARD 封测活动发放奖励
%% 活动条件说明
%% {login_reward, []} 登陆活动奖励
%% {source_list, [平台标识...]} 平台标识列表##原子
%% {recharge_return, [{LoginDay(登录天数), Ratio(返还比例)}]}:充值返还,登录天数

%% CUSTOM_ACT_TYPE_BONUS_POOL 许愿池
%% 活动条件说明
%% {cost,[{Type,GoodsTypeId,Num}]} 抽奖一次的消耗
%% {free_times, Value} 免费次数，每个大奖对应的免费次数
%% {role_lv, LV} 等级限制
%% {wlv, Min, Max} 世界等级限制
%% 奖励条件说明 
%% {tv, {ModuleId, Id}} 传闻主键 ModuleId:模块id, Id:语言表的id
%% {luckey_value, 最大幸运值} 不填或者为0表示非大奖
%% {weight, 基础权重}
%% {add_weight, [{Min, Max, AddWeight}...]} 幸运值加成权重，幸运值在Min Max之间时使用基础权重加上加成权重

%% CUSTOM_ACT_TYPE_LUCKEY_WHEEL 幸运探宝
%% 活动条件说明
%% {one_cost,[{Type,GoodsTypeId,Num}]} 抽奖一次的消耗
%% {ten_cost,[{Type,GoodsTypeId,Num}]} 抽奖十次的消耗
%% {base_pool_reward, [{Type,GoodsTypeId,Num}]} 初始公共奖池
%% {add_reward_draw, [{Type,GoodsTypeId,Num}]} 每次抽奖增加的公共奖池奖励
%% {role_lv, LV} 开启等级
%% {is_kf, 0否/1是} 是否跨服
%% {pool_range,[{0,Max0,Source0},{Min1,Max,Source}...{Min_n,null,Source_n}]} 大奖资源
%% 奖励条件说明 
%% {rare, 0:普通 1:稀有 2:罕见} 稀有以上才会有记录
%% {reward, 50} 公共奖池奖励的50%
%% {tv, {ModuleId, Id}} 传闻主键 ModuleId:模块id, Id:语言表的id
%% {weight, [{MinDrawtimes:抽奖次数下限, MaxDrawtimes:抽奖次数上限, AddWeight:额外增加的权重}], BaseWeight}

%% CUSTOM_ACT_TYPE_ACTIVATION
%% 活动条件说明
%% {cost,[{Type,GoodsTypeId,Num}]} 抽奖消耗
%% {activation, 150} 150点活跃度可领取代币
%% {activation_reward, [{Type, Gtype, Num}]} 活跃度奖励
%% {role_lv, LV} 开启等级
%% {source_list, [平台标识...]} 平台标识列表##原子
%% 奖励条件说明 
%% {rare, 0:普通 1:稀有 2:罕见} 稀有以上才会有跨服记录
%% {tv, {ModuleId, Id}} 传闻主键 ModuleId:模块id, Id:语言表的id
%% {weight, Weight} 权重
%% {day_max, Num} 每日最大抽中数量
%% {max_num, MaxNum:活动期间可抽中次数}
%% {num, [{Min:充值最小金额, Max:充值最大金额, Num:该区间每日可抽中次数}...]}

%% CUSTOM_ACT_TYPE_RECHARGE
%% 活动条件说明
%% {cost,[{Type,GoodsTypeId,Num}]} 抽奖消耗
%% {recharge, [{Id, Money}...]} 充值阶段 id从1开始
%% {role_lv, LV} 开启等级
%% {source_list, [平台标识...]} 平台标识列表##原子
%% {recharge_reward, [{Id, [{Type, Gtype, Num}]}...]} 充值达到的奖励
%% 奖励条件说明 
%% {rare, 0:普通 1:稀有 2:罕见} 稀有以上才会有跨服记录
%% {tv, {ModuleId, Id}} 传闻主键 ModuleId:模块id, Id:语言表的id
%% {weight, Weight} 权重
%% {day_max, Num} 每日最大抽中数量
%% {max_num, MaxNum:活动期间可抽中次数}
%% {num, [{Min:充值最小金额, Max:充值最大金额, Num:该区间每日可抽中次数}...]}

%% CUSTOM_ACT_TYPE_FIRST_KILL
%% 活动首杀
%% {kill_msg, scene_id, boss_id, [{Type,GoodsTypeId,Num}]} {场景id, bossId, 奖励展示}  击杀信息
%% {lv, 等级}

%% CUSTOM_ACT_TYPE_RED_ENVELOPES_RAIN
%% 活动条件说明
%% {rain_time, StartTimeSec, TotalWave, TimeGap} 波数时间控制
%% {wave_envelopes_num, NumList} 波数红包数量控制
%% {rain_value, recharge|activity, _Value} 充值/活跃红包
%% 奖励条件说明 
%% {rare, 0:普通 1:稀有}
%% {weight, Weight} 权重

%% CUSTOM_ACT_TYPE_KF_GROUP_BUY
%% 活动条件
%% {buy_day, 购买天数}
%% 奖励条件
%% {cost, 原价, 折扣价, 订购价}
%% {discount, [{人数, 价格}]}
%% {buy_count, 限购数}

%% CUSTOM_ACT_TYPE_TREE_SHOP
%% 活动条件说明
%% {money, 特殊货币类型id}
%% 奖励条件说明 
%% {wlv, 世界等级} 活动开启时世界等级达到要求才能兑换
%% {exchange_num, Num:可兑换数量}
%% {clear_type, day} 每日数量限制/其他或者不填表示活动期间兑换
%% {cost, [{255, 特殊货币类型id, Num}]}消耗

%% CUSTOM_ACT_TYPE_FOLLOW
%% 奖励邮件标题是奖励名字
%% 奖励邮件内容是奖励描述

%% CUSTOM_ACT_TYPE_QUESTIONNAIRE
%% 活动条件说明
%% {role_lv, LV} 开启等级
%% 奖励条件说明 
%% {questionnaire, Type}:完成的问卷类型

%% CUSTOM_ACT_TYPE_ESCORT
%% 活动条件说明
%% {role_lv, Lv}
%% {time, [{{StartHour, StartMinute},{EndHour, EndMinute}}]} 开启时间
%% {show_time, 秒} 展示时间 前多少秒

%% CUSTOM_ACT_TYPE_DESTINY_TURN
%% 天命转盘
%% {role_lv, 等级} 等级限制
%% {turn, [{轮次, 消耗积分}]} 对应所有轮次消耗积分
%% {double_point, [{双倍积分消费类型, 跳转id}]} 问服务端与客户端拿
%% 例： [{role_lv,160},{turn, [{1, 2000}, {2,3000}]},{double_point,[{pay_sell, 20}]}]

%% CUSTOM_ACT_TYPE_COMMON_DRAW
%% 活动条件说明
%% {max_luck, 最大幸运值} 达到当前幸运值的抽奖必定获取大奖 (若该值是0，则是用幸运值兑换奖励类型,抽中大奖不会清空自身幸运值) 【必填】
%% {per_luck, 每次抽奖提供幸运值} 【必填】
%% {role_lv, 活动开放等级} 活动开放等级 【必填】
%% {one_cost, 单抽消耗} 【必填】
%% {ten_cost, 10连消耗} 【必填】
%% {is_back, 是否放回奖励}
%% {tv_info, {ModId, TvId}}   抽奖传闻的ID  【必填】
%% {consume_type, xxxxx}  消费类型【必填】
%% 奖励条件说明 (一下选项全是可选) weight， total， exchange三选一
%% {weight, 权重}/ {weight, {抽奖次数下限, 抽奖次数上限, 区间权重, 权重}}/ {weight, {{幸运值下限, 幸运值上限, 每幸运值增加权重}, 基础权重}}
%% {is_nice, 是否大奖}
%% {is_tv, 是否传闻}
%% {is_rare, 是否记录}
%% {total, 次数累计奖励}  不能与weight， exchange同时出现
%% {exchange, 所需幸运值} 不能与weight， total同时出现

%% CUSTOM_ACT_TYPE_TASK_REWARD
%% 活动条件说明
%% {role_lv, Lv}    玩家等级限制
%% {wlv, Wlv}       世界等级限制
%% {key, [treasure_hunt......]} 获得奖励事件
%% 奖励条件说明 
%% {key, treasure_hunt} 当前奖励获得的前置事件
%% {jump_id, Id}跳转id 客户端用
%% {treasure_hunt, Arg, Num}:活动条件key里面的字段对应的某个事件，Arg特殊参数如：寻宝类型 Num获得奖励条件

%% CUSTOM_ACT_TYPE_TREASURE_HUNT
%% 活动条件说明
%% {role_lv, Lv}    玩家等级限制,不满足无返回
%% {wlv, Wlv}       世界等级限制,不满足无返回
%% {luckyvalue, [{轮数,幸运值},...]} 幸运值,每轮从0开始
%% {add_value, 10} 每次抽奖增加的幸运值
%% {cost, [{Type, GTypeId, Num}...]} 抽一次消耗
%% 奖励条件说明 
%% {weight, NormalWeight, [{轮数, 权重加成}...]} 权重 = NormalWeight + 轮数权重加成(不填为0)
%% {rare, Weight} 必中大奖使用的权重，0或者不填表示非大奖
%% {tv, {ModuleId, Id}} 传闻主键 ModuleId:模块id, Id:语言表的id


%% CUSTOM_ACT_TYPE_LV_GIFT
%% 活动条件说明
%% {min_lv, 60}       60级开始计时
%% {max_lv, 100}      100级结束计时
%% {limit_time,  15}  15分钟的计时时间

%% CUSTOM_ACT_TYPE_DAILY_DIRECT_BUY
%% 活动条件说明
%% {role_lv, lv}      玩家等级限制
%% {one_package, 打包购买商品的Id, [打包时所包括的商品礼包ID]}
%% {tv, {ModuleId, Id}}         打包购买时用到的传闻主键 ModuleId:模块id, Id:语言表的id
%% 奖励条件说明
%% {recharge_id, Id}       购买商品Id
%% {tv, {ModuleId, Id}}     传闻主键 ModuleId:模块id, Id:语言表的id
%% {original_price, selling_price, discount}  {原价，售价，折扣}

%% ==================================== 定制活动奖励格式 ==================================
-define(REWARD_FORMAT_TYPE_COMMON,          1).                 %% 通用奖励格式[{类型,道具id,数量}]
-define(REWARD_FORMAT_TYPE_LV,              2).                 %% 等级阶段奖励格式[{等级,[{类型,道具id,数量}]
-define(REWARD_FORMAT_TYPE_RAND,            3).                 %% 随机奖励格式[{权值,[{类型,道具id,数量}]}]
-define(REWARD_FORMAT_TYPE_WLV,             4).                 %% 世界等级阶段奖励格式[{世界等级,[{类型,道具id,数量}]}]
-define(REWARD_FORMAT_TYPE_SEX,             5).                 %% 性别奖励格式[{性别,[{类型,道具id,数量}]}]
-define(REWARD_FORMAT_TYPE_SPECIFY_LV,      6).                 %% 指定玩家等级段奖励格式[{[玩家等级下限,玩家等级上限],[{类型,道具id,数量}]}] 不在这些等级区间的没有奖励
-define(REWARD_FORMAT_TYPE_SPECIFY_LVASEX,  7).                 %% 指定玩家等级段和性别奖励格式[{[玩家等级下限,玩家等级上限],{性别, [{类型,道具id,数量}]}}] 不在这些等级区间的没有奖励
-define(REWARD_FORMAT_TYPE_SPECIFY_WLVASEX, 8).                 %% 指定世界等级段和性别奖励格式[{[世界等级下限,世界等级上限],{性别, [{类型,道具id,数量}]}}] 不在这些等级区间的没有奖励
-define(REWARD_FORMAT_TYPE_CAREER,          9).                 %% 职业奖励格式[{职业,[{类型,道具id,数量}]}]
-define(REWARD_FORMAT_TYPE_OPEN_DAY,       10).                 %% 职业奖励格式[{[开服天数下限,开服天数限],[{类型,道具id,数量}]}] 不在这些开服天数的没有奖励
-define(REWARD_FORMAT_TYPE_BY_RARE,        11).                 %% 奖励区分珍稀[{珍稀类型, [{类型,道具id,数量}]}] 1 - 普通奖励 2- 珍稀奖励
%% ==================================== 定制活动奖励格式 ==================================

-define(CUSTOM_ACT_NORMAL,              1).                 %% 定制活动(官方服)
-define(CUSTOM_ACT_EXTRA,               2).                 %% 额外定制活动(渠道服)

-define(CUSTOM_ACT_SWITCH_CLOSE,        0).                 %% 关闭
-define(CUSTOM_ACT_SWITCH_OPEN,         1).                 %% 开启

%% 开启类型
-define(OPEN_TYPE_SPECIFY_TIME,         1).                 %% 指定时间开启
-define(OPEN_TYPE_WEEK,                 2).                 %% 每周几循环开启
-define(OPEN_TYPE_MONTH,                3).                 %% 每月几号循环开启
-define(OPEN_TYPE_SPECIFY_DATE,         4).                 %% 固定日期开启
-define(OPEN_TYPE_CONTINUOUS_WEEK,      5).                 %% 每周几循环开启,周数需要连续
-define(OPEN_TYPE_OPEN_DAY,             6).                 %% 开服天数循环
-define(OPEN_TYPE_DAYS_APART,           7).                 %% 根据配置时间段，从开启时间开始，隔几天开一次

-define(OPEN_TYPE_LIST, [
    ?OPEN_TYPE_SPECIFY_TIME,
    ?OPEN_TYPE_WEEK,
    ?OPEN_TYPE_MONTH,
    ?OPEN_TYPE_SPECIFY_DATE,
    ?OPEN_TYPE_CONTINUOUS_WEEK,
    ?OPEN_TYPE_OPEN_DAY,
    ?OPEN_TYPE_DAYS_APART
    ]).

%% 定制活动状态
%% >= 开始时间 < 结束时间为活动开启中
-define(CUSTOM_ACT_STATUS_CLOSE,            0).                 %% 定制活动关闭
-define(CUSTOM_ACT_STATUS_OPEN,             1).                 %% 定制活动开启
-define(CUSTOM_ACT_STATUS_MANUAL_CLOSE,     2).                 %% 定制活动手动关闭 比如某些活动出问题了后台手动关闭

-define(EXTRA_CUSTOM_ACT_SUB_ADD,       10000).             %% 额外定制活动子类型偏移值

-define(ACT_DURATION_ONE_DAY,           86399).             %% 活动一天的时间

%% 活动期间清理类型
-define(CUSTOM_ACT_CLEAR_NULL,              1).             %% 不清理
-define(CUSTOM_ACT_CLEAR_ZERO,              2).             %% 0点清理
-define(CUSTOM_ACT_CLEAR_FOUR,              3).             %% 4点清理

-define(TIMER_START,    1).             %% 定时器开启
-define(RELOAD_START,   2).             %% 重新加载开启

%% 奖励状态
-define(ACT_REWARD_CAN_NOT_GET,         0).         %% 未满足条件不能领取
-define(ACT_REWARD_CAN_GET,             1).         %% 可以领取
-define(ACT_REWARD_HAS_GET,             2).         %% 已经领取
-define(ACT_REWARD_TIME_OUT,            3).         %% 奖励超时

-define(limit_gift_reward_not_get,      1).         %% 礼包没有领取
-define(limit_gift_reward_yet_get,      2).         %% 礼包已经领取

-record(custom_act_cfg, {
    type = 0,                           %% 活动主类型
    subtype = 0,                        %% 活动子类型
    act_type = 0,                       %% 活动类型 1:开服活动 2:合服活动 3:运营活动 4:单独图标 5:封测活动
    show_id = 0,                        %% 展示id
    name = <<>>,                        %% 活动名字
    desc = <<>>,                        %% 活动描述
    open_start_time = 0,                %% 服开始时间戳##闭区间
    open_end_time = 0,                  %% 服结束时间戳##闭区间
    opday_lim = [],                     %% 开服天数限制
    merday_lim = [],                    %% 合服天数限制
    wlv_lim = [],                       %% 世界等级限制
    optype = 0,                         %% 开启类型 1: 具体时间控制 2: 每周几固定开启 3: 每月固定天数开启 4: 固定时间开启
    opday = [],                         %% 根据开启类型填 周几开启[周几] 每月固定天数开启[每月几号] 固定时间开启[{年,月,日}]
    optime = [],                        %% 开启时间段 活动当天什么时间段开启[{{开始时,开始分,开始秒}, {结束时,结束分,结束秒}}]
    start_time = 0,                     %% 活动开始时间 开启类型为0有效
    end_time = 0,                       %% 活动结束时间 开启类型为0有效
    clear_type = 0,                     %% 活动期间数据清理类型 1=不清理；2=0点清理；3=4点清理
    condition = []                      %% 条件
    }).

-record(custom_act_reward_cfg, {
    type = 0,                           %% 活动主类型
    subtype = 0,                        %% 活动子类型 注意：在代码里面不要拿这个subtype来用 官方定制活动和额外定制活动可能会配一样的 统一用act_info里面的！！！
    grade = 0,                          %% 奖励档次
    name = <<>>,                        %% 奖励名字
    desc = <<>>,                        %% 奖励描述
    condition = [],                     %% 奖励领取条件
    format = 0,                         %% 奖励格式 见定制活动奖励格式
    reward = []
    }).

-record(ac_custom_cfg, {
        id = 0,
        value = []
    }).

%% 定制活动数据
-record(custom_act_state, {
    unopen_kf_act = []                  %% [#act_info{}]保存跨服中心同步过来的跨服定制活动(因开服合服天数不满足或者世界等级不满足暂未开启的活动)
    , rl_check_ref = none               %% 重新加载检查定时器
    , rl_check_times = 0                %% 重新加载次数
    }).

%% 开启中的活动信息
-record(act_info, {
    key = {0, 0},                       %% {type, subtype}
    wlv = 0,                            %% 活动开启时候的世界等级
    stime = 0,
    etime = 0
}).

%% 玩家身上的定制活动数据
-record(status_custom_act, {
        reward_map = #{}                %% #{{type, subtype, grade} => #reward_status{}}
        , data_map = #{}                %% 活动需要统计保存的数据{{活动主类型,活动子类型} => #custom_act_data{}}
        , other_data_map = #{}          %% 定制活动其余数据#{{活动主类型,活动子类型} => Term} 该数据需要自己初始化
    }).

-record(reward_status, {
    receive_times = 0,                  %% 奖励领取次数
    utime = 0,                          %% 数据更新时间
    login_times = 0                     %% 活动开启时间登陆次数
    }).

%% 用来取奖励的辅助参数 有些奖励玩家没有领取，要补发给他们，因此存了得到奖励当时的情况
-record (reward_param, {
    player_lv = 0,
    wlv = 0,
    sex = 0,
    career = 0
    }).

 %% 用来取奖励权重的辅助参数
-record (reward_rank_param, {
    player_lv = 0,
    wlv = 0,
    sex = 0,
    career = 0
    }).

 -record(limit_gift, {
        sub_type = 0,       %% 活动子类型
        reward_status = []  %% [{档次, 状态}]  0
    }).

%% 定制活动 活动统计数据
%%  data:
-record(custom_act_data, {
        id = {0, 0},                    %% {活动主类型,活动子类型}
        type = 0,                       %% 活动主类型
        subtype = 0,                    %% 活动子类型
        data = []                       %% 活动统计数据 各个活动自己控制，一般为[{key, value}]
    }).

%% 转盘记录[玩家]
%% CUSTOM_ACT_TYPE_LUCKY_TURNTABLE 28:幸运转盘
-record(custom_act_turntable, {
        times = 0           % 抽奖次数
        , gold = 0          % 充值的钱
        , utime = 0         % 更新时间##判断是否需要清理
    }).

%% 招财猫[玩家]
%% CUSTOM_ACT_TYPE_FORTUNE_CAT 87:招财猫
-record(custom_act_cat, {
    turn = 1           % 抽奖轮次
    , utime = 0         % 更新时间##判断是否需要清理
}).

%% 通用抽奖
-record(custom_common_draw, {
    total_times = 0,    %% 抽奖总次数
    luck_value = 0,     %% 幸运值
    nice_list = [],     %% 已抽到的大奖列表 （不放回奖励有效字段
    grand_status = []   %% 累计奖励领取状态 （累计奖励 有效字段
}).

-record(train_init_state, {
        key = {0,0}           %
        , type = 0          %
        , subtype = 0
        , infos = []
        , utime = 0         %
    }).

%% 每日直购[玩家]
%% CUSTOM_ACT_TYPE_DAILY_DIRECT_BUY 115:每日直购
-record(custom_act_daily_direct_buy, {
    bought = []         % 购买情况列表
    , utime = 0         % 更新时间##判断是否需要清理
}).

%% 全民狂欢
-record(custom_the_carnival, {
    is_init = 0,
    task_process = [],  % [{gradeId, Process}]
    receive_ids = []    % 已领取的奖励ID列表
}).

%% 全服充值有礼
-define(REGULAR_REWARD_TYPE,  1).   %% 常规类型
-define(RARE_REWARD_TYPE,     2).   %% 珍稀类型

-record(custom_recharge_polite, {
    money = 0,         %% 活动期间玩家累充的金额
    free_ids = [],     %% 已成功领取的免费ID
    pay_ids = [],      %% 付费礼包的领取情况
    end_time = 0       %% 活动结束时间
}).

%% 循环冲榜累充活动
-record(cycle_rank_recharge, {
    money = 0,        %% 累充金额
    reward_ids = [],   %% 成功领取的奖励
    end_time = 0      %% 该轮次的结束时间
}).

%% 循环冲榜 单笔充值活动
-record(cycle_rank_single_recharge, {
    times_map = #{},    %% #{ product_id => {buy_times, reward_times}}
    end_time = 0        %% 活动结束时间
}).

%% 勾玉祈愿抽奖
-record(wish_draw_act, {
    turn = 1,               %% 当前轮次
    times = 0,              %% 当前轮次抽奖次数
    free_times = 0,         %% 免费抽奖次数
    recharge_time = 0,      %% 充值时间
    free_gift_time = 0,      %% 每日免费礼包领取时间
    utime = 0               %% 更新时间##判断是否需要清理
}).

%% 外形购买数据
-record(custom_act_figure_buy, {
    bought = []         % 直购购买情况列表 [充值id]
    , other_bought = [] % 绑玉勾玉礼包购买列表{挡位Id， 购买次数}
    , utime = 0         % 更新时间##判断是否需要清理
}).

%% 系统邮件活动(130)
-record(custom_act_sys_mail, {
    last_mail_time = 0 % 上次邮件发送时间
}).

-define(select_opening_custom_act,
    <<"select type, subtype, wlv, stime, etime from custom_act_opening">>).
-define(insert_opening_custom_act,
    <<"replace into custom_act_opening(type, subtype, wlv, stime, etime) values(~p, ~p, ~p, ~p, ~p)">>).
-define(update_opening_custom_act,
    <<"update custom_act_opening set stime = ~p, etime = ~p where type = ~p and subtype = ~p">>).
-define(delete_opening_custom_act,
    <<"delete from custom_act_opening where type = ~p and subtype = ~p">>).
-define(clear_opening_custom_act,
    <<"truncate table custom_act_opening">>).

%% 备注 custom_act_receive_reward表不做清理，通过比较utime判断数据的有效性
-define(select_custom_act_reward_receive,
    <<"select type, subtype, grade, receive_times, utime from custom_act_receive_reward where role_id = ~p">>).
-define(select_custom_act_reward_receive_times,
    <<"select receive_times from custom_act_receive_reward where role_id = ~p and type = ~p and subtype = ~p and grade = ~p">>).
-define(select_custom_act_reward_receive_by_type,
    <<"select role_id, grade, receive_times, utime from custom_act_receive_reward where type = ~p and subtype = ~p">>).
-define(insert_custom_act_reward_receive,
    <<"insert into custom_act_receive_reward(role_id, type, subtype, grade, receive_times, utime) values(~p, ~p, ~p, ~p, ~p, ~p)">>).
-define(update_custom_act_reward_receive,
    <<"update custom_act_receive_reward set receive_times = ~p, utime = ~p where role_id = ~p and type = ~p and subtype = ~p and grade = ~p">>).
-define(DELETE_CUSTOM_ACT_REWARD_RECEIVE,
    <<"delete from custom_act_receive_reward where type = ~p and subtype = ~p">>).
% -define(delete_custom_act_reward_receive_by_one,
%     <<"delete from custom_act_receive_reward where role_id = ~p and type = ~p and subtype = ~p and grade = ~p">>).
% -define(delete_custom_act_reward_receive_by_type,
%     <<"delete from custom_act_receive_reward where type = ~p">>).
% -define(delete_custom_act_reward_receive_by_stype,
%     <<"delete from custom_act_receive_reward where type = ~p and subtype = ~p">>).
% -define(delete_custom_act_reward_receive_by_uid,
%     <<"delete from custom_act_receive_reward where role_id = ~p and type = ~p and subtype = ~p">>).

%% 查询定制活动保存的统计数据
-define(SQL_SELECT_CUSTOM_ACT_DATA, <<"select `type`, `subtype`, `data_list` from
    `custom_act_data` where `player_id`=~p">>).
-define(SQL_SAVE_CUSTOM_ACT_DATA, <<"replace into `custom_act_data`(
    `player_id`, `type`, `subtype`, `data_list`) values(~p, ~p, ~p, '~ts')">>).

%% 清除定制活动保存的统计数据
%% 根据定制活动主次类型删除定制活动保存的统计数据
-define(SQL_DELETE_CUSTOM_ACT_DATA_1, <<"delete from `custom_act_data` where `type`=~p and `subtype`=~p">>).
%% 根据定制活动主次类型和特定玩家删除定制活动保存的统计数据
-define(SQL_DELETE_CUSTOM_ACT_DATA_2, <<"delete from `custom_act_data` where `player_id`=~p and `type`=~p and `subtype`=~p">>).

-define(select_custom_act_sign_days,
    <<"select count, utime from custom_act_sign_days where role_id = ~p and type = ~p and sub_type = ~p">>).
-define(select_custom_act_sign_days_buy_type,
    <<"select role_id, count from custom_act_sign_days where type = ~p and sub_type = ~p">>).
-define(insert_custom_act_sign_days,
    <<"replace into custom_act_sign_days(role_id, type, sub_type, count, utime) values (~p, ~p, ~p, ~p, ~p)">>).
-define(delete_custom_act_sign_days,
    <<"delete from custom_act_sign_days where type = ~p and sub_type = ~p">>).

%% -----------------------活动掉落物品数量记录-------------------------
-define(select_custom_drop_log,
    <<"select act_type, subtype, goods_type, goodsid, num from custom_drop_log where role_id = ~p">>).
-define(insert_custom_drop_log,
    <<"replace into custom_drop_log (role_id, act_type, subtype, goods_type, goodsid, num) values (~p,~p,~p,~p,~p,~p)">>).
-define(delete_custom_drop_log,
    <<"delete from custom_drop_log where act_type =~p and subtype = ~p">>).

%% --------------------------跨服定制活动相关--------------------------
-define(select_opening_kf_custom_act,
    <<"select type, subtype, wlv, stime, etime from kf_custom_act_opening">>).
-define(insert_opening_kf_custom_act,
    <<"insert into kf_custom_act_opening(type, subtype, wlv, stime, etime) values(~p, ~p, ~p, ~p, ~p)">>).
-define(update_opening_kf_custom_act,
    <<"update kf_custom_act_opening set stime = ~p, etime = ~p where type = ~p and subtype = ~p">>).
-define(delete_opening_kf_custom_act,
    <<"delete from kf_custom_act_opening where type = ~p and subtype = ~p">>).
-define(clear_opening_kf_custom_act,
    <<"truncate table kf_custom_act_opening">>).

%% --------------------------额外定制活动相关--------------------------
-define(select_extra_custom_act, <<
    "select
        `type`, `subtype`, `act_type`, `show_id`, `name`, `desc`, UNIX_TIMESTAMP(open_start_time), UNIX_TIMESTAMP(open_end_time), `opday_lim`, `merday_lim`,
        `optype`, `opday`, `optime`, UNIX_TIMESTAMP(start_time), UNIX_TIMESTAMP(end_time), `clear_type`, `condition`
        from `extra_custom_act` "
    >>).

%% --------------------------定制活动奖励计算相关--------------------------
-define(select_player_act_args,
    <<"select `player_lv`, `wlv`, `career`, `sex` from player_act_args where `role_id` = ~p and `type` = ~p and `subtype` = ~p">>).
-define(insert_player_act_args,
    <<"insert into player_act_args(`role_id`, `type`, `subtype`, `player_lv`, `wlv`, `career`, `sex`) values(~p, ~p, ~p, ~p, ~p, ~p, ~p)">>).
-define(delete_player_act_args,
    <<"delete from player_act_args where type = ~p and subtype = ~p">>).
