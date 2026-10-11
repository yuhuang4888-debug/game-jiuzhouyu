import { BaseWindowComponent } from "../common/BaseWindowComponent"
import { DestinyTurntableView } from "./DestinyTurntableView"
import { InstructionType } from "../common/InstructionType"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"
import { CustomActivityDefine } from "../commonModel/CustomActivityDefine"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { EventName } from "../common/EventName"

export class DestinyTurntableEnView extends BaseWindowComponent {
	DestinyTurntableRedDot
	bg_list
	instruction_list
	tabStrList
	titleStr
	viewClassList
	window_load_back


	public constructor() {
		super()

		this.dependent_res = ["customActivity"]
		this.tabStrList = [{ label: "天命转盘" }]
		this.viewClassList = ["DestinyTurntableView"]
		this.titleStr = "customActivity.uitmzp_001"
		this.bg_list = ["uitmzp_021.jpg"]

		this.instruction_list = [
			InstructionType.DestinyTurntable
		]
		this.window_load_back = () => {
			this.DestinyTurntableRedDot()
			this.BindEvent(CustomActivityModel.GetInstance(), CustomActivityDefine.EVENT.DESTINY_TURNTABLE_INTEGRAL, () => {
				this.DestinyTurntableRedDot()
			})
			this.BindEvent(CustomActivityModel.GetInstance(), CustomActivityDefine.EVENT.DESTINY_TURNTABLE_RUN, () => {
				this.DestinyTurntableRedDot()
			})
		}

		this.DestinyTurntableRedDot = () => {
			let value = CustomActivityModel.GetInstance().GetRedDotValue(99, 1)
			GlobalEventSystem.Fire(EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "DestinyTurntableEnView", 1, value && value > 0)
		}
	}
}
window["DestinyTurntableEnView"] = DestinyTurntableEnView