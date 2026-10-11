import { BaseWindowComponent } from "../common/BaseWindowComponent"
import { EventName } from "../common/EventName"
import { DsgtModel } from "../commonModel/DsgtModel"
import { MainFunc } from "../commonModel/MainUIModel"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { Util } from "../util/Util"
import "./DsgtView"

export class DsgtWindowView extends BaseWindowComponent {
	InitSubEvent
	UpdateRed
	_Local_Open
	money_list
	tabStrList
	titleStr
	viewClassList
	window_load_back

	public constructor() {
		super()


		this.dependent_res = ["role"]
		this.tabStrList = [{ label: "称号", icon_up_source: "role_json.role_9_png", icon_down_source: "role_json.role_8_png" }]
		this.viewClassList = ["DsgtView"]
		this.titleStr = "role.title_name"
		this.money_list = [2, 1, 0]
		let model = DsgtModel.GetInstance()
		let local_GlobalEventSystem = GlobalEventSystem
		let local_EventName = EventName
		this.window_load_back = () => {
			this.InitSubEvent()
			this.UpdateRed()
		}

		this._Local_Open = (prams?) => {
			if (!Util.IsTableEmpty(prams)) {
				this.SetIndexParameter(0, prams[0])
			}
			super.Open()
		}

		this.UpdateRed = () => {
			let dot2 = model.ShowRedIcon()
			local_GlobalEventSystem.Fire(local_EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "DsgtWindowView", 0, dot2)
		}

		this.InitSubEvent = () => {
			this.BindEvent(model, DsgtModel.DSGT_RED, () => {
				this.UpdateRed()
			}
			)
		}

		this.BaseWindowCloseFunc = () => {
			super.BaseWindowCloseFunc()
			local_GlobalEventSystem.Fire(local_EventName.SWITCH_MAIN_FUNC_VIEW, MainFunc.Role)
		}


	}

	public Open(...new_args) {

		this._Local_Open(new_args)
	}

}

window["DsgtWindowView"]=DsgtWindowView