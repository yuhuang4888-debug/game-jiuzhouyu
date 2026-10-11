
//require("game.proto.137.Require137")
//require("game.diamondFight.DiamondFightModel")
//require("game.diamondFight.RequireDiamondFight")

import { Alert, Alert_Type } from "../alert/Alert"
import { AutoFightManager } from "../autofight/AutoFightManager"
import { BaseController } from "../common/BaseController"
import { EventName, SceneEventType } from "../common/EventName"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { UserMsgAdapter } from "../common/UserMsgAdapter"
import { ViewManager } from "../common/ViewManager"
import { DiamondFightModel } from "../commonModel/DiamondFightModel"
import { MainUIModel } from "../commonModel/MainUIModel"
import { TopPkModel } from "../commonModel/TopPkModel"
import { ActivityIconManager } from "../commonModel/ActivityIconManager"
import { RoleManager } from "../commonModel/RoleManager"
import { FightEvent } from "../scene/fight/FightEvent"
import { SceneManager } from "../scene/SceneManager"
import { Message } from "../sysInfo/SysInfoController"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { Util } from "../util/Util"
import { MainUIController } from "./MainUIController"
import { Config } from "../common/Config"

import "../diamondFight/RequireDiamondFight"
import "../baseEnterView/WorldBattleEnterView"
export class DiamondFightController extends BaseController {



	show_diamond_enter_tips = false
	view_dic


	user_msg_adapter: UserMsgAdapter
	role_mgr: RoleManager
	diamond_fight_model: DiamondFightModel
	scene_mgr: SceneManager
	res_mgr: ResManager
	public constructor() {
		super()

		this.scene_mgr = SceneManager.GetInstance()
		this.diamond_fight_model = DiamondFightModel.GetInstance()
		this.role_mgr = RoleManager.GetInstance()
		this.user_msg_adapter = UserMsgAdapter.GetInstance()
		this.res_mgr = ResManager.GetInstance()

		this.InitEvent()
		this.RegisterAllProtocals()
	}

