import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { Util } from "../util/Util"
import { table } from "../common/table"
import { HolySealModel } from "../commonModel/HolySealModel"
import { longlangModel } from "../commonModel/longlangModel"
import { UIToolTipMgr } from "../common/UIToolTipMgr"
import { ResManager } from "../common/ResManager"
import { WordManager } from "../common/WordManager"
import { GoodsModel } from "../commonModel/GoodsModel"
import { LonglangToolTips } from "../common/LonglangToolTips"

export class longlangBagItem extends BaseItemRenderer {
	WIDTH = 88.9
	HEIGT = 88.9

	equip_cfg
	goods_basic
	holyseal
	model

	public constructor() {
		super()
		this.base_file = "holySeal"
		this.layout_file = "HolySealBagItem"

		this.holyseal = HolySealModel.GetInstance()
		this.model = longlangModel.GetInstance()

		this.load_callback = () => {
			this.display_obj.height = 85
			this.display_obj.width = 85
			this._gp_con.height = 85
			this._gp_con.width = 85
			this._img_bg.height = 85
			this._img_bg.width = 85
			this.display_obj.scaleX = 1.045
			this.display_obj.scaleY = 1.045
			// this.cache_order = this.AddCurrLayerSortingOrder("UI")
			this.LoadSuccess()
		}
		this.Load()
	}

	public LoadSuccess() {
		Util.AddClickEvent(this._gp_con, () => {
			if (this.goods_basic) {
				if (this.goods_basic.type == longlangModel.GOODS_TYPE) {
					let show_btn_list = [LonglangToolTips.Btn.replace]
					if (this.goods_basic.color >= 6 || this.goods_basic.subtype > 6 && (this.goods_basic.color == 5 || this.goods_basic.color == 4 && this.data.stage > 3)) {
						table.insert(show_btn_list, LonglangToolTips.Btn.dismantle)
					}
					if (this.data.bind != 1 && this.data.trade == 1) {
						table.insert(show_btn_list, LonglangToolTips.Btn.upShelf)
					}
					UIToolTipMgr.GetInstance().AppendLongLangToolTips(this.data.type_id, this.data, null, show_btn_list)
				} else {
					UIToolTipMgr.GetInstance().AppendGoodsTips(this.goods_basic.type_id, null, null, null, 1)
				}
			}
		}, this, true)

		this.equip_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_draconic_equip", false)
		this._img_stage_bg.visible = false
	}

	public dataChanged() {
		if(!super.dataChanged()){
			return
		}
		if (this.data) {
			let goods_basic = null
			let type_id = this.data.type_id
			let up = 0
			if (type_id == 0) {
				ResManager.GetInstance().SetImageSprite(this, this._img_bg, "common", "com_goods_plate_0")
				this._gp_effect.visible = false
				this._gp_stage.visible = false
				this._img_icon.visible = false
				this._img_bind.visible = false
				this._lb_count.text = ""
			} else {
				goods_basic = GoodsModel.GetInstance().GetGoodsBasicByTypeId(type_id)
				if (goods_basic) {
					let url = "com_goods_plate_" + goods_basic.color
					ResManager.GetInstance().SetImageSprite(this, this._img_bg, "common", url)
					ResManager.GetInstance().SetOutsideImageSprite(this, this._img_icon, "resource/game/goodsIcon/" + goods_basic.goods_icon + ".png")
					this._img_bind.visible = this.data.bind == 1
					if (this.data.type == longlangModel.GOODS_TYPE) {
						let equip = this.model.GetWearEquipByPos(this.data.subtype)
						if (!equip) {
							up = 2
						} else if (this.data.rating > equip.rating) {
							if (this.model.CanGetSuit(this.data)) {
								up = 2
							} else {
								up = 1
							}
						}
					} else {
						this._gp_effect.visible = false
					}
					this._lb_count.text = this.data.goods_num > 1 && this.data.goods_num || ""
					this._img_icon.visible = true
					let bool = goods_basic.type == longlangModel.GOODS_TYPE
					this._gp_stage.visible = bool
					if (bool && this.equip_cfg) {
						let equip_data = this.equip_cfg[type_id]
						if (equip_data) {
							this._lb_stage.text = WordManager.ConvertNum(equip_data.stage) + "阶"
							ResManager.GetInstance().SetImageSprite(this, this._img_stage_bg, "common", this.holyseal.GetStage2BgSource(goods_basic.color))
							this._img_stage_bg.visible = true
						}
					}
				}
			}
			this._gp_effect.visible = false
			this._img_up.visible = false
			this.ClearE()
			if (up) {
				if (up == 2 && this._gp_effect) {
					this._gp_effect.visible = true
					this._img_up.visible = true
					//this:AddUIEffect("ui_Seals_frame", this._gp_effect, false, false, true)
				}
			}
			if ((goods_basic && goods_basic.effect_id)) { this.SetBoxEffect(goods_basic.effect_id) }
			this.goods_basic = goods_basic
		}
	}

	public ClearE() {
		if (this._gp_effect) {
			// this.ClearUIEffect(this._gp_effect)
		}
		this.ClearBoxEffect()
	}

	public SetBoxEffect(effect_id?) {
		this.ClearBoxEffect()
		//if (! this.box_effect_group ) {
		//this.box_effect_group = eui. new Group()
		//this.box_effect_group.horizontalCenter = 0
		//this.box_effect_group.verticalCenter = 0
		//this:addChild(this.box_effect_group)
		//}
		let effect_str = ""
		if (effect_id == 1004) {
			effect_str = "UI_1304_1"
		} else if (effect_id == 1005) {
			effect_str = "UI_1305_1"
		} else if (effect_id == 1006) {
			effect_str = "UI_1306"
		} else if (effect_id == 1007) {
			effect_str = "UI_1307"
		} else if (effect_id == 1008) {
			effect_str = "ui_1309"
		}
		// this.AddUIEffect(effect_str, "UI", this.box_effect_group, null, null, true, { mask_id = 1, custom_sorting_order = this.cache_order })

		//this:AddUIEffect("ui_goods_" + effect_id, this.box_effect_group, null, 0.68, true)
		//this:AddUIEffect("UI_2008", this.layer_value, this._con_effect, null, null, true, {load_call_back =() => {
		//this:CoverEffect(this.showTitleImage)
		//this:CoverEffect(this._img_show)
		//}})
	}

	public ClearBoxEffect() {
		// if (this.box_effect_group) {
		// 	this.ClearUIEffect(this.box_effect_group)
		// }
	}

	public DeleteMe() {
		this.ClearE()
		super.DeleteMe()
	}

	_gp_con: Laya.Box
	_img_bg: Laya.Image
	_img_icon: Laya.Image
	_gp_stage: Laya.Box
	_img_stage_bg: Laya.Image
	_lb_stage: Laya.Label
	_gp_effect: Laya.Box
	_img_bind: Laya.Image
	_lb_count: Laya.Label
	_gp_effect2: Laya.Box
	_img_up: Laya.Image
	public GetComponents() {
		[
			this._gp_con,
			this._img_bg,
			this._img_icon,
			this._gp_stage,
			this._img_stage_bg,
			this._lb_stage,
			this._gp_effect,
			this._img_bind,
			this._lb_count,
			this._gp_effect2,
			this._img_up,
		]
			= this.GetChildrenByNames([
				"_gp_con",
				"_img_bg",
				"_img_icon",
				"_gp_stage",
				"_img_stage_bg",
				"_lb_stage",
				"_gp_effect",
				"_img_bind",
				"_lb_count",
				"_gp_effect2",
				"_img_up",
			])
	}
}
window["longlangBagItem"] = longlangBagItem