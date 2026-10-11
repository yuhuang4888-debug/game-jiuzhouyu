import { BaseItem1 } from "../common/BaseItem1"
import { Config } from "../common/Config"
import { Util, SetLocalScale } from "../util/Util"
import { ResManager } from "../common/ResManager"
import { DragonBallModel } from "../commonModel/DragonBallModel"
import { EffectResType } from "../scene/SceneConfig"

export class PlayerMessageDragonBallItem extends BaseItem1 {
    need_refresh_info
    need_refresh_data
    need_refresh_zorder
    alpha_cache


    info
    data
    index
    res_mgr: ResManager

    move_stage
    has_set_effect
    public constructor(parent?) {
        super(parent)

        this.base_file = "playerMessage"
        this.layout_file = "PlayerMessageDragonBallItem"

        this.res_mgr = ResManager.GetInstance()

        this.load_callback = () => {
            this.InitEvent()
            if (this.need_refresh_info) {
                this.UpdateInfo()
                this.need_refresh_info = undefined
            }

            if (this.need_refresh_data) {
                this.UpdateData()
                this.need_refresh_data = undefined
            }

            if (this.need_refresh_zorder) {
                this.UpdateZOrder()
                this.need_refresh_zorder = undefined
            }

            if (this.alpha_cache) {
                this.SetAlpha(this.alpha_cache);
                this.alpha_cache = undefined
            }
        }
    }


    public UpdateInfo() {
        let info = this.info
        this.res_mgr.SetImageSprite(this, this._img_icon, "playerMessage", info.res, true)
    }

    public UpdateData() {
        let data = this.data
        if (!data || data.level == 0) {
            this._img_lock.visible = true
            this._img_icon.gray = true
            this._box_effect.visible = false
        }
        else {
            this._img_lock.visible = false
            this._img_icon.gray = false
            this._box_effect.visible = true
            if (!this.has_set_effect) {
                this.has_set_effect = true
                this.AddUIEffect("ui_xinghe_1", this._box_effect, { x: 0.3, y: -3.3 }, 3.5, null, null, null, null, null, null, null, null, true, EffectResType.XingHe)
            }
        }
    }

    public InitEvent() {

    }

    public SetInfo(info, index) {
        this.info = info
        this.index = index
        if (this.is_loaded) {
            this.UpdateInfo()
        }
        else {
            this.need_refresh_info = true
        }
    }

    public SetData(data) {
        this.data = data
        if (this.is_loaded) {
            this.UpdateData()
        }
        else {
            this.need_refresh_data = true
        }
    }

    SetAlpha(alpha?) {
        if (this.is_loaded) {
            this.display_obj.alpha = alpha;
        } else {
            this.alpha_cache = alpha;
        }
    }

    public SetMoveStage(stage) {
        this.move_stage = stage
        if (this.is_loaded) {
            this.UpdateZOrder()
        } else {
            this.need_refresh_zorder = true
        }

    }
    public UpdateZOrder() {
        let move_state = this.GetMoveStage()
        if (move_state >= 2 && move_state <= 4) {
            this.display_obj.zOrder = 0
        }
        else {
            this.display_obj.zOrder = 2
        }
    }

    public GetMoveStage() {
        return this.move_stage
    }

    public DeleteMe() {
        this.has_set_effect = this.need_refresh_data = this.need_refresh_info = this.need_refresh_zorder = undefined
        super.DeleteMe()
    }

    _img_icon: Laya.Image
    _box_effect: Laya.Box
    _img_lock: Laya.Image
    public GetComponents() {
        [
            this._img_icon,
            this._box_effect,
            this._img_lock,
        ]
            = this.GetChildrenByNames([

                "_img_icon",
                "_box_effect",
                "_img_lock",
            ])
    }
}
window["PlayerMessageDragonBallItem"] = PlayerMessageDragonBallItem