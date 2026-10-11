import { OpenMode } from "../common/BaseView1"
import { BaseWindowComponent } from "../common/BaseWindowComponent"
import { EventName } from "../common/EventName"
import { InstructionType } from "../common/InstructionType"
import { WeekCardModel } from "../commonModel/WeekCardModel"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"

export class WeekCardEnterView extends BaseWindowComponent {

    _Local_Open
    public constructor() {
        super()


        this.dependent_res = ["customActivity"]
        this.titleStr = "customActivity.zhouka"
        this.destroy_imm = true
        this.open_mode = OpenMode.OpenToggle
        let local_GlobalEventSystem = GlobalEventSystem
        let UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE = EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE
        let local_Number = Number
        this.tabStrList = [{ label: "周卡" }]
        this.bg_list = ["ui_activity_zk_bg.jpg"]
        this.viewClassList = ["WeekCardMainView"]
        this.instruction_list = [
			InstructionType.WeeklyCard
		]
        this.money_list = [2, 1, 0]
        this.window_load_back = () => {
            this.BindEvent(WeekCardModel.GetInstance(), WeekCardModel.UPDATE_VIEW, () => {
                let state = WeekCardModel.GetInstance().CanReceive() || WeekCardModel.GetInstance().spacial_red
                GlobalEventSystem.Fire(UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "WeekCardEnterView", 0, state)

            }
            )
            let state = WeekCardModel.GetInstance().CanReceive() || WeekCardModel.GetInstance().spacial_red
            GlobalEventSystem.Fire(UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "WeekCardEnterView", 0, state)
        }



        this._Local_Open = ( parms?) => {
			if (parms ) {
				this.SetBackId(parms[0])
			}
		}

    }


    public Open(...new_args){ 
		let parms = new_args
		this._Local_Open(parms)
		super.Open()
	}

}
window["WeekCardEnterView"] = WeekCardEnterView