import { BaseWindowComponent } from "../common/BaseWindowComponent"
import { KaifuActivityModel, KaifuActivityModelEvent } from "../commonModel/KaifuActivityModel"
import { RedDotManager } from "../common/RedDotManager"
import { ModuleType } from "../common/RedDotManager"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { EventName } from "../common/EventName"
import "../invest/MonthCardView"
import "../invest/LVinvestView"
import "../invest/TopInvestView"
import "../invest/zExtremeInvestView"
import "../invest/zGodInvestView"
import "../invest/zKingInvestView"
import { table } from "../common/table"
import { FirstRechargeModel } from "../commonModel/FirstRechargeModel"
import { WeekCardModel } from "../commonModel/WeekCardModel"
import { InstructionType } from "../common/InstructionType"
export class KaifuActivityEntView extends BaseWindowComponent {
	CheckMonthReddot
	CheckVIPReddot
	GetClassIndex
	bg_list
	setData
	tabStrList
	titleStr
	window_load_back
	CheckWeekCardRedDot

	public constructor() {
		super()
		this.dependent_res = ["invest"]
		this.titleStr = "invest.uikf_001"
		let _model = KaifuActivityModel.GetInstance()
		let UPDATE_TAB_RED = KaifuActivityModelEvent.UPDATE_TAB_RED
		let red_dot_mgr = RedDotManager.GetInstance()
		let week_card_model = WeekCardModel.GetInstance()
		let first_recharge_model = FirstRechargeModel.GetInstance()
		let local_ModuleType = ModuleType
		

		this.window_load_back = () => {
			this.BindEvent(_model, UPDATE_TAB_RED, (class_name?, state?) => {
				let index = this.GetClassIndex(class_name)
				if (index != null) {
					GlobalEventSystem.Fire(EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "KaifuActivityEntView", index, state)
				}
			}
			)
			this.instruction_list = []
			for (let key in this.viewClassList) {
				
				let _class = this.viewClassList[key]
				if (_class == "BookOfContractView") {
					_model.setBookRedDot()
				} else if (_class == "LVinvestView") {
					_model.setLEVELReddot()
				} else if (_class == "VIPinvestView") {
					this.CheckVIPReddot()
				} else if (_class == "MonthCardView") {
					this.CheckMonthReddot()
				} else if (_class == "WeekCardMainView"){
					this.CheckWeekCardRedDot()
					this.instruction_list = [
						InstructionType.WeeklyCard
					]
				}
			}
			_model.investReddot()
		}

		this.setData = (viewClassList?, tabStrList?, bg_list?) => {
			if (!first_recharge_model.IsNoFirstRecharge()) {
				//在这里特殊处理一下
				let list = {
					label: "周卡",
					red_state: false,
					effect: undefined,
				}
				table.unshift(viewClassList, "WeekCardMainView")
				table.unshift(tabStrList, list)
				table.unshift(bg_list, "ui_activity_zk_bg.jpg")
			}
			this.viewClassList = viewClassList
			this.tabStrList = tabStrList
			this.bg_list = bg_list
		}

		this.CheckVIPReddot = () => {
			let red = red_dot_mgr.CheckRedStatus(local_ModuleType.VIPINVEST, 1)
			_model.Fire(UPDATE_TAB_RED, "VIPinvestView", red)
		}

		this.CheckMonthReddot = () => {
			let red = red_dot_mgr.CheckRedStatus(local_ModuleType.MONTHINVSET, 1)
			_model.Fire(UPDATE_TAB_RED, "MonthCardView", red)
		}

		this.GetClassIndex = (class_name?) => {
			for (let key in this.viewClassList) {

				let _class = this.viewClassList[key]
				if (_class == class_name) {
					return Number(key)
				}
			}
		}

		this.CheckWeekCardRedDot = () =>{
			let red = week_card_model.CanReceive() || week_card_model.spacial_red
			_model.Fire(UPDATE_TAB_RED, "WeekCardMainView", red)
		}
	}
}
window["KaifuActivityEntView"] = KaifuActivityEntView
