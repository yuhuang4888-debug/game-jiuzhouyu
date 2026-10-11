
import { Alert, Alert_Type } from "../alert/Alert"
import { BaseEnterDefine } from "../baseEnterView/BaseEnterDefine"
import { BaseController } from "../common/BaseController"
import { EventName, SceneEventType } from "../common/EventName"
import { FigureProtoVo } from "../common/FigureProtoVo"
import { OpenFun } from "../common/OpenFun"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { UserMsgAdapter } from "../common/UserMsgAdapter"
import { GuildFightModel, GuildFightEvent } from "../commonModel/GuildFightModel"
import { MainUIModel } from "../commonModel/MainUIModel"
import { RoleManager } from "../commonModel/RoleManager"
import { Scene } from "../scene/Scene"
import { SceneManager } from "../scene/SceneManager"
import { SceneObj } from "../scene/sceneobj/SceneObj"
import { Message } from "../sysInfo/SysInfoController"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { TimeUtil } from "../util/TimeUtil"
import { Util } from "../util/Util"
import { MainUIController } from "./MainUIController"
import { Config } from "../common/Config"

import "../guildFight/GuildFightCallItem"
import "../guildFight/GuildFightDistributionItem"
import "../guildFight/GuildFightDistributionView"
import "../guildFight/GuildFightEndRewardView"
import "../guildFight/GuildFightKillItem"
import "../guildFight/GuildFightMapItem"
import "../guildFight/GuildFightMapView"
import "../guildFight/GuildFightPanelItem"
import "../guildFight/GuildFightPanelSub"
import "../guildFight/GuildFightReliveView"
import "../guildFight/GuildFightRewardItem"
import "../guildFight/GuildFightRewardView"
import "../guildFight/GuildFightSceneView"
import "../guildFight/GuildFightSchItem"
import "../guildFight/GuildFightSchedule"
import "../guildFight/GuildFightView"
import "../guildFight/GuildFightWiningRewardItem"
import "../guildFight/GuildFightWiningRewardView"
import "../baseEnterView/BattleFieldEnterView"
import { GoodsModel } from "../commonModel/GoodsModel"
import { AutoFightManager } from "../autofight/AutoFightManager"
import { CommonManager } from "../common/CommonManager"
import { kfStageModel } from "../commonModel/kfStageModel"
import { FlowerrankModel } from "../commonModel/FlowerRankModel"


