import { BaseWindowComponent } from "../common/BaseWindowComponent"
import { RoleManager } from "../commonModel/RoleManager";
import { FlowerRankView } from "../flowerRank/FlowerRankView";
import { InstructionType } from "../common/InstructionType"

export class FlowerRankEnterView extends BaseWindowComponent {
	titleStr
    viewClassList
	bg_list
	tabStrList
	SetActInfo
	
	public constructor() {
		super()
		this.destroy_imm = true
		this.dependent_res = ["customActivity"]
		this.titleStr = "customActivity.ui_rising_star"
		this.viewClassList = ["FlowerRankView","FlowerRankView"]
		this.tabStrList = [{label: "全民男神", red_state: false, effect: undefined},
							{label: "全民女神", red_state: false, effect: undefined}]
		this.instruction_list = [
			InstructionType.FlowerRank,
			InstructionType.FlowerRank
		]
		this.SetActInfo = (info?)=>{
			this.arg_list = [info, info]
			let sex = RoleManager.GetInstance().mainRoleInfo.sex
			this.SetDefaultIndex(sex - 1) //这里减1是因为ts的索引从0开始
		}
	}
}
window["FlowerRankEnterView"] = FlowerRankEnterView
