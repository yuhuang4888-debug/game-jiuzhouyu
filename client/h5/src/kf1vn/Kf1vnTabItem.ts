import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { ResManager } from "../common/ResManager"
import { Color } from "../util/Util"

export class Kf1vnTabItem extends BaseItemRenderer {

    public WIDTH = 152
    public HEIGT = 72

    public constructor(parent) {
        super()
        this.base_file = "kf1vn"
        this.layout_file = "Kf1vnTabItem"
        this.load_callback = () => {
        }

        this.Load()
    }

    public dataChanged() {
        if (!super.dataChanged()) return

        let text_color = null
        let line_color = null
        let img_str = null
        if (this.selected) {
            text_color = "#ffffff"
            line_color = "#ad455c"
            img_str = "uilwmb_041"
        } else {
            text_color = "#4f538f"
            line_color = "#c6c3f4"
            img_str = "uilwmb_042"
        }
        this._lb_name.text = this.data.name
        this._lb_name.color = text_color
        this._lb_name.strokeColor = line_color
        ResManager.GetInstance().SetImageSprite(this, this._Image1, "kf1vn", img_str, true)
        this._img_red.visible = this.data.red_state

    }

    _Image1: Laya.Image
    _lb_name: Laya.Label
    _img_red: Laya.Image
    public GetComponents() {
        [
            this._Image1,
            this._lb_name,
            this._img_red,
        ]
            = this.GetChildrenByNames([

                "_Image1",
                "_lb_name",
                "_img_red",
            ])
    }
}
window["Kf1vnTabItem"] = Kf1vnTabItem