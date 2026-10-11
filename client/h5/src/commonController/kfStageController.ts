import { BaseController } from "../common/BaseController"
import { EventName } from "../common/EventName"
import { UserMsgAdapter } from "../common/UserMsgAdapter"
import { kfStageModel } from "../commonModel/kfStageModel"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { ViewOrderModel, ViewOrderModelEvent } from "../commonModel/ViewOrderModel"

import "../kfStart/kfStageOpenView"
import "../kfStart/kfStageShowView"
import "../kfStart/kfStageStartView"
import "../kfStart/kfStageView"
import "../kfStart/kfStageShow2View"
import "../kfStart/kfStageStartItem"

export class kfStageController extends BaseController {
	user_msg_adapter
	model:kfStageModel
	view_dic = {}

	public constructor() {
		super()
		this.user_msg_adapter = UserMsgAdapter.GetInstance()
		this.model = kfStageModel.GetInstance()

		this.InitInfo()
		this.InitEvent()
	}

	private InitInfo() {
		let On10200 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(10200)
			this.model.SetData(scmd)
		}
		this.RegisterProtocal(10200, On10200)
	}

	private InitEvent() {
		GlobalEventSystem.Bind(EventName.GAME_START, async () => {
			await this.model.InitCookieData()
			await this.SendFmtToGame(10200)
			await ViewOrderModel.GetInstance().Fire(ViewOrderModelEvent.PROTO_OUT_LINE);
		})

		this.model.Bind(kfStageModel.OPEN_VIEW, (view_name: string, ...new_args) => {
			let view = this.view_dic[view_name]
			if (!view) {
				let viewName = window[view_name]
				view = new viewName()
				this.view_dic[view_name] = view
			}

			view.Open(...new_args)
		})
	}
}
window["kfStageController"] = kfStageController