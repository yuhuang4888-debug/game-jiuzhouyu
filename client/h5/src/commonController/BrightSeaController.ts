

import { AutoFightManager } from "../autofight/AutoFightManager"
import { BaseController } from "../common/BaseController"
import { CongratulationObtainView } from "../common/CongratulationObtainView"
import { EventName, LoginStateEvent } from "../common/EventName"
import { table } from "../common/table"
import { UserMsgAdapter } from "../common/UserMsgAdapter"
import { BrightSeaEvent, BrightSeaModel, CruiseState, SeaNotificationType } from "../commonModel/BrightSeaModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { GuildModel } from "../commonModel/GuildModel"
import { SceneManager } from "../scene/SceneManager"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { Util } from "../util/Util"
import { MainUIController } from "./MainUIController"

import "../commonModel/BrightSeaModel"
import "../brightSea/BrightSeaBattleResultItem"
import "../brightSea/BrightSeaBattleResultView"
import "../brightSea/BrightSeaCruiseItem"
import "../brightSea/BrightSeaCruiseLogItem"
import "../brightSea/BrightSeaCruiseLogView"
import "../brightSea/BrightSeaCruiseView"
import "../brightSea/BrightSeaEnterView"
import "../brightSea/BrightSeaFightSceneView"
import "../brightSea/BrightSeaGuildHelpDialog"
import "../brightSea/BrightSeaPlunderDialog"
import "../brightSea/BrightSeaPlunderLogItem"
import "../brightSea/BrightSeaPlunderLogView"
import "../brightSea/BrightSeaResultView"
import "../brightSea/BrightSeaRoleItem"
import "../brightSea/BrightSeaSchItem"
import "../brightSea/BrightSeaSchedule"
import "../brightSea/BrightSeaThanksDialog"
import { ResManager } from "../common/ResManager"
import { Message } from "../sysInfo/SysInfoController"
import { Config } from "../common/Config"
import { OpenFun } from "../common/OpenFun"

export class BrightSeaController extends BaseController {
	ChangeScene
	ChangeSceneBegin
	CloseView
	Init
	SetMainUIVisible
	ShowRankBreachReward
	view_dic

