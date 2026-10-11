import { attributePotionModel } from "../commonModel/attributePotionModel"
import { BaseItem1 } from "../common/BaseItem1"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { ResManager } from "../common/ResManager"
import { PlatformManager } from "../PlatformManager"
import { ColorUtil } from "../util/ColorUtil"
import { SetSizeDeltaX, Util } from "../util/Util"

export class attributePotionTab extends BaseItemRenderer {
	_Image1:Laya.Image
	_lb_name
	_red_dot
	iconDisplay

	public  WIDTH = 150
	public  HEIGHT = 52
	_model
	public constructor(parent) {
		super()

		this.base_file = "attributePotion"
		this.layout_file = "attributePotionTab"
		this._model = attributePotionModel.GetInstance()
		this.Load()

		// this.BindEvent(this._model, attributePotionModel.TIME_DATA_RETURN, (args?) => {
		// 	if (args && args == this.data.level + 1 || args == "All") {
		// 		this.dataChanged()
		// 	}
		// }
		// )
		if (PlatformManager.IsEyouEnPlatform()) {
			SetSizeDeltaX(this._lb_name, 80)
		}

	}






	public createChildren() {
		super.createChildren()
	}

	public dataChanged() {
		if(super.dataChanged()){
			this._lb_name.text = this.data.label
			this._red_dot.visible = this._model.tabRedDot(this.data.level)
			console.log(this.parent.parent)
			let list=this.parent.parent as Laya.List
			console.log(list.selectedIndex)
			if (this.index==list.selectedIndex) {
				this._lb_name.color = "#9b572f"
				ResManager.GetInstance().SetImageSprite(this,this._Image1,"attributePotion","uitc_006")
			} else {
				this._lb_name.color = "#FFFFFF"
				ResManager.GetInstance().SetImageSprite(this,this._Image1,"attributePotion","uitc_005")
			}
		}	
	}

	public DeleteMe(){
		super.DeleteMe()
	}


	public GetComponents() {
		[
			this._Image1,
			this._lb_name,
			this.iconDisplay,
			this._red_dot
		]
			= this.GetChildrenByNames([

				"_Image1",
				"_lb_name",
				"iconDisplay",
				"_red_dot"
			])
	}
}
window["attributePotionTab"] = attributePotionTab