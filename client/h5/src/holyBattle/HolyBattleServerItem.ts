import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { HtmlColorTxt, SetHtmlCenter, SetHtmlStyle, TransformLevel, Util } from "../util/Util"

export class HolyBattleServerItem extends BaseItemRenderer {

	public WIDTH = 458
	public HEIGT = 96

	public constructor(parent) {
		super()
		this.base_file = "holyBattle"
		this.layout_file = "HolyBattleServerItem"
		this.load_callback = () => {
			SetHtmlStyle(this._html_server, { c: "#d15e00", ww: false, f: 22 })
		}
		this.Load()
	}

	public dataChanged() {
		if (!super.dataChanged()) return
		let data = this.data
		let level = TransformLevel(data.lv)
        this._html_server.innerHTML = `S.${data.server_num}${data.server_name}&nbsp;<font color='#0a953e'>${level}级</font>`
	}


	public DeleteMe() {
		super.DeleteMe()
	}



_img_bg:Laya.Image
_img_icon:Laya.Image
_html_server:Laya.HTMLDivElement
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
 window["HolyBattleServerItem"]= HolyBattleServerItem