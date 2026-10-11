import { BaseWindowComponent } from "../common/BaseWindowComponent"
import { EventName } from "../common/EventName"
import { KaifuActivityModel, KaifuActivityModelEvent } from "../commonModel/KaifuActivityModel"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import "../invest/zExtremeInvestView"
import "../invest/zGodInvestView"
import "../invest/zKingInvestView"
export class TopInvestEntView extends BaseWindowComponent {
    _model
    bg_list
    tabStrList
    titleStr
    viewClassList
    window_load_back

    public constructor() {
        super()

        this.titleStr = "invest.invest_title"
        this._model = KaifuActivityModel.GetInstance()
        this.window_load_back = () => {
            this.BindEvent(this._model, KaifuActivityModelEvent.UPDATE_TAB_RED, (class_name?, state?) => {
                let index = this.GetClassIndex(class_name)
                if (index != null) {
                    GlobalEventSystem.Fire(EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "TopInvestEntView", index, state)
                }
            }
            )
            this._model.investReddot(true)
        }
    }

    public GetClassIndex(class_name?) {

        for (let key in this.viewClassList) {

            let _class = this.viewClassList[key]
            if (_class == class_name) {
                return Number(key)
            }
        }
    }

    public setData(viewClassList?, tabStrList?, bg_list?) {

        this.viewClassList = viewClassList
        this.tabStrList = tabStrList
        this.bg_list = bg_list
    }
}
window["TopInvestEntView"] = TopInvestEntView