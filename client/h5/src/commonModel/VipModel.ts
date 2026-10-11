import { EventDispatcher } from "../util/EventDispatcher"
import { Mathf } from "../util/Mathf"
import { TimeUtil } from "../util/TimeUtil"
import { CookieWrapper } from "../common/CookieWrapper"
import { RoleManager } from "./RoleManager"
import { ResManager } from "../common/ResManager"
import { ErlangParser } from "../util/ErlangParser"
import { ActivityIconManager } from "../commonModel/ActivityIconManager"
import { Alert } from "../alert/Alert"
import { Alert_Type } from "../alert/Alert"
import { table } from "../common/table"
import { Util } from "../util/Util"
import { ClientConfig } from "../util/DeclareGlobalVar"
import { TaskModel } from "./TaskModel"
import { PlatformManager } from "../PlatformManager"
import { Config } from "../common/Config"

export class VipModel extends EventDispatcher {
	CanReceiveGift
	CheckMoney
	CheckNobleRenewal
	CheckVipIcon
	EyouCardReturnMapping
	EyouKrPlatformRecharge
	EyouPlatformRecharge
	GetCurWeekGiftNum
	GetExp
	GetEyouCardReturnMappingCfg
	GetMaxVipCardType
	GetNextStageExp
	GetNobleCardInfo
	GetNobleCardState
	GetRechargeIconRed
	GetRechargeProductList
	GetRewards
	GetShowRechargeProductList
	GetTimeText
	GetVipCfgNumType
	GetVipLevel
	GetVipPrivilegeValue
	GetVipPVSweepNum
	GetVipPVChallengeNum
	GetWeekGiftNum
	HaveFirstRecharge
	IsInvalidCard
	IsReceivedGift
	SaveNobleCardInfo
	SetRechargeIconRed
	SetRechargeOneProduct
	SetRechargeProductList
	SetRechargeRecord
	GetVipHide
	active_card_type
	all_recharge_record
	can_get_week_list
	can_receve_card_list
	config
	hasReceveCard
	has_get_award
	has_show_vip_tips
	max_vip_lv
	nobel_card_lv
	noble_Card_info
	recharge_product_list
	recharge_red
	showNameBoardTaskId
	show_real_recharge_product_list
	show_red_list
	show_vip_red
	vip_card_default
	vipLevel
	cur_exp
	week_award_get_num
	total_exp
	initConfig
	select_vip_lv
	vip_hide
	// 
	public static SELECT_CARD_ITEM = "SELECT_CARD_ITEM";
	public static VIP_LEFT_BTN_CLICK = "VIP_LEFT_BTN_CLICK";
	public static RECEIVE_EXCLUSIVE_GIFT = "RECEIVE_EXCLUSIVE_GIFT";
	public static SCMD_RECEIVE_EXCLUSIVE_GIFT = "SCMD_RECEIVE_EXCLUSIVE_GIFT";
	public static RECEIVE_WEEK_GIFT = "RECEIVE_WEEK_GIFT";
	public static SELECT_WELFARE_TAB = "SELECT_WELFARE_TAB";
	public static SELECT_SHOW_ITEM = "SELECT_SHOW_ITEM";
	public static UPDATE_NOBLE_STATE = "UPDATE_NOBLE_STATE";
	public static BUY_VIP_CARD = "BUY_VIP_CARD";
	public static UPDATE_VIP_DATA = "UPDATE_VIP_DATA";
	public static GET_NOBLE_GOODS = "GET_NOBLE_GOODS";
	public static UPDATE_RECHARGE_VIEW = "UPDATE_RECHARGE_VIEW";
	public static UPDATE_ALL_RECHARGE = "UPDATE_ALL_RECHARGE";
	public static UPDATE_RECHARGE_TYPETWO = "UPDATE_RECHARGE_TYPETWO";
	public static UPDATE_VIP_RED = "UPDATE_VIP_RED";
	public static GET_WEEK_REWARD = "GET_WEEK_REWARD";
	public static OPEN_VIEW = "OPEN_VIEW";
	public static REQUEST_PROTO = "REQUEST_PROTO";
	public static ADD_RECHARGE_ICON = "ADD_RECHARGE_ICON";
	public static UPDATE_VIP_TAB_RED = "UPDATE_VIP_TAB_RED";
	public static SHOW_MAINUI_TIP = "SHOW_MAINUI_TIP";
	public static USE_TOKEN_SUCCESS = "USE_TOKEN_SUCCESS";
	public static CLOSE_SOME_VIEW = "CLOSE_SOME_VIEW";
	public static UPDATA_VIPCARD_ITEM = "UPDATA_VIPCARD_ITEM";
	public static CHANGE_DISCOUNT_IMG_AND_REFRESH_CARD_ITEM = "CHANGE_DISCOUNT_IMG_AND_REFRESH_CARD_ITEM";
	public static IS_HIDE_VIP_FLAG = "IS_HIDE_VIP_FLAG";
	public static VipCardType = { gold_card: 0, platinum_card: 1, supreme_card: 2 };

