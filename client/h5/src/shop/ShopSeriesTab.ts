import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { RedDotController } from "../common/RedDotController"
import { RedKey } from "../common/RedDotDefine"
import { ResManager } from "../common/ResManager"
import { MedalModel } from "../commonModel/MedalModel"
import { ShopModel, ShopType } from "../commonModel/ShopModel"
import { ColorType, Enum_ColorUtil_Dark, Enum_ColorUtil_Light } from "../util/ColorUtil"
import { SetSizeDelta, Util } from "../util/Util"

export class ShopSeriesTab extends BaseItemRenderer {
	model
	public WIDTH = 152
	public HEIGT = 70

	public constructor(parent) {
		super()

		this.model = ShopModel.GetInstance()
		this.base_file = "shop"
		this.layout_file = "ShopSeriesTab"
		this.Load()
	}

	public createChildren() {
		super.createChildren()
	}

	public dataChanged() {
		if(!super.dataChanged())return
		//顯示數據中的 label 值
		// if (this.is_loaded ) 
		if (super.dataChanged()) {
			let data = this.data
			this.labelDisplay.text = data.desc

			let img_width = null
			let img_height = null
			let text_color = null
			let line_color = null
			let url = null
			if (this.selected) {
				text_color = "#ffffff"
				line_color = "#ad455c"
				url = "uiscv2_007"
			} else {
				text_color = "#4f538f"
				line_color = "#c6c3f4"
				url = "uiscv2_008"
			}

			ResManager.GetInstance().SetImageSprite(this, this._Image1, "shop_asset", url)
			this.labelDisplay.color = text_color
			this.labelDisplay.strokeColor = line_color

			if(this.data.shop_type==ShopType.Guild){
				this.redDisplay.visible =  RedDotController.ins.get(RedKey[`GUILD_SHOP${data.id}`])
			}
		}
	}



_Image1:Laya.Image
redDisplay:Laya.Image
labelDisplay:Laya.Label
public GetComponents() {
[
this._Image1,
this.redDisplay,
this.labelDisplay,
]
 = this.GetChildrenByNames([

"_Image1",
"redDisplay",
"labelDisplay",
])
}
}
 window["ShopSeriesTab"]= ShopSeriesTab