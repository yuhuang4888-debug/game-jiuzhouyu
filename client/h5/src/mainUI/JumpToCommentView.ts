import { BaseView1 } from "../common/BaseView1"
import { EventName } from "../common/EventName"
import { Enum_UILayer, LayerManager } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { PlatformManager } from "../PlatformManager"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"

export class JumpToCommentView extends BaseView1 {

    public constructor() {
        super()
        this.base_file = "mainUI"
        this.layout_file = "JumpToCommentView"
        this.layer_value = Enum_UILayer.Activity
        this.is_center = true
        this.use_background = true
        this.click_bg_toClose = true
        this.change_scene_close = true

        this.load_callback = () => {
            this.LoadSuccess()
            this.InitEvent()
        }
        this.open_callback = () => {

        }

        this.destroy_callback = () => {
            this.Clear()
        }
    }

    public InitEvent() {
        Util.AddClickEvent(this._box_go, () => {
            PlatformManager.GetInstance().JumpToAppStore()
            this.Close()
        }, this, true)

        Util.AddClickEvent(this._box_cancel, () => {
            this.Close()
        }, this, true)

        Util.AddClickEvent(this._img_close, () => {
            this.Close()
        }, this, true)
    }

    public LoadSuccess() {
        //resource/game/mainUI/other/uipfzy_001.png
        ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg, GameResPath.GetIconOtherPath("mainUI", "uipfzy_001"))
        //resource/game/mainUI/other/uipfzy_003.png
        ResManager.GetInstance().SetOutsideImageSprite(this, this._img_detail, GameResPath.GetIconOtherPath("mainUI", "uipfzy_003"))


        if (PlatformManager.IsEyouTwPlatform()) {
            this._lb_go.text = "前往"
            this._lb_cancel.text = "稍後"
        } else if (PlatformManager.IsEyouJpPlatform()) {
            this._lb_go.text = "はい"
            this._lb_cancel.text = "いいえ"
        } else if (PlatformManager.IsEyouThPlatform()) {
            this._lb_go.text = "ไปคอมเม้นท์"
            this._lb_cancel.text = "ปฎิเสธ"
        } else {
            this._lb_go.text = "Go Now"
            this._lb_cancel.text = "Not Now"
        }
    }

    public Clear() {

    }

    public Open(...new_args) {
        super.Open()
    }
    _img_bg: Laya.Image
    _img_detail: Laya.Image
    _img_close: Laya.Image
    _box_go: Laya.Box
    _lb_go: Laya.Label
    _box_cancel: Laya.Box
    _lb_cancel: Laya.Label
    public GetComponents() {
        [
            this._img_bg,
            this._img_detail,
            this._img_close,
            this._box_go,
            this._lb_go,
            this._box_cancel,
            this._lb_cancel,
        ]
            = this.GetChildrenByNames([

                "_img_bg",
                "_img_detail",
                "_img_close",
                "_box_go",
                "_lb_go",
                "_box_cancel",
                "_lb_cancel",
            ])
    }
}
window["JumpToCommentView"] = JumpToCommentView