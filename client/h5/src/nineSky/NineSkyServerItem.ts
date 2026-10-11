import { BaseItem1 } from "../common/BaseItem1"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { Util } from "../util/Util"

export class NineSkyServerItem extends BaseItemRenderer {
	public WIDTH = 458
	public HEIGT = 96

	public constructor() {
		super()
		this.base_file = "nineSky"
		this.layout_file = "NineSkyServerItem"
		this.load_callback = () => {
			this.LoadSuccess()
		}
		this.Load()
	}

	public LoadSuccess() {
		this._html_server.style.color = "#d15e00"
		this._html_server.style.fontSize = 22
		this._html_server.style.wordWrap = false
	}

	public dataChanged() {
		if (super.dataChanged()) {
			let data = this.data
			let level = data.world_lv > 370 && "神创" + (data.world_lv - 370) || data.world_lv
			this._html_server.innerHTML = `S.${data.server_num}${data.server_name}&nbsp;<font color='#0a953e'>${level}级</font>`
		}
	}
	_img_bg: Laya.Image
	_img_icon: Laya.Image
	_html_server: Laya.HTMLDivElement
	public GetComponents() {
		[
			this._img_bg,
			this._img_icon,
			this._html_server,
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_img_icon",
				"_html_server",
			])
	}
}
window["NineSkyServerItem"] = NineSkyServerItem
