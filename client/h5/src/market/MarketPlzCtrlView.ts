import { BaseItem1 } from "../common/BaseItem1"
import { MarketEvent, MarketViewType, MarketModel } from "../commonModel/MarketModel"
import { Message } from "../sysInfo/SysInfoController"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { EventName } from "../common/EventName"
import { ResManager } from "../common/ResManager"
import { LoopScrowViewMgr,LoopScrCon } from "../common/LoopScrowViewMgr"
import { MarketTypeBtn } from "../market/MarketTypeBtn"
import { Util } from "../util/Util"
import { GoodsModel } from "../commonModel/GoodsModel"
import { table } from "../common/table"
import { EquipModel } from "../commonModel/EquipModel"
import { MarketPlzGoodsItem } from "../market/MarketPlzGoodsItem"
import { MarketPlzTypeItem } from "../market/MarketPlzTypeItem"

export class MarketPlzCtrlView extends BaseItem1 {
	_group_ctrl:Laya.Box
	_Group1:Laya.Box
	Content:Laya.List
	_Image1:Laya.Image
	_lb_title:Laya.Label
	_Group4:Laya.Box
	_Label1:Laya.Label
	_Label2:Laya.Label
	_Label3:Laya.Label
	_Label4:Laya.Label
	_lb_tips_price:Laya.Label
	_lb_total:Laya.Label
	_lb_ratio:Laya.Label
	_img_total:Laya.Image
	_img_ratio:Laya.Image
	_btn_go:Laya.Box
	_Image11:Laya.Image
	labelDisplay:Laya.Label
	_group_price:Laya.Box
	_Label5:Laya.Label
	_lb_price_ratio:Laya.Label
	_Image2:Laya.Image
	_Group2:Laya.HBox
	_img_unit:Laya.Image
	_lb_unit:Laya.Label
	_btn_price_sub:Laya.Image
	_btn_price_add:Laya.Image
	_group_free:Laya.Box
	_Image3:Laya.Image
	_gp_free:Laya.HBox
	_lb_price:Laya.Label
	_Group3:Laya.Box
	_btn_count_sub:Laya.Image
	_btn_count_add:Laya.Image
	_Image4:Laya.Image
	_lb_count:Laya.Label
	_Image5:Laya.Image
	_group_item:Laya.Box
	Content1:Laya.List
	_Image6:Laya.Image
	Content11:Laya.List
	_group_empty:Laya.HBox
	_Image7:Laya.Image
	_Label6:Laya.Label

	goodsEvent
	TouchHandler
	ChangeFreeCount
	ChangeFreePrice
	ChangePrice
	ClickTypeCallback
	Emp_btn_go
	InitEvent
	InitView
	LocalDeleteMe
	Scr_Scroller1
	Scr_Scroller2
	Scr_Scroller3
	SetCountValue
	SetData
	SetFreePriceValue
	SetGroupVisible
	SetPriceValue
	SwitchView
	UpdateGoods
	UpdateItems
	UpdateView
	_list_btn
	_list_goods
	_list_item
	btn_loop_mgr
	goods_loop_mgr
	loop_mgr

