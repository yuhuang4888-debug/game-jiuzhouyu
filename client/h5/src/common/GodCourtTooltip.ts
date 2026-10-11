import { BaseView1 } from "./BaseView1"
import { Config } from "./Config"
import { Util, Trim, SetSizeDeltaY, GetLocalPositionY, SetAnchoredPositionY, RefGridLayout, RefBoxVLayout } from "../util/Util"
import { Enum_UILayer } from "./LayerManager"
import { TimeUtil } from "../util/TimeUtil"
import { WordManager } from "./WordManager"
import { ColorUtil, Enum_ColorUtil_Dark } from "../util/ColorUtil"
import { ResManager } from "./ResManager"
import { GameResPath } from "../util/GameResPath"
import { GoodsModel } from "../commonModel/GoodsModel"
import { GodCourtModel } from "../commonModel/GodCourtModel"
import { Alert, Alert_Type } from "../alert/Alert"
import { EquipmentItem } from "./EquipmentItem"

export class GodCourtTooltip extends BaseView1 {
	//GetBaseAndStrenProStr
	InitEvent
	InitView
	LoadSuccess
	RefreshBtnState
	Remove
	SetData
	UpdateAttrData

	goods_icon
	goods_vo
	height
	model
	scrollerhei
	showbtnCount
	type_id
	x
	x_cache
	y
	y_cache
	public static Btn = { close: 0, inEquip: 1, replace: 2, out: 3 }

