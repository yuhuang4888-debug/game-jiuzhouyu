import { BaseItem1 } from "../common/BaseItem1"
import { SetAnchoredPosition, SetSizeDelta, Util } from "../util/Util"
import { ResManager } from "../common/ResManager"
import { WordManager } from "../common/WordManager"
import { GoodsModel } from "../commonModel/GoodsModel"
import { HolySealModel } from "../commonModel/HolySealModel"
import { longlangModel } from "../commonModel/longlangModel"

export class longlangStrItem extends BaseItem1 {
	InitEvent
	SetClickCallBackAndPos
	SetData
	SetSelcetImg
	UpdateStren
	UpdateView

	call_back
	data
	model
	need_refresh_data
	pos
	cache_select = false
	cfg_draconic_equip
	cfg_draconic_strong

	public constructor(parent?) {
		super(parent)
		this.base_file = "longlanguage"
		this.layout_file = "longlangStrItem"
		this.preload_server_config = {
			"config_draconic_equip": false,
			"config_draconic_strong": false
		}

		this.model = longlangModel.GetInstance()

		this.load_callback = () => {
			this.cfg_draconic_equip = ResManager.GetInstance().GetGameConfigFromCache(this, "config_draconic_equip", false)
			this.cfg_draconic_strong = ResManager.GetInstance().GetGameConfigFromCache(this, "config_draconic_strong", false)
			this.LoadSuccess()
			this.InitEvent()
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this._gp_con, () => {
				if (this.call_back) { this.call_back(this.pos) }
			}, this, true)

			this.BindEvent(this.model, longlangModel.EQUIP_STR_INFO, (pos_id?) => {
				if (pos_id == this.pos) {
					this.UpdateStren()
				}
			})

			this.BindEvent(GoodsModel.GetInstance(), GoodsModel.UPDATE_SPECIAL_SCORE, (vo?) => {
				if (vo.currency_id == longlangModel.MONEY_TYPE) {
					this.UpdateStren()
				}
			})
		}

		this.SetData = (data?) => {
			this.data = data
			if (this.is_loaded) {
				this.UpdateView()
			} else {
				this.need_refresh_data = true
			}
		}

		this.UpdateView = () => {
			let pos = this.data.subtype || this.data.equip_type
			// let iconScale = 1
			// let hCenter = 0
			// let effectPos = null
			let effectName = null
			if (pos == 11) {
				ResManager.GetInstance().SetImageSprite(this, this._img_bg, "longlanguage", "ui_seal_colour2_1", true)
				ResManager.GetInstance().SetImageSprite(this, this._img_select, "longlanguage", "com_select_circle")
				SetSizeDelta(this._img_select, 135, 135)
				SetAnchoredPosition(this._img_red, 72, -7)
				effectName = "UI_1303c"
				// effectPos = [x = -2, y = 4]
			} else if (pos < 7) {
				ResManager.GetInstance().SetImageSprite(this, this._img_bg, "longlanguage", "ui_ly_02", true)
				SetAnchoredPosition(this._img_red, 55, 0)
				// iconScale = 0.7
				// hCenter = 1
				// SetLocalScale(this.form, 0.9, 0.9, 1)
				// effectPos = [x = 2, y = 1]
				effectName = "UI_1303a"
			} else {
				ResManager.GetInstance().SetImageSprite(this, this._img_bg, "longlanguage", "ui_ly_01", true)
				SetAnchoredPosition(this._img_red, 65, 0)
				// iconScale = 0.75
				// hCenter = 0
				effectName = "UI_1303b"
			}
			let type_id = this.data.type_id
			if (type_id == 0) {
				this._lb_stren.visible = false
				this._gp_stage.visible = false
				this._img_red.visible = false
				ResManager.GetInstance().SetImageSprite(this, this._img_icon, "longlanguage", this.data.equip_type, true)
				// SetAnchoredPositionX(this._img_icon, 2)
				// if (pos == 11) {
				// 	SetLocalScale(this._img_icon, 1.5, 1.5, 1)
				// 	SetAnchoredPositionY(this._img_icon, -7)
				// } else {
				// 	SetLocalScale(this._img_icon, 1, 1, 1)
				// }
			} else {
				// SetLocalScale(this._img_icon, 0.94, 0.94, 1)
				// SetAnchoredPositionX(this._img_icon, hCenter)
				let goods_basic = GoodsModel.GetInstance().GetGoodsBasicByTypeId(type_id)
				if (goods_basic) {
					this.UpdateStren()
					ResManager.GetInstance().SetOutsideImageSprite(this, this._img_icon, "resource/game/goodsIcon/" + goods_basic.goods_icon + ".png", true)
					this._gp_stage.visible = true
					this._lb_stren.visible = true
					this._img_bg.visible = true
					let cfg = this.cfg_draconic_equip
					if (cfg) {
						let equip_data = cfg[type_id]
						this._lb_stage.text = WordManager.ConvertNum(equip_data.stage) + "阶"
						let holyseal = HolySealModel.GetInstance()
						let source = holyseal.GetStage2BgSource(equip_data.color)
						ResManager.GetInstance().SetImageSprite(this, this._img_stage_bg, "common", source, true)
					}
					if (goods_basic.color > 3) {
						this.AddUIEffect(effectName, this.effectGp, null, 10, true)
						if (pos == 11) {
							//this:AddUIEffect("ui_draconic_frame3_down", this.effect, null, null, true)
						}
					} else {
					}
				}
			}
		}

