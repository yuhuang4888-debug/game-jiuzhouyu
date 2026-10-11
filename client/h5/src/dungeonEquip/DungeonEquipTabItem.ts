import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { ResManager } from "../common/ResManager"
import { PlatformManager } from "../PlatformManager"
import { SetAnchoredPosition, SetSizeDeltaX } from "../util/Util"

export class DungeonEquipTabItem extends BaseItemRenderer {
	inited
	public WIDTH = 95
	public HEIGT = 92
	is_set = false
	public constructor(parent) {
		super()

		this.base_file = "dungeonEquip"
		this.layout_file = "DungeonEquipTabItem"

		this.inited = false
		this.load_callback = () => {

			//this:InitEvent()
			this.inited = true
			// if (PlatformMgr.GetInstance().IsEyouEnPlatform() ) {
			// 	SetAnchoredPositionX(this._Group1, 25)
			// 	let layout = this._Group1.GetComponent("UnityEngine.UI.HorizontalLayoutGroup")
			// 	layout.spacing = -13
			// }

			if (!this.is_set) {
				this.is_set = true
				this.SetData()
			}
		}

		this.Load()
	}

	//function DungeonEquipTabItem.createChildren()
	//    super.createChildren()
	//}

	public dataChanged() {
		if (!super.dataChanged()) return
		if (this.is_loaded) {
			this.SetData()
			this.is_set = true
		} else {
			this.is_set = false
		}

	}

	SetData() {
		if (!this.inited || !this.data) { return }
		if (this.is_loaded) {
			let state = this.data.state

			ResManager.GetInstance().SetImageSprite(this, this._img_bg, "dungeonEquip_asset", this.data.img_source , true)
			this._img_select.visible=this.selected 

			this._gp_cond.visible = !state
			this._img_tips.visible = state
			let id=this.data.dun_id%100
			ResManager.GetInstance().SetImageSprite(this, this._img_tips, "dungeonEquip_asset",`ui_copy_yq${id}` , true)
			if (!state) {
				let sclv=370
				let lv = (this.data.lv > sclv && (this.data.lv - sclv) || (this.data.lv))
				this.destiny_img.visible = this.data.lv > sclv
				this._lb_cond.centerX=this.data.lv > sclv?10:0
				this._lb_cond.fontSize = 20
				if (PlatformManager.IsEyouEnPlatform()) {
					this._lb_cond.text = "Lv."+ lv 
				}else{
				this._lb_cond.text = lv + "级\n"
				}
			}
		}
	}

	public DeleteMe() {
		super.DeleteMe()
	}

_img_bg:Laya.Image
_img_tips:Laya.Image
_gp_cond:Laya.Box
_Image1:Laya.Image
_Group1:Laya.Box
destiny_img:Laya.Image
_lb_cond:Laya.Label
_img_select:Laya.Image
public GetComponents() {
[
this._img_bg,
this._img_tips,
this._gp_cond,
this._Image1,
this._Group1,
this.destiny_img,
this._lb_cond,
this._img_select,
]
 = this.GetChildrenByNames([

"_img_bg",
"_img_tips",
"_gp_cond",
"_Image1",
"_Group1",
"destiny_img",
"_lb_cond",
"_img_select",
])
}
}
 window["DungeonEquipTabItem"]= DungeonEquipTabItem