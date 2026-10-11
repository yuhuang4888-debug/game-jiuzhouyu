import { BaseView1 } from "../common/BaseView1"
import { EventName } from "../common/EventName"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { SeaHegemonyModel } from "../commonModel/SeaHegemonyModel"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"

export class ApplySettingView extends BaseView1 {
    lv
    fight
    InitView
    auto
    public constructor() {
        super()

        this.lv = 0
        this.fight = 0
        this.base_file = "seaHegemony"
        this.layout_file = "ApplySettingView"
        this.layer_value = Enum_UILayer.Activity
        this.click_bg_toClose = true
        this.use_background = true
        let local_util = Util
        this.is_center = true
        let local_model = SeaHegemonyModel
        let local_modelIns = local_model.GetInstance()
        this.load_callback = () => {

            this.InitView()
        }

        this.InitView = () => {
            Util.AddClickEvent(
                this.closeBtn, () => {
                    this.Close()
                },
                this,
                true
            )
            Util.AddClickEvent(
                this.cancelBtn, () => {
                    this.Close()
                },
                this,
                true
            )
            Util.AddClickEvent(
                this.saveBtn, () => {
                    // [ts2lua]lua中0和空字符串也是true，此处this.auto需要确认
                    local_modelIns.Fire(local_model.REQUEST_PROTO, 18602, "hlc", this.lv, this.fight, (this.auto && (1) || (0)))
                    this.Close()
                },
                this,
                true
            )
            let data = local_modelIns.applySettingData
            this.auto = data.auto == 1
            this.lv = data.role_lv
            this.lvLb.text = data.role_lv
            this.fight = data.power
            this.fightLb.text = data.power
            let SetAuto = (boolean?) => {
                this.auto = boolean
                this.autoImg.visible = this.auto
            }

            SetAuto(this.auto)
            Util.AddClickEvent(
                this.autoBtn, () => {
                    SetAuto(!this.auto)
                },
                this,
                true
            )
            Util.AddClickEvent(
                this.lvBtn, () => {
                    let lvFunc = (value?) => {
                        this.lvLb.text = value
                        this.lv = value
                    }

                    let pos=[0,-50]
                    GlobalEventSystem.Fire(EventName.OPEN_CALCULATOR_VIEW, 1000, lvFunc, pos)
                },
                this,
                false
            )
            Util.AddClickEvent(
                this.fightBtn, () => {
                    let fightFunc = (value?) => {
                        this.fightLb.text = value
                        this.fight = value
                    }
                    let pos=[0,0]
                    GlobalEventSystem.Fire(EventName.OPEN_CALCULATOR_VIEW, 100000000000, fightFunc, pos)
                },
                this,
                false
            )
            this.BindEvent(
                local_modelIns,
                local_model.APPLY_SETTING, () => {
                    let data = local_modelIns.applySettingData
                    this.auto = data.auto == 1
                    this.lv = data.role_lv
                    this.lvLb.text = data.role_lv
                    this.fight = data.power
                    this.fightLb.text = data.power
                    SetAuto(this.auto)
                }
            )
            local_modelIns.Fire(local_model.REQUEST_PROTO, 18622)
        }
    }

    public DeleteMe(): void {
        super.DeleteMe()
    }


bg:Laya.Image
closeBtn:Laya.Image
lvBtn:Laya.Image
fightBtn:Laya.Image
_Label1:Laya.Label
_Label2:Laya.Label
_Label3:Laya.Label
lvLb:Laya.Label
fightLb:Laya.Label
autoBtn:Laya.Box
_Image3:Laya.Image
autoImg:Laya.Image
cancelBtn:Laya.Box
_Image111:Laya.Image
labelDisplay:Laya.Label
saveBtn:Laya.Box
_Image11:Laya.Image
labelDisplay1:Laya.Label
_Image2_title:Laya.Image
_lb_win_name:Laya.Label
public GetComponents() {
[
this.bg,
this.closeBtn,
this.lvBtn,
this.fightBtn,
this._Label1,
this._Label2,
this._Label3,
this.lvLb,
this.fightLb,
this.autoBtn,
this._Image3,
this.autoImg,
this.cancelBtn,
this._Image111,
this.labelDisplay,
this.saveBtn,
this._Image11,
this.labelDisplay1,
this._Image2_title,
this._lb_win_name,
]
 = this.GetChildrenByNames([

"bg",
"closeBtn",
"lvBtn",
"fightBtn",
"_Label1",
"_Label2",
"_Label3",
"lvLb",
"fightLb",
"autoBtn",
"_Image3",
"autoImg",
"cancelBtn",
"_Image111",
"labelDisplay",
"saveBtn",
"_Image11",
"labelDisplay1",
"_Image2_title",
"_lb_win_name",
])
}
}
 window["ApplySettingView"]= ApplySettingView