	public constructor(parent?) {
		super(parent)


		this.base_file = "market"
		this.layout_file = "MarketPlzCtrlView"
		let model = MarketModel.GetInstance()
		let local_MarketEvent = MarketEvent
		let local_MarketViewType = MarketViewType
		let local_Math = Math
		let local_Message = Message
		let local_GlobalEventSystem = GlobalEventSystem
		let local_EventName = EventName
		let _ac_btn_ = null
		let _cal_type_ = null
		let _max_count_ = 1
		let type_ = 0
		let subtype_ = 0
		let select_index_ = 0
		let goods_vo_ = null
		let goods_num_ = 1
		let ratio_ = 0
		let unit_price_ = 0
		let cur_price_ = 0
		let min_price_ = 0
		let max_price_ = 0
		let is_free_ = false
		let _color_ = 99
		let _stage_ = 99
		let _star_ = 99
		let _min_ratio_ = null
		let _max_ratio_ = null
		let _need_refresh_data_ = false
		this.preload_client_config = {
			"ConfigMarket": false
		}
		this.preload_server_config = {
			"config_goods_sell": false,
			"config_equip_attr": false,
			"config_num_by_vip": false,
			"config_num_by_vip_info": false
		}
		this.load_callback = () => {

			// 		if (PlatformMgr.GetInstance().IsEyouIdnPlatform() ) {
			// 			this._Label3.size  = 18
			// 			let csf = this._lb_tips_price.GetComponent("ContentSizeFitter")
			// 			csf.horizontalFit = UnityEngine.UI.ContentSizeFitter.FitMode.Unconstrained
			// 			SetSizeDeltaX(this._lb_tips_price,70)
			// 			SetAnchoredPosition(this._lb_tips_price,17,-146)
			// 			this._lb_tips_price.size  = 22
			// 			this._lb_tips_price.lineSpacing = 0.7
			// 			this._lb_tips_price.verticalAlign = "middle"
			// this._lb_tips_price.textAlign = "center"
			// 			SetAnchoredPositionY(this._Label3,-407.59)
			// 		}
			// 		let mask = this.GetChild("_group_ctrl/_Group1/_Scroller1/_list_goods").GetComponent("Image")
			// 		this.RegisterMask(mask)
			this.InitView()
		}

		this.LocalDeleteMe = () => {
			if (this.loop_mgr) {
				this.loop_mgr.DeleteMe()
				this.loop_mgr = null
			}
			if (this.btn_loop_mgr) {
				this.btn_loop_mgr.DeleteMe()
				this.btn_loop_mgr = null
			}
			if (this.goods_loop_mgr) {
				this.goods_loop_mgr.DeleteMe()
				this.goods_loop_mgr = null
			}
			// this.Content.removeEventListener(eui.ItemTapEvent.ITEM_TAP, this.goodsEvent, this)
			// this.Content11.removeEventListener(eui.ItemTapEvent.ITEM_TAP, this.TouchHandler, this)
		}

		this.InitView = () => {
			let market_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "ConfigMarket", true)
			if (this.use_delete_method) {
				//lua_resM:DestroyAllReferenceRes(this.hashCode)
				return
			}


			let cfg1 = ResManager.GetInstance().GetGameConfigFromCache(this, "config_num_by_vip", false)
			let cfg2 = ResManager.GetInstance().GetGameConfigFromCache(this, "config_num_by_vip_info", false)
			ratio_ = model.GetMarketVipRatio(cfg1,cfg2) / 100
			// [ts2lua]market_cfg下标访问可能不正确
			let radio_list = market_cfg["type_radio_cfg"]

			if (!this.btn_loop_mgr) {
				this.btn_loop_mgr = new LoopScrowViewMgr()
				this.btn_loop_mgr.SetData(this.Content11, MarketTypeBtn, radio_list, LoopScrCon.Horizontal, 1, () => {
					if (this.Content11.array) {
						let index = this.Content11.array[this.Content11.selectedIndex].id
						this.SwitchView(index)
					}
					
				})
				//this.Content11.addEventListener(eui.ItemTapEvent.ITEM_TAP, this.TouchHandler, this)
			} else {
				this.btn_loop_mgr.replaceAll(radio_list)
			}
			this.btn_loop_mgr.SetSelectIndex(0)
			this.SwitchView(1)
			let kvcfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_goods_sell", false)
			_min_ratio_ = model.GetKVCfg(kvcfg, 12)
			_max_ratio_ = model.GetKVCfg(kvcfg, 11)
			this.InitEvent()
			if (_need_refresh_data_) {
				_need_refresh_data_ = false
				model.Fire(local_MarketEvent.PLZ_GROUP_VISIBLE, local_MarketViewType.CTRL, !this._group_ctrl.visible)
			}
		}
		this.TouchHandler = (e?) => {
			let data = e.item
			let index = data.id
			this.SwitchView(index)
		}
		this.InitEvent = () => {
			Util.AddClickEvent(this._btn_price_sub, () => {
				let price = cur_price_ - local_Math.ceil(unit_price_ * 0.1)
				if (price < min_price_) {
					local_Message.show("当前价格已是最低")
					return
				}
				cur_price_ = price
				this.SetPriceValue(cur_price_)
			}
				, this, true)
			Util.AddClickEvent(this._btn_price_add, () => {
				let price = cur_price_ + local_Math.ceil(unit_price_ * 0.1)
				if (price > max_price_) {
					local_Message.show("当前价格已是最高")
					return
				}
				cur_price_ = price
				this.SetPriceValue(cur_price_)
			}
				, this, true)
			Util.AddClickEvent(this._btn_go, () => {
				if ((!goods_vo_ || goods_num_ <= 0) || cur_price_ <= 0) {
					return
				}
				// [ts2lua]lua中0和空字符串也是true，此处is_free_需要确认
				let price = is_free_ && cur_price_ || goods_num_ * cur_price_
				model.Fire(local_MarketEvent.REQUEST_PROTO, 15115, "iii", goods_vo_.type_id, goods_num_, price)
			}
				, this, true)
			this.BindEvent(model, local_MarketEvent.PLZ_SORT_GOODS, (color?, stage?, star?) => {
				_color_ = color
				_stage_ = stage
				_star_ = star
				this.UpdateGoods(null, color, stage, star)
			}
			)
			this.BindEvent(model, local_MarketEvent.CLICK_PLZ_TYPE_ITEM, (data?) => {
				this.ClickTypeCallback(data)
			}
			)
			Util.AddClickEvent(this._group_free, () => {
				_cal_type_ = 1
				let pos = [50, -280]
				local_GlobalEventSystem.Fire(local_EventName.OPEN_CALCULATOR_VIEW, 9999, (value?) => {
					this.ChangeFreePrice(value)
				}, pos)
			}
				, this, true)
			Util.AddClickEvent(this._lb_count, () => {
				_cal_type_ = 2
				let pos = [50, -210]
				local_GlobalEventSystem.Fire(local_EventName.OPEN_CALCULATOR_VIEW, 9999, (value?) => {
					this.ChangeFreeCount(value)
				}, pos)
			}
				, this, true)
			this.BindEvent(local_GlobalEventSystem, local_EventName.CLOSE_CALCULATOR_VIEW, () => {
				if (_cal_type_ == 1) {
					this.SetFreePriceValue()
				} else if (_cal_type_ == 2) {
					this.SetCountValue()
				}
			}
			)
			Util.AddClickEvent(this._btn_count_sub, () => {
				if (_max_count_ <= 1) {
					return
				}
				let num = goods_num_ - 1
				if (num < 1) {
					local_Message.show("当前数量已是最小")
					return
				}
				goods_num_ = num
				this._lb_count.text = num.toString()
				this.SetCountValue()
			}
				, this, true)
			Util.AddClickEvent(this._btn_count_add, () => {
				if (_max_count_ <= 1) {
					return
				}
				let num = goods_num_ + 1
				if (num > _max_count_) {
					local_Message.show("当前数量已是最大")
					return
				}
				goods_num_ = num
				this._lb_count.text = num.toString()
				this.SetCountValue()
			}
				, this, true)
		}

