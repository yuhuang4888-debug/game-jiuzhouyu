import { BaseController } from "../common/BaseController"
import { Util } from "../util/Util"
import { ServerTimeModel } from "../serverTime/ServerTimeModel"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { EventName } from "../common/EventName"
import { UserMsgAdapter } from "../common/UserMsgAdapter"
import { MainUIModel } from "../commonModel/MainUIModel"
import { RoleManager } from "../commonModel/RoleManager"
import { SceneManager } from "../scene/SceneManager"
import { BossModel } from "../commonModel/BossModel"
import { AutoFightManager } from "../autofight/AutoFightManager"
import { MainUIController } from "./MainUIController"
import { DragonWhisperModel, DrWsEvent, DragonWhisperDefine } from "../commonModel/DragonWhisperModel"

import "../dragonWhisper/dwSceneView"

export class DragonWhisperController extends BaseController {
	InitEvent
	InitInfo
	OnSceneChanged
	SetMainUIVisible
	model

	public constructor() {
		super()
		this.model = DragonWhisperModel.GetInstance()
		let local_GlobalEventSystem = GlobalEventSystem
		let local_EventName = EventName
		let role_mgr = RoleManager.GetInstance()
		let local_DragonWhisperDefine = DragonWhisperDefine
		let local_DrWsEvent = DrWsEvent
		let user_msg_adapter = UserMsgAdapter.GetInstance()
		let local_stModel = ServerTimeModel.GetInstance()
		this.InitEvent = () => {
			local_GlobalEventSystem.Bind(local_EventName.GAME_START, () => {
				this.model.Reset()
				if (role_mgr.GetMainRoleVo().level >= local_DragonWhisperDefine.OPEN_LV && local_stModel.GetOpenServerDay() >= local_DragonWhisperDefine.OPEN_DAY) {
					this.SendFmtToGame(65101)
				}
			})

			role_mgr.GetMainRoleVo().Bind(local_EventName.CHANGE_LEVEL, (level?) => {
				if (level == local_DragonWhisperDefine.OPEN_LV && local_stModel.GetOpenServerDay() >= local_DragonWhisperDefine.OPEN_DAY) {
					this.SendFmtToGame(65101)
				}
			})

			role_mgr.GetMainRoleVo().Bind("vip_flag", () => {
				if (role_mgr.GetMainRoleVo().level >= local_DragonWhisperDefine.OPEN_LV && local_stModel.GetOpenServerDay() >= local_DragonWhisperDefine.OPEN_DAY) {
					this.SendFmtToGame(65101)
				}
			})

			this.model.Bind(local_DrWsEvent.PROTO, (id, fmt, ...new_args) => {
				this.SendFmtToGame(id, fmt, ...new_args)
			})

			local_GlobalEventSystem.Bind(SceneManager.START, () => {
				this.OnSceneChanged()
			})
		}

		this.OnSceneChanged = () => {
			let scene_mgr = SceneManager.GetInstance()
			let last_scene_id = scene_mgr.GetLastSceneId()
			if (scene_mgr.IsDWScene()) {
				this.SetMainUIVisible(false)
				GlobalEventSystem.Fire(EventName.CLOSE_VIEW, "BossEnterView")
				local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "dwSceneView")
				local_GlobalEventSystem.Fire(local_EventName.OPEN_BOSS_ENTER_VIEW, BossModel.Index.Dragon_Boss, null, false)
			} else if (scene_mgr.IsDWScene(last_scene_id) && !scene_mgr.IsDWScene()) {
				this.SetMainUIVisible(true)
				local_GlobalEventSystem.Fire(local_EventName.CLOSE_VIEW, "dwSceneView")
				AutoFightManager.GetInstance().SetAutoFight(true)
			}
		}

		this.SetMainUIVisible = (bool?) => {
			let mainUI_controller = MainUIController.GetInstance()
			mainUI_controller.SetMainUIViewVisible(5, bool)
			mainUI_controller.SetMainUIViewVisible(10, bool)
			MainUIModel.GetInstance().Fire(MainUIModel.CHANGE_ACTIVITY_STATE, bool)
		}

		this.InitInfo = () => {
			let on65100 = () => {
				let scmd = user_msg_adapter.GetSCMD(65100)
				Util.ErrorCodeShow(scmd.code)
			}

			let on65101 = () => {
				let scmd = user_msg_adapter.GetSCMD(65101)
				this.model.SetViewInfo(scmd)
			}

			let on65102 = () => {
				let scmd = user_msg_adapter.GetSCMD(65102)
				this.model.SetEnterInfo(scmd)
			}

			let on65103 = () => {
				let scmd = user_msg_adapter.GetSCMD(651003)
			}

			let on65104 = () => {
				let scmd = user_msg_adapter.GetSCMD(65104)
				let vinfo = this.model.GetViewInfo()
				if (!vinfo) {
					return
				}
				vinfo.left_count = scmd.left_count
				vinfo.all_count = scmd.all_count
				this.model.SetViewInfo(vinfo)
				this.model.Fire(local_DrWsEvent.BUY_TIME_SUCCESS)
			}

			let on65105 = () => {
				// let vinfo = this.model.GetViewInfo()
				// if (vinfo) {
				// 	let count = vinfo.left_count - 1
				// 	vinfo.left_count = Math.max(count, 0)
				// 	this.model.SetViewInfo(vinfo)
				// }
				this.model.Fire(local_DrWsEvent.PROTO, 65101)
				let scmd = user_msg_adapter.GetSCMD(65105)
				this.model.SetSceneInfo(scmd)
			}

			let on65106 = () => {
				let scmd = user_msg_adapter.GetSCMD(65106)
				this.model.Fire(local_DrWsEvent.UPDATE_RECORD, scmd)
			}

			let on65107 = () => {
				let scmd = user_msg_adapter.GetSCMD(65107)
				let vinfo = this.model.GetViewInfo()
				if (vinfo) {
					vinfo.left_count = scmd.left_count
					vinfo.all_count = scmd.all_count
					this.model.SetViewInfo(vinfo)
				}
				let sinfo = this.model.GetSceneInfo()
				if (sinfo) {
					sinfo.time = scmd.left_time
					this.model.SetSceneInfo(sinfo)
				}
				this.model.Fire(local_DrWsEvent.BUY_TIME_SUCCESS)
			}

			this.RegisterProtocal(65100, on65100)
			this.RegisterProtocal(65101, on65101)
			this.RegisterProtocal(65102, on65102)
			this.RegisterProtocal(65103, on65103)
			this.RegisterProtocal(65104, on65104)
			this.RegisterProtocal(65105, on65105)
			this.RegisterProtocal(65106, on65106)
			this.RegisterProtocal(65107, on65107)
		}

		this.InitInfo()
		this.InitEvent()
	}
}
window["DragonWhisperController"] = DragonWhisperController