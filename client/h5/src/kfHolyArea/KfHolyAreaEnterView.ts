import { BaseWindowComponent } from "../common/BaseWindowComponent"
import { InstructionType } from "../common/InstructionType"
import "../kfHolyArea/KfHolyAreaMainView"
export class KfHolyAreaEnterView extends BaseWindowComponent {
	bg_list
	instruction_list
	preload_client_config
	preload_server_config
	tabStrList
	titleStr
	viewClassList
	window_load_back

	public constructor() {
		super()

		this.titleStr = "kfHolyArea.uikfsy_001"
		this.dependent_res = ["kfHolyArea"]
		this.tabStrList = [{ label: "跨服异域" }]

		this.viewClassList = ["KfHolyAreaMainView"]
		this.bg_list = [
			"uikfsy_002.jpg"
		]
		this.instruction_list = [InstructionType.KfHolyArea2]

		this.window_load_back = () => {
		}

		// this.preload_server_config = [config_c_sanctuary_info=false, config_c_sanctuary_construction=false, config_c_sanctuary_mon=false, config_c_sanctuary_score=false, config_c_sanctuary_type=false]
		// this.preload_client_config = [ConfigKfHolyArena=false]
	}

}
window["KfHolyAreaEnterView"] = KfHolyAreaEnterView