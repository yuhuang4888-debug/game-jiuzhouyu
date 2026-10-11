import { Alert, Alert_Type } from "../alert/Alert"
import { BaseItem1 } from "../common/BaseItem1"
import { EventName } from "../common/EventName"
import { Enum_UILayer } from "../common/LayerManager"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { DailyModel } from "../commonModel/DailyModel"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { ErlangParser } from "../util/ErlangParser"
import { Util, Trim } from "../util/Util"
import { DailyEvent } from "./DailyEvent"
import { DailyResFindItem } from "./DailyResFindItem"

export class DailyResFindView extends BaseItem1{
	GetTotalPrice
	InitContent
	RefreshCheckBoxState
	SetData
	SetReceiveGpStage
	SortFun
	bag_loop_mgr
	LoadSuccess
	InitEvents
	public constructor(parent?) {
		super(parent)
		this.base_file = "daily"
		this.layout_file = "DailyResFindView"
		this.layer_value = Enum_UILayer.UI
		let model = DailyModel.GetInstance()
		let local_DailyEvent = DailyEvent
		let local_Util = Util
		let local_Erlang = ErlangParser.GetInstance()
		let _data = null
		let _res_data = null
		let _arrayCollection = null
		//this.use_local_view = true
		this.bag_loop_mgr = null
		this.load_callback = () => {
			this.LoadSuccess()
			this.InitEvents()
		}

		this.LoadSuccess = () => {
			this.Content.scrollBar.visible = false
			// this.RegisterMask(this.scroll_group)
			model.Fire(local_DailyEvent.DAILY_REQUEST_PROTO, 41900)
			model.resFindCheck = [false, true]
		}

		this.InitEvents = () => {
			let update_fun = () => {
				this.SetData()
			}
			this.BindEvent(model, local_DailyEvent.UPDATE_RES_FIND_DATA, update_fun)

			Util.AddClickEvent(this.checkBtn0, () => {
				if (model.resFindCheck[0]) {
					return
				}
				model.resFindCheck = [true, false]
				this.RefreshCheckBoxState()
			}, this)
			Util.AddClickEvent(this.checkBtn1, () => {
				if (model.resFindCheck[1]) {
					return
				}
				model.resFindCheck = [false, true]
				this.RefreshCheckBoxState()
			}, this)

			Util.AddClickEvent(this.receive_gp, () => {
				if (this._Image3.gray) {
					return
				}
				let [money_type, total_price] = this.GetTotalPrice()
				let str = null
				if (money_type == 1) {
					str = "是否使用<font color='#639c12'>" + total_price + "绑玉</font>一键找回所有奖励？\n(绑玉不足时消耗勾玉代替)"
				} else if (money_type == 2) {
					str = "是否一键免费找回所有奖励？"
				}
				let content = str
				if (Trim(content) != "") {
					Alert.Show(content, Alert_Type.Two, () => {
						model.Fire(local_DailyEvent.RES_FIND_REQUEST_PROTO, 41904, "c", money_type)
					})
					if (money_type == 1) {
						Alert.SetIsCharge(true)
					}
				}
			}, this)
			this.SetData()
		}

		this.SetData = () => {
			_res_data = model.res_find_data
			//let data = OutLineModel.GetInstance().GetOutlineFindData()
			let data = null
			let have = false
			if (_res_data && _res_data.length >= 0) {
				for (let i = 0; i < _res_data.length; i++) {
					if (_res_data[i].act_id == -1 && _res_data[i].act_sub == 132) {
						if (data) {
							_res_data[i] = data
						} else {
							_res_data.splice(i, 1)
						}
						have = true
						break
					}
				}
				if (!have && data) {
					_res_data.push(data)
				}
				if (!_res_data) {
					return
				}
				this.none_conta.visible = !(_res_data.length > 0)
				this.checkBtn0.visible = _res_data.length > 0
				//this.lineImg.visible = this.checkBtn0.visible 
				this.checkBtn1.visible = _res_data.length > 0
				this.receive_gp.visible = _res_data.length > 0
				if (_res_data.length > 0) {
					model.res_find_dot_not_show = true
					GlobalEventSystem.Fire(EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "DailyView", 3, false)
				}
				this.RefreshCheckBoxState()
				this.SetReceiveGpStage()
			}
		}

		this.RefreshCheckBoxState = () => {
			let img_source = (model.resFindCheck[0] == true) && "com_ui_gx1" || "com_ui_gx"
			ResManager.GetInstance().SetImageSprite(this, this.check_img0, "common_asset", img_source)
			let img_source2 = (model.resFindCheck[1] == true) && "com_ui_gx1" || "com_ui_gx"
			ResManager.GetInstance().SetImageSprite(this, this.check_img1, "common_asset", img_source2)
			this.InitContent()
		}

		this.InitContent = () => {
			let bag_list = _res_data && _res_data || {}
			bag_list = this.SortFun(bag_list)
			if (!this.bag_loop_mgr) {
				this.bag_loop_mgr = new LoopScrowViewMgr()
				this.bag_loop_mgr.SetData(this.Content, DailyResFindItem, bag_list, LoopScrCon.Vertical)
			} else {
				this.bag_loop_mgr.replaceAll(bag_list)
			}
		}

		this.SortFun = (bag_list?) => {
			if (model.resFindCheck[0]) {
				let sort_fun = (a?, b?) => {
					let a_times = a.lefttimes + a.lefttimes_vip
					let b_times = b.lefttimes + b.lefttimes_vip
					if (a_times == b_times) {
						return a.act_id < b.act_id
					} else {
						return a_times > b_times
					}
				}
				table.sort(bag_list, sort_fun)
			} else {
				let sort_fun = (a?, b?) => {
					if (a.lefttimes == b.lefttimes) {
						return a.act_id < b.act_id
					} else {
						return a.lefttimes > b.lefttimes
					}
				}
				table.sort(bag_list, sort_fun)
			}
			return bag_list
		}

		this.GetTotalPrice = () => {
			let bag_list = _res_data ? _res_data : []
			let money_type
			let total_price = 0
			if (bag_list.length > 0 && model.resFindCheck[0]) {
				money_type = 1
				for (let i = 0; i < bag_list.length; i++) {
					if (bag_list[i].act_id == -1 && bag_list[i].act_sub == 132) continue
					let price = JSON.parse(bag_list[i].config_res_act.gold_per)
					let num = Number(bag_list[i].lefttimes)
					let money = Number(price[0][2]) * num
					total_price += Number(money)
				}
			}
			else if (bag_list.length > 0 && model.resFindCheck[1]) {
				money_type = 2
				for (let i = 0; i < bag_list.length; i++) {
					if (bag_list[i].act_id == -1 && bag_list[i].act_sub == 132) continue
					let price = JSON.parse(bag_list[i].config_res_act.coin_per)
					let num = Number(bag_list[i].lefttimes)
					let money = Number(price[0][2]) * num
					total_price += Number(money)
				}
			}

			return [money_type, total_price]
		}

		this.SetReceiveGpStage = () => {
			let all_find = true
			let bag_list = _res_data ? _res_data : []
			if (bag_list.length > 0) {
				for (let i = 0; i < bag_list.length; i++) {
					if (bag_list[i].act_id == -1 && bag_list[i].act_sub == 132) continue
					if (bag_list[i].lefttimes > 0)
						all_find = false
				}
			}
			if (all_find) {
				Util.SetImageGray(this._Image3, true)
				this._Label1.stroke = 0
				//this.receive_gp.touchChildren = false
				//this.receive_gp.touchEnabled = this.receive_gp.touchChildren
			} else {
				Util.SetImageGray(this._Image3, false)
				this._Label1.stroke = 2
				//this.receive_gp.touchChildren = true
				//this.receive_gp.touchEnabled = this.receive_gp.touchChildren
			}
		}
	}
	public DeleteMe() {
		if (this.bag_loop_mgr) {
			this.bag_loop_mgr.DeleteMe()
			this.bag_loop_mgr = null
		}
		super.DeleteMe()
	}

