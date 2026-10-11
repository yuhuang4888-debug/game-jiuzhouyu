import { BaseItem1 } from "../common/BaseItem1"
import { Util, SetSizeDeltaY } from "../util/Util"
import { VipView } from "./VipView"

export class VipRuleItem extends BaseItem1 {
	conta: Laya.Box
	_Image1: Laya.Image
	desc: Laya.HTMLDivElement
	data
	height
	needRefresh


	public static Height = 60;
	public constructor(parent?) {
		super(parent)

		this.base_file = "vip"
		this.layout_file = "VipRuleItem"
		this.load_callback = () => {

			if (this.needRefresh) {
				this.SetData(this.data)
			}
		}
	}

	public SetData(data?) {

		this.data = data
		if (!this.data) {
			return
		}
		if (this.is_loaded) {
			this.desc.innerHTML = Util.StrToHTML(this.data.tips)
			// this.desc.height = this.desc.textHeight
			// SetSizeDeltaY(this.desc, x)
			// this.conta.height = 8 + this.desc.textHeight + 20
			SetSizeDeltaY(this.conta, 8 + this.desc.contextHeight + 20)
			// this.height = this.conta.height
			SetSizeDeltaY(this.display_obj, this.conta.y)
		} else {
			this.needRefresh = true
		}
	}


	public GetComponents() {
		[
			this.conta,
			this._Image1,
			this.desc,
		]
			= this.GetChildrenByNames([

				"conta",
				"_Image1",
				"desc",
			])
		this.desc.style.fontSize=24
		this.desc.style.color="#80372c"
		this.desc.style.wordWrap=false
	}
}
window["VipRuleItem"]=VipRuleItem