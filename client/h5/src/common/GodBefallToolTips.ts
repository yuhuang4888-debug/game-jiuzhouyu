import { EquipModel } from "../commonModel/EquipModel";
import { GodBefallEvent, GodBefallModel } from "../commonModel/GodBefallModel";
import { GoodsModel } from "../commonModel/GoodsModel";
import { Message } from "../sysInfo/SysInfoController";
import { ColorUtil, Enum_ColorUtil_Dark } from "../util/ColorUtil";
import { GlobalEventSystem } from "../util/DeclareGlobalVar";
import { Util } from "../util/Util";
import { BaseView1 } from "./BaseView1";
import { EquipmentItem } from "./EquipmentItem";
import { EventName } from "./EventName";
import { Enum_UILayer } from "./LayerManager";
import { ModuleType } from "./RedDotManager";
import { MarketModel, MarketEvent } from "../commonModel/MarketModel"
import { CompositeModel } from "../commonModel/CompositeModel";
import { GameResPath } from "../util/GameResPath";

export class GodBefallToolTips extends BaseView1 {
	Clear
	InitEvent
	LoadSuccess
	UpdateView
	RefreshBtn
	SetData

	public constructor() {
		super()
		this.base_file = "common"
		this.layout_file = "GodBefallToolTips"
		this.layer_value = Enum_UILayer.Activity
		this.destroy_imm = true
		this.use_background = true
		this.is_center = true
		this.back_login_toClose = true
		this.click_bg_toClose = true

		let model = GodBefallModel.GetInstance(),
			local_Util = Util,
			request_proto = GodBefallEvent.REQUEST_PROTO,
			_item_: EquipmentItem,
			_type_id_,
			_goods_vo_,
			_btn_list_

		this.load_callback = function () {
			this.InitEvent()
			this.LoadSuccess()
		}
		this.destroy_callback = function () {
			this.Clear()
		}
		this.open_callback = function () {
			this.UpdateView()
		}
		this.Clear = () => { }

		this.InitEvent = () => {
			local_Util.AddClickEvent(this._btn_com, () => {
				this.Close()
				let data_list = model.CheckCompositeData(_goods_vo_)
				let [can, dtype_dic, type_dic, mat_list] = data_list
				if (can) {
					let data = model.GetEquipData(_goods_vo_.type_id)
					model.Fire(request_proto, 44014, "il", data.composite_rule, _goods_vo_.goods_id)
					// if (local_Util.TableSize(type_dic) && !model._com_mark) {
					// 	GlobalEventSystem.Fire(EventName.OPEN_VIEW, "GodBefallComTipsView", _goods_vo_, data_list)
					// } else {
					// 	let data = model.GetEquipData(_goods_vo_.type_id)
					// 	model.Fire(request_proto, 44014, "il", data.composite_rule, _goods_vo_.goods_id)
					// 	// CompositeModel.GetInstance().Fire(CompositeEvent.REQUEST_PROTO, data.composite_rule, mat_list, [])
					// }
				} else {
					Message.show("材料不足")
				}
			}, this, true)

			local_Util.AddClickEvent(this._btn_out, () => {
				if (!model._cur_data || !_goods_vo_) return
				let data = model.GetEquipData(_type_id_)
				if (!data) return
				model.Fire(request_proto, 44013, "ic", model._cur_data.id, data.pos)
				this.Close()
			}, this, true)

			local_Util.AddClickEvent(this._btn_equip, () => {
				if (!model._cur_data || !_goods_vo_) return
				model.Fire(request_proto, 44012, "li", _goods_vo_.goods_id, model._cur_data.id)
				this.Close()
			}, this, true)

			local_Util.AddClickEvent(this._btn_ok, () => {
				this.Close()
			}, this, true)

			local_Util.AddClickEvent(this._btn_com_out, () => {
				if (!_goods_vo_) return
				CompositeModel.GetInstance().Fire(CompositeModel.UNINSTALL_EQUIP, _goods_vo_.goods_id)
				this.Close()
			}, this, true)

			local_Util.AddClickEvent(this.outShelfBtn, () => {
				if (!_goods_vo_) return
					MarketModel.GetInstance().Fire(MarketEvent.REQUEST_PROTO, 15108, "clii", 1, _goods_vo_.id, _goods_vo_.type_id, _goods_vo_.goods_num)
				this.Close()
			}, this, true)

			local_Util.AddClickEvent(this._btn_sell, () => {
				if (!_goods_vo_) return
				if (!GoodsModel.GetInstance().GetGoodsVoByGoodsId(_goods_vo_.goods_id)) {
					Message.show("物品不存在")
					MarketModel.GetInstance().Fire(MarketEvent.NEED_UPDATE_BAG)
				} else {
					MarketModel.GetInstance().Fire(MarketEvent.OPEN_VIEW, "MarketSellCtrlView", _goods_vo_)
				}
				this.Close()
			}, true)

		}

		this.LoadSuccess = () => {
			this._lb_attr.width = 380
			this._lb_attr.style.fontSize = 20
			this._lb_attr.style.color = "#663915"
			this._lb_attr.style.leading = 8
			
			_item_ = new EquipmentItem(this._gp_item)
			_item_.Load()
			_item_.SetShowTips(false)
			_item_.ChangeCountVisible(false)
			_item_.SetItemSize(84, 84)
		}

		this.UpdateView = () => {
			this.RefreshBtn()
			let basic = GoodsModel.GetInstance().GetGoodsBasicByTypeId(_type_id_)
			if (!basic) return
			let data = model.GetEquipData(_type_id_)
			if (!data) return

			this.ingf2.skin = GameResPath.GetIcon('common4', 'ui_tips_pz_' + basic.color)
			// let color = ColorUtil.GetColorDark(data.color, false)
			// this._lb_name.color = color
			this._lb_name.text = basic.goods_name
			this._lb_pos.text = model.GetGodEquipPosName(data.pos)
			this._lb_type.text = model.GetGodEquipTypeName(data.limit)
			let edata = EquipModel.GetInstance().GetEquipData(_type_id_)
			this._lb_score.text = edata.base_rating
			let attr_list = JSON.parse(data.attr)
			// this._lb_score.text = Util.CalAttrPower(attr_list, false).toString()
			let attr_str = model.GetAttrStr(attr_list, Enum_ColorUtil_Dark.GREEN)
			this._lb_attr.innerHTML = local_Util.StrToHTML(attr_str)
			this._lb_attr.width = 380
			_item_.SetData(_type_id_)

			let show = _btn_list_.indexOf(1) != -1
			if (show && model._cur_data) {
				let id = model._cur_data.id * 10000 + data.pos
				this._reddot.visible = model.GetRedStatus(ModuleType.GOD_QUICK_COM, id)
			}

			let attr_height = attr_list.length * 28
			if(attr_height < 88) attr_height = 88

			let height = this._lb_attr.y + attr_height + 10 
			this._gp_btn.y = height
			height += 26
			if(_btn_list_.length > 0){
				height += 52 
			}
			this.img1.height = height
			this.display_obj.height = height
		}

		this.RefreshBtn = () => {
			let btn
			for (let i = 0; i < this._gp_btn.numChildren; i++) {
				let show = _btn_list_.indexOf(i) != -1
				btn = this._gp_btn.getChildAt(i)
				if (btn) {
					btn.visible = show
					btn.includeInLayout = show
					btn.width = show ? 180 : 0.1
				}
			}
			let btn_x = _btn_list_.length == 1 ? 112 : 8
			this._gp_btn.x = btn_x
		}

		this.SetData = (type_id: number, goods_vo?: any, btn_list?: Array<number>) => {
			_type_id_ = type_id
			_goods_vo_ = goods_vo
			_btn_list_ = btn_list || [3]
		}
	}