	image: Laya.Image
	lineImg: Laya.Image
	scroll: Laya.Panel
	Content: Laya.List
	none_conta: Laya.Box
	_Image1: Laya.Image
	tips: Laya.Label
	tips_icon: Laya.Image
	_Image2: Laya.Image
	_Group1: Laya.Box
	checkBtn0: Laya.Box
	check_img0: Laya.Image
	check_label0: Laya.Label
	checkBtn1: Laya.Box
	check_img1: Laya.Image
	check_label1: Laya.Label
	receive_gp: Laya.Box
	_Image3: Laya.Image
	_Label1: Laya.Label
	public GetComponents() {
		[
			this.image,
			this.lineImg,
			this.scroll,
			this.Content,
			this.none_conta,
			this._Image1,
			this.tips,
			this.tips_icon,
			this._Image2,
			this._Group1,
			this.checkBtn0,
			this.check_img0,
			this.check_label0,
			this.checkBtn1,
			this.check_img1,
			this.check_label1,
			this.receive_gp,
			this._Image3,
			this._Label1,
		]
			= this.GetChildrenByNames([

				"image",
				"lineImg",
				"scroll",
				"Content",
				"none_conta",
				"_Image1",
				"tips",
				"tips_icon",
				"_Image2",
				"_Group1",
				"checkBtn0",
				"check_img0",
				"check_label0",
				"checkBtn1",
				"check_img1",
				"check_label1",
				"receive_gp",
				"_Image3",
				"_Label1",
			])
	}
}
window["DailyResFindView"] = DailyResFindView