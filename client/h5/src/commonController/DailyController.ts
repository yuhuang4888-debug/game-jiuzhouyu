import { BaseController } from "../common/BaseController"
import { BaseView1 } from "../common/BaseView1"
import { CongratulationObtainView } from "../common/CongratulationObtainView"
import { EventName } from "../common/EventName"
import { UserMsgAdapter } from "../common/UserMsgAdapter"
import { DailyModel, ActivityType } from "../commonModel/DailyModel"
import { DailyEvent } from "../daily/DailyEvent"
import { RoleManager } from "../commonModel/RoleManager"
import { SceneManager } from "../scene/SceneManager"
import { Message } from "../sysInfo/SysInfoController"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { Util } from "../util/Util"
import { Config } from "../common/Config"


import "../daily/DailyView";
import "../daily/DailyLimitActivityTipsView";
import "../daily/DailyLivenessMsgView";
import "../daily/DailyCalendarView";
import "../daily/DailyResFindTipsView";
import "../daily/DailyReservationView";
import "../daily/DailyActTipView"

import { ResManager } from "../common/ResManager"
import { WeekCardModel } from "../commonModel/WeekCardModel"
import { table } from "../common/table"
import { ViewPopLevelModel, ViewPopLevelModelEvent } from "../commonModel/ViewPopLevelModel"
import { ActivityForeshowManager } from "../commonModel/ActivityForeshowManager"
import { ItemUseModel } from "../commonModel/ItemUseModel"




export class DailyController extends BaseController {
	InitEvent
	InitInfo
	model
	obtain_view
	public view_dic = {}
	static Instance: any

