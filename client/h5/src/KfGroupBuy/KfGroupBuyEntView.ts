import { BaseWindowComponent } from "../common/BaseWindowComponent";
import { InstructionType } from "../common/InstructionType";
import { KfGroupBuyView } from "../KfGroupBuy/KfGroupBuyView";


export class KfGroupBuyEntView extends BaseWindowComponent {
    titleStr
    viewClassList
	bg_list
	tabStrList
	SetActInfo

    public constructor() {
        super()
        this.destroy_imm = true
		this.dependent_res = ["customActivity"]
		this.titleStr = "customActivity.uikftg_002"
		this.viewClassList = ["KfGroupBuyView"]
		this.bg_list = ["ui_kftg_bg.jpg"]
		this.tabStrList = [{label: "跨服团购", red_state: false, effect: undefined}]
		this.instruction_list = [
			InstructionType.KfGroupBuy
		]

        this.SetActInfo = (info?,prams?)=>{
			if(prams){
				info.select_index = prams[0]
			}else{
				info.select_index = null
			}
			this.arg_list = [info]
		}
    }
}
window["KfGroupBuyEntView"] = KfGroupBuyEntView