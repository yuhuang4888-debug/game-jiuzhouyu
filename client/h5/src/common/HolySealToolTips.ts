import { GoodsModel } from "../commonModel/GoodsModel"
import { HolySealModel } from "../commonModel/HolySealModel"
import { RoleManager } from "../commonModel/RoleManager"
import { Message } from "../sysInfo/SysInfoController"
import { ColorType, ColorUtil } from "../util/ColorUtil"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
// import { ErlangParser } from "../util/ErlangParser"
import { GameResPath } from "../util/GameResPath"
import { TimeUtil } from "../util/TimeUtil"
import { AtlasUrl, Util } from "../util/Util"
import { BaseView1 } from "./BaseView1"
import { EquipmentItem } from "./EquipmentItem"
import { EventName } from "./EventName"
import { Enum_UILayer } from "./LayerManager"
import { ResManager } from "./ResManager"
import { WordManager } from "./WordManager"
import { HolySealToolSuitAttrItem } from "./HolySealToolSuitAttrItem"
import { Config } from "./Config"
import { MarketEvent, MarketModel } from "../commonModel/MarketModel"

export class HolySealToolTips extends BaseView1 {
	Remove
	UpdateSuitData
	RefreshBtnState
	GetBaseAndStrenProStr
	UpdateView
	SetData
	InitEvent
	LoadSuccess
	SetDecomposeCost
	UpdateSize

	public static Btn = {
		upShelf: 0,
		replace: 1,
		dismantle: 2,
		close: 3,
		outShelf: 4,
		upStage: 5,
		upColor: 6,
		outEquip: 7
	}
	public constructor() {
		super()
		this.base_file = "common"
		this.layout_file = "HolySealToolTips"
		this.layer_value = Enum_UILayer.Activity
		this.destroy_imm = true
		this.use_background = true
		this.click_bg_toClose = true
		this.is_center = true
		this.show_open_movie = true

		this.load_callback = () => {
			this.LoadSuccess()
		}

		this.destroy_callback = () => {
			this.Remove()
		}

		this.preload_server_config = {
			"config_seal_strong": false,
			"config_seal_suit": false,
			"config_goods_decompose": false,
			"config_seal_kv": false,
			"GoodsSubtype": false
		}

		let goods_vo_ = null,
			type_id_ = 0,
			holy_seal_model_ = HolySealModel.GetInstance(),
			market_model_ = MarketModel.GetInstance(),
			goods_model_ = GoodsModel.GetInstance(),
			// erlang_parser_ = ErlangParser.GetInstance(),
			res_mgr_ = ResManager.GetInstance(),
			role_id_ = 0,
			suit_item_list_: Array<HolySealToolSuitAttrItem> = null,
			pos_x_ = 0,
			pos_y_ = 0,
			btn_list_ = null,
			show_btn_list_ = null,
			base_suit_id_ = null,
			goods_icon_ = null,
			local_JSON = JSON,
			have_suit = false,
			cache_resize = false


		this.Remove = () => {
			if (goods_icon_) {
				goods_icon_.DeleteMe()
				goods_icon_ = null
			}
			if (suit_item_list_) {
				for (let _tmpi in suit_item_list_) {
					var obj = suit_item_list_[_tmpi]
					obj.DeleteMe()
				}
				suit_item_list_ = null
			}
			GlobalEventSystem.Fire(EventName.CLOSE_TIPS_VIEW)
		}

		this.LoadSuccess = () => {

			btn_list_ = [
				this._btn_upShelf,
				this._btn_replace,
				this._btn_dismantle,
				this._btn_close,
				this._btn_outShelf,
				this._btn_upStage,
				this._btn_upColor,
				this._btn_outEquip,
			]
			let config_seal_kv = ResManager.GetInstance().GetGameConfigFromCache(this, "config_seal_kv", false)
			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_decompose_icon, GameResPath.GetGoodsIconPath(holy_seal_model_.GetkeyValue(2, config_seal_kv)))

			this._lb_rating.style.fontSize = 22
			this._lb_rating.style.color = "#ffffff"
			this._lb_rating.style.width = 200

			this._lb_level.style.fontSize = 22
			this._lb_level.style.color = "#ffffff"
			this._lb_level.style.width = 200

			this._lb_career.style.fontSize = 20
			this._lb_career.style.color = "#663915"
			this._lb_career.style.bold = true

			this._lb_pos.style.fontSize = 20
			this._lb_pos.style.color = "#663915"
			this._lb_pos.style.bold = true

			this._lb_base_attr.style.fontSize = 20
			this._lb_base_attr.style.color = "#663915"
			this._lb_base_attr.style.width = 340
			this._lb_base_attr.style.leading = 4


			this.InitEvent()
			this.UpdateView()
		}

