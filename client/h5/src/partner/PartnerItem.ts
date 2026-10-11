import { BaseItem1 } from "../common/BaseItem1";
import { BaseItemRenderer } from "../common/BaseItemRenderer";
import { Enum_UILayer } from "../common/LayerManager";
import { ResManager } from "../common/ResManager";
import { GoodsModel } from "../commonModel/GoodsModel";
import { Util } from "../util/Util";
import { PartnerModel } from "../commonModel/PartnerModel";
import { GameResPath } from "../util/GameResPath";
import { PlatformManager } from "../PlatformManager";


export class PartnerItem extends BaseItemRenderer {
	bg: Laya.Image
	icon: Laya.Image
	bg_1: Laya.Image
	img_stage: Laya.Image
	effect_stage: Laya.Box
	name_res: Laya.Label
	select: Laya.Image
	red: Laya.Image
	fighting: Laya.Image
	stage_res: Laya.Label
	unactive: Laya.Image
	icon_mask

	model

	public constructor() {
		super()
		this.base_file = "partner"
		this.layout_file = "PartnerItem"
		this.WIDTH=114
		this.HEIGT=139
		// this.skinName = "resource/game/partner/exml/PartnerItemExml.exml"
		this.model = PartnerModel.GetInstance()
		this.Load()
	}

	public createChildren() {
		super.createChildren()
	}

	public load_callback(){
		if (PlatformManager.IsEyouEnPlatform()) {
			this.name_res.width = 103
			this.name_res.height = 37
			this.name_res.centerX = 1
			this.name_res.centerY = 57
			this.name_res.align = "center"
			this.name_res.valign = "middle"
			this.name_res.leading = 0.1
			this.name_res.wordWrap = true
		}
		this.BindEvent(this.model, PartnerModel.UPDATE_VIEW, (scmd_id?, scmd?) => {
			if (scmd_id == 14201 && scmd.companion_id != this.data.id) {
				if (this.fighting.visible) { //激活时，自动出战激活的伙伴
					this.RefFighting()
				}
				return
			}
			this.dataChanged()
		})

		this.BindEvent(this.model, PartnerModel.UPDATE_UP_ACT, () => {
			this.RefRed()
		})

		this.BindEvent(this.model, PartnerModel.UPDATE_BIOG_RED, () => {
			this.RefRed()
		})
	}
	public dataChanged() {
		if(!super.dataChanged()){
			return
		}
		if (!this.data) {
			return
		}
		let info = this.model.GetInfoByID(this.data.id)
		let cfg = this.data

		if (!info || !cfg) { return }
		//名称
		this.name_res.text = cfg.name
		let bool = info.is_active == 0
		//未激活置灰
		Util.SetImageGray(this.icon, bool)
		//未激活标签
		this.unactive.visible = bool
		//显示阶数
		this.stage_res.visible = !bool
		if (!bool) {
			this.stage_res.text = info.stage + "阶"
		}
		//选中框
		this.select.visible = this.selected
		//颜色标签
		let goods_basic = GoodsModel.GetInstance().GetGoodsBasicByTypeId(cfg.goods_id)

		let bg_res = "uihb_012"
		let imgstage_res = "uihb_007"
		if (goods_basic) {
			if (goods_basic.color == 4) {
				bg_res = "uihb_013"
				imgstage_res = "uihb_008"
			} else if (goods_basic.color == 5) {
				bg_res = "uihb_014"
				imgstage_res = "uihb_009"
			} else if (goods_basic.color == 7) {
				bg_res = "uihb_015"
				imgstage_res = "uihb_010"
				/*
				imgstage_res = null
				let data = {
					mask_id = this.mask_id,
					mask_corners = this.mask_corners,
					custom_sorting_order = this.curr_sorting_order,
					load_call_back =(go?) => {
						let renders = go.GetComponentsInChildren(typeof (UnityEngine.Renderer))
						for (let i = 0; i < renders.Length; i++) {
							let mesh = renders[i]
							let materials = mesh.sharedMaterials
							if (materials.Length > 0) {
								for (let j = 0; j < materials.Length; j++) {
									let material = materials[j]
									if (material) {
										//特殊处理
										if (material.shader.name == "Custom/mb_add_mask_mask") {
											material.renderQueue = 3001
										}
									}
								}
							}
						}
					}
				}
				this.AddUIEffect("UI_partner_card", this.layer_value, this.effect_stage, null, null, true, data)
				this.CoverEffect(this.red, this.layer_value, this.curr_sorting_order)
				*/
			}
			this.bg.skin = GameResPath.GetIcon("partner", `${bg_res}a`)// `partner_json.${bg_res}a_png`
			this.bg_1.skin = GameResPath.GetIcon("partner", `${bg_res}b`)// `partner_json.${bg_res}b_png`
			if (imgstage_res) {
				this.img_stage.skin = GameResPath.GetIcon("partner", `${imgstage_res}`)// `partner_json.${imgstage_res}_png`
				this.img_stage.visible = true
				// this.ClearUIEffect(this.effect_stage)
			} else {
				this.img_stage.visible = false
			}
			this.icon.skin = GameResPath.GetIcon("partner", `${cfg.figure_id}`)
			// ResManager.GetInstance().SetTexture(this, this.icon, GameResPath.GetIcon("partner", cfg.figure_id))
			// this.icon.mask=this.icon_mask
		}
		this.RefFighting()
		this.RefRed()
	}

	//出战标志
	public RefFighting() {
		if (!this.data) { return }
		let _info = this.model.GetInfo()
		let bool1 = _info && _info.fight_id == this.data.id
		this.fighting.visible = bool1
	}

	//红点
	public RefRed() {
		if (!this.data) { return }
		let status = this.model.GetRed(this.data.id)||this.model.CheckCompanionRed(this.data.id)
		this.red.visible = status
	}


	public GetComponents() {
		[
			this.bg,
			this.icon,
			this.bg_1,
			this.img_stage,
			this.effect_stage,
			this.name_res,
			this.select,
			this.red,
			this.fighting,
			this.stage_res,
			this.unactive,
			this.icon_mask
		]
			= this.GetChildrenByNames([

				"bg",
				"icon",
				"bg_1",
				"img_stage",
				"effect_stage",
				"name_res",
				"select",
				"red",
				"fighting",
				"stage_res",
				"unactive",
				"icon_mask"
			])
	}
}
window["PartnerItem"] = PartnerItem