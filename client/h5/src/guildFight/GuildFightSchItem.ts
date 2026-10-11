import { BaseItem1 } from "../common/BaseItem1"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { HtmlColorTxt, SetHtmlStyle, TransformLevel } from "../util/Util"

export class GuildFightSchItem extends BaseItemRenderer {

	public WIDTH = 458
	public HEIGT = 96
	color_str = "'#00abc4'"
	public constructor(parent) {
		super()
		this.base_file = "guildFight"
		this.layout_file = "GuildFightSchItem"
		this.load_callback = () => {
			SetHtmlStyle(this._html_server, { c: "#d15e00", ww: false, f: 22 })
		}
		this.Load()
	}

	public dataChanged() {
		if (!super.dataChanged()) return
		this.SetData()
	}



	public DeleteMe() {
		super.DeleteMe()
	}

	SetData() {
		let data = this.data
        let level = TransformLevel(this.data.wlv)
        this._html_server.innerHTML = `S.${data.server_num}${data.server_name}&nbsp;<font color='#0a953e'>${level}级</font>`
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
 window["GuildFightSchItem"]= GuildFightSchItem