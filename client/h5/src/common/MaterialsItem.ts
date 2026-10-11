import { RoleManager } from "../commonModel/RoleManager";
import { Enum_ColorUtil_Dark } from "../util/ColorUtil";
import { GlobalEventSystem } from "../util/DeclareGlobalVar";
import { GameResPath } from "../util/GameResPath";
import { Util, Split, SetHtmlStyle, HtmlColorTxt } from "../util/Util"
import { BaseItem1 } from "./BaseItem1";
import { EventName } from "./EventName";
import { OpenFun } from "./OpenFun"
import { ResManager } from "./ResManager";

export class MaterialsItem extends BaseItem1 {

	private data;
	cur_com_id_

	public constructor(parent) {

		super(parent)
		this.base_file = "common"
		this.layout_file = "MaterialsItem"
		this.is_delay_callback = false
		this.load_callback = () => {
			ResManager.GetInstance().SetOutsideImageSprite(this, this.tip, GameResPath.GetIconOtherPath("common", "img_go_recommend"))
			this.InitEvent()
			this.dataChanged()
		}
	}


	public InitEvent() {
		Util.AddClickEvent(this.btn, () => {
			if (this.data[2] == "38070001") {
			} else {
				OpenFun.OpenFunHandler(this.data[0], this.data[1], this.data[2])
			}
			GlobalEventSystem.Fire(EventName.MATERIAL_VIEW_CLOSE)
		}, this, true)
	}

	public dataChanged() {
		if (this.data) {

			let list = Split(String(this.data[0]), "_")
			let bool = false
			if (list.length >= 2 && list[0] == 331) {
				bool = true
			}
			this.btn.visible = Number(this.data[0]) < 10000 || bool
			this.tip.visible = (this.data[0] == 70)

			let title = OpenFun.OpenName(this.data[0])
			SetHtmlStyle(this.targetName,{c:"#663915",f:24,ww:false,w:400})
			if (this.cur_com_id_ && (this.cur_com_id_.name == "护符" || this.cur_com_id_.name == "项链")&&list[0] == 36) {
				if(RoleManager.GetInstance().GetMainRoleLevel()>=240){
					this.targetName.innerHTML = title+`${HtmlColorTxt("(推荐)",Enum_ColorUtil_Dark.GREEN)}`
				}else{
					this.targetName.innerHTML = title
				}
				
			} else {
				this.targetName.innerHTML = title
			}
		}
	}

	public SetData(data?, cur_com_id_?) {
		this.data = data;
		this.cur_com_id_ = cur_com_id_
	}


_Image11:Laya.Image
tip:Laya.Image
targetName:Laya.HTMLDivElement
btn:Laya.Image
labelDisplay:Laya.Label
_Image2:Laya.Image
public GetComponents() {
[
this._Image11,
this.tip,
this.targetName,
this.btn,
this.labelDisplay,
this._Image2,
]
 = this.GetChildrenByNames([

"_Image11",
"tip",
"targetName",
"btn",
"labelDisplay",
"_Image2",
])
}
}
 window["MaterialsItem"]= MaterialsItem