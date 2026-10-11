
//require("game.proto.490.Require490")
//require("game.surpriseGift.DrawBtnRerderer")
//require("game.surpriseGift.DrawItem")
//require("game.surpriseGift.DrawView")
//require("game.surpriseGift.GiftView")
//require("game.surpriseGift.SurpriseGiftBaseView")
//require("game.surpriseGift.SurpriseGiftItem")
//require("game.surpriseGift.SurpriseGiftMainView")
//require("game.surpriseGift.SurpriseGiftModel")

import { BaseController } from "../common/BaseController"
import { EventName } from "../common/EventName"
import { UserMsgAdapter } from "../common/UserMsgAdapter"
import { ActivityIconManager } from "../commonModel/ActivityIconManager"
import { RoleManager } from "../commonModel/RoleManager"
import { SurpriseGiftModel } from "../commonModel/SurpriseGiftModel"
import { ServerTimeModel } from "../serverTime/ServerTimeModel"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { Util } from "../util/Util"
import { RoleController } from "./RoleController"
import "../surpriseGift/SurpriseGiftBaseView"

export class SurpriseGiftController extends BaseController {
	InitEvent
	InitInfo
	public constructor() {
		super()


		let model = SurpriseGiftModel.GetInstance()
		let local_SurpriseGiftModel = SurpriseGiftModel
		let activity_icon_mgr = ActivityIconManager.GetInstance()
		let local_GlobalEventSystem = GlobalEventSystem
		let local_EventName = EventName
		let role_mgr = RoleManager.GetInstance()

		let user_msg_adapter = UserMsgAdapter.GetInstance()
		let view_dic_ = []
		this.InitEvent = () => {
			// let update = () => {
			// 	//model:LoadConfig()
			// 	if (model.getOpenStatus()) {
			// 		model.Fire(local_SurpriseGiftModel.SCMD_REQUEST, 49000)
			// 		activity_icon_mgr.addIcon(490)
			// 	}
			// }
			let game_start = () => {
				 model.LoadConfig()
			}

			local_GlobalEventSystem.Bind(local_EventName.GAME_START, game_start)
			local_GlobalEventSystem.Bind(ServerTimeModel.DAY_CHANGE, game_start)
			role_mgr.GetMainRoleVo().Bind(local_EventName.CHANGE_LEVEL, game_start)
			role_mgr.GetMainRoleVo().BindOne("vip_flag", game_start)
			//local_GlobalEventSystem:Bind(local_EventName.INIT_CONFIG,() => {

			//}
			//)
			let vip_flag = () => {
				if (!RoleController.GetInstance().first_receive_13001) {
					if (model.getOpenStatus()) {
						model.Fire(local_SurpriseGiftModel.SCMD_REQUEST, 49000)
						activity_icon_mgr.addIcon(490)
					}
				}
			}

			role_mgr.GetMainRoleVo().Bind("vip_flag", vip_flag)
			let scmd_request = (scmd, ...new_args) => {
				let prams = new_args
				if (49001 == scmd) {
					this.SendFmtToGame(scmd, "i", prams[0])
				} else if (49003 == scmd) {
					this.SendFmtToGame(scmd, "i", prams[0])
				} else{
					this.SendFmtToGame(scmd)
				}
			}

			model.Bind(local_SurpriseGiftModel.SCMD_REQUEST, scmd_request)
			let open_view = (view_name?: string) => {
				if (!model.getOpenStatus(true)) {
					return
				}
				if (view_name) {
					// [ts2lua]view_dic_下标访问可能不正确
					let view = view_dic_[view_name]
					if (!view) {
						// [ts2lua]view_dic_下标访问可能不正确
						view_dic_[view_name] = true
						// [ts2lua]window下标访问可能不正确

						if (view_dic_[view_name]) {
							// [ts2lua]window下标访问可能不正确
							let view_class = window[view_name]
							view = new view_class()
							// [ts2lua]view_dic_下标访问可能不正确
							view_dic_[view_name] = view
						}
					}
					if (view) {
						view.Open()
					}
				}
			}

			model.Bind(local_SurpriseGiftModel.OPEN_VIEW, open_view)
		}

		this.InitInfo = () => {
			let On49000 = () => {
				let scmd = user_msg_adapter.GetSCMD(49000)
				if (scmd.code != 1) {
					Util.ErrorCodeShow(scmd.code)
					return
				}
				model.CheckFinshAllDraw(scmd)
				model.SetViewInfo(scmd)
				model.RefRedNum()
				model.Fire(local_SurpriseGiftModel.UPDATA_VIEW, scmd)
				model.Fire(local_SurpriseGiftModel.REF_TAB_RED)
				let state = model.CheckRed()
				local_GlobalEventSystem.Fire(local_EventName.REFRESH_ACTIVITY_ICON_RED_DOT, 490, state)
			}

			let On49001 = () => {
				let scmd = user_msg_adapter.GetSCMD(49001)
				if (scmd.code != 1) {
					Util.ErrorCodeShow(scmd.code)
					return
				}
				model.Fire(local_SurpriseGiftModel.SCMD_REQUEST, 49000)
				model.Fire(local_SurpriseGiftModel.BUY_SUCCESS, scmd.gift_id)
			}

			let On49002 = () => {
				let scmd = user_msg_adapter.GetSCMD(49002)
				if (scmd.code != 1) {
					Util.ErrorCodeShow(scmd.code)
					return
				}
				model.UpdataViewInfo(scmd)
				model.RefRedNum()
				let state = model.CheckRed()
				local_GlobalEventSystem.Fire(local_EventName.REFRESH_ACTIVITY_ICON_RED_DOT, 490, state)
				model.Fire(local_SurpriseGiftModel.REF_TAB_RED)
				model.Fire(local_SurpriseGiftModel.DRAW_SUCCESS, scmd)
			}

			let On49003 = () => {
				let scmd = user_msg_adapter.GetSCMD(49003)
				if (scmd.code != 1) {
					Util.ErrorCodeShow(scmd.code)
					return
				}
				model.UpdataViewInfo(scmd)
				model.RefRedNum()
				let state = model.CheckRed()
				local_GlobalEventSystem.Fire(local_EventName.REFRESH_ACTIVITY_ICON_RED_DOT, 490, state)
				model.Fire(local_SurpriseGiftModel.REF_TAB_RED)
				model.Fire(local_SurpriseGiftModel.GET_SUCCESS, scmd.gift_id)
			}

			let On49004 = () => {
				let scmd = user_msg_adapter.GetSCMD(49004)
				let info = model.GetViewInfo()
				if (!info) {
					return
				}
				info.free_draw_times = scmd.free_draw_times
				info.add_draw_times = scmd.add_draw_times
				info.use_free_times = scmd.use_free_times
				info.day_task_list = scmd.day_task_list
				model.SetViewInfo(info)
				model.RefRedNum()
				let state = model.CheckRed()
				local_GlobalEventSystem.Fire(local_EventName.REFRESH_ACTIVITY_ICON_RED_DOT, 490, state)
				model.Fire(local_SurpriseGiftModel.REF_TAB_RED)
				model.Fire(local_SurpriseGiftModel.UPDATA_VIEW)
			}

			this.RegisterProtocal(49000, On49000)
			this.RegisterProtocal(49001, On49001)
			this.RegisterProtocal(49002, On49002)
			this.RegisterProtocal(49003, On49003)
			this.RegisterProtocal(49004, On49004)
		}

		this.InitInfo()
		this.InitEvent()
	}
}