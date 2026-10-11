import { BaseView1 } from "../common/BaseView1"
import { EquipmentItem } from "../common/EquipmentItem"
import { EventName } from "../common/EventName"
import { Enum_UILayer } from "../common/LayerManager"
import { OpenFun } from "../common/OpenFun"
import { ResManager } from "../common/ResManager"
import { CustomActivityDefine } from "../commonModel/CustomActivityDefine"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GameResPath } from "../util/GameResPath"
import { TimeUtil } from "../util/TimeUtil"
import { GlobalTimerQuest, SetAnchoredPosition, Util } from "../util/Util"

export class DestinyTurnTableActiveView extends BaseView1 {

    bg: Laya.Image
    _gp_item: Laya.Box
    go: Laya.Box
    count: Laya.Label
    des: Laya.Image
    time_text: Laya.HTMLDivElement
    AutoFunc
    item
    time

    public constructor() {
        super()

        this.base_file = "destinyTurntable"
        this.layout_file = "DestinyTurnTableActiveView"
        this.layer_value = Enum_UILayer.Main
        this.destroy_imm = true
        //this.need_loading_view = false
        let autoTimer_
        let endTime_
        this.load_callback = () => {

            this.RefViewPos()
            this.LoadSuccess()
            this.InitEvent()
            autoTimer_ = GlobalTimerQuest.AddPeriodQuest(this.AutoFunc, 1)
            endTime_ = TimeUtil.getServerTime() + 10
            this.time_text.style.color = "#FFFFFF"
            this.time_text.style.align = "center"
            this.time_text.style.fontSize = 20
            this.time_text.style.wordWrap = false
            this.AutoFunc()
        }

        this.open_callback = () => {
            // this.time = setTimeout(() => {
            //     //GlobalEventSystem.Fire(EventName.CLOSE_VIEW, "DestinyTurnTableActiveView")
            // }, 10000);
        }
        this.close_callback = () => {
            if (this.item) {
                this.item.DeleteMe()
                this.item = null
            }
            if (this.time) {
                clearTimeout(this.time)
                this.time = null
            }
            if (autoTimer_) {
                GlobalTimerQuest.CancelQuest(this.AutoFunc)
                autoTimer_ = null
            }
        }
        this.AutoFunc = () => {
            if (this.use_delete_method) {
                return
            }
            this.time_text.innerHTML = Util.StrToHTML(`<font color='#FFFF00'>${endTime_ - TimeUtil.getServerTime()}</font>秒后自动关闭`)
            let a = <Laya.HBox>this.time_text.parent
            if (a)
                a.refresh()
            if (endTime_ - TimeUtil.getServerTime() <= 0) {
                if (this.time_text) {
                    this.time_text.innerHTML = ``
                }
                if (autoTimer_) {
                    GlobalTimerQuest.CancelQuest(this.AutoFunc)
                    autoTimer_ = null
                }
                GlobalEventSystem.Fire(EventName.CLOSE_VIEW, "DestinyTurnTableActiveView")

            }
        }
    }

    public RefViewPos() {
        if (Laya.stage.height > 1280) {
            SetAnchoredPosition(this.display_obj, 0, 650)
        } else {
            SetAnchoredPosition(this.display_obj, 0, 450)
        }

    }

    public InitEvent() {

        Util.AddClickEvent(this.go, () => {
            OpenFun.OpenFunHandler(229)
            GlobalEventSystem.Fire(EventName.CLOSE_VIEW, "DestinyTurnTableActiveView")
        }, true)
    }


    public LoadSuccess() {
        ResManager.GetInstance().SetOutsideImageSprite(this, this.bg, GameResPath.GetIconOtherPath("destinyTurntable", "tianming2"), true)
        let info = CustomActivityModel.GetInstance().GetDesTinyInfo()
        if (!info) return
        let need = info.need_count >= 0 ? info.need_count : 0
        let source = need > 0 ? "tianming1" : "tianming5"
        this.count.visible = need > 0
        this.count.text = String(need)
        let goods_vo = info.goods_vo
        if (!this.item) {
            this.item = new EquipmentItem(this._gp_item)
            this.item.Load()
            this.item.SetItemSize(85, 85)
        }
        this.item.ExcuteCallback(() => {
            this.item.SetData(goods_vo[0][1], goods_vo[0][2], 0)
        }
        )
        ResManager.GetInstance().SetImageSprite(this, this.des, "destinyTurntable", source, true)
    }






    public GetComponents() {
        [
            this.bg,
            this._gp_item,
            this.go,
            this.count,
            this.des,
            this.time_text
        ]
            = this.GetChildrenByNames([

                "bg",
                "_gp_item",
                "go",
                "count",
                "des",
                "time_text"
            ])
    }
}
window["DestinyTurnTableActiveView"] = DestinyTurnTableActiveView