		this.UpdateView = (goods_vo?) => {
			if(!goods_vo) return
			goods_vo_ = goods_vo
			let num_limit = 1
			let basic = GoodsModel.GetInstance().GetGoodsBasicByTypeId(goods_vo.type_id)
			is_free_ = basic.if_custom_price != 0 && basic.if_custom_price != '[]'
			// [ts2lua]lua中0和空字符串也是true，此处is_free_需要确认
			this._lb_tips_price.text = is_free_ && "总价" || "单价"
			if (is_free_) {
				let [min_price, max_price, limit] = model.GetMarketLimitPriceFree(basic.if_custom_price)
				min_price_ = min_price
				max_price_ = max_price
				num_limit = limit
				this._lb_price.text = ""
				cur_price_ = 0
				this.ChangePrice()
			} else {
				let [unit_price, limit] = model.GetMarketLimitPrice(goods_vo.type_id)
				unit_price_ = unit_price
				cur_price_ = unit_price_
				min_price_ = local_Math.ceil((1 - _min_ratio_ / 100) * unit_price_)
				max_price_ = local_Math.ceil((1 + _max_ratio_ / 100) * unit_price_)
				this.SetPriceValue(cur_price_)
				num_limit = limit
			}
			_max_count_ = num_limit
			goods_num_ = local_Math.min(goods_num_, _max_count_)
			this._lb_count.text = String(goods_num_)
			this._group_free.visible = is_free_
			this._group_price.visible = !is_free_
			let gray = _max_count_ <= 1
			Util.SetImageGray(this._btn_count_sub, gray)
			Util.SetImageGray(this._btn_count_add, gray)
			this._btn_count_sub.mouseEnabled = !gray
			this._btn_count_add.mouseEnabled = !gray
			this._lb_count.mouseEnabled = !gray
		}


