
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { ResManager } from "../common/ResManager"

export class LungRadionButton extends BaseItemRenderer {
    public WIDTH = 102
    public HEIGT = 45

    public static width = 102
    public static height = 50
    public constructor() {
        super()
        this.base_file = "lung"
        this.layout_file = "LungRadionButton"
        this.Load()
    }

    public load_callback() {

    }

    public dataChanged() {
        if (super.dataChanged()) {
            let name = String(this.data.name)
            this.labelDisplay.text = name
            this._Image1.visible = !this.selected
            this._Image2.visible = this.selected
            // if (this.selected) {
            //     ResManager.GetInstance().SetImageSprite(this, this._Image1, "common_asset", "com_ui_gx1")
            // } else {
            //     ResManager.GetInstance().SetImageSprite(this, this._Image1, "common_asset", "com_ui_gx")
            // }
        }

    }

    
    _Group1: Laya.Box
    _Image1: Laya.Image
    _Image2: Laya.Image
    labelDisplay: Laya.Label
    public GetComponents() {
        [
            this._Group1,
            this._Image1,
            this._Image2,
            this.labelDisplay,
        ]
            = this.GetChildrenByNames([

                "_Group1",
                "_Image1",
                "_Image2",
                "labelDisplay",
            ])
    }
}
window["LungRadionButton"] = LungRadionButton