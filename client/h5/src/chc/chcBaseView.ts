import { BaseWindowComponent } from "../common/BaseWindowComponent"
import { EventName } from "../common/EventName"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { chcModel } from "../commonModel/chcModel"

import "./chcMainView"

export class chcBaseView extends BaseWindowComponent {
	bg_list
	money_list
	//tabStrList
	titleList
	titleStr
	viewClassList
	window_open_back

	public constructor() {
		super()
		let local_GlobalEventSystem = GlobalEventSystem
		let local_EventName = EventName
		this.dependent_res = ["starEquip"]
		this.tabStrList = [{ label: "打造"}]
		//this.titleStr = "chc.ui_title_dz"
		this.viewClassList = ["chcMainView"]
		this.money_list = [2, 1, 0]
		this.bg_list = [
			"uisydz_001.jpg"
		]
		this.titleList = ["chc.ui_title_dz"]

		this.window_open_back = () => {
			this.SetBackId(170)
			let UpdateRed = () => {
				let red = chcModel.GetInstance().GetReddotAll()
				local_GlobalEventSystem.Fire(
					local_EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE,
					"chcBaseView",
					1,
					red
				)
			}
			this.BindEvent(chcModel.GetInstance(), chcModel.UPDATE_RED, UpdateRed, true)
		}
	}
}
window["chcBaseView"] = chcBaseView