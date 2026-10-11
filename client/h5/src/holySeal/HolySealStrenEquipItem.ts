import { BaseItem1 } from "../common/BaseItem1"
import { ResManager } from "../common/ResManager"
import { WordManager } from "../common/WordManager"
import { GoodsModel } from "../commonModel/GoodsModel"
import { HolySealModel } from "../commonModel/HolySealModel"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"
import { HolySealView } from "./HolySealView"

export class HolySealStrenEquipItem extends BaseItem1 {
	data
	need_refresh_data
	data_cache
	pos
	model: HolySealModel
	res_mgr:ResManager
	cache_select

	effect_obj: Laya.Sprite3D
	effect_cache = false

	public constructor(parent) {
		super(parent)
		this.base_file = "holySeal"
		this.layout_file = "HolySealStrenEquipItem"
		this.model = HolySealModel.GetInstance()
		this.res_mgr = ResManager.GetInstance()
		this.load_callback = function () {
			this.LoadSuccess()
			this.InitEvent()
		}
	}

	LoadSuccess() {
		if (this.need_refresh_data) {
			this.UpdateView()
			this.need_refresh_data = false
		}
		if(this.cache_select){
			this.SetSelcetImg(this.cache_select)
			this.cache_select = undefined
		}


		this.AddUIEffect("QiangHua", this.group_eff, null, 4, null, null, null, (obj) => {
			this.effect_obj = obj
			if (!this.effect_cache) {
				this.effect_obj.active = false
			} else {
				this.effect_cache = false
			}
		}, null, null, null, null, false)
	}

	InitEvent() {
		Util.AddClickEvent(this._gp_con, () => {
			this.call_back && this.call_back(this.pos)
		}, this, true)

		this.BindEvent(this.model, HolySealModel.STREN_SUCCESS, (equip_type) => {
			let sub_type = HolySealView.GetEquipTypeByPos(this.pos)
			if (equip_type == sub_type) {
				this.UpdateStren()
			}
		})

		this.BindEvent(GoodsModel.GetInstance(), GoodsModel.UPDATE_SPECIAL_SCORE, (vo) => {
			if (vo.currency_id == HolySealModel.MONEY_TYPE) {
				this.UpdateStren()
			}
		})


		this.BindEvent(this.model, HolySealModel.PLAY_END_EFFECT, (pos) => {
			if (this.pos == pos) {
				if (this.effect_obj) {
					this.effect_obj.active = false
					this.effect_obj.active = true
				} else {
					this.effect_cache = true
				}
			}
		})
	}

	SetData(data) {
		this.data = data
		if (this.is_loaded) {
			this.UpdateView()
		}
		else {
			this.need_refresh_data = true
		}
	}

	UpdateView() {
		let type_id = this.data.type_id
		if (type_id == 0) {
			this._img_red.visible = this._gp_stage.visible = this._lb_stren.visible = false
			this.res_mgr.SetImageSprite(this, this._img_bg, "holySeal", `bg_${this.model.GetEquipBgbByType(this.data.equip_type)}_0`)
			this.res_mgr.SetImageSprite(this, this._img_icon, "holySeal", `base_${this.data.equip_type}`)
		}
		else {
			let goods_basic = GoodsModel.GetInstance().GetGoodsBasicByTypeId(type_id)
			if (goods_basic) {

				this.res_mgr.SetImageSprite(this, this._img_bg, "holySeal", `bg_${this.model.GetEquipBgbByType(this.data.cell)}_${goods_basic.color}`)
				this.UpdateStren()

				this.res_mgr.SetTexture(this, this._img_icon, GameResPath.GetGoodsIconPath(goods_basic.goods_icon))

				this._lb_stren.visible = this._gp_stage.visible = true

				let config_seal_equip = this.res_mgr.GetGameConfigFromCache(this, "config_seal_equip", false)
				let equip_data = this.model.GetHolySealData(type_id, config_seal_equip)

				this._lb_stage.text = `${WordManager.ConvertNum(equip_data.stage)}阶`

				this._lb_stage.strokeColor = this.model.GetStage2StrokeColor(equip_data.color)

				this.res_mgr.SetImageSprite(this, this._img_stage_bg, "common_asset", this.model.GetStage2BgSource(equip_data.color))

			}
		}
	}

	UpdateStren() {	
		let sub_type = HolySealView.GetEquipTypeByPos(this.pos)
		let stren_lv = this.model.GetHolySealStrenDate(sub_type)
		this._lb_stren.text = `+${stren_lv}`
		let config_seal_equip = this.res_mgr.GetGameConfigFromCache(this, "config_seal_equip", false)
		let equip_data = this.model.GetHolySealData(this.data.type_id, config_seal_equip)

		let red_state = false
		let max_stren
		if (equip_data) {
			max_stren = equip_data.strong
		}
		let seal_strong_cfgs = this.res_mgr.GetGameConfigFromCache(this, "config_seal_strong", false)
		let next_cfg = this.model.GetHolySealStrenCfg(sub_type, stren_lv + 1, seal_strong_cfgs)

		if (max_stren && max_stren > stren_lv && next_cfg) {
			let cost = next_cfg.cost
			let value = 0
			if (cost != "[]") {
				cost = JSON.parse(cost)
				value = cost && cost[0] && cost[0][2]
			}
			let have = GoodsModel.GetInstance().GetSpecialScore(HolySealModel.MONEY_TYPE)
			red_state = have >= value
		}
		this._img_red.visible = red_state
	}

	private call_back
	SetClickCallBackAndPos(call_back, pos) {
		this.call_back = call_back
		this.pos = pos
	}

	SetSelcetImg(image: Laya.Image) {
		if (this.is_loaded) {
			if(image){
				this._gp_selcet.addChild(image)
				//根据选中图片算的
				image.x = image.y = -9
			}
		}
		else
		{
			this.cache_select = image
		}
	}

	DeleteMe(){

		if (this.effect_obj) {
			this.effect_obj.destroy()
		}
		this.effect_cache = false

		this.cache_select = undefined
		super.DeleteMe()
	}

_gp_con:Laya.Box
_img_bg:Laya.Image
_img_icon:Laya.Image
_gp_selcet:Laya.Box
_gp_stage:Laya.Box
_img_stage_bg:Laya.Image
_lb_stage:Laya.Label
_lb_stren:Laya.Label
_img_red:Laya.Image
group_eff:Laya.Box
public GetComponents() {
[
this._gp_con,
this._img_bg,
this._img_icon,
this._gp_selcet,
this._gp_stage,
this._img_stage_bg,
this._lb_stage,
this._lb_stren,
this._img_red,
this.group_eff,
]
 = this.GetChildrenByNames([

"_gp_con",
"_img_bg",
"_img_icon",
"_gp_selcet",
"_gp_stage",
"_img_stage_bg",
"_lb_stage",
"_lb_stren",
"_img_red",
"group_eff",
])
}
}
 window["HolySealStrenEquipItem"]= HolySealStrenEquipItem