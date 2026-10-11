import { DownDropBtn } from "../common/DownDropBtn"
import { SetHtmlCenter, SetHtmlStyle } from "../util/Util"
import { kfSRDropList } from "./kfSRDropList"

export class kfSRDropBtn extends DownDropBtn {

	public constructor(parent) {
		super(parent)

		this.base_file = "kfSingleRank"
		this.layout_file = "kfSRDropBtn"
		this._list_class = kfSRDropList

		this.is_custom_html=true
		this.CustomHtml=()=>{
			SetHtmlStyle(this._lb_content,{f:18,c:"#ffffff",a:"center",w:176,ww:false,st:2,stc:"#414388"})
		}
		this.CustomHtmlCenter=()=>{
			SetHtmlCenter(this._lb_content,{x:14,w:176})
		}
	}


}
window["kfSRDropBtn"] = kfSRDropBtn