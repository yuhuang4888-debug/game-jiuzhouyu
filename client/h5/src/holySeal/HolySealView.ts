import { BaseItem1 } from "../common/BaseItem1"
import { EventName } from "../common/EventName"
import { InstructionType } from "../common/InstructionType"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { GoodsModel } from "../commonModel/GoodsModel"
import { HolySealModel } from "../commonModel/HolySealModel"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"
import { CompositeModel } from "../commonModel/CompositeModel"
import { HolySealBagItem } from "../holySeal/HolySealBagItem"
import { HolySealEquipItem } from "../holySeal/HolySealEquipItem"
import { CommonManager } from "../common/CommonManager"

import "../holySeal/HolySealAttrView"
import "../holySeal/HolySealDecomposeView"
import "../holySeal/HolySealDismantleView"
import "../holySeal/HolySealStrenView"
import "../holySeal/HolySealSuitPreviewView"
import "../holySeal/HolySealTipsView"
import "../holySeal/HolySoulView"
import { OpenFun } from "../common/OpenFun"
import { KfHolyAreaModel } from "../commonModel/KfHolyAreaModel"
import { ServerTimeModel } from "../serverTime/ServerTimeModel"
import { PlatformManager } from "../PlatformManager"

export class HolySealView extends BaseItem1 {

	static GetEquipTypeByPos(pos) {
		return ({
			[1]: 6,
			[2]: 5,
			[3]: 4,
			[4]: 3,
			[5]: 2,
			[6]: 1,
			[7]: 7,
			[8]: 8,
			[9]: 9,
			[10]: 10,
			[11]: 11
		})[pos]
	}

	goods_model
	holy_seal_model

	equip_list
	refresh_bag_id

	bag_loop_mgr: LoopScrowViewMgr
	res_mgr: ResManager

	public constructor(parent?) {
		super(parent)
		this.base_file = "holySeal"
		this.layout_file = "HolySealView"
		this.holy_seal_model = HolySealModel.GetInstance()
		this.goods_model = GoodsModel.GetInstance()
		this.res_mgr = ResManager.GetInstance()

		this.load_callback = () => {
			this.LoadSuccess()
		}
	}

	LoadSuccess() {
		if(PlatformManager.IsEyouThPlatform()){
			this._img_stren.autoSize = true
			this._img_composite.autoSize = true
			this._img_decompose.autoSize = true
			this._img_preview.width = 108
			this._img_preview.height = 82
			this._img_preview.pos(-9,0)
		}
		this.res_mgr.SetOutsideImageSprite(this, this._img_bg, GameResPath.GetIcon("holySeal", "ui_seal_01"))
		this.res_mgr.SetOutsideImageSprite(this, this._img_line_1, GameResPath.GetIcon("holySeal", "com_line_1"))

		this.UpdateView()
		this.InitEvent()
		this.holy_seal_model.Fire(HolySealModel.REQUEST_CCMD_EVENT, 65407)

		this._lb_fighting.fontSize = 24
		ResManager.GetInstance().LoadFont(this, "fighting_font", this._lb_fighting)
	}


	InitEvent() {
		Util.AddClickEvent(this._btn_holy, ()=> {
			let [kf, msg] = KfHolyAreaModel.GetInstance().GetOpenState()
			if (kf){
				OpenFun.OpenFunHandler(99)
			} else {
				let cfg = CommonManager.GetInstance().GetFunctionIconCfg(283)
				if (cfg) {
					let open_day = ServerTimeModel.GetInstance().GetOpenServerDay()
					if(open_day > cfg.open_day && open_day <= cfg.max_open_day) {
						OpenFun.OpenFunHandler(88)
					}
				}
			}
		}, this, true)

		Util.AddClickEvent(this._img_attr, () => {
			GlobalEventSystem.Fire(EventName.OPEN_VIEW, "HolySealAttrView")
		}, this, true)

		Util.AddClickEvent(this._img_tips, () => {
			GlobalEventSystem.Fire(EventName.OPEN_INSTRUCTION_VIEW, InstructionType.HolySeal)
			//GlobalEventSystem:Fire(EventName.OPEN_VIEW, "HolySealTipsView", InstructionType.HolySeal)
		}, this, true)

		Util.AddClickEvent(this._gp_composite, () => {
			CompositeModel.GetInstance().Fire(CompositeModel.OPEN_COMPOSITE_VIEW, CompositeModel.Index.HolySeal, 84)
		}, this, true)

		Util.AddClickEvent(this._gp_decompose, () => {
			GlobalEventSystem.Fire(EventName.OPEN_VIEW, "HolySealDecomposeView")
		}, this, true)

		Util.AddClickEvent(this._gp_preview, () => {
			GlobalEventSystem.Fire(EventName.OPEN_VIEW, "HolySealSuitPreviewView")
		}, this, true)

		Util.AddClickEvent(this._gp_soul, () => {
			GlobalEventSystem.Fire(EventName.OPEN_VIEW, "HolySoulView")
		}, this, true)

		Util.AddClickEvent(this._gp_stren, () => {
			GlobalEventSystem.Fire(EventName.OPEN_VIEW, "HolySealStrenView")
		}, this, true)

		this.BindEvent(this.goods_model, GoodsModel.CHANGE_HOLY_SEAL_BAG_LIST, () => {
			this.TryUpdateBag()
		})

		this.BindEvent(this.goods_model, GoodsModel.CHANGE_HOLY_SEAL_LIST, () => {
			this.holy_seal_model.Fire(HolySealModel.REQUEST_CCMD_EVENT, 65407)
			this.UpdateEquip()
			this.TryUpdateBag()
			this.UpdateEffect()
		})

		this.BindEvent(this.holy_seal_model, HolySealModel.REFRESH_RED_FLAG, (flag?) => {
			switch (flag) {
				case HolySealModel.RedFlag.Stren:
					this.UpdateStrenRed()
					break
				case HolySealModel.RedFlag.Decompose:
					this.UpdateDecomposeRed()
					break
				case HolySealModel.RedFlag.Composite:
					this.UpdateCompositeRed()
					break
				case HolySealModel.RedFlag.Soul:
					this.UpdateSoulRed()
					break
			}
		})

		this.BindVar(this.holy_seal_model, "total_rating", () => {
			this.UpdateTotalSorce()
		})
	}

