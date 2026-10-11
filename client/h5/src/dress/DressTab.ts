import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { ResManager } from "../common/ResManager"
import { DressModel, DressEvent } from "../commonModel/DressModel"
import { TaskFinishView } from "../task/TaskFinishView"
import { SetLocalPositionX, SetLocalPositionY, SetSizeDeltaX, SetSizeDeltaY } from "../util/Util"

export class DressTab extends BaseItemRenderer {
	_Image1: Laya.Image
	_Group1: Laya.HBox
	iconDisplay: Laya.Image
	_lb: Laya.Label
	redDisplay: Laya.Image
	InitEvent
	Out_lb
	SetRedDot
	init_x

	public static width = 131
	public static height = 53
	public constructor(parent) {
		super()
		this.HEIGT=57
		this.WIDTH=150

		this.base_file = "dress"
		this.layout_file = "DressTab"
		// this.skinName = "resource/game/dress/exml/DressTabExml.exml"
		let model = DressModel.GetInstance()

		// this.load_callback = () => {
		// if (PlatformMgr.GetInstance().IsEyouEnPlatform()) {
		// 	this._lb.size = 20
		// }
		// }

		this.load_callback = () => {
			// this.init_x = this._Image1.x
			let update_fun = () => {
				this.SetRedDot()
			}

			this.BindEvent(model, DressEvent.DRESS_UPDATE_RED_DOT, update_fun)
		}

		// this.InitEvent()

		this.dataChanged = () => {
			if(super.dataChanged()){
				let url = this.selected ? "uian_003a" : "uian_003c"
				ResManager.GetInstance().SetImageSprite(this, this._Image1, "dress_asset", url, true)
				// let out_color = this.selected && 0xe4792a || 0x000000//Color(228 / 255, 121 / 255, 42 / 255, 255 / 255) || Color(0, 0, 0, 0)
				// this.Out_lb.effectColor = out_color
				// let text_color = this.selected ? 0xffffff : 0x83644d //Color(255 / 255, 255 / 255, 255 / 255, 1) || Color(131 / 255, 100 / 255, 77 / 255, 1)
				// this._lb.textColor = text_color
				this._lb.color = this.selected ? "#9b572f" : "#ffffff"
				let url1 = this.selected && this.data.icon_down_source || this.data.icon_up_source
				ResManager.GetInstance().SetImageSprite(this, this.iconDisplay, "dress_asset", url1)
				this._lb.text = this.data.name
				this.SetRedDot()
				// LayoutRebuilder(this.iconDisplay)
				// LayoutRebuilder(this._Group1)
				// SetSizeDeltaX(this._Image1, this.selected ? 148 : 135)
				SetLocalPositionY(this._Image1, this.selected ? 6 : 8 )
				this._Image1.height=this.selected? 57 :52
			}
		
		}

		this.SetRedDot = () => {
			if (this.data) {	
				this.redDisplay.visible = model.DressCanActive(this.data.dress_type) || model.DressCanUplevel(this.data.dress_type)
			}
		}
		this.Load()
	}

	public GetComponents() {
		[
			this._Image1,
			this._Group1,
			this.iconDisplay,
			this._lb,
			this.redDisplay,
		]
			= this.GetChildrenByNames([

				"_Image1",
				"_Group1",
				"iconDisplay",
				"_lb",
				"redDisplay",
			])
	}
}
window["DressTab"] = DressTab