	public constructor() {
		super()
		this.base_file = "common"
		this.layout_file = "GodCourtTooltip"
		this.layer_value = Enum_UILayer.Activity
		this.destroy_imm = true
		this.use_background = true
		this.click_bg_toClose = true
		this.is_center = true
		this.show_open_movie = true

		let local_TimeUtil = TimeUtil
		let local_GodCourtModel = GodCourtModel
		//let market_model = MarketModel.GetInstance()
		//let local_MarketEvent = MarketEvent
		//let local_Message = Message
		let goods_model = GoodsModel.GetInstance()
		//let local_Erlang = ErlangParser.GetInstance()
		let local_WordManager = WordManager
		let _godcourtId = 0
		//let _pos_x = 0
		//let _pos_y = 0
		//let _btn_list = null
		let _show_btn_list = null

		this.type_id = 0
		this.goods_vo = null
		this.model = local_GodCourtModel.GetInstance()

		this.load_callback = () => {
			this.LoadSuccess()
		}

		this.open_callback = () => {
			this.InitView()
		}

		this.close_callback = () => {
			this.model.Fire(GodCourtModel.CLOSE_COMPARED)
		}

		this.destroy_callback = () => {
			this.Remove()
		}

		this.Remove = () => {
			if (this.goods_icon) {
				this.goods_icon.DeleteMe()
				this.goods_icon = null
			}
			this.goods_vo = null
		}

		this.LoadSuccess = () => {
			ResManager.GetInstance().SetOutsideImageSprite(this, this.devourIcon, GameResPath.GetGoodsIconPath(this.model.devoureMatId))
			this.scroller.vScrollBarSkin = ""

			this._lb_rating.style.fontSize = 24
			this._lb_rating.style.color = "#ffffff"
			this._lb_rating.style.wordWrap = false

			this._lb_level.style.fontSize = 24
			this._lb_level.style.color = "#ffffff"
			this._lb_level.style.wordWrap = false

			this.baseName.style.fontSize = 20
			this.baseName.style.color = "#663915"
			this.baseName.style.wordWrap = false

			this._lb_base_attr.style.fontSize = 20
			this._lb_base_attr.style.color = "#663915"
			this._lb_base_attr.style.leading = 6
			this._lb_base_attr.width = 380


			this.rareLb.style.fontSize = 20
			this.rareLb.style.color = "#663915"
			this.rareLb.style.leading = 6
			this.rareLb.width = 380

			this.bestLb.style.fontSize = 20
			this.bestLb.style.color = "#663915"
			this.bestLb.style.leading = 6
			this.bestLb.width = 380

			this.disLb.style.fontSize = 20
			this.disLb.style.color = "#663915"
			this.disLb.style.leading = 6
			this.disLb.width = 380

			this._lb_career.style.fontSize = 20
			this._lb_career.style.color = "#663915"
			this._lb_career.style.wordWrap = false
			this._lb_career.style.bold = true

			this._lb_pos.style.fontSize = 20
			this._lb_pos.style.color = "#663915"
			this._lb_pos.style.wordWrap = false
			this._lb_pos.style.bold = true

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
					this.model.Fire(GodCourtModel.OPEN_VIEW, "GodCourtBagView", this.goods_vo.skill_id)
					this.Close()
				}
			}, this, true)

			Util.AddClickEvent(this._btn_inEquip, () => {
				if (!this.goods_vo) {
					return
				}
				let EquipFunc = () => {
					if (!next_time || next_time < local_TimeUtil.getServerTime()) {
						next_time = local_TimeUtil.getServerTime() + 1
						this.model.Fire(local_GodCourtModel.SEND_SCMD, 23303, "icl", _godcourtId, this.goods_vo.subtype, this.goods_vo.goods_id)
						this.Close()
					}
				}
				//let isLow = false
				if (this.model.showLowTips && this.goods_vo.color < 4) {
					let wearEquip = this.model.GetEquipPosGoodsVo(_godcourtId, this.goods_vo.subtype)
					if (wearEquip && wearEquip.color >= 4) {
						let wearCore = this.model.GetEquipPosGoodsVo(_godcourtId, 9)
						if (wearCore) {
							Alert.Show("替换后会导致因不满足穿神具装备条件\n而自动脱下" + GoodsModel.GetGoodsNameWithColorDark(wearCore.type_id) + "，是否继续？", Alert_Type.AlertTypeCheckBox, EquipFunc, null, null, null, null, null, (bool?) => {
								this.model.showLowTips = !bool
							}
							)
							return
						}
					}
				}
				EquipFunc()
			}, this, true)

			Util.AddClickEvent(this._btn_out, () => {
				if (this.goods_vo) {
					this.model.SelectComMat(this.goods_vo.goods_id, this.goods_vo.comIndex, false)
					this.Close()
				}
			}, this, true)
		}

		this.SetData = (type_id?, goods_vo?, godcourtId?, show_btn_list?, x?, y?, only_goods_id?) => {
			this.type_id = Number(type_id)
			_godcourtId = godcourtId
			_show_btn_list = show_btn_list && show_btn_list || [0]
			this.x_cache = x
			this.y_cache = y
			//if (x != null && y != null ) {
			//this.is_center = false
			//}else{
			//this.is_center = true
			//}
			if (goods_vo) {
				this.goods_vo = goods_vo
			}
		}

		this.InitView = () => {
			//let scHeight = 0
			let basic = goods_model.GetGoodsBasicByTypeId(this.type_id)
			if (basic == null) {
				return
			}
			if (!this.goods_icon) {
				this.goods_icon = new EquipmentItem(this._gp_icon)
				this.goods_icon.Load()
				this.goods_icon.SetItemSize(90, 90)
				this.goods_icon.ChangeCountVisible(false)
			}
			this.goods_icon.SetData(basic.type_id)
			//if (this.x_cache != null && this.y_cache != null ) {
			//this.x = this.x_cache
			//this.y = this.y_cache
			//}

			this._img_title.skin = GameResPath.GetIcon('common4', 'ui_tips_pz_' + basic.color)
			this.goods_icon.SetShowTips(false)

			this._lb_name.text = Trim(basic.goods_name)
			//let goods_vo = this.goods_vo
			//let is_preview = true
			//let is_wear_equip = false
			// if (goods_vo && goods_vo.goods_id) {
			// 	is_preview = false
			// }

			this._lb_career.innerHTML = Util.StrToHTML("职业：<font color='#d15e00'>通用</font>")
			this._lb_pos.innerHTML = Util.StrToHTML("类型：<font color='#d15e00'>" + (basic.subtype < 9 && "纹章" || "神具") + "</font>")
			this.UpdateAttrData()
			this.RefreshBtnState()

			let btn_height
			let devourNum = 0
			let devourCfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_goods_decompose.name, basic.type_id, false)
			if (devourCfg) {
				devourNum = JSON.parse(devourCfg.regular_mat)[0][2]
				this.devour1.visible = true
				this.devour0.visible = true
				this._gp_btns.y = 90
				btn_height = 170
				
			} else {
				this.devour1.visible = false
				this.devour0.visible = false
				btn_height = 145
				this._gp_btns.y = 55
				this.btnGroup.height = 145
			}
			this.devourLb.text = String(devourNum)

			if(this.showbtnCount == 0){
				btn_height -= 52
			}

			this.btnGroup.height = btn_height

			let height = 150 + this.scrollerhei + btn_height
			this._img_bg.height = height
			this.display_obj.height = height
		}

		// this.GetBaseAndStrenProStr = (base_attrlist?, stren_list?) => {
		// 	let str = ""
		// 	let stren_str = null
		// 	for (let i1 in base_attrlist) {
		// 		let v1 = base_attrlist[i1]
		// 		stren_str = ""
		// 		if (stren_list) {
		// 			for (let i2 in stren_list) {
		// 				let pro = stren_list[i2]
		// 				if ((pro && pro[1] == v1[1]) && pro[2] > 0) {
		// 					stren_str = " <font color='#639c12'>(强化+" + pro[2] + ")</font>"
		// 					break
		// 				}
		// 			}
		// 		}

		// 		if (i1 != base_attrlist.length) {
		// 			str = str + local_WordManager.GetProperties(v1[1]) + ":<font color='#4a3a32'>" + local_WordManager.ConvertToPercentValue(v1[1], v1[2]) + "</font>" + stren_str + " \n"
		// 		} else {
		// 			str = str + local_WordManager.GetProperties(v1[1]) + ":<font color='#4a3a32'>" + v1[2] + "</font>" + stren_str
		// 		}
		// 	}
		// 	return str
		// }

		this.RefreshBtnState = () => {
			let btn = null
			let i = 0
			this.showbtnCount = 0
			if (_show_btn_list && _show_btn_list.length > 0) {
				do {
					let show = Util.TableContains(_show_btn_list, i)
					btn = this._gp_btns.getChildAt(i)
					if (btn) {
						btn.visible = show
					}
					if (show) {
						this.showbtnCount = this.showbtnCount + 1
					}
					i = i + 1
				} while ((i < this._gp_btns.numChildren))
			}

			RefGridLayout(this._gp_btns, {
				column: 2,
				h_gap: 64,
				v_gap: 10,
				item_w: 141,
				item_h: 52
			})
		}

		this.UpdateAttrData = () => {
			let equipCfg = Config.PRELOAD_SERVER_CONFIG.config_god_court_equip
			let baseScore = 0
			if (equipCfg) {
				let curCfg = equipCfg[this.type_id]
				if (curCfg) {
					let baseAttr = JSON.parse(curCfg.base_attr)
					let baseStr = ""
					let nameStr = "基础属性"
					let baseNum = 0
					let AddNum = 0
					let isSelf = this.goods_vo && goods_model.GetGoodsVoByGoodsId(this.goods_vo.goods_id)
					if (isSelf) {
						let stage = isSelf && this.model.GetStage(this.goods_vo.skill_id, this.goods_vo.subtype)
						if (stage > 0) {
							let stageCfg = Config.PRELOAD_SERVER_CONFIG.config_god_court_equip_stage
							if (stageCfg && stageCfg[stage]) {
								let strenAttr = JSON.parse(stageCfg[stage].attr)
								if (strenAttr && strenAttr[0][0] == "331") {
									nameStr = nameStr + "(基础" + ("<font color='#a376ff'> +升阶</font>") + ")"
									AddNum = Number(strenAttr[0][1])
								}
							}
						}
					}
					for (let _tmpi in baseAttr) {
						let vo = baseAttr[_tmpi]
						let strenStr = ""
						if (AddNum > 0) {
							strenStr = " <font color='#a376ff'>+" + WordManager.ConvertToPercentValue(vo[0], Math.floor(Number(vo[1]) * AddNum / 10000)) + "</font>"
						}
						baseStr = baseStr + WordManager.GetProperties(vo[0]) + ":<font color='#d15e00'>" + WordManager.ConvertToPercentValue(vo[0], vo[1]) + "</font>" + strenStr + "<br>"
						baseNum = baseNum + 1
					}
					//baseStr = string.gsub(baseStr, "\n$", "")
					this._lb_base_attr.innerHTML = baseStr
					this._lb_base_attr.width = 380
					SetSizeDeltaY(this.baseGp, 46 + baseNum * 26)

					this.baseName.innerHTML = nameStr
					let rareAttr = JSON.parse(curCfg.rare_attr)
					let showRare = rareAttr.length > 0
					if (showRare) {
						let rareStr = ""
						for (let _tmpi in rareAttr) {
							let vo = rareAttr[_tmpi]
							rareStr = rareStr + local_WordManager.GetProperties(vo[0]) + (" + ") + local_WordManager.ConvertToPercentValue(vo[0], vo[1]) + "<br>"
						}
						//rareStr = string.gsub(rareStr, '\n$', "")
						this.rareLb.innerHTML = rareStr
						this.rareLb.width = 380

						let bx_height = this.rareLb.y + this.rareLb.contextHeight + 5
						SetSizeDeltaY(this.rareGp, bx_height)
					} else {
						SetSizeDeltaY(this.rareGp, 1)
					}
					this.rareGp.visible = showRare

					let bestAttr = JSON.parse(curCfg.brilliant_attr)
					let showBest = bestAttr.length > 0
					if (showBest) {
						let bestStr = ""
						for (let _tmpi in bestAttr) {
							let vo = bestAttr[_tmpi]
							bestStr = bestStr + WordManager.GetProperties(vo[0]) + (" + ") + WordManager.ConvertToPercentValue(vo[0], vo[1]) + "<br>"
						}
						//bestStr = string.gsub(bestStr, '\n$', "")
						this.bestLb.innerHTML = bestStr
						this.bestLb.width = 380
						let bx_height = this.bestLb.y + this.bestLb.contextHeight + 5
						SetSizeDeltaY(this.bestGp, bx_height)
					} else {
						SetSizeDeltaY(this.bestGp, 1)
					}
					this.bestGp.visible = showBest
					if (this.goods_vo) {
						baseScore = this.goods_vo.rating
					} else {
						baseScore = Util.CalAttrPower(baseAttr, false)
					}


				}
			}
			let goodsBasic = goods_model.GetGoodsBasicByTypeId(this.type_id)
			let show_use_ways = null
			if (goodsBasic) {
				let str = Trim(goodsBasic.intro)
				show_use_ways = str != ""
				if (show_use_ways) {
					this.disLb.innerHTML = str
					this.disLb.width = 380
				}

				let bx_height = this.disLb.y + this.disLb.contextHeight + 5
				SetSizeDeltaY(this.disGp, bx_height)
			}
			this.disGp.visible = show_use_ways

			let color = Enum_ColorUtil_Dark.YELLOW
			this._lb_rating.innerHTML = `基础评分：<font color=${color}>${baseScore}</font>`
			this._lb_level.innerHTML = `穿戴等级：<font color=${color}>${(goodsBasic.level || 1)}</font>`

			// 滑动框高度
			RefBoxVLayout(this.detail_group, 5, true)
			let grouph = this.detail_group.height
			if (grouph > 400) {
				grouph = 400
			} else if (grouph < 170) {
				grouph = 170
			}
			this.scrollerhei = grouph
			SetSizeDeltaY(this.scroller, grouph)
		}
	}


	_img_bg: Laya.Image
	_gp_icon: Laya.Box
	_img_title: Laya.Image
	_lb_name: Laya.Label
	_lb_rating: Laya.HTMLDivElement
	_lb_level: Laya.HTMLDivElement
	scroller: Laya.Panel
	detail_group: Laya.Box
	baseGp: Laya.Box
	_Image3: Laya.Image
	baseName: Laya.HTMLDivElement
	_lb_base_attr: Laya.HTMLDivElement
	rareGp: Laya.Box
	_Image5: Laya.Image
	_Label1: Laya.Label
	rareLb: Laya.HTMLDivElement
	bestGp: Laya.Box
	_Image7: Laya.Image
	_Label2: Laya.Label
	bestLb: Laya.HTMLDivElement
	disGp: Laya.Box
	_Image9: Laya.Image
	_Label3: Laya.Label
	disLb: Laya.HTMLDivElement
	btnGroup: Laya.Box
	devour0: Laya.Label
	devour1: Laya.HBox
	devourLb: Laya.Label
	devourIcon: Laya.Image
	_Group1: Laya.Box
	_Image11: Laya.Image
	_lb_career: Laya.HTMLDivElement
	_lb_pos: Laya.HTMLDivElement
	_gp_btns: Laya.Box
	_btn_close: Laya.Box
	_img_closeBtn: Laya.Image
	_lb_closeBtn: Laya.Label
	_btn_inEquip: Laya.Box
	_img_ineBtn: Laya.Image
	_lb_ineBtn: Laya.Label
	_btn_replace: Laya.Box
	_img_repBtn: Laya.Image
	_lb_repBtn: Laya.Label
	replaceRed: Laya.Image
	_btn_out: Laya.Box
	_img_outBtn: Laya.Image
	_lb_outBtn: Laya.Label
	red0: Laya.Image
	public GetComponents() {
		[
			this._img_bg,
			this._gp_icon,
			this._img_title,
			this._lb_name,
			this._lb_rating,
			this._lb_level,
			this.scroller,
			this.detail_group,
			this.baseGp,
			this._Image3,
			this.baseName,
			this._lb_base_attr,
			this.rareGp,
			this._Image5,
			this._Label1,
			this.rareLb,
			this.bestGp,
			this._Image7,
			this._Label2,
			this.bestLb,
			this.disGp,
			this._Image9,
			this._Label3,
			this.disLb,
			this.btnGroup,
			this.devour0,
			this.devour1,
			this.devourLb,
			this.devourIcon,
			this._Group1,
			this._Image11,
			this._lb_career,
			this._lb_pos,
			this._gp_btns,
			this._btn_close,
			this._img_closeBtn,
			this._lb_closeBtn,
			this._btn_inEquip,
			this._img_ineBtn,
			this._lb_ineBtn,
			this._btn_replace,
			this._img_repBtn,
			this._lb_repBtn,
			this.replaceRed,
			this._btn_out,
			this._img_outBtn,
			this._lb_outBtn,
			this.red0,
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_gp_icon",
				"_img_title",
				"_lb_name",
				"_lb_rating",
				"_lb_level",
				"scroller",
				"detail_group",
				"baseGp",
				"_Image3",
				"baseName",
				"_lb_base_attr",
				"rareGp",
				"_Image5",
				"_Label1",
				"rareLb",
				"bestGp",
				"_Image7",
				"_Label2",
				"bestLb",
				"disGp",
				"_Image9",
				"_Label3",
				"disLb",
				"btnGroup",
				"devour0",
				"devour1",
				"devourLb",
				"devourIcon",
				"_Group1",
				"_Image11",
				"_lb_career",
				"_lb_pos",
				"_gp_btns",
				"_btn_close",
				"_img_closeBtn",
				"_lb_closeBtn",
				"_btn_inEquip",
				"_img_ineBtn",
				"_lb_ineBtn",
				"_btn_replace",
				"_img_repBtn",
				"_lb_repBtn",
				"replaceRed",
				"_btn_out",
				"_img_outBtn",
				"_lb_outBtn",
				"red0",
			])
	}
}
window["GodCourtTooltip"] = GodCourtTooltip