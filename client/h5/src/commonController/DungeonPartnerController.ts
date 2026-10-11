import { BaseController } from "../common/BaseController"
import { CongratulationObtainView } from "../common/CongratulationObtainView"
import { EventName } from "../common/EventName"
import { ResManager } from "../common/ResManager"
import { UserMsgAdapter } from "../common/UserMsgAdapter"
import { DungeonPartnerModel } from "../commonModel/DungeonPartnerModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { RoleManager } from "../commonModel/RoleManager"
import { ServerTimeModel } from "../serverTime/ServerTimeModel"
import { GlobalEventSystem, LOAD_QUEUE } from "../util/DeclareGlobalVar"
import { Util } from "../util/Util"
import { Config } from "../common/Config"

import "../commonModel/DungeonPartnerModel"

export class DungeonPartnerController extends BaseController {

	model: DungeonPartnerModel
	res_mgr: ResManager
	user_msg_adapter: UserMsgAdapter
	public constructor() {
		super()
		this.model = DungeonPartnerModel.GetInstance()
		this.res_mgr = ResManager.GetInstance()
		this.user_msg_adapter = UserMsgAdapter.GetInstance()
		this.RegisterAllProtocals()
		this.InitEvents()
	}

	public InitEvents() {

		//请求协议
		let onRequestHandler = (...new_args) => {
			let args_list = new_args
			if (args_list[0] == 61102) {
				this.WriteBegin(61102)
				this.WriteFMT("i", args_list[1])
				let pet_arr = args_list[2]
				this.WriteFMT("h", pet_arr.length)
				for (let _ in pet_arr) {
					let v = pet_arr[_]
					this.WriteFMT("i", v)
				}
				this.SendToGame()
			} else if (args_list[0] == 61104) {
				this.SendFmtToGame(args_list[0], "i", args_list[1])
			} else if (args_list[0] == 61105) {
				this.SendFmtToGame(args_list[0], "c", args_list[1])
			} else if (args_list[0] == 61106) {
				this.SendFmtToGame(args_list[0], "c", args_list[1])
			} else if (args_list[0] == 61107) {
				this.SendFmtToGame(args_list[0], "i", args_list[1])
			} else if (args_list[0] == 61108) {
				this.SendFmtToGame(args_list[0], "cc", args_list[1], args_list[2])
			} else if (args_list[0] == 61109) {
				this.SendFmtToGame(args_list[0], "c", args_list[1])
			} else {
				this.SendFmtToGame(args_list[0])
			}
		}
		this.model.Bind(DungeonPartnerModel.REQUEST_CCMD_EVENT, onRequestHandler)


		let ResetData = () => {
			let config_partner_dun_chapter = Config.PRELOAD_SERVER_CONFIG.config_partner_dun_chapter
			if (config_partner_dun_chapter) {
				let data
				for (let i in config_partner_dun_chapter) {
					data = config_partner_dun_chapter[i]
					this.model.Fire(DungeonPartnerModel.REQUEST_CCMD_EVENT, 61105, data.chapter_id)
					this.model.Fire(DungeonPartnerModel.REQUEST_CCMD_EVENT, 61106, data.chapter_id)
				}
			}
		}

		GlobalEventSystem.Bind(
			EventName.GAME_START, () => {
				ResetData()
			}
		)

		GlobalEventSystem.Bind(
			ServerTimeModel.DAY_CHANGE, () => {
				setTimeout(() => {
					ResetData()
				},
					300
				)
			}
		)

		let refresh_red = () => {
			this.model.TryRefreshChallengeRed()
		}
		RoleManager.GetInstance().GetMainRoleVo().BindOne(
			"fighting", () => {
				Laya.timer.clear(this, refresh_red)
				Laya.timer.frameOnce(10, this, refresh_red)
			})

		
		GlobalEventSystem.Bind(EventName.UPDATE_NEWEST_TASK_ID, (newest_finish_task_id) => {
			let cfg = Config.PRELOAD_CLIENT_CONFIG.ConfigPartnerAwake
			if(cfg && newest_finish_task_id == cfg.ParnterTalkLastTaskId){
				ResetData()
			}
		})
	}



