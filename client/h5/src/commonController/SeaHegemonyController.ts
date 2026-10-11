

import { BaseController } from "../common/BaseController"
import { UserMsgAdapter } from "../common/UserMsgAdapter"
import { Util } from "../util/Util"
import { table } from "../common/table"
import { Config } from "../common/Config"
import { EventName } from "../common/EventName"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { ActivityIconManager } from "../commonModel/ActivityIconManager"
import { TimeUtil } from "../util/TimeUtil"
import { SkillManager } from "../skill/SkillManager"
import { Message } from "../sysInfo/SysInfoController"
import { MainUIController } from "./MainUIController"
import { MainUIModel } from "../commonModel/MainUIModel"
import { SceneManager } from "../scene/SceneManager"
import { SceneEventType } from "../common/EventName"
import { AutoFightManager } from "../autofight/AutoFightManager"
import { RoleManager } from "../commonModel/RoleManager"
import { Scene } from "../scene/Scene"
import { SeaHegemonyModel } from "../commonModel/SeaHegemonyModel"

import "../country/CountryARequest"
import { ResManager } from "../common/ResManager"

export class SeaHegemonyController extends BaseController {
	first_send18617
	public constructor() {
		super()

		let local_model = SeaHegemonyModel
		let local_modelIns = local_model.GetInstance()
		//let local_util = Util
		let viewDic = []
		let user_msg_adapter = UserMsgAdapter.GetInstance()
		let local_GlobalEventSystem = GlobalEventSystem
		let local_EventName = EventName
		let local_timeUtil = TimeUtil
		let act_icon_mgr = ActivityIconManager.GetInstance()
		local_modelIns.Bind(
			local_model.REQUEST_PROTO, (id, fmt, ...new_args) => {
				this.SendFmtToGame(id, fmt, ...new_args)
			}
		)
		local_modelIns.Bind(
			local_model.OPEN_VIEW, (view_name: string, ...new_args) => {
				let view = viewDic[view_name]
				if (!view) {
					viewDic[view_name] = true
					if (viewDic[view_name] == true) {
						let view_class = window[view_name]
						view = new view_class()
						viewDic[view_name] = view
					}
				}
				if (view && view != true) {
					if (view.HasOpen() && view_name == "CountryBaseView") {
						local_modelIns.Fire(local_model.SWITCH_VIEW, ...new_args)
					} else {
						let res = view.Open(...new_args)
					}
				}
			}
		)
		local_modelIns.Bind(
			local_model.CLOSE_VIEW, (view_name?) => {
				let view = viewDic[view_name]
				if (((view && view != true) && view.HasOpen) && view.HasOpen()) {
					view.Close()
				}
			}
		)



		this.RegisterProtocal(
			18600, () => {
				let scmd = user_msg_adapter.GetSCMD(18600)
				if (scmd) {
					local_modelIns.seaHegemonyData = scmd
					//console.log("________________18600")
					local_modelIns.hasJoinSea = scmd.camp != 0
					local_modelIns.isSeaKing = scmd.self_level == 1
					local_modelIns.ChangeVar("dailyRewardRed", scmd.reward_status == 0)
					local_modelIns.Fire(local_model.UPDATE_SEA_INFO)
					local_modelIns.Fire(local_model.REFRESH_RED, 0)
					local_modelIns.Fire(local_model.REFRESH_RED, 2)
					this.SendFmtToGame(18625)
					if (scmd.self_level == 1) {
						this.SendFmtToGame(18604)
					}
					this.SendFmtToGame(18656)
					local_GlobalEventSystem.Fire(local_EventName.REFRESH_ACTIVITY_ICON_RED_DOT, 6210)
					local_GlobalEventSystem.Fire(local_EventName.REFRESH_ACTIVITY_ICON_RED_DOT, 1861)
				}
			}
		)
		this.RegisterProtocal(
			18601, () => {
				let scmd = user_msg_adapter.GetSCMD(18601)
				if (scmd) {
					local_modelIns.seaSoldierData = scmd
					local_modelIns.hasJoinSoldier = scmd.has_join == 1
					local_modelIns.Fire(local_model.SOLDIER_INFO)
				}
			}
		)
		this.RegisterProtocal(
			18602, () => {
				let scmd = user_msg_adapter.GetSCMD(18602)
				if (scmd && scmd.code != 1) {
					Util.ErrorCodeShow(scmd.code)
				} else {
					this.SendFmtToGame(18601)
				}
			}
		)
		this.RegisterProtocal(
			18603, () => {
				let scmd = user_msg_adapter.GetSCMD(18603)
				if (scmd && scmd.code != 1) {
					Util.ErrorCodeShow(scmd.code)
				} else {
					Message.show("申请成功")
				}
			}
		)
		this.RegisterProtocal(
			18604, () => {
				let scmd = user_msg_adapter.GetSCMD(18604)
				if (scmd) {
					local_modelIns.seaSoldierApplyList = scmd.list
					local_modelIns.applyRed = scmd.list.length > 0
					local_modelIns.Fire(local_model.SOLDIER_APPLY)
					local_modelIns.Fire(local_model.REFRESH_RED, 1)
					local_GlobalEventSystem.Fire(local_EventName.REFRESH_ACTIVITY_ICON_RED_DOT, 6210)
					local_GlobalEventSystem.Fire(local_EventName.REFRESH_ACTIVITY_ICON_RED_DOT, 1861)
				}
			}
		)
		this.RegisterProtocal(
			18605, () => {
				let scmd = user_msg_adapter.GetSCMD(18605)
				this.SendFmtToGame(18604)
				if (scmd && scmd.code != 1) {
					Util.ErrorCodeShow(scmd.code)
				}
			}
		)
		this.RegisterProtocal(
			18606, () => {
				let scmd = user_msg_adapter.GetSCMD(18606)
				if (scmd && scmd.code != 1) {
					Util.ErrorCodeShow(scmd.code)
				} else {
					Message.show("官职设置成功")
					this.SendFmtToGame(18601)
				}
			}
		)
		this.RegisterProtocal(
			18607, () => {
				let scmd = user_msg_adapter.GetSCMD(18607)
				if (scmd) {
					let cfg = Config.PRELOAD_SERVER_CONFIG.config_seacraft_kv
					let isToday = false
					if (cfg && scmd.start_time != 0) {
						let time1 = scmd.start_time - local_timeUtil.getServerTime()
						let openKey = JSON.parse(cfg.open_time.value)[0][0]
						let time2 = openKey[0] * 60 * 60 + openKey[1] * 60
						if (time1 < time2) {
							isToday = true
						}
					}
					if (((scmd.start_time != 0 && local_timeUtil.getServerTime() >= scmd.start_time) && local_timeUtil.getServerTime() < scmd.end_time) && scmd.can_enter == 1) {
						local_modelIns.nomalActiveRed = scmd.act_type == 1
						local_modelIns.kingActiveRed = scmd.act_type == 2
					} else {
						local_modelIns.nomalActiveRed = false
						local_modelIns.kingActiveRed = false
					}
					local_modelIns.hasFight = (scmd.has_fight != 0) || isToday
					local_modelIns.StartTime = scmd.start_time
					local_modelIns.actType = scmd.act_type
					local_modelIns.StartInfo = scmd
					local_modelIns.Fire(local_model.START_DATA)
					local_modelIns.Fire(local_model.REFRESH_RED, 2)
					local_modelIns.Fire(local_model.REFRESH_RED, 3)
					local_GlobalEventSystem.Fire(local_EventName.REFRESH_ACTIVITY_ICON_RED_DOT, 6210)
					local_GlobalEventSystem.Fire(local_EventName.REFRESH_ACTIVITY_ICON_RED_DOT, 1861)

					//更换背景
					local_modelIns.Fire(local_model.CHANGE_BG)
				}
			}
		)
		this.RegisterProtocal(
			18608, () => {
				let scmd = user_msg_adapter.GetSCMD(18608)
				if (scmd) {
					// [ts2lua]local_modelIns.seaGuildList下标访问可能不正确
					//console.log("______________________18608")
					//PrintTable(scmd.guild_list)
					local_modelIns.seaGuildList[scmd.camp] = scmd.guild_list
					local_modelIns.Fire(local_model.GUILD_LIST, scmd.camp)
				}
			}
		)
		this.RegisterProtocal(
			18609, () => {
				let scmd = user_msg_adapter.GetSCMD(18609)
				if (scmd) {
					let noattackId = null
					local_modelIns.fightCurId = null
					local_modelIns.fightBeforeId = null
					let cacheData = {}

					for (let i = scmd.list.length-1; i >= 0; i --) {
						let vo = scmd.list[i]
						if (local_modelIns.beforeList[vo.mon_id] && vo.att_limit == 0) {
							local_modelIns.fightBeforeId = vo.mon_id
						}
						cacheData[vo.mon_id] = vo
					}
					if (Util.IsTableEmpty(cacheData)) {
						return
					}

					for (let i = local_model.towerPoslist.length-1; i >= 0; i--) {
						let id = local_model.towerPoslist[i]
						let beforData = local_modelIns.monsterData[id]
						let curData = cacheData[id]
						if (curData && curData.att_limit == 1) {
							if ((beforData && beforData.hp > curData.hp) && !local_modelIns.fightCurId) {
								local_modelIns.fightCurId = curData.mon_id
							}
							noattackId = curData.mon_id
						}
						local_modelIns.monsterData[curData.mon_id] = curData
					}
					if (!local_modelIns.fightCurId) {
						local_modelIns.fightCurId = noattackId || scmd.list[0].mon_id
					}
					local_modelIns.Fire(local_model.UPDATE_MONSTER)
				}
			}
		)
		this.RegisterProtocal(
			18610, () => {
				let scmd = user_msg_adapter.GetSCMD(18610)
				if (scmd) {
					//console.log("____________18610")
					//PrintTable(scmd)
					if (scmd.code == 1) {
						local_modelIns.shipType = scmd.type
						local_modelIns.changeCold = scmd.time
						local_modelIns.Fire(local_model.CHANGE_SHIP)
						SkillManager.Instance.Fire(SkillManager.UPDATE_SKILL_LIST)
					} else {
						Util.ErrorCodeShow(scmd.code)
					}
				}
			}
		)
		this.RegisterProtocal(
			18611, () => {
				let scmd = user_msg_adapter.GetSCMD(18611)
				if (scmd) {
					local_modelIns.fightGuildData = scmd.score_rank
					local_modelIns.Fire(local_model.TOTAL_INFO)
				}
			}
		)
		this.RegisterProtocal(
			18612, () => {
				let scmd = user_msg_adapter.GetSCMD(18612)
				if (scmd) {
					setTimeout(() => {
						this.SendFmtToGame(18607)
					},
						3
					)
					local_modelIns.Fire(local_model.OPEN_VIEW, "SeaFightSettleView", scmd)
				}
			}
		)
		this.RegisterProtocal(
			18613, () => {
				let scmd = user_msg_adapter.GetSCMD(18613)
				if (scmd) {
					if (scmd.code == 1) {
						local_modelIns.shipType = scmd.type
						SkillManager.Instance.Fire(SkillManager.UPDATE_SKILL_LIST)
					}
					else if (scmd.code != 1860023) {
						Util.ErrorCodeShow(scmd.code)
					}
				}
			}
		)
		this.RegisterProtocal(
			18614, () => {
				let scmd = user_msg_adapter.GetSCMD(18614)
				if (scmd && scmd.code != 1) {
					Util.ErrorCodeShow(scmd.code)
				}
			}
		)
		this.RegisterProtocal(
			18615, () => {
				let scmd = user_msg_adapter.GetSCMD(18615)
				if (scmd) {
					local_modelIns.seaKingData = scmd
					local_modelIns.Fire(local_model.KING_INFO)
				}
			}
		)
		this.RegisterProtocal(
			18616, () => {
				let scmd = user_msg_adapter.GetSCMD(18616)
				if (scmd && scmd.code != 1) {
					Util.ErrorCodeShow(scmd.code)
				}
			}
		)
		this.RegisterProtocal(
			18617, () => {
				let scmd = user_msg_adapter.GetSCMD(18617)
				if (scmd) {
					local_modelIns.fightData = scmd
					local_modelIns.attackList = {}
					local_modelIns.defList = {}
					//local_modelIns.guildToShip = {}
					//let tempGuildList = []
					for (let _tmpi in scmd.att) {
						let vo = scmd.att[_tmpi]
						local_modelIns.attackList[vo.guild_id] = true
						//table.insert(tempGuildList, vo.guild_id)
					}
					for (let _tmpi in scmd.def) {
						let vo = scmd.def[_tmpi]
						local_modelIns.defList[vo.guild_id] = true
						//table.insert(tempGuildList, vo.guild_id)
					}
					// table.sort(tempGuildList, (a?, b?) => {
					// 	if (a != b) {
					// 		return b > a
					// 	}
					// 	return false
					// })
					// for (let i = 0; i < tempGuildList.length; i++) {
					// 	local_modelIns.guildToShip[tempGuildList[i]] = i+1
					// }

					//fightType  0防守  1进攻

					local_modelIns.fightType = 1
					for (let _tmpi in scmd.def) {
						let vo = scmd.def[_tmpi]
						let guildId = RoleManager.GetInstance().GetMainRoleVo().guild_id
						if (guildId == vo.guild_id || local_modelIns.seaHegemonyData.camp == vo.guild_id) {
							local_modelIns.fightType = 0
						}
					}
					let doorList = Scene.GetInstance().door_list
					// 防守方才有传送门
					if (SceneManager.GetInstance().IsSeaHegemonyScene() && doorList && local_modelIns.fightType == 1) {
						for (let i in doorList) {
							let door = doorList[i]
							if (door && door.id) {
								Scene.GetInstance().DeleteDoor(door.id)
							}
						}
					}
					if (!this.first_send18617) {
						local_GlobalEventSystem.Fire(local_EventName.CANCEL_TO_COLLECT)
						AutoFightManager.GetInstance().SetAutoFight(false)
						local_modelIns.Fire(local_model.ATTACK_DEF_DATA)
					}
				}
				this.first_send18617 = null
			}
		)
		this.RegisterProtocal(
			18618, () => {
				let scmd = user_msg_adapter.GetSCMD(18618)
				if (scmd) {
					local_modelIns.seaPreList = []
					for (let _tmpi in scmd.list) {
						let vo = scmd.list[_tmpi]
						// [ts2lua]local_modelIns.seaPreList下标访问可能不正确
						local_modelIns.seaPreList[vo.camp] = vo
					}
					local_modelIns.Fire(local_model.JOIN_VIEW_DATA)
				}
			}
		)
		this.RegisterProtocal(
			18619, () => {
				let scmd = user_msg_adapter.GetSCMD(18619)
				if (scmd.code != 1) {
					Util.ErrorCodeShow(scmd.code)
				} else {
					setTimeout(() => {
						this.SendFmtToGame(18600)
						this.SendFmtToGame(18618)
					}, 300)
				}
			}
		)
		this.RegisterProtocal(
			18620, () => {
				let scmd = user_msg_adapter.GetSCMD(18620)
				if (scmd.code != 1) {
					Util.ErrorCodeShow(scmd.code)
				} else {
					local_modelIns.seaPreList = []
					setTimeout(() => {
						this.SendFmtToGame(18600)
						this.SendFmtToGame(18618)
					},
						0.3)
				}
			}
		)
		this.RegisterProtocal(
			18621, () => {
				let scmd = user_msg_adapter.GetSCMD(18621)
				if (scmd) {
					if (scmd.code != 1) {
						Util.ErrorCodeShow(scmd.code)
					} else {
						this.SendFmtToGame(18600)
						Util.ShowCongratulationView(scmd.reward)
					}
				}
			}
		)
		this.RegisterProtocal(
			18622, () => {
				let scmd = user_msg_adapter.GetSCMD(18622)
				if (scmd) {
					local_modelIns.applySettingData = scmd
					local_modelIns.Fire(local_model.APPLY_SETTING)
				}
			}
		)
		this.RegisterProtocal(
			18623, () => {
				let scmd = user_msg_adapter.GetSCMD(18623)
				if (scmd.code) {
					this.SendFmtToGame(18607)
					this.SendFmtToGame(18624)
					this.SendFmtToGame(18625)
				}
			}
		)
		this.RegisterProtocal(
			18624, () => {
				let scmd = user_msg_adapter.GetSCMD(18624)
				if (scmd) {
					//console.log("_____18624", scmd.time_list)
					//PrintTable(scmd.time_list)
					for (let _tmpi in scmd.time_list) {
						let vo = scmd.time_list[_tmpi]
						// [ts2lua]local_modelIns.activeStartTime下标访问可能不正确
						local_modelIns.activeStartTime[vo.act_type] = vo
					}
					local_modelIns.Fire(local_model.START_DATA)
				}
			}
		)
		this.RegisterProtocal(
			18625, () => {
				let scmd = user_msg_adapter.GetSCMD(18625)
				if (scmd && scmd.end_time) {
					let previewStartime = scmd.end_time - 86400
					if (previewStartime < TimeUtil.getServerTime() && TimeUtil.getServerTime() < scmd.end_time) {
						let color="#88ff43"
						let txt = "报名中"// "<font color=0x78f72c>报名中</font>"
						if (local_modelIns.seaHegemonyData && local_modelIns.seaHegemonyData.camp != 0) {
							txt = "已报名"// "<font color=0x78f72c>已报名</font>"
						}
						let iconInfo = act_icon_mgr.getIconInfo(18601)
						if (iconInfo) {
							local_GlobalEventSystem.Fire(ActivityIconManager.SET_ICON_TEXT, 18601, txt)
						} else {
							act_icon_mgr.addIcon(18601, null, null, txt)
						}
					}
					else if (act_icon_mgr.getIconInfo(18601)) {
						act_icon_mgr.deleteIcon(18601)
					}
				}
			}
		)
		this.RegisterProtocal(
			18626, () => {
				let scmd = user_msg_adapter.GetSCMD(18626)
				if (scmd && scmd.code) {
					this.SendFmtToGame(18600)
				}
			}
		)
		this.RegisterProtocal(
			18650, () => {
				let scmd = user_msg_adapter.GetSCMD(18650)
			}
		)
		this.RegisterProtocal(
			18651, () => {
				let scmd = user_msg_adapter.GetSCMD(18651)
				if (scmd) {

					ResManager.GetInstance().GetGameConfigWithAutoDestory("config_sea_privilege", (cfg) => {
						if (cfg) {
							local_modelIns.muteTime = Math.round(cfg[1].duration / 60)
						}
						local_modelIns.privilegeData = scmd
						for (let _tmpi in scmd.list) {
							let vo = scmd.list[_tmpi]
							if (vo.priv_id == 1) {
								local_modelIns.mutedStatus = vo.status == 1
								break
							}
						}
						local_modelIns.Fire(local_model.UPDATE_PRIVI_DATA)
					}, false)


				}
			}
		)
		this.RegisterProtocal(
			18652, () => {
				let scmd = user_msg_adapter.GetSCMD(18652)
				if (scmd) {
					if (scmd.code == 1) {
						Message.show("操作成功")
						this.SendFmtToGame(18651)
						local_modelIns.Fire(local_model.UPDATE_PRIVI_DATA)
					} else {
						Util.ErrorCodeShow(scmd.code)
					}
				}
			}
		)
		this.RegisterProtocal(
			18653, () => {
				let scmd = user_msg_adapter.GetSCMD(18653)
				local_modelIns.meritData = scmd
				local_modelIns.Fire(local_model.UPDATE_MERIT_DATA)
			}
		)
		this.RegisterProtocal(
			18654, () => {
				let scmd = user_msg_adapter.GetSCMD(18654)
				//console.log("_______________18654")
				//PrintTable(scmd.member)
				if (scmd.page_size != 1) {
					// [ts2lua]local_modelIns.peopleData下标访问可能不正确
					local_modelIns.peopleData[scmd.page_num] = scmd.member
				}
				if (scmd.page_size != 1 && scmd.page_total > scmd.page_num) {
					this.SendFmtToGame(18654, "hh", scmd.page_size, scmd.page_num)
				}
				local_modelIns.isShowPoliticalView = scmd.member.length != 0
				local_modelIns.Fire(local_model.UPDATE_PEOPLE_DATA)
			}
		)
		this.RegisterProtocal(
			18655, () => {
				let scmd = user_msg_adapter.GetSCMD(18655)
				table.sort(scmd.guild_info, (a?, b?) => {
					if (a.fight != b.fight) {
						return a.fight > b.fight
					}
					return false
				})
				let i = 0
				do {
					// [ts2lua]scmd.guild_info[i]下标访问可能不正确
					scmd.guild_info[i]["rank"] = i + 1
					i = i + 1
				} while ((i < scmd.guild_info.length))
				local_modelIns.campData = scmd.guild_info
				local_modelIns.Fire(local_model.UPDATE_CAMP_DATA)
			}
		)
		this.RegisterProtocal(
			18700, () => {
				let scmd = user_msg_adapter.GetSCMD(18700)
				Util.ErrorCodeShow(scmd.code)
			}
		)
		this.RegisterProtocal(
			18701, () => {
				let scmd = user_msg_adapter.GetSCMD(18701)
				//console.log("_______________________18701")
				//PrintTable(scmd)
				local_modelIns.assertViewData = scmd
				local_modelIns.Fire(local_model.ASSERT_VIEW_DATA)
			}
		)
		this.RegisterProtocal(
			18703, () => {
				let scmd = user_msg_adapter.GetSCMD(18703)
				local_modelIns.assertSceneData = scmd
				local_modelIns.Fire(local_model.ASSERT_SCENE_DATA)
			}
		)
		this.RegisterProtocal(
			18704, () => {
				let scmd = user_msg_adapter.GetSCMD(18704)
				// [ts2lua]scmd下标访问可能不正确
				scmd["req_time"] = TimeUtil.getServerTimeMs()
				local_modelIns.assertRankData = scmd
				for (let i = 0; i < local_modelIns.assertRankData.rank_list.length; i++) {
					let value = local_modelIns.assertRankData.rank_list[i]
					value.rank = i
				}
				//console.log("_________________18704")
				//PrintTable(scmd)
				local_modelIns.Fire(local_model.ASSERT_RANK_DATA)
			}
		)
		this.RegisterProtocal(
			18705, () => {
				let scmd = user_msg_adapter.GetSCMD(18705)
				if (scmd.code == 1) {
					local_modelIns.Fire(local_model.ASSERT_BRICK_ING)
				} else {
					Util.ErrorCodeShow(scmd.code)
				}
			}
		)
		this.RegisterProtocal(
			18706, () => {
				let scmd = user_msg_adapter.GetSCMD(18706)
				if (scmd.code == 1) {
					AutoFightManager.GetInstance().SetAutoFight(false)
					local_modelIns.Fire(local_model.ASSERT_BRICK_DOWN)
				} else {
					Util.ErrorCodeShow(scmd.code)
				}
			}
		)
		this.RegisterProtocal(
			18707, () => {
				let scmd = user_msg_adapter.GetSCMD(18707)
				if (scmd.code == 1) {
					for (let key in local_modelIns.assertViewData.sea_list) {
						let viewData = local_modelIns.assertViewData.sea_list[key]
						if (viewData.sea_id == local_modelIns.assertSceneData.sea_id) {
							viewData.brick_color = scmd.lv
							local_modelIns.Fire(local_model.ASSERT_BRICK_UP)
						}
					}
					Message.show("砖块品质提升成功")
				} else {
					Util.ErrorCodeShow(scmd.code)
				}
			}
		)
		this.RegisterProtocal(
			18710, () => {
				let scmd = user_msg_adapter.GetSCMD(18710)
				local_modelIns.SetBrickFi(scmd)
			}
		)
		this.RegisterProtocal(
			18711, () => {
				let scmd = user_msg_adapter.GetSCMD(18711)
				// [ts2lua]scmd下标访问可能不正确
				scmd["req_time"] = TimeUtil.getServerTimeMs()
				local_modelIns.assertRankData_all = scmd
				if (local_modelIns.assertRankData_all) {
					for (let i = 0; i < local_modelIns.assertRankData_all.rank_list.length; i++) {
						let value = local_modelIns.assertRankData_all.rank_list[i]
						value.rank = i
					}
				}
				local_modelIns.Fire(local_model.ASSERT_RANK_DATA)
			}
		)
		this.RegisterProtocal(
			18712, () => {
				let scmd = user_msg_adapter.GetSCMD(18712)
				local_modelIns.assertTaskData = scmd
				local_modelIns.SetAssertRed()
				local_modelIns.Fire(local_model.ASSERT_TASK_DATA)
			}
		)
		this.RegisterProtocal(
			18713, () => {
				let scmd = user_msg_adapter.GetSCMD(18713)
				local_modelIns.setTaskData(scmd)
				this.SendFmtToGame(18712)
			}
		)
		this.RegisterProtocal(
			18714, () => {
				let scmd = user_msg_adapter.GetSCMD(18714)
				if (scmd.code == 1) {
					Message.show("当前海域海王已经封边，您即将被请出当前海域")
				}
			}
		)
		this.RegisterProtocal(
			18715, () => {
				let scmd = user_msg_adapter.GetSCMD(18715)
				//console.log("_______________________18715")
				//PrintTable(scmd)
				local_modelIns.assertGuildData = scmd
				local_modelIns.Fire(local_model.ASSERT_GUILD_DATA)
			}
		)
		this.RegisterProtocal(
			18656, () => {
				let scmd = user_msg_adapter.GetSCMD(18656)
				if (scmd) {
					local_modelIns.ChangeVar("showRewardType", scmd.four_level)
				}
			}
		)
		let mainUI_controller = MainUIController.GetInstance()
		let scene_mgr = SceneManager.GetInstance()
		let mainUI_model = MainUIModel.GetInstance()
		let scene_changed_func = () => {
			let last_scene_id = scene_mgr.GetLastSceneId()
			if (scene_mgr.IsSeaHegemonyScene()) {
				mainUI_controller.SetMainUIViewVisible(10, false)
				local_modelIns.Fire(local_model.OPEN_VIEW, "SeaHegemonySceneView")
				mainUI_model.Fire(MainUIModel.CHANGE_ACTIVITY_STATE, false)
			}
			if (scene_mgr.IsSeaHegemonyScene(last_scene_id) && !scene_mgr.IsSeaHegemonyScene()) {
				mainUI_controller.SetMainUIViewVisible(10, true)
				local_modelIns.Fire(local_model.CLOSE_VIEW, "SeaHegemonySceneView")
				mainUI_model.Fire(MainUIModel.CHANGE_ACTIVITY_STATE, true)
			}
			if (scene_mgr.IsSeaAsserScene()) {
				mainUI_controller.SetMainUIViewVisible(10, false)
				local_modelIns.Fire(local_model.OPEN_VIEW, "SeaAssertSceneView")
				mainUI_model.Fire(MainUIModel.CHANGE_ACTIVITY_STATE, false)
			}
			if (scene_mgr.IsSeaAsserScene(last_scene_id) && !scene_mgr.IsSeaAsserScene()) {
				mainUI_controller.SetMainUIViewVisible(10, true)
				local_modelIns.Fire(local_model.CLOSE_VIEW, "SeaAssertSceneView")
				mainUI_model.Fire(MainUIModel.CHANGE_ACTIVITY_STATE, true)
			}
		}

		local_GlobalEventSystem.Bind(SceneEventType.SCENE_CHANGED, scene_changed_func)
		local_GlobalEventSystem.Bind(
			local_EventName.GAME_START, () => {
				this.SendFmtToGame(18600)
				this.SendFmtToGame(18607)
				this.SendFmtToGame(18615)
				this.first_send18617 = true
				this.SendFmtToGame(18617)
				this.SendFmtToGame(18624)
				this.SendFmtToGame(18712)
				this.SendFmtToGame(18654, "hh", 1, 1)
			}
		)
		local_GlobalEventSystem.Bind(
			SceneManager.START, () => {
				if (scene_mgr.IsFieldScene()) {
					local_modelIns.Fire(local_model.CLOSE_VIEW, "SeaHegemonySceneView")
				}
			}
		)
		local_modelIns.Bind(
			local_model.APPOINT, () => {
				let position = local_modelIns.selectingPosition
				if (position) {
					let peopleList = local_modelIns.selectInfo[position]
					if (peopleList) {
						this.WriteBegin(18606)
						this.WriteFMT("h", local_modelIns.selectingPosition)
						this.WriteFMT("h", peopleList.people.length)
						for (let _tmpi in peopleList.people) {
							let vo = peopleList.people[_tmpi]
							this.WriteFMT("l", vo)
						}
						this.SendToGame()
					}
				}
			}
		)
		local_modelIns.Bind(
			local_model.REMOVE_SOLDIER, (role_id?) => {
				if (role_id) {
					this.WriteBegin(18606)
					this.WriteFMT("h", 6)
					this.WriteFMT("h", 1)
					this.WriteFMT("l", role_id)
					this.SendToGame()
				}
			}
		)
	}
}
window["SeaHegemonyController"] = SeaHegemonyController