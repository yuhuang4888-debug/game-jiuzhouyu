import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { GoodsModel } from "../commonModel/GoodsModel"
import { EquipmentItem } from "./EquipmentItem";

export class ItemInfoItem extends BaseItemRenderer {
    _item: EquipmentItem;


    WIDTH = 87;
    HEIGT = 87;

    public constructor() {
        super();
        this._item = null;
        this.base_file = "common";
        this.layout_file = "ItemInfoItem";

        this.load_callback = () => {

            this.LoadSuccess();
        }
        this.Load();

    }

    private LoadSuccess() {
        if (!this._item) {
            this._item = new EquipmentItem(this.iconBox);
            this._item.Load();
            this._item.SetItemSize(87, 87);
        }

    }


    public DeleteMe() {
        if (this._item) {
            this._item.DeleteMe();
            this._item = null;
        }
        super.DeleteMe();
    }



    public dataChanged() {
        if (super.dataChanged()) {
            let reward = typeof this.data[0] == 'object' ? this.data[0] : this.data;
            if (!this._item) {
                this._item = new EquipmentItem(this.iconBox);
            }
            this._item.Load();
            this._item.SetItemSize(87, 87);
            let [type_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(reward[0], reward[1]);
            let goods_vo = GoodsModel.GetInstance().GetGoodsBasicByTypeId(type_id)
            if (goods_vo) {
                let num = (reward[2] == 1 && (null) || (reward[2]));
                this._item.SetData(goods_vo.type_id, num, lock);
            }
        }
    }



    iconBox: Laya.Box
    public GetComponents() {
        [
            this.iconBox,
        ]
            = this.GetChildrenByNames([

                "iconBox",
            ])
    }
}
window["ItemInfoItem"] = ItemInfoItem