	public RegisterAllProtocals() {

		let On61105 = () => {
			let vo = this.user_msg_adapter.GetSCMD(61105)
			// console.log("on61105")
			// PrintTable(vo)
			this.model.SetViewInfo(vo)
			this.model.Fire(DungeonPartnerModel.UPDATE_PARTNER_VIEW, vo)

			//红点
			// let level = RoleManager.GetInstance().GetMainRoleVo().level
			// let fighting = RoleManager.GetInstance().GetMainRoleVo().fighting
			let left_sweep_time = this.model.GetLeftSweepTime()
			let first_level_info = this.model.GetViewInfo(1)
			if (left_sweep_time > 0 && first_level_info && first_level_info.dun_list[1].score > 0) {
				this.model.SetRedPointFlag(DungeonPartnerModel.RED_POINT_TYPE.SWEEP, true)
			} else {
				this.model.SetRedPointFlag(DungeonPartnerModel.RED_POINT_TYPE.SWEEP, false)
			}
			this.model.TryRefreshChallengeRed()
		}

		let On61106 = () => {

			let vo = this.user_msg_adapter.GetSCMD(61106)
			this.model.SetStageRewardInfo(vo)
			this.model.Fire(DungeonPartnerModel.UPDATE_PARTNER_VIEW_STAGE_REWARD, vo)

			let find = false
			let len = Util.TableSize(this.model.stage_reward_info)
			for (let i = 1; i <= len; i++) {
				let level_data = this.model.stage_reward_info[i]
				for (let _ = 0; _ < level_data.stage_reward.length; _++) {
					let v = level_data.stage_reward[_]
					if (1 == v.status) { //可领取
						this.model.SetRedPointFlag(DungeonPartnerModel.RED_POINT_TYPE.STAGE_REWARD, true)
						find = true
						break
					}
				}
			}
			if (!find) {
				this.model.SetRedPointFlag(DungeonPartnerModel.RED_POINT_TYPE.STAGE_REWARD, false)
			}
		}

		let On61107 = () => {
			let vo = this.user_msg_adapter.GetSCMD(61107)
		}

		let On61108 = () => {

			let scmd = this.user_msg_adapter.GetSCMD(61108)
			if (scmd.code == 1) {
				let reward_lists = GoodsModel.RewardKeyToNumber(scmd.reward_lists)
				let view = new CongratulationObtainView(reward_lists, 10)
				view.Open()
				this.model.Fire(DungeonPartnerModel.REQUEST_CCMD_EVENT, 61106, this.model.GetPage())
			} else {
				Util.ErrorCodeShow(scmd.code)
			}
		}

		let On61109 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(61109)
			if (scmd.code == 1) {
				let mul_reward_lists
				let is_double=false
				if (scmd.mul_reward_lists.length > 0) {
					mul_reward_lists = GoodsModel.RewardKeyToNumber(scmd.mul_reward_lists)
					for (let key in mul_reward_lists) {
						mul_reward_lists[key][6] = 1
					}
				}
				let reward_lists = GoodsModel.RewardKeyToNumber(scmd.reward_lists)
				if (mul_reward_lists) {
					reward_lists = reward_lists.concat(mul_reward_lists)
					is_double=true
				}
				let view = new CongratulationObtainView(reward_lists, 10, null, null, null, null, null, null, null, is_double)
				view.Open()
				// GlobalEventSystem.Fire(EventName.OPEN_VIEW, "DungeonPartnerMopRewardView", scmd)
				this.model.Fire(DungeonPartnerModel.REQUEST_CCMD_EVENT, 61105, this.model.GetPage())
			} else {
				Util.ErrorCodeShow(scmd.code)
			}
		}

		let On61110 = () => {
			let vo = this.user_msg_adapter.GetSCMD(61110)
			this.model.Fire(DungeonPartnerModel.UPDATE_PARTNER_SCENE_BATTLE_INFO, vo)
		}

		this.RegisterProtocal(61105, On61105)//伙伴副本界面
		this.RegisterProtocal(61106, On61106)//伙伴副本阶段奖励
		this.RegisterProtocal(61107, On61107)//伙伴副本首通
		this.RegisterProtocal(61108, On61108)//伙伴副本领取阶段奖励
		this.RegisterProtocal(61109, On61109)//伙伴副本扫荡
		this.RegisterProtocal(61110, On61110)//伙伴副本怪物信息
	}
}
window["DungeonPartnerController"] = DungeonPartnerController