		this.ClickTypeCallback = (data?) => {
			type_ = data.type
			subtype_ = data.subtype
			this.SetGroupVisible(false)
			this.UpdateGoods(null, _color_, _stage_, _star_)
			model.Fire(local_MarketEvent.PLZ_GROUP_VISIBLE, local_MarketViewType.CTRL, false)
		}

		this.ChangePrice = () => {
			let total = goods_num_ * cur_price_
			this._lb_total.text = String(total)
			this._lb_ratio.text = String(local_Math.ceil(total * ratio_))
		}

		this.SetPriceValue = (value?) => {
			cur_price_ = value
			this._lb_unit.text = String(value)
			let ratio = Math.floor(value / unit_price_ * 100)
			this._lb_price_ratio.text = ratio + "%"
			this.ChangePrice()
			//LayoutRebuilder(this._Group2)
		}

		this.SetFreePriceValue = () => {
			let price = Number(this._lb_price.text)
			if (price && max_price_) {
				if (price > max_price_) {
					price = local_Math.min(price, max_price_)
					this._lb_price.text = price.toString()
				} else if (price < min_price_) {
					price = local_Math.max(price, min_price_)
					this._lb_price.text = price.toString()
				}

			}
			if (price) {
				cur_price_ = price
				this._lb_total.text = price.toString()
				this._lb_ratio.text = String(local_Math.ceil(price * ratio_))
			}
		}

		this.ChangeFreePrice = (value?) => {
			if (this.use_delete_method) {
				return
			}
			this._lb_price.text = value
			if (value > max_price_) {
				local_Message.show("不能大于" + max_price_)
			} else if (value < min_price_) {
				local_Message.show("不能小于" + min_price_)
			}
		}

		this.SetCountValue = () => {
			let count = Number(this._lb_count.text)
			if (count > _max_count_) {
				count = local_Math.min(count, _max_count_)
				this._lb_count.text = count.toString()
			} else if (count < 1) {
				count = local_Math.max(count, 1)
				this._lb_count.text = count.toString()
			}
			goods_num_ = count
		}

		this.ChangeFreeCount = (value?) => {
			if (this.use_delete_method) {
				return
			}
			this._lb_count.text = value
			if (value > _max_count_) {
				local_Message.show("不能大于" + _max_count_)
			} else if (value < 1) {
				local_Message.show("不能小于1")
			}
		}

		this.SetData = (...new_args) => {
			if (this.is_loaded) {
				model.Fire(local_MarketEvent.PLZ_GROUP_VISIBLE, local_MarketViewType.CTRL, !this._group_ctrl.visible)
			} else {
				_need_refresh_data_ = true
			}
		}

		this.UpdateGoods = (list?, color?, stage?, star?) => {
			if (color == null) {
				color = 99
			}
			if (stage == null) {
				stage = 99
			}
			if (star == null) {
				star = 99
			}
			let equip_attr_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_equip_attr", false)
			list = list || model.GetPlzGoodsByCond(type_, subtype_, color, stage, star, equip_attr_cfg)
			table.sort(list, (a?, b?) => {
				let data_a = EquipModel.GetInstance().GetEquipData(a.type_id)
				let data_b = EquipModel.GetInstance().GetEquipData(b.type_id)
				if (data_a && data_b) {

					if (data_a.stage != data_b.stage) {
						return data_a.stage < data_b.stage
					} else {
						if (a.color != b.color) {
							return a.color < b.color
						} else {
							if (data_a.star != data_b.star) {
								return data_a.star < data_b.star
							} else {
								if (a.career_id != b.career_id) {
									return a.career_id < b.career_id
								} else {
									return a.type_id < b.type_id
								}
							}
						}
					}
				} else {
					return a.type_id < b.type_id
				}
			})
			if (!this.goods_loop_mgr) {
				this.goods_loop_mgr = new LoopScrowViewMgr()
				this.goods_loop_mgr.SetData(this.Content, MarketPlzGoodsItem, list, LoopScrCon.Vertical, 1, (item?) => {
					if (this.Content.array){
						let data = this.Content.array[this.Content.selectedIndex]
						this.UpdateView(data)

					}
				})
				//this.Content.addEventListener(eui.ItemTapEvent.ITEM_TAP, this.goodsEvent, this)
			} else {
				this.goods_loop_mgr.replaceAll(list)
				// this.goods_loop_mgr.SetData(this.Content, MarketPlzGoodsItem, list, this._Scroller1, 1, (item?) => {
				// 	let data = this.goods_loop_mgr.data_list[this.goods_loop_mgr.select_index]
				// 	this.UpdateView(data)
				// })
			}
			this.goods_loop_mgr.FirstOnChild(0)
			this._group_empty.visible = list.length < 1
			this._group_ctrl.visible = list.length > 0
			if (list.length > 0) {
				this.goods_loop_mgr.SetSelectIndex(0)
				let data = list[this.Content.selectedIndex]
				this.UpdateView(data)
			}
			//

			//SetAnchoredPositionY(this.Content,0)
		}
		this.goodsEvent = (e?) => {
			let vo = e.item
			let data = vo
			this.UpdateView(data)
		}

