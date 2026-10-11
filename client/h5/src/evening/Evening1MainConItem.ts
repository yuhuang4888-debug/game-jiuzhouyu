import { BaseItem1 } from "../common/BaseItem1"
import { SetHtmlStyle } from "../util/Util"

export class Evening1MainConItem extends BaseItem1 {
	data
	needRefreshData

	public static width = 630
	public static height = 20


	public constructor(parent) {
		super(parent)

		this.base_file = "evening"
		this.layout_file = "EveningMainConItem"
		this.load_callback = () => {
			SetHtmlStyle(this._lb_content,{c:"#663915",f:20,w:585,lh:25})
			if (this.needRefreshData) {
				this.SetData(this.data)
				this.needRefreshData = null
			}
		}
	}


	public SetData(data?) {

		this.data = data || this.data
		if (this.is_loaded) {
			this._lb_content.innerHTML = this.data
			this._lb_content.style.width=585
			this.display_obj.height=this._lb_content.contextHeight+7
		} else {
			this.needRefreshData = true
		}
	}

	public DeleteMe(){
		super.DeleteMe()
	}

	_Image1: Laya.Image
	_lb_content: Laya.HTMLDivElement
	public GetComponents() {
		[
			this._Image1,
			this._lb_content,
		]
			= this.GetChildrenByNames([

				"_Image1",
				"_lb_content",
			])
	}
}

window["Evening1MainConItem"] = Evening1MainConItem