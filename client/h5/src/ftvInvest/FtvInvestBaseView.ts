import { BaseWindowComponent } from "../common/BaseWindowComponent"
import { EventName } from "../common/EventName";
import { CustomActivityDefine } from "../commonModel/CustomActivityDefine";
import { CustomActivityModel } from "../commonModel/CustomActivityModel";
import { GlobalEventSystem } from "../util/DeclareGlobalVar";
export class FtvInvestBaseView extends BaseWindowComponent {
    CkeckRed
    InitSubEvent
    SetActInfo
    public constructor() {
        super()
        let model = CustomActivityModel.GetInstance(),
            UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE = EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE,
            info_

        this.dependent_res = ["ftvInvest"]
        this.viewClassList = ["FtvInvestView"]
        this.titleStr = `ftvInvest.ui_title_cjtz`
        this.bg_list = ["ui_cjtz_01.jpg"]
        this.window_load_back = () => {
            this.CkeckRed()
            this.InitSubEvent()
        }

        this.InitSubEvent = () => {
            this.BindEvent(model, CustomActivityDefine.EVENT.UPDATE_RED_DOT, (base_type, sub_type) => {
                if (!info_) return
                if (base_type == info_.base_type && sub_type == info_.sub_type) {
                    let value = model.GetRedDotValue(base_type, sub_type)
                    GlobalEventSystem.Fire(UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "FtvInvestBaseView", 0, value > 0 ? true : false)
                }
            })
        }

        this.CkeckRed = () => {
            if (!info_) return
            let base_type = info_.base_type
            let sub_type = info_.sub_type
            let value = model.GetRedDotValue(base_type, sub_type)
            GlobalEventSystem.Fire(UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "FtvInvestBaseView", 0, value > 0 ? true : false)
        }

        this.SetActInfo = (...parms) => {
            if (parms) {
                info_ = parms[0]
                let name = parms[0] && parms[0].name || `超级投资`
                this.tabStrList = []
                this.tabStrList.push({ "label": `${name}` })
                this.SetIndexParameter(0, parms[0])
            }
        }
    }
}
window["FtvInvestBaseView"] = FtvInvestBaseView