		this.InitEvent = () => {
			this.BindEvent(holy_seal_model_, HolySealModel.UPDATE_SUIT_DATA, (data?) => {
				this.UpdateSuitData(data)
			})

			Util.AddClickEvent(this._btn_close, () => {
				this.Close()
			}, this, true)

			let next_time = null
			Util.AddClickEvent(this._btn_replace, () => {
				if (!goods_vo_) {
					return
				}
				if (!next_time || next_time < TimeUtil.getServerTime()) {
					next_time = TimeUtil.getServerTime() + 1
					holy_seal_model_.Fire(HolySealModel.REQUEST_CCMD_EVENT, 65403, goods_vo_.subtype, goods_vo_.goods_id)
					this.Close()
				}
			}, this, true)

			Util.AddClickEvent(this._btn_dismantle, () => {
				if (goods_vo_) {
					GlobalEventSystem.Fire(EventName.OPEN_VIEW, "HolySealDismantleView", goods_vo_)
				}
				// this.show_open_movie = false
				this.Close()
			}, this, true)

			Util.AddClickEvent(this._btn_upShelf, () => {
				if (!goods_model_.GetGoodsVoByGoodsId(goods_vo_.goods_id)) {
					Message.show("物品不存在")
					market_model_.Fire(MarketEvent.NEED_UPDATE_BAG)
				} else {
					market_model_.Fire(MarketEvent.OPEN_VIEW, "MarketSellCtrlView", goods_vo_)
				}
				// this.show_open_movie = false
				this.Close()
			}, this, true)

			Util.AddClickEvent(this._btn_outShelf, () => {
				if (!goods_vo_) {
					return
				}
				let goods_vo = goods_vo_
				market_model_.Fire(MarketEvent.REQUEST_PROTO, 15108, "clii", 1, goods_vo.id, goods_vo.type_id, goods_vo.goods_num)
				this.Close()
			}, this, true)
		}


		this.SetData = (type_id?, goods_vo?, role_id?, show_btn_list?) => {
			type_id_ = Number(type_id)
			role_id_ = role_id
			show_btn_list_ = show_btn_list && show_btn_list || [HolySealToolTips.Btn.close]
			goods_vo_ = goods_vo || goods_model_.GetGoodsBasicByTypeId(type_id)
		}


