%% ---------------------------------------------------------------------------
%% @doc language.hrl
%% @author ming_up@foxmail.com
%% @since  2016-08-08
%% @deprecated  语言包
%% ---------------------------------------------------------------------------

-define(LAN_MSG(LanId), data_language:get(LanId)).

%% ---------------------------------------------------------------------------
%%% 语言id定义
%% ---------------------------------------------------------------------------

%% 注：此处语言id，待重新划分，按{模块id,模块内语言id}作为一个复合id
%% 以下省略...

-define(LAN_EXPER_SUCCESS,              1).     %% 获得历练时间
-define(LAN_TITLE_SELL_DOWN_AUTO,       2).     %% 交易商品自动下架：标题
-define(LAN_CONTENT_SELL_DOWN_AUTO,     3).     %% 交易商品自动下架: 内容
-define(LAN_TITLE_SELL_SUCCESS,         4).     %% 交易商品成功出售：标题
-define(LAN_CONTENT_SELL_SUCCESS,       5).     %% 交易商品成功出售：内容
% -define(LAN_CHANGE_SCENE_SIGN,        12).    %% 排队换线中
% -define(LAN_SCENE_NOT_EXIST,          13).    %% 目标场景数据不存在
% -define(LAN_NOT_REACH_SCENE_LV,       14).    %% 等级不足，不能切换到目标场景

-define(LAN_FLAGWAR_REWARD_TITLE,       17).    %% 标题: 夺旗战场奖励
-define(LAN_FLAGWAR_REWARD_GET_REWARD,  18).    %% 内容: 您在夺旗战场中表现出色，胜场到达{1}场，获得以下奖励。
-define(LAN_FLAGWAR_REWARD_FAILED,      19).    %% 内容: 您在夺旗战场中胜场为0，我们不哭努力提升战力，期待您下次的精彩表现。
-define(LAN_FLAGWAR_FAIL_TO_START_TITLE,20).    %% 标题: 夺旗战场开启失败
-define(LAN_FLAGWAR_FAIL_TO_START,      21).    %% 内容: 抱歉，由于夺旗战场报名人数不足{1}人，活动开启失败。

-define(LAN_TITLE_RECHAEGE,  			35). 	%% 标题: 充值成功
-define(LAN_CONTENT_RECHAEGE, 			36).    %% 内容: 充值成功
-define(LAN_TITLE_DROP, 				37). 	%% 标题：怪物掉落
-define(LAN_CONTENT_DROP, 				38). 	%% 内容：怪物掉落

-define(LAN_TITLE_RECHAEGE_RETURN,  	52). 	%% 标题: 充值返利
-define(LAN_CONTENT_RECHAEGE_RETURN, 	53).    %% 内容: 充值返利
% -define(LAN_TITLE_RECHAEGE_FIRST,  	    54). 	%% 标题: 添加有礼
% -define(LAN_CONTENT_RECHAEGE_FIRST, 	55).

-define(LAN_CANNOT_TRANSFER,         	95).    %% 当前场景不能进入

-define(LAN_TITLE_TSMAP_FINE,           97).    %% 标题: 精致宝图奖励
-define(LAN_CONTENT_TSMAP_FINE,         98).    %% 内容: 您在离线期间，精致宝图的怪物被击败，获得以下奖励。

-define(LAN_TITLE_TSMAP_REWARD,         99).    %% 标题: 藏宝图奖励
-define(LAN_CONTENT_TSMAP_REWARD,       100).   %% 内容: 奖励如下

-define(LAN_TITLE_GUILD_WAR,            110).   %% 标题：公会试炼奖励
-define(LAN_CONTENT_GUILD_WAR,          111).   %% 内容: 恭喜你，在本次公会试炼中中表现出色。我们自动帮你兑换了试炼奖励，兑换后您的剩余水晶币为：{1}

-define(LAN_TITLE_AC_CUSTOM_COMBAT_RANK,          112).   %% 标题: 战力排行奖励
-define(LAN_CONTENT_AC_CUSTOM_COMBAT_RANK,        113).   %% 内容: 恭喜您在开服战力排行活动中获得第{1}名，现发放奖励。

-define(LAN_TITLE_AC_CUSTOM_GUILD_RANK,          114).   %% 标题: 公会排行奖励
-define(LAN_CONTENT_AC_CUSTOM_GUILD_RANK,        115).   %% 内容: 恭喜您所在的公会在开服公会排行活动中获得第{1}名，现发放奖励。