	// 直升V4开启条件
	static VIP4_OPEN_LV = 90
	static Instance: VipModel
	public constructor() {
		super()

		if (VipModel.Instance) {
			return
		}
		VipModel.Instance = this
		this.max_vip_lv = 15;
		this.has_get_award = [];
		this.can_get_week_list = [];
		this.noble_Card_info = [];
		this.nobel_card_lv = 0;
		this.can_receve_card_list = [];
		this.config = [];
		this.show_vip_red = false;
		this.vip_card_default = 2;
		this.has_show_vip_tips = false;
		this.show_red_list = [false, false];
		this.recharge_red = false;
		this.hasReceveCard = false;
		this.all_recharge_record = 0
		this.show_real_recharge_product_list = false			//真正显示在充值界面中的充值卡
		//完成这个任务之后 不显示头顶vip
		this.showNameBoardTaskId = 100890
		let local_config = Config
		let local_math = Math
		let local_time = TimeUtil
		let local_cook = CookieWrapper
		let cookier = local_cook.GetInstance()
		let roleMgr = RoleManager.GetInstance()
		let cfg1
		let cfg2
		let res_mgr = ResManager.GetInstance()

		this.initConfig = () => {
			cfg1 = Config.PRELOAD_SERVER_CONFIG.config_num_by_vip
			cfg2 = Config.PRELOAD_SERVER_CONFIG.config_num_by_vip_info
		}
		this.GetVipPrivilegeValue = (moduleId?, subId?, vipCard?, vipLv?, ignoreCard?) => {

			if (cfg1 && cfg2) {
				if (0 == this.nobel_card_lv && !ignoreCard) {
					vipLv = 0
				}
				let key = moduleId + "@" + subId + "@" + vipCard + "@" + vipLv
				let value = null
				let cfg = cfg1
				cfg = cfg && cfg[key]
				if (cfg) {
					value = Number(cfg.num) || 0
				}
				if (!value) {
					key = moduleId + "@" + subId
					let info_cfg = cfg2
					info_cfg = info_cfg && info_cfg[key]
					if (info_cfg) {
						value = info_cfg.num
					} else {
						value = 0
					}
				}

				return value //config_num_by_vip  config_num_by_vip_info


			}

		}

		//没开特权卡  从这里读取挑战次数或者扫荡次数  base_num_by_vip_info
		this.GetVipPVChallengeNum = (moduleId?, subId?) => {
			let value = 0
			let key = moduleId + "@" + subId
			if (cfg2 && cfg2[key]) {
				value = cfg2[key].num
			}
			return value
		}
		//开了特权卡  从这里读取挑战次数或者扫荡次数  base_num_by_vip
		this.GetVipPVSweepNum = (moduleId?, subId?, vipCard?, vipLv?) => {
			//config_num_by_vip 提供扫荡+挑战次数
			let value = 0
			if (cfg1) {
				let key = moduleId + "@" + subId + "@" + vipCard + "@" + vipLv
				let cfg = cfg1 && cfg1[key]
				if (cfg) {
					value = Number(cfg.num)
				}
			}
			return value
		}
		this.GetVipCfgNumType = (cfg, moduleId?, subId?) => {
			let key = moduleId + "@" + subId
			let info_cfg = cfg
			info_cfg = info_cfg && info_cfg[key]
			let num_type = 0
			if (info_cfg) {
				num_type = info_cfg.num_type
			}
			return num_type

			// ResManager.GetInstance().LoadGameConfig(this, "config_num_by_vip_info", false, undefined, (obj) => {
			// 	let key = moduleId + "@" + subId
			// 	let info_cfg = obj
			// 	info_cfg = info_cfg && info_cfg[key]
			// 	let num_type = 0
			// 	if (info_cfg) {
			// 		num_type = info_cfg.num_type
			// 	}
			// 	ResManager.GetInstance().DestoryGameConfig(this, "config_num_by_vip_info")
			// 	return num_type
			// })

		}

		this.GetVipLevel = () => {
			return this.vipLevel || 0
		}

		this.GetExp = () => {
			return this.cur_exp || 0
		}

		this.GetTimeText = (time?) => {
			let dateStr = local_math.floor(time / 60 / 60 / 24)
			let hoursStr = local_math.floor(time / 60 / 60) % 24
			let minutesStr = local_math.floor(time / 60) % 60
			if (dateStr > 0) {
				return dateStr + "天" + hoursStr + "时" + minutesStr + "分"
			} else {
				return hoursStr + "时" + minutesStr + "分"
			}
		}

		this.GetWeekGiftNum = () => {
			ResManager.GetInstance().LoadGameConfig(this, "config_vip_config", false, undefined, (obj) => {
				let num = 0
				if (obj[this.vipLevel]) {
					num = obj[this.vipLevel].week_max_times
				}
				ResManager.GetInstance().DestoryGameConfig(this, "config_vip_config")
				return num
			})


		}

		this.GetCurWeekGiftNum = () => {
			return this.week_award_get_num || 0
		}

		this.GetNextStageExp = () => {
			return this.total_exp || 0
		}

		this.GetVipHide = () => {
			return this.vip_hide || 0
		}

		this.IsReceivedGift = (lv?) => {
			return this.has_get_award[lv]
		}

		this.SaveNobleCardInfo = (data?) => {
			this.active_card_type = false
			if (!this.noble_Card_info) {
				this.noble_Card_info = []
			}
			this.nobel_card_lv = 0
			let is_forever = false
			let have_card_invalid = false
			let showVip6Icon = false
			for (let _tmpi in data) {
				var card_data = data[_tmpi]
				this.noble_Card_info[card_data.card_type] = card_data
				if (card_data.is_active == 1 && (!(card_data.time != 0) || card_data.time > local_time.getServerTime())) {
					this.nobel_card_lv = 99
					if (!this.active_card_type || this.active_card_type < card_data.card_type) {
						this.active_card_type = card_data.card_type
					}
					if (card_data.is_forever) {
						is_forever = true
					}
				} else if ((card_data.is_active == 0 && card_data.time) && card_data.time < local_time.getServerTime()) {
					have_card_invalid = true
				}
			}
			this.CheckVipIcon()
			// if ((! this.active_card_type && have_card_invalid && ! is_forever && ! cookier.GetCookie(CookieLevelType.Common, CookieKey.VIP_INVALID_VIEW_SHOW_TIME) && roleMgr.GetMainRoleVo().vip_flag > 0) ) {
			// 	this.Fire(VipModel.OPEN_VIEW, "VipInvalidView")
			// 	cookier.SaveCookie(CookieLevelType.Common, CookieTimeType.TYPE_ALWAYS, CookieKey.VIP_INVALID_VIEW_SHOW_TIME, "1")
			// }
			this.CheckNobleRenewal()
		}

		this.GetRewards = (index?, obj?) => {
			if (this.select_vip_lv > this.max_vip_lv || this.select_vip_lv < 1) {
				return
			}
			if (!obj) {
				return
			}
			let vipData = obj[this.select_vip_lv]
			let weekData = vipData.week_rewards
			let goodDatas = vipData.rewards
			let goods = JSON.parse(goodDatas)
			let week = JSON.parse(weekData)
			return { goods_reward: goods, week_reward: week }
		}

		this.CheckVipIcon = () => {
			if (PlatformManager.GetInstance().is_alpha) {
				return
			}
			// 直升V4条件变动
			let main_role = RoleManager.GetInstance().GetMainRoleVo()
			let my_level = main_role.level
			let vip_level = main_role.vip_flag
			let acIconMgr = ActivityIconManager.GetInstance()

			if (my_level >= VipModel.VIP4_OPEN_LV && (!vip_level || vip_level < 4)) {
				let vip6Icon = acIconMgr.getIconInfo("450@1")
				if (!vip6Icon) {
					acIconMgr.addIcon("450@1")
				}
			} else {
				let vip6Icon = acIconMgr.getIconInfo("450@1")
				if (vip6Icon) {
					acIconMgr.deleteIcon("450@1")
				}
			}
			//TODO:购买之后刷新界面
			this.Fire(VipModel.CHANGE_DISCOUNT_IMG_AND_REFRESH_CARD_ITEM)
		}

		this.CanReceiveGift = (lv?) => {
			if ((lv < 1 || lv > this.max_vip_lv) || lv > this.GetVipLevel()) {
				return false
			}
			if (this.IsReceivedGift(lv)) {
				return false
			} else {
				return true
			}
		}

		this.CheckMoney = (cost_gold?, type_id?) => {
			let money = roleMgr.GetMainRoleVo().jin
			if (money < cost_gold) {
				let ok = () => {

				}

				Alert.Show("勾玉不足" + cost_gold + ",是否前往充值?", Alert_Type.Two, ok, null, "充值", "取消")
				return false
			} else {
				let ok = () => {
					Alert.Show("是否确定购买", Alert_Type.Two, ok, null, "确定", "取消")
				}

				return true
			}
		}

		this.CheckNobleRenewal = () => {
			let info = this.noble_Card_info
			if (!info) {
				return
			}
			let renewal = []
			for (let index in info) {

				let _time = info[index].time - local_time.getServerTime()
				if (info[index].is_never == 0 || _time < 0) {
					table.insert(renewal, info[index].type_id)
				}
			}
			return renewal
		}

		this.GetNobleCardInfo = (type_id?) => {
			return this.noble_Card_info[type_id]
		}

		this.GetNobleCardState = () => {
			return this.nobel_card_lv
		}

		this.SetRechargeProductList = (scmd?) => {
			//RuntimePlatform = []
			//RuntimePlatform.IPhonePlayer = 1
			//Application = []
			//Application.platform = 1
			let obj = Config.PRELOAD_SERVER_CONFIG.config_recharge_product

			this.recharge_product_list = Util.DeepCopy(scmd.product_list)
			this.show_real_recharge_product_list = []
			let data = { product_list: [] }
			data.product_list = scmd.product_list
			// if (PlatformMgr.GetInstance().IsEyouPlatform()) { //eyou平臺儲值卡處理
			// 	data = this.EyouPlatformRecharge(scmd)
			// } else if (PlatformMgr.GetInstance().IsEyouKrPlatform()) { //韓文
			// 	data = this.EyouKrPlatformRecharge(scmd)
			// }
			//審核服判斷操作
			if (PlatformManager.GetInstance().is_alpha) { //審核服
				if (data && data.product_list) {
					let remove_index_list = []
					for (let i = 0; i < data.product_list.length; i++) {
						var v = data.product_list[i]
						let cfg = obj[v.product_id]
						if (cfg == null || v.product_id == 0) {
							table.insert(remove_index_list, i)
						}
					}
					let del_num = 0
					for (let i = 0; i < remove_index_list.length; i++) {
						var v = remove_index_list[i]
						let index = v - del_num
						table.remove(data.product_list, index)
						del_num = del_num + 1
					}
				}
			} else {  	//非審核服，顯示大類是1, 2的儲值卡
				if (data && data.product_list) {
					let remove_index_list = []
					for (let i = 0; i < data.product_list.length; i++) {
						var v = data.product_list[i]
						let cfg = obj[v.product_id]
						//写死0不显示，作为首充用
						if (cfg == null || v.product_id == 0 || (cfg.product_type != 1 && cfg.product_type != 2)) {
							table.insert(remove_index_list, i)
						}
					}
					let del_num = 0
					for (let i = 0; i < remove_index_list.length; i++) {
						var v = remove_index_list[i]
						let index = v - del_num
						table.remove(data.product_list, index)
						del_num = del_num + 1
					}
				}
			}
			if (ClientConfig.HideChargeIds) { //某些手機包需要屏蔽某些儲值卡
				let remove_index_list = []
				if (data && data.product_list) {
					for (let i = 0; i < data.product_list.length; i++) {
						var v = data.product_list[i]
						for (let j = 0; j < ClientConfig.HideChargeIds.length; j++) {
							var vo = ClientConfig.HideChargeIds[j]
							if (v.product_id == Number(vo)) {
								table.insert(remove_index_list, i)
								break
							}
						}
					}
				}
				let del_num = 0
				for (let i = 0; i < remove_index_list.length; i++) {
					var v = remove_index_list[i]
					let index = v - del_num
					table.remove(data.product_list, index)
					del_num = del_num + 1
				}
			}
			let sort_fun = (a?, b?) => {
				if (a && b) {
					let a_cfg = obj[a.product_id]
					let b_cfg = obj[b.product_id]
					if ((a_cfg && b_cfg)) {
						return Number(a_cfg.money) < Number(b_cfg.money)
					}
				}
			}
			table.sort(data.product_list, sort_fun)
			this.show_real_recharge_product_list = data.product_list
		}

		//篩選出eyou平臺的用的儲值配置
		this.EyouPlatformRecharge = (data?) => {
			// if (RuntimePlatform && data && data.product_list) {
			// 	let remove_index_list = []
			// 	if (Application.platform == RuntimePlatform.IPhonePlayer) { //蘋果手機
			// 		if (PlatformMgr.GetInstance().IsTWAreaCurrency()) { //臺灣地區
			// 			for (let i = 0; i < data.product_list.length; i++) {
			// 				var v = data.product_list[i]
			// 				let cfg = Config.RechargeEyouIOSTwProduct[v.product_id]
			// 				if (cfg == null) {
			// 					table.insert(remove_index_list, i)
			// 				}
			// 			}
			// 		} else { //非臺灣地區
			// 			for (let i = 0; i < data.product_list.length; i++) {
			// 				var v = data.product_list[i]
			// 				let cfg = Config.RechargeEyouIOSNotTwProduct[v.product_id]
			// 				if (cfg == null) {
			// 					table.insert(remove_index_list, i)
			// 				}
			// 			}
			// 		}
			// 	} else if (Application.platform == RuntimePlatform.Android) { //安卓
			// 		if (PlatformMgr.GetInstance().IsTWAreaCurrency()) { //臺灣地區
			// 			for (let i = 0; i < data.product_list.length; i++) {
			// 				var v = data.product_list[i]
			// 				let cfg = Config.RechargeEyouAndroidTwProduct[v.product_id]
			// 				if (cfg == null) {
			// 					table.insert(remove_index_list, i)
			// 				}
			// 			}
			// 		} else { //非臺灣地區
			// 			for (let i = 0; i < data.product_list.length; i++) {
			// 				var v = data.product_list[i]
			// 				let cfg = Config.RechargeEyouAndroidNotTwProduct[v.product_id]
			// 				if (cfg == null) {
			// 					table.insert(remove_index_list, i)
			// 				}
			// 			}
			// 		}
			// 	}
			// 	let del_num = 0
			// 	for (let i = 0; i < remove_index_list.length; i++) {
			// 		var v = remove_index_list[i]
			// 		let index = v - del_num
			// 		table.remove(data.product_list, index)
			// 		del_num = del_num + 1
			// 	}
			// }
			// return data
		}
		//显示在充值界面的充值卡
		this.GetShowRechargeProductList = () => {
			return this.show_real_recharge_product_list
		}

		//this.GetRechargeProductList = () => {
		//return this.recharge_product_list
		//}
		//刷新数据
		this.SetRechargeOneProduct = (scmd?) => {
			if (this.recharge_product_list) {
				for (let key in this.recharge_product_list) {

					if (this.recharge_product_list[key].product_id == scmd.product_id) {
						this.recharge_product_list[key].return_type = scmd.return_type
					}
				}
				for (let key in this.show_real_recharge_product_list) {

					if (this.show_real_recharge_product_list[key].product_id == scmd.product_id) {
						this.show_real_recharge_product_list[key].return_type = scmd.return_type
					}
				}
			}
		}

		this.HaveFirstRecharge = () => {
			if (this.recharge_product_list) {
				for (let key in this.recharge_product_list) {

					if (this.recharge_product_list[key].return_type == 1) {
						return true
					}
				}
			}
			return false
		}

		this.SetRechargeIconRed = (bool?) => {
			this.recharge_red = bool
		}

		this.GetRechargeIconRed = () => {
			return this.recharge_red
		}

		this.GetMaxVipCardType = () => {
			let type = 0
			if (this.noble_Card_info) {
				for (let key in this.noble_Card_info) {

					let vo = this.noble_Card_info[key]
					if (vo) {
						if (vo.is_active == 1 && vo.card_type > type) {
							type = vo.card_type
						}
					}
				}
			}
			return type
		}

		this.IsInvalidCard = () => {
			let now = local_time.getServerTime()
			let active = false //激活过特权卡
			for (let key in this.noble_Card_info) {

				let vo = this.noble_Card_info[key]
				if (!active && vo.time > 0) { //过期时间大于0代表使用过特权卡
					active = true
				}
				if (vo.is_active && (vo.is_forever == 1 || vo.time > now)) {
					return false
				}
			}
			if (active) {
				return true
			} else {
				return false
			}
		}

		this.SetRechargeRecord = (value?) => {
			this.all_recharge_record = value
			//WelfareModel.GetInstance().Fire(WelfareEvent.SHOW_SVIP_ICON)
		}
		//eyou第三方儲值卡返還映射
		this.EyouCardReturnMapping = (product_id?) => {
			let return_type = null
			if (this.recharge_product_list) {
				let cfg = this.GetEyouCardReturnMappingCfg(product_id)
				if (cfg) {
					for (let i = 0; i < this.recharge_product_list.length; i++) {
						var v = this.recharge_product_list[i]
						if (v.product_id == Number(cfg.mapping_product_id)) {
							return_type = v.return_type
							break
						}
					}
				}
			}
			return return_type
		}
		//eyou第三方儲值卡返還映射配置
		this.GetEyouCardReturnMappingCfg = (product_id?) => {
			// let cfg = null
			// if (Config.RechargeEyouReturnMapping) {
			// 	for (let k in Config.RechargeEyouReturnMapping) {
			// 		var v = Config.RechargeEyouReturnMapping[k]
			// 		if (v.product_id == product_id) {
			// 			cfg = v
			// 			break
			// 		}
			// 	}
			// }
			// return cfg
		}
		//篩選出eyou平臺的用的儲值配置
		this.EyouKrPlatformRecharge = (data?) => {
			// if (RuntimePlatform && data && data.product_list) {
			// 	let remove_index_list = []
			// 	if (Application.platform == RuntimePlatform.IPhonePlayer) { //蘋果手機
			// 		for (let i = 0; i < data.product_list.length; i++) {
			// 			var v = data.product_list[i]
			// 			let cfg = Config.RechargeEyouKrIosProduct[v.product_id]
			// 			if (cfg == null) {
			// 				table.insert(remove_index_list, i)
			// 			}
			// 		}
			// 	} else if (Application.platform == RuntimePlatform.Android) { //安卓
			// 		for (let i = 0; i < data.product_list.length; i++) {
			// 			var v = data.product_list[i]
			// 			let cfg = Config.RechargeEyouKrAndroidProduct[v.product_id]
			// 			if (cfg == null) {
			// 				table.insert(remove_index_list, i)
			// 			}
			// 		}
			// 	}
			// 	let del_num = 0
			// 	for (let i = 0; i < remove_index_list.length; i++) {
			// 		var v = remove_index_list[i]
			// 		let index = v - del_num
			// 		table.remove(data.product_list, index)
			// 		del_num = del_num + 1
			// 	}
			// }
			// return data
		}
	}

	public static GetInstance() {

		if (!VipModel.Instance) {
			VipModel.Instance = new VipModel()
		}
		return VipModel.Instance
	}

	public HasTempCard() {

		for (let k in this.noble_Card_info) {
			var v = this.noble_Card_info[k]
			if (1 == v.is_active && 1 == v.is_temp_card) {
				return true
			}
		}
		return false
	}

	public ShowNameBoardTips() {

		return TaskModel.GetInstance().newest_finish_task_id < this.showNameBoardTaskId
	}
}

window["VipModel"] = VipModel