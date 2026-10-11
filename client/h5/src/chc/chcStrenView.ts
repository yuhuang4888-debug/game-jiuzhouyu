import { BaseItem1 } from "../common/BaseItem1"
import { Util, SetSizeDeltaY, PlayBigEffect } from "../util/Util"
import { table } from "../common/table"
import { EventName } from "../common/EventName"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { Enum_ColorUtil_Dark, Enum_ColorUtil_Light } from "../util/ColorUtil"
import { HtmlColorTxt } from "../util/Util"
import { WordManager } from "../common/WordManager"
import { Message } from "../sysInfo/SysInfoController"
import { MaterialsTool } from "../common/MaterialsTool"
import { GoodsModel } from "../commonModel/GoodsModel"
import { ResManager } from "../common/ResManager"
import { GameResPath } from "../util/GameResPath"
import { RedDotManager } from "../common/RedDotManager"
import { UIToolTipMgr } from "../common/UIToolTipMgr"
import { chcModel } from "../commonModel/chcModel"
import { EquipmentItem } from "../common/EquipmentItem"
import { chcEquipGroup } from "./chcEquipGroup"

export class chcStrenView extends BaseItem1 {
	Content1
	GetAttrStr
	GetSpecAttrList
	InitEvent
	LoadSuccess
	UpdateAttrData
	UpdateCostItem
	UpdateRed
	UpdateRedMaster
	UpdateShowData
	UpdateView

	_citem_list
	_cost_list
	_cur_data
	_ecfg
	_egroup
	_model
	_show_item
	_stype = 1
	_tips_list
	_type = 1
	showEffectCount
	cfg_strength

	public constructor(parent?) {
		super(parent)
		this.base_file = "chc"
		this.layout_file = "chcStrenView"
		this.preload_server_config = {
			"config_constellation_pos": false,
			"config_constellation_strength": false
		}

		this._model = chcModel.GetInstance()
		let resMgr = ResManager.GetInstance()
		let goodsModel = GoodsModel.GetInstance()
		this._type = chcModel.CHCTYPE.STREN
		this._citem_list = []

		this.load_callback = () => {
			this.cfg_strength = resMgr.GetGameConfigFromCache(this, "config_constellation_strength", false)
			this._Scroller1.vScrollBar.visible = false
			this._lb_attr_next.width = 120
			this._lb_attr_next.style.fontSize = 20
			this._lb_attr_next.style.color = "#663915"
			this._lb_attr_cur.width = 120
			this._lb_attr_cur.style.fontSize = 20
			this._lb_attr_cur.style.color = "#663915"
			this.InitEvent()
			this.LoadSuccess()
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this._btn_master, () => {
				GlobalEventSystem.Fire(EventName.OPEN_VIEW, "chcMasterView", this._type, this._stype)
			}, this, true)

			Util.AddClickEvent(this._btn_attr, () => {
				if (!this._cur_data) {
					Message.show("请先选择装备")
					return
				}
				GlobalEventSystem.Fire(EventName.OPEN_VIEW, "chcMagicAddView", this._stype, this._cur_data.cell)
			}, this, true)

			Util.AddClickEvent(this._btn_help, () => {
				GlobalEventSystem.Fire(EventName.OPEN_INSTRUCTION_VIEW, 23201)
			}, this, true)

			Util.AddClickEvent(this._btn_stren, () => {
				if (!this._cur_data) {
					Message.show("请先选择装备")
				} else {
					if (this._tips_list && this._tips_list.length > 0) {
						MaterialsTool.GetInstance().materialsTips(this._tips_list[0])
					} else {
						this._model.Fire(chcModel.REQUEST_PROTO, 23211, "ccc", this._stype, this._cur_data.cell, 0)
					}
				}
			}, this, true)

			Util.AddClickEvent(this._btn_spec, () => {
				GlobalEventSystem.Fire(EventName.OPEN_VIEW, "chcStrenSpecView", this._stype, this._cur_data.cell)
			}, this, true)

			this.BindEvent(this._model, chcModel.SELECT_TYPE, (stype?, type?) => {
				if (this._type != type) {
					return
				}
				this._stype = stype
				this.UpdateView()
			})

			this.BindEvent(this._model, chcModel.SELECT_ITEM, (data?, type?) => {
				if (!data) {
					return
				}
				if (this._type != type) {
					return
				}
				if (this._cur_data == data) {
					return
				}
				this._cur_data = data
				this.UpdateShowData()
			}
			)
			this.BindEvent(this._model, chcModel.UPDATE_RESULT, (type?, bool?) => {
				if (this._type != type) {
					return
				}
				if (!bool) {
					return
				}

				PlayBigEffect("ui_qianghuachenggong")
				//this.AddUIEffect("ui_qianghuachenggong", this._gp_effs,{x:0,y:0},2,false)
			}
			)
			this.BindEvent(this._model, chcModel.UPDATE_INFO, (type?, stype?) => {
				if (this._type != type) {
					return
				}
				if (this._stype != stype) {
					return
				}
				this.UpdateView()
				this.UpdateShowData()
			}
			)
			this.BindEvent(this._model, chcModel.UPDATE_RED, () => {
				this.UpdateRed()
			}
			)
			this.BindEvent(goodsModel, GoodsModel.UPDATE_GOODS_NUM, (goods_list?) => {
				if (this.use_delete_method) {
					return
				}
				for (let _tmpi in goods_list) {
					let vo = goods_list[_tmpi]
					if (!this._cost_list) {
						break
					}
					let basic = goodsModel.GetGoodsBasicByTypeId(vo.type_id)
					if (!basic) {
						break
					}
					if (basic.type != 79) {
						break
					}
					if (basic.subtype == 11) {
						this.UpdateCostItem(this._cost_list)
						break
					}
				}
			}
			)
			this.BindEvent(this._model, chcModel.UPDATE_MASTER, () => {
				this.UpdateRedMaster()
			}
			)
		}

