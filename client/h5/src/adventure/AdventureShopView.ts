import { Alert, Alert_Type } from "../alert/Alert"
import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { AdventureModel } from "../commonModel/AdventureModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { RoleManager } from "../commonModel/RoleManager"
import { Message } from "../sysInfo/SysInfoController"
import { GameResPath } from "../util/GameResPath"
import { TimeUtil } from "../util/TimeUtil"
import { Util, NotEnougnDiamond, Trim, GlobalTimerQuest, RefGridLayout } from "../util/Util"
import { AdventureShopItem } from "./AdventureShopItem"

export class AdventureShopView extends BaseView1 {
	_Image1: Laya.Image
	_Image2: Laya.Image
	_Image3: Laya.Image
	_Image4: Laya.Image
	_img_close: Laya.Image
	_gp_btn: Laya.Box
	_Image5: Laya.Image
	_Group1: Laya.HBox
	_lb_ref: Laya.Label
	_img_cost: Laya.Image
	_lb_cost: Laya.Label
	_Scroller1: Laya.Panel
	Content: Laya.Box
	_lb_time: Laya.HTMLDivElement
	line_1: Laya.Image
	line_2: Laya.Image
	DestroyCallback
	InitEvent
	InitView
	OnTimer
	RefCost
	RefItem
	click_bg_toClose
	destroy_callback
	destroy_imm
	is_center
	not_show_item_use
	open_callback
	show_open_movie
	use_background



