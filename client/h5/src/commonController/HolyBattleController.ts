
import "../commonModel/HolyBattleModel"
import "../holyBattle/HolyBattleBuffView"
import "../holyBattle/HolyBattleEnterView"
import "../holyBattle/HolyBattleFightSceneView"
import "../holyBattle/HolyBattleInstructionView"
import "../holyBattle/HolyBattleRecordItem"
import "../holyBattle/HolyBattleRecordView"
import "../holyBattle/HolyBattleReliveView"
import "../holyBattle/HolyBattleResultView"
import "../holyBattle/HolyBattleRewardItem"
import "../holyBattle/HolyBattleRewardTabItem"
import "../holyBattle/HolyBattleRewardView"
import "../holyBattle/HolyBattleServerItem"
import "../holyBattle/HolyBattleServerView"
import "../holyBattle/HolyBattleSkillView"
import "../holyBattle/HolyBattleTargetItem"
import "../holyBattle/HolyBattleTargetPanel"
import "../holyBattle/HolyBattleTowerItem"
import "../holyBattle/HolyBattleWaitSceneView"


import { BaseController } from "../common/BaseController"
import { EventName, SceneEventType } from "../common/EventName"
import { UserMsgAdapter } from "../common/UserMsgAdapter"
import { HolyBattleModel } from "../commonModel/HolyBattleModel"
import { MainUIModel } from "../commonModel/MainUIModel"
import { RoleManager } from "../commonModel/RoleManager"
import { SceneManager } from "../scene/SceneManager"
import { Message } from "../sysInfo/SysInfoController"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { TimeUtil } from "../util/TimeUtil"
import { Util } from "../util/Util"
import { MainUIController } from "./MainUIController"
import { kfStageModel } from "../commonModel/kfStageModel"

export class HolyBattleController extends BaseController {
	InitInfo

	public constructor() {
		super()


		this.InitInfo = () => {
			let local_HolyBattleModel = HolyBattleModel
			let local_HolyBattleModel_Instance = HolyBattleModel.GetInstance()
			let local_RoleManager_Instance = RoleManager.GetInstance()
			let local_UserMsgAdapter_Instance = UserMsgAdapter.GetInstance()
			let local_GlobalEventSystem = GlobalEventSystem
			let local_EventName = EventName
			let local_Message = Message
			let local_SceneManager_Instance = SceneManager.GetInstance()
			let local_TimeUtil = TimeUtil
			let local_MainUIController = MainUIController.GetInstance()
			let local_MainUIModel = MainUIModel.GetInstance()

			//通用错误返回
			let On21800 = () => {
				let scmd = local_UserMsgAdapter_Instance.GetSCMD(21800)
				Util.ErrorCodeShow(scmd.error_code)
			}

			//活动信息
			let On21801 = () => {
				let scmd = local_UserMsgAdapter_Instance.GetSCMD(21801)
				kfStageModel.GetInstance().SetHolyBattleData(scmd)
				local_HolyBattleModel_Instance.UpdateActData(scmd)
				local_HolyBattleModel_Instance.Fire(local_HolyBattleModel.REQUEST_PROTO, 21811)
			}

			//进入场景
			let On21802 = () => {
				let scmd = local_UserMsgAdapter_Instance.GetSCMD(21802)
				Util.ErrorCodeShow(scmd.code)
				local_HolyBattleModel_Instance.ClearResultData()
			}

			//退出场景
			let On21803 = () => {
				let scmd = local_UserMsgAdapter_Instance.GetSCMD(21803)
				local_HolyBattleModel_Instance.ClearMonData()
			}

			//经验变化
			let On21804 = () => {
				let scmd = local_UserMsgAdapter_Instance.GetSCMD(21804)
				local_HolyBattleModel_Instance.UpdateExpData(scmd)
			}

			//个人奖励
			let On21805 = () => {
				let scmd = local_UserMsgAdapter_Instance.GetSCMD(21805)
				local_HolyBattleModel_Instance.UpdateScoreData(scmd)
			}

			//领取个人积分奖励
			let On21806 = () => {
				let scmd = local_UserMsgAdapter_Instance.GetSCMD(21806)
				local_HolyBattleModel_Instance.Fire(local_HolyBattleModel.REQUEST_PROTO, 21805)
				Util.ShowCongratulationView(scmd.reward)
			}

			//玩家战场信息
			let On21807 = () => {
				let scmd = local_UserMsgAdapter_Instance.GetSCMD(21807)
				local_HolyBattleModel_Instance.UpdateFightData(scmd)
			}

			//战场统计
			let On21808 = () => {
				let scmd = local_UserMsgAdapter_Instance.GetSCMD(21808)
				local_HolyBattleModel_Instance.UpdateRecordData(scmd)
			}

			//死亡信息
			let On21809 = () => {
				let scmd = local_UserMsgAdapter_Instance.GetSCMD(21809)
				local_HolyBattleModel_Instance.Fire(local_HolyBattleModel.UPDATE_SKILL_DATA, scmd.anger)
				local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "HolyBattleReliveView", scmd)
			}

			//结算信息
			let On21810 = () => {
				let scmd = local_UserMsgAdapter_Instance.GetSCMD(21810)
				local_HolyBattleModel_Instance.SetResultData(scmd)
				if (!local_HolyBattleModel_Instance.result_open) {
					local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "HolyBattleResultView", scmd)
				}
			}

