
//require("game.proto.159.Require159")
//require("game.firstRecharge.FirstRechargeModel")
//require("game.firstRecharge.FirstRechargeTipsView")
//require("game.firstRecharge.FirstRechargeView")
//require("game.firstRecharge.FirstRechargeBubble")
import { FirstRechargeModel } from "../commonModel/FirstRechargeModel"
import { FirstRechargeTipsView } from "../recharge/FirstRechargeTipsView"
import { FirstRechargeView } from "../recharge/FirstRechargeView"
import "../recharge/FirstRechargeBubble"
import { BaseController } from "../common/BaseController"
import { RoleManager } from "../commonModel/RoleManager"
import { TaskModel } from "../commonModel/TaskModel"
import { EventName } from "../common/EventName"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { UserMsgAdapter } from "../common/UserMsgAdapter"
import { ActivityIconManager } from "../commonModel/ActivityIconManager"
import { ResManager } from "../common/ResManager"
import { ServerTimeModel } from "../serverTime/ServerTimeModel"
import { Util } from "../util/Util"
import { ErlangParser } from "../util/ErlangParser"
import { CongratulationObtainView } from "../common/CongratulationObtainView"
import { SceneManager } from "../scene/SceneManager"
import { SceneEventType } from "../common/EventName"
import { TimeUtil } from "../util/TimeUtil"
import { Config } from "../common/Config"
import { PlatformManager } from "../PlatformManager"
import "../recharge/FirstRechargeNewTipsView"
import { MainRoleVo } from "../sharedata/MainRoleVo"
import { FirstRechargeNewTipsView } from "../recharge/FirstRechargeNewTipsView"
import { AddVipServiceModel } from "../commonModel/AddVipServiceModel"
import { WeekCardModel } from "../commonModel/WeekCardModel"
import { ViewPopLevelModel } from "../commonModel/ViewPopLevelModel"
export class FirstRechargeController extends BaseController {
	CheckShowBubble
	GetRewardList
	InitEvents
	InitInfo
	ShowTipsView

