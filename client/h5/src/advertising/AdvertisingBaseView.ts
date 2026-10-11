import { BaseWindowComponent } from "../common/BaseWindowComponent"

export class AdvertisingBaseView extends BaseWindowComponent {
	public constructor() {
		super()
		this.destroy_imm = true
		this.titleList = ["advertising.ui_fllb_01"]
		this.tabStrList = [
			{ label: "福利礼包" }
		]
		this.viewClassList = [
			"AdvertisingMainView"
		]
	}
}
window["AdvertisingBaseView"] = AdvertisingBaseView


