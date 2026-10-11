%% ---------------------------------------------------------------------------
%% @doc pp_gm
%% @author ming_up@foxmail.com
%% @since  2016-08-31
%% @deprecated  秘籍文件
%% ---------------------------------------------------------------------------
-module(pp_gm).
-include("common.hrl").
-include("server.hrl").
-include("figure.hrl").
-include("attr.hrl").
-include("predefine.hrl").
-include("scene.hrl").
-include("record.hrl").
-include("goods.hrl").
-include("partner.hrl").
-include("battle.hrl").
-include("guild.hrl").
-include("team.hrl").
-include("checkin.hrl").
-include("def_daily.hrl").
-include("def_module.hrl").
-include("def_recharge.hrl").
-include("rec_recharge.hrl").
-include("skill.hrl").
-include("daily.hrl").
-include("def_id_create.hrl").
-include("reincarnation.hrl").
-include("custom_act.hrl").
-include("def_goods.hrl").
-include("dungeon.hrl").
-include("marriage.hrl").
-include("relationship.hrl").
-include("def_event.hrl").
-include("errcode.hrl").
-include("eternal_valley.hrl").
-include("shake.hrl").
-include("rec_onhook.hrl").
-include("chat.hrl").
-include("buff.hrl").
-include("counter_global.hrl").
-include("task.hrl").
-include("top_pk.hrl").
-include("def_fun.hrl").
-include("seacraft.hrl").
-include("mount.hrl").
-include("boss.hrl").
-include("code_vsn.hrl").

-export([handle/3]).
-compile(export_all).

