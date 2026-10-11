import { BaseView1 } from "../common/BaseView1";
import { EventName } from "../common/EventName";
import { Enum_UILayer } from "../common/LayerManager";
import { ResManager } from "../common/ResManager";
import { MarriageEvent, MarriageModel } from "../commonModel/MarriageModel";
import { GlobalEventSystem } from "../util/DeclareGlobalVar";
import { GameResPath } from "../util/GameResPath";
import { Util } from "../util/Util";

export class MarriageGiftTipsView extends BaseView1 {

    Local_Open
    LoadSuccess
    InitEvent
    UpdateView
    public constructor() {
        super()
        this.base_file = "marriage"
        this.dependent_res = ["marriage2"]
        this.layout_file = "MarriageGiftTipsView"
        this.layer_value = Enum_UILayer.Activity;
        this.is_center = true
        this.use_background = true
        this.click_bg_toClose = true
        this.show_open_movie = true
        this.destroy_imm = true

        let _model = MarriageModel.GetInstance(),
            local_Util = Util,
            _msg_: string

        this.load_callback = function () {
            this.LoadSuccess()
        }

        this.open_callback = function () {
            this.UpdateView()
            _model.Fire(MarriageEvent.UPDATE_PLEASE_STATE, false)
        }
        this.Local_Open = (parms) => {
            [_msg_] = parms
            super.Open()
        }

        this.LoadSuccess = () => {
            ResManager.GetInstance().SetOutsideImageSprite(this, this._Image11, GameResPath.GetIcon("marriage", "uijh_081"))
            ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg, GameResPath.GetIcon("marriage", "uijh_133"))
            this.InitEvent()
        }

        this.InitEvent = () => {
            local_Util.AddClickEvent(this._btn_close, () => {
                this.Close()
            }, this, true)

            local_Util.AddClickEvent(this._btn_cancel, () => {
                this.Close()
            }, this, true)

            local_Util.AddClickEvent(this._btn_go, () => {
                GlobalEventSystem.Fire(EventName.OPEN_VIEW, "MarriageBaseView", 3)
                this.Close()
            }, this, true)

        }

        this.UpdateView = () => {
            this._lb_msg.text = _msg_
        }
    }

    public Open(...parms) {
        this.Local_Open(parms)
    }

    _Image11: Laya.Image
    _img_bg: Laya.Image
    _Image2: Laya.Image
    _Image3: Laya.Image
    _Group1: Laya.HBox
    _btn_cancel: Laya.Box
    _Image1: Laya.Image
    labelDisplay: Laya.Label
    _btn_go: Laya.Box
    _Image111: Laya.Image
    labelDisplay1: Laya.Label
    _lb_msg: Laya.Label
    _btn_close: Laya.Image
    public GetComponents() {
        [
            this._Image11,
            this._img_bg,
            this._Image2,
            this._Image3,
            this._Group1,
            this._btn_cancel,
            this._Image1,
            this.labelDisplay,
            this._btn_go,
            this._Image111,
            this.labelDisplay1,
            this._lb_msg,
            this._btn_close,
        ]
            = this.GetChildrenByNames([

                "_Image11",
                "_img_bg",
                "_Image2",
                "_Image3",
                "_Group1",
                "_btn_cancel",
                "_Image1",
                "labelDisplay",
                "_btn_go",
                "_Image111",
                "labelDisplay1",
                "_lb_msg",
                "_btn_close",
            ])
    }
}
window["MarriageGiftTipsView"] = MarriageGiftTipsView