
//require("game.eternity.EternityBossItem")
//require("game.eternity.EternityCadreItem")
//require("game.eternity.EternityDamageItem")
//require("game.eternity.EternityDefine")
//require("game.eternity.EternityMainView")
//require("game.eternity.EternityModel")
//require("game.eternity.EternityMonItem")
//require("game.eternity.EternityReliveView")
//require("game.eternity.EternitySceneView")

import { BaseController } from "../common/BaseController"
import { EventName, SceneEventType } from "../common/EventName"
import { UserMsgAdapter } from "../common/UserMsgAdapter"
import { EternityDefine, EternityEvent, EternityModel } from "../commonModel/EternityModel"
import { MainUIModel } from "../commonModel/MainUIModel"
import { RoleManager } from "../commonModel/RoleManager"
import { SceneManager } from "../scene/SceneManager"
import { Message } from "../sysInfo/SysInfoController"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { Util } from "../util/Util"
import { MainUIController } from "./MainUIController"
import "../eternity/EternityMainView"
import "../eternity/EternityReliveView"
import "../eternity/EternitySceneView"
import { ResManager } from "../common/ResManager"
import { BossModel } from "../commonModel/BossModel"

//require("game.proto.279.Require279")
export class EternityController extends BaseController {
	ChangeScene
	InitEvent
	InitInfo
	SetMainUIVisible
	model

	public constructor() {
		super()



		let local_GlobalEventSystem = GlobalEventSystem
		let local_EventName = EventName
		let role_mgr = RoleManager.GetInstance()
		let local_EternityDefine = EternityDefine
		let local_EternityEvent = EternityEvent
		this.model = EternityModel.GetInstance();
		let scene_mgr = SceneManager.GetInstance()
		let user_msg_adapter = UserMsgAdapter.GetInstance()
		let local_Message = Message
		this.InitEvent = () => {
			local_GlobalEventSystem.Bind(local_EventName.GAME_START, () => {
				this.model.Reset()
				if (role_mgr.GetMainRoleVo().level >= local_EternityDefine.OPEN_LV) {
					this.SendFmtToGame(27900)
				}
			}
			)
			role_mgr.GetMainRoleVo().Bind(local_EventName.CHANGE_LEVEL, (level?) => {
				if (level == local_EternityDefine.OPEN_LV) {
					this.SendFmtToGame(27900)
				}
			}
			)
			this.model.Bind(local_EternityEvent.REQUEST_PROTO, (id, fmt, ...new_args) => {
				this.SendFmtToGame(id, fmt, ...new_args)
			}
			)
			local_GlobalEventSystem.Bind(SceneManager.START, () => {
				this.ChangeScene()
			}
			)
			local_GlobalEventSystem.Bind(local_EventName.SHOWRELIVEWINDOW, (type?) => {
				if (type == 1 && scene_mgr.IsEternityScene()) {
					local_GlobalEventSystem.Fire(local_EventName.CLOSE_VIEW, "EternityReliveView")
				} else if (type == 0 && scene_mgr.IsEternityScene()) {
					local_GlobalEventSystem.Fire(SceneEventType.UPDATE_KILLER)
				}
			}
			)
		}

		this.ChangeScene = () => {
			if (scene_mgr.IsEternityScene()) {
				this.SetMainUIVisible(false)
				local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "EternitySceneView")
			} else if (!scene_mgr.IsEternityScene() && scene_mgr.IsEternityScene(scene_mgr.GetLastSceneId())) {
				this.SetMainUIVisible(true)
				local_GlobalEventSystem.Fire(local_EventName.CLOSE_VIEW, "EternitySceneView")
				local_GlobalEventSystem.Fire(local_EventName.CLOSE_VIEW, "EternityReliveView")
			}
		}

		this.SetMainUIVisible = (bool?) => {
			let mainUI_controller = MainUIController.GetInstance()
			mainUI_controller.SetMainUIViewVisible(10, bool)
			mainUI_controller.SetMainUIViewVisible(11, bool)
			mainUI_controller.SetMainUIViewVisible(13, bool)
			MainUIModel.GetInstance().Fire(MainUIModel.CHANGE_ACTIVITY_STATE, bool)
		}

