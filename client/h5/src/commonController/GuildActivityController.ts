

import { Alert, Alert_Type } from "../alert/Alert"
import { AutoFightManager } from "../autofight/AutoFightManager"
import { BaseController } from "../common/BaseController"
import { CongratulationObtainView } from "../common/CongratulationObtainView"
import { EventName } from "../common/EventName"
import { OpenFun } from "../common/OpenFun"
import { table } from "../common/table"
import { UserMsgAdapter } from "../common/UserMsgAdapter"
import { GoodsModel } from "../commonModel/GoodsModel"
import { GuildActEvent, GuildActivityModel } from "../commonModel/GuildActivityModel"
import { MainUIModel, MainFunc } from "../commonModel/MainUIModel"
import { SceneManager } from "../scene/SceneManager"
import { Message } from "../sysInfo/SysInfoController"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { Util } from "../util/Util"
import { MainUIController } from "./MainUIController"
import "../evening/EveningAnswerItem"
import "../evening/EveningAnswerView"
import "../evening/EveningAnswerWaitView"
import "../evening/EveningBaseView"
import "../evening/EveningBossDamageItem"
import "../evening/EveningBossNormalView"
import "../evening/EveningBossPanel"
import "../evening/EveningChatItem"
import "../evening/EveningDragonCallItem"
import "../evening/EveningDragonWaitView"
import "../evening/EveningAnswerRankView"
import "../evening/EveningIntroItem"
import "../evening/EveningIntroView"
import "../evening/EveningMainBaseView"
import "../evening/EveningMainBossGroup"
import "../evening/Evening1MainConItem"
import "../evening/EveningMainItem"
import "../evening/EveningMainView"
import "../evening/EveningRankRewardItem"
import "../evening/EveningRankRewardView"
import "../evening/EveningRewardItem"
import "../evening/EveningFoodView"
import "../evening/EveningFoodItem"
import "../evening/EveningMainConGameGroup"
import "../common/CongratulationObtainView"
import "../common/CongratulationRareView"
import { AuctionEvent, AuctionModel } from "../commonModel/AuctionModel"
import { GuildModel } from "../commonModel/GuildModel"

//require("game.evening.EveningIntroTextItem")
export class GuildActivityController extends BaseController {
	ChangeScene
	InitEvent
	InitInfo
	SetMainUIVisible


