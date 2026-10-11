import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { kfStageModel } from "../commonModel/kfStageModel"
import { Util } from "../util/Util"
import { SYTweenLite } from "../util/SYTweenLite"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { EventName } from "../common/EventName"
import { ServerTimeModel } from "../serverTime/ServerTimeModel"
import { HolyTerritoryModel, HTEvent } from "../commonModel/HolyTerritoryModel"
import { CookieWrapper } from "../common/CookieWrapper"

export class HolyTerritoryOpenView extends BaseView1 {
    res_mgr
    model
    tween_id1
    tween_id2
    anim_time = 0.7

    public constructor() {
        super()
        this.base_file = "holyTerritory"
        this.layout_file = "HolyTerritoryOpenView"
        this.layer_value = Enum_UILayer.Top
        this.destroy_imm = true
        this.use_background = true
        this.is_center = true

        this.res_mgr = ResManager.GetInstance()
        this.model = kfStageModel.GetInstance()

        this.load_callback = () => {
            this.LoadSuccess()
            this.InitEvent()
        }

        this.close_callback = () => {

            this.Remove()
        }
    }

    private LoadSuccess() {
        this.model.Fire(kfStageModel.CLOSE_VIEW)

        this.res_mgr.SetOutsideImageSprite(this, this._img_left, "resource/game/holyTerritory/other/ui_kqkf_tc_004a.jpg")
        this.res_mgr.SetOutsideImageSprite(this, this._img_right, "resource/game/holyTerritory/other/ui_kqkf_tc_004a.jpg")
        this.res_mgr.SetOutsideImageSprite(this, this._img_left2, "resource/game/holyTerritory/other/ui_kqkf_tc_006a.png")
        this.res_mgr.SetOutsideImageSprite(this, this._img_right2, "resource/game/holyTerritory/other/ui_kqkf_tc_006b.png")
        this.res_mgr.SetOutsideImageSprite(this, this._img_center, "resource/game/holyTerritory/other/ui_kqkf_tc_002.png")

        this.display_obj.width = Laya.stage.width
        this.display_obj.height = Laya.stage.height
        this._gp_click.width = Laya.stage.width
        this._gp_click.height = Laya.stage.height
    }

    private InitEvent() {
        Util.AddClickEvent(this._gp_click, () => {
            this._img_center.visible = false
            this._gp_click.visible = false
            this.PlayAnim()
        }, this, true)
    }

    private Remove() {
        if (this.tween_id1) {
            SYTweenLite.Stop(this.tween_id1)
            this.tween_id1 = null
        }
        if (this.tween_id2) {
            SYTweenLite.Stop(this.tween_id2)
            this.tween_id2 = null
        }
    }

    private PlayAnim() {
        this.tween_id1 = SYTweenLite.to(this, this._img_left, SYTweenLite.UiAnimationType.POSX, -180, this.anim_time)
        this.tween_id2 = SYTweenLite.to(this, this._img_right, SYTweenLite.UiAnimationType.POSX, 900, this.anim_time, () => {


            HolyTerritoryModel.GetInstance().Fire(
                HTEvent.OPEN_VIEW,
                'holyTerritoryMainView',
                0
            )
            this.Close()
        })
    }

    _gp_con: Laya.Box
    _img_left: Laya.Image
    _img_left2: Laya.Image
    _img_right: Laya.Image
    _img_right2: Laya.Image
    _img_center: Laya.Image
    _img_tips: Laya.Image
    _gp_click: Laya.Box
    public GetComponents() {
        [
            this._gp_con,
            this._img_left,
            this._img_left2,
            this._img_right,
            this._img_right2,
            this._img_center,
            this._img_tips,
            this._gp_click,
        ]
            = this.GetChildrenByNames([
                "_gp_con",
                "_img_left",
                "_img_left2",
                "_img_right",
                "_img_right2",
                "_img_center",
                "_img_tips",
                "_gp_click",
            ])
    }
}
window["HolyTerritoryOpenView"] = HolyTerritoryOpenView