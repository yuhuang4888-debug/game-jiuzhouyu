import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { Util } from "../util/Util"

export class FriendInviteShareView extends BaseView1 {
	_bg1: Laya.Image
	_bg: Laya.Image
	_Label1: Laya.Label
	height
	width

	public constructor() {
		super()


		this.base_file = "friendInvite"
		this.layout_file = "FriendInviteShareView"
		this.layer_value = Enum_UILayer.UIRoot
		this.is_center = true
		this.load_callback = () => {
			//this.width = LayerManager.GetInstance().stageWidth + 10
			//this.height = LayerManager.GetInstance().stageHeight + 10
			//lua_resM:SetOutsideImageSprite(this, this._bg, GameResPath.GetIcon("friendInvite","ui_wxshare"))
			InitEvent()
		}

		let InitEvent = () => {
			Util.AddClickEvent(this._bg1, () => {
				this.Close()
			}
				, this, true)
		}
	}



	public GetComponents() {
		[
			this._bg1,
			this._bg,
			this._Label1,
		]
			= this.GetChildrenByNames([

				"_bg1",
				"_bg",
				"_Label1",
			])
	}
}
window["FriendInviteShareView"] = FriendInviteShareView