import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { GoodsModel } from "../commonModel/GoodsModel"
import { EquipmentItem } from "../common/EquipmentItem"

export class OnHookItem extends BaseItemRenderer {
    WIDTH = 85
    HEIGT = 85

    reward

    public constructor() {
        super()
        this.base_file = "onHook"
        this.layout_file = "OnHookItem"

        this.load_callback = () => {
            if (!this.reward) {
                this.reward = new EquipmentItem(this.item)
                this.reward.Load()
                this.reward.SetItemSize(85, 85)
            }
        }
        this.Load()
    }

    public dataChanged() {
        if (!super.dataChanged()) {
            return
        }
        if (this.data) {
            let [type, lock] = GoodsModel.GetInstance().GetMappingTypeId(this.data.type, this.data.goods_id)
            this.reward.SetData(type, this.data.num)
        }
    }

    public DeleteMe() {
        if (this.reward) {
            this.reward.DeleteMe()
            this.reward = null
        }
        super.DeleteMe()
    }
    bg: Laya.Image
    item: Laya.Box
    public GetComponents() {
        [
            this.bg,
            this.item,
        ]
            = this.GetChildrenByNames([

                "bg",
                "item",
            ])
    }
}
window["OnHookItem"] = OnHookItem