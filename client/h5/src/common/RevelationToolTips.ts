import { BaseView1 } from "./BaseView1"
import { table } from "./table"
import { Util, HtmlColorTxt, RefGridLayout, AtlasUrl } from "../util/Util"
import { Enum_UILayer } from "./LayerManager"
import { TimeUtil } from "../util/TimeUtil"
import { RevelationModel, RevelationEvent } from "../commonModel/RevelationModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { RoleManager } from "../commonModel/RoleManager"
import { WordManager } from "./WordManager"
import { ErlangParser } from "../util/ErlangParser"
import { ColorUtil, Enum_ColorUtil_Dark, Enum_ColorUtil_Light } from "../util/ColorUtil"
import { EquipmentItem } from "./EquipmentItem"
import { HolySealToolSuitAttrItem } from "./HolySealToolSuitAttrItem"
import { ResManager } from "./ResManager"
import { GameResPath } from "../util/GameResPath"
import { MarketModel, MarketEvent } from "../commonModel/MarketModel"
import { Message } from "../sysInfo/SysInfoController"

export class RevelationToolTips extends BaseView1 {
	res_mgr

	GetBaseAndStrenProStr
	LoadSuccess
	InitEvent
	InitView
	RebuildTimer
	RefreshBtnState
	Remove
	SetData
	UpdateSuitData

	public static Btn = { upShelf: 0, replace: 1, unload: 2, close: 3, outShelf: 4 }

