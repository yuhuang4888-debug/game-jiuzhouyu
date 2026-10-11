
//require("game.proto.204.Require204")
//require("game.tsCrack.TSCrackModel")
//require("game.tsCrack.RequireTSCrack")

import { BaseController } from "../common/BaseController"
import { EventName } from "../common/EventName"
import { ResManager } from "../common/ResManager"
import { UserMsgAdapter } from "../common/UserMsgAdapter"
import { RoleManager } from "../commonModel/RoleManager"
import { TSCrackModel } from "../commonModel/TSCrackModel"
import { SceneManager } from "../scene/SceneManager"
import { Message } from "../sysInfo/SysInfoController"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { ErlangParser } from "../util/ErlangParser"
import { Util } from "../util/Util"

import "../tsCrack/TSCrackDescView"
import "../tsCrack/TSCrackInstructionView"
import "../tsCrack/TSCrackScrambleView"
import "../tsCrack/TSCrackSeasonView"
import "../tsCrack/TSCrackStrongholdMsgView"
import "../tsCrack/TSCrackTargetView"
import "../tsCrack/TSCrackTeleportView"
import "../tsCrack/TSCrackMainView"
export class TSCrackController extends BaseController {
	res_mgr
	scene_mgr
	ts_crack_model
	use_msg_adapter

	static Instance



	public constructor() {
		super()

		if (TSCrackController.Instance != null) {
			//error("attempt to create singleton(TSCrackController) twice!")
			return
		}
		TSCrackController.Instance = this

		this.ts_crack_model = TSCrackModel.GetInstance()
		this.res_mgr = RoleManager.GetInstance()
		this.use_msg_adapter = UserMsgAdapter.GetInstance()
		this.scene_mgr = SceneManager.GetInstance()

		this.InitEvent()
		this.RegisterAllProtocals()
	}

	public InitEvent() {


		this.ts_crack_model.Bind(TSCrackModel.REQUEST_PROTO, (id, ...new_args) => {
			let parms = new_args
			let case1 = () => {
				this.SendFmtToGame(id, "h", parms[0])
			}
			switch (id) {
				case 20403:
					case1()
					break;
				case 20402:
					case1()
					break;
				case 20408:
					case1()
					break;
				case 20406:
					this.SendFmtToGame(id, "c", parms[0])
					break;

				default:
					this.SendFmtToGame(id)
					break;
			}





		})

		GlobalEventSystem.Bind(EventName.GAME_START, () => {
			this.ts_crack_model.Fire(TSCrackModel.REQUEST_PROTO, 20411)
		})

		let _level_time_id = null
		this.res_mgr.GetMainRoleVo().Bind(EventName.CHANGE_LEVEL, (level?) => {
			ResManager.GetInstance().GetGameConfigWithAutoDestory("config_chrono_rift_castle_kv", (cfg_) => {
				if (!_level_time_id) {
					_level_time_id = setTimeout(() => {
						let lv_limit_cfg = cfg_ && cfg_["lv_limit"]
						if (lv_limit_cfg) {
							if (level >= lv_limit_cfg.value) {
								this.ts_crack_model.Fire(TSCrackModel.REQUEST_PROTO, 20411)
							}
							_level_time_id = null
						}
					}, 1000)
				}
			}, false)

		})

	}

