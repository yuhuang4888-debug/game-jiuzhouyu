import { BaseWindowComponent } from "../common/BaseWindowComponent"

export class WeekendActivityView extends BaseWindowComponent {
    back_login_toClose
    bg_list
    destroy_imm
    instruction_list
    money_list
    tabStrList
    titleStr
    viewClassList
    window_load_back
    public constructor() {
        super()

        this.dependent_res = ["feastBoss"]
        this.destroy_imm = true
        this.back_login_toClose = true
        this.tabStrList = [{ label: "怪物攻城" }]
        this.viewClassList = ["FeastBossEnterView"]
        this.instruction_list = {
            //5004
        }
        this.titleStr = "feastBoss_asset.uihd_001"
        this.bg_list = ["uigwgc_001.jpg"]
        this.money_list = [2, 1, 0]
        this.window_load_back = () => {

        }
    }

}
window["WeekendActivityView"] = WeekendActivityView