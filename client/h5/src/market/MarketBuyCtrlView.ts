import { BaseItem1 } from "../common/BaseItem1"
import { MarketEvent, MarketModel } from "../commonModel/MarketModel"
import { MarketShowItem } from "../market/MarketShowItem"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { DownDropBtn } from "../common/DownDropBtn"
import { SetSizeDeltaX, SetAnchoredPositionY, Util } from "../util/Util"
import { LoopScrCon,LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { GameResPath } from "../util/GameResPath"
export class MarketBuyCtrlView extends BaseItem1 {
	_img_bg: Laya.Image
	_Group1: Laya.Box
	_Image1: Laya.Image
	Content: Laya.List
	_lb_times: Laya.Label
	_group_title: Laya.Box
	_Image2: Laya.Image
	_Label1: Laya.Label
	_Label2: Laya.Label
	_group_price: Laya.Box
	_Label3: Laya.Label
	_img_price: Laya.Image
	_group_empty: Laya.HBox
	_Image3: Laya.Image
	_Label4: Laya.Label
	_group_drop: Laya.Box
	_dd_color: Laya.Box
	_dd_stage: Laya.Box
	_dd_star: Laya.Box


	ClickColor
	ClickStage
	ClickStar
	FireEvent
	InitEvent
	InitView
	Local_DeleteMe
	Scr_Scroller1
	SetCountData
	SetData
	SetDefault
	SortList
	UpdateItems
	_list_item
	down_btn1
	down_btn2
	down_btn3
	loop_mgr

	public constructor(parent?) {
		super(parent)


		this.base_file = "market"
		this.layout_file = "MarketBuyCtrlView"
		let model = MarketModel.GetInstance()
		let local_MarketEvent = MarketEvent
		let type_ = 0
		let subtype_ = 0
		let _set_color_ = 99
		let _set_stage_ = 99
		let _set_star_ = 99
		let up_order_ = null
		let data_list_ = []
		this.preload_client_config = {
			"ConfigMarket": false
		}
		this.preload_server_config = {
			"config_equip_attr": false
		}
		this.load_callback = () => {

			// let mask = this.GetChild("_Group1/_Scroller1/_list_item").GetComponent("Image")
			// this.RegisterMask(mask)
			// if (PlatformMgr.GetInstance().IsEyouThPlatform()) {
			// 	SetSizeDeltaY(this._Label4, 35)
			// }
			this.InitView()
			this.SetDefault()
		}

		this.Local_DeleteMe = () => {
			if (this.down_btn1) {
				this.down_btn1.DeleteMe()
				this.down_btn1 = null
			}
			if (this.down_btn2) {
				this.down_btn2.DeleteMe()
				this.down_btn2 = null
			}
			if (this.down_btn3) {
				this.down_btn3.DeleteMe()
				this.down_btn3 = null
			}
			if (this.loop_mgr) {
				this.loop_mgr.DeleteMe()
				this.loop_mgr = null
			}

		}

		this.InitView = () => {
			ResManager.GetInstance().SetOutsideImageSprite(this, this._Image2, GameResPath.GetIcon("market", "uishi_014"))
			let market_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "ConfigMarket", true)
			if (this.use_delete_method) {
				//lua_resM:DestroyAllReferenceRes(this.hashCode)
				return
			}
			let color_cfg = []
			let j = 1
			for (let _ in market_cfg["drop_color_cfg"]) {
				var v = market_cfg["drop_color_cfg"][_]

				color_cfg[j] = v
				j = j + 1
			}
			table.sort(color_cfg, (a?, b?) => {
				return a.id < b.id
			})


			let stage_cfg = []
			let i = 1
			for (let _ in market_cfg["drop_stage_cfg"]) {
				var v = market_cfg["drop_stage_cfg"][_]

				stage_cfg[i] = v
				i = i + 1
			}
			table.sort(stage_cfg, (a?, b?) => {
				return a.id < b.id
			})
			let star_cfg = []
			let a = 1
			for (let _ in market_cfg["drop_star_cfg"]) {
				var v = market_cfg["drop_star_cfg"][_]

				star_cfg[a] = v
				a = a + 1
			}
			table.sort(star_cfg, (a?, b?) => {
				return a.id < b.id
			})


			this.down_btn1 = new DownDropBtn(this._dd_color)
			this.down_btn1.Init(color_cfg, (index?, data?) => {
				this.ClickColor(index, data)
			}, "品质", "content", this.layer_value)
			this.down_btn1.Load()
			SetSizeDeltaX(this.down_btn1.transform, 135)
			this.down_btn2 = new DownDropBtn(this._dd_stage)
			this.down_btn2.Init(stage_cfg, (index?, data?) => {
				this.ClickStage(index, data)
			}, "阶级", "content", this.layer_value, 5)
			this.down_btn2.Load()
			SetSizeDeltaX(this.down_btn2.transform, 135)
			this.down_btn3 = new DownDropBtn(this._dd_star)
			this.down_btn3.Init(star_cfg, (index?, data?) => {
				this.ClickStar(index, data)
			}, "星级", "content", this.layer_value)
			this.down_btn3.Load()
			SetSizeDeltaX(this.down_btn3.transform, 135)

			this.InitEvent()
			this.FireEvent()
		}

		this.FireEvent = () => {
			model.Fire(local_MarketEvent.REQUEST_PROTO, 15114)
		}

		this.InitEvent = () => {
			this.BindEvent(model, local_MarketEvent.SET_SELL_TYPE_DIC, (type?, subtype?) => {
				if (type != type_ || subtype != subtype_) {
					return
				}
				this.UpdateItems()
			}
			)
			this.BindEvent(model, local_MarketEvent.UPDATE_BUY_TIMES, (info?) => {
				this.SetCountData(info)
			}
			)
			this.BindEvent(model, local_MarketEvent.OUT_SHELF_SUCCESS, (info?) => {
				model.Fire(local_MarketEvent.REQUEST_PROTO, 15102, "iiccc", type_, subtype_, 99, 99, 99)
			}
			)
			this.BindEvent(model, local_MarketEvent.UP_SHELF_SUCCESS, (info?) => {
				model.Fire(local_MarketEvent.REQUEST_PROTO, 15102, "iiccc", type_, subtype_, 99, 99, 99)
			}
			)
			Util.AddClickEvent(this._group_price, () => {
				up_order_ = !up_order_
				let rotation = !up_order_ ? 180 : 0
				this._img_price.rotation = rotation
				data_list_ = this.SortList(data_list_, up_order_)
				this.UpdateItems(data_list_)
			}
				, this)
		}

		this.SortList = (list?, up?) => {
			if (up == null) {
				return list
			}
			if (up) {
				table.sort(list, (a?, b?) => {
					return a.unit_price > b.unit_price
				}
				)
			} else {
				table.sort(list, (a?, b?) => {
					return b.unit_price > a.unit_price
				}
				)
			}
			return list
		}

		this.SetCountData = (info?) => {
			let data = info.times_list[0]
			this._lb_times.text = "购买次数：" + data.times + "/" + data.times_limit
		}

		this.ClickColor = (index?, data?) => {
			_set_color_ = data.cond
			this.UpdateItems()
		}

		this.ClickStage = (index?, data?) => {
			_set_stage_ = data.cond
			this.UpdateItems()
		}

		this.ClickStar = (index?, data?) => {
			_set_star_ = data.cond
			this.UpdateItems()
		}

		this.UpdateItems = (data_list?) => {
			let equip_attr_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_equip_attr", false)
			data_list_ = data_list || model.GetSellGoodsByCond(type_, subtype_, _set_color_, _set_stage_, _set_star_, equip_attr_cfg)
			data_list_ = this.SortList(data_list_, up_order_)

			if (!this.loop_mgr) {
			this.loop_mgr = new LoopScrowViewMgr()
			this.loop_mgr.SetData(this.Content, MarketShowItem, data_list_, LoopScrCon.Vertical)
			}
			else{
				this.loop_mgr.replaceAll(data_list_)
			}
			//SetAnchoredPositionY(this.Content, 0)
			//this.loop_mgr.FirstOnChild(1)
			//this._list_item.scrollV = 0
			this._group_empty.visible = data_list_.length < 1
			this._group_title.visible = data_list_.length > 0
		}

		this.SetData = (...new_args) => {
			let parms = new_args
			type_ = Number(parms[0])
			subtype_ = Number(parms[1])
			if (this.is_loaded) {
				this.SetDefault()
			}
		}

		this.SetDefault = () => {
			_set_color_ = 99
			_set_stage_ = 99
			_set_star_ = 99
			this.down_btn1.Refuse()
			this.down_btn2.Refuse()
			this.down_btn3.Refuse()

			//if (_set_color_ != 99 ) {
			//this.down_btn1.SetSelectIndex(1)
			//}
			//if (_set_stage_ != 99 ) {
			//this.down_btn2.SetSelectIndex(1)
			//}
			//if (_set_star_ != 99 ) {
			//this.down_btn3.SetSelectIndex(1)
			//}
			let key = type_ * 10000 + subtype_
			model.Fire(local_MarketEvent.REQUEST_PROTO, 15102, "iiccc", type_, subtype_, 99, 99, 99)
		}


	}

	public DeleteMe() {

		this.Local_DeleteMe()
		super.DeleteMe()
	}




	public GetComponents() {
		[
			this._img_bg,
			this._Group1,
			this._Image1,
			this.Content,
			this._lb_times,
			this._group_title,
			this._Image2,
			this._Label1,
			this._Label2,
			this._group_price,
			this._Label3,
			this._img_price,
			this._group_empty,
			this._Image3,
			this._Label4,
			this._group_drop,
			this._dd_color,
			this._dd_stage,
			this._dd_star,
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_Group1",
				"_Image1",
				"Content",
				"_lb_times",
				"_group_title",
				"_Image2",
				"_Label1",
				"_Label2",
				"_group_price",
				"_Label3",
				"_img_price",
				"_group_empty",
				"_Image3",
				"_Label4",
				"_group_drop",
				"_dd_color",
				"_dd_stage",
				"_dd_star",
			])
	}
}

window["MarketBuyCtrlView"] = MarketBuyCtrlView