	public RegisterAllProtocals() {


		//错误码
		let is_first_20411 = false
		let On20400 = () => {
			let scmd = this.use_msg_adapter.GetSCMD(20400)
			Util.ErrorCodeShow(scmd.code)
		}

		//主界面
		let On20401 = () => {
			let scmd = this.use_msg_adapter.GetSCMD(20401)
			this.ts_crack_model.UpdateAllStrongholdData(scmd)
		}

		//单个据点界面信息 #############有争夺值的据点变更主动推.length
		let On20402 = () => {
			let scmd = this.use_msg_adapter.GetSCMD(20402)
			this.ts_crack_model.UpdateStrongholdData(scmd)
		}

		//驻扎 #############成功后推送.length 01协议
		let On20403 = () => {
			let scmd = this.use_msg_adapter.GetSCMD(20403)
			if (scmd.code == 1) {
				Message.show("传送成功")
			}
		}

		//每日争夺
		let On20404 = () => {
			let scmd = this.use_msg_adapter.GetSCMD(20404)
			this.ts_crack_model.UpdateScrambleValue(scmd)
		}

		//每日争夺奖励 ############争夺值有变动主动推送.length
		let On20405 = () => {
			let scmd = this.use_msg_adapter.GetSCMD(20405)
			this.ts_crack_model.UpdateScrambleRewardData(scmd)
		}

		//每日争夺奖励 ############成功后推送05协议.length
		let On20406 = () => {
			let scmd = this.use_msg_adapter.GetSCMD(20406)
			Message.show("领取成功")
			ResManager.GetInstance().GetGameConfigWithAutoDestory("config_chrono_rift_role_stage_reward", (cfg_) => {

				let cfg = cfg_ && cfg_[scmd.stage]
				if (cfg) {
					Util.ShowCongratulationView(JSON.parse(cfg.reward))
				}
			}, false)

		}

		//赛季目标
		let On20407 = () => {
			let scmd = this.use_msg_adapter.GetSCMD(20407)
			this.ts_crack_model.UpdateSeasonRewardData(scmd)
		}

		//领取赛季奖励
		let On20408 = () => {
			let scmd = this.use_msg_adapter.GetSCMD(20408)
			Message.show("领取成功")
			ResManager.GetInstance().GetGameConfigWithAutoDestory("config_chrono_rift_goal", (cfg_) => {
				let cfg = cfg_ && cfg_[scmd.goal_id]
				if (cfg) {
					Util.ShowCongratulationView(JSON.parse(cfg.reward))
				}
				this.ts_crack_model.Fire(TSCrackModel.REQUEST_PROTO, 20407)
			}, false)

		}

		//个人排名
		let On20409 = () => {
			let scmd = this.use_msg_adapter.GetSCMD(20409)
			this.ts_crack_model.UpdatePersonRank(scmd)
		}

		//当前据点
		let On20410 = () => {
			let scmd = this.use_msg_adapter.GetSCMD(20410)
			this.ts_crack_model.UpdateOwnerPosId(scmd)

			let last_stronghold_id = this.ts_crack_model.GetlastStrongholdId()
			if (last_stronghold_id) {
				this.ts_crack_model.Fire(TSCrackModel.REQUEST_PROTO, 20402, last_stronghold_id)
			}
			this.ts_crack_model.Fire(TSCrackModel.REQUEST_PROTO, 20402, scmd.castle_id)
		}

		//世界信息
		let On20411 = () => {
			let scmd = this.use_msg_adapter.GetSCMD(20411)
			if (scmd) {
				this.ts_crack_model.UpdateServerData(scmd)
				if (scmd.status == 1) {
					this.ts_crack_model.Fire(TSCrackModel.REQUEST_PROTO, 20401)
					this.ts_crack_model.Fire(TSCrackModel.REQUEST_PROTO, 20410)
					this.ts_crack_model.Fire(TSCrackModel.REQUEST_PROTO, 20405)
					this.ts_crack_model.Fire(TSCrackModel.REQUEST_PROTO, 20407)
					this.ts_crack_model.Fire(TSCrackModel.REQUEST_PROTO, 20409)
				}
			}
		}

		this.RegisterProtocal(20400, On20400)//错误码
		this.RegisterProtocal(20401, On20401)//主界面
		this.RegisterProtocal(20402, On20402)//单个据点界面信息 #############有争夺值的据点变更主动推.length
		this.RegisterProtocal(20403, On20403)//驻扎 #############成功后推送.length 01协议
		this.RegisterProtocal(20404, On20404)//每日争夺
		this.RegisterProtocal(20405, On20405)//每日争夺奖励 ############争夺值有变动主动推送.length
		this.RegisterProtocal(20406, On20406)//每日争夺奖励 ############成功后推送05协议.length
		this.RegisterProtocal(20407, On20407)//赛季目标
		this.RegisterProtocal(20408, On20408)//领取赛季奖励
		this.RegisterProtocal(20409, On20409)//个人排名
		this.RegisterProtocal(20410, On20410)//当前据点
		this.RegisterProtocal(20411, On20411)//世界信息
	}
}
