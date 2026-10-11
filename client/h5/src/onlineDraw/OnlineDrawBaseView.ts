import { BaseWindowComponent } from "../common/BaseWindowComponent"
import { EventName } from "../common/EventName";
import { CustomActivityDefine } from "../commonModel/CustomActivityDefine";
import { CustomActivityModel } from "../commonModel/CustomActivityModel";
import { GlobalEventSystem } from "../util/DeclareGlobalVar";
export class OnlineDrawBaseView extends BaseWindowComponent {
    CkeckRed
    InitSubEvent
    SetActInfo
    public constructor() {
        super()
        let model = CustomActivityModel.GetInstance(),
            UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE = EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE,
            info_
        this.destroy_imm = true
        this.dependent_res = ["onlineDraw"]
        this.viewClassList = ["OnlineDrawView"]
        this.titleStr = `customActivity.uizxhy_005`
        this.bg_list = ["uizxhy_001.jpg"]
        this.window_load_back = () => {
            this.CkeckRed()
            this.InitSubEvent()
        }

        this.InitSubEvent = () => {
            this.BindEvent(model, CustomActivityDefine.EVENT.UPDATE_RED_DOT, (base_type, sub_type) => {
                if (!info_) return
                if (base_type == info_.base_type && sub_type == info_.sub_type) {
                    let value = model.GetRedDotValue(base_type, sub_type)
                    GlobalEventSystem.Fire(UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "OnlineDrawBaseView", 0, value > 0 ? true : false)
                }
            })
        }

        this.CkeckRed = () => {
            if (!info_) return
            let base_type = info_.base_type
            let sub_type = info_.sub_type
            let value = model.GetRedDotValue(base_type, sub_type)
            GlobalEventSystem.Fire(UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "OnlineDrawBaseView", 0, value > 0 ? true : false)
        }

        this.SetActInfo = (...parms) => {
            if (parms) {
                info_ = parms[0]
                let name = parms[0] && parms[0].name || `活跃抽奖`
                this.tabStrList = []
                this.tabStrList.push({ "label": `${name}` })
                if(info_.show_id == 13){
                    this.titleStr = `customActivity.uizxhy_005b`
                    this.bg_list = ["uizxhy_001b.jpg"]
                }else{
                    this.titleStr = `customActivity.uizxhy_005`
                    this.bg_list = ["uizxhy_001.jpg"]
                }
                this.SetIndexParameter(0, info_)
            }
        }
    }
}
window["OnlineDrawBaseView"] = OnlineDrawBaseView