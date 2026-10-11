import { BaseItem1 } from "../common/BaseItem1"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { VipModel } from "../commonModel/VipModel"
import { PlatformManager } from "../PlatformManager"
import { Util, SetSizeDeltaY } from "../util/Util"

export class VipInstructionItem extends BaseItemRenderer {
	info_hbox: Laya.HBox
	_Image1: Laya.Image
	_lb_desc: Laya.HTMLDivElement
	new_group: Laya.Box
	_Image2: Laya.Image
	_Label1: Laya.Label
	// height

	public static width = 420
	public static height = 24

	public constructor(parent) {
		super()
		this.WIDTH=420
		this.HEIGT=28
		this.base_file = "vip"
		this.layout_file = "VipInstructionItem"

		this.Load()
	}

	public load_callback(){

			// if (PlatformMgr.GetInstance().IsEyouEnPlatform() ) {
			// 	let layout = this.form.GetComponent("UnityEngine.UI.HorizontalLayoutGroup")
			// 	layout.spacing = 5
			// 	this._lb_desc.size  = 18
			// }
	}

	public dataChanged() {
		if(!super.dataChanged()) return 
        if(PlatformManager.IsEyouPlatform()){
            this._lb_desc.style.wordWrap = true
            this._lb_desc.style.width = 340
            this._lb_desc.style.leading = 0.1
        }
		if (this.data) {
			this._lb_desc.innerHTML = Util.StrToHTML(this.data.tips)
			if(PlatformManager.IsEyouPlatform()){
                this._lb_desc.style.width = 340
				let box:Laya.Box = this._lb_desc.parent as Laya.Box
				if(box){
					box.width = this._lb_desc.contextWidth
				}
            }
			// Laya.callLater(() => {
			// 		this.height = this._lb_desc.height
			// 	}
			// 	, this)
			// SetSizeDeltaY(this.display_obj, this._lb_desc.y)
			if (this.data.new && this.data.new > VipModel.GetInstance().GetVipLevel()) {
				this.new_group.visible = true
				this.info_hbox.refresh()
			} else {
				this.new_group.visible = false
			}
			// UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(this.form)
		}
	}


	public GetComponents() {
		[
			this.info_hbox,
			this._Image1,
			this._lb_desc,
			this.new_group,
			this._Image2,
			this._Label1,
		]
			= this.GetChildrenByNames([
				"info_hbox",
				"_Image1",
				"_lb_desc",
				"new_group",
				"_Image2",
				"_Label1",
			])
		this._lb_desc.style.fontSize=22
		this._lb_desc.style.color="#663915"
		this._lb_desc.style.wordWrap=false
	}
}
window["VipInstructionItem"]=VipInstructionItem