	public constructor() {
		super()


		this.view_dic = []
		let brightSea_model: BrightSeaModel = BrightSeaModel.GetInstance()
		//let guild_model = GuildModel.GetInstance()
		let brightSea_event = BrightSeaEvent
		let notification_type = SeaNotificationType
		let cruise_state = CruiseState
		let local_GlobalEventSystem = GlobalEventSystem
		let local_EventName = EventName
		let local_SceneManager = SceneManager
		let user_msg_adapter = UserMsgAdapter.GetInstance()
		let mainUI_controller = MainUIController.GetInstance()
		let auto_fight_mgr = AutoFightManager.GetInstance()

		brightSea_model.InitConfig()
		this.Init = () => {
			local_GlobalEventSystem.Bind(local_EventName.GAME_START, () => {
				brightSea_model.InitConfig()
				brightSea_model.Fire(BrightSeaEvent.REQUEST_PROTO, 18900)
				brightSea_model.Fire(brightSea_event.REQUEST_PROTO, 18917)
				
			})

			brightSea_model.Bind(brightSea_event.OPEN_VIEW, (view_name, ...new_args) => {
				let view = this.view_dic[view_name]
				if (!view) {
					this.view_dic[view_name] = true
					if (this.view_dic[view_name] == true) {
						let view_class:any = window[view_name]
						if (!view_class) {
							//require("game.brightSea." + view_name)
							view_class = window[view_name]
						}
						view = new view_class()
						this.view_dic[view_name] = view
					}
				}
				if (view) {
					view.Open(...new_args)
				}
			}
			)

			brightSea_model.Bind(brightSea_event.CLOSE_VIEW, (view_name?) => {
				let view = this.view_dic[view_name]
				if (view) {
					if (view != true && view.HasOpen()) {
						view.Close()
					}
					this.view_dic[view_name] = null
				}
			})

			//local_GlobalEventSystem:Bind(SceneEventType.SCENE_CHANGED,() => {
			//	this.ChangeScene()
			//})

			local_GlobalEventSystem.Bind(SceneManager.START, () => {
				this.ChangeScene()
			})

			//@@@
			// local_GlobalEventSystem.Bind(LoginStateEvent.SHOW_LOGIN_VIEW, () => {
			// 	// 登出就会被踢出
			// 	this.SetMainUIVisible(true)
			// 	brightSea_model.Fire(brightSea_event.CLOSE_VIEW, "BrightSeaFightSceneView")
			// })

			let Proto2Fmt = {
				[18904] : "l",
				[18905] : "lilc",
				[18909] : "lc",
				[18914] : "cc",
			}
			brightSea_model.Bind(brightSea_event.REQUEST_PROTO, (cmd, ...new_args) => {
				let fmt = Proto2Fmt[cmd] || null
				let params = new_args
				console.log("BrightSea send cmd: ", fmt)
				//PrintTable(params)
				if (fmt) {
					this.SendFmtToGame(cmd, fmt, ...new_args)
				} else {
					this.SendFmtToGame(cmd)
				}
			})

			// 主界面信息
			let On18900 = () => {
				let scmd = user_msg_adapter.GetSCMD(18900)
				brightSea_model.SetSendList(scmd.send_list)
				brightSea_model.SetMainViewInfo(scmd)

				//巡航次数
				let red_status = false
				// 状态信息  正在巡航中，但还有巡航次数时不显示红点
				if(scmd.auto_id!=0&&scmd.status==0){
					red_status = false
				}else{
				if (scmd.status) {
					red_status = scmd.status == cruise_state.CanReward && scmd.auto_id != 0
				}
				if (!red_status) {
					if (scmd.reward_times!=null && scmd.total_reward_times) {
						let have_num = scmd.total_reward_times - scmd.reward_times
						red_status = have_num > 0
					}
					}
				}
				brightSea_model.SetRedState(red_status)
				//掠夺情况
				brightSea_model.SetRobStatus()
				brightSea_model.UpdateBrightSeaRedAll()
			}

			let On18901 = () => {
				let scmd = user_msg_adapter.GetSCMD(18901)
				if (scmd.log_list) {
					brightSea_model.SetCruiseLog(scmd.log_list)
				}
			}

			let On18902 = () => {
				let scmd = user_msg_adapter.GetSCMD(18902)
				// 船只界面信息
				brightSea_model.Fire(brightSea_event.UPDATE_SHIP_INFO, scmd)
			}

			let On18903 = () => {
				// 开始巡航
				let scmd = user_msg_adapter.GetSCMD(18903)
				if (scmd.code == 1) {
					brightSea_model.Fire(brightSea_event.REQUEST_PROTO, 18900)
					brightSea_model.Fire(brightSea_event.CRUISE_CALLBACK)
				} else {
					Util.ErrorCodeShow(scmd.code)
				}
			}

			let On18904 = () => {
				let scmd = user_msg_adapter.GetSCMD(18904)
				brightSea_model.SetCruiseResult(scmd)
				brightSea_model.AddCruiseNotification(notification_type.Result, scmd)
				brightSea_model.Fire(brightSea_event.UPDATE_CRUISE_RET)
			}

			let On18905 = () => {
				let scmd = user_msg_adapter.GetSCMD(18905)
				// 开始掠夺
				if (scmd.code == 1) {

				} else {
					Util.ErrorCodeShow(scmd.code)
				}
			}

			let On18906 = () => {
				let scmd = user_msg_adapter.GetSCMD(18906)
				// 战斗预告
				let scene_mgr = SceneManager.Instance
				if (scmd["state"] == 1) {
					if (scene_mgr.IsBrightSeaScene()) {
						auto_fight_mgr.SetAutoFight(false)
					}
				} else if (scmd.stage == 2) {
					if (scene_mgr.IsBrightSeaScene()) {
						auto_fight_mgr.SetAutoFight(true)
					}
				} else if (scmd.stage == 0) {
					brightSea_model.combat_power = scmd.combat_power
				}
				brightSea_model.Fire(brightSea_event.UPDATE_FIGHT_INFO, scmd.stage, scmd.time)
				GuildModel.GetInstance().SetAssistData(null)
			}

			let On18907 = () => {
				let scmd = user_msg_adapter.GetSCMD(18907)
				// 战斗结果
				brightSea_model.result_info = scmd
				brightSea_model.Fire(brightSea_event.BATTLE_RESULT)
			}

			let On18908 = () => {
				let scmd = user_msg_adapter.GetSCMD(18908)
				// 复仇成功通知(协助)->推送
				brightSea_model.AddCruiseNotification(notification_type.GuildHelp, scmd)
			}

			let On18909 = () => {
				let scmd = user_msg_adapter.GetSCMD(18909)
				// 领取奖励
				if (scmd.code == 1) {
					if (scmd.reward && scmd.reward.length>0) {
						let rewardsList = GoodsModel.RewardKeyToNumber(scmd.reward)
						let view = new CongratulationObtainView(rewardsList, 10)
						view.Open()
					} else {
						Message.show("奖励为空");
					}
					brightSea_model.Fire(brightSea_event.RECEIVE_REWARD)
					brightSea_model.Fire(brightSea_event.REQUEST_PROTO, 18900)
				} else {
					Util.ErrorCodeShow(scmd.code)
				}
			}

			let On18910 = () => {
				let scmd = user_msg_adapter.GetSCMD(18910)
				// 新增巡航日志
				let curise_log_list = brightSea_model.curise_log_list || []
				let be_plunder = false
				if (scmd.log_list) {
					//console.log("______________________18910_______________________")
					//PrintTable(scmd.log_list)
					for (let _ = 0; _ < scmd.log_list.length; _++) {
						var log = scmd.log_list[_]
						// 1 被掠夺
						if (log.type == 1 && !brightSea_model.InCruiseLogList(log.auto_id)) {
							be_plunder = true
						}
						table.insert(curise_log_list, log)
					}
					brightSea_model.SetCruiseLog(curise_log_list)
					if (be_plunder) {
						brightSea_model.AddCruiseNotification(notification_type.BePlunder, {})
					}
				}
			}

			let On18911 = () => {
				let scmd = user_msg_adapter.GetSCMD(18911)
				// 新增巡航船只
				if (scmd.send_list) {
					for (let _ in scmd.send_list) {
						var data = scmd.send_list[_]
						brightSea_model.AppendToSendList(data)
					}
					brightSea_model.Fire(brightSea_event.UPDATE_SEND_LIST_ADD)
					brightSea_model.SetRobStatus()
					brightSea_model.UpdateBrightSeaRedAll()
				}
			}

			let On18912 = () => {
				let scmd = user_msg_adapter.GetSCMD(18912)
				// 其他玩家协助成功，已方战斗失败
				//console.log("___________________其他玩家协助成功，已方战斗失败_____________________")
				// 踢出
				if (scmd.code == 1) {
					brightSea_model.Fire(brightSea_event.CLOSE_VIEW, "BrightSeaFightSceneView")
				}
			}

			let On18913 = () => {
				let scmd = user_msg_adapter.GetSCMD(18913)
				// 退出战斗场景
				//console.log("__________退出场景______18913")
			}

			let On18914 = () => {
				let scmd = user_msg_adapter.GetSCMD(18914)
				if (scmd.code == 1) {
					brightSea_model.Fire(brightSea_event.UPDATE_LEVELUP_SHIP, scmd)
					// 升级船只
					//brightSea_model.Fire(brightSea_event.REQUEST_PROTO, 18902)
				} else {
					Util.ErrorCodeShow(scmd.code)
				}
			}

			let On18915 = () => {
				let scmd = user_msg_adapter.GetSCMD(18915)
				brightSea_model.serInfo = scmd

				let cfg = Config.PRELOAD_SERVER_CONFIG.config_sea_treasure_mod
						if (cfg) {
					brightSea_model.startRound = cfg[scmd["mode_num"]] && cfg[scmd["mode_num"]].start_round || 1
						}
						brightSea_model.Fire(brightSea_event.UPDATE_SERVER_INFO)
			}

			let On18916 = () => {
				let scmd = user_msg_adapter.GetSCMD(18916)
				// 绑钻信息
				brightSea_model.SetAssitLimt(scmd.num>=scmd.max)
				brightSea_model.Fire(brightSea_event.UPDATE_DIAMOND_INFO, scmd)
			}

			let On18917 = () => {
				let scmd = user_msg_adapter.GetSCMD(18917)
				let red_status = false
				// 状态信息 正在巡航中，但还有巡航次数时不显示红点
				if(scmd.auto_id!=0&&scmd.status==0){
					red_status = false
				}else{
				if (scmd.status) {
					red_status = scmd.status == cruise_state.CanReward && scmd.auto_id != 0
				}
				if (!red_status) {
					if (scmd.reward_times!=null && scmd.total_reward_times) {
						let have_num = scmd.total_reward_times - scmd.reward_times
						red_status = have_num > 0
						}
					}
				}
				brightSea_model.SetRedState(red_status)
				//掠夺情况
				brightSea_model.SetRobStatus()
				brightSea_model.UpdateBrightSeaRedAll()
			}

			let On18918 = () => {
				let scmd = user_msg_adapter.GetSCMD(18918)
				if (scmd.code != 1) {
					// 错误码显示
					Util.ErrorCodeShow(scmd.code)
				}
			}

			let On18919 = () => {
				let scmd = user_msg_adapter.GetSCMD(18919)
				if (scmd.auto_id) {
					brightSea_model.RemoveNotificationByAutoId(scmd.auto_id)
				}
			}

			let On18920 = () => {
				let scmd = user_msg_adapter.GetSCMD(18920)
				// 错误码显示
				Util.ErrorCodeShow(scmd.code)
			}

			this.RegisterProtocal(18900, On18900) // 主界面信息
			this.RegisterProtocal(18901, On18901) // 获取巡航日志
			this.RegisterProtocal(18902, On18902) // 船只界面信息
			this.RegisterProtocal(18903, On18903) // 开始巡航
			this.RegisterProtocal(18904, On18904) // 巡航结束通知
			this.RegisterProtocal(18905, On18905) // 开始掠夺
			this.RegisterProtocal(18906, On18906) // 战斗预告
			this.RegisterProtocal(18907, On18907) // 战斗结果
			this.RegisterProtocal(18908, On18908) // 复仇成功通知
			this.RegisterProtocal(18909, On18909) // 领取奖励
			this.RegisterProtocal(18910, On18910) // 新增巡航日志
			this.RegisterProtocal(18911, On18911) // 新增巡航船只
			this.RegisterProtocal(18912, On18912) // 其他玩家协助成功，已方战斗失败
			this.RegisterProtocal(18913, On18913) // 退出战斗场景
			this.RegisterProtocal(18914, On18914) // 升级船只
			this.RegisterProtocal(18915, On18915) // 跨服信息
			this.RegisterProtocal(18916, On18916) // 绑钻信息
			this.RegisterProtocal(18917, On18917) // 璀璨之海状态信息
			this.RegisterProtocal(18918, On18918) // 退出场景
			this.RegisterProtocal(18919, On18919) // 清除奖励通知

			this.RegisterProtocal(18920, On18920) // 领取奖励
		}

		this.ChangeSceneBegin = () => {
			let scene_mgr = SceneManager.Instance
			if (!scene_mgr.IsBrightSeaScene() && scene_mgr.IsBrightSeaScene(scene_mgr.GetLastSceneId())) {
				brightSea_model.Fire(brightSea_event.CLOSE_VIEW, "BrightSeaFightSceneView")
				this.SetMainUIVisible(true)
			}
		}

		this.CloseView = () => {
			brightSea_model.Fire(brightSea_event.CLOSE_VIEW, "BrightSeaPlunderDialog")
			brightSea_model.Fire(brightSea_event.CLOSE_VIEW, "BrightSeaPlunderLogView")
			brightSea_model.Fire(brightSea_event.CLOSE_VIEW, "BrightSeaCruiseLogView")
			brightSea_model.Fire(brightSea_event.CLOSE_VIEW, "BrightSeaResultView")
			local_GlobalEventSystem.Fire(local_EventName.CLOSE_VIEW, "GuildHelpView")
			local_GlobalEventSystem.Fire(local_EventName.CLOSE_VIEW, "GuildHelpTipsView")
		}

		this.ChangeScene = () => {
			let scene_mgr = SceneManager.Instance
			if (scene_mgr.IsBrightSeaScene() && !scene_mgr.IsBrightSeaScene(scene_mgr.GetLastSceneId())) {
				this.CloseView()
				brightSea_model.Fire(brightSea_event.OPEN_VIEW, "BrightSeaFightSceneView")

				this.SetMainUIVisible(false)
				//AutoFightManager:GetInstance():SetAutoFight(false)
			} else if (!scene_mgr.IsBrightSeaScene() && scene_mgr.IsBrightSeaScene(scene_mgr.GetLastSceneId())) {
				this.SetMainUIVisible(true)
				brightSea_model.Fire(brightSea_event.CLOSE_VIEW, "BrightSeaFightSceneView")
				this.CloseView()
				OpenFun.OpenFunHandler(197)
				//AutoFightManager:GetInstance():SetAutoFight(true)
			}
		}

		this.SetMainUIVisible = (bool?) => {
			mainUI_controller.SetMainUIViewVisible(0, bool)
			mainUI_controller.SetMainUIViewVisible(1, bool)
			mainUI_controller.SetMainUIViewVisible(2, bool)
			mainUI_controller.SetMainUIViewVisible(5, bool)
			mainUI_controller.SetMainUIViewVisible(11, bool)
			//mainUI_controller:SetMainUIViewVisible(14, bool)
			mainUI_controller.SetMainUIViewVisible(15, bool)
			mainUI_controller.SetHeadVisible(bool)
			mainUI_controller.SetMapVisible(bool)
			mainUI_controller.SetCareerLevelVisible(bool)
			//mainUI_controller:SetMarriForeshowVisible(bool)
		}

		this.ShowRankBreachReward = (scmd?) => {
			let data = []
			for (let _tmpi in scmd.reward) {
				var reward = scmd.reward[_tmpi]
				let vo = []
				table.insert(vo, reward.style)
				table.insert(vo, reward.typeId)
				table.insert(vo, reward.count)
				table.insert(data, vo)
			}
			if (data.length > 0) {
				let view = new CongratulationObtainView(data, 10)
				view.Open()
				brightSea_model.Fire(brightSea_event.REQUEST_PROTO, 28001)
			}
		}

		this.Init()
	}
}

window["BrightSeaController"] = BrightSeaController