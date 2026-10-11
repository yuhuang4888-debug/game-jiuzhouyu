import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { ResManager } from "../common/ResManager"
import { PlatformManager } from "../PlatformManager"

export class HolySealSuitPreviewItem extends BaseItemRenderer {
	public WIDTH = 83 //68 + 15
	public HEIGT = 180

	//eui
	private change = false

	public constructor() {
		super()
		this.base_file = "holySeal"
		this.layout_file = "HolySealSuitPreviewItem"

		this.load_callback = () => {
			this.LoadSuccess()
		}
		this.Load()
	}

	LoadSuccess() {

	}

	public dataChanged() {
		if (super.dataChanged()) {
			if (PlatformManager.IsEyouEnPlatform() && !this.change) {
				this._lb_name.rotation = -90;
				this._lb_name.width = 120;
				this._lb_name.y = 140;
				this._lb_name.centerX = NaN;
				this._lb_name.x = 6;
				this._lb_name.align = "center";
				this._lb_name.valign = "middle";
				this._lb_name.wordWrap = true;
				this._lb_name.fontSize = 20;
				this._lb_count.fontSize = 20;
				this.change = true;
			}
			let data = this.data
			let color = data.color>5?6:data.color
			ResManager.GetInstance().SetImageSprite(this, this._img_bg, "holySeal", `pre_tab_${color}`)
			this._lb_name.text = data.name

			this._lb_count.text = `${data.activating_count}/${data.seal.length}`

			this._img_select.visible = this.selected
		}
	}

	_img_bg: Laya.Image
	_lb_name: Laya.Label
	_lb_count: Laya.Label
	_img_select: Laya.Image
	public GetComponents() {
		[
			this._img_bg,
			this._lb_name,
			this._lb_count,
			this._img_select,
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_lb_name",
				"_lb_count",
				"_img_select",
			])
	}
}
window["HolySealSuitPreviewItem"] = HolySealSuitPreviewItem