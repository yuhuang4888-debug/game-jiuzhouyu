
//require("game.proto.280.Require280")
//require("game.arena.ArenaBattleRecordItem")
//require("game.arena.ArenaBattleRecordView")
//require("game.arena.ArenaBuyTimesView")
//require("game.arena.ArenaEnterRoleItem")
//require("game.arena.ArenaEnterView")
//require("game.arena.ArenaFightSceneView")
//require("game.arena.ArenaModel")
//require("game.arena.ArenaRankBreachRewardView")
//require("game.arena.ArenaRankRewardItem")
//require("game.arena.ArenaRankRewardMainView")
//require("game.arena.ArenaRankRewardView")
//require("game.arena.ArenaRankTabItem")
//require("game.arena.ArenaResultView")

import { BaseEnterDefine } from "../baseEnterView/BaseEnterDefine"
import { BaseController } from "../common/BaseController"
import { CongratulationObtainView } from "../common/CongratulationObtainView"
import { EventName, SceneEventType } from "../common/EventName"
import { table } from "../common/table"
import { UserMsgAdapter } from "../common/UserMsgAdapter"
import { ArenaModel } from "../commonModel/ArenaModel"
import { MedalModel } from "../commonModel/MedalModel"
import { TaskModel } from "../commonModel/TaskModel"
import { SceneManager } from "../scene/SceneManager"
import { ServerTimeModel } from "../serverTime/ServerTimeModel"
import { Message } from "../sysInfo/SysInfoController"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { NotEnougnDiamond, Util } from "../util/Util"
import { MainUIController } from "./MainUIController"
import { Config } from "../common/Config"
import "../arena/ArenaBuyTimesView"
import "../arena/ArenaFightSceneView"
import "../arena/ArenaRankRewardMainView"
import "../arena/ArenaResultView"
import "../arena/ArenaBattleRecordView"
import "../arena/ArenaEnterView"
import { ResManager } from "../common/ResManager"
import { Scene } from "../scene/Scene"
import { SceneObj } from "../scene/sceneobj/SceneObj"

export class ArenaController extends BaseController {
	ChangeScene
	ChangeSceneBegin
	Init
	SetMainUIVisible
	ShowRankBreachReward
	view_dic

