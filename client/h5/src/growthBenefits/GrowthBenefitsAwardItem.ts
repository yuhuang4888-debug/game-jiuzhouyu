import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { GoodsModel } from "../commonModel/GoodsModel"
import { ColorUtil } from "../util/ColorUtil";

export class GrowthBenefitsAwardItem extends BaseItemRenderer {
    _item


    WIDTH = 78;
    HEIGT = 78;

    public constructor() {
        super();
        this._item = null;
        this.base_file = "growthBenefits";
        this.layout_file = "GrowthBenefitsAwardItem";

        this.load_callback = () => {
            this.LoadSuccess();
        }
        this.Load();

    }

    private LoadSuccess() {
        if (!this._item) {
            this._item = new BaseAwardItem(this.iconBox);
            this._item.Load();
            this._item.SetItemSize(78, 78);
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
                this._item = new BaseAwardItem(this.iconBox);
            }
            this._item.Load();
            this._item.SetItemSize(78, 78);
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

                "iconBox"
            ])
    }
}
window["GrowthBenefitsAwardItem"] = GrowthBenefitsAwardItem