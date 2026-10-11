import { BaseItem1 } from "../common/BaseItem1"
import { table } from "../common/table"
import { Util, HtmlColorTxt, PlayBigEffect } from "../util/Util"
import { Enum_ColorUtil_Dark, Enum_ColorUtil_Light } from "../util/ColorUtil"
import { EventName } from "../common/EventName"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { Message } from "../sysInfo/SysInfoController"
import { RedDotManager } from "../common/RedDotManager"
import { GoodsModel } from "../commonModel/GoodsModel"
import { ResManager } from "../common/ResManager"
import { GameResPath } from "../util/GameResPath"
import { MaterialsTool } from "../common/MaterialsTool"
import { chcModel } from "../commonModel/chcModel"
import { chcEquipGroup } from "./chcEquipGroup"
import { UIToolTipMgr } from "../common/UIToolTipMgr"
import { EquipmentItem } from "../common/EquipmentItem"

export class chcMagicView extends BaseItem1 {
	ClickCheckBox
	InitEvent
	LoadSuccess
	UpdateAttrData
	UpdateCostItem
	UpdateRed
	UpdateRedMaster
	UpdateShowData
	UpdateView

	_auto
	_citem_list
	_cost_list
	_cur_data
	_ecfg
	_egroup
	_model
	_pcfg
	_show_item
	_stype = 1
	_tips_list
	_type
	showEffectCount
	cfg_pos
	cfg_quick_buy
	cfg_enchant

