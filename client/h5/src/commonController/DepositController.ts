import { BaseController } from "../common/BaseController"
import { EventName } from "../common/EventName"
import { table } from "../common/table"
import { UserMsgAdapter } from "../common/UserMsgAdapter"
import { DepositModel } from "../commonModel/DepositModel"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { TimeUtil } from "../util/TimeUtil"
import { Util } from "../util/Util"


import "../deposit/DepositRecordView";
import "../deposit/DepositExchangeView";
import "../deposit/DepositSettingGuildEvening";
import "../deposit/DepositSettingTopPk";


export class DepositController extends BaseController {
	model:DepositModel
	public constructor() {
		super()
		this.model = DepositModel.GetInstance()
		this.RegisterAllProtocals()
		this.InitEvents()

	}

	public InitEvents() {
		let ResetData = () => {

		}

		GlobalEventSystem.Bind(
			EventName.GAME_START, async() => {
				// await this.model.InitConfig()
				ResetData()
				this.model.Fire(DepositModel.REQUEST_CCMD_EVENT, 19201)
			}
		)
		//请求协议
		var onRequestHandler = (...new_args) => {
			let args_list = new_args
			if (args_list[0] == 19202) {
				this.SendFmtToGame(args_list[0], "hh", args_list[1], args_list[2])
			} else if (args_list[0] == 19203) {
				this.SendFmtToGame(args_list[0], "hh", args_list[1], args_list[2])
			} else if (args_list[0] == 19204) {
				this.SendFmtToGame(args_list[0], "hhhh", args_list[1], args_list[2], args_list[3],args_list[4]||0)
			} else if (args_list[0] == 19205) {
				this.SendFmtToGame(args_list[0], "hhhh", args_list[1], args_list[2], args_list[3])
			} else if (args_list[0] == 19207) {
				this.SendFmtToGame(args_list[0], "i", args_list[1])
			} else {
				this.SendFmtToGame(args_list[0])
			}
		}
		this.model.Bind(DepositModel.REQUEST_CCMD_EVENT, onRequestHandler)
	}

	public RegisterAllProtocals() {
		this.RegisterProtocal(19201, "on19201")
		this.RegisterProtocal(19202, "on19202")
		this.RegisterProtocal(19203, "on19203")
		this.RegisterProtocal(19204, "on19204")
		this.RegisterProtocal(19205, "on19205")
		this.RegisterProtocal(19206, "on19206")
		this.RegisterProtocal(19207, "on19207")
		this.RegisterProtocal(19208, "on19208")
	}

	public on19201 = ()=> {

		let vo = UserMsgAdapter.GetInstance().GetSCMD("19201")
		this.model.info = vo
		this.model.SetDepositValue(vo.onhook_coin,vo.day_coin)
		this.model.Fire(DepositModel.UPDATE_INFO, vo)
	}

	public on19202 = ()=>{
		let vo = UserMsgAdapter.GetInstance().GetSCMD("19202")
		if (vo.code == 1) {
			this.model.Fire(DepositModel.DEPOSIT_SELECT, vo)
		} else {
			Util.ErrorCodeShow(vo.code)
		}
	}

	public on19203 = ()=> {
		let vo = UserMsgAdapter.GetInstance().GetSCMD("19203")
		if (vo.code == 1) {
			this.model.Fire(DepositModel.DEPOSIT_UNSELECT, vo)
		} else {
			Util.ErrorCodeShow(vo.code)
		}
	}

	public on19204 = ()=> {
		let vo = UserMsgAdapter.GetInstance().GetSCMD("19204")
		if (vo.code == 1) {
			this.model.SetDeposit(vo.module_id, vo.sub_module, true)
			let data = this.model.GetDepositData(vo.module_id, vo.sub_module)
			let find = false
			if (data) {
				for (let _ = 0; _ < data.behaviour_list.length; _++) {
					var v = data.behaviour_list[_]
					if (v.behaviour_id == vo.behaviour_id) {
						v.b_select_time = TimeUtil.getServerTime()
						v.times = vo["times"]
						find = true
					}
				}
			}
			if (!find) {
				table.insert(data.behaviour_list, { "behaviour_id":vo.behaviour_id, "b_select_time" : TimeUtil.getServerTime(),"times":vo["times"]})
			}
			this.model.Fire(DepositModel.DEPOSIT_BEHAVIOUR_SELECT, vo)
			// this.model.Fire(DepositModel.REQUEST_CCMD_EVENT, 19201)
		} else {
			Util.ErrorCodeShow(vo.code)
		}
	}

	public on19205 = ()=>{
		let vo = UserMsgAdapter.GetInstance().GetSCMD("19205")
		if (vo.code == 1) {
			let data = this.model.GetDepositData(vo.module_id, vo.sub_module)
			if (data) {
				for (let _ = 0; _ < data.behaviour_list.length; _++) {
					var v = data.behaviour_list[_]
					if (v.behaviour_id == vo.behaviour_id) {
						v.b_select_time = 0
					}
				}
			}
			this.model.Fire(DepositModel.DEPOSIT_BEHAVIOUR_UNSELECT, vo)
			// this.model.Fire(DepositModel.REQUEST_CCMD_EVENT, 19201)
		} else {
			Util.ErrorCodeShow(vo.code)
		}
	}

	public on19206 = ()=>{
		let vo = UserMsgAdapter.GetInstance().GetSCMD("19206")
		this.model.Fire(DepositModel.UPDATE_RECORD_LIST, vo)
	}

	public on19207 = ()=> {
		let vo = UserMsgAdapter.GetInstance().GetSCMD("19207")
		if (vo.code == 1) {
			this.model.SetDepositValue(vo.onhook_coin, this.model.GetNowDayDepositValue())
		} else {
			Util.ErrorCodeShow(vo.code)
		}
	}

	public on19208 = ()=>{
		let vo = UserMsgAdapter.GetInstance().GetSCMD("19208")
		this.model.SetDepositValue(vo.onhook_coin, vo.day_coin)
	}
}


window["DepositController"] = DepositController