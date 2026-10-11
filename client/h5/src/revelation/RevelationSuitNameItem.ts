import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { ResManager } from "../common/ResManager"
import { RevelationModel, RevelationEvent } from "../commonModel/RevelationModel"

export class RevelationSuitNameItem extends BaseItemRenderer {
	WIDTH = 150
	HEIGT = 52

	model
	need_refresh = false
	//OutlabelDisplay

	public constructor() {
		super()
		this.base_file = "revelation"
		this.layout_file = "RevelationSuitNameItem"

		this.model = RevelationModel.GetInstance()
		
		this.load_callback = () => {
			if (this.need_refresh) {
				this.need_refresh = false
				this.dataChanged()
			}
			/*
			if (PlatformMgr.GetInstance().IsEyouIdnPlatform()) {
				this.labelDisplay.size = 18
			}
			*/
		}
		this.Load()
	}

	public dataChanged() {
		if (this.is_loaded) {
			this.lb_tips.text = this.data.name
			if (this.selected) {
				//this.OutlabelDisplay.effectColor = ColorUtil.TryParseHtmlString("#d26b40")
				this.lb_tips.color = "#9b572f"
				ResManager.GetInstance().SetImageSprite(this, this.img_bg, "common2", "uian_003a")
				this.model.Fire(RevelationEvent.SELECT_SUIT_NAME, this)
			} else {
				//this.OutlabelDisplay.effectColor = ColorUtil.TryParseHtmlString("#885f4c")
				this.lb_tips.color = "#ffffff"
				ResManager.GetInstance().SetImageSprite(this, this.img_bg, "common2", "uian_003c")
			}
			this.img_bg.y = this.selected ? 27 : 30
		} else {
			this.need_refresh = true
		}
	}

	img_bg: Laya.Image
	lb_tips: Laya.Label
	img_red: Laya.Image
	public GetComponents() {
		[
			this.img_bg,
			this.lb_tips,
			this.img_red,
		]
			= this.GetChildrenByNames([

				"img_bg",
				"lb_tips",
				"img_red",
			])
	}
}
window["RevelationSuitNameItem"] = RevelationSuitNameItem