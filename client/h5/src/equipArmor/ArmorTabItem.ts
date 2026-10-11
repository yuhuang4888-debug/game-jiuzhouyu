import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { ArmorModel } from "../commonModel/ArmorModel"
import { Util } from "../util/Util"
import { ResManager } from "../common/ResManager"
import { WordManager } from "../common/WordManager"

export class ArmorTabItem extends BaseItemRenderer {
	model
	res_mgr
	select
	need_refresh = false
	armour_cfg
	is_first = true

	WIDTH = 158
	HEIGT = 68

	public constructor() {
		super()
		this.base_file = "equipArmor"
		this.layout_file = "ArmorTabItem"

		this.model = ArmorModel.GetInstance()
		this.res_mgr = ResManager.GetInstance()

		this.select = false

		this.load_callback = () => {
			this.armour_cfg = this.res_mgr.GetGameConfigFromCache(this, "config_armour_equipment", false)

			this.InitEvent()

			if (this.need_refresh) {
				this.need_refresh = false
				this.dataChanged()
			}
		}
		this.Load()
	}

	public InitEvent() {
		this.BindEvent(this.model, ArmorModel.UPDATE_SELECT_TAB, (stage?) => {
			if (!this.data) {
				return
			}
			this.select = this.data.stage == stage
			this.UpdateSelect()
		})

		this.BindEvent(this.model, ArmorModel.UPDATE_RED, () => {
			if (!this.data) {
				return
			}
			if (!this.data.lock) {
				this._img_red.visible = this.model.CheckStageRed(this.data.stage, this.armour_cfg)
			} else {
				this._img_red.visible = false
			}
		})
	}

	public dataChanged() {
		if (!this.is_loaded) {
			this.need_refresh = true
			return
		}
		if (this.data.lock) {
			this._lb_name.text = this.data.tips
			this._img_red.visible = false
		} else {
			this._lb_name.text = WordManager.NumConvertStage(this.data.stage) + "阶"
			this._img_red.visible = this.model.CheckStageRed(this.data.stage, this.armour_cfg)
			if (this.is_first){
				this.is_first = false
				this.select = this.selected
			}
		}
		this.UpdateSelect()
		this._img_final.visible = this.data.status
	}

	private UpdateSelect() {
		if (this.data.lock){
			this.select = false
		}
		let icon = this.select ? "uizj_002" : "uizj_001"
		this.res_mgr.SetImageSprite(this, this._img_bg, "equipArmor", icon)
		this._lb_name.color = this.select ? "#9b572f" : "#ffffff"
	}

	gp_con: Laya.Box
	_img_bg: Laya.Image
	_lb_name: Laya.Label
	_img_final: Laya.Image
	_img_red: Laya.Image
	public GetComponents() {
		[
			this.gp_con,
			this._img_bg,
			this._lb_name,
			this._img_final,
			this._img_red,
		]
			= this.GetChildrenByNames([
				"gp_con",
				"_img_bg",
				"_lb_name",
				"_img_final",
				"_img_red",
			])
	}
}
window["ArmorTabItem"] = ArmorTabItem