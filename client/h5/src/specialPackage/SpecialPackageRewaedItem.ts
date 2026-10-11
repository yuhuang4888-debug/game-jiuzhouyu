import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { GoodsModel } from "../commonModel/GoodsModel"

export class SpecialPackageRewaedItem extends BaseItemRenderer {
    _item


    WIDTH = 85;
    HEIGT = 85;

    public constructor() {
        super();
        this._item = null;
        this.base_file = "specialPackage";
        this.layout_file = "SpecialPackageRewaedItem";

        this.load_callback = () => {

            this.LoadSuccess();
        }
        this.Load();

    }

    private LoadSuccess() {
        if (!this._item) {
            this._item = new BaseAwardItem(this._gp_item);
            this._item.Load();
            this._item.SetItemSize(85, 85);
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
            let reward = this.data;
            if (!this._item) {
                this._item = new BaseAwardItem(this._gp_item);
            }
            this._item.Load();
            this._item.SetItemSize(85, 85);
            let [type_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(reward[0], reward[1]);
            let goods_vo = GoodsModel.GetInstance().GetGoodsBasicByTypeId(type_id)
            if (goods_vo) {
                let num = (reward[2] == 1 && (null) || (reward[2]));
                this._item.SetData(goods_vo.type_id, num, lock);
            }
        }
    }


    _gp_item: Laya.Box
    public GetComponents() {
        [
            this._gp_item,
        ]
            = this.GetChildrenByNames([
                "_gp_item",
            ])
    }
}
window["SpecialPackageRewaedItem"] = SpecialPackageRewaedItem