% %% [{秘籍代码指令，秘籍名称，秘籍参数},...].
% get_gm_ui_data(Status) ->
% [
% {"goods",   "增加物品", ["物品类型id", "数量"]}
% , {"opday",  uio:format("开服天数({1})天", [util:get_open_day()]), ["开服天数"]}
% , {"mergeday",  uio:format("合服天数({1})天", [util:get_merge_day()]), ["合服天数"]}
% , {"worldlv", uio:format("世界等级({1})级(固定值:{2})", [util:get_world_lv(), mod_global_counter:get_count(?MOD_0, ?GLOBAL_0_GM_WORLD_LV_OPEN)]), ["等级"]}
% , {"nochangeworldlv", uio:format("设置世界固定等级({1})级(固定值:{2})", [util:get_world_lv(), mod_global_counter:get_count(?MOD_0, ?GLOBAL_0_GM_WORLD_LV_OPEN)]), ["等级"]}
% , {"pt",    "调试协议", ["协议编号", "协议数据"]}
% , {"cdaily", "清除个人日常", []}
% , {"wdaily", "清周日常", []}
% , {"goodstype", "按类型添加物品", ["大类", "子类", "数量"]}
% , {"onekeyaddequip", "一键添加装备", ["颜色", "星级"]}
% , {"scurrency",   "增加特殊货币", ["物品类型id", "数量"]}
% , {"clean", "清理背包", []}
% , {"money", "设置金钱", ["100000"]}
% , {"coin", "铜币", ["100000"]}
% , {"vipexp", "加vip经验", ["增加经验"]}
% , {"gcoin", "公会货币", ["公会货币"]}
% , {"recharge", "充值商品", ["商品id:如1"]}

% , {"mon",   "创建怪物", ["10000", "1"]}
% , {"attr",  "改变属性",  [uio:format("[{{1},10000}, {{2}, 1000}]", [?ATT, ?HIT])]}
% , {"speed", "改变速度",  [uio:format("[{18, 1000}]", [?SPEED])]}
% , {"rechage_num", uio:format("玩家充值{1}元", [round(lib_recharge_data:get_total_rmb(Status#player_status.id))]), []}

% , {"addgrowth", "增加公会成长值", ["1000"]}
% , {"adddonate", "增加公会贡献", ["1000"]}
% , {"addgfunds", "增加公会资金", ["1000"]}
% , {"addprestige", "增加声望值", ["1000"]}
% , {"degradeprestige", "声望降级", ["秒数"]}
% , {"clearprestigerecord", "清理声望获取记录", []}
% , {"dummy", "创建假人", ["人数","分组(0不会打架)"]}
% , {"scene", "强制切换场景", ["1000"]}
% , {"exp",   "增加经验", ["1000"]}
% , {"gmexp", "增加经验(GM)", ["1000"]}
% , {"lv",    "升级",     ["10"]}
% % , {"setlv",    "设置等级",     ["10"]}

% , {"mail", "增加测试邮件", []}
% , {"rewardmail", "增加奖励邮件", ["[{0,101075021,1},{1,36010001,1024}]"]}
% , {"delmail", "清理所有邮件", []}

% , {"commerce", "触发商会任务", []}
% , {"jjcwin", "竞技场胜利", []}
% , {"jjctimer", "竞技场结算", []}

% , {"guide", "引导", ["等级"]}
% , {"closedungeon", "关闭副本", []}
% , {"dunresult", "副本结束", ["结束类型"]}
% , {"dunlevelresult", "副本关卡结束", ["结束类型"]}
% , {"dunevent", "副本事件", ["归属列表", "事件Id"]}
% , {"dunquit", "退出副本", []}
% , {"refreshmirror", "刷新玩家镜像", []}
% , {"addlive", "增加活跃度",["活动ID", "活动子ID"]}
% , {"addlive2", "增加活跃度2",["数量"]}
% , {"copyscene", "开启线路", ["场景id", "进程池id", "线"]}
% , {"skills", "学习技能", []}
% , {"dropclean", "gm清理个人和全服限制掉落次数", ["类型1个人2全服"]}
% , {"beskills", "学习被动技能", ["[]:所有;[{id,lv}]"]}
% , {"cleanskills", "清除被动技能", []}
% , {"setskillpoint", "设置天赋技能点",["100"]}
% , {"nocd", "设置技能cd", ["1没有cd;0恢复cd"]}
% , {"guildguard", "开启守卫公会",["持续多少秒"]}
%
% , {"artipoints", "神器强化积分", ["类型", "数量"]}
% , {"card", "礼包卡", ["卡号"]}
% , {"toppk#seasonend", "巅峰竞技赛季结算", []}
% , {"toppk#start", "开启巅峰竞技", ["300"]}
% , {"resourcebacktest", "资源找回刷新", []}
% , {"tcheststart", "开启青云寻宝", ["持续时间(s)"]}
% , {"weddingstart", "婚礼开始", []}
% , {"weddinganime", "进入动画阶段", []}
% , {"weddingfeast", "进入宴席阶段", []}
% , {"plusstarvalue", "增加星力", ["数值"]}
% , {"investrw", "领取投资奖励", ["投资类型","奖励id"]}
% , {"investgettime", "投资领取时间", ["投资类型","领取时间戳"]}
% , {"investloginday", "投资登录时间", ["投资类型","登录天数"]}
% , {"startvoidfam", "开启虚空秘境", ["持续时间(s)"]}
% , {"customactoplist", "打印已开启的定制活动", []}
% , {"reloadccustom", "重新加载定制活动", []}
% , {"configaccustom", "生成定制活动查看文件",[]}
% , {"customactwlv", "更改定制活动的世界等级", ["活动大类", "活动子类", "世界等级"]}
% , {"rushrankclear", "开服冲榜结算", []}
% , {"clearyhbg", "重置永恒碑谷", []}
% , {"localflowerrankclear", "本服魅力榜结算", ["活动子类型"]}
% , {"kfflowerrankclear", "跨服魅力榜结算", ["活动子类型"]}
% , {"kffloweradd", "魅力榜增加值", ["增加值"]}
% , {"wedrankclear", "婚礼榜清理", ["活动子类型"]}
% , {"commonranktitle", "排行榜称号结算", []}
% , {"beachnext", "海滩下一阶段", []}
% , {"addhonour", "增加荣誉值", ["数量"]}
% , {"modifyannounce", "修改公会公告", ["公告"]}
% , {"modifyguildname", "修改公会名字", ["名字"]}
% , {"disbandguild", "解散公会", []}
% , {"clearmail", "删除过期邮件", []}
% , {"activefashionall", "激活全部时装", []}
% , {"addgoods", "增加物品", ["物品类型", "物品类型id", "物品数量"]}
% , {"buydun", "增加副本次数", ["副本id", "次数"]}
% , {"ghost", "变幽灵", ["1"]}
% , {"start3armies", "开启三军之战", ["持续时间(s)"]}
% , {"addbuff", "添加buff", ["技能id"]}
% , {"rmbuff", "移除buff", ["技能id"]}
% , {"rmbuff2", "移除buff类型", ["buff类型"]}
% , {"act19", "开启幻兽入侵", ["300"]}
% , {"addhipoints", "加狂欢值", ["值"]}
% , {"runereset", "重置符文副本", []}
% , {"onetouchfriend", "一键加好友(会掉线)", ["数量"]}
% , {"wldbossinit", "世界boss重置", []}
% , {"sdl#next", "星钻联赛下一阶段", []}
% , {"sdl#applyall", "星钻联赛全服报名", []}
% , {"clearcollect", "收集活动清理", ["类型（1为全服 2为全服和个人）"]}
% , {"clearrechargerank", "结算充值排行", []}
% , {"changesource", "服务端渠道标识", ["渠道"]}
% , {"3v3", "开启3v3", ["持续时间"]}
% , {"3v3timemb", "开启3v3(限制人數)", ["持續時間", "队伍人数"]}
% , {"3v3mb", "3v3限制人數", ["队伍人数"]}
% , {"synckfhegemonyser", "同步跨服服战服务器", []}
% , {"hegemonynext", "服战下一阶段", []}
% , {"hegemonyreset", "服战赛季重置", []}
% , {"hegemonyrecheck", "服战重新加载", []}
% , {"gmcloudbuyaward", "结束并结算云购", ["节点（0本服 1跨服）"]}
% , {"restartcloudbuy", "2s后重启云购", []}
% , {"reloadguess", "加载竞猜", []}
% , {"guessfile", "打印竞猜文件", []}
% , {"1vn1", "开启1vn淘汰赛", ["报名时间","进入时间", "淘汰赛时间"]}
% , {"1vn2", "开启1vn挑战赛", ["进入时间", "挑战赛时间"]}
% , {"kfgwarnext", "跨服公会战下一阶段", []}
% % , {"clearkfgwarguildinfo", "清理跨服公会战本公会信息", []}
% , {"resetkfgwarseason", "重置跨服公会战赛季", []}
% , {"addrunepoint", "增加符文经验", [1000]}
% , {"addrunechip",  "增加符文碎片", [1000]}
% , {"sendRumor","发送传闻", ["模块id", "配置id", "[参数用逗号隔开]"]}
% , {"addAllRune","增加所有符文", []}
% , {"addAllSoul","增加所有聚魂", []}
% , {"activemonpic", "激活图鉴", ["图鉴id"]}
% , {"awakening", "天命", []}
% , {"resetsomeact", "重置活动领取次数", ["活动类型","子类型"]}
% , {"successActivity", "完成活动",["功能id", "子id", "次数"]}
% , {"startguildbattle", "开启公会战", []}
% , {"endguildbattle", "结束公会战", []}
% , {"nine", "九魂圣殿", ["时间"]}
% , {"ninemod", "九魂圣殿单服", ["先改开发天数"]}
% , {"ninePartition", "九魂圣殿分服", []}
% , {"nineend", "九魂圣殿结束", []}
% , {"guildFeastOpen", "公会晚宴开启", []}
% , {"guildFeastClose", "公会晚宴关闭", []}
% , {"nineenter", "九魂圣殿进入", ["层数"]}
% , {"guilddunset", "公会副本复活数据设置", ["复活次数", "层数", "通报次数"]}
% , {"loginRewardReSet", "七天登录重置天数", [7]}
% , {"onlinetimeReset", "在线奖励重置", []}
% , {"onlinetimeAdd", "在线奖励增加时长", ["分钟"]}
% , {"valleyopen","激活契约之书",["层数"]}
% , {"inviteclear", "邀请清理日常和cd", []}
% , {"addsoulpoint","增加聚魂经验",["数量"]}
% , {"LimitShopSellReset","限时钜惠", []}
% , {"clinvite", "清理邀请数据", []}
% , {"clearshake", "清理摇摇乐数据",["活动子类型"]}
% , {"clearbonustree", "重置摇钱树",["活动子类型"]}
% , {"setMainDungeon", "主线副本关卡", ["关卡"]}
% , {"feastBossReset", "节日boss重置", []}
% , {"feastBossClose", "节日boss活动结束", []}
% , {"setTowerDun", "爬塔副本关卡", ["关卡"]}
% , {"setRune2Dun", "符文副本关卡", ["关卡"]}
% , {"moninvade", "异兽入侵清除等待时间", []}
% , {"moninvadeValue", "设置异兽入侵守护值", ["守护值","开服几天的奖励"]}
% , {"startdrum", "进入擂台赛准备期", ["X秒后"]}
% , {"drumrank", "进入16强", []}
% , {"attrMedicament", "属性药剂今日次数清0", []}
% , {"cleararbitramentloop", "圣裁轮盘清零", []}
% , {"gladst", "决斗场开始", ["是否跨服", "时间"]}
% , {"gladend", "决斗场结束", []}
% , {"bosstask", "boss任务", ["boss类型", "boss等级", "数量"]}
% , {"addTopHonor", "巅峰竞技荣耀值", [100]}
% , {"topPkSetRankLv", "巅峰竞技段位等级", ["RankLv"]}
% , {"topPkYesterdayRankLv", "巅峰竞技更新昨天段位等级", []}
% , {"setonhooktime", "设置个人挂机时间秒", ["100"]}
% , {"fastonhook", "快捷挂机", []}
% , {"setonhookdata", "设置挂机数据", []}
% , {"setonhookoff", "关闭挂机", []}
% , {"onhookexptime", "挂机经验次数", ["次数"]}
% , {"onhookoffexp", "离线经验", ["经验", "消耗"]}
% , {"checkcustom", "检查定制活动", []}
% , {"caliveness", "节日活跃", ["主类型", "次类型", "次数"]}
% , {"mondrop", "怪物掉落", []}
% , {"draconicequip", "增加龙语装备", ["阶数", "颜色"]}
% , {"cleanliveness", "清理节日活跃全服次数", ["主类型", "次类型"]}
% , {"cleanroleliveness", "清理节日活跃个人次数", ["主类型", "次类型"]}
% , {"refreshmon", "开启圣域夺宝", []}
% , {"closeterritoryact", "关闭圣域夺宝", []}
% , {"sanctuaryStart", "圣域开启", ["时间"]}
% , {"sanctuarySettlement", "圣域结算", []}
% , {"addweddingtimes", "增加婚宴次数", []}
% , {"sanctuaryClear", "圣域清理勋章", []}
% , {"sethuntfreetime", "设置寻宝免费时间", ["寻宝类型(1装备,2至尊,3巅峰)", "多少秒(S)之后"]}
% , {"sancturyUpdateDesignation", "修复圣域称号", []}
% , {"setluckeyvalue", "设置寻宝幸运值", ["100"]}
% , {"nearestmon", "最近的怪", []}
% , {"kfsanctuarymon", "开启跨服圣域",[]}
% , {"rmcustomactrecord", "清理定制活动记录", ["主类型", "次类型"]}
% , {"gmsetrolescore", "设置跨服圣域积分", ["1000"]}
% , {"addSanctuaryTried", "增加圣域疲劳", ["疲劳值"]}
% , {"middayPartyStart", "午间派对开启", []}
% , {"middayPartyEnd", "午间派对关闭", []}
% , {"middayPartyNum", "午间派对房间人数", ["人数"]}

% , {"topPKSendMail", "巅峰竞技发送邮件", []}
% , {"logout", "登出", []}
% , {"replaceequip","修复所有玩家幻兽装",[]}
% , {"deleteinvest", "删除投资", ["投资类型"]}
% , {"adddragonequip", "一键增加龙纹装备", []}
% , {"addkfSanctuaryTried", "增加跨服圣域疲劳值", ["240"]}
% , {"compensate", "经验补偿", ["挂机时间", "挂机经验"]}
% , {"gmUpdateTopPk", "更新巅峰竞技服务器Id", []}
% , {"resetbonusdraw", "重置赛博夺宝",[]}
% , {"luckyturntable", "充值幸运转盘", ["主类型", "次类型"]}
% , {"babytask", "完成宝宝任务", ["任务id", "数量"]}
% , {"addbabyraise", "增加养育值", ["数量"]}
% , {"resetbaby", "零点清理宝宝", []}
% , {"setwavebonusdraw", "设置赛博夺宝波数", ["活动类型","活动子类型","波数"]}
% , {"resetgodlevel", "重置神装系统", []}
% , {"delfestinvest", "删除节日投资档次", ["活动类型","活动子类型","档次"]}
% , {"resttreasurehunt", "重置寻宝", []}
% , {"eudemonslandexp", "圣兽领经验", ["增加经验值"]}
% , {"eudemonslandrank", "圣兽领榜单结算", []}
% , {"cusactstageclear", "升阶升战活动清状态", ["活动大类", "活动子类"]}
% , {"changename", "改名", ["玩家id(本玩家除外)", "名字"]}
% , {"changesanctuarytime", "跨服圣域对战服务器时间修改",[]}
% , {"role3v3Repair", "3v3数据修复", []}
% , {"resetvipgift", "重置vip特惠礼包", ["活动大类","活动子类"]}
% , {"viptimeout", "过期vip", ["vip特权卡类型"]}
% , {"alldemons", "激活所有使魔", ["星数", "等级"]}
% , {"deletedragonbagone", "删除龙纹背包某个物品", ["物品类型id", "数量", "1龙纹碎片0表示其他"]}
% , {"mergereturn", "合服清理充值返还", []}
% , {"DunDemonCompensate", "使魔副本补偿", []}
% , {"getdemonsdunattr", "使魔副本属性", ["使魔id"]}
% , {"protectuseclear", "清理保护使用次数", ["场景类型"]}
% , {"opengboss", "开启公会boss", []}
% , {"addgbossmat", "增加龙魂值", ["龙魂值"]}
% , {"endgboss", "关闭公会boss", []}
% , {"3v3ChampionPk", "3v3冠军赛开启", []}
% , {"3v3UpdataChampion", "3v3冠军赛取数据", []}
% , {"resetgbosstimes", "重置公会boss次数", []}
% , {"guildauction", "开启公会拍卖", ["功能id", "拍品列表", "参与分红玩家列表"]}
% , {"cleatauctionpay", "清除个人拍卖记录", []}
% , {"cleatauctionbonus", "清除个人分红", []}
% , {"gmsetextrastate", "跨服圣域累计贡献", ["增加贡献值"]}
% , {"gmresetstate","重置助力礼包状态", []}
% , {"decorsboss", "幻饰特殊boss刷新", []}
% , {"decorboss", "幻饰boss刷新", []}
% , {"betareturndays", "封测返还天数自增", []}
% , {"Season3v3Clear", "3v3赛季结算", []}
% , {"clearbackdecration", "清理背饰", []}
% , {"rdungeonlevel", "排名本通关", ["层数", "通关时间"]}
% , {"rdungeonsett", "排名本结算", []}
% , {"terriwarstart", "开启领地战", ["准备时长", "开始时间"]}
% , {"cleartitle", "重置头衔", []}
% , {"weekdunrank", "周常本榜单", ["副本id", "通关时间"]}
% , {"weekdunranksettle", "周常本榜单结算", []}
% , {"spiritblessvalue", "精灵转盘祝福值", ["祝福值"]}
% , {"onlinerewardreset", "重置在线奖励", []}
% , {"takeoffdraconicequip", "卸下龙语装备", ["位置"]}
% , {"leveldraw", "进行等级抽奖", ["活动子类"]}
% , {"rechargeconsumerank", "首发充值消费", ["活动子类", "榜单类型", "数量"]}
% , {"endrechargeconsumerank", "结束充值消费榜", ["活动大类", "活动子类"]}
% , {"clearleveldraw", "清除等级抽奖", ["活动子类"]}
% , {"clearFirstKill", "清除活动首杀", ["活动子类"]}
% , {"startredrain", "开启红包雨", ["活动子类"]}
% , {"addguilddaily", "增加公会宝箱", []}
% , {"clearguilddaily", "清理公会宝箱", []}
% , {"tribossrotary", "触发boss转盘", ["boss类型", "bossId"]}
% , {"clearservercamp", "清理服务器阵营记录", []}
% , {"addHolyBattle", "增加圣灵战场积分", [1000]}
% , {"openHolyBattle", "开启圣灵战场", []}
% , {"endHolyBattle",  "关闭圣灵战场", []}
% , {"calcHolyBattle",  "分区圣灵战场", []}
% , {"arcanareset", "远古奥术重置", []}
% , {"resetfourtunecat", "清空招财猫转盘", ["主类型","子类型"]}
% , {"resetcloudbuy", "重置跨服云购", ["主类型", "小类"]}
% , {"addcontractpoint", "添加契约点", ["活动子类型","契约点"]}
% , {"addgodcourtequip", "添加神庭装备", []}
% , {"cleargodcourtstatus", "清空神庭", []}
% , {"changegodhousestatus", "修改神之所", ["升橙次数", "等级"]}
% , {"finishChronoRiftAct", "完成时空裂缝任务", ["模块id","模块子Id", "值"]}
% , {"finishChronoRiftActEnd", "时空裂缝结束", []}
% , {"startescort", "开启矿石护送10分钟", []}
% , {"endescort", "结束矿石护送活动", []}
% , {"signUpClear", "日常预约清理", []}
% , {"cancelassist", "取消公会协助", []}
% , {"clearmon", "清理怪物", []}
% , {"clearstartrek", "清空星际旅行", ["主类型","子类型"]}
% ].

%% [{秘籍代码指令，秘籍名称，秘籍参数},...].
get_gm_ui_data(Status) ->
    A = [

        {"基础", [
            % {秘籍, 秘籍名称, 秘籍参数, 秘籍默认值(为空则显示秘籍参数)}
            {"pt", "调试协议", ["协议编号", "协议数据"], []}
            , {"scene", "强制切换场景", ["场景id"], ["1000"]}
            , {"money", "设置金钱", ["金钱数"], ["100000"]}
            , {"scurrency", "增加特殊货币", ["物品类型id", "数量"], []}
            , {"recharge", "充值商品", ["商品id:如1"], ["1"]}
            % 场景、战斗、怪物相关
            , {"mon", "创建怪物", ["怪物类型", "数量"], ["10000", "1"]}
            , {"monxy", "创建怪物2", ["怪物类型", "X", "Y"], ["11", "1000", "1000"]}
            , {"delmon", "删除怪物(删monxy)", [], []}
            , {"dummy", "创建假人", ["人数","分组(0不会打架)"], ["1", "0"]}
            , {"attr",  "改变属性",  ["属性列表"], [uio:format("[{{1},10000}, {{2}, 1000}]", [?ATT, ?HIT])]}
            , {"attr2", "改变属性(直接计算)", ["属性列表"], [uio:format("[{{1},10000}, {{2}, 1000}]", [?ATT, ?HIT])]}
            , {"group", "改变分组", ["分组"], ["1"]}
            , {"assistskill", "辅助技能释放", ["技能id", "技能等级"], ["8102205", "1"]}
            % , {"activeskill", "主动技能释放", ["技能id", "技能等级"], ["8102205", "1"]}
            , {"battleskill", "技能释放(需要拥有)", ["技能ID", "释放角度120"], ["5201001", "120"]}
            % 常用
            , {"opday", uio:format("开服天数({1})天,禁用:{2}", [util:get_open_day(), ?IF(mod_global_counter:get_count(?MOD_BASE, 1) == 0, false, true)]),
                ["开服天数"], ["1"]}
            , {"mergeday", uio:format("合服天数({1})天", [util:get_merge_day()]), ["合服天数"], ["1"]}
            , {"worldlv", uio:format("世界等级({1})级", [util:get_world_lv()]), ["等级"], ["1"]}
            , {"nochangeworldlv", uio:format("设置世界固定等级({1})级(固定值:{2})", [util:get_world_lv(), mod_global_counter:get_count(?MOD_0, ?GLOBAL_0_GM_WORLD_LV_OPEN)]), ["等级"], ["1"]}
            , {"cdaily", "清理个人日常", [], []}
            , {"wdaily", "清周日常", [], []}
            , {"lv", "升级", ["等级"], ["10"]}
            , {"vipexp", "加vip经验", ["增加经验"], []}
            , {"viptimeout", "过期vip", ["vip特权卡类型"], []}
            , {"turn", "转生", [], []}
            , {"logout", "强制登出", [], []}
            , {"designation", "激活称号", ["称号id"], ["104001"]}
            , {"alldesignation", "一键激活所有称号", [], []}
            , {"getprocessdata", "查看进程数据", ["0本服/1跨服", "序号"], ["0", "1"]}
            , {"restartprocess", "重启进程", ["序号"], ["1"]}
            , {"revive", "复活", ["复活类型"], ["22"]}
            , {"getscenemon", "输出当前场景怪物信息", [], []}
            , {"updatelogindays", "累积登陆天数加1", [], []}
            , {"gmclosemodule", "秘籍关闭活动", ["模块id","子模块id","0开启1关闭"], ["460", "0", "1"]}
            , {"zonechange", "测试改变分区", ["分区类型", "目标服务器id", "新分区id"], ["1", "1", "2"]}
            , {"forbidChat", "禁言", ["玩家id", "禁言类型0：5分钟 1 :10分钟 2:30分钟"],["1", "0"]}
            , {"unForbidChat", "解除禁言", ["玩家id"],["1"]}
            , {"forbidOpenDay", "开服天数禁用", ["0 开启，1 禁用"],["1"]}
            , {"changecrename", "修改重命名状态位", ["3 原来有免费命名，4 原来没有免费命名"],["3"]}
        ]},

        {"等级和服务器", [
            {"lv", "升级", ["等级"], ["10"]}
            % , {"setlv", "设置等级", ["500"]}
            , {"exp", "增加经验", ["经验"], ["1000000"]}
            , {"opday", uio:format("开服天数({1})天", [util:get_open_day()]), ["开服天数"], ["1"]}
            , {"mergeday", uio:format("合服天数({1})天", [util:get_merge_day()]), ["合服天数"], ["1"]}
            , {"mergewlv", uio:format("合服世界等级({1})", [util:get_merge_wlv()]), ["合服世界等级"], ["1"]}
            , {"worldlv", uio:format("世界等级({1})级", [util:get_world_lv()]), ["等级"], ["1"]}
            , {"attrdebug", "属性调试", ["1记录,2输出区别"], []}
            , {"skilldebug", "技能调试(不包含吗增益类型)", ["1记录,2输出区别"], []}
            , {"battleattrdebug", "战斗属性调试", ["1记录,2输出区别"], []}
            , {"outputattr", "输出所有属性", ["1战斗属性，2基础属性"], []}
            , {"outputskill", "输出所有技能(不包含增益类型)", ["技能类型"], []}
            , {"timerMidNight", "模拟0点", [], []}
        ]},

        {"背包物品装备", [
            {"goods",  "增加物品", ["物品类型id", "数量"], []}
            , {"multigoods",  "批量物品", ["多个物品ID用.隔开", "数量"], ["物品类型列表", "数量"]}
            , {"clean", "清理背包", [], []}
            , {"addgoods", "增加物品", ["物品类型", "物品类型id", "物品数量"], []}
            , {"goodsname","按名称添加物品",["物品名称", "物品数量"], ["八域狂剑", "1"]}
            , {"onekeyaddequip", "一键添加装备", ["颜色", "星级"], ["1","1"]}
            , {"onekeyaddequipstage", "一键添加装备(带阶数)", ["阶数", "颜色", "星级"], ["1","1","1"]}
            , {"goodstype", "按类型添加物品", ["大类", "子类", "数量"], []}
            , {"adddragonequip", "一键增加龙纹装备", [], []}
            , {"deletedragonbagone", "删除龙纹背包某个物品", ["物品类型id", "数量", "1龙纹碎片0表示其他"], []}
            , {"deletebygoodsid", "删除指定物品", ["物品类型id", "数量"], ["319", "1"]}
            , {"resetdecstren", "重置幻饰强化属性", [], []}
            , {"draconicequip", "增加龙语装备", ["阶数", "颜色"], []}
            , {"takeoffdraconicequip", "卸下龙语装备", ["位置"], []}
            , {"testdrop", "测试掉落", ["怪物ID", "次数"], []}
            , {"testdrop2", "测试掉落列表", ["怪物ID", "掉落列表", "次数"], []}
        ]},

        {"任务", [
            {"task",  "接任务",  ["任务id"], []}
            , {"dtask", "移除任务",  ["任务id"], []}
            , {"finishtask", "完成任务", ["任务id"], []}
            , {"cleanactask", "清理已接任务", ["0:当前已接;1:历史所有"], ["1"]}
            , {"finlvtask", "完成id之前任务", ["任务id"], ["9999999"]}
            , {"fincurrentmaintask", "完成当前主线任务", [], []}
            , {"finfiguretask", "完成唤醒任务", [], []}
            , {"fineudemonstask", "完成悬赏任务", ["任务id"], []}
            , {"clearyhbg", "重置永恒碑谷（契约纸之书）", [], []}
            , {"valleyopen","激活契约之书",["层数"], []}
            , {"cleardailytask", "清日常任务", [], []}
            , {"finishawakentask", "一键完成唤醒任务", [], []}
        ]},

        % 培养、成就等等
        {"功能玩法", [
            {"activemounttype", "激活培养系统", ["1坐骑2精灵等"], ["1"]}
            , {"checkin", "每日签到",["签到日", "是否补签"], []}
            , {"checkinReset", "每日签到重置", [], []}
            , {"checkinSetDay", uio:format("注册时间距离现在({1})天", [lib_checkin:gm_for_read(Status#player_status.reg_time)]),["0:减少1:增加", "多少天"], ["1", "1"]}
            % 首充活动
            , {"rechargefirstIndexL", "首充领取设置", ["领取列表(为空重置;[1]代表领了1)"], ["[]"]}
            , {"rechargefirstDays", "首充登录天数", ["登录天数(设置当天登录天数)"], ["1"]}
            % 挂机
            , {"setafktime", "设置个人挂机时间", ["秒"], ["100"]}
            , {"setoff", "设置挂机离线信息", ["离线挂机时间秒"], ["7200"]}
            , {"setoff2", "设置挂机离线信息",
                ["离线挂机时间秒(默认两个小时)", "离线时间戳", "指定绑钻数", "绑钻数时间戳"],
                ["7200", lists:concat([utime:unixtime() - 7200]), "100", lists:concat([utime:unixtime()])]}
            , {"setoff3", "设置挂机离线信息",
                ["离线挂机时间秒(默认两个小时)", "离线时间戳", "指定绑钻数", "绑钻数时间戳", "挂机倍率", "挂机倍率结束时间"],
                ["7200", lists:concat([utime:unixtime() - 7200]), "100", lists:concat([utime:unixtime()]), "1", lists:concat([utime:unixtime()])]}
            % 活跃度
            , {"addlive", "增加活跃度",["活动ID", "活动子ID"], []}
            , {"addlive2", "增加活跃度2",["数量"], []}
            , {"loginRewardReSet", "七天登录重置天数", [7], []}
            , {"loginMergeRewardReSet", "合服登录重置天数", [7], []}
            , {"addrunepoint", "增加符文经验", [1000], []}
            , {"addrunechip",  "增加符文碎片", [1000], []}
            , {"addAllRune","增加所有符文", [], []}
            , {"addAllSoul","增加所有聚魂", [], []}
            , {"clearlive", "清理统计的活跃度", [], []}
            % 成就
            , {"completeachv", "完成某系列成就", ["成就标签id"], [1]}
            , {"clearachv", "重置玩家成就", [], []}
            % 至尊vip
            , {"supvipchargeday", "至尊vip升永久充值天数", ["充值天数"], ["1"]}
            , {"supviplogindays", "至尊vip登录天数", ["登录天数"], ["1"]}
            , {"supviptaskchargeday", "至尊vip任务充值天数", ["充值天数"], ["1"]}
            , {"supvipskilltaskall", "至尊vip技能任务完成", [], []}
            , {"supvipskilltask", "至尊vip技能任务完成", ["任务id"], ["0"]}
            , {"supvipexref", "至尊vip体验过期时间", ["过期秒数"], ["300"]}
            , {"supvip", "至尊vip阶数", ["阶数"], ["1"]}
            , {"supvipright", "清理至尊vip特权", ["特权类型"], ["1"]}
            , {"sethuntfreetime", "设置寻宝免费时间", ["寻宝类型(1装备,2至尊,3巅峰)", "多少秒(S)之后"], []}
            , {"sealequip", "增加圣印装备", ["阶数", "颜色"], ["10", "5"]}
            , {"setjjcnum", "设置竞技场次数", ["次数"], ["10"]}
            , {"middayPartyStart", "午间派对开启", [], []}
            , {"middayPartyEnd", "午间派对关闭", [], []}
            , {"middayPartyNum", "午间派对房间人数", ["人数"], []}
            % 投资
            , {"investrw", "领取投资奖励", ["投资类型","奖励id"], ["1", "1"]}
            , {"investgettime", "投资领取时间", ["投资类型","领取时间戳"], ["1", "0"]}
            , {"investloginday", "投资登录时间", ["投资类型","登录天数"], ["1", "1"]}
            , {"deleteinvest", "删除投资", ["投资类型"], ["1"]}
            , {"resetfirstblood", "重置首杀", [], []}
            , {"resetspecialgift", "重置超值特惠礼包", ["活动子类型"], ["8"]}
            , {"setluckeyvalue", "设置寻宝幸运值", ["寻宝类型","幸运值"], ["1","100"]}
            % 假人聊天
            , {"robotchat", "机器人聊天", ["类型"], [""]}
            , {"templeawaken", "神殿觉醒章节完成", ["类型"], ["1001"]}
            , {"templeawkanesub", "神殿觉醒子章节完成", ["章节", "子章节"], ["1001", "1"]}
            , {"templeawkanestage", "神殿觉醒章节阶段完成", ["章节", "子章节", "阶段"], ["1001", "1", "1"]}
            , {"cleartempleawaken", "清空神殿觉醒", [], []}
            , {"addRevelationEquip", "添加天启装备", ["数量"], ["10"]}
            , {"addcontractpoint", "添加契约点", ["活动子类型","契约点"], []}
            % 惊喜礼包
            , {"suprisegifttimes", "惊喜礼包增加免费次数", ["次数"], ["1"]}
            , {"addconstellation", "增加星宿装备", ["星宿id"], ["1"]}
            , {"clearconstellationforge", "清空星宿锻造", [], []}
            , {"constellationgoodsadd", "一键添加星宿锻造材料", ["数量"], ["100"]}
            , {"deleteusedgoods", "设置魔晶使用数量", ["类型(3翅膀)", "物品类型id", "数量"], ["3", "18010003", "1"]}
            , {"advertisementClear", "清理", [], []}
            , {"advertisementFinish", "看完广告", [], []}
            , {"resetgodlv", "重置降神等级", ["降神id", "等级"], ["1", "0"]}
            % 祭典
            , {"resetFiesta", "重置祭典", [], []}
            , {"addFiestaExp", "增加祭典经验", ["增加经验值"], ["0"]}
            , {"finishFiestaTask", "完成祭典任务(按id)", ["任务id"], ["0"]}
            , {"finishFiestaTask2", "完成祭典任务(按内容)", ["任务内容"], ["acc@recharge"]}
            , {"setPlayerRegTime", "设置玩家创角时间", ["时间戳"], ["0"]}
            , {"growwelfaretask", "完成成长福利任务", [], []}
        ]},

        {"副本", [
            {"dungeon", "副本", ["副本id"], ["19001"]}
            , {"setRune2Dun", "符文副本关卡", ["关卡"], []}
            , {"weekdunranksettle", "周常本榜单结算", [""], []}
            , {"resetrankdungeon", "重置神谕副本挑战次数", [], []}
            , {"setMainDungeon", "主线副本(推关)关卡", ["关卡"], []}
        ]},

        {"定制活动", [
            {"rushrankclear", "开服冲榜结算", [], []}
            , {"reloadccustom", "重新加载定制活动", [], []}
            , {"cusactstageclear", "升阶升战活动清状态", ["活动大类", "活动子类"], ["65", "1"]}
            , {"customactoplist", "打印已开启的定制活动", [], []}
            , {"clearactdata", "清空定制活动数据", ["活动大类", "活动子类"], ["99", "1"]}
            , {"forceendbetarecharge", "强制结束封测充值返利", [], []}
            , {"resetbetarecharge", "重置封测充值返利", [], []}
            , {"resetbonustreasure", "重置个人幸运鉴宝", ["活动大类", "活动子类"], ["102", "1"]}
            , {"caliveness", "节日活跃", ["主类型", "次类型", "次数"], ["56", "2", "1"]}
            , {"cleanliveness", "清理节日活跃全服次数", ["主类型", "次类型"], ["56", "2"]}
            , {"cleanroleliveness", "清理节日活跃个人次数", ["主类型", "次类型"], ["56", "2"]}
            , {"cleanUpPowerRank", "战力冲榜结算", ["子类型"], [1]}
            , {"customactwlv", "定制活动世界等级(内存中)", ["主类型", "次类型", "等级"], ["1", "2", "100"]}
            , {"endrechargeconsumerank", "结束充值消费榜", ["活动大类", "活动子类"], ["33", "2"]}
            , {"resetrechargeconsumerank", "重置充值消费榜（充值：381，消费：382）", ["消费大类", "活动子类"], ["381", "2"]}
            , {"feastbossreset", "节日boss重置", [], []}
            , {"feastbossclose", "节日boss活动结束", [], []}
            , {"enveloperebate", "红包返利奖励", [], []}
            , {"startredrain", "开启红包雨", ["活动子类"], ["1"]}
            , {"gmaddturnpoint", "增加天命值", ["增加数量"], ["3000"]}
        ]},

        {"跨服玩法", [
              {"gmresetmod", "重新分服", [], []}
            , {"refreshmon", "开启圣域夺宝", [], []}
            , {"closeterritoryact", "关闭圣域夺宝", [], []}
            , {"gmsetrolescore", "添加跨服圣域积分", ["1000"], []}
            , {"nine", "九魂圣殿", ["时间"], []}
            , {"ninemod", "九魂圣殿单服", ["先改开发天数"], []}
            , {"nineend", "九魂圣殿结束", [], []}
            , {"nineenter", "九魂圣殿进入", ["层数"], []}
            , {"beingsgatestart", "开启众生之门", ["持续时间"], ["900"]}
            , {"beingsgateend", "关闭众生之门", [], []}
            , {"toppk#seasonend", "巅峰竞技赛季结算", [], []}
            , {"toppk#start", "开启巅峰竞技", ["300"], []}
            , {"addTopHonor", "巅峰竞技荣耀值", [100], []}
            , {"topPkSetRankLv", "巅峰竞技段位等级", ["RankLv"], []}
            , {"topPkSetMatch", "巅峰竞技匹配次数", ["Count(设置完要匹配一次)"], []}
            , {"topPkYesterdayRankLv", "巅峰竞技更新昨天段位等级", [], []}
            , {"openHolyBattle", "开启圣灵战场", [], []}
            , {"endHolyBattle",  "关闭圣灵战场", [], []}
            , {"calcHolyBattle",  "分区圣灵战场", [], []}
            , {"kfsanctuarymon", "开启跨服圣域",[], []}
            , {"addkfSanctuaryTried", "设置跨服圣域疲劳值", ["240"], []}
            , {"clearservercamp", "清理服务器阵营记录", [], []}
            , {"terriwarstart", "开启领地战", ["准备时长", "开始时间"], []}
            , {"startdrum", "进入钻石大战准备期", ["X秒后"], []}
            , {"drumrank", "进入钻石大战16强", [], []}
            , {"kfsanctuaryboss", "跨服圣域boss刷新", [], []}
            , {"opensanctum", "永恒圣殿开启", ["分钟"], ["15"]}
            , {"closesanctum", "永恒圣殿关闭", [], []}
            , {"kfsanctuaryclear", "跨服圣域定时清理", ["0疲劳值1个人积分"], ["0"]}
            , {"endallship", "结束所有巡航", [], []}
            , {"clearshippinglog", "清理巡航日志", ["0所有玩家1本人"], ["0"]}
            , {"clearshipping", "清理失效巡航数据", [], []}
            , {"createrobot", "创建巡航机器人", [], []}
            , {"rdungeonsett", "排名本结算", [], []}
            , {"finishChronoRiftAct", "完成时空裂缝任务", ["模块id","模块子Id", "值"], []}
            , {"finishChronoRiftActEnd", "时空裂缝结束", [], []}
            , {"gmstartseacraft", "开启怒海争霸", ["1海域争夺2海域争霸", "时长（分钟）"], []}
            , {"gmendseacraft", "结束怒海争霸", [], []}
            , {"gmupdmember", "怒海更新成员数据", [], []}
            , {"gmaddseaexploit_功勋值", "添加怒海功勋值", [], []}
            , {"gmresetseacraft", "重置海域赛季(使用后等2分钟)", [], []}
            , {"freshseacraftboss", "海域日常boss刷新", [], []}
            , {"seacraftsetbrick", "海域日常设置砖块", ["用完后搬下砖"], ["海域ID", "数量"]}
            , {"1vn1", "开启1vn淘汰赛", ["报名时间","进入时间", "淘汰赛时间"], []}
            , {"1vn2", "开启1vn挑战赛", ["进入时间", "挑战赛时间"], []}
            , {"gmOpenNG", "开启百鬼夜行", [], []}
            , {"gmCloseNG", "关闭百鬼夜行", [], []}
        ]},

        {"本服玩法", [
              {"sanctuaryStart", "圣域开启", ["时间"], []}
            , {"sanctuarySettlement", "圣域结算", [], []}
            , {"sanctuaryupdate", "圣域排行榜更新", [], []}
            , {"sanctuaryClear", "圣域清理勋章", [], []}
            , {"sancturyUpdateDesignation", "修复圣域称号", [], []}
            , {"addSanctuaryTried", "增加圣域疲劳", ["疲劳值"], []}
            , {"resetsanctuaryboss", "圣域Boss复活", ["圣域Id"], []}
            , {"guildFeastOpen", "公会晚宴开启", [], []}
            , {"guildFeastClose", "公会晚宴关闭", [], []}
            , {"guildFeastGameType", "设置公会晚宴轮换游戏", ["0:答题1:消消乐"], ["0"]}
            , {"resetgbosstimes", "重置公会boss次数", [], []}
            , {"bossinit", "boss重置", [], []}
            , {"domainspbossinit", "秘境领域毁灭领主刷新", [], []}
            , {"LimitShopSellReset","限时钜惠", [], []}
            , {"LimitShopSellReset1","限时钜惠刷新未购买", ["1自己0所有玩家"], ["0"]}
            , {"bossgmclose", "gm关闭boss", ["0所有/boss类型", "1关闭0开启"], ["12", "1"]}
            , {"clearbossratio", "清空Boss掉落概率列表", [], []}
        ]},

        {"各种Boss", [
            {"decorboss", "幻饰Boss复活", [], []}
            , {"setbossvit", "设置世界boss体力", ["体力值"], ["20"]}
            , {"gmsetlastvittime", "设置上次体力更新时间", ["时间戳"], ["0"]}
            , {"bossreborn", "boss复活", ["Boss类型", "BossId"], ["12", "3400095"]}
            , {"clearNoAutoRemind", "清理boss之家自动关注限制", [], []}
        ]},

        {"公会", [
            {"gcoin", "公会货币", ["公会货币"], []}
            , {"addgrowth", "增加公会成长值", ["1000"], []}
            , {"adddonate", "增加公会贡献", ["1000"], []}
            , {"addgfunds", "增加公会资金", ["1000"], []}
            , {"disbandguild", "解散公会", [], []}
            , {"disbandguild2", "解散指定公会", ["公会Id"], []}
            , {"opengboss", "开启公会boss", [], []}
            , {"addgbossmat", "增加龙魂值", ["龙魂值"], []}
            , {"endgboss", "关闭公会boss", [], []}
            , {"guildauction", "开启公会拍卖", ["功能id", "拍品列表", "参与分红玩家列表"], []}
            , {"cleatauctionpay", "清除个人拍卖记录", [], []}
            , {"cleatauctionbonus", "清除个人分红", [], []}
            , {"quitguildnocheck", "强制退出公会", [], []}
            , {"addprestige", "公会增加声望值", ["1000"], []}
            , {"degradeprestige", "公会声望降级", ["秒数"], []}
            , {"clearprestigerecord", "公会清理声望获取记录", [], []}
            , {"cancelassist", "取消公会协助", [], []}
            , {"guildmerge", "触发所有已同意的公会合并", [], []}
            , {"clearguildmerge", "清理公会合并", [], []}
        ]},

        {"其他", [
            {"mail", "增加测试邮件", [], []}
            , {"mails", "增加多封邮件", ["数量"], ["1"]}
            , {"rewardmail", "增加奖励邮件", [], ["[{0,101075021,1},{0,38040002,1024}]"]}
            , {"rewardmails", "增加多封奖励邮件", [], ["[{0,101075021,1},{0,38040002,1024}]", "1"]}
            , {"delmail", "清理所有邮件", [], []}
            , {"clearmail", "删除过期邮件", [], []}
            , {"battleformula", "战斗模拟", ["数量", "攻击属性列表", "攻击者等级", "防守属性列表", "防守者等级", "技能id", "技能等级"],
                ["1", "[{1,1000},{2,1000},{3,1000}]", "100", "[{1,1000},{2,1000},{3,1000}]", "50", "200201", "1"]}
            , {"attrpower", "属性战力", [], []}
            , {"sendtv", "传闻", [], ["Module", "Id"]}
            , {"sendscenetv", "场景传闻", [], ["Module", "Id"]}
            , {"addweddingtimes", "增加婚宴次数", ["婚礼类型:1:精致婚礼 2：豪门婚礼 3：简约婚礼"], ["2"]}
            , {"weddingstart", "婚礼开始", [], []}
            , {"weddingend", "婚礼结束", [], []}
            , {"enterwedding", "进入婚礼", ["男角色的玩家id"], []}
            , {"clearhallinformation", "清除征友大厅信息", [], []}
            , {"updateweddingday", "更改相恋天数", ["相恋天数"], ["10"]}
            , {"cleanringinfo", "戒指数据清理", [], []}
            , {"htest", "临时测试", [], []}
            , {"babytask", "完成宝宝任务", ["任务id", "数量"], []}
            , {"addbabyraise", "增加养育值", ["数量"], []}
            , {"resetbaby", "零点清理宝宝", [], []}
            , {"kfSellClose", "关闭跨服市场", [], []}
            , {"addonhookcoin", "增加托管币", ["数量"], []}
            , {"mfa", "执行函数", ["{模块,函数,参数};下划线换成="], ["{io,format,[\"abc~n\", []]}"]}
            , {"dbquery", "查询数据库", ["{sql语句,参数};下划线换成@"], ["{\"select * from player@low where id = ~p\", [4294967309]}"]}
            , {"dbexecute", "执行sql", ["{sql语句};下划线换成@"], []}
            , {"updateplayerlogintime", "更新玩家最近登录时间", ["最近登录时间戳", "上上次登录时间戳"], ["1596729600", "1596556800"]}
            , {"spiritblessvalue", "精灵转盘祝福值", ["祝福值"], []}
            , {"alldemons", "激活所有使魔", ["星数", "等级"], []}
            , {"adddemonsskillpro", "加使魔生活技能进度", ["使魔id", "增加值"], []}
            , {"ninefakejoin", "假人托管九魂设置", ["参加人数"], []}
            , {"holyBattleFakeJoin", "假人托管圣灵战场", ["参加人数"], []}
            , {"1vnfakejoin", "假人托管1vn设置", ["参加人数"], []}
            , {"middayfakejoin", "假人托管午间排队", ["参加人数"], []}
            , {"fakeactivity", "假人托管设置", ["参加人数", "模块Id", "子模块ID"], []}
            , {"uploadnewinivtee", "更新被邀请者数据", ["邀请者id"], []}
            , {"addlvmount", "坐骑升阶", ["坐骑id", "坐骑阶数", "坐骑星级"], ["1", "20", "10"]}
            , {"guardexpired", "守护过期", ["0 无魔法阵 1 调皮小鬼 2 蛋壳天使 3 调皮恶魔 4 守护天使"], ["1"]}
            , {"freeexperience", "激活守护体验", ["1 调皮小鬼 2 蛋壳天使 3 调皮恶魔 4 守护天使"], ["1"]}
            , {"pushgiftclearexpire", "推送礼包过期清0", [], []}
            , {"outprocess", "输出进程信息", ["进程名;下划线换成@", "是否全局", "是否跨服"], ["mod@sanctuary@cluster@local", "0", "0"]}
            , {"modifycumulationolddata", "每日累充修复旧数据", [], []}
            , {"resetrunehunt", "重置符文夺宝", [], []}
            , {"setgmpassword", "设置秘籍密码", ["密码"], ["123"]}
            , {"resetsuit", "重置史诗套装激活", [], []}
            , {"printsceneinfo", "打印当前场景id", [], []}
            , {"rushtreasureactend", "冲榜夺宝活动结算秘籍", ["活动主类型", "活动子类型"], ["116", "1"]}
            , {"gmcombat", "重置战力福利", [], []}
            , {"tsmap", "批量挖宝", ["1-神秘 2-传说", "次数"], []}
            , {"mount", "坐骑类养成线", ["坐骑类型ID", "需要增加等级"], []}
            , {"limittower", "限时爬塔", [], []}
            , {"overtower", "结算限时爬塔", [], []}
            , {"onefinishtower", "一键所有关卡", ["需要完成的轮次"], []}
            , {"addweeklyccardexp", "增加周卡经验", ["经验值"], ["10"]}
            , {"expiredweeklycard", "重置周卡", [], []}
            , {"updateexpiredweeklycard", "周卡过期时间修改（默认过期后一天凌晨4点）", [], []}
            , {"addgodcourtequip", "添加神庭装备", [], []}
            , {"cleargodcourtstatus", "清空神庭", [], []}
            , {"changegodhousestatus", "修改神之所", ["升橙次数", "等级"], []}
            , {"taagentofficial", "TA上报正式测试(用完要关闭)", [], []}
            , {"taagentrevert", "TA关闭正式测试", [], []}
            , {"restorelevelactdata", "恢复玩家类型一等级抢购活动数据", [], []}
            , {"printpoolgift", "打印当前奖池礼包的轮次和失败次数", ["礼包类型Id"], ["32070088"]}
            , {"dragonballbuyrefresh", "星核直购活动刷新", [], []}
        ]}
   ],
   A.


%% 请求秘籍界面
handle(11100, Status, _) ->
    Data = get_gm_ui_data(Status),
    {ok, BinData} = pt_111:write(11100, [Data]),
    lib_server_send:send_to_sid(Status#player_status.sid, BinData),
    ok;

%% 执行秘籍
handle(11101, Status, [Data]) when is_list(Data) ->
    Args = string:tokens(Data, "_"),
    case Args of
        ["setgmpassword", GmPassword] ->
            put(gmpassword, GmPassword),
            % ?PRINT("GmPassword:~p ~n", [GmPassword]),
            ok;
        _ ->
            CfgGmPassword = config:get_gm_password(),
            % ?PRINT("GmPassword:~p, CfgGmPassword:~p ~n", [get(gmpassword), CfgGmPassword]),
            case CfgGmPassword == get(gmpassword) orelse CfgGmPassword == "" of
                true ->
                    #player_status{id = RoleId, figure = #figure{name = RoleName}} = Status,
                    lib_log_api:log_gm_use(RoleId, RoleName, Data),
                    execute_gm(Status, Data);
                false ->lib_game:send_error(Status, ?FAIL)
            end
    end;

handle(_Cmd, _, _Data) ->
    ?PRINT("cmd =~w, data=~p ~n", [_Cmd, _Data]),
    {error, no_match}.

%% 执行秘籍
execute_gm(Status, Data) ->
    Args = string:tokens(Data, "_"),
    NewStatus =
        case Args of
            %% 增加物品
            ["goods", _GoodsId, _Num] ->
                Id = list_to_integer(_GoodsId),
                Num = list_to_integer(_Num),
                lib_goods_api:send_reward_by_id([{?TYPE_GOODS, Id, Num}], gm, Status#player_status.id),
                %% lib_goods_api:give_goods_by_list(Status, [{Id, Num}], gm, 0),
                ok;
            ["multigoods", GoodsIdL0, _Num] ->
                Num = list_to_integer(_Num),
                F = fun(I) -> case I of 46 -> 44; _ -> I end end,
                GoodsIdLStr = "[" ++ lists:map(F, GoodsIdL0) ++ "]",
                case util:string_to_term(GoodsIdLStr) of
                    undefined -> skip;
                    GoodsIdL ->
                        lib_goods_api:send_reward_by_id([{?TYPE_GOODS, Id, Num}||Id<-GoodsIdL], gm, Status#player_status.id)
                end;
            %% 按名称添加物品
            ["goodsname", _GoodsName, _Num] ->
                %%获得物品类别列表
                TypeList = data_goods_type:get_type(),
                Num = list_to_integer(_Num),
                %%根据中文找到物品id
                F = fun(GoodsTypeId, AccL) ->
                    EtsGoodsType = data_goods_type:get(GoodsTypeId),
                    EtsGoodsName = binary_to_list(EtsGoodsType#ets_goods_type.goods_name),
                    case _GoodsName =:= EtsGoodsName of
                        true ->
                            RewardList = [{?TYPE_GOODS, GoodsTypeId, Num}|AccL],
                            %%每一百个物品睡眠1秒
                            case length(RewardList) >= 100 of
                                true ->
                                    lib_goods_api:send_reward_by_id(RewardList, gm, Status#player_status.id),
                                    timer:sleep(1000),
                                    [];
                                _ -> RewardList
                            end;
                        false ->
                            AccL
                    end
                end,
                %%寻找该物品所属类别
                F1 = fun(Type, List) ->
                    GoodsIdList = data_goods_type:get_by_type_all(Type),
                    lists:foldl(F, [], GoodsIdList) ++ List
                end,
                spawn(fun() ->
                    Reward = lists:foldl(F1, [], TypeList),
                    case length(Reward) > 0 of
                        true -> lib_goods_api:send_reward_by_id(Reward, gm, Status#player_status.id);
                        _ -> ok
                    end
                end),
                ok;
            ["goodstype", _Type, _Subtype, _Num] ->
                GoodsIdList = data_goods_type:get_by_type(list_to_integer(_Type), list_to_integer(_Subtype)),
                Num = list_to_integer(_Num),
                spawn(fun() ->
                    F = fun(GoodsTypeId, L) ->
                        L1 = [{?TYPE_GOODS, GoodsTypeId, Num}|L],
                        case length(L1) >= 100 of
                            true ->
                                lib_goods_api:send_reward_by_id(L1, gm, Status#player_status.id), timer:sleep(1000),
                                [];
                            _ -> L1
                        end
                    end,
                    Left = lists:foldl(F, [], GoodsIdList),
                    case length(Left) > 0 of true -> lib_goods_api:send_reward_by_id(Left, gm, Status#player_status.id); _ -> ok end
                end),
                ok;
            ["onekeyaddequip", _Color, _Star] ->
                lib_equip:one_key_add_equip(Status, list_to_integer(_Color), list_to_integer(_Star));
            ["onekeyaddequipstage", Stage, Color, Star] ->
                lib_equip:one_key_add_equip(Status, list_to_integer(Stage), list_to_integer(Color), list_to_integer(Star));
            ["goodslist", List] ->
                GoodsList = util:string_to_term(List),
                {_, NStatus} = lib_goods_api:send_reward_with_mail(Status, #produce{type = gm, reward = GoodsList}),
                NStatus;
            ["costlist", List] ->
                CostList = util:string_to_term(List),
                case lib_goods_api:cost_object_list_with_check(Status, CostList, gm, "") of
                    {true, NStatus} -> ok;
                    {false, Res, NStatus} -> ?PRINT("gm costlist Res ~p~n", [Res])
                end,
                NStatus;
            ["revive", _Type] ->
                pp_battle:handle(20004, Status, list_to_integer(_Type));
            %% 发特殊类型货币
            ["scurrency", _GoodsId, _Num] ->
                Id = list_to_integer(_GoodsId),
                Num = list_to_integer(_Num),
                lib_goods_api:send_reward_by_id([{?TYPE_CURRENCY, Id, Num}], gm, Status#player_status.id),
                ok;
            %% 清理背包
            ["clean"] ->
                GoodsStatus = lib_goods_do:get_goods_status(),
                Dict1 = dict:filter(fun(_Key, [Value]) ->
                    case Value#goods.id > 0 of
                        true ->
                            Value#goods.location == Value#goods.bag_location;
                        _ -> false
                    end
                end, GoodsStatus#goods_status.dict),
                DictList = dict:to_list(Dict1),
                List = lib_goods_dict:get_list(DictList, []),
                [lib_goods_do:delete_one(GoodsInfo#goods.id, GoodsInfo#goods.num)||GoodsInfo<-List];
            %% 设置金钱
            ["money", _Money] ->
                Money = list_to_integer(_Money),
                db:execute(io_lib:format(<<"update `player_high` set coin = ~p, gcoin = ~p, bgold = ~p, gold = ~p where id=~p">>, [Money, Money, Money, Money, Status#player_status.id])),
                StatusMoney =  Status#player_status{gold = Money, bgold = Money, coin = Money, gcoin = Money},
                lib_player:send_attribute_change_notify(StatusMoney, ?NOTIFY_MONEY),
                StatusMoney;
            %% 设置金钱
            ["coin", _Money] ->
                Money = list_to_integer(_Money),
                db:execute(io_lib:format(<<"update `player_high` set coin = ~p where id=~p">>, [Money, Status#player_status.id])),
                StatusMoney =  Status#player_status{coin = Money},
                lib_player:send_attribute_change_notify(StatusMoney, ?NOTIFY_MONEY),
                StatusMoney;
            ["vipexp", _Exp] ->
                StatusMoney = lib_vip:add_vip_exp(Status, list_to_integer(_Exp)),
                StatusMoney;
            %% 公会货币
            ["gcoin", _Gcoin] ->
                Gcoin = list_to_integer(_Gcoin),
                db:execute(io_lib:format(<<"update `player_high` set gcoin = ~p where id=~p">>, [Gcoin, Status#player_status.id])),
                StatusMoney =  Status#player_status{gcoin = Gcoin},
                lib_player:send_attribute_change_notify(StatusMoney, ?NOTIFY_MONEY),
                StatusMoney;
            %% 调试协议
            ["pt", _Cmd, _CmdData] ->
                Cmd = list_to_integer(_Cmd),
                CmdData = util:string_to_term(_CmdData),
                %% catch，方便报错后能还原现场，继续调试
                case catch mod_server:routing(Cmd, Status, CmdData) of
                    {'EXIT', _} = ExitReason ->
                        ?PRINT("'EXIT' gm_handle args: ~p~n reason = ~p~n", [[_Cmd, _CmdData], ExitReason]),
                        ?ERR("'EXIT' gm_handle args: ~p~n reason = ~p~n", [[_Cmd, _CmdData], ExitReason]),
                        ok;
                    Other -> Other
                end;
            %% MFA
            ["mfa", MfaData] ->
                %% 把"="替换为"_"
                ExFun = fun
                    (61) -> 95;
                    (R) -> R
                end,
                List = lists:map(ExFun, MfaData),
                Return = case util:string_to_term(List) of
                    undefined -> {};
                    DataT ->
                        {M, F, A} = DataT,
                        apply(M, F, A)
                end,
                ReturnData = util:term_to_string(Return),
                ?PRINT("~n M:~p L:~p ReturnData:~p ~n", [?MODULE, ?LINE, Return]),
                ?ERR("~n M:~p L:~p ReturnData:~p ~n", [?MODULE, ?LINE, Return]),
                lib_chat:gm_send_to_all(Status, ReturnData),
                ok;
            ["mon", MonTypeIdStr, NumStr] ->
                MonTypeId = list_to_integer(MonTypeIdStr),
                Num = list_to_integer(NumStr),
                case data_mon:get(MonTypeId) of
                    #mon{type=Type} ->
                        [lib_mon:async_create_mon(MonTypeId, Status#player_status.scene, Status#player_status.scene_pool_id,
                            Status#player_status.x, Status#player_status.y, Type, Status#player_status.copy_id, 1, [])  ||_N  <- lists:seq(1, Num) ];
                    _ -> skip
                end,
                ok;
            ["mon1", MonTypeIdStr] ->
                #player_status{figure = #figure{guild_id = GuildId}} = Status,
                MonTypeId = list_to_integer(MonTypeIdStr),
                case data_mon:get(MonTypeId) of
                    #mon{type=Type} ->
                        lib_scene_object:async_create_object(?BATTLE_SIGN_BTREE_MON, MonTypeId, Status#player_status.scene, Status#player_status.scene_pool_id,
                            Status#player_status.x, Status#player_status.y, Type, Status#player_status.copy_id, 1, []);
                    _ -> skip
                end,
                ok;
            ["monxy", MonTypeIdStr, XStr, YStr] ->
                MonTypeId = list_to_integer(MonTypeIdStr),
                X = list_to_integer(XStr),
                Y = list_to_integer(YStr),
                #player_status{scene = SceneId, scene_pool_id = ScenePoolId, copy_id = CopyId} = Status,
                case data_mon:get(MonTypeId) of
                    #mon{type=Type} ->
                        MonId = lib_mon:sync_create_mon(MonTypeId, SceneId, ScenePoolId, X, Y, Type, CopyId, 1, []),
                        CreateMonL0 = get('gm_mon_create'),
                        CreateMonL = ?IF(is_list(CreateMonL0), CreateMonL0, []),
                        NewCreateMonL = [{MonId, SceneId, ScenePoolId}|CreateMonL],
                        put('gm_mon_create', NewCreateMonL),
                        ok;
                    _ -> skip
                end;
            ["delmon"] ->
                case erase('gm_mon_create') of
                    CreateMonL when is_list(CreateMonL) ->
                        [lib_mon:clear_scene_mon_by_ids(SceneId, ScenePoolId, 1, [MonId])||{MonId, SceneId, ScenePoolId}<-CreateMonL];
                    _ ->
                        skip
                end;
            ["scene", SceneIdStr] ->
                SceneId = list_to_integer(SceneIdStr),
                case data_scene:get(SceneId) of
                    #ets_scene{} ->
                        lib_scene:player_change_scene(Status#player_status.id, SceneId, 0, 0, true, []);
                    _ -> skip
                end,
                ok;
            ["scene", SceneIdStr, _X, _Y] ->
                SceneId = list_to_integer(SceneIdStr),
                X = list_to_integer(_X),
                Y = list_to_integer(_Y),
                case data_scene:get(SceneId) of
                    #ets_scene{} ->
                        io:format("scene:~p~n", [{SceneId, X, Y}]),
                        lib_scene:player_change_scene(Status#player_status.id, SceneId, 0, 0, X, Y, false, []);
                    _ -> skip
                end,
                ok;
            ["dummy", Num, GroupStr] ->
                Group = list_to_integer(GroupStr),
                SkillList = lib_dummy_api:get_skill_list(Status),
                [begin
                MyArgs0 = [{figure, lib_dummy_api:change_figure(Status#player_status.figure, [rand_wing,rand_name,rand_fashion])}, {battle_attr, Status#player_status.battle_attr}, {skill, SkillList},{group, Group},{ghost,0}],
                if
                    Group > 0 ->
                        MyArgs = [{find_target, 3000}|MyArgs0];
                    true ->
                        MyArgs = MyArgs0
                end,
                lib_scene_object:async_create_object(?BATTLE_SIGN_DUMMY, 0, Status#player_status.scene, Status#player_status.scene_pool_id,
                                                     Status#player_status.x, Status#player_status.y, 1, Status#player_status.copy_id, 1, MyArgs)
                end|| _ <- lists:seq(1, list_to_integer(Num))];
            ["lv", AddLvStr] ->
                AddLv = list_to_integer(AddLvStr),
                RealAddLv = AddLv, %% min(AddLv, 60),
                F = fun(_, TmpStatus) ->
                            Exp = max(0, data_exp:get(TmpStatus#player_status.figure#figure.lv) - TmpStatus#player_status.exp),
                            UpExpStatus = lib_player:add_exp(TmpStatus, Exp, ?ADD_EXP_GM, []),
                            {ok, UpExpStatus}
                    end,
                {ok, UpLvStatus} = util:for(Status#player_status.figure#figure.lv, min(999999,Status#player_status.figure#figure.lv+RealAddLv-1), F, Status),
                UpLvStatus;
            % 不要使用本秘籍:会导致战力问题
            % ["setlv", StrLv] ->
            %     RealAddLv = list_to_integer(StrLv),
            %     Figure = Status#player_status.figure,
            %     TmpStatus = Status#player_status{exp = 0, figure = Figure#figure{lv = RealAddLv}},
            %     UpExpStatus = lib_player:add_exp(TmpStatus, 1, ?ADD_EXP_GM, []),
            %     pp_player:handle(13001, UpExpStatus, []),
            %     UpExpStatus;
            ["turn"] ->
                #player_status{figure = Figure, reincarnation = ReincarnationStatus} = Status,
                #figure{turn = OldTurn} = Figure,
                NewTurn = OldTurn + 1,
                case NewTurn =< ?MAX_TURN of
                    true ->
                        NewReincarnationStatus = ReincarnationStatus#reincarnation{
                            turn = NewTurn,
                            turn_stage = 0,
                            stage_tasks = []},
                        lib_reincarnation:save_reincarnation_data(NewReincarnationStatus),
                        NewPlayer = Status#player_status{figure = Figure#figure{turn = NewTurn, turn_stage = 0}, reincarnation = NewReincarnationStatus},
                        lib_reincarnation:turn_up(NewPlayer);
                    false ->
                        Status
                end;
            ["gmexp", AddExpStr] ->
                AddExp = list_to_integer(AddExpStr),
                lib_player:add_exp(Status, AddExp, ?ADD_EXP_GM, []);
            ["exp", AddExpStr] ->
                AddExp = list_to_integer(AddExpStr),
                case AddExp > 0 of
                    true  -> lib_player:add_exp(Status, AddExp, ?ADD_EXP_GM, []);
                    false -> lib_player:deduct_exp(Status, abs(AddExp))
                end;
            ["task", TaskIdStr] -> %% 强制接取某个任务
                TaskId = list_to_integer(TaskIdStr),
                case data_task:get(TaskId) of
                    null -> skip;
                    _    -> mod_task:force_trigger(Status#player_status.tid, TaskId, lib_task_api:ps2task_args(Status))
                end,
                ok;
            ["dtask", TaskIdStr] -> %% 移除某个任务
                TaskId = list_to_integer(TaskIdStr),
                case data_task:get(TaskId) of
                    null -> skip;
                    _    ->  mod_task:del_task(Status#player_status.tid, TaskId, lib_task_api:ps2task_args(Status))
                end,
                ok;
            ["cleanactask", Type] ->
                mod_task:gm_refresh_task(Status#player_status.tid, list_to_integer(Type), lib_task_api:ps2task_args(Status)),
                ok;
            ["finishtask", TaskIdStr] ->
                TaskId = list_to_integer(TaskIdStr),
                Res1111 = lib_task_api:gm_finish(Status, TaskId),
                ?PRINT("finishtask gm ~p~n", [Res1111]),
                lib_task_event:finish(Status, TaskId);
            ["finishawakentask"] ->
                TaskIds = [2001000, 2001100, 2001200, 2001300, 2001400,2002000, 2002100, 2002200, 2002300, 2002400, 2000000],
                F = fun(TaskId, AccStatus) -> lib_task_api:gm_finish(AccStatus, TaskId),lib_task_event:finish(AccStatus, TaskId) end,
                lists:foldl(F, Status, TaskIds);
            ["finlvtask", MainTaskIdStr] ->
                TaskArgs = lib_task_api:ps2task_args(Status),
                spawn(fun() ->
                    case mod_task:finish_lv_task(Status#player_status.tid, TaskArgs, 0, list_to_integer(MainTaskIdStr)) of
                        LastTaskId when is_integer(LastTaskId) ->
                            lib_player:update_player_info(Status#player_status.id, [{last_task_id, LastTaskId}]);
                        _ -> ok
                    end
                end);
            ["fincurrentmaintask"] ->
                LastTaskId = Status#player_status.last_task_id,
                case data_task:get(LastTaskId) of
                    #task{next = TaskId} ->
                        ?PRINT("TaskId ~p ~n", [TaskId]),
                        lib_task_api:gm_finish(Status, TaskId),
                        lib_task_event:finish(Status, TaskId);
                    _ -> skip
                end;
            ["finfiguretask"] ->
                TaskArgs = lib_task_api:ps2task_args(Status),
                spawn(fun() -> mod_task:finish_lv_task(Status#player_status.tid, TaskArgs, 1, 0) end);
            ["fineudemonstask", TaskIdStr] ->
                TaskArgs = lib_task_api:ps2task_args(Status),
                CellNum = lib_goods_api:get_cell_num(Status),
                TaskId = list_to_integer(TaskIdStr),
                mod_task:finish_eudemonstask(Status#player_status.tid, TaskId, [CellNum], TaskArgs),
                lib_eudemons_land:fin_task(Status, TaskId);
            ["cleardailytask"] ->
                RoleId = Status#player_status.id,
                db:execute(io_lib:format("delete from `task_bag` where `role_id` = ~p and (`type` = ~w or `type` = ~w or `type` = ~w or `type` = ~w or `type` = ~w)", [RoleId, ?TASK_TYPE_GUILD, ?TASK_TYPE_DAILY, ?TASK_TYPE_DAY, ?TASK_TYPE_DAILY_EUDEMONS,?TASK_TYPE_SANCTUARY_KF])),
                db:execute(io_lib:format("delete from `task_bag_content` where `role_id` = ~p and (`type` = ~w or `type` = ~w or `type` = ~w or `type` = ~w or `type` = ~w)", [RoleId, ?TASK_TYPE_GUILD, ?TASK_TYPE_DAILY, ?TASK_TYPE_DAY, ?TASK_TYPE_DAILY_EUDEMONS,?TASK_TYPE_SANCTUARY_KF])),
                db:execute(io_lib:format("delete from `task_log_clear` where `role_id` = ~p and (`type` = ~w or `type` = ~w or `type` = ~w or `type` = ~w)", [RoleId, ?TASK_TYPE_DAILY, ?TASK_TYPE_DAY, ?TASK_TYPE_DAILY_EUDEMONS,?TASK_TYPE_SANCTUARY_KF])),
                mod_task:each_daily_clear(Status#player_status.tid, lib_task_api:ps2task_args(Status), ?FOUR);
            ["attr", AttrListStr] ->
                AttrList = util:string_to_term(AttrListStr),
                BA = Status#player_status.battle_attr,
                OldOAttrList = lib_player_attr:to_kv_list(Status#player_status.original_attr),
                F = fun({Index, Value}, Result) ->
                    if
                        Index == 1 ->
                            [{Index, Value} | lists:keydelete(Index, 1, Result)];
                        Index == 2 ->
                            Result;
                        true ->
                            [{Index, Value} | lists:keydelete(Index, 1, Result)]
                    end
                end,
                CombineOAttrList = lists:foldl(F, OldOAttrList, AttrList),
                OAttr = lib_player_attr:to_attr_record(CombineOAttrList),
                Attr = lib_player:calc_attr_ratio(OAttr),
                case lists:keyfind(?HP, 1, AttrList) of
                    false -> HpLim = Attr#attr.hp;
                    {?HP, HpValue} -> HpLim = HpValue
                end,
                case lists:keyfind(?SPEED, 1, AttrList) of
                    false -> Speed = Attr#attr.speed;
                    {?SPEED, Speed} -> ok
                end,
                CombatPower = lib_player:calc_all_power(Attr#attr{hp = HpLim}),
                NewBA = BA#battle_attr{hp = HpLim, hp_lim = HpLim, speed = Speed, attr=Attr#attr{hp = HpLim}, combat_power = CombatPower},
                TmpStatus = Status#player_status{battle_attr = NewBA, combat_power = CombatPower},
                mod_scene_agent:update(TmpStatus, [{battle_attr, TmpStatus#player_status.battle_attr}]),
                lib_player:send_attribute_change_notify(TmpStatus, ?NOTIFY_ATTR),
                ?PRINT("gm change attr partial_power:~w expact_power: ~w~n",
                    [lib_player:calc_partial_power(OAttr, 0, AttrList),
                    lib_player:calc_expact_power(Status#player_status.original_attr, 0, AttrList)]),
                TmpStatus;
            ["attr2", AttrListStr] ->
                AttrList = util:string_to_term(AttrListStr),
                BA = Status#player_status.battle_attr,
                OldOAttrList = lib_player_attr:to_kv_list(Status#player_status.original_attr),
                F = fun({Index, Value}, Result) -> [{Index, Value} | lists:keydelete(Index, 1, Result)] end,
                CombineOAttrList = lists:foldl(F, OldOAttrList, AttrList),
                OAttr = lib_player_attr:to_attr_record(CombineOAttrList),
                Attr = lib_player:calc_attr_ratio(OAttr),
                HpLim = Attr#attr.hp,
                Speed = Attr#attr.speed,
                CombatPower = lib_player:calc_all_power(Attr#attr{hp = HpLim}),
                NewBA = BA#battle_attr{hp = HpLim, hp_lim = HpLim, speed = Speed, attr=Attr#attr{hp = HpLim}, combat_power = CombatPower},
                TmpStatus = Status#player_status{battle_attr = NewBA, combat_power = CombatPower},
                mod_scene_agent:update(TmpStatus, [{battle_attr, TmpStatus#player_status.battle_attr}]),
                lib_player:send_attribute_change_notify(TmpStatus, ?NOTIFY_ATTR),
                ?PRINT("gm change attr partial_power:~w expact_power: ~w~n",
                    [lib_player:calc_partial_power(OAttr, 0, AttrList),
                    lib_player:calc_expact_power(Status#player_status.original_attr, 0, AttrList)]),
                TmpStatus;
            ["speed", AttrListStr] ->
                AttrList = util:string_to_term(AttrListStr),
                BA = Status#player_status.battle_attr,
                case lists:keyfind(?SPEED, 1, AttrList) of
                    false -> Speed = BA#battle_attr.speed;
                    {?SPEED, Speed} -> ok
                end,
                NewBA = BA#battle_attr{speed = Speed},
                TmpStatus = Status#player_status{battle_attr = NewBA},
                mod_scene_agent:update(TmpStatus, [{battle_attr, TmpStatus#player_status.battle_attr}]),
                lib_player:send_attribute_change_notify(TmpStatus, ?NOTIFY_ATTR),
                TmpStatus;
            ["attr"] ->
                ?PRINT("attr ~p~n", [{Status#player_status.battle_attr#battle_attr.attr}]);
            ["printscene"] ->
                ?PRINT("scene ~p X:~p, Y:~p ~n", [Status#player_status.scene, Status#player_status.x, Status#player_status.y]);
            ["hp", _Hp] ->
                Hp = list_to_integer(_Hp),
                BA = Status#player_status.battle_attr,
                TmpStatus = Status#player_status{battle_attr = BA#battle_attr{hp=Hp}},
                mod_scene_agent:update(TmpStatus, [{battle_attr, TmpStatus#player_status.battle_attr}]),
                lib_player:send_attribute_change_notify(TmpStatus, ?NOTIFY_ATTR),
                TmpStatus;
            %% 设置开服天数
            ["opday", Day] ->
                case mod_global_counter:get_count(?MOD_BASE, 1) of
                    0 ->
                        ?ERR("GM Change Open Day>>>>>>>>>>>>>> ~p~n", [Day]),
                        Time = list_to_integer(Day),
                        Day2 = case Time > 0 of
                                   true -> Time - 1;
                                   false -> Time
                               end,
                        OpenTime = utime:unixdate() - 86400*Day2,
                        case db:get_row(io_lib:format(<<"select id from `player_login` where 1 order by `id` limit 1">>, [])) of
                            [Id] -> db:execute(io_lib:format(<<"update `player_login` set reg_time=~p WHERE `id`=~p">>, [OpenTime, Id]));
                            _ -> skip
                        end,
                        lib_server_kv:update_open_time(OpenTime),
                        pp_game:handle(10201, Status, []),
                        mod_pushmail:open_day(),
                        lib_custom_act_api:reload_custom_act_cfg(),
                        lib_recharge_act:daily_clear(0),
                        {ok, NStatus} = pp_dragon:handle(18105, Status, []),
                        mod_clusters_node:apply_cast(lib_clusters_center_api, update, [config:get_server_id(), [{open_time, OpenTime}]]),
                        mod_sea_treasure_local:server_open_day_change(OpenTime),
                        mod_decoration_boss_center:cast_center([{'sync_server_data', config:get_server_id(), OpenTime}]),
                        mod_clusters_node:apply_cast(mod_cycle_rank, gm_open_day, []),
                        notice_opday_change(),
                        handle(11100, NStatus, []);
                    _ ->
                        skip
                end;
            %% 设置合服天数
            ["mergeday", Day] ->
                Time = list_to_integer(Day),
                Day2 = case Time > 0 of
                           true -> Time - 1;
                           false -> Time
                       end,
                case Time == 0 of
                    true -> MergeTime = 0;
                    false -> MergeTime = utime:get_logic_day_start_time() - 86400*Day2
                end,
                KvR = #server_kv{key = ?SKV_MERGE_TIME, value=MergeTime, time=utime:unixtime()},
                lib_server_kv:update_server_kv(KvR),
                pp_game:handle(10201, Status, []),
                mod_pushmail:marge_day(),
                lib_custom_act_api:reload_custom_act_cfg(),
                lib_recharge_act:daily_clear(0),
                notice_mergeday_change(),
                handle(11100, Status, []);
            %% 设置合服世界等级
            ["mergewlv", _Wlv] ->
                Wlv = list_to_integer(_Wlv),
                KvR = #server_kv{key = ?SKV_MERGE_WLV, value=Wlv, time=utime:unixtime()},
                lib_server_kv:update_server_kv(KvR);
            %% 设置世界等级
            ["worldlv", _Lv] ->
                mod_global_counter:set_count(?MOD_0, ?GLOBAL_0_GM_WORLD_LV_OPEN, 0),
                Lv = list_to_integer(_Lv),
                KvR = #server_kv{key = ?SKV_WORLD_LV, value=Lv, time=utime:unixtime()},
                lib_server_kv:update_server_kv(KvR),
                mod_clusters_node:apply_cast(lib_clusters_center_api, update, [config:get_server_id(), [{world_lv, Lv}]]),
                pp_game:handle(10201, Status, []),
                mod_pushmail:open_day(),
                lib_custom_act_api:reload_custom_act_cfg(),
                lib_recharge_act:daily_clear(0),
                util:cast_event_to_players({'refresh_average_lv_20'}),
                util:cast_event_to_players({'set_data', [{world_lv, Lv}]}),
                handle(11100, Status, []),
                spawn(fun() -> timer:sleep(2000), mod_clusters_node:apply_cast(mod_zone_mgr, sync_mod_wordlv, []) end);
            ["battleattrdebug", NumberStr] ->
                Number = list_to_integer(NumberStr),
                #player_status{id = RoleId, scene = Sid, scene_pool_id = PoolId} = Status,
                case Number of
                    1->
                        case mod_scene_agent:get_player_attr(Sid, PoolId, RoleId) of
                            {ok, #battle_attr{attr = BeforeAttr}} ->
                                put(battleattrdebug, BeforeAttr);
                            _ -> ok
                        end;
                    _ ->
                        case erase(battleattrdebug) of
                            undefined -> skip;
                            BAttr ->
                                case mod_scene_agent:get_player_attr(Sid, PoolId, RoleId) of
                                    {ok, #battle_attr{attr = CAttr}} ->
                                        DiffentAttr = lists:reverse(minus_attr([CAttr, BAttr])),
                                        Msg = "属性区别：" ++ util:term_to_string(DiffentAttr),
                                        send_msg_to_chat(Status, [Msg]);
                                    _ -> ok
                                end
                        end
                end,
                ok;
            ["attrdebug", NumberStr] ->
                Number = list_to_integer(NumberStr),
                case Number of
                    1->
                        #player_status{original_attr = BeforeAttr} = Status,
                        put(attrdebug_val, BeforeAttr);
                    _ ->
                        case erase(attrdebug_val) of
                            undefined -> skip;
                            BAttr ->
                                #player_status{original_attr = CAttr} = Status,
                                DiffentAttr = lists:reverse(minus_attr([CAttr, BAttr])),
                                Msg = "属性区别：" ++ util:term_to_string(DiffentAttr),
                                send_msg_to_chat(Status, [Msg])
                        end
                end,
                ok;
            ["skilldebug", NumberStr] ->
                Number = list_to_integer(NumberStr),
                #player_status{id = RoleId, scene = Sid, scene_pool_id = PoolId} = Status,
                case Number of
                    1->
                        case mod_scene_agent:get_player_skill(Sid, PoolId, RoleId) of
                            {ok, SkillList, PassSkillList} ->
                                put(skilldebug_val, {SkillList, PassSkillList});
                            _ -> ok
                        end;
                    _ ->
                        case erase(skilldebug_val) of
                            undefined -> skip;
                            {OSkillList, OPassSkillList} ->
                                case mod_scene_agent:get_player_skill(Sid, PoolId, RoleId) of
                                    {ok, NSkillList, NPassSkillList} ->
                                        AddSkillList = (NSkillList -- OSkillList) ++ (NPassSkillList -- OPassSkillList),
                                        ReduceSkillList = (OSkillList -- NSkillList) ++ (OPassSkillList -- NPassSkillList),
                                        Msg3 = "旧技能：" ++ util:term_to_string(OSkillList),
                                        Msg4 = "旧被动技能：" ++ util:term_to_string(OPassSkillList),
                                        Msg5 = "新技能：" ++ util:term_to_string(NPassSkillList),
                                        Msg6 = "旧新被动技能：" ++ util:term_to_string(NPassSkillList),
                                        Msg1 = "新增的技能：" ++ util:term_to_string(AddSkillList),
                                        Msg2 = "减少的技能：" ++ util:term_to_string(ReduceSkillList),
                                        send_msg_to_chat(Status, [Msg3, Msg4, Msg5, Msg6, Msg1, Msg2]);
                                    _ -> ok
                                end
                        end
                end,
                ok;
            ["outputattr", TypeStr] ->
                #player_status{battle_attr=#battle_attr{attr = BattleAttr}, original_attr = OriginAttr} = Status,
                case list_to_integer(TypeStr) of
                    1 -> SumAttr = BattleAttr;
                    _ -> SumAttr = OriginAttr
                end,
                SumAttrList = lists:reverse(lib_player_attr:add_attr(list, [SumAttr])),
                case list_to_integer(TypeStr) of
                    1 -> Msg = "战斗属性：" ++ util:term_to_string(SumAttrList);
                    _ -> Msg = "基础属性：" ++ util:term_to_string(SumAttrList)
                end,
                send_msg_to_chat(Status, [Msg]);
            ["outputskill", SkillTypeStr] ->
                #player_status{skill = #status_skill{skill_list = SkillList}} = Status,
                PassSkillList = lib_skill:get_skill_passive(Status),
                Fun = fun
                    ({SKillId, SkillLv}) ->
                        #skill{career = Career} = data_skill:get(SKillId, SkillLv),
                        Career == list_to_integer(SkillTypeStr);
                    (_) -> false
                end,
                FilterSkills = lists:filter(Fun, PassSkillList ++ SkillList),
                Msg = "技能有：" ++ util:term_to_string(FilterSkills),
                send_msg_to_chat(Status, [Msg]),
                Status;
            ["timerMidNight"] ->
                timer_midnight:do_handle(?NODE_GAME),
                mod_clusters_node:apply_cast(timer_midnight, do_handle, [?NODE_CENTER]),
                Status;
            %% 设置世界等级
            ["nochangeworldlv", _Lv] ->
                Lv = list_to_integer(_Lv),
                mod_global_counter:set_count(?MOD_0, ?GLOBAL_0_GM_WORLD_LV_OPEN, Lv),
                KvR = #server_kv{key = ?SKV_WORLD_LV, value=Lv, time=utime:unixtime()},
                lib_server_kv:update_server_kv(KvR),
                mod_clusters_node:apply_cast(lib_clusters_center_api, update, [config:get_server_id(), [{world_lv, Lv}]]),
                pp_game:handle(10201, Status, []),
                mod_pushmail:open_day(),
                lib_custom_act_api:reload_custom_act_cfg(),
                lib_recharge_act:daily_clear(0),
                util:cast_event_to_players({'refresh_average_lv_20'}),
                util:cast_event_to_players({'set_data', [{world_lv, Lv}]}),
                handle(11100, Status, []);
            %% 邮件
            ["mail"] ->
                lib_mail_api:send_sys_mail([Status#player_status.id], "测试", "测试", []);
            ["mails", _N] ->
                N = list_to_integer(_N),
                F = fun(_I, Acc) ->
                    {ok, [Status#player_status.id|Acc]}
                end,
                {ok, Ids} = util:for(1, N, F, []),
                lib_mail_api:send_sys_mail(Ids, "测试", "测试", []);
            %% 邮件
            ["rewardmail", _Reward] ->
                Reward = util:string_to_term(_Reward),
                lib_mail_api:send_sys_mail([Status#player_status.id], "测试", "测试", Reward);
            ["rewardmails", _Reward, _N] ->
                Reward = util:string_to_term(_Reward),
                N = list_to_integer(_N),
                F = fun(_I, Acc) ->
                    {ok, [Status#player_status.id|Acc]}
                end,
                {ok, Ids} = util:for(1, N, F, []),
                lib_mail_api:send_sys_mail(Ids, "测试", "测试", Reward);
            ["partner", PartnerId] ->
                PartnerIdInt = list_to_integer(PartnerId),
                lib_partner_api:create_partner(Status, [PartnerIdInt]);
            ["addgfunds", _AddGfunds] ->
                mod_guild:add_gfunds(Status#player_status.id, Status#player_status.guild#status_guild.id, list_to_integer(_AddGfunds), gm);
            ["addgrowth", _Val] ->
                mod_guild:add_growth(Status#player_status.id, Status#player_status.guild#status_guild.id, list_to_integer(_Val), gm, gm);
            ["adddonate", _Val] ->
                mod_guild:add_donate(Status#player_status.id, list_to_integer(_Val), gm, gm);
            ["addprestige", _Val] ->
                mod_guild_prestige:add_prestige([Status#player_status.id, gm, ?GOODS_ID_GUILD_PRESTIGE, list_to_integer(_Val), 0]);
            ["degradeprestige", _Val] ->
                mod_guild_prestige:gm_degrade(Status#player_status.id, list_to_integer(_Val));
            ["clearprestigerecord"] ->
                mod_guild_prestige:gm_clear_record(Status#player_status.id);
            ["autoguild", _No] ->
                case list_to_integer(_No) of
                    1 -> mod_guild:auto_appoint_apprentice_to_normal(0);
                    2 -> mod_guild:auto_appoint_to_elite(0);
                    3 -> mod_guild:auto_appoint_to_leader(0);
                    _ -> skip
                end;
            ["auctionguild"] ->
                GuildId = Status#player_status.guild#status_guild.id,
                case GuildId=/=0  of
                    true ->
                        GoodsList = lib_auction_mod:get_sys_goods(urand:rand(1,2)),
                        GuildGoodsList = [{GuildId, GoodsList}],
                        lib_auction_api:start_guild_auction_gm(utime:unixtime()+5, 154, GuildGoodsList);
                    _ -> skip
                end;
            ["auctionworld"] ->
                mod_auction:start_system_auction(urand:rand(1,2));
            ["closeauction"] ->
                mod_auction:close_all_auction_gm();
            ["joinlog", _ModuleId] ->
                ModuleId = list_to_integer(_ModuleId),
                PlayerId= Status#player_status.id,
                GuildId = Status#player_status.guild#status_guild.id,
                lib_act_join_api:add_join(PlayerId, GuildId, ModuleId);
            ["checkin", _Day, _IsRetro] ->
                Day = list_to_integer(_Day),
                IsRetro = list_to_integer(_IsRetro),
                case lib_checkin:handle_cheats(Status, Day, IsRetro) of
                    {ok, NewPS} -> NewPS;
                    _ -> Status
                end;
            ["dungeon", _DunId] ->
                lib_dungeon:enter_dungeon(Status, list_to_integer(_DunId));
            ["commerce"] ->
                {_, Status1} = pp_commerce:handle(41702, Status, []),
                Status1;
            ["recharge", _ProductId] ->
                NowTime = utime:unixtime(),
                ProductId = list_to_integer(_ProductId),
                IdList = data_recharge:get_all_product_ids(),
                case lists:member(ProductId, IdList) of
                    true ->
                        #base_recharge_product{money = Money} = lib_recharge_check:get_product(ProductId),
                        #player_status{id = PlayerId, accname = AccName, figure = #figure{lv = Lv, name = Name}} = Status,

                        PayNo = mod_id_create:get_new_id(?CHARGE_PAY_NO_CREATE),
                        Sql = io_lib:format(?sql_pay_insert_gm, [1, PayNo, AccName, PlayerId, Name, ProductId, Money, Money * 10, NowTime, 0, Lv]),
                        db:execute(ulists:list_to_bin(Sql)),
                        lib_recharge_api:nofity_pay(PlayerId);
                    false -> skip
                end;
            ["eventprint"] ->
                gen_server:cast(Status#player_status.copy_id, {'event_print'});
            ["kfSellClose"] ->
                mod_sell:set_kf_status(0);
            ["duninfo"] ->
                gen_server:cast(Status#player_status.copy_id, {'get_state'});
            ["designation", DsgtId] ->
                Id = list_to_integer(DsgtId),
                lib_designation_api:active_dsgt_common(Status#player_status.id, Id);
            ["alldesignation"] ->
                DsgtList = data_designation:get_all_designation(),
                spawn(fun() ->
                    F = fun(DsgtId) ->
                        timer:sleep(100),
                        lib_designation_api:active_dsgt_common(Status#player_status.id, DsgtId)
                    end,
                    lists:foreach(F, DsgtList)
                end);
            ["dungrow", SortId] ->
                lib_dungeon_grow:gm_set_dungeon_grow(Status, list_to_integer(SortId));
            ["addreputation", _Reputation] ->
                mod_guild:add_reputation(Status#player_status.id, Status#player_status.guild#status_guild.id, list_to_integer(_Reputation), gm);
            ["openhusong"] ->
                mod_husong:gm_open();
            ["clearhusong"] ->
                mod_husong:gm_clear({Status#player_status.guild#status_guild.id});
            ["jjctimer"] ->
                mod_jjc:cast_to_jjc(refresh_reward, []);
            %% 清除个人日常
            ["cdaily"] ->
                ?ERR("CDaily_RoleId:~p~n", [Status#player_status.id]),
                mod_daily_dict:daily_clear_one(Status#player_status.id),
                mod_daily:daily_clear_role_all(Status#player_status.id, ?TWELVE),
                mod_daily:daily_clear_role_all(Status#player_status.id, ?FOUR),
                gen_server:cast(Status#player_status.pid, {'refresh_and_clear_daily', ?TWELVE}),
                gen_server:cast(Status#player_status.pid, {'refresh_and_clear_daily', ?FOUR}),
                {ok, Status1} = lib_resource_back:refresh_4_clock_res_act(Status),
                mod_scene_agent:update(Status1, [{boss_tired, 0}, {temple_boss_tired, 0}]),
                mod_scene_agent:update(Status1, [{eudemons_boss_tired, 0}]),
                Status2 = Status1#player_status{boss_tired = 0, temple_boss_tired = 0},
                Status3 = lib_local_chrono_rift_act:day_trigger(Status2),
                broadcast(Status3);
            ["wdaily"] ->
                ?ERR("WDaily_RoleId:~p~n", [Status#player_status.id]),
                mod_week:week_clear_role_all(Status#player_status.id);
            ["closedungeon"] ->
                case lib_dungeon:is_on_dungeon(Status) of
                    true -> mod_dungeon:close_dungeon(Status#player_status.copy_id);
                    false -> skip
                end;
            ["dunresult", _ResultType] ->
                #player_status{copy_id = DunPid, id = RoleId} = Status,
                case lib_dungeon:is_on_dungeon(Status) of
                    true -> mod_dungeon:gm_close_dungeon(DunPid, RoleId, list_to_integer(_ResultType));
                    false -> skip
                end;
            ["dunlevelresult", _ResultType] ->
                #player_status{copy_id = DunPid, id = RoleId} = Status,
                case lib_dungeon:is_on_dungeon(Status) of
                    true -> mod_dungeon:gm_close_dungeon_level(DunPid, RoleId, list_to_integer(_ResultType));
                    false -> skip
                end;
            ["dunevent", _BelongTypeList, _CommonEventId] ->
                #player_status{copy_id = DunPid} = Status,
                BelongTypeList = util:string_to_term(_BelongTypeList),
                case lib_dungeon:is_on_dungeon(Status) of
                    true -> mod_dungeon:gm_common_event(DunPid, BelongTypeList, list_to_integer(_CommonEventId));
                    false -> skip
                end;
            ["dunquit"] ->
                pp_dungeon:handle(61002, Status, []);
            ["dunlogout"] ->
                lib_dungeon:logout(Status);
            ["dunlogin"] ->
                lib_dungeon:reconnect(Status);
            ["guilddayclear"] ->
                mod_guild:day_clear(?TWELVE, 0),
                mod_guild:day_clear(?FOUR, 0);
            ["guildweeksalary"] ->
                mod_guild:send_week_salary_by_guild_id(Status#player_status.guild#status_guild.id);
            ["modifyannounce", AnnounceStr] ->
                lib_guild_api:modify_announce_by_gm(Status#player_status.guild#status_guild.id, AnnounceStr);
            ["modifyguildname", NameStr] ->
                lib_guild_api:modify_guild_name_by_gm(Status#player_status.guild#status_guild.id, NameStr);
            ["disbandguild"] ->
                lib_guild_api:disband_guild_by_gm(Status#player_status.guild#status_guild.id);
            ["disbandguild2", GuildId] ->
                GID = list_to_integer(GuildId),
                lib_guild_api:disband_guild_by_gm(GID);
            ["addguildliveness", _AddLiveness] ->
                mod_guild:add_liveness(Status#player_status.id, list_to_integer(_AddLiveness));
            ["guildcreatetime", _CreateTime] ->
                mod_guild:update_guild_create_time(Status#player_status.guild#status_guild.id, list_to_integer(_CreateTime));
            ["refreshmirror"] ->
                lib_player_mirror_api:timer_rank();
            ["activefashionall"] ->
                lib_fashion:active_fashion_all(Status);
            ["delmail"] ->
                db:execute(io_lib:format(<<"DELETE FROM mail_attr WHERE rid = ~p">>, [Status#player_status.id])),
                db:execute(io_lib:format(<<"DELETE FROM mail_content WHERE rid = ~p">>, [Status#player_status.id])),
                lib_mail:init_mail_dict(Status#player_status.id),
                pp_mail:handle(19001, Status, []);
            ["clearluckycat"] ->
                mod_lucky_cat:ac_custom_timer_clear();
            ["dailycount", _ModuleId, _Type, _Count] ->
                mod_daily:set_count(Status#player_status.id, list_to_integer(_ModuleId), list_to_integer(_Type), list_to_integer(_Count));
            ["firstrecharge"] ->
                mod_first_recharge:gm_first_recharge();
            ["sumrecharge"] ->
                mod_first_recharge:gm_sum_recharge();
            ["addlive", Module, ModuleSub] ->
                lib_activitycalen_api:role_success_end_activity(Status, list_to_integer(Module), list_to_integer(ModuleSub));
            ["addlive2", Num] ->
                OldLive = mod_daily:get_count(Status#player_status.id, ?MOD_ACTIVITY, ?ACTIVITY_LIVE_DAILY),
                LiveLimit = mod_daily:get_limit_by_type(?MOD_ACTIVITY, ?ACTIVITY_LIVE_DAILY),
                Add = min(list_to_integer(Num), LiveLimit - OldLive),
                lib_baby_api:add_liveness(Status#player_status.id, Add),
                mod_daily:plus_count(Status#player_status.id, ?MOD_ACTIVITY, ?ACTIVITY_LIVE_DAILY, Add),
                lib_red_envelopes_rain:add_liveness(Status#player_status.id, Add),
                lib_surprise_gift:add_liveness(Status#player_status.id, OldLive, OldLive+Add),
                mod_activity_onhook:add_activity_value(Status#player_status.id, OldLive, list_to_integer(Num)),
                lib_demons_api:add_liveness(Status#player_status.id, OldLive, OldLive+Add),
                lib_beings_gate_api:add_activity_value(Add),
                #player_status{figure = Figure} = Status,
                case  lib_custom_act_api:is_open_act(?CUSTOM_ACT_TYPE_SUPPLY, 1) andalso Figure#figure.lv >= lib_custom_act:get_open_lv(?CUSTOM_ACT_TYPE_SUPPLY) of
                    true ->
                        mod_daily:plus_count_offline(Status#player_status.id, ?MOD_AC_CUSTOM, ?CUSTOM_ACT_TYPE_SUPPLY, Add);
                    _ ->
                        skip
                end,
                {ok, Status1} = lib_liveness:add_liveness(Status, list_to_integer(Num)),
                Status1;
            ["copyscene", SceneId, ScenePoolId, CopyId] ->
                mod_scene_init:copy_a_outside_scene(list_to_integer(SceneId), list_to_integer(ScenePoolId), list_to_integer(CopyId), 1);
            ["skills"] ->
                Sql = io_lib:format(<<"delete from `skill` where id = ~p ">>, [Status#player_status.id]),
                db:execute(Sql),
                SkillStatus = lib_skill:skill_online(Status#player_status.id, Status#player_status.figure#figure.career, Status#player_status.figure#figure.lv, 0),
                Status2 = Status#player_status{ skill = SkillStatus, quickbar = []},
                {ok, Status1} = lib_skill:auto_learn_skill(Status2, login),
                {ok, BinData} = pt_130:write(13007, Status1#player_status.quickbar),
                lib_server_send:send_to_sid(Status#player_status.sid, BinData),
                pp_skill:handle(21002, Status1, []),
                Status1;
            ["beskills", SkillListStr] ->
                PassiveSkillList = util:string_to_term(SkillListStr),
                if
                    PassiveSkillList == [] ->
                        Skills = data_skill:get_ids(10,0),
                        F = fun({SkillId, SkillLv}, Index) ->
                                    Sql0 = io_lib:format(<<"replace into skill set id = ~p, skill_id = ~p, lv = ~p ">>, [Status#player_status.id, SkillId, SkillLv]),
                                    db:execute(Sql0),
                                    Index + 1
                            end,
                        lists:foldl(F, 1, Skills),
                        SkillStatus = lib_skill:skill_online(Status#player_status.id, Status#player_status.figure#figure.career, Status#player_status.figure#figure.lv, 0),
                        Status1 = lib_player:count_player_attribute(Status#player_status{ skill = SkillStatus}),
                        Status1;
                    true ->
                        #player_status{ skill = SkillStatus} = Status,
                        #status_skill{
                           skill_list = SkillList,
                           skill_passive = OPassiveSkillList
                          } = SkillStatus,
                        F = fun({SkillId, SLv}, TSkills) -> lists:keystore(SkillId, 1, TSkills, {SkillId, SLv}) end,
                        NewSkillList = lists:foldl(F, SkillList, PassiveSkillList),
                        NewPassiveSkill = lists:foldl(F, OPassiveSkillList, PassiveSkillList),
                        AttrList = lib_skill:get_passive_skill_attr(NewSkillList),
                        NewSkillStatus = SkillStatus#status_skill{skill_list = NewSkillList,
                                                                  skill_passive = NewPassiveSkill,
                                                                  skill_attr = AttrList},
                        Status11 = Status#player_status{ skill = NewSkillStatus},
                        Status1 = lib_player:count_player_attribute(Status11),
                        mod_scene_agent:update(Status1, [{passive_skill, NewPassiveSkill}]),
                        Status1
                end;
            ["cleanskills"] ->
                #player_status{ skill = SkillStatus} = Status,
                #status_skill{skill_list = SkillList} = SkillStatus,
                F = fun({SkillId, SkillLv}, TL) ->
                            case data_skill:get(SkillId, SkillLv) of
                                #skill{type = 2} ->
                                    Sql0 = io_lib:format(<<"delete from skill where id = ~p and skill_id = ~p and lv = ~p ">>, [Status#player_status.id, SkillId, SkillLv]),
                                    db:execute(Sql0),
                                    TL;
                                _ ->
                                    [{SkillId, SkillLv}|TL]
                            end
                    end,
                NewSkillList = lists:foldl(F, [], SkillList),
                {SkillAttr, SkillAttrOhter} = lib_skill:get_passive_skill_attr(NewSkillList),
                NewSkillStatus = SkillStatus#status_skill{skill_list = NewSkillList,
                                                          skill_passive = [],
                                                          skill_attr = SkillAttr,
                                                          skill_attr_other = SkillAttrOhter},
                Status11 = Status#player_status{ skill = NewSkillStatus},
                Status1 = lib_player:count_player_attribute(Status11),
                mod_scene_agent:update(Status1, [{delete_passive_skill, SkillList}]),
                %% mod_scene_agent:update(Status1, [{battle_attr, Status1#player_status.battle_attr}]),
                Status1;

            ["setskillpoint", StrPoint] ->
                #player_status{id = RoleId, sid = _Sid, skill = SkillStatus} = Status,
                NewSkillStatus = SkillStatus#status_skill{point = list_to_integer(StrPoint)},
                db:execute(io_lib:format(?sql_update_talent_skill_point, [list_to_integer(StrPoint), RoleId])),
                Status1 = Status#player_status{skill = NewSkillStatus},
                pp_skill:handle(21010, Status1, []),
                Status1;
            ["nocd", Type] ->
                mod_scene_agent:update(Status, [{nocd, list_to_integer(Type)}]),
                Status;
            ["dropclean", Type] ->
                case list_to_integer(Type) of
                    1 -> %% 个人
                        #player_status{id = RoleId, pid = Pid} = Status,
                        mod_daily_dict:daily_clear_one(RoleId),
                        mod_daily:daily_clear_role_all(RoleId, 24),
                        mod_daily:daily_clear_role_all(RoleId, 3),
                        gen_server:cast(Pid, {'refresh_and_clear_daily', 24}),
                        gen_server:cast(Pid, {'refresh_and_clear_daily', 3}),
                        Status1 = lib_resource_back:refresh_4_clock_res_act(Status),
                        mod_week:week_clear_role_all(RoleId),
                        gen_server:cast(Pid, {'refresh_and_clear_week'}),
                        Status1;
                    _ -> %% 全服
                        mod_global_counter:clean()
                end;
            ["addrunepoint", SNum] ->
                Num = list_to_integer(SNum),
                GoodsStatus = lib_goods_do:get_goods_status(),
                NewGoodsStatues = lib_rune:add_rune_point(Num, GoodsStatus),
                lib_goods_do:set_goods_status(NewGoodsStatues),
                Status;
            ["resetsomeact", TypeL, SubTypeL] ->
                Type = list_to_integer(TypeL),
                SubType = list_to_integer(SubTypeL),
                lib_custom_act_api:gm_reset_recieve_times(Status, Type, SubType);
            ["addsoulpoint", SNum] ->
                Num = list_to_integer(SNum),
                GoodsStatus = lib_goods_do:get_goods_status(),
                NewGoodsStatues = lib_soul:add_soul_point(Num, GoodsStatus),
                lib_goods_do:set_goods_status(NewGoodsStatues),
                Status;
            ["sendRumor", _ModuleId, _Id, _Msg] ->   %%发送传闻
                ModuleId = list_to_integer(_ModuleId),
                Id       = list_to_integer(_Id),
                Msg = util:string_to_term(_Msg),
                ?DEBUG("ModuleId:~p,Id:~p,Msg:~p~n", [ModuleId, Id, Msg]),
                lib_chat:send_TV({all}, ModuleId, Id, Msg),
                Status;
            ["addrunechip", SNum] ->
                Num = list_to_integer(SNum),
                GoodsStatus = lib_goods_do:get_goods_status(),
                NewGoodsStatues = lib_rune:add_rune_chip(Num, GoodsStatus),
                lib_goods_do:set_goods_status(NewGoodsStatues),
                Status;
            ["guildguard", STime] ->
                Time = list_to_integer(STime),
                mod_guild_guard:gm_start(Time),
                Status;
            ["card", StrCardNo] ->
                pp_goods:handle(15087, Status, [StrCardNo]);
            ["toppk#seasonend"] ->
                case lib_top_pk:is_local_match() of
                    true ->
                        mod_top_pk_rank:monthly_clear_ranks();
                    _ ->
                        mod_clusters_node:apply_cast(mod_top_pk_rank_kf, monthly_clear_ranks, [])
                end,
%%                mod_top_pk_rank_kf:monthly_clear_ranks(),
                lib_top_pk:gm_season_end(Status);
            ["toppk#start", TimeStr] ->
                lib_top_pk:gm_start(list_to_integer(TimeStr));
            % ["gwarconfirm"] ->
            %     mod_guild_war:gm_confirm();
            % ["gwarstart"] ->
            %     mod_guild_war:gm_start();
            % ["gwartest"] ->
            %     mod_guild_war:gm_test();
            % ["gwarreset"] ->
            %     #player_status{id = RoleId} = Status,
            %     mod_guild_war:gm_reset(RoleId);
            ["resourcebacktest"] ->
                ?ERR("gm clear resource_back!~n", []),
                lib_resource_back:refresh(0);
            ["tcheststart", StrDuration] ->
                Duration = max(60, list_to_integer(StrDuration)),
                mod_treasure_chest:gm_start(Duration);
            ["weddingstart"] ->
                #player_status{
                    id = RoleId
                } = Status,
                mod_marriage_wedding_mgr:gm_wedding_start(RoleId);
            ["enterwedding", RoleIdM] ->
                pp_marriage:handle(17263, Status, [list_to_integer(RoleIdM)]),
                Status;
            ["clearhallinformation"] ->
                mod_marriage:gm_clear_hall_information(),
                pp_marriage:handle(17200, Status, [1]),
                Status;
            ["updateweddingday", _LoveDay] ->
                #player_status{id = RoleId} = Status,
                LoveDay = list_to_integer(_LoveDay),
                mod_marriage:gm_update_wedding_day(RoleId, LoveDay);
            ["cleanringinfo"] ->
                lib_marriage:gm_clean_ring_info(Status),
                pp_marriage:handle(17210, Status, []);
            ["weddinganime"] ->
                #player_status{
                    id = RoleId
                } = Status,
                mod_marriage:gm_wedding_anime(RoleId);
            ["weddingfeast"] ->
                #player_status{
                    id = RoleId
                } = Status,
                mod_marriage:gm_wedding_feast(RoleId);
            ["weddingin", SRoleId] ->
                RoleId = list_to_integer(SRoleId),
                lib_scene:player_change_scene(Status#player_status.id, ?WeddingScene, 0, RoleId, false, []);
            ["plusstarvalue", V] ->
                Num = list_to_integer(V),
                NewPS = lib_goods_api:send_reward(Status, [{?TYPE_CURRENCY, ?GOODS_ID_STAR, Num}], gm, ""),
                NewPS;
            ["investrw", T, Id] ->
                Type = list_to_integer(T),
                RId = list_to_integer(Id),
                lib_investment:gm_get_reward(Status, Type, RId);
            ["investgettime", T, G] ->
                Type = list_to_integer(T),
                GetTime = list_to_integer(G),
                lib_investment:gm_update(Status, Type, [{get_time, GetTime}]);
            ["investloginday", T, _LoginDays] ->
                Type = list_to_integer(T),
                LoginDays = list_to_integer(_LoginDays),
                lib_investment:gm_update(Status, Type, [{login_days, LoginDays}]);
            ["sreward", List] ->
                Rewards = util:string_to_term(List),
                NewPS = lib_goods_api:send_reward(Status, Rewards, gm, "gm"),
                NewPS;
            ["costobj", List] ->
                ObjList = util:string_to_term(List),
                case lib_goods_api:cost_object_list_with_check(Status, ObjList, 0, "gm") of
                    {true, NewPS} ->
                        NewPS;
                    _ ->
                        Status
                end;
            ["startvoidfam", StrDuration] ->
                Duration = max(60, list_to_integer(StrDuration)),
                mod_void_fam_local:gm_start(Duration);
            ["configaccustom"] ->
                lib_custom_act_dynamic_compile:product_debug_ac_custom_info();
            ["customactoplist"] ->
                List = lib_custom_act_util:get_custom_act_open_list(),
                List1 = [T#act_info.key || T <- List],
                #player_status{server_num = ServerNum, c_server_msg = CServerMsg, server_id = SerId, server_name = ServerName, id = RoleId, figure = Figure} = Status,
                Msg = io_lib:format("已开启定制活动列表:~p", [List1]),
                PackData = [?CHAT_CHANNEL_WORLD, ServerNum, CServerMsg, SerId, ServerName, "", "", RoleId, Figure, Msg, util:term_to_string([]), 0, utime:unixtime()],
                {ok, BinData} = pt_110:write(11001, PackData),
                lib_server_send:send_to_all(BinData);
            ["clearactdata", Type_, SubType_] ->
                Type = list_to_integer(Type_),
                SubType = list_to_integer(SubType_),
                lib_custom_act:db_delete_custom_act_data(Type, SubType),
                spawn(fun() -> mod_login:stop_player(Status#player_status.id) end);
            ["forceendbetarecharge"] ->
                lib_beta_recharge_return:gm_force_end(Status);
            ["resetbetarecharge"] ->
                lib_beta_recharge_return:gm_reset_act(Status);
            ["reloadccustom"] ->
                lib_custom_act_api:reload_custom_act_cfg();
            ["customactwlv", Type, SubType, WLv] ->
                lib_custom_act_api:gm_change_custom_act_wlv(list_to_integer(Type), list_to_integer(SubType), list_to_integer(WLv));
            ["rushrankclear"] ->
                 mod_rush_rank:day_clear(0);
            ["localflowerrankclear", StrSubType] ->
                SubType = list_to_integer(StrSubType),
                mod_flower_act_local:send_charm_local_reward(SubType);
            ["kfflowerrankclear", StrSubType] ->
                SubType = list_to_integer(StrSubType),
                mod_clusters_node:apply_cast(mod_kf_flower_act, act_open, [SubType]),
                mod_clusters_node:apply_cast(mod_kf_flower_act, send_reward, [SubType]);
            ["kffloweradd", AddValue] ->
                lib_flower_act_api:reflash_rank_by_flower(Status, list_to_integer(AddValue));
            ["wedrankclear", StrSubType] ->
                SubType = list_to_integer(StrSubType),
                mod_flower_act_local:clear_wed_rank(SubType);
            ["commonranktitle"] ->
                mod_common_rank:day_clear(0);
            ["clearachv"] ->
                NewPlayer = lib_achievement_api:gm_reset(Status),
                NewPlayer;
            ["addhonour", _Num] ->
                Num = list_to_integer(_Num),
                lib_goods_api:send_reward_by_id([{?TYPE_HONOUR, 0, Num}], gm, Status#player_status.id);
            ["addgoods", SGoodsType, SGoodsTypeId, SNum] ->
                GoodsType = list_to_integer(SGoodsType),
                GoodsTypeId = list_to_integer(SGoodsTypeId),
                Num = list_to_integer(SNum),
                RewardList = [{GoodsType, GoodsTypeId, Num}],
                NewPlayer = lib_goods_api:send_reward(Status, RewardList, gm, 0),
                NewPlayer;
            ["addAllRune"] ->
                F = fun(SubType, Acc) ->
                        NewAcc =   data_goods_type:get_by_type(26, SubType) ++  Acc,
                        NewAcc
                    end,
                GoodsIdList = lists:foldl(F, [] ,[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,99]),
                RewardList = [{?TYPE_GOODS, GoodsTypeId, 1} || GoodsTypeId <- GoodsIdList],
%%                ?DEBUG("RewardList:~p~n", [RewardList]),
                NewPlayer = lib_goods_api:send_reward(Status, RewardList, gm, 0),
                NewPlayer;
            ["addAllSoul"] ->
                F = fun(SubType, Acc) ->
                    NewAcc =   data_goods_type:get_by_type(?GOODS_TYPE_SOUL, SubType) ++  Acc,
                    NewAcc
                    end,
                GoodsIdList = lists:foldl(F, [] ,[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,99]),
                RewardList = [{?TYPE_GOODS, GoodsTypeId, 1} || GoodsTypeId <- GoodsIdList],
                NewPlayer = lib_goods_api:send_reward(Status, RewardList, gm, 0),
                NewPlayer;
            %% ["starttracer"] ->
            %%     ttb:tracer(all),
            %%     ttb:p(self(), call),
            %%     ttb:tp(mod_server, handle_call, ttb:seq_trigger_ms()),
            %%     Status;
            %% ["stoptracer"] ->
            %%     seq_trace:reset_trace(),
            %%     ttb:stop([fetch]),
            %%     Status;
            ["setjjcnum", Num] ->
                mod_jjc_cast:plus_challenge_num(Status#player_status.id, list_to_integer(Num)),
                pp_jjc:handle(28001, Status, []),
                Status;
            ["buydun", DunIdS, NumS] ->
                DunId = list_to_integer(DunIdS),
                Num = list_to_integer(NumS),
                case data_dungeon:get(DunId) of
                    #dungeon{type = DunType} ->
                        CountType = lib_dungeon_api:get_daily_buy_type(DunType, DunId),
                        mod_daily:plus_count(Status#player_status.id, ?MOD_DUNGEON, ?MOD_DUNGEON_BUY, CountType, Num);
                    _ ->
                        ok
                end;
            ["ghost", Ghost] ->
                mod_server_cast:set_data_sub([{ghost, list_to_integer(Ghost)}], Status);
            ["clearmail"] ->
                lib_mail:clean_mail();
            %% 随机穿时装
            ["randfashion"] ->
                PosList = data_fashion:get_pos_id_list(),
                F = fun(PosId, TmpStatus) ->
                    case data_fashion:get_pos_fashion_list(PosId) of
                        FashionIds when FashionIds =/= [] ->
                            FashionId = urand:list_rand([0|FashionIds]),
                            case FashionId > 0 of
                                true ->
                                    {ok, NewTmpStatus} = pp_fashion:handle(41302, TmpStatus, [PosId, FashionId, 0]),
                                    NewTmpStatus;
                                false -> TmpStatus
                            end;
                        _ -> TmpStatus
                    end
                end,
                lists:foldl(F, Status, PosList);
            ["addbuff", SkillId] ->
                ?PRINT("????? ~p~n", [SkillId]),
                lib_goods_buff:add_skill_buff(Status, list_to_integer(SkillId), 1);
            ["rmbuff", SkillId] ->
                lib_goods_buff:remove_skill_buff(Status, list_to_integer(SkillId));
            ["rmbuff2", BuffType] ->
                lib_goods_buff:remove_goods_buff_by_type(Status, list_to_integer(BuffType));
            ["act19", TimeStr] ->
                mod_eudemons_attack:gm_start(list_to_integer(TimeStr));
            ["addhipoints", NumS] ->
                Num = list_to_integer(NumS),
                lib_hi_point_api:gm_add_points(Num, Status);
            ["runereset"] ->
                lib_dungeon_rune:gm_reset_rune2(Status);
            %% 一键加好友，不需要对方同意
            ["onetouchfriend", NumStr] ->
                #player_status{id = RoleId} = Status,
                Num = list_to_integer(NumStr),
                NowTime = utime:unixtime(),
                List = db:get_all(io_lib:format(<<"select id from player_low where id != ~p and lv >= 120">>, [RoleId])),
                F = fun([TId], Acc) when Acc < Num ->
                    case db:get_row(io_lib:format(<<"select rela_type from relationship where role_id = ~p and other_rid = ~p">>, [RoleId, TId])) of
                        [A2BRelaType] -> skip;
                        _ -> A2BRelaType = ?RELA_TYPE_NONE
                    end,
                    case db:get_row(io_lib:format(<<"select rela_type from relationship where role_id = ~p and other_rid = ~p">>, [TId, RoleId])) of
                        [B2ARelaType] -> skip;
                        _ -> B2ARelaType = ?RELA_TYPE_NONE
                    end,
                    InBlackL = case lists:member(A2BRelaType, ?RELA_BLACK_TYPES) of
                        false ->
                            lists:member(B2ARelaType, ?RELA_BLACK_TYPES);
                        true -> true
                    end,
                    InFriendL = case lists:member(A2BRelaType, ?RELA_FRIEND_TYPES) of
                        false ->
                            lists:member(B2ARelaType, ?RELA_FRIEND_TYPES);
                        true -> true
                    end,
                    case not InBlackL andalso not InFriendL of
                        true ->
                            NewA2BRelaType = lib_relationship:rela_type_change(A2BRelaType, ?RELA_TYPE_FRIEND, add_friend),
                            NewB2ARelaType = lib_relationship:rela_type_change(B2ARelaType, ?RELA_TYPE_FRIEND, add_friend),
                            db:execute(io_lib:format(?sql_save_role_rela, [RoleId, TId, NewA2BRelaType, 0, 0, NowTime])),
                            db:execute(io_lib:format(?sql_save_role_rela, [TId, RoleId, NewB2ARelaType, 0, 0, NowTime])),
                            Acc + 1;
                        _ -> Acc
                    end;
                    (_, Acc) -> Acc
                end,
                F1 = fun() ->
                    lists:foldl(F, 0, List),
                    ok
                end,
                case catch db:transaction(F1) of
                    Res when Res == ok ->
                        Res + 1;
                    _Err ->
                        ?ERR(">>>>>>>>>>:~p", [_Err]),
                        Status
                end;
            ["payment", Order] ->
                case Order of
                    "1" ->
                        case lib_consume_data:advance_cost_objects(Status, [{0, 18010003, 1}], buy_goods, "18010003", true) of
                            {true, Status1, Ref} ->
                                put("payment_test", Ref),
                                Status1;
                            _ ->
                                ok
                        end;
                    "2" ->
                        Ref = get("payment_test"),
                        lib_consume_data:advance_payment_done(Status#player_status.id, Ref);
                    "3" ->
                        Ref = get("payment_test"),
                        lib_consume_data:advance_payment_fail(Status#player_status.id, Ref, []);
                    _ ->
                        ok
                end;
            ["sdl#next"] ->
                mod_clusters_node:apply_cast(mod_diamond_league_schedule, gm_next, []);
            ["sdl#applyall"] ->
                mod_clusters_node:apply_cast(lib_diamond_league_apply, gm_apply_all, []);
            ["bossinit"]->
                mod_boss:refresh_killed_boss(gm),
                if
                    Status#player_status.scene == 34100 ->
                        mod_special_boss:gm_refresh_boss(Status#player_status.id, 13);
                    true ->
                        skip
                end,
                Status;
            ["wldbossinit"] ->
                mod_boss:gm_wldboss_init(),
                Status;
            ["clearcollect", Value] ->
                Type = list_to_integer(Value),
                lib_collect:clear_collect_gm(Type);
            ["clearrechargerank"] ->
                mod_consume_rank_act:clear_recharge_rank_act(0,1);
            ["changesource"|SpiltSource] ->
                Source = string:join(SpiltSource, "_"),
                Status#player_status{source = Source};
            ["3v3", LastTime] ->
                mod_clusters_node:apply_cast(mod_3v3_center, gm_start_3v3_2, [list_to_integer(LastTime)]);
            ["3v3timemb", LastTime, LimitMember] ->
                mod_clusters_node:apply_cast(mod_3v3_center, gm_start_3v3, [list_to_integer(LastTime), list_to_integer(LimitMember)]);
            ["3v3mb", LimitMember] ->
                mod_clusters_node:apply_cast(mod_3v3_center, gm_set_member_limit, [list_to_integer(LimitMember)]);
            ["gmcloudbuyaward", SNode] ->
                Node = list_to_integer(SNode),
                mod_cloud_buy_mgr:gm_award(Node),
                Status;
            ["restartcloudbuy"] ->
                mod_cloud_buy_mgr:gm_restart(),
                Status;
            ["reloadguess"] ->
                spawn(fun() ->
                    lib_php_api:reload_guess()
                end),
                Status;
            ["guessfile"] ->
                {_FileName, Cfg} = lib_dynamic_compile:init_cfg(2),
                ?INFO("~s ~n", [Cfg]),
                Status;
            ["1vn1", SignTimeStr, PreTimeStr, RaceTimeStr] ->
                mod_kf_1vN_local:gm_start_1(list_to_integer(SignTimeStr), list_to_integer(PreTimeStr), list_to_integer(RaceTimeStr));
            ["1vn2", PreTimeStr, RaceTimeStr] ->
                mod_kf_1vN_local:gm_start_2(list_to_integer(PreTimeStr), list_to_integer(RaceTimeStr));
            ["gmOpenNG"] ->
                mod_night_ghost_local:gm_act_start();
            ["gmCloseNG"] ->
                mod_night_ghost_local:gm_act_end();
            ["gmtenum", SRoleId, SLuckyNum, SSubType] ->
                RoleId = list_to_integer(SRoleId),
                LuckyNum = list_to_integer(SLuckyNum),
                SubType = list_to_integer(SSubType),
                lib_treasure_evaluation:gm_te_lucky_num(RoleId, LuckyNum, SubType);
            ["houseinsidesql"] ->
                mod_house:gm_reflesh_inside_sql();
            ["kfgwarnext"] ->
                mod_clusters_node:apply_cast(mod_kf_guild_war, gm_next, []),
                Status;
            % ["clearkfgwarguildinfo"] ->
            %     mod_clusters_node:apply_cast(mod_kf_guild_war, clear_guild_info, [Status#player_status.guild#status_guild.id]),
            %     Status;
            ["resetkfgwarseason"] ->
                mod_clusters_node:apply_cast(mod_kf_guild_war, reset_season, []),
                Status;
            ["activemonpic", _PicId] ->
                PicId = list_to_integer(_PicId),
                lib_mon_pic:gm_active(Status, PicId);
            ["awakening"] ->
                lib_task_api:awakening(Status#player_status.id, Status#player_status.figure#figure.lv);
            ["successActivity", _ActId,  _SubId, _Times] ->
                ActId = list_to_integer(_ActId),
                SubId = list_to_integer(_SubId),
                Times = list_to_integer(_Times),
                lib_activitycalen_api:role_success_end_activity(Status, ActId, SubId, Times);
            ["completeachv", _Category] ->
                CategoryId = list_to_integer(_Category),
                lib_achievement:gm_complete_achv(Status, CategoryId);
            ["rank", _RankType] ->
                lib_common_rank_api:refresh_common_rank(Status, list_to_integer(_RankType));
            ["startguildbattle"] ->
                mod_guild_battle:gm_start_tip(),
                Status;
            ["endguildbattle"] ->
                mod_guild_battle:gm_end_tip(),
                Status;
            ["nine", Time] ->
                mod_nine_local:gm_act_start(list_to_integer(Time)+utime:unixtime());
            ["ninemod"] ->
                mod_nine_local:gm_single_mod(),
                Status;
            ["ninePartition"] ->
                mod_nine_center:gm_partition(),
                Status;
            ["nineend"] ->
                mod_nine_center:gm_act_end(),
                mod_nine_local:gm_act_end();
            ["beingsgatestart", Time] ->
                mod_beings_gate_local:gm_act_start(list_to_integer(Time) + utime:unixtime());
            ["beingsgateend"] ->
                catch whereis(mod_beings_gate_local) ! {'apply', act_end},
                Pid = mod_clusters_node:apply_call(erlang, whereis, [mod_beings_gate_kf]),
                catch mod_clusters_node:apply_call(erlang, send, [Pid, {'apply', act_end}]),
                ok;
            ["clearlive"] ->
                mod_beings_gate_local:gm_clear_activity();
            ["guildFeastOpen"] ->
                mod_guild_feast_mgr:gm_open();
            ["guildFeastClose"] ->
                mod_guild_feast_mgr:gm_close();
            ["guildFeastGameType", GameIdStr] ->
                GameId = list_to_integer(GameIdStr),
                mod_guild_feast_mgr:gm_set_game_type(GameId);
            ["nineenter", _LayerId] ->
                lib_nine:apply_war(Status, list_to_integer(_LayerId));
            ["guilddunset", _ChallengeTimes, _Level, _NotifyTimes] ->
                mod_guild_dun_mgr:apply_cast({mod, gm_set_role_data, [Status#player_status.id, list_to_integer(_ChallengeTimes), list_to_integer(_Level), list_to_integer(_NotifyTimes)]});
            ["loginRewardReSet", _Day] ->
                lib_login_reward:reset(Status, list_to_integer(_Day));
            ["loginMergeRewardReSet", _Day] ->
                lib_login_reward_merge:reset(Status, list_to_integer(_Day));
            ["checkinReset"] ->
                lib_checkin:gm_refresh_state(Status);
            ["onlinetimeReset"] ->
                lib_online_reward:gm_clean_time(Status);
            ["LimitShopSellReset"] ->
                lib_limit_shop:gm_reset(Status);
            ["LimitShopSellReset1", _Num] ->
                lib_limit_shop:gm_reset_not_buy(list_to_integer(_Num), Status#player_status.id);
            ["clearbossratio"] ->
                db:execute(io_lib:format(<<"delete from role_drop_ratio where role_id = ~p">>, [Status#player_status.id])),
                Status#player_status{drop_ratio_map = #{}};
            ["valleyskill"] ->
                F = fun(Chapter, TmpPlayer) ->
                    {ok, TmpPlayer2} = lib_skill:auto_learn_skill(TmpPlayer, {eternal_valley, Chapter}),
                    TmpPlayer2
                end,
                lists:foldl(F, Status, lists:seq(1, 6));
            ["checkinSetDay", Flag, Num] ->
                lib_checkin:gm_set_player_regtime(Status, list_to_integer(Flag), list_to_integer(Num));
            ["clearyhbg"] ->
                lib_eternal_valley:gm_reset(Status);
            ["valleyopen",Chapt] ->
                Chapter = list_to_integer(Chapt),
                lib_eternal_valley:gm_complete_chapter(Status, Chapter);
            ["inviteclear"] ->
                lib_invite:gm_clear_daily_and_cd(Status);
            ["battle"] ->
                lib_player:battle(Status);
            ["fakeactivity", JoinNum, Module, SubModule] ->
                lib_nine_api:gm_fake_join_nine(list_to_integer(JoinNum), list_to_integer(Module), list_to_integer(SubModule)),
                Status;
            %% 坐骑升阶
            ["addlvmount", _TypeId, _Stage, _Star] ->
                TypeId = list_to_integer(_TypeId),
                Stage = list_to_integer(_Stage),
                Star = list_to_integer(_Star),
                #player_status{id = RoleId, status_mount = _StatusMount, figure = Figure} = Status,
                StageCfg = data_mount:get_stage_cfg(TypeId, Stage, Figure#figure.career),
                case StageCfg of
                    [] ->
                        skip;
                    _ ->
                        {ok, NewStatus0} = lib_mount:do_upgrade_star(Status, TypeId, Stage, Star, ?MAX_GOODS_EXP, 0, [], [], 0),
                        #player_status{status_mount = NewStatusMount} = NewStatus0,
                        #status_mount{stage = NewStage, star = NewStar, blessing = NewBlessing, etime = Etime} = lists:keyfind(TypeId, #status_mount.type_id, NewStatusMount),
                        {ok, BinData} = pt_160:write(16023, [?SUCCESS, TypeId, NewStage, NewStar, NewBlessing, 0, Etime, ?AUTOBUY, []]),
                        lib_server_send:send_to_sid(Status#player_status.sid, BinData),
                        pp_mount:handle(16002, NewStatus0, [TypeId]),
                        NewStatus0
                end;
            ["guardexpired", _TypeId] ->
                TypeId = list_to_integer(_TypeId),
                lib_magic_circle:time_out(Status, TypeId);
            ["freeexperience", _TypeId] ->
                TypeId = list_to_integer(_TypeId),
                lib_magic_circle_api:free_experience(Status, TypeId);
            ["clinvite"] ->
                lib_invite:gm_clinvite(Status);
            ["uploadnewinivtee", InviteIdStr] ->
                InviteId = list_to_integer(InviteIdStr),
                lib_invite_api:upload_new_inivtee(Status, InviteId),
                lib_invite_api:request_update_invite_state(InviteId),
                mod_invite:set_new_inivtee(Status#player_status.id);
            ["clearshake", StrSubType] ->
                SubType = list_to_integer(StrSubType),
                lib_shake:db_shake_delete(Status#player_status.id, SubType),
                #player_status{status_shake = StShake} = Status,
                #status_shake{shake = Shake} = StShake,
                NewShake = maps:put(SubType, #shake{draw_times = 0,shake_record = [],time = 0}, Shake),
                NewStatuShake = StShake#status_shake{shake = NewShake},
                NewStatu = Status#player_status{status_shake = NewStatuShake},
                pp_custom_act:handle(33187, NewStatu, [?CUSTOM_ACT_TYPE_SHAKE, SubType]),
                NewStatu;
            ["clearbonustree", Type, StrSubType] ->
                SubType = list_to_integer(StrSubType),
                {ok, NewPS} = lib_bonus_tree:reset_status(Status, list_to_integer(Type), SubType),
                NewPS;
            ["setMainDungeon", _Gate] ->
                Gate = list_to_integer(_Gate),
                NewPs = lib_enchantment_guard:gm_set_gate(Status, Gate),
                NewPs;
            ["feastbossreset"] ->
                mod_boss:gm_feast_boss_reset(Status#player_status.id);
            ["feastbossclose"] ->
                mod_boss:feast_boss_act_end();
            ["enveloperebate"] ->
                lib_envelope_rebate:gm_finish_all(Status);
            ["startredrain", _Subtype] ->
                mod_red_envelopes_rain:gm_start_red_rain(list_to_integer(_Subtype));
            ["setTowerDun", _Gate] ->
                Gate = list_to_integer(_Gate),
                NewPs = lib_dungeon_tower:gm_set_gate(Status, ?DUNGEON_TYPE_TOWER, Gate),
                NewPs;
            ["setRune2Dun", _Gate] ->
                Gate = list_to_integer(_Gate),
                NewPs = lib_dungeon_tower:gm_set_gate(Status, ?DUNGEON_TYPE_RUNE2, Gate),
                NewPs;
            ["moninvade"] ->
                Ids = data_dungeon:get_ids_by_type(?DUNGEON_TYPE_MON_INVADE),
                Fun = fun(DunId, PS) ->
                    NewPS = lib_dungeon_mon_invade:gm_refresh(PS, DunId),
                    NewPS
                end,
                lists:foldl(Fun, Status, Ids);
            ["moninvadeValue", Value] ->
                Ids = data_dungeon:get_ids_by_type(?DUNGEON_TYPE_MON_INVADE),
                Fun = fun(DunId, PS) ->
                    NewPS = lib_dungeon_mon_invade:gm_set_value(PS, DunId, list_to_integer(Value)),
                    NewPS
                end,
                lists:foldl(Fun, Status, Ids);
            ["startdrum",Time] ->
                mod_drumwar_mgr:gm_start(list_to_integer(Time)),
                Status;  %%
            ["drumrank"] ->
                mod_drumwar_mgr:cast_center([{gm_startrank}]),
                Status;  %%
            ["attrMedicament"] ->
                lib_attr_medicament:timer_0_clock();
            ["cleararbitramentloop"] ->
                lib_arbitrament:gm_clear_loop(Status);
            ["gladst", Type, Time] ->
                mod_glad_local:gm_act_start(list_to_integer(Type), list_to_integer(Time)+utime:unixtime());
            ["gladend"] ->
                mod_glad_local:gm_act_end();
            ["bosstask", BossType, BossLv, Count] ->
                spawn(fun() ->
                    F = fun(_No) ->
                        lib_task_api:kill_boss(Status#player_status.id, list_to_integer(BossType), list_to_integer(BossLv)),
                        timer:sleep(100)
                    end,
                    lists:foreach(F, lists:seq(1, list_to_integer(Count)))
                end);
            ["addTopHonor", _Num] ->
                Num = list_to_integer(_Num),
                lib_goods_api:send_reward_with_mail(Status#player_status.id,
                    #produce{reward = [{?TYPE_CURRENCY, ?GOODS_ID_TOP_HONOR, Num}], type = gm});
            ["topPkSetRankLv", _RankLv] ->
                RankLv = list_to_integer(_RankLv),
                lib_top_pk:gm_set_rank_lv(Status, RankLv);
            ["topPkSetMatch", _Count] ->
                Count = list_to_integer(_Count),
                #player_status{top_pk = Top} = Status,
                NewTop = Top#top_pk_status{season_match_count = Count},
                lib_top_pk:update_status(Status#player_status.id, NewTop),
                Status#player_status{top_pk = NewTop};
            ["topPkYesterdayRankLv"] ->
                lib_top_pk:update_yesterday_rank_lv();
            ["setonhooktime", Ss] ->
                #player_status{onhook = Onhook} = Status,
                NewOnhook = Onhook#status_onhook{
                    onhook_time = list_to_integer(Ss) ,
                    exp = 0,
                    pet_exp = 0,
                    cost_onhook_time = 0,
                    auto_devour_equips = 0,
                    auto_pickup_goods = [],
                    revive_data = []
                },
                Status#player_status{onhook = NewOnhook};
            %% 快捷挂机
            ["fastonhook"] -> %% 机器人专业
                %% 离线挂机等级定为X级，不够X级自动升到X级，超过X级无视
                OnhookLv = urand:rand(136, 168),
                Figure = Status#player_status.figure,
                case Status#player_status.figure#figure.lv < OnhookLv of
                    true ->
                        UpExpStatus = lib_player:add_exp(Status#player_status{exp = 0, figure = Figure#figure{lv = OnhookLv}}, 1, ?ADD_EXP_GM, []),
                        RealAddLv = 2,
                        F = fun(_, TmpStatus) ->
                            Exp = max(0, data_exp:get(TmpStatus#player_status.figure#figure.lv) - TmpStatus#player_status.exp),
                            TmpUpExpStatus = lib_player:add_exp(TmpStatus, Exp, ?ADD_EXP_GM, []),
                            {ok, TmpUpExpStatus}
                        end,
                        {ok, UpLvStatus} = util:for(UpExpStatus#player_status.figure#figure.lv, min(999999,UpExpStatus#player_status.figure#figure.lv+RealAddLv-1), F, UpExpStatus);
                    _ -> UpLvStatus = Status
                end,
                %% 设置金钱
                Money = 100000,
                db:execute(io_lib:format(<<"update `player_high` set coin = ~p, gcoin = ~p, bgold = ~p, gold = ~p where id=~p">>,
                                         [Money, Money, Money, Money, Status#player_status.id])),
                StatusMoney =  UpLvStatus#player_status{gold = Money, bgold = Money, coin = Money, gcoin = Money},
                %% 设置挂机时间
                #player_status{onhook = Onhook} = StatusMoney,
                OnhookTime = 86400 * 4,
                NewOnhook = Onhook#status_onhook{
                    onhook_time = OnhookTime,
                    exp = 0,
                    pet_exp = 0,
                    cost_onhook_time = 0,
                    auto_devour_equips = 0,
                    auto_pickup_goods = [],
                    revive_data = []
                },
                db:execute(io_lib:format(?SQL_ROLE_ONHOOK_UPDATE_TIME, [OnhookTime, Status#player_status.id])),
                %% 设置自动买活
                case pp_onhook:handle(13201, StatusMoney#player_status{onhook = NewOnhook}, [?AUTO_REVIVE, 1]) of
                    {ok, OnhookStatus} -> OnhookStatus;
                    _ -> StatusMoney
                end;
            ["setonhookdata"] ->
                F = fun() ->
                    SQL1 = <<"update role_onhook set onhook_time = 86400, onhook_setting = '[{1,0},{2,1},{3,1},{4,1},{5,1},{6,1},{7,1},{8,1},{9,1}]'">>,
                    db:execute(SQL1),
                    SQL2 = <<"update player_high set exp = 100">>,
                    db:execute(SQL2)
                end,
                db:transaction(F),
                AllIds = db:get_all(<<"select id from player_high">>),
                F1 = fun(RId) ->
                    RandLv = urand:rand(135, 230),
                    SQL3 = <<"update player_low set lv = ~p where id = ~w">>,
                    db:execute(io_lib:format(SQL3, [RandLv, RId]))
                end,
                [F1(RId) || [RId] <- AllIds],
                Status;
            ["setonhookoff"] ->
                F = fun() ->
                    SQL1 = <<"update role_onhook set onhook_time = 0">>,
                    db:execute(SQL1),
                    SQL2 = <<"update player_high set exp = 100">>,
                    db:execute(SQL2)
                end,
                db:transaction(F),
                Status;
            ["onhookexptime", _Count] ->
                NowTime = utime:unixtime(),
                Count = list_to_integer(_Count),
                F = fun(Seq) -> {NowTime - Seq*3600, 1000} end,
                ExpList = lists:map(F, lists:reverse(lists:seq(1, Count))),
                #player_status{onhook = OnHookStatus} = Status,
                NewOnHook = OnHookStatus#status_onhook{exp_list = ExpList, get_count = 0},
                Status#player_status{onhook = NewOnHook};
            ["onhookoffexp", RedemptionExp, RedemptionGold] ->
                #player_status{onhook = OnHookStatus} = Status,
                NewOnHook = OnHookStatus#status_onhook{redemption_exp = list_to_integer(RedemptionExp), redemption_gold = list_to_integer(RedemptionGold)},
                Status#player_status{onhook = NewOnHook};
            ["hjh"] ->
                % ?PRINT("skill:~p ~n", [lib_skill:get_talent_extra_attr(Player, ModKey)]),
                lib_onhook:onhook_auto_devour_equips(Status);
            % ["sceneother"] ->
            %     misc:is_process_alive(misc:get_player_process(4294967303)),
            ["robotchat", _Type] ->
                {ok, BinData} = pt_110:write(11064, [list_to_integer(_Type)]),
                lib_server_send:send_to_sid(Status#player_status.sid, BinData);
            ["checkcustom"] ->
                List = [{Type, SubType} || #act_info{key = {Type, SubType}}<-lib_custom_act_util:get_custom_act_open_list()],
                ListStr = util:term_to_string(List),
                MsgSend = lists:concat(["checkcustom:", ListStr]),
                lib_chat:gm_send_to_all(Status, MsgSend);
            ["caliveness", _Type, _SubType, Count] ->
                Type = list_to_integer(_Type), SubType = list_to_integer(_SubType),
                mod_custom_act_liveness:add_commit_count(Type, SubType, list_to_integer(Count)),
                pp_custom_act:handle(33193, Status, [Type, SubType]),
                pp_custom_act:handle(33104, Status, [Type, SubType]),
                Status;
            ["mondrop", MonId] ->
                #player_status{
                    scene = SceneId, scene_pool_id = ScenePoolId, copy_id = CopyId, x = X, y = Y, pid = Pid, id = RoleId,
                    server_num = ServerNum, server_id = ServerId, team = #status_team{team_id = TeamId},
                    figure = #figure{lv = Lv, name = Name}, server_name = ServerName
                    } = Status,
                case data_mon:get(list_to_integer(MonId)) of
                    #mon{} = M ->
                        FirstAttr = #mon_atter{
                            id = RoleId, pid = Pid, node = node(),
                            server_id = ServerId, team_id = TeamId, hurt = 10000, att_sign = ?BATTLE_SIGN_PLAYER, att_lv = Lv,
                            name = Name, server_num = ServerNum, world_lv = util:get_world_lv(), server_name = ServerName,
                            mod_level = lib_scene:get_mod_level(Status)},
                        MonStatus = lib_mon_util:base_to_cache([0, SceneId, ScenePoolId, X, Y, 0, CopyId, CopyId], M),
                        lib_goods_drop:mon_drop(node(), RoleId, MonStatus, [FirstAttr], FirstAttr);
                    _ ->
                        skip
                end;
            ["sealequip", _Stage, _Color] ->
                Stage = list_to_integer(_Stage),
                Color = list_to_integer(_Color),
                lib_seal:gm_add_equip(Status, Stage, Color);
            ["draconicequip", _Stage, _Color] ->
                Stage = list_to_integer(_Stage),
                Color = list_to_integer(_Color),
                lib_draconic:gm_add_equip(Status, Stage, Color);
            ["cleanliveness", _Type, _SubType] ->
                Type = list_to_integer(_Type), SubType = list_to_integer(_SubType),
                lib_custom_act_liveness:gm_clean(Type, SubType),
                pp_custom_act:handle(33193, Status, [Type, SubType]),
                pp_custom_act:handle(33104, Status, [Type, SubType]),
                Status;
            ["cleanroleliveness", _Type, _SubType] ->
                Type = list_to_integer(_Type), SubType = list_to_integer(_SubType),
                Status0 = lib_custom_act_liveness:gm_clean_role(Status, Type, SubType),
                pp_custom_act:handle(33193, Status0, [Type, SubType]),
                pp_custom_act:handle(33104, Status0, [Type, SubType]),
                Status0;
            ["cleanUpPowerRank", _SubType] ->
                SubType = list_to_integer(_SubType),
                mod_up_power_rank:act_end(SubType),
                Status;
            ["gmresetmod"] ->
                mod_clusters_node:apply_call(mod_zone_mod, gm_reset, []),
                ok;
            ["refreshmon"] ->
                lib_territory_treasure:gm_start(Status);
                % mod_territory_treasure:start_act();
            ["sanctuaryStart", _Time] ->
                Time = list_to_integer(_Time),
                mod_sanctuary:gm_start(Time);
            ["sanctuarySettlement"] ->
                mod_sanctuary:gm_settlement();
            ["addweddingtimes", WeddingType] ->
                mod_marriage:gm_add_wedding_times(Status#player_status.id, list_to_integer(WeddingType));
            ["sanctuaryClear"] ->
                lib_sanctuary:day_clear();
            ["sethuntfreetime", _HType, _Time] ->
                HType = list_to_integer(_HType),
                Time = list_to_integer(_Time),
                mod_treasure_hunt:gm_set_free_time(HType, Time);
            ["sancturyUpdateDesignation"] ->
                lib_sanctuary:update_sanctuary_designation();
            ["kfsanctuarymon"] ->
                mod_sanctuary_cluster_mgr:gm_start_act();
            ["setluckeyvalue", _HType, _Val] ->
                Value = list_to_integer(_Val),
                HType = list_to_integer(_HType),
                mod_treasure_hunt:gm_set_luckey_value(HType, Value);
            ["nearestmon"] ->
                #player_status{id = RoleId, scene=Scene, scene_pool_id=ScenePoolId, copy_id=CopyId, x = X, y = Y} = Status,
                mod_scene_agent:apply_cast(Scene, ScenePoolId, lib_scene, gm_find_nearest_mon_auto_id, [node(), RoleId, CopyId, X, Y]);
            ["rmcustomactrecord", _Type, _SubType] ->
                Type = list_to_integer(_Type), SubType = list_to_integer(_SubType),
                mod_custom_act_record:cast({remove_log, Type, SubType});
            ["gmsetrolescore", _Score] ->
                #player_status{id = RoleId} = Status,
                Score = list_to_integer(_Score),
                lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_sanctuary_cluster, gm_add_score, [Score]),
                Status;
            ["addSanctuaryTried", _Tried] ->
                #player_status{id = RoleId} = Status,
                Tried = list_to_integer(_Tried),
                mod_daily:plus_count_offline(RoleId, ?MOD_SANCTUARY, 3, Tried),
                %% 通知客户端疲劳值
                BossTired = mod_daily:get_count_offline(RoleId, ?MOD_SANCTUARY, 3),
                {ok, Bin} = pt_283:write(28318, [BossTired]),
                {ok, Bin1} = pt_283:write(28319,[Tried]),
                lib_server_send:send_to_uid(RoleId, Bin),
                lib_server_send:send_to_uid(RoleId, Bin1),
                lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, lib_boss, try_to_updata_senen_data, [14]);
            ["team"] ->
                #player_status{team = #status_team{team_id = TeamId} = Team} = Status,
                lib_chat:gm_send_to_all(Status, lists:concat(["TeamId:", TeamId, "Team:", util:term_to_string(Team)]));
            ["middayPartyStart"] ->
                mod_midday_party:act_start();
            ["middayPartyEnd"] ->
                mod_midday_party:act_end();
            ["middayPartyNum", _Num] ->
                Num = list_to_integer(_Num),
                mod_midday_party:gm_copy_num(Num);
            ["topPKSendMail"] ->
                lib_top_pk:gm_send_mail();
            ["investshow"] ->
                List = lib_investment:handle_invest_show(Status),
                lib_chat:gm_send_to_all(Status, lists:concat(["investshow  List:", util:term_to_string(List)]));
            ["logout"] ->
                spawn(fun() -> mod_login:stop_player(Status#player_status.id) end);
            ["replaceequip"] ->
                lib_eudemons:gm_repalce_equip();
            ["deleteinvest", Type] ->
                lib_investment:gm_delete_investment(Status, list_to_integer(Type));
            ["compensate", CostOnhookTime, Exp] ->
                {ok, Status0} = lib_compensate_exp:compensate(Status, list_to_integer(CostOnhookTime), list_to_integer(Exp)),
                Status0;
            ["adddragonequip"] ->
                lib_dragon_api:gm_add_dragon_equip(Status),
                Status;
            ["addkfSanctuaryTried", _AddTired] ->
                Tried = list_to_integer(_AddTired),
                lib_sanctuary_cluster:set_role_anger(Status, Tried);
            ["clearactdrop", Type, SubType] ->
                lib_custom_act_api:gm_clear_act_drop(list_to_integer(Type), list_to_integer(SubType));
            ["printclearactdrop"] ->
                #player_status{custom_drop = CustomDropMap} = Status,
                lib_chat:gm_send_to_all(Status, util:term_to_string(CustomDropMap));
            ["gmUpdateTopPk"] ->
                lib_top_pk:gm_update_rank_server_id();
            ["resetbonusdraw"] ->
                TemStatus = lib_bonus_draw:gm_reset_bonus_draw(Status),
                TemStatus;
            ["luckyturntable", Type, SubType] ->
                lib_lucky_turntable:gm_reset(Status, list_to_integer(Type), list_to_integer(SubType));
            ["babytask", TaskId, Num] ->
                lib_baby_api:trigger_task(Status, list_to_integer(TaskId), list_to_integer(Num));
            ["addbabyraise", Num] ->
                {ok, TemStatus} = lib_baby:add_raise_exp(Status, list_to_integer(Num), [999]),
                pp_baby:handle(18203, TemStatus, []),
                TemStatus;
            ["resetbaby"] ->
                mod_baby_mgr:daily_clear();
            ["setwavebonusdraw", Type, SubType, Wave] ->
                TemStatus = lib_bonus_draw:gm_set_wave(Status, list_to_integer(Type), list_to_integer(SubType), list_to_integer(Wave)),
                TemStatus;
            ["resetgodlevel"] ->
                TemStatus = lib_god_equip:gm_reset_god_level(Status),
                TemStatus;
            ["delfestinvest", Type, SubType, Lv] ->
                lib_festival_investment:gm_delete_investment(Status, list_to_integer(Type), list_to_integer(SubType), list_to_integer(Lv));
            ["resttreasurehunt"] ->
                mod_treasure_hunt:gm_reset_treasure(Status#player_status.id);
            ["eudemonslandexp", ExpAdd] ->
                lib_eudemons_land:gm_add_eudemons_exp(Status, list_to_integer(ExpAdd));
            ["eudemonslandrank"] ->
                mod_clusters_node:apply_cast(mod_eudemons_land, settlement_rank, []);
            ["cusactstageclear", Type, SubType] ->
                lib_train_act:gm_delete_train_init_state(Status, list_to_integer(Type), list_to_integer(SubType));
            ["changename", RoleId, Name] ->
                lib_php_api:gm_change_role_name(list_to_integer(RoleId), Name);
            ["rechargefirstIndexL", IndexListStr] ->
                IndexList = util:string_to_term(IndexListStr),
                Status1 = lib_recharge_first:gm_update(Status, [{index_list, IndexList}]),
                lib_recharge_first:send_first_state_to_client(Status1),
                Status1;
            ["rechargefirstDays", LoginDays] ->
                Status1 = lib_recharge_first:gm_update(Status, [{login_days, list_to_integer(LoginDays)}]),
                lib_recharge_first:send_first_state_to_client(Status1),
                Status1;
            ["rechargefirstTime", LoginUtime] ->
                Status1 = lib_recharge_first:gm_update(Status, [{days_utime, list_to_integer(LoginUtime)}]),
                lib_recharge_first:send_first_state_to_client(Status1),
                Status1;
            ["role3v3Repair"] ->
                lib_3v3_local:repair();
            ["opensanctum", MinS] ->
                Min = list_to_integer(MinS),
                mod_kf_sanctum:gm_start_act(Min);
            ["closesanctum"] ->
                mod_kf_sanctum:gm_close_act();
            ["resetvipgift", Type, SubType] ->
                lib_custom_act_vip_gift:gm_reset_gift_state(Status, list_to_integer(Type), list_to_integer(SubType));
            ["viptimeout", Type] ->
                lib_vip:gm_set_card_timeout(Status, list_to_integer(Type));
            ["deletedragonbagone", GoodsTypeId, Num, Sign] ->
                lib_dragon:clear_dragon_bag_equip(Status#player_status.id, list_to_integer(GoodsTypeId), list_to_integer(Num), list_to_integer(Sign));
            ["deletebygoodsid", GoodsTypeId_, Num_] ->
                GoodsTypeId = list_to_integer(GoodsTypeId_),
                Num = list_to_integer(Num_),
                Cost = [{?TYPE_GOODS, GoodsTypeId, Num}],
                case lib_goods_api:cost_object_list_with_check(Status, Cost, gm, "") of
                    {true, NStatus} -> ok;
                    {false, Res, NStatus} -> ?PRINT("gm costlist Res ~p~n", [Res])
                end,
                NStatus;
            ["resetdecstren"] ->
                lib_decoration:gm_reset_stren(Status);
            ["alldemons", Star, Level] ->
                lib_demons:gm_active_all_demons(Status, list_to_integer(Star), list_to_integer(Level));
            ["adddemonsskillpro", _DemonsId, _AddProcess] ->
                lib_demons:gm_add_skill_process(Status, list_to_integer(_DemonsId), list_to_integer(_AddProcess));
            ["ninefakejoin", JoinNum] ->
                lib_nine_api:gm_fake_join_nine(list_to_integer(JoinNum)),
                Status;
            ["holyBattleFakeJoin", JoinNum] ->
                lib_holy_spirit_battlefield:gm_fake_join(list_to_integer(JoinNum)),
                Status;
            ["1vnfakejoin", JoinNum] ->
                lib_kf_1vN:gm_fake_join_1vn(list_to_integer(JoinNum)),
                Status;
            ["mergereturn"] ->
                lib_recharge_return:merge_recharge_return();
            ["DunDemonCompensate"] ->
                lib_dun_demon:demon_dun_compensate();
            ["getdemonsdunattr", _DemonsId] ->
                AttrList = lib_demons:get_battle_demons_for_dun(Status),
                DemonsId = list_to_integer(_DemonsId),
                case lists:keyfind(DemonsId, 1, AttrList) of
                    {_, _, Attr} ->
                        List = lib_player_attr:to_kv_list(Attr),
                        ListStr = util:term_to_string(List),
                        MsgSend = lists:concat(["attr:", ListStr]),
                        lib_chat:gm_send_to_all(Status, MsgSend);
                    _ ->
                        MsgSend = lists:concat(["no_such_demons:", _DemonsId]),
                        lib_chat:gm_send_to_all(Status, MsgSend)
                end;
            ["supvipchargeday", ChargeDay] ->
                lib_supreme_vip:gm_update_charge_day(Status, list_to_integer(ChargeDay));
            ["supviplogindays", LoginDays] ->
                lib_supreme_vip:gm_update_login_days(Status, list_to_integer(LoginDays));
            ["supviptaskchargeday", ChargeDay] ->
                lib_supreme_vip:gm_update_task_charge_day(Status, list_to_integer(ChargeDay));
            ["supvipskilltaskall"] ->
                lib_supreme_vip:gm_finish_skill_task(Status);
            ["supvipskilltask", TaskId] ->
                lib_supreme_vip:gm_finish_skill_task(Status, list_to_integer(TaskId));
            ["supvipexref", Time] ->
                lib_supreme_vip:gm_ex_ref(Status, list_to_integer(Time));
            ["supvip", Stage] ->
                lib_supreme_vip:gm_update_stage(Status, list_to_integer(Stage));
            ["supvipright", RightType] ->
                lib_supreme_vip:gm_clear_supvipright(Status, list_to_integer(RightType));
            ["protectuseclear", SceneType] ->
                lib_protect:gm_clear_use_count(Status, list_to_integer(SceneType));
            ["opengboss"] ->
                mod_guild_boss:gm_open_gboss();
            ["endgboss"] ->
                mod_guild_boss:gboss_end();
            ["resetgbosstimes"] ->
                mod_guild_boss:reset_gboss_times();
            ["guildauction", ModuleId1, List1, List2] ->
                ModuleId = list_to_integer(ModuleId1),
                GuildId = Status#player_status.guild#status_guild.id,
                GoodsList = util:string_to_term(List1),
                PlayerIdList = util:string_to_term(List2),
                AuthenticationId = mod_id_create:get_new_id(?AUTHENTICATION_ID_CREATE),
                InAuctionPlayerList = [{AuthenticationId, PlayerId1, GuildId, ModuleId} ||PlayerId1 <- PlayerIdList],
                lib_act_join_api:add_authentication_player(InAuctionPlayerList),
                lib_auction_api:start_guild_auction(ModuleId, AuthenticationId, [{GuildId, GoodsList}]),
                ok;
            ["cleatauctionpay"] ->
                mod_auction:gm_clear_auction_pay_record(Status#player_status.id);
            ["cleatauctionbonus"] ->
                mod_auction:gm_clear_auction_bonus(Status#player_status.id);
            ["quitguildnocheck"] ->
                mod_guild:quit_guild(Status#player_status.id),
                Status;
            ["addgbossmat", GBossMat] ->
                mod_guild_boss:add_gboss_mat(Status#player_status.id, Status#player_status.guild#status_guild.id, list_to_integer(GBossMat), gm);
            ["gmresetstate"] ->
                TemStatus = lib_level_act:gm_reset(Status),
                TemStatus;
            ["3v3ChampionPk"] ->
                mod_clusters_node:apply_cast(mod_3v3_champion, gm_start_champion_pk, []);
            ["3v3UpdataChampion"] ->
                mod_clusters_node:apply_cast(mod_3v3_rank, get_champion_data, []);
            ["decorsboss"] ->
                mod_decoration_boss_center:cast_center([{'gm_sboss_ref'}]);
            ["decorboss"] ->
                mod_decoration_boss_center:cast_center([{'gm_reborn_ref'}]),
                mod_decoration_boss_local:gm_reborn_ref();
            ["betareturndays"] ->
                lib_beta_recharge_return:gm_update_login_days(Status);
            ["Season3v3Clear"] ->
                mod_clusters_node:apply_cast(mod_3v3_rank, gm_clear_season_date, []);
            ["closeterritoryact"] ->
                mod_territory_treasure:gm_close_act();
            ["clearbackdecration"] ->
                lib_back_decoration:gm_clear_decoration(Status);
            ["rdungeonlevel", _Level, _GoTime] ->
                #player_status{
                    id = RoleId, server_id = ServerId, server_num = ServerNum, c_server_msg = CServerMsg,
                    figure = #figure{name = RoleName, lv = Lv, career = Career, sex = Sex, picture = Pic, picture_ver = PicVer}
                } = Status,
                RoleArgs = [RoleId, ServerId, ServerNum, CServerMsg, RoleName, Lv, Career, Sex, Pic, PicVer],
                mod_kf_rank_dungeon_local:dungeon_succ([RoleArgs, list_to_integer(_Level), list_to_integer(_GoTime)]);
            ["rdungeonsett"] ->
                mod_kf_rank_dungeon_local:midnight_reset(),
                mod_clusters_node:apply_cast(mod_kf_rank_dungeon, midnight_reset, []);
            ["terriwarstart", _ReadyTime, _StartTime] ->
                mod_clusters_node:apply_cast(mod_territory_war, gm_start, [list_to_integer(_ReadyTime), list_to_integer(_StartTime)]);
            ["onlinetimeAdd", _AddMinute] ->
                AddMinute = list_to_integer(_AddMinute),
                TemStatus = lib_online_reward:gm_add_online_time(Status, AddMinute*60),
                TemStatus;
            ["rechage_num"] ->
                Status;
            ["cleartitle"] ->
                lib_title:gm_clear_title(Status);
            ["advancemodulemail"] ->
                lib_advance_fun:inform_by_mail(),
                Status;
            ["weekdunrank", _DunId, _PassTime] ->
                lib_week_dungeon:gm_refresh_week_dun_rank(Status, list_to_integer(_DunId), list_to_integer(_PassTime));
            ["weekdunranksettle"] ->
                mod_clusters_node:apply_cast(mod_week_dun_rank, gm_midnight_reset, []);
            ["resetrankdungeon"] ->
                #player_status{id = RoleId} = Status,
                mod_kf_rank_dungeon_local:gm_reset_rank_dungeon(RoleId),
                pp_kf_rank_dungeon:handle(50701, Status, []);
            ["spiritblessvalue", _BlessValue] ->
                lib_spirit_rotary:set_bless_value(Status, list_to_integer(_BlessValue));
            ["onlinerewardreset"] ->
                lib_online_reward:gm_reset();
            ["takeoffdraconicequip", _Pos] ->
                case pp_draconic:handle(62204, Status, [list_to_integer(_Pos)]) of
                    {ok, battle_attr, NewPS2} -> NewPS2;
                    {ok, NewPS2} -> NewPS2;
                    _ -> Status
                end;
            ["testdrop", _MonId, _Num] ->
                MonId = list_to_integer(_MonId),
                Num = list_to_integer(_Num),
                Reward = lib_goods_drop:gm_test_drop(MonId, Num),
                {ok, NewStatus0} = lib_goods_api:send_reward_with_mail(Status, #produce{reward = Reward, type = gm}),
                NewStatus0;
            ["testdrop2", _MonId, _ListId, _Num] ->
                MonId = list_to_integer(_MonId),
                ListId = list_to_integer(_ListId),
                Num = list_to_integer(_Num),
                Reward = lib_goods_drop:gm_test_drop2(MonId, ListId, Num),
                {ok, NewStatus0} = lib_goods_api:send_reward_with_mail(Status, #produce{reward = Reward, type = gm}),
                NewStatus0;
            ["leveldraw", _Subtype] ->
                mod_level_draw_reward:gm_send_reward(list_to_integer(_Subtype));
            ["rechargeconsumerank", _Subtype, _AddType, _AddNum] ->
                lib_consume_rank_act:gm_refresh(Status, list_to_integer(_Subtype), list_to_integer(_AddType), list_to_integer(_AddNum));
            ["endrechargeconsumerank", Type, SubType] ->
                lib_consume_rank_act:gm_end_act(list_to_integer(Type), list_to_integer(SubType));
            ["resetrechargeconsumerank", Type, SubType] ->
                mod_consume_rank_act:apply_cast(lib_consume_rank_act_mod, clear_act_data, [list_to_integer(Type), list_to_integer(SubType)]);
            ["clearleveldraw", _Subtype] ->
                mod_level_draw_reward:gm_clear(list_to_integer(_Subtype));
            ["clearFirstKill", _Subtype] ->
                mod_first_kill:clear_act(list_to_integer(_Subtype));
            ["startredrain", _Subtype] ->
                mod_red_envelopes_rain:gm_start_red_rain(list_to_integer(_Subtype));
            ["gmaddturnpoint", AddPoint] ->
                lib_destiny_turntable:gm_add_turntable_point(Status, list_to_integer(AddPoint));
            ["addguilddaily"] ->
                lib_guild_daily:gm_commplete_task(Status);
            % ["clearguilddaily"] ->
            %     lib_guild_daily:gm_clear(Status);
            ["tribossrotary", BossType, BossId] ->
                {ok, Status2} = lib_boss_rotary:boss_be_kill(Status, list_to_integer(BossType), list_to_integer(BossId)),
                Status2;
            ["clearservercamp"] ->
                mod_c_sanctuary:clear_camp_record();
            ["addHolyBattle", _Point] ->
                lib_holy_spirit_battlefield:add_point(Status, list_to_integer(_Point));
            ["openHolyBattle"] ->
                mod_holy_spirit_battlefield_local:gm_act_start(),
                mod_clusters_node:apply_cast(mod_holy_spirit_battlefield, gm_act_start, []);
            ["endHolyBattle"] ->
                mod_holy_spirit_battlefield_local:gm_end(),
                mod_clusters_node:apply_cast(mod_holy_spirit_battlefield, gm_end, []);
            ["calcHolyBattle"] ->
                mod_clusters_node:apply_cast(mod_holy_spirit_battlefield, gm_calc_server, []);
            ["arcanareset"] ->
                lib_arcana:gm_reset(Status);
            ["addconstellation", _Page] ->
                lib_constellation_equip:gm_add_equip(Status, list_to_integer(_Page)),
                Status;
            ["clearconstellationforge"] ->
                lib_constellation_forge:gm_clear_forge(Status);
            ["constellationgoodsadd", _Num] ->
                lib_constellation_equip:gm_add_goods(Status#player_status.id, list_to_integer(_Num)),
                Status;
            ["resetfourtunecat", Type, SubType] ->
                lib_fortune_cat:gm_reset(Status, Type, SubType);
            ["resetcloudbuy", Type, SubType] ->
                mod_clusters_node:apply_cast(mod_kf_cloud_buy, gm_reset_act, [list_to_integer(Type), list_to_integer(SubType)]);
            ["addcontractpoint", SubType, Point] ->
                mod_contract_challenge:gm_add_point(Status, list_to_integer(SubType), list_to_integer(Point)),
                Status;
            ["addgodcourtequip"] ->
                lib_god_court:gm_add_court_equip(Status),
                Status;
            ["cleargodcourtstatus"] ->
                lib_god_court:gm_clear_status(Status);
            ["changegodhousestatus", OriginTimes, Lv] ->
                lib_god_court:gm_change_house_status(Status, list_to_integer(OriginTimes), list_to_integer(Lv));
            ["restorelevelactdata"] ->
                lib_level_act:gm_restore_role_level_act_data();
            ["finishChronoRiftAct", Mod, SubMod, Count] ->
                lib_local_chrono_rift_act:role_success_finish_act(Status#player_status.id, list_to_integer(Mod),
                    list_to_integer(SubMod), list_to_integer(Count)),
                Status;
            ["finishChronoRiftActEnd"] ->
                mod_clusters_node:apply_cast(mod_kf_chrono_rift, gm_act_end, []),
                Status;
            ["gmstartseacraft", Type, Mintue] ->
                mod_kf_seacraft:gm_start_act(Status#player_status.server_id, list_to_integer(Type), list_to_integer(Mintue));
            ["gmendseacraft"] ->
                mod_kf_seacraft:gm_end_act();
            ["gmsyncmember"] ->
                mod_kf_seacraft:gm_sync_member_list();
            ["gmupdmember"] ->
                mod_seacraft_local:get_change_info(1);
            ["gmaddseaexploit", Exploit] ->
%%                lib_goods_api:send_reward_with_mail(Status#player_status.id, #produce{reward = [{?TYPE_SEA_EXPLOIT, 0, list_to_integer(Exploit)}], type = sea_craft_daily_task_reward});
                lib_seacraft_extra_api:add_exploit(Status, list_to_integer(Exploit), {produce, gm});
            ["gmresetseacraft"] ->
                mod_clusters_node:apply_cast(mod_kf_seacraft, gm_reset_act, []),
%%                F = fun() ->
%%                    db:execute(?TRUNCATE_SEA_GUILD), db:execute(?TRUNCATE_SEA_CAMP), db:execute(?TRUNCATE_SEA_JOB),
%%                    db:execute(?TRUNCATE_SEA_APPLY), db:execute(?TRUNCATE_SEA_INFO), db:execute(?TRUNCATE_SEA_ACT),
%%                    db:execute(?TRUNCATE_DAILY_JOB), db:execute(?TRUNCATE_SEA_MEMBER_INFO), db:execute(?TRUNCATE_LOCAL_CHANGEINFO),
%%                    db:execute(?TRUNCATE_LOCAL_JOIN), db:execute(?TRUNCATE_LOCAL_QUIT), db:execute("update guild set realm = 0")
%%                    end,
%%                lib_goods_util:transaction(F),
%%                supervisor:terminate_child(gsrv_sup, {mod_seacraft_local, start_link, []}),
%%                supervisor:restart_child(gsrv_sup, {mod_seacraft_local, start_link, []}),
%%                mod_clusters_node:apply_cast(supervisor, terminate_child, [gsrv_sup, {mod_seacraft_local, start_link, []}]),
%%                mod_clusters_node:apply_cast(supervisor, restart_child, [gsrv_sup, {mod_seacraft_local, start_link, []}]),
                Status;
            ["freshseacraftboss"] ->
                mod_clusters_node:apply_cast(mod_kf_seacraft_daily, boss_reborn, [18, 1, 1]),
                mod_clusters_node:apply_cast(mod_kf_seacraft_daily, boss_reborn, [18, 1, 2]),
                mod_clusters_node:apply_cast(mod_kf_seacraft_daily, boss_reborn, [18, 1, 3]),
                mod_clusters_node:apply_cast(mod_kf_seacraft_daily, boss_reborn, [18, 1, 4]),
                mod_clusters_node:apply_cast(mod_kf_seacraft_daily, boss_reborn, [19, 1, 1]),
                mod_clusters_node:apply_cast(mod_kf_seacraft_daily, boss_reborn, [19, 1, 2]),
                mod_clusters_node:apply_cast(mod_kf_seacraft_daily, boss_reborn, [19, 1, 3]),
                mod_clusters_node:apply_cast(mod_kf_seacraft_daily, boss_reborn, [19, 1, 4]),
                ok;
            ["seacraftsetbrick", SeaIdStr, NumStr] ->
                mod_clusters_node:apply_cast(mod_kf_seacraft_daily, gm_add_sea_brick,
                    [config:get_server_id(), list_to_integer(SeaIdStr), list_to_integer(NumStr)]),
                ok;
            ["startescort"] ->
                mod_escort_kf:gm_start(),
                Status;
            ["endescort"] ->
                mod_escort_kf:gm_act_end(),
                Status;
            ["signUpClear"] ->
                lib_act_sign_up:day_trigger(),
                Status;
            ["cancelassist"] ->
                lib_guild_assist:gm_cancel_assist(Status);
            ["guildmerge"] ->
                mod_guild:gm_guild_merge();
            ["clearguildmerge"] ->
                mod_guild:gm_clear_guild_merge();
            ["clearmon"] ->
                lib_mon:clear_scene_mon(Status#player_status.scene, Status#player_status.scene_pool_id, Status#player_status.copy_id, 1);
            ["decoratbossfix"] ->
                mod_decoration_boss_local:gm_fix_reborn();
            ["decoratbossfixkf"] ->
                mod_decoration_boss_center:cast_center([{'gm_fix_reborn'}]);
            ["clearstartrek", Type, SubType] ->
                lib_star_trek:gm_clear_data(Type, SubType);
            ["activemounttype", _Type] ->
                lib_mount:active_base_task(Status#player_status.id, list_to_integer(_Type));
            ["subscribe"] ->
                lib_subscribe_api:send_subscribe_of_onhook(Status);
            ["battleformula", Num, AttrKvLA, LvA, AttrKvLB, LvB, SkillId, SkillLv] ->
                List = mod_battle:ts_battle_formula(list_to_integer(Num), util:string_to_term(AttrKvLA), list_to_integer(LvA),
                    util:string_to_term(AttrKvLB), list_to_integer(LvB), list_to_integer(SkillId), list_to_integer(SkillLv)),
                lib_chat:gm_send_to_all(Status, util:term_to_string(List));
            ["attrpower", AttrL] ->
                Power = lib_player:calc_all_power(util:string_to_term(AttrL)),
                lib_chat:gm_send_to_all(Status, util:term_to_string(Power));
            ["sendtv", Module, Id] ->
                #player_status{id = PlayerId} = Status,
                lib_chat:send_TV({player, PlayerId}, list_to_integer(Module), list_to_integer(Id), []),
                Status;
            ["sendscenetv", Module, Id] ->
                #player_status{scene = SceneId, scene_pool_id = PoolId} = Status,
                lib_chat:send_TV({scene, SceneId, PoolId}, list_to_integer(Module), list_to_integer(Id), []),
                Status;
            ["setafktime", S] ->
                {ok, Status0} = lib_afk:set_afk_time(Status, list_to_integer(S)),
                Status0;
            ["setoff", BackTime] ->
                lib_afk:gm_simulate_off(Status, list_to_integer(BackTime));
            ["setoff2", AfkLeftTime, AfkUtime, DayBGold, DayUtime] ->
                lib_afk:gm_simulate_off(Status, list_to_integer(AfkLeftTime), list_to_integer(AfkUtime),
                    list_to_integer(DayBGold), list_to_integer(DayUtime));
            ["setoff3", AfkLeftTime, AfkUtime, DayBGold, DayUtime, Ratio, RatioEndTime] ->
                lib_afk:gm_simulate_off(Status, list_to_integer(AfkLeftTime), list_to_integer(AfkUtime),
                    list_to_integer(DayBGold), list_to_integer(DayUtime), list_to_integer(Ratio), list_to_integer(RatioEndTime));
            ["group", Group] ->
                mod_server_cast:set_data_sub([{group, list_to_integer(Group)}], Status);
            ["resetfirstblood"] ->
                lib_boss_first_blood_plus:gm_reset_reward_state(Status);
            ["resetspecialgift", SubType] ->
                lib_special_gift:gm_reset_reward(Status, list_to_integer(SubType));
            ["htest"] ->
                htest:htest(Status);
            ["getprocessdata", _IsKf, _Num] ->
                get_process_data(list_to_integer(_IsKf), list_to_integer(_Num));
            ["restartprocess", _Num] ->
                restart_process(list_to_integer(_Num));
            ["battleskill", SkillId, Angle] ->
                lib_battle_api:gm_battle(Status, SkillId, Angle);
            ["domainspbossinit"] ->
                Scene = Status#player_status.scene,
                mod_boss:gm_create_domain_boss(Scene);
            ["kfdomainspbossinit"] ->
                Scene = Status#player_status.scene,
                mod_great_demon_local:gm_create_special_boss(Scene);
            ["kfdomainrefreshcl"] ->
                mod_great_demon_local:gm_reinit_cl_boss();
            ["kfdomainrefreshboss"] ->
                mod_great_demon_local:gm_reinit_boss_be_kill(Status#player_status.scene);
            ["kfdomaindailyclear"] ->
                mod_great_demon_local:daily_clear_demon_kill();
            ["kfsanctuaryboss"] ->
                mod_sanctuary_cluster_mgr:gm_create_mon();
            ["assistskill", SKillId, SkillLv] ->
                lib_battle_api:assist_anything(Status#player_status.scene, Status#player_status.scene_pool_id, ?BATTLE_SIGN_PLAYER,
                    Status#player_status.id, ?BATTLE_SIGN_PLAYER, Status#player_status.id, list_to_integer(SKillId), list_to_integer(SkillLv));
            ["getscenemon"] ->
                #player_status{scene = Scene, scene_pool_id = Pool, copy_id = CopyId} = Status,
                mod_scene_agent:apply_cast(Scene, Pool, pp_gm, print_mon_info, [Scene, Pool, CopyId]);
            ["updatelogindays"] ->
                lib_player_login_day:pp_gm_update_login_day(Status);
            ["gmclosemodule", _ModuleId, _SubModule, _ModStatus] ->
                lib_gm_stop:gm_change_mod(list_to_integer(_ModuleId), list_to_integer(_SubModule), list_to_integer(_ModStatus));
            ["resetbonustreasure", _Type, _Subtype] ->
                lib_bonus_treasure:gm_reset_bonus_treasure(Status, list_to_integer(_Type), list_to_integer(_Subtype));
            ["kfsanctuaryclear", _Type] ->
                lib_sanctuary_cluster:clear_role_anger();
            ["endallship"] ->
                mod_sea_treasure_local:gm_end_ship();
            ["clearshippinglog", _Type] ->
                Type = list_to_integer(_Type),
                ?IF(Type == 0, mod_sea_treasure_local:gm_clear_treasure_log(),
                    mod_sea_treasure_local:gm_clear_treasure_log(Status#player_status.id));
            ["clearshipping"] ->
                mod_sea_treasure_local:gm_clear_ship_info();
            ["createrobot"] ->
                mod_sea_treasure_local:gm_create_robot();
            ["templeawaken", _Chapter] ->
                Status1 = lib_temple_awaken:gm_complete_temple(Status, list_to_integer(_Chapter)),
%%                ?PRINT("#player_status{temple_awaken ~p ~n", [Status1#player_status.temple_awaken]),
                Status1;
            ["templeawkanesub", Chapter, SubChapter] ->
                lib_temple_awaken:gm_complete_subchapter(Status, list_to_integer(Chapter), list_to_integer(SubChapter));
            ["templeawkanestage", Chapter, SubChapter, Stage] ->
                lib_temple_awaken:gm_complete_stage(Status, list_to_integer(Chapter), list_to_integer(SubChapter), list_to_integer(Stage));
            ["cleartempleawaken"] ->
                lib_temple_awaken:gm_clear(Status);
            ["addRevelationEquip", Num] ->
                lib_revelation_equip:gm_add_equip(Status, list_to_integer(Num));
            ["addonhookcoin", _Value] ->
                mod_activity_onhook:gm_add_activity_value(Status#player_status.id, list_to_integer(_Value));
            ["setbossvit", _Value] ->
                Status1 = lib_boss:gm_set_boss_vit(Status, list_to_integer(_Value)),
                Status1;
            ["gmsetlastvittime", Value] ->
                Status1 = lib_boss:gm_set_last_vit_time(Status, list_to_integer(Value)),
                Status1;
            ["bossreborn", _BossType, _BossId] ->
                BossType = list_to_integer(_BossType),
                case lists:member(BossType, ?GM_BOSSTYPE_LIST) of
                    true ->
                        mod_boss ! {'boss_reborn', BossType, list_to_integer(_BossId)},
                        mod_boss ! {'boss_remind', BossType, list_to_integer(_BossId)};
                    false -> skip
                end;
            ["clearNoAutoRemind"] ->
                mod_boss:gm_clear_no_auto_remind_state(Status#player_status.id),
                Status;
            ["dbquery", Value] ->
                %% 把"@"替换为"_"
                ExFun = fun
                    (64) -> 95;
                    (R) -> R
                end,
                List = lists:map(ExFun, Value),
                ReturnData = case util:string_to_term(List) of
                    undefined -> {};
                    ValueT ->
                        {Sql, Params} = ValueT,
                        LastSql = io_lib:format(Sql, Params),
                        db:get_all(LastSql)
                end,
                ?ERR("~p", [ReturnData]),
                lib_chat:gm_send_to_all(Status, util:term_to_string(ReturnData)),
                ok;
            ["dbexecute", Value] ->
                ExFun = fun
                            (64) -> 95;
                            (R) -> R
                        end,
                List = lists:map(ExFun, Value),
                case util:string_to_term(List) of
                    {Sql} ->
                        ?PRINT("Sql ~p ~n", [Sql]),
                        db:execute(Sql);
                    _ -> skip
                end,
                ok;
            ["updateplayerlogintime", V1, V2] ->
                NewV1 = list_to_integer(V1),
                NewV2 = list_to_integer(V2),
                ?MYLOG("cxd_gm", "~p", [update_player_login_time]),
                NewStatus1 = Status#player_status{login_time_before_last = NewV2, last_login_time = NewV1},
                lib_chat:gm_send_to_all(NewStatus1, lists:concat(["最近一次登陆时间戳：", NewV1, ";上上次登录时间戳：", NewV2])),
                NewStatus1;
            ["zonechange", ZoneType, ServerId, NewZone] ->
                mod_clusters_node:apply_cast(mod_zone_mgr, gm_zone_change, [list_to_integer(ZoneType), list_to_integer(ServerId), list_to_integer(NewZone)]),
                Status;
            ["forbidChat", UserId, Type] ->
                lib_chat:forbid_chat([list_to_integer(UserId)], list_to_integer(Type), 1);
            ["unForbidChat", UserId] ->
                lib_chat:release_chat([list_to_integer(UserId)], 1);
            ["forbidOpenDay", Flag] ->
                mod_global_counter:set_count(?MOD_BASE, 1, list_to_integer(Flag));
            ["changecrename", Str] ->
                Status#player_status{c_rename = list_to_integer(Str)};
            ["suprisegifttimes", _Times] ->
                lib_surprise_gift:add_free_times(Status, list_to_integer(_Times));
            ["deleteusedgoods", _Type, _GtypeId, _Num] ->
                TypeId = list_to_integer(_Type),
                GoodsTypeId = list_to_integer(_GtypeId),
                Num = list_to_integer(_Num),
                lib_mount:gm_delete_used_goods(Status, TypeId, GoodsTypeId, Num);
            ["advertisementClear"] ->
                lib_advertisement:gm_clear();
            ["advertisementFinish"] ->
                lib_advertisement:notify(Status#player_status.id);
            ["pushgiftclearexpire"] ->
                lib_push_gift_api:gm_clear_expire(Status);
            ["outprocess", ProcessStr, IsGolStr, IsClsStr] ->
                ExFun = fun (64) -> 95; (R) -> R end,
                List = lists:map(ExFun, ProcessStr),
                Process = list_to_atom(List),
                IsGol = list_to_atom(IsGolStr),
                IsCls = list_to_atom(IsClsStr),
                State =
                    if
                        IsCls, IsGol -> mod_clusters_node:apply_call(sys, get_state, [{global, Process}]);
                        IsCls -> mod_clusters_node:apply_call(sys, get_state, [Process]);
                        IsGol -> sys:get_state({global, Process});
                        true -> sys:get_state(Process)
                    end,
                ?INFO("~p: ~n ~p ~n", [Process, State]);
            ["areadetailbattleinfo"] ->
                #player_status{scene = Scene, scene_pool_id = Pool, x = X, y = Y} = Status,
                print_battle_info(Scene, Pool, area_object_detail_info, [X, Y, 100]);
            ["modifycumulationolddata"] ->
                % 小于2021.10.12日之前的数据，1代表已经领取，进行更改
                SQL = io_lib:format("update recharge_cumulation_reward set state = 2 where state = 1 and time < 1634054400", []),
                db:execute(SQL),
                OnlineList = ets:tab2list(?ETS_ONLINE),
                [
                    lib_player:apply_cast(PlayerId, ?APPLY_CAST_STATUS, lib_recharge_cumulation, update_daily, [])
                    || #ets_online{id = PlayerId} <- OnlineList
                ];
            ["resetrunehunt"] ->
                lib_rune_hunt:gm_reset_rune_hunt(Status);
            [ "resetsuit"] ->
                lib_equip:gm_reset_suit(Status);
            ["middayfakejoin", BNum] ->
                Num = list_to_integer(BNum),
                mod_midday_party:gm_fake_join(Num);
            ["weddingend"] ->
                #player_status{id = RoleId} = Status,
                mod_marriage_wedding_mgr:gm_wedding_end(RoleId);
            ["resetsanctuaryboss", SanctuaryId] ->
                mod_sanctuary:gm_reset_boss(list_to_integer(SanctuaryId));
            ["sanctuaryupdate"] ->
                mod_sanctuary ! {'person_rank_refresh'};
            ["resetgodlv", BGodId, BGodLv] ->
                GodId = list_to_integer(BGodId),
                GodLv = list_to_integer(BGodLv),
                lib_god_api:gm_reset_god(GodId, GodLv, Status);
            ["resetFiesta"] ->
                lib_fiesta_api:gm_reset_fiesta(Status);
            ["addFiestaExp", ExpAddS] ->
                ExpAdd = list_to_integer(ExpAddS),
                lib_fiesta_api:gm_add_fiesta_exp(Status, ExpAdd);
            ["finishFiestaTask", TaskIdS] ->
                TaskId = list_to_integer(TaskIdS),
                lib_fiesta_api:gm_finish_task(Status, TaskId);
            ["finishFiestaTask2", TaskContentS] ->
                TaskContent = list_to_atom(re:replace(TaskContentS, "@", "_", [global, {return, list}])),
                lib_fiesta_api:gm_finish_task(Status, TaskContent);
            ["setPlayerRegTime", RegTimeS] ->
                RegTime = list_to_integer(RegTimeS),
                lib_fiesta_api:gm_set_reg_time(Status, RegTime);
            ["growwelfaretask"] ->
                lib_grow_welfare:gm_finish_all(Status);
            ["printsceneinfo"] ->
                #player_status{server_num = ServerNum, c_server_msg = CServerMsg, server_id = SerId, server_name = ServerName,
                    scene = SceneId, scene_pool_id = PoolId, copy_id = CopyId, x = X, y = Y, id = RoleId, figure = Figure} = Status,
                Msg = io_lib:format("当前场景Id: ~p 场景线程Id: ~p 场景房间Id: ~p 坐标: ~p~n", [SceneId, PoolId, CopyId, {X, Y}]),
                PackData = [?CHAT_CHANNEL_WORLD, ServerNum, CServerMsg, SerId, ServerName, "", "", RoleId, Figure, Msg, util:term_to_string([]), 0, utime:unixtime()],
                {ok, BinData} = pt_110:write(11001, PackData),
                lib_server_send:send_to_all(BinData);
            ["printpoolgift", GiftIdS] ->
                GiftId = list_to_integer(GiftIdS),
                #player_status{server_num = ServerNum, c_server_msg = CServerMsg, server_id = SerId, server_name = ServerName, id = RoleId, figure = Figure} = Status,
                Round = lib_gift_util:get_pool_gift_round(RoleId, GiftId),
                FailTimes = lib_gift_util:get_pool_gift_fail_times(RoleId, GiftId),
                Msg = io_lib:format("礼包id：~p 轮次：~p 失败次数：~p~n", [GiftId, Round, FailTimes]),
                PackData = [?CHAT_CHANNEL_WORLD, ServerNum, CServerMsg, SerId, ServerName, "", "", RoleId, Figure, Msg, "[]", 0, utime:unixtime()],
                {ok, BinData} = pt_110:write(11001, PackData),
                lib_server_send:send_to_all(BinData);
            ["rushtreasureactend", _Type, _SubType] ->
                mod_rush_treasure_kf:cast_center([{gm_act_end, list_to_integer(_Type), list_to_integer(_SubType)}]);
            ["gmcombat"] ->
                lib_combat_welfare:gm_reset_rewardL(Status);
            ["tsmap", Type, Times] ->
                LvLimit = data_treasure_map:get_kv(lv_limit),
                case Status#player_status.figure#figure.lv < LvLimit of
                    true -> lib_tsmap:pack_and_send(Status#player_status.id, 20300, [?ERRCODE(lv_limit)]);
                    _ -> lib_tsmap:tsmap_gm(Status, list_to_integer(Type), list_to_integer(Times))
                end;
            ["mount", TypeId, AddLevel] ->
                lib_mount_upgrade_sys:gm_set_mount_level(Status, list_to_integer(TypeId),  list_to_integer(AddLevel));
            ["limittower"] ->
                lib_dungeon_limit_tower:reset_limit_tower_data(Status);
            ["overtower"] ->
                lib_dungeon_limit_tower:gm_settleAccounts(Status);
            ["onefinishtower", Round] ->
                lib_dungeon_limit_tower:set_pass_success_all(Status, list_to_integer(Round));
            ["addweeklyccardexp", Exp] ->
                lib_weekly_card:gm_add_exp(Status, list_to_integer(Exp));
            ["expiredweeklycard"] ->
                lib_weekly_card:gm_expired_weekly_card(Status);
            ["updateexpiredweeklycard"] ->
                lib_weekly_card:gm_update_expired_weekly_card(Status);
            ["cyclerank", Type, SubType, Score] ->
                Last = lib_cycle_rank:cycle_gm(Status, list_to_integer(Type), list_to_integer(SubType), list_to_integer(Score)),
                Last;
            ["rechargenum", SubType, Num] ->
                lib_custom_act_recharge_polite:gm_set_num(list_to_integer(SubType), list_to_integer(Num)),
                Status;
            ["clearnum", SubType] ->
                lib_custom_act_recharge_polite:gm_clear(list_to_integer(SubType));
            ["ranksna"] ->
                mod_common_rank:common_rank_snapshot(),
                Status;
            ["taagentofficial"] ->
                  case ?CODE_BRANCH == ?CODE_BRANCH_PRE_STABLE of
                        true ->
                              ta_agent:gm_set_url(official),
                              lib_chat:gm_send_to_all(Status, lists:concat(["TA 正式上报到TA系统中的测试APPID中"]));
                        false ->
                              lib_chat:gm_send_to_all(Status, lists:concat(["TA 本版本无法设置上报TA系统"]))
                  end;
            ["cyclerank100"] ->
                lib_cycle_rank_local_mod:gm_select_player_rank(),
                Status;
            ["groupbuy", Type, SubType, GradeId, CdTime] ->
                ShoutArgs = [list_to_integer(Type), list_to_integer(SubType), Status#player_status.id ,config:get_server_id(), list_to_integer(GradeId), list_to_integer(CdTime)],
                mod_clusters_node:apply_cast(mod_kf_group_buy, group_buy_shout, [ShoutArgs]),
                Status;
            ["resetgroupbuy"] ->
                mod_clusters_node:apply_cast(mod_kf_group_buy, gm_reset_group_buy, []),
                Status;
            ["dragonballbuyrefresh"] ->
                NStatus = lib_dragon_ball:gm_refresh_buy_time(Status),
                NStatus;
            _ ->
                ?PRINT("error gm cmd = 11101, data=~p ~n", [Args]),
                Status
        end,
    case NewStatus of
        #player_status{} ->
            lib_player:send_attribute_change_notify(NewStatus, ?NOTIFY_ATTR),
            {ok, battle_attr, NewStatus};
        _ -> NewStatus
    end.


broadcast(Status) ->
    pp_dungeon:handle(61020, Status, [?DUNGEON_TYPE_PARTNER]),
    pp_dungeon:handle(61020, Status, [?DUNGEON_TYPE_WING]),
    pp_dungeon:handle(61020, Status, [?DUNGEON_TYPE_EQUIP]),
    pp_dungeon:handle(61020, Status, [?DUNGEON_TYPE_DRAGON]),
    pp_dungeon:handle(61020, Status, [?DUNGEON_TYPE_HIGH_EXP]),
    pp_dungeon:handle(61020, Status, [?DUNGEON_TYPE_EXP_SINGLE]),
    pp_dungeon_sec:handle(61121, Status, [0]),
    lib_game:send_game_info(Status),
    Status.

%% 输出玩家信息
print_role_info(RoleId) when is_integer(RoleId) ->
    lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, ?NOT_HAND_OFFLINE, pp_gm, print_role_info, []);
print_role_info(Player) ->
    #player_status{id = RoleId, scene = Scene} = Player,
    ?MYLOG("roleinfo", "RoleId:~p Scene:~p ~n", [RoleId, Scene]),
    {ok, Player}.

%% 通知开服天数变化
notice_opday_change() ->
    OnlineRoles = ets:tab2list(?ETS_ONLINE),
    spawn(fun() ->
        F = fun(E) ->
            lib_player:apply_cast(E#ets_online.id, ?APPLY_CAST_SAVE, ?MODULE, notice_opday_change, [])
        end,
        lists:foreach(F, OnlineRoles)
    end),
    ok.

notice_opday_change(Status) ->
    pp_game:handle(10201, Status, []),
    {ok, NStatus} = pp_dragon:handle(18105, Status, []),
    {ok, LastStatus} = lib_dungeon_limit_tower:gm_change_open_day(NStatus),
    {ok, LastStatus}.

%% 通知合服天数变化
notice_mergeday_change() ->
    OnlineRoles = ets:tab2list(?ETS_ONLINE),
    spawn(fun() ->
        F = fun(E) ->
            lib_player:apply_cast(E#ets_online.id, ?APPLY_CAST_SAVE, ?MODULE, notice_mergeday_change, [])
        end,
        lists:foreach(F, OnlineRoles)
    end),
    ok.

notice_mergeday_change(Status) ->
    pp_game:handle(10201, Status, []),
    {ok, Status}.

get_process_data(IsKf, Num) ->
    ProcessName = get_mod(Num),
    if
        ProcessName == false -> skip;
        IsKf == 1 ->
            mod_clusters_node:apply_cast(tool, get_process_state, [0, ProcessName]);
        true ->
            tool:get_process_state(0, ProcessName)
    end.

get_mod(Num) ->
    case Num of
        1 -> "mod_c_sanctuary_local";
        2 -> "mod_c_sanctuary";
        3 -> "mod_zone_mgr";
        4 -> "mod_sea_treasure_local";
        5 -> "mod_sea_treasure_kf";
        6 -> "mod_kf_sanctum_local";
        7 -> "mod_kf_sanctum";
        _ -> false
    end.

restart_process(Num) ->
    Mod = get_mod(Num),
    lib_php_api:restart_process(Mod).

print_mon_info(Scene, Pool, CopyId) ->
    List = if
        CopyId == 0 ->
            lib_scene_object_agent:get_scene_object();
        true ->
            lib_scene_object_agent:get_scene_object(CopyId)
    end,
    ?INFO("Scene:~p, Pool:~p, CopyId:~p SceneObjectList: ~p ~n",[Scene, Pool, CopyId, List]),
    ok.

%% 秘籍聊天频道输出信息
send_msg_to_chat(_Status, []) -> ok;
send_msg_to_chat(Status, [Msg|T]) ->
    #player_status{server_num = ServerNum, c_server_msg = CServerMsg, server_id = SerId, server_name = ServerName, id = RoleId, figure = Figure, copy_id = CopyId} = Status,
    PackData = [?CHAT_CHANNEL_WORLD, ServerNum, CServerMsg, SerId, ServerName, "", "", RoleId, Figure, Msg, util:term_to_string([]), 0, utime:unixtime()],
    {ok, BinData} = pt_110:write(11001, PackData),
    lib_server_send:send_to_uid(RoleId, BinData),
    send_msg_to_chat(Status, T).

%% 输出战斗信息
print_battle_info(SceneId, PoolId, Key, Args) ->
    mod_scene_agent:apply_cast_with_state(SceneId, PoolId, ?MODULE, print_battle_info_help, [Key, SceneId, PoolId, Args]),
    ok.

%% 输出战斗信息-场景
% 周围对象的信息
print_battle_info_help(area_object_detail_info, _SceneId, _PoolId, [X, Y, Area], _EtsScene) ->
    ObjectList = lib_scene_object_agent:get_scene_object(),
    UserList = lib_scene_agent:get_scene_user(),
    F = fun(T, TmpList) ->
        case T of
            #scene_object{id = Id, config_id = ConfigId, sign = Sign, x = TmpX, y = TmpY, battle_attr = #battle_attr{hp = Hp}} -> ok;
            #ets_scene_user{id = Id, x = TmpX, y = TmpY, battle_attr = #battle_attr{hp = Hp}} -> ConfigId = 0, Sign = ?BATTLE_SIGN_PLAYER
        end,
        case Area == 0 orelse umath:distance({X, Y}, {TmpX, TmpY}) =< Area of
            true -> [{Id, ConfigId, Sign, TmpX, TmpY, Hp}|TmpList];
            false -> TmpList
        end
    end,
    List = lists:foldl(F, [], ObjectList++UserList),
    ?MYLOG("battleinfo", "area_object_detail_info ~p ~n", [{X, Y, Area, List}]),
    ok;
print_battle_info_help(_Key, _SceneId, _PoolId, _Args, _EtsScene) ->
    ?MYLOG("battleinfo", "print_battle_info_help no match ~p ~n", [{_Key, _SceneId, _PoolId, _Args}]),
    ok.

%% ==========================属性相减（带负数，方便测试使用）==========================================
minus_attr(AttrList) ->
    NewAttrList = [minus_attr_helper(Attr) || Attr <- AttrList],
    DiffListTmp = kv_list_minus_extra(NewAttrList),
    [Attr||{_, Val} = Attr<-DiffListTmp, Val =/=0].

%% 转化为通用格式
minus_attr_helper(Attr) when is_map(Attr) orelse is_record(Attr, attr) ->
    to_kv_list(Attr);
minus_attr_helper([{_, _} | _] = Attr) ->
    Attr;
minus_attr_helper(_) -> [].

%% key-value列表元素相减，不要求列表元素对应(有负数)
kv_list_minus_extra([List]) -> List;
kv_list_minus_extra([List1, List2|T]) ->
    SumList = kv_list_minus_extra(List1, List2),
    kv_list_minus_extra([SumList|T]);
kv_list_minus_extra([]) -> [].

kv_list_minus_extra(List, []) -> List;
kv_list_minus_extra(List1, [{K, V2}|T]) ->
    case lists:keyfind(K, 1, List1) of
        {K, V1} -> kv_list_minus_extra(lists:keystore(K, 1, List1, {K, V1-V2}), T);
        false -> kv_list_minus_extra(List1, T)
    end.

to_kv_list(AttrMaps) when is_map(AttrMaps) ->
    maps:to_list(AttrMaps);

to_kv_list(Attr) when is_record(Attr, attr) ->
    [_|List] = tuple_to_list(Attr),
    F = fun(Value, {Index, Result}) ->
        case Value > 0 of
            true -> {Index+1, [{Index, Value}|Result]};
            false -> {Index+1, Result}
        end
        end,
    {_, Res} = lists:foldl(F, {1, []}, List),
    Res.
%% ================================end====================================
