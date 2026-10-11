import { BaseWindowComponent } from "../common/BaseWindowComponent"
import { EventName } from "../common/EventName"
import { ReincarnationModel } from "../commonModel/ReincarnationModel"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import "../reincarnation/ReincarnationBaseView";
export class ReincarnationEnterView extends BaseWindowComponent {
	bg_list
	change_scene_close
	delay_delete_time
	destroy_imm
	money_list
	tabStrList
	titleStr
	viewClassList
	window_load_back

	public constructor() {
		super()


		this.tabStrList = [{ label: "转职", icon_up_source: "reincarnation.zhuansheng_2", icon_down_source: "reincarnation.zhuansheng_1" }]
		this.viewClassList = ["ReincarnationBaseView"]
		this.bg_list = ["uizs_001_720x1222.jpg"]
		this.destroy_imm = false
		this.delay_delete_time = 0.01
		this.titleStr = "reincarnation.uizs_001"
		this.change_scene_close = false
		this.money_list = [2, 1, 0]
		this.window_load_back = () => {
			this.ReinRedDot()
		}
	}

	public ReinRedDot() {
		let UpdateReinRed = (red?) => {
			GlobalEventSystem.Fire(EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "ReincarnationEnterView", 0, red)
		}

		this.BindEvent(ReincarnationModel.GetInstance(), ReincarnationModel.UPDATE_RED_DOT, UpdateReinRed)
		ReincarnationModel.GetInstance().UpdateRedDot()
	}
}
window["ReincarnationEnterView"] = ReincarnationEnterView