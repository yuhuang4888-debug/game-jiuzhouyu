import { BaseItemRenderer } from "../common/BaseItemRenderer";
import { ResManager } from "../common/ResManager";
import { GameResPath } from "../util/GameResPath";
import { RefBoxChildsLayout } from "../util/Util";

export class KfGBDiscountItem extends BaseItemRenderer {

    public WIDTH = 800
    public HEIGT = 38
    
    public constructor() {
        super()
        this.base_file = "kfGroupBuy"
        this.layout_file = "KfGBDiscountItem"
        this.Load()
    }

    public load_callback() {
        ResManager.GetInstance().SetOutsideImageSprite(this, this._img_num, GameResPath.GetIconOtherPath("kfGroupBuy", "ui_kftg_05"), false)
        ResManager.GetInstance().SetOutsideImageSprite(this, this._Image1, GameResPath.GetIconOtherPath("kfGroupBuy", "ui_kftg_04"), false)
        ResManager.GetInstance().SetOutsideImageSprite(this, this._img_effect, GameResPath.GetIconOtherPath("kfGroupBuy", "ui_kftg_06"), false)
    }

    public dataChanged() {
        if (super.dataChanged()) {
            let data = this.data
            if (data) {
                let str = data[0] == 0 ? `初始价` : `${data[0]}件`
                this._lb_num.text = str
                this._lb_price.text = `${data[1]}`
                // this.ClearUIEffect(this._gp_effect)
                let disc = Math.floor(data[1] / data[4] * 100) / 10
                this._lb_discount.text = `${disc}折`
                let width = this.index * 40
                this._img_num.width = 98 + width
                let bool = data[1] == data[3]
                this._img_effect.visible = bool
                this._img_effect.width = this._img_num.width + 15
                this._gp_discount.width = this._img_num.width
                if (bool) {
                    // this.AddUIEffect(`ui_kuafutuangou_1`, this._gp_effect, null, { x: this._img_num.width / 360, y: 1 },true)
                }
                RefBoxChildsLayout(this._Group3, 0, null, true, "left")
            }
        }
    }

    _lb_num:Laya.Label
    _Group3:Laya.Box
    _gp_discount:Laya.Box
    _img_num:Laya.Image
    _gp_effect:Laya.Box
    _img_effect:Laya.Image
    _lb_discount:Laya.Label
    _Group2:Laya.Box
    _Image1:Laya.Image
    _Group1:Laya.HBox
    _lb_price:Laya.Label
    _img_jin:Laya.Image
    public GetComponents() {
        [
            this._lb_num,
            this._Group3,
            this._gp_discount,
            this._img_num,
            this._gp_effect,
            this._img_effect,
            this._lb_discount,
            this._Group2,
            this._Image1,
            this._Group1,
            this._lb_price,
            this._img_jin,
        ]
        = this.GetChildrenByNames([
            "_lb_num",
            "_Group3",
            "_gp_discount",
            "_img_num",
            "_gp_effect",
            "_img_effect",
            "_lb_discount",
            "_Group2",
            "_Image1",
            "_Group1",
            "_lb_price",
            "_img_jin",
        ])
    }
}
 window["KfGBDiscountItem"]= KfGBDiscountItem