import { BaseWindowComponent } from "../common/BaseWindowComponent"
import { CommonManager } from "../common/CommonManager"
import { EventName } from "../common/EventName"
import { InstructionType } from "../common/InstructionType"
import { BrightSeaModel } from "../commonModel/BrightSeaModel"
import { DailyModel } from "../commonModel/DailyModel"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { DailyEvent } from "./DailyEvent"

import "../daily/DailyTaskView";
import "../daily/DailyLimitActivityView";
import "../daily/DailyResFindView";
import "../daily/DailyStrongerView";
import "../deposit/DepositView";
import { CustomActivityModel } from "../commonModel/CustomActivityModel"
import { Split } from "../util/Util"


export class DailyView extends BaseWindowComponent {
	CheckRedDot
	InitMyEvent
	_Local_Open
	window_load_back

	public constructor() {
		super()

		let daily_model = DailyModel.GetInstance()
		let sea_model = BrightSeaModel.GetInstance()
		let local_DailyEvent = DailyEvent
		let local_GlobalEventSystem = GlobalEventSystem
		let update_window_red_event = EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE
		this.destroy_imm = true
		this.tabStrList = [
			{ label: "每日任务" },
			{ label: "限时活动" },
			{ label: "璀璨之海" },
			{ label: "资源找回" },
			{ label: "托管中心" },
			{ label: "我要变强", open_lv: 100 }
		]

		this.viewClassList = [
			"DailyTaskView",
			"DailyLimitActivityView",
			"BrightSeaEnterView",
			"DailyResFindView",
			"DepositView",
			"DailyStrongerView",
		]


		// this.titleList = ["daily_asset.uilxkf_005"]
		this.titleStr = "daily.uirw_008a"
		this.money_list = [2, 1, 0]
		//this.bg_list = ["daily_bg.jpg", "daily_bg.jpg", "daily_bg.jpg", "daily_bg.jpg"]
		this.bg_list = ["daily_bg.jpg", "daily_bg.jpg", "uicczh_008.jpg", "daily_bg.jpg", "daily_bg.jpg", "daily_bg.jpg"]

		this.instruction_list = [
			null,
			null,
			InstructionType.BrightSea,
		]

		this.tab_new_cond = {
			"2": () => {
				return CommonManager.GetInstance().CheckFuncOpenState("BrightSeaEnterView", true)
			}
		}

		this.window_load_back = () => {
			this.InitMyEvent()
		}

		this.InitMyEvent = () => {
			let update_fun = (red?) => {
				this.CheckRedDot()
			}

			this.BindEvent(daily_model, local_DailyEvent.REFRESH_DILY_DOT, update_fun)

			let swtich_fun = (...new_args) => {
				let params = new_args
				if (params && params[0]) {
					this.SetSelectIndex(params[0])
				} else {
					this.SetSelectIndex(0)
				}
			}
			this.BindEvent(daily_model, local_DailyEvent.DAILY_SWTICH_VIEW, swtich_fun)
		}


		this._Local_Open = (param?) => {
			if (param && param.length > 0) {
				daily_model.Fire(local_DailyEvent.DAILY_REQUEST_PROTO, 15718)
				this.SetDefaultIndex(param[0])
				this.SetIndexParameter(param[0], param)
			}
			GlobalEventSystem.Fire(EventName.ACTIVITY_ICON_FINGER, false, DailyModel.DailyIconType)
			super.Open()
		}

		this.CheckRedDot = () => {
			let red = (((daily_model.LivenessCanGet() || daily_model.LivenessCanUpgrade()) || daily_model.liveness_dot_not_show == false && daily_model.LivenessCanFind()) || daily_model.LivenessRewardCanGet()) || daily_model.GetOffLineRed()
			local_GlobalEventSystem.Fire(update_window_red_event, "DailyView", 0, red)
			let res_find_red = daily_model.ResCanFind() && daily_model.res_find_dot_not_show == false
			local_GlobalEventSystem.Fire(update_window_red_event, "DailyView", 3, res_find_red)
			let res_stronger_red = daily_model.GetstrongerRedDot()
			local_GlobalEventSystem.Fire(update_window_red_event, "DailyView", 5, res_stronger_red)
			let resRed = daily_model.dailyResRed > 0 || daily_model.GetResStatusRed() || daily_model.GetOffLineRed()
			local_GlobalEventSystem.Fire(update_window_red_event, "DailyView", 1, resRed)
			let red2 = sea_model.GetRedState()||sea_model.GetRobStatus()
			local_GlobalEventSystem.Fire(update_window_red_event, "DailyView", 2, red2)
		}
	}

	public BaseWindowCloseFunc() {
		DailyModel.GetInstance().need_tuo_guan_guide = false
		if (CustomActivityModel.GetInstance().online_draw_type) {
			let list = Split(CustomActivityModel.GetInstance().online_draw_type, "@")
			GlobalEventSystem.Fire(EventName.OPEN_ACT_VIEW, CustomActivityModel.GetInstance().online_draw_back_id, list[0], list[1])

		}
		super.BaseWindowCloseFunc()
	}

	public Open(...new_args) {
		let params = new_args
		this._Local_Open(params)
	}
}

window["DailyView"] = DailyView