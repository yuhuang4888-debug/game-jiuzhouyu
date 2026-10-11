import { BaseItem1 } from "../common/BaseItem1"
import { EventName } from "../common/EventName"
import { OpenFun } from "../common/OpenFun"
import { ResManager } from "../common/ResManager"
import { ActivityIconManager } from "../commonModel/ActivityIconManager"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"
import { Message } from "../sysInfo/SysInfoController"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { Util } from "../util/Util"

export class rechargeReturnView extends BaseItem1 {
	_img_1: Laya.Image
	_img_2: Laya.Image
	_gp_btn: Laya.Box
	_img_btn: Laya.Image
	_lb_btn: Laya.Label
	CustomMehod
	InitEvent
	LoadSuccess

	public constructor(parent?) {
		super(parent)


		this.base_file = "activity"
		this.layout_file = "rechargeReturnView"
		this.is_load_res = false
		let model = CustomActivityModel.GetInstance()
		let info = null
		this.preload_client_config = {
			"ConfigCustomActivityView": false
		}
		this.load_callback = () => {

			this.LoadSuccess()
			this.InitEvent()
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this._gp_btn, () => {
				if (!info) {
					return
				}
				if (info.base_type == 86) {
					OpenFun.OpenFunHandler(21)
				} else {
					if (1 == info.show_id) {
						OpenFun.OpenFunHandler(21)
					} else if (2 == info.show_id) {
						let type = "175_1"
						if (ActivityIconManager.GetInstance().getIconInfo(type)) {
							GlobalEventSystem.Fire(EventName.OPEN_SEVENDAY_VIEW, type)
						}
						else
							Message.show("合服登录奖励已领完")
					}
				}
			}, this, true)
		}

		this.LoadSuccess = () => {
			if (!info) {
				return
			}
			model.CloseACTRed(info.base_type, info.sub_type, null, info.show_id)
			let view_name = "rechargeReturnView"
			if (info.base_type == 86) {
				view_name = "rechargeReturnView86"
			}
			let cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "ConfigCustomActivityView", true)
			if (cfg) {
				model.LoadCompontRes(this, cfg, view_name, info.show_id)
			}
		}

		this.CustomMehod = (index?, args?) => {
			if (args) {
				info = args
			}
		}


	}



	public GetComponents() {
		[
			this._img_1,
			this._img_2,
			this._gp_btn,
			this._img_btn,
			this._lb_btn,
		]
			= this.GetChildrenByNames([

				"_img_1",
				"_img_2",
				"_gp_btn",
				"_img_btn",
				"_lb_btn",
			])
	}
}
window["rechargeReturnView"] = rechargeReturnView