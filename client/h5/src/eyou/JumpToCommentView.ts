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
        this.base_file = "eyou"
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

        this.close_callback = () =>{
            PlatformManager.GetInstance().EyouDataPlacement("gamer_true");
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
        //resource/game/eyou/other/ui_eyou_comment_bg.png
        ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg, GameResPath.GetIconOtherPath("eyou", "ui_sdtc_01"))

        this._lb_go.text = "前往"
        this._lb_cancel.text = "稍后"
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