			//阶段发生变化
			let On21811 = () => {
				let scmd = local_UserMsgAdapter_Instance.GetSCMD(21811)
				local_HolyBattleModel_Instance.UpdateTimeData(scmd)
			}

			//怪物信息
			let On21813 = () => {
				let scmd = local_UserMsgAdapter_Instance.GetSCMD(21813)
				local_HolyBattleModel_Instance.UpdateMonData(scmd)
			}

			this.RegisterProtocal(21800, On21800)	//通用错误返回
			this.RegisterProtocal(21801, On21801)	//活动信息
			this.RegisterProtocal(21802, On21802)	//进入场景
			this.RegisterProtocal(21803, On21803)	//退出场景
			this.RegisterProtocal(21804, On21804)	//经验变化
			this.RegisterProtocal(21805, On21805)	//个人奖励
			this.RegisterProtocal(21806, On21806)	//领取个人积分奖励
			this.RegisterProtocal(21807, On21807)	//玩家战场信息
			this.RegisterProtocal(21808, On21808)	//战场统计
			this.RegisterProtocal(21809, On21809)	//死亡信息
			this.RegisterProtocal(21810, On21810)	//结算信息
			this.RegisterProtocal(21811, On21811)	//阶段发生变化
			this.RegisterProtocal(21813, On21813)	//怪物信息

			local_HolyBattleModel_Instance.Bind(local_HolyBattleModel.REQUEST_PROTO, (id, ...new_args) => {
				let parms = new_args
				if (id == 21806) {
					this.SendFmtToGame(id, "c", parms[0])
				} else {
					this.SendFmtToGame(id)
				}
			}
			)

			local_GlobalEventSystem.Bind(local_EventName.GAME_START, () => {
				local_HolyBattleModel_Instance.Fire(local_HolyBattleModel.REQUEST_PROTO, 21801)
				local_HolyBattleModel_Instance.Fire(local_HolyBattleModel.REQUEST_PROTO, 21805)
			}
			)

			local_GlobalEventSystem.Bind(SceneEventType.SCENE_CHANGED, () => {
				let last_scene_id = local_SceneManager_Instance.GetLastSceneId()
				if (local_SceneManager_Instance.IsHolyBattleWaitScene() && !local_SceneManager_Instance.IsHolyBattleWaitScene(last_scene_id)) {
					local_MainUIController.SetMainUIViewVisible(10, false)
					local_MainUIModel.Fire(MainUIModel.CHANGE_ACTIVITY_STATE, false)
					local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "HolyBattleWaitSceneView")
				} else if (local_SceneManager_Instance.IsHolyBattleWaitScene(last_scene_id) && !local_SceneManager_Instance.IsHolyBattleWaitScene()) {
					local_GlobalEventSystem.Fire(local_EventName.CLOSE_VIEW, "HolyBattleWaitSceneView")
					local_MainUIController.SetMainUIViewVisible(10, true)
					local_MainUIModel.Fire(MainUIModel.CHANGE_ACTIVITY_STATE, true)
				}
				if (local_SceneManager_Instance.IsHolyBattleFightScene() && !local_SceneManager_Instance.IsHolyBattleFightScene(last_scene_id)) {
					local_MainUIController.SetMainUIViewVisible(10, false)
					local_MainUIController.SetMainUIViewVisible(13, false)
					local_MainUIModel.Fire(MainUIModel.CHANGE_ACTIVITY_STATE, false)
					local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "HolyBattleFightSceneView")
				} else if (local_SceneManager_Instance.IsHolyBattleFightScene(last_scene_id) && !local_SceneManager_Instance.IsHolyBattleFightScene()) {
					local_GlobalEventSystem.Fire(local_EventName.CLOSE_VIEW, "HolyBattleFightSceneView")
					local_MainUIController.SetMainUIViewVisible(10, true)
					local_MainUIController.SetMainUIViewVisible(13, true)
					local_MainUIModel.Fire(MainUIModel.CHANGE_ACTIVITY_STATE, true)
					local_HolyBattleModel_Instance.CheakResultData()
				}
				local_HolyBattleModel_Instance.RefreshActOpenRed()
			}
			)

			
		}

		this.InitInfo()
	}

}

window["HolyBattleController"] = HolyBattleController