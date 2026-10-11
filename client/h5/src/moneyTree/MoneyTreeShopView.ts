import { BaseView1 } from "../common/BaseView1"
import { CongratulationObtainView } from "../common/CongratulationObtainView"
import { Enum_UILayer } from "../common/LayerManager"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { CustomActivityDefine } from "../commonModel/CustomActivityDefine"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"
import { Message } from "../sysInfo/SysInfoController"
import { Util } from "../util/Util"
import { MoneyTreeShopItem } from "./MoneyTreeShopItem"

export class MoneyTreeShopView extends BaseView1 {
	_Image1: Laya.Image
	_Image2: Laya.Image
	_Image3: Laya.Image
	_Image4: Laya.Image
	_exchange: Laya.Box
	_Image11: Laya.Image
	labelDisplay: Laya.Label
	_rewards: Laya.List
	_close: Laya.Image
	_Label1: Laya.Label
	_score: Laya.Label
	InitEvent
	InitView
	OnClick
	Open
	click_bg_toClose
	destroy_imm
	is_center
	loop_mgr
	mask
	maskId
	show_open_movie
	use_background

	public constructor() {
		super()

		this.base_file = "moneyTree"
		this.layout_file = "MoneyTreeShopView"
		this.layer_value = Enum_UILayer.Activity
		this.destroy_imm = true
		this.is_center = true
		this.use_background = true
		this.click_bg_toClose = true
		this.show_open_movie = true
		let model = CustomActivityModel.GetInstance()
		let select_data = null
		let local_CustomActivityDefine = CustomActivityDefine
		let shop_data = null
		this.load_callback = () => {

			// this.mask = this.GetChild("_rewards/_gp_reward").GetComponent("Image")
			// this.maskId =  this.RegisterMask(this.mask)
			this.InitEvent()
			this.InitView()
		}

		let getShopList = () => {
			if (!shop_data) {
				return
			}
			let shop = shop_data.reward_list
			if (!shop || shop.length <= 0) {
				return
			}
			for (let _tmpi in shop) {
				var v = shop[_tmpi]
				v.currency = shop_data.currency
				v.base_type = shop_data.base_type
				v.sub_type = shop_data.sub_type
			}
			return shop
		}

		this.InitView = () => {
			if (!shop_data) {
				return
			}
			let shop = getShopList()
			if (!this.loop_mgr) {
				this.loop_mgr = new LoopScrowViewMgr()
				this.loop_mgr.SetData(this._rewards, MoneyTreeShopItem, shop, LoopScrCon.Vertical, 2, (item?) => {
					this.OnClick(item)
				}, null, this.maskId)
			}
			this.loop_mgr.replaceAll(shop)
			select_data = shop[0]
			this._score.text = shop_data.currency
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this._close, () => {
				this.Close()
			}
				, this, true)
			Util.AddClickEvent(this._exchange, () => {
				if (select_data && shop_data) {
					let cond = model.GetActCondition(select_data.base_type, select_data.sub_type, "data", select_data.grade)
					if (!cond) {
						return
					}
					let cost = cond["cost"] && cond["cost"][0]
					if (!cost) {
						return
					}
					let need = Number(cost[2])
					let max = Number(cond["exchange_num"])
					if ((need && shop_data.currency && need <= shop_data.currency) && (!max || (select_data.receive_times && max > select_data.receive_times))) {
						model.Fire(CustomActivityDefine.EVENT.SCMD_REQUEST, 33105, select_data.base_type, select_data.sub_type, select_data.grade)
					} else if ((need && shop_data.currency && need > shop_data.currency)) {
						Message.show("积分不足")
					} else if ((max && select_data.receive_times && max <= select_data.receive_times)) {
						Message.show("兑换次数不足")
					}
				} else {
					Message.show("请选择兑换物品")
				}
			}
				, this, true)

			//this._gp_reward.addEventListener(Laya.ItemTapEvent.ITEM_TAP, OnClick, this)

			this.BindEvent(model, local_CustomActivityDefine.EVENT.ANSWER_TARGET, (...new_args) => {
				let args = new_args
				if ((shop_data && shop_data.base_type == args[0]) && shop_data.sub_type == args[1]) {
					if (args[3] && args[3].reward) {
						let reward = model.GetActReward(args[0], args[1], args[3].form_type, args[3].reward)
						if (reward && reward.length) {
							let view = new CongratulationObtainView(reward, 10)
							view.Open()
						}
					}
					shop_data = model.GetActData(args[0], args[1])
					if (shop_data) {
						let shop = getShopList()
						this.loop_mgr.replaceAll(shop)
						this._score.text = shop_data.currency
					}
				}
			}
			)
			let get_reward = (...new_args) => {
				let args = new_args
				if (args[0] == shop_data.base_type && args[1] == shop_data.sub_type) {
					shop_data = model.GetActData(args[0], args[1])
					if (shop_data) {
						let shop = getShopList()
						this.loop_mgr.replaceAll(shop)
						this._score.text = shop_data.currency
					}
				}
			}

			this.BindEvent(model, local_CustomActivityDefine.EVENT.UPDATE_VIEW, get_reward)
		}

		this.OnClick = (item?) => {
			let obj = item
			let shop = getShopList()
			if (shop) {
				select_data = shop[obj]// obj.data
			} else {
				select_data = null
			}
		}

		this.Open = (...new_args) => {
			let parms = new_args
			shop_data = parms[0]
			super.Open()
		}


	}
	public DeleteMe() {
		if (this.loop_mgr) {
			this.loop_mgr.DeleteMe()
			this.loop_mgr = null
		}
		super.DeleteMe()
	}

	public GetComponents() {
		[
			this._Image1,
			this._Image2,
			this._Image3,
			this._Image4,
			this._exchange,
			this._Image11,
			this.labelDisplay,
			this._rewards,
			this._close,
			this._Label1,
			this._score,
		]
			= this.GetChildrenByNames([

				"_Image1",
				"_Image2",
				"_Image3",
				"_Image4",
				"_exchange",
				"_Image11",
				"labelDisplay",
				"_rewards",
				"_close",
				"_Label1",
				"_score",
			])
		this._rewards.scrollBar.visible=false
	}
}
window["MoneyTreeShopView"]=MoneyTreeShopView