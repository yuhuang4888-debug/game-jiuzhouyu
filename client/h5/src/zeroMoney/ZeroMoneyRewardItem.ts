import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { GoodsModel } from "../commonModel/GoodsModel"

export class ZeroMoneyRewardItem extends BaseItemRenderer {
    _item

    public WIDTH = 85
    public HEIGT = 85
    public constructor(parent) {
        super()

        this.base_file = "zeroMoney"
        this.layout_file = "ZeroMoneyRewardItem"

        this.load_callback = () => {


        }
        this.Load()
    }

    public InitEvent() {



    }

    public dataChanged() {
        if (super.dataChanged()) {
            let data = this.data
            let item = this._item
            if (!item) {
                item = new BaseAwardItem(this.gp)
                item.Load()
            }
            let [type_id, bind] = GoodsModel.GetInstance().GetMappingTypeId(data[0], data[1])
            item.SetData(type_id, data[2])
            this._item = item
            item.SetItemSize(85, 85)
        }
    }

    public DeleteMe() {

        if (this._item) {
            this._item.DeleteMe()
            this._item = null
        }
        super.DeleteMe()
    }




    gp: Laya.Box
    public GetComponents() {
        [
            this.gp,
        ]
            = this.GetChildrenByNames([

                "gp",
            ])
    }
}
window["ZeroMoneyRewardItem"] = ZeroMoneyRewardItem