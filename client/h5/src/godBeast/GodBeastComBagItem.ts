import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { EquipmentItem } from "../common/EquipmentItem"
import { UIToolTipMgr } from "../common/UIToolTipMgr"

export class GodBeastComBagItem extends BaseItemRenderer {
    public WIDTH = 83
    public HEIGT = 83

    public item: EquipmentItem
    public constructor() {
        super()
        this.base_file = "godBeast"
        this.layout_file = "GodBeastComBagItem"
        this.Load()
    }

    public load_callback() {
        if (!this.item) {
            this.item = new EquipmentItem(this.itemGp)
            this.item.Load()
            // this.item.SetScale(0.75)
            this.item.SetItemSize(85, 85)
        }
        this.item.SetClickCallBack(() => {
            if (this.data && this.data.type == 39) {
                UIToolTipMgr.GetInstance().AppendGodBeastTips(this.data.type_id, undefined, undefined, this.data, undefined, [4])
            }
        })
    }

    public createChildren() {
        super.createChildren()
    }

    public dataChanged() {
        if (super.dataChanged()) {
            this.item.SetData(this.data.type_id)
            this.item.ExcuteCallback(() => {
                this.item.SetStrengthen(this.data.stren)
            })
        }
    }

    public DeleteMe() {
        if (this.item) {
            this.item.DeleteMe()
            this.item = null
        }
        super.DeleteMe()
    }
    itemGp: Laya.Box
    public GetComponents() {
        [
            this.itemGp,
        ]
            = this.GetChildrenByNames([

                "itemGp",
            ])
    }
}
window["GodBeastComBagItem"] = GodBeastComBagItem