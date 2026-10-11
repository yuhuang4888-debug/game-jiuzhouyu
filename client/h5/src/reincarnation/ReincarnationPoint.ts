import { BaseItem1 } from "../common/BaseItem1"
import { Util } from "../util/Util"

export class ReincarnationPoint extends BaseItem1 {
	ClickFunc
	SetClick
	SetSelect
	need_refresh
	status

	public constructor(parent?) {
		super(parent)


		this.base_file = "reincarnation"
		this.layout_file = "ReincarnationPoint"
		this.load_callback = () => {

			let OnClick = () => {
				if (this["clickFunc"]) {
					this["clickFunc"]()
				}
				this.SetSelect(true)
			}
			Util.AddClickEvent(this.light_btn, OnClick, this, true)

			if (this.need_refresh) {
				this.SetSelect(this.status)
			}
		}
		this.SetSelect = (bool?) => {
			this.status = bool
			if (this.is_loaded) {
				if (bool) {
					this.select_btn.visible = true
					this.light_btn.visible = false
				} else {
					this.select_btn.visible = false
					this.light_btn.visible = true
				}
			} else {
				this.need_refresh = true
			}
		}

		this.SetClick = (clickFunc?) => {
			this.ClickFunc = clickFunc
		}


	}


	select_btn: Laya.Image
	light_btn: Laya.Image
	public GetComponents() {
		[
			this.select_btn,
			this.light_btn,
		]
			= this.GetChildrenByNames([

				"select_btn",
				"light_btn",
			])
	}
}
window["ReincarnationPoint"] = ReincarnationPoint