import { BaseItem1 } from "./BaseItem1"

export class CommonRuleItem extends BaseItem1 {
	private data
	private needRefresh

	public constructor(parent) {
		super(parent)
		this.base_file = "common"
		this.layout_file = "CommonRuleItem"

		this.load_callback = () => {
			this.LoadSuccess()
		}
	}

	public LoadSuccess() {
		this.desc.width = 430
		this.desc.style.fontSize = 24
		this.desc.style.color = "#80372c"
		this.desc.style.lineHeight=30
		this.desc.style.wordWrap = true
		
		if (this.needRefresh) {
			this.SetData(this.data)
		}
	}

	public SetData(data) {
		this.data = data
		if (!this.data) {
			return
		}
		if (this.is_loaded) {
			let desc = ""
			if (typeof (this.data) == "object") {
				for (let i = 0; i < this.data.length; i++) {
					let v = this.data[i]
					if (i == 1) {
						desc = v
					} else {
						desc = desc + "\n" + v
					}
				}
			} else if (typeof (this.data) == "string") {
				desc = this.data
			}
			this.desc.innerHTML = desc
			this.desc.width = 430
			let lb_h = this.desc.contextHeight
			let content_h = 8 + lb_h + 20
			this.desc.height = lb_h
			this.conta.height = content_h
			this.display_obj.height = content_h
		} else {
			this.needRefresh = true
		}
	}

	conta: Laya.Box
	_Image1: Laya.Image
	desc: Laya.HTMLDivElement
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
	}
}
window["CommonRuleItem"] = CommonRuleItem