	public InitEvent() {


		let request_data = () => {
			this.diamond_fight_model.Fire(DiamondFightModel.REQUEST_SCMD, 13700)
			this.diamond_fight_model.Fire(DiamondFightModel.REQUEST_SCMD, 13703)
			this.diamond_fight_model.Fire(DiamondFightModel.REQUEST_SCMD, 13716)
			this.diamond_fight_model.Fire(DiamondFightModel.REQUEST_SCMD, 13721)
		}

		GlobalEventSystem.Bind(EventName.GAME_START, () => {
			let config_drumwar_value = Config.PRELOAD_SERVER_CONFIG.config_drumwar_value
			this.diamond_fight_model.InitConfig(config_drumwar_value)
			this.diamond_fight_model.ResetData()
			this.diamond_fight_model.ResetWaitingData()
			this.diamond_fight_model.ResetFightData()
			let mainRoleVo = this.role_mgr.GetMainRoleVo()
			if (mainRoleVo && mainRoleVo.level >= DiamondFightModel.OPEN_LEVEL) {
				request_data()
			}
		})

		this.role_mgr.mainRoleInfo.Bind(EventName.CHANGE_LEVEL, (level?) => {
			if (level == DiamondFightModel.OPEN_LEVEL) {
				request_data()
			}
		})

		this.diamond_fight_model.Bind(DiamondFightModel.REQUEST_SCMD, (cmd, ...new_args) => {
			let args = new_args
			switch (cmd) {
				case 13706:
				case 13707:
				case 13711:
					this.SendFmtToGame(cmd, "c", args[0])
					break
				case 13715:
					this.SendFmtToGame(cmd, "i", args[0])
					break
				case 13720:
					this.SendFmtToGame(cmd, "clc", args[0], args[1], args[2])
					break
				case 13723:
					this.SendFmtToGame(cmd, "ccl", args[0], args[1], args[2])
					break
				default:
					this.SendFmtToGame(cmd)
					break
			}
		})


		this.diamond_fight_model.Bind(DiamondFightModel.OPEN_VIEW, (view_name, ...new_args) => {
			if (!this.view_dic) {
				this.view_dic = []
			}
			let view = this.view_dic[view_name]
			if (!view && window[view_name]) {
				let view_class: any = window[view_name]
				view = new view_class()
				this.view_dic[view_name] = view
			}
			if (view) {
				view.Open(...new_args)
			}
		})

		this.diamond_fight_model.Bind(DiamondFightModel.CLOSE_VIEW, (view_name?) => {
			let view = this.view_dic && this.view_dic[view_name]
			if (view && view.HasOpen()) {
				view.Close()
				this.view_dic[view_name] = null
			}
		})

		let setMainUIVisible = (index?, bool?) => {
			let mainUI_controller = MainUIController.GetInstance()
			if (index == 1) {
				mainUI_controller.SetMainUIViewVisible(0, bool)
				mainUI_controller.SetMainUIViewVisible(1, bool)
				mainUI_controller.SetMainUIViewVisible(2, bool)
			} else {
				mainUI_controller.SetMainUIViewVisible(0, true)
				mainUI_controller.SetMainUIViewVisible(1, true)
				mainUI_controller.SetMainUIViewVisible(2, true)
				mainUI_controller.SetMainUIViewVisible(10, bool)
			}
		}


		GlobalEventSystem.Bind(SceneEventType.SCENE_CHANGED, () => {
			if (this.scene_mgr.IsDiamondFightWaitingScene() && !this.scene_mgr.IsDiamondFightWaitingScene(this.scene_mgr.GetLastSceneId())) {
				setMainUIVisible(2, false)
				MainUIModel.GetInstance().Fire(MainUIModel.CHANGE_ACTIVITY_STATE, false)
				this.diamond_fight_model.Fire(DiamondFightModel.CLOSE_VIEW, "DiamondFightSceneView")
				this.diamond_fight_model.Fire(DiamondFightModel.OPEN_VIEW, "DiamondFightWaitingView")
			} else if (this.scene_mgr.IsDiamondFightScene() && !this.scene_mgr.IsDiamondFightScene(this.scene_mgr.GetLastSceneId())) {
				this.diamond_fight_model.ResetFightData()
				setMainUIVisible(1, false)
				this.diamond_fight_model.Fire(DiamondFightModel.CLOSE_VIEW, "DiamondFightWaitingView")
				this.diamond_fight_model.Fire(DiamondFightModel.OPEN_VIEW, "DiamondFightSceneView")
				this.diamond_fight_model.Fire(DiamondFightModel.OPEN_VIEW, "DiamondFightMatchSuccessView")
				// AutoFightManager.GetInstance().SetAutoFight(false)
				// GlobalEventSystem.Fire(EventName.STARTAUTOFIGHT)
				GlobalEventSystem.Fire(EventName.STOPAUTOFIGHT)
			} else if (!this.scene_mgr.IsDiamondFightWaitingScene() && this.scene_mgr.IsDiamondFightWaitingScene(this.scene_mgr.GetLastSceneId())) {
				setMainUIVisible(2, true)
				this.diamond_fight_model.Fire(DiamondFightModel.CLOSE_VIEW, "DiamondFightWaitingView")
			} else if (!this.scene_mgr.IsDiamondFightScene() && this.scene_mgr.IsDiamondFightScene(this.scene_mgr.GetLastSceneId())) {
				setMainUIVisible(1, true)
				this.diamond_fight_model.Fire(DiamondFightModel.CLOSE_VIEW, "DiamondFightSceneView")
			}
		})

		// GlobalEventSystem.Bind(EventName.SCENELOADVIEWE_CLOSE, () => {
		// 	if (this.scene_mgr.IsDiamondFightScene() && !this.scene_mgr.IsDiamondFightScene(this.scene_mgr.GetLastSceneId())) {

		// 	}
		// }
		// )

	}

