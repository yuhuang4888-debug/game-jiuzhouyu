import { BaseClass } from "../common/BaseClass"

export class CustomActivityDefine extends BaseClass {
	public static ICON_KEY = "331"

	//独立图标对应活动页面
	//key: 模块ID@主类型@展示ID
	public static IconType2View = {
		"331@36@0": { module_js_class: "ZeroMoneyBaseViewNew", module_js_name: "zeroMoney" },
		"331@36@1": { module_js_class: "ZeroMoneyBaseViewNew", module_js_name: "zeroMoney" },
		"331@36@2": { module_js_class: "ZeroMoneyBaseViewNew", module_js_name: "zeroMoney" },
		"331@36@10": { module_js_class: "ZeroMoneyBaseViewTwo", module_js_name: "zeroMoney" },
		"331@45@0": { module_js_class: "FashionActView", module_js_name: "separateActTwo" },
		"331@18@0": { module_js_class: "CloudPurchaseView", module_js_name: "separateActTwo" },
		"331@6@0": { module_js_class: "DailyFirstMainView", module_js_name: "dailyAct" },
		"331@51@0": { module_js_class: "WeekendActivityView", module_js_name: "boss" },
		// "331@52@0":MonsterInvasionEntView, 
		"331@58@0": { module_js_class: "SaiboTreasureView", module_js_name: "SaiboTreasure" },
		"331@62@1": { module_js_class: "FtvInvestBaseView", module_js_name: "ftvInvest" },
		"331@62@2": { module_js_class: "FtvInvestBaseView", module_js_name: "ftvInvest" },
		"331@69@0": { module_js_class: "NameVerifyView", module_js_name: "specialAct" },
		"331@71@0": { module_js_class: "vipGiftWindowView", module_js_name: "giftAct" },
		"331@73@0": { module_js_class: "WXOneMoneyView", module_js_name: "specialAct" },
		"331@73@1": { module_js_class: "WXOneMoneyView", module_js_name: "specialAct" },
		"331@2@0": { module_js_class: "FlowerRankEnterView", module_js_name: "flowerRank" },
		"331@76@0": { module_js_class: "OptionalLottoWindow", module_js_name: "separateAct" },
		"331@77@0": { module_js_class: "TestActBaseView", module_js_name: "testAct" },
		"331@80@0": { module_js_class: "LuckyTreasureView", module_js_name: "separateActTwo" },
		"331@81@12": { module_js_class: "OnlineDrawBaseView", module_js_name: "onlineDraw" },
		"331@81@13": { module_js_class: "OnlineDrawBaseView", module_js_name: "onlineDraw" },
		"331@91@0": { module_js_class: "ActChallengeEnterView", module_js_name: "actChallenge" },
		"331@91@1": { module_js_class: "ActChallengeEnterView", module_js_name: "actChallenge" },
		"331@92@0": { module_js_class: "ConvoyBaseView", module_js_name: "convoy" },
		"331@99@1": { module_js_class: "DestinyTurntableEnView", module_js_name: "destinyturntable" },
		"331@102@1": { module_js_class: "LuckyTreasureTwoBaseView", module_js_name: "luckyTreasureTwo" },
		"331@103@1": { module_js_class: "CommonActivityView", module_js_name: "partnerAct" },
		"331@103@2": { module_js_class: "CommonActivityView", module_js_name: "partnerAct" },
		"331@107@0": { module_js_class: "ManyRechargeView", module_js_name: "manyRecharge" },
		"331@115@0": { module_js_class: "OneDollarSpikeView", module_js_name: "oneDollarSpike" },
		"331@117@0": { module_js_class: "RedEnvelopeRebateView", module_js_name: "redEnvelopeRebate" },
		"331@120@0": { module_js_class: "SuperGiftView", module_js_name: "superGift" },
		"331@120@1": { module_js_class: "SuperGiftView", module_js_name: "superGift" },
		"331@128@0": { module_js_class: "RareSurfaceView", module_js_name: "rareSurface" },
		"331@128@1": { module_js_class: "RareSurfaceView", module_js_name: "rareSurface" },
		"331@128@2": { module_js_class: "RareSurfaceView", module_js_name: "rareSurface" }, //新增节日直购
		"331@88@0": { module_js_class: "KfGroupBuyEntView", module_js_name: "kfGroupBuy" }, //跨服团购
		"331@111@0": { module_js_class: "AdvertisingBaseView", module_js_name: "advertising" },
		"331@131@0": {module_js_class: "NewAccumRechargeEnterView", module_js_name: "newAccumRecharge"}, //新海外累充活动
	}

