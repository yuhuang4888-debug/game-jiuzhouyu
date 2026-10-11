
import { Util, Trim, IsInTable, HtmlColorTxt, SetSizeDeltaY, GetSizeDeltaY, RefGridLayout } from "../util/Util"
import { TimeUtil } from "../util/TimeUtil"
import { ColorUtil } from "../util/ColorUtil"

import { GameResPath } from "../util/GameResPath"
import { Message } from "../sysInfo/SysInfoController"
import { Config } from "../common/Config"
import { GoodsModel } from "../commonModel/GoodsModel"
import { MarketModel } from "../commonModel/MarketModel"
import { CompositeModel } from "../commonModel/CompositeModel"
import { MarketEvent } from "../commonModel/MarketModel"
import { longlangModel } from "../commonModel/longlangModel"
import { BaseView1 } from "../common/BaseView1"
import { EquipmentItem } from "../common/EquipmentItem"
import { HolySealToolSuitAttrItem } from "../common/HolySealToolSuitAttrItem"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { WordManager } from "../common/WordManager"


export class PlayerMessageLonglanguageTips extends BaseView1 {
	public static Btn = { upShelf: 0, replace: 1, dismantle: 2, close: 3, outShelf: 4, upStage: 5, upColor: 6, outEquip: 7 }
	GetBaseAndStrenProStr
	InitEvent
	InitView
	LoadSuccess
	RefreshBtnState
	Remove
	SetData
	SetDecomposeCost
	UpdateSuitData

	base_suit_id
	goods_icon
	goods_vo
	image
	model
	suit_item_list
	type_id
	cfg_draconic_equip
	cfg_draconic_strong
	cfg_draconic_pos
	cfg_draconic_suit
    suit_list
	public constructor() {
		super()
		this.base_file = "common"
		this.layout_file = "LonglangToolTips"
		this.layer_value = Enum_UILayer.Activity
		this.destroy_imm = true
		this.use_background = true
		this.click_bg_toClose = true
		this.is_center = true
		this.show_open_movie = true
		this.preload_server_config = {
			"config_draconic_equip": false,
			"config_draconic_strong": false,
			"config_draconic_pos": false,
			"config_draconic_suit": false
		}

		let local_TimeUtil = TimeUtil
		let local_longlangModel = longlangModel
		let market_model = MarketModel.GetInstance()
		let local_MarketEvent = MarketEvent
		let local_Message = Message
		let goods_model = GoodsModel.GetInstance()
		let local_WordManager = WordManager
		this.model = longlangModel.GetInstance()
		// let _role_id = 0
		// let _pos_x = 0
		// let _pos_y = 0
		// let _btn_list = null
		let _show_btn_list = null
		this.type_id = 0
		this.goods_vo = null
        this.suit_list = null
		this.load_callback = () => {
			this.cfg_draconic_equip = ResManager.GetInstance().GetGameConfigFromCache(this, "config_draconic_equip", false)
			this.cfg_draconic_strong = ResManager.GetInstance().GetGameConfigFromCache(this, "config_draconic_strong", false)
			this.cfg_draconic_pos = ResManager.GetInstance().GetGameConfigFromCache(this, "config_draconic_pos", false)
			this.cfg_draconic_suit = ResManager.GetInstance().GetGameConfigFromCache(this, "config_draconic_suit", false)
			this.LoadSuccess()
		}

		this.open_callback = () => {
			this.InitView()
		}

		this.close_callback = () => { }
		this.destroy_callback = () => {
			this.Remove()
		}

		this.Remove = () => {
			if (this.goods_icon) {
				this.goods_icon.DeleteMe()
				this.goods_icon = null
			}
			if (this.suit_item_list) {
				for (let _tmpi in this.suit_item_list) {
					let obj = this.suit_item_list[_tmpi]
					obj.DeleteMe()
				}
				this.suit_item_list = null
			}
		}

		this.LoadSuccess = () => {
			// ResManager.GetInstance().SetOutsideImageSprite(this, this._Image6, GameResPath.GetIcon("common2", "uity_016c"), true)
			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_decompose_icon, GameResPath.GetGoodsIconPath(String(local_longlangModel.MONEY_TYPE)))
			this._Scroller1.vScrollBarSkin = ""
			this._lb_rating.style.fontSize = 20
			this._lb_rating.style.color = "#783528"
			this._lb_rating.style.width = 200
			this._lb_level.style.fontSize = 20
			this._lb_level.style.color = "#783528"
			this._lb_level.style.width = 200

			this._lb_career.style.fontSize = 20
			this._lb_career.style.color = "#93847D"
			this._lb_career.style.wordWrap = false
			this._lb_pos.style.fontSize = 20
			this._lb_pos.style.color = "#93847D"
			this._lb_pos.style.wordWrap = false

			this._lb_base_attr.style.fontSize = 20
			this._lb_base_attr.style.color = "#93847D"
			this._lb_base_attr.style.width = 340
			this._lb_base_attr.style.leading = 4
			this._lb_extra_attr.style.fontSize = 20
			this._lb_extra_attr.style.color = "#93847D"
			this._lb_extra_attr.style.width = 340
			this._lb_extra_attr.style.leading = 4
			this._lb_longlang.style.fontSize = 20
			this._lb_longlang.style.color = "#93847D"
			this._lb_longlang.style.width = 340
			this._lb_longlang.style.leading = 4
			this.InitEvent()
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this._btn_close, () => {
				this.Close()
			}, this, true)