		this.UpdateStren = () => {
			let stren_lv = this.model.GetStrData(this.pos)
			this._lb_stren.text = "+" + stren_lv
			let cfg = this.cfg_draconic_equip
			let equip_data = cfg[this.data.type_id]
			let red_state = false
			let max_stren = null
			if (equip_data) {
				max_stren = equip_data.strong
			}
			let seal_strong_cfgs = this.cfg_draconic_strong
			let next_cfg = seal_strong_cfgs[this.pos + "@" + (stren_lv + 1)]
			if ((max_stren && max_stren > stren_lv) && next_cfg) {
				let cost = next_cfg.cost
				let value = 0
				if (cost != "[]") {
					cost = JSON.parse(cost)
					value = (cost && cost[0]) && cost[0][2]
				}
				let have = GoodsModel.GetInstance().GetSpecialScore(longlangModel.MONEY_TYPE)
				red_state = have >= Number(value)
			}
			this._img_red.visible = red_state
		}

		this.SetClickCallBackAndPos = (call_back?, pos?) => {
			this.call_back = call_back
			this.pos = pos
		}

		this.SetSelcetImg = (select) => {
			if (this.is_loaded) {
				this._img_select.visible = select
				// if (this.pos == 11) {
				// 	ResManager.GetInstance().SetImageSprite(this, image, "longlanguage_asset", "uily_005", true)
				// } else {
				// 	ResManager.GetInstance().SetImageSprite(this, image, "longlanguage_asset", "uily_006", true)
				// }
			} else {
				this.cache_select = select
			}
		}
	}

	public DeleteMe() {
		super.DeleteMe()
	}

	public LoadSuccess() {
		if (this.need_refresh_data) {
			this.UpdateView()
			this.need_refresh_data = false
		}
		this._img_select.visible = this.cache_select
	}

	_gp_con: Laya.Box
	_img_bg: Laya.Image
	_img_icon: Laya.Image
	effectGp: Laya.Box
	_img_select: Laya.Image
	_gp_stage: Laya.Box
	_img_stage_bg: Laya.Image
	_lb_stage: Laya.Label
	_lb_stren: Laya.Label
	_img_red: Laya.Image
	public GetComponents() {
		[
			this._gp_con,
			this._img_bg,
			this._img_icon,
			this.effectGp,
			this._img_select,
			this._gp_stage,
			this._img_stage_bg,
			this._lb_stage,
			this._lb_stren,
			this._img_red,
		]
			= this.GetChildrenByNames([

				"_gp_con",
				"_img_bg",
				"_img_icon",
				"effectGp",
				"_img_select",
				"_gp_stage",
				"_img_stage_bg",
				"_lb_stage",
				"_lb_stren",
				"_img_red",
			])
	}
}
window["longlangStrItem"] = longlangStrItem