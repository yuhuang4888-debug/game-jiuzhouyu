import { BaseController } from "../common/BaseController"
import { GlobalEventSystem, LOAD_QUEUE } from "../util/DeclareGlobalVar"
import { EventName } from "../common/EventName"
import { UserMsgAdapter } from "../common/UserMsgAdapter"
import { Split, Util } from "../util/Util"
import { SentientActEvent, SentientActModel } from "../commonModel/SentientActModel"
import "../sentientAct/SentientActMainView"
import "../baseEnterView/WorldBattleEnterViewTwo"
import "../sentientAct/SentientActTeamView"
import { SceneManager } from "../scene/SceneManager"
import { MainUIModel } from "../commonModel/MainUIModel"
import "../sentientAct/SentientActSceneView"
import { BossModel } from "../commonModel/BossModel"
import { ResManager } from "../common/ResManager"
import { Alert, Alert_Type } from "../alert/Alert"
import { TeamEvent, TeamModel } from "../commonModel/TeamModel"
import "../sentientAct/SentientActTipView"

export class SentientActController extends BaseController {
	InitInfo
	scene_mgr = SceneManager.GetInstance()
	dungeon_out = false
	public constructor() {
		super()


		let model = SentientActModel.GetInstance()
		let local_GlobalEventSystem = GlobalEventSystem
		let local_EventName = EventName

		let user_msg_adapter = UserMsgAdapter.GetInstance()
		this.InitInfo = () => {
			let game_start = () => {
				model.Fire(SentientActEvent.REQUEST_PROTO, 24101)
				model.Fire(SentientActEvent.REQUEST_PROTO, 24107)
				model.Fire(SentientActEvent.REQUEST_PROTO, 24102)
			}

			local_GlobalEventSystem.Bind(local_EventName.GAME_START, game_start)
			model.Bind(
				SentientActEvent.REQUEST_PROTO, (id, fmt, ...new_args) => {
					this.SendFmtToGame(id, fmt, ...new_args)
				}
			)
			GlobalEventSystem.Bind(
				SceneManager.START, () => {
					this.ChangeScene()
				}
			)

			let On24101 = () => {
				let scmd = user_msg_adapter.GetSCMD(24101)
				model.SetActData(scmd)
				if (scmd.state)
					model.Fire(SentientActEvent.REQUEST_PROTO, 24102)
				model.Fire(SentientActEvent.UPDATE_ACT_STATE, scmd.state, scmd.next_start_time)
				GlobalEventSystem.Fire(EventName.REFRESH_ACTIVITY_ICON_RED_DOT, 6210)
				GlobalEventSystem.Fire(EventName.REFRESH_ACTIVITY_ICON_RED_DOT, 241)
			}

			this.RegisterProtocal(24101, On24101)

			let On24102 = () => {
				let scmd = user_msg_adapter.GetSCMD(24102)
				model.SetPortalData(scmd.portal_list)
				model.Fire(SentientActEvent.UPDATE_DOOR_DATA)
				model.SetRed()
			}

			this.RegisterProtocal(24102, On24102)

			let On24103 = () => {
				let scmd = user_msg_adapter.GetSCMD(24103)
				if (scmd.code != 1) {
					Util.ErrorCodeShow(scmd.code)
					return
				}
			}

			this.RegisterProtocal(24103, On24103)

			let On24104 = () => {
				let scmd = user_msg_adapter.GetSCMD(24104)
				if (scmd.code != 1) {
					Util.ErrorCodeShow(scmd.code)
					return
				}
				// else
				// 	model.Fire(SentientActEvent.REQUEST_PROTO, 24102)
			}

			this.RegisterProtocal(24104, On24104)

			let On24105 = () => {
				let scmd = user_msg_adapter.GetSCMD(24105)
				if (scmd.code != 1) {
					Util.ErrorCodeShow(scmd.code)
					return
				}
			}

			this.RegisterProtocal(24105, On24105)

			let On24106 = () => {
				let scmd = user_msg_adapter.GetSCMD(24106)
				model.Fire(SentientActEvent.DELETE_DOOR, scmd.portal_id)
				model.Fire(SentientActEvent.REQUEST_PROTO, 24102)
			}

			this.RegisterProtocal(24106, On24106)

			let On24107 = () => {
				let scmd = user_msg_adapter.GetSCMD(24107)
				model.Fire(SentientActEvent.UPDATE_COUNT, scmd.assist_num, scmd.enter_num)
				model.enter_num = scmd.enter_num
				model.assist_num = scmd.assist_num
				GlobalEventSystem.Fire(EventName.REFRESH_ACTIVITY_ICON_RED_DOT, 6210)
				GlobalEventSystem.Fire(EventName.REFRESH_ACTIVITY_ICON_RED_DOT, 241)
				if (this.dungeon_out == true) {
					ResManager.GetInstance().GetGameConfigWithAutoDestory("config_beings_gate_kv", (cfg) => {
						if (!cfg) return
						let max_into_count = cfg["beings_gate_scene_enter"].value
						let is_dungeon_scene = SentientActModel.GetInstance().IsSentientActDungeonScene(cfg)
						let enter_num = scmd.enter_num
						if ((max_into_count - enter_num) <= 0 && !is_dungeon_scene) {
							Alert.Show("当前众生之门次数已用光，是否继续以协助模式进行战斗？", Alert_Type.Two, null, (bool) => {
								if (!bool)
									TeamModel.GetInstance().Fire(TeamEvent.TEAM_REQUEST_PROTO, 24005)
							}, "确定", "取消", null, null, null, null, null, null, null, null, null, null, false)
						}
					}, false)

				}
				model.SetRed()
			}

			this.RegisterProtocal(24107, On24107)

			let On24108 = () => {
				let scmd = user_msg_adapter.GetSCMD(24108)
				if (scmd.code != 1) {
					Util.ErrorCodeShow(scmd.code)
					return
				}
				else {
					Alert.Show("队长发起了进入恶鬼入侵玩法的召集，是否进入场景？", Alert_Type.Two, () => {
						model.Fire(SentientActEvent.REQUEST_PROTO, 24104)
					}, null, "确定", "取消", null, null, null, null, null, null, null, null, null, null, false)
				}
			}

			this.RegisterProtocal(24108, On24108)

			let On24109 = () => {
				let scmd = user_msg_adapter.GetSCMD(24109)
				model.dungeon_id = scmd.dun_id
			}

			this.RegisterProtocal(24109, On24109)
		}

		this.InitInfo()
	}
	public ChangeScene() {
		ResManager.GetInstance().GetGameConfigWithAutoDestory("config_beings_gate_kv", (cfg) => {
			let last_scene_id = SceneManager.GetInstance().GetLastSceneId()
			let is_dungeon_scene = SentientActModel.GetInstance().IsSentientActDungeonScene(cfg)
			let is_last_dungeon_scene = SentientActModel.GetInstance().IsSentientActDungeonScene(cfg, last_scene_id)
			if ((this.scene_mgr.IsSentientActScene() && (!this.scene_mgr.IsSentientActScene(last_scene_id) || last_scene_id == 0) && !is_dungeon_scene && !is_last_dungeon_scene)
				|| ((!this.scene_mgr.IsSentientActScene(last_scene_id) || last_scene_id == 0) && is_dungeon_scene)) {
				this.EnterSceneHandle()
				let team_info = TeamModel.GetInstance().team_info
				if (!team_info)
					GlobalEventSystem.Fire(EventName.OPEN_VIEW, "SentientActTipView")
			}
			if (!is_dungeon_scene && !this.scene_mgr.IsSentientActScene()) {
				this.ExitSceneHandle()
			}
			if (is_last_dungeon_scene) {
				this.dungeon_out = true
				SentientActModel.GetInstance().Fire(SentientActEvent.REQUEST_PROTO, 24107)
			}
			if (this.scene_mgr.IsSentientActScene(last_scene_id)) {
				//退出队伍
				let team_model = TeamModel.GetInstance()
				let team_info = team_model.team_info
				if (team_info) {
					team_model.Fire(TeamEvent.TEAM_REQUEST_PROTO, 24005);
				}
			}
			if (this.scene_mgr.IsSentientActScene() && SentientActModel.GetInstance().GetDoorNum() > 0){
				SentientActModel.GetInstance().set_red = false
				GlobalEventSystem.Fire(EventName.REFRESH_ACTIVITY_ICON_RED_DOT, 6210)
				GlobalEventSystem.Fire(EventName.REFRESH_ACTIVITY_ICON_RED_DOT, 241)
			}
			if(this.scene_mgr.IsSentientActScene(last_scene_id) && SentientActModel.GetInstance().GetDoorNum() > 0){
				SentientActModel.GetInstance().set_red = true
				GlobalEventSystem.Fire(EventName.REFRESH_ACTIVITY_ICON_RED_DOT, 6210)
				GlobalEventSystem.Fire(EventName.REFRESH_ACTIVITY_ICON_RED_DOT, 241)
			}

		}, false)

	}
	public EnterSceneHandle() {
		BossModel.GetInstance().main_ui_setting_flag = true
		SentientActModel.GetInstance().Fire(SentientActEvent.OPEN_SENTIENTACT_VIEW, true)
		MainUIModel.GetInstance().Fire(MainUIModel.CHANGE_ACTIVITY_STATE, false)
		GlobalEventSystem.Fire(EventName.OPEN_VIEW, "SentientActSceneView")
		//SentientActModel.GetInstance().Fire(SentientActEvent.REQUEST_PROTO, 24102)
	}

	public ExitSceneHandle() {
		GlobalEventSystem.Fire(EventName.CLOSE_VIEW, "SentientActSceneView")
	}
}

window["SentientActController"] = SentientActController