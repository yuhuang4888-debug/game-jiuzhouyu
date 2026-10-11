import { BaseItem1 } from "../common/BaseItem1"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { GameResPath } from "../util/GameResPath"

export class LoginSelectServerTabItem extends BaseItemRenderer {

	WIDTH = 180
	HEIGT = 72

	public constructor() {
		super()
		this.base_file = "login"
		this.layout_file = "LoginSelectServerTabItem"
		this.load_callback = () => {

		}
		this.Load()
	}


	public dataChanged() {
		if (!super.dataChanged()) return
		this._lb_name.text = this.data.name
		if (this.data.size) {
			this._lb_name.fontSize = this.data.size
		} else {
			this._lb_name.fontSize = 24
		}
		this.UpdateSelect()
	}

	public UpdateSelect() {

		if (this.selected) {
			this._img_bg.skin = GameResPath.GetIcon("login", "ui_Login_21")
			this._lb_name.color = "#663915"
		} else {
			this._img_bg.skin = GameResPath.GetIcon("login", "ui_Login_22")
			this._lb_name.color = "#6773a5"
		}
	}

	_img_bg: Laya.Image
	_lb_name: Laya.Label
	public GetComponents() {
		[
			this._img_bg,
			this._lb_name,
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_lb_name",
			])
	}
}
window["LoginSelectServerTabItem"] = LoginSelectServerTabItem