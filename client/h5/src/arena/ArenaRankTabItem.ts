import { BaseItem1 } from "../common/BaseItem1"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { ResManager } from "../common/ResManager"
import { ArenaModel } from "../commonModel/ArenaModel"
import { ArtifactIllusionView } from "../pet/artifact/ArtifactIllusionView"
import { ColorUtil } from "../util/ColorUtil"
import { Color } from "../util/Util"

export class ArenaRankTabItem extends BaseItemRenderer {
	_Image1: Laya.Image
	_Image2: Laya.Image
	_lb: Laya.Label
	redDot_img: Laya.Image
	line_lb
	model


	public static width = 146
	public static height = 52

	public constructor(parent) {
		super()


		this.base_file = "arena"
		this.layout_file = "ArenaRankTabItem"
		this.model = ArenaModel.GetInstance()
		this.WIDTH=146
		this.HEIGT=52
		// this.load_callback = () => {

		// if (PlatformMgr.GetInstance().IsEyouEnPlatform() ) {
		// 	this._lb.size  = 20
		// }
		// if (PlatformMgr.GetInstance().IsEyouIdnPlatform() ) {
		// 	this._lb.size  = 20
		// }
		// this.InitEvent()
		// }
		this.Load()
	}

	public load_callback() {

		this.BindVar(this.model, "breach_dot", (event_name?, value?, old_value?) => {
			if(!this.data) return
			this.SetRedDot(this.data.index)
		}
		)
	}

	public dataChanged() {
		if(!super.dataChanged()) return 
		this._lb.text = this.data.name
		this._lb.color = this.selected && ColorUtil.GetColorLight(1) || "#e1cabe"//Color(222 / 255, 202 / 255, 190 / 255, 1)
		// this.line_lb.effectColor = this.selected && "#c95126"||"#b38270" //Color(201 / 255, 81 / 255, 38 / 255, 1) || Color(179 / 255, 130 / 255, 112 / 255, 1)
		let img_url = this.selected && "uilwmb_041" || "uilwmb_042"
		// ResManager.GetInstance().SetImageSprite(this, this._Image1, "arena_asset", img_url)
		if(this.selected){
			this._Image2.visible=true
			this._Image1.visible=false
			this._lb.color="#9b572f"
		}else{
			this._Image1.visible=true
			this._Image2.visible=false
			this._lb.color="#ffffff"
		}
		this.SetRedDot(this.data.index)
	}

	public SetRedDot(index?) {

		if (index == 1) {
			this.redDot_img.visible = this.model.GetBreachDot()
		}
	}

	public GetComponents() {
		[
			this._Image1,
			this._Image2,
			this._lb,
			this.redDot_img,
		]
			= this.GetChildrenByNames([

				"_Image1",
				"_Image2",
				"_lb",
				"redDot_img",
			])
	}
}
window["ArenaRankTabItem"]=ArenaRankTabItem