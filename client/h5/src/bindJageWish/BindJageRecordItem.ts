import { RuneTreasureModel } from "../commonModel/RuneTreasureModel"
import { RoleManager } from "../commonModel/RoleManager"
import { SetHtmlCenter, SetSizeDeltaY, Util } from "../util/Util"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { GoodsModel } from "../commonModel/GoodsModel"

export class BindJageRecordItem extends BaseItemRenderer {
    WIDTH = 540
    HEIGT = 20
    public record_label: Laya.HTMLDivElement
    public constructor() {
        super()
        this.base_file = "bindJageWish"
        this.layout_file = "BindJageRecordItem"
        this.Load()
    }

    public createChildren() {
        super.createChildren()
    }


    public dataChanged() {
        if (super.dataChanged()) {
            if (this.data) {
                // let goods_name = GoodsModel.GetGoodsNameWithColorLight(this.data.reward_list[0].typeId)
                let str = ``
                let is_mark = this.data.role_name == "蒙面人"
                let self_mask = is_mark && RoleManager.GetInstance().GetMainRoleId() == this.data.role_id
                let name = self_mask ? `蒙面人(自己)` : this.data.name
                str = `恭喜<font color='#71f563'>${name}</font>福至心灵，在绑玉祈愿中抽中<font color='#71f563'>绑玉*${this.data.reward_list[0].count}</font>!`
                this.record_label.style.fontSize = 20
                this.record_label.style.color = "#FFFFFF"
                this.record_label.style.wordWrap = false
                this.record_label.style.width = 500
                this.record_label.innerHTML = Util.StrToHTML(str)
            }
        }
    }
    public GetComponents() {
        [
            this.record_label,
        ]
            = this.GetChildrenByNames([
                "record_label",
            ])
    }

    public DeleteMe() {
        super.DeleteMe()
    }
}
window["BindJageRecordItem"] = BindJageRecordItem