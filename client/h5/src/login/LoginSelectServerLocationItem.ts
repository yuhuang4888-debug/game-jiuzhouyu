import { BaseItem1 } from "../common/BaseItem1"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { GameResPath } from "../util/GameResPath"

export class LoginSelectServerLocationItem extends BaseItemRenderer {

	WIDTH = 188
	HEIGT = 60

	public constructor() {
		super()
		this.base_file = "login"
		this.layout_file = "LoginSelectServerLocationItem"
		this.load_callback = () => {

		}
		this.Load()
	}


	public dataChanged() {
		if (!super.dataChanged()) return
		this._lb_name.text = this.data.name
		// if (this.data.size) {
		// 	this._lb_name.fontSize = this.data.size
		// } else {
		// 	this._lb_name.fontSize = 24
		// }
		this.UpdateSelect()
	}

	public UpdateSelect() {
		if (this.selected) {
			this._img_bg.skin = GameResPath.GetIcon("login", "ui_Login_btn_1")
			this._lb_name.color = "#ae6231"
		} else {
			this._img_bg.skin = GameResPath.GetIcon("login", "ui_Login_btn_2")
			this._lb_name.color = "#e4e5f8"
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
window["LoginSelectServerLocationItem"] = LoginSelectServerLocationItem