		this.LoadSuccess = () => {
			this._ecfg = resMgr.GetGameConfigFromCache(this, "config_constellation_pos", false)
			//resMgr.SetOutsideImageSprite(this, this._img_004, GameResPath.GetIcon("chc", "uiqhjm_004"))
			//resMgr.SetOutsideImageSprite(this, this._Image6, GameResPath.GetIcon("chc", "uiqhjm_013a"))
			//resMgr.SetOutsideImageSprite(this, this._Image7, GameResPath.GetIcon("chc", "uiqhjm_013a"))

			//this.AddUIEffect("ui_constellation_array", "UI", this._gp_eff, null, null, true)

			if (!this._egroup) {
				this._egroup = new chcEquipGroup(this._gp_item)
				this._egroup.SetType(this._type)
				this._egroup.Load()
			}
		}

		this.UpdateCostItem = (list?) => {
			if (!list) {
				return
			}
			this._tips_list = []
			let i = 0
			if (i < list.length) {
				do {
					let vo = list[i]
					let item = this._citem_list[i]
					if (!item) {
						item = new EquipmentItem(this._gp_cost)
						item.Load()
						item.SetItemSize(65, 65)
						this._citem_list[i] = item
					} else {
						item.display_obj.width = 127
					}
					let type_id = goodsModel.GetMappingTypeId(vo[0], vo[1])[0]
					let own = goodsModel.GetTypeGoodsNum(type_id)
					let enough = own >= Number(vo[2])
					let color = (own >= Number(vo[2]) && (Enum_ColorUtil_Light.GREEN) || (Enum_ColorUtil_Light.RED))
					let own_str = HtmlColorTxt(own, color)
					if (!enough) {
						table.insert(this._tips_list, type_id)
					}
					item.ExcuteCallback(() => {
						item.SetData(type_id)
						item.ForceSetNumberInFlow(own_str + "/" + vo[2])
					}
					)
					item.SetVisible(true)
					i = i + 1
				} while ((i < list.length))
			}
			i = list.length
			if (i < this._citem_list.length) {
				do {
					this._citem_list[i].SetVisible(false)
					this._citem_list[i].display_obj.width = 0.1
					i = i + 1
				} while ((i < this._citem_list.length))
			}
		}