		this.UpdateView = () => {
			if (!goods_vo_) {
				return
			}
			let basic = goods_model_.GetGoodsBasicByTypeId(type_id_)
			if (basic == null) {
				return
			}
			if (!goods_icon_) {
				goods_icon_ = new EquipmentItem(this._gp_icon)
				let preload_server_config = goods_icon_.preload_server_config
				if (preload_server_config == null) {
					preload_server_config = {
						"config_seal_equip": false
					}
				}
				else {
					preload_server_config["config_seal_equip"] = false
				}
				goods_icon_.Load()
				goods_icon_.SetItemSize(92, 92)
				goods_icon_.ChangeCountVisible(false)
			}
			goods_icon_.SetData(basic.type_id, 1)
			goods_icon_.SetShowTips(false)

			// this._lb_name.text = Util.StrToHTML(Util.HtmlColorTxt(basic.goods_name, ColorUtil.GetColorDark(basic.color)))
			this._lb_name.text = basic.goods_name
			// this._img_name.source = "common_json.ts_title_bg" + basic.color + "_png"
			this._img_name.skin = AtlasUrl("common4", "ui_tips_pz_" + basic.color)
			this._img_name.y = -8
			// res_mgr_.SetImageSprite(this, this._img_name, "common", `ts_title_bg${basic.color}`)

			let config_seal_equip = res_mgr_.GetGameConfigFromCache(this, "config_seal_equip", false)
			let holy_seal_data = holy_seal_model_.GetHolySealData(basic.type_id, config_seal_equip)
			let goods_vo = goods_vo_

			let is_preview = true
			let is_wear_equip = false

			if (goods_vo.goods_id) {
				is_preview = false
			}

			if (is_preview) {
				let attr_list = []
				let base_attr = local_JSON.parse(holy_seal_data.base_attr)
				for (let _ in base_attr) {
					var vo = base_attr[_]
					attr_list.push(vo)
				}
				let extra_attr = local_JSON.parse(holy_seal_data.extra_attr)
				for (let _ in extra_attr) {
					var vo = extra_attr[_]
					attr_list.push(vo)
				}
				this._lb_rating.innerHTML = `装备评分：${Util.HtmlColorTxt(Util.CalAttrPower(attr_list, false), "'#ffe222'")}`
			} else {
				is_wear_equip = holy_seal_model_.GetWearEquipInfo(goods_vo.goods_id) && true || false

				let desc1
				if (is_wear_equip) {
					desc1 = `综合评分：${Util.HtmlColorTxt(goods_vo.overall_rating, "'#ffe222'")}`
				} else {
					desc1 = `装备评分：${Util.HtmlColorTxt(goods_vo.rating, "'#ffe222'")}`
				}
				this._lb_rating.innerHTML = desc1
			}

			let base_attr = holy_seal_data && holy_seal_data.base_attr
			if (base_attr) {
				base_attr = local_JSON.parse(base_attr)
				let stren_attr
				if (!is_preview && is_wear_equip) {
					let stren_lv = holy_seal_model_.GetHolySealStrenDate(basic.subtype)
					let seal_strong_cfgs = ResManager.GetInstance().GetGameConfigFromCache(this, "config_seal_strong", false)
					let cfg = holy_seal_model_.GetHolySealStrenCfg(basic.subtype, stren_lv, seal_strong_cfgs)
					if (cfg) {
						stren_attr = local_JSON.parse(cfg.add_attr)
					}
				}
				this._lb_base_attr.innerHTML = this.GetBaseAndStrenProStr(base_attr, stren_attr)
				this._gp_base_attr.height = 30 + 10 + base_attr.length * 24
			}
			this._lb_career.innerHTML = `职业：${Util.HtmlColorTxt("通用", "'#d15e00'")}`
			this._lb_career.style.width = 150
			let GoodsSubtype = res_mgr_.GetGameConfigFromCache(this, "GoodsSubtype", false)
			this._lb_pos.innerHTML = `部位：${Util.HtmlColorTxt(holy_seal_model_.GetEquipTypeName(basic.subtype, GoodsSubtype), "'#d15e00'")}`
			this._lb_pos.style.width = 150
			this._lb_level.innerHTML = `穿戴等级：${Util.HtmlColorTxt(1, "'#ffe222'")}`
			this._lb_level.style.width = 250

			// let extra_attr = holy_seal_data && holy_seal_data.extra_attr
			// if (extra_attr) {
			// 	extra_attr = local_JSON.parse(extra_attr)
			// 	let str = ""
			// 	if (extra_attr) {

			// 		for (let idx = 0; idx < extra_attr.length; idx++) {
			// 			var val = extra_attr[idx]
			// 			if (idx + 1 != extra_attr.length) {
			// 				str = str + WordManager.GetProperties(val[0]) + (" + ") + WordManager.ConvertToPercentValue(val[0], val[1]) + "\n"
			// 			} else {
			// 				str = str + WordManager.GetProperties(val[0]) + (" + ") + WordManager.ConvertToPercentValue(val[0], val[1])
			// 			}
			// 		}
			// 	}
			// 	if (str == "") {
			// 		str = "无"
			// 	}
			// 	this._lb_extra_attr.text = str
			// }

			have_suit = false
			base_suit_id_ = holy_seal_data.suit
			let config_seal_kv = ResManager.GetInstance().GetGameConfigFromCache(this, "config_seal_kv", false)
			if (holy_seal_model_.GetkeyValue(3, config_seal_kv) > RoleManager.GetInstance().GetMainRoleLevel()) {
				this.UpdateSuitData({
					suit: [
						{ suit_id: base_suit_id_, num: 1 }
					]
				})
			} else {
				holy_seal_model_.Fire(HolySealModel.REQUEST_CCMD_EVENT, 65408, basic.type_id)
				cache_resize = true
			}

			this.RefreshBtnState()
			if (!cache_resize) {
				this.UpdateSize()
			} else {
				this.display_obj.height = this._gp_btns.height + this._gp_btns.y + 16
			}

			if (basic.color > 5) {
				this._img_decompose_icon.visible = false
				// if (basic.subtype == 11 ) {
				// 	this._lb_decompose_value.text = "神器不可拆解"
				// }else{
				this._lb_decompose_value.text = "请先拆解影装"
				// }
			} else {
				this.SetDecomposeCost()
			}
		}

