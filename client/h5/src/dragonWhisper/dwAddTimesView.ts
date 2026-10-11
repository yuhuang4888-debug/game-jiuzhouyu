import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { Config } from "../common/Config"
import { Util, HtmlColorTxt } from "../util/Util"
import { EventName } from "../common/EventName"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GoodsModel } from "../commonModel/GoodsModel"
import { DragonWhisperModel, DrWsEvent } from "../commonModel/DragonWhisperModel"
import { ColorType, ColorUtil, Enum_ColorUtil_Dark } from "../util/ColorUtil"
import { UIToolTipMgr } from "../common/UIToolTipMgr"
import { Message } from "../sysInfo/SysInfoController"
import { ResManager } from "../common/ResManager"
import { GameResPath } from "../util/GameResPath"

export class dwAddTimesView extends BaseView1 {
	InitEvent
	LoadSuccess
	SendEnterProto
	UpdateView

	public constructor() {
		super()
		this.base_file = "dragonWhisper"
		this.layout_file = "dwAddTimesView"
		this.layer_value = Enum_UILayer.Activity
		this.show_open_movie = true
		this.change_scene_close = true
		this.use_background = true
		this.click_bg_toClose = true
		this.destroy_imm = true
		this.is_center = true

		let _model = DragonWhisperModel.GetInstance()
		let goods_model = GoodsModel.GetInstance()
		let local_DrWsEvent = DrWsEvent
		let _enough_ = false
		let _cost_data_ = null
		let _map_id_ = null

		this.load_callback = () => {
			this.LoadSuccess()
		}

		this.LoadSuccess = () => {
			this.UpdateView()
			this.InitEvent()
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this._btn_close, () => {
				this.Close()
			}, this, true)

			Util.AddClickEvent(this._btn_cancel, () => {
				this.Close()
			}, this, true)

			Util.AddClickEvent(this._btn_ok, () => {
				let vinfo = _model.GetViewInfo()
				if (!vinfo) {
					return
				}
				if (vinfo.left_count <= 0) {
					Message.show("次数不足，无法增加")
				} else if (!_enough_) {
					if (!_cost_data_) {
						return
					}
					let cdata = _cost_data_
					let own = goods_model.GetTypeGoodsNum(cdata.type_id)
					let cost = cdata.price * cdata.need - own
					let str = "可消耗<font color='#639c12'>" + cost + "</font>绑玉或勾玉增加1次时间(优先消耗绑玉)"
					GlobalEventSystem.Fire(EventName.OPEN_VIEW, "BossPersonalAlert", cdata.type_id, own, cdata.need, cdata.price, null, cdata.name, null, () => {
						this.SendEnterProto(1)
					}, str, "增加时间")
				} else {
					this.SendEnterProto(0)
				}
			}, this, true)

			Util.AddClickEvent(this._img_ticket, () => {
				if (!_cost_data_) {
					return
				}
				UIToolTipMgr.GetInstance().AppendGoodsTips(_cost_data_.type_id)
			}, this, true)

			this.BindEvent(_model, local_DrWsEvent.BUY_TIME_SUCCESS, () => {
				this.Close()
			})
		}

		this.UpdateView = () => {
			let vinfo = _model.GetViewInfo()
			if (!vinfo) {
				return
			}
			let sinfo = _model.GetSceneInfo()
			if (!sinfo) {
				return
			}
			_map_id_ = sinfo.map_id
			let map_cfg = Config.PRELOAD_SERVER_CONFIG.config_dragon_language_map
			let mdata = map_cfg[_map_id_]
			let cost_list = JSON.parse(mdata.cost)
			let tar_count = vinfo.all_count - vinfo.left_count + 1
			tar_count = Math.min(tar_count, cost_list.length)
			let cdata = null
			for (let _tmpi in cost_list) {
				let vo = cost_list[_tmpi]
				if (Number(vo[0]) == tar_count) {
					cdata = vo[1][0]
					break
				}
			}
			let [type_id, lock] = goods_model.GetMappingTypeId(cdata[0], cdata[1])
			let basic = goods_model.GetGoodsBasicByTypeId(type_id)
			let goods_info = Config.PRELOAD_SERVER_CONFIG.config_goods_price[type_id]
			let own = goods_model.GetTypeGoodsNum(type_id)
			_enough_ = cdata && own >= Number(cdata[2]) || false
			_cost_data_ = { type_id: type_id, need: Number(cdata[2]), name: basic.goods_name, price: goods_info.price }
			let color = _enough_ ? ColorUtil.GetColorDark(ColorType.GREEN, false) : ColorUtil.GetColorDark(ColorType.RED, false)
			this._lb_own.color = color
			this._lb_own.text = own + "/" + cdata[2]
			color = vinfo.left_count > 0 ? ColorUtil.GetColorDark(ColorType.GREEN, false) : ColorUtil.GetColorDark(ColorType.RED, false)
			this._lb_count.color = color
			this._lb_count.text = vinfo.left_count + "/" + vinfo.all_count
			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_ticket, GameResPath.GetGoodsIconPath(basic.goods_icon))
		}

		this.SendEnterProto = (auto?) => {
			if (!_map_id_) {
				return
			}
			_model.Fire(local_DrWsEvent.PROTO, 65107, "cc", _map_id_, auto)
		}
	}

	_img_bg: Laya.Image
	_img_bg2: Laya.Image
	_gp_title: Laya.Image
	_lb_title: Laya.Label
	_btn_close: Laya.Image
	_Group2: Laya.Box
	_Label2: Laya.Label
	_lb_count: Laya.Label
	_btn_add: Laya.Image
	_Group5: Laya.HBox
	_Label3: Laya.Label
	_img_ticket: Laya.Image
	_lb_own: Laya.Label
	_lb_content: Laya.Label
	_btn_cancel: Laya.Box
	_Image1: Laya.Image
	labelDisplay1: Laya.Label
	_btn_ok: Laya.Box
	_Image11: Laya.Image
	labelDisplay: Laya.Label
	public GetComponents() {
		[
			this._img_bg,
			this._img_bg2,
			this._gp_title,
			this._lb_title,
			this._btn_close,
			this._Group2,
			this._Label2,
			this._lb_count,
			this._btn_add,
			this._Group5,
			this._Label3,
			this._img_ticket,
			this._lb_own,
			this._lb_content,
			this._btn_cancel,
			this._Image1,
			this.labelDisplay1,
			this._btn_ok,
			this._Image11,
			this.labelDisplay,
		]
			= this.GetChildrenByNames([
				"_img_bg",
				"_img_bg2",
				"_gp_title",
				"_lb_title",
				"_btn_close",
				"_Group2",
				"_Label2",
				"_lb_count",
				"_btn_add",
				"_Group5",
				"_Label3",
				"_img_ticket",
				"_lb_own",
				"_lb_content",
				"_btn_cancel",
				"_Image1",
				"labelDisplay1",
				"_btn_ok",
				"_Image11",
				"labelDisplay",
			])
	}
}
window["dwAddTimesView"] = dwAddTimesView