	public constructor() {
		super()

		this.model = DailyModel.GetInstance();
		this.view_dic = [];
		let local_DailyEvent = DailyEvent
		let request_proto = local_DailyEvent.DAILY_REQUEST_PROTO
		let local_GlobalEventSystem = GlobalEventSystem
		let local_EventName = EventName
		let local_ActivityType = ActivityType
		let user_msg_adapter = UserMsgAdapter.GetInstance()
		let local_Message = Message
		let local_Util = Util
		this.InitEvent = async () => {
			this.model.Bind(request_proto, (id, fmt, ...new_args) => {
				this.SendFmtToGame(id, fmt, ...new_args)
			}
			)

			this.model.Bind(local_DailyEvent.RES_FIND_REQUEST_PROTO, (...new_args) => {
				let params = new_args
				this.SendFmtToGame(params[0], params[1], params[2], params[3], params[4], params[5], params[6])
			})

			this.model.Bind(local_DailyEvent.OPEN_VIEW, (view_name: string, ...new_args) => {
				let view = this.view_dic[view_name]
				if (!view) {
					let view_class = window[view_name]
					if (view_class) {
						view = new view_class()
						this.view_dic[view_name] = view
					}
				}
				if (view) {
					if (view.HasOpen() && view_name == "DailyView") {
						this.model.Fire(local_DailyEvent.DAILY_SWTICH_VIEW, ...new_args)
					} else {
						let res = view.Open(...new_args)
					}
				}
			}
			)

			this.model.Bind(local_DailyEvent.DAILY_CLOSE_VIEW, (view_name, ...new_args) => {
				let view = this.view_dic[view_name]
				if ((view && view.HasOpen())) {
					view.Close()
				}
				this.view_dic[view_name] = null
			}
			)

			let refresh_time_id
			local_GlobalEventSystem.Bind(local_EventName.GAME_START, async () => {
				this.model.ResetData()
				this.model.Fire(request_proto, 15701, "c", local_ActivityType.UnLimit)
				this.model.Fire(request_proto, 15701, "c", local_ActivityType.Limit)
				this.model.Fire(request_proto, 15703)
				this.model.Fire(request_proto, 41900)
				this.model.Fire(request_proto, 15709)

				ActivityForeshowManager.GetInstance().is_pop_tip=false
				this.model.Fire(request_proto, 15721)
				if (RoleManager.GetInstance().mainRoleInfo.level >= DailyModel.LivenessFindOpenLevel) {
					this.model.Fire(request_proto, 15715)
				}
				if (refresh_time_id) {
					clearTimeout(refresh_time_id)
				}

				this.model.Fire(request_proto, 15718)

				//活动预告
				this.Fire(local_DailyEvent.CONFIG_IS_LOAD)
			}
			)
			this.model.Bind(local_DailyEvent.REQUEST_STRONGER_DATA, () => {
				this.SendFmtToGame(61801)
			}
			)
			let show_tuo_guan_guide_fun = () => {
				//if (this.model.need_tuo_guan_guide && SceneManager.GetInstance().IsFieldScene() ) { 
				//let step = [direction = 6, text= "别忘了来托管中心看看\n离线也能获得收益哦~", force_show_img = 1]
				//GlobalEventSystem:Fire(EventName.ACTIVITY_ICON_FINGER, true, DailyModel.DailyIconType, step)
				//}
			}

			RoleManager.GetInstance().GetMainRoleVo().Bind(EventName.CHANGE_LEVEL, (level?) => {
				this.model.Fire(request_proto, 15721)
				//if (level == DailyModel.TuoGuanGuideLevel ) { 
				//this.model.need_tuo_guan_guide = true
				//show_tuo_guan_guide_fun()
				//}
			})
			// GlobalEventSystem.Bind(EventName.SCENE_LOAD_VIEW_COMPLETE, show_tuo_guan_guide_fun)
			GlobalEventSystem.Bind(SceneManager.START, show_tuo_guan_guide_fun)
		}

		this.InitInfo = () => {
			let Handler15700 = () => {
				let scmd = user_msg_adapter.GetSCMD(15700)
				Util.ErrorCodeShow(scmd.errcode)
			}

			let Handler15701 = () => {
				let scmd = user_msg_adapter.GetSCMD(15701)
				this.model.SetDailyData(scmd)
				if (scmd.act_type == ActivityType.UnLimit) {
					this.model.CheckDailyTaskRed()
				}
				this.model.ShowRedDot()
			}

			let Handler15703 = () => {
				let scmd = user_msg_adapter.GetSCMD(15703)
				this.model.SetLivenessReward(scmd)
				this.model.ShowRedDot()
			}

			let Handler15705 = () => {
				let scmd = user_msg_adapter.GetSCMD(15705)
				if (scmd.errcode == 1) {
					local_Message.show("领取奖励成功")
					this.model.Fire(request_proto, 15703)
					ResManager.GetInstance().LoadGameConfig(this, "config_activity_reward", false, undefined, (obj) => {
						let reward_list = this.model.GetBoxRewardListById(scmd.id, obj)
						if (WeekCardModel.GetInstance().GetWeekCardData().is_activity == 1) {
							let reward = Util.DeepCopy(reward_list[0])
							reward[3] = null
							reward[4] = true
							table.insert(reward_list, reward)
						}
						if (reward_list) {
							this.obtain_view = new CongratulationObtainView(reward_list, 10)
							this.obtain_view.Open()
						}
						ResManager.GetInstance().DestoryGameConfig(this, "config_activity_reward", false)
					})

				} else {
					Util.ErrorCodeShow(scmd.errcode)
				}
			}

			let Handler15706 = () => {
				let scmd = user_msg_adapter.GetSCMD(15706)
				this.model.UpdateDailyData(scmd)
				if(ViewPopLevelModel.GetInstance().CheckViewIsPoping("DailyActTipView")){
					this.SendFmtToGame(15721)
				}
			}

			let Handler41900 = () => {
				let scmd = user_msg_adapter.GetSCMD(41900)
				if (scmd.errcode == 1) {
					this.model.SetResFindData(scmd.res_act)
					this.model.ShowRedDot()
				} else {
					Util.ErrorCodeShow(scmd.errcode)
				}
			}

			let Handler41903 = () => {
				let scmd = user_msg_adapter.GetSCMD(41903)
				if (scmd.errcode == 1) {
					local_Message.show("找回成功")
					this.model.Fire(local_DailyEvent.RES_FIND_SUCCESS)
					this.model.ShowReward(scmd)
					this.model.UpdateFindData(scmd)
				} else {
					if (scmd.errcode == 4190001) {
						this.model.Fire(request_proto, 41900)
					} else {
						Util.ErrorCodeShow(scmd.errcode)
					}
				}
			}

			let Handler41904 = () => {
				let scmd = user_msg_adapter.GetSCMD(41904)
				if (scmd.errcode == 1) {
					this.model.SetAllResFindData(scmd.act_list)
					this.model.ShowAllReward(scmd.type)
					this.model.Fire(request_proto, 41900)
				} else {
					Util.ErrorCodeShow(scmd.errcode)
				}
			}

			let Handler15709 = () => {
				let scmd = user_msg_adapter.GetSCMD(15709)
				this.model.SetLivenessImageData(scmd)
				this.model.ShowRedDot()
			}

			let Handler15710 = () => {
				let scmd = user_msg_adapter.GetSCMD(15710)
				if (scmd.errcode == 1) {
					this.model.Fire(local_DailyEvent.LIVENESS_UPGRDE_SUCCESS)
					this.model.Fire(request_proto, 15709)
				} else {
					Util.ErrorCodeShow(scmd.errcode)
				}
			}

			let Handler15711 = () => {
				let scmd = user_msg_adapter.GetSCMD(15711)
				if (scmd.errcode == 1) {
					local_Message.show("幻化成功")
					this.model.Fire(request_proto, 15709)
				} else {
					Util.ErrorCodeShow(scmd.errcode)
				}
			}

			let Handler15712 = () => {
				let scmd = user_msg_adapter.GetSCMD(15712)
				let role_vo = SceneManager.GetInstance().GetRoleVo(scmd.role_id)
				if (role_vo) {
					role_vo.ChangeVar("liveness_id", scmd.figure_id)
				}
			}

			let Handler15714 = () => {
				let scmd = user_msg_adapter.GetSCMD(15714)
				this.model.outline_info = scmd.time
				this.model.Fire(local_DailyEvent.UPDATE_OUTLINE_INFO, scmd.time)
				this.model.ShowRedDot()
			}

			let Handler15715 = () => {
				let scmd = user_msg_adapter.GetSCMD(15715)
				this.model.SetHuoYueDuData(scmd.res_act)
				this.model.ShowRedDot()
			}

			let Handler15716 = () => {
				let scmd = user_msg_adapter.GetSCMD(15716)
				local_Message.show("找回成功")
				this.model.Fire(request_proto, 15715)
			}

			let Handler15717 = () => {
				let scmd = user_msg_adapter.GetSCMD(15717)
				local_Message.show("领取成功")
				this.model.Fire(request_proto, 15701, "c", local_ActivityType.UnLimit)
				this.model.Fire(request_proto, 15703)
			}

			let Handler61801 = () => {
				let scmd = user_msg_adapter.GetSCMD(61801)
				this.model.setStrongerData(scmd)
			}


			let Handler15720 = () => {
				let scmd = user_msg_adapter.GetSCMD(15720)
				if (scmd.code == 1) {
					let key = `${scmd.module}@${scmd.module_sub}@${scmd.ac_sub}`
					let cfg = Config.PRELOAD_SERVER_CONFIG.config_ac[key]
					if (cfg) {
						let reward_data = JSON.parse(cfg.sign_up_reward)
						if (reward_data && reward_data.length > 0) {
							let view = new CongratulationObtainView(reward_data, 10)
							view.Open()
						}

					}
					this.model.SetReservationState(scmd.module, scmd.module_sub, scmd.ac_sub, 2)
					this.model.ShowRedDot()
					this.model.Fire(local_DailyEvent.UPDATE_DAILY_DATA)
				} else {
					Util.ErrorCodeShow(scmd.code)
				}
			}

			let Handler15721 = () => {
				let scmd = user_msg_adapter.GetSCMD(15721)
				let [have_new, new_mod] = this.model.HasNewAct(scmd)
				if(!ViewPopLevelModel.GetInstance().CheckViewIsPoping("DailyActTipView")){
					if (scmd.is_remind && scmd.act_list && Util.TableSize(scmd.act_list) > 0 && have_new) {
						this.model.SetDailyActData(scmd)
						ViewPopLevelModel.GetInstance().SetSpacialView('DailyActTipView',true,new_mod)
						// ViewPopLevelModel.GetInstance().SetView('DailyActTipView', new_mod);
					}
	
					if(!scmd.is_remind){
						ActivityForeshowManager.GetInstance().is_pop_tip=true
						let act = ActivityForeshowManager.GetInstance().is_need_pop_act
						if(act){
							ViewPopLevelModel.GetInstance().SetView('ForeshowStarTipsView', act, true);
							ActivityForeshowManager.GetInstance().is_need_pop_act=null
						}
					}
				}else{
					//界面打开的时候更新页面
					if (scmd.is_remind && scmd.act_list && Util.TableSize(scmd.act_list) > 0) {
						// scmd.act_list[0].state=1  测试代码
						this.model.SetDailyActData(scmd)
						this.model.Fire(local_DailyEvent.DAILY_UPDATE_ORDER_VIEW,new_mod)
					}else{
						//关闭界面
						GlobalEventSystem.Fire(EventName.CLOSE_VIEW, "DailyActTipView");
					}
					
				}

				ViewPopLevelModel.GetInstance().SetSpacialView('DailyActTipView',false)
			}
			this.RegisterProtocal(15721, Handler15721)

			let Handler15722 = () => {
				let scmd = user_msg_adapter.GetSCMD(15722)

			}
			this.RegisterProtocal(15722, Handler15722)


			this.RegisterProtocal(15700, Handler15700)
			this.RegisterProtocal(15701, Handler15701)
			this.RegisterProtocal(15703, Handler15703)
			this.RegisterProtocal(15705, Handler15705)
			this.RegisterProtocal(15706, Handler15706)
			this.RegisterProtocal(15709, Handler15709)
			this.RegisterProtocal(15710, Handler15710)
			this.RegisterProtocal(15711, Handler15711)
			this.RegisterProtocal(15712, Handler15712)
			this.RegisterProtocal(15714, Handler15714)
			this.RegisterProtocal(15715, Handler15715)
			this.RegisterProtocal(15716, Handler15716)
			this.RegisterProtocal(15717, Handler15717)
			this.RegisterProtocal(41900, Handler41900)
			this.RegisterProtocal(41903, Handler41903)
			this.RegisterProtocal(41904, Handler41904)
			this.RegisterProtocal(61801, Handler61801)
			this.RegisterProtocal(15718, () => {
				let scmd = user_msg_adapter.GetSCMD(15718)
				if (scmd) {
					this.model.SetResData(scmd.act_list, true)
				}
			}
			)
			this.RegisterProtocal(15719, () => {
				let scmd = user_msg_adapter.GetSCMD(15719)
				if (scmd) {
					if (scmd.code == 1) {
						this.model.SetResData(scmd, false)
						this.model.Fire(local_DailyEvent.DAILY_ORDER_SUCCESS, scmd.module, scmd.module_sub, scmd.ac_sub, scmd.status)
						if (scmd.status != 2) {
							this.model.Fire(local_DailyEvent.OPEN_VIEW, "DailyReservationView", scmd)
						}

					} else {
						Util.ErrorCodeShow(scmd.code)
					}
				}
			}
			)

			this.RegisterProtocal(15720, Handler15720)
		}

		this.InitInfo()
		this.InitEvent()
	}

	public static GetInstance() {
		if (!DailyController.Instance) {
			DailyController.Instance = new DailyController()
		}
		return DailyController.Instance
	}

}


window["DailyController"] = DailyController