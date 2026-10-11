import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { ResManager } from "../common/ResManager"
import { GodCourtModel } from "../commonModel/GodCourtModel"

export class GodCourtTabItem extends BaseItemRenderer {
	WIDTH = 158
    HEIGT = 68
	model

	public constructor() {
		super()
		this.base_file = "godCourt"
		this.layout_file = "GodCourtTabItem"

		this.model = GodCourtModel.GetInstance()

		this.load_callback = () => {
			let changeFunc = (scmd?) => {
				if (this.data && ((scmd && scmd.court_id == this.data.id) || scmd == "23308")) {
					this.dataChanged()
				}
			}
			this.BindEvent(this.model, GodCourtModel.UNLOCK, changeFunc)
			this.BindEvent(this.model, GodCourtModel.UPDATE_LVDATA, changeFunc)
			this.BindEvent(this.model, GodCourtModel.UPDATE_STREN_DATA, changeFunc)

			this.BindEvent(this.model, GodCourtModel.REFRESH_RED, () => {
				if (this.data) {
					this.redDot.visible = this.model.GetTabRed(this.data.id)
				}
			})
		}
		this.Load()
	}

	public dataChanged() {
		if (!super.dataChanged()) {
			return
		}

		this.nameLb.text = this.data.name
		let active = this.model.IsGodCourtActive(this.data.id)
		let Red = false
		if (active) {
			this.lockLb.color = "#ffffff"
			this.lockLb.fontSize = 24
			this.lockLb.text = "Lv." + this.model.GetData(this.data.id).court_lv
			Red = this.model.GetTabRed(this.data.id)
		} else {
			this.lockLb.color = "#ffd778"
			this.lockLb.fontSize = 18
			let condition = JSON.parse(this.data.condition)
			if (this.model.ConditionCheck(condition)) {
				this.lockLb.text = "可解锁"
				Red = true
			} else {
				this.lockLb.text = "神祈Lv." + condition[0][1] + "解锁"
			}
		}
		this.redDot.visible = Red
		
		if (this.selected) {
			ResManager.GetInstance().SetImageSprite(this, this._img_bg, "common4", "ui_btn_achv_highlight")
			this.nameLb.color = "#9b572f"
			this.lockLb.color = "#9b572f"
		} else {
			this.nameLb.color = "#ffffff"
			this.lockLb.color = active ? "#ffffff" : "#ffd778"
			ResManager.GetInstance().SetImageSprite(this, this._img_bg, "common4", "ui_btn_achv")
		}
	}

	public DeleteMe() {
		super.DeleteMe()
	}

	_img_bg: Laya.Image
	nameLb: Laya.Label
	lockLb: Laya.Label
	redDot: Laya.Image
	public GetComponents() {
		[
			this._img_bg,
			this.nameLb,
			this.lockLb,
			this.redDot,
		]
			= this.GetChildrenByNames([
				"_img_bg",
				"nameLb",
				"lockLb",
				"redDot",
			])
	}
}
window["GodCourtTabItem"] = GodCourtTabItem