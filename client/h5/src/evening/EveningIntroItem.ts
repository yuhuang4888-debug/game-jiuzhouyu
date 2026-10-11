import { BaseItem1 } from "../common/BaseItem1"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { ResManager } from "../common/ResManager"
import { GuildActivityModel } from "../commonModel/GuildActivityModel"
import { ColorUtil } from "../util/ColorUtil"

export class EveningIntroItem extends BaseItemRenderer {
	model
	name_outline

	public WIDTH = 170
	public HEIGT = 120

	is_set
	public constructor(parent) {
		super()
		this.is_set = false
		this.base_file = "evening"
		this.layout_file = "EveningIntroItem"
		this.model = GuildActivityModel.GetInstance()
		this.load_callback = () => {
			//this.name_outline = this.GetChild("_lb_name").GetComponent("Outline")

			if (!this.is_set) {
				this.is_set = true
			}
		}

		this.Load()
	}


	public dataChanged() {

		if (! super.dataChanged()) {
			return
		}
		if (this.is_loaded) {
			this.SetDate()
			this.is_set = true
		} else {
			this.is_set = false
		}

	}

	SetDate() {
		if (!this.data) return
		if(this.data.id ==2){
			if(GuildActivityModel.GetInstance().EveningGameType()==2){
				ResManager.GetInstance().SetImageSprite(this, this._img_icon, "evening_asset", this.data.icon2, true)
			}else{
				ResManager.GetInstance().SetImageSprite(this, this._img_icon, "evening_asset", this.data.icon, true)
			}
			
		}else{
			ResManager.GetInstance().SetImageSprite(this, this._img_icon, "evening_asset", this.data.icon, true)
		}
	

		if (this.selected) {
			ResManager.GetInstance().SetImageSprite(this, this._img_select, "evening_asset", "uighgha_011", true)
		} else {
			ResManager.GetInstance().SetImageSprite(this, this._img_select, "evening_asset", "uighgha_012", true)
		}
	}

	public DeleteMe() {
		super.DeleteMe()
	}

_img_select:Laya.Image
_img_icon:Laya.Image
public GetComponents() {
[
this._img_select,
this._img_icon,
]
 = this.GetChildrenByNames([

"_img_select",
"_img_icon",
])
}
}
 window["EveningIntroItem"]= EveningIntroItem