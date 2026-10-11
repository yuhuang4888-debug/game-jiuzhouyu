import { BaseItem1 } from "../common/BaseItem1"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { ResManager } from "../common/ResManager"
import { PlatformManager } from "../PlatformManager"
import { ColorUtil } from "../util/ColorUtil"

export class DrawBtnRerderer extends BaseItemRenderer {
	_Image1: Laya.Image
	_lb_turn: Laya.Label
	public static width = 150
	public static height = 57
	WIDTH = 121
	HEIGT = 52
	public constructor(parent) {
		super()


		this.base_file = "surpriseGift"
		this.layout_file = "DrawBtnRerderer"
		this.load_callback = () => {

		}
		this.Load()
	}

	public dataChanged() {
		if (super.dataChanged()) {
			if (this.data) {
				this.InitView()
			}
		}
	}

	public InitView() {


		if (this.data && this.data.turn_id) {
			// if (PlatformManager.GetInstance().IsEyouThPlatform()) {
			// 	this._lb_turn.text = "รอบที่" + this.data.turn_id
			// } else if (PlatformMgr.GetInstance().IsEyouIdnPlatform()) {
			// 	this._lb_turn.text = "Babak " + this.data.turn_id
			// } else {
			this._lb_turn.text = "第" + this.data.turn_id + "轮"
			//}
			// [ts2lua]lua中0和空字符串也是true，此处this.selected需要确认
			let color = this.selected && "#ffffff" || "#4f538f"
			this._lb_turn.color = ColorUtil.TryParseHtmlString(color)
			let effect_color = this.selected && "#ad455c" || "#c6c3f4"
			this._lb_turn.strokeColor = ColorUtil.TryParseHtmlString(effect_color)
			let url = this.selected && "uijxlb_203b" || "uijxlb_203a"
			ResManager.GetInstance().SetImageSprite(this, this._Image1, "surpriseGift_asset", url,true)
		}
	}



	public GetComponents() {
		[
			this._Image1,
			this._lb_turn,
		]
			= this.GetChildrenByNames([

				"_Image1",
				"_lb_turn",
			])
	}
}
window["DrawBtnRerderer"] = DrawBtnRerderer