import { BaseItem1 } from "../common/BaseItem1"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { HolySealToolTips } from "../common/HolySealToolTips"
import { ResManager } from "../common/ResManager"
import { UIToolTipMgr } from "../common/UIToolTipMgr"
import { WordManager } from "../common/WordManager"
import { GoodsModel } from "../commonModel/GoodsModel"
import { HolySealModel } from "../commonModel/HolySealModel"
import { ColorUtil } from "../util/ColorUtil"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"

export class HolySealBagItem extends BaseItemRenderer {
	public WIDTH = 99 //86 + 13
	public HEIGT = 99

	goods_basic
	model

	public constructor() {
		super()
		this.base_file = "holySeal"
		this.layout_file = "HolySealBagItem"
		this.model = HolySealModel.GetInstance()
		this.load_callback = () => {
			this.LoadSuccess()
		}
		this.Load()
	}

	public LoadSuccess() {
		Util.AddClickEvent(this._gp_con, () => {
			if (this.goods_basic) {
				if (this.goods_basic.type == HolySealModel.GOODS_TYPE) {
					let show_btn_list = [HolySealToolTips.Btn.replace]
					if (this.goods_basic.color > 5) { //and this.goods_basic.subtype != 11
						show_btn_list.push(HolySealToolTips.Btn.dismantle)

					}
					if (this.data.bind != 1 && this.data.trade == 1) {
						show_btn_list.push(HolySealToolTips.Btn.upShelf)
					}
					UIToolTipMgr.GetInstance().AppendHolySealTips(this.data.type_id, this.data, null, show_btn_list)
				} else {
					UIToolTipMgr.GetInstance().AppendGoodsTips(this.goods_basic.type_id, null, null, null, 1)
				}
			}
		}, this, true)
	}

	protected dataChanged() {
		if (super.dataChanged()) {
			let goods_basic = null
			let type_id = this.data.type_id
			if (type_id == 0) {
				ResManager.GetInstance().SetImageSprite(this, this._img_bg, "common_asset", "com_goods_plate_0")
				this._gp_effect.visible = false
				this._gp_stage.visible = false
				this._img_icon.visible = false
				this._img_bind.visible = false
				this._img_up.visible = false
				this._lb_count.text = ""
			} else {
				goods_basic = GoodsModel.GetInstance().GetGoodsBasicByTypeId(type_id)
				if (goods_basic) {
					this._img_bg.skin = undefined
					ResManager.GetInstance().SetImageSprite(this, this._img_bg, "common_asset", `com_goods_plate_${goods_basic.color}`)
					ResManager.GetInstance().SetOutsideImageSprite(this, this._img_icon, GameResPath.GetGoodsIconPath(goods_basic.goods_icon))
					this._img_bind.visible = this.data.bind == 1
					if (this.data.type == HolySealModel.GOODS_TYPE) {
						let equip = this.model.GetWearEquipByPos(this.data.subtype)
						let bool = false
						let config_seal_equip = ResManager.GetInstance().GetGameConfigFromCache(this.base_item, "config_seal_equip", false)
						if (equip && this.data.color == 3 && equip.color > 3) {
							let equip_data = this.model.GetHolySealData(equip.type_id, config_seal_equip)
							let now_data = this.model.GetHolySealData(this.data.type_id, config_seal_equip)
							if (equip_data && now_data && now_data.stage - equip_data.stage > 5) {
								bool = true
							}
						} else {
							if (!equip || this.data.rating > equip.rating) {
								bool = true
							}
						}
						this._gp_effect.visible = bool
						this._img_up.visible = bool
						if (bool) {
							// ResManager.GetInstance().SetUIEffect(this,"ui_1138",this.layer_value,this._gp_effect,Vector3(0,20,0),null,true,{mask_id = 1})
							// this.AddUIEffect2("ui_1138", this._gp_effect, false, false, true)
						}
						else {
							this._img_up.visible = false
						}
					} else {
						this._img_up.visible = false
						this._gp_effect.visible = false
					}
					this._lb_count.text = this.data.goods_num > 1 && this.data.goods_num || ""
					this._img_icon.visible = true
					let bool = goods_basic.type == HolySealModel.GOODS_TYPE
					this._gp_stage.visible = bool
					if (bool) {
						let config_seal_equip = ResManager.GetInstance().GetGameConfigFromCache(this.base_item, "config_seal_equip", false)
						let equip_data = this.model.GetHolySealData(type_id, config_seal_equip)
						if (equip_data) {
							this._lb_stage.text = WordManager.ConvertNum(equip_data.stage) + "阶"
							this._lb_stage.strokeColor = this.model.GetStage2StrokeColor(goods_basic.color)
							ResManager.GetInstance().SetImageSprite(this, this._img_stage_bg, "common_asset", this.model.GetStage2BgSource(goods_basic.color), true)
						}
					}
				}
			}
			this.goods_basic = goods_basic
		}
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
window["HolySealBagItem"] = HolySealBagItem