	/*
	// 活动页面放在综合活动图标内，又需要有单独图标入口
	// key: "综合图标#页签"
	// value: "独立图标" 
	// "综合图标页签"#.见ConfigCustomActivity.windowscomponent
	//*/
	public static ShowKeyItemToIcon = {
		"331@3#7@0": "331@7@0",
		"331@3#4@0": "331@4@0",
		"331@3_1#7@0": "331@7@0",
		"331@3_1#4@0": "331@4@0",
		//"331@10#67@0":"331@67@0", 
		//"331@10#67@1":"331@67@1", 
		//"331@10#67@2":"331@67@2", 
		//"331@10#67@3":"331@67@3", 
		//"331@10#67@4":"331@67@4", 
		"331@4#53@0": "331@53@0",
		"331@4#53@1": "331@53@1",
		"331@4_1#53@2": "331@53@2",
		"331@4_1#53@3": "331@53@3",
		"331@4_2#53@4": "331@53@4",
		"331@4_2#53@5": "331@53@5",
		"331@100#10@0": "331@10@0",
		"331@100#98@0": "331@98@0",
		"331@100#98@1": "331@98@1",
		"331@100#100@0": "331@100@0",
		"331@100#101@0": "331@100@0"

	}

	//非定制活动的特殊页签
	public static SpecialView = {
		//"424@0":{module_js_class:"BookOfContractView", module_js_name:"kaifuactivity"}, 
		"417@0": { module_js_class: "LevelRewardView", module_js_name: "kaifuactivity" },
		"23@0": { module_js_class: "kfHotPointView", module_js_name: "separateAct" },
		"23@1": { module_js_class: "kfHotPointView", module_js_name: "separateAct" },
		"23@2": { module_js_class: "kfHotPointView", module_js_name: "separateAct" },
		"23@10": { module_js_class: "kfHotPointView", module_js_name: "separateAct" }
	}

	public static DESC_LABEL = ["活动未开启"]

	public static EVENT = {
		UPDATE_VIEW: "CustomActivityDefine.UPDATE_VIEW",
		ANSWER_TARGET: "CustomActivityDefine.ANSWER_TARGET",
		UPDATE_RED_DOT: "CustomActivityDefine.UPDATE_RED_DOT",
		SCMD_REQUEST: "CustomActivityDefine.SCMD_REQUEST",
		UPDATE_TAB_RED: "CustomActivityDefine.UPDATE_TAB_RED",
		OPEN_CUSTOM_VIEW: "CustomActivityDefine.OPEN_CUSTOM_VIEW", //各自活动自己的界面
		UPDATE_ALL_COUNT: "CustomActivityDefine.UPDATE_ALL_COUNT", //更新活动全服特殊计数
		UP_GRADE: "CustomActivityDefine.UP_GRADE", //更新档位信息

		RECEIVE_SUCCESS: "CustomActivityDefine.RECEIVE_SUCCESS",
		BUY_SUCCESS: "CustomActivityDefine.BUY_SUCCESS",
		REFRESHCOUNTDOWN: "CustomActivityDefine.REFRESHCOUNTDOWN",
		UPDATE_ACT_RECHANGE: "CustomActivityDefine.UPDATE_ACT_RECHANGE",
		UPDATE_ACT_RECHANGE_DAY: "CustomActivityDefine.UPDATE_ACT_RECHANGE_DAY",
		DAILYFRIST_SELECT: "CustomActivityDefine.DAILYFRIST_SELECT",
		UPDATE_CLOUD_PURCHASE_HISTORY_VIEW: "CustomActivityDefine.UPDATE_CLOUD_PURCHASE_HISTORY_VIEW",
		EGGS_OPEN: "CustomActivityDefine.EGGS_OPEN",
		UPDATE_HOTPOINT: "CustomActivityDefine.UPDATE_HOTPOINT", //更新嗨点信息
		CLOSE: "CustomActivityDefine.CLOSE",
		SHOW_FORES_GAME_SATR_TIPS_VIEW: "CustomActivityDefine.SHOW_FORES_GAME_SATR_TIPS_VIEW",
		SHOW_FORES_TIPS_VIEW: "CustomActivityDefine.SHOW_FORES_TIPS_VIEW",
		UP_LOG_LIST: "CustomActivityDefine.UP_LOG_LIST", //更新活动记录
		UP_DAILY_SUPPLY: "UDS1", //更新每日补给
		NAME_VERIFY_SUCCESS: "NAME_VERIFY_SUCCESS", //实名验证成功
		UP_BETA_RECHARGE: "CustomActivityDefine.UP_BETA_RECHARGE", //更新封测充值数据
		WISH_POOL_RESET: "CustomActivityDefine.WISH_POOL_RESET", //许愿池重置
		ACT_TURNTABLE_REWARD: "CustomActivityDefine.ACT_TURNTABLE_REWARD", //取活跃度奖励
		ACT_TURNTABLE_RETURN: "CustomActivityDefine.ACT_TURNTABLE_RETURN", //活跃转盘抽奖
		ACT_TURNTABLE_RECORD_RETURN: "CustomActivityDefine.ACT_TURNTABLE_RECORD_RETURN", //活跃转盘抽奖
		ACT_TFIRST_BLOOD_RETURN: "CustomActivityDefine.ACT_TFIRST_BLOOD_RETURN",
		UPDATE_RED_PACKET: "CAD.UPDATE_RED_PACKET", //刷新红包奖励
		WAVE_RED_PACKET: "CAD.WAVE_RED_PACKET",//收到红包推送
		CLICK_TOPPLAYER_TAB: "CustomActivityDefine.CLICK_TOPPLAYER_TAB",
		DESTINY_TURNTABLE_INTEGRAL: "DESTINY_TURNTABLE_INTEGRAL", //天命转盘积分变更
		DESTINY_TURNTABLE_RUN: "DESTINY_TURNTABLE_RUN", //天命转盘抽奖
		STOP_AUTO: "STOP_AUTO", //结束自动抽奖
		SEND_GASHAPON_OP: "SEND_GASHAPON_OP", // 扭蛋
		CLEAR_AUTO_VIEW: "CLEAR_AUTO_VIEW", // 清理自动抽奖奖励界面
		SELECT_GRADE: "SELECT_GRADE",   // 选择档位Item
		OPEN_DESTABLE: "OPEN_DESTABLE",
		ADD_TOPPLAYER_TIP: "ADD_TOPPLAYER_TIP",
		ADD_GIFT_TIP: "ADD_GIFT_TIP",
		UPDATE_RECHARGE_ITEM: "UPDATE_RECHARGE_ITEM",
		RECHARGE_SUCCESS: "RECHARGE_SUCCESS",
		FTV_INVEST_TAB_SELECT: "FTV_INVEST_TAB_SELECT",
		BIND_JAGE_WISH_DAILY: "BIND_JAGE_WISH_DAILY",
		BIND_JAGE_WISH_REWARD: "BIND_JAGE_WISH_REWARD",
		RARE_SURFACE_SELECT_ITEM: "RARE_SURFACE_SELECT_ITEM",
		UPDATE_FIGHTING_VALUE: "UPDATE_FIGHTING_VALUE", //活跃抽奖战力跟新
		UPDATE_GROUP_BUY_SPEAK_TIME: "UPDATE_GROUP_BUY_SPEAK_TIME", //跨服团购购买喊话冷却
		UPDATE_DAYILY_FIRST_VIEW: "UPDATE_DAYILY_FIRST_VIEW", //刷新每日首充界面数据
		UPDATE_ADVERTISING_CD: "UPDATE_ADVERTISING_CD"//
	}