	public constructor() {
		super()


		let model = FirstRechargeModel.GetInstance()
		let role_mgr = RoleManager.GetInstance()
		let local_EventName = EventName
		let task_model = TaskModel.GetInstance()
		let local_GlobalEventSystem = GlobalEventSystem
		let local_FirstRechargeModel = FirstRechargeModel
		//let platform_mgr = PlatformManager.GetInstance()
		let user_msg_adapter = UserMsgAdapter.GetInstance()
		let local_ActivityIconManager = ActivityIconManager

		let first_recharge_view_ = null
		let first_recharge_tips_view_ = null
		let first_recharge_qipao_view = null
		let _id_ = null
		this.InitEvents = () => {
			//日服20级之后才开始所有的首充流程
			// if (PlatformMgr.GetInstance().IsEyouJpPlatform() ) {
			// 	let role_lv = role_mgr.GetMainRoleVo().level
			// 	if (role_lv < model.open_func_lv ) {
			// 		let level_up_imme = role_mgr.GetMainRoleVo().Bind(EventName.IMMEDIATE_CHANGE_LEVEL,(level?) => {
			// 				if (level == model.open_func_lv ) {
			// 					let curr_time = TimeUtil.getServerTime()
			// 					CookieWrapper.GetInstance().SaveCookie(CookieLevelType.Account,CookieTimeType.TYPE_ALWAYS, CookieKey.FIRST_RECHARGE_OPEN,curr_time)
			// 					model.Fire(FirstRechargeModel.SCMD_REQUEST, 15905)
			// 					role_mgr.GetMainRoleVo().UnBind(level_up_imme)
			// 				}
			// 			})
			// 	}
			// }


			let call_func = (first_recharge_cfg?) => {

				//等级
				let level_up_id = role_mgr.GetMainRoleVo().Bind(local_EventName.CHANGE_LEVEL, (level?) => {
					if (model.IsDoneFirstRecharge()) {
						role_mgr.GetMainRoleVo().UnBind(level_up_id)
						return
					}
					this.ShowTipsView(level, false, first_recharge_cfg)
				}
				)

				//任务
				let cache_task_id = null
				let task_change_id = GlobalEventSystem.Bind(EventName.UPDATE_NEWEST_TASK_ID, (value?) => {
					if (model.IsDoneFirstRecharge()) {
						GlobalEventSystem.UnBind(task_change_id)
						return
					}
					let newest_finish_task_id = task_model.newest_finish_task_id
					if (cache_task_id && cache_task_id != newest_finish_task_id) {
						cache_task_id = newest_finish_task_id
						this.ShowTipsView(false, newest_finish_task_id, first_recharge_cfg)
					}
					if (!cache_task_id) {
						cache_task_id = newest_finish_task_id
					}
				}
				)
			}

			local_GlobalEventSystem.Bind(local_EventName.GAME_START, () => {
				model.ResetModel()
				let cfg = Config.PRELOAD_CLIENT_CONFIG.ConfigFirstRecharge
				call_func(cfg)
				model.Fire(local_FirstRechargeModel.SCMD_REQUEST, 15905)
				model.Fire(local_FirstRechargeModel.SCMD_REQUEST, 15908)
			}
			)
			//首充弹窗 
			TaskModel.GetInstance().Bind(TaskModel.FINISH_TASK, (task_id) => {
				let cfg = Config.PRELOAD_CLIENT_CONFIG.ConfigFirstRecharge
				if (cfg.new_tips_show_task_id.length <= 0) return
				for (let num = 0; num < cfg.new_tips_show_task_id.length; num++) {
					if (cfg.new_tips_show_task_id[num] == task_id && FirstRechargeModel.GetInstance().IsNoFirstRecharge()) {
						model.Fire(local_FirstRechargeModel.OPEN_FIRST_RECHARGE_TIPS_VIEW)
						break
					}
				}
			})

			RoleManager.GetInstance().GetMainRoleVo().Bind(EventName.CHANGE_LEVEL, () => {
				let cfg = Config.PRELOAD_CLIENT_CONFIG.ConfigFirstRecharge
				let lv = RoleManager.GetInstance().mainRoleInfo.level
				for (let num = 0; num < cfg.tips_show_new_Lv.length; num++) {
					if (lv == cfg.tips_show_new_Lv[num] && FirstRechargeModel.GetInstance().IsNoFirstRecharge()){
						model.Fire(local_FirstRechargeModel.OPEN_FIRST_RECHARGE_TIPS_VIEW)
						break
					}
				}
			})

			local_GlobalEventSystem.Bind(local_EventName.CHANGE_ROLE, () => {
				ActivityIconManager.GetInstance().deleteIcon(159)
				model.Fire(local_FirstRechargeModel.ADD_BUBBLE, false)
			})

			local_GlobalEventSystem.Bind(local_EventName.CHANGE_ACCOUNT, () => {
				ActivityIconManager.GetInstance().deleteIcon(159)
				model.Fire(local_FirstRechargeModel.ADD_BUBBLE, false)
			})

			model.Bind(local_FirstRechargeModel.SCMD_REQUEST, (cmd, ...new_args) => {
				let args = new_args
				if (15906 == cmd) {
					this.SendFmtToGame(cmd, "c", args[0])
				} else {
					this.SendFmtToGame(cmd)
				}
			}
			)

			model.Bind(local_FirstRechargeModel.OPEN_FIRST_RECHARGE_TIPS_VIEW, () => {
				// if (platform_mgr.is_alpha || platform_mgr.need_alpha_open_charge ) {
				// 	return
				// }
				if (PlatformManager.GetInstance().is_alpha || SceneManager.GetInstance().IsExpDungeon()) return
				let cfg = Config.PRELOAD_CLIENT_CONFIG.ConfigFirstRecharge
				let Lv = RoleManager.GetInstance().mainRoleInfo.level
				if (Lv < cfg.tips_show_min_lv) return
				Laya.timer.once(2000, this, () => {
					if(model.is_bubble){
						model.Fire(FirstRechargeModel.ADD_FIRST_RECHARGE_NEW_TIPS_ITEM,model.is_bubble)
					}else{
						model.Fire(FirstRechargeModel.ADD_FIRST_RECHARGE_NEW_TIPS_ITEM,null)
					}

				})
				// Laya.timer.once(2000, this, () => {
				// 	if (!first_recharge_tips_view_) {
				// 		first_recharge_tips_view_ = new FirstRechargeNewTipsView()
				// 	}
				// 	if (!first_recharge_tips_view_.HasOpen()) {
				// 		first_recharge_tips_view_.Open()
				// 	}
				// })

			})

			model.Bind(local_FirstRechargeModel.OPEN_FIRST_RECHARGE_VIEW, (is_open_time?) => {
				if (PlatformManager.GetInstance().is_alpha) return
				if (!first_recharge_view_) {
					first_recharge_view_ = new FirstRechargeView()
				}
				if (!first_recharge_view_.HasOpen()) {
					first_recharge_view_.Open(is_open_time)
				}
			}
			)

			//跨天
			let dayChange = () => {
				if (model.HasNoRecevie()) {
					this.SendFmtToGame(15905)
				}
			}
			local_GlobalEventSystem.Bind(ServerTimeModel.DAY_CHANGE, dayChange)

			//屏蔽渠道 原h5
			let change_fun = () => {
				this.SendFmtToGame(15905)
			}
			local_GlobalEventSystem.Bind(local_EventName.ALPHA_STATE_CHANGE, change_fun)
		}

		this.InitInfo = () => {
			let activity_icon_mgr = ActivityIconManager.GetInstance()
			let On15905 = () => {
				let scmd = user_msg_adapter.GetSCMD(15905)
				model.first_recharge_info = scmd
				WeekCardModel.GetInstance().Fire(WeekCardModel.UPDATE_ICON)
				model.is_notify = scmd.is_notify
				model.iconRed = false
				if (!model.IsDoneAllReward()) {
					let icon = activity_icon_mgr.getIconInfo(159)
					let showRed = false
					let showText = false
					for (let _tmpi in scmd.reward_list) {
						var vo = scmd.reward_list[_tmpi]
						if (vo.open == 1) {
							showRed = true
						} else if (vo.open == 2) {
							showText = true
						}
					}
					model.iconRed = showRed
					let show_state = this.CheckShowBubble()
					if (show_state == 0) {	//展示倒计时通知阶段
						if (!model.is_bubble) {
							FirstRechargeModel.GetInstance().Fire(FirstRechargeModel.ADD_BUBBLE, true)
							model.is_bubble = true
						}
					} else if (show_state == 1) {//已经过了倒计时通知，主界面图标显示
						if (!icon) {
							if (showText && !showRed) {
								activity_icon_mgr.addIcon(159, null, null, "明天可领")
								if (model.is_bubble) {
									FirstRechargeModel.GetInstance().Fire(FirstRechargeModel.ADD_BUBBLE, false)
									model.is_bubble = false
								}
							} else {
								activity_icon_mgr.addIcon(159)
								if (model.is_bubble) {
									FirstRechargeModel.GetInstance().Fire(FirstRechargeModel.ADD_BUBBLE, false)
									model.is_bubble = false
								}
							}
						} else {
							if (showText && !showRed) {
								local_GlobalEventSystem.Fire(local_ActivityIconManager.SET_ICON_TEXT, 159, "明天可领")
							} else {
								local_GlobalEventSystem.Fire(local_ActivityIconManager.SET_ICON_TEXT, 159, "")
							}
						}
						local_GlobalEventSystem.Fire(local_EventName.REFRESH_ACTIVITY_ICON_RED_DOT, 159)
					}

				} else {
					activity_icon_mgr.deleteIcon(159)
					if (first_recharge_view_ && first_recharge_view_.HasOpen()) {
						first_recharge_view_.Close()
					}
				}
				model.Fire(local_FirstRechargeModel.UPDATE_FIRST_RECHARGE_VIEW)
				let cfg = Config.PRELOAD_CLIENT_CONFIG.ConfigFirstRecharge
				if (cfg.is_tips_show && model.first_show_tips && TimeUtil.timeConversion(RoleManager.GetInstance().GetMainRoleVo().create_role_time) == TimeUtil.timeConversion(TimeUtil.getServerTime()) && model.IsNoFirstRecharge()) {
					model.first_show_tips = false
					model.Fire(local_FirstRechargeModel.OPEN_FIRST_RECHARGE_TIPS_VIEW)
				}
			}

			let On15906 = () => {
				let scmd = user_msg_adapter.GetSCMD(15906)
				Util.ErrorCodeShow(scmd.errcode)
				if (scmd.errcode == 1) {
					model.Fire(local_FirstRechargeModel.SCMD_REQUEST, 15905)
					model.Fire(local_FirstRechargeModel.RECEVIED_SUCCESS, scmd.index)
					this.GetRewardList(scmd.index)
					model.Fire(local_FirstRechargeModel.CREAT_FIRST_QIPAO, true)
					//完成首充并领取第一次首充奖励
					if(scmd.index == 1){
						PlatformManager.GetInstance().EyouDataPlacement("purchase_first");
					}
				}
			}
			
			let On15908 = () =>{
				let scmd = user_msg_adapter.GetSCMD(15908)
				if (scmd.is_buy == 1) {
					AddVipServiceModel.GetInstance().is_show_add_vip_service_icon = true
					AddVipServiceModel.GetInstance().CheckIconOpen()
				}
			}

			this.RegisterProtocal(15905, On15905)
			this.RegisterProtocal(15906, On15906)
			this.RegisterProtocal(15908, On15908)
		}

		this.GetRewardList = (index?) => {
			ResManager.GetInstance().LoadGameConfig(this, "config_recharge_first", false, undefined, (cfg) => {
				let data = model.first_recharge_info
				let sex = role_mgr.mainRoleInfo.sex
				let str = data.product_id + "@" + sex + "@" + index
				let cfg_data = cfg[str]
				let career_reward = JSON.parse(cfg_data.reward)
				let reward_list = []
				for (let _i = 0; _i < career_reward.length; _i++) {
					var _v = career_reward[_i]
					if (role_mgr.mainRoleInfo.career == Number(_v[0])) {
						reward_list = _v[1]
					}
				}
				if (reward_list && reward_list.length > 0) {
					let congratulation_obtain_View = new CongratulationObtainView(reward_list, 10)
					congratulation_obtain_View.Open()
				}
				ResManager.GetInstance().DestoryGameConfig(this, "config_recharge_first")
			})
		}

		this.ShowTipsView = (level?, task_id?, first_recharge_cfg?) => {
			//tips界面的特效没做好，直接弹出首充界面。
			let scene_mgr = SceneManager.GetInstance()
			if (_id_) {
				return
			}
			if (!first_recharge_cfg) {
				return
			}
			if (level) {
				let list = first_recharge_cfg.tips_show_lv
				for (let _tmpi in list) {
					var v = list[_tmpi]
					if (level == v) {
						if (scene_mgr.IsFieldScene()) {
							ViewPopLevelModel.GetInstance().SetView('FirstRechargeView');
							// model.Fire(local_FirstRechargeModel.OPEN_FIRST_RECHARGE_VIEW)
						} else {
							_id_ = local_GlobalEventSystem.Bind(SceneEventType.SCENE_CHANGED, () => {
								if (scene_mgr.IsFieldScene() && !scene_mgr.IsFieldScene(String(scene_mgr.GetLastSceneId()))) {
									// model.Fire(local_FirstRechargeModel.OPEN_FIRST_RECHARGE_VIEW)
									ViewPopLevelModel.GetInstance().SetView('FirstRechargeView');
									local_GlobalEventSystem.UnBind(_id_)
									_id_ = null
								}
							}
							)
						}
						break
					}
				}
			}
			if (task_id) {
				let list = first_recharge_cfg.tips_show_task_id
				for (let _tmpi in list) {
					var v = list[_tmpi]
					if (task_id == v) {
						if (scene_mgr.IsFieldScene()) {
							// model.Fire(local_FirstRechargeModel.OPEN_FIRST_RECHARGE_VIEW, true)
							ViewPopLevelModel.GetInstance().SetView('FirstRechargeView', true);
						} else {
							_id_ = local_GlobalEventSystem.Bind(SceneEventType.SCENE_CHANGED, () => {
								if (scene_mgr.IsFieldScene() && !scene_mgr.IsFieldScene(String(scene_mgr.GetLastSceneId()))) {
									// model.Fire(local_FirstRechargeModel.OPEN_FIRST_RECHARGE_VIEW, true)
									ViewPopLevelModel.GetInstance().SetView('FirstRechargeView', true);
									local_GlobalEventSystem.UnBind(_id_)
									_id_ = null
								}
							}
							)
						}
						break
					}
				}
			}
		}

		//0未通知 1已通知 2先不通知(日服)
		this.CheckShowBubble = () => {
			//已经通知过
			if (model.is_notify == 1) {
				return 1
			}

			//充值了，需要标记已通知
			if (model.IsDoneFirstRecharge() && model.is_notify == 0) {
				model.is_notify = 1
				model.Fire(local_FirstRechargeModel.SCMD_REQUEST, 15907)
				return 1
			}

			let [e_time, state] = model.GetBubbleTime()
			if (state == 0) {
				let left_time = e_time - TimeUtil.getServerTime()
				if (left_time > 0) {
					//在通知时间内
					return 0
				} else if (left_time <= 0) {
					if (model.is_notify == 0) {
						//过了通知时间了，需要标记已通知
						model.is_notify = 1
						model.Fire(local_FirstRechargeModel.SCMD_REQUEST, 15907)
					}
					return 1
				}
			} else {
				if (state == 1) {
					model.is_notify = 1
					model.Fire(local_FirstRechargeModel.SCMD_REQUEST, 15907)
				}
				return state
			}

		}

		this.InitEvents()
		this.InitInfo()
	}
}

window["FirstRechargeController"] = FirstRechargeController