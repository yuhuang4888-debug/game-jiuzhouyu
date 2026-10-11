import { BaseItem1 } from "../common/BaseItem1"
import { KaifuActivityModel } from "../commonModel/KaifuActivityModel"
import { TimeUtil } from "../util/TimeUtil"
import { KaifuActivityModelEvent } from "../commonModel/KaifuActivityModel"
import { investType } from "../commonModel/KaifuActivityModel"
import { KAIFUACTIVITY_CONFIG } from "../commonModel/KaifuActivityModel"
import { ResManager } from "../common/ResManager"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"
import { Alert, Alert_Type } from "../alert/Alert"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"
import { ErlangParser } from "../util/ErlangParser"
import { Message } from "../sysInfo/SysInfoController"
import { ColorUtil } from "../util/ColorUtil"
import { CookieWrapper } from "../common/CookieWrapper"
import { RoleManager } from "../commonModel/RoleManager"
import { OpenFun } from "../common/OpenFun"
import { MonthCardItem } from "./MonthCardItem"
import { table } from "../common/table"
import { GoodsModel } from "../commonModel/GoodsModel"
import { VipModel } from "../commonModel/VipModel"
import { PlatformManager } from "../PlatformManager"
import { EquipmentItem } from "../common/EquipmentItem"
export class MonthCardView extends BaseItem1 {

	InitEvent
	LoadSuccess
	PriceType2Desc
	SaveCookie
	UpdateView
	InitItem
	LocalDeleteMe

	id
	level
	outl_lb_desc
	state

	public static className = "MonthCardView"
	public constructor(parent?) {
		super(parent)


		this.base_file = "invest"
		this.layout_file = "MonthCardView"
		let _model = KaifuActivityModel.GetInstance()
		let cookie_wrapper = CookieWrapper.GetInstance()
		// let MONTH_INVEST_RED_TIME = CookieKey.MONTH_INVEST_RED_TIME
		let local_TimeUtil = TimeUtil
		let local_KaifuActivityModelEvent = KaifuActivityModelEvent
		let local_investType = investType
		let local_KAIFUACTIVITY_CONFIG = KAIFUACTIVITY_CONFIG
		this.is_load_res = false
		let item_list_ = []
		let reward_item
		let MONTH_CARD_TYPE = "2@1"
		this.preload_server_config = {
			"config_recharge_product": false,
			"config_investment_types": false
		}
		this.load_callback = () => {
			if(PlatformManager.IsEyouPlatform()){
				this.tip.y = 898
				this.tip.style.width = 470
				this.tip.style.wordWrap = true
				this.tip.style.leading = 0.1
			}
		this.tip.innerHTML = "现在购买立得<font color='#0a953e'>250</font>勾玉和<font color='#0a953e'>250</font>绑玉，享受超多月卡特权"
			if(PlatformManager.IsEyouPlatform()){
				this.tip.style.width = 470
			}
			this.InitItem()
			this.LoadSuccess()
			this.InitEvent()
		}

		this.SaveCookie = () => {
			let cookie_time = CookieWrapper.Instance.GetCookie(CookieWrapper.MONTH_INVEST_RED_TIME)
			if (!cookie_time || local_TimeUtil.getServerTime() > Number(cookie_time)) {
				CookieWrapper.Instance.SaveCookie(CookieWrapper.MONTH_INVEST_RED_TIME, String(local_TimeUtil.GetFutureZeroStamp(1)))

				_model.upateInvestRedDot(local_investType.month)
			}
		}

		this.LoadSuccess = () => {

			this.UpdateView()
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this._gp_get, () => {
				if (0 == this.state) {
					let my_vip = RoleManager.GetInstance().GetMainRoleVo().vip_flag
					// if (Number(my_vip) < 4) {
					// 	Alert.Show(`升至VIP4可购买月卡投资。`, Alert_Type.Two, () => {
					// 		OpenFun.OpenFunHandler(23)
					// 	}
					// 		, null, "前往提升", "取消")
					// }
					//else {
					if (this.level) {
						// let key = local_investType.month + "@" + this.level
						// let cfg = _model.getConfig(local_KAIFUACTIVITY_CONFIG.INVESTMENT_TYPES)
						// if (cfg && cfg[key]) {
						// 	let cond = JSON.parse(cfg[key].condition)
						// 	let reward = cond[0][1]
						// 	if (CustomActivityModel.GetInstance().CheckMoney(Number(reward[0][2]))) {
						// 		Alert.Show(Util.StrToHTML("是否花费<font color='#0a953e'>300</font>勾玉进行月卡投资"), Alert_Type.Two, () => {
						// 			_model.Fire(local_KaifuActivityModelEvent.SEND_INVEST_LEVEL, local_investType.month, this.level)
						// 		}
						// 			, null, "确定", "取消")
						// 	}
						// }


						let cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_recharge_product", false)
						let product_info_ = cfg[108]
						let hasNum: number = GoodsModel.GetInstance().GetTypeGoodsNum(36210008) // 写死默认拿这个道具
						if (hasNum >= 8) {
							VipModel.GetInstance().Fire(VipModel.REQUEST_PROTO, 15804, 'i', 108)
						}
						else {
							if (product_info_) {

								PlatformManager.GetInstance().PayRequest(product_info_.money, { id: product_info_.product_id, pay_title: product_info_.product_name }, (ret) => {
									if (ret == 'SUCCESS') {
										//model.Fire(WeekCardModel.REQUEST_PROTO, 45201)
									}
								})
							}
						}
					}
					//}

				} else if (1 == this.state) {
					if (this.id) {
						_model.Fire(local_KaifuActivityModelEvent.GET_INVEST, local_investType.month, this.id)
					}
				} else if (2 == this.state) {
					Message.show("今日已领取")
				}
			}
				, this, true)
			let update_data = (type?) => {
				if (type == local_investType.month) {
					this.UpdateView()
				}
			}

			this.BindEvent(_model, local_KaifuActivityModelEvent.INVEST_DATA_UPDATE, update_data)
		}