export class GuildFightController extends BaseController {
	InitInfo
	UpdateActRed
	public constructor() {
		super()

		GuildFightModel.GetInstance().ResConfig()
		this.UpdateActRed = () => {
			let red_state = GuildFightModel.GetInstance().IsShowRed()
			GlobalEventSystem.Fire(EventName.REFRESH_ACTIVITY_ICON_RED_DOT, 280)
			GlobalEventSystem.Fire(EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "BattleFieldEnterView", BaseEnterDefine.BattleFieldIndex().GuildFight, red_state)
		}

		this.InitInfo = () => {
			let guildfightModel: GuildFightModel = GuildFightModel.GetInstance()
			let user_msg_adapter = UserMsgAdapter.GetInstance()
			let role_mgr = RoleManager.GetInstance()
			let local_GlobalEventSystem = GlobalEventSystem
			//let update_window_red_event = EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE
			let refresh_activity_red_event = EventName.REFRESH_ACTIVITY_ICON_RED_DOT
			let local_EventName = EventName
			let local_GuildFightEvent = GuildFightEvent
			let local_Util = Util
			let local_Message = Message
			let scene_mgr = SceneManager.GetInstance()
			let local_TimeUtil = TimeUtil
			let local_Alert = Alert
			let local_Alert_Type = Alert_Type

			let mainUI_controller = MainUIController.GetInstance()
			let mainUI_model = MainUIModel.GetInstance()
			let view_dic_ = []
			let guildSceneView_ = null
			let Handler50600 = () => {
				let scmd = user_msg_adapter.GetSCMD(50600)
				let roleVo = role_mgr.GetMainRoleVo()
				guildfightModel.stateInfo = scmd
				// guildfightModel.ac_state = scmd.war_state == 3 && guildfightModel.selectInfo.qualification == 1
				guildfightModel.SetAcState(scmd.war_state == 3 && guildfightModel.selectInfo.qualification == 1)
				guildfightModel.SetSelectState()
				if (scmd.war_state == 1) {
					this.SendFmtToGame(50624)
				} else {
					this.SendFmtToGame(50621)
				}
				this.SendFmtToGame(50620)
				// let red_state = guildfightModel.IsShowRed()
				local_GlobalEventSystem.Fire(refresh_activity_red_event, 280)
				this.UpdateActRed()
				//local_GlobalEventSystem.Fire(update_window_red_event, "BattleFieldEnterView", BaseEnterDefine.BattleFieldIndex().GuildFight, red_state)
				guildfightModel.Fire(local_GuildFightEvent.UPDATE_AC_STATE, guildfightModel.ac_state)
			}

			let Handler50601 = () => {
				let scmd = user_msg_adapter.GetSCMD(50601)
				guildfightModel.SetWinData(scmd)
				guildfightModel.SetRedDotData(scmd)
				guildfightModel.Fire(local_GuildFightEvent.UPDATE_GUILD_FIGHT_VIEW)
			}

			let Handler50602 = () => {
				let scmd = user_msg_adapter.GetSCMD(50602)
				if (scmd.error_code == 1) {
					this.SendFmtToGame(50601)
					guildfightModel.day_red_dot = false
					//let red_state = guildfightModel.IsShowRed()
					//local_GlobalEventSystem.Fire(refresh_activity_red_event, 280)
					this.UpdateActRed()
					// local_GlobalEventSystem.Fire(update_window_red_event, "BattleFieldEnterView", BaseEnterDefine.BattleFieldIndex().GuildFight, red_state)


					ResManager.GetInstance().LoadGameConfig(this, "config_terri_war_win_reward", false, null, (cfg) => {
						if (cfg) {
							let world_lv = role_mgr.GetMainRoleVo().worldLv || 1
							for (let key in cfg) {
								if (cfg[key].min_wlv <= world_lv && world_lv <= cfg[key].max_wlv) {
									let daily_reward = JSON.parse(cfg[key].daily_reward)
									Util.ShowCongratulationView(daily_reward)
								}
							}
						}
						ResManager.GetInstance().DestoryGameConfig(this, "config_terri_war_win_reward")
					})

					local_Message.show("领取成功")
				} else {
					Util.ErrorCodeShow(scmd.error_code)
				}
			}

			let Handler50603 = () => {
				let scmd = user_msg_adapter.GetSCMD(50603)
				if (scmd.error_code != 1) {
					Util.ErrorCodeShow(scmd.error_code)
				}
			}

			let Handler50611 = () => {
				let scmd = user_msg_adapter.GetSCMD(50611)
				if (scene_mgr.IsGuildFightScene()) {

					//策划说更换成通用的奖励面板

					ResManager.GetInstance().LoadGameConfig(this, "config_terri_war_battle_reward", false, null, (Cfg) => {
						let data_ = scmd
						let gmodel = GoodsModel.GetInstance()


						for (let _tmpi in data_.guild_list) {
							var vo = data_.guild_list[_tmpi]
							if (vo.guild_id == RoleManager.GetInstance().GetMainRoleVo().guild_id) {
								let key = data_.territory_id + "@" + data_.mode_num
								// [ts2lua]Cfg下标访问可能不正确
								if (Cfg && Cfg[key]) {
									let reward_list = []
									if (vo.is_win == 1) {
										CommonManager.GetInstance().PlayFightingVoice(2)
										reward_list = JSON.parse(Cfg[key].win_reward)
									} else {
										CommonManager.GetInstance().PlayFightingVoice(1)
										reward_list = JSON.parse(Cfg[key].fail_reward)
									}

									let list = []
									for (let key in reward_list) {
										table.insert(list, reward_list[key])
									}
									// table.insert(list, [type, vo.id, vo.num])
									Util.ShowCongratulationView(list, 10)
								}
							}
						}

						ResManager.GetInstance().DestoryGameConfig(this, "config_terri_war_battle_reward")
					})

				}
				this.SendFmtToGame(50620)
				this.SendFmtToGame(50600)
			}

			let Handler50612 = () => {
				let scmd = user_msg_adapter.GetSCMD(50612)
				guildfightModel.Fire(local_GuildFightEvent.UPDATE_ROLE_SCORE, scmd)
			}

			let Handler50617 = () => {
				let scmd = user_msg_adapter.GetSCMD(50617)

				ResManager.GetInstance().LoadGameConfig(this, "config_terri_mon", false, null, (cfg) => {
					// [ts2lua]cfg下标访问可能不正确
					if (!guildfightModel.warInfo || !guildfightModel.warInfo.territory_id) {
						return
					}
					let CurCfg = cfg[guildfightModel.warInfo.territory_id + "@" + scmd.mon_id]
					if (CurCfg) {
						let end_pos = { x: CurCfg.x / SceneObj.GetLogicRealRatio().x, y: CurCfg.y / SceneObj.GetLogicRealRatio().y }
						let ok_func = () => {
							GlobalEventSystem.Fire(EventName.STOPAUTOFIGHT)
							Scene.GetInstance().MainRoleMove(end_pos, 0, () => {
								GlobalEventSystem.Fire(EventName.STARTAUTOFIGHT)
							})
						}

						let check_func = (bool?) => {
							if (bool) {
								// let x = local_TimeUtil.getClientTime()
								guildfightModel.show_call_tips = local_TimeUtil.getClientTime() + 60 * 5
							} else {
								guildfightModel.show_call_tips = 0
							}
						}

						if ((!guildfightModel.show_call_tips || local_TimeUtil.getClientTime() - guildfightModel.show_call_tips > 0) && role_mgr.GetMainRoleVo().position != 1) {
							if (CurCfg.mon_type == 2) {
								local_Alert.Show("会长正在召集联盟成员前往普通据点参与据点争夺，是否接受召集前往！", local_Alert_Type.AlertTypeCheckBox, ok_func, null, "接受", "拒绝", null, false, check_func, "5分钟内不再弹出")
							}
							else if (CurCfg.mon_type == 1) {
								local_Alert.Show("会长正在召集联盟成员前往王者据点参与据点争夺，是否接受召集前往！", local_Alert_Type.AlertTypeCheckBox, ok_func, null, "接受", "拒绝", null, false, check_func, "5分钟内不再弹出")
							}
						}
					}
					ResManager.GetInstance().DestoryGameConfig(this, "config_terri_mon")
				})

			}

			let Handler50618 = () => {
				let scmd = user_msg_adapter.GetSCMD(50618)
				if (scmd.code == 1) {
					guildfightModel.dis_red_dot = false
					// let red_state = guildfightModel.IsShowRed()
					// local_GlobalEventSystem.Fire(refresh_activity_red_event, 280)
					this.UpdateActRed()
					//local_GlobalEventSystem.Fire(update_window_red_event, "BattleFieldEnterView", BaseEnterDefine.BattleFieldIndex().GuildFight, red_state)
					this.SendFmtToGame(50601)
				}
				Util.ErrorCodeShow(scmd.code)
			}

			let Handler50619 = () => {
				let scmd = user_msg_adapter.GetSCMD(50619)
				guildfightModel.Fire(local_GuildFightEvent.SHOW_KILL_ITEM, scmd)
			}

			let Handler50604 = () => {
				//let war_info_scmd = user_msg_adapter.GetSCMD(50604)
				let warInfo = { territory_id: 0, end_time: 0, role_score: 0, guild_list: [], stage_list: [], own_list: [] }
				warInfo.territory_id = this.ReadFmt("i")
				warInfo.end_time = this.ReadFmt("i")
				warInfo.role_score = this.ReadFmt("i")
				let len0 = this.ReadFmt("h")
				warInfo.guild_list = []
				let vo0 = null
				for (let i = 1; i <= len0; i++) {
					vo0 = []
					vo0.guild_id = this.ReadFmt("l")
					vo0.guild_name = this.ReadFmt("s")
					vo0.server_id = this.ReadFmt("h")
					vo0.server_num = this.ReadFmt("h")
					vo0.score = this.ReadFmt("i")
					let len05 = this.ReadFmt("h")
					vo0.own_list = []
					let vo505 = null
					for (let j = 1; j <= len05; j++) {
						vo505 = []
						vo505.mod_id = this.ReadFmt("i")
						table.insert(vo0.own_list, vo505)
					}
					warInfo.guild_list[vo0.guild_id] = vo0
				}
				len0 = this.ReadFmt("h")
				warInfo.stage_list = []
				let vo1 = null
				for (let i = 1; i <= len0; i++) {
					vo1 = []
					vo1.keyid = this.ReadFmt("c")
					table.insert(warInfo.stage_list, vo1)
				}
				let len2 = this.ReadFmt("h")
				warInfo.own_list = []
				let vo2 = null
				for (let i = 0; i < len2; i++) {
					vo2 = []
					vo2.type = this.ReadFmt("c")
					vo2.guild_id = this.ReadFmt("l")
					vo2.guild_name = this.ReadFmt("s")
					vo2.mon_id = this.ReadFmt("i")
					vo2.hp = this.ReadFmt("i")
					vo2.hp_lim = this.ReadFmt("i")
					warInfo.own_list[vo2.mon_id] = vo2
				}
				guildfightModel.warInfo = warInfo
				guildfightModel.Fire(local_GuildFightEvent.UPDATE_WAR_INFO)
			}

			let Handler50605 = () => {
				let scmd = user_msg_adapter.GetSCMD(50605)
			}

			let Handler50606 = () => {
				let scmd = user_msg_adapter.GetSCMD(50606)
				let guild_list = guildfightModel.warInfo.guild_list
				if (guild_list) {
					for (let _tmpi in scmd.guild_update_list) {
						var vo = scmd.guild_update_list[_tmpi]
						// [ts2lua]guild_list下标访问可能不正确
						if (guild_list[vo.guild_id]) {
							// [ts2lua]guild_list下标访问可能不正确
							guild_list[vo.guild_id].score = vo.score
							// [ts2lua]guild_list下标访问可能不正确
							guild_list[vo.guild_id].own_list = vo.own_list
						}
					}
				}
				guildfightModel.warInfo.guild_list = guild_list
				guildfightModel.Fire(local_GuildFightEvent.UPDATE_GUILD_INFO)
			}

			let Handler50607 = () => {
				let scmd = user_msg_adapter.GetSCMD(50607)
				let own_list = guildfightModel.warInfo.own_list
				if (own_list) {
					for (let _tmpi in scmd.own_update_list) {
						var vo = scmd.own_update_list[_tmpi]
						// [ts2lua]own_list下标访问可能不正确
						if (own_list[vo.mon_id]) {
							// [ts2lua]own_list下标访问可能不正确
							own_list[vo.mon_id] = vo
						}
					}
				}
				guildfightModel.warInfo.own_list = own_list
				//console.log("////////////////////////+++++++++++++++++++++++++++++++////////////////////////-")
				//PrintTable(scmd.own_update_list, 1)
				guildfightModel.SetGuildOwnData(scmd.own_update_list)
				guildfightModel.Fire(local_GuildFightEvent.UPDATE_TOWER_INFO, scmd.own_update_list)
			}

			let Handler50620 = () => {
				let scmd = user_msg_adapter.GetSCMD(50620)
				guildfightModel.roundInfo = scmd
				this.SendFmtToGame(50621)
				guildfightModel.Fire(local_GuildFightEvent.UPDATE_ROUND)
			}

			let Handler50621 = () => {
				let scmd = []
				let len7 = this.ReadFmt("h")
				let vo7 = null

				let isEnd = false
				let isTrans = false
				let myGuildId = RoleManager.GetInstance().GetMainRoleVo().guild_id

				for (let i = 1; i <= len7; i++) {
					vo7 = []
					vo7.territory_id = this.ReadFmt("i")
					vo7.a_guild = this.ReadFmt("l")
					vo7.a_guild_name = this.ReadFmt("s")
					vo7.a_server_id = this.ReadFmt("h")
					vo7.a_server_num = this.ReadFmt("h")
					vo7.b_guild = this.ReadFmt("l")
					vo7.b_guild_name = this.ReadFmt("s")
					vo7.b_server_id = this.ReadFmt("h")
					vo7.b_server_num = this.ReadFmt("h")
					vo7.winner = this.ReadFmt("l")
					scmd[vo7.territory_id] = vo7

					//红点优化
					if (!isEnd) {
						if (vo7.territory_id == 1007 && vo7.winner != 0) {
							isEnd = true
							if (vo7.winner == myGuildId) guildfightModel.territory_id = 0
						} else {
							isEnd = false
							if (!isTrans) {
								if (vo7.a_guild == myGuildId || vo7.b_guild == myGuildId) {
									if (guildfightModel.territory_id != vo7.territory_id && guildfightModel.territory_id < vo7.territory_id) {
										guildfightModel.territory_id = vo7.territory_id
										isTrans = true
									}
								}
							}

						}
					}//

				}



				//刷新红点
				if (isEnd) {
					guildfightModel.ac_state_login = true
					guildfightModel.select_red_login = true
				} else {
					if (guildfightModel.ac_state_login == false && isTrans) {
						guildfightModel.ac_state_login = true
						guildfightModel.Fire(local_GuildFightEvent.UPDATE_AC_STATE, guildfightModel.ac_state)
					}
				}
				this.UpdateActRed()


				guildfightModel.terInfo = scmd
				guildfightModel.Fire(local_GuildFightEvent.UPDATE_TER_INFO)
			}

			let Handler50622 = () => {
				let scmd = user_msg_adapter.GetSCMD(50622)
				// kfStageModel.GetInstance().SetGuildData(scmd)
				guildfightModel.serInfo = scmd
				let cfg = Config.PRELOAD_SERVER_CONFIG.config_territory_mode
				if (cfg) {
					guildfightModel.startRound = cfg[scmd.mode_num] && cfg[scmd.mode_num].start_round || 1
				}
				guildfightModel.Fire(local_GuildFightEvent.UPDATE_SERVER_INFO)
			}

			let Handler13014 = () => {
				let scmd
				scmd = {}
				scmd.server_id = this.ReadFmt("h")
				scmd.guild_id = this.ReadFmt("l")
				scmd.model_id = this.ReadFmt("h")
				scmd.role_id = this.ReadFmt("l")
				scmd.figure = {}
				new FigureProtoVo().ReadFmt(scmd.figure);
				guildfightModel.Fire(local_GuildFightEvent.UPDATE_REQUEST_FIGURE, scmd)
			}


			let Handler13015 = () => {
				let scmd
				scmd = {}
				scmd.server_id = this.ReadFmt("h")
				scmd.model_id = this.ReadFmt("h")
				scmd.role_id = this.ReadFmt("l")
				scmd.figure = {}
				new FigureProtoVo().ReadFmt(scmd.figure);
				guildfightModel.Fire(local_GuildFightEvent.UPDATE_REQUEST_FIGURE_2, scmd)
				FlowerrankModel.GetInstance().SetTopRoleFigure(scmd)
			}


			let Handler50623 = () => {
				let scmd = user_msg_adapter.GetSCMD(50623)
				if (scmd.code == 1) {
					local_Message.show("宣战成功")
					guildfightModel.selectInfo.is_choose_terri_id = 1
					this.SendFmtToGame(50624)
					this.SendFmtToGame(50621)
				} else {
					if (scmd.code == 5060009) {
						this.SendFmtToGame(50624)
						this.SendFmtToGame(50621)
					}
					Util.ErrorCodeShow(scmd.code)
				}
			}

			let Handler50624 = () => {
				let scmd = user_msg_adapter.GetSCMD(50624)
				guildfightModel.selectInfo = scmd
				//guildfightModel.ac_state = guildfightModel.stateInfo.war_state == 3 && guildfightModel.selectInfo.qualification == 1
				guildfightModel.SetAcState(guildfightModel.stateInfo.war_state == 3 && guildfightModel.selectInfo.qualification == 1)
				guildfightModel.SetSelectState()
				//let red_state = guildfightModel.IsShowRed()
				//local_GlobalEventSystem.Fire(refresh_activity_red_event, 280)
				this.UpdateActRed()
				//local_GlobalEventSystem.Fire(update_window_red_event, "BattleFieldEnterView", BaseEnterDefine.BattleFieldIndex().GuildFight, red_state)
				guildfightModel.Fire(local_GuildFightEvent.UPDATE_AC_STATE, guildfightModel.ac_state)
			}

			let Handler50625 = () => {
				let scmd = user_msg_adapter.GetSCMD(50625)
				this.SendFmtToGame(50620)
				this.SendFmtToGame(50600)
				guildfightModel.selectInfo.qualification = scmd.qualification
				//guildfightModel.ac_state = guildfightModel.stateInfo.war_state == 3 && guildfightModel.selectInfo.qualification == 1
				guildfightModel.SetAcState(guildfightModel.stateInfo.war_state == 3 && guildfightModel.selectInfo.qualification == 1)
				//let red_state = guildfightModel.IsShowRed()
				//local_GlobalEventSystem.Fire(refresh_activity_red_event, 280)
				this.UpdateActRed()
				//local_GlobalEventSystem.Fire(update_window_red_event, "BattleFieldEnterView", BaseEnterDefine.BattleFieldIndex().GuildFight, red_state)
				guildfightModel.Fire(local_GuildFightEvent.UPDATE_AC_STATE, guildfightModel.ac_state)
			}

			let Handler50626 = () => {
				let scmd = user_msg_adapter.GetSCMD(50626)
				if (scmd.up_war_list == 1) {
					guildfightModel.Fire(local_GuildFightEvent.REFRESH_PROTO)
				}
			}

			let Handler50627 = () => {
				let scmd = user_msg_adapter.GetSCMD(50627)
				if (!scene_mgr.IsGuildFightScene()) {

					ResManager.GetInstance().LoadGameConfig(this, "config_territory", false, null, (cfg) => {
						if (cfg && cfg[scmd.territory_id]) {
							// [ts2lua]cfg下标访问可能不正确
							local_Alert.Show(
								Util.StrToHTML("您所在结社参与的<font color=\"#00b11d\">" + cfg[scmd.territory_id].territory_name + "</font>领地争夺战开启了，是否立即进入战场争夺？"),
								local_Alert_Type.Two, () => {
									this.SendFmtToGame(50603, "c", 1)
								}
							)
						}
						ResManager.GetInstance().DestoryGameConfig(this, "config_territory")
					})


				}
			}

			this.RegisterProtocal(50600, Handler50600)
			this.RegisterProtocal(50601, Handler50601)
			this.RegisterProtocal(50602, Handler50602)
			this.RegisterProtocal(50603, Handler50603)
			this.RegisterProtocal(50604, Handler50604)
			this.RegisterProtocal(50605, Handler50605)
			this.RegisterProtocal(50606, Handler50606)
			this.RegisterProtocal(50607, Handler50607)
			this.RegisterProtocal(50611, Handler50611)
			this.RegisterProtocal(50612, Handler50612)
			this.RegisterProtocal(50617, Handler50617)
			this.RegisterProtocal(50618, Handler50618)
			this.RegisterProtocal(50619, Handler50619)
			this.RegisterProtocal(50620, Handler50620)
			this.RegisterProtocal(50621, Handler50621)
			this.RegisterProtocal(50622, Handler50622)
			this.RegisterProtocal(50623, Handler50623)
			this.RegisterProtocal(50624, Handler50624)
			this.RegisterProtocal(50625, Handler50625)
			this.RegisterProtocal(50626, Handler50626)
			this.RegisterProtocal(50627, Handler50627)
			this.RegisterProtocal(13014, Handler13014)
			this.RegisterProtocal(13015, Handler13015)
			guildfightModel.Bind(
				local_GuildFightEvent.GUILDFIGHT_REQUEST_PROTO, (id, fmt, ...new_args) => {
					this.SendFmtToGame(id, fmt, ...new_args)
				}
			)
			guildfightModel.Bind(
				local_GuildFightEvent.GUILDFIGHT_OPEN_VIEW, (view_name, ...new_args) => {
					// [ts2lua]view_dic_下标访问可能不正确
					let view = view_dic_[view_name]
					if (!view) {
						// [ts2lua]view_dic_下标访问可能不正确
						view_dic_[view_name] = true
						// [ts2lua]window下标访问可能不正确
						if (!window[view_name]) {
							if (!ResManager.GetInstance().IsJsLoad("guildFight")) {
							}
						}
						// [ts2lua]view_dic_下标访问可能不正确
						if (view_dic_[view_name] == true) {
							// [ts2lua]window下标访问可能不正确
							let view_class: any = window[view_name]
							view = new view_class()
							// [ts2lua]view_dic_下标访问可能不正确
							view_dic_[view_name] = view
						}
					}
					if (view && view != true) {
						// [ts2lua]lua中0和空字符串也是true，此处view:HasOpen()需要确认
						let res = (view.HasOpen() && (view.Close()) || (view.Open(...new_args)))
					}
				}
			)
			local_GlobalEventSystem.Bind(
				local_EventName.INIT_CONFIG, () => {
					guildfightModel.ResConfig()
				}
			)
			local_GlobalEventSystem.Bind(
				local_EventName.GAME_START, () => {
					this.SendFmtToGame(50600)
					this.SendFmtToGame(50601)
					this.SendFmtToGame(50622)
					this.SendFmtToGame(50624)
				}
			)
			guildfightModel.Bind(
				local_GuildFightEvent.OPEN_GUILD_FIGHT_SCENE, (show?) => {
					// [ts2lua]window下标访问可能不正确
					if (!window["GuildFightSceneView"] && !ResManager.GetInstance().IsJsLoad("guildFight")) {
					}
					if (show) {
						if (!guildSceneView_) {
							// [ts2lua]window下标访问可能不正确
							let view = window["GuildFightSceneView"]
							guildSceneView_ = new view()
						}
						this.SendFmtToGame(50600)
						guildSceneView_.Open()
						this.SendFmtToGame(50604)
					} else {
						if (guildSceneView_ && guildSceneView_.HasOpen()) {
							guildSceneView_.Close()
						}
					}
				}
			)
			let scene_changed_func = () => {
				let last_scene_id = scene_mgr.GetLastSceneId()
				if (scene_mgr.IsGuildFightScene()) {
					mainUI_controller.SetMainUIViewVisible(10, false)
					guildfightModel.Fire(local_GuildFightEvent.OPEN_GUILD_FIGHT_SCENE, true)
					mainUI_model.Fire(MainUIModel.CHANGE_ACTIVITY_STATE, false)
				}
				if (scene_mgr.IsGuildFightScene(last_scene_id) && !scene_mgr.IsGuildFightScene()) {
					mainUI_controller.SetMainUIViewVisible(10, true)
					guildfightModel.Fire(local_GuildFightEvent.OPEN_GUILD_FIGHT_SCENE, false)
					mainUI_model.Fire(MainUIModel.CHANGE_ACTIVITY_STATE, true)
					OpenFun.OpenFunHandler(33)
					guildfightModel.Fire(local_GuildFightEvent.GUILDFIGHT_OPEN_VIEW, "GuildFightMapView")
					guildfightModel.warInfo = []
				}
			}

			local_GlobalEventSystem.Bind(SceneEventType.SCENE_CHANGED, scene_changed_func)
		}

		this.InitInfo()
	}

}
window["GuildFightController"] = GuildFightController
