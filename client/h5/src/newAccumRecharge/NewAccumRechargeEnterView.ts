import { BaseWindowComponent } from "../common/BaseWindowComponent";
import "../newAccumRecharge/NewAccumRechargeView"

export class NewAccumRechargeEnterView extends BaseWindowComponent {
    titleStr
    viewClassList
	bg_list
	tabStrList
	SetActInfo

    public constructor() {
        super()
        this.destroy_imm = true
		this.titleStr = "customActivity.ui_activity_title_131"
		this.viewClassList = ["NewAccumRechargeView"]
		this.bg_list = ["ui_bg_1.jpg"]
		this.tabStrList = [{label: "累计充值", red_state: false, effect: undefined}]

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
window["NewAccumRechargeEnterView"] = NewAccumRechargeEnterView