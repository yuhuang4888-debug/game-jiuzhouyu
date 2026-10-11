import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { EquipmentItem } from "../common/EquipmentItem"
import { GoodsModel } from "../commonModel/GoodsModel"

export class LungStoveShowItem extends BaseItemRenderer {
    WIDTH = 80
    HEIGT = 80

    anim_time = 0.01
    move_step = 0.5
    item

    public constructor() {
        super()
        this.base_file = "lung"
        this.layout_file = "LungStoveShowItem"
        this.load_callback = () => {
			this.item = new EquipmentItem(this.item_box)
            this.item.Load()
            this.item.SetItemSize(80, 80)
		}
        this.Load()
    }

    public dataChanged() {
        if (super.dataChanged()) {
            let _data: { itemData: number[], isUp: boolean } = this.data;
            if (!_data) return;
            let [type_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(_data.itemData[0], _data.itemData[1])
            this.item.SetVisible(true)
            this.item.SetData(type_id, _data.itemData[2])
            this.item.SetUpMark(_data.isUp);
        }
    }

    public DeleteMe() {
        if(this.item){
            this.item.DeleteMe()
            this.item = null
        }
        super.DeleteMe()
    }

    item_box: Laya.Box
    gp_eff: Laya.Box
    public GetComponents() {
        [
            this.item_box,
            this.gp_eff,
        ]
            = this.GetChildrenByNames([
                "item_box",
                "gp_eff",
            ])
    }
}
window["LungStoveShowItem"] = LungStoveShowItem