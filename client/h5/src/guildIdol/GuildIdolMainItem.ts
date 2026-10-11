import { BaseItem1 } from "../common/BaseItem1"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { ResManager } from "../common/ResManager"
import { GuildModel, GuildEvent } from "../commonModel/GuildModel"
import { Color } from "../util/Util"

export class GuildIdolMainItem extends BaseItemRenderer {
	Out_lb_name
	_model

	public WIDTH = 152
	public HEIGT = 72
	is_set
	is_wait=false
	public constructor(parent) {
		super()

		this.is_set = false
		this.base_file = "guildidol"
		this.layout_file = "GuildIdolMainItem"
		this._model = GuildModel.GetInstance()
		this.load_callback = () => {

			// if (PlatformMgr.GetInstance().IsEyouPlatform()) {
			// 	this._lb_name.size = 16
			// }
			// if (PlatformMgr.GetInstance().IsEyouIdnPlatform()) {
			// 	this._lb_name.size = 16
			// }
			this.InintEvent()


			if (!this.is_set) {
				this.is_set = true
				this.SetData()

				if(this.is_wait){
					this.is_wait=false
					this.updateRed()
				}
			}
		}

		this.Load()
	}

	public InintEvent() {

		let local_GuildEvent = GuildEvent

		this.BindEvent(this._model, local_GuildEvent.IDOL_TAB_RED_UPDATE, (god_id?) => {
			if(!this.is_set){
				this.is_wait=true
				return
			}else{
				if (this.data&&this.data.god_id == god_id) {
					this.updateRed()
				}
			}
			
		}
		)

		this.BindEvent(this._model, local_GuildEvent.IDOL_TAB_ALL_RED_UPDATE, () => {
			this.updateRed()
		}
		)
	}
	public DeleteMe() {
		super.DeleteMe()
	}


	public dataChanged() {
		if (!super.dataChanged()) return
		if (this.is_loaded) {
			this.is_set = true
			this.SetData()
		} else {
			this.is_set = false
		}

	}


	SetData() {
		if (!this.data) return
		let text_color = null
		let line_color = null
		let img_str = null
		if (this.selected) {
			text_color ="#ffffff" 
			line_color = "#ad455c"
			img_str = "ui_role_btn_3"
		} else {
			text_color ="#4f538f" 
			line_color = "#c6c3f4"
			img_str = "ui_role_btn_4"
		}
		this._lb_name.text = this.data.name
		this._lb_name.color = text_color
		this._lb_name.strokeColor=line_color
		ResManager.GetInstance().SetImageSprite(this, this._Image1, "guildidol_asset", img_str, true)
		this.updateRed()
	}

	public updateRed() {
		if (!this.data) return
		let god_id = this.data.god_id
		let act = this._model.actItemRed(god_id)
		let awaken = this._model.awakenItemRed(god_id)
		let rune = this._model.runeItemRed(god_id)
		let red_bool = act || awaken || rune
		this._red.visible = red_bool
	}


_Image1:Laya.Image
_lb_name:Laya.Label
_red:Laya.Image
public GetComponents() {
[
this._Image1,
this._lb_name,
this._red,
]
 = this.GetChildrenByNames([

"_Image1",
"_lb_name",
"_red",
])
}
}
 window["GuildIdolMainItem"]= GuildIdolMainItem