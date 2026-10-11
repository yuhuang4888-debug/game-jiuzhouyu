import { BaseWindowComponent } from "../common/BaseWindowComponent"
import { EventName } from "../common/EventName"
import { MondaysAwardModel, MondaysAwardEvent } from "../commonModel/MondaysAwardModel"
import { ServerTimeModel } from "../serverTime/ServerTimeModel"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import  "./MondaysAwardChnageView"
import  "./MondaysAwardView"

export class MondaysAwardEntView extends BaseWindowComponent {
	_Local_Close
	bg_list
	money_list
	redDot
	tabStrList
	titleStr
	viewClassList
	window_load_back

	public constructor() {
		super()


		//this.dependent_res = ["mondaysaward"]
		this.tabStrList = [{ label: "周一大奖" }]
		this.viewClassList = ["MondaysAwardView"]
		this.titleStr = "mondaysaward.ui_luck_title"
		this.money_list = [2, 1, 0]
		this.bg_list = ["ui_luck_bg.jpg"]
		this.instruction_list = [3318]
		let _model = MondaysAwardModel.GetInstance()
		let local_MondaysAwardEvent = MondaysAwardEvent
		this.destroy_imm=true

		this.window_load_back = () => {
			this.redDot()
		}

		this._Local_Close = () => {
			_model.Fire(local_MondaysAwardEvent.ClOSE_VIEW, "MondaysAwardChnageView")
			super.Close()
		}

		this.redDot = () => {
			let changeRedDot = () => {
				GlobalEventSystem.Fire(EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "MondaysAwardEntView", 0, _model.showRedDot())
			}
			this.BindEvent(_model, local_MondaysAwardEvent.UPDATE_RED_DOT, changeRedDot)
			changeRedDot()
		}

	}

	public Close() {

		this._Local_Close()
	}

}

window["MondaysAwardEntView"]=MondaysAwardEntView