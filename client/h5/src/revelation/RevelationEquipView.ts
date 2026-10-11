import { BaseItem1 } from "../common/BaseItem1"
import { SetAnchoredPosition, Util } from "../util/Util"
import { OpenFun } from "../common/OpenFun"
import { ResManager } from "../common/ResManager"
import { GameResPath } from "../util/GameResPath"
import { GoodsModel } from "../commonModel/GoodsModel"
import { CompositeModel } from "../commonModel/CompositeModel"
import { RedDotManager, ModuleType } from "../common/RedDotManager"
import { LoopScrowViewMgr, LoopScrCon } from "../common/LoopScrowViewMgr"
import { FightingShowSmallItem } from "../common/FightingShowSmallItem"
import { RevelationModel, RevelationEvent } from "../commonModel/RevelationModel"
import { Revelation1EquipItem } from "./Revelation1EquipItem"
import { RevelationBagItem } from "./RevelationBagItem"
import "./RevelationAttrView"
import "./RevelationSuitView"
import "./RevelationActiveView"
import "./RevelationDevourView"

export class RevelationEquipView extends BaseItem1 {
	model
	red_mgr
	goods_model
	comp_model

	bag_list
	pos_list
	fight
	wait_time
	equip_items
	bag_loop_mgr

	cover_effect_cache_sort_order
	effect_cache_sort_order

	public constructor(parent?) {
		super(parent)
		this.base_file = "revelation"
		this.layout_file = "RevelationEquipView"

		this.model = RevelationModel.GetInstance()
		this.red_mgr = RedDotManager.GetInstance()
		this.goods_model = GoodsModel.GetInstance()
		this.comp_model = CompositeModel.GetInstance()

		this.bag_list = null
		this.equip_items = []
		this.pos_list = [
			{ x: 90, y: 270 },
			{ x: 310, y: 46 },
			{ x: 310, y: 490 },
			{ x: 310, y: 204 },
			{ x: 310, y: 333 },
			{ x: 200, y: 157 },
			{ x: 420, y: 157 },
			{ x: 420, y: 380 },
			{ x: 200, y: 380 },
			{ x: 532, y: 270 }
		]

		this.load_callback = () => {
			ResManager.GetInstance().SetOutsideImageSprite(this, this.img_bg, GameResPath.GetIcon("revelation", "ui_Apocalypse_01"))
			this.InitView()
			this.InitEvent()
		}
	}

	private InitEvent() {
		let getRed = this.red_mgr.GetRedStatus(ModuleType.REVE_DEVOUR_RED)
		this.devourRed.visible = (getRed && getRed > 0 || this.model.skillRed)

		Util.AddClickEvent(this.propBtn, () => {
			this.model.Fire(RevelationEvent.OPEN_VIEW, "RevelationAttrView")
		}, this, true)

		Util.AddClickEvent(this.suitBtn, () => {
			this.model.Fire(RevelationEvent.OPEN_VIEW, "RevelationSuitView")
		}, this, true)

		Util.AddClickEvent(this.getBtn, () => {
			OpenFun.OpenFunHandler(136)
		}, this, true)

		Util.AddClickEvent(this.comBtn, () => {
			this.comp_model.Fire(CompositeModel.OPEN_COMPOSITE_VIEW, CompositeModel.Index.Revelation, 137)
		}, this, true)

		Util.AddClickEvent(this.soulBtn, () => {
			this.model.Fire(RevelationEvent.OPEN_VIEW, "RevelationDevourView")
		}, this, true)

		this.BindEvent(this.goods_model, GoodsModel.CHANGE_REVE_BAG_LIST, () => {
			this.RefreshBag()
		})

		this.BindEvent(this.goods_model, GoodsModel.CHANGE_REVE_EQUIP_LIST, (list?) => {
			if (list) {
				for (let _tmpi in list) {
					var vo = list[_tmpi]
					let item = null
					if (!vo.equip_type) {
						let goodsBasic = this.goods_model.GetGoodsBasicByTypeId(vo.type_id)
						if (goodsBasic) {
							item = this.equip_items[goodsBasic.equip_type]
							item.SetData({ type_id: 0, equip_type: goodsBasic.equip_type })
						}
					} else {
						item = this.equip_items[vo.equip_type]
						item.SetData(this.model.GetWearEquipByPos(vo.equip_type))
					}
				}
			} else {
				for (let _tmpi in RevelationModel.PosIndex) {
					var vo1 = RevelationModel.PosIndex[_tmpi]
					let item = this.equip_items[vo1]
					item.SetData(this.model.GetWearEquipByPos(vo1))
				}
			}
			this.RefreshBag()
		})

		let devourRed = () => {
			let getRed = this.red_mgr.GetRedStatus(ModuleType.REVE_DEVOUR_RED)
			this.devourRed.visible = (getRed && getRed > 0 || this.model.skillRed)
		}
		this.BindVar(this.model, "skillRed", devourRed)
		this.BindEvent(this.model, RevelationEvent.UPDATE_DEVOUR_RED, devourRed)

		this.BindEvent(this.model, RevelationEvent.UPDATE_EQUIP_DATA, () => {
			if (!this.fight){
				return
			}
			this.fight.Updatefighting(this.model.equipData.power || 0)
		})

		
		this.BindVar(this.comp_model, "revelation_red_dot", () => {
			this.comRed.visible = this.comp_model.GetRevelationRedDot()
		})
		

		this.BindEvent(this.model, RevelationEvent.UPDATE_POWER, () => {
			this.fight.Updatefighting(this.model.equipData.power || 0)
		})
	}

