import { BaseView1 } from "./BaseView1"
import { table } from "./table"
import { Util, Trim, SetAnchoredPosition, SetSizeDeltaY, HtmlColorTxt, RefGridLayout, AtlasUrl } from "../util/Util"
import { ColorUtil, Enum_ColorUtil_Dark } from "../util/ColorUtil"
import { TimeUtil } from "../util/TimeUtil"
import { ResManager } from "./ResManager"
import { Message } from "../sysInfo/SysInfoController"
import { ColorType } from "../util/ColorUtil"
import { Enum_UILayer } from "./LayerManager"
import { WordManager } from "./WordManager"
import { GoodsModel } from "../commonModel/GoodsModel"
import { RoleManager } from "../commonModel/RoleManager"
import { StarEquipModel } from "../commonModel/StarEquipModel"
import { EquipmentItem } from "./EquipmentItem"
import { HolySealToolSuitAttrItem } from "./HolySealToolSuitAttrItem"
import { StarEquipExcItem } from "./StarEquipExcItem"

import "../starEquip/StarEquipTransform"
import "../starEquip/StarChangeEquipView"
import { GameResPath } from "../util/GameResPath"

export class StarEquipToolTip extends BaseView1 {
	//GetBaseAndStrenProStr
	InitEvent
	InitView
	LoadSuccess
	RefreshBtnState
	Remove
	SetData
	UpdateSuitData
	_Group1

	excItemList
	goods_icon
	goods_vo
	is_center
	model
	only_goods_id
	replaceClose
	suit_item_list
	type_id
	x_cache
	y_cache

	cfg_equip
	cfg_pos
	cfg_page

	public static Btn = { close: 0, inEquip: 1, outEquip: 2, replace: 3, out: 4, transfrom: 5 }

	public constructor() {
		super()
		this.base_file = "common"
		this.layout_file = "StarEquipToolTip"
		this.layer_value = Enum_UILayer.Activity
		this.destroy_imm = true
		this.use_background = true
		this.click_bg_toClose = true
		this.is_center = true
		this.show_open_movie = true
		this.preload_server_config = {
			"config_constellation_equip": false,
			"config_constellation_pos": false,
			"config_constellation_page": false
		}

		this.replaceClose = false
		this.type_id = 0
		this.goods_vo = null
		let local_TimeUtil = TimeUtil
		let local_StarEquipModel = StarEquipModel
		// let local_Util = Util
		// let market_model = MarketModel.GetInstance()
		// let local_MarketEvent = MarketEvent
		// let local_Message = Message
		let goods_model = GoodsModel.GetInstance()
		let local_WordManager = WordManager
		let _role_id
		// let _pos_x = 0
		// let _pos_y = 0
		// let _btn_list = null
		let _show_btn_list = null
		this.model = local_StarEquipModel.GetInstance()

		this.load_callback = () => {
			this._Scroller1.vScrollBarSkin = ""

			this._lb_level.style.fontSize = 24
			this._lb_level.style.color = "#ffffff"
			this._lb_level.style.wordWrap = false
			
			this._lb_rating.style.fontSize = 24
			this._lb_rating.style.color = "#ffffff"
			this._lb_rating.style.wordWrap = false
			
			this._lb_career.style.fontSize = 20
			this._lb_career.style.color = "#663915"
			this._lb_career.style.wordWrap = false
			this._lb_career.style.bold = true
			
			this._lb_pos.style.fontSize = 20
			this._lb_pos.style.color = "#663915"
			this._lb_pos.style.wordWrap = false
			this._lb_pos.style.bold = true
			
			this._lb_base_attr.width = 380
			this._lb_base_attr.style.fontSize = 20
			this._lb_base_attr.style.color = "#663915"
			this._lb_base_attr.style.leading = 8
			
			this.disLb.width = 380
			this.disLb.style.fontSize = 20
			this.disLb.style.color = "#663915"
			this.disLb.style.leading = 8
			
			this.baseName.style.fontSize = 20
			this.baseName.style.bold = true
			this.baseName.style.color = "#663915"
			this.baseName.style.wordWrap = false

			this.cfg_equip = ResManager.GetInstance().GetGameConfigFromCache(this, "config_constellation_equip", false)
			this.cfg_pos = ResManager.GetInstance().GetGameConfigFromCache(this, "config_constellation_pos", false)
			this.cfg_page = ResManager.GetInstance().GetGameConfigFromCache(this, "config_constellation_page", false)
			//this.visible = false 
			this.LoadSuccess()
		}

		this.open_callback = () => {
			this.InitView()
		}

		this.close_callback = () => {
			StarEquipModel.GetInstance().Fire(StarEquipModel.CLOSE_COMPARED)
		}

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
			if (this.excItemList) {
				for (let _tmpi in this.excItemList) {
					let vo = this.excItemList[_tmpi]
					vo.DeleteMe()
				}
				this.excItemList = null
			}
			this.goods_vo = null
			this.only_goods_id = this.goods_vo
		}

