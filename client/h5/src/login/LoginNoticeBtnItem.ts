import { BaseItem1 } from "../common/BaseItem1";
import { BaseItemRenderer } from "../common/BaseItemRenderer";
import { ResManager } from "../common/ResManager";
import { SpecialCharKey } from "../common/SpecialCharKey";
import { PlatformManager } from "../PlatformManager";
import { GameResPath } from "../util/GameResPath";
import { AtlasUrl, SetHtmlCenter, SetHtmlStyle, Util } from "../util/Util";

export class LoginNoticeBtnItem extends BaseItemRenderer {

	WIDTH = 142
    HEIGT = 52
	public constructor(parent) {
		super();
		this.base_file = "login";
		this.layout_file = "LoginNoticeBtnItem";

		this.load_callback = () => {

		}

		this.Load()
	}


	public dataChanged(){
		if(!super.dataChanged())return
		this.labelDisplay.text = this.data.title

		let select_bg = this.selected ? "uian_001a" : "uian_001b"
		this._Image1.skin = AtlasUrl("common", select_bg)

		let stroke_color = this.selected ? "#3E9298" : "#6873A8"
		this.labelDisplay.strokeColor = stroke_color
	}

	public DeleteMe(){
		super.DeleteMe()
	}
	


_Image1:Laya.Image
labelDisplay:Laya.Label
public GetComponents() {
[
this._Image1,
this.labelDisplay,
]
 = this.GetChildrenByNames([

"_Image1",
"labelDisplay",
])
}
}
 window["LoginNoticeBtnItem"]= LoginNoticeBtnItem