			let next_time = null
			Util.AddClickEvent(this._btn_replace, () => {
				if (!this.goods_vo) {
					return
				}
				if (!next_time || next_time < local_TimeUtil.getServerTime()) {
					next_time = local_TimeUtil.getServerTime() + 1
					this.model.Fire(local_longlangModel.SEND_PROTO, 62203, "cl", this.goods_vo.subtype, this.goods_vo.goods_id)
					this.Close()
				}
			}
				, this, true)
			Util.AddClickEvent(this._btn_dismantle, () => {
				if (this.goods_vo) {
					this.model.Fire(local_longlangModel.OPEN_VIEW, "longlangSBaseView", 1, this.goods_vo)
				}
				this.show_open_movie = false
				this.Close()
			}
				, this, true)
			Util.AddClickEvent(this._btn_upShelf, () => {
				if (!goods_model.GetGoodsVoByGoodsId(this.goods_vo.goods_id)) {
					Message.show("物品不存在")
					market_model.Fire(MarketEvent.NEED_UPDATE_BAG)
				} else {
					market_model.Fire(local_MarketEvent.OPEN_VIEW, "MarketSellCtrlView", this.goods_vo)
				}
				this.show_open_movie = false
				this.Close()
			}
				, this, true)
			Util.AddClickEvent(this._btn_outShelf, () => {
				if (!this.goods_vo) {
					return
				}
				let goods_vo = this.goods_vo
				market_model.Fire(local_MarketEvent.REQUEST_PROTO, 15108, "clii", 1, goods_vo.id, goods_vo.type_id, goods_vo.goods_num)
				this.Close()
			}
				, this, true)
			Util.AddClickEvent(this._btn_upStage, () => {
				if (this.goods_vo) {
					if (this.goods_vo.color > 5) {
						local_Message.show("当前装备需要先拆解为红装后方可升阶")
						return
					}
					// [ts2lua]this.model.UpStageCfg下标访问可能不正确
					if (!this.model.UpStageCfg[String(this.goods_vo.type_id)]) {
						local_Message.show("当前装备不可升阶")
						return
					}
					this.model.Fire(local_longlangModel.OPEN_VIEW, "longQuickFuncView", this.goods_vo, local_longlangModel.upStage)
					this.Close()
				}
			}
				, this, true)
			Util.AddClickEvent(this._btn_upColor, () => {
				if (!this.goods_vo) {
					return
				}
				if (!this.model.UpColorCfg[String(this.goods_vo.type_id)]) {
					local_Message.show("当前装备不可晋升")
					return
				}
				this.model.Fire(local_longlangModel.OPEN_VIEW, "longQuickFuncView", this.goods_vo, local_longlangModel.upColor)
				this.Close()
			}
				, this, true)
			Util.AddClickEvent(this._btn_outEquip, () => {
				if (!this.goods_vo) {
					return
				}
				this.model.Fire(local_longlangModel.SEND_PROTO, 62204, "cl", this.goods_vo.subtype, this.goods_vo.goods_id)
				this.Close()
			}
				, this, true)
			// this.BindEvent(this.model, local_longlangModel.PREVIEW_SUIT, (data?) => {
			// 	this.UpdateSuitData(data)
			// }
			// )
		}

		this.SetData = (type_id?, goods_vo?, role_id?, show_btn_list?,suit_list?) => {
			this.type_id = type_id
			// _role_id = role_id
			_show_btn_list = show_btn_list && show_btn_list || [0]
            this.suit_list = suit_list
			//let main_role_id = RoleManager.GetInstance().GetMainRoleId()
			this.goods_vo = goods_vo || goods_model.GetGoodsBasicByTypeId(type_id)
		}

		this.InitView = () => {
			if (!this.goods_vo) {
				return
			}
			let basic = goods_model.GetGoodsBasicByTypeId(this.type_id)
			if (basic == null) {
				return
			}
			if (!this.goods_icon) {
				this.goods_icon = new EquipmentItem(this._gp_icon)
				this.goods_icon.Load()
				this.goods_icon.SetItemSize(85, 85)
				this.goods_icon.ChangeCountVisible(false)
			}
			this.goods_icon.SetData(basic.type_id, 1)
			this.goods_icon.SetShowTips(false)
			// this._lb_name.color = ColorUtil.GetColorDark(basic.color, false)
			this._lb_name.text = Trim(basic.goods_name)
			ResManager.GetInstance().SetImageSprite(this, this._img_name, "common", `ts_title_bg${basic.color}`)

			let longlangData = this.cfg_draconic_equip[basic.type_id]
			if (!longlangData) {
				return
			}
			let goods_vo = this.goods_vo
			let is_preview = true
			let is_wear_equip = false
			if (goods_vo.goods_id) {
				is_preview = false
			}
            this._lb_rating.innerHTML = Util.StrToHTML("综合评分：<font color='#4a3a32'>" + goods_vo.rating + "</font>")
			// if (is_preview) {
			// 	let attr_list = []
			// 	let base_attr = JSON.parse(longlangData.base_attr)
			// 	for (let _tmpi in base_attr) {
			// 		let vo = base_attr[_tmpi]
			// 		table.insert(attr_list, vo)
			// 	}
			// 	let extra_attr = JSON.parse(longlangData.extra_attr)
			// 	for (let _tmpi in extra_attr) {
			// 		let vo = extra_attr[_tmpi]
			// 		table.insert(attr_list, vo)
			// 	}
			// 	this._lb_rating.innerHTML = Util.StrToHTML("装备评分：<font color='#4a3a32'>" + Util.CalAttrPower(attr_list, false) + "</font>")
			// } else {
			// 	is_wear_equip = (goods_model.longlang_equip_dic[goods_vo.goods_id] && (true) || (false))
			// 	this._lb_rating.innerHTML = Util.StrToHTML(is_wear_equip && Util.StrToHTML("综合评分：<font color='#4a3a32'>" + goods_vo.overall_rating + "</font>") || Util.StrToHTML("装备评分：<font color='#4a3a32'>" + goods_vo.rating + "</font>"))
			// }

			let base_attr = longlangData.base_attr
			if (base_attr) {
				base_attr = JSON.parse(base_attr)
				let stren_attr
				// if (!is_preview && is_wear_equip) {
					// let stren_lv = this.model.GetStrData(basic.subtype)
					let cfg = this.cfg_draconic_strong[basic.subtype + "@" + goods_vo.strong]
					if (cfg) {
						stren_attr = JSON.parse(cfg.add_attr)
					}
				// }
				this._lb_base_attr.innerHTML = Util.StrToHTML(this.GetBaseAndStrenProStr(base_attr, stren_attr))
				this._gp_base_attr.height = 30 + 8 + base_attr.length * 24
			}

			this._lb_career.innerHTML = Util.StrToHTML("职业：<font color='#4a3a32'>通用</font>")
			this._lb_pos.innerHTML = Util.StrToHTML("部位：<font color='#4a3a32'>" + this.model.GetEquipTypeName(basic.subtype, this.cfg_draconic_pos) + "</font>")
			this._lb_level.innerHTML = Util.StrToHTML("穿戴等级：<font color='#4a3a32'>1</font>")

			let extra_attr = longlangData.extra_attr
			if (extra_attr) {
				extra_attr = JSON.parse(extra_attr)
				let num_ex = 0
				let num_long = 0
				let exstr = ""
				let longstr = ""
				if (extra_attr) {
					let i = 0
					if (i < extra_attr.length) {
						do {
							let val = extra_attr[i]
							if (Number(val[0]) >= 50 && Number(val[0]) <= 52) {
								num_long = num_long + 1
								longstr = longstr + local_WordManager.GetProperties(val[0]) + (" + ") + local_WordManager.ConvertToPercentValue(val[0], val[1]) + "<br>"
							} else {
								num_ex = num_ex + 1
								exstr = exstr + local_WordManager.GetProperties(val[0]) + (" + ") + local_WordManager.ConvertToPercentValue(val[0], val[1]) + "<br>"
							}
							i = i + 1
						} while ((i < extra_attr.length))
					}
				}
				if (exstr == "") {
					exstr = "无"
					num_ex = 1
				} else {
					//exstr = String.gsub(exstr, '\n$', "")
				}
				if (longstr == "") {
					longstr = "无"
					num_long = 1
				} else {
					//longstr = string.gsub(longstr, '\n$', "")
				}
				this._gp_extra_attr.visible = true
				this._gp_longlang.visible = true
				this._lb_extra_attr.innerHTML = Util.StrToHTML(exstr)
				this._gp_extra_attr.height = 30 + 8 + num_ex * 24
				let color = ColorUtil.TryParseHtmlString(ColorUtil.GetColorDark(basic.color))
				this._lb_extra_attr.style.color = color
				this._lb_longlang.style.color = color
				this._lb_longlang.innerHTML = Util.StrToHTML(longstr)
				this._gp_longlang.height = 30 + 8 + num_long * 24
			}
			this._lb_suit_value.text = "无"
			this.base_suit_id = longlangData.suit
			this.model.Fire(local_longlangModel.SEND_PROTO, 62208, "i", basic.type_id)
			//if (this._btn_upShelf ) {
			this.RefreshBtnState()
			//}
			//SetSizeDeltaY(this._gp_extra_attr,this._lb_extra_attr.anchoredPosition.y+GetSizeDeltaY(this._lb_extra_attr) + 12)
			//SetSizeDeltaY(this._gp_longlang,this._lb_longlang.anchoredPosition.y+GetSizeDeltaY(this._lb_longlang) + 12)
			SetSizeDeltaY(this.display_obj, this._gp_btns.y + GetSizeDeltaY(this._gp_btns) + 16)

			if (basic.color >= 6 || basic.subtype > 6 && (basic.color == 5 || basic.color == 4 && longlangData.stage > 3)) {
				this._img_decompose_icon.visible = false
				this._lb_decompose_value.text = "请先拆解神祭"
			} else {
				this.SetDecomposeCost()
			}
			let comModel = CompositeModel.GetInstance()
			let red0 = this._btn_upStage.visible && comModel.CanCompose(this.model.UpStageCfg[this.type_id])
			this.red0.visible = red0
			let red1 = this._btn_upColor.visible && comModel.CanCompose(this.model.UpColorCfg[this.type_id])
			this.red1.visible = red1
            this.UpdateSuitData()
		}

		this.SetDecomposeCost = () => {
			let cfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_goods_decompose.name, this.type_id, false)
			if (cfg) {
				let reward = JSON.parse(cfg.regular_mat)
				let vo = reward && reward[0]
				let count = 0
				if (vo) {
					// let type_id, lock = goods_model.GetMappingTypeId(vo[0], vo[1])
					count = vo[2]
				}
				this._lb_decompose_value.text = String(count)
				this._img_decompose_icon.visible = true
			} else {
				this._lb_decompose_value.text = "0"
			}
		}

		this.GetBaseAndStrenProStr = (base_attrlist?, stren_list?) => {
			let str = ""
			let stren_str = null
			let pro = null
			if (base_attrlist) {
				for (let idx = 0; idx < base_attrlist.length; idx++) {
					let val = base_attrlist[idx]
					stren_str = ""
					if (stren_list) {
						let i = 0
						do {
							pro = stren_list[i]
							if ((pro && Number(pro[0]) == Number(val[0])) && Number(pro[1]) > 0) {
								stren_str = "&nbsp;&nbsp;<font color='#0a953e'>(强化+" + pro[1] + ")</font>"
								break
							}
							i = i + 1
						} while ((i < stren_list.length))
					}
					if (idx != base_attrlist.length) {
						str = str + local_WordManager.GetProperties(val[0]) + ":<font color='#4a3a32'>" + local_WordManager.ConvertToPercentValue(val[0], val[1]) + "</font>" + stren_str + "<br>"
					} else {
						str = str + local_WordManager.GetProperties(val[0]) + ":<font color='#4a3a32'>" + val[1] + "</font>" + stren_str
					}
				}
			}
			return str
		}

		this.RefreshBtnState = () => {
			let btn = null
			let i = 0
			do {
				let show = IsInTable(i, _show_btn_list)
				if (show) {
					if (i == 2) {
						// let con = false
						let color = this.goods_vo.color
						if (((!this.goods_vo.goods_id || color < 4) || color == 4 && (this.goods_vo.subtype < 7 || this.goods_vo.stage == 3)) || color == 5 && this.goods_vo.subtype < 7) {
							break
						}
					} else if (i == 5) {
					} else if (i == 6) {
						if (!this.goods_vo.goods_id || this.goods_vo.subtype < 7) {
							break
						}
					}
				}
				btn = this._gp_btns.getChildAt(i)
				if (btn) {
					btn.visible = show
				}
				i = i + 1
			} while ((i < this._gp_btns.numChildren))
			RefGridLayout(this._gp_btns, {
				column: 2,
				h_gap: 6,
				v_gap: 0,
				item_w: 141,
				item_h: 52,
				frist_item_space: 25
			})
		}

		this.UpdateSuitData = () => {
            let my_count = null
            let suit_id = this.cfg_draconic_equip[this.type_id].suit
            for(let key in this.suit_list){
                if(this.suit_list[key].suit_id == suit_id){
                    my_count = this.suit_list[key].num
                }
            }
			if (!suit_id || !my_count) {
				suit_id = this.base_suit_id
				my_count = 1
			}
			let longlang_suit_cfg = this.cfg_draconic_suit
			let suit_cfg = longlang_suit_cfg[suit_id]
			if (suit_cfg) {
				this._gp_suit_attr_con.visible = true
				this._lb_suit_value.visible = false
				let max_count = 0
				let suit_attr = JSON.parse(suit_cfg.attr)
				let desc = ""
				if (!this.suit_item_list) {
					this.suit_item_list = []
				}
				let suit_attr_height = 0, height
				for (let key in suit_attr) {
					let item = this.suit_item_list[key]
					if (!item) {
						item = new HolySealToolSuitAttrItem(this._gp_suit_attr_con)
						this.suit_item_list[key] = item
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
				this._lb_suit_value.text = Util.StrToHTML(desc)
				desc = suit_cfg.name + "  (" + my_count + "/" + max_count + ")"
				if (this.base_suit_id != suit_id) {
					desc = desc + " 【兼容】"
				}
				this._lb_suit_name.text = desc
				this._gp_suit.height = 30 + suit_attr_height
			} else {
				this._gp_suit_attr_con.visible = false
				this._lb_suit_value.visible = true
				this._lb_suit_name.text = "套装属性"
				// let desc = HtmlColorTxt("无", ColorUtil.GetColorDark(ColorType.RED))
				this._lb_suit_value.text = "无" //Util.StrToHTML(desc)
				this._gp_suit.height = 50
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
	_Image7: Laya.Image
	_lb_suit_name: Laya.Label
	_gp_suit_attr_con: Laya.Box
	_lb_suit_value: Laya.Label
	_gp_extra_attr: Laya.Box
	_Image4: Laya.Image
	_Label2: Laya.Label
	_lb_extra_attr: Laya.HTMLDivElement
	_gp_longlang: Laya.Box
	_Image5: Laya.Image
	_Label3: Laya.Label
	_lb_longlang: Laya.HTMLDivElement
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
	_img_line: Laya.Image
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
			this._Image7,
			this._lb_suit_name,
			this._gp_suit_attr_con,
			this._lb_suit_value,
			this._gp_extra_attr,
			this._Image4,
			this._Label2,
			this._lb_extra_attr,
			this._gp_longlang,
			this._Image5,
			this._Label3,
			this._lb_longlang,
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
			this._img_line,
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
				"_Image7",
				"_lb_suit_name",
				"_gp_suit_attr_con",
				"_lb_suit_value",
				"_gp_extra_attr",
				"_Image4",
				"_Label2",
				"_lb_extra_attr",
				"_gp_longlang",
				"_Image5",
				"_Label3",
				"_lb_longlang",
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
				"_img_line",
			])
	}
}
window["PlayerMessageLonglanguageTips"] = PlayerMessageLonglanguageTips