import { BaseWindowComponent } from "../common/BaseWindowComponent"
import { EventName } from "../common/EventName"
import { UnrealModel } from "../commonModel/UnrealModel"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"


import "../unreal/UnrealStrengthenView"
import { MainFunc } from "../commonModel/MainUIModel"
import { SecretTreasureMainViewIndex } from "../commonModel/LungModel"

export class UnrealEnterView extends BaseWindowComponent {
    bg_list
    model
    money_list
    tabStrList
    titleList
    viewClassList
    window_load_back
    public static Index = {
        Stren: 0,
    }
    public constructor() {
        super()

        this.tabStrList = [{ label: "灵饰强化" }]
        this.viewClassList = [
            "UnrealStrengthenView"
        ]
        this.titleList = [
            "unreal.uihs_stren"
        ]
        this.bg_list = [
            "ui_rare_bg4.jpg"
        ]

        this.money_list = [2, 1, 0]

        this.window_load_back = () => {
            this.InitMyEvent()
        }
        this.model = UnrealModel.GetInstance()
    }

    public InitMyEvent() {
        GlobalEventSystem.Fire(EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "UnrealEnterView", UnrealEnterView.Index.Stren, this.model.GetStrenRedDot())

        this.BindEvent(GlobalEventSystem, EventName.REFRESH_FUNCTION_ICON_RED_DOT, (_type) => {
            if (_type && _type == MainFunc.Treasure) {
                GlobalEventSystem.Fire(EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "UnrealEnterView", UnrealEnterView.Index.Stren, this.model.GetStrenRedDot())
            }
        })
    }

    public Close() {
        super.Close()
    }

    public BaseWindowCloseFunc() {
        GlobalEventSystem.Fire(EventName.OPEN_VIEW, "SecretTreasureMainView", SecretTreasureMainViewIndex.Unreal)
        super.BaseWindowCloseFunc()
    }

    public Open(...new_args) {
        if (new_args && new_args.length > 0) {
            if (new_args[0]) {
                this.SetDefaultIndex(new_args[0])
            }
            if (new_args[1]) {
                this.SetBackId(new_args[1], new_args[2])
            }
        }
        super.Open()
    }
}

window["UnrealEnterView"] = UnrealEnterView