	img1: Laya.Image
	ingf2: Laya.Image
	img3: Laya.Image
	_lb_name: Laya.Label
	_lb_title1: Laya.Label
	_lb_title2: Laya.Label
	_lb_title3: Laya.Label
	_lb_score: Laya.Label
	_lb_type: Laya.Label
	_lb_pos: Laya.Label
	label1: Laya.Label
	_lb_attr: Laya.HTMLDivElement
	_gp_item: Laya.Box
	_gp_btn: Laya.HBox
	_btn_out: Laya.Box
	_Image1: Laya.Image
	labelDisplay1: Laya.Label
	_btn_com: Laya.Box
	_Image2: Laya.Image
	labelDisplay2: Laya.Label
	_btn_sell: Laya.Box
	_Imag3: Laya.Image
	labelDisplay3: Laya.Label
	_btn_ok: Laya.Box
	_Image4: Laya.Image
	labelDisplay4: Laya.Label
	_btn_com_out: Laya.Box
	_Image5: Laya.Image
	labelDisplay5: Laya.Label
	_btn_equip: Laya.Box
	_Image6: Laya.Image
	labelDisplay6: Laya.Label
	outShelfBtn: Laya.Box
	_Image7: Laya.Image
	labelDisplay7: Laya.Label
	_reddot: Laya.Image
	public GetComponents() {
		[
			this.img1,
			this.ingf2,
			this.img3,
			this._lb_name,
			this._lb_title1,
			this._lb_title2,
			this._lb_title3,
			this._lb_score,
			this._lb_type,
			this._lb_pos,
			this.label1,
			this._lb_attr,
			this._gp_item,
			this._gp_btn,
			this._btn_out,
			this._Image1,
			this.labelDisplay1,
			this._btn_com,
			this._Image2,
			this.labelDisplay2,
			this._btn_sell,
			this._Imag3,
			this.labelDisplay3,
			this._btn_ok,
			this._Image4,
			this.labelDisplay4,
			this._btn_com_out,
			this._Image5,
			this.labelDisplay5,
			this._btn_equip,
			this._Image6,
			this.labelDisplay6,
			this.outShelfBtn,
			this._Image7,
			this.labelDisplay7,
			this._reddot,
		]
			= this.GetChildrenByNames([
				"img1",
				"ingf2",
				"img3",
				"_lb_name",
				"_lb_title1",
				"_lb_title2",
				"_lb_title3",
				"_lb_score",
				"_lb_type",
				"_lb_pos",
				"label1",
				"_lb_attr",
				"_gp_item",
				"_gp_btn",
				"_btn_out",
				"_Image1",
				"labelDisplay1",
				"_btn_com",
				"_Image2",
				"labelDisplay2",
				"_btn_sell",
				"_Imag3",
				"labelDisplay3",
				"_btn_ok",
				"_Image4",
				"labelDisplay4",
				"_btn_com_out",
				"_Image5",
				"labelDisplay5",
				"_btn_equip",
				"_Image6",
				"labelDisplay6",
				"outShelfBtn",
				"_Image7",
				"labelDisplay7",
				"_reddot",
			])
	}
}
window["GodBefallToolTips"] = GodBefallToolTips