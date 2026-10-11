
import { BaseController } from "../common/BaseController"
import { EventName } from "../common/EventName"
import { UserMsgAdapter } from "../common/UserMsgAdapter"
import { OutWardBaseModel } from "../commonModel/OutWardBaseModel"
import { TempleAwakenModel, TempleAwakenEvent } from "../commonModel/TempleAwakenModel"
import { LoginModel } from "../login/LoginModel"
import { SceneManager } from "../scene/SceneManager"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { Util } from "../util/Util"

import "../commonModel/TempleAwakenModel"
import "../templeAwaken/TempleAwakenBaseView"
import "../templeAwaken/TempleAwakenEnterView"
import "../templeAwaken/TempleAwakenItem"
import "../templeAwaken/TempleAwakenMainView"
import { MainUIModel } from "../commonModel/MainUIModel"
import { table } from "../common/table"
import { CookieWrapper } from "../common/CookieWrapper"

export class TempleAwakenController extends BaseController {
	InitInfo

	public constructor() {
		super()


		this.InitInfo = () => {
			let model = TempleAwakenModel.GetInstance()
			let local_GlobalEventSystem = GlobalEventSystem
			let local_EventName = EventName
			let request_proto_event = TempleAwakenEvent.REQUEST_PROTO
			let user_msg_adapter = UserMsgAdapter.GetInstance()
			local_GlobalEventSystem.Bind(local_EventName.GAME_START, () => {
				model.Fire(request_proto_event, 42901)
				model.Fire(request_proto_event, 42909)
				model.SetLastChapter()
			}
			)
			model.Bind(request_proto_event, (id, fmt, ...new_args) => {
				this.SendFmtToGame(id, fmt, ...new_args)
			})


			// local_GlobalEventSystem.Bind(
			// 	local_EventName.HIDE_OR_SHOW_AWAKEN_CANVAS_LAYER, (bool?) => {
			// 		LoginModel.GetInstance().hide_or_show_canvas_layer = bool
			// 		panelMgr.GetParent("SceneContainer").visible = bool
			// 		panelMgr.GetParent("SceneObjContainer").visible = bool
			// 		UiFactory.GetSceneCanvas().visible = bool
			// 		panelMgr.GetParent("NameBoard").visible = bool
			// 		panelMgr.GetParent("Dynamic_NameBoard").visible = bool
			// 		//panelMgr:GetParent("UI").visible = bool 
			// 		panelMgr.GetParent("Activity").visible = bool
			// 		panelMgr.GetParent("Main").visible = bool
			// 		//LuaViewManager:GetInstance():Fire(LuaViewManager.CHANGE_MAIN_CANVAS_VISIBLE, "login_view", bool)
			// 		//if (bool ) {
			// 		//BaseController.is_delay_send_protocal = false
			// 		//GlobalEventSystem:Fire(EventName.INIT_MAINUI_EVENT)
			// 		//}
			// 	}
			// )

			// local_GlobalEventSystem.Bind(local_EventName.SCENELOADVIEWE_CLOSE, () => {
			// 	if (SceneManager.GetInstance().IsTempleAwakenScene()) {
			// 		GlobalEventSystem.Fire(EventName.OPEN_VIEW, "TempleAwakeReadyView")

			// 	}
			// })



			GlobalEventSystem.Bind(EventName.CHANGE_ACCOUNT, () => {
				MainUIModel.GetInstance().is_popped=false
			})

			GlobalEventSystem.Bind(EventName.CHANGE_ROLE, () => {
				MainUIModel.GetInstance().is_popped=false
			})



			let Handle42900 = () => {
				let scmd = user_msg_adapter.GetSCMD(42900)
				if (scmd.error_code == 1) {
					model.Fire(request_proto_event, 42901)
				} else {
					Util.ErrorCodeShow(scmd.error_code)
				}
			}
			let Handle42901 = () => {
				let scmd = user_msg_adapter.GetSCMD(42901)
				model.SetTaskComplete(scmd.task_complete)
				model.SaveUnlockInfo(scmd.list)
				model.Fire(TempleAwakenEvent.UPDATE_VIEW)
			}
			let Handle42902 = () => {
				let scmd = user_msg_adapter.GetSCMD(42902)
				model.UpdateUnlockInfo(scmd)
				model.Fire(TempleAwakenEvent.UPDATE_VIEW)
			}
			let Handle42903 = () => {
				let scmd = user_msg_adapter.GetSCMD(42903)
				model.UpdateMainChapterInfo(scmd)
				model.Fire(request_proto_event, 42902, "h", scmd.chapter)
			}
			let Handle42904 = () => {
				let scmd = user_msg_adapter.GetSCMD(42904)
				model.UpdateSubChapterInfo(scmd)
				model.Fire(TempleAwakenEvent.UPDATE_VIEW)
			}
			let Handle42905 = () => {
				let scmd = user_msg_adapter.GetSCMD(42905)
				model.UpdateSubChapterTaskInfo(scmd)
				model.Fire(TempleAwakenEvent.UPDATE_VIEW)
			}
			let Handle42906 = () => {
				let scmd = user_msg_adapter.GetSCMD(42906)
				if (scmd.error_code != 1) {
					Util.ErrorCodeShow(scmd.error_code)
				} else {
					//let cfg = Config.Templeawakensuit

					let data = {
						_type: scmd.chapter,
						isFirst: false,
						cb: () => {
							model.Fire(TempleAwakenEvent.REQUEST_PROTO, 42908, "hc", scmd.chapter, 1)
						}
					}
					OutWardBaseModel.GetInstance().Fire(OutWardBaseModel.OPEN_VIEW, "OutwardChangedView", data)
					model.Fire(request_proto_event, 42901)
				}
			}
			let Handle42907 = () => {
				let scmd = user_msg_adapter.GetSCMD(42907)
				if (scmd.error_code != 1) {
					Util.ErrorCodeShow(scmd.error_code)
				} else {
					model.ShowReward(scmd.chapter, scmd.sub_chapter, scmd.stage)
					model.UpdateTaskInfo(scmd.chapter, scmd.sub_chapter, scmd.stage)
					//model:Fire(request_proto_event, 42902,"h",scmd.chapter)
					model.Fire(TempleAwakenEvent.UPDATE_TASK_ITEM, scmd.chapter, scmd.sub_chapter, scmd.stage)
					let receive_all = model.ReceiveNowChapterAll(scmd.chapter)
					if (receive_all) {
						model.Fire(request_proto_event, 42906, "h", scmd.chapter)
						return
					}
					if (model.ReceiveNowSubChapterAll()) {
						model.Fire(request_proto_event, 42901)
					}
				}
			}
			let Handle42908 = () => {
				let scmd = user_msg_adapter.GetSCMD(42908)
				if (scmd.errcode != 1) {
					Util.ErrorCodeShow(scmd.errcode)
				} else {
					model.SetWearInfo(scmd.chapter, scmd.is_wear)
					model.Fire(TempleAwakenEvent.UPDATE_WEAR_STAGE)
				}
			}
			let Handle42909 = () => {
				let scmd = user_msg_adapter.GetSCMD(42909)
				model.SetFrontTaskComplete(scmd.is_finish)
			}

			//功能性弹窗
			let Handle10211 = () => {
				let scmd = user_msg_adapter.GetSCMD(10211)
				if (scmd) {
					MainUIModel.GetInstance().Fire(MainUIModel.SHOW_FUNC_BOARD_VIEW, scmd,429)
				}
			}

			this.RegisterProtocal(42900, Handle42900)
			this.RegisterProtocal(42901, Handle42901)
			this.RegisterProtocal(42902, Handle42902)
			this.RegisterProtocal(42903, Handle42903)
			this.RegisterProtocal(42904, Handle42904)
			this.RegisterProtocal(42905, Handle42905)
			this.RegisterProtocal(42906, Handle42906)
			this.RegisterProtocal(42907, Handle42907)
			this.RegisterProtocal(42908, Handle42908)
			this.RegisterProtocal(42909, Handle42909)
			this.RegisterProtocal(10211, Handle10211)
		}



		this.InitInfo()
	}

}

window["TempleAwakenController"] = TempleAwakenController