	public constructor() {
		super()
		this.base_file = "adventure"
		this.layout_file = "AdventureShopView"
		this.is_center = true
		this.use_background = true
		this.destroy_imm = true
		this.not_show_item_use = true
		this.click_bg_toClose = true
		this.show_open_movie = true
		this.layer_value = Enum_UILayer.Activity
		let local_AdventureModel = AdventureModel
		let goods_model = GoodsModel.GetInstance()
		let local_TimeUtil = TimeUtil
		let model = AdventureModel.GetInstance()
		let item_list_ = []
		let timer_ = null
		let data_ = null
		let cost_ = null
		let cost_basic_ = null
		this.load_callback = () => {
			this.InitEvent()
		}

		this.open_callback = () => {
			this.InitView()
		}

		this.destroy_callback = () => {
			this.DestroyCallback()
		}

		this.InitEvent = () => {
			ResManager.GetInstance().SetOutsideImageSprite(this, this._Image1, GameResPath.GetIcon("adventure", "uittmx_026"), true)
			// ResManager.GetInstance().SetOutsideImageSprite(this, this._Image2, GameResPath.GetIcon("adventure", "uittmx_026"), true)
			ResManager.GetInstance().SetOutsideImageSprite(this, this._Image3, GameResPath.GetIcon("adventure", "uittmx_024"), true)
			ResManager.GetInstance().SetImageSprite(this, this._Image4, "adventure", "uittmx_023", true)
			ResManager.GetInstance().SetTexture(this,this.line_1,GameResPath.GetIcon("adventure","ui_tb_13"))
			ResManager.GetInstance().SetTexture(this,this.line_2,GameResPath.GetIcon("adventure","ui_tb_13"))
			Util.AddClickEvent(this._img_close, () => {
				this.Close()
			}
				, this, true)
			this.BindEvent(model, local_AdventureModel.UPDATE_SHOPVIEW, () => {
				this.InitView()
			}
			)
			Util.AddClickEvent(this._gp_btn, () => {
				let left_time = model.GetZoreStatus()
				if (left_time > 0) {
					Message.show("商店0点刷新中")
					return
				}
				let request = () => {
					model.Fire(local_AdventureModel.REQUEST_SCMD, 42706)
				}
				if (((data_ && cost_) && cost_basic_) && model.alert_status["alert_shop_ref"]) {
					let need_num = cost_.count
					let have_num = RoleManager.GetInstance().mainRoleInfo.jin
					let name = cost_basic_.goods_name
					let alert_ref = false
					let ok_callback = () => {
						if (alert_ref) {
							model.alert_status["alert_shop_ref"] = false
						}
						if (need_num > have_num) {
							NotEnougnDiamond()
						} else {
							request()
						}
					}
					let check_func = () => {
						alert_ref = !alert_ref
					}
					let str = "是否消耗<font color='#639c12'>" + need_num + Trim(name) + "</font>进行刷新"
					Alert.Show(Util.StrToHTML(str), Alert_Type.AlertTypeCheckBox, ok_callback, null, null, null, null, null, check_func, "本次登录不再提示")
				} else {
					request()
				}
			}
				, this, true)
		}



		this.InitView = () => {
			let data = model.shop_data
			if (!data) {
				return
			}
			data_ = data
			if (!timer_) {
				let func = () => {
					this.OnTimer()
				}
				timer_ = GlobalTimerQuest.AddPeriodQuest(func, 1)
			}
			this.OnTimer()
			this.RefCost(data.refresh_cost)
			this.RefItem(data.goods_list)
		}

		this.RefItem = (goods_list?) => {
			if (item_list_.length > 0) {
				for (let _tmpi in item_list_) {
					var item = item_list_[_tmpi]
					item.visible = false
				}
			}
			let number = goods_list.length
			let count = 0
			if (goods_list && goods_list.length > 0) {
				for (let i in goods_list) {
					let item = item_list_[i]
					if (!item) {
						item = new AdventureShopItem(this.Content)
						item.Load()
						table.insert(item_list_, item)
					}
					item.ExcuteCallback(() => {
						count++
						if (count == number) {
							RefGridLayout(this.Content, {
								h_gap: 10,
								v_gap: 5,
								column: 3,
								item_w: 165,
								item_h: 255
							})
						}
						item.SetData(goods_list[i])
						item.visible = true
					}
					)
				}
			}
		}

		this.RefCost = (cost?) => {
			if (cost && cost.length > 0) {
				cost = cost[0]
				cost_ = cost
				let [type_id, lock] = goods_model.GetMappingTypeId(cost.style, cost.typeId)
				this._lb_cost.text = cost.count
				let basic = goods_model.GetGoodsBasicByTypeId(type_id)
				if (basic) {
					cost_basic_ = basic
					ResManager.GetInstance().SetOutsideImageSprite(this, this._img_cost, GameResPath.GetGoodsIconPath(basic.goods_icon))
				}
				this._lb_cost.visible = true
				this._img_cost.visible = true
				this._lb_ref.text = "刷新"
			} else {
				this._lb_cost.visible = false
				this._img_cost.visible = false
				this._lb_ref.text = "免费"
			}
		}

		this.OnTimer = () => {
			let left_time = model.GetZoreStatus()
			if (left_time > 0) {
				this._lb_time.innerHTML = Util.StrToHTML("刷新中(" + left_time + "s)")
			} else {
				let zero_time = local_TimeUtil.GetFutureZeroStamp(1)
				let start_time = zero_time - model.outTime
				let time = start_time - local_TimeUtil.getServerTime()
				let url = "距商店自动刷新:" + local_TimeUtil.timeConvert(time, "hh-mm-ss")
				this._lb_time.innerHTML = Util.StrToHTML(url)
			}
		}

		this.DestroyCallback = () => {
			if (item_list_.length > 0) {
				for (let _tmpi in item_list_) {
					var item = item_list_[_tmpi]
					item.DeleteMe()
				}
				item_list_ = []
			}
			if (timer_) {
				GlobalTimerQuest.CancelQuest(timer_)
				timer_ = null
			}
		}
	}

	public GetComponents() {
		[
			this._Image1,
			this._Image2,
			this._Image3,
			this._Image4,
			this._img_close,
			this._gp_btn,
			this._Image5,
			this._Group1,
			this._lb_ref,
			this._img_cost,
			this._lb_cost,
			this._Scroller1,
			this.Content,
			this._lb_time,
			this.line_1,
			this.line_2
		]
			= this.GetChildrenByNames([

				"_Image1",
				"_Image2",
				"_Image3",
				"_Image4",
				"_img_close",
				"_gp_btn",
				"_Image5",
				"_Group1",
				"_lb_ref",
				"_img_cost",
				"_lb_cost",
				"_Scroller1",
				"Content",
				"_lb_time",
				"line_1",
				"line_2"
			])
		this._lb_time.style.fontSize = 20
		this._lb_time.style.color = "#96ff00"
		this._lb_time.style.wordWrap = false
	}
}
window["AdventureShopView"] = AdventureShopView