	public constructor() {
		super()


		this.view_dic = []
		let arena_model = ArenaModel.GetInstance()
		let local_GlobalEventSystem = GlobalEventSystem
		let local_EventName = EventName
		let local_ArenaModel = ArenaModel
		let local_SceneManager = SceneManager
		let user_msg_adapter = UserMsgAdapter.GetInstance()
		let mainUI_controller = MainUIController.GetInstance()

		this.Init = () => {
			local_GlobalEventSystem.Bind(local_EventName.GAME_START, () => {

				arena_model.InitConfig()

				arena_model.Fire(local_ArenaModel.REQUEST_CCMD_EVENT, 28004)
				arena_model.Fire(local_ArenaModel.REQUEST_CCMD_EVENT, 28001)
			}
			)

			arena_model.Bind(local_ArenaModel.OPEN_VIEW, (view_name: string, ...new_args) => {
				let view = this.view_dic[view_name]
				if (!view) {
					this.view_dic[view_name] = true
					if (this.view_dic[view_name] == true) {
						let view_class = window[view_name]
						view = new view_class()
						this.view_dic[view_name] = view
					}
				}
				if (view) {
					view.Open(...new_args)
				}
			}
			)

			arena_model.Bind(local_ArenaModel.CLOSE_VIEW, (view_name?) => {
				let view = this.view_dic[view_name]
				if (view) {
					if (view != true && view.HasOpen()) {
						view.Close()
					}
					this.view_dic[view_name] = null
				}
			}
			)

			local_GlobalEventSystem.Bind(SceneManager.START, () => {
				this.ChangeScene()
			}
			)

			local_GlobalEventSystem.Bind(SceneEventType.SCENE_CHANGED, () => {
				this.ChangeSceneBegin()
			}
			)

			local_GlobalEventSystem.Bind(EventName.SCENELOADVIEWE_CLOSE, () => {
				let scene_mgr = SceneManager.Instance
				if (scene_mgr.IsArenaFightScene() && !scene_mgr.IsArenaFightScene(scene_mgr.GetLastSceneId())) {
					arena_model.Fire(local_ArenaModel.REQUEST_CCMD_EVENT, 28018)
				}
			}
			)

			local_GlobalEventSystem.Bind(ServerTimeModel.DAY_CHANGE, () => {
				arena_model.RefreshRed()
			}
			)

			local_GlobalEventSystem.Bind(ServerTimeModel.HOUR_REFRESH, (hour?) => {
				if (hour == 4) {
					arena_model.RefreshRed()
				}
			}
			)

			arena_model.Bind(local_ArenaModel.REQUEST_CCMD_EVENT, (cmd, ...new_args) => {
				let args = new_args
				if (cmd == 28003) {
					this.SendFmtToGame(cmd, "ilic", args[0], args[1], args[2], args[3])
				} else if (cmd == 28005) {
					this.SendFmtToGame(cmd, "h", args[0])
				} else if (cmd == 28014) {
					this.SendFmtToGame(cmd, "ci", args[0], args[1])
				} else if (cmd == 28017) {
					this.SendFmtToGame(cmd, "i", args[0])
				} else if (cmd == 28003) {
					this.SendFmtToGame(cmd, "ilic", args[0], args[1], args[2], args[3])
				} else if (cmd == 28005) {
					this.SendFmtToGame(cmd, "h", args[0])
				} else if (cmd == 28014) {
					this.SendFmtToGame(cmd, "ci", args[0], args[1])
				} else {
					this.SendFmtToGame(cmd)
				}
			}
			)

			//错误码展示
			let On28000 = () => {
				let scmd = user_msg_adapter.GetSCMD(28000)
				if (scmd.errcode == 2800006 || scmd.errcode == 2800007) {
					//对手排名已改变,自己排名已改变,要刷新
					arena_model.Fire(local_ArenaModel.REQUEST_CCMD_EVENT, 28001)
					arena_model.Fire(local_ArenaModel.REQUEST_CCMD_EVENT, 28002)
				} else if (scmd.errcode == 1001 || scmd.errcode == 4500003) {
					NotEnougnDiamond()
				}
				Util.ErrorCodeShow(scmd.errcode)
			}

			let On28001 = () => {
				let scmd = user_msg_adapter.GetSCMD(28001)
				let cfg = Config.PRELOAD_SERVER_CONFIG.config_jjc_reward_break
				arena_model.SetCanReceiveNum(cfg, scmd)
				arena_model.SetPageInfo(scmd)
				arena_model.RefreshRed()
			}

			let On28002 = () => {
				let scmd = user_msg_adapter.GetSCMD(28002)
				table.sort(scmd.role_list, (a?, b?) => {
					return a.rank < b.rank
				})
				arena_model.ChangeVar("challenge_player_list", scmd.role_list)
			}

			let On28003 = () => {
				let scmd = user_msg_adapter.GetSCMD(28003)
				arena_model.result_info = scmd
				arena_model.Fire(local_ArenaModel.OPEN_VIEW, "ArenaResultView")
				arena_model.Fire(local_ArenaModel.REQUEST_CCMD_EVENT, 28004)
				arena_model.Fire(local_ArenaModel.REQUEST_CCMD_EVENT, 28002)
				if (SceneManager.GetInstance().IsArenaFightScene()) {
					ArenaModel.GetInstance().Fire(ArenaModel.REQUEST_CCMD_EVENT, 28012)
				}
			}

			let On28004 = () => {
				let scmd = user_msg_adapter.GetSCMD(28004)
				arena_model.ChangeVar("times_info", scmd)
				arena_model.RefreshRed()
			}

			let On28005 = () => {
				let scmd = user_msg_adapter.GetSCMD(28005)
				if (scmd.errcode == 1) {
					Message.show("购买成功")
					arena_model.Fire(local_ArenaModel.REQUEST_CCMD_EVENT, 28004)
				} else {
					Util.ErrorCodeShow(scmd.errcode)
				}
			}

			let On28008 = () => {
				let scmd = user_msg_adapter.GetSCMD(28008)
				if (scmd.errcode == 1) {
					Message.show("领取奖励成功")
					let page_info = arena_model.page_info
					if (page_info) {
						page_info.is_reward = scmd.is_reward
						arena_model.SetPageInfo(page_info)
					}
				} else {
					Util.ErrorCodeShow(scmd.errcode)
				}
			}

			let On28009 = () => {
				let scmd = user_msg_adapter.GetSCMD(28009)
				arena_model.record_list = scmd.record_list
				arena_model.Fire(local_ArenaModel.UPDATE_RECORD)
			}

			let On28010 = () => {
				let scmd = user_msg_adapter.GetSCMD(28010)
				if (scmd.errcode == 1) {
					MedalModel.GetInstance().honour = scmd.honour
				} else {
					Util.ErrorCodeShow(scmd.errcode)
				}
			}

			let On28012 = () => {
				let scmd = user_msg_adapter.GetSCMD(28012)
				if (scmd.errcode != 1) {
					Util.ErrorCodeShow(scmd.errcode)
				}
			}

			let On28013 = () => {
				let scmd = user_msg_adapter.GetSCMD(28013)
				arena_model.SetRolesData(scmd)
			}

			let On28014 = () => {
				let scmd = user_msg_adapter.GetSCMD(28014)
				arena_model.Fire(local_ArenaModel.UPDATE_FIGHT_INFO, scmd.stage, scmd.time)
			}

			let On28015 = () => {
				let scmd = user_msg_adapter.GetSCMD(28015)
			}

			let On28017 = () => {
				let scmd = user_msg_adapter.GetSCMD(28017)
				if (scmd.errcode == 1) {
					arena_model.Fire(local_ArenaModel.REQUEST_CCMD_EVENT, 28001)
					this.ShowRankBreachReward(scmd)
				} else {
					Util.ErrorCodeShow(scmd.errcode)
				}
			}

			this.RegisterProtocal(28000, On28000)//错误码展示
			this.RegisterProtocal(28001, On28001)//获取玩家jjc信息
			this.RegisterProtocal(28002, On28002)//随机对手
			this.RegisterProtocal(28003, On28003)//挑战对手
			this.RegisterProtocal(28004, On28004)//挑战次数信息
			this.RegisterProtocal(28005, On28005)//购买挑战次数
			this.RegisterProtocal(28008, On28008)//领取奖励
			this.RegisterProtocal(28009, On28009)//被挑战记录
			this.RegisterProtocal(28010, On28010)//荣誉值
			this.RegisterProtocal(28012, On28012)//退出场景
			this.RegisterProtocal(28013, On28013)//战斗假人信息
			this.RegisterProtocal(28014, On28014)//战斗时间信息
			this.RegisterProtocal(28015, On28015)//跳过战斗
			this.RegisterProtocal(28017, On28017)//领取突破奖励
		}

		this.ChangeSceneBegin = () => {
			let scene_mgr = SceneManager.Instance
			if (!scene_mgr.IsArenaFightScene() && scene_mgr.IsArenaFightScene(scene_mgr.GetLastSceneId())) {
				arena_model.Fire(local_ArenaModel.CLOSE_VIEW, "ArenaFightSceneView")
				this.SetMainUIVisible(true)
			}
		}

		this.ChangeScene = () => {
			let scene_mgr = SceneManager.Instance
			if (scene_mgr.IsArenaFightScene() && !scene_mgr.IsArenaFightScene(scene_mgr.GetLastSceneId())) {
				this.SetMainUIVisible(false)
				arena_model.Fire(local_ArenaModel.OPEN_VIEW, "ArenaFightSceneView")
				let main_role = Scene.GetInstance().GetMainRole()
				if(main_role){
					main_role.SetModelHideFlag(SceneObj.ModelHideFlag.Arena, true)
					main_role.SetShadowVisible(false)
				}
			} else if (!scene_mgr.IsArenaFightScene() && scene_mgr.IsArenaFightScene(scene_mgr.GetLastSceneId())) {
				if (!TaskModel.GetInstance().MainTaskIsJoinJJCTaskType()) {
					// local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "BattleFieldEnterView", BaseEnterDefine.BattleFieldIndex().Arena)
					// arena_model.Fire(local_ArenaModel.OPEN_VIEW, "ArenaEnterView")
					local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "BattleFieldEnterView", 0)
				}
				let main_role = Scene.GetInstance().GetMainRole()
				if(main_role){
					main_role.SetModelHideFlag(SceneObj.ModelHideFlag.Arena, false)
					main_role.SetShadowVisible(true)
				}
			}
		}

		this.SetMainUIVisible = (bool?) => {
			mainUI_controller.SetMainUIViewVisible(0, bool)
			mainUI_controller.SetMainUIViewVisible(1, bool)
			mainUI_controller.SetMainUIViewVisible(2, bool)
			mainUI_controller.SetMainUIViewVisible(5, bool)
			mainUI_controller.SetMainUIViewVisible(11, bool)
			mainUI_controller.SetMainUIViewVisible(14, bool)
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
				vo[0] = reward.style
				vo[1] = reward.typeId
				vo[2] = reward.count
				table.insert(data, vo)
			}
			if (data.length > 0) {
				let view = new CongratulationObtainView(data, 10)
				view.Open()
				arena_model.Fire(local_ArenaModel.REQUEST_CCMD_EVENT, 28001)
			}
		}

		this.Init()
	}
}
window["ArenaController"] = ArenaController
