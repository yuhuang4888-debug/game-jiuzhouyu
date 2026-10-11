import { BaseController } from "../common/BaseController"
import { ListDuobaoModel } from "../commonModel/ListDuobaoModel"
import { UserMsgAdapter } from "../common/UserMsgAdapter"
import { Config } from "../common/Config"

import "../ListDuobao/ListDuobaoView"
import { ErlangParser } from "../util/ErlangParser"
import { CongratulationObtainView } from "../common/CongratulationObtainView"

export class ListDuobaoController extends BaseController {
	model
	user_msg_adapter
	view_dic

	public constructor() {
		super()

		this.model = ListDuobaoModel.GetInstance()
		this.user_msg_adapter = UserMsgAdapter.GetInstance()
		this.view_dic = []
		this.RegisterAll()
		this.InitEvent()
	}

	public InitEvent() {
		this.model.Bind(ListDuobaoModel.REQUEST_SCMD, (...new_args) => {
			let arg = new_args
			if (arg[0] == 33252) {
				this.SendFmtToGame(33252, "hh", arg[1], arg[2])
			} else if (arg[0] == 33253) {
				this.SendFmtToGame(33253, "hh", arg[1], arg[2])
			} else if (arg[0] == 33254) {
				this.SendFmtToGame(33254, "hhh", arg[1], arg[2], arg[3])
			}
		})

		this.model.Bind(ListDuobaoModel.OPEN_VIEW, (view_name: string, ...new_args) => {
			let view = this.view_dic[view_name]
			if (!view && view_name) {
				view = new window[view_name]()
				this.view_dic[view_name] = view
			}

			if (view) {
				if (view.HasOpen()) {
					view.Close()
				} else {
					view.Open(...new_args)
				}
			}
		})

		this.model.Bind(ListDuobaoModel.TEST_EVENT, (scmd) => {
			if (scmd.type == this.model.base_type && scmd.subtype == this.model.sub_type) {
				let key = scmd.type + "@" + scmd.subtype + "@" + scmd.reward_id
				let cfg = Config.PRELOAD_SERVER_CONFIG.config_rush_treasure_stage_reward[key]
				if (cfg && cfg.reward) {
					let reward = ErlangParser.GetInstance().Parse(cfg.reward)
					let success_view = new CongratulationObtainView(reward, 10)
					success_view.Open()
				}
			}
		})
	}

	public RegisterAll() {
		let On33254 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(33254)
			if (scmd.type == this.model.base_type && scmd.subtype == this.model.sub_type) {
				let key = scmd.type + "@" + scmd.subtype + "@" + scmd.reward_id
				let cfg = Config.PRELOAD_SERVER_CONFIG.config_rush_treasure_stage_reward[key]
				if (cfg && cfg.reward) {
					let reward = ErlangParser.GetInstance().Parse(cfg.reward)
					let success_view = new CongratulationObtainView(reward, 10)
					success_view.Open()
				}
			}
			this.model.Fire(ListDuobaoModel.REQUEST_SCMD, 33252, this.model.base_type, this.model.sub_type)
		}

		let On33252 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(33252)
			this.model.SetData(scmd)
		}

		let On33253 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(33253)
			this.model.SetRankData(scmd)
		}

		this.RegisterProtocal(33254, On33254)
		this.RegisterProtocal(33252, On33252)
		this.RegisterProtocal(33253, On33253)
	}
}
window["ListDuobaoController"] = ListDuobaoController