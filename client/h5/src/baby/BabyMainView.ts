import { BaseWindowComponent } from "../common/BaseWindowComponent"
import { CommonManager } from "../common/CommonManager"
import { EventName } from "../common/EventName"
import { InstructionType } from "../common/InstructionType"
import { RedDotManager, ModuleType } from "../common/RedDotManager"
import { BabyModel, BabyEvent } from "../commonModel/BabyModel"
import { MarriageModel, MarriageEvent } from "../commonModel/MarriageModel"
import { RuneTreasureModel } from "../commonModel/RuneTreasureModel"
import { LoginModel } from "../login/LoginModel"
import { PlatformManager } from "../PlatformManager"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { Util } from "../util/Util"
import { BabyCultivateView } from "./BabyCultivateView"
import { BabyFamilyView } from "./BabyFamilyView"
import { BabyIllusionView } from "./BabyIllusionView"

/**宝宝主界面*/
export class BabyMainView extends BaseWindowComponent {
    model = BabyModel.GetInstance()
    InitRed
    Local_SelectView
    _Local_Open
    public constructor() {
        super()
        let mar_model = MarriageModel.GetInstance()
        let local_GlobalEventSystem = GlobalEventSystem
        let local_EventName = EventName
        let red_dot_mgr = RedDotManager.GetInstance()
        let local_ModuleType = ModuleType
        let local_BabyEvent = BabyEvent
        let rune_model = RuneTreasureModel.GetInstance()
        let local_InstructionType = InstructionType
        this.dependent_res = ["baby"]
        this.tabStrList = [
            { label: "培养" },
            { label: "家庭" },
            { label: "皮肤" },
        ];
        this.titleStr = `baby.uibaobao_01a`
        this.viewClassList = ["BabyCultivateView", "BabyFamilyView", "BabyIllusionView"]

        this.bg_list = ["uibbsj_013.jpg", "uibbsj_013.jpg", "uibbsj_013.jpg"]
        this.window_load_back = function () {
            let mateInfo = mar_model.GetMateInfo()
            if (!mateInfo) {
                mar_model.Fire(MarriageEvent.REQUEST_PROTO, 17232)
            }
            this.InitRed()
            // this.SetInstruInex()
        }
        this.InitRed = () => {
            let red1Func = () => {
                let red1 = this.model.stageRed || this.model.lvTaskRed || this.model.babyLikeRed
                local_GlobalEventSystem.Fire(local_EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "BabyMainView", 0, red1)
            }
            this.BindVar(this.model, "stageRed", () => {
                red1Func()
            })
            this.BindVar(this.model, "lvTaskRed", () => {
                red1Func()
            })
            this.BindVar(this.model, "babyLikeRed", () => {
                red1Func()
            })
            red1Func()

            // let red3Func = () => {
            // let red = red_dot_mgr.GetRedStatus(local_ModuleType.BABY_EQUIP_FOR) || this.model.betterEquipRed
            // local_GlobalEventSystem.Fire(local_EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "BabyMainView", 2, red)
            // }
            // this.BindEvent(this.model, local_BabyEvent.UPDATE_EQUIP_RED, red3Func)

            // this.BindVar(this.model, "betterEquipRed", () => {
            //     red3Func()
            // })
            // red3Func()

            let red4Func = () => {
                let red = red_dot_mgr.GetRedStatus(local_ModuleType.BABY_ILLU_RED)
                local_GlobalEventSystem.Fire(local_EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "BabyMainView", 2, red)
            }
            this.BindEvent(this.model, local_BabyEvent.UPDATE_ILLU_RED, red4Func)

            red4Func()

            // let CheckRed3 = () => {
            //     let red3 = rune_model.babyTreasureRed
            //     local_GlobalEventSystem.Fire(local_EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "BabyMainView", 4, red3)
            // }
            // this.BindVar(rune_model, "babyTreasureRed", CheckRed3)
            // CheckRed3()
        }

        this._Local_Open = (parms) => {
            if (parms && parms[0]) {
                this.SetDefaultIndex(parms[0])
                this.SetIndexParameter(parms[0], parms[1])
            }
            super.Open()
        }

        this.Local_SelectView = (index, is_real_index) => {
            super.SelectView(index, is_real_index)
            if (index == 1) {
                this.model.Fire(local_BabyEvent.REQUEST_PROTO, 18207)
            }
        }
        this.instruction_list = [local_InstructionType.Baby, local_InstructionType.Baby, local_InstructionType.Baby]
    }
    public Open(...parms) {
        this._Local_Open(parms)
    }
    public SelectView(index: number, is_real_index = false) {
        this.Local_SelectView(index, is_real_index)
    }
}

window["BabyMainView"] = BabyMainView