	private InitView() {
		/*
		this.RegisterMask(this.bag_loop_mgr)
		this.effect_cache_sort_order = this.AddCurrLayerSortingOrder("UI")
		this.AddUIEffect("UI_1302b", "UI", this.effectGp1, null, null, true, { custom_sorting_order = this.effect_cache_sort_order })
		this.cover_effect_cache_sort_order = this.AddCurrLayerSortingOrder("UI")
		this.CoverEffect(this._Image3, "UI", this.cover_effect_cache_sort_order)
		this.CoverEffect(this._Image12, "UI", this.cover_effect_cache_sort_order)
		*/

		for (let _tmpi in RevelationModel.PosIndex) {
			let vo = RevelationModel.PosIndex[_tmpi]
			let item = new Revelation1EquipItem(this.equipGp)
			item.Load()
			//item.SetBaseCove(this.cover_effect_cache_sort_order)
			item.ExcuteCallback(() => {
				let data = this.model.GetWearEquipByPos(vo) || { type_id: 0, equip_type: vo }
				item.SetData(data)
				SetAnchoredPosition(item.display_obj, this.pos_list[vo-1].x - 3 , this.pos_list[vo-1].y - 3)
			})
			this.equip_items[vo] = item
		}

		this.bag_list = this.model.GetBagFullList()
		if (!this.bag_loop_mgr) {
			this.bag_loop_mgr = new LoopScrowViewMgr()
			this.bag_loop_mgr.SetData(this.gp_bag, RevelationBagItem, this.bag_list, LoopScrCon.Vertical)
		}

		if (!this.fight) {
			this.fight = new FightingShowSmallItem(this.gp_fight)
			this.fight.Load()
		}
		this.fight.Updatefighting(this.model.equipData.power || 0)

		this.comRed.visible = this.comp_model.GetRevelationRedDot()
		//ResManager.GetInstance().SetOutsideImageSprite(this, this._Image2, GameResPath.GetIcon("revelation", "uirwv4_007"))
		//this:AddUIEffect("ui_Apocalypse_icon_wenli", this.effectGp2, null, null, true)
	}

	private RefreshBag(force?) {
		if (force) {
			this.bag_loop_mgr.replaceAll(this.model.GetBagFullList())
		} else {
			if (this.wait_time) {
				clearTimeout(this.wait_time)
			}
			this.wait_time = setTimeout(() => {
				this.bag_loop_mgr.replaceAll(this.model.GetBagFullList())
				this.wait_time = null
			}, 0.1)
		}
	}

	public SetVisible(state?) {
		if (state) {
			this.model.Fire(RevelationEvent.REQUEST_PROTO, 28609)
		}
		super.SetVisible(state)
	}

	public DeleteMe() {
		for (let key in this.equip_items) {
			this.equip_items[key].DeleteMe()
			this.equip_items[key] = null
		}
		if (this.fight) {
			this.fight.DeleteMe()
			this.fight = null
		}
		if (this.bag_loop_mgr) {
			this.bag_loop_mgr.DeleteMe()
			this.bag_loop_mgr = null
		}
		if (this.wait_time) {
			clearTimeout(this.wait_time)
			this.wait_time = null
		}
		
		super.DeleteMe()
	}

	public ReOpen_callback() {
		//this.AddUIEffect("UI_1302b", "UI", this.effectGp1, null, null, true, { custom_sorting_order = this.effect_cache_sort_order })
		//this.CoverEffect(this._Image3, "UI", this.cover_effect_cache_sort_order)
		//this.CoverEffect(this._Image12, "UI", this.cover_effect_cache_sort_order)
	}

	img_bg: Laya.Image
	img_line1: Laya.Image
	img_line2: Laya.Image
	effectGp1: Laya.Box
	effectGp2: Laya.Box
	gp_bag: Laya.List
	suitBtn: Laya.Image
	getBtn: Laya.Image
	comBtn: Laya.Image
	comRed: Laya.Image
	soulBtn: Laya.Image
	devourRed: Laya.Image
	propBtn: Laya.Image
	_Image3: Laya.Image
	_Image4: Laya.Image
	_Image5: Laya.Image
	_Image6: Laya.Image
	_Image7: Laya.Image
	_Image8: Laya.Image
	_Image9: Laya.Image
	_Image10: Laya.Image
	_Image11: Laya.Image
	_Image12: Laya.Image
	equipGp: Laya.Box
	gp_fight: Laya.Box
	public GetComponents() {
		[
			this.img_bg,
			this.img_line1,
			this.img_line2,
			this.effectGp1,
			this.effectGp2,
			this.gp_bag,
			this.suitBtn,
			this.getBtn,
			this.comBtn,
			this.comRed,
			this.soulBtn,
			this.devourRed,
			this.propBtn,
			this._Image3,
			this._Image4,
			this._Image5,
			this._Image6,
			this._Image7,
			this._Image8,
			this._Image9,
			this._Image10,
			this._Image11,
			this._Image12,
			this.equipGp,
			this.gp_fight,
		]
			= this.GetChildrenByNames([

				"img_bg",
				"img_line1",
				"img_line2",
				"effectGp1",
				"effectGp2",
				"gp_bag",
				"suitBtn",
				"getBtn",
				"comBtn",
				"comRed",
				"soulBtn",
				"devourRed",
				"propBtn",
				"_Image3",
				"_Image4",
				"_Image5",
				"_Image6",
				"_Image7",
				"_Image8",
				"_Image9",
				"_Image10",
				"_Image11",
				"_Image12",
				"equipGp",
				"gp_fight",
			])
	}
}
window["RevelationEquipView"] = RevelationEquipView