		this.UpdateItems = () => {
			let kvcfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_goods_sell", false)
			let cfg_list = model.GetTypeCfgAll(kvcfg, type_, 2)
			let list = []
			for (let k in cfg_list) {
				var v = cfg_list[k]
				table.insert(list, v)
			}
			if (!this.loop_mgr) {
				this.loop_mgr = new LoopScrowViewMgr()
				this.loop_mgr.SetData(this.Content1, MarketPlzTypeItem, list, LoopScrCon.Vertical, 4)
			} else {
				this.loop_mgr.replaceAll(list)

			}
		}

		this.SetGroupVisible = (is_item?) => {
			this._group_item.visible = is_item
			this._group_ctrl.visible = !is_item
		}

		this.SwitchView = (index?) => {
			type_ = index
			this.UpdateItems()
			this.SetGroupVisible(true)
			this._group_empty.visible = false
			this.SetData()
		}



	}
	public DeleteMe() {

		this.LocalDeleteMe()
		super.DeleteMe()
	}

	public GetComponents() {
		[
			this._group_ctrl,
			this._Group1,
			this.Content,
			this._Image1,
			this._lb_title,
			this._Group4,
			this._Label1,
			this._Label2,
			this._Label3,
			this._Label4,
			this._lb_tips_price,
			this._lb_total,
			this._lb_ratio,
			this._img_total,
			this._img_ratio,
			this._btn_go,
			this._Image11,
			this.labelDisplay,
			this._group_price,
			this._Label5,
			this._lb_price_ratio,
			this._Image2,
			this._Group2,
			this._img_unit,
			this._lb_unit,
			this._btn_price_sub,
			this._btn_price_add,
			this._group_free,
			this._Image3,
			this._gp_free,
			this._lb_price,
			this._Group3,
			this._btn_count_sub,
			this._btn_count_add,
			this._Image4,
			this._lb_count,
			this._Image5,
			this._group_item,
			this.Content1,
			this._Image6,
			this.Content11,
			this._group_empty,
			this._Image7,
			this._Label6,
		]
			= this.GetChildrenByNames([

				"_group_ctrl",
				"_Group1",
				"Content",
				"_Image1",
				"_lb_title",
				"_Group4",
				"_Label1",
				"_Label2",
				"_Label3",
				"_Label4",
				"_lb_tips_price",
				"_lb_total",
				"_lb_ratio",
				"_img_total",
				"_img_ratio",
				"_btn_go",
				"_Image11",
				"labelDisplay",
				"_group_price",
				"_Label5",
				"_lb_price_ratio",
				"_Image2",
				"_Group2",
				"_img_unit",
				"_lb_unit",
				"_btn_price_sub",
				"_btn_price_add",
				"_group_free",
				"_Image3",
				"_gp_free",
				"_lb_price",
				"_Group3",
				"_btn_count_sub",
				"_btn_count_add",
				"_Image4",
				"_lb_count",
				"_Image5",
				"_group_item",
				"Content1",
				"_Image6",
				"Content11",
				"_group_empty",
				"_Image7",
				"_Label6",
			])
	}
}
 window["MarketPlzCtrlView"]= MarketPlzCtrlView