		this.InitInfo = () => {
			let on27900 = () => {
				let scmd = user_msg_adapter.GetSCMD(27900)
				this.model.SetActData(scmd)
			}

			let on27901 = () => {
				let scmd = user_msg_adapter.GetSCMD(27901)
				this.model.Fire(local_EternityEvent.UPDATE_PLAYER, scmd)
			}

			let on27902 = () => {
				let scmd = user_msg_adapter.GetSCMD(27902)
				if (scmd.code == 1) {
					local_Message.show('进入成功')
				} else {
					Util.ErrorCodeShow(scmd.code)
				}
			}

			let on27903 = () => {
				let scmd = user_msg_adapter.GetSCMD(27903)
				if (scmd.code == 1) {
					local_Message.show('退出成功')
				} else {
					Util.ErrorCodeShow(scmd.code)
				}
			}

			let on27904 = () => {
				let scmd = user_msg_adapter.GetSCMD(27904)
				this.model.SetMonData(scmd)
				BossModel.GetInstance().TryToCreatGrave()
			}

			let on27905 = () => {
				let scmd = user_msg_adapter.GetSCMD(27905)
				this.model.SetDamageData(scmd)
			}

			let on27906 = () => {
				let scmd = user_msg_adapter.GetSCMD(27906)
				this.model.SetReliveData(scmd)
			}

			let on27907 = () => {
				let scmd = user_msg_adapter.GetSCMD(27907)
				let mData = this.model.GetMonData()
				if (!mData) {
					return
				}
				for (let _tmpi in mData.mon) {
					var vo = mData.mon[_tmpi]
					if (vo.mon_id == scmd.mon_id) {
						vo.reborn_time = 0
						break
					}
				}
				this.model.SetMonData(mData)
				BossModel.GetInstance().TryToCreatGrave()
			}

			let on27908 = () => {
				let scmd = user_msg_adapter.GetSCMD(27908)
				let mData = this.model.GetMonData()
				if (mData) {
					for (let _tmpi in mData.mon) {
						var vo = mData.mon[_tmpi]
						if (vo.mon_id == scmd.mon_id) {
							vo.reborn_time = scmd.reborn_time
							vo.bl_server = scmd.bl_server
							vo.bl_server_num = scmd.bl_server_num
							vo.bl_server_name = scmd.bl_server_name
							break
						}
					}
					this.model.SetMonData(mData)
				}
				ResManager.GetInstance().GetGameConfigWithAutoDestory("ConfigEternity", (cfg?) => {
					let server_id = role_mgr.GetMainRoleVo().server_unique_id
					let scene_id = scene_mgr.GetSceneId()
					let type = cfg.mon_type[scmd.mon_id]
					let can_go = (server_id == scmd.bl_server && scene_id != local_EternityDefine.BOSS_SCENE) && type == 1
					this.model.Fire(local_EternityEvent.UPDATE_GO_STATUS, can_go, scmd)
				}
					, true)
				//这条可能广播不是当前地图的boss，所以走遍历创建
				BossModel.GetInstance().TryToCreatGrave()
			}

			let on27909 = () => {
				let scmd = user_msg_adapter.GetSCMD(27909)
				if (scmd.code != 1) {
					Util.ErrorCodeShow(scmd.code)
				}
			}

			this.RegisterProtocal(27900, on27900)
			this.RegisterProtocal(27901, on27901)
			this.RegisterProtocal(27902, on27902)
			this.RegisterProtocal(27903, on27903)
			this.RegisterProtocal(27904, on27904)
			this.RegisterProtocal(27905, on27905)
			this.RegisterProtocal(27906, on27906)
			this.RegisterProtocal(27907, on27907)
			this.RegisterProtocal(27908, on27908)
			this.RegisterProtocal(27909, on27909)
		}

		this.InitInfo()
		this.InitEvent()
	}

}