import { Alert, Alert_Type } from "../alert/Alert"
import { BaseItem1 } from "../common/BaseItem1"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { CommonManager } from "../common/CommonManager"
import { EventName } from "../common/EventName"
import { OpenFun } from "../common/OpenFun"
import { VipModel } from "../commonModel/VipModel"
import { Message } from "../sysInfo/SysInfoController"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { Util } from "../util/Util"
import { RedPacketModel } from "../commonModel/RedPacketModel"

export class RedPacketFuncItem extends BaseItemRenderer {
	_model

	public WIDTH = 280
	public HEIGT = 40


	public constructor(parent) {
		super()

		this.base_file = "redPacket"
		this.layout_file = "RedPacketFuncItem"
		this._model = RedPacketModel.GetInstance()
		this.load_callback = () => {
			this.load_callback1()
		}
		this.Load()
	}

	public DeleteMe() {

		super.DeleteMe()
	}

	// function RedPacketFuncItem.createChildren()
	public load_callback1() {

		//未曾移植模块
		// if (PlatformMgr.GetInstance().IsEyouEnPlatform() ) {
		// 	this._Image1.visible = false 
		// }
		// if (PlatformMgr.GetInstance().IsEyouIdnPlatform() ) {
		// 	this._lb_go.size  = 16
		// 	this._lb_content.size  = 14
		// 	this._lb_content.lineSpacing = 0.5
		// 	let csf = this._lb_content.GetComponent("ContentSizeFitter")
		// 	csf.horizontalFit = UnityEngine.UI.ContentSizeFitter.FitMode.Unconstrained
		// 	SetSizeDeltaX(this._lb_content,190)
		// }


		// super.createChildren()
		// this._lb_go.text = [{text:"前往"}, {style:{textColor:"#639c12", underline:true}]}
		this._lb_go.text = "前往>>"
		Util.AddClickEvent(this._btn_go, () => {
			console.log("RedPacketFuncItem open_id", this.data.open_id)
			if (this.data.open_id == 104) {
				let need_vip_lv = CommonManager.GetInstance().GetValue(3390004)
				let vip_lv = VipModel.GetInstance().GetVipLevel()
				if (need_vip_lv > vip_lv) {
					Alert.Show("VIP" + need_vip_lv + "及以上才可发送勾玉红包！\n每日登陆以及消费勾玉可获得VIP经验值。", Alert_Type.One, () => {
						OpenFun.OpenFunHandler(23)
					}
						, null, "我知道了")
				} else {
					OpenFun.OpenFunHandler(this.data.open_id)
				}
			} else if (this.data.open_id == 50) {
				Message.show("参加结社晚宴可获得大量绑玉红包")
			} else {
				if (this.data.open_id == 61 || this.data.open_id == 62) {
					GlobalEventSystem.Fire(EventName.CLOSE_VIEW, "RedPacketMainView")
				}
				OpenFun.OpenFunHandler(this.data.open_id)
			}
		}
			, this, true)
	}

	public dataChanged() {

		if (! super.dataChanged()) {
			return
		}
		this._lb_content.text = this.data.title
	}


_lb_content:Laya.Label
_btn_go:Laya.Box
_lb_go:Laya.Label
public GetComponents() {
[
this._lb_content,
this._btn_go,
this._lb_go,
]
 = this.GetChildrenByNames([

"_lb_content",
"_btn_go",
"_lb_go",
])
}
}
 window["RedPacketFuncItem"]= RedPacketFuncItem