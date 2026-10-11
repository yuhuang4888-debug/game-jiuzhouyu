import { BaseItem1 } from "../common/BaseItem1"
import { Util, SetAnchoredPositionX, PlayBigEffect } from "../util/Util"
import { ColorUtil } from "../util/ColorUtil"
import { Config } from "../common/Config"
import { table } from "../common/table"
import { GoodsModel } from "../commonModel/GoodsModel"
import { SYTweenLite } from "../util/SYTweenLite"
import { SYTweenFunc } from "../util/SYTweenFunc"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { EventName } from "../common/EventName"
import { UIToolTipMgr } from "../common/UIToolTipMgr"
import { MaterialsTool } from "../common/MaterialsTool"
import { ResManager } from "../common/ResManager"
import { GameResPath } from "../util/GameResPath"
import { EquipModel, EquipDefine, EquipEvent } from "../commonModel/EquipModel"
import { BaseAwardItem } from "../common/BaseAwardItem"
import { EquipRefineItem } from "./EquipRefineItem"
import { EquipRefiAttrsItem } from "./EquipRefiAttrsItem"

export class EquipRefinementView extends BaseItem1 {
	InitEquipList
	InitEvent
	LoadCallback
	LocalDeleteMe
	RefAttrs
	RefCost
	RefCostNum
	Scr_Scroller1
	ShowSelect
	//_gp_equips
	//_img_4
	cfg_refine