	public RegisterAllProtocals() {
		//活动状态
		this.RegisterProtocal(13700, () => {
			let scmd = this.user_msg_adapter.GetSCMD(13700)
			this.diamond_fight_model.SetStageInfo(scmd)
			let user_info = this.diamond_fight_model.user_info
			let icon_mgr = ActivityIconManager.GetInstance()



			switch (scmd.war_state) {
				case 0:
				case 5:
					if (user_info) {
						user_info.is_sign = 0
					} else {
						user_info = { is_sign: 0 }
					}
					this.diamond_fight_model.ChangeVar("user_info", user_info, false, true)
					break
				case 1:
					this.diamond_fight_model.Fire(DiamondFightModel.REQUEST_SCMD, 13701)
					break
				default:
					if (scmd.war_state == 2) {
						this.show_diamond_enter_tips = true
					}
					this.diamond_fight_model.Fire(DiamondFightModel.REQUEST_SCMD, 13701)
					this.diamond_fight_model.Fire(DiamondFightModel.REQUEST_SCMD, 13703)
					break


			}

			if (scmd.war_state > 0 && scmd.war_state < 5) {
				let txt = ""
				let color
				let is_show_icon=true
				if (scmd.war_state == 1) {
					if (user_info && user_info.is_sign == 1) {
						txt ="已报名"
						color="#ff4f50"
						is_show_icon = false
					} else {
						txt ="报名中"
						color="#88ff43"
					}
				} else if (scmd.war_state >= 2) {
					txt = "进行中"
					color="#88ff43"
				}
				if(is_show_icon){
				let icon_info = icon_mgr.getIconInfo(DiamondFightModel.MODULE_ID)
				if (icon_info) {
					GlobalEventSystem.Fire(ActivityIconManager.SET_ICON_TEXT, DiamondFightModel.MODULE_ID, txt,color)
				} else {
					icon_mgr.addIcon(DiamondFightModel.MODULE_ID, null, null, txt)
				}
			} else {
				icon_mgr.deleteIcon(DiamondFightModel.MODULE_ID)
				}
			} else {
				icon_mgr.deleteIcon(DiamondFightModel.MODULE_ID)
			}
			this.diamond_fight_model.UpdateRedforDiamond()
		})

		//面板信息
		this.RegisterProtocal(13701, () => {
			let scmd = this.user_msg_adapter.GetSCMD(13701)
			this.diamond_fight_model.SetUserInfo(scmd)
			let open_func = () => {
				let view = ViewManager.GetInstance().GetView("WorldBattleEnterView")
				if (view && view.HasOpen()) {
					view.SelectView(TopPkModel.GetInstance().WorldBattleIndex.Diamond_Fight)
				} else {
					GlobalEventSystem.Fire(EventName.OPEN_VIEW, "WorldBattleEnterView", DiamondFightModel.MODULE_ID)
				}
			}

			if (this.show_diamond_enter_tips) {
				this.show_diamond_enter_tips = false
				let state = scmd.is_sign == 1
				if (state) {
					Alert.Show("勾玉大战已正式开启,您已报名,是否立即前往？", Alert_Type.Two, open_func, null, "确定", "取消")
				}
			}
		})

		//报名
		this.RegisterProtocal(13702, () => {
			let scmd = this.user_msg_adapter.GetSCMD(13702)
			if (scmd.code == 1) {
				Message.show("报名成功~")
				if (this.diamond_fight_model.user_info) {
					this.diamond_fight_model.user_info.is_sign = 1
				}
				this.diamond_fight_model.SetUserInfo(this.diamond_fight_model.user_info)
			} else {
				Util.ErrorCodeShow(scmd.code)
			}
		})

		//入场倒计时
		this.RegisterProtocal(13703, () => {
			let scmd = this.user_msg_adapter.GetSCMD(13703)
			if (scmd.type == 4) {
				return
			}
			if (scmd.type == 3) {
				this.diamond_fight_model.ChangeVar("fight_start_time", scmd.end_time)
			} else if (scmd.type == 6) {
				this.diamond_fight_model.ChangeVar("fight_end_time", scmd.end_time)
				this.diamond_fight_model.ChangeVar("wait_tip_info", scmd)
			} else {
				this.diamond_fight_model.ChangeVar("wait_tip_info", scmd)
			}
		})

		//进入准备场景
		this.RegisterProtocal(13704, () => {
			let scmd = this.user_msg_adapter.GetSCMD(13704)
			if (scmd.code != 1) {
				Util.ErrorCodeShow(scmd.code)
			}
		})

		//小面板
		this.RegisterProtocal(13705, () => {
			let scmd = this.user_msg_adapter.GetSCMD(13705)
			this.diamond_fight_model.ChangeVar("waiting_info", scmd)
		})

		//购买命数
		this.RegisterProtocal(13706, () => {
			let scmd = this.user_msg_adapter.GetSCMD(13706)
			if (scmd.code == 1) {
				Message.show("购买成功~")
				if (this.diamond_fight_model.waiting_info) {
					this.diamond_fight_model.waiting_info.life_num = scmd.life_num
				}
				this.diamond_fight_model.Fire(DiamondFightModel.UPDATE_LIFE, scmd.life_num)
			} else {
				Util.ErrorCodeShow(scmd.code)
			}
		})

		//退出场景
		this.RegisterProtocal(13707, () => {
			let scmd = this.user_msg_adapter.GetSCMD(13707)
		})

		//战报
		this.RegisterProtocal(13708, () => {
			let scmd = this.user_msg_adapter.GetSCMD(13708)
			if (scmd.settlement == 1) {
				this.diamond_fight_model.fight_enemy_info = Util.DeepCopy(this.diamond_fight_model.fight_enemy_info)
				this.diamond_fight_model.Fire(DiamondFightModel.OPEN_VIEW, "DiamondFightResultView", scmd)
			}
		})

		//激活AI 暂时不用
		this.RegisterProtocal(13709, () => {
			let scmd = this.user_msg_adapter.GetSCMD(13709)
		})

		//命数信息
		this.RegisterProtocal(13710, () => {
			let scmd = this.user_msg_adapter.GetSCMD(13710)
			if ((this.diamond_fight_model.lives_info && this.diamond_fight_model.lives_info.self_life > scmd.self_life) && scmd.self_life != 0) {
				GlobalEventSystem.Fire(EventName.RELIVE_BY_TYPE, 19, true)
			}
			this.diamond_fight_model.ChangeVar("lives_info", scmd)
		})

		//战报
		this.RegisterProtocal(13711, () => {
			let scmd = this.user_msg_adapter.GetSCMD(13711)
			this.diamond_fight_model.SetHistoryList(scmd)
		})

		//冠军广播
		this.RegisterProtocal(13712, () => {

		})

		//假人信息
		this.RegisterProtocal(13714, () => {
			let scmd = this.user_msg_adapter.GetSCMD(13714)
			this.diamond_fight_model.ChangeVar("fake_role_info", scmd)
		})

		//使用技能
		this.RegisterProtocal(13715, () => {
			let scmd = this.user_msg_adapter.GetSCMD(13715)
			if (scmd.code == 1) {
				this.diamond_fight_model.SetSkillCd(scmd)
				GlobalEventSystem.Fire(FightEvent.RELEASE_MAIN_SKILL, null, scmd.skill_id)
				Message.show("技能使用成功~")
			} else {
				Util.ErrorCodeShow(scmd.code)
			}
		})

		//赛区
		this.RegisterProtocal(13716, () => {
			let scmd = this.user_msg_adapter.GetSCMD(13716)
			this.diamond_fight_model.SetZoneInfo(scmd)
		})

		//竞猜面板更新(客户端收到协议后，如果竞猜面板打开中，请求13719更新面板信息)
		this.RegisterProtocal(13718, () => {
			let scmd = this.user_msg_adapter.GetSCMD(13718)
			let battle_view = this.view_dic && this.view_dic["DiamondFightBattleView"]
			let bet_view = this.view_dic && this.view_dic["DiamondfightBetView"]
			if (battle_view && battle_view.HasOpen() || bet_view && bet_view.HasOpen()) {
				this.diamond_fight_model.Fire(DiamondFightModel.REQUEST_SCMD, 13719)
			}
		})

		//竞猜面板
		this.RegisterProtocal(13719, () => {
			let scmd = this.user_msg_adapter.GetSCMD(13719)
			this.diamond_fight_model.SetGambleData(scmd)
		})

		//竞猜
		this.RegisterProtocal(13720, () => {
			let scmd = this.user_msg_adapter.GetSCMD(13720)
			if (scmd.code == 1) {
				Message.show("竞猜成功～")
				let gamble_data = this.diamond_fight_model.gamble_data && this.diamond_fight_model.gamble_data.data
				if (gamble_data) {
					let action_data = gamble_data[scmd.action_id]
					if (action_data) {
						for (let _tmpi in action_data) {
							var vo = action_data[_tmpi]
							if (vo.arid == scmd.role_id || vo.brid == scmd.role_id) {
								vo.suprid = scmd.role_id
								this.diamond_fight_model.ChangeVar("gamble_data", this.diamond_fight_model.gamble_data, false, true)
								return
							}
						}
					}
				}
			} else {
				Util.ErrorCodeShow(scmd.code)
			}
		})

		//所有的竞猜记录
		this.RegisterProtocal(13721, () => {
			let scmd = this.user_msg_adapter.GetSCMD(13721)
			this.diamond_fight_model.SetRecordInfo(scmd)
			this.TryRefreshRecordRed()
		})

		//添加新竞猜记录(服务端推)
		this.RegisterProtocal(13722, () => {
			let scmd = this.user_msg_adapter.GetSCMD(13722)
			let info = this.diamond_fight_model.record_info
			if (!info) {
				info = {}
			}
			if (!info[scmd.zone]) {
				info[scmd.zone] = []
			}
			table.insert(info[scmd.zone], scmd)
			this.diamond_fight_model.ChangeVar("record_info", info, false, true)
			this.TryRefreshRecordRed()
		})

		//竞猜奖励领取
		this.RegisterProtocal(13723, () => {
			let scmd = this.user_msg_adapter.GetSCMD(13723)
			if (scmd.code == 1) {
				Message.show("领取成功～")
				let info = this.diamond_fight_model.record_info
				if (info) {
					let zone_info = info[scmd.zone]
					if (zone_info) {
						for (let _tmpi in zone_info) {
							var vo = zone_info[_tmpi]
							if (vo.suprid == scmd.suprid && vo.action == scmd.action) {
								vo.reward_st = scmd.reward_st
								this.diamond_fight_model.ChangeVar("record_info", info, false, true)
								this.TryRefreshRecordRed()
							}
						}
					}
				}
			} else {
				Util.ErrorCodeShow(scmd.code)
			}
		})

		//胜者广播
		this.RegisterProtocal(13724, () => {
			let scmd = this.user_msg_adapter.GetSCMD(13724)
			let gamble_data = this.diamond_fight_model.gamble_data && this.diamond_fight_model.gamble_data.data
			if (gamble_data) {
				let action_data = gamble_data[scmd.action]
				if (action_data) {
					for (let _tmpi in action_data) {
						var vo = action_data[_tmpi]
						if (vo.arid == scmd.winner || vo.brid == scmd.winner) {
							vo.winner = scmd.winner
							this.diamond_fight_model.ChangeVar("gamble_data", this.diamond_fight_model.gamble_data, false, true)
							return
						}
					}
				}
			}
		})

	}

	try_refresh_red = false
	public TryRefreshRecordRed() {
		if (this.try_refresh_red) return
		this.try_refresh_red = true
		this.res_mgr.GetGameConfigWithAutoDestory("config_drumwar_lv_to_zone", (config_drumwar_lv_to_zone) => {
			this.try_refresh_red = false
			this.diamond_fight_model.RefreshRecordRed(config_drumwar_lv_to_zone)
		}, false)
	}

}