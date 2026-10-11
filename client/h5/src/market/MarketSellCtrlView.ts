import { BaseView1 } from "../common/BaseView1"
import { MarketModel, MarketEvent } from "../commonModel/MarketModel"
import { Message } from "../sysInfo/SysInfoController";
import { GlobalEventSystem } from "../util/DeclareGlobalVar";
import { EventName } from "../common/EventName";
import { GoodsModel } from "../commonModel/GoodsModel";
import { Enum_UILayer } from "../common/LayerManager";
import { ResManager } from "../common/ResManager";
import { Util, Trim, HtmlColorTxt } from "../util/Util";
import { LuaSoundManager } from "../common/SoundManager";
import { GameResPath } from "../util/GameResPath";
import { ColorUtil } from "../util/ColorUtil";
import { RoleManager } from "../commonModel/RoleManager";
import { Enum_ColorUtil_Dark } from "../util/ColorUtil";
import { EquipmentItem } from "../common/EquipmentItem";

export class MarketSellCtrlView extends BaseView1 {
	_Image11:Laya.Image
	_Image2:Laya.Image
	_Image3:Laya.Image
	_Group1:Laya.Box
	_Image4:Laya.Image
	_Label1:Laya.Label
	_Image5:Laya.Image
	_btn_go:Laya.Box
	_Image111:Laya.Image
	labelDisplay:Laya.Label
	_btn_close:Laya.Box
	_Image1:Laya.Image
	labelDisplay1:Laya.Label
	vip_gp:Laya.HBox
	_lb_vip_tips:Laya.HTMLDivElement
	_Label2:Laya.Label
	_Label3:Laya.Label
	_Label4:Laya.Label
	_lb_own:Laya.Label
	_lb_tips_price:Laya.Label
	_lb_total:Laya.Label
	_lb_ratio:Laya.Label
	_lb_goods:Laya.HTMLDivElement
	_Label5:Laya.Label
	_img_total:Laya.Image
	_img_ratio:Laya.Image
	_group_item:Laya.Box
	_group_price:Laya.Box
	_Label6:Laya.Label
	_lb_price_ratio:Laya.Label
	_Image6:Laya.Image
	_Group2:Laya.HBox
	_img_unit:Laya.Image
	_lb_unit:Laya.Label
	_btn_price_sub:Laya.Image
	_btn_price_add:Laya.Image
	_group_free:Laya.Box
	_Image7:Laya.Image
	_gp_free:Laya.HBox
	_lb_price:Laya.Label
	_Group3:Laya.Box
	_btn_count_sub:Laya.Image
	_btn_count_add:Laya.Image
	_Image8:Laya.Image
	_lb_count:Laya.Label
	_Image9:Laya.Image
	tip:Laya.Box
	check:Laya.Image
	toggle:Laya.Image


	ChangeFreeCount
	ChangeFreePrice
	ChangePrice
	Clear
	Emp_btn_close
	Emp_btn_go
	InitAwardItem
	InitEvent
	InitView
	Local_Open
	SetCountValue
	SetFreePriceValue
	SetPriceValue

	click_bg_toClose
	destroy_callback
	destroy_imm
	is_center
	preload_server_config
	show_open_movie
	use_background
	check_state