		this.UpdateView = () => {
			let data = _model.getInvestData(local_investType.month)
			if (data) {
				if (data.cur_lv <= 0 || !data.cur_lv) {
					this.state = 0
					let cfg = _model.investConfig(local_investType.month, local_KAIFUACTIVITY_CONFIG.INVESTMENT_TYPES)
					let info = cfg[0]
					this.level = info.level
					let price = info.price
					let price_type = this.PriceType2Desc(info.price_type)
					this._lb_desc.text = "25元抢购"
					let my_vip = RoleManager.GetInstance().GetMainRoleVo().vip_flag
					this._lb_tips.innerHTML = ""
					this._gp_get.centerX = 45
					//}
				} else {
					this._gp_get.centerX = 4
					let max_id = 0
					for (let key in data.rewards) {

						let vo = data.rewards[key]
						if (!max_id || vo.id > max_id) {
							max_id = vo.id
						}
					}
					this._lb_tips.innerHTML = "（剩余<font color='#0a953e'>" + (30 - max_id) + "</font>天）可领取"
					let left_day = 30 - max_id
					let bool = true
					if (data.get_time > 0) {
						let time_date = new Date(data.get_time * 1000)
						time_date.setHours(0, 0, 0)
						let time = Math.floor(time_date.getTime() / 1000) + 24 * 60 * 60
						bool = local_TimeUtil.getServerTime() >= time
					}
					if (bool) {
						this.state = 1
						this.id = max_id + 1
					} else {
						this.state = 2
					}
					if (this.state == 1) {
						this._lb_desc.text = "领取"
					} else if (this.state == 2) {
						this._lb_desc.text = "明天可领"
					}
					if (30 - max_id == 0)
						this._lb_desc.text = "明天可买"
				}
				this._img_red.visible = this.state == 1
				//this._lb_tips.visible = this.state > 0
			}
		}

		this.PriceType2Desc = (show_price_type?) => {
			let price_type = ""
			if (1 == show_price_type) {
				price_type = "com_diamond"
			} else if (2 == show_price_type) {
				price_type = "com_bind_diamond"
			} else if (3 == show_price_type) {
				price_type = "com_gold"
			}
			return price_type
		}

		this.InitItem = () => {
			for (let i = 0; i < 4; i++) {
				let item = item_list_[i]
				if (!item) {
					item = new MonthCardItem(this.item_gp)
					item.Load()
					table.insert(item_list_, item)
				}
				item.Setdata(i)
			}

			let cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_investment_types", false)
			let reward_list = JSON.parse(cfg && cfg[MONTH_CARD_TYPE] && cfg[MONTH_CARD_TYPE].condition)
			if (!reward_list) return
			let reward
			for (let key in reward_list) {
				let vo = reward_list[key]
				if (vo[0] == "show_reward") {
					reward = vo[1][0]
				}
			}
			if (reward) {
				let item: EquipmentItem = reward_item
				if (!item) {
					item = new EquipmentItem(this.reward_gp)
					item.Load()
					reward_item = item
					item.SetItemSize(100, 100)
				}
				let [type_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(reward[0], reward[1])
				item.SetData(reward[1], reward[2])
			}

		}

		this.LocalDeleteMe = () => {
			if (item_list_ && item_list_.length > 0) {
				for (let _tmpi in item_list_) {
					let obj = item_list_[_tmpi]
					obj.DeleteMe()
				}
				item_list_ = null
			}
			if (reward_item) {
				reward_item.DeleteMe()
			}
			reward_item = null
		}

		this.SaveCookie()
	}

	public DeleteMe() {
		this.LocalDeleteMe()
		super.DeleteMe()
	}




	tip: Laya.HTMLDivElement
	_lb_tips: Laya.HTMLDivElement
	reward_gp: Laya.Box
	item_gp: Laya.VBox
	_gp_get: Laya.Box
	_img_btn: Laya.Image
	gp1: Laya.Box
	_lb_desc: Laya.Label
	_img_red: Laya.Image
	public GetComponents() {
		[
			this.tip,
			this._lb_tips,
			this.reward_gp,
			this.item_gp,
			this._gp_get,
			this._img_btn,
			this.gp1,
			this._lb_desc,
			this._img_red,
		]
			= this.GetChildrenByNames([

				"tip",
				"_lb_tips",
				"reward_gp",
				"item_gp",
				"_gp_get",
				"_img_btn",
				"gp1",
				"_lb_desc",
				"_img_red",
			])
		this._lb_tips.style.fontSize = 20
		this._lb_tips.style.color = "#663915"
		this._lb_tips.style.wordWrap = false
		this.tip.style.fontSize = 20
		this.tip.style.color = "#663915"
		this.tip.style.wordWrap = false
	}
}
window["MonthCardView"] = MonthCardView