	////////添加红点后，使用CheckFirstRed()获取红点的值
	////////在打开活动页面后，要调用CustomActivityModel中的CloseActRed()关闭红点
	////登录第一次需要显示红点
	public static First_Show_Red = {
		[10]: true,
		[12]: true,
		[13]: true,
		[14]: true,
		[16]: true,
		[48]: true,
		[49]: true,
		[50]: true,
		//[51]:true, 
		[53]: true,
		[54]: true,
		[55]: true,
		[24]: true,
		[56]: true,
		[23]: true,
		[58]: true,
		[59]: true,
		[60]: true,
		[61]: true,
		[28]: true,
		[71]: true,
		[68]: true,
		[72]: true,
		[73]: true,
		[77]: true,
		[80]: true,
		[87]: true,
		[98]: true,
		[104]: true,
		[103]: true,
		[113]: true,
		[114]: true,
		[112]: true,
		[118]: true,
		[120]: true,
		[122]: true,
		[125]: true,
		[128]: true,
		[129]: true,
	}

	////当天第一次登录才显示红点
	public static Day_First_Show_Red = {
		[36]: true,
		[62]: true,
		[64]: true,
		[65]: true,
		[66]: true,
		[74]: true,
		[76]: true,
		[25]: true,
		[81]: true,
		[83]: true,
		[84]: true,
		[86]: true,
		[88]: true,
		[89]: true,
		[93]: true
	}

	////////需在CustomActivityModel的UpdataACTGoodsNum()添加对应处理
	////物品刷新关联红点
	public static Update_Good_Num = {
		[49]: true,
		[56]: true,
		[50]: true,
		[54]: true,
		[60]: true,
		[4]: true,
		[72]: true,
		[79]: true,
		[84]: true,
		[87]: true,
		[80]: true
	}

	//特殊的活动图标,可以处理一些需要异步请求，才能确定是否需要显示图标的活动
	public static SpecialIcon = {
		[69]: true,
		[70]: true
	}

	//审核服需要屏蔽的活动大类
	public static NeedHideInAlpha = {
		[7]: true,
		[68]: true
	}

	//针对不同子类型，有不同的渠道屏蔽规则的活动ID
	public static Subtype_By_Platform = {
		"15@90": true,
	}

	//活动图标需要有预告的活动类型//[type,icon]
	public static AdvanceIcon = {
		[51]: "51",
		[92]: "331@92@0"
	}

	//[icon,type]
	public static AdvanceType = {
		"51": 51,
		"331@92@0": 92
	}
}

export enum Enum_Btn_Type {
	ONE,
	TWO
}

export enum Enum_Currency_Type {
	Money,
	Special
}
window["Enum_Btn_Type"] = Enum_Btn_Type
window["Enum_Currency_Type"] = Enum_Currency_Type
window["CustomActivityDefine"] = CustomActivityDefine