	public constructor() {
		super()


		let model = MarketModel.GetInstance()
		let local_Math = Math
		let local_Message = Message
		let local_GlobalEventSystem = GlobalEventSystem
		let local_EventName = EventName
		let local_String = String
		let goods_model = GoodsModel.GetInstance()
		let _cal_type_ = null
		let _max_count_ = 1
		let goods_vo_ = null
		let goods_num_ = 1
		let ratio_ = 0
		let unit_price_ = 0
		let cur_price_ = 0
		let min_price_ = 0
		let max_price_ = 0
		let is_free_ = false
		let _min_ratio_ = null
		let _max_ratio_ = null
		let award_item_ = null
		this.base_file = "market"
		this.layout_file = "MarketSellCtrlView"
		this.layer_value = Enum_UILayer.Activity
		this.use_background = true
		this.click_bg_toClose = true
		this.is_center = true
		this.destroy_imm = true
		this.show_open_movie = true
		this.check_state = 1
		this.load_callback = () => {

			// if (PlatformMgr.GetInstance().IsEyouThPlatform()) {
			// 	SetAnchoredPositionX(this._Label2, 67)
			// 	SetAnchoredPositionX(this._Label3, 70)
			// 	SetSizeDeltaY(this._lb_goods, 40)
			// 	SetSizeDeltaY(this._Label5, 30)
			// 	SetSizeDeltaY(this._lb_own, 30)
			// 	SetSizeDeltaY(this._lb_total, 32)
			// 	SetSizeDeltaY(this._lb_ratio, 32)
			// }
			this.InitView()
			this.InitEvent()
		}

		this.destroy_callback = () => {
			this.Clear()
		}

		this.preload_server_config = {
			"config_goods_sell": false,
			"config_num_by_vip": false,
			"config_num_by_vip_info": false
		}
		this.Clear = () => {
			if (award_item_) {
				award_item_.DeleteMe()
				award_item_ = null
			}
			goods_num_ = 1
		}

		this.Local_Open = (parms?) => {
			goods_vo_ = parms[0]
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this.check, () => {
				this.toggle.visible = !this.toggle.visible
				let state = this.toggle.visible ? 1 : 0
				this.check_state = state
			}, this, true)

			Util.AddClickEvent(this._btn_close, () => {
				this.Close()
			}
				, this, true, null, null, null, null, LuaSoundManager.SOUND_UI.CLOSE)
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
				if (!goods_vo_) {
					return
				}
				if (goods_num_ <= 0) {
					local_Message.show("请输入数量")
					return
				}
				if (cur_price_ <= 0) {
					local_Message.show("请输入价格")
					return
				}
				// [ts2lua]lua中0和空字符串也是true，此处is_free_需要确认
				let price = is_free_ && cur_price_ || goods_num_ * cur_price_
				model.Fire(MarketEvent.REQUEST_PROTO, 15106, "liic", goods_vo_.goods_id, goods_num_, price, this.check_state)
			}
				, this, true)
			Util.AddClickEvent(this._group_free, () => {
				_cal_type_ = 1
				let pos = [0, 0]
				local_GlobalEventSystem.Fire(local_EventName.OPEN_CALCULATOR_VIEW, 9999, (value?) => {
					this.ChangeFreePrice(value)
				}, pos)
			}
				, this, true)
			Util.AddClickEvent(this._lb_count, () => {
				_cal_type_ = 2
				let pos = [0, 100]
				local_GlobalEventSystem.Fire(local_EventName.OPEN_CALCULATOR_VIEW, _max_count_, (value?) => {
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
				this._lb_count.text = local_String(num)
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
				this._lb_count.text = local_String(num)
				this.SetCountValue()
			}
				, this, true)
		}

		this.InitView = () => {
			//ResManager.GetInstance().SetOutsideImageSprite(this, this._Image9, GameResPath.GetIcon("common2", "com_line_2"), true)

			if (!goods_vo_) {
				return
			}
			let goods_vo = goods_vo_
			let own = model.GetGoodsNum(goods_vo.type_id)
			this._lb_own.text = String(own)
			let color = ColorUtil.GetColorDark(goods_vo.color)
			this._lb_goods.style.fontSize = 24
			this._lb_goods.style.valign = "center"
			this._lb_goods.style.color = "#fe1a1a"
			this._lb_goods.width = 500
			this._lb_goods.innerHTML = Util.StrToHTML("<font color=" + color + ">" + Trim(goods_vo.goods_name) + "</font>")
			let vip = RoleManager.GetInstance().GetMainRoleVo().vip_flag
			let cfg1 = ResManager.GetInstance().GetGameConfigFromCache(this, "config_num_by_vip", false)
			let cfg2 = ResManager.GetInstance().GetGameConfigFromCache(this, "config_num_by_vip_info", false)
			ratio_ = model.GetMarketVipRatio(cfg1, cfg2) / 100
			let vip_str = HtmlColorTxt(`VIP${vip}`, "'#d15e00'")
			let ratio_str = HtmlColorTxt(ratio_ * 100, "'#d15e00'")
			let invalid = 0//VipModel.GetInstance().IsInvalidCard()
			// [ts2lua]lua中0和空字符串也是true，此处invalid需要确认
			let invalid_str = invalid && "（已过期）" || ""
			this._lb_vip_tips.style.fontSize = 18
			this._lb_vip_tips.style.valign = "center"
			this._lb_vip_tips.style.color = "#663915"
			this._lb_vip_tips.width = 500
			this._lb_vip_tips.innerHTML = Util.StrToHTML("当前" + vip_str + invalid_str + ",税率降为" + ratio_str + "%")
			let num_limit = 1
			let basic = goods_model.GetGoodsBasicByTypeId(goods_vo.type_id)
			is_free_ = basic.if_custom_price != 0
			// [ts2lua]lua中0和空字符串也是true，此处is_free_需要确认
			this._lb_tips_price.text = (is_free_ && ("总价：") || ("单价："))
			if (is_free_) {
				let [min_price, max_price, limit] = model.GetMarketLimitPriceFree(basic.if_custom_price)
				min_price_ = min_price
				max_price_ = max_price
				num_limit = limit
				cur_price_ = 0
				this.ChangeFreePrice(min_price_)
				this.SetFreePriceValue()
			} else {
				let [unit_price, limit] = model.GetMarketLimitPrice(goods_vo.type_id)
				unit_price_ = unit_price
				cur_price_ = unit_price
				let kvcfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_goods_sell", false)
				_min_ratio_ = model.GetKVCfg(kvcfg, 12)
				_max_ratio_ = model.GetKVCfg(kvcfg, 11)
				min_price_ = local_Math.ceil((1 - _min_ratio_ / 100) * unit_price_)
				max_price_ = local_Math.ceil((1 + _max_ratio_ / 100) * unit_price_)
				this.SetPriceValue(cur_price_)
				num_limit = limit
			}
			_max_count_ = local_Math.min(own, num_limit)
			goods_num_ = local_Math.min(goods_num_, _max_count_)
			this._lb_count.text = String(goods_num_)
			this._group_free.visible = is_free_
			this._group_price.visible = !is_free_
			this.InitAwardItem(goods_vo)
			let gray = _max_count_ <= 1
			Util.SetImageGray(this._btn_count_sub, gray)
			Util.SetImageGray(this._btn_count_add, gray)
			this._btn_count_sub.mouseEnabled = !gray
			this._btn_count_add.mouseEnabled = !gray
			this._lb_count.mouseEnabled = !gray
		}

		this.InitAwardItem = (goods_vo?) => {
			if (!award_item_) {
				award_item_ = new EquipmentItem(this._group_item)
				award_item_.SetItemSize(85, 85)
				award_item_.Load()
			}
			award_item_.SetData(goods_vo.type_id)
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
			if (price > max_price_) {
				price = local_Math.min(price, max_price_)
				this._lb_price.text = local_String(price)
			} else if (price < min_price_) {
				price = local_Math.max(price, min_price_)
				this._lb_price.text = local_String(price)
			}
			cur_price_ = price
			this._lb_total.text = local_String(price)
			this._lb_ratio.text = String(local_Math.ceil(price * ratio_))
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
				this._lb_count.text = local_String(count)
			} else if (count < 1) {
				count = local_Math.max(count, 1)
				this._lb_count.text = local_String(count)
			}
			goods_num_ = count
			if (!is_free_) {
				this.ChangePrice()
			}
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


	}

	public Open(...new_args) {

		let parms = new_args
		this.Local_Open(parms)
		super.Open()
	}


	public GetComponents() {
		[
			this._Image11,
			this._Image2,
			this._Image3,
			this._Group1,
			this._Image4,
			this._Label1,
			this._Image5,
			this._btn_go,
			this._Image111,
			this.labelDisplay,
			this._btn_close,
			this._Image1,
			this.labelDisplay1,
			this.vip_gp,
			this._lb_vip_tips,
			this._Label2,
			this._Label3,
			this._Label4,
			this._lb_own,
			this._lb_tips_price,
			this._lb_total,
			this._lb_ratio,
			this._lb_goods,
			this._Label5,
			this._img_total,
			this._img_ratio,
			this._group_item,
			this._group_price,
			this._Label6,
			this._lb_price_ratio,
			this._Image6,
			this._Group2,
			this._img_unit,
			this._lb_unit,
			this._btn_price_sub,
			this._btn_price_add,
			this._group_free,
			this._Image7,
			this._gp_free,
			this._lb_price,
			this._Group3,
			this._btn_count_sub,
			this._btn_count_add,
			this._Image8,
			this._lb_count,
			this._Image9,
			this.tip,
			this.check,
			this.toggle,
		]
			= this.GetChildrenByNames([

				"_Image11",
				"_Image2",
				"_Image3",
				"_Group1",
				"_Image4",
				"_Label1",
				"_Image5",
				"_btn_go",
				"_Image111",
				"labelDisplay",
				"_btn_close",
				"_Image1",
				"labelDisplay1",
				"vip_gp",
				"_lb_vip_tips",
				"_Label2",
				"_Label3",
				"_Label4",
				"_lb_own",
				"_lb_tips_price",
				"_lb_total",
				"_lb_ratio",
				"_lb_goods",
				"_Label5",
				"_img_total",
				"_img_ratio",
				"_group_item",
				"_group_price",
				"_Label6",
				"_lb_price_ratio",
				"_Image6",
				"_Group2",
				"_img_unit",
				"_lb_unit",
				"_btn_price_sub",
				"_btn_price_add",
				"_group_free",
				"_Image7",
				"_gp_free",
				"_lb_price",
				"_Group3",
				"_btn_count_sub",
				"_btn_count_add",
				"_Image8",
				"_lb_count",
				"_Image9",
				"tip",
				"check",
				"toggle",
			])
	}
}
 window["MarketSellCtrlView"]= MarketSellCtrlView