		this.LoadSuccess = () => {
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
				if (this.replaceClose) {
					let wearEquip = StarEquipModel.GetInstance().GetWearEquip(this.goods_vo.page, this.goods_vo.subtype)
					if (((wearEquip && wearEquip.addition_attrlist.length >= 2) && this.goods_vo.rating > wearEquip.rating) && this.goods_vo.addition_attrlist.length == 0) {
						StarEquipModel.GetInstance().Fire(StarEquipModel.OPEN_VIEW, "StarEquipTransform", wearEquip, this.goods_vo)
						return
					}
					if (!next_time || next_time < local_TimeUtil.getServerTime()) {
						this.model.Fire(local_StarEquipModel.SEND_PROTO, 23202, "lic", this.goods_vo.goods_id, this.goods_vo.page, 0)
						this.Close()
					}
				} else {
					this.model.Fire(local_StarEquipModel.OPEN_VIEW, "StarChangeEquipView", this.goods_vo)
					this.Close()
				}
			}, this, true)

			Util.AddClickEvent(this._btn_inEquip, () => {
				if (!this.goods_vo) {
					return
				}
				let wearEquip = StarEquipModel.GetInstance().GetWearEquip(this.goods_vo.page, this.goods_vo.subtype)
				if ((wearEquip && wearEquip.addition_attrlist.length >= 2) && this.goods_vo.rating > wearEquip.rating) {
					StarEquipModel.GetInstance().Fire(StarEquipModel.OPEN_VIEW, "StarEquipTransform", wearEquip, this.goods_vo)
					StarEquipModel.GetInstance().Fire(local_StarEquipModel.CLOSE_COMPARED)
					return
				}
				if (!next_time || next_time < local_TimeUtil.getServerTime()) {
					this.model.Fire(local_StarEquipModel.SEND_PROTO, 23202, "lic", this.goods_vo.goods_id, this.goods_vo.page, 0)
					this.Close()
				}
				StarEquipModel.GetInstance().Fire(local_StarEquipModel.CLOSE_COMPARED)
			}, this, true)

			Util.AddClickEvent(this.out, () => {
				if (this.goods_vo) {
					StarEquipModel.GetInstance().SelectComMat(this.goods_vo.goods_id, this.goods_vo.comIndex, false)
					this.Close()
				}
			}, this, true)

			Util.AddClickEvent(this.transfromBtn, () => {
				if (this.goods_vo) {
					let equipList = goods_model.starEquipBagList
					let curPage = this.goods_vo.page
					let curType = this.goods_vo.subtype
					let color = this.goods_vo.color
					let transEquip = null
					for (let _tmpi in equipList) {
						let vo = equipList[_tmpi]
						if ((((vo.color >= ColorType.ORANGE && vo.addition_attrlist.length > 0) && vo.color < color) && vo.page == curPage) && vo.subtype == curType) {
							if (!transEquip || transEquip.rating < vo.rating) {
								transEquip = vo
							}
						}
					}
					if (transEquip) {
						StarEquipModel.GetInstance().Fire(StarEquipModel.OPEN_VIEW, "StarEquipTransform", transEquip, this.goods_vo, 1)
						this.Close()
					} else {
						Message.show("需要一件有卓越属性的同部位橙装才能进行属性转移")
					}
				}
			}, this, true)

			Util.AddClickEvent(this._btn_outEquip, () => {
				if (!this.goods_vo) {
					return
				}
				this.model.Fire(local_StarEquipModel.SEND_PROTO, 23203, "ic", this.goods_vo.page, this.goods_vo.subtype)
				this.Close()
			}
				, this, true)

			this.BindEvent(this.model, local_StarEquipModel.PREVIEW_TOOLTIPS, (data?) => {
				if (this.goods_vo && data.goods_id == Number(this.goods_vo.goods_id)) {
					this.UpdateSuitData(data)
				}
			}
			)

			this.BindEvent(this.model, local_StarEquipModel.TRANSFROM_PREVIEW, (data?) => {
				if (this.goods_vo && data.goods_id == Number(this.goods_vo.goods_id)) {
					this.UpdateSuitData(data)
				}
			}
			)
			//ResManager.GetInstance().SetOutsideImageSprite(this, this._Image12, GameResPath.GetIcon("common2", "uity_016c"), true)
		}

		this.SetData = (type_id?, goods_vo?, role_id?, show_btn_list?, x?, y?, only_goods_id?) => {
			this.type_id = type_id
			this.only_goods_id = only_goods_id
			_role_id = role_id
			_show_btn_list = show_btn_list || [0]
			this.x_cache = x
			this.y_cache = y
			if (x != null && y != null) {
				this.is_center = false
			} else {
				this.is_center = true
			}
			if (goods_vo) {
				this.goods_vo = goods_vo
			}
		}

		this.InitView = () => {
			if (!this.goods_vo) {
				let goodsVo = goods_model.GetGoodsBasicByTypeId(this.type_id)
				goodsVo.goods_id = this.type_id
				let equipCfg = this.cfg_equip[Number(this.type_id)]
				if (equipCfg) {
					let star = 0
					let excAttr = JSON.parse(equipCfg.extra_attr)
					for (let _tmpi in excAttr) {
						let vo = excAttr[_tmpi]
						if ((vo[6] && vo[6] == '1') || (!vo[6] && vo[4] && vo[4] == '1')) {
							star = star + 1
						}
					}
					goodsVo.star = star
					goodsVo.is_suit = equipCfg.is_suit == 1
					goodsVo.page = equipCfg.page
				}
				if (this.only_goods_id) {
					goodsVo.goods_id = this.only_goods_id
				} else {
					goodsVo.sham = true
				}
				this.goods_vo = goodsVo
			}
			let basic = goods_model.GetGoodsBasicByTypeId(this.type_id)
			if (basic == null) {
				return
			}
			if (!this.goods_icon) {
				this.goods_icon = new EquipmentItem(this._gp_icon)
				this.goods_icon.Load()
				this.goods_icon.SetItemSize(84, 84)
				this.goods_icon.SetShowTips(false)
			}
			this.goods_icon.SetData(basic.type_id)
			if (this.goods_vo.sham) {
				if (!this.model.typePreviewCache[this.goods_vo.type_id]) {
					local_StarEquipModel.GetInstance().Fire(local_StarEquipModel.SEND_PROTO, 23255, "i", this.goods_vo.type_id)
				} else {
					this.UpdateSuitData(this.model.typePreviewCache[this.goods_vo.type_id])
				}
			} else if (this.goods_vo.goods_id != 23254) {
				local_StarEquipModel.GetInstance().Fire(local_StarEquipModel.SEND_PROTO, 23250, "ll", _role_id || RoleManager.GetInstance().GetMainRoleId(), this.goods_vo.goods_id)
			} else {
				let chache = local_StarEquipModel.GetInstance().transfromCache
				if (chache) {
					this.UpdateSuitData(chache)
				}
			}
			if (this.x_cache != null && this.y_cache != null) {
				//SetAnchoredPosition(this.display_obj, this.x_cache, this.y_cache)
				this.display_obj.centerX = this.x_cache
				this.display_obj.centerY = this.y_cache
			}
			//this._lb_name.color = ColorUtil.GetColorDark(basic.color, false)
			this._lb_name.text = Trim(basic.goods_name)
			this.img_namebg.skin = GameResPath.GetIcon('common4', 'ui_tips_pz_' + basic.color)
			let is_preview = true
			//let is_wear_equip = false
			if (this.goods_vo.goods_id) {
				is_preview = false
			}
			// let attr_list = []
			// let base_attr = ErlangParser.GetInstance().Parse(basic.base_attrlist)
			// for (let _tmpi in base_attr) {
			// 	let vo = base_attr[_tmpi]
			// 	table.insert(attr_list, vo)
			// }
			this._lb_career.innerHTML = Util.StrToHTML("等级：<font color='#d15e00'>" + (basic.level != 0 && basic.level || "无限制") + "</font>")
			let posCfg = this.cfg_pos[basic.subtype]
			if (posCfg) {
				this._lb_pos.innerHTML = Util.StrToHTML("部位：<font color='#d15e00'>" + posCfg.name + "</font>")
			}
			this._lb_suit_value.text = Util.StrToHTML("<font color='#d15e00'>无</font>")
			this.RefreshBtnState()
		}

		// this.GetBaseAndStrenProStr = (base_attrlist?, stren_list?) => {
		// 	let str = ""
		// 	let stren_str = null
		// 	let pro = null
		// 	if (base_attrlist && Array.isArray(base_attrlist)) {
		// 		base_attrlist.forEach((val?, idx?, array?) => {
		// 			stren_str = ""
		// 			if (stren_list && Array.isArray(stren_list)) {
		// 				let i = 0
		// 				do {
		// 					pro = stren_list[i]
		// 					if ((pro && pro[0] == val[0]) && pro[1] > 0) {
		// 						stren_str = " <font color='#0a953e'.length>(强化+" + pro[1] + ")</font>"
		// 						break
		// 					}
		// 					i = i + 1
		// 				} while ((i < stren_list.length))
		// 			}
		// 			if (idx + 1 != base_attrlist.length) {
		// 				str = str + local_WordManager.GetProperties(val[0]) + ":<font color='#4a3a32'>" + local_WordManager.ConvertToPercentValue(val[0], val[1]) + "</font>" + stren_str + " \n"
		// 			} else {
		// 				str = str + local_WordManager.GetProperties(val[0]) + ":<font color='#4a3a32'>" + val[1] + "</font>" + stren_str
		// 			}
		// 		}
		// 		)
		// 	}
		// 	return str
		// }

		this.RefreshBtnState = () => {
			let btn = null
			let i = 0
			if (_show_btn_list.length > 0) {
				do {
					let show = Util.TableContains(_show_btn_list, i)
					btn = this._gp_btns.getChildAt(i)
					if (btn) {
						btn.visible = show
					}
					i = i + 1
				} while ((i < this._gp_btns.numChildren))
			}
			

			let list = this.model.equipRedList
			let Num = list[this.goods_vo.page] && list[this.goods_vo.page][this.goods_vo.subtype]
			this.replaceRed.visible = this._btn_replace.visible && (Num && Num == 1)
			this.red0.visible = this.transfromBtn.visible && (Num && Num > 1)

			RefGridLayout(this._gp_btns, {
				column: 2,
				h_gap: 64,
				v_gap: 25,
				item_w: 141,
				item_h: 52
			})
		}

		this.UpdateSuitData = (data?) => {
			this.goods_icon.ExcuteCallback(() => {
				this.goods_icon.SetStarEquipStar(this.goods_vo.color, this.goods_vo.star)
			})

			let color = Enum_ColorUtil_Dark.YELLOW
			this._lb_level.innerHTML = `综合评分：<font color=${color}>${data.score}</font>`
			this._lb_rating.innerHTML = `基础评分：<font color=${color}>${data.base_rating}</font>`

			let total_height = 0

			this.bestGp.y = total_height
			{
				// 极品属性
				let bestAttr = data.extra_attr
				let bestNum = 0
				let bestStr = ""
				for (let _tmpi in bestAttr) {
					let vo = bestAttr[_tmpi]
					if (_tmpi == bestAttr.length) {
						bestStr = bestStr + WordManager.GetProperties(vo[0]) + (" + ") + WordManager.ConvertToPercentValue(vo[0], vo[1])
					} else {
						bestStr = bestStr + WordManager.GetProperties(vo[0]) + (" + ") + WordManager.ConvertToPercentValue(vo[0], vo[1]) + "\n"
					}
					bestNum = bestNum + 1
				}
				
				this.bestLb.text = bestStr
				this.bestGp.visible = bestNum > 0
				var height = bestNum > 0 ? (42 + bestNum * 28) : 0
				SetSizeDeltaY(this.bestGp, height)
				// total_height += (height + 10)
				total_height += height
			}
			

			//没用的词缀属性
			//let affixAttr = data.send_dsgt
			//if (affixAttr.length > 0 ) {
			//let affStr = ""
			//for (let _tmpi in affixAttr) {
			//let dsgtAttr = affixAttr[_tmpi]
			//for (let _tmpi in dsgtAttr.dsgt_attr) {
			//let vo = dsgtAttr.dsgt_attr[_tmpi]
			//affStr = affStr + WordManager.GetProperties(vo[0]) + ":" + WordManager.ConvertToPercentValue(vo[0], vo[1]) + "\n"
			//}
			//}
			//affStr = string.gsub(affStr, '\n$', "")
			//this.affixLb.text = affStr
			//}else{
			//this.affixsuitGp.visible = false 
			//this.affixGp.visible = false 
			//}

			// 进化属性
			this.evolutionGp.y = total_height
			{
				let evolutionLbData = data.evolu_attr
				let evoNum = 0
				if (evolutionLbData && evolutionLbData.length > 0) {
					let spiritStrevoluStr = ""
					for (let _tmpi in evolutionLbData) {
						let vo = evolutionLbData[_tmpi]
						spiritStrevoluStr = spiritStrevoluStr + WordManager.GetProperties(vo[0]) + (" + ") + WordManager.ConvertToPercentValue(vo[0], vo[1]) + "\n"
						evoNum = evoNum + 1
					}
					spiritStrevoluStr = spiritStrevoluStr.replace('\n$', "")
					this.evolutionLb.text = spiritStrevoluStr
					this.evolutionGp.visible = true
					var height = 42 + evoNum * 28
					SetSizeDeltaY(this.evolutionGp, height)
					// total_height += (height + 10)
					total_height += height
				} else {
					this.evolutionGp.visible = false
					SetSizeDeltaY(this.evolutionGp, 0.1)
				}
			}
			

			// 启灵属性
			this.spiritGp.y = total_height
			{
				let spiritAttr = data.spirit_attr
				let spiritNum = 0
				if (spiritAttr && spiritAttr.length > 0) {
					let spiritStr = ""
					for (let _tmpi in spiritAttr) {
						let vo = spiritAttr[_tmpi]
						spiritStr = spiritStr + WordManager.GetProperties(vo[0]) + (" + ") + WordManager.ConvertToPercentValue(vo[0], vo[1]) + "\n"
						spiritNum = spiritNum + 1
					}
					spiritStr = spiritStr.replace('\n$', "")
					this.spiritLb.text = spiritStr
					this.spiritGp.visible = true
					var height = 42 + spiritNum * 28
					SetSizeDeltaY(this.spiritGp, height)
					// total_height += (height + 10)
					total_height += height
				}
				else{
					this.spiritGp.visible = false
					SetSizeDeltaY(this.spiritGp, 0.1)
				}
			}
			

			// 卓越属性
			this.excGp.y = total_height
			{
				let star_attr = data.star_attr_cfg
				table.sort(star_attr, (a?, b?) => {
					return b.type_id < a.type_id
				})
				if (!this.excItemList) {
					this.excItemList = []
				}
				for (let i = 0; i < star_attr.length; i++) {
					let vo = star_attr[i]
					let item = this.excItemList[i]
					if (!item) {
						item = new StarEquipExcItem(this.excItemGp)
						item.Load()
						this.excItemList[i] = item
					}
					item.SetVisible(true)
					item.SetData(vo)
				}
				for (let i = star_attr.length; i < this.excItemList.length; i++) {
					let item = this.excItemList[i]
					if (item) {
						item.SetVisible(false)
					}
				}
				if (star_attr && star_attr.length > 0) {
					this.noexcLb.visible = false
					this.excItemGp.visible = true
					this.excGp.visible = true
					var height = 42 + 28 * star_attr.length
					SetSizeDeltaY(this.excGp, height)
					// total_height += (height + 10)
					total_height += height
				} else {
					this.excItemGp.visible = false
					this.noexcLb.visible = true
					this.excGp.visible = false
					SetSizeDeltaY(this.excGp, 0.1)
				}
			}
			

			// 套装属性
			this.excsuitGp.y = total_height
			{
				let suit_id = this.goods_vo.page
				let my_count = data.suit_num
				//let list = data.suit_attr
				let suitHeight = 42
				let suit_cfg = this.cfg_page[suit_id]
				if (suit_cfg && this.goods_vo.is_suit) {
					let nomal = this.goods_vo.subtype < 7
					this.excsuitName.text = (nomal && suit_cfg.normal_name || suit_cfg.special_name) + "套装(" + my_count + "/" + (nomal && 6 || 4) + ")"
					this._gp_suit_attr_con.visible = true
					this._lb_suit_value.visible = false
					let max_count = 0
					let suit_attr = (nomal && (JSON.parse(suit_cfg.normal_suit_attr)) || (JSON.parse(suit_cfg.special_suit_attr)))
					//let desc = ""
					if (!this.suit_item_list) {
						this.suit_item_list = []
					}
					let i = 0
					do {
						let item = this.suit_item_list[i]
						if (!item) {
							item = new HolySealToolSuitAttrItem(this._gp_suit_attr_con)
							this.suit_item_list[i] = item
							item.Load()
						}
						let vo = suit_attr[i]
						let count = vo[0]
						item.SetData([vo[0], vo[2]], my_count)
						max_count = count
						suitHeight += item.GetHeight()
						i = i + 1
					} while ((i < suit_attr.length))
					this.excsuitGp.visible = true
				} else {
					//suitHeight = 70
					suitHeight = 0.1
					this._gp_suit_attr_con.visible = false
					this._lb_suit_value.visible = true
					this.excsuitName.text = "套装属性"
					this._lb_suit_value.text = HtmlColorTxt("无", ColorUtil.GetColorDark(ColorType.RED))
					this.excsuitGp.visible = false
				}
				SetSizeDeltaY(this.excsuitGp, suitHeight)
				// total_height += (suitHeight + 10)
				if(this.excsuitGp.visible == false){
					total_height += suitHeight
				}else{
					total_height += suitHeight - 7
				}
			}	
			
			
			// 基础属性
			this.baseGp.y = total_height
			{
				let baseStr = ""
				let nameStr = "基础属性(基础"
				let baseNum = 0
				let baseAttr = data.base_attr
				let strenAttr = data.stren_attr
				let strenList = {}
				if (strenAttr && strenAttr.length > 0) {
					nameStr = nameStr + ("<font color='#0a953e'> +强化</font>")
					for (let _tmpi in strenAttr) {
						let strenVo = strenAttr[_tmpi]
						if (!strenList[strenVo[0]]) {
							strenList[strenVo[0]] = strenVo[1]
						} else {
							strenList[strenVo[0]] = strenList[strenVo[0]] + strenVo[1]
						}
					}
				}
				let masterAttr = data.master_attr
				let masterList = {}
				if (masterAttr && masterAttr.length > 0) {
					nameStr = nameStr + ("<font color='#2971e6'> +觉醒</font>")
					for (let _tmpi in masterAttr) {
						let masterVo = masterAttr[_tmpi]
						if (!masterList[masterVo[0]]) {
							masterList[masterVo[0]] = masterVo[1]
						} else {
							masterList[masterVo[0]] = masterList[masterVo[0]] + masterVo[1]
						}
					}
				}
				for (let _tmpi in baseAttr) {
					let vo = baseAttr[_tmpi]
					let strenStr = ""
					if (strenList[vo[0]]) {
						strenStr = " <font color='#0a953e'>+" + WordManager.ConvertToPercentValue(vo[0], strenList[vo[0]]) + "</font> "
						//strenList[vo[0]] = null
						//strenList.splice(vo[0], 1)
						delete strenList[vo[0]]
					}
					let masterStr = ""
					if (masterList[vo[0]]) {
						masterStr = " <font color='#2971e6'>+" + WordManager.ConvertToPercentValue(vo[0], masterList[vo[0]]) + "</font> "
						//masterList[vo[0]] = null
						//masterList.splice(vo[0], 1)
						delete masterList[vo[0]]
					}
					baseStr = baseStr + WordManager.GetProperties(vo[0]) + ":<font color='#d15e00'>" + WordManager.ConvertToPercentValue(vo[0], vo[1]) + "</font>" + strenStr + masterStr + "<br>"
					baseNum = baseNum + 1
				}
				for (let key in strenList) {
					baseStr = baseStr + WordManager.GetProperties(Number(key)) + ":<font color='#0a953e'>" + WordManager.ConvertToPercentValue(key, strenList[key]) + "</font>"
					if (masterList[key]) {
						baseStr = baseStr + " <font color='#2971e6'>+" + WordManager.ConvertToPercentValue(key, masterList[key]) + "</font>"
						//masterList[key] = null
						//masterList.splice(Number(key), 1)
						delete masterList[Number(key)]
					}
					baseStr = baseStr + "<br>"
					baseNum = baseNum + 1
				}
				for (let key in masterList) {
					baseStr = baseStr + WordManager.GetProperties(Number(key)) + ":<font color='#2971e6'>" + WordManager.ConvertToPercentValue(key, masterList[key]) + "</font><br>"
					baseNum = baseNum + 1
				}
				this._lb_base_attr.innerHTML = baseStr.replace("\n$", "")
				this._lb_base_attr.width = 380
				nameStr = nameStr + ")"
				this.baseName.innerHTML = nameStr.replace("%(基础%)", "")

				var height = 42 + baseNum * 28 
				SetSizeDeltaY(this.baseGp, height)
				// total_height += (height + 10)
				total_height += height
			}
			
			
			// 物品描述
			this.disGp.y = total_height
				let goodsBasic = goods_model.GetGoodsBasicByTypeId(this.goods_vo.type_id)
				let show_use_ways = null
				if (goodsBasic) {
					let str = Trim(goodsBasic.getway)
					show_use_ways = str != ""
					if (show_use_ways) {
						this.disLb.innerHTML = str
						this.disLb.width = 380
					}

				this.disGp.visible = show_use_ways
				height = show_use_ways ? (40 + this.disLb.contextHeight) : 0.1
				SetSizeDeltaY(this.disGp, height)
				total_height += height
			}
			
			if(total_height > 500){
				total_height = 500
			}

			this._Scroller1.height = total_height
			total_height = this._Scroller1.y + total_height + 10
			this._Group2.y = total_height
			total_height += 54
			this._gp_btns.y = total_height
			let len = Math.ceil(_show_btn_list.length / 2)
			total_height += (len * 52 + (len - 1) * 25)
			total_height += 26

			this._img_bg.height = total_height
			this.display_obj.height = total_height
		}
	}

	_img_bg: Laya.Image
	_gp_icon: Laya.Box
	img_namebg: Laya.Image
	_Image2: Laya.Image
	_lb_name: Laya.Label
	_lb_rating: Laya.HTMLDivElement
	_lb_level: Laya.HTMLDivElement
	_Scroller1: Laya.Panel
	Content: Laya.VBox
	bestGp: Laya.Box
	_Label1: Laya.Label
	bestLb: Laya.Label
	_Image3: Laya.Image
	affixGp: Laya.Box
	_Label2: Laya.Label
	affixLb: Laya.Label
	_Image4: Laya.Image
	affixsuitGp: Laya.Box
	_Label3: Laya.Label
	affixsuitLb: Laya.Label
	_Image5: Laya.Image
	evolutionGp: Laya.Box
	_Label4: Laya.Label
	evolutionLb: Laya.Label
	_Image6: Laya.Image
	spiritGp: Laya.Box
	_Label5: Laya.Label
	spiritLb: Laya.Label
	_Image7: Laya.Image
	excGp: Laya.Box
	_Label6: Laya.Label
	excItemGp: Laya.VBox
	_Image8: Laya.Image
	noexcLb: Laya.Label
	excsuitGp: Laya.Box
	excsuitName: Laya.Label
	_gp_suit_attr_con: Laya.VBox
	_lb_suit_value: Laya.Label
	_Image9: Laya.Image
	baseGp: Laya.Box
	baseName: Laya.HTMLDivElement
	_lb_base_attr: Laya.HTMLDivElement
	_Image10: Laya.Image
	disGp: Laya.Box
	_Label7: Laya.Label
	disLb: Laya.HTMLDivElement
	_Image11: Laya.Image
	_Group2: Laya.Box
	_Image12: Laya.Image
	_lb_career: Laya.HTMLDivElement
	_lb_pos: Laya.HTMLDivElement
	_gp_btns: Laya.Box
	_btn_close: Laya.Box
	_Image1111111: Laya.Image
	labelDisplay1: Laya.Label
	_btn_inEquip: Laya.Box
	_Image1111: Laya.Image
	labelDisplay1111: Laya.Label
	_btn_outEquip: Laya.Box
	_Image1: Laya.Image
	labelDisplay: Laya.Label
	_btn_replace: Laya.Box
	_Image11111: Laya.Image
	labelDisplay111: Laya.Label
	out: Laya.Box
	_Image111: Laya.Image
	labelDisplay11111: Laya.Label
	transfromBtn: Laya.Box
	_Image111111: Laya.Image
	labelDisplay11: Laya.Label
	red0: Laya.Image
	replaceRed: Laya.Image
	public GetComponents() {
		[
			this._img_bg,
			this._gp_icon,
			this.img_namebg,
			this._Image2,
			this._lb_name,
			this._lb_rating,
			this._lb_level,
			this._Scroller1,
			this.Content,
			this.bestGp,
			this._Label1,
			this.bestLb,
			this._Image3,
			this.affixGp,
			this._Label2,
			this.affixLb,
			this._Image4,
			this.affixsuitGp,
			this._Label3,
			this.affixsuitLb,
			this._Image5,
			this.evolutionGp,
			this._Label4,
			this.evolutionLb,
			this._Image6,
			this.spiritGp,
			this._Label5,
			this.spiritLb,
			this._Image7,
			this.excGp,
			this._Label6,
			this.excItemGp,
			this._Image8,
			this.noexcLb,
			this.excsuitGp,
			this.excsuitName,
			this._gp_suit_attr_con,
			this._lb_suit_value,
			this._Image9,
			this.baseGp,
			this.baseName,
			this._lb_base_attr,
			this._Image10,
			this.disGp,
			this._Label7,
			this.disLb,
			this._Image11,
			this._Group2,
			this._Image12,
			this._lb_career,
			this._lb_pos,
			this._gp_btns,
			this._btn_close,
			this._Image1111111,
			this.labelDisplay1,
			this._btn_inEquip,
			this._Image1111,
			this.labelDisplay1111,
			this._btn_outEquip,
			this._Image1,
			this.labelDisplay,
			this._btn_replace,
			this._Image11111,
			this.labelDisplay111,
			this.out,
			this._Image111,
			this.labelDisplay11111,
			this.transfromBtn,
			this._Image111111,
			this.labelDisplay11,
			this.red0,
			this.replaceRed,
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_gp_icon",
				"img_namebg",
				"_Image2",
				"_lb_name",
				"_lb_rating",
				"_lb_level",
				"_Scroller1",
				"Content",
				"bestGp",
				"_Label1",
				"bestLb",
				"_Image3",
				"affixGp",
				"_Label2",
				"affixLb",
				"_Image4",
				"affixsuitGp",
				"_Label3",
				"affixsuitLb",
				"_Image5",
				"evolutionGp",
				"_Label4",
				"evolutionLb",
				"_Image6",
				"spiritGp",
				"_Label5",
				"spiritLb",
				"_Image7",
				"excGp",
				"_Label6",
				"excItemGp",
				"_Image8",
				"noexcLb",
				"excsuitGp",
				"excsuitName",
				"_gp_suit_attr_con",
				"_lb_suit_value",
				"_Image9",
				"baseGp",
				"baseName",
				"_lb_base_attr",
				"_Image10",
				"disGp",
				"_Label7",
				"disLb",
				"_Image11",
				"_Group2",
				"_Image12",
				"_lb_career",
				"_lb_pos",
				"_gp_btns",
				"_btn_close",
				"_Image1111111",
				"labelDisplay1",
				"_btn_inEquip",
				"_Image1111",
				"labelDisplay1111",
				"_btn_outEquip",
				"_Image1",
				"labelDisplay",
				"_btn_replace",
				"_Image11111",
				"labelDisplay111",
				"out",
				"_Image111",
				"labelDisplay11111",
				"transfromBtn",
				"_Image111111",
				"labelDisplay11",
				"red0",
				"replaceRed",
			])
	}
}
window["StarEquipToolTip"] = StarEquipToolTip