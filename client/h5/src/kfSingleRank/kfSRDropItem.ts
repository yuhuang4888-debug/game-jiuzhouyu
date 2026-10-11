import { DownDropItem } from "../common/DownDropItem"
import { SetHtmlStyle } from "../util/Util"

export class kfSRDropItem extends DownDropItem {
	public constructor(parent) {
		super(parent)

		this.base_file = "kfSingleRank"
		this.layout_file = "kfSRDropItem"
		this.is_custom_html=true
		this.CustomHtml=()=>{
			this._lb_content.style.fontSize = 20
			this._lb_content.style.color = "#663915"
			this._lb_content.style.valign = "middle"
		}
	}

}
 window["kfSRDropItem"]= kfSRDropItem