		this.UpdateShowData = () => {
			let data = this._cur_data
			if (!this._show_item) {
				this._show_item = new EquipmentItem(this._gp_show)
				this._show_item.SetItemSize(85, 85)
				this._show_item.Load()
			}

			this._show_item.SetClickCallBack(() => {
				UIToolTipMgr.GetInstance().AppendStarEquipToolTips(data.type_id, data)
			})

			this._show_item.ExcuteCallback(() => {
				this._show_item.SetData(data.type_id)
				this._show_item.SetStarEquipStar(data.color, data.star)
			})

			let edata = this._model.GetDataByPos(this._type, this._stype, data.cell)
			let lv = (edata && (edata.lv) || (0))
			let scfg = this.cfg_strength //resMgr:GetGameConfigFromCache(this, "config_constellation_strength", false)

			let ccfg = scfg[this._stype + "@" + data.cell + "@" + lv]
			let cattr = JSON.parse(ccfg.attr)

			let ncfg = scfg[this._stype + "@" + data.cell + "@" + (lv + 1)]

			let nattr = (ncfg && JSON.parse(ncfg.attr) || null)
			this.UpdateAttrData(cattr, nattr, lv, data.cell)
			let cost_list = JSON.parse(ccfg.cost)
			this.UpdateCostItem(cost_list)
			this._cost_list = cost_list
			let is_max = !ncfg
			this._lb_cost_max.visible = is_max
			this._gp_cost.visible = !is_max
			this._btn_stren.visible = !is_max
			let is_spec = this._ecfg[data.cell].type != 1
			this._btn_spec.visible = is_spec
			this.UpdateRed()
		}

		this.UpdateAttrData = (clist?, nlist?, lv?, pos?) => {
			this._lb_stren_cur.text = "+" + lv
			let [str, num] = this.GetAttrStr(clist, pos, lv, "'#d15e00'")
			this._lb_attr_cur.innerHTML = str
			this._lb_attr_cur.width = 120
			this._img_lv_max.visible = !nlist
			this._gp_attr_next.visible = !(!nlist)
			this._lb_attr_next.visible = !(!nlist)
			if (nlist) {
				this._lb_stren_next.text = "+" + ((lv + 1))
				let [str2, num2] = this.GetAttrStr(nlist, pos, lv, Enum_ColorUtil_Dark.GREEN)
				this._lb_attr_next.innerHTML = str2
				this._lb_attr_next.width = 120
			}
			if (clist) {
				SetSizeDeltaY(this.Content, (clist.length + num) * 27 - 4)
			}
		}

		this.UpdateView = () => {
			let info = this._model.GetInfoByStype(this._type, this._stype)
			if (info) {
				let count = 0
				let is_max = info.is_max == 1
				if (is_max) {
					count = 6
				} else {
					for (let _tmpi in info.equip_list) {
						let vo = info.equip_list[_tmpi]
						if (vo && this._ecfg[vo.pos].type == 1) {
							count = count + (vo.lv >= info.stage && 1 || 0)
						}
					}
				}
				this.showEffectCount = count
				// if (count > 0) {
				// 	for (let i = 1; i <= count; i++) {
				// 		this.AddUIEffect("ui_constellation_line", "UI", this["trans_gp_effm" + i], null, null, true, { rotate = Quaternion.Euler(0, 0, chcModel.LinePos[i]) })
				// 	}
				// }
				// for (let i = count + 1; i <= 6; i++) {
				// 	this.ClearUIEffect(this["trans_gp_effm" + i])
				// }
				this._lb_master.text = "+" + info.stage
				this._lb_ratio.text = info.buff + "%"
			}
			this.UpdateRedMaster()
		}

		this.UpdateRed = () => {
			if (!this._cur_data) {
				return
			}
			this._reddot.visible = this._model.GetReddotOne(this._type, this._stype, this._cur_data.cell)
		}