	public constructor() {
		super()
		this.base_file = "common"
		this.layout_file = "RevelationToolTips"
		this.layer_value = Enum_UILayer.Activity
		this.destroy_imm = true
		this.use_background = true
		this.click_bg_toClose = true
		this.is_center = true
		this.show_open_movie = true

		this.res_mgr = ResManager.GetInstance()
		let local_TimeUtil = TimeUtil
		let model = RevelationModel.GetInstance()
		let request_proto = RevelationEvent.REQUEST_PROTO
		let market_model = MarketModel.GetInstance()
		let local_MarketEvent = MarketEvent
		let role_mgr = RoleManager.GetInstance()
		let goods_model = GoodsModel.GetInstance()

		let local_Enum_ColorUtil_Dark = Enum_ColorUtil_Dark
		let local_Enum_ColorUtil_Light = Enum_ColorUtil_Light
		let local_WordManager = WordManager
		let local_RevelationModel = RevelationModel
		let _role_id = 0
		let _type_id = 0
		let _pos_x = 0
		let _pos_y = 0
		let _goods_vo = null
		let _goods_icon = null
		let _btn_list = null
		let _show_btn_list = null
		let _suitNum = null
		let _suit_item_list = null

		this.load_callback = () => {
			this.LoadSuccess()
			this.InitEvent()
		}

		this.open_callback = () => {
			this.InitView()
		}

		this.close_callback = () => {
			if (this.RebuildTimer) {
				clearTimeout(this.RebuildTimer)
				this.RebuildTimer = null
			}
		}

		this.destroy_callback = () => {
			this.Remove()
		}

		this.Remove = () => {
			if (_goods_icon) {
				_goods_icon.DeleteMe()
				_goods_icon = null
			}
			_suitNum = null
			if (_suit_item_list) {
				for (let _tmpi in _suit_item_list) {
					let obj = _suit_item_list[_tmpi]
					obj.DeleteMe()
				}
				_suit_item_list = null
			}
		}

		this.LoadSuccess = () => {
			this.content_scroll.vScrollBar.visible = false

			this._lb_rating.width = 271
			this._lb_rating.style.fontSize = 22
			// this._lb_rating.style.color = "#663915"
			this._lb_rating.style.color = "#ffffff"

			this._lb_level.width = 271
			this._lb_level.style.fontSize = 22
			this._lb_level.style.color = "#ffffff"
			// this._lb_level.style.color = "#663915"

			this._lb_career.width = 195
			this._lb_career.style.fontSize = 20
			this._lb_career.style.color = "#663915"
			this._lb_career.style.bold = true


			this._lb_pos.width = 195
			this._lb_pos.style.fontSize = 20
			this._lb_pos.style.color = "#663915"
			this._lb_pos.style.bold = true


			this._lb_base_attr.width = 310
			this._lb_base_attr.style.fontSize = 19
			this._lb_base_attr.style.color = "#663915"
			this._lb_base_attr.style.leading = 4
			// this._lb_base_attr.style.bold = true


			this._lb_extra_attr.width = 310
			this._lb_extra_attr.style.fontSize = 19
			this._lb_extra_attr.style.color = "#663915"
			this._lb_extra_attr.style.leading = 4
			// this._lb_extra_attr.style.bold = true

		}

		this.InitEvent = () => {
			Util.AddClickEvent(this._btn_close, () => {
				this.Close()
			}, this, true)

			let next_time = null
			Util.AddClickEvent(this._btn_replace, () => {
				if (!_goods_vo) {
					return
				}
				if (!next_time || next_time < local_TimeUtil.getServerTime()) {
					next_time = local_TimeUtil.getServerTime() + 1
					model.Fire(request_proto, 28601, "l", _goods_vo.goods_id)
					this.Close()
				}
			}, this, true)

			Util.AddClickEvent(this._btn_upShelf, () => {
				if (!goods_model.GetGoodsVoByGoodsId(_goods_vo.goods_id)) {
					Message.show("物品不存在")
					market_model.Fire(MarketEvent.NEED_UPDATE_BAG)
				} else {
					market_model.Fire(local_MarketEvent.OPEN_VIEW, "MarketSellCtrlView", _goods_vo)
				}
				this.show_open_movie = false
				this.Close()
			}, this, true)

			Util.AddClickEvent(this._btn_unload, () => {
				if (_goods_vo) {
					model.Fire(request_proto, 28602, "l", _goods_vo.goods_id)
					this.Close()
				}
			}, this, true)

			Util.AddClickEvent(this._btn_outShelf, () => {
				if (!_goods_vo) {
					return
				}
				let goods_vo = _goods_vo
				market_model.Fire(local_MarketEvent.REQUEST_PROTO, 15108, "clii", 1, goods_vo.goods_id || goods_vo.id, goods_vo.type_id, goods_vo.goods_num)
				this.Close()
			}, this, true)
		}

		this.SetData = (type_id?, goods_vo?, role_id?, show_btn_list?, suitNum?) => {
			_type_id = type_id
			_role_id = role_id
			_show_btn_list = show_btn_list && show_btn_list || [3]
			_suitNum = suitNum
			let main_role_id = role_mgr.GetMainRoleId()
			_goods_vo = goods_vo || goods_model.GetGoodsBasicByTypeId(type_id)
		}

		this.InitView = () => {
			let basic = goods_model.GetGoodsBasicByTypeId(_type_id)
			if (basic == null) {
				return
			}
			let equipCfg = this.res_mgr.GetGameConfigFromCache(this, "config_revelation_equip_attr", false)
			if (!equipCfg) {
				return
			}
			if (!_goods_icon) {
				_goods_icon = new EquipmentItem(this._gp_icon)
				_goods_icon.Load()
				_goods_icon.SetItemSize(92, 92)
				_goods_icon.ChangeCountVisible(false)
			}
			// _goods_icon.SetData(basic.type_id, 1)
			_goods_icon.SetData(basic.type_id)

			let star = equipCfg[_type_id] && equipCfg[_type_id].star || 0
			_goods_icon.SetStar(star)
			_goods_icon.SetShowTips(false)

			let color_str = ColorUtil.GetColorDark(basic.color)
			this._lb_name.text = basic.goods_name
			//this._lb_name.color = color_str
			this.nameBG.skin = AtlasUrl("common4", "ui_tips_pz_" + basic.color)
			// this.res_mgr.SetImageSprite(this, this.nameBG, "common", "ts_title_bg" + basic.color)

			let revelation_data = equipCfg[basic.type_id]
			let goods_vo = _goods_vo
			let is_preview = true
			let is_wear_equip = false
			if (goods_vo.goods_id) {
				is_preview = false
			}
			if (is_preview) {
				let attr_list = []
				let base_attr = JSON.parse(revelation_data.recommend_attr)
				for (let _tmpi in base_attr) {
					let vo = base_attr[_tmpi]
					table.insert(attr_list, vo)
				}
				let other_attr = JSON.parse(revelation_data.other_attr)
				for (let _tmpi in other_attr) {
					let vo = other_attr[_tmpi]
					table.insert(attr_list, vo)
				}
				this._lb_rating.innerHTML = Util.StrToHTML("装备评分：<font color='#ffe222'>" + Util.CalAttrPower(attr_list, false) + "</font>")
			} else {
				is_wear_equip = model.GetWearEquipInfo(goods_vo.goods_id) && true
				if(goods_vo.score){
					this._lb_rating.innerHTML = Util.StrToHTML(is_wear_equip && ("综合评分：<font color='#ffe222'>" + goods_vo.score + "</font>") || ("装备评分：<font color='#ffe222'>" + goods_vo.score + "</font>"))
				}else{
					this._lb_rating.innerHTML = Util.StrToHTML(is_wear_equip && ("综合评分：<font color='#ffe222'>" + goods_vo.overall_rating + "</font>") || ("装备评分：<font color='#ffe222'>" + goods_vo.rating + "</font>"))
				}
			}

			let base_attr = revelation_data.recommend_attr
			if (base_attr) {
				base_attr = JSON.parse(base_attr)
				let stren_attr = null
				this._lb_base_attr.innerHTML = this.GetBaseAndStrenProStr(base_attr, stren_attr)
				this._lb_base_attr.width = 310
				this._lb_base_attr.height = this._lb_base_attr.contextHeight
			}

			this._lb_career.innerHTML = Util.StrToHTML("职业：<font color='#d15e00'>通用</font>")
			this._lb_pos.innerHTML = "部位：<font color='#d15e00'>" + model.GetEquipTypeName(basic.subtype) + "</font>"
			this._lb_pos.x = 250
			let role_lv = role_mgr.GetMainRoleVo().level
			// let lv_color = role_lv >= basic.level && "'#c85a37'" || local_Enum_ColorUtil_Dark.RED
			let lv_color = role_lv >= basic.level && "'#ffe222'" || local_Enum_ColorUtil_Light.RED
			this.sc_img.visible = basic.level > 370
			let lv = basic.level > 370 ? (basic.level - 370) : basic.level
			let lv_str = HtmlColorTxt(lv, lv_color)
			let lv_space = basic.level > 370 ? "&nbsp;&nbsp;&nbsp;" : " "
			this._lb_level.innerHTML = Util.StrToHTML("等级：" + lv_space + lv_str)

			let extra_attr = revelation_data.other_attr
			if (extra_attr) {
				extra_attr = JSON.parse(extra_attr)
				let str = ""
				let val
				for (let i = 0; i < extra_attr.length; i++) {
					val = extra_attr[i]
					if (i != extra_attr.length) {
						str = str + local_WordManager.GetProperties(val[0]) + " <font color='#c85a37'>&nbsp;+" + local_WordManager.ConvertToPercentValue(val[0], val[1]) + "</font><br/>"
					} else {
						str = str + local_WordManager.GetProperties(val[0]) + " <font color='#c85a37'>&nbsp;+" + local_WordManager.ConvertToPercentValue(val[0], val[1]) + "</font>"
					}
				}
				if (str == "") {
					str = "无"
				}
				this._lb_extra_attr.innerHTML = str
				this._lb_extra_attr.width = 310
				this._lb_extra_attr.height = this._lb_extra_attr.contextHeight
			}

			this.RefreshBtnState()

			if (_suitNum != null) {
				this.UpdateSuitData(_suitNum, star)
			} else {
				let my_count = 0
				let list = goods_model.revelation_equip_list
				if (list && list.length > 0) {
					for (let _tmpi in list) {
						let vo = list[_tmpi]
						if (vo && vo.star >= star) {
							my_count = my_count + 1
						}
					}
				}
				this.UpdateSuitData(my_count, star)
			}

			//this._gp_extra_attr.height = this._lb_extra_attr.y + this._lb_extra_attr.height + 12
			//this.height = this._gp_btns.height + this._gp_btns.y + 16
			/*
			this.RebuildTimer = setTimeout(() => {
				UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(this.Content)
				this.RebuildTimer = null
			}, 0.3)
			*/
			//this.res_mgr.SetOutsideImageSprite(this, this._Image5, GameResPath.GetIcon("common2", "uity_016c"), true)
		}

		this.GetBaseAndStrenProStr = (base_attrlist?, stren_list?) => {
			let str = ""
			let stren_str = null
			let pro = null
			let val
			if (base_attrlist) {
				for (let i = 0; i < base_attrlist.length; i++) {
					val = base_attrlist[i]
					//for (let i = 1; i <= stren_list.length; i++){
					//pro = stren_list[i]
					//if ((pro && pro[1] == val[1]) && pro[2] > 0 ) {
					//stren_str = " <font color='639c12'.length>(强化+" + pro[2] + ")</font>"
					//break
					//}
					//}
					if (i != base_attrlist.length) {
						str = str + local_WordManager.GetProperties(val[0]) + ":&nbsp;&nbsp; <font color='#d15e00'>" + local_WordManager.ConvertToPercentValue(val[0], val[1]) + "</font><br/>"
					} else {
						str = str + local_WordManager.GetProperties(val[0]) + ":&nbsp;&nbsp; <font color='#d15e00'>" + val[1] + "</font>"
					}
				}
			}
			return str
		}

		this.RefreshBtnState = () => {
			let btn = null
			let btnNum = 4
			for (let i = 0; i < btnNum; i++) {
				let show = Util.TableContains(_show_btn_list, i)
				btn = this._gp_btns.getChildAt(i)
				if (btn) {
					btn.visible = show
				}
			}

			RefGridLayout(this._gp_btns, {
				frist_item_space: 30,
				column: 2,
				h_gap: 6,
				v_gap: 0,
				item_w: 142,
				item_h: 52
			})
		}

		this.UpdateSuitData = (count?, curStar?) => {
			let suit_id = null
			let my_count = count || 0
			this._gp_suit_attr_con.visible = true
			this._lb_suit_value.visible = false
			if (!_suit_item_list) {
				_suit_item_list = []
			}
			let suitCfg = this.res_mgr.GetGameConfigFromCache(this, "config_revelation_equip_suit", false)
			let index = 0
			let suit_height = 0
			let item_height = 0
			let desc = ""
			for (let _tmpi in local_RevelationModel.StarList) {
				let vo = local_RevelationModel.StarList[_tmpi]
				let suit_cfg = suitCfg[curStar + "@" + vo]
				if (suit_cfg) {
					if (desc == "") {
						desc = suit_cfg.name
					}
					let suit_attr = JSON.parse(suit_cfg.attr)
					let item = _suit_item_list[index]
					if (!item) {
						item = new HolySealToolSuitAttrItem(this._gp_suit_attr_con)
						_suit_item_list[index] = item
						item.Load()
					}
					item.SetData({ 0: vo, 1: suit_attr }, my_count)
					item_height = item.GetHeight()
					item.SetPosition(0, suit_height)
					suit_height += item_height
					index = index + 1
				}
			}
			this._gp_suit.height = 30 + suit_height
			let max_count = local_RevelationModel.StarList[local_RevelationModel.StarList.length - 1]
			this._lb_suit_value.text = desc
			desc = desc + "  (" + my_count + "/" + max_count + ")"
			this._lb_suit_name.text = desc
		}
	}
	
