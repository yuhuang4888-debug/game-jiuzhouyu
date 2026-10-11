import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { MarriageDefine, MarriageEvent, MarriageModel } from "../commonModel/MarriageModel"
import { Util } from "../util/Util"

export class MarriageMatchView extends BaseView1 {
    //eui
    // private _img_bg: eui.Image
    // private _gp_cacel_match: eui.Group
    // private _img_rotation: eui.Image
    // private _lb_count_down: eui.Label
    // private _lb_tips_1: eui.Label
    // private _lb_tips_2: eui.Label

    // Remove
    // LoadSuccess
    // InitEvent
    // InitView
    // CancelCountDown
    // StartCountDown
    // public constructor() {
    //     super()
    //     let local_egret = egret,
    //         time_id_,
    //         time_func_

    //     this.base_file = "topPk"
    //     this.layout_file = "TopPkMatchViewSkin"
    //     this.layer_value = Enum_UILayer.Activity
    //     this.destroy_imm = true
    //     this.use_background = true
    //     this.is_center = true
    //     // this.change_scene_close = true
    //     // this.click_bg_toClose = true

    //     this.load_callback = function () {
    //         this.LoadSuccess()
    //     }
    //     this.close_callback = function () {
    //         this.Remove()
    //     }
    //     this.Remove = () => {
    //         this.CancelCountDown()
    //         if (this._img_rotation)
    //             local_egret.Tween.removeTweens(this._img_rotation)
    //     }

    //     this.LoadSuccess = () => {
    //         ResManager.GetInstance().SetTexture(this, this._img_bg, "resource/game/topPk/texture/uidfjj_024.png")
    //         this._lb_tips_1.text = "正在为你匹配在线异性玩家"
    //         this._lb_tips_2.text = "匹配时间"
    //         this.InitView()
    //         this.InitEvent()
    //     }

    //     this.InitEvent = () => {
    //         Util.AddClickEvent(this._gp_cacel_match, () => {
    //             MarriageModel.GetInstance().Fire(MarriageEvent.REQUEST_PROTO, 17245, "ci", 2, MarriageDefine.DUN_ID)
    //             this.Close()
    //         }, this, true)
    //     }

    //     this.InitView = () => {
    //         let start_time = 0
    //         this.StartCountDown(() => {
    //             this._lb_count_down.text = String(start_time)
    //             start_time++
    //         })

    //         local_egret.Tween.get(this._img_rotation, { loop: true }).to({ rotation: -360 }, 1000).call(() => {
    //             if (this._img_rotation)
    //                 this._img_rotation.rotation = 0
    //         })
    //     }


    //     this.CancelCountDown = () => {
    //         if (time_id_) {
    //             time_id_.stop()
    //             time_id_.removeEventListener(local_egret.TimerEvent.TIMER, time_func_, this)
    //             time_id_ = undefined
    //             time_func_ = undefined
    //         }
    //     }

    //     this.StartCountDown = (func) => {
    //         this.CancelCountDown()
    //         time_func_ = func
    //         time_id_ = new local_egret.Timer(1000, 0)
    //         time_id_.addEventListener(local_egret.TimerEvent.TIMER, func, this)
    //         time_id_.start()
    //         func()
    //     }
    // }

}
window["MarriageMatchView"] = MarriageMatchView