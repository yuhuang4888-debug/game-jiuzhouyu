
//require("game.preload_proto.Require111")

import "../cheat/CheatInputView"
import { BaseController } from "../common/BaseController"
import { EventName } from "../common/EventName"
import { ResManager } from "../common/ResManager"
import { UserMsgAdapter } from "../common/UserMsgAdapter"
import { CheatModel } from "../commonModel/CheatModel"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { LoadLuaClassAB } from "../util/Util"

export class CheatController extends BaseController {
	cheatInputView
	model
	testPopView
	LuaState
	attrView
	static Instance


	public constructor() {
		super()

		CheatController.Instance = this
		this.model = CheatModel.GetInstance()
		this.RegisterAllProtocals()
		this.InitEvent()
	}

	public RegisterAllProtocals() {

		let handler11100 = () => {
			let vo = UserMsgAdapter.GetInstance().GetSCMD("11100")
			this.model.SetCheatsData(vo.command_list)
		}
		this.RegisterProtocal(11100, handler11100)//秘籍列表
		this.RegisterProtocal(11101, "handler11101")//执行秘籍
	}

	public InitEvent() {

		let request_cheat = () => {
			this.SendFmtToGame(11100)
		}
		this.model.Bind(CheatModel.REQUEST_CHEAT_DATA, request_cheat)

		let send_cheat = (text?) => {
			if (text) {
				this.SendFmtToGame(11101, "s", text)
			}
		}
		this.model.Bind(CheatModel.SEND_CHEAT_TO_SERVER, send_cheat)

		let open_client_view = () => {
			//if (! PlatformMgr.GetInstance().IsInternalPalt() ) {
			//Message.show("no Internal Palt")
			//return
			//}

			let  callback = async() => {
				if (!window["CheatInputView"] && !ResManager.GetInstance().IsJsLoad("cheat")) {
					// await ResManager.GetInstance().LoadJs("cheat")
				}
				if (this.cheatInputView == null) {
					this.cheatInputView = new window["CheatInputView"]()
				}
				if (this.cheatInputView.HasOpen()) {
					this.cheatInputView.Close()
				} else {
					this.cheatInputView.Open()
				}
			}
			LoadLuaClassAB("CheatInputView", callback)
		}
		GlobalEventSystem.Bind(EventName.OPEN_CHEAT_CLIENT_VIEW, open_client_view)


		// let open_test_view = () => {

		// 	if (this.testPopView == null ) {
		// 		this.testPopView =  new TestPopView()
		// 	}
		// 	if (this.testPopView.HasOpen() ) {
		// 		this.testPopView.Close()
		// 	}else{
		// 		this.testPopView.Open()
		// 	}
		// }
		// GlobalEventSystem.Bind(EventName.OPEN_TEST_VIEW, open_test_view)

		// let open_attr_view = () => {
		// 	if (this.attrView == null ) {
		// 		this.attrView =  new AttrLogView()
		// 	}
		// 	if (this.attrView.HasOpen() ) {
		// 		this.attrView.Close()
		// 	}else{
		// 		this.attrView.Open()
		// 	}
		// }
		// GlobalEventSystem.Bind(EventName.OPEN_ATTR_VIEW, open_attr_view)


		// var onOpenLuaStateView =()=> {
		// 	if (this.LuaState == null ) {
		// 		this.LuaState =  new LuaState()
		// 	}
		// 	if (this.LuaState.HasOpen() ) {
		// 		this.LuaState.Close()
		// 	}else{
		// 		this.LuaState.Open()
		// 	}
		// }
		// // if (ApplicationPlatform == RuntimePlatform.WindowsEditor || ApplicationPlatform == RuntimePlatform.WindowsPlayer ) {
		// // 	onOpenLuaStateView()
		// // }
		// EventSystem.Bind(GlobalEventSystem, EventName.OPEN_LUA_STATE_VIEW, onOpenLuaStateView)
	}

	public handler11100() {

		let vo = UserMsgAdapter.GetInstance().GetSCMD("11100")
		this.model.SetCheatsData(vo.command_list)
	}

	public handler11101() {


	}
}
window["CheatController"] = CheatController