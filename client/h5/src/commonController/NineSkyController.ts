
//require("game.proto.135.Require135")
//require("game.nineSky.NineSkyModel")
//require("game.nineSky.RequireNineSky")

import { BaseController } from "../common/BaseController"
import { EventName } from "../common/EventName"
import { UserMsgAdapter } from "../common/UserMsgAdapter"
import { MainUIModel } from "../commonModel/MainUIModel"
import { NineSkyModel } from "../commonModel/NineSkyModel"
import { RoleManager } from "../commonModel/RoleManager"
import { SceneManager } from "../scene/SceneManager"
import { Message, SysInfoType } from "../sysInfo/SysInfoController"
import { ColorUtil } from "../util/ColorUtil"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { TimeUtil } from "../util/TimeUtil"
import { Util } from "../util/Util"
import { MainUIController } from "./MainUIController"

import "../baseEnterView/BattleFieldEnterView"
import "../nineSky/NineSkyFightSceneView"
import "../nineSky/NineSkyResultView"

export class NineSkyController extends BaseController {
	nine_sky_model: NineSkyModel
	user_msg_adapter: UserMsgAdapter

	public constructor() {
		super()

		this.nine_sky_model = NineSkyModel.GetInstance()
		this.user_msg_adapter = UserMsgAdapter.GetInstance()
		this.InitEvent()
		this.RegisterAllProtocals()
	}

	public InitEvent() {

		GlobalEventSystem.Bind(EventName.GAME_START, () => {
			this.nine_sky_model.ResetData()
			this.nine_sky_model.Fire(NineSkyModel.REQUEST_CCMD_EVENT, 13500)
		})

		GlobalEventSystem.Bind(SceneManager.START, () => {
			this.ChangeScene()
			if(this.nine_sky_model.need_init_state){
				this.nine_sky_model.need_init_state = false
				if(SceneManager.GetInstance().IsNineSkyFightScene()){
					this.nine_sky_model.Fire(NineSkyModel.REQUEST_CCMD_EVENT, 13503)
				}
			}
		})

		this.nine_sky_model.Bind(NineSkyModel.REQUEST_CCMD_EVENT, (cmd, ...args) => {
			if (13506 == cmd) {
				this.SendFmtToGame(cmd, "c", args[0])
			} else if (13501 == cmd) {
				this.SendFmtToGame(cmd, "cc", args[0], args[1])
			} else {
				this.SendFmtToGame(cmd)
			}
		})
	}

	public RegisterAllProtocals() {
		//九魂圣殿状态(状态变更时会推送)
		let On13500 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(13500)
			this.nine_sky_model.SetStateInfo(scmd)
		}
		this.RegisterProtocal(13500, On13500)//九魂圣殿状态(状态变更时会推送)

		//参战
		let On13502 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(13502)
			if (scmd.error_code == 1) {
				Message.show("正在前往战场！")
			} else {
				Util.ErrorCodeShow(scmd.error_code)
			}
		}
		this.RegisterProtocal(13502, On13502)//参战

		//小面板(状态变更时会推送)
		let On13503 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(13503)
			this.nine_sky_model.SetNotifyInfo(scmd)
		}
		this.RegisterProtocal(13503, On13503)//小面板(状态变更时会推送)

		//广播秘宝持有者(状态变更时会推送)
		let On13504 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(13504)
			this.nine_sky_model.SetTopInfo(scmd)
		}
		this.RegisterProtocal(13504, On13504)//广播秘宝持有者(状态变更时会推送)

		//离开
		let On13505 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(13505)
			if (scmd.error_code == 1) {
				Message.show("离开副本")
			} else {
				Util.ErrorCodeShow(scmd.error_code)
			}
		}
		this.RegisterProtocal(13505, On13505)//离开

		//复活
		let On13506 = () => {

		}
		this.RegisterProtocal(13506, On13506)//复活

		//结算
		let On13507 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(13507)
			GlobalEventSystem.Fire(EventName.OPEN_VIEW, "NineSkyResultView", scmd)
		}
		this.RegisterProtocal(13507, On13507)//结算

		//积分
		let On13508 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(13508)
			let color = ColorUtil.GetColorDark(1)
			Message.show("获得<font color=" + color + ">积分 x" + scmd.score + "</font>", true, SysInfoType.MINI)
			this.nine_sky_model.SetScore(scmd.total_score)
		}
		this.RegisterProtocal(13508, On13508)//积分

		//连杀
		let On13509 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(13509)
			let main_role_id = RoleManager.GetInstance().GetMainRoleId()
			let index = null
			if (main_role_id == scmd["role_id"]) {
				index = scmd.dkill > 2 && scmd.dkill
			} else {
				if (scmd.dkill % 5 == 0) {
					index = scmd.dkill / 5 + 2
				}
			}
			if (index) {
				scmd["index"] = index
				this.nine_sky_model.Fire(NineSkyModel.UPDATE_KILL_DATA, scmd)
			}
		}
		this.RegisterProtocal(13509, On13509)//连杀
	}

	public ChangeScene() {

		let scene_mgr = SceneManager.GetInstance()
		let mainUI_model = MainUIModel.GetInstance()

		if (scene_mgr.IsNineSkyFightScene() && !scene_mgr.IsNineSkyFightScene(scene_mgr.GetLastSceneId())) {
			this.SetNineSkyMainUIVisible(false)
			// this.nine_sky_model.Fire(NineSkyModel.REQUEST_CCMD_EVENT, 13504)
			GlobalEventSystem.Fire(EventName.CLOSE_VIEW, "BattleFieldEnterView")
			mainUI_model.Fire(MainUIModel.CHANGE_ACTIVITY_STATE, false)
			GlobalEventSystem.Fire(EventName.OPEN_VIEW, "NineSkyFightSceneView")
			setTimeout(() => {
				GlobalEventSystem.Fire(EventName.STARTAUTOFIGHT)
			}, 1000);
		} else if (!scene_mgr.IsNineSkyFightScene() && scene_mgr.IsNineSkyFightScene(scene_mgr.GetLastSceneId())) {
			this.SetNineSkyMainUIVisible(true)
			mainUI_model.Fire(MainUIModel.CHANGE_ACTIVITY_STATE, true)
			GlobalEventSystem.Fire(EventName.SHOWRELIVEWINDOW, 1)
			GlobalEventSystem.Fire(EventName.CLOSE_VIEW, "NineSkyFightSceneView")
		}
	}

	public SetNineSkyMainUIVisible(bool?) {

		MainUIController.GetInstance().SetMainUIViewVisible(10, bool)
		MainUIController.GetInstance().SetMainUIViewVisible(13, bool)
	}


}
window["NineSkyController"] = NineSkyController