import { BaseController } from "../common/BaseController"
import { Util } from "../util/Util"
import { EventName } from "../common/EventName"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { UserMsgAdapter } from "../common/UserMsgAdapter"
import { OutLineModel } from "../commonModel/OutLineModel"
import { DailyModel } from "../commonModel/DailyModel"
import { ViewManager } from "../common/ViewManager"
import { EnumViewOrder, ViewOrderModel, ViewOrderModelEvent } from "../commonModel/ViewOrderModel"
import "../outline/OutLineView"
import { ViewPopLevelModel } from "../commonModel/ViewPopLevelModel"

export class OutLineController extends BaseController {
	InitInfo
	OpenOutlineView

	public constructor() {
		super()
		let outlineModel = OutLineModel.GetInstance()
		let user_msg_adapter = UserMsgAdapter.GetInstance()
		let daily_model = DailyModel.GetInstance()
		let local_OutLineModel = OutLineModel
		let local_GlobalEventSystem = GlobalEventSystem
		let local_EventName = EventName

		let outline_view_ = null

		this.InitInfo = () => {
			//let On13200 = () => {
			//let scmd = user_msg_adapter.GetSCMD(13200)
			//outlineModel.onhookTime = scmd.onhook_time
			//daily_model:ShowRedDot()
			//}

			//let On13201 = () => {
			//let scmd = user_msg_adapter.GetSCMD(13201)
			//}

			//let On13202 = () => {
			//let scmd = user_msg_adapter.GetSCMD(13202)
			//outlineModel.onhookTime = scmd.onhook_time
			//outlineModel.ol_award_dic = scmd
			//this:OpenOutlineView()
			//this:SendFmtToGame(13205)
			//}

			//let On13203 = () => {
			//let scmd = user_msg_adapter.GetSCMD(13203)
			//outlineModel:SetOutlineFindData(scmd)
			//}

			//let On13204 = () => {
			//let scmd = user_msg_adapter.GetSCMD(13204)
			//if (scmd.code == 1 ) {
			//this:SendFmtToGame(13203, "c", scmd.type)
			//}else{
			//ErrorCodeShow(scmd.code)
			//}
			//}

			//let On13205 = () => {
			//let scmd = user_msg_adapter.GetSCMD(13205)
			//outlineModel.redemptionData = scmd
			//outlineModel:Fire(local_OutLineModel.UPDATE_REDEMPTION_INFO, scmd)
			//}

			//let On13206 = () => {
			//let scmd = user_msg_adapter.GetSCMD(13206)
			//if (scmd.code == 1 ) {
			//this:SendFmtToGame(13205)
			//ShowCongratulationView([{5, 0, scmd.exp}])
			//}else{
			//ErrorCodeShow(scmd.code)
			//}
			//}

			let On13211 = () => {
				let scmd = user_msg_adapter.GetSCMD(13211)
				outlineModel.RequestItmer(scmd.next_time)
				if (scmd.error_code == 1) {
				} else {
					Util.ErrorCodeShow(scmd.error_code)
				}
			}
			let On13212 = () => {
				let scmd = user_msg_adapter.GetSCMD(13212)
				outlineModel.onhookTime = scmd.afk_time
				outlineModel.ol_award_dic = scmd
				outlineModel.exp_effect = scmd.exp_effect
				console.log("13212 OutlineExp:" + scmd.exp_effect)
				if (scmd.login_type == 1 && Util.TableSize(scmd.goods_list) > 0 && outlineModel.ShowExpEffect()) {
					// 判断是否出现跨服界面,因为需要等跨服关闭了 才打开挂机界面 所以先暂存起来
					/* let viewMag: ViewManager = ViewManager.GetInstance();
					if (viewMag.GetView('kfStageOpenView')?.isPop || viewMag.GetView('kfStageShowView')?.isPop) {
						ViewOrderModel.GetInstance().SetTypeByView(EnumViewOrder.eOutLine, { viewName: 'OutLineView' });
					} else {
					} */
					this.OpenOutlineView();
				}
				outlineModel.RequestItmer(scmd.next_time)
				outlineModel.Fire(OutLineModel.REFRESH_EXP_EFFECT)
			}
			let On13213 = () => {
				let scmd = user_msg_adapter.GetSCMD(13213)
				if (scmd.code == 1) {
					outlineModel.SetOutlineFindData(scmd)
					outlineModel.Fire(local_OutLineModel.UPDATE_REDEMPTION_INFO, scmd)
					Util.ShowCongratulationView([[5, 0, scmd.exp]])
				} else {
					Util.ErrorCodeShow(scmd.code)
				}
			}
			let On13214 = () => {
				let scmd = user_msg_adapter.GetSCMD(13214)
				outlineModel.RequestItmer(scmd.next_time)
				outlineModel.onhookTime = scmd.afk_time
				daily_model.ShowRedDot()
			}
			let On13215 = () => {
				let scmd = user_msg_adapter.GetSCMD(13215)
				outlineModel.exp_effect = scmd.exp_effect
				console.log("13215 OutlineExp:" + scmd.exp_effect)
				outlineModel.Fire(OutLineModel.REFRESH_EXP_EFFECT)
			}

			//this:RegisterProtocal(13200, On13200)
			//this:RegisterProtocal(13201, On13201)
			//this:RegisterProtocal(13202, On13202)
			//this:RegisterProtocal(13203, On13203)
			//this:RegisterProtocal(13204, On13204)
			//this:RegisterProtocal(13205, On13205)
			//this:RegisterProtocal(13206, On13206)
			this.RegisterProtocal(13211, On13211)
			this.RegisterProtocal(13212, On13212)
			this.RegisterProtocal(13213, On13213)
			this.RegisterProtocal(13214, On13214)
			this.RegisterProtocal(13215, On13215)


			// 处理先后顺序问题
			ViewOrderModel.GetInstance().Bind(ViewOrderModelEvent.PROTO_OUT_LINE, () => {
				this.SendFmtToGame(13212)

			})

			/* local_GlobalEventSystem.Bind(local_EventName.GAME_START, () => {
				this.SendFmtToGame(13212)
			}) */

			outlineModel.Bind(local_OutLineModel.REQUEST_PROTO, (id, fmt, ...new_args) => {
				this.SendFmtToGame(id, fmt, ...new_args)
			}
			)
		}

		this.OpenOutlineView = () => {
			/* 	if (!window["OutLineView"]) {
					// if (!ResManager.GetInstance().IsJsLoad("outline")) {
	
					// }
				}
				if (!outline_view_) {
					let view = window["OutLineView"]
					outline_view_ = new view()
				}
				outline_view_.Open() */
			// 为了统一管理
			/* GlobalEventSystem.Fire(EventName.OPEN_VIEW, "OutLineView"); */
			ViewPopLevelModel.GetInstance().SetView('OutLineView');
			daily_model.ShowRedDot()
		}

		this.InitInfo()
	}
}
window["OutLineController"] = OutLineController