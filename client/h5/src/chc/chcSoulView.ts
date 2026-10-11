import { BaseItem1 } from "../common/BaseItem1"
import { table } from "../common/table"
import { Util, HtmlColorTxt, PlayBigEffect } from "../util/Util"
import { Enum_ColorUtil_Dark, Enum_ColorUtil_Light } from "../util/ColorUtil"
import { EventName } from "../common/EventName"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { ResManager } from "../common/ResManager"
import { GameResPath } from "../util/GameResPath"
import { WordManager } from "../common/WordManager"
import { GoodsModel } from "../commonModel/GoodsModel"
import { Message } from "../sysInfo/SysInfoController"
import { MaterialsTool } from "../common/MaterialsTool"
import { UIToolTipMgr } from "../common/UIToolTipMgr"
import { chcModel } from "../commonModel/chcModel"
import { EquipmentItem } from "../common/EquipmentItem"
import { chcEquipGroup } from "./chcEquipGroup"

export class chcSoulView extends BaseItem1 {
	GetAttrStr
	InitEvent
	LoadSuccess
	Scr_scroll_cost
	UpdateAttrData
	UpdateCostItem
	UpdateRed
	UpdateShowData

	_citem_list
	_cost_list
	_cur_data
	_egroup
	_is_spirit
	_model
	_show_item
	_stype = 1
	_tips_list
	_type
	cfg_spirit

	public constructor(parent?) {
		super(parent)
		this.base_file = "chc"
		this.layout_file = "chcSoulView"
		this.preload_server_config = {
			"config_constellation_spirit": false
		}

		this._model = chcModel.GetInstance()
		let resMgr = ResManager.GetInstance()
		let goodsModel = GoodsModel.GetInstance()
		this._type = chcModel.CHCTYPE.SOUL
		this._is_spirit = false

		this.load_callback = () => {
			this.cfg_spirit = resMgr.GetGameConfigFromCache(this, "config_constellation_spirit", false)
			this._lb_attr.width = 300
			this._lb_attr.style.fontSize = 22
			this._lb_attr.style.color = "#4a3a32"
			this._lb_attr.style.leading = 8

			this.InitEvent()
			this.LoadSuccess()
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this._btn_help, () => {
				GlobalEventSystem.Fire(EventName.OPEN_INSTRUCTION_VIEW, 23204)
			}
				, this, true)

			Util.AddClickEvent(this._btn_go, () => {
				if (!this._cur_data) {
					Message.show("请先选择装备")
				} else if (this._is_spirit) {
					Message.show("部位已启灵")
				} else {
					if (this._tips_list && this._tips_list.length > 0) {
						MaterialsTool.GetInstance().materialsTips(this._tips_list[0])
					} else {
						this._model.Fire(chcModel.REQUEST_PROTO, 23241, "cc", this._stype, this._cur_data.cell)
					}
				}
			}
				, this, true)

			this.BindEvent(this._model, chcModel.SELECT_TYPE, (stype?, type?) => {
				if (this._type != type) {
					return
				}
				this._stype = stype
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

				//PlayBigEffect("ui_qilingchenggong")
				// this.AddUIEffect("ui_qilingchenggong", this._gp_effs,{x:0,y:0},1,false)
			}
			)

			this.BindEvent(this._model, chcModel.UPDATE_INFO, (type?, stype?) => {
				if (this._type != type) {
					return
				}
				if (this._stype != stype) {
					return
				}
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
					if (basic.subtype == 14) {
						this.UpdateCostItem(this._cost_list)
						break
					}
				}
			}
			)
		}

		this.LoadSuccess = () => {
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
					i = i + 1
				} while ((i < list.length))
			}
			i = list.length
			if (i < this._citem_list.length) {
				do {
					this._citem_list[i].SetVisible(false)
					//this._citem_list[i].includeInLayout = false
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
			}
			)
			this._show_item.ExcuteCallback(() => {
				this._show_item.SetData(data.type_id)
				this._show_item.SetStarEquipStar(data.color, data.star)
			}
			)
			let edata = this._model.GetDataByPos(this._type, this._stype, data.cell)
			let scfg = this.cfg_spirit

			let ccfg = scfg[this._stype + "@" + data.cell]
			let cattr = JSON.parse(ccfg.attr)
			this.UpdateAttrData(cattr)
			let cost_list = JSON.parse(ccfg.cost)
			this.UpdateCostItem(cost_list)
			this._cost_list = cost_list

			let is_spirit = edata && edata.is_spirit != 0
			this._lb_tips.visible = is_spirit
			this._gp_cost.visible = !is_spirit
			Util.SetImageGray(this._Image6, is_spirit)
			this._is_spirit = is_spirit
			this.UpdateRed()
		}

		this.UpdateAttrData = (list?) => {
			let str = this.GetAttrStr(list, Enum_ColorUtil_Dark.GREEN)
			this._lb_attr.innerHTML = str
			this._lb_attr.width = 300
			this.gp_attr.width = this._lb_attr.contextWidth
		}

		this.GetAttrStr = (attr_list?, color?) => {
			let str = ""
			if (!attr_list) {
				return str
			}
			let i = 0
			do {
				let attr = attr_list[i]
				let line = (i + 1 != attr_list.length && ("<br>") || (""))
				let value = WordManager.ConvertToPercentValue(attr[0], attr[1])
				str = str + "启灵：" + WordManager.GetProperties(attr[0]) + " " + HtmlColorTxt(value, color) + line
				i = i + 1
			} while ((i < attr_list.length))
			return str
		}

		this.UpdateRed = () => {
			if (!this._cur_data) {
				return
			}
			this._reddot.visible = this._model.GetReddotOne(this._type, this._stype, this._cur_data.cell)
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
		//this.AddUIEffect("ui_constellation_array", "UI", this._gp_eff, null, null, true)
	}

	_btn_help: Laya.Image
	_Image2: Laya.Image
	_Image3: Laya.Image
	_lb_tips2: Laya.Label
	_lb_tips3: Laya.Label
	_gp_cost: Laya.HBox
	gp_attr: Laya.HBox
	_lb_attr: Laya.HTMLDivElement
	_lb_tips: Laya.Label
	_gp_item: Laya.Box
	_gp_show: Laya.Box
	_btn_go: Laya.Box
	_Image6: Laya.Image
	_Label1: Laya.Label
	_reddot: Laya.Image
	_gp_effs: Laya.Box
	_gp_eff: Laya.Box
	public GetComponents() {
		[
			this._btn_help,
			this._Image2,
			this._Image3,
			this._lb_tips2,
			this._lb_tips3,
			this._gp_cost,
			this.gp_attr,
			this._lb_attr,
			this._lb_tips,
			this._gp_item,
			this._gp_show,
			this._btn_go,
			this._Image6,
			this._Label1,
			this._reddot,
			this._gp_effs,
			this._gp_eff,
		]
			= this.GetChildrenByNames([

				"_btn_help",
				"_Image2",
				"_Image3",
				"_lb_tips2",
				"_lb_tips3",
				"_gp_cost",
				"gp_attr",
				"_lb_attr",
				"_lb_tips",
				"_gp_item",
				"_gp_show",
				"_btn_go",
				"_Image6",
				"_Label1",
				"_reddot",
				"_gp_effs",
				"_gp_eff",
			])
	}
}
window["chcSoulView"] = chcSoulView