	public constructor(parent?) {
		super(parent)
		this.base_file = "equipRefinement"
		this.layout_file = "EquipRefinementView"
		this.preload_server_config = {
			"config_equip_refinement": false
		}

		let model = EquipModel.GetInstance()
		let local_goodsModel = GoodsModel.GetInstance()
		let local_EquipDefine = EquipDefine
		let equip_item_list = []
		let select_equip = null
		let cost_item = null
		let cost = null
		let extra_attr_item = null
		let now_lv_item = null
		let next_lv_item = null
		let equipRefinementMaxLv = 10

		this.load_callback = () => {
			//this.RegisterMask(this._gp_equips)
			this.cfg_refine = ResManager.GetInstance().GetGameConfigFromCache(this, "config_equip_refinement", false)
			this._Scroller1.hScrollBar.visible = false
			this.LoadCallback()
			this.InitEvent()
		}

		this.LoadCallback = () => {
			/*
			local_ResManager.SetOutsideImageSprite(this, this._img_0, GameResPath.GetIconJpg("equipRefinement", "uisl_001_720x1222"))
			local_ResManager.SetOutsideImageSprite(this, this._img_1, GameResPath.GetIcon("equipRefinement", "uisl_002"), true)
			local_ResManager.SetOutsideImageSprite(this, this._img_2, GameResPath.GetIcon("equipRefinement", "uisl_007"), true)
			local_ResManager.SetOutsideImageSprite(this, this._img_3, GameResPath.GetIcon("equipRefinement", "uisl_01"), true)
			local_ResManager.SetOutsideImageSprite(this, this._img_4, GameResPath.GetIcon("equipRefinement", "uisl_013"), true)
			*/

			//let y = -100
			SYTweenLite.to(this, this._img_equip, SYTweenLite.UiAnimationType.ANCHORED_POSY, 205, 2.5, null, SYTweenFunc.PINGPONG, true)

			//Laya.Tween.get(this._img_equip, {loop=true}):to({y=176}, 800):to({y=196}, 1600).to({y=186}, 800)
			//Laya.Tween.get(this._gp_huanrao, {loop=true}):to({y=176}, 800):to({y=196}, 1600).to({y=186}, 800)
			this.AddUIEffect("UI_1505", this._gp_huanrao, null, 2.2, true)
			this.InitEquipList()
			this.ShowSelect()
		}

		this.InitEvent = () => {
			this.BindEvent(local_goodsModel, GoodsModel.CHANGE_EQUIPLIST, () => {
				this.InitEquipList()
				this.ShowSelect()
			})

			this.BindVar(model, "equip_refinement_select", (event_name?, value?, old_value?) => {
				select_equip = value
				this.ShowSelect()
			})

			this.BindEvent(local_goodsModel, GoodsModel.CHANGE_BAG_LIST, (goods_list?) => {
				for (let _tmpi in goods_list) {
					let info = goods_list[_tmpi]
					if (local_EquipDefine.REFINEMENT_GOODS == info.type_id || local_EquipDefine.REFINEMENT_TWO_GOODS == info.type_id) {
						this.RefCostNum()
						break
					}
				}
			})

			this.BindEvent(model, EquipEvent.UPDATA_REFI_VIEW, (equip?) => {
				let equip_infos = model.GetWearEquipDynamics()
				if (!equip_infos || equip_infos.length == 0) {
					return
				}
				for (let _tmpi in equip_infos) {
					let vo = equip_infos[_tmpi]
					if (vo.equip_type == select_equip.equip_type) {
						select_equip = vo
						this.ShowSelect()
						break
					}
				}
				if (equip.equip_type == select_equip.equip_type) {
					this._gp_huanrao.visible = false
					SYTweenLite.to(this, this._img_equip, SYTweenLite.UiAnimationType.SCALE, { x: 1, y: 1, z: 1 }, 0.05, () => {
						SYTweenLite.to(this, this._img_equip, SYTweenLite.UiAnimationType.SCALE, { x: 2, y: 2, z: 2 }, 0.1, () => {
							SYTweenLite.to(this, this._img_equip, SYTweenLite.UiAnimationType.SCALE, { x: 1.3, y: 1.3, z: 1.3 }, 0.05)
						})
					})
					//Laya.Tween.get(this._img_equip):wait(150):to({scaleX=1, scaleY=1}, 50):to({scaleX=2, scaleY=2}, 100).to({scaleX=1.3, scaleY=1.3}, 50)
					this.AddUIEffect("UI_1506", this._gp_dazao, null, null, null)
					PlayBigEffect("ui_shenlianchenggong")
					setTimeout(() => {
						if (this.use_delete_method) {
							return
						}
						GlobalEventSystem.Fire(EventName.OPEN_VIEW, "EquipRefiUpLvView", equip)
					}, 0.75)
				}
			})

			Util.AddClickEvent(this._btn_refi, () => {
				if (!cost || !select_equip) {
					return
				}
				let type, lock = local_goodsModel.GetMappingTypeId(cost[1], cost[2])
				let have_num = local_goodsModel.GetTypeGoodsNum(type)
				if (have_num < Number(cost[3])) {
					MaterialsTool.GetInstance().materialsTips(type)
				} else {
					model.Fire(EquipEvent.REQUEST_PROTO, 15255, "l", select_equip.goods_id)
				}
			}, this, true)

			Util.AddClickEvent(this._img_equip, () => {
				if (!select_equip) {
					return
				}
				let goodsVo = local_goodsModel.GetEquipById(select_equip.goods_id)
				if (goodsVo) {
					UIToolTipMgr.GetInstance().AppendEquipTips(select_equip.type_id, null, null, goodsVo, null, [0])
				}
			}, this, false)

			/*
			Util.AddClickEvent(this._gp_instrcution, () => {
				this._gp_instrcution.visible = false
			}, this, false)
			*/

			Util.AddClickEvent(this.insBtn, () => {
				//this._gp_instrcution.visible = true
				GlobalEventSystem.Fire(EventName.OPEN_INSTRUCTION_VIEW, 15212)
			}, this, false)

			this.BindEvent(model, EquipEvent.CLOSE_REFIUP_VIEW, () => {
				this._gp_huanrao.visible = true
			})
		}

		this.RefAttrs = () => {
			if (!select_equip) {
				return
			}
			let extra_attr = select_equip.equip_extra_attr
			let lv = select_equip.refinement_lv
			let bool = equipRefinementMaxLv < lv + 1
			this._gp_arrow.visible = !bool
			this._gp_next_lv.visible = !bool
			if (bool) {
				SetAnchoredPositionX(this._gp_extra_attr, 100)
				SetAnchoredPositionX(this._gp_now_lv, 400)
			} else {
				SetAnchoredPositionX(this._gp_extra_attr, 68)
				SetAnchoredPositionX(this._gp_now_lv, 285)
				let suit_type = model.GetSuitType(select_equip.equip_type)
				let next_cfg = this.cfg_refine[(lv + 1) + "@" + suit_type]
				if (next_cfg) {
					this._bit_add.text = "+" + (next_cfg.promote / 100) + "%"
				}
			}
			if (!extra_attr_item) {
				extra_attr_item = new EquipRefiAttrsItem(this._gp_extra_attr)
				extra_attr_item.Load()
			}
			extra_attr_item.ExcuteCallback(() => {
				extra_attr_item.SetData(1, select_equip)
			}
			)
			if (!now_lv_item) {
				now_lv_item = new EquipRefiAttrsItem(this._gp_now_lv)
				now_lv_item.Load()
			}
			now_lv_item.ExcuteCallback(() => {
				now_lv_item.SetData(2, select_equip)
			}
			)
			if (!bool) {
				if (!next_lv_item) {
					next_lv_item = new EquipRefiAttrsItem(this._gp_next_lv)
					next_lv_item.Load()
				}
				next_lv_item.ExcuteCallback(() => {
					next_lv_item.SetData(2, select_equip, lv + 1)
				}
				)
			}
		}

		this.RefCostNum = () => {
			if (!cost) {
				return
			}
			let type = local_goodsModel.GetMappingTypeId(cost[0], cost[1])[0]
			let have_num = local_goodsModel.GetTypeGoodsNum(type)
			let costNum = Number(cost[2])
			let color = have_num >= costNum && "#1db641" || "#ff4f50"
			this._lb_cost_num.text = have_num + "/" + costNum
			this._lb_cost_num.color = ColorUtil.TryParseHtmlString(color)
			this._img_red.visible = have_num >= costNum
		}

		this.RefCost = () => {
			if (!select_equip) {
				return
			}
			let next_lv = select_equip.refinement_lv + 1
			let suit_type = model.GetSuitType(select_equip.equip_type)

			let next_cfg = this.cfg_refine[next_lv + "@" + suit_type]
			this._img_max.visible = !next_cfg
			//this._gp_cost.visible = next_cfg != null
			this._btn_refi.visible = next_cfg != null
			if (!next_cfg) {
				this._lb_cost_num.color = "#1db641"
				this._lb_cost_num.text = "无消耗"

				let now_cfg = this.cfg_refine[select_equip.refinement_lv + "@" + suit_type]
				let now_cost = now_cfg.cost_list
				if (now_cost) {
					now_cost = JSON.parse(now_cost)[0]
					if (!cost_item) {
						cost_item = new BaseAwardItem(this._gp_cost_goods)
						cost_item.Load()
						cost_item.SetItemSize(81, 81)
					}
					cost_item.ExcuteCallback(() => {
						let type = local_goodsModel.GetMappingTypeId(now_cost[0], now_cost[1])[0]
						cost_item.SetData(type, 0)
						let basic = local_goodsModel.GetGoodsBasicByTypeId(type)
						if (basic) {
							let color = ColorUtil.GetColorDark(basic.color, false)
							this._lb_cost_name.color = color
							this._lb_cost_name.text = basic.goods_name
						}
					})
				}
				return
			}
			if (next_cfg.cost_list) {
				let _cost = next_cfg.cost_list
				_cost = JSON.parse(_cost)[0]
				if (!cost_item) {
					cost_item = new BaseAwardItem(this._gp_cost_goods)
					cost_item.Load()
					cost_item.SetItemSize(81, 81)
				}
				cost_item.ExcuteCallback(() => {
					let type = local_goodsModel.GetMappingTypeId(_cost[0], _cost[1])[0]
					cost_item.SetData(type, 0)
					let basic = local_goodsModel.GetGoodsBasicByTypeId(type)
					if (basic) {
						let color = ColorUtil.GetColorDark(basic.color, false)
						this._lb_cost_name.color = color
						this._lb_cost_name.text = basic.goods_name
					}
				})
				cost = _cost
				this.RefCostNum()
			}
		}

		this.ShowSelect = () => {
			if (!select_equip) {
				return
			}
			let type_id = select_equip.type_id
			let goods_basic = local_goodsModel.GetGoodsBasicByTypeId(type_id)
			//Util.SetGoodsIcon(this, this._img_equip, type_id)
			ResManager.GetInstance().SetTexture(this, this._img_equip, GameResPath.GetGoodsIconPath(goods_basic.goods_icon))
			let extra_attr = select_equip.equip_extra_attr
			let is_color = false
			let c = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_equip_attr.name, type_id, false)
			let stage = c && c.stage
			let bool = extra_attr.length != 0 && (stage && stage >= local_EquipDefine.REFINEMENT_DIVISION)
			if (bool) {
				for (let _tmpi in extra_attr) {
					let v = extra_attr[_tmpi]
					if (v.color > 3) {
						is_color = true
						break
					}
				}
			}
			//this._img_4.visible = bool && is_color
			//this._gp_cost.visible = bool && is_color
			this._btn_refi.visible = bool && is_color
			this._gp_attr.visible = bool && is_color
			this._gp_notice.visible = !bool || !is_color
			this._gp_cost.visible = !this._gp_notice.visible
			this._img_max.visible = false
			if (bool && is_color) {
				this.RefCost()
				this.RefAttrs()
			} else if (stage < local_EquipDefine.REFINEMENT_DIVISION) {
				this.lb_notice.text = "当前装备低于9阶无法进行神炼\n请更换高阶装备"
				//ResManager.GetInstance().SetOutsideImageSprite(this, this.img_tips, GameResPath.GetIcon("equipRefinement", "uisl_018b"))
			} else {
				this.lb_notice.text = "当前装备品质较低无法进行神炼\n请更换更高品质装备"
				//ResManager.GetInstance().SetOutsideImageSprite(this, this.img_tips, GameResPath.GetIcon("equipRefinement", "uisl_018c"))
			}
		}

