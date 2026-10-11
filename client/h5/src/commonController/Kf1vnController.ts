

import { AutoFightManager } from "../autofight/AutoFightManager"
import { BaseController } from "../common/BaseController"
import { CommonManager } from "../common/CommonManager"
import { EventName, SceneEventType } from "../common/EventName"
import { table } from "../common/table"
import { UserMsgAdapter } from "../common/UserMsgAdapter"
import { ActivityIconManager } from "../commonModel/ActivityIconManager"
import { CustomActivityDefine } from "../commonModel/CustomActivityDefine"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"
import { DailyModel } from "../commonModel/DailyModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { Kf1vnModel, Kf1vnEvent, KfViewIndex } from "../commonModel/Kf1vnModel"
import { MainUIModel } from "../commonModel/MainUIModel"
import { RoleManager } from "../commonModel/RoleManager"
import { SceneManager } from "../scene/SceneManager"
import { ServerTimeModel } from "../serverTime/ServerTimeModel"
import { Message } from "../sysInfo/SysInfoController"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { TimeUtil } from "../util/TimeUtil"
import { Util } from "../util/Util"
import { Config } from "../common/Config"

import "../commonModel/Kf1vnModel"
import "../kf1vn/Kf1vnChallengerDetailView"
import "../kf1vn/Kf1vnChallengerMsgItem"
import "../kf1vn/Kf1vnEnterView"
import "../kf1vn/Kf1vnFightResultView"
import "../kf1vn/Kf1vnFightSceneView"
import "../kf1vn/Kf1vnMatchSuccessView"
import "../kf1vn/Kf1vnPlatformMatchSuccessView"
import "../kf1vn/Kf1vnPlatformPlayingItem"
import "../kf1vn/Kf1vnPlatformPlayingView"
import "../kf1vn/Kf1vnPlatformRewardItem"
import "../kf1vn/Kf1vnQuizHistoryItem"
import "../kf1vn/Kf1vnQuizHistoryView"
import "../kf1vn/Kf1vnQuizRadioItem"
import "../kf1vn/Kf1vnQuizSelectItem"
import "../kf1vn/Kf1vnQuizSelectView"
import "../kf1vn/Kf1vnRankItem"
import "../kf1vn/Kf1vnRankView"
import "../kf1vn/Kf1vnRewardView"
import "../kf1vn/Kf1vnRoleHpItem"
import "../kf1vn/Kf1vnSettlementView"
import "../kf1vn/Kf1vnShopExchangeItem"
import "../kf1vn/Kf1vnShopExchangeView"
import "../kf1vn/Kf1vnShopView"
import "../kf1vn/Kf1vnTicketRewardItem"
import "../kf1vn/Kf1vnWaitSceneView"
import "../kf1vn/Kf1vnTabItem"
import { ViewManager } from "../common/ViewManager"


//最强王者模块
export class Kf1vnController extends BaseController {
	ChangeScene
	InitEvent
	InitInfo
	SetMainUIVisible
	ShowIcon


