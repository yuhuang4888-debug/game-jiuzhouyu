import { BaseWindowComponent } from "../common/BaseWindowComponent"
import { InstructionType } from "../common/InstructionType"
import { ModuleType, RedDotManager } from "../common/RedDotManager"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { EventName } from "../common/EventName"
import { MarketModel } from "../commonModel/MarketModel"
import "./MarketBuyView"
import "./MarketPlzView"
import "./MarketSellView"



export class MarketBaseView extends BaseWindowComponent {
	destroy_imm
	instruction_list
	is_show_tab
	model
	money_list
	preload_server_config
	tabStrList
	titleStr
	viewClassList
	window_load_back

	public constructor() {
		super()

		this.dependent_res = ["market"]
		this.model = MarketModel.GetInstance();
		this.viewClassList = ["MarketBuyView", "MarketPlzView", "MarketSellView"]//, MarketAuctionView, MarketRecordView
		if (!this.model.kf_open) {
			this.titleStr = "market.uisc_001"
		} else {
			this.titleStr = "market.uisc_001_kf"
		}
		this.bg_list = [
			"ui_bg_1.jpg",
			"ui_bg_1.jpg",
			"ui_bg_1.jpg",
			// "uiwg_0082.jpg", 
			// "uibs_001_720x1222.jpg", 
			// "uiwg_008a.jpg"
		]
		this.money_list = [2, 1, 0]
		this.is_show_tab = true
		this.destroy_imm = true
		this.tabStrList = [{ label: "购买" },//, icon_up_source: "uisc_004_r1_c2_png", icon_down_source: "uisc_004_r1_c1_png"
		{ label: "求购" },//, icon_up_source: "uisc_004_r2_c2_png", icon_down_source: "uisc_004_r2_c1_png" 
		{ label: "出售" }]//, icon_up_source: "uisc_004_r3_c2_png", icon_down_source: "uisc_004_r3_c1_png"
		//, {label="拍卖", icon_up_source="market_asset.uighgh_0014", icon_down_source="market_asset.uighgh_0013"}, {label="记录", icon_up_source="market_asset.uisc_004_r4_c2", icon_down_source="market_asset.uisc_004_r4_c1"}
		this.instruction_list = [null, null, null, InstructionType.AUCTION, InstructionType.MARKET_RECORD]
		this.window_load_back = () => {
			this.UpdateRedStatus()
		}

		this.preload_server_config = { "config_goods": false, "config_equip_attr": false }
	}

	public Open(...new_args) {

		let parms = new_args
		let index = parms
		this.SetDefaultIndex(parms[0])
		if ((parms[0] && parms[1]) && parms[0] == 3) {
			this.SetIndexParameter(parms[0], parms[1])
		}
		if (parms[0] == 0 && parms[1] && parms[2]) {
			this.SetIndexParameter(parms[0], parms[1], parms[2])
		}
		super.Open()
	}

	public UpdateRedStatus() {

		this.RefreshAuctionRed()
	}

	public RefreshAuctionRed() {

		let red = RedDotManager.GetInstance().CheckRedStatus(ModuleType.AUCTON, 1)
		GlobalEventSystem.Fire(EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "MarketBaseView", 4, red)
	}

}
window["MarketBaseView"] = MarketBaseView