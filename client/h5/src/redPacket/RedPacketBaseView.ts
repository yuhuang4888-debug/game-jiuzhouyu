import { BaseWindowComponent } from "../common/BaseWindowComponent"
import { EventName } from "../common/EventName"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { RedPacketMainView } from "./RedPacketMainView"
import { RedPacketModel } from "../commonModel/RedPacketModel"

export class RedPacketBaseView extends BaseWindowComponent {
	append_to_ctl_queue
	destroy_imm
	money_list
	tabStrList
	viewClassList
	window_load_back

	public constructor() {
		super()

		this.destroy_imm = true
		this.dependent_res = ["redPacket"]
		this.viewClassList = [RedPacketMainView]
		this.money_list = [2, 1, 0]
		this.tabStrList = [{ label: "红包", icon_up_source: "", icon_down_source: "" }]
		this.window_load_back = () => {
			let is_show = RedPacketModel.GetInstance().GetRedStatus()
			GlobalEventSystem.Fire(EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "RedPacketBaseView", 0, is_show)
		}


	}
}
window["RedPacketBaseView"]=RedPacketBaseView
