import { BaseView1 } from "../common/BaseView1"
import { EquipmentItem } from "../common/EquipmentItem"
import { EventName } from "../common/EventName"
import { Enum_UILayer } from "../common/LayerManager"
import { OpenFun } from "../common/OpenFun"
import { ResManager } from "../common/ResManager"
import { CustomActivityDefine } from "../commonModel/CustomActivityDefine"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"
import { CycleimpActlistModel } from "../commonModel/CycleimpActlistModel"
import { SuitActivityPanel } from "../suitActivity/SuitActivityPanel"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GameResPath } from "../util/GameResPath"
import { TimeUtil } from "../util/TimeUtil"
import { GlobalTimerQuest, SetAnchoredPosition, Util } from "../util/Util"

export class CycleimpActlistTipsView extends BaseView1 {

    bg: Laya.Image
    img_bg: Laya.Image
    _gp_item: Laya.Box
    img_title: Laya.Image
    go: Laya.Box
    time_gp: Laya.Image
    time_text: Laya.HTMLDivElement
    des: Laya.HTMLDivElement
    AutoFunc
    item
    time
    show_info
    model
    public constructor() {
        super()

        this.base_file = "cycleimpActlist"
        this.layout_file = "CycleimpActlistTipsView"
        this.layer_value = Enum_UILayer.Activity
        this.destroy_imm = true
        //this.need_loading_view = false
        let autoTimer_
        let endTime_
        this.model = CycleimpActlistModel.GetInstance()
        this.load_callback = () => {
            this.display_obj.zOrder = 4
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
                this.Close()

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
            // if (this.model.type == 1) {
            //     OpenFun.OpenFunHandler(2)
            // } else if (this.model.type == 2) {
            //     OpenFun.OpenFunHandler(15)
            // } else if (this.model.type == 3) {
            //     OpenFun.OpenFunHandler(3)
            // } else if (this.model.type == 4) {
            //     OpenFun.OpenFunHandler(13)
            // } else if (this.model.type == 5) {
            //     OpenFun.OpenFunHandler(14)
            // } else if (this.model.type == 6) {

            // } else if (this.model.type == 7) {

            // }
            GlobalEventSystem.Fire(EventName.OPEN_ACT_VIEW,"331@110")
            this.Close()
        }, true)
    }


    public LoadSuccess() {
        if (!this.show_info) return
        this.des.width = 153
        if (this.show_info.type == 3) {
            this.des.innerHTML = "冲榜排名已被其他玩家超过"
        } else if (this.show_info.type == 2) {
            this.des.innerHTML = "再提升<font color='#feea65'>" + this.show_info.value + "分</font><br>即可超过" + this.show_info.rank + "名"
        } else if (this.show_info.type == 1) {
            this.des.innerHTML = "提高<font color='#feea65'>" + this.show_info.value + "</font>分可领取目标奖励"
        }
        this.des.x = 153 / 2 - this.des.contextWidth / 2
        this.des.y = 52 / 2 - this.des.contextHeight / 2
        ResManager.GetInstance().SetImageSprite(this, this.img_title, "cycleimpActlist", "ui_1_" + this.model.type)
    }
    public Open(info?) {
        this.show_info = info
        super.Open()
    }

    public GetComponents() {
        [
            this.bg,
            this.img_bg,
            this._gp_item,
            this.img_title,
            this.go,
            this.time_gp,
            this.time_text,
            this.des,
        ]
            = this.GetChildrenByNames([

                "bg",
                "img_bg",
                "_gp_item",
                "img_title",
                "go",
                "time_gp",
                "time_text",
                "des",
            ])
        this.des.style.fontSize = 20
        this.des.style.color = "#ffffff"
        this.des.style.stroke = 2
        this.des.style.strokeColor = "#a51c1c"
        this.des.style.leading = 3
        this.des.style.align = "center"
        this.des.style.valign = "middle"
    }
}
window["CycleimpActlistTipsView"] = CycleimpActlistTipsView