
//require("game.proto.511.Require511")
//require("game.mask.MaskModel")
//require("game.mask.RequireMask")

import { BaseController } from "../common/BaseController"
import { EventName } from "../common/EventName"
import { UserMsgAdapter } from "../common/UserMsgAdapter"
import { MaskModel } from "../commonModel/MaskModel"
import { Message } from "../sysInfo/SysInfoController"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import "../mask/MaskAddTimeView"
import "../mask/MaskInfoView"
import "../mask/MaskUseView"

export class MaskController extends BaseController {
	mask_model
	user_msg_adapter





	public constructor() {
		super()

		this.user_msg_adapter = UserMsgAdapter.GetInstance()
		this.mask_model = MaskModel.GetInstance()

		this.InitEvents()
		this.RegisterAllProtocals()
	}

	public InitEvents() {

		this.mask_model.Bind(MaskModel.REQUEST_PROTO, (id, fmt, ...new_args) => {
			this.SendFmtToGame(id, fmt, ...new_args)
		}
		)
		GlobalEventSystem.Bind(EventName.GAME_START, () => {
			this.SendFmtToGame(51101)
		}
		)
	}

	public RegisterAllProtocals() {

		let on51101 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(51101)
			this.mask_model.SetMaskInfo(scmd)
		}

		let on51102 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(51102)
			let info = this.mask_model.GetMaskInfo(scmd)
			if (info) {
				info.mask_id = scmd.mask_id
				info.end_time = scmd.end_time
				this.mask_model.SetMaskInfo(info)
			}
			Message.show("你取消了蒙面人变身效果")
		}

		this.RegisterProtocal(51101, on51101)//蒙面信息
		this.RegisterProtocal(51102, on51102)//取消蒙面
	}
}