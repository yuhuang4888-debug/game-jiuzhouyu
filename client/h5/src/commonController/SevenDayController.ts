import { BaseController } from "../common/BaseController"
import { SevenDayModel } from "../commonModel/SevenDayModel"
import { GlobalEventSystem, LOAD_QUEUE } from "../util/DeclareGlobalVar"
import { EventName } from "../common/EventName"
import { CommonManager } from "../common/CommonManager"
import { ActivityIconManager } from "../commonModel/ActivityIconManager"
import { UserMsgAdapter } from "../common/UserMsgAdapter"
import { ServerTimeModel } from "../serverTime/ServerTimeModel";
import { RoleManager } from "../commonModel/RoleManager"
import { TaskModel } from "../commonModel/TaskModel"
import { ResManager } from "../common/ResManager"
import { Split, Util } from "../util/Util"
import "../sevenDay/SevenDayView"
import "../sevenDay/SevenEightDayView"
import { Message } from "../sysInfo/SysInfoController"
import "../sevenMergeDay/SevenMergeView"



export class SevenDayController extends BaseController {
	InitInfo

	public constructor() {
		super()


		let model = SevenDayModel.GetInstance()
		let local_GlobalEventSystem = GlobalEventSystem
		let local_EventName = EventName
		let common_mgr = CommonManager.GetInstance()
		let activity_icon_mgr = ActivityIconManager.GetInstance()
		let local_SevenDayModel = SevenDayModel

		let user_msg_adapter = UserMsgAdapter.GetInstance()
		let sevenDay_view_ = null
		let view_dic_ = []
		this.InitInfo = () => {
			let game_start = () => {
				this.SendFmtToGame(17500)
				this.SendFmtToGame(17502)
			}

			local_GlobalEventSystem.Bind(local_EventName.GAME_START, game_start)
			local_GlobalEventSystem.Bind(ServerTimeModel.DAY_CHANGE, game_start)
			let LevelChange = (level?) => {
				let icon = "175_1"
				let cfg = common_mgr.GetFunctionIconCfg(icon)
				let icon_ifno = activity_icon_mgr && activity_icon_mgr.getIconInfo(icon) || activity_icon_mgr.getBoxIconInfo(icon)
				let lv0 = cfg.open_lv || cfg.attach_open_lv
				if ((cfg && lv0 >= level) && !icon_ifno) {
					this.SendFmtToGame(17502)
				}
				icon = "175"
				cfg = common_mgr.GetFunctionIconCfg(icon)
				icon_ifno = activity_icon_mgr && activity_icon_mgr.getIconInfo(icon) || activity_icon_mgr.getBoxIconInfo(icon)
				let lv = cfg.open_lv || cfg.attach_open_lv
				if ((cfg && lv >= level) && !icon_ifno) {
					this.SendFmtToGame(17500)
				}
			}

			RoleManager.GetInstance().GetMainRoleVo().Bind(local_EventName.CHANGE_LEVEL, LevelChange)
			let task_change = (task_id?) => {
				let cfg = common_mgr.GetFunctionIconCfg("175")
				if (cfg && cfg.open_task_id == task_id) {
					this.SendFmtToGame(17500)
				}
			}

			GlobalEventSystem.Bind(EventName.UPDATE_NEWEST_TASK_ID, task_change)
			let open_view = (icontype?) => {
				let view_name: string = null
				if (!icontype) {
					icontype = "175"
				}
				// if (icontype != "175"){
				// 	Message.show("未开发")
				// 	return
				// }
				let type = local_SevenDayModel.iconToType[icontype]
				view_name = local_SevenDayModel.typeToView[type]
				if (view_name) {
					let view = view_dic_[view_name]
					if (!view) {
						view_dic_[view_name] = true
						if (!window[view_name]) {
							if (!ResManager.GetInstance().IsJsLoad("sevenDay")) {

							}
						}
						if (view_dic_[view_name] == true) {
							let view_class = window[view_name]
							view = new view_class()
							view_dic_[view_name] = view
						}
					}
					if (view) {
						view.SetType(type)
						view.Open()
					}
				}
			}

			local_GlobalEventSystem.Bind(local_EventName.OPEN_SEVENDAY_VIEW, open_view)

			let frist_open_view = () => {
				for (let key in local_SevenDayModel.icon) {

					let arr = Split(key, "@") //key:split("@")
					let icon = local_SevenDayModel.icon[key]
					if (model.GetOpenType(arr[0]) != key) {
						if (activity_icon_mgr && activity_icon_mgr.getIconInfo(icon) || activity_icon_mgr.getBoxIconInfo(icon)) {
							GlobalEventSystem.Fire(EventName.REFRESH_ACTIVITY_ICON_RED_DOT, icon, false)
							activity_icon_mgr.deleteIcon(icon)
						}
					} else if (model.GetOpenType(arr[0]) == key) {
						if (activity_icon_mgr && !activity_icon_mgr.getIconInfo(icon) && !activity_icon_mgr.getBoxIconInfo(icon)) {
							activity_icon_mgr.addIcon(icon)
							if (Number(arr[1]) > 0) {
								let info = model.GetInfoByOpenType(arr[0], arr[1])
								let day = info.current_day == (model.limit_day - 1)
								if (day) {
									local_GlobalEventSystem.Fire(ActivityIconManager.SET_ICON_TEXT, icon, "明天可领")
								}
							}
						}
					}
				}
			}

			model.Bind(local_SevenDayModel.REF_SEVENDAY_ICON, frist_open_view)

			let request_func = (scmd, ...new_args) => {
				if (scmd == 17501 || scmd == 17503) {
					this.SendFmtToGameImme(scmd, "c", ...new_args)
				}
			}
			model.Bind(local_SevenDayModel.REQUEST_SCMD, request_func)

			let On17500 = () => {
				let scmd = user_msg_adapter.GetSCMD(17500)
				if (scmd.errcode != 1) {
					Util.ErrorCodeShow(scmd.errcode)
					return
				}
				scmd["type"] = local_SevenDayModel.act_type.open
				model.SetSevenDayInfo(scmd)
				model.Fire(local_SevenDayModel.REF_SEVENDAY_ICON)
				model.RefIconRed(local_SevenDayModel.act_type.open)
			}

			this.RegisterProtocal(17500, On17500)
			let On17501 = () => {
				let scmd = user_msg_adapter.GetSCMD(17501)
				if (scmd.errcode != 1) {
					Util.ErrorCodeShow(scmd.errcode)
					return
				}
				model.UpdateRawardStatus(scmd.day_id, local_SevenDayModel.act_type.open)
				model.GetRewardList(scmd)
				model.RefIconRed(local_SevenDayModel.act_type.open)
				model.Fire(local_SevenDayModel.UPDATE_VIEW, local_SevenDayModel.act_type.open)
			}

			this.RegisterProtocal(17501, On17501)
			let On17502 = () => {
				let scmd = user_msg_adapter.GetSCMD(17502)
				if (scmd.errcode != 1) {
					return
				}
				// [ts2lua]scmd下标访问可能不正确
				scmd["type"] = local_SevenDayModel.act_type.merge
				model.SetSevenDayInfo(scmd)
				model.Fire(local_SevenDayModel.REF_SEVENDAY_ICON)
				model.RefIconRed(local_SevenDayModel.act_type.merge)
			}

			this.RegisterProtocal(17502, On17502)
			let On17503 = () => {
				let scmd = user_msg_adapter.GetSCMD(17503)
				if (scmd.errcode != 1) {
					Util.ErrorCodeShow(scmd.errcode)
					return
				}
				model.UpdateRawardStatus(scmd.day_id, local_SevenDayModel.act_type.merge)
				model.GetRewardList(scmd)
				model.RefIconRed(local_SevenDayModel.act_type.merge)
				model.Fire(local_SevenDayModel.UPDATE_VIEW, local_SevenDayModel.act_type.merge)
			}

			this.RegisterProtocal(17503, On17503)
		}

		this.InitInfo()
	}
}

window["SevenDayController"] = SevenDayController