		this.UpdateRedMaster = () => {
			let rtype = this._model.GetReddotTypeMaster(this._type)
			let bool = RedDotManager.GetInstance().CheckAnyRedStatus(rtype, this._stype)
			this._red_master.visible = bool
		}

		this.GetSpecAttrList = (pos?, cur_lv?) => {
			let is_spec = this._ecfg[pos].type != 1
			if (!is_spec) {
				return
			}
			let list = []
			//let scfg = Config.Constellationstrength //resMgr:GetGameConfigFromCache(this, "config_constellation_strength", false)
			//let lv = 0
			//let skey = this._stype + "@" + pos + "@" + lv
			// [ts2lua]scfg下标访问可能不正确
			//let data = scfg[skey]
			//let mark = false
			//while ((data)
			//) {
			//let has_attr = data.special_attr != "[]"
			//if (has_attr ) {
			//let attr = ErlangParser.GetInstance().Parse(data.special_attr)[0]
			//list:unshift({attr=attr, lv=lv})
			//}
			//if (lv > cur_lv && has_attr ) {
			//break
			//}
			//lv=lv+1
			//// [ts2lua]scfg下标访问可能不正确
			//data = scfg[skey + lv]
			//}
			for (let i = 0; i <= 50; i++) {
				let cfg = this.cfg_strength[this._stype + "@" + pos + "@" + i]
				if (cfg) {
					let attr = JSON.parse(cfg.special_attr)[1]
					if (attr && attr.length > 0) {
						table.unshift(list, { attr: attr, lv: i })
						if (i > cur_lv) {
							break
						}
					}
				}
			}
			return list
		}