	public constructor(parent?) {
		super(parent)
		this._type = chcModel.CHCTYPE.MAGIC
		this._auto = false
		this.base_file = "chc"
		this.layout_file = "chcMagicView"
		this.preload_server_config = {
			"config_constellation_pos": false,
			"config_quick_buy_price": false,
			"config_constellation_enchantment": false
		}

		this._model = chcModel.GetInstance()
		let resMgr = ResManager.GetInstance()
		let goodsModel = GoodsModel.GetInstance()

		this.load_callback = () => {
			this.cfg_pos = resMgr.GetGameConfigFromCache(this, "config_constellation_pos", false)
			this.cfg_quick_buy = resMgr.GetGameConfigFromCache(this, "config_quick_buy_price", false)
			this.cfg_enchant = resMgr.GetGameConfigFromCache(this, "config_constellation_enchantment", false)

			this._lb_cost.style.fontSize = 24
			this._lb_cost.style.color = "#4a3a32"
			this._lb_cost.style.wordWrap = false
			this._lb_attr_cur.width = 120
			this._lb_attr_cur.style.fontSize = 20
			this._lb_attr_cur.style.color = "#663915"
			this._lb_attr_next.width = 120
			this._lb_attr_next.style.fontSize = 20
			this._lb_attr_next.style.color = "#663915"

			this.InitEvent()
			this.LoadSuccess()
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this._btn_master, () => {
				GlobalEventSystem.Fire(EventName.OPEN_VIEW, "chcMasterView", this._type, this._stype)
			}
				, this, true)
			Util.AddClickEvent(this._btn_help, () => {
				GlobalEventSystem.Fire(EventName.OPEN_INSTRUCTION_VIEW, 23203)
			}
				, this, true)
			Util.AddClickEvent(this._btn_go, () => {
				if (!this._cur_data) {
					Message.show("请先选择装备")
				} else {
					if ((!this._auto && this._tips_list) && this._tips_list.length > 0) {
						MaterialsTool.GetInstance().materialsTips(this._tips_list[0])
					} else {
						this._model.Fire(chcModel.REQUEST_PROTO, 23231, "ccc", this._stype, this._cur_data.cell, this._auto && 1 || 0)
					}
				}
			}
				, this, true)
			Util.AddClickEvent(this.imgcheck, () => {
				this.ClickCheckBox()
			}, this, true)
			this.BindEvent(this._model, chcModel.SELECT_TYPE, (stype?, type?) => {
				if (this._type != type) {
					return
				}
				this._stype = stype
				this.UpdateView()
			}
			)
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


				PlayBigEffect("ui_juexingtexiao")
				//this.AddUIEffect("ui_juexingtexiao", this._gp_eff,{x:0,y:0},2,false)
				//this:AddUIEffect("ui_constellation_juexing", this._gp_effs)
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
					if (basic.subtype == 13) {
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
			this._img_tog.visible = this._auto
		}

		this.LoadSuccess = () => {
			//resMgr.SetOutsideImageSprite(this, this._img_004, GameResPath.GetIcon("chc", "uiqhjm_004"))
			this._ecfg = this.cfg_pos
			this._pcfg = this.cfg_quick_buy
			//this._cb_cost.addEventListener(Laya.Event.CHANGE, this.ClickCheckBox, this)
			//this.AddUIEffect("ui_constellation_array", "UI", this._gp_eff, null, null, true)
			this._citem_list = []
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
			let all_price = 0
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
					// [ts2lua]this._pcfg下标访问可能不正确
					let price = Number(this._pcfg[type_id].gold_price)
					let lack = Math.max(Number(vo[2]) - own, 0)
					all_price = all_price + lack * price
					i = i + 1
				} while ((i < list.length))
			}
			i = list.length
			if (i < this._citem_list.length) {
				do {
					this._citem_list[i].SetVisible(false)
					i = i + 1
				} while ((i < this._citem_list.length))
			}
			let str = HtmlColorTxt(all_price, Enum_ColorUtil_Dark.GREEN)
			this._lb_cost.innerHTML = "消耗" + str + "勾玉购买道具补齐"
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
			// [ts2lua]lua中0和空字符串也是true，此处edata需要确认
			let lv = (edata && (edata.lv) || (0))
			let scfg = this.cfg_enchant
			// [ts2lua]scfg下标访问可能不正确
			let ccfg = scfg[this._stype + "@" + data.cell + "@" + lv]
			let cattr = JSON.parse(ccfg.attr)
			// [ts2lua]scfg下标访问可能不正确
			let ncfg = scfg[this._stype + "@" + data.cell + "@" + (lv + 1)]
			// [ts2lua]lua中0和空字符串也是true，此处ncfg需要确认
			let nattr = (ncfg && (JSON.parse(ncfg.attr)) || (null))
			this.UpdateAttrData(cattr, nattr, lv)
			let cost_list = JSON.parse(ccfg.cost)
			this.UpdateCostItem(cost_list)
			this._cost_list = cost_list
			let is_max = !ncfg
			this._lb_cost_max.visible = is_max
			this._gp_cost.visible = !is_max
			this._btn_go.visible = !is_max
			this._gp_check.visible = !is_max
			this.UpdateRed()
		}

		this.UpdateAttrData = (clist?, nlist?, lv?) => {
			this._lb_stren_cur.text = "+" + lv
			let str = this._model.GetAttrStr(clist)
			this._lb_attr_cur.innerHTML = str
			this._lb_attr_cur.width = 120
			this._img_lv_max.visible = !nlist
			this._gp_attr_next.visible = !(!nlist)
			if (nlist) {
				this._lb_stren_next.text = "+" + (lv + 1)
				str = this._model.GetAttrStr(nlist, Enum_ColorUtil_Dark.GREEN)
				this._lb_attr_next.innerHTML = str
				this._lb_attr_next.width = 120
			}
		}

		this.ClickCheckBox = () => {
			this._auto = !this._auto
			this._img_tog.visible = this._auto
		}

		this.UpdateView = () => {
			if (!this.is_loaded) {
				return
			}
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
				// 		this.AddUIEffect("ui_constellation_line", "UI", this["trans_gp_effm" + i], null, null, true, { rotate = Quaternion.Euler(0, 0, chcModel.LinePos2[i]) })
				// 	}
				// }
				this._lb_master.text = "+" + info.stage
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
		//if (this._cb_cost ) {
		//this._cb_cost.removeEventListener(Laya.Event.CHANGE, this.ClickCheckBox, this)
		//}
	}

	public ReOpen_callback() {
		// this.AddUIEffect("ui_constellation_array", "UI", this._gp_eff, null, null, true)
		// if (this.showEffectCount && this.showEffectCount > 0) {
		// 	for (let i = 1; i <= this.showEffectCount; i++) {
		// 		this.AddUIEffect("ui_constellation_line", "UI", this["trans_gp_effm" + i], null, null, true, { rotate = Quaternion.Euler(0, 0, chcModel.LinePos2[i]) })
		// 	}
		// }
	}

	_btn_help: Laya.Image
	_Image2: Laya.Image
	_Image3: Laya.Image
	_Image6: Laya.Image
	_img_lv_max: Laya.Image
	_lb_cost_max: Laya.Label
	_lb_tips2: Laya.Label
	_lb_tips3: Laya.Label
	_gp_check: Laya.Box
	_lb_cost: Laya.HTMLDivElement
	imgcheck: Laya.Image
	_img_tog: Laya.Image
	_gp_cost: Laya.HBox
	_Group1: Laya.Box
	_Image7: Laya.Image
	_lb_stren_cur: Laya.Label
	_lb_attr_cur: Laya.HTMLDivElement
	_lb_tips4: Laya.Label
	_gp_attr_next: Laya.Box
	_Image9: Laya.Image
	_lb_stren_next: Laya.Label
	_lb_attr_next: Laya.HTMLDivElement
	_lb_tips5: Laya.Label
	_btn_master: Laya.Box
	_Image11: Laya.Image
	_Image12: Laya.Image
	_red_master: Laya.Image
	_gp_master: Laya.Box
	_Image13: Laya.Image
	_lb_master: Laya.Label
	_gp_effm1: Laya.Box
	_gp_effm2: Laya.Box
	_gp_effm3: Laya.Box
	_gp_effm4: Laya.Box
	_gp_effm5: Laya.Box
	_gp_effm6: Laya.Box
	_btn_go: Laya.Box
	_Image14: Laya.Image
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
			this._img_lv_max,
			this._lb_cost_max,
			this._lb_tips2,
			this._lb_tips3,
			this._gp_check,
			this._lb_cost,
			this.imgcheck,
			this._img_tog,
			this._gp_cost,
			this._Group1,
			this._Image7,
			this._lb_stren_cur,
			this._lb_attr_cur,
			this._lb_tips4,
			this._gp_attr_next,
			this._Image9,
			this._lb_stren_next,
			this._lb_attr_next,
			this._lb_tips5,
			this._btn_master,
			this._Image11,
			this._Image12,
			this._red_master,
			this._gp_master,
			this._Image13,
			this._lb_master,
			this._gp_effm1,
			this._gp_effm2,
			this._gp_effm3,
			this._gp_effm4,
			this._gp_effm5,
			this._gp_effm6,
			this._btn_go,
			this._Image14,
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
				"_img_lv_max",
				"_lb_cost_max",
				"_lb_tips2",
				"_lb_tips3",
				"_gp_check",
				"_lb_cost",
				"imgcheck",
				"_img_tog",
				"_gp_cost",
				"_Group1",
				"_Image7",
				"_lb_stren_cur",
				"_lb_attr_cur",
				"_lb_tips4",
				"_gp_attr_next",
				"_Image9",
				"_lb_stren_next",
				"_lb_attr_next",
				"_lb_tips5",
				"_btn_master",
				"_Image11",
				"_Image12",
				"_red_master",
				"_gp_master",
				"_Image13",
				"_lb_master",
				"_gp_effm1",
				"_gp_effm2",
				"_gp_effm3",
				"_gp_effm4",
				"_gp_effm5",
				"_gp_effm6",
				"_btn_go",
				"_Image14",
				"_Label1",
				"_reddot",
				"_gp_item",
				"_gp_show",
				"_gp_eff",
				"_gp_effs",
			])
	}
}
window["chcMagicView"] = chcMagicView