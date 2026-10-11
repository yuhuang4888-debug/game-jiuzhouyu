import { BaseItemRenderer } from "../common/BaseItemRenderer";
import { ResManager } from "../common/ResManager";
import { GoodsModel } from "../commonModel/GoodsModel";
import { RoleManager } from "../commonModel/RoleManager";
import { ColorType, ColorUtil } from "../util/ColorUtil";
import { GameResPath } from "../util/GameResPath";
import { Util } from "../util/Util";

// TypeScript file
export class KfGBRecordItem extends BaseItemRenderer {
    public WIDTH = 610
    public HEIGT = 50  

    public constructor() {
        super()
        this.base_file = "kfGroupBuy"
        this.layout_file = "KfGBRecordItem"
        this.Load()
    }

    public dataChanged() {
        if (super.dataChanged()) {
            let data = this.data
            if (data) {
                let vo = data.reward
                let [type_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(vo[0], vo[1])
                let goods_name = GoodsModel.GetGoodsNameWithColorLight(type_id)
                let is_mask = data.role_name == "蒙面人" && data.role_id == RoleManager.GetInstance().GetMainRoleId()
                let name = is_mask ? "蒙面人(自己)" : `${data.role_name}`
                let str = data.is_buy ? `支付订金,预订了超值商品` : `支付尾款,获得了超值商品`
                this._lb_desc.innerHTML = Util.StrToHTML(`${Util.HtmlColorTxt(`${name}`, ColorUtil.GetColorDark(ColorType.GREEN))}${str}${goods_name}x${vo[2]}`)
                this._lb_desc.y = 10
            }
        }
    }
    img_bg: Laya.Image
    _lb_desc: Laya.HTMLDivElement
    public GetComponents() {
        [
            this.img_bg,
            this._lb_desc,
        ]
        = this.GetChildrenByNames([

            "img_bg",
            "_lb_desc",
        ])
        this._lb_desc.style.fontSize = 20
        this._lb_desc.style.color = "#663915"
        this._lb_desc.style.wordWrap = false
        this._lb_desc.style.bold = true
    }
}
window["KfGBRecordItem"]= KfGBRecordItem