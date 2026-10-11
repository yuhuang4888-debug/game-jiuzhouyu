
//require("game.proto.339.Require339")
//require("game.redPacket.RedPacketBaseView")
//require("game.redPacket.RedPacketCtrlView")
// window.originalRequire("game.redPacket.RedPacketDefine")
//require("game.redPacket.RedPacketDefine")
//require("game.redPacket.RedPacketDetailItem")
//require("game.redPacket.RedPacketDetailView")
//require("game.redPacket.RedPacketFuncItem")
//require("game.redPacket.RedPacketMainItem")
//require("game.redPacket.RedPacketMainView")
//require("game.redPacket.RedPacketModel")
//require("game.redPacket.RedPacketRecordItem")

import { BaseController } from "../common/BaseController"
import { EventName } from "../common/EventName"
import { UserMsgAdapter } from "../common/UserMsgAdapter"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { LoadLuaClassAB, Util } from "../util/Util"
import  "../redPacket/RedPacketDetailView"
import  "../redPacket/RedPacketMainView"
import  "../redPacket/RedPacketCtrlview"
import { RedPacketEvent, RedPacketModel } from "../commonModel/RedPacketModel"


export class RedPacketController extends BaseController {
	InitEvent
	InitInfo
	view_dic

	public constructor() {
		super()
		this.view_dic=[]
		let local_GlobalEventSystem = GlobalEventSystem
		let local_EventName = EventName
		let user_msg_adapter = UserMsgAdapter.GetInstance()
		let local_Util = Util
		let model = RedPacketModel.GetInstance()
		this.InitEvent = () => {
			local_GlobalEventSystem.Bind(local_EventName.INIT_CONFIG, () => {

			}
			)
			local_GlobalEventSystem.Bind(local_EventName.GAME_START, () => {
				model.Reset()
			}
			)
			model.Bind(RedPacketEvent.REQUEST_PROTO, (id, fmt, ...new_args) => {
				this.SendFmtToGame(id, fmt, ...new_args)
			}
			)

		}

		this.InitInfo = () => {
			let on33900 = () => {
				let scmd = user_msg_adapter.GetSCMD(33900)
				Util.ErrorCodeShow(scmd.errcode)
			}

			let on33901 = () => {
				let scmd = user_msg_adapter.GetSCMD(33901)
				model.SetRedPacketInfo(scmd)
			}

			let on33902 = () => {
				let scmd = user_msg_adapter.GetSCMD(33902)
				for (let _tmpi in scmd.recipient_list) {
					var info = scmd.recipient_list[_tmpi]
					info.type = scmd.type
				}
				model.SetBestRole(scmd)
				model.UpdateRedPacketInfo(scmd)
				model.SetRedMsgDic(scmd)
				local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "RedPacketDetailView", scmd)
			}

			let on33903 = () => {
				let scmd = user_msg_adapter.GetSCMD(33903)
			}

			let on33904 = () => {
				let scmd = user_msg_adapter.GetSCMD(33904)
				if (scmd.errcode == 1) {
					local_GlobalEventSystem.Fire(local_EventName.CLOSE_VIEW, "RedPacketCtrlView")
					this.SendFmtToGame(33901)
				} else {
					Util.ErrorCodeShow(scmd.errcode)
				}
			}

			let on33905 = () => {
				let scmd = user_msg_adapter.GetSCMD(33905)
				if (scmd.errcode == 1) {
					local_GlobalEventSystem.Fire(local_EventName.CLOSE_VIEW, "RedPacketCtrlView")
					this.SendFmtToGame(33901)
				} else {
					Util.ErrorCodeShow(scmd.errcode)
				}
			}

			let on33906 = () => {
				let scmd = user_msg_adapter.GetSCMD(33906)
				if (scmd.errcode == 1) {
					local_GlobalEventSystem.Fire(local_EventName.CLOSE_VIEW, "RedPacketCtrlView")
					this.SendFmtToGame(33901)
				} else if (scmd.errcode == 3390012) {
					local_GlobalEventSystem.Fire(local_EventName.CLOSE_VIEW, "RedPacketCtrlView")
					this.SendFmtToGame(33901)
					Util.ErrorCodeShow(scmd.errcode, scmd.args)
				} else {
					Util.ErrorCodeShow(scmd.errcode, scmd.args)
				}
			}

			let on33907 = () => {
				let scmd = user_msg_adapter.GetSCMD(33907)
				let info = model.GetRedPacketInfo()
				if (!info) {
					return
				}
				//table.merge(info.red_envelopes_list, scmd.red_envelopes_list)
				let arr = []
				arr = arr.concat(info.red_envelopes_list).concat(scmd.red_envelopes_list)
				model.SetRedPacketInfo(arr)
			}

			let on33908 = () => {
				let scmd = user_msg_adapter.GetSCMD(33908)
				let info = model.GetRedPacketInfo()
				if (!info) {
					return
				}
				for (let _tmpi in info.red_envelopes_list) {
					var data = info.red_envelopes_list[_tmpi]
					if (data.id == scmd.id) {
						data.status = 2
						if (data.receuve_status == 2) {
							data.receuve_status = 0
						}
						data.recipients_num = data.total_num
						break
					}
				}
				model.SetRedPacketInfo(info)
			}

			this.RegisterProtocal(33900, on33900)
			this.RegisterProtocal(33901, on33901)
			this.RegisterProtocal(33902, on33902)
			this.RegisterProtocal(33903, on33903)
			this.RegisterProtocal(33904, on33904)
			this.RegisterProtocal(33905, on33905)
			this.RegisterProtocal(33906, on33906)
			this.RegisterProtocal(33907, on33907)
			this.RegisterProtocal(33908, on33908)
		}

		this.InitInfo()
		this.InitEvent()
	}
}

window["RedPacketController"] = RedPacketController