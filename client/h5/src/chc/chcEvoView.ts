import { BaseItem1 } from "../common/BaseItem1"
import { table } from "../common/table"
import { Util, HtmlColorTxt, SetAnchoredPositionY, PlayBigEffect } from "../util/Util"
import { Enum_ColorUtil_Light, Enum_ColorUtil_Dark } from "../util/ColorUtil"
import { EventName } from "../common/EventName"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { SYTweenLite } from "../util/SYTweenLite"
import { Message } from "../sysInfo/SysInfoController"
import { MaterialsTool } from "../common/MaterialsTool"
import { Alert, Alert_Type } from "../alert/Alert"
import { ResManager } from "../common/ResManager"
import { GameResPath } from "../util/GameResPath"
import { GoodsModel } from "../commonModel/GoodsModel"
import { chcModel } from "../commonModel/chcModel"
import { chcEquipGroup } from "./chcEquipGroup"
import { EquipmentItem } from "../common/EquipmentItem"
import { UIToolTipMgr } from "../common/UIToolTipMgr"
import { StarEquipModel } from "../commonModel/StarEquipModel"

export class chcEvoView extends BaseItem1 {
	Emp_btn_go
	InitEvent
	LoadSuccess
	Scr_Scroller1
	SetDefRatio
	StartFailAni
	UpdateAttrData
	UpdateCostItem
	UpdateRed
	UpdateShowData

	_citem_list
	_cost_list
	_cur_data
	_def_ratio
	_egroup

	_model
	_mtrl_dic
	_ratio

	_show_item
	_stype = 1
	_tips_list
	_type
	tween_id
	waitid
	cfg_evolu
	cfg_forge_kv

