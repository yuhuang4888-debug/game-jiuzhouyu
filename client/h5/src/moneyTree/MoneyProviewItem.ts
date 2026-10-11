import { BaseItemRenderer } from "../common/BaseItemRenderer";
import { EquipmentItem } from "../common/EquipmentItem";
import { GoodsModel } from "../commonModel/GoodsModel";

export class MoneyProviewItem extends BaseItemRenderer {
    private _gp_item
    private _item
    public constructor() {
        super();
        this.base_file = "moneyTree"
        this.layout_file = "MoneyProviewItem"
        this.Load()
    }

    public WIDTH = 87
    public HEIGT = 87

    public DeleteMe() {
        if (this._item)
            this._item.DeleteMe();
        super.DeleteMe();
    }

    public dataChanged() {
        if (super.dataChanged()) {
            let self = this;
            let reward = self.data
            if (!self._item) {
                self._item = new EquipmentItem(self._gp_item);
                self._item.Load();
                self._item.SetItemSize(87,87)
            }
            let [typeID, lock] = GoodsModel.GetInstance().GetMappingTypeId(reward.reward[0].style,reward. reward[0].typeId)
            self._item.SetData(typeID,reward.reward[0].count, lock);
        }
    }
    public GetComponents() {
        [
            this._gp_item,
        ]
            = this.GetChildrenByNames([

                "_gp_item",
            ])
    }
}

window["MoneyProviewItem"]=MoneyProviewItem