	UpdateView() {
		this.TryUpdateBag()
		if (!this.equip_list) {
			this.equip_list = {}
		}
		let item = null
		let i = 1
		do {
			item = new HolySealEquipItem(this._gp_equips)
			item.Load()
			this.equip_list[i] = item
			let pos = this.GetPos(i - 1)
			item.SetPosition(pos.x, pos.y)
			i = i + 1
		} while ((i <= HolySealModel.EQUIP_COUNT))

		this.UpdateEquip()
		this.UpdateEffect()
		this.UpdateStrenRed()
		this.UpdateDecomposeRed()
		this.UpdateCompositeRed()
		this.UpdateSoulRed()
		this.UpdateTotalSorce()
	}

	UpdateStrenRed() {
		let bool = this.holy_seal_model.HasRedFlag(HolySealModel.RedFlag.Stren)
		this._img_stren_red.visible = bool
	}

	UpdateDecomposeRed() {
		this._img_decompose_red.visible = this.holy_seal_model.HasRedFlag(HolySealModel.RedFlag.Decompose)
	}

	UpdateCompositeRed() {
		this._img_composite_red.visible = this.holy_seal_model.HasRedFlag(HolySealModel.RedFlag.Composite)
	}

	UpdateSoulRed() {
		this._img_soul_red.visible = this.holy_seal_model.HasRedFlag(HolySealModel.RedFlag.Soul)
	}

	DeleteMe() {
		if (this.equip_list) {
			for (let _tmpi in this.equip_list) {
				var obj = this.equip_list[_tmpi]
				obj.DeleteMe()
			}
			this.equip_list = false
		}

		if (this.bag_loop_mgr) {
			this.bag_loop_mgr.DeleteMe()
			this.bag_loop_mgr = undefined
		}

		super.DeleteMe()
	}

	UpdateBag() {
		let config_seal_kv = this.res_mgr.GetGameConfigFromCache(this, "config_seal_kv", false)
		let list = this.holy_seal_model.GetHolySealBagList(config_seal_kv)
		if (this.bag_loop_mgr) {
			this.bag_loop_mgr.replaceAll(list)
		}
		else {
			this.bag_loop_mgr = new LoopScrowViewMgr()
			this.bag_loop_mgr.SetData(this._list_bag, HolySealBagItem, list, LoopScrCon.Vertical)
		}
	}

	TryUpdateBag() {
		if (this.refresh_bag_id) {
			return
		}

		this.refresh_bag_id = setTimeout(() => {
			this.refresh_bag_id = false
			if (this.use_delete_method) { return }
			this.UpdateBag()
		}, 0.2)
	}

	UpdateEquip() {
		let list = this.goods_model.wear_holy_seal_list
		let i = 1
		let equip
		let sub_type
		do {
			sub_type = HolySealView.GetEquipTypeByPos(i)
			equip = list[sub_type - 1]
			if (!equip) {
				equip = { equip_type: sub_type, type_id: 0 }
			}
			this.equip_list[i].SetData(equip)
			i++
		} while ((i <= HolySealModel.EQUIP_COUNT))
	}

	UpdateTotalSorce() {
		this._lb_fighting.text = String(this.holy_seal_model.total_rating)
	}

