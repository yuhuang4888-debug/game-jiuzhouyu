import { ResManager } from "../common/ResManager"
import { AccumRechargeView } from "./AccumRechargeView"
import { Config } from "../common/Config"

export class FtvRechargeMainViewTwo extends AccumRechargeView {
	LoadSuccess
	time_title_color

	public constructor(parent?) {
		super(parent)

		this.LoadSuccess = () => {
			// let cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "ConfigCustomActivityView", true)
			// if (cfg && this._act_info) {
			// 	this._model.LoadCompontRes(this, cfg, "FtvRechargeMainViewTwo", this._act_info.show_id)
			// }

			if (this._act_info) {
				this._model.CloseACTRed(this._act_info.base_type, this._act_info.sub_type, null, this._act_info.show_id)
				if (this._act_info.show_id > 10) {
					this._gp_tips.visible = true
				}
			}

			let bool = this._act_info.base_type == 14 && true || false
			// this._titleBg.visible = bool
			this._lb_desc.visible=false
			//活动时间开头文字颜色
			// let view_cfg = Config.PRELOAD_CLIENT_CONFIG["FtvRechargeMainViewTwo"]
			// let com_cfg = view_cfg[this._act_info.show_id]
			// if (!com_cfg) {
			// 	com_cfg = view_cfg["default"]
			// }
			// this.time_title_color = (com_cfg["_gp_time"] && com_cfg["_gp_time"].title_color) && com_cfg["_gp_time"].title_color || null

			this.InitView()
			this.InitEvent()
		}

	}
}
window["FtvRechargeMainViewTwo"]=FtvRechargeMainViewTwo