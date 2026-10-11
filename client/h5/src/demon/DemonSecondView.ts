import { BaseWindowComponent } from "../common/BaseWindowComponent"
import { EventName } from "../common/EventName"
import { DemonModel } from "../commonModel/DemonModel"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"

import "./DemonPaintingView"
import "./DemonShopView"

export class DemonSecondView extends BaseWindowComponent {
	public static Index = {
		Picture: 0,
		Shop: 1
	}

	public constructor() {
		super()

		this.dependent_res = ["demon", "pet"]
		this.tabStrList = [
			{ label: "绘卷" },
			{ label: "黑市" }
		]

		this.viewClassList = [
			"DemonPaintingView",
			"DemonShopView"
		]

		this.titleStr = "pet.uism_001"
		this.bg_list = {
			//0="uism_048b_720x1222.jpg", 
			1: "uismhd_003a.jpg"
		}
		this.preload_server_config = {
			"config_demons": false,
			"config_demons_level": false,
			"config_demons_star": false
		}

		let update_window_red_event = EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE
		let demon_model = DemonModel.GetInstance()

		this.window_load_back = () => {
			GlobalEventSystem.Fire(update_window_red_event, "DemonSecondView", DemonSecondView.Index.Picture, demon_model.HasRedFlag(DemonModel.RedFlag.Painting))
			GlobalEventSystem.Fire(update_window_red_event, "DemonSecondView", DemonSecondView.Index.Shop, demon_model.HasRedFlag(DemonModel.RedFlag.Shop))
		}

		this.window_open_back = () => { }
	}

	public BaseWindowCloseFunc() {
		GlobalEventSystem.Fire(EventName.SWITCH_MOUNT_PET_VIEW, 3)
	}

	public Open(...parms) {
		if (this.HasOpen()) {
			this.SetSelectIndex(parms[0])
			return
		} else {
			this.SetDefaultIndex(parms[0])
		}
		super.Open()
	}
}
window["DemonSecondView"]=DemonSecondView