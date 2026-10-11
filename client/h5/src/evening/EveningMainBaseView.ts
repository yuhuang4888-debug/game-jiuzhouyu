import { BaseWindowComponent } from "../common/BaseWindowComponent"
import { EventName } from "../common/EventName"
import { MainFunc } from "../commonModel/MainUIModel"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { EveningMainView } from "./EveningMainView"

export class EveningMainBaseView extends BaseWindowComponent {
	append_to_ctl_queue
	bg_list
	destroy_imm
	money_list
	tabStrList
	titleStr
	viewClassList
	public constructor() {
		super()

		this.destroy_imm = true
		this.dependent_res = ["evening"]
		this.viewClassList = ["EveningMainView"]
		this.titleStr = "evening.uighgh_001"
		this.bg_list = ["ui_Guild_bg1.jpg"]
		this.money_list = [2, 1, 0]
		this.tabStrList = [{ label: "结社篝火" }]

		this.BaseWindowCloseFunc=()=>{
			GlobalEventSystem.Fire(EventName.SWITCH_MAIN_FUNC_VIEW, MainFunc.Guild)
		}

		
	}

	public DeleteMe() {
		super.DeleteMe()
	}

}

window["EveningMainBaseView"]=EveningMainBaseView