	UpdateEffect() {
		// let data = {
		// 	load_call_back =() => {
		// 		let curr_sorting_order = this.AddCurrLayerSortingOrder(this.layer_value)
		// 		this.CoverEffect(this._gp_con,this.layer_value,curr_sorting_order)
		// 		this.CoverEffect(this._gp_equips,this.layer_value,curr_sorting_order)
		// 	}
		// }
		// let list = this.goods_model.wear_holy_seal_list
		// let bool = true
		// let i = 1
		// do {
		// 	if (! list[i] ) {
		// 		bool = false
		// 		break
		// 	}
		// 	i = i + 1
		// } while ((i < 7))
		// if (bool ) {
		// 	this.res_mgr.SetUIEffect(this,"UI_1301_big",this.layer_value,this._gp_effect,null,null,true,data)
		// 	// this.AddUIEffect2("ui_Seals_circle1", this._gp_effect, false, {x = 1.5, y = 1.5}, true)
		// }else{
		// 	this.res_mgr.ClearParentUIEffect(this,this._gp_effect)
		// }

		// bool = true
		// let i = 7
		// do {
		// 	if (! list[i] ) {
		// 		bool = false
		// 		break
		// 	}
		// 	i = i + 1

		// } while ((i < 11))
		// if (bool ) {
		// 	this.res_mgr.SetUIEffect(this,"UI_1301_mid",this.layer_value,this._gp_effect0,null,null,true,data)
		// 	this.res_mgr.SetUIEffect(this,"UI_1301_small",this.layer_value,this._gp_effect1,null,null,true,data)
		// 	// this.AddUIEffect2("ui_Seals_circle2", this._gp_effect0, false, false, true)
		// 	// this.AddUIEffect2("ui_Seals_rune", this._gp_effect1, false, false, true)
		// }else{
		// 	this.res_mgr.ClearParentUIEffect(this,this._gp_effect0)
		// 	this.res_mgr.ClearParentUIEffect(this,this._gp_effect1)
		// 	// this.ClearUIEffect(this._gp_effect0)
		// 	// this.ClearUIEffect(this._gp_effect1)
		// }
		// bool = true
		// if (! list[11] ) {
		// 	bool = false
		// }
		// if (bool ) {
		// 	this.res_mgr.SetUIEffect(this,"UI_1308",this.layer_value,this._gp_effect2,null,null,true,data)
		// }else{
		// 	this.res_mgr.ClearParentUIEffect(this,this._gp_effect2)
		// }
	}

	GetPos(index?) {
		return ([
			//外圈 右到左
			{ x: 479, y: 117 },
			{ x: 348, y: 41 },
			{ x: 199, y: 68 },
			{ x: 101, y: 184 },
			{ x: 101, y: 335 },
			{ x: 199, y: 452 },
			//内圈 上左下右
			{ x: 374, y: 202 },
			{ x: 254, y: 324 },
			{ x: 374, y: 444 },
			{ x: 494, y: 324 },
			//中间

			{ x: 374, y: 324 }])[index]
	}

	_img_bg: Laya.Image
	_img_bg2: Laya.Image
	_img_line_1: Laya.Image
	_img_line_2: Laya.Image
	_btn_holy: Laya.Image
	_img_attr: Laya.Image
	img2: Laya.Image
	img1: Laya.Image
	_img_tips: Laya.Image
	_lb_fighting: Laya.Label
	_gp_equips: Laya.Box
	_list_bag: Laya.List
	_gp_stren: Laya.Box
	_img_stren: Laya.Image
	_img_stren_red: Laya.Image
	_gp_preview: Laya.Box
	_img_preview: Laya.Image
	_img_preview_red: Laya.Image
	_gp_decompose: Laya.Box
	_img_decompose: Laya.Image
	_img_decompose_red: Laya.Image
	_gp_composite: Laya.Box
	_img_composite: Laya.Image
	_img_composite_red: Laya.Image
	_gp_soul: Laya.Box
	_img_soul: Laya.Image
	_img_soul_red: Laya.Image
	public GetComponents() {
		[
			this._img_bg,
			this._img_bg2,
			this._img_line_1,
			this._img_line_2,
			this._btn_holy,
			this._img_attr,
			this.img2,
			this.img1,
			this._img_tips,
			this._lb_fighting,
			this._gp_equips,
			this._list_bag,
			this._gp_stren,
			this._img_stren,
			this._img_stren_red,
			this._gp_preview,
			this._img_preview,
			this._img_preview_red,
			this._gp_decompose,
			this._img_decompose,
			this._img_decompose_red,
			this._gp_composite,
			this._img_composite,
			this._img_composite_red,
			this._gp_soul,
			this._img_soul,
			this._img_soul_red,
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_img_bg2",
				"_img_line_1",
				"_img_line_2",
				"_btn_holy",
				"_img_attr",
				"img2",
				"img1",
				"_img_tips",
				"_lb_fighting",
				"_gp_equips",
				"_list_bag",
				"_gp_stren",
				"_img_stren",
				"_img_stren_red",
				"_gp_preview",
				"_img_preview",
				"_img_preview_red",
				"_gp_decompose",
				"_img_decompose",
				"_img_decompose_red",
				"_gp_composite",
				"_img_composite",
				"_img_composite_red",
				"_gp_soul",
				"_img_soul",
				"_img_soul_red",
			])
	}
}
window["HolySealView"] = HolySealView