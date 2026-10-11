import { BaseItem1 } from "../common/BaseItem1"
import { Util } from "../util/Util"

export class MenuRedButtonSkin extends BaseItem1 {
	_Image1
	data
	labelDisplay
	needRefreshData

	public constructor(parent) {
		super(parent)

		this.base_file = "friend"
		this.layout_file = "MenuRedButtonSkin"
		this.load_callback = () => {

			Util.AddClickEvent(this._Image1, () => {
				if (this.data && this.data.clickFunc) {
					this.data.clickFunc(this)
				}
			}, this, true)
			if (this.needRefreshData) {
				this.SetData(this.data)
				this.needRefreshData = false
			}
		}
	}


	public SetData(data?) {

		this.data = data
		if (!this.is_loaded) {
			this.needRefreshData = true
			return
		}
		this.labelDisplay.text = data.label
	}

	public DeleteMe() {
		super.DeleteMe()
	}


	public GetComponents() {
		[
			this._Image1,
			this.labelDisplay,
		]
			= this.GetChildrenByNames([

				"_Image1",
				"labelDisplay",
			])
	}
}

window["MenuRedButtonSkin"] = MenuRedButtonSkin