	bg: Laya.Image
	_gp_icon: Laya.Box
	nameBG: Laya.Image
	_lb_name: Laya.Label
	_lb_rating: Laya.HTMLDivElement
	_lb_level: Laya.HTMLDivElement
	content_scroll: Laya.Panel
	content_group: Laya.VBox
	base_pro_conta: Laya.Box
	line1: Laya.Image
	base: Laya.Label
	_lb_base_attr: Laya.HTMLDivElement
	_gp_extra_attr: Laya.Box
	line8: Laya.Image
	spec: Laya.Label
	_lb_extra_attr: Laya.HTMLDivElement
	_gp_suit: Laya.Box
	line9: Laya.Image
	_lb_suit_name: Laya.Label
	_gp_suit_attr_con: Laya.Box
	_lb_suit_value: Laya.Label
	_Image3: Laya.Image
	_lb_career: Laya.HTMLDivElement
	_lb_pos: Laya.HTMLDivElement
	_gp_btns: Laya.Box
	_btn_upShelf: Laya.Box
	img_upShelf: Laya.Image
	lb_upShelf: Laya.Label
	_btn_replace: Laya.Box
	img_replace: Laya.Image
	lb_replace: Laya.Label
	_btn_unload: Laya.Box
	img_unload: Laya.Image
	lb_unload: Laya.Label
	_btn_close: Laya.Box
	img_close: Laya.Image
	lb_close: Laya.Label
	_btn_outShelf: Laya.Box
	img_outShelf: Laya.Image
	lb_outShelf: Laya.Label
	sc_img: Laya.Image
	public GetComponents() {
		[
			this.bg,
			this._gp_icon,
			this.nameBG,
			this._lb_name,
			this._lb_rating,
			this._lb_level,
			this.content_scroll,
			this.content_group,
			this.base_pro_conta,
			this.line1,
			this.base,
			this._lb_base_attr,
			this._gp_extra_attr,
			this.line8,
			this.spec,
			this._lb_extra_attr,
			this._gp_suit,
			this.line9,
			this._lb_suit_name,
			this._gp_suit_attr_con,
			this._lb_suit_value,
			this._Image3,
			this._lb_career,
			this._lb_pos,
			this._gp_btns,
			this._btn_upShelf,
			this.img_upShelf,
			this.lb_upShelf,
			this._btn_replace,
			this.img_replace,
			this.lb_replace,
			this._btn_unload,
			this.img_unload,
			this.lb_unload,
			this._btn_close,
			this.img_close,
			this.lb_close,
			this._btn_outShelf,
			this.img_outShelf,
			this.lb_outShelf,
			this.sc_img,
		]
			= this.GetChildrenByNames([

				"bg",
				"_gp_icon",
				"nameBG",
				"_lb_name",
				"_lb_rating",
				"_lb_level",
				"content_scroll",
				"content_group",
				"base_pro_conta",
				"line1",
				"base",
				"_lb_base_attr",
				"_gp_extra_attr",
				"line8",
				"spec",
				"_lb_extra_attr",
				"_gp_suit",
				"line9",
				"_lb_suit_name",
				"_gp_suit_attr_con",
				"_lb_suit_value",
				"_Image3",
				"_lb_career",
				"_lb_pos",
				"_gp_btns",
				"_btn_upShelf",
				"img_upShelf",
				"lb_upShelf",
				"_btn_replace",
				"img_replace",
				"lb_replace",
				"_btn_unload",
				"img_unload",
				"lb_unload",
				"_btn_close",
				"img_close",
				"lb_close",
				"_btn_outShelf",
				"img_outShelf",
				"lb_outShelf",
				"sc_img",
			])
	}
}
window["RevelationToolTips"] = RevelationToolTips