-define(LAN_TITLE_AC_CUSTOM_RANDOM,              116).   %% 标题: 额外奖励
-define(LAN_CONTENT_AC_CUSTOM_RANDOM,            117).   %% 内容: 您在完成【{1}】时，运气爆棚，额外获得【{2}】！

-define(LAN_TITLE_AC_CUSTOM_LV_SPRINT,           120).   %% 标题: 等级排行奖励
-define(LAN_CONTENT_AC_CUSTOM_LV_SPRINT,         121).   %% 内容: 恭喜您在开服等级排行活动中 第{1}名 达到{2}级，现发放奖励。

-define(LAN_TITLE_JJC_EXP,                       122).   %% 标题: 竞技场经验
-define(LAN_CONTENT_JJC_EXP,                     123).   %% 内容: 你在竞技场战斗结束后，有经验未领取。

-define(LAN_TITLE_GUILD_RED_PACKET_LUCK,         128).   %% 标题: 幸运红包
-define(LAN_CONTENT_GUILD_RED_PACKET_LUCK,       129).   %% 标题: 你的幸运红包没有成功开启，现返还你{1}卢币。

-define(LAN_CONTENT_GUILD_RED_PACKET_LUCKY,      130).   %% 标题: 你参与的幸运红包还没人开启成功，现已变成了手气红包。请查收你的奖励

-define(LAN_TITLE_RENAME,                        131).   %% 标题: 好友改名
-define(LAN_CONTENT_FRIEND_RENAME,               132).   %% 内容: 亲爱的玩家，您的好友{1}现已更名为{2}，请继续保持联系哦！
-define(LAN_CONTENT_ENEMY_RENAME,                133).   %% 内容: 亲爱的玩家，您的仇人{1}现已更名为{2}，请继续保持追寻其下落！

-define(LAN_TITLE_RECHAEGE_REWARD,                147). %% 标题: 充值活动
-define(LAN_CONTENT_RECHAEGE_REWARD,              148). %% 内容: 你的背包不足。

-define(LAN_TITLE_JJC_WIN,                        149). %% 标题:　竞技场排名下降
-define(LAN_CONTENT_JJC_WIN,                      150). %% 标题:　您在竞技场中被击败，排名下降

-define(LAN_TITLE_FLOWER_RANK_BOY,                161). %% 标题:　男鲜花周榜第{1}名
-define(LAN_CONTENT_FLOWER_RANK_BOY,              162). %% 内容:  恭喜您获得男鲜花周榜第{1}名，特发放排行奖励！
-define(LAN_TITLE_FLOWER_RANK_GUILD,              163). %% 标题:　鲜花周榜公会奖励
-define(LAN_CONTENT_FLOWER_RANK_GUILD,            164). %% 内容:  恭喜贵公会的{1}获得鲜花周榜前三，特发放最高排名的公会奖励！
-define(LAN_TITLE_FLOWER_RANK_GIRL,               167). %% 标题:　女鲜花周榜第{1}名
-define(LAN_CONTENT_FLOWER_RANK_GIRL,             168). %% 内容:  恭喜您获得女鲜花周榜第{1}名，特发放排行奖励！

-define(LAN_TITLE_AC_CUSTOM_FIRST_RECHARGE,       169). %% 标题:　首充团购
-define(LAN_CONTENT_AC_CUSTOM_FIRST_RECHARGE,     170). %% 内容:  你在首充团购活动中，获得了如下奖励，请记得查收哦。

-define(LAN_TITLE_AC_CUSTOM_SUM_RECHARGE,       171). %% 标题:　累充大奖
-define(LAN_CONTENT_AC_CUSTOM_SUM_RECHARGE,     172). %% 内容:  你在累充大奖活动中，充值金额达到XXX，得到了活动奖励。现通过邮件发给您，不要忘记领取哦！
-define(LAN_TITLE_EQUIP_SUIT_TAKEOFF,          205). %% 标题: 套装解除
-define(LAN_CONTENT_EQUIP_SUIT_TAKEOFF,        206). %% 内容: 套装解除
-define(LAN_TITLE_DUNGEON_DROP,                207). %% 标题: 副本掉落自动拾取
-define(LAN_CONTENT_DUNGEON_DROP,              208). %% 内容: 副本掉落自动拾取

