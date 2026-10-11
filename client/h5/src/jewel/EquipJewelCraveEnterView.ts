import { BaseWindowComponent } from "../common/BaseWindowComponent"
import { EventName } from "../common/EventName"
import { RedDotManager, ModuleType } from "../common/RedDotManager"
import { EquipModel, EquipEvent } from "../commonModel/EquipModel"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"

export class EquipJewelCraveEnterView extends BaseWindowComponent {
	money_list
	tabStrList
	titleStr
	viewClassList
	window_open_back

	public constructor() {
		super()
		this.dependent_res = ["jewel"]
		this.tabStrList = [{ label: "宝石雕琢" }]
		this.viewClassList = ["EquipJewelCraveView"]
		this.viewClassModuleDic = {
			"0": { module_name: "equip", class_name: "EquipJewelCraveView" },
		}
		this.titleStr = "equip.uidz_001"
		this.money_list = [2, 1, 0]
		this.bg_list = ["ui_forge_bg.jpg"]

		this.window_open_back = () => {
			this.CheckJewelCraveRedDot()
		}
	}
	
	private CheckJewelCraveRedDot(){
		let Red1 = () => {
			let red = RedDotManager.GetInstance().CheckRedStatus(ModuleType.JEWEL_CRAVE_RED)
			GlobalEventSystem.Fire(EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "EquipJewelCraveEnterView", 0, red)
		}
		this.BindEvent(EquipModel.GetInstance(), EquipEvent.UPDATE_JEWEL_CARVE_RED, Red1)
		Red1()
	}

	public BaseWindowCloseFunc() {
		super.BaseWindowCloseFunc()
		//FunctionOpenModel:GetInstance():ClearNowStory(FuncOpenId.Genstone)
		EquipModel.GetInstance().Fire(EquipEvent.OPEN_VIEW, "EquipView", 2)
	}
}
window["EquipJewelCraveEnterView"] = EquipJewelCraveEnterView