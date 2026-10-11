
import { AutoFightManager } from "../autofight/AutoFightManager"
import { BaseController } from "../common/BaseController"
import { EventName } from "../common/EventName"
import { table } from "../common/table"
import { UserMsgAdapter } from "../common/UserMsgAdapter"
import { kfSingleRankModel, kfSingleRankDefine, kfSREvent } from "../commonModel/kfSingleRankModel"
import { MainUIModel } from "../commonModel/MainUIModel"
import { RoleManager } from "../commonModel/RoleManager"
import { SceneManager } from "../scene/SceneManager"
import { Message } from "../sysInfo/SysInfoController"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { Util } from "../util/Util"
import { MainUIController } from "./MainUIController"



import "../commonModel/kfSingleRankModel"
import "../kfSingleRank/kfSRAwardItem"
import "../kfSingleRank/kfSRAwardItemB"
import "../kfSingleRank/kfSRAwardItemC"
import "../kfSingleRank/kfSRDropBtn"
import "../kfSingleRank/kfSRDropItem"
import "../kfSingleRank/kfSRDropList"
import "../kfSingleRank/kfSRMainItem"
import "../kfSingleRank/kfSRMainRankItem"
import "../kfSingleRank/kfSRMainView"
import "../kfSingleRank/kfSRRankItem"
import "../kfSingleRank/kfSRRankView"
import "../kfSingleRank/kfSRRewardItem"
import "../kfSingleRank/kfSRRewardView"
import "../kfSingleRank/kfSRSceneTipsView"
import "../kfSingleRank/kfSRSceneView"
import "../kfSingleRank/kfSRVictoryView"
import { ResManager } from "../common/ResManager"

export class kfSingleRankController extends BaseController {
	InitEvent
	InitInfo
	OnSceneChanged
	SetMainUIVisible

	public constructor() {
		super()

		let model = kfSingleRankModel.GetInstance()
		let local_GlobalEventSystem = GlobalEventSystem
		let local_EventName = EventName
		let scene_mgr = SceneManager.GetInstance()
		let user_msg_adapter = UserMsgAdapter.GetInstance()
		let local_Util = Util
		this.InitEvent = () => {
			local_GlobalEventSystem.Bind(local_EventName.GAME_START, () => {
				this.SendFmtToGame(50701)
			}
			)
			RoleManager.GetInstance().GetMainRoleVo().Bind(local_EventName.CHANGE_LEVEL, (level?) => {
				if (level == kfSingleRankDefine.OPEN_LV) {
					this.SendFmtToGame(50701)
				}
			}
			)
			model.Bind(kfSREvent.REQUEST_PROTO, (id, fmt, ...new_args) => {
				this.SendFmtToGame(id, fmt, ...new_args)
			}
			)
			local_GlobalEventSystem.Bind(SceneManager.START, () => {
				this.OnSceneChanged()
			}
			)
		}

		this.OnSceneChanged = () => {
			let last_scene_id = scene_mgr.GetLastSceneId()
			if (scene_mgr.IsKfSingleRankScene()) {
				this.SetMainUIVisible(false)
				//AutoFightManager.GetInstance().SetAutoFight(true)
			} else if (scene_mgr.IsKfSingleRankScene(last_scene_id) && !scene_mgr.IsKfSingleRankScene()) {
				this.SetMainUIVisible(true)
				local_GlobalEventSystem.Fire(local_EventName.CLOSE_VIEW, "kfSRSceneTipsView")
				AutoFightManager.GetInstance().SetAutoFight(true)
			}
		}

		

		this.SetMainUIVisible = (bool?) => {
			let mainUI_controller = MainUIController.GetInstance()
			mainUI_controller.SetMainUIViewVisible(5, bool)
			mainUI_controller.SetMainUIViewVisible(10, bool)
			mainUI_controller.SetMainUIViewVisible(11, bool)
			MainUIModel.GetInstance().Fire(MainUIModel.CHANGE_ACTIVITY_STATE, bool)
		}

		this.InitInfo = () => {
			let on50701 = () => {
				let scmd = user_msg_adapter.GetSCMD(50701)
				table.sort(scmd.level_list, (a?, b?) => {
					return b.level < a.level
				})
				let dic = []
				for (let _tmpi in scmd.level_list) {
					var vo = scmd.level_list[_tmpi]
					// [ts2lua]dic下标访问可能不正确
					dic[vo.level] = vo
				}
				// [ts2lua]scmd下标访问可能不正确
				scmd["level_dic"] = dic
				model.SetPlayerInfo(scmd)
			}

			let on50702 = () => {
				let scmd = user_msg_adapter.GetSCMD(50702)
				table.sort(scmd.challengers, (a?, b?) => {
					return b.level < a.level
				})
				let dic = []
				for (let _tmpi in scmd.challengers) {
					var vo = scmd.challengers[_tmpi]
					vo.area_id = scmd.area_id
					// [ts2lua]dic下标访问可能不正确
					dic[vo.level] = vo
				}
				// [ts2lua]scmd下标访问可能不正确
				scmd["challenger_dic"] = dic
				model.SetAreaTowerData(scmd)
			}

			let on50703 = () => {
				let scmd = user_msg_adapter.GetSCMD(50703)
				table.sort(scmd.challengers, (a?, b?) => {
					return b.level < a.level
				})
				let dic = []
				for (let _tmpi in scmd.challengers) {
					var vo = scmd.challengers[_tmpi]
					vo.area_id = scmd.area_id
					// [ts2lua]dic下标访问可能不正确
					dic[vo.level] = vo
				}
				// [ts2lua]scmd下标访问可能不正确
				scmd["challenger_dic"] = dic
				model.SetAreaTopData(scmd)
			}

			let on50704 = () => {
				let scmd = user_msg_adapter.GetSCMD(50704)
				if (scmd.error_code == 1) {
					Message.show("领取成功")
					let pinfo = model.GetPlayerInfo()
					if (!pinfo) {
						return
					}
					pinfo.rw_state = scmd.rw_state
					model.CheckRewardRedStatus(pinfo)
					model.Fire(kfSREvent.UPDATE_RW_STATE, scmd)

					ResManager.GetInstance().LoadGameConfig(this, "config_rank_dungeon_daily", false, null, (cfg) => {
						let lv = pinfo.start_level
						let rlist = JSON.parse(cfg[lv].reward)
						if (!rlist || rlist.length < 1) {
							return
						}
						Util.ShowCongratulationView(rlist)
						ResManager.GetInstance().DestoryGameConfig(this, "config_rank_dungeon_daily")
					})

				} else {
					Util.ErrorCodeShow(scmd.error_code)
				}
			}

			let on50705 = () => {
				let scmd = user_msg_adapter.GetSCMD(50705)
				if (scmd.result_type == 1) {
					local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "kfSRVictoryView", scmd)
					model.Fire(kfSREvent.UDPATE_RESULT, scmd)
				} else {
					local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "DungeonFailureView")
				}
			}

			this.RegisterProtocal(50701, on50701)
			this.RegisterProtocal(50702, on50702)
			this.RegisterProtocal(50703, on50703)
			this.RegisterProtocal(50704, on50704)
			this.RegisterProtocal(50705, on50705)
		}

		this.InitInfo()
		this.InitEvent()
	}

}
window["kfSingleRankController"] = kfSingleRankController