		this.InitEquipList = () => {
			let equip_infos = model.GetWearEquipDynamics()
			if (!equip_infos || equip_infos.length == 0) {
				return
			}
			table.sort(equip_infos, (a?, b?) => {
				return a.equip_type < b.equip_type
			})
			if (select_equip == null) {
				select_equip = equip_infos[0]
			}
			for (let i = 0; i < equip_infos.length; i++) {
				let v = equip_infos[i]
				let item = equip_item_list[i]
				if (!item) {
					item = new EquipRefineItem(this.Content)
					item.Load()
					equip_item_list[i] = item
				}
				item.ExcuteCallback(() => {
					if (select_equip.equip_type == v.equip_type && select_equip != v) {
						select_equip = v
					}
					item.SetData(v, select_equip.equip_type == v.equip_type)
				}
				)
			}
		}

		this.LocalDeleteMe = () => {
			if (equip_item_list.length > 0) {
				for (let _tmpi in equip_item_list) {
					let item = equip_item_list[_tmpi]
					item.DeleteMe()
				}
				equip_item_list = []
			}
			if (cost_item) {
				cost_item.DeleteMe()
				cost_item = null
			}
			if (extra_attr_item) {
				extra_attr_item.DeleteMe()
				extra_attr_item = null
			}
			if (now_lv_item) {
				now_lv_item.DeleteMe()
				now_lv_item = null
			}
			if (next_lv_item) {
				next_lv_item.DeleteMe()
				next_lv_item = null
			}
		}
	}

	public DeleteMe() {
		this.LocalDeleteMe()
		super.DeleteMe()
	}

	/*
	public ReOpen_callback() {
		this.AddUIEffect("UI_1505", "UI", this._gp_huanrao, null, 0.7, true)
	}
	*/

	_img_0: Laya.Image
	_img_1: Laya.Image
	_img_2: Laya.Image
	_Label1: Laya.Label
	_img_equip: Laya.Image
	_gp_attr: Laya.Box
	_gp_extra_attr: Laya.Box
	_gp_now_lv: Laya.Box
	_gp_arrow: Laya.Box
	_bit_add0: Laya.Label
	_Image3: Laya.Image
	_bit_add: Laya.Label
	_gp_next_lv: Laya.Box
	_gp_notice: Laya.Box
	_Image4: Laya.Image
	_img_notice: Laya.Image
	img_tips: Laya.Image
	lb_notice: Laya.Label
	_gp_cost: Laya.Box
	_Label2: Laya.Label
	_lb_cost_name: Laya.Label
	_lb_cost_num: Laya.Label
	_btn_refi: Laya.Box
	img_refi: Laya.Image
	lb_refi: Laya.Label
	_gp_cost_goods: Laya.Box
	_img_red: Laya.Image
	_Scroller1: Laya.Panel
	Content: Laya.HBox
	_img_max: Laya.Image
	_gp_huanrao: Laya.Box
	_gp_dazao: Laya.Box
	insBtn: Laya.Image
	_gp_instrcution: Laya.Box
	_Image5: Laya.Image
	_Label3: Laya.Label
	public GetComponents() {
		[
			this._img_0,
			this._img_1,
			this._img_2,
			this._Label1,
			this._img_equip,
			this._gp_attr,
			this._gp_extra_attr,
			this._gp_now_lv,
			this._gp_arrow,
			this._bit_add0,
			this._Image3,
			this._bit_add,
			this._gp_next_lv,
			this._gp_notice,
			this._Image4,
			this._img_notice,
			this.img_tips,
			this.lb_notice,
			this._gp_cost,
			this._Label2,
			this._lb_cost_name,
			this._lb_cost_num,
			this._btn_refi,
			this.img_refi,
			this.lb_refi,
			this._gp_cost_goods,
			this._img_red,
			this._Scroller1,
			this.Content,
			this._img_max,
			this._gp_huanrao,
			this._gp_dazao,
			this.insBtn,
			this._gp_instrcution,
			this._Image5,
			this._Label3,
		]
			= this.GetChildrenByNames([

				"_img_0",
				"_img_1",
				"_img_2",
				"_Label1",
				"_img_equip",
				"_gp_attr",
				"_gp_extra_attr",
				"_gp_now_lv",
				"_gp_arrow",
				"_bit_add0",
				"_Image3",
				"_bit_add",
				"_gp_next_lv",
				"_gp_notice",
				"_Image4",
				"_img_notice",
				"img_tips",
				"lb_notice",
				"_gp_cost",
				"_Label2",
				"_lb_cost_name",
				"_lb_cost_num",
				"_btn_refi",
				"img_refi",
				"lb_refi",
				"_gp_cost_goods",
				"_img_red",
				"_Scroller1",
				"Content",
				"_img_max",
				"_gp_huanrao",
				"_gp_dazao",
				"insBtn",
				"_gp_instrcution",
				"_Image5",
				"_Label3",
			])
	}
}
window["EquipRefinementView"] = EquipRefinementView