	public constructor() {
		super()

		let local_GuildActEvent = GuildActEvent
		let local_GlobalEventSystem = GlobalEventSystem
		let local_EventName = EventName
		let open_view_event = EventName.OPEN_VIEW
		let auction_model = AuctionModel.GetInstance()
		let local_AuctionModel = AuctionModel
		let local_Alert = Alert
		let user_msg_adapter = UserMsgAdapter.GetInstance()
		let local_Util = Util
		let local_Message = Message
		let model = GuildActivityModel.GetInstance()
		this.InitEvent = () => {
			model.Bind(local_GuildActEvent.REQUEST_PROTO, (id, fmt, ...new_args) => {
				this.SendFmtToGame(id, fmt, ...new_args)
			}
			)
			local_GlobalEventSystem.Bind(local_EventName.INIT_CONFIG, () => {

			}
			)
			local_GlobalEventSystem.Bind(local_EventName.GAME_START, () => {
				model.InitConfig()
				model.Reset()
				setTimeout(() => {
					this.SendFmtToGame(40201)
					// this.SendFmtToGame(40211)
					this.SendFmtToGameImme(40211)
				}
					, 1.5 / 1000)
			}
			)
			local_GlobalEventSystem.Bind(SceneManager.START, () => {
				this.ChangeScene()
			}
			)
		}

		this.ChangeScene = () => {
			let scene_mgr = SceneManager.GetInstance()
			if (scene_mgr.IsEveningScene()) {
				model.Fire(GuildActEvent.REQUEST_PROTO, 40214)
			}
			if (scene_mgr.IsEveningScene() && !scene_mgr.IsEveningScene(scene_mgr.GetLastSceneId())) {
				let act_info = model.GetActInfo()
				if (!act_info) {
					local_Message.show("没有活动信息")
					return
				}
				this.SetMainUIVisible(false)
				model._change_scene_mark = true
				this.SendFmtToGameImme(40211)
				auction_model.Fire(AuctionEvent.REQUEST_PROTO, 15401, "iii", local_AuctionModel.TYPE.GUILD, 0, 0)
			} else if (!scene_mgr.IsEveningScene() && scene_mgr.IsEveningScene(scene_mgr.GetLastSceneId())) {
				AutoFightManager.GetInstance().SetAutoFight(true)
				this.SetMainUIVisible(true)
				local_GlobalEventSystem.Fire(local_EventName.CLOSE_VIEW, "EveningBaseView")
				local_GlobalEventSystem.Fire(local_EventName.CLOSE_VIEW, "EveningBossNormalView")
			} else if (!scene_mgr.IsEveningScene()) {
				local_GlobalEventSystem.Fire(local_EventName.CLOSE_VIEW, "EveningBaseView")
				local_GlobalEventSystem.Fire(local_EventName.CLOSE_VIEW, "EveningBossNormalView")
			}

			GlobalEventSystem.Fire(EventName.REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Guild)
		}

		this.SetMainUIVisible = (bool?) => {
			let mainUI_controller = MainUIController.GetInstance()
			mainUI_controller.SetMainUIViewVisible(0, bool)
			mainUI_controller.SetMainUIViewVisible(10, bool)
			MainUIModel.GetInstance().Fire(MainUIModel.CHANGE_ACTIVITY_STATE, bool)
		}

		this.InitInfo = () => {
			let on40200 = () => {
				let scmd = user_msg_adapter.GetSCMD(40200)
				Util.ErrorCodeShow(scmd.errcode)
			}

			let on40211 = () => {
				let scmd = user_msg_adapter.GetSCMD(40211)
				model.SetActInfo(scmd)
				GuildModel.GetInstance().SetEveningRedDot();
				local_GlobalEventSystem.Fire(local_EventName.REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Guild)
				if (SceneManager.GetInstance().IsEveningScene()) {
					model.CheckOpenView()
				}

				
				if (model._change_scene_mark ) {
					model.CheckOpenView()
					model._change_scene_mark = false
				}
				let scene_mgr = SceneManager.GetInstance()
				if (1 == scmd.status && scene_mgr.IsEveningScene() && ! scene_mgr.IsEveningScene(scene_mgr.GetLastSceneId()) ) {
					this.SetMainUIVisible(false)
					model.CheckOpenView()
				}
			}

			let on40212 = () => {
				let scmd = user_msg_adapter.GetSCMD(40212)
				if (scmd.errcode == 1) {
					this.SendFmtToGame(40211)
				} else {
					Util.ErrorCodeShow(scmd.errcode)
				}
			}

			let on40214 = () => {
				let scmd = user_msg_adapter.GetSCMD(40214)
				model.SetRankInfo(scmd)
			}

			let on40217 = () => {
				let scmd = user_msg_adapter.GetSCMD(40217)
				model.SetQuestInfo(scmd)
			}

			let on40218 = () => {
				let scmd = user_msg_adapter.GetSCMD(40218)
				if (scmd.errcode == 1) {

				} else {
					Util.ErrorCodeShow(scmd.errcode)
				}
			}

			let on40255 = () => {
				let scmd = user_msg_adapter.GetSCMD(40255)
				model.Fire(local_GuildActEvent.UPDATE_EXP, scmd)
			}

			let on40256 = () => {
				let scmd = user_msg_adapter.GetSCMD(40256)
				model.SetFireInfo(scmd)
			}

			let on40257 = () => {
				let scmd = user_msg_adapter.GetSCMD(40257)
				let reward_list = GoodsModel.RewardKeyToNumber(scmd.reward_list)
				let success_view = new CongratulationObtainView(reward_list, 10)
				success_view.Open()
			}

			let on40258 = () => {
				let scmd = user_msg_adapter.GetSCMD(40258)
			}

			let on40259 = () => {
				let scmd = user_msg_adapter.GetSCMD(40259)
				model.Fire(local_GuildActEvent.UPDATE_QUESTION_STATUS, scmd.status)
			}

			let on40260 = () => {
				let scmd = user_msg_adapter.GetSCMD(40260)
				model.SetDragonInfo(scmd)
			}

			let on40261 = () => {
				let scmd = user_msg_adapter.GetSCMD(40261)
			}

			let on40262 = () => {
				let scmd = user_msg_adapter.GetSCMD(40262)
				model.SetResultInfo(scmd)
				// if (scmd.status == 1) {
				// 	local_GlobalEventSystem.Fire(open_view_event, "EveningResultView")
				// } else if (scmd.status == 2) {
				// 	local_GlobalEventSystem.Fire(open_view_event, "DungeonFailureView")
				// }
			}

			let on40263 = () => {
				let scmd = user_msg_adapter.GetSCMD(40263)
				if (scmd.code == 1) {
					local_Message.show("召唤成功")
				} else {
					if (scmd.code == 4021045) {
						local_Alert.Show("召唤BOSS阶段剩余不足1分钟，召唤失败。\n召唤卡可用于下次活动开启时使用。", Alert_Type.One)
					} else {
						Util.ErrorCodeShow(scmd.code)
					}
				}
			}

			let on40264 = () => {
				let scmd = user_msg_adapter.GetSCMD(40264)
				if (scmd.code == 1) {
					model.Fire(GuildActEvent.UPDATE_FOOD_LIST, scmd)
					Message.show("购买菜肴成功")
				} else {
					Util.ErrorCodeShow(scmd.code)
				}
			}

			let on40265 = () => {
				let scmd = user_msg_adapter.GetSCMD(40265)
				model.Fire(GuildActEvent.UPDATE_FOOD_LIST, scmd)
			}

			let on40201 = () => {
				let scmd = user_msg_adapter.GetSCMD(40201)

				//屏蔽这个弹窗
				// if (scmd.mon_state == 1 && scmd.etime > 0) {
				// 	model.OpenBossIcon()
				// } else {
				// 	model.CloseBossIcon()
				// }
				model.SetBossInfo(scmd)
			}

			let on40203 = () => {
				let scmd = user_msg_adapter.GetSCMD(40203)
				local_Message.show("获得神兽诱饵:" + scmd.add_gboss_mat)
			}

			let on40204 = () => {
				let scmd = user_msg_adapter.GetSCMD(40204)
				if (scmd.errcode == 1) {
					let binfo = model.GetBossInfo()
					if (binfo) {
						binfo.is_drum_today = 1
					}
					model.Fire(local_GuildActEvent.CALL_BOSS_SUCCESS, scmd)
					//model.OpenBossIcon()//屏蔽这个弹窗
				} else if (scmd.errcode == 2) {
					model.CloseBossIcon()
				} else {
					Util.ErrorCodeShow(scmd.errcode)
				}
			}

			let on40208 = () => {
				let scmd = user_msg_adapter.GetSCMD(40208)
				if (scmd.gboss_result == 1) {
					local_GlobalEventSystem.Fire(open_view_event, "EveningBossResultView", scmd)
				} else {
					local_GlobalEventSystem.Fire(open_view_event, "DungeonFailureView")
				}
			}

			let on40209 = () => {
				let scmd = user_msg_adapter.GetSCMD(40209)
				if (scmd.errcode == 1) {
					if(scmd.is_auto){
						local_Message.show("设置自动召唤成功")
					}else{
						local_Message.show("取消自动召唤成功")
					}
					
				} else {
					Util.ErrorCodeShow(scmd.errcode)
				}
				model.Fire(local_GuildActEvent.UPDATE_AUTO, scmd)
			}

			let on40266 = () => {
				let scmd = user_msg_adapter.GetSCMD(40266)
				let list = []
				let func = (arr) => {
					if (arr && arr.length > 0) {
						for (let i = 0; i < arr.length; i++) {
							let vo = arr[i]
							table.insert(list, [vo.style, vo.typeId, vo.count])
					}
				}
					
				}
				func(scmd.reward)
				Util.ShowCongratulationView(list, 15);
			}

			let on40267 = () => {
				let scmd = user_msg_adapter.GetSCMD(40267)
				model.Fire(local_GuildActEvent.UPDATE_EXP_BUFF, scmd)
			}
			let on40220 = () => {
				let scmd = user_msg_adapter.GetSCMD(40220)
				model.my_rank_info = scmd
				model.Fire(local_GuildActEvent.UPDATE_MY_RANK_INFO)
			}
			let on40221 = () => {
				let scmd = user_msg_adapter.GetSCMD(40221)
				model.Fire(local_GuildActEvent.UPDATE_MINI_GAME_STATUS, scmd.is_finish)
			}
			let on40222 = () => {
				let scmd = user_msg_adapter.GetSCMD(40222)
				model.evening_game_type = scmd.game_type
			}

			this.RegisterProtocal(40200, on40200)
			this.RegisterProtocal(40211, on40211)
			this.RegisterProtocal(40212, on40212)
			this.RegisterProtocal(40214, on40214)
			this.RegisterProtocal(40217, on40217)
			this.RegisterProtocal(40218, on40218)
			this.RegisterProtocal(40255, on40255)
			this.RegisterProtocal(40256, on40256)
			this.RegisterProtocal(40257, on40257)
			this.RegisterProtocal(40258, on40258)
			this.RegisterProtocal(40259, on40259)
			this.RegisterProtocal(40260, on40260)
			this.RegisterProtocal(40261, on40261)
			this.RegisterProtocal(40262, on40262)
			this.RegisterProtocal(40263, on40263)
			this.RegisterProtocal(40264, on40264)
			this.RegisterProtocal(40265, on40265)
			this.RegisterProtocal(40201, on40201)
			this.RegisterProtocal(40203, on40203)
			this.RegisterProtocal(40204, on40204)
			this.RegisterProtocal(40208, on40208)
			this.RegisterProtocal(40209, on40209)
			this.RegisterProtocal(40266, on40266)
			this.RegisterProtocal(40267, on40267)
			this.RegisterProtocal(40220, on40220)
			this.RegisterProtocal(40221, on40221)
			this.RegisterProtocal(40222, on40222)
		}

		this.InitInfo()
		this.InitEvent()
	}

	static Instance
	public static GetInstance() {

		if (!GuildActivityController.Instance) {
			GuildActivityController.Instance = new GuildActivityController()
		}
		return GuildActivityController.Instance
	}

}
window["GuildActivityController"] = GuildActivityController