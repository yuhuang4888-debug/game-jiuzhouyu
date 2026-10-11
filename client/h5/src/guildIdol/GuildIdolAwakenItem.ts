import { BaseItem1 } from "../common/BaseItem1"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { SetAnchoredPositionY } from "../util/Util"

export class GuildIdolAwakenItem extends BaseItem1 {
	color
	pos_y
	refresh

	public constructor(parent?) {
		super(parent)

		this.base_file = "guildidol"
		this.layout_file = "GuildIdolAwakenItem"
		this.layer_value = Enum_UILayer.UI
		this.color = 0
		this.pos_y = 0
		this.refresh = false
		this.load_callback = () => {

			if (this.refresh) {
				this.InitView()
			}
		}
	}

	public InitView() {

		//this:AddUIEffect("ui_shengxiangbaoshi_" + this.color, this.layer_value, this._gp_effect, null, {x=0.65, y=0.65}, true)
		//SetAnchoredPositionY(this._gp_effect, this.pos_y)
		ResManager.GetInstance().SetImageSprite(this, this.Image, "guildidol_asset", "uigh_r" + this.color)
		SetAnchoredPositionY(this.display_obj, this.pos_y)
	}

	public SetData(color?, pos_y?) {

		//this.color = color
		this.color = color == 6 && 7 || color
		this.pos_y = pos_y
		if (this.is_loaded) {
			this.InitView()
		} else {
			this.refresh = true
		}
	}


	public DeleteMe() {
		super.DeleteMe()
	}

	_gp_effect: Laya.Box
	Image: Laya.Image
	public GetComponents() {
		[
			this._gp_effect,
			this.Image,
		]
			= this.GetChildrenByNames([

				"_gp_effect",
				"Image",
			])
	}
}
window["GuildIdolAwakenItem"] = GuildIdolAwakenItem