		this.GetAttrStr = (list?, pos?, cur_lv?, color?) => {
			if (!list) {
				return ""
			}
			let nstr = this._model.GetAttrStr(list, color)
			let sepc_list = this.GetSpecAttrList(pos, cur_lv)
			if (!sepc_list) {
				return [nstr, 0]
			}
			let sstr = ""
			let i = 0
			if (i < sepc_list.length) {
				do {
					let data = sepc_list[i]
					let name = WordManager.GetProperties(data.attr[0])
					let value = WordManager.ConvertToPercentValue(data.attr[0], data.attr[1])
					let open_str = (data.lv <= cur_lv && ("") || ("(+" + data.lv + "解锁)"))
					sstr = sstr + HtmlColorTxt(name + " " + value + open_str, "#ff4550") + "<br>"
					i = i + 1
				} while ((i < sepc_list.length))
			}
			return [sstr + nstr, sepc_list.length]
		}
	}

	public DeleteMe() {
		if (this._citem_list) {
			for (let _tmpi in this._citem_list) {
				let item = this._citem_list[_tmpi]
				item.DeleteMe()
			}
			this._citem_list = null
		}
		if (this._show_item) {
			this._show_item.DeleteMe()
			this._show_item = null
		}
		if (this._egroup) {
			this._egroup.DeleteMe()
			this._egroup = null
		}
		this.ClearUIEffect(this._gp_eff)
		this.ClearUIEffect(this._gp_effs)
		super.DeleteMe()
	}

	public ReOpen_callback() {
		// this.AddUIEffect("ui_constellation_array", "UI", this._gp_eff, null, null, true)
		// if (this.showEffectCount && this.showEffectCount > 0) {
		// 	for (let i = 1; i <= this.showEffectCount; i++) {
		// 		this.AddUIEffect("ui_constellation_line", "UI", this["trans_gp_effm" + i], null, null, true, { rotate = Quaternion.Euler(0, 0, chcModel.LinePos[i]) })
		// 	}
		// }
	}

	_btn_help: Laya.Image
	_Image2: Laya.Image
	_Image3: Laya.Image
	_Image6: Laya.Image
	_Image7: Laya.Image
	_img_arrow: Laya.Image
	_img_lv_max: Laya.Image
	_btn_attr: Laya.Image
	_btn_spec: Laya.Image
	_lb_tips: Laya.Label
	_lb_tips2: Laya.Label
	_lb_tips3: Laya.Label
	_lb_ratio: Laya.Label
	_lb_cost_max: Laya.Label
	_gp_cost: Laya.HBox
	_Group1: Laya.Box
	_Image9: Laya.Image
	_lb_stren_cur: Laya.Label
	_lb_tips4: Laya.Label
	_gp_attr_next: Laya.Box
	_Image11: Laya.Image
	_lb_stren_next: Laya.Label
	_lb_tips5: Laya.Label
	_Scroller1: Laya.Panel
	Content: Laya.Box
	_lb_attr_cur: Laya.HTMLDivElement
	_lb_attr_next: Laya.HTMLDivElement
	_btn_master: Laya.Box
	_Image13: Laya.Image
	_gp_effm1: Laya.Box
	_Image14: Laya.Image
	_red_master: Laya.Image
	_gp_master: Laya.Box
	_Image15: Laya.Image
	_lb_master: Laya.Label
	_gp_effm2: Laya.Box
	_gp_effm3: Laya.Box
	_gp_effm4: Laya.Box
	_gp_effm5: Laya.Box
	_gp_effm6: Laya.Box
	_btn_stren: Laya.Box
	_Image16: Laya.Image
	_Label1: Laya.Label
	_reddot: Laya.Image
	_gp_item: Laya.Box
	_gp_show: Laya.Box
	_gp_eff: Laya.Box
	_gp_effs: Laya.Box
	public GetComponents() {
		[
			this._btn_help,
			this._Image2,
			this._Image3,
			this._Image6,
			this._Image7,
			this._img_arrow,
			this._img_lv_max,
			this._btn_attr,
			this._btn_spec,
			this._lb_tips,
			this._lb_tips2,
			this._lb_tips3,
			this._lb_ratio,
			this._lb_cost_max,
			this._gp_cost,
			this._Group1,
			this._Image9,
			this._lb_stren_cur,
			this._lb_tips4,
			this._gp_attr_next,
			this._Image11,
			this._lb_stren_next,
			this._lb_tips5,
			this._Scroller1,
			this.Content,
			this._lb_attr_cur,
			this._lb_attr_next,
			this._btn_master,
			this._Image13,
			this._gp_effm1,
			this._Image14,
			this._red_master,
			this._gp_master,
			this._Image15,
			this._lb_master,
			this._gp_effm2,
			this._gp_effm3,
			this._gp_effm4,
			this._gp_effm5,
			this._gp_effm6,
			this._btn_stren,
			this._Image16,
			this._Label1,
			this._reddot,
			this._gp_item,
			this._gp_show,
			this._gp_eff,
			this._gp_effs,
		]
			= this.GetChildrenByNames([

				"_btn_help",
				"_Image2",
				"_Image3",
				"_Image6",
				"_Image7",
				"_img_arrow",
				"_img_lv_max",
				"_btn_attr",
				"_btn_spec",
				"_lb_tips",
				"_lb_tips2",
				"_lb_tips3",
				"_lb_ratio",
				"_lb_cost_max",
				"_gp_cost",
				"_Group1",
				"_Image9",
				"_lb_stren_cur",
				"_lb_tips4",
				"_gp_attr_next",
				"_Image11",
				"_lb_stren_next",
				"_lb_tips5",
				"_Scroller1",
				"Content",
				"_lb_attr_cur",
				"_lb_attr_next",
				"_btn_master",
				"_Image13",
				"_gp_effm1",
				"_Image14",
				"_red_master",
				"_gp_master",
				"_Image15",
				"_lb_master",
				"_gp_effm2",
				"_gp_effm3",
				"_gp_effm4",
				"_gp_effm5",
				"_gp_effm6",
				"_btn_stren",
				"_Image16",
				"_Label1",
				"_reddot",
				"_gp_item",
				"_gp_show",
				"_gp_eff",
				"_gp_effs",
			])
	}
}
window["chcStrenView"] = chcStrenView