	public constructor(parent?) {
		super(parent)
		this.base_file = "chc"
		this.layout_file = "chcEvoView"
		this.preload_server_config = {
			"config_constellation_evolution": false,
			"config_constellation_forge_kv": false
		}

		this._model = chcModel.GetInstance()
		let resMgr = ResManager.GetInstance()
		let goodsModel = GoodsModel.GetInstance()

		this._type = chcModel.CHCTYPE.EVO
		this._mtrl_dic = {}
		this._ratio = 0
		this._def_ratio = 0

		this.load_callback = () => {
			this.cfg_evolu = resMgr.GetGameConfigFromCache(this, "config_constellation_evolution", false)
			this.cfg_forge_kv = resMgr.GetGameConfigFromCache(this, "config_constellation_forge_kv", false)
			this._lb_attr_cur.width = 180
			this._lb_attr_cur.style.fontSize = 20
			this._lb_attr_cur.style.color = "#663915"
			this._lb_attr_next.width = 180
			this._lb_attr_next.style.fontSize = 20
			this._lb_attr_next.style.color = "#663915"
			this.InitEvent()
			this.LoadSuccess()
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this._btn_select, () => {
				GlobalEventSystem.Fire(EventName.OPEN_VIEW, "chcEvoSelectView", this._cur_data, this._mtrl_dic)
			}, this, true)

			Util.AddClickEvent(this._btn_attr, () => {
				GlobalEventSystem.Fire(EventName.OPEN_VIEW, "chcEvoAttrView", this._cur_data)
			}, this, true)

			Util.AddClickEvent(this._btn_go, () => {
				if (!this._cur_data) {
					Message.show("请先选择装备")
				} else {
					if (this._tips_list && this._tips_list.length > 0) {
						MaterialsTool.GetInstance().materialsTips(this._tips_list[0])
					} else {
						let func = () => {
							let list = this._model.DicToList(this._mtrl_dic)
							this._model.Fire(chcModel.SEND_EVO_PROTO, this._stype, this._cur_data.goods_id, this._cur_data.cell, list)
						}
						if (this._ratio < 10000 && !this._model._hide_evo_alert) {
							Alert.Show("当前进化成功率未达到100%，是否继续？\n（进化失败消耗材料不返还）", Alert_Type.AlertTypeCheckBox, func, null, null, null, null, null, (bool?) => {
								this._model._hide_evo_alert = bool
							}
							)
						} else {
							func()
						}
					}
				}
			}, this, true)

			Util.AddClickEvent(this._btn_help, () => {
				GlobalEventSystem.Fire(EventName.OPEN_INSTRUCTION_VIEW, 23202)
			}, this, true)

			this.BindEvent(this._model, chcModel.SELECT_TYPE, (stype?, type?) => {
				if (this._type != type) {
					return
				}
				this._stype = stype
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
			})

			this.BindEvent(this._model, chcModel.UPDATE_MTRL, (dic?, ratio?) => {
				this._mtrl_dic = dic
				this._ratio = ratio
				ratio = Math.min(100, Math.floor(ratio / 100))
				this._lb_ratio.text = ratio + "%"
			})

			this.BindEvent(this._model, chcModel.UPDATE_RESULT, (type?, bool?, scmd?) => {
				if (this._type != type) {
					return
				}
				this.SetDefRatio()
				if (bool) {
					//this.AddUIEffect("ui_jinhuachenggong", "Activity", this._gp_eff)
					setTimeout(() => {
						if (scmd) {
							GlobalEventSystem.Fire(EventName.OPEN_VIEW, "chcEvoTipsView", scmd)
						}
					}, 100)
					//this:AddUIEffect("ui_constellation_fail", "UI", this._gp_effs, null, null)
					//this:AddUIEffect("ui_constellation_jinjie", this._gp_effs, null, null, null, null,() => {
					//}
					//)
				} else {
					//this.AddUIEffect("ui_constellation_fail", "UI", this._gp_effs)
					Message.show("进化失败")
					return
				}

				//PlayBigEffect("ui_jinshengchenggong")
				//this.AddUIEffect("ui_jinshengchenggong", this._gp_effs,{x:0,y:0},2,false)
			})

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
					if (basic.subtype == 12) {
						this.UpdateCostItem(this._cost_list)
						break
					}
				}
			}
			)
			this.BindEvent(this._model, chcModel.SELECT_VIEW, () => {
				this.SetDefRatio()
			}
			)
		}

		this.LoadSuccess = () => {
			resMgr.SetOutsideImageSprite(this, this._img_tips, GameResPath.GetIcon("chc", "uixzsy_049"), true)
			//resMgr.SetOutsideImageSprite(this, this._img_004, GameResPath.GetIcon("chc", "uiqhjm_004"))
			this._citem_list = []
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
					}
					let type_id = goodsModel.GetMappingTypeId(vo[0], vo[1])[0]
					let own = goodsModel.GetTypeGoodsNum(type_id)
					let enough = own >= Number(vo[2])
					// [ts2lua]lua中0和空字符串也是true，此处own >= vo[2]需要确认
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
				if (this.use_delete_method) {
					return
				}
				this._show_item.SetData(data.type_id)
				this._show_item.SetStarEquipStar(data.color, data.star)
			}
			)
			let edata = this._model.GetDataByPos(this._type, this._stype, data.cell)

			let lv = (edata && (edata.lv) || (0))
			let scfg = this.cfg_evolu
			let ccfg = scfg[this._stype + "@" + data.cell + "@" + lv]
			this._def_ratio = (ccfg && (ccfg.rate) || (0))
			this.SetDefRatio()
			let cattr = JSON.parse(ccfg.attr)
			let ncfg = scfg[this._stype + "@" + data.cell + "@" + (lv + 1)]
			let nattr = (ncfg && (JSON.parse(ncfg.attr)) || (null))
			this.UpdateAttrData(cattr, nattr, lv)
			//let kvcfg = Config.Constellationforgekv //resMgr:GetGameConfigFromCache(this, "config_constellation_forge_kv", false)
			let color = 2 //kvcfg[4].value
			let can_evo = data.color >= color && (edata && edata.attr_num >= 2)
			let is_max = !ncfg
			if (can_evo) {
				let cost_list = JSON.parse(ccfg.cost)
				this.UpdateCostItem(cost_list)
				this._cost_list = cost_list
			} else {
				this._cost_list = null
			}
			this._lb_cost_max.visible = is_max
			this._gp_cost_show.visible = !is_max
			this._btn_go.visible = !is_max && can_evo
			this._img_cant.visible = !can_evo
			this._img_tips.visible = !can_evo
			this._gp_cost_title.visible = can_evo
			this._Image1.visible = can_evo
			this._gp_tips.visible = can_evo
			this._gp_attr_cur.visible = can_evo
			this._gp_attr_next.visible = can_evo && !is_max
			this._img_arrow.visible = can_evo
			this.UpdateRed()
		}

		this.UpdateAttrData = (clist?, nlist?, lv?) => {
			this._lb_stren_cur.text = "+" + lv
			let str = this._model.GetAttrStr(clist, "'#d15e00'")
			this._lb_attr_cur.innerHTML = str
			this._lb_attr_cur.width = 180
			this._img_lv_max.visible = !nlist
			this._gp_attr_next.visible = !(!nlist)
			if (nlist) {
				this._lb_stren_next.text = "+" + ((lv + 1))
				str = this._model.GetAttrStr(nlist, Enum_ColorUtil_Dark.GREEN)
				this._lb_attr_next.innerHTML = str
				this._lb_attr_next.width = 180
			}
		}

		this.StartFailAni = () => {
			SetAnchoredPositionY(this._img_fail, 450)
			//this._img_fail.y =
			this._img_fail.visible = true
			this._img_fail.alpha = 1
			//Laya.Tween.removeTweens(this._img_fail)
			//Laya.Tween.get(this._img_fail):to({y=300}, 1000):wait(200):to({alpha=0}, 800).call(() => {
			//this._img_fail.visible = false 
			//}
			//)

			this.tween_id = SYTweenLite.to(this, this._img_fail, SYTweenLite.UiAnimationType.POSY, 300, 1, () => {
				this.waitid = setTimeout(() => {
					if (!this.use_delete_method) {
						this.tween_id = SYTweenLite.to(this, this._img_fail, SYTweenLite.UiAnimationType.ALPHA, 0, 0.8)
						this._img_fail.visible = false
					}
				}, 200)
			})
		}

		this.UpdateRed = () => {
			if (!this._cur_data) {
				return
			}
			this._reddot.visible = this._model.GetReddotOne(this._type, this._stype, this._cur_data.cell)
		}

		this.SetDefRatio = () => {
			this._mtrl_dic = {}
			this._lb_ratio.text = this._def_ratio / 100 + "%"
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
		StarEquipModel.waitShowMaster = null
		//if (this._img_fail ) {
		//Laya.Tween.removeTweens(this._img_fail)
		//}
		super.DeleteMe()
	}

	public ReOpen_callback() {
		//this.AddUIEffect("ui_constellation_array", "UI", this._gp_eff, null, null, true)
	}

	_btn_help: Laya.Image
	_img_arrow: Laya.Image
	_img_lv_max: Laya.Image
	_Image1: Laya.Image
	_lb_tips1: Laya.Label
	_img_tips: Laya.Image
	_lb_cost_max: Laya.Label
	_gp_tips: Laya.Box
	_Label1: Laya.Label
	_Image2: Laya.Image
	_Label2: Laya.Label
	_Group1: Laya.Box
	_btn_attr: Laya.Image
	_gp_cost_title: Laya.Box
	_Image3: Laya.Image
	_lb_tips: Laya.Label
	_gp_cost_show: Laya.Box
	_Image5: Laya.Image
	_btn_select: Laya.Image
	_lb_ratio: Laya.Label
	_Scroller1: Laya.Panel
	_gp_cost: Laya.HBox
	_gp_attr_cur: Laya.Box
	_Image6: Laya.Image
	_lb_stren_cur: Laya.Label
	_lb_attr_cur: Laya.HTMLDivElement
	_lb_tips2: Laya.Label
	_gp_attr_next: Laya.Box
	_Image8: Laya.Image
	_lb_stren_next: Laya.Label
	_lb_attr_next: Laya.HTMLDivElement
	_lb_tips3: Laya.Label
	_img_fail: Laya.Image
	_btn_go: Laya.Box
	_Image10: Laya.Image
	_Label3: Laya.Label
	_reddot: Laya.Image
	_gp_item: Laya.Box
	_gp_show: Laya.Box
	_img_cant: Laya.Image
	_gp_effs: Laya.Box
	_gp_eff: Laya.Box
	public GetComponents() {
		[
			this._btn_help,
			this._img_arrow,
			this._img_lv_max,
			this._Image1,
			this._lb_tips1,
			this._img_tips,
			this._lb_cost_max,
			this._gp_tips,
			this._Label1,
			this._Image2,
			this._Label2,
			this._Group1,
			this._btn_attr,
			this._gp_cost_title,
			this._Image3,
			this._lb_tips,
			this._gp_cost_show,
			this._Image5,
			this._btn_select,
			this._lb_ratio,
			this._Scroller1,
			this._gp_cost,
			this._gp_attr_cur,
			this._Image6,
			this._lb_stren_cur,
			this._lb_attr_cur,
			this._lb_tips2,
			this._gp_attr_next,
			this._Image8,
			this._lb_stren_next,
			this._lb_attr_next,
			this._lb_tips3,
			this._img_fail,
			this._btn_go,
			this._Image10,
			this._Label3,
			this._reddot,
			this._gp_item,
			this._gp_show,
			this._img_cant,
			this._gp_effs,
			this._gp_eff,
		]
			= this.GetChildrenByNames([

				"_btn_help",
				"_img_arrow",
				"_img_lv_max",
				"_Image1",
				"_lb_tips1",
				"_img_tips",
				"_lb_cost_max",
				"_gp_tips",
				"_Label1",
				"_Image2",
				"_Label2",
				"_Group1",
				"_btn_attr",
				"_gp_cost_title",
				"_Image3",
				"_lb_tips",
				"_gp_cost_show",
				"_Image5",
				"_btn_select",
				"_lb_ratio",
				"_Scroller1",
				"_gp_cost",
				"_gp_attr_cur",
				"_Image6",
				"_lb_stren_cur",
				"_lb_attr_cur",
				"_lb_tips2",
				"_gp_attr_next",
				"_Image8",
				"_lb_stren_next",
				"_lb_attr_next",
				"_lb_tips3",
				"_img_fail",
				"_btn_go",
				"_Image10",
				"_Label3",
				"_reddot",
				"_gp_item",
				"_gp_show",
				"_img_cant",
				"_gp_effs",
				"_gp_eff",
			])
	}
}
window["chcEvoView"] = chcEvoView