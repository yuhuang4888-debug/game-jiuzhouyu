import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { ResManager } from "../common/ResManager"
import { Color } from "../util/Util"

export class FriendInviteTabItem extends BaseItemRenderer {
	_Image1: Laya.Image
	_lb_name: Laya.Label
	_img_red: Laya.Image
	public static width = 117
	public static height = 163
	WIDTH = 60
	HEIGT = 108

	public constructor(parent) {
		super()

		this.base_file = "friendInvite"
		this.layout_file = "FriendInviteTabItem"
		this.load_callback = () => {

		}
		this.Load()
	}

	public dataChanged() {
		if (super.dataChanged()) {
			this._lb_name.text = this.data.name
			this._lb_name.color = this.selected && "#cf4243" || "#69252b"
			this._lb_name.strokeColor = this.selected && "#ffffff" || "#ce7f85"
			this._img_red.visible = this.data.red_state
			ResManager.GetInstance().SetImageSprite(this, this._Image1, "friendInvite_asset", this.selected && "uiyqkbx_003" || "uiyqkbx_004", true)
		}
	}


	public GetComponents() {
		[
			this._Image1,
			this._lb_name,
			this._img_red,
		]
			= this.GetChildrenByNames([

				"_Image1",
				"_lb_name",
				"_img_red",
			])
	}
}
window["FriendInviteTabItem"] = FriendInviteTabItem