import { SetHtmlStyle, SetSizeDeltaX } from "../util/Util"
import { Evening1MainConItem } from "./Evening1MainConItem"

export class EveningIntroTextItem extends Evening1MainConItem {
	_lb_content:Laya.HTMLDivElement
	data
	needRefreshData
	public static width = 400
	public static height = 20
	public constructor(parent) {
		super(parent)

		this.base_file = "evening"
		this.layout_file = "EveningMainConItem"
		this.load_callback=()=>{
			this._lb_content.x=20
			SetHtmlStyle(this._lb_content,{c:"#663915",f:20,w:EveningIntroTextItem.width-20,lh:25})
			SetSizeDeltaX(this.display_obj, EveningIntroTextItem.width)
			//SetSizeDeltaX(this._lb_content, EveningIntroTextItem.width-20)
			if (this.needRefreshData) {
				this.SetData(this.data)
				this.needRefreshData = false
			}
		}
	}

	public DeleteMe() {
		super.DeleteMe()
	}


	public SetData(data?) {


		this.data = data || this.data

		if (this.is_loaded) {

			this._lb_content.innerHTML = this.data
			this._lb_content.style.width=EveningIntroTextItem.width-20
			this.display_obj.height=this._lb_content.contextHeight+5
		} else {
			this.needRefreshData = true

		}

	}



}

window["EveningIntroTextItem"] = EveningIntroTextItem