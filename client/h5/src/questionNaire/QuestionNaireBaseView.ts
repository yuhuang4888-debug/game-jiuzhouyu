import { BaseWindowComponent } from "../common/BaseWindowComponent";
import { EventName } from "../common/EventName";
import { CustomActivityModel } from "../commonModel/CustomActivityModel";
import { QuestionNaireModel } from "../commonModel/QuestionNaireModel";
import { GlobalEventSystem } from "../util/DeclareGlobalVar";

export class QuestionNaireBaseView extends BaseWindowComponent {
    CheckRedStatus
    InitSubEvent
    public constructor() {
        super()
        let model = QuestionNaireModel.GetInstance(),
        UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE = EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE
        this.destroy_imm = true
        this.bg_list = ["uizxhy_001.jpg"]
        this.tabStrList = [
            { label: "问卷调查" }
        ];
        this.viewClassList = ["QuestionNaireMainView"]

        this.titleStr = "questionNaire.uiwjdc_001"

         
        this.window_load_back = function () {
            this.CheckRedStatus()
            this.InitSubEvent()
        }
        this.InitSubEvent = () => {
            GlobalEventSystem.Bind(EventName.REFRESH_ACTIVITY_ICON_RED_DOT, (iconType ,value) => {
                if (iconType == "90@331") {
                    GlobalEventSystem.Fire(UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "QuestionNaireBaseView", 0, value)
                }
            })
        }
        this.CheckRedStatus = () =>{
            GlobalEventSystem.Fire(UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "QuestionNaireBaseView", 0, model.red_status)
        }
    }
}
window["QuestionNaireBaseView"] = QuestionNaireBaseView

