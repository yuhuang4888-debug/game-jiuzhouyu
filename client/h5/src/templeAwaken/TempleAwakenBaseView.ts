import { BaseWindowComponent } from "../common/BaseWindowComponent"
import { EventName } from "../common/EventName"
import { TaskTipType } from "../commonModel/TaskModel"
import { TempleAwakenModel, TempleAwakenEvent } from "../commonModel/TempleAwakenModel"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { TempleAwakenMainView } from "./TempleAwakenMainView"

export class TempleAwakenBaseView extends BaseWindowComponent {
	bg_list
	destroy_imm
	instruction_list
	is_show_tab
	model
	money_list
	tabStrList
	titleStr
	viewClassList
	window_load_back

	public constructor() {
		super()


		this.model = TempleAwakenModel.GetInstance()
		this.dependent_res = ["templeAwaken"]
		this.viewClassList = ["TempleAwakenMainView"]
		this.titleStr = "templeAwaken.jxzl_008"
		this.bg_list = ["ui_sdjx.jpg"]
		this.money_list = [2, 1, 0]
		this.is_show_tab = true
		this.destroy_imm = true
		this.change_scene_close=true
		this.tabStrList = [{ label: "觉醒之路" }]//, icon_up_source="market_asset.uisc_004_r1_c2", icon_down_source="market_asset.uisc_004_r1_c1"
		//this.instruction_list = [null, null, null, InstructionType.AUCTION, InstructionType.MARKET_RECORD]
		this.window_load_back = () => {
			this.BindEvent(this.model, TempleAwakenEvent.UPDATE_VIEW, () => {
				this.RefreshRed()
			}
			)
			this.RefreshRed()
		}

	}

	public Close(): void {
		if (this.task_model.IsCurrMainLineTaskTipType(TaskTipType.Open_function)) {
			if (this.story_model.curr_view_story_step > 0) {
				this.story_model.curr_view_story_step = 0
			}
		}
		super.Close()
	}
	public BaseWindowCloseFunc() {

		super.BaseWindowCloseFunc()
	}

	public Open(...new_args) {
		// let parms = new_args
		// let index = parms[0]
		// this.SetDefaultIndex(index)
		// // if ((parms[0] && parms[1]) && parms[0] == 3) {
		// // 	this.SetIndexParameter(parms[0], parms[1])
		// // }
		super.Open()
	}

	public RefreshRed() {

		let red = this.model.GetRed()
		GlobalEventSystem.Fire(EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "TempleAwakenBaseView", 0, red)
	}

	public DeleteMe() {
		super.DeleteMe()
	}
}
window["TempleAwakenBaseView"]=TempleAwakenBaseView