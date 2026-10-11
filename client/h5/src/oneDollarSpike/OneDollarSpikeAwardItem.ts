import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { GoodsModel } from "../commonModel/GoodsModel"
import { ColorUtil } from "../util/ColorUtil";

export class OneDollarSpikeAwardItem extends BaseItemRenderer {
    _item


    WIDTH = 88;
    HEIGT = 88;

    public constructor() {
        super();
        this._item = null;
        this.base_file = "oneDollarSpike";
        this.layout_file = "OneDollarSpikeAwardItem";

        this.load_callback = () => {

            this.LoadSuccess();


            
        }
        this.Load();

    }

    private LoadSuccess() {
        if (!this._item) {
            this._item = new BaseAwardItem(this.iconBox);
            this._item.Load();
            this._item.SetItemSize(88, 88);
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
            this._item.SetItemSize(88, 88);
            let [type_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(reward[0], reward[1]);
            let goods_vo = GoodsModel.GetInstance().GetGoodsBasicByTypeId(type_id)
            if (goods_vo) {
                let num = (reward[2] == 1 && (null) || (reward[2]));
                this._item.SetData(goods_vo.type_id, num, lock);
                this.iconNameLab.text = goods_vo.goods_name;/*  : GoodsModel.GetGoodsName(type_id); */
                this.iconNameLab.color = ColorUtil.GetColorDark(goods_vo.color, false);
            }
        }
    }


    iconBox: Laya.Box
    iconNameLab: Laya.Label
    public GetComponents() {
        [
            this.iconBox,
            this.iconNameLab,
        ]
            = this.GetChildrenByNames([

                "iconBox",
                "iconNameLab",
            ])
    }
}
window["OneDollarSpikeAwardItem"] = OneDollarSpikeAwardItem