		this.UpdateSize = () => {
			this._Scroller1.height = have_suit ? 370 : 180
			this._Group3.y = have_suit ? 566 : (566 - 190)
			this._Label4.y = have_suit ? 620 : (620 - 190)
			this._Group4.y = have_suit ? 614 : (614 - 190)
			this._gp_btns.y = have_suit ? 667 : (667 - 190)
			this.red0.y = have_suit ? 665 : (665 - 190)
			this.display_obj.height = this._gp_btns.height + this._gp_btns.y + 16
		}

		this.SetDecomposeCost = () => {
			let config_goods_decompose = ResManager.GetInstance().GetGameConfigFromCache(this, "config_goods_decompose", false)
			let cfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_goods_decompose.name, type_id_, false, config_goods_decompose)
			if (cfg) {
				let reward = local_JSON.parse(cfg.regular_mat)
				let vo = reward && reward[0]
				let count = 0
				if (vo) {
					let type_id, lock = goods_model_.GetMappingTypeId(vo[0], vo[1])
					count = vo[2]
				}
				this._lb_decompose_value.text = String(count)
				this._img_decompose_icon.visible = true
			}
		}

		this.GetBaseAndStrenProStr = (base_attrlist?, stren_list?) => {
			let str = ""
			let stren_str = null
			let pro = null
			if (base_attrlist) {
				for (let idx = 0; idx < base_attrlist.length; idx++) {
					var val = base_attrlist[idx]
					stren_str = ""
					if (stren_list) {
						let i = 0
						if (i < stren_list.length) {
							do {
								pro = stren_list[i]
								if (pro && Number(pro[0]) == Number(val[0]) && Number(pro[1]) > 0) {
									stren_str = Util.HtmlColorTxt("(强化+" + pro[1] + ")", "'#639c12'")
									break
								}
								i = i + 1
							} while ((i < stren_list.length))
						}
					}
					if (idx != base_attrlist.length - 1) {
						str = str + WordManager.GetProperties(val[0]) + ":&nbsp;" + Util.HtmlColorTxt(WordManager.ConvertToPercentValue(val[0], val[1]), "'#d15e00'") + "<br/>"
					} else {
						str = str + WordManager.GetProperties(val[0]) + ":&nbsp;" + Util.HtmlColorTxt(val[1], "'#d15e00'")
					}
				}
			}
			return str
		}

		this.RefreshBtnState = () => {
			let index = 0
			for (let i = 0; i < btn_list_.length; i++) {
				var obj = btn_list_[i]
				let show = show_btn_list_.indexOf(i) != -1
				if (show && i == HolySealToolTips.Btn.dismantle) {
					//真实物品且品质为分装才可拆解
					if (!goods_vo_.goods_id || goods_vo_.color < 6) {
						show = false
					}
				}
				obj.visible = show
				if (show) {
					index++
					if (show_btn_list_.length == 1) {
						obj.centerX = 0
						obj.y = 0
					}
					else {
						obj.centerX = NaN
						obj.x = index % 2 == 1 ? 0 : 204
						obj.y = Math.floor((index - 1) / 2) * 75
					}
				}
			}

			// 绑定粉装要调换按钮位置
			if (goods_vo_.bind == 1 && goods_vo_.color >= 6) {
				btn_list_[1].x = 204
				btn_list_[2].x = 0
			}

			this._gp_btns.height = Math.round(index / 2) * 75

		}

		this.UpdateSuitData = (data?) => {
			let my_count = null
			let list = data.suit

			for (let _ in list) {
				var vo = list[_]
				if (vo.suit_id == base_suit_id_) {
					my_count = vo.num
				}
			}

			if (!my_count || my_count == 0) {
				my_count = 1
			}

			let seal_suit_cfg = res_mgr_.GetGameConfigFromCache(this, "config_seal_suit", false)
			let suit_cfg = holy_seal_model_.GetHolySealSuitCfg(base_suit_id_, seal_suit_cfg)
			if (suit_cfg) {
				have_suit = true
				this._gp_suit_attr_con.visible = true
				this._lb_suit_none.visible = false
				let max_count = 0
				let suit_attr = local_JSON.parse(suit_cfg.attr)
				let desc = ""
				if (!suit_item_list_) {
					suit_item_list_ = []
				}
				let suit_attr_height = 0, height
				for (let key in suit_attr) {
					let item: HolySealToolSuitAttrItem = suit_item_list_[key]
					if (!item) {
						item = new HolySealToolSuitAttrItem(this._gp_suit_attr_con)
						suit_item_list_[key] = item
						item.Load()
					}
					let vo = suit_attr[key]
					let count = vo[0]
					item.SetData(vo, my_count)
					height = item.GetHeight()
					item.SetPosition(0, suit_attr_height)
					suit_attr_height += height
					max_count = count
				}
				desc = suit_cfg.name.trim() + "(" + my_count + "/" + max_count + ")"
				//if (base_suit_id_ != suit_id ) {
				//desc = desc + " 【兼容】"
				//}
				this._lb_suit_name.text = desc

				this._gp_suit.height = 30 + suit_attr_height
			} else {
				this._gp_suit_attr_con.visible = false
				this._lb_suit_none.visible = true
				this._lb_suit_name.text = "套装属性"
				this._gp_suit.height = 50 //30 + 20
			}
			if (cache_resize) {
				cache_resize = false
				this.UpdateSize()
			}
		}
	}
	_img_bg: Laya.Image
	_gp_icon: Laya.Box
	_img_name: Laya.Image
	_lb_name: Laya.Label
	_lb_rating: Laya.HTMLDivElement
	_lb_level: Laya.HTMLDivElement
	_Scroller1: Laya.Panel
	_Group2: Laya.VBox
	_gp_base_attr: Laya.Box
	_Image2: Laya.Image
	_Label1: Laya.Label
	_lb_base_attr: Laya.HTMLDivElement
	_gp_suit: Laya.Box
	_Image5: Laya.Image
	_lb_suit_name: Laya.Label
	_gp_suit_attr_con: Laya.Box
	_lb_suit_none: Laya.Label
	_Group3: Laya.Box
	_Image6: Laya.Image
	_lb_career: Laya.HTMLDivElement
	_lb_pos: Laya.HTMLDivElement
	_Label4: Laya.Label
	_Group4: Laya.HBox
	_lb_decompose_value: Laya.Label
	_img_decompose_icon: Laya.Image
	_gp_btns: Laya.Box
	_btn_upShelf: Laya.Box
	_img1: Laya.Image
	labelDisplay111: Laya.Label
	_btn_replace: Laya.Box
	_img2: Laya.Image
	labelDisplay1: Laya.Label
	_btn_dismantle: Laya.Box
	_img3: Laya.Image
	labelDisplay: Laya.Label
	_btn_close: Laya.Box
	_img4: Laya.Image
	labelDisplay1111: Laya.Label
	_btn_outShelf: Laya.Box
	_img5: Laya.Image
	labelDisplay11: Laya.Label
	_btn_upStage: Laya.Box
	_img6: Laya.Image
	Text: Laya.Label
	_btn_upColor: Laya.Box
	_img7: Laya.Image
	labelDisplay11111: Laya.Label
	_btn_outEquip: Laya.Box
	_img8: Laya.Image
	labelDisplay111111: Laya.Label
	red0: Laya.Image
	red1: Laya.Image
	public GetComponents() {
		[
			this._img_bg,
			this._gp_icon,
			this._img_name,
			this._lb_name,
			this._lb_rating,
			this._lb_level,
			this._Scroller1,
			this._Group2,
			this._gp_base_attr,
			this._Image2,
			this._Label1,
			this._lb_base_attr,
			this._gp_suit,
			this._Image5,
			this._lb_suit_name,
			this._gp_suit_attr_con,
			this._lb_suit_none,
			this._Group3,
			this._Image6,
			this._lb_career,
			this._lb_pos,
			this._Label4,
			this._Group4,
			this._lb_decompose_value,
			this._img_decompose_icon,
			this._gp_btns,
			this._btn_upShelf,
			this._img1,
			this.labelDisplay111,
			this._btn_replace,
			this._img2,
			this.labelDisplay1,
			this._btn_dismantle,
			this._img3,
			this.labelDisplay,
			this._btn_close,
			this._img4,
			this.labelDisplay1111,
			this._btn_outShelf,
			this._img5,
			this.labelDisplay11,
			this._btn_upStage,
			this._img6,
			this.Text,
			this._btn_upColor,
			this._img7,
			this.labelDisplay11111,
			this._btn_outEquip,
			this._img8,
			this.labelDisplay111111,
			this.red0,
			this.red1,
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_gp_icon",
				"_img_name",
				"_lb_name",
				"_lb_rating",
				"_lb_level",
				"_Scroller1",
				"_Group2",
				"_gp_base_attr",
				"_Image2",
				"_Label1",
				"_lb_base_attr",
				"_gp_suit",
				"_Image5",
				"_lb_suit_name",
				"_gp_suit_attr_con",
				"_lb_suit_none",
				"_Group3",
				"_Image6",
				"_lb_career",
				"_lb_pos",
				"_Label4",
				"_Group4",
				"_lb_decompose_value",
				"_img_decompose_icon",
				"_gp_btns",
				"_btn_upShelf",
				"_img1",
				"labelDisplay111",
				"_btn_replace",
				"_img2",
				"labelDisplay1",
				"_btn_dismantle",
				"_img3",
				"labelDisplay",
				"_btn_close",
				"_img4",
				"labelDisplay1111",
				"_btn_outShelf",
				"_img5",
				"labelDisplay11",
				"_btn_upStage",
				"_img6",
				"Text",
				"_btn_upColor",
				"_img7",
				"labelDisplay11111",
				"_btn_outEquip",
				"_img8",
				"labelDisplay111111",
				"red0",
				"red1",
			])
	}
}
window["HolySealToolTips"] = HolySealToolTips