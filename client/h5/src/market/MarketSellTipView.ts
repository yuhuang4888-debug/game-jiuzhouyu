import { BaseView1 } from "../common/BaseView1"
import { MarketModel, MarketEvent } from "../commonModel/MarketModel"
import { ColorUtil } from "../util/ColorUtil";
import { Enum_UILayer } from "../common/LayerManager";
import { Util } from "../util/Util";
import { LuaSoundManager } from "../common/SoundManager";
import { GoodsModel } from "../commonModel/GoodsModel";
import { Enum_ColorUtil_Dark } from "../util/ColorUtil";
import { RoleManager } from "../commonModel/RoleManager";
import { EquipmentItem } from "../common/EquipmentItem";
import { ResManager } from "../common/ResManager";

export class MarketSellTipView extends BaseView1 {
	_Image111: Laya.Image
	_Image2: Laya.Image
	_Group1: Laya.Box
	_Image3: Laya.Image
	_Label1: Laya.Label
	_Image4: Laya.Image
	_btn_go: Laya.Box
	_Image1: Laya.Image
	labelDisplay1: Laya.Label
	_btn_close: Laya.Box
	_Image11: Laya.Image
	labelDisplay: Laya.Label
	_Image5: Laya.Image
	_lb_goods: Laya.HTMLDivElement
	_lb_price: Laya.Label
	_Label2: Laya.Label
	_lb_vip_tips: Laya.HTMLDivElement
	_group_item: Laya.Box
	_Image6: Laya.Image
	_Group2: Laya.HBox
	_Label3: Laya.Label
	_Image7: Laya.Image
	_lb_price_tips: Laya.Label
	Clear
	Emp_btn_close
	Emp_btn_go
	InitAwardItem
	InitEvent
	InitView
	Local_Open
	click_bg_toClose
	destroy_callback
	destroy_imm
	is_center
	show_open_movie
	use_background

	public constructor() {
		super()


		let model = MarketModel.GetInstance()
		let local_ColorUtil = ColorUtil
		let data_ = null
		let award_item_ = null
		this.base_file = "market"
		this.layout_file = "MarketSellTipView"
		this.layer_value = Enum_UILayer.UI
		this.use_background = true
		this.click_bg_toClose = true
		this.is_center = true
		this.destroy_imm = true
		this.show_open_movie = true
		this.load_callback = () => {

			this.InitEvent()
			this.InitView()
		}
		this.preload_server_config = {
			
			"config_num_by_vip": false,
			"config_num_by_vip_info": false
		}
		this.destroy_callback = () => {
			this.Clear()
		}

		this.Clear = () => {
			if (award_item_) {
				award_item_.DeleteMe()
				award_item_ = null
			}
		}

		this.Local_Open = (parms?) => {
			data_ = parms[0]
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this._btn_close, () => {
				this.Close()
			}
				, this, true, null, null, null, null, LuaSoundManager.SOUND_UI.CLOSE)
			Util.AddClickEvent(this._btn_go, () => {
				if (!data_) {
					return
				}
				let data = data_
				model.Fire(MarketEvent.REQUEST_PROTO, 15117, "lliii", data.id, data.player_id, data.type_id, data.goods_num,data.unit_price)
				this.Close()
			}
				, this, true)
		}

		this.InitView = () => {
			let data = data_
			let basic = GoodsModel.GetInstance().GetGoodsBasicByTypeId(data.type_id)
			if (!basic) {
				return
			}
			let name = Util.HtmlColorTxt(basic.goods_name, local_ColorUtil.GetColorDark(basic.color))
			let num = Util.HtmlColorTxt(data.goods_num, Enum_ColorUtil_Dark.GREEN)
			this._lb_goods.style.fontSize = 24
			this._lb_goods.style.valign = "center"
			this._lb_goods.style.color = "#93847d"
			this._lb_goods.width = 500
			this._lb_goods.innerHTML = Util.StrToHTML(name + "x" + num)
			let aprice = data.unit_price
			this._lb_price.text = String(aprice)
			let vip = RoleManager.GetInstance().GetMainRoleVo().vip_flag
			let cfg1 = ResManager.GetInstance().GetGameConfigFromCache(this, "config_num_by_vip", false)
			let cfg2 = ResManager.GetInstance().GetGameConfigFromCache(this, "config_num_by_vip_info", false)
			let ratio = model.GetMarketVipRatio(cfg1,cfg2)
			let vip_str = Util.HtmlColorTxt(vip, Enum_ColorUtil_Dark.GREEN)
			let ratio_str = Util.HtmlColorTxt(ratio, Enum_ColorUtil_Dark.GREEN)
			let invalid = 0//VipModel.GetInstance().IsInvalidCard()
			// [ts2lua]lua中0和空字符串也是true，此处invalid需要确认
			let invalid_str = invalid && "（已过期）" || ""
			this._lb_vip_tips.style.fontSize = 22
			this._lb_vip_tips.style.valign = "center"
			this._lb_vip_tips.style.color = "#93847d"
			this._lb_vip_tips.width = 500
			this._lb_vip_tips.innerHTML = Util.StrToHTML("当前VIP" + vip_str + invalid_str + ",税率降为" + ratio_str + "%")
			let price = Math.floor(aprice * (1 - ratio * 0.01))
			this._lb_price_tips.text = String(price)
			this.InitAwardItem(basic)
			//LayoutRebuilder(this._Group2)
		}

		this.InitAwardItem = (basic?) => {
			if (!award_item_) {
				award_item_ = new EquipmentItem(this._group_item)
				award_item_.Load()
			}
			award_item_.SetData(basic.type_id)
		}


	}

	public Open(...new_args) {

		let parms = new_args
		this.Local_Open(parms)
		super.Open()
	}



	public GetComponents() {
		[
			this._Image111,
			this._Image2,
			this._Group1,
			this._Image3,
			this._Label1,
			this._Image4,
			this._btn_go,
			this._Image1,
			this.labelDisplay1,
			this._btn_close,
			this._Image11,
			this.labelDisplay,
			this._Image5,
			this._lb_goods,
			this._lb_price,
			this._Label2,
			this._lb_vip_tips,
			this._group_item,
			this._Image6,
			this._Group2,
			this._Label3,
			this._Image7,
			this._lb_price_tips,
		]
			= this.GetChildrenByNames([

				"_Image111",
				"_Image2",
				"_Group1",
				"_Image3",
				"_Label1",
				"_Image4",
				"_btn_go",
				"_Image1",
				"labelDisplay1",
				"_btn_close",
				"_Image11",
				"labelDisplay",
				"_Image5",
				"_lb_goods",
				"_lb_price",
				"_Label2",
				"_lb_vip_tips",
				"_group_item",
				"_Image6",
				"_Group2",
				"_Label3",
				"_Image7",
				"_lb_price_tips",
			])
	}
}
window["MarketSellTipView"] = MarketSellTipView