	public constructor() {
		super()

		let scene_mgr = SceneManager.GetInstance()

		let role_mgr = RoleManager.GetInstance()


		let activity_icon_mgr = ActivityIconManager.GetInstance()
		let user_msg_adapter = UserMsgAdapter.GetInstance()

		let auto_fight_mgr = AutoFightManager.GetInstance()
		let model = Kf1vnModel.GetInstance()
		let view_dic_ = []
		this.InitEvent = () => {
			model.Bind(Kf1vnEvent.KF1VN_REQUEST_PROTO, (id, fmt, ...new_args) => {
				this.SendFmtToGame(id, fmt, ...new_args)
			}
			)

			model.Bind(Kf1vnEvent.OPEN_DIAOND_FIGHT_VIEW, () => {
				let view = view_dic_["Kf1vnView"]
				if (!view) {
					view = window["Kf1vnView"]
					view_dic_["Kf1vnView"] = new view()
				}
				if (view.HasOpen()) {
					view.SetSelectIndex(KfViewIndex.Eudaemon_Ridge_Boss)
				} else {
					view.SetDefaultIndex(KfViewIndex.Eudaemon_Ridge_Boss)
					view.Open()
				}
			}
			)
			let InitRequest = () => {
				let cfg = CommonManager.GetInstance().GetFunctionIconCfg(621)
				if (((cfg && role_mgr.mainRoleInfo) && role_mgr.mainRoleInfo.level >= cfg.open_lv) && ServerTimeModel.GetInstance().GetOpenServerDay() >= cfg.open_day) {
					model.Fire(Kf1vnEvent.KF1VN_REQUEST_PROTO, 62101)
					model.Fire(Kf1vnEvent.KF1VN_REQUEST_PROTO, 62133)
					GoodsModel.GetInstance().Fire(GoodsModel.REQUEST_EXCHANGE_GOODS, Kf1vnModel.ExchangeShopType)
				}
			}

			GlobalEventSystem.Bind(EventName.INIT_CONFIG, () => {
				model.InitConfig()
			}
			)
			GlobalEventSystem.Bind(EventName.GAME_START, () => {
				activity_icon_mgr.deleteIcon(Kf1vnModel.ICON_TYPE)
				model.ClearData()
				InitRequest()
			}
			)
			role_mgr.GetMainRoleVo().Bind(EventName.CHANGE_LEVEL, () => {
				InitRequest()
			}
			)
			let scene_changed_func = () => {
				this.ChangeScene()
			}
			GlobalEventSystem.Bind(SceneEventType.SCENE_CHANGED, scene_changed_func)
			GlobalEventSystem.Bind(SceneManager.START, scene_changed_func)
			let refresh_1vn_dot_fun = () => {
				GlobalEventSystem.Fire(EventName.REFRESH_ACTIVITY_ICON_RED_DOT, 2820)
			}
			GoodsModel.GetInstance().Bind(GoodsModel.UPDATE_SPECIAL_SCORE, refresh_1vn_dot_fun)
			GlobalEventSystem.Bind(ServerTimeModel.DAY_CHANGE, () => {
				let openDay = ServerTimeModel.GetInstance().GetOpenServerDay()
				let cfg = Config.PRELOAD_CLIENT_CONFIG.ConfigFuncOpenCondition
				let view_cfg = cfg.Kf1vnEnterView
				if (openDay < view_cfg.open_day) {
					activity_icon_mgr.deleteIcon(Kf1vnModel.ICON_TYPE)
				}
            });
		}

		this.ShowIcon = (stage?) => {
			let txt = ""
			let color
			let has_sign = false
			if(!model.page_info){
				return
			}
			if (model.page_info && model.page_info.is_sign == 1) {
				has_sign = true
			}
			if (stage == 1) {
				txt = has_sign ? "已报名" : "报名中"
					color="#88ff43"
			} else if (stage >= 2) {
				txt = "进行中"
				color="#88ff43"
			}
			if (stage >= 1 && stage != 6) {
				if (stage == 1 && has_sign) {
					activity_icon_mgr.deleteIcon(Kf1vnModel.ICON_TYPE)
				} else {
				let icon_info = activity_icon_mgr.getIconInfo(Kf1vnModel.ICON_TYPE)
				if (icon_info) {
					GlobalEventSystem.Fire(ActivityIconManager.SET_ICON_TEXT, Kf1vnModel.ICON_TYPE, txt,color)
				} else {
					activity_icon_mgr.addIcon(Kf1vnModel.ICON_TYPE, null, null, txt)
					}
				}
				model.StartChuanWenTimer()
				//1vn开启预告
				if (((stage == 1 && !has_sign) || (has_sign && (stage == 2 || stage == 3)))
					&& !model.had_show_foreshow) {
					if (!scene_mgr.IsKf1vnWaitingScene() && !scene_mgr.IsKf1vnWaitingScene()) {
						let activity = DailyModel.GetInstance().GetAcCfgByTypeStr(Kf1vnModel.ForeshowType)
						if (activity) {
							model.had_show_foreshow = true
							CustomActivityModel.GetInstance().Fire(CustomActivityDefine.EVENT.SHOW_FORES_TIPS_VIEW, activity, true)
						}
					} else {
						model.had_show_foreshow = true
					}
				}
			} else {
				activity_icon_mgr.deleteIcon(Kf1vnModel.ICON_TYPE)
			}
		}

		this.InitInfo = () => {
			let Handler62100 = () => {
				let scmd = user_msg_adapter.GetSCMD(62100)
				//console.log("62100//////////////")
				//PrintTable(scmd)
				model.ChangeVar("page_info", scmd)
				if (model.stage_info) {
					this.ShowIcon(model.stage_info.stage)
				}
				model.RefreshIcon()
			}

			let Handler62101 = () => {
				let scmd = user_msg_adapter.GetSCMD(62101)
				//console.log("62101//////////////")
				//PrintTable(scmd)
				let info = model.stage_info
				if (info) {
					if (info.stage != scmd.stage) {
						model.Fire(Kf1vnEvent.KF1VN_REQUEST_PROTO, 62100)
						model.Fire(Kf1vnEvent.KF1VN_REQUEST_PROTO, 62104)
					}
				} else {
					model.Fire(Kf1vnEvent.KF1VN_REQUEST_PROTO, 62100)
				}
				//预告标志
				if (!model.stage_info || ((scmd.stage == 1 || scmd.stage == 2 || scmd.stage == 3) && model.stage_info.stage != scmd.stage)) {
					model.had_show_foreshow = false
				}
				model.SetStageInfo(scmd)
				model.UpdateQuizInfo()
				this.ShowIcon(scmd.stage)
				//if (scmd.stage >= 2 && scmd.stage <= 3 && ! model.rank_info_in_waiting_scene && scene_mgr.IsKf1vnWaitingScene() ) {
				if (scmd.stage >= 2 && scmd.stage <= 3 && scene_mgr.IsKf1vnWaitingScene()) {
					model.Fire(Kf1vnEvent.KF1VN_REQUEST_PROTO, 62119)
				} 
				else if (scmd.stage == 5) {
					if (scene_mgr.IsKf1vnWaitingScene()) {
						//GlobalEventSystem.Fire(EventName.OPEN_VIEW, "Kf1vnPlatformPlayingView")
						if (scmd.sub_stage <= 2) {
							model.Fire(Kf1vnEvent.KF1VN_REQUEST_PROTO, 62117)
						}
					}
				}
				model.RefreshIcon()
			}

			let Handler62102 = () => {
				let scmd = user_msg_adapter.GetSCMD(62102)
				Util.ErrorCodeShow(scmd.error_code)
				if (scmd.error_code == 1) {
					model.Fire(Kf1vnEvent.KF1VN_REQUEST_PROTO, 62100)
				}
			}

			let Handler62103 = () => {
				let scmd = user_msg_adapter.GetSCMD(62103)
				Util.ErrorCodeShow(scmd.error_code)
			}

			let Handler62104 = () => {
				let scmd = user_msg_adapter.GetSCMD(62104)
				model.ChangeVar("ticket_wait_info", scmd)
			}

			let Handler62105 = () => {
				let scmd = user_msg_adapter.GetSCMD(62105)
				scmd["type"] = 1
				model.ChangeVar("ticket_fighting_info", scmd)
				if (scene_mgr.IsKf1vnFightScene()) {
					let loading_time = scmd.loading_time - TimeUtil.getServerTime()

					//检验场次
					if(model.data_obj_["Kf1vnMatchSuccessView"]&&model.data_obj_["Kf1vnMatchSuccessView"]==scmd.battle_time){
						return
					}
					if (loading_time >= 1) {
						if(!ViewManager.GetInstance().GetViewOpenState("Kf1vnMatchSuccessView")){
							model.data_obj_["Kf1vnMatchSuccessView"] = scmd.battle_time
					GlobalEventSystem.Fire(EventName.OPEN_VIEW,"Kf1vnMatchSuccessView",scmd)
						}
					} else {
						auto_fight_mgr.SetAutoFight(true)
					}
				}
			}

			let Handler62107 = () => {
				let scmd = user_msg_adapter.GetSCMD(62107)
				Util.ErrorCodeShow(scmd.error_code)
			}

			let Handler62108 = () => {
				let scmd = user_msg_adapter.GetSCMD(62108)
				scmd["type"] = 1
				//console.log(scmd)
				GlobalEventSystem.Fire(EventName.OPEN_VIEW,"Kf1vnFightResultView",scmd)
			}

			let Handler62109 = () => {
				let scmd = user_msg_adapter.GetSCMD(62109)
				scmd["type"] = 1
				//console.log("62109//////////////")
				//PrintTable(scmd)
				GlobalEventSystem.Fire(EventName.OPEN_VIEW,"Kf1vnSettlementView",scmd)
			}

			let Handler62110 = () => {
				let scmd = user_msg_adapter.GetSCMD(62110)
				let sort_fun = (a?, b?) => {
					return a.rank < b.rank
				}
				//console.log("62110//////////////")
				//PrintTable(scmd)
				table.sort(scmd.rank_1_list, sort_fun)
				model.ChangeVar("ticket_rank_data", scmd)
			}

			let Handler62111 = () => {
				let scmd = user_msg_adapter.GetSCMD(62111)
				//console.log("62111//////////////")
				//PrintTable(scmd)
			}

			let Handler62112 = () => {
				let scmd = user_msg_adapter.GetSCMD(62112)
				scmd["type"] = 2
				let mid = role_mgr.GetMainRoleVo().role_id
				let isPart = false
				if (mid == scmd.player_id) {
					isPart = false
				} else {
					for (let _tmpi in scmd.challenger_list) {
						var vo = scmd.challenger_list[_tmpi]
						if (vo.player_id == mid) {
							isPart = true
							break
						}
					}
				}
				scmd["isPart"] = isPart


				model.ChangeVar("leader_fighting_info", scmd)
				if (scene_mgr.IsKf1vnFightScene()) {
					let loading_time = scmd.loading_time - TimeUtil.getServerTime()
					//检验场次
					if(model.data_obj_["Kf1vnPlatformMatchSuccessView"]&&model.data_obj_["Kf1vnPlatformMatchSuccessView"]==scmd.battle_time){
						return
					}
					if (loading_time >= 1) {
						if(!ViewManager.GetInstance().GetViewOpenState("Kf1vnPlatformMatchSuccessView")){
							model.data_obj_["Kf1vnPlatformMatchSuccessView"] = scmd.battle_time
					GlobalEventSystem.Fire(EventName.OPEN_VIEW,"Kf1vnPlatformMatchSuccessView",scmd)
						}
					} else {
						auto_fight_mgr.SetAutoFight(true)
					}
				}
			}

			let Handler62113 = () => {
				let scmd = user_msg_adapter.GetSCMD(62113)
				scmd["type"] = 2
				console.log(scmd)
				GlobalEventSystem.Fire(EventName.OPEN_VIEW,"Kf1vnFightResultView",scmd)
			}

			let Handler62116 = () => {
				let scmd = user_msg_adapter.GetSCMD(62116)
				let sort_fun = (a?, b?) => {
					return a.rank < b.rank
				}
				table.sort(scmd.rank_2_def_rank, sort_fun)
				//console.log("62116//////////////")
				//PrintTable(scmd)
				model.ChangeVar("leader_rank_data", scmd)
			}

			let Handler62117 = () => {
				let scmd = user_msg_adapter.GetSCMD(62117)
				let sort_fun = (a?, b?) => {
					return b.battle_id < a.battle_id
				}
				table.sort(scmd.bet_list, sort_fun)
				model.quiz_info = scmd
				model.Fire(Kf1vnEvent.KF1VN_UPDATE_QUIZ_INFO)
			}

			let Handler62118 = () => {
				let scmd = user_msg_adapter.GetSCMD(62118)
				//console.log("62118//////////////")
				//PrintTable(scmd)
				if (scmd.error_code == 1) {
					Message.show("竞猜成功")
					if (model.quiz_info) {
						for (let _tmpi in model.quiz_info.bet_list) {
							var vo = model.quiz_info.bet_list[_tmpi]
							if (vo.battle_id == scmd.battle_id) {
								vo.is_bet = 1
								break
							}
						}
					}
					if (model.quiz_info && model.quiz_info.bet_num != null) {
						model.quiz_info.bet_num = model.quiz_info.bet_num + 1
					}
					model.Fire(Kf1vnEvent.KF1VN_UPDATE_QUIZ_INFO)
				} else {
					Util.ErrorCodeShow(scmd.error_code)
				}
			}

			let Handler62119 = () => {
				let scmd = user_msg_adapter.GetSCMD(62119)
				//console.log("62119//////////////")
				//PrintTable(scmd)
				model.ChangeVar("rank_info_in_waiting_scene", scmd)
			}

			let Handler62120 = () => {
				let scmd = user_msg_adapter.GetSCMD(62120)
				scmd["type"] = 2
				//console.log("62120//////////////")
				//PrintTable(scmd)
				GlobalEventSystem.Fire(EventName.OPEN_VIEW,"Kf1vnSettlementView",scmd)
			}

			let Handler62121 = () => {
				let scmd = user_msg_adapter.GetSCMD(62121)
				//console.log("62121//////////////")
				//PrintTable(scmd)
				if (scmd.error_code != 1) {
					Util.ErrorCodeShow(scmd.error_code)
					model.is_vistor = false
				}
			}

			let Handler62123 = () => {
				let scmd = user_msg_adapter.GetSCMD(62123)
				if (model.quiz_info) {
					for (let _tmpi in model.quiz_info.bet_list) {
						var vo = model.quiz_info.bet_list[_tmpi]
						if (vo.battle_id == scmd.battle_id) {
							if (scmd.bet_result != 0) {
								vo.battle_result = scmd.battle_result
								vo.is_bet = 1
								vo.status = 2
								vo.bet_result = scmd.bet_result
							}
							break
						}
					}
				}
				model.Fire(Kf1vnEvent.KF1VN_UPDATE_QUIZ_INFO)
			}

			let Handler62132 = () => {
				let scmd = user_msg_adapter.GetSCMD(62132)
				Util.ErrorCodeShow(scmd.error_code)
			}

			let Handler62133 = () => {
				let scmd = user_msg_adapter.GetSCMD(62133)
				let sort_fun = (a?, b?) => {
					if (a.status == b.status) {
						if (a.race_2_turn == b.race_2_turn) {
							return b.key < a.key
						} else {
							return b.race_2_turn < a.race_2_turn
						}
					} else {
						return b.status < a.status
					}
				}
				table.sort(scmd.bet_list, sort_fun)
				model.ChangeVar("quiz_history", scmd)
				GlobalEventSystem.Fire(EventName.REFRESH_ACTIVITY_ICON_RED_DOT, 2820)
			}

			let Handler62134 = () => {
				let scmd = user_msg_adapter.GetSCMD(62134)
				model.Fire(Kf1vnEvent.KF1VN_GET_QUIZ_REWARD_SUCCESS, scmd.key)
				model.Fire(Kf1vnEvent.KF1VN_REQUEST_PROTO, 62133)
			}

			let Handler62135 = () => {
				let scmd = user_msg_adapter.GetSCMD(62135)
				if (model.quiz_info) {
					for (let _tmpi in model.quiz_info.bet_list) {
						var vo = model.quiz_info.bet_list[_tmpi]
						if (vo.battle_id == scmd.battle_id) {
							if (scmd.battle_result != 0) {
								vo.status = 2
							}
							vo.battle_result = scmd.battle_result
							break
						}
					}
				}
				model.Fire(Kf1vnEvent.KF1VN_UPDATE_QUIZ_INFO)
			}

			let Handler62136 = () => {
				let scmd = user_msg_adapter.GetSCMD(62136)
			}

			this.RegisterProtocal(62100, Handler62100)
			this.RegisterProtocal(62101, Handler62101)
			this.RegisterProtocal(62102, Handler62102)
			this.RegisterProtocal(62103, Handler62103)
			this.RegisterProtocal(62104, Handler62104)
			this.RegisterProtocal(62105, Handler62105)
			this.RegisterProtocal(62107, Handler62107)
			this.RegisterProtocal(62108, Handler62108)
			this.RegisterProtocal(62109, Handler62109)
			this.RegisterProtocal(62110, Handler62110)
			this.RegisterProtocal(62111, Handler62111)
			this.RegisterProtocal(62112, Handler62112)
			this.RegisterProtocal(62113, Handler62113)
			this.RegisterProtocal(62116, Handler62116)
			this.RegisterProtocal(62117, Handler62117)
			this.RegisterProtocal(62118, Handler62118)
			this.RegisterProtocal(62119, Handler62119)
			this.RegisterProtocal(62120, Handler62120)
			this.RegisterProtocal(62121, Handler62121)
			this.RegisterProtocal(62123, Handler62123)
			this.RegisterProtocal(62132, Handler62132)
			this.RegisterProtocal(62133, Handler62133)
			this.RegisterProtocal(62134, Handler62134)
			this.RegisterProtocal(62135, Handler62135)
			this.RegisterProtocal(62136, Handler62136)
		}

		this.ChangeScene = () => {

			//等待匹配界面
			if (scene_mgr.IsKf1vnWaitingScene()){
				model.is_vistor = false
				model.ticket_fighting_info = null
				model.leader_fighting_info = null
				this.SetMainUIVisible(false)
				
				GlobalEventSystem.Fire(EventName.CLOSE_VIEW,"Kf1vnFightSceneView")
				GlobalEventSystem.Fire(EventName.OPEN_VIEW,"Kf1vnWaitSceneView")
				GlobalEventSystem.Fire(EventName.CLOSE_CHAT_VIEW)
				let sInfo = model.stage_info
				model.Fire(Kf1vnEvent.KF1VN_REQUEST_PROTO, 62101)
				//if (sInfo && sInfo.stage >= 2 && sInfo.stage <= 3 ) {
				model.Fire(Kf1vnEvent.KF1VN_REQUEST_PROTO, 62119)
				//}
				model.Fire(Kf1vnEvent.KF1VN_REQUEST_PROTO, 62104)
			}
			//战斗界面
			else if(scene_mgr.IsKf1vnFightScene()){
				auto_fight_mgr.SetAutoFight(false)
				this.SetMainUIVisible(false)
				GlobalEventSystem.Fire(EventName.CLOSE_VIEW, "Kf1vnWaitSceneView")
				GlobalEventSystem.Fire(EventName.OPEN_VIEW, "Kf1vnFightSceneView")
				// model.Fire(Kf1vnEvent.KF1VN_CLOSE_PLAYING_VIEW)
				let fightData = null
				let sInfo = model.stage_info
				if (sInfo) {
					if (sInfo.stage == 3) {
						fightData = model.ticket_fighting_info
					} else if (sInfo.stage == 5) {
						fightData = model.leader_fighting_info
					}
					if (fightData && sInfo.stage == 3) {
						model.Fire(Kf1vnEvent.KF1VN_REQUEST_PROTO, 62105)
					}
					if (fightData && sInfo.stage == 5) {
						model.Fire(Kf1vnEvent.KF1VN_REQUEST_PROTO, 62112)
					}
					// if (1) {
					// 	if (sInfo.stage == 3 || sInfo.stage == 5) {
					// 		let loading_time = fightData.loading_time - TimeUtil.getServerTime()
					// 		//console.log("loading剩余时间//////////////-：", fightData.loading_time, loading_time)
					// 		if (loading_time >= 1) {
					// 			if (sInfo.stage == 3) {
					// 				//GlobalEventSystem.Fire(EventName.OPEN_VIEW, "Kf1vnMatchSuccessView", fightData)
					// 			} else {
					// 				GlobalEventSystem.Fire(EventName.OPEN_VIEW, "Kf1vnPlatformMatchSuccessView", fightData)
					// 			}
					// 		} else if (loading_time > 0) {
					// 			setTimeout(() => {
					// 				auto_fight_mgr.SetAutoFight(true)
					// 			}
					// 				, loading_time)
					// 		} else {
					// 			auto_fight_mgr.SetAutoFight(true)
					// 		}
					// 	}
					// }
				}
				GlobalEventSystem.Fire(EventName.OPEN_VIEW, "Kf1vnFightSceneView")
			}else{
				model.is_vistor = false
				model.ticket_fighting_info = null
				GlobalEventSystem.Fire(EventName.CLOSE_VIEW, "Kf1vnFightSceneView")
				GlobalEventSystem.Fire(EventName.CLOSE_VIEW, "Kf1vnWaitSceneView")
			}

		}

		this.SetMainUIVisible = (bool?) => {
			model.SetMainUIVisible(bool)
		}

		this.InitInfo()
		this.InitEvent()
	}


}
window["Kf1vnController"]=Kf1vnController