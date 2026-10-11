import { BaseAwardItem } from "../common/BaseAwardItem";
import { BaseItemRenderer } from "../common/BaseItemRenderer";

export class EquipTreaseRewardItem extends BaseItemRenderer {
    private _gp_item
    private _item
    public constructor() {
        super();
        this.base_file = "runeTreasure"
        this.layout_file = "EquipTreaseRewardItem"
        this.Load()
    }

    public WIDTH = 90
    public HEIGT = 90

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
                self._item = new BaseAwardItem(self._gp_item);
                self._item.Load();
                self._item.SetItemSize(90, 90)
            }
            self._item.SetData(reward[0], reward[1]);
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

window["EquipTreaseRewardItem"]=EquipTreaseRewardItem