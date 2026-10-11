import { BaseController } from "../common/BaseController"
import { CommonManager } from "../common/CommonManager"
import { CongratulationObtainView } from "../common/CongratulationObtainView"
import { EventName } from "../common/EventName"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { UserMsgAdapter } from "../common/UserMsgAdapter"
import { CustomActivityDefine } from "../commonModel/CustomActivityDefine"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { TaskModel } from "../commonModel/TaskModel"
import { WelfareModel, WelfareEvent } from "../commonModel/WelfareModel"
import "../levelReward/LevelRewardView"
import { ActivityIconManager } from "../commonModel/ActivityIconManager"
import { PlatformManager } from "../PlatformManager"
import { RoleManager } from "../commonModel/RoleManager"
import { ServerTimeModel } from "../serverTime/ServerTimeModel"
import { Message } from "../sysInfo/SysInfoController"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { ErlangParser } from "../util/ErlangParser"
import { Util } from "../util/Util"
import { WelfareView } from "../welfare/WelfareView"
import { TimeUtil } from "../util/TimeUtil"
import "../welfare/WelfareWelcomeView"
import { KaifuActivityModel } from "../commonModel/KaifuActivityModel"

export class WelfareController extends BaseController {
	InitInfo
	close_event_id
	svip_view
	welfare_view
	welfare_welcome_view
	obtain_view
	public constructor() {
		super()

		this.welfare_view = null
		this.svip_view = null
		this.InitInfo = () => {
			let welfareModel = WelfareModel.GetInstance()
			let local_WelfareEvent = WelfareEvent
			let user_msg_adapter = UserMsgAdapter.GetInstance()
			let custom_activity_model = CustomActivityModel.GetInstance()
			let local_CustomActivityDefine = CustomActivityDefine
			let activity_icon_mgr = ActivityIconManager.GetInstance()
			let role_vo = RoleManager.GetInstance().GetMainRoleVo()

			let local_GlobalEventSystem = GlobalEventSystem
			let local_EventName = EventName
			let user_mgr = UserMsgAdapter.GetInstance()
			////////////////////////等级礼包////////////////////////

			let ShowLevelReward = (scmd?) => {
				let data = []
				for (let _tmpi in scmd.rewads) {
					var reward = scmd.rewads[_tmpi]
					table.insert(data, { "0": reward.style, "1": reward.typeId, "2": reward.count })
				}
				if (data.length > 0) {
					let view = new CongratulationObtainView(data, 10)
					view.banner_view_type = "LevelReward"
					view.Open()
				}
			}

			let Handler41700 = () => {
				let scmd = user_msg_adapter.GetSCMD(41700)
				table.sort(scmd.giftbag_state, (a?, b?) => {
					return a.lv < b.lv
				})
				welfareModel.SetLevelRewardInfo(scmd)
				let open_day = ServerTimeModel.GetInstance().GetOpenServerDay()
				if (open_day <= 7) {
					custom_activity_model.CheckSpecialIcon("331@3_1")
				} else {
					custom_activity_model.CheckSpecialIcon("331@3")
				}
			}

			let Handler41701 = () => {
				let scmd = user_msg_adapter.GetSCMD(41701)
				if (scmd.code == 1) {
					welfareModel.Fire(local_WelfareEvent.WELFARE_REQUEST_PROTO, 41700)
					ShowLevelReward(scmd)
				} else {
					Util.ErrorCodeShow(scmd.code)
				}
			}

			////////////////////////等级礼包////////////////////////


			////////////////////////每日签到////////////////////////

			let Handler41703 = () => {
				let scmd = user_msg_adapter.GetSCMD(41703)
				welfareModel.SetDailySignData(scmd)
			}

			let Handler41704 = () => {
				let code = this.ReadFmt("i")
				if (code == 1) {
					let reward = []
					let vo = null

					let len = this.ReadFmt("h")
					for (let i = 1; i <= len; i++) {
						vo = []
						let style = this.ReadFmt("i")
						let typeId = this.ReadFmt("i")
						let count = this.ReadFmt("i")
						vo[0] = style //table.insert(vo, style)
						vo[1] = typeId //table.insert(vo, typeId)
						vo[2] = count //table.insert(vo, count)
						table.insert(reward, vo)
					}

					let len4 = this.ReadFmt("h")
					for (let i = 1; i <= len4; i++) {
						vo = []
						let style = this.ReadFmt("i")
						let typeId = this.ReadFmt("i")
						let count = this.ReadFmt("i")
						vo[0] = style //table.insert(vo, style)
						vo[1] = typeId //table.insert(vo, typeId)
						vo[2] = count //table.insert(vo, count)
						table.insert(vo, true)
						table.insert(reward, vo)
					}

					//奖励展示
					let reward_view = new CongratulationObtainView(reward, 10, null, null, null, null, window["enum_CongratulaionType"].additional)
					reward_view.Open()

					welfareModel.Fire(local_WelfareEvent.WELFARE_REQUEST_PROTO, 41703)
				} else {
					Util.ErrorCodeShow(code)
				}
			}

			let Handler41705 = () => {
				let scmd = user_msg_adapter.GetSCMD(41705)
				if (scmd.code == 1) {
					let reward_arr = GoodsModel.RewardKeyToNumber(scmd.rewads)
					let reward_view = new CongratulationObtainView(reward_arr, 10)
					reward_view.Open()
					welfareModel.Fire(local_WelfareEvent.WELFARE_REQUEST_PROTO, 41703)
				} else {
					Util.ErrorCodeShow(scmd.code)
				}
			}

			////////////////////////每日签到////////////////////////

			////////////////////////在线福利////////////////////////

			let Handler41715 = () => {
				let scmd = user_msg_adapter.GetSCMD(41715)
				scmd.list.sort((a?, b?) => {
					let acfg = welfareModel.GetOnlineCfg(a.id)
					let bcfg = welfareModel.GetOnlineCfg(b.id)
					if (!acfg || !bcfg) {
						return 0
					}
					return acfg.sort - bcfg.sort
				}
				)
				// [ts2lua]scmd下标访问可能不正确
				scmd["cur_time"] = TimeUtil.getServerTime()
				welfareModel.SetOnlineData(scmd)
			}

			let Handler41707 = () => {
				let scmd = user_mgr.GetSCMD("41707")
				welfareModel.UpdateResourceGiftRewardState(scmd)
			}


			let Handler41708 = () => {
				let scmd = user_mgr.GetSCMD("41708")
				if (scmd.code == 1) {
					Message.show("领取成功")
					welfareModel.UpdateResourceGiftRewardState({ code: 2 })
					let reward = welfareModel.config_key_value && welfareModel.config_key_value[1] && welfareModel.config_key_value[1].value
					reward = reward && ErlangParser.GetInstance().Parse(reward)
					if (reward) {
						Util.ShowCongratulationView(reward)
					}
				} else {
					Util.ErrorCodeShow(scmd.code)
				}
			}





			let Handler41716 = () => {
				let scmd = user_msg_adapter.GetSCMD(41716)
				if (scmd.code == 1) {
					welfareModel.Fire(local_WelfareEvent.WELFARE_REQUEST_PROTO, 41715)
					let list = []
					for (let i in scmd.send_list) {
						let data = scmd.send_list[i].rewards[0]
						let obj = []
						obj[0] = data.style;
						obj[1] = data.typeId;
						obj[2] = data.count;
						table.insert(list, obj)
					}
					if (KaifuActivityModel.GetInstance().CheckHaveMonthCard()) {
						for (let i in scmd.send_list) {
							let data = scmd.send_list[i].other_rewards[0]
							if (!data) continue
							let obj = []
							obj[0] = data.style;
							obj[1] = data.typeId;
							obj[2] = data.count;
							obj[3] = null
							obj[4] = null
							obj[5] = true
							table.insert(list, obj)
						}
					}

					if (list.length > 0) {
						this.obtain_view = new CongratulationObtainView(list, 10)
						this.obtain_view.Open()
					}
				} else {
					Util.ErrorCodeShow(scmd.code)
				}
			}

			////////////////////////在线福利////////////////////////^

			//没用的
			let Handler41717 = () => {
				//let scmd = user_msg_adapter.GetSCMD(41717)
				//welfareModel:UpdataLevelRewardNum(scmd)
			}



			////////////////////-手机/身份验证//////////////////////-

			let Handler41718 = () => {
				//let scmd = user_msg_adapter.GetSCMD(41718)
				//if (scmd.code == 1 ) {
				//Message.show("领取验证奖励成功")
				//if (scmd.reward.length > 0 ) {
				//local_Util:ShowCongratulationView(scmd.reward)
				//}
				//}else{
				//Util.ErrorCodeShow(scmd.code)
				//}
			}

			////////////////////-手机/身份验证//////////////////////-

			//////////////////////领取心悦礼包//////////////////////-

			let Handler41719 = () => {
				let scmd = user_msg_adapter.GetSCMD(41719)
				console.log("41719////////-:", scmd.code, scmd.opr, scmd.gift_st)
				if (scmd.code == 1) {
					if (scmd.opr == 4) {	//领取新手礼包
						if (scmd.reward.length > 0) {
							Util.ShowCongratulationView(scmd.reward)
							//if (LoginModel.GetInstance().is_new_career ) {	//新角色
							if (this.close_event_id) {
								local_GlobalEventSystem.UnBind(this.close_event_id)
								this.close_event_id = null
							}
							this.close_event_id = local_GlobalEventSystem.Bind(local_EventName.CONGRATULATION_VIEW_CLOSE, () => {
								TaskModel.GetInstance().DoTask()	//开始任务
								if (this.close_event_id) {
									local_GlobalEventSystem.UnBind(this.close_event_id)
									this.close_event_id = null
								}
							})
							//}
						}
					} else if (scmd.opr == 3) {	//新手礼包
						if (scmd.gift_st == 0) { 	//未领取礼包
							//if (LoginModel.GetInstance().is_new_career ) {	//新角色
							// GlobalEventSystem.Fire(EventName.OPEN_WEFARE_WELCOME_VIEW)
							//}else{
							//welfareModel:Fire(local_WelfareEvent.WELFARE_REQUEST_PROTO, 41719, "c", 4)	//目前英文的新手奖励界面用
							//}
						} else {
						}
					}
				} else {
					if (scmd.code != 1005 && scmd.code != 1028) {
						Util.ErrorCodeShow(scmd.code)
					}
				}

				//let scmd = user_msg_adapter.GetSCMD(41719)
				//if (scmd.code == 1 ) {
				//let icon_type = 41719
				//if (scmd.opr == 2 ) {
				//if (scmd.reward.length > 0 ) {
				//local_Util:ShowCongratulationView(scmd.reward)
				//}
				//}else{
				//let icon = ActivityIconManager.GetInstance().getIconInfo(icon_type)
				//if (! icon ) {
				//ActivityIconManager:GetInstance():addIcon(icon_type)
				//}
				//}
				//welfareModel.xinYue_Data = scmd
				//local_GlobalEventSystem:Fire(local_EventName.REFRESH_ACTIVITY_ICON_RED_DOT, icon_type)
				//welfareModel:Fire(local_WelfareEvent.UPDATE_XINYUE_VIEW)
				//}else{
				//Util.ErrorCodeShow(scmd.code)
				//}
			}

			//////////////////////领取心悦礼包//////////////////////-


			//广告奖励内容
			let Handler19301 = () => {
				let scmd = user_msg_adapter.GetSCMD(19301)
				let reward_list = []
				for (let key in scmd.reward) {

					let info = scmd.reward[key]
					table.insert(reward_list, { "0": info.style, "1": info.typeId, "2": info.count })
				}
				if (reward_list.length > 0) {
					let success_view = new CongratulationObtainView(reward_list, 10)
					success_view.Open()
				}
			}

			let Handler19302 = () => {
				let scmd = user_msg_adapter.GetSCMD(19302)
				welfareModel.SetAdData(scmd.ad_list)
			}

			let Handler19303 = () => {
				let scmd = user_msg_adapter.GetSCMD(19303)
				if (scmd.code != 1) {
					Util.ErrorCodeShow(scmd.code)
				}
			}

			let Handler19304 = () => {
				let scmd = user_msg_adapter.GetSCMD(19304)
				// if (PlatformManager.GetInstance().IsEyouRuPlatform() || PlatformManager.GetInstance().IsEyouBrPlatform() || PlatformManager.GetInstance().IsEyouThPlatform() ) { 
				// 	if ((scmd.mod_id == 610 && (scmd.sub_id == 2 || scmd.sub_id == 18)) ) {
				// 		PlatformManager.GetInstance().SubmitStartCLFBDRAW()
				// 	} else if (scmd.mod_id == 610 && scmd.sub_id == 20 ) {
				// 		PlatformManager.GetInstance().SubmitStartJYFBDRAW()
				// 	} else if (scmd.mod_id == 179 && scmd.sub_id == 1 ) {
				// 		PlatformManager.GetInstance().SubmitStartZYCJDRAW()
				// 	} else if (scmd.mod_id == 416 && scmd.sub_id == 1 ) {
				// 		PlatformManager.GetInstance().SubmitStartZBDBDRAW()
				// 	} else if (scmd.mod_id == 416 && scmd.sub_id == 2 ) {
				// 		PlatformManager.GetInstance().SubmitStartDFDBDRAW()
				// 	} else if (scmd.mod_id == 417 && scmd.sub_id == 1 ) {
				// 		PlatformManager.GetInstance().SubmitStartQDDRAW()
				// 	} else if (scmd.mod_id == 331 && scmd.grade_id ) {
				// 		PlatformManager.GetInstance().SubmitStartGDRAW(scmd.grade_id)
				// 	}
				// } 
			}


			//等级礼包
			this.RegisterProtocal(41700, Handler41700)
			this.RegisterProtocal(41701, Handler41701)

			//每日签到
			this.RegisterProtocal(41703, Handler41703)
			this.RegisterProtocal(41704, Handler41704)
			this.RegisterProtocal(41705, Handler41705)

			//静默下载奖励
			this.RegisterProtocal(41707, Handler41707)
			this.RegisterProtocal(41708, Handler41708)

			//在线福利
			this.RegisterProtocal(41715, Handler41715)
			this.RegisterProtocal(41716, Handler41716)

			//没用的
			this.RegisterProtocal(41717, Handler41717)

			//手机/身份验证
			this.RegisterProtocal(41718, Handler41718)

			//心悦礼包
			this.RegisterProtocal(41719, Handler41719)

			//广告奖励
			this.RegisterProtocal(19301, Handler19301)		//广告奖励内容
			this.RegisterProtocal(19302, Handler19302)		//广告状态
			this.RegisterProtocal(19303, Handler19303)		//开始观看广告
			this.RegisterProtocal(19304, Handler19304)		//通知打点


			welfareModel.Bind(local_WelfareEvent.WELFARE_REQUEST_PROTO, (id, fmt, ...new_args) => {
				this.SendFmtToGame(id, fmt, ...new_args)
			}
			)

			local_GlobalEventSystem.Bind(local_EventName.OPEN_WELFARE_VIEW, (index?) => {
				if (!this.welfare_view) {
					let view = WelfareView
					this.welfare_view = new view()
				}
				if (index) {
					this.welfare_view.SetDefaultIndex(index)
				}
				if (this.welfare_view.HasOpen()) {
					this.welfare_view.Close()
				} else {
					this.welfare_view.Open()
				}
			}
			)

			// local_GlobalEventSystem.Bind(local_EventName.OPEN_SUPER_VIP,() => {
			// 		if (! this.svip_view ) {
			// 			this.svip_view =  new SuperVipWindow()
			// 		}

			// 		if (this.svip_view.HasOpen() ) {
			// 			this.svip_view.Close()
			// 		}else{
			// 			this.svip_view.Open()
			// 		}
			// 	}
			// )

			local_GlobalEventSystem.Bind(local_EventName.GAME_START, () => {
				welfareModel.Reset()
				if (CommonManager.GetInstance().GetWelfareWelcomeOpenState()) {
					welfareModel.Fire(local_WelfareEvent.WELFARE_REQUEST_PROTO, 41719, "c", 3)	//目前英文的新手奖励界面用
				}
				welfareModel.Fire(local_WelfareEvent.WELFARE_REQUEST_PROTO, 41700)
				welfareModel.Fire(local_WelfareEvent.WELFARE_REQUEST_PROTO, 41703)

				welfareModel.Fire(local_WelfareEvent.WELFARE_REQUEST_PROTO, 41707)
				welfareModel.Fire(local_WelfareEvent.WELFARE_REQUEST_PROTO, 41715)
				//welfareModel:GetVerifyStateFormSdk()
				//welfareModel:InitXinYueGift()
				if(welfareModel.GetAdOpenState())
					welfareModel.Fire(local_WelfareEvent.WELFARE_REQUEST_PROTO, 19302)
			}
			)

			local_GlobalEventSystem.Bind(ServerTimeModel.DAY_CHANGE, () => {
				//welfareModel:InitXinYueGift()
				let _id = setTimeout(() => {
					welfareModel.Fire(local_WelfareEvent.WELFARE_REQUEST_PROTO, 41703)
					clearTimeout(_id)
					_id = null
				}, 5)
			}
			)

			RoleManager.GetInstance().GetMainRoleVo().Bind(local_EventName.CHANGE_LEVEL, (level?) => {
				let online_open_lv = welfareModel.GetKvCfg(3)
				if (level == online_open_lv) {
					welfareModel.Fire(local_WelfareEvent.WELFARE_REQUEST_PROTO, 41715)
				}
				welfareModel.RefreshSuperVipRed()
				//welfareModel:InitXinYueGift()
			}
			)

			//每日补给
			let changeRed = (base_type?, sub_type?) => {
				if (base_type == 61 && sub_type == 1) {
					welfareModel.RefreshDailySupplyRed()
				}
			}
			custom_activity_model.Bind(local_CustomActivityDefine.EVENT.UPDATE_VIEW, changeRed)
			custom_activity_model.Bind(local_CustomActivityDefine.EVENT.ANSWER_TARGET, changeRed)

			//已下载量,总更新量,当前更新速度,是否已更新完成
			// var update_resourse_state =(now_size,all_size,speed,isdone)=> {
			// 	welfareModel.SetResourceDownInfo(now_size,all_size,speed,isdone)
			// 	welfareModel.Fire(WelfareEvent.SHOW_DOWN_RES_SPEED,now_size,all_size,speed,isdone)
			// 	if (isdone ) {
			// 		StepPackModule.GetInstance().SetCallbackFunc(null)
			// 	}
			// }
			// StepPackModule.GetInstance().SetCallbackFunc(update_resourse_state)

			// 超级Vip
			let svip_flag = () => {
				let super_vip_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "ConfigSuperVip", true)
				let ans = welfareModel.CheckSuperVipOpenState(super_vip_cfg)
				let icon = activity_icon_mgr.getIconInfo(452)
				if (!icon && ans) {
					//activity_icon_mgr.addIcon(452)
				}
			}
			role_vo.Bind(role_vo, local_EventName.CHANGE_LEVEL, svip_flag)
			welfareModel.Bind(local_WelfareEvent.SHOW_SVIP_ICON, svip_flag)

			// local_GlobalEventSystem.Bind(local_EventName.OPEN_WEFARE_WELCOME_VIEW,() => {
			// 		if (! this.welfare_welcome_view ) {
			// 			this.welfare_welcome_view =  new WelfareWelcomeView()
			// 		}
			// 		this.welfare_welcome_view.Open()
			// 	}
			// )
		}

		this.InitInfo()
	}
}

window["WelfareController"] = WelfareController