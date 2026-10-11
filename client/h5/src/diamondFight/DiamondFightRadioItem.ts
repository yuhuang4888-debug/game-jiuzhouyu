import { BaseItem1 } from "../common/BaseItem1"
import { DiamondFightModel } from "../commonModel/DiamondFightModel"
import { Util } from "../util/Util"

export class DiamondFightRadioItem extends BaseItem1 {

    cache_select_state
    data
    func
    index
    model: DiamondFightModel
    need_refresh_data

    public constructor(parent) {
        super(parent)

        this.base_file = "diamondFight"
        this.layout_file = "DiamondFightRadioItem"
        this.model = DiamondFightModel.GetInstance()
        this.load_callback = () => {
            this.LoadSuccess()
        }
    }

    public LoadSuccess() {

        Util.AddClickEvent(this._box_con, () => {
            if (this.func) {
                this.func(this.index)
            }
        }, this)

        if (this.need_refresh_data) {
            this.need_refresh_data = false
            this.UpdateItem()
        }

        if (this.cache_select_state != null) {
            this.SetSelect(this.cache_select_state)
            this.cache_select_state = null
        }
    }

    public SetData(data?, index?, func?) {

        this.data = data
        this.index = index
        this.func = func
        if (this.is_loaded) {
            this.UpdateItem()
        } else {
            this.need_refresh_data = true
        }
    }

    public UpdateItem() {

        let data = this.data
        this._lb_value.text = data.input
    }

    public SetSelect(bool?) {

        if (this.is_loaded) {
            this._img_bg2.visible = bool
        } else {
            this.cache_select_state = bool
        }
    }

    _box_con: Laya.Box
    _img_bg: Laya.Image
    _img_bg2: Laya.Image
    _img_icon: Laya.Image
    _lb_value: Laya.Label
    public GetComponents() {
        [
            this._box_con,
            this._img_bg,
            this._img_bg2,
            this._img_icon,
            this._lb_value,
        ]
            = this.GetChildrenByNames([

                "_box_con",
                "_img_bg",
                "_img_bg2",
                "_img_icon",
                "_lb_value",
            ])
    }
}
window["DiamondFightRadioItem"] = DiamondFightRadioItem