-define(LAN_TITLE_PROPOSE_REFUSE,              215). %% 标题: 求婚被拒
-define(LAN_CONTENT_PROPOSE_REFUSE,            216). %% 内容: 求婚被拒
-define(LAN_TITLE_PROPOSE_TIME_OUT,            217). %% 标题: 求婚超时
-define(LAN_CONTENT_PROPOSE_TIME_OUT,          218). %% 内容: 求婚超时
-define(LAN_TITLE_PROPOSE_FAIL_OTHER,          220). %% 标题: 求婚其它
-define(LAN_CONTENT_PROPOSE_FAIL_OTHER,        221). %% 内容: 求婚其它
-define(LAN_TITLE_WEDDING_SUCCESS,             222). %% 标题: 婚礼奖励
-define(LAN_CONTENT_WEDDING_SUCCESS,           223). %% 内容: 婚礼奖励
-define(LAN_TITLE_DIVORCE_FAIL,                224). %% 标题: 离婚失败
-define(LAN_CONTENT_DIVORCE_FAIL,              225). %% 内容: 离婚失败
-define(LAN_TITLE_SHOW_LOVE,                   226). %% 标题: 秀恩爱
-define(LAN_CONTENT_SHOW_LOVE,                 227). %% 内容: 秀恩爱
-define(LAN_TITLE_WEDDING_ORDER_RETURN,        228). %% 标题: 婚礼预订返回
-define(LAN_CONTENT_WEDDING_ORDER_RETURN,      229). %% 内容: 婚礼预订返回
-define(LAN_TITLE_BUY_GUEST_NUM_RETURN,        230). %% 标题: 婚礼购买宾客上限返还
-define(LAN_CONTENT_BUY_GUEST_NUM_RETURN,      231). %% 内容: 婚礼购买宾客上限返还
-define(LAN_TITLE_WEDDING_AURA,                232). %% 标题: 婚礼气氛值奖励
-define(LAN_CONTENT_WEDDING_AURA,              233). %% 内容: 婚礼气氛值奖励

-define(LAN_TITLE_TOPPK_SEASONREWARDS,         234). %% 标题: 巅峰竞技赛季结算
-define(LAN_CONTENT_TOPPK_SEASONREWARDS,       235). %% 内容: 巅峰竞技赛季结算

-define(LAN_TITLE_DUN_RUNE_DAILY_REWARD,       242). %% 标题: 符文副本每日奖励
-define(LAN_CONTENT_DUN_RUNE_DAILY_REWARD,     243). %% 内容: 符文副本每日奖励

-define(LAN_TITLE_TOPPK_REWARD,                244). %% 标题: 巅峰竞技挑战奖励
-define(LAN_CONTENT_TOPPK_REWARD,              247). %% 内容: 巅峰竞技挑战奖励

-define(LAN_TITLE_WEDDING_FAIL,                261). %% 标题: 重启婚期未完成返还
-define(LAN_CONTENT_WEDDING_FAIL,              262). %% 内容: 重启婚期未完成返还

-define(LAN_TITLE_TEAM_ARBITRATE_RETURN,       273). %% 标题: 投票中断返还
-define(LAN_CONTENT_TEAM_ARBITRATE_RETURN,     274). %% 内容: 投票中断返还

-define(LAN_TITLE_HUSONG_TIME_OUT_OFFLINE,     275). %% 标题: 护送离线超时
-define(LAN_CONTENT_HUSONG_TIME_OUT_OFFLINE,   276). %% 内容: 护送离线超时

-define(LAN_TITLE_HUSONG_TAKE,                 277). %% 标题: 护送拦截成功
-define(LAN_CONTENT_HUSONG_TAKE,               278). %% 内容: 护送拦截成功

-define(LAN_TIME_MM_DD,                        283). %% {1}月{2}日

-define(LAN_TITLE_DUN_EVIL_REWARD,             284). %% 标题 诛邪战场每日奖励
-define(LAN_CONTENT_DUN_EVIL_REWARD,           285). %% 内容 诛邪战场每日奖励

-define(LAN_TITLE_MARRIAGE_DIVORCE_DESIGNATION,             308). %% 标题 离婚收回称号
-define(LAN_CONTENT_MARRIAGE_DIVORCE_DESIGNATION,           309). %% 内容 离婚收回称号

-define(LAN_TITLE_ACTIVE_DESIGNATION_OFFLINE,               310). %% 标题 离线激活称号重复
-define(LAN_CONTENT_ACTIVE_DESIGNATION_OFFLINE,             311). %% 内容 离线激活称号重复

