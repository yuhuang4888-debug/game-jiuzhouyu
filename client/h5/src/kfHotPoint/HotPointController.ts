
//require("game.proto.333.Require333")
//require("game.kfHotPoint.HotPointModel")
//require("game.kfHotPoint.kfHotPointView")
//require("game.kfHotPoint.kfHotPointItem")
//require("game.kfHotPoint.kfHotPointRewardItem")

import { BaseController } from "../common/BaseController"
import { EventName } from "../common/EventName"
import { UserMsgAdapter } from "../common/UserMsgAdapter"
import { CustomActivityDefine } from "../commonModel/CustomActivityDefine"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { Util } from "../util/Util"
import { HotPointModel } from "./HotPointModel"
import "./kfHotPointView"

export class HotPointController extends BaseController {

	public constructor() {
		super()

		let user_msg_adapter = UserMsgAdapter.GetInstance()
		let local_GlobalEventSystem = GlobalEventSystem
		let local_EventName = EventName
		let model = HotPointModel.GetInstance()
		let REQUEST_SCMD = HotPointModel.REQUEST_SCMD
		let UPDATE_VIEW = CustomActivityDefine.EVENT.UPDATE_VIEW

		model.Bind(REQUEST_SCMD, (scmd, ...new_args) => {
			let args = new_args

			if (scmd == 33300) {
				this.SendFmtToGame(scmd)
			} else if (scmd == 33302
				|| scmd == 33303) {
				this.SendFmtToGame(scmd, "hh", args[0], args[1])
			} else if (scmd == 33304) {
				this.SendFmtToGame(scmd, "hhh", args[0], args[1], args[2])
			}

		}
		)

		local_GlobalEventSystem.Bind(local_EventName.GAME_START, () => {
			this.SendFmtToGame(33300)
		}
		)

		let On33300 = () => {
			let scmd = user_msg_adapter.GetSCMD(33300)
			model.SetActInfo(scmd)
		}

		let On33302 = () => {
			let scmd = user_msg_adapter.GetSCMD(33302)
			model.SetActData(scmd)
			CustomActivityModel.GetInstance().Fire(UPDATE_VIEW, scmd.base_type, scmd.sub_type, 33302)
		}

		let On33303 = () => {
			let scmd = user_msg_adapter.GetSCMD(33303)
			model.SetActReward(scmd)
			CustomActivityModel.GetInstance().Fire(UPDATE_VIEW, scmd.base_type, scmd.sub_type, 33303)
		}

		let On33304 = () => {
			let scmd = user_msg_adapter.GetSCMD(33304)
			model.SetResult(scmd)
		}

		let On33305 = () => {
			let scmd = user_msg_adapter.GetSCMD(33305)
			model.UpdataActData(scmd)
			model.Fire(REQUEST_SCMD, 33303, scmd.base_type, scmd.sub_type)
			CustomActivityModel.GetInstance().Fire(UPDATE_VIEW, scmd.base_type, scmd.sub_type, 33305)
		}

		let On33306 = () => {
			let scmd = user_msg_adapter.GetSCMD(33306)
			Util.ErrorCodeShow(scmd.error_code)
		}

		this.RegisterProtocal(33300, On33300)	//嗨点信息
		this.RegisterProtocal(33302, On33302)	//嗨点详情
		this.RegisterProtocal(33303, On33303)	//获取奖励领取状态
		this.RegisterProtocal(33304, On33304)	//领取活动奖励
		this.RegisterProtocal(33305, On33305)	//单次嗨点信息（主动推送）
		this.RegisterProtocal(33306, On33306)	//统一错误出口
	}
}
window["HotPointController"]=HotPointController