-define(LAN_TITLE_CLOUD_BUY_LUCKY,                                3310003). %% 标题 幸运之星中奖通知
-define(LAN_CONTENT_CLOUD_BUY_LUCKY,                              3310004). %% 内容 幸运之星中奖通知

-define(LAN_TITLE_CLOUD_BUY_NOMAL,                                3310002). %% 标题 幸运之星未中奖通知
-define(LAN_CONTENT_CLOUD_BUY_NOMAL,                              3310005). %% 内容 幸运之星未中奖通知
-define(LAN_CONTENT_CLOUD_BUY_SPECIAL,                            3310032). %% 内容 幸运之星无人中奖通知

-define(LAN_TITLE_CLOUD_BUY_START_SALE,                           3310044). %% 标题 限时云购开售
-define(LAN_CONTENT_CLOUD_BUY_START_SALE,                         3310045). %% 内容 限时云购开售

-define(LAN_TITLE_PERFECT_LOVER,                                3310012). %% 标题 完美恋人奖励通知
-define(LAN_CONTENT_PERFECT_LOVER,                              3310013). %% 内容 完美恋人奖励通知

-define(SIGN_REWARD_MAIL_TITLE,                                   3310036). %登陆有礼邮件标题
-define(SIGN_REWARD_MAIL_CONTENT,                                 3310037). %登陆有礼邮件内容

-define(LAN_MYSTERY_MAN,                        179). %% 神秘人
-define(SYSTEM,                                 180). %% 系统

-define(LAN_TITLE_WEDDING_BREAK_OFF,                            1720003). %% 标题 婚礼中断
-define(LAN_CONTENT_WEDDING_BREAK_OFF,                          1720004). %% 标题 婚礼中断

-define(LAN_TITLE_WEDDING_AA_FAIL,                              1720005). %% 标题 平分费用结婚失败返还（返还答应的那个人，防报错用）
-define(LAN_CONTENT_WEDDING_AA_FAIL,                            1720006). %% 标题 平分费用结婚失败返还（返还答应的那个人，防报错用）

-define(LAN_TITLE_COLLECT_ALL_REWARD,                           3310018). %% 标题 收集活动全服物品奖励
-define(LAN_CONTENT_COLLECT_ALL_REWARD,                         3310019). %% 标题 收集活动全服物品奖励

-define(LAN_TITLE_MON_INVADE_STAGE_REWARD,                      6100002). %% 标题 异兽入侵
-define(LAN_CONTENT_MON_INVADE_STAGE_REWARD,                    6100003). %% 内容 异兽入侵

-define(LAN_TITLE_HOUSE_FAIL_RETURN,                            1770001). %% 标题 购买房子失败返还
-define(LAN_CONTENT_HOUSE_FAIL_RETURN,                          1770002). %% 标题 购买房子失败返还
-define(LAN_TITLE_HOUSE_AA_FAIL_RETURN,                         1770003). %% 标题 答应AA购买房子失败返还
-define(LAN_CONTENT_HOUSE_AA_FAIL_RETURN,                       1770004). %% 标题 答应AA购买房子失败返还
-define(LAN_TITLE_HOUSE_AA_REFUSE_RETURN,                       1770005). %% 标题 AA购买房子被拒返还
-define(LAN_CONTENT_HOUSE_AA_REFUSE_RETURN,                     1770006). %% 标题 AA购买房子被拒返还
-define(LAN_TITLE_HOUSE_AA_tIMEOUT_RETURN,                      1770007). %% 标题 AA购买房子超时返还
-define(LAN_CONTENT_HOUSE_AA_tIMEOUT_RETURN,                    1770008). %% 标题 AA购买房子超时返还
-define(LAN_TITLE_HOUSE_UPGRADE_FAIL_RETURN,                    1770009). %% 标题 房子升级失败
-define(LAN_CONTENT_HOUSE_UPGRADE_FAIL_RETURN,                  1770010). %% 标题 房子升级失败
-define(LAN_TITLE_HOUSE_AA_UPGRADE_FAIL_RETURN,                 1770011). %% 标题 答应AA升级房子失败返还
-define(LAN_CONTENT_HOUSE_AA_UPGRADE_FAIL_RETURN,               1770012). %% 标题 答应AA升级房子失败返还
-define(LAN_TITLE_HOUSE_AA_UPGRADE_REFUSE_RETURN,               1770013). %% 标题 AA升级房子被拒返还
-define(LAN_CONTENT_HOUSE_AA_UPGRADE_REFUSE_RETURN,             1770014). %% 标题 AA升级房子被拒返还
-define(LAN_TITLE_HOUSE_AA_UPGRADE_tIMEOUT_RETURN,              1770015). %% 标题 AA升级房子超时返还
-define(LAN_CONTENT_HOUSE_AA_UPGRADE_tIMEOUT_RETURN,            1770016). %% 标题 AA升级房子超时返还
-define(LAN_TITLE_HOUSE_MARRIAGE_SIDE_HAVE,                     1770017). %% 标题 结婚婚房通知单方有房
-define(LAN_CONTENT_HOUSE_MARRIAGE_SIDE_HAVE,                   1770018). %% 标题 结婚婚房通知单方有房
-define(LAN_TITLE_HOUSE_MARRIAGE_BOTH_HAVE,                     1770019). %% 标题 结婚婚房通知两方有房
-define(LAN_CONTENT_HOUSE_MARRIAGE_BOTH_HAVE,                   1770020). %% 标题 结婚婚房通知两方有房
-define(LAN_TITLE_HOUSE_DIVORCE_AFTER_BUY,                      1770021). %% 标题 离婚婚后买房
-define(LAN_CONTENT_HOUSE_DIVORCE_AFTER_BUY,                    1770022). %% 标题 离婚婚后买房
-define(LAN_TITLE_HOUSE_DIVORCE_SIDE_HAVE,                      1770023). %% 标题 离婚婚前一方有房
-define(LAN_CONTENT_HOUS_DIVORCEE_SIDE_HAVE,                    1770024). %% 标题 离婚婚前一方有房
-define(LAN_TITLE_HOUSE_DIVORCE_BOTH_HAVE,                      1770025). %% 标题 离婚婚前两方有房
-define(LAN_CONTENT_HOUSE_DIVORCE_BOTH_HAVE,                    1770026). %% 标题 离婚婚前两方有房
-define(LAN_TITLE_HOUSE_CHOOSE_TIMEOUT,                         1770027). %% 标题 选择房子超时算答应
-define(LAN_CONTENT_HOUSE_CHOOSE_TIMEOUT,                       1770028). %% 标题 选择房子超时算答应
-define(LAN_TITLE_HOUSE_GIFT_FAIL,                              1770029). %% 标题 送礼物失败返还
-define(LAN_CONTENT_HOUSE_GIFT_FAIL,                            1770030). %% 标题 送礼物失败返还
-define(LAN_TITLE_HOUSE_MERGE_RETURN,                           1770031). %% 标题 合服家园返还
-define(LAN_CONTENT_HOUSE_MERGE_RETURN,                         1770032). %% 标题 合服家园返还
-define(LAN_TITLE_HOUSE_MERGE_AA_RETURN,                        1770033). %% 标题 合服家园买房，提升规模AA返还
-define(LAN_CONTENT_HOUSE_MERGE_AA_RETURN,                      1770034). %% 标题 合服家园买房，提升规模AA返还
-define(LAN_TITLE_HOUSE_MERGE_LOCK_TURN,                        1770035). %% 标题 合服家园锁定转主房
-define(LAN_CONTENT_HOUSE_MERGE_LOCK_TURN,                      1770036). %% 标题 合服家园锁定转主房

%% 拍卖
-define(LAN_TITLE_AUCTION_SUCCESS,      1540001).     %% 获得拍卖：标题
-define(LAN_CONTENT_AUCTION_SUCCESS,    1540002).     %% 获得拍卖：内容
-define(LAN_TITLE_AUCTION_FAIL,         1540003).     %% 未获得拍卖：标题
-define(LAN_CONTENT_AUCTION_FAIL,       1540004).     %% 未获得拍卖：内容
-define(LAN_TITLE_AUCTION_AWARD,        1540005).    %% 拍卖分红：标题
-define(LAN_CONTENT_AUCTION_AWARD,      1540006).    %% 拍卖分红：内容

%% ---------------------------------------------------------------------------
%%% 语言额外类型定义
%% ---------------------------------------------------------------------------

%% 类型
%% 1:传闻
%% 2:普通消息

%% 子类型
%% 1:传闻
%%  频道
%% 2:普通消息
%%  频道

%% 附加提示
%% 0:无
%% 1:提示
%% 2:警告

%% 语言记录
-record(language, {
        module_id = 0
        , id = 0